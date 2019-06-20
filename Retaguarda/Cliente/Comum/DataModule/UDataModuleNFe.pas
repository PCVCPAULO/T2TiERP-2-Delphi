unit UDataModuleNFe;

interface

uses
  SysUtils, Classes, DB, DBClient, WideStrings, DBXMySql, FMTBcd, Provider,
  SqlExpr, Biblioteca;

type
  TFDataModuleNFe = class(TDataModule)
    CDSVolumes: TClientDataSet;
    DSVolumes: TDataSource;
    CDSNfReferenciada: TClientDataSet;
    DSNfReferenciada: TDataSource;
    CDSCteReferenciado: TClientDataSet;
    DSCteReferenciado: TDataSource;
    CDSNfRuralReferenciada: TClientDataSet;
    DSNfRuralReferenciada: TDataSource;
    CDSCupomReferenciado: TClientDataSet;
    DSCupomReferenciado: TDataSource;
    CDSDuplicata: TClientDataSet;
    DSDuplicata: TDataSource;
    CDSNfeReferenciada: TClientDataSet;
    DSNfeReferenciada: TDataSource;
    CDSNfeDetalhe: TClientDataSet;
    DSNfeDetalhe: TDataSource;
    CDSReboque: TClientDataSet;
    DSReboque: TDataSource;
    CDSNfeImpostoCofins: TClientDataSet;
    DSNfeImpostoCofins: TDataSource;
    CDSNfeImpostoIcms: TClientDataSet;
    DSNfeImpostoIcms: TDataSource;
    CDSNfeImpostoImportacao: TClientDataSet;
    DSNfeImpostoImportacao: TDataSource;
    CDSNfeImpostoIpi: TClientDataSet;
    DSNfeImpostoIpi: TDataSource;
    CDSNfeImpostoIssqn: TClientDataSet;
    DSNfeImpostoIssqn: TDataSource;
    CDSNfeImpostoPis: TClientDataSet;
    DSNfeImpostoPis: TDataSource;
    CDSNfeDeclaracaoImportacao: TClientDataSet;
    DSNfeDeclaracaoImportacao: TDataSource;
    CDSNfeImportacaoDetalhe: TClientDataSet;
    DSNfeImportacaoDetalhe: TDataSource;
    CDSNfeDetalheVeiculo: TClientDataSet;
    DSNfeDetalheVeiculo: TDataSource;
    CDSNfeDetalheArmamento: TClientDataSet;
    DSNfeDetalheArmamento: TDataSource;
    CDSNfeDetalheCombustivel: TClientDataSet;
    DSNfeDetalheCombustivel: TDataSource;
    CDSNfeDetalheMedicamento: TClientDataSet;
    DSNfeDetalheMedicamento: TDataSource;
    CDSVolumesLacres: TClientDataSet;
    DSVolumesLacres: TDataSource;
    CDSNfeNumero: TClientDataSet;
    DSNfeNumero: TDataSource;
    procedure ControlaPersistencia(pDataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDataModuleNFe: TFDataModuleNFe;

implementation

uses
  NfeDetalheImpostoCofinsVO, NfeDetalheImpostoIcmsVO, NfeNumeroVO,
  NfeDetalheImpostoPisVO, NfeDetalheImpostoIiVO, NfeDetalheImpostoIssqnVO,
  NfeDetalheImpostoIpiVO, NfeDeclaracaoImportacaoVO, NfeImportacaoDetalheVO,
  NfeDetEspecificoVeiculoVO, NfeDetEspecificoCombustivelVO;

{$R *.dfm}

{ TFDataModuleNFe }

procedure TFDataModuleNFe.ControlaPersistencia(pDataSet: TDataSet);
begin
  pDataSet.FieldByName('PERSISTE').AsString := 'S';
end;

procedure TFDataModuleNFe.DataModuleCreate(Sender: TObject);
begin
  ConfiguraCDSFromVO(CDSNfeImpostoIcms, TNfeDetalheImpostoIcmsVO);
  CDSNfeImpostoIcms.IndexFieldNames := 'ID_NFE_DETALHE';
  CDSNfeImpostoIcms.MasterSource := DSNfeDetalhe;
  CDSNfeImpostoIcms.MasterFields := 'ID';

  ConfiguraCDSFromVO(CDSNfeImpostoPis, TNfeDetalheImpostoPisVO);
  CDSNfeImpostoPis.IndexFieldNames := 'ID_NFE_DETALHE';
  CDSNfeImpostoPis.MasterSource := DSNfeDetalhe;
  CDSNfeImpostoPis.MasterFields := 'ID';

  ConfiguraCDSFromVO(CDSNfeImpostoCofins, TNfeDetalheImpostoCofinsVO);
  CDSNfeImpostoCofins.IndexFieldNames := 'ID_NFE_DETALHE';
  CDSNfeImpostoCofins.MasterSource := DSNfeDetalhe;
  CDSNfeImpostoCofins.MasterFields := 'ID';

  ConfiguraCDSFromVO(CDSNfeImpostoIpi, TNfeDetalheImpostoIpiVO);
  CDSNfeImpostoIpi.IndexFieldNames := 'ID_NFE_DETALHE';
  CDSNfeImpostoIpi.MasterSource := DSNfeDetalhe;
  CDSNfeImpostoIpi.MasterFields := 'ID';

  ConfiguraCDSFromVO(CDSNfeImpostoImportacao, TNfeDetalheImpostoIiVO);
  CDSNfeImpostoImportacao.IndexFieldNames := 'ID_NFE_DETALHE';
  CDSNfeImpostoImportacao.MasterSource := DSNfeDetalhe;
  CDSNfeImpostoImportacao.MasterFields := 'ID';

  ConfiguraCDSFromVO(CDSNfeImpostoIssqn, TNfeDetalheImpostoIssqnVO);
  CDSNfeImpostoIssqn.IndexFieldNames := 'ID_NFE_DETALHE';
  CDSNfeImpostoIssqn.MasterSource := DSNfeDetalhe;
  CDSNfeImpostoIssqn.MasterFields := 'ID';

  ConfiguraCDSFromVO(CDSNfeDetalheCombustivel, TNfeDetEspecificoCombustivelVO);
  CDSNfeDetalheCombustivel.IndexFieldNames := 'ID_NFE_DETALHE';
  CDSNfeDetalheCombustivel.MasterSource := DSNfeDetalhe;
  CDSNfeDetalheCombustivel.MasterFields := 'ID';

  ConfiguraCDSFromVO(CDSNfeDetalheVeiculo, TNfeDetEspecificoVeiculoVO);
  CDSNfeDetalheVeiculo.IndexFieldNames := 'ID_NFE_DETALHE';
  CDSNfeDetalheVeiculo.MasterSource := DSNfeDetalhe;
  CDSNfeDetalheVeiculo.MasterFields := 'ID';

  ConfiguraCDSFromVO(CDSNfeNumero, TNfeNumeroVO);
end;

end.
