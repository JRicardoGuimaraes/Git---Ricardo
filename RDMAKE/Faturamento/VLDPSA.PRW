#include "rwmake.ch"
#include "topconn.ch"
/***************************************************************************
* Programa........: VLDPSA()                                               *
* Autor...........: Marcelo Aguiar Pimentel                                *
* Data............: 15/03/2007                                             *
* Descricao.......: Faz críticas quando o cliente e Peugeot na Inclusao e  *
*                   Alteracao do Pedido de venda e Contas a Receber        *
*                                                                          *
****************************************************************************
* Modificado por..:                                                        *
* Data............:                                                        *
* Motivo..........:                                                        *
*                                                                          *
***************************************************************************/
User Function vldPSA(cTipo)
Local aArea := GetArea()
Local cMsg:=""
Local lAnPSA:=.t.

Local cCliente 	:= ""
Local cLoja		:= ""
Local cCusto		:= ""
Local cCcusPSA	:= ""
Local cCtaPSA		:= ""
Local cOIPSA		:= ""
Local cFunName	:=allTrim(FunName())

If cFunName $("MATA410|MATA410X")

	If M->C5_TIPO $ "B|D"
		Return cMsg
	EndIf

	cCliente	:=	M->C5_CLIENTE
	cLoja		:=	M->C5_LOJACLI
	cCusto		:=	M->C5_CCUSTO
	cCcusPSA	:=	M->C5_CCUSPSA
	cCtaPSA	:=	M->C5_CTAPSA
	cOIPSA		:=	M->C5_OIPSA

ElseIf cFunName $("FINA040|FINA740|FINA040X|FINA740") // Atencao: Se incluir novas funcoes para validacao do funname() verifique antes no código que é feito o mesmo teste deste bloco de código.
	cCliente	:=	M->E1_CLIENTE
	cLoja		:=	M->E1_LOJA
	cCusto		:=	M->E1_CCONT
	cCcusPSA	:=	M->E1_CCPSA
	cCtaPSA	:=	M->E1_CTAPSA
	cOIPSA		:=	M->E1_OIPSA
EndIf


If isCliPSA(cCliente+cLoja,.f.)
	If subStr(cCusto,10,1) = '4'
		If !isCliPSA(cCliente+cLoja,.t.) // *COD_SAP = BR30*
			lAnPSA:=.f.
		EndIf
	EndIf
Else
	lAnPSA:=.f.
EndIf

DbselectArea("SA1")
DbSetorder(1)       // Ordena Por Cliente+loja
Dbseek(xFilial("SA1")+cCliente)
If Empty(SA1->A1_GEFCAT1)
	cMsg:="Campo 'Categoria 1' no Cadastro de cliente não está informado."
	return cMsg
EndIf
lVldSZD:=.t.
If len(allTrim(cCusto)) < 10 .and. cFunName $("FINA040|FINA740|FINA040X|FINA740X")
	lVldSZD:=.f.
EndIf

If lVldSZD
	DbSelectArea("SZD")
	DbSetOrder(1)
	If DbSeek(xFilial("SZD")+SubStr(cCusto,10,1)+SA1->A1_GEFCAT1)
		IF !Empty(SZD->ZD_UO)
			IF !(SubStr(cCusto,2,2) $ SZD->ZD_UO)
	            	    //Uo não autoriazada apra esta configuração de faturamento: UO X 10ºDigito Centro de custo.
				If cTipo $('CCPAD|TODOS')
					cMsg:="Centro de custo inválido: UO X 10ºDigito Centro de custo."+chr(10)
				EndIf
                If cTipo == 'CCPAD'
					ApMsgAlert(cMsg)
					return ""
	            EndIf
			EndIf
		EndIf
	Else
	   	    //Faturamento não permitido: 10º Digito CC X Categoria do Cliente.
		If cTipo $('CCPAD|TODOS')
			cMsg:="Centro de custo inválido: 10º Digito CC X Categoria do Cliente."+chr(10)
		EndIf
        If cTipo == 'CCPAD'
			ApMsgAlert(cMsg)
			return ""
		EndIf
	EndIf
EndIf

If lAnPSA
	//Critica de C.Custo PSA
/*
	If !Empty(cCcusPSA)
		dbSelectArea("SZG")
		dbSetOrder(1)
		If !dbSeek(xFilial("SZG")+ltrim(cCcusPSA))
			If cTipo $('CCPSA|TODOS')
				cMsg+="C.Custo PSA nao encontrado: "+cCcusPSA+chr(10)
			EndIf
            If cTipo == 'CCPSA'
				return cMsg
			EndIf
			//pos	:=24
		EndIf
	Else
*/
	If Empty(cCcusPSA)
		If cTipo $('CCPSA|TODOS')
			cMsg+="C.Custo PSA está em branco!"+chr(10)//pos	:=25
		EndIf
        If cTipo == 'CCPSA'
			ApMsgAlert(cMsg)
			return ""
		EndIf
	EndIf
	//Procutra Conta Despesa PSA em SZF
/*
	If !Empty(ltrim(cCtaPSA))
		dbSelectArea("SZF")
		dbSetOrder(1)
		If !dbSeek(xFilial("SZF")+ltrim(cCtaPSA))
			If cTipo $('CTAPSA|TODOS')
				cMsg+="Conta PSA nao encontrada: "+cCtaPSA+chr(10)//pos	:=26
			EndIf
			If cTipo == 'CTAPSA'
				return cMsg
			EndIf
		EndIf
	Else
*/
	If Empty(cCtaPSA)
		If cTipo $('CTAPSA|TODOS')
			cMsg+="Conta PSA está em branco!"+chr(10)//pos	:=27
		EndIf
		If cTipo == 'CTAPSA'
			ApMsgAlert(cMsg)
			return ""
		EndIf
	EndIf

/*
	If Empty(cOIPSA)
		If !Empty(cCcusPSA) .and. !Empty(cCtaPSA)
			// Por: Ricardo - Em: 13/04/2010
			If Empty(cOIPSA) .AND. POSICIONE("SZG",1,xFilial("SZG")+cCCusPSA,"ZG_OIOBRIG") == "S"
				cMsg := "A Ordem Interna PSA é obrigatória para o C.Custo PSA informado.  Favor preencher o campo."
			ElseIf !Empty(cOIPSA) .AND. POSICIONE("SZG",1,xFilial("SZG")+cCCusPSA,"ZG_OIOBRIG") <> "S"
				cMsg := "O C.Custo PSA informado não requer Ordem Interna.  Favor manter o campo OI em branco ou alterar o CC."
			ElseIf !Empty(cOIPSA) .AND. POSICIONE("SZG",1,xFilial("SZG")+cCCusPSA,"ZG_OIOBRIG") == "S"
				dbSelectArea("SZI")
				dbSetOrder(1)
				cChave:=ltrim(cCcusPSA)+space(len(cCcusPSA)-len(LTRIM(cCcusPSA)))
				cChave+=ltrim(cCtaPSA)+space(len(cCtaPSA)-len(LTRIM(cCtaPSA)))
				If dbSeek(xFilial("SZI")+cChave)
	//				If Empty(SZI->ZI_OI)
	//					cMsg+="Não permitido.  O.I. está em branco na tabela de CONTA X C.CUSTO X ORDEM INTERNA"+chr(10)//pos:=28
	//				EndIf
					If cFunName $("MATA410|MATA410X")
						M->C5_OIPSA:=SZI->ZI_OI
					ElseIf cFunName $("FINA040|FINA740|FINA040X|FINA740")
						M->E1_OIPSA:=SZI->ZI_OI
					EndIf
	//			Else
	//				cMsg+="Não permitido.  Conta e C.Custo PSA não encontrados na tabela de CONTA X C.CUSTO X ORDEM INTERNA"+chr(10)//pos:=29
				EndIf
			EndIf
		EndIf
	Else
		If !Empty(cCcusPSA) .and. !Empty(cCtaPSA)
			// Por: Ricardo - Em: 13/04/2010
			If Empty(cOIPSA) .AND. POSICIONE("SZG",1,xFilial("SZG")+cCCusPSA,"ZG_OIOBRIG") == "S"
				cMsg := "A Ordem Interna PSA é obrigatória para o C.Custo PSA informado.  Favor preencher o campo."
			ElseIf !Empty(cOIPSA) .AND. POSICIONE("SZG",1,xFilial("SZG")+cCCusPSA,"ZG_OIOBRIG") <> "S"
				cMsg := "O C.Custo PSA informado não requer Ordem Interna.  Favor manter o campo OI em branco ou alterar o CC."
			ElseIf !Empty(cOIPSA) .AND. POSICIONE("SZG",1,xFilial("SZG")+cCCusPSA,"ZG_OIOBRIG") == "S"
				dbSelectArea("SZI")
				dbSetOrder(1)
				cChave:=ltrim(cCcusPSA)+space(len(cCcusPSA)-len(LTRIM(cCcusPSA)))
				cChave+=ltrim(cCtaPSA)+space(len(cCtaPSA)-len(LTRIM(cCtaPSA)))
				cChave+=ltrim(cOIPSA)+space(len(cOIPSA)-len(LTRIM(cOIPSA)))
				If !dbSeek(xFilial("SZI")+cChave)
					If cTipo $('OIPSA|TODOS')
						cMsg+="O.I. inválida.  Conta PSA, C.Custo PSA e O.I. não encontrados na tabela de CONTA X C.CUSTO X ORDEM INTERNA (SZI) "+chr(10)//pos:=30
					EndIf
					If cTipo == 'OIPSA'
						ApMsgAlert(cMsg)
						return ""
					EndIf
				EndIf
			Endif
		EndIf
	EndIf
*/
	dbSelectArea("CTT")
	dbSetOrder(1)
	If dbSeek(xFilial("CTT")+cCusto)
		If Empty(CTT->CTT_XTPDES)
			If cTipo $ ('CCPAD|TODOS')
				cMsg+="Tipo de Despesa não cadastrado no Centro de Custo!"+chr(10)
			EndIf
			If cTipo == "CCPAD"
				ApMsgAlert(cMsg)
				return ""
			EndIf
		Else
			If cFunName $("MATA410|MATA410X")
				M->C5_TPDESP:=CTT->CTT_XTPDES
			ElseIf cFunName $("FINA040|FINA740")
				M->E1_TPDESP:=CTT->CTT_XTPDES
			EndIf
		EndIf
	EndIf
EndIf
RestArea(aArea)
Return cMsg

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
ElseIf lCodSap
/*	If AllTrim(SZE->ZE_CODSAP) == 'BR30' --Marcos Furtado 27/06/2007 - estava ignorando o cliente Peugeot de Porto Real.
		lRet:=.f.
	EndIf*/
EndIf

Return lRet





/*
User Function vPSACP(cCampo)
Local lRet:=.t.
Local cMsg:=""
Local cCliente
Local cLoja
Local cCusto
Local cCcusPSA
Local cCtaPSA
Local cOIPSA
Local cFunName	:=allTrim(FunName())

If cFunName == "MATA410"
	cCliente	:=	M->C5_CLIENTE
	cLoja		:=	M->C5_LOJACLI
	cCusto		:=	M->C5_CCUSTO
	cCcusPSA	:=	M->C5_CCUSPSA
	cCtaPSA		:=	M->C5_CTAPSA
	cOIPSA		:=	M->C5_OIPSA
ElseIf cFunName $("FINA040|FINA740")
	cCliente	:=	M->E1_CLIENTE
	cLoja		:=	M->E1_LOJA
	cCusto		:=	M->E1_CCONT
	cCcusPSA	:=	M->E1_CCPSA
	cCtaPSA		:=	M->E1_CTAPSA
	cOIPSA		:=	M->E1_OIPSA
EndIf


u_vldPSA()
If cCampo == "CCPSA"
	If !Empty(cCcusPSA)
		dbSelectArea("SZG")
		dbSetOrder(1)
		If !dbSeek(xFilial("SZG")+ltrim(cCcusPSA))
			lRet:=.f.
			ApMsgAlert("C.Custo PSA inválido!")
		EndIf
	EndIf
ElseIf cCampo == "CTAPSA"
	If !Empty(cCtaPSA)
		dbSelectArea("SZF")
		dbSetOrder(1)
		If !dbSeek(xFilial("SZF")+ltrim(cCtaPSA))
			lRet:=.f.
			ApMsgAlert("Conta PSA inválida!")
		EndIf
	EndIf
ElseIf cCampo == "OIPSA"
	If !Empty(cOIPSA)
		dbSelectArea("SZH")
		dbSetOrder(1)
		If !dbSeek(xFilial("SZH")+ltrim(cOIPSA))
			lRet:=.f.
			ApMsgAlert("O.I. PSA inválida!")
		EndIf
	EndIf
EndIf
Return lRet
*/