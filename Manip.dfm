object Form1: TForm1
  Left = 397
  Top = 182
  Width = 762
  Height = 397
  Caption = 'za'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LbAmp: TLabel
    Left = 112
    Top = 104
    Width = 21
    Height = 13
    Caption = 'Amp'
  end
  object LbVel: TLabel
    Left = 112
    Top = 128
    Width = 15
    Height = 13
    Caption = 'Vel'
  end
  object BtConnect: TButton
    Left = 112
    Top = 8
    Width = 65
    Height = 25
    Caption = 'Connect'
    TabOrder = 0
    OnClick = BtConnectClick
  end
  object EdDevice: TEdit
    Left = 8
    Top = 8
    Width = 97
    Height = 21
    TabOrder = 1
    Text = 'Device'
  end
  object BtDisconn: TButton
    Left = 184
    Top = 8
    Width = 65
    Height = 25
    Caption = 'Disconnect'
    TabOrder = 2
    OnClick = BtDisconnClick
  end
  object BtSendMode: TButton
    Left = 560
    Top = 48
    Width = 81
    Height = 25
    Caption = 'SendMode'
    TabOrder = 3
    OnClick = BtSendModeClick
  end
  object BtSendPar: TButton
    Left = 560
    Top = 112
    Width = 81
    Height = 25
    Caption = 'SendPar'
    TabOrder = 4
    OnClick = BtSendParClick
  end
  object RdGrCtrl: TRadioGroup
    Left = 112
    Top = 40
    Width = 433
    Height = 41
    Caption = 'Control'
    Columns = 6
    ItemIndex = 0
    Items.Strings = (
      'Stop'
      'Sensors'
      'Init'
      'Vel'
      'Trq'
      'Servo')
    TabOrder = 5
    OnClick = RdGrCtrlClick
  end
  object TrBarAmp: TTrackBar
    Left = 144
    Top = 96
    Width = 257
    Height = 25
    Max = 25
    TabOrder = 6
    OnChange = TrBarAmpChange
  end
  object TrBarVel: TTrackBar
    Left = 144
    Top = 128
    Width = 257
    Height = 25
    Max = 20
    TabOrder = 7
    OnChange = TrBarVelChange
  end
  object RdGrDir: TRadioGroup
    Left = 152
    Top = 160
    Width = 129
    Height = 33
    Caption = 'Dir'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Dir-'
      'Dir+')
    TabOrder = 8
    OnClick = RdGrDirClick
  end
  object BtSendPos: TButton
    Left = 352
    Top = 200
    Width = 81
    Height = 105
    Caption = 'SendPos'
    TabOrder = 9
    OnClick = BtSendPosClick
  end
  object onSM: TCheckBox
    Left = 656
    Top = 40
    Width = 65
    Height = 41
    Caption = 'onSM'
    Checked = True
    State = cbChecked
    TabOrder = 10
    OnClick = onSMClick
  end
  object CommandText: TEdit
    Left = 272
    Top = 8
    Width = 153
    Height = 21
    TabOrder = 11
    Text = 'CommandText'
  end
  object onSPar: TCheckBox
    Left = 656
    Top = 104
    Width = 65
    Height = 41
    Caption = 'onSPar'
    Checked = True
    State = cbChecked
    TabOrder = 12
    OnClick = onSParClick
  end
  object AmpText: TEdit
    Left = 424
    Top = 96
    Width = 121
    Height = 21
    TabOrder = 13
    Text = 'AmpText'
  end
  object VelText: TEdit
    Left = 424
    Top = 128
    Width = 121
    Height = 21
    TabOrder = 14
    Text = 'VelText'
  end
  object chkLink1: TCheckBox
    Left = 16
    Top = 80
    Width = 57
    Height = 33
    Caption = 'Link 1'
    TabOrder = 15
    OnClick = chkLink1Click
  end
  object chkLink2: TCheckBox
    Left = 16
    Top = 120
    Width = 57
    Height = 33
    Caption = 'Link 2'
    TabOrder = 16
    OnClick = chkLink2Click
  end
  object chkLink3: TCheckBox
    Left = 16
    Top = 160
    Width = 57
    Height = 33
    Caption = 'Link3'
    TabOrder = 17
    OnClick = chkLink3Click
  end
  object All: TCheckBox
    Left = 16
    Top = 48
    Width = 41
    Height = 33
    Caption = 'All'
    TabOrder = 18
    OnClick = AllClick
  end
  object res1: TEdit
    Left = 456
    Top = 200
    Width = 57
    Height = 21
    TabOrder = 19
    Text = 'res1'
  end
  object res2: TEdit
    Left = 456
    Top = 240
    Width = 57
    Height = 21
    TabOrder = 20
    Text = 'res2'
  end
  object res3: TEdit
    Left = 456
    Top = 280
    Width = 57
    Height = 21
    TabOrder = 21
    Text = 'res3'
  end
  object ZeroPosition: TButton
    Left = 160
    Top = 312
    Width = 337
    Height = 33
    Caption = 'ZeroPosition'
    TabOrder = 22
    OnClick = ZeroPositionClick
  end
  object m1: TEdit
    Left = 152
    Top = 200
    Width = 81
    Height = 21
    TabOrder = 23
    Text = '350'
  end
  object m2: TEdit
    Left = 152
    Top = 240
    Width = 81
    Height = 21
    TabOrder = 24
    Text = '120'
  end
  object m3: TEdit
    Left = 152
    Top = 280
    Width = 81
    Height = 21
    TabOrder = 25
    Text = '440'
  end
  object q1: TEdit
    Left = 248
    Top = 200
    Width = 81
    Height = 21
    TabOrder = 26
    Text = '310'
  end
  object q2: TEdit
    Left = 248
    Top = 240
    Width = 81
    Height = 21
    TabOrder = 27
    Text = '-120'
  end
  object q3: TEdit
    Left = 248
    Top = 280
    Width = 81
    Height = 21
    TabOrder = 28
    Text = '390'
  end
  object tmr: TTimer
    Interval = 80
    OnTimer = tmrTimer
    Left = 24
    Top = 216
  end
end
