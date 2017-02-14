#include "protheus.ch"

//-------------------------------------------------------------------------------------------------
/* {2LGI} GEFCNHR1
@autor		: Luiz Alexandre
@descricao	: Relacao dos planos de transporte
@since		: Ago./2014
@using		:
@review	:
*/
//-------------------------------------------------------------------------------------------------
User Function GEFCNHR1()

// --- Variaveis utilizadas
Local oReport
Private _cPerg	:= 'GEFCNHR100'

// --- Verifica perguntas
CNHR1SX1(_cPerg)

// --- Definicoes do relatorio
oReport := CNHR1Def()

// --- Exibe spool
oReport:PrintDialog()

Return

//-------------------------------------------------------------------------------------------------
/* {2LGI} CNHR1Def
@autor		: Luiz Alexandre
@descricao	: Definições do relatorio
@since		: Ago./2014
@using		:
@review		:
*/
//-------------------------------------------------------------------------------------------------
Static Function CNHR1Def()

// --- Variaveis utilizadas
Local _cReport	:= 'GEFCNHR1'
Local _cTitulo	:= OemToAnsi('Planos de transporte')
Local _cDesc	:= OemtoAnsi('Relação de planos de transporte')
Local oReport
Local oSection1

oReport := TReport():New(_cReport,_cTitulo,_cPerg,{|oReport| CNHR1Print(oReport)},_cDesc)
oReport:lParamPage:= .f.

// --- Secao de pracas
oSection1 := TRSection():New(oReport,"Planos de transporte","DF0")
TRCell():New(oSection1,"DUE_CODCLI"	,"DUE",,/*Picture*/	,20,/*lPixel*/	,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"DUE_LOJCLI"	,"DUE",,/*Picture*/	,20,/*lPixel*/	,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"DUE_NOME"	,"DUE",,/*Picture*/	,60,/*lPixel*/	,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"DF0_DATCAD"	,"DF0",,"@D"		,20,/*lPixel*/	,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"X5_DESCRI"	,"SX5",,/*Picture*/ ,30,/*lPixel*/	,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"DF0_PLANID"	,"DF0",,			,,/*lPixel*/	,/*{|| code-block de impressao }*/)  
//oSection1:SetColSpace( 1 )
//oSection1:SetLineStyle()
//oSection1:SetCharSeparator("") 
TRFunction():New(oSection1:Cell("DF0_PLANID"),NIL,"COUNT",NIL,NIL,NIL,NIL,.F.)
                                                                                         

Return oReport

//-------------------------------------------------------------------------------------------------
/* {2LGI} CNHR1Print
@autor		: Luiz Alexandre
@descricao	: Relatorio de planos de transporte
@since		: Ago./2014
@using		:
@review		:
*/
//-------------------------------------------------------------------------------------------------
Static Function CNHR1Print(oReport)

// --- Variaveis utilizadas
Local oSection1 := oReport:Section(1)
Local cFiltro   := ""
Local cAlias	:= GetNextAlias()
Local cOrder	:= "%DF0_CNHID, DF0_PLANID%"
Local aEndQry	:= {mv_par01,mv_par02}
Local cStatus	:= Mv_par05
Local cTipo		:= ""  
Local _nX		:= 0  

// ---	Formata os tipos selecionados
For _nX	:=	1 to Len(cStatus) Step 2
	cTipo	+=	Iif( Substr(cStatus,_nX,2) <> '**', "'"+Substr(cStatus,_nX,2)+"',", '' ) 
Next _nX
cTipo	:= Left(cTipo, Len(AllTrim(cTipo))-1 )
cTipo	:= "%" + cTipo + "%"

// --- Transforma os parametros em expressao SQL
MakeSqlExpr(_cPerg)

// --- Inicia montagem da query
oSection1:BeginQuery()

BeginSql alias cAlias
	SELECT
	DF0.DF0_PLANID,
	DF0.DF0_DDD,
	DF0.DF0_TEL, 
	DF0.DF0_CNHID, 
	DF0.DF0_DATCAD, 
	SX5.X5_DESCRI,
	DUE.DUE_CODCLI,
	DUE.DUE_LOJCLI,
	DUE.DUE_NOME
	FROM
	%table:DF0% DF0
	INNER JOIN %table:DUE% DUE
	ON DUE.DUE_FILIAL = DF0.DF0_FILIAL AND
	DUE.DUE_DDD = DF0.DF0_DDD AND
	DUE.DUE_TEL = DF0.DF0_TEL AND
	DUE.%notDel%
	INNER JOIN %table:SX5% SX5
	ON SX5.X5_FILIAL = DF0.DF0_FILIAL AND 
	SX5.X5_TABELA = 'ZY' AND
	SX5.X5_CHAVE = DF0.DF0_CNHID AND
	SX5.%notDel%
	WHERE
	DF0.DF0_FILIAL = %xfilial:DF0% AND
	DF0.DF0_PLANID BETWEEN %exp:mv_par01% AND %exp:mv_par02% AND
	DF0.DF0_DATCAD BETWEEN %exp:mv_par03% AND %exp:mv_par04% AND
	DF0.DF0_CNHID IN (%exp:cTipo%) AND
	DF0.%notDel% 
	ORDER BY %exp:cOrder%
EndSql
                   
/*	Prepara relatorio para executar a query gerada pelo Embedded SQL passando como
parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados
pela funcao MakeSqlExpr para serem adicionados a query	*/ 

oSection1:EndQuery()

// --- Imprime relatorio
oSection1:Print()

// --- Fecha area temporaria
(cAlias)->(dbCloseArea())

Return

Static Function CNHR1SX1(_cPerg)
//-------------------------------------------------------------------------------------------------
/* {2LGI} CNHR1SX1
@autor		: Luz Alexandre
@descricao	: Atualiza os parametros da rotina
@since		: Ago./2014
@using		:
@review	:
*/
//-------------------------------------------------------------------------------------------------
// --- Variaveis utilizadas
Local aArea    	:= GetArea()
Local aHelpPor 	:= {}
Local aHelpEng 	:= {}
Local aHelpEsp 	:= {}

// --- Perguntas
aHelpPor := { "Informe plano inicial." }
aHelpEng := { "Informe plano inicial." }
aHelpEsp := { "Informe plano inicial." }
PutSx1(_cPerg, "01", "Plano De", "Plano De", "Plano De", ;
"MV_CH1", "N",TamSX3("DF0_PLANID")[1], 0, 0, "G", "", "", "", "", ;
"MV_PAR01", "", "", "", "", "", "", "", "", ;
"", "", "", "N", "", "", "", "", ;
aHelpPor, aHelpEng, aHelpEsp )

aHelpPor := { "Informe plano final." }
aHelpEng := { "Informe plano final." }
aHelpEsp := { "Informe plano final." }
PutSx1(_cPerg, "02", "Plano Ate", "Plano Ate", "Plano Ate", ;
"MV_CH1", "N",TamSX3("DF0_PLANID")[1], 0, 0, "G", "", "", "", "", ;
"MV_PAR01", "", "", "", "", "", "", "", "", ;
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


aHelpPor := { "Informe status do plano para filtro." }
aHelpEng := { "Informe status do plano para filtro." }
aHelpEsp := { "Informe status do plano para filtro." }
PutSx1(_cPerg, "05", "Status do plano", "Status do plano", "Status do plano", ;
"MV_CH5", "C",20, 0, 0, "G", "U_CNHR1STA()", "", "", "", ;
"MV_PAR05", "", "", "", "", "", "", "", "", ;
"", "", "", "N", "", "", "", "", ;
aHelpPor, aHelpEng, aHelpEsp )

// --- Posiciona as perguntas no
Pergunte(_cPerg,.f.)

// --- Restaura area de trabalho
RestArea(aArea)

Return



User Function CNHR1STA(_l1Elem,_lTipoRet)
//-------------------------------------------------------------------------------------------------
/* {2LGI} CNHR1STA
@autor		: Luz Alexandre
@descricao	: Atualiza os parametros da rotina
@since		: Ago./2014
@using		:
@review	:
*/
//-------------------------------------------------------------------------------------------------
// --- Variaveis utilizadas

Local 	_cTitulo	:=	""
Local 	_MvPar
Local 	_MvParDef	:=	""
Local	_aArea		:=	GetArea()
Private _aCat		:=	{}

Default _lTipoRet 	:= 	.T.

_l1Elem 	:=	If (_l1Elem = Nil , .F. , .T.)


If _lTipoRet
	_MvPar	:=	&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
	_MvRet	:=	Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
EndIF

// ---	Seleciona tabela de status ZY
SX5->(dbSetOrder(1))

If SX5->(dbSeek(xFilial('SX5')+"ZY"))
	_cTitulo := Alltrim(Left(X5Descri(),20))
	CursorWait()
	While SX5->(!Eof()) .and. SX5->X5_TABELA == "ZY"
		
		// ---	Adiciona registros da tabela
		Aadd(_aCat,Left(SX5->X5_CHAVE,2) + " - " + Alltrim(X5Descri()))
		_MvParDef	+=	Left(SX5->X5_CHAVE,2)
		SX5->(dbSkip())
		
	Enddo
	CursorArrow()
	
Else
	
	// ---	Utiliza os tipos conforme manual fornecido, caso nao encontre a tabela
	aCat :={;
	"30 - Planejado",;
	"31 - Cancelado",;
	"32 - Declinado",;
	"33 - Em Captacao",;
	"34 - Em Execucao",;
	"35 - Executado",;
	"36 - Execucao Validada",;
	"37 - Pagamento Pendente",;
	"38 - Pagamento em Analise",;
	"39 - Liberado para pagamento";
	}
	_MvParDef	:=	"30313233343536373839"
	_cTitulo 	:=	'Status CNH'      
	
EndIf

// ---
If _lTipoRet
	
	// ---	Chamada da funcao padrao que monta opcoes
	If f_Opcoes(@_MvPar,_cTitulo,_aCat,_MvParDef,,,_l1Elem,2)
		
		// ---	Devolve resultados
		&_MvRet		:= 	_mvpar
	EndIf
	
EndIf

// ---	Restaura area de trabalho
RestArea(_aArea)

Return( If( _lTipoRet , .T. , _MvParDef ) )
