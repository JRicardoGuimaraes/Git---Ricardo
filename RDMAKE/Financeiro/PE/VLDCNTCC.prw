#include "rwMake.ch"
/****************************************************************************
* Programa......: VLDCNTCC()                                                *
* Autor.........: Marcelo Aguiar Pimentel                                   *
* Data..........: 25/05/2007                                                *
* Descricao.....: PE para travar centro de custo com 6 digitos quando utili-*
*                 zados as contas do parametro MV_XCNTCC                    *
*                                                                           *
*****************************************************************************
* Modificado por:                                                           *
* Data..........:                                                           *
* Motivo........:                                                           *
*                                                                           *
****************************************************************************/
User Function vldCntCC(pCC,pConta)
Local lRet		:=	.t.
Local aArea		:=	GetArea()
Local aAreaSE2	:=	SE2->(GetArea())
Local cMV_XCNTCC:=	GetMv("MV_XCNTCC")

If (allTrim(pConta) $ cMV_XCNTCC) .and. (len(allTrim(pCC))<10)
	ApMsgAlert("Centro de Custo inválido para a conta informada.  Informe um Centro de Custo de 10 digitos")
	lRet:=.f.
EndIf

RestArea(aAreaSE2)
RestArea(aArea)
Return lRet
