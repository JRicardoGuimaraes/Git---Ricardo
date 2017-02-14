#Include 'Protheus.ch'

/*
Programa	: MT116XMLCT
Funcao		: PE - MT116XMLCT
Data		: 15/07/2016
Autor		: André Costa
Descricao	: Este Ponto de Entrada é utilizado na rotina de Importação de XML de nota fiscal eletrônica, referente a conhecimento de transporte que disponibiliza o objeto XML para implementações diversas dos usuarios.
Uso			: Aletração da informação dos produtos do XML
Sintaxe	: PE
Chamada	: Interna
*/


User Function MT116XMLCT

	Local oXML			:= PARAMIXB[1]
	Local cNF			:= PARAMIXB[2]
	Local cSerie		:= PARAMIXB[3]
	Local cForn		:= PARAMIXB[4]
	Local cLoja		:= PARAMIXB[5]
	Local cTipo		:= PARAMIXB[6]
	Local cOpc			:= PARAMIXB[7]		//	PF - Produto Frete, PN - Produto na NF original
	Local aArea		:= GetArea()
	Local cCNPJ		:= oXml:_INFCTE:_EMIT:_CNPJ:TEXT
	Local xFilial		:= LoadFilial( oXml:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT )
	Local nQtdeField	:= SDT->(FCount())
	Local aQtdeField	:= {}
	Local nQtdeComp	:= IIf( ValType( oXml:_INFCTE:_VPREST:_COMP ) == 'A' , Len( oXml:_INFCTE:_VPREST:_COMP ) , 1 )
	Local aErro		:= {}
	Local xProduto

	Begin Sequence

		If !( SDT->( DbSeek( xFilial+cCNPJ+cForn+cLoja+cNF+cSerie ) ) )
			aadd( aErro, 'Documento ' + cNF + 'não encontrado na tabela de importação' )
		EndIf

		If Len( aErro ) # 0
			Break
		EndIf

		SA5->( DbSetOrder(14) )

		For X := 1 To nQtdeComp

			xProduto := 'NAO_EXISTE_SA5'

			If SA5->( DbSeek( xFilial()+cForn+cLoja+ Upper(oXml:_INFCTE:_VPREST:_COMP[X]:_XNOME:TEXT) ) )
				xProduto :=  SA5->A5_PRODUTO
			EndIf

			aadd( aQtdeField , {} )

			For Y := 1 To nQtdeField

				xConteudo := SDT->( FieldGet(Y) )

				If SDT->(Field(Y)) == "DT_ITEM"
					 xConteudo	:=	StrZero( X , TamSX3("DT_ITEM")[1] )
				ElseIf SDT->(Field(Y)) == "DT_COD"
					xConteudo	:=	xProduto
				ElseIf SDT->(Field(Y)) == "DT_QUANT"
					xConteudo	:=	1
				ElseIf SDT->(Field(Y)) $ "DT_VUNIT|DT_TOTAL"
					xConteudo	:=	Val( oXml:_INFCTE:_VPREST:_COMP[X]:_VCOMP:TEXT )
				EndIf

				aadd( aQtdeField[X] , { SDT->(Field(Y)) , xConteudo } )

			Next Y

		Next X

		RecLock("SDT",.F.)
			SDT->(DbDelete())
		SDT->( MsUnlock() )

		For X := 1 To Len( aQtdeField )

			RecLock("SDT",.T.)

				For Y := 1 To Len( aQtdeField[X] )
					SDT->( FieldPut( FieldPos( aQtdeField[X][Y][1] ) , aQtdeField[X][Y][2] ) )
				Next Y

			SDT->( MsUnlock() )

		Next X


	End Sequence

	RestArea( aArea )


Return


Static Function LoadFilial( xFilial )

	Local _xFilial

	aRet := {}

	OpenSM0()

	SM0->( DbGoTop() )

	While !SM0->(EOF())

		If SM0->M0_CGC # xFilial
			SM0->( DbSkip() )
		EndIf

		_xFilial := SM0->M0_CODFIL

		Exit


	Enddo

Return( _xFilial )



