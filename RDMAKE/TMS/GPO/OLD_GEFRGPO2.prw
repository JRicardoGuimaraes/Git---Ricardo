#Include 'Protheus.ch'
#Include "TopConn.ch"
#Include "Report.CH"

#Define PICT_VALOR01 "@E 9999,999.99"
#Define PICT_MARGEM1 "@E 999.99"
#Define TAM_VALOR01	15
#Define TAM_ROTA		50
#Define TAM_CUSTO		22

/*
Programa    : GEFRGPO2
Funcao      : User Fucntion GEFRGPO01
Data        : 10/09/2015
Autor       : Ricardo Guimarães
Descricao   : Model Report - MVC
Uso         :
Sintaxe     : GEFRGPO2()
Chamenda    : Menu
*/
//*************
USER Function GEFRGPO2()
	Local aArea			:=	GetArea()
	Private cPerg			:=	"GEFRGPO002"
	Private TRAB			:=	GetNextAlias()
	Private oReport
	//Private cConta		:=	AjustaSX6()
	//Private aConta		:=	StrToArray( cConta , "|" )
	Private cArqTemp
	Private cArqTemp1
	Private cArqTemp2

	AjustaSX1()

	oReport := ModelReport()
	oReport:PrintDialog()

	RestArea( aArea )

Return

/*
Programa    : GEFRGPO2
Funcao      : ModelReport
Data        : 10/09/2015
Autor       : Ricardo Guimarães
Descricao   : Função Model do Relatorio - MVC
Uso         :
Sintaxe     : ModelReport()
Chamenda    : Interna - ModelReport()
*/


Static Function ModelReport
	Local oReport
	Local oSection1
	Local oSection2
	Local oBreak

	oReport := TReport():New("GEFRGPO02","Margem de Contribuição - Completo","GEFRGPO002",{ |oReport| PrintReport( oReport ) },"MARGEM DE CONTRIBUIÇÃO - COMPLETO")
	oReport:SetLandScape()
	oReport:nDevice := 4  // Direciona para enviar dados para o Excel

	Pergunte(oReport:uParam,.F.)

	//oSection := TRSection():New( oReport,"Margem" ,{"ZA6","ZA7","ZT0","ZT1"} )
	oSection1 := TRSection():New( oReport,"Margem" ,{"ZA6","ZA7","ZT0","ZT1","DTC","SA1","DTQ","ZA3","DTR", "DA3"} )

	oSection1:SetLineBreak(.F.)
	oSection1:SetHeaderBreak( .T. )
	oSection1:SetHeaderSection( .T. )
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalInLine(.F.)
	//oSection1:SetTotalText("Tota:l")

	//TRCell():New(oSection,"AST"		        ,"TRAB","AST"			,GetSx3Cache("ZA6_AS"	,"X3_PICTURE")	,TAM_CUSTO	,.T.,/*{|| }*/,,,"LEFT")
//	TRCell():New(oSection1,"AST"	          	,"TRAB","AST"			         	,"@!"         ,TAM_CUSTO	                		,.F.,/*{|| }*/,,,"LEFT")
//	oSection1:aCell[1]:lEnabled := .F. // Não imprime a coluna AST

//	TRCell():New(oSection1,"CUSTO_PLANEJADO"  ,"TRAB","C.Planejado"	    	,PICT_VALOR01 ,TAM_VALOR01                 	,.T.,/*{|| }*/,,,"RIGHT")
//	TRCell():New(oSection1,"CUSTO_REALIZADO"  ,"TRAB","C.Realizado"	    	,PICT_VALOR01 ,TAM_VALOR01                 	,.T.,/*{|| }*/,,,"RIGHT") //  "Left"
//	TRCell():New(oSection1,"VALOR_VENDA"	   	,"TRAB","Vr. Venda"	    		,PICT_VALOR01 ,TAM_VALOR01                 	,.T.,/*{|| }*/,,,"RIGHT")
//	TRCell():New(oSection1,"MC_PLANEJADA"	   	,"TRAB","% M.C Planej" 			,PICT_MARGEM1 ,TAM_VALOR01                 	,.T.,/*{|| }*/,,,"RIGHT")
//	TRCell():New(oSection1,"MC_REALIZADA"	   	,"TRAB","% M.C Realiz" 			,PICT_MARGEM1 ,TAM_VALOR01                 	,.T.,/*{|| }*/,,,"RIGHT")

//	oBreak := TRBreak():New(oSection1,oSection1:Cell("AST"),,.F.)
//	TRFunction():New(oSection1:Cell("AST"),"QTD.Itens ","COUNT",oBreak,,"@E 999999",,.T.,.F.)
	//TRFunction():New(oSection1:Cell("CUSTO_PLANEJADO"),"C. Planejado",CUSTO_PLANEJADO,oBreak,,PICT_VALOR01,,.T.,.F.)

/*
	oSection2 := TRSection():New(oSection1,"Margem" ,{"ZA6","ZA7","ZT0","ZT1","DTC","SA1","DTQ","ZA3","DTR", "DA3"} )

	oSection2:SetLineBreak(.F.)
	oSection2:SetHeaderBreak( .T. )
	oSection2:SetHeaderSection( .T. )
	oSection2:SetPageBreak(.F.)
	oSection2:SetTotalInLine(.F.)
	//oSection2:SetTotalText("Total:")
*/

	TRCell():New(oSection1,"DTQ_DATGER"       ,"TRAB","Dt.Geração"	         	,"@D"         ,12 	                    		,.T.,/*{|| }*/,,,"LEFT")
	TRCell():New(oSection1,"DTQ_VIAGEM"       ,"TRAB","Viagem"		         	,"@!"         ,(TAMSX3("DTQ_VIAGEM")[01])+3	,.T.,/*{|| }*/,,,"LEFT")
	TRCell():New(oSection1,"AST"	          	,"TRAB","AST"			         	,"@!"         ,TAM_CUSTO	                		,.T.,/*{|| }*/,,,"LEFT")
	TRCell():New(oSection1,"ZT1_VEICUL"       ,"TRAB","Veic.Plan."    			,"@!"		   	,(TAMSX3("ZT1_VEICUL")[01])+3 	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DUT_DESCRI"       ,"TRAB","Veic.Realiz"    		,"@!"		   	,(TAMSX3("DUT_DESCRI")[01])+1 	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTR_CODVEI"       ,"TRAB","Veic.Real."   			,"@!"	      	,(TAMSX3("DTR_CODVEI")[01])+1 	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"ZT1_CODFOR"       ,"TRAB","Forn.Planej" 			,"@!"		   	,20   ,.T.,{|| ZT1_CODFOR+"-"+ZT1_LOJFOR},,,"LEFT")
	TRCell():New(oSection1,"ZT1_NOMFOR"       ,"TRAB","Transp. Planejada"    	,"@!"	     	,(TAMSX3("ZT1_NOMFOR")[01])+1 	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTR_CREADI"       ,"TRAB", "T.Realiz."   	      	,"@!"		   	,20   ,.T.,{|| DTR_CREADI+"-"+DTR_LOJCRE},,,"LEFT")
	TRCell():New(oSection1,"DTR_NOMCRE"       ,"TRAB","Transp.Realizada"  	,"@!"		 	,(TAMSX3("DTR_NOMCRE")[01])+1 	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTQ_CCC"          ,"TRAB","C. Custo"      			,"@!"		 	,(TAMSX3("DTQ_CCC")[01])+1   	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTQ_SOT"          ,"TRAB","Protjeto"            	,"@!"         ,(TAMSX3("DTQ_SOT")[01])+1		,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"ZA0_CLI"          ,"TRAB","Cod.Cli"         		,"@!"         ,12									,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"ZA0_CLINOM"       ,"TRAB","Cliente"     			,"@!"         ,(TAMSX3("A1_NOME")[01]+1)		,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTC_CLIREM"       ,"TRAB","Cod.Remet"       		,"@!"         ,16,.T.,{|| DTC_CLIREM+"-"+DTC_LOJREM},,,"LEFT")
	//TRCell():New(oSection1,"DTC_CLIREM"       ,"TRAB","Cod.Remet"       		,"@!"         ,12                          	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"CLI_REM"          ,"TRAB","Cli.Remet"   			,"@!"         ,(TAMSX3("A1_NOME")[01])+5  	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTC_CLIDES"       ,"TRAB","Cli.Dest"				,"@!"        	,16									,.T.,{|| DTC_CLIDES+"-"+DTC_LOJDES},,,"LEFT")
	TRCell():New(oSection1,"CLI_DEST"         ,"TRAB","Destinatário"   		,"@!"         ,(TAMSX3("A1_NOME")[01])+2   	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTQ_FILORI"       ,"TRAB","Fil." 	         		,"@!"		   	,(TAMSX3("DTQ_FILORI")[01])+1  	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTQ_MOTORI"       ,"TRAB","C.Mot."        			,"@!"		   	,(TAMSX3("DTQ_MOTORI")[01])+1 	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"NOME_MOTORI"      ,"TRAB","Motorista"    			,"@!"		   	,(TAMSX3("DA4_NOME")[01])+1   	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTQ_XFRETE" 	  	,"TRAB","Frete"       			,PICT_VALOR01 ,TAM_VALOR01  					,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTQ_VRPEDA"       ,"TRAB","Pedágio"     			,PICT_VALOR01 ,TAM_VALOR01  					,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTQ_VRESTA"       ,"TRAB","Estadia"     			,PICT_VALOR01 ,TAM_VALOR01  					,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTQ_VALADV"       ,"TRAB","ADV"	     				,PICT_VALOR01 ,TAM_VALOR01  					,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"GRIS"             ,"TRAB","GRIS"	     			,PICT_VALOR01 ,TAM_VALOR01  					,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"ZT0_TAXAS"        ,"TRAB","Taxas"      	      	,PICT_VALOR01 ,TAM_VALOR01  					,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTQ_CTRREP"       ,"TRAB","REPOM"      			,"@!" 			,(TAMSX3("DTQ_CTRREP")[01])+1	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTQ_NUMCTR"       ,"TRAB","CT-e"	      			,"@!"         ,(TAMSX3("DTQ_NUMCTR")[01])+1	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTQ_SERCTR"       ,"TRAB","Ser" 	            	,"@!"         ,(TAMSX3("DTQ_SERCTR")[01])+1	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTQ_PREFAT"       ,"TRAB","Fat"  	          		,"@!"         ,(TAMSX3("DTQ_PREFAT")[01])+1	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTQ_ORIGEM"	   	,"TRAB","Cid.Origem"     		,"@!"         ,(TAMSX3("DTQ_ORIGEM")[01])+1	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"DTQ_DESTIN"       ,"TRAB","Cid.Destino"   			,"@!"         ,(TAMSX3("DTQ_DESTIN")[01])+1	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"ROTA"             ,"TRAB","Nome da Rota"        	,"@!"         ,(TAMSX3("ZA6_DESCRO")[01])+1   	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"ZA3_NOMROT"       ,"TRAB","Itinerário"	        	,"@!"         ,(TAMSX3("ZA3_NOMROT")[01])+1	,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection1,"CUSTO_PLANEJADO"  ,"TRAB","C.Planejado"	    	,PICT_VALOR01 ,TAM_VALOR01                 	,.T.,/*{|| }*/,,,"RIGHT")
	TRCell():New(oSection1,"CUSTO_REALIZADO"  ,"TRAB","C.Realizado"	    	,PICT_VALOR01 ,TAM_VALOR01                 	,.T.,/*{|| }*/,,,"RIGHT") //  "Left"
	TRCell():New(oSection1,"VALOR_VENDA"	   	,"TRAB","Vr. Venda"	    		,PICT_VALOR01 ,TAM_VALOR01                 	,.T.,/*{|| }*/,,,"RIGHT")
	TRCell():New(oSection1,"MC_PLANEJADA"	   	,"TRAB","% M.C Planej" 			,PICT_MARGEM1 ,TAM_VALOR01                 	,.T.,/*{|| }*/,,,"RIGHT")
	TRCell():New(oSection1,"MC_REALIZADA"	   	,"TRAB","% M.C Realiz" 			,PICT_MARGEM1 ,TAM_VALOR01                 	,.T.,/*{|| }*/,,,"RIGHT")


//	TRCell():New(oSection,"A1_COD"		    ,"TRAB","CODIGO"			,"@!"		   ,06,.T.,/*{|| xfuncao()}*/,,,"RIGHT")
//	TRCell():New(oSection,"A1_NOME"		    ,"TRAB","RAZÃO SOCIAL"  ,"@!"		   ,50,.T.,/*{|| xfuncao()}*/,,,"LEFT")
//	TRCell():New(oSection,"A1_CGC"		    ,"TRAB","C.N.P.J"       ,"@R 99.999.999/9999-99",20,.T.,/*{|| xfuncao()}*/,,,"LEFT")

//	oBreak := TRBreak():New(oSection2,oSection2:Cell("AST"),,.F.)

//	TRFunction():New(oSection2:Cell("AST"),"QTD.Itens ","COUNT",oBreak,,"@E 999999",,.F.,.F.)

	//oCT_TOTC := TRFunction():New(oSection:Cell("CT_TOTC"),Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)
	//oCT_VRAT := TRFunction():New(oSection:Cell("CT_VRAT"),Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)
	//oCT_VTOT := TRFunction():New(oSection:Cell("CT_VTOT"),Nil,"SUM",/*oBreak*/,,PICT_VALOR02,/*uFormula*/,.T.,.F.)

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
	Local oSection1	:= oReport:Section(1)
	Local oSection2  	:= oReport:Section(1):Section(1)
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

	Local _cASIni		:= MV_PAR01
	Local _cASFim		:= MV_PAR02
	Local _cCliIni	:= MV_PAR03
	Local _cLojIni	:= MV_PAR04
	Local _cCliFim	:= MV_PAR05
	Local _cLojFim	:= MV_PAR06
	Local _cDatIni	:= dtos(MV_PAR07)
	Local _cDatFim	:= dtos(MV_PAR08)

	_cWhere := ""
	//_cWhere := "AND ZA6_AS BetWeen %Exp:MV_PAR01% AND %Exp:MV_PAR02%"  //'010000401200120'
	//_cWhere := "AND ZA6_AS BetWeen '" + _cASIni + "' AND '" + _cASFim + "' "  //'010000401200120'
	//_cWhere += "AND ZA6_AS <> '' "
	//_cWhere += "AND

	//_cWhere := "% AND A1_NOME LIKE '%GEFCO%' %"
	//_cWhere := "%"+_cWhere+"%"

	MakeSqlExpr(oReport:uParam)

	oSection1:BeginQuery()

		BeginSql Alias TRAB

//			SELECT A1_COD, A1_NOME, A1_CGC FROM %Table:SA1% SA1
//				WHERE SA1.%NotDel%

			column ZA6_DTINI  as Date
			column ZA7_VALOR  as Numeric(18,2)
			column DATA_INI 	 as Date
			column DTQ_XFRETE as Numeric(18,2)
			column DTQ_VRPEDA as Numeric(18,2)
			column DTQ_VRESTA as Numeric(18,2)
			column DTQ_VALADV as Numeric(18,2)
			column ZT0_TAXAS  as Numeric(18,2)
			column VALOR_VENDA as Numeric(18,2)
			column MC_PLANEJADA as Numeric(18,2)
			column CUSTO_PLANEJADO as Numeric(18,2)
			column CUSTO_REALIZADO  as Numeric(18,2)


			// column QEK_SKLDOC As Logical
			%noparser%

			SELECT DISTINCT DTQ_DATGER, DTQ_VIAGEM, A.AST, DTQ_FILORI, DTQ_MOTORI, ISNULL(DA4_NOME,'') AS NOME_MOTORI, ZT1_VEICUL,
				   DUT_DESCRI, DTR_CODVEI, DTR_PLACA, ZT1_CODFOR, ZT1_LOJFOR, ZT1_NOMFOR, DTR_CREADI, DTR_LOJCRE, DTR_NOMCRE,
				   DTQ_CCC, DTQ_XFRETE, DTQ_VRPEDA, DTQ_VRESTA, DTQ_VALADV, (DTQ_BASADV * ZT0_PGRIS) AS GRIS, ZT0_TAXAS,
				   DTQ_CTRREP, DTQ_NUMCTR, DTQ_SERCTR, DTQ_PREFAT, DTQ_SOT, ZA0_CLI, ZA0_CLINOM,
				   DTC_CLIREM, DTC_LOJREM, REM.A1_NOME AS CLI_REM, DTQ_ORIGEM, DTC_CLIDES, DTC_LOJDES, DEST.A1_NOME AS  CLI_DEST,
				   DTQ_DESTIN, A.ROTA, ZA3_NOMROT, DTC_CLIDEV, DTC_LOJDEV, DEV.A1_NOME AS CLI_DEV,
				   A.CUSTO_PLANEJADO, A.CUSTO_REALIZADO, A.VALOR_VENDA,
				   (((VALOR_VENDA / CUSTO_PLANEJADO)*100)-100) AS MC_PLANEJADA,
				   (((VALOR_VENDA / CUSTO_REALIZADO)*100)-100) AS MC_REALIZADA
			  FROM (
						SELECT ZA6_AS AS 'AST', ZA6_DESCRO AS ROTA, ZT1_CUSTO AS CUSTO_PLANEJADO, ZT1_CODFOR, ZT1_LOJFOR, ZT1_NOMFOR,
							   ZT1_VEICUL, ZA6_VIAGEM, SUM(ZA7_CUSTO) AS CUSTO_REALIZADO, SUM(ZA7_VALOR) AS VALOR_VENDA,
							   ZT0_PGRIS, ZT0_TAXAS, ZA6_PROJET, ZA6_OBRA, ZA6_SEQTRA, ZA6_FILIAL
						  FROM ZA6010 (nolock) ZA6, ZT0010 (nolock) ZT0, ZT1010 (nolock) ZT1, ZA7010 (nolock) ZA7
						 WHERE ZA6_AS BetWeen 	%Exp:_cASIni% AND 	%Exp:_cASFim%
						   AND ZA6_DTINI BetWeen %Exp:_cDatIni% AND 	%Exp:_cDatFim%
						   AND ZA6_TABVEN = ZT0_CODTAB
						   AND ZA6_VERVEN = ZT0_VERTAB
						   AND ZA6_ITTABV = ZT0_ITEMTB
						   AND ZT0_TABCOM = ZT1_CODTAB
						   AND ZT0_VERCOM = ZT1_VERTAB
						   AND ZT0_ITTABC = ZT1_ITEMTB
						   AND ZT0.D_E_L_E_T_=''
						   AND ZA6.D_E_L_E_T_=''
						   AND ZT1.D_E_L_E_T_=''
						   AND ZA6_AS = ZA7_AS
						GROUP BY ZA6_AS, ZA6_DESCRO, ZT1_CUSTO, ZA6_VIAGEM, ZT1_CODFOR, ZT1_LOJFOR, ZT1_NOMFOR, ZT1_VEICUL, ZT0_PGRIS, ZT0_TAXAS,
								 ZA6_PROJET, ZA6_OBRA, ZA6_SEQTRA, ZA6_FILIAL
						) A, SA1010 (nolock) REM, SA1010 (nolock) DEST, SA1010 (nolock) DEV, ZAM010 (nolock) ZAM, ZA0010  (nolock)ZA0, ZA3010 (nolock) ZA3, DTC010 (nolock) DTC,

			      ((((DTQ010 (nolock) DTQ 	 LEFT JOIN DA4010 (nolock) DA4 ON DTQ_MOTORI = DA4_COD)
												 LEFT JOIN DTR010 (nolock) DTR ON DTQ_VIAGEM = DTR_VIAGEM AND DTQ_FILORI = DTR_FILORI)
												 LEFT JOIN DA3010 (nolock) DA3 ON DA3_COD = DTR_CODVEI )
												 LEFT JOIN DUT010 DUT ON DA3_TIPVEI = DUT_TIPVEI)

			WHERE A.AST = DTQ_AS
			  AND DTQ.D_E_L_E_T_=''
			  AND A.ZA6_FILIAL = DTC_FILORI
			  AND A.ZA6_VIAGEM = DTC_VIAGEM
			  AND DTQ.DTQ_SOT    = DTC_SOT
			  AND DTC_CLIDEV   = DEV.A1_COD
			  AND DTC_LOJDEV   = DEV.A1_LOJA
			  AND DEV.%NotDel%
			  AND DTC_CLIREM   = REM.A1_COD
			  AND DTC_LOJREM   = REM.A1_LOJA
			  AND REM.%NotDel%
			  AND DTC_CLIDES   = DEST.A1_COD
			  AND DTC_LOJDES   = DEST.A1_LOJA
			  AND DEST.%NotDel%
			  AND DTC_CLIDEV BetWeen %Exp:_cCliIni% AND %Exp:_cCliFim%
			  AND DTC_LOJDEV BetWeen %Exp:_cLojIni% AND %Exp:_cLojFim%
			  AND DTC.%NotDel%
			  AND DTQ_SOT = ZA0_PROJET
			  AND ZA0.%NotDel%
			  AND A.ZA6_PROJET = ZAM_PROJET
			  AND A.ZA6_OBRA = ZAM_OBRA
			  AND A.ZA6_SEQTRA = ZAM_SEQTRA
			  AND ZAM_ETAPA = '001'
			  AND ZAM_FILIAL = ZA6_FILIAL
			  AND ZAM.%NotDel%
			  AND ZAM_ORIGEM = ZA3_ORIGEM
			  AND ZAM_DESTIN = ZA3_DESTIN
			  AND ZAM_ROTA = ZA3_ROTA
			ORDER BY A.AST
		EndSql

	oSection1:EndQuery()

	oSection1:SetParentQuery()
	oSection1:SetParentFilter({|cParam| (TRAB)->AST >= cParam .and. (TRAB)->AST <= cParam},{|| (TRAB)->AST})

	aQuery := GetLastQuery()

	oReport:SetMeter( ( TRAB )->( LastRec() ) )

	(TRAB)->( DbGoTop() )

	If !oReport:Cancel()

		dbSelectArea( (TRAB) )

		oReport:SetTitle("MARGEM DE CONTRIBUICAO - COMPLETO")

		oSection1:Init()
		While !oReport:Cancel() .And. (TRAB)->( !Eof() )

			oSection1:PrintLine()

//			oSection2:Init()
//			_cAST := (TRAB)->AST
//			While !oReport:Cancel() .And. (TRAB)->( !Eof() ) .AND. (TRAB)->AST == _cAST
//				oSection2:PrintLine()

				oReport:IncMeter()

 				(TRAB)->( DbSkip() )

// 			End While
//			oSection1:Finish()

		End While

		oSection1:Finish()

		oReport:EndPage()

	EndIf

	If Select( (TRAB) ) # 0
		( TRAB )->( DbCloseArea() )
	EndIf

	RestArea( aArea )

Return


/*
Programa    : GEFRGPO02
Funcao      : Função Estatica  - AjustaSX1
Data        : 02/10/2015
Autor       : Ricardo Guimarães
Descricao   : Função de Apoio
Uso         : Ajusta os Parametros do Relatorio
Sintaxe     : AjustaSX1()
Chamenda    : Interna
*/

Static Function AjustaSX1
	PutSx1(cPerg,"01","AS De"		     ,"AS   De"		,"AS  De"		,"mv_ch1","C",15,0,0,"G","",""	 ,"","","mv_par01",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"02","AS Ate"		     ,"AS  Até"		,"AS Até"		,"mv_ch2","C",15,0,0,"G","",""	 ,"","","mv_par02",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"03","Cliente Dev. De"  ,"Devedor De"	,"Devedor  De","mv_ch3","C",06,0,0,"G","","SA1","","","mv_par03",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"04","Loja Cli.Dev. De" ,"Devedor De"	,"Devedor  De","mv_ch4","C",02,0,0,"G","",""	 ,"","","mv_par04",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"05","Cliente Dev. Ate" ,"Devedor Até" ,"Devedor Até","mv_ch5","C",06,0,0,"G","","SA1","","","mv_par05",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"06","Loja Cli.Dev. Ate","Devedor De"	,"Devedor  De","mv_ch6","C",02,0,0,"G","",""	 ,"","","mv_par06",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"07","Data De"	         ,"Devedor De"	,"Devedor  De","mv_ch7","D",08,0,0,"G","",""	 ,"","","mv_par07",""		,"","","",""	,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"08","Data Ate"	     ,"Devedor De"	,"Devedor  De","mv_ch8","D",08,0,0,"G","",""   ,"","","mv_par08",""		,"","","",""	,"","","","","","","","","","","","","","","")

	//PutSx1(cPerg,"03","Contabilizar"	,"Contabilizar"	,"Contabilizar"	,"mv_ch3","N",01,0,1,"C","",""	,"","","mv_par03","Sim"	,"","","","Não","","","","","","","","","","","","","","","")
	//PutSx1(cPerg,"04","Tipo Saldo"		,"Tipo Saldo"		,"Tipo Saldo"		,"mv_ch4","C",01,0,0,"G","","SLW","","","mv_par04",""		,"","","","","","","","","","","","","","","","","","","","")

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

