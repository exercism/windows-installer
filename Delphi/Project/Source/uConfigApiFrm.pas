unit uConfigApiFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, ovcurl,
  uTypes, Vcl.Imaging.pngimage;

type
  TfrmConfigAPI = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    btnFinish: TButton;
    Label3: TLabel;
    fldAPI: TEdit;
    OvcURL1: TOvcURL;
    Label4: TLabel;
    Image1: TImage;
    procedure btnFinishClick(Sender: TObject);
    procedure fldAPIChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    InstallInfo: TInstallInfo;
    function ExecuteAndWait(const aCommand: string): Boolean;
  public
    { Public declarations }
  end;

  function ShowConfigAPIForm(const aInstallInfo: TInstallInfo): TResultStatus;


implementation
uses System.IOUtils;
{$R *.dfm}

function ShowConfigAPIForm(const aInstallInfo: TInstallInfo): TResultStatus;
begin
  result := rsFinished;
  with TfrmConfigAPI.Create(nil) do
    try
      InstallInfo := aInstallInfo;
      ShowModal;
    finally
      DisposeOf;
    end;
end;


procedure TfrmConfigAPI.btnFinishClick(Sender: TObject);
var
  lCommand: string;
begin
  if trim(fldAPI.Text) <> '' then
  begin
    lCommand := TPath.Combine(InstallInfo.Path, 'exercism.exe');
    lCommand := lCommand + ' configure --key=' + fldAPI.Text;
    if ExecuteAndWait(lCommand) then
    begin
      lCommand := TPath.Combine(InstallInfo.Path, 'exercism.exe');
      lCommand := lCommand + ' configure --dir="' + TPath.Combine(InstallInfo.Path, '') + '"';
      ExecuteAndWait(lCommand);
    end;
    close;
  end;
end;

procedure TfrmConfigAPI.fldAPIChange(Sender: TObject);
begin
  btnFinish.Enabled := true;
end;

procedure TfrmConfigAPI.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
end;

function TfrmConfigAPI.ExecuteAndWait(const aCommand: string): Boolean;
var
  tmpStartupInfo: TStartupInfo;
  tmpProcessInformation: TProcessInformation;
  tmpProgram: String;
begin
  result := false;
  tmpProgram := aCommand.Trim;
  FillChar(tmpStartupInfo, SizeOf(tmpStartupInfo), 0);
  with tmpStartupInfo do
  begin
    cb := SizeOf(TStartupInfo);
    wShowWindow := SW_HIDE;
  end;

  if CreateProcess(nil, pchar(tmpProgram), nil, nil, true, CREATE_NO_WINDOW,
    nil, nil, tmpStartupInfo, tmpProcessInformation) then
  begin
    // loop every 10 ms
    while WaitForSingleObject(tmpProcessInformation.hProcess, 10) > 0 do
    begin
      Application.ProcessMessages;
    end;
    CloseHandle(tmpProcessInformation.hProcess);
    CloseHandle(tmpProcessInformation.hThread);
    result := true;
  end
  else
  begin
    RaiseLastOSError;
  end;
end;

end.
