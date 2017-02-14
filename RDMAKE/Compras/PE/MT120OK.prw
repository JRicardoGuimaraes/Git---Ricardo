#include "rwMake.ch"
#include "topconn.ch"
/**********************************************************************
* Programa........: MT120OK()                                         *
* Autor...........: Marcelo Aguiar Pimentel                           *
* Data............: 21/05/2007                                        *
* Descricao.......: PE na inclusao/aleracao do Ped.Compras para veri- *
*                   ficar  se  os Centro de Custos  dos  itens  estao *
*                   dentro da UO                                      * 
*                                                                     *
***********************************************************************
* Modificado por..:                                                   *
* Data............:                                                   *
* Motivo..........:                                                   *
*                                                                     *
**********************************************************************/
User Function MT120OK()
Local aArea		:=	GetArea()
Local aAreaSAL	:=	SAL->(GetArea())
Local lRet		:=	.f.
Local nPosDel	:=	0
Local nBkN		:=	0
Local nLen		:=	0
Local cCc		:=	""
Local cAprov	:=	""

/*If INCLUI .OR. ALTERA
	nLen:=len(aCols)
	If nLen > 0
		nBkN:=n
		nPosDel:=aCols[1,len(aCols[1])+1]
		For n:=1 to nLen
			If !aCols[n,nPosDel]
				cCc		:=	GdFieldGet("C7_CC")
				cAprov	:=	GdFieldGet("C7_APROV")
				//Fazer critica de UO diferente
			EndIf
		Next nPos	
		n:=nBkN
	EndIf
Else
	lRet:=.t.
EndIf*/
             
lRet:=.t.
	
RestArea(aAreaSAL)
RestArea(aArea)
Return lRet
