object DMCadTomador: TDMCadTomador
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 310
  Top = 178
  Height = 352
  Width = 592
  object sdsTomador: TSQLDataSet
    NoMetadata = True
    GetMetadata = False
    CommandText = 'SELECT * FROM TOMADOR'#13#10
    MaxBlobSize = -1
    Params = <>
    SQLConnection = dmDatabase.scoPrincipal
    Left = 48
    Top = 40
    object sdsTomadorID_TOMADOR: TIntegerField
      FieldName = 'ID_TOMADOR'
      Required = True
    end
    object sdsTomadorID_FILIAL: TIntegerField
      FieldName = 'ID_FILIAL'
    end
    object sdsTomadorNOME: TStringField
      FieldName = 'NOME'
      Size = 100
    end
    object sdsTomadorENDERECO: TStringField
      FieldName = 'ENDERECO'
      Size = 100
    end
    object sdsTomadorNUMERO: TStringField
      FieldName = 'NUMERO'
      Size = 10
    end
    object sdsTomadorCOMPLEMENTO: TStringField
      FieldName = 'COMPLEMENTO'
      Size = 50
    end
    object sdsTomadorBAIRRO: TStringField
      FieldName = 'BAIRRO'
      Size = 100
    end
    object sdsTomadorCIDADE: TStringField
      FieldName = 'CIDADE'
      Size = 100
    end
    object sdsTomadorESTADO: TStringField
      FieldName = 'ESTADO'
      FixedChar = True
      Size = 10
    end
    object sdsTomadorCEP: TStringField
      FieldName = 'CEP'
      Size = 10
    end
    object sdsTomadorDOCUMENTO: TStringField
      FieldName = 'DOCUMENTO'
      Size = 18
    end
    object sdsTomadorFPAS: TIntegerField
      FieldName = 'FPAS'
    end
    object sdsTomadorSTATUS: TStringField
      FieldName = 'STATUS'
      FixedChar = True
      Size = 1
    end
  end
  object cdsTomador: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspTomador'
    Left = 112
    Top = 40
    object cdsTomadorID_TOMADOR: TIntegerField
      DisplayLabel = 'Cod.Tomador'
      FieldName = 'ID_TOMADOR'
      Required = True
    end
    object cdsTomadorID_FILIAL: TIntegerField
      DisplayLabel = 'Cod.Filial'
      FieldName = 'ID_FILIAL'
    end
    object cdsTomadorNOME: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'NOME'
      Size = 100
    end
    object cdsTomadorENDERECO: TStringField
      DisplayLabel = 'Endere'#231'o'
      FieldName = 'ENDERECO'
      Size = 100
    end
    object cdsTomadorNUMERO: TStringField
      DisplayLabel = 'Nro'
      FieldName = 'NUMERO'
      Size = 10
    end
    object cdsTomadorCOMPLEMENTO: TStringField
      DisplayLabel = 'Complemento'
      FieldName = 'COMPLEMENTO'
      Size = 50
    end
    object cdsTomadorBAIRRO: TStringField
      DisplayLabel = 'Bairro'
      FieldName = 'BAIRRO'
      Size = 100
    end
    object cdsTomadorCIDADE: TStringField
      DisplayLabel = 'Cidade'
      FieldName = 'CIDADE'
      Size = 100
    end
    object cdsTomadorESTADO: TStringField
      DisplayLabel = 'UF'
      FieldName = 'ESTADO'
      FixedChar = True
      Size = 10
    end
    object cdsTomadorCEP: TStringField
      DisplayLabel = 'Cep'
      FieldName = 'CEP'
      Size = 10
    end
    object cdsTomadorDOCUMENTO: TStringField
      DisplayLabel = 'Documento'
      FieldName = 'DOCUMENTO'
      Size = 18
    end
    object cdsTomadorFPAS: TIntegerField
      DisplayLabel = 'Fpas'
      FieldName = 'FPAS'
    end
    object cdsTomadorsdsTomadorDiasTrabalhados: TDataSetField
      FieldName = 'sdsTomadorDiasTrabalhados'
    end
    object cdsTomadorSTATUS: TStringField
      FieldName = 'STATUS'
      FixedChar = True
      Size = 1
    end
  end
  object dspTomador: TDataSetProvider
    DataSet = sdsTomador
    Left = 80
    Top = 40
  end
  object dsTomador: TDataSource
    DataSet = cdsTomador
    Left = 144
    Top = 40
  end
  object dsMestre: TDataSource
    DataSet = sdsTomador
    Left = 56
    Top = 96
  end
  object sdsTomadorDiasTrabalhados: TSQLDataSet
    NoMetadata = True
    GetMetadata = False
    CommandText = 
      'SELECT * FROM TOMADOR_DIAS_TRABALHADOS'#13#10'WHERE ID_TOMADOR = :ID_T' +
      'OMADOR'#13#10'ORDER BY ANO, MES DESC'
    DataSource = dsMestre
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_TOMADOR'
        ParamType = ptInput
      end>
    SQLConnection = dmDatabase.scoPrincipal
    Left = 48
    Top = 152
    object sdsTomadorDiasTrabalhadosMES: TStringField
      FieldName = 'MES'
      FixedChar = True
      Size = 10
    end
    object sdsTomadorDiasTrabalhadosANO: TSmallintField
      FieldName = 'ANO'
    end
    object sdsTomadorDiasTrabalhadosID_TOMADOR: TIntegerField
      FieldName = 'ID_TOMADOR'
    end
    object sdsTomadorDiasTrabalhadosDIAS: TIntegerField
      FieldName = 'DIAS'
    end
    object sdsTomadorDiasTrabalhadosVALOR_VA: TFMTBCDField
      FieldName = 'VALOR_VA'
      Precision = 15
      Size = 2
    end
    object sdsTomadorDiasTrabalhadosPERC_VA: TFMTBCDField
      FieldName = 'PERC_VA'
      Precision = 15
      Size = 2
    end
    object sdsTomadorDiasTrabalhadosVALOR_LANCHE: TFMTBCDField
      FieldName = 'VALOR_LANCHE'
      Precision = 15
      Size = 2
    end
  end
  object cdsTomadorDiasTrabalhados: TClientDataSet
    Aggregates = <>
    DataSetField = cdsTomadorsdsTomadorDiasTrabalhados
    Params = <>
    Left = 80
    Top = 152
    object cdsTomadorDiasTrabalhadosMES: TStringField
      DisplayLabel = 'M'#234's'
      FieldName = 'MES'
      FixedChar = True
      Size = 10
    end
    object cdsTomadorDiasTrabalhadosANO: TSmallintField
      DisplayLabel = 'Ano'
      FieldName = 'ANO'
    end
    object cdsTomadorDiasTrabalhadosID_TOMADOR: TIntegerField
      DisplayLabel = 'Cod.Tomador'
      FieldName = 'ID_TOMADOR'
    end
    object cdsTomadorDiasTrabalhadosDIAS: TIntegerField
      DisplayLabel = 'Dias'
      FieldName = 'DIAS'
    end
    object cdsTomadorDiasTrabalhadosVALOR_VA: TFMTBCDField
      DisplayLabel = 'Valor VA'
      FieldName = 'VALOR_VA'
      DisplayFormat = '##0.00'
      Precision = 15
      Size = 2
    end
    object cdsTomadorDiasTrabalhadosPERC_VA: TFMTBCDField
      DisplayLabel = '% VA'
      FieldName = 'PERC_VA'
      DisplayFormat = '##0.00'
      Precision = 15
      Size = 2
    end
    object cdsTomadorDiasTrabalhadosVALOR_LANCHE: TFMTBCDField
      DisplayLabel = 'Valor Lanche'
      FieldName = 'VALOR_LANCHE'
      DisplayFormat = '##0.00'
      Precision = 15
      Size = 2
    end
  end
  object dsTomadorDiasTrabalhados: TDataSource
    DataSet = cdsTomadorDiasTrabalhados
    Left = 112
    Top = 152
  end
  object sdsConsulta: TSQLDataSet
    NoMetadata = True
    GetMetadata = False
    CommandText = 'SELECT * FROM TOMADOR'#13#10'WHERE 0=0'#13#10
    MaxBlobSize = -1
    Params = <>
    SQLConnection = dmDatabase.scoPrincipal
    Left = 248
    Top = 40
    object IntegerField1: TIntegerField
      FieldName = 'ID_TOMADOR'
      Required = True
    end
    object IntegerField2: TIntegerField
      FieldName = 'ID_FILIAL'
    end
    object StringField1: TStringField
      FieldName = 'NOME'
      Size = 100
    end
    object StringField2: TStringField
      FieldName = 'ENDERECO'
      Size = 100
    end
    object StringField3: TStringField
      FieldName = 'NUMERO'
      Size = 10
    end
    object StringField4: TStringField
      FieldName = 'COMPLEMENTO'
      Size = 50
    end
    object StringField5: TStringField
      FieldName = 'BAIRRO'
      Size = 100
    end
    object StringField6: TStringField
      FieldName = 'CIDADE'
      Size = 100
    end
    object StringField7: TStringField
      FieldName = 'ESTADO'
      FixedChar = True
      Size = 10
    end
    object StringField8: TStringField
      FieldName = 'CEP'
      Size = 10
    end
    object StringField9: TStringField
      FieldName = 'DOCUMENTO'
      Size = 18
    end
    object IntegerField3: TIntegerField
      FieldName = 'FPAS'
    end
    object sdsConsultaSTATUS: TStringField
      FieldName = 'STATUS'
      FixedChar = True
      Size = 1
    end
  end
  object cdsConsulta: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspConsulta'
    Left = 312
    Top = 40
    object cdsConsultaID_FILIAL: TIntegerField
      DisplayLabel = 'Cod.Filial'
      FieldName = 'ID_FILIAL'
    end
    object cdsConsultaID_TOMADOR: TIntegerField
      DisplayLabel = 'Cod.Tomador'
      FieldName = 'ID_TOMADOR'
      Required = True
    end
    object cdsConsultaNOME: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'NOME'
      Size = 100
    end
    object cdsConsultaENDERECO: TStringField
      DisplayLabel = 'Endere'#231'o'
      FieldName = 'ENDERECO'
      Size = 100
    end
    object cdsConsultaNUMERO: TStringField
      DisplayLabel = 'N'#250'mero'
      FieldName = 'NUMERO'
      Size = 10
    end
    object cdsConsultaCOMPLEMENTO: TStringField
      DisplayLabel = 'Compl'
      FieldName = 'COMPLEMENTO'
      Size = 50
    end
    object cdsConsultaBAIRRO: TStringField
      DisplayLabel = 'Bairro'
      FieldName = 'BAIRRO'
      Size = 100
    end
    object cdsConsultaCIDADE: TStringField
      DisplayLabel = 'Cidade'
      FieldName = 'CIDADE'
      Size = 100
    end
    object cdsConsultaESTADO: TStringField
      DisplayLabel = 'UF'
      FieldName = 'ESTADO'
      FixedChar = True
      Size = 10
    end
    object cdsConsultaCEP: TStringField
      FieldName = 'CEP'
      EditMask = '99999-999;0;'
      Size = 10
    end
    object cdsConsultaDOCUMENTO: TStringField
      DisplayLabel = 'Documento'
      FieldName = 'DOCUMENTO'
      Size = 18
    end
    object cdsConsultaFPAS: TIntegerField
      FieldName = 'FPAS'
    end
    object cdsConsultaSTATUS: TStringField
      FieldName = 'STATUS'
      FixedChar = True
      Size = 1
    end
  end
  object dspConsulta: TDataSetProvider
    DataSet = sdsConsulta
    Left = 280
    Top = 40
  end
  object dsConsulta: TDataSource
    DataSet = cdsConsulta
    Left = 344
    Top = 40
  end
  object qTomador: TSQLQuery
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftInteger
        Name = 'ID_TOMADOR'
        ParamType = ptInput
      end>
    SQL.Strings = (
      'SELECT ID_TOMADOR, NOME FROM TOMADOR'
      'WHERE ID_TOMADOR = :ID_TOMADOR')
    SQLConnection = dmDatabase.scoPrincipal
    Left = 440
    Top = 136
    object qTomadorID_TOMADOR: TIntegerField
      FieldName = 'ID_TOMADOR'
      Required = True
    end
    object qTomadorNOME: TStringField
      FieldName = 'NOME'
      Size = 100
    end
  end
  object qTomador_Dias: TSQLQuery
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftSmallint
        Name = 'ANO'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'MES'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'ID_TOMADOR'
        ParamType = ptInput
      end>
    SQL.Strings = (
      
        'select T.ID_TOMADOR, T.NOME, TT.DIAS, TT.VALOR_VA, TT.PERC_VA, T' +
        'T.VALOR_LANCHE'
      'from TOMADOR T'
      
        'inner join TOMADOR_DIAS_TRABALHADOS TT on T.ID_TOMADOR = TT.ID_T' +
        'OMADOR'
      'where TT.ANO = :ANO and'
      '      TT.MES = :MES and'
      '      TT.ID_TOMADOR = :ID_TOMADOR')
    SQLConnection = dmDatabase.scoPrincipal
    Left = 440
    Top = 192
    object qTomador_DiasID_TOMADOR: TIntegerField
      FieldName = 'ID_TOMADOR'
      Required = True
    end
    object qTomador_DiasNOME: TStringField
      FieldName = 'NOME'
      Size = 100
    end
    object qTomador_DiasDIAS: TIntegerField
      FieldName = 'DIAS'
    end
    object qTomador_DiasVALOR_VA: TFMTBCDField
      FieldName = 'VALOR_VA'
      Precision = 15
      Size = 2
    end
    object qTomador_DiasPERC_VA: TFMTBCDField
      FieldName = 'PERC_VA'
      Precision = 15
      Size = 2
    end
    object qTomador_DiasVALOR_LANCHE: TFMTBCDField
      FieldName = 'VALOR_LANCHE'
      Precision = 15
      Size = 2
    end
  end
end