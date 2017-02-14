#include "rwmake.ch"      

User Function GEFM44()    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GEFM44   ³ Autor ³ Saulo Muniz           ³ Data ³ 29.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Faturamento por RANKING - REGULAR             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Utilizacao³ Especifico para GEFCO                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   .  .   ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

cString  :="SE1"
cDesc1   := OemToAnsi("Este programa tem como objetivo, demonstrar o")
cDesc2   := OemToAnsi("Faturamento das Vendas")
cDesc3   := ""
tamanho  := "G"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "GEFM44"
wnrel    :=nomeprog
aLinha   := { }
aCampos  := { }
nLastKey := 0
titulo   :="Relatorio de Faturamento por periodo "
cCancel  := "***** CANCELADO PELO OPERADOR *****"
cPerg    :="GEFM35"
Pergunte(CPERG,.F.)

Store 0 to xMerc,xIcmr,xDesc,xValb,xtMerc,xtQTLT,xtValDev,xtVendLiq,xtIcmr,xtDesc,xtValb,xTliq
Store 0 to xdMerc,xdIcmr,xdDesc,xdValb,xtdMerc,xtdIcmr,xtdDesc,xtdValb,XTtliq
Store 0 to xLitros,xdLitros,xTlitros
aTotCF := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametro                         ³
//³ mv_par01              Data de                               ³
//³ mv_par02              Ate                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,tamanho)
titulo  :="Relatorio Faturamento Mensal Regular : "+dtoc(mv_par01)+" ate  "+dtoc(mv_par02)

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

cbcont := 0
cbtxt  := space(10)
cabec1 := "NOME                         JAN      FEV      MAR      ABR      MAI      JUN      JUL      AGO      SET      OUT      NOV      DEZ "
cabec2 := " "
         //1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//cabec2 := " "     10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160
li     := 155 //80
m_pag  := 1

cNomArq1    := "GEFM44.DBF"                 // Arquivo
cNomInd1    := "GEFM44"+OrdBagExt()         // Indice

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


cNomArq := CriaTrab (aCampos, .T.)
dbUseArea (.T., , cNomArq, "TRB", .T. , .F.)
_cArqInd := Criatrab("",.F.)
IndRegua("TRB",_cArqInd,"TB_CODIGO",,,"Selecionando Registros.")
dbGoTop ()

dbselectarea ("SE1")
DbSetOrder(21)  // EMISSAO+CLIENTE+LOJA
dbGoTop ()
SetRegua(SE1->(LastRec()))
DbSeek(MV_PAR01,.T.)

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

    xCliente := SE1->E1_CLIENTE            

While !Eof() 
    
    IncRegua()
    
	If SE1->E1_EMISSAO <= mv_par01 .And. SE1->E1_EMISSAO >= mv_par02
       dbSelectArea("SE1")
	   dbSkip()
	   Loop
	EndIf
    //
	If SE1->E1_TIPO == "FAT"  // DESCONSIDERA FATURAS, APENAS OS TITULOS GERADOS
       dbSelectArea("SE1")
	   dbSkip()
	   Loop
	EndIf
    //
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
        xCliente := SE1->E1_CLIENTE	

	Endif
	//
	Do Case  // APENAS FATURAMENTO REGULAR

	   Case Month(SE1->E1_EMISSAO) == 1
            xVlrMes1 := SE1->E1_VALOR
            xQtdMes1 := xQtdMes1 + 1
            
	   Case Month(SE1->E1_EMISSAO) == 2
            xVlrMes2 := SE1->E1_VALOR
            xQtdMes2 := xQtdMes2 + 1
            
	   Case Month(SE1->E1_EMISSAO) == 3
            xVlrMes3 := SE1->E1_VALOR  
            xQtdMes3 := xQtdMes3 + 1            
            
	   Case Month(SE1->E1_EMISSAO) == 4
			xVlrMes4 :=	SE1->E1_VALOR			 
            xQtdMes4 := xQtdMes4 + 1            
       
       Case Month(SE1->E1_EMISSAO) == 5
            xVlrMes5 := SE1->E1_VALOR
            xQtdMes5 := xQtdMes5 + 1            
            
	   Case Month(SE1->E1_EMISSAO) == 6
            xVlrMes6 := SE1->E1_VALOR
            xQtdMes6 := xQtdMes6 + 1            
            
	   Case Month(SE1->E1_EMISSAO) == 7
            xVlrMes7 := SE1->E1_VALOR
            xQtdMes7 := xQtdMes7 + 1            
            
	   Case Month(SE1->E1_EMISSAO) == 8
			xVlrMes8 :=	SE1->E1_VALOR			 
            xQtdMes8 := xQtdMes8 + 1            
       
       Case Month(SE1->E1_EMISSAO) == 9
            xVlrMes9 := SE1->E1_VALOR
            xQtdMes9 := xQtdMes9 + 1                        
            
	   Case Month(SE1->E1_EMISSAO) == 10
            xVlrMes10 := SE1->E1_VALOR
            xQtdMes10 := xQtdMes10 + 1            
            
	   Case Month(SE1->E1_EMISSAO) == 11
            xVlrMes11 := SE1->E1_VALOR
            xQtdMes11 := xQtdMes11 + 1            
                        
	   Case Month(SE1->E1_EMISSAO) == 12
			xVlrMes12 := SE1->E1_VALOR				 					   			   
            xQtdMes12 := xQtdMes12 + 1            
       //Otherwise
	
	EndCase                
       
    
    xCliente := SE1->E1_CLIENTE
       
	DbSelectArea("TRB")
	If !dbSeek(xCliente)
      _nVal := SE1->E1_VALOR     
      RecLock ("TRB",.T.)
	  Replace TB_CODIGO     with SE1->E1_CLIENTE
	  Replace TB_LOJA       with SE1->E1_LOJA
	  Replace TB_NOME       with SE1->E1_NOMCLI
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
	  Msunlock ()
    EndIf

    dbSelectArea("SE1")
	dbskip()	
        
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
  TRB -> (dbSkip (-1))
  MsUnlock ()
Next

_cArqInd := Criatrab("",.F.)
IndRegua("TRB",_cArqInd,"TB_RANKING",,,"Selecionando Registros...")
//IndRegua("TRB",_cArqInd,"TB_CODIGO",,,"Selecionando Registros...")
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

//  @ li, 01 psay TRB->TB_CODIGO
//  @ li, 08 psay TRB->TB_LOJA 
//  @ li, 40 psay TRB->TB_VALBRUT picture "@E 999,999,999,999.99"
/*
  @ li,026 psay TRB->TB_MES01 picture "@E 99999"
  @ li,033 psay TRB->TB_MES02 picture "@E 99999"
  @ li,038 psay TRB->TB_MES03 picture "@E 99999"
  @ li,043 psay TRB->TB_MES04 picture "@E 99999"
  @ li,050 psay TRB->TB_MES05 picture "@E 99999"
  @ li,057 psay TRB->TB_MES06 picture "@E 99999"
  @ li,064 psay TRB->TB_MES07 picture "@E 99999"
  @ li,071 psay TRB->TB_MES08 picture "@E 99999"
  @ li,078 psay TRB->TB_MES09 picture "@E 99999"
  @ li,085 psay TRB->TB_MES10 picture "@E 99999"
  @ li,092 psay TRB->TB_MES11 picture "@E 99999"
  @ li,099 psay TRB->TB_MES12 picture "@E 99999"
*/

  @ li,001 psay TRB->TB_NOME
  @ li,025 psay TRB->TB_VAL01 picture "@E 999,999.99"
  @ li,035 psay TRB->TB_VAL02 picture "@E 999,999.99"
  @ li,045 psay TRB->TB_VAL03 picture "@E 999,999.99"
  @ li,055 psay TRB->TB_VAL04 picture "@E 999,999.99"
  @ li,065 psay TRB->TB_VAL05 picture "@E 999,999.99"
  @ li,075 psay TRB->TB_VAL06 picture "@E 999,999.99"
  @ li,085 psay TRB->TB_VAL07 picture "@E 999,999.99"
  @ li,095 psay TRB->TB_VAL08 picture "@E 999,999.99"
  @ li,105 psay TRB->TB_VAL09 picture "@E 999,999.99"
  @ li,115 psay TRB->TB_VAL10 picture "@E 999,999.99"
//  @ li,110 psay TRB->TB_VAL11 picture "@E 999,999.99"
//  @ li,118 psay TRB->TB_VAL12 picture "@E 999,999.99"

//  @ li,106 psay TRB->TB_VAL01 picture "@E 9,999,999.99"
//  @ li,090 psay TRB->TB_RANKING  // picture "99999999999999999"

  xtMerc    := xtMerc + TRB->TB_VALBRUT
  
  dbSkip ()

  li := li+1
  
Enddo

li := li + 2
@ li, 01 psay "------------------------------------------------------------------------------------------------------------------------------------"
li := li + 1
@ li, 02 psay "TOTAL.........................................: "
@ li, 51 psay xtMerc     picture "@E 999,999,999,999.99"
                                                
If ( Li != 80 )
	roda(cbcont,cbtxt,tamanho)
EndIf

Set Device To Screen
If ( aReturn[5]==1 )
	Set Print to
	dbCommitall()
	ourspool(wnrel)
EndIf
MS_Flush()

dbCloseArea ("TRB")

//If file (cNomArq)
//  fErase (cNomArq)
//EndIf

FRename("GEFM44.DBF", cNomArq)   
FRename("GEFM44"+OrdBagExt(),cNomInd1)  


Return NIL