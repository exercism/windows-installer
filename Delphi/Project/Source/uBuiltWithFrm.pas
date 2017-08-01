unit uBuiltWithFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TfrmBuiltWith = class(TForm)
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  frmBuiltWith: TfrmBuiltWith;

procedure ShowAbout;

implementation

{$R *.dfm}

procedure ShowAbout;
begin
  with TfrmBuiltWith.Create(nil) do
    try
      ShowModal;
    finally
      DisposeOf;
    end;
end;

end.
