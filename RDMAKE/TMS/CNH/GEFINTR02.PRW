#include "protheus.ch"

//-------------------------------------------------------------------------------------------------
/* {2LGI} GEFINTR02
@autor		: Luiz Alexandre
@descricao	: Relatorio de log de importacao
@since		: Ago./2014
@using		:
@review	:
*/
//-------------------------------------------------------------------------------------------------
User Function GEFCNHR2()

// --- Variaveis utilizadas
Local oReport
Private _cPerg	:= 'GEFINTR002'

// --- Verifica perguntas
GEF02SX1(_cPerg)

// --- Definicoes do relatorio
oReport := GEF02Def()

// --- Exibe spool
oReport:PrintDialog()

Return

//-------------------------------------------------------------------------------------------------
/* {2LGI} GEF02Def
@autor		: Luiz Alexandre
@descricao	: Relatorio de log de plano de transporte
@since		: Ago./2014
@using		:
@review	:
*/
//-------------------------------------------------------------------------------------------------
Static Function GEF02Def()

// --- Variaveis utilizadas
Local _cReport	:= 'GEFINTR02'
Local _cTitulo	:= OemToAnsi('Log de importação de Planos de transporte')
Local _cDesc	:= OemtoAnsi('Relatório de log de importação')
Local oReport
Local oSection1
Local oSection2

oReport := TReport():New(_cReport,_cTitulo,_cPerg,{|oReport| GEF02Print(oReport)},_cDesc)   
oReport:lParamPage:= .f.
oReport:SetLandscape()
oReport:DisableOrientation()


// --- Plano de transporte
oSection1 := TRSection():New(oReport,"Plano de transporte","DF0")  
TRCell():New(oSection1,"DF0_NUMAGE","DF0","Agendamento ")
TRCell():New(oSection1,"DF0_PLANID","DF0"," Plano de transp. ") 
TRCell():New(oSection1,"DF0_DATCAD","DF0") 
TRCell():New(oSection1,"DF0_STPLAN","DF0") 
TRCell():New(oSection1,"DF0_CNHID" ,"DF0") 
TRFunction():New(oSection1:Cell("DF0_PLANID"),NIL,"COUNT",NIL,NIL,NIL,NIL,.F.)   

// --- Secao de linhas do log
oSection2 := TRSection():New(oSection1,"Registro de log de importação","PA3")
TRCell():New(oSection2,"PA3_ITEM","PA3")
TRCell():New(oSection2,"PA3_WSID","PA3")
TRCell():New(oSection2,"PA3_DATPRO","PA3")
TRCell():New(oSection2,"PA3_HORPRO","PA3")
TRCell():New(oSection2,"PA3_MSGOCO","PA3")
TRCell():New(oSection2,"PA3_MSGSOL","PA3")
TRCell():New(oSection2,"PA3_USUARI","PA3")
TRFunction():New(oSection2:Cell("PA3_MSGSOL"),NIL,"COUNT")

Return oReport

//-------------------------------------------------------------------------------------------------
/* {2LGI} GEF02Print
@autor		: Luiz Alexandre
@descricao	: Relatorio de log de importacao de planos
@since		: Ago./2014
@using		:
@review	:
*/
//-------------------------------------------------------------------------------------------------
Static Function GEF02Print(oReport)

// --- Variaveis utilizadas
Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local cFiltro   := "" 
Local cAlias	:= GetNextAlias()      
Local cOrder	:= "%DF0_PLANID, PA3_DATPRO, PA3_WSID, PA3_ITEM, PA3_HORPRO%"
Local aEndQry	:= {mv_par01,mv_par02}
Local cTipo		:= ''

// ---	Define o filtro do tipo da mensagem do relatorio	
If Mv_par05 == 1
	cTipo	:= '0'
ElseIf Mv_par05 == 2
	cTipo	:= '1'
ElseIf Mv_par05	== 3
	cTipo	:= '1|0'
EndIf

cTipo := "%" + FormatIn(cTipo,"|") + "%"

// --- Transforma os parametros em expressao SQL
MakeSqlExpr(oReport:uParam)
 
// --- Inicia montagem da query
oSection1:BeginQuery()            

BeginSql alias cAlias
	SELECT
	DF0.DF0_NUMAGE,
	DF0.DF0_PLANID,
	DF0.DF0_DATCAD,
	DF0.DF0_STPLAN,
	DF0.DF0_CNHID,
	PA3.PA3_PLANID,
	PA3.PA3_ITEM,
	PA3.PA3_WSID,
	PA3.PA3_DATPRO,
	PA3.PA3_HORPRO,
	PA3.PA3_MSGOCO,
	PA3.PA3_MSGSOL,
	PA3.PA3_USUARI,
	PA3.PA3_TIPMSG
	FROM 
	%table:DF0% DF0
		INNER JOIN %table:PA3% PA3 
		ON DF0.DF0_FILIAL = PA3.PA3_FILIAL AND
		DF0.DF0_PLANID = PA3.PA3_PLANID AND
		PA3.PA3_TIPMSG IN %exp:cTipo% AND   
		PA3.D_E_L_E_T_ = ' ' 
	WHERE  
	DF0.DF0_FILIAL = %xfilial:DF0% AND
	DF0.DF0_PLANID BETWEEN %exp:mv_par01% AND %exp:mv_par02% AND
	DF0.DF0_DATCAD BETWEEN %exp:mv_par03% AND %exp:mv_par04% AND
	DF0.D_E_L_E_T_= ' ' 
	ORDER BY %exp:cOrder%
EndSql

                            
/*	Prepara relatorio para executar a query gerada pelo Embedded SQL passando como 	parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados 	pela funcao MakeSqlExpr para serem adicionados a query	*/
oSection1:EndQuery()             
oSection2:SetParentQuery(.T.)
oSection2:SetParentFilter({|cParam| (cAlias)->DF0_PLANID >= cParam .and. (cAlias)->DF0_PLANID <= cParam } ,{|| (cAlias)->PA3_PLANID })

// --- Imprime relatorio
oSection1:Print()       

// --- Fecha area temporaria
(cAlias)->(dbCloseArea())

Return

//-------------------------------------------------------------------------------------------------
/* {2LGI} GEF03SX1
@autor		: Luiz Alexandre
@descricao	: Atualiza os parametros da rotina
@since		: Ago./2014
@using		:
@review	:
*/
//-------------------------------------------------------------------------------------------------
Static Function GEF02SX1(_cPerg)
                
// --- Variaveis utilizadas
Local aArea    	:= GetArea()
Local aHelpPor 	:= {}
Local aHelpEng 	:= {}
Local aHelpEsp 	:= {}

// --- Perguntas
aHelpPor := { "Numero de plano de transporte inicial." }
aHelpEng := { "Numero de plano de transporte inicial." }
aHelpEsp := { "Numero de plano de transporte inicial." }
PutSx1(_cPerg, "01", "Plano Transp De", "Plano Transp De", "Plano Transp De", ;
"MV_CH1", "N",TamSX3("DF0_PLANID")[1], 0, 0, "G", "", "", "", "", ;
"MV_PAR01", "", "", "", "", "", "", "", "", ;
"", "", "", "N", "", "", "", "", ;
aHelpPor, aHelpEng, aHelpEsp )

// --- Perguntas
aHelpPor := { "Numero de plano de transporte final." }
aHelpEng := { "Numero de plano de transporte final." }
aHelpEsp := { "Numero de plano de transporte final." }
PutSx1(_cPerg, "02", "Plano Transp Ate", "Plano Transp Ate", "Plano Transp Ate", ;
"MV_CH2", "N",TamSX3("DF0_PLANID")[1], 0, 0, "G", "", "", "", "", ;
"MV_PAR02", "", "", "", "", "", "", "", "", ;
"", "", "", "N", "", "", "", "", ;
aHelpPor, aHelpEng, aHelpEsp )

// ---
aHelpPor := { "Informe a data inicial." }
aHelpEng := { "Informe a data inicial." }
aHelpEsp := { "Informe a data inicial." }
PutSx1(_cPerg, "03", "Data De", "Data De", "Data De", ;
"MV_CH3", "D",8, 0, 0, "G", "", "", "", "", ;
"MV_PAR03", "", "", "", "", "", "", "", "", ;
"", "", "", "N", "", "", "", "", ;
aHelpPor, aHelpEng, aHelpEsp )

// ---
aHelpPor := { "Informe a data final." }
aHelpEng := { "Informe a data final." }
aHelpEsp := { "Informe a data final." }
PutSx1(_cPerg, "04", "Data Ate", "Data Ate", "Data Ate", ;
"MV_CH4", "D",8, 0, 0, "G", "", "", "", "", ;
"MV_PAR04",;
"", "", "", "", "", "", "", "", ;
"", "", "", "N", "", "", "", "", ;
aHelpPor, aHelpEng, aHelpEsp )

// ---
aHelpPor := { "Informe o tipo de mensagem." }
aHelpEng := { "Informe o tipo de mensagem." }
aHelpEsp := { "Informe o tipo de mensagem." }
PutSx1(_cPerg, "05", "Tipo Mensagem", "Tipo Mensagem", "Tipo Mensagem", ;
"MV_CH5", "N",1, 0, 1, "C", ""/*Valid*/, ""/*F3*/, ""/*SXG*/, ""/*Pyme*/, ;
"MV_PAR05",;
"Erros", "Erros", "Erros",;
"",/*Cnt1*/;
"Validadas"/*Def2*/,"Validadas","Validadas",;
"Todas"/*Def3*/,"Todas","Todas",;
""/*Def4*/,"","",;
""/*Def5*/,"","",;
aHelpPor, aHelpEng, aHelpEsp, "" )

// --- Posiciona as perguntas no 
Pergunte(_cPerg,.f.)             

// --- Restaura area de trabalho
RestArea(aArea)

Return