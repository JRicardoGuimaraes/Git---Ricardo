#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

#DEFINE FIAT_PATH		"\Interfaces\TMS\PROTHEUS\OUT\FIAT\"
#DEFINE FIAT_BACKUP	"\Interfaces\TMS\PROTHEUS\OUT\FIAT\BACKUP\"
#DEFINE FILELOG		"ImportEDI.LOG"

/*
Programa    : GEFBRWEDI
Funcao      : GEFBRWEDI - MVC
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Principal - Controller
Uso         : Externo
Sintaxe     : GEFBRWEDI
Chamanda    : Menu
*/

User Function teste_EDI								// U_teste_EDI()
	Local aArea	:= GetArea()
	Local aCoors 	:= FWGetDialogSize( oMainWnd )

	Local oDlgPrinc
	Local oFWLayer

	Local oPane1
	Local oPane2
	Local oPane3
	Local oPane4

	Local cAlias01	:= GetNextAlias()
	Local cAlias02	:= GetNextAlias()
	Local cAlias03	:= GetNextAlias()
	Local cAlias04	:= GetNextAlias()

	Local nInterval		:= 40000
	Local bTimerAction	:= { || xAtualiza()  }

	Local aField		:= {	{ "PA8_FILORI" , "Filial" 	, 04 } ,;
								{ "PA8_ARQUIV" , "Arquivo" 	, 30 } }

	Local aLegenda	:=	{	{" Empty( PA8_FILORI ) .And.  Empty( PA8_OPERAC ) .And.  Empty( PA8_STATUS )"	,"BR_LARANJA"		,"EDI - Problemas na Leitura"	} ,;
								{"!Empty( PA8_FILORI ) .And. !Empty( PA8_OPERAC ) .And.  Empty( PA8_STATUS )"	,"BR_VERDE"		,"EDI - Não Processado"			} ,;
					 			{"!Empty( PA8_FILORI ) .And. !Empty( PA8_OPERAC ) .And. !Empty( PA8_STATUS )"	,"BR_VERMELHO"	,"EDI - Processado"				} }

	Private aOper 	:=	{	{ "1", "Operação - FTL" 			, "PA8_OPERAC == '6' .And. Empty( PA8_STATUS )" } ,;
								{ "2", "Operação - Milk Run"	, "PA8_OPERAC == 'M' .And. Empty( PA8_STATUS )" } ,;
								{ "3", "Operação - LineHaul"	, "PA8_OPERAC == 'T' .And. Empty( PA8_STATUS )" } ,;
								{ "4", "Inconsistencias do EDI"	, "PA8_OPERAC == ''	.And. Empty( PA8_STATUS )" } }

	Private oBrowse1
	Private oBrowse2
	Private oBrowse3
	Private oBrowse4

	DbSelectArea("PA8")
	PA8->(DbSetOrder(2))
	dbChangeAlias("PA8",cAlias01)

	DbSelectArea("PA8")
	PA8->(DbSetOrder(2))
	dbChangeAlias("PA8",cAlias02)

	DbSelectArea("PA8")
	PA8->(DbSetOrder(2))
	dbChangeAlias("PA8",cAlias03)

	DbSelectArea("PA8")
	PA8->(DbSetOrder(2))
	dbChangeAlias("PA8",cAlias04)

	AjustaSX6()

	Define MsDialog oDlgPrinc Title 'Registros de EDI - FIAT' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

	oFWLayer	:= FWLayer():New()
	oFWLayer:Init( oDlgPrinc, .F., .T. )

	oFWLayer:AddLine( 'UP', 50, .F. )
	oFWLayer:AddCollumn( '01' , 50, .T., 'UP' )
	oFWLayer:AddCollumn( '02' , 50, .T., 'UP' )

	oPanel1	:= oFWLayer:GetColPanel( '01', 'UP' )
	oPanel2	:= oFWLayer:GetColPanel( '02', 'UP' )

	oFWLayer:AddLine( 'DOWN', 50, .F. )
	oFWLayer:AddCollumn( '03' , 50, .T., 'DOWN' )
	oFWLayer:AddCollumn( '04' , 50, .T., 'DOWN' )

	oPanel3	:= oFWLayer:GetColPanel( '03' , 'DOWN' )
	oPanel4	:= oFWLayer:GetColPanel( '04', 'DOWN' )

	oBrowse1:= FWBrowse():New()
	oBrowse1:SetDataTable()
	oBrowse1:SetOwner( oPanel1 )
	oBrowse1:SetAlias( cAlias01 )
	oBrowse1:SetProfileID("1")
	oBrowse1:SetDescription("Operação - FTL")
	oBrowse1:SetFilterDefault("PA8_OPERAC == '6' .And. Empty( PA8_STATUS )")
	oBrowse1:OptionReport(.F.)
	oBrowse1:DisableConfig()

	For X := 1 To Len( aLegenda )
		ADD Legend Data aLegenda[X][1] Color aLegenda[X][2] Title aLegenda[X][3] Of oBrowse1
	Next X

	ADD Column oColumn Data { || PA8_FILORI } Title "Filial"	Size 04 OF oBrowse1
	ADD Column oColumn Data { || PA8_ARQUIV } Title "Arquivo"	Size 30 OF oBrowse1

	oBrowse1:Activate()

	oBrowse2:= FWBrowse():New()
	oBrowse2:SetDataTable()
	oBrowse2:SetOwner( oPanel2 )
	oBrowse2:SetAlias( cAlias02 )
	oBrowse2:SetProfileID("2")
	oBrowse2:SetDescription("Operação - Milk Run")
	oBrowse2:SetFilterDefault("PA8_OPERAC == 'M' .And. Empty( PA8_STATUS )")
	oBrowse2:OptionReport(.F.)
	oBrowse2:DisableConfig()

	For X := 1 To Len( aLegenda )
		ADD Legend Data aLegenda[X][1] Color aLegenda[X][2] Title aLegenda[X][3] Of oBrowse2
	Next X

	ADD Column oColumn Data { || PA8_FILORI } Title "Filial"	Size 04 OF oBrowse2
	ADD Column oColumn Data { || PA8_ARQUIV } Title "Arquivo"	Size 30 OF oBrowse2

	oBrowse2:Activate()


	oBrowse3:= FWBrowse():New()
	oBrowse3:SetDataTable()
	oBrowse3:SetOwner( oPanel3 )
	oBrowse3:SetAlias( cAlias03 )
	oBrowse3:SetProfileID("3")
	oBrowse3:SetDescription("Operação - LineHaul")
	oBrowse3:SetFilterDefault("PA8_OPERAC == 'T' .And. Empty( PA8_STATUS )")
	oBrowse3:OptionReport(.F.)
	oBrowse3:DisableConfig()

	For X := 1 To Len( aLegenda )
		ADD Legend Data aLegenda[X][1] Color aLegenda[X][2] Title aLegenda[X][3] Of oBrowse3
	Next X

	ADD Column oColumn Data { || PA8_FILORI } Title "Filial"	Size 04 OF oBrowse3
	ADD Column oColumn Data { || PA8_ARQUIV } Title "Arquivo"	Size 30 OF oBrowse3

	oBrowse3:Activate()

	oBrowse4:= FWBrowse():New()
	oBrowse4:SetDataTable()
	oBrowse4:SetOwner( oPanel4 )
	oBrowse4:SetAlias( cAlias04 )
	oBrowse4:SetProfileID("4")
	oBrowse4:SetDescription("Inconsistencias do EDI")
	oBrowse4:SetFilterDefault("PA8_OPERAC == ''	.And. Empty( PA8_STATUS )")
	oBrowse4:OptionReport(.F.)
	oBrowse4:DisableConfig()

	For X := 1 To Len( aLegenda )
		ADD Legend Data aLegenda[X][1] Color aLegenda[X][2] Title aLegenda[X][3] Of oBrowse4
	Next X

	ADD Column oColumn Data { || PA8_FILORI } Title "Filial"	Size 04 OF oBrowse4
	ADD Column oColumn Data { || PA8_ARQUIV } Title "Arquivo"	Size 30 OF oBrowse4

	oBrowse4:Activate()

   oTimer := TTimer():New( nInterval , bTimerAction , oDlgPrinc )
   oTimer:Activate()

	Activate MsDialog oDlgPrinc Center

	RestArea(aArea)

Return NIL

/*
Programa    : GEFBRWEDI
Funcao      : xAtualiza
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função de Atualização de Browse com novas informações
Uso         : Interno
Sintaxe     : xAtualiza()
Chamanda    : GEFBRWEDI
*/

Static Function xAtualiza
	Local aArea := GetArea()

	Begin Sequence

		If !( xBuscaFtp() )
			Break
		EndIf

		GEFIMPPA8()

		oBrowse4:SetFocus()
		oBrowse4:GoTop()
		oBrowse4:Refresh()

		oBrowse3:SetFocus()
		oBrowse3:GoTop()
		oBrowse3:Refresh()

		oBrowse2:SetFocus()
		oBrowse2:GoTop()
		oBrowse2:Refresh()

		oBrowse1:SetFocus()
		oBrowse1:GoTop()
		oBrowse1:Refresh()

	End Sequence

	RestArea( aArea )

Return

/*
Programa    : GEFBRWEDI
Funcao      : MenuDef - MVC
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Statica - Menus
Uso         : Interno
Sintaxe     : MenuDef()
Chamanda    : GEFBRWEDI
*/

Static Function MenuDef
    Local aRot := {}

    ADD OPTION aRot TITLE 'Executar EDI'	Action 'StaticCall(GEFBRWEDI , GEFEXPPA8 )'	OPERATION 6 ACCESS 0

Return aRot


/*
Programa    : GEFBRWEDI
Funcao      : GEFEXPPA8
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função de Exportação para EDI - FIAT
Uso         : Interno
Sintaxe     : GEFIMPPA8()
Chamanda    : MenuDef - Browse
*/


Static Function GEFEXPPA8
	Local aArea		:= GetArea()
	Local oBrowse	:= FwmBrwActive()
	Local xFilial	:= (oBrowse:oData:cAlias)->PA8_FILORI
	Local xArquivo	:= (oBrowse:oData:cAlias)->PA8_ARQUIV

	Begin Sequence

		If Empty( (oBrowse:oData:cAlias)->PA8_FILORI )
			ApMsgAlert("Registro com problemas.", "Atenção")
			(oBrowse:oData:cAlias)->(DbGoTOp())
			Break
		EndIf

		If ! ( u_IMPFIAT( xFilial ,, FIAT_PATH+xArquivo ) )
			Break
		EndIf

		DbSelectArea("PA8")
		DbSetOrder(2)

		lRlock := IIf( DbSeek( xFilial+xArquivo )  , .F. , .T. )

		Reclock("PA8", lRlock )

			PA8->PA8_STATUS	:= 'X'

		PA8->( MsUnlock() )

	End Sequence

	RestArea( aArea )

Return



/*
Programa    : GEFBRWEDI
Funcao      : GEFIMPPA8
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função de Importação dos arquivos do EDI
Uso         : Interno
Sintaxe     : GEFIMPPA8()
Chamanda    : GEFBRWEDI
*/


Static Function GEFIMPPA8

	Local aArea := GetArea()
	Local xFilial
	Local aDados
	Local nDados
	Local xStatus
	Local xMensagem
	Local X
	Local cDe		:= GetMv("MV_RELFROM")
	Local cPara		:= UsrRetMail( RetCodUsr() )
	Local cCc		:= ''
	Local cAssunto	:= 'Log de erro da Importação do EDI - FIAT'
	Local cMsg		:= 'Segue em anexo o arquivo com as informações de erro ocorridos na Importação.'
	Local cAnexo	:= '\SYSTEM\'+FILELOG
	Local lLog		:= .F.

	Begin Sequence

		Processa( { || aDados := CargaArray() } ,'Aguarde','Processando...',.F.)

		nDados	:= Len( aDados )

		If nDados == 0
			Aviso('Atenção','Não existem arquivos de EDI para serem Importados.',{"OK"})
			Break
		EndIf

		For X := 1 To Len( aDados )

			IncProc("Carregando Linha "+AllTrim(cValToChar( X ) )+" de "+AllTrim( cValToChar( nDados ) ) )

			Begin Sequence

				If !( CGC( aDados[X][3] ,, .F. )  )
					xMensagem := "O CNPJ " + aDados[X][3] + " esta Invalido."
					Break
				EndIf

				DbSelectArea( "SA1" )
				DbSetOrder(3)

				If !( SA1->( DbSeek( xFilial("SA1") + aDados[X][3]  ) ) )
					xMensagem := "O CNPJ " + aDados[X][3] + " é Inesistente."
					Break
				EndIf

				DbSelectArea( "DUY" )
				DbSetOrder( 3 )

				If !( DUY->( DbSeek( xFilial("DUY") + SA1->A1_MUN ) ) )
					xMensagem := "Filial não encontrada atraves do Municipio " + SA1->A1_MUN + "."
					Break
				EndIf

				If Empty( DUY->DUY_FILDES )
					xMensagem := "Filial esta vazia na Tabela DUY."
					Break
				EndIf

				If !( aDados[X][2] $ 'M|T|6' )
					xMensagem := "Tipo de Operação " + aDados[X][2] + " é Inesistente."
					Break
				EndIf

				xFilial		:= IIf( aDados[X][2] $ 'M|T','20',DUY->DUY_FILDES )
				xArquivo	:= aDados[X][1]
				xOperacao	:= aDados[X][2]

			Recover

				xFilial		:= xFilial("PA8")
				xArquivo	:= aDados[X][1]
				xOperacao	:= ''
				lLog		:= .T.

				StaticCall( GEFCNHAST , LogThis , CRLF + "Inicio do Arquivo " + aDados[X][1] + "." + CRLF + xMensagem + CRLF + "Fim do Arquivo "+ aDados[X][1]+CRLF , FILELOG )

			End Sequence

			DbSelectArea("PA8")
			DbSetOrder(2)

			lRlock := IIf( DbSeek( xFilial+xArquivo )  , .F. , .T. )

			Reclock("PA8", lRlock )

				PA8->PA8_FILORI := xFilial
				PA8->PA8_ARQUIV	:= xArquivo
				PA8->PA8_OPERAC	:= xOperacao

			PA8->( MsUnlock() )

		Next X

		If lLog

			u_EnvEmail( cDe , cPara , cCc , cAssunto , cMsg , cAnexo )

			FErase( cAnexo )

		EndIf

	End Sequence

	RestArea( aArea )

Return

/*
Programa    : GEFBRWEDI
Funcao      : Static CargaArray
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função a leitura do arquivo CSV
Uso         : Interno
Sintaxe     : CargaArray()
Chamanda    : GEFIMPPA8
*/

Static Function CargaArray

	Local aArea		:= GetArea()
	Local aDir		:= {}
	Local aDados	:= {}
	Local nDir		:= 0
	Local nHandle	:= 0
	Local X

	aDir := Directory( FIAT_PATH+"*.*","D" )

	nDir := Len( aDir )

	ProcRegua( nDir )

	For X := 1 To nDir

		IncProc("Carregando Linha "+AllTrim(cValToChar( X ) )+" de "+AllTrim( cValToChar( nDir ) ) )

		nHandle := Ft_Fuse( FIAT_PATH+aDir[X][1] )

		If nHandle == -1
			Loop
		EndIf

		FT_FGoTop()

		cLinha		:= Ft_FReadLn()

		xOperacao	:= Right( AllTrim( cLinha ) , 1 )
		xCNPJ	 	:= SubStr( AllTrim( cLinha ),154,14)

		aAdd( aDados, { aDir[X][1] , xOperacao , xCNPJ } )

		FT_FUse()

	Next X

	RestArea( aArea )

Return aDados

/*
Programa    : GEFBRWEDI
Funcao      : Static CargaArray
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função de importação dos arquivo do FTP da FIAT
Uso         : Interno
Sintaxe     : xBuscaFtp
Chamanda    : xAtualiza
*/

Static Function xBuscaFtp
	Local aRetDir	:= {}
	Local xFTP_FIAT	:= GetMv("MV_XFTPFIA")
	Local xUsuario	:= SubStr( xFTP_FIAT , 1 , At( ":",xFTP_FIAT) - 1 )
	Local xSenha	:= SubStr( xFTP_FIAT , At( ":",xFTP_FIAT) + 1 , ( At( "@",xFTP_FIAT) - At( ":",xFTP_FIAT) ) - 1 )
	Local xFTP		:= SubStr( xFTP_FIAT , At( "@",xFTP_FIAT) + 1  )
	Local lFTP		:= .T.

	Begin Sequence

		If ! FTPConnect( xFTP , 21 ,xUsuario, xSenha )
			ApMsgAlert("Não foi possivel conectar em " + xFTP, "Atenção")
			Break
		EndIf

		If ! FTPDirChange( "/OUT" )
			ApMsgAlert("Não foi possivel acessar o diretorio /OUT !! ", "Atenção")
			Break
		EndIf

		aRetDir := FTPDirectory( "*.*" , )

		If Len( aRetDir ) == 0
			ApMsgAlert("Não existe registros a serem baixados do FTP ", "Atenção")
			Break
		EndIf

		For X := 1 To Len( aRetDir )

			If ! FTPDownLoad( FIAT_PATH + aRetDir[X][1], aRetDir[X][1] )
				Loop
			EndIf
/*
			If ! FTPErase( aRetDir[X][1] )
				Loop
			EndIf
*/

		Next X

	Recover

		lFTP := .F.

	End Sequence

	If lFTP
		FTPDisconnect()
	EndIf

Return( lFTP )


/*
Programa	: GEFNEWXML
Funcao		: Função Estatica - AjustaSX6
Data		: 31/07/2015
Autor		: André Costa
Descricao	: Função de Apoio
Uso			: Ajusta os Parametros da Rotina Exportação de XML para Averbação
Sintaxe		: AjustaSX6()
Retorno		: Conteudo do Parametro
*/


Static Function AjustaSX6
	Local aArea 	:= GetArea()
	Local aRetorno	:= {}

	DbSelectArea("SX6")
	SX6->( DbSetOrder(1) )

	Begin Sequence

		If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XFTPFIA" , .F. ) )
			Conout('Parametro MV_XFTPFIA Criado')
			RecLock( "SX6",.T. )
				SX6->X6_VAR     := "MV_XFTPFIA"
				SX6->X6_TIPO    := "C"
				SX6->X6_CONTEUD := 'gefco:gefco123@ftp.gmdlogistica.com.br'
				SX6->X6_CONTSPA := 'gefco:gefco123@ftp.gmdlogistica.com.br'
				SX6->X6_CONTENG := 'gefco:gefco123@ftp.gmdlogistica.com.br'

				SX6->X6_DESCRIC := "Servidor de FTP da FIAT"
				SX6->X6_DESC1   := ""
				SX6->X6_DSCSPA  := "Servidor de FTP da FIAT"
				SX6->X6_DSCSPA1 := ""
				SX6->X6_DSCENG  := "Servidor de FTP da FIAT"
				SX6->X6_DSCENG1 := ""
			MsUnLock()
		EndIf

	End Sequence

	RestArea(aArea)

Return
