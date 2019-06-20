{ *******************************************************************************
Title: T2Ti ERP
Description: Janela Cadastro de Pessoas

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
t2ti.com@gmail.com</p>

@author Albert Eije
@version 2.0
******************************************************************************* }

unit UPessoa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, Mask, JvExMask, JvToolEdit,
  JvCombobox, LabeledCtrls, DBCtrls, LabeledDBCtrls, DB, DBClient, StrUtils,
  Math, VO, PessoaFisicaVO, PessoaJuridicaVO, Generics.Collections,
  Atributos, Constantes, CheckLst, JvExCheckLst, JvCheckListBox, JvBaseEdits,
  Controller, Actions, ActnList, RibbonSilverStyleActnCtrls,
  ActnMan, ToolWin, ActnCtrls, Biblioteca;

type

  [TFormDescription(TConstantes.MODULO_CADASTROS, 'Pessoa')]
  TFPessoa = class(TFTelaCadastro)
    ScrollBox: TScrollBox;
    PageControlDadosPessoa: TPageControl;
    tsTipoPessoa: TTabSheet;
    PanelDadosPessoa: TPanel;
    PageControlTipoPessoa: TPageControl;
    tsPessoaFisica: TTabSheet;
    PanelPessoaFisica: TPanel;
    EditCPF: TLabeledMaskEdit;
    GroupBoxRG: TGroupBox;
    EditRGNumero: TLabeledEdit;
    EditRGEmissao: TLabeledDateEdit;
    EditRGOrgaoEmissor: TLabeledEdit;
    EditNascimento: TLabeledDateEdit;
    RadioGroupSexo: TRadioGroup;
    LComboBoxEstadoCivil: TLabeledDBLookupComboBox;
    tsPessoaJuridica: TTabSheet;
    PanelPessoaJuridica: TPanel;
    EditFantasia: TLabeledEdit;
    EditCNPJ: TLabeledMaskEdit;
    EditInscricaoMunicipal: TLabeledEdit;
    EditDataConstituicao: TLabeledDateEdit;
    tsContato: TTabSheet;
    PanelContatos: TPanel;
    GridContato: TJvDBUltimGrid;
    EditNomeMae: TLabeledEdit;
    EditNaturalidade: TLabeledEdit;
    EditNacionalidade: TLabeledEdit;
    ComboBoxRaca: TLabeledComboBox;
    ComboBoxTipoSangue: TLabeledComboBox;
    GroupBoxCNH: TGroupBox;
    EditCNHNumero: TLabeledEdit;
    EditCNHVencimento: TLabeledDateEdit;
    ComboBoxCNHCategoria: TLabeledComboBox;
    GroupBoxTituloEleitoral: TGroupBox;
    EditTituloNumero: TLabeledEdit;
    EditTituloZona: TLabeledCalcEdit;
    EditTituloSecao: TLabeledCalcEdit;
    EditNomePai: TLabeledEdit;
    GroupBoxReservista: TGroupBox;
    EditReservistaNumero: TLabeledEdit;
    ComboBoxReservistaCategoria: TLabeledComboBox;
    EditInscricaoEstadual: TLabeledEdit;
    EditSuframa: TLabeledEdit;
    ComboBoxTipoRegime: TLabeledComboBox;
    ComboBoxCRT: TLabeledComboBox;
    tsEndereco: TTabSheet;
    PanelEnderecos: TPanel;
    GridEndereco: TJvDBUltimGrid;
    PanelPessoaDadosBase: TPanel;
    EditEmail: TLabeledEdit;
    EditNome: TLabeledEdit;
    ComboboxTipoPessoa: TLabeledComboBox;
    CheckListBoxPessoa: TJvCheckListBox;
    EditSite: TLabeledEdit;
    CDSEndereco: TClientDataSet;
    DSEndereco: TDataSource;
    CDSContato: TClientDataSet;
    DSContato: TDataSource;
    CDSEstadoCivil: TClientDataSet;
    DSEstadoCivil: TDataSource;
    ActionToolBar2: TActionToolBar;
    ActionManager: TActionManager;
    ActionExcluirContato: TAction;
    ActionExcluirEndereco: TAction;
    ActionExcluirTelefone: TAction;
    ActionToolBar1: TActionToolBar;
    tsTelefone: TTabSheet;
    CDSTelefone: TClientDataSet;
    DSTelefone: TDataSource;
    PanelTelefones: TPanel;
    GridTelefone: TJvDBUltimGrid;
    ActionToolBar3: TActionToolBar;
    procedure FormCreate(Sender: TObject);
    procedure ComboboxTipoPessoaChange(Sender: TObject);
    procedure ActionExcluirContatoExecute(Sender: TObject);
    procedure ActionExcluirEnderecoExecute(Sender: TObject);
    procedure ActionExcluirTelefoneExecute(Sender: TObject);
    procedure ControlaPersistencia(pDataSet: TDataSet);
    procedure ControlaInsercaoGridInterna(pDataSet: TDataSet; pCampoControle: String);
  private
    { Private declarations }
    IdTipoPessoa: Integer;
  public
    { Public declarations }
    procedure GridParaEdits; override;
    procedure LimparCampos; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;

    procedure ExibirDadosTipoPessoa;
    procedure ConfigurarLayoutTela;
    procedure PopulaComboEstadoCivil(Sender: TObject);
  end;

var
  FPessoa: TFPessoa;

implementation

uses
      EstadoCivilController, PessoaController,
      EstadoCivilVO, PessoaVO, PessoaContatoVO, PessoaEnderecoVO, PessoaTelefoneVO;
{$R *.dfm}

{$Region 'Infra'}
procedure TFPessoa.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  ClasseObjetoGridVO := TPessoaVO;
  ObjetoController := TPessoaController.Create;
  inherited;

  PopulaComboEstadoCivil(Self);

  // Configura a Grid dos Endere�os
  ConfiguraCDSFromVO(CDSEndereco, TPessoaEnderecoVO);
  ConfiguraGridFromVO(GridEndereco, TPessoaEnderecoVO);

  // Configura a Grid dos Contatos
  ConfiguraCDSFromVO(CDSContato, TPessoaContatoVO);
  ConfiguraGridFromVO(GridContato, TPessoaContatoVO);

  // Configura a Grid dos Telefones
  ConfiguraCDSFromVO(CDSTelefone, TPessoaTelefoneVO);
  ConfiguraGridFromVO(GridTelefone, TPessoaTelefoneVO);
end;

procedure TFPessoa.ConfigurarLayoutTela;
begin
  PageControlDadosPessoa.ActivePageIndex := 0;
  PanelEdits.Enabled := True;

  if StatusTela = stNavegandoEdits then
  begin
    PanelDadosPessoa.Enabled := False;
    PanelContatos.Enabled := False;
    PanelEnderecos.Enabled := False;
    PanelPessoaDadosBase.Enabled := False;
    PanelTelefones.Enabled := False;
  end
  else
  begin
    PanelDadosPessoa.Enabled := True;
    PanelContatos.Enabled := True;
    PanelEnderecos.Enabled := True;
    PanelTelefones.Enabled := True;
    PanelPessoaDadosBase.Enabled := True;
  end;
  ExibirDadosTipoPessoa;
end;

procedure TFPessoa.ExibirDadosTipoPessoa;
begin
  case ComboboxTipoPessoa.ItemIndex of
    0:
      begin
        PanelPessoaFisica.Parent := PanelDadosPessoa;
        PanelPessoaFisica.Visible := True;
        PanelPessoaJuridica.Visible := False;
      end;
    1:
      begin
        PanelPessoaJuridica.Parent := PanelDadosPessoa;
        PanelPessoaFisica.Visible := False;
        PanelPessoaJuridica.Visible := True;
      end;
  end;
end;

procedure TFPessoa.PopulaComboEstadoCivil(Sender: TObject);
begin
  ConfiguraCDSFromVO(CDSEstadoCivil, TEstadoCivilVO);

  TEstadoCivilController.SetDataSet(CDSEstadoCivil);
  TController.ExecutarMetodo('EstadoCivilController.TEstadoCivilController', 'Consulta', ['ID>0', '0', False], 'GET', 'Lista');

  LComboBoxEstadoCivil.ListField := 'NOME';
  LComboBoxEstadoCivil.KeyField := 'ID'
end;

procedure TFPessoa.LimparCampos;
var
  I: Integer;
begin
  inherited;

  // Pessoa
  ComboboxTipoPessoa.ItemIndex := 0;

  // Pessoa F�sica
  RadioGroupSexo.ItemIndex := -1;
  LComboBoxEstadoCivil.KeyValue := Null;

  // Contatos
  CDSContato.EmptyDataSet;
  // Endere�os
  CDSEndereco.EmptyDataSet;
  // Telefones
  CDSTelefone.EmptyDataSet;

  // CheckListBox
  for I := 0 to CheckListBoxPessoa.Items.Count - 1 do
    CheckListBoxPessoa.Checked[I] := False;
end;

procedure TFPessoa.ComboboxTipoPessoaChange(Sender: TObject);
begin
  ExibirDadosTipoPessoa;
end;
{$EndRegion 'Infra'}

{$REGION 'Controles CRUD'}
function TFPessoa.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    IdTipoPessoa := 0;
    EditNome.SetFocus;
    ComboboxTipoPessoa.Enabled := True;
    ExibirDadosTipoPessoa;
  end;
end;

function TFPessoa.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditNome.SetFocus;
    ComboboxTipoPessoa.Enabled := False;
  end;
end;

function TFPessoa.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      TController.ExecutarMetodo('PessoaController.TPessoaController', 'Exclui', [IdRegistroSelecionado], 'DELETE', 'Boolean');
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
    TController.ExecutarMetodo('PessoaController.TPessoaController', 'Consulta', [Trim(Filtro), Pagina.ToString, False], 'GET', 'Lista');
end;

function TFPessoa.DoSalvar: Boolean;
begin
  if EditNome.Text = '' then
  begin
    Application.MessageBox('Informe o nome da pessoa.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
    EditNome.SetFocus;
    Exit(False);
  end
  else if ComboboxTipoPessoa.ItemIndex = 0 then
  begin
    if EditCPF.Text = '' then
    begin
      Application.MessageBox('Informe o CPF da pessoa.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      EditCPF.SetFocus;
      Exit(False);
    end
    else if EditNomeMae.Text = '' then
    begin
      Application.MessageBox('Informe o nome da m�e.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      EditNomeMae.SetFocus;
      Exit(False);
    end
    else if LComboBoxEstadoCivil.KeyValue = Null then
    begin
      Application.MessageBox('Selecione o estado civil.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      LComboBoxEstadoCivil.SetFocus;
      Exit(False);
    end
  end
  else if ComboboxTipoPessoa.ItemIndex = 1 then
  begin
    if EditCNPJ.Text = '' then
    begin
      Application.MessageBox('Informe o CNPJ da pessoa.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      EditCNPJ.SetFocus;
      Exit(False);
    end;
  end;

  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TPessoaVO.Create;

      TPessoaVO(ObjetoVO).Nome := EditNome.Text;
      TPessoaVO(ObjetoVO).Tipo := IfThen(ComboboxTipoPessoa.ItemIndex = 0, 'F', 'J');
      TPessoaVO(ObjetoVO).Email := EditEmail.Text;
      TPessoaVO(ObjetoVO).Site := EditSite.Text;
      TPessoaVO(ObjetoVO).Cliente := IfThen(CheckListBoxPessoa.Checked[0], 'S', 'N');
      TPessoaVO(ObjetoVO).Fornecedor := IfThen(CheckListBoxPessoa.Checked[1], 'S', 'N');
      TPessoaVO(ObjetoVO).Colaborador := IfThen(CheckListBoxPessoa.Checked[2], 'S', 'N');
      TPessoaVO(ObjetoVO).Transportadora := IfThen(CheckListBoxPessoa.Checked[3], 'S', 'N');

      // Tipo de Pessoa
      if TPessoaVO(ObjetoVO).Tipo = 'F' then
      begin
        TPessoaVO(ObjetoVO).PessoaFisicaVO.Id := IdTipoPessoa;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.IdPessoa := TPessoaVO(ObjetoVO).Id;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.CPF := EditCPF.Text;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.DataNascimento := EditNascimento.Date;
        if LComboBoxEstadoCivil.KeyValue <> Null then
          TPessoaVO(ObjetoVO).PessoaFisicaVO.IdEstadoCivil := LComboBoxEstadoCivil.KeyValue;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.Raca := Copy(ComboBoxRaca.Text, 1, 1);
        TPessoaVO(ObjetoVO).PessoaFisicaVO.TipoSangue := Copy(ComboBoxTipoSangue.Text, 1, 1);
        TPessoaVO(ObjetoVO).PessoaFisicaVO.Naturalidade := EditNaturalidade.Text;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.Nacionalidade := EditNacionalidade.Text;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.NomePai := EditNomePai.Text;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.NomeMae := EditNomeMae.Text;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.RG := EditRGNumero.Text;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.DataEmissaoRg := EditRGEmissao.Date;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.OrgaoRg := EditRGOrgaoEmissor.Text;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.ReservistaNumero := EditReservistaNumero.Text;
        if ComboBoxReservistaCategoria.Text <> '' then
          TPessoaVO(ObjetoVO).PessoaFisicaVO.ReservistaCategoria := StrToInt(ComboBoxReservistaCategoria.Text);
        case RadioGroupSexo.ItemIndex of
          0:
            TPessoaVO(ObjetoVO).PessoaFisicaVO.Sexo := 'F';
          1:
            TPessoaVO(ObjetoVO).PessoaFisicaVO.Sexo := 'M';
        else
          TPessoaVO(ObjetoVO).PessoaFisicaVO.Sexo := '';
        end;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.CnhNumero := EditCNHNumero.Text;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.CnhVencimento := EditCNHVencimento.Date;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.CnhCategoria := ComboBoxCNHCategoria.Text;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.TituloEleitoralNumero := EditTituloNumero.Text;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.TituloEleitoralZona := EditTituloZona.AsInteger;
        TPessoaVO(ObjetoVO).PessoaFisicaVO.TituloEleitoralSecao := EditTituloSecao.AsInteger;
      end
      else if TPessoaVO(ObjetoVO).Tipo = 'J' then
      begin
        TPessoaVO(ObjetoVO).PessoaJuridicaVO.Id := IdTipoPessoa;
        TPessoaVO(ObjetoVO).PessoaJuridicaVO.IdPessoa := TPessoaVO(ObjetoVO).Id;
        TPessoaVO(ObjetoVO).PessoaJuridicaVO.Fantasia := EditFantasia.Text;
        TPessoaVO(ObjetoVO).PessoaJuridicaVO.Cnpj := EditCNPJ.Text;
        TPessoaVO(ObjetoVO).PessoaJuridicaVO.InscricaoEstadual := EditInscricaoEstadual.Text;
        TPessoaVO(ObjetoVO).PessoaJuridicaVO.InscricaoMunicipal := EditInscricaoMunicipal.Text;
        TPessoaVO(ObjetoVO).PessoaJuridicaVO.DataConstituicao := EditDataConstituicao.Date;
        TPessoaVO(ObjetoVO).PessoaJuridicaVO.Suframa := EditSuframa.Text;
        TPessoaVO(ObjetoVO).PessoaJuridicaVO.TipoRegime := Copy(ComboBoxTipoRegime.Text, 1, 1);
        TPessoaVO(ObjetoVO).PessoaJuridicaVO.Crt := Copy(ComboBoxCRT.Text, 1, 1);
      end;

      // Contatos
      TController.PreencherObjectListFromCDS<TPessoaContatoVO>(TPessoaVO(ObjetoVO).ListaPessoaContatoVO, CDSContato);

      // Endere�os
      TController.PreencherObjectListFromCDS<TPessoaEnderecoVO>(TPessoaVO(ObjetoVO).ListaPessoaEnderecoVO, CDSEndereco);

      // Telefones
      TController.PreencherObjectListFromCDS<TPessoaTelefoneVO>(TPessoaVO(ObjetoVO).ListaPessoaTelefoneVO, CDSTelefone);

      if StatusTela = stInserindo then
        TController.ExecutarMetodo('PessoaController.TPessoaController', 'Insere', [TPessoaVO(ObjetoVO)], 'PUT', 'Lista')
      else if StatusTela = stEditando then
      begin
        if TPessoaVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        begin
          TController.ExecutarMetodo('PessoaController.TPessoaController', 'Altera', [TPessoaVO(ObjetoVO)], 'POST', 'Boolean');
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

{$REGION 'Controle de Grids e ClientDataSets'}
procedure TFPessoa.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := TPessoaVO(TController.BuscarObjeto('PessoaController.TPessoaController', 'ConsultaObjeto', ['ID=' + IdRegistroSelecionado.ToString], 'GET'));
  end;

  if Assigned(ObjetoVO) then
  begin
    // Pessoa
    EditNome.Text := TPessoaVO(ObjetoVO).Nome;
    ComboboxTipoPessoa.ItemIndex := IfThen(TPessoaVO(ObjetoVO).Tipo = 'F', 0, 1);
    EditEmail.Text := TPessoaVO(ObjetoVO).Email;
    EditSite.Text := TPessoaVO(ObjetoVO).Site;
    if TPessoaVO(ObjetoVO).Cliente = 'S' then
      CheckListBoxPessoa.Checked[0] := True;
    if TPessoaVO(ObjetoVO).Fornecedor = 'S' then
      CheckListBoxPessoa.Checked[1] := True;
    if TPessoaVO(ObjetoVO).Colaborador = 'S' then
      CheckListBoxPessoa.Checked[2] := True;
    if TPessoaVO(ObjetoVO).Transportadora = 'S' then
      CheckListBoxPessoa.Checked[3] := True;

    // Tipo Pessoa
    if (TPessoaVO(ObjetoVO).Tipo = 'F') and (Assigned(TPessoaVO(ObjetoVO).PessoaFisicaVO)) then // Pessoa F�sica
    begin
      IdTipoPessoa := TPessoaVO(ObjetoVO).PessoaFisicaVO.Id;
      EditCPF.Text := TPessoaVO(ObjetoVO).PessoaFisicaVO.CPF;
      EditNascimento.Date := TPessoaVO(ObjetoVO).PessoaFisicaVO.DataNascimento;
      if TPessoaVO(ObjetoVO).PessoaFisicaVO.IdEstadoCivil > 0 then
        LComboBoxEstadoCivil.KeyValue := TPessoaVO(ObjetoVO).PessoaFisicaVO.IdEstadoCivil;

      case AnsiIndexStr(TPessoaVO(ObjetoVO).PessoaFisicaVO.Raca, ['B', 'N', 'P', 'I']) of
        0:
          ComboBoxRaca.ItemIndex := 0;
        1:
          ComboBoxRaca.ItemIndex := 1;
        2:
          ComboBoxRaca.ItemIndex := 2;
        3:
          ComboBoxRaca.ItemIndex := 3;
      else
        ComboBoxRaca.ItemIndex := -1;
      end;

      case AnsiIndexStr(TPessoaVO(ObjetoVO).PessoaFisicaVO.TipoSangue, ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']) of
        0:
          ComboBoxTipoSangue.ItemIndex := 0;
        1:
          ComboBoxTipoSangue.ItemIndex := 1;
        2:
          ComboBoxTipoSangue.ItemIndex := 2;
        3:
          ComboBoxTipoSangue.ItemIndex := 3;
        4:
          ComboBoxTipoSangue.ItemIndex := 4;
        5:
          ComboBoxTipoSangue.ItemIndex := 5;
        6:
          ComboBoxTipoSangue.ItemIndex := 6;
        7:
          ComboBoxTipoSangue.ItemIndex := 7;
      else
        ComboBoxTipoSangue.ItemIndex := -1;
      end;

      EditNaturalidade.Text := TPessoaVO(ObjetoVO).PessoaFisicaVO.Naturalidade;
      EditNacionalidade.Text := TPessoaVO(ObjetoVO).PessoaFisicaVO.Nacionalidade;
      EditNomePai.Text := TPessoaVO(ObjetoVO).PessoaFisicaVO.NomePai;
      EditNomeMae.Text := TPessoaVO(ObjetoVO).PessoaFisicaVO.NomeMae;
      EditRGNumero.Text := TPessoaVO(ObjetoVO).PessoaFisicaVO.RG;
      EditRGEmissao.Date := TPessoaVO(ObjetoVO).PessoaFisicaVO.DataEmissaoRg;
      EditRGOrgaoEmissor.Text := TPessoaVO(ObjetoVO).PessoaFisicaVO.OrgaoRg;
      EditReservistaNumero.Text := TPessoaVO(ObjetoVO).PessoaFisicaVO.ReservistaNumero;
      ComboBoxReservistaCategoria.ItemIndex := TPessoaVO(ObjetoVO).PessoaFisicaVO.ReservistaCategoria - 1;

      case AnsiIndexStr(TPessoaVO(ObjetoVO).PessoaFisicaVO.Sexo, ['F', 'M']) of
        0:
          RadioGroupSexo.ItemIndex := 0;
        1:
          RadioGroupSexo.ItemIndex := 1;
      else
        RadioGroupSexo.ItemIndex := -1;
      end;

      EditCNHNumero.Text := TPessoaVO(ObjetoVO).PessoaFisicaVO.CnhNumero;
      EditCNHVencimento.Date := TPessoaVO(ObjetoVO).PessoaFisicaVO.CnhVencimento;

      case AnsiIndexStr(TPessoaVO(ObjetoVO).PessoaFisicaVO.CnhCategoria, ['A', 'B', 'C', 'D', 'E']) of
        0:
          ComboBoxCNHCategoria.ItemIndex := 0;
        1:
          ComboBoxCNHCategoria.ItemIndex := 1;
        2:
          ComboBoxCNHCategoria.ItemIndex := 2;
        3:
          ComboBoxCNHCategoria.ItemIndex := 3;
        4:
          ComboBoxCNHCategoria.ItemIndex := 4;
      else
        ComboBoxCNHCategoria.ItemIndex := -1;
      end;

      EditTituloNumero.Text := TPessoaVO(ObjetoVO).PessoaFisicaVO.TituloEleitoralNumero;
      EditTituloZona.AsInteger := TPessoaVO(ObjetoVO).PessoaFisicaVO.TituloEleitoralZona;
      EditTituloSecao.AsInteger := TPessoaVO(ObjetoVO).PessoaFisicaVO.TituloEleitoralSecao;
    end
    else if (TPessoaVO(ObjetoVO).Tipo = 'J') and (Assigned(TPessoaVO(ObjetoVO).PessoaJuridicaVO)) then // Pessoa Jur�dica
    begin
      IdTipoPessoa := TPessoaVO(ObjetoVO).PessoaJuridicaVO.Id;

      EditFantasia.Text := TPessoaVO(ObjetoVO).PessoaJuridicaVO.Fantasia;
      EditCNPJ.Text := TPessoaVO(ObjetoVO).PessoaJuridicaVO.Cnpj;
      EditInscricaoEstadual.Text := TPessoaVO(ObjetoVO).PessoaJuridicaVO.InscricaoEstadual;
      EditInscricaoMunicipal.Text := TPessoaVO(ObjetoVO).PessoaJuridicaVO.InscricaoMunicipal;
      EditDataConstituicao.Date := TPessoaVO(ObjetoVO).PessoaJuridicaVO.DataConstituicao;
      EditSuframa.Text := TPessoaVO(ObjetoVO).PessoaJuridicaVO.Suframa;

      case AnsiIndexStr(TPessoaVO(ObjetoVO).PessoaJuridicaVO.TipoRegime, ['1', '2', '3']) of
        0:
          ComboBoxTipoRegime.ItemIndex := 0;
        1:
          ComboBoxTipoRegime.ItemIndex := 1;
        2:
          ComboBoxTipoRegime.ItemIndex := 2;
      else
        ComboBoxTipoRegime.ItemIndex := -1;
      end;

      case AnsiIndexStr(TPessoaVO(ObjetoVO).PessoaJuridicaVO.Crt, ['1', '2', '3']) of
        0:
          ComboBoxCRT.ItemIndex := 0;
        1:
          ComboBoxCRT.ItemIndex := 1;
        2:
          ComboBoxCRT.ItemIndex := 2;
      else
        ComboBoxCRT.ItemIndex := -1;
      end;
    end;

    // Preenche as grids internas com os dados das Listas que vieram no objeto
    TController.TratarRetorno<TPessoaEnderecoVO>(TPessoaVO(ObjetoVO).ListaPessoaEnderecoVO, True, True, CDSEndereco);
    TController.TratarRetorno<TPessoaContatoVO>(TPessoaVO(ObjetoVO).ListaPessoaContatoVO, True, True, CDSContato);
    TController.TratarRetorno<TPessoaTelefoneVO>(TPessoaVO(ObjetoVO).ListaPessoaTelefoneVO, True, True, CDSTelefone);

    // Limpa as listas para comparar posteriormente se houve inclus�es/altera��es e subir apenas o necess�rio para o servidor
    TPessoaVO(ObjetoVO).ListaPessoaEnderecoVO.Clear;
    TPessoaVO(ObjetoVO).ListaPessoaContatoVO.Clear;
    TPessoaVO(ObjetoVO).ListaPessoaTelefoneVO.Clear;

    // Serializa o objeto para consultar posteriormente se houve altera��es
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
  ConfigurarLayoutTela;
end;

procedure TFPessoa.ControlaInsercaoGridInterna(pDataSet: TDataSet; pCampoControle: String);
begin
  if Trim(pDataSet.FieldByName(pCampoControle).AsString) = '' then
    pDataSet.Cancel;
end;

procedure TFPessoa.ControlaPersistencia(pDataSet: TDataSet);
begin
  pDataSet.FieldByName('PERSISTE').AsString := 'S';
end;
{$ENDREGION}

{$REGION 'Exclus�es Internas'}
procedure TFPessoa.ActionExcluirContatoExecute(Sender: TObject);
begin
  if not CDSContato.IsEmpty then
  begin
    if Application.MessageBox('Tem certeza que deseja excluir o registro selecionado?', 'Pergunta do Sistema', MB_YesNo + MB_IconQuestion) = IdYes then
    begin
      if StatusTela = stInserindo then
        CDSContato.Delete
      else if StatusTela = stEditando then
      begin
        TController.ExecutarMetodo('PessoaController.TPessoaController', 'ExcluiContato', [CDSContato.FieldByName('ID').AsInteger], 'DELETE', 'Boolean');
        if TController.RetornoBoolean then
          CDSContato.Delete;
      end;
    end;
  end
  else
    Application.MessageBox('N�o existem dados para serem exclu�dos.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
end;

procedure TFPessoa.ActionExcluirEnderecoExecute(Sender: TObject);
begin
  if not CDSEndereco.IsEmpty then
  begin
    if Application.MessageBox('Tem certeza que deseja excluir o registro selecionado?', 'Pergunta do Sistema', MB_YesNo + MB_IconQuestion) = IdYes then
    begin
      if StatusTela = stInserindo then
        CDSEndereco.Delete
      else if StatusTela = stEditando then
      begin
        TController.ExecutarMetodo('PessoaController.TPessoaController', 'ExcluiEndereco', [CDSEndereco.FieldByName('ID').AsInteger], 'DELETE', 'Boolean');
        if TController.RetornoBoolean then
          CDSEndereco.Delete;
      end;
    end;
  end
  else
    Application.MessageBox('N�o existem dados para serem exclu�dos.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
end;

procedure TFPessoa.ActionExcluirTelefoneExecute(Sender: TObject);
begin
  if not CDSTelefone.IsEmpty then
  begin
    if Application.MessageBox('Tem certeza que deseja excluir o registro selecionado?', 'Pergunta do Sistema', MB_YesNo + MB_IconQuestion) = IdYes then
    begin
      if StatusTela = stInserindo then
        CDSTelefone.Delete
      else if StatusTela = stEditando then
      begin
        TController.ExecutarMetodo('PessoaController.TPessoaController', 'ExcluiTelefone', [CDSTelefone.FieldByName('ID').AsInteger], 'DELETE', 'Boolean');
        if TController.RetornoBoolean then
          CDSTelefone.Delete;
      end;
    end;
  end
  else
    Application.MessageBox('N�o existem dados para serem exclu�dos.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
end;
{$EndREGION 'Exclus�es Internas'}

end.
