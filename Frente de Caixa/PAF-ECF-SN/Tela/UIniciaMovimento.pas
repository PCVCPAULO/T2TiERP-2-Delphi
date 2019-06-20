{ *******************************************************************************
Title: T2TiPDV
Description: Janela utilizada para iniciar um novo movimento.

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
unit UIniciaMovimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, UBase,
  Dialogs, Grids, DBGrids, JvExDBGrids, JvDBGrid, StdCtrls, JvExStdCtrls,
  JvButton, JvCtrls, Buttons, JvExButtons, JvBitBtn, pngimage, ExtCtrls,
  JvEdit, JvValidateEdit, DB, FMTBcd, Provider, DBClient, SqlExpr,
  JvEnterTab, JvComponentBase, Tipos, JvDBUltimGrid, Biblioteca, Controller,
  Vcl.Mask, JvExMask, JvToolEdit, JvBaseEdits, DateUtils;

type
  TFIniciaMovimento = class(TFBase)
    Image1: TImage;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    GroupBox3: TGroupBox;
    JvEnterAsTab1: TJvEnterAsTab;
    GroupBox1: TGroupBox;
    editLoginGerente: TLabeledEdit;
    editSenhaGerente: TLabeledEdit;
    botaoConfirma: TJvBitBtn;
    botaoCancela: TJvImgBtn;
    GroupBox4: TGroupBox;
    editLoginOperador: TLabeledEdit;
    editSenhaOperador: TLabeledEdit;
    DSTurno: TDataSource;
    CDSTurno: TClientDataSet;
    GridTurno: TJvDBUltimGrid;
    EditValorSuprimento: TJvCalcEdit;
    procedure Confirma;
    procedure FormActivate(Sender: TObject);
    procedure GridTurnoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure botaoConfirmaClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImprimeAbertura;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FIniciaMovimento: TFIniciaMovimento;

implementation

uses
  UDataModule,
  EcfOperadorVO, EcfMovimentoVO, EcfTurnoVO, EcfSuprimentoVO,
  EcfTurnoController, PAFUtil, ECFUtil;

{$R *.dfm}

{$REGION 'Infra'}
procedure TFIniciaMovimento.FormActivate(Sender: TObject);
begin
  Color := StringToColor(Sessao.Configuracao.CorJanelasInternas);

  // Configura a Grid do Turno
  ConfiguraCDSFromVO(CDSTurno, TEcfTurnoVO);
  ConfiguraGridFromVO(GridTurno, TEcfTurnoVO);

  // Consulta os turnos
  TEcfTurnoController.SetDataSet(CDSTurno);
  TController.ExecutarMetodo('EcfTurnoController.TEcfTurnoController', 'Consulta', ['ID>0', '0', False], 'GET', 'Lista');

  GridTurno.SelectedIndex := 1;
  GridTurno.SetFocus;
end;

procedure TFIniciaMovimento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

procedure TFIniciaMovimento.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F12 then
    Confirma;
end;

procedure TFIniciaMovimento.GridTurnoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    editValorSuprimento.SetFocus;
end;
{$ENDREGION 'Infra'}

{$Region 'Confirma��o e In�cio do Movimento'}
procedure TFIniciaMovimento.botaoConfirmaClick(Sender: TObject);
begin
  Confirma;
end;

procedure TFIniciaMovimento.Confirma;
var
  Gerente: TEcfOperadorVO;
  Suprimento: TEcfSuprimentoVO;
begin
  try
    try
      // verifica se senha e o n�vel do operador est�o corretos
      Sessao.AutenticaUsuario(editLoginOperador.Text, editSenhaOperador.Text);
      if Assigned(Sessao.Usuario) then
      begin
        // verifica se senha do gerente esta correta
        Gerente := TEcfOperadorVO(TController.BuscarObjeto('EcfFuncionarioController.TEcfFuncionarioController', 'Usuario', [editLoginGerente.Text, editSenhaGerente.Text], 'GET'));
        if Assigned(Gerente) then
        begin
          // verifica nivel de acesso do gerente/supervisor
          if (Gerente.EcfFuncionarioVO.NivelAutorizacao = 'G') or (Gerente.EcfFuncionarioVO.NivelAutorizacao = 'S') then
          begin
            if TECFUtil.ImpressoraOK(2) then
            begin
              // insere movimento
              Sessao.Movimento := TEcfMovimentoVO.Create;

              Sessao.Movimento.IdEcfTurno := CDSTurno.FieldByName('ID').AsInteger;
              Sessao.Movimento.IdEcfImpressora := Sessao.Configuracao.IdEcfImpressora;
              Sessao.Movimento.idEcfEmpresa := Sessao.Configuracao.idEcfEmpresa;
              Sessao.Movimento.IdECfOperador := Sessao.Usuario.Id;
              Sessao.Movimento.IdECfCaixa := Sessao.Configuracao.IdECfCaixa;
              Sessao.Movimento.IdGerenteSupervisor := Gerente.Id;
              Sessao.Movimento.DataAbertura := EncodeDate(YearOf(FDataModule.ACBrECF.DataHora), MonthOf(FDataModule.ACBrECF.DataHora), DayOf(FDataModule.ACBrECF.DataHora));
              Sessao.Movimento.HoraAbertura := FormatDateTime('hh:nn:ss', FDataModule.ACBrECF.DataHora);
              Sessao.Movimento.TotalSuprimento := editValorSuprimento.Value;
              Sessao.Movimento.StatusMovimento := 'A';

              TController.ExecutarMetodo('EcfMovimentoController.TEcfMovimentoController', 'IniciaMovimento', [Sessao.Movimento], 'PUT', 'Objeto');
              Sessao.Movimento := TEcfMovimentoVO(TController.ObjetoConsultado);
            end
            else
            begin
              Application.MessageBox('N�o foi poss�vel abrir o movimento!.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
              Sessao.StatusCaixa := scSomenteConsulta;
              Close;
            end; // if UECF.ImpressoraOK(2) then

            // insere suprimento
            if editValorSuprimento.Value > 0 then
            begin
              try
                TECFUtil.Suprimento(editValorSuprimento.Value, Sessao.Configuracao.DescricaoSuprimento);

                Suprimento := TEcfSuprimentoVO.Create;
                Suprimento.IdEcfMovimento := Sessao.Movimento.Id;
                Suprimento.DataSuprimento := EncodeDate(YearOf(FDataModule.ACBrECF.DataHora), MonthOf(FDataModule.ACBrECF.DataHora), DayOf(FDataModule.ACBrECF.DataHora));
                Suprimento.Valor := editValorSuprimento.Value;
                TController.ExecutarMetodo('EcfSuprimentoController.TEcfSuprimentoController', 'Insere', [Suprimento], 'PUT', 'Lista');
                Sessao.Movimento.TotalSuprimento := Sessao.Movimento.TotalSuprimento + Suprimento.Valor;
                TController.ExecutarMetodo('EcfMovimentoController.TEcfMovimentoController', 'Altera', [Sessao.Movimento], 'POST', 'Boolean');
              finally
                FreeAndNil(Suprimento);
              end;
            end; // if StrToFloat(editValorSuprimento.Text) <> 0 then

            if Assigned(Sessao.Movimento) then
            begin
              Application.MessageBox('Movimento aberto com sucesso.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
              Sessao.StatusCaixa := scAberto;
              ImprimeAbertura;
            end;
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
    FreeAndNil(Gerente);
  end;
end;
{$EndRegion 'Confirma��o e In�cio do Movimento'}

{$Region 'Impress�o da Abertura'}
procedure TFIniciaMovimento.ImprimeAbertura;
begin
  FDataModule.ACBrECF.AbreRelatorioGerencial(Sessao.Configuracao.EcfRelatorioGerencialVO.X);
  FDataModule.ACBrECF.LinhaRelatorioGerencial(StringOfChar('=', 48));
  FDataModule.ACBrECF.LinhaRelatorioGerencial(' ABERTURA DE CAIXA ');
  FDataModule.ACBrECF.PulaLinhas(1);
  FDataModule.ACBrECF.LinhaRelatorioGerencial('DATA DE ABERTURA  : ' + FormatDateTime('dd/mm/yyyy', Sessao.Movimento.DataAbertura));
  FDataModule.ACBrECF.LinhaRelatorioGerencial('HORA DE ABERTURA  : ' + Sessao.Movimento.HoraAbertura);
  FDataModule.ACBrECF.LinhaRelatorioGerencial(Sessao.Movimento.EcfCaixaVO.Nome + '  OPERADOR: ' + Sessao.Movimento.EcfOperadorVO.Login);
  FDataModule.ACBrECF.LinhaRelatorioGerencial('MOVIMENTO: ' + IntToStr(Sessao.Movimento.Id));
  FDataModule.ACBrECF.LinhaRelatorioGerencial(StringOfChar('=', 48));
  FDataModule.ACBrECF.PulaLinhas(1);
  FDataModule.ACBrECF.LinhaRelatorioGerencial('SUPRIMENTO...: ' + formatfloat('##,###,##0.00', EditValorSuprimento.Value));
  FDataModule.ACBrECF.PulaLinhas(3);
  FDataModule.ACBrECF.LinhaRelatorioGerencial(' ________________________________________ ');
  FDataModule.ACBrECF.LinhaRelatorioGerencial(' VISTO DO CAIXA ');
  FDataModule.ACBrECF.PulaLinhas(3);
  FDataModule.ACBrECF.LinhaRelatorioGerencial(' ________________________________________ ');
  FDataModule.ACBrECF.LinhaRelatorioGerencial(' VISTO DO SUPERVISOR ');

  FDataModule.ACBrECF.FechaRelatorio;
  TPAFUtil.GravarR06('RG');
end;
{$EndRegion 'Impress�o da Abertura'}

end.
