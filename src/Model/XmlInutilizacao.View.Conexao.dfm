object dmDados: TdmDados
  Height = 480
  Width = 640
  object fdConnection: TFDConnection
    LoginPrompt = False
    Left = 271
    Top = 192
  end
  object fdPgLink: TFDPhysPgDriverLink
    OnDriverCreated = fdPgLinkDriverCreated
    Left = 344
    Top = 192
  end
end
