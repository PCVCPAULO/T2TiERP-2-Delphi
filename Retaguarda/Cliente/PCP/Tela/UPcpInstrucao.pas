{ *******************************************************************************
Title: T2Ti ERP
Description: Janela Cadastro de Instru��es da Ordem de Produ��o

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
t2ti.com@gmail.com</p>

@author Albert Eije
@version 2.0
******************************************************************************* }
unit UPcpInstrucao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, Atributos, Constantes,
  LabeledCtrls, Controller;

type
  [TFormDescription(TConstantes.MODULO_PCP, 'Instru�ao')]

  TFPcpInstrucao = class(TFTelaCadastro)
    EditDescricao: TLabeledEdit;
    EditCodigo: TLabeledEdit;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
  private
    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;

    procedure GridParaEdits; override;

  public

  end;

var
  FPcpInstrucao: TFPcpInstrucao;

implementation

{$R *.dfm}

uses
  PcpInstrucaoVO, PcpInstrucaoController;

{$REGION 'Infra'}
procedure TFPcpInstrucao.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TPcpInstrucaoVO;
  ObjetoController := TPcpInstrucaoController.Create;

  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFPcpInstrucao.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditCodigo.SetFocus;
  end;
end;

function TFPcpInstrucao.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditCodigo.SetFocus;
  end;
end;

function TFPcpInstrucao.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      TController.ExecutarMetodo('PcpInstrucaoController.TPcpInstrucaoController', 'Exclui', [IdRegistroSelecionado], 'DELETE', 'Boolean');
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
    TController.ExecutarMetodo('PcpInstrucaoController.TPcpInstrucaoController', 'Consulta', [Trim(Filtro), Pagina.ToString, False], 'GET', 'Lista');
end;

function TFPcpInstrucao.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TPcpInstrucaoVO.Create;

      TPcpInstrucaoVO(ObjetoVO).Codigo := EditCodigo.Text;
      TPcpInstrucaoVO(ObjetoVO).Descricao := EditDescricao.Text;

      if StatusTela = stInserindo then
      begin
        TController.ExecutarMetodo('PcpInstrucaoController.TPcpInstrucaoController', 'Insere', [TPcpInstrucaoVO(ObjetoVO)], 'PUT', 'Lista');
      end
      else if StatusTela = stEditando then
      begin
        if TPcpInstrucaoVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        begin
          TController.ExecutarMetodo('PcpInstrucaoController.TPcpInstrucaoController', 'Altera', [TPcpInstrucaoVO(ObjetoVO)], 'POST', 'Boolean');
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
procedure TFPcpInstrucao.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := TPcpInstrucaoVO(TController.BuscarObjeto('PcpInstrucaoController.TPcpInstrucaoController', 'ConsultaObjeto', ['ID=' + IdRegistroSelecionado.ToString], 'GET'));
  end;

  if Assigned(ObjetoVO) then
  begin
    EditCodigo.Text := TPcpInstrucaoVO(ObjetoVO).Codigo;
    EditDescricao.Text := TPcpInstrucaoVO(ObjetoVO).Descricao;

    // Serializa o objeto para consultar posteriormente se houve altera��es
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;
{$ENDREGION}


end.
