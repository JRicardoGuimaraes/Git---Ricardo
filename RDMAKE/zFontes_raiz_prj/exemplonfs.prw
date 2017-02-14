#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EmiteNFS  ºAutor  ³Irenio Saored e Olivº Data ³  29/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Emite a Nota Fiscal de Saida apos segunda pesagem       	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function Geranfs()

Local _xPedido, _xItem, _xSeq, _xQtdLib, _xPrcven, _xProduto, _xLocPD, _xISS, _xCond, _xTES
Local _xC9Rec, _xC5Rec, _xC6Rec, _xE4Rec, _xB1Rec, _xB2Rec, _xF4Rec
Local aPvlNfs := {}
LOCAL _aMVAnt		:= Array(4,1)
LOCAL _cPerg		:= "NFSIGW"
LOCAL _nCont		:= 1
LOCAL _dAux			:= M->dDataBase

_xPedido := SC5->C5_NUM
//cSerie   := SC5->C5_GEFSER  

//se a liberação já tenha sido feita (SC9) já existir...

Dbselectarea('SC9')
Dbseek(xFilial('SC9')+_xPedido)
While !eof() .and. SC9->C9_PEDIDO = _xPedido
	
	If RTRIM(SC9->C9_NFISCAL) == ''
		_xItem    := SC9->C9_ITEM
		_xSeq     := SC9->C9_SEQUEN
		SC5->(Dbsetorder(1))
		SC5->(Dbseek(xFilial("SC5")+_xPedido))
		_xCond := SC5->C5_CONDPAG
		_xC5Rec := SC5->(RecNo())
		SC6->(Dbsetorder(1))
		SC6->(Dbseek(xFilial("SC6")+_xPedido+_xItem))
		_xProduto := SC6->C6_PRODUTO
		_xTES     := SC6->C6_TES
		_xC6Rec := SC6->(RecNo())
		SE4->(Dbsetorder(1))
		SE4->(Dbseek(xFilial("SE4")+_xCond))
		_xE4Rec := SE4->(RecNo())
		SB1->(Dbsetorder(1))
		SB1->(Dbseek(xFilial("SB1")+_xProduto))
		_xB1Rec := SB1->(RecNo())
		SB2->(Dbsetorder(1))
		SB2->(Dbseek(xFilial("SB2")+_xProduto+SB1->B1_LOCPAD))
		_xB2Rec := SB2->(RecNo())
		SF4->(Dbsetorder(1))
		SF4->(Dbseek(xFilial("SF4")+_xTES))
		_xISS   := SF4->F4_ISS
		_xF4Rec := SF4->(RecNo())
		_xPrcven := SC9->C9_PRCVEN
		_xQtdlib := SC9->C9_QTDLIB
		_xC9Rec := SC9->(RecNo())
		
		aadd(aPvlNfs,{_xPedido,_xItem,_xSeq,_xQtdLib,_xPrcven,_xProduto,.F., ;
		_xC9Rec,_xC5Rec,_xC6Rec,_xE4Rec,_xB1Rec,_xB2Rec,_xF4Rec})

        AAdd(aPvlNfs,{cNumPed,"01","01",1,100,"999999999999999",.f.,;
    
	Endif
	Dbselectarea('SC9')
	Dbskip()
EndDo

//Chama a janela de serie de notas Fiscais

_lSerie := Sx5NumNota(cSerie)
Alert(_lSerie)
 
If !_lSerie
	MsgInfo('Escolha um serie !')
	//_lSerie := Sx5NumNota(cSerie)
	Return
Endif


/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funcao    ³MaPvlNfs  ³ Autor ³                       ³ Data ³28.08.1999³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Inclusao de Nota fiscal de Saida atraves do PV liberado     ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³ExpA1: Array com os itens a serem gerados                   ³
³          ³ExpC2: Serie da Nota Fiscal                                 ³
³          ³ExpL3: Mostra Lct.Contabil                                  ³
³          ³ExpL3: Mostra Lct.Contabil                                  ³
³          ³ExpL4: Aglutina Lct.Contabil                                ³
³          ³ExpL5: Contabiliza On-Line                                  ³
³          ³ExpL6: Contabiliza Custo On-Line                            ³
³          ³ExpL7: Reajuste de preco na nota fiscal                     ³
³          ³ExpN8: Tipo de Acrescimo Financeiro                         ³
³          ³ExpN9: Tipo de Arredondamento                               ³
³          ³ExpLA: Atualiza Amarracao Cliente x Produto                 ³
³          ³ExplB: Cupom Fiscal                                         ³
³          ³ExpCC: Numero do Embarque de Exportacao                     ³
³          ³ExpBD: Code block para complemento de atualizacao dos titu- ³
³          ³       los financeiros.                                     ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

cNota := MaPvlNfs(aPvlNfs,cSerie, .F., .F., .F., .F., .F., 0, 0, .F., .F.)
MsgInfo(cNota)     

If Rtrim(cNota) <> ''
	Msginfo('Nota Fiscal'+cnota+'gerada com sucesso','Geracao de NF')
Endif

Return