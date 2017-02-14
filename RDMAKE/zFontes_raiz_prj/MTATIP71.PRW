#include "rwmake.ch"        
#include "tOPCONN.ch"

*----------------------------------------------------------------------------------*
* Ponto de entrada disparada da rotina MATA940 - SIGAFIS - SINTEGRA                *
* para tratar o registro 71                                                        *
*----------------------------------------------------------------------------------*

User Function MTATIP71(lEnt1,lEnt2,aArray1,aArray2,aArray3,aArray4)    
Local aArea := GetArea()
Local aArray := ParamIxb
Local cCnpjCPf := ""
Local _nTamCpoNF := 0
                                        

/*Private V_Alias,V_Order

V_Alias := Alias()
V_Order := IndexOrd()*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ make data for file temp                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  /*
   dbSelectArea("R71")
   Reclock("R71",.T.)
    R71->A71_CGCTOM  := 
    R71->A71_IETOM   := 
    R71->A71_DTCONH  :=    
    R71->A71_UFTOM   :=    
    R71->A71_MODCON  :=    
    R71->A71_SERCON  :=    
    R71->A71_SUBCON  :=    
    R71->A71_NUMCON  :=    
    R71->A71_UFREM   :=    
    R71->A71_CGCREM  :=    
    R71->A71_IEREM   :=    
    R71->A71_DTNOTA  :=    
    R71->A71_MODNOT  :=    
    R71->A71_SERNOT  :=  
    R71->A71_NUMNOT  :=    
    R71->A71_VALNOT  :=        
   Msunlock()
*/    
// Processar somente CTR                                                                             
// if AllTrim(aArray[2][1][5]) == '5359' .or. AllTrim(aArray[2][1][5]) == '6359'
// Todos CFOP iniciado por 535 ou 635 são de CTRC

//Por: Ricardo - Em: 18/10/2011 - Atendendo solicitação da Célia Souza
//if Left(AllTrim(aArray[2][1][5]),3) <> '535' .and. Left(AllTrim(aArray[2][1][5]),3) <> '635'
if .NOT. Left(AllTrim(aArray[2][1][5]),3) $ ('535|635|593|693|735') 
	RestArea(aArea)
	Return
Endif

// A partir desta data, todas as filiais passaram a emitir CTRC no Protheus(TMS)
/*
If aArray[2][1][10] >= CTOD("01/06/12") // Data de Entrada na SF3
	RestArea(aArea)
	Return
Endif
*/
dbSelectArea("SZ5")    
// DbSetOrder(1)
// DbSetOrder(2) // Por: Ricard - Em: 09/10/2007 - Passar a usar Série na Chave
// Foi retirado devido ter percebido que a interface que alimente a SZ5 não está alimentando o campo Z5_SERCTRC
DbSetOrder(2)  // Por: Ricard - Em: 24/10/2013 - Passar a usar Série na Chave

//Deve ser implentado a série do CTRC também
//If DbSeek(xFilial("SZ5")+SF3->F3_NFISCAL+SF3->F2_SERIE)

_nTamCpoNF := TamSX3("Z5_CTRC")[1]

// If DbSeek(xFilial("SZ5")+PadR(AllTrim(aArray[2][1][1]),06) + AllTrim(aArray[2][1][2])) // COM SERIE
// If DbSeek(xFilial("SZ5")+PadR(AllTrim(aArray[2][1][1]),_nTamCpoNF) )
If DbSeek(xFilial("SZ5")+PadR(AllTrim(aArray[2][1][1]),_nTamCpoNF) + AllTrim(aArray[2][1][2]) )
//    While !Eof() .And. SZ5->Z5_FILIAL+SZ5->Z5_CTRC+ SZ5->Z5_SERCTR == SF3->F3_FILIAL+SF3->F2_NFISCAL+SF3->F2_SERIE
//    While !Eof() .And. SZ5->Z5_FILIAL+SZ5->Z5_CTRC == xFilial("SZ5")+PadR(AllTrim(aArray[2][1][1]),_nTamCpoNF)
    While !Eof() .And. SZ5->Z5_FILIAL+SZ5->Z5_CTRC == xFilial("SZ5")+PadR(AllTrim(aArray[2][1][1]),_nTamCpoNF) .And. SZ5->Z5_SERCTR = AllTrim(aArray[2][1][2])
//    While !Eof() .And. SZ5->Z5_CTRC == AllTrim(aArray[2][1][1]) .And. SZ5->Z5_SERIE == AllTrim(aArray[2][1][2]) .And.;
//    	SZ5->Z5_FILIAL == xFilial("SZ5")
    	
/*		SZ5->Z5_FILIAL  := _cFilial
	    SZ5->Z5_CGCREM  := xTipoCgc
	    SZ5->Z5_SERIE   := cSerNf
	    SZ5->Z5_NUM     := cNumNf
	    SZ5->Z5_VALOR   := nValnf
	    SZ5->Z5_DTNOTA  := dDataNf
	    SZ5->Z5_CTRC    := cDoc
	    SZ5->Z5_SERCTR  := cSerie	*/
	
        DbSelectArea("SA1") 
        DbSetOrder(1)
        DbSeek(xFilial("SA1")+AllTrim(aArray[2][1][3])+AllTrim(aArray[2][1][4]))
        
        //SA1->(dbSeek(xFilial("SA1")+(cAliasDT6)->DT6_CLIDEV+(cAliasDT6)->DT6_LOJDEV))

/*		R70->A70_EMISS	:=	aArrayF3[1][10]
		R70->A70_MODELO	:=	AModNot(aArrayF3[1][7])
		R70->A70_SERIE	:=	Substr(aArrayF3[1][2],1,1)
		R70->A70_SUBSER	:=  Substr(aArrayF3[1][2],2,2)
		R70->A70_NFISC	:=	aArrayF3[1][1]
		R70->A70_CFOP	:=	aArrayF3[1][5]
		R70->A70_SITUAC	:=	"S"						   */
   	
	   	Reclock("R71",.T.)
	   	R71->A71_CGCTOM := SA1->A1_CGC
		R71->A71_IETOM  := aRETDIG(SA1->A1_INSCR,.T.)
		R71->A71_DTCONH := aArray[2][1][10]          
		R71->A71_UFTOM  := SA1->A1_EST
		R71->A71_MODCON := AModNot(aArray[2][1][7])
		R71->A71_SERCON := Substr(aArray[2][1][2],1,1)
		R71->A71_SUBCON := Substr(aArray[2][1][2],2,2)
		R71->A71_NUMCON := aArray[2][1][1]
/*		Do Case 
		   Case (cAliasDT6)->DT6_DEVFRE == "1" //Remetente
			   SA1->(dbSeek(xFilial("SA1")+(cAliasDT6)->DT6_CLIDES+(cAliasDT6)->DT6_LOJDES))
		   Case (cAliasDT6)->DT6_DEVFRE == "2" //Destinatario
			   SA1->(dbSeek(xFilial("SA1")+(cAliasDT6)->DT6_CLIREM+(cAliasDT6)->DT6_LOJREM))
		   Case (cAliasDT6)->DT6_DEVFRE == "3" //Consignatario
			   SA1->(dbSeek(xFilial("SA1")+(cAliasDT6)->DT6_CLICON+(cAliasDT6)->DT6_LOJCON))
		   Case (cAliasDT6)->DT6_DEVFRE == "4" //Despachante
			   SA1->(dbSeek(xFilial("SA1")+(cAliasDT6)->DT6_CLIDPC+(cAliasDT6)->DT6_LOJDPC))							   							   						
		EndCase*/

//		R71->A71_UFREM  := SA1->A1_EST
		R71->A71_CGCREM := SA1->A1_CGC
		R71->A71_IEREM  := aRETDIG(SA1->A1_INSCR,.T.)
		
//		If CGC(strzero(SZ5->Z5_CGCREM,14)) 
        DbSelectArea("SA1")    
        DbSetOrder(3)
//		If CGC(replicate("0",14 - len(AllTrim(SZ5->Z5_CGCREM)))+AllTrim(SZ5->Z5_CGCREM)) 
//			cCnpjCPf := strzero(SZ5->Z5_CGCREM,14)
			cCnpjCPf := replicate("0",14 - len(AllTrim(SZ5->Z5_CGCREM)))+AllTrim(SZ5->Z5_CGCREM)						
			
	        IF DbSeek(xFilial("SA1")+cCnpjCPf)        
				R71->A71_UFREM  := SA1->A1_EST
				R71->A71_CGCREM := SA1->A1_CGC
				R71->A71_IEREM  := aRETDIG(SA1->A1_INSCR,.T.)
			Else
				cCnpjCPf := ""
			EndIF
				
//		EndIF	
//		If CGC(strzero(SZ5->Z5_CGCREM,11)) .And. Empty(cCnpjCPf)                                
//		If CGC(replicate("0",11 - len(AllTrim(SZ5->Z5_CGCREM)))+AllTrim(SZ5->Z5_CGCREM)) .And. Empty(cCnpjCPf)                            
		If Empty(cCnpjCPf)                            
//			cCnpjCPf := CGC(strzero(SZ5->Z5_CGCREM,11))                                                                 
			cCnpjCPf := replicate("0",11 - len(AllTrim(SZ5->Z5_CGCREM)))+AllTrim(SZ5->Z5_CGCREM)									

	        IF DbSeek(xFilial("SA1")+cCnpjCPf)        
				R71->A71_UFREM  := SA1->A1_EST
				R71->A71_CGCREM := SA1->A1_CGC
				R71->A71_IEREM  := aRETDIG(SA1->A1_INSCR,.T.)
			Else
				cCnpjCPf := ""
				R71->A71_UFREM  := "EX"  // TESTE
			EndIF
			
		EndIF
		
/*        DbSelectArea("SA1")    
        DbSetOrder(3)
//        IF DbSeek(xFilial("SA1")+SZ5->Z5_CGCREM)
        IF DbSeek(xFilial("SA1")+cCnpjCPf)        
			R71->A71_UFREM  := SA1->A1_EST
			R71->A71_CGCREM := SA1->A1_CGC
			R71->A71_IEREM  := aRETDIG(SA1->A1_INSCR,.T.)
		ElseIf !Empty(SZ5->Z5_EST) 
			R71->A71_UFREM  := SZ5->Z5_EST
//			R71->A71_CGCREM := SZ5->Z5_CGCREM
			R71->A71_CGCREM := cCnpjCPf
			R71->A71_IEREM  := aRETDIG(SZ5->Z5_INSCR,.T.)
		EndIF                      */
/* 2013-10-24
		If Empty(R71->A71_UFREM)
			If Left(SZ5->Z5_CGCREM,2)<>"MS"
				cQuery := "SELECT * FROM remetente WHERE ltrim(rtrim(str(convert(decimal(15, 0), replace(rtrim(ltrim('"+AllTrim(SZ5->Z5_CGCREM)+"')), ' ', '')), 15, 0))) = cnpj "
				TCQUERY cQuery ALIAS "_REM" NEW
				If !Empty(_REM->CNPJ)
					R71->A71_UFREM  := _REM->UF
					R71->A71_CGCREM := SZ5->Z5_CGCREM
					R71->A71_IEREM  := aRETDIG(IIF(Empty(_REM->INSCRICAO),"ISENTO",_REM->INSCRICAO),.T.)
	    		EndIF
				dbSelectARea("_REM")
				dbCloseArea()
			EndIf	
        EndIF
*/
		If Empty(R71->A71_UFREM) .And. !Empty(SZ5->Z5_EST) 
			R71->A71_UFREM  := SZ5->Z5_EST
			R71->A71_CGCREM := SZ5->Z5_CGCREM
			R71->A71_IEREM  := aRETDIG(SZ5->Z5_INSCR,.T.)
        EndIF

/*
		If Empty(R71->A71_UFREM)
	        DbSelectArea("SA1")         
	        DbSetOrder(1)
	        DbSeek(xFilial("SA1")+AllTrim(aArray[2][1][3])+AllTrim(aArray[2][1][4]))
			cQry:="SELECT ZM_ADFIL "
			cQry+="  FROM "+RetSqlName("SZM")
			cQry+=" WHERE ZM_FILIAL = '"+SZ5->Z5_FILIAL+"'"
			cQry+="   AND D_E_L_E_T_ <> '*'"
			TcQuery cQry Alias "TZM" New
				
			cFilAd:=TZM->ZM_ADFIL
				
			dbCloseArea()				
			cQuery:= "SELECT NUMCGCREMETENTE "
			cQuery+= "  FROM NF_CTRC_ADHOC "
			cQuery+= " WHERE LNGPOLOCOLETA = '" + cFilAd + "' "
			cQuery+="    AND LNGNF =   " + alltrim(str(val(SZ5->Z5_NUM)))
			cQuery+= "   AND LNGCTRC = " + alltrim(str(val(SZ5->Z5_CTRC)))				
			TcQuery cQuery Alias "CTRC_ADHOC" New
			cCgcRem:=""
			If !Eof()
				cCgcRem:=CTRC_ADHOC->NUMCGCREMETENTE

				cQuery := "SELECT * "
				cQuery += "  FROM remetente "
				cQuery += " WHERE ltrim(rtrim(str(convert(decimal(15, 0), replace(rtrim(ltrim('"+AllTrim(cCgcRem)+"')), ' ', '')), 15, 0))) = cnpj "
				TCQUERY cQuery ALIAS "_REM" NEW
				If !Empty(_REM->CNPJ)
					R71->A71_UFREM  := _REM->UF
					R71->A71_CGCREM := _REM->CNPJ
					R71->A71_IEREM  := aRETDIG(IIF(Empty(_REM->INSCRICAO),"ISENTO",_REM->INSCRICAO),.T.)
				EndIf				
				dbSelectARea("_REM")
				dbCloseArea()
					
			Else
				R71->A71_UFREM  := SA1->A1_EST
				R71->A71_CGCREM := SA1->A1_CGC
				R71->A71_IEREM  := aRETDIG(SA1->A1_INSCR,.T.)
							
	    	EndIF
			dbSelectARea("CTRC_ADHOC")
			dbCloseArea()
			
        EndIF
*/
		If Empty(SZ5->Z5_DTNOTA)
			R71->A71_DTNOTA := aArray[2][1][10] 				
		Else
			R71->A71_DTNOTA := SZ5->Z5_DTNOTA		
		EndIF
		R71->A71_MODNOT := "01"
//		R71->A71_SERNOT := DTC->DTC_SERNFC
		R71->A71_NUMNOT := SZ5->Z5_NUM
		R71->A71_VALNOT := SZ5->Z5_VALOR
		
	   	R71->(MsUnLock())
		
		DbSelectArea("SZ5")
		DbSkip()
	End

EndIF

/*DbSelectArea(V_Alias)
DbSetOrder(V_Order)*/
RestArea(aArea)

Return