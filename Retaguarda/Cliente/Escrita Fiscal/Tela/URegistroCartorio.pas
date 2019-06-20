{ *******************************************************************************
Title: T2Ti ERP
Description: Janela Registro Cart�rio para o m�dulo Escrita Fiscal

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

@author Albert Eije (t2ti.com@gmail.com)
@version 2.0
******************************************************************************* }
unit URegistroCartorio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, DB, DBClient, Menus, StdCtrls, ExtCtrls, Buttons, Grids,
  DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, RegistroCartorioVO,
  RegistroCartorioController, Tipos, Atributos, Constantes, LabeledCtrls, Mask,
  JvExMask, JvToolEdit, JvBaseEdits, StrUtils, Controller;

type
  [TFormDescription(TConstantes.MODULO_ESCRITA_FISCAL, 'Registro Cart�rio')]

  TFRegistroCartorio = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditNomeCartorio: TLabeledEdit;
    EditDataRegistro: TLabeledDateEdit;
    EditNumero: TLabeledCalcEdit;
    EditFolha: TLabeledCalcEdit;
    EditLivro: TLabeledCalcEdit;
    EditNire: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FRegistroCartorio: TFRegistroCartorio;

implementation

{$R *.dfm}

{$REGION 'Controles Infra'}
procedure TFRegistroCartorio.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TRegistroCartorioVO;
  ObjetoController := TRegistroCartorioController.Create;

  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFRegistroCartorio.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditNomeCartorio.SetFocus;
  end;
end;

function TFRegistroCartorio.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditNomeCartorio.SetFocus;
  end;
end;

function TFRegistroCartorio.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      TController.ExecutarMetodo('RegistroCartorioController.TRegistroCartorioController', 'Exclui', [IdRegistroSelecionado], 'DELETE', 'Boolean');
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
    TController.ExecutarMetodo('RegistroCartorioController.TRegistroCartorioController', 'Consulta', [Trim(Filtro), Pagina.ToString, False], 'GET', 'Lista');
end;

function TFRegistroCartorio.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TRegistroCartorioVO.Create;

      TRegistroCartorioVO(ObjetoVO).IdEmpresa := Sessao.Empresa.Id;
      TRegistroCartorioVO(ObjetoVO).NomeCartorio := EditNomeCartorio.Text;
      TRegistroCartorioVO(ObjetoVO).DataRegistro := EditDataRegistro.Date;
      TRegistroCartorioVO(ObjetoVO).Numero := EditNumero.AsInteger;
      TRegistroCartorioVO(ObjetoVO).Folha := EditFolha.AsInteger;
      TRegistroCartorioVO(ObjetoVO).Livro := EditLivro.AsInteger;
      TRegistroCartorioVO(ObjetoVO).Nire := EditNire.Text;

      if StatusTela = stInserindo then
      begin
        TController.ExecutarMetodo('RegistroCartorioController.TRegistroCartorioController', 'Insere', [TRegistroCartorioVO(ObjetoVO)], 'PUT', 'Lista');
      end
      else if StatusTela = stEditando then
        if TRegistroCartorioVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        begin
          TController.ExecutarMetodo('RegistroCartorioController.TRegistroCartorioController', 'Altera', [TRegistroCartorioVO(ObjetoVO)], 'POST', 'Boolean');
        end
        else
          Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
    except
      Result := False;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFRegistroCartorio.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := TRegistroCartorioVO(TController.BuscarObjeto('RegistroCartorioController.TRegistroCartorioController', 'ConsultaObjeto', ['ID=' + IdRegistroSelecionado.ToString], 'GET'));
  end;

  if Assigned(ObjetoVO) then
  begin
    EditNomeCartorio.Text := TRegistroCartorioVO(ObjetoVO).NomeCartorio;
    EditDataRegistro.Date := TRegistroCartorioVO(ObjetoVO).DataRegistro;
    EditNumero.AsInteger := TRegistroCartorioVO(ObjetoVO).Numero;
    EditFolha.AsInteger := TRegistroCartorioVO(ObjetoVO).Folha;
    EditLivro.AsInteger := TRegistroCartorioVO(ObjetoVO).Livro;
    EditNire.Text := TRegistroCartorioVO(ObjetoVO).Nire;

    // Serializa o objeto para consultar posteriormente se houve altera��es
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;
{$ENDREGION}

end.
