#Include 'Protheus.ch'

#Define _PRODUTO 'NAO_EXISTE_SA5'


User Function A116ICOMP						// SchedComCol({"01","01"})

	Local oXML		:= PARAMIXB[1]
	Local aArea	:= GetArea()
	Local X		:= 0
	Local nVlrPrd	:= 0
	Local aItem	:= {}
	Local aItens	:= {}
	Local aAux		:= {}

	Begin Sequence

		If !( SDT->( DbSeek( xFilial+cCNPJ+cForn+cLoja+cNF+cSerie ) ) )
			MsgInfo( 'Documento ' + cNF + 'não encontrado na tabela de importação' , "Atenção" )
			Break
		EndIf

		If ValType( XmlChildEx(oXML:_INFCTE:_VPREST,"_COMP") ) == "U"
			Break
		EndIf

		SA5->( DbSetOrder(14) )

		aAux := If( ValType(oXML:_INFCTE:_VPREST:_COMP) == "O",{oXML:_INFCTE:_VPREST:_COMP},oXML:_INFCTE:_VPREST:_COMP)

		For X := 1 To Len( aAux )

			If ValType(aAux[X]:_xNome:Text) == "U" .And. Empty(aAux[X]:_xNome:Text)
				Loop
			EndIf

			xProduto	:= _PRODUTO
			nVlrPrd	:= 0

			If !( SA5->( DbSeek( xFilial() + cForn + cLoja + PadR( aAux[X]:_xNome:Text,TamSx3("A5_CODPRF")[1] ) ) ) )
				xProduto :=  SA5->A5_PRODUTO
			EndIf

			If ValType(aAux[X]:_vComp:Text) # "U" .And. ! Empty(aAux[X]:_vComp:Text)
				nVlrPrd := Val(aAux[X]:_vComp:Text)
			EndIf

			AADD(aItem	,	{"DT_ITEM"		,StrZero( Len(aItens) + 1 , TamSX3("DT_ITEM")[1] )	}	)
			AADD(aItem	,	{"DT_COD"		,xProduto													}	)
			AADD(aItem	,	{"DT_QUANT"	,1															}	)
			AADD(aItem	,	{"DT_VUNIT"	,nVlrPrd													}	)
			AADD(aItem	,	{"DT_TOTAL"	,nVlrPrd													}	)
//			AADD(aItem	,	{"DT_PICM"		,12															}	) 				// Busca pela aliquota correspondente

			aAdd(aItens , aClone(aItem) )

			aItem := {}

		Next X

	End Sequence

	RestArea(aArea)

Return( aItens )
