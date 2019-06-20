{*******************************************************************************
Title: T2Ti ERP                                                                 
Description: Controller relacionado � tabela [ECF_IMPRESSORA] 
                                                                                
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
t2ti.com@gmail.com</p>

Albert Eije (T2Ti.COM)
@version 2.0
*******************************************************************************}
unit EcfImpressoraController;

interface

uses
  Classes, SysUtils, DBClient, DB, Windows, Forms, Controller, Rtti, Atributos,
  VO, EcfImpressoraVO, Generics.Collections;


type
  TEcfImpressoraController = class(TController)
  private
    class var FDataSet: TClientDataSet;
  public
    class procedure Consulta(pFiltro: String; pPagina: String; pConsultaCompleta: Boolean = False);
    class function ConsultaLista(pFiltro: String): TObjectList<TEcfImpressoraVO>;
    class procedure EcfImpressora(pFiltro: String);
    class function GetDataSet: TClientDataSet; override;
    class procedure SetDataSet(pDataSet: TClientDataSet); override;
    class procedure TratarListaRetorno(pListaObjetos: TObjectList<TVO>);
  end;

implementation

uses T2TiORM;

class procedure TEcfImpressoraController.Consulta(pFiltro: String; pPagina: String; pConsultaCompleta: Boolean);
var
  Retorno: TObjectList<TEcfImpressoraVO>;
begin
  try
    Retorno := TT2TiORM.Consultar<TEcfImpressoraVO>(pFiltro, pPagina, pConsultaCompleta);
    TratarRetorno<TEcfImpressoraVO>(Retorno);
  finally
  end;
end;

class function TEcfImpressoraController.ConsultaLista(pFiltro: String): TObjectList<TEcfImpressoraVO>;
begin
  try
    Result := TT2TiORM.Consultar<TEcfImpressoraVO>(pFiltro, '-1', True);
  finally
  end;
end;

class procedure TEcfImpressoraController.EcfImpressora(pFiltro: String);
var
  ObjetoLocal: TEcfImpressoraVO;
begin
  try
    ObjetoLocal := TT2TiORM.ConsultarUmObjeto<TEcfImpressoraVO>(pFiltro, True);
    TratarRetorno<TEcfImpressoraVO>(ObjetoLocal);
  finally
  end;
end;

class function TEcfImpressoraController.GetDataSet: TClientDataSet;
begin
  Result := FDataSet;
end;

class procedure TEcfImpressoraController.SetDataSet(pDataSet: TClientDataSet);
begin
  FDataSet := pDataSet;
end;

class procedure TEcfImpressoraController.TratarListaRetorno(pListaObjetos: TObjectList<TVO>);
begin
  try
    TratarRetorno<TEcfImpressoraVO>(TObjectList<TEcfImpressoraVO>(pListaObjetos));
  finally
    FreeAndNil(pListaObjetos);
  end;
end;

initialization
  Classes.RegisterClass(TEcfImpressoraController);

finalization
  Classes.UnRegisterClass(TEcfImpressoraController);

end.
