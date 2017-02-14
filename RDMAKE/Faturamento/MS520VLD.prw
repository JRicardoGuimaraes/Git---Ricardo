#INCLUDE "RWMAKE.CH"
/****************************************************************************
* Programa......: MS520VLD()                                                *
* Autor.........: J Ricardo de O Guimarães                                  *
* Data..........: 04/11/2008                                                *
* Descricao.....: PE para travar exclusão de NF caso o período contábil es- *
*                 ja bloqueado/fechado e se a NF for de outro período,  so- *
*                 mente os usuários do fiscal estão autorizados             *
*****************************************************************************
* Modificado por:                                                           *
* Data..........:                                                           *
* Motivo........:                                                           *
*                                                                           *
****************************************************************************/
User Function MS520VLD()
Local _lRet		:=	.T.
Local _lRetCtb  :=	.T.
Local _aArea	:=	GetArea()

If Month(SF2->F2_EMISSAO) <> Month(dDataBase)
	If __cUserId $ GETMV("MV_XFISCAL")
		_lRet := .T.
	Else
		_lRet := .F.
		Aviso("Atenção","A NF " + SF2->F2_DOC + "-" + SF2->F2_SERIE + " emitida em " + DTOC(SF2->F2_EMISSAO) + " está fora do período contábil.  Favor contactar o Depto. Fiscal." ,{"Ok"})
	EndIf
EndIf

If _lRet
	If SF2->F2_EMISSAO > dDataBase
		Aviso("Atenção","A NF " + SF2->F2_DOC + "-" + SF2->F2_SERIE + " emitida em " + DTOC(SF2->F2_EMISSAO) + ".  O Cancelamento não pode ser em data menor que a data de emissão.  Favor contactar o Depto. Fiscal." ,{"Ok"})	
		_lRet := .F.
	EndIf
EndIf

*-------------------------------------------------*
* Verifico Calendário Contábil                    *
*-------------------------------------------------*
If !U_GEFMCTB()
	_lRetCTB := .F.
EndIf	

If _lRet .AND. _lRetCTB
	_lRet := .T.
Else
	_lRet := .F.
EndIf	

RestArea(_aArea)
Return _lRet
