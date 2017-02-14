#include "rwmake.ch"    
#include "topconn.ch"
#INCLUDE "tbiconn.ch"

/**********************************************************************
* Programa.......: GEFM56A()                                          *
* Autor..........: Marcelo Aguiar Pimentel                            *
* Data...........: 30/03/07                                           *
* Descricao......: Importação de Nota Fiscal - CTRC                   *
*                                                                     *
***********************************************************************
* Modificado por.:                                                    *
* Data...........:                                                    *
* Motivo.........:                                                    *
*                                                                     *
**********************************************************************/

User Function GEFM56S()
	u_gefm56x(.t.)
Return

User Function GEFM56X(lAutoI)
Private lAutoImp:=iif(lAutoI = Nil,.f.,lAutoI)

If !lAutoImp
	If MsgYesNo("Esta rotina irá fazer a Importação de Nota Fiscal - CTRC para o Microsiga."+chr(10)+"Deseja continuar?","Atenção!")
//		Processa({|| RunImp() },"Importando notas ADHOC ...")      
		Processa({|| RunImpDTC() },"Importando notas TMS ...")			
	EndIf
Else
	RPCSetType(3) // Nao consome o numero de licencas
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FIN" TABLES "SZ5","SZM"
//	Processa({|| RunImp() },"Importando notas ADHOC ...")
	Processa({|| RunImpDTC() },"Importando notas TMS ...")	
	RESET ENVIRONMENT
EndIf
Return
/*****************************************************************************
* Funcao....: RunImp()                                                       *
* Autor.....: Marcelo Aguiar Pimentel                                        *
* Data......: 30/03/07                                                       *
* Descricao.: Importa Nota Fiscal CTRC                                       *
*                                                                            *
*****************************************************************************/
Static Function RunImp()
dbSelectArea("SZ5")
dbSetOrder(1)

dbSelectArea("SZM")
dbSetOrder(1)

cQry:="SELECT * FROM NF_CTRC_ADHOC"
cQry+=" WHERE FLGIMPORTADO = 'N'"
//Essas duas linhas foram utilizadas somente na base teste.
//cQry+="   AND LNGCTRC >='175660'"
//cQry+="ORDER BY LNGCTRC"

TcQuery cQry Alias "TRB" New

ProcRegua(RecCount()) // Numero de registros a processar

CONOUT("Inicio de importação das NFs do ADHOC.")
    	
While !Eof()
	dbSelectArea("SZM")
	dbSeek(ALLTRIM(STR(TRB->LNGPOLOCOLETA)))
	_cFilial:=SZM->ZM_FILIAL
	dbSelectArea("TRB")	    	
//  	CONOUT("Filial : " + _cFilial  + "  Nota : "+alltrim(str(TRB->LNGCTRC)))
   	IncProc("Filial : " + _cFilial  + "  Nota : "+alltrim(str(TRB->LNGCTRC)))
   	
	xDoc	 	:= alltrim(STRZERO(TRB->LNGCTRC,6))
	cDoc     	:= PadR(IIf(Len(xDoc) < 6,"0"+xDoc,xDoc),09)
	cSerie   	:= SZM->ZM_SERCTRC // Space(3) - Por: J Ricardo - Em: 08/10/2007 - Passou a tratar série
    xTipoCgc 	:= ""
    // cSerNf   	:= ""
    cSerNf   	:= AllTrim(TRB->DTC_SERNFC)    // Por: Ricardo - Em: 16/03/2012    
    cNumNf   	:=	alltrim(str(TRB->LNGNF))
    dDataNf  	:= stod(TRB->DTAEMISSAO)
    nValnf   	:= TRB->NUMTOTALNF
    cCgcRem  	:= TRB->NUMCGCREMETENTE
    cCgcDest 	:= TRB->NUMCGCDESTINATARIO
    cCgcConsig	:= TRB->NUMCGCCONSIGNA
    cTomador 	:= TRB->INTFRETE
    cCgcTomador := ""
    nPeso		:= TRB->NUMPESO
    // R/D/C
    Do Case 
    	Case Alltrim(cTomador) == "R" 
        	xTipoCgc  := cCgcDest
			cCgcTomador := cCgcRem
	  	Case Alltrim(cTomador) == "D" 
    		xTipoCgc  := cCgcRem	    
			cCgcTomador := cCgcDest	
	  	Case Alltrim(cTomador) == "C" 
    		xTipoCgc  := cCgcDest	       	
			cCgcTomador := cCgcConsig
	  	OtherWise
    		xTipoCgc  := ""
	EndCase
        
	dbSelectArea("SZ5")
	If !dbSeek(_cFilial + cDoc + cNumNf )
    	dbSelectArea("SZ5")
    	Reclock("SZ5",.T.)
     		SZ5->Z5_FILIAL  := _cFilial
            SZ5->Z5_CGCREM  := xTipoCgc
        	SZ5->Z5_SERIE   := cSerNf
    		SZ5->Z5_NUM     := cNumNf
    		SZ5->Z5_VALOR   := nValnf
    		SZ5->Z5_DTNOTA  := dDataNf
    		SZ5->Z5_CTRC    := cDoc
    		SZ5->Z5_SERCTR  := cSerie	
    		SZ5->Z5_TOMADOR	:= cTomador
    		SZ5->Z5_CGCTOMA := 	cCgcTomador
    		SZ5->Z5_PESO	:= nPeso
    	Msunlock()        
	Endif
        
	DbselectArea("TRB")
	Dbskip()

EndDo
CONOUT("Atualizando flag de importação das NFs do ADHOC.")
cQry:="UPDATE NF_CTRC_ADHOC "
cQry+="   SET FLGIMPORTADO = 'S'"
cQry+=" WHERE FLGIMPORTADO = 'N'"
TcSQLExec(cQry)
TcSQLExec("COMMIT")
CONOUT("Final de importação das NFs do ADHOC.")
dbSelectArea("TRB")
dbCloseArea()
Return

/*****************************************************************************
* Funcao....: RunImpDT6()                                                    *
* Autor.....: J Ricardo Guimarães                                            *
* Data......: 01/02/2010                                                     *
* Descricao.: Importa Nota Fiscal CTRC do módulo TMS do Protheus             *
*                                                                            *
*****************************************************************************/
Static Function RunImpDTC()
dbSelectArea("SZ5")
dbSetOrder(1)

cQry:="SELECT * FROM " + RetSqlName("DTC") + " DTC "
cQry+=" WHERE DTC_FLGSIN    <> 'S'"
cQry+="   AND DTC_DOC <> '' "
cQry+="   AND DTC.D_E_L_E_T_ = '' "
cQry+="ORDER BY DTC_DOC"

TcQuery cQry Alias "TRB" New

ProcRegua(0) // Numero de registros a processar

CONOUT("Inicio de importação das NFs do TMS.")

dbSelectArea("TRB") ; dbGoTop()
    	
While !Eof()
	
	_cFilial:=TRB->DTC_FILORI
   	IncProc("Filial : " + _cFilial  + "  CTRC : " + TRB->DTC_DOC)
   	
	cDoc     	:= TRB->DTC_DOC
	cSerie   	:= TRB->DTC_SERIE
    xTipoCgc 	:= ""
    // cSerNf   	:= ""
    cSerNf   	:= Alltrim(TRB->DTC_SERNFC)  // Informado após Go Live dos CTRC do TLA no TMS - Por: Ricardo
    cNumNf   	:=	alltrim(TRB->DTC_NUMNFC)
    dDataNf  	:= stod(TRB->DTC_EMINFC)
    nValnf   	:= TRB->DTC_VALOR
    cCgcRem  	:= POSICIONE("SA1",1,XFILIAL("SA1")+TRB->DTC_CLIREM+TRB->DTC_LOJREM,"A1_CGC")
    cCgcDest 	:= POSICIONE("SA1",1,XFILIAL("SA1")+TRB->DTC_CLIDES+TRB->DTC_LOJDES,"A1_CGC")
    cCgcConsig	:= POSICIONE("SA1",1,XFILIAL("SA1")+TRB->DTC_CLICON+TRB->DTC_LOJCON,"A1_CGC")
    cTomador 	:= ""
    cCgcTomador := POSICIONE("SA1",1,XFILIAL("SA1")+TRB->DTC_CLIDEV+TRB->DTC_LOJDEV,"A1_CGC")
    nPeso		:= TRB->DTC_PESO
        
	dbSelectArea("SZ5")
	If !dbSeek(_cFilial + cDoc + cNumNf )
    	dbSelectArea("SZ5")
    	Reclock("SZ5",.T.)
     		SZ5->Z5_FILIAL  := _cFilial
            SZ5->Z5_CGCREM  := cCgcRem // xTipoCgc
        	SZ5->Z5_SERIE   := cSerNf
    		SZ5->Z5_NUM     := cNumNf
    		SZ5->Z5_VALOR   := nValnf
    		SZ5->Z5_DTNOTA  := dDataNf
    		SZ5->Z5_CTRC    := cDoc
    		SZ5->Z5_SERCTR  := cSerie	
    		SZ5->Z5_TOMADOR	:= cTomador
    		SZ5->Z5_CGCTOMA := cCgcTomador
    		SZ5->Z5_PESO	:= nPeso
    	Msunlock()        
	Endif

	// Atualizo Flag de importação
	dbSelectArea("DTC") ; dbSetOrder(7)
		
//	CONOUT("Inicio de atualização de flag de importação das NFs do TMS.")
	
	If DTC->(dbSeek(TRB->DTC_FILIAL + TRB->DTC_DOC + TRB->DTC_SERIE + TRB->DTC_FILDOC + TRB->DTC_NUMNFC + TRB->DTC_SERNFC))
		If RecLock("DTC",.F.)
			DTC->DTC_FLGSIN := "S"
			DTC->(MsUnLock())
	    EndIf
	EndIf
		
	DbselectArea("TRB")
	Dbskip()

EndDo

// Atualizo Flag de importação
/*
dbSelectArea("DTC") ; dbSetOrder(7)
	
DbselectArea("TRB")
dbGoTop()
CONOUT("Inicio de atualização de flag de importação das NFs do TMS.")
While !Eof()

	dbSelectArea("DTC")

	If dbSeek(TRB->DTC_FILIAL + TRB->DTC_DOC + TRB->DTC_SERIE + TRB->DTC_FILDOC + TRB->DTC_NUMNFC + TRB->DTC_SERNFC)
		If RecLock("DTC",.F.)
			DTC_FLGSIN = "S"
	    EndIf
	EndIf
	
	DbselectArea("TRB")
	Dbskip()	
End
*/

dbSelectArea("TRB")
dbCloseArea()

ConOut("Fim de Importação de NFs de CTRC")

Return