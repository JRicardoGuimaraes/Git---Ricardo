//#Include "FIVEWIN.Ch"
#Include "TopConn.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ GEFR106CC ³ Autor ³ Marcos Furtado       ³ Data ³ 15.09.06 ³±±
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
// 
// Alteracao: Vitor Sbano ( 26/05/10) - Disponibilizacao de Novo relatorio para atendimento solicitacao usuario
//                                      Flavio Lima (FIN;CTB)  - arquivo Original GEFINR06
//                                      Destina-se a gerar o Balancete Idade Saldos (GEF006) contemplando:
//                                      - Emissão de Titulos para Todas as Moedas (convertidas em Real - Moeda 1)
//                                      - Agrupar por Unidade Operacional ( quebrar por Unidade - Sim/Nao)
//
//                                      - Agrupar Clientes (A1_GRUPO) em "Grandes Grupos" : Grupo 1,2,3,4 e 9 .. Non Group
//                                                                                          Grupo 6 ............ GEFCO
//                                                                                          Grupo 5 ............ PSA 
//                                      -  
//
//
//
/*/

User Function GEFR106CC()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis											 				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1 := "Este programa ira  emitir o balancete idade saldos."
LOCAL cDesc2 := "Versao em Validacao - 07/06/2010"
LOCAL cDesc3 := "GEFCO - Considera sempre TODAS as Moedas"
LOCAL cString:= "SE1"

Private Tamanho:="G"
Private limite := 220//225
PRIVATE titulo
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:= "GEFR106"
PRIVATE aLinha	:= { },nLastKey := 0
//PRIVATE cPerg	:= "GEFR106"
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
//³ mv_par03  // Qual moeda                            ³ .....  Gerar SEMPRE em Reais (Moeda 1 )
//³ mv_par04  // Outras moedas (1 Converter/ 2 Nao Imp)³ .....  Gerar SEMPRE como CONVERTER
//³ mv_par05  // Unid.Operacioal                       ³
//³ mv_par06  // Da Emissao                            ³
//³ mv_par07  // Ate a Emissao                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas					  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT	  		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel  := "GEFR106"            //Nome Default do relatorio em Disco
cDia	:= alltrim(str(day(dDataBase)))+"/"+alltrim(str(month(dDataBase)))+"/"+alltrim(str(year(dDataBase)))
titulo := OemToAnsi("Balancete Idade Saldos  II ")
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
±±³Fun‡…o	 ³ FA300Imp ³ Autor ³ Paulo Boschetti	    ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao dos maiores atrasos/devedores		 		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA300Imp(lEnd,wnRelm,Cstring)						      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Parametro 1 - lEnd	 - A‡Æo do CodeBlock		          ³±±
±±³ 		    ³ Parametro 2 - wnRel	 - T¡tulo do relat¢rio	   	      ³±±
±±³ 		    ³ Parametro 3 - cString - Mensagem 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso 	    ³ Generico 											      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA300Imp(lEnd,wnRel,cString)
LOCAL CbCont,CbTxt
LOCAL nOrdem
//LOCAL tamanho   := "M"
LOCAL lContinua := .T.
LOCAL aDados[1][18]
//LOCAL aDadTit[1][6]
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
//
//
//If MV_PAR03 <> 1
//	Alert("Parametro 03 - Moeda - ajustado para 1 - Em Reais")
//	MV_PAR03 := 1
//Endif
//If MV_PAR04 <> 1
//	Alert("Parametro 04 - Outras Moedas- ajustado para 1 - Converter")
//	MV_PAR04 := 1
//Endif
If MV_PAR05 <> 5
	Alert("Parametro 05 - Unidade Operacional - ajustado para 5 - Todas")
	MV_PAR05 := 1
Endif
//	
//
Do Case							&& 
   Case MV_PAR05 == 1			&& Unidade Operacional
        UnidOp := "RDVM"        &&
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
              
cDia	:= alltrim(str(day(dDataRef)))+"/"+alltrim(str(month(dDataRef)))+"/"+alltrim(str(year(dDataRef)))

titulo := OemToAnsi("Balancete Idade Saldos II - ref: "+cDia + IIF(MV_PAR13 == 1, " - SINTETICO", " - ANALITICO"))

//cabec1 := OemToAnsi('Nome do Cliente                   Valor em Atraso Valor Total Devido N.Tit %Tot  Dias em Atraso')  //'Nome do Cliente                   Valor em Atraso Valor Total Devido N.Tit %Tot  Dias em Atraso'

//cabec1 := OemToAnsi('Nome do Cliente                   Valor em Atraso Valor Total Devido N.Tit %Tot  Dias em Atraso          Rede/Grupo')  
//cabec1 := OemToAnsi('Nome do Cliente                               Vol.Negocios ' + DTOC(dDataBase)  + "     Saldo Contab.   " + DTOC(MV_PAR09)  + "  Saldo Vencido   1 a 30           31 a 60           61 a 90          91 a 180         181 a 365             > 365")
cabec1 := OemToAnsi("Nome do Cliente                              Vol.Negocios           Saldo Contab.     Saldo Vencido        %Saldo Venc.      1 a 30           31 a 60           61 a 90          91 a 180         181 a 365             > 365")
cabec2 := "Periodo: "+dtoc(MV_PAR06)+" a "+dtoc(MV_PAR07)+"  - Moeda: "+transform(MV_PAR03,"@e 99")

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
aDados[1][8]  := Space(6)
aDados[1][9]  := 0
aDados[1][10] := 0
aDados[1][11] := 0
aDados[1][12] := 0
aDados[1][13] := 0
aDados[1][14] := 0
aDados[1][15] := 0
aDados[1][16] := 0
aDados[1][17] := space(8)
aDados[1][18] := space(2)		&& Filial

//
//
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
Aadd(aEstru, { "NUMTIT"  , "N",       9,       0 } )
Aadd(aEstru, { "DIAATR"  , "N",       5,       0 } )
Aadd(aEstru, { "UO"      , "C",       4,       0 } )
Aadd(aEstru, { "XGRPCLI" , "C",       8,       0 } )  //Criado por Marcelo Aguiar Pimentel
Aadd(aEstru, { "GRUPO"   , "C",      10,       0 } )  //Criado pelo Francisco
Aadd(aEstru, { "VALANT"  , "N", aTam[1], aTam[2] } )  //Criado por Marcos Furtado
Aadd(aEstru, { "VALAVC"  , "N", aTam[1], aTam[2] } )  //Criado por Marcos Furtado
Aadd(aEstru, { "VALA30"  , "N", aTam[1], aTam[2] } )  //01 a 30
Aadd(aEstru, { "VALA60"  , "N", aTam[1], aTam[2] } )  //31 A 60
Aadd(aEstru, { "VALA90"  , "N", aTam[1], aTam[2] } )  //61 A 90
Aadd(aEstru, { "VALA180" , "N", aTam[1], aTam[2] } )  //91 A 180
Aadd(aEstru, { "VALA365" , "N", aTam[1], aTam[2] } )  //181 A 365 
Aadd(aEstru, { "VALM365" , "N", aTam[1], aTam[2] } )  //maior que 365
Aadd(aEstru, { "FILIAL"  , "C",       2,       0 } )  //Filial
Aadd(aEstru, { "DESCUO"  , "C",      10,       0 } )  //Filial
Aadd(aEstru, { "DESCFIL" , "C",      15,       0 } )  //Filial
Aadd(aEstru, { "CCONT"   , "C",       7,       0 } )  //Filial


cArq		:= criatrab(aEstru)
Use &cArq Alias cArq New
cValDev 	:= CriaTrab("",.F.)
cValAtr     := Subs(cValDev,1,7)+"A"

cArqXls		:= criatrab(aEstru)
Use &cArqXls Alias cXls New

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
//
//		Do Case
//		   Case mv_par05 = 1  //RDVM
//		        cQuery += " (SUBSTRING(E1_CCONT,2,2) = '01' OR SUBSTRING(E1_CCONT,2,2) = '02') AND " 		   
//		   Case mv_par05 = 2 
//    		    cQuery += " SUBSTRING(E1_CCONT,2,2) = '21'  AND " 		   
//		   Case mv_par05 = 3            
//		        cQuery += " SUBSTRING(E1_CCONT,2,2) = '11' AND " 		   
//		   Case mv_par05 = 4  //RMA
//		        cQuery += " ( SUBSTRING(E1_CCONT,2,2) = '22' OR SUBSTRING(E1_CCONT,2,2) = '23') AND " 		   
//		EndCase				
//
        cQuery += " E1_CLIENTE = A1_COD AND "
        cQuery += " E1_LOJA    = A1_LOJA AND "        

		If !Empty(MV_PAR11)
			cQuery += " A1_GRUPO IN ( " + AllTrim(MV_PAR11) + ")  AND "				        
		EndIf
        cQuery += " E1_EMISSAO >= '" +DTOS(Mv_Par06)+"' AND "        					&& Parametro 6 - Data de
        cQuery += " E1_EMISSAO <= '" +DTOS(Mv_Par07)+"' AND  " 			            	&& Parametro 6 - Data Ate               
//        cQuery += " E1_SALDO <> 0.01 AND "											&& 07/06/10 - Rever Vitor Sbano

        cQuery += " (E1_BAIXA > '"  + DTOS(dDataRef) + "' OR E1_BAIXA = ' ') "        && 26/05/2010 Vitor

//
//        cQuery += " E1_VENCREA >= '" +DTOS(Mv_Par06)+"' AND "
//        cQuery += " E1_VENCREA <= '" +DTOS(Mv_Par07)+"' AND "                              */
//        cQuery += " E1_CLIENTE = '001442' AND " 
//

//        cQuery += " (E1_BAIXA > '"  + DTOS(dDataRef) + "' OR E1_BAIXA = ' ' OR E1_SALDO <> 0)  "         && 26/05/2010 Vitor
        		
		cQuery += " ORDER BY A1_XGRPCLI,E1_CLIENTE, E1_LOJA, E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO "		
                             
//		cQuery := ChangeQuery(cQuery)
        memowrite("D:\TMP\GEFR106.SQL",cQuery)
        
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
    aDados[1][8] := Space(6)
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
		
		// Desconsidera registros que nao sao da moeda informada se escolhido nao imprimir
		If  mv_par04 == 2 .AND. SE1->E1_MOEDA != mv_par03 
		   SE1->(dbSkip())                
		   Loop
		EndIf

		If nFirst = 1
			dbSelectArea("SA1")
			If Empty(SE1->A1_XGRPCLI) .OR. MV_PAR13 <> 1
			
				dbSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)			
	            aDados[1][17]:= SE1->E1_CLIENTE+SE1->E1_LOJA
			Else
				dbSeek(cFilial+AllTrim(SE1->A1_XGRPCLI))			
	            aDados[1][17]:= SE1->A1_XGRPCLI
			EndIF
            aDados[1][1] := SubStr(A1_NOME,1,30)
//          aDados[1][8] := IIF(Empty(A1_GRUPO),"*",Alltrim(A1_GRUPO))
            aDados[1][8] := IIF(Empty(A1_GRUPO),"9_OUTROS",IIF(Alltrim(A1_GRUPO) $ "1|2|3|4|9","1_NON_GRP",IIF(alltrim(A1_GRUPO)="6","2_GEFCO","3_PSA")))
            
			nFirst++
		Endif

		dbSelectarea("SE1")
		lSoma := .T.

        If SE1->E1_TIPO $ MVABATIM+"/"+MVRECANT+"/"+MV_CRNEG
			lSoma := .F.
		EndIf                         
        //
        // **********Tratamento dos títulos prorrogados  **************
        // ***02/08/2006  -  Marcos Furtado                         ***
        // Neste momento verifico se Existe  registro de prorrogaçãodo titulo atual, caso haja comparo a data de prorrogação
        // com a data base ou de referencia para definir qual data de vecto que  sera utilizada no calculo retroativo.
        // A variavel dVencRea sempre sera inializada com E1_VENCREA, o seu conteudo so será mudado caso encontre 
        // uma prorrogação.

        dVencRea := SE1->E1_VENCREA
	 	                
		cTit        := SE1->E1_NUM

		dDataRef:=MV_PAR09

//		If dVencRea < dDataBase		
		If dVencRea < dDataRef		

//			nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par03,dDataBase-1,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0),mv_par10)			
//			If dDataRef = dDataBase	
//				nSaldo := xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,mv_par03,SE1->E1_EMISSAO,nDecs+1)		
//			Else
//				nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par03,dDataBase-1,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0),mv_par10)
				nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par03,dDataRef-1,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0),mv_par10)

//			EndIf			
//			// Subtrai decrescimo para recompor o saldo na data escolhida.
			If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
				nSAldo -= SE1->E1_DECRESC
			Endif
			// Soma Acrescimo para recompor o saldo na data escolhida.
			If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
				nSAldo += SE1->E1_ACRESC
			Endif           
		Else
//			nSaldoaVencer := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par03,dDataBase-1,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0),mv_par10)		
			nSaldoaVencer := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par03,dDataRef-1,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0),mv_par10)		

		EndIf	

        //Data de Referencia                                           
		dDataRef :=  MV_PAR09
        _dDataBase := dDataBase
        dDataBase := dDataRef
        //
        // **********Tratamento dos títulos prorrogados  **************
        // ***02/08/2006  -  Marcos Furtado                         ***
        // Neste momento verifico se Existe  registro de prorrogaçãodo titulo atual, caso haja comparo a data de prorrogação
        // com a data base ou de referencia para definir qual data de vecto que  sera utilizada no calculo retroativo.
        // A variavel dVencRea sempre sera inializada com E1_VENCREA, o seu conteudo so será mudado caso encontre 
        // uma prorrogação.
  
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
//			aDados[1][7] := Substr(SE1->E1_CCONT,2,2)  // U.O.
			aDados[1][7] := Substr(SE1->E1_CCONT,1,4)  // U.O.
			aDados[1][18] := SE1->E1_FILIAL  // Filial
			
			
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
		//
		// Ajuste de Identificacao de UO
		//  aDados[1][7]  -> Identifica a UO conforme CCusto
		_cxUO	:=	""

//		Do Case                                             
//			Case aDados[1][7] == "01" .or. aDados[1][7] == "02"
//				_cxUO	:= "01"
//			Case aDados[1][7] == "22" .or. aDados[1][7] == "23"
//				_cxUO	:= "22" 
//			Case empty(aDados[1][7])
//				_cxUO	:= "99"
//			Otherwise
//				_cxUO	:= aDados[1][7]
//		EndCase
                   
		//  Definicao de Unidade Operacional 07/06/10 - Flavio Lima (CTB/GEFCO)
		//	1  - TLA
		//	2  - OVL
		//	321 - LOG
		//	322 - OVS
		//	3231 - TLA
		//	3232 - OVL
		//	3233 - OVS

		Do Case                                             
			Case substr(aDados[1][7],1,1) == "1" 
				_cxUO	:= "TLA"
			Case substr(aDados[1][7],1,1) == "2" 
				_cxUO	:= "OVL"       
			Case substr(aDados[1][7],1,3) == "321" 
				_cxUO	:= "LOG"       
			Case substr(aDados[1][7],1,3) == "322" 
				_cxUO	:= "OVS"       
			Case substr(aDados[1][7],1,4) == "3231" 
				_cxUO	:= "TLA"       
			Case substr(aDados[1][7],1,4) == "3232" 
				_cxUO	:= "OVL"       
			Case substr(aDados[1][7],1,4) == "3233" 
				_cxUO	:= "OVS"       
			Otherwise
				_cxUO	:= "Outros"+substr(aDados[1][7],1,4)
		EndCase


		//
	
	    Replace NOME    With aDados[1][1]
		Replace VALATR	With aDados[1][2]
		Replace VALDEV	With aDados[1][3]
		Replace NUMTIT	With aDados[1][5]
		Replace DIAATR  With Iif(mv_par02 == 1, aDados[1][6] / aDados[1][5], aDados[1][6])
//		Replace UO  	With iif(mv_par05 == 5,"TD",aDados[1][7])
//		Replace UO  	With aDados[1][7]
		Replace UO  	With _cxUO

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
		Replace FILIAL	With aDados[1][18]
		Replace CCONT	With aDados[1][18]+"_"+aDados[1][7]
		
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

///////////////////////////////////////////////////////////////////////////
//
//  Apresentacao de Dados Sumarizados Por UO / Grupo  
//
///////////////////////////////////////////////////////////////////////////

dbSelectarea("cArq")
cIndUoGr 	:= CriaTrab("",.F.)
IndRegua("cArq",cIndUOGr ,"UO+GRUPO",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
SetRegua(RecCount())
dbSetOrder(1)
dbGotop()
//
//                                10        20        30
//                       1234567890123456789012345678901234567890
cabec1 := OemToAnsi("Unid Operac        Grupo                     Vol.Negocios           Saldo Contab.     Saldo Vencido        %Saldo Venc.      1 a 30           31 a 60           61 a 90          91 a 180         181 a 365             > 365")
cabec2 := "Periodo: "+dtoc(MV_PAR06)+" a "+dtoc(MV_PAR07)
//
nC := 0
AntGRUPO := GRUPO

While !EOF()
	
	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")  //"CANCELADO PELO OPERADOR"
		Exit
	End
	
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	End

	IncRegua()
        
	_cUO	:= UO
//
//	Do Case
//	   	Case _cUO == "01" .OR. _cUO == "02"
//   	    	_cDescUO := "TLA"  	&& "RDVM"
//   		Case _cUO == "21" 
//   	    	_cDescUO := "LOG"	&& "ILI"         
//   		Case _cUO == "11" 
//        	_cDescUO := "OVL"	&& "RMLAP"   
//   		Case _cUO == "22" .OR. _cUO == "23" 
//        	_cDescUO := "OVS"	&& "RMA"            
//   		Otherwise
//   			_cDescUO := "Outros"
//	  EndCase
//
	_nAcum01 := 0
	_nAcum02 := 0
	_nAcum03 := 0
	_nAcum04 := 0
	_nAcum05 := 0		
	_nAcum06 := 0
	_nAcum07 := 0
	_nAcum08 := 0
	_nAcum09 := 0
	_nAcum10 := 0
	_nAcum11 := 0
	_nAcum12 := 0
	_nAcum13 := 0
	
	_nAcum101 := 0	&& Totalizacao por UO
	_nAcum102 := 0
	_nAcum103 := 0
	_nAcum104 := 0
	_nAcum105 := 0		
	_nAcum106 := 0
	_nAcum107 := 0
	_nAcum108 := 0
	_nAcum109 := 0
	_nAcum110 := 0
	_nAcum111 := 0
	_nAcum112 := 0
	_nAcum113 := 0
	//
	Do While !eof() .and. UO ==	_cUO
		//
		_cGRUPO	:=	GRUPO
		_nAcum01 := 0
		_nAcum02 := 0
		_nAcum03 := 0
		_nAcum04 := 0
		_nAcum05 := 0		
		_nAcum06 := 0
		_nAcum07 := 0
		_nAcum08 := 0
		_nAcum09 := 0
		_nAcum10 := 0
		_nAcum11 := 0
		_nAcum12 := 0
		_nAcum13 := 0
	
	    Do Case
	       Case alltrim(GRUPO) == "NON_GRP"
	            cDescGR := "NON GROUP"
	       Case alltrim(GRUPO) == "GEFCO"
	            cDescGR := "GEFCO"
	       Case alltrim(GRUPO) == "PSA"
	            cDescGR := "PSA"
			Otherwise
	            cDescGR := "OUTROS"
	    EndCase
		//
		Do while !eof() .and. UO == _cUO .and. GRUPO == _cGRUPO

			_nAcum01 += VALATR
			_nAcum02 += VALFAT//VALDEV
			_nAcum03 += NUMTIT
			_nAcum04 += VALDEV+VALAVC//VALANT
			_nAcum05 += VALDEV//VALAVC		
			_nAcum06 += VALA30
			_nAcum07 += VALA60
			_nAcum08 += VALA90
			_nAcum09 += VALA180
			_nAcum10 += VALA365
			_nAcum11 += VALM365
			_nAcum12 += VALCON
			_nAcum13 += VALDEV

			_nAcum101 += VALATR
			_nAcum102 += VALFAT//VALDEV
			_nAcum103 += NUMTIT
			_nAcum104 += VALDEV+VALAVC//VALANT
			_nAcum105 += VALDEV//VALAVC		
			_nAcum106 += VALA30
			_nAcum107 += VALA60
			_nAcum108 += VALA90
			_nAcum109 += VALA180
			_nAcum110 += VALA365
			_nAcum111 += VALM365
			_nAcum112 += VALCON
			_nAcum113 += VALDEV

//			aAcum[1] += VALATR
//			aAcum[2] += VALFAT//VALDEV
//			aAcum[3] += NUMTIT
//			aAcum[4] += VALDEV+VALAVC//VALANT
//			aAcum[5] += VALDEV//VALAVC		
//			aAcum[6] += VALA30
//			aAcum[7] += VALA60
//			aAcum[8] += VALA90
//			aAcum[9] += VALA180
//			aAcum[10] += VALA365
//			aAcum[11] += VALM365
		
			DbSkip()	
		
		Enddo
	    
		@ li, 000 PSAY _cUO  &&+" "+_cDescUO
		@ Li, 020 psay _cGRUPO 
		@ li, 044 PSAY _nAcum02                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 068 PSAY _nAcum12         			    Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 086 PSAY _nAcum13                       Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		//	nPerc:=(VALDEV+VALAVC)
		//	nPerc:=(VALDEV*100)/nPerc
		//	@ li, 110 PSAY  nPerc Picture "999.99%"//+PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 120 PSAY _nAcum06                      Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 138 PSAY _nAcum07                      Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 156 PSAY _nAcum08                      Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 174 PSAY _nAcum09                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 192 PSAY _nAcum10                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 205 PSAY _nAcum11                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)		
	    //Endif
	    nRede  := nRede  + _nAcum113            
		Li++
	Enddo
	//	
	Li ++
	@ li, 00 PSAY "TOTAL....... "
	@ Li, 020 psay _cUO  &&+" "+_cDescUO
	@ li, 044 PSAY _nAcum102                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 068 PSAY _nAcum112         			    Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 086 PSAY _nAcum113                       Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 120 PSAY _nAcum106                      Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 138 PSAY _nAcum107                      Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 156 PSAY _nAcum108                      Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 174 PSAY _nAcum109                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 192 PSAY _nAcum110                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 205 PSAY _nAcum111                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)		
	Li++
	Li++
		
	nC++
    
End
/////////////////////////////////////////////////////
//
// Fim de Apresentacao de Dados por UO / GRUPO
//
/////////////////////////////////////////////////////
//
// *****************************************************************************************************
// *****************************************************************************************************
//
//////////////////////////////////////////////////////
//
//  Apresentacao de Dados Sumarizados Por GRUPO  
//
/////////////////////////////////////////////////////

dbSelectarea("cArq")
cIndGrp 	:= CriaTrab("",.F.)
IndRegua("cArq",cIndGrp ,"GRUPO",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
SetRegua(RecCount())
dbSetOrder(1)
dbGotop()

nC := 0
AntGRUPO := GRUPO   
Li ++
@ Li,1 psay replicate("-",80)+"  TOTALIZACAO POR GRUPO "+replicate("-",80)
Li ++
While !EOF()
	
	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")  //"CANCELADO PELO OPERADOR"
		Exit
	End
	
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	End

	IncRegua()

	_cGRUPO	:=	GRUPO
	_nAcum01 := 0
	_nAcum02 := 0
	_nAcum03 := 0
	_nAcum04 := 0
	_nAcum05 := 0		
	_nAcum06 := 0
	_nAcum07 := 0
	_nAcum08 := 0
	_nAcum09 := 0
	_nAcum10 := 0
	_nAcum11 := 0
	_nAcum12 := 0
	_nAcum13 := 0

    Do Case
       Case alltrim(GRUPO) == "NON_GRP"
            cDescGR := "NON GROUP"
       Case alltrim(GRUPO) == "GEFCO"
            cDescGR := "GEFCO"
       Case alltrim(GRUPO) == "PSA"
            cDescGR := "PSA"
		Otherwise
            cDescGR := "OUTROS"
    EndCase
	//
	Do while !eof() .and. GRUPO == _cGRUPO

		_nAcum01 += VALATR
		_nAcum02 += VALFAT//VALDEV
		_nAcum03 += NUMTIT
		_nAcum04 += VALDEV+VALAVC//VALANT
		_nAcum05 += VALDEV//VALAVC		
		_nAcum06 += VALA30
		_nAcum07 += VALA60
		_nAcum08 += VALA90
		_nAcum09 += VALA180
		_nAcum10 += VALA365
		_nAcum11 += VALM365

		_nAcum12 += VALCON
		_nAcum13 += VALDEV

	
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
	
		DbSkip()	
		
	Enddo
    
//    // If nC >= 20 .And. MV_PAR12 = 1
//    // Por: Ricardo - Em: 09/03/2010
//    If nC >= MV_PAR01 .And. MV_PAR12 = 1    
//	   dbSkip(-1)
//	   Loop
//    Endif

   
//	@ li, 00 PSAY cDescGR
	@ li, 00 PSAY _cGRUPO

	@ li, 44 PSAY _nAcum02                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 068 PSAY _nAcum12         			    Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 086 PSAY _nAcum13                       Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
//	nPerc:=(VALDEV+VALAVC)
//	nPerc:=(VALDEV*100)/nPerc
//	@ li, 110 PSAY  nPerc Picture "999.99%"//+PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 120 PSAY _nAcum06                      Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 138 PSAY _nAcum07                      Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 156 PSAY _nAcum08                      Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 174 PSAY _nAcum09                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 192 PSAY _nAcum10                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
	@ li, 205 PSAY _nAcum11                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)		
    //Endif

    nRede  := nRede  + _nAcum13            
//    nRede1 := nRede1 + VALANT                    
//    nRede2 := nRede2 + VALAVC                    

//	aAcum[1] += VALATR
//	aAcum[2] += VALFAT//VALDEV
//	aAcum[3] += NUMTIT
//	aAcum[4] += VALDEV+VALAVC//VALANT
//	aAcum[5] += VALDEV//VALAVC		
//	aAcum[6] += VALA30
//	aAcum[7] += VALA60
//	aAcum[8] += VALA90
//	aAcum[9] += VALA180
//	aAcum[10] += VALA365
//	aAcum[11] += VALM365
//
//    AntGRUPO := GRUPO
//    AntDescr := cDescGR
//    dbSkip(-1)
	Li++
	nC++
    
End 

///////////////////////////////////////////////////
//
// Fim de Apresentacao de Dados por GRUPO
//
///////////////////////////////////////////////////
//

//    ImptotG(aAcum,nT)                        

//
// Imprimir Demonstrativo por Unidade Operacional / Grupo / Filial
//
      
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
//@Li , 44 PSAY aAcum[2]						  PICTURE PesqPict("SE1","E1_SALDO",13,mv_par03)		&& Volume Negocios
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

If MsgYesNo("Deseja Imprimir Demonstrativo por Grupo / Filial / Unidade Operacional  ?")
	//
	///////////////////////////////////////////////////////////////////////////
	//
	//  Apresentacao de Dados Sumarizados Por Grupo / Filial / Unidade Operacional
	//
	///////////////////////////////////////////////////////////////////////////
    //
    //                                10        20        30
    //                       1234567890123456789012345678901234567890
//  cabec1 := OemToAnsi("Unid Operac        Grupo          Fil        Vol.Negocios           Saldo Contab.     Saldo Vencido        %Saldo Venc.      1 a 30           31 a 60           61 a 90          91 a 180         181 a 365             > 365")
    cabec1 := OemToAnsi("Grupo              Filial         Unid Oper  Vol.Negocios           Saldo Contab.     Saldo Vencido                          1 a 30           31 a 60           61 a 90          91 a 180         181 a 365             > 365")

	cabec2 := "Periodo: "+dtoc(MV_PAR06)+" a "+dtoc(MV_PAR07)
	
	dbSelectarea("cArq")
	cIndUoGr 	:= CriaTrab("",.F.)
	IndRegua("cArq",cIndUOGr ,"GRUPO+FILIAL+CCONT",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."

	SetRegua(RecCount())
	dbSetOrder(1)
	dbGotop()
	//
	Li+=50
	nC := 0
	nTotReg	:= 0
	//Li ++
	//@ Li,01 psay "TOTALIZACAO POR UNIDADE OPERACIONAL / GRUPO "
	
	Do While !EOF()
		
		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")  //"CANCELADO PELO OPERADOR"
			Exit
		End
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		End
		IncRegua()
		_cGRUPO	:=	GRUPO
		@ li, 000 PSAY _cGRUPO

		_nAcumG01 := 0  && Totalizacao por Grupo
		_nAcumG02 := 0
		_nAcumG03 := 0
		_nAcumG04 := 0
		_nAcumG05 := 0		
		_nAcumG06 := 0
		_nAcumG07 := 0
		_nAcumG08 := 0
		_nAcumG09 := 0
		_nAcumG10 := 0
		_nAcumG11 := 0
		_nAcumG12 := 0
		_nAcumG13 := 0

		_nAcumF01 := 0  && Totalizacao por Filial
		_nAcumF02 := 0
		_nAcumF03 := 0
		_nAcumF04 := 0
		_nAcumF05 := 0		
		_nAcumF06 := 0
		_nAcumF07 := 0
		_nAcumF08 := 0
		_nAcumF09 := 0
		_nAcumF10 := 0
		_nAcumF11 := 0
		_nAcumF12 := 0
		_nAcumF13 := 0

		_nAcumU01 := 0  && Totalizacao por Unidade Operacional
		_nAcumU02 := 0
		_nAcumU03 := 0
		_nAcumU04 := 0
		_nAcumU05 := 0		
		_nAcumU06 := 0
		_nAcumU07 := 0
		_nAcumU08 := 0
		_nAcumU09 := 0
		_nAcumU10 := 0
		_nAcumU11 := 0
		_nAcumU12 := 0
		_nAcumU13 := 0

	    Do Case
	       Case alltrim(GRUPO) == "NON_GRP"
	            cDescGR := "NON GROUP"
	       Case alltrim(GRUPO) == "GEFCO"
	            cDescGR := "GEFCO"
	       Case alltrim(GRUPO) == "PSA"
	            cDescGR := "PSA"
			Otherwise
	            cDescGR := "OUTROS"
	    EndCase
		//
		Do while !eof() .and. GRUPO == _cGRUPO
	
           	_cFILMOV	:= 	FILIAL
			_cDescFil	:=	Posicione("SM0",1,CEMPANT+_cFILMOV,"M0_FILIAL")
			@ Li, 020 psay substr(_cDESCFIL,1,12) 			

  			_nAcumF01 := 0  && Totalizacao por Filial
			_nAcumF02 := 0
			_nAcumF03 := 0
			_nAcumF04 := 0
			_nAcumF05 := 0		
			_nAcumF06 := 0
			_nAcumF07 := 0
			_nAcumF08 := 0
			_nAcumF09 := 0
			_nAcumF10 := 0
			_nAcumF11 := 0
			_nAcumF12 := 0
			_nAcumF13 := 0

			_nAcumU01 := 0  && Totalizacao por Unidade Operacional
			_nAcumU02 := 0
			_nAcumU03 := 0
			_nAcumU04 := 0
			_nAcumU05 := 0		
			_nAcumU06 := 0
			_nAcumU07 := 0
			_nAcumU08 := 0
			_nAcumU09 := 0
			_nAcumU10 := 0
			_nAcumU11 := 0
			_nAcumU12 := 0
			_nAcumU13 := 0
			Do while !eof() .and. GRUPO == _cGRUPO .and. FILIAL == _cFILMOV
				//
				_cUO	:= CCONT

			
//				Do Case
//				   	Case _cUO == "01" .OR. _cUO == "02"
//			   	    	_cDescUO := "TLA"  	&& "RDVM"
//			   		Case _cUO == "21" 
//			   	    	_cDescUO := "LOG"	&& "ILI"         
//			   		Case _cUO == "11" 
//			        	_cDescUO := "OVL"	&& "RMLAP"   
//			   		Case _cUO == "22" .OR. _cUO == "23" 
//			        	_cDescUO := "OVS"	&& "RMA"            
//			   		Otherwise
//			   			_cDescUO := "Outros"
//				EndCase

				Do while !eof() .and. GRUPO == _cGRUPO .and. FILIAL == _cFILMOV .and. CCONT == _cUO		&& AQUIIIIIIIIIIIIII
					//
					_nAcumU01 += VALATR				&& Totalizacao por Unidade Operacional
					_nAcumU02 += VALFAT//VALDEV
					_nAcumU03 += NUMTIT
					_nAcumU04 += VALDEV+VALAVC//VALANT
					_nAcumU05 += VALDEV//VALAVC		
					_nAcumU06 += VALA30
					_nAcumU07 += VALA60
					_nAcumU08 += VALA90
					_nAcumU09 += VALA180
					_nAcumU10 += VALA365
					_nAcumU11 += VALM365
					_nAcumU12 += VALCON
					_nAcumU13 += VALDEV
	
					_nAcumF01 += VALATR				&& Totalizacao por Filial
					_nAcumF02 += VALFAT//VALDEV
					_nAcumF03 += NUMTIT
					_nAcumF04 += VALDEV+VALAVC//VALANT
					_nAcumF05 += VALDEV//VALAVC		
					_nAcumF06 += VALA30
					_nAcumF07 += VALA60
					_nAcumF08 += VALA90
					_nAcumF09 += VALA180
					_nAcumF10 += VALA365
					_nAcumF11 += VALM365
					_nAcumF12 += VALCON
					_nAcumF13 += VALDEV
		
					_nAcumG01 += VALATR				&& Totalizacao por Grupo
					_nAcumG02 += VALFAT//VALDEV
					_nAcumG03 += NUMTIT
					_nAcumG04 += VALDEV+VALAVC//VALANT
					_nAcumG05 += VALDEV//VALAVC		
					_nAcumG06 += VALA30
					_nAcumG07 += VALA60
					_nAcumG08 += VALA90
					_nAcumG09 += VALA180
					_nAcumG10 += VALA365
					_nAcumG11 += VALM365
					_nAcumG12 += VALCON
					_nAcum113 += VALDEV

					nTotReg ++	
					DbSkip()	
				
				Enddo
 	            //
//				@ li, 000 PSAY _cGRUPO
//				@ Li, 020 psay substr(_cDESCFIL,1,12) 			
				IF li > 58
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)  
					Li 	:=	prow()
					LI ++
					@ li, 000 PSAY _cGRUPO
					@ Li, 020 psay substr(_cDESCFIL,1,12)     				
				End
		
				@ Li, 035 psay _cUO 
//				@ li, 044 PSAY _nAcumU02                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
				@ li, 068 PSAY _nAcumU12         			 Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
				@ li, 086 PSAY _nAcumU13                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
				@ li, 120 PSAY _nAcumU06                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
				@ li, 138 PSAY _nAcumU07                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
				@ li, 156 PSAY _nAcumU08                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
				@ li, 174 PSAY _nAcumU09                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
				@ li, 192 PSAY _nAcumU10                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
				@ li, 205 PSAY _nAcumU11                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)		

			    nRede  := nRede  + _nAcumU13            
				Li++
				_mOldArea	:=	alias()
				//
//				Do Case
//				   	Case _cUO == "01" .OR. _cUO == "02"
//			   	    	_cDescUO := "TLA"  	&& "RDVM"
//			   		Case _cUO == "21" 
//		   		    	_cDescUO := "LOG"	&& "ILI"         
//			   		Case _cUO == "11" 
//		    	    	_cDescUO := "OVL"	&& "RMLAP"   
//			   		Case _cUO == "22" .OR. _cUO == "23" 
//			        	_cDescUO := "OVS"	&& "RMA"            
//			   		Otherwise
//			   			_cDescUO := "Outros"
//  		    EndCase
				DbSelectArea("cXls")
				RecLock("cXls",.t.)
			   	cXls->UO		:=	_cUO
			   	cXls->DESCUO	:=	"" &&_cDescUO
			   	cXls->GRUPO		:=	_cGRUPO
			   	cXls->FILIAL	:=	_cFILMOV
			   	cXls->DESCFIL	:=	_cDESCFIL && Posicione("SM0",1,cEmpAnt+_cFILMOV,"M0_FILIAL")
			   	cXls->VALFAT	:=	_nAcumU02
			   	cXls->VALCON	:=	_nAcumU12
			   	cXls->VALDEV	:=	_nAcumU13
			   	cXls->VALA30	:=	_nAcumU06
			   	cXls->VALA60	:=	_nAcumU07
			   	cXls->VALA90	:=	_nAcumU08
			   	cXls->VALA180	:=	_nAcumU09
			   	cXls->VALA365	:=	_nAcumU10
			   	cXls->VALM365	:=	_nAcumU11			
				MsUnlock()
				//								
				_nAcumU01 := 0  && Totalizacao por Unidade Operacional
				_nAcumU02 := 0
				_nAcumU03 := 0
				_nAcumU04 := 0
				_nAcumU05 := 0		
				_nAcumU06 := 0
				_nAcumU07 := 0
				_nAcumU08 := 0
				_nAcumU09 := 0
				_nAcumU10 := 0
				_nAcumU11 := 0
				_nAcumU12 := 0
				_nAcumU13 := 0

				DbSelectArea(_mOldArea)
				//
			Enddo	                   
//			@ li, 000 PSAY _cGRUPO
			@ Li, 020 psay replicate("-",218)
			Li ++
			@ Li, 020 psay "Total "+_cFILMOV+" "+substr(_cDESCFIL,1,12)
//			@ li, 044 PSAY _nAcumF02                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
			@ li, 068 PSAY _nAcumF12           		     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
			@ li, 086 PSAY _nAcumF13                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
			@ li, 120 PSAY _nAcumF06                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
			@ li, 138 PSAY _nAcumF07                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
			@ li, 156 PSAY _nAcumF08                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
			@ li, 174 PSAY _nAcumF09                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
			@ li, 192 PSAY _nAcumF10                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
			@ li, 205 PSAY _nAcumF11                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)		
		    //Endif
		    nRede  := nRede  + _nAcum113            
			_nAcumF01 := 0  && Totalizacao por Unidade Operacional
			_nAcumF02 := 0
			_nAcumF03 := 0
			_nAcumF04 := 0
			_nAcumF05 := 0		
			_nAcumF06 := 0
			_nAcumF07 := 0
			_nAcumF08 := 0
			_nAcumF09 := 0
			_nAcumF10 := 0
			_nAcumF11 := 0
			_nAcumF12 := 0
			_nAcumF13 := 0
			Li++
			@ Li, 020 psay replicate("-",215)
			Li ++
		Enddo
		//	 
		@ Li, 00 psay replicate("-",218)
		Li ++
		@ li, 00 PSAY "TOTAL "+_cGRUPO
//		@ li, 044 PSAY _nAcumG02                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 068 PSAY _nAcumG12         		     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 086 PSAY _nAcumG13                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 120 PSAY _nAcumG06                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 138 PSAY _nAcumG07                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 156 PSAY _nAcumG08                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 174 PSAY _nAcumG09                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 192 PSAY _nAcumG10                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)
		@ li, 205 PSAY _nAcumG11                     Picture PesqPict("SE1","E1_SALDO",13,mv_par03)		
		Li++
		@ Li, 00 psay replicate("-",218)
		Li ++
		_nAcumG01 := 0  && Totalizacao por Unidade Operacional
		_nAcumG02 := 0
		_nAcumG03 := 0
		_nAcumG04 := 0
		_nAcumG05 := 0		
		_nAcumG06 := 0
		_nAcumG07 := 0
		_nAcumG08 := 0
		_nAcumG09 := 0
		_nAcumG10 := 0
		_nAcumG11 := 0
		_nAcumG12 := 0
		_nAcumG13 := 0

		nC++
	Enddo
/////////////////////////////////////////////////////
//
// Fim de Apresentacao de Dados por UO / GRUPO / Filial
//
/////////////////////////////////////////////////////
//
//
EndIF                                 
//
If MsgYesno("Deseja gerar arquivo Excel ?","Gerar Planilha")
	//
	// ********************************** Inicio de Geracao de Arquivo Excel ****************************************
	//
	aArray2 := { {"Unid_Oper",;       	&& 1
				"Desc_UO",;             && 2
				"Cod_Grupo",;           && 3
				"Cod_Filial",;          && 4 
				"Desc_Filial",;         && 5
				"Volume_Negocios",;     && 6
				"Saldo_Contabil",;      && 7
				"Saldo_Vencido",;       && 8
				"Vencido_30",;          && 9
				"Vencido_60",;          && 10
				"Vencido_90",;          && 11
				"Vencido_180",;         && 12
				"Vencido_365",;         && 13
				"Vencido_acima"} }      && 14
//	// 
//	
//	DbSelectArea("SM0")
//	DbSetOrder (1)
//	IncProc("Gerando Cabeçalho Planilha")
// 	aAdd(aArray2,{Alltrim(SM0->M0_CGC),;
//	Alltrim(SM0->M0_NOMECOM),;
//	Alltrim(SM0->M0_ENDCOB),;
//	Alltrim(SM0->M0_COMPCOB),;
//	Alltrim(SM0->M0_BAIRCOB),;
//	Alltrim(SM0->M0_CEPCOB),;
//	Alltrim(SM0->M0_TEL),;
//	Alltrim(SM0->M0_CODMUN),;
//	Alltrim(SM0->M0_CNAE)})                   
    //             1  2  3  4  5  6  7  8  9  0  1  2  3
 	aAdd(aArray2,{"","","","","","","","","","","","","",""})
// 	//
	ProcRegua(nTotReg)
	//
	dbSelectArea("cXls")
//	(cArq)->(DbGoTop())
	DbGoTop()
	While !Eof()
                IncProc("Gerando Itens Planilha")
                
                aAdd(aArray2,{  UO,;				&& Unidade Operacional
                  				DESCUO,;     		&& Desc Unidade Operacional
			                	GRUPO,;             && Grupo
                				FILIAL,;            && Filial
                				DESCFIL,;
			                    VALFAT,;            && Volume Negocio
			                	VALCON,;            && Saldo Contabil
                				VALDEV,;            && Saldo Vencido
			                    VALA30,;             && Vencido ate 30
			                    VALA60,;             && Vencido ate 60
                				VALA90,;            && Vencido ate 90
			                    VALA180,;             && Vencido ate 180
                				VALA365,;            && Vencido ate 365
			                    VALM365})             && Vencido acima 365
                DbSkip()

	Enddo
    //
	DlgToExcel({{"ARRAY","","",aArray2}})
	//
	// **********************************  Fim de Geracao de Arquivo Excel ******************************************
	//
Endif
//
// ******************************************************************************************************
//
IF li != 80
	roda(cbcont,cbtxt,"G")
End
 
//
If FILE(cArq+".DBF")     //Elimina o arquivo de trabalho
    dbCloseArea()
    Ferase(cArq+".DBF")
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

