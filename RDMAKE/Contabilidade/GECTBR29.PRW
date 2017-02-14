#Include "Protheus.CH"
#Include "TopConn.ch"
#Include "Report.CH"

#Define TAM_VALOR01	18
#Define TAM_VALOR02	22
#Define TAM_CUSTO		17
#Define TAM_UO			05

#Define PICT_VALOR01 "@E 999,999,999,999.99"
#Define PICT_VALOR02 "@E 999,999,999,999,999.99"

#Define IMP0001 "Resumo dos Debitos PIS / COFINS por UO"
#Define IMP0002 "TOTAL"
#Define IMP0003 "PIS"
#Define IMP0004 "COFINS"
#Define IMP0005 "DIF PIS"
#Define IMP0006 "DIF COFINS"
#Define IMP0007 "UO"


/*
Programa    : GECTBR29
Funcao      : User Fucntion GECTBR29
Data        : 25/05/2015
Autor       : André Costa
Descricao   : Model Report - MVC
Uso         : 
Sintaxe     : GECTBR29() 
Chamenda    : Menu
*/

User Function GECTBR29		// U_GECTBR29()
                     	
	Local aArea				:=	GetArea()
	Private cPerg			:=	"GECT29"
	Private TRAB			:=	GetNextAlias()
	Private oReport
	Private cConta			:=	AjustaSX6()
	Private aConta			:=	StrToArray( cConta , "|" )
	Private nPcFVL	   	:=	GetMv("MV_XPCRDVM")  			// Porcentagem de rateio do FVL	- 0.36
	Private nPcOVL	   	:=	GetMv("MV_XPCRMLA") 				// Porcentagem de rateio do OVL	- 0.382
	Private nPcOVS    	:=	GetMv("MV_XPCRMA"	) 				// Porcentagem de rateio do OVS	- 0.203
	Private nPcLOG    	:=	GetMv("MV_XPCILI"	) 				// Porcentagem de rateio do LOG	- 0.055
	Private nAliqPIS   	:=	GetMv("MV_TXPIS")	 				// Parâmetro do Valor			- PIS	
	Private nAliqCofins	:=	GetMv("MV_TXCOFIN")				// Parâmetro do Valor		 	- COFINS	
	Private cCtPIS			:=	GetMv("MV_XCTPIS")				// Parâmetro de conta contábil	- PIS
	Private cCtCOFINS  	:=	GetMv("MV_XCTCOF") 				// Parâmetro de conta contábil	- COFINS
	Private cArqTemp
	Private cArqTemp1
	Private cArqTemp2

	If Select("TST1") # 0
		TST1->(DbCloseArea())
	EndIf
	
	If Select("TST2") # 0
		TST2->(DbCloseArea())
	EndIf

	AjustaSX1()

	oReport := ModelReport()
	oReport:PrintDialog()

	RestArea( aArea )
	
Return

/*
Programa    : GECTBR29
Funcao      : ModelReport
Data        : 25/05/2015
Autor       : André Costa
Descricao   : Função Model do Relatorio - MVC
Uso         : 
Sintaxe     : ModelReport()
Chamenda    : Interna - GECTBR29
*/


Static Function ModelReport
	Local oReport
	Local oSection
	Local oBreak

	oReport := TReport():New("GECTBR29","Contabilização de PIS e COFINS (Débitos)","GECT29",{ |oReport| PrintReport( oReport ) },"APURACAO DO DÉBITO DO PIS/COFINS POR UO")
	oReport:SetLandScape()

	Pergunte(oReport:uParam,.F.)

	oSection := TRSection():New( oReport,"Contabil" ,{"CT3","TST1"} )

	oSection:SetLineBreak(.F.)
	oSection:SetHeaderBreak( .T. )
	oSection:SetHeaderSection( .T. )
	oSection:SetPageBreak(.F.)
	oSection:SetTotalInLine(.F.)
	oSection:SetTotalText("Total : ")

	TRCell():New(oSection,"CT_CUSTO"		,"TST1"	,"Cod C.C"			,GetSx3Cache("CT3_CUSTO"	,"X3_PICTURE")	,TAM_CUSTO	, .T.,/*{|| }*/,,,"Left")
	TRCell():New(oSection,"CT_UO"			,"TST1"	,"U.O"				,"999"												,TAM_UO		, .T.,/*{|| xRateio() }*/,,,"RIGHT")

	For A := 1 To Len( aConta )
	
		If A == 6
			TRCell():New(oSection,"CT_TOTC"	,"TST1","Total"			,PICT_VALOR02,TAM_VALOR02	,.T.,/*{|| }*/,,,"RIGHT")
		EndIf
		
		TRCell():New(oSection,"CT_"+aConta[A],"TST1"	,aConta[A]	,PICT_VALOR01,TAM_VALOR01	,.T.,/*{|| }*/,,,"RIGHT")
		
		If A == 6
			TRCell():New(oSection,"CT_VPIS"	,"TST1",IMP0003+" " + cValToChar(nAliqPIS)		+"%"	,PICT_VALOR02,TAM_VALOR02	,.T.,/*{|| }*/,,,"RIGHT")
			TRCell():New(oSection,"CT_DPIS"	,"TST1",IMP0005 										,PICT_VALOR02,TAM_VALOR02	,.T.,/*{|| }*/,,,"RIGHT")
		ElseIf A == 7
			TRCell():New(oSection,"CT_VCOF"	,"TST1",IMP0004+" " + cValToChar(nAliqCofins)	+"%"	,PICT_VALOR02,TAM_VALOR02	,.T.,/*{|| }*/,,,"RIGHT")
			TRCell():New(oSection,"CT_DCOF"	,"TST1",IMP0006 										,PICT_VALOR02,TAM_VALOR02	,.T.,/*{|| }*/,,,"RIGHT")
		EndIf
		
	Next A	
	
	For A := 1 To Len( aConta )
		oObjeto := 'oTotal'+cValToChar(A)
		&oObjeto := TRFunction():New(oSection:Cell("CT_"+aConta[A]),Nil,"SUM",/*oBreak*/,,PICT_VALOR01,/*uFormula*/,.T.,.F.)
	Next A
	
	oCT_TOTC := TRFunction():New(oSection:Cell("CT_TOTC")	,Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)	
	oCT_VPIS := TRFunction():New(oSection:Cell("CT_VPIS")	,Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)
	oCT_DPIS := TRFunction():New(oSection:Cell("CT_DPIS")	,Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)
	
	oCT_VCOF := TRFunction():New(oSection:Cell("CT_VCOF")	,Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)
	oCT_DCOF := TRFunction():New(oSection:Cell("CT_DCOF")	,Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)

	oSection1 := TRSection():New( oReport,"Resumo 2" ,{"TST2"} )
	oSection1:SetLineBreak(.F.)
	oSection1:SetHeaderBreak( .T. )
	oSection1:SetHeaderSection( .T. )
	oSection1:SetPageBreak(.F.)
	
	TRCell():New(oSection1,"CT_UO"		,"TST2"	,IMP0007								  			  			,"@!"				,TAM_UO		 	, .T.,/*{|| }*/,,,"Left")
	TRCell():New(oSection1,"VL_PIS"		,"TST2"	,IMP0003 + " " + cValToChar(nAliqPIS)		+"%"	,PICT_VALOR02	,TAM_VALOR02	, .T.,/*{|| }*/,,,"RIGHT")
	TRCell():New(oSection1,"VL_COFINS"	,"TST2"	,IMP0004 + " " + cValToChar(nAliqCofins)	+"%"	,PICT_VALOR02	,TAM_VALOR02 	, .T.,/*{|| }*/,,,"RIGHT")
	TRCell():New(oSection1,"VL_TOTAL"	,"TST2"	,IMP0002														,PICT_VALOR02	,TAM_VALOR02 	, .T.,/*{|| }*/,,,"RIGHT")
	
	oVL_PIS		:= TRFunction():New(oSection1:Cell("VL_PIS")		,Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)
	oVL_COFINS	:= TRFunction():New(oSection1:Cell("VL_COFINS")	,Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)
	oVL_TOTAL	:= TRFunction():New(oSection1:Cell("VL_TOTAL")	,Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)

Return oReport

/*
Programa    : GECTBR29
Funcao      : Static Function PrintReport()
Data        : 25/05/2015
Autor       : André Costa
Descricao   : Model Report - MVC
Uso         : 
Sintaxe     : PrintReport(oReport)
Chamenda    : Interna
*/

Static Function PrintReport(oReport)
	Local oSection		:= oReport:Section(1)
	Local oSection1	:= oReport:Section(2)
	Local aArea			:= GetArea()
	
	Local aQuery
	Local _cWhere
	Local nTotConta	:= 0
	Local oFont07		:= TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)
	Local oFont08		:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
	Local oFont10		:= TFont():New("Times New Roman",10,10,,.F.,,,,.T.,.F.)
	
	Local oFont07N		:= TFont():New("Times New Roman",07,07,,.T.,,,,.T.,.F.)
	Local oFont08N		:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)	
	Local oFont10N		:= TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
		
	Private cChave
	Private cArquivo	:= ""
	Private nHdlPrv	:= ""
	Private cUONCred	:= "31,32,33,34,35,37,38,51,61"		// GetMvPar("MV_XUONPF") // Relação de UOs que não tem crédito de PIS e COFINS. O valor é utilizado rateio.
	Private cUOSDeb	:= "01,02,11,21,22,23"					// GetMvPar("MV_XUOSPF") // Relação de UOs que tem crédito de PIS e COFINS. O seu valor é adicionado ao rateio.

	Private aTST1	:= {}
	Private aTST2	:= {}

	Aadd( aTST1 , {"CT_CUSTO" 	,"C",10,0 } )
	Aadd( aTST1 , {"CT_UO"		,"C",03,0 } )   
	
	For X := 1 To Len( aConta )
		Aadd( aTST1 , { "CT_"+aConta[X] ,"N",15,2 } )
	Next X
	
	Aadd(aTST1 , {"CT_TOTC"   ,"N",15	,2 } )
	Aadd(aTST1 , {"CT_VPIS"   ,"N",15	,2 } )
	Aadd(aTST1 , {"CT_VCOF"   ,"N",17	,2 } )
	Aadd(aTST1 , {"CT_DPIS"   ,"N",15	,2 } )
	Aadd(aTST1 , {"CT_DCOF"   ,"N",17	,2 } )
							                                
	cArqTemp := CriaTrab( aTST1 )
	
	dbUseArea( .T. , __LocalDriver , cArqTemp , "TST1" )
	
	IndRegua("TST1",cArqTemp,"CT_CUSTO")
	DbSelectArea("TST1")
	
	Aadd( aTST2 , {"CT_UO"		,"C",03,0 } )
	Aadd( aTST2 , {"VL_PIS"		,"N",18,2 } )
	Aadd( aTST2 , {"VL_COFINS"	,"N",18,2 } )
	Aadd( aTST2 , {"VL_TOTAL"	,"N",18,2 } )
			
	cArqTemp1 := CriaTrab( aTST2 )
	
	dbUseArea( .T. , __LocalDriver , cArqTemp1 , "TST2" )
	
	IndRegua("TST2",cArqTemp1,"CT_UO")
	
	DbSelectArea("TST2") 

	_cWhere	:= ""
	
	_cWhere	+= " And CT3_CONTA IN "+FormatIn(cConta,"|")
		
	_cWhere	:= "%"+_cWhere+"%"

	MakeSqlExpr(oReport:uParam)

	oSection:BeginQuery()			

		BeginSql Alias TRAB

			Select Distinct SubString( CT3_CUSTO , 1 , 3 ) As "CT_UO" , CT3_CUSTO

 			From %Table:CT3% CT3

			Where (		CT3.%NotDel%
						And	CT3.CT3_DATA BetWeen %Exp:DtoS( MV_PAR01 )% And %Exp:DtoS( MV_PAR02 )%
						And	CT3.CT3_TPSALD 	=	%Exp:MV_PAR03%
					)

					%Exp:_cWhere%

			Order By SubString( CT3_CUSTO , 1, 3 ) , CT3_CUSTO

		EndSql

	oSection:EndQuery()

	aQuery := GetLastQuery()
			
	oReport:SetMeter( ( TRAB )->( LastRec() ) )
	
	While !oReport:Cancel() .And. ( TRAB )->( !Eof() )

		nTotConta := 0
		
		DbSelectArea("TST1") 
		RecLock("TST1",.T.)

			TST1->CT_CUSTO := AllTrim( ( TRAB )->CT3_CUSTO )
			TST1->CT_UO	 := ( TRAB )->CT_UO

			For Y := 1 To Len( aConta )
				nConta		:= MovCusto( aConta[Y] , ( TRAB )->CT3_CUSTO , MV_PAR01 , MV_PAR02 , "01" , "1" , 3 )
				
				nTotConta	+= IIf( Y < 6,nConta,0)

				TST1->( FieldPut( TST1->( FieldPos( "CT_"+aConta[y] ) ) , nConta ) )
			Next Y
			
			TST1->CT_TOTC	:= nTotConta
			TST1->CT_VPIS	:= ( nTotConta * ( nAliqPis		/ 100 ) )
			TST1->CT_VCOF	:= ( nTotConta * ( nAliqCofins	/ 100 ) )
		TST1->( MsUnLock() )
		
		RecLock("TST1",.F.)
			TST1->CT_DPIS	:= TST1->CT_VPIS + TST1->( CT_812203 )
			TST1->CT_DCOF	:= TST1->CT_VCOF + TST1->( CT_812204 )
		TST1->( MsUnLock() )

		RecLock("TST2" , TST2->( !DbSeek( ( TRAB )->CT_UO ) ) )
		
			TST2->CT_UO			:= ( TRAB )->CT_UO 
			TST2->VL_PIS		+= TST1->CT_VPIS
			TST2->VL_COFINS	+= TST1->CT_VCOF
			TST2->VL_TOTAL		+= TST1->CT_VPIS + TST1->CT_VCOF
		
		TST2->( MsUnLock() )

		( TRAB )->( DbSkip() )

		oReport:IncMeter()

	End While
	
	If Select( "TRAB" ) # 0
		( TRAB )->( DbCloseArea() )
	EndIf

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
		
// Detalhamento dos Debitos - Resumo 01		
		
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

	If Select("TST1") # 0
		TST1->( DbCloseArea() )
	EndIf
	
	If Select("TST2") # 0
		TST2->( DbCloseArea() )
	EndIf

	If File(cArqTemp)
		fErase(cArqTemp)
	EndIf
	
	If File(cArqTemp1)
		fErase(cArqTemp1)
	EndIf

	RestArea( aArea )
	
Return

/*
Programa    : GECTBR29
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
	PutSx1(cPerg,"03","Tipo Saldo"		,"Tipo Saldo"		,"Tipo Saldo"		,"mv_ch3","C",01,0,0,"G","","SLW","","","mv_par03",""		,"","","","","","","","","","","","","","","","","","","","")

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
Programa	: GECTBR29
Funcao		: Função Estatica  - AjustaSX6
Data		: 25/05/2015
Autor		: André Costa
Descricao	: Função de Apoio
Uso			: Ajusta os Parametros do Relatorio
Sintaxe	: AjustaSX6()
Chamenda	: Interna
Retorno	: Conteudo do Parametro
*/


Static Function AjustaSX6
	Local aArea		:= GetArea()
	Local _MVConta	:= GetMV("MV_XRCTB29",.F.,'')
	
	Begin Sequence
	
		If !Empty( _MVConta )
			Break
		EndIf
	
		DbSelectArea("SX6")  // abre arquivo temporário    
		SX6->( DbSetOrder(1) )

		If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XRCTB29" , .F. ) )
			Conout('Parametro MV_XRCTB29 Criado')
			RecLock( "SX6",.T. )
				SX6->X6_VAR     := "MV_XRCTB29"
				SX6->X6_TIPO    := "C"
				SX6->X6_CONTEUD := "811101|811104|811105|811107|812101|812203|812204"
				SX6->X6_CONTSPA := "811101|811104|811105|811107|812101|812203|812204"
				SX6->X6_CONTENG := "811101|811104|811105|811107|812101|812203|812204"
			                       
				SX6->X6_DESCRIC := "Contas a serem utilizadas no relatorio"
				SX6->X6_DESC1   := "Pis/Confis Debito"
				SX6->X6_DSCSPA  := "Contas a serem utilizadas no relatorio"
				SX6->X6_DSCSPA1 := "Pis/Confis Debito"
				SX6->X6_DSCENG  := "Contas a serem utilizadas no relatorio"
				SX6->X6_DSCENG1 := "Pis/Confis Debito"
			MsUnLock()
		EndIf
		
	End Sequence

	RestArea(aArea)
	
Return( _MVConta )

