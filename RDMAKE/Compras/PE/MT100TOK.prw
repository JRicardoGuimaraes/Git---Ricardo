#INCLUDE "RWMAKE.CH"
/****************************************************************************
* Programa......: MT100TOK                                                  *
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
User Function MT100TOK()
Local lRet		:=	.f.
Local lRet2		:=	.f.
Local aArea		:=	GetArea()
Local nPD1CC	:=	0
Local nPD1CNT	:=	0
Local nX		:=	0

If AllTrim(FUNNAME()) $ "MATA920|TMSA200|TMSA500|TMSA050"
   Return .T.
EndIf   

/*For nX:=1 to len(aCols)
	If !aCols[n][len(aCols[n])]
		nPD1CC	:=aScan(aHeader,{|x| alltrim(x[2] ) == "D1_CC"})
		nPD1CNT	:=aScan(aHeader,{|x| alltrim(x[2] ) == "D1_CONTA"})
		lRet:=u_vldCntCC(aCols[n][nPD1CC],aCols[n][nPD1CNT])
		If !lRet
			exit
		EndIf
	Else
		lRet:=.t.
	EndIf
Next nX*/        

*-----------------------*
lRet2 := fVldPedido()
*-----------------------*

lRet:=.t.
*-----------------------*
lRet := VldNatuerza()
*-----------------------*

*-----------------------*
//lRet2 := fVldCtbCC()
*-----------------------*

RestArea(aArea)
Return lRet .and. lRet2


/****************************************************************************
* Programa......: MT100TOK                                                  *
* Autor.........: Ricardo de Oliveira                                       *
* Data..........: 14/11/2007                                                *
* Descricao.....: PE para não permitir incluir Documento de Entrada sem     *
*                 Natureza ( natureza em branco )                           *
*                                                                           *
*****************************************************************************
* Modificado por:                                                           *
* Data..........:                                                           *
* Motivo........:                                                           *
*                                                                           *
****************************************************************************/
*-----------------------------*
Static Function VldNatuerza()
*-----------------------------*
Local _cNat, _lRet := .T.
_cNat := MaFisRet(,"NF_NATUREZA")
_nColTes := aScan(aHeader,{|x| alltrim(x[2] ) == "D1_TES"})

If FUNNAME() $ "MATA920"
   Return .T.
EndIf   

ACols[1,_nColTes]

If Empty(_cNat) .and. POSICIONE("SF4",1,xFilial("SF4")+ACols[1,_nColTes],"F4_DUPLIC") = "S"
	Aviso("ATENÇÃO","Favor informar o Natureza do documento de entrada.",{"Ok"})
	_lRet := .F.
EndIf

Return _lRet       

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VLDCTBCC º Autor ³ Vitor Sbano        º Data ³  08/05/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina destinada a validar o lancto de Tit pagar - CCusto  º±±
±±º          ³ restringindo a existencia de Cta Ctb (conf Natureza)       º±±
±±º          ³ no cadastro SZN - Restricao Conta Contabil X CCusto        º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³ Solicitado por Vânia Cardoso                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 8.11 - Financeiro                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fVLDCTBCC

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//
Local lRet	:= .t.
Local _aArea := GetArea()
Local _nPosProd := aScan(aHeader,{|x| alltrim(x[2] ) == "D1_COD"})
Local _nPosCC   := aScan(aHeader,{|x| alltrim(x[2] ) == "D1_CC"})
Local _X        := 0
Local _cAlias   := Alias()
Local _lError   := .T.

If FUNNAME() $ "MATA920"
   Return .T.
EndIf   

For _X := 1 To Len(ACols)

	_mCTACTB	:=	""
	_mCCD		:=	""
	_nCONT		:=  0

	dbSelectArea("SB1") ; dbSetOrder(1)
	If dbSeek(xFilial("SB1")+ACols[_X,_nPosProd])
		_mCTACTB	:=	Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_XCONTA")
		_mCCD		:=	ACols[_X,_nPosCC]
		_nCONT		:=  0
	EndIf
	//
	DbSelectArea("SZN")
	DbSetOrder(1)
	If DbSeek(xFilial("SZN")+_mCTACTB)
		//
		_cString	:= ""
		//
		Do while !eof() .and. SZN->ZN_FILIAL == xFilial("SZN") .and. alltrim(SZN->ZN_CTACTB) == alltrim(_mCTACTB)
			//
			If alltrim(SZN->ZN_CCD) == alltrim(_mCCD)
				//
				_nCONT ++
				//		
			Endif   
			_cString	+=alltrim(SZN->ZN_CCD)+" ; "
			DbSkip()	
		Enddo       
		If _nCONT == 0
			//
			alert("Item " + StrZero(_X,3) + " - Conta Contabil (" + alltrim(_mCTACTB) + ") com lancamento(s) restrito(s) ao CCusto " + alltrim(_cString))
			lRet	:= .f.
			_lError := .F.
			//
		Else
			lRet	:= .t.
		Endif	
		//
	Else
		lRet	:= .t.	
	Endif

Next _X
	
RestArea(_aArea)
Return(_lError)

********************************************************
* Por: Ricardo   -   Em: 24/09/2008                    *
* Objetivo: Quando o doc.de entrada estiver linkado a  *
* um pedido de compra, não permitir alterar para maior *
* a quantidade ou valor unitário                       *
********************************************************
*------------------------------------------------------*
Static Function fVldPedido
*------------------------------------------------------*
Local _lRet := .T.
Local _nColPed		:= aScan(aHeader,{|x| alltrim(x[2] ) == "D1_PEDIDO"})
Local _lIteComPed   := .F.
Local _lIteSemPed   := .F.

If FUNNAME() $ "MATA920"
   Return .T.
EndIf   

For nX:=1 to len(aCols)
	If !aCols[nX][len(aCols[nX])]

		// O item de compra não está vinculado a nenhum pedido		
		If !Empty(aCols[nX,_nColPed])
			_lIteComPed := .T. 
		EndIf

		// O item de compra não está vinculado a nenhum pedido
		If Empty(aCols[nX,_nColPed])
			_lIteSemPed := .T. 
		EndIf
		
	EndIf
			
Next nX

If _lIteComPed .and. _lIteSemPed
	// MsgAlert("Documento de entrada baixando pedido não é permitido conter item sem estar vinculado a pedido.")
	Aviso("ATENÇÃO","Documento de entrada baixando pedido não é permitido conter item sem estar vinculado a pedido.",{"Ok"})	
	_lRet := .F.
EndIf

Return _lRet