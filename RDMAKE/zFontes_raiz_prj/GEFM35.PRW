#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 18/10/04

User Function GEFM35()        // incluido pelo assistente de conversao do AP6 IDE em 18/10/04

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,WNREL,ALINHA,ACAMPOS,NLASTKEY,TITULO")
SetPrvt("CCANCEL,CPERG,ATOTCF,AORD,CBCONT,CBTXT")
SetPrvt("CABEC1,CABEC2,LI,M_PAG,ATAM,CNOMARQ")
SetPrvt("_CARQIND,CARQ1,CCHAVEIND,CARQ2,_CTEMPVEND,_NLITROS")
SetPrvt("_NDESCONTOO,_NVALMERC,_CNOMVEND,_CCF,_NDESCONTO,_NCONT")
SetPrvt("TB_RANKING,_NVENDLIQ,_NPERCDEV,XTMERC,XTVALDEV,XTVENDLIQ")
SetPrvt("XTQTLT,XTPERCVEN,VALMERD,_CVENDDEV,_NVALMERD,TB_VALDEV")
SetPrvt("_NLITROSDEV,_NLITDEV,_NLITROSANT,TB_QTLT,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GEFM35   ³ Autor ³ Saulo Muniz           ³ Data ³ 19.10.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Faturamento por RANKING                       ³±±
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
tamanho  :="M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog :="GEFM35"
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
//aOrd:={"Por Cliente","Por Produto","Por Data"}

SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,tamanho)
//titulo  :="Relatorio de Ranking de Clientes "
titulo  :="Relatorio de Ranking do Periodo: "+dtoc(mv_par01)+" ate  "+dtoc(mv_par02)

If nLastKey == 27
	 Set Filter To
	 Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	 Set Filter To
	 Return
Endif

RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP6 IDE em 18/10/04 ==> RptStatus({|| Execute(RptDetail) })
Return NIL

Static Function RptDetail()

cbcont := 0
cbtxt  := space(10)
cabec1 := "  CODIGO LOJA   NOME                                                  VALOR                        RANKING      "
cabec2 := " "
li     := 155 //80
m_pag  := 1

//cabec2   :="  CODIGO  NOME DO VENDEDOR                            VENDAS        DEVOLUCOES      LIQUIDAS       LIQUIDA      DEVOLUCAO    RANKING"

cNomArq1    := "GEFM35.DBF"                 // Arquivo
cNomInd1    := "GEFM35"+OrdBagExt()         // Indice

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
AADD(aCampos, {"TB_MES01", "C", 1, 0})
AADD(aCampos, {"TB_MES02", "C", 1, 0})
AADD(aCampos, {"TB_MES03", "C", 1, 0})
AADD(aCampos, {"TB_MES04", "C", 1, 0})
AADD(aCampos, {"TB_MES05", "C", 1, 0})
AADD(aCampos, {"TB_MES06", "C", 1, 0})
AADD(aCampos, {"TB_MES07", "C", 1, 0})
AADD(aCampos, {"TB_MES08", "C", 1, 0})
AADD(aCampos, {"TB_MES09", "C", 1, 0})
AADD(aCampos, {"TB_MES10", "C", 1, 0})
AADD(aCampos, {"TB_MES11", "C", 1, 0})
AADD(aCampos, {"TB_MES12", "C", 1, 0})

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

While !Eof() //.And. SE1->E1_EMISSAO >= mv_par01 .And. SE1->E1_EMISSAO <= mv_par02
    
    IncRegua ()

	If SE1->E1_EMISSAO <= mv_par01 .And. SE1->E1_EMISSAO >= mv_par02
       dbSelectArea("SE1")
	   dbSkip()
	   Loop
	EndIf

	//If SE1->E1_FATURA  == "NOTFAT"  //DESCONSIDERA FATURAS, APENAS OS TITULOS GERADOS
    //   dbSelectArea("SE1")
	//   dbSkip()
	//   Loop
	//EndIf
	
	If SE1->E1_TIPO == "FAT"  //DESCONSIDERA FATURAS, APENAS OS TITULOS GERADOS
       dbSelectArea("SE1")
	   dbSkip()
	   Loop
	EndIf
    
    xCliente := SE1->E1_CLIENTE
       
	DbSelectArea("TRB")
	If !dbSeek(xCliente)
      _nVal := SE1->E1_VALOR     
      RecLock ("TRB",.T.)
	  Replace TB_CODIGO     with SE1->E1_CLIENTE
	  Replace TB_LOJA       with SE1->E1_LOJA
	  Replace TB_NOME       with SE1->E1_NOMCLI
	  Replace TB_VALBRUT    with _nVal
	  //Replace "TB_MES"+cMes with "X"  
	  Msunlock ()
    Else
      _nVal :=(TRB->TB_VALBRUT+SE1->E1_VALOR)
      RecLock ("TRB",.F.)
	  Replace TB_VALBRUT    with _nVal
	  //Replace "TB_MES"+cMes with "X"  
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

  @ li, 01 psay TRB->TB_CODIGO
  @ li, 10 psay TRB->TB_LOJA 
  @ li, 15 psay TRB->TB_NOME
  @ li, 61 psay TRB->TB_VALBRUT picture "@E 999,999,999,999,999.99"
  //@ li, 76 psay TRB->TB_EMIS   
  //@ li, 120 psay "%"
  @ li, 100 psay TRB->TB_RANKING // picture "99999999999999999"

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

FRename("GEFM35.DBF", cNomArq)   
FRename("GEFM35"+OrdBagExt(), cNomInd1)  


Return NIL