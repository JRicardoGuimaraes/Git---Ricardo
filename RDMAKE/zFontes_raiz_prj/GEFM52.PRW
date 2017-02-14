#include "rwmake.ch"      

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GEFM52   ³ Autor ³ Saulo Muniz           ³ Data ³ 18.01.05 ³±±
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
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GEFM52()    

cString  :="SE1"
cDesc1   := OemToAnsi("Este programa tem como objetivo, demonstrar o")
cDesc2   := OemToAnsi("Faturamento das Vendas")
cDesc3   := ""
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog :="GEFM52"
wnrel    :=nomeprog
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
Store 0 to xVlrMes1,xVlrMes2,xVlrMes3,xVlrMes4,xVlrMes5,xVlrMes6,xVlrMes7,xVlrMes8,xVlrMes9,xVlrMes10,xVlrMes11,xVlrMes12     
xCustoNovo := ""
aTotCF := {}

SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,tamanho)

titulo  :="Relatorio Faturamento Mensal -  " 

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
cabec1 := " NOME                         C.CUSTO ANTIGO            C.CUSTO NOVO      TITULO (  CHAVE  )"
cabec2 := " "
li     := 80
m_pag  := 1
cNomArq1    := "GEFM52.DBF"                 // Arquivo
cNomInd1    := "GEFM52"+OrdBagExt()         // Indice

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
aTam:=TamSX3("E1_CCONT")
AADD(aCampos, {"TB_CCONT", "C", aTam[1], aTam[2]})
AADD(aCampos, {"TB_CCNEW", "C", 10, 0})
AADD(aCampos, {"TB_RANKING", "N", 17, 0})
AADD(aCampos, {"TB_CHAVE", "C", 25, 0})
AADD(aCampos, {"TB_PERC ", "N",  5, 2})

cNomArq := CriaTrab (aCampos, .T.)
dbUseArea (.T., , cNomArq, "TRB", .T. , .F.)
_cArqInd := Criatrab("",.F.)
IndRegua("TRB",_cArqInd,"TB_CODIGO",,,"Selecionando Registros.")
dbGoTop ()

/*
dbselectarea("SE1")
DbSetOrder(21)  // EMISSAO+CLIENTE+LOJA
dbGoTop ()
SetRegua(SE1->(LastRec()))
DbSeek(MV_PAR01,.T.)
xCliente  := SE1->E1_CLIENTE            
*/

dbselectarea("SE1")
DbSetOrder(21) 
dbGoTop()
//DbSeek(xFilial())
SetRegua(SE1->(LastRec()))
DbSeek(MV_PAR01,.T.)
//xCliente  := SE1->E1_CLIENTE            


While !Eof() 
    
    IncRegua()
        
	If SE1->E1_EMISSAO <= mv_par01 .And. SE1->E1_EMISSAO >= mv_par02
       dbSelectArea("SE1")
	   dbSkip()
	   Loop
	EndIf

	If SE1->E1_PREFIXO == "FAT"  // DESCONSIDERA FATURAS, APENAS OS TITULOS GERADOS
       dbSelectArea("SE1")
	   dbSkip()
	   Loop
	EndIf

	If SE1->E1_SALDO = 0  // BAIXADOS
       dbSelectArea("SE1")
	   dbSkip()
	   Loop
	EndIf
      
    If Empty(SE1->E1_CCONT) .Or. Len(Alltrim(SE1->E1_CCONT)) > 7    // Centro de custo vazio 
       dbSelectArea("SE1")
       dbSkip()
       Loop              
    Endif       

	DbSelectArea("SZ3")    
    DbSetOrder(1)  // 	Filial + C.custo Antigo
    DbGotop()
    If Dbseek(xFilial("SZ3") + SE1->E1_CCONT )    
       xCustoNovo := SZ3->Z3_CUSTO    
    Else
       xCustoNovo := "N"        
    Endif
    
    dbSelectArea("SE1")
    xChave := SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO
    xCliente := SE1->E1_CLIENTE
       
	DbSelectArea("TRB")
    _nVal := SE1->E1_VALOR     
    RecLock ("TRB",.T.)
    Replace TB_CODIGO     with SE1->E1_CLIENTE
    Replace TB_LOJA       with SE1->E1_LOJA
    Replace TB_NOME       with UPPER(SE1->E1_NOMCLI)
    Replace TB_VALBRUT    with _nVal
    Replace TB_CCONT      with SE1->E1_CCONT
    Replace TB_CCNEW      with xCustoNovo
    Replace TB_CHAVE      with xChave
    Msunlock ()

    dbSelectArea("SE1")
    RecLock ("SE1",.F.)	
     Replace SE1->E1_OBS   with "UPDATE "+Alltrim(SE1->E1_CCONT)
     Replace SE1->E1_CCONT with xCustoNovo
    Msunlock()			   
  
    dbSelectArea("SE1")	    
	dbskip()	
   
       
EndDo

//
// Imprimindo Relatorio
//***********************

If li>= 58
    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
Endif
  
DbSelectArea("TRB")
dbGoTop()
While !eof()
  
  If li>=58
    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
  Endif
   
	  @ li,001 psay Substr(Alltrim(TRB->TB_NOME),1,20)  	  
	  @ li,030 psay TB_CCONT
	  @ li,050 psay xCustoNovo
	  @ li,065 psay " Titulo -> "
	  @ li,080 psay xChave
  
	  li := li + 1
	
	  dbSkip ()
	
Enddo
                                               
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

dbCloseArea("TRB")
DbCloseArea(cNomArq) 

FRename(cNomArq+".DBF", cNomArq1)   
FRename(_cArqInd+OrdBagExt(), cNomInd1)  

Ferase(cNomArq+".DBF")                                      
Ferase(_cArqInd+OrdBagExt())

Return NIL