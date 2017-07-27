object frmDownload: TfrmDownload
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
      Width = 83
      Height = 19
      Caption = 'Installation'
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
      Width = 260
      Height = 17
      Caption = 'Installing Latest Version of Exercism CLI'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
  object btnCancel: TButton
    Left = 421
    Top = 300
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnNext: TButton
    Left = 509
    Top = 300
    Width = 75
    Height = 25
    Caption = '&Next >'
    TabOrder = 2
    OnClick = btnNextClick
  end
  object mStatus: TMemo
    Left = 12
    Top = 84
    Width = 617
    Height = 169
    Color = clInactiveCaptionText
    ReadOnly = True
    TabOrder = 3
  end
  object dlProgress: TProgressBar
    Left = 21
    Top = 268
    Width = 597
    Height = 21
    TabOrder = 4
  end
end
