inherited FBanco: TFBanco
  Tag = 1
  Left = 318
  Top = 203
  Caption = 'Bancos'
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
          Width = 932
          Height = 153
          Anchors = [akLeft, akTop, akRight]
          Constraints.MinWidth = 753
        end
        object EditCodigo: TLabeledEdit
          Left = 18
          Top = 33
          Width = 90
          Height = 21
          Constraints.MinWidth = 90
          EditLabel.Width = 37
          EditLabel.Height = 13
          EditLabel.BiDiMode = bdLeftToRight
          EditLabel.Caption = 'C'#243'digo:'
          EditLabel.ParentBiDiMode = False
          TabOrder = 0
        end
        object EditNome: TLabeledEdit
          Left = 18
          Top = 84
          Width = 913
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 31
          EditLabel.Height = 13
          EditLabel.Caption = 'Nome:'
          TabOrder = 1
        end
        object EditURL: TLabeledEdit
          Left = 18
          Top = 132
          Width = 913
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 23
          EditLabel.Height = 13
          EditLabel.Caption = 'URL:'
          TabOrder = 2
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
