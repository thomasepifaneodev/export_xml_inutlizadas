unit uConexao;

interface

uses XmlInutilizacao.View.Conexao, System.Classes, System.SysUtils, Vcl.Forms, uLib;

procedure Conexao(Ip, Porta, Base, User, Pass : String);

implementation
procedure Conexao(Ip, Porta, Base, User, Pass : String);
begin
var
  vFileName: string;
begin
  dmDados.fdPgLink.VendorHome := ExtractFilePath(Application.ExeName);
  vFileName := ExtractFilePath(Application.ExeName) + 'XMLInut.ini';

  SetValorIni(vFileName, 'CONFIGURACAO', 'BASE', Base);
  SetValorIni(vFileName, 'CONFIGURACAO', 'SERVER', Ip);
  SetValorIni(vFileName, 'CONFIGURACAO', 'USER_C', User);
  SetValorIni(vFileName, 'CONFIGURACAO', 'PORTA', Porta);

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



end.
