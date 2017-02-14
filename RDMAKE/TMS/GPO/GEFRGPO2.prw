#Include "PROTHEUS.CH"
#include "TBICONN.CH"
#include "RWMAKE.CH"
#include "topconn.ch"
#include "TbiCode.ch"
#include "tryexception.ch"

#Define nAlign01 1		// Left
#Define nAlign02 2		// Center
#Define nAlign03 3		// Right

#Define nFormat01 1		// General
#Define nFormat02 2		// Number
#Define nFormat03 3		// Monetario
#Define nFormat04 4		// Date Time

#Define lTotal02 .T.		// Totaliza
#Define lTotal02 .F.		// N�o Totaliza

#Define MSG0001 "Aguarde"
#Define MSG0002 "Processando Informa��es"




/*
Programa    : GEFRGPO2
Funcao      : Fun��o Usuario de Controle - MVC
Data        : 02/10/2016
Autor       : Andr� Costa
Descricao   : Fun��o de Apoio
Uso         : Ajusta os Parametros do Relatorio
Sintaxe     : GEFRGPO03()
Chamenda    : Menu -
*/


User Function GEFRGPO2						// u_GEFRGPO2
	Local aArea			:= GetArea()

	Private oExcel		:= Nil
	Private oXls			:= Nil

	Private cArquivo		:= GetTempPath(.T.)+"MargemCompleto"+".XML"
	Private cPerg			:=	"GEFRGPO002"

	Private TrabQuery		:= GetNextAlias()

	Private lEnd			:= .T.
	Private lAbortPrint	:= .F.

	If Select( "TrabQuery" ) # 0
		DbCloseArea("TrabQuery")
	EndIf

	AjustaSX1()

	If Pergunte( cPerg , .T. )

		Processa( { |lEnd| View() } , MSG0001, MSG0002 , .T. )	//  Aguarde - Processando informa��e

	EndIf

	RestArea( aArea )

Return(Nil)

/*
Programa    : GEFRGPO2
Funcao      : View
Data        : 02/10/2016
Autor       : Andr� Costa
Descricao   : Fun��o de Apoio
Uso         : Ajusta os Parametros do Relatorio
Sintaxe     : AjustaSX1()
Chamenda    : Interna
*/

Static Function View()
	Local aArea := GetArea()

	Begin Sequence

		oExcel := FWMSEXCEL():New()

		Model()

		If !lEnd
			Break
		EndIf

		oExcel:Activate()
		oExcel:GetXMLFile( cArquivo )
		oExcel:DeActivate()

		oXls := MsExcel():New()

		oXls:WorkBooks:Open(cArquivo)
		oXls:SetVisible(.T.)
		oXls:Destroy()

	End Sequence

	RestArea( aArea )

Return( Nil )


/*
Programa    : GEFRGPO2
Funcao      : Fun��o Estatica  - Model
Data        : 02/10/2016
Autor       : Andr� Costa
Descricao   : Fun��o de Apoio
Uso         : Modelagem do Relatorio
Sintaxe     : Model()
Chamenda    : Interna
*/

Static Function Model

	Begin Sequence

		IncProc()

		BuildQuery()

		DbSelectArea( (TrabQuery) )

		( TrabQuery )->( DbgoTop() )

		If ( TrabQuery )->( Eof() )
			Aviso("Aten��o","N�o existem informa��es a serem impressas.",{"OK"})
			lEnd := .F.
			Break
		EndIf

		oExcel:AddworkSheet("Margem")

		oExcel:AddTable ("Margem","Margem de Contribui��o - Completo")

		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Dt.Gera��o"			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Viagem"				, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","AST"					, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Veic.Plan."			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Veic.Realiz."			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Veic.Real"				, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Forn.Planej."			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Transp.Planejada"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","T.Realiz"				, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Transp.Realizada"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","C. Custo"				, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Projeto"				, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Cod.Cli."				, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Cliente"				, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Cod.Remet."			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Cli.Remet."			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Cli.Dest."				, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Destinat�rio"			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Filial"				, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","C.Mot."				, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Motorista"				, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Frete"					, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Ped�gio"				, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Estadia"				, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","ADV"					, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","GRIS"					, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Taxas"					, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","REPOM"					, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","CT-e"					, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Ser"					, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Fat"					, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Cid. Origem"			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Cid. Destino"			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Nome da Rota"			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Itiner�rio"			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","C.Planejado"			, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","C.Realizado"			, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Vr. Venda"				, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","Venda Realizada"		, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","% M.C Planej"			, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn("Margem","Margem de Contribui��o - Completo","% M.C Realiz"			, nAlign03, nFormat02, lTotal02 )

		TRYEXCEPTION

			While ( TrabQuery )->( ! Eof() ) .And. lEnd

				ChkAbort()

				IncProc()

				oExcel:AddRow("Margem","Margem de Contribui��o - Completo",	{	StoD(	( TrabQuery )->DTQ_DATGER	)									,;
																								( TrabQuery )->DTQ_VIAGEM										,;
																								( TrabQuery )->AST												,;
																								( TrabQuery )->ZT1_VEICUL										,;
																								( TrabQuery )->DUT_DESCRI										,;
																								( TrabQuery )->DTR_CODVEI 										,;
																								( TrabQuery )->ZT1_CODFOR 	+"-"+( TrabQuery )->ZT1_LOJFOR	,;
																								( TrabQuery )->ZT1_NOMFOR 										,;
																								( TrabQuery )->DTR_CREADI 	+"-"+( TrabQuery )->DTR_LOJCRE	,;
																								( TrabQuery )->DTR_NOMCRE 										,;
																								( TrabQuery )->DTQ_CCC											,;
																								( TrabQuery )->DTQ_SOT											,;
																								( TrabQuery )->ZA0_CLI											,;
																								( TrabQuery )->ZA0_CLINOM										,;
																								( TrabQuery )->DTC_CLIREM	+"-"+( TrabQuery )->DTC_LOJREM	,;
																								( TrabQuery )->CLI_REM											,;
																								( TrabQuery )->DTC_CLIDES	+"-"+( TrabQuery )->DTC_LOJDES	,;
																								( TrabQuery )->CLI_DEST											,;
																								( TrabQuery )->DTQ_FILORI										,;
																								( TrabQuery )->DTQ_MOTORI 										,;
																								( TrabQuery )->NOME_MOTORI										,;
																								( TrabQuery )->DTQ_XFRETE										,;
																								( TrabQuery )->DTQ_VRPEDA										,;
																								( TrabQuery )->DTQ_VRESTA										,;
																								( TrabQuery )->DTQ_VALADV										,;
																								( TrabQuery )->GRIS												,;
																								( TrabQuery )->ZT0_TAXAS											,;
																								( TrabQuery )->DTQ_CTRREP										,;
																								( TrabQuery )->DTQ_NUMCTR										,;
																								( TrabQuery )->DTQ_SERCTR										,;
																								( TrabQuery )->DTQ_PREFAT										,;
																								( TrabQuery )->DTQ_ORIGEM										,;
																								( TrabQuery )->DTQ_DESTIN										,;
																								( TrabQuery )->ROTA												,;
																								( TrabQuery )->ZA3_NOMROT										,;
																								( TrabQuery )->CUSTO_PLANEJADO									,;
																								( TrabQuery )->CUSTO_REALIZADO									,;
																								( TrabQuery )->VALOR_VENDA										,;
																								( TrabQuery )->DT6_VALTOT										,;
																								( TrabQuery )->MC_PLANEJADA										,;
																								( TrabQuery )->MC_REALIZADA										 ;
																					} )

				( TrabQuery )->( DbSkip() )

			End While

		CATCHEXCEPTION

			lEnd := .F.

	 	ENDEXCEPTION

	End Sequence

Return( Nil )



/*
Programa    : GEFRGPO2
Funcao      : Fun��o Estatica  - BuildQuery
Data        : 02/10/2016
Autor       : Andr� Costa
Descricao   : Fun��o de Apoio
Uso         : Cria a Query com informa��es necessarias
Sintaxe     : BuildQuery()
Chamenda    : Interna
*/


Static Function BuildQuery
	Local aArea := GetArea()
	LocAL aGetLastQuery

	If Select( "TrabQuery" ) # 0
		DbCloseArea("TrabQuery")
	EndIf

	BeginSql Alias TrabQuery

		Column ZA6_DTINI			As Date
		Column DATA_INI			As Date
		Column ZA7_VALOR			As Numeric(18,2)
		Column DTQ_XFRETE			As Numeric(18,2)
		Column DTQ_VRPEDA			As Numeric(18,2)
		Column DTQ_VRESTA			As Numeric(18,2)
		Column DTQ_VALADV			As Numeric(18,2)
		Column ZT0_TAXAS			As Numeric(18,2)
		Column VALOR_VENDA		As Numeric(18,2)
		Column MC_PLANEJADA		As Numeric(18,2)
		Column CUSTO_PLANEJADO	As Numeric(18,2)
		Column CUSTO_REALIZADO	As Numeric(18,2)

		%noparser%

		Select Distinct	DTQ_DATGER			,DTQ_VIAGEM , ZT1_VEICUL												,
							A.AST				,DTQ_FILORI , DT6_VALTOT												,
							DTQ_MOTORI			,DUT_DESCRI															,
							DTR_CODVEI			,DTR_PLACA																,
							ZT1_CODFOR			,ZT1_LOJFOR															,
							ZT1_NOMFOR			,DTR_CREADI															,
							DTR_LOJCRE			,DTR_NOMCRE															,
							DTQ_CCC			,DTQ_XFRETE															,
							DTQ_VRPEDA			,DTQ_VRESTA															,
							DTQ_VALADV			,ZT0_TAXAS																,
							DTQ_CTRREP			,DTQ_NUMCTR															,
							DTQ_SERCTR			,DTQ_PREFAT															,
							DTQ_SOT			,ZA0_CLI																,
							ZA0_CLINOM			,DTC_CLIREM															,
							DTC_LOJREM			,DTQ_ORIGEM															,
							DTC_CLIDES			,DTC_LOJDES															,
							DTQ_DESTIN			,A.ROTA																,
							ZA3_NOMROT			,DTC_CLIDEV															,
							DTC_LOJDEV			,A.CUSTO_PLANEJADO													,
							A.CUSTO_REALIZADO	,A.VALOR_VENDA														,
							DEV.A1_NOME 															As CLI_DEV			,
							DEST.A1_NOME															As CLI_DEST		,
							REM.A1_NOME															As CLI_REM			,
							(DTQ_BASADV * ZT0_PGRIS)												As GRIS			,
							ISNULL(DA4_NOME,'')													As NOME_MOTORI	,
							( ( ( VALOR_VENDA - CUSTO_PLANEJADO ) / CASE VALOR_VENDA WHEN 0 THEN 1 ELSE VALOR_VENDA END ) * 100)	As MC_PLANEJADA	,
							( ( ( VALOR_VENDA - CUSTO_REALIZADO ) / CASE VALOR_VENDA WHEN 0 THEN 1 ELSE VALOR_VENDA END ) * 100) 	As MC_REALIZADA

		From 	%Table:SA1%	(nolock) REM	,
				%Table:SA1%	(nolock) DEST	,
				%Table:SA1%	(nolock) DEV	,
				%Table:ZAM%	(nolock) ZAM	,
				%Table:ZA0%	(nolock) ZA0	,
				%Table:ZA3%	(nolock) ZA3	,
				%Table:DTC%	(nolock) DTC	,
				%Table:DT6%	(nolock) DT6	,
		( ( ( (%Table:DTQ%	(nolock) DTQ	Left Join %Table:DA4% (nolock) DA4 On DTQ_MOTORI = DA4_COD )
												Left Join %Table:DTR% (nolock) DTR On DTQ_VIAGEM = DTR_VIAGEM And DTQ_FILORI = DTR_FILORI )
												Left Join %Table:DA3% (nolock) DA3 On DA3_COD		= DTR_CODVEI )
												Left Join %Table:DUT% (nolock) DUT On DA3_TIPVEI = DUT_TIPVEI ),

		(	Select ZA6_AS			As 'AST'				,
					ZA6_DESCRO		As ROTA				,
					ZT1_CUSTO		As CUSTO_PLANEJADO	,
					ZT1_CODFOR								,
					ZT1_LOJFOR								,
					ZT1_NOMFOR								,
					ZT1_VEICUL								,
					ZA6_VIAGEM								,
					SUM(ZA7_CUSTO) AS CUSTO_REALIZADO	,
					SUM(ZA7_VALOR) AS VALOR_VENDA		,
					ZT0_PGRIS								,
					ZT0_TAXAS								,
					ZA6_PROJET								,
					ZA6_OBRA								,
					ZA6_SEQTRA								,
					ZA6_FILIAL

				From	%Table:ZA6% (nolock) ZA6,
						%Table:ZT0% (nolock) ZT0,
						%Table:ZT1% (nolock) ZT1,
						%Table:ZA7% (nolock) ZA7

				Where	ZT0.%NotDel%
					And	ZA6.%NotDel%
					And	ZT1.%NotDel%
					And	ZA6_TABVEN	= ZT0_CODTAB
					And	ZA6_VERVEN	= ZT0_VERTAB
					And	ZA6_ITTABV	= ZT0_ITEMTB
					And	ZT0_TABCOM	= ZT1_CODTAB
					And	ZT0_VERCOM	= ZT1_VERTAB
					And	ZT0_ITTABC	= ZT1_ITEMTB
					And	ZA6_AS		= ZA7_AS
					And	ZA6_AS		BetWeen %Exp:MV_PAR01%	And %Exp:MV_PAR02%
					And	ZA6_DTINI	BetWeen %Exp:MV_PAR07%	And %Exp:MV_PAR08%

			Group By ZA6_AS, ZA6_DESCRO, ZT1_CUSTO, ZA6_VIAGEM, ZT1_CODFOR, ZT1_LOJFOR, ZT1_NOMFOR, ZT1_VEICUL, ZT0_PGRIS, ZT0_TAXAS, ZA6_PROJET, ZA6_OBRA, ZA6_SEQTRA, ZA6_FILIAL
		) A

		Where	DTQ.%NotDel%
			And	DEV.%NotDel%
			And	REM.%NotDel%
			And	DEST.%NotDel%
			And	DTC.%NotDel%
			And	ZA0.%NotDel%
			And	ZAM.%NotDel%
			And	DT6.%NotDel%
			And	A.AST			= DTQ_AS
			And	A.ZA6_FILIAL	= DTC_FILORI
			And	A.ZA6_VIAGEM	= DTC_VIAGEM
			And	A.ZA6_PROJET	= ZAM_PROJET
			And	A.ZA6_OBRA		= ZAM_OBRA
			And	A.ZA6_SEQTRA	= ZAM_SEQTRA
			And	ZAM_FILIAL 	= ZA6_FILIAL
			And	ZAM_ORIGEM 	= ZA3_ORIGEM
			And	ZAM_DESTIN 	= ZA3_DESTIN
			And	ZAM_ROTA		= ZA3_ROTA
			And	ZAM_ETAPA 		= '001'
			And	DTC_CLIDEV		= DEV.A1_COD
			And	DTC_LOJDEV		= DEV.A1_LOJA
			And	DTC_CLIREM		= REM.A1_COD
			And	DTC_LOJREM		= REM.A1_LOJA
			And	DTC_CLIDES		= DEST.A1_COD
			And	DTC_LOJDES		= DEST.A1_LOJA
			And	DTQ_SOT		= ZA0_PROJET
			And	DTQ.DTQ_SOT	= DTC_SOT
			And	DTQ_NUMCTR		<> ''
			And	DTQ_SERCTR		<> ''
			And	DTQ_NUMPV		<> ''
			And	DTQ_FILORI		= DT6_FILDOC
			And	DTQ_NUMCTR		= DT6_DOC
			And	DTQ_SERCTR		= DT6_SERIE
			And	DTC_CLIDEV 	BetWeen %Exp:MV_PAR03% And %Exp:MV_PAR05%
			And	DTC_LOJDEV 	BetWeen %Exp:MV_PAR04% And %Exp:MV_PAR06%

		Order By A.AST

	EndSql

	aGetLastQuery := GetLastQuery()

	ProcRegua( ( TrabQuery )->( RecCount() ) )

	RestArea( aArea )

Return( Nil )

/*
Programa	: GEFRGPO2
Funcao		: Fun��o Estatica ChkAbort
Data		: 02/10/2016
Autor		: Andr� Costa
Descricao	: Fun��o de Apoio
Uso			: Verifica se o Botao Cancelar foi precionado
Sintaxe	: ChkAbort( lProcessMessage )
Parametro	: Parametro logico
Chamada	: Interna
*/

Static Function ChkAbort( lProcessMessage )

    Default lProcessMessage := .T.

    If ( lProcessMessage )
    	ProcessMessage()
    EndIf

	If ( lAbortPrint )
		lAbortPrint := MsgNoYes( OemToAnsi( "Deseja Abortar a Opera��o" ) , OemToAnsi( "Aten��o" ) )
		If ( lAbortPrint )
			lEnd := .F.
		EndIf
	EndIf

Return( NIL )



/*
Programa    : GEFRGPO2
Funcao      : Fun��o Estatica  - AjustaSX1
Data        : 02/10/2016
Autor       : Andr� Costa
Descricao   : Fun��o de Apoio
Uso         : Ajusta os Parametros do Relatorio
Sintaxe     : AjustaSX1()
Chamenda    : Interna
*/

Static Function AjustaSX1
	PutSx1(cPerg,"01","AS De"		     ,"AS   De"		,"AS  De"		,"mv_ch1","C",15,0,0,"G","",""	 ,"","","mv_par01",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"02","AS Ate"		     ,"AS  At�"		,"AS At�"		,"mv_ch2","C",15,0,0,"G","",""	 ,"","","mv_par02",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"03","Cliente Dev. De"  ,"Devedor De"	,"Devedor  De","mv_ch3","C",06,0,0,"G","","SA1","","","mv_par03",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"04","Loja Cli.Dev. De" ,"Devedor De"	,"Devedor  De","mv_ch4","C",02,0,0,"G","",""	 ,"","","mv_par04",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"05","Cliente Dev. Ate" ,"Devedor At�" ,"Devedor At�","mv_ch5","C",06,0,0,"G","","SA1","","","mv_par05",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"06","Loja Cli.Dev. Ate","Devedor De"	,"Devedor  De","mv_ch6","C",02,0,0,"G","",""	 ,"","","mv_par06",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"07","Data De"	         ,"Devedor De"	,"Devedor  De","mv_ch7","D",08,0,0,"G","",""	 ,"","","mv_par07",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"08","Data Ate"	     ,"Devedor De"	,"Devedor  De","mv_ch8","D",08,0,0,"G","",""   ,"","","mv_par08",""		,"","","",""	,"","","","","","","","","","","","","","","")

	// PutSX1(/*cGrupo*/,/*cOrdem*/,/*cPergunt*/,/*cPerSpa*/,/*cPerEngc*/,/*Var*/,/*cTipo*/,/*nTamanho*/,/*[nDecimal]*/,/*[nPresel]*/,/*cGSC*/,/*[cValid]*/,/*[cF3]*/,/*[cGrpSxg]*/,/*[cPyme]*/,/*[cVar01]*/,/*[cDef01]*/,/*[cDefSpa1]*/,/*[cDefEng1]*/,/*[cCnt01]*/,/*[cDef02]*/,/*[cDefSpa2]*/,/*[cDefEng2]*/,/*[cDef03]*/,/*[cDefSpa3]*/,/*[cDefEng3]*/,/*[cDef04]*/,/*[cDefSpa4]*/,/*[cDefEng4]*/,/*[cDef05]*/,/*[cDefSpa5]*/,/*[cDefEng5]*/,/*[aHelpPor]*/,/*[aHelpEng]*/,/*[aHelpSpa]*/,/*[cHelp] )
	/*
	01 cGrupo		Caracter		Nome do grupo de pergunta      X
	02 cOrdem		Caracter		Ordem de apresenta��o das perguntas na tela      X
	03 cPergunt  Caracter		Texto da pergunta a ser apresentado na tela.      X
	04 cPerSpa	Caracter		Texto em espanhol da pergunta a ser apresentado na tela.      X
	05 cPerEng	Caracter		Texto em ingl�s da pergunta a ser apresentado na tela.      X
	06 cVar		Caracter		Variavel do item.      X
	07 cTipo		Caracter		Tipo do conte�do de resposta da pergunta.      X
	08 nTamanho  Nulo			Tamanho do campo para a resposta da pergunta.      X
	09 nDecimal  Num�rico		N�mero de casas decimais da resposta, se houver.   0
	10 nPresel	Num�rico		Valor que define qual o item do combo estar� selecionado na apresenta��o da tela. Este campo somente poder� ser preenchido quAndo o par�metro cGSC for preenchido com "C".
	11 cGSC		Caracter		Estilo de apresenta��o da pergunta na tela: - "G" - formato que permite editar o conte�do do campo. - "S" - formato de texto que n�o permite altera��o. - "C" - formato que permite a op��o de sele��o de dados para o campo.      X
	12 cValid		Caracter		Valida��o do item de pergunta.
	13 cF3		Caracter		Nome da consulta F3 que poder� ser acionada pela pergunta.
	14 cGrpSxg	Caracter		C�digo do grupo de campos relacionado a pergunta.
	15 cPyme		Caracter
	16 cVar01		Caracter		Nome do MV_PAR para a utiliza��o nos programas.
	17 cDef01		Caracter		Conte�do em portugu�s do primeiro item do objeto, caso seja Combo.
	18 cDefSpa1	Caracter		Conte�do em espanhol do primeiro item do objeto, caso seja Combo.
	19 cDefEng1	Caracter		Conte�do em ingl�s do primeiro item do objeto, caso seja Combo.
	20 cCnt01		Caracter		Conte�do padr�o da pergunta.
	21 cDef02		Caracter		Conte�do em portugu�s do segundo item do objeto, caso seja Combo.
	22 cDefSpa2	Caracter		Conte�do em espanhol do segundo item do objeto, caso seja Combo.
	23 cDefEng2	Caracter		Conte�do em ingl�s do segundo item do objeto, caso seja Combo.
	24 cDef0		Caracter		Conte�do em portugu�s do terceiro item do objeto, caso seja Combo.
	25 cDefSpa3	Caracter		Conte�do em espanhol do terceiro item do objeto, caso seja Combo.
	26 cDefEng3	Caracter		Conte�do em ingl�s do terceiro item do objeto, caso seja Combo.
	27 cDef04		Caracter		Conte�do em portugu�s do quarto item do objeto, caso seja Combo.
	28 cDefSpa4	Caracter		Conte�do em espanhol do quarto item do objeto, caso seja Combo.
	29 cDefEng4	Caracter		Conte�do em ingl�s do quarto item do objeto, caso seja Combo.
	30 cDef05		Caracter		Conte�do em portugu�s do quinto item do objeto, caso seja Combo.
	31 cDefSpa5	Caracter		Conte�do em espanhol do quinto item do objeto, caso seja Combo.
	32 cDefEng5	Caracter		Conte�do em ingl�s do quinto item do objeto, caso seja Combo.
	33 aHelpPor	Vetor			Help descritivo da pergunta em Portugu�s.
	34 aHelpEng	Vetor			Help descritivo da pergunta em Ingl�s.
	35 aHelpSpa	Vetor			Help descritivo da pergunta em Espanhol.
	36 cHelp		Caracter		Nome do help equivalente, caso j� exista algum no sistema.
	*/

Return





