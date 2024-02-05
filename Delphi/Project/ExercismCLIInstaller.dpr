program ExercismCLIInstaller;

uses
  Vcl.Forms,
  uInstallLocationFrm in 'Source\uInstallLocationFrm.pas' {frmInstallLocation},
  uClientDownloadFrm in 'Source\uClientDownloadFrm.pas' {frmDownload},
  uTypes in 'Source\uTypes.pas',
  uUpdatePath in 'Source\uUpdatePath.pas',
  uConfigApiFrm in 'Source\uConfigApiFrm.pas' {frmConfigAPI};

{$R *.res}


begin
  var InstallInfo: TInstallInfo;
  fillchar(InstallInfo, sizeof(TInstallInfo), #0);
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  var i := 0;
  var LoopStatus := rsContinue;
  repeat
    var ResultStatus := rsCancel;
    case i of
      0: ResultStatus := ShowInstallLocationForm(InstallInfo);
      1: ResultStatus := ShowClientDownloadForm(InstallInfo);
      2: ResultStatus := ShowConfigAPIForm(InstallInfo);
    end; //case

    case ResultStatus of
      rsNext: inc(i);

      rsCancel,
      rsFinished: LoopStatus := rsDone;
    end; // case

  until LoopStatus = rsDone;
end.
