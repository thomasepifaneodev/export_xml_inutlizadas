unit XmlInutilizacao.View.Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uConexao, XmlInutilizacao.View.Conexao, uLib,
  System.ImageList, Vcl.ImgList, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons, XmlInutilizacao.View.Configuracao;

type
  TfrmLogin = class(TForm)
    edtSenha: TEdit;
    btnLogin: TButton;
    Image: TImage;
    edtUsuario: TEdit;
    btnConfig: TSpeedButton;
    ImageList: TImageList;
    procedure btnLoginClick(Sender: TObject);
    procedure edtUsuarioKeyPress(Sender: TObject; var Key: Char);
    procedure edtSenhaKeyPress(Sender: TObject; var Key: Char);
    procedure btnConfigClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.btnConfigClick(Sender: TObject);
begin
  frmConfig := TFrmConfig.Create(nil);
    try
      frmConfig.ShowModal();
    finally
      FreeAndNil(frmConfig);
    end;
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  try
    uConexao.LoginUser(edtUsuario.Text, edtSenha.Text);
    if dmDados.fdConnection.Connected then
    begin
      Close;
    end;
  except
      on e: Exception do
    begin
      Application.MessageBox('Erro! Verifique Usu�rio e/ou Senha!', 'XML Inutiliza��o', MB_OK + MB_ICONWARNING);
    end;
  end;

end;
procedure TfrmLogin.edtSenhaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 Then
  btnLoginClick(Sender)	;
end;

procedure TfrmLogin.edtUsuarioKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 Then
  edtSenha.SetFocus;
end;


end.