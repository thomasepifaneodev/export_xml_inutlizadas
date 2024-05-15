﻿unit XmlInutilizacao.View.Principal;

interface

uses
  Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, uLib, Data.DB, Vcl.Grids, DateUtils, XmlInutilizacao.View.Configuracao,
  Vcl.DBGrids, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.WinXPickers,
  FireDAC.Phys.PGDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.VCLUI.Wait, XmlInutilizacao.View.Conexao, uConexao,
  XmlInutilizacao.View.Login, AdvOfficeButtons, AdvGlassButton;

type
  TfrmPrincipal = class(TForm)
    pnlConection: TPanel;
    pnlBottom: TPanel;
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
    lblNinicial: TLabeledEdit;
    lblNfinal: TLabeledEdit;
    checkBox: TAdvOfficeCheckBox;
    btn4Checar: TAdvGlassButton;
    btn1Export: TAdvGlassButton;
    btn3Exit: TAdvGlassButton;

    procedure FormShow(Sender: TObject);
    procedure btn3ExitClick(Sender: TObject);
    procedure btn1ExportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure checkBoxClick(Sender: TObject);
    procedure btn4Checar_Click(Sender: TObject);
    procedure lblNfinalKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure FecharApp;
    procedure LimparCampos;
    procedure InicializarControles;
    procedure AlterarControles;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  System.SysUtils, Winapi.Windows;

{$R *.dfm}

procedure TfrmPrincipal.LimparCampos;
begin
  dbGridPrincipal.DataSource.DataSet.Close;
  lblRows.Caption := '';
end;

procedure TfrmPrincipal.FecharApp;
begin
  if Application.MessageBox('Deseja realmente fechar o aplicativo?', 'XML Inutilização', MB_YESNO + MB_ICONQUESTION) = IDYES then
begin
  Application.Terminate;
end;
end;

procedure TfrmPrincipal.InicializarControles;
begin
  lblAno.Enabled := False;
  lblModel.Enabled := False;
  lblSerie.Enabled := False;
  lblNinicial.Enabled := False;
  lblNfinal.Enabled := False;
end;

procedure TfrmPrincipal.AlterarControles;
begin
  lblAno.Enabled := True;
  lblModel.Enabled := True;
  lblSerie.Enabled := True;
  lblNinicial.Enabled := True;
  lblNfinal.Enabled := True;
end;

procedure TfrmPrincipal.btn4Checar_Click(Sender: TObject);
begin
  if checkBox.Checked then
  begin
    if (lblAno.Text = '') OR (lblModel.Text = '')  OR (lblSerie.Text = '') OR (lblNinicial.Text = '') OR (lblNfinal.Text = '') then
  begin
    Application.MessageBox('Todos os campos dos filtros devem ser preenchidos!', 'XML Inutilização', MB_OK + MB_ICONINFORMATION);
  end
  else
    dmDados.FiltroInutilizacao(DateToStr(DatePicker1Inicial.Date), DateToStr(DatePicker2Final.Date),
    lblSerie.Text, lblModel.Text, StrToInt(lblNinicial.Text), StrToInt(lblNfinal.Text), StrToInt(lblAno.Text));
  end
  else
  begin
    dmDados.FiltroXML(DateToStr(DatePicker1Inicial.Date), DateToStr(DatePicker2Final.Date));
  end;
    ShowScrollBar(dbGridPrincipal.Handle,SB_VERT,False);
    lblRows.Caption := 'Total de registros: ' + dbGridPrincipal.DataSource.DataSet.RecordCount.ToString;
end;

procedure TfrmPrincipal.checkBoxClick(Sender: TObject);
begin
  frmPrincipal.SetFocus;
  if checkBox.Checked then
  begin
  Self.SetFocus;
  AlterarControles;
  end
  else
  begin
  Self.SetFocus;
  InicializarControles;
  end;
end;

procedure TfrmPrincipal.btn1ExportClick(Sender: TObject);
begin;
  dmDados.ExportFiltroXML;
  LimparCampos;
end;

procedure TfrmPrincipal.btn3ExitClick(Sender: TObject);
begin
  FecharApp;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  if not ArquivoINIExiste(ExtractFilePath(Application.ExeName) + 'XMLInut.ini') then
  begin
  Application.MessageBox('Arquivo de configuração não encontrado!', 'XML Inutilização', MB_OK + MB_ICONWARNING);
  frmConfig := TFrmConfig.Create(nil);
    try
      frmConfig.ShowModal();
    finally
      FreeAndNil(frmConfig);
    end;
  end;
  frmLogin := TFrmLogin.Create(nil);
    try
      frmLogin.ShowModal();
      if dmDados.fdConnection.Connected then
        begin
          frmLogin.ModalResult := ReturnForm(mrOk);
        end;
      if frmLogin.ModalResult	<> mrOk then
      begin
      frmPrincipal.Free;
      Application.Terminate;
      end;
    finally
      FreeAndNil(frmLogin);
    end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  InicializarControles;
  DatePicker1Inicial.Date := Now;
  DatePicker2Final.Date := Now;
end;

procedure TfrmPrincipal.lblNfinalKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    lblAno.SetFocus;
  end;
end;
end.
