program ExercismCLIInstaller;

uses
  Vcl.Forms,
  uMainFrm in 'Source\uMainFrm.pas' {frmMain},
  uInstallLocationFrm in 'Source\uInstallLocationFrm.pas' {Form2},
  uClientDownloadFrm in 'Source\uClientDownloadFrm.pas' {Form3},
  uConfigApiFrm in 'Source\uConfigApiFrm.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
