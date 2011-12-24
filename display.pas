unit display;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql50conn, sqldb, db, FileUtil, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ComCtrls, Grids, EditBtn, DBGrids;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    DateEditToT: TDateEdit;
    DateEditFromT: TDateEdit;
    DateEditTo: TDateEdit;
    DateEditFrom: TDateEdit;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    edPort: TEdit;
    ft: TComboBox;
    Datasource: TDatasource;
    edHost: TEdit;
    edUser: TEdit;
    edPass: TEdit;
    edDB: TEdit;
    edMomen: TEdit;
    edLR: TEdit;
    edEpoch: TEdit;
    edEMax: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Connection: TMySQL50Connection;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    YOutput: TStringGrid;
    VijHidden: TStringGrid;
    WijHidden: TStringGrid;
    procedure Button10Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure edPassChange(Sender: TObject);
    procedure GroupBox2Click(Sender: TObject);
  private
    { private declarations }
    function fft(no:integer;value:Extended):Extended;
    function dft(no:integer;value:Extended):Extended;
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation
uses grafik,nnga;
{$R *.lfm}
var isFinish: Boolean;
{ TForm1 }
function TForm1.fft(no:integer;value:Extended):Extended;
var eHasil:Extended;
begin
  eHasil:=0.0;
  case no of
  0 :begin
      if value>=10000 then eHasil:=0.9999;
      if value<=-10000 then eHasil:=0.000000001;
      if (value>-10000) and (value<10000) then eHasil:=1/(1+exp(-value));
  end;
  1:begin
      if value>=10000 then eHasil:=0.9999;
      if value<=-10000 then eHasil:=-0.9999;
      if (value>-10000) and (value<10000) then eHasil:=(2/1+exp(-1*value))-1;
  end;
  end;
      fft:=eHasil;
end;
function TForm1.dft(no:integer;value:Extended):Extended;
var dummy,eHasil:Extended;
begin
      eHasil:=0.0;
      case no of
      0:begin
          dummy:=fft(no,value);
          eHasil:=(1-dummy)*dummy;
        end;
      1:begin
            dummy:=fft(no,value);
            eHasil:=0.5*(1+dummy)*(1-dummy);
        end;
      end;
      dft:=eHasil;
end;

procedure TForm1.GroupBox2Click(Sender: TObject);
begin

end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin

  Connection.HostName:=edHost.Text;
  Connection.port:=strtoint(edPort.Text);
  Connection.UserName:=edUser.Text;
  Connection.Password:=edPass.Text;
  Connection.DatabaseName:=edDB.Text;
  try
    Connection.Connected:=true;
    GroupBox2.Enabled:=true;
    GroupBox3.Enabled:=true;
    GroupBox4.Enabled:=true;
    GroupBox5.Enabled:=true;
    GroupBox6.Enabled:=true;
    GroupBox7.Enabled:=true;
    GroupBox8.Enabled:=true;
  except
    GroupBox2.Enabled:=false;
    GroupBox3.Enabled:=false;
    GroupBox4.Enabled:=false;
    GroupBox5.Enabled:=false;
    GroupBox6.Enabled:=false;
    GroupBox7.Enabled:=false;
    GroupBox8.Enabled:=false;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var  eMomen,eLR,eEpoch : Extended;
  jInput,jHiden,jOutput,jLooping,ftOpsi:Integer;
  Done : Boolean;
  maxValue : real;
begin
  isFinish := false;
  Button2.Enabled:=false;
  Button3.Enabled:=false;
  ftOpsi := ft.ItemIndex;

  {-set stringGrid-}

  {-Inisialisasi data penimbang-}

  {-proses pelatihan-}

  {-hasil pelatiha-}
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  Form1.Enabled:=false;
  Grafiksistem.show;
end;

procedure TForm1.edPassChange(Sender: TObject);
begin

end;

end.

