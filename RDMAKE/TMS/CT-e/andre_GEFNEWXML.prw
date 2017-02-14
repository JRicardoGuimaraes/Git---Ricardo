#Include 'Protheus.ch'

#Define MSN0001 "C.Custo "
#Define MSN0002 " Tabela "
#Define MSN0003 " Lote "
#Define MSN0004 " C.Custo PSA "
#Define MSN0005 " Cta. Despesa "
#Define MSN0006 "BR: Z-NO-NE"
#Define MSN0007 "TRANSPORTE SUBCONTRATADO COM A TERMACO TERM MAR CONT SERV ACESS LTDA"
#Define MSN0008 "CNPJ 11.552.312/0007-10 - IE:336.686.100.114"
#Define MSN0009 "Tipo Carreg.(MAN) : "
#Define MSN0010 " - No.CVA(MAN) : "
#Define MSN0011 " - No.Coleta Moniloc(MAN) : "


/*
Programa	: GEFNEWXML
Funcao		: Static Function NoteMessages
Data		: 04/01/2016
Autor		: André Costa
Descricao	: Função para controle das Mensagens que vão compor o CTESEFAZ
Sintaxe	: StaticCall( GEFNEWXML , NoteMessages , xObs , cAliasDT6 )
Utilizada	: CTESEFAZ
*/

Static Function NoteMessages( xObs , cAliasDT6 )
	Local aArea			:= GetArea()
	Local cAlias			:= GetNextAlias()
	Local xMen				:= ''
	Local xTes				:= ''
	Local xFormula		:= ''
	Local aDevedor		:= {}
	Local aRemetente		:= {}
	Local aDestinatario	:= {}
	Local aMen				:= {}

// Inicio da Mensagem IDMS DIFERIDO

	If ! Empty( xObs )
		aadd( aMen , xObs )
	EndIf

	If (cAliasDT6)->DT6_CLIREM+(cAliasDT6)->DT6_LOJREM + (cAliasDT6)->DT6_CLIDEV+(cAliasDT6)->DT6_LOJDEV $ GETMV("MV_XCLIDIF")
		aadd( aMen ,  AllTrim( GetNewPar("MV_XDESDIF","ICMS DIFERIDO CONFORME LEI RJ/6108/11" ) ) )
	EndIf

// Fim da Mensagem IDMS DIFERIDO


// Inicio da Mensagem de MG X MG

	DbSelectArea("SM4")

	Begin Sequence

		If ! ( SM0->M0_ESTENT == "MG" )
			Break
		EndIf

		aDevedor		:= GetAdvFVal("SA1",{"A1_INSCR"}	,xFilial("SA1")+(cAliasDT6)->(DT6_CLIDEV+DT6_LOJDEV),1,{""} )
		aRemetente		:= GetAdvFVal("SA1",{"A1_EST"}		,xFilial("SA1")+(cAliasDT6)->(DT6_CLIREM+DT6_LOJREM),1,{""} )
		aDestinatario	:= GetAdvFVal("SA1",{"A1_EST"}		,xFilial("SA1")+(cAliasDT6)->(DT6_CLIDES+DT6_LOJDES),1,{""} )

		If ( Empty( aDevedor[1] ) .Or. AllTrim( aDevedor[1] ) $ "ISENTO" )
			Break
		EndIf

		If ( ( aRemetente[1] # aDestinatario[1] ) .Or. ( aRemetente[1] # "MG" ) )
			Break
		EndIf

		aadd( aMen , Formula("014") )

	End Sequence
// Fim da Mensagem de MG X MG

// Inicio da Mensagem de Guaiba
	Begin Sequence

		If cFilAnt # "24"
			Break
		EndIf

		If Left( (cAliasDT6)->DT6_CDRORI,2 ) # "RS"
			Break
		EndIf

		xTes := GetAdvFVal('SD2','D2_TES',(cAliasDT6)->DT6_FILDOC + (cAliasDT6)->DT6_DOC + (cAliasDT6)->DT6_SERIE,3,"")

		If ! Empty( xTes )
			xFormula := GetAdvFVal('SF4','F4_FORMULA',xFilial('SF4')+xTes,1,"")
		EndIf

		If Empty( xFormula )
			xFormula := "016"
		EndIf

		aadd( aMen , Formula( xFormula ) )

	End Sequence
// Fim da Mensagem de Guaiba

// Inicio do Nome da Transportadora

	Begin Sequence

		If !( SubStr((cAliasDT6)->DT6_CCUSTO,1,3) $ GetMV("MV_XTLACC") )
			Break
		EndIf

		aSZ8 := GetAdvFVal("SZ8",{"Z8_CNPJTRA"},xFilial("SZ8")+(cAliasDT6)->DT6_LOTNFC,2,{} )

		If Empty( aSZ8[1] )
			Break
		EndIf

		aSA2 := GetAdvFVal("SA2",{"A2_NOME"},xFilial("SA2")+aSZ8[1],3,{})

		If Empty( aSA2[1] )
			Break
		EndIf

		aadd( aMen , AllTrim( FwNoAccent( aSA2[1] ) ) )

	End Sequence

// Fim do Nome da Transportadora

// Inicio -  Unificação de fontes do GPO - OBSERVAÇÃO GPO

	Begin Sequence

		DbSelectArea("DTQ")
		DbOrderNickName("XCTR")

		If !( DbSeek(xFilial("DTQ")+(cAliasDT6)->DT6_DOC+(cAliasDT6)->DT6_SERIE) )
			Break
		EndIf

		ZA6->( DbSetOrder(5) )

		If !( ZA6->( DbSeek( DTQ->DTQ_AS, .T.  ) ) .And. ! Empty(ZA6->ZA6_OBSVIA) )
			Break
		EndIf

		aadd( aMen , "Rota Cliente: " + Alltrim( ZA6->ZA6_OBSVIA ) )

	End Sequence

// Fim - Unificação de fontes do GPO

	For X := 1 To Len( aMen )

		If Empty( aMen[X] )
			Loop
		EndIf

		xMen += Alltrim( aMen[X] ) + IIf( X == Len( aMen ),''," /-/ ")

	Next X

	RestArea( aArea )

Return( xMen )



/*
Programa	: GEFNEWXML
Funcao		: Static Function ObsContMens
Data		: 04/01/2016
Autor		: André Costa
Descricao	: Função para controle das Mensagens que vão compor o CTESEFAZ
Sintaxe	: StaticCall( GEFNEWXML , ObsContMens , cAliasDT6 )
Utilizada	: CTESEFAZ
*/

Static Function ObsContMens( cAliasDT6 )
	Local aArea		:= GetArea()
	Local aMen			:= {}
	Local X			:= 0
	Local _cString	:= ''

	aadd( aMen, MSN0001 + AllTrim( (cAliasDT6)->DT6_CCUSTO ) + MSN0002 + AllTrim( (cAliasDT6)->DT6_TABFRE )  + MSN0003 + AllTrim( (cAliasDT6)->DT6_LOTNFC ) )  // C.Custo ## Tabela ## Lote

	If StaticCall( RTMSR27, IsCliPSA, (cAliasDT6)->DT6_CLIDEV , .F. )
		aMen[1] += MSN0004 + AllTrim((cAliasDT6)->DT6_CCONT) + MSN0005 + AllTrim((cAliasDT6)->DT6_CONTA)	// C.Custo PSA ## Conta Despesa
	EndIf

// Inicio - Mensagens para O FVL
	Begin Sequence

		If !( SubStr((cAliasDT6)->DT6_CCUSTO,1,3) $ GetMV("MV_XTLACC") )
			Break
		EndIf

		aSZ8 := GetAdvFVal("SZ8",{"Z8_VIN","Z8_MARCA","Z8_DESCMOD"},xFilial("SZ8")+(cAliasDT6)->DT6_LOTNFC,2, {} )

		If Empty( aSZ8[1] ) .Or. Empty( aSZ8[2] ) .Or. Empty( aSZ8[3] )
			Break
		EndIf

		aadd( aMen, "Chassi " + aSZ8[1] + " Marca " + AllTrim( FwNoAccent( aSZ8[2] ) )  + " Modelo " + AllTrim( aSZ8[3] ) )

	End Sequence
// Fim - Mensagens para O FVL

// Inicio SUBCONTRATACAO TERMACO para a filial Barueri(04)

	Begin Sequence

		If cFilAnt == "04"

			DTC->( dbsetorder(3) )

			If !( DTC->( DbSeek( xFilial("DTC")+(cAliasDT6)->( DT6_FILDOC + DT6_DOC + DT6_SERIE ) ) ) )
				Break
			EndIf

			If GetNewPar("MV_TERMACO", MSN0006) == AllTrim(DTC->DTC_XZONA)
				AADD(	aMen	,	GetNewPar("MV_TERMSG", MSN0007 ) )
				AADD(	aMen	,	MSN0008 )
			EndIf

			Break

		EndIf

	// Por: Ricardo Guimarães - Em: 30/06/2016 - Compatibilizar com a validação existente na tela de entrada de doc. Lote.
		// If	!( ( (cAliasDT6)->( DT6_CLIDEV + DT6_LOJDEV ) $ AllTrim( _cCliMAN ) ) .AND. ( !( SubStr((cAliasDT6)->DT6_CCUSTO,1,3) $ GetMV("MV_XOVLCC") ) ) )
		If	!( (cAliasDT6)->( DT6_CLIDEV + DT6_LOJDEV ) $ AllTrim( _cCliMAN ) ) .AND. !( SubStr((cAliasDT6)->DT6_CCUSTO,1,3) $ GetMV("MV_XOVLCC") )  		
			Break
		EndIf

		DTC->( dbsetorder(3) ) 			// Buscar informações da MAN na DTC

		xFind := (cAliasDT6)->(DT6_FILDOC + IIf( (cAliasDT6)->DT6_DOCTMS == "8",DT6_DOCDCO+DT6_SERDCO,DT6_DOC+DT6_SERIE ))

		If DTC->( DbSeek( xFilial("DTC")+ xFind ) )
			AADD( aMen , MSN0009 + DTC->DTC_TPCAR + MSN0010 + AllTrim(DTC->DTC_NUMCVA) + MSN0011 + AllTrim(DTC->DTC_COLMON) ) // Tipo Carreg.(MAN): ##  - No.CVA(MAN): ##  - No.Coleta Moniloc(MAN):
		EndIf

	End Sequence

// Fim SUBCONTRATACAO TERMACO para a filial Barueri(04)

	For X := 1 To Len( aMen )

		_cString +=	'<ObsCont xCampo="EMISSOR">'

		_cString +=  		"<xTexto>" + aMen[X] +"</xTexto>"

		_cString +=	"</ObsCont>"

	Next X

	RestArea( aArea )

Return( _cString )
