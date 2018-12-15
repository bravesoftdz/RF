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
    SMDBGrid1: TSMDBGrid;
    Label3: TLabel;
    edtTomador: TEdit;
    edtNomeTomador: TEdit;
    btnConsultaTomador: TBitBtn;
    btnConsultar: TNxButton;
    btnImprimir: TNxButton;
    cdsVTVA: TClientDataSet;
    dsVTVA: TDataSource;
    cdsVTVACod_Funcionario: TIntegerField;
    cdsVTVANome_Funcionario: TStringField;
    cdsVTVAValor_Passagem: TFloatField;
    cdsVTVAQtde_Passagem: TFloatField;
    cdsVTVADias_Trabalhados: TIntegerField;
    cdsVTVADias_Atestado: TIntegerField;
    cdsVTVADias_Falta: TIntegerField;
    rdgTipoImpressa: TRadioGroup;
    procedure btnConsultaTomadorClick(Sender: TObject);
    procedure edtTomadorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure rdgTipoImpressaExit(Sender: TObject);
    procedure edtTomadorExit(Sender: TObject);
  private
    fDMCadTomador: TDMCadTomador;
    fDMSage: TDMSage;
    procedure prc_Montar_VR;
    procedure prc_Montar_VT;
    { Private declarations }
  public
    vMes : String;
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

procedure TfrmRelVA_VT.edtTomadorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if edtTomador.Text <> '' then
  begin
    fDMCadTomador.prc_Localizar(StrToInt(edtTomador.Text));
    edtNomeTomador.Text := fDMCadTomador.cdsTomadorNOME.AsString;
    if fDMCadTomador.cdsTomador.IsEmpty then
    begin
      ShowMessage('C�digo n�o encontrado!');
      edtTomador.SetFocus;
      exit;
    end;
  end;
end;

procedure TfrmRelVA_VT.FormShow(Sender: TObject);
begin
  fDMCadTomador := TDMCadTomador.Create(Self);
  oDBUtils.SetDataSourceProperties(Self, fDMCadTomador);
  fDMSage := TDMSage.Create(Self);
  oDBUtils.SetDataSourceProperties(Self, fDMSage);
  fDMSage.cdsEmpresa.Open;
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
  vMes := IntToStr(ComboMes.ItemIndex + 1);
  fDMCadTomador.prc_Posiciona_Tomador_Dia(edtAno.AsInteger, vMes,StrToInt(edtTomador.Text));
  fDMSage.prc_Abrir_ProcEvento(ComboEmpresa.KeyValue, StrToInt(edtTomador.Text), ComboMes.ItemIndex + 1, edtAno.Text);
  fDMSage.prc_Abrir_Vale_Transporte(ComboEmpresa.KeyValue);
  fDMSage.prc_Abrir_Vale_Refeicao(ComboEmpresa.KeyValue);
  cdsVTVA.EmptyDataSet;
  case rdgTipoImpressa.ItemIndex of
    0:
      prc_Montar_VR;
    1:
      prc_Montar_VT;
  end;

end;

procedure TfrmRelVA_VT.rdgTipoImpressaExit(Sender: TObject);
begin
  cdsVTVA.EmptyDataSet;
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
  fDMSage.cdsValeRefeicao.First;
  while not fDMSage.cdsValeTransporte.Eof do
  begin
    if fDMSage.cdsValeRefeicaoqt_dia_util.AsInteger > 0 then
    begin
      cdsVTVA.Insert;
      cdsVTVACod_Funcionario.AsInteger := fDMSage.cdsValeRefeicaocd_funcionario.AsInteger;
//      cdsVTVADias_Trabalhados
      cdsVTVA.Post;
      fDMSage.cdsValeTransporte.Next;

    end;
  end;

end;

procedure TfrmRelVA_VT.prc_Montar_VT;
begin
//
end;

end.

