unit XmlInutilizacao.View.Configuracao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uConexao, uLib,
  System.ImageList, Vcl.ImgList;

type
  TfrmConfig = class(TForm)
    edtIp: TEdit;
    edtPorta: TEdit;
    edtBase: TEdit;
    btnConfirmar: TButton;
    ImageList: TImageList;
    procedure btnConfirmarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtIpKeyPress(Sender: TObject; var Key: Char);
    procedure edtPortaKeyPress(Sender: TObject; var Key: Char);
    procedure edtBaseKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfig: TfrmConfig;

implementation

{$R *.dfm}

procedure TfrmConfig.btnConfirmarClick(Sender: TObject);
begin
  Conexao(edtIp.Text , edtPorta.Text, edtBase.Text);
  Application.MessageBox('Configuração salva!', 'XML Inutilização', MB_OK + MB_ICONINFORMATION);
  Close;
end;

procedure TfrmConfig.edtBaseKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 Then
  btnConfirmarClick(Sender)	;
end;

procedure TfrmConfig.edtIpKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 Then
  edtPorta.SetFocus;
end;

procedure TfrmConfig.edtPortaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 Then
  edtBase.SetFocus;
end;

procedure TfrmConfig.FormShow(Sender: TObject);
begin
  if GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'SERVER') = '' then
  begin
    edtIp.Text := '127.0.0.1'
  end
  else
  begin
    edtIp.Text := GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'SERVER');
    edtPorta.Text := GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'PORTA');
    edtBase.Text := GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'BASE');
  end;
end;
end.
