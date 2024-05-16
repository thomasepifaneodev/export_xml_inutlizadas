unit XmlInutilizacao.View.Conexao;

interface

uses
  System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.PGDef,
  FireDAC.Phys.PG, Data.DB, FireDAC.Comp.Client, System.SysUtils, Vcl.Forms,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, Winapi.Windows, Vcl.Controls, Vcl.Dialogs;

type
  TdmDados = class(TDataModule)
    fdConnection: TFDConnection;
    fdPgLink: TFDPhysPgDriverLink;
    fdQuery: TFDQuery;
    procedure fdPgLinkDriverCreated(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ExportFiltroXML;
    procedure FiltroXML(DatInicial, DatFinal : String);
    procedure FiltroInutilizacao(DatInicial, DatFinal, Serie, Modelo : String; NumeroInicial, NumeroFinal, Ano : Integer);
  end;

var
  dmDados: TdmDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmDados.FiltroInutilizacao(DatInicial, DatFinal, Serie, Modelo: String; NumeroInicial, NumeroFinal, Ano : Integer);
var
  DatIni : String;
  DatFim : String;
begin
  DatIni := DatInicial;
  DatFim := DatFinal;

  fdQuery.SQL.Clear;

  fdQuery.SQL.Add('SELECT xml::VARCHAR(10000) arqxml, numeroinicial, serie, modelonf_codigo');
  fdQuery.SQL.Add('FROM inutilizacao');
  fdQuery.SQL.Add('WHERE datahora BETWEEN ' + '''' + DatIni + ' 00:00:00''' + ' AND ' + '''' + DatFim + ' 23:59:59''');
  fdQuery.SQL.Add('AND ano = ' + IntToStr(Ano));
  fdQuery.SQL.Add('AND serie = ' + '''' + Serie + '''');
  fdQuery.SQL.Add('AND modelonf_codigo = ' + '''' + Modelo + '''');
  fdQuery.SQL.Add('AND( numeroinicial BETWEEN ' + IntToStr(NumeroInicial) + ' AND ' + IntToStr(NumeroFinal));
  fdQuery.SQL.Add('OR numerofinal BETWEEN ' + IntToStr(NumeroInicial) + ' AND ' + IntToStr(NumeroFinal) + ')');

  fdQuery.Open;
end;

procedure TdmDados.FiltroXML(DatInicial, DatFinal : String);
var
  DatIni : String;
  DatFim : String;
begin
  DatIni := DatInicial;
  DatFim := DatFinal;

  fdQuery.SQL.Clear;

  fdQuery.SQL.Add('SELECT xml::VARCHAR(10000) arqxml, numeroinicial, serie, modelonf_codigo');
  fdQuery.SQL.Add('FROM inutilizacao');
  fdQuery.SQL.Add('WHERE datahora BETWEEN ' + '''' + DatIni + ' 00:00:00''' + ' AND ' + '''' + DatFim + ' 23:59:59''');

  fdQuery.Open;
end;

procedure TdmDados.ExportFiltroXML;
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
    MessageDlg('XMLs exportados com sucesso!', mtInformation, [mbOk], 0);
  end
  else
    MessageDlg('Nenhum registro encontrado para exportar.', mtWarning, [mbOk], 0);
end;

procedure TdmDados.fdPgLinkDriverCreated(Sender: TObject);
begin
    fdPgLink.VendorHome := ExtractFilePath(Application.ExeName);
end;

end.

