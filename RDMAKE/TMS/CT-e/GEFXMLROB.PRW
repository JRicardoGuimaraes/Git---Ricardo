#Include "Protheus.CH"


/*
Programa	: GEFXMLROB
Funcao		: Usuario GEFXMLROB
Data		: 31/07/2015
Autor		: Andr� Costa
Descricao	: Fun��o de contorle
Chamada	: Schedule / Menu
Sintaxe	: GEFXMLROB
*/


User Function GEFXMLROB						// u_GEFXMLROB()
	Local aArea := GetArea()

	StartJob("U_IniGefXmlRob",GetEnvServer(),.F.,1)
	StartJob("U_IniGefXmlRob",GetEnvServer(),.F.,2)

	RestArea( aArea )
Return




/*
Programa	: GEFXMLROB
Funcao		: Static GEFXMLROB
Data		: 31/07/2015
Autor		: Andr� Costa
Descricao	: Fun��o de Controle
Chamada	: GEFXMLROB
Sintaxe	: GEFXMLROB()
*/


User Function IniGefXmlRob( X , P1 , P2 )
	Local aArea		:= GetArea()
	Local cFunName	:= FunName()
	Local lSchedule	:= xSchedule()
	Local xIdEnt		:= ''
	Local xMensagem	:= ''
	Local cDe			:= ''
	Local cPara		:= ''
	Local cCc			:= ''
	Local cAnexo		:= ''
	Local cRpcEmp		:= '01'
	Local cRpcFil		:= '01'
	Local cEnvMod		:= '43'
	Local cAssunto	:= 'Log da exporta��o dos CTe�S para AVERBA��O'
	Local cMsg			:= 'Segue em anexo o arquivo com as informa��es do processo de Exporta��o de XML para AVERBA��O dos CTe�S - '
	Local aCTE			:= {}
	Local aQuery		:= {}
	Local aTipArq		:= {	{"1","199_","Normal" 	} ,	;
								{"2","200_","Cancelado"	}	;
							}
	Local TRAB
	Local cArquivo

	Local xHoraIni
	Local xQtde
	Local xQtdeExp
	Local dDataIni
	Local _cPatchCopia
	Local _cDirColab
	Local _cWhere

	If lSchedule
		RpcSetType( 3 )
		RpcSetEnv( cRpcEmp,cRpcFil,/*cEnvUser*/,/*cEnvPass*/,cEnvMod,cFunName,/*aTables*/,/*lShowFinal*/,/*lAbend*/,/*lOpenSX*/,/*lConnect*/ )
	EndIf

	AjustaSX6()

	dDataIni	:= DtoS( FirstDate( dDataBase ) - 7 )
	dDataFim	:= DtoS( LastDate( dDataBase ) )

	_cPatchCopia	:= GetMV("MV_XXMLROB")
	_cDirColab		:= GetMV("MV_XARQCOL")

	cArquivo	:= "CTE_"+aTipArq[X][3]+".LOG"
	cAnexo		:= '\SYSTEM\' + cArquivo

	xHoraIni	:= Time()

	xQtde		:= 0
	xQtdeExp	:= 0

	cDe			:= GetMv("MV_RELFROM")
	cPara		:= IIf( lSchedule , GetMv("MV_XUSRROB") , UsrRetMail( RetCodUsr() ) )

	xMensagem := 'Incio do Processo de Averbacao em ' + DtoC( Date() ) +" as "+ xHoraIni + CRLF

	If Select( "TRAB" ) # 0
		( TRAB )->( DbCloseArea() )
	EndIf

	TRAB := GetNextAlias()

	StaticCall( GEFCNHAST , LogThis, "Iniciando o processo de Exporta��o da AVERBA��O do CTE ", cArquivo )

	Begin Sequence

		_cWhere := " And DT6.D_E_L_E_T_ = ''	"

		If X # 1
			_cWhere := " And DT6.D_E_L_E_T_ = '*'	"
		EndIf

		xMensagem += '	Selecionando Registros de CTe ' + aTipArq[X][3] + CRLF

		_cWhere	:= "%" + _cWhere	+ "%"

		BeginSql Alias TRAB

			Select	DT6.D_E_L_E_T_,DT6_FILDOC,DT6_DOC,DT6_SERIE,DT6_CHVCTE,DT6_DATEMI,DT6_XCTERO

			From	%Table:DT6010%	DT6


			Where (		DT6.DT6_DATEMI BetWeen %Exp:dDataIni% And %Exp:dDataFim%
						And DT6.DT6_XCTERO = ''
						And	DT6.DT6_IDRCTE =	'100'
						And	DT6.DT6_SERIE	 =	'5'
					)

			%Exp:_cWhere%

			Order By DT6_FILDOC

		EndSql

		aQuery := GetLastQuery()

		( TRAB )->( DbGoTop() )

		If ( TRAB )->( Eof() )
			xMensagem += '		Nao foram encontrados registros para serem Processados na DT6' + CRLF
			Break
		EndIf

		aArqColab := Directory( _cDirColab + aTipArq[X][2] + "*.*" , "D" )

		xMensagem += '		Selecionado ' + cValToChar( Len( aArqColab ) ) +' Arquivos do Colaboracao do tipo ' + aTipArq[X][2] + CRLF

		While ( TRAB )->( !Eof() )

			lOkCTE := .F.
			lColab := .F.
			lCopia	:= .F.

			For Y := 1 To Len( aArqColab )

				nHandle := FT_FUse( _cDirColab + aArqColab[Y][1] )

				If nHandle = -1
					Loop
				EndIf

				FT_FGoTop()

				While ! FT_FEOF() .And. ! lOkCTE

					If ( TRAB )->( DT6_CHVCTE ) $ FT_FReadLn()
						lOkCTE := .T.
					EndIf

					FT_FSKIP()

				End While

				FT_FUse()

				If ! ( lOkCTE )
					Loop
				EndIf

				lCopia :=  __CopyFile( _cDirColab + aArqColab[Y][1] , _cPatchCopia + aTipArq[X][2] + ( TRAB )->( DT6_CHVCTE )+ ".XML" )

				If ! ( lCopia )
					xMensagem += "		Problema ao copiar o Arquivo " +  _cDirColab + aArqColab[Y][1] + " para " + _cPatchCopia + aTipArq[X][2] + ( TRAB )->( DT6_CHVCTE )+ ".XML" + CRLF
				EndIf

				lColab := .T.

				Exit

			Next Y

			If ! ( lOkCTE )

				Begin Sequence

					xIdEnt := GetIdEnt( cEmpAnt , ( TRAB )->( DT6_FILDOC ) )

					If Empty( xIdEnt )
						Break
					EndIf

					If !( SpedPExp( xIdEnt , ( TRAB )->( DT6_FILDOC ) , ( TRAB )->( DT6_SERIE	) , ( TRAB )->( DT6_DOC ) , _cPatchCopia , StoD( ( TRAB )->( DT6_DATEMI ) ) ) )
						Break
					EndIf

					lOkCTE := .T.
					lCopia := .T.

				End Sequence

			EndIf

			If lOkCTE

				If lCopia

					DbSelectArea("DT6")

					DT6->( MsSeek( xFilial("DT6") + ( TRAB )->( DT6_FILDOC+DT6_DOC+DT6_SERIE ) ) )

					RecLock("DT6",.F.)

						DT6->DT6_XCTERO	:= cValToChar( X )
//						DT6->DT6_XCTEDT	:= FWTimeStamp( 2 )

					DT6->( MsUnlock() )

					xQtdeExp++

				EndIf

			EndIf

			StaticCall( GEFCNHAST , LogThis, IIf( lColab, 'TC  - ','TSS - ')+"Filial " + ( TRAB )->( DT6_FILDOC	) + " Documento " + ( TRAB )->( DT6_DOC ) +" Serie " + ( TRAB )->( DT6_SERIE	) + " " + aTipArq[X][3] + " " + IIf( lOkCTE , "" , "N�o") + " Enviado para AVERBACAO", cArquivo )

			( TRAB )->( DbSkip() )

			xQtde++

		End While

		If Select( "TRAB" ) # 0
			( TRAB )->( DbCloseArea() )
		EndIf

	End Sequence

	xMensagem += "		Foram Processados " + cValToChar( xQtde ) + " registros e Exportados "+ cValToChar( xQtdeExp ) +" arquivos XML'S"+ CRLF

	xMensagem += "	Finalizado o processo de Exportacao da AVERBACAO de CTE " + aTipArq[X][3] + CRLF

	StaticCall( GEFCNHAST , LogThis, "Foram Processados " + cValToChar( xQtde ) + " registros e Exportados "+ cValToChar( xQtdeExp ) +" arquivos XML'S" , cArquivo )

	StaticCall( GEFCNHAST , LogThis, "Finalizado o processo de Exporta��o da AVERBA��O dos CTE Tempo Decorrido "+ ElapTime( xHoraIni , Time() ) , cArquivo )

	u_EnvEmail( cDe , cPara , cCc , aTipArq[X][3] + " - " + cAssunto , cMsg , cAnexo )

	FErase( cAnexo )

	xMensagem += 'Fim do Processo de Averbacao em ' + DtoC( Date() ) +" as "+ Time() + " Tempo Decorrido "+ ElapTime( xHoraIni , Time() )+ CRLF

	Conout( xMensagem )

	If lSchedule
		RpcClearEnv()
	EndIf

	RestArea( aArea )

Return

/*
Programa	: GEFXMLROB
Funcao		: Static SpedPExp
Data		: 31/07/2015
Autor		: Andr� Costa
Descricao	: Realiza a exporta��o do XML autorizado pelo SEFAZ
Chamada	: GEFXMLROB
Sintaxe	: SpedPExp(cIdEnt,cSerie,cNotaIni,cDirDest)
*/


Static Function SpedPExp(cIdEnt,xFilial,cSerie,cNotaIni,cDirDest,cDataDe,cDataAte,cCNPJDESTInicial,cCNPJDESTFinal)

	Local cChvNFe		:= ""
	Local cPrefixo	:= "CTe"
	Local cXml			:= ""
	Local cNFes		:= ""
	Local nHandle		:= 0
	Local X			:= 0
	Local lOk			:= .F.
	Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oWS
	Local oRetorno
	Local oXML

	Default cDataDe				:= Lastday(dDataBase,1)
	Default cDataAte				:= Lastday(cDataDe)
	Default cCNPJDESTInicial		:= ''
	Default cCNPJDESTFinal		:= 'ZZZZZZZZZZZZZZ'

	oWS:= WSNFeSBRA():New()
	oWS:cUSERTOKEN			:= "TOTVS"
	oWS:cID_ENT				:= cIdEnt
	oWS:_URL					:= AllTrim(cURL)+"/NFeSBRA.apw"
	oWS:cIdInicial			:= cSerie+cNotaIni
	oWS:cIdFinal				:= cSerie+cNotaIni
	oWS:dDataDe				:= cDataDe
	oWS:dDataAte				:= cDataAte
	oWS:cCNPJDESTInicial		:= cCNPJDESTInicial
	oWS:cCNPJDESTFinal		:= cCNPJDESTFinal
	oWS:nDiasparaExclusao	:= 0
	lOk							:= oWS:RETORNAFX()
	oRetorno					:= oWS:oWsRetornaFxResult

	Begin Sequence

		If !( lOk )
			StaticCall( GEFCNHAST , LogThis, "Ocorreu problema. Filial "+xFilial+" Entidade "+ cIdEnt + " Serie "+cSerie+" Documento "+cNotaIni+" Dat Ini. "+DtoC(cDataDe)+" Dat. Fim"+DtoC(cDataAte)+" CNPJ Ini "+cCNPJDESTInicial+" CNPJ Fim "+cCNPJDESTFinal , cArquivo )
			Break
		EndIf

		For X := 1 To Len(oRetorno:OWSNOTAS:OWSNFES3)

			oXml		:= oRetorno:OWSNOTAS:OWSNFES3[X]
			oXmlExp	:= XmlParser(oRetorno:OWSNOTAS:OWSNFES3[X]:OWSNFE:CXML,"","","")
			cXML		:= ""
			cVerCte	:= Iif(Type("oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT") <> "U", oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT, '')

			If Empty(oXml:oWSNFe:cProtocolo)
				StaticCall( GEFCNHAST , LogThis, "Protoculo Vazio. Filial "+xFilial+" Entidade "+ cIdEnt + " Serie "+cSerie+" Documento "+cNotaIni+" Dat Ini. "+DtoC(cDataDe)+" Dat. Fim"+DtoC(cDataAte)+" CNPJ Ini "+cCNPJDESTInicial+" CNPJ Fim "+cCNPJDESTFinal , cArquivo )
				Loop
			EndIf

			cNotaIni	:= oXml:cID
			cNFes		:= cNFes+cNotaIni+CRLF
			cChvNFe	:= NfeIdSPED(oXml:oWSNFe:cXML,"Id")

			nHandle := FCreate(cDirDest+SubStr(cChvNFe,4,44)+"-"+cPrefixo+".xml")

			If nHandle == 0
				StaticCall( GEFCNHAST , LogThis, "Problema para Criar o Arquivo. Filial "+xFilial+" Entidade "+ cIdEnt + " Serie "+cSerie+" Documento "+cNotaIni+" Dat Ini. "+DtoC(cDataDe)+" Dat. Fim"+DtoC(cDataAte)+" CNPJ Ini "+cCNPJDESTInicial+" CNPJ Fim "+cCNPJDESTFinal , cArquivo )
				Loop
			EndIf

			cCab1	:= '<?xml version="1.0" encoding="UTF-8"?>'
			cCab1	+= '<cteProc xmlns="http://www.portalfiscal.inf.br/cte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/cte procCTe_v'+cVerCte+'.xsd" versao="'+cVerCte+'">'
			cRodap	:= '</cteProc>'

			FWrite(nHandle,AllTrim(cCab1))
			FWrite(nHandle,AllTrim(oXml:oWSNFe:cXML))
			FWrite(nHandle,AllTrim(oXml:oWSNFe:cXMLPROT))
			FWrite(nHandle,AllTrim(cRodap))
			FClose(nHandle)

		Next X

	End Sequence

Return( lOk )



/*
Programa	: GEFXMLROB
Funcao		: Static GetIdEnt
Data		: 31/07/2015
Autor		: Andr� Costa
Descricao	: Faz a identifica��o da Entitade da Empresa
Chamada	: SpedPExp
Sintaxe	: GetIdEnt(xFilial)
*/

Static Function GetIdEnt(xEmpresa,xFilial)

	Local aArea  := GetArea()
	Local cIdEnt := ""
	Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oWs

	Default xEmpresa := cEmpAnt

	Begin Sequence

		DbSelectArea("SM0")
		DbSetOrder(1)

		If !( MsSeek(xEmpresa + xFilial ) )
			StaticCall( GEFCNHAST , LogThis, "Nao foi encontrada a Empresa "+xEmpresa+" e ou a Filial "+xFilial+". Favor informar a TI.", cArquivo )
			Break
		EndIf

		oWS := WsSPEDAdm():New()
		oWS:cUSERTOKEN := "TOTVS"

		oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
		oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
		oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
		oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
		oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
		oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
		oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
		oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
		oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
		oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
		oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
		oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
		oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
		oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
		oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
		oWS:oWSEMPRESA:cCEP_CP     := Nil
		oWS:oWSEMPRESA:cCP         := Nil
		oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
		oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
		oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
		oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
		oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
		oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
		oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
		oWS:oWSEMPRESA:cINDSITESP  := ""
		oWS:oWSEMPRESA:cID_MATRIZ  := ""
		oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
		oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"

		If oWs:ADMEMPRESAS()
			cIdEnt  := oWs:cADMEMPRESASRESULT
		EndIf

	End Sequence

	RestArea(aArea)

Return(cIdEnt)


/*
Programa		: GEFXMLROB
Funcao			: Fun��o Estatica - AjustaSX6
Data			: 31/07/2015
Autor			: Andr� Costa
Descricao		: Fun��o de Apoio
Uso				: Ajusta os Parametros da Rotina Exporta��o de XML para Averba��o
Sintaxe		: AjustaSX6()
Retorno		: Conteudo do Parametro
*/


Static Function AjustaSX6
	Local aArea := GetArea()

	DbSelectArea("SX6")  // abre arquivo tempor�rio
	SX6->( DbSetOrder(1) )

	If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XDATROB" , .F. ) )
		Conout('Parametro MV_XDATROB Criado')
		RecLock( "SX6",.T. )
		SX6->X6_VAR     := "MV_XDATROB"
		SX6->X6_TIPO    := "D"
		SX6->X6_CONTEUD := DtoC( Date() )
		SX6->X6_CONTSPA := DtoC( Date() )
		SX6->X6_CONTENG := DtoC( Date() )

		SX6->X6_DESCRIC := "Data de Inicio do processo de Exporta��o da AVERBA"
		SX6->X6_DESC1   := "�AO"
		SX6->X6_DSCSPA  := "Data de Inicio do processo de Exporta��o da AVERBA"
		SX6->X6_DSCSPA1 := "�AO"
		SX6->X6_DSCENG  := "Data de Inicio do processo de Exporta��o da AVERBA"
		SX6->X6_DSCENG1 := "�AO"
		MsUnLock()
	EndIf

	If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XXMLROB" , .F. ) )
		Conout('Parametro MV_XXMLROB Criado')
		RecLock( "SX6",.T. )
		SX6->X6_VAR     := "MV_XXMLROB"
		SX6->X6_TIPO    := "C"
		SX6->X6_CONTEUD := "\Interfaces\TMS\PROTHEUS\OUT\AVERBACAO\"
		SX6->X6_CONTSPA := "\Interfaces\TMS\PROTHEUS\OUT\AVERBACAO\"
		SX6->X6_CONTENG := "\Interfaces\TMS\PROTHEUS\OUT\AVERBACAO\"

		SX6->X6_DESCRIC := "Local de grava��o dos arquivos XML para Exporta��o"
		SX6->X6_DESC1   := " da AVERBA�AO"
		SX6->X6_DSCSPA  := "Local de grava��o dos arquivos XML para Exporta��o"
		SX6->X6_DSCSPA1 := " da AVERBA�AO"
		SX6->X6_DSCENG  := "Local de grava��o dos arquivos XML para Exporta��o"
		SX6->X6_DSCENG1 := " da AVERBA�AO"
		MsUnLock()
	EndIf

	If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XUSRROB" , .F. ) )
		Conout('Parametro MV_XUSRROB Criado')
		RecLock( "SX6",.T. )
		SX6->X6_VAR     := "MV_XUSRROB"
		SX6->X6_TIPO    := "C"
		SX6->X6_CONTEUD := "pedro.alvarez@gefco.com.br"
		SX6->X6_CONTSPA := "pedro.alvarez@gefco.com.br"
		SX6->X6_CONTENG := "pedro.alvarez@gefco.com.br"

		SX6->X6_DESCRIC := "Email do usuario que recebera o log a AVERBACAO."
		SX6->X6_DESC1   := ""
		SX6->X6_DSCSPA  := "Email do usuario que recebera o log a AVERBACAO"
		SX6->X6_DSCSPA1 := ""
		SX6->X6_DSCENG  := "Email do usuario que recebera o log a AVERBACAO"
		SX6->X6_DSCENG1 := ""
		MsUnLock()
	EndIf

	If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XARQCOL" , .F. ) )
		Conout('Parametro MV_XARQCOL Criado')
		RecLock( "SX6",.T. )
		SX6->X6_VAR     := "MV_XARQCOL"
		SX6->X6_TIPO    := "C"
		SX6->X6_CONTEUD := "\NeoGridClient\bin\LIDOS\"
		SX6->X6_CONTSPA := "\NeoGridClient\bin\LIDOS\"
		SX6->X6_CONTENG := "\NeoGridClient\bin\LIDOS\"

		SX6->X6_DESCRIC := "Diretorio onde est�o os Arquivos do Colabora��o."
		SX6->X6_DESC1   := ""
		SX6->X6_DSCSPA  := "Diretorio onde est�o os Arquivos do Colabora��o."
		SX6->X6_DSCSPA1 := ""
		SX6->X6_DSCENG  := "Diretorio onde est�o os Arquivos do Colabora��o."
		SX6->X6_DSCENG1 := ""
		MsUnLock()
	EndIf

	RestArea(aArea)

Return

/*
Programa	: GEFXMLROB
Funcao		: Fun��o Estatica - xSchedule
Data		: 03/08/2015
Autor		: Andr� Costa
Descricao	: Fun��o de Apoio
Uso			: Verifica se a rotina esta esta rodando por Schedule ou via IDE
Sintaxe	: xSchedule()
Retorno	: Logico Verdadeiro / Falso
*/

Static Function xSchedule
	Local aArea		:= GetArea()
	Local lRetorno	:= .F.

	Begin Sequence

		If ( Type( "__cInternet" ) == "U" )

			If Select("SX6") == 0
				lRetorno := .T.
				Break
			EndIf

			If __cInternet == "AUTOMATICO"
				lRetorno := .T.
				Break
			EndIf

		EndIf

	End Sequence

	RestArea( aArea )

Return( lRetorno )