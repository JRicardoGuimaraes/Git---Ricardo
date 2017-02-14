#INCLUDE "RWMAKE.CH"
/****************************************************************************
* Programa......: MS520VLD()                                                *
* Autor.........: J Ricardo de O Guimar�es                                  *
* Data..........: 04/11/2008                                                *
* Descricao.....: PE para travar exclus�o de NF caso o per�odo cont�bil es- *
*                 ja bloqueado/fechado e se a NF for de outro per�odo,  so- *
*                 mente os usu�rios do fiscal est�o autorizados             *
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
		Aviso("Aten��o","A NF " + SF2->F2_DOC + "-" + SF2->F2_SERIE + " emitida em " + DTOC(SF2->F2_EMISSAO) + " est� fora do per�odo cont�bil.  Favor contactar o Depto. Fiscal." ,{"Ok"})
	EndIf
EndIf

If _lRet
	If SF2->F2_EMISSAO > dDataBase
		Aviso("Aten��o","A NF " + SF2->F2_DOC + "-" + SF2->F2_SERIE + " emitida em " + DTOC(SF2->F2_EMISSAO) + ".  O Cancelamento n�o pode ser em data menor que a data de emiss�o.  Favor contactar o Depto. Fiscal." ,{"Ok"})	
		_lRet := .F.
	EndIf
EndIf

*-------------------------------------------------*
* Verifico Calend�rio Cont�bil                    *
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
