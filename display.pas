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
    DataSource: TDatasource;
    dateEditFrom: TDateEdit;
    dateEditTo: TDateEdit;
    DBGrid1: TDBGrid;
    edt_username: TEdit;
    edt_password: TEdit;
    edt_hostName: TEdit;
    edt_port: TEdit;
    edt_database: TEdit;
    edtLearningRate: TFloatSpinEdit;
    GroupBox1: TGroupBox;
    groupBox_training: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    LabelLearningRate: TLabel;
    Connection: TMySQL50Connection;
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    transaction: TSQLTransaction;
    table_bmg_bjm: TSQLQuery;
    table_bmg_bjmKelembaban: TFloatField;
    table_bmg_bjmSuhuAvg: TFloatField;
    table_bmg_bjmSuhuMax: TFloatField;
    table_bmg_bjmSuhuMin: TFloatField;
    table_bmg_bjmTanggal: TDateField;
    VijHidden: TStringGrid;
    YOutput: TStringGrid;
    procedure btnConnectClick(Sender: TObject);
    procedure dateEditChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{ TForm1 }

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

initialization
  {$I display.lrs}

end.

