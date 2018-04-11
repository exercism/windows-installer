unit uInstallLocationFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTypes, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, System.UITypes, ovcurl, IPPeerClient, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope;

type
  ICheckTLS = interface(IInvokable)
    ['{2AED8C0C-BF88-4A06-A3B2-418799CD28EF}']
    function GetTLSOK: boolean;
    function GetStatusCode: integer;
    function GetTLSVersion: string;
    function GetMessageStr: string;
    property TLSok: boolean read GetTLSOK;
    property StatusCode: integer read GetStatusCode;
    property TLSVersion: string read GetTLSVersion;
    property ErrMessage: string read GetMessageStr;
  end;

  TCheckTLS = class(TInterfacedObject, ICheckTLS)
  strict private
    const
      cDesiredVersion: double = 1.2;
    var
      fTLSVersion: string;
      fTLSOK: boolean;
      fStatusCode: integer;
      fMessageStr: string;
    function GetTLSOK: boolean;
    function GetStatusCode: integer;
    function GetTLSVersion: string;
    function GetMessageStr: string;
  public
    constructor Create(aRESTRequest: TRestRequest; aRESTResponse: TRESTResponse);
    property TLSok: boolean read GetTLSOK;
    property StatusCode: integer read GetStatusCode;
    property TLSVersion: string read GetTLSVersion;
    property ErrMessage: string read GetMessageStr;
  end;

  TfrmInstallLocation = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    btnCancel: TButton;
    btnNext: TButton;
    fldLocation: TEdit;
    Label3: TLabel;
    btnBrowse: TButton;
    Label4: TLabel;
    Label5: TLabel;
    OvcURL4: TOvcURL;
    Image1: TImage;
    rcCheckTLSVersion: TRESTClient;
    rrCheckTLSVersion: TRESTRequest;
    rResponseCheckTLSVersion: TRESTResponse;
    lblUpdateTLS: TOvcURL;
    tmrCheckTLS: TTimer;
    procedure btnCancelClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure tmrCheckTLSTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NextClicked: boolean;
  end;

  function ShowInstallLocationForm(var aInstallInfo: TInstallInfo): TResultStatus;

implementation
uses
  Vcl.FileCtrl,
  System.IOUtils;
{$R *.dfm}

var
  thisForm: TfrmInstallLocation;


function ShowInstallLocationForm(var aInstallInfo: TInstallInfo): TResultStatus;
begin
  result := rsCancel;
  thisForm := TfrmInstallLocation.Create(nil);
  try
    thisForm.ShowModal;
    if thisForm.NextClicked then
    begin
      aInstallInfo.Path := thisForm.fldLocation.Text;
      result := rsNext;
    end;
  finally
    thisForm.DisposeOf;
  end;
end;

procedure TfrmInstallLocation.btnBrowseClick(Sender: TObject);
var
  folder: string;
begin
  folder := fldLocation.Text;
  if vcl.FileCtrl.SelectDirectory('Select Install Location', '', Folder, [sdNewUI, sdNewFolder], Self) then
  begin
    fldLocation.Text := folder;
  end;
end;

procedure TfrmInstallLocation.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmInstallLocation.btnNextClick(Sender: TObject);
var lOKNext: boolean;
    lDlgResult: word;
begin
  lOKNext := true;
  if not System.SysUtils.DirectoryExists(fldLocation.Text) then
  begin
    lDlgResult := MessageDlg(format('Directory "%s" does not exist.'+#13#10+
                                    'Shall I create it for you?',
       [fldLocation.Text]),mtError, [mbYes, mbNo],0);
    if lDlgResult = mrYes then
    begin
      if not System.SysUtils.ForceDirectories(fldLocation.Text) then
      begin
        lOKNext := false;
        MessageDlg(format('Error: Unable to create "%s".'+#13#10+
                          'Please select another folder or Cancel this installation'
                          ,[fldLocation.Text]), mtError, [mbOK], 0);
      end;
    end
    else
    begin
      lOKNext := false;
      MessageDlg('Please select a folder or Cancel this installation', mtInformation, [mbOK], 0);
    end;
  end;

  if lOKNext then
  begin
    NextClicked := true;
    close;
  end;
end;

procedure TfrmInstallLocation.FormActivate(Sender: TObject);
begin
  tmrCheckTLS.Enabled := true;
end;

procedure TfrmInstallLocation.FormCreate(Sender: TObject);
begin
  NextClicked := false;
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
end;

procedure TfrmInstallLocation.tmrCheckTLSTimer(Sender: TObject);
var
  CheckTLS: ICheckTLS;
begin
  tmrCheckTLS.Enabled := false;
  CheckTLS := TCheckTLS.Create(rrCheckTLSVersion, rResponseCheckTLSVersion);
  btnNext.Enabled := CheckTLS.TLSok;
  if not btnNext.Enabled then
  begin
    lblUpdateTLS.Visible := true;
    MessageDlg(CheckTLS.ErrMessage,mtError,[mbok],0);
  end;
end;

{ TCheckTLS }

constructor TCheckTLS.Create(aRESTRequest: TRestRequest; aRESTResponse: TRESTResponse);
var
  actualVersion: double;
  lFormatSettings: TFormatSettings;
begin
  aRESTRequest.Execute;
  fStatusCode := aRESTResponse.StatusCode;
  fMessageStr := '';
  fTLSOK := false;
  fTLSVersion := '';
  if fStatusCode = 200 then
  begin
    lFormatSettings := TFormatSettings.Create;
    lFormatSettings.ThousandSeparator := ',';
    lFormatSettings.DecimalSeparator := '.';
    fTLSVersion := aRESTResponse.JSONText.Replace('"TLS ','');
    fTLSVersion := fTLSVersion
                     .Replace('"','')
                     .Replace(' ','');
    actualVersion := StrToFloat(fTLSVersion, lFormatSettings);
    fTLSOK := actualVersion >= cDesiredVersion;
    if not fTLSOK then
      fMessageStr := format('TLS Version = %s, must be %0.1f or greater.'+#13#10+
                            'GitHub requires at least version 1.2'+#13#10+
                            'Please follow the link to Microsoft for instructions on updating Windows.',[fTLSVersion,cDesiredVersion]);
  end
  else
  begin
    fMessageStr := format('Err: REST Status Code %d', [fStatusCode]);
    fTLSOk := false;
  end;
end;

function TCheckTLS.GetMessageStr: string;
begin
  result := fMessageStr;
end;

function TCheckTLS.GetStatusCode: integer;
begin
  result := fStatusCode;
end;

function TCheckTLS.GetTLSOK: boolean;
begin
  result := fTLSOk;
end;

function TCheckTLS.GetTLSVersion: string;
begin
  result := fTLSVersion;
end;

end.
