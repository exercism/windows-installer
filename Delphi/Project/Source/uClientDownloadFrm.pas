unit uClientDownloadFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  uTypes;

type
  TfrmDownload = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    btnCancel: TButton;
    btnNext: TButton;
    mStatus: TMemo;
    dlProgress: TProgressBar;
    procedure btnCancelClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NextClicked: Boolean;
  end;

  function ShowClientDownloadForm: TResultStatus;

implementation

{$R *.dfm}
var
  thisForm: TfrmDownload;

function ShowClientDownloadForm: TResultStatus;
begin
  result := rsCancel;
  thisForm := TfrmDownload.Create(nil);
  try
    thisForm.ShowModal;
    if thisForm.NextClicked then
      result := rsNext;
  finally
    thisForm.DisposeOf;
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

procedure TfrmDownload.FormCreate(Sender: TObject);
begin
  NextClicked := false;
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
end;

end.
