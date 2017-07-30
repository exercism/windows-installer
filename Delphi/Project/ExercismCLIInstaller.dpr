program ExercismCLIInstaller;

uses
  Vcl.Forms,
  uMainFrm in 'Source\uMainFrm.pas' {frmMain},
  uInstallLocationFrm in 'Source\uInstallLocationFrm.pas' {frmInstallLocation},
  uClientDownloadFrm in 'Source\uClientDownloadFrm.pas' {frmDownload},
  uConfigApiFrm in 'Source\uConfigApiFrm.pas' {frmConfigAPI},
  uTypes in 'Source\uTypes.pas',
  uUpdatePath in 'Source\uUpdatePath.pas';

{$R *.res}


var LoopStatus,
    ResultStatus: TResultStatus;
    i: integer;
    InstallInfo: TInstallInfo;

begin
  fillchar(InstallInfo, sizeof(TInstallInfo), #0);
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  i := 0;
  LoopStatus := rsContinue;
  ResultStatus := rsCancel;
  repeat
    case i of
      0: ResultStatus := ShowMainForm;
      1: ResultStatus := ShowInstallLocationForm(InstallInfo);
      2: ResultStatus := ShowClientDownloadForm(InstallInfo);
      3: ResultStatus := ShowConfigAPIForm(InstallInfo);
    end; //case

    case ResultStatus of
      rsNext: inc(i);

      rsCancel,
      rsFinished: LoopStatus := rsDone;
    end; // case

  until LoopStatus = rsDone;
end.
