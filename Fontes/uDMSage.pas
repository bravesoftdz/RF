unit uDMSage;

interface

uses
  SysUtils, Classes, FMTBcd, DBClient, Provider, DB, SqlExpr;

type
  TDMSage = class(TDataModule)
    sdsTomadorSage: TSQLDataSet;
    dspTomadorSage: TDataSetProvider;
    cdsTomadorSage: TClientDataSet;
    sdsTomadorSagecd_empresa: TSmallintField;
    sdsTomadorSagecd_tomador: TSmallintField;
    sdsTomadorSagenome: TStringField;
    sdsTomadorSageendereco: TStringField;
    sdsTomadorSagenr_endereco: TIntegerField;
    sdsTomadorSagecompl_endereco: TStringField;
    sdsTomadorSagebairro: TStringField;
    sdsTomadorSagecidade: TStringField;
    sdsTomadorSageestado: TStringField;
    sdsTomadorSagecep: TIntegerField;
    sdsTomadorSagecgc: TStringField;
    sdsTomadorSagecodigo_cei: TStringField;
    sdsTomadorSageobservacao: TStringField;
    sdsTomadorSagecodigo_fpas: TSmallintField;
    sdsTomadorSagecodigo_terceiros: TSmallintField;
    sdsTomadorSagealiq_sat: TFloatField;
    sdsTomadorSagecnae: TIntegerField;
    sdsTomadorSageobra_construcao_civil: TStringField;
    sdsTomadorSagetipo_obra: TSmallintField;
    sdsTomadorSageMatriz: TStringField;
    sdsTomadorSagecd_filial: TSmallintField;
    sdsTomadorSagecodigo_pagamento_gps: TIntegerField;
    sdsTomadorSagecd_municipio: TIntegerField;
    sdsTomadorSagestatus: TStringField;
    sdsTomadorSagetipo_logradouro: TStringField;
    sdsTomadorSageesocial_tipo_tomador: TIntegerField;
    sdsTomadorSageesocial_tipo_obra: TIntegerField;
    sdsTomadorSageesocial_cno: TStringField;
    sdsTomadorSageesocial_nr_documento_contratant: TStringField;
    sdsTomadorSageesocial_nr_documento_proprietar: TStringField;
    sdsTomadorSagealiq_fpas: TFloatField;
    sdsTomadorSagealiq_fpas_prolabore: TFloatField;
    sdsTomadorSagealiq_fap: TFloatField;
    sdsTomadorSagealiq_terceiros: TFloatField;
    sdsTomadorSagealiq_sest: TFloatField;
    sdsTomadorSagecd_pagamento_inss_cnpj: TIntegerField;
    sdsTomadorSagecd_pagto_inss_cnpj_outras_ent: TIntegerField;
    sdsTomadorSagesujeita_a_desoneracao: TStringField;
    sdsTomadorSagealiq_senat: TFloatField;
    sdsTomadorSageid_esocial: TStringField;
    cdsTomadorSagecd_empresa: TSmallintField;
    cdsTomadorSagecd_tomador: TSmallintField;
    cdsTomadorSagenome: TStringField;
    cdsTomadorSageendereco: TStringField;
    cdsTomadorSagenr_endereco: TIntegerField;
    cdsTomadorSagecompl_endereco: TStringField;
    cdsTomadorSagebairro: TStringField;
    cdsTomadorSagecidade: TStringField;
    cdsTomadorSageestado: TStringField;
    cdsTomadorSagecep: TIntegerField;
    cdsTomadorSagecgc: TStringField;
    cdsTomadorSagecodigo_cei: TStringField;
    cdsTomadorSageobservacao: TStringField;
    cdsTomadorSagecodigo_fpas: TSmallintField;
    cdsTomadorSagecodigo_terceiros: TSmallintField;
    cdsTomadorSagealiq_sat: TFloatField;
    cdsTomadorSagecnae: TIntegerField;
    cdsTomadorSageobra_construcao_civil: TStringField;
    cdsTomadorSagetipo_obra: TSmallintField;
    cdsTomadorSageMatriz: TStringField;
    cdsTomadorSagecd_filial: TSmallintField;
    cdsTomadorSagecodigo_pagamento_gps: TIntegerField;
    cdsTomadorSagecd_municipio: TIntegerField;
    cdsTomadorSagestatus: TStringField;
    cdsTomadorSagetipo_logradouro: TStringField;
    cdsTomadorSageesocial_tipo_tomador: TIntegerField;
    cdsTomadorSageesocial_tipo_obra: TIntegerField;
    cdsTomadorSageesocial_cno: TStringField;
    cdsTomadorSageesocial_nr_documento_contratant: TStringField;
    cdsTomadorSageesocial_nr_documento_proprietar: TStringField;
    cdsTomadorSagealiq_fpas: TFloatField;
    cdsTomadorSagealiq_fpas_prolabore: TFloatField;
    cdsTomadorSagealiq_fap: TFloatField;
    cdsTomadorSagealiq_terceiros: TFloatField;
    cdsTomadorSagealiq_sest: TFloatField;
    cdsTomadorSagecd_pagamento_inss_cnpj: TIntegerField;
    cdsTomadorSagecd_pagto_inss_cnpj_outras_ent: TIntegerField;
    cdsTomadorSagesujeita_a_desoneracao: TStringField;
    cdsTomadorSagealiq_senat: TFloatField;
    cdsTomadorSageid_esocial: TStringField;
    dspEmpresa: TDataSetProvider;
    cdsEmpresa: TClientDataSet;
    dsEmpresa: TDataSource;
    sdsEmpresa: TSQLDataSet;
    sdsEmpresacd_empresa: TIntegerField;
    sdsEmpresarazao: TStringField;
    sdsEmpresacnpj_cpf: TStringField;
    cdsEmpresacd_empresa: TIntegerField;
    cdsEmpresarazao: TStringField;
    cdsEmpresacnpj_cpf: TStringField;
    sdsValeTransporte: TSQLDataSet;
    dspValeTransporte: TDataSetProvider;
    cdsValeTransporte: TClientDataSet;
    sdsValeRefeicao: TSQLDataSet;
    dspValeRefeicao: TDataSetProvider;
    cdsValeRefeicao: TClientDataSet;
    sdsValeTransportecd_funcionario: TIntegerField;
    sdsValeTransportecd_linha: TSmallintField;
    sdsValeTransporteqt_dia_util: TSmallintField;
    sdsValeTransporteqt_sabado: TSmallintField;
    sdsValeTransporteqt_domingo: TSmallintField;
    sdsValeTransporteqt_feriado: TSmallintField;
    sdsValeTransportevl_vale: TFloatField;
    sdsValeTransportedescricao: TStringField;
    cdsValeTransportecd_funcionario: TIntegerField;
    cdsValeTransportecd_linha: TSmallintField;
    cdsValeTransporteqt_dia_util: TSmallintField;
    cdsValeTransporteqt_sabado: TSmallintField;
    cdsValeTransporteqt_domingo: TSmallintField;
    cdsValeTransporteqt_feriado: TSmallintField;
    cdsValeTransportevl_vale: TFloatField;
    cdsValeTransportedescricao: TStringField;
    sdsValeTransportenome: TStringField;
    cdsValeTransportenome: TStringField;
    sdsValeTransportecd_empresa: TSmallintField;
    sdsValeTransportecd_tomador: TIntegerField;
    cdsValeTransportecd_empresa: TSmallintField;
    cdsValeTransportecd_tomador: TIntegerField;
    sdsValeRefeicaocd_funcionario: TIntegerField;
    sdsValeRefeicaocd_vale: TSmallintField;
    sdsValeRefeicaoqt_dia_util: TSmallintField;
    sdsValeRefeicaodescricao: TStringField;
    sdsValeRefeicaovl_vale: TFloatField;
    sdsValeRefeicaonome: TStringField;
    sdsValeRefeicaocd_empresa: TSmallintField;
    sdsValeRefeicaocd_tomador: TIntegerField;
    cdsValeRefeicaocd_funcionario: TIntegerField;
    cdsValeRefeicaonome: TStringField;
    cdsValeRefeicaocd_vale: TSmallintField;
    cdsValeRefeicaoqt_dia_util: TSmallintField;
    cdsValeRefeicaodescricao: TStringField;
    cdsValeRefeicaovl_vale: TFloatField;
    cdsValeRefeicaocd_empresa: TSmallintField;
    cdsValeRefeicaocd_tomador: TIntegerField;
    sdsFuncionario: TSQLDataSet;
    dspFuncionario: TDataSetProvider;
    cdsFuncionario: TClientDataSet;
    sdsFuncionariocd_empresa: TSmallintField;
    sdsFuncionariocd_funcionario: TIntegerField;
    sdsFuncionarionome: TStringField;
    sdsFuncionarioendereco: TStringField;
    sdsFuncionarionr_endereco: TIntegerField;
    sdsFuncionariocompl_endereco: TStringField;
    sdsFuncionariobairro: TStringField;
    sdsFuncionariocidade: TStringField;
    sdsFuncionarioestado: TStringField;
    sdsFuncionariocep: TIntegerField;
    sdsFuncionariosexo: TStringField;
    sdsFuncionarioestado_civil: TSmallintField;
    sdsFuncionariodt_admissao: TSQLTimeStampField;
    cdsFuncionariocd_empresa: TSmallintField;
    cdsFuncionariocd_funcionario: TIntegerField;
    cdsFuncionarionome: TStringField;
    cdsFuncionarioendereco: TStringField;
    cdsFuncionarionr_endereco: TIntegerField;
    cdsFuncionariocompl_endereco: TStringField;
    cdsFuncionariobairro: TStringField;
    cdsFuncionariocidade: TStringField;
    cdsFuncionarioestado: TStringField;
    cdsFuncionariocep: TIntegerField;
    cdsFuncionariosexo: TStringField;
    cdsFuncionarioestado_civil: TSmallintField;
    cdsFuncionariodt_admissao: TSQLTimeStampField;
    sdsMovimentoFolha: TSQLDataSet;
    sdsMovimentoFolhacd_empresa: TSmallintField;
    sdsMovimentoFolhacd_funcionario: TIntegerField;
    sdsMovimentoFolhames: TSmallintField;
    sdsMovimentoFolhaano: TSmallintField;
    sdsMovimentoFolhavalor_total: TFloatField;
    dspMovimentoFolha: TDataSetProvider;
    cdsMovimentoFolha: TClientDataSet;
    cdsMovimentoFolhacd_empresa: TSmallintField;
    cdsMovimentoFolhacd_funcionario: TIntegerField;
    cdsMovimentoFolhames: TSmallintField;
    cdsMovimentoFolhaano: TSmallintField;
    cdsMovimentoFolhavalor_total: TFloatField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    ctTomadorSage : String;
    ctProcEvento  : string;
    ctValeTransporte : String;
    ctValeRefeicao : string;
    procedure prc_Abrir_Tomador_Sage(ID_Filial : Integer);
    procedure prc_Abrir_Vale_Transporte(ID_Empresa, ID_Tomador : Integer); overload;
    procedure prc_Abrir_Vale_Refeicao(ID_Empresa, ID_Tomador : Integer);
    procedure prc_Abrir_Funcionario_Sage;
    procedure prc_Abrir_Movimento_Folha(ID_Filial, Ano : Integer; Mes : String);
    { Public declarations }
  end;

var
  DMSage: TDMSage;

implementation

uses
  DmdDatabase, uUtilPadrao;

{$R *.dfm}

procedure TDMSage.DataModuleCreate(Sender: TObject);
begin
  ctTomadorSage := sdsTomadorSage.CommandText;
  ctValeTransporte := sdsValeTransporte.CommandText;
  ctValeRefeicao := sdsValeRefeicao.CommandText;
end;

procedure TDMSage.prc_Abrir_Funcionario_Sage;
begin
  cdsFuncionario.Close;
//  sdsTomadorSage.CommandText := ctTomadorSage + ' where cd_empresa = ' + IntToStr(vFilial);
  cdsFuncionario.Open;
end;

procedure TDMSage.prc_Abrir_Movimento_Folha(ID_Filial, Ano: Integer;
  Mes: String);
var
  vSql : String;
begin
  cdsMovimentoFolha.Close;
  vSql := 'SELECT pro.cd_empresa, pro.cd_funcionario, pro.mes,';
  vSql := vSql + ' pro.ano,SUM(case when eve.tp_evento = ' + QuotedStr('V')+ ' then pro.valor else -pro.valor end) valor_total';
  vSql := vSql + ' FROM ProcEvento pro inner join Eventog eve on pro.cd_evento = eve.cd_evento ';
  vSql := vSql + ' where pro.cd_empresa = ' + IntToStr(ID_Filial);
  vSql := vSql + ' and pro.mes = ' + Mes;
  vSql := vSql + ' and pro.ano = ' + IntToStr(Ano);
  vSql := vSql + ' group by pro.cd_empresa, pro.cd_funcionario, pro.mes,pro.ano';
  vSql := vSql + ' order by pro.cd_funcionario, pro.mes';
  sdsMovimentoFolha.CommandText := vSql;
  cdsMovimentoFolha.Open;
end;

procedure TDMSage.prc_Abrir_Tomador_Sage(ID_Filial : Integer);
begin
  cdsTomadorSage.Close;
  if ID_Filial <> 0 then
    sdsTomadorSage.CommandText := ctTomadorSage + ' where cd_empresa = ' + IntToStr(ID_Filial);
  cdsTomadorSage.Open;
end;


procedure TDMSage.prc_Abrir_Vale_Refeicao(ID_Empresa, ID_Tomador : Integer);
var
  vSql : String;
begin
  cdsValeRefeicao.Close;
  vSql :=  ' WHERE FT.CD_EMPRESA = ' + IntToStr(ID_Empresa) + ' AND FC.CD_EMPRESA = ' + IntToStr(ID_Empresa);
  vSql := vSql + ' AND FT.DT_LOTACAO = (SELECT MAX(DT_LOTACAO) FROM FUNTOMADOR FT1 WHERE FT.CD_FUNCIONARIO = FT1.CD_FUNCIONARIO) ';
  vSql := vSql + ' AND FT.CD_TOMADOR = ' + IntToStr(ID_Tomador) + ' AND FT.CD_EMPRESA = ' + IntToStr(ID_Empresa);
  vSql := vSql + ' AND VR.CD_EMPRESA = ' + IntToStr(ID_Empresa);;
  vSql := vSql + ' ORDER BY VR.CD_FUNCIONARIO';
  sdsValeRefeicao.CommandText := ctValeRefeicao + vSql;
  cdsValeRefeicao.Open;
end;

procedure TDMSage.prc_Abrir_Vale_Transporte(ID_Empresa, ID_Tomador : Integer);
var
  vSql : String;
begin
  cdsValeTransporte.Close;
  vSql :=  ' WHERE FT.CD_EMPRESA = ' + IntToStr(ID_Empresa) + ' AND fc.CD_EMPRESA = ' + IntToStr(ID_Empresa);
  vSql := vSql + ' AND ft.dt_lotacao = (select max(dt_lotacao) from funtomador ft1 where ft.cd_funcionario = ft1.cd_funcionario) ';
  vSql := vSql + ' AND ft.cd_tomador = ' + IntToStr(ID_Tomador) + ' AND ft.cd_empresa = ' + IntToStr(ID_Empresa);
  vSql := vSql + ' and fun.cd_empresa = ' + IntToStr(ID_Empresa);;
  vSql := vSql + ' order by fun.cd_funcionario';
  sdsValeTransporte.CommandText := ctValeTransporte + vSql;
  cdsValeTransporte.Open;
end;

end.
