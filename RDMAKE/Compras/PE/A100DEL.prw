#INCLUDE "RWMAKE.CH"
/****************************************************************************
* Programa......: A100DEL                                                   *
* Autor.........: J Ricardo Guimarães                                       *
* Data..........: 22/10/2012                                                *
* Descricao.....: PE para não permitir excluir um documento de entrada,     *
*                 quando este se tratar de compra de frente do TLA, que     *
*                 deverá ser excluído pelo módulo TMS, através do CTRC      *
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
		// MsgInfo("Documento " + SD1->D1_DOC + " ref. compra de frete TLA.  Favor excluir o CTRC pelo módulo TMS.")
		If !MsgYesNo("Documento " + SD1->D1_DOC + " ref. compra de frete TLA originaldo pelo módulo TMS.  Confirma a EXCLUSÃO pelo módulo de Compras?")	
			RestArea(aArea)
			Return .F.
		EndIf	
	EndIf
EndIf
RestArea(aArea)
Return .T.
