#include "rwmake.ch"
#include "topconn.ch"
/***************************************************************************
* Programa........: FA040INC()                                             *
* Autor...........: Marcelo Aguiar Pimentel                                *
* Data............: 16/03/2007                                             * 
* Descricao.......: Valida na Inclusao e alteracao criticas de clietne PSA *
*                                                                          *
****************************************************************************
* Modificado por..:                                                        *
* Data............:                                                        *
* Motivo..........:                                                        *
*                                                                          *
***************************************************************************/

User Function FA040INC()
Local aArea:=GetArea()
Local lRet:=.t.
Local cMsg:=""          

If AllTrim(FunName()) == 'FINA040'

	cMsg:=u_vldPSA('TODOS')
	If !Empty(cMsg)
	   	APMsgAlert(cMsg)
		lRet:=.f.
	EndIf
	
EndIf	
RestArea(aArea)
Return lRet
