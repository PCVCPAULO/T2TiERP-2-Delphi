{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [R06] 
                                                                                
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
unit R06VO;

interface

uses
  VO, Atributos, Classes, Constantes, Generics.Collections, SysUtils, R07VO;

type
  [TEntity]
  [TTable('R06')]
  TR06VO = class(TVO)
  private
    FID: Integer;
    FID_OPERADOR: Integer;
    FID_IMPRESSORA: Integer;
    FID_ECF_CAIXA: Integer;
    FSERIE_ECF: String;
    FCOO: Integer;
    FGNF: Integer;
    FGRG: Integer;
    FCDC: Integer;
    FDENOMINACAO: String;
    FDATA_EMISSAO: TDateTime;
    FHORA_EMISSAO: String;
    FLOGSS: String;

    FListaR07VO: TObjectList<TR07VO>;

  public 
    constructor Create; override;
    destructor Destroy; override;

    [TId('ID')]
    [TGeneratedValue(sAuto)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Id: Integer  read FID write FID;
    [TColumn('ID_OPERADOR', 'Id Operador', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdOperador: Integer  read FID_OPERADOR write FID_OPERADOR;
    [TColumn('ID_IMPRESSORA', 'Id Impressora', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdImpressora: Integer  read FID_IMPRESSORA write FID_IMPRESSORA;
    [TColumn('ID_ECF_CAIXA', 'Id Ecf Caixa', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdEcfCaixa: Integer  read FID_ECF_CAIXA write FID_ECF_CAIXA;
    [TColumn('SERIE_ECF', 'Serie Ecf', 160, [ldGrid, ldLookup, ldCombobox], False)]
    property SerieEcf: String  read FSERIE_ECF write FSERIE_ECF;
    [TColumn('COO', 'Coo', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Coo: Integer  read FCOO write FCOO;
    [TColumn('GNF', 'Gnf', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Gnf: Integer  read FGNF write FGNF;
    [TColumn('GRG', 'Grg', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Grg: Integer  read FGRG write FGRG;
    [TColumn('CDC', 'Cdc', 80, [ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Cdc: Integer  read FCDC write FCDC;
    [TColumn('DENOMINACAO', 'Denominacao', 16, [ldGrid, ldLookup, ldCombobox], False)]
    property Denominacao: String  read FDENOMINACAO write FDENOMINACAO;
    [TColumn('DATA_EMISSAO', 'Data Emissao', 80, [ldGrid, ldLookup, ldCombobox], False)]
    property DataEmissao: TDateTime  read FDATA_EMISSAO write FDATA_EMISSAO;
    [TColumn('HORA_EMISSAO', 'Hora Emissao', 64, [ldGrid, ldLookup, ldCombobox], False)]
    property HoraEmissao: String  read FHORA_EMISSAO write FHORA_EMISSAO;
    [TColumn('LOGSS', 'Log', 8, [], False)]
    property HashRegistro: String  read FLOGSS write FLOGSS;

    [TManyValuedAssociation('ID_R06', 'ID')]
    property ListaR07VO: TObjectList<TR07VO> read FListaR07VO write FListaR07VO;
  end;

implementation

constructor TR06VO.Create;
begin
  inherited;

  FListaR07VO := TObjectList<TR07VO>.Create;
end;

destructor TR06VO.Destroy;
begin
  FreeAndNil(FListaR07VO);

  inherited;
end;

initialization
  Classes.RegisterClass(TR06VO);

finalization
  Classes.UnRegisterClass(TR06VO);

end.
