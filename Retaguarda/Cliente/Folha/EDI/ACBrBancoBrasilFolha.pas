{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2009 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:   Juliana Rodrigues Prado                       }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}
(******************************************************************************}

  OBS:

  Esse arquivo foi copiado do componente ACBrBoleto para servir como base para a
  cria��o de um componente para a gera��o de remessas e leitura de retornos
  do item "3.1 - Pagamentos" do layout CNAB 240 da Febraban.

******************************************************************************)

unit ACBrBancoBrasilFolha;

interface

uses
  Classes, SysUtils, SessaoUsuario;

type
  { TACBrBancoBrasilFolha }

  TACBrBancoBrasilFolha = class
  protected
    class function Sessao: TSessaoUsuario;
  private
  public
    function SaveFileTXT(Arquivo: String): boolean; // M�todo que escreve o arquivo texto no caminho passado como par�metro

    function GerarRegistroHeader240: String;
    function GerarRegistroTransacao240: String;
    function GerarRegistroTrailler240: String;
    Procedure LerRetorno240(ARetorno: TStringList);
  end;

implementation

uses {$IFDEF COMPILER6_UP} DateUtils {$ELSE} FileCtrl {$ENDIF},
  StrUtils, Variants, ACBrUtil;

class function TACBrBancoBrasilFolha.Sessao: TSessaoUsuario;
begin
  Result := TSessaoUsuario.Instance;
end;

function TACBrBancoBrasilFolha.SaveFileTXT(Arquivo: String): boolean;
var
  txtFile: TextFile;
begin
  Result := True;

  if (Trim(Arquivo) = '') then
    raise Exception.Create('Caminho ou nome do arquivo n�o informado!');

  try
    AssignFile(txtFile, Arquivo);
    try
      Rewrite(txtFile);
      Write(txtFile, GerarRegistroHeader240);
      Write(txtFile, GerarRegistroTransacao240);
      Write(txtFile, GerarRegistroTrailler240);
    finally
      CloseFile(txtFile);
    end;

  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;
end;

function TACBrBancoBrasilFolha.GerarRegistroHeader240: String;
var
  ATipoInscricao, aConta: String;
  aAgencia, aModalidade: String;
begin
  (*
    ATipoInscricao
    pFisica  : ATipoInscricao := '1';
    pJuridica: ATipoInscricao := '2';
  *)

  ATipoInscricao := '2';

  { GERAR REGISTRO-HEADER DO ARQUIVO }

  Result:= IntToStrZero(1, 3)                              + // 1 a 3 - C�digo do banco
           '0000'                                          + // 4 a 7 - Lote de servi�o
           '0'                                             + // 8 - Tipo de registro - Registro header de arquivo
           StringOfChar(' ', 9)                            + // 9 a 17 Uso exclusivo FEBRABAN/CNAB
           ATipoInscricao                                  + // 18 - Tipo de inscri��o do cedente
           PadLeft(OnlyNumber(Sessao.Empresa.Cnpj), 14, '0')           + // 19 a 32 -N�mero de inscri��o do cedente
           PadLeft('456', 9, '0') + '0014'              + // 33 a 45 - C�digo do conv�nio no banco [ Alterado conforme instru��es da CSO Bras�lia ] 27-07-09
           'CARTEIRA' + // 46 a 47 - Carteira
           aModalidade + '  '                              + // 48 a 52 - Variacao Carteira
           aAgencia                                        + // 53 a 57 - C�digo da ag�ncia do cedente
           PadRight('2854', 1 , '0')                + // 58 - D�gito da ag�ncia do cedente
           aConta                                          + // 59 a 70 - N�mero da conta do cedente
           PadRight('456789', 1, '0')                   + // 71 - D�gito da conta do cedente
           ' '                                             + // 72 - D�gito verificador da ag�ncia / conta
           TiraAcentos(UpperCase(PadRight('Nome do cedente', 30, ' '))) + // 73 a 102 - Nome do cedente
           PadRight('BANCO DO BRASIL', 30, ' ')            + // 103 a 132 - Nome do banco
           StringOfChar(' ', 10)                           + // 133 a 142 - Uso exclusivo FEBRABAN/CNAB
           '1'                                             + // 143 - C�digo de Remessa (1) / Retorno (2)
           FormatDateTime('ddmmyyyy', Now)                 + // 144 a 151 - Data do de gera��o do arquivo
           FormatDateTime('hhmmss', Now)                   + // 152 a 157 - Hora de gera��o do arquivo
           PadLeft(IntToStr(1), 6, '0')        + // 158 a 163 - N�mero seq�encial do arquivo
           '030'                                           + // 164 a 166 - N�mero da vers�o do layout do arquivo
           StringOfChar('0', 5)                            + // 167 a 171 - Densidade de grava��o do arquivo (BPI)
           StringOfChar(' ', 20)                           + // 172 a 191 - Uso reservado do banco
           StringOfChar('0', 20)                           + // 192 a 211 - Uso reservado da empresa
           StringOfChar(' ', 11)                           + // 212 a 222 - 11 brancos
           'CSP'                                           + // 223 a 225 - 'CSP'
           StringOfChar('0', 3)                            + // 226 a 228 - Uso exclusivo de Vans
           StringOfChar(' ', 2)                            + // 229 a 230 - Tipo de servico
           StringOfChar(' ', 10);                            // 231 a 240 - titulo em carteira de cobranca

      { GERAR REGISTRO HEADER DO LOTE }

  Result:= Result + #13#10 +
           IntToStrZero(1, 3)               + // 1 a 3 - C�digo do banco
           '0001'                                          + // 4 a 7 - Lote de servi�o
           '1'                                             + // 8 - Tipo de registro - Registro header de arquivo
           'R'                                             + // 9 - Tipo de opera��o: R (Remessa) ou T (Retorno)
           '01'                                            + // 10 a 11 - Tipo de servi�o: 01 (Cobran�a)
           '00'                                            + // 12 a 13 - Forma de lan�amento: preencher com ZEROS no caso de cobran�a
           '020'                                           + // 14 a 16 - N�mero da vers�o do layout do lote
           ' '                                             + // 17 - Uso exclusivo FEBRABAN/CNAB
           ATipoInscricao                                  + // 18 - Tipo de inscri��o do cedente
           PadLeft(OnlyNumber(Sessao.Empresa.Cnpj), 15, '0')           + // 19 a 32 -N�mero de inscri��o do cedente
           PadLeft('0000', 9, '0') + '0014'              + // 33 a 45 - C�digo do conv�nio no banco [ Alterado conforme instru��es da CSO Bras�lia ] 27-07-09
           'CARTEIRA' + // 46 a 47 - Carteira
           aModalidade + '  '                              + // 48 a 52 - Variacao Carteira
           aAgencia                                        + // 53 a 57 - C�digo da ag�ncia do cedente
           PadRight('2854', 1 , '0')                + // 58 - D�gito da ag�ncia do cedente
           aConta                                          + // 59 a 70 - N�mero da conta do cedente
           PadRight('456789', 1, '0')                   + // 71 - D�gito da conta do cedente
           ' '                                             + // 72 - D�gito verificador da ag�ncia / conta
           PadRight('Nome do cedente', 30, ' ')                         + // 73 a 102 - Nome do cedente
           StringOfChar(' ', 40)                           + // 104 a 143 - Mensagem 1 para todos os boletos do lote
           StringOfChar(' ', 40)                           + // 144 a 183 - Mensagem 2 para todos os boletos do lote
           PadLeft(IntToStr(1), 8, '0')        + // 184 a 191 - N�mero do arquivo
           FormatDateTime('ddmmyyyy', Now)                 + // 192 a 199 - Data de gera��o do arquivo
           StringOfChar('0', 8)                            + // 200 a 207 - Data do cr�dito - S� para arquivo retorno
           StringOfChar(' ', 33);                            // 208 a 240 - Uso exclusivo FEBRABAN/CNAB
end;

function TACBrBancoBrasilFolha.GerarRegistroTransacao240: String;
begin
     {Registro Detalhe - Segmento A (Obrigat�rio - Remessa / Retorno)}

     {SEGMENTO P}
     Result:= IntToStrZero(1, 3)                                         + // 1 a 3 - C�digo do banco
              '0001'                                                                    + // 4 a 7 - Lote de servi�o
              '3'                                                                       + // 8 - Tipo do registro: Registro detalhe
              IntToStrZero(1 , 5) + // 9 a 13 - N�mero seq�encial do registro no lote - Cada t�tulo tem 2 registros (P e Q)
              'A'                                                                       + // 14 - C�digo do segmento do registro detalhe
              ' '                                                                       + // 15 - Uso exclusivo FEBRABAN/CNAB: Branco
              'ATipoOcorrencia'                                                           + // 16 a 17 - C�digo de movimento
              'aAgencia'                                                                  + // 18 a 22 - Ag�ncia mantenedora da conta
              PadRight('5555', 1 , '0')                       + // 23 -D�gito verificador da ag�ncia
              '45699'                                                                    + // 24 a 35 - N�mero da conta corrente
              PadRight('8899', 1, '0')                          + // 36 - D�gito verificador da conta
              ' '                                                                       + // 37 - D�gito verificador da ag�ncia / conta
              PadRight('8', 20, ' ')                                       + // 38 a 57 - Nosso n�mero - identifica��o do t�tulo no banco
              'wTipoCarteira'                                                            + // 58 - Cobran�a Simples
              '1'                                                                       + // 59 - Forma de cadastramento do t�tulo no banco: com cadastramento
              InttoStr(Integer(5))                       + // 60 - Tipo de documento: Tradicional
              'ATipoBoleto'                                                               + // 61 a 62 - Quem emite e quem distribui o boleto?
              PadRight('7', 15, ' ')                                        + // 63 a 77 - N�mero que identifica o t�tulo na empresa [ Alterado conforme instru��es da CSO Bras�lia ] {27-07-09}
              FormatDateTime('ddmmyyyy', now)                                    + // 78 a 85 - Data de vencimento do t�tulo
              IntToStrZero( round( 123 * 100), 15)                           + // 86 a 100 - Valor nominal do t�tulo
              '00000 '                                                                  + // 101 a 106 - Ag�ncia cobradora + Digito. Se ficar em branco, a caixa determina automaticamente pelo CEP do sacado
              PadRight('1',2)                                                    + // 107 a 108 - Esp�cie do documento
              'ATipoAceite'                                                               + // 109 - Identifica��o de t�tulo Aceito / N�o aceito
              FormatDateTime('ddmmyyyy', now)                                 + // 110 a 117 - Data da emiss�o do documento
              IfThen(546 > 0, '1', '3')                                      + // 118 - C�digo de juros de mora: Valor por dia
              '2016-01-01'                                                            + // 119 a 126 - Data a partir da qual ser�o cobrados juros
              IfThen(88 > 0,
                     IntToStrZero(round(99 * 100), 15),
                     PadRight('', 15, '0'))                                             + // 127 a 141 - Valor de juros de mora por dia
              IfThen(1 > 0, IfThen(now > 0, '1','3'), '0')         + // 142 - C�digo de desconto: 1 - Valor fixo at� a data informada 4-Desconto por dia de antecipacao 0 - Sem desconto
              '2016-01-01'   + // 143 a 150 - Data do desconto
              IfThen(1 > 0, IntToStrZero( round(1 * 100), 15),
                     PadRight('', 15, '0'))                                             + // 151 a 165 - Valor do desconto por dia
              IntToStrZero( round(1 * 100), 15)                                  + // 166 a 180 - Valor do IOF a ser recolhido
              IntToStrZero( round(1 * 100), 15)                           + // 181 a 195 - Valor do abatimento
              PadRight('1', 25, ' ')                                              + // 196 a 220 - Identifica��o do t�tulo na empresa
              '1'    + // 221 - C�digo de protesto: Protestar em XX dias corridos
              '00'                                                              + // 222 a 223 - Prazo para protesto (em dias corridos)
              '0'                                                                       + // 224 - Campo n�o tratado pelo BB [ Alterado conforme instru��es da CSO Bras�lia ] {27-07-09}
              '000'                                                                     + // 225 a 227 - Campo n�o tratado pelo BB [ Alterado conforme instru��es da CSO Bras�lia ] {27-07-09}
              '09'                                                                      + // 228 a 229 - C�digo da moeda: Real
              StringOfChar('0', 10)                                                     + // 230 a 239 - Uso exclusivo FEBRABAN/CNAB
              ' ';                                                                        // 240 - Uso exclusivo FEBRABAN/CNAB

     {Registro Detalhe - Segmento B (Obrigat�rio - Remessa / Retorno)}
     Result:= Result + #13#10 +
              IntToStrZero(1, 3)                                        + // C�digo do banco
              '0001'                                                                   + // N�mero do lote
              '3'                                                                      + // Tipo do registro: Registro detalhe
              IntToStrZero(2 ,5) + // N�mero seq�encial do registro no lote - Cada t�tulo tem 2 registros (P e Q)
              'B'                                                                      + // C�digo do segmento do registro detalhe
              ' '                                                                      + // Uso exclusivo FEBRABAN/CNAB: Branco
              'ATipoOcorrencia'                                                          + // Tipo Ocorrencia
              '1'                                + // Tipo inscricao
              PadLeft(OnlyNumber(Sessao.Empresa.Cnpj), 15, '0')                             +
              PadRight('Sacado.NomeSacado', 40, ' ')                                     +
              PadRight('Sacado.Logradouro' + ' ' + 'Sacado.Numero' + ' '+
                       'Sacado.Complemento' , 40, ' ')                                   +
              PadRight('Sacado.Bairro', 15, ' ')                                         +
              PadLeft('OnlyNumber(Sacado.CEP)', 8, '0')                                  +
              PadRight('Sacado.Cidade', 15, ' ')                                         +
              PadRight('Sacado.UF', 2, ' ')                                              +
              IfThen('Sacado.SacadoAvalista.Pessoa' = 'pJuridica','2',
                     IfThen('Sacado.SacadoAvalista.CNPJCPF' <> '','1', '0'))             + // Tipo de inscri��o: N�o informado
              PadRight(OnlyNumber(Sessao.Empresa.Cnpj), 15, '0')             + // N�mero de inscri��o
              PadRight('Sacado.SacadoAvalista.NomeAvalista', 40, ' ')                    + // Nome do sacador/avalista
              PadRight('', 3, '0')                                                     + // Uso exclusivo FEBRABAN/CNAB
              PadRight('',20, ' ')                                                     + // Uso exclusivo FEBRABAN/CNAB
              PadRight('', 8, ' ');                                                      // Uso exclusivo FEBRABAN/CNAB
end;

function TACBrBancoBrasilFolha.GerarRegistroTrailler240: String;
begin
   {REGISTRO TRAILER DO LOTE}
   Result:= IntToStrZero(1, 3)                          + //C�digo do banco
            '0001'                                                     + //N�mero do lote
            '5'                                                        + //Tipo do registro: Registro trailer do lote
            Space(9)                                                   + //Uso exclusivo FEBRABAN/CNAB
            //IntToStrZero(ARemessa.Count-1, 6)                        + //Quantidade de Registro da Remessa
            IntToStrZero((3 * 1), 6)                    + //Quantidade de Registro da Remessa
            PadRight('', 6, '0')                                           + //Quantidade t�tulos em cobran�a
            PadRight('',17, '0')                                           + //Valor dos t�tulos em carteiras}
            PadRight('', 6, '0')                                           + //Quantidade t�tulos em cobran�a
            PadRight('',17, '0')                                           + //Valor dos t�tulos em carteiras}
            PadRight('', 6, '0')                                           + //Quantidade t�tulos em cobran�a
            PadRight('',17, '0')                                           + //Valor dos t�tulos em carteiras}
            PadRight('', 6, '0')                                           + //Quantidade t�tulos em cobran�a
            PadRight('',17, '0')                                           + //Valor dos t�tulos em carteiras}
            Space(8)                                                   + //Uso exclusivo FEBRABAN/CNAB}
            PadRight('',117,' ')                                           ;

   {GERAR REGISTRO TRAILER DO ARQUIVO}
   Result:= Result + #13#10 +
            IntToStrZero(1, 3)                          + //C�digo do banco
            '9999'                                                     + //Lote de servi�o
            '9'                                                        + //Tipo do registro: Registro trailer do arquivo
            space(9)                                                   + //Uso exclusivo FEBRABAN/CNAB}
            '000001'                                                   + //Quantidade de lotes do arquivo}
            IntToStrZero(((1-1)* 3)+4, 6)                 + //Quantidade de registros do arquivo, inclusive este registro que est� sendo criado agora}
            space(6)                                                   + //Uso exclusivo FEBRABAN/CNAB}
            space(205);                                                  //Uso exclusivo FEBRABAN/CNAB}
end;

procedure TACBrBancoBrasilFolha.LerRetorno240(ARetorno: TStringList);
var
  TempData, Linha, rCedente, rCNPJCPF: String;
  ContLinha : Integer;
  idxMotivo: Integer;
  rConvenioCedente: String;
begin

  /// EXERCICIO: Fa�a as devidas adapta��es para ler o retorno

  (*

   ACBrBanco.ACBrBoleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0],144,2)+'/'+
                                                           Copy(ARetorno[0],146,2)+'/'+
                                                           Copy(ARetorno[0],148,4),0, 'DD/MM/YYYY' );

   ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0],158,6),0);

   rCedente        := trim(copy(ARetorno[0], 73, 30));
   rCNPJCPF        := OnlyNumber( copy(ARetorno[0], 19, 14) );
   rConvenioCedente:= Trim(Copy(ARetorno[0], 33, 9));

   with ACBrBanco.ACBrBoleto do
   begin
      if (not LeCedenteRetorno) and (rCNPJCPF <> OnlyNumber(Cedente.CNPJCPF)) then
         raise Exception.create(ACBrStr('CNPJ\CPF do arquivo inv�lido'));

      if LeCedenteRetorno then
      begin
        Cedente.Nome          := rCedente;
        Cedente.CNPJCPF       := rCNPJCPF;
        Cedente.Convenio      := rConvenioCedente;
        Cedente.Agencia       := trim(copy(ARetorno[0], 53, 5));
        Cedente.AgenciaDigito := trim(copy(ARetorno[0], 58, 1));
        Cedente.Conta         := trim(copy(ARetorno[0], 59, 12));
        Cedente.ContaDigito   := trim(copy(ARetorno[0], 71, 1));
      end;

      case StrToIntDef(copy(ARetorno[0], 18, 1), 0) of
        01:
          Cedente.TipoInscricao := pFisica;
        else
          Cedente.TipoInscricao := pJuridica;
      end;

      ACBrBanco.ACBrBoleto.ListadeBoletos.Clear;
   end;

   ACBrBanco.TamanhoMaximoNossoNum := 20;

   for ContLinha := 1 to ARetorno.Count - 2 do
   begin
      Linha := ARetorno[ContLinha];

      if copy(Linha, 8, 1) <> '3' then // verifica se o registro (linha) � um registro detalhe (segmento J)
         Continue;

      if copy(Linha, 14, 1) = 'T' then // se for segmento T cria um novo titulo
         Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

      with Titulo do
      begin
         if copy(Linha, 14, 1) = 'T' then
          begin
            SeuNumero := copy(Linha, 106, 25);
            NumeroDocumento := copy(Linha, 59, 15);
            Carteira := copy(Linha, 58, 1);

            TempData := copy(Linha, 74, 2) + '/'+copy(Linha, 76, 2)+'/'+copy(Linha, 78, 4);
            if TempData<>'00/00/0000' then
               Vencimento := StringToDateTimeDef(TempData, 0, 'DDMMYY');

            ValorDocumento := StrToFloatDef(copy(Linha, 82, 15), 0) / 100;

            if Length(ACBrBoleto.Cedente.Convenio) = 6 then
              NossoNumero := copy(Linha, 44, 10)
            else
              NossoNumero := copy(Linha, 45, 10);
            ValorDespesaCobranca := StrToFloatDef(copy(Linha, 199, 15), 0) / 100;

            OcorrenciaOriginal.Tipo := CodOcorrenciaToTipo(StrToIntDef(copy(Linha, 16, 2), 0));

            IdxMotivo := 214;

            while (IdxMotivo < 223) do
            begin
               if (trim(Copy(Linha, IdxMotivo, 2)) <> '') then
               begin
                  MotivoRejeicaoComando.Add(Copy(Linha, IdxMotivo, 2));
                  DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo, StrToIntDef(Copy(Linha, IdxMotivo, 2), 0)));
               end;
               Inc(IdxMotivo, 2);
            end;

            // quando o numero documento vier em branco
            if Trim(NumeroDocumento) = '' then
              NumeroDocumento := NossoNumero;
          end
         else // segmento U
          begin
            ValorIOF := StrToFloatDef(copy(Linha, 63, 15), 0) / 100;
            ValorAbatimento := StrToFloatDef(copy(Linha, 48, 15), 0) / 100;
            ValorDesconto := StrToFloatDef(copy(Linha, 33, 15), 0) / 100;
            ValorMoraJuros := StrToFloatDef(copy(Linha, 18, 15), 0) / 100;
            ValorOutrosCreditos := StrToFloatDef(copy(Linha, 123, 15), 0) / 100;
            ValorOutrasDespesas := StrToFloatDef(copy(Linha, 108, 15), 0) / 100;
            ValorRecebido := StrToFloatDef(copy(Linha, 78, 15), 0) / 100;
            TempData := copy(Linha, 138, 2)+'/'+copy(Linha, 140, 2)+'/'+copy(Linha, 142, 4);
            if TempData<>'00/00/0000' then
                DataOcorrencia := StringToDateTimeDef(TempData, 0, 'DDMMYY');
            TempData := copy(Linha, 146, 2)+'/'+copy(Linha, 148, 2)+'/'+copy(Linha, 150, 4);
            if TempData<>'00/00/0000' then
                DataCredito := StringToDateTimeDef(TempData, 0, 'DDMMYYYY');
          end;
      end;
   end;

   ACBrBanco.TamanhoMaximoNossoNum := 10;
   *)
end;

end.
