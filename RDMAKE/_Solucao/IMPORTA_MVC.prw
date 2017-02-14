#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*
Programa    : GEFIMPPA7
Funcao      : User GEFIMPPA7 - MVC
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Principal para chamada via menu XNU
Uso         : Externo
Sintaxe     : GEFIMPPA7
Chamanda    : Menu - XNU
*/

User Function GEFIMPPA7			// u_GEFIMPPA7()
	Local aArea	:= GetArea()

	GEFIMPPA7()

	RestArea( aArea )

Return NIL



/*
Programa    : GEFIMPPA7
Funcao      : Static GEFIMPPA7 - MVC
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Principal para chamada via menu browse
Uso         : Interno
Sintaxe     : GEFIMPPA7
Chamanda    : Menu - Browse
*/


Static Function GEFIMPPA7
	Local aArea	:= GetArea()
	Local aDados	:= {}

	Begin Sequence

		aDados := CargaXLS()

		If !( aDados[2] )
			Break
		EndIf

		If Len( aDados[1] ) == 0
			Aviso("Atenção","Não existe registros para importação.",{"OK"})
			Break
		EndIf

		Processa( { || lOk := Runproc( aDados[1] ) } ,'Aguarde','Processando...',.F.)

	End Sequence

	RestArea( aArea )

Return NIL


/*
Programa    : GEFIMPPA7
Funcao      : Static CargaXLS
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função faz o carregamento do arquivo a ser importado
Uso         : Interno
Sintaxe     : CargaXLS
Chamanda    : GEFIMPPA7
*/


Static Function CargaXLS

	Local aPergs		:= {}
	Local aRet			:= {}
	Local aRetorno		:= {}
	Local lRetorno		:= .F.

	Local cArquivo		:= Padr("",150)
	Local cExtensao		:= 'Arquivo *.CSV|*.CSV|Arquivo *.XLS*|*.XLS*'

	Private cTemp		:= GetTempPath()
	Private cSystem		:= Upper( GetSrvProfString( "STARTPATH" , "" ) )
	Private cArqMacro	:= "XLS2DBF.XLA"
	Private aRet		:= {}

	aAdd( aPergs , { 6 , "Arquivo",cArquivo,"",,"",60,.T.,cExtensao,"C:\",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE } )

    If ParamBox( aPergs , "Importação de Dados" , aRet )

		aRetorno	:= IntegraArq()
		lRetorno	:= .T.

    EndIf

Return( { aRetorno , lRetorno } )

/*
Programa    : GEFIMPPA7
Funcao      : Static IntegraArq
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função de controle de Conversão do Arquivo em CSV e Leitura do Mesmo
Uso         : Interno
Sintaxe     : IntegraArq
Chamanda    : CargaXLS
*/


Static Function IntegraArq

	Local aRet				:= {}
	Local lConv			:= .T.

	Private cDiretorio	:= Upper( Alltrim( MV_PAR01 ) )
	Private cExtensao		:= SubStr( cDiretorio, Rat( ".",cDiretorio ) + 1  )
	Private cArquivo		:= SubStr( cDiretorio, Rat( "\",cDiretorio ) + 1 , Rat( ".",cDiretorio ) - Rat( "\",cDiretorio ) - 1 )

	If cExtensao $ 'XLS|XLSX'
		Processa( { || lConv := ConvArqs() },"Aguarde.","Convertendo arquivos" )
	EndIf

	If lConv
		Processa( { |lEnd| aRet := CargaArray( cArquivo ) } ,"Aguarde.","Carregando planilha...",.T.)
	EndIf

Return( aRet )

/*
Programa    : GEFIMPPA7
Funcao      : Static ConvArqs
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função de conversão do arquivo XLS* em CSV
Uso         : Interno
Sintaxe     : ConvArqs
Chamanda    : IntegraArq
*/

Static Function ConvArqs

	Local oExcelApp
	Local lRetorno	:= .F.

	Begin Sequence

		If File( cTemp+cArquivo+"."+cExtensao )
			fErase(cTemp+cArquivo)
		EndIf

		If !AvCpyFile(cDiretorio,cTemp+cArquivo+"."+cExtensao ,.F.)
			MsgInfo("Problemas na copia do arquivo "+cArquivo+" para "+cTemp+cArquivo+"."+cExtensao ,"AvCpyFile()")
			Break
		EndIf

		If !File(cTemp+cArqMacro)
			If !AvCpyFile(cSystem+cArqMacro,cTemp+cArqMacro,.F.)
				MsgInfo("Problemas na copia do arquivo "+cSystem+cArqMacro+"para"+cTemp+cArqMacro ,"AvCpyFile()")
				Break
			EndIf
		EndIf

		If File(cTemp+cArquivo+".CSV")
			fErase(cTemp+cArquivo+".CSV")
		EndIf

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cTemp+cArqMacro)
		oExcelApp:Run(cArqMacro+'!XLS2DBF',cTemp,cArquivo+"."+cExtensao)
		oExcelApp:WorkBooks:Close('savechanges := False')

		oExcelApp:Quit()
		oExcelApp:Destroy()

		fErase(cTemp+cArquivo+"."+cExtensao)

		lRetorno := .T.

	End Sequence

Return( lRetorno )

/*
Programa    : GEFIMPPA7
Funcao      : Static CargaArray
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função a leitura do arquivo CSV
Uso         : Interno
Sintaxe     : CargaArray
Chamanda    : IntegraArq
*/

Static Function CargaArray

	Local cLinha  := ""
	Local nLin    := 1
	Local nTotLin := 0
	Local aDados  := {}
	Local cFile   := cTemp + cArquivo + ".csv"
	Local nHandle := 0

	nHandle := Ft_Fuse(cFile)

	If nHandle == -1
		Return aDados
	EndIf

	FT_FGoTop()

	nLinTot := FT_FLastRec() - 1

	ProcRegua( nLinTot )

	Ft_FSkip()
	nLin++

	While !Ft_FEof()

		IncProc("Carregando Linha "+AllTrim(cValToChar( nLin ) )+" de "+AllTrim( cValToChar( nLinTot ) ) )
		nLin++

		cLinha := Ft_FReadLn()

		If Empty(AllTrim(StrTran(cLinha,';','')))
			Ft_FSkip()
			Loop
		EndIf

		cLinha := StrTran(cLinha,'"',"'")
		cLinha := '{"'+cLinha+'"}'

		cLinha := StrTran(cLinha,';','","')
		aAdd(aDados, &cLinha)

		FT_FSkip()

	End While


	FT_FUse()


	If File(cFile)
		FErase(cFile)
	EndIf

Return aDados


/*
Programa    : GEFIMPPA7
Funcao      : Static Runproc
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função o processamento dos dados a serem importados
Uso         : Interno
Sintaxe     : Runproc( aDados )
Chamanda    : GEFIMPPA7
*/


Static Function Runproc( aDados )

	Local lRet			:= .T.
	Local aHeader		:= PA7->( DbStruct() )
	Local aCampos		:= Nil
	Local Y
	Local cDe			:= GetMv("MV_RELFROM")
	Local cPara			:= UsrRetMail( RetCodUsr() )
	Local cCc			:= ''
	Local cAssunto		:= 'Log de erro da Importação da CNH - OTM'
	Local cMsg			:= 'Segue em anexo o arquivo com as informações de erro ocorridos na Importação.'
	Local cAnexo		:= '\SYSTEM\ImportCNH.LOG'
	Local nDados		:= Len( aDados )

	ProcRegua( nDados )

	For Y := 1 To Len( aHeader )

		aCampos	:= {}

		AADD( aCampos , { "PA7_FILIAL"	, ""								} )
		AADD( aCampos , { "PA7_LOCXID"	, Upper( aDados[Y][01] )			} )
		AADD( aCampos , { "PA7_CNPJ"	, aDados[Y][02]						} )
		AADD( aCampos , { "PA7_NOME"	, aDados[Y][03]						} )
		AADD( aCampos , { "PA7_MUN"	 	, aDados[Y][04]						} )
		AADD( aCampos , { "PA7_PAIS"	, aDados[Y][05]						} )
		AADD( aCampos , { "PA7_LOCAL"	, aDados[Y][06]						} )
		AADD( aCampos , { "PA7_CEP"		, StrTran( aDados[Y][07],"-",'' )	} )
		AADD( aCampos , { "PA7_LOCROL"	, aDados[Y][08]						} )
		AADD( aCampos , { "PA7_PLANT"	, aDados[Y][09]						} )
		AADD( aCampos , { "PA7_CALEND"	, aDados[Y][10]						} )
		AADD( aCampos , { "PA7_UF"		, aDados[Y][11]						} )

		If !Import( aCampos )
			lRet := .F.
		EndIf

		IncProc("Atualizando a Tabela "+AllTrim(cValToChar( Y ) )+" de "+AllTrim( cValToChar( nDados ) ) )

	Next Y

	If !lRet

		u_EnvEmail( cDe , cPara , cCc , cAssunto , cMsg , cAnexo )

		FErase( cAnexo )

	EndIf


Return lRet

/*
Programa    : GEFIMPPA7
Funcao      : Static Import - MVC
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função a importação dos Dados o processamento dos dados a serem importados
Uso         : Interno
Sintaxe     : Runproc( aDados )
Chamanda    : Runproc
*/


Static Function Import( aCampos )
	Local aArea		:= GetArea()
	Local nI			:= 0
	Local nPos			:= 0
	Local lRet			:= .T.
	Local aAux			:= {}
	Local cFileLog	:= 'ImportCNH.LOG'
	Local oModel
	Local oAux
	Local oStruct
	Local aErro
	Local X,Z
	Local lAux

	DbSelectArea( "PA7" )
	DbSetOrder( 1 )

	oModel := FWLoadModel( 'GEFINSPA7' )

	oModel:SetOperation( 3 )

	oModel:Activate()

	oAux	:= oModel:GetModel("FORMPA7")

	oStruct := oAux:GetStruct()

	aAux	:= oStruct:GetFields()

	For X := 1 To Len( aCampos )

		If ( nPos := aScan( aAux , { |Z| AllTrim( Z[3] ) == AllTrim(aCampos[X][1] ) } ) ) > 0

			If !( lAux := oModel:SetValue( "FORMPA7" , aCampos[X][1] , aCampos[X][2] ) )

				lRet := .F.

				Exit

			EndIf

		EndIf

	Next X

	If lRet

		If ( lRet := oModel:VldData() )

			oModel:CommitData()

		EndIf

	EndIf

	If !lRet

		aErro := oModel:GetErrorMessage()

		// A estrutura do vetor com erro é:
		// [1] identificador (ID) do formulário de origem
		// [2] identificador (ID) do campo de origem
		// [3] identificador (ID) do formulário de erro
		// [4] identificador (ID) do campo de erro
		// [5] identificador (ID) do erro
		// [6] mensagem do erro
		// [7] mensagem da solução
		// [8] Valor atribuído
		// [9] Valor anterior

		LogThis( CRLF +	"Id do campo de erro: "	+ '[' + AllToChar( aErro[4] ) + ']'	+ CRLF + ;
							"Id do erro: " 			+ '[' + AllToChar( aErro[5] ) + ']'	+ CRLF + ;
							"Mensagem do erro: " 	+ '[' + AllToChar( aErro[6] ) + ']'	+ CRLF + ;
							"Mensagem da solução: "	+ '[' + AllToChar( aErro[7] ) + ']'	+ CRLF + ;
							"Valor atribuído: "		+ '[' + AllToChar( aErro[9] ) + ']'	+ CRLF , cFileLog )

	EndIf

	oModel:DeActivate()

	RestArea( aArea )

Return( lRet )


/*
	Autor		: Andre Costa
	Data		: 22/04/2015
	Descricao	: Gera Log para a Importação
	Chamada	: Interna
	Sintaxe	: LogThis( cMensagem , xArquivo )
*/

Static Function LogThis( cMensagem , xArquivo )

	Local cConsole	:= IIf( !( __cInternet # Nil ), "Console","Schedule" )
	Local cArquivo	:= xArquivo
	Local xMensagem	:= "[" + DtoC( Date() ) + " " + Time() + " " + cConsole + "] " + cMensagem
	Local nHdlArq
	Local nTamArq

	Begin Sequence

		nHdlArq := FOpen( cArquivo , 2 + 64 )

		If nHdlArq < 0
			nHdlArq := FCreate( cArquivo )
		EndIf

		If nHdlArq < 0
			Conout("["+cArquivo+"] Erro ao abrir o arquivo de LOG: " + cArquivo )
			Break
		EndIf

		nTamArq := FSeek( nHdlArq , 0 , 2 )

		FWrite( nHdlArq, xMensagem + CRLF )

		FClose( nHdlArq )

	End Sequence

Return

