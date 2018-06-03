object frmDownload: TfrmDownload
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Exercism CLI Install'
  ClientHeight = 332
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
  object Label4: TLabel
    Left = 16
    Top = 311
    Width = 149
    Height = 13
    Caption = '-------   Built with Delphi   -------'
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 73
    Align = alTop
    BevelOuter = bvNone
    Color = clGreen
    ParentBackground = False
    TabOrder = 0
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 640
      Height = 73
      Align = alClient
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000002800000
        0049080200000022D700210000002C744558744372656174696F6E2054696D65
        005361742031392041756720323031372032313A33333A3333202D30353030BA
        13FDFC0000000774494D4507E1081401222513B311DE00000009704859730000
        0EC300000EC301C76FA8640000000467414D410000B18F0BFC6105000003CD49
        44415478DAEDDD6B72DA301480514377D5657629DD5E63AB3682008110CCEB0A
        DF73DA19A6E40F6966FAF5DA92BCFAFDF74FC742957E28C310FD2900386325C0
        CB56FABE0C25FA5300F095002F5C29A51B060D06688D002F9F06033448805328
        35C04583015A21C0594CABB1C659D81C0CD006014E649A837B8BA2019A20C0B9
        6830402304381DF783015A20C01969304038014E6A3A24AB6830401801CE4B83
        010209706A1A0C104580B3733F18208400E38C8E9456A3E9D5CF1DA2083013E7
        45E732C6773DFE5EBB07018104983DCF2ECC60EC6EB7DECEBF7EE21048803932
        8D4483A3B2166A33F86E2E3EAFEA1BC3476FFC852802CC571ABC4035BAEB7D7A
        2B01864002CC1996652DCAEE8EEF97B7DDF8875802CC799B067746E1B7365D70
        EECE0CBE951D68104B80B9C4229D77559BBB5E9F4D6FE55E03C412607E5046FD
        604E7A1B57A4B712608825C0FC6C7BB3B07432DCB8ED22E793DBBD67B9BC01B1
        04986BB965D8B259E9AD9CC201B104981936A370F1AF765BBE59E4FC231330C4
        126066B37DA51527076BCC621330C412606E61140E765F7ABBBAB66E0C301047
        80B9DDF6BC0E8BB35E6693DBB3675ADD60F8F711FDFD406A02CCBD64F845EE9E
        7A0F9980219C00F3184EAF7C9E7AA0D5EAD7EC6556174C6BDA7B9B80219200F3
        48B62A3DD2D5476ADC4080219C00F378327CAF6F1E5EF4408EC1827002CCB3B8
        283D5BEDEEF86BFEA6DEB90418C209304FB4DDA7543A1B962EABABAB1EB5C0EA
        1A020CE1049857D895D862E903DBDA4E23EF2BD35B39060BC20930AF23C3D566
        557337F7E8E6C7720C1684136002D483B4EA6BFD73F4277ABECF7977F4CCD555
        579A26E0DCFF0D8270024CA4E5CFC407D79903E7DD5326600827C034615125DE
        1E18197C91F932E750423801A639DBD5B9EFB576BA4EBA35BDAD46F790004338
        01A669471B99BA6686E3DD1DDCBA6DF7F56B98EF27C0104E80791B470D2EBB37
        5E90E4CF4BCABB2D435D4DEFDBF22406688100F3AECA617AF755DEBF1C7EE582
        9392AEEA52E5335F78E7E81EFF9D0830C4136096A6DC37132FA6B2170830B440
        802123F780219C00433A2660688100433A1E060C2D1060484780A105020CE908
        30B44080211D0186160830A423C0D00201867404185A20C0908E00430B0418D2
        1160688100433A020C2D1060484780A105020CE9388A125A20C0908E00430B04
        1832F234240827C0908E09185A20C0908E00430B04183272091AC209306424C0
        104E802123018670020C190D1F7D574AF4A780D404183212600827C09051E9FB
        320830441260C84880219C004346020CE10418322AFD50060F448248020C1979
        2221841360C8C8699410EE3F1252224234E779380000000049454E44AE426082}
      ExplicitLeft = 380
      ExplicitTop = 24
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
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
      Transparent = True
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
      Transparent = True
    end
    object urlDocs: TOvcURL
      Left = 404
      Top = 32
      Width = 125
      Height = 18
      Hint = 'https://github.com/exercism/docs'
      Caption = 'CLI Documentation'
      URL = 'https://github.com/exercism/docs'
      UseVisitedColor = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
      Transparent = True
      Visible = False
    end
  end
  object btnCancel: TButton
    Left = 421
    Top = 299
    Width = 75
    Height = 25
    Caption = '&Cancel'
    Enabled = False
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object mStatus: TMemo
    Left = 8
    Top = 84
    Width = 617
    Height = 169
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object ProgressBarDownload: TProgressBar
    Left = 21
    Top = 268
    Width = 597
    Height = 21
    TabOrder = 3
  end
  object btnStopDownload: TButton
    Left = 271
    Top = 300
    Width = 97
    Height = 25
    Cancel = True
    Caption = '&Stop Download'
    TabOrder = 4
    OnClick = btnStopDownloadClick
  end
  object btnFinish: TButton
    Left = 512
    Top = 299
    Width = 75
    Height = 25
    Caption = '&Finish'
    Enabled = False
    TabOrder = 5
    OnClick = btnFinishClick
  end
  object tmrDownload: TTimer
    Interval = 500
    OnTimer = tmrDownloadTimer
    Left = 40
    Top = 264
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
    Left = 184
    Top = 128
  end
  object Assets: TRESTResponseDataSetAdapter
    Dataset = tableAssets
    FieldDefs = <>
    Response = RESTResponse1
    NestedElements = True
    Left = 260
    Top = 88
  end
  object tableAssets: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 320
    Top = 96
  end
  object tmrInstall: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrInstallTimer
    Left = 120
    Top = 272
  end
  object Root: TRESTResponseDataSetAdapter
    Dataset = tableRoot
    FieldDefs = <>
    Response = RESTResponse1
    NestedElements = True
    Left = 260
    Top = 140
  end
  object tableRoot: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 324
    Top = 176
  end
end
