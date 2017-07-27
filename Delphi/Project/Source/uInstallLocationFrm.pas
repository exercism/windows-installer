unit uInstallLocationFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTypes, Vcl.StdCtrls, Vcl.ExtCtrls,
  RzShellDialogs;

type
  TfrmInstallLocation = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    btnCancel: TButton;
    btnNext: TButton;
    fldLocation: TEdit;
    Label3: TLabel;
    btnBrowse: TButton;
    RzSelectFolderDialog1: TRzSelectFolderDialog;
    procedure btnCancelClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NextClicked: boolean;
  end;


  function ShowInstallLocationForm: TResultStatus;

implementation
uses System.IOUtils;
{$R *.dfm}

var
  thisForm: TfrmInstallLocation;


function ShowInstallLocationForm: TResultStatus;
begin
  result := rsCancel;
  thisForm := TfrmInstallLocation.Create(nil);
  try
    thisForm.ShowModal;
    if thisForm.NextClicked then
      result := rsNext;
  finally
    thisForm.DisposeOf;
  end;
end;

procedure TfrmInstallLocation.btnBrowseClick(Sender: TObject);
begin
  if RzSelectFolderDialog1.Execute then
  begin
    fldLocation.Text := RzSelectFolderDialog1.SelectedPathName
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
  if not DirectoryExists(fldLocation.Text) then
  begin
    lDlgResult := MessageDlg(format('Directory "%s" does not exist.'+#13#10+
                                    'Shall I create it for you?',
       [fldLocation.Text]),mtError, [mbYes, mbNo],0);
    if lDlgResult = mrYes then
      ForceDirectories(fldLocation.Text)
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

procedure TfrmInstallLocation.FormCreate(Sender: TObject);
begin
  NextClicked := false;
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
end;

end.
