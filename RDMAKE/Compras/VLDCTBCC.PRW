#INCLUDE "rwmake.ch"

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

User Function VLDCTBCC

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//
Local	lRet	:= .t.
Local _nPosProd := 0
Local _nPosCC   := 0

//
_mOldArea	:=	alias()
_mOldInde	:=	IndexOrd()
_mOldRecn	:=	Recno()   

//  
If AllTrim(FunName()) == "MATA110"
	// Solicitação de Compras
	_nPosProd := aScan(aHeader,{|x| alltrim(x[2] ) == "C1_PRODUTO"})
	_nPosCC   := aScan(aHeader,{|x| alltrim(x[2] ) == "C1_CC"})

	dbSelectArea("SB1") ; dbSetOrder(1)
	If dbSeek(xFilial("SB1")+ACols[N,_nPosProd])
		_mCTACTB	:=	Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_XCONTA")
		// _mCCD		:=	ACols[N,_nPosCC]
		_mCCD		:= 	M->C1_CC
		
	EndIf
ElseIf AllTrim(FunName()) == "MATA121"
	// Solicitação de Compras
	_nPosProd := aScan(aHeader,{|x| alltrim(x[2] ) == "C7_PRODUTO"})
	_nPosCC   := aScan(aHeader,{|x| alltrim(x[2] ) == "C7_CC"})

	dbSelectArea("SB1") ; dbSetOrder(1)
	If dbSeek(xFilial("SB1")+ACols[N,_nPosProd])
		_mCTACTB	:=	Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_XCONTA")
		// _mCCD		:=	ACols[N,_nPosCC]
		_mCCD		:=	M->C7_CC
		
	EndIf	
ElseIf AllTrim(FunName()) $ "MATA103|MATA140|RPC|TMSA200|GEFWMS01" // Pré Nota - Por: Ricardo - Em: 15/03/2011
	// Documento de Entrada
	_nPosProd := aScan(aHeader,{|x| alltrim(x[2] ) == "D1_COD"})
	_nPosCC   := aScan(aHeader,{|x| alltrim(x[2] ) == "D1_CC"})

	dbSelectArea("SB1") ; dbSetOrder(1)
	If dbSeek(xFilial("SB1")+ACols[N,_nPosProd])
		_mCTACTB	:=	Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_XCONTA")
//		_mCCD		:=	ACols[N,_nPosCC]
		_mCCD		:=	M->D1_CC
	EndIf                                      
ElseIf AllTrim(FunName()) $ "GEFAFRETE|GEFM079"	// Compra de Frete FVL
	_mCTACTB	:=	"711101"
	_mCCD		:=	M->D1_CC	// SOMENTE PARA TESTAR - REMOVER                   
Else
	_mCTACTB	:=	Posicione("SED",1,xFilial("SED")+M->E2_NATUREZ,"ED_CONTA")
//	_mCTACTB	:=	"711101"
	_mCCD		:=	M->E2_CCONT 
//	_mCCD		:=	M->D1_CC	// SOMENTE PARA TESTAR - REMOVER                   
//	_mCTACTB	:=	Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_XCONTA")	
EndIf
	
_nCONT		:=  0
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
		alert("Conta Contabil ("+alltrim(_mCTACTB)+") com lancamento(s) restrito(s) ao CCusto "+alltrim(_cString))
		lRet	:= .f.
		//
	Else
		lRet	:= .t.
	Endif	
	//
Else
	lRet	:= .t.	
Endif
//
dbSelectArea(_mOldArea)
dbSetOrder(_mOldInde)
DbGoto(_mOldRecn)
//
Return(lRet)
