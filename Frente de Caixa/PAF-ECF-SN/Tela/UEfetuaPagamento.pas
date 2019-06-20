{ *******************************************************************************
Title: T2TiPDV
Description: Janela para selecionar as formas de pagamento e finalizar a venda

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

{ *******************************************************************************
Opera��es TEF Discado:

ATV		Verifica se o Gerenciador Padr�o est� ativo
ADM		Permite o acionamento da Solu��o TEF Discado para execu��o das fun��es administrativas
CHQ		Pedido de autoriza��o para transa��o por meio de cheque
CRT		Pedido de autoriza��o para transa��o por meio de cart�o
CNC		Cancelamento de venda efetuada por qualquer meio de pagamento
CNF		Confirma��o da venda e impress�o de cupom
NCN		N�o confirma��o da venda e/ou da impress�o.
******************************************************************************* }

unit UEfetuaPagamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, UBase,
  Dialogs, Grids, DBGrids, JvExDBGrids, JvDBGrid, StdCtrls, JvExStdCtrls,
  Buttons, JvExButtons, JvBitBtn, pngimage, ExtCtrls, Mask,
  JvEdit, JvValidateEdit, JvExForms, JvScrollBox, Generics.Collections, Biblioteca,
  JvExControls, JvEnterTab, DB, DBClient, ACBrTEFD, ACBrTEFDClass,
  JvCombobox, JvExMask, JvToolEdit, Constantes, MidasLib,
  ACBrDevice, ACBrECF, dateutils, JvComponentBase, Tipos,
  JvBaseEdits, JvSpeedButton, TypInfo, Controller, EcfTotalTipoPagamentoVO;

type
  TFEfetuaPagamento = class(TFBase)
    Image1: TImage;
    GroupBox1: TGroupBox;
    JvScrollBox1: TJvScrollBox;
    botaoConfirma: TJvBitBtn;
    GroupBox2: TGroupBox;
    labelDescricaoTotalVenda: TLabel;
    labelTotalVenda: TLabel;
    Bevel1: TBevel;
    labelDescricaoDesconto: TLabel;
    Bevel2: TBevel;
    labelDesconto: TLabel;
    labelDescricaoAcrescimo: TLabel;
    Bevel3: TBevel;
    labelAcrescimo: TLabel;
    labelTotalReceber: TLabel;
    Bevel4: TBevel;
    labelDescricaoTotalReceber: TLabel;
    labelTotalRecebido: TLabel;
    Bevel5: TBevel;
    labelDescricaoTotalRecebido: TLabel;
    labelTroco: TLabel;
    Bevel6: TBevel;
    labelDescricaoTroco: TLabel;
    PanelConfirmaValores: TPanel;
    LabelConfirmaValores: TLabel;
    botaoNao: TBitBtn;
    botaoSim: TBitBtn;
    JvEnterAsTab1: TJvEnterAsTab;
    GridValores: TJvDBGrid;
    GroupBox3: TGroupBox;
    ComboTipoPagamento: TComboBox;
    labelDescricaoAindaFalta: TLabel;
    labelAindaFalta: TLabel;
    Bevel7: TBevel;
    Label1: TLabel;
    ACBrTEFD: TACBrTEFD;
    Label2: TLabel;
    EditValorPago: TJvCalcEdit;
    BotaoCancela: TJvSpeedButton;
    CDSValores: TClientDataSet;
    DSValores: TDataSource;
    CDSValoresDESCRICAO: TStringField;
    CDSValoresVALOR: TFloatField;
    CDSValoresID: TIntegerField;
    CDSValoresTEF: TStringField;
    CDSValoresNSU: TStringField;
    CDSValoresREDE: TStringField;
    CDSValoresINDICE_TRANSACAO: TIntegerField;
    CDSValoresINDICE_LISTA: TIntegerField;
    procedure FechamentoRapido;
    procedure TelaPadrao;
    procedure FechaVendaComProblemas;
    procedure OrdenaLista;
    procedure SubTotalizaCupom;
    procedure FormActivate(Sender: TObject);
    procedure botaoConfirmaClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure botaoSimClick(Sender: TObject);
    procedure botaoNaoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditValorPagoExit(Sender: TObject);
    procedure VerificaSaldoRestante;
    procedure FinalizaVenda;
    procedure AtualizaLabelsValores;
    procedure CancelaOperacao;
    procedure BotaoCancelaClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure GridValoresKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ACBrTEFDAguardaResp(Arquivo: string; SegundosTimeOut: Integer; var Interromper: Boolean);
    procedure ACBrTEFDAntesCancelarTransacao(RespostaPendente: TACBrTEFDResp);
    procedure ACBrTEFDAntesFinalizarRequisicao(Req: TACBrTEFDReq);
    procedure ACBrTEFDBloqueiaMouseTeclado(Bloqueia: Boolean; var Tratado: Boolean);
    procedure ACBrTEFDComandaECF(Operacao: TACBrTEFDOperacaoECF; Resp: TACBrTEFDResp; var RetornoECF: Integer);
    procedure ACBrTEFDComandaECFAbreVinculado(COO, IndiceECF: string; Valor: Double; var RetornoECF: Integer);
    procedure ACBrTEFDComandaECFImprimeVia(TipoRelatorio: TACBrTEFDTipoRelatorio; Via: Integer; ImagemComprovante: TStringList; var RetornoECF: Integer);
    procedure ACBrTEFDComandaECFPagamento(IndiceECF: string; Valor: Double; var RetornoECF: Integer);
    procedure ACBrTEFDExibeMsg(Operacao: TACBrTEFDOperacaoMensagem; Mensagem: string; var AModalResult: TModalResult);
    procedure ACBrTEFDInfoECF(Operacao: TACBrTEFDInfoECF; var RetornoECF: string);
    procedure ACBrTEFDRestauraFocoAplicacao(var Tratado: Boolean);
    procedure ComboTipoPagamentoExit(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FEfetuaPagamento: TFEfetuaPagamento;
  ListaTotalTipoPagamento: TObjectList<TEcfTotalTipoPagamentoVO>;
  SaldoRestante, TotalVenda, Desconto, Acrescimo, TotalReceber, TotalRecebido, ValorDinheiro, Troco: Extended;
  TransacaoComTef, ImpressaoOK, CupomCancelado, PodeFechar, StatusTransacao, SegundoCartaoCancelado: Boolean;
  IndiceTransacaoTef, QuantidadeCartao: Integer;

implementation

uses
  UDataModule, UCaixa, UFechaEfetuaPagamento, UParcelamento, UCheques,
  PAFUtil, ECFUtil,
  EcfTipoPagamentoVO;

{$R *.dfm}

procedure TFEfetuaPagamento.FormActivate(Sender: TObject);
begin
  TotalVenda := 0;
  Desconto := 0;
  Acrescimo := 0;
  TotalReceber := 0;
  TotalRecebido := 0;
  ValorDinheiro := 0;
  Troco := 0;
  QuantidadeCartao := 0;

  Color := StringToColor(Sessao.Configuracao.CorJanelasInternas);

  if Sessao.VendaAtual.TaxaAcrescimo > 0 then
    Sessao.VendaAtual.Acrescimo := TruncaValor(Sessao.VendaAtual.TaxaAcrescimo / 100 * Sessao.VendaAtual.ValorVenda, Constantes.TConstantes.DECIMAIS_VALOR);
  if Sessao.VendaAtual.TaxaDesconto > 0 then
    Sessao.VendaAtual.Desconto := TruncaValor(Sessao.VendaAtual.TaxaDesconto / 100 * Sessao.VendaAtual.ValorVenda, Constantes.TConstantes.DECIMAIS_VALOR);

  // preenche valores nas variaveis
  TotalVenda := Sessao.VendaAtual.ValorVenda;
  Acrescimo := Sessao.VendaAtual.Acrescimo;
  Desconto := Sessao.VendaAtual.Desconto;
  TotalReceber := TruncaValor(TotalVenda + Acrescimo - Desconto, Constantes.TConstantes.DECIMAIS_VALOR);
  SaldoRestante := TotalReceber;

  SegundoCartaoCancelado := False;
  TransacaoComTef := False;
  CupomCancelado := False;
  PodeFechar := True;
  IndiceTransacaoTef := -1;

  AtualizaLabelsValores;

  if SaldoRestante > 0 then
    EditValorPago.Text := FormatFloat('0.00', SaldoRestante)
  else
    EditValorPago.Text := FormatFloat('0.00', 0);

  ComboTipoPagamento.SetFocus;

  // lista que vai acumular os meios de pagamento
  ListaTotalTipoPagamento := TObjectList<TEcfTotalTipoPagamentoVO>.Create(True);

  // tela padr�o
  TelaPadrao;
end;

procedure TFEfetuaPagamento.AtualizaLabelsValores;
begin
  labelTotalVenda.Caption := FormatFloat('#,###,###,##0.00', TotalVenda);
  labelAcrescimo.Caption := FormatFloat('#,###,###,##0.00', Acrescimo);
  labelDesconto.Caption := FormatFloat('#,###,###,##0.00', Desconto);
  labelTotalReceber.Caption := FormatFloat('#,###,###,##0.00', TotalReceber);
  labelTotalRecebido.Caption := FormatFloat('#,###,###,##0.00', TotalRecebido);
  if SaldoRestante > 0 then
    labelAindaFalta.Caption := FormatFloat('#,###,###,##0.00', SaldoRestante)
  else
    labelAindaFalta.Caption := FormatFloat('#,###,###,##0.00', 0);
  labelTroco.Caption := FormatFloat('#,###,###,##0.00', Troco);
end;

procedure TFEfetuaPagamento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(ListaTotalTipoPagamento);
  CDSValores.Close;
  Action := caFree;
end;

procedure TFEfetuaPagamento.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (PodeFechar = True) and (Sessao.StatusCaixa = scAberto) then
  begin
    Application.CreateForm(TFFechaEfetuaPagamento, FFechaEfetuaPagamento);
    FFechaEfetuaPagamento.Left := self.Left;
    FFechaEfetuaPagamento.Top := self.Top + self.Height - FFechaEfetuaPagamento.Height;
    FFechaEfetuaPagamento.Width := self.Width;
    FFechaEfetuaPagamento.ShowModal;
  end;
  CanClose := PodeFechar;
end;

procedure TFEfetuaPagamento.TelaPadrao;
var
  i: Integer;
begin
  for i := 0 to Sessao.ListaTipoPagamento.Count - 1 do
    ComboTipoPagamento.Items.Add(TEcfTipoPagamentoVO(Sessao.ListaTipoPagamento.Items[i]).Descricao);
  ComboTipoPagamento.ItemIndex := 0;
end;

procedure TFEfetuaPagamento.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F2 then
  begin
    if CDSValores.RecordCount = 0 then
    begin
      if Application.MessageBox('Confirma valores e encerra venda por fechamento r�pido?', 'Finalizar venda', Mb_YesNo + Mb_IconQuestion) = IdYes then
      begin
        FechamentoRapido;
      end;
    end
    else
    begin
      Application.MessageBox('J� existem valores informados. Imposs�vel utilizar Fechamento R�pido.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
      ComboTipoPagamento.SetFocus;
    end;
  end;

  if Key = VK_F12 then
    botaoConfirma.Click;

  if Key = VK_ESCAPE then
    BotaoCancela.Click;

  if Key = VK_F5 then
  begin
    if CDSValores.RecordCount > 0 then
      GridValores.SetFocus
    else
    begin
      Application.MessageBox('N�o existem valores informados para serem removidos.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
      ComboTipoPagamento.SetFocus;
    end;
  end;
end;

procedure TFEfetuaPagamento.FechamentoRapido;
begin
  StatusTransacao := True;
  botaoSim.Click;
end;

// controle das teclas digitadas na Grid
procedure TFEfetuaPagamento.GridValoresKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    if CDSValores.FieldByName('TEF').AsString = 'S' then
      Application.MessageBox('Opera��o n�o permitida.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION)
    else
    begin
      if Application.MessageBox('Deseja remover o valor selecionado?', 'Remover ', Mb_YesNo + Mb_IconQuestion) = IdYes then
      begin
        TotalRecebido := TruncaValor(TotalRecebido - CDSValores.FieldByName('VALOR').AsFloat, Constantes.TConstantes.DECIMAIS_VALOR);
        Troco := TruncaValor(TotalRecebido - TotalReceber, Constantes.TConstantes.DECIMAIS_VALOR);
        if Troco < 0 then
          Troco := 0;

        ListaTotalTipoPagamento.Delete(CDSValores.FieldByName('INDICE_LISTA').AsInteger);

        CDSValores.Delete;
        VerificaSaldoRestante;
        if SaldoRestante > 0 then
          EditValorPago.Text := FormatFloat('0.00', SaldoRestante)
        else
          EditValorPago.Text := FormatFloat('0.00', 0);
      end;
      ComboTipoPagamento.SetFocus;
    end;
  end;
  if Key = VK_RETURN then
    ComboTipoPagamento.SetFocus;
end;

procedure TFEfetuaPagamento.Label1Click(Sender: TObject);
begin
  keybd_event(VK_F2, 0, 0, 0);
end;

procedure TFEfetuaPagamento.Label2Click(Sender: TObject);
begin
  keybd_event(VK_F5, 0, 0, 0);
end;

procedure TFEfetuaPagamento.BotaoCancelaClick(Sender: TObject);
begin
  CancelaOperacao;
end;

procedure TFEfetuaPagamento.botaoConfirmaClick(Sender: TObject);
begin
  VerificaSaldoRestante;
  // se n�o houver mais saldo no ECF � porque j� devemos finalizar a venda
  if SaldoRestante <= 0 then
  begin
    if Application.MessageBox('Deseja finalizar a venda?', 'Finalizar venda', Mb_YesNo + Mb_IconQuestion) = IdYes then
    begin
      FinalizaVenda;
    end
    else
    begin
      if TransacaoComTef then
      begin
        ACBrTEFD.CancelarTransacoesPendentes;
        Sessao.VendaAtual.CupomCancelado := 'S';
        Sessao.StatusCaixa := scAberto;
        FechaVendaComProblemas;
        PodeFechar := True;
        Close;
      end;
    end;
  end
  else
  begin
    Application.MessageBox('Valores informados n�o s�o suficientes para finalizar a venda.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
    ComboTipoPagamento.SetFocus;
  end;
end;

procedure TFEfetuaPagamento.EditValorPagoExit(Sender: TObject);
begin
  if EditValorPago.Value > 0 then
  begin
    VerificaSaldoRestante;
    // se ainda tem saldo no ECF para pagamento
    if SaldoRestante > 0 then
    begin
      PanelConfirmaValores.Visible := True;
      PanelConfirmaValores.BringToFront;
      LabelConfirmaValores.Caption := 'Confirma forma de pagamento e valor?';
      botaoSim.SetFocus;
    end
    else
      Application.MessageBox('Todos os valores j� foram recebidos. Finalize a venda.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
  end
  else
  begin
    Application.MessageBox('Valor n�o pode ser menor ou igual a zero.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
    EditValorPago.Clear;
    ComboTipoPagamento.SetFocus;
  end;
end;

procedure TFEfetuaPagamento.VerificaSaldoRestante;
var
  RecebidoAteAgora: Extended;
begin
  RecebidoAteAgora := 0;

  CDSValores.DisableControls;
  CDSValores.First;
  while Not CDSValores.Eof do
  begin
    RecebidoAteAgora := TruncaValor(RecebidoAteAgora + CDSValores.FieldByName('VALOR').AsFloat, Constantes.TConstantes.DECIMAIS_VALOR);
    CDSValores.Next;
  end;
  CDSValores.EnableControls;

  SaldoRestante := TruncaValor(TotalReceber - RecebidoAteAgora, Constantes.TConstantes.DECIMAIS_VALOR);

  AtualizaLabelsValores;
end;

procedure TFEfetuaPagamento.botaoNaoClick(Sender: TObject);
var
  i: Integer;
begin
  PanelConfirmaValores.Visible := False;
  ComboTipoPagamento.SetFocus;
end;

procedure TFEfetuaPagamento.botaoSimClick(Sender: TObject);
var
  TipoPagamento: TEcfTipoPagamentoVO;
  TotalTipoPagamento: TEcfTotalTipoPagamentoVO;
  ValorInformado: Extended;
  Mensagem: String;
begin
  TipoPagamento := TEcfTipoPagamentoVO(Sessao.ListaTipoPagamento.Items[ComboTipoPagamento.ItemIndex].Clone);
  ValorInformado := TruncaValor(EditValorPago.Value, Constantes.TConstantes.DECIMAIS_VALOR);

  if ((TipoPagamento.Descricao = 'CONSULTA CHEQUE') or (TipoPagamento.Descricao = 'CONSULTA CHQ TECBAN')) and (TransacaoComTef) then
  begin
    Application.MessageBox('Compra com Cart�o e Cheque n�o permitida.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
    ComboTipoPagamento.SetFocus;
    PanelConfirmaValores.Visible := False;
    PanelConfirmaValores.SendToBack;
  end
  else
  begin
    TotalTipoPagamento := TEcfTotalTipoPagamentoVO.Create;

    if ((TransacaoComTef) or (TipoPagamento.TEF = 'S')) and (ValorInformado > SaldoRestante) then
    begin
      Application.MessageBox('Compra n�o permite troco.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
      ComboTipoPagamento.SetFocus;
      PanelConfirmaValores.Visible := False;
      PanelConfirmaValores.SendToBack;
    end
    else if (TipoPagamento.TEF = 'S') and (QuantidadeCartao >= Sessao.Configuracao.QuantidadeMaximaCartoes) then
    begin
      Application.MessageBox('J� foi utilizada a quantidade m�xima de cart�es para efetuar pagamento.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
      ComboTipoPagamento.SetFocus;
      PanelConfirmaValores.Visible := False;
      PanelConfirmaValores.SendToBack;
    end
    else if (TipoPagamento.TEF = 'S') and (QuantidadeCartao >= Sessao.Configuracao.QuantidadeMaximaCartoes - 1) and (ValorInformado <> SaldoRestante) then
    begin
      Mensagem := 'M�ltiplos Cart�es. Transa��o suporta at� ' + IntToStr(Sessao.Configuracao.QuantidadeMaximaCartoes) + ' cart�es.'#$D#$A' Informe o valor exato para fechar a venda.';
      Application.MessageBox(PChar(Mensagem), 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
      ComboTipoPagamento.SetFocus;
      PanelConfirmaValores.Visible := False;
      PanelConfirmaValores.SendToBack;
    end
    else
    begin
      GroupBox3.Enabled := False;
      StatusTransacao := True;
      if TipoPagamento.TEF = 'S' then
      begin
        try
          try
            ACBrTEFD.Inicializar(TACBrTEFDTipo(StrToInt(TipoPagamento.TefTipoGP)));
          except
            Application.MessageBox('GP para tipo de pagamento solicitado n�o instalado.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
            StatusTransacao := False;
          end;
          if (TipoPagamento.Descricao = 'CONSULTA CHEQUE') or (TipoPagamento.Descricao = 'CONSULTA CHQ TECBAN') then
            StatusTransacao := ACBrTEFD.CHQ(ValorInformado, TipoPagamento.Codigo, FDataModule.ACBrECF.NumCOO)
          else
            StatusTransacao := ACBrTEFD.CRT(ValorInformado, TipoPagamento.Codigo, FDataModule.ACBrECF.NumCOO);

          if StatusTransacao then
          begin
            Inc(IndiceTransacaoTef);
            TotalTipoPagamento.NSU := ACBrTEFD.RespostasPendentes[IndiceTransacaoTef].NSU;
            TotalTipoPagamento.Rede := ACBrTEFD.RespostasPendentes[IndiceTransacaoTef].Rede;

            if (ACBrTEFD.RespostasPendentes[IndiceTransacaoTef].TipoTransacao >= 10) and (ACBrTEFD.RespostasPendentes[IndiceTransacaoTef].TipoTransacao <= 12) then
              TotalTipoPagamento.CartaoDC := 'C';
            if (ACBrTEFD.RespostasPendentes[IndiceTransacaoTef].TipoTransacao >= 20) and (ACBrTEFD.RespostasPendentes[IndiceTransacaoTef].TipoTransacao <= 25) then
              TotalTipoPagamento.CartaoDC := 'D';

            Inc(QuantidadeCartao);
            TransacaoComTef := True;
            PodeFechar := False;
          end;
        except
        end;
      end;

      if StatusTransacao then
      begin

        CDSValores.Append;
        CDSValores.FieldByName('DESCRICAO').AsString := ComboTipoPagamento.Text;
        CDSValores.FieldByName('VALOR').AsExtended := EditValorPago.Value;
        if TipoPagamento.TEF = 'S' then
        begin
          CDSValores.FieldByName('TEF').AsString := 'S';
          CDSValores.FieldByName('NSU').AsString := TotalTipoPagamento.NSU;
          CDSValores.FieldByName('REDE').AsString := TotalTipoPagamento.Rede;
          CDSValores.FieldByName('INDICE_TRANSACAO').AsInteger := IndiceTransacaoTef;
        end;
        CDSValores.Post;

        TotalRecebido := TruncaValor(TotalRecebido + EditValorPago.Value, Constantes.TConstantes.DECIMAIS_VALOR);
        Troco := TruncaValor(TotalRecebido - TotalReceber, Constantes.TConstantes.DECIMAIS_VALOR);
        if Troco < 0 then
          Troco := 0;
        VerificaSaldoRestante;

        TotalTipoPagamento.IdEcfVendaCabecalho := Sessao.VendaAtual.Id;
        TotalTipoPagamento.IdEcfTipoPagamento := TipoPagamento.Id;
        TotalTipoPagamento.Valor := TruncaValor(EditValorPago.Value, Constantes.TConstantes.DECIMAIS_VALOR);
        TotalTipoPagamento.Estorno := 'N';
        TotalTipoPagamento.SerieEcf := Sessao.Configuracao.EcfImpressoraVO.Serie;
        TotalTipoPagamento.COO := StrToInt(FDataModule.ACBrECF.NumCOO);
        TotalTipoPagamento.Ccf := StrToInt(FDataModule.ACBrECF.NumCCF);
        TotalTipoPagamento.Gnf := StrToInt(FDataModule.ACBrECF.NumGNF);

        TotalTipoPagamento.EcfTipoPagamentoVO := TipoPagamento;

        ListaTotalTipoPagamento.Add(TotalTipoPagamento);

        // guarda o �ndice da lista
        CDSValores.Edit;
        CDSValores.FieldByName('INDICE_LISTA').AsInteger := ListaTotalTipoPagamento.Count - 1;
        CDSValores.Post;
      end;
      PanelConfirmaValores.Visible := False;
      PanelConfirmaValores.SendToBack;
      if SaldoRestante > 0 then
        EditValorPago.Text := FormatFloat('0.00', SaldoRestante)
      else
        EditValorPago.Text := FormatFloat('0.00', 0);

      GroupBox3.Enabled := True;
      ComboTipoPagamento.SetFocus;
    end;

    VerificaSaldoRestante;
    if SaldoRestante <= 0 then
      FinalizaVenda;

    if SegundoCartaoCancelado then
    begin
      Application.MessageBox('Cupom fiscal cancelado. Ser� aberto novo cupom e deve-se informar novamente os pagamentos.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
      Sessao.VendaAtual.CupomCancelado := 'S';
      Sessao.StatusCaixa := scAberto;
      FechaVendaComProblemas;
      PodeFechar := True;
      Close;
    end;
  end;
end;

procedure TFEfetuaPagamento.FinalizaVenda;
var
  i: Integer;
begin
  ImpressaoOK := True;

  // subtotaliza o cupom
  SubTotalizaCupom;

  // manda os pagamentos para o ECF
  if TransacaoComTef then
    OrdenaLista;

  for i := 0 to ListaTotalTipoPagamento.Count - 1 do
  begin
    if ListaTotalTipoPagamento.Items[i].EcfTipoPagamentoVO.Tef <> 'S' then
      FDataModule.ACBrECF.EfetuaPagamento(ListaTotalTipoPagamento.Items[i].EcfTipoPagamentoVO.Codigo, ListaTotalTipoPagamento.Items[i].Valor);
  end;

  BlockInput(True);

  // finaliza o cupom
  ACBrTEFD.FinalizarCupom;

  // imprime as transacoes pendentes - comprovantes nao fiscais vinculados
  ACBrTEFD.ImprimirTransacoesPendentes;

  BlockInput(False);

  if ImpressaoOK then
  begin
    // grava os pagamentos no banco de dados
    TController.ExecutarMetodo('EcfTotalTipoPagamentoController.TEcfTotalTipoPagamentoController', 'InsereLista', [ListaTotalTipoPagamento], 'PUT', 'Boolean');

    // conclui o encerramento da venda - grava dados de cabecalho no banco
    Sessao.VendaAtual.ValorFinal := TotalReceber;
    Sessao.VendaAtual.ValorRecebido := TotalRecebido;
    Sessao.VendaAtual.Troco := Troco;
    Sessao.VendaAtual.StatusVenda := 'F';
    Sessao.StatusCaixa := scAberto;
    FCaixa.ConcluiEncerramentoVenda;

    // usado quando a gaveta tem sinal invertido
    if Sessao.Configuracao.GavetaSinalInvertido = 'S' then
      FDataModule.ACBrECF.GavetaSinalInvertido := True;

    if Sessao.Configuracao.GavetaUtilizacao > 0 then
      FDataModule.ACBrECF.AbreGaveta;

    PodeFechar := True;
    Close;
  end
  else
  begin
    if CupomCancelado then
    {
      ocorreu problema na impressao do comprovante do TEF. ECF Desligado.
      Sistema pergunta ao usu�rio se o mesmo quer tentar novamente. Usu�rio responde N�o.
      ECF agora est� ligado e o sistema consegue cancelar o cupom.
    }
    begin
      Application.MessageBox('Problemas no ECF. Cupom Fiscal Cancelado.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
      Sessao.VendaAtual.CupomCancelado := 'S';
      Sessao.StatusCaixa := scAberto;
      FechaVendaComProblemas;
      PodeFechar := True;
      Close;
    end
    else

    {
      ocorreu problema na impressao do comprovante do TEF. ECF Desligado.
      Sistema pergunta ao usu�rio se o mesmo quer tentar novamente. Usu�rio responde N�o.
      ECF continua desligado e o sistema n�o consegue cancelar o cupom.
    }
    begin
      Application.MessageBox('Problemas no ECF. Aplica��o funcionar� apenas para consulta.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
      Sessao.StatusCaixa := scSomenteConsulta;
      FechaVendaComProblemas;
      PodeFechar := True;
      Close;
    end;
  end;
end;

procedure TFEfetuaPagamento.FechaVendaComProblemas;
var
  i: Integer;
begin
  // altera o status da venda para C
  Sessao.VendaAtual.StatusVenda := 'C';
  FCaixa.ConcluiEncerramentoVenda;

  // grava os pagamentos no banco de dados com o indicador de estorno
  for i := 0 to ListaTotalTipoPagamento.Count - 1 do
    TEcfTotalTipoPagamentoVO(ListaTotalTipoPagamento.Items[i]).Estorno := 'S';
  TController.ExecutarMetodo('EcfTotalTipoPagamentoController.TEcfTotalTipoPagamentoController', 'InsereLista', [ListaTotalTipoPagamento], 'PUT', 'Boolean');
end;

procedure TFEfetuaPagamento.CancelaOperacao;
begin
  if TransacaoComTef then
  begin
    if Application.MessageBox('Existem pagamentos no cart�o. O cupom fiscal ser� cancelado. Deseja continuar?', 'Pergunta do Sistema', Mb_YesNo + Mb_IconQuestion) = IdYes then
    begin
      ACBrTEFD.CancelarTransacoesPendentes;
      if CupomCancelado then
      begin
        Sessao.VendaAtual.CupomCancelado := 'S';
        Sessao.StatusCaixa := scAberto;
        FechaVendaComProblemas;
        Application.MessageBox('Transa��o com cart�o cancelada. Cupom Fiscal Cancelado.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
      end
      else
      begin
        Sessao.StatusCaixa := scSomenteConsulta;
        FechaVendaComProblemas;
        Application.MessageBox('Problemas no ECF. Aplica��o funcionar� apenas para consulta.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
      PodeFechar := True;
      Close;
    end;
  end
  else
    Close;
end;

procedure TFEfetuaPagamento.ComboTipoPagamentoExit(Sender: TObject);
var
  TipoPagamento: TEcfTipoPagamentoVO;
begin
  TipoPagamento := TEcfTipoPagamentoVO(Sessao.ListaTipoPagamento.Items[ComboTipoPagamento.ItemIndex]);

  if Assigned(TipoPagamento) then
  begin
    if TipoPagamento.GeraParcelas = 'S' then
    begin
      VerificaSaldoRestante;
      if SaldoRestante > 0 then
      begin
        try
          Application.CreateForm(TFParcelamento, FParcelamento);
          FParcelamento.editNome.Text := Sessao.VendaAtual.NomeCliente;
          FParcelamento.editCPF.Text := Sessao.VendaAtual.CpfCnpjCliente;
          FParcelamento.editValorVenda.Text := labelTotalVenda.Caption;
          FParcelamento.editValorRecebido.Text := labelTotalRecebido.Caption;
          FParcelamento.editValorParcelar.Value := SaldoRestante;
          FParcelamento.editVencimento.Date := Date() + 30;

          if Sessao.VendaAtual.Desconto > 0 then
          begin
            FParcelamento.lblDesconto.Caption := 'Desconto';
            FParcelamento.editDesconto.Value := Sessao.VendaAtual.Desconto;
          end;

          if Sessao.VendaAtual.Acrescimo > 0 then
          begin
            FParcelamento.lblDesconto.Caption := 'Acr�scimo';
            FParcelamento.editDesconto.Value := Sessao.VendaAtual.Acrescimo;
          end;

          if (FParcelamento.ShowModal = MROK) then
          begin
            // Depois d chamar a tela de parcelamente, se tudo deu certo finaliza a Venda.
            EditValorPago.Value := SaldoRestante;
            botaoSimClick(Self);
          end
          else
            ComboTipoPagamento.SetFocus;

        finally
          FreeAndNil(FParcelamento);
        end;
      end;
    end
    else if TipoPagamento.GeraParcelas = 'C' then
    begin
      VerificaSaldoRestante;
      if SaldoRestante > 0 then
      begin
        try
          Application.CreateForm(TFCheques, FCheques);
          FCheques.editNome.Text := Sessao.VendaAtual.NomeCliente;
          FCheques.editCPF.Text := Sessao.VendaAtual.CpfCnpjCliente;
          FCheques.edValor.Text := labelTotalVenda.Caption;

          if (FCheques.ShowModal = MROK) then
          begin
            // Depois d chamar a tela de parcelamente, se tudo deu certo finaliza a Venda.
            EditValorPago.Value := SaldoRestante;
            botaoSimClick(Self);
          end
          else
            ComboTipoPagamento.SetFocus;
        finally
          FreeAndNil(FCheques);
        end;
      end;
    end;
  end;
end;

procedure TFEfetuaPagamento.SubTotalizaCupom;
begin
  if Sessao.VendaAtual.Desconto > 0 then
    TECFUtil.SubTotalizaCupom(Sessao.VendaAtual.Desconto * -1)
  else if Sessao.VendaAtual.Acrescimo > 0 then
    TECFUtil.SubTotalizaCupom(Sessao.VendaAtual.Acrescimo)
  else
    TECFUtil.SubTotalizaCupom(0);
end;

// pode ser muito melhorado
// verificar o m�todo Sort de Generics.Collections juntamente com utiliza��o de TComparer
procedure TFEfetuaPagamento.OrdenaLista;
var
  i: Integer;
  ListaTotalTipoPagamentoLocal: TObjectList<TEcfTotalTipoPagamentoVO>;
  ObjetoLocal: TEcfTotalTipoPagamentoVO;
begin
  try
    ListaTotalTipoPagamentoLocal := TObjectList<TEcfTotalTipoPagamentoVO>.Create;

    // no primeiro la�o insere na lista s� quem nao tem TEF
    for i := 0 to ListaTotalTipoPagamento.Count - 1 do
    begin
      if TEcfTotalTipoPagamentoVO(ListaTotalTipoPagamento.Items[i]).EcfTipoPagamentoVO.Tef = 'N' then
      begin
        ObjetoLocal := TEcfTotalTipoPagamentoVO(ListaTotalTipoPagamento.Items[i].Clone);
        ListaTotalTipoPagamentoLocal.Add(ObjetoLocal);
      end;
    end;

    // no segundo la�o insere os pagamentos que tem tef
    for i := 0 to ListaTotalTipoPagamento.Count - 1 do
    begin
      if TEcfTotalTipoPagamentoVO(ListaTotalTipoPagamento.Items[i]).EcfTipoPagamentoVO.Tef = 'S' then
      begin
        ObjetoLocal := TEcfTotalTipoPagamentoVO(ListaTotalTipoPagamento.Items[i].Clone);
        ListaTotalTipoPagamentoLocal.Add(ObjetoLocal);
      end;
    end;

    FreeAndNil(ListaTotalTipoPagamento);
    ListaTotalTipoPagamento := ListaTotalTipoPagamentoLocal;
  finally
  end;
end;

{$Region 'M�todos do Componente ACBrTEFD'}
procedure TFEfetuaPagamento.ACBrTEFDAguardaResp(Arquivo: string; SegundosTimeOut: Integer; var Interromper: Boolean);
var
  Msg: String;
begin
  Msg := '';
  if (ACBrTEFD.GPAtual in [gpCliSiTef, gpVeSPague]) then // � TEF dedicado?
  begin
    if Arquivo = '23' then // Est� aguardando Pin-Pad ?
    begin
      if ACBrTEFD.TecladoBloqueado then
      begin
        ACBrTEFD.BloquearMouseTeclado(False); // Desbloqueia o Teclado
      end;
      Msg := 'Tecle "ESC" para cancelar.';
    end;
  end
  else
    Msg := 'Aguardando: ' + Arquivo + ' ' + IntToStr(SegundosTimeOut);

  if Msg <> '' then
    FCaixa.labelMensagens.Caption := Msg;
  Application.ProcessMessages;
end;

procedure TFEfetuaPagamento.ACBrTEFDAntesCancelarTransacao(RespostaPendente: TACBrTEFDResp);
var
  Est: TACBrECFEstado;
begin
  Est := FDataModule.ACBrECF.Estado;
  case Est of
    estVenda, estPagamento:
      begin
        TECFUtil.CancelaCupom;
        CupomCancelado := True;
      end;
    estRelatorio:
      begin
        FDataModule.ACBrECF.FechaRelatorio;
        TPAFUtil.GravarR06('CC');
      end
  else
    if not(Est in [estLivre, estDesconhecido, estNaoInicializada]) then
      FDataModule.ACBrECF.CorrigeEstadoErro(False);
  end;
end;

procedure TFEfetuaPagamento.ACBrTEFDAntesFinalizarRequisicao(Req: TACBrTEFDReq);
begin
  if Req.Header = 'CRT' then
    Req.GravaInformacao(777, 777, 'REDECARD');
end;

procedure TFEfetuaPagamento.ACBrTEFDBloqueiaMouseTeclado(Bloqueia: Boolean; var Tratado: Boolean);
begin
  FCaixa.Enabled := not Bloqueia;
  Tratado := False; { Se "False" --> Deixa executar o c�digo de Bloqueio do ACBrTEFD }
end;

procedure TFEfetuaPagamento.ACBrTEFDComandaECF(Operacao: TACBrTEFDOperacaoECF; Resp: TACBrTEFDResp; var RetornoECF: Integer);
var
  Mensagem, ML: String;
begin
  Mensagem := '';

  try
    case Operacao of
      opeAbreGerencial:
        FDataModule.ACBrECF.AbreRelatorioGerencial;

      opeCancelaCupom:
        begin
          ImpressaoOK := False;
          try
            TECFUtil.CancelaCupom;
            CupomCancelado := True;
          except
            CupomCancelado := False;
          end;
        end;

      opeFechaCupom:
        begin
          if Sessao.VendaAtual.IdEcfPreVendaCabecalho > 0 then
          begin
            Mensagem := 'PV' + StringOfChar('0', 10 - Length(IntToStr(Sessao.VendaAtual.IdEcfPreVendaCabecalho))) + IntToStr(Sessao.VendaAtual.IdEcfPreVendaCabecalho);
          end;
          if Sessao.VendaAtual.IdEcfDAV > 0 then
          begin
            Mensagem := 'DAV' + StringOfChar('0', 10 - Length(IntToStr(Sessao.VendaAtual.IdEcfDAV))) + IntToStr(Sessao.VendaAtual.IdEcfDAV);
          end;

          if Sessao.Configuracao.EcfEmpresaVO.UF = 'DF' then
            Mensagem := UCaixa.MD5 + Mensagem + 'NL' + #13 + #10
          else
            Mensagem := UCaixa.MD5 + Mensagem + #13 + #10;

          try
            if Sessao.Configuracao.EcfEmpresaVO.UF = 'MG' then
            begin
              Mensagem := Mensagem + 'MINAS LEGAL:' + COPY(DevolveInteiro(Sessao.Configuracao.EcfEmpresaVO.CNPJ), 1, 8) + ' ' + FormatDateTime('ddmmyyyy', FDataModule.ACBrECF.DataHora);
              if Sessao.VendaAtual.ValorFinal >= 1 then
              begin
                Mensagem := Mensagem + ' ' + DevolveInteiro(Format('%7.0n', [Sessao.VendaAtual.ValorFinal]));
              end;
              Mensagem := Mensagem + #13 + #10;
            end
            else if Sessao.Configuracao.EcfEmpresaVO.UF = 'RJ' then
            begin
              Mensagem := Mensagem + 'CUPOM MANIA, CONCORRA A PR�MIOS';
              Mensagem := Mensagem + #13 + #10;
              Mensagem := Mensagem + 'ENVIE SMS P/ 6789:' + COPY(DevolveInteiro(Sessao.Configuracao.EcfEmpresaVO.InscricaoEstadual), 1, 8) + FormatDateTime('ddmmyy', FDataModule.ACBrECF.DataHora);
              Mensagem := Mensagem + StringOfChar('0', 6 - Length(FDataModule.ACBrECF.NumCOO)) + FDataModule.ACBrECF.NumCOO + FDataModule.ACBrECF.NumECF;
              Mensagem := Mensagem + #13 + #10;
            end
            // AJUSTAR PARA O DF IDENTIFICANDO SE O ESTABELECIMENTO EST� INCLUIDO NO PROGRAMA E CALCULANDO O TRIBUTO CORRETAMENTE
            else if Sessao.Configuracao.EcfEmpresaVO.UF = 'DF' then
            begin
              Mensagem := Mensagem + 'ESTABELECIMENTO INCLU�DO NO PROGRAMA DE';
              Mensagem := Mensagem + #13 + #10;
              Mensagem := Mensagem + 'CONCESS�O DE CR�DITOS - LEI n� 4.159/08';
              Mensagem := Mensagem + #13 + #10;
              Mensagem := Mensagem + 'NOTA LEGAL: ICMS = ' + FloatToStr(Sessao.VendaAtual.Icms);
              Mensagem := Mensagem + #13 + #10;
            end
            else if Sessao.Configuracao.EcfEmpresaVO.UF = 'pb' then
            begin
              Mensagem := Mensagem + 'PARA�BA LEGAL - RECEITA CIDAD�';
              Mensagem := Mensagem + #13 + #10;
              Mensagem := Mensagem + 'TORPEDO PREMIADO:' + COPY(DevolveInteiro(Sessao.Configuracao.EcfEmpresaVO.InscricaoEstadual), 1, 8) + ' ' + FormatDateTime('ddmmyyyy', FDataModule.ACBrECF.DataHora);
              Mensagem := Mensagem + ' ' + StringOfChar('0', 6 - Length(FDataModule.ACBrECF.NumCOO)) + FDataModule.ACBrECF.NumCOO;
              Mensagem := Mensagem + ' ' + DevolveInteiro(Format('%7.0n', [Sessao.VendaAtual.ValorFinal]));
              Mensagem := Mensagem + #13 + #10;
            end;

            TECFUtil.FechaCupom(Mensagem + Sessao.Configuracao.MensagemCupom);
          finally
          end;
        end;

      opeSubTotalizaCupom:
        FDataModule.ACBrECF.SubTotalizaCupom(0);

      opeFechaGerencial, opeFechaVinculado:
        begin
          FDataModule.ACBrECF.FechaRelatorio;
          TPAFUtil.GravarR06('CC');
        end;

      opePulaLinhas:
        begin
          FDataModule.ACBrECF.PulaLinhas(FDataModule.ACBrECF.LinhasEntreCupons);
          FDataModule.ACBrECF.CortaPapel(True);
          Sleep(200);
        end;
    end;

    RetornoECF := 1;
  except
    RetornoECF := 0;
  end;
end;

procedure TFEfetuaPagamento.ACBrTEFDComandaECFAbreVinculado(COO, IndiceECF: string; Valor: Double; var RetornoECF: Integer);
begin
  try
    FDataModule.ACBrECF.AbreCupomVinculado(COO, IndiceECF, Valor);
    RetornoECF := 1;
  except
    RetornoECF := 0;
  end;
end;

procedure TFEfetuaPagamento.ACBrTEFDComandaECFImprimeVia(TipoRelatorio: TACBrTEFDTipoRelatorio; Via: Integer; ImagemComprovante: TStringList; var RetornoECF: Integer);
begin
  { *** Se estiver usando ACBrECF... Lembre-se de configurar ***
    ACBrECF1.MaxLinhasBuffer   := 3; // Os homologadores permitem no m�ximo
    // Impressao de 3 em 3 linhas
    ACBrECF1.LinhasEntreCupons := 7; // (ajuste conforme o seu ECF)
    NOTA: ACBrECF nao possui comando para imprimir a 2a via do CCD }
  try
    case TipoRelatorio of
      trGerencial:
        FDataModule.ACBrECF.LinhaRelatorioGerencial(ImagemComprovante.Text);
      trVinculado:
        FDataModule.ACBrECF.LinhaCupomVinculado(ImagemComprovante.Text)
    end;

    RetornoECF := 1;
  except
    RetornoECF := 0;
  end;
end;

procedure TFEfetuaPagamento.ACBrTEFDComandaECFPagamento(IndiceECF: string; Valor: Double; var RetornoECF: Integer);
begin
  try
    FDataModule.ACBrECF.EfetuaPagamento(IndiceECF, Valor);
    RetornoECF := 1;
  except
    RetornoECF := 0;
  end;
end;

procedure TFEfetuaPagamento.ACBrTEFDExibeMsg(Operacao: TACBrTEFDOperacaoMensagem; Mensagem: string; var AModalResult: TModalResult);
var
  Fim: TDateTime;
  OldMensagem: String;
begin
  case Operacao of
    opmOK:
      AModalResult := Application.MessageBox(PChar(Mensagem), 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);

    opmYesNo:
      begin
        if not FDataModule.ACBrECF.Ativo then
        begin
          FDataModule.ACBrECF.Modelo := TACBrECFModelo(GetEnumValue(TypeInfo(TACBrECFModelo), Sessao.Configuracao.EcfImpressoraVO.ModeloAcbr));
          FDataModule.ACBrECF.Porta := Sessao.Configuracao.PortaECF;
          FDataModule.ACBrECF.TimeOut := Sessao.Configuracao.TimeOutECF;
          FDataModule.ACBrECF.IntervaloAposComando := Sessao.Configuracao.IntervaloECF;
          FDataModule.ACBrECF.Device.Baud := Sessao.Configuracao.BitsPorSegundo;
          try
            FDataModule.ACBrECF.Ativar;
          except
          end;
          FDataModule.ACBrECF.CarregaAliquotas;
          FDataModule.ACBrECF.CarregaFormasPagamento;
        end;
        AModalResult := Application.MessageBox(PChar(Mensagem), 'Pergunta do Sistema', Mb_YesNo + Mb_IconQuestion);
      end;

    opmExibirMsgOperador, opmRemoverMsgOperador:
      FCaixa.labelMensagens.Caption := Mensagem;

    opmExibirMsgCliente, opmRemoverMsgCliente:
      FCaixa.labelMensagens.Caption := Mensagem;

    opmDestaqueVia:
      begin
        OldMensagem := FCaixa.labelMensagens.Caption;
        try
          FCaixa.labelMensagens.Caption := Mensagem;

          { Aguardando 3 segundos }
          Fim := IncSecond(now, 3);
          repeat
            Sleep(200);
            FCaixa.labelMensagens.Caption := Mensagem + ' ' + IntToStr(SecondsBetween(Fim, now));
            Application.ProcessMessages;
          until (now > Fim);

        finally
          FCaixa.labelMensagens.Caption := OldMensagem;
        end;
      end;
  end;

  if (AModalResult = 7) and (Mensagem = 'Gostaria de continuar a transa��o com outra(s) forma(s) de pagamento ?') then
  begin
    SegundoCartaoCancelado := True;
  end;

  Application.ProcessMessages;
end;

procedure TFEfetuaPagamento.ACBrTEFDInfoECF(Operacao: TACBrTEFDInfoECF; var RetornoECF: string);
begin
  case Operacao of
    ineSubTotal:
      RetornoECF := FormatFloat('0.00', FDataModule.ACBrECF.Subtotal - FDataModule.ACBrECF.TotalPago);

    ineEstadoECF:
      begin
        Case FDataModule.ACBrECF.Estado of
          estLivre:
            RetornoECF := 'L';
          estVenda:
            RetornoECF := 'V';
          estPagamento:
            RetornoECF := 'P';
          estRelatorio:
            RetornoECF := 'R';
        else
          RetornoECF := 'O';
        end;
      end;
  end;
end;

procedure TFEfetuaPagamento.ACBrTEFDRestauraFocoAplicacao(var Tratado: Boolean);
begin
  Application.BringToFront;
  Tratado := False; { Deixa executar o c�digo de Foco do ACBrTEFD }
end;

function BlockInput(fBlockInput: Boolean): DWORD; stdcall; external 'user32.DLL';
{$EndRegion 'M�todos do Componente ACBrTEFD'}

end.
