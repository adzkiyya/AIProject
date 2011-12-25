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
    Target: TStringGrid;
    XInput: TStringGrid;
    YOutput: TStringGrid;
    VijHidden: TStringGrid;
    WjkHidden: TStringGrid;
    procedure Button10Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure edPassChange(Sender: TObject);
    procedure GroupBox2Click(Sender: TObject);
  private
    { private declarations }
    function fft(no:integer;value:Extended):Extended;
    function dft(no:integer;value:Extended):Extended;
    function RandomWeight(low,high:Extended):Extended;
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
function TForm1.RandomWeight(low,high:Extended):Extended;
begin
      RandomWeight:=Random(100)*(high-low)*0.01+low;
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
var  eMomen,eLR,eEpoch,eEMax : Extended;
  jInput,jHiden,jOutput,jLooping,ftOpsi:Integer;
  counter,i,j,k : Integer;
  dummy,dInput,dHiden,dOutput : Extended;
  Xi : array[1..100] of real;
  Vij,Vijupdate: array[0..100,1..100] of Extended;
  Wjk,Wjkupdate: array[0..100,1..100] of Extended;
  Zin_j,Zj : array[1..100] of Extended;
  Yin_k,Yk : array[1..100] of Extended;
  Otarget  : array[1..100] of Extended;
  deltain_j,delta_j : array[1..100] of Extended;
  delta_k   : array[1..30] of Extended;
  eError, eES : Extended;
  Done : Boolean;
  maxValue : real;
begin
  isFinish := false;
  Button2.Enabled:=false;
  Button3.Enabled:=false;
  Button7.Enabled:=false;
  Button8.Enabled:=false;
  Button9.Enabled:=false;
  Button10.Enabled:=false;
  jInput  := 3;
  jHiden  := 50;
  jOutput := 1 ;
  eMomen  := StrToFloat(edMomen.Text);
  eLR     := StrToFloat(edLR.Text);
  jLooping:= StrToInt(edEpoch.Text);
  eEmax   := StrToFloat(edEMax.Text);
  Done := false;
  ftOpsi  := ft.ItemIndex;
  {-set stringGrid- Langkah-langkahnya :
  1. ambil data dari database, suhu rata-rata pada tanggal h-1, suhu rata-rata
  pada tanggal h, dan kelembaban pada tanggal h untuk memprediksi suhu rata2 pada
  tanggal h+1
  2. kemudian siapkan stringgrid
  3. Pindahkan data dari dbgrid ke stringgrid
  }

  VijHidden.ColCount:=jHiden+1;
  VijHidden.RowCount:=jInput+2;
  VijHidden.Cells[0,0]:=' i/j';
  for i:=1 to jInput do VijHidden.Cells[0,i]:=IntToStr(i-1);
  for j:=1 to jHiden do VijHidden.Cells[j,0]:=IntToStr(j);

  WjkHidden.ColCount:=jOutput+1;
  WjkHidden.RowCount:=jHiden+2;
  WjkHidden.Cells[0,0]:='  j/k';
  for j:=1 to jOutput do WjkHidden.Cells[0,j]:=IntToStr(j-1);
  for k:=1 to jHiden do WjkHidden.Cells[k,0]:=IntToStr(k);

  YOutput.ColCount:=jOutput+2;
  YOutput.RowCount:=2;
  YOutput.Cells[0,0]:='No.';
  YOutput.Cells[1,0]:='Error';
  for i:=1 to jOutput do
   YOutput.Cells[i+1,0]:= 'Output' + IntToStr(i);


  {-Inisialisasi bobot input-hidden dan hidden-output -}
   for i:=1 to jInput do Xi[i]:=StrToFloat(Xi.Cells[1,i]);
   //Tahap awal lakukan normalisasi
   maxValue := 0.0;
   for i:=1 to jInput do
    if Xi[i] > maxValue then  maxValue := Xi[i];

   for i:=1 to jInput do  Xi[i]= Xi[i]/maxValue;
   for i:=1 to jOutput do Otarget[i]:= StrToFloat(Target.Cells[1,i]);

   RandSeed := 1000;
   for i:=1 to jInput+1 do
    for j:=1 to  jHiden do
     Vij[i-1,j]:=RandomWeight(-0.5,0.5);

   for j:=1 to jHiden+1 do
    for k:=1 to jOutput do
     Wjk[j-1,k]:=RandomWeight(-0.5,0.5);

   {-Proses pelatihan-}
   counter:=0;
   ProgressBar1.Position:=0;
   ProgressBar1.Max:=jLooping;
   ProgressBar1.Update;
   Grafiksistem.Chart1.ClearSeries;
   Repeat
      counter:=counter+1;
      for j:=1 to jHiden do
      begin
      Zin_j[j]:=0;
      for i:=1 to jInput do
       Zin_j[j]:=Zin_j[j]+Xi[i]*Vij[i,j];
       Zin_j[j]:=Zin_j[j]+Vij[0,j];
       Zj[j]:=fft(ftOpsi,Zin_j[j]);
     end;

     for k:=1 to jOutput do
     begin
     Yin_k[k]:=0;
     for j:=1 to jHiden do
      Yin_k[k]:=Yin_k[k]+Zj[j]*Wjk[j,k];
      Yin_k[k]:=Yin_k[k]+Wjk[0,k];
      Yk[k]:=fft(ftOpsi,Yin_k[k]);
     end;

     eError:=0;
     for k:=1 to jOutput do
     eError:=eError+(Otarget[k]-Yk[k])*(Otarget[k]-Yk[k]);
     eError:=0.5*eError;

     if eError> eEMax then
     begin
     for k:=1 to jOutput do
     begin
      delta_k[k]:=(Otarget[k]-Yk[k])*dft(ftOpsi,Yin_k[k]);
      for j:=1 to jHiden do
       Wjkupdate[j,k]:=eLR*delta_k[k]*Zj[j]+(Wjkupdate[j,k]*eMomen);
       Wjkupdate[0,k]:=eLR*delta_k[k];
     end;

     for j:=1 to jHiden do
     begin
     deltain_j[j]:=0;
     for k:=1 to jOutput do
       deltain_j[j]:=deltain_j[j]+delta_k[k]*Wjk[j,k];
       delta_j[j]:=deltain_j[j]*dft(ftOpsi,Zin_j[j]);
     end;

     for j:=1 to jHiden do
     begin
     for i:=1 to jInput do
       Vijupdate[i,j]:=eLR*delta_j[j]*Xi[i]+(Vij[i,j]*eMomen);
       Vijupdate[0,j]:=eLR*delta_j[j];
     end;

     for j:=0 to jHiden do
     for k:=1 to jOutput do
       Wjk[j,k]:=Wjk[j,k]+Wjkupdate[j,k];

     for i:=0 to jInput do
     for j:=1 to jHiden do
       Vij[i,j]:=Vij[i,j]+Vijupdate[i,j];
     end else
     begin
     Done:=true;
     end;

     if Done=false then
     begin
      YOutput.Cells[1,counter]:=FloatToStrF(eError,ffGeneral,6,10);
      Grafiksistem.Chart1.AddSeries(counter,eError,'');

     for i:=1 to jOutput do
      YOutput.Cells[1+i,counter]:=FloatToStrF(Yk[i],ffGeneral,6,10);
      YOutput.Cells[0,counter]:=IntToStr(counter);
     end;

     if counter>=jLooping then Done:=true;
     if Done=false then YOutput.RowCount:=YOutput.RowCount+1;

     ProgressBar1.Position:=counter;
     ProgressBar1.Update;
  until Done=true or isFinish=true;
  ProgressBar1.Position:=0;
  ProgressBar1.Update;

 {-hasil pelatihan-}
   for i:=1 to jInput+1 do
    for j:=1 to jHiden do
     VijHidden.Cells[j,i]:=FloattoStrF(Vij[i-1,j],ffGeneral,6,10);

   for j:=1 to jHiden+1 do
    for k:=1 to jOutput do
     WjkHidden.Cells[k,j]:=FloattoStrF(Wjk[j-1,k],ffGeneral,6,10);

   YOutput.Cells[1,counter]:=FloattoStrF(eError,ffGeneral,6,10);
   for i:=1 to jOutput do
    YOutput.Cells[i+1,counter]:=FloattoStrF(Yk[i],ffGeneral,6,10);
    YOutput.Cells[0,counter]:=IntToStr(counter);

    Label18.Visible:=true;
    Label19.Visible:=true;
    Label20.Visible:=true;
    XInput.Visible:=true;
    VijHidden.Visible:=true;
    WjkHidden.Visible:=true;
    YOutput.Visible:=true;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Grafiksistem.show;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  Grafiksistem.show;
end;

procedure TForm1.edPassChange(Sender: TObject);
begin

end;

end.

