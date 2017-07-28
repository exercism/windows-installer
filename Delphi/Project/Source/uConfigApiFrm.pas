unit uConfigApiFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, ovcurl,
  uTypes;

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
    procedure btnFinishClick(Sender: TObject);
    procedure fldAPIChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  thisForm: TfrmConfigAPI;

  function ShowConfigAPIForm(const aInstallInfo: TInstallInfo): TResultStatus;


implementation

{$R *.dfm}

function ShowConfigAPIForm(const aInstallInfo: TInstallInfo): TResultStatus;
begin
  result := rsFinished;
  thisForm := TfrmConfigAPI.Create(nil);
  try
    thisForm.ShowModal;
  finally
    thisForm.DisposeOf;
  end;
end;


procedure TfrmConfigAPI.btnFinishClick(Sender: TObject);
begin
  if trim(fldAPI.Text) <> '' then

  close;
end;

procedure TfrmConfigAPI.fldAPIChange(Sender: TObject);
begin
  btnFinish.Enabled := true;
end;

procedure TfrmConfigAPI.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
end;

end.
