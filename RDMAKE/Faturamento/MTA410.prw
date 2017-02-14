#include "rwmake.ch"
#include "topconn.ch"
/***************************************************************************
* Programa........: MTA410()                                               *
* Autor...........: Marcelo Aguiar Pimentel                                *
* Data............: 15/03/2007                                             * 
* Descricao.......: Valida na Inclusao e alteracao criticas de clietne PSA *
*                   Pedido de Venda                                        *
****************************************************************************
* Modificado por..:                                                        *
* Data............:                                                        *
* Motivo..........:                                                        *
*                                                                          *
***************************************************************************/

User Function MTA410()
Local aArea:=GetArea()
Local lRet:=.t.
Local lRetRefGef:=.t.
Local cMsg:=""
Local _cCliMAN  := AllTrim(GETNewPar("MV_XFATMAN","04858701|"))

If INCLUI .OR. ALTERA
	If !Empty(M->C5_CCUSTO)
		If Posicione("CTT",1,xFilial("CTT")+M->C5_CCUSTO,"CTT_BLOQ") == "1"
    		APMsgAlert("Centro de Custo Bloqueado.")
    		Return .F.
		EndIf
		
	EndIf

	cMsg:=u_vldPSA('TODOS')
	If !Empty(cMsg)
    	APMsgAlert(cMsg)
    	lRet:=.f.
    EndIf
    *--------------------------------*
	lRetRefGef := fVldRefGefco()    
	*--------------------------------*
	
	If Empty(M->C5_NATUREZ) .AND. AllTrim(M->C5_XTIPONF) == 'NFS'
    	APMsgAlert("Natureza não pode estar em branco.")	
    	Return .f.
    EndIf
    
	If Empty(M->C5_NATUREZ) .AND. AllTrim(M->C5_XTIPONF) == 'NFT'
    	APMsgAlert("Natureza não pode estar em branco para NF Mod. 7. Favor informar no parâmetro MV_XNATNF7")
    	Return .f.
    EndIf 

	// Por: Ricardo Guimarães - Em: 03/02/2014
	// Validação dos campos que são obrigatório para a operação MAN
	If M->C5_CLIENTE + M->C5_LOJACLI $ _cCliMAN .AND. Left(M->C5_CCUSTO,3) $ AllTrim(GETMV("MV_XOVLCC"))
		If Empty(M->C5_TPCAR)
			Aviso("Campo Obrigatório(MAN)","Favor informar o Tipo de Carregamento(MAN).",{"Continuar"})
			Return .F.			
		EndIf
			                      
		If Empty(M->C5_NUMCVA)
			Aviso("Campo Obrigatório(MAN)","Favor informar o Número do CVA(MAN).",{"Continuar"})
			Return .F.			
		EndIf                  
			
		If Empty(M->C5_COLMON)
			Aviso("Campo Obrigatório(MAN)","Favor informar o Número do ColetA do Moniloc(MAN).",{"Continuar"})
			Return .F.
		EndIf
	EndIF
	
EndIf

RestArea(aArea)
Return( lRet .and. lRetRefGef )

/************************************************************************
* Funcao....: fVldRefGefco()                                            *
* Autor.....: J Ricardo de O Guimarães                                  *
* Data......: 22/02/2008                                                *
* Descricao.: Valida a Ref. Gefco coforme definição da PSA              *
*                                                                       *
************************************************************************/
*---------------------------------*
Static Function fVldRefGefco()
*---------------------------------*
Local _lRet := .T.
Local _cRefGef := AllTrim(M->C5_REFGEFC)
Local _cQry := ""

If isCliPSA(M->C5_CLIENTE+M->C5_LOJACLI)
	If M->C5_TPDESP = "I" // Importação
		// Retirado a crítica PCB em função da entrada do sistema FullComex - Por: Ricardo - Em: 07/05/2010
		// If Left(_cRefGef,3)<>'PCB' .AND. Left(_cRefGef,4)<>'DLPR' .AND. Left(_cRefGef,10)<>'DIVS - CKD' .AND. Left(_cRefGef,11)<>'DIVS - DLPR' .AND. Left(_cRefGef,09)<>'DIVS - VN'
/*
		If Left(_cRefGef,4)<>'DLPR' .AND. Left(_cRefGef,10)<>'DIVS - CKD' .AND. Left(_cRefGef,11)<>'DIVS - DLPR' .AND. Left(_cRefGef,09)<>'DIVS - VN'		
			Aviso("Aviso","Tipo de despesa Importação exige PCB- ou DLPR- acompanhado de número.",{"Ok"})
			_lRet := .F.
		Else
*/
		/* Comentado por: Ricardo - Em: 07/05/2010 - Em função da entrada do sistema FullComex
			If Left(_cRefGef,3) == 'PCB' .AND. SubStr(_cRefGef,4,1) <> "-"
				Aviso("Aviso","O PCB exige o seguinte formato PCB-999999, onde 999999 é o número sequencial do PCB, " + Chr(13) +;
				       "caso o número seja menor que 6 dígitos deverá ser preenchido com Zeros a esquerda." + Chr(13) +;
				       "No caso de diversos, usar DIVS - CKD, DIVS - VN ou DIVS - DLPR." ,{"Ok"})
				_lRet := .F.
		*/
			If Left(_cRefGef,4) == 'DLPR' .AND. SubStr(_cRefGef,5,1) <> "-"
				Aviso("Aviso","O DLPR exige o seguinte formato DLPR-99999, onde 99999 é o número sequencial do DLPR, " + Chr(13) +;
				       "caso o número seja menor que 5 dígitos deverá ser preenchido com Zeros a esquerda." + Chr(13) +;
				       "No caso de diversos, usar DIVS - CKD, DIVS - VN ou DIVS - DLPR." ,{"Ok"})				       
				_lRet := .F.
			//Else
		/* Comentado por: Ricardo - Em: 07/05/2010 - Em função da entrada do sistema FullComex			
				If Left(_cRefGef,3) == 'PCB' .AND. SubStr(_cRefGef,4,1) == "-" .AND. Len(SubStr(_cRefGef,5,Len(_cRefGef))) < 6
					Aviso("Aviso","O PCB informado está fora do formato PCB-999999 exigido, onde 999999 é o número sequencial do PCB, " + Chr(13) +;
					       "caso o número seja menor que 6 dígitos deverá ser preenchido com Zeros a esquerda." + Chr(13) +;
				       	   "No caso de diversos, usar DIVS - CKD, DIVS - VN ou DIVS - DLPR." ,{"Ok"})				       					       
					_lRet := .F.
		*/					
			ElseIf Left(_cRefGef,4) == 'DLPR' .AND. SubStr(_cRefGef,5,1) == "-" .AND. Len(SubStr(_cRefGef,6,Len(_cRefGef))) < 5
					Aviso("Aviso","O BLPR informado está fora do formato DLPR-99999 exigido, onde 99999 é o número sequencial do DLPR, " + Chr(13) +;
					       "caso o número seja menor que 5 dígitos deverá ser preenchido com Zeros a esquerda." + Chr(13) +;
				       	   "No caso de diversos, usar DIVS - CKD, DIVS - VN ou DIVS - DLPR." ,{"Ok"})				       					       					       
					_lRet := .F.
			  //	EndIf
	//		EndIf
			EndIf
	ElseIf M->C5_TPDESP = "E" // Exportação
		If "EMRIO" $ _cRefGef
			Aviso("Aviso","Tipo de Despesa Exportação deverá conter o número de referência da exportação. " + Chr(13) +;
				       "A Referência da exportação não pode conter a palavra EMRIO.",{"Ok"})
			_lRet := .F.         
			
		EndIf

/*
		// Regra passado pelo Valter em 24/04/08		
		Após a barra deve ser informado os 2 ultimos algarismos do ano do processo
		E nnn/nn => E 148/07 , ERnnn/nn => ER135/07 , VCnnn/nn => VC036/08
		VPnnn/nn => VP133/07 , P nnn/nn => P 156/08 , PTnnn/nn => PT 156/08
		R nnn/nn => R 035/08 , M nnn/nn => M 036/08 , PRnnn/nn => PR037/08
		Cnnnn/nn => C1036/08
*/		

		_cMsg := "Formatos aceitos como Ref. Gefco quando o tipo é Exportação: "        + Chr(13) +; 
		         "E nnn/nn => E 148/07 , ERnnn/nn => ER135/07 , VCnnn/nn => VC036/08  " + Chr(13) +; 
				 "VPnnn/nn => VP133/07 , P nnn/nn => P 156/08 , PTnnn/nn => PT 156/08 " + Chr(13) +; 
				 "R nnn/nn => R 035/08 , M nnn/nn => M 036/08 , PRnnn/nn => PR037/08  " + Chr(13) +; 
				 "Cnnnn/nn => C1036/08 "

		If Len(AllTrim(_cRefGef)) <> 8 
			Aviso("Aviso",_cMsg,{"Ok"})
			_lRet := .F.
		ElseIf Val(AllTrim(SubStr(_cRefGef,7,2))) < 7 
			Aviso("Aviso",_cMsg,{"Ok"})
			_lRet := .F.
		ElseIf !ISDIGIT(SubStr(_cRefGef,3,1)) .OR. !ISDIGIT(SubStr(_cRefGef,4,1)) .OR. !ISDIGIT(SubStr(_cRefGef,5,1))
			Aviso("Aviso",_cMsg,{"Ok"})
			_lRet := .F.
		ElseIf AT("/",SubStr(_cRefGef,6,3)) = 0 
			Aviso("Aviso",_cMsg,{"Ok"})
			_lRet := .F.
		ElseIf !(Left(_cRefGef,2) $ "E |ER|VC|VP|P |PT|R |M |PR") .AND. Left(_cRefGef,1) <> "C"
			Aviso("Aviso",_cMsg,{"Ok"})
			_lRet := .F.
		EndIf
		
	ElseIf M->C5_TPDESP = "O" // Outros
		If !Empty(_cRefGef)
			Aviso("Aviso","Tipo de Despesa Outros, a Referência Gefco deverá estar em branco.",{"Ok"})
			_lRet := .F.
		EndIf
	EndIf
	
	
EndIf

// Por: Ricardo Guimarães - Em: 23/02/2010 - Objetivo: Não permitir incluir pedido com a mesma Ref. Gefco
If !Empty(_cRefGef) 
	If LEFT(_cRefGef,3) == "PCB" .OR. LEFT(_cRefGef,2) $ "P |R |VC|VP"
		_cQry := " SELECT C5_REFGEFC, C5_NOTA, C5_SERIE FROM " + RetSqlName("SC5") + " SC5 " 
		_cQry += "  WHERE C5_FILIAL  = '" + cFilAnt  + "' "
		_cQry += "    AND C5_REFGEFC = '" + _cRefGef + "' "
		_cQry += "    AND C5_NOTA   <> '' " 
		_cQry += "    AND D_E_L_E_T_ = '' "
		
		TCQUERY _cQry ALIAS "TSC5" NEW
		
		dbSelectArea("TSC5") ; dbGoTop()
		
		_cMsg := ""
		While !TSC5->(Eof())
			_cMsg += " " + AllTrim(TSC5->C5_NOTA) + "-" + AllTrim(TSC5->C5_SERIE) + ", "
			TSC5->(dbSkip())
		End
		
		TSC5->(dbCloseArea())
		
		If !Empty(_cMSG)
			_cMSG := SubStr(_cMSG, 1, Len(_cMSG)-3)
			_cMSG := "A Ref. Gefco " + AllTrim(_cRefGef) + " já foi faturada na(s) NF(s): " + _cMSG + ". Continua com a gravação do Pedido"
			// Aviso("Aviso",_cMSG,{"Ok"})
			If MsgYesNo(_cMSG)
				_lRet := .T.
			Else
				_lRet := .F.
			EndIf	
		EndIf
		
	EndIf
EndIf

Return _lRet

/************************************************************************
* Funcao....: isCliPSA()                                                *
* Autor.....: Marcelo Aguiar Pimentel                                   *
* Data......: 14/03/2007                                                *
* Descricao.: Verifica se o cliente está cadastrado na tabela SZE(Clien *
*             Peugeot PSA                                               *
*                                                                       *
************************************************************************/
Static Function isCliPSA(pCliente,lCodSap)
Local lRet:=.t.

dbSelectArea("SZE")
dbSetOrder(1)

If !dbSeek(xFilial("SZE")+pCliente)
	lRet:=.f.
EndIf

Return lRet
