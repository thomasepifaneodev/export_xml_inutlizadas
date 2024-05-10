﻿unit XmlInutilizacao.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, uLib, Data.DB, Vcl.Grids, DateUtils,
  Vcl.DBGrids, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.WinXPickers,
  FireDAC.Phys.PGDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.VCLUI.Wait, XmlInutilizacao.View.Conexao, uConexao;

type
  TfrmPrincipal = class(TForm)
    pnlConection: TPanel;
    edt1Ip: TLabeledEdit;
    edt2Porta: TLabeledEdit;
    edt3Base: TLabeledEdit;
    edt4User: TLabeledEdit;
    edt5Pass: TLabeledEdit;
    pnlBtnConectar: TPanel;
    ButtonConectar: TSpeedButton;
    pnlBottom: TPanel;
    btn4Checar: TButton;
    btn1Export: TButton;
    btn3Exit: TButton;
    imgList: TImageList;
    pnlCentral: TPanel;
    dbGridPrincipal: TDBGrid;
    dataSource: TDataSource;
    lblFinal: TLabel;
    lblInicio: TLabel;
    DatePicker1Inicial: TDatePicker;
    DatePicker2Final: TDatePicker;
    lblRows: TLabel;
    lblAno: TLabeledEdit;
    lblModel: TLabeledEdit;
    lblSerie: TLabeledEdit;
    lblNfinal: TLabeledEdit;
    lblNinicial: TLabeledEdit;
    procedure edt5PassKeyPress(Sender: TObject; var Key: Char);
    procedure edt1IpKeyPress(Sender: TObject; var Key: Char);
    procedure edt2PortaKeyPress(Sender: TObject; var Key: Char);
    procedure edt3BaseKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure edt4UserKeyPress(Sender: TObject; var Key: Char);
    procedure btn3ExitClick(Sender: TObject);
    procedure btn4ChecarClick(Sender: TObject);
    procedure btn1ExportClick(Sender: TObject);
    procedure ButtonConectarClick(Sender: TObject);
  private
    { Private declarations }
    procedure InicializarControles;
    procedure AtualizaEstadoControles;
    procedure FecharApp;
    procedure ObterDadosIni;
    procedure ChecaCampos;
    procedure PreencherTextBoxes;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  System.SysUtils;

{$R *.dfm}

procedure TfrmPrincipal.InicializarControles;
begin
  edt1Ip.Enabled := True;
  edt2Porta.Enabled := True;
  edt3Base.Enabled := True;
  edt4User.Enabled := True;
  edt5Pass.Enabled := True;
  btn1Export.Enabled := False;
  btn4Checar.Enabled := False;
  ButtonConectar.Caption := 'Conectar';
end;

procedure TfrmPrincipal.AtualizaEstadoControles;
begin
  edt1Ip.Enabled := False;
  edt2Porta.Enabled := False;
  edt3Base.Enabled := False;
  edt4User.Enabled := False;
  edt5Pass.Enabled := False;
  DatePicker1Inicial.Enabled := True;
  DatePicker2Final.Enabled := True;
  btn1Export.Enabled := True;
  btn4Checar.Enabled := True;
  ButtonConectar.Caption := 'Desconectar';
end;

procedure TfrmPrincipal.ObterDadosIni;
begin
  edt1Ip.Text := GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'SERVER');
  edt2Porta.Text := GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'PORTA');
  edt3Base.Text := GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'BASE');
  edt4User.Text := GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'USER_C');
end;

procedure TfrmPrincipal.PreencherTextBoxes;
begin
  lblAno.Text := IntToStr(YearOf(Now));
  lblModel.Text := '55';
  lblSerie.Text := '1';
  lblNinicial.Text := '1';
  lblNfinal.Text := '1';
end;

procedure TfrmPrincipal.FecharApp;
begin
  if Application.MessageBox('Deseja realmente fechar o app?', 'XML Inutilização', MB_YESNO + MB_ICONQUESTION) = IDYES then
begin
  Application.Terminate;
end;
end;

procedure TfrmPrincipal.btn4ChecarClick(Sender: TObject);
begin
  if (lblAno.Text <> '') AND (lblModel.Text <> '')  AND (lblSerie.Text <> '') AND (lblNinicial.Text <> '') AND (lblNfinal.Text <> '') then

  dmDados.FiltroInutilizacao(DateToStr(DatePicker1Inicial.Date), DateToStr(DatePicker2Final.Date),
  lblSerie.Text, lblModel.Text, StrToInt(lblNinicial.Text), StrToInt(lblNfinal.Text), StrToInt(lblAno.Text))

  else
  begin

  dmDados.FiltroXML(DateToStr(DatePicker1Inicial.Date), DateToStr(DatePicker2Final.Date));

  end;

  ShowScrollBar(dbGridPrincipal.Handle,SB_VERT,False);
  lblRows.Caption := 'Total de registros: ' + dbGridPrincipal.DataSource.DataSet.RecordCount.ToString;
end;

procedure TfrmPrincipal.ButtonConectarClick(Sender: TObject);
begin
  if ButtonConectar.Caption = 'Desconectar' then
  begin
    dmDados.fdConnection.Connected := False;
    Application.MessageBox('Desconectado!', 'XML Inutilização', MB_OK + MB_ICONINFORMATION);
    InicializarControles;
  end
  else
  try
    uConexao.Conexao(edt1Ip.Text, edt2Porta.Text, edt3Base.Text, edt4User.Text, edt5Pass.Text);
    AtualizaEstadoControles;
    if dmDados.fdConnection.Connected then
    begin
      Application.MessageBox('Conexão Realizada!', 'XML Inutilização', MB_OK + MB_ICONINFORMATION);
    end;
  except
    on e: Exception do
    begin
      Application.MessageBox('Erro na Conexão!', 'XML Inutilização', MB_OK + MB_ICONWARNING);
    end;
  end;
end;

procedure TfrmPrincipal.ChecaCampos;
begin
  if (edt3Base.Text <> '') or (edt2Porta.Text <> '') or (edt4User.Text <> '') or (edt1Ip.Text <> '') and (edt5Pass.Text = '') then
    edt5Pass.SetFocus
  else
    edt1Ip.SetFocus;
end;

procedure TfrmPrincipal.btn1ExportClick(Sender: TObject);
begin;
  dmDados.ExportFiltroXML;
end;

procedure TfrmPrincipal.btn3ExitClick(Sender: TObject);
begin
  FecharApp;
end;

procedure TfrmPrincipal.edt1IpKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 Then
  edt2Porta.SetFocus;
end;

procedure TfrmPrincipal.edt2PortaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 Then
  edt3Base.SetFocus;
end;

procedure TfrmPrincipal.edt3BaseKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 Then
  edt4User.SetFocus;
end;

procedure TfrmPrincipal.edt4UserKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 Then
  edt5Pass.SetFocus;
end;

procedure TfrmPrincipal.edt5PassKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 Then
  ButtonConectarClick(Sender);
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  ObterDadosIni;
  InicializarControles;
  ChecaCampos;
  DatePicker1Inicial.Date := Now;
  DatePicker2Final.Date := Now;
  PreencherTextBoxes;
end;
end.
