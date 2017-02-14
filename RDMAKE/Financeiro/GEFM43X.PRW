#include "rwmake.ch"      
#include "TOPCONN.ch"      

User Function GEFM43X()    //Não utilizar usar a versão GEFM43XX()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GEFM43   ³ Autor ³ Saulo Muniz           ³ Data ³ 29.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Faturamento por RANKING - REGULAR             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Utilizacao³ Especifico para GEFCO                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³ Manutencao Efetuada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 21.09.05 ³ Saulo Muniz   ³ Adicionado tratamneto por U.O              ³±±
±±³ 03.07.06 ³ Marcos Furtado³ Inclusão de Agrupamento de Cliente         ³±±
±±³ 10.07.06 ³ Marcos Furtado³ Inclusão de total por Cliente              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Adicionado Kvalor, Separação por U.O. - Saulo Muniz 30/11/2005

cString  :="SE1"
cDesc1   := OemToAnsi("Este programa tem como objetivo, demonstrar o")
cDesc2   := OemToAnsi("Faturamento das Vendas")
cDesc3   := ""
tamanho  := "G" // "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "GEFM43X"
wnrel    := nomeprog
aLinha   := { }
aCampos  := { }
nLastKey := 0
titulo   :="Relatorio de Faturamento por periodo "
cCancel  := "***** CANCELADO PELO OPERADOR *****"
cPerg    :="GEFM35"
xDescM1  := " "
xDescUO  := " "
Pergunte(CPERG,.F.)

Store 0 to xMerc,xIcmr,xDesc,xValb,xtMerc,xtQTLT,xtValDev,xtVendLiq,xtIcmr,xtDesc,xtValb,xTliq
Store 0 to xdMerc,xdIcmr,xdDesc,xdValb,xtdMerc,xtdIcmr,xtdDesc,xtdValb,XTtliq
Store 0 to xLitros,xdLitros,xTlitros,_RnkTot   
Store 0 to xQtdMes1,xQtdMes2,xQtdMes3,xQtdMes4,xQtdMes5,xQtdMes6,xQtdMes7,xQtdMes8,xQtdMes9,xQtdMes10,xQtdMes11,xQtdMes12
Store 0 to xVlrMes1,xVlrMes2,xVlrMes3,xVlrMes4,xVlrMes5,xVlrMes6,xVlrMes7,xVlrMes8,xVlrMes9,xVlrMes10,xVlrMes11,xVlrMes12,xVlrTotal    

aTotCF := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametro                         ³
//³ mv_par01              Data de                               ³
//³ mv_par02              Ate                                   ³
//³ mv_par03              Valores                               ³
//³ mv_par04              Unidade Oper.                         ³
//³ mv_par05              Cliente/Grupo                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//TABELA DE UO (PERGUNTAS SX1) = TIPO NUMERICO (1)
/*  
 1 = TODOS
 2 = RDVM
 3 = ILI
 4 = RMLAP
 5 = RMA
 
*/

xDescM1 := IIF(MV_PAR03==1,"REAIS "," KVALOR ")

DO CASE
   CASE MV_PAR04 == 1
        xDescUO := "TODOS"
   CASE MV_PAR04 == 2
        xDescUO := "RDVM" 
   CASE MV_PAR04 == 3
        xDescUO := "ILI"      
   CASE MV_PAR04 == 4
        xDescUO := "RMLAP"   
   CASE MV_PAR04 == 5
        xDescUO := "RMA"         
ENDCASE

SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,tamanho)

titulo  :="Relatorio Faturamento Mensal -  " + xDescM1 + dtoc(mv_par01) + " Ate  " + dtoc(mv_par02) + " - Unidade Oper. " + xDescUO

If nLastKey == 27
	 Set Filter To
	 Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	 Set Filter To
	 Return
Endif

RptStatus({|| RptDetail() })  
Return NIL

Static Function RptDetail()
Local cOrdem := ""

cbcont := 0
cbtxt  := space(10)
cabec1 := "NOME                         JAN            FEV            MAR            ABR            MAI            JUN            JUL            AGO            SET            OUT            NOV            DEZ          TOTAL    %"
//cabec1 := "NOME                         JAN            FEV            MAR            ABR            MAI            JUN            JUL            AGO            SET            OUT            NOV            DEZ           %"
//     := " NOME                              JAN          FEV          MAR          ABR          MAI          JUN          JUL          AGO          SET          OUT          NOV          DEZ         %"
cabec2 := " "
//12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//cabec2 := " "     10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200        210       
li     := 155 //80
m_pag  := 1

cNomArq1    := "GEFM43.DBF"                 // Arquivo
cNomInd1    := "GEFM43"+OrdBagExt()         // Indice

If File(cNomArq1)  
   V_Erase1 := FErase(cNomArq1)        
   If V_Erase1 != 0      
      Msgbox("Problemas ao tentar excluir o arquivo : " + cNomArq1  + "." + chr(13)+;
             "Portanto a operacao nao sera realizada." ,"Aviso")
      Return .t.
   Endif
   
Endif

//Preparando os Arquivos
//************************
aCampos  := { }
aTam:=TamSX3("E1_CLIENTE")
AADD(aCampos, {"TB_CODIGO ", "C", aTam[1], aTam[2]})
aTam:=TamSX3("E1_LOJA")
AADD(aCampos, {"TB_LOJA   ", "C", aTam[1], aTam[2]})
aTam:=TamSX3("E1_NOMCLI")
AADD(aCampos, {"TB_NOME   ", "C", aTam[1], aTam[2]})
aTam:=TamSX3("E1_VALOR")
AADD(aCampos, {"TB_VALBRUT", "N", aTam[1], aTam[2]})
aTam:=TamSX3("E1_EMISSAO")
AADD(aCampos, {"TB_EMIS", "D", aTam[1], aTam[2]})
AADD(aCampos, {"TB_RANKING", "N", 17, 0})
AADD(aCampos, {"TB_MES01", "N", 9, 0})
AADD(aCampos, {"TB_MES02", "N", 9, 0})
AADD(aCampos, {"TB_MES03", "N", 9, 0})
AADD(aCampos, {"TB_MES04", "N", 9, 0})
AADD(aCampos, {"TB_MES05", "N", 9, 0})
AADD(aCampos, {"TB_MES06", "N", 9, 0})
AADD(aCampos, {"TB_MES07", "N", 9, 0})
AADD(aCampos, {"TB_MES08", "N", 9, 0})
AADD(aCampos, {"TB_MES09", "N", 9, 0})
AADD(aCampos, {"TB_MES10", "N", 9, 0})
AADD(aCampos, {"TB_MES11", "N", 9, 0})
AADD(aCampos, {"TB_MES12", "N", 9, 0})
AADD(aCampos, {"TB_VAL01", "N", 17, 2})
AADD(aCampos, {"TB_VAL02", "N", 17, 2})
AADD(aCampos, {"TB_VAL03", "N", 17, 2})
AADD(aCampos, {"TB_VAL04", "N", 17, 2})
AADD(aCampos, {"TB_VAL05", "N", 17, 2})
AADD(aCampos, {"TB_VAL06", "N", 17, 2})
AADD(aCampos, {"TB_VAL07", "N", 17, 2})
AADD(aCampos, {"TB_VAL08", "N", 17, 2})
AADD(aCampos, {"TB_VAL09", "N", 17, 2})
AADD(aCampos, {"TB_VAL10", "N", 17, 2})
AADD(aCampos, {"TB_VAL11", "N", 17, 2})
AADD(aCampos, {"TB_VAL12", "N", 17, 2})
AADD(aCampos, {"TB_VALTT", "N", 17, 2})
AADD(aCampos, {"TB_PERC ", "N",  6, 2})

cNomArq := CriaTrab (aCampos, .T.)
dbUseArea (.T., , cNomArq, "TRB", .T. , .F.)
_cArqInd := Criatrab("",.F.)
IndRegua("TRB",_cArqInd,"TB_CODIGO",,,"Selecionando Registros.")
dbGoTop ()                                               

dbSelectarea("SE1")
dbSetOrder(21)
cOrder := SqlOrder(IndexKey())
SetRegua( Reccount())
dbCloseArea()


// Todas filiais
cQuery := "SELECT * "
cQuery += "  FROM "+	RetSqlName("SE1")
cQuery += " WHERE D_E_L_E_T_ <> '*' AND "
cQuery += " E1_EMISSAO >= '" +DTOS(Mv_Par01)+"' AND "
cQuery += " E1_EMISSAO <= '" +DTOS(Mv_Par02)+"' AND "                              
cQuery += " E1_PREFIXO <> 'FAT' AND "                              
cQuery += " E1_PREFIXO <> 'INV' AND "                              
cQuery += " E1_TIPO <> 'NCC' AND "                              
cQuery += " E1_CCONT <> ' ' "                              

/*cQuery += " (E1_CLIENTE = '001503' OR E1_CLIENTE = '026559' OR"                              
cQuery += " E1_CLIENTE = '031371' OR E1_CLIENTE = '031663' OR E1_CLIENTE = '037906') AND "                              */

//  If MV_PAR04 == 1  // 1 = TODOS ; 2 = RDVM ; 3= ILI ; 4= RMLAP ; 5= RMA             
Do Case
   Case mv_par04 = 2  //RDVM

   		if MV_PAR05 = 1        
	        cQuery += " AND (SUBSTRING(E1_CCONT,2,2) = '01' OR SUBSTRING(E1_CCONT,2,2) = '02') " 		      		
	    Else                                               
	/*        cQuery += " AND ((SUBSTRING(E1_CCONT,4,1)  = '5' AND SUBSTRING(E1_CCONT,2,2) <> '11') "	        
			cQuery += "       OR  SUBSTRING(E1_CCONT,2,2) = '11' )  "*/
	    EndIf	    
   		
   Case mv_par04 = 3  //ILI    
   		if MV_PAR05 = 1           
   		    cQuery += " AND SUBSTRING(E1_CCONT,2,2) = '21'  " 		   
   		Else 
   		////
   		EndIF
   Case mv_par04 = 4  //RMLAP         
   		if MV_PAR05 = 1
	        cQuery += " AND SUBSTRING(E1_CCONT,2,2) = '11' " 		   
	    Else                                               
	        cQuery += " AND ((SUBSTRING(E1_CCONT,4,1)  = '5' AND SUBSTRING(E1_CCONT,2,2) <> '11') "	        
			cQuery += "       OR  SUBSTRING(E1_CCONT,2,2) = '11' )  "
	    EndIf	    
        
   Case mv_par04 = 5  //RMA                                             
   
   		if MV_PAR05 = 1
	        cQuery += " AND ( SUBSTRING(E1_CCONT,2,2) = '22' OR SUBSTRING(E1_CCONT,2,2) = '23') " 		   
	    Else              
	        cQuery += " AND ( SUBSTRING(E1_CCONT,4,1)  >= '6' AND SUBSTRING(E1_CCONT,4,1)  <= '9' "
	        cQuery += "       AND SUBSTRING(E1_CCONT,2,2) <> '22' AND SUBSTRING(E1_CCONT,2,2) <> '23' "
			cQuery += "       OR ( SUBSTRING(E1_CCONT,2,2) = '22' OR SUBSTRING(E1_CCONT,2,2) = '23') ) "       
	    EndIf	    
       
EndCase				
                                            
cQuery += " ORDER BY " + cOrder

//cQuery := ChangeQuery(cQuery)
//Alert(cOrder)
//ALERT(cQuery)

//dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)
MEMOWRIT("D:\TEMP\RANKINGX.TXT",cQuery)
  TCQUERY cQuery ALIAS "SE1" NEW
  dbSelectArea("SE1") 



/*dbselectarea("SE1")
DbSetOrder(21)  // EMISSAO+CLIENTE+LOJA
dbGoTop ()
SetRegua(SE1->(LastRec()))
DbSeek(MV_PAR01,.T.)*/
xCliente  := SE1->E1_CLIENTE            

While !Eof() 
    
    IncRegua()
        
/*	If SE1->E1_EMISSAO <= mv_par01 .And. SE1->E1_EMISSAO >= mv_par02
       dbSelectArea("SE1")
	   dbSkip()
	   Loop
	EndIf

	If SE1->E1_PREFIXO == "FAT"  // DESCONSIDERA FATURAS, APENAS OS TITULOS GERADOS
       dbSelectArea("SE1")
	   dbSkip()
	   Loop
	EndIf*/

/*    If MV_PAR04 == 1  // 1 = TODOS ; 2 = RDVM ; 3= ILI ; 4= RMLAP ; 5= RMA             

    Else
    
       cUo    := Substr(Alltrim(SE1->E1_CCONT),2,2)
       xPar04 := MV_PAR04
       
       If Empty(SE1->E1_CCONT)   // Centro de custo vazio
          dbSelectArea("SE1")
          dbSkip()
   	      Loop              
       Endif       
    
       Do Case  
    	  Case cUo $ "01|02" 
               xFiltro := 2  	   
    	  Case cUo == "11" 
               xFiltro := 4   	         	         	         	   
//   	      Case cUo == "22|23" 
   	      Case cUo $ "22|23"    	      
               xFiltro := 5   	         	         	   
    	  Case cUo $ "21" 
               xFiltro := 3   	              	         	 	             
          OtherWise
               xFiltro := 1                     
       EndCase
    
       If xPar04 == xFiltro
          //Ok
       Else
          dbSelectArea("SE1")
          dbSkip()
          Loop       
       Endif       
           
    Endif   */

	If  SE1->E1_CLIENTE <> xCliente
        xQtdMes1  := 0
        xQtdMes2  := 0
        xQtdMes3  := 0
        xQtdMes4  := 0
        xQtdMes5  := 0
        xQtdMes6  := 0            
        xQtdMes7  := 0    
        xQtdMes8  := 0    
        xQtdMes9  := 0    
        xQtdMes10 := 0
        xQtdMes11 := 0
        xQtdMes12 := 0
        xQtdTotal := 0        
        xVlrMes1  := 0
        xVlrMes2  := 0
        xVlrMes3  := 0    
        xVlrMes4  := 0    
        xVlrMes5  := 0
        xVlrMes6  := 0
        xVlrMes7  := 0    
        xVlrMes8  := 0    
        xVlrMes9  := 0
        xVlrMes10 := 0    
        xVlrMes11 := 0    
        xVlrMes12 := 0    	
        xVlrTotal := 0    	        
        xCliente := SE1->E1_CLIENTE	

	Endif
	//
/*	Do Case  // APENAS FATURAMENTO REGULAR

	   Case Month(STOD(SE1->E1_EMISSAO)) == 1
            xVlrMes1 := SE1->E1_VALOR 
            xQtdMes1 := xQtdMes1 + 1
            
	   Case Month(STOD(SE1->E1_EMISSAO)) == 2
            xVlrMes2 := SE1->E1_VALOR
            xQtdMes2 := xQtdMes2 + 1
            
	   Case Month(STOD(SE1->E1_EMISSAO)) == 3
            xVlrMes3 := SE1->E1_VALOR  
            xQtdMes3 := xQtdMes3 + 1            
            
	   Case Month(STOD(SE1->E1_EMISSAO)) == 4
			xVlrMes4 :=	SE1->E1_VALOR			 
            xQtdMes4 := xQtdMes4 + 1            
       
       Case Month(STOD(SE1->E1_EMISSAO)) == 5
            xVlrMes5 := SE1->E1_VALOR
            xQtdMes5 := xQtdMes5 + 1            
            
	   Case Month(STOD(SE1->E1_EMISSAO)) == 6
            xVlrMes6 := SE1->E1_VALOR
            xQtdMes6 := xQtdMes6 + 1            
            
	   Case Month(STOD(SE1->E1_EMISSAO)) == 7
            xVlrMes7 := SE1->E1_VALOR
            xQtdMes7 := xQtdMes7 + 1            
            
	   Case Month(STOD(SE1->E1_EMISSAO)) == 8
			xVlrMes8 :=	SE1->E1_VALOR			 
            xQtdMes8 := xQtdMes8 + 1            
       
       Case Month(STOD(SE1->E1_EMISSAO)) == 9
            xVlrMes9 := SE1->E1_VALOR
            xQtdMes9 := xQtdMes9 + 1                        
            
	   Case Month(STOD(SE1->E1_EMISSAO)) == 10
            xVlrMes10 := SE1->E1_VALOR
            xQtdMes10 := xQtdMes10 + 1            
            
	   Case Month(STOD(SE1->E1_EMISSAO)) == 11
            xVlrMes11 := SE1->E1_VALOR
            xQtdMes11 := xQtdMes11 + 1            
                        
	   Case Month(STOD(SE1->E1_EMISSAO)) == 12
			xVlrMes12 := SE1->E1_VALOR				 					   			   
            xQtdMes12 := xQtdMes12 + 1            
       //Otherwise
	
	EndCase                       */

	// APENAS FATURAMENTO REGULAR

	If Month(STOD(SE1->E1_EMISSAO)) == 1
            xVlrMes1 := SE1->E1_VALOR 
            xQtdMes1 := xQtdMes1 + 1
            
	ElseIF Month(STOD(SE1->E1_EMISSAO)) == 2
            xVlrMes2 := SE1->E1_VALOR
            xQtdMes2 := xQtdMes2 + 1
            
	ElseIF Month(STOD(SE1->E1_EMISSAO)) == 3
            xVlrMes3 := SE1->E1_VALOR  
            xQtdMes3 := xQtdMes3 + 1            
            
	ElseIF Month(STOD(SE1->E1_EMISSAO)) == 4
			xVlrMes4 :=	SE1->E1_VALOR			 
            xQtdMes4 := xQtdMes4 + 1            
       
    ElseIF Month(STOD(SE1->E1_EMISSAO)) == 5
            xVlrMes5 := SE1->E1_VALOR
            xQtdMes5 := xQtdMes5 + 1            
            
	ElseIF Month(STOD(SE1->E1_EMISSAO)) == 6
            xVlrMes6 := SE1->E1_VALOR
            xQtdMes6 := xQtdMes6 + 1            
            
	ElseIF Month(STOD(SE1->E1_EMISSAO)) == 7
            xVlrMes7 := SE1->E1_VALOR
            xQtdMes7 := xQtdMes7 + 1            
            
	ElseIF Month(STOD(SE1->E1_EMISSAO)) == 8
			xVlrMes8 :=	SE1->E1_VALOR			 
            xQtdMes8 := xQtdMes8 + 1            
       
    ElseIF Month(STOD(SE1->E1_EMISSAO)) == 9
            xVlrMes9 := SE1->E1_VALOR
            xQtdMes9 := xQtdMes9 + 1                        
            
	ElseIF Month(STOD(SE1->E1_EMISSAO)) == 10
            xVlrMes10 := SE1->E1_VALOR
            xQtdMes10 := xQtdMes10 + 1            
            
	ElseIF Month(STOD(SE1->E1_EMISSAO)) == 11
            xVlrMes11 := SE1->E1_VALOR
            xQtdMes11 := xQtdMes11 + 1            
                        
	ElseIF Month(STOD(SE1->E1_EMISSAO)) == 12
			xVlrMes12 := SE1->E1_VALOR				 					   			   
            xQtdMes12 := xQtdMes12 + 1            
       //Otherwise
	
	EndIf                         

	//alteração Marcos Furtado - 10/07/2006
	//Inclusão de total
    xVlrTotal := SE1->E1_VALOR
	
//  Alteração - Marcos Furtado  
//    xCliente := SE1->E1_CLIENTE
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
    If !Empty(SA1->A1_XGRPCLI)
		xCliente := SA1->A1_XGRPCLI       
    	DbSelectArea("SA1")
		DbSetOrder(1)      
		DbGotop()
		DbSeek(xFilial("SA1")+AllTrim(xCliente))
	Else 
		xCliente := SE1->E1_CLIENTE	
	EndIF
	
	DbSelectArea("TRB")
	If !dbSeek(AllTrim(xCliente))
      _nVal := SE1->E1_VALOR     
      RecLock ("TRB",.T.)
//	  Replace TB_CODIGO     with SE1->E1_CLIENTE
//	  Replace TB_LOJA       with SE1->E1_LOJA         
//	  Replace TB_NOME       with UPPER(SE1->E1_NOMCLI)
      If !Empty(SA1->A1_XGRPCLI)
	  	  Replace TB_CODIGO     with SA1->A1_COD
		  Replace TB_LOJA       with SA1->A1_LOJA
		  Replace TB_NOME       with UPPER(SA1->A1_NREDUZ)
      Else 
		  Replace TB_CODIGO     with SE1->E1_CLIENTE
		  Replace TB_LOJA       with SE1->E1_LOJA         
//		  Replace TB_NOME       with UPPER(SE1->E1_NOMCLI)
		  Replace TB_NOME       with UPPER(SA1->A1_NREDUZ)
      EndIF
	  Replace TB_VALBRUT    with _nVal
	  Replace TB_MES01      with xQtdMes1
	  Replace TB_MES02      with xQtdMes2
	  Replace TB_MES03      with xQtdMes3
	  Replace TB_MES04      with xQtdMes4
	  Replace TB_MES05      with xQtdMes5
	  Replace TB_MES06      with xQtdMes6
	  Replace TB_MES07      with xQtdMes7
	  Replace TB_MES08      with xQtdMes8
	  Replace TB_MES09      with xQtdMes9
	  Replace TB_MES10      with xQtdMes10
	  Replace TB_MES11      with xQtdMes11
	  Replace TB_MES12      with xQtdMes12
	  Replace TB_VAL01      with xVlrMes1
	  Replace TB_VAL02      with xVlrMes2
	  Replace TB_VAL03      with xVlrMes3	  
	  Replace TB_VAL04      with xVlrMes4	  
	  Replace TB_VAL05      with xVlrMes5	  
	  Replace TB_VAL06      with xVlrMes6	  	  
	  Replace TB_VAL07      with xVlrMes7
	  Replace TB_VAL08      with xVlrMes8
	  Replace TB_VAL09      with xVlrMes9
	  Replace TB_VAL10      with xVlrMes10	  	  
	  Replace TB_VAL11      with xVlrMes11	  	  	  
	  Replace TB_VAL12      with xVlrMes12	  	  	  
	  Replace TB_VALTT      with xVlrTotal	  	  	  	  
	  Msunlock ()
    Else
      _nVal :=(TRB->TB_VALBRUT+SE1->E1_VALOR)
      RecLock ("TRB",.F.)
	  Replace TB_VALBRUT    with _nVal	  
	  Replace TB_MES01      with TB_MES01+xQtdMes1
	  Replace TB_MES02      with TB_MES02+xQtdMes2
	  Replace TB_MES03      with TB_MES03+xQtdMes3
	  Replace TB_MES04      with TB_MES04+xQtdMes4
	  Replace TB_MES05      with TB_MES05+xQtdMes5
	  Replace TB_MES06      with TB_MES06+xQtdMes6
	  Replace TB_MES07      with TB_MES07+xQtdMes7
	  Replace TB_MES08      with TB_MES08+xQtdMes8
	  Replace TB_MES09      with TB_MES09+xQtdMes9
	  Replace TB_MES10      with TB_MES10+xQtdMes10
	  Replace TB_MES11      with TB_MES11+xQtdMes11
	  Replace TB_MES12      with TB_MES12+xQtdMes12
	  Replace TB_VAL01      with TB_VAL01+xVlrMes1
	  Replace TB_VAL02      with TB_VAL02+xVlrMes2
	  Replace TB_VAL03      with TB_VAL03+xVlrMes3	  
	  Replace TB_VAL04      with TB_VAL04+xVlrMes4	  
	  Replace TB_VAL05      with TB_VAL05+xVlrMes5	  
	  Replace TB_VAL06      with TB_VAL06+xVlrMes6	  	  
	  Replace TB_VAL07      with TB_VAL07+xVlrMes7
	  Replace TB_VAL08      with TB_VAL08+xVlrMes8
	  Replace TB_VAL09      with TB_VAL09+xVlrMes9
	  Replace TB_VAL10      with TB_VAL10+xVlrMes10	  	  
	  Replace TB_VAL11      with TB_VAL11+xVlrMes11	  	  	  
	  Replace TB_VAL12      with TB_VAL12+xVlrMes12	  	  
	  Replace TB_VALTT      with TB_VALTT+xVlrTotal	  	  	  	  	  	  	  
	  Msunlock ()
    EndIf

    dbSelectArea("SE1")
	dbskip()	
    
    // Cria a Linha de Totalizadora
    _RnkTot := _RnkTot + SE1->E1_VALOR
        
EndDo

//
// Classifica por Ranking
//***********************
//
DbSelectArea("TRB")
_cArqInd := Criatrab("",.F.)
IndRegua("TRB",_cArqInd,"TB_VALBRUT",,,"Selecionando Registros..")
dbGoBottom ()

For _nCont := 1 to TRB -> (LastRec ())
  RecLock ("TRB", .f.)
  TRB -> TB_RANKING := _nCont
  TRB -> TB_PERC    := (TRB->TB_VALBRUT / _RnkTot ) * 100
  TRB -> (dbSkip (-1))
  MsUnlock ()
Next                          

_cArqInd := Criatrab("",.F.)
IndRegua("TRB",_cArqInd,"TB_RANKING",,,"Selecionando Registros...")

//
// Imprimindo Relatorio
//***********************

If li>= 58
    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
Endif
  
DbSelectArea("TRB")
dbGoTop ()
While ! eof ()
  
  If li>=58
    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
  Endif
  
  If  MV_PAR03 == 1 // REAIS
  
	  @ li,000 psay Substr(Alltrim(TRB->TB_NOME),1,20)  
	  @ li,020 psay TRB->TB_VAL01 picture "@E 999,999,999.99"       
	  @ li,035 psay TRB->TB_VAL02 picture "@E 999,999,999.99"  //040
	  @ li,050 psay TRB->TB_VAL03 picture "@E 999,999,999.99"  //055
	  @ li,065 psay TRB->TB_VAL04 picture "@E 999,999,999.99"  //070
	  @ li,080 psay TRB->TB_VAL05 picture "@E 999,999,999.99"  //085
	  @ li,095 psay TRB->TB_VAL06 picture "@E 999,999,999.99"  //100
	  @ li,110 psay TRB->TB_VAL07 picture "@E 999,999,999.99"  //115
	  @ li,125 psay TRB->TB_VAL08 picture "@E 999,999,999.99"  //135
	  @ li,140 psay TRB->TB_VAL09 picture "@E 999,999,999.99"  //150
	  @ li,155 psay TRB->TB_VAL10 picture "@E 999,999,999.99"  //165
	  @ li,170 psay TRB->TB_VAL11 picture "@E 999,999,999.99"  //180
	  @ li,185 psay TRB->TB_VAL12 picture "@E 999,999,999.99"  //195
	  @ li,200 psay TRB->TB_VALTT picture "@E 999,999,999.99"  //211	  // 207
	  @ li,215 psay TRB->TB_PERC  picture "@E 999.99"          //211	  // 207
//	  @ li,214 psay "%"                                        //218//214

  Else // KVALOR
	  @ li,000 psay Substr(Alltrim(TRB->TB_NOME),1,20)  
	  @ li,020 psay TRB->TB_VAL01/1000 picture "@E 999999999"  
	  @ li,035 psay TRB->TB_VAL02/1000 picture "@E 999999999"  //40
	  @ li,050 psay TRB->TB_VAL03/1000 picture "@E 999999999"  //55
	  @ li,065 psay TRB->TB_VAL04/1000 picture "@E 999999999"  //70
	  @ li,080 psay TRB->TB_VAL05/1000 picture "@E 999999999"  //85
	  @ li,095 psay TRB->TB_VAL06/1000 picture "@E 999999999"  //100
	  @ li,110 psay TRB->TB_VAL07/1000 picture "@E 999999999"  //115
	  @ li,125 psay TRB->TB_VAL08/1000 picture "@E 999999999"  //135
	  @ li,140 psay TRB->TB_VAL09/1000 picture "@E 999999999"  //150
	  @ li,155 psay TRB->TB_VAL10/1000 picture "@E 999999999"  //165
	  @ li,170 psay TRB->TB_VAL11/1000 picture "@E 999999999"  //180
	  @ li,185 psay TRB->TB_VAL12/1000 picture "@E 999999999"  //195
	  @ li,200 psay TRB->TB_VALTT/1000 picture "@E 999,999,999.99"  //211	  // 207	  
	  @ li,215 psay TRB->TB_PERC  picture "@E 999.99"          //211
//	  @ li,214 psay "%"                                        //218  

  Endif
  
	  xtMerc   := xtMerc  + TRB->TB_VALBRUT 
	  li := li + 1
	
	  dbSkip ()
	
Enddo

li := li + 1
@ li, 01 psay "------------------------------------------------------------------------------------------------------------------------------------"
li := li + 1
@ li, 25 psay "TOTAL.........................................: "

If MV_PAR03 == 1
   @ li, 75 psay xtMerc     picture "@E 999,999,999,999.99"
Else
   @ li, 75 psay xtMerc/1000     picture "@E 999999999999"
Endif
                                                
If ( Li != 80 )
	roda(cbcont,cbtxt,tamanho)
EndIf

Set Device To Screen

dbSelectArea("SE1")
dbCloseArea()


If ( aReturn[5]==1 )
	Set Print to
	dbCommitall()
	ourspool(wnrel)
EndIf
MS_Flush()

dbCloseArea("TRB")
DbCloseArea(cNomArq) 

//FRename("GEFM43.DBF", cNomArq1)   
//FRename("GEFM43"+OrdBagExt(), cNomInd1)  

FRename(cNomArq+".DBF", cNomArq1)   
FRename(_cArqInd+OrdBagExt(), cNomInd1)  

Ferase(cNomArq+".DBF")                                      
Ferase(_cArqInd+OrdBagExt())

Return NIL