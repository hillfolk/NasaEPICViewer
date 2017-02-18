program EPIC_VIEW;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {fxMain},
  Jsons in 'Json\Jsons.pas',
  Description in 'Description.pas' {fxDescription};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfxMain, fxMain);
  Application.CreateForm(TfxDescription, fxDescription);
  Application.Run;
end.
