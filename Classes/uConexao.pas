unit uConexao;

interface

uses XmlInutilizacao.View.Conexao, System.Classes, System.SysUtils, Vcl.Forms, uLib,
  Vcl.Controls, System.UITypes, Winapi.Windows, Winapi.Messages, Vcl.Dialogs,
  FireDAC.Comp.Client;

procedure Conexao(Ip, Porta, Base : String);
procedure LoginUser(User, Pass : String);
function ReturnForm(Acao: TModalResult) : TModalResult;
function CheckUser(User, Pass : String) : Boolean;

implementation

function CheckUser(User, Pass : String) : Boolean;
var
  Check: Boolean;
  ConsultaSql : TFDQuery;
begin
    ConsultaSql := TFDQuery.Create(nil);

    ConsultaSql.Connection := dmDados.fdConnection;
    ConsultaSql.SQL.Clear;
    ConsultaSql.SQL.Add('SELECT * FROM usuarios WHERE login = :User AND pass = :Pass');
    ConsultaSql.ParamByName('User').AsString := User;
    if User = 'zeus' then
    begin
    ConsultaSql.ParamByName('Pass').AsString := Pass
    end
    else
    begin
    ConsultaSql.ParamByName('Pass').AsString := '@2t24F5D4n75Z8foE8541Gj54gS5+878a@341R5$sGa4ES5$j%D14s#5d!5';
    end;
    ConsultaSql.Open;

    if ConsultaSql.IsEmpty then
    begin
      Check := False;
    end
    else
    begin
      Check := True;
    end;

  ConsultaSql.Close;
  ConsultaSql.Free;
  Result := Check;
end;

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
    MessageDlg('Verifique as infromações do arquivo INI!', mtInformation, [mbOk], 0);
  end
  else
  begin
  dmDados.fdPgLink.VendorHome := ExtractFilePath(Application.ExeName);
  vFileName := ExtractFilePath(Application.ExeName) + 'XMLInut.ini';

  XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Clear;
  XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.UserName := User;
  if User = 'zeus' then
  begin
    XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Password := Pass;
  end
  else
  begin
    XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Password := '@2t24F5D4n75Z8foE8541Gj54gS5+878a@341R5$sGa4ES5$j%D14s#5d!5';
  end;

  XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Add('DriverID=PG');
  XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Add('Database=' + GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'BASE'));
  XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Add('Port=' + GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'PORTA'));
  XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Add('Server=' + GetValorIni(ExtractFilePath(Application.ExeName) + 'XMLInut.ini', 'CONFIGURACAO', 'SERVER'));
  XmlInutilizacao.View.Conexao.dmDados.fdConnection.Params.Add('LoginTimeout=2');

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
