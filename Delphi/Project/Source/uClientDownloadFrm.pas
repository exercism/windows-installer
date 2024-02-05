{_define V3Test}
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
  Vcl.Imaging.pngimage, REST.Types;

type
  Tos = class
    class function Is32BitWindows: Boolean;
  end;

  IAssetsURL = interface(IInvokable)
  ['{49E2CFFF-32DB-4CF7-9C63-674206B52BBA}']
    function GetAssetsURL: string;
    property assets_url: string read GetAssetsURL;
  end;

  IDownloadURL = interface(IInvokable)
  ['{049FAAD1-D024-4E96-B7B5-96674D6F56AF}']
    function GetUrl: string;
    function GetDownloadSize: Int64;
    property Url: string read GetUrl;
    property DownloadSize: Int64 read GetDownloadsize;
  end;

  IDownloadVer = interface(IInvokable)
  ['{40673B5E-DBD8-4F14-ABC6-3851E720DC4D}']
    function GetMajorVersion: integer;
    function GetTagName: string;
    property MajorVersion: integer read GetMajorVersion;
    property Tag_Name: string read GetTagName;
  end;

  TfrmDownload = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    btnCancel: TButton;
    mStatus: TMemo;
    ProgressBarDownload: TProgressBar;
    tmrDownload: TTimer;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    tmrInstall: TTimer;
    btnStopDownload: TButton;
    Label4: TLabel;
    btnFinish: TButton;
    Root: TRESTResponseDataSetAdapter;
    tableRoot: TFDMemTable;
    Image1: TImage;
    imgV2Logo: TImage;
    urlDocs: TLinkLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrDownloadTimer(Sender: TObject);
    procedure ReceiveDataEvent(const Sender: TObject; AContentLength: Int64; AReadCount: Int64; var Abort: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure tmrInstallTimer(Sender: TObject);
    procedure btnStopDownloadClick(Sender: TObject);
    procedure btnFinishClick(Sender: TObject);
    procedure urlDocsLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
  private
    { Private declarations }
    InstallInfo : TInstallInfo;
    FClient: THTTPClient;
    FGlobalStart: Cardinal;
    FAsyncResponse: IAsyncResult;
    FDownloadStream: TStream;
    FHTTPResponse: IHTTPResponse;
    DownloadVer: IDownloadVer;
    AssetsURL: IAssetsURL;
    procedure DoEndDownload(const AsyncResult: IAsyncResult);
    function DetermineArchitecture(var aStatus: TResultStatus): Boolean;
    procedure FetchRESTRequest(var aStatus: TResultStatus);
    function FetchDownloadVersion(var aStatus: TResultStatus): IDownloadVer;
    function FetchAssetsURL(var aStatus: TResultStatus): IAssetsURL;
    function FetchDownloadURL(const aIs32BitWindows: Boolean; var aStatus: TResultStatus): IDownloadURL;
    procedure Download_CLI_ZIP(aDownloadURL: IDownloadURL; var aStatus: TResultStatus);
    procedure Unzip_CLI(var aStatus: TResultStatus);
    procedure Update_PATH(var aStatus: TResultStatus);
  public
    { Public declarations }
    NextClicked: Boolean;
    FinishClicked: Boolean;
  end;

  function ShowClientDownloadForm(const aInstallInfo: TInstallInfo): TResultStatus;
  function NewDownloadURL(a32Bit: boolean; aFDMemTable: TFDMemTable): IDownloadURL;
  function NewDownloadVer(aFDMemTable: TFDMemTable): IDownloadVer;
  function NewAssets(aFDMemTable: TFDMemTable): IAssetsURL;

implementation
uses System.IOUtils, System.Zip, uUpdatePath, Vcl.ExtActns;
{$R *.dfm}
type
  TAssetsURL = class(TInterfacedObject, IAssetsURL)
  private
    fAssetsUrl: string;
    function GetAssetsURL: string;
  public
    constructor create(aFDMEMTable: TFDMemTable);
    property assets_url: string read GetAssetsURL;
  end;

  TDownloadVer = class(TInterfacedObject, IDownloadVer)
  private
    FVersion: TArray<integer>;
    Ftag_name: string;
    function GetTagName: string;
    function GetMajorVersion: integer;
    function cleanVersion(const aInput: string): TArray<integer>;
  public
    constructor create(aFDMEMTable: TFDMemTable);
    property MajorVersion: integer read GetMajorVersion;
    property Tag_Name: string read GetTagName;
  end;


  TDownloadURL = class(TInterfacedObject, IDownloadURL)
  private
    FUrl: string;
    FDownloadSize: Int64;
    function GetUrl: string;
    function GetDownloadSize: Int64;
  public
    constructor create(a32Bit: boolean; aFDMemTable: TFDMemTable);
    property Url: string read GetUrl;
    property DownloadSize: Int64 read GetDownloadsize;
  end;

function NewDownloadURL(a32Bit: boolean; aFDMemTable: TFDMemTable): IDownloadURL;
begin
  result := TDownloadURL.create(a32Bit, aFDMemTable);
end;

function NewDownloadVer(aFDMemTable: TFDMemTable): IDownloadVer;
begin
  result := TDownloadVer.create(aFDMemTable);
end;

function NewAssets(aFDMemTable: TFDMemTable): IAssetsURL;
begin
  result := TAssetsURL.Create(aFDMemTable);
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
      if FinishClicked then
        result := rsFinished
      else
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

procedure TfrmDownload.btnFinishClick(Sender: TObject);
begin
  FinishClicked := btnFinish.Tag = 1;
  NextClicked := btnFinish.Tag = 0;
  close;
end;

procedure TfrmDownload.btnStopDownloadClick(Sender: TObject);
begin
  btnStopDownload.Enabled := false
end;

procedure TfrmDownload.FormCreate(Sender: TObject);
begin
  var TLSProts: THTTPSecureProtocols := [THTTPSecureProtocol.TLS12];
  RESTClient1.SecureProtocols := TLSProts;
  FClient := THTTPClient.Create;
  FClient.SecureProtocols := TLSProts;
  FClient.OnReceiveData := ReceiveDataEvent;
  NextClicked := false;
  FinishClicked := false;
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

procedure TfrmDownload.FetchRESTRequest(var aStatus: TResultStatus);
begin
  aStatus := rsCancel;
  try
    RESTRequest1.Execute;
    if RESTResponse1.StatusCode = 200 then
      aStatus := rsNext
    else
    begin
      mStatus.Lines.Add('Failed to establish connection');
      if MessageDlg('Failed to establish connection.  Confirm internet connection then Retry or Cancel.',
                     mtError, [mbRetry, mbCancel], 0) = mrRetry then
      begin
        aStatus := rsRepeat;
        mStatus.Lines.Add('');
      end;
    end;
  except
    on E: Exception do
    begin
      messagedlg(format('%s',[E.Message]),mtError,[mbOk],0);
      close;
    end;
  end;
end;

function TfrmDownload.FetchDownloadVersion(var aStatus: TResultStatus): IDownloadVer;
begin
  aStatus := rsCancel;
  mStatus.Lines.Add('Fetching Version Info.');
  result := NewDownloadVer(tableRoot);
  if not result.Tag_Name.IsEmpty then
  begin
    mStatus.Lines.Add('Successfully retrieved Version Info');
    aStatus := rsNext;
  end
  else
  begin
    result := nil;
    mStatus.Lines.Add('Failed to retrieve Version Info');
    if MessageDlg('Unable to retrieve Version Info.  Confirm internet connection then Retry or Cancel.',
                   mtError, [mbRetry, mbCancel], 0) = mrRetry then
    begin
      aStatus := rsRepeat;
      mStatus.Lines.Add('');
    end;
  end;
end;

function TfrmDownload.FetchAssetsURL(var aStatus: TResultStatus): IAssetsURL;
begin
  aStatus := rsCancel;
  mStatus.Lines.Add('Fetching Assets Info.');
  result := NewAssets(tableRoot);
  if not result.Assets_Url.IsEmpty then
  begin
    mStatus.Lines.Add('Successfully retrieved Assets Info');
    aStatus := rsNext;
  end
  else
  begin
    result := nil;
    mStatus.Lines.Add('Failed to retrieve Assets Info');
    if MessageDlg('Unable to retrieve Assets Info.  Confirm internet connection then Retry or Cancel.',
                   mtError, [mbRetry, mbCancel], 0) = mrRetry then
    begin
      aStatus := rsRepeat;
      mStatus.Lines.Add('');
    end;
  end;
end;

function TfrmDownload.FetchDownloadURL(const aIs32BitWindows: Boolean; var aStatus: TResultStatus): IDownloadURL;
begin
  aStatus := rsCancel;
  mStatus.Lines.Add('Fetching URL for latest CLI version.');
  result := NewDownloadURL(aIs32BitWindows, tableRoot);
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
begin
  aStatus := rsCancel;
  var lFileName := TPath.Combine(InstallInfo.Path, 'exercism.zip');
  try
    FAsyncResponse := nil;
    var URL := aDownloadURL.Url;

    var LSize := aDownloadURL.DownloadSize;

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
  except
    on E: EFCreateError do
    begin
      mStatus.Lines.Add(E.Message);
      btnCancel.Enabled := true;
      btnStopDownload.Enabled := false;
    end;
  end;
  FAsyncResponse := nil;
end;

procedure TfrmDownload.Unzip_CLI(var aStatus: TResultStatus);
begin
  aStatus := rsCancel;
  mStatus.Lines.Add(format('Unzipping CLI to %s',[InstallInfo.Path]));
  var lFilename := TPath.Combine(InstallInfo.Path,'exercism.zip');
  try
    TZipFile.ExtractZipFile(lFilename, TPath.Combine(InstallInfo.Path,''));
    aStatus := rsNext;
    mStatus.Lines.Add('CLI Extraction Successful');
  finally
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
    aStatus := rsNext;
  end
  else
    mStatus.Lines.Add(format('Folder "%s" NOT added to Path.',[InstallInfo.Path]));
end;

procedure TfrmDownload.urlDocsLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  var Browser := TBrowseUrl.Create(self);
  Browser.URL := Link;
  Browser.Execute;
  Browser.DisposeOf;
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
      1: FetchRESTRequest(lStatus);
      2:
        begin
          DownloadVer := FetchDownloadVersion(lStatus);
          imgV2Logo.Visible := DownloadVer.MajorVersion >= 3;
        end;
      3:
        begin
          AssetsURL := FetchAssetsURL(lStatus);
          if lStatus = rsNext then
          begin
            RESTClient1.BaseURL := AssetsURL.assets_url;
            FetchRESTRequest(lStatus);
          end;
        end;
      4: lDownloadURL := FetchDownloadURL(lIs32BitWindows, lStatus);
      5: Download_CLI_ZIP(lDownloadURL, lStatus);
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
  lIsV3CLI: boolean;
begin
  tmrInstall.Enabled := false;
  lIsV3CLI := false;
  i := 0;
  lLoopStatus := rsContinue;
  lStatus := rsCancel;
  repeat
    case i of
      0: Unzip_CLI(lStatus);
      1: Update_PATH(lStatus);
      2: begin
           lIsV3CLI := DownloadVer.MajorVersion >= 3;
           lStatus := rsFinished;
         end;
    end;//case

    case lStatus of
      rsNext: inc(i);
      rsCancel,
      rsFinished: lLoopStatus := rsDone;
    end;//cased
  until lLoopStatus = rsDone;
  btnFinish.Enabled := (lStatus = rsFinished);
  btnFinish.Tag := lIsV3CLI.ToInteger;
  if btnFinish.Enabled then
  begin
    if lIsV3CLI then
    begin
      mStatus.Lines.Add('');
      mStatus.Lines.Add('Installation Complete!');
      mStatus.Lines.Add('Invoke the CLI from the command-line by calling exercism.exe');
      mStatus.Lines.Add('Click [Finish] to exit the installer.');
      ActiveControl := btnFinish;
      urlDocs.Visible := true;
    end
    else
    begin
      btnFinish.Caption := '&Next';
      mStatus.Lines.Add('');
      mStatus.Lines.Add('Installation Complete!');
      mStatus.Lines.Add('Click [Next] to proceed with configuring the CLI.');
      ActiveControl := btnFinish;
    end;
  end;
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

constructor TDownloadURL.create(a32Bit: boolean; aFDMemTable: TFDMemTable);
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

{ TDownloadVer }

function TDownloadVer.cleanVersion(const aInput: string): TArray<integer>;
var cleaned: string;
    cleanedSplit: TArray<string>;
    i: integer;
begin
  cleaned := ainput.Trim(['v','V',' ']);
  cleanedSplit := cleaned.Split(['.']);
  SetLength(Result, length(cleanedSplit));
  for i := 0 to High(Result) do
    Result[i] := cleanedSplit[i].ToInteger;
end;

constructor TDownloadVer.create(aFDMEMTable: TFDMemTable);
var
  IsFound: boolean;
  tag_name_Field: TField;
begin
  FTag_Name := '';
  if aFDMemTable.FindFirst then
  begin
    IsFound := false;
    repeat
      tag_name_Field := aFDMemTable.FindField('tag_name');
      if assigned(tag_name_Field) then
      begin
        IsFound := true;
        FTag_Name := tag_name_Field.DisplayText;
        FVersion := cleanVersion(FTag_Name);
      end;
    until IsFound or not aFDMemtable.FindNext;
  end;
end;

function TDownloadVer.GetMajorVersion: integer;
begin
  result := FVersion[0];
  {$ifdef V3Test}
  result := 3;
  {$endif}
end;

function TDownloadVer.GetTagName: string;
begin
  result := FTag_Name;
end;

{ TAssetsURL }

constructor TAssetsURL.create(aFDMEMTable: TFDMemTable);
var
  IsFound: boolean;
  assets_url_Field: TField;
begin
  fAssetsUrl := '';
  if aFDMemTable.FindFirst then
  begin
    IsFound := false;
    repeat
      assets_url_Field := aFDMemTable.FindField('assets_url');
      if assigned(assets_url_Field) then
      begin
        IsFound := true;
        fAssetsUrl := assets_url_Field.DisplayText;
      end;
    until IsFound or not aFDMemtable.FindNext;
  end;
end;

function TAssetsURL.GetAssetsURL: string;
begin
  result := fAssetsUrl;
end;

end.
