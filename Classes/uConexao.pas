unit uConexao;

interface

uses XmlInutilizacao.View.Conexao, System.Classes, System.SysUtils, Vcl.Forms, uLib,
  Vcl.Controls, System.UITypes,  Winapi.Windows, Winapi.Messages;

procedure Conexao(Ip, Porta, Base : String);
procedure LoginUser(User, Pass : String);
function ReturnForm(Acao: TModalResult) : TModalResult;

implementation

function ReturnForm(Acao: TModalResult) : TModalResult;
begin
  Result := Acao;
end;
procedure LoginUser(User, Pass : String);
begin
var
  vFileName: string;
begin
  if
  (GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'BASE') = '') OR
  (GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'SERVER') = '') OR
  (GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'PORTA') = '')
  then
  begin
    Application.MessageBox('Verifique as infromações do arquivo INI!', 'XML Inutilização', MB_OK + MB_ICONWARNING);
  end
  else
  begin
  dmDados.fdPgLink.VendorHome := ExtractFilePath(Application.ExeName);
  vFileName := ExtractFilePath(Application.ExeName) + 'XMLInut.ini';

  XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Clear;
  XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.UserName := User;
  XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Password := Pass;
  XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Add('DriverID=PG');
  XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Add('Database=' + GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'BASE'));
  XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Add('Port=' + GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'PORTA'));
  XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Add('Server=' + GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'SERVER'));

  XmlInutilizacao.View.Conexao.dmDados.fdConnection.Connected := True;
  end;
end;
end;
procedure Conexao(Ip, Porta, Base : String);
var
  vFileName: string;
begin
  vFileName := ExtractFilePath(Application.ExeName) + 'XMLInut.ini';
  SetValorIni(vFileName, 'CONFIGURACAO', 'BASE', Base);
  SetValorIni(vFileName, 'CONFIGURACAO', 'SERVER', Ip);
  SetValorIni(vFileName, 'CONFIGURACAO', 'PORTA', Porta);
end;
end.
