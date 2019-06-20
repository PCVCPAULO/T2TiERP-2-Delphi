{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [OS_ABERTURA_EQUIPAMENTO] 
                                                                                
The MIT License                                                                 
                                                                                
Copyright: Copyright (C) 2016 T2Ti.COM                                          
                                                                                
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
*******************************************************************************}
unit OsAberturaEquipamentoVO;

interface

uses
  VO, Atributos, Classes, Constantes, Generics.Collections, SysUtils;

type
  [TEntity]
  [TTable('OS_ABERTURA_EQUIPAMENTO')]
  TOsAberturaEquipamentoVO = class(TVO)
  private
    FID: Integer;
    FID_OS_EQUIPAMENTO: Integer;
    FID_OS_ABERTURA: Integer;
    FNUMERO_SERIE: String;
    FTIPO_COBERTURA: Integer;

    //Usado no lado cliente para controlar quais registros ser�o persistidos
    FPersiste: String;




  public 
    [TId('ID', [ldGrid, ldLookup, ldComboBox])]
    [TGeneratedValue(sAuto)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Id: Integer  read FID write FID;
    [TColumn('ID_OS_EQUIPAMENTO', 'Id Os Equipamento', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdOsEquipamento: Integer  read FID_OS_EQUIPAMENTO write FID_OS_EQUIPAMENTO;
    [TColumn('ID_OS_ABERTURA', 'Id Os Abertura', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdOsAbertura: Integer  read FID_OS_ABERTURA write FID_OS_ABERTURA;
    [TColumn('NUMERO_SERIE', 'Numero Serie', 400, [ldGrid, ldLookup, ldCombobox], False)]
    property NumeroSerie: String  read FNUMERO_SERIE write FNUMERO_SERIE;
    [TColumn('TIPO_COBERTURA', 'Tipo Cobertura', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property TipoCobertura: Integer  read FTIPO_COBERTURA write FTIPO_COBERTURA;


    [TColumn('PERSISTE', 'Persiste', 60, [], True)]
    property Persiste: String  read FPersiste write FPersiste;



  end;

implementation


initialization
  Classes.RegisterClass(TOsAberturaEquipamentoVO);

finalization
  Classes.UnRegisterClass(TOsAberturaEquipamentoVO);

end.
