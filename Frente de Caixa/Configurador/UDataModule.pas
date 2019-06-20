{*******************************************************************************
Title: T2Ti ERP
Description: Datamodule.

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
           t2ti.com@gmail.com</p>

@author Albert Eije (T2Ti.COM)
@version 1.0
*******************************************************************************}
unit UDataModule;

interface

uses
SysUtils, ACBrTEFDClass, Forms, ACBrDevice, ACBrBase, ACBrECF, DBXMySql, FMTBcd,
Provider, DBClient, DB, SqlExpr, Classes, WideStrings, StdCtrls, Controls,
Windows, ACBrUtil, dateutils, strutils, ACBrPAF, ACBrPAF_D, ACBrPAF_E, ACBrPAF_P,
ACBrPAF_R, ACBrPAF_T, ACBrPAFRegistros, ACBrSpedFiscal, ACBrSintegra, Dialogs,
Inifiles, DBXFirebird,DBXMsSQL, ACBrFala, ACBrECFClass, ImgList, JvImageList, jpeg;

type
  TFDataModule = class(TDataModule)
    Conexao: TSQLConnection;
    ACBrECF: TACBrECF;
    ImagemPadrao: TImageList;
    OpenDialog: TOpenDialog;
    ImagensCadastros: TImageList;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RemoteAppPath:string;
  end;

var
  FDataModule: TFDataModule;

implementation

uses UConfigConexao, Biblioteca, USplash;

{$R *.dfm}

procedure TFDataModule.DataModuleCreate(Sender: TObject);
var
	ArquivoIni: TIniFile;
  Banco, Arquivo: String;
  Parametros: TStrings;
begin
  FSplash.lbMensagem.caption := 'Conectando a Base de Dados...';
  FSplash.lbMensagem.Refresh;

  Conexao.Connected := False;

  try
    ArquivoIni := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Conexao.ini');
    Banco := UpperCase(ArquivoIni.ReadString('SGBD','BD',''));
    RemoteAppPath:= UpperCase(ArquivoIni.ReadString('IMPORTA','REMOTEAPP',''));
  finally
    ArquivoIni.Free;
  end;

  if Banco = 'MYSQL' then
  begin
    Arquivo := CaminhoApp + 'MySQL_DBExpress_conn.txt';
    Conexao.DriverName     := 'MySQL';
    Conexao.ConnectionName := 'MySQLConnection';
    Conexao.GetDriverFunc  := 'getSQLDriverMYSQL';
    Conexao.LibraryName    := 'dbxmys.dll';
    Conexao.VendorLib      := 'libmysql.dll';
  end
  else if Banco = 'FIREBIRD' then
  begin
    Arquivo := CaminhoApp + 'Firebird_DBExpress_conn.txt';
    Conexao.DriverName     := 'Firebird';
    Conexao.ConnectionName := 'FBConnection';
    Conexao.GetDriverFunc  := 'getSQLDriverINTERBASE';
    Conexao.LibraryName    := 'dbxfb.dll';
    Conexao.VendorLib      := 'fbclient.dll';
  end;

  Parametros := TStringList.Create;
  Parametros.LoadFromFile(Arquivo);
  Conexao.Params := Parametros;

  try
    FSplash.Repaint;
    Conexao.Connected := True;
    FSplash.lbMensagem.Caption := 'Conectando a Base de Dados local...';
    FSplash.lbMensagem.Refresh;
    FSplash.imgBanco.Visible := True;

  except
    Application.MessageBox('Falha ao tentar conectar a Base de Dados.', 'Informa��o do Sistema', Mb_OK + MB_ICONERROR);
    FSplash.lbMensagem.Caption := 'Falha ao tentar conectar a Base de Dados';
    FSplash.lbMensagem.Refresh;

    Application.CreateForm(TFConfigConexao, FConfigConexao);
    if FConfigConexao.ShowModal <> mrOK then
    begin
      ACBrECF.Desativar;
      Application.ProcessMessages;
      Application.Terminate;
    end  else
    begin
      FSplash.imgBanco.visible := true;
    end;
  end;
end;

end.
