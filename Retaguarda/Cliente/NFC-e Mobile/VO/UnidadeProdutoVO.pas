{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [UNIDADE_PRODUTO] 
                                                                                
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
unit UnidadeProdutoVO;

interface

uses
  VO, Atributos, Classes, Constantes, Generics.Collections, SysUtils;

type
  [TEntity]
  [TTable('UNIDADE_PRODUTO')]
  TUnidadeProdutoVO = class(TVO)
  private
    FID: Integer;
    FSIGLA: String;
    FDESCRICAO: String;
    FPODE_FRACIONAR: String;

  public
    [TId('ID')]
    [TGeneratedValue(sAuto)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Id: Integer  read FID write FID;
    [TColumn('SIGLA', 'Sigla', 80, [ldGrid, ldLookup, ldCombobox], False)]
    property Sigla: String  read FSIGLA write FSIGLA;
    [TColumn('DESCRICAO', 'Descricao', 450, [ldGrid, ldLookup, ldCombobox], False)]
    property Descricao: String  read FDESCRICAO write FDESCRICAO;
    [TColumn('PODE_FRACIONAR', 'Pode Fracionar', 8, [ldGrid, ldLookup, ldCombobox], False)]
    property PodeFracionar: String  read FPODE_FRACIONAR write FPODE_FRACIONAR;

  end;

implementation


initialization
  Classes.RegisterClass(TUnidadeProdutoVO);

finalization
  Classes.UnRegisterClass(TUnidadeProdutoVO);

end.
