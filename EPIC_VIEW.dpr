program EPIC_VIEW;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {fxMain},
  Jsons in 'Json\Jsons.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfxMain, fxMain);
  Application.Run;
end.
