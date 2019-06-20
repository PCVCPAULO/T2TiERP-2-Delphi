{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [ECF_MOVIMENTO] 
                                                                                
The MIT License                                                                 
                                                                                
Copyright: Copyright (C) 2010 T2Ti.COM                                          
                                                                                
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
@version 1.0                                                                    
*******************************************************************************}
unit EcfMovimentoVO;

interface

uses
  VO, Atributos, Classes, Constantes, Generics.Collections, SysUtils,
  EcfImpressoraVO, EcfCaixaVO, EcfEmpresaVO, EcfTurnoVO, EcfOperadorVO,
  EcfFechamentoVO, EcfSuprimentoVO, EcfSangriaVO, EcfDocumentosEmitidosVO,
  EcfRecebimentoNaoFiscalVO;

type
  [TEntity]
  [TTable('ECF_MOVIMENTO')]
  TEcfMovimentoVO = class(TVO)
  private
    FID: Integer;
    FID_ECF_EMPRESA: Integer;
    FID_ECF_TURNO: Integer;
    FID_ECF_IMPRESSORA: Integer;
    FID_ECF_OPERADOR: Integer;
    FID_ECF_CAIXA: Integer;
    FID_GERENTE_SUPERVISOR: Integer;
    FDATA_ABERTURA: TDateTime;
    FHORA_ABERTURA: String;
    FDATA_FECHAMENTO: TDateTime;
    FHORA_FECHAMENTO: String;
    FTOTAL_SUPRIMENTO: Extended;
    FTOTAL_SANGRIA: Extended;
    FTOTAL_NAO_FISCAL: Extended;
    FTOTAL_VENDA: Extended;
    FTOTAL_DESCONTO: Extended;
    FTOTAL_ACRESCIMO: Extended;
    FTOTAL_FINAL: Extended;
    FTOTAL_RECEBIDO: Extended;
    FTOTAL_TROCO: Extended;
    FTOTAL_CANCELADO: Extended;
    FSTATUS_MOVIMENTO: String;

    FNOME_CAIXA: String;
    FID_GERADO_CAIXA: Integer;
    FDATA_SINCRONIZACAO: TDateTime;
    FHORA_SINCRONIZACAO: String;

    FEcfImpressoraVO: TEcfImpressoraVO;
    FEcfCaixaVO: TEcfCaixaVO;
    FEcfEmpresaVO: TEcfEmpresaVO;
    FEcfTurnoVO: TEcfTurnoVO;
    FEcfOperadorVO: TEcfOperadorVO;
    FEcfGerenteVO: TEcfOperadorVO;

    FListaEcfFechamentoVO: TObjectList<TEcfFechamentoVO>;
    FListaEcfSuprimentoVO: TObjectList<TEcfSuprimentoVO>;
    FListaEcfSangriaVO: TObjectList<TEcfSangriaVO>;
    FListaEcfDocumentosEmitidosVO: TObjectList<TEcfDocumentosEmitidosVO>;
    FListaEcfRecebimentoNaoFiscalVO: TObjectList<TEcfRecebimentoNaoFiscalVO>;

  public
    constructor Create; override;
    destructor Destroy; override;

    [TId('ID')]
    [TGeneratedValue(sAuto)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Id: Integer  read FID write FID;
    [TColumn('ID_ECF_EMPRESA', 'Id Ecf Empresa', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdEcfEmpresa: Integer  read FID_ECF_EMPRESA write FID_ECF_EMPRESA;
    [TColumn('ID_ECF_TURNO', 'Id Ecf Turno', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdEcfTurno: Integer  read FID_ECF_TURNO write FID_ECF_TURNO;
    [TColumn('ID_ECF_IMPRESSORA', 'Id Ecf Impressora', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdEcfImpressora: Integer  read FID_ECF_IMPRESSORA write FID_ECF_IMPRESSORA;
    [TColumn('ID_ECF_OPERADOR', 'Id Ecf Operador', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdEcfOperador: Integer  read FID_ECF_OPERADOR write FID_ECF_OPERADOR;
    [TColumn('ID_ECF_CAIXA', 'Id Ecf Caixa', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdEcfCaixa: Integer  read FID_ECF_CAIXA write FID_ECF_CAIXA;
    [TColumn('ID_GERENTE_SUPERVISOR', 'Id Gerente Supervisor', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdGerenteSupervisor: Integer  read FID_GERENTE_SUPERVISOR write FID_GERENTE_SUPERVISOR;
    [TColumn('DATA_ABERTURA', 'Data Abertura', 80, [ldGrid, ldLookup, ldCombobox], False)]
    property DataAbertura: TDateTime  read FDATA_ABERTURA write FDATA_ABERTURA;
    [TColumn('HORA_ABERTURA', 'Hora Abertura', 64, [ldGrid, ldLookup, ldCombobox], False)]
    property HoraAbertura: String  read FHORA_ABERTURA write FHORA_ABERTURA;
    [TColumn('DATA_FECHAMENTO', 'Data Fechamento', 80, [ldGrid, ldLookup, ldCombobox], False)]
    property DataFechamento: TDateTime  read FDATA_FECHAMENTO write FDATA_FECHAMENTO;
    [TColumn('HORA_FECHAMENTO', 'Hora Fechamento', 64, [ldGrid, ldLookup, ldCombobox], False)]
    property HoraFechamento: String  read FHORA_FECHAMENTO write FHORA_FECHAMENTO;
    [TColumn('TOTAL_SUPRIMENTO', 'Total Suprimento', 128, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property TotalSuprimento: Extended  read FTOTAL_SUPRIMENTO write FTOTAL_SUPRIMENTO;
    [TColumn('TOTAL_SANGRIA', 'Total Sangria', 128, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property TotalSangria: Extended  read FTOTAL_SANGRIA write FTOTAL_SANGRIA;
    [TColumn('TOTAL_NAO_FISCAL', 'Total Nao Fiscal', 128, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property TotalNaoFiscal: Extended  read FTOTAL_NAO_FISCAL write FTOTAL_NAO_FISCAL;
    [TColumn('TOTAL_VENDA', 'Total Venda', 128, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property TotalVenda: Extended  read FTOTAL_VENDA write FTOTAL_VENDA;
    [TColumn('TOTAL_DESCONTO', 'Total Desconto', 128, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property TotalDesconto: Extended  read FTOTAL_DESCONTO write FTOTAL_DESCONTO;
    [TColumn('TOTAL_ACRESCIMO', 'Total Acrescimo', 128, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property TotalAcrescimo: Extended  read FTOTAL_ACRESCIMO write FTOTAL_ACRESCIMO;
    [TColumn('TOTAL_FINAL', 'Total Final', 128, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property TotalFinal: Extended  read FTOTAL_FINAL write FTOTAL_FINAL;
    [TColumn('TOTAL_RECEBIDO', 'Total Recebido', 128, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property TotalRecebido: Extended  read FTOTAL_RECEBIDO write FTOTAL_RECEBIDO;
    [TColumn('TOTAL_TROCO', 'Total Troco', 128, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property TotalTroco: Extended  read FTOTAL_TROCO write FTOTAL_TROCO;
    [TColumn('TOTAL_CANCELADO', 'Total Cancelado', 128, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property TotalCancelado: Extended  read FTOTAL_CANCELADO write FTOTAL_CANCELADO;
    [TColumn('STATUS_MOVIMENTO', 'Status Movimento', 8, [ldGrid, ldLookup, ldCombobox], False)]
    property StatusMovimento: String  read FSTATUS_MOVIMENTO write FSTATUS_MOVIMENTO;

    [TColumn('NOME_CAIXA', 'Nome Caixa', 64, [ldGrid, ldLookup, ldCombobox], False)]
    property NomeCaixa: String  read FNOME_CAIXA write FNOME_CAIXA;
    [TColumn('ID_GERADO_CAIXA', 'Id Gerado Caixa', 80, [ldGrid, ldLookup, ldCombobox], False)]
    property IdGeradoCaixa: Integer  read FID_GERADO_CAIXA write FID_GERADO_CAIXA;
    [TColumn('DATA_SINCRONIZACAO', 'Data Sinronizacao', 80, [ldGrid, ldLookup, ldCombobox], False)]
    property DataSincronizacao: TDateTime  read FDATA_SINCRONIZACAO write FDATA_SINCRONIZACAO;
    [TColumn('HORA_SINCRONIZACAO', 'Hora Sincronizacao', 64, [ldGrid, ldLookup, ldCombobox], False)]
    property HoraSincronizacao: String  read FHORA_SINCRONIZACAO write FHORA_SINCRONIZACAO;

    [TAssociation('ID', 'ID_ECF_IMPRESSORA')]
    property EcfImpressoraVO: TEcfImpressoraVO read FEcfImpressoraVO write FEcfImpressoraVO;

    [TAssociation('ID', 'ID_ECF_CAIXA')]
    property EcfCaixaVO: TEcfCaixaVO read FEcfCaixaVO write FEcfCaixaVO;

    [TAssociation('ID', 'ID_ECF_EMPRESA')]
    property EcfEmpresaVO: TEcfEmpresaVO read FEcfEmpresaVO write FEcfEmpresaVO;

    [TAssociation('ID', 'ID_ECF_TURNO')]
    property EcfTurnoVO: TEcfTurnoVO read FEcfTurnoVO write FEcfTurnoVO;

    [TAssociation('ID', 'ID_ECF_OPERADOR')]
    property EcfOperadorVO: TEcfOperadorVO read FEcfOperadorVO write FEcfOperadorVO;

    [TAssociation('ID', 'ID_GERENTE_SUPERVISOR')]
    property EcfGerenteVO: TEcfOperadorVO read FEcfGerenteVO write FEcfGerenteVO;

    [TManyValuedAssociation('ID_ECF_MOVIMENTO', 'ID')]
    property ListaEcfFechamentoVO: TObjectList<TEcfFechamentoVO> read FListaEcfFechamentoVO write FListaEcfFechamentoVO;

    [TManyValuedAssociation('ID_ECF_MOVIMENTO', 'ID')]
    property ListaEcfSuprimentoVO: TObjectList<TEcfSuprimentoVO> read FListaEcfSuprimentoVO write FListaEcfSuprimentoVO;

    [TManyValuedAssociation('ID_ECF_MOVIMENTO', 'ID')]
    property ListaEcfSangriaVO: TObjectList<TEcfSangriaVO> read FListaEcfSangriaVO write FListaEcfSangriaVO;

    [TManyValuedAssociation('ID_ECF_MOVIMENTO', 'ID')]
    property ListaEcfDocumentosEmitidosVO: TObjectList<TEcfDocumentosEmitidosVO> read FListaEcfDocumentosEmitidosVO write FListaEcfDocumentosEmitidosVO;

    [TManyValuedAssociation('ID_ECF_MOVIMENTO', 'ID')]
    property ListaEcfRecebimentoNaoFiscalVO: TObjectList<TEcfRecebimentoNaoFiscalVO> read FListaEcfRecebimentoNaoFiscalVO write FListaEcfRecebimentoNaoFiscalVO;
  end;

implementation

constructor TEcfMovimentoVO.Create;
begin
  inherited;

  FEcfImpressoraVO := TEcfImpressoraVO.Create;
  FEcfCaixaVO := TEcfCaixaVO.Create;
  FEcfEmpresaVO := TEcfEmpresaVO.Create;
  FEcfTurnoVO := TEcfTurnoVO.Create;
  FEcfOperadorVO := TEcfOperadorVO.Create;
  FEcfGerenteVO := TEcfOperadorVO.Create;

  FListaEcfFechamentoVO := TObjectList<TEcfFechamentoVO>.Create;
  FListaEcfSuprimentoVO := TObjectList<TEcfSuprimentoVO>.Create;
  FListaEcfSangriaVO := TObjectList<TEcfSangriaVO>.Create;
  FListaEcfDocumentosEmitidosVO := TObjectList<TEcfDocumentosEmitidosVO>.Create;
  FListaEcfRecebimentoNaoFiscalVO := TObjectList<TEcfRecebimentoNaoFiscalVO>.Create;
end;

destructor TEcfMovimentoVO.Destroy;
begin
  FreeAndNil(FEcfImpressoraVO);
  FreeAndNil(FEcfCaixaVO);
  FreeAndNil(FEcfEmpresaVO);
  FreeAndNil(FEcfTurnoVO);
  FreeAndNil(FEcfOperadorVO);
  FreeAndNil(FEcfGerenteVO);

  FreeAndNil(FListaEcfFechamentoVO);
  FreeAndNil(FListaEcfSuprimentoVO);
  FreeAndNil(FListaEcfSangriaVO);
  FreeAndNil(FListaEcfDocumentosEmitidosVO);
  FreeAndNil(FListaEcfRecebimentoNaoFiscalVO);

  inherited;
end;

initialization
  Classes.RegisterClass(TEcfMovimentoVO);

finalization
  Classes.UnRegisterClass(TEcfMovimentoVO);

end.
