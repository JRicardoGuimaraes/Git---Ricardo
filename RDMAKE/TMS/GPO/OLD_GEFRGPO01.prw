#Include 'Protheus.ch'
#Include "TopConn.ch"
#Include "Report.CH"

#Define PICT_VALOR01 "@E 999,999,999.99"
#Define PICT_MARGEM1 "@E 999.99"
#Define TAM_VALOR01	22
#Define TAM_ROTA		50
#Define TAM_CUSTO		22

/*
Programa    : GEFRGPO01
Funcao      : User Fucntion GEFRGPO01
Data        : 10/09/2015
Autor       : Ricardo Guimarães
Descricao   : Model Report - MVC
Uso         : 
Sintaxe     : GEFRGPO01() 
Chamenda    : Menu
*/

USER Function GEFRGPO01()
	Local aArea			:=	GetArea()
	Private cPerg			:=	"GEFRGPO001"
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
Programa    : GEFRGPO01
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
	Local oSection
	Local oBreak

	oReport := TReport():New("GEFRGPO01","Margem de Contribuição Simplificado","GEFRGPO001",{ |oReport| PrintReport( oReport ) },"MARGEM DE CONTRIBUIÇÃO SIMPLIFICADO")
	oReport:SetLandScape()

	Pergunte(oReport:uParam,.F.)

	//oSection := TRSection():New( oReport,"Margem" ,{"ZA6","ZA7","ZT0","ZT1"} )
	oSection := TRSection():New( oReport,"Margem" ,{"ZA6","ZA7","ZT0","ZT1","DTC","SA1"} )	

	oSection:SetLineBreak(.F.)
	oSection:SetHeaderBreak( .T. )
	oSection:SetHeaderSection( .T. )
	oSection:SetPageBreak(.F.)
	oSection:SetTotalInLine(.F.)
	oSection:SetTotalText("Total:")

	//TRCell():New(oSection,"AST"		        ,"TRAB","AST"			,GetSx3Cache("ZA6_AS"	,"X3_PICTURE")	,TAM_CUSTO	, .T.,/*{|| }*/,,,"LEFT")
	TRCell():New(oSection,"CLIENTE"	        ,"TRAB","Cliente"		    ,"@!"        ,100	    , .T.,/*{|| }*/,,,"LEFT")
	TRCell():New(oSection,"DATA_INI"       ,"TRAB","Data"			    ,"@D"        ,08   	    , .T.,/*{|| }*/,,,"LEFT")
	TRCell():New(oSection,"AST"		        ,"TRAB","AST"			    ,"@!"        ,TAM_CUSTO	 , .T.,/*{|| }*/,,,"LEFT")		
	TRCell():New(oSection,"ROTA"		    ,"TRAB","ROTA"			    ,"@!"		   ,TAM_ROTA   ,.T.,/*{|| xfuncao()}*/,,,"LEFT")
	TRCell():New(oSection,"CUSTO_PLANEJADO","TRAB","C.Planejado  "	    ,PICT_VALOR01,TAM_VALOR01,.T.,/*{|| }*/,,,"RIGHT")
	TRCell():New(oSection,"CUSTO_REALIZADO","TRAB","C.Realizado  "	    ,PICT_VALOR01,TAM_VALOR01,.T.,/*{|| }*/,,,"RIGHT") //  "Left"
	TRCell():New(oSection,"VALOR_VENDA"	,"TRAB","Valor de Venda"	    ,PICT_VALOR01,TAM_VALOR01,.T.,/*{|| }*/,,,"RIGHT")
	TRCell():New(oSection,"MC_PLANEJADA"	,"TRAB","% Margem Planejada",PICT_MARGEM1,TAM_VALOR01 ,.T.,/*{|| }*/,,,"RIGHT")	
	TRCell():New(oSection,"MC_REALIZADA"	,"TRAB","% Margem Realizada",PICT_MARGEM1,TAM_VALOR01 ,.T.,/*{|| }*/,,,"RIGHT")

//	TRCell():New(oSection,"A1_COD"		    ,"TRAB","CODIGO"			,"@!"		   ,06,.T.,/*{|| xfuncao()}*/,,,"RIGHT")
//	TRCell():New(oSection,"A1_NOME"		    ,"TRAB","RAZÃO SOCIAL"  ,"@!"		   ,50,.T.,/*{|| xfuncao()}*/,,,"LEFT")
//	TRCell():New(oSection,"A1_CGC"		    ,"TRAB","C.N.P.J"       ,"@R 99.999.999/9999-99",20,.T.,/*{|| xfuncao()}*/,,,"LEFT")	
	

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
	Local oSection	:= oReport:Section(1)
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

	oSection:BeginQuery()			

		BeginSql Alias TRAB
		
//			SELECT A1_COD, A1_NOME, A1_CGC FROM %Table:SA1% SA1
//				WHERE SA1.%NotDel%
	
			column ZA6_DTINI as Date, ZA7_VALOR  as Numeric(18,2), DATA_INI as Date   
			// column QEK_SKLDOC As Logical          
			%noparser%   

			SELECT DISTINCT A.AST, A.ROTA, A.CUSTO_PLANEJADO, A.CUSTO_REALIZADO, A.VALOR_VENDA,
				   (((VALOR_VENDA / CUSTO_PLANEJADO)*100)-100) AS MC_PLANEJADA, 
				   (((VALOR_VENDA / CUSTO_REALIZADO)*100)-100) AS MC_REALIZADA, (A1_COD + '-' + A1_LOJA + ' - ' + A1_NOME) AS CLIENTE, ZA6_DTINI AS DATA_INI, ZA6_VIAGEM
			  FROM (
			SELECT ZA6_AS AS 'AST', ZA6_DESCRO AS ROTA, ZT1_CUSTO AS CUSTO_PLANEJADO, SUM(ZA7_CUSTO) AS CUSTO_REALIZADO, 
				   SUM(ZA7_VALOR) AS VALOR_VENDA, ZA6_VIAGEM, ZA6_DTINI  
			 
			  FROM %Table:ZA6% ZA6, %Table:ZT0% ZT0, %Table:ZT1% ZT1, %Table:ZA7% ZA7
			 
			 WHERE 
			 ( 
			       ZA6_TABVEN = ZT0_CODTAB
			   AND ZA6_VERVEN = ZT0_VERTAB
			   AND ZA6_ITTABV = ZT0_ITEMTB
			   AND ZT0_TABCOM = ZT1_CODTAB
			   AND ZT0_VERCOM = ZT1_VERTAB
			   AND ZT0_ITTABC = ZT1_ITEMTB
			   AND ZT0.%NotDel%
			   AND ZA6.%NotDel%
			   AND ZT1.%NotDel%
			   AND ZA6_AS = ZA7_AS
			   AND ZA6_AS <> %Exp:Space(01)%
			   AND ZA6_AS BetWeen %Exp:_cASIni% AND %Exp:_cASFim% 
			   AND ZA6_DTINI BetWeen %Exp:_cDatIni% AND %Exp:_cDatFim%
			   
			   //%Exp:_cWhere%			   
			)

			GROUP BY ZA6_AS, ZA6_DESCRO, ZT1_CUSTO, ZA6_VIAGEM, ZA6_DTINI
			) A, %Table:SA1% SA1, %Table:DTC% DTC
			WHERE DTC_CLIDEV BetWeen %Exp:_cCliIni% AND %Exp:_cCliFim%
			  AND DTC_LOJDEV BetWeen %Exp:_cLojIni% AND %Exp:_cLojFim%
			  AND ZA6_VIAGEM = DTC_VIAGEM
			  AND DTC_CLIDEV = A1_COD
			  AND DTC_LOJDEV = A1_LOJA
			  AND DTC.%NotDel%			  			

		EndSql

	oSection:EndQuery()

	aQuery := GetLastQuery()
			
	oReport:SetMeter( ( TRAB )->( LastRec() ) )

	(TRAB)->( DbGoTop() )
		
	If !oReport:Cancel()

		dbSelectArea( (TRAB) )
		
		oReport:SetTitle("MARGEM DE CONTRIBUICAO SIMPLIFICADA")
				
		oSection:Init()
		While !oReport:Cancel() .And. (TRAB)->( !Eof() )
		
			oSection:PrintLine()
	
			oReport:IncMeter()

 			(TRAB)->( DbSkip() )

		End While
		
		oSection:Finish()
		
		oReport:EndPage()
		
	EndIf

	If Select( (TRAB) ) # 0
		( TRAB )->( DbCloseArea() )
	EndIf
	
	RestArea( aArea )
	
Return


/*
Programa    : GEFRGPO01
Funcao      : Função Estatica  - AjustaSX1
Data        : 10/09/2015
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
	PutSx1(cPerg,"08","Data Ate"	     ,"Devedor De"	,"Devedor  De","mv_ch8","D",08,0,0,"G","","1","","","mv_par08",""		,"","","",""	,"","","","","","","","","","","","","","","")
				
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





