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
  object fdQuery: TFDQuery
    Connection = fdConnection
    FetchOptions.AssignedValues = [evRowsetSize, evCursorKind]
    FetchOptions.RowsetSize = 100000
    ResourceOptions.AssignedValues = [rvSilentMode]
    Left = 400
    Top = 192
  end
end
