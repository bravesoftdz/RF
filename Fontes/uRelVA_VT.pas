unit uRelVA_VT;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, SMDBGrid, ComCtrls, ToolEdit, uDMCadTomador,
  StdCtrls, Mask, CurrEdit, RxLookup, Buttons, USel_Tomador, rsDBUtils,
  NxCollection, DB, DBClient, uDMSage, frxExportPDF, frxExportMail,
  uDMCadFuncionario;

type
  TEnumTipoRel = (tpValeRefeicao, tpValeTransporte, tpLiquidos);

type
  TfrmRelVA_VT = class(TForm)
    pnlCabecalho: TPanel;
    pnlPrincipal: TPanel;
    Label6: TLabel;
    ComboEmpresa: TRxDBLookupCombo;
    Label1: TLabel;
    ComboMes: TComboBox;
    edtAno: TCurrencyEdit;
    Label2: TLabel;
    DateEditReferencia: TDateEdit;
    ProgressBar1: TProgressBar;
    Label3: TLabel;
    edtTomador: TEdit;
    edtNomeTomador: TEdit;
    btnConsultaTomador: TBitBtn;
    btnConsultar: TNxButton;
    btnImprimir: TNxButton;
    rdgTipoImpressa: TRadioGroup;
    SMDBGrid2: TSMDBGrid;
    dsLocal: TDataSource;
    btnEnviaEmail: TNxButton;
    procedure btnConsultaTomadorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure rdgTipoImpressaExit(Sender: TObject);
    procedure edtTomadorExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnImprimirClick(Sender: TObject);
    procedure edtTomadorChange(Sender: TObject);
    procedure btnEnviaEmailClick(Sender: TObject);
    procedure edtTomadorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    fDMCadTomador: TDMCadTomador;
    fDMCadFuncionario: TDMFuncionario;
    fDMSage: TDMSage;
    procedure prc_Montar_VR;
    procedure prc_Montar_VT;
    procedure prc_Montar_Relatorio;
    procedure prc_Montar_Liquidos;
    function fnc_Retorna_Dias_Adicionais(Tipo: string; ID_Funcionario, ID_Filial: Integer): double;
    function fnc_Retorna_Dias_Faltas(Tipo_Desconto, Tipo: string; ID_Funcionario, ID_Filial: Integer): double;
    { Private declarations }
  public
    vMes: string;
    vAno: string;
    frmSel_Tomador: TfrmSel_Tomador;
    { Public declarations }
  end;

var
  ffrmRelVA_VT: TfrmRelVA_VT;
  ffrmSel_Tomador: TfrmSel_Tomador;

implementation

uses
  uUtilPadrao, classe.imprimir, classe.validaemail;

{$R *.dfm}

procedure TfrmRelVA_VT.btnConsultaTomadorClick(Sender: TObject);
begin
  if (ComboEmpresa.KeyValue = '') or (ComboEmpresa.KeyValue = null) then
  begin
    ShowMessage('Preencha o campo Empresa');
    ComboEmpresa.SetFocus;
    Exit;
  end;
  vFilial := ComboEmpresa.KeyValue;
  ffrmSel_Tomador := TfrmSel_Tomador.Create(Self);
  ffrmSel_Tomador.ShowModal;
  FreeAndNil(ffrmSel_Tomador);
  if vCod_Tomador_Pos > 0 then
    edtTomador.Text := IntToStr(vCod_Tomador_Pos);
  edtTomador.SetFocus;
end;

procedure TfrmRelVA_VT.FormShow(Sender: TObject);
begin
  fDMCadTomador := TDMCadTomador.Create(Self);
  oDBUtils.SetDataSourceProperties(Self, fDMCadTomador);
  fDMCadFuncionario := TDMFuncionario.Create(Self);
  oDBUtils.SetDataSourceProperties(Self, fDMCadFuncionario);
  fDMSage := TDMSage.Create(Self);
  oDBUtils.SetDataSourceProperties(Self, fDMSage);
  fDMSage.cdsEmpresa.Open;
  vMes := FormatDateTime('MM', Date);
  vAno := FormatDateTime('YYYY', Date);
  DateEditReferencia.Date := Date;
  ComboMes.ItemIndex := StrToInt(vMes) - 1;
  edtAno.Text := vAno;
end;

procedure TfrmRelVA_VT.btnConsultarClick(Sender: TObject);
begin
  if edtTomador.Text = '' then
  begin
    ShowMessage('Infome o tomador!');
    edtTomador.SetFocus;
    Exit;
  end;
  if ComboEmpresa.KeyValue = '' then
  begin
    ShowMessage('Infome a empresa!');
    ComboEmpresa.SetFocus;
    Exit;
  end;
  if ComboMes.Text = '' then
  begin
    ShowMessage('Infome o m�s!');
    ComboMes.SetFocus;
    Exit;
  end;
  if edtAno.Text = '' then
  begin
    ShowMessage('Infome o ano!');
    edtAno.SetFocus;
    Exit;
  end;
  if DateEditReferencia.Date < 10 then
  begin
    ShowMessage('Infome a data de refer�ncia!');
    DateEditReferencia.SelectAll;
    DateEditReferencia.SetFocus;
    Exit;
  end;
  fDMSage.cdsEmpresa.Locate('cd_empresa', ComboEmpresa.KeyValue, [loCaseInsensitive]);
  vNomeEmpresa := fDMSage.cdsEmpresarazao.AsString;

  vMes := IntToStr(ComboMes.ItemIndex + 1);

  fDMCadFuncionario.prc_Consulta_DiasAdicionais(vMes, StrToInt(vAno), ComboEmpresa.KeyValue);
  fDMCadFuncionario.prc_Consulta_Faltas(vMes, StrToInt(vAno), ComboEmpresa.KeyValue);
  fDMCadTomador.prc_Posiciona_Tomador_Dia(edtAno.AsInteger, vMes, StrToInt(edtTomador.Text),ComboEmpresa.KeyValue);
  fDMSage.prc_Abrir_Vale_Transporte(ComboEmpresa.KeyValue, StrToInt(edtTomador.Text));
  fDMSage.prc_Abrir_Vale_Refeicao(ComboEmpresa.KeyValue, StrToInt(edtTomador.Text));
  fDMCadTomador.cdsVTVA.EmptyDataSet;
  fDMCadTomador.mVTAuxiliar.EmptyDataSet;
  fDMCadTomador.mVRAuxiliar.EmptyDataSet;
  fDMCadTomador.cdsLiquidos.EmptyDataSet;
  case TEnumTipoRel(rdgTipoImpressa.ItemIndex) of
    tpValeRefeicao:
      begin
        dsLocal.DataSet := fDMCadTomador.cdsVTVA;
        prc_Montar_VR;
      end;
    tpValeTransporte:
      begin
        dsLocal.DataSet := fDMCadTomador.cdsVTVA;
        prc_Montar_VT;
      end;
    tpLiquidos:
    begin
      dsLocal.DataSet := fDMCadTomador.cdsLiquidos;
      prc_Montar_Liquidos;
    end;
  end;
end;

procedure TfrmRelVA_VT.rdgTipoImpressaExit(Sender: TObject);
begin
  fDMCadTomador.cdsVTVA.EmptyDataSet;
  fDMCadTomador.mVTAuxiliar.EmptyDataSet;
  fDMCadTomador.mVRAuxiliar.EmptyDataSet;
end;

procedure TfrmRelVA_VT.edtTomadorExit(Sender: TObject);
begin
  if edtTomador.Text <> '' then
  begin
    fDMCadTomador.prc_Posiciona_Tomador(StrToInt(edtTomador.Text),ComboEmpresa.KeyValue);
    edtNomeTomador.Text := fDMCadTomador.qTomadorNOME.AsString;
    if fDMCadTomador.qTomador.IsEmpty then
    begin
      ShowMessage('C�digo n�o encontrado!');
      edtTomador.SetFocus;
      exit;
    end;
  end;
end;

procedure TfrmRelVA_VT.prc_Montar_VR;
var
  i : Integer;
begin
  fDMCadTomador.cdsVTVA.EmptyDataSet;
  fDMCadTomador.mVTAuxiliar.EmptyDataSet;
  fDMCadTomador.mVRAuxiliar.EmptyDataSet;
  fDMSage.cdsValeRefeicao.First;
  while not fDMSage.cdsValeRefeicao.Eof do
  begin
    if fDMSage.cdsValeRefeicaoqt_dia_util.AsInteger > 0 then
    begin
      fDMCadTomador.cdsVTVA.Insert;
      fDMCadTomador.cdsVTVACod_Funcionario.AsInteger := fDMSage.cdsValeRefeicaocd_funcionario.AsInteger;
      fDMCadTomador.cdsVTVANome_Funcionario.AsString := fDMSage.cdsValeRefeicaonome.AsString;
      fDMCadTomador.cdsVTVAValor_Passagem.AsFloat := fDMSage.cdsValeRefeicaovl_vale.AsFloat;
      fDMCadTomador.cdsVTVAQtde_Passagem.AsFloat := fDMSage.cdsValeRefeicaoqt_dia_util.AsFloat;
//      fDMCadTomador.cdsVTVAValor_Refeicao.AsFloat := fDMCadTomador.qTomador_DiasVALOR_VA.AsFloat;
      fDMCadTomador.cdsVTVAValor_Refeicao.AsFloat := fDMSage.cdsValeRefeicaovl_vale.AsFloat;
      fDMCadTomador.cdsVTVADiasTrabalhados.AsFloat := fDMCadTomador.qTomador_DiasDIAS.AsInteger;

      fDMCadTomador.cdsVTVADiasAtestado.AsFloat := fnc_Retorna_Dias_Faltas('VT', 'A', fDMCadTomador.cdsVTVACod_Funcionario.AsInteger, ComboEmpresa.KeyValue);
      fDMCadTomador.cdsVTVADiasFalta.AsFloat := fnc_Retorna_Dias_Faltas('VT', 'F', fDMCadTomador.cdsVTVACod_Funcionario.AsInteger, ComboEmpresa.KeyValue);
      fDMCadTomador.cdsVTVADias_Adicionais.AsFloat := fnc_Retorna_Dias_Adicionais('VT', fDMCadTomador.cdsVTVACod_Funcionario.AsInteger, ComboEmpresa.KeyValue);

      fDMCadTomador.cdsVTVACod_VR.AsInteger := fDMSage.cdsValeRefeicaocd_vale.AsInteger;
      fDMCadTomador.cdsVTVANome_Refeicao.AsString := fDMSage.cdsValeRefeicaodescricao.AsString;
      fDMCadTomador.cdsVTVAPerc_Refeicao.AsFloat := fDMCadTomador.qTomador_DiasPERC_VA.AsFloat;
      fDMCadTomador.cdsVTVAMes.AsInteger := StrToInt(vMes);
      fDMCadTomador.cdsVTVAAno.AsString := vAno;
      fDMCadTomador.cdsVTVA.Post;
      if fDMCadTomador.mVRAuxiliar.Locate('cod_funcionario', fDMCadTomador.cdsVTVACod_Funcionario.AsInteger, [loCaseInsensitive]) then
        fDMCadTomador.mVRAuxiliar.Edit
      else
        fDMCadTomador.mVRAuxiliar.Insert;
      fDMCadTomador.mVRAuxiliarcod_funcionario.AsInteger := fDMSage.cdsValeRefeicaocd_funcionario.AsInteger;
      fDMCadTomador.mVRAuxiliarnome_funcionario.AsString := fDMSage.cdsValeRefeicaonome.AsString;
      fDMCadTomador.mVRAuxiliarvalor_desconto.AsFloat := fDMCadTomador.cdsVTVAValor_Total.AsFloat * (fDMCadTomador.qTomador_DiasPERC_VA.AsFloat / 100);
      fDMCadTomador.mVRAuxiliarvalor_total.AsFloat := fDMCadTomador.mVRAuxiliarvalor_total.AsFloat + fDMCadTomador.cdsVTVAValor_Total.AsFloat;
      fDMCadTomador.mVRAuxiliarmes.AsInteger := StrToInt(vMes);
      fDMCadTomador.mVRAuxiliarano.AsString := vAno;
      fDMCadTomador.mVRAuxiliarperc_refeicao.AsFloat := fDMCadTomador.qTomador_DiasPERC_VA.AsFloat;
      fDMCadTomador.mVRAuxiliardias_trabalhados.AsFloat := fDMCadTomador.cdsVTVADiasTrabalhados.AsFloat + fDMCadTomador.cdsVTVADias_Adicionais.AsFloat - fDMCadTomador.cdsVTVADiasFalta.AsFloat - fDMCadTomador.cdsVTVADiasAtestado.AsFloat;
      fDMCadTomador.mVRAuxiliar.Post;
    end;
    fDMSage.cdsValeRefeicao.Next;
  end;

  for i := 1 to SMDBGrid2.ColCount - 2 do
  begin
    if (SMDBGrid2.Columns[i].FieldName = 'Valor_Passagem') or
       (SMDBGrid2.Columns[i].FieldName = 'Qtde_Passagem') or
       (SMDBGrid2.Columns[i].FieldName = 'Mes') or
       (SMDBGrid2.Columns[i].FieldName = 'Ano') or
       (SMDBGrid2.Columns[i].FieldName = 'Nome_Linha') then
      SMDBGrid2.Columns[i].Visible := False;
  end;

end;

procedure TfrmRelVA_VT.prc_Montar_VT;
var
  i : Integer;
begin
  fDMCadTomador.cdsVTVA.EmptyDataSet;
  fDMCadTomador.mVTAuxiliar.EmptyDataSet;
  fDMCadTomador.mVRAuxiliar.EmptyDataSet;
  fDMSage.cdsValeTransporte.First;
  while not fDMSage.cdsValeTransporte.Eof do
  begin
    if fDMSage.cdsValeTransporteqt_dia_util.AsInteger > 0 then
    begin
      fDMCadTomador.cdsVTVA.Insert;
      fDMCadTomador.cdsVTVACod_Funcionario.AsInteger := fDMSage.cdsValeTransportecd_funcionario.AsInteger;
      fDMCadTomador.cdsVTVANome_Funcionario.AsString := fDMSage.cdsValeTransportenome.AsString;
      fDMCadTomador.cdsVTVAValor_Passagem.AsFloat := fDMSage.cdsValeTransportevl_vale.AsFloat;
      fDMCadTomador.cdsVTVAQtde_Passagem.AsFloat := fDMSage.cdsValeTransporteqt_dia_util.AsFloat;
      fDMCadTomador.cdsVTVADiasTrabalhados.AsFloat := fDMCadTomador.qTomador_DiasDIAS.AsInteger;

      fDMCadTomador.cdsVTVADiasAtestado.AsFloat := fnc_Retorna_Dias_Faltas('VA', 'A', fDMCadTomador.cdsVTVACod_Funcionario.AsInteger, ComboEmpresa.KeyValue);
      fDMCadTomador.cdsVTVADiasFalta.AsFloat := fnc_Retorna_Dias_Faltas('VA', 'F', fDMCadTomador.cdsVTVACod_Funcionario.AsInteger, ComboEmpresa.KeyValue);
      fDMCadTomador.cdsVTVADias_Adicionais.AsFloat := fnc_Retorna_Dias_Adicionais('VA', fDMCadTomador.cdsVTVACod_Funcionario.AsInteger, ComboEmpresa.KeyValue);

      fDMCadTomador.cdsVTVACod_Passagem.AsInteger := fDMSage.cdsValeTransportecd_linha.AsInteger;
      fDMCadTomador.cdsVTVANome_Linha.AsString := fDMSage.cdsValeTransportedescricao.AsString;
      fDMCadTomador.cdsVTVAMes.AsInteger := StrToInt(vMes);
      fDMCadTomador.cdsVTVAAno.AsString := vAno;
      fDMCadTomador.cdsVTVA.Post;
      if fDMCadTomador.mVTAuxiliar.Locate('cod_funcionario', fDMCadTomador.cdsVTVACod_Funcionario.AsInteger, [loCaseInsensitive]) then
        fDMCadTomador.mVTAuxiliar.Edit
      else
        fDMCadTomador.mVTAuxiliar.Insert;
      fDMCadTomador.mVTAuxiliarcod_funcionario.AsInteger := fDMSage.cdsValeTransportecd_funcionario.AsInteger;
      fDMCadTomador.mVTAuxiliarnome_funcionario.AsString := fDMSage.cdsValeTransportenome.AsString;
      fDMCadTomador.mVTAuxiliarvalor_total.AsFloat := fDMCadTomador.mVTAuxiliarvalor_total.AsFloat + fDMCadTomador.cdsVTVAValor_Total.AsFloat;
      fDMCadTomador.mVTAuxiliarMes.AsInteger := StrToInt(vMes);
      fDMCadTomador.mVTAuxiliarAno.AsString := vAno;
      fDMCadTomador.mVTAuxiliar.Post;
    end;
    fDMSage.cdsValeTransporte.Next;
  end;
  for i := 1 to SMDBGrid2.ColCount - 2 do
  begin
    if (SMDBGrid2.Columns[i].FieldName = 'Nome_Refeicao') or
       (SMDBGrid2.Columns[i].FieldName = 'Valor_Refeicao') or
       (SMDBGrid2.Columns[i].FieldName = 'Mes') or
       (SMDBGrid2.Columns[i].FieldName = 'Ano') or
       (SMDBGrid2.Columns[i].FieldName = 'Perc_Refeicao') then
      SMDBGrid2.Columns[i].Visible := False;
  end;
end;

procedure TfrmRelVA_VT.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmRelVA_VT.btnImprimirClick(Sender: TObject);
begin
  prc_Montar_Relatorio;
  fDMCadTomador.frxReport1.variables['Nome_Departamento'] := QuotedStr(fDMCadTomador.qTomadorNOME.AsString);
  fDMCadTomador.frxReport1.ShowReport;
  fDMCadTomador.cdsVTVA.Filtered := False;
end;

procedure TfrmRelVA_VT.edtTomadorChange(Sender: TObject);
begin
  fDMCadTomador.cdsVTVA.EmptyDataSet;
  fDMCadTomador.mVTAuxiliar.EmptyDataSet;
  fDMCadTomador.mVRAuxiliar.EmptyDataSet;
end;

procedure TfrmRelVA_VT.btnEnviaEmailClick(Sender: TObject);
var
  mail: TfrxMailExport;
  pdf: TfrxPDFExport;
  vTexto: string;
begin
  prc_Montar_Relatorio;

  if fDMCadTomador.qParametrosEMAIL.AsString = '' then
  begin
    ShowMessage('Email n�o configurado nos par�metros!');
    Exit;
  end;

  fDMCadTomador.frxReport1.variables['Nome_Departamento'] := QuotedStr(fDMCadTomador.qTomadorNOME.AsString);
  mail := TfrxMailExport.Create(nil);
  pdf := TfrxPDFExport.Create(nil);
  mail.Address := '';
  case TEnumTipoRel(rdgTipoImpressa.ItemIndex) of
    tpValeRefeicao:
      vTexto := 'Vale Refei��o m�s: ' + ComboMes.Text + '/' + edtAno.Text;
    tpValeTransporte:
      vTexto := 'Vale Transporte m�s: ' + ComboMes.Text + '/' + edtAno.Text;
  end;
  mail.Subject := vTexto;
  mail.Login := fDMCadTomador.qParametrosUSUARIO.AsString;
  mail.ExportFilter := pdf;
  mail.FilterDesc := 'PFD por e-mail';
  mail.Password := fDMCadTomador.qParametrosSENHA.AsString;
  mail.Lines.Add('Segue em anexo ' + vTexto);
  mail.FromMail := fDMCadTomador.qParametrosEMAIL.AsString;
  mail.FromCompany := ComboEmpresa.Text;
  mail.SmtpHost := fDMCadTomador.qParametrosHOST.AsString;
  mail.SmtpPort := fDMCadTomador.qParametrosPORTA.AsInteger;
  mail.UseIniFile := False;
  mail.ShowExportDialog := False;
  mail.ShowDialog := fDMCadTomador.qParametrosTELA_ENVIO.AsString = 'S';
  mail.ConfurmReading := fDMCadTomador.qParametrosCONFIRMACAO_LEITURA.AsString = 'S';
  fDMCadTomador.frxReport1.PrepareReport(True);
  fDMCadTomador.frxReport1.Export(mail);
  mail.Destroy;
  fDMCadTomador.cdsVTVA.Filtered := False;
end;

procedure TfrmRelVA_VT.prc_Montar_Relatorio;
var
  Imprimir: TImprimir;
begin
  if fDMCadTomador.cdsVTVA.IsEmpty then
  begin
    ShowMessage('Nenhuma informa��o na consulta');
    exit;
  end;
  if fDMCadTomador.cdsVTVADiasTrabalhados.AsFloat <= 0 then
  begin
    ShowMessage('Tomador n�o tem dias trabalhados');
    exit;
  end;

  Imprimir := TImprimir.Create;
  try
    case TEnumTipoRel(rdgTipoImpressa.ItemIndex) of
      tpValeRefeicao:
        Imprimir.Caminho := 'Relatorios\Vale_Refeicao.fr3';
      tpValeTransporte:
        Imprimir.Caminho := 'Relatorios\Vale_Transporte.fr3';
    end;
    fDMCadTomador.frxReport1.Report.LoadFromFile(Imprimir.Caminho);
  finally
    Imprimir.Free;
  end;

end;

procedure TfrmRelVA_VT.edtTomadorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = vk_f2 then
    btnConsultaTomadorClick(Sender);
end;

function TfrmRelVA_VT.fnc_Retorna_Dias_Adicionais(Tipo: string; ID_Funcionario, ID_Filial: Integer): double;
begin
  Result := 0;
  fDMCadFuncionario.cdsDiasAdicionais.Filtered := False;
  fDMCadFuncionario.cdsDiasAdicionais.Filter := 'ID_FUNCIONARIO = ' + IntToStr(ID_Funcionario) + ' AND ID_FILIAL = ' + IntToStr(ID_Filial);
  fDMCadFuncionario.cdsDiasAdicionais.Filtered := True;
  fDMCadFuncionario.cdsDiasAdicionais.First;
  while not fDMCadFuncionario.cdsDiasAdicionais.Eof do
  begin
    if fDMCadFuncionario.cdsDiasAdicionaisTIPO_ACRESCIMO.AsString <> Tipo then
      Result := Result + fDMCadFuncionario.cdsDiasAdicionaisDIAS.AsFloat;
    fDMCadFuncionario.cdsDiasAdicionais.Next;
  end;
end;

function TfrmRelVA_VT.fnc_Retorna_Dias_Faltas(Tipo_Desconto, Tipo: string; ID_Funcionario, ID_Filial: Integer): double;
begin
  Result := 0;
  fDMCadFuncionario.cdsFaltasAtestado.Filtered := False;
  fDMCadFuncionario.cdsFaltasAtestado.Filter := 'ID_FUNCIONARIO = ' + QuotedStr(IntToStr(ID_Funcionario)) + ' AND ID_FILIAL = ' + QuotedStr(IntToStr(ID_Filial)) + ' AND TIPO = ' + QuotedStr(Tipo);
  fDMCadFuncionario.cdsFaltasAtestado.Filtered := True;
  fDMCadFuncionario.cdsFaltasAtestado.First;
  while not fDMCadFuncionario.cdsFaltasAtestado.Eof do
  begin
    if fDMCadFuncionario.cdsFaltasAtestadoTIPO_DESCONTO.AsString <> Tipo_Desconto then
      Result := Result + fDMCadFuncionario.cdsFaltasAtestadoDIAS.AsFloat;
    fDMCadFuncionario.cdsFaltasAtestado.Next;
  end;
end;

procedure TfrmRelVA_VT.prc_Montar_Liquidos;
begin
  fDMCadTomador.cdsVTVA.EmptyDataSet;
  fDMCadTomador.mVTAuxiliar.EmptyDataSet;
  fDMCadTomador.mVRAuxiliar.EmptyDataSet;
  fDMSage.cdsValeRefeicao.First;
  fDMSage.prc_Abrir_Movimento_Folha(ComboEmpresa.KeyValue,StrToInt(vAno),vMes);
  fDMSage.cdsMovimentoFolha.First;
  while not fDMSage.cdsMovimentoFolha.Eof do
  begin
    fDMCadTomador.cdsLiquidos.Insert;
    fDMCadTomador.cdsLiquidoscod_filial.AsInteger := fDMSage.cdsMovimentoFolhacd_empresa.AsInteger;
    fDMCadTomador.cdsLiquidoscod_funcionario.AsInteger := fDMSage.cdsMovimentoFolhacd_funcionario.AsInteger;
    fDMCadTomador.cdsLiquidosvalor_salario.AsFloat := fDMSage.cdsMovimentoFolhavalor_total.AsFloat;
    fDMCadTomador.cdsLiquidos.Post;
    fDMSage.cdsMovimentoFolha.Next;
  end;
end;

end.

