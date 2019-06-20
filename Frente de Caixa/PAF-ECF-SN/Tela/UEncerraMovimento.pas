{ *******************************************************************************
Title: T2TiPDV
Description: Encerra um movimento aberto.

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
unit UEncerraMovimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, UBase,
  Dialogs, Grids, DBGrids, JvExDBGrids, JvDBGrid, StdCtrls, ExtCtrls,
  JvExStdCtrls, JvButton, JvCtrls, Buttons, JvExButtons, JvBitBtn, pngimage,
  FMTBcd, JvEnterTab, Provider, DBClient, DB, SqlExpr, Generics.Collections,
  JvComponentBase, Mask, JvExMask, JvToolEdit, JvBaseEdits, Biblioteca,
  Controller, JvDBUltimGrid, Tipos, DateUtils;

type
  TFEncerraMovimento = class(TFBase)
    Image1: TImage;
    GroupBox2: TGroupBox;
    editSenhaOperador: TLabeledEdit;
    GroupBox1: TGroupBox;
    editLoginGerente: TLabeledEdit;
    editSenhaGerente: TLabeledEdit;
    botaoConfirma: TJvBitBtn;
    botaoCancela: TJvImgBtn;
    JvEnterAsTab1: TJvEnterAsTab;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    LabelTurno: TLabel;
    LabelTerminal: TLabel;
    LabelOperador: TLabel;
    LabelImpressora: TLabel;
    GroupBox3: TGroupBox;
    ComboTipoPagamento: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    edtValor: TJvCalcEdit;
    btnAdicionar: TBitBtn;
    btnRemover: TBitBtn;
    edtTotal: TJvCalcEdit;
    DSFechamento: TDataSource;
    GridFechamento: TJvDBUltimGrid;
    CDSFechamento: TClientDataSet;
    procedure Confirma;
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure botaoConfirmaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TotalizaFechamento;
    procedure ImprimeFechamento;
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure edtValorExit(Sender: TObject);
    procedure editSenhaGerenteExit(Sender: TObject);
    procedure botaoCancelaClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  FEncerraMovimento: TFEncerraMovimento;
  FechouMovimento: Boolean;

implementation

uses
  UDataModule,
  EcfFechamentoController, PAFUtil,
  EcfTipoPagamentoVO, EcfOperadorVO, EcfFechamentoVO, ViewTotalPagamentoMovimentoVO;

{$R *.dfm}

{$Region 'Infra'}
procedure TFEncerraMovimento.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  FechouMovimento := False;

  LabelTurno.Caption := Sessao.Movimento.EcfTurnoVO.Descricao;
  LabelTerminal.Caption := Sessao.Movimento.EcfCaixaVO.Nome;
  LabelOperador.Caption := Sessao.Movimento.EcfOperadorVO.Login;
  LabelImpressora.Caption := Sessao.Movimento.EcfImpressoraVO.Identificacao;

  try
    for i := 0 to Sessao.ListaTipoPagamento.Count - 1 do
      ComboTipoPagamento.Items.Add(TEcfTipoPagamentoVO(Sessao.ListaTipoPagamento.Items[i]).Descricao);
    ComboTipoPagamento.ItemIndex := 0;
  finally
  end;
end;

procedure TFEncerraMovimento.FormActivate(Sender: TObject);
begin
  Color := StringToColor(Sessao.Configuracao.CorJanelasInternas);
  ComboTipoPagamento.SetFocus;

  // Configura a Grid do Fechamento
  ConfiguraCDSFromVO(CDSFechamento, TEcfFechamentoVO);
  ConfiguraGridFromVO(GridFechamento, TEcfFechamentoVO);

  TotalizaFechamento;
end;

procedure TFEncerraMovimento.editSenhaGerenteExit(Sender: TObject);
begin
  botaoConfirma.SetFocus;
end;

procedure TFEncerraMovimento.edtValorExit(Sender: TObject);
begin
  if edtValor.Value = 0 then
    editSenhaOperador.SetFocus;
end;

procedure TFEncerraMovimento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FechouMovimento then
  begin
    ModalResult := mrOK;
    Sessao.Movimento := Nil;
  end
  else
    ModalResult := mrCancel;
  Action := caFree;
end;

procedure TFEncerraMovimento.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F12 then
    Confirma;
  if Key = VK_ESCAPE then
    botaoCancela.Click;
end;

procedure TFEncerraMovimento.botaoCancelaClick(Sender: TObject);
begin
  Close;
end;

procedure TFEncerraMovimento.botaoConfirmaClick(Sender: TObject);
begin
  Confirma;
end;
{$EndRegion 'Infra'}

{$Region 'Dados de Fechamento'}
procedure TFEncerraMovimento.btnAdicionarClick(Sender: TObject);
var
  Fechamento: TEcfFechamentoVO;
begin
  if trim(ComboTipoPagamento.Text) = '' then
  begin
    Application.MessageBox('Informe um tipo de Pagamento V�lido!', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
    ComboTipoPagamento.SetFocus;
    Exit;
  end;

  if edtValor.Value <= 0 then
  begin
    Application.MessageBox('Informe um Valor V�lido!', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
    edtValor.SetFocus;
    Exit;
  end;

  try
    Fechamento := TEcfFechamentoVO.Create;
    Fechamento.IdEcfMovimento := Sessao.Movimento.Id;
    Fechamento.TipoPagamento := ComboTipoPagamento.Text;
    Fechamento.Valor := edtValor.Value;

    TController.ExecutarMetodo('EcfFechamentoController.TEcfFechamentoController', 'Insere', [Fechamento], 'PUT', 'Lista');

    TotalizaFechamento;
  finally
    FreeAndNil(Fechamento);
  end;
  edtValor.Clear;
  ComboTipoPagamento.SetFocus;
end;

procedure TFEncerraMovimento.btnRemoverClick(Sender: TObject);
begin
  if not CDSFechamento.IsEmpty then
  begin
    TController.ExecutarMetodo('EcfFechamentoController.TEcfFechamentoController', 'Exclui', [CDSFechamento.FieldByName('ID').AsInteger], 'DELETE', 'Boolean');
    TotalizaFechamento;
  end;
  ComboTipoPagamento.SetFocus;
end;

procedure TFEncerraMovimento.TotalizaFechamento;
var
  Total: Extended;
  Filtro: String;
begin
  // Verifica se j� existem dados para o fechamento
  Filtro := 'ID_ECF_MOVIMENTO = ' + IntToStr(Sessao.Movimento.Id);
  TEcfFechamentoController.SetDataSet(CDSFechamento);
  TController.ExecutarMetodo('EcfFechamentoController.TEcfFechamentoController', 'Consulta', [Filtro, '0', False], 'GET', 'Lista');

  Total := 0;

  if not CDSFechamento.IsEmpty then
  begin
    CDSFechamento.DisableControls;
    CDSFechamento.First;
    while not CDSFechamento.Eof do
    begin
      Total := Total + CDSFechamento.FieldByName('VALOR').AsExtended;
      CDSFechamento.Next;
    end;
    CDSFechamento.EnableControls;
  end;
  edtTotal.Value := Total;
end;
{$EndRegion 'Dados de Fechamento'}

{$Region 'Confirma��o e Encerramento do Movimento'}
procedure TFEncerraMovimento.Confirma;
var
  Operador: TEcfOperadorVO;
  Gerente: TEcfOperadorVO;
begin
  try
   try
      // verifica se senha do operador esta correta
      Operador := TEcfOperadorVO(TController.BuscarObjeto('EcfFuncionarioController.TEcfFuncionarioController', 'Usuario', [LabelOperador.Caption, editSenhaOperador.Text], 'GET'));
      if Assigned(Operador) then
      begin
        // verifica se senha do gerente esta correta
        Gerente := TEcfOperadorVO(TController.BuscarObjeto('EcfFuncionarioController.TEcfFuncionarioController', 'Usuario', [editLoginGerente.Text, editSenhaGerente.Text], 'GET'));
        if Assigned(Gerente) then
        begin
          if (Gerente.EcfFuncionarioVO.NivelAutorizacao = 'G') or (Gerente.EcfFuncionarioVO.NivelAutorizacao = 'S') then
          begin
            // encerra movimento
            Sessao.Movimento.DataFechamento := EncodeDate(YearOf(FDataModule.ACBrECF.DataHora), MonthOf(FDataModule.ACBrECF.DataHora), DayOf(FDataModule.ACBrECF.DataHora));
            Sessao.Movimento.HoraFechamento := FormatDateTime('hh:nn:ss', FDataModule.ACBrECF.DataHora);
            Sessao.Movimento.StatusMovimento := 'F';

            TController.ExecutarMetodo('EcfMovimentoController.TEcfMovimentoController', 'Altera', [Sessao.Movimento], 'POST', 'Boolean');
            ExecutarIntegracao('EXPORTA_MOVIMENTO');

            ImprimeFechamento;

            Application.MessageBox('Movimento encerrado com sucesso.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);

            FechouMovimento := True;

            botaoConfirma.ModalResult := mrOK;
            self.ModalResult := mrOK;
            Close;
          end
          else
          begin
            Application.MessageBox('Gerente ou Supervisor: n�vel de acesso incorreto.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
            editLoginGerente.SetFocus;
          end; // if (Gerente.Nivel = 'G') or (Gerente.Nivel = 'S') then
        end
        else
        begin
          Application.MessageBox('Gerente ou Supervisor: dados incorretos.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
          editLoginGerente.SetFocus;
        end; // if Gerente.Id <> 0 then
      end
      else
      begin
        Application.MessageBox('Operador: dados incorretos.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
        editSenhaOperador.SetFocus;
      end; // if Operador.Id <> 0 then
    except
    end;
  finally
    if Assigned(Operador) then
      FreeAndNil(Operador);
    if Assigned(Gerente) then
      FreeAndNil(Gerente);
  end;
end;
{$EndRegion 'Confirma��o e Encerramento do Movimento'}

{$Region 'Impress�o do Fechamento'}
procedure TFEncerraMovimento.ImprimeFechamento;
var
  Calculado, Declarado, Diferenca, Meio: AnsiString;
  ValorCalculado, ValorDeclarado, ValorDiferenca, TotCalculado, TotDeclarado, TotDiferenca: Currency;
  Suprimento, Sangria, NaoFiscal, TotalVenda, Desconto, Acrescimo, Recebido, Troco, Cancelado, TotalFinal: AnsiString;
  TotalPagamentoMovimento: TViewTotalPagamentoMovimentoVO;
  Filtro: String;
begin
  try
    FDataModule.ACBrECF.AbreRelatorioGerencial(Sessao.Configuracao.EcfRelatorioGerencialVO.X);
    FDataModule.ACBrECF.LinhaRelatorioGerencial(StringOfChar('=', 48));
    FDataModule.ACBrECF.LinhaRelatorioGerencial('             FECHAMENTO DE CAIXA                ');
    FDataModule.ACBrECF.PulaLinhas(1);
    FDataModule.ACBrECF.LinhaRelatorioGerencial('DATA DE ABERTURA  : ' + FormatDateTime('dd/mm/yyyy', Sessao.Movimento.DataAbertura));
    FDataModule.ACBrECF.LinhaRelatorioGerencial('HORA DE ABERTURA  : ' + Sessao.Movimento.HoraAbertura);
    FDataModule.ACBrECF.LinhaRelatorioGerencial('DATA DE FECHAMENTO: ' + FormatDateTime('dd/mm/yyyy', Sessao.Movimento.DataFechamento));
    FDataModule.ACBrECF.LinhaRelatorioGerencial('HORA DE FECHAMENTO: ' + Sessao.Movimento.HoraFechamento);
    FDataModule.ACBrECF.LinhaRelatorioGerencial(Sessao.Movimento.EcfCaixaVO.Nome + '  OPERADOR: ' + Sessao.Movimento.EcfOperadorVO.Login);
    FDataModule.ACBrECF.LinhaRelatorioGerencial('MOVIMENTO: ' + IntToStr(Sessao.Movimento.Id));
    FDataModule.ACBrECF.LinhaRelatorioGerencial(StringOfChar('=', 48));
    FDataModule.ACBrECF.PulaLinhas(1);

    Suprimento := FloatToStrF(Sessao.Movimento.TotalSuprimento, ffNumber, 11, 2);
    Suprimento := StringOfChar(' ', 13 - Length(Suprimento)) + Suprimento;
    Sangria := FloatToStrF(Sessao.Movimento.TotalSangria, ffNumber, 11, 2);
    Sangria := StringOfChar(' ', 13 - Length(Sangria)) + Sangria;
    NaoFiscal := FloatToStrF(Sessao.Movimento.TotalNaoFiscal, ffNumber, 11, 2);
    NaoFiscal := StringOfChar(' ', 13 - Length(NaoFiscal)) + NaoFiscal;
    TotalVenda := FloatToStrF(Sessao.Movimento.TotalVenda, ffNumber, 11, 2);
    TotalVenda := StringOfChar(' ', 13 - Length(TotalVenda)) + TotalVenda;
    Desconto := FloatToStrF(Sessao.Movimento.TotalDesconto, ffNumber, 11, 2);
    Desconto := StringOfChar(' ', 13 - Length(Desconto)) + Desconto;
    Acrescimo := FloatToStrF(Sessao.Movimento.TotalAcrescimo, ffNumber, 11, 2);
    Acrescimo := StringOfChar(' ', 13 - Length(Acrescimo)) + Acrescimo;
    Recebido := FloatToStrF(Sessao.Movimento.TotalRecebido, ffNumber, 11, 2);
    Recebido := StringOfChar(' ', 13 - Length(Recebido)) + Recebido;
    Troco := FloatToStrF(Sessao.Movimento.TotalTroco, ffNumber, 11, 2);
    Troco := StringOfChar(' ', 13 - Length(Troco)) + Troco;
    Cancelado := FloatToStrF(Sessao.Movimento.TotalCancelado, ffNumber, 11, 2);
    Cancelado := StringOfChar(' ', 13 - Length(Cancelado)) + Cancelado;
    TotalFinal := FloatToStrF(Sessao.Movimento.TotalFinal, ffNumber, 11, 2);
    TotalFinal := StringOfChar(' ', 13 - Length(TotalFinal)) + TotalFinal;

    FDataModule.ACBrECF.LinhaRelatorioGerencial('SUPRIMENTO...: ' + Suprimento);
    FDataModule.ACBrECF.LinhaRelatorioGerencial('SANGRIA......: ' + Sangria);
    FDataModule.ACBrECF.LinhaRelatorioGerencial('NAO FISCAL...: ' + NaoFiscal);
    FDataModule.ACBrECF.LinhaRelatorioGerencial('TOTAL VENDA..: ' + TotalVenda);
    FDataModule.ACBrECF.LinhaRelatorioGerencial('DESCONTO.....: ' + Desconto);
    FDataModule.ACBrECF.LinhaRelatorioGerencial('ACRESCIMO....: ' + Acrescimo);
    FDataModule.ACBrECF.LinhaRelatorioGerencial('RECEBIDO.....: ' + Recebido);
    FDataModule.ACBrECF.LinhaRelatorioGerencial('TROCO........: ' + Troco);
    FDataModule.ACBrECF.LinhaRelatorioGerencial('CANCELADO....: ' + Cancelado);
    FDataModule.ACBrECF.LinhaRelatorioGerencial('TOTAL FINAL..: ' + TotalFinal);
    FDataModule.ACBrECF.PulaLinhas(3);
    FDataModule.ACBrECF.LinhaRelatorioGerencial('                 CALCULADO  DECLARADO  DIFERENCA');

    TotCalculado := 0;
    TotDeclarado := 0;
    TotDiferenca := 0;

    CDSFechamento.DisableControls;
    CDSFechamento.First;
    while not CDSFechamento.Eof do
    begin
      try
        Filtro := 'ID_ECF_MOVIMENTO = ' + IntToStr(Sessao.Movimento.Id) + ' AND DESCRICAO = ' + QuotedStr(CDSFechamento.FieldByName('TIPO_PAGAMENTO').AsString);
        TotalPagamentoMovimento := TViewTotalPagamentoMovimentoVO(TController.BuscarObjeto('ViewTotalPagamentoMovimentoController.TViewTotalPagamentoMovimentoController', 'ConsultaObjeto', [Filtro], 'GET'));

        if Assigned(TotalPagamentoMovimento) then
          ValorCalculado := TotalPagamentoMovimento.ValorApurado
        else
          ValorCalculado := 0;
      finally
        FreeAndNil(TotalPagamentoMovimento);
      end;

      Calculado := FloatToStrF(ValorCalculado, ffNumber, 9, 2);
      Calculado := StringOfChar(' ', 11 - Length(Calculado)) + Calculado;

      ValorDeclarado := CDSFechamento.FieldByName('VALOR').AsExtended;
      Declarado := FloatToStrF(ValorDeclarado, ffNumber, 9, 2);
      Declarado := StringOfChar(' ', 11 - Length(Declarado)) + Declarado;

      ValorDiferenca := ValorCalculado - ValorDeclarado;
      Diferenca := FloatToStrF(ValorDiferenca, ffNumber, 9, 2);
      Diferenca := StringOfChar(' ', 11 - Length(Diferenca)) + Diferenca;

      Meio := Copy(CDSFechamento.FieldByName('TIPO_PAGAMENTO').AsString, 1, 15);
      Meio := StringOfChar(' ', 15 - Length(Meio)) + Meio;

      TotCalculado := TotCalculado + ValorCalculado;
      TotDeclarado := TotDeclarado + ValorDeclarado;
      TotDiferenca := TotDiferenca + ValorDiferenca;

      FDataModule.ACBrECF.LinhaRelatorioGerencial(Meio + Calculado + Declarado + Diferenca);

      CDSFechamento.Next;
    end;
    CDSFechamento.First;
    CDSFechamento.EnableControls;

    FDataModule.ACBrECF.LinhaRelatorioGerencial(StringOfChar('-', 48));

    Calculado := FloatToStrF(TotCalculado, ffNumber, 9, 2);
    Calculado := StringOfChar(' ', 11 - Length(Calculado)) + Calculado;
    Declarado := FloatToStrF(TotDeclarado, ffNumber, 9, 2);
    Declarado := StringOfChar(' ', 11 - Length(Declarado)) + Declarado;
    Diferenca := FloatToStrF(TotDiferenca, ffNumber, 9, 2);
    Diferenca := StringOfChar(' ', 11 - Length(Diferenca)) + Diferenca;

    FDataModule.ACBrECF.LinhaRelatorioGerencial('TOTAL.........:' + Calculado + Declarado + Diferenca);
    FDataModule.ACBrECF.PulaLinhas(4);
    FDataModule.ACBrECF.LinhaRelatorioGerencial('    ________________________________________    ');
    FDataModule.ACBrECF.LinhaRelatorioGerencial('                 VISTO DO CAIXA                 ');
    FDataModule.ACBrECF.PulaLinhas(3);
    FDataModule.ACBrECF.LinhaRelatorioGerencial('    ________________________________________    ');
    FDataModule.ACBrECF.LinhaRelatorioGerencial('               VISTO DO SUPERVISOR              ');

    FDataModule.ACBrECF.FechaRelatorio;
    TPAFUtil.GravarR06('RG');
    Application.ProcessMessages;

  finally
  end;
end;
{$EndRegion 'Impress�o do Fechamento'}



end.
