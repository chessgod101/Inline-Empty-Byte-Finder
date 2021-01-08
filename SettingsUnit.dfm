object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Configuration'
  ClientHeight = 125
  ClientWidth = 449
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 433
    Height = 57
    Caption = 'Hiew Path:'
    TabOrder = 0
    object HiewPathEdit: TEdit
      Left = 12
      Top = 22
      Width = 321
      Height = 21
      TabOrder = 0
    end
    object Button1: TButton
      Left = 339
      Top = 20
      Width = 75
      Height = 25
      Caption = '<- Choose'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object Button2: TButton
    Left = 20
    Top = 83
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Button3: TButton
    Left = 354
    Top = 83
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Hiew Exe |*.exe'
    Left = 328
    Top = 51
  end
end
