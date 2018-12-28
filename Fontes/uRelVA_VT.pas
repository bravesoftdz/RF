unit uRelVA_VT;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, SMDBGrid, ComCtrls, ToolEdit, uDMCadTomador,
  StdCtrls, Mask, CurrEdit, RxLookup, Buttons, USel_Tomador, rsDBUtils,
  NxCollection, DB, DBClient, uDMSage;

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
    procedure btnConsultaTomadorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure rdgTipoImpressaExit(Sender: TObject);
    procedure edtTomadorExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnImprimirClick(Sender: TObject);
    procedure edtTomadorChange(Sender: TObject);
  private
    fDMCadTomador: TDMCadTomador;
    fDMSage: TDMSage;
    procedure prc_Montar_VR;
    procedure prc_Montar_VT;
    { Private declarations }
  public
    vMes: string;
    vAno: String;
    frmSel_Tomador: TfrmSel_Tomador;
    { Public declarations }
  end;

var
  ffrmRelVA_VT: TfrmRelVA_VT;
  ffrmSel_Tomador: TfrmSel_Tomador;

implementation

uses
  uUtilPadrao;

{$R *.dfm}

procedure TfrmRelVA_VT.btnConsultaTomadorClick(Sender: TObject);
begin
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
  fDMSage := TDMSage.Create(Self);
  oDBUtils.SetDataSourceProperties(Self, fDMSage);
  fDMSage.cdsEmpresa.Open;
  vMes := FormatDateTime('MM',Date);
  vAno := FormatDateTime('YYYY',Date);
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
  fDMSage.cdsEmpresa.Locate('cd_empresa',ComboEmpresa.KeyValue,[loCaseInsensitive]);
  vNomeEmpresa := fDMSage.cdsEmpresarazao.AsString;
  vMes := IntToStr(ComboMes.ItemIndex + 1);
  fDMCadTomador.prc_Posiciona_Tomador_Dia(edtAno.AsInteger, vMes, StrToInt(edtTomador.Text));
  fDMSage.prc_Abrir_ProcEvento(ComboEmpresa.KeyValue, StrToInt(edtTomador.Text), ComboMes.ItemIndex + 1, edtAno.Text);
  fDMSage.prc_Abrir_Vale_Transporte(ComboEmpresa.KeyValue,StrToInt(edtTomador.Text));
  fDMSage.prc_Abrir_Vale_Refeicao(ComboEmpresa.KeyValue,StrToInt(edtTomador.Text));
  fDMCadTomador.cdsVTVA.EmptyDataSet;
  fDMCadTomador.mVTAuxiliar.EmptyDataSet;
  case rdgTipoImpressa.ItemIndex of
    0:
      prc_Montar_VR;
    1:
      prc_Montar_VT;
  end;
end;

procedure TfrmRelVA_VT.rdgTipoImpressaExit(Sender: TObject);
begin
  fDMCadTomador.cdsVTVA.EmptyDataSet;
  fDMCadTomador.mVTAuxiliar.EmptyDataSet;
end;

procedure TfrmRelVA_VT.edtTomadorExit(Sender: TObject);
begin
  if edtTomador.Text <> '' then
  begin
    fDMCadTomador.prc_Posiciona_Tomador(StrToInt(edtTomador.Text));
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
begin
  fDMCadTomador.cdsVTVA.EmptyDataSet;
  fDMCadTomador.mVTAuxiliar.EmptyDataSet;
  fDMSage.cdsValeRefeicao.First;
  while not fDMSage.cdsValeRefeicao.Eof do
  begin
    if fDMSage.cdsValeRefeicaoqt_dia_util.AsInteger > 0 then
    begin
      fDMCadTomador.cdsVTVA.Insert;
      fDMCadTomador.cdsVTVACod_Funcionario.AsInteger  := fDMSage.cdsValeRefeicaocd_funcionario.AsInteger;
      fDMCadTomador.cdsVTVANome_Funcionario.AsString  := fDMSage.cdsValeRefeicaonome.AsString;
      fDMCadTomador.cdsVTVAValor_Passagem.AsFloat     := fDMSage.cdsValeRefeicaovl_vale.AsFloat;
      fDMCadTomador.cdsVTVAQtde_Passagem.AsFloat      := fDMSage.cdsValeRefeicaoqt_dia_util.AsFloat;
      fDMCadTomador.cdsVTVADiasTrabalhados.AsFloat    := fDMCadTomador.qTomador_DiasDIAS.AsInteger;
      if fDMSage.cdsProcEvento.Locate('cd_funcionario;cd_evento',VarArrayOf([fDMCadTomador.cdsVTVACod_Funcionario.AsInteger,'938']),[loCaseInsensitive]) then
        fDMCadTomador.cdsVTVADiasAtestado.AsFloat     := fDMSage.cdsProcEventoreferencia.AsFloat;
      if fDMSage.cdsProcEvento.Locate('cd_funcionario;cd_evento',VarArrayOf([fDMCadTomador.cdsVTVACod_Funcionario.AsInteger,'225']),[loCaseInsensitive]) then
        fDMCadTomador.cdsVTVADiasFalta.AsFloat        := fDMSage.cdsProcEventoreferencia.AsFloat;
      fDMCadTomador.cdsVTVACod_VR.AsInteger     := fDMSage.cdsValeRefeicaocd_vale.AsInteger;
      fDMCadTomador.cdsVTVANome_Refeicao.AsString     := fDMSage.cdsValeRefeicaodescricao.AsString;
      fDMCadTomador.cdsVTVAMes.AsInteger              := StrToInt(vMes);
      fDMCadTomador.cdsVTVAAno.AsString               := vAno;
      fDMCadTomador.cdsVTVA.Post;
      if fDMCadTomador.mVTAuxiliar.Locate('cod_funcionario',fDMCadTomador.cdsVTVACod_Funcionario.AsInteger,[loCaseInsensitive]) then
        fDMCadTomador.mVTAuxiliar.Edit
      else
        fDMCadTomador.mVTAuxiliar.Insert;
      fDMCadTomador.mVTAuxiliarcod_funcionario.AsInteger := fDMSage.cdsValeRefeicaocd_funcionario.AsInteger;
      fDMCadTomador.mVTAuxiliarnome_funcionario.AsString := fDMSage.cdsValeRefeicaonome.AsString;
      fDMCadTomador.mVTAuxiliarvalor_total.AsFloat       := fDMCadTomador.mVTAuxiliarvalor_total.AsFloat + fDMCadTomador.cdsVTVAValor_Total.AsFloat;
      fDMCadTomador.mVTAuxiliarMes.AsInteger              := StrToInt(vMes);
      fDMCadTomador.mVTAuxiliarAno.AsString               := vAno;
      fDMCadTomador.mVTAuxiliar.Post;
    end;
    fDMSage.cdsValeRefeicao.Next;
  end;
end;

procedure TfrmRelVA_VT.prc_Montar_VT;
begin
  fDMCadTomador.cdsVTVA.EmptyDataSet;
  fDMCadTomador.mVTAuxiliar.EmptyDataSet;
  fDMSage.cdsValeTransporte.First;
  while not fDMSage.cdsValeTransporte.Eof do
  begin
    if fDMSage.cdsValeTransporteqt_dia_util.AsInteger > 0 then
    begin
      fDMCadTomador.cdsVTVA.Insert;
      fDMCadTomador.cdsVTVACod_Funcionario.AsInteger  := fDMSage.cdsValeTransportecd_funcionario.AsInteger;
      fDMCadTomador.cdsVTVANome_Funcionario.AsString  := fDMSage.cdsValeTransportenome.AsString;
      fDMCadTomador.cdsVTVAValor_Passagem.AsFloat     := fDMSage.cdsValeTransportevl_vale.AsFloat;
      fDMCadTomador.cdsVTVAQtde_Passagem.AsFloat      := fDMSage.cdsValeTransporteqt_dia_util.AsFloat;
      fDMCadTomador.cdsVTVADiasTrabalhados.AsFloat    := fDMCadTomador.qTomador_DiasDIAS.AsInteger;
      if fDMSage.cdsProcEvento.Locate('cd_funcionario;cd_evento',VarArrayOf([fDMCadTomador.cdsVTVACod_Funcionario.AsInteger,'938']),[loCaseInsensitive]) then
        fDMCadTomador.cdsVTVADiasAtestado.AsFloat     := fDMSage.cdsProcEventoreferencia.AsFloat;
      if fDMSage.cdsProcEvento.Locate('cd_funcionario;cd_evento',VarArrayOf([fDMCadTomador.cdsVTVACod_Funcionario.AsInteger,'225']),[loCaseInsensitive]) then
        fDMCadTomador.cdsVTVADiasFalta.AsFloat        := fDMSage.cdsProcEventoreferencia.AsFloat;
      fDMCadTomador.cdsVTVACod_Passagem.AsInteger     := fDMSage.cdsValeTransportecd_linha.AsInteger;
      fDMCadTomador.cdsVTVANome_Linha.AsString        := fDMSage.cdsValeTransportedescricao.AsString;
      fDMCadTomador.cdsVTVAMes.AsInteger              := StrToInt(vMes);
      fDMCadTomador.cdsVTVAAno.AsString               := vAno;
      fDMCadTomador.cdsVTVA.Post;
      if fDMCadTomador.mVTAuxiliar.Locate('cod_funcionario',fDMCadTomador.cdsVTVACod_Funcionario.AsInteger,[loCaseInsensitive]) then
        fDMCadTomador.mVTAuxiliar.Edit
      else
        fDMCadTomador.mVTAuxiliar.Insert;
      fDMCadTomador.mVTAuxiliarcod_funcionario.AsInteger := fDMSage.cdsValeTransportecd_funcionario.AsInteger;
      fDMCadTomador.mVTAuxiliarnome_funcionario.AsString := fDMSage.cdsValeTransportenome.AsString;
      fDMCadTomador.mVTAuxiliarvalor_total.AsFloat       := fDMCadTomador.mVTAuxiliarvalor_total.AsFloat + fDMCadTomador.cdsVTVAValor_Total.AsFloat;
      fDMCadTomador.mVTAuxiliarMes.AsInteger              := StrToInt(vMes);
      fDMCadTomador.mVTAuxiliarAno.AsString               := vAno;
      fDMCadTomador.mVTAuxiliar.Post;
    end;
    fDMSage.cdsValeTransporte.Next;
  end;
end;

procedure TfrmRelVA_VT.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmRelVA_VT.btnImprimirClick(Sender: TObject);
var
  vArq : String;
begin
  if fDMCadTomador.cdsVTVA.IsEmpty then
  begin
    ShowMessage('Nenhuma informa��o na consulta');
    exit;
  end;

  if rdgTipoImpressa.ItemIndex = 1 then
    vArq := ExtractFilePath(Application.ExeName) + 'Relatorios\Vale_Transporte.fr3'
  else
    vArq := ExtractFilePath(Application.ExeName) + 'Relatorios\Vale_Refeicao.fr3';
  if FileExists(vArq) then
    fDMCadTomador.frxReport1.Report.LoadFromFile(vArq)
  else
  begin
    ShowMessage('Relat�rio n�o localizado! ' + vArq);
    Exit;
  end;
  fDMCadTomador.frxReport1.variables['Nome_Departamento'] :=  QuotedStr(fDMCadTomador.qTomadorNOME.AsString);
  fDMCadTomador.frxReport1.ShowReport;
  fDMCadTomador.cdsVTVA.Filtered := False;
end;

procedure TfrmRelVA_VT.edtTomadorChange(Sender: TObject);
begin
  fDMCadTomador.cdsVTVA.EmptyDataSet;
  fDMCadTomador.mVTAuxiliar.EmptyDataSet;
end;

end.

