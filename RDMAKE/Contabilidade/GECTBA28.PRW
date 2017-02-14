#Include "Protheus.CH"
#Include "TopConn.ch"
#Include "Report.CH"

#Define TAM_VALOR01	18
#Define TAM_VALOR02	22
#Define TAM_CUSTO		17
#Define TAM_UO			05

#Define PICT_VALOR01 "@E 999,999,999,999.99"
#Define PICT_VALOR02 "@E 999,999,999,999,999.99"

#Define IMP0001 "Resumo dos Creditos PIS / COFINS por UO"
#Define IMP0002 "TOTAL"

#Define IMP0003 "SEDE"
#Define IMP0004 "UO C/CRED"
#Define IMP0005 "UO S/CRED"
#Define IMP0006 "UO OUTRAS"
#Define IMP0007 "UO C/CRED + SEDE"

#Define IMP0008 "PIS"
#Define IMP0009 "COFINS"
#Define IMP0010 "FVL"
#Define IMP0011 "OVL"
#Define IMP0012 "OVS"
#Define IMP0013 "LOG"


/*
Programa    : GECTBA28
Funcao      : User Fucntion GECTBA28
Data        : 25/05/2015
Autor       : André Costa
Descricao   : Model Report - MVC
Uso         :
Sintaxe     : GECTBA28()
Chamenda    : Menu
*/

User Function GECTBA28		// U_GECTBA28()

	Local aArea			:=	GetArea()
	Private cPerg			:=	"GECT27"
	Private TRAB			:=	GetNextAlias()
	Private oReport
	Private cConta		:=	AjustaSX6()
	Private aConta		:=	StrToArray( cConta , "|" )
	Private nPcFVL	   	:=	GetMv("MV_XPCRDVM")  			// Porcentagem de rateio do FVL	- 0.36
	Private nPcOVL	   	:=	GetMv("MV_XPCRMLA") 				// Porcentagem de rateio do OVL	- 0.382
	Private nPcOVS    	:=	GetMv("MV_XPCRMA"	) 				// Porcentagem de rateio do OVS	- 0.203
	Private nPcLOG    	:=	GetMv("MV_XPCILI"	) 				// Porcentagem de rateio do LOG	- 0.055
	Private nAliqPIS   	:=	GetMv("MV_TXPIS")	 				// Parâmetro do Valor				- PIS
	Private nAliqCofins	:=	GetMv("MV_TXCOFIN")				// Parâmetro do Valor		 		- COFINS
	Private cCtPIS		:=	GetMv("MV_XCTPIS")				// Parâmetro de conta contábil	- PIS
	Private cCtPISA    	:=	GetMv("MV_XCTPISA")				// Parâmetro de conta contábil	- PIS a Recolher
	Private cCtCOFINS  	:=	GetMv("MV_XCTCOF") 				// Parâmetro de conta contábil	- COFINS
	Private cCtCOFINSA 	:=	GetMv("MV_XCTCOFA") 	  			// Parâmetro de conta contábil	- COFINS a Recolher
	Private cArqTemp
	Private cArqTemp1
	Private cArqTemp2

	If Select("TST1") # 0
		TST1->(DbCloseArea())
	EndIf

	If Select("TST2") # 0
		TST2->(DbCloseArea())
	EndIf

	If Select("TST3") # 0
		TST2->(DbCloseArea())
	EndIf

	AjustaSX1()

	oReport := ModelReport()
	oReport:PrintDialog()

	RestArea( aArea )

Return

/*
Programa    : GECTBA28
Funcao      : ModelReport
Data        : 25/05/2015
Autor       : André Costa
Descricao   : Função Model do Relatorio - MVC
Uso         :
Sintaxe     : ModelReport()
Chamenda    : Interna - GECTBA28
*/


Static Function ModelReport
	Local oReport
	Local oSection
	Local oBreak

	oReport := TReport():New("GECTBA28","Contabilização de PIS e COFINS (Débitos)","GECT27",{ |oReport| PrintReport( oReport ) },"APURACAO DO DÉBITO DO PIS/COFINS POR UO")
	oReport:SetLandScape()

	Pergunte(oReport:uParam,.F.)

	oSection := TRSection():New( oReport,"Contabil" ,{"CT3","TST1"} )

	oSection:SetLineBreak(.F.)
	oSection:SetHeaderBreak( .T. )
	oSection:SetHeaderSection( .T. )
	oSection:SetPageBreak(.F.)
	oSection:SetTotalInLine(.F.)
	oSection:SetTotalText("Total:")

	TRCell():New(oSection,"CT_CUSTO"		,"TST1"	,"Cod C.C"			,GetSx3Cache("CT3_CUSTO"	,"X3_PICTURE")	,TAM_CUSTO	, .T.,/*{|| }*/,,,"Left")
	TRCell():New(oSection,"CT_UO"			,"TST1"	,"U.O"				,"99"													,TAM_UO	, .T.,{|| xRateio() },,,"RIGHT")

	For A := 1 To Len( aConta )
		TRCell():New(oSection,"CT_"+aConta[A],"TST1"	,aConta[A]		,PICT_VALOR01,TAM_VALOR01	,.T.,/*{|| }*/,,,"RIGHT")
	Next A

	TRCell():New(oSection,"CT_TOTC"		,"TST1","Total"				,PICT_VALOR02,TAM_VALOR02	,.T.,/*{|| }*/,,,"RIGHT")
	TRCell():New(oSection,"CT_VRAT"		,"TST1","Rat. Sede"			,PICT_VALOR02,TAM_VALOR02	,.T.,/*{|| }*/,,,"RIGHT") //  "Left"
	TRCell():New(oSection,"CT_VTOT"		,"TST1","Total Rateio"		,PICT_VALOR02,TAM_VALOR02	,.T.,/*{|| }*/,,,"RIGHT")

	For A := 1 To Len( aConta )
		oObjeto := 'oTotal'+cValToChar(A)
		&oObjeto := TRFunction():New(oSection:Cell("CT_"+aConta[A]),Nil,"SUM",/*oBreak*/,,PICT_VALOR01,/*uFormula*/,.T.,.F.)
	Next A

	oCT_TOTC := TRFunction():New(oSection:Cell("CT_TOTC"),Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)
	oCT_VRAT := TRFunction():New(oSection:Cell("CT_VRAT"),Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)
	oCT_VTOT := TRFunction():New(oSection:Cell("CT_VTOT"),Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)

	oSection1 := TRSection():New( oReport,"Resumo 1" ,{"TST2"} )
	oSection1:SetLineBreak(.F.)
	oSection1:SetHeaderBreak( .T. )
	oSection1:SetHeaderSection( .T. )
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalInLine(.F.)
	oSection1:SetTotalText("Total:")

	xDescPis		:= cCtPIS		+ " - " + cValToChar( nAliqPIS		)
	xDescCofins	:= cCtCOFINS	+ " - " + cValToChar( nAliqCofins	)

	TRCell():New(oSection1,"CT_CUSTO"	,"TST2"	,"Cod C.C"							  	,GetSx3Cache("CT3_CUSTO","X3_PICTURE")	,TAM_CUSTO	, .T.,/*{|| }*/,,,"Left")
	TRCell():New(oSection1,"VL_PIS"		,"TST2"	,"PIS - CONTA "		+ xDescPis		,PICT_VALOR01 									,50			, .T.,/*{|| }*/,,,"RIGHT")
	TRCell():New(oSection1,"VL_COFINS"	,"TST2"	,"COFINS	- CONTA "	+ xDescCofins	,PICT_VALOR01									,50			, .T.,/*{|| }*/,,,"RIGHT")

	oVLPIS		:= TRFunction():New(oSection1:Cell("VL_PIS")		,Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)
	oVLCOFINS	:= TRFunction():New(oSection1:Cell("VL_COFINS")	,Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)

	oSection2 := TRSection():New( oReport,"Resumo 2" ,{"TST3"} )
	oSection2:SetLineBreak(.F.)
	oSection2:SetHeaderBreak( .T. )
	oSection2:SetHeaderSection( .T. )
	oSection2:SetPageBreak(.F.)

	TRCell():New(oSection2,"DESCRI"		,"TST3"	,""															,"@!"			,TAM_VALOR02 + 10	, .T.,/*{|| }*/,,,"Left")
	TRCell():New(oSection2,"VL_TOTAL"	,"TST3"	,IMP0002													,PICT_VALOR02	,TAM_VALOR02 		, .T.,/*{|| }*/,,,"RIGHT")
	TRCell():New(oSection2,"VL_FVL"		,"TST3"	,IMP0010 + " ( " + AllTrim( Str( nPCFVL ) ) + " )"	,PICT_VALOR02	,TAM_VALOR02 		, .T.,/*{|| }*/,,,"RIGHT")
	TRCell():New(oSection2,"VL_OVL"		,"TST3"	,IMP0011 + " ( " + AllTrim( Str( nPCOVL ) ) + " )"	,PICT_VALOR02	,TAM_VALOR02 		, .T.,/*{|| }*/,,,"RIGHT")
	TRCell():New(oSection2,"VL_OVS"		,"TST3"	,IMP0012 + " ( " + AllTrim( Str( nPCOVS ) ) + " )"	,PICT_VALOR02	,TAM_VALOR02 		, .T.,/*{|| }*/,,,"RIGHT")
	TRCell():New(oSection2,"VL_LOG"		,"TST3"	,IMP0013 + " ( " + AllTrim( Str( nPCLOG ) ) + " )"	,PICT_VALOR02	,TAM_VALOR02		, .T.,/*{|| }*/,,,"RIGHT")

Return oReport

/*
Programa    : GECTBA28
Funcao      : Static Function PrintReport()
Data        : 25/05/2015
Autor       : André Costa
Descricao   : Model Report - MVC
Uso         :
Sintaxe     : PrintReport(oReport)
Chamenda    : Interna
*/

Static Function PrintReport(oReport)
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(2)
	Local oSection2	:= oReport:Section(3)
	Local aArea		:= GetArea()

	Local aQuery
	Local _cWhere
	Local nTotConta	:= 0
	Local oFont07	:= TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)
	Local oFont08	:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
	Local oFont10	:= TFont():New("Times New Roman",10,10,,.F.,,,,.T.,.F.)

	Local oFont07N	:= TFont():New("Times New Roman",07,07,,.T.,,,,.T.,.F.)
	Local oFont08N	:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
	Local oFont10N	:= TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)

	Private cChave
	Private cArquivo	:= ""
	Private nHdlPrv	:= ""
	Private cUONCred	:= "31,32,33,34,35,37,38,51,61"		// GetMvPar("MV_XUONPF") // Relação de UOs que não tem crédito de PIS e COFINS. O valor é utilizado rateio.
	Private cUOSCred	:= "01,02,11,21,22,23"					// GetMvPar("MV_XUOSPF") // Relação de UOs que tem crédito de PIS e COFINS. O seu valor é adicionado ao rateio.

	Private nContador	:= 1

	Private aTST1	:= {}
	Private aTST2	:= {}
	Private aTST3	:= {}

	Private aSede	:= { 0,0,0,0,0,0,0,0,0 }
	Private aTotUo	:= { 0,0,0,0,0,{0,0,0,0,0},{0,0,0,0,0} }

	Aadd( aTST1 , {"INDICE"		,"N",03,0 } )
	Aadd( aTST1 , {"CT_CUSTO" 	,"C",10,0 } )
	Aadd( aTST1 , {"CT_UO"		,"C",02,0 } )

	For X := 1 To Len( aConta )
		Aadd( aTST1 , { "CT_"+aConta[X] ,"N",15,2 } )
	Next X

	Aadd(aTST1 , {"CT_TOTC"   ,"N",15	,2 } )
	Aadd(aTST1 , {"CT_VRAT"   ,"N",15	,2 } )
	Aadd(aTST1 , {"CT_VTOT"   ,"N",17	,2 } )

	cArqTemp := CriaTrab( aTST1 )

	dbUseArea( .T. , __LocalDriver , cArqTemp , "TST1" )

	cChave := "Str(Indice) + CT_CUSTO"

	IndRegua("TST1",cArqTemp,cChave)
	DbSelectArea("TST1")

	Aadd( aTST2 , {"CT_CUSTO" 	,"C",10,0 } )
	Aadd( aTST2 , {"VL_PIS"		,"N",18,2 } )
	Aadd( aTST2 , {"VL_COFINS"	,"N",18,2 } )

	cArqTemp1 := CriaTrab( aTST2 )

	dbUseArea( .T. , __LocalDriver , cArqTemp1 , "TST2" )

	DbSelectArea("TST2")

	Aadd( aTST3 , {"DESCRI"		,"C",25,2 } )
	Aadd( aTST3 , {"VL_TOTAL"	,"N",18,2 } )
	Aadd( aTST3 , {"VL_FVL"		,"N",18,2 } )
	Aadd( aTST3 , {"VL_OVL"		,"N",18,2 } )
	Aadd( aTST3 , {"VL_OVS"		,"N",18,2 } )
	Aadd( aTST3 , {"VL_LOG"		,"N",18,2 } )

	cArqTemp2 := CriaTrab( aTST3 )

	dbUseArea( .T. , __LocalDriver , cArqTemp2 , "TST3" )

	DbSelectArea("TST3")

	 _cWhere := ""

	_cWhere	+= " And CT3_CONTA IN "+FormatIn(cConta,"|")

	_cWhere	:= "%"+_cWhere+"%"

	MakeSqlExpr(oReport:uParam)

	oSection:BeginQuery()

		BeginSql Alias TRAB

			Select Distinct SubString( CT3_CUSTO , 2 , 2 ) As "CT_UO" , CT3_CUSTO

 			From %Table:CT3% CT3

			Where (		CT3.%NotDel%
						And	CT3.CT3_DATA BetWeen %Exp:DtoS( MV_PAR01 )% And %Exp:DtoS( MV_PAR02 )%
						And	CT3.CT3_TPSALD 	=	%Exp:MV_PAR04%
					)

					%Exp:_cWhere%

			Order By SubString( CT3_CUSTO , 2 , 2 ) , CT3_CUSTO

		EndSql

	oSection:EndQuery()

	aQuery := GetLastQuery()

	oReport:SetMeter( ( TRAB )->( LastRec() ) )

	While !oReport:Cancel() .And. ( TRAB )->( !Eof() )

		nTotConta := 0

		DbSelectArea("TST1")
		RecLock("TST1",.T.)

			TST1->INDICE	:= nContador
			TST1->CT_CUSTO	:= AllTrim( ( TRAB )->CT3_CUSTO )
			TST1->CT_UO		:= ( TRAB )->CT_UO

			For Y := 1 To Len( aConta )
				nConta		:= MovCusto( aConta[Y] , ( TRAB )->CT3_CUSTO , MV_PAR01 , MV_PAR02 , "01" , "1" , 3 )
				nTotConta	+= nConta

				TST1->( FieldPut( TST1->( FieldPos( "CT_"+aConta[y] ) ) , nConta ) )
			Next Y

			TST1->CT_TOTC := nTotConta

		TST1->( MsUnLock() )

		Do Case

			Case SubStr( ( TRAB )->CT3_CUSTO,2,2 )	$ "01|02" 							// FVL
				aTotUO[2] += TST1->CT_TOTC

			Case SubStr( ( TRAB )->CT3_CUSTO,2,2 )	$ "11"								// OVL
				aTotUO[3] += TST1->CT_TOTC

			Case SubStr( ( TRAB )->CT3_CUSTO,2,2 )	$ "22|23"							// OVS
				aTotUO[4] += TST1->CT_TOTC

			Case SubStr( ( TRAB )->CT3_CUSTO,2,2 )	$ "21" 								// LOG
				aTotUO[5] += TST1->CT_TOTC

			Case SubStr( ( TRAB )->CT3_CUSTO,2,2 )	$ "31,32,33,34,35,37,38,51,61"		// Sem credito
				aTotUO[6][1] += TST1->CT_TOTC

			OtherWise																						// Sem UOS
				aTotUO[7][1] += TST1->CT_TOTC
		EndCase

		nContador++
		( TRAB )->( DbSkip() )

		oReport:IncMeter()

	End While

	aTotUO[1] := aTotUO[2] + aTotUO[3] + aTotUO[4] + aTotUO[5]

	aSede[1] := aTotUO[6][1] + aTotUO[7][1]

	aSede[2] :=  aSede[1] * nPcFVL					// Porcentagem de rateio do FVL para SEDE.
	aSede[3] :=  aSede[1] * nPcOVL					// Porcentagem de rateio do OVL para SEDE.
	aSede[4] :=  aSede[1] * nPcOVS					// Porcentagem de rateio do OVS para SEDE.
	aSede[5] :=  aSede[1] * nPcLOG					// Porcentagem de rateio do LOG para SEDE.

	aTotUO[6][2] :=  aTotUO[6][1] * nPcFVL			// Porcentagem de rateio do FVL para Sem Credito.
	aTotUO[6][3] :=  aTotUO[6][1] * nPcOVL			// Porcentagem de rateio do OVL para Sem Credito.
	aTotUO[6][4] :=  aTotUO[6][1] * nPcOVS			// Porcentagem de rateio do OVS para Sem Credito.
	aTotUO[6][5] :=  aTotUO[6][1] * nPcLOG			// Porcentagem de rateio do LOG para Sem Credito.

	aTotUO[7][2] :=  aTotUO[7][1] * nPcFVL			// Porcentagem de rateio do FVL para Sem Credito.
	aTotUO[7][3] :=  aTotUO[7][1] * nPcOVL			// Porcentagem de rateio do OVL para Sem Credito.
	aTotUO[7][4] :=  aTotUO[7][1] * nPcOVS			// Porcentagem de rateio do OVS para Sem Credito.
	aTotUO[7][5] :=  aTotUO[7][1] * nPcLOG			// Porcentagem de rateio do LOG para Sem Credito.

	If Select( "TRAB" ) # 0
		( TRAB )->( DbCloseArea() )
	EndIf

	If !oReport:Cancel()

		nImp := nAliqPIS + nAliqCofins

					//		UO S/CRED	,UO OUTRAS	,SEDE		,UO C/CRED	,UO C/CRED + SEDE ,	9,25					,PIS		,COFINS	,TOTAL
		aDescri := { 	IMP0005		,IMP0006		,IMP0003	,IMP0004		,IMP0007				,cValToChar( nImp )	,IMP0008	,IMP0009	,IMP0002 }


		For X := 1 To Len( aDescri )

			RecLock("TST3",.T.)
				TST3->DESCRI	:= aDescri[X]
			TST3->( MsUnlock() )

			For Y := 2 To Len( aTST3 )

				nPos := Y - 1

				Do Case
					Case X == 1
						nVal := aTotUO[6][nPOS]										  						// UO´s sem Credito
					Case X == 2
						nVal := aTotUO[7][nPOS]																// UO´s Outras
					Case X == 3
						nVal :=	aSede[nPOS]												  					// aSede[1] / aSede[2] / aSede[3] / aSede[4] / aSede[5]			- Totais Sede
					Case X == 4
						nVal := aTotUO[nPOS]									  								// aTotUO[1] / aTotUO[2] / aTotUO[3] / aTotUO[4] / aTotUO[5]	- Uos com Credito
					Case X == 5
						nVal := aTotUO[nPOS] + aSede[nPOS]						  						// UO C/CRED + SEDE
					Case X == 6
						nVal := ( ( aTotUO[nPOS] + aSede[nPOS] ) * ( nIMP 			/ 100 ) )	// 9.25
					Case X == 7
						nVal := ( ( aTotUO[nPOS] + aSede[nPOS] ) * ( nAliqPIS		/ 100 ) )	// PIS
					Case X == 8
						nVal := ( ( aTotUO[nPOS] + aSede[nPOS] ) * ( nAliqCofins 	/ 100 ) )	// COFINS
					Case X == 9
						nVal := ( ( aTotUO[nPOS] + aSede[nPOS] ) * ( nIMP			/ 100	) )

				EndCase

				RecLock("TST3",.F.)
					FieldPut( Y , nVal )
				TST3->( MsUnlock() )

			Next Y

		Next X

// Detalhamento das Contas

		dbSelectArea( "TST1" )

		TST1->( DbGoTop() )

		oReport:SetMeter( TST1->( LastRec() ) )

		oReport:SetTitle("APURACAO DO CREDITO DO PIS/COFINS POR UO ( " + DtoC(MV_PAR01) + " - " + DtoC(MV_PAR02) + " )")

		oSection:Init()
		While !oReport:Cancel() .And. TST1->( !Eof() )

			oSection:PrintLine()

			oReport:IncMeter()

 			TST1->( DbSkip() )

		End While

		oSection:Finish()

		oReport:EndPage()

// Detalhamento dos Creditos - Resumo 01

		dbSelectArea( "TST2" )

		TST2->( DbGoTop() )

		oReport:SetMeter( TST2->( LastRec() ) )

		oSection1:Init()
		While !oReport:Cancel() .And. TST2->( !Eof() )

			oSection1:PrintLine()

			oReport:IncMeter()

 			TST2->( DbSkip() )

		End While

		oSection1:Finish()

		oReport:EndPage()

// Resumo 02

		dbSelectArea( "TST3" )

		TST3->( DbGoTop() )

		oReport:SetMeter( TST3->( LastRec() ) )

		oSection2:Init()
		While !oReport:Cancel() .And. TST3->( !Eof() )

			oSection2:PrintLine()

			oReport:IncMeter()

 			TST3->( DbSkip() )

		End While

		oSection2:Finish()

		If MV_PAR03 = 1

			If MsgYesNo("Deseja contabilizar o crédito do PIS/COFINS?")		//	Rotina de Contabilização
				CTBCRED()
			EndIf

		EndIf

	EndIf

	If Select("TST1") # 0
		TST1->( DbCloseArea() )
	EndIf

	If Select("TST2") # 0
		TST2->( DbCloseArea() )
	EndIf

	If Select("TST3") # 0
		TST3->( DbCloseArea() )
	EndIf

	If File(cArqTemp)
		fErase(cArqTemp)
	EndIf

	If File(cArqTemp1)
		fErase(cArqTemp1)
	EndIf

	If File(cArqTemp2)
		fErase(cArqTemp2)
	EndIf

	RestArea( aArea )

Return

/*
Programa    : GECTBA28
Funcao      : Static Function xRateio
Data        : 27/05/2015
Autor       : André Costa
Descricao   : Faz a atualização do campo
Uso         : Função de Apoio
Sintaxe     : xRateio()
Chamenda    : Interna
*/


Static Function xRateio
	Local aArea		:= GetArea()
	Local nCT_VTOT	:= 0

	RecLock("TST1",.F.)

		Do Case

			Case SubStr( TST1->CT_CUSTO,2,2 )	$ "01|02"									// FVL
				TST1->CT_VRAT	:= ( TST1->CT_TOTC / aTotUO[2] ) * aSede[2]
				TST1->CT_VTOT	:= ( TST1->CT_VRAT + TST1->CT_TOTC )

			Case SubStr( TST1->CT_CUSTO,2,2 )	$ "11"										// OVL
				TST1->CT_VRAT	:= ( TST1->CT_TOTC / aTotUO[3] ) * aSede[3]
				TST1->CT_VTOT	:= TST1->CT_VRAT + TST1->CT_TOTC

			Case SubStr( TST1->CT_CUSTO,2,2 )	$ "21"								  		// LOG
				TST1->CT_VRAT	:= ( TST1->CT_TOTC / aTotUO[5] ) * aSede[5]
				TST1->CT_VTOT	:= TST1->CT_VRAT + TST1->CT_TOTC

			Case SubStr( TST1->CT_CUSTO,2,2 )	$ "22|23"									// OVS
				TST1->CT_VRAT	:= ( TST1->CT_TOTC / aTotUO[4] ) * aSede[4]
				TST1->CT_VTOT	:= TST1->CT_VRAT + TST1->CT_TOTC

			Case SubStr( TST1->CT_CUSTO,2,2 )	$ "31,32,33,34,35,37,38,51,61"		// Sem credito
				TST1->CT_VRAT	:= 0
				TST1->CT_VTOT	:= TST1->CT_VRAT + TST1->CT_TOTC

			OtherWise
				TST1->CT_VRAT	:= 0
				TST1->CT_VTOT	:= TST1->CT_VRAT + TST1->CT_TOTC
		EndCase

	TST1->( MsUnlock() )

	Reclock("TST2",.T.)
		TST2->CT_CUSTO	:= TST1->CT_CUSTO
		TST2->VL_PIS	:= ( TST1->CT_TOTC * ( nAliqPIS	/ 100 ) )
		TST2->VL_COFINS	:= ( TST1->CT_TOTC * ( nAliqCofins	/ 100 ) )
	TST2->( MsUnLock() )

   RestArea( aArea )

Return( TST1->CT_UO )


/*
Programa	: GECTBA28
Funcao		: Função CTBCRED
Data		: 10/08/05
Autor		: Marcos Furtado
Data		: 29/05/15
Melhora		: Andre Costa
Descricao	: Esta função contaliza os valores decrédito da tabela temporária totalizada por centro de custo
Uso			: Função de Apoio
Sintax		: CTBCRED()
Chamenda	: Interna
*/


Static Function CTBCRED
	Local aArea		:= GetArea()
	Local aPadrao	:= {}
	Local nTotal	:= 0
	Local cRotina	:= "GECTBA28"
	Local cLote		:= "000001"
	Local cArquivo	:= "GECTBA28"
	Local lCredito
	Local nHdlPrv
	Local lDigita	:= .T.

	aPadrao := {	{	"063" , "VL_PIS"		,	GetMv("MV_XCTPIS") 	, GetMv("MV_XCTPISA")	} ,;	// Pis
					{	"064" , "VL_COFINS"	,	GetMv("MV_XCTCOF")	, GetMv("MV_XCTCOFA")	} }		// Cofins

	For X := 1 To Len( aPadrao )

		nHdlPrv	:= HeadProva( cLote , cRotina , Substr( cUsuario , 7 , 6 ) , @cArquivo ) // Abre o lançamento contábil

		nTotal	:= 0

		dbSelectArea( "TST2" )

		TST2->( DbGoTop() )

		oReport:SetMeter( TST2->( LastRec() ) )

		While TST2->(!Eof())

			oReport:IncMeter()

			If VerPadrao( aPadrao[X][1] )

				lCREDITO	:= ( TST2->&(aPadrao[X][2]) < 0 )											 // CREDITO

				CUSTOD		:= IIf(!lCREDITO , TST2->CT_CUSTO	, ""				)
				CUSTOC		:= IIf( lCREDITO , TST2->CT_CUSTO	, ""				)
				DEBITO		:= IIf( lCREDITO , aPadrao[X][4]	, aPadrao[X][3]	)
				CREDITO	:= IIf( lCREDITO , aPadrao[X][3]	, aPadrao[X][4]	)

			    VALOR	:= ( TST2->&(aPadrao[X][2] ) * IIf( lCREDITO , -1 , 1 ) )
				nTotal	+= DetProva(nHdlPrv,aPadrao[X][1],cRotina,cLote)								// Inclui uma linha no lançamento contábil

	   		EndIf

			TST2->( DbSkip() )

 		EndDo

		RodaProva( nHdlPrv	, nTotal )																	// Roda o Lançamento
		cA100Incl( cArquivo , nHdlPrv , 3 , cLote , .T. , .F. ) 										// Envia para Lancamento Contabil

	Next X

	RestArea( aArea )

Return


/*
Programa    : GECTBA28
Funcao      : Função Estatica  - AjustaSX1
Data        : 25/05/2015
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Ajusta os Parametros do Relatorio
Sintaxe     : AjustaSX1()
Chamenda    : Interna
*/

Static Function AjustaSX1
	PutSx1(cPerg,"01","Emissão De"		,"Emissão De"		,"Emissão De"		,"mv_ch1","D",08,0,0,"G","",""	,"","","mv_par01",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"02","Emissão Ate"		,"Emissão De"		,"Emissão De"		,"mv_ch2","D",08,0,0,"G","",""	,"","","mv_par02",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"03","Contabilizar"	,"Contabilizar"	,"Contabilizar"	,"mv_ch3","N",01,0,1,"C","",""	,"","","mv_par03","Sim"	,"","","","Não","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"04","Tipo Saldo"		,"Tipo Saldo"		,"Tipo Saldo"		,"mv_ch4","C",01,0,0,"G","","SLW","","","mv_par04",""		,"","","","","","","","","","","","","","","","","","","","")

// PutSX1(/*cGrupo*/,/*cOrdem*/,/*cPergunt*/,/*cPerSpa*/,/*cPerEngc*/,/*Var*/,/*cTipo*/,/*nTamanho*/,/*[nDecimal]*/,/*[nPresel]*/,/*cGSC*/,/*[cValid]*/,/*[cF3]*/,/*[cGrpSxg]*/,/*[cPyme]*/,/*[cVar01]*/,/*[cDef01]*/,/*[cDefSpa1]*/,/*[cDefEng1]*/,/*[cCnt01]*/,/*[cDef02]*/,/*[cDefSpa2]*/,/*[cDefEng2]*/,/*[cDef03]*/,/*[cDefSpa3]*/,/*[cDefEng3]*/,/*[cDef04]*/,/*[cDefSpa4]*/,/*[cDefEng4]*/,/*[cDef05]*/,/*[cDefSpa5]*/,/*[cDefEng5]*/,/*[aHelpPor]*/,/*[aHelpEng]*/,/*[aHelpSpa]*/,/*[cHelp] )
/*
 01 cGrupo		Caracter		Nome do grupo de pergunta      X
 02 cOrdem		Caracter		Ordem de apresentação das perguntas na tela      X
 03 cPergunt  Caracter		Texto da pergunta a ser apresentado na tela.      X
 04 cPerSpa	Caracter		Texto em espanhol da pergunta a ser apresentado na tela.      X
 05 cPerEng	Caracter		Texto em inglês da pergunta a ser apresentado na tela.      X
 06 cVar		Caracter		Variavel do item.      X
 07 cTipo		Caracter		Tipo do conteúdo de resposta da pergunta.      X
 08 nTamanho  Nulo			Tamanho do campo para a resposta da pergunta.      X
 09 nDecimal  Numérico		Número de casas decimais da resposta, se houver.   0
 10 nPresel	Numérico		Valor que define qual o item do combo estará selecionado na apresentação da tela. Este campo somente poderá ser preenchido quando o parâmetro cGSC for preenchido com "C".
 11 cGSC		Caracter		Estilo de apresentação da pergunta na tela: - "G" - formato que permite editar o conteúdo do campo. - "S" - formato de texto que não permite alteração. - "C" - formato que permite a opção de seleção de dados para o campo.      X
 12 cValid		Caracter		Validação do item de pergunta.
 13 cF3		Caracter		Nome da consulta F3 que poderá ser acionada pela pergunta.
 14 cGrpSxg	Caracter		Código do grupo de campos relacionado a pergunta.
 15 cPyme		Caracter
 16 cVar01		Caracter		Nome do MV_PAR para a utilização nos programas.
 17 cDef01		Caracter		Conteúdo em português do primeiro item do objeto, caso seja Combo.
 18 cDefSpa1	Caracter		Conteúdo em espanhol do primeiro item do objeto, caso seja Combo.
 19 cDefEng1	Caracter		Conteúdo em inglês do primeiro item do objeto, caso seja Combo.
 20 cCnt01		Caracter		Conteúdo padrão da pergunta.
 21 cDef02		Caracter		Conteúdo em português do segundo item do objeto, caso seja Combo.
 22 cDefSpa2	Caracter		Conteúdo em espanhol do segundo item do objeto, caso seja Combo.
 23 cDefEng2	Caracter		Conteúdo em inglês do segundo item do objeto, caso seja Combo.
 24 cDef0		Caracter		Conteúdo em português do terceiro item do objeto, caso seja Combo.
 25 cDefSpa3	Caracter		Conteúdo em espanhol do terceiro item do objeto, caso seja Combo.
 26 cDefEng3	Caracter		Conteúdo em inglês do terceiro item do objeto, caso seja Combo.
 27 cDef04		Caracter		Conteúdo em português do quarto item do objeto, caso seja Combo.
 28 cDefSpa4	Caracter		Conteúdo em espanhol do quarto item do objeto, caso seja Combo.
 29 cDefEng4	Caracter		Conteúdo em inglês do quarto item do objeto, caso seja Combo.
 30 cDef05		Caracter		Conteúdo em português do quinto item do objeto, caso seja Combo.
 31 cDefSpa5	Caracter		Conteúdo em espanhol do quinto item do objeto, caso seja Combo.
 32 cDefEng5	Caracter		Conteúdo em inglês do quinto item do objeto, caso seja Combo.
 33 aHelpPor	Vetor			Help descritivo da pergunta em Português.
 34 aHelpEng	Vetor			Help descritivo da pergunta em Inglês.
 35 aHelpSpa	Vetor			Help descritivo da pergunta em Espanhol.
 36 cHelp		Caracter		Nome do help equivalente, caso já exista algum no sistema.
*/

Return



/*
Programa    : GECTBA28
Funcao      : Função Estatica  - AjustaSX6
Data        : 25/05/2015
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Ajusta os Parametros do Relatorio
Sintaxe     : AjustaSX6()
Chamenda    : InteOVS
Retorno		: Conteudo do Parametro
*/


Static Function AjustaSX6
	Local aArea		:= GetArea()
	Local _MVConta	:= GetMV("MV_XRCTB27",.F.,'')

	Begin Sequence

		If !Empty( _MVConta )
			Break
		EndIf

		DbSelectArea("SX6")  // abre arquivo temporário
		SX6->( DbSetOrder(1) )

		If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XRCTB27" , .F. ) )
			Conout('Parametro MV_XRCTB27 Criado')
			RecLock( "SX6",.T. )
				SX6->X6_VAR     := "MV_XRCTB27"
				SX6->X6_TIPO    := "C"
				SX6->X6_CONTEUD := "713201|713203|711101|711107|711109|713408|713706|713709|713710|713711|713911|713910|712103"
				SX6->X6_CONTSPA := "713201|713203|711101|711107|711109|713408|713706|713709|713710|713711|713911|713910|712103"
				SX6->X6_CONTENG := "713201|713203|711101|711107|711109|713408|713706|713709|713710|713711|713911|713910|712103"

				SX6->X6_DESCRIC := "Contas a serem utilizadas no relatorio"
				SX6->X6_DESC1   := ""
				SX6->X6_DSCSPA  := "Contas a serem utilizadas no relatorio"
				SX6->X6_DSCSPA1 := ""
				SX6->X6_DSCENG  := "Contas a serem utilizadas no relatorio"
				SX6->X6_DSCENG1 := ""
			MsUnLock()
		EndIf

	End Sequence

	RestArea(aArea)

Return( _MVConta )


