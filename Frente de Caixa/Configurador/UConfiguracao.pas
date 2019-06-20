unit UConfiguracao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, JvExDBGrids, JvDBGrid, FMTBcd, Provider, DBClient,
  DB, SqlExpr, StdCtrls, Mask, DBCtrls, Buttons, pngimage, ExtCtrls,
  JvExStdCtrls, JvButton, JvCtrls, JvExButtons, JvBitBtn, ComCtrls, JvCombobox,
  JvColorCombo, JvExExtCtrls, JvExtComponent, JvPanel, JvOfficeColorPanel,
  JvExControls, JvColorBox, JvColorButton, JvBaseDlg, JvBrowseFolder, ACBrECF,
  JvExMask, JvToolEdit, JvBaseEdits, TypInfo, jpeg, IniFiles, EcfConfiguracaoVO,
  JvSpin, ACBrNFe, FileCtrl, GIFImg, Biblioteca, MidasLib;

type
  TFConfiguracao = class(TForm)
    QConfiguracao: TSQLQuery;
    DSConfiguracao: TDataSource;
    CDSConfiguracao: TClientDataSet;
    DSPConfiguracao: TDataSetProvider;
    QPosicaoComponentes: TSQLQuery;
    DSPosicaoComponentes: TDataSource;
    CDSPosicaoComponentes: TClientDataSet;
    DSPPosicaoComponentes: TDataSetProvider;
    QImpressora: TSQLQuery;
    DSImpressora: TDataSource;
    DSPImpressora: TDataSetProvider;
    CDSImpressora: TClientDataSet;
    botaoConfirma: TJvBitBtn;
    botaoSair: TJvImgBtn;
    Image1: TImage;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ScrollBox1: TScrollBox;
    DBLookupComboBox1: TDBLookupComboBox;
    Label1: TLabel;
    Label2: TLabel;
    DBLookupComboBox2: TDBLookupComboBox;
    QCaixa: TSQLQuery;
    DSCaixa: TDataSource;
    DSPCaixa: TDataSetProvider;
    CDSCaixa: TClientDataSet;
    DBLookupComboBox4: TDBLookupComboBox;
    Label4: TLabel;
    QEmpresa: TSQLQuery;
    DSEmpresa: TDataSource;
    DSPEmpresa: TDataSetProvider;
    CDSEmpresa: TClientDataSet;
    TabSheet2: TTabSheet;
    GridPosicaoComponentes: TJvDBGrid;
    Label3: TLabel;
    DBLookupComboBox3: TDBLookupComboBox;
    Label5: TLabel;
    DBEdit1: TDBEdit;
    Label6: TLabel;
    DBEdit2: TDBEdit;
    Label7: TLabel;
    DBEdit3: TDBEdit;
    Label8: TLabel;
    DBEdit4: TDBEdit;
    Label9: TLabel;
    DBEdit5: TDBEdit;
    Label10: TLabel;
    PaletaCores: TJvOfficeColorPanel;
    Label11: TLabel;
    DBEdit6: TDBEdit;
    Label12: TLabel;
    DBEdit7: TDBEdit;
    Label13: TLabel;
    DBEdit8: TDBEdit;
    Folder: TJvBrowseForFolderDialog;
    BotaoCaminhoImagemProduto: TSpeedButton;
    BotaoCaminhoImagemMarketing: TSpeedButton;
    BotaoCaminhoImagemLayout: TSpeedButton;
    Label14: TLabel;
    DBEdit9: TDBEdit;
    Label15: TLabel;
    DBEdit10: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    QCFOP: TSQLQuery;
    DSCFOP: TDataSource;
    DSPCFOP: TDataSetProvider;
    CDSCFOP: TClientDataSet;
    DBLookupComboBox5: TDBLookupComboBox;
    Label17: TLabel;
    DBLookupComboBox6: TDBLookupComboBox;
    Label18: TLabel;
    Label19: TLabel;
    DBEdit11: TDBEdit;
    Label21: TLabel;
    DBEdit13: TDBEdit;
    Label22: TLabel;
    DBEdit14: TDBEdit;
    Label27: TLabel;
    DBEdit19: TDBEdit;
    PanelScroll: TPanel;
    GroupBox1: TGroupBox;
    Label24: TLabel;
    DBEdit16: TDBEdit;
    Label25: TLabel;
    DBEdit17: TDBEdit;
    Label26: TLabel;
    DBEdit18: TDBEdit;
    Label23: TLabel;
    DBEdit15: TDBEdit;
    DBComboBox1: TDBComboBox;
    Label16: TLabel;
    Label20: TLabel;
    DBEdit12: TDBEdit;
    botaoConexoes: TJvBitBtn;
    botaoReconectaImpressora: TJvBitBtn;
    Label61: TLabel;
    SinalVerde: TImage;
    SinalVermelho: TImage;
    DBEdit21: TDBEdit;
    Label62: TLabel;
    TabSheet6: TTabSheet;
    botaoDesconectaImpressora: TJvBitBtn;
    Bevel1: TBevel;
    PageControl2: TPageControl;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    TabSheet10: TTabSheet;
    GroupBox6: TGroupBox;
    Label65: TLabel;
    Label66: TLabel;
    SerieECF: TEdit;
    GTECF: TEdit;
    GroupBox21: TGroupBox;
    Label101: TLabel;
    cmbXXXVI1: TComboBox;
    GroupBox18: TGroupBox;
    Label86: TLabel;
    Label89: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    cmbApl1: TComboBox;
    cmbApl2: TComboBox;
    cmbApl3: TComboBox;
    cmbApl4: TComboBox;
    cmbApl5: TComboBox;
    cmbApl6: TComboBox;
    cmbApl7: TComboBox;
    GroupBox17: TGroupBox;
    Label78: TLabel;
    Label80: TLabel;
    Label82: TLabel;
    Label84: TLabel;
    cmbPar1: TComboBox;
    cmbPar2: TComboBox;
    cmbPar3: TComboBox;
    cmbPar4: TComboBox;
    GroupBox20: TGroupBox;
    Label99: TLabel;
    Label100: TLabel;
    cmbXXII1: TComboBox;
    cmbXXII2: TComboBox;
    GroupBox19: TGroupBox;
    Label95: TLabel;
    Label96: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    cmbCri1: TComboBox;
    cmbCri2: TComboBox;
    cmbCri3: TComboBox;
    cmbCri4: TComboBox;
    GroupBox16: TGroupBox;
    Label72: TLabel;
    Label74: TLabel;
    Label76: TLabel;
    cmbFun1: TComboBox;
    cmbFun2: TComboBox;
    cmbFun3: TComboBox;
    Panel1: TPanel;
    botaoRecarregarArquivosIni: TJvBitBtn;
    botaoSalvarArquivosIni: TJvBitBtn;
    GroupBox11: TGroupBox;
    Label77: TLabel;
    editBD: TEdit;
    GroupBox12: TGroupBox;
    Label81: TLabel;
    editImporta: TEdit;
    GroupBox9: TGroupBox;
    Label69: TLabel;
    Label63: TLabel;
    Label68: TLabel;
    editCNPJEstabelecimento: TEdit;
    editRegistraPreVenda: TEdit;
    editImprimeDAV: TEdit;
    GroupBox8: TGroupBox;
    Label67: TLabel;
    editArquivos: TEdit;
    GroupBox10: TGroupBox;
    Label71: TLabel;
    Label73: TLabel;
    Label75: TLabel;
    editCNPJ: TEdit;
    editNome_PAF: TEdit;
    editMD5PrincipalEXE: TEdit;
    GroupBox7: TGroupBox;
    Label64: TLabel;
    editGT: TEdit;
    GroupBox14: TGroupBox;
    MemoSerieEcf: TMemo;
    Bevel2: TBevel;
    GroupBox13: TGroupBox;
    BotaoPosicionarComponentes: TSpeedButton;
    QResolucao: TSQLQuery;
    DSResolucao: TDataSource;
    DSPResolucao: TDataSetProvider;
    CDSResolucao: TClientDataSet;
    EditServidorAppServidor: TLabeledEdit;
    EditServidorAppPorta: TLabeledEdit;
    EditServidorAppCamadas: TLabeledEdit;
    CDSConfiguracaoID: TIntegerField;
    CDSConfiguracaoID_ECF_IMPRESSORA: TIntegerField;
    CDSConfiguracaoID_ECF_RESOLUCAO: TIntegerField;
    CDSConfiguracaoID_ECF_CAIXA: TIntegerField;
    CDSConfiguracaoID_ECF_EMPRESA: TIntegerField;
    CDSConfiguracaoMENSAGEM_CUPOM: TStringField;
    CDSConfiguracaoPORTA_ECF: TStringField;
    CDSConfiguracaoIP_SERVIDOR: TStringField;
    CDSConfiguracaoIP_SITEF: TStringField;
    CDSConfiguracaoTIPO_TEF: TStringField;
    CDSConfiguracaoTITULO_TELA_CAIXA: TStringField;
    CDSConfiguracaoCAMINHO_IMAGENS_PRODUTOS: TStringField;
    CDSConfiguracaoCAMINHO_IMAGENS_MARKETING: TStringField;
    CDSConfiguracaoCAMINHO_IMAGENS_LAYOUT: TStringField;
    CDSConfiguracaoCOR_JANELAS_INTERNAS: TStringField;
    CDSConfiguracaoMARKETING_ATIVO: TStringField;
    CDSConfiguracaoCFOP_ECF: TIntegerField;
    CDSConfiguracaoCFOP_NF2: TIntegerField;
    CDSConfiguracaoTIMEOUT_ECF: TIntegerField;
    CDSConfiguracaoINTERVALO_ECF: TIntegerField;
    CDSConfiguracaoDESCRICAO_SUPRIMENTO: TStringField;
    CDSConfiguracaoDESCRICAO_SANGRIA: TStringField;
    CDSConfiguracaoTEF_TIPO_GP: TIntegerField;
    CDSConfiguracaoTEF_TEMPO_ESPERA: TIntegerField;
    CDSConfiguracaoTEF_ESPERA_STS: TIntegerField;
    CDSConfiguracaoTEF_NUMERO_VIAS: TIntegerField;
    CDSConfiguracaoDECIMAIS_QUANTIDADE: TIntegerField;
    CDSConfiguracaoDECIMAIS_VALOR: TIntegerField;
    CDSConfiguracaoBITS_POR_SEGUNDO: TIntegerField;
    CDSConfiguracaoQUANTIDADE_MAXIMA_CARTOES: TIntegerField;
    CDSConfiguracaoPESQUISA_PARTE: TStringField;
    CDSConfiguracaoULTIMA_EXCLUSAO: TIntegerField;
    CDSConfiguracaoLAUDO: TStringField;
    CDSConfiguracaoDATA_ATUALIZACAO_ESTOQUE: TDateField;
    CDSConfiguracaoPEDE_CPF_CUPOM: TStringField;
    CDSConfiguracaoTIPO_INTEGRACAO: TIntegerField;
    CDSConfiguracaoTIMER_INTEGRACAO: TIntegerField;
    CDSConfiguracaoGAVETA_SINAL_INVERTIDO: TStringField;
    CDSConfiguracaoGAVETA_UTILIZACAO: TIntegerField;
    CDSConfiguracaoQUANTIDADE_MAXIMA_PARCELA: TIntegerField;
    CDSConfiguracaoIMPRIME_PARCELA: TStringField;
    CDSConfiguracaoUSA_TECLADO_REDUZIDO: TStringField;
    CDSConfiguracaoPERMITE_LANCAR_NF_MANUAL: TStringField;
    CDSImpressoraID: TIntegerField;
    CDSImpressoraNUMERO: TIntegerField;
    CDSImpressoraCODIGO: TStringField;
    CDSImpressoraSERIE: TStringField;
    CDSImpressoraIDENTIFICACAO: TStringField;
    CDSImpressoraMC: TStringField;
    CDSImpressoraMD: TStringField;
    CDSImpressoraVR: TStringField;
    CDSImpressoraTIPO: TStringField;
    CDSImpressoraMARCA: TStringField;
    CDSImpressoraMODELO: TStringField;
    CDSImpressoraMODELO_ACBR: TStringField;
    CDSImpressoraMODELO_DOCUMENTO_FISCAL: TStringField;
    CDSImpressoraVERSAO: TStringField;
    CDSImpressoraLE: TStringField;
    CDSImpressoraLEF: TStringField;
    CDSImpressoraMFD: TStringField;
    CDSImpressoraLACRE_NA_MFD: TStringField;
    CDSImpressoraDOCTO: TStringField;
    CDSImpressoraDATA_INSTALACAO_SB: TDateField;
    CDSImpressoraHORA_INSTALACAO_SB: TStringField;
    procedure Confirma;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure botaoConfirmaClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PaletaCoresColorChange(Sender: TObject);
    procedure BotaoCaminhoImagemProdutoClick(Sender: TObject);
    procedure BotaoCaminhoImagemMarketingClick(Sender: TObject);
    procedure BotaoCaminhoImagemLayoutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure botaoConexoesClick(Sender: TObject);
    procedure CarregaArquivoAuxiliar;
    procedure ConfiguraACBr;
    procedure botaoReconectaImpressoraClick(Sender: TObject);
    procedure botaoRecarregarArquivosIniClick(Sender: TObject);
    procedure botaoSalvarArquivosIniClick(Sender: TObject);
    procedure botaoDesconectaImpressoraClick(Sender: TObject);
    procedure BotaoPosicionarComponentesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FConfiguracao: TFConfiguracao;
  ConfiguracaoVO: TEcfConfiguracaoVO;

implementation

uses
    UDataModule, UConfigConexao, USplash, UCaixa,
    EcfConfiguracaoController, UDataModuleConexao;

{$R *.dfm}

{$REGION 'Infra'}
procedure TFConfiguracao.FormCreate(Sender: TObject);
begin
  Application.CreateForm(TFSplash, FSplash);
  Application.CreateForm(TFDataModule, FDataModule);
  Application.CreateForm(TFDataModuleConexao, FDataModuleConexao);

  try
    FSplash.Show;
    FSplash.BringToFront;

    CDSCaixa.Active := True;
    CDSCFOP.Active := True;
    CDSConfiguracao.Active := True;
    CDSEmpresa.Active := True;
    CDSImpressora.Active := True;
    CDSResolucao.Active := True;
    CDSPosicaoComponentes.Active := True;
    //
    CDSPosicaoComponentes.MasterSource := DSResolucao;
    CDSPosicaoComponentes.MasterFields := 'ID';

    try
      ConfiguraACBr;
    except
    end;
    ConfiguracaoVO := TEcfConfiguracaoController.ConsultaObjeto('ID=1');
    CarregaArquivoAuxiliar;
  finally
    FreeAndNil(FSplash);
    FConfiguracao.Show;
    PageControl1.ActivePageIndex := 0;
  end;
end;

procedure TFConfiguracao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFConfiguracao.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F12 then
    Confirma;
end;

procedure TFConfiguracao.botaoDesconectaImpressoraClick(Sender: TObject);
begin
  try
    FDataModule.ACBrECF.Desativar;
    SinalVerde.Visible := false;
    SinalVermelho.Visible := True;
  except
  end;
end;

procedure TFConfiguracao.botaoReconectaImpressoraClick(Sender: TObject);
begin
  Confirma;
  Application.CreateForm(TFSplash, FSplash);
  FSplash.Show;
  FSplash.BringToFront;
  FDataModule.ACBrECF.Desativar;
  try
    ConfiguraACBr;
  except
  end;
  FreeAndNil(FSplash);
end;

procedure TFConfiguracao.botaoConexoesClick(Sender: TObject);
begin
  Application.CreateForm(TFConfigConexao, FConfigConexao);
  FConfigConexao.ShowModal;
end;

procedure TFConfiguracao.BotaoPosicionarComponentesClick(Sender: TObject);
begin
  Application.CreateForm(TFCaixa, FCaixa);
  FCaixa.ShowModal;
  CDSPosicaoComponentes.Refresh;
end;
{$ENDREGION 'Infra'}

{$REGION 'Edi��o, Confirma��o e Grava��o dos Dados'}
procedure TFConfiguracao.botaoConfirmaClick(Sender: TObject);
begin
  Confirma;
end;

procedure TFConfiguracao.Confirma;
begin
  try
    Application.ProcessMessages;
    if CDSConfiguracao.State in [dsEdit] then
    begin
      CDSConfiguracao.Post;
      CDSConfiguracao.ApplyUpdates(0);
    end;
    if CDSPosicaoComponentes.State in [dsEdit] then
    begin
      CDSPosicaoComponentes.Post;
      CDSPosicaoComponentes.ApplyUpdates(0);
    end;
    Application.MessageBox('Dados salvos com sucesso.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
  except
    Application.MessageBox('Erro ao salvar modifica��es.', 'Informa��o do Sistema', MB_OK + MB_ICONERROR);
    Abort;
  end;
end;

procedure TFConfiguracao.PaletaCoresColorChange(Sender: TObject);
begin
  CDSConfiguracao.Edit;
  CDSConfiguracao.FieldByName('COR_JANELAS_INTERNAS').AsString := ColorToString(PaletaCores.SelectedColor);
end;

procedure TFConfiguracao.BotaoCaminhoImagemProdutoClick(Sender: TObject);
begin
  Folder.Execute;
  DBEdit6.Text := Folder.Directory + '\';
  CDSConfiguracao.Edit;
end;

procedure TFConfiguracao.BotaoCaminhoImagemMarketingClick(Sender: TObject);
begin

  Folder.Execute;
  DBEdit7.Text := Folder.Directory + '\';
  CDSConfiguracao.Edit;
end;

procedure TFConfiguracao.BotaoCaminhoImagemLayoutClick(Sender: TObject);
begin
  Folder.Execute;
  DBEdit8.Text := Folder.Directory + '\';
  CDSConfiguracao.Edit;
end;
{$ENDREGION 'Edi��o, Confirma��o e Grava��o dos Dados'}

{$REGION 'Arquivo Auxiliar'}
procedure TFConfiguracao.botaoRecarregarArquivosIniClick(Sender: TObject);
begin
  CarregaArquivoAuxiliar;
end;

procedure TFConfiguracao.CarregaArquivoAuxiliar;
var
  ArquivoAuxiliarIni: TIniFile;
  ConexaoIni: TIniFile;
  I, Qtde: integer;
begin
  try
    try
      // dados arquivo auxiliar
      ArquivoAuxiliarIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ArquivoAuxiliar.ini');

      // ***********************************************************************
      // Aba Principal
      // ***********************************************************************

      MemoSerieEcf.Text := '';
      ArquivoAuxiliarIni.ReadSectionValues('SERIES', MemoSerieEcf.Lines);

      Qtde := (MemoSerieEcf.Lines.Count - 1);
      MemoSerieEcf.Text := '';
      for I := 1 to Qtde do
      begin
        if trim(ArquivoAuxiliarIni.ReadString('SERIES', 'SERIE' + IntToStr(I), '')) <> '' then
          MemoSerieEcf.Lines.Add(Codifica('D', trim(ArquivoAuxiliarIni.ReadString('SERIES', 'SERIE' + IntToStr(I), ''))));
      end;

      editGT.Text := Codifica('D', trim(ArquivoAuxiliarIni.ReadString('ECF', 'GT', '')));
      editArquivos.Text := Codifica('D', trim(ArquivoAuxiliarIni.ReadString('MD5', 'ARQUIVOS', '')));

      editCNPJEstabelecimento.Text := Codifica('D', trim(ArquivoAuxiliarIni.ReadString('ESTABELECIMENTO', 'CNPJ', '')));
      editRegistraPreVenda.Text := Codifica('D', trim(ArquivoAuxiliarIni.ReadString('ESTABELECIMENTO', 'REGISTRAPREVENDA', '')));
      editImprimeDAV.Text := Codifica('D', trim(ArquivoAuxiliarIni.ReadString('ESTABELECIMENTO', 'IMPRIMEDAV', '')));

      editCNPJ.Text := Codifica('D', trim(ArquivoAuxiliarIni.ReadString('SHOUSE', 'CNPJ', '')));
      editNome_PAF.Text := Codifica('D', trim(ArquivoAuxiliarIni.ReadString('SHOUSE', 'NOME_PAF', '')));
      editMD5PrincipalEXE.Text := Codifica('D', trim(ArquivoAuxiliarIni.ReadString('SHOUSE', 'MD5PrincipalEXE', '')));

      // ***********************************************************************
      // Aba Par�metros
      // ***********************************************************************

      cmbFun1.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('FUNCIONALIDADES', 'FUN1', ''))));
      cmbFun2.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('FUNCIONALIDADES', 'FUN2', ''))));
      cmbFun3.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('FUNCIONALIDADES', 'FUN3', ''))));

      cmbPar1.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('PARAMETROSPARANAOCONCOMITANCIA', 'PAR1', ''))));
      cmbPar2.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('PARAMETROSPARANAOCONCOMITANCIA', 'PAR2', ''))));
      cmbPar3.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('PARAMETROSPARANAOCONCOMITANCIA', 'PAR3', ''))));
      cmbPar4.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('PARAMETROSPARANAOCONCOMITANCIA', 'PAR4', ''))));

      cmbCri1.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('CRITERIOSPORUNIDADEFEDERADA', 'CRI1', ''))));
      cmbCri2.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('CRITERIOSPORUNIDADEFEDERADA', 'CRI2', ''))));
      cmbCri3.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('CRITERIOSPORUNIDADEFEDERADA', 'CRI3', ''))));
      cmbCri4.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('CRITERIOSPORUNIDADEFEDERADA', 'CRI4', ''))));

      cmbApl1.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('APLICATIVOSESPECIAIS', 'APL1', ''))));
      cmbApl2.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('APLICATIVOSESPECIAIS', 'APL2', ''))));
      cmbApl3.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('APLICATIVOSESPECIAIS', 'APL3', ''))));
      cmbApl4.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('APLICATIVOSESPECIAIS', 'APL4', ''))));
      cmbApl5.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('APLICATIVOSESPECIAIS', 'APL5', ''))));
      cmbApl6.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('APLICATIVOSESPECIAIS', 'APL6', ''))));
      cmbApl7.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('APLICATIVOSESPECIAIS', 'APL7', ''))));

      cmbXXII1.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('XXIIREQUISITO', 'XXII1', ''))));
      cmbXXII2.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('XXIIREQUISITO', 'XXII2', ''))));

      cmbXXXVI1.Text := (Codifica('D', trim(ArquivoAuxiliarIni.ReadString('XXXVIREQUISITO', 'XXXVI1', ''))));

      // ***********************************************************************
      // Aba Conex�o
      // ***********************************************************************

      ConexaoIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Conexao.ini');

      editBD.Text := ConexaoIni.ReadString('SGBD', 'BD', '');

      editImporta.Text := ConexaoIni.ReadString('INTEGRACAO', 'REMOTEAPP', '');

      EditServidorAppServidor.Text := ConexaoIni.ReadString('ServidorApp', 'Servidor', '');
      EditServidorAppPorta.Text := ConexaoIni.ReadString('ServidorApp', 'Porta', '');
      EditServidorAppCamadas.Text := ConexaoIni.ReadString('ServidorApp', 'Camadas', '');

      // Dados ECF
      if FDataModule.ACBrECF.Ativo then
      begin
        SerieECF.Text := FDataModule.ACBrECF.NumSerie;
        GTECF.Text := FloatToStr(FDataModule.ACBrECF.GrandeTotal);
      end;
    except
      Application.MessageBox('Problemas ao carregar um dos arquivos: ArquivoAuxiliar.ini / Conexao.ini', 'Informa��o do Sistema', MB_OK + MB_ICONERROR);
    end;
  finally
    ArquivoAuxiliarIni.Free;
    ConexaoIni.Free;
  end;
end;

procedure TFConfiguracao.botaoSalvarArquivosIniClick(Sender: TObject);
var
  ArquivoAuxiliarIni: TIniFile;
  ConexaoIni: TIniFile;
  I: integer;
  Serie: Boolean;
  Serial: string;
begin
  try
    try
      if Application.MessageBox('Tem certeza que deseja salvar estes dados no ArquivoAuxiliar.ini?' + #13 + 'Os dados antigos do arquivo ser�o perdidos.', 'Informa��o do Sistema', MB_YESNO + MB_ICONQUESTION) = mryes then
      begin
        // dados arquivo auxiliar
        ArquivoAuxiliarIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ArquivoAuxiliar.ini');

        // *********************************************************************
        // Aba Principal
        // *********************************************************************
        ArquivoAuxiliarIni.WriteString('ECF', 'GT', Codifica('C', trim(GTECF.Text)));
        Serie := false;

        for I := 0 to MemoSerieEcf.Lines.Count - 1 do
        begin
          if (trim(MemoSerieEcf.Lines.Strings[I])) = (trim(SerieECF.Text)) then
            Serie := True;
        end;

        if not Serie then
        begin
          MemoSerieEcf.Lines.Add(trim(SerieECF.Text));
        end;

        for I := 0 to MemoSerieEcf.Lines.Count - 1 do
        begin
          if trim(MemoSerieEcf.Lines.Strings[I]) <> '' then
          begin
            Serial := 'SERIE' + IntToStr(I + 1);
            ArquivoAuxiliarIni.WriteString('SERIES', pchar(Serial), Codifica('C', trim(MemoSerieEcf.Lines.Strings[I])));
          end;
          Application.ProcessMessages;
        end;

        ArquivoAuxiliarIni.WriteString('MD5', 'ARQUIVOS', Codifica('C', trim(editArquivos.Text)));

        ArquivoAuxiliarIni.WriteString('ESTABELECIMENTO', 'CNPJ', Codifica('C', trim(editCNPJEstabelecimento.Text)));
        ArquivoAuxiliarIni.WriteString('ESTABELECIMENTO', 'REGISTRAPREVENDA', Codifica('C', trim(editRegistraPreVenda.Text)));
        ArquivoAuxiliarIni.WriteString('ESTABELECIMENTO', 'IMPRIMEDAV', Codifica('C', trim(editImprimeDAV.Text)));

        ArquivoAuxiliarIni.WriteString('SHOUSE', 'CNPJ', Codifica('C', trim(editCNPJ.Text)));
        ArquivoAuxiliarIni.WriteString('SHOUSE', 'NOME_PAF', Codifica('C', trim(editNome_PAF.Text)));
        ArquivoAuxiliarIni.WriteString('SHOUSE', 'MD5PrincipalEXE', Codifica('C', trim(editMD5PrincipalEXE.Text)));

        // *********************************************************************
        // Aba Par�metros
        // *********************************************************************

        ArquivoAuxiliarIni.WriteString('FUNCIONALIDADES', 'FUN1', Codifica('C', trim(cmbFun1.Text)));
        ArquivoAuxiliarIni.WriteString('FUNCIONALIDADES', 'FUN2', Codifica('C', trim(cmbFun2.Text)));
        ArquivoAuxiliarIni.WriteString('FUNCIONALIDADES', 'FUN3', Codifica('C', trim(cmbFun3.Text)));

        ArquivoAuxiliarIni.WriteString('PARAMETROSPARANAOCONCOMITANCIA', 'PAR1', Codifica('C', trim(cmbPar1.Text)));
        ArquivoAuxiliarIni.WriteString('PARAMETROSPARANAOCONCOMITANCIA', 'PAR2', Codifica('C', trim(cmbPar2.Text)));
        ArquivoAuxiliarIni.WriteString('PARAMETROSPARANAOCONCOMITANCIA', 'PAR3', Codifica('C', trim(cmbPar3.Text)));
        ArquivoAuxiliarIni.WriteString('PARAMETROSPARANAOCONCOMITANCIA', 'PAR4', Codifica('C', trim(cmbPar4.Text)));

        ArquivoAuxiliarIni.WriteString('CRITERIOSPORUNIDADEFEDERADA', 'CRI1', Codifica('C', trim(cmbCri1.Text)));
        ArquivoAuxiliarIni.WriteString('CRITERIOSPORUNIDADEFEDERADA', 'CRI2', Codifica('C', trim(cmbCri2.Text)));
        ArquivoAuxiliarIni.WriteString('CRITERIOSPORUNIDADEFEDERADA', 'CRI3', Codifica('C', trim(cmbCri3.Text)));
        ArquivoAuxiliarIni.WriteString('CRITERIOSPORUNIDADEFEDERADA', 'CRI4', Codifica('C', trim(cmbCri4.Text)));

        ArquivoAuxiliarIni.WriteString('APLICATIVOSESPECIAIS', 'APL1', Codifica('C', trim(cmbApl1.Text)));
        ArquivoAuxiliarIni.WriteString('APLICATIVOSESPECIAIS', 'APL2', Codifica('C', trim(cmbApl2.Text)));
        ArquivoAuxiliarIni.WriteString('APLICATIVOSESPECIAIS', 'APL3', Codifica('C', trim(cmbApl3.Text)));
        ArquivoAuxiliarIni.WriteString('APLICATIVOSESPECIAIS', 'APL4', Codifica('C', trim(cmbApl4.Text)));
        ArquivoAuxiliarIni.WriteString('APLICATIVOSESPECIAIS', 'APL5', Codifica('C', trim(cmbApl5.Text)));
        ArquivoAuxiliarIni.WriteString('APLICATIVOSESPECIAIS', 'APL6', Codifica('C', trim(cmbApl6.Text)));
        ArquivoAuxiliarIni.WriteString('APLICATIVOSESPECIAIS', 'APL7', Codifica('C', trim(cmbApl7.Text)));

        ArquivoAuxiliarIni.WriteString('XXIIREQUISITO', 'XXII1', Codifica('C', trim(cmbXXII1.Text)));
        ArquivoAuxiliarIni.WriteString('XXIIREQUISITO', 'XXII2', Codifica('C', trim(cmbXXII2.Text)));

        ArquivoAuxiliarIni.WriteString('XXXVIREQUISITO', 'XXXVI1', Codifica('C', trim(cmbXXXVI1.Text)));

        // *********************************************************************
        // Aba Conex�o
        // *********************************************************************
        ConexaoIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Conexao.ini');

        ConexaoIni.WriteString('SGBD', 'BD', editBD.Text);

        ConexaoIni.WriteString('INTEGRACAO', 'REMOTEAPP', editImporta.Text);

        ConexaoIni.WriteString('ServidorApp', 'Servidor', EditServidorAppServidor.Text);
        ConexaoIni.WriteString('ServidorApp', 'Porta', EditServidorAppPorta.Text);
        ConexaoIni.WriteString('ServidorApp', 'Camadas', EditServidorAppCamadas.Text);
      end;
    except
      Application.MessageBox('Problemas ao salvar um dos arquivos: ArquivoAuxiliar.ini / Conexao.ini', 'Informa��o do Sistema', MB_OK + MB_ICONERROR);
    end;
  finally
    ArquivoAuxiliarIni.Free;
    ConexaoIni.Free;
  end;
end;
{$ENDREGION 'Arquivo Auxiliar'}

{$REGION 'ACBr'}
procedure TFConfiguracao.ConfiguraACBr;
begin
  FDataModule.ACBrECF.Modelo := TACBrECFModelo(GetEnumValue(TypeInfo(TACBrECFModelo), CDSImpressora.FieldByName('MODELO_ACBR').AsString));
  FDataModule.ACBrECF.Porta := CDSConfiguracao.FieldByName('PORTA_ECF').AsString;
  FDataModule.ACBrECF.TimeOut := CDSConfiguracao.FieldByName('TIMEOUT_ECF').Asinteger;
  FDataModule.ACBrECF.IntervaloAposComando := CDSConfiguracao.FieldByName('INTERVALO_ECF').Asinteger;
  FDataModule.ACBrECF.Device.Baud := CDSConfiguracao.FieldByName('BITS_POR_SEGUNDO').Asinteger;
  try
    FSplash.lbMensagem.caption := 'Conectando ao ECF...';
    FSplash.lbMensagem.Refresh;
    FDataModule.ACBrECF.Ativar;
    FSplash.lbMensagem.caption := 'ECF conectado!';
    FSplash.lbMensagem.Refresh;
    FSplash.imgECF.Visible := True;
    FSplash.imgTEF.Visible := True;
    SinalVerde.Visible := True;
    SinalVermelho.Visible := false;
  except
    FSplash.lbMensagem.caption := 'Falha ao tentar conectar ECF!';
    FSplash.lbMensagem.Refresh;
    Application.MessageBox('ECF com problemas ou desligado. Configura��es diretas com o ECF n�o funcionar�o.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
    SinalVerde.Visible := false;
    SinalVermelho.Visible := True;
  end;
  FDataModule.ACBrECF.CarregaAliquotas;
  if FDataModule.ACBrECF.Aliquotas.Count <= 0 then
  begin
    Application.MessageBox('ECF sem al�quotas cadastradas. Aplica��o ser� aberta para somente consulta.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
  end;
  FDataModule.ACBrECF.CarregaFormasPagamento;

  if FDataModule.ACBrECF.FormasPagamento.Count <= 0 then
  begin
    Application.MessageBox('ECF sem formas de pagamento cadastradas. Aplica��o ser� aberta para somente consulta.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
  end;
end;
{$ENDREGION 'ACBr'}

end.
