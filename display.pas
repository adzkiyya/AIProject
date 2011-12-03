unit display; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql50conn, sqldb, db, FileUtil, LResources, Forms,
  Controls, Graphics, Dialogs, StdCtrls, ComCtrls, Grids, ExtCtrls, Spin,
  EditBtn, DBGrids;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnBackProp: TButton;
    btnGA: TButton;
    btnConnect: TButton;
    chkTrain: TCheckBox;
    ft: TComboBox;
    DataSource: TDatasource;
    DateEdit1: TDateEdit;
    dateEditFrom: TDateEdit;
    dateEditTo: TDateEdit;
    DBGrid1: TDBGrid;
    edSMomen: TEdit;
    edt_username: TEdit;
    edt_password: TEdit;
    edt_hostName: TEdit;
    edt_port: TEdit;
    edt_database: TEdit;
    edtLearningRate: TFloatSpinEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    groupBox_training: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LabelLearningRate: TLabel;
    Connection: TMySQL50Connection;
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    YOutput: TStringGrid;
    VijHidden: TStringGrid;
    WijHidden: TStringGrid;
    target: TStringGrid;
    transaction: TSQLTransaction;
    table_bmg_bjm: TSQLQuery;
    table_bmg_bjmKelembaban: TFloatField;
    table_bmg_bjmSuhuAvg: TFloatField;
    table_bmg_bjmSuhuMax: TFloatField;
    table_bmg_bjmSuhuMin: TFloatField;
    table_bmg_bjmTanggal: TDateField;
    procedure btnConnectClick(Sender: TObject);
    procedure dateEditChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure GroupBox3Click(Sender: TObject);
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

{ TForm1 }
function TForm1.fft(no:integer;value:Extended):Extended;
var eHasil:Extended;
begin
  eHasil:=0.0;
  case no of
  0 :begin
      if value>=10000 then eHasil:=0.9999;
      if value<=-10000 then eHasil:=0.000000001
      if (value>-10000) and (value<10000) then eHasil:=1/(1+exp(-value));
  end;
  1:begin
      if value>=10000 then eHasil:=0.9999;
      if value<=-10000 then eHasil:=-0.9999;
      if (value>-10000) and (value<10000) then eHasil:=(2/1+exp(-1*value)))-1;
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

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  Connection.HostName:=edt_hostName.Text;
  Connection.port:=strtoint(edt_port.Text);
  Connection.UserName:=edt_username.Text;
  Connection.Password:=edt_password.Text;
  Connection.DatabaseName:=edt_database.Text;
  try
    Connection.Connected:=true;
    groupBox_training.Enabled:=true;
    dateEditFrom.Date:=now;
    dateEditTo.Date:=now;
    dateEditFrom.OnChange:=@dateEditChange;
    dateEditTo.OnChange:=@dateEditChange;
    dateEditChange(self);
  except
    groupBox_training.Enabled:=false;
  end;
end;

procedure TForm1.dateEditChange(Sender: TObject);
begin
  try
    transaction.Rollback;
    transaction.Active:=false;
    table_bmg_bjm.Active:=false;
    table_bmg_bjm.SQL.Text := 'SELECT * FROM bmg_bjm WHERE tanggal<='''+
      dateEditTo.Text +''' AND tanggal>='''+
      dateEditFrom.Text +''' ORDER BY tanggal';
    showMessage(table_bmg_bjm.SQL.Text);
    table_bmg_bjm.Active:=true;
    transaction.Active:=true;
  finally
  end;
end;


procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  transaction.Rollback;
  transaction.Active:=false;
  table_bmg_bjm.Active:=false;
  Connection.Connected:=false;
end;

procedure TForm1.GroupBox3Click(Sender: TObject);
begin

end;

initialization
  {$I display.lrs}

end.

