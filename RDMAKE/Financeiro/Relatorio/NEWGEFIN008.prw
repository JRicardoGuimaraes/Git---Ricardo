#Include 'Protheus.ch'

#Define PICT_VALOR01 "@E 9,999,999.99"

User Function NEWGEFIN008		// U_NEWGEFIN008()

	Local aArea	:=	GetArea()
	Local cPerg	:= Padr("GEFIN008",10)
	Local oReport	:= Nil

	Private aDadosDb	:= {}
	Private aUO		:= {	{"1","RDVM"	,"01|02"	}	,;
								{"2","ILI"		,"21"		}	,;
								{"3","RMLAP"	,"11"		}	,;
								{"4","RMA"		,"22|23"	}	,;
								{"5","SCC"		,""			}	 ;
							}
	Begin Sequence

		If ! ( Pergunte( cPerg , .T. ) )
			Break
		EndIf

		If ! ( ValidPDD() )
			Break
		EndIf

		oReport := ModelReport()
		oReport:PrintDialog()

	End Sequence

	RestArea( aArea )

Return



Static Function ModelReport
	Local aArea 		:= GetArea()
	Local oReport		:= Nil
	Local oSection	:= Nil
	Local oBreak		:= Nil
	Local oBreak1		:= Nil
	Local lLandscape	:= .T.

	oReport := TReport():New("GEFIN008","Relação PDD","GEFIN008",{ |oReport| PrintReport( oReport ) },"Relação PDD",lLandscape,/*uTotalText*/,/*lTotalInLine*/,/*cPageTText*/,/*lPageTInLine*/,/*lTPageBreak*/,5)

	For X := 1 To Len( aUO )

		oSection	:= 'oSection'	+ cValToChar(X)
		oBreak		:= 'oBreak'	+ cValToChar(X)
		oBreak1	:= 'oBreak1'	+ cValToChar(X)

		&oSection := TRSection():New( oReport , aUO[X][2] )
		&oSection:SetLineBreak(.F.)
		&oSection:SetHeaderBreak( .T. )
		&oSection:SetHeaderSection( .T. )
		&oSection:SetPageBreak(.F.)
		&oSection:SetTotalInLine(.F.)

		TRCell():New(&oSection,"UO"				,,"UO"						,'@!'												,06												, .T.,/*{|| }*/,,,"Left")
		TRCell():New(&oSection,"E1_FILIAL"		,,"Filial"					,GetSx3Cache("E1_FILIAL"		,"X3_PICTURE")	,GetSx3Cache("E1_FILIAL"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"Left")
		TRCell():New(&oSection,"E1_CLIENTE"	,,"Cliente"				,GetSx3Cache("A1_COD"		,"X3_PICTURE")	,GetSx3Cache("A1_COD"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"Left")
		TRCell():New(&oSection,"E1_LOJA"		,,"Loja"					,GetSx3Cache("A1_LOJA"		,"X3_PICTURE")	,GetSx3Cache("A1_LOJA"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"Left")
		TRCell():New(&oSection,"A1_NOME"		,,"Nome"					,GetSx3Cache("A1_NOME"		,"X3_PICTURE")	,GetSx3Cache("A1_NOME"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"Left")
		TRCell():New(&oSection,"E1_PREFIXO"	,,"Prefixo"				,GetSx3Cache("E1_PREFIXO"	,"X3_PICTURE")	,GetSx3Cache("E1_PREFIXO"	,"X3_TAMANHO"), .T.,/*{|| }*/,,,"Left")
		TRCell():New(&oSection,"E1_NUM"			,,"Numero"					,GetSx3Cache("E1_NUM"		,"X3_PICTURE")	,GetSx3Cache("E1_NUM"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"Left")
		TRCell():New(&oSection,"E1_PARCELA"	,,"Parcela"				,GetSx3Cache("E1_PARCELA"	,"X3_PICTURE")	,GetSx3Cache("E1_PARCELA"	,"X3_TAMANHO"), .T.,/*{|| }*/,,,"Left")
		TRCell():New(&oSection,"E1_EMISSAO"	,,"Emissao"				,GetSx3Cache("E1_EMISSAO"	,"X3_PICTURE")	,GetSx3Cache("E1_EMISSAO"	,"X3_TAMANHO"), .T.,/*{|| }*/,,,"Left")
		TRCell():New(&oSection,"E1_VENCREA"	,,"Venc. Real"			,GetSx3Cache("E1_VENCREA"	,"X3_PICTURE")	,GetSx3Cache("E1_VENCREA"	,"X3_TAMANHO"), .T.,/*{|| }*/,,,"Left")
		TRCell():New(&oSection,"DIASATRASO"	,,"Dias Atraso"			,'999999'											,06												, .T.,/*{|| }*/,,,"RIGHT")
		TRCell():New(&oSection,"50%"			,,"50% Val. 90 - 180"	,PICT_VALOR01										,GetSx3Cache("E1_VALOR"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
		TRCell():New(&oSection,"75%"			,,"75% Val. 181 - 365"	,PICT_VALOR01										,GetSx3Cache("E1_VALOR"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
		TRCell():New(&oSection,"100%"			,,"100% Val. > 365"		,PICT_VALOR01										,GetSx3Cache("E1_VALOR"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
		TRCell():New(&oSection,"VENCIDOS"		,,"Vencidos"				,PICT_VALOR01										,GetSx3Cache("E1_VALOR"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
		TRCell():New(&oSection,"CCUSTO"			,,"Centro de Custo"		,PICT_VALOR01										,GetSx3Cache("E1_CCONT"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")

		&oBreak	:= TRBreak():New(&oSection,&oSection:Cell("A1_NOME"),,.F.)
		&oBreak1	:= TRBreak():New(&oSection,&oSection:Cell("UO")		,,.F.)

		TRFunction():New(&oSection:Cell("A1_NOME"),"Total Cliente"			,"SUM",&oBreak	,,GetSx3Cache("E1_VALOR","X3_PICTURE"),,.F.,.F.)
		TRFunction():New(&oSection:Cell("UO")		,"Total " + aUO[X][2]	,"SUM",&oBreak1	,,GetSx3Cache("E1_VALOR","X3_PICTURE"),,.F.,.F.)

	Next X

	RestArea( aArea )

Return( oReport )

Static Function PrintReport(oReport)
	Local aArea		:= GetArea()
	Local DbTrab		:= GetNextAlias()
	Local DbTrab01	:= GetNextAlias()
	Local aQuery		:= {}
	Local cQuery		:= ''
	Local nPosUO		:= 0
	Local nPosCli		:= 0
	Local aStruSE1	:= SE1->( DbStruct() )

	If Select( "DbTrab" ) # 0
		( DbTrab )->( DbCloseArea() )
	EndIf

	cQuery :=	"Select Case "

	For Y := 1 To Len( aUO )
		cQuery +=  " When SubString( SE1.E1_CCONT , 2 , 2 )	In " + FormatIn(aUO[Y][3],"|") + " Then '" + aUO[Y][2] + "' "
	Next Y

	cQuery += "	Else 'SCC' 	End	'UO' "

	cQuery += "			SA1.A1_NOME,																							"
	cQuery +=	"			SE1.E1_FILIAL		,SE1.E1_PREFIXO	,SE1.E1_NUM		,SE1.E1_PARCELA	,SE1.E1_TIPO		,	"
	cQuery +=	"			SE1.E1_CLIENTE	,SE1.E1_LOJA		,SE1.E1_MOEDA		,SE1.E1_CCONT  	,SE1.E1_EMISSAO	,	"
	cQuery +=	"			SE1.E1_VENCREA	,SE1.E1_VENCTO	,SE1.E1_VALOR		,SE1.E1_SALDO		,SE1.E1_SDACRES	,	"
	cQuery +=	"			SE1.E1_ACRESC		,SE1.E1_DECRESC	,SE1.E1_SDDECRE	,SA1.A1_XGRPCLI						,	"
	cQuery +=	"	From " + RetSqlName("SE1") + " SE1, " +	RetSqlName("SA1") +  " SA1           						"
	cQuery +=	"	Where		SE1.D_E_L_E_T_ == '' 																			"
	cQuery +=	"		And		SA1.D_E_L_E_T_ == '' 																			"
	cQuery +=	"		And		E1_EMISSAO BetWeen '" + DtoS( MV_PAR05 )	+	"' AND '" + DtoS( MV_PAR06 ) + "'			"
	cQuery +=	"		And		E1_VENCTO	<= '"  + DtoS( MV_PAR07 - 90 )	+	"'												"
	cQuery +=	"		And		E1_MOEDA	= '1' 																					"
	cQuery +=	"		And		E1_TIPO	<> 'NCC'																				"
	cQuery +=	"		And		E1_SALDO	<> 0																					"
	cQuery +=	"		And		E1_CLIENTE = A1_COD																				"
	cQuery +=	"		And		E1_LOJA    = A1_LOJA																				"

	If ! Empty( MV_PAR08 )
		cQuery += " And A1_GRUPO IN " + FormatIn( AllTrim( MV_PAR08 ) , "," )
	EndIf

	nPosUo := aScan( aUO , { |Z| cValToChar( MV_PAR02 ) == Z[1] } )

	If ! ( cValToChar( nPosUO ) == '5' )
		cQuery += " And ( SubString( SE1.E1_CCONT , 2 , 2 ) IN " + FormatIn( aUO[nPosUO][3] , "|" )
	EndIf

	cQuery +=	"Order By E1_FILIAL,UO,A1_XGRPCLI,SubString(E1_CCONT,2,2),SA1.A1_NOME,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO "

	DbUseArea( .T. , "TopConn" , TCGenQry( ,,cQuery ) , 'DbTrab' , .F. , .T. )

	For X := 1 to Len(aStru)

		If ( aStruSE1[X][2] $ 'DNL')
			TCSetField( 'DbTrab' , aStruSE1[X][1] , aStruSE1[X][2] , aStruSE1[X][3] , aStruSE1[X][4] )
		EndIf

	Next X


	While !oReport:Cancel() .And. ( DbTrab )->( !Eof() )


		xFilial		:= ( DbTrab )->E1_FILIAL
		xUO				:= ( DbTrab )->UO
		xE1_CLIENTE	:= ( DbTrab )->E1_CLIENTE
		xE1_LOJA		:= ( DbTrab )->E1_LOJA

		While	!oReport:Cancel()																				.And. ;
				xFilial+xUO+xE1_CLIENTE+xE1_LOJA == ( DbTrab )->(E1_FILIAL+UO+E1_CLIENTE+E1_LOJA) 	.And. ;
				( DbTrab )->( !Eof() )


			( DbTrab )->( DbSkip() )

		End While

		oReport:IncMeter()

	End While

	RestArea( aArea )

Return
/*

Store 0 To xVal050,xVal075,xVal100,xDiasAtraso,xValVencido,xTotVencido

		xFilial		:= ( DbTrab )->E1_FILIAL
		xUO				:= ( DbTrab )->UO
		xE1_CLIENTE	:= ( DbTrab )->E1_CLIENTE
		xE1_LOJA		:= ( DbTrab )->E1_LOJA

		While	!oReport:Cancel()																				.And. ;
				xFilial+xUO+xE1_CLIENTE+xE1_LOJA == ( DbTrab )->(E1_FILIAL+UO+E1_CLIENTE+E1_LOJA) 	.And. ;
				( DbTrab )->( !Eof() )

			nQtdeDias := ( MV_PAR07 - ( DbTrab )->E1_VENCREA )

			If MV_PAR01 == 1
				xDiasAtraso += nQtdeDias
			Else
				xDiasAtraso := IIf( xDiasAtraso < nQtdeDias, nQtdeDias, xDiasAtraso )
			EndIf

			If nQtdeDias >= 90 .And. nQtdeDias <= 180
				xVal050 += ( ( DbTrab )->E1_VALOR * 0.50 )

			ElseIf nQtdeDias >= 181 .And. nQtdeDias <= 365
				xVal075 += ( ( DbTrab )->E1_VALOR * 0.75 )

			ElseIf nQtdeDias > 365
				xVal100 += ( DbTrab )->E1_VALOR

			EndIf

			xTotVencido := xVal050 + xVal075 + xVal100

			( DbTrab )->( DbSkip() )

		End While

		aDadosDb[nPosUO][2][nPosCli][10] := aDadosDb[nPosUO][2][nPosCli][05] + aDadosDb[nPosUO][2][nPosCli][06] + aDadosDb[nPosUO][2][nPosCli][07]


	For Z := 1 To Len( aDadosDb )

		nPos := aScan( aUO , { |A| A[2] == AllTrim( aDadosDb[Z][1]) } )

		If nPos == 0
			Loop
		EndIf

		oReport:Section(nPos):Cell("UO"):Disable()

		If MV_PAR04 # 1

			oReport:Section(nPos):Cell("E1_FILIAL"):Disable()
			oReport:Section(nPos):Cell("E1_CLIENTE"):Disable()
			oReport:Section(nPos):Cell("E1_LOJA"):Disable()
			oReport:Section(nPos):Cell("E1_PREFIXO"):Disable()
			oReport:Section(nPos):Cell("E1_NUM"):Disable()
			oReport:Section(nPos):Cell("E1_PARCELA"):Disable()
			oReport:Section(nPos):Cell("E1_EMISSAO"):Disable()
			oReport:Section(nPos):Cell("E1_VENCREA"):Disable()
			oReport:Section(nPos):Cell("CCUSTO"):Disable()

		EndIf


		oReport:SetMeter( Len( aDadosDb[Z][2] ) )

		oReport:Section(nPos):Init()

		oReport:Section(nPos):SetHeaderSection(.T.)

		oReport:Section(nPos):Cell("UO"):SetValue(aDadosDb[Z][1])

		For Y := 1 To Len( aDadosDb[Z][2] )

			oReport:Section(nPos):Cell("A1_NOME"):SetValue(aDadosDb[Z][2][Y][03])
			oReport:Section(nPos):Cell("DIASATRASO"):SetValue(aDadosDb[Z][2][Y][04])
			oReport:Section(nPos):Cell("50%"):SetValue(aDadosDb[Z][2][Y][05])
			oReport:Section(nPos):Cell("75%"):SetValue(aDadosDb[Z][2][Y][06])
			oReport:Section(nPos):Cell("100%"):SetValue(aDadosDb[Z][2][Y][07])
			oReport:Section(nPos):Cell("VENCIDOS"):SetValue(aDadosDb[Z][2][Y][10])

			For X := 1 To Len( aDadosDb[Z][2][Y][12] )

				oReport:Section(nPos):Cell("E1_FILIAL"):SetValue(aDadosDb[Z][2][Y][12][X][1])
				oReport:Section(nPos):Cell("E1_PREFIXO"):SetValue(aDadosDb[Z][2][Y][12][X][2])
				oReport:Section(nPos):Cell("E1_NUM"):SetValue(aDadosDb[Z][2][Y][12][X][3])
				oReport:Section(nPos):Cell("E1_PARCELA"):SetValue(aDadosDb[Z][2][Y][12][X][4])
				oReport:Section(nPos):Cell("E1_EMISSAO"):SetValue(aDadosDb[Z][2][Y][12][X][5])
				oReport:Section(nPos):Cell("E1_VENCREA"):SetValue(aDadosDb[Z][2][Y][12][X][6])
				oReport:Section(nPos):Cell("CCUSTO"):SetValue(aDadosDb[Z][2][Y][12][X][7])

			Next X

			oReport:IncMeter()

			oReport:Section(nPos):PrintLine()

		Next Y

		oReport:Section(nPos):Finish()

	Next Z
*/


Static Function ValidPDD					// StaticCall( NEWGEFIN008 , ValidPDD )
	Local aArea		:= GetArea()
	Local lRetorno	:= .T.
	Local DbTrab		:= GetNextAlias()
	Local xSelect		:= ''
	Local aQuery

	Begin Sequence

		If MV_PAR03 # 1
			Break
		EndIf

		xSelect := "Sum( Z9_M" + StrZero( Month( MV_PAR07 ) , 2 ) + " ) As MES "
		xSelect := "%"+xSelect+"%"

		BeginSql Alias DbTrab

			Select %Exp:xSelect%

 			From %Table:SZ9% SZ9

			Where (		SZ9.%NotDel%
						And	SZ9.Z9_FILIAL	=	%Exp:xFilial("SZ9")%
						And	SZ9.Z9_ANO		=	%Exp:AllTrim( Str( Year( MV_PAR07 ) ) )%
					)

		EndSql

		aQuery := GetLastQuery()

		If (DbTrab)->MES # 0
			MsgAlert("A Data do PDD já foi processada." + Chr(10) + "Informe outro período!","Atenção !")
			lRetorno := .F.
		EndIf

	End Sequence

	If Select( DbTrab ) # 0
		(DbTrab)->( DbCloseArea() )
	EndIf

	RestArea( aArea )

Return( lRetorno )
