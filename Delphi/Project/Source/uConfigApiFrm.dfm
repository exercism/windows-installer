object frmConfigAPI: TfrmConfigAPI
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Exercism CLI Install'
  ClientHeight = 352
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 64
    Top = 116
    Width = 433
    Height = 32
    Caption = 
      'The CLI requires the API Key that Exercism assigned you when you' +
      ' created your account.  Please enter your key into the field bel' +
      'ow.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object OvcURL1: TOvcURL
    Left = 64
    Top = 224
    Width = 216
    Height = 16
    Caption = 'I don'#39't have or don'#39't know my API key'
    URL = 'http://exercism.io/account/key'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 64
    Top = 160
    Width = 42
    Height = 13
    Caption = 'API Key:'
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 73
    Align = alTop
    BevelOuter = bvNone
    Color = 5975778
    ParentBackground = False
    TabOrder = 0
    object Label1: TLabel
      Left = 80
      Top = 8
      Width = 105
      Height = 19
      Caption = 'Configuration'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 100
      Top = 33
      Width = 150
      Height = 17
      Caption = 'Provide API Key for CLI'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
  object btnFinish: TButton
    Left = 509
    Top = 300
    Width = 75
    Height = 25
    Caption = '&Finish'
    Enabled = False
    TabOrder = 1
    OnClick = btnFinishClick
  end
  object fldAPI: TEdit
    Left = 65
    Top = 179
    Width = 509
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnChange = fldAPIChange
  end
end
