program XMLInut;

uses
  Vcl.Forms,
  XmlInutilizacao.View.Principal in 'src\View\XmlInutilizacao.View.Principal.pas' {frmPrincipal},
  uLib in 'Classes\uLib.pas',
  XmlInutilizacao.View.Conexao in 'src\Model\XmlInutilizacao.View.Conexao.pas' {dmDados: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TdmDados, dmDados);
  Application.Run;
end.