#include "rwmake.ch"
#Include "PROTHEUS.CH"                                 
#Include "TopConn.CH"

/**********************************************************************
* Programa.......: GEFMNFE_PR()                                       *
* Autor..........: J Ricardo Guimarães                                *
* Data...........: 15/09/10                                           *
* Descricao......: Rotina para informar NF-e de Porto Real            *
*                                                                     *
***********************************************************************
* Modificado por.:                                                    *
* Data...........:                                                    *
* Motivo.........:                                                    *
*                                                                     *
**********************************************************************/

User Function GEFMNFE_PR()
Local oGetNFE
Local cGetNFE := Space(TamSX3("F3_NFELETR")[1])
Local oGetRPS
Local cGetRPS := Space(TamSX3("F3_NFISCAL")[1])
Local oGetSerie
Local cGetSerie := Space(TamSX3("F3_SERIE")[1])
Local oGroup1
Local oSay1
Local oSay2
Local oSay3
Local oSButton1
Local oSButton2
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Atualizar RPS com NFE" FROM 000, 000  TO 110, 425 COLORS 0, 16777215 PIXEL

    @ 001, 002 GROUP oGroup1 TO 034, 207 OF oDlg COLOR 0, 16777215 PIXEL
    @ 009, 011 SAY oSay1 PROMPT "No. RPS " SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 008, 138 SAY oSay2 PROMPT "No. NF-e" SIZE 027, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 008, 087 SAY oSay3 PROMPT "Série do RPS" SIZE 034, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 017, 010 MSGET oGetRPS VAR cGetRPS SIZE 060, 010 OF oDlg PICTURE "@R 999999999" VALID eval({|a,b| cGetRPS := STRZERO(VAL(cGetRPS),TAMSX3("F2_DOC")[1]),.T.}) COLORS 0, 16777215 PIXEL // StrZero(Val(oGetRPS),9) 
    @ 017, 088 MSGET oGetSerie VAR cGetSerie SIZE 032, 010 OF oDlg PICTURE "!!!" COLORS 0, 16777215 PIXEL
    @ 017, 139 MSGET oGetNFE VAR cGetNFE SIZE 060, 010 OF oDlg PICTURE "@R 999999999" VALID eval({|a,b| cGetNFE := STRZERO(VAL(cGetNFE),TAMSX3("F2_NFELETR")[1]),.T.}) COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 040, 130 TYPE 01 OF oDlg ONSTOP "Confirmar Informações" ACTION (fConfirmar(cGetRPS, cGetSerie, cGetNFE)) ENABLE
    DEFINE SBUTTON oSButton2 FROM 040, 180 TYPE 02 OF oDlg ONSTOP "Cancelar Informações"  ACTION (oDlg:End()) ENABLE

  ACTIVATE MSDIALOG oDlg CENTERED

Return                                                                                                 

Static Function fConfirmar(_cRPS, _cSerie, _cNFE)

If Empty(Val(_cRPS))
	Aviso("Informação","Favor informar o número do RPS", {"Ok"})
	Return
EndIf               

If Empty(Val(_cNFE))
	Aviso("Informação","Favor informar o número da NF-e", {"Ok"})
	Return
EndIf
     
If !NFE_PR_Atu(_cRPS, _cSerie, _cNFE)
	Aviso("Informação","NF-e NÃO atualizada", {"Ok"})
Else
	Aviso("Informação","NF-e atualizada", {"Ok"})	
EndIf

Return

*--------------------------------------------------*
Static Function NFE_PR_Atu(_cRPS, _cSerie, _cNFE)
*--------------------------------------------------*
Local cChave	:= ""             
Local lSF3 		:= .F.
Local lSF2 		:= .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se encontra todos os documentos que serao atualizados:³
	//³SF2, SF3 e SFT. Caso nao encontre, nao sera atualizado.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lSF3 		:= .F.    

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³SF3 - livro Fiscal³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SF3->(dbSetOrder(6))
	cChave := xFilial("SF3")+_cRPS+_cSERIE
	If SF3->(dbSeek(xFilial("SF3")+_cRPS+_cSERIE))
		lSF3 := .T.
	Else
		lSF3 := .F.	
	Endif 
	
	If lSF3 .and. !Empty(SF3->F3_DTCANC)
		Aviso("Informação","RPS Cancelado.", {"Ok"})			
		Return .F.
	EndIf

	If !lSF3
		Aviso("Informação","RPS NÃO encontrado no Fiscal.", {"Ok"})
		Return .F.
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³SF2 - cabecalho das notas fiscais de saida³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Notas fiscais canceladas nao possuem SF2
	SF2->(dbSetOrder(1))
	If !SF2->(dbSeek(xFilial("SF2")+_cRPS+_cSERIE))
		lSF2 := .F.
	Endif

	If !lSF3
		Aviso("Informação","RPS NÃO encontrado no faturamento.", {"Ok"})
		Return .F.
	EndIf

	If lSF2 .and. lSF3 .and. !Empty(SF3->F3_NFELETR)
		If !MsgBox("Já existe NF-e informada para o RPS.  Deseja atualizar mesmo assim?","Atualiza NF-e", "YESNO")
			Return .F.
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualizando tabelas posicionadas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lSF3

		Begin Transaction

			// Notas fiscais canceladas nao possuem SF2
			RecLock("SF2",.F.)
			SF2->F2_NFELETR	:= _cNFE
			SF2->F2_EMINFE	:= CTOD("//")
			SF2->F2_HORNFE	:= ""
			SF2->F2_CODNFE	:= ""
			//SF2->F2_CREDNFE	:= ""
			MsUnLock()
	
			RecLock("SF3",.F.)
			SF3->F3_NFELETR	:= _cNFE
			SF3->F3_EMINFE	:= CTOD("//")
			SF3->F3_HORNFE	:= ""
			SF3->F3_CODNFE	:= ""
			//SF3->F3_CREDNFE	:= ""
			MsUnLock()

    	End Transaction
    	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualizando todos os itens do SFT³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SFT->(dbSetOrder(1))
		cChave := xFilial("SFT")+"S"+_cSERIE+_cRPS
		If SFT->(dbSeek(xFilial("SFT")+"S"+_cSERIE+_cRPS))
			Do While cChave == xFilial("SFT")+"S"+SFT->FT_SERIE+SFT->FT_NFISCAL .And. !SFT->(Eof())
				
				Begin Transaction
					RecLock("SFT",.F.)
					SFT->FT_NFELETR	:= _cNFE
					SFT->FT_EMINFE	:= CTOD("//")
					SFT->FT_HORNFE	:= ""
					SFT->FT_CODNFE	:= ""
					//SFT->FT_CREDNFE	:= ""
					MsUnLock()
				End Transaction
				SFT->(dbSkip())
			End
			
		Endif
    	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se tiver o campo E1_NFELETR de nota fiscal 	 ³
		//³eletronica, grava o numero da NFe gerada na 	 ³
		//³prefeitura tambem no titulo (SE1)		 	 ³		
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Se tiver o campo E1_NFELETR de nota fiscal eletronica, grava o numero da NFe gerada na prefeitura tambem no titulo (SE1)
		If (SE1->(FieldPos("E1_NFELETR")) > 0)
			If !Empty(SF2->F2_NFELETR)
				dbSelectArea("SE1")
				dbSetOrder(2)  // E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
				MsSeek(xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DOC))  
			
				While !Eof() .And. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DOC)
					RecLock("SE1",.F.)
					SE1->E1_NFELETR := RIGHT(SF2->F2_NFELETR,TAMSX3("E1_NFELETR")[1])
					MsUnlock()
						
					dbSkip()
				Enddo	     
			
			Endif
		EndIf
	EndIf	
Return(.T.)	
