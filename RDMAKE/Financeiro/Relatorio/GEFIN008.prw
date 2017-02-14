#INCLUDE "rwmake.ch"
#Include "Topconn.Ch"
//#Include "FIVEWIN.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ GEFINR008³ Autor ³ Marcos Furtado        ³ Data ³ 11.07.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de PDD                              			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ GEFINR008     											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³				    					 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Financeiro   											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function GEFIN008()			// u_GEFIN008()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis											 				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL wnrel
	LOCAL cDesc1 := "Este programa ira  emitir a rela‡ao de PDD."
	LOCAL cDesc2 := ""
	LOCAL cDesc3 :=""
	LOCAL cString:="SE1"

	PRIVATE limite := 220//132
	PRIVATE Tamanho:="G" //"M"
	PRIVATE titulo
	PRIVATE cabec1
	PRIVATE cabec2
	PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
	PRIVATE nomeprog:= "GFINR008"
	PRIVATE aLinha	:= { },nLastKey := 0
	PRIVATE cPerg	:= "GEF008"
	PRIVATE nLastKey:=0
	Private nTipo := 18
	Private aPDDCtb:= {}//array(20)
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros			   ³
	//³ mv_par01  // Dias em Atraso (Media ou Maior Atraso)³
	//³ mv_par02  // Unid.Operacional                      ³
	//³ mv_par03  // Da emissao                            ³
	//³ mv_par04  // Ate a Data                            ³
	//³ mv_par05  // Data PDD                              ³
	//³ mv_par06  // Grupos:                               ³
	//³ mv_par07  // Contabiliza                           ³
	//³ mv_par08  // Imprime Relatorio Analitico/Sintetico ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas					  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT	  		   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel  := "GFINR008"            //Nome Default do relatorio em Disco
	titulo := OemToAnsi("Relacao - PDD")
	wnrel  := SetPrint(cString,wnrel   ,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.f.,""  ,.T.,Tamanho,,.T.)

	nTipo := If(aReturn[4]==1,15,18)
	lProcessa:=.t.
	If MV_PAR07 = 1 // Sim
		While .t.
			cMes:=strzero(month(mv_par05),2)
			cAno:=allTrim(str( year(mv_par05)))
			cQry:="SELECT SUM(Z9_M"+cMes+") AS MES "
			cQry+="  FROM "+RetSqlName("SZ9")
			cQry+=" WHERE Z9_FILIAL   = '  '     "
			cQry+="   AND Z9_ANO      = '"+cAno+"'"
			cQry+="   AND D_E_L_E_T_ <> '*'	     "
			TcQuery cQry Alias "TSZ9" New
			nMes:=TSZ9->MES
			dbCloseArea()
			If nMes > 0
				MsgAlert("A Data do PDD já foi processada."+chr(10)+"Informe outro período!","Atençao!")
				If !Pergunte(cPerg,.t.)
					lProcessa:=.f.
					exit
				EndIf
			Else
				exit
			EndIf
		EndDo
	EndIf

	If lProcessa
		cDescUO :=""
		cDescGR :="GRUPO GEFCO"
		lTotais := .T.
		AntGRUPO := "9"
		AntDescr :=""
		AntUO	:=""
		If nLastKey == 27
			Return
		Endif

		SetDefault(aReturn,cString)

		If nLastKey == 27
			Return
		Endif

		RptStatus({|lEnd| Fa300Imp(@lEnd,wnRel,cString)},titulo)
	EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FA300Imp ³ Autor ³ Paulo Boschetti		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao dos maiores atrasos/devedores		 			        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA300Imp(lEnd,wnRelm,Cstring)							           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Parametro 1 - lEnd	 - A‡Æo do CodeBlock				        ³±±
±±³ 		    ³ Parametro 2 - wnRel	 - T¡tulo do relat¢rio				     ³±±
±±³ 		    ³ Parametro 3 - cString - Mensagem 						        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso 	    ³ Generico 											                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA300Imp(lEnd,wnRel,cString)
	LOCAL CbCont,CbTxt
	LOCAL nOrdem
	LOCAL lContinua     := .T.
	LOCAL cCliAnt	    := SPACE(6)
	LOCAL aDados[1][15]
	LOCAL aAcum[7]
	LOCAL aSub[7]
	LOCAL nC:=1 , nT    := 1
	LOCAL nFirst	    := 0
	LOCAL aEstru	    :={},aTam:={}
	LOCAL aEstruAn		:={}
	LOCAL aEstruCTB		:={}
	Local aEstruSZ9		:={}
	LOCAL cArq		    := SPACE(8)
	Local lSoma
	Local cValDev, cValAtr
	Local nSaldo        := 0
	Local nSaldoAnt     := 0
	Local nDiasAtraso   := 0
	Local aStru         := SE1->(dbStruct()), ni
	Local nDecs         := MsDecimais(2)
	Local dDataReaj
	Local cFilBkp       := cFilAnt
	local xI            := 0

	PRIVATE cArqAN		:= space(8)
	PRIVATE cArqCTB		:= space(8)
	PRIVATE cArqSZ9		:= space(8)
	PRIVATE dDataPDD      := mv_par05
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cbtxt	 := SPACE(10)
	cbcont	 := 0
	li		 := 80
	m_pag	 := 1
	UnidOp   := " "

	Do Case
	Case mv_par02 == 1
		UnidOp := "RDVM"
	Case mv_par02 == 2
		UnidOp := "ILI"
	Case mv_par02 == 3
		UnidOp := "RMLAP"
	Case mv_par02 == 4
		UnidOp := "RMA"
	Case mv_par02 == 5
		UnidOp := "TODOS"
	EndCase

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao dos cabecalhos									 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	titulo := OemToAnsi('Relacao - PDD - ')+iif(mv_par08 = 1,"Analítico - ","Sintético - ") + UnidOp

	cMes:=upper(subStr(cMonth(ctod("01/"+str(month(dDataPDD))+"/"+str(year(dDataPDD)))-1),1,3))
	cAno:=strzero( year(ctod("01/"+str(month(dDataPDD))+"/"+str(year(dDataPDD)))-1),4)

	cMesAnt:="PDD "+cMes+" "+cAno
	cMesAtu:="PDD "+upper(subStr(cMonth(dDataPDD),1,3))+" "+alltrim(str(year(dDataPDD)))

	cabec1 := OemToAnsi('                                  Dias de       50%              75%            100%                   ')
	cabec2 := OemToAnsi('Nome do Cliente                   Atraso   Val. 90 - 180   Val. 181 - 365    Val. > 365     Vencidos    '+cMesAnt+'    '+cMesAtu+'        Variacao')

	nCol01  := 035 //31
	nCol02  := 43//084 //78
	nCol03  := 60//090 //91
	nCol04  := 74//105 //107
	nCol05  := 87//120 //125
	//92
	nCol07	:= 103
	nCol08	:= 119
	nCol09	:= 135
	If mv_par08 = 1

		cabec1 := OemToAnsi("                            Prf-Numero  Data de   Vencto   Dias de       50%                75%             100%                               ")
		cabec2 := OemToAnsi('Fil-Codigo-Lj-Nome do Cli.  Parcela     Emissao   Real     Atraso   Val. 90 - 180     Val. 181 - 365     Val. > 365     Vencidos     C.Custo       '+cMesAnt+'  '+cMesAtu+'    Variacao')

		nCol01  := 060
		nCol02  := 068
		nCol03  := 087//086
		nCol04  := 101//094
		nCol05  := 117//106
		nCol06  := 132//108
		//133
		nCol07  := 146
		nCol08  := 159
		nCol09  := 174
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa array que sera utilizado como acumulador 		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aDados[1][1] := space(30)
	aDados[1][2] := 0
	aDados[1][3] := 0
	aDados[1][4] := 0
	aDados[1][5] := 0
	aDados[1][6] := 0
	aDados[1][7] := Space(1)
	aDados[1][8] := Space(1)
	aDados[1][9] := 0
	aDados[1][10]:= 0
	aDados[1][11]:= 0
	aDados[1][12]:= 0
	aDados[1][13]:= space(6) // Codigo do Cliente
	aDados[1][14]:= space(2) // Loja
	aDados[1][15]:= space(8) // Grupo

	aAcum[1]	 := 0
	aAcum[2]	 := 0
	aAcum[3]	 := 0
	aAcum[4]	 := 0
	aAcum[5]	 := 0
	aAcum[6]	 := 0
	aAcum[7]	 := 0
	nRede := 0

	aSub[1]:=0
	aSub[2]:=0
	aSub[3]:=0
	aSub[4]:=0
	aSub[5]:=0
	aSub[6]:=0
	aSub[7]:=0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho com o conteudo do array			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTam := TamSX3("E1_SALDO")

	Aadd(aEstru, { "NOME"   , "C",      30,       0 } )
	Aadd(aEstru, { "VALATR", "N", aTam[1], aTam[2] } ) // 90 - 180
	Aadd(aEstru, { "VALATR1", "N", aTam[1], aTam[2] } ) // 90 - 180
	Aadd(aEstru, { "VALATR2", "N", aTam[1], aTam[2] } ) //181 - 365
	Aadd(aEstru, { "VALATR3", "N", aTam[1], aTam[2] } ) //    > 365
	Aadd(aEstru, { "VALDEV" , "N", aTam[1], aTam[2] } )
	Aadd(aEstru, { "NUMTIT" , "N",       5,       0 } )
	Aadd(aEstru, { "DIAATR" , "N",       5,       0 } )
	Aadd(aEstru, { "UO"     , "C",       5,       0 } )
	Aadd(aEstru, { "GRUPO"  , "C",       1,       0 } )  //Criado pelo Francisco
	Aadd(aEstru, { "CODCLI" , "C",       6,       0 } )  //Criado pelo Francisco
	Aadd(aEstru, { "LOJA"   , "C",       2,       0 } )  //Criado pelo Francisco
	Aadd(aEstru, { "XGRPCLI", "C",       8,       0 } )  //Criado pelo Francisco
	Aadd(aEstru, { "VALANT" , "N", aTam[1], aTam[2] } )  //Criado por Marcos Furtado

	If mv_par08 == 1 //Analítico
		Aadd(aEstruAN, { "FILIAL" , "C",       2,       0 } )
		Aadd(aEstruAN, { "UO"     , "C",       5,       0 } )
		Aadd(aEstruAN, { "XGRPCLI", "C",       8,       0 } )  //Criado pelo Francisco
		Aadd(aEstruAN, { "CODCLI" , "C",       6,       0 } )  //Criado pelo Francisco
		Aadd(aEstruAN, { "LOJA"   , "C",       2,       0 } )  //Criado pelo Francisco
		Aadd(aEstruAN, { "NREDUZ" , "C",     20,       0 } )
		Aadd(aEstruAN, { "PREFIXO", "C",      3,       0 } )
		Aadd(aEstruAN, { "NUM"    , "C",      6,       0 } )
		Aadd(aEstruAN, { "PARCELA", "C",      1,       0 } )
		Aadd(aEstruAN, { "EMISSAO", "D",      8,       0 } )
		Aadd(aEstruAN, { "VENCREA", "D",      8,       0 } )
		Aadd(aEstruAN, { "CCONT"  , "C",     10,       0 } )
		Aadd(aEstruAN, { "VALOR"  , "N", aTam[1], aTam[2]} )
		Aadd(aEstruAN, { "SALDO"  , "N", aTam[1], aTam[2] } )
		Aadd(aEstruAN, { "VALATR" , "N", aTam[1], aTam[2] } ) // 90 - 180
		Aadd(aEstruAN, { "VALATR1", "N", aTam[1], aTam[2] } ) // 90 - 180
		Aadd(aEstruAN, { "VALATR2", "N", aTam[1], aTam[2] } ) //181 - 365
		Aadd(aEstruAN, { "VALATR3", "N", aTam[1], aTam[2] } ) //    > 365
		Aadd(aEstruAN, { "VALDEV" , "N", aTam[1], aTam[2] } )
		Aadd(aEstruAN, { "DIAATR" , "N",       5,       0 } )
		Aadd(aEstruAN, { "GRUPO"  , "C",       1,       0 } )  //Criado pelo Francisco

		cArqAN		:= CriaTrab(aEstruAN)
		Use &cArqAN Alias cArqAN New
		cValDevAN		:= CriaTrab("",.F.)
		cValAtrAN		:= Subs(cValDevAN,1,7)+"A"
		IndRegua("cArqAN",cValAtrAN,"XGRPCLI+UO+STR(VALATR,17,2)",,,OemToAnsi("Selecionando Registros..."))
		IndRegua("cArqAN",cValDevAN,"XGRPCLI+UO+STR(VALDEV,17,2)",,,OemToAnsi("Selecionando Registros..."))
		dbSetIndex(cValAtrAN+OrdBagExt())
	EndIf

	If mv_par07 = 1 // Contabiliza SIM
		Aadd(aEstruCTB, { "CCONT"     , "C",       10,      0 } )
		Aadd(aEstruCTB, { "TOTAL"     , "N", aTam[1], aTam[2] } )
		Aadd(aEstruCTB, { "VALOR1"     , "N", aTam[1], aTam[2] } )
		Aadd(aEstruCTB, { "VALOR2"     , "N", aTam[1], aTam[2] } )
		Aadd(aEstruCTB, { "VALOR3"     , "N", aTam[1], aTam[2] } )

		cArqCTB		:= criatrab(aEstruCTB)
		Use &cArqCTB Alias cArqCTB New
		cValDevCTB 	:= CriaTrab("",.F.)
		cValAtrCTB  := Subs(cValDevCTB,1,7)+"A"
		IndRegua("cArqCTB",cValAtrCTB,"CCONT",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."

		dbSetIndex( cValAtrCTB +OrdBagExt())
	EndIf

	cArq		:= criatrab(aEstru)
	Use &cArq Alias cArq New
	cValDev 	:= CriaTrab("",.F.)
	cValAtr     := Subs(cValDev,1,7)+"A"

	IndRegua("cArq",cValAtr,"UO + Str(VALATR,17,2)",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
	IndRegua("cArq",cValDev,"UO + Str(VALDEV,17,2)",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."

	dbSetIndex( cValAtr +OrdBagExt())
	SE5->(dbSetOrder(4)) // Para verificar se ha movimentacao bancaria
	SA6->(dbSetOrder(1)) // Para pegar a moeda do banco

	cUO := ""

	#IFDEF TOP
		if TcSrvType() != "AS/400"
			dbSelectarea("SE1")
			dbSetOrder(2)
			cOrder := SqlOrder(IndexKey())
			SetRegua( Reccount())
			dbCloseArea()
			dbSelectarea("SA1")

			// Todas filiais
			cQuery := "SELECT SE1.E1_FILIAL,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO    ,"
			cQuery += "       SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_MOEDA,SE1.E1_NATUREZ,SE1.E1_CCONT   ,"
			cQuery += "       SE1.E1_TXMOEDA,SE1.E1_EMISSAO,SE1.E1_XVENCRE,SE1.E1_VENCREA,SE1.E1_VENCTO,"
			cQuery += "       SE1.E1_VALOR,SE1.E1_SALDO,SE1.E1_SDACRES,SE1.E1_ACRESC,SE1.E1_DECRESC ,"
			cQuery += "       SE1.E1_SDDECRE, A1_XGRPCLI                                             "
			cQuery += "  FROM "+ RetSqlName("SE1") + " SE1, " +	RetSqlName("SA1") +  " SA1           "
			cQuery += " WHERE SE1.D_E_L_E_T_ <> '*' AND                                              "
			cQuery += " SA1.D_E_L_E_T_ <> '*' AND "
			cQuery += " E1_EMISSAO >= '" +DTOS(mv_par03)+"' AND "
			cQuery += " E1_EMISSAO <= '" +DTOS(mv_par04)+"' AND "
			cQuery += " E1_VENCTO  <= '" +DTOS(dDataPDD-90)+"' AND "
			cQuery += " E1_MOEDA = '1' AND "
			cQuery += " E1_TIPO <> 'NCC' AND "
			cQuery += " E1_SALDO <> 0 AND "
			cQuery += " E1_CLIENTE = A1_COD AND "
			cQuery += " E1_LOJA    = A1_LOJA  AND "
			cQuery += " A1_XGPDD = '1'"

			If !Empty(mv_par06)
				cQuery += " AND A1_GRUPO IN ( " + AllTrim(mv_par06) + ") "
			EndIf

			Do Case
			Case mv_par02 = 1  //RDVM
				cQuery += " AND (SUBSTRING(E1_CCONT,2,2) = '01' OR SUBSTRING(E1_CCONT,2,2) = '02') "

			Case mv_par02 = 2 // ILI
				cQuery += " AND SUBSTRING(E1_CCONT,2,2) = '21'  "

			Case mv_par02 = 3  //RMLAP
				cQuery += " AND SUBSTRING(E1_CCONT,2,2) = '11' "

			Case mv_par02 = 4  //RMA
				cQuery += " AND (SUBSTRING(E1_CCONT,2,2) = '22' OR SUBSTRING(E1_CCONT,2,2) = '23') "

			EndCase

			cQuery += " ORDER BY A1_XGRPCLI,SUBSTRING(E1_CCONT,2,2), E1_CLIENTE, E1_LOJA, E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO "

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)

			For ni := 1 to Len(aStru)
				If aStru[ni,2] != 'C'
					TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next
		else
			dbSelectarea("SE1")
			dbSetOrder(2)
			dbSeek(cFilial)
			SetRegua( Reccount())
		endif
	#ELSE
		dbSelectarea("SE1")
		dbSetOrder(2)
		dbSeek(cFilial)
		SetRegua( Reccount())
	#ENDIF
	nId:=1

	While !Eof() .And. lContinua
		cFilAnt :=  SE1->E1_FILIAL
		IF lEnd
			lContinua := .F.
			Exit
		Endif

		aDados[1][1] := space(30)
		aDados[1][2] := 0
		aDados[1][3] := 0
		aDados[1][5] := 0
		aDados[1][6] := 0
		aDados[1][7] := Space(2)
		aDados[1][8] := Space(1)
		nRede := 0
		nFirst  := 1
		cUOAnt:=Substr(SE1->E1_CCONT,2,2)
		Do Case
		Case cUOAnt = "01" .OR. cUOAnt = "02"
			cUOAnt := "RDVM"
		Case cUOAnt = "21"
			cUOAnt := "ILI"
		Case cUOAnt = "11"
			cUOAnt := "RMLAP"
		Case cUOAnt = "22" .OR. cUOAnt = "23"
			cUOAnt := "RMA"
		OTHERWISE
			cUOAnt := "SCC" // Sem C.Custo
		EndCase
		cUO:=cUOAnt

		cGrpCliSN	:= SE1->A1_XGRPCLI
		cCliSN  	:= SE1->E1_CLIENTE
		cLojaSN 	:= SE1->E1_LOJA
		cUOSN		:= cUO
		cCliAnt 	:= SE1->A1_XGRPCLI+cUO

		dbSelectArea("SE1")
		While SE1->A1_XGRPCLI+cUO == cCliAnt .And. !Eof()

			IF lEnd
				lContinua := .F.
				Exit
			Endif

			IncRegua()

			dbSelectArea("SA1")
			dbSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)
			If nFirst = 1
				aDados[1][1] := SubStr(A1_NOME,1,30)
				aDados[1][8] := IIF(Empty(A1_GRUPO),"*",Alltrim(A1_GRUPO))
				nFirst++
			Endif

			dbSelectarea("SE1")
			lSoma := .T.

			If SE1->E1_TIPO $ MVABATIM+"/"+MVRECANT+"/"+MV_CRNEG
				lSoma := .F.
			EndIf

			nSaldo := SE1->E1_SALDO // xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,mv_par02,SE1->E1_EMISSAO,nDecs+1)

			If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
				nSAldo -= SE1->E1_DECRESC
			Endif

			// Soma Acrescimo para recompor o saldo na data escolhida.
			If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
				nSAldo += SE1->E1_ACRESC
			Endif


			If SE1->E1_VENCTO  < dDataPDD .and. nSaldo != 0

				If lSoma
					aDados[1][2] += nSaldo  // Valor Em Atraso
				Else
					aDados[1][2] -= nSaldo  // Valor Em Atraso
				Endif

				aDados[1][5] ++    // No. de titulos

				cUO:=Substr(SE1->E1_CCONT,2,2)
				Do Case
				Case cUO = "01" .OR. cUO = "02"
					aDados[1][7] := "RDVM"
				Case cUO = "21"
					aDados[1][7] := "ILI"
				Case cUO = "11"
					aDados[1][7] := "RMLAP"
				Case cUO = "22" .OR. cUO = "23"
					aDados[1][7] := "RMA"
				OTHERWISE
					aDados[1][7] := "SCC" // Sem C.Custo
				EndCase
				cUO:=aDados[1,7]
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Calcula a Quantidade de Dias em Atraso.                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nDiasAtraso := dDataPDD - SE1->E1_VENCTO

				If nDiasAtraso >= 90 .And. nDiasAtraso <= 180
					xI := 10 //Array[1][10]
				ElseIf nDiasAtraso >= 181 .And. nDiasAtraso <= 365
					xI := 11 //Array[1][11]
				ElseIf nDiasAtraso > 365
					xI := 12 //Array[1][12]
				EndIf

				If xI >= 10
					If lSoma
						aDados[1][xI] += nSaldo  // Valor Em Atraso
					Else
						aDados[1][xI] -= nSaldo  // Valor Em Atraso
					Endif
				EndIF
				xI := 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Armazena a Quantidade de Dias em Atraso de acordo com a esco-³
				//³ lha do Usuario : mv_par02 == 1 (Media) / 2 (Maior Atraso)    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If mv_par01 == 1
					aDados[1][6] := aDados[1][6] + nDiasAtraso
				Else
					aDados[1][6] := Iif(aDados[1][6] < nDiasAtraso, nDiasAtraso, aDados[1][6])
				EndIf
			Endif

			If lSoma
				aDados[1][3] += nSaldo  // Valor Devido
				aDados[1][4] += nSaldo  // Valor Total Dos Saldos dos titulos
			Else
				aDados[1][3] -= nSaldo  // Valor Devido
				aDados[1][4] -= nSaldo  // Valor Total Dos Saldos dos titulos
			End

			If mv_par08 == 1 .and. nDiasAtraso >=90//Analítico
				//Gravando Itens
				RecLock("cArqAN",.T.)
				cArqAN->UO		:= cUO
				cArqAN->XGRPCLI	:= SE1->A1_XGRPCLI
				cArqAN->CODCLI	:= SE1->E1_CLIENTE
				cArqAN->LOJA	:= SE1->E1_LOJA
				cArqAN->NREDUZ 	:= SA1->A1_NREDUZ
				cArqAN->PREFIXO	:= SE1->E1_PREFIXO
				cArqAN->NUM		:= SE1->E1_NUM
				cArqAN->PARCELA	:= SE1->E1_PARCELA
				cArqAN->EMISSAO	:= SE1->E1_EMISSAO
				cArqAN->VENCREA	:= SE1->E1_VENCTO
				cArqAN->VALOR	:= SE1->E1_VALOR
				cArqAN->SALDO	:= SE1->E1_SALDO
				cArqAN->FILIAL	:= SE1->E1_FILIAL
				If nDiasAtraso >= 90 .And. nDiasAtraso <= 180
					cArqAN->VALATR1	:= nSaldo*0.5
				ElseIf nDiasAtraso >= 181 .And. nDiasAtraso <= 365
					cArqAN->VALATR2	:= nSaldo*0.75
				ElseIf nDiasAtraso > 365
					cArqAN->VALATR3	:= nSaldo
				EndIf
				cArqAN->VALATR	:= nSaldo //aDados[1][2]
				cArqAN->VALDEV	:= nSaldo
				cArqAN->DIAATR	:= nDiasAtraso
				cArqAN->GRUPO	:= IIF(Empty(SA1->A1_GRUPO),"*",Alltrim(SA1->A1_GRUPO))
				cArqAN->CCONT	:= SE1->E1_CCONT
				MsUnLock()
			EndIf

			If mv_par07 = 1							/// Andre
				dbSelectArea("cArqCTB")
				lInclui:=.t.
				If nDiasAtraso >= 90
					If dbSeek(SE1->E1_CCONT)
						RecLock("cArqCTB",.F.)
						If nDiasAtraso >= 90 .And. nDiasAtraso <= 180
							cArqCTB->VALOR1	+=nSaldo
						ElseIf nDiasAtraso >= 181 .And. nDiasAtraso <= 365
							cArqCTB->VALOR2	+=nSaldo
						ElseIf nDiasAtraso > 365
							cArqCTB->VALOR3	+=nSaldo
						EndIf
						MsUnLock()
					Else
						RecLock("cArqCTB",.T.)
						cArqCTB->CCONT	:=	SE1->E1_CCONT
						If nDiasAtraso >= 90 .And. nDiasAtraso <= 180
							cArqCTB->VALOR1	:=nSaldo
						ElseIf nDiasAtraso >= 181 .And. nDiasAtraso <= 365
							cArqCTB->VALOR2	:=nSaldo
						ElseIf nDiasAtraso > 365
							cArqCTB->VALOR3	:=nSaldo
						EndIf
						MsUnLock()
					EndIf
				EndIf
			EndIf
			dbSelectArea("SE1")
			SE1->(dbSkip())
			nSaldoAnt := 0
			cUO:=Substr(SE1->E1_CCONT,2,2)
			Do Case
			Case cUO = "01" .OR. cUO = "02"
				cUO:="RDVM"
			Case cUO = "21"
				cUO:="ILI"
			Case cUO = "11"
				cUO:="RMLAP"
			Case cUO = "22" .OR. cUO = "23"
				cUO:= "RMA"
			OTHERWISE
				cUO:= "SCC" // Sem C.Custo
			EndCase
		Enddo

		If aDados[1][6] >=90
			If aDados[1][6] >= 90 .And. aDados[1][6] <= 180
				aDados[1][2]:=(aDados[1][2]*0.5)
				aDados[1][3]:=(aDados[1][3]*0.5)
			ElseIf aDados[1][6] >= 181 .And. aDados[1][6] <= 365
				aDados[1][2]:=(aDados[1][2]*0.75)
				aDados[1][3]:=(aDados[1][3]*0.75)
			EndIf

			aDados[1][10]:=(aDados[1][10]*0.5)
			aDados[1][11]:=(aDados[1][11]*0.75)

			RecLock( "cArq" , .T. )

			Replace NOME    With aDados[1][1]
			Replace VALATR1	With aDados[1][10] // 90 - 180
			Replace VALATR2	With aDados[1][11] //181 - 365
			Replace VALATR3	With aDados[1][12] //    > 365
			Replace VALATR	With aDados[1][2]
			Replace VALDEV	With aDados[1][3]
			Replace NUMTIT	With aDados[1][5]
			Replace DIAATR  With Iif(mv_par01 == 1, aDados[1][6] / aDados[1][5], aDados[1][6])
			Replace UO  	With aDados[1][7]
			Replace GRUPO	With aDados[1][8]
			Replace XGRPCLI With cGrpCliSN
			Replace CODCLI  With cCliSN
			Replace LOJA    With cLojaSN
			Replace UO      With cUOSN
			MsUnlock()
		EndIf
		aDados[1][9]  := 0
		aDados[1][10] := 0
		aDados[1][11] := 0
		aDados[1][12] := 0
		aSub[1]:=0
		aSub[2]:=0
		aSub[3]:=0
		aSub[4]:=0

		nSaldo		  :=	0
		dbSelectarea("SE1")
		nId++
	Enddo

	//Retorna a Filial

	cFilAnt := cFilBkp
	dbSelectArea("SZ9")
	cFilSZ9:=xFilial("SZ9")
	dbSelectarea("cArq")
	dbSetOrder(1)

	dbGoBottom()

	SetRegua(RecCount())
	cUO:=cArq->UO
	nUO:=5

	Do Case
	Case cUO = "RDVM"
		nUO := 1
	Case cUO = "ILI"
		nUO := 2
	Case cUO = "RMLAP"
		nUO := 3
	Case cUO = "RMA"
		nUO := 4
	Case cUO = "SCC"
		nUO := 5
	EndCase
	AntUO:=nUO
	lFirst:=.t.
	aSub[1]:=0
	aSub[2]:=0
	aSub[3]:=0
	aSub[4]:=0
	aSub[5]:=0
	aSub[6]:=0
	aSub[7]:=0
	cNXGrp:=""
	While !Bof() .And. (mv_par02 == nUO .or. mv_par02 == 5)

		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")  //"CANCELADO PELO OPERADOR"
			Exit
		End

		IF cArq->VALDEV+cArq->VALATR <= 0
			dbSkip(-1)
			Loop
		Endif

		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		End

		IncRegua()

		// UO
		nPDDAnt:=BuscaPDD(cArq->XGRPCLI,cArq->CODCLI,cArq->LOJA,cArq->UO)
		cNXGrp+=cArq->XGRPCLI+","
		If AntUO <> nUO .and. !lFirst
			Do Case
			Case AntUO == 1
				cDescUO := "RDVM"
			Case AntUO == 2
				cDescUO := "ILI"
			Case AntUO == 3
				cDescUO := "RMLAP"
			Case AntUO == 4
				cDescUO := "RMA"
			Case AntUO == 5
				cDescUO := "SEM C.CUSTO"
			EndCase

			//Imprimindo PDD do Mês anterior que não foi encontrada no Mês atual
			cNXGrp:=alltrim(cNXGrp)
			If subStr(cNXGrp,len(cNXGrp),1) == ","
				cNXGrp:=subStr(cNXGrp,1,len(cNXGrp)-1)
			EndIf
			cMesTA:=strzero(month(ctod("01/"+str(month(dDataPDD))+"/"+str(year(dDataPDD)))-1),2) // Mes Anterior
			cAnoTA:=strzero( year(ctod("01/"+str(month(dDataPDD))+"/"+str(year(dDataPDD)))-1),4)
			cQry:="SELECT Z9_CLIENTE,Z9_LOJA,Z9_M"+cMesTA+" AS MES FROM "+RetSqlName("SZ9")
			cQry+=" WHERE Z9_FILIAL = '"+cFilSZ9+"'"
			cQry+="   AND Z9_ANO = '"+cAnoTA+"'"
			cQry+="   AND Z9_UO = '"+cDescUO+"'"
			cQry+="   AND Z9_XGRPCLI NOT IN ("+cNXGrp+")"
			cQry+="   AND Z9_M"+cMesTA+" <> 0"
			cQry+="   AND D_E_L_E_T_ <> '*'"
			TcQuery cQry Alias "TASZ9" New
			While !Eof()
				aSub[5]  += TASZ9->MES
				aSub[7]  -= TASZ9->MES
				aAcum[5] += TASZ9->MES
				aAcum[7] -= TASZ9->MES
				nSMesAtu:=0
				IF li > 58
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
				End

				@ li, 00 PSAY Posicione("SA1",1,xFilial("SA1")+TASZ9->Z9_CLIENTE+TASZ9->Z9_LOJA,"A1_NOME")
				@ li, nCol07 PSAY TASZ9->MES                           Picture PesqPict("SE1","E1_SALDO",13,1)
				@ li, nCol08 PSAY nSMesAtu                             	Picture PesqPict("SE1","E1_SALDO",13,1)
				@ li, nCol09 PSAY (nSMesAtu-TASZ9->MES)                   Picture "@("+PesqPict("SE1","E1_SALDO",13,1)
				LI++
				dbSelectArea("TASZ9")
				dbSkip()
			EndDo
			dbCloseArea()
			dbSelectarea("cArq")
			cNXGrp:=cArq->XGRPCLI+","

			Li++
			@Li ,  0 PSAY REPLICATE("-",limite)
			Li++
			@Li ,  0 PSAY OemToAnsi("Total Geral - ") + cDescUO

			@ li, nCol02 PSAY aSub[1]                     Picture PesqPict("SE1","E1_SALDO",13,1)
			@ li, nCol03 PSAY aSub[2]                     Picture PesqPict("SE1","E1_SALDO",13,1)
			@ li, nCol04 PSAY aSub[3]                     Picture PesqPict("SE1","E1_SALDO",13,1)
			@ li, nCol05 PSAY aSub[4]                      Picture PesqPict("SE1","E1_SALDO",13,1)
			@ li, nCol07 PSAY aSub[5]                      Picture PesqPict("SE1","E1_SALDO",13,1)
			@ li, nCol08 PSAY aSub[6]                      Picture PesqPict("SE1","E1_SALDO",13,1)
			@ li, nCol09 PSAY aSub[7]                      Picture PesqPict("SE1","E1_SALDO",13,1)
			Li++
			@Li ,  0 PSAY REPLICATE("-",limite)
			Li+=2
			nRede := 0
			nRede := nRede + cArq->VALDEV
			aAcum[5] += nPDDAnt
			aAcum[6] += cArq->VALATR1+cArq->VALATR2+cArq->VALATR3
			aAcum[7] += cArq->VALATR1+cArq->VALATR2+cArq->VALATR3-nPDDAnt

			aSub[1]:=cArq->VALATR1
			aSub[2]:=cArq->VALATR2
			aSub[3]:=cArq->VALATR3
			aSub[4]:=cArq->VALATR1+cArq->VALATR2+cArq->VALATR3
			aSub[5]:=nPDDAnt
			aSub[6]:=aSub[4]
			aSub[7]:=aSub[4]-aSub[5]

			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)

		Else
			nRede := nRede + cArq->VALDEV
			aSub[1]+=cArq->VALATR1
			aSub[2]+=cArq->VALATR2
			aSub[3]+=cArq->VALATR3
			aSub[4]+=cArq->VALATR1+cArq->VALATR2+cArq->VALATR3
			aSub[5]+=nPDDAnt
			aSub[6]+=cArq->VALATR1+cArq->VALATR2+cArq->VALATR3
			aSub[7]+=cArq->VALATR1+cArq->VALATR2+cArq->VALATR3-nPDDAnt

			aAcum[5] += nPDDAnt
			aAcum[6] += cArq->VALATR1+cArq->VALATR2+cArq->VALATR3
			aAcum[7] += cArq->VALATR1+cArq->VALATR2+cArq->VALATR3-nPDDAnt

		Endif

		@ li, 00 PSAY cArq->NOME
		@ li, nCol01 PSAY cArq->DIAATR                     Picture "99999"

		@ li, nCol02 PSAY cArq->VALATR1                     Picture PesqPict("SE1","E1_SALDO",13,1)
		@ li, nCol03 PSAY cArq->VALATR2                     Picture PesqPict("SE1","E1_SALDO",13,1)
		@ li, nCol04 PSAY cArq->VALATR3                     Picture PesqPict("SE1","E1_SALDO",13,1)
		nSoma:=cArq->VALATR1+cArq->VALATR2+cArq->VALATR3
		@ li, nCol05 PSAY nSoma                             Picture PesqPict("SE1","E1_SALDO",13,1)
		@ li, nCol07 PSAY nPDDAnt                           Picture PesqPict("SE1","E1_SALDO",13,1)
		@ li, nCol08 PSAY nSoma                             Picture PesqPict("SE1","E1_SALDO",13,1)
		@ li, nCol09 PSAY (nSoma-nPDDAnt)                   Picture "@("+PesqPict("SE1","E1_SALDO",13,1)

		If mv_par08 = 1 //Analitico
			ImpDet(cArq->XGRPCLI,cArq->CODCLI,cArq->LOJA,cArq->UO)
		EndIf

		aAcum[1] += cArq->VALATR1
		aAcum[2] += cArq->VALATR2
		aAcum[3] += cArq->VALATR3
		aAcum[4] += nSoma

		AntUO	:=	nUO
		AntDescr := cDescUO
		lFirst:=.f.
		dbSelectarea("cArq")
		dbSkip(-1)
		Li++
		nC++

		cUO:=cArq->UO

		Do Case
		Case cUO = "RDVM"
			nUO := 1
		Case cUO = "ILI"
			nUO := 2
		Case cUO = "RMLAP"
			nUO := 3
		Case cUO = "RMA"
			nUO := 4
		Case cUO = "SCC"
			nUO := 5
		EndCase

	End

	If nRede <> 0
		Do Case
		Case AntUO == 1
			cDescUO := "RDVM"
		Case AntUO == 2
			cDescUO := "ILI"
		Case AntUO == 3
			cDescUO := "RMLAP"
		Case AntUO == 4
			cDescUO := "RMA"
		Case AntUO == 5
			cDescUO := "SEM C.CUSTO"
		EndCase
		//Imprimindo PDD do Mês anterior que não foi encontrada no Mês atual
		cNXGrp:=alltrim(cNXGrp)
		If subStr(cNXGrp,len(cNXGrp),1) == ","
			cNXGrp:=subStr(cNXGrp,1,len(cNXGrp)-1)
		EndIf
		cMesTA:=strzero(month(ctod("01/"+str(month(dDataPDD))+"/"+str(year(dDataPDD)))-1),2) // Mes Anterior
		cAnoTA:=strzero( year(ctod("01/"+str(month(dDataPDD))+"/"+str(year(dDataPDD)))-1),4)
		cQry:="SELECT Z9_CLIENTE,Z9_LOJA,Z9_M"+cMesTA+" AS MES FROM "+RetSqlName("SZ9")
		cQry+=" WHERE Z9_FILIAL = '"+cFilSZ9+"'"
		cQry+="   AND Z9_ANO = '"+cAnoTA+"'"
		cQry+="   AND Z9_UO = '"+cDescUO+"'"
		cQry+="   AND Z9_XGRPCLI NOT IN ("+cNXGrp+")"
		cQry+="   AND Z9_M"+cMesTA+" <> 0"
		cQry+="   AND D_E_L_E_T_ <> '*'"
		TcQuery cQry Alias "TASZ9" New
		While !Eof()
			aSub[5]  += TASZ9->MES
			aSub[7]  -= TASZ9->MES
			aAcum[5] += TASZ9->MES
			aAcum[7] -= TASZ9->MES
			nSMesAtu:=0
			IF li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
			End

			@ li, 00 PSAY Posicione("SA1",1,xFilial("SA1")+TASZ9->Z9_CLIENTE+TASZ9->Z9_LOJA,"A1_NOME")
			@ li, nCol07 PSAY TASZ9->MES                           Picture PesqPict("SE1","E1_SALDO",13,1)
			@ li, nCol08 PSAY nSMesAtu                             	Picture PesqPict("SE1","E1_SALDO",13,1)
			@ li, nCol09 PSAY (nSMesAtu-TASZ9->MES)                   Picture "@("+PesqPict("SE1","E1_SALDO",13,1)
			LI++
			dbSelectArea("TASZ9")
			dbSkip()
		EndDo
		dbCloseArea()
		dbSelectarea("cArq")
		cNXGrp:=cArq->XGRPCLI+","

		Li++
		@Li ,  0 PSAY REPLICATE("-",limite)
		Li++

		@Li ,  0 PSAY OemToAnsi("Total Geral - ") + cDescUO
		@ li, nCol02 PSAY aSub[1]                     Picture PesqPict("SE1","E1_SALDO",13,1)
		@ li, nCol03 PSAY aSub[2]                     Picture PesqPict("SE1","E1_SALDO",13,1)
		@ li, nCol04 PSAY aSub[3]                     Picture PesqPict("SE1","E1_SALDO",13,1)
		@ li, nCol05 PSAY aSub[4]                      Picture PesqPict("SE1","E1_SALDO",13,1)
		@ li, nCol07 PSAY aSub[5]                      Picture PesqPict("SE1","E1_SALDO",13,1)
		@ li, nCol08 PSAY aSub[6]                      Picture PesqPict("SE1","E1_SALDO",13,1)
		@ li, nCol09 PSAY aSub[7]                      Picture PesqPict("SE1","E1_SALDO",13,1)
		Li++
		@Li ,  0 PSAY REPLICATE("-",limite)
		Li+=2
		nRede := 0
	EndIF


	ImptotG(aAcum,nT)


	IF li != 80
		roda(cbcont,cbtxt,"G")
	End

	If FILE(cArqAN+".DBF")     //Elimina o arquivo de trabalho
		dbSelectArea("cArqAN")
		dbCloseArea()
		Ferase(cArqAN+".DBF")
		Ferase("CVALDEVAN"+OrdBagExt())
		Ferase("CVALATRAN"+OrdBagExt())
	End

	Set Device To Screen

	#IFNDEF TOP
		dbSelectArea("SE1")
		dbSetOrder(1)
		Set Filter To
	#ELSE
		if TcSrvType() != "AS/400"
			dbSelectArea("SE1")
			dbCloseArea()
			ChKFile("SE1")
			dbSetOrder(1)
		else
			dbSelectArea("SE1")
			dbSetOrder(1)
			Set Filter To
		endif
	#ENDIF

	If aReturn[5] = 1
		Set Printer To
		dbCommit()
		ourspool(wnrel)
	End
	MS_FLUSH()

	If mv_par07 = 1 //Contabiliza
		nRet:=Aviso("ATENÇÃO", "Será feita a contabilização dos valores apresentados no relatório.  Deseja realmente continuar?", { "Sim","Nao" },2)
		If nRet = 1 //Continuar
			Processa({|| CTB() },"Gerando Lancamento Contábil...")
			Processa({|| SaveSZ9() },"Salvando PDD...")
		EndIf
		If FILE(cArqCTB+".DBF")     //Elimina o arquivo de trabalho
			dbSelectArea("cArqCTB")
			dbCloseArea()
			Ferase(cArqCTB+".DBF")
			Ferase("CVALDEVCTB"+OrdBagExt())
			Ferase("CVALATRCTB"+OrdBagExt())
		End
	EndIf

	If FILE(cArq+".DBF")     //Elimina o arquivo de trabalho
		dbSelectArea("cArq")
		dbCloseArea()
		Ferase(cArq+".DBF")
		Ferase("CVALDEV"+OrdBagExt())
		Ferase("CVALATR"+OrdBagExt())
	End

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ IMPDET 	³ Autor ³ Marcelo Aguiar Pimentel Data 09/02/07   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³IMPRIMIR DETALHE QUANDO RELATORIO EM ANALITICO    		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ IMPDET() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³	        												  ³±±
±±             pXGRPCLI: GRUPO DO CLIENTE								  ³±±
±±             pCODCLI : CODIGO DO CLIENTE  							  ³±±
±±             pLOJA   : LOJA  DO CLIENTE								  ³±±
±±             pUO     : Unidade Operacional         					  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpDet(pXGRPCLI,pCODCLI,pLOJA,pUO)
	Local aArea:=GetArea()
	dbSelectArea("cArqAN")

	dbGoTop()
	dbSeek(pXGRPCLI+pUO)//+pCODCLI+pLOJA+pUO)
	li++

	While !Eof() .And. pXGRPCLI+pUO == cArqAN->XGRPCLI+cArqAN->UO
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		End
		cCol:=cArqAN->FILIAL+"- "+cArqAN->CODCLI+"-"+cArqAN->LOJA+"-"+SubStr(cArqAN->NREDUZ,1,12)+" "
		cCol+=cArqAN->PREFIXO+"-"+cArqAN->NUM+"-"+cArqAN->PARCELA
		// 47
		@ li,000 PSAY cCol
		@ li,040 PSAY cArqAN->EMISSAO PICTURE PesqPict("SE1","E1_EMISSAO")
		@ li,050 PSAY cArqAN->VENCREA PICTURE PesqPict("SE1","E1_VENCREA")
		nSoma:=cArqAN->VALATR1+cArqAN->VALATR2+cArqAN->VALATR3
		@ li, nCol02 PSAY cArqAN->VALATR1                     Picture PesqPict("SE1","E1_SALDO",13,1)
		@ li, nCol03 PSAY cArqAN->VALATR2                     Picture PesqPict("SE1","E1_SALDO",13,1)
		@ li, nCol04 PSAY cArqAN->VALATR3                     Picture PesqPict("SE1","E1_SALDO",13,1)
		@ li, nCol05 PSAY nSoma			                      Picture PesqPict("SE1","E1_SALDO",13,1)
		@ li, nCol06 PSAY cArqAN->CCONT                       Picture PesqPict("SE1","E1_CCONT",13,1)
		li++
		dBSkip()
	EndDo

	RestArea(aArea)
	dbSelectArea("cArq")
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ IMPTOTG	³ Autor ³ Paulo Boschetti		³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³IMPRIMIR TOTAL DO RELATORIO								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ IMPTOTG()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso 	 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpTotG(aAcum,nT)

	Li++
	@Li ,  0 PSAY REPLICATE("-",limite)
	Li++
	@Li ,  0 PSAY OemToAnsi("Total Geral ") //"Total dos "###" maiores devedores"
	@Li , nCol02 PSAY aAcum[1]						  PICTURE PesqPict("SE1","E1_SALDO",13,1)
	@Li , nCol03 PSAY aAcum[2]						  PICTURE PesqPict("SE1","E1_SALDO",13,1)
	@Li , nCol04 PSAY aAcum[3]						  PICTURE PesqPict("SE1","E1_SALDO",13,1)//"99999"
	@Li , nCol05 PSAY aAcum[1]+aAcum[2]+aAcum[3]	  PICTURE PesqPict("SE1","E1_SALDO",13,1)//"99999"
	@Li , nCol07 PSAY aAcum[5]						  PICTURE PesqPict("SE1","E1_SALDO",13,1)//"99999"
	@Li , nCol08 PSAY aAcum[6]						  PICTURE PesqPict("SE1","E1_SALDO",13,1)//"99999"
	@Li , nCol09 PSAY aAcum[7]						  PICTURE "@("+PesqPict("SE1","E1_SALDO",13,1)//"99999"
	Li++
	@Li ,  0 PSAY REPLICATE("-",limite)
	Li+=2
Return .T.

/********************************************************************
* Funcao.....: CTB()												*
* Autor......: Marcelo Aguiar Pimentel            					*
* Data.......: 13/02/2007											*
* Descricao..: Rotina para realizar o Lanca.Contabil do valores do  *
*              relatório.                                           *
*																	*
********************************************************************/
Static Function CTB()
	Private nValCred := 0
	Private nValDeb  := 0
	Private cArquivo  := ""
	Private nTotal    := 0
	Private lDigita   := .T.
	Private cPadrao := ""
	Private nPrazoC  := 0
	Private nVistaC  := 0
	Private nPrazoD  := 0
	Private nVistaD  := 0
	Private nHdlPrv := ""
	Private nValorFil := 0
	Private nBaseIcm  := 0
	Private nValIcm   := 0
	Private nValorCTB := 0
	Private nPerc      := MV_PAR07  // %

	//Variáveis Utilizadas na Rotina de Lançcamentos Contábeis

	cPadrao  := "062" // CODIGO DO LANCAMENTO PADRAO PARA CONTABILIZACAO


	nHdlPrv := HeadProva("000001","CTBA102",Substr(cUsuario,7,6),@cArquivo) //Abre o lançamento contábil


	DbSelectArea("cArqCTB")
	nValorCTB := 0
	ProcRegua(cArqCTB->(RecCount())+2)
	DbGotop()
	While !Eof()
		IncProc()
		cCusto    	:= cArqCTB->CCONT
		If Empty(cCusto)
			dbskip()
			loop
		EndIf

		RecLock("cArqCTB",.f.)
		cArqCTB->VALOR1 := cArqCTB->VALOR1*0.5
		cArqCTB->VALOR2 := cArqCTB->VALOR2*0.75
		cArqCTB->VALOR3 := cArqCTB->VALOR3
		MsUnLock()

		nValDeb	  	:= cArqCTB->VALOR1+cArqCTB->VALOR2+cArqCTB->VALOR3//cArqCTB->VALOR
		nValorCTB  	+= nValDeb//(cArqCTB->VALOR1*0.5)+(cArqCTB->VALOR2*0.75)+cArqCTB->VALOR3//cArqCTB->VALOR
		nValCred	:=0
		nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CTBA102","000001") //Inclui uma linha no lançamento contábil
		DbSkip()
	EndDo

	If nValorCTB <> 0
		nValDeb := 0
		nValCred:= nValorCTB
		nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CTBA102","000001") //inclui o Último Lançamento de Débito
		IncProc()
		RodaProva(nHdlPrv,nTotal) //Roda o Lançamento
		IncProc()
		cA100Incl(cArquivo,nHdlPrv,3,"000001",lDigita,.F.) 	// Envia para Lancamento Contabil

		nValDeb  := 0
	EndIf

Return

/********************************************************************
* Funcao.....: SaveSZ9()											*
* Autor......: Marcelo Aguiar Pimentel            					*
* Data.......: 13/02/2007											*
* Descricao..: Rotina para atualizar a tabela de lancamento realiza *
*              dos anteriormente.                                   *
*																	*
********************************************************************/
/*
array de aPDDCtb
01 Ano
02 Grupo de Cliente
03 Codigo do Cliente
04 Loja do cliente
05 Centro de Custo
06 Valor 1
07 Valor 2
08 Valor 3
09 Jan
10 UO
*/
Static Function SaveSZ9()
	Local nX

	dbSelectArea("SZ9")
	dbSetOrder(1)

	dbSelectArea("cArq")
	ProcRegua(cArq->(RecCount()))
	dbSetOrder(1)
	dbGoTop()
	cCampo			:=  "Z9_M"+STRZERO(month(dDataPDD),2)
	While !Eof()
		IncProc()
		cUO:=cArq->UO
		If cUO != "SCC"
			// Filial       + Ano+UO +  Grupo Cli  +  Cliente    + Loja
			cAno:=alltrim(str(year(dDataPDD)))
			dbSelectArea("SZ9")
			lInclui:=.t.
			If dbSeek(xFilial("SZ9")+cAno+cUO+cArq->XGRPCLI+cArq->CODCLI +cArq->LOJA)
				lInclui:=.f.
			EndIf
			RecLock("SZ9",lInclui)
			SZ9->Z9_FILIAL	:=	xFilial("SZ9")//"PR" // Processamento posterior xFilial("SZ9")
			SZ9->Z9_ANO   	:=	cAno
			SZ9->Z9_XGRPCLI	:=	cArq->XGRPCLI
			SZ9->Z9_CLIENTE	:=	cArq->CODCLI
			SZ9->Z9_LOJA  	:=	cArq->LOJA
			SZ9->Z9_VALOR1 	+=	cArq->VALATR1
			SZ9->Z9_VALOR2 	+=	cArq->VALATR2
			SZ9->Z9_VALOR3 	+=	cArq->VALATR3
			nSoma			:=	cArq->VALATR1+cArq->VALATR2+cArq->VALATR3
			SZ9->&cCampo	+=	nSoma
			SZ9->Z9_UO		:=	cUO
			MsUnLock()
		EndIf
		dbSelectArea("cArq")
		dbSkip()
	EndDo

Return

/********************************************************************
* Funcao.....: BuscaPDD(pGrpCli,pCliente,pCOD,pLoja,pCCont)         *
* Autor......: Marcelo Aguiar Pimentel            					*
* Data.......: 13/02/2007											*
* Descricao..: Rotina para buscar na tabela SZ9 Lancamentos Contab. *
*              de PDD realizados anteriormente.                     *
*																	*
********************************************************************/
Static Function BuscaPDD(pGrpCli,pCliente,pLoja,pUO)
	Local cQry:=""
	Local nRet:=0

	cMes:=strzero(month(ctod("01/"+str(month(dDataPDD))+"/"+str(year(dDataPDD)))-1),2)
	cAno:=strzero( year(ctod("01/"+str(month(dDataPDD))+"/"+str(year(dDataPDD)))-1),4)

	cQry:="SELECT SUM(Z9_M"+cMes+") AS MES "
	cQry+="  FROM "+RetSqlName("SZ9")
	cQry+=" WHERE Z9_FILIAL   = '"+xFilial("SZ9")+"'"
	cQry+="   AND Z9_ANO      = '"+cAno          +"'"
	cQry+="   AND Z9_UO       = '"+pUO           +"'"
	cQry+="   AND Z9_XGRPCLI  = '"+pGrpCli       +"'"
	cQry+="   AND D_E_L_E_T_ <> '*'"
	TcQuery cQry Alias "TSZ9" New
	While !Eof()
		nRet+=TSZ9->MES
		dbSkip()
	EndDo
	dbCloseArea()
Return nRet


