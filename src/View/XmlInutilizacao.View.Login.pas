unit XmlInutilizacao.View.Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uConexao, XmlInutilizacao.View.Conexao, uLib,
  System.ImageList, Vcl.ImgList, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons, XmlInutilizacao.View.Configuracao,
  AdvGlassButton;

type
  TfrmLogin = class(TForm)
    edtSenha: TEdit;
    Image: TImage;
    edtUsuario: TEdit;
    btnConfig: TSpeedButton;
    ImageList: TImageList;
    btnLogin: TSpeedButton;
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
        if e.ToString.Contains('failed: FATAL:  password authentication failed for user') then
      begin
        Application.MessageBox('Usu�rio e/ou Senha incorretos! ', 'XML Inutiliza��o', MB_OK + MB_ICONWARNING);
      end
        else if e.ToString.Contains('failed: fe_sendauth: no password supplied') then
        Application.MessageBox('Informe usu�rio e senha!', 'XML Inutiliza��o', MB_OK + MB_ICONWARNING)
      else
      begin
        Application.MessageBox('N�o foi poss�vel conectar.' + sLineBreak + 'Verifique as configura��es!', 'XML Inutiliza��o', MB_OK + MB_ICONWARNING);

          frmConfig := TFrmConfig.Create(nil);
        try
          frmConfig.ShowModal();
        finally
          FreeAndNil(frmConfig);
        end;
      end;
      end;
end;

end;
procedure TfrmLogin.edtSenhaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 Then
  begin
  Key := #0;
  btnLoginClick(Sender);
  end;
end;

procedure TfrmLogin.edtUsuarioKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 Then
  begin
  Key := #0;
  edtSenha.SetFocus;
  end;
end;

end.
