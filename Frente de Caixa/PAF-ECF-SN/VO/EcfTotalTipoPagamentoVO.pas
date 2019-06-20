{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [ECF_TOTAL_TIPO_PAGAMENTO] 
                                                                                
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
unit EcfTotalTipoPagamentoVO;

interface

uses
  VO, Atributos, Classes, Constantes, Generics.Collections, SysUtils,
  EcfTipoPagamentoVO;

type
  [TEntity]
  [TTable('ECF_TOTAL_TIPO_PAGAMENTO')]
  TEcfTotalTipoPagamentoVO = class(TVO)
  private
    FID: Integer;
    FID_ECF_VENDA_CABECALHO: Integer;
    FID_ECF_TIPO_PAGAMENTO: Integer;
    FSERIE_ECF: String;
    FCOO: Integer;
    FCCF: Integer;
    FGNF: Integer;
    FVALOR: Extended;
    FNSU: String;
    FESTORNO: String;
    FREDE: String;
    FCARTAO_DC: String;
    FDATA_VENDA: TDateTime;
    FLOGSS: String;

    FEcfTipoPagamentoVO: TEcfTipoPagamentoVO;

  public 
    constructor Create; override;
    destructor Destroy; override;

    [TId('ID')]
    [TGeneratedValue(sAuto)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Id: Integer  read FID write FID;
    [TColumn('ID_ECF_VENDA_CABECALHO', 'Id Ecf Venda Cabecalho', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdEcfVendaCabecalho: Integer  read FID_ECF_VENDA_CABECALHO write FID_ECF_VENDA_CABECALHO;
    [TColumn('ID_ECF_TIPO_PAGAMENTO', 'Id Ecf Tipo Pagamento', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdEcfTipoPagamento: Integer  read FID_ECF_TIPO_PAGAMENTO write FID_ECF_TIPO_PAGAMENTO;
    [TColumn('SERIE_ECF', 'Serie Ecf', 160, [ldGrid, ldLookup, ldCombobox], False)]
    property SerieEcf: String  read FSERIE_ECF write FSERIE_ECF;
    [TColumn('COO', 'Coo', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Coo: Integer  read FCOO write FCOO;
    [TColumn('CCF', 'Ccf', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Ccf: Integer  read FCCF write FCCF;
    [TColumn('GNF', 'Gnf', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Gnf: Integer  read FGNF write FGNF;
    [TColumn('VALOR', 'Valor', 128, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property Valor: Extended  read FVALOR write FVALOR;
    [TColumn('NSU', 'Nsu', 240, [ldGrid, ldLookup, ldCombobox], False)]
    property Nsu: String  read FNSU write FNSU;
    [TColumn('ESTORNO', 'Estorno', 8, [ldGrid, ldLookup, ldCombobox], False)]
    property Estorno: String  read FESTORNO write FESTORNO;
    [TColumn('REDE', 'Rede', 80, [ldGrid, ldLookup, ldCombobox], False)]
    property Rede: String  read FREDE write FREDE;
    [TColumn('CARTAO_DC', 'Cartao Dc', 8, [ldGrid, ldLookup, ldCombobox], False)]
    property CartaoDc: String  read FCARTAO_DC write FCARTAO_DC;
    [TColumn('DATA_VENDA', 'Data Venda', 80, [ldGrid, ldLookup, ldCombobox], False)]
    property DataVenda: TDateTime  read FDATA_VENDA write FDATA_VENDA;
    [TColumn('LOGSS', 'Log', 8, [], False)]
    property HashRegistro: String  read FLOGSS write FLOGSS;


    [TAssociation('ID', 'ID_ECF_TIPO_PAGAMENTO')]
    property EcfTipoPagamentoVO: TEcfTipoPagamentoVO read FEcfTipoPagamentoVO write FEcfTipoPagamentoVO;

  end;


implementation

constructor TEcfTotalTipoPagamentoVO.Create;
begin
  inherited;
  FEcfTipoPagamentoVO := TEcfTipoPagamentoVO.Create;
end;

destructor TEcfTotalTipoPagamentoVO.Destroy;
begin
  FreeAndNil(FEcfTipoPagamentoVO);
  inherited;
end;

initialization
  Classes.RegisterClass(TEcfTotalTipoPagamentoVO);

finalization
  Classes.UnRegisterClass(TEcfTotalTipoPagamentoVO);

end.
