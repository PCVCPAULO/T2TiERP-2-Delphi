{*******************************************************************************
Title: T2Ti ERP
Description: Janela Cadastro de OSEquipamento

The MIT License

Copyright: Copyright (C) 2015 T2Ti.COM

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

t2ti.com@gmail.com
@author Albert Eije (T2Ti.COM)
@version 2.0
*******************************************************************************}
unit UOSEquipamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, DB, DBClient, Menus, StdCtrls, ExtCtrls, Buttons, Grids,
  DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, OSEquipamentoVO,
  OSEquipamentoController, Tipos, Atributos, Constantes, LabeledCtrls,
  Controller;

type
  [TFormDescription(TConstantes.MODULO_CADASTROS,'Situa��o Documento')]
  TFOSEquipamento = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditDescricao: TLabeledEdit;
    EditNome: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;

    //Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FOSEquipamento: TFOSEquipamento;

implementation

{$R *.dfm}

{$REGION 'Infra'}
procedure TFOSEquipamento.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TOSEquipamentoVO;
  ObjetoController := TOSEquipamentoController.Create;

  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFOSEquipamento.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditNome.SetFocus;
  end;
end;

function TFOSEquipamento.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditNome.SetFocus;
  end;
end;

function TFOSEquipamento.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      TController.ExecutarMetodo('OsEquipamentoController.TOsEquipamentoController', 'Exclui', [IdRegistroSelecionado], 'DELETE', 'Boolean');
      Result := TController.RetornoBoolean;
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    TController.ExecutarMetodo('OsEquipamentoController.TOsEquipamentoController', 'Consulta', [Trim(Filtro), Pagina.ToString, False], 'GET', 'Lista');
end;

function TFOSEquipamento.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TOSEquipamentoVO.Create;

      TOSEquipamentoVO(ObjetoVO).Nome    := EditNome.Text;
      TOSEquipamentoVO(ObjetoVO).Descricao := EditDescricao.Text;

      if StatusTela = stInserindo then
      begin
        TController.ExecutarMetodo('OsEquipamentoController.TOsEquipamentoController', 'Insere', [TOsEquipamentoVO(ObjetoVO)], 'PUT', 'Lista');
      end
      else if StatusTela = stEditando then
      begin
        if TOSEquipamentoVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        begin
          TController.ExecutarMetodo('OsEquipamentoController.TOsEquipamentoController', 'Altera', [TOsEquipamentoVO(ObjetoVO)], 'POST', 'Boolean');
        end
        else
          Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
    except
      Result := False;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFOSEquipamento.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := TOSEquipamentoVO(TController.BuscarObjeto('OsEquipamentoController.TOsEquipamentoController', 'ConsultaObjeto', ['ID=' + IdRegistroSelecionado.ToString], 'GET'));
  end;

  if Assigned(ObjetoVO) then
  begin
    EditNome.Text := TOSEquipamentoVO(ObjetoVO).Nome;
    EditDescricao.Text := TOSEquipamentoVO(ObjetoVO).Descricao;

    // Serializa o objeto para consultar posteriormente se houve altera��es
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;
{$ENDREGION}

end.
