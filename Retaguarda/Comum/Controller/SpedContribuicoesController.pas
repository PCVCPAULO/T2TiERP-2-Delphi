{ *******************************************************************************
Title: T2Ti ERP
Description: Controller para gera��o do arquivo Sped Contribui��es

The MIT License

Copyright: Copyright (C) 2014 T2Ti.COM

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

The author may be contacted at:
t2ti.com@gmail.com

@author Albert Eije (t2ti.com@gmail.com)
@version 2.0
******************************************************************************* }
unit SpedContribuicoesController;

interface

uses
  Forms, Classes, SQLExpr, SysUtils, Generics.Collections, Controller, DBXJSON, DBXCommon,
  Biblioteca, ACBrEFDBlocos, Constantes, ACBrEPCBlocos;

type
  TSpedContribuicoesController = class(TController)
  private
    class procedure GerarBloco0;
    class procedure GerarBlocoA;
    class procedure GerarBlocoC;
    class procedure GerarBlocoD;
    class procedure GerarBlocoF;
    class procedure GerarBlocoI;
    class procedure GerarBlocoM;
    class procedure GerarBloco1;
    class function GerarArquivoSpedContribuicoes: Boolean;
  protected
  public
    // consultar
    class function GerarSpedContribuicoes(pFiltro: String): String;
  end;

implementation

uses
  T2TiORM, UDataModule, EmpresaController,
  // VOs
  EmpresaVO, ContadorVO, UnidadeProdutoVO, ProdutoVO, EcfImpressoraVO,
  EcfNotaFiscalCabecalhoVO, NfeCupomFiscalReferenciadoVO,
  ViewSpedC321VO, ViewSpedC370VO, ViewSpedC390VO, ViewSpedC425VO, ViewSpedC490VO, EcfR02VO,
  EcfR03VO, EcfVendaCabecalhoVO, EcfVendaDetalheVO, FiscalApuracaoIcmsVO, ProdutoAlteracaoItemVO,
  ViewSpedNfeEmitenteVO, ViewSpedNfeDestinatarioVO, ViewSpedNfeItemVO, UnidadeConversaoVO,
  TributOperacaoFiscalVO, NfeTransporteVO, ViewSpedNfeDetalheVO, ViewSpedC190VO,
  ViewSpedC300VO, NfeCabecalhoVO;

{ TSpedContribuicoesController }

var
  Empresa: TEmpresaVO;
  VersaoLeiaute, TipoEscrituracao, IdEmpresa, IdContador: Integer;
  DataInicial, DataFinal, Arquivo, FiltroLocal: String;


{$REGION 'Infra'}
class function TSpedContribuicoesController.GerarSpedContribuicoes(pFiltro: String): String;
var
  ConteudoFiltro: TStringList;
begin
  try
    ConteudoFiltro := TStringList.Create;
    Split('|', pFiltro, ConteudoFiltro);
    {
      0 - Periodo Inicial
      1 - Periodo Final
      2 - Versao Leiaute
      3 - Tipo Escrituracao
      4 - IdEmpresa
      5 - IdContador
    }
    DataInicial := ConteudoFiltro[0];
    DataFinal := ConteudoFiltro[1];
    VersaoLeiaute := StrToInt(ConteudoFiltro[2]);
    TipoEscrituracao := StrToInt(ConteudoFiltro[3]);
    IdEmpresa := StrToInt(ConteudoFiltro[4]);
    IdContador := StrToInt(ConteudoFiltro[5]);
    //
    FormatSettings.DecimalSeparator := ',';
    GerarArquivoSpedContribuicoes;
    Result := Arquivo;
  finally
    FreeAndNil(ConteudoFiltro);
  end;
end;
{$ENDREGION}

{$REGION 'Gera��o Arquivo'}

{$REGION 'BLOCO 0: ABERTURA, IDENTIFICA��O E REFER�NCIAS'}
class procedure TSpedContribuicoesController.GerarBloco0;
var
  Contador: TContadorVO;
  ListaProduto: TObjectList<TViewSpedNfeItemVO>;
  ListaEmitente: TObjectList<TViewSpedNfeEmitenteVO>;
  ListaDestinatario: TObjectList<TViewSpedNfeDestinatarioVO>;
  ListaUnidade: TObjectList<TUnidadeProdutoVO>;
  ListaProdutoAlterado: TObjectList<TProdutoAlteracaoItemVO>;
  ListaOperacaoFiscal: TObjectList<TTributOperacaoFiscalVO>;
  UnidadeConversao: TUnidadeConversaoVO;
  UnidadeProduto: TUnidadeProdutoVO;
  ListaParticipante: TStringList;
  ListaSiglaUnidade: TStringList;
  i: Integer;
begin
  try
    Empresa := TEmpresaController.ConsultaObjeto('ID=' + IntToStr(IdEmpresa));
    Contador := TT2TiORM.ConsultarUmObjeto<TContadorVO>('ID=' + IntToStr(IdContador), True);
    ListaEmitente := TT2TiORM.Consultar<TViewSpedNfeEmitenteVO>('ID in (select ID_FORNECEDOR from NFE_CABECALHO where DATA_HORA_EMISSAO BETWEEN ' + QuotedStr(DataInicial) + ' and ' + QuotedStr(DataFinal) + ')', '-1', False);
    ListaDestinatario := TT2TiORM.Consultar<TViewSpedNfeDestinatarioVO>('ID in (select ID_CLIENTE from NFE_CABECALHO where DATA_HORA_EMISSAO BETWEEN ' + QuotedStr(DataInicial) + ' and ' + QuotedStr(DataFinal) + ')', '-1', False);
    ListaProduto := TT2TiORM.Consultar<TViewSpedNfeItemVO>('ID in (select ID_PRODUTO from NFE_DETALHE JOIN NFE_CABECALHO ON NFE_DETALHE.ID_NFE_CABECALHO = NFE_CABECALHO.ID' + ' where NFE_CABECALHO.DATA_HORA_EMISSAO BETWEEN ' + QuotedStr(DataInicial) + ' and ' + QuotedStr(DataFinal) + ')', '-1', False);
    ListaProdutoAlterado := TT2TiORM.Consultar<TProdutoAlteracaoItemVO>('DATA_INICIAL BETWEEN ' + QuotedStr(DataInicial) + ' and ' + QuotedStr(DataFinal), '-1', False);
    ListaOperacaoFiscal := TT2TiORM.Consultar<TTributOperacaoFiscalVO>('ID>0', '-1', False);

    with FDataModule.ACBrSpedContribuicoes.Bloco_0 do
    begin
      // REGISTRO 0000: ABERTURA DO ARQUIVO DIGITAL E IDENTIFICA��O DA PESSOA JUR�DICA
      with Registro0000New do
      begin
        COD_VER := TACBrVersaoLeiaute(VersaoLeiaute);
        TIPO_ESCRIT := TACBrTipoEscrit(TipoEscrituracao);
        //IND_SIT_ESP := indSitAbertura;
        NUM_REC_ANTERIOR := ''; //N�mero do Recibo da Escritura��o anterior a ser retificada, utilizado quando TIPO_ESCRIT for igual a 1
        NOME := Empresa.RazaoSocial;
        CNPJ := Empresa.CNPJ;
        UF := Empresa.EnderecoPrincipal.UF;
        COD_MUN := Empresa.CodigoIbgeCidade;
        //SUFRAMA := Empresa.SUFRAMA;
        IND_NAT_PJ := indNatPJSocEmpresariaGeral;
        IND_ATIV := indAtivComercio;
      end;

      // REGISTRO 0001: ABERTURA DO BLOCO 0
      with Registro0001New do
      begin
        IND_MOV := imComDados;

        // REGISTRO 0035: IDENTIFICA��O DE SOCIEDADE EM CONTA DE PARTICIPA��O � SCP
        { N�o Implementado }

        // REGISTRO 0100: DADOS DO CONTABILISTA
        with Registro0100New do
        begin
          NOME := Contador.NOME;
          CPF := Contador.CPF;
          CRC := Contador.InscricaoCrc;
          CNPJ := Contador.CNPJ;
          CEP := Contador.CEP;
          ENDERECO := Contador.Logradouro;
          NUM := Contador.Numero;
          COMPL := Contador.Complemento;
          BAIRRO := Contador.BAIRRO;
          FONE := Contador.FONE;
          FAX := Contador.FAX;
          EMAIL := Contador.EMAIL;
          COD_MUN := Contador.MunicipioIbge;
        end; // with Registro0100New do

        // REGISTRO  0110:  REGIMES  DE  APURA��O  DA  CONTRIBUI��O  SOCIAL  E  DE APROPRIA��O DE CR�DITO
        with Registro0110New do
        begin
          COD_INC_TRIB  := codEscrOpIncNaoCumulativo;
          IND_APRO_CRED := indMetodoApropriacaoDireta;
          COD_TIPO_CONT := codIndTipoConExclAliqBasica;
        end;

        // REGISTRO  0111:  TABELA  DE  RECEITA  BRUTA  MENSAL  PARA  FINS  DE  RATEIO  DE CR�DITOS COMUNS
        // REGISTRO  0120:  IDENTIFICA��O  DE  PER�ODOS  DISPENSADOS  DA  ESCRITURA��O FISCAL DIGITAL DAS CONTRIBUI��ES � EFD-CONTRIBUI��ES
        { N�o Implementados }

        // REGISTRO 0140: TABELA DE CADASTRO DE ESTABELECIMENTO
        with Registro0140New do
        begin
          COD_EST := 'MATRIZ';
          NOME := Empresa.RazaoSocial;;
          CNPJ := Empresa.CNPJ;
          UF := Empresa.EnderecoPrincipal.UF;
          IE := Empresa.InscricaoEstadual;
          COD_MUN := Empresa.CodigoIbgeCidade;
          IM := Empresa.InscricaoMunicipal;
          //SUFRAMA := Empresa.SUFRAMA;

          // REGISTRO 0145: REGIME DE APURA��O DA CONTRIBUI��O PREVIDENCI�RIA SOBRE A RECEITA BRUTA
          { N�o Implementado }

          // REGISTRO 0150: TABELA DE CADASTRO DO PARTICIPANTE
          ListaParticipante := TStringList.Create;
          if assigned(ListaEmitente) then
          begin
            for i := 0 to ListaEmitente.Count - 1 do
            begin
              with Registro0150New do
              begin
                COD_PART := 'F' + IntToStr(TViewSpedNfeEmitenteVO(ListaEmitente.Items[i]).Id);
                NOME := TViewSpedNfeEmitenteVO(ListaEmitente.Items[i]).NOME;
                COD_PAIS := '01058';
                if Length(TViewSpedNfeEmitenteVO(ListaEmitente.Items[i]).CpfCnpj) = 11 then
                  CPF := TViewSpedNfeEmitenteVO(ListaEmitente.Items[i]).CpfCnpj
                else
                  CNPJ := TViewSpedNfeEmitenteVO(ListaEmitente.Items[i]).CpfCnpj;
                IE := TViewSpedNfeEmitenteVO(ListaEmitente.Items[i]).InscricaoEstadual;
                COD_MUN := TViewSpedNfeEmitenteVO(ListaEmitente.Items[i]).CodigoMunicipio;
                //SUFRAMA := TViewSpedNfeEmitenteVO(ListaEmitente.Items[i]).SUFRAMA.ToString;
                ENDERECO := TViewSpedNfeEmitenteVO(ListaEmitente.Items[i]).Logradouro;
                NUM := TViewSpedNfeEmitenteVO(ListaEmitente.Items[i]).Numero;
                COMPL := TViewSpedNfeEmitenteVO(ListaEmitente.Items[i]).Complemento;
                BAIRRO := TViewSpedNfeEmitenteVO(ListaEmitente.Items[i]).BAIRRO;
                //
                ListaParticipante.Add(COD_PART);
              end; // with Registro0150New do
            end; // for I := 0 to ListaEmitente.Count - 1 do
          end; // if assigned(ListaEmitente) then

          if assigned(ListaDestinatario) then
          begin
            for i := 0 to ListaDestinatario.Count - 1 do
            begin
              if ListaParticipante.IndexOf(TViewSpedNfeEmitenteVO(ListaDestinatario.Items[i]).CpfCnpj) = -1 then
              begin
                with Registro0150New do
                begin
                  COD_PART := 'C' + IntToStr(TViewSpedNfeEmitenteVO(ListaDestinatario.Items[i]).Id);
                  NOME := TViewSpedNfeDestinatarioVO(ListaDestinatario.Items[i]).NOME;
                  COD_PAIS := '01058';
                  if Length(TViewSpedNfeDestinatarioVO(ListaDestinatario.Items[i]).CpfCnpj) = 11 then
                    CPF := TViewSpedNfeDestinatarioVO(ListaDestinatario.Items[i]).CpfCnpj
                  else
                    CNPJ := TViewSpedNfeDestinatarioVO(ListaDestinatario.Items[i]).CpfCnpj;
                  IE := TViewSpedNfeDestinatarioVO(ListaDestinatario.Items[i]).InscricaoEstadual;
                  COD_MUN := TViewSpedNfeDestinatarioVO(ListaDestinatario.Items[i]).CodigoMunicipio;
                  //SUFRAMA := TViewSpedNfeDestinatarioVO(ListaDestinatario.Items[i]).SUFRAMA.ToString;
                  ENDERECO := TViewSpedNfeDestinatarioVO(ListaDestinatario.Items[i]).Logradouro;
                  NUM := TViewSpedNfeDestinatarioVO(ListaDestinatario.Items[i]).Numero;
                  COMPL := TViewSpedNfeDestinatarioVO(ListaDestinatario.Items[i]).Complemento;
                  BAIRRO := TViewSpedNfeDestinatarioVO(ListaDestinatario.Items[i]).BAIRRO;
                end; // with Registro0150New do
              end;
            end; // for I := 0 to ListaDestinatario.Count - 1 do
          end; // if assigned(ListaDestinatario) then

          // REGISTRO 0200: TABELA DE IDENTIFICA��O DO ITEM (PRODUTO E SERVI�OS)
          ListaSiglaUnidade := TStringList.Create;
          ListaUnidade := TObjectList<TUnidadeProdutoVO>.Create;
          for i := 0 to ListaProduto.Count - 1 do
          begin
            with Registro0200New do
            begin
              COD_ITEM := IntToStr(TViewSpedNfeItemVO(ListaProduto.Items[i]).Id);
              DESCR_ITEM := TViewSpedNfeItemVO(ListaProduto.Items[i]).NOME;
              COD_BARRA := TViewSpedNfeItemVO(ListaProduto.Items[i]).GTIN;
              (* TEM QUE PREENCHER PARA INFORMAR NO 0205 *)
              COD_ANT_ITEM := '';
              UNID_INV := IntToStr(TViewSpedNfeItemVO(ListaProduto.Items[i]).IdUnidadeProduto);
              TIPO_ITEM := TACBrTipoItem(StrToInt(TViewSpedNfeItemVO(ListaProduto.Items[i]).TipoItemSped));
              COD_NCM := TViewSpedNfeItemVO(ListaProduto.Items[i]).NCM;
              EX_IPI := TViewSpedNfeItemVO(ListaProduto.Items[i]).ExTipi;
              COD_GEN := Copy(TViewSpedNfeItemVO(ListaProduto.Items[i]).NCM, 1, 2);
              COD_LST := TViewSpedNfeItemVO(ListaProduto.Items[i]).CodigoLst;
              ALIQ_ICMS := TViewSpedNfeItemVO(ListaProduto.Items[i]).AliquotaIcmsPaf;

              if ListaSiglaUnidade.IndexOf(IntToStr(TViewSpedNfeItemVO(ListaProduto.Items[i]).IdUnidadeProduto)) = -1 then
              begin
                ListaSiglaUnidade.Add(IntToStr(TViewSpedNfeItemVO(ListaProduto.Items[i]).IdUnidadeProduto));
                UnidadeProduto := TUnidadeProdutoVO.Create;
                UnidadeProduto.Id := TViewSpedNfeItemVO(ListaProduto.Items[i]).IdUnidadeProduto;
                UnidadeProduto.Sigla := TViewSpedNfeItemVO(ListaProduto.Items[i]).Sigla;
                ListaUnidade.Add(UnidadeProduto);
              end; // if ListaSiglaUnidade.IndexOf(IntToStr(TViewSpedNfeItemVO(ListaProduto.Items[i]).IdUnidadeProduto)) = -1 then
            end; // with Registro0200New do
          end; // for i := 0 to ListaProduto.Count - 1 do

          // REGISTRO 0190: IDENTIFICA��O DAS UNIDADES DE MEDIDA
          for i := 0 to ListaUnidade.Count - 1 do
          begin
            with Registro0190New do
            begin
              UNID := IntToStr(TUnidadeProdutoVO(ListaUnidade.Items[i]).Id);
              DESCR := TUnidadeProdutoVO(ListaUnidade.Items[i]).Sigla;
            end;
          end;

          // REGISTRO 0205: ALTERA��O DO ITEM
          for i := 0 to ListaProdutoAlterado.Count - 1 do
          begin
            with Registro0205New do
            begin
              DESCR_ANT_ITEM := TProdutoAlteracaoItemVO(ListaProdutoAlterado.Items[i]).NOME;
              DT_INI := TProdutoAlteracaoItemVO(ListaProdutoAlterado.Items[i]).DataInicial;
              DT_FIN := TProdutoAlteracaoItemVO(ListaProdutoAlterado.Items[i]).DataFinal;
              COD_ANT_ITEM := TProdutoAlteracaoItemVO(ListaProdutoAlterado.Items[i]).Codigo;
            end; // with Registro0205New do
          end; // for i := 0 to ListaProdutoAlterado.Count - 1 do
		  
		  // REGISTRO 0206: C�DIGO DE PRODUTO CONFORME TABELA PUBLICADA PELA ANP (COMBUST�VEIS)
		  { N�o Implementado }

		  // REGISTRO 0208: C�DIGO DE GRUPOS POR MARCA COMERCIAL� REFRI (BEBIDAS FRIAS).
		  { N�o Implementado }
        end;

        // REGISTRO 0400: TABELA DE NATUREZA DA OPERA��O/PRESTA��O
        for i := 0 to ListaOperacaoFiscal.Count - 1 do
        begin
          with Registro0400New do
          begin
            COD_NAT := IntToStr(TTributOperacaoFiscalVO(ListaOperacaoFiscal.Items[i]).Id);
            DESCR_NAT := TTributOperacaoFiscalVO(ListaOperacaoFiscal.Items[i]).DescricaoNaNf;
          end; // with Registro0400New do
        end; // for i := 0 to ListaOperacaoFiscal.Count - 1 do

        // REGISTRO 0450: TABELA DE INFORMA��O COMPLEMENTAR DO DOCUMENTO FISCAL
        { N�o Implementado }

        // REGISTRO 0500: PLANO DE CONTAS CONT�BEIS
        { N�o Implementado }

        // REGISTRO 0600: CENTRO DE CUSTOS
        { N�o Implementado }

      end; // with Registro0001New do
    end;
  finally
    FreeAndNil(Contador);
    FreeAndNil(ListaProduto);
    FreeAndNil(ListaEmitente);
    FreeAndNil(ListaDestinatario);
    FreeAndNil(ListaUnidade);
    FreeAndNil(ListaProdutoAlterado);
    FreeAndNil(ListaOperacaoFiscal);
    FreeAndNil(ListaParticipante);
    FreeAndNil(ListaSiglaUnidade);
  end;
end;
{$ENDREGION}

{$REGION 'BLOCO A: DOCUMENTOS FISCAIS - SERVI�OS (N�O SUJEITOS AO ICMS)'}
class procedure TSpedContribuicoesController.GerarBlocoA;
begin
  try
    with FDataModule.ACBrSpedContribuicoes.Bloco_A do
    begin
      // REGISTRO A001: ABERTURA DO BLOCO A
      with RegistroA001New do
      begin
        IND_MOV := imSemDados;
      end; // with RegistroA100New do
    end;
  finally
  end;
end;
{$ENDREGION 'BLOCO A: DOCUMENTOS FISCAIS - SERVI�OS (N�O SUJEITOS AO ICMS)'}

{$REGION 'BLOCO C: DOCUMENTOS FISCAIS I - MERCADORIAS (ICMS/IPI)'}
class procedure TSpedContribuicoesController.GerarBlocoC;
var
  ListaImpressora: TObjectList<TEcfImpressoraVO>;
  ListaNF2Cabecalho: TObjectList<TEcfNotaFiscalCabecalhoVO>;
  ListaNF2CabecalhoCanceladas: TObjectList<TEcfNotaFiscalCabecalhoVO>;
  ListaNFeCabecalho: TObjectList<TNfeCabecalhoVO>;
  ListaNFeDetalhe: TObjectList<TViewSpedNfeDetalheVO>;
  ListaNFeAnalitico: TObjectList<TViewSpedC190VO>;
  ListaCupomNFe: TObjectList<TNfeCupomFiscalReferenciadoVO>;
  ListaC300: TObjectList<TViewSpedC300VO>;
  ListaC321: TObjectList<TViewSpedC321VO>;
  ListaC370: TObjectList<TViewSpedC370VO>;
  ListaC390: TObjectList<TViewSpedC390VO>;
  ListaC425: TObjectList<TViewSpedC425VO>;
  ListaC490: TObjectList<TViewSpedC490VO>;
  ListaR02: TObjectList<TEcfR02VO>;
  ListaR03: TObjectList<TEcfR03VO>;
  ListaR04: TObjectList<TEcfVendaCabecalhoVO>;
  ListaR05: TObjectList<TEcfVendaDetalheVO>;
  i, j, k, l, m, g: Integer;
  //
  NfeTransporte: TNfeTransporteVO;
  EcfNotaFiscalCabecalho: TEcfNotaFiscalCabecalhoVO;
  Produto: TProdutoVO;
begin
  try
    with FDataModule.ACBrSpedContribuicoes.Bloco_C do
    begin
      // REGISTRO C001: ABERTURA DO BLOCO C
      with RegistroC001New do
      begin
        IND_MOV := imComDados;

        ListaNF2Cabecalho := TT2TiORM.Consultar<TEcfNotaFiscalCabecalhoVO>('DATA_EMISSAO BETWEEN ' + QuotedStr(DataInicial) + ' and ' + QuotedStr(DataFinal), '-1', False);
        ListaNF2CabecalhoCanceladas := TT2TiORM.Consultar<TEcfNotaFiscalCabecalhoVO>('CANCELADA = ' + QuotedStr('S') + ' and DATA_EMISSAO BETWEEN ' + QuotedStr(DataInicial) + ' and ' + QuotedStr(DataFinal), '-1', False);
        ListaNFeCabecalho := TT2TiORM.Consultar<TNfeCabecalhoVO>('DATA_HORA_EMISSAO BETWEEN ' + QuotedStr(DataInicial) + ' and ' + QuotedStr(DataFinal), '-1', False);

        // REGISTRO C010: IDENTIFICA��O DO ESTABELECIMENTO
        with RegistroC010New do
        begin
          CNPJ := Empresa.Cnpj;
          IND_ESCRI := IndEscriIndividualizado;     // 1 � Apura��o com base nos registros de consolida��odas opera��es por NF-e (C180 e C190) e por ECF (C490);
                                                    // 2 � Apura��o com base no registro individualizado de NF-e (C100 e C170) e de ECF (C400)

          if assigned(ListaNFeCabecalho) then
          begin
            for i := 0 to ListaNFeCabecalho.Count - 1 do
            begin
              // REGISTRO C100: NOTA FISCAL (C�DIGO 01), NOTA FISCAL AVULSA (C�DIGO 1B), NOTA FISCAL DE PRODUTOR (C�DIGO 04), NF-e (C�DIGO 55) e NFC-e (C�DIGO 65)
              with RegistroC100New do
              begin
                IND_OPER := TACBrTipoOperacao(TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).TipoOperacao);
                IND_EMIT := edEmissaoPropria;
                if TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).IdCliente > 0 then
                  COD_PART := 'C' + IntToStr(TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).IdCliente)
                else
                  COD_PART := 'F' + IntToStr(TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).IdFornecedor);
                COD_MOD := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).CodigoModelo;

                (*
                  4.1.2- Tabela Situa��o do Documento
                  C�digo Descri��o
                  00 Documento regular
                  01 Documento regular extempor�neo
                  02 Documento cancelado
                  03 Documento cancelado extempor�neo
                  04 NFe denegada
                  05 Nfe � Numera��o inutilizada
                  06 Documento Fiscal Complementar
                  07 Documento Fiscal Complementar extempor�neo.
                  08 Documento Fiscal emitido com base em Regime Especial ou Norma Espec�fica
                *)
                if TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).StatusNota = 0 then
                  COD_SIT := sdRegular
                else
                  COD_SIT := sdCancelado;
                SER := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).Serie;
                NUM_DOC := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).Numero;
                CHV_NFE := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).ChaveAcesso;
                DT_DOC := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).DataHoraEmissao;
                DT_E_S := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).DataHoraEntradaSaida;
                VL_DOC := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).ValorTotal;
                IND_PGTO := TACBrTipoPagamento(TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).IndicadorFormaPagamento);
                VL_DESC := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).ValorDesconto;
                VL_ABAT_NT := 0;
                VL_MERC := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).ValorTotalProdutos;
                //
                NfeTransporte := TT2TiORM.ConsultarUmObjeto<TNfeTransporteVO>('ID_NFE_CABECALHO=' + IntToStr(TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).Id), False);

                if assigned(NfeTransporte) then
                begin
                  IND_FRT := TACBrTipoFrete(NfeTransporte.ModalidadeFrete);
                  FreeAndNil(NfeTransporte);
                end;

                VL_FRT := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).ValorFrete;
                VL_SEG := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).ValorSeguro;
                VL_OUT_DA := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).ValorDespesasAcessorias;
                VL_BC_ICMS := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).BaseCalculoIcms;
                VL_ICMS := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).ValorIcms;
                VL_BC_ICMS_ST := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).BaseCalculoIcmsSt;
                VL_ICMS_ST := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).ValorIcmsSt;
                VL_IPI := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).ValorIpi;
                VL_PIS := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).ValorPis;
                VL_COFINS := TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).ValorCofins;
                VL_PIS_ST := 0;
                VL_COFINS_ST := 0;

                // REGISTRO C110: COMPLEMENTO  DO  DOCUMENTO  -  INFORMA��O  COMPLEMENTAR  DA NOTA FISCAL (C�DIGOS 01, 1B, 04 e 55)
                { N�o Implementado }

                // REGISTRO C111: PROCESSO REFERENCIADO
                { N�o Implementado }

                // REGISTRO  C120:  COMPLEMENTO  DO  DOCUMENTO  -  OPERA��ES DE  IMPORTA��O (C�DIGO 01)
                { N�o Implementado }

                try
                  // REGISTRO  C170:  COMPLEMENTO  DO  DOCUMENTO  -  ITENS  DO  DOCUMENTO (C�DIGOS 01, 1B, 04 e 55)
                  ListaNFeDetalhe := TT2TiORM.Consultar<TViewSpedNfeDetalheVO>('ID_NFE_CABECALHO=' + IntToStr(TNfeCabecalhoVO(ListaNFeCabecalho.Items[i]).Id), '-1', False);
                  if assigned(ListaNFeDetalhe) then
                  begin
                    for j := 0 to ListaNFeDetalhe.Count - 1 do
                    begin
                      with RegistroC170New do
                      begin
                        NUM_ITEM := IntToStr(TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).NumeroItem);
                        COD_ITEM := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).GTIN;
                        DESCR_COMPL := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).NomeProduto;
                        QTD := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).QuantidadeComercial;
                        UNID := IntToStr(TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).IdUnidadeProduto);
                        VL_ITEM := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).ValorTotal;
                        VL_DESC := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).ValorDesconto;
                        IND_MOV := mfSim;
                        //CST_ICMS := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).CstIcms;
                        CFOP := IntToStr(TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).CFOP);
                        COD_NAT := IntToStr(TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).IdTributOperacaoFiscal);
                        VL_BC_ICMS := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).BaseCalculoIcms;
                        ALIQ_ICMS := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).AliquotaIcms;
                        VL_ICMS := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).ValorIcms;
                        VL_BC_ICMS_ST := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).ValorBaseCalculoIcmsSt;
                        ALIQ_ST := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).AliquotaIcmsSt;
                        VL_ICMS_ST := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).ValorIcmsSt;
                        IND_APUR := iaMensal;
                        //CST_IPI := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).CstIpi;
                        COD_ENQ := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).EnquadramentoIpi;
                        VL_BC_IPI := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).ValorBaseCalculoIpi;
                        ALIQ_IPI := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).AliquotaIpi;
                        VL_IPI := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).ValorIpi;
                        //CST_PIS := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).CstPis;
                        VL_BC_PIS := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).ValorBaseCalculoPis;
                        ALIQ_PIS_PERC := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).AliquotaPisPercentual;
                        QUANT_BC_PIS := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).QuantidadeVendidaPis;
                        ALIQ_PIS_R := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).AliquotaPisReais;
                        VL_PIS := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).ValorPis;
                        //CST_COFINS := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).CstCofins;
                        VL_BC_COFINS := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).BaseCalculoCofins;
                        ALIQ_COFINS_PERC := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).AliquotaCofinsPercentual;
                        QUANT_BC_COFINS := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).QuantidadeVendidaCofins;
                        ALIQ_COFINS_R := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).AliquotaCofinsReais;
                        VL_COFINS := TViewSpedNfeDetalheVO(ListaNFeDetalhe.Items[j]).ValorCofins;
                        COD_CTA := '';
                      end; // with RegistroC170New do
                    end; // for j := 0 to ListaNFeDetalhe.Count - 1 do
                  end; // if Assigned(ListaNFeDetalhe) then
                finally
                  FreeAndNil(ListaNFeDetalhe);
                end;

                // REGISTRO C175: REGISTRO ANAL�TICO DO DOCUMENTO (C�DIGO 65)
                { Ser� analisado ap�s a implementa��o da NFC-e }

                // REGISTRO C180: CONSOLIDA��O  DE  NOTAS  FISCAIS  ELETR�NICAS  EMITIDAS PELA PESSOA JUR�DICA (C�DIGOS 55 e 65) � OPERA��ES DE VENDAS
                // REGISTRO C181: DETALHAMENTO DA CONSOLIDA��O � OPERA��ES DE VENDAS � PIS/PASEP
                // REGISTRO C185: DETALHAMENTO DA CONSOLIDA��O � OPERA��ES DE VENDAS � COFINS
                // REGISTRO C188: PROCESSO REFERENCIADO
                { N�o Implementados }

                // REGISTRO C190: CONSOLIDA��O DE NOTAS FISCAIS ELETR�NICAS (C�DIGO 55) � OPERA��ES  DE  AQUISI��O  COM  DIREITO  A  CR�DITO,  E  OPERA��ES  DE DEVOLU��O DE COMPRAS E VENDAS.
                // REGISTRO C191:  DETALHAMENTO  DA  CONSOLIDA��O  �  OPERA��ES  DE AQUISI��O  COM  DIREITO  A  CR�DITO,  E  OPERA��ES  DE  DEVOLU��O  DE COMPRAS E VENDAS � PIS/PASEP
                // REGISTRO C195:  DETALHAMENTO  DA  CONSOLIDA��O  -  OPERA��ES  DE AQUISI��O  COM  DIREITO  A  CR�DITO,  E  OPERA��ES  DE  DEVOLU��O  DE COMPRAS E VENDAS � COFINS
                // REGISTRO C198: PROCESSO REFERENCIADO
                // REGISTRO C199: COMPLEMENTO DO DOCUMENTO - OPERA��ESDE IMPORTA��O (C�DIGO 55)
                { N�o Implementados }

              end; // with RegistroC100New do
            end; // for i := 0 to ListaNFeCabecalho.Count - 1 do
          end; // if Assigned(ListaNFeCabecalho) then


          // REGISTRO  C380:  NOTA  FISCAL  DE  VENDA  A  CONSUMIDOR  (C�DIGO  02)  - CONSOLIDA��O DE DOCUMENTOS EMITIDOS.
          ListaC300 := TT2TiORM.Consultar<TViewSpedC300VO>('DATA_EMISSAO BETWEEN ' + QuotedStr(DataInicial) + ' and ' + QuotedStr(DataFinal), '-1', False);
          if assigned(ListaC300) then
          begin
            for i := 0 to ListaC300.Count - 1 do
            begin
              with RegistroC380New do
              begin
                COD_MOD := '2';

                FiltroLocal := '(DATA_EMISSAO BETWEEN ' + QuotedStr(DataInicial) + ' and ' + QuotedStr(DataFinal) + ')';

                EcfNotaFiscalCabecalho := TT2TiORM.ConsultarUmObjeto<TEcfNotaFiscalCabecalhoVO>('ID=' + IntToStr(TT2TiORM.SelectMin('ECF_NOTA_FISCAL_CABECALHO', FiltroLocal)), False);
                if assigned(EcfNotaFiscalCabecalho) then
                begin
                  NUM_DOC_INI := StrToInt(EcfNotaFiscalCabecalho.Numero);
                  DT_DOC_INI := EcfNotaFiscalCabecalho.DataEmissao;
                  FreeAndNil(EcfNotaFiscalCabecalho);
                end;

                EcfNotaFiscalCabecalho := TT2TiORM.ConsultarUmObjeto<TEcfNotaFiscalCabecalhoVO>('ID=' + IntToStr(TT2TiORM.SelectMax('ECF_NOTA_FISCAL_CABECALHO', FiltroLocal)), False);
                if assigned(EcfNotaFiscalCabecalho) then
                begin
                  NUM_DOC_FIN := StrToInt(EcfNotaFiscalCabecalho.Numero);
                  DT_DOC_FIN := EcfNotaFiscalCabecalho.DataEmissao;
                  FreeAndNil(EcfNotaFiscalCabecalho);
                end;

                VL_DOC := TViewSpedC300VO(ListaC300.Items[i]).SomaTotalNf;
                VL_DOC_CANC := 0; // Como pegar os valores cancelados?

                // REGISTRO C381: DETALHAMENTO DA CONSOLIDA��O � PIS/P ASEP
                // REGISTRO C385: DETALHAMENTO DA CONSOLIDA��O � COFINS
                { Exerc�cio: implementar }

                // REGISTRO C395: NOTAS FISCAIS DE VENDA A CONSUMIDOR(C�DIGOS 02, 2D, 2E e 59) � AQUISI��ES/ENTRADAS COM CR�DITO.
                // REGISTRO  C396:  ITENS  DO  DOCUMENTO  (C�DIGOS  02,  2D,  2E  e  59)  � AQUISI��ES/ENTRADAS COM CR�DITO
                { N�o Implementados }

              end; // with RegistroC380New do
            end; // for i := 0 to ListaC380.Count - 1 do
          end; // if assigned(ListaC380) then


          ListaImpressora := TT2TiORM.Consultar<TEcfImpressoraVO>('ID>0', '-1', False);
          if assigned(ListaImpressora) then
          begin
            for i := 0 to ListaImpressora.Count - 1 do
            begin
              // REGISTRO C400: EQUIPAMENTO ECF (C�DIGOS 02 e 2D)
              with RegistroC400New do
              begin
                COD_MOD := TEcfImpressoraVO(ListaImpressora.Items[i]).ModeloDocumentoFiscal;
                ECF_MOD := TEcfImpressoraVO(ListaImpressora.Items[i]).Modelo;
                ECF_FAB := TEcfImpressoraVO(ListaImpressora.Items[i]).Serie;
                ECF_CX := TEcfImpressoraVO(ListaImpressora.Items[i]).Numero;

                try
                  // verifica se existe movimento no periodo para aquele ECF
                  FiltroLocal := 'ID_IMPRESSORA=' + IntToStr(TEcfImpressoraVO(ListaImpressora.Items[i]).Id) + ' and (DATA_EMISSAO BETWEEN ' + QuotedStr(DataInicial) + ' and ' + QuotedStr(DataFinal) + ')';
                  ListaR02 := TT2TiORM.Consultar<TEcfR02VO>(FiltroLocal, '-1', False);
                  if assigned(ListaR02) then
                  begin
                    for j := 0 to ListaR02.Count - 1 do
                    begin
                      // REGISTRO C405: REDU��O Z (C�DIGOS 02 e 2D)
                      with RegistroC405New do
                      begin
                        DT_DOC := TEcfR02VO(ListaR02.Items[j]).DataMovimento;
                        CRO := TEcfR02VO(ListaR02.Items[j]).CRO;
                        CRZ := TEcfR02VO(ListaR02.Items[j]).CRZ;
                        NUM_COO_FIN := TEcfR02VO(ListaR02.Items[j]).Coo;
                        GT_FIN := TEcfR02VO(ListaR02.Items[j]).GrandeTotal;
                        VL_BRT := TEcfR02VO(ListaR02.Items[j]).VendaBruta;


                        try
                          // REGISTRO C481: RESUMO DI�RIO DE DOCUMENTOS EMITIDOSPOR ECF � PIS/PASEP (C�DIGOS 02 e 2D).
                          // REGISTRO C485: RESUMO DI�RIO DE DOCUMENTOS EMITIDOSPOR ECF � COFINS (C�DIGOS 02 e 2D)
                          FiltroLocal := 'TOTALIZADOR_PARCIAL not like ' + QuotedStr('%CAN%') + 'and TOTALIZADOR_PARCIAL not like ' + QuotedStr('%S%') + ' and (DATA_VENDA BETWEEN ' + QuotedStr(DataInicial) + ' and ' + QuotedStr(DataFinal) + ')';
                          ListaC425 := TT2TiORM.Consultar<TViewSpedC425VO>(FiltroLocal, '-1', False);
                          if assigned(ListaC425) then
                          begin
                            for l := 0 to ListaC425.Count - 1 do
                            begin
                              with RegistroC481New do
                              begin
                                //CST_PIS := ''; // De onde pegar?
                                VL_ITEM := TViewSpedC425VO(ListaC425.Items[l]).SomaItem;
                                VL_BC_PIS := 0; // De onde pegar?
                                ALIQ_PIS := 0; // De onde pegar?
                                QUANT_BC_PIS := 0; // De onde pegar?
                                ALIQ_PIS_QUANT := 0; // De onde pegar?
                                VL_PIS := TViewSpedC425VO(ListaC425.Items[l]).SomaPis;
                                COD_ITEM := IntToStr(TViewSpedC425VO(ListaC425.Items[l]).IdEcfProduto);
                              end; // with RegistroC481New do

                              with RegistroC485New do
                              begin
                                //CST_COFINS := ''; // De onde pegar?
                                VL_ITEM := TViewSpedC425VO(ListaC425.Items[l]).SomaItem;
                                VL_BC_COFINS := 0; // De onde pegar?
                                ALIQ_COFINS := 0; // De onde pegar?
                                QUANT_BC_COFINS := 0; // De onde pegar?
                                ALIQ_COFINS_QUANT := 0; // De onde pegar?
                                VL_COFINS := TViewSpedC425VO(ListaC425.Items[l]).SomaPis;
                                COD_ITEM := IntToStr(TViewSpedC425VO(ListaC425.Items[l]).IdEcfProduto);
                              end; // with RegistroC485New do

                            end; // for l := 0 to ListaC425.Count - 1 do
                          end; // if Assigned(ListaC425) then
                        finally
                          FreeAndNil(ListaC425);
                        end;

                        // REGISTRO C489: PROCESSO REFERENCIADO
                        { N�o Implementado }

                        // REGISTRO C490: CONSOLIDA��O DE DOCUMENTOS EMITIDOS  POR ECF (C�DIGOS 02, 2D, 59 e 60)
                        // REGISTRO C491:  DETALHAMENTO  DA CONSOLIDA��O DE DOCUMENTOS EMITIDOS POR ECF (C�DIGOS 02, 2D e 59) � PIS/PASEP
                        // REGISTRO C495:  DETALHAMENTO  DA CONSOLIDA��O DE DOCUMENTOS EMITIDOS POR ECF (C�DIGOS 02, 2D e 59) � COFINS
                        // REGISTRO C499: PROCESSO REFERENCIADO
                        { N�o Implementados }

                      end; // with RegistroC405New do
                    end; // for j := 0 to ListaR02.Count - 1 do
                  end; // if Assigned(ListaR02) then

                finally
                  FreeAndNil(ListaR02);
                end;

              end; // with RegistroC400New do
            end; // for i := 0 to ListaImpressora.Count - 1 do
          end; // if Assigned(ListaImpressora) then

          // REGISTRO C500:  NOTA  FISCAL/CONTA  DE  ENERGIA  EL�TRICA  (C�DIGO  06),  NOTA FISCAL/CONTA  DE  FORNECIMENTO  D'�GUA  CANALIZADA  (C�DIGO  29)  E  NOTA  FISCAL CONSUMO  FORNECIMENTO  DE  G�S  (C�DIGO  28)  E  NF-e  (C�DIGO  55)�  DOCUMENTOS  DE ENTRADA/AQUISI��O COM CR�DITO
          // REGISTRO C501: COMPLEMENTO DA OPERA��O (C�DIGOS 06,28 e 29) � PIS/PASEP
          // REGISTRO C505: COMPLEMENTO DA OPERA��O (C�DIGOS 06,28 e 29) � COFINS
          // REGISTRO C509: PROCESSO REFERENCIADO
          // REGISTRO C600:  CONSOLIDA��O  DI�RIA  DE  NOTAS  FISCAIS/CONTAS  EMITIDAS  DE ENERGIA  EL�TRICA  (C�DIGO  06),  NOTA  FISCAL/CONTA  DE  FORNECIMENTO  D'�GUA CANALIZADA (C�DIGO 29) E NOTA FISCAL/CONTA DE FORNECIMENTO DE G�S (C�DIGO 28) (EMPRESAS OBRIGADAS OU N�O OBRIGADAS AO CONVENIO ICMS 115/03) � DOCUMENTOS DE SA�DA
          // REGISTRO C601: COMPLEMENTO DA CONSOLIDA��O DI�RIA (C�DIGOS 06, 28 e 29) � DOCUMENTOS DE SA�DAS - PIS/PASEP
          // REGISTRO C605: COMPLEMENTO DA CONSOLIDA��O DI�RIA (C�DIGOS 06, 28 e 29) � DOCUMENTOS DE SA�DAS � COFINS
          // REGISTRO C609: PROCESSO REFERENCIADO
          { N�o Implementados }

          // REGISTRO C800: CUPOM FISCAL ELETR�NICO (C�DIGO 59)
          // REGISTRO C810:  DETALHAMENTO  DO  CUPOM  FISCAL  ELETR�NICO  (C�DIGO  59)  � PIS/PASEP E COFINS
          // REGISTRO C820:  DETALHAMENTO  DO  CUPOM  FISCAL  ELETR�NICO  (C�DIGO  59)  � PIS/PASEP E COFINS APURADO POR UNIDADE DE MEDIDA DEPRODUTO
          // REGISTRO C830: PROCESSO RERENCIADO
          // REGISTRO C860: IDENTIFICA��O DO EQUIPAMENTO SAT-CF-E
          // REGISTRO C870:  RESUMO  DI�RIO  DE  DOCUMENTOS  EMITIDOS POR  EQUIPAMENTO SAT-CF-E (C�DIGO 59) � PIS/PASEP E COFINS
          // REGISTRO C880:  RESUMO  DI�RIO  DE  DOCUMENTOS  EMITIDOS POR  EQUIPAMENTO SAT-CF-E (C�DIGO 59) � PIS/PASEP E COFINS APURADO POR UNIDADE DE MEDIDA DE PRODUTO
          // REGISTRO C890: PROCESSO REFERENCIADO
          (* Ser�o analisados ap�s implementa��o do SAT *)

        end;
      end; // with RegistroC001New do
    end; // with FDataModule.ACBrSpedContribuicoes.Bloco_C do
  finally
    FreeAndNil(ListaImpressora);
    FreeAndNil(ListaNF2Cabecalho);
    FreeAndNil(ListaNF2CabecalhoCanceladas);
    FreeAndNil(ListaNFeCabecalho);
    FreeAndNil(ListaC300);
    FreeAndNil(ListaC321);
    FreeAndNil(ListaC390);
  end;
end;
{$ENDREGION}

{$REGION 'BLOCO D: DOCUMENTOS FISCAIS II - SERVI�OS (ICMS)'}
class procedure TSpedContribuicoesController.GerarBlocoD;
begin
  try
    with FDataModule.ACBrSpedContribuicoes.Bloco_D do
    begin
      // REGISTRO D001: ABERTURA DO BLOCO F
      with RegistroD001New do
      begin
        IND_MOV := imSemDados
      end; // with RegistroD001New do
    end;
  finally
  end;
end;
{$ENDREGION}

{$REGION 'BLOCO F: DEMAIS DOCUMENTOS E OPERA��ES'}
class procedure TSpedContribuicoesController.GerarBlocoF;
begin
  try
    with FDataModule.ACBrSpedContribuicoes.Bloco_F do
    begin
      // REGISTRO F001: ABERTURA DO BLOCO F
      with RegistroF001New do
      begin
        IND_MOV := imSemDados
      end; // with RegistroF001New do
    end;
  finally
  end;
end;
{$ENDREGION}

{$REGION 'BLOCO I: OPERA��ES DAS INSTITUI��ES FINANCEIRAS, SEGURADORAS, ENTIDADES DE  PREVIDENCIA  PRIVADA,  OPERADORAS  DE  PLANOS  DE  ASSIST�NCIA  � SA�DE E DEMAIS PESSOAS JUR�DICAS REFERIDAS NOS �� 6�, 8�E 9�DO ART. 3�DA LEI n�9.718/98'}
class procedure TSpedContribuicoesController.GerarBlocoI;
begin
  try
    with FDataModule.ACBrSpedContribuicoes.Bloco_I do
    begin
      // REGISTRO I001: ABERTURA DO BLOCO I
      with RegistroI001New do
      begin
        IND_MOV := imSemDados
      end; // with RegistroI001New do
    end;
  finally
  end;
end;
{$ENDREGION}

{$REGION 'BLOCO M: APURA��O  DA  CONTRIBUI��O  E  CR�DITO  DO  PIS/PASEP  E DA COFINS'}
class procedure TSpedContribuicoesController.GerarBlocoM;
begin
  try
    with FDataModule.ACBrSpedContribuicoes.Bloco_M do
    begin
      // REGISTRO M001: ABERTURA DO BLOCO M
      with RegistroM001New do
      begin
        IND_MOV := imSemDados
      end; // with RegistroM001New do
    end;
  finally
  end;
end;
{$ENDREGION}

{$REGION 'BLOCO 1: COMPLEMENTO DA ESCRITURA��O � CONTROLE DE  SALDOS DE  CR�DITOS  E  DE  RETEN��ES,  OPERA��ES  EXTEMPOR�NEAS E OUTRAS INFORMA��ES'}
class procedure TSpedContribuicoesController.GerarBloco1;
var
  i: Integer;
begin
  try
    with FDataModule.ACBrSpedContribuicoes.Bloco_1 do
    begin
      // REGISTRO 1001: ABERTURA DO BLOCO 1
      with Registro1001New do
      begin
        IND_MOV := imSemDados;
      end; // with Registro1001New do
    end;
  finally
  end;
end;
{$ENDREGION}

{$REGION 'Gerar Arquivo'}
class function TSpedContribuicoesController.GerarArquivoSpedContribuicoes: Boolean;
begin
  Result := False;
  try
    try
      with FDataModule.ACBrSpedContribuicoes do
      begin
        DT_INI := TextoParaData(DataInicial);
        DT_FIN := TextoParaData(DataFinal);
      end;

      // BLOCO 0: ABERTURA, IDENTIFICA��O E REFER�NCIAS
      GerarBloco0;

      // BLOCO A: DOCUMENTOS FISCAIS - SERVI�OS (N�O SUJEITOS AO ICMS)
      {
        Ser� analisado ap�s a implementa��o da NFS-e
        Exerc�cio:
          Analisar como implementar com dados de um NF-e de servi�o.
      }
      GerarBlocoA;

      // BLOCO C: DOCUMENTOS FISCAIS I - MERCADORIAS (ICMS/IPI
      GerarBlocoC;

      // BLOCO D: DOCUMENTOS FISCAIS II - SERVI�OS (ICMS).
      // Estabelecimentos  que  efetivamente  tenham realizado as opera��es especificadas no Bloco D (presta��o ou contrata��o), relativas a servi�os de transporte de cargas e/ou de passageiros, servi�os de comunica��o e de telecomunica��o, mediante emiss�o de documento fiscal definido pela legisla��o do ICMS e do IPI, que devam ser escrituradas no Bloco D.
      { N�o Implementado }
      GerarBlocoD;

      // BLOCO F: DEMAIS DOCUMENTOS E OPERA��ES
      // Neste  bloco  ser�o  informadas  pela  pessoa  jur�dica,  as  demais  opera��es  geradoras  de  contribui��o  ou  de cr�dito,  n�o informadas nos Blocos A, C e D
      { N�o Implementado }
      GerarBlocoF;

      // BLOCO I: OPERA��ES DAS INSTITUI��ES FINANCEIRAS, SEGURADORAS, ENTIDADES DE  PREVIDENCIA  PRIVADA,  OPERADORAS  DE  PLANOS  DE  ASSIST�NCIA  � SA�DE E DEMAIS PESSOAS JUR�DICAS REFERIDAS NOS �� 6�, 8�E 9�DO ART. 3�DA LEI n�9.718/98.
      { N�o Implementado }
      GerarBlocoI;

      // BLOCO  M: APURA��O  DA  CONTRIBUI��O  E  CR�DITO  DO  PIS/PASEP  E DA COFINS
      { Gerado pelo PVA }
      GerarBlocoM;

      // BLOCO P: APURA��O DA CONTRIBUI��O PREVIDENCI�RIA SOBRE A RECEITA BRUTA (CPRB)
      { N�o Implementado }

      // BLOCO 1: COMPLEMENTO DA ESCRITURA��O � CONTROLE DE  SALDOS DE  CR�DITOS  E  DE  RETEN��ES,  OPERA��ES  EXTEMPOR�NEAS E OUTRAS INFORMA��ES
      { N�o Implementado }
      GerarBloco1;

      Arquivo := ExtractFilePath(Application.ExeName) + '\Arquivos\Sped\SpedContribuicoes' + FormatDateTime('DDMMYYYYhhmmss', Now) + '.txt';

      if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\Arquivos\Sped\') then
        ForceDirectories(ExtractFilePath(Application.ExeName) + '\Arquivos\Sped\');

      FDataModule.ACBrSpedContribuicoes.Arquivo := Arquivo;
      FDataModule.ACBrSpedContribuicoes.SaveFileTXT;

      Result := True;
    except
      Result := False;
    end;
  finally
    FreeAndNil(Empresa);
  end;
end;
{$ENDREGION}

{$ENDREGION}

initialization

Classes.RegisterClass(TSpedContribuicoesController);

finalization

Classes.UnRegisterClass(TSpedContribuicoesController);

end.
