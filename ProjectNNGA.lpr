program ProjectNNGA;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, display, LResources, SQLDBLaz, nnga
  { you can add units after this };

{$IFDEF WINDOWS}{$R ProjectNNGA.rc}{$ENDIF}

begin
  {$I ProjectNNGA.lrs}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

