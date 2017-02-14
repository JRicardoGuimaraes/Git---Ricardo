#INCLUDE "RWMAKE.CH"
#INCLUDE "Protheus.CH"

***********************************************************************
* Cliente:  GEFCO                                                     *
* Programa: GEFCO01 - Axcadastro                                      *
* Autor: Papa                                          Data: 10/05/07 *
***********************************************************************
*Fun��o:   Atribuir C�digo do Produto de forma autom�tica, ou seja, � *
*          realizada uma pesquisa, por grupo de produtos e o c�digo � *
*          gerado para o pr�ximo.                                     *
***********************************************************************

User Function GEFCO01()

Local cProduto
Local cUltProd
Local cGrupo	:= Alltrim(M->B1_GRUPO)
Local nSizeGrp  := LEN(M->B1_GRUPO)
Local aAreaSB1  := GetArea("SB1")

If "MOD"$cGrupo
	RestArea(aAreaSB1)
	Return NIL
EndIf


DbSelectArea("SB1")
DbSetOrder(4) // Grupo + c�d. do produto
DbSeek(xFilial("SB1")+cGrupo)

If .Not. Found()
	cProduto := alltrim(cGrupo)+"0001"
Else
	Do While xFilial("SB1")=SB1->B1_FILIAL .AND. Left(SB1->B1_COD,4)== cGrupo .and. !EOF()
		cUltProd := Alltrim(SB1->B1_COD)
		dbskip()
	EndDo
	cProduto:=  alltrim(cGrupo)+strzero((val(substr(cUltProd,5,nSizeGrp))+1),4)

EndIF

RestArea(aAreaSB1)
Return cProduto
