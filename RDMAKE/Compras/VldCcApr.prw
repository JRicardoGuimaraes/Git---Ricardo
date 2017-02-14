#include "rwMake.ch"
#include "topconn.ch"
/**********************************************************************
* Programa........: VLDCCAPR()                                        *
* Autor...........: Marcelo Aguiar Pimentel                           *
* Data............: 21/05/2007                                        *
* Descricao.......: Rotina responsavel por trazer o codigo do grupo   *
*                   de aprovadores de acordo com a UO.                *
*                                                                     *
***********************************************************************
* Modificado por..:                                                   *
* Data............:                                                   *
* Motivo..........:                                                   *
*                                                                     *
**********************************************************************/
User Function VldCcApr(pUO)
Local aArea		:=	GetArea()
Local aAreaSAL	:=	SAL->(GetArea())
Local cGrp		:=	""
Local cUO		:=	""
// Busca o Digito da U.O.
cUO:=subStr(pUO,2,2)

dbSelectArea("SAL")
cQry:="SELECT AL_COD "
cQry+="  FROM "+RetSqlName("SAL")
cQry+=" WHERE AL_FILIAL = '"+xFilial("SAL")+"'"
cQry+="   AND AL_XUO LIKE '%"+cUO+"%'"
cQry+="   AND D_E_L_E_T_ <> '*'"
TcQuery cQry Alias "TSAL" New
If !Eof()
	cGrp:=TSAL->AL_COD
EndIf
dbCloseArea()

RestArea(aAreaSAL)
RestArea(aArea)
Return cGrp