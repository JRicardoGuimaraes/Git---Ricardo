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
	Local aArea		:= GetArea()
	Local cMsg			:= ""
	Local lAnPSA		:= .T.

	Local cCliente 	:= ""
	Local cLoja		:= ""
	Local cCusto		:= ""
	Local cCcusPSA	:= ""
	Local cCtaPSA		:= ""
	Local cOIPSA		:= ""
	Local cFunName	:= AllTrim( FunName() )

	If cFunName $("MATA410|MATA410X")

		If M->C5_TIPO $ "B|D"
			Return( cMsg )
		EndIf

		cCliente	:=	M->C5_CLIENTE
		cLoja		:=	M->C5_LOJACLI
		cCusto		:=	M->C5_CCUSTO
		cCcusPSA	:=	M->C5_CCUSPSA
		cCtaPSA	:=	M->C5_CTAPSA
		cOIPSA		:=	M->C5_OIPSA

	ElseIf cFunName $("FINA040|FINA040X|FINA740") // Atencao: Se incluir novas funcoes para validacao do funname() verifique antes no código que é feito o mesmo teste deste bloco de código.
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
		Return cMsg
	EndIf

	lVldSZD	:= .T.

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
		If Empty(cCcusPSA)
			If cTipo $('CCPSA|TODOS')
				cMsg+="C.Custo PSA está em branco!"+chr(10)//pos	:=25
			EndIf
			If cTipo == 'CCPSA'
				ApMsgAlert(cMsg)
				return ""
			EndIf
		EndIf
		If Empty(cCtaPSA)
			If cTipo $('CTAPSA|TODOS')
				cMsg+="Conta PSA está em branco!"+chr(10)//pos	:=27
			EndIf
			If cTipo == 'CTAPSA'
				ApMsgAlert(cMsg)
				return ""
			EndIf
		EndIf
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
	EndIf

Return lRet
