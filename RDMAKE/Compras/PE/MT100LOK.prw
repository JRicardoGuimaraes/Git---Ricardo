#INCLUDE "RWMAKE.CH"
/****************************************************************************
* Programa......: MT100LOK                                                  *
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
User Function MT100LOK()
Local _lRet		:=	.t.
Local aArea		:=	GetArea()
Local nPD1CC	:=	0
Local nPD1CNT	:=	0

Local _nColQtd		:=aScan(aHeader,{|x| alltrim(x[2] ) == "D1_QUANT" })
Local _nColVunit	:=aScan(aHeader,{|x| alltrim(x[2] ) == "D1_VUNIT" })
Local _nColPed		:=aScan(aHeader,{|x| alltrim(x[2] ) == "D1_PEDIDO"})
Local _nColItemPC	:=aScan(aHeader,{|x| alltrim(x[2] ) == "D1_ITEMPC"})
Local _nColItem		:=aScan(aHeader,{|x| alltrim(x[2] ) == "D1_ITEM"})
Local _nColProd		:=aScan(aHeader,{|x| alltrim(x[2] ) == "D1_COD"})

/*If !aCols[n][len(aCols[n])]
	nPD1CC	:=aScan(aHeader,{|x| alltrim(x[2] ) == "D1_CC"})
	nPD1CNT	:=aScan(aHeader,{|x| alltrim(x[2] ) == "D1_CONTA"})
	lRet:=u_vldCntCC(aCols[n][nPD1CC],aCols[n][nPD1CNT])
//	lRet:=u_vldCntCC(aCols[n][nPD1CC],CNATUREZ)
Else
	_lRet:=.t.
EndIf*/      


********************************************************
* Por: Ricardo   -   Em: 24/09/2008                    *
* Objetivo: Quando o doc.de entrada estiver linkado a  *
* um pedido de compra, não permitir alterar para maior *
* a quantidade ou valor unitário                       *
********************************************************

If !aCols[N][Len(aCols[N])]
	If !Empty(aCols[N,_nColPed])
		dbSelectArea("SC7") ; dbSetOrder(1)
		// Localizo o Pedido
	//	If dbSeek(xFilial("SC6")+aCols[N,_nColPed]+aCols[N,_nColItemPC]+aCols[N,_nColProd])
		If dbSeek(xFilial("SC7")+aCols[N,_nColPed]+aCols[N,_nColItemPC])
			If aCols[N,_nColQtd] > (SC7->C7_QUANT - SC7->C7_QUJE)  // Qtd.do Ped. - Qtd. já Entregue
				MsgAlert("Quantidade informada não pode ser maior que a qtd. comprada - qtd. já entregue.")
				_lRet := .F.
			EndIf
	
			If aCols[N,_nColVUnit] # (SC7->C7_PRECO)
				MsgAlert("Não é permitido alterar o valor de Compra na entrada do documento.")
				_lRet := .F.
			EndIf		
		EndIf
	EndIf
EndIf

RestArea(aArea)
Return _lRet
