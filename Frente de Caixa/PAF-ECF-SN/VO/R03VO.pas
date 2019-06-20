{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [R03] 
                                                                                
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
unit R03VO;

interface

uses
  VO, Atributos, Classes, Constantes, Generics.Collections, SysUtils;

type
  [TEntity]
  [TTable('R03')]
  TR03VO = class(TVO)
  private
    FID: Integer;
    FID_R02: Integer;
    FSERIE_ECF: String;
    FTOTALIZADOR_PARCIAL: String;
    FVALOR_ACUMULADO: Extended;
    FCRZ: Integer;
    FLOGSS: String;

  public 
    [TId('ID')]
    [TGeneratedValue(sAuto)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Id: Integer  read FID write FID;
    [TColumn('ID_R02', 'Id R02', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdR02: Integer  read FID_R02 write FID_R02;
    [TColumn('SERIE_ECF', 'Serie Ecf', 160, [ldGrid, ldLookup, ldCombobox], False)]
    property SerieEcf: String  read FSERIE_ECF write FSERIE_ECF;
    [TColumn('TOTALIZADOR_PARCIAL', 'Totalizador Parcial', 80, [ldGrid, ldLookup, ldCombobox], False)]
    property TotalizadorParcial: String  read FTOTALIZADOR_PARCIAL write FTOTALIZADOR_PARCIAL;
    [TColumn('VALOR_ACUMULADO', 'Valor Acumulado', 128, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property ValorAcumulado: Extended  read FVALOR_ACUMULADO write FVALOR_ACUMULADO;
    [TColumn('CRZ', 'Crz', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Crz: Integer  read FCRZ write FCRZ;
    [TColumn('LOGSS', 'Log', 8, [], False)]
    property HashRegistro: String  read FLOGSS write FLOGSS;

  end;

implementation


initialization
  Classes.RegisterClass(TR03VO);

finalization
  Classes.UnRegisterClass(TR03VO);

end.
