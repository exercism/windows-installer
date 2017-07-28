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
  OnDestroy = FormDestroy
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
    Enabled = False
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
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object ProgressBarDownload: TProgressBar
    Left = 21
    Top = 268
    Width = 597
    Height = 21
    TabOrder = 4
  end
  object btnRetry: TButton
    Left = 156
    Top = 300
    Width = 75
    Height = 25
    Caption = 'Retry'
    TabOrder = 5
    Visible = False
    OnClick = btnRetryClick
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 44
    Top = 304
  end
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'https://api.github.com/repos/exercism/cli/releases/latest'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 52
    Top = 124
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 116
    Top = 120
  end
  object RESTResponse1: TRESTResponse
    ContentType = 'application/json'
    RootElement = 'assets'
    Left = 184
    Top = 128
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Dataset = FDMemTable1
    FieldDefs = <>
    Response = RESTResponse1
    NestedElements = True
    Left = 260
    Top = 88
  end
  object FDMemTable1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 348
    Top = 120
  end
end
