#Include 'Protheus.ch'

#Define TAM02 2
#Define TAM06 6
#Define TAM60 60

User Function GEFFINR8		// u_GEFFINR8()

	Local aArea	:=	GetArea()
	Local cPerg	:= Padr("GEFFINR8",10)

	Private oReport := Nil

	Private lEnd			:= .F.
	Private lAbortPrint	:= .F.

	Private dDataAnt
	Private dDataAtu
	Private nMesAnt
	Private nMesAtu
	Private cMountAtu
	Private cMountAtu
	Private cTRABDB
	Private DbTrab
	Private aUO		:= {	{"1","RDVM"			,"01|02"	}	,;
								{"2","ILI"				,"21"		}	,;
								{"3","RMLAP"			,"11"		}	,;
								{"4","RMA"				,"22|23"	}	,;
								{"5","SCC"				,""			}	,;
								{"6","TOTAL GERAL"	,""			}	 ;
							}
	Private aContabil := {}
	Private aTotais := Afill( Array( 7 ) , 0 )

	Begin Sequence

		If ! ( Pergunte( cPerg , .T. ) )
			Break
		EndIf

		dDataAtu	:= MV_PAR07
		nMesAtu	:= StrZero( Month( dDataAtu ) , 2 )
		cMountAtu	:= SubStr( cMonth( dDataAtu ) , 1 , 3 )

		dDataAnt	:= LastDay( dDataAtu - 31 , 2 )
		nMesAnt	:= StrZero( Month( dDataAnt ) , 2 )
		cMountAnt	:= SubStr( cMonth( dDataAnt ) , 1 , 3 )

		If ! ( ValidPDD() )
			Break
		EndIf

		oReport := ModelReport()
		oReport:PrintDialog()

		If lEnd

			If MV_PAR03 == 1 .And. ( Aviso("Atenção", "Será feita a contabilização dos valores apresentados no relatório.  Deseja realmente continuar?", { "Sim","Nao" } , 2 ) == 1 )
				CtbCred()
				SaveSZ9()
			EndIf

		EndIf

		If Select("dTRABDB") # 0
			dTRABDB->( DbCloseArea() )
		EndIf

	End Sequence

	SZ9->( DbCloSeArea() )

	RestArea( aArea )

Return


Static Function ModelReport
	Local aArea 		:= GetArea()
	Local oSection	:= Nil
	Local oBreak		:= Nil
	Local oUO			:= Nil
	Local oA1GRUPO	:= Nil
	Local lLandscape	:= .T.

	oReport := TReport():New("GEFFINR8","Relação PDD","GEFFINR8",{ |oReport| PrintReport( oReport ) },"Relação PDD",lLandscape,/*uTotalText*/,/*lTotalInLine*/,/*cPageTText*/,/*lPageTInLine*/,/*lTPageBreak*/,2)
	oReport:ShowParamPage()
	oReport:ParamReadOnly(.T.)

	For X := 1 To Len( aUO )

		oSection 	:= 'oSection'+cValToChar(X)

		&oSection := TRSection():New(oReport,aUO[X][2],/*uTable*/,/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/,/*uTotalText*/,/*lTotalInLine*/,/*lHeaderPage*/,/*lHeaderBreak*/,/*lPageBreak*/,/*lLineBreak*/,/*nLeftMargin*/,/*lLineStyle*/,/*nColSpace*/,.T.,/*cCharSeparator*/,/*nLinesBefore*/,/*nCols*/,/*nClrBack*/,/*nClrFore*/,/*nPercentage*/)

		&oSection:SetLineBreak(.F.)
		&oSection:SetHeaderBreak( .T. )
		&oSection:SetHeaderSection( .T. )
		&oSection:SetPageBreak(.T.)
		&oSection:SetTotalInLine(.F.)
		&oSection:SetTotalPageBreak(.F.)
		&oSection:SetTotalText("Total " + aUO[X][2] + " :" )

		oUO := TRCell():New(&oSection,"UO"	,"dTRABDB","UO"					,'@!'												,06												, .T.,/*{|| }*/,,,"Left")
		oUO:Disable()

		oA1GRUPO := TRCell():New(&oSection,"A1GRUPO"	,"dTRABDB","Grupo"	,GetSx3Cache("A1_GRUPO"		,"X3_PICTURE")	,GetSx3Cache("A1_GRUPO"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
		oA1GRUPO:Disable()

		TRCell():New(&oSection,"E1CLIENTE"	,"dTRABDB","Codigo"				,GetSx3Cache("A1_COD"		,"X3_PICTURE")	,GetSx3Cache("A1_COD"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"Left")
		TRCell():New(&oSection,"E1LOJA"		,"dTRABDB","Loja"					,GetSx3Cache("A1_LOJA"		,"X3_PICTURE")	,GetSx3Cache("A1_LOJA"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"Left")

		TRCell():New(&oSection,"A1NOME"		,"dTRABDB","Cliente"				,GetSx3Cache("A1_NOME"		,"X3_PICTURE")	,GetSx3Cache("A1_NOME"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"Left")

		TRCell():New(&oSection,"DIASATRASO","dTRABDB","Atraso"				,'999999'											,06												, .T.,/*{|| }*/,,,"RIGHT")

		TRCell():New(&oSection,"VAL050"		,"dTRABDB","50% 90 - 180"		,GetSx3Cache("E1_VALOR"		,"X3_PICTURE")	,GetSx3Cache("E1_VALOR"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
		TRCell():New(&oSection,"VAL075"		,"dTRABDB","75% 181 - 365"		,GetSx3Cache("E1_VALOR"		,"X3_PICTURE")	,GetSx3Cache("E1_VALOR"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
		TRCell():New(&oSection,"VAL100"		,"dTRABDB","100% > 365"			,GetSx3Cache("E1_VALOR"		,"X3_PICTURE")	,GetSx3Cache("E1_VALOR"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
		TRCell():New(&oSection,"VENCIDOS"	,"dTRABDB","Vencidos"			,GetSx3Cache("E1_VALOR"		,"X3_PICTURE")	,GetSx3Cache("E1_VALOR"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
		TRCell():New(&oSection,"PDDANT"		,"dTRABDB","PDD " + cMountAnt	,GetSx3Cache("E1_VALOR"		,"X3_PICTURE")	,GetSx3Cache("E1_VALOR"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
		TRCell():New(&oSection,"PDDATU"		,"dTRABDB","PDD " + cMountAtu	,GetSx3Cache("E1_VALOR"		,"X3_PICTURE")	,GetSx3Cache("E1_VALOR"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
		TRCell():New(&oSection,"VARIACAO"	,"dTRABDB","Variacao"			,GetSx3Cache("E1_VALOR"		,"X3_PICTURE")	,GetSx3Cache("E1_VALOR"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")

		If MV_PAR04 == 1
			TRCell():New(&oSection,"E1FILIAL"	,"dTRABDB","Fil."				,GetSx3Cache("E1_FILIAL"		,"X3_PICTURE")	,GetSx3Cache("E1_FILIAL"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
			TRCell():New(&oSection,"E1PREFIXO"	,"dTRABDB","Pref."			,GetSx3Cache("E1_PREFIXO"	,"X3_PICTURE")	,GetSx3Cache("E1_PREFIXO"	,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
			TRCell():New(&oSection,"E1NUM"		,"dTRABDB","Numero"			,GetSx3Cache("E1_NUM"		,"X3_PICTURE")	,GetSx3Cache("E1_NUM"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
			TRCell():New(&oSection,"E1PARCELA"	,"dTRABDB","Parc."			,GetSx3Cache("E1_PARCELA"	,"X3_PICTURE")	,GetSx3Cache("E1_PARCELA"	,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
			TRCell():New(&oSection,"E1EMISSAO"	,"dTRABDB","Emissao"			,GetSx3Cache("E1_EMISSAO"	,"X3_PICTURE")	,GetSx3Cache("E1_EMISSAO"	,"X3_TAMANHO"), .T.,/*{|| }*/,,,"Left")
			TRCell():New(&oSection,"E1VENCREA"	,"dTRABDB","Venc. Real"		,GetSx3Cache("E1_VENCREA"	,"X3_PICTURE")	,GetSx3Cache("E1_VENCREA"	,"X3_TAMANHO"), .T.,/*{|| }*/,,,"Left")
			TRCell():New(&oSection,"E1CCONT"	,"dTRABDB","C.Custo"			,GetSx3Cache("E1_CCONT"		,"X3_PICTURE")	,GetSx3Cache("E1_CCONT"		,"X3_TAMANHO"), .T.,/*{|| }*/,,,"RIGHT")
		EndIf

		If X # Len( aUO )

			oBreak	:= 'oBreak'+cValToChar(X)
			oBreak	:= TRBreak():New(&oSection,&oSection:Cell("UO"),,.F.)

			TRFunction():New(&oSection:Cell("VAL050")		,Nil,"SUM",oBreak,/*cTitle*/,GetSx3Cache("E1_VALOR"	,"X3_PICTURE"),/*uFormula*/,.T.,.F.,/*lEndPage*/,/*oParent*/,/*bCondition*/,/*lDisable*/,/*bCanPrint*/)
			TRFunction():New(&oSection:Cell("VAL075")		,Nil,"SUM",oBreak,/*cTitle*/,GetSx3Cache("E1_VALOR"	,"X3_PICTURE"),/*uFormula*/,.T.,.F.,/*lEndPage*/,/*oParent*/,/*bCondition*/,/*lDisable*/,/*bCanPrint*/)
			TRFunction():New(&oSection:Cell("VAL100")		,Nil,"SUM",oBreak,/*cTitle*/,GetSx3Cache("E1_VALOR"	,"X3_PICTURE"),/*uFormula*/,.T.,.F.,/*lEndPage*/,/*oParent*/,/*bCondition*/,/*lDisable*/,/*bCanPrint*/)
			TRFunction():New(&oSection:Cell("VENCIDOS") 	,Nil,"SUM",oBreak,/*cTitle*/,GetSx3Cache("E1_VALOR"	,"X3_PICTURE"),/*uFormula*/,.T.,.F.,/*lEndPage*/,/*oParent*/,/*bCondition*/,/*lDisable*/,/*bCanPrint*/)
			TRFunction():New(&oSection:Cell("PDDANT")		,Nil,"SUM",oBreak,/*cTitle*/,GetSx3Cache("E1_VALOR"	,"X3_PICTURE"),/*uFormula*/,.T.,.F.,/*lEndPage*/,/*oParent*/,/*bCondition*/,/*lDisable*/,/*bCanPrint*/)
			TRFunction():New(&oSection:Cell("PDDATU")		,Nil,"SUM",oBreak,/*cTitle*/,GetSx3Cache("E1_VALOR"	,"X3_PICTURE"),/*uFormula*/,.T.,.F.,/*lEndPage*/,/*oParent*/,/*bCondition*/,/*lDisable*/,/*bCanPrint*/)
			TRFunction():New(&oSection:Cell("VARIACAO")	,Nil,"SUM",oBreak,/*cTitle*/,GetSx3Cache("E1_VALOR"	,"X3_PICTURE"),/*uFormula*/,.T.,.F.,/*lEndPage*/,/*oParent*/,/*bCondition*/,/*lDisable*/,/*bCanPrint*/)

		EndIf

	Next X

	RestArea( aArea )

Return( oReport )

Static Function PrintReport(oReport)
	Local aArea		:= GetArea()
	Local oSection	:= Nil
	Local oTotais  	:= oReport:Section(6)

	lEnd := .T.

	Begin Sequence

		xBuildInfo()

		If !lEnd
			Break
		EndIf

		For Z := 1 To ( Len( aUO ) - 1 )

			StaticCall( GEFRGPO2 , ChkAbort )

			If oReport:Cancel() .Or. !lEnd
				lEnd := .F.
				Exit
			EndIf

			DbSelectArea( "dTRABDB" )

			DbSetFilter( {|| AllTrim( dTRABDB->UO ) == AllTrim( aUO[Z][2] ) } , 'AllTrim( dTRABDB->UO ) == AllTrim( aUO[Z][2] )' )

			dTRABDB->( DbGoBottom() )
			dTRABDB->( DbGoTop() )

			If dTRABDB->(Eof())
				DBClearFilter()
				Loop
			EndIf

			oSection := oReport:Section(Z)

			oReport:SetTitle('RELATORIO DE PDD' + IIf( MV_PAR04 == 1 ," ANALITICO"," SINTETICO" ) + " - " + aUO[Z][2] )

			oReport:SetMsgPrint("Imprimindo Registros do PDD.")

			oReport:SetMeter( dTRABDB->( LastRec() ) )

			dTRABDB->( DbGoTop() )

			oSection:Init()
			oSection:SetHeaderSection(.T.)

			While	!oReport:Cancel()		.And.	;
					lEnd					.And.	;
					dTRABDB->( !Eof() )

				StaticCall( GEFRGPO2 , ChkAbort )

				xUO			:= dTRABDB->UO
				xA1GRUPO	:= dTRABDB->A1GRUPO
				xCliente	:= dTRABDB->E1CLIENTE
				xLoja		:= dTRABDB->E1LOJA

				While !oReport:Cancel()																			.And.	;
						xUO+xA1GRUPO+xCLIENTE+xLOJA == dTRABDB->( UO + A1GRUPO + E1CLIENTE + E1LOJA )	.And.	;
						lEnd																						.And.	;
						dTRABDB->( !Eof() )

					StaticCall( GEFRGPO2 , ChkAbort )

					If MV_PAR04 == 1 .And. oReport:nDevice # 4
						oSection:Cell("A1NOME"):SetSize(25,.T.)
					EndIf

					oReport:IncMeter()

					oSection:PrintLine()

					If MV_PAR04 == 1 .And. oReport:nDevice # 4
						oSection:Cell("E1CLIENTE"):Hide()
						oSection:Cell("E1LOJA"):Hide()
						oSection:Cell("A1NOME"):Hide()
						oSection:Cell("PDDANT"):Hide()
						oSection:Cell("PDDATU"):Hide()
						oSection:Cell("VARIACAO"):Hide()
					EndIf

					dTRABDB->( DbSkip() )

	 			End While

				If MV_PAR04 == 1 .And. oReport:nDevice # 4
					oSection:Cell("E1CLIENTE"):Show()
					oSection:Cell("E1LOJA"):Show()
					oSection:Cell("A1NOME"):Show()
					oSection:Cell("PDDANT"):Show()
					oSection:Cell("PDDATU"):Show()
					oSection:Cell("VARIACAO"):Show()
				EndIf

			End While

			oSection:Finish()

			DbClearFilter()

		Next Z

		oReport:SetTitle('RELATORIO DE PDD ' + IIf( MV_PAR04 == 1 ," ANALITICO "," SINTETICO" ) + " - " + aUO[6][2] )

		oTotais:Cell("E1CLIENTE"):Disable()
		oTotais:Cell("E1LOJA"):Disable()
		oTotais:Cell("A1NOME"):Disable()
		oTotais:Cell("DIASATRASO"):Disable()

		If MV_PAR04 == 1
			oTotais:Cell("E1FILIAL"):Disable()
			oTotais:Cell("E1PREFIXO"	):Disable()
			oTotais:Cell("E1NUM"):Disable()
			oTotais:Cell("E1PARCELA"):Disable()
			oTotais:Cell("E1EMISSAO"):Disable()
			oTotais:Cell("E1VENCREA"):Disable()
			oTotais:Cell("E1CCONT"):Disable()
		EndIf

		oTotais:Init()

		oTotais:Cell("VAL050"):SetBlock( { || aTotais[1] } )
		oTotais:Cell("VAL075"):SetBlock( { || aTotais[2] } )
		oTotais:Cell("VAL100"):SetBlock( { || aTotais[3] } )
		oTotais:Cell("VENCIDOS"):SetBlock( { || aTotais[4] } )
		oTotais:Cell("PDDANT"):SetBlock( { || aTotais[5] } )
		oTotais:Cell("PDDATU"):SetBlock( { || aTotais[6] } )
		oTotais:Cell("VARIACAO"):SetBlock( { || aTotais[7] } )

		oTotais:PrintLine()

		oTotais:Finish()

	End Sequence

	If File(cTRABDB)
		fErase(cTRABDB)
	EndIf

	RestArea( aArea )

Return


Static Function xBuildInfo
	Local aArea		:= GetArea()
	Local cWhere		:= ''
	Local cSelect		:= ''
	Local cOrder		:= ''
	Local xWhile		:= '.T.'
	Local nInteiro 	:= TamSX3("E1_VALOR")[1]
	Local nDecimal	:= TamSX3("E1_VALOR")[2]
	Local nPosUO		:= 0
	Local nPosCli		:= 0
	Local aQuery
	Local nContTit

	Begin Sequence

		xCriaArq()

		If !lEnd
			Break
		EndIf

		nPosUo := aScan( aUO , { |Z| cValToChar( MV_PAR02 ) == Z[1] } )

		If cValToChar( nPosUO ) # '5'
			cWhere += " And SubString( SE1.E1_CCONT , 2 , 2 ) IN " + FormatIn(aUO[nPosUO][3],"|")
		EndIf

		If ! Empty( MV_PAR08 )
			cWhere += " And A1_GRUPO IN " + FormatIn(AllTrim(MV_PAR08),",")
		EndIf

		cWhere += " And E1_TIPO Not IN ('NCC','RA ')"

		cWhere	:= "%" + cWhere + "%"

		For X := 1 To 2

			StaticCall( GEFRGPO2 , ChkAbort )

			If !lEnd
				Exit
			EndIf

			If Select( "DbTrab" ) # 0
				( DbTrab )->( DbCloseArea() )
			EndIf

			DbTrab	:= GetNextAlias()

			cSelect := "	Count(*) As Qtde"
			cOrder	 := " QTDE "

			If X = 2

				cSelect := "	Case "

				For Y := 1 To Len( aUO )
					cSelect +=  " When SubString( SE1.E1_CCONT , 2 , 2 )	In " + FormatIn(aUO[Y][3],"|") + " Then '" + aUO[Y][2] + "' "
				Next Y

				cSelect += "	Else 'SCC' 	End	'UO'																				"
				cSelect += " ,SA1.A1_NOME		,																					"
				cSelect += " 	SE1.E1_FILIAL		,SE1.E1_PREFIXO	,SE1.E1_NUM		,SE1.E1_PARCELA	,SE1.E1_TIPO		,	"
				cSelect += " 	SE1.E1_CLIENTE	,SE1.E1_LOJA		,SE1.E1_MOEDA		,SE1.E1_CCONT  	,SE1.E1_EMISSAO	,	"
				cSelect += " 	SE1.E1_VENCREA	,SE1.E1_VENCTO	,SE1.E1_VALOR		,SE1.E1_SALDO		,SE1.E1_SDACRES	,	"
				cSelect += " 	SE1.E1_ACRESC		,SE1.E1_DECRESC	,SE1.E1_SDDECRE	,SA1.A1_XGRPCLI							"

				cOrder	 := ' UO,A1_XGRPCLI,E1_CLIENTE,E1_LOJA'

			EndIf

			cSelect := "%" + cSelect + "%"
			cOrder	:= "%" + cOrder + "%"

			BeginSql Alias DbTrab

				 Column E1_EMISSAO	As Date
				 Column E1_VENCREA	As Date
				 Column E1_VENCTO		As Date
				 Column E1_VALOR		As Numeric(nInteiro,nDecimal)
				 Column E1_SALDO		As Numeric(nInteiro,nDecimal)
				 Column E1_SDACRES	As Numeric(nInteiro,nDecimal)
				 Column E1_ACRESC		As Numeric(nInteiro,nDecimal)
				 Column E1_DECRESC	As Numeric(nInteiro,nDecimal)
				 Column E1_SDDECRE	As Numeric(nInteiro,nDecimal)

				Select	%Exp:cSelect%

				From	%Table:SE1% SE1,
						%Table:SA1% SA1

				Where (		SE1.%NotDel%
							And	SA1.%NotDel%
							And	SE1.E1_EMISSAO BetWeen %Exp:DtoS( MV_PAR05 )% And %Exp:DtoS( MV_PAR06 )%
							And	SE1.E1_VENCTO <=	%Exp:DtoS( dDataAtu - 90 )%
							And	SE1.E1_MOEDA	= '1'
							And	SA1.A1_XGPDD	= '1'
							And	SE1.E1_SALDO	<> 0
							And	SE1.E1_CLIENTE = SA1.A1_COD
							And	SE1.E1_LOJA	 = SA1.A1_LOJA
						)

				%Exp:cWhere%

				Order By %Exp:cOrder%

			EndSql

			If X == 1
				nQtdeReg := ( DbTrab )->( Qtde )
			EndIf

		Next X

		If !lEnd
			Break
		EndIf

		aQuery := GetLastQuery()

		( DbTrab )->( DbGoTop() )

		If ( DbTrab )->( Eof() )
			lEnd := .F.
		EndIf

		If MV_PAR04 == 2
			xWhile :=	'xUO+xGRPCLI+xE1CLIENTE+xE1LOJA == ( DbTrab )->(AllTrim(UO)+A1_XGRPCLI+E1_CLIENTE+E1_LOJA)
		EndIf

		oReport:SetMeter( nQtdeReg )

		nCountReg = 0

		While	! oReport:Cancel()		.And.	;
				lEnd						.And.	;
				( DbTrab )->( !Eof() )

			StaticCall( GEFRGPO2 , ChkAbort )

			Store 0 To xVal050,xVal075,xVal100,xDiasAtraso,xTotVencido,nContTit

			xFilial	:= ( DbTrab )->E1_FILIAL
			xUO			:= AllTrim(( DbTrab )->UO)
			xGRPCLI	:= ( DbTrab )->A1_XGRPCLI
			xE1CLIENTE	:= ( DbTrab )->E1_CLIENTE
			xE1LOJA	:= ( DbTrab )->E1_LOJA
			xA1NOME	:= ( DbTrab )->A1_NOME
			xE1PREFIXO	:= ( DbTrab )->E1_PREFIXO
			xE1NUM		:= ( DbTrab )->E1_NUM
			xE1PARCELA	:= ( DbTrab )->E1_PARCELA
			xE1CCONT	:= ( DbTrab )->E1_CCONT
			xE1EMISSAO	:= ( DbTrab )->E1_EMISSAO
			xE1VENCREA	:= ( DbTrab )->E1_VENCREA

			While	&xWhile  					.And. ;
					lEnd						.And.	;
					( DbTrab )->( !Eof() )

				nCountReg++

				oReport:SetMsgPrint("Selecionando Registros " + cValTochar( nCountReg ) + " de " + cValTochar( nQtdeReg ) )

				StaticCall( GEFRGPO2 , ChkAbort )

				nSaldo := ( DbTrab )->E1_SALDO

				nSaldo -= SomaAbat( ( DbTrab )->E1_PREFIXO,( DbTrab )->E1_NUM,( DbTrab )->E1_PARCELA,"R",( DbTrab )->E1_MOEDA,/*dDataBase*/,( DbTrab )->E1_CLIENTE,( DbTrab )->E1_LOJA)

				If	( DbTrab )->E1_VALOR		== nSaldo	.And.	;
					( DbTrab )->E1_SDDECRE	==	0 		.And.	;
					( DbTrab )->E1_DECRESC	>	0

					nSaldo -= SE1->E1_DECRESC

				EndIf

				If	( DbTrab )->E1_VALOR		==	nSaldo	.And.	;
					( DbTrab )->E1_SDACRES	==	0		.And.	;
					( DbTrab )->E1_ACRESC	>	0

					nSaldo += SE1->E1_ACRESC

				EndIf

				nQtdeDias := ( dDataAtu - ( DbTrab )->E1_VENCREA )

				If MV_PAR01 == 1
					xDiasAtraso += nQtdeDias
					nContTit++
				Else
					xDiasAtraso := IIf( xDiasAtraso < nQtdeDias, nQtdeDias, xDiasAtraso )
				EndIf

				nPos := aScan( aContabil , { |Z| AllTrim( Z[1] ) == AllTrim( ( DbTrab )->E1_CCONT ) }  )

				If nPos == 0
					AAdd( aContabil , { ( DbTrab )->E1_CCONT , 0 , 0 , 0 }  )
					nPos := Len( aContabil )
				EndIf

				If nQtdeDias >= 90 .And. nQtdeDias <= 180
					xVal050 += NoRound( ( nSaldo * 0.50 ) )
					aContabil[nPos][2] += NoRound( ( nSaldo * 0.50 ) )

				ElseIf nQtdeDias >= 181 .And. nQtdeDias <= 365
					xVal075 += NoRound( ( nSaldo * 0.75 ) )
					aContabil[nPos][3] += NoRound( ( nSaldo * 0.75 ) )

				ElseIf nQtdeDias > 365
					xVal100 += NoRound( nSaldo )
					aContabil[nPos][4] += NoRound( nSaldo )

				EndIf

				( DbTrab )->(DbSkip())

				oReport:IncMeter()

				If MV_PAR04 == 1
					Exit
				EndIf

			End While

			xTotVencido := NoRound( xVal050 + xVal075 + xVal100 )

			aPDD := GetAdvFVal("SZ9",{ "Z9_M" + nMesAnt , "Z9_M" + nMesAtu },xFilial("SZ9") + cValToChar( Year(MV_PAR07) ) + xUO+xGRPCLI+xE1CLIENTE+xE1LOJA , 1 , {0,0} )

			aPDD[2] := IIf( aPDD[2] == 0 , xTotVencido , aPDD[2] )

			RecLock( "dTRABDB" , .T. )
				dTRABDB->UO			:=	xUO
				dTRABDB->A1GRUPO		:=	xGRPCLI
				dTRABDB->E1FILIAL		:=	xFilial
				dTRABDB->E1CLIENTE	:=	xE1CLIENTE
				dTRABDB->E1LOJA		:=	xE1LOJA
				dTRABDB->A1NOME		:=	xA1NOME
				dTRABDB->DIASATRASO	:=	IIf( MV_PAR01 == 1 , xDiasAtraso / nContTit , xDiasAtraso )
				dTRABDB->VAL050		+=	xVal050
				dTRABDB->VAL075		+=	xVal075
				dTRABDB->VAL100		+=	xVal100
				dTRABDB->VENCIDOS		+=	xTotVencido
				dTRABDB->PDDANT		+=	aPDD[1]
				dTRABDB->PDDATU		+=	aPDD[2]
				dTRABDB->VARIACAO		+=	aPDD[1] - aPDD[2]

				If MV_PAR04 == 1
					dTRABDB->E1PREFIXO	:= xE1PREFIXO
					dTRABDB->E1NUM		:= xE1NUM
					dTRABDB->E1PARCELA	:= xE1PARCELA
					dTRABDB->E1CCONT		:= xE1CCONT
					dTRABDB->E1EMISSAO	:= xE1EMISSAO
					dTRABDB->E1VENCREA	:= xE1VENCREA
					dTRABDB->E1VENCREA	:= xE1VENCREA
				EndIf

			dTRABDB->( MsUnlock() )

			aTotais[1] += dTRABDB->VAL050
			aTotais[2] += dTRABDB->VAL075
			aTotais[3] += dTRABDB->VAL100
			aTotais[4] += dTRABDB->VENCIDOS
			aTotais[5] += dTRABDB->PDDANT
			aTotais[6] += dTRABDB->PDDATU
			aTotais[7] += dTRABDB->VARIACAO

		End While

	End Sequence

	RestArea( aArea )

Return


Static Function xCriaArq
	Local aArea 	:= GetArea()
	Local aTRABDB	:= {}
	Local aTamVal	:= TamSX3("E1_VALOR")

	If Select("dTRABDB") # 0
		dTRABDB->( DbCloseArea() )
	EndIf

	Aadd( aTRABDB , {"UO"			,"C",05,0 })
	Aadd( aTRABDB , {"A1GRUPO"		,"C",GetSx3Cache("A1_XGRPCLI"	,"X3_TAMANHO"),0 } )
	Aadd( aTRABDB , {"E1FILIAL"		,"C",GetSx3Cache("E1_FILIAL"	,"X3_TAMANHO"),0 } )
	Aadd( aTRABDB , {"E1CLIENTE"	,"C",GetSx3Cache("E1_CLIENTE"	,"X3_TAMANHO"),0 } )
	Aadd( aTRABDB , {"E1LOJA"		,"C",GetSx3Cache("E1_FILIAL"	,"X3_TAMANHO"),0 } )
	Aadd( aTRABDB , {"DIASATRASO"	,"N",06,0 })
	Aadd( aTRABDB , {"A1NOME"		,"C",60,0 })
	Aadd( aTRABDB , {"E1PREFIXO"	,"C",GetSx3Cache("E1_PREFIXO"	,"X3_TAMANHO"),0 } )
	Aadd( aTRABDB , {"E1NUM"			,"C",GetSx3Cache("E1_NUM"		,"X3_TAMANHO"),0 } )
	Aadd( aTRABDB , {"E1PARCELA"	,"C",GetSx3Cache("E1_PARCELA"	,"X3_TAMANHO"),0 } )
	Aadd( aTRABDB , {"E1CCONT"		,"C",GetSx3Cache("E1_CCONT"		,"X3_TAMANHO"),0 } )
	Aadd( aTRABDB , {"E1EMISSAO"	,"D",GetSx3Cache("E1_EMISSAO"	,"X3_TAMANHO"),0 } )
	Aadd( aTRABDB , {"E1VENCREA"	,"D",GetSx3Cache("E1_VENCREA"	,"X3_TAMANHO"),0 } )
	Aadd( aTRABDB , {"E1VALOR"		,"N",aTamVal[1],aTamVal[2] })
	Aadd( aTRABDB , {"E1SALDO"		,"N",aTamVal[1],aTamVal[2] })
	Aadd( aTRABDB , {"VAL050"		,"N",aTamVal[1],aTamVal[2] })
	Aadd( aTRABDB , {"VAL075"		,"N",aTamVal[1],aTamVal[2] })
	Aadd( aTRABDB , {"VAL100"		,"N",aTamVal[1],aTamVal[2] })
	Aadd( aTRABDB , {"VENCIDOS"		,"N",aTamVal[1],aTamVal[2] })
	Aadd( aTRABDB , {"PDDANT"		,"N",aTamVal[1],aTamVal[2] })
	Aadd( aTRABDB , {"PDDATU"		,"N",aTamVal[1],aTamVal[2] })
	Aadd( aTRABDB , {"VARIACAO"		,"N",aTamVal[1],aTamVal[2] })

	cTRABDB := CriaTrab( aTRABDB )

	dbUseArea( .T. , __LocalDriver , cTRABDB , "dTRABDB" )

	IndRegua("dTRABDB",cTRABDB,"UO+A1GRUPO+E1CLIENTE+E1LOJA")
	DbSelectArea("dTRABDB")

	StaticCall( GEFRGPO2 , ChkAbort )

	RestArea( aArea )

Return


Static Function CtbCred
	Local aArea		:= GetArea()
	Local nTotal		:= 0
	Local cRotina		:= "GEFFINR008"
	Local cLote		:= "000001"
	Local cArquivo	:= "GEFFINR008"
	Local cPadrao		:= "099"
	Local nHdlPrv
	Local lDigita	:= .T.

	VALOR2 := 0

	nHdlPrv	:= HeadProva( cLote , cRotina , Substr( cUsuario , 7 , 6 ) , @cArquivo ) // Abre o lançamento contábil

	For X := 1 To Len( aContabil )

		If VerPadrao( cPadrao )

			CUSTOD	:= aContabil[X][1]
			VALOR	:= aContabil[X][2] + aContabil[X][3] + aContabil[X][4]
			nTotal	+= DetProva(nHdlPrv,cPadrao,cRotina,cLote)

	 	EndIf

	 Next X

	 VALOR := 0

	 If nTotal # 0
	 	CUSTOC		:= ''
	 	VALOR2		:= nTotal
	 	nTotal		+= DetProva(nHdlPrv,cPadrao,cRotina,"000001")

		RodaProva( nHdlPrv	, nTotal )
																				// Roda o Lançamento
		cA100Incl( cArquivo	, nHdlPrv , 3 , cLote , .T. , .F. ) 		// Envia para Lancamento Contabil

	EndIf

	RestArea( aArea )

Return


Static Function ValidPDD
	Local aArea		:= GetArea()
	Local lRetorno	:= .T.
	Local DbTrab		:= GetNextAlias()
	Local xSelect		:= ''
	Local aQuery

	Begin Sequence

		If MV_PAR03 # 1
			Break
		EndIf

		xSelect := "Sum( Z9_M" + nMesAtu + " ) As MES "
		xSelect := "%"+xSelect+"%"

		BeginSql Alias DbTrab

			Select %Exp:xSelect%

 			From %Table:SZ9% SZ9

			Where (		SZ9.%NotDel%
						And	SZ9.Z9_FILIAL	=	%Exp:xFilial("SZ9")%
						And	SZ9.Z9_ANO		=	%Exp:AllTrim( cValToChar( Year( dDataAtu ) ) )%
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

Static Function SaveSZ9()
	Local aArea := GetArea()

	DbSelectArea("dTRABDB")

	dTRABDB->( DbGoTop() )

	cCampo :=  "Z9_M" + nMesAtu
	cAno	:= cValToChar( Year( dDataAtu ) )

	While dTRABDB->( !Eof() )

		DbSelectArea("SZ9")

		Begin Sequence

			If AllTrim( dTRABDB->UO ) == "SCC"

				Break

			EndIf

			lInclui := .T.

			If DbSeek( xFilial("SZ9") + cAno + dTRABDB->( UO + A1GRUPO + E1CLIENTE + E1LOJA ) )
				lInclui := .F.
			EndIf

			RecLock( "SZ9" , lInclui )

				If lInclui
					SZ9->Z9_FILIAL	:=	xFilial("SZ9")
					SZ9->Z9_ANO   	:=	cAno
					SZ9->Z9_XGRPCLI	:=	dTRABDB->A1GRUPO
					SZ9->Z9_CLIENTE	:=	dTRABDB->E1CLIENTE
					SZ9->Z9_LOJA  	:=	dTRABDB->E1LOJA
					SZ9->Z9_UO			:=	dTRABDB->UO
				EndIf

				SZ9->Z9_VALOR1 		+=	dTRABDB->VAL050
				SZ9->Z9_VALOR2 		+=	dTRABDB->VAL075
				SZ9->Z9_VALOR3 		+=	dTRABDB->VAL100
				SZ9->&cCampo			+=	dTRABDB->VENCIDOS

			SZ9->( MsUnLock() )

		End Sequence

		dTRABDB->( DbSkip() )

	End While

	RestArea( aArea )

Return
