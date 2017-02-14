#Include 'Protheus.ch'


/*
Programa		: CNHNEWXML
Funcao			: Função Estatica CNHNEWXML
Data			: 09/11/2015
Autor			: André Costa
Descricao		: Colocação de Informações no XML da CNH
Uso				: CTESEFAZ.PRW
Sintaxe		: StaticCall( CNHNEWXML,CNHNEWXML,xChaveDT6 ,xChaveSA1 )
Retorno		:
*/

Static Function CNHNEWXML( xChaveDT6 ,xChaveSA1 )

	Local aArea		:= GetArea()

	Local _cString	:= ''
	Local cDF0_PLANID	:= ''
	Local cDF1_NUMPUR	:= ''

	Local aField		:= {'ShipmentID','OrderNum','PinNumber','OTM_Serv_Prov_XID'}
	Local aData		:= {}

	Local cES_CGCDEV	:= GetMv("ES_CGCDEV")
	Local aDT6NUMAGD	:= GetAdvFVal("DT6",{"DT6_NUMAGD","DT6_ITEAGD"},xChaveDT6,1,{} )
	Local cCGCDEV		:= SubStr( GetAdvFVal("SA1","A1_CGC" ,xChaveSA1,1,""),1,8)

	Local cCodGefco	:= AjustaSX6()[1]

	Begin Sequence

		If Len( aDT6NUMAGD ) == 0
			Break
		EndIf

		If !( cCGCDEV $ cES_CGCDEV )
			Break
		EndIf

		DbSelectArea( "DF0")
		DbSetOrder(1)

		If ! ( DbSeek( xFilial("DF0") + aDT6NUMAGD[1] ) )
			Break
		EndIf

		aadd( aData , { cValToChar(DF0->DF0_PLANID) } )

		DbSelectArea("DF1")
		DbSetOrder(1)

		If ! ( DbSeek( xFilial("DF1") + aDT6NUMAGD[1] + aDT6NUMAGD[2] ) )
			Break
		EndIf

		aadd( aData , { Alltrim( DF1->DF1_NUMPUR ) } )

		aadd(aData , {''} )
		aadd(aData , { cCodGefco } )

		For X := 1 To Len( aField )

			If Empty( aData[X][1] )
				Loop
			EndIf

			_cString +=	'<ObsCont xCampo="'+aField[X]+'">'

			_cString +=  		"<xTexto>" + aData[X][1] +"</xTexto>"

			_cString +=	"</ObsCont>"

		Next X

	End Sequence

	RestArea( aArea )

Return( _cString )


/*
Programa		: CNHNEWXML
Funcao			: Função Estatica CNHNEWXML
Data			: 09/11/2015
Autor			: André Costa
Descricao		: Imprimi as Mascaras do Campos solicitados pela CNH
Uso				: RTMSR27.PRW
Sintaxe		: StaticCall( CNHNEWXML,CNHXMLOBS )
Retorno		:
*/


Static Function CNHXMLOBS( xField )
	Local aArea		:= GetArea()
	Local lRetorno	:= .F.
	Local aField		:= {'ShipmentID','OrderNum','PinNumber','OTM_Serv_Prov_XID'}
	Local nPos			:= 0

	If aScan( aField , { |Z| Upper(xField) == Upper(Z) } ) > 0
		lRetorno := .T.
	EndIf

	RestArea(aArea)

Return( lRetorno )



/*
Programa		: CNHNEWXML
Funcao			: Função Estatica - AjustaSX6
Data			: 31/07/2015
Autor			: André Costa
Descricao		: Função de Apoio
Uso				: Ajusta os Parametros da Rotina Exportação de XML para Averbação
Sintaxe		: AjustaSX6()
Retorno		: Conteudo do Parametro
*/


Static Function AjustaSX6
	Local aArea 		:= GetArea()
	Local aRetorno	:= {}

	DbSelectArea("SX6")
	SX6->( DbSetOrder(1) )

	Begin Sequence

		If ( !MsSeek( Space( FWSizeFilial() ) + "ES_SERVPRV" , .F. ) )
			Conout('Parametro ES_SERVPRV Criado')
			RecLock( "SX6",.T. )
				SX6->X6_VAR     := "ES_SERVPRV"
				SX6->X6_TIPO    := "C"
				SX6->X6_CONTEUD := '9157'
				SX6->X6_CONTSPA := '9157'
				SX6->X6_CONTENG := '9157'

				SX6->X6_DESCRIC := "Codigo da GEFCO na CNH - Projeto OTM"
				SX6->X6_DESC1   := ""
				SX6->X6_DSCSPA  := "Codigo da GEFCO na CNH - Projeto OTM"
				SX6->X6_DSCSPA1 := ""
				SX6->X6_DSCENG  := "Codigo da GEFCO na CNH - Projeto OTM"
				SX6->X6_DSCENG1 := ""
			MsUnLock()
		EndIf

	End Sequence

	aRetorno := { GetMv("ES_SERVPRV") }

	RestArea(aArea)

Return(aRetorno)
