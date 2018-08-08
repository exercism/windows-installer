unit uInstallLocationFrm;
{_define SimTLSCheckFailure}
{$define SkipTLSCheck}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTypes, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, System.UITypes, ovcurl;

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
    Label4: TLabel;
    Label5: TLabel;
    OvcURL4: TOvcURL;
    Image1: TImage;
    imgV2Logo: TImage;
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

  function ShowInstallLocationForm(var aInstallInfo: TInstallInfo): TResultStatus;

implementation
uses
  Vcl.FileCtrl;
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

procedure TfrmInstallLocation.FormCreate(Sender: TObject);
begin
  NextClicked := false;
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
end;

end.
