#Include 'Protheus.ch'   /// Teste Comit
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

User Function GEFBRWEDI								// U_GEFBRWEDI()
	Local aArea	:= GetArea()
	Local aCoors	:= FWGetDialogSize( oMainWnd )

	Local oDlgPrinc 	:= Nil
	Local oFWLayer	:= Nil

	Local bTimerAction	:= { || xAtualiza() , xAtuBrowse()  }

	Local cAlias01 := GetNextAlias()
	Local cAlias02 := GetNextAlias()
	Local cAlias03 := GetNextAlias()
	Local cAlias04 := GetNextAlias()

	Local cPerg	:= Padr("GEFBRWEDI",10)

	Local aFields	:= {	{ "Filial"		,"PA8_FILORI","C",TamSX3("PA8_FILORI")[1],0,"@!" } ,;
							{ "Arquivo"	,"PA8_ARQUIV","C",TamSX3("PA8_ARQUIV")[1],0,"@!" } }

	Local aLegenda :=	{	{" PA8_FILORI == 'EE'  .And.  PA8_OPERAC = 'E'	 .And.  Empty( PA8_STATUS )								"	,"BR_LARANJA"		,"EDI - Problemas na Leitura"	} ,;
							{"!Empty( PA8_FILORI ) .And. !Empty( PA8_OPERAC ) .And.  Empty( PA8_STATUS )								"	,"BR_VERDE"		,"EDI - Não Processado"			} ,;
					 		{"!Empty( PA8_FILORI ) .And. !Empty( PA8_OPERAC ) .And. !Empty( PA8_STATUS ) .And. PA8_STATUS # 'D'	"	,"BR_AZUL"			,"EDI - Processado"				} ,;
					 		{"!Empty( PA8_FILORI ) .And. !Empty( PA8_OPERAC ) .And. !Empty( PA8_STATUS ) .And. PA8_STATUS = 'D'	"	,"BR_VERMELHO"	,"EDI - Deletado pelo Usuario"	} }



	Private oPanel01 := Nil
	Private oPanel02 := Nil
	Private oPanel03 := Nil
	Private oPanel04 := Nil

	Private oBrowse01 := Nil
	Private oBrowse02 := Nil
	Private oBrowse03 := Nil
	Private oBrowse04 := Nil

	AjustaSX6()
	AjustaPA8()

	xAtualiza()

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

	If ( PswAdmin(,,__cUserID) == 0 )
		SetKey( VK_F12, { || AjustaParam() } )
	EndIf

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
	oBrowse01:SetFilterDefault( "PA8_OPERAC == '6' " )
	oBrowse01:SetProfileID( 'oBrowse01' )
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
	oBrowse02:SetFilterDefault( "PA8_OPERAC == 'M' " )
	oBrowse02:SetProfileID( 'oBrowse02' )
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
	oBrowse03:SetFilterDefault( "PA8_OPERAC == 'T' " )
	oBrowse03:SetProfileID( 'oBrowse03' )
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
	oBrowse04:SetDescription( "Inconsistências do EDI" )
	oBrowse04:SetAlias( cAlias04 )
	oBrowse04:DisableDetails()
	oBrowse04:SetFields( aFields )
	oBrowse04:SetFilterDefault( "PA8_OPERAC == 'E'" )
	oBrowse04:SetProfileID( 'oBrowse04' )
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

    oTimer := TTimer():New( ( MV_PAR01 * 60000 ) , bTimerAction , oDlgPrinc )

    oTimer:Activate()

	Activate MsDialog oDlgPrinc Center

	If ( PswAdmin(,,__cUserID) == 0 )
		SetKey( VK_F12 , { || } )
	EndIf

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

		MV_PAR01 := GetMv("MV_XFTPMIN",.T.,6)
		MV_PAR02 := GetMv("MV_XMOVARQ")
		MV_PAR03 := GetMv("MV_XUSREXC")
		MV_PAR04 := GetMv("MV_XBKPEXC")
		MV_PAR05 := GetMv("MV_XUSRLIP")
		MV_PAR06 := GetMv("MV_XFTPEXC")

	End Sequence

	RestArea( aArea )

Return

/*
Programa    : GEFBRWEDI
Funcao      : Função Estatica - Atualiza os Browses
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Statica
Uso         : Interno
Sintaxe     : xAtuBrowse()
Chamanda    : GEFBRWEDI
*/

Static Function xAtuBrowse
	oBrowse04:ChangeTopBot(.T.)
	oBrowse03:ChangeTopBot(.T.)
	oBrowse02:ChangeTopBot(.T.)
	oBrowse01:ChangeTopBot(.T.)
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

	ADD OPTION aRot Title 'Executar EDI'	Action 'StaticCall(GEFBRWEDI , GEFEXPPA8 )'	OPERATION 6 ACCESS 0
	ADD OPTION aRot Title 'Visualizar'		Action 'StaticCall(GEFBRWEDI , GEFVILPA8 )'	OPERATION 7 ACCESS 0

	If ( cUserName $ MV_PAR03 )
		ADD OPTION aRot Title 'Excluir'			Action 'StaticCall(GEFBRWEDI , GEFEXCPA8 )'	OPERATION 8 ACCESS 0
	EndIf

    If ( cUserName $ MV_PAR05 )
    	ADD OPTION aRot Title 'Limpar Tabela'	Action 'StaticCall(GEFBRWEDI , GEFDELPA8 )'	OPERATION 9 ACCESS 0
    EndIf

Return aRot


/*
Programa    : GEFBRWEDI
Funcao      : GEFVILPA8
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função de Visualização do Erro do EDI - FIAT
Uso         : Interno
Sintaxe     : GEFVILPA8()
Chamanda    : MenuDef - Browse
*/


Static Function GEFVILPA8
	Local aArea 		:= GetArea()
	Local oBrowse		:= FwmBrwActive()
	Local xPA8_DESERR := 'Necessario criar o campo MEMO PA8_DESERR na tabela PA8'
	Local xTexto		:= IIf( FieldPos("PA8_DESERR") = 0 , xPA8_DESERR , Upper( (oBrowse:oData:cAlias)->PA8_DESERR ) )
	Local xFilial		:= (oBrowse:oData:cAlias)->PA8_FILORI
	Local xArquivo	:= (oBrowse:oData:cAlias)->PA8_ARQUIV
	Local lReadOnly	:= .T.
	Local lPixel		:= .T.
	Local lNoVScroll	:= .T.
	Local lNoBorder	:= .T.
	Local oDlg			:= Nil

	Begin Sequence

		If xFilial # 'EE'
			ApMsgAlert("Visualização do EDI somente nas Inconsistências.", "Atenção")
			Break
		EndIf

		If Empty( xTexto )
			ApMsgAlert("Registro Antigo sem informação de Erro disponivel.", "Atenção")
			Break
		EndIf

		Define Dialog oDlg Title "Erro do Arquivo de EDI - FIAT" From 180,180 To 370,700 Pixel

		oTMultiget1 := TMultiGet():New(01,01,{|u|if(Pcount()>0,xTexto:=u,xTexto)},oDlg,260,92,;
		/*[oFont]*/	,/*[ lHScroll]*/	,/*[uParam9]*/	,/*[uParam10]*/	,/*[uParam11]*/	,lPixel		,/*[uParam13]*/,;
		/*[uParam14]*/,/*[bWhen]*/		,/*[uParam16]*/	,/*[uParam17]*/	,lReadOnly			,/*[bValid]*/	,/*[uParam20]*/,;
		/*[uParam21]*/,lNoBorder			,lNoVScroll )

		Activate Dialog oDlg Centered

	End Sequence

	RestArea( aArea )
Return



/*
Programa    : GEFBRWEDI
Funcao      : GEFDELPA8
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função de Limpeza da Tebala do EDI - FIAT
Uso         : Interno
Sintaxe     : GEFDELPA8()
Chamanda    : MenuDef - Browse
*/


Static Function GEFDELPA8
	Local aArea := GetArea()

	cQuery := "Delete From " + RetSqlName("PA8")
	cQuery += " Where	PA8_STATUS	 <> '' "

	TCSqlExec( cQuery )

	oBrowse04:ChangeTopBot(.T.)
	oBrowse03:ChangeTopBot(.T.)
	oBrowse02:ChangeTopBot(.T.)
	oBrowse01:ChangeTopBot(.T.)

	RestArea( aArea )
Return



/*
Programa    : GEFBRWEDI
Funcao      : GEFEXCPA8
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função de Deletação do EDI - FIAT
Uso         : Interno
Sintaxe     : GEFEXCPA8()
Chamanda    : MenuDef - Browse
*/


Static Function GEFEXCPA8
	Local aArea		:= GetArea()
	Local oBrowse		:= FwmBrwActive()
	Local xFilial		:= (oBrowse:oData:cAlias)->PA8_FILORI
	Local xArquivo	:= (oBrowse:oData:cAlias)->PA8_ARQUIV

	Begin Sequence

		DbSelectArea("PA8")
		DbSetOrder(2)

		If ! ( DbSeek( xFilial+xArquivo ) )
			Aviso("Atenção","Arquivo "+AllTrim(xArquivo)+" não encontrado na PA8.")
			Break
		EndIf

		If ( MV_PAR04 == 1 )

			If ! ( __CopyFile( FIAT_PATH+AllTrim(xArquivo), FIAT_BACKUP+AllTrim(xArquivo) ) )
				Aviso("Atenção","Arquivo "+AllTrim(xArquivo)+" não copiado para o diretorio " + FIAT_BACKUP )
				Break
			EndIf

		EndIf

		Reclock("PA8", .F. )
			PA8->PA8_STATUS	:= 'D'
		PA8->( MsUnlock() )

	End Sequence

	RestArea( aArea )

Return


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
	Local oBrowse		:= FwmBrwActive()
	Local xFilial		:= (oBrowse:oData:cAlias)->PA8_FILORI
	Local xArquivo	:= (oBrowse:oData:cAlias)->PA8_ARQUIV
	Local lIMPFIAT	:= .F.

	Begin Sequence

		If Empty( (oBrowse:oData:cAlias)->PA8_FILORI )
			ApMsgAlert("Registro com problemas.", "Atenção")
			(oBrowse:oData:cAlias)->(DbGoTOp())
			Break
		EndIf

		lIMPFIAT := u_IMPFIAT( xFilial ,, FIAT_PATH+AllTrim(xArquivo) )

		If !( lIMPFIAT )
			Break
		EndIf

		DbSelectArea("PA8")
		DbSetOrder(2)

		If ! ( DbSeek( xFilial+xArquivo ) )
			Aviso("Atenção","Arquivo "+AllTrim(xArquivo)+" não encontrado na PA8.")
			Break
		EndIf

		If ( MV_PAR02 == 1 )

			If ! ( __CopyFile( FIAT_PATH+AllTrim(xArquivo), FIAT_BACKUP+AllTrim(xArquivo) ) )
				Aviso("Atenção","Arquivo "+AllTrim(xArquivo)+" não copiado para o diretorio " + FIAT_BACKUP )
				Break
			EndIf

			If FErase( FIAT_PATH+AllTrim(xArquivo) ) == -1
				Aviso("Atenção","Arquivo "+AllTrim(xArquivo)+" não foi deletado do diretorio " + FIAT_PATH )
			EndIf

		EndIf

		Reclock("PA8", .F. )

			PA8->PA8_STATUS	:= 'P'

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
	Local cDe			:= GetMv("MV_RELFROM")
	Local cPara		:= UsrRetMail( RetCodUsr() )
	Local cCc			:= ''
	Local cAssunto	:= 'Log de erro da Importação do EDI - FIAT'
	Local cMsg			:= 'Segue em anexo o arquivo com as informações de erro ocorridos na Importação.'
	Local cAnexo		:= '\SYSTEM\'+FILELOG
	Local lLog			:= .F.

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

				xFilial	:= IIf( aDados[X][2] $ 'M|T','20',DUY->DUY_FILDES )
				xArquivo	:= aDados[X][1]
				xOperacao	:= aDados[X][2]

			Recover

				xFilial	:= 'EE'
				xArquivo	:= aDados[X][1]
				xOperacao	:= 'E'

				StaticCall( GEFCNHAST , LogThis , CRLF + "Inicio do Arquivo " + aDados[X][1] + "." + CRLF + xMensagem + CRLF + "Fim do Arquivo "+ aDados[X][1]+CRLF , FILELOG )

			End Sequence

			DbSelectArea("PA8")
			DbSetOrder(2)

			If ! ( DbSeek( xFilial+xArquivo ) )

				Reclock("PA8", .T. )

					PA8->PA8_FILORI	:= xFilial
					PA8->PA8_ARQUIV	:= xArquivo
					PA8->PA8_OPERAC	:= xOperacao

					If FieldPos("PA8_DESERR") > 0
						PA8->PA8_DESERR	:= IIf( Empty( xMensagem ) ,'',xMensagem )
					EndIf

				PA8->( MsUnlock() )

				lLog := .T.

			EndIf

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

	Local aArea	:= GetArea()
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
	Local aRetDir		:= {}
	Local xFTP_FIAT	:= GetMv("MV_XFTPFIA")
	Local xUsuario	:= SubStr( xFTP_FIAT , 1 ,	At( ":",xFTP_FIAT) - 1 )
	Local xSenha		:= SubStr( xFTP_FIAT , 		At( ":",xFTP_FIAT) + 1 , ( At( "@",xFTP_FIAT) - At( ":",xFTP_FIAT) ) - 1 )
	Local xFTP			:= SubStr( xFTP_FIAT , 		At( "@",xFTP_FIAT) + 1  )
	Local lFTP
	Local xMensagem	:= ''
	Local xHoraIni	:= Time()

	xMensagem := 'Incio do Processo do EDI - FIAT (FTP) ' + DtoC( Date() ) +" as "+ xHoraIni + CRLF

	Begin Sequence

		lFTP := FTPConnect( xFTP , 21 ,xUsuario, xSenha )

		If ! ( lFTP )
			xMensagem += "Não foi possivel conectar em "	+ xFTP + CRLF
			ApMsgAlert("Não foi possivel conectar em "	+ xFTP, "Atenção")
			Break
		EndIf

		If ! FTPDirChange( "/OUT" )
			xMensagem += "Não foi possivel acessar o diretorio /OUT." + CRLF
			ApMsgAlert("Não foi possivel acessar o diretorio /OUT.", "Atenção")
			Break
		EndIf

		aRetDir := FTPDirectory( "*.*" , )

		If Len( aRetDir ) == 0
			xMensagem += "Nao existem registros a serem baixados do FTP - EDI FIAT" + CRLF
			Break
		EndIf

		For X := 1 To Len( aRetDir )

			If File( FIAT_PATH + aRetDir[X][1] )
				Loop
			EndIf

			If ! FTPDownLoad( FIAT_PATH + aRetDir[X][1], aRetDir[X][1] )
				xMensagem += "Impossivel baixar o arquivo de EDI FIAT " + aRetDir[X][1] + CRLF
				Loop
			EndIf

			xMensagem += "	Foi baixado do FTP o arquivo " + aRetDir[X][1] + CRLF

			If ( MV_PAR06 == 1 )
				If ! FTPErase( aRetDir[X][1] )
					Loop
				EndIf
			EndIf
		Next X

	End Sequence

	xMensagem += 'Fim do Processo do EDI - FIAT (FTP) ' + DtoC( Date() ) +" as "+ Time() + " Tempo Decorrido "+ ElapTime( xHoraIni , Time() ) + CRLF

	Conout( xMensagem )

	FTPDisconnect()

Return( lFTP )


/*
Programa	: GEFBRWEDI
Funcao		: Função Estatica - AjustaSX6
Data		: 31/07/2015
Autor		: André Costa
Descricao	: Função de Apoio
Uso			: Ajusta os Parametros da Rotina Exportação de XML para Averbação
Sintaxe	: AjustaSX6()
Retorno	: Conteudo do Parametro
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

		If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XFTPMIN" , .F. ) )
			Conout('Parametro MV_XFTPMIN Criado')
			RecLock( "SX6",.T. )
				SX6->X6_VAR     := "MV_XFTPMIN"
				SX6->X6_TIPO    := "N"
				SX6->X6_CONTEUD := '6'
				SX6->X6_CONTSPA := '6'
				SX6->X6_CONTENG := '6'

				SX6->X6_DESCRIC := "Minutos para Atualização da Tela"
				SX6->X6_DESC1   := "do EDI FIAT"
				SX6->X6_DSCSPA  := "Minutos para Atualização da Tela"
				SX6->X6_DSCSPA1 := "do EDI FIAT"
				SX6->X6_DSCENG  := "Minutos para Atualização da Tela"
				SX6->X6_DSCENG1 := "do EDI FIAT"
			MsUnLock()
		EndIf

		If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XUSREXC" , .F. ) )
			Conout('Parametro MV_XUSREXC Criado')
			RecLock( "SX6",.T. )
				SX6->X6_VAR     := "MV_XUSREXC"
				SX6->X6_TIPO    := "C"
				SX6->X6_CONTEUD := ''
				SX6->X6_CONTSPA := ''
				SX6->X6_CONTENG := ''

				SX6->X6_DESCRIC := "Usuarios que pode excluir arquivos"
				SX6->X6_DESC1   := "do Browse do EDI FIAT"
				SX6->X6_DSCSPA  := "Usuarios que pode excluir arquivos"
				SX6->X6_DSCSPA1 := "do Browse do EDI FIAT"
				SX6->X6_DSCENG  := "Usuarios que pode excluir arquivos"
				SX6->X6_DSCENG1 := "do Browse do EDI FIAT"
			MsUnLock()
		EndIf

		If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XMOVARQ" , .F. ) )
			Conout('Parametro MV_XMOVARQ Criado')
			RecLock( "SX6",.T. )
				SX6->X6_VAR     := "MV_XMOVARQ"
				SX6->X6_TIPO    := "N"
				SX6->X6_CONTEUD := '1'
				SX6->X6_CONTSPA := '1'
				SX6->X6_CONTENG := '1'

				SX6->X6_DESCRIC := "Mover o Arquivo Processado para"
				SX6->X6_DESC1   := "o diretorio de Backup"
				SX6->X6_DSCSPA  := "Mover o Arquivo Processado para"
				SX6->X6_DSCSPA1 := "o diretorio de Backup"
				SX6->X6_DSCENG  := "Mover o Arquivo Processado para"
				SX6->X6_DSCENG1 := "o diretorio de Backup"
			MsUnLock()
		EndIf

		If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XBKPEXC" , .F. ) )
			Conout('Parametro MV_XBKPEXC Criado')
			RecLock( "SX6",.T. )
				SX6->X6_VAR     := "MV_XBKPEXC"
				SX6->X6_TIPO    := "N"
				SX6->X6_CONTEUD := '1'
				SX6->X6_CONTSPA := '1'
				SX6->X6_CONTENG := '1'

				SX6->X6_DESCRIC := "Mover o Arquivo Excluido para"
				SX6->X6_DESC1   := "o diretorio de Backup"
				SX6->X6_DSCSPA  := "Mover o Arquivo Excluido para"
				SX6->X6_DSCSPA1 := "o diretorio de Backup"
				SX6->X6_DSCENG  := "Mover o Arquivo Excluido para"
				SX6->X6_DSCENG1 := "o diretorio de Backup"
			MsUnLock()
		EndIf

		If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XUSRLIP" , .F. ) )
			Conout('Parametro MV_XUSRLIP Criado')
			RecLock( "SX6",.T. )
				SX6->X6_VAR     := "MV_XUSRLIP"
				SX6->X6_TIPO    := "C"
				SX6->X6_CONTEUD := ''
				SX6->X6_CONTSPA := ''
				SX6->X6_CONTENG := ''

				SX6->X6_DESCRIC := "Usuarios que pode Limpar a tabela"
				SX6->X6_DESC1   := "PA8 do EDI FIAT"
				SX6->X6_DSCSPA  := "Usuarios que pode Limpar a tabela"
				SX6->X6_DSCSPA1 := "PA8 do EDI FIAT"
				SX6->X6_DSCENG  := "Usuarios que pode Limpar a tabela"
				SX6->X6_DSCENG1 := "PA8 do EDI FIAT"
			MsUnLock()
		EndIf

		If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XFTPEXC" , .F. ) )
			Conout('Parametro MV_XFTPEXC Criado')
			RecLock( "SX6",.T. )
				SX6->X6_VAR     := "MV_XFTPEXC"
				SX6->X6_TIPO    := "N"
				SX6->X6_CONTEUD := '2'
				SX6->X6_CONTSPA := '2'
				SX6->X6_CONTENG := '2'

				SX6->X6_DESCRIC := "Deletar os Arquivos do FDT"
				SX6->X6_DESC1   := "do EDI FIAT"
				SX6->X6_DSCSPA  := "Deletar os Arquivos do FDT"
				SX6->X6_DSCSPA1 := "do EDI FIAT"
				SX6->X6_DSCENG  := "Deletar os Arquivos do FDT"
				SX6->X6_DSCENG1 := "do EDI FIAT"
			MsUnLock()
		EndIf

	End Sequence

	RestArea(aArea)

Return

/*
Programa	: GEFBRWEDI
Funcao		: Função Estatica - AjustaParam
Data		: 01/02/2017
Autor		: André Costa
Descricao	: Função de Apoio
Uso			: Ajusta os Parametros do Relatorio
Sintaxe	: AjustaParam()
Chamenda	: Interna
Retorno	: Logico
*/

Static Function AjustaParam

	Local aParamBox	:= {}
	Local aRet			:= {}
	Local lCanSave	:= .F.
	Local lUserSave	:= .T.
	Local cLoad		:= "GEFBRWEDI"
	Local cInterval	:= Space(10)
	Local aRadio		:= {"Sim","Não"}

	If ( PswAdmin(,,__cUserID) == 0 )
		SetKey( VK_F12 , { || } )
	EndIf

	cInterval :=  PadR( cValToChar( MV_PAR01 ) , 10 )

	aAdd(aParamBox,{ 01 , "Atualizar em quantos Minutos " 	, cInterval 	,"@!"	,"","","",50,.T.})

	If ( PswAdmin(,,__cUserID) == 0 )
    	aAdd(aParamBox,{ 03 , "Mover Arquivos para o Bsckup "		, 1	,aRadio,50,"",.T.})
		aAdd(aParamBox,{ 11 , "Usuarios que podem Excluir "			,MV_PAR03,".T.",".T.",.T.})
		aAdd(aParamBox,{ 03 , "Fazer backup da Exclusao "			, 1	,aRadio,50,"",.T.})
		aAdd(aParamBox,{ 11 , "Usuarios da Limpeza da PA8 "			,MV_PAR05,".T.",".T.",.T.})
		aAdd(aParamBox,{ 03 , "Retirar do FTP o Arquivo Baixado "	, 2,aRadio,50,"",.T.})
    EndIf

	If	ParamBox(aParamBox,"Configuração do Browse EDI - FIAT",@aRet,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPosX*/,/*nPosy*/,/*oDlgWizard*/,cLoad,lCanSave,lUserSave)
		PutMV("MV_XFTPMIN", MV_PAR01)
		PutMV("MV_XMOVARQ", MV_PAR02)
		PutMV("MV_XUSREXC", MV_PAR03)
		PutMV("MV_XBKPEXC", MV_PAR04)
		PutMV("MV_XUSRLIP", MV_PAR05)
		PutMV("MV_XFTPEXC", MV_PAR06)
		xAtualiza()
	EndIf

	If ( PswAdmin(,,__cUserID) == 0 )
		SetKey( VK_F12, { || AjustaParam() } )
	EndIf

Return


/*
Programa	: GEFBRWEDI
Funcao		: Função Estatica - AjustaPA8
Data		: 01/02/2017
Autor		: André Costa
Descricao	: Função de Apoio
Uso			: Ajusta os Campos da Tabela PA8
Sintaxe	: AjustaPA8()
Chamenda	: Interna
Retorno	: Logico
*/

Static Function AjustaPA8

	Local aArea 		:= GetArea()
	Local aArquivo	:= {}

	Begin Sequence

		DbSelectArea("PA8")

		If FieldPos("PA8_DESERR") > 0
			Break
		EndIf

		PA8->(DbCloseArea())

		X31UPDTABLE("PA8")

		CHKFILE("PA8")

	End Sequence

	RestArea( aArea )

Return
