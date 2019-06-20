{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [ECF_TIPO_PAGAMENTO] 
                                                                                
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
unit EcfTipoPagamentoVO;

interface

uses
  VO, Atributos, Classes, Constantes, Generics.Collections, SysUtils;

type
  [TEntity]
  [TTable('ECF_TIPO_PAGAMENTO')]
  TEcfTipoPagamentoVO = class(TVO)
  private
    FID: Integer;
    FCODIGO: String;
    FDESCRICAO: String;
    FTEF: String;
    FIMPRIME_VINCULADO: String;
    FPERMITE_TROCO: String;
    FTEF_TIPO_GP: String;
    FGERA_PARCELAS: String;

  public 
    [TId('ID')]
    [TGeneratedValue(sAuto)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Id: Integer  read FID write FID;
    [TColumn('CODIGO', 'Codigo', 24, [ldGrid, ldLookup, ldCombobox], False)]
    property Codigo: String  read FCODIGO write FCODIGO;
    [TColumn('DESCRICAO', 'Descricao', 160, [ldGrid, ldLookup, ldCombobox], False)]
    property Descricao: String  read FDESCRICAO write FDESCRICAO;
    [TColumn('TEF', 'Tef', 8, [ldGrid, ldLookup, ldCombobox], False)]
    property Tef: String  read FTEF write FTEF;
    [TColumn('IMPRIME_VINCULADO', 'Imprime Vinculado', 8, [ldGrid, ldLookup, ldCombobox], False)]
    property ImprimeVinculado: String  read FIMPRIME_VINCULADO write FIMPRIME_VINCULADO;
    [TColumn('PERMITE_TROCO', 'Permite Troco', 8, [ldGrid, ldLookup, ldCombobox], False)]
    property PermiteTroco: String  read FPERMITE_TROCO write FPERMITE_TROCO;
    [TColumn('TEF_TIPO_GP', 'Tef Tipo Gp', 8, [ldGrid, ldLookup, ldCombobox], False)]
    property TefTipoGp: String  read FTEF_TIPO_GP write FTEF_TIPO_GP;
    [TColumn('GERA_PARCELAS', 'Gera Parcelas', 8, [ldGrid, ldLookup, ldCombobox], False)]
    property GeraParcelas: String  read FGERA_PARCELAS write FGERA_PARCELAS;

  end;

implementation

initialization
  Classes.RegisterClass(TEcfTipoPagamentoVO);

finalization
  Classes.UnRegisterClass(TEcfTipoPagamentoVO);


end.
