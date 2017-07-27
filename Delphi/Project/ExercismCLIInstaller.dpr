program ExercismCLIInstaller;

uses
  Vcl.Forms,
  uMainFrm in 'Source\uMainFrm.pas' {frmMain},
  uInstallLocationFrm in 'Source\uInstallLocationFrm.pas' {frmInstallLocation},
  uClientDownloadFrm in 'Source\uClientDownloadFrm.pas' {frmDownload},
  uConfigApiFrm in 'Source\uConfigApiFrm.pas' {frmConfigAPI},
  uTypes in 'Source\uTypes.pas';

{$R *.res}


var LoopStatus,
    ResultStatus: TResultStatus;
    i: integer;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  i := 0;
  LoopStatus := rsOK;
  ResultStatus := rsCancel;
  repeat
    case i of
      0:
        ResultStatus := ShowMainForm;
      1:
        ResultStatus := ShowInstallLocationForm;
      2:
        ResultStatus := ShowConfigAPIForm;
    end; //case

    case ResultStatus of
      rsNext:
        inc(i);

      rsCancel,
      rsFinished:
        LoopStatus := rsDone;
    end; // case

  until LoopStatus = rsDone;
end.
