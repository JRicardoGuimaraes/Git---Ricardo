//#Include "FIVEWIN.Ch"
#Include "TopConn.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ GEFINR06 ³ Autor ³ Marcos Furtado        ³ Data ³ 15.09.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao balancete idade saldos   ³±±
               débitos em dias		                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ GEFINR06(void)											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GEFINR06()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis											 				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1 := "Este programa ira  emitir o balancete idade saldos."
LOCAL cDesc2 := ""
LOCAL cDesc3 :=""
LOCAL cString:="SE1"

Private Tamanho:="G"
Private limite := 220//225
PRIVATE titulo
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:= "GEF006"
PRIVATE aLinha	:= { },nLastKey := 0
PRIVATE cPerg	:= "GEF006"
PRIVATE nLastKey:=0
PRIVATE cCliente:={}
PRIVATE nCliente:=0
PRIVATE nDuvida:=0
Private nTipo := 18
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01

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
Pergunte("GEF006",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT	  		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel  := "GFIN006"            //Nome Default do relatorio em Disco
cDia	:= alltrim(str(day(dDataBase)))+"/"+alltrim(str(month(dDataBase)))+"/"+alltrim(str(year(dDataBase)))
titulo := OemToAnsi("Balancete Idade Saldos a "+cDia)
wnrel  := SetPrint(cString,wnrel   ,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,""  ,.T.,Tamanho,,.T.)

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
nTipo := If(aReturn[4]==1,15,18)

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
//LOCAL tamanho   := "M"
LOCAL lContinua := .T.
LOCAL aDados[1][17]
//LOCAL aDados[1][6]
LOCAL aAcum[11]
LOCAL nC:=1 , nT:= 1
LOCAL nFirst	:= 0
LOCAL aEstru	:={},aTam:={}
LOCAL cArq		:= SPACE(8)
Local lSoma
Local cValDev, cValAtr
Local nSaldo      := 0
Local nSaldoAnt   := 0
Local nSaldoaVencer := 0
Local nDiasAtraso := 0
Local aStru := SE1->(dbStruct()), ni
Local nDecs := MsDecimais(mv_par03)
Local dDataReaj
Local dDataRef := MV_PAR09
Local cFilBkp := cFilAnt                  
Local dVencRea  // Data de vencmento real que será considerada
Local cTit := Space(06)

PRIVATE _lExpr := ".T." 
PRIVATE cCliAnt	:= SPACE(6)

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
//If mv_par01 = 1
//	titulo := OemToAnsi('Relacao Do Maior Devedor') + " - " + UnidOp //'Relacao Do Maior Devedor'
//Else
//	titulo := OemToAnsi('Relacao dos ')+alltrim(str(mv_par01))+OemToAnsi(' Maiores Devedores') + " - " + UnidOp  //'Relacao dos '###' Maiores Devedores'
//Endif

cDia	:= alltrim(str(day(dDataBase)))+"/"+alltrim(str(month(dDataBase)))+"/"+alltrim(str(year(dDataBase)))
titulo := OemToAnsi("Balancete Idade Saldos a "+cDia + IIF(MV_PAR13 == 1, " - SINTETICO", " - ANALITICO"))

//cabec1 := OemToAnsi('Nome do Cliente                   Valor em Atraso Valor Total Devido N.Tit %Tot  Dias em Atraso')  //'Nome do Cliente                   Valor em Atraso Valor Total Devido N.Tit %Tot  Dias em Atraso'

//cabec1 := OemToAnsi('Nome do Cliente                   Valor em Atraso Valor Total Devido N.Tit %Tot  Dias em Atraso          Rede/Grupo')  
//cabec1 := OemToAnsi('Nome do Cliente                               Vol.Negocios ' + DTOC(dDataBase)  + "     Saldo Contab.   " + DTOC(MV_PAR09)  + "  Saldo Vencido   1 a 30           31 a 60           61 a 90          91 a 180         181 a 365             > 365")
cabec1 := OemToAnsi("Nome do Cliente                              Vol.Negocios           Saldo Contab.     Saldo Vencido        %Saldo Venc.      1 a 30           31 a 60           61 a 90          91 a 180         181 a 365             > 365")
cabec2 := ''

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa array que sera utilizado como acumulador 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDados[1][1]  := space(30)
aDados[1][2]  := 0
aDados[1][3]  := 0
aDados[1][4]  := 0
aDados[1][5]  := 0
aDados[1][6]  := 0
aDados[1][7]  := Space(1)
aDados[1][8]  := Space(1)
aDados[1][9]  := 0
aDados[1][10] := 0
aDados[1][11] := 0
aDados[1][12] := 0
aDados[1][13] := 0
aDados[1][14] := 0
aDados[1][15] := 0
aDados[1][16] := 0
aDados[1][17] := space(8)

aAcum[1]	 := 0
aAcum[2]	 := 0
aAcum[3]	 := 0
aAcum[4]	 := 0
aAcum[5]	 := 0
aAcum[6]	 := 0
aAcum[7]	 := 0
aAcum[8]	 := 0
aAcum[9]	 := 0
aAcum[10]	 := 0
aAcum[11]	 := 0
nRede  := 0
nRede1 := 0
nRede2 := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho com o conteudo do array			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam := TamSX3("E1_SALDO")

Aadd(aEstru, { "NOME"    , "C",      30,       0 } )
Aadd(aEstru, { "VALFAT"  , "N", aTam[1], aTam[2] } )
Aadd(aEstru, { "VALATR"  , "N", aTam[1], aTam[2] } )
Aadd(aEstru, { "VALDEV"  , "N", aTam[1], aTam[2] } )
Aadd(aEstru, { "VALCON"  , "N", aTam[1], aTam[2] } )
Aadd(aEstru, { "NUMTIT"  , "N",       5,       0 } )
Aadd(aEstru, { "DIAATR"  , "N",       5,       0 } )
Aadd(aEstru, { "UO"      , "C",       2,       0 } )
Aadd(aEstru, { "XGRPCLI" , "C",       8,       0 } )  //Criado por Marcelo Aguiar Pimentel
Aadd(aEstru, { "GRUPO"   , "C",       1,       0 } )  //Criado pelo Francisco
Aadd(aEstru, { "VALANT"  , "N", aTam[1], aTam[2] } )  //Criado por Marcos Furtado
Aadd(aEstru, { "VALAVC"  , "N", aTam[1], aTam[2] } )  //Criado por Marcos Furtado
Aadd(aEstru, { "VALA30"  , "N", aTam[1], aTam[2] } )  //01 a 30
Aadd(aEstru, { "VALA60"  , "N", aTam[1], aTam[2] } )  //31 A 60
Aadd(aEstru, { "VALA90"  , "N", aTam[1], aTam[2] } )  //61 A 90
Aadd(aEstru, { "VALA180" , "N", aTam[1], aTam[2] } )  //91 A 180
Aadd(aEstru, { "VALA365" , "N", aTam[1], aTam[2] } )  //181 A 365 
Aadd(aEstru, { "VALM365" , "N", aTam[1], aTam[2] } )  //maior que 365

cArq		:= criatrab(aEstru)
Use &cArq Alias cArq New
cValDev 	:= CriaTrab("",.F.)
cValAtr     := Subs(cValDev,1,7)+"A"

IndRegua("cArq",cValAtr,"Str(VALCON,17,2)",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
//IndRegua("cArq",cValDev,"Str(VALDEV,17,2)",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."

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
		
		// Todas filiais
		cQuery := "SELECT SE1.E1_FILIAL,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO    ,"
		cQuery += "       SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_MOEDA,SE1.E1_NATUREZ,SE1.E1_CCONT   ,"
		cQuery += "       SE1.E1_TXMOEDA,SE1.E1_EMISSAO,SE1.E1_XVENCRE,SE1.E1_VENCREA          ,"
		cQuery += "       SE1.E1_VALOR,SE1.E1_SALDO,SE1.E1_SDACRES,SE1.E1_ACRESC,SE1.E1_DECRESC ,"
		cQuery += "       SE1.E1_SDDECRE, A1_XGRPCLI                                             "
		cQuery += "  FROM "+ RetSqlName("SE1") + " SE1, " +	RetSqlName("SA1") +  " SA1           "
		cQuery += " WHERE SE1.D_E_L_E_T_ <> '*' AND                                              "
		cQuery += " SA1.D_E_L_E_T_ <> '*' AND "		
		Do Case
		   Case mv_par05 = 1  //RDVM
		        cQuery += " (SUBSTRING(E1_CCONT,2,2) = '01' OR SUBSTRING(E1_CCONT,2,2) = '02') AND " 		   
		   Case mv_par05 = 2 
    		    cQuery += " SUBSTRING(E1_CCONT,2,2) = '21'  AND " 		   
		   Case mv_par05 = 3            
		        cQuery += " SUBSTRING(E1_CCONT,2,2) = '11' AND " 		   
		   Case mv_par05 = 4  //RMA
		        cQuery += " ( SUBSTRING(E1_CCONT,2,2) = '22' OR SUBSTRING(E1_CCONT,2,2) = '23') AND " 		   
		EndCase				
        cQuery += " E1_CLIENTE = A1_COD AND "
        cQuery += " E1_LOJA    = A1_LOJA AND "        

		If !Empty(MV_PAR11)
			cQuery += " A1_GRUPO IN ( " + AllTrim(MV_PAR11) + ")  AND "				        
		EndIf
        cQuery += " E1_EMISSAO >= '" +DTOS(Mv_Par06)+"' AND "        
        cQuery += " E1_EMISSAO <= '" +DTOS(Mv_Par07)+"' AND "                              
        cQuery += " E1_SALDO <> 0.01 AND "                                      
/*        cQuery += " E1_VENCREA >= '" +DTOS(Mv_Par06)+"' AND "
        cQuery += " E1_VENCREA <= '" +DTOS(Mv_Par07)+"' AND "                              */
//        cQuery += " E1_CLIENTE = '001442' AND " 
        cQuery += " (E1_BAIXA > '"  + DTOS(dDataRef) + "' OR E1_BAIXA = ' ' OR E1_SALDO <> 0)  "         
        
		
//		cQuery += " ORDER BY E1_FILIAL,A1_XGRPCLI,E1_CLIENTE, E1_LOJA, E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO "
		cQuery += " ORDER BY A1_XGRPCLI,E1_CLIENTE, E1_LOJA, E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO "		
                             
//		cQuery := ChangeQuery(cQuery)

//		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)
		TcQuery cQuery Alias "SE1" NEW 

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
    nRede  := 0
	nRede1 := 0
	nRede2 := 0    
	nFirst  := 1
//	cCliAnt := SE1->E1_CLIENTE+E1_LOJA
    
	cCliAnt := SE1->A1_XGRPCLI	    
       
	// Trato o relatório por Analítico ou Sintético - Por: Ricardo - Em: 09/03/2010
	If MV_PAR13 = 1
		_lExpr := "SE1->A1_XGRPCLI == cCliAnt"
	Else
		_lExpr := ".T."
	EndIf
			
//	While SE1->A1_XGRPCLI == cCliAnt .And. !Eof()	
	
  	While &(_lExpr) .And. !Eof()		
	
		cFilAnt :=  SE1->E1_FILIAL	

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

		If nFirst = 1
			dbSelectArea("SA1")
//			dbSeek(cF
			If Empty(SE1->A1_XGRPCLI) .OR. MV_PAR13 <> 1
			
				dbSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)			
	            aDados[1][17]:= SE1->E1_CLIENTE+SE1->E1_LOJA
			Else
				dbSeek(cFilial+AllTrim(SE1->A1_XGRPCLI))			
	            aDados[1][17]:= SE1->A1_XGRPCLI
			EndIF
            aDados[1][1] := SubStr(A1_NOME,1,30)
            aDados[1][8] := IIF(Empty(A1_GRUPO),"*",Alltrim(A1_GRUPO))
			nFirst++
		Endif

		dbSelectarea("SE1")
		lSoma := .T.

        If SE1->E1_TIPO $ MVABATIM+"/"+MVRECANT+"/"+MV_CRNEG
			lSoma := .F.
		EndIf                         
  
        **********Tratamento dos títulos prorrogados  **************
        ***02/08/2006  -  Marcos Furtado                         ***
        //Neste momento verifico se Existe  registro de prorrogaçãodo titulo atual, caso haja comparo a data de prorrogação
        //com a data base ou de referencia para definir qual data de vecto que  sera utilizada no calculo retroativo.
        //A variavel dVencRea sempre sera inializada com E1_VENCREA, o seu conteudo so será mudado caso encontre 
        //uma prorrogação.

        dVencRea := SE1->E1_VENCREA
	 	                
		cTit        := SE1->E1_NUM

		dDataRef:=MV_PAR09
		If dVencRea < dDataBase		

//			nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par03,dDataBase-1,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0),mv_par10)			
			If dDataRef = dDataBase	
				nSaldo := xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,mv_par03,SE1->E1_EMISSAO,nDecs+1)		
			Else
				nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par03,dDataBase-1,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0),mv_par10)
			EndIf			
			// Subtrai decrescimo para recompor o saldo na data escolhida.
			If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
				nSAldo -= SE1->E1_DECRESC
			Endif
			// Soma Acrescimo para recompor o saldo na data escolhida.
			If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
				nSAldo += SE1->E1_ACRESC
			Endif           
		Else
			nSaldoaVencer := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par03,dDataBase-1,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0),mv_par10)		
		EndIf	

        //Data de Referencia                                           
		dDataRef :=  MV_PAR09
        _dDataBase := dDataBase
        dDataBase := dDataRef

        **********Tratamento dos títulos prorrogados  **************
        ***02/08/2006  -  Marcos Furtado                         ***
        //Neste momento verifico se Existe  registro de prorrogaçãodo titulo atual, caso haja comparo a data de prorrogação
        //com a data base ou de referencia para definir qual data de vecto que  sera utilizada no calculo retroativo.
        //A variavel dVencRea sempre sera inializada com E1_VENCREA, o seu conteudo so será mudado caso encontre 
        //uma prorrogação.
  
        dVencRea := SE1->E1_VENCREA          
        
		dDataReaj := IIF(SE1->E1_VENCREA < dDataRef,IIF(mv_par08=1,dDataRef,E1_VENCREA),dDataRef)

		//Calculo na Data de Ref
		If dDataRef = dDataBase	
			nSaldoAnt := xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,mv_par03,SE1->E1_EMISSAO,nDecs+1)
		Else
			nSaldoAnt := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par03,dDataReaj,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0),mv_par10)
		EndIf
		// Subtrai decrescimo para recompor o saldo na data escolhida.
		If Str(SE1->E1_VALOR,17,2) == Str(nSaldoAnt,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
			nSAldoAnt -= SE1->E1_DECRESC
		Endif
		// Soma Acrescimo para recompor o saldo na data escolhida.
		If Str(SE1->E1_VALOR,17,2) == Str(nSaldoAnt,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
			nSAldoAnt += SE1->E1_ACRESC
		Endif
	
        dDataBase := _dDataBase
		If (nSaldo != 0 .Or. nSaldoAnt != 0 .Or. nSaldoaVencer != 0)		
			
			If lSoma
				aDados[1][2] += nSaldo  // Valor Em Atraso
			Else
				aDados[1][2] -= nSaldo  // Valor Em Atraso
            Endif
            
			//Saldo Retroativo
			If lSoma
				aDados[1][9] += nSaldoAnt  // Valor Em Atraso Retroativo
			Else
				aDados[1][9] -= nSaldoAnt  // Valor Em Atraso Retroativo
            Endif

			//Saldo Retroativo
			If lSoma
				aDados[1][10] += nSaldoaVencer  // Valor Em Atraso Retroativo
			Else
				aDados[1][10] -= nSaldoaVencer  // Valor Em Atraso Retroativo
            Endif


			aDados[1][5] ++    // No. de titulos
			aDados[1][7] := Substr(SE1->E1_CCONT,2,2)  // U.O.
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula a Quantidade de Dias em Atraso.                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//			nDiasAtraso := dDataBase - SE1->E1_VENCREA
			nDiasAtraso := dDataBase - dVencRea
  

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Armazena a Quantidade de Dias em Atraso de acordo com a esco-³
			//³ lha do Usuario : mv_par02 == 1 (Media) / 2 (Maior Atraso)    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par02 == 1
				aDados[1][6] := aDados[1][6] + nDiasAtraso
			Else
				aDados[1][6] := Iif(aDados[1][6] < nDiasAtraso, nDiasAtraso, aDados[1][6])
			EndIf
			
			if nDiasAtraso <= 30
				_nCol := 11
			ElseIf nDiasAtraso >= 31 .And. nDiasAtraso <= 60
				_nCol := 12
			ElseIf nDiasAtraso >= 61 .And. nDiasAtraso <= 90
				_nCol := 13
			ElseIf nDiasAtraso >= 91 .And. nDiasAtraso <= 180
				_nCol := 14
			ElseIf nDiasAtraso >= 181 .And. nDiasAtraso <= 365
				_nCol := 15
			ElseIf nDiasAtraso > 365
				_nCol := 16			
			EndIF
		  			
			If lSoma
				aDados[1][3] += nSaldo  // Valor Devido
				aDados[1][4] += nSaldo  // Valor Total Dos Saldos dos titulos
				aDados[1][_nCol] += nSaldo  // Valor Total Dos Saldos dos titulos				
			Else
				aDados[1][3] -= nSaldo  // Valor Devido
				aDados[1][4] -= nSaldo  // Valor Total Dos Saldos dos titulos                   
				aDados[1][_nCol] -= nSaldo  // Valor Total Dos Saldos dos titulos								
			End
				
			
		Endif
    
		If MV_PAR13 <> 1 // [1] - Sintético ; [2] - Analítico
			_lExpr := ".F."
		EndIf
    
		SE1->(dbSkip())           
		nSaldo        := 0
		nSaldoAnt     := 0       
		nSaldoaVencer := 0
		
	Enddo
//	If aDados[1][2] > 0 .Or. aDados[1][9] > 0 .Or. aDados[1][10] > 0
	If aDados[1][2] <> 0 .Or. aDados[1][9] <> 0 .Or. aDados[1][10] <> 0	
		RecLock( "cArq" , .T. )
	
	    Replace NOME    With aDados[1][1]
		Replace VALATR	With aDados[1][2]
		Replace VALDEV	With aDados[1][3]
		Replace NUMTIT	With aDados[1][5]
		Replace DIAATR  With Iif(mv_par02 == 1, aDados[1][6] / aDados[1][5], aDados[1][6])
		Replace UO  	With iif(mv_par05 == 5,"TD",aDados[1][7])
		Replace GRUPO	With aDados[1][8]
		Replace VALANT	With aDados[1][9]	//Alterado - Marcos Furtado 30/06/2006
		Replace VALAVC	With aDados[1][10]	//Alterado - Marcos Furtado 18/07/2006		
		Replace VALCON  With VALDEV+VALAVC
		Replace VALA30  With aDados[1][11]	
		Replace VALA60  With aDados[1][12]	
		Replace VALA90  With aDados[1][13]	
		Replace VALA180 With aDados[1][14]	
		Replace VALA365 With aDados[1][15]	
		Replace VALM365 With aDados[1][16]	
		Replace XGRPCLI	With aDados[1][17]
		
		MsUnlock()
	EndIf		
	aDados[1][9]  := 0	
	aDados[1][10] := 0	
	aDados[1][11] := 0	
	aDados[1][12] := 0	
	aDados[1][13] := 0	
	aDados[1][14] := 0	
	aDados[1][15] := 0	
	aDados[1][16] := 0	

	dbSelectarea("SE1")
Enddo                               

cFilAnt := cFilBkp

dbSelectarea("cArq")
dbSetOrder(1)
dbGotop()
dbGoBottom()
cCliente:=""
nCliente:=0
While !Bof()
//While !Bof() .and. nCliente <=mv_par01
	If Mv_par12 = 1
		If nCliente >=mv_par01
			exit
		EndIf
	EndIf
	cQuery:="SELECT SUM(CASE E1_TIPO WHEN 'NCC' THEN E1_VALOR * (-1) ELSE E1_VALOR END) AS E1_VALOR"
	cQuery+="  FROM SE1010 SE1, SA1010 SA1"
	cQuery+=" WHERE SE1.D_E_L_E_T_ <> '*'"
	cQuery+="   AND SA1.D_E_L_E_T_ <> '*'"
	cQuery += " AND E1_EMISSAO >= '" +DTOS(ctod("01/"+str(month(dDataBase))+"/"+str(year(dDataBase))))+"'"        
	cQuery += " AND E1_EMISSAO <= '" +DTOS(dDataBase)+"'"
	cQuery+="   AND E1_MOEDA = 1"
	cQuery+="   AND E1_CLIENTE = A1_COD"
	cQuery+="   AND E1_TIPO <> 'FAT'"
	cQuery+="   AND E1_LOJA = A1_LOJA AND "  
	Do Case
	   Case mv_par05 = 1  //RDVM
	        cQuery += " (SUBSTRING(E1_CCONT,2,2) = '01' OR SUBSTRING(E1_CCONT,2,2) = '02') AND " 		   
	   Case mv_par05 = 2 
    		    cQuery += " SUBSTRING(E1_CCONT,2,2) = '21'  AND " 		   
	   Case mv_par05 = 3            
	        cQuery += " SUBSTRING(E1_CCONT,2,2) = '11' AND " 		   
	   Case mv_par05 = 4  //RMA
	        cQuery += " ( SUBSTRING(E1_CCONT,2,2) = '22' OR SUBSTRING(E1_CCONT,2,2) = '23') AND " 		   
	EndCase				
	cQuery+="   A1_XGRPCLI = '"+cArq->XGRPCLI+"'"
	TcQuery cQuery Alias "TSE1" NEW
	nValor:=TSE1->E1_VALOR
	dbCloseArea("TSE1")

	cQuery:="SELECT E1_NUM,E1_TIPO,E1_PREFIXO,E1_VALOR,E1_MOEDA,E1_CLIENTE,E1_LOJA,E1_DTVARIA,E1_TXMOEDA"
	cQuery+="  FROM SE1010 SE1, SA1010 SA1 "
	cQuery+=" WHERE SE1.D_E_L_E_T_ <> '*'"
	cQuery+="   AND SA1.D_E_L_E_T_ <> '*'"
	cQuery += " AND E1_EMISSAO >= '" +DTOS(ctod("01/"+str(month(dDataBase))+"/"+str(year(dDataBase))))+"'"        
	cQuery += " AND E1_EMISSAO <= '" +DTOS(dDataBase)+"'"
	cQuery+="   AND E1_MOEDA <> 1"
	cQuery+="   AND E1_CLIENTE = A1_COD"
	cQuery+="   AND E1_TIPO <> 'FAT'"
	cQuery+="   AND E1_LOJA = A1_LOJA AND "
	Do Case
	   Case mv_par05 = 1  //RDVM
	        cQuery += " (SUBSTRING(E1_CCONT,2,2) = '01' OR SUBSTRING(E1_CCONT,2,2) = '02') AND " 		   
	   Case mv_par05 = 2 
    		    cQuery += " SUBSTRING(E1_CCONT,2,2) = '21'  AND " 		   
	   Case mv_par05 = 3            
	        cQuery += " SUBSTRING(E1_CCONT,2,2) = '11' AND " 		   
	   Case mv_par05 = 4  //RMA
	        cQuery += " ( SUBSTRING(E1_CCONT,2,2) = '22' OR SUBSTRING(E1_CCONT,2,2) = '23') AND " 		   
	EndCase				
	cQuery+="   A1_XGRPCLI = '"+cArq->XGRPCLI+"'"
	TcQuery cQuery Alias "TSE1" NEW

	nVlrMd2:=0
	nVlrTmp:=0
	While !Eof()
		If MV_PAR04 == 1
			If Empty(TSE1->E1_DTVARIA)
	   	   		nVlrTmp :=  (TSE1->E1_VALOR * TSE1->E1_TXMOEDA)
	   	   	ELSE 
	   	   		DbSelectArea("SM2")	
	   	   	   	DbSetOrder(1)
	   	   	   	If DbSeek(sToD(TSE1->E1_DTVARIA))
	   	   	   		If TSE1->E1_MOEDA = 2	
		   	   	   		nVlrTmp := (TSE1->E1_VALOR * SM2->M2_MOEDA2)   	   
		   	   	   	ElseIf TSE1->E1_MOEDA = 4	
		   	   	   	   	nVlrTmp := (TSE1->E1_VALOR * SM2->M2_MOEDA4)   	   			   	   	   
		   	   	   	EndIF
	   	   	   	EndIf
	   	   	EndIf
	            Else
	            	nVlrTmp:=TSE1->E1_VALOR
	            EndIf
		If TSE1->E1_TIPO == "NCC"
			nVlrMd2-=nVlrTmp
		Else
			nVlrMd2+=nVlrTmp
		EndIf
		dbSkip()
	EndDo
	dbCloseArea("TSE1")
	nValor+=nVlrMd2
	RecLock("cArq",.f.)
		cArq->VALFAT:=nValor
	MsUnLock()
	dbSelectArea("cArq")
	dbSkip(-1)
	nCliente++
EndDo

//Retorna a Filial
cFilAnt := cFilBkp

dbSelectarea("cArq")
SetRegua(RecCount())

dbSetOrder(1)
dbGotop()
dbGoBottom()

Do Case
   Case cArq->UO == "01" .OR. cArq->UO == "02"
        cUO := 1
   Case cArq->UO == "21" 
        cUO := 2         
   Case cArq->UO == "11" 
        cUO := 3   
   Case cArq->UO == "22" .OR. cArq->UO == "23" 
        cUO := 4            
   Case cArq->UO == "TD"
   		cUO := 5
EndCase

nC := 0
AntGRUPO := GRUPO

While !Bof() .And. MV_PAR05 == cUO
	
	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")  //"CANCELADO PELO OPERADOR"
		Exit
	End
	
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
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
       Case UO == "5"
            cDescUO := "TODOS"       
    EndCase

    Do Case
       Case GRUPO == "1"
            cDescGR := "REDE PEUGEOT"
       Case GRUPO == "2"
            cDescGR := "REDE SHC"
       Case GRUPO == "3"
            cDescGR := "REDE CITROEN INDEPENDENTE"
       Case GRUPO == "4"
            cDescGR := "HORS GROUPE"
       Case GRUPO == "9"
            cDescGR := "EMRPESAS DO GRUPO "            
    EndCase
    
    // If nC >= 20 .And. MV_PAR12 = 1
    // Por: Ricardo - Em: 09/03/2010
    If nC >= MV_PAR01 .And. MV_PAR12 = 1    
	   dbSkip(-1)
	   Loop
    Endif

   
	@ li, 00 PSAY NOME
//	@ li, 35 PSAY VALATR                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
//	@ li, 54 PSAY VALDEV                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 44 PSAY VALFAT                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
//	@ li, 68 PSAY NUMTIT                     Picture "99999"
//	@ li, 74 PSAY (VALDEV/aDados[1][4])*100  Picture "999.9"
//	@ li, 90 PSAY DIAATR                     Picture "99999"

	//If MV_PAR05 == 1
   // @ li, 97 PSAY cDescUO
   	   
//	   @ li, 105 PSAY cDescGR                                                               
//	@ li, 082 PSAY VALANT                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
//	@ li, 100 PSAY VALAVC                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
//	@ li, 068 PSAY VALDEV+VALAVC  			    Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 068 PSAY VALCON         			    Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 086 PSAY VALDEV                       Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	nPerc:=(VALDEV+VALAVC)
	nPerc:=(VALDEV*100)/nPerc
	@ li, 110 PSAY  nPerc Picture "999.99%"//+PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 120 PSAY VALA30                      Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 138 PSAY VALA60                      Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 156 PSAY VALA90                      Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 174 PSAY VALA180                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 192 PSAY VALA365                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 205 PSAY VALM365                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)		
    //Endif

    nRede  := nRede  + VALDEV            
    nRede1 := nRede1 + VALANT                    
    nRede2 := nRede2 + VALAVC                    

	aAcum[1] += VALATR
	aAcum[2] += VALFAT//VALDEV
	aAcum[3] += NUMTIT
	aAcum[4] += VALDEV+VALAVC//VALANT
	aAcum[5] += VALDEV//VALAVC		
	aAcum[6] += VALA30
	aAcum[7] += VALA60
	aAcum[8] += VALA90
	aAcum[9] += VALA180
	aAcum[10] += VALA365
	aAcum[11] += VALM365

    AntGRUPO := GRUPO
    AntDescr := cDescGR
    dbSkip(-1)
	Li++
	nC++
    
End

ImptotG(aAcum,nT)

IF li != 80
	roda(cbcont,cbtxt,"G")
End

If FILE(cArq+".DBF")     //Elimina o arquivo de trabalho
    dbCloseArea()
    Ferase(cArq+".DBF")
//    Ferase("CVALDEV"+OrdBagExt())
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
@Li ,  0 PSAY REPLICATE("-",limite)
Li++
If nT = 1
	If Mv_par12 =1
		@Li ,  0 PSAY OemToAnsi("Total dos ")+alltrim(str(mv_par01))+OemToAnsi(" maiores")  //"Total dos "###" maiores devedores"
	Else
		@Li ,  0 PSAY OemToAnsi("Total ")  //"Total dos "###" maiores devedores"
	EndIf
Else
	If Mv_par12 =1
		@Li ,  0 PSAY OemToAnsi("Total ")//"Total dos "###" Maiores Atrasos"
	Else
		@Li ,  0 PSAY OemToAnsi("Total ")//"Total dos "###" Maiores Atrasos"
	EndIf
Endif
//@Li , 35 PSAY aAcum[1]						  PICTURE PesqPict("SE1","E1_SALDO",13,mv_par03)
@Li , 44 PSAY aAcum[2]						  PICTURE PesqPict("SE1","E1_SALDO",13,mv_par03)
//@Li , 68 PSAY aAcum[3]						  PICTURE "99999"                               
@Li , 68 PSAY aAcum[4]						  PICTURE PesqPict("SE1","E1_SALDO",13,mv_par03)
@Li , 86 PSAY aAcum[5]						  PICTURE PesqPict("SE1","E1_SALDO",13,mv_par03)
@Li ,120 PSAY aAcum[6]						  PICTURE PesqPict("SE1","E1_SALDO",13,mv_par03)
@Li ,138 PSAY aAcum[7]						  PICTURE PesqPict("SE1","E1_SALDO",13,mv_par03)
@Li ,156 PSAY aAcum[8]						  PICTURE PesqPict("SE1","E1_SALDO",13,mv_par03)
@Li ,174 PSAY aAcum[9]						  PICTURE PesqPict("SE1","E1_SALDO",13,mv_par03)
@Li ,192 PSAY aAcum[10]						  PICTURE PesqPict("SE1","E1_SALDO",13,mv_par03)
@Li ,205 PSAY aAcum[11]						  PICTURE PesqPict("SE1","E1_SALDO",13,mv_par03)

Li++
@Li ,  0 PSAY REPLICATE("-",limite)
Li+=2
Return .T.
