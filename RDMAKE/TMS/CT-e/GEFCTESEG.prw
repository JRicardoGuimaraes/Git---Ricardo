#Include 'Protheus.ch'


/*
Programa		: GEFCTESEG
Funcao			: Função Estatica GEFCTESEG
Data			: 09/11/2015
Autor			: André Costa
Descricao		: Trata do Seguro especifico da GEFCO
Uso				: CTESEFAZ
Sintaxe		: StaticCall( GEFCTESEG,GEFCTESEG )
Retorno		:
*/

Static Function GEFCTESEG( xAlias )

	Local aArea		:= GetArea()
	Local cString		:= ''
	Local cRespSeg	:= '4'
	Local nValMer		:= 0
	Local cPosIniCC
	Local cPosFimCC

	DbSelectArea("SA1")

	aSA1 := GetAdvFVal("SA1",{"A1_XAPOLIC","A1_XSEGURA"},xFilial("SA1")+(xAlias)->DT6_CLIDEV+(xAlias)->DT6_LOJDEV,1,{"",""})

	Begin Sequence

		If !( Empty( aSA1[1] ) )

			cRespSeg	:= '5'
			cApolice	:= aSA1[1]
			cNomSeg	:= aSA1[2]

			Break

		EndIf

		cPosIniCC := Left( AllTrim( (xAlias)->DT6_CCUSTO ), 1)
		cPosFimCC := Right( AllTrim( (xAlias)->DT6_CCUSTO ), 1)

		_cFormula := "SG1"										// Formula Geral - Fora Grupo

		If cPosIniCC == '1' .And. cPosFimCC $ '1|2|3|4|'		// PSA - FVL
			_cFormula := "SG2"

		ElseIf cPosIniCC == '2' .And. cPosFimCC $ '3|4|'		// OVL
			_cFormula := "SG3"

		EndIf

		DbSelectArea("SM4")

		cNomSeg	:= SubStr(Formula(_cFormula)[1],7,25)		// Seguradora
		cApolice	:= SubStr(Formula(_cFormula)[3],7,30)		// No. da Apolice

	End Sequence

	nValMer := StaticCall( CTESEFAZ, ConvType , (xAlias)->DT6_VALMER , 15, 2)

	cString 	+=	'<seg>'
	cString 	+= 		'<respSeg>'	+ NoAcentoCte(AllTrim(cRespSeg))	+	'</respSeg>'
	cString 	+=		'<xSeg>'		+ NoAcentoCte(AllTrim(cNomSeg))		+	'</xSeg>'
	cString 	+=		'<nApol>'		+ NoAcentoCte(AllTrim(cApolice))	+	'</nApol>'
	cString 	+=		'<vCarga>'		+ nValMer								+	'</vCarga>'
	cString 	+=	'</seg>'

	RestArea( aArea )

Return( cString )
