{ *******************************************************************************
Title: T2Ti ERP
Description: Classe de controle de Logs de Importa��o de Dados.

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
@version 2.0
******************************************************************************* }
unit LogImportacaoController;

interface

uses
  Classes, SQLExpr, SysUtils, LogImportacaoVO, T2TiORM;

type
  TLogImportacaoController = class
  protected
  public
    class procedure GravarLogImportacao(pTupla: String; pErro: String);
  end;

implementation

class procedure TLogImportacaoController.GravarLogImportacao(pTupla: String; pErro: String);
var
  ObjetoLogImportacaoVO: TLogImportacaoVO;
begin
  try
    ObjetoLogImportacaoVO := TLogImportacaoVO.Create;
    ObjetoLogImportacaoVO.Registro := pTupla;
    ObjetoLogImportacaoVO.Erro := pErro;
    ObjetoLogImportacaoVO.DataImportacao := Date;
    ObjetoLogImportacaoVO.HoraImportacao := TimeToStr(Now);

    TT2TiORM.Inserir(ObjetoLogImportacaoVO);
  finally
    FreeAndNil(ObjetoLogImportacaoVO);
  end;
end;


end.
