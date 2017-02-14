/****************************************************************************
* Programa......: CT105TOK                                                  *
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
User Function CT105TOK()
Local lRet	:=	.f.
Local aArea	:=	GetArea()

//alert(1)
RestArea(aArea)
Return lRet