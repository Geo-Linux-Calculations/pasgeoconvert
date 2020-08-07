object Form1: TForm1
  Left = 265
  Top = 107
  Width = 515
  Height = 599
  Caption = #1043#1077#1086#1076#1077#1079#1080#1095#1077#1089#1082#1080#1081' '#1082#1086#1085#1074#1077#1088#1090#1086#1088
  Color = clBtnFace
  Constraints.MaxHeight = 600
  Constraints.MaxWidth = 515
  Constraints.MinHeight = 522
  Constraints.MinWidth = 515
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PB1: TProgressBar
    Left = 0
    Top = 556
    Width = 507
    Height = 16
    Align = alBottom
    TabOrder = 0
  end
  object Panel3: TPanel
    Left = 0
    Top = 519
    Width = 507
    Height = 37
    Align = alBottom
    BevelInner = bvLowered
    TabOrder = 1
    object _save: TButton
      Left = 374
      Top = 6
      Width = 129
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = _LoadClick
    end
    object _convert: TButton
      Left = 8
      Top = 6
      Width = 105
      Height = 25
      Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = _convertClick
    end
    object _Load: TButton
      Left = 240
      Top = 6
      Width = 126
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1089#1093'. '#1076#1072#1085#1085#1099#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = _LoadClick
    end
  end
  object _page: TPageControl
    Left = 0
    Top = 0
    Width = 507
    Height = 519
    ActivePage = TabSheet5
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Style = tsButtons
    TabOrder = 2
    TabWidth = 250
    object TabSheet5: TTabSheet
      Caption = ' '#1043#1077#1086#1076#1077#1079#1080#1095#1077#1089#1082#1080#1093' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
      object Panel2: TPanel
        Left = 0
        Top = 137
        Width = 499
        Height = 351
        Align = alClient
        TabOrder = 0
        object MR1: TMemo
          Left = 247
          Top = 1
          Width = 251
          Height = 349
          Align = alClient
          Color = clScrollBar
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
        end
        object MP1: TMemo
          Left = 1
          Top = 1
          Width = 246
          Height = 349
          Align = alLeft
          ScrollBars = ssBoth
          TabOrder = 1
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 499
        Height = 137
        Align = alTop
        BevelInner = bvLowered
        TabOrder = 1
        object _lr: TLabel
          Left = 240
          Top = 8
          Width = 96
          Height = 21
          AutoSize = False
          Caption = #1056#1077#1079'. '#1101#1083#1083#1080#1087#1089#1086#1080#1076
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
        end
        object _: TLabel
          Left = 6
          Top = 8
          Width = 95
          Height = 21
          AutoSize = False
          Caption = #1048#1089#1093'. '#1101#1083#1083#1080#1087#1089#1086#1080#1076
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
        end
        object Label1: TLabel
          Left = 2
          Top = 108
          Width = 255
          Height = 21
          AutoSize = False
          Caption = ' '#1050#1086#1086#1088#1076#1080#1085#1072#1090#1099' : (N481200.00-E321500.00)*'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
        end
        object Label12: TLabel
          Left = 258
          Top = 108
          Width = 238
          Height = 22
          AutoSize = False
          Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1087#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1103
          Layout = tlCenter
        end
        object _Method: TPageControl
          Left = 2
          Top = 33
          Width = 495
          Height = 57
          ActivePage = TabSheet3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Style = tsButtons
          TabOrder = 0
          TabWidth = 160
          object TabSheet3: TTabSheet
            Caption = #1043#1077#1086#1094#1077#1085#1090#1088#1080#1095#1077#1089#1082#1080#1081' '#1084#1077#1090#1086#1076
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ImageIndex = 2
            ParentFont = False
          end
          object TabSheet1: TTabSheet
            Caption = #1052#1077#1090#1086#1076' '#1052#1086#1083#1086#1076#1077#1085#1089#1082#1086#1075#1086
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            object Label2: TLabel
              Left = 1
              Top = 2
              Width = 84
              Height = 18
              AutoSize = False
              Caption = #1057#1076#1074#1080#1075' '#1050#1057'    dX  ='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object Label3: TLabel
              Left = 161
              Top = 2
              Width = 84
              Height = 18
              AutoSize = False
              Caption = #1057#1076#1074#1080#1075' '#1050#1057'    dY  ='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object Label4: TLabel
              Left = 320
              Top = 2
              Width = 91
              Height = 18
              AutoSize = False
              Caption = #1057#1076#1074#1080#1075' '#1050#1057'    dZ  ='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object _dX: TEdit
              Left = 96
              Top = 0
              Width = 52
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              Text = '28'
            end
            object _dY: TEdit
              Left = 256
              Top = 0
              Width = 49
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              Text = '-130'
            end
            object _dZ: TEdit
              Left = 411
              Top = 0
              Width = 51
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              Text = '-95'
            end
          end
          object TabSheet2: TTabSheet
            Caption = #1052#1077#1090#1086#1076' '#1061#1077#1083#1100#1084#1077#1088#1090#1072' 7 '#1087#1072#1088#1072#1084'.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ImageIndex = 1
            ParentFont = False
            object Label5: TLabel
              Left = 1
              Top = 4
              Width = 20
              Height = 21
              AutoSize = False
              Caption = 'dX:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object Label6: TLabel
              Left = 62
              Top = 4
              Width = 20
              Height = 21
              AutoSize = False
              Caption = 'dY:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object Label7: TLabel
              Left = 126
              Top = 4
              Width = 20
              Height = 21
              AutoSize = False
              Caption = 'dZ:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object Label8: TLabel
              Left = 190
              Top = 4
              Width = 20
              Height = 21
              AutoSize = False
              Caption = 'RX:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object Label9: TLabel
              Left = 257
              Top = 4
              Width = 20
              Height = 21
              AutoSize = False
              Caption = 'RY:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object Label10: TLabel
              Left = 324
              Top = 4
              Width = 20
              Height = 21
              AutoSize = False
              Caption = 'RZ:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object Label11: TLabel
              Left = 397
              Top = 5
              Width = 51
              Height = 18
              AutoSize = False
              Caption = 'k*10E-6 :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object _V0: TEdit
              Left = 21
              Top = 4
              Width = 34
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              Text = '25'
            end
            object _V1: TEdit
              Left = 85
              Top = 4
              Width = 34
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              Text = '-141'
            end
            object _V2: TEdit
              Left = 147
              Top = 4
              Width = 37
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              Text = '-78.5'
            end
            object _V3: TEdit
              Left = 211
              Top = 4
              Width = 40
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
              Text = '0'
            end
            object _V4: TEdit
              Left = 280
              Top = 4
              Width = 40
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              Text = '-0.35'
            end
            object _V5: TEdit
              Left = 350
              Top = 4
              Width = 40
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 5
              Text = '-0.736'
            end
            object _V6: TEdit
              Left = 448
              Top = 3
              Width = 46
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 6
              Text = '0'
            end
          end
        end
        object _From: TComboBox
          Left = 101
          Top = 8
          Width = 132
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 1
          OnChange = _FromChange
        end
        object _to: TComboBox
          Left = 338
          Top = 8
          Width = 154
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 2
          OnChange = _FromChange
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077' '#1087#1088#1086#1077#1082#1094#1080#1081
      ImageIndex = 1
      object _txt: TLabel
        Left = 0
        Top = 113
        Width = 499
        Height = 21
        Align = alTop
        AutoSize = False
        Caption = ' '#1050#1086#1086#1088#1076#1080#1085#1072#1090#1099' : (N481200.00-E321500.00)*'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object Panel4: TPanel
        Left = 0
        Top = 134
        Width = 499
        Height = 354
        Align = alClient
        TabOrder = 0
        object MR2: TMemo
          Left = 245
          Top = 1
          Width = 253
          Height = 352
          Align = alClient
          Color = clScrollBar
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
          OnEnter = MR2Enter
          OnKeyPress = MR2KeyPress
        end
        object MP2: TMemo
          Left = 1
          Top = 1
          Width = 244
          Height = 352
          Align = alLeft
          ScrollBars = ssBoth
          TabOrder = 1
        end
      end
      object _vect: TRadioGroup
        Left = 0
        Top = 75
        Width = 499
        Height = 38
        Align = alTop
        Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1087#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1103' '
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          #1050#1086#1086#1088#1076#1080#1085#1072#1090#1072' => '#1087#1083#1072#1085' (BL=>XY)'
          #1055#1083#1072#1085' => '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1072'  (XY=>BL)')
        TabOrder = 1
        OnClick = _vectClick
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 499
        Height = 75
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object _lBts: TLabel
          Left = 102
          Top = 27
          Width = 25
          Height = 21
          AutoSize = False
          Caption = 'B'#1090#1089'='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          Visible = False
        end
        object _lB2: TLabel
          Left = 102
          Top = 51
          Width = 30
          Height = 21
          AutoSize = False
          Caption = 'B'#1102'='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          Visible = False
        end
        object _lB1: TLabel
          Left = 102
          Top = 27
          Width = 30
          Height = 21
          AutoSize = False
          Caption = 'Bc='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          Visible = False
        end
        object _lL1: TLabel
          Left = 191
          Top = 26
          Width = 28
          Height = 21
          AutoSize = False
          Caption = 'L'#1079'='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          Visible = False
        end
        object _ll2: TLabel
          Left = 191
          Top = 50
          Width = 28
          Height = 21
          AutoSize = False
          Caption = 'L'#1074'='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          Visible = False
        end
        object _lb0: TLabel
          Left = 3
          Top = 26
          Width = 36
          Height = 21
          AutoSize = False
          Caption = #1042#1086'='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          Visible = False
        end
        object _ll0: TLabel
          Left = 3
          Top = 50
          Width = 36
          Height = 21
          AutoSize = False
          Caption = 'L'#1086'='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          Visible = False
        end
        object Label13: TLabel
          Left = 3
          Top = 0
          Width = 78
          Height = 21
          AutoSize = False
          Caption = #1055#1088#1086#1077#1082#1094#1080#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
        end
        object Label14: TLabel
          Left = 280
          Top = 0
          Width = 69
          Height = 21
          AutoSize = False
          Caption = #1069#1083#1083#1080#1087#1089#1086#1080#1076
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
        end
        object _Bts: TMaskEdit
          Left = 130
          Top = 27
          Width = 57
          Height = 21
          EditMask = '>L000000;0;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 7
          ParentFont = False
          TabOrder = 0
          Text = 'N400000'
          Visible = False
        end
        object _B2: TMaskEdit
          Left = 130
          Top = 51
          Width = 57
          Height = 21
          EditMask = '>L000000;0;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 7
          ParentFont = False
          TabOrder = 1
          Text = 'N450000'
          Visible = False
        end
        object _B1: TMaskEdit
          Left = 130
          Top = 27
          Width = 57
          Height = 21
          EditMask = '>L000000;0;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 7
          ParentFont = False
          TabOrder = 2
          Text = 'N500000'
          Visible = False
        end
        object _L1: TMaskEdit
          Left = 219
          Top = 26
          Width = 57
          Height = 21
          EditMask = '>L0000000;0;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 8
          ParentFont = False
          TabOrder = 3
          Text = 'E0300000'
          Visible = False
        end
        object _L2: TMaskEdit
          Left = 219
          Top = 50
          Width = 58
          Height = 21
          EditMask = '>L0000000;0;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 8
          ParentFont = False
          TabOrder = 4
          Text = 'E0320000'
          Visible = False
        end
        object _p2: TPanel
          Left = 290
          Top = 27
          Width = 210
          Height = 46
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          object _ldN: TLabel
            Left = 290
            Top = 0
            Width = 24
            Height = 21
            AutoSize = False
            Caption = 'dN ='
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            Visible = False
          end
          object _ldW: TLabel
            Left = 290
            Top = 0
            Width = 27
            Height = 21
            AutoSize = False
            Caption = 'dW ='
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            Visible = False
          end
          object _ldM: TLabel
            Left = 290
            Top = 24
            Width = 24
            Height = 21
            AutoSize = False
            Caption = 'dM ='
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            Visible = False
          end
          object _dW: TEdit
            Left = 290
            Top = 0
            Width = 42
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = '0.8'
            Visible = False
          end
          object _dN: TEdit
            Left = 290
            Top = 0
            Width = 42
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            Text = '0.8'
            Visible = False
          end
          object _dM: TEdit
            Left = 290
            Top = 24
            Width = 42
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            Text = '0.8'
            Visible = False
          end
        end
        object _p3: TPanel
          Left = 290
          Top = 26
          Width = 202
          Height = 46
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          object _lalpha: TLabel
            Left = 1
            Top = 1
            Width = 40
            Height = 21
            AutoSize = False
            Caption = #1073' ='
            Font.Charset = GREEK_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            Visible = False
          end
          object _lgamma: TLabel
            Left = 1
            Top = 25
            Width = 40
            Height = 21
            AutoSize = False
            Caption = #1075' ='
            Font.Charset = GREEK_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            Visible = False
          end
          object _lomega: TLabel
            Left = 99
            Top = 25
            Width = 41
            Height = 21
            AutoSize = False
            Caption = #1102' ='
            Font.Charset = GREEK_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            Visible = False
          end
          object _lzone: TLabel
            Left = 99
            Top = 1
            Width = 41
            Height = 21
            AutoSize = False
            Caption = #1047#1086#1085#1072' ='
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            Visible = False
          end
          object _alpha: TEdit
            Left = 32
            Top = 1
            Width = 61
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = '40'
            Visible = False
          end
          object _gamma: TEdit
            Left = 32
            Top = 25
            Width = 61
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            Text = '40'
            Visible = False
          end
          object _omega: TEdit
            Left = 141
            Top = 25
            Width = 61
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            Text = '40'
            Visible = False
          end
          object _zone: TComboBox
            Left = 141
            Top = 0
            Width = 63
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 13
            ItemIndex = 0
            ParentFont = False
            TabOrder = 3
            Text = '1'
            Visible = False
            Items.Strings = (
              '1'
              '2'
              '3'
              '4'
              '5'
              '6'
              '7'
              '8'
              '9'
              '10'
              '11'
              '12'
              '13'
              '14'
              '15'
              '16'
              '17'
              '18'
              '19'
              '20'
              '21'
              '22'
              '23'
              '24'
              '25'
              '26'
              '27'
              '28'
              '29'
              '30'
              '31'
              '32'
              '33'
              '34'
              '35'
              '36'
              '37'
              '38'
              '39'
              '40'
              '41'
              '42'
              '43'
              '44'
              '45'
              '46'
              '47'
              '48'
              '49'
              '50'
              '51'
              '52'
              '53'
              '54'
              '55'
              '56'
              '57'
              '58'
              '59'
              '60')
          end
        end
        object _B0: TMaskEdit
          Left = 38
          Top = 26
          Width = 61
          Height = 21
          EditMask = '>L000000;0;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 7
          ParentFont = False
          TabOrder = 7
          Text = 'N400000'
          Visible = False
        end
        object _L0: TMaskEdit
          Left = 38
          Top = 50
          Width = 61
          Height = 21
          EditMask = '>L0000000;0;_'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 8
          ParentFont = False
          TabOrder = 8
          Text = 'E0310000'
          Visible = False
        end
        object _ellps: TComboBox
          Left = 348
          Top = 0
          Width = 148
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 0
          ParentFont = False
          TabOrder = 9
        end
        object _reg: TComboBox
          Left = 38
          Top = 26
          Width = 61
          Height = 21
          Style = csDropDownList
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ItemIndex = 0
          ParentFont = False
          TabOrder = 10
          Text = 'A'
          Visible = False
          Items.Strings = (
            'A'
            'B'
            'C'
            'D'
            'E'
            'F'
            'G'
            'H'
            'I'
            'J'
            'K'
            'L'
            'M'
            'P'
            'Q'
            'R'
            'S'
            'T'
            'U'
            'V'
            'W'
            'X'
            'Y')
        end
      end
      object Proj: TComboBox
        Left = 80
        Top = 0
        Width = 184
        Height = 21
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        TabOrder = 3
        OnChange = _FromChange
      end
    end
    object TabSheet4: TTabSheet
      Caption = #1056#1072#1089#1089#1090#1086#1103#1085#1080#1077' '#1080' '#1072#1079#1080#1084#1091#1090
      ImageIndex = 2
      TabVisible = False
      object PageControl1: TPageControl
        Left = 0
        Top = 0
        Width = 499
        Height = 488
        ActivePage = TabSheet7
        Align = alClient
        Style = tsFlatButtons
        TabOrder = 0
        object TabSheet7: TTabSheet
          Caption = #1053#1072#1081#1090#1080' '#1090#1086#1095#1082#1091' '#1087#1086' '#1072#1079#1080#1084#1091#1090#1091' '#1080' '#1076#1072#1083#1100#1085#1086#1089#1090#1080' '
          object Label16: TLabel
            Left = 0
            Top = 51
            Width = 491
            Height = 21
            Align = alTop
            AutoSize = False
            Caption = ' '#1040':45.00 '#1080#1083#1080' A:0453010  D:15120'
            Layout = tlCenter
          end
          object Panel6: TPanel
            Left = 0
            Top = 72
            Width = 491
            Height = 385
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 0
            object Memo1: TMemo
              Left = 240
              Top = 0
              Width = 251
              Height = 385
              Align = alClient
              Color = clScrollBar
              TabOrder = 0
            end
            object M1: TMemo
              Left = 0
              Top = 0
              Width = 240
              Height = 385
              Align = alLeft
              TabOrder = 1
            end
          end
          object Panel7: TPanel
            Left = 0
            Top = 0
            Width = 491
            Height = 51
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object Label19: TLabel
              Left = 0
              Top = 0
              Width = 97
              Height = 21
              AutoSize = False
              Caption = #1069#1051#1051#1048#1055#1057#1054#1048#1044
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              Layout = tlCenter
            end
            object Label15: TLabel
              Left = 2
              Top = 28
              Width = 95
              Height = 21
              AutoSize = False
              Caption = #1041#1072#1079#1086#1074#1072#1103' '#1090#1086#1095#1082#1072
              Layout = tlCenter
            end
            object l1: TMaskEdit
              Left = 205
              Top = 28
              Width = 90
              Height = 21
              EditMask = 'L000\'#176'00\'#39'00.00";1;_'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              MaxLength = 14
              ParentFont = False
              TabOrder = 0
              Text = 'E000'#176'00'#39'00.00"'
            end
            object b1: TMaskEdit
              Left = 103
              Top = 28
              Width = 86
              Height = 21
              EditMask = 'L00\'#176'00\'#39'00.00";1;_'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              MaxLength = 13
              ParentFont = False
              TabOrder = 1
              Text = 'N00'#176'00'#39'00.00"'
            end
            object _elltask: TComboBox
              Left = 103
              Top = 0
              Width = 194
              Height = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 0
              ParentFont = False
              TabOrder = 2
            end
          end
        end
        object TabSheet8: TTabSheet
          Caption = #1053#1072#1081#1090#1080' '#1072#1079#1080#1084#1091#1090' '#1080' '#1076#1072#1083#1100#1085#1086#1089#1090#1100
          ImageIndex = 1
        end
      end
    end
  end
  object OD1: TOpenDialog
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099' '#1089' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1072#1084#1080'|*.txt|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Left = 440
    Top = 24
  end
  object SD1: TSaveDialog
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099'|*.txt|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Left = 472
    Top = 24
  end
end
