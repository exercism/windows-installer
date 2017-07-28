unit uTypes;

interface

type
  TResultStatus = (rsNext, rsDone, rsCancel, rsContinue, rsFinished, rsRepeat);

  TInstallInfo = record
    APIKey: string;
    Path: string;
  end;

implementation

end.
