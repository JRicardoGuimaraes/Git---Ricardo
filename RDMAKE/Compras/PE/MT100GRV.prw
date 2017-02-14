#INCLUDE "RWMAKE.CH"
/****************************************************************************
* Programa......: MT100GRV                                                  *
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
User Function MT100GRV()
Local lRet		:=	.f.
Local aArea		:=	GetArea()
Local nPD1CC	:=	0
Local nPD1CNT	:=	0
Local nX		:=	0

For nX:=1 to len(aCols)
	If !aCols[nX][len(aCols[nX])]
		nPD1CC	:=aScan(aHeader,{|x| alltrim(x[2] ) == "D1_CC"})
		nPD1CNT	:=aScan(aHeader,{|x| alltrim(x[2] ) == "D1_CONTA"})
		lRet:=u_vldCntCC(aCols[nX][nPD1CC],aCols[nX][nPD1CNT])
		If !lRet
			exit
		EndIf
	EndIf
Next nX
RestArea(aArea)
Return lRet