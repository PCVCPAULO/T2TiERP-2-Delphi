program ConfiguraPAFECF;

uses
  Forms,
  UConfiguracao in 'UConfiguracao.pas' {FConfiguracao},
  UDataModule in 'UDataModule.pas' {FDataModule: TDataModule},
  UConfigConexao in 'UConfigConexao.pas' {FConfigConexao},
  USplash in 'USplash.pas' {FSplash},
  UCaixa in 'UCaixa.pas' {FCaixa},
  UPropriedades in 'UPropriedades.pas' {FPropriedades},
  EcfPosicaoComponentesVO in '..\PAF-ECF\VO\EcfPosicaoComponentesVO.pas',
  VO in '..\PAF-ECF\VO\VO.pas',
  Atributos in '..\PAF-ECF\Util\Atributos.pas',
  T2TiORM in '..\PAF-ECF\Util\T2TiORM.pas',
  Biblioteca in '..\PAF-ECF\Util\Biblioteca.pas',
  Constantes in '..\PAF-ECF\Util\Constantes.pas',
  EcfConfiguracaoVO in '..\PAF-ECF\VO\EcfConfiguracaoVO.pas',
  EcfCaixaVO in '..\PAF-ECF\VO\EcfCaixaVO.pas',
  EcfConfiguracaoBalancaVO in '..\PAF-ECF\VO\EcfConfiguracaoBalancaVO.pas',
  EcfConfiguracaoLeitorSerVO in '..\PAF-ECF\VO\EcfConfiguracaoLeitorSerVO.pas',
  EcfEmpresaVO in '..\PAF-ECF\VO\EcfEmpresaVO.pas',
  EcfImpressoraVO in '..\PAF-ECF\VO\EcfImpressoraVO.pas',
  EcfRelatorioGerencialVO in '..\PAF-ECF\VO\EcfRelatorioGerencialVO.pas',
  EcfResolucaoVO in '..\PAF-ECF\VO\EcfResolucaoVO.pas',
  EcfConfiguracaoController in 'Controller\EcfConfiguracaoController.pas',
  UDataModuleConexao in '..\PAF-ECF\DataModule\UDataModuleConexao.pas' {FDataModuleConexao: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFConfiguracao, FConfiguracao);
  Application.CreateForm(TFPropriedades, FPropriedades);
  Application.Run;
end.
