inherited FFolhaFechamento: TFFolhaFechamento
  Tag = 1
  Left = 318
  Top = 203
  Caption = 'Folha Fechamento'
  ClientWidth = 961
  ExplicitWidth = 977
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TPageControl
    Width = 961
    ActivePage = PaginaEdits
    ExplicitWidth = 961
    inherited PaginaGrid: TTabSheet
      ExplicitWidth = 953
      inherited PanelGrid: TPanel
        Width = 953
        ExplicitWidth = 953
        inherited Grid: TJvDBUltimGrid
          Width = 953
        end
        inherited PanelFiltroRapido: TPanel
          Width = 953
          ExplicitWidth = 953
          inherited BotaoConsultar: TSpeedButton
            Left = 821
            ExplicitLeft = 825
          end
          inherited EditCriterioRapido: TLabeledMaskEdit
            Width = 652
            ExplicitWidth = 652
          end
        end
      end
    end
    inherited PaginaEdits: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 953
      ExplicitHeight = 407
      inherited PanelEdits: TPanel
        Width = 953
        ExplicitWidth = 953
        object BevelEdits: TBevel
          Left = 10
          Top = 11
          Width = 935
          Height = 54
          Anchors = [akLeft, akTop, akRight]
          Constraints.MinWidth = 753
        end
        object EditFechamentoAtual: TLabeledMaskEdit
          Left = 18
          Top = 33
          Width = 130
          Height = 21
          Alignment = taCenter
          EditLabel.Width = 91
          EditLabel.Height = 13
          EditLabel.Caption = 'Fechamento Atual:'
          MaxLength = 7
          TabOrder = 0
          Text = '  //////'
          Required = False
          EditMask = '##/####;1;_'
          MaskState = [msMasked]
        end
        object EditProximoFechamento: TLabeledMaskEdit
          Left = 154
          Top = 33
          Width = 130
          Height = 21
          Alignment = taCenter
          EditLabel.Width = 104
          EditLabel.Height = 13
          EditLabel.Caption = 'Pr'#243'ximo Fechamento:'
          MaxLength = 7
          TabOrder = 1
          Text = '  ///////'
          Required = False
          EditMask = '##/####;1;_'
          MaskState = [msMasked]
        end
      end
    end
  end
  inherited PanelToolBar: TPanel
    Width = 961
    ExplicitWidth = 961
    inherited BotaoSair: TSpeedButton
      Left = 857
      ExplicitLeft = 889
    end
    inherited BotaoExportar: TSpeedButton
      Left = 757
      ExplicitLeft = 799
    end
    inherited BotaoImprimir: TSpeedButton
      Left = 647
      ExplicitLeft = 719
    end
    inherited BotaoSeparador1: TSpeedButton
      Left = 747
      ExplicitLeft = 895
      ExplicitTop = -4
    end
    inherited BotaoFiltrar: TSpeedButton
      Left = 547
      ExplicitLeft = 639
    end
  end
end
