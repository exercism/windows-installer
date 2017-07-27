object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
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
      Width = 146
      Height = 19
      Caption = 'License Agreement'
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
      Width = 353
      Height = 17
      Caption = 'Please read the following information before continuing'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel2: TPanel
    Left = 55
    Top = 85
    Width = 529
    Height = 189
    BevelOuter = bvLowered
    TabOrder = 1
    object Label3: TLabel
      Left = 9
      Top = 12
      Width = 163
      Height = 13
      Caption = 'GNU Affero General Public License'
    end
    object Label4: TLabel
      Left = 9
      Top = 31
      Width = 155
      Height = 13
      Caption = #169' Copyright 2017 Katrina Owen'
    end
    object Label5: TLabel
      Left = 9
      Top = 50
      Width = 88
      Height = 13
      Caption = 'All Right Reserved'
    end
    object Label6: TLabel
      Left = 9
      Top = 69
      Width = 106
      Height = 13
      Caption = 'Original Setup Design:'
    end
    object Label7: TLabel
      Left = 9
      Top = 88
      Width = 67
      Height = 13
      Caption = 'Setup Design:'
    end
    object Label8: TLabel
      Left = 121
      Top = 128
      Width = 287
      Height = 19
      Caption = 'Welcome to Exercism.io!  Happy Coding!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object OvcURL1: TOvcURL
      Left = 119
      Top = 69
      Width = 41
      Height = 13
      Caption = 'blueelvis'
      URL = 'https://twitter.com/blueelvis'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object OvcURL2: TOvcURL
      Left = 81
      Top = 88
      Width = 53
      Height = 13
      Caption = 'Ryan Potts'
      URL = 'https://github.com/rpottsoh'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
  end
  object rbAccept: TRadioButton
    Left = 56
    Top = 292
    Width = 161
    Height = 17
    Caption = 'I accept the agreement'
    TabOrder = 2
    OnClick = rbAcceptClick
  end
  object rbDontAccept: TRadioButton
    Left = 56
    Top = 320
    Width = 161
    Height = 17
    Caption = 'I don'#39't accept the agreement'
    TabOrder = 3
    OnClick = rbDontAcceptClick
  end
  object btnNext: TButton
    Left = 509
    Top = 300
    Width = 75
    Height = 25
    Caption = '&Next >'
    Enabled = False
    ModalResult = 1
    TabOrder = 4
    OnClick = btnNextClick
  end
  object btnCancel: TButton
    Left = 421
    Top = 300
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 5
    OnClick = btnCancelClick
  end
end
