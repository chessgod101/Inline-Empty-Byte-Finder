object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Inline Empty Byte Finder'
  ClientHeight = 487
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ListView1: TListView
    Left = 0
    Top = 113
    Width = 625
    Height = 355
    Align = alClient
    Columns = <
      item
        Caption = 'Section'
        Width = 100
      end
      item
        Caption = 'Offset'
        Width = 100
      end
      item
        Caption = 'RVA'
        Width = 100
      end
      item
        Caption = 'Size'
        Width = 100
      end
      item
        Caption = 'Size(Hex)'
        Width = 100
      end>
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = ListView1ColumnClick
    OnCompare = ListView1Compare
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 625
    Height = 113
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 363
      Top = 74
      Width = 23
      Height = 13
      Caption = 'Size:'
    end
    object Label2: TLabel
      Left = 19
      Top = 28
      Width = 16
      Height = 13
      Caption = 'PE:'
    end
    object Label3: TLabel
      Left = 209
      Top = 74
      Width = 59
      Height = 13
      Caption = 'Empty Byte:'
    end
    object FilePathEdit: TEdit
      Left = 48
      Top = 25
      Width = 378
      Height = 21
      TabOrder = 0
    end
    object Button1: TButton
      Left = 440
      Top = 23
      Width = 75
      Height = 25
      Caption = '<-Choose'
      TabOrder = 1
      OnClick = Button1Click
    end
    object GroupBox1: TGroupBox
      Left = 536
      Top = 11
      Width = 81
      Height = 89
      Caption = 'Section Flags'
      TabOrder = 2
      object ExecutableCB: TCheckBox
        Left = 6
        Top = 16
        Width = 97
        Height = 17
        Caption = 'Executable'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object ReadableCB: TCheckBox
        Left = 6
        Top = 39
        Width = 97
        Height = 17
        Caption = 'Readable'
        TabOrder = 1
      end
      object WritableCB: TCheckBox
        Left = 6
        Top = 62
        Width = 97
        Height = 17
        Caption = 'Writable'
        TabOrder = 2
      end
    end
    object GoButton: TButton
      Left = 48
      Top = 69
      Width = 75
      Height = 25
      Caption = 'Go'
      TabOrder = 3
      OnClick = GoButtonClick
    end
    object SizeEdit: TEdit
      Left = 392
      Top = 71
      Width = 75
      Height = 21
      TabOrder = 4
      Text = '20'
    end
    object EmptyByteEdit: TEdit
      Left = 274
      Top = 71
      Width = 75
      Height = 21
      MaxLength = 2
      TabOrder = 5
      Text = '00'
    end
    object HexCB: TCheckBox
      Left = 473
      Top = 73
      Width = 42
      Height = 17
      Caption = 'Hex'
      TabOrder = 6
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 468
    Width = 625
    Height = 19
    Panels = <
      item
        Text = 'Caves Found:'
        Width = 200
      end>
  end
  object OpenDialog1: TOpenDialog
    Filter = 'PE File | *.exe; *.dll'
    Left = 168
    Top = 56
  end
  object PopupMenu1: TPopupMenu
    Left = 256
    Top = 184
    object C1: TMenuItem
      Caption = 'Copy Section'
      OnClick = C1Click
    end
    object C2: TMenuItem
      Caption = 'Copy Offset'
      OnClick = C2Click
    end
    object C3: TMenuItem
      Caption = 'Copy RVA'
      OnClick = C3Click
    end
    object C4: TMenuItem
      Caption = 'Copy Size'
      OnClick = C4Click
    end
    object C5: TMenuItem
      Caption = 'Copy Size(Hex)'
      OnClick = C5Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object H1: TMenuItem
      Caption = 'Hiew32 Actions'
      object F1: TMenuItem
        Caption = 'Follow Offset in Hex'
        ShortCut = 114
        OnClick = F1Click
      end
      object F2: TMenuItem
        Caption = 'Follow RVA in DISASM'
        ShortCut = 115
        OnClick = F2Click
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 360
    Top = 64
    object O1: TMenuItem
      Caption = 'Settings'
      object P1: TMenuItem
        Caption = 'Configuration'
        OnClick = P1Click
      end
    end
    object H2: TMenuItem
      Caption = 'Help'
      object A1: TMenuItem
        Caption = 'About'
        OnClick = A1Click
      end
    end
  end
end
