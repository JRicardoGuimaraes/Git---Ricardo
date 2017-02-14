//#Include "FIVEWIN.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FINR300	³ Autor ³ Paulo Boschetti		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao dos maiores atrasos/devedores							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR300(void)															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Adicionado tratamento por U.O e filtro de datas - Saulo Muniz 01/12/05 (20 maiores)
// Criar separação por Grupo e filtrar 20 clientes por vez. !!!!!
// Atualizado U.O - Saulo Muniz 10/04/06
// Adicionado filtro por emissão - Saulo Muniz 22/05/06


User Function GFIN005()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis											 				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1 := "Este programa ira  emitir a rela‡ao dos maiores,"
LOCAL cDesc2 := "devedores/atrasos"
LOCAL cDesc3 :=""
LOCAL limite := 132
LOCAL cString:="SE1"
LOCAL Tamanho:="M"

PRIVATE titulo
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:= "GFIN005"
PRIVATE aLinha	:= { },nLastKey := 0
PRIVATE cPerg	:= "FIN300"
PRIVATE nLastKey:=0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros			   ³
//³ mv_par01  // Quantidade							   ³
//³ mv_par02  // Dias em Atraso (Media ou Maior Atraso)³
//³ mv_par03  // Qual moeda                            ³
//³ mv_par04  // Outras moedas                         ³
//³ mv_par05  // Unid.Operacioal                       ³
//³ mv_par06  // Da Emissao                            ³
//³ mv_par07  // Ate a Emissao                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas					  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("FIN300",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT	  		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel  := "GFIN005"            //Nome Default do relatorio em Disco
titulo := OemToAnsi("Relacao dos Maiores Devedores")  //"Relacao dos Maiores Devedores"
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

cDescUO :=""
cDescGR :="GRUPO GEFCO"            
lTotais := .T.
AntGRUPO := "9"
AntDescr :=""

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa300Imp(@lEnd,wnRel,cString)},titulo)
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
LOCAL tamanho   := "M"
LOCAL lContinua := .T.
LOCAL cCliAnt	:= SPACE(6)
LOCAL aDados[1][8]
//LOCAL aDados[1][6]
LOCAL aAcum[3]
LOCAL nC:=1 , nT:= 1
LOCAL nFirst	:= 0
LOCAL aEstru	:={},aTam:={}
LOCAL cArq		:= SPACE(8)
Local lSoma
Local cValDev, cValAtr
Local nSaldo      := 0
Local nDiasAtraso := 0
Local aStru := SE1->(dbStruct()), ni
Local nDecs := MsDecimais(mv_par03)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt	 := SPACE(10)
cbcont	 := 0
li		 := 80
m_pag	 := 1
UnidOp   := " "

Do Case
   Case MV_PAR05 == 1
        UnidOp := "RDVM"
   Case MV_PAR05 == 2
        UnidOp := "ILI"
   Case MV_PAR05 == 3
        UnidOp := "RMLAP"
   Case MV_PAR05 == 4
        UnidOp := "RMA"
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par01 = 1
	titulo := OemToAnsi('Relacao Do Maior Devedor') + " - " + UnidOp //'Relacao Do Maior Devedor'
Else
	titulo := OemToAnsi('Relacao dos ')+alltrim(str(mv_par01))+OemToAnsi(' Maiores Devedores') + " - " + UnidOp  //'Relacao dos '###' Maiores Devedores'
Endif

//cabec1 := OemToAnsi('Nome do Cliente                   Valor em Atraso Valor Total Devido N.Tit %Tot  Dias em Atraso')  //'Nome do Cliente                   Valor em Atraso Valor Total Devido N.Tit %Tot  Dias em Atraso'
cabec1 := OemToAnsi('Nome do Cliente                   Valor em Atraso Valor Total Devido N.Tit %Tot  Dias em Atraso          Rede/Grupo')  
cabec2 := ''

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
aAcum[1]	 := 0
aAcum[2]	 := 0
aAcum[3]	 := 0
nRede := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho com o conteudo do array			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam := TamSX3("E1_SALDO")

Aadd(aEstru, { "NOME"  , "C",      30,       0 } )
Aadd(aEstru, { "VALATR", "N", aTam[1], aTam[2] } )
Aadd(aEstru, { "VALDEV", "N", aTam[1], aTam[2] } )
Aadd(aEstru, { "NUMTIT", "N",       5,       0 } )
Aadd(aEstru, { "DIAATR", "N",       5,       0 } )
Aadd(aEstru, { "UO"    , "C",       2,       0 } )
Aadd(aEstru, { "GRUPO" , "C",       1,       0 } )  //Criado pelo Francisco
               
cArq		:= criatrab(aEstru)
Use &cArq Alias cArq New
cValDev 	:= CriaTrab("",.F.)
cValAtr     := Subs(cValDev,1,7)+"A"

If MV_PAR05 = 1 //RDVM
   IndRegua("cArq",cValAtr,"GRUPO + Str(VALATR,17,2)",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
   IndRegua("cArq",cValDev,"GRUPO + Str(VALDEV,17,2)",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
Else   
   IndRegua("cArq",cValAtr,"VALATR",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
   IndRegua("cArq",cValDev,"VALDEV",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
Endif

dbSetIndex( cValAtr +OrdBagExt())
SE5->(dbSetOrder(4)) // Para verificar se ha movimentacao bancaria
SA6->(dbSetOrder(1)) // Para pegar a moeda do banco

cUO := 0

#IFDEF TOP
   if TcSrvType() != "AS/400"
		dbSelectarea("SE1")
		dbSetOrder(2)
		cOrder := SqlOrder(IndexKey())
		SetRegua( Reccount())
		dbCloseArea()
		dbSelectarea("SA1") 
        /*
		cQuery := "SELECT * "
		cQuery += "  FROM "+	RetSqlName("SE1")
		cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "'"
		cQuery += "   AND D_E_L_E_T_ <> '*' "
		cQuery += " ORDER BY " + cOrder
        */
		
		// Todas filiais
		cQuery := "SELECT * "
		cQuery += "  FROM "+	RetSqlName("SE1")
		cQuery += " WHERE D_E_L_E_T_ <> '*' AND"
        cQuery += " E1_EMISSAO >=" + "'"+DTOS(Mv_Par06)+"'" +  " AND "
        cQuery += " E1_EMISSAO <=" + "'"+DTOS(Mv_Par07)+"'" 
		cQuery += " ORDER BY " + cOrder

		cQuery := ChangeQuery(cQuery)

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

While !Eof() .And. lContinua 
//While !Eof() .And. lContinua //.and. SE1->E1_FILIAL == cFilial
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
	cCliAnt := SE1->E1_CLIENTE+E1_LOJA

	While SE1->E1_CLIENTE+E1_LOJA == cCliAnt .And. !Eof()
	//While SE1->E1_CLIENTE+E1_LOJA == cCliAnt .And. !Eof()

		IF lEnd
			lContinua := .F.
			Exit
		Endif

		IncRegua()
		      
		// Desconsidera registros que nao sao da moeda informada se escolhido nao imp.
		If  mv_par04 == 2 .AND. SE1->E1_MOEDA != mv_par03 
		   SE1->(dbSkip())                
		   Loop
		EndIf

        // Filtra UO
		Do Case
		   Case Substr(SE1->E1_CCONT,2,2) == "01" .OR. Substr(SE1->E1_CCONT,2,2) == "02"
		        cUO := 1
		   Case Substr(SE1->E1_CCONT,2,2) == "21" 
		        cUO := 2         
		   Case Substr(SE1->E1_CCONT,2,2) == "11" 
		        cUO := 3   
		   Case Substr(SE1->E1_CCONT,2,2) == "22" .OR. Substr(SE1->E1_CCONT,2,2) == "23" 
		        cUO := 4            
		EndCase				

		If mv_par05 <> cUO
		   SE1->(dbSkip())                
		   Loop
		EndIf

		If nFirst = 1
			dbSelectArea("SA1")
			dbSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)
            aDados[1][1] := SubStr(A1_NOME,1,30)
            aDados[1][8] := IIF(Empty(A1_GRUPO),"*",Alltrim(A1_GRUPO))
			nFirst++
		Endif

		dbSelectarea("SE1")
		lSoma := .T.

        If SE1->E1_TIPO $ MVABATIM+"/"+MVRECANT+"/"+MV_CRNEG
			lSoma := .F.
		EndIf                         
		                                     
		nSaldo := xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,mv_par03,SE1->E1_EMISSAO,nDecs+1)

		If SE1->E1_VENCREA < dDataBase .and. nSaldo != 0
			
			If lSoma
				aDados[1][2] += nSaldo  // Valor Em Atraso
			Else
				aDados[1][2] -= nSaldo  // Valor Em Atraso
            Endif

			aDados[1][5] ++    // No. de titulos
			aDados[1][7] := Substr(SE1->E1_CCONT,2,2)  // U.O.
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula a Quantidade de Dias em Atraso.                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nDiasAtraso := dDataBase - SE1->E1_VENCREA

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Armazena a Quantidade de Dias em Atraso de acordo com a esco-³
			//³ lha do Usuario : mv_par02 == 1 (Media) / 2 (Maior Atraso)    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par02 == 1
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
			
		SE1->(dbSkip())
		
	Enddo

	RecLock( "cArq" , .T. )

    Replace NOME    With aDados[1][1]
	Replace VALATR	With aDados[1][2]
	Replace VALDEV	With aDados[1][3]
	Replace NUMTIT	With aDados[1][5]
	Replace DIAATR  With Iif(mv_par02 == 1, aDados[1][6] / aDados[1][5], aDados[1][6])
	Replace UO  	With aDados[1][7]
	Replace GRUPO	With aDados[1][8]
	MsUnlock()
	
	dbSelectarea("SE1")
Enddo

dbSelectarea("cArq")
dbSetOrder(1)
//dbGotop()
dbGoBottom()

SetRegua(RecCount())

Do Case
   Case cArq->UO == "01" .OR. cArq->UO == "02"
        cUO := 1
   Case cArq->UO == "21" 
        cUO := 2         
   Case cArq->UO == "11" 
        cUO := 3   
   Case cArq->UO == "22" .OR. cArq->UO == "23" 
        cUO := 4            
EndCase

//While !Eof() .And. MV_PAR05 == cUO
While !Bof() .And. MV_PAR05 == cUO
//While !Bof() .And. nC <= mv_par01
	
	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")  //"CANCELADO PELO OPERADOR"
		Exit
	End
	
	IF VALDEV+VALATR <= 0
		dbSkip(-1)
		Loop
	Endif
    
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
	End

	IncRegua()
        
    // UO
    Do Case
       Case UO == "1"
            cDescUO := "RDVM"
       Case UO == "2"
            cDescUO := "ILI"
       Case UO == "3"
            cDescUO := "RMLAP"
       Case UO == "4"
            cDescUO := "RMA"       
    EndCase

    Do Case
       Case GRUPO == "1"
            cDescGR := "PEUGEOT"
       Case GRUPO == "2"
            cDescGR := "SHC"
       Case GRUPO == "3"
            cDescGR := "INDEP"
       Case GRUPO == "4"
            cDescGR := "TIERS"
       Case GRUPO == "5"
			cDescGR	:= "PSA"
       Case GRUPO == "6"
			cDescGR	:= "GEFCO"
       Case GRUPO == "9"
            cDescGR := "EMPRESAS DO GRUPO" //"GRUPO GEFCO"            
    EndCase

    If AntGRUPO <> GRUPO 
        Li++
		@Li ,  0 PSAY REPLICATE("-",132)
		Li++		
		@Li ,  0 PSAY OemToAnsi("Total Geral - ") + IIf(Empty(AntDescr),"PEUGEOT",AntDescr)
		@Li , 54 PSAY nRede	  PICTURE PesqPict("SE1","E1_SALDO",13,mv_par03)
		Li++		
		@Li ,  0 PSAY REPLICATE("-",132)
		Li+=2		    
        nRede := 0
        nRede := nRede + VALDEV            
    Else
        nRede := nRede + VALDEV    
    Endif
      
	@ li, 00 PSAY NOME
	@ li, 35 PSAY VALATR                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 54 PSAY VALDEV                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 68 PSAY NUMTIT                     Picture "99999"
	@ li, 74 PSAY (VALDEV/aDados[1][4])*100  Picture "999.9"
	@ li, 90 PSAY DIAATR                     Picture "99999"

	//If MV_PAR05 == 1
   	   @ li, 97 PSAY cDescUO
	   @ li, 105 PSAY cDescGR
    //Endif

	aAcum[1] += VALATR
	aAcum[2] += VALDEV
	aAcum[3] += NUMTIT
    AntGRUPO := GRUPO
    AntDescr := cDescGR
    dbSkip(-1)
	Li++
	nC++
    
    //If nC == 20
    //   Exit
    //Endif
    
End

ImptotG(aAcum,nT)

//Cortada 2ºparte do relatorio
/*

nC		 := 1
nT		 := 2
cbtxt	 := SPACE(10)
cbcont	 := 0
li		 := 80
m_pag	 := 1
aAcum[1] := 0
aAcum[2] := 0
aAcum[3] := 0

dbSetOrder( 2 )
dbGotop()
//dbGoBottom()

If mv_par01 = 1
	titulo := OemToAnsi('Relacao Do Maior Atraso') + " - " + UnidOp //'Relacao Do Maior Devedor'
Else
	titulo := OemToAnsi('Relacao dos ')+alltrim(str(mv_par01))+OemToAnsi(' Maiores Atrasos') + " - " + UnidOp  //'Relacao dos '###' Maiores Devedores'
Endif

SetRegua(Reccount())

While !Eof() //.And. nC <= mv_par01
//While !Bof() .And. nC <= mv_par01

	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
	End

	IncRegua()
    
     //cUO := UO

	IF VALDEV+VALATR <= 0
		dbSkip()
		Loop
	Endif
    
    // UO
    Do Case
       Case UO == "1"
            cDescUO := "RDVM"
       Case UO == "2"
            cDescUO := "ILI"
       Case UO == "3"
            cDescUO := "RMLAP"
       Case UO == "4"
            cDescUO := "RMA"       
    EndCase

    Do Case
       Case GRUPO == "1"
            cDescGR := "PEUGEOT"
       Case GRUPO == "2"
            cDescGR := "SHC"
       Case GRUPO == "3"
            cDescGR := "INDEP"
       Case GRUPO == "4"
            cDescGR := "TIERS"
       Case GRUPO == "9"
            cDescGR := "GRUPO GEFCO"            
    EndCase

    If AntGRUPO <> GRUPO 
        Li++
		@Li ,  0 PSAY REPLICATE("-",132)
		Li++		
		@Li ,  0 PSAY OemToAnsi("Total Geral - ") + cDescGR
		@Li , 54 PSAY nRede	  PICTURE PesqPict("SE1","E1_SALDO",13,mv_par03)
		Li++		
		@Li ,  0 PSAY REPLICATE("-",132)
		Li+=2		    
        nRede := 0
    Else
        nRede := nRede + VALDEV    
    Endif

	@ li, 00 PSAY NOME
	@ li, 35 PSAY VALATR                    Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 54 PSAY VALDEV                    Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 68 PSAY NUMTIT                    Picture "99999"
	@ li, 75 PSAY (VALDEV/aDados[1][4])*100 Picture "99.9"
	@ li, 90 PSAY DIAATR                    Picture "99999"

	//If MV_PAR05 == 1
   	   @ li, 97 PSAY cDescUO
	   @ li, 105 PSAY cDescGR
    //Endif

	aAcum[1] += VALATR
	aAcum[2] += VALDEV
	aAcum[3] += NUMTIT
    AntGRUPO := GRUPO
	DbSkip() 
	Li++
	nC++
End

ImpTotG(aAcum,nT)

*/

IF li != 80
	roda(cbcont,cbtxt,"M")
End

If FILE(cArq+".DBF")     //Elimina o arquivo de trabalho
    dbCloseArea()
    Ferase(cArq+".DBF")
    Ferase("CVALDEV"+OrdBagExt())
    Ferase("CVALATR"+OrdBagExt())
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
@Li ,  0 PSAY REPLICATE("-",132)
Li++
If nT = 1
	@Li ,  0 PSAY OemToAnsi("Total dos ")+alltrim(str(mv_par01))+OemToAnsi(" maiores devedores")  //"Total dos "###" maiores devedores"
Else
	@Li ,  0 PSAY OemToAnsi("Total dos ")+alltrim(str(mv_par01))+OemToAnsi(" Maiores Atrasos") //"Total dos "###" Maiores Atrasos"
Endif
@Li , 35 PSAY aAcum[1]						  PICTURE PesqPict("SE1","E1_SALDO",13,mv_par03)
@Li , 54 PSAY aAcum[2]						  PICTURE PesqPict("SE1","E1_SALDO",13,mv_par03)
@Li , 68 PSAY aAcum[3]						  PICTURE "99999"
Li++
@Li ,  0 PSAY REPLICATE("-",132)
Li+=2
Return .T.