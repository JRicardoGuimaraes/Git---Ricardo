#Include "ProtheusS.CH"
#Include "TbiConn.CH"
#Include "Colors.CH"
#Include "RptDef.CH"
#Include "FWPrintSetup.ch"
#Include "TopConn.ch"

/*
Programa	: GEFFINR001
Funcao		: Static Fucntion GEFFINR001
Data		: 18/08/2015
Autor		: André Costa
Descricao	: Função principal
Uso			: Faz a chamada da função Static GEFFINR001
Sintaxe	: GEFFINR001()
Chamada	: Externa
*/


User Function GEFFINR001					// u_GEFFINR001()
	Local aArea 			:= GetArea()
	Local xObs

	Local nQtdCopy

	Private cPerg				:= "GEFFINR001"
	Private aDadosInfo		:= {}
	Private aObs 				:= {}

	Private lEnd				:= .F.
	Private lDisableSetup	:= .F.
	Private lViewPDF			:= .F.
	Private cPathInServer	:= GetTempPath(.F.)
	Private nModalResult
	Private cPrinter			:= ''
	Private cPathPDF			:= ''
	Private xImpressora

	AjustaSX1()

	If ! ( Pergunte(cPerg , .T. ) )
		Return
	EndIf

	xImpressora := IIf( MV_PAR07 == 1 , IMP_SPOOL , IMP_PDF )

	xBuildFatura()

	If Len( aDadosInfo ) == 0
		MsgInfo( "Não foram encontrados registros com os parametros informados." , "Atenção" )
		Return
	EndIf

	For X := 1 To Len( aDadosInfo )

		If !( SA1->( DbSeek( xFilial("SA1") + aDadosInfo[X][7] + aDadosInfo[X][8]  ) ) )

			cMensagem := "Cliente : " + aDadosInfo[X][7] + " Loja : " + aDadosInfo[X][8] + "" + CRLF
			cMensagem += "Não encontrado " + CRLF
			cMensagem += "Verifique Cadastro de Clientes" + CRLF

			MsgInfo( cMensagem , "Atenção" )

			Loop

		EndIf

		xObs := MV_PAR06 + "|" + aDadosInfo[X][9]

		aObs := StrToKArr( xObs , "|" )

		StaticCall( GEFCNHFAT , GEFCNHFAT , aDadosInfo[X][1], aDadosInfo[X][2], StoD(aDadosInfo[X][3]) , aDadosInfo[X][4] , aDadosInfo[X][6], aObs,.F.,MV_PAR08)

	Next X

	RestArea( aArea )

Return

Static Function xBuildFatura
	Local aArea	:= GetArea()
	Local Trab01	:= GetNextAlias()
	Local aLastQuery
	Local aBuildInfo

	If Select( Trab01 ) # 0
		(Trab01)->(DbCloseArea())
	EndIf

	BeginSql Alias Trab01

		Select E1_NUM		,	E1_VENCREA		,	E1_OBS		,
				E1_CLIENTE	,	E1_LOJA		,	E1_TIPO	,
				E1_FATURA	,	E1_FATPREF		,	E1_EMISSAO	,
				E1_VALOR	,	E1_NATUREZ		,	E1_VALLIQ	,
				E1_TPCAR	,	E1_NUMCVA		,	E1_COLMON	,
				E1_FILIAL

		From 	%Table:SE1% SE1
		Where	SE1.%NotDel%
			And	SE1.E1_FILIAL		=		 %Exp:xFilial("SE1")%
			And	SE1.E1_PREFIXO	=	 	 %Exp:MV_PAR05%
			And	SE1.E1_EMISSAO	BetWeen %Exp:MV_PAR01% And %Exp:MV_PAR02%
			And	SE1.E1_NUM			BetWeen %Exp:MV_PAR03% And %Exp:MV_PAR04%
	EndSql

	aLastQuery := GetLastQuery()

	While (Trab01)->( ! Eof() )

		aBuildInfo := {	( Trab01 )->E1_FILIAL	,;
							( Trab01 )->E1_NUM		,;
							( Trab01 )->E1_CLIENTE	,;
							( Trab01 )->E1_LOJA		,;
							( Trab01 )->E1_TIPO		,;
							( Trab01 )->E1_TPCAR		,;
							( Trab01 )->E1_NUMCVA	,;
							( Trab01 )->E1_COLMON	,;
							( Trab01 )->E1_VENCREA	,;
							( Trab01 )->E1_OBS		 ;
						}

		xBuildManInfo( aBuildInfo  )

		(Trab01)->( DbSkip() )

 	End While

	(Trab01)->( DbCloseArea() )

	RestArea( aArea )

Return

Static Function xBuildManInfo( aInfoBuild )
	Local aArea		:= GetArea()
	Local Trab02		:= GetNextAlias()
	Local aRetorno	:= {}
	Local cWhere		:= ''
	Local cInfMAN		:= AllTrim( aInfoBuild[10] )
	Local lInfMan		:= IIf( aInfoBuild[3]+aInfoBuild[4] $ AllTrim(GETNewPar("MV_XCLIMAN","04858701|15882200")) .And. aInfoBuild[5] = MV_PAR05 , .T. , .F.)
	Local xDesc		:= 0

	If Select( Trab02 ) # 0
		(Trab02)->(DbCloseArea())
	EndIf

	cWhere := " And SE1.E1_FATURA = '" + aInfoBuild[2]	+ "'"

	If lInfMan

		cInfMAN += IIf( Empty( cInfMAN ),'', "|" ) + "Inf. MAN => Tipo Carreg.: " + AllTrim(aInfoBuild[6]) + " - " + "No.CVA: " + AllTrim(aInfoBuild[7]) + " - " + "No.Moniloc: " + AllTrim(aInfoBuild[8])

		cWhere += " And	SE1.E1_FATPREF 	= '" + MV_PAR05		+ "'"
		cWhere += " And	SE1.E1_CLIENTE 	= '" + aInfoBuild[3]	+ "'"
		cWhere += " And	SE1.E1_LOJA		= '" + aInfoBuild[4]	+ "'"

	Else
		cWhere += " And E1_NATUREZ <> 'ISS' "
	EndIf

	cWhere := "%"+cWhere+"%"

	BeginSql Alias Trab02

		Select E1_FILIAL	,	E1_NUM		,	E1_SALDO	,
				E1_EMISSAO	,	E1_VALOR	,	E1_VALLIQ ,
				E1_FATURA


		From 	%Table:SE1% SE1
		Where	SE1.%NotDel%

		%Exp:cWhere%

	EndSql

	While (Trab02)->( ! Eof() )

		nPos := aScan( aDadosInfo, { |Z| Z[2] == aInfoBuild[2] } )

		If nPos == 0
			AADD( aDadosInfo, {	aInfoBuild[1]	,;
									aInfoBuild[2]	,;
									aInfoBuild[9]	,;
									0				,;
									0				,;
									{}				,;
									aInfoBuild[3]	,;
									aInfoBuild[4]	,;
									cInfMAN		,;
									0				 ;
								} )

			nPos := Len( aDadosInfo )
		EndIf

		DbSelectArea("SE1")
		DbSetOrder(1)

		If ( DbSeek(xFilial("SE1")+( Trab02 )->E1_FATURA+MV_PAR05+" "+"AB-"))
			xDesc := SE1->E1_VALOR
		EndIf

		AADD( aDadosInfo[nPos][6] ,	{	( Trab02 )->E1_FILIAL	,;
											( Trab02 )->E1_NUM		,;
											( Trab02 )->E1_VALLIQ	,;
											( Trab02 )->E1_EMISSAO	,;
											( Trab02 )->E1_VALOR		,;
											( Trab02 )->E1_SALDO		,;
											xDesc						 ;
										} )

		aDadosInfo[nPos][04] += ( Trab02 )->E1_VALOR
		aDadosInfo[nPos][05] += ( Trab02 )->E1_SALDO
		aDadosInfo[nPos][10] += xDesc

		(Trab02)->( DbSkip() )

 	End While

 	aDadosInfo[Len( aDadosInfo )]

	(Trab02)->( DbCloseArea() )

	RestArea( aArea )

Return


Static Function AjustaSX1()
	Local aArea		:= GetArea()
	Local aCposSX1	:= {}
	Local aPergs		:= {}
	Local X,J 			:= 0
	Local lAltera		:= .F.
	Local cKey			:= ""

	cPerg := Padr( cPerg , Len(SX1->X1_GRUPO) )

	Aadd(aPergs,{"Data Inicial"		,"","","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Data Final"		,"","","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Fatura Inicial"	,"","","mv_ch3","C",09,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Fatura Final"		,"","","mv_ch4","C",09,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Prefixo da Fat"	,"","","mv_ch5","C",03,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Observação"		,"","","mv_ch6","C",74,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Impressão em"		,"","","mv_ch7","N",01,0,2,"C","","MV_PAR07","Spool"	,"Spool"	,"Spool"	,"","","PDF","PDF","PDF","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Imprimir 2º Via"	,"","","mv_ch8","N",01,0,1,"C","","MV_PAR08","Não"	,"Nao"		,"No"		,"","","Sim","Si","Yes","","","","","","","","","","","","","","","","","","","","",""})

	aCposSX1	:=	{		"X1_PERGUNT"	,"X1_PERSPA"	,"X1_PERENG"	,"X1_VARIAVL"	,"X1_TIPO"		,	;
							"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"		,"X1_VALID"	,	;
							"X1_VAR01"		,"X1_DEF01"	,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"	,	;
							"X1_VAR02"		,"X1_DEF02"	,"X1_DEFSPA2"	,"X1_DEFENG2"	,"X1_CNT02"	,	;
							"X1_VAR03"		,"X1_DEF03"	,"X1_DEFSPA3"	,"X1_DEFENG3"	,"X1_CNT03"	,	;
							"X1_VAR04"		,"X1_DEF04"	,"X1_DEFSPA4"	,"X1_DEFENG4"	,"X1_CNT04"	,	;
							"X1_VAR05"		,"X1_DEF05"	,"X1_DEFSPA5"	,"X1_DEFENG5"	,"X1_CNT05"	,	;
							"X1_F3"		,"X1_GRPSXG"	,"X1_PYME"		,"X1_HELP" 						;
					}

	dbSelectArea("SX1")
	dbSetOrder(1)

	For X := 1 To Len(aPergs)

		lAltera := .F.

		If MsSeek(cPerg+Right(aPergs[X][11], 2))
			If (ValType(aPergs[X][Len(aPergs[x])]) = "B" .And. Eval(aPergs[X][Len(aPergs[x])], aPergs[X] ))
				aPergs[X] := aSize(aPergs[X], Len(aPergs[X]) - 1)
				lAltera := .T.
			EndIf
		EndIf

		If ! lAltera .And. Found() .And. X1_TIPO # aPergs[X][5]
			lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
		Endif

		If ! Found() .Or. lAltera
			RecLock("SX1",If(lAltera, .F., .T.))
				SX1->X1_GRUPO := cPerg
				SX1->X1_ORDEM := Right(aPergs[X][11], 2)

			For J := 1 To Len(aCposSX1)

				If 	Len(aPergs[X]) >= J .And. aPergs[X][J] # Nil .And. FieldPos( AllTrim(aCposSX1[J]) ) > 0
					SX1->&(AllTrim(aCposSX1[J])) := aPergs[X][J]
				Endif
			Next J

			MsUnlock()

			cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

			If ValType(aPergs[X][Len(aPergs[X])]) = "A"
				aHelpSpa := aPergs[X][Len(aPergs[X])]
			Else
				aHelpSpa := {}
			Endif

			If ValType(aPergs[X][Len(aPergs[X])-1]) = "A"
				aHelpEng := aPergs[X][Len(aPergs[X])-1]
			Else
				aHelpEng := {}
			Endif

			If ValType(aPergs[X][Len(aPergs[X])-2]) = "A"
				aHelpPor := aPergs[X][Len(aPergs[X])-2]
			Else
				aHelpPor := {}
			Endif

			PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		Endif

	Next

	RestArea( aArea )

Return



