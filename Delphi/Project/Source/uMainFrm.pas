unit uMainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, ovcurl;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    rbAccept: TRadioButton;
    rbDontAccept: TRadioButton;
    btnNext: TButton;
    btnCancel: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    OvcURL1: TOvcURL;
    OvcURL2: TOvcURL;
    procedure rbAcceptClick(Sender: TObject);
    procedure rbDontAcceptClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.rbAcceptClick(Sender: TObject);
begin
  btnNext.Enabled := True;
end;

procedure TfrmMain.rbDontAcceptClick(Sender: TObject);
begin
  btnNext.Enabled := False;
end;

end.
