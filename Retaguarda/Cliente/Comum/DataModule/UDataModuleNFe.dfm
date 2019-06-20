object FDataModuleNFe: TFDataModuleNFe
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 641
  Width = 912
  object CDSVolumes: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 356
    Top = 22
  end
  object DSVolumes: TDataSource
    DataSet = CDSVolumes
    Left = 356
    Top = 70
  end
  object CDSNfReferenciada: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 356
    Top = 134
  end
  object DSNfReferenciada: TDataSource
    DataSet = CDSNfReferenciada
    Left = 356
    Top = 182
  end
  object CDSCteReferenciado: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 212
    Top = 134
  end
  object DSCteReferenciado: TDataSource
    DataSet = CDSCteReferenciado
    Left = 212
    Top = 182
  end
  object CDSNfRuralReferenciada: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 212
    Top = 22
  end
  object DSNfRuralReferenciada: TDataSource
    DataSet = CDSNfRuralReferenciada
    Left = 212
    Top = 70
  end
  object CDSCupomReferenciado: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 68
    Top = 254
  end
  object DSCupomReferenciado: TDataSource
    DataSet = CDSCupomReferenciado
    Left = 68
    Top = 302
  end
  object CDSDuplicata: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 212
    Top = 254
  end
  object DSDuplicata: TDataSource
    DataSet = CDSDuplicata
    Left = 212
    Top = 302
  end
  object CDSNfeReferenciada: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 68
    Top = 134
  end
  object DSNfeReferenciada: TDataSource
    DataSet = CDSNfeReferenciada
    Left = 68
    Top = 182
  end
  object CDSNfeDetalhe: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 68
    Top = 22
  end
  object DSNfeDetalhe: TDataSource
    DataSet = CDSNfeDetalhe
    Left = 68
    Top = 70
  end
  object CDSReboque: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 356
    Top = 254
  end
  object DSReboque: TDataSource
    DataSet = CDSReboque
    Left = 356
    Top = 302
  end
  object CDSNfeImpostoCofins: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    MasterSource = DSNfeDetalhe
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 492
    Top = 22
  end
  object DSNfeImpostoCofins: TDataSource
    DataSet = CDSNfeImpostoCofins
    Left = 492
    Top = 70
  end
  object CDSNfeImpostoIcms: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    MasterSource = DSNfeDetalhe
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 492
    Top = 134
  end
  object DSNfeImpostoIcms: TDataSource
    DataSet = CDSNfeImpostoIcms
    Left = 492
    Top = 182
  end
  object CDSNfeImpostoImportacao: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    MasterSource = DSNfeDetalhe
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 492
    Top = 254
  end
  object DSNfeImpostoImportacao: TDataSource
    DataSet = CDSNfeImpostoImportacao
    Left = 492
    Top = 302
  end
  object CDSNfeImpostoIpi: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    MasterSource = DSNfeDetalhe
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 636
    Top = 22
  end
  object DSNfeImpostoIpi: TDataSource
    DataSet = CDSNfeImpostoIpi
    Left = 636
    Top = 70
  end
  object CDSNfeImpostoIssqn: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'ID_NFE_DETALHE'
    MasterFields = 'ID'
    MasterSource = DSNfeDetalhe
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 636
    Top = 134
  end
  object DSNfeImpostoIssqn: TDataSource
    DataSet = CDSNfeImpostoIssqn
    Left = 636
    Top = 182
  end
  object CDSNfeImpostoPis: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    MasterSource = DSNfeDetalhe
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 636
    Top = 254
  end
  object DSNfeImpostoPis: TDataSource
    DataSet = CDSNfeImpostoPis
    Left = 636
    Top = 302
  end
  object CDSNfeDeclaracaoImportacao: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'DEFAULT_ORDER'
      end
      item
        Name = 'CHANGEINDEX'
      end>
    MasterSource = DSNfeDetalhe
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 68
    Top = 374
  end
  object DSNfeDeclaracaoImportacao: TDataSource
    DataSet = CDSNfeDeclaracaoImportacao
    Left = 68
    Top = 422
  end
  object CDSNfeImportacaoDetalhe: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    MasterSource = DSNfeDeclaracaoImportacao
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 68
    Top = 494
  end
  object DSNfeImportacaoDetalhe: TDataSource
    DataSet = CDSNfeImportacaoDetalhe
    Left = 68
    Top = 542
  end
  object CDSNfeDetalheVeiculo: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    MasterSource = DSNfeDetalhe
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 212
    Top = 374
  end
  object DSNfeDetalheVeiculo: TDataSource
    DataSet = CDSNfeDetalheVeiculo
    Left = 212
    Top = 422
  end
  object CDSNfeDetalheArmamento: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    MasterSource = DSNfeDetalhe
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 212
    Top = 494
  end
  object DSNfeDetalheArmamento: TDataSource
    DataSet = CDSNfeDetalheArmamento
    Left = 212
    Top = 542
  end
  object CDSNfeDetalheCombustivel: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    MasterSource = DSNfeDetalhe
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 356
    Top = 374
  end
  object DSNfeDetalheCombustivel: TDataSource
    DataSet = CDSNfeDetalheCombustivel
    Left = 356
    Top = 422
  end
  object CDSNfeDetalheMedicamento: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    MasterSource = DSNfeDetalhe
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 356
    Top = 494
  end
  object DSNfeDetalheMedicamento: TDataSource
    DataSet = CDSNfeDetalheMedicamento
    Left = 356
    Top = 542
  end
  object CDSVolumesLacres: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    MasterSource = DSVolumes
    PacketRecords = 0
    Params = <>
    StoreDefs = True
    AfterEdit = ControlaPersistencia
    Left = 492
    Top = 374
  end
  object DSVolumesLacres: TDataSource
    DataSet = CDSVolumesLacres
    Left = 492
    Top = 422
  end
  object CDSNfeNumero: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 492
    Top = 494
  end
  object DSNfeNumero: TDataSource
    DataSet = CDSNfeNumero
    Left = 492
    Top = 542
  end
end
