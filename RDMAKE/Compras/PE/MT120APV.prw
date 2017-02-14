#include "rwMake.ch"
#include "topconn.ch"
/**********************************************************************
* Programa........: MT120APV()                                        *
* Autor...........: Marcelo Aguiar Pimentel                           *
* Data............: 21/05/2007                                        *
* Descricao.......: PE para selecionar o aprovador de acordo com o    *
*                   centro de custo do pedido de compras              *
*                                                                     *
***********************************************************************
* Modificado por..:                                                   *
* Data............:                                                   *
* Motivo..........:                                                   *
*                                                                     *
**********************************************************************/
User Function MT120APV()
Local aArea		:=	GetArea()
Local aAreaSAL	:=	SAL->(GetArea())
Local cGrp		:=	""

cGrp:=U_VLDCCApr(SC7->C7_CC)

RestArea(aAreaSAL)
RestArea(aArea)
Return cGrp   