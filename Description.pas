unit Description;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.Ani;

type
  TfxDescription = class(TForm)
    Image1: TImage;
    Memo1: TMemo;
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fxDescription: TfxDescription;

implementation

{$R *.fmx}

procedure TfxDescription.Image1Click(Sender: TObject);
begin
 Self.Close;
end;

end.
