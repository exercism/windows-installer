unit uClientDownloadFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  uTypes, IPPeerClient, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, System.Types, System.Net.HttpClient, System.UITypes,
  Vcl.Imaging.pngimage;

type
  Tos = class
    class function Is32BitWindows: Boolean;
  end;

  IDownloadURL = interface(IInvokable)
  ['{049FAAD1-D024-4E96-B7B5-96674D6F56AF}']
    function GetUrl: string;
    function GetDownloadSize: Int64;
    property Url: string read GetUrl;
    property DownloadSize: Int64 read GetDownloadsize;
  end;

  TfrmDownload = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    btnCancel: TButton;
    btnNext: TButton;
    mStatus: TMemo;
    ProgressBarDownload: TProgressBar;
    tmrDownload: TTimer;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    tmrInstall: TTimer;
    Image1: TImage;
    btnStopDownload: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrDownloadTimer(Sender: TObject);
    procedure ReceiveDataEvent(const Sender: TObject; AContentLength: Int64; AReadCount: Int64; var Abort: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure tmrInstallTimer(Sender: TObject);
    procedure btnStopDownloadClick(Sender: TObject);
  private
    { Private declarations }
    InstallInfo : TInstallInfo;
    FClient: THTTPClient;
    FGlobalStart: Cardinal;
    FAsyncResponse: IAsyncResult;
    FDownloadStream: TStream;
    FHTTPResponse: IHTTPResponse;
    procedure DoEndDownload(const AsyncResult: IAsyncResult);
    function DetermineArchitecture(var aStatus: TResultStatus): Boolean;
    function FetchDownloadURL(const aIs32BitWindows: Boolean; var aStatus: TResultStatus): IDownloadURL;
    procedure Download_CLI_ZIP(aDownloadURL: IDownloadURL; var aStatus: TResultStatus);
    procedure Unzip_CLI(var aStatus: TResultStatus);
    procedure Update_PATH(var aStatus: TResultStatus);
  public
    { Public declarations }
    NextClicked: Boolean;
  end;

  function ShowClientDownloadForm(const aInstallInfo: TInstallInfo): TResultStatus;
  function NewDownloadURL(a32Bit: boolean; aRESTRequest: TRESTRequest; aFDMemTable: TFDMemTable): IDownloadURL;

implementation
uses System.IOUtils, System.Zip, uUpdatePath;
{$R *.dfm}
type
  TDownloadURL = class(TInterfacedObject, IDownloadURL)
  private
    FUrl: string;
    FDownloadSize: Int64;
    function GetUrl: string;
    function GetDownloadSize: Int64;
  public
    constructor create(a32Bit: boolean; aRESTRequest: TRESTRequest; aFDMemTable: TFDMemTable);
    property Url: string read GetUrl;
    property DownloadSize: Int64 read GetDownloadsize;
  end;

function NewDownloadURL(a32Bit: boolean; aRESTRequest: TRESTRequest; aFDMemTable: TFDMemTable): IDownloadURL;
begin
  result := TDownloadURL.create(a32Bit, aRESTRequest, aFDMemTable);
end;

class function Tos.Is32BitWindows: Boolean;
begin
  result := TOSVersion.Architecture = arIntelX86;
end;

function ShowClientDownloadForm(const aInstallInfo: TInstallInfo): TResultStatus;
begin
  result := rsCancel;
  with TfrmDownload.Create(nil) do
    try
      InstallInfo := aInstallInfo;
      ShowModal;
      if NextClicked then
        result := rsNext;
    finally
      DisposeOf;
    end;
end;

procedure TfrmDownload.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmDownload.btnNextClick(Sender: TObject);
begin
  NextClicked := true;
  Close;
end;

procedure TfrmDownload.btnStopDownloadClick(Sender: TObject);
begin
  btnStopDownload.Enabled := false
end;

procedure TfrmDownload.FormCreate(Sender: TObject);
begin
  FClient := THTTPClient.Create;
  FClient.OnReceiveData := ReceiveDataEvent;
  NextClicked := false;
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
end;

procedure TfrmDownload.FormDestroy(Sender: TObject);
begin
  FClient.Free;
  FDownloadStream.Free;
  FAsyncResponse := nil;
end;

function TfrmDownload.DetermineArchitecture(var aStatus: TResultStatus): Boolean;
begin
  aStatus := rsCancel;
  result := Tos.Is32BitWindows;
  if result then
    mStatus.Lines.Add('32 Bit Windows Detected')
  else
    mStatus.Lines.Add('64 Bit Windows Detected');
  aStatus := rsNext;
end;

function TfrmDownload.FetchDownloadURL(const aIs32BitWindows: Boolean; var aStatus: TResultStatus): IDownloadURL;
begin
  aStatus := rsCancel;
  mStatus.Lines.Add('Fetching URL for latest CLI version.');
  result := NewDownloadURL(aIs32BitWindows, RESTRequest1, FDMemTable1);
  if result.Url <> '' then
  begin
    mStatus.Lines.Add('Successfully retrieved URL');
    aStatus := rsNext;
  end
  else
  begin
    result := nil;
    mStatus.Lines.Add('Failed to retrieve URL');
    if MessageDlg('Unable to retrieve URL.  Confirm internet connection then Retry or Cancel.',
                   mtError, [mbRetry, mbCancel], 0) = mrRetry then
    begin
      aStatus := rsRepeat;
      mStatus.Lines.Add('');
    end;
  end;
end;

procedure TfrmDownload.Download_CLI_ZIP(aDownloadURL: IDownloadURL; var aStatus: TResultStatus);
var
  lFilename: string;
  URL: string;
  LSize: Int64;
begin
  aStatus := rsCancel;
  LFileName := TPath.Combine(InstallInfo.Path, 'exercism.zip');
  try
    FAsyncResponse := nil;
    URL := aDownloadURL.Url;

    LSize := aDownloadURL.DownloadSize;

    ProgressBarDownload.Max := LSize;
    ProgressBarDownload.Min := 0;
    ProgressBarDownload.Position := 0;

    mStatus.Lines.Add(Format('Downloading: "%s" (%d Bytes) into "%s"' , ['exercism.zip', LSize, LFileName]));

    // Create the file that is going to be dowloaded
    FDownloadStream := TFileStream.Create(LFileName, fmCreate);
    FDownloadStream.Position := 0;

    FGlobalStart := TThread.GetTickCount;

    // Start the download process
    FAsyncResponse := FClient.BeginGet(DoEndDownload, URL, FDownloadStream);
    aStatus := rsFinished;
  finally
    FAsyncResponse := nil;
  end;
end;

procedure TfrmDownload.Unzip_CLI(var aStatus: TResultStatus);
var
//  UnZipper: TZipFile;
  lFilename: string;
begin
  aStatus := rsCancel;
  mStatus.Lines.Add(format('Unzipping CLI to %s',[InstallInfo.Path]));
//  UnZipper := TZipFile.Create;
  try
    lFilename := TPath.Combine(InstallInfo.Path,'exercism.zip');
//    UnZipper.Open(lFilename, zmRead);
//    Unzipper.ExtractAll(TPath.Combine(InstallInfo.Path,''));
    TZipFile.ExtractZipFile(lFilename, TPath.Combine(InstallInfo.Path,''));
    aStatus := rsNext;
    mStatus.Lines.Add('CLI Extraction Successful');
  finally
//    Unzipper.DisposeOf;
    if FileExists(lFilename) then
      DeleteFile(lFilename);
  end;
end;

procedure TfrmDownload.Update_PATH(var aStatus: TResultStatus);
begin
  aStatus := rsCancel;
  if TUpdatePath.AddToPath(InstallInfo.Path) then
  begin
    mStatus.Lines.Add(format('Folder "%s" added to Path.',[InstallInfo.Path]));
    aStatus := rsFinished;
  end
  else
    mStatus.Lines.Add(format('Folder "%s" NOT added to Path.',[InstallInfo.Path]));
end;

procedure TfrmDownload.tmrDownloadTimer(Sender: TObject);
var
  lIs32BitWindows: boolean;
  i: integer;
  lLoopStatus,
  lStatus: TResultStatus;
  lDownloadURL: IDownloadURL;
begin
  tmrDownload.Enabled := false;
  i := 0;
  lLoopStatus := rsContinue;
  lIs32BitWindows := false;
  repeat
    case i of
      0: lIs32BitWindows := DetermineArchitecture(lStatus);
      1: lDownloadURL := FetchDownloadURL(lIs32BitWindows, lStatus);
      2: Download_CLI_ZIP(lDownloadURL, lStatus);
    end;//case

    case lStatus of
      rsNext: inc(i);
      rsCancel,
      rsFinished: lLoopStatus := rsDone;
    end;//cased
  until lLoopStatus = rsDone;
end;

procedure TfrmDownload.tmrInstallTimer(Sender: TObject);
var
  i: integer;
  lLoopStatus,
  lStatus: TResultStatus;
begin
  tmrInstall.Enabled := false;
  i := 0;
  lLoopStatus := rsContinue;
  lStatus := rsCancel;
  repeat
    case i of
      0: Unzip_CLI(lStatus);
      1: Update_PATH(lStatus);
    end;//case

    case lStatus of
      rsNext: inc(i);
      rsCancel,
      rsFinished: lLoopStatus := rsDone;
    end;//cased
  until lLoopStatus = rsDone;
  btnNext.Enabled := lStatus = rsFinished;
  if btnNext.Enabled then
  begin
    mStatus.Lines.Add('');
    mStatus.Lines.Add('Click [Next] to configure the CLI');
    ActiveControl := btnNext;
  end
end;

procedure TfrmDownload.ReceiveDataEvent(const Sender: TObject; AContentLength, AReadCount: Int64;
  var Abort: Boolean);
var
  lCancel: Boolean;
begin
  lCancel := Abort;
  TThread.Queue(nil,
    procedure
    begin
      lCancel := not btnStopDownload.Enabled;
      ProgressBarDownload.Position := AReadCount;
    end);
  Abort := lCancel;
end;

procedure TfrmDownload.DoEndDownload(const AsyncResult: IAsyncResult);
begin
  try
    FHTTPResponse := THTTPClient.EndAsyncHTTP(AsyncResult);
    TThread.Synchronize(nil,
      procedure
      begin
        mStatus.Lines.Add('Download Finished!');
        mStatus.Lines.Add(Format('Status: %d - %s', [FHTTPResponse.StatusCode, FHTTPResponse.StatusText]));
      end);
  finally
    FDownloadStream.Free;
    FDownloadStream := nil;
    btnCancel.Enabled := true;
    tmrInstall.Enabled := btnStopDownload.Enabled;
    btnStopDownload.Enabled := false;
  end;
end;

{ TDownloadURL }

constructor TDownloadURL.create(a32Bit: boolean; aRESTRequest: TRESTRequest;
  aFDMemTable: TFDMemTable);
var
  IsFound: boolean;
  nameField: TField;
  downloadSize,
  browser_download_urlField: TField;
  lTarget: string;
begin
  FUrl := '';
  if a32Bit then
    lTarget := 'windows-32bit'
  else
    lTarget := 'windows-64bit';
  aRESTRequest.Execute;
  if aFDMemTable.FindFirst then
  begin
    IsFound := false;
    repeat
      nameField := aFDMemTable.FindField('name');
      if assigned(nameField) then
      begin
        if nameField.DisplayText.ToLower.Contains(lTarget) then
        begin
          downloadSize := aFDMemTable.FindField('size');
          browser_download_urlField := aFDMemTable.FindField('browser_download_url');
          if assigned(browser_download_urlField) then
          begin
            FUrl := browser_download_urlField.DisplayText;
            IsFound := true;
            if assigned(downloadSize) then
              FDownloadSize := downloadSize.AsInteger;
          end;
        end;
      end;
    until IsFound or not aFDMemtable.FindNext;
  end;
end;

function TDownloadURL.GetDownloadSize: Int64;
begin
  result := FDownloadSize;
end;

function TDownloadURL.GetUrl: string;
begin
  result := FUrl;
end;

end.
