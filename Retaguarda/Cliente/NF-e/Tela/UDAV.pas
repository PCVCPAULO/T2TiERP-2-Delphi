{ *******************************************************************************
Title: T2Ti ERP
Description: Janela do DAV - Documento Auxiliar de Venda

The MIT License

Copyright: Copyright (C) 2014 T2Ti.COM

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

@author Albert Eije
@version 2.0
******************************************************************************* }
unit UDAV;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, LabeledCtrls, Atributos, Constantes,
  Mask, JvExMask, JvToolEdit, JvBaseEdits, DB, DBClient, Generics.Collections,
  WideStrings, DBXMySql, FMTBcd, Provider, SqlExpr, StrUtils, System.Actions,
  Vcl.ActnList, Vcl.RibbonSilverStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin,
  Vcl.ActnCtrls, Biblioteca, Controller, COMObj;

type
  [TFormDescription(TConstantes.MODULO_BALCAO, 'DAV')]

  TFDAV = class(TFTelaCadastro)
    GroupBoxDAVDetalhe: TGroupBox;
    GridDetalhe: TJvDBUltimGrid;
    CDSDetalhe: TClientDataSet;
    DSDetalhe: TDataSource;
    BevelEdits: TBevel;
    EditIdCliente: TLabeledCalcEdit;
    EditNomeCliente: TLabeledEdit;
    EditCpfCnpjCliente: TLabeledEdit;
    EditValorDesconto: TLabeledCalcEdit;
    EditValorSubTotal: TLabeledCalcEdit;
    EditValorTotal: TLabeledCalcEdit;
    EditTaxadesconto: TLabeledCalcEdit;
    ActionToolBar1: TActionToolBar;
    ActionManager: TActionManager;
    ActionIncluirItem: TAction;
    ActionExcluirItem: TAction;
    ActionAtualizarTotais: TAction;
    procedure FormCreate(Sender: TObject);
    procedure GridDetalheKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdClienteKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ActionIncluirItemExecute(Sender: TObject);
    procedure ControlaPersistencia(pDataSet: TDataSet);
    procedure GridDetalheDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ActionExcluirItemExecute(Sender: TObject);
    procedure ActionAtualizarTotaisExecute(Sender: TObject);
    procedure CDSDetalheBeforePost(DataSet: TDataSet);
    procedure ImprimirDAV;
    procedure BotaoImprimirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;
    procedure LimparCampos; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FDAV: TFDAV;
  SeqItem: Integer;

implementation

uses DAVController, DavCabecalhoVO, DAVDetalheVO, ULookup, ColaboradorVO,
  ColaboradorController, ProdutoVO, ProdutoController, ViewPessoaClienteVO,
  ViewPessoaClienteController;
{$R *.dfm}

{$REGION 'Infra'}
procedure TFDAV.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TDavCabecalhoVO;
  ObjetoController := TDAVController.Create;

  inherited;

  // Configura a Grid dos itens
  ConfiguraCDSFromVO(CDSDetalhe, TDAVDetalheVO);
  ConfiguraGridFromVO(GridDetalhe, TDAVDetalheVO);
end;

procedure TFDAV.LimparCampos;
begin
  inherited;
  SeqItem := 0;
  CDSDetalhe.EmptyDataSet;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFDAV.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditIdCliente.SetFocus;
  end;
end;

function TFDAV.DoEditar: Boolean;
begin
  if CDSGrid.FieldByName('SITUACAO').AsString <> 'P' then
  begin
    Application.MessageBox('O DAV selecionado n�o pode ser alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
    Exit(False);
  end;

  Result := inherited DoEditar;

  if Result then
  begin
    SeqItem := CDSDetalhe.RecordCount;
    EditIdCliente.SetFocus;
  end;
end;

function TFDAV.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      TController.ExecutarMetodo('DAVController.TDAVController', 'Exclui', [IdRegistroSelecionado], 'DELETE', 'Boolean');
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
    TController.ExecutarMetodo('DAVController.TDAVController', 'Consulta', [Trim(Filtro), Pagina.ToString, False], 'GET', 'Lista');
end;

function TFDAV.DoSalvar: Boolean;
var
  DAVDetalhe: TDAVDetalheVO;
begin
  if EditNomeCliente.Text = '' then
  begin
    Application.MessageBox('Informe o nome do cliente.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
    EditNomeCliente.SetFocus;
    Exit(False);
  end;
  if EditCpfCnpjCliente.Text = '' then
  begin
    Application.MessageBox('Informe o CPF/CNPJ do cliente.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
    EditCpfCnpjCliente.SetFocus;
    Exit(False);
  end;

  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TDavCabecalhoVO.Create;

      ActionAtualizarTotais.Execute;

      TDavCabecalhoVO(ObjetoVO).IdEmpresa := Sessao.Empresa.Id;
      if EditIdCliente.Value <> 0 then
        TDavCabecalhoVO(ObjetoVO).IdPessoa := EditIdCliente.AsInteger;
      TDavCabecalhoVO(ObjetoVO).NomeDestinatario := EditNomeCliente.Text;
      TDavCabecalhoVO(ObjetoVO).CpfCnpjDestinatario := EditCpfCnpjCliente.Text;
      TDavCabecalhoVO(ObjetoVO).Situacao := 'P';
      TDavCabecalhoVO(ObjetoVO).TaxaDesconto := EditTaxaDesconto.Value;
      TDavCabecalhoVO(ObjetoVO).Desconto := EditValorDesconto.Value;
      TDavCabecalhoVO(ObjetoVO).SubTotal := EditValorSubTotal.Value;
      TDavCabecalhoVO(ObjetoVO).Valor := EditValorTotal.Value;

      // Detalhes
      TController.PreencherObjectListFromCDS<TDAVDetalheVO>(TDavCabecalhoVO(ObjetoVO).ListaDavDetalheVO, CDSDetalhe);

      if StatusTela = stInserindo then
      begin
        TDavCabecalhoVO(ObjetoVO).DataEmissao := Date;
        TDavCabecalhoVO(ObjetoVO).HoraEmissao := FormatDateTime('hh:mm:ss', Now);
        TController.ExecutarMetodo('DAVController.TDAVController', 'Insere', [TDavCabecalhoVO(ObjetoVO)], 'PUT', 'Lista');
      end
      else if StatusTela = stEditando then
      begin
        if TDavCabecalhoVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        begin
          TController.ExecutarMetodo('DAVController.TDAVController', 'Altera', [TDavCabecalhoVO(ObjetoVO)], 'POST', 'Boolean');
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

{$REGION 'Campos Transientes'}
procedure TFDAV.EditIdClienteKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Filtro: String;
begin
  if Key = VK_F1 then
  begin
    if EditIdCliente.Value <> 0 then
      Filtro := 'ID = ' + EditIdCliente.Text
    else
      Filtro := 'ID=0';

    try
      EditIdCliente.Clear;
      EditNomeCliente.Clear;
      EditCpfCnpjCliente.Clear;
      if not PopulaCamposTransientes(Filtro, TViewPessoaClienteVO, TViewPessoaClienteController) then
        PopulaCamposTransientesLookup(TViewPessoaClienteVO, TViewPessoaClienteController);
      if CDSTransiente.RecordCount > 0 then
      begin
        EditIdCliente.Text := CDSTransiente.FieldByName('ID').AsString;
        EditCpfCnpjCliente.Text := CDSTransiente.FieldByName('CPF_CNPJ').AsString;
        EditNomeCliente.Text := CDSTransiente.FieldByName('NOME').AsString;
      end
      else
      begin
        Exit;
        EditIdCliente.SetFocus;
      end;
    finally
      CDSTransiente.Close;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Actions'}
procedure TFDAV.ActionIncluirItemExecute(Sender: TObject);
begin
  try
    PopulaCamposTransientesLookup(TProdutoVO, TProdutoController);
    if CDSTransiente.RecordCount > 0 then
    begin
        inc(SeqItem);
        CDSDetalhe.Append;
        CDSDetalhe.FieldByName('ID_PRODUTO').AsInteger := CDSTransiente.FieldByName('ID').AsInteger;
        CDSDetalhe.FieldByName('ID_DAV_CABECALHO').AsInteger := 0;
        CDSDetalhe.FieldByName('DATA_EMISSAO').AsDateTime := Date;
        CDSDetalhe.FieldByName('ITEM').AsInteger := SeqItem;
        CDSDetalhe.FieldByName('QUANTIDADE').AsExtended := 1;
        CDSDetalhe.FieldByName('VALOR_UNITARIO').AsExtended := CDSTransiente.FieldByName('VALOR_VENDA').AsExtended;
        CDSDetalhe.FieldByName('VALOR_TOTAL').AsExtended := CDSDetalhe.FieldByName('VALOR_UNITARIO').AsExtended * CDSDetalhe.FieldByName('QUANTIDADE').AsExtended;
        CDSDetalhe.FieldByName('CANCELADO').AsString := 'N';
        CDSDetalhe.FieldByName('PERSISTE').AsString := 'S';
        CDSDetalhe.FieldByName('GTIN_PRODUTO').AsString := CDSTransiente.FieldByName('GTIN').AsString;
        CDSDetalhe.FieldByName('NOME_PRODUTO').AsString := CDSTransiente.FieldByName('NOME').AsString;
        CDSDetalhe.FieldByName('UNIDADE_PRODUTO').AsString := CDSTransiente.FieldByName('UNIDADE_PRODUTO.SIGLA').AsString;
        CDSDetalhe.FieldByName('TOTALIZADOR_PARCIAL').AsString := CDSTransiente.FieldByName('TOTALIZADOR_PARCIAL').AsString;
        CDSDetalhe.Post;
    end;
  finally
    CDSTransiente.Close;
  end;
end;

procedure TFDAV.ActionAtualizarTotaisExecute(Sender: TObject);
var
  TotalProdutos: Double;
begin
  TotalProdutos := 0;

  CDSDetalhe.DisableControls;
  CDSDetalhe.First;
  while not CDSDetalhe.Eof do
  begin
    TotalProdutos := TotalProdutos + CDSDetalhe.FieldByName('VALOR_TOTAL').AsExtended;
    CDSDetalhe.Next;
  end;
  CDSDetalhe.First;
  CDSDetalhe.EnableControls;
  //
  EditValorSubTotal.Value := TotalProdutos;
  if EditTaxadesconto.Value > 0 then
  begin
    EditValorDesconto.Value := EditValorSubTotal.Value * (EditTaxadesconto.Value / 100);
  end;
  EditValorTotal.Value := EditValorSubTotal.Value - EditValorDesconto.Value;
end;

procedure TFDAV.ActionExcluirItemExecute(Sender: TObject);
begin
  CDSDetalhe.Edit;
  CDSDetalhe.FieldByName('CANCELADO').AsString := 'S';
  CDSDetalhe.Post;
end;
{$EndREGION 'Actions'}

{$REGION 'Controle de Grid'}
procedure TFDAV.GridDetalheDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if CDSDetalhe.FieldByName('CANCELADO').AsString = 'S' then
    GridDetalhe.Canvas.Brush.Color := $00C6C6FF;
  GridDetalhe.DefaultDrawDataCell(Rect, GridDetalhe.columns[datacol].field, State);
end;

procedure TFDAV.GridDetalheKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    ActionIncluirItem.Execute;
  end;
end;

procedure TFDAV.CDSDetalheBeforePost(DataSet: TDataSet);
var
  TotalItem: Double;
begin
  TotalItem := CDSDetalhe.FieldByName('QUANTIDADE').AsExtended * CDSDetalhe.FieldByName('VALOR_UNITARIO').AsExtended;
  TotalItem := ArredondaTruncaValor('A', TotalItem, 2);
  CDSDetalhe.FieldByName('VALOR_TOTAL').AsExtended := TotalItem;
  //
  if CDSDetalhe.FieldByName('ITEM').AsString = '' then
    CDSDetalhe.Cancel;
end;

procedure TFDAV.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := TDavCabecalhoVO(TController.BuscarObjeto('DAVController.TDAVController', 'ConsultaObjeto', ['ID=' + IdRegistroSelecionado.ToString], 'GET'));
  end;

  if Assigned(ObjetoVO) then
  begin
    EditIdCliente.AsInteger := TDavCabecalhoVO(ObjetoVO).IdPessoa;
    EditNomeCliente.Text := TDavCabecalhoVO(ObjetoVO).NomeDestinatario;
    EditCpfCnpjCliente.Text := TDavCabecalhoVO(ObjetoVO).CpfCnpjDestinatario;
    EditTaxaDesconto.Value := TDavCabecalhoVO(ObjetoVO).TaxaDesconto;
    EditValorDesconto.Value := TDavCabecalhoVO(ObjetoVO).Desconto;
    EditValorSubTotal.Value := TDavCabecalhoVO(ObjetoVO).SubTotal;
    EditValorTotal.Value := TDavCabecalhoVO(ObjetoVO).Valor;

    // Preenche as grids internas com os dados das Listas que vieram no objeto
    TController.TratarRetorno<TDAVDetalheVO>(TDavCabecalhoVO(ObjetoVO).ListaDavDetalheVO, True, True, CDSDetalhe);

    // Limpa as listas para comparar posteriormente se houve inclus�es/altera��es e subir apenas o necess�rio para o servidor
    TDavCabecalhoVO(ObjetoVO).ListaDavDetalheVO.Clear;

    // Serializa o objeto para consultar posteriormente se houve altera��es
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;

procedure TFDAV.ControlaPersistencia(pDataSet: TDataSet);
begin
  pDataSet.FieldByName('PERSISTE').AsString := 'S';
end;
{$ENDREGION}

{$REGION 'Impress�o'}
procedure TFDAV.BotaoImprimirClick(Sender: TObject);
begin
  ImprimirDAV;
end;

procedure TFDAV.ImprimirDAV;
var
  ReportManager: Variant;
begin
  if not CDSGrid.IsEmpty then
  begin
    try
      ReportManager := CreateOleObject('ReportMan.ReportManX');
      ReportManager.Preview := True;
      ReportManager.ShowProgress := True;
      ReportManager.ShowPrintDialog := False;
      ReportManager.Filename := 'DAV.rep';
      ReportManager.SetParamValue('ID', CDSGrid.FieldByName('ID').AsInteger);
      ReportManager.SetParamValue('EMPRESA', 'Denomina��o: ' + Sessao.Empresa.RazaoSocial);
      ReportManager.SetParamValue('CNPJ', 'CNPJ: ' + Sessao.Empresa.Cnpj);
      ReportManager.SetParamValue('SUBTOTAL', FormatFloat('0.00', CDSGrid.FieldByName('SUBTOTAL').AsExtended));
      if CDSGrid.FieldByName('DESCONTO').AsExtended >  0 then
        ReportManager.SetParamValue('DESCONTO_ACRESCIMO', '(' + FormatFloat('0.00', CDSGrid.FieldByName('DESCONTO').AsExtended) + ')')
      else if CDSGrid.FieldByName('ACRESCIMO').AsExtended >  0 then
        ReportManager.SetParamValue('DESCONTO_ACRESCIMO', FormatFloat('0.00', CDSGrid.FieldByName('ACRESCIMO').AsExtended))
      else
        ReportManager.SetParamValue('DESCONTO_ACRESCIMO', '0,00');
      ReportManager.SetParamValue('TOTAL', FormatFloat('0.00', CDSGrid.FieldByName('VALOR').AsExtended));
      ReportManager.execute;
    except
      on E: Exception do
        Application.MessageBox(PChar('Ocorreu um erro durante a impress�o. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  end;
end;
{$EndREGION 'Impress�o'}


end.
