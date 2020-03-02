unit uInstallLocationFrm;
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTypes, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, System.Generics.Collections, System.UITypes, Vcl.Buttons;

type
  TCLIPresent = class;

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
    Image1: TImage;
    imgV2Logo: TImage;
    LinkLabel1: TLinkLabel;
    pnlPreexistingCLI: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    btnYes: TButton;
    btnNo: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LinkLabel1LinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnYesClick(Sender: TObject);
    procedure btnNoClick(Sender: TObject);
  private
    { Private declarations }
    OldCLIPresent: TCLIPresent;
  public
    { Public declarations }
    NextClicked: boolean;
  end;

  TCLIPresent = class
  strict private
    const
      CliFilename = 'exercism.exe';
    var
      FInstallTo: string;
      FListOfFinds: TList<string>;
      FIsPresent: Boolean;
      FNumberFound: Integer;
    function GetPath: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure FindPreexistingCLI;
    property InstallTo: string read FInstallTo;
    property IsPresent: Boolean read FIsPresent;
    property NumberFound: Integer read FNumberFound;
  end;

  function ShowInstallLocationForm(var aInstallInfo: TInstallInfo): TResultStatus;

implementation
uses
  StrUtils, Vcl.FileCtrl, Vcl.ExtActns, Registry;
{$R *.dfm}

function ShowInstallLocationForm(var aInstallInfo: TInstallInfo): TResultStatus;
begin
  result := rsCancel;
  var thisForm := TfrmInstallLocation.Create(nil);
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
begin
  var folder: string := fldLocation.Text;
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
begin
  var lOKNext := true;
  if not System.SysUtils.DirectoryExists(fldLocation.Text) then
  begin
    var lDlgResult := MessageDlg(format('Directory "%s" does not exist.'+#13#10+
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

procedure TfrmInstallLocation.btnNoClick(Sender: TObject);
begin
  pnlPreexistingCLI.Visible := false;
  MessageDlg('Please remove all copies of the CLI before attempting to install the latest version.', mtInformation, [mbOk], 0);
  btnCancel.Click;
end;

procedure TfrmInstallLocation.FormActivate(Sender: TObject);
begin
  OldCLIPresent.FindPreexistingCLI;
  if OldCLIPresent.IsPresent then
  begin
    pnlPreexistingCLI.BringToFront;
    pnlPreexistingCLI.Visible := true;
    btnNext.Enabled := false;
  end;
end;

procedure TfrmInstallLocation.FormCreate(Sender: TObject);
begin
  NextClicked := false;
  OldCLIPresent := TCLIPresent.Create;
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
end;

procedure TfrmInstallLocation.FormDestroy(Sender: TObject);
begin
  OldCLIPresent.DisposeOf;
end;

procedure TfrmInstallLocation.LinkLabel1LinkClick(Sender: TObject;
  const Link: string; LinkType: TSysLinkType);
begin
  var Browser := TBrowseUrl.Create(self);
  Browser.URL := Link;
  Browser.Execute;
  Browser.DisposeOf;
end;

procedure TfrmInstallLocation.btnYesClick(Sender: TObject);
begin
  pnlPreexistingCLI.Visible := false;
  fldLocation.Text := OldCLIPresent.InstallTo;
  btnNext.Enabled := True;
end;

{ TCLIPresent }

constructor TCLIPresent.Create;
begin
  inherited;
  FListOfFinds := TList<string>.Create;
end;

destructor TCLIPresent.Destroy;
begin
  FListOfFinds.DisposeOf;
  inherited;
end;

procedure TCLIPresent.FindPreexistingCLI;
begin
  var PathArray := GetPath.Split([';']);
  for var aPath in PathArray do
  begin
    var fixedPath := aPath;
    if not fixedPath.EndsWith('\') then
      fixedPath := fixedPath + '\';
    var LFileToFind := fixedPath + CliFilename;
    if FileExists(LFileToFind) then
        FListOfFinds.Add(aPath);
  end;
  FNumberFound := FListOfFinds.Count;
  FIsPresent := FNumberFound > 0;
  FInstallTo := ifthen(FIsPresent, FListOfFinds[0]);
end;

function TCLIPresent.GetPath: string;
begin
  var reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    var openResult := reg.OpenKeyReadOnly('Environment');
    if openResult then
      Result := reg.ReadString('Path')
    else
      Result := '';
  finally
    reg.CloseKey;
    reg.Free;
  end;
end;

end.
