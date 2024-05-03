program XMLInut;

uses
  Vcl.Forms,
  XmlInutilizacao.View.Principal in 'src\View\XmlInutilizacao.View.Principal.pas' {frmPrincipal},
  uLib in 'Classes\uLib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
