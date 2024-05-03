unit XmlInutilizacao.View.Conexao;

interface

uses
  System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Phys.PGDef, FireDAC.Phys.PG, Data.DB, FireDAC.Comp.Client,
  System.SysUtils, Vcl.Forms;

type
  TdmDados = class(TDataModule)
    fdConnection: TFDConnection;
    fdPgLink: TFDPhysPgDriverLink;
    procedure fdPgLinkDriverCreated(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmDados: TdmDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmDados.fdPgLinkDriverCreated(Sender: TObject);
begin
    fdPgLink.VendorHome := ExtractFilePath(Application.ExeName);
end;

end.
