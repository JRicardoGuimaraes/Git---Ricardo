#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

#DEFINE VBOX      080
#DEFINE VSPACE    008
#DEFINE HSPACE    010
#DEFINE SAYVSPACE 008
#DEFINE SAYHSPACE 008
#DEFINE HMARGEM   030
#DEFINE VMARGEM   030
#DEFINE MAXITEM   Max((022-Max(0,Len(aMensagem)-02)),1)
#DEFINE MAXITEMP2 055
#DEFINE MAXMENLIN 070

#DEFINE doDTC_SERNFC	1
#DEFINE doDTC_NUMNFC	2
#DEFINE doDTC_EMINFC	3
#DEFINE doDTC_VALOR		4
#DEFINE doDTC_PESO		5
#DEFINE doDTC_CLIDEV	6
#DEFINE doDTC_LOJDEV	7
#DEFINE doDTC_NFEID		8

Static aUltChar2pix
Static aUltVChar2pix
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RTMSR27   ³ Autor ³Igor Franzoi           ³ Data ³24/10/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao responsavel por imprimir o DACTE.                    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RTMSR27()
Local cIdEnt	:=	''
Local aArea		:=	SF2->( GetArea() )
Local aAreaSM0  :=  SM0->( GetArea() )		// Armazenamos a posicao da SM0
Local cNewFil   :=  SF2->F2_FILIAL			// Pegamos a Filial da NF
Private  _aMonitor

Private cDoc  	:= ""
Private cSerie  := ""

Private cViagem := ""
Private cNRAS	:= ""

	If !TMSSpedNFe(@cIdEnt)
		Alert("CT-e Indisponivel")
		Return
	EndIf

	_aMonitor	:=	StaticCall(SPEDNFE,WsNFeMnt,cIdEnt,1,{SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC})

	RestArea(aArea)
	
	If Len(_aMonitor) > 0 .And. Substr(_aMonitor[1,6],1,3) == "001"
	
		SM0->( dbSetOrder(1) )
		SM0->( dbSeek( cEmpAnt + cNewFil ) )	// Buscando SM0 da Filial que emitiu o Dacte	- Cristiam Rossi em 04/08/2015

		FwMsgRun(,{|| PrtCte()},,"Emitindo DACT-e")

		SM0->( RestArea( aArea ) )				// restaurando SM0 logada pelo usuario
		
	Else
		Aviso("Aviso", "Não autorizado a impressão do Documento Auxiliar de Conhecimento de Transporte Eletrônico!",{"&Ok"})
	EndIf
Return


Static Function PrtCte()
	Local nCount		:= 0
	Local cLabel		:= ""
	Local nSoma			:= 0
	Local nCInic		:= 0	// Coluna Inicial
	Local cChaveA		:= ''
	Local cChaveB		:= ''
	Local cTmsAntt		:= SuperGetMv( "MV_TMSANTT", .F., .F. )	//Numero do registro na ANTT com 14 dígitos
	Local cAliasD2		:= ''
	Local cAliasDev		:= ''
	Local aCab			:= {}
	Local aDoc			:= {}
	Local oFont07		:= TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)
	Local oFont07N		:= TFont():New("Times New Roman",07,07,,.T.,,,,.T.,.F.)
	Local oFont08		:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
	Local oFont08N		:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
	Local oFont10N		:= TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
	Local lControl		:= .F.
	Local cAliasInfNF	:= ''
	Local cAliasSeg		:= ''
	Local cPerg			:= 'RTMSR25'
	Local nCont			:= 0
	Local lSeqDes		:= .F.
	Local lSeqRec		:= .F.
	Local cDT6Obs		:= ''
	Local cDT6Obs2		:= ''
	Local cDT6Obs3		:=	''
	Local cDTCObs		:= ''
	Local cDTCObs2		:= ''
	Local cObsCont		:= ''
	Local cTipoNF		:= ''
	Local cCtrDpc		:= ''
	Local cSerDpc		:= ''
	Local cTpDocAnt		:= ''
	Local cCTEDocAnt	:= ''
	Local aSeg
//-- Buscar dados XML
	Local aNotas		:= {}
	Local aXML			:= {}
	Local cAviso		:= ""
	Local cErro			:= ""
	Local cAutoriza		:= ""
	Local cHorAut		:= ""
	Local cDatAut		:= ""
	Local cModalidade	:= Substr(StaticCall(FISTRFNFE,GetInfSefaz)[3],1,1)
	Local cVersaoCTE	:= ""
	Local cIdEnt		:= ""
	Local nX			:= 0
	Local nY			:= 0
//-- CFOP - Natureza da Prestacao
	Local cCFOP			:= ''
	Local cDescCfop		:= ''
//-- Origem Prestacao
	Local cOriMunPre	:= ""
	Local cOriUFPre		:= ""
//-- Destino Prestacao
	Local cDesMunPre	:= ""
	Local cDesUFPre		:= ""
//-- Remetente
	Local cRemMun		:= ""
	Local cRemUF		:= ""
	Local cRemNome		:= ""
	Local cRemEnd		:= ""
	Local cRemNro		:= ""
	Local cRemCompl		:= ""
	Local cRemBair		:= ""
	Local cRemCEP		:= ""
	Local cRemCNPJ		:= ""
	Local cRemIE		:= ""
	Local cRemPais		:= ""
	Local cRemFone		:= ""
//-- Destinatario
	Local cDesMun		:= ""
	Local cDesUF		:= ""
	Local cDesNome		:= ""
	Local cDesEnd		:= ""
	Local cDesNro		:= ""
	Local cDesCompl		:= ""
	Local cDesBair		:= ""
	Local cDesCEP		:= ""
	Local cDesCNPJ		:= ""
	Local cDesIE		:= ""
	Local cDesPais		:= ""
	Local cDesFone		:= ""
//-- Expedidor
	Local cExpNome		:= ""
	Local cExpEnd		:= ""
	Local cExpNro		:= ""
	Local cExpMun		:= ""
	Local cExpBai		:= ""
	Local cExpUF		:= ""
	Local cExpDoc		:= ""	// CNPJ / CPF
	Local cExpPais		:= ""
	Local cExpIE		:= ""
	Local cExpCEP		:= ""
	LOcal cExpFone		:= ""
//-- Recebedor
	Local cRecNome		:= ""
	Local cRecEnd		:= ""
	Local cRecBai		:= ""
	Local cRecMun		:= ""
	Local cRecUF		:= ""
	Local lRecPJ		:= .F.
	Local cRecCGC		:= ""
	Local cRecCPF		:= ""
	Local cRecINSCR		:= ""
//-- Tomador do Servico
	Local cDevMun		:= ""
	Local cDevUF		:= ""
	Local cDevNome		:= ""
	Local cDevEnd		:= ""
	Local cDevNro		:= ""
	Local cDevCompl		:= ""
	Local cDevBair		:= ""
	Local cDevCEP		:= ""
	Local cDevCNPJ		:= ""
	Local cDevIE		:= ""
	Local cDevPais		:= ""
	Local cDevFone		:= ""
//-- Produto Predominante
	Local cPPDesc		:= ""
	Local cPPCarga		:= ""
	Local cPPVlTot		:= ""
	Local cPPPesoB		:= ""
	Local cPPPeso3		:= ""
	Local cPPMetro3		:= ""
	Local cPPQtdVol		:= ""
//-- Dados Seguradora
	Local cSegNome		:= ""
	Local cSegResp		:= ""
	Local cSegDesc		:= ""
	Local cSegNrApoli	:= ""
	Local cSegNrAverb	:= ""
//-- Documentos Originarios
	Local aDocOri		:= {}
//Lotação
	Local lLotacao		:= .F.
	Local cTpVei		:= ""
	Local cPlaca		:= ""
	Local cUf			:= ""
	Local cRNTRC		:= ""
	Local cCodMoto		:= ""
	Local cCpfMoto		:= ""
	Local cNomeMoto		:= ""
	Local cLacre		:= ""
	Local nQtdDev		:= 0
	Local cDesDocAnt	:= ""
	Local cAliasDT5		:= ""
	Local cRNLotacao	:= ""
	Local cRNDtPrv		:= ""
	Local cRNMensagem	:= ""
	Local cCliente		:= ""
	Local cLoja			:= ""
	Local cAliasPeri	:= ""
	Local lPerig		:= .F.	//-- Informa se ha produtos perigosos
	Local cStartPath
	Local cForSeg		:= SuperGetMv("MV_FORSEG",,"")
	Local lForApol		:= SA2->(FieldPos('A2_APOLICE')) > 0
	Local nTamCod		:= Len(SA2->A2_COD)
	Local nTamLoj		:= Len(SA2->A2_LOJA)
	Local aResp			:= {}
	Local cTipoDoc		:= ''
	Local nObs 			:= 0
	Local cTCiot		:= ''  	
	Local cBanco		:= ''
	Local cAgenc		:= ''
	Local cConta		:= ''
	Local cSA2Obs    	:= ''  // 2013-12-09
	Local cSA2Obs2   	:= ''  // 2013-12-09
	
//-- Variaveis Private
	Private cAliasCT	:= GetNextAlias()
	Private oDacte
	Private nLInic		:= 0	// Linha Inicial
	Private nLFim		:= 0	// Linha Inicial
	Private nDifEsq		:= 0	// Variavel com Diferenca para alinhar os Print da Esquerda com os da Direita
	Private cInsRemOpc	:= ''	// Remetente com sequencia de IE
	Private nFolhas		:= 0
	Private nFolhAtu	:= 1
	Private PixelX		:= nil
	Private PixelY		:= nil
	Private nMM			:= 0
	Private lXml		:= .F.
	Private lComp		:= .F.	//CTE Complementar

//Verifica se o arquivo sera gerado em Remote Linux
	If GetRemoteType() = 2
		cStartPath	:= "l:\tmp\"
	Else
		cStartPath	:= "C:\"
	EndIf

//Tratamento para ambiente Linux
	If IsSrvUnix() .And. GetRemoteType() == 1
		cStartPath := StrTran(cStartPath,"/","\")
	Endif

	AjustaSX1()

//-- MV_PAR01 - Informe lote inicial.
//-- MV_PAR02 - Informe lote final.
//-- MV_PAR03 - Informe documento inicial.
//-- MV_PAR04 - Informe documento final.
//-- MV_PAR05 - Informe serie do documento inicial.
//-- MV_PAR06 - Informe serie do documento final.
//-- MV_PAR07 - Informe tipo do documento.
//-- MV_PAR08 - Buscar XML do WebService.
//If !Pergunte(cPerg,.T.)
//	Return()
//EndIf

	Pergunte(cPerg,.T.)
	//MV_PAR01	:=	""
	//MV_PAR02	:=	"ZZZZZZZZZZ"
	//MV_PAR03	:=	SF2->F2_DOC
	//MV_PAR04	:=	SF2->F2_DOC
	//MV_PAR05	:=	SF2->F2_SERIE
	//MV_PAR06	:=	SF2->F2_SERIE
	MV_PAR07	:=	'2'
	MV_PAR08	:=	1

//-- Buscar XML do WebService
	lXml := MV_PAR08 == 1

	If	lXml .And. !TMSSpedNFe(@cIdEnt,@cModalidade,@cVersaoCTE)
		Return()
	EndIf

//Se for contingencia nao busca do XML
	If cModalidade == '7-Contingência FS-DA' .And. cVersaoCTE == '1.04'
		lXml = .F.
	EndIf

// Cria Arquivo de Trabalho - Documentos de Transporte
	cAliasCT := DataSource( 'DT6' )

	oDacte:=FWMSPrinter():New("DACTE",IMP_PDF,.F.,cStartPath,.F.,,@oDacte,,,,,.T.)
	oDacte:SetResolution(72)
	oDacte:SetPortrait()
	oDacte:SetPaperSize(DMPAPER_A4)
	oDacte:SetMargin(60,60,60,60)

	PixelX  := oDacte:nLogPixelX()
	PixelY  := oDacte:nLogPixelY()
	nMM     := 0

	While !(cAliasCT)->(Eof())

		cViagem := (cAliasCT)->DTQ_VIAGEM		// Cristiam Rossi em 18/08/2015
		cNRAS   := (cAliasCT)->DTQ_AS	 		// Cristiam Rossi em 18/08/2015
		cSA2Obs := ''

		oDacte:StartPage()
		cLacre := ""

	//-- Buscar XML do WebService
		If lXml
			aNotas := {}
			aadd(aNotas,{})
			aAdd(Atail(aNotas),.F.)

			aadd(Atail(aNotas),"S") //IIF(MV_PAR04==1,"E","S"))
			aAdd(Atail(aNotas),"")
			aAdd(Atail(aNotas),(cAliasCT)->DT6_SERIE) //SERIE
			aAdd(Atail(aNotas),(cAliasCT)->DT6_DOC) //Documento
			aadd(Atail(aNotas),"")
			aadd(Atail(aNotas),"")

			nX   := 1
			aXml := {}
			aXml := TMSGetXML(cIdEnt,aNotas,@cModalidade)
			If !Empty(aXML[nX][2])
				If !Empty(aXml[nX])
					cAutoriza   := aXML[nX][1]
					cCodAutDPEC := aXML[nX][5]
					cHorAut     := IIF(!Empty(aXML[nX][6]),aXML[nX][6],"")			//-- Data autorizacao 21/09/2015
					cDatAut     := IIF(!Empty(aXML[nX][7]),DToC(aXML[nX][7]),"")	//-- Hora autorizacao
				Else
					cAutoriza   := ""
					cCodAutDPEC := ""
					cHorAut     := ""												//-- Data autorizacao
					cDatAut     := ""												//-- Hora autorizacao
				EndIf
				cAviso := ""
				cErro  := ""
				oNfe := XmlParser(aXML[nX][2],"_",@cAviso,@cErro)
				oNfeDPEC := XmlParser(aXML[nX][4],"_",@cAviso,@cErro)
			
				cModalidade := SubStr(cModalidade,1,1)//Alison (11/10/2013)
			
				If (!Empty(cAutoriza) .Or. !Empty(cCodAutDPEC) .Or. !cModalidade$"1,4,5,6")
					If aNotas[nX][02]=="S"
						dbSelectArea("SF2")
						dbSetOrder(1)
						If MsSeek(xFilial("SF2")+aNotas[nX][05]+aNotas[nX][04]) .And. cModalidade$"1,4,6"
							RecLock("SF2")
							If !SF2->F2_FIMP$"D"
								SF2->F2_FIMP := "S"
							EndIf
							If SF2->(FieldPos("F2_CHVNFE"))>0
								SF2->F2_CHVNFE := SubStr(NfeIdSPED(aXML[nX][2],"Id"),4)
							EndIf
							MsUnlock()
							                                       
							//Alison 18/07/14
							AtuDT6(SF2->(F2_FILIAL+F2_DOC+F2_SERIE))
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona a qtde de registros, p/ calcular a qtde de folhas            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAliasInfNF := DataSource( 'DTC' )
		If (cAliasInfNF)->nTotal > 0
			If (cAliasInfNF)->nTotal <= 8
				nFolhas := 1
			Else
				nFolhas := (cAliasInfNF)->nTotal - 8	//-- Qtde da primeira paginas.
				nFolhas := Int(( nFolhas / 74 ) + 2)	//-- Qtde da outras paginas.
			EndIf
		EndIf
		(cAliasInfNF)->(DbCloseArea())

		If Type( 'oNFE' ) == 'U'
			lXML := .F. //Restricao de errorlog devido ao xml retornado
		EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Controla o documento a ser enviado para montagem do cabecalho.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nCont += 1
		cProtoco	:=	_aMonitor[1,5]
		If lXML
			aAdd(aCab, {;
				AllTrim((cAliasCT)->DT6_DOC),;
				AllTrim(oNfe:_CTE:_INFCTE:_IDE:_SERIE:TEXT),;
				AllTrim(STRTRAN( SUBSTR( oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT, 1, AT('T', oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT) - 1) , '-', '')),;
				AllTrim(STRTRAN( SUBSTR( oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT, AT('T', oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT) + 1, 5) , ':', '')),;
				AllTrim(STRTRAN(UPPER(oNFE:_CTE:_INFCTE:_ID:TEXT),'CTE','')),;
				cProtoco,"" ,cDatAut, cHorAut})	//-- Nao possui ref. no XML
		Else
			aAdd(aCab, {;
				AllTrim((cAliasCT)->DT6_DOC),;
				AllTrim((cAliasCT)->DT6_SERIE),;
				AllTrim((cAliasCT)->DT6_DATEMI),;
				AllTrim((cAliasCT)->DT6_HOREMI),;
				AllTrim((cAliasCT)->DT6_CHVCTE),;
				cProtoco,"" ,cDatAut, cHorAut})			// 21/09/2015
		EndIf
		
		cDoc	:= (cAliasCT)->DT6_DOC
		cSerie	:= (cAliasCT)->DT6_SERIE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Funcao responsavel por montar o cabecalho do relatorio                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nFolhAtu := 1
		lSeqDes  :=.F.
		lSeqRec  :=.F.
		TMSR27Cab(aCab[nCont],.T.)

	//-- Estrutura da funcao que retorna o logradouro, numero e complemento.
	//-- Logradouro		FisGetEnd(XXXXXXXX)[1]
	//-- Numero			FisGetEnd(XXXXXXXX)[2]
	//-- Complemento	FisGetEnd(XXXXXXXX)[4]

		If !lXml
		//-- CFOP
			cAliasD2 := DataSource( 'CFOP' )
			If !(cAliasD2)->(Eof())
				cCFOP		:= AllTrim((cAliasCT)->CFOP)
				cDescCfop	:= SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,127)
			EndIf
			(cAliasD2)->(DbCloseArea())

		//-- Origem da Prestacao
			If Empty((cAliasCT)->ORI_CODORI)
				cOriMunPre := (cAliasCT)->REM_MUNICI
				cOriUFPre  := (cAliasCT)->REM_UF
			Else
				cOriMunPre := Posicione('CC2',3,xFilial("CC2")+ (cAliasCT)->ORI_CODORI ,"CC2_MUN")
				cOriUFPre  := Posicione('CC2',3,xFilial("CC2")+ (cAliasCT)->ORI_CODORI ,"CC2_EST")
			EndIf
		
		//-- Destino da Prestacao
			If Empty((cAliasCT)->DES_CODDES)
				cDesMunPre := (cAliasCT)->DES_MUNICI
				cDesUFPre  := (cAliasCT)->DES_UF
			Else
				cDesMunPre := Posicione('CC2',3,xFilial("CC2")+ (cAliasCT)->DES_CODDES ,"CC2_MUN")
				cDesUFPre  := Posicione('CC2',3,xFilial("CC2")+ (cAliasCT)->DES_CODDES ,"CC2_EST")
			EndIf

		//-- Remetente
			cRemMun   := (cAliasCT)->REM_MUNICI
			cRemUF    := (cAliasCT)->REM_UF
			cRemNome  := (cAliasCT)->REM_NOME
			cRemEnd   := FisGetEnd((cAliasCT)->REM_END)[1]
			cRemNro   := Iif(FisGetEnd((cAliasCT)->REM_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasCT)->REM_END)[2])),"S/N")
			cRemCompl := cValtoChar(FisGetEnd((cAliasCT)->REM_END)[4])
			cRemBair  := (cAliasCT)->REM_BAIRRO
			cRemCEP   := (cAliasCT)->REM_CEP
			cRemCNPJ  := (cAliasCT)->REM_CNPJ
			cRemIE    := (cAliasCT)->REM_INSC
			cRemPais  := Posicione("SYA",1,xFilial("SYA")+(cAliasCT)->REM_PAIS,"YA_DESCR")
			cRemFone  := "("+AllTrim((cAliasCT)->REM_DDDTEL)+") "+AllTrim((cAliasCT)->REM_TEL)

		//-- Destinatario
			cDesMun   := (cAliasCT)->DES_MUNICI
			cDesUF    := (cAliasCT)->DES_UF
			cDesNome  := (cAliasCT)->DES_NOME
			cDesEnd   := FisGetEnd((cAliasCT)->DES_END)[1]
			cDesNro   := Iif(FisGetEnd((cAliasCT)->DES_END)[2]<>0, AllTrim(cValtoChar(FisGetEnd((cAliasCT)->DES_END)[2])),"S/N")
			cDesCompl := cValtoChar(FisGetEnd((cAliasCT)->DES_END)[4])
			cDesBair  := (cAliasCT)->DES_BAIRRO
			cDesCEP   := (cAliasCT)->DES_CEP
			cDesCNPJ  := (cAliasCT)->DES_CNPJ
			cDesIE    := (cAliasCT)->DES_INSC
			cDesPais  := Posicione("SYA",1,xFilial("SYA")+(cAliasCT)->DES_PAIS,"YA_DESCR")
			cDesFone  := "("+AllTrim((cAliasCT)->DES_DDDTEL)+") "+AllTrim((cAliasCT)->DES_TEL)

		//-- PROD.PREDOMINANTE / OUT.CARACT / VLR.TOTAL MERCADORIA
			cAliasInfNF := DataSource( 'PRODUTO_PREDOMINANTE' )

			cPPDesc			:= (cAliasInfNF)->B1_DESC
			cPPCarga		:= (cAliasInfNF)->X5_DESCRI
			cPPVlTot		:= STR( (cAliasCT)->DT6_VALMER )
			If (cAliasCT)->DT6_DOCTMS == "8"  //CTRC Complementar
				cDTCObs		:= MsMM((cAliasCT)->DT6_CODOBS)
			Else
				cDTCObs		:= MsMM((cAliasInfNF)->DTC_CODOBS,80)
			EndIf
			cDTCObs			:= StrTran(cDTCObs, Chr(10)," ")
			cDTCObs			:= StrTran(cDTCObs, Chr(13)," ")

			cTipoNF			:= AllTrim((cAliasInfNF)->DTC_TIPNFC)
			cCtrDpc			:= AllTrim((cAliasInfNF)->DTC_CTRDPC)
			cSerDpc			:= AllTrim((cAliasInfNF)->DTC_SERDPC)
			cTpDocAnt		:= AllTrim((cAliasInfNF)->DTC_TIPANT)
			cCTEDocAnt		:= AllTrim((cAliasInfNF)->DTC_CTEANT)

			cPPPesoB		:= (cAliasCT)->DT6_PESO
			cPPPeso3		:= (cAliasCT)->DT6_PESOM3
			cPPMetro3		:= (cAliasCT)->DT6_METRO3
			cPPQtdVol		:= (cAliasCT)->DT6_VOLORI

			If cTpDocAnt == '0'
				cDesDocAnt:= 'CTRC'
			ElseIf cTpDocAnt == '2'
				cDesDocAnt:= 'ACT'
			ElseIf cTpDocAnt == '3'
				cDesDocAnt:= 'NF'
			ElseIf cTpDocAnt == '4'
				cDesDocAnt:= 'AWB'
			ElseIf cTpDocAnt == '5'
				cDesDocAnt:= 'OUT'
			EndIf
			(cAliasInfNF)->(DbCloseArea())

		//-- Dados Seguradora
			cSegNome		:= ""
			cSegResp		:= ""
			cSegNrApoli		:= ""
			cSegNrAverb		:= ""

		//-- Tomador do Servico
			cDevMun   := (cAliasCT)->DEV_MUNICI
			cDevUF    := (cAliasCT)->DEV_UF
			cDevNome  := (cAliasCT)->DEV_NOME
			cDevEnd   := FisGetEnd((cAliasCT)->DEV_END)[1]
			cDevNro   := Iif(FisGetEnd((cAliasCT)->DEV_END)[2]<>0, AllTrim(cValtoChar(FisGetEnd((cAliasCT)->DEV_END)[2])),"S/N")
			cDevCompl := cValtoChar(FisGetEnd((cAliasCT)->DEV_END)[4])
			cDevBair  := (cAliasCT)->DEV_BAIRRO
			cDevCEP   := (cAliasCT)->DEV_CEP
			cDevCNPJ  := (cAliasCT)->DEV_CNPJ
			cDevIE    := (cAliasCT)->DEV_INSC
			cDevPais  := Posicione("SYA",1,xFilial("SYA")+(cAliasCT)->DEV_PAIS,"YA_DESCR")
			cDevFone  := "("+AllTrim((cAliasCT)->DEV_DDDTEL)+") "+AllTrim((cAliasCT)->DEV_TEL)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o endereco de entrega e diferente do principal             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cAliasTagE := DataSource( 'ENDERECO' )

			If !Empty((cAliasTagE)->DTC_SQEDES)
				DUL->(DbSetOrder(2))
				If DUL->(MsSeek(xFilial('DUL')+(cAliasCT)->DT6_CLIDES + (cAliasCT)->DT6_LOJDES + (cAliasTagE)->DTC_SQEDES))
					If Alltrim(DUL->DUL_CODRED) <> ""
						lSeqRec := .T.
					Else
						lSeqDes := .T.
					EndIf
				//Destino Prestacao
					cRecEnd		:= DUL->DUL_END
					cRecBai		:= DUL->DUL_BAIRRO
					cRecMun		:= NoAcentoCte(DUL->DUL_MUN)
					crecUF		:= NoAcentoCte(DUL->DUL_EST)
				//-- Destino da Prestacao
					cDesMunPre	:= cRecMun
					cDesUFPre	:= crecUF
				//-- Cadastro de Clientes
					cCliente:= Iif(Empty(DUL->DUL_CODRED),(cAliasCT)->DT6_CLIDES,DUL->DUL_CODRED)
					cLoja   := Iif(Empty(DUL->DUL_LOJRED),(cAliasCT)->DT6_LOJDES,DUL->DUL_LOJRED)
					SA1->(DbSetOrder(1))
					If SA1->(dbSeek(xFilial('SA1') + cCliente + cLoja))
						cRecNome	:= AllTrim( SA1->A1_NOME )
						lRecPJ		:= ( AllTrim(SA1->A1_PESSOA) == "J" )
						cRecCGC		:= AllTrim( SA1->A1_CGC )
						cRecCPF		:= AllTrim( SA1->A1_CGC )
						cRecINSCR	:= AllTrim( SA1->A1_INSCR )
					EndIf
				EndIf
			EndIf

		//Origem Prestacao
		//If (cAliasTagE)->DTC_SELORI == StrZero(1,Len(DTC->DTC_SELORI))   //Transportadora
		//	DUY->(DbSetOrder(1))
		//	If DUY->(MsSeek(xFilial("DUY")+(cAliasCT)->DT6_CDRORI))
			cOriMunPre := (cAliasCT)->REM_MUNICI //NoAcentoCte( Posicione('CC2',1,xFilial("CC2")+ DUY->DUY_EST + DUY->DUY_CODMUN,"CC2_MUN") )
			cOriUFPre  := (cAliasCT)->REM_UF //NoAcentoCte( DUY->DUY_EST )
		//	EndIf
		//EndIf

			(cAliasTagE)->(dBCloseArea())

		//-- Documentos Originarios
			aDocOri		:= {}
			cAliasInfNF := DataSource( 'DOCUMENTOS_ORIGINARIOS' )
			If (cAliasInfNF)->( EOF() )
				(cAliasInfNF)->(dbCloseArea())
				cAliasInfNF := DataSource( 'DOCUMENTO_DE_APOIO' )
			EndIf
			If !(cTipoNF $ '3,6,7') //-- Documento Nao Fiscal
				While !(cAliasInfNF)->( EOF() )
					If aScan(aDocOri,{|x|x[1]+x[2]==(cAliasInfNF)->DTC_SERNFC+(cAliasInfNF)->DTC_NUMNFC})==0
						AADD( aDocOri, {;
							(cAliasInfNF)->DTC_SERNFC,;
							(cAliasInfNF)->DTC_NUMNFC,;
							(cAliasInfNF)->DTC_EMINFC,;
							(cAliasInfNF)->DTC_VALOR,;
							(cAliasInfNF)->DTC_PESO,;
							(cAliasInfNF)->DTC_CLIDEV,;
							(cAliasInfNF)->DTC_LOJDEV,;
							(cAliasInfNF)->DTC_NFEID} )
					EndIf
					(cAliasInfNF)->(dbSkip())
				EndDo
			Else
				While !(cAliasInfNF)->( EOF() )
					If aScan(aDocOri,{|x|x[1]+x[2]==(cAliasInfNF)->DTC_SERNFC+(cAliasInfNF)->DTC_NUMNFC})==0
						AADD( aDocOri, {;
							'',; //Documento Nao Fiscal nao envia Serie
						(cAliasInfNF)->DTC_NUMNFC,;
							(cAliasInfNF)->DTC_EMINFC,;
							'',; //Documento Nao Fiscal nao envia Valor
						'',; //(cAliasInfNF)->DTC_PESO,;
							(cAliasInfNF)->DTC_CLIDEV,;
							(cAliasInfNF)->DTC_LOJDEV,;
							(cAliasInfNF)->DTC_NFEID} )
					EndIf
					(cAliasInfNF)->(dbSkip())
				EndDo
			EndIf
			(cAliasInfNF)->(dbCloseArea())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se possui numero da viagem                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cViagem  := Posicione('DTP',2,xFilial('DTP')+(cAliasCT)->DT6_FILORI+(cAliasCT)->DT6_LOTNFC,'DTP_VIAGEM')
			
			If !Empty(cViagem)
				cAliasDev := DataSource( 'CLIENTE_DEVEDOR' )
				nQtdDev := 0
				While (cAliasDev)->(!Eof())
					If nQtdDev > 1
						Exit
					EndIf
					nQtdDev += 1
					(cAliasDev)->(dbSkip())
				EndDo
				(cAliasDev)->(dbCloseArea())
				lLotacao := (nQtdDev == 1)
			EndIf

			//(cAliasInfNF)->(dbCloseArea())
		//-- RNTRC
			cRNLotacao	:= If(lLotacao, "Lotação", "Carga Fracionada")
			cRNDtPrv	:= AllTrim((cAliasCT)->DT6_PRZENT)
			cRNDtPrv	:= SubStr(cRNDtPrv,7,2) + '/' + SubStr(cRNDtPrv,5,2) + "/" + SubStr(cRNDtPrv,1,4)
			cRNMensagem	:= "Esse Conhecimento de Transporte atende á Legislação de Transporte Rodoviário em Vigor"

		ElseIf lXML
		//-- CFOP
			cCFOP		:= AllTrim(oNfe:_CTE:_INFCTE:_IDE:_CFOP:TEXT)
			cDescCfop	:= AllTrim(oNfe:_CTE:_INFCTE:_IDE:_NATOP:TEXT)

		//-- Origem da Prestacao
			cOriMunPre	:= (cAliasCT)->REM_MUNICI//Iif(Type("oNfe:_CTE:_INFCTE:_IDE:_XMUNINI:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_IDE:_XMUNINI:TEXT)
			cOriUFPre	:= (cAliasCT)->REM_UF//oNfe:_CTE:_INFCTE:_IDE:_UFINI:TEXT

		//-- Destino da Prestacao
			cDesMunPre	:= (cAliasCT)->DES_MUNICI//oNfe:_CTE:_INFCTE:_IDE:_XMUNFIM:TEXT
			cDesUFPre	:= (cAliasCT)->DES_UF//oNfe:_CTE:_INFCTE:_IDE:_UFFIM:TEXT

		//-- Remetente
			cRemMun   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XMUN:TEXT
			cRemUF    := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_UF:TEXT
			cRemNome  := oNfe:_CTE:_INFCTE:_REM:_XNOME:TEXT
			cRemEnd   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XLGR:TEXT
			cRemNro   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_NRO:TEXT
			cRemCompl := ""
			cRemBair  := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XBAIRRO:TEXT
			cRemCEP   := oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_CEP:TEXT
			cRemCNPJ  := Iif(Type("oNfe:_CTE:_INFCTE:_REM:_CNPJ:TEXT")=="U",oNfe:_CTE:_INFCTE:_REM:_CPF:TEXT,oNfe:_CTE:_INFCTE:_REM:_CNPJ:TEXT)
			cRemIE    := Iif(Type("oNfe:_CTE:_INFCTE:_REM:_IE:TEXT"  )=="U"," ",oNfe:_CTE:_INFCTE:_REM:_IE:TEXT)
			cRemPais  := Iif(Type("oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XPAIS:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_REM:_ENDERREME:_XPAIS:TEXT)
			cRemFone  := Iif(Type("oNfe:_CTE:_INFCTE:_REM:_FONE:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_REM:_FONE:TEXT)

		//-- Expedidor
			If (Type("oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET")) <> "U"
				cExpNome	:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XNOME:TEXT
				cExpEnd		:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XLGR:TEXT
				cExpNro		:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_NRO:TEXT
				cExpMun		:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XMUN:TEXT
				cExpBai		:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_XBAIRRO:TEXT
				cExpUF		:= oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_UF:TEXT
				cExpDoc		:= Iif(Type("oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_CNPJ:TEXT")=="U", oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_CPF:TEXT , oNfe:_CTE:_INFCTE:_REM:_INFNF:_LOCRET:_CNPJ:TEXT)
				cExpPais	:= cRemPais
			ElseIf (Type("oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED")) <> "U"
				//lSeqRec := .T.
				cExpNome	:= SubStr(oNfe:_CTE:_INFCTE:_EXPED:_XNOME:TEXT,1,51)
				cExpEnd		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XLGR:TEXT + ", " + oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_NRO:TEXT
				cExpBai		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XBAIRRO:TEXT
				cExpMun		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XMUN:TEXT
				cExpUF		:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_UF:TEXT
				If Type("oNfe:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT")=="U"
					cExpCPF	:= oNfe:_CTE_EXPED:_CPF:TEXT
				Else
					cExpCGC	:= oNfe:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT
					cExpIE 	:= oNfe:_CTE:_INFCTE:_EXPED:_IE:TEXT
					lExpPJ	:= .T.
				EndIf               
				cExpDoc	:= Iif(Type("oNfe:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT")=="U", oNfe:_CTE:_INFCTE:_EXPED:_CPF:TEXT , oNfe:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT)
				cExpPais	:= oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_XPAIS:TEXT
				
				cExpCEP  := oNfe:_CTE:_INFCTE:_EXPED:_ENDEREXPED:_CEP:TEXT   
				cExpFone := Iif(Type("oNfe:_CTE:_INFCTE:_EXPED:_FONE:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_EXPED:_FONE:TEXT)
			
			EndIf

		//-- Destinatario
			cDesMun   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XMUN:TEXT
			cDesUF    := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT
			cDesNome  := oNfe:_CTE:_INFCTE:_DEST:_XNOME:TEXT
			cDesEnd   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XLGR:TEXT
			cDesNro   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_NRO:TEXT
			cDesCompl := ""
			cDesBair  := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XBAIRRO:TEXT
			cDesCEP   := oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_CEP:TEXT
			cDesCNPJ  := Iif(Type("oNfe:_CTE:_INFCTE:_DEST:_CNPJ:TEXT")=="U",    oNfe:_CTE:_INFCTE:_DEST:_CPF:TEXT, oNfe:_CTE:_INFCTE:_DEST:_CNPJ:TEXT)
			cDesIE    := Iif(Type("oNfe:_CTE:_INFCTE:_DEST:_IE:TEXT"  )=="U"," ",oNfe:_CTE:_INFCTE:_DEST:_IE:TEXT)
			cDesPais  := Iif(Type("oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XPAIS:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_DEST:_ENDERDEST:_XPAIS:TEXT)
			cDesFone  := Iif(Type("oNfe:_CTE:_INFCTE:_DEST:_FONE:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_DEST:_FONE:TEXT)

		//-- Local de Entrega


			If (Type("oNfe:_CTE:_INFCTE:_DEST:_LOCENT")) <> "U"
				lSeqDes := .T.
			//Destino Prestacao
				cRecNome	:= oNfe:_CTE:_INFCTE:_DEST:_LOCENT:_XNOME:TEXT
				cRecEnd		:= oNfe:_CTE:_INFCTE:_DEST:_LOCENT:_XLGR:TEXT + ", " + oNfe:_CTE:_INFCTE:_DEST:_LOCENT:_NRO:TEXT
				cRecBai		:= oNfe:_CTE:_INFCTE:_DEST:_LOCENT:_XBAIRRO:TEXT
				cRecMun		:= oNfe:_CTE:_INFCTE:_DEST:_LOCENT:_XMUN:TEXT
				crecUF		:= oNfe:_CTE:_INFCTE:_DEST:_LOCENT:_UF:TEXT
				If Type("oNfe:_CTE:_INFCTE:_DEST:_LOCENT:_CNPJ:TEXT")=="U"
					cRecCPF	:= oNfe:_CTE:_INFCTE:_DEST:_LOCENT:_CPF:TEXT
				Else
					cRecCGC	:= oNfe:_CTE:_INFCTE:_DEST:_LOCENT:_CNPJ:TEXT
					cRecINSCR := oNfe:_CTE:_INFCTE:_DEST:_IE:TEXT
					lRecPJ	:= .T.
				EndIf
			ElseIf (Type("oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB")) <> "U"
				lSeqRec := .T.
			//Destino Recebedor
				cRecNome	:= oNfe:_CTE:_INFCTE:_RECEB:_XNOME:TEXT
				cRecEnd		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XLGR:TEXT + ", " + oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_NRO:TEXT
				cRecBai		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XBAIRRO:TEXT
				cRecMun		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_XMUN:TEXT
				crecUF		:= oNfe:_CTE:_INFCTE:_RECEB:_ENDERRECEB:_UF:TEXT
				If Type("oNfe:_CTE:_INFCTE:_RECEB:_CNPJ:TEXT")=="U"
					cRecCPF	:= oNfe:_CTE_RECEB:_CPF:TEXT
				Else
					cRecCGC	:= oNfe:_CTE:_INFCTE:_RECEB:_CNPJ:TEXT
					cRecINSCR := oNfe:_CTE:_INFCTE:_RECEB:_IE:TEXT
					lRecPJ	:= .T.
				EndIf
			EndIf
			     

		//-- Produto Predominante
			If (Type("oNFE:_CTE:_INFCTE:_INFCTENORM")) <> "U"
				cPPDesc			:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_PROPRED:TEXT
				cPPCarga		:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_XOUTCAT:TEXT
				If Type("oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_VMERC") <> "U"
					cPPVlTot	:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_VMERC:TEXT
				Else
					cPPVlTot	:= oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_VCARGA:TEXT
				EndIf
				If ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ ) == 'A'
					For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ )
						Do Case
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "PESO DECLARADO"
							cPPPesoB := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "PESO CUBADO"
							cPPPeso3 := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "LITRAGEM"
							cPPQtdVol := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "VOLUME"
							cPPQtdVol := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "METROS CUBICOS"
							cPPMetro3 := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
						EndCase
					Next nCount
				EndIf
			EndIf

		//-- Dados Seguradora
			cSegNome		:= ""
			cSegResp		:= ""
			cSegNrApoli		:= ""
			cSegNrAverb		:= ""
			
			If (Type("oNFE:_CTE:_INFCTE:_INFCTENORM:_SEG")) <> "U"
				cSegDesc	:= ""
				cSegNome	:= oNFE:_CTE:_INFCTE:_INFCTENORM:_SEG:_XSEG:TEXT
				cSegResp	:= oNFE:_CTE:_INFCTE:_INFCTENORM:_SEG:_RESPSEG:TEXT
				cSegNrApoli	:= oNFE:_CTE:_INFCTE:_INFCTENORM:_SEG:_NAPOL:TEXT
				If (Type("oNFE:_CTE:_INFCTE:_INFCTENORM:_SEG:_NAVER")) <> "U"
					cSegNrAverb	:= oNFE:_CTE:_INFCTE:_INFCTENORM:_SEG:_NAVER:TEXT // Campo nao obrigatorio.
				EndIf
				//-- Responsavel pelo Seguro
				If	cSegResp == "0"
					 cSegDesc := "Remetente"
				ElseIf	cSegResp == "1"
					cSegDesc := "Expedidor"
				ElseIf	cSegResp == "2"
					cSegDesc := "Recebedor"
				ElseIf	cSegResp == "3"
					cSegDesc := "Destinatario"
				ElseIf	cSegResp == "4"
					cSegDesc := "Emitente do CT-e"
				ElseIf 	cSegResp == "5"
					cSegDesc := "Tomador de Servico"
				EndIf
			EndIf

		//-- Tomador
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tomador do Servico         ³
		//³ 0 - Remetente;             ³
		//³ 1 - Expedidor;             ³
		//³ 2 - Recebedor;             ³
		//³ 3 - Destinatario.          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Type("oNfe:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT") <> "U"
				If oNfe:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT == "0"
					cDevMun   := cRemMun
					cDevUF    := cRemUF
					cDevNome  := cRemNome
					cDevEnd   := cRemEnd
					cDevNro   := cRemNro
					cDevCompl := cRemCompl
					cDevBair  := cRemBair
					cDevCEP   := cRemCEP
					cDevCNPJ  := cRemCNPJ
					cDevIE    := cRemIE
					cDevPais  := cRemPais
					cDevFone  := cRemFone
				Else
					cDevMun   := cDesMun
					cDevUF    := cDesUF
					cDevNome  := cDesNome
					cDevEnd   := cDesEnd
					cDevNro   := cDesNro
					cDevCompl := cDesCompl
					cDevBair  := cDesBair
					cDevCEP   := cDesCEP
					cDevCNPJ  := cDesCNPJ
					cDevIE    := cDesIE
					cDevPais  := cDesPais
					cDevFone  := cDesFone
				EndIf
			ElseIf Type("oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_TOMA:TEXT") <> "U"
				If oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_TOMA:TEXT == "4"
				// Subcontratacao DT6_DEVFRE == "4" - Despachante		
					cDevMun   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_XMUN:TEXT
					cDevUF    := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_UF:TEXT
					cDevNome  := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_XNOME:TEXT
					cDevEnd   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_XLGR:TEXT
					cDevNro   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_NRO:TEXT
					cDevCompl := ""
					cDevBair  := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_XBAIRRO:TEXT
					cDevCEP   := oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_CEP:TEXT
					cDevCNPJ  := Iif(Type("oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT")=="U",oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_CPF:TEXT,oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT)
					cDevIE    := Iif(Type("oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_IE:TEXT"  )=="U"," ",oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_IE:TEXT)
					cDevPais  := ""
					cDevFone  := Iif(Type("oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_FONE:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_IDE:_TOMA4:_FONE:TEXT)
				EndIf
			EndIf
		//-- Documentos Originarios
			aDocOri := {}
			If	( Type( "oNFE:_CTE:_INFCTE:_REM:_INFNFE" ) <> 'U' )
				If ValType( oNFE:_CTE:_INFCTE:_REM:_INFNFE ) == 'A'
					For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_REM:_INFNFE )
						If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_REM:_INFNFE[ nCount ]:_CHAVE:TEXT})==0
							AADD(aDocOri, {;
								'',;
								'',;
								'',;
								'',;
								'',;
								'',;
								'',;
								oNFE:_CTE:_INFCTE:_REM:_INFNFE[ nCount ]:_CHAVE:TEXT })
						EndIf
					Next nCount
				ElseIf ValType( oNFE:_CTE:_INFCTE:_REM:_INFNFE ) == 'O'
					If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_REM:_INFNFE:_CHAVE:TEXT})==0
						AADD(aDocOri, {;
							'',;
							'',;
							'',;
							'',;
							'',;
							'',;
							'',;
							oNFE:_CTE:_INFCTE:_REM:_INFNFE:_CHAVE:TEXT })
					EndIf
				EndIf
			ElseIf	( Type( "oNFE:_CTE:_INFCTE:_REM:_INFNF" ) <> 'U' )
				If ValType( oNFE:_CTE:_INFCTE:_REM:_INFNF ) == 'A'
					For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_REM:_INFNF )
						If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_NDOC:TEXT})==0
							AADD(aDocOri, {;
								oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_SERIE:TEXT,;
								oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_NDOC:TEXT,;
								STRTRAN(oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_DEMI:TEXT,'-'),;
								oNFE:_CTE:_INFCTE:_REM:_INFNF[ nCount ]:_VPROD:TEXT,;
								'',;
								'',;
								'',;
								'' })
						EndIf
					Next nCount
				Else
					If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_REM:_INFNF:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_REM:_INFNF:_NDOC:TEXT})==0
						AADD(aDocOri, {;
							oNFE:_CTE:_INFCTE:_REM:_INFNF:_SERIE:TEXT,;
							oNFE:_CTE:_INFCTE:_REM:_INFNF:_NDOC:TEXT,;
							STRTRAN(oNFE:_CTE:_INFCTE:_REM:_INFNF:_DEMI:TEXT,'-'),;
							oNFE:_CTE:_INFCTE:_REM:_INFNF:_VPROD:TEXT,;
							'',;
							'',;
							'',;
							'' })
					EndIf
				EndIf

			ElseIf	( Type( "oNFE:_CTE:_INFCTE:_REM:_INFOUTROS" ) <> 'U' )
				If ValType( oNFE:_CTE:_INFCTE:_REM:_INFOUTROS ) == 'A'
					For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_REM:_INFOUTROS )
						If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_REM:_INFOUTROS[ nCount ]:_NDOC:TEXT})==0
							AADD(aDocOri, {;
								'',; //SERIE DO DOCUMENTO NAO INFORMADA NO XML QUANDO O DOCUMENTO NAO EH FISCAL
							oNFE:_CTE:_INFCTE:_REM:_INFOUTROS[ nCount ]:_NDOC:TEXT,;
								STRTRAN(oNFE:_CTE:_INFCTE:_REM:_INFOUTROS[ nCount ]:_DEMI:TEXT,'-'),;
								'',; //--VALOR DO PRODUTO NAO INFORMADO NO XML QUANDO O DOCUMENTO NAO EH FISCAL
							'',;
								'',;
								'',;
								'' })
						EndIf
					Next nCount
				Else
					If ( Type( "oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_NDOC" ) <> 'U' );
						.And. ( Type( "oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_DEMI" ) <> 'U' )
						If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_NDOC:TEXT})==0
							AADD(aDocOri, {;
								'',;//SERIE DO DOCUMENTO NAO INFORMADA NO XML QUANDO O DOCUMENTO NAO EH FISCAL
							oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_NDOC:TEXT,;
								STRTRAN(oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_DEMI:TEXT,'-'),;
								'',; //--VALOR DO PRODUTO NAO INFORMADO NO XML QUANDO O DOCUMENTO NAO EH FISCAL
							'',;
								'',;
								'',;
								'' })
						EndIf
					Else
						If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_REM:_INFOUTROS:_NDOC:TEXT})==0
							AADD(aDocOri, {;
								'',;//SERIE DO DOCUMENTO NAO INFORMADA NO XML QUANDO O DOCUMENTO NAO EH FISCAL
							'',;
								'',;
								'',; //--VALOR DO PRODUTO NAO INFORMADO NO XML QUANDO O DOCUMENTO NAO EH FISCAL
							'',;
								'',;
								'',;
								'' })
						EndIf
				
					EndIf
				EndIf
				
			//Alison 05/06/14	
			ElseIf	( Type( "oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE" ) <> 'U' )
				If ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE ) == 'A'
					For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE )
						If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE[ nCount ]:_CHAVE:TEXT})==0
							AADD(aDocOri, {;
								'',;
								'',;
								'',;
								'',;
								'',;
								'',;
								'',;
								oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE[ nCount ]:_CHAVE:TEXT })
						EndIf
					Next nCount
				ElseIf ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE ) == 'O'
					If aScan(aDocOri,{|x|x[8]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT})==0
						AADD(aDocOri, {;
							'',;
							'',;
							'',;
							'',;
							'',;
							'',;
							'',;
							oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT })
					EndIf
				EndIf
			
			//Alison 05/06/14 "DTA"	
			ElseIf	( Type( "oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS" ) <> 'U' )
				If ValType( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS ) == 'A'
					For nCount := 1 To Len( oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS )
						If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS[ nCount ]:_NDOC:TEXT})==0
							AADD(aDocOri, {;
								'',; //SERIE DO DOCUMENTO NAO INFORMADA NO XML QUANDO O DOCUMENTO NAO EH FISCAL
							oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS[ nCount ]:_NDOC:TEXT,;
								STRTRAN(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS[ nCount ]:_DEMI:TEXT,'-'),;
								'',; //--VALOR DO PRODUTO NAO INFORMADO NO XML QUANDO O DOCUMENTO NAO EH FISCAL
							'',;
								'',;
								'',;
								'' })
						EndIf
					Next nCount
				Else
					If ( Type( "oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_NDOC" ) <> 'U' );
						.And. ( Type( "oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_DEMI" ) <> 'U' )
						If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_NDOC:TEXT})==0
							AADD(aDocOri, {;
								'',;//SERIE DO DOCUMENTO NAO INFORMADA NO XML QUANDO O DOCUMENTO NAO EH FISCAL
							oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_NDOC:TEXT,;
								STRTRAN(oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_DEMI:TEXT,'-'),;
								'',; //--VALOR DO PRODUTO NAO INFORMADO NO XML QUANDO O DOCUMENTO NAO EH FISCAL
							'',;
								'',;
								'',;
								'' })
						EndIf
					Else
						If aScan(aDocOri,{|x|x[1]+x[2]==oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_SERIE:TEXT+oNFE:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFOUTROS:_NDOC:TEXT})==0
							AADD(aDocOri, {;
								'',;//SERIE DO DOCUMENTO NAO INFORMADA NO XML QUANDO O DOCUMENTO NAO EH FISCAL
							'',;
								'',;
								'',; //--VALOR DO PRODUTO NAO INFORMADO NO XML QUANDO O DOCUMENTO NAO EH FISCAL
							'',;
								'',;
								'',;
								'' })
						EndIf
				
					EndIf
				EndIf
				
			EndIf
				
		//-- RNTRC
			If (Type("oNFE:_CTE:_INFCTE:_INFCTENORM")) <> "U"
				If (Type("oNFE:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO")) <> "U"
					cRNLotacao	:= If( oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LOTA:TEXT == '0', "Carga Fracionada", "Lotação")
					cRNDtPrv	:= oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_DPREV:TEXT
					cRNDtPrv	:= SubStr(cRNDtPrv,9,2) + '/' + SubStr(cRNDtPrv,6,2) + '/' + SubStr(cRNDtPrv,1,4)
					cRNMensagem	:= "Esse Conhecimento de Transporte atende á Legislação de Transporte Rodoviário em Vigor"
				Else
					cRNLotacao	:= If( oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LOTA:TEXT == '0', "Carga Fracionada", "Lotação")
					cRNDtPrv	:= oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_DPREV:TEXT
					cRNDtPrv	:= SubStr(cRNDtPrv,9,2) + '/' + SubStr(cRNDtPrv,6,2) + '/' + SubStr(cRNDtPrv,1,4)
					cRNMensagem	:= "Esse Conhecimento de Transporte atende á Legislação de Transporte Rodoviário em Vigor"
				EndIf
			ElseIf (Type("oNFE:_CTE:_INFCTE:_INFCTECOMP")) <> "U"
				cRNDtPrv	:= oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT
				cRNDtPrv	:= SubStr(cRNDtPrv,9,2) + '/' + SubStr(cRNDtPrv,6,2) + '/' + SubStr(cRNDtPrv,1,4)
				cRNMensagem	:= "Esse Conhecimento de Transporte atende á Legislação de Transporte Rodoviário em Vigor"	
			EndIf
		EndIf	//-- lXML

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: CFOP - Natureza da Prestacao                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oDacte:Box(0224, 0000, 0241, 0559)
		oDacte:Say(0230, 0003, "CFOP - Natureza da Prestação",	oFont08N)
		oDacte:Say(0238, 0003, cCFOP + " - " + cDescCfop,		oFont08)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: ORIGEM DA PRESTACAO                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oDacte:Box(0243, 0000, 0260, 0279)
		oDacte:Say(0249, 0003, "Origem da Prestação" , oFont08N)
		//oDacte:Say(0257, 0003, AllTrim(cOriMunPre) + ' - ' + AllTrim(cOriUFPre), oFont08)
		oDacte:Say(0257, 0003, AllTrim(cOriMunPre) , oFont08)//Mun e UF na mesma variavel

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: DESTINO DA PRESTACAO                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oDacte:Box(0243, 0281, 0260, 0559)
		oDacte:Say(0249, 0288, "Destino da Prestação", oFont08N)
		//oDacte:Say(0257, 0288, AllTrim(cDesMunPre) + ' - ' + AllTrim(cDesUFPre), oFont08)
		oDacte:Say(0257, 0288, AllTrim(cDesMunPre) , oFont08)//Mun e UF na mesma variavel

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: Remetente                                                         ³
	//³ BOX: Destinatario                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oDacte:Box(0262, 0000, 0313, 0279)	//Remetente
		oDacte:Box(0262, 0281, 0313, 0559)	//Destinatario

		oDacte:Say(0268, 0003, "Remetente:", oFont08)
		oDacte:Say(0268, 0043, NoAcentoCte(Substr(cRemNome,1,50)), oFont08N)
		oDacte:Say(0268, 0288, "Destinatario:", oFont08)
		oDacte:Say(0268, 0328, NoAcentoCte(Substr(cDesNome,1,50)), oFont08N)

		cInsRemOpc := AllTrim(cRemIE)
		For nCount := 1 To 5
			Do Case
			Case ( nCount == 1 )
				oDacte:Say(0277, 0003, "Endereço:", oFont08)
				oDacte:Say(0277, 0043, AllTrim(cRemEnd) + ", " + cRemNro, oFont08)
				oDacte:Say(0277, 0288, "Endereço:", oFont08)
				oDacte:Say(0277, 0328, AllTrim(cDesEnd) + ", " + cDesNro, oFont08)
			Case ( nCount == 2 )
				oDacte:Say(0284, 0043, AllTrim(cRemCompl) + " - " + AllTrim(cRemBair), oFont08)
				oDacte:Say(0284, 0328, AllTrim(cDesCompl) + " - " + AllTrim(cDesBair), oFont08)
			Case ( nCount == 3 )
				oDacte:Say(0291, 0003, "Municipio:", oFont08)
				oDacte:Say(0291, 0043, AllTrim(cRemMun) + ' - ' + AllTrim(cRemUF)  + ' CEP.: ' + Transform(AllTrim(cRemCEP), "@r 99999-999"), oFont08)
				oDacte:Say(0291, 0288, "Municipio:", oFont08)
				oDacte:Say(0291, 0328, AllTrim(cDesMun) + ' - ' + AllTrim(cDesUF) + ' CEP.: ' + Transform(AllTrim(cDesCEP), "@r 99999-999"), oFont08)
			Case ( nCount == 4 )
				oDacte:Say(0298, 0003, "CNPJ/CPF:", oFont08)
				oDacte:Say(0298, 0043, Transform(AllTrim(cRemCNPJ), "@r 99.999.999/9999-99") + "   Inscrição Estadual: " +  AllTrim(cInsRemOpc), oFont08)
				oDacte:Say(0298, 0288, "CNPJ/CPF:", oFont08)
				oDacte:Say(0298, 0328, Transform(AllTrim(cDesCNPJ), "@r 99.999.999/9999-99") + "   Inscrição Estadual: " +  AllTrim(cDesIE),    oFont08)
			Case ( nCount == 5 )
				oDacte:Say(0305, 0003, "Pais:", oFont08)
				oDacte:Say(0305, 0043, AllTrim(cRemPais) + ' Telefone.: ' + Transform(AllTrim(cRemFone),"@r (999) 999999999"),  oFont08)
				oDacte:Say(0305, 0288, "Pais:", oFont08)
				oDacte:Say(0305, 0328, AllTrim(cDesPais) + ' Telefone.: ' + Transform(AllTrim(cDesFone),"@r (999) 999999999"), oFont08)
			EndCase
		Next nCount

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: Expedidor / BOX: Recebedor                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oDacte:Box(0315, 0000, 0366, 0279)	//Expedidor
		oDacte:Box(0315, 0281, 0366, 0559)	//Recebedor

		oDacte:Say(0322, 0003, "Expedidor:", oFont08)
		oDacte:Say(0322, 0043, cExpNome    , oFont08N)

	//-- Sequencia de endereco preenchida, fica como local de entrega.
	
		If lSeqDes
			oDacte:Say(0322, 0288, "Local de Entrega:", oFont08)
			oDacte:Say(0322, 0342,  NoAcentoCte(Substr(cRecNome,1,50)), oFont08N)
		EndIf
	
		If lSeqRec
			oDacte:Say(0322, 0288, "Recebedor:", oFont08)
			oDacte:Say(0322, 0328,  NoAcentoCte(Substr(cRecNome,1,50)), oFont08N)
		EndIf

		If !lSeqDes .And. !lSeqRec
			oDacte:Say(0322, 0288, "Recebedor:", oFont08)
		EndIf

		For nCount := 1 To 5
			Do Case
			Case ( nCount == 1 )
				oDacte:Say(0331, 0003, "Endereço:", oFont08)
				oDacte:Say(0331, 0043, cExpEnd    , oFont08)
				oDacte:Say(0331, 0288, "Endereço:", oFont08)
				//-- Sequencia de endereco preenchida, fica como local de entrega.
				oDacte:Say(0331, 0328, If(lSeqDes .or. lSeqRec, AllTrim(FisGetEnd(cRecEnd)[1]) + ", " + Iif(FisGetEnd(cRecEnd)[2]<>0, AllTrim(cValtoChar(FisGetEnd(cRecEnd)[2])),"S/N"),""), oFont08)
			Case ( nCount == 2 )
				oDacte:Say(0338, 0043, " - "+AllTrim(cExpBai), oFont08)
				oDacte:Say(0338, 0328, If(lSeqDes .or. lSeqRec, AllTrim(cValtoChar(FisGetEnd(cRecEnd)[4])) + " - " + AllTrim(cRecBai),""), oFont08)
			Case ( nCount == 3 )
				oDacte:Say(0345, 0003, "Municipio:", oFont08)
				oDacte:Say(0345, 0043, AllTrim(cExpMun)  + ' - ' + AllTrim(cExpUF)  + ' CEP.: ' + Transform(AllTrim(cExpCEP), "@r 99999-999")    , oFont08)
				oDacte:Say(0345, 0288, "Municipio:", oFont08)
				oDacte:Say(0345, 0328, If(lSeqDes .or. lSeqRec, AllTrim(cRecMun) + ' - ' + AllTrim(cRecUF),""), oFont08)
			Case ( nCount == 4 )
				oDacte:Say(0352, 0003, "CNPJ/CPF:", oFont08)
				oDacte:Say(0352, 0043, Transform(cExpDoc,"@r 99.999.999/9999-99") + "   Inscrição Estadual: " +  AllTrim(cExpIE)    , oFont08)
				oDacte:Say(0352, 0288, "CNPJ/CPF:", oFont08)
				If lSeqDes .or. lSeqRec
					If lRecPJ
						oDacte:Say(0352, 0328, Transform(cRecCGC,"@r 99.999.999/9999-99") + "   Inscrição Estadual: " +  cRecINSCR, oFont08)
					Else
						oDacte:Say(0352, 0328, Transform(cRecCPF,"@r 999.999.999-99"), oFont08)
					EndIf
				Else
					oDacte:Say(0352, 0328, "", oFont08)
				EndIf

			Case ( nCount == 5 )
				oDacte:Say(0359, 0003, "Pais:" , oFont08)
				oDacte:Say(0359, 0043, AllTrim(cExpPais) + ' Telefone.: ' + Transform(AllTrim(cExpFone),"@r (999) 999999999"), oFont08)
				oDacte:Say(0359, 0288, "Pais:" , oFont08)
				oDacte:Say(0359, 0328, If(lSeqDes .or. lSeqRec ,AllTrim(cDesPais),""), oFont08)
			EndCase
		Next nCount

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: Tomador do Servico                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oDacte:Box(0368, 0000, 0395, 0559)
		oDacte:Say(0375, 0003, "Tomador do Serviço:", oFont08)
		oDacte:Say(0375, 0070, NoAcentoCte(SubStr(cDevNome,1,45)), oFont08)
		oDacte:Say(0375, 0328, "Municipio:", oFont08)
		oDacte:Say(0375, 0368, AllTrim(cDevMun) + ' - ' + AllTrim(cDevUF) + ' CEP.: ' + Transform(AllTrim(cDevCEP),"@r 99999-999"), oFont08)

		For nCount := 1 To 2
			Do Case
			Case ( nCount == 1 )
				oDacte:Say(0383, 0003, "Endereço:", oFont08)
				oDacte:Say(0383, 0043, SubStr(AllTrim(cDevEnd),1,40) + ", " + cDevNro + " - "	+;
					AllTrim(cDevCompl) + " - " + AllTrim(cDevBair), oFont08)
				oDacte:Say(0383, 0328, "Pais: ", oFont08)
				oDacte:Say(0383, 0368, AllTrim(cDevPais), oFont08)
			Case ( nCount == 2 )
				oDacte:Say(0391, 0003, "CNPJ/CPF:", oFont08)
				oDacte:Say(0391, 0043, Transform(AllTrim(cDevCNPJ),"@r 99.999.999/9999-99") + "   Inscrição Estadual: " + AllTrim(cDevIE), oFont08)
				oDacte:Say(0391, 0328, "Telefone:", oFont08)
				oDacte:Say(0391, 0368, Transform(AllTrim(cDevFone),"@r (999) 999999999"), oFont08)
			EndCase
		Next nCount

		If	AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 2, Len(DT6->DT6_DOCTMS)) .Or.;
				AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 6, Len(DT6->DT6_DOCTMS)) .Or.;
				AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 7, Len(DT6->DT6_DOCTMS)) .Or.;
				AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 9, Len(DT6->DT6_DOCTMS)) .Or.;
				AllTrim((cAliasCT)->DT6_DOCTMS) == 'A' .Or. AllTrim((cAliasCT)->DT6_DOCTMS) == 'E' .Or. ;
				(AllTrim((cAliasCT)->DT6_DOCTMS) == 'B' .Or. AllTrim((cAliasCT)->DT6_DOCTMS) == 'C' .And. ;
				Empty(Posicione('DUI',1,xFilial('DUI')+(cAliasCT)->DT6_DOCTMS,'DUI_DOCFAT')) )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ BOX: Prod Predom || Outras Caract || Valor Total da Mercadoria         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oDacte:Box(0397 , 0000, 0414, 0559)
			oDacte:Line(0397, 0189, 0414, 0189) // Linha: Prod.Predominante e Out.Caracteristicas
			oDacte:Line(0397, 0378, 0414, 0378) // Linha: Out.Caracteristicas e Vlr.Total
			oDacte:Say(0403, 0003, "Produto Predominante"           , oFont08N)
			oDacte:Say(0403, 0192, "Outras Caracteristicas da Carga", oFont08N)
			oDacte:Say(0403, 0381, "Valor Total da Mercadoria"      , oFont08N)
			oDacte:Say(0411, 0003, SubStr(cPPDesc,1,40), oFont08)	//Produto Predominante
			oDacte:Say(0411, 0192, AllTrim(cPPCarga)	, oFont08)	//Outras Caracteristicas da Carga
			oDacte:Say(0411, 0381, PadL( Transform( val(cPPVlTot), PesqPict("DT6","DT6_VALMER") ), 20 ), oFont08)	//Valor Total da Mercadoria

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ BOX: QNT. / UNIDADE MEDIDA /                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oDacte:Box(0416, 0000, 0443,  0315)
			oDacte:Say(0423 , 0003, "Peso Bruto (KG)"	, oFont08N)
			oDacte:Say(0423 , 0067, "Peso Cubado    "	, oFont08N)
			oDacte:Say(0423 , 0131, "M³             "	, oFont08N)
			oDacte:Say(0423 , 0195, "Qtd. Volume (Un)"	, oFont08N)
			oDacte:Say(0423 , nCInic, "                ", oFont08N)
			oDacte:Line(0416, 0064, 0443, 0064) // Linha: Separador Peso Bruto (KG) / Peso Cubado
			oDacte:Line(0416, 0128, 0443, 0128) // Linha: Separador Peso Cubado / M³
			oDacte:Line(0416, 0192, 0443, 0192) // Linha: Separador M³ / Qtd. Volume (Un)
			oDacte:Line(0416, 0256, 0443, 0256) // Linha: SeparadorQtd. Volume (Un) /

			If lXml
				oDacte:Say(0431, 0003, Transform(val(cPPPesoB) ,	PesqPict("DT6","DT6_PESO")   ),	oFont08)
				oDacte:Say(0431, 0067, Transform(val(cPPPeso3) ,	PesqPict("DT6","DT6_PESOM3") ),	oFont08)
				oDacte:Say(0431, 0131, Transform(val(cPPMetro3),	PesqPict("DT6","DT6_METRO3") ),	oFont08)
				oDacte:Say(0431, 0195, Transform(val(cPPQtdVol),	PesqPict("DT6","DT6_VOLORI") ),	oFont08)
			Else
				oDacte:Say(0431, 0003, Transform(cPPPesoB,	PesqPict("DT6","DT6_PESO")   ),	oFont08)
				oDacte:Say(0431, 0067, Transform(cPPPeso3,	PesqPict("DT6","DT6_PESOM3") ),	oFont08)
				oDacte:Say(0431, 0131, Transform(cPPMetro3,	PesqPict("DT6","DT6_METRO3") ),	oFont08)
				oDacte:Say(0431, 0195, Transform(cPPQtdVol,	PesqPict("DT6","DT6_VOLORI") ),	oFont08)
			EndIf

		//-- Zera as variaveis(Peso, Peso Cubado, Metro Cubico e Qtd Volume) depois de impresso no DACTE.
			cPPPesoB  := ""
			cPPPeso3  := ""
			cPPMetro3 := ""
			cPPQtdVol := ""
		//Retorna Informações Referente ao Seguro - Igor Franzoi
			//aSeg			:=	GetSegInfo()
		
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ BOX: SEGURADORA                                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		  /*	oDacte:Box(0416 , 0317, 0443,  0559)
			oDacte:Say(0423 , 0324, "Nome da Seguradora:"	, oFont08N)
			oDacte:Say(0423 , 0400, Alltrim(aSeg[4])		, oFont08N)
			oDacte:Line(0426, 0317, 0426, 0559)							// Linha: Separador Nome da Seguradora / Responsavel
			oDacte:Say(0433 , 0324, "Responsavel"			, oFont08N)
			oDacte:Say(0440 , 0324, AllTrim(aSeg[1])		, oFont08N)
			oDacte:Line(0426, 0402, 0443, 0402)							// Linha: Separador Responsavel / Número da Apolice
			oDacte:Say(0433 , 0405, "Número da Apolice"		, oFont08N)
			oDacte:Say(0440 , 0405, AllTrim(aSeg[2])		, oFont08N)
			oDacte:Line(0426, 0485, 0443, 0485)							// Linha: Separador Número da Apolice / Número da Averbação
			oDacte:Say(0433 , 0487, "Número da Averbação"	, oFont08N)
			oDacte:Say(0440 , 0487, AllTrim(aSeg[3])				, oFont08N)   */
			
			oDacte:Box(0416 , 0317, 0443,  0559)
			oDacte:Say(0423 , 0324, "Nome da Seguradora:"	, oFont08N)
			oDacte:Say(0423 , 0400, cSegNome				, oFont08N)
			oDacte:Line(0426, 0317, 0426, 0559)							// Linha: Separador Nome da Seguradora / Responsavel
			oDacte:Say(0433 , 0324, "Responsavel"			, oFont08N)
			oDacte:Say(0440 , 0324, cSegDesc				, oFont08N)
			oDacte:Line(0426, 0402, 0443, 0402)							// Linha: Separador Responsavel / Número da Apolice
			oDacte:Say(0433 , 0405, "Número da Apolice"		, oFont08N)
			oDacte:Say(0440 , 0405, cSegNrApoli				, oFont08N)
			oDacte:Line(0426, 0479, 0443, 0479)							// Linha: Separador Número da Apolice / Número da Averbação
			oDacte:Say(0433 , 0482, "Número da Averbação"	, oFont08N)
			oDacte:Say(0440 , 0477, cSegNrAverb				, oFont08N)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Conteudo do Box: Componentes do Valor da Prestacao de Servico          ³
		//³ Conteudo do Box: Informacoes Relativas ao Imposto                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			TMSR27Comp(lXml,aCab)

			cAliasPeri := DataSource("PRODUTOS_PERIGOSOS")
			If (cAliasPeri)->(!Eof())
				lPerig := .T.
			EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ BOX: DOCUMENTOS ORIGINARIOS                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oDacte:Box(0533 , 0000, 0590, 0559)
			If Empty(cCtrDpc)
				oDacte:Say(00539 , 0243, "Documentos Originários",oFont08N)
			Else
				oDacte:Say(00528 , 0243, "Documentos Originários",oFont08N)
				oDacte:Say(00539 , 0443, "Documentos Anteriores ",oFont08N)
			EndIf

			oDacte:Line(0541, 0000, 0541, 0559)	// Linha: Abaixo    DOCUMENTOS ORIGINARIOS
			oDacte:Line(0541, 0283, 0590, 0283)	// Linha: Separador DOCUMENTOS ORIGINARIOS
		
			oDacte:Say(0548 , 0003, "Tp.Doc"            , oFont08N)
			oDacte:Say(0548 , 0033, "CNPJ/CPF Emitente" , oFont08N)
			oDacte:Say(0548 , 0163, "Série/Nr.Documento", oFont08N)
			oDacte:Say(0548 , 0286, "Tp.Doc"            , oFont08N)
			oDacte:Say(0548 , 0316, "CNPJ/CPF Emitente" , oFont08N)
			oDacte:Say(0548 , 0448, "Série/Nr.Documento", oFont08N)
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Documentos Originarios                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lControl := .F.
			nLInic   := 0556

			nCount := 0
			aDoc   := {}

			RetInfoDocs(@aDocOri)
			For nCount := 1 to Len( aDocOri )
				lControl := !lControl
				If nCount < 11
					If Empty(cCtrDpc)
						If lControl
							If Empty(AllTrim(aDocOri[nCount][doDTC_NFEID])) .And. !Empty(AllTrim(aDocOri[nCount][doDTC_SERNFC]))
							//-- Imprime a Chave da NF-e, lado esquerdo
								oDacte:Say(nLInic, 0003, "NF", oFont08)
								oDacte:Say(nLInic, 0073, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
								oDacte:Say(nLInic, 0163, AllTrim(aDocOri[nCount][doDTC_SERNFC] + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC])), oFont08)
							ElseIf Empty(AllTrim(aDocOri[nCount][doDTC_NFEID]))
							//-- Imprime os dados do documento não fiscal do lado esquerdo.
								oDacte:Say(nLInic, 0003, "Outros", oFont08)
								oDacte:Say(nLInic, 0073, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
								oDacte:Say(nLInic, 0163, AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)
							Else
							//-- Imprime a Chave da NF-e, lado esquerdo
								cChaveA := AllTrim(aDocOri[nCount][doDTC_NFEID])
								oDacte:Say(nLInic, 0003, "NF-E CHAVE:", oFont08)
								oDacte:Say(nLInic, 53 /*0073*/, cChaveA, oFont08)
								oDacte:Say(nLInic, 0223, AllTrim(aDocOri[nCount][doDTC_SERNFC] + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC])), oFont08)
								cChaveA := ''
							EndIf
						Else
							//-- Imprime a Chave da NF-e, lado direito
							If Empty(AllTrim(aDocOri[nCount][doDTC_NFEID])) .And. !Empty(AllTrim(aDocOri[nCount][doDTC_SERNFC]))
								oDacte:Say(nLInic, 0286, "NF", oFont08)
								oDacte:Say(nLInic, 0356, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
								oDacte:Say(nLInic, 0448, AllTrim(aDocOri[nCount][doDTC_SERNFC]) + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)
							ElseIf Empty(AllTrim(aDocOri[nCount][doDTC_NFEID]))
							//-- Imprime os dados do documento não fiscal do lado esquerdo.
								oDacte:Say(nLInic, 0286, "Outros", oFont08)
								oDacte:Say(nLInic, 0356, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
								oDacte:Say(nLInic, 0448, AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)
							Else
							//-- Imprime a Chave da NF-e, lado direito
								cChaveB := AllTrim(aDocOri[nCount][doDTC_NFEID])
								oDacte:Say(nLInic, 0286, "NF-E CHAVE:", oFont08)
								oDacte:Say(nLInic, 0336 /*0356*/, cChaveB, oFont08)
								oDacte:Say(nLInic, 0506, AllTrim(aDocOri[nCount][doDTC_SERNFC]) + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)
								cChaveB := ''
							EndIf
						EndIf
					ElseIf lControl
						If Empty(AllTrim(aDocOri[nCount][doDTC_NFEID])) .And. !Empty(AllTrim(aDocOri[nCount][doDTC_SERNFC]))
							oDacte:Say(nLInic, 0003, "NF", oFont08)
							oDacte:Say(nLInic, 0033, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
							oDacte:Say(nLInic, 0163, AllTrim(aDocOri[nCount][doDTC_SERNFC]) + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)
						ElseIf Empty(AllTrim(aDocOri[nCount][doDTC_NFEID]))
							oDacte:Say(nLInic, 0003, "Outros", oFont08)
							oDacte:Say(nLInic, 0033, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
							oDacte:Say(nLInic, 0163, AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)
						Else
						//-- Imprime a Chave da NF-e, lado direito
							cChaveA := AllTrim(aDocOri[nCount][doDTC_NFEID])
							oDacte:Say(nLInic, 0003, "NF-E CHAVE:", oFont08)
							oDacte:Say(nLInic, 0053 /*0110*/, cChaveA, oFont08)
							oDacte:Say(nLInic, 0223, AllTrim(aDocOri[nCount][doDTC_SERNFC] + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC])), oFont08)
							cChaveA := ''
						EndIf
						If !Empty(cCtrDpc)
							If Empty(cCTEDocAnt)
								oDacte:Say(nLInic, 0286, cDesDocAnt, oFont08)
								oDacte:Say(nLInic, 0316, Transform(AllTrim((cAliasCT)->DPC_CNPJ),"@r 99.999.999/9999-99"), oFont08)
								oDacte:Say(nLInic, 0448, AllTrim(cSerDpc) + " / " + AllTrim(cCtrDpc), oFont08)
							Else
							//-- Imprime a Chave da NF-e, lado esquerdo
								cChaveB := AllTrim(cCTEDocAnt)
								oDacte:Say(nLInic, 0286, "NF-E CHAVE:", oFont08)
								oDacte:Say(nLInic, 0506, cChaveB, oFont08)
								cChaveB := ''
							EndIf
						EndIf
					EndIf
				Else
					cTipoDoc := IIf(Empty(AllTrim(aDocOri[nCount][doDTC_SERNFC])),'Outros',IIf(Empty(AllTrim(aDocOri[nCount][doDTC_NFEID])),'NF','NF-e'))
					aadd(aDoc,{ AllTrim(cRemCNPJ),;
						AllTrim(aDocOri[nCount][doDTC_SERNFC]) + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC]),;
						AllTrim(aDocOri[nCount][doDTC_NFEID]),cTipoDoc})
				 //--Acrescenta o Tipo do Documento no aDoc
				EndIf
			
			// FORCAR A "QUEBRA" DA LINHA
				If ( (mod(nCount,2)) == 0 )
					If nCount < 11
						If !Empty(cChaveA)
							nLInic += 0008
							oDacte:Say(nLInic, 0003, "NF-E CHAVE:", oFont08)
							oDacte:Say(nLInic, 0240, cChaveA, oFont08)
							cChaveA := ''
						EndIf
						If !Empty(cChaveA)
							nLInic += 0008
							oDacte:Say(nLInic, 0286, "NF-E CHAVE:", oFont08)
							oDacte:Say(nLInic, 0316, cChaveB, oFont08)
							cChaveB := ''
						EndIf
						nLInic += 0008
					EndIf
				EndIf
			Next nCount
//		nLInic := 0020
			nLInic := 2050
		Else
			TMSR27Cmp()
			TMSR27Comp(lXml,aCab)
		EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: OBSERVACOES                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oDacte:Box(0592,  0000, 0643, 0559)
		oDacte:Say(0598,  0278, "Observações", oFont08N)
		oDacte:Line(0600, 0000, 0600, 0559) // Linha: OBSERVACOES

		If (cAliasCT)->DT6_AMBIEN == 2 .And. Empty((cAliasCT)->DT6_CHVCTG)
			oDacte:Say (0608, 0003, "DOCUMENTO GERADO EM AMBIENTE DE HOMOLOGAÇÃO", oFont10N)
		ElseIf !Empty((cAliasCT)->DT6_CHVCTG) .And. Substr((cAliasCT)->DT6_CHVCTG,3,1) == "5" .And. cVersaoCTE == "1.04" //"7-Contingência FS-DA"
			oDacte:Say (0608, 0003, "DACTE em Contingência - impresso em decorrência de problemas técnicos", oFont10N)
		EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: OBSERVACOES                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("DT6") //-- Nao retirar
		If lXml
			If Type("oNfe:_CTE:_INFCTE:_IMP:_INFADFISCO:TEXT") == "U"
				cDT6Obs := " "
			Else
				cDT6Obs := oNfe:_CTE:_INFCTE:_IMP:_INFADFISCO:TEXT
			EndIf
			If Type("oNfe:_CTE:_INFCTE:_COMPL:_XOBS:TEXT") == "U"
				cDTCObs := " "
			Else
				cDTCObs := oNfe:_CTE:_INFCTE:_COMPL:_XOBS:TEXT
			EndIf
			
			cObsCont := ""
			/*If Type("oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT") <> "U"
				If Type("oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT") == "A"
					For nObs1 := 1 To Len(oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT)
						If oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT[nObs1]:_XCAMPO:TEXT == "ValorContainer" 
							cObsCont += " Val.Container:"+AllTrim(Transform(Val(oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT[nObs1]:_XTEXTO:TEXT),"@E 999,999,999.99"))  
						Else
							cObsCont += oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT[nObs1]:_XTEXTO:TEXT 	 
						EndIf
					Next nObs1
				Else
					If oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT:_XCAMPO:TEXT == "ValorContainer" 
						cObsCont := "Val.Container:"+AllTrim(Transform(Val(oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT:_XTEXTO:TEXT),"@E 999,999,999.99"))	                 
					Else
						cObsCont := oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT:_XTEXTO:TEXT	                 
					EndIf
				EndIf
			Else
				cObsCont := ""
			EndIf*/
			
			If Type("oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT:_XTEXTO:TEXT") == "U"
				cObsCont := ""
			Else
				cObsCont := oNfe:_CTE:_INFCTE:_COMPL:_OBSCONT:_XTEXTO:TEXT
			EndIf
		Else
			cDT6Obs := MsMM((cAliasCT)->DT6_CODMSG)
			cDT6Obs := StrTran(cDT6Obs,Chr(10)," ")
			cDT6Obs := StrTran(cDT6Obs,Chr(13)," ")
		
			If (cAliasCT)->DT6_VALIMP > 0
				cObsCont := 'O valor aproximado dos tributos incidentes sobre o preco deste servico e de R$ '
				//	+ PADL(Transform((cAliasCT)->DT6_VALIMP,'@E 999,999.99'),20)
			EndIf
		EndIf 
		
		nObsLin 	:= 0608
		nObs	  	:= 0	
		
		If !Empty(cDT6Obs)
			oDacte:Say (nObsLin, 0003, cDT6Obs,  oFont08)
			nObsLin += 10
			nObs := 1
		EndIf                                    		

		cObs := RetObsCtr((cAliasCT)->DT6_FILDOC,(cAliasCT)->DT6_DOC,(cAliasCT)->DT6_SERIE)
		
		For nObs := nObs To 3
			If !Empty(cObs)
				oDacte:Say (nObsLin, 0003, SubStr(cObs,001,130), oFont08)
				cObs := SubStr(cObs,131,Len(cObs)-130)
				nObsLin += 10
			EndIf	
		Next nObs

		//cDT6Obs2:= SubStr(cObs,108,107)//Caracter 161 a 320
		//cObs := SubStr(cObs,1,107)  //Caracter 001 a 160
	
		//cDTCObs2:= SubStr(cDTCObs,108,107)
		//cDTCObs := SubStr(cDTCObs,1,107)
	
		//oDacte:Say (0608, 0003, cDT6Obs,  oFont08)
		//oDacte:Say (0616, 0003, cObs, oFont08)
	
		//oDacte:Say (0632, 0003, cDTCObs,  oFont08)
		//oDacte:Say (0640, 0003, cDTCObs2, oFont08)
		
		//nObsLin := 0624

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: INFORMACOES ESPECIFICAS DO MODAL                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//oDacte:Box(0643, 0000, 0672, 0559)
		oDacte:Box(0645, 0000, 0672, 0559)
		oDacte:Say(0652, 0210, "Dados Especificos do Modal Rodoviário - " + cRNLotacao, oFont08N) // Titulo nao pode ser "FIXO"
//		oDacte:Line(0652, 0000, 0652, 0559)
		oDacte:Say(0660, 0003, "RNTRC da Empresa"    			, oFont08N)
		oDacte:Say(0660, 0103, "CIOT"                 			, oFont08N)
		oDacte:Say(0660, 0173, "Data Prevista de Entrega"		, oFont08N)
		//oDacte:Say(0669, 0003, "RNTRC da Empresa: " + cTmsAntt	, oFont08)
		oDacte:Say(0669, 0003, cTmsAntt	, oFont08)
//--oDacte:Say(0619, 0146, cRNLotacao,	oFont08) // Reservar campo para uso de CIOT

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ RNTRC                                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oDacte:Say(0669, 0173, cRNDtPrv,	oFont08)
		oDacte:Say(0665, 0283, cRNMensagem,	oFont08)
		oDacte:Line(0653, 0000, 0653, 0559) // Linha: Horizontal Dados Especificos do Modal Rodoviário
		oDacte:Line(0653, 0100, 0672, 0100) // Linha: Separador RNTRC x Lotacao
		oDacte:Line(0653, 0170, 0672, 0170) // Linha: Separador Lotacao x Data Prevista de Entrega
		oDacte:Line(0653, 0280, 0672, 0280) // Linha: Separador Data Prevista de Entrega x Mensagem	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: DADOS DE LOTACAO/VALE PEDAGIO                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oDacte:Box( 0674, 0000, 0734, 0559)
		oDacte:Line(0674, 0239, 0734, 0239) // Linha Vertical: Separador Informacoes Veiculo x Vale Pedágio

		oDacte:Say(0680 , 0003, "Identificaçao do Conjunto Transportador", oFont08N)
		oDacte:Say(0680 , 0246, "Informações referentes ao vale-pedágio",  oFont08N)
		oDacte:Line(0682, 0000, 0682, 0559) // Linha Horizontal

		oDacte:Say(0688, 0003, "Tipo", oFont08N)
		oDacte:Say(0688, 0063, "Placa", oFont08N)
		oDacte:Say(0688, 0105, "UF", oFont08N)
		oDacte:Say(0688, 0125, "RNTRC", oFont08N)
		oDacte:Say(0688, 0246-4, "NRO.REG.ESP", oFont08N)
		oDacte:Say(0688, 0330-4, "Responsável", oFont08N)
		oDacte:Say(0688, 0455-4, "Valor Total", oFont08N)
		oDacte:Line(0690, 0000, 0690, 0559) // Linha Horizontal	:

		oDacte:Say(0696, 0246-4, "Empresa credenciada",		oFont08N)
		oDacte:Say(0696, 0330-4, "Vigência",				oFont08N)
		oDacte:Say(0696, 0400-4, "Número do Dispositivo",	oFont08N)
		oDacte:Say(0696, 0480-4, "Código da Transação",		oFont08N)
		oDacte:Line(0698, 0243-4, 0698, 0559)		// Linha Horizontal	:

		oDacte:Line(0690, 0060, 0744, 0060)			//Linha Vertical: Separador Tipo x Placa
		oDacte:Line(0690, 0102, 0744, 0102)			//Linha Vertical: Placa x UF
		oDacte:Line(0690, 0122, 0744, 0122)			//Linha Vertical: UF x RNTRC

		oDacte:Line(0682, 0327-4, 0690, 0327-4)	//Linha Vertical: NRO.REG.ESP x Responsável
		oDacte:Line(0682, 0452-4, 0690, 0452-4)	//Linha Vertical: Responsável x Valor Total

		oDacte:Line(0698, 0327-4, 0734, 0327-4)	//Linha Vertical: Empresa credenciada x Vigencia
		oDacte:Line(0698, 0397-4, 0734, 0397-4)	//Linha Vertical: Vigencia x Numero do Dispositivo
		oDacte:Line(0698, 0477-4, 0734, 0477-4)	//Linha Vertical: Numero do Dispositivo x Codigo da Transação

		nLInic:=0698
		nSoma := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ LINHAS: TIPO (VEICULO)                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lXml
			If (Type("oNFE:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO")) <> "U" .And. (oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LOTA:TEXT) == '1'

				_cNomTransp := ""
				aAreaDTQ := DTQ->(GetArea())
				DbSelectArea("DTQ")
				DbOrderNickName("XCTR")
				If DbSeek(xFilial("DTQ")+(cAliasCT)->DT6_DOC+(cAliasCT)->DT6_SERIE)
					cViagem := DTQ->DTQ_VIAGEM

					DTR->( dbSetOrder(1) )
					if DTR->( dbSeek( xFilial("DTR") + DTQ->( DTQ_FILORI + DTQ_VIAGEM ), .T. ) )
						_cNomTransp := DTR->DTR_NOMCRE
					endif
				EndIf
				RestArea(aAreaDTQ)


				If ValType(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC) == "O" //Se a Tag do Veículo for um Objeto o mesmo possui apenas um veículo
					cTpVei :=  xTabela('MU',oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_TPROD:TEXT)
					cPlaca :=  oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_PLACA:TEXT
					cUF    :=  oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_UF:TEXT
					cRNTRC :=  IIf((oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_TPPROP:TEXT) == "P",cTmsAntt,;
						(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_PROP:_RNTRC:TEXT))
				
					oDacte:Say(nLInic + nSoma , 0003, SubStr(AllTrim(cTpVei),1,11), oFont08)
					oDacte:Say(nLInic + nSoma , 0063, cPlaca, oFont08)
					oDacte:Say(nLInic + nSoma , 0105, cUf, oFont08)
					oDacte:Say(nLInic + nSoma , 0125, cRNTRC, oFont08)
					
					nSoma += 10
					oDacte:Say(nLInic + nSoma , 0125, _cNomTransp, oFont08)
					
					
					
				Else //Caso não seja um objeto significa que possui mais de um veículo
					nY := 1
					While nY <= 3
						If Type("oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC["+Str(nY,1)+"]:_TPROD:TEXT") != "U"
							cTpVei :=  xTabela('MU',oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC[nY]:_TPROD:TEXT)
							cPlaca :=  oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC[nY]:_PLACA:TEXT
							cUF    :=  oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC[nY]:_UF:TEXT
							cRNTRC :=  IIf((oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC[nY]:_TPPROP:TEXT) == "P",cTmsAntt,;
								(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC[nY]:_PROP:_RNTRC:TEXT))
						Else
							Exit
						EndIf
						If nY == 1	//Caso o veículo a ser impresso não seja o primeiro pula uma linha no box
							nSoma := 0
						Else
							nSoma += 10
						EndIf
						oDacte:Say(nLInic + nSoma , 0003, SubStr(AllTrim(cTpVei),1,11), oFont08)
						oDacte:Say(nLInic + nSoma , 0063, cPlaca, oFont08)
						oDacte:Say(nLInic + nSoma , 0105, cUf, oFont08)
						oDacte:Say(nLInic + nSoma , 0125, cRNTRC, oFont08)
						nY += 1
					EndDo

					nSoma += 10
					oDacte:Say(nLInic + nSoma , 0125, _cNomTransp, oFont08)

				EndIf
				If	Type("oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_MOTO") != "U"
					If ValType(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_MOTO)  == "O"
						cNomeMoto:= oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_MOTO:_XNOME:TEXT
						cCpfMoto := oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_MOTO:_CPF:TEXT
					Else
						cNomeMoto:= oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_MOTO[1]:_XNOME:TEXT
						cCpfMoto := oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_MOTO[1]:_CPF:TEXT
					EndIf
				EndIf
				If	Type("oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LACRODO") != "U"
					If ValType(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LACRODO) == "O"
						cLacre += oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LACRODO:_NLACRE:TEXT
					Else
						nY := 1
						While nY <= 5
							If Type("oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LACRODO["+Str(nY,1)+"]:_NLACRE:TEXT") != "U"
								If !Empty(cLacre)
									cLacre += ' / '
								EndIf
								cLacre += oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LACRODO[nY]:_NLACRE:TEXT
							Else
								Exit
							EndIf
							nY ++
						EndDo
					EndIf
				EndIf
			ElseIf (Type("oNFE:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO")) <> "U" .And. (oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LOTA:TEXT) == '1'
				If Type("oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC") == "O" //Se a Tag do Veículo for um Objeto o mesmo possui apenas um veículo
					cTpVei := Tabela('MU',oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_TPROD:TEXT,.F.)
					cPlaca :=  oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_PLACA:TEXT
					cUF    :=  oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_UF:TEXT
					cRNTRC :=  IIf((oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_TPPROP:TEXT) == "P",cTmsAntt,;
						(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_RNTRC:TEXT))

					oDacte:Say(nLInic + nSoma , 0003, SubStr(AllTrim(cTpVei),1,11), oFont08)
					oDacte:Say(nLInic + nSoma , 0063, cPlaca, oFont08)
					oDacte:Say(nLInic + nSoma , 0105, cUf, oFont08)
					oDacte:Say(nLInic + nSoma , 0125, cRNTRC, oFont08)
				Else //Caso não seja um objeto significa que possui mais de um veículo
					nY := 1
					While nY <= 3
						If Type("oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC["+Str(nY,1)+"]:_TPROD:TEXT") != "U"
							cTpVei := Tabela('MU',oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC[nY]:_TPROD:TEXT,.F.)
							cPlaca :=  oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC[nY]:_PLACA:TEXT
							cUF    :=  oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC[nY]:_UF:TEXT
							cRNTRC :=  IIf((oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC[nY]:_TPPROP:TEXT) == "P",cTmsAntt,;
								(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC[nY]:_PROP:_RNTRC:TEXT))
						Else
							Exit
						EndIf
						If nY == 1	//Caso o veículo a ser impresso não seja o primeiro pula uma linha no box
							nSoma := 0
						Else
							nSoma += 10
						EndIf

						oDacte:Say(nLInic + nSoma , 0003, SubStr(AllTrim(cTpVei),1,11), oFont08)
						oDacte:Say(nLInic + nSoma , 0063, cPlaca, oFont08)
						oDacte:Say(nLInic + nSoma , 0105, cUf, oFont08)
						oDacte:Say(nLInic + nSoma , 0125, cRNTRC, oFont08)
						nY += 1
					EndDo
				EndIf
				If	Type("oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_MOTO") != "U"
					If ValType(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_MOTO)  == "O"
						cNomeMoto:= oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_MOTO:_XNOME:TEXT
						cCpfMoto := oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_MOTO:_CPF:TEXT
					Else
						cNomeMoto:= oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_MOTO[1]:_XNOME:TEXT
						cCpfMoto := oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_MOTO[1]:_CPF:TEXT
					EndIf
				EndIf
			
				If	Type("oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LACRODO") != "U"
					If ValType(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LACRODO) == "O"
						cLacre += oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LACRODO:_NLACRE:TEXT
					Else
						nY := 1
						While nY <= 5
							If Type("oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LACRODO["+Str(nY,1)+"]:_NLACRE:TEXT") != "U"
								If !Empty(cLacre)
									cLacre += ' / '
								EndIf
								cLacre += oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LACRODO[nY]:_NLACRE:TEXT
							Else
								Exit
							EndIf
							nY ++
						EndDo
					EndIf
				EndIf
			EndIf    
			
			aAreaDTQ := DTQ->(GetArea())
			DbSelectArea("DTQ")
			DbOrderNickName("XCTR")
			If DbSeek(xFilial("DTQ")+(cAliasCT)->DT6_DOC+(cAliasCT)->DT6_SERIE)
				cViagem := DTQ->DTQ_VIAGEM
			EndIf                      
			RestArea(aAreaDTQ)                

			cAliasDTR := DataSource( 'VEICULOS_DA_LOTACAO' )
			     
			If (Type("oNFE:_CTE:_INFCTE:_INFCTECOMP")) <> "U"                                        
				While (cAliasDTR)->(!Eof())
				                                              
					If Empty(cTCiot)
						cTCiot	:= (cAliasDTR)->DTR_TCIOT         
					EndIf
					cCodVei := (cAliasDTR)->DTR_CODVEI
				
				
					cAliasDA3 := DataSource( 'DA3' )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ TAG: Prop -- Se o veiculo for de terceiros, preencher tags com  ³
				//³ informacoes do proprietário                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (cAliasDA3)->DUT_TIPROD == "00"
						cTpVei := "Não Aplicável"
					ElseIf (cAliasDA3)->DUT_TIPROD == "01"
						cTpVei := "Truck"
					ElseIf (cAliasDA3)->DUT_TIPROD == '02'
						cTpVei := "Toco"
					ElseIf (cAliasDA3)->DUT_TIPROD == '03'
						cTpVei := "Cavalo Mecânico"
					ElseIf (cAliasDA3)->DUT_TIPROD == '04'
						cTpVei := "VAN"
					ElseIf (cAliasDA3)->DUT_TIPROD == '05'
						cTpVei := "Utilitário"
					Else
						cTpVei := "Outros"
					EndIf
				
					cPlaca :=  (cAliasDA3)->DA3_PLACA
					cUF	 :=  (cAliasDA3)->DA3_ESTPLA
					cRNTRC := IIf((cAliasDA3)->DA3_FROVEI <> '1',(cAliasDA3)->A2_RNTRC,cTmsAntt)
				
					If nX == 1	//Caso o veículo a ser impresso não seja o primeiro pula uma linha no box
						nSoma := 0
					Else
						nSoma += 10
					EndIf
				
					oDacte:Say(nLInic + nSoma , 0003, cTpVei, oFont08)
					oDacte:Say(nLInic + nSoma , 0063, cPlaca, oFont08)
					oDacte:Say(nLInic + nSoma , 0105, cUf, oFont08)
					oDacte:Say(nLInic + nSoma , 0125, cRNTRC, oFont08)
					
					nX++
					(cAliasDTR)->(dbSkip())
				EndDo
				cCodMoto := Posicione("DUP",1,xFilial('DUP')+(cAliasCT)->DT6_FILORI+cViagem,'DUP_CODMOT')
				cNomeMoto:= Posicione("DA4",1,xFilial('DA4')+cCodMoto,'DA4_NOME')			
				cCPFMoto := DA4->DA4_CGC
				
				aAreaDTQ := DTQ->(GetArea())
				DbSelectArea("DTQ")
				DbOrderNickName("XCTR")
				If DbSeek(xFilial("DTQ")+(cAliasCT)->DT6_DOC+(cAliasCT)->DT6_SERIE)
					cViagem := DTQ->DTQ_VIAGEM

					DTR->( dbSetOrder(1) )
					if DTR->( dbSeek( xFilial("DTR") + DTQ->( DTQ_FILORI + DTQ_VIAGEM ), .T. ) )
						nSoma += 10
						oDacte:Say(nLInic + nSoma , 0125, DTR->DTR_NOMCRE, oFont08)

					endif
				EndIf
				RestArea(aAreaDTQ)
				
				(cAliasDA3)->(dbCloseArea())
			Else
				cCodVei:= ''
				While (cAliasDTR)->(!Eof())
					cTCiot	:= (cAliasDTR)->DTR_TCIOT         
					cCodVei 	:= (cAliasDTR)->DTR_CODVEI
					Exit
				EndDo
			EndIf                           

			nX := 1			                               
			
			cAliasDA3 := DataSource( 'DA3' )    
			
			(cAliasDTR)->(dbCloseArea())         
				
			oDacte:Say(0669, 0103, cTCiot,	oFont08) 		
			
			If (cAliasDA3)->DA3_FROVEI <> '1'
				If !Empty((cAliasDA3)->A2_BANCO)
					cBanco 	:= (cAliasDA3)->A2_NOMEBCO // Posicione('SA6',1,xFilial('SA6')+ (cAliasDA3)->A2_BANCO,'A6_NOME')
					cAgenc	:= (cAliasDA3)->A2_AGENCIA
					cConta	:= Alltrim((cAliasDA3)->A2_NUMCON)
					//Substr(RTrim((cAliasDA3)->A2_NUMCON),1,Len(Rtrim((cAliasDA3)->A2_NUMCON))-1) + '-' + Substr(RTrim((cAliasDA3)->A2_NUMCON),Len(RTrim((cAliasDA3)->A2_NUMCON))-1,1)  						
				
//					cSA2Obs := "Motorista: " + Rtrim(cBanco) + " - Agencia: " + Alltrim(cAgenc) +  " - C/C: " + Alltrim(cConta)			
				EndIf
			EndIf
			
			(cAliasDA3)->(dbCloseArea())    
			
		ElseIf lLotacao
			If SA2->(FieldPos('A2_RNTRC')) > 0
			//-- Veiculos da lotacao
				cAliasDTR := DataSource( 'VEICULOS_DA_LOTACAO' )
			
				While (cAliasDTR)->(!Eof())
					cCodVei:= ''
					cTCiot	:= (cAliasDTR)->DTR_TCIOT 
					For nX := 1 To 3
						If nX == 1
							cCodVei := (cAliasDTR)->DTR_CODVEI
						ElseIf nX == 2
							If !Empty((cAliasDTR)->DTR_CODRB1)
								cCodVei := (cAliasDTR)->DTR_CODRB1
							Else
								Exit
							EndIf
						ElseIf !Empty((cAliasDTR)->DTR_CODRB2)
							cCodVei := (cAliasDTR)->DTR_CODRB2
						Else
							Exit
						EndIf
					
						cAliasDA3 := DataSource( 'DA3' )
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ TAG: Prop -- Se o veiculo for de terceiros, preencher tags com  ³
					//³ informacoes do proprietário                                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (cAliasDA3)->DUT_TIPROD == "00"
							cTpVei := "Não Aplicável"
						ElseIf (cAliasDA3)->DUT_TIPROD == "01"
							cTpVei := "Truck"
						ElseIf (cAliasDA3)->DUT_TIPROD == '02'
							cTpVei := "Toco"
						ElseIf (cAliasDA3)->DUT_TIPROD == '03'
							cTpVei := "Cavalo Mecânico"
						ElseIf (cAliasDA3)->DUT_TIPROD == '04'
							cTpVei := "VAN"
						ElseIf (cAliasDA3)->DUT_TIPROD == '05'
							cTpVei := "Utilitário"
						Else
							cTpVei := "Outros"
						EndIf
					
						cPlaca :=  (cAliasDA3)->DA3_PLACA
						cUF	 :=  (cAliasDA3)->DA3_ESTPLA
						cRNTRC := IIf((cAliasDA3)->DA3_FROVEI <> '1',(cAliasDA3)->A2_RNTRC,cTmsAntt)
					
						If nX == 1	//Caso o veículo a ser impresso não seja o primeiro pula uma linha no box
							nSoma := 0
						Else
							nSoma += 10
						EndIf
					
						oDacte:Say(nLInic + nSoma , 0003, cTpVei, oFont08)
						oDacte:Say(nLInic + nSoma , 0063, cPlaca, oFont08)
						oDacte:Say(nLInic + nSoma , 0105, cUf, oFont08)
						oDacte:Say(nLInic + nSoma , 0125, cRNTRC, oFont08)
					Next nX
					(cAliasDTR)->(dbSkip())
				EndDo
				(cAliasDTR)->(dbCloseArea())         
				
				oDacte:Say(0669, 0103, cTCiot,	oFont08) 
			                         
				If (cAliasDA3)->DA3_FROVEI <> '1'
					If !Empty((cAliasDA3)->A2_BANCO)
						cBanco 	:= (cAliasDA3)->A2_NOMEBCO // Posicione('SA6',1,xFilial('SA6')+ (cAliasDA3)->A2_BANCO,'A6_NOME')
						cAgenc	:= (cAliasDA3)->A2_AGENCIA
						cConta	:= Alltrim((cAliasDA3)->A2_NUMCON)
						//Substr(RTrim((cAliasDA3)->A2_NUMCON),1,Len(Rtrim((cAliasDA3)->A2_NUMCON))-1) + '-' + Substr(RTrim((cAliasDA3)->A2_NUMCON),Len(RTrim((cAliasDA3)->A2_NUMCON))-1,1)  						
					
//						cSA2Obs := "Motorista: " + Rtrim(cBanco) + " - Agencia: " + Alltrim(cAgenc) +  " - C/C: " + Alltrim(cConta)			
					EndIf
				EndIf
			
				cCodMoto := Posicione("DUP",1,xFilial('DUP')+(cAliasCT)->DT6_FILORI+cViagem,'DUP_CODMOT')
				cNomeMoto:= Posicione("DA4",1,xFilial('DA4')+cCodMoto,'DA4_NOME')
				cCPFMoto := DA4->DA4_CGC
			EndIf
		//-- Lacres dos veiculos da lotacao
			cAliasDVB := DataSource( 'DVB' )
		
			While (cAliasDVB)->(!Eof())
				If Empty(cLacre)
					cLacre := (cAliasDVB)->DVB_LACRE
				Else
					cLacre += ' / ' +  (cAliasDVB)->DVB_LACRE
				EndIf
				(cAliasDVB)->(dbSkip())
			Enddo
			(cAliasDVB)->(dbCloseArea())

		EndIf                                                                       

		ZA6->( dbSetOrder(2) )
		if ZA6->( dbSeek( (cAliasCT)->DT6_FILORI + cNRAS ) ) .and. !Empty(ZA6->ZA6_OBSVIA)	// solicitacao Anderson - Cristiam em 18/08/2015
			cSA2Obs += "Rota Cliente: "+Alltrim( ZA6->ZA6_OBSVIA )
		endif
        
		If (cAliasCT)->DT6_CLIREM+(cAliasCT)->DT6_LOJREM + (cAliasCT)->DT6_CLIDEV+(cAliasCT)->DT6_LOJDEV $ GETMV("MV_XCLIDIF")
  			cDT6Obs3	:= AllTrim(GetNewPar("MV_XDESDIF","ICMS DIFERIDO CONFORME LEI RJ/6108/11"))
		EndIf

		cSA2Obs2:= SubStr(cSA2Obs,161,160)
		cSA2Obs := SubStr(cSA2Obs,1,160)
	
		If !Empty(cSA2Obs)
			oDacte:Say (nObsLin, 0003, cSA2Obs,  oFont08)
			nObsLin += 10
		EndIf
		
		If !Empty(cSA2Obs2)
			oDacte:Say (nObsLin, 0003, cSA2Obs2, oFont08)
			nObsLin += 10
		EndIf
		
		If !Empty(cDT6Obs3)
			oDacte:Say (nObsLin, 0003, cDT6Obs3, oFont08)
			nObsLin += 10
		EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX:  MOTORISTA                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oDacte:Box(0736 , 0000, 0762, 0559)
		oDacte:Line(0736, 0243, 0762, 0243) // Linha: Nome do Motorista|CPF do Motorista
		oDacte:Line(0736, 0327, 0762, 0327) // Linha: CPF do Motorista|Identificação dos lacres em Trânsito
		oDacte:Line(0743, 0000, 0743, 0559) // Linha Horizontal
		oDacte:Say(0742 , 0003, "Nome do Motorista", oFont08N)
		oDacte:Say(0742 , 0246, "CPF do Motorista",  oFont08N)
		oDacte:Say(0742 , 0330, "Identificação dos lacres em Trânsitos", oFont08N)
		oDacte:Say(0750,0003, cNomeMoto, oFont08)
		oDacte:Say(0750,0246, cCPFMoto,  oFont08)
		oDacte:Say(0735,0330, cLacre,    oFont08)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: USO EXCLUSIVO DO EMISSOR + RESERVADO AO FISCO                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oDacte:Box(0764 , 0000, 0820, 0559)
		oDacte:Say(0770 , 0090, "USO EXCLUSIVO DO EMISSOR DO CT-E", oFont08N)
		
		// LEI DA TRANSPARENCIA - ESPECIFICO TWA -> 12/12/2014 (Alison)
		cObsCont := 'O valor aproximado dos tributos incidentes sobre o preco deste servico e de R$ '
//		oDacte:Say(0780 , 0003, cObsCont, oFont08)
//		oDacte:Say(0790 , 0003, "Icms = R$ " + Alltrim(PADL(Transform((cAliasCT)->DT6_VALIMP,'@E 999,999,999.99'),20)), oFont08)
	
		//-- Pis e Cofins 
		nValPis		:= 0
		nValCof		:= 0
		cAliasSFT := "SFT_TMP"
		
		If (Select(cAliasSFT) > 0)
			(cAliasSFT)->(DbCloseArea())
		EndIf
		
		cQuery := " SELECT SUM(FT_VALPIS) FT_VALPIS, SUM(FT_VALCOF) FT_VALCOF	" + CRLF
		cQuery += "   FROM " + RetSqlName('SFT') + " SFT " +CRLF
		cQuery += "  WHERE SFT.FT_FILIAL	= '" + (cAliasCT)->DT6_FILDOC + "'" +CRLF
		cQuery += " 	AND SFT.FT_NFISCAL  = '" + (cAliasCT)->DT6_DOC + "'" + CRLF
		cQuery += " 	AND SFT.FT_SERIE    = '" + (cAliasCT)->DT6_SERIE + "'" + CRLF
		cQuery += " 	AND SFT.D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSFT, .F., .T.)
		
		While !(cAliasSFT)->(Eof())
			nValPis += (cAliasSFT)->FT_VALPIS
			nValCof += (cAliasSFT)->FT_VALCOF							
			(cAliasSFT)->(DbSkip())
		EndDo
		
		(cAliasSFT)->(DbCloseArea())
/*	
		If nValPis > 0
			oDacte:Say(0800 , 0003, "Pis = R$ " + Alltrim(PADL(Transform(nValPis,'@E 999,999,999.99'),20)), oFont08)
	 	EndIf
	 			
	 	If nValCof > 0
	 		oDacte:Say(0810 , 0003, "Cofins = R$ " + Alltrim(PADL(Transform(nValCof,'@E 999,999,999.99'),20)), oFont08)
	 	EndIf	
*/

//		cObsCont := 'O valor aproximado de tributos incidentes sobre o preco deste servico e de: '
		cObsCont += "R$ " + Alltrim( Transform( nValPis + nValCof + (cAliasCT)->DT6_VALIMP, '@E 999,999,999.99') )
		oDacte:Say(0780 , 0003, cObsCont, oFont08)

		aAreaDTQ := DTQ->(GetArea())
		DbSelectArea("DTQ")
		DbOrderNickName("XCTR")
		If DbSeek(xFilial("DTQ")+(cAliasCT)->DT6_DOC+(cAliasCT)->DT6_SERIE)
			ZA6->( dbSetOrder(5) )
			if ZA6->( dbSeek( DTQ->DTQ_AS, .T.  ) )
				cNovaLin := "C.Custo: "  +     Alltrim(ZA6->ZA6_CCGEFC) + " /"
				cNovaLin += " Tabela: "  +     Alltrim(ZA6->ZA6_TABVEN) + "-" + Alltrim(ZA6->ZA6_VERVEN) + " /"
				cNovaLin += " Ord.Int.: "+     Alltrim(ZA6->ZA6_OI) + " /"
				cNovaLin += " C.Custo PSA: "+  Alltrim(ZA6->ZA6_CCCLIE) + " /"
				cNovaLin += " Cta. Despesa: "+ Alltrim(ZA6->ZA6_CONTA)

				ZA7->( dbSetOrder(3) )
				if ZA7->( dbSeek( DTQ->DTQ_VIAGEM, .T.  ) )
					cNovaLin := "C.Custo: "  +     Alltrim(ZA7->ZA7_CCGEFC) + " /"
					cNovaLin += " Tabela: "  +     Alltrim(ZA6->ZA6_TABVEN) + "-" + Alltrim(ZA6->ZA6_VERVEN) + " /"
					cNovaLin += " Ord.Int.: "+     Alltrim(ZA7->ZA7_OI) + " /"
					cNovaLin += " C.Custo PSA: "+  Alltrim(ZA7->ZA7_CCCLIE) + " /"
					cNovaLin += " Cta. Despesa: "+ Alltrim(ZA7->ZA7_CONTA)
				endif

				oDacte:Say(0790 , 0003, cNovaLin, oFont08)
			endif
			
			if ! Empty(DTQ->DTQ_TPCTRC)
				cViagemOri :=  DTQ->DTQ_CTRORI
				DTQ->( dbSetOrder(1) )
				if DTQ->( dbSeek( xFilial("DTQ") + cViagemOri ) )
					cNovaLin := "Complementar ao CT-e numero " + Alltrim(DTQ->DTQ_NUMCTR) + "/" + Alltrim(DTQ->DTQ_SERCTR) + ", viagem " + cViagemOri
					oDacte:Say(0800 , 0003, cNovaLin, oFont08)
				endif
			endif
		EndIf                      
		RestArea(aAreaDTQ)                

		//oDacte:Say(0780 , 0003, cObsCont, oFont08)
		oDacte:Say(0770 , 0420, "RESERVADO AO FISCO", oFont08N)
		oDacte:Line(0773, 0000, 0773, 0559)	//Linha Horizontal
		oDacte:Line(0764, 0355, 0820, 0355)	//Linha Vertical

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizar o Status de Impressao no CTe                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DT6->(dbSetOrder(1))
		If	DT6->(MsSeek(xFilial('DT6')+(cAliasCT)->DT6_FILDOC+(cAliasCT)->DT6_DOC+(cAliasCT)->DT6_SERIE))
			RecLock('DT6',.F.)
			DT6->DT6_FIMP := StrZero(1, Len(DT6->DT6_FIMP)) //Grava Flag de Impressao
			MsUnLock()
		EndIf
		oDacte:EndPage()
	
	//-- aDoc > 0, existe mais de uma pagina com Doc a ser impressa.
	//-- lPerig .T. existem produtos perigosos a serem impressos.
		If Len(aDoc) > 0 .Or. lPerig
		//-- Caso de mais de uma pagina, chama a funcao para montar as paginas seguites.
			TMSR27Cont(aDoc, aCab[nCont])
		EndIf
		(cAliasCT)->(DbSkip())
	EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TERMINO ROTINA DE IMPRESSAO                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oDacte:Preview()

	(cAliasCT)->(dbCloseArea())

Return(.T.)


	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³Char2PixV ³ Autor ³Igor Franzoi           ³ Data ³24/10/2013³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Rotina copiada do fonte DANFEII.                            ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Nenhum                                                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Nenhum                                                      ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³               ³                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function Char2PixV(oDacte,cChar,oFont)
	Local nX := 0

	Default aUltVChar2pix := {}

	cChar := SubStr(cChar,1,1)
	nX := aScan(aUltVChar2pix,{|x| x[1] == cChar .And. x[2] == oFont})
	If nX == 0
		aadd(aUltVChar2pix,{cChar,oFont,oDacte:GetTextWidht(cChar,oFont)*(300/PixelY)})
		nX := Len(aUltVChar2pix)
	EndIf

Return(aUltVChar2pix[nX][3])

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  |TMSR27Cont³ Autor ³Igor Franzoi           ³ Data ³24/10/2013³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ³±±
	±±³Descri‡…o ³Caso de mais de uma pagina, chama a funcao para montar      ³±±
	±±³          ³as paginas seguites.                                        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   |                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Nenhum                                                      ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³               ³                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function TMSR27Cont(aDoc, aCab, aPerigo, nCnt)
	Local oFont08     := TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
	Local oFont08N    := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
	Local lControl    := .F.
	Local nCount      := 0
	Local aDoc1       := {}
	Local cChaveA     := ''
	Local cChaveB     := ''

//Variaveis Produtos Perigosos
	Local nCompr		:= 50	//Comprimento Padrao da Primeira Linha
	Local nSegLinha		:= 1	//Trecho a ser Impresso para cada linha
	Local lVerif		:= .F.	//Evita Repeticao de Impressao
	Local lFimPerig		:= .F.

	Default nCnt		:= 1
	Default aPerigo		:= {}
	Default aDoc		:= {}

	oDacte:StartPage()
	oDacte:SetPaperSize(Val(GetProfString(GetPrinterSession(),"PAPERSIZE","1",.T.)))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao responsavel pela montagem do cabecalho do DACTE                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TMSR27Cab(aCab,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: DOCUMENTOS ORIGINARIOS                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oDacte:Box(0224, 0000, 0593, 0559)
	oDacte:Say(0230, 0210, "DOCUMENTOS ORIGINARIOS", oFont08N)

	oDacte:Line(0232, 0000, 0232, 0559) 	// Linha: DOCUMENTOS ORIGINARIOS
	oDacte:Line(0232, 0280, 0593, 0280) // Linha: Separador DOCUMENTOS ORIGINARIOS
	oDacte:Say( 0238, 0003, "Tp.Doc"            , oFont08N)
	oDacte:Say( 0238, 0033, "CNPJ/CPF Emitente" , oFont08N)
	oDacte:Say( 0238, 0163, "Série/Nr.Documento", oFont08N)
	oDacte:Say( 0238, 0286, "Tp.Doc"            , oFont08N)
	oDacte:Say( 0238, 0316, "CNPJ/CPF Emitente" , oFont08N)
	oDacte:Say( 0238, 0448, "Série/Nr.Documento", oFont08N)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime as NF                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lControl := .F.
	nLInic := 0244
	For nCount := 1 To Len(aDoc)
		lControl := !lControl
	
		If nCount < 75
			If (lControl == .T.)
				oDacte:Say(nLInic, 0003, aDoc[nCount,4],										oFont08)
				oDacte:Say(nLInic, 0033, Transform(aDoc[nCount,1],"@r 99.999.999/9999-99"),	oFont08)
				oDacte:Say(nLInic, 0163, aDoc[nCount,2],										oFont08)
				cChaveA:= aDoc[nCount,3]
			Else
				oDacte:Say(nLInic, 0286, aDoc[nCount,4],									    oFont08)
				oDacte:Say(nLInic, 0316, Transform(aDoc[nCount,1],"@r 99.999.999/9999-99"),	oFont08)
				oDacte:Say(nLInic, 0448, aDoc[nCount,2],										oFont08)
				cChaveB :=aDoc[nCount,3]
			EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³FORCAR A "QUEBRA" DA LINHA                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lControl //( (mod(nCount,2)) == 0 )
				If !Empty(cChaveA) .or. !Empty(cChaveB)
					nLInic   += 0008
				EndIf

				If !Empty(cChaveA)
					oDacte:Say(nLInic, 0003, "NF-E CHAVE:"	,oFont08)
					oDacte:Say(nLInic, 0047,cChaveA			,oFont08)
					cChaveA := ''
				EndIf

				If !Empty(cChaveB)
					oDacte:Say(nLInic, 0286, "NF-E CHAVE:"	,oFont08)
					oDacte:Say(nLInic, 0340, cChaveB		,oFont08)
					cChaveB := ''
				EndIf
				nLInic += 0008
			EndIf
		Else
			aAdd(aDoc1,{aDoc[nCount,1],;
				aDoc[nCount,2],;
				aDoc[nCount,3],;
				aDoc[nCount,4]})
		EndIf
	Next nCount

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime a ultima Chave.                                                 ³
//³FORCAR A "QUEBRA" DA LINHA                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cChaveA)
		nLInic += 0008
		oDacte:Say(nLInic, 0003, "NF-E CHAVE:",	oFont08)
		oDacte:Say(nLInic, 0047,cChaveA ,		oFont08)
		cChaveA := ''

		oDacte:Say(nLInic, 1175, "NF-E CHAVE:",	oFont08)
		oDacte:Say(nLInic, 0340, cChaveB,		oFont08)
		cChaveB := ''
	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: Produtos Perigosos                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAliasPeri := DataSource("PRODUTOS_PERIGOSOS")
	nSoma   := 1380

	If (cAliasPeri)->(!Eof())
		nDifEsq:= 110
		nLInic := 2214
		oDacte:Box(0645 , 0000, 0820, 0559)
		oDacte:Say(0651 , 0200, "Informações sobre Produtos Perigosos", oFont08N)
		nSoma  := 12
		oDacte:Line(0653, 0000, 0653, 0559)		// Linha Horizontal
		oDacte:Line(0653, 0032, 0820, 0032 )	// Linha Divisoria Nro. Onu X Nome Apropriado
		oDacte:Line(0653, 0262, 0820, 0262 )	// Linha Divisoria Nome Apropriado X Classe/Subclasse e Risco Subsidiário
		oDacte:Line(0653, 0430, 0820, 0430 )	// Linha Divisoria Classe Subclasse e Risco Subsidiário X Grupo de Embalagem
		oDacte:Line(0653, 0501, 0820, 0501 )	// Linha Divisoria Grupo de Embalagem X Qto. Tot. Produto
	
		oDacte:Say(0659 , 0002, "Nro. Onu"			, oFont08N)
		oDacte:Say(0659 , 0035, "Nome Apropriado" 	, oFont08N)
		oDacte:Say(0659 , 0265, "Classe/Subclasse e Risco Subsidiário", oFont08N)
		oDacte:Say(0659 , 0433, "Grupo de Embalagem", oFont08N)
		oDacte:Say(0659 , 0504, "Qto. Tot. Produto" , oFont08N)
		nLInic :=  0665
		If Len(aPerigo) <= 0
			Do While (cAliasPeri)->(!EoF())
				AAdd(aPerigo,{	(cAliasPeri)->DY3_ONU,;
					(cAliasPeri)->DY3_DESCRI,;
					(cAliasPeri)->DY3_CLASSE + ' ' + (cAliasPeri)->DY3_NRISCO, ;
					(cAliasPeri)->DY3_GRPEMB,;
					Str((cAliasPeri)->DTC_PESO)})
				(cAliasPeri)->(dbSkip())
			EndDo
		EndIf

		For nCnt := nCnt to Len(aPerigo)														//Verifica tamanho do array
			oDacte:Say(nLInic , 0002,     aPerigo[nCnt][1]   , oFont08)						//Nro. Onu
			For nSegLinha:= nSegLinha To Len(aPerigo[nCnt][2])									//
				oDacte:Say(nLInic , 0035,Substr(aPerigo[nCnt][2],nSegLinha,nCompr), oFont08)	//Nome Apropriado
				If !lVerif 																		//Nao repete valores a cada quebra de linha
					oDacte:Say(nLInic , 0265,aPerigo[nCnt][3]	, oFont08)						//Classe/Subclasse e Risco Subsidiário
					oDacte:Say(nLInic , 0433,aPerigo[nCnt][4] 	, oFont08)						//Grupo de Embalagem
					oDacte:Say(nLInic , 0504,aPerigo[nCnt][5]	, oFont08)						//Qto. Tot. Produto
					lVerif := .T.
				EndIf
				nSegLinha += nCompr -1
				If Len(aPerigo[nCnt][2]) > nSegLinha
					nLInic += 0008
				EndIf
				If nLInic >= 0770		//Verifica se chegou ao fim da pagina
					lFimPerig := .T.
					Exit
				EndIf
			Next
			If lFimPerig
				Exit
			EndIf
			nSegLinha := 1
			lVerif	:= .F. // Reinicia valor para o proximo elemento
		Next
		nCnt++
	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Linha de finalizacao.                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oDacte:EndPage()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se existir mais doc para outra pagina, chama a mesma funcao.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aDoc1) > 1
		TMSR27Cont(aDoc1)
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se existir mais prod perigoso para outra pagina, chama a mesma funcao. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLInic >= 0820
		TMSR27Cont(,aCab,aPerigo,nCnt)
	EndIf

Return


	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³ TMSR27Cab³ Autor ³Igor Franzoi           ³ Data ³24/10/2013³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Funcao responsavel por montar o cabecalho do relatorio      ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   |                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Nenhum                                                      ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³               ³                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function TMSR27Cab(aCab, lImpCan)
	Local oFont07    := TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)	//Fonte Times New Roman 07
	Local oFont07N   := TFont():New("Times New Roman",07,07,,.T.,,,,.T.,.F.)	//Fonte Times New Roman 08 Negrito
	Local oFont08    := TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)	//Fonte Times New Roman 08
	Local oFont08N   := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)	//Fonte Times New Roman 08 Negrito
	Local cAliasAll  := GetNextAlias()
	Local cTpServ	 	:= ''
	Local cStartPath := GetSrvProfString("Startpath","")
	Local cTmsAntt   := SuperGetMv( "MV_TMSANTT", .F., .F. )	//Numero do registro na ANTT com 14 dígitos
	Local cLogoTp    := cStartPath + "logoCte.bmp"				//Insira o caminho do Logo da empresa, na variavel cLogoTp.

	Default lImpCan  := .F.                          

	If	IsSrvUnix() .And. GetRemoteType() == 1
		cLogoTp := StrTran(cLogoTp,"/","\")
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: CANHOTO - 0746                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	lImpCan
		/*oDacte:Box(0036, 0000, 0082, 0559)
		oDacte:Line(0046, 0166, 0082, 0166) // Linha Vertical:
		oDacte:Line(0046, 0416, 0082, 0416) // Linha Vertical:
		oDacte:Line(0046, 0000, 0046, 0559) // Linha Horizontal: USO EXCLUSICO DO EMISSOR
		oDacte:Line(0072, 0000, 0072, 0166) // Linha Horizontal: Separador NOME e RG
		oDacte:Line(0062, 0416, 0062, 0559) // Linha Horizontal: Separador CHEGADA e SAIDA
		oDacte:Say(0042, 0003, "DECLARO QUE RECEBI OS VOLUMES DESTE CONHECIMENTO EM PERFEITO ESTADO E DOU POR CUMPRIDO O PRESENTE CONTRATO DE TRANSPORTE", oFont08N)
		oDacte:Say(0052, 0003, "Nome"               , oFont08N)
		oDacte:Say(0052, 0419, "Chegada Data / Hora", oFont08N)
		oDacte:Say(0078, 0003, "R.G"                , oFont08N)
		oDacte:Say(0068, 0419, "Saída Data / Hora"  , oFont08N)*/
		oDacte:Box(0020, 0000, 0082, 0559)

		// Tomador do Serviço
		cDevMun   := (cAliasCT)->DEV_MUNICI
		cDevUF    := (cAliasCT)->DEV_UF
		cDevNome  := (cAliasCT)->DEV_NOME
		cDevCNPJ  := (cAliasCT)->DEV_CNPJ
		xMsg := "TOMADOR: " + Transform( cDevCNPJ, "@R 99.999.999/9999-99") + " - " + Alltrim(cDevNome) + " - " + Alltrim(cDevMun) + " - " + cDevUF + " - " + Space(5) + Alltrim(SM0->M0_CIDCOB) + " - " + SM0->M0_ESTCOB
		oDacte:Say(0028 , 0001, xMsg, oFont08N)

		oDacte:Line(0029, 0000, 0029, 0559) // Linha horizontal
		oDacte:Say(0037 , 0001, "DECLARO QUE RECEBI OS VOLUMES DESTE CONHECIMENTO EM PERFEITO ESTADO E DOU POR CUMPRIDO O PRESENTE CONTRATO DE TRANSPORTE", oFont08N)
		oDacte:Line(0039, 0000, 0039, 0559) // Linha horizontal

		oDacte:Line(0062, 0000, 0062, 0136) // Linha Horizontal: Separador NOME e RG
		oDacte:Line(0062, 0386, 0062, 0483) // Linha Horizontal: Separador CHEGADA e SAIDA
		
		oDacte:Line(0039, 0136, 0082, 0136) // Linha vertical
		oDacte:Line(0039, 0386, 0082, 0386) // Linha vertical
		oDacte:Line(0039, 0483, 0082, 0483) // Linha vertical
		
		oDacte:Say(0047 , 0005, "Nome"               	, oFont08N)
		oDacte:Say(0047 , 0391, "Chegada Data / Hora"	, oFont08N)
		oDacte:Say(0047 , 0512, "CT-e"					, oFont08N)
		oDacte:Say(0063 , 0495, "Nro.: "+cValtoChar( aCab[1] ) , oFont08N)
		//oDacte:Say(0067 , 0518, cValtoChar( Val(aCab[1]))	, oFont07N)
		oDacte:Say(0079 , 0508, "Série: "+cValtoChar( Val(aCab[2]))	, oFont08N)
		oDacte:Say(0070 , 0005, "R.G"                	, oFont08N)
		oDacte:Say(0079 , 0221, "Assinatura / Carimbo"  , oFont08N)
		oDacte:Say(0070 , 0391, "Saída Data / Hora"  	, oFont08N)
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: Empresa + 0050                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oDacte:Box(0086, 0000, 0203, 0322)
	oDacte:SayBitmap(0088, 0005,cLogoTp,0310,0040 )		//Logo

	xFilMsg := "Filial: " + Alltrim(SM0->M0_FILIAL)			// Cristiam Rossi em 21/09/2015
	oDacte:SayAlign(0138, 0005, xFilMsg,oFont08, 0314, 8, 0, 1 /*0=esquerda, 1=direita, 2=centralizado*/) 	//Nome Filial

	oDacte:Say(0148, 0005, AllTrim(SM0->M0_NOMECOM),oFont08) 	//Nome Comercial
	oDacte:Say(0158, 0005, AllTrim(SM0->M0_ENDENT) ,oFont08)	//Endereco
	oDacte:Say(0168, 0005, AllTrim(SM0->M0_BAIRENT),oFont08)	//Bairro
	oDacte:Say(0178, 0005, AllTrim(SM0->M0_CIDENT) + '  -  ' + AllTrim(SM0->M0_ESTENT) + '  CEP.:  ' + AllTrim(SM0->M0_CEPENT) ,oFont08)	//Cidade, UF, CEP
	oDacte:Say(0188, 0005, 'CNPJ: ' + Transform(AllTrim(SM0->M0_CGC),"@r 99.999.999/9999-99"))
	oDacte:Say(0188, 0100, 'Inscrição Estadual: ' + AllTrim(SM0->M0_INSC)	,oFont08)	//CNPJ e IE
	oDacte:Say(0198, 0005, 'Telefone: '           + AllTrim(SM0->M0_TEL)	,oFont08)	//Telefone
	oDacte:Say(0198, 0100, 'RNTRC da Empresa: '   + AllTrim(cTmsAntt)		,oFont08)	//RNTRC da Empresa

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: DACTE                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oDacte:Box(0086, 0324, 0103, 0472)
	oDacte:Say(0092, 390, "DACTE", oFont08N)
	oDacte:Say(01000, 340, (Upper("Documento Auxiliar do CT-e")),oFont08)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: MODAL                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oDacte:Box(0086, 0474, 0103, 0559)
	oDacte:Say(0092, 504,"MODAL"     ,oFont08N)
	oDacte:Say(0100, 501,"Rodoviário",oFont08 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BOX: Modelo / Serie / Numero / Folha / Emis                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oDacte:Box(0105, 0324, 0122 , 0559)
	oDacte:Say(0111, 0344, "Modelo" , oFont08N)	//Modelo
	oDacte:Say(0118, 0349,"57",oFont08)

	oDacte:Say(0111, 0384, "Serie"  , oFont08N)	//Serie
	oDacte:Say(0118, 0389, cValtoChar( Val(aCab[2]) ), oFont08)

	oDacte:Say(0111, 0424, "Número" , oFont08N)	//Numero
	oDacte:Say(0118, 0420, cValtoChar( aCab[1] ), oFont08)

	oDacte:Say(0111, 0461, "Folha"  , oFont08N)	//Folha
	oDacte:Say(0118, 0464, AllTrim(Str(nFolhAtu)) + " / " + AllTrim(Str(nFolhas)), oFont08)
	nFolhAtu ++

	oDacte:Say(0111, 0512, "Emissão", oFont08N)//Emissao
	oDacte:Say(0118, 0492, 	SubStr(AllTrim(aCab[3]), 7, 2) + '/'   +;
		SubStr(AllTrim(aCab[3]), 5, 2) + "/"   +;
		SubStr(AllTrim(aCab[3]), 1, 4) + " - " +;
		SubStr(AllTrim(aCab[4]), 1, 2) + ":"   +;
		SubStr(AllTrim(aCab[4]), 3, 2) + ":00")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: Controle do Fisco                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oDacte:Box(0124, 0324, 0203, 0559)
	If	AllTrim((cAliasCT)->DT6_CHVCTG)<>''
		oDacte:Code128C(152.6,337,(cAliasCT)->DT6_CHVCTE, 29)
		oDacte:Code128C(202.4,337,(cAliasCT)->DT6_CHVCTG, 29)
	Else
		oDacte:Code128C(152.6,337,(cAliasCT)->DT6_CHVCTE, 29)
	EndIf
	oDacte:Line(0153, 0324, 0153, 0559 )	//Linha Separadora
	oDacte:Say( 0158, 0345,"Chave de acesso para consulta de autenticidade no site www.cte.fazenda.gov.br",oFont07)
	oDacte:Say( 0168, 0350, Transform(AllTrim(aCab[5]),"@r 99.9999.99.999.999/9999-99-99-999-999.999.999.999.999.999.9"), oFont08N)
	oDacte:Line(0172, 0324, 0172, 0559 )	//Linha Separadora

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  BOX: Tipo do CTe                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oDacte:Box(0205, 0000, 0222 , 0559)
	oDacte:Say(0211, 0003, "Tipo do CTe"                 , oFont08N)
	oDacte:Say(0211, 0073, "Tipo de Serviço"             , oFont08N)
	oDacte:Say(0211, 0160, "Tomador do Serviço"          , oFont08N)
	oDacte:Say(0211, 0243, "Forma de Pagamento"          , oFont08N)
	oDacte:Say(0211, 0324, "Número do Protocolo"         , oFont08N)
	oDacte:Say(0211, 0457, "Insc.Suframa do Destinatário", oFont08N)
	oDacte:Line(0205, 0071, 0222 , 0071) // Linha: Divide Tp.CTe e Tp.Servico
	oDacte:Line(0205, 0158, 0222 , 0158) // Linha: Tp.Servico e Tomador
	oDacte:Line(0205, 0241, 0222 , 0241) // Linha: Tomador e Forma Pagto
	oDacte:Line(0205, 0322, 0222 , 0322) // Linha: Divide Forma Pagto e Protocolo
	oDacte:Line(0205, 0455, 0222 , 0455) // Linha: Divide Protocolo e Suframa Dest.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipo de Conhecimento                                            ³
//³ 0 - Normal                                                      ³
//³ 1 - Complemento de Valores                                      ³
//³ 2 - Emitido em Hipotese de anulacao de Debito                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( AllTrim((cAliasCT)->DT6_DOCTMS) == "8" )
		oDacte:Say(0218,  0003, "COMPLEMENTO"	, oFont08)
	ElseIf ( AllTrim((cAliasCT)->DT6_DOCTMS) == "M" )
		oDacte:Say(0218,  0003, "ANULACAO"		, oFont08)
	Else
		oDacte:Say(0218,  0003, "NORMAL"		, oFont08)
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipo de Servico                                                 ³
//³ 0 - Normal                                                      ³
//³ 1 - SubContratacao                                              ³
//³ 2 - Redespacho                                                  ³
//³ 3 - Redespacho Intermediario                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DTC - Notas Fiscais: (Informacao do campo DTC_TIPNFC)           ³
//³   0 - Normal                                                    ³
//³   1 - Devolucao                                                 ³
//³   2 - SubContratacao                                            ³
//³   3 - Dcto Nao Fiscal                                           ³
//³   4 - Exportacao                                                ³
//³   5 - Redespacho                                                ³
//³   6 - Dcto Nao Fiscal 1                                         ³
//³   7 - Dcto Nao Fiscal 2                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lXml
		cTpServ := oNfe:_CTE:_INFCTE:_IDE:_tpserv:TEXT
	Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona as informacoes do produto, baseado na DTC             ³
	//³ Pega o produto com maior valor de mercadoria, definido como     ³
	//³ o produto predominante                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAliasAll := "DTC_TMP"
		If (Select(cAliasAll) > 0)
			(cAliasAll)->(DbCloseArea())
		EndIf
		cQuery := " SELECT DTC.DTC_CODPRO,	" +CRLF
		cQuery += "		DTC.DTC_TIPNFC,		" +CRLF
		cQuery += "		DV3.DV3_INSCR		" +CRLF
		cQuery += "   FROM " + RetSqlName('DTC') + " DTC " +CRLF
		cQuery += " 		 LEFT JOIN " + RetSqlName('DV3') + " DV3 " +CRLF
		cQuery += "						ON (DV3.DV3_FILIAL = '" + xFilial("DV3") + "'"  +CRLF
		cQuery += "					  AND DV3.DV3_CODCLI = DTC.DTC_CLIREM " +CRLF
		cQuery += "					  AND DV3.DV3_LOJCLI = DTC.DTC_LOJREM " +CRLF
		cQuery += "					  AND DV3.DV3_SEQUEN = DTC.DTC_SQIREM " +CRLF
		cQuery += "					  AND DV3.D_E_L_E_T_ = ' ') " +CRLF
		cQuery += "  WHERE DTC.DTC_FILIAL	= '" + xFilial('DTC')			+ "'" +CRLF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se o tipo de Conhecimento for de Complemento, seleciona as      ³
	//³ informacoes do CTR principal, pois o complemento nao tem DTC    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty((cAliasCT)->DT6_DOCDCO)
			cQuery += " AND DTC.DTC_FILDOC   = '" + (cAliasCT)->DT6_FILDCO + "'" + CRLF
			cQuery += " AND DTC.DTC_DOC      = '" + (cAliasCT)->DT6_DOCDCO + "'" + CRLF
			cQuery += " AND DTC.DTC_SERIE    = '" + (cAliasCT)->DT6_SERDCO + "'" + CRLF
		Else
			cQuery += " AND DTC.DTC_FILDOC   = '" + (cAliasCT)->DT6_FILDOC + "'" + CRLF
			cQuery += " AND DTC.DTC_DOC      = '" + (cAliasCT)->DT6_DOC    + "'" + CRLF
			cQuery += " AND DTC.DTC_SERIE    = '" + (cAliasCT)->DT6_SERIE  + "'" + CRLF
		EndIf
		cQuery += " AND DTC.D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAll, .F., .T.)
	
		If ((cAliasAll)->(Eof()))
		//-- Nao localizou documentos... Procura documentos de apoio...
			(cAliasAll)->(DbCloseArea())
			cQuery := " SELECT DTC.DTC_TIPNFC,		" + CRLF
			cQuery += " 		 DTC.DTC_CODPRO,		" + CRLF
			cQuery += " 		 MAX(DTC.DTC_VALOR),	" + CRLF
			cQuery += " 		 DV3.DV3_INSCR			" + CRLF
	
			cQuery += "   FROM " + RetSqlName("DTC") + " DTC "

			cQuery += " 		 LEFT JOIN " + RetSqlName('DV3') + " DV3 " + CRLF
			cQuery += "					ON (DV3.DV3_FILIAL = '" + xFilial("DV3") + "'"  + CRLF
			cQuery += "					AND DV3.DV3_CODCLI = DTC.DTC_CLIREM " + CRLF
			cQuery += "					AND DV3.DV3_LOJCLI = DTC.DTC_LOJREM " + CRLF
			cQuery += "					AND DV3.DV3_SEQUEN = DTC.DTC_SQIREM " + CRLF
			cQuery += "					AND DV3.D_E_L_E_T_ = ' ') " + CRLF

			cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 " + CRLF
			cQuery += "   ON DT6.DT6_CLIDEV   = '" + (cAliasCT)->DT6_CLIDEV + "'" + CRLF
			cQuery += "  AND DT6.DT6_LOJDEV   = '" + (cAliasCT)->DT6_LOJDEV + "'" + CRLF
			cQuery += "  AND DT6.DT6_PREFIX   = '" + (cAliasCT)->DT6_PREFIX + "'" + CRLF
			cQuery += "  AND DT6.DT6_NUM      = '" + (cAliasCT)->DT6_NUM    + "'" + CRLF
			cQuery += "  AND DT6.DT6_TIPO     = '" + (cAliasCT)->DT6_TIPO   + "'" + CRLF
			cQuery += "  AND DT6.DT6_DOCTMS IN('B','C','H','I','N','O') "
			cQuery += "  AND DT6.D_E_L_E_T_   = ' '" + CRLF

			cQuery += " WHERE DTC.DTC_FILIAL = '" + xFilial('DTC') + "'" + CRLF
			cQuery += "  AND DTC.DTC_FILDOC   = DT6.DT6_FILDOC " + CRLF
			cQuery += "  AND DTC.DTC_DOC      = DT6.DT6_DOC    " + CRLF
			cQuery += "  AND DTC.DTC_SERIE    = DT6.DT6_SERIE  " + CRLF
			cQuery += "  AND DTC.D_E_L_E_T_   = ' '" + CRLF
			cQuery += " ORDER BY MAX(DTC.DTC_VALOR) DESC" + CRLF
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAll, .F., .T.)
			lDocApoio := !(cAliasAll)->(Eof())
		EndIf
		If (!(cAliasAll)->(Eof()))
			cTpServ := (cAliasAll)->DTC_TIPNFC
		//-- Caso tenha sequencia de IE do remetente.
			If !Empty((cAliasAll)->DV3_INSCR)
				cInsRemOpc := AllTrim( (cAliasAll)->DV3_INSCR )
			EndIf
		EndIf
		(cAliasAll)->(DbCloseArea())
	EndIf
	If (cTpServ == '0')
		oDacte:Say(0218, 0073, "NORMAL"				, oFont08)
	//ElseIf (cTpServ == '2')
	ElseIf (cTpServ == '1')
		oDacte:Say(0218, 0073, "SUBCONTRATAÇÃO"		, oFont08)
	ElseIf (cTpServ == '3')
		oDacte:Say(0218, 0073, "DOC. NÃO FISCAL"	, oFont08)
	ElseIf (cTpServ == '4')
		oDacte:Say(0218, 0073, "EXPORTAÇÃO"			, oFont08)
	ElseIf (cTpServ == '5')
		oDacte:Say(0218, 0073, "REDESPACHO"			, oFont08)
	ElseIf (cTpServ == '6')
		oDacte:Say(0218, 0073, "DOC. NÃO FISCAL"	, oFont08)
	ElseIf (cTpServ == '7')
		oDacte:Say(0218, 0073, "DOC. NÃO FISCAL"	, oFont08)
	Else
		oDacte:Say(0218, 0073, "NORMAL"				, oFont08)
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tomador do Servico                                              ³
//³ 0 - Remetente;                                                  ³
//³ 1 - Expedidor;                                                  ³
//³ 2 - Recebedor;                                                  ³
//³ 3 - Destinatario;                                               ³
//³ 4 - Outros. (Consignatario / Despachante)                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Forma de Pagamento do Servico                                   ³
//³ 0 - Pago                                                        ³
//³ 1 - A pagar                                                     ³
//³ 2 - Outros                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (cAliasCT)->DT6_DEVFRE == "1"
		oDacte:Say(0218,  0160, "REMETENTE"  	, oFont08)	//Tomador do Servico
		//oDacte:Say(0218,  0243, "PAGO"       	, oFont08)	//Forma de Pagamento do Servico
		oDacte:Say(0218,  0243, "A PAGAR"       , oFont08)
	ElseIf (cAliasCT)->DT6_DEVFRE == "2"
		oDacte:Say(0218,  0160, "DESTINATÁRIO"  , oFont08)
		oDacte:Say(0218,  0243, "A PAGAR"       , oFont08)
	ElseIf (cAliasCT)->DT6_DEVFRE == "3"
		oDacte:Say(0218,  0160, "OUTROS"  		, oFont08)
		//oDacte:Say(0218,  0243, "OUTROS"  		, oFont08)
		oDacte:Say(0218,  0243, "A PAGAR"       , oFont08)
	Else
		oDacte:Say(0218,  0193, "EXPEDIDOR"  	, oFont08)
		oDacte:Say(0218,  0243, "OUTROS"     	, oFont08)
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Numero Protocolo                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oDacte:Say(0218,  0324, aCab[6] + " " + aCab[8] + " " + aCab[9], oFont08)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Insc.Suframa do Destinatário                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oDacte:Say(0218,  0457, AllTrim((cAliasCT)->DES_SUFRAMA), oFont08)

Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³TMSR27Comp³ Autor ³Igor Franzoi           ³ Data ³24/10/2013³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Funcao responsavel por montar o BOX com as informacoes do   ³±±
	±±³          ³componentes do frete e impostos                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   |                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Nenhum                                                      ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³               ³                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function TMSR27Comp(lXml,aCab)
	Local cAliasDT8   	:= GetNextAlias()
	Local cAliasRBC		:= ''
	Local cLabel      	:= ''
	Local nCInic      	:= 0			// Coluna Inicial
	Local oFont08     	:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
	Local oFont08N    	:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
	Local oFont10N    	:= TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
	Local lControl    	:= .F.
	Local nCount      	:= 0
	Local nCount_2    	:= 0
	Local cSitTriba		:= "Sit Trib"
	Local cBaseIcms		:= ''			//-- Base de Calculo
	Local cAliqIcms		:= ''			//-- Aliquota ICMS
	Local cValIcms		:= ''			//-- Valor ICMS
	Local cRedBcCalc	:= ''			//-- "Red.Bc.Calc."
	Local cIcmsSt		:= ''			//-- ICMS ST
	Local nCount_3		:= 0
	Local lCTEVFRE		:= SuperGetMv("MV_CTEVFRE",.F.,.F.)
	Local aComp			:= {}

	If ValType(lXml) != 'L'
		lXml:= (MV_PAR08 == 1)
	EndIf
//-- Buscar XML do WebService

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: COMPONENTES DA PRESTACAO                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lComp
		nLInic	:= 0505
		nLFim	:= 0563
	Else
		nLInic	:= 0445
		nLFim	:= 0503
	EndIf

	oDacte:Box(nLInic, 0000, nLFim, 0559)

	nLInic	+= 0008
	oDacte:Say(nLInic, 0210, "Componentes do Valor da Prestação de Serviço", oFont08N)
	
	nLInic	+= 0004
	
	oDacte:Line(nLInic, 0000, nLInic, 0559) // Linha: Componentes da Prestacao
	oDacte:Line(nLInic, 0070, nLFim, 0070) // Linha: Separador Vertical
	oDacte:Line(nLInic, 0140, nLFim, 0140) // Linha: Separador Vertical
	oDacte:Line(nLInic, 0210, nLFim, 0210) // Linha: Separador Vertical
	oDacte:Line(nLInic, 0280, nLFim, 0280) // Linha: Separador Vertical
	oDacte:Line(nLInic, 0350, nLFim, 0350) // Linha: Separador Vertical
	oDacte:Line(nLInic, 0420, nLFim, 0420) // Linha: Separador Vertical
	
	nLInic	+= 0006
	oDacte:Say(nLInic, 0003, "Nome",	oFont08N)
	oDacte:Say(nLInic, 0073, "Valor",	oFont08N)
	oDacte:Say(nLInic, 0143, "Nome",	oFont08N)
	oDacte:Say(nLInic, 0213, "Valor",	oFont08N)
	oDacte:Say(nLInic, 0283, "Nome",	oFont08N)
	oDacte:Say(nLInic, 0353, "Valor",	oFont08N)
	oDacte:Say(nLInic, 0423, "Valor Total do Serviço", oFont08N)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Componentes do Valor da Prestacao de Servico                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³DT8 - Componentes do Frete                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLInic		+= 0008
	nCInic		:= 0003
	lControl	:= .F.

	If (lXml)
		aComp := TMSGetComp( oNfe ) //GetCompl()
		
		For nCount_3 := 1 To Len( aComp )
			nCount += 2
			oDacte:Say(nLInic, nCInic, AllTrim(aComp[nCount_3][1]), oFont08)	//Descricao do Componente
			nCInic += 0070	//Proxima Coluna

			oDacte:Say(nLInic, nCInic, Transform(Val(aComp[nCount_3][2]),'@E 999,999.99'), oFont08)	//Valor do Componente
			nCInic += 0070	//Proxima Coluna


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FORCAR A "QUEBRA" DA LINHA, SENDO 6 CAMPOS POR LINHA.                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( (mod(nCount,6)) == 0 )
				nCount_2 += 1
				Do Case
				Case ( nCount_2 == 1 )
					cLabel := PadL(Transform(Val(oNFE:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT),'@E 999,999.99'),20)
				Case ( nCount_2 == 2 )
					cLabel := ""
				Case ( nCount_2 == 3 )
					oDacte :Line(nLInic - 8, 0420, nLInic - 8, 0559) // Linha: VALOR A RECEBER
					cLabel := "Valor a Receber"
				Case ( nCount_2 == 4 )
					cLabel := PadL(Transform(Val(oNFE:_CTE:_INFCTE:_VPREST:_VREC:TEXT),'@E 999,999.99'),20)
				EndCase
				
				oDacte:Say(nLInic , 0423, cLabel, oFont10N)
				nLInic   += 0008
				nCInic   := 0003
			EndIf
		Next nCount_3
		For nCount := (1 + nCount) To 24
			lControl := !lControl
			nCInic   += 0070
			cLabel   := ""
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FORCAR A "QUEBRA" DA LINHA, SENDO 6 CAMPOS POR LINHA.                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( (mod(nCount,6)) == 0 )
				nCount_2 += 1
				Do Case
				Case ( nCount_2 == 1 )
					cLabel := PadL(Transform(Val(oNFE:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT),'@E 999,999.99'),20)
				Case ( nCount_2 == 2 )
					cLabel := ""
				Case ( nCount_2 == 3 )
					oDacte :Line(nLInic - 8, 0420, nLInic - 8, 0559) // Linha: VALOR A RECEBER
					cLabel := "Valor a Receber"
				Case ( nCount_2 == 4 )
					cLabel := PadL(Transform(Val(oNFE:_CTE:_INFCTE:_VPREST:_VREC:TEXT),'@E 999,999.99'),20)
				EndCase
			
				oDacte:Say(nLInic , 0423, cLabel, oFont10N)
				nLInic   += 0008
				nCInic   := 0003
			EndIf
		Next nCount
	Else
		cQuery := " SELECT DOCCOMP.DT8_VALTOT, " +CRLF
		cQuery += "        DOCCOMP.DT8_VALPAS, " +CRLF
		cQuery += "           COMP.DT3_DESCRI  " +CRLF
		cQuery += "        FROM " + RetSqlName('DT8') + " DOCCOMP " +CRLF
		cQuery += " INNER JOIN  " + RetSqlName('DT3') + " COMP " +CRLF
		cQuery += "      ON ( COMP.DT3_FILIAL='" + xFilial("DT3") + "'" +CRLF
		cQuery += "       AND COMP.DT3_FILIAL = DOCCOMP.DT8_FILIAL " +CRLF
		cQuery += "       AND COMP.DT3_CODPAS = DOCCOMP.DT8_CODPAS " +CRLF
		cQuery += "       AND COMP.D_E_L_E_T_=' ')" +CRLF
		cQuery += "  WHERE DOCCOMP.DT8_FILIAL  = '" + xFilial("DT8") + "'" +CRLF
		cQuery += "    AND DOCCOMP.DT8_FILDOC  = '" + AllTrim((cAliasCT)->DT6_FILDOC)	+ "'" +CRLF
		cQuery += "    AND DOCCOMP.DT8_DOC     = '" + AllTrim((cAliasCT)->DT6_DOC)		+ "'" +CRLF
		cQuery += "    AND DOCCOMP.DT8_SERIE   = '" + AllTrim((cAliasCT)->DT6_SERIE)	+ "'" +CRLF
		cQuery += "    AND DOCCOMP.D_E_L_E_T_  = ' '"
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasDT8, .F., .T.)
	
		While !(cAliasDT8)->(Eof())
			nCount += 2
			oDacte:Say(nLInic, nCInic, SubStr(AllTrim((cAliasDT8)->DT3_DESCRI),1,12)   , oFont08)			//Descricao do Componente
		
			nCInic += 0070	//Proxima Coluna
			If lCTEVFRE
				oDacte:Say(nLInic, nCInic, Transform((cAliasDT8)->DT8_VALPAS, '@E 9,999999.99'), oFont08)	//Valor do Componente
			Else
				oDacte:Say(nLInic, nCInic, Transform((cAliasDT8)->DT8_VALTOT, '@E 9,999999.99'), oFont08)	//Valor do Componente
			EndIf
		
			nCInic += 0070	//Proxima Coluna
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FORCAR A "QUEBRA" DA LINHA, SENDO 6 CAMPOS POR LINHA.                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( (mod(nCount,6)) == 0 )
				nCount_2 += 1
				Do Case
				Case ( nCount_2 == 1 )
					cLabel := Transform((cAliasCT)->DT6_VALTOT,'@E 999,999.99')
				Case ( nCount_2 == 2 )
					cLabel := ""
				Case ( nCount_2 == 3 )
					oDacte :Line(nLInic - 0008, 0420, nLInic - 0008, 0559) // Linha: VALOR A RECEBER
					cLabel := "Valor a Receber"
				Case ( nCount_2 == 4 )
					cLabel := Transform((cAliasCT)->DT6_VALFAT,'@E 999,999.99')
				EndCase
				oDacte:Say(nLInic , 0423, cLabel, oFont10N)
				nLInic   += 0008
				nCInic   := 0003
			EndIf
			(cAliasDT8)->(DbSkip())
		EndDo
		For nCount := (1 + nCount) To 24
			lControl := !lControl
			nCInic   += 0070
			cLabel   := ""
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FORCAR A "QUEBRA" DA LINHA, SENDO 6 CAMPOS POR LINHA.                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( (mod(nCount,6)) == 0 )
				nCount_2 += 1
			
				Do Case
				Case ( nCount_2 == 1 )
					cLabel := PadL(Transform((cAliasCT)->DT6_VALTOT,'@E 999,999.99'),20)
				Case ( nCount_2 == 2 )
					cLabel := ""
				Case ( nCount_2 == 3 )
					oDacte :Line(nLInic - 0008, 0420, nLInic - 0008, 0559) // Linha: VALOR A RECEBER
					cLabel := "Valor a Receber"
				Case ( nCount_2 == 4 )
					cLabel := PadL(Transform((cAliasCT)->DT6_VALFAT,'@E 999,999.99'),20)
				EndCase
			
				oDacte:Say(nLInic , 0423, cLabel, oFont10N)
				nLInic   += 0008
				nCInic   := 0003
			EndIf
		Next nCount
		(cAliasDT8)->(dbCloseArea())
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: INFORMACOES RELATIVAS AO IMPOSTO                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If !lComp
		nLInic	:= 0505
		nLFim	:= 0531
	Else
		nLInic	:= 0565
		nLFim	:= 0591
	EndIf

	oDacte:Box(nLInic , 0000, nLFim, 0559)

	nLInic += 0006
	oDacte:Say(nLInic , 0212, "Informações Relativas ao Imposto", oFont08N)

	nLInic += 0002
	oDacte:Line(nLInic, 0000, nLInic, 0559)	// Linha:
	oDacte:Line(nLInic, 0240, nLFim, 0240)	// Linha: Separador Situacao Trib	/ Base de Calculo
	oDacte:Line(nLInic, 0310, nLFim, 0310) 	// Linha: Separador Base de Calculo	/ Aliq.ICMS
	oDacte:Line(nLInic, 0360, nLFim, 0360) 	// Linha: Separador Aliq.ICMS    	/ Valor ICMS
	oDacte:Line(nLInic, 0430, nLFim, 0430) 	// Linha: Separador Valor ICMS    	/ %Red Bc.Calc
	oDacte:Line(nLInic, 0500, nLFim, 0500) 	// Linha: Separador %Red Bc.Calc	/ ICMS ST

	nLInic += 0008
	oDacte:Say(nLInic , 0003, "Situação Tributária", oFont08N)   // Label: Situação Tributária
	oDacte:Say(nLInic , 0243, "Base de Cálculo"    , oFont08N)   // Label: Base de Cálculo
	oDacte:Say(nLInic , 0313, "Aliq.ICMS"          , oFont08N)   // Label: Aliq.ICMS
	oDacte:Say(nLInic , 0363, "Valor ICMS"         , oFont08N)   // Label: Valor ICMS
	oDacte:Say(nLInic , 0433, "%Red.Bc.Calc."      , oFont08N)   // Label: %Red.Bc.Calc.
	oDacte:Say(nLInic , 0503, "ICMS ST"            , oFont08N)   // Label: ICMS ST"


	If !lXML
		cAliasImp := DataSource( 'IMPOSTOS' )
	
		If !(cAliasImp)->(Eof())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Seleciona a descricao da Substituicao Tributaria.                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cAliasD2 := DataSource( 'DESCRSUBSTTRIBUTARIA' )
		
			If !(cAliasD2)->(Eof())
				cSitTriba := SUBSTR((cAliasImp)->FT_CLASFIS,2,2) + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40)
			EndIf
			(cAliasD2)->(DbCloseArea())
		
		//-- Inicio % de Reducao Base Calculo ICM
			If SubStr((cAliasImp)->FT_CLASFIS, 2, 2) == '00'
				cBaseIcms	:= (cAliasImp)->FT_BASEICM
				cAliqIcms	:= (cAliasImp)->FT_ALIQICM
				cValIcms	:= (cAliasImp)->FT_VALICM

			ElseIf SubStr((cAliasImp)->FT_CLASFIS, 2, 2) $ "40,41,51"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ ICMS Isento, nao Tributado ou diferido  ³
			//³ - 40: ICMS Isencao                      ³
			//³ - 41: ICMS Nao Tributada                ³
			//³ - 51: ICMS Diferido                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cBaseIcms	:= (cAliasImp)->FT_BASEICM
				cAliqIcms	:= (cAliasImp)->FT_ALIQICM
				cValIcms	:= (cAliasImp)->FT_VALICM

			ElseIf SubStr((cAliasImp)->FT_CLASFIS, 2, 2) $ "10,30,70"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ - 80: ICMS pagto atribuido ao tomador ou ao 3o previsto para    ³
			//³ substituicao tributaria                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cBaseIcms	:= (cAliasImp)->FT_BASEICM
				cAliqIcms 	:= (cAliasImp)->FT_ALIQICM
				cValIcms 	:= (cAliasImp)->FT_VALICM
				cIcmsSt	:= (cAliasImp)->FT_ICMSRET
		
			ElseIf SubStr((cAliasImp)->FT_CLASFIS, 2, 2) = "60"
				cBaseIcms	:= (cAliasImp)->FT_BASERET
				cAliqIcms 	:= (cAliasImp)->FT_ALIQSOL
				cValIcms 	:= (cAliasImp)->FT_ICMSRET + (cAliasImp)->FT_CRPRST
				cIcmsSt	:= (cAliasImp)->FT_ICMSRET

			ElseIf SubStr((cAliasImp)->FT_CLASFIS, 2, 2) $ '20,90' .Or. AllTrim((cAliasCT)->CFOP) $ "5932,6932"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ - 81: ICMS DEVIDOS A OUTRAS UF'S                                ³
			//³ - 90: ICMS Outros                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cAliasRBC := GetNextAlias()
				cQuery := " SELECT F4_BASEICM " + CRLF
				cQuery += "   FROM " + RetSqlName("SD2") + " D2," + RetSqlName("SF4") + " F4 " + CRLF
				cQuery += "  WHERE D2.D2_FILIAL  = '"  + xFilial('SD2') + "'" + CRLF
				cQuery += "    AND D2.D2_DOC     = '"  + (cAliasCT)->F3_NFISCAL	+ "'" + CRLF
				cQuery += "    AND D2.D2_SERIE   = '"  + (cAliasCT)->F3_SERIE  + "'" + CRLF
				cQuery += "    AND D2.D2_CLIENTE = '"  + (cAliasCT)->F3_CLIEFOR	+ "'" + CRLF
				cQuery += "    AND D2.D2_LOJA    = '"  + (cAliasCT)->F3_LOJA   + "'" + CRLF
				cQuery += "    AND D2.D_E_L_E_T_<>'*'" + CRLF
			//-- Cadastro de TES
				cQuery += "    AND F4.F4_FILIAL  = '"  + xFilial('SF4') + "'" + CRLF
				cQuery += "    AND F4.F4_CODIGO  = D2.D2_TES" + CRLF
				cQuery += "    AND F4.D_E_L_E_T_<>'*'"
				cQuery := ChangeQuery(cQuery)
				DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasRBC, .F., .T.)

				If !(cAliasRBC)->(Eof())
					If (cAliasRBC)->F4_BASEICM > 0
						cRedBcCalc := AllTrim(Str(100-(cAliasRBC)->F4_BASEICM ))
					EndIf
				EndIf

				(cAliasRBC)->(DbCloseArea())

				cBaseIcms	:= (cAliasImp)->FT_BASEICM
				cAliqIcms	:= (cAliasImp)->FT_ALIQICM
				cValIcms 	:= (cAliasImp)->FT_VALICM
				cIcmsSt	:= (cAliasImp)->FT_ICMSRET
			EndIf
		
		//-- CT-e complemento ICMS campos preenchidos somente para permitir a validacao do CT-e
			If (cAliasCT)->DT6_DOCTMS == "8" .And. cBaseIcms == 0 .And. cAliqIcms == 0 .And. cValIcms > 0
				cBaseIcms := cValIcms
				cAliqIcms := 100
			EndIf
		
		EndIf
		(cAliasImp)->(DbCloseArea())
	Else
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS00>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT")=="U"

			cAliasImp := DataSource( 'IMPOSTOS' )
			cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

			cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT")=="U"," ",;
				oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

			cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT)
			cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT)
			cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT)
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS45>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT") == "U"

			cAliasImp := DataSource( 'IMPOSTOS' )
			cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

			cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT")=="U"," ",;
				oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )
 
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS90>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT") == "U"

			cAliasImp := DataSource( 'IMPOSTOS' )
			cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

			cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT")=="U"," ",;
				oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

			cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VBC:TEXT)
			cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_PICMS:TEXT)
			cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VICMS:TEXT)
			cIcmsSt	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_vCred:TEXT)
			cRedBcCalc := Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_pRedBC:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_pRedBC:TEXT) ))
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS20>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT") == "U"

			cAliasImp := DataSource( 'IMPOSTOS' )
			cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

			cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT")=="U"," ",;
				oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

			cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VBC:TEXT)
			cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_PICMS:TEXT)
			cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VICMS:TEXT)
			cRedBcCalc := Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_pRedBC:TEXT)
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS60>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT") == "U"

			cAliasImp := DataSource( 'IMPOSTOS' )
			cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

			cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT")=="U"," ",;
				oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

			cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VBCSTRET:TEXT)
			cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_PICMSSTRET:TEXT)
			cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VICMSSTRET:TEXT)
			cCredPres	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_vCred:TEXT)
			cIcmsSt  	:= cValIcms - cCredPres
		ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_CST:TEXT") == "U"

			cAliasImp := DataSource( 'IMPOSTOS' )
			cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

			cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_CST:TEXT")=="U"," ",;
				oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

			cBaseIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_vBCOutraUF:TEXT)
			cAliqIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_pICMSOutraUF:TEXT)
			cValIcms	:= Val(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_vICMSOutraUF:TEXT)
			cRedBcCalc := Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_pRedBCOutraUF:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_pRedBCOutraUF:TEXT) ))
		EndIf
	Endif //-- !XML

	nLInic += 0008
	oDacte:Say(nLInic , 0003, cSitTriba,								oFont08)
	oDacte:Say(nLInic , 0243, Transform(cBaseIcms , '@E 999,999.99'),	oFont08)
	oDacte:Say(nLInic , 0313, Transform(cAliqIcms , '@E 999,999.99'),	oFont08)
	oDacte:Say(nLInic , 0363, Transform(cValIcms  , '@E 999,999.99'),	oFont08)
	oDacte:Say(nLInic , 0433, Transform(cRedBcCalc, '@E 999,999.99'),	oFont08)
	oDacte:Say(nLInic , 0503, Transform(cIcmsSt   , '@E 999,999.99'),	oFont08)

	lComp := .F. //CTE Complementar

Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³ TMSR27Cmp³ Autor ³Igor Franzoi           ³ Data ³24/10/2013³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Funcao responsavel por montar o BOX relativo as informacoes ³±±
	±±³          ³dos componentes e valores complementados                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   |                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Nenhum                                                      ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³               ³                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function TMSR27Cmp()

	Local nCount    := 0
	Local nCount_2  := 0
	Local oFont08   := TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
	Local oFont08N  := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
	Local lControl  := .F.
	Local cAliasChv := ''

	lComp := .T.	//CTE Complementar

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: COMPONENTES DO VALOR DA PRESTACAO DO SERVICO                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLInic  := 0397
	nLFim   := 0503
	oDacte:Box(nLInic , 0000, nLFim, 0559)

	nLInic += 0006
	oDacte:Say(nLInic , 0210, "Componentes do Valor da Prestação do Serviço", oFont08N)

	nLInic += 0002
	oDacte:Line(nLInic, 0000, nLInic, 0559)		// Linha: DOCUMENTOS ORIGINARIOS
	oDacte:Line(nLInic, 0279, nLFim , 0279)	// Linha: Separador DOCUMENTOS ORIGINARIOS

	nLInic += 0007
	oDacte:Say(nLInic , 0003, "Chave do CT-e Complementado", oFont08N)
	oDacte:Say(nLInic , 0205, "Valor Complementado", oFont08N)
	oDacte:Say(nLInic , 0281, "Chave do CT-e Complementado", oFont08N)
	oDacte:Say(nLInic , 0483, "Valor Complementado", oFont08N)

	nLInic   += 0008
	nCount   := 0
	nCount_2 := 0
	lControl := .F.

//-- Query para pesquisar a chave do CTE original
	cAliasChv :=  GetNextAlias()
	cQuery := ''
	cQuery += " SELECT DT6.DT6_CHVCTE " +CRLF
	cQuery += "   FROM " + RetSqlName('DT6') + " DT6 " +CRLF
	cQuery += "  WHERE DT6.DT6_FILIAL = '" + xFilial('DT6') + "'" +CRLF
	cQuery += "    AND DT6.DT6_FILDOC = '" + (cAliasCT)->DT6_FILDCO + "'" +CRLF
	cQuery += "    AND DT6.DT6_DOC    = '" + (cAliasCT)->DT6_DOCDCO + "'" +CRLF
	cQuery += "    AND DT6.DT6_SERIE  = '" + (cAliasCT)->DT6_SERDCO + "'" +CRLF
	cQuery += "    AND DT6.D_E_L_E_T_ = ' '"
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasChv, .F., .T.)

	nCount   := 0
	While !(cAliasChv)->(Eof())

		nCount   += 1
		lControl := !lControl

		If nCount < 9

			If (lControl == .T.)
				oDacte:Say(nLInic, 0003, Transform(AllTrim((cAliasChv)->DT6_CHVCTE),"@!")	, oFont08)
				oDacte:Say(nLInic, 0205, PadL(Transform((cAliasCT)->DT6_VALFAT,'@E 9,999,999.9999'),20), oFont08)
			Else
				oDacte:Say(nLInic, 0281, Transform(AllTrim((cAliasChv)->DT6_CHVCTE),"@!")	, oFont08)
			EndIf

		EndIf

		(cAliasChv)->(DbSkip())

	EndDo

	(cAliasChv)->(dbCloseArea())

Return
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³AjustaSX1     ³ Autor ³Igor Franzoi          ³ Data ³24/10/2013³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³Ajusta o X1_GSC                                                ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³AjustaSX1()                                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	/*/
Static Function AjustaSX1()
	Local aArea    := GetArea()
	Local cTamLot  := TamSX3("DTP_LOTNFC")[1]
	Local cTamDoc  := TamSX3("DT6_DOC")[1]
	Local cTamSer  := TamSX3("DT6_SERIE")[1]
	Local cTamTip  := TamSX3("DT6_DOCTMS")[1]
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpEsp := {}

	aHelpPor := {"Informe o lote inicial."}
	aHelpEng := {"Introduzca el lote inicial."}
	aHelpEsp := {"Enter the initial batch."}
	PutSx1(	"RTMSR25", "01", "Lote De", "De Lote?", "From Lot?", ;
		"MV_CH1", "C",cTamLot, 0, 0, "G", "", "DTP", "", "", ;
		"MV_PAR01", "", "", "", "", "", "", "", "", ;
		"", "", "", "N", "", "", "", "", ;
		aHelpPor, aHelpEng, aHelpEsp )

	aHelpPor := {"Informe o lote final."}
	aHelpEng := {"Introduzca la mezcla final."}
	aHelpEsp := {"Enter the final blend."}
	PutSx1(	"RTMSR25", "02", "Lote Ate", "A Lote?", "To Lot?", ;
		"MV_CH2", "C", cTamLot, 0, 0, "G", "", "DTP", "", "", ;
		"MV_PAR02", "", "", "", "", "", "", "", "", ;
		"", "", "", "N", "", "", "", "", ;
		aHelpPor, aHelpEng, aHelpEsp )


//-- Numero do Documento.
	aHelpPor := {"Informe o documento inicial."}
	aHelpEng := {"Introduzca el documento de partida."}
	aHelpEsp := {"Enter the starting document."}
	PutSx1(	"RTMSR25", "03", "Documento De", "De Documento", "From Document", ;
		"MV_CH3", "C", cTamDoc, 0, 0, "G", "", "DT6", "", "", ;
		"MV_PAR03", "", "", "", "", "", "", "", "", ;
		"", "", "", "N", "", "", "", "", ;
		aHelpPor, aHelpEng, aHelpEsp )
			
	aHelpPor := {"Informe o documento final."}
	aHelpEng := {"Introduzca el documento final."}
	aHelpEsp := {"Enter the final document."}
	PutSx1(	"RTMSR25", "04", "Documento Ate", "A Documento", "To Document", ;
		"MV_CH4", "C", cTamDoc, 0, 0, "G", "", "DT6", "", "", ;
		"MV_PAR04", "", "", "", "", "", "", "", "", ;
		"", "", "", "N", "", "", "", "", ;
		aHelpPor, aHelpEng, aHelpEsp )


//-- Serie do Documento.
	aHelpPor := {"Informe  serie do documento inicial."}
	aHelpEng := {"Informe de la serie del documento original."}
	aHelpEsp := {"Report series of the original document."}
	PutSx1(	"RTMSR25", "05", "Serie De", "De Serie", "From Series", ;
		"MV_CH5", "C", cTamSer, 0, 0, "G", "", "", "", "", ;
		"MV_PAR05", "", "", "", "", "", "", "", "", ;
		"", "", "", "N", "", "", "", "", ;
		aHelpPor, aHelpEng, aHelpEsp )

	aHelpPor := {"Informe  serie do documento final."}
	aHelpEng := {"La serie de Informes del documento final."}
	aHelpEsp := {"Report series of the final document."}
	PutSx1(	"RTMSR25", "06", "Serie Ate", "A Serie", "To Series", ;
		"MV_CH6", "C", cTamSer, 0, 0, "G", "", "", "", "", ;
		"MV_PAR06", "", "", "", "", "", "", "", "", ;
		"", "", "", "N", "", "", "", "", ;
		aHelpPor, aHelpEng, aHelpEsp )


//-- Tipo do Documento.
	aHelpPor := {"Informe  o tipo do documento."}
	aHelpEng := {"Introduzca el tipo de documento."}
	aHelpEsp := {"Enter the type of document."}
	PutSx1(	"RTMSR25", "07", "Tipo do Documento", "Tipo do Documento", "Document Type", ;
		"MV_CH7", "C", cTamTip, 0, 0, "G", "", "DLC", "", "", ;
		"MV_PAR07", "", "", "", "", "", "", "", "", ;
		"", "", "", "N", "", "", "", "", ;
		aHelpPor, aHelpEng, aHelpEsp )

//-- Tipo do Documento.
	aHelpPor := {"Buscar XML direto do WebService."}
	aHelpEng := {"Buscar XML direto do WebService."}
	aHelpEsp := {"Buscar XML direto do WebService."}
	PutSx1(	"RTMSR25", "08", "Buscar XML", "Buscar XML", "Buscar XML", ;
		"MV_CH8", "N", 1, 0, 2, "C", "", "", "", "", ;
		"MV_PAR08", "Sim", "Si", "Yes", "", "Nao", "No", "No", "", ;
		"", "", "", "N", "", "", "", "", ;
		aHelpPor, aHelpEng, aHelpEsp )

	RestArea(aArea)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR27   ³ Autor ³Igor Franzoi        ³ Data ³24/10/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna um Array com a estrutura do campo complemento rel. º±±
±±º          ³ ao objeto passado por parametro                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TMS                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TMSGetComp( oObject )
	Local i			:= 0		// Auxiliar no Incremento da Estrutura de Laco
	Local aAuxClone	:= { }		// Copia da propriedade Comp do Objeto passado por parametro
	Local aAuxComp	:= { }		// Auxiliar no processamento de aAuxClone
	Local aResult	:= { }		// Retorno da Funcao

	/*If Valtype(XmlChildEx(oObject:_CTE:_INFCTE,"_INFCTECOMP")) <> "U"    //Complemento
		If (Type("oObject:_CTE:_INFCTE:_INFCTECOMP:_VPRESCOMP:_COMPCOMP")) <> "U"
			If Valtype( oObject:_CTE:_INFCTE:_INFCTECOMP:_VPRESCOMP:_COMPCOMP ) == "A"
				aAuxClone := ACLONE( oObject:_CTE:_INFCTE:_INFCTECOMP:_VPRESCOMP:_COMPCOMP)
				For i := 1 To Len( aAuxClone )
					AADD( aResult, {AllTrim(aAuxClone[ i ]:_XNOME:TEXT), AllTrim(aAuxClone[ i ]:_VCOMP:TEXT)} )
				Next i
			ElseIf Valtype( oObject:_CTE:_INFCTE:_INFCTECOMP:_VPRESCOMP ) == "O"
				AADD( aAuxComp, AllTrim(oObject:_CTE:_INFCTE:_INFCTECOMP:_VPRESCOMP:_COMPCOMP:_XNOME:TEXT) )
				AADD( aAuxComp, AllTrim(oObject:_CTE:_INFCTE:_INFCTECOMP:_VPRESCOMP:_COMPCOMP:_VCOMP:TEXT) )
				AADD( aResult, aAuxComp )
				aAuxComp := {}
			EndIf 
		EndIf
	Else*/
		If (cAliasCT)->DT6_TIPTRA == "1"
			If	ValType( oObject:_CTE:_INFCTE:_VPREST:_COMP ) == "A"
				aAuxClone := ACLONE( oObject:_CTE:_INFCTE:_VPREST:_COMP )
				For i := 1 To Len( aAuxClone )
					AADD( aResult, {AllTrim(aAuxClone[ i ]:_XNOME:TEXT), AllTrim(aAuxClone[ i ]:_VCOMP:TEXT)} )
				Next i
			ElseIf	ValType( oObject:_CTE:_INFCTE:_VPREST:_COMP ) == "O"
				AADD( aAuxComp, AllTrim(oObject:_CTE:_INFCTE:_VPREST:_COMP:_XNOME:TEXT) )
				AADD( aAuxComp, AllTrim(oObject:_CTE:_INFCTE:_VPREST:_COMP:_VCOMP:TEXT) )
				AADD( aResult, aAuxComp )
				aAuxComp := {}
			EndIf
		EndIf
	//EndIf

Return ( aResult )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR27   ³ Autor ³Igor Franzoi        ³ Data ³24/10/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DataSource( cSource )
	Local cNewArea	:= GetNextAlias()
	Local cQuery	:= ""

	cQuery := GetSQL( cSource )
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cNewArea, .F., .T.)

Return ( cNewArea )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR27   ³ Autor ³Igor Franzoi        ³ Data ³24/10/2013   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³  Cria DACTE sem utilizar o XML, utilizando tabela.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetSQL( cSource )
	Local cQuery	:= ""
	Local cSitTriba	:= ""
	Local cForSeg	:= SuperGetMv("MV_FORSEG",,"")
	Local lForApol	:= SA2->(FieldPos('A2_APOLICE')) > 0
	Local nTamCod	:= Len(SA2->A2_COD)
	Local nTamLoj	:= Len(SA2->A2_LOJA)
	Local aResp		:= {}

	If	cSource == 'DT6'
		cQuery += "    SELECT DISTINCT " + CRLF
		cQuery += "    CTRC.DT6_FILDOC,                " +CRLF
		cQuery += "    CTRC.DT6_SERIE,                 " +CRLF
		cQuery += "    CTRC.DT6_DOC,                   " +CRLF
		cQuery += "    CTRC.DT6_DATEMI,                " +CRLF
		cQuery += "    CTRC.DT6_HOREMI,                " +CRLF
		cQuery += "    CTRC.DT6_DOCTMS,                " +CRLF
		cQuery += "    CTRC.DT6_TIPTRA,                " +CRLF
		cQuery += "    CTRC.DT6_FILIAL,                " +CRLF
		cQuery += "    CTRC.DT6_CLIDEV,                " +CRLF
		cQuery += "    CTRC.DT6_LOJDEV,                " +CRLF
		cQuery += "    CTRC.DT6_CLIREM,                " +CRLF
		cQuery += "    CTRC.DT6_LOJREM,                " +CRLF
		cQuery += "    CTRC.DT6_CLIDES,                " +CRLF
		cQuery += "    CTRC.DT6_LOJDES,                " +CRLF
		cQuery += "    CTRC.DT6_CLICON,                " +CRLF
		cQuery += "    CTRC.DT6_LOJCON,                " +CRLF
		cQuery += "    CTRC.DT6_CLIDPC,                " +CRLF
		cQuery += "    CTRC.DT6_LOJDPC,                " +CRLF
		cQuery += "    CTRC.DT6_VALTOT,                " +CRLF
		cQuery += "    CTRC.DT6_PRZENT,                " +CRLF
		cQuery += "    CTRC.DT6_VOLORI,                " +CRLF
		cQuery += "    CTRC.DT6_CHVCTE,                " +CRLF
		cQuery += "    CTRC.DT6_PROCTE,                " +CRLF
		cQuery += "    CTRC.DT6_VALMER,                " +CRLF
		cQuery += "    CTRC.DT6_VALFAT,                " +CRLF
		cQuery += "    CTRC.DT6_PESO,                  " +CRLF
		cQuery += "    CTRC.DT6_PESOM3,                " +CRLF
		cQuery += "    CTRC.DT6_METRO3,                " +CRLF
		cQuery += "    CTRC.DT6_SERVIC,                " +CRLF
		cQuery += "    CTRC.DT6_LOTNFC,                " +CRLF
		cQuery += "    CTRC.DT6_FILDCO,                " +CRLF
		cQuery += "    CTRC.DT6_DOCDCO,                " +CRLF
		cQuery += "    CTRC.DT6_SERDCO,                " +CRLF
		cQuery += "    CTRC.DT6_CODMSG,                " +CRLF
		cQuery += "    CTRC.DT6_CODOBS,                " +CRLF
		cQuery += "    CTRC.DT6_AMBIEN,                " +CRLF
		cQuery += "    CTRC.DT6_CDRORI,                " +CRLF
		cQuery += "    CTRC.DT6_DEVFRE,                " +CRLF
		cQuery += "    CTRC.DT6_FILORI,                " +CRLF
		cQuery += "    CTRC.DT6_IDRCTE,                " +CRLF
		cQuery += "    CTRC.DT6_CHVCTG,                " +CRLF
		cQuery += "    CTRC.DT6_PREFIX,                " +CRLF
		cQuery += "    CTRC.DT6_NUM,	                   " +CRLF
		cQuery += "    CTRC.DT6_TIPO ,                 " +CRLF
		cQuery += "    CTRC.DT6_VALIMP,                " +CRLF

		cQuery += "    CLIREM.A1_NOME REM_NOME,        " +CRLF
		cQuery += "    CLIREM.A1_END REM_END,          " +CRLF
		cQuery += "    CLIREM.A1_BAIRRO REM_BAIRRO,    " +CRLF
		cQuery += "    DTQ.DTQ_ORIGEM REM_MUNICI,      " +CRLF
		cQuery += "    ''			 REM_UF,           " +CRLF
		cQuery += "    CLIREM.A1_CEP REM_CEP,          " +CRLF
		cQuery += "    CLIREM.A1_CGC REM_CNPJ,         " +CRLF
		cQuery += "    CLIREM.A1_INSCR REM_INSC,       " +CRLF
		cQuery += "    CLIREM.A1_DDD REM_DDDTEL,       " +CRLF
		cQuery += "    CLIREM.A1_TEL REM_TEL,          " +CRLF
		cQuery += "    CLIREM.A1_PAIS REM_PAIS,        " +CRLF
		cQuery += "    CLIREM.A1_PESSOA REM_TPPESSOA,  " +CRLF

		cQuery += "    CLIDES.A1_NOME DES_NOME,        " +CRLF
		cQuery += "    CLIDES.A1_END DES_END,          " +CRLF
		cQuery += "    CLIDES.A1_BAIRRO DES_BAIRRO,    " +CRLF
		cQuery += "    DTQ.DTQ_DESTIN DES_MUNICI,      " +CRLF
		cQuery += "    ''			 DES_UF,           " +CRLF
		cQuery += "    CLIDES.A1_CEP DES_CEP,          " +CRLF
		cQuery += "    CLIDES.A1_CGC DES_CNPJ,         " +CRLF
		cQuery += "    CLIDES.A1_INSCR DES_INSC,       " +CRLF
		cQuery += "    CLIDES.A1_DDD DES_DDDTEL,       " +CRLF
		cQuery += "    CLIDES.A1_TEL DES_TEL,          " +CRLF
		cQuery += "    CLIDES.A1_PAIS DES_PAIS,        " +CRLF
		cQuery += "    CLIDES.A1_SUFRAMA DES_SUFRAMA,  " +CRLF
		cQuery += "    CLIDES.A1_PESSOA DES_TPPESSOA,  " +CRLF

		cQuery += "    CLICON.A1_CGC CON_CNPJ,         " +CRLF
		cQuery += "    CLICON.A1_INSCR CON_INSC,       " +CRLF
		cQuery += "    CLICON.A1_CONTRIB CON_CONTRIB,  " +CRLF
		cQuery += "    CLICON.A1_NOME CON_NOME,        " +CRLF
		cQuery += "    CLICON.A1_DDD CON_DDDTEL,       " +CRLF
		cQuery += "    CLICON.A1_TEL CON_TEL,          " +CRLF
		cQuery += "    CLICON.A1_PESSOA CON_TPPESSOA,  " +CRLF
		cQuery += "    CLICON.A1_SUFRAMA CON_SUFRAMA,  " +CRLF
		cQuery += "    CLICON.A1_END CON_END,          " +CRLF
		cQuery += "    CLICON.A1_BAIRRO CON_BAIRRO,    " +CRLF
		cQuery += "    CLICON.A1_MUN CON_MUNICI,       " +CRLF
		cQuery += "    CLICON.A1_CEP CON_CEP,          " +CRLF
		cQuery += "    CLICON.A1_EST CON_UF,           " +CRLF
		cQuery += "    CLICON.A1_PAIS CON_PAIS,        " +CRLF
		cQuery += "    CLICON.A1_COD_MUN CON_COD_MUN,  " +CRLF
	
		cQuery += "    CLIDPC.A1_CGC DPC_CNPJ,         " +CRLF
		cQuery += "    CLIDPC.A1_INSCR DPC_INSC,       " +CRLF
		cQuery += "    CLIDPC.A1_CONTRIB DPC_CONTRIB,  " +CRLF
		cQuery += "    CLIDPC.A1_NOME DPC_NOME,        " +CRLF
		cQuery += "    CLIDPC.A1_DDD DPC_DDDTEL,       " +CRLF
		cQuery += "    CLIDPC.A1_TEL DPC_TEL,          " +CRLF
		cQuery += "    CLIDPC.A1_PESSOA DPC_TPPESSOA,  " +CRLF
		cQuery += "    CLIDPC.A1_SUFRAMA DPC_SUFRAMA,  " +CRLF
		cQuery += "    CLIDPC.A1_END DPC_END,          " +CRLF
		cQuery += "    CLIDPC.A1_BAIRRO DPC_BAIRRO,    " +CRLF
		cQuery += "    CLIDPC.A1_MUN DPC_MUNICI,       " +CRLF
		cQuery += "    CLIDPC.A1_CEP DPC_CEP,          " +CRLF
		cQuery += "    CLIDPC.A1_EST DPC_UF,           " +CRLF
		cQuery += "    CLIDPC.A1_PAIS DPC_PAIS,        " +CRLF
		cQuery += "    CLIDPC.A1_COD_MUN DPC_COD_MUN,  " +CRLF

		cQuery += "    CLIDEV.A1_NOME DEV_NOME,        " +CRLF
		cQuery += "    CLIDEV.A1_END DEV_END,          " +CRLF
		cQuery += "    CLIDEV.A1_BAIRRO DEV_BAIRRO,    " +CRLF
		cQuery += "    CLIDEV.A1_MUN DEV_MUNICI,       " +CRLF
		cQuery += "    CLIDEV.A1_EST DEV_UF,           " +CRLF
		cQuery += "    CLIDEV.A1_CEP DEV_CEP,          " +CRLF
		cQuery += "    CLIDEV.A1_CGC DEV_CNPJ,         " +CRLF
		cQuery += "    CLIDEV.A1_INSCR DEV_INSC,       " +CRLF
		cQuery += "    CLIDEV.A1_DDD DEV_DDDTEL,       " +CRLF
		cQuery += "    CLIDEV.A1_TEL DEV_TEL,          " +CRLF
		cQuery += "    CLIDEV.A1_PAIS DEV_PAIS,        " +CRLF
		cQuery += "    CLIDEV.A1_SUFRAMA DEV_SUFRAMA,  " +CRLF
		cQuery += "    CLIDEV.A1_PESSOA DEV_TPPESSOA,  " +CRLF

		cQuery += "    LFISCAL.F3_CFO,                 " + CRLF
		cQuery += "    LFISCAL.F3_ALIQICM,             " + CRLF
		cQuery += "    LFISCAL.F3_CFO CFOP,            " + CRLF
		cQuery += "    LFISCAL.F3_CLIEFOR,             " + CRLF
		cQuery += "    LFISCAL.F3_LOJA,                " + CRLF
		cQuery += "    LFISCAL.F3_NFISCAL,             " + CRLF
		cQuery += "    LFISCAL.F3_SERIE,               " + CRLF
	
		cQuery += "    NF_LF.F2_BASEICM,               " + CRLF
		cQuery += "    NF_LF.F2_VALICM,                " + CRLF
		cQuery += "    NF_LF.F2_SERIE,                 " + CRLF
		cQuery += "    NF_LF.F2_DOC,                   " + CRLF
		cQuery += "    NF_LF.F2_CLIENTE,               " + CRLF
		cQuery += "    NF_LF.F2_LOJA,                  " + CRLF
		cQuery += "    DTQ.DTQ_CODORI ORI_CODORI,      " + CRLF
		cQuery += "    DTQ.DTQ_CODDES DES_CODDES,      " + CRLF
		cQuery += "	   DTQ.DTQ_VLRINF AQU_VLRINF,	   " + CRLF
		cQuery += "	   DTQ.DTQ_AFRMM  AQU_AFRMM,	   " + CRLF
		cQuery += "	   DTQ.DTQ_IRIN   AQU_IRIN,		   " + CRLF
		cQuery += "	   DTQ.DTQ_TOTFRE AQU_BSAFR,       " + CRLF

		cQuery += "	   DTQ.DTQ_VIAGEM, " + CRLF		// Cristiam Rossi em 18/08/2015
		cQuery += "	   DTQ.DTQ_AS " + CRLF			// Cristiam Rossi em 18/08/2015

		cQuery += "   FROM " + RetSqlName('DT6') + " CTRC " + CRLF
		cQuery += "        LEFT  JOIN " + RetSqlName('DTC') + " DTC ON DTC.D_E_L_E_T_ = '' AND DTC.DTC_FILDOC = CTRC.DT6_FILDOC AND DTC.DTC_DOC = CTRC.DT6_DOC AND DTC.DTC_SERIE = CTRC.DT6_SERIE "
		cQuery += "        LEFT  JOIN " + RetSqlName('DTQ') + " DTQ ON DTQ.D_E_L_E_T_ = '' AND DTQ.DTQ_VIAGEM = DTC.DTC_VIAGEM "
		cQuery += "        LEFT  JOIN " + RetSqlName('SF2') + " NF_LF ON (NF_LF.F2_FILIAL = '" + xFilial('SF2') + "' AND NF_LF.F2_FILIAL = CTRC.DT6_FILDOC AND NF_LF.F2_DOC = CTRC.DT6_DOC AND NF_LF.F2_SERIE = CTRC.DT6_SERIE AND NF_LF.F2_CLIENTE = CTRC.DT6_CLIDEV AND NF_LF.F2_LOJA = CTRC.DT6_LOJDEV AND NF_LF.D_E_L_E_T_ = ' ')" + CRLF
		cQuery += "        INNER JOIN " + RetSqlName('SF3') + " LFISCAL ON(LFISCAL.F3_NFISCAL = CTRC.DT6_DOC AND LFISCAL.F3_SERIE = CTRC.DT6_SERIE AND LFISCAL.F3_CLIEFOR = CTRC.DT6_CLIDEV AND LFISCAL.F3_LOJA = CTRC.DT6_LOJDEV) " + CRLF
		cQuery += "        INNER JOIN " + RetSqlName('SA1') + " CLIREM ON (CLIREM.A1_COD = CTRC.DT6_CLIREM AND CLIREM.A1_LOJA = CTRC.DT6_LOJREM) " + CRLF
		cQuery += "        INNER JOIN " + RetSqlName('SA1') + " CLIDES ON (CLIDES.A1_COD = CTRC.DT6_CLIDES AND CLIDES.A1_LOJA = CTRC.DT6_LOJDES AND CLIDES.D_E_L_E_T_ = ' ' ) " + CRLF
		cQuery += "        INNER JOIN " + RetSqlName('SA1') + " CLIDEV ON (CLIDEV.A1_COD = CTRC.DT6_CLIDEV AND CLIDEV.A1_LOJA = CTRC.DT6_LOJDEV AND CLIDEV.D_E_L_E_T_ = ' ' ) " + CRLF
		cQuery += "        LEFT  JOIN " + RetSqlName('SA1') + " CLICON ON (CLICON.A1_FILIAL = '" + xFilial('SA1') + "' AND CLICON.A1_COD = CTRC.DT6_CLICON AND CLICON.A1_LOJA = CTRC.DT6_LOJCON AND CLICON.D_E_L_E_T_ = ' ' ) " + CRLF
		cQuery += "        LEFT  JOIN " + RetSqlName('SA1') + " CLIDPC ON (CLIDPC.A1_FILIAL = '" + xFilial('SA1') + "' AND CLIDPC.A1_COD = CTRC.DT6_CLIDPC AND CLIDPC.A1_LOJA = CTRC.DT6_LOJDPC AND CLIDPC.D_E_L_E_T_ = ' ' ) " + CRLF
	//cQuery += "        INNER JOIN " + RetSqlName('DTP') + " LOTE   ON (LOTE.DTP_FILORI = CTRC.DT6_FILORI AND LOTE.DTP_LOTNFC = CTRC.DT6_LOTNFC AND "
	//cQuery += "        LOTE.D_E_L_E_T_ = ' ')" + CRLF

		cQuery += "  WHERE CTRC.DT6_FILIAL  = '" + xFilial('DT6') + "'" + CRLF
		cQuery += "    AND CTRC.DT6_FILORI  = '" + cFilAnt  + "'" + CRLF
		cQuery += "    AND CTRC.DT6_LOTNFC >= '" + MV_PAR01 + "'" + CRLF
		cQuery += "    AND CTRC.DT6_LOTNFC <= '" + MV_PAR02 + "'" + CRLF
	//cQuery += "    AND CTRC.DT6_IDRCTE = '100'" + CRLF

		cQuery += "    AND CTRC.DT6_DOC    >= '" + MV_PAR03 + "'" + CRLF
		cQuery += "    AND CTRC.DT6_DOC    <= '" + MV_PAR04 + "'" + CRLF
		cQuery += "    AND CTRC.DT6_SERIE  >= '" + MV_PAR05 + "'" + CRLF
		cQuery += "    AND CTRC.DT6_SERIE  <= '" + MV_PAR06 + "'" + CRLF
//	cQuery += "    AND CTRC.DT6_DOCTMS  = '" + MV_PAR07 + "'" + CRLF
		cQuery += "    AND CTRC.D_E_L_E_T_  = ' ' " + CRLF

		cQuery += "  AND LFISCAL.F3_FILIAL = '" + xFilial('SF3') + "'" + CRLF
		cQuery += "  AND LFISCAL.D_E_L_E_T_= ' '" + CRLF

		cQuery += "  AND CLIREM.A1_FILIAL  = '"  + xFilial('SA1') + "'" + CRLF
		cQuery += "  AND CLIREM.D_E_L_E_T_ = ' '" + CRLF

		cQuery += "  AND CLIDES.A1_FILIAL  = '"  + xFilial('SA1') + "'" + CRLF
		cQuery += "  AND CLIDES.D_E_L_E_T_ = ' '" + CRLF

		cQuery += "  AND CLIDEV.A1_FILIAL  = '"  + xFilial('SA1') + "'" + CRLF
		cQuery += "  AND CLIDEV.D_E_L_E_T_ = ' '" + CRLF

//	cQuery += "  AND LOTE.DTP_FILIAL  = '" + xFilial('DTP') + "'" + CRLF
//	cQuery += "  AND LOTE.D_E_L_E_T_  = ' '" + CRLF

		cQuery += "  ORDER BY CTRC.DT6_FILIAL, " + CRLF
		cQuery += "           CTRC.DT6_DOC,    " + CRLF
		cQuery += "           CTRC.DT6_SERIE   "

	ElseIf cSource == 'DTC'

		cQuery += " SELECT Count(NF.DTC_NUMNFC) nTotal "
		cQuery += "   FROM " + RetSqlName('DTC') + " NF "
		cQuery += "  WHERE NF.DTC_FILIAL = '" + xFilial("DTC") + "'"
		cQuery += "    AND NF.DTC_FILDOC = '" + AllTrim((cAliasCT)->DT6_FILDOC) + "'"
		cQuery += "    AND NF.DTC_DOC    = '" + AllTrim((cAliasCT)->DT6_DOC)    + "'"
		cQuery += "    AND NF.DTC_SERIE  = '" + AllTrim((cAliasCT)->DT6_SERIE)  + "'"
		cQuery += "    AND NF.D_E_L_E_T_ =' '"

	ElseIf cSource == 'CFOP'

		cQuery := " SELECT SX5.X5_DESCRI" + CRLF
		cQuery += "   FROM " + RetSqlName("SX5") + " SX5 " + CRLF
		cQuery += "  WHERE SX5.X5_FILIAL  ='"  + xFilial("SX5") + "'" + CRLF
		cQuery += "    AND SX5.X5_TABELA  ='13'" + CRLF
		cQuery += "    AND SX5.X5_CHAVE   ='" + AllTrim((cAliasCT)->CFOP) + "'" + CRLF
		cQuery += "    AND SX5.D_E_L_E_T_ =' '"

	ElseIf cSource == 'ENDERECO'

		cQuery := " SELECT DTC.DTC_SQEDES, DTC.DTC_SELORI, DTC.DTC_FILORI, DTC.DTC_NUMSOL " + CRLF
		cQuery += "   FROM " + RetSqlName('DTC') + " DTC " + CRLF
		If !Empty((cAliasCT)->DT6_DOCDCO)
			cQuery += "   INNER JOIN " + RetSqlName('DT6') + " DT6 ON " + CRLF
			cQuery += "    DT6.DT6_FILIAL     = '" + xFilial("DT6") + "'" + CRLF
			cQuery += "    AND DT6.DT6_FILDOC = '" + (cAliasCT)->DT6_FILDCO + "'" + CRLF
			cQuery += "    AND DT6.DT6_DOC    = '" + (cAliasCT)->DT6_DOCDCO + "'" + CRLF
			cQuery += "    AND DT6.DT6_SERIE  = '" + (cAliasCT)->DT6_SERDCO + "'" + CRLF
			cQuery += "    AND DT6.D_E_L_E_T_ = ' '"
		EndIf

		cQuery += "  WHERE DTC.DTC_FILIAL = '" + xFilial('DTC') + "'" + CRLF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se o tipo de Conhecimento for de Complemento, seleciona as       ³
	//³ informacoes do CTR principal, pois o complemento nao tem DTC     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty((cAliasCT)->DT6_DOCDCO)
			cQuery += "    AND DTC.DTC_FILDOC = '" + (cAliasCT)->DT6_FILDCO + "'" + CRLF
			cQuery += "    AND DTC.DTC_DOC    = '" + (cAliasCT)->DT6_DOCDCO + "'" + CRLF
			cQuery += "    AND DTC.DTC_SERIE  = '" + (cAliasCT)->DT6_SERDCO + "'" + CRLF
			cQuery += "    AND DTC.DTC_SERVIC = DT6.DT6_SERVIC " +CRLF
			cQuery += "    AND DTC.DTC_LOTNFC = DT6.DT6_LOTNFC " +CRLF
		Else
			cQuery += "    AND DTC.DTC_FILDOC = '" + (cAliasCT)->DT6_FILDOC + "'" + CRLF
			cQuery += "    AND DTC.DTC_DOC    = '" + (cAliasCT)->DT6_DOC    + "'" + CRLF
			cQuery += "    AND DTC.DTC_SERIE  = '" + (cAliasCT)->DT6_SERIE  + "'" + CRLF
			cQuery += "    AND DTC.DTC_SERVIC = '" + (cAliasCT)->DT6_SERVIC + "'" + CRLF
			cQuery += "    AND DTC.DTC_LOTNFC = '" + (cAliasCT)->DT6_LOTNFC + "'" + CRLF
		EndIf
		cQuery += "    AND DTC.D_E_L_E_T_ = ' '"

	ElseIf cSource == 'PRODUTO_PREDOMINANTE'

		cQuery += " SELECT MAX(DTC.DTC_VALOR), " + CRLF
		cQuery += "       DTC.DTC_TIPNFC,   " + CRLF
		cQuery += "       DTC.DTC_CODOBS,   " + CRLF
		cQuery += "       DTC.DTC_CTRDPC,   " + CRLF
		cQuery += "       DTC.DTC_SERDPC,   " + CRLF
		cQuery += "       DTC.DTC_TIPANT,   " + CRLF
		cQuery += "       DTC.DTC_DPCEMI,   " + CRLF
		cQuery += "       DTC.DTC_CTEANT,   " + CRLF
		cQuery += "       DV3.DV3_INSCR,    " + CRLF
		cQuery += "       SB1.B1_DESC,      " + CRLF
		cQuery += "       SX5.X5_DESCRI     " + CRLF
		cQuery += "   FROM " + RetSqlName('DTC') + " DTC " + CRLF

		cQuery += "        INNER JOIN " + RetSqlName('SB1') + " SB1 " + CRLF
		cQuery += "               ON (SB1.B1_FILIAL = '" + xFilial("SB1") + "'"  + CRLF
		cQuery += "               AND SB1.B1_COD = DTC.DTC_CODPRO " + CRLF
		cQuery += "               AND SB1.D_E_L_E_T_ = ' ') " + CRLF

		cQuery += "        INNER JOIN " + RetSqlName("DB0") + " DB0 " + CRLF
		cQuery += "                ON DB0.DB0_FILIAL = '"   + xFilial("DB0") + "'" + CRLF
		cQuery += "               AND DB0.DB0_CODMOD = SB1.B1_TIPCAR " + CRLF
		cQuery += "               AND DB0.D_E_L_E_T_ = ' ' " + CRLF

		cQuery += "        INNER JOIN " + RetSqlName("SX5") + " SX5 " + CRLF
		cQuery += "                ON SX5.X5_FILIAL ='"  + xFilial("SX5") + "'" + CRLF
		cQuery += "               AND SX5.X5_TABELA ='DU'" + CRLF
		cQuery += "               AND SX5.X5_CHAVE  = DB0.DB0_TIPCAR " + CRLF
		cQuery += "               AND SX5.D_E_L_E_T_=' '"

		cQuery += "         LEFT JOIN " + RetSqlName('DV3') + " DV3 " + CRLF
		cQuery += "                ON (DV3.DV3_FILIAL = '" + xFilial("DV3") + "'"  + CRLF
		cQuery += "               AND DV3.DV3_CODCLI = DTC.DTC_CLIREM " + CRLF
		cQuery += "               AND DV3.DV3_LOJCLI = DTC.DTC_LOJREM " + CRLF
		cQuery += "               AND DV3.DV3_SEQUEN = DTC.DTC_SQIREM " + CRLF
		cQuery += "               AND DV3.D_E_L_E_T_ = ' ') " + CRLF

		cQuery += "  WHERE DTC.DTC_FILIAL = '" + xFilial('DTC') + "'"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se o tipo de Conhecimento for de Complemento, seleciona as      ³
	//³ informacoes do CTR principal, pois o complemento nao tem DTC    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty((cAliasCT)->DT6_DOCDCO)
			cQuery += " AND DTC.DTC_FILDOC   = '" + (cAliasCT)->DT6_FILDCO + "'" + CRLF
			cQuery += " AND DTC.DTC_DOC      = '" + (cAliasCT)->DT6_DOCDCO + "'" + CRLF
			cQuery += " AND DTC.DTC_SERIE    = '" + (cAliasCT)->DT6_SERDCO + "'" + CRLF
		Else
			cQuery += " AND DTC.DTC_FILDOC   = '" + (cAliasCT)->DT6_FILDOC + "'" + CRLF
			cQuery += " AND DTC.DTC_DOC      = '" + (cAliasCT)->DT6_DOC    + "'" + CRLF
			cQuery += " AND DTC.DTC_SERIE    = '" + (cAliasCT)->DT6_SERIE  + "'" + CRLF
		EndIf

		cQuery += " AND DTC.D_E_L_E_T_   = ' '" + CRLF
		cQuery += " GROUP BY DV3.DV3_INSCR, DTC.DTC_TIPNFC, DTC.DTC_CODOBS, DTC.DTC_CTRDPC, DTC.DTC_SERDPC, DTC.DTC_TIPANT, " + CRLF
		cQuery += "          DTC.DTC_DPCEMI, DTC.DTC_CTEANT, SB1.B1_DESC, SX5.X5_DESCRI " + CRLF
		cQuery += " ORDER BY MAX(DTC.DTC_VALOR) DESC" + CRLF

	ElseIf cSource == 'DOCUMENTOS_ORIGINARIOS'

		cQuery += " SELECT DTC.DTC_SERNFC, "
		cQuery += "   DTC.DTC_NUMNFC, "
		cQuery += "   DTC.DTC_EMINFC, "
		cQuery += "   DTC.DTC_VALOR, "
		cQuery += "   DTC.DTC_PESO, "
		cQuery += "   DTC.DTC_CLIDEV, "
		cQuery += "   DTC.DTC_LOJDEV, "
		cQuery += "   DTC.DTC_NFEID "
		cQuery += " FROM " + RetSqlName('DTC') + " DTC "
		cQuery += " WHERE "
		cQuery += "   DTC.DTC_FILIAL   = '" + xFilial("DTC") + "'"
		If !Empty((cAliasCT)->DT6_DOCDCO)
			cQuery += " AND DTC.DTC_FILDOC = '" + (cAliasCT)->DT6_FILDCO + "'" + CRLF
			cQuery += " AND DTC.DTC_DOC    = '" + (cAliasCT)->DT6_DOCDCO + "'" + CRLF
			cQuery += " AND DTC.DTC_SERIE  = '" + (cAliasCT)->DT6_SERDCO + "'" + CRLF
		Else
			cQuery += " AND DTC.DTC_FILDOC = '" + (cAliasCT)->DT6_FILDOC + "'" + CRLF
			cQuery += " AND DTC.DTC_DOC    = '" + (cAliasCT)->DT6_DOC    + "'" + CRLF
			cQuery += " AND DTC.DTC_SERIE  = '" + (cAliasCT)->DT6_SERIE  + "'" + CRLF
		EndIf
		cQuery += " AND DTC.D_E_L_E_T_   =' '"

	ElseIf cSource == 'VEICULOS_DA_LOTACAO'

		//cQuery    := " SELECT DTR_CODVEI, DTR_CODRB1, DTR_CODRB2 "
		cQuery    := " SELECT DTR_CODVEI, DTR_CODRB1, DTR_CODRB2, DTR_TCIOT "  
		cQuery    += " FROM " + RetSqlName("DTR")+" DTR "
		cQuery    += " WHERE DTR_FILIAL = '"+xFilial('DTR')+"'"
		cQuery    += "   AND DTR_FILORI = '"+(cAliasCT)->DT6_FILORI+"'"
		cQuery    += "   AND DTR_VIAGEM = '"+cViagem+"'"
		cQuery    += "   AND D_E_L_E_T_ = ' '"

	ElseIf cSource == 'CLIENTE_DEVEDOR'

		cQuery := " SELECT DT6.DT6_CLIDEV, DT6.DT6_LOJDEV "
		cQuery += " FROM " + RetSqlName('DT6') + " DT6 "
		cQuery += " WHERE DT6_FILIAL      = '" + xFilial("DT6")  + "'" + CRLF
		cQuery += "    AND DT6.DT6_FILORI = '" + DTP->DTP_FILORI + "'" + CRLF
		cQuery += "    AND DT6.DT6_LOTNFC = '" + DTP->DTP_LOTNFC + "'" + CRLF
		cQuery += "    AND D_E_L_E_T_     = '' "
		cQuery += " GROUP BY DT6.DT6_CLIDEV, DT6.DT6_LOJDEV " + CRLF

	ElseIf cSource == 'DA3'

		cQuery += " SELECT DA3_COD, DA3_PLACA, DA3_RENAVA, DA3_TARA, DA3_CAPACM, DA3_FROVEI, " + CRLF
		cQuery += "   DA3_ESTPLA, DA3_CODFOR, DA3_LOJFOR, DUT_DESCRI,DUT_TIPROD, DUT_TIPCAR, " + CRLF
		cQuery += "   DA3_ALTINT, DA3_LARINT, DA3_COMINT,DA3_DESC " + CRLF
		cQuery += "   A2_CGC, A2_NOME, A2_INSCR, A2_EST, A2_TIPO, A2_RNTRC, " + CRLF 
		cQuery += "   A2_BANCO  , A2_NOMEBCO, A2_AGENCIA, A2_NUMCON  " + CRLF 
		cQuery += " FROM " + RetSqlName("DA3") + " DA3 " + CRLF
		cQuery += "   INNER JOIN " + RetSqlName("DUT") + " DUT " + CRLF
		cQuery += "   ON DUT.DUT_TIPVEI = DA3.DA3_TIPVEI " + CRLF
		cQuery += "   AND DUT.D_E_L_E_T_ = ' ' " + CRLF
		cQuery += "   INNER JOIN " + RetSqlName("SA2") + " SA2 ON " + CRLF
		cQuery += "   SA2.A2_COD = DA3.DA3_CODFOR AND " + CRLF
		cQuery += "   SA2.A2_LOJA   = DA3.DA3_LOJFOR AND " + CRLF
		cQuery += "   SA2.D_E_L_E_T_= '' " + CRLF
		cQuery += " WHERE DA3.DA3_FILIAL = '"+xFilial("DA3")+"'" + CRLF
		cQuery += "   AND DA3.DA3_COD    = '"+cCodVei+"'" + CRLF
		cQuery += "   AND DA3.D_E_L_E_T_ = ' '" + CRLF
		cQuery += "   AND DUT.DUT_FILIAL = '"+xFilial('DUT')+"'" + CRLF
		cQuery += "   AND SA2.A2_FILIAL  = '"+xFilial('SA2')+"'" + CRLF

	ElseIf cSource == 'DVB'

		cQuery := " SELECT DVB_LACRE "
		cQuery += " FROM " + RetSqlName("DVB") + " DVB " + CRLF
		cQuery += " WHERE DVB_FILIAL = '" + xFilial("DVB") + "' AND " + CRLF
		cQuery += "   DVB_FILORI = '" + (cAliasCT)->DT6_FILORI + "' AND " + CRLF
		cQuery += "   DVB_VIAGEM = '" + cViagem + "' AND " + CRLF
		cQuery += "   DVB.D_E_L_E_T_ = '' " + CRLF

	ElseIf cSource == 'IMPOSTOS'

		cQuery := " SELECT SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS, " + CRLF
		cQuery += "        MAX(SFT.FT_ALIQICM) FT_ALIQICM, " + CRLF
		cQuery += "        MAX(SFT.FT_ALIQSOL) FT_ALIQSOL, " + CRLF
		cQuery += "        SUM(SFT.FT_BASEICM) FT_BASEICM, " + CRLF
		cQuery += "        SUM(SFT.FT_BASERET) FT_BASERET, " + CRLF
		cQuery += "        SUM(SFT.FT_CRPRST) FT_CRPRST, " + CRLF
		cQuery += "        SUM(SFT.FT_VALICM) FT_VALICM,   " + CRLF
		cQuery += "        SUM(SFT.FT_ICMSRET) FT_ICMSRET  " + CRLF
		cQuery += "  FROM " + RetSqlName('SFT') + " SFT  "   + CRLF
		cQuery += "  WHERE SFT.FT_FILIAL  = '" + xFilial('SFT') + "'" + CRLF
		cQuery += "    AND SFT.FT_NFISCAL = '" + (cAliasCT)->F3_NFISCAL + "'" + CRLF
		cQuery += "    AND SFT.FT_SERIE   = '" + (cAliasCT)->F3_SERIE   + "'" + CRLF
		cQuery += "    AND SFT.FT_CLIEFOR = '" + (cAliasCT)->F3_CLIEFOR + "'" + CRLF
		cQuery += "    AND SFT.FT_LOJA    = '" + (cAliasCT)->F3_LOJA    + "'" + CRLF
		cQuery += "    AND SFT.D_E_L_E_T_ = ' '" + CRLF
		cQuery += "  GROUP BY SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS "

	ElseIf cSource == 'DESCRSUBSTTRIBUTARIA'

		cQuery := " SELECT SX5.X5_DESCRI"
		cQuery += " FROM " + RetSqlName("SX5") + " SX5 "
		cQuery += " WHERE SX5.X5_FILIAL ='"  + xFilial("SX5") + "'"
		cQuery += "   AND SX5.X5_TABELA ='S2'"

		If !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT")=="U"
			cSitTriba := Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT")=="U"," ",;
				oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT)
		ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT")=="U"
			cSitTriba := Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT")=="U"," ",;
				oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT)
		ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT")=="U"
			cSitTriba := Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT")=="U"," ",;
				oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT)
		ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT")=="U"
			cSitTriba := Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT")=="U"," ",;
				oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT)
		ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT")=="U"
			cSitTriba := Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT")=="U"," ",;
				oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT)
		ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_CST:TEXT")=="U"
			cSitTriba := Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_CST:TEXT")=="U"," ",;
				oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOutraUF:_CST:TEXT)
		EndIf

		cQuery += " AND SX5.X5_CHAVE  ='" + Iif(lXml, cSitTriba+ "'", SUBSTR((cAliasImp)->FT_CLASFIS,2,2) + "'")
		cQuery += " AND SX5.D_E_L_E_T_<>'*'"

	ElseIf cSource == "SOLICITANTE"
		cQuery := " SELECT DUE.DUE_CGC, DUE.DUE_NOME, DUE.DUE_END, DUE.DUE_BAIRRO, "
		cQuery += "        DUE.DUE_CODMUN, DUE.DUE_MUN, DUE.DUE_EST, "
		cQuery += "        DUL.DUL_CODMUN, DUL.DUL_MUN, DUL.DUL_EST, "
		cQuery += "        DUL.DUL_END, DUL.DUL_BAIRRO "
		cQuery += "  FROM " + RetSQLName("DT5") + " DT5 "
		cQuery += "  JOIN " + RetSQLName("DUE") + " DUE "
		cQuery += "    ON DUE_FILIAL = '" + xFilial("DUE") + "' "
		cQuery += "    AND DUE_DDD   = DT5_DDD  "
		cQuery += "    AND DUE_TEL   = DT5_TEL  "
		cQuery += "    AND DUE.D_E_L_E_T_ = ' ' "
		cQuery += "  LEFT JOIN " + RetSQLName("DUL") + " DUL "
		cQuery += "    ON DUL_FILIAL = '" + xFilial("DUL") + "' "
		cQuery += "    AND DUL_DDD    = DT5_DDD "
		cQuery += "    AND DUL_TEL    = DT5_TEL "
		cQuery += "    AND DUL_SEQEND = DT5_SEQEND "
		cQuery += "    AND DUL.D_E_L_E_T_ = ' ' "
		cQuery += "  WHERE DT5_FILIAL = '" + xFilial("DT5") + "' "
		cQuery += "    AND DT5_FILORI = '" + (cAliasTagE)->DTC_FILORI + "' "
		cQuery += "    AND DT5_NUMSOL = '" + (cAliasTagE)->DTC_NUMSOL + "' "
		cQuery += "    AND DT5.D_E_L_E_T_ = ' ' "

	ElseIf cSource == "PRODUTOS_PERIGOSOS"

		cQuery := " SELECT DTC.DTC_PESO, DY3.DY3_ONU, DY3.DY3_DESCRI, DY3.DY3_GRPEMB, DY3.DY3_CLASSE, DY3.DY3_NRISCO "
		cQuery += " FROM " + RetSqlName("DTC") + " DTC , " + RetSqlName("SB5") + " SB5 , " + RetSqlName("DY3") + " DY3 "
		cQuery += " WHERE DTC.DTC_FILIAL   = '"  + xFilial("DT6") + "' "
		cQuery += " AND DTC.DTC_FILDOC = '" + (cAliasCT)->DT6_FILDOC + "'"
		cQuery += " AND DTC.DTC_DOC = '" + (cAliasCT)->DT6_DOC + "'"
		cQuery += " AND DTC.DTC_SERIE = '" + (cAliasCT)->DT6_SERIE + "'"
		cQuery += " AND SB5.B5_CARPER = '1' " //-- Carga Perigosa
		cQuery += " AND DTC.DTC_CODPRO = SB5.B5_COD"
		cQuery += " AND DY3.DY3_ONU = SB5.B5_ONU "
		cQuery += " AND DY3.DY3_ITEM = SB5.B5_ITEM "
		cQuery += " AND DTC.D_E_L_E_T_ = ' '"
		cQuery += " AND SB5.D_E_L_E_T_ = ' '"
		cQuery += " AND DY3.D_E_L_E_T_ = ' '"

	ElseIf cSource == "DADOS_SEGURADORA1"

	//-- Valida se existe Responsavel pelo seguro
		aResp := TMSAvbCli(	(cAliasCT)->DT6_CLIDEV, (cAliasCT)->DT6_LOJDEV, '', ;
			(cAliasCT)->DT6_CLIREM, (cAliasCT)->DT6_LOJREM,     ;
			(cAliasCT)->DT6_CLIDES, (cAliasCT)->DT6_LOJDES, .F. )
		If !Empty(aResp) .And. lForApol //-- Cliente Responsavel pelo Seguro
			cQuery := "SELECT  SA2.A2_NOME, DV6.DV6_APOL "
			cQuery += " FROM  " + RetSqlName("DV6") + " DV6 "
		//-- Averbacao Seguro por Cliente (DV6)
			cQuery += " JOIN " + RetSqlName("SA2") + " SA2 "
			cQuery += " ON DV6.DV6_CLIDEV  = '" + aResp[1]       + "'"
			cQuery += " AND DV6.DV6_LOJDEV = '" + aResp[2]       + "'"
			cQuery += " AND DV6.DV6_FILIAL = '" + xFilial("DV6") + "'"
			cQuery += " AND DV6.D_E_L_E_T_ = ' '"
			cQuery += " AND SA2.A2_FILIAL  = '" + xFilial("SA2") + "'"
			cQuery += " AND SA2.A2_COD     = DV6.DV6_CODSEG"
			cQuery += " AND SA2.A2_LOJA    = DV6.DV6_LOJSEG"
			cQuery += " AND SA2.D_E_L_E_T_ = ' '"
		EndIf

	ElseIf cSource == "DADOS_SEGURADORA2"
		cQuery := "SELECT  SA2.A2_NOME, SA2.A2_APOLICE"
		cQuery += " FROM  " + RetSqlName("SA2") + " SA2 "
		cQuery += " WHERE A2_COD = '" + Substr(cForSeg,1,nTamCod) + "'"
		cQuery += " AND A2_LOJA  = '" + Substr(cForSeg,nTamCod+1,nTamLoj) + "'"
		cQuery += " AND SA2.A2_FILIAL  = '" + xFilial("SA2") + "'"
		cQuery += " AND SA2.D_E_L_E_T_ = ' '"
	
	ElseIf cSource == "DOCUMENTO_DE_APOIO"

		cQuery := " SELECT DTC.DTC_SERNFC, "
		cQuery += "   DTC.DTC_NUMNFC, "
		cQuery += "   DTC.DTC_EMINFC, "
		cQuery += "   DTC.DTC_VALOR, "
		cQuery += "   DTC.DTC_PESO, "
		cQuery += "   DTC.DTC_CLIDEV, "
		cQuery += "   DTC.DTC_LOJDEV, "
		cQuery += "   DTC.DTC_NFEID "
	
		cQuery += "   FROM " + RetSqlName("DTC") + " DTC "

		cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 "
		cQuery += "   ON DT6.DT6_CLIDEV   = '" + (cAliasCT)->DT6_CLIDEV + "'"
		cQuery += "  AND DT6.DT6_LOJDEV   = '" + (cAliasCT)->DT6_LOJDEV + "'"
		cQuery += "  AND DT6.DT6_PREFIX   = '" + (cAliasCT)->DT6_PREFIX + "'"
		cQuery += "  AND DT6.DT6_NUM      = '" + (cAliasCT)->DT6_NUM    + "'"
		cQuery += "  AND DT6.DT6_TIPO     = '" + (cAliasCT)->DT6_TIPO   + "'"
		cQuery += "  AND DT6.DT6_DOCTMS IN('B','C','H','I','N','O') "
		cQuery += "  AND DT6.D_E_L_E_T_   = ' '"

		cQuery += " WHERE DTC.DTC_FILIAL = '" + xFilial('DTC') + "'"
		cQuery += "  AND DTC.DTC_FILDOC   = DT6.DT6_FILDOC "
		cQuery += "  AND DTC.DTC_DOC      = DT6.DT6_DOC    "
		cQuery += "  AND DTC.DTC_SERIE    = DT6.DT6_SERIE  "
		cQuery += "  AND DTC.D_E_L_E_T_   = ' '"
						
	EndIf

	cQuery := ChangeQuery( cQuery )

Return ( cQuery )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMSR620   ºAutor  ³Igor Franzoi           º Data ³24/10/2013º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetObsCtr(cFilOri,cNumCtr,cSerCtr)
	Local cObs	:=	""
	Local cAliasObs	:=	GetNextAlias()

	BeginSql Alias	cAliasObs

		%NoParser%

		Select
		DTQ_VIAGEM
		From
		%Table:DTQ%
		Where
		%NotDel%				And
		DTQ_FILORI	=	%Exp:cFilOri%	And
		DTQ_NUMCTR	=	%Exp:cNumCtr%	And
		DTQ_SERCTR	=	%Exp:cSerCtr%
    	
	
	EndSql

	cObs	:=	Posicione("DTQ",1,xFilial("DTQ")+(cAliasObs)->DTQ_VIAGEM,"DTQ_OBSCTR")

	(cAliasObs)->(dbCloseArea())

Return(cObs)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMSR620   ºAutor  ³Igor Franzoi        º Data ³  10/09/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetSegInfo()

	Local aRet
	Local cQuery
	Local cAliasSeg
	Local cAliasDT6
	Local cRespSeg	:=	''
	Local cNomSeg	:=	''
	Local cApolice	:=	''
	Local cNumAvb	:=	''

	cAliasDT6	:=	GetNextAlias()
	cQuery := "	Select "+	CRLF
	cQuery += "		DT6_CLIDEV, "+	CRLF
	cQuery += "		DT6_LOJDEV, "+	CRLF
	cQuery += "		DT6_CLIREM, "+	CRLF
	cQuery += "		DT6_LOJREM, "+	CRLF
	cQuery += "		DT6_CLIDES, "+	CRLF
	cQuery += "		DT6_LOJDES  "+	CRLF
	cQuery += "From "  +	CRLF
	cQuery += "		"+RetSqlName("DT6") + " DT6 "+	CRLF
	cQuery += "Where "+	CRLF
	cQuery += "		D_E_L_E_T_ 	= '' 					And "+	CRLF
	cQuery += "		DT6_FILDOC 	= '"+SF2->F2_FILIAL	+"'	And"+	CRLF
	cQuery += "		DT6_DOC 	= '"+SF2->F2_DOC	+"'	And"+	CRLF
	cQuery += "		DT6_SERIE 	= '"+SF2->F2_SERIE	+"'"+	CRLF
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasDT6, .F., .T.)

	cAliasSeg := GetNextAlias()
	cQuery := " SELECT DV6.DV6_NUMAVB, DV7.DV7_PAGSEG, DV7.DV7_PERAVB,DV6.DV6_NOMSEG,DV6.DV6_APOL "	+	CRLF
	cQuery += "   FROM " + RetSqlName("DV6") + " DV6 "+	CRLF
	cQuery += "   JOIN " + RetSqlName("DV7") + " DV7 "+	CRLF
	cQuery += "     ON  DV6.DV6_FILIAL = '" + xFilial("DV6") + "' "+	CRLF
	cQuery += "     AND DV6.DV6_CLIDEV = '" + (cAliasDT6)->DT6_CLIDEV + "' "+	CRLF
	cQuery += "     AND DV6.DV6_LOJDEV = '" + (cAliasDT6)->DT6_LOJDEV + "' "+	CRLF
	cQuery += "     AND DV6.DV6_INIVIG <= '" + DToS(dDataBase) + "' "+	CRLF
	cQuery += "     AND ( DV6.DV6_FIMVIG  = ' ' OR DV6.DV6_FIMVIG >= '" + DToS(dDataBase) + "' )"+	CRLF
	cQuery += "     AND DV6.D_E_L_E_T_ = ' ' "+	CRLF
	cQuery += "     AND DV7.DV7_FILIAL = '" + xFilial("DV7") + "' "+	CRLF
	cQuery += "     AND DV7.DV7_NUMAVB = DV6.DV6_NUMAVB "+	CRLF
	cQuery += "     AND ( DV7.DV7_CLIREM = ' ' OR DV7.DV7_CLIREM = '" + (cAliasDT6)->DT6_CLIREM + "' ) "+	CRLF
	cQuery += "     AND ( DV7.DV7_LOJREM = ' ' OR DV7.DV7_LOJREM = '" + (cAliasDT6)->DT6_LOJREM + "' ) "+	CRLF
	cQuery += "     AND ( DV7.DV7_CLIDES = ' ' OR DV7.DV7_CLIDES = '" + (cAliasDT6)->DT6_CLIDES + "' ) "+	CRLF
	cQuery += "     AND ( DV7.DV7_LOJDES = ' ' OR DV7.DV7_LOJDES = '" + (cAliasDT6)->DT6_LOJDES + "' ) "+	CRLF
	cQuery += "     AND ( DV7.DV7_ESTDES = ' ' OR DV7.DV7_ESTDES = '" + Posicione("SA1",1,xFilial('SA1')+(cAliasDT6)->DT6_CLIDES+(cAliasDT6)->DT6_LOJDES ,"A1_EST") + "' ) "+	CRLF
	cQuery += "     AND DV7.D_E_L_E_T_ = ' ' "+	CRLF
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasSeg, .F., .T.)
    
	If !Eof()
		If 		(cAliasSeg)->DV7_PAGSEG == StrZero( 1, Len( DV7->DV7_PAGSEG ) ) //-- Remetente
			cRespSeg  := 'Remetente'
		ElseIf 	(cAliasSeg)->DV7_PAGSEG == StrZero( 2, Len( DV7->DV7_PAGSEG ) ) //-- Destinatario
			cRespSeg  := 'Destinatario'
		ElseIf 	(cAliasSeg)->DV7_PAGSEG == StrZero( 3, Len( DV7->DV7_PAGSEG ) ) //-- Devedor
			cRespSeg  := 'Tomador de Servico'
		ElseIf 	(cAliasSeg)->DV7_PAGSEG == StrZero( 4, Len( DV7->DV7_PAGSEG ) ) //-- Devedor
			cRespSeg  := 'Expedidor'
		ElseIf 	(cAliasSeg)->DV7_PAGSEG == StrZero( 5, Len( DV7->DV7_PAGSEG ) ) //-- Devedor
			cRespSeg  := 'Recebedor'
		ElseIf 	(cAliasSeg)->DV7_PAGSEG == StrZero( 6, Len( DV7->DV7_PAGSEG ) ) //-- Devedor
			cRespSeg  := 'Emitente do CT-e'
		EndIf
	EndIf

	cNomSeg  	:= (cAliasSeg)->DV6_NOMSEG
	cApolice  	:= (cAliasSeg)->DV6_APOL
	cNumAvb  	:= (cAliasSeg)->DV6_NUMAVB

Return({cRespSeg,cApolice,cNumAvb,cNomSeg})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR25   ºAutor  ³Igor Franzoi        º Data ³  10/09/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function xTabela(cTab,cKey)

	Local cRet	:=	''

	DbSelectArea('SX5')
	If DbSeek(xFilial('SX5') + cTab + cKey)
		cRet := AllTrim(X5Descri())
	EndIf

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR25   ºAutor  ³Igor Franzoi        º Data ³  10/09/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetInfoDocs(aDocOri)

	Local nCount
	Local cAlias
	Local cChave

	For nCount := 1 To Len(aDocOri)

		If !Empty(AllTrim(aDocOri[nCount][doDTC_NFEID]))
		
			cAlias	:=	GetNextAlias()
		
			cChave	:=	AllTrim(aDocOri[nCount][doDTC_NFEID])
				
			BeginSql Alias cAlias
				Select
				DTC_NUMNFC,
				DTC_SERNFC
				From
				%Table:DTC%
				Where
				%NotDel%			And
				DTC_NFEID	=	%Exp:cChave%
			EndSql
				
			aDocOri[nCount][doDTC_SERNFC]	:=	(cAlias)->DTC_SERNFC
			aDocOri[nCount][doDTC_NUMNFC]	:=	(cAlias)->DTC_NUMNFC
		
			(cAlias)->(dbCloseArea())
		 		
		EndIf
	
	Next nCount

Return
                         

Static Function GetCompl()
	Local aArea		:= GetArea()
	Local aAreaDTQ	:= DTQ->(GetArea())      
	Local aRet		:= {}
	Local nValTot	:= 0
	Local nValServ	:= 0
	Local nValDilui := 0//Valor diluido ICMS e Advalorem
	
	DbSelectArea("DTQ")
	DbSetOrder()
	DbOrderNickName("XCTR")
	If DbSeek(xFilial("DTQ")+cDoc+cSerie)		
		If DTQ->DTQ_VRESTA > 0
			Aadd(aRet,{"ESTADIA",DTQ->DTQ_VRESTA})
		EndIf
		If DTQ->DTQ_CARDES > 0 
			Aadd(aRet,{"CARGA/DESCARGA",DTQ->DTQ_CARDES})
		EndIf
		If DTQ->DTQ_VRESCO > 0
			Aadd(aRet,{"ESCOLTA",DTQ->DTQ_VRESCO})
		EndIf
		If DTQ->DTQ_VRPEDA > 0
			Aadd(aRet,{"PEDAGIO",DTQ->DTQ_VRPEDA})
		EndIf                                                        
		If DTQ->DTQ_XFRETE > 0
			Aadd(aRet,{"FRETE",DTQ->DTQ_XFRETE})
		EndIf                            
		If DTQ->DTQ_VALICM > 0
			Aadd(aRet,{"ICMS",DTQ->DTQ_VALICM})
		EndIf                            
		
		
		nValServ	:= DTQ->(DTQ_VRESTA+DTQ_CARDES+DTQ_VRESCO+DTQ_VRPEDA+DTQ_XFRETE)
		nValTot 	:= DTQ->DTQ_TOTFRE//+DTQ->DTQ_VALADV
		
		nValDilui	:= nValTot-nValServ
		
		nValDilui 	:= nValDilui/Len(aRet)
		
		//Dilui Icms entre os componentes
		/*For nX := 1 To Len(aRet)
			aRet[nX,2] += nValDilui
		Next nX*/
		  
		//Seguro não dilui
		If DTQ->DTQ_VALADV > 0
			Aadd(aRet,{"SEGURO",DTQ->DTQ_VALADV})
		EndIf
	EndIf
                         
	RestArea(aAreaDTQ)
	RestArea(aArea)
Return(aRet)
                       
//Alison 18/07/14 - Atualiza DT6_IDRCTE, este é verificado na emissão do CC-e para CT-e
Static Function AtuDT6(cIndice)                                                               
	Local aArea		:= GetArea()      
	Local aAreaDT6	:= DT6->(GetArea())
                  
	DbSelectArea("DT6")
	DbSetOrder(1)//FilDoc+Doc+Serie
	If DbSeek(xFilial("DT6")+cIndice)	                               
		RecLock("DT6",.F.)
		DT6->DT6_IDRCTE	:= "100"
		MsUnlock()                                
	EndIf	                                       
	RestArea(aAreaDT6)
	RestArea(aArea)
Return