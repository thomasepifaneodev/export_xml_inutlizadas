﻿unit XmlInutilizacao.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, uLib, Data.DB, Vcl.Grids,
  Vcl.DBGrids, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.WinXPickers,
  FireDAC.Phys.PGDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.VCLUI.Wait, XmlInutilizacao.View.Conexao;


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
    Label1: TLabel;
    Label2: TLabel;
    DatePicker1Inicial: TDatePicker;
    DatePicker2Final: TDatePicker;
    fdQuery: TFDQuery;
    lblRows: TLabel;
    procedure ButtonConectarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edt5PassKeyPress(Sender: TObject; var Key: Char);
    procedure edt1IpKeyPress(Sender: TObject; var Key: Char);
    procedure edt2PortaKeyPress(Sender: TObject; var Key: Char);
    procedure edt3BaseKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure edt4UserKeyPress(Sender: TObject; var Key: Char);
    procedure btn3ExitClick(Sender: TObject);
    procedure btn4ChecarClick(Sender: TObject);
    procedure btn1ExportClick(Sender: TObject);
  private
    { Private declarations }
    procedure DesativarControles;
    procedure AtivarControles;
    procedure FiltroXML;
    procedure ChecaSenha;
    procedure FecharApp;

  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  System.SysUtils;


{$R *.dfm}

procedure TfrmPrincipal.btn4ChecarClick(Sender: TObject);
begin
   FiltroXML;
   fdQuery.Open();
   ShowScrollBar(dbGridPrincipal.Handle,SB_VERT,False);
   lblRows.Caption := 'Total de registros: ' + dbGridPrincipal.DataSource.DataSet.RecordCount.ToString;
end;

procedure TfrmPrincipal.btn1ExportClick(Sender: TObject);
var
  i: Integer;
  XMLStream: TStringStream;
  XMLFileName, DesktopPath: string;
  StringXML : string;
begin
  if (fdQuery.RecordCount > 0) then
  begin
    DesktopPath := ExtractFilePath(Application.ExeName) + 'XMLInutilizacao\';
    if not DirectoryExists (DesktopPath) then
    ForceDirectories(DesktopPath);

    fdQuery.First;
    while not fdQuery.Eof do
    begin
      StringXML := fdQuery.FieldByName('arqxml').AsString;

      XMLStream := TStringStream.Create(StringXML, TEncoding.UTF8);

      try
        XMLFileName := DesktopPath + 'xmlInutilizacao_' +
        'modelo_' + fdQuery.FieldByName('modelonf_codigo').AsString +
        '_serie_' + fdQuery.FieldByName('serie').AsString +
        '_numero_' + fdQuery.FieldByName('numeroinicial').AsString +'.xml';

        XMLStream.SaveToFile(XMLFileName);

      finally
        XMLStream.Free;
      end;

      fdQuery.Next;
    end;
    Application.MessageBox('XMLs exportados com sucesso!', 'XML Inutilização', MB_OK + MB_ICONINFORMATION);
  end
  else
    Application.MessageBox('Nenhum registro encontrado para exportar.', 'XML Inutilização', MB_OK + MB_ICONEXCLAMATION);
end;

procedure TfrmPrincipal.btn3ExitClick(Sender: TObject);
begin
  FecharApp;
end;

procedure TfrmPrincipal.ButtonConectarClick(Sender: TObject);
begin
var
  vFileName: string;
begin
  dmDados.fdPgLink.VendorHome := ExtractFilePath(Application.ExeName);
  if ButtonConectar.Caption	= 'Desconectar' then
    try
      XmlInutilizacao.View.Conexao.dmDados.fdConnection.Connected := False;
      AtivarControles;
      Application.MessageBox('Desconectado!', 'XML Inutilização', MB_OK + MB_ICONINFORMATION);
      lblRows.Caption := '';
    except
      Application.MessageBox('Não foi possível desconectar!', 'XML Inutilização', MB_OK + MB_ICONEXCLAMATION);
    end
  else
  begin
  if (edt3Base.Text = '') or (edt2Porta.Text = '') or (edt4User.Text = '') or (edt1Ip.Text = '') or (edt5Pass.Text = '') then
      Application.MessageBox('Erro na Conexão! Preencha Todas as informações de conexão', 'Atenção', MB_OK + MB_ICONERROR)
  else
    begin
      vFileName := ExtractFilePath(Application.ExeName) + 'XMLInut.ini';

      SetValorIni(vFileName, 'CONFIGURACAO', 'BASE', edt3Base.Text);
      SetValorIni(vFileName, 'CONFIGURACAO', 'SERVER', edt1Ip.Text);
      SetValorIni(vFileName, 'CONFIGURACAO', 'USER_C', edt4User.Text);
      SetValorIni(vFileName, 'CONFIGURACAO', 'PORTA', edt2Porta.Text);

      XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Clear;
      XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.UserName := edt4User.Text;
      XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Password := edt5Pass.Text;
      XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Add('DriverID=PG');
      XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Add('Database=' + GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'BASE'));
      XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Add('Port=' + GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'PORTA'));
      XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Add('Server=' + GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'SERVER'));

    try
      XmlInutilizacao.View.Conexao.dmDados.fdConnection.Connected := True;
      DesativarControles;

      DatePicker1Inicial.Enabled := True;
      DatePicker2Final.Enabled := True;
      btn1Export.Enabled := True;
      btn4Checar.Enabled := True;

      Application.MessageBox('Conexão Realizada!', 'XML Inutilização', MB_OK + MB_ICONINFORMATION);
    except
      Application.MessageBox('Erro na Conexão! Verifique as informações de conexão!', 'XML Inutilização', MB_OK + MB_ICONWARNING);
    end;
    end;
  end;
end;
end;

procedure TfrmPrincipal.ChecaSenha;
begin
  if (edt3Base.Text <> '') or (edt2Porta.Text <> '') or (edt4User.Text <> '') or (edt1Ip.Text <> '') and (edt5Pass.Text = '') then
    edt5Pass.SetFocus
  else
    edt1Ip.SetFocus;
end;

procedure TfrmPrincipal.DesativarControles;
begin
    edt1Ip.Enabled := False;
    edt2Porta.Enabled := False;
    edt3Base.Enabled := False;
    edt4User.Enabled := False;
    edt5Pass.Enabled := False;
    ButtonConectar.Caption := 'Desconectar';
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

procedure TfrmPrincipal.AtivarControles;
begin
    edt1Ip.Enabled := True;
    edt2Porta.Enabled := True;
    edt3Base.Enabled := True;
    edt4User.Enabled := True;
    edt5Pass.Enabled := True;
    DatePicker1Inicial.Enabled := False;
    DatePicker2Final.Enabled := False;
    btn1Export.Enabled := False;
    btn4Checar.Enabled := False;		
    ButtonConectar.Caption := 'Conectar';
end;

procedure TfrmPrincipal.FecharApp;
begin
  if Application.MessageBox('Deseja realmente fechar o app?', 'XML Inutilização', MB_YESNO + MB_ICONQUESTION) = IDYES then
begin
  Application.Terminate;
end;

end;

procedure TfrmPrincipal.FiltroXML;
var
  DatIni : String; 
  DatFim : String;
begin
  DatIni := DateToStr(DatePicker1Inicial.Date);
  DatFim := DateToStr(DatePicker2Final.Date);

  fdQuery.SQL.Clear;

  fdQuery.SQL.Add('SELECT xml::VARCHAR(10000) arqxml, numeroinicial, serie, modelonf_codigo');
  fdQuery.SQL.Add('FROM inutilizacao');
  fdQuery.SQL.Add('WHERE datahora BETWEEN ' + '''' + DatIni + ' 00:00:00''' + ' AND ' + '''' + DatFim + ' 23:59:59''');

  fdQuery.Open;

end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
    edt1Ip.Text := GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'SERVER');
    edt2Porta.Text := GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'PORTA');
    edt3Base.Text := GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'BASE');
    edt4User.Text := GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'USER_C');
    edt5Pass.Text := '';
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
    ChecaSenha;
    DatePicker1Inicial.Enabled := False;
    DatePicker2Final.Enabled := False;
    btn1Export.Enabled := False;
    btn4Checar.Enabled := False;
end;

end.
