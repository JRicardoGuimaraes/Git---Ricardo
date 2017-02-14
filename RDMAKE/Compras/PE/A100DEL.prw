#INCLUDE "RWMAKE.CH"
/****************************************************************************
* Programa......: A100DEL                                                   *
* Autor.........: J Ricardo Guimar�es                                       *
* Data..........: 22/10/2012                                                *
* Descricao.....: PE para n�o permitir excluir um documento de entrada,     *
*                 quando este se tratar de compra de frente do TLA, que     *
*                 dever� ser exclu�do pelo m�dulo TMS, atrav�s do CTRC      *
*****************************************************************************
* Modificado por:                                                           *
* Data..........:                                                           *
* Motivo........:                                                           *
*                                                                           *
****************************************************************************/
User Function A100DEL()
Local aArea		:=	GetArea()

If cModulo <> 'TMS'
	SD1->(dbSetOrder(1))
	SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE))
	If SD1->D1_XCOMTLA == "S"
		// MsgInfo("Documento " + SD1->D1_DOC + " ref. compra de frete TLA.  Favor excluir o CTRC pelo m�dulo TMS.")
		If !MsgYesNo("Documento " + SD1->D1_DOC + " ref. compra de frete TLA originaldo pelo m�dulo TMS.  Confirma a EXCLUS�O pelo m�dulo de Compras?")	
			RestArea(aArea)
			Return .F.
		EndIf	
	EndIf
EndIf
RestArea(aArea)
Return .T.
