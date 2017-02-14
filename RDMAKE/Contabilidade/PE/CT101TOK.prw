#INCLUDE "RWMAKE.CH"
/****************************************************************************
* Programa......: CT101TOK                                                  *
* Autor.........: Marcelo Aguiar Pimentel                                   *
* Data..........: 25/05/2007                                                *
* Descricao.....: PE para travar centro de custo com 6 digitos quando utili-*
*                 zados as contas do parametro MV_XCNTCC no Lanc. Contabil  *
*                                                                           *
*****************************************************************************
* Modificado por:                                                           *
* Data..........:                                                           *
* Motivo........:                                                           *
*                                                                           *
****************************************************************************/
User Function CT101TOK()
Local lRet	:=	.f.
Local aArea	:=	GetArea()
Local cCntD	:=	""
Local cCCD	:=	""
Local cCntC	:=	""
Local cCCC	:=	""

//cTipo,cDebito,cCredito,cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,cClVlDeb,cClVlCrd,cTpSald
cCntD	:=	allTrim(ParamIxb[02])
cCntC	:=	allTrim(ParamIxb[03])
cCCD	:=	allTrim(ParamIxb[04])
cCCC	:=	allTrim(ParamIxb[05])
cTipo	:=	alltrim(ParamIxb[1])

Alert("ct2-ok")

If cTipo == "1" .OR. cTipo == "3"
	lRet:=u_vldCntCC(cCCD,cCntD)
EndIf

If cTipo == "2"
	lRet:=u_vldCntCC(cCCC,cCntC)
ElseIf cTipo == "3" .AND. lRet
	lRet:=u_vldCntCC(cCCC,cCntC)
EndIf

RestArea(aArea)
Return lRet