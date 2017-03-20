#Include "PROTHEUS.CH"
#include "RWMAKE.CH"
#include "TOPCONN.CH"
#include "TBICODE.CH"
#include "TBICONN.CH"

#Define MSG0001 "Aguarde"
#Define MSG0002 "Processando Informações - Relatório "
#Define MSG0003 "Carregando Planilha do Excel"

#Define nAlign01 1		// Left
#Define nAlign02 2		// Center
#Define nAlign03 3		// Right

#Define nFormat01 1		// General
#Define nFormat02 2		// Number
#Define nFormat03 3		// Monetario
#Define nFormat04 4		// Date Time

#Define lTotal02 .T.		// Totaliza
#Define lTotal02 .F.		// Não Totaliza

/*
Programa    : GEFR022
Funcao      : Função Usuario de Controle - MVC
Data        : 19/01/2016
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Impressao do Relatorio de CTEs Emitidos - Analitico / Sintetico
Sintaxe     : GEFR022
Chamenda    :
*/


User Function GEFR022					// u_GEFR022()
	Local aArea			:= GetArea()
	Local oDlgVnd			:= Nil
	Local nOpcao			:=	0

	Private oExcel		:= Nil
	Private oXls			:= Nil

	Private cSheet		:= "CTe"
	Private cTitulo		:= "CTe Emitidos - "

	Private lEnd			:= .T.
	Private lAbortPrint	:= .F.

	Private lAnalitico
	Private TrabQuery

	If AjustaParam()

		Processa( { |lEnd| View() } , MSG0001, MSG0002 + IIf( lAnalitico , 'Analítico', 'Sintético') , .T. )	//  Aguarde - Processando informaçõe

	EndIf

	RestArea( aArea )

Return


/*
Programa    : GEFR022
Funcao      : Função Estatica  - View
Data        : 19/01/2016
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Faz o Controle da Visualização do Relatorio
Sintaxe     : View()
Chamenda    : Interna
*/

Static Function View()
	Local aArea := GetArea()

	Begin Sequence

		Model()

		If Select( "TrabQuery" ) # 0
			( TrabQuery )->(DbCloseArea())
		EndIf

		If !lEnd
			Break
		EndIf

		Processa( { || ViewExcel() } , MSG0001, MSG0003 , .F. )

	End Sequence

	RestArea( aArea )

Return( Nil )

/*
Programa    : GEFR022
Funcao      : Função Estatica  - ViewExcel
Data        : 19/01/2016
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Faz o carregamento dos dados para visualização da planilha
Chamenda    : Interna
*/

Static Function ViewExcel
	Local aArea := GetArea()

	MV_PAR02 := AllTrim(MV_PAR01) + AllTrim(MV_PAR02)+'_'+IIf( lAnalitico , 'Analitico', 'Sintetico')+".XML"

	oExcel:Activate()
	oExcel:GetXMLFile( MV_PAR02 )
	oExcel:DeActivate()

	oXls := MsExcel():New()

	oXls:WorkBooks:Open(MV_PAR02)
	oXls:SetVisible(.T.)
	oXls:Destroy()

	RestArea( aArea )
Return( Nil )

/*
Programa    : GEFR022
Funcao      : Função Estatica  - Model
Data        : 19/01/2016
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Modelagem do Relatorio
Sintaxe     : Model()
Chamenda    : Interna
*/

Static Function Model

	Local aArea		:= GetArea()
	Local aCliRem		:= {}
	Local aCliDes		:= {}
	Local aCliDev		:= {}

	Local cREG_CDRORI
	Local cREG_CDRDES
	Local cREG_CDRCAL
	Local cSelec_Orig
	Local cObs
	Local cServico
	Local cCondicao
	Local nRec		:= 0
	Local nRecTot := 0
	Local cModOrig:= ''

	If Select( "TrabQuery" ) # 0
		( TrabQuery )->(DbCloseArea())
	EndIf

	( TrabQuery )	:= GetNextAlias()

	Begin Sequence

		BuildQuery()

		DbSelectArea( (TrabQuery) )

		If ( TrabQuery )->( Eof() )
			Aviso("Atenção","Não existem informações a serem impressas.",{"OK"})
			lEnd := .F.
			Break
		EndIf

		( TrabQuery )->( DbGoBottom() )

		( TrabQuery )->( DbEval( { || nRecTot += 1 } ) )

		( TrabQuery )->( DbgoTop() )

		cTitulo := cTitulo + IIf( lAnalitico,'Analítico','Sintético')

		oExcel := FWMSEXCEL():New()

		oExcel:AddworkSheet( cSheet )
		oExcel:AddTable (cSheet,cTitulo)

		oExcel:AddColumn(cSheet,cTitulo,"SISTEMA"			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_FILORI"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_LOTNFC"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_DATEMI"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_DOC"			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_SERIE"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"NOTAS_CLI"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_VALMER"		, nAlign03, nFormat02, lTotal02 )

		If lAnalitico
			oExcel:AddColumn(cSheet,cTitulo,"DTC_VALOR"	, nAlign03, nFormat02, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,"DTC_QTDVOL"	, nAlign03, nFormat02, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,"DTC_PESO"	, nAlign03, nFormat02, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,"DTC_PESOM3"	, nAlign03, nFormat02, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,"DTC_METRO3"	, nAlign03, nFormat02, lTotal02 )
		Else
			oExcel:AddColumn(cSheet,cTitulo,"DT6_VOLORI"	, nAlign03, nFormat02, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,"DT6_PESO"	, nAlign03, nFormat02, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,"DT6_PESOM3"	, nAlign03, nFormat02, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,"DT6_METRO3"	, nAlign03, nFormat02, lTotal02 )
		EndIf

		oExcel:AddColumn(cSheet,cTitulo,"DT6_VALFRE"		, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_VALIMP"		, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_VALTOT"		, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_TABFRE"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_TIPTAB"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_CLIREM"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_LOJREM"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"REM_CNPJ"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"REMETENTE"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_CLIDES"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_LOJDES"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DES_CNPJ"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DESTINAT"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DEV_FRETE"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_CLIDEV"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_LOJDEV"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"CLI_DEV"			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_CLICAL"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_LOJCAL"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_TIPFRE"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_SERTMS"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_TIPTRA"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_SERVIC"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"SERVICO"			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"CARGA"			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"SELEC_ORIG"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_CDRORI"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"REG_ORIGEM"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_CDRDES"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"REG_DEST"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_CDRCAL"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"REG_CALC"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_CCUSTO"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_CCONT"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_OI"			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_CONTA"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_TIPDES"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT6_REFGEF"		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT8_VALTOT"		, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT8_VALPAS"		, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DT8_VALIMP"		, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"FRETE_PESO"		, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"FRETE_VAL"		, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"SEC_CAT"			, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"PEDAGIO"			, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"GRIS"				, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"ITR"				, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"SUFRAMA"			, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"DESPACHO"		, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"OUTROS"			, nAlign03, nFormat02, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,"NFRETEPESO"		, nAlign01, nFormat01, lTotal02 )

		If lAnalitico
			oExcel:AddColumn(cSheet,cTitulo,"DTC_CODOBS"	, nAlign01, nFormat01, lTotal02 )
		EndIf

		oExcel:AddColumn(cSheet,cTitulo,"OBS"				, nAlign01, nFormat01, lTotal02 )

		If lAnalitico
			oExcel:AddColumn(cSheet,cTitulo,"DTC_SELORI"	, nAlign01, nFormat01, lTotal02 )
		EndIf

		oExcel:AddColumn(cSheet,cTitulo,"VIAGEM"			, nAlign01, nFormat01, lTotal02 )

		ProcRegua( ( TrabQuery )->( nRecTot ) )

		( TrabQuery )->( DbGoTop() )

		While ( TrabQuery )->( ! Eof() ) .And. lEnd

			StaticCall( GEFRGPO2 , ChkAbort )

			IncProc('Atualizando Registro '+cValToChar(++nRec)+' de '+cValToChar(nRecTot))

			aCliRem := GetAdvFVal("SA1", { "A1_CGC","A1_NOME","A1_MUN","A1_EST" }	, xFilial("SA1")+( TrabQuery )->DT6_CLIREM+( TrabQuery )->DT6_LOJREM, 1, { "", "", "", "" })
			aCliDes := GetAdvFVal("SA1", { "A1_CGC","A1_NOME","A1_MUN","A1_EST" }	, xFilial("SA1")+( TrabQuery )->DT6_CLIDES+( TrabQuery )->DT6_LOJDES, 1, { "", "", "", "" })
			aCliDev := GetAdvFVal("SA1", { "A1_CGC","A1_NOME","A1_MUN","A1_EST" }	, xFilial("SA1")+( TrabQuery )->DT6_CLIDEV+( TrabQuery )->DT6_LOJDEV, 1, { "", "", "", "" })

			cObs := ''

			If ( TrabQuery )->DT6_XORICT == 'GPO'
				cModOrig		:= 'GPO'
				cREG_ORIGEM	:= aCliRem[3]+aCliRem[4]
				cREG_DEST		:= aCliDes[3]+aCliDes[4]
				cREG_CALC		:= aCliDev[3]+aCliDev[4]

				DbSelectArea("ZA6")
				DbSetOrder(2)

				If ZA6->(MsSeek(( TrabQuery )->DT6_FILORI+( TrabQuery )->ZA6_AS+( TrabQuery )->VIAGEM))
					cObs	:= ZA6_OBSVIA
				EndIf

				Begin Sequence

					cServico := 'N/DEFINIDO'

					cCondicao := IIf( !Empty( ( TrabQuery )->ZA7_EMERG2 ),'ZA7_EMERG2','ZA7_EMERGE')

					If AllTrim(( TrabQuery )->&cCondicao)  == 'S'
						cServico := 'EMERGENCIAL'
						Break
					EndIf

/*
					// Por: Ricardo Guimarães - Em: 19/02/2016 - O Valter solicitou para mudar a Regra
					If AllTrim( ( TrabQuery )->ZA7_CARGA ) = 'P'
						cServico := 'PECA'
						Break
					EndIf

					If AllTrim( ( TrabQuery )->ZA7_CARGA ) = 'I'
						cServico := 'EMBALAGEM IDA'
						Break
					EndIf

					If AllTrim( ( TrabQuery )->ZA7_CARGA ) = 'R'
						cServico := 'RETORNO'
 						Break
					EndIf
*/
					If AllTrim( ( TrabQuery )->ZA7_DEVEMB ) = 'P'
						cServico := 'PECA'
						Break
					EndIf

					If AllTrim( ( TrabQuery )->ZA7_DEVEMB) = 'I'
						cServico := 'EMBALAGEM IDA'
						Break
					EndIf

					If AllTrim( ( TrabQuery )->ZA7_DEVEMB) = 'R'
						cServico := 'RETORNO EMBALAGEM'
						Break
					EndIf


				End Sequence

			Else
				cModOrig		:= 'TMS'
				cREG_ORIGEM	:= GetAdvFVal("DUY", "DUY_DESCRI"	, xFilial("DUY")+( TrabQuery )->DT6_CDRORI			, 1,"")
				cREG_DEST		:= GetAdvFVal("DUY", "DUY_DESCRI"	, xFilial("DUY")+( TrabQuery )->DT6_CDRDES			, 1,"")
				cREG_CALC		:= GetAdvFVal("DUY", "DUY_DESCRI"	, xFilial("DUY")+( TrabQuery )->DT6_CDRCAL			, 1,"")
				cServico		:= ( TrabQuery )->SERVICO

				// cObs := MSMM(( TrabQuery )->DTC_CODOBS,80)

				If lAnalitico

					cObs := MSMM(( TrabQuery )->DTC_CODOBS,80)

					Do Case
						Case ( TrabQuery )->DTC_SELORI == "1"
							cSelec_Orig := "TRANSPORTADORA"
						Case ( TrabQuery )->DTC_SELORI == "2"
							cSelec_Orig := "CLIENTE REMETENTE"
						Case ( TrabQuery )->DTC_SELORI == "3"
							cSelec_Orig := "LOCAL DE COLETA"
						OtherWise
							cSelec_Orig := ""
					EndCase

				EndIf

			EndIf

			StaticCall( GEFRGPO2 , ChkAbort )

			If lAnalitico

				oExcel:AddRow(cSheet,cTitulo,	{	  cModOrig /*( TrabQuery )->DT6_XORICT*/	,	;
														( TrabQuery )->DT6_FILORI	,	;
														( TrabQuery )->DT6_LOTNFC	,	;
														( TrabQuery )->DT6_DATEMI 	,	;
														( TrabQuery )->DT6_DOC		,	;
														( TrabQuery )->DT6_SERIE		,	;
														( TrabQuery )->NOTAS_CLI		,	;
														( TrabQuery )->DT6_VALMER	,	;
														( TrabQuery )->DTC_VALOR		,	;
														( TrabQuery )->DTC_QTDVOL	,	;
														( TrabQuery )->DTC_PESO		,	;
														( TrabQuery )->DTC_PESOM3	,	;
														( TrabQuery )->DTC_METRO3	,	;
														( TrabQuery )->DT6_VALFRE	,	;
														( TrabQuery )->DT6_VALIMP	,	;
														( TrabQuery )->DT6_VALTOT	,	;
														( TrabQuery )->DT6_TABFRE	,	;
														( TrabQuery )->DT6_TIPTAB	,	;
														( TrabQuery )->DT6_CLIREM	,	;
														( TrabQuery )->DT6_LOJREM 	,	;
														aCliRem[1] 					,	;
														aCliRem[2]						,	;
														( TrabQuery )->DT6_CLIDES	,	;
														( TrabQuery )->DT6_LOJDES	,	;
														aCliDes[1]						,	;
														aCliDes[2]						,	;
														( TrabQuery )->DEV_FRETE		,	;
														( TrabQuery )->DT6_CLIDEV	,	;
														( TrabQuery )->DT6_LOJDEV	,	;
														aCliDev[2]					,	;
														( TrabQuery )->DT6_CLICAL	,	;
														( TrabQuery )->DT6_LOJCAL	,	;
														( TrabQuery )->DT6_TIPFRE	,	;
														( TrabQuery )->DT6_SERTMS	,	;
														( TrabQuery )->DT6_TIPTRA	,	;
														( TrabQuery )->DT6_SERVIC	,	;
														( TrabQuery )->SERVICO		,	;
														cServico						,	;
														cSELEC_ORIG					,	;
														( TrabQuery )->DT6_CDRORI	,	;
														cREG_ORIGEM					,	;
														( TrabQuery )->DT6_CDRDES	,	;
														cREG_DEST						,	;
														( TrabQuery )->DT6_CDRCAL	,	;
														cREG_CALC						,	;
														( TrabQuery )->DT6_CCUSTO	,	;
														( TrabQuery )->DT6_CCONT		,	;
														( TrabQuery )->DT6_OI		,	;
														( TrabQuery )->DT6_CONTA		,	;
														( TrabQuery )->DT6_TIPDES	,	;
														( TrabQuery )->DT6_REFGEF	,	;
														( TrabQuery )->DT8_VALTOT	,	;
														( TrabQuery )->DT8_VALPAS	,	;
														( TrabQuery )->DT8_VALIMP	,	;
														( TrabQuery )->FRETE_PESO	,	;
														( TrabQuery )->FRETE_VAL		,	;
														( TrabQuery )->SEC_CAT		,	;
														( TrabQuery )->PEDAGIO		,	;
														( TrabQuery )->GRIS			,	;
														( TrabQuery )->ITR			,	;
														( TrabQuery )->SUFRAMA		,	;
														( TrabQuery )->DESPACHO		,	;
														( TrabQuery )->OUTROS		,	;
														( TrabQuery )->NFRETEPESO	,	;
														( TrabQuery )->DTC_CODOBS	,	;
														cOBS							,	;
														( TrabQuery )->DTC_SELORI	,	;
														( TrabQuery )->VIAGEM			;
													} )

			Else

				// cInfo	:= BuildNotas( ( TrabQuery )->DT6_FILORI,( TrabQuery )->DT6_DOC,( TrabQuery )->DT6_SERIE )
				aInfo	:= BuildNotas( ( TrabQuery )->DT6_FILORI,( TrabQuery )->DT6_DOC,( TrabQuery )->DT6_SERIE )

				oExcel:AddRow(cSheet,cTitulo,	{	  cModOrig /*( TrabQuery )->DT6_XORICT*/	,	;
														( TrabQuery )->DT6_FILORI	,	;
														( TrabQuery )->DT6_LOTNFC	,	;
														( TrabQuery )->DT6_DATEMI 	,	;
														( TrabQuery )->DT6_DOC		,	;
														( TrabQuery )->DT6_SERIE	,	;
														aInfo[1]	/*Notas*/		,	;
														( TrabQuery )->DT6_VALMER	,	;
														( TrabQuery )->DTC_QTDVOL	,	;
														( TrabQuery )->DTC_PESO		,	;
														( TrabQuery )->DTC_PESOM3	,	;
														( TrabQuery )->DTC_METRO3	,	;
														( TrabQuery )->DT6_VALFRE	,	;
														( TrabQuery )->DT6_VALIMP	,	;
														( TrabQuery )->DT6_VALTOT	,	;
														( TrabQuery )->DT6_TABFRE	,	;
														( TrabQuery )->DT6_TIPTAB	,	;
														( TrabQuery )->DT6_CLIREM	,	;
														( TrabQuery )->DT6_LOJREM	,	;
														aCliRem[1]						,	;
														aCliRem[2]						,	;
														( TrabQuery )->DT6_CLIDES	,	;
														( TrabQuery )->DT6_LOJDES	,	;
														aCliDes[1]						,	;
														aCliDes[2]						,	;
														( TrabQuery )->DEV_FRETE		,	;
														( TrabQuery )->DT6_CLIDEV	,	;
														( TrabQuery )->DT6_LOJDEV	,	;
														aCliDev[2]					,	;
														( TrabQuery )->DT6_CLICAL	,	;
														( TrabQuery )->DT6_LOJCAL	,	;
														( TrabQuery )->DT6_TIPFRE	,	;
														( TrabQuery )->DT6_SERTMS	,	;
														( TrabQuery )->DT6_TIPTRA	,	;
														( TrabQuery )->DT6_SERVIC	,	;
														( TrabQuery )->SERVICO		,	;
														cServico						,	;
														cSELEC_ORIG					,	;
														( TrabQuery )->DT6_CDRORI	,	;
														cREG_ORIGEM					,	;
														( TrabQuery )->DT6_CDRDES	,	;
														cREG_DEST						,	;
														( TrabQuery )->DT6_CDRCAL	,	;
														cREG_CALC						,	;
														( TrabQuery )->DT6_CCUSTO	,	;
														( TrabQuery )->DT6_CCONT		,	;
														( TrabQuery )->DT6_OI		,	;
														( TrabQuery )->DT6_CONTA		,	;
														( TrabQuery )->DT6_TIPDES	,	;
														( TrabQuery )->DT6_REFGEF	,	;
														( TrabQuery )->DT8_VALTOT	,	;
														( TrabQuery )->DT8_VALPAS	,	;
														( TrabQuery )->DT8_VALIMP	,	;
														( TrabQuery )->FRETE_PESO	,	;
														( TrabQuery )->FRETE_VAL		,	;
														( TrabQuery )->SEC_CAT		,	;
														( TrabQuery )->PEDAGIO		,	;
														( TrabQuery )->GRIS			,	;
														( TrabQuery )->ITR			,	;
														( TrabQuery )->SUFRAMA		,	;
														( TrabQuery )->DESPACHO		,	;
														( TrabQuery )->OUTROS		,	;
														( TrabQuery )->NFRETEPESO	,	;
														aInfo[2]					,	;
														( TrabQuery )->VIAGEM			;
													} )

			EndIf

			( TrabQuery )->( DbSkip() )

		End While

	End Sequence

	RestArea( aArea )

Return( Nil )


/*
Programa    : GEFR022
Funcao      : Função Estatica  - BuildNotas
Data        : 25/01/2016
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Validação dos Parametros
Sintaxe     : BuildNotas()
Chamenda    : Interna
*/

Static Function BuildNotas(xDT6_FILORI,xDT6_DOC,xDT6_SERIE)
	Local aArea	:= GetArea()
	Local cNFs	:= ''
	Local aRet  := {"",""}
	Local cObs	:= ''
	Loca cCodObs:= ''

	DTC->(DbSetOrder(3))

	Begin Sequence

		If !( DTC->( DbSeek( xFilial("DTC")+xDT6_FILORI+xDT6_DOC+xDT6_SERIE ) ) )
			Break
		EndIf

		While	DTC->DTC_FILORI	=	xDT6_FILORI	.And.;
				DTC->DTC_DOC		=	xDT6_DOC		.And.;
				DTC->DTC_SERIE	=	xDT6_SERIE		.And.;
				DTC->( !Eof() )

			cNFs += AllTrim( DTC->DTC_NUMNFC ) + "/"
			cObs := MSMM( DTC->DTC_CODOBS,80)

			DTC->( DbSkip() )

		End While

		aRet[1] := cNFs
		aRet[2] := cObs

	End Sequence


	RestArea( aArea )

// Return( cNFs )
Return( aRet )


/*
Programa    : GEFR022
Funcao      : Função Estatica  - BuildQuery
Data        : 19/10/2016
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Cria a Query com informações necessarias
Sintaxe     : BuildQuery()
Chamenda    : Interna
*/

Static Function BuildQuery

	Local cSelect 	:= ''
	Local cSelectGPO	:= ''
	Local cSelectTMS	:= ''
	Local cFrom		:= ''
	Local cFromGPO	:= ''
	Local cFromTMS	:= ''
	Local cWhere		:= ''
	Local cWhereGPO	:= ''
	Local cWhereTMS	:= ''
	Local cGroup		:= ''
	Local cGroupGPO	:= ''
	Local cGroupTMS	:= ''

	cSelect += "	DT6_XORICT,DT6_FILORI,DT6_LOTNFC,DT6_DATEMI,DT6_DOC,DT6_SERIE,DT6_VALFRE,DT6_VALIMP						, 	" + CRLF
	cSelect += "	DT6_CLIREM,DT6_LOJREM,DT6_CLIDES,DT6_LOJDES,DT6_CLIDEV,DT6_LOJDEV,DT6_CLICAL,DT6_LOJCAL					, 	" + CRLF
	cSelect += "  DT6_TIPFRE,DT6_SERTMS,DT6_TIPTRA,SPACE(20) AS SELEC_ORIG,DT6_CDRORI,DT6_CDRDES							, 	" + CRLF
	cSelect += "  DT6_CDRCAL,DT6_CCUSTO,DT6_CCONT,DT6_OI,DT6_CONTA,DT6_TIPDES,DT6_REFGEF,Space(100) AS OBS				, 	" + CRLF
	cSelect += "	DEV_FRETE =	CASE	WHEN DT6_DEVFRE = '1' THEN 'Remetente'										 				" + CRLF
	cSelect += "        		  			WHEN DT6_DEVFRE = '2' THEN 'Destinatario'											 		" + CRLF
	cSelect += "        		  			WHEN DT6_DEVFRE = '3' THEN 'Consignatario'										 		" + CRLF
	cSelect += "       		  			WHEN DT6_DEVFRE = '4' THEN 'Despachante'											 		" + CRLF
	cSelect += "  						ELSE 'N/DEFINIDO'																		 		" + CRLF
	cSelect += "            	   END																									, 	" + CRLF
	cSelect += "  DT6_SERVIC,X5_DESCRI AS SERVICO																					, 	" + CRLF

	// Por Ricardo
	cSelect += "		SUM(DT8_VALTOT) AS DT8_VALTOT																				, 	" + CRLF
	cSelect += "		SUM(DT8_VALPAS) AS DT8_VALPAS																				, 	" + CRLF
	cSelect += "		SUM(DT8_VALIMP) AS DT8_VALIMP																				, 	" + CRLF
	cSelect += "		'FRETE_PESO'  = SUM( CASE WHEN DT3_COLIMP = '1' THEN DT8_VALTOT ELSE 0 END )							, 	" + CRLF
	cSelect += "		'FRETE_VAL'   = SUM( CASE WHEN DT3_COLIMP = '2' THEN DT8_VALTOT ELSE 0 END )							, 	" + CRLF
	cSelect += "		'SEC_CAT'     = SUM( CASE WHEN DT3_COLIMP = '3' THEN DT8_VALTOT ELSE 0 END )							, 	" + CRLF
	cSelect += "		'PEDAGIO'     = SUM( CASE WHEN DT3_COLIMP = '4' THEN DT8_VALTOT ELSE 0 END )							, 	" + CRLF
	cSelect += "		'GRIS'        = SUM( CASE WHEN DT3_COLIMP = '5' THEN DT8_VALTOT ELSE 0 END )							, 	" + CRLF
	cSelect += "		'ITR'         = SUM( CASE WHEN DT3_COLIMP = '6' THEN DT8_VALTOT ELSE 0 END )							, 	" + CRLF
	cSelect += "		'SUFRAMA'     = SUM( CASE WHEN DT3_COLIMP = '7' THEN DT8_VALTOT ELSE 0 END )							, 	" + CRLF
	cSelect += "		'DESPACHO'    = SUM( CASE WHEN DT3_COLIMP = '8' THEN DT8_VALTOT ELSE 0 END )							, 	" + CRLF
	cSelect += "		'OUTROS'      = SUM( CASE WHEN DT3_COLIMP = '9' THEN DT8_VALTOT ELSE 0 END )							, 	" + CRLF
//	cSelect += "		'NFRETEPESO'  = MAX( CASE WHEN DT3_COLIMP = '1' THEN DT3_DESCRI ELSE '' END )						, 	" + CRLF

//	cFrom	 += 	RetSqlName("DTC") + " DTC		(nolock)																		,	" + CRLF
	cFrom	 += 	RetSqlName("SX5") + " SX5		(nolock)																		,	" + CRLF

	// Por: Ricardo
	cFrom 	 += 	RetSqlName("DT3") + " DT3		(nolock)																			,	" + CRLF
	cFrom 	 += 	RetSqlName("DT8") + " DT8		(nolock)																			,	" + CRLF

	cWhere	 += "		DT6.D_E_L_E_T_	=	''							 			 				 									" + CRLF
/*
	cWhere	 += "	AND	DTC.D_E_L_E_T_	=	''						 			 					 									" + CRLF
	cWhere	 += "	AND	DT6_DOC 			= DTC_DOC						 			 					 								" + CRLF
	cWhere	 += "	AND	DT6_SERIE 			= DTC_SERIE								 		 			 								" + CRLF
*/
	cWhere	 += "	AND X5_TABELA			= 'L4'					 			 			 												" + CRLF
	cWhere	 += "	AND DT6_SERVIC 		= X5_CHAVE								 			 			 								" + CRLF
	// Por Ricardo
	cWhere	 += "	AND	SX5.D_E_L_E_T_	=	''									 			 			 								" + CRLF
	cWhere  += "	AND DT8.D_E_L_E_T_	=	''						 			 					 									" + CRLF
	cWhere  += "	AND DT3.D_E_L_E_T_	=	''								 		 			 										" + CRLF
	cWhere  += "	AND DT6_FILDOC		= DT8_FILDOC			 			 						 									" + CRLF
	cWhere  += "	AND DT6_DOC			= DT8_DOC				 			 					 										" + CRLF
	cWhere  += "	AND DT6_SERIE			= DT8_SERIE				 			 					 									" + CRLF
	cWhere  += "	AND DT8_CODPAS		= DT3_CODPAS					 			 				 									" + CRLF

	cWhere	 += "	AND	DT6_DATEMI	BETWEEN '" + DtoS(MV_PAR03)	+ "' AND '" + DtoS(MV_PAR04)	+ 	"'	 							" + CRLF
	cWhere	 += "	AND	DT6_DOC	BETWEEN '" + MV_PAR05		+ "' AND '" + MV_PAR06			+ 	"'	 							" + CRLF
	cWhere	 += "	AND	DT6_CCUSTO	BETWEEN '" + MV_PAR09		+ "' AND '" + MV_PAR10			+ 	"'	 							" + CRLF

	// cGroup += "	DT6_XORICT,DT6_FILORI,DT6_DEVFRE,DTC_CODOBS,DT6_LOTNFC,DT6_DATEMI,DT6_DOC	,DT6_SERIE						,	" + CRLF
	cGroup += "	DT6_XORICT,DT6_FILORI,DT6_DEVFRE,DT6_LOTNFC,DT6_DATEMI,DT6_DOC	,DT6_SERIE								,	" + CRLF
	cGroup += "	DT6_VALFRE	,DT6_VALIMP,DT6_CLIDES,DT6_LOJDES,DT6_CLIREM,DT6_LOJREM,DT6_CLIDEV,DT6_LOJDEV				, 	" + CRLF
	cGroup += "	DT6_CLICAL	,DT6_LOJCAL,DT6_TIPFRE,DT6_SERTMS,DT6_TIPTRA,DT6_CDRORI,DT6_CDRDES	,DT6_CDRCAL				,	" + CRLF
	cGroup += "	DT6_CCUSTO	,DT6_CCONT	,DT6_OI,DT6_CONTA	,DT6_TIPDES,DT6_REFGEF,DT6_VALMER,DT6_SERVIC,X5_DESCRI		,	" + CRLF

	If lAnalitico
		cSelect += "		DTC_NUMNFC AS NOTAS_CLI																					, 	" + CRLF
		cSelect += "		DTC_VALOR																									, 	" + CRLF
		cSelect += "		DTC_PESO																									, 	" + CRLF
		cSelect += "		DTC_QTDVOL																									, 	" + CRLF
		cSelect += "		DTC_PESOM3																									, 	" + CRLF
		cSelect += "		DTC_METRO3																									, 	" + CRLF
		cSelect += "		DTC_SELORI																									,	" + CRLF

		cSelect += "		DTC_CODOBS																									, 	" + CRLF //Ricardo

		cWhere += " AND DT6_FILDOC	BETWEEN '" + MV_PAR07		+ "' AND '" + MV_PAR08			+ 	"'	 						" + CRLF
		cWhere += " AND DT6_FILDOC 	= DTC_FILDOC					 			 												" + CRLF

		cWhere	 += "	AND	DTC.D_E_L_E_T_	=	''						 			 					 									" + CRLF
		cWhere	 += "	AND	DT6_DOC 			= DTC_DOC						 			 					 							" + CRLF
		cWhere	 += "	AND	DT6_SERIE 			= DTC_SERIE								 		 			 								" + CRLF

		cFrom	 += 	RetSqlName("DTC") + " DTC		(nolock)																		,	" + CRLF

		cWhereTMS += " AND DT6_LOTNFC	= DTC_LOTNFC						 															" + CRLF

		cGroup    += "	DTC_SELORI	,	DTC_PESOM3	,	DTC_METRO3	,	DTC_PESO	,	DTC_VALOR,		DTC_QTDVOL	,	DTC_NUMNFC		,	" + CRLF
		cGroup    += "	DTC_CODOBS  , " + CRLF

	Else

		cSelect += "		'' AS NOTAS_CLI																							, 	" + CRLF
		cSelect += "		DT6_PESO		As DTC_PESO																				, 	" + CRLF
		cSelect += "		DT6_VOLORI		As DTC_QTDVOL																			, 	" + CRLF
		cSelect += "		DT6_PESOM3		As DTC_PESOM3																			, 	" + CRLF
		cSelect += "		DT6_METRO3		As DTC_METRO3																			, 	" + CRLF
		cSelect += "		'' AS DTC_CODOBS																						, 	" + CRLF //Ricardo

		cWhere += " AND DT6_FILDOC	BETWEEN '" + MV_PAR07     	+ "' AND '" + MV_PAR08			+ 	"'							" + CRLF
//		cWhere += " AND DT6_FILDOC 	= DTC_FILDOC					 			 						 								" + CRLF

		cGroup += "	DT6_PESOM3	,	DT6_METRO3	,	DT6_PESO	,	DT6_VOLORI	,														" + CRLF
//		cGroup += "	DTC_CODOBS  , " + CRLF

	EndIf

	cSelectGPO += "		DTQ_BASADV	AS DT6_VALMER																					,	" + CRLF
	cSelectGPO += "		DTQ_TOTFRE	AS DT6_VALTOT																					,	" + CRLF
	cSelectGPO += "		ZT0_CODTAB	AS DT6_TABFRE																					,	" + CRLF
	cSelectGPO += "		ZT0_ITEMTB	AS DT6_TIPTAB																					,	" + CRLF
	cSelectGPO += "    	ZA7_CARGA																									,	" + CRLF
	cSelectGPO += "    	ZA7_EMERGE																									,	" + CRLF
	cSelectGPO += "    	ZA7_EMERG2																									,	" + CRLF
	cSelectGPO += "		'NFRETEPESO'	= DTQ_EQUIP																					,	" + CRLF
	cSelectGPO += "    	ZA7_DEVEMB																									, 	" + CRLF

/* Por Ricardo
	cSelectGPO += "		SUM(D2_VALBRUT) AS DT8_VALTOT																			,	" + CRLF
	cSelectGPO += "		SUM(D2_TOTAL)   AS DT8_VALPAS																			,	" + CRLF
	cSelectGPO += "		SUM(D2_VALICM + D2_VALIMP5 + D2_VALIMP6) AS DT8_VALIMP												,	" + CRLF
	cSelectGPO += "		'FRETE_PESO'	= SUM(	CASE	WHEN D2_ITEM = '01' 													 		" + CRLF
	cSelectGPO += "										THEN D2_VALBRUT 															 	" + CRLF
	cSelectGPO += "										ELSE 0																		 	" + CRLF
	cSelectGPO += "								END )																				, 	" + CRLF
	cSelectGPO += "    	'FRETE_VAL'	= SUM(	CASE	WHEN	(DTQ_VRPEDA > 0 AND D2_ITEM = '03')						 		" + CRLF
	cSelectGPO += "    										Or	(DTQ_VRPEDA = 0 AND D2_ITEM = '02')						 		" + CRLF
	cSelectGPO += "    									THEN D2_VALBRUT 														 		" + CRLF
	cSelectGPO += "    									ELSE 0 																 		" + CRLF
	cSelectGPO += "    							END )																				,	" + CRLF
	cSelectGPO += "    	'SEC_CAT'		= ( DTQ_BASADV * DTQ_VALADV ) / 100													, 	" + CRLF
	cSelectGPO += "    	'PEDAGIO'		= SUM( CASE	WHEN (DTQ_VRPEDA > 0 AND D2_ITEM = '02')								 	" + CRLF
	cSelectGPO += "    									THEN D2_VALBRUT															 	" + CRLF
	cSelectGPO += "    									ELSE 0 																	 	" + CRLF
	cSelectGPO += "    							END )																				,	" + CRLF
	cSelectGPO += "		'GRIS'			= ( DT6_VALMER * ZT0_PGRIS ) / 100														,	" + CRLF
	cSelectGPO += "		'ITR'			= 0																							,	" + CRLF
	cSelectGPO += "		'SUFRAMA'		= 0						0																	,	" + CRLF
	cSelectGPO += "		'DESPACHO'		= 0																							,	" + CRLF
	cSelectGPO += "		'OUTROS'		= DTQ_VROUTR																				,	" + CRLF
	cSelectGPO += "		'NFRETEPESO'	= DTQ_EQUIP																				,	" + CRLF
*/
//	cSelectGPO += "		'' 				AS DTC_CODOBS																				,	" + CRLF
	cSelectGPO += "		DTQ_AS		 	AS ZA6_AS																					,	" + CRLF
	cSelectGPO += "		DTQ_VIAGEM		AS VIAGEM																				 		" + CRLF

	cFromGPO += RetSqlName("DT6") + " DT6		(nolock)																			,	" + CRLF
	cFromGPO += RetSqlName("DTQ") + " DTQ		(nolock)																				" + CRLF
	cFromGPO += " LEFT JOIN " + RetSqlName("ZA6") + " ZA6	(nolock)																	" + CRLF
    cFromGPO += "   ON DTQ_AS = ZA6_AS AND DTQ_VIAGEM = ZA6_VIAGEM AND ZA6.D_E_L_E_T_ = ''    											" + CRLF
	cFromGPO += " LEFT JOIN " + RetSqlName("ZA0") + " ZA0	(nolock) 																	" + CRLF
	cFromGPO += "   ON ZA6_PROJET = 	ZA0_PROJET AND ZA0.D_E_L_E_T_ = ''																" + CRLF
 	cFromGPO += " LEFT JOIN " + RetSqlName("ZT0") + " ZT0	(nolock)  																	" + CRLF
   	cFromGPO += "   ON ZA6_TABVEN = ZT0_CODTAB AND ZA6_VERVEN = ZT0_VERTAB AND ZA6_ITTABV = ZT0_ITEMTB									" + CRLF
   	cFromGPO += "  AND ZT0_CODCLI = ZA0_CLI AND ZT0_LOJCLI = ZA0_LOJA AND ZT0.D_E_L_E_T_ = ''									     ,	" + CRLF
	cFromGPO += RetSqlName("ZA7") + " ZA7		(nolock)																				" + CRLF

//	cFromGPO += RetSqlName("SD2") + " SD2		(nolock)																				" + CRLF

//	cWhereGPO += "	AND SD2.D_E_L_E_T_	=	''					 			 						 								" + CRLF
	cWhereGPO += "	AND DTQ.D_E_L_E_T_	=	''							 			 				 								" + CRLF
//	cWhereGPO += "	AND ZA6.D_E_L_E_T_	=	''							 			 				 								" + CRLF
	cWhereGPO += "	AND ZA7.D_E_L_E_T_	=	''							 			 				 								" + CRLF
	cWhereGPO += "	AND DT6_XORICT		<>	''							 			 				 								" + CRLF
//	cWhereGPO += "	AND DT6_FILDOC		= D2_FILIAL						 			 				 							" + CRLF
//	cWhereGPO += "	AND DT6_DOC    		= D2_DOC							 			 			 								" + CRLF
//	cWhereGPO += "	AND DT6_SERIE  		= D2_SERIE							 			 				 							" + CRLF
	cWhereGPO += "	AND DT6_FILIAL 		= DTQ_FILIAL						 			 							 				" + CRLF
	cWhereGPO += "	AND DT6_FILDOC 		= DTQ_FILORI							 			 						 				" + CRLF
	cWhereGPO += "	AND DT6_DOC     	= DTQ_NUMCTR				 			 							 						" + CRLF
	cWhereGPO += "	AND DT6_SERIE 		= DTQ_SERCTR				 			 									 				" + CRLF
//	cWhereGPO += "	AND DTQ_FILORI 		= ZA7_FILIAL				 			 									 				" + CRLF
	cWhereGPO += "	AND DTQ_VIAGEM 		= ZA7_VIAGEM				 			 									 				" + CRLF
/*
	cWhereGPO += "	AND DTQ_AS 			= ZA6_AS				 			 							 							" + CRLF
	cWhereGPO += "	AND DTQ_VIAGEM		= ZA6_VIAGEM			 			 							 							" + CRLF
	cWhereGPO += "	AND ZA6_TABVEN 		= ZT0_CODTAB			 			 										 				" + CRLF
	cWhereGPO += "	AND ZA6_VERVEN 		= ZT0_VERTAB				 			 								 					" + CRLF
	cWhereGPO += "	AND ZA6_ITTABV 		= ZT0_ITEMTB				 			 								 					" + CRLF
*/
//	cWhereGPO += "	AND ZT0.D_E_L_E_T_	= ''						 			 								 					" + CRLF

//	cGroupGPO += "	DTQ_VALADV,	ZT0_PGRIS	,	DTQ_VROUTR	,	DTQ_EQUIP	,	DTQ_VIAGEM	,	DTQ_AS		,	ZA7_CARGA		,	" + CRLF
	cGroupGPO += "	DTQ_VIAGEM	,	DTQ_AS		,	ZA7_CARGA	,	DTQ_EQUIP 	,	ZA7_DEVEMB  ,									" + CRLF
	cGroupGPO += "	DTQ_BASADV	,	DTQ_TOTFRE	,	ZT0_CODTAB	,	ZT0_ITEMTB	,	ZA7_CARGA	,	ZA7_EMERGE	,	ZA7_EMERG2		" + CRLF

	cSelectTMS += "		DT6_VALMER																									, 	" + CRLF
	cSelectTMS += "		DT6_VALTOT																									, 	" + CRLF
	cSelectTMS += "		DT6_TABFRE																									, 	" + CRLF
	cSelectTMS += "		DT6_TIPTAB																									, 	" + CRLF
	cSelectTMS += "    	'' AS ZA7_EMERGE																							, 	" + CRLF
	cSelectTMS += "    	'' As ZA7_EMERG2																							, 	" + CRLF
	cSelectTMS += "    	'' AS ZA7_CARGA																								, 	" + CRLF
	cSelectTMS += "		'NFRETEPESO'  = MAX( CASE WHEN DT3_COLIMP = '1' THEN DT3_DESCRI ELSE '' END )								, 	" + CRLF
	cSelectTMS += "    	'' AS ZA7_DEVEMB																							, 	" + CRLF

/*
Passou a ser comum - Ricardo(11/02/2016)
	cSelectTMS += "		SUM(DT8_VALTOT) AS DT8_VALTOT																			, 	" + CRLF
	cSelectTMS += "		SUM(DT8_VALPAS) AS DT8_VALPAS																			, 	" + CRLF
	cSelectTMS += "		SUM(DT8_VALIMP) AS DT8_VALIMP																			, 	" + CRLF
	cSelectTMS += "		'FRETE_PESO'  = SUM( CASE WHEN DT3_COLIMP = '1' THEN DT8_VALTOT ELSE 0 END )						, 	" + CRLF
	cSelectTMS += "		'FRETE_VAL'   = SUM( CASE WHEN DT3_COLIMP = '2' THEN DT8_VALTOT ELSE 0 END )						, 	" + CRLF
	cSelectTMS += "		'SEC_CAT'     = SUM( CASE WHEN DT3_COLIMP = '3' THEN DT8_VALTOT ELSE 0 END )						, 	" + CRLF
	cSelectTMS += "		'PEDAGIO'     = SUM( CASE WHEN DT3_COLIMP = '4' THEN DT8_VALTOT ELSE 0 END )						, 	" + CRLF
	cSelectTMS += "		'GRIS'        = SUM( CASE WHEN DT3_COLIMP = '5' THEN DT8_VALTOT ELSE 0 END )						, 	" + CRLF
	cSelectTMS += "		'ITR'         = SUM( CASE WHEN DT3_COLIMP = '6' THEN DT8_VALTOT ELSE 0 END )						, 	" + CRLF
	cSelectTMS += "		'SUFRAMA'     = SUM( CASE WHEN DT3_COLIMP = '7' THEN DT8_VALTOT ELSE 0 END )						, 	" + CRLF
	cSelectTMS += "		'DESPACHO'    = SUM( CASE WHEN DT3_COLIMP = '8' THEN DT8_VALTOT ELSE 0 END )						, 	" + CRLF
	cSelectTMS += "		'OUTROS'      = SUM( CASE WHEN DT3_COLIMP = '9' THEN DT8_VALTOT ELSE 0 END )						, 	" + CRLF
	cSelectTMS += "		'NFRETEPESO'  = MAX( CASE WHEN DT3_COLIMP = '1' THEN DT3_DESCRI ELSE '' END )					, 	" + CRLF
*/
//	cSelectTMS += "		DTC_CODOBS																									, 	" + CRLF //Ricardo
	cSelectTMS += "		'' AS ZA6_AS																								, 	" + CRLF
	cSelectTMS += "		'' AS VIAGEM																							 		" + CRLF

	cFromTMS += RetSqlName("DT6") + " DT6		(nolock)																				" + CRLF
	cFromTMS += "			LEFT JOIN DTL010 DTL ON ( DT6_TABFRE = DTL_TABFRE AND DT6_TIPTAB = DTL_TIPTAB )						" + CRLF

/* Por: Ricardo - Passou a ser comum
	cFromTMS += RetSqlName("DT3") + " DT3		(nolock)																			,	" + CRLF
	cFromTMS += RetSqlName("DT8") + " DT8		(nolock)																				" + CRLF
*/
	cWhereTMS += "	AND SX5.D_E_L_E_T_	=	''								 			 				 							" + CRLF
	cWhereTMS += "	AND DTL.D_E_L_E_T_	=	''				 			 							 								" + CRLF
/* Por: Ricardo - Virou comum
	cWhereTMS += "	AND DT8.D_E_L_E_T_	=	''						 			 					 								" + CRLF
	cWhereTMS += "	AND DT3.D_E_L_E_T_	=	''								 		 			 									" + CRLF
	cWhereTMS += "	AND DT6_FILDOC		= DT8_FILDOC			 			 						 								" + CRLF
	cWhereTMS += "	AND DT6_DOC			= DT8_DOC				 			 					 									" + CRLF
	cWhereTMS += "	AND DT6_SERIE			= DT8_SERIE				 			 					 								" + CRLF
	cWhereTMS += "	AND DT8_CODPAS		= DT3_CODPAS					 			 				 								" + CRLF
*/
	cGroupTMS += "	DT6_VALTOT	,	DT6_TABFRE	,	DT6_TIPTAB																			" + CRLF

	cSelectGPO	:= "%"+cSelect+cSelectGPO	+"%"
	cFromGPO	:= "%"+cFrom+cFromGPO		+"%"
	cWhereGPO	:= "%"+cWhere+cWhereGPO		+"%"
	cGroupGPO	:= "%"+cGroup+cGroupGPO		+"%"

	cSelectTMS	:= "%"+cSelect+cSelectTMS	+"%"
	cFromTMS	:= "%"+cFrom+cFromTMS		+"%"
	cWhereTMS	:= "%"+cWhere+cWhereTMS		+"%"
	cGroupTMS	:= "%"+cGroup+cGroupTMS		+"%"

	BeginSql Alias TrabQuery

		Column DT6_DATEMI	As Date
		Column DT6_VALMER	As Numeric(18,2)
		Column DTC_VALOR	As Numeric(18,2)
		Column DTC_PESO	As Numeric(18,2)
		Column DTC_PESOM3	As Numeric(18,2)
		Column DTC_METRO3	As Numeric(18,2)
		Column DT6_VALFRE	As Numeric(18,2)
		Column DT6_VALIMP	As Numeric(18,2)
		Column DT6_VALTOT	As Numeric(18,2)
		Column DT8_VALTOT	As Numeric(18,2)
		Column DT8_VALPAS	As Numeric(18,2)
		Column DT8_VALIMP	As Numeric(18,2)
		Column FRETE_PESO	As Numeric(18,2)
		Column FRETE_VAL	As Numeric(18,2)
		Column PEDAGIO	As Numeric(18,2)

		%noparser%

		Select	%Exp:cSelectGPO%

			From %Exp:cFromGPO%

			Where %Exp:cWhereGPO%

			Group By %Exp:cGroupGPO%

		Union

		Select	%Exp:cSelectTMS%

			From %Exp:cFromTMS%

			Where %Exp:cWhereTMS%

			Group By %Exp:cGroupTMS%

	EndSql

	aQuery := GetLastQuery()
	MEMOWRIT("D:\TEMP\GEFR022.SQL_"+IIF(lAnalitico,"Analitico","Sintetico"),aQuery[2])
Return


/*
Programa	: GEFR022
Funcao		: Função Estatica - VldDiretorio
Data		: 19/10/2016
Autor		: Andre Costa
Descricao	: Função de Apoio
Uso			: Validação do Nome do Diretorio
Sintaxe	: VldDiretorio()
Chamenda	: Interna
Retorno	: Logico
*/


Static Function VldDiretorio
	Local lRetorno	:= .T.

	Begin Sequence

		If Empty( MV_PAR01 )
			Break
		EndIf

		If lIsDir( Alltrim( MV_PAR01 ) )
			Break
		EndIf

		Aviso("Atenção","Diretorio Invalido.",{"OK"})

		lRetorno := .F.

	End Sequence

Return( lRetorno )


/*
Programa	: GEFR022
Funcao		: Função Estatica - VldArquivo
Data		: 19/10/2016
Autor		: Andre Costa
Descricao	: Função de Apoio
Uso			: Validação do Nome do Diretorio
Sintaxe	: VldArquivo()
Chamenda	: Interna
Retorno	: Logico
*/


Static Function VldArquivo
	Local lRetorno	:= .F.
	Local aArray		:= {'\','/',':','*','?','<','>'}
	Local nX

	Begin Sequence

		If Empty( AllTrim( MV_PAR02 ) )
			Aviso("Atenção","Nome do Arquivo Vazio.",{"OK"})
			Break
		EndIf

		For nX := 1 To Len( aArray )

			If aArray[nX] $ MV_PAR02
				Aviso("Atenção",'"Nome do Arquivo Invalido. Não pode conter caracteres "\ / : * ? < >"',{"OK"})
				Break
			EndIf

		Next nX

		If File( AllTrim(MV_PAR01) + AllTrim(MV_PAR02)+".XML" )
			lRetorno := ApMsgYesNo("Deseja sobre escrever o arquivo ? ")
			Break
		EndIf

		lRetorno := .T.

	End Sequence

Return( lRetorno )

/*
Programa    : GEFR022
Funcao      : Função Estatica - DataFim
Data        : 19/01/2016
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Ajusta os Parametros do Relatorio
Sintaxe     : StaticCall( GEFR022 ,DataFim )
Chamenda    : Interna
*/

Static Function VldDataFim
	Local lRetorno := .F.

	Begin Sequence

		If ( DateDiffDay( MV_PAR04 , MV_PAR03 ) <= 30 )
			lRetorno := .T.
			Break
		EndIf

		Aviso("Atenção","Data Final não pode ser maior que 30 dias.",{"OK"})

	End Sequence

Return( lRetorno )

/*
Programa    : GEFR022
Funcao      : Função Estatica - VldCTE
Data        : 19/01/2016
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Ajusta os Parametros do Relatorio
Sintaxe     : StaticCall( GEFR022 ,VldCTE )
Chamenda    : Interna
*/

Static Function VldCTE
	Local lRetorno := .F.

	Begin Sequence

		If MV_PAR06 < MV_PAR05
			Aviso("Atenção","CTE Final informado é menor que o CTE Inicial.",{"OK"})
			Break
		EndIf

		lRetorno := .T.

	End Sequence

Return( lRetorno )


/*
Programa    : GEFR022
Funcao      : Função Estatica - VldFilial
Data        : 19/01/2016
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Ajusta os Parametros do Relatorio
Sintaxe     : StaticCall( GEFR022 ,VldFilial )
Chamenda    : Interna
*/

Static Function VldFilial
	Local lRetorno := .F.

	Begin Sequence

		If MV_PAR08 < MV_PAR07
			Aviso("Atenção","Filial final informada é menor que a Filial inicial.",{"OK"})
			Break
		EndIf

		lRetorno := .T.

	End Sequence

Return( lRetorno )

/*
Programa	: GEFR022
Funcao		: Função Estatica - AjustaParam
Data		: 19/01/2016
Autor		: André Costa
Descricao	: Função de Apoio
Uso			: Ajusta os Parametros do Relatorio
Sintaxe	: AjustaParam()
Chamenda	: Interna
Retorno	: Logico
*/


Static Function AjustaParam

	Local aParamBox	:= {}
	Local aRet			:= {}

	Local lRetorno	:= .F.
	Local lCanSave	:= .T.
	Local lUserSave	:= .T.

	Local cLoad		:= "GEFR022"
	Local aCombo		:= {"Analitico","Sintetico"}
	Local cDiretorio	:= PadR(MV_PAR01,20)

	Aadd(aParamBox,{6,"Diretorio"		,cDiretorio		,"@!"	,"StaticCall(GEFR022,VldDiretorio)","",50,.F.,"XML (*.XML) |*.XML","U:",GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY } )

	aAdd(aParamBox,{1,"Arquivo"			,PadR("CT-e",50)	,"@!"	,"StaticCall(GEFR022,VldArquivo)"	,"","",50,.F.})

	aAdd(aParamBox,{1,"Data Inicial"	,Ctod(Space(8))	,""		,""										,"","",50,.F.})
	aAdd(aParamBox,{1,"Data Final"		,Ctod(Space(8))	,""		,"StaticCall(GEFR022,VldDataFim)"	,"","",50,.F.})

	aAdd(aParamBox,{1,"CT-e Inicial"	,Space(GetSx3Cache("DT6_DOC","X3_TAMANHO"))	,"@!","",""		,"",50 ,.F.})
	aAdd(aParamBox,{1,"CT-e Final"		,Space(GetSx3Cache("DT6_DOC","X3_TAMANHO"))	,"@!","StaticCall(GEFR022,VldCTE)",""		,"",50	,.F.})

	aAdd(aParamBox,{1,"Filial Inicial"	,Space(GetSx3Cache("DT6_FILDOC","X3_TAMANHO")),"@!","",""		,"",05 ,.F.})
	aAdd(aParamBox,{1,"Filial Final"	,Space(GetSx3Cache("DT6_FILDOC","X3_TAMANHO")),"@!","StaticCall(GEFR022,VldFilial)",""		,"",05	,.F.})

	aAdd(aParamBox,{1,"C.Custo Inicial",Space(GetSx3Cache("CTT_CUSTO","X3_TAMANHO"))	,"@!","","CTT"	,"",50	,.F.})
	aAdd(aParamBox,{1,"C.Custo Final"	,Space(GetSx3Cache("CTT_CUSTO","X3_TAMANHO"))	,"@!","","CTT"	,"",50	,.F.})

	aAdd(aParamBox,{2,"Tipo do Relatorio",1,aCombo,50,"",.F.})

	If	ParamBox(aParamBox,"Parâmetros...",@aRet,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPosX*/,/*nPosy*/,/*oDlgWizard*/,cLoad,lCanSave,lUserSave)
		lAnalitico := ( ValType( MV_PAR11 ) == 'N' )
		lRetorno	:= .T.
	Endif

Return( lRetorno )

