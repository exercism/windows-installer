object frmInstallLocation: TfrmInstallLocation
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
    Left = 68
    Top = 108
    Width = 507
    Height = 16
    Caption = 
      'It is recommended to install the CLI in the suggested location t' +
      'o avoid permission issues.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
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
      Width = 116
      Height = 19
      Caption = 'Install Location'
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
      Width = 201
      Height = 17
      Caption = 'Where to install Exercism CLI?'
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
  object fldLocation: TEdit
    Left = 68
    Top = 140
    Width = 393
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Text = 'C:\Exercism'
  end
  object btnBrowse: TButton
    Left = 467
    Top = 140
    Width = 75
    Height = 25
    Caption = '&Browse'
    TabOrder = 4
    OnClick = btnBrowseClick
  end
  object RzSelectFolderDialog1: TRzSelectFolderDialog
    Options = [sfdoContextMenus, sfdoCreateFolderIcon, sfdoDeleteFolderIcon]
    Left = 440
    Top = 208
  end
end
