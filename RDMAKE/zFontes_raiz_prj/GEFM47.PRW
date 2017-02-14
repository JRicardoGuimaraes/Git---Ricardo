#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEFM47   ³ Autor ³ Saulo Muniz           ³ Data ³ 24/07/04  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de importação de ativos                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³  Gefco Logistica do Brasil                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GEFM47()

LOCAL nOpca	   :=	0
LOCAL aSays	   :=	{}
LOCAL aButtons :=	{}

AADD(aSays,"Esta rotina ira fazer a Importação de Ativos ")
AADD(aButtons,{ 1,.T.,{|o| nOpca:= 1, o:oWnd:End() }} )
AADD(aButtons,{ 16,.T.,{|o| nOpca:= 2, o:oWnd:End() }} )
AADD(aButtons,{ 2,.T.,{|o| o:oWnd:End() }} )

FormBatch("Importação de Ativos ",aSays,aButtons,,150,350 ) 

IF nOpcA == 1

	//+--------------------------------------------------------------+
	//¦ Criando Arquivo Temporario pela ordem selecionada            ¦
	//+--------------------------------------------------------------+
	cArqDBF	:= CriaTrab(NIL,.f.)
	aFields := {}
	AADD(aFields,{"BEN_C"    ,"N",06,0})
	AADD(aFields,{"DATAAQ"   ,"D",08,0})
	AADD(aFields,{"DSBEM_C"  ,"C",37,0})
	AADD(aFields,{"BEN_F"    ,"N",07,0})
	AADD(aFields,{"LOCAL_F"  ,"C",08,0})
	AADD(aFields,{"DOC"      ,"C",13,0})
	AADD(aFields,{"FORNEC"   ,"C",28,0})
	AADD(aFields,{"VALOR"    ,"N",13,2})
	AADD(aFields,{"CONTA"    ,"N",08,0})
	AADD(aFields,{"CCUSTO"   ,"C",13,0})
	AADD(aFields,{"DEPREC"   ,"N",12,2})
	AADD(aFields,{"DSBEM_F"  ,"C",69,0})
	AADD(aFields,{"PERC"     ,"N",02,0})
	AADD(aFields,{"BEM"      ,"C",06,0})
	AADD(aFields,{"DEPRECIA" ,"N",08,0})
	AADD(aFields,{"DESPESA"  ,"N",08,0})
	
	DbCreate(cArqDbf,aFields)
	DbUseArea(.T.,,cArqDbf,"SMC",.F.)
	DBSELECTAREA("SMC")
	DBGOTOP()                 

   Append from COTEJADO.DBF //sdf     
   Processa({||Cotejado(nOpcA)},,"Atualizando Cotejados ...")    
Endif	

IF nOpcA == 2

	//+--------------------------------------------------------------+
	//¦ Criando Arquivo Temporario pela ordem selecionada            ¦
	//+--------------------------------------------------------------+
	cArqDBF	:= CriaTrab(NIL,.f.)
	aFields := {}
	AADD(aFields,{"BEM"      ,"N",07,0})
	AADD(aFields,{"CONTA"    ,"N",06,0})
	AADD(aFields,{"CCUSTO"   ,"C",07,0})
	AADD(aFields,{"DSBEM_F"  ,"C",90,0})	
	AADD(aFields,{"DATAQ"    ,"D",08,0})
	AADD(aFields,{"DOC"      ,"C",06,0})
	AADD(aFields,{"FORNEC"   ,"C",27,0})
	AADD(aFields,{"VALOR"    ,"N",18,2})
	AADD(aFields,{"DEPREC"   ,"N",14,2})
	AADD(aFields,{"PERC"     ,"N",02,0})
	AADD(aFields,{"DEPRECIA" ,"N",12,0})
	AADD(aFields,{"DESPESA"  ,"N",08,0})
	
	DbCreate(cArqDbf,aFields)
	DbUseArea(.T.,,cArqDbf,"SMC",.F.)
	DBSELECTAREA("SMC")
	DBGOTOP()                 

   Append from SOBRAS.DBF //sdf     
   Processa({||Cotejado(nOpcA)},,"Atualizando Sobras Contabeis ...")    
   //Processa({||SobraCont(nOpcA)},,"Atualizando Sobras Contabeis ...")
Endif	

Aviso("Atencao !!", "Processamento Efetuado com Sucesso !!", {" Ok "})

Return(.T.)


Static Function Cotejado(nOpcA,arqimp)

Local aCabPV 	:= {}
Local aItemPV	:= {}
Local _aItens	:= {}
Local _nItens   := 1  // ->No. de itens do pedido A
Local nOpc      := 3  // 3 = Inclusão ; 5 = Exclusão
Local xBem      := " "
Local xBemOld   := " "
Local nItem     := 1
Local lMsErroAuto := .F.


dbSelectArea("SMC")         
ProcRegua(RecCount())
Dbgotop()

While !Eof() 

    If nOpcA == 1
	   IncProc("Importando Ativo : "+ OemToAnsi(Substr(Alltrim(SMC->DSBEM_C),1,15)))

    Else
       IncProc("Importando Ativo : "+ OemToAnsi(Substr(Alltrim(SMC->DSBEM_F),1,15)))
    Endif

    xBem := IIF(nOpcA == 1,Alltrim(SMC->BEM),Alltrim(Str(SMC->BEM)))

    If xBemOld == xBem
       nItem++  
    Else
       nItem := 1    
    Endif
    
    //CABEC.
    dbSelectArea("SN1")         
	Reclock("SN1",.T.)
	SN1->N1_FILIAL  := "01"
	SN1->N1_CBASE   := xBem //SMC->BEM
	SN1->N1_ITEM    := Strzero(nItem,4) //"0001"	
	SN1->N1_AQUISIC := IIF(nOpcA == 1,Gravadata(SMC->DATAAQ,.T.,1),Gravadata(SMC->DATAQ,.T.,1))
	SN1->N1_DESCRIC := IIF(nOpcA == 1,OemToAnsi(Alltrim(SMC->DSBEM_C)),OemToAnsi(Alltrim(SMC->DSBEM_F)))
	SN1->N1_QUANTD  := 1	
	SN1->N1_CHAPA   := IIF(nOpcA == 1,Alltrim(Str(SMC->BEN_F)),Alltrim(xBem))
	SN1->N1_LOCAL   := IIF(nOpcA == 1,Alltrim(SMC->LOCAL_F )," ")
	SN1->N1_NSERIE  := "   "
	SN1->N1_NFISCAL := Alltrim(SMC->DOC)
	SN1->N1_PATRIM  := "N"	
	SN1->N1_NOMFOR  := OemToAnsi(Alltrim(SMC->FORNEC))
    SN1->N1_GRUPO   := "0001"
	Msunlock()

    //ITENS
    dbSelectArea("SN3")         
	Reclock("SN3",.T.)	                 
	SN3->N3_FILIAL  := "01"
	SN3->N3_CBASE   := xBem //SMC->BEM
	SN3->N3_ITEM    := Strzero(nItem,4) //"0001"	
	SN3->N3_AQUISIC := IIF(nOpcA == 1,Gravadata(SMC->DATAAQ,.T.,1),Gravadata(SMC->DATAQ,.T.,1))
	SN3->N3_TIPO    := "01"
	SN3->N3_VORIG1  := SMC->VALOR 
	SN3->N3_VORIG3  := IIF(nOpcA == 1,xMoeda(SMC->VALOR,1,3,Gravadata(SMC->DATAAQ,.T.,1)),xMoeda(SMC->VALOR,1,3,Gravadata(SMC->DATAQ,.T.,1))) 
	SN3->N3_CCONTAB := Alltrim(Str(SMC->CONTA))
	SN3->N3_CUSTBEM := Alltrim(SMC->CCUSTO)
    SN3->N3_CCUSTO  := Alltrim(SMC->CCUSTO)
	SN3->N3_TXDEPR1 := SMC->PERC 
	SN3->N3_TXDEPR3 := SMC->PERC 
	SN3->N3_DINDEPR := Ctod("01/07/2005") //dDatabase
	SN3->N3_VRDACM1 := SMC->DEPREC 
    SN3->N3_VRDACM3 := IIF(nOpcA == 1,xMoeda(SMC->DEPREC,1,3,Gravadata(SMC->DATAAQ,.T.,1)),xMoeda(SMC->DEPREC,1,3,Gravadata(SMC->DATAQ,.T.,1))) 
	SN3->N3_HISTOR  := IIF(nOpcA == 1,OemToAnsi(Alltrim(SMC->DSBEM_C)),OemToAnsi(Alltrim(SMC->DSBEM_F)))
    SN3->N3_VRDBAL1 := SMC->DEPREC 
    SN3->N3_VRDBAL3 := IIF(nOpcA == 1,xMoeda(SMC->DEPREC,1,3,Gravadata(SMC->DATAAQ,.T.,1)),xMoeda(SMC->DEPREC,1,3,Gravadata(SMC->DATAQ,.T.,1))) 
    SN3->N3_VRDMES1 := SMC->DEPREC 
    SN3->N3_VRDMES3 := IIF(nOpcA == 1,xMoeda(SMC->DEPREC,1,3,Gravadata(SMC->DATAAQ,.T.,1)),xMoeda(SMC->DEPREC,1,3,Gravadata(SMC->DATAQ,.T.,1))) 
    SN3->N3_SEQ	    := "001"
    SN3->N3_BAIXA   := "0"
    SN3->N3_CDEPREC := Alltrim(STR(SMC->DESPESA))
    SN3->N3_CCDEPR  := Alltrim(STR(SMC->DEPRECIA))
	Msunlock()

    //MOVIMENTAÇÕES DO ATIVO
    dbSelectArea("SN4")         
	Reclock("SN4",.T.)
	SN4->N4_FILIAL  := "01"
	SN4->N4_CBASE   := xBem
	SN4->N4_ITEM    := Strzero(nItem,4) //"0001"	
	SN4->N4_TIPO    := "01"	
	SN4->N4_OCORR   := "05"
	SN4->N4_TIPOCNT := "1"
    SN4->N4_CONTA   := Alltrim(Str(SMC->CONTA))
    SN4->N4_DATA    := IIF(nOpcA == 1,Gravadata(SMC->DATAAQ,.T.,1),Gravadata(SMC->DATAQ,.T.,1))
    SN4->N4_QUANTD  := 1
    SN4->N4_VLROC1  := SMC->VALOR 
    SN4->N4_VLROC3  := IIF(nOpcA == 1,xMoeda(SMC->VALOR,1,3,Gravadata(SMC->DATAAQ,.T.,1)),xMoeda(SMC->VALOR,1,3,Gravadata(SMC->DATAQ,.T.,1))) 
    SN4->N4_NOTA    := Alltrim(SMC->DOC)
    SN4->N4_CCUSTO  := Alltrim(SMC->CCUSTO)
    SN4->N4_SEQ     := "001"    
	Msunlock()

    //ARQUIVO DE SALDOS
    /*
    dbSelectArea("SN5")         
    DbSetOrder(1)
    Dbgotop()
    If Dbseek(xFilial() + Alltrim(Str(SMC->CONTA)) + IIF(nOpcA == 1,Gravadata(SMC->DATAAQ,.T.,1),Gravadata(SMC->DATAQ,.T.,1)) + "1")
		Reclock("SN5",.F.)
		SN5->N5_FILIAL  := "01"
		SN5->N5_CONTA   := Alltrim(Str(SMC->CONTA))
		SN5->N5_DATA    := IIF(nOpcA == 1,Gravadata(SMC->DATAAQ,.T.,1),Gravadata(SMC->DATAQ,.T.,1))
		SN5->N5_TIPO    := "1"	
		SN5->N5_VALOR1  := SMC->VALOR 
		SN5->N5_VALOR3  := IIF(nOpcA == 1,xMoeda(SMC->VALOR,1,3,Gravadata(SMC->DATAAQ,.T.,1)),xMoeda(SMC->VALOR,1,3,Gravadata(SMC->DATAQ,.T.,1))) 
		Msunlock()
	Else
		Reclock("SN5",.T.)
		SN5->N5_FILIAL  := "01"
		SN5->N5_CONTA   := Alltrim(Str(SMC->CONTA))
		SN5->N5_DATA    := IIF(nOpcA == 1,Gravadata(SMC->DATAAQ,.T.,1),Gravadata(SMC->DATAQ,.T.,1))
		SN5->N5_TIPO    := "1"	
		SN5->N5_VALOR1  := SMC->VALOR 
		SN5->N5_VALOR3  := IIF(nOpcA == 1,xMoeda(SMC->VALOR,1,3,Gravadata(SMC->DATAAQ,.T.,1)),xMoeda(SMC->VALOR,1,3,Gravadata(SMC->DATAQ,.T.,1))) 
		Msunlock()	
	Endif
	*/
	   
    xBemOld := xBem
   
dbSelectArea("SMC")         
dbSkip()

EndDo

DbCloseArea("SMC")

Return