unit uLib;

interface
  uses IniFiles, System.SysUtils, Vcl.Forms;

  procedure SetValorIni(pLocal, pSessao, pSubSessao, pValor: string);

  function GetValorIni(pLocal, pSessao, pSubSessao: string) : string;

  function ArquivoINIExiste(const NomeArquivo: string): Boolean;

implementation

  procedure SetValorIni(pLocal, pSessao, pSubSessao, pValor: string);
    var vArquivo: TIniFile;

  begin
    vArquivo := TIniFile.Create(pLocal);
    vArquivo.WriteString(pSessao, pSubSessao, pValor);
    vArquivo.Free;
  end;

  function GetValorIni(pLocal, pSessao, pSubSessao: string) : string;
    var vArquivo: TIniFile;
  begin

    vArquivo := TIniFile.Create(pLocal);
    Result := vArquivo.ReadString(pSessao, pSubSessao, '');
    vArquivo.Free;
  end;

  function ArquivoINIExiste(const NomeArquivo: string): Boolean;
  begin
    Result := FileExists(NomeArquivo);
  end;

end.

