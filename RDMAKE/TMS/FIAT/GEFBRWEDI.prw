#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

#DEFINE FIAT_PATH	"\Interfaces\TMS\PROTHEUS\OUT\FIAT\"
#DEFINE FIAT_BACKUP "\Interfaces\TMS\PROTHEUS\OUT\FIAT\BACKUP\"
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

User Function GEFBRWEDI								// U_GEFBRWEDI()
	Local aArea	 := GetArea()
	Local aCoors := FWGetDialogSize( oMainWnd )

	Local oDlgPrinc
	Local oFWLayer
	Local oPane01
	Local oPane02
	Local oPane03
	Local oPane04
		
	Local nInterval		:= 60000
	Local bTimerAction	:= { || xAtualiza()  }
	
	Local cAlias01	:= GetNextAlias()
	Local cAlias02	:= GetNextAlias()
	Local cAlias03	:= GetNextAlias()
	Local cAlias04	:= GetNextAlias()
		
	Local aFields	:= {	{ "Filial"	,"PA8_FILORI","C",TamSX3("PA8_FILORI")[1],0,"@!" } ,;
							{ "Arquivo"	,"PA8_ARQUIV","C",TamSX3("PA8_ARQUIV")[1],0,"@!" } }
							
	Local aLegenda :=	{	{" Empty( PA8_FILORI ) .And.  Empty( PA8_OPERAC ) .And.  Empty( PA8_STATUS )"	,"BR_LARANJA"	,"EDI - Problemas na Leitura"	} ,;
							{"!Empty( PA8_FILORI ) .And. !Empty( PA8_OPERAC ) .And.  Empty( PA8_STATUS )"	,"BR_VERDE"		,"EDI - Não Processado"			} ,; 
					 		{"!Empty( PA8_FILORI ) .And. !Empty( PA8_OPERAC ) .And. !Empty( PA8_STATUS )"	,"BR_VERMELHO"	,"EDI - Processado"				} }
					 		
	Private oBrowse01
	Private oBrowse02
	Private oBrowse03
	Private oBrowse04
	
	AjustaSX6()
	
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

	Define MsDialog oDlgPrinc Title 'Registros de EDI - FIAT' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

	oFWLayer	:= FWLayer():New()
	oFWLayer:Init( oDlgPrinc, .F., .T. )

	oFWLayer:AddLine( 'UP', 50, .F. )
	oFWLayer:AddCollumn( '01' , 50, .T., 'UP' )
	oFWLayer:AddCollumn( '02' , 50, .T., 'UP' )

	oPanel01	:= oFWLayer:GetColPanel( '01', 'UP' )
	oPanel02	:= oFWLayer:GetColPanel( '02', 'UP' )

	oFWLayer:AddLine( 'DOWN', 50, .F. )
	oFWLayer:AddCollumn( '03' , 50, .T., 'DOWN' )
	oFWLayer:AddCollumn( '04' , 50, .T., 'DOWN' )

	oPanel03	:= oFWLayer:GetColPanel( '03' , 'DOWN' )
	oPanel04	:= oFWLayer:GetColPanel( '04', 'DOWN' )

	aRotina	:= MenuDef()

	oBrowse01:= FWmBrowse():New()
	oBrowse01:SetOwner( oPanel01 )
	oBrowse01:SetDescription( "Operação - FTL" )
	oBrowse01:SetAlias( cAlias01 )
	oBrowse01:DisableDetails()
	oBrowse01:SetFields( aFields )
	oBrowse01:SetFilterDefault( "PA8_OPERAC == '6' .And. Empty( PA8_STATUS ) " )
	oBrowse01:SetProfileID( '1' )
	oBrowse01:SetAmbiente( .F. )
	oBrowse01:SetWalkThru(.F.)
	oBrowse01:OptionReport(.F.)
	oBrowse01:SetSeek(.F.,{})

	For X := 1 To Len( aLegenda )
		oBrowse01:AddLegend(aLegenda[X][1],aLegenda[X][2],aLegenda[X][3])
	Next x
	
	oBrowse01:ForceQuitButton()	
	oBrowse01:Activate()

	oBrowse02:= FWmBrowse():New()
	oBrowse02:SetOwner( oPanel02 )
	oBrowse02:SetDescription( "Operação - Milk Run" )
	oBrowse02:SetAlias( cAlias02 )
	oBrowse02:DisableDetails()
	oBrowse02:SetFields( aFields )
	oBrowse02:SetFilterDefault( "PA8_OPERAC == 'M' .And. Empty( PA8_STATUS )" )	
	oBrowse02:SetProfileID( '2' )
	oBrowse02:SetAmbiente( .F. )
	oBrowse02:SetWalkThru(.F.)
	oBrowse02:OptionReport(.F.)
	oBrowse02:SetSeek(.F.,{})
	
	For X := 1 To Len( aLegenda )
		oBrowse02:AddLegend(aLegenda[X][1],aLegenda[X][2],aLegenda[X][3])
	Next x
	
	oBrowse02:ForceQuitButton()
	oBrowse02:Activate()

	oBrowse03:= FWmBrowse():New()
	oBrowse03:SetOwner( oPanel03 )
	oBrowse03:SetDescription( "Operação - LineHaul" )
	oBrowse03:SetAlias( cAlias03 )
	oBrowse03:DisableDetails()
	oBrowse03:SetFields( aFields )
	oBrowse03:SetFilterDefault( "PA8_OPERAC == 'T' .And. Empty( PA8_STATUS )" )	
	oBrowse03:SetProfileID( '3' )
	oBrowse03:SetAmbiente( .F. )
	oBrowse03:SetWalkThru(.F.)
	oBrowse03:OptionReport(.F.)
	oBrowse03:SetSeek(.F.,{})
	
	For X := 1 To Len( aLegenda )
		oBrowse03:AddLegend(aLegenda[X][1],aLegenda[X][2],aLegenda[X][3])
	Next x
	
	oBrowse03:ForceQuitButton()
	oBrowse03:Activate()

	oBrowse04:= FWmBrowse():New()
	oBrowse04:SetOwner( oPanel04 )
	oBrowse04:SetDescription( "Inconsistencias do EDI" )
	oBrowse04:SetAlias( cAlias04 )
	oBrowse04:DisableDetails()
	oBrowse04:SetFields( aFields )
	oBrowse04:SetFilterDefault( "PA8_OPERAC == '' .And. Empty( PA8_STATUS )" )	
	oBrowse04:SetProfileID( '4' )
	oBrowse04:SetAmbiente( .F. )
	oBrowse04:SetWalkThru(.F.)
	oBrowse04:OptionReport(.F.)
	oBrowse04:SetSeek(.F.,{})
	
	For X := 1 To Len( aLegenda )
		oBrowse04:AddLegend(aLegenda[X][1],aLegenda[X][2],aLegenda[X][3])
	Next x
	
	oBrowse04:ForceQuitButton()
	oBrowse04:Activate()
	
	oBrowse01:SetFocus()
	
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
				
		oBrowse04:ChangeTopBot(.T.)
		oBrowse03:ChangeTopBot(.T.)
		oBrowse02:ChangeTopBot(.T.)
		oBrowse01:ChangeTopBot(.T.)

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
		
		lIMPFIAT := u_IMPFIAT( xFilial ,, FIAT_PATH+xArquivo )
		
		If lIMPFIAT 
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
		
			If File( FIAT_PATH + aRetDir[X][1] )
				Loop 
			EndIf    	    	
	
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
