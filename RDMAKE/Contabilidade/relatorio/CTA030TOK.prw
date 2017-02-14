#include "rwmake.ch"

/**********************************************************************
* Programa........: CTA030TOK()                                       *
* Autor...........: Marcelo Aguiar Pimentel                           *
* Data............: 15/05/2007                                        *
* Descricao.......: Ponto de Entrada na Inclusao e Aletracao do Cadas-*
*                   de C.Custo para deixar o campo CTT_XTPDES obriga- *
*                   torio quando o 10ºDigito do C.Custo for 1,2,3 ou 4*
*                                                                     *
***********************************************************************
* Modificado por..:                                                   *
* Data............:                                                   *
* Motivo..........:                                                   *
*                                                                     *
**********************************************************************/

User Function CTA030TOK()
Local aArea:=GetArea()
Local lRet:=.f.
If INCLUI .OR. ALTERA
	If subStr(M->CTT_CUSTO,10,1) $("1,2,3,4") .and. Empty(M->CTT_XTPDES)
		ApMsgAlert("O campo 'Tip. Despesa' é obrigatório para Centro de Custo PSA","Atenção!")
		lRet:=.t.
	EndIf
EndIf
RestArea(aArea)
Return lRet