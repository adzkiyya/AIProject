unit grafik;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  TAStyles, TAGraph;

type

  { TGrafiksistem }

  TGrafiksistem = class(TForm)
    Button1: TButton;
    Chart1: TChart;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Grafiksistem: TGrafiksistem;

implementation

{$R *.lfm}

{ TGrafiksistem }

procedure TGrafiksistem.Button1Click(Sender: TObject);
begin
 Application.Terminate;
end;

end.

