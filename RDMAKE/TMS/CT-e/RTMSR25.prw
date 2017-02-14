#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "topconn.ch"

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
±±³Programa  ³RTMSR25   ³ Autor ³Adalberto SM           ³ Data ³09/02/09  ³±±
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
User Function RTMSR25()
Local nCount		:= 0
Local cLabel		:= ""
Local nSoma			:= 0
Local nCInic		:= 0	// Coluna Inicial
Local cChaveA		:= ''
Local cChaveB		:= ''
Local cTmsAntt		:= SuperGetMv( "MV_TMSANTT", .F., .F. )	//Numero do registro na ANTT com 14 dÃ­gitos
Local cAliasD2		:= ''
Local cAliasDev		:= ''
Local aCab			:= {}
Local aDoc			:= {}
Local oFont08		:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
Local oFont08N		:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local oFont10N		:= TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
Local lControl		:= .F.
Local cAliasInfNF	:= ''
Local cAliasSeg		:= ''
Local cPerg			:= 'RTMSR25'
Local nCont			:= 0
Local lSeqDes		:= .F.
Local cDT6Obs		:= ''
Local cDT6Obs2		:= ''
Local cDTCObs		:= ''
Local cDTCObs2		:= ''
Local cTipoNF		:= ''
Local cCtrDpc		:= ''
Local cSerDpc		:= ''
Local cTpDocAnt		:= ''
Local cCTEDocAnt	:= ''
//-- Buscar dados XML
Local aNotas		:= {}
Local aXML			:= {}
Local cAviso		:= ""
Local cErro			:= ""
Local cAutoriza		:= ""
Local cModalidade	:= ""
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
Local nPerig		:= 0	//-- Contador de linhas Produtos Perigosos
Local nModPerig		:= 0	//-- Resto da divisao do numero de linhas de produtos perigosos
Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local lOk			:= .T.
Local cForSeg		:= SuperGetMv("MV_FORSEG",,"")
Local lForApol		:= SA2->(FieldPos('A2_APOLICE')) > 0
Local nTamCod		:= Len(SA2->A2_COD)
Local nTamLoj		:= Len(SA2->A2_LOJA)
Local aResp			:= {}                 

Local	cCCGefco		:= ""
Local	cCCPSA		:= ""
Local	cContaPSA	:= ""
Local	cOIPSA		:= ""
Local	cRefGefco	:= ""

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
Private lAgdEntr  := SuperGetMv( "MV_AGDENTR", .F., .F. )	//-- Parametro do Agendamento de Entrega.

Private  _cCliMAN  := AllTrim(GETNewPar("MV_XCTEMAN","04858701|"))

AjustaSX1()

//-- MV_PAR01 - Informe lote inicial.
//-- MV_PAR02 - Informe lote final.
//-- MV_PAR03 - Informe documento inicial.
//-- MV_PAR04 - Informe documento final.
//-- MV_PAR05 - Informe serie do documento inicial.
//-- MV_PAR06 - Informe serie do documento final.
//-- MV_PAR07 - Informe tipo do documento.
//-- MV_PAR08 - Buscar XML do WebService.
//-- MV_PAR09 - Tipo de Operacao
If !Pergunte(cPerg,.T.)
	Return()
EndIf

//-- Buscar XML do WebService
lXml := MV_PAR08 == 1

If	!TMSSpedNFe(@cIdEnt,@cModalidade,@cVersaoCTE)
	Return()
EndIf

//Se for contingencia nao busca do XML
If cModalidade == '7-Contingência FS-DA' .And. cVersaoCTE == '1.04'
	lXml = .F.
EndIf

// Cria Arquivo de Trabalho - Documentos de Transporte
If MV_PAR09 == 1
	cAliasCT := DataSource( 'SF1' ) // 1 - Saida: Anulacao
	lXml := .T.
Else
	cAliasCT := DataSource( 'DT6' ) // 2 - Entrada
EndIf

oDacte := TMSPrinter():New("DACTE - Documento Auxiliar do Conhecimento Eletrônico")
oDacte:SetPortrait()

PixelX  := oDacte:nLogPixelX()
PixelY  := oDacte:nLogPixelY()
nMM     := 0

While !(cAliasCT)->(Eof())

	oDacte:StartPage()
	oDacte:SetPaperSize(Val(GetProfString(GetPrinterSession(),"PAPERSIZE","1",.T.)))
	cLacre := ""

	//-- Buscar XML do WebService
	If lXml
		aNotas := {}
		aadd(aNotas,{})
		aAdd(Atail(aNotas),.F.)

		aadd(Atail(aNotas),IIF(MV_PAR09==1,"E","S"))
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
			Else
				cAutoriza   := ""
				cCodAutDPEC := ""
			EndIf
			cAviso := ""
			cErro  := ""
			oNfe := XmlParser(aXML[nX][2],"_",@cAviso,@cErro)
			oNfeDPEC := XmlParser(aXML[nX][4],"_",@cAviso,@cErro)
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
					EndIf
				EndIf
			EndIf
		EndIf
		cProCte := (cAliasCT)->DT6_PROCTE
		If Empty(cProCte)
			//-- Esce. WS para retornar protocolo
			oWS:= WSNFeSBRA():New()
			oWS:cUSERTOKEN    := "TOTVS"
			oWS:cID_ENT       := cIdEnt 
			oWS:_URL          := AllTrim(cURL)+"/NFeSBRA.apw"
			oWS:cIdInicial    := (cAliasCT)->DT6_SERIE+(cAliasCT)->DT6_DOC
			oWS:cIdFinal      := (cAliasCT)->DT6_SERIE+(cAliasCT)->DT6_DOC
			lOk := oWS:MONITORFAIXA()
			oRetorno := oWS:oWsMonitorFaixaResult
			For nCount := 1 To Len(oRetorno:oWSMONITORNFE)
				cProCte := oRetorno:OWSMONITORNFE[nCount]:CPROTOCOLO
			Next nCount
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona a qtde de registros, p/ calcular a qtde de folhas            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAliasPerig := DataSource("PRODUTOS_PERIGOSOS")
	While (cAliasPerig)->(!EoF())
		If Len((cAliasPerig)->DY3_DESCRI) <= 50
			nPerig += 1
		ElseIf Len((cAliasPerig)->DY3_DESCRI) > 50 .And. Len((cAliasPerig)->DY3_DESCRI) <= 100
			nPerig += 2
		ElseIf Len((cAliasPerig)->DY3_DESCRI) > 100
			nPerig += 3
		EndIf
		(cAliasPerig)->( DBSKIP())	
	EndDo

	nModPerig := (nPerig / 24) - (Int(nPerig / 24))			//-- Utilizado este calculo pois a funcao MOD com falha
	nPerig    := Int(nPerig / 24) + IIF (nModPerig > 0,2,0)	//-- Soma 2, para considerar a primeira pagina
	
	cAliasInfNF := DataSource( 'DTC' )
	If (cAliasInfNF)->nTotal > 0
		If ((cAliasInfNF)->nTotal <= 8) .And. nPerig == 0
			nFolhas := 1
		Else
			nFolhas := ((cAliasInfNF)->nTotal - 8)	//-- Qtde da primeira paginas.
			nFolhas := Int(( nFolhas / 74 ) + 2)	//-- Qtde da outras paginas.
			If (nFolhas) < nPerig					//-- Caso numero de produtos perigosos ultrapasse a qtd ja existente de folhas
				nFolhas := nPerig
			Endif
		EndIf
	EndIf
	(cAliasInfNF)->(DbCloseArea())
	
	If Type( 'oNFE' ) == 'U'
		If	MV_PAR09 == 1
			Return()
		Else
			lXML := .F. //restricao de errorlog devido ao xml retornado
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Controla o documento a ser enviado para montagem do cabecalho.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nCont += 1
	If lXML
		aAdd(aCab, {;
		AllTrim((cAliasCT)->DT6_DOC),;
		AllTrim(oNfe:_CTE:_INFCTE:_IDE:_SERIE:TEXT),;
		AllTrim(STRTRAN( SUBSTR( oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT, 1, AT('T', oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT) - 1) , '-', '')),;
		AllTrim(STRTRAN( SUBSTR( oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT, AT('T', oNfe:_CTE:_INFCTE:_IDE:_dhEmi:TEXT) + 1, 5) , ':', '')),;
		AllTrim(STRTRAN(UPPER(oNFE:_CTE:_INFCTE:_ID:TEXT),'CTE','')),;
		cProCte, "" })	//-- Nao possui ref. no XML
	Else
		aAdd(aCab, {;
		AllTrim((cAliasCT)->DT6_DOC),;
		AllTrim((cAliasCT)->DT6_SERIE),;
		AllTrim((cAliasCT)->DT6_DATEMI),;
		AllTrim((cAliasCT)->DT6_HOREMI),;
		AllTrim((cAliasCT)->DT6_CHVCTE),;
				(cAliasCT)->DT6_PROCTE,;
		AllTrim((cAliasCT)->DT6_CHVCTG)})
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Funcao responsavel por montar o cabecalho do relatorio                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nFolhAtu := 1
	lSeqDes  :=.F.
	TMSR25Cab(aCab[nCont])

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
		cOriMunPre := (cAliasCT)->REM_MUNICI
		cOriUFPre  := (cAliasCT)->REM_UF

		//-- Destino da Prestacao
		cDesMunPre := (cAliasCT)->DES_MUNICI
		cDesUFPre  := (cAliasCT)->DES_UF

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

		cPPDesc		:= (cAliasInfNF)->B1_DESC
		cPPCarga		:= (cAliasInfNF)->X5_DESCRI
		cPPVlTot		:= STR( (cAliasCT)->DT6_VALMER )

		If (cAliasCT)->DT6_DOCTMS == "8"  //CTRC Complementar
			cDTCObs		:= MsMM((cAliasCT)->DT6_CODOBS)
		Else
			cDTCObs		:= MsMM((cAliasInfNF)->DTC_CODOBS,80)
		EndIf
		cDTCOBS			:= StrTran(cDTCObs, Chr(10)," ")
		cDTCOBS			:= StrTran(cDTCObs, Chr(13)," ")

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

		If	!AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 8, Len(DT6->DT6_DOCTMS)) .And.;
			!AllTrim((cAliasCT)->DT6_DOCTMS) == "M"
			//-- Dados Seguradora
			cSegNome	:= ""
			cSegResp	:= ""
			cSegDesc	:= ""
			cSegNrApoli	:= ""
			cSegNrAverb	:= ""
			//-- Valida se existe Responsavel pelo seguro
			aResp := TMSAvbCli(	(cAliasCT)->DT6_CLIDEV, (cAliasCT)->DT6_LOJDEV, '', ;
								(cAliasCT)->DT6_CLIREM, (cAliasCT)->DT6_LOJREM,     ;
								(cAliasCT)->DT6_CLIDES, (cAliasCT)->DT6_LOJDES, .F. )
			If !Empty(aResp) .And. lForApol //-- Cliente Responsavel pelo Seguro
				cAliasSeg := DataSource( 'DADOS_SEGURADORA1' )
				If (cAliasSeg)->(!EoF())
					cSegNome    := (cAliasSeg)->A2_NOME
					cSegNrApoli := (cAliasSeg)->DV6_APOL
					If aResp[1]+aResp[2] == (cAliasDT6)->DT6_CLIREM + (cAliasDT6)->DT6_LOJREM
						cSegResp := "0" //-- Remetente;
						cSegDesc := "Remetente"
					ElseIf aResp[1]+aResp[2] == (cAliasDT6)->DT6_CLIDES + (cAliasDT6)->DT6_LOJDES
						cSegResp := "3" //-- Destinatario;
						cSegDesc := "Destinatario"
					ElseIf aResp[1]+aResp[2] == (cAliasDT6)->DT6_CLIDEV + (cAliasDT6)->DT6_LOJDEV
						cSegResp := "5" //-- Tomador de Servico;
						cSegDesc := "Tomador de Servico"
					EndIf
				EndIf
				(cAliasSeg)->(DbCloseArea())
			EndIf
			//-- Caso o Cliente não esteja registrado na tabela de Averbação
			//-- Transportadora Responsavel pelo Seguro
			// --- If !Empty(cForSeg) .And. (Empty(cSegNome) .And. Empty(cSegNrApoli) .And. Empty(cSegResp)) .And. lForApol
				// --- cAliasSeg := DataSource( 'DADOS_SEGURADORA2' )
				/// --- If (cAliasSeg)->(!EoF())
					
					// --- {2LGI - Tratamento especifico GEFCO - Projeto CT-e - 03/Jul./2013 }
					// --- Somente para o FVL a seguradora eh outra
					_cFormula := ""		
					_cChassi	 := ""
					// Alterado por: Ricardo - EM: 20/08/2013 - Tratamento para CT-e manual, pegar seguradora na formula
					If Mv_par10 == 3
		               // --- Seguradora e apolice especifica para FVL
	               
		               	SZ8->(dbSetOrder(2))
 						If SZ8->(dbSeek(xFilial("SZ8")+(cAliasCT)->DT6_LOTNFC))
 						   	cSegResp    := "4" //-- Emitente do CT-e;
							cSegDesc    := SZ8->Z8_RESPSEG
 					   		cSegNome    := SZ8->Z8_SEGURAD         // Seguradora
					   		cSegNrApoli := SZ8->Z8_APOLICE         // No. da Apolice
					   		_cChassi		:=  "Chassi: " + SZ8->Z8_VIN + "  Marca: " + SZ8->Z8_MARCA + " Modelo: " + Trim(SZ8->Z8_DESCMOD)   
					   	Else
					   		_cFormula   := "SG7"	
              				DbSelectArea("SM4")					   		
	                		cSegResp    := "4" //-- Emitente do CT-e;
							cSegDesc    := SubStr(FORMULA(_cFormula)[2],7,10)  
	 					   	cSegNome    := SubStr(FORMULA(_cFormula)[1],7,25)         // Seguradora
						   	cSegNrApoli := SubStr(FORMULA(_cFormula)[3],7,30)     // No. da Apolice   					   	
 	 					EndIf
					Else 
						_cFormula := ""
               
 	               		If SubStr((cAliasCT)->DT6_CCUSTO,10,1)='5' .AND. SubStr((cAliasCT)->DT6_CCUSTO,1,3) == "322" .AND. SubStr((cAliasCT)->DT6_CCUSTO,7,3) $ "401|403|405|407|408|409" // Grupo/OVS/Importação
                    		_cFormula := "SG3"
       		      		ElseIf SubStr((cAliasCT)->DT6_CCUSTO,10,1)='5' .AND. SubStr((cAliasCT)->DT6_CCUSTO,1,3) == "322" .AND. SubStr((cAliasCT)->DT6_CCUSTO,7,3) $ "402|404|406|410"        // Grupo/OVS/Exportaçao
                     		_cFormula := "SG4"                                                            
                		ElseIf SubStr((cAliasCT)->DT6_CCUSTO,10,1)='6' .AND. SubStr((cAliasCT)->DT6_CCUSTO,1,3) == "322" .AND. SubStr((cAliasCT)->DT6_CCUSTO,7,3) $ "401|403|405|407|408|409" // Fora Grupo/OVS/Importação
                     		_cFormula := "SG5"
                		ElseIf SubStr((cAliasCT)->DT6_CCUSTO,10,1)='6' .AND. SubStr((cAliasCT)->DT6_CCUSTO,1,3) == "322" .AND. SubStr((cAliasCT)->DT6_CCUSTO,7,3) $ "402|404|406|410"        // Fora Grupo/OVS/Exportaçao
                     		_cFormula := "SG6"
                		ElseIf SubStr((cAliasCT)->DT6_CCUSTO,10,1)='5' .AND. SubStr((cAliasCT)->DT6_CCUSTO,1,3) == "211" // Grupo/OVL                           
                     		_cFormula := "SG1"
                		ElseIf SubStr((cAliasCT)->DT6_CCUSTO,10,1)='6' .AND. SubStr((cAliasCT)->DT6_CCUSTO,1,3) == "211" // Fora Grupo/OVL
                     		_cFormula := "SG2"
                		Else
                     		_cFormula := "SG1"
                		EndIf    

              			DbSelectArea("SM4")
                		cSegResp    := "4" //-- Emitente do CT-e;
						cSegDesc    := SubStr(FORMULA(_cFormula)[2],7,10)  
 					   	cSegNome    := SubStr(FORMULA(_cFormula)[1],7,25)         // Seguradora
					   	cSegNrApoli := SubStr(FORMULA(_cFormula)[3],7,30)     // No. da Apolice   
					
					EndIf
					// --- { 2LGI - Fim especifico GEFCO } 
					     
				// --- EndIf
				// --- (cAliasSeg)->(DbCloseArea())
			// --- EndIf
		EndIf

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

		If (!Empty((cAliasTagE)->DTC_SQEDES).AND.((cAliasCT)->DT6_DOCTMS<>"6"))
			DUL->(DbSetOrder(2))
			If DUL->(MsSeek(xFilial('DUL')+(cAliasCT)->DT6_CLIDES + (cAliasCT)->DT6_LOJDES + (cAliasTagE)->DTC_SQEDES))
				lSeqDes := .T.
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
		If (cAliasTagE)->DTC_SELORI == StrZero(1,Len(DTC->DTC_SELORI))   //Transportadora
			DUY->(DbSetOrder(1))
			If DUY->(MsSeek(xFilial("DUY")+(cAliasCT)->DT6_CDRORI))
				cOriMunPre := NoAcentoCte( Posicione('CC2',1,xFilial("CC2")+ DUY->DUY_EST + DUY->DUY_CODMUN,"CC2_MUN") )
				cOriUFPre  := NoAcentoCte( DUY->DUY_EST )
			EndIf
		ElseIf (cAliasTagE)->DTC_SELORI == StrZero(3,Len(DTC->DTC_SELORI))   //Coleta
			cAliasDT5 := Datasource("SOLICITANTE")
			If !(cAliasDT5)->(Eof())
				If !Empty((cAliasDT5)->DUL_MUN)
					//-- Expedidor
					cExpNome	:= NoAcentoCte((cAliasDT5)->DUE_NOME)
					cExpEnd		:= NoAcentoCte(FisGetEnd((cAliasDT5)->DUL_END)[1])
					cExpNro		:= Iif(FisGetEnd((cAliasDT5)->DUL_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasDT5)->DUL_END)[2])),"S/N")
					cExpMun		:= NoAcentoCte( (cAliasDT5)->DUL_MUN )
					cExpBai		:= NoAcentoCte( (cAliasDT5)->DUL_BAIRRO )
					cExpUF		:= NoAcentoCte( (cAliasDT5)->DUL_EST )
					cExpDoc		:= NoAcentoCte( (cAliasDT5)->DUE_CGC )
					cExpPais	:= cRemPais
					cOriMunPre	:= NoAcentoCte( (cAliasDT5)->(DUL_MUN) )
					cOriUFPre	:= NoAcentoCte( (cAliasDT5)->(DUL_EST) )
				Else
					cExpNome	:= NoAcentoCte((cAliasDT5)->DUE_NOME)
					cExpEnd		:= NoAcentoCte(FisGetEnd((cAliasDT5)->DUE_END)[1])
					cExpNro		:= Iif(FisGetEnd((cAliasDT5)->DUE_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasDT5)->DUE_END)[2])),"S/N")
					cExpMun		:= NoAcentoCte( (cAliasDT5)->DUE_MUN )
					cExpBai		:= NoAcentoCte( (cAliasDT5)->DUE_BAIRRO )
					cExpUF		:= NoAcentoCte( (cAliasDT5)->DUE_EST )
					cExpDoc		:= NoAcentoCte( (cAliasDT5)->DUE_CGC )
					cExpPais	:= cRemPais
					cOriMunPre	:= NoAcentoCte( (cAliasDT5)->(DUE_MUN) )
					cOriUFPre	:= NoAcentoCte( (cAliasDT5)->(DUE_EST) )
				EndIf
			EndIf
			(cAliasDT5)->(DbCloseArea())
		EndIf
		(cAliasTagE)->(dBCloseArea())

		//-- Documentos Originarios
		
		If !(cTipoNF $ '3,6,7') //-- Documento Nao Fiscal
			aDocOri		:= {}
			cAliasInfNF := DataSource( 'DOCUMENTOS_ORIGINARIOS' )
			
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
			(cAliasInfNF)->(dbCloseArea())
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se possui numero da viagem                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cViagem  := Posicione('DTP',2,xFilial('DTP')+(cAliasCT)->DT6_FILORI+(cAliasCT)->DT6_LOTNFC,'DTP_VIAGEM')
		
		//KATIA COMENTOU, POIS SERA CONSIDERADO COMO LOTACAO QUANDO OS DADOS DO MOTORISTA E VEICULO ESTIVEREM PREENCHIDOS NO LOTE
		/*
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
		*/
		//FIM DO COMENTARIO DA KATIA
		
		//INCLUSAO DA VALIDACAO ESPECIFICA DA GEFCO
		If !Empty(DTP->DTP_CODMOT) .AND. !Empty(DTP->DTP_CODVEI)
			lLotacao := .T.
		EndIf
		//FIM DA VALIDAÃ‡ÃƒO ESPECIFICA DA GEFCO
		

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
		cOriMunPre	:= Iif(Type("oNfe:_CTE:_INFCTE:_IDE:_XMUNINI:TEXT")=="U"," ",oNfe:_CTE:_INFCTE:_IDE:_XMUNINI:TEXT)
		cOriUFPre	:= oNfe:_CTE:_INFCTE:_IDE:_UFINI:TEXT

		//-- Destino da Prestacao
		cDesMunPre	:= oNfe:_CTE:_INFCTE:_IDE:_XMUNFIM:TEXT
		cDesUFPre	:= oNfe:_CTE:_INFCTE:_IDE:_UFFIM:TEXT

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
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "VOLUME"
							cPPQtdVol := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "LITRAGEM"
							cPPQtdVol := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
						Case oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_TPMED:TEXT == "METROS CUBICOS"
							cPPMetro3 := oNFE:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[ nCount ]:_QCARGA:TEXT
					EndCase
				Next nCount
			EndIf
		EndIf

		//-- Dados Seguradora
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
			ElseIf	cSegResp == "4'
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
		EndIf

		//-- RNTRC
		If (Type("oNFE:_CTE:_INFCTE:_INFCTENORM")) <> "U"
			If (Type("oNFE:_CTE:_INFCTE:_INFCTENORM:_RODO")) <> "U"
				cRNLotacao	:= If( oNfe:_CTE:_INFCTE:_INFCTENORM:_RODO:_LOTA:TEXT == '0', "Carga Fracionada", "Lotação")
				cRNDtPrv	:= oNfe:_CTE:_INFCTE:_INFCTENORM:_RODO:_DPREV:TEXT
				cRNDtPrv	:= SubStr(cRNDtPrv,9,2) + '/' + SubStr(cRNDtPrv,6,2) + '/' + SubStr(cRNDtPrv,1,4)
				cRNMensagem	:= "Esse Conhecimento de Transporte atende á Legislação de Transporte Rodoviário em Vigor"
			Else
				cRNLotacao	:= If( oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LOTA:TEXT == '0', "Carga Fracionada", "Lotação" )
				cRNDtPrv	:= oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_DPREV:TEXT
				cRNDtPrv	:= SubStr(cRNDtPrv,9,2) + '/' + SubStr(cRNDtPrv,6,2) + '/' + SubStr(cRNDtPrv,1,4)
				cRNMensagem	:= "Esse Conhecimento de Transporte atende á Legislação de Transporte Rodoviário em Vigor"
			EndIf
		EndIf
	EndIf	//-- lXML

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: CFOP - Natureza da Prestacao                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSoma   := 26
	nDifEsq := 30
	nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
	nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)
	oDacte:Box(nLInic, 0030, (nLFim + nDifEsq), 2370)
	oDacte:Say(nLInic, 0035, "CFOP - Natureza da Prestação", oFont08N)
	nSoma  := 12
	nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
	oDacte:Say(nLInic, 35, cCFOP + " - " + cDescCfop, oFont08)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: ORIGEM DA PRESTACAO                                               ³
	//³ BOX: DESTINO DA PRESTACAO                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSoma   := 31
	nDifEsq := 25
	nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
	nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)

	oDacte:Box(nLInic, 0030, (nLFim + nDifEsq), 1170)
	oDacte:Box(nLInic, 1175, (nLFim + nDifEsq), 2370)

	oDacte:Say(nLInic, 0035, "Origem da Prestação" , oFont08N)
	oDacte:Say(nLInic, 1185, "Destino da Prestação", oFont08N)

	nSoma  := 12
	nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
	oDacte:Say(nLInic, 0035, AllTrim(cOriMunPre) + ' - ' + AllTrim(cOriUFPre), oFont08)
	oDacte:Say(nLInic, 1185, AllTrim(cDesMunPre) + ' - ' + AllTrim(cDesUFPre), oFont08)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: Remetente                                                         ³
	//³ BOX: Destinatario                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSoma   := 32
	nDifEsq := 150
	nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
	nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)
	oDacte:Box(nLInic, 30  , (nLFim + nDifEsq), 1170)
	oDacte:Box(nLInic, 1175, (nLFim + nDifEsq), 2370)

	oDacte:Say(nLInic, 0035, "Remetente:", oFont08)
	oDacte:Say(nLInic, 0210, NoAcentoCte(Substr(cRemNome,1,50)), oFont08N)
	oDacte:Say(nLInic, 1185, "Destinatario:", oFont08)
	oDacte:Say(nLInic, 1380, NoAcentoCte(Substr(cDesNome,1,50)), oFont08N)

	cInsRemOpc := AllTrim(cRemIE)

	cRemCompl := AllTrim(cRemCompl)
	cDesCompl := AllTrim(cDesCompl)

	nSoma := 12
	For nCount := 1 To 5
		nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
		Do Case
			Case ( nCount == 1 )
				oDacte:Say(nLInic, 0035, "Endereço:", oFont08)
				oDacte:Say(nLInic, 0210, AllTrim(cRemEnd) + ", " + cRemNro, oFont08)
				oDacte:Say(nLInic, 1185, "Endereço:", oFont08)
				oDacte:Say(nLInic, 1380, AllTrim(cDesEnd) + ", " + cDesNro, oFont08)
			Case ( nCount == 2 )
				oDacte:Say(nLInic, 0210, Iif(Empty(cRemCompl),"",cRemCompl+" - ") + AllTrim(cRemBair), oFont08)
				oDacte:Say(nLInic, 1380, Iif(Empty(cDesCompl),"",cDesCompl+" - ") + AllTrim(cDesBair), oFont08)
			Case ( nCount == 3 )
				oDacte:Say(nLInic, 0035, "Municipio:", oFont08)
				oDacte:Say(nLInic, 0210, AllTrim(cRemMun) + ' - ' + AllTrim(cRemUF)  + ' CEP.: ' + Transform(AllTrim(cRemCEP), "@r 99999-999"), oFont08)
				oDacte:Say(nLInic, 1185, "Municipio:", oFont08)
				oDacte:Say(nLInic, 1380, AllTrim(cDesMun) + ' - ' + AllTrim(cDesUF) + ' CEP.: ' + Transform(AllTrim(cDesCEP), "@r 99999-999"), oFont08)
			Case ( nCount == 4 )
				oDacte:Say(nLInic, 0035, "CNPJ/CPF:", oFont08)
				oDacte:Say(nLInic, 0210, Transform(AllTrim(cRemCNPJ), "@r 99.999.999/9999-99") + "   Inscrição Estadual: " +  AllTrim(cInsRemOpc), oFont08)
				oDacte:Say(nLInic, 1185, "CNPJ/CPF:", oFont08)
				oDacte:Say(nLInic, 1380, Transform(AllTrim(cDesCNPJ), "@r 99.999.999/9999-99") + "   Inscrição Estadual: " +  AllTrim(cDesIE),    oFont08)
			Case ( nCount == 5 )
				oDacte:Say(nLInic, 0035, "Pais:", oFont08)
				oDacte:Say(nLInic, 0210, AllTrim(cRemPais) + ' Telefone.: ' + Transform(AllTrim(cRemFone),"@r (999) 999999999"),  oFont08)
				oDacte:Say(nLInic, 1185, "Pais:", oFont08)
				oDacte:Say(nLInic, 1380, AllTrim(cDesPais) + ' Telefone.: ' + Transform(AllTrim(cDesFone),"@r (999) 999999999"), oFont08)
		EndCase
	Next nCount

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: Expedidor / BOX: Recebedor                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSoma   := 31
	nDifEsq := 150
	nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
	nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)
	oDacte:Box(nLInic, 0030, (nLFim + nDifEsq), 1170)
	oDacte:Box(nLInic, 1175, (nLFim + nDifEsq), 2370)

	oDacte:Say(nLInic, 0035, "Expedidor:", oFont08)
	oDacte:Say(nLInic, 0210, cExpNome    , oFont08N)

	//-- Sequencia de endereco preenchida, fica como local de entrega.
	oDacte:Say(nLInic, 1185, Iif(lSeqDes,"Local de Entrega:","Recebedor:"), oFont08)
	oDacte:Say(nLInic, 1380, cRecNome, oFont08)
	nSoma  := 12

	For nCount := 1 To 5
		nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma

		Do Case
			Case ( nCount == 1 )
				oDacte:Say(nLInic, 0035, "Endereço:", oFont08)
				oDacte:Say(nLInic, 0210, cExpEnd + ", " + cExpNro, oFont08)
				oDacte:Say(nLInic, 1185, "Endereço:", oFont08)
				//-- Sequencia de endereco preenchida, fica como local de entrega.
				oDacte:Say(nLInic, 1380, If(lSeqDes, AllTrim(FisGetEnd(cRecEnd)[1]) + ", " + Iif(FisGetEnd(cRecEnd)[2]<>0, AllTrim(cValtoChar(FisGetEnd(cRecEnd)[2])),"S/N"),""), oFont08)
			Case ( nCount == 2 )
				oDacte:Say(nLInic, 0210, cExpBai, oFont08)
				oDacte:Say(nLInic, 1380, If(lSeqDes,AllTrim(cValtoChar(FisGetEnd(cRecEnd)[4])) + " - " + AllTrim(cRecBai),""), oFont08)
			Case ( nCount == 3 )
				oDacte:Say(nLInic, 0035, "Municipio:", oFont08)
				oDacte:Say(nLInic, 0210, AllTrim(cExpMun) + ' - ' + AllTrim(cExpUF), oFont08)
				oDacte:Say(nLInic, 1185, "Municipio:", oFont08)
				oDacte:Say(nLInic, 1380, If(lSeqDes,AllTrim(cRecMun) + ' - ' + AllTrim(cRecUF),""), oFont08)
			Case ( nCount == 4 )
				oDacte:Say(nLInic, 0035, "CNPJ/CPF:", oFont08)
				oDacte:Say(nLInic, 0210, cExpDoc    , oFont08)
				oDacte:Say(nLInic, 1185, "CNPJ/CPF:", oFont08)
				If lSeqDes
					If lRecPJ
						oDacte:Say(nLInic, 1380, Transform(cRecCGC,"@r 99.999.999/9999-99") + "   Inscrição Estadual: " +  cRecINSCR, oFont08)
					Else
						oDacte:Say(nLInic, 1380, Transform(cRecCPF,"@r 999.999.999-99"), oFont08)
					EndIf
				Else
					oDacte:Say(nLInic, 1380, "", oFont08)
				EndIf

			Case ( nCount == 5 )
				oDacte:Say(nLInic, 0035, "Pais:" , oFont08)
				oDacte:Say(nLInic, 0210, cExpPais, oFont08)
				oDacte:Say(nLInic, 1185, "Pais:" , oFont08)
				// oDacte:Say(nLInic, 1380, If(lSeqDes,AllTrim(cDesPais),""), oFont08)
				// Por: Ricardo - Em: 28/05/2014 - Estava saindo o Pais do destinatário.
				oDacte:Say(nLInic, 1380, If(lSeqDes,AllTrim(cRemPais),""), oFont08)				
		EndCase
	Next nCount

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: Tomador do Servico                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSoma   := 33
	nDifEsq := 55
	nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
	nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)
	oDacte:Box(nLInic, 0030, (nLFim + nDifEsq), 2370)

	oDacte:Say(nLInic, 0035, "Tomador do Serviço:", oFont08)
	oDacte:Say(nLInic, 0335, NoAcentoCte(SubStr(cDevNome,1,45)), oFont08)
	oDacte:Say(nLInic, 1380, "Municipio:", oFont08)
	oDacte:Say(nLInic, 1575, AllTrim(cDevMun) + ' - ' + AllTrim(cDevUF) + ' CEP.: ' + Transform(AllTrim(cDevCEP),"@r 99999-999"), oFont08)

	cDevCompl := AllTrim(cDevCompl)

	nSoma := 12
	For nCount := 1 To 2
		nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
		Do Case
			Case ( nCount == 1 )
				oDacte:Say(nLInic, 0035, "Endereço:", oFont08)
				oDacte:Say(nLInic, 0210, SubStr(AllTrim(cDevEnd),1,40)  + ", " + cDevNro + " - ", oFont08)
				oDacte:Say(nLInic, 0980, Iif(Empty(cDevCompl),"",cDevCompl+" - ") + AllTrim(cDevBair), oFont08)
				oDacte:Say(nLInic, 1875, "Pais:", oFont08)
				oDacte:Say(nLInic, 1950, AllTrim(cDevPais), oFont08)
			Case ( nCount == 2 )
				oDacte:Say(nLInic, 0035, "CNPJ/CPF:", oFont08)
				oDacte:Say(nLInic, 0210, Transform(AllTrim(cDevCNPJ),"@r 99.999.999/9999-99") + "   Inscrição Estadual: " + AllTrim(cDevIE), oFont08)
				oDacte:Say(nLInic, 1380, "Telefone:", oFont08)
				oDacte:Say(nLInic, 1575, Transform(AllTrim(cDevFone),"@r (999) 999999999"), oFont08)
		EndCase
	Next nCount

	If	AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 2, Len(DT6->DT6_DOCTMS)) .Or.;
		AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 6, Len(DT6->DT6_DOCTMS)) .Or.;
		AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 7, Len(DT6->DT6_DOCTMS)) .Or.;
		AllTrim((cAliasCT)->DT6_DOCTMS) == StrZero( 9, Len(DT6->DT6_DOCTMS)) .Or.;
		AllTrim((cAliasCT)->DT6_DOCTMS) == 'A' .Or. AllTrim((cAliasCT)->DT6_DOCTMS) == 'E' .Or. ;
		(AllTrim((cAliasCT)->DT6_DOCTMS) == 'B' .Or. AllTrim((cAliasCT)->DT6_DOCTMS) == 'C' .And. ;
		 Empty(Posicione('DUI',1,xFilial('DUI')+(cAliasCT)->DT6_DOCTMS,'DUI_DOCFAT')) )

		nSoma   := 33
		nDifEsq := 25
		nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
		nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ BOX: Prod Predom || Outras Caract || Valor Total da Mercadoria         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oDacte:Box(nLInic , 0030, (nLFim + nDifEsq)                , 2370)
		oDacte:Line(nLInic, 0800, (nLFim + nDifEsq)                , 0800) // Linha: Prod.Predominante e Out.Caracteristicas
		oDacte:Line(nLInic, 1585, (nLFim + nDifEsq)                , 1585) // Linha: Out.Caracteristicas e Vlr.Total
		oDacte:Say(nLInic , 0035, "Produto Predominante"           , oFont08N)
		oDacte:Say(nLInic , 0815, "Outras Caracteristicas da Carga", oFont08N)
		oDacte:Say(nLInic , 1595, "Valor Total da Mercadoria"      , oFont08N)

		nSoma  := 12
		nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma

		oDacte:Say(nLInic , 0035, SubStr(cPPDesc,1,40), oFont08)
		oDacte:Say(nLInic , 0815, AllTrim(cPPCarga), oFont08)
		oDacte:Say(nLInic , 1595, PadL( Transform( val(cPPVlTot), PesqPict("DT6","DT6_VALMER") ), 20 ), oFont08)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ BOX: QNT. / UNIDADE MEDIDA / BOX: SEGURADORA                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nSoma   := 33
		nDifEsq := 50
		nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
		nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)
		
		oDacte:Box(nLInic,  0030, (nLFim + nDifEsq),  1300)
		oDacte:Box(nLInic,  1308, (nLFim + nDifEsq),  2370)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ IMPRIMIR LABEL: VALORES DO QNT. / UNIDADE MEDIDA                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nCInic := 35
		oDacte:Say(nLInic , nCInic, "Peso Bruto (KG)", oFont08N)
		nCInic += 254
		oDacte:Line(nLInic, (nCInic - 5), (nLFim + nDifEsq), (nCInic - 5)) // Linha: Separador
		
		oDacte:Say(nLInic , nCInic, "Peso Cubado    ", oFont08N)
		nCInic += 254
		oDacte:Line(nLInic, (nCInic - 5), (nLFim + nDifEsq), (nCInic - 5)) // Linha: Separador
		
		oDacte:Say(nLInic , nCInic, "M³             ", oFont08N)
		nCInic += 254
		oDacte:Line(nLInic, (nCInic - 5), (nLFim + nDifEsq), (nCInic - 5)) // Linha: Separador
		
		oDacte:Say(nLInic , nCInic, "Qtd. Volume (Un)", oFont08N)
		nCInic += 254
		oDacte:Line(nLInic, (nCInic - 5), (nLFim + nDifEsq), (nCInic - 5)) // Linha: Separador
		
		oDacte:Say(nLInic , nCInic, "                ", oFont08N)
		nCInic += 254
		oDacte:Line(nLInic, (nCInic - 5), (nLFim + nDifEsq), (nCInic - 5)) // Linha: Separador
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ IMPRIMIR VALORES DO Peso / Peso Cubado / Metro3 / Volume               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nSoma  := 12
		nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
		oDacte:Line(nLInic, 1308, nLInic, 2370)

		If lXml
			nCInic := 35
			oDacte:Say(nLInic, nCInic, Transform(val(cPPPesoB),	PesqPict("DT6","DT6_PESO") ),	oFont08)
			nCInic += 254

			oDacte:Say(nLInic, nCInic, Transform(val(cPPPeso3),	PesqPict("DT6","DT6_PESOM3") ),	oFont08)
			nCInic += 254

			oDacte:Say(nLInic, nCInic, Transform(val(cPPMetro3),	PesqPict("DT6","DT6_METRO3") ),	oFont08)
			nCInic += 254

			oDacte:Say(nLInic, nCInic, Transform(val(cPPQtdVol),	PesqPict("DT6","DT6_VOLORI") ),	oFont08)
			nCInic += 254
		Else
			nCInic := 35
			oDacte:Say(nLInic, nCInic, Transform(cPPPesoB,	PesqPict("DT6","DT6_PESO") ),	oFont08)
			nCInic += 254

			oDacte:Say(nLInic, nCInic, Transform(cPPPeso3,	PesqPict("DT6","DT6_PESOM3") ),	oFont08)
			nCInic += 254

			oDacte:Say(nLInic, nCInic, Transform(cPPMetro3,	PesqPict("DT6","DT6_METRO3") ),	oFont08)
			nCInic += 254

			oDacte:Say(nLInic, nCInic, Transform(cPPQtdVol,	PesqPict("DT6","DT6_VOLORI") ),	oFont08)
			nCInic += 254		
		EndIf

		//-- Zera as variaveis(Peso, Peso Cubado, Metro Cubico e Qtd Volume) depois de impresso no DACTE.
		cPPPesoB  := ""
		cPPPeso3  := ""
		cPPMetro3 := ""
		cPPQtdVol := ""
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ IMPRIMIR LABEL: Nome da Seguradora                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oDacte:Say(nLInic-33 , 1318, "Nome da Seguradora: ", oFont08N)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ IMPRIMIR CONTEUDO: Nome da Seguradora                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oDacte:Say(nLInic-33 , 1580, cSegNome, oFont08)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Solicitacao para que sejam "calculadas" as linhas faltantes            ³
		//³ para completar o BOX                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nLInic  := CalcLinha(1, 1, nLInic, nSoma, oDacte, oFont08, 2)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ IMPRIMIR LABEL: RESP / NR.APOLICE / NR.AVERBACAO                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nCInic := 1318
		For nCount := 1 To 3
			Do Case
				Case ( nCount == 1 )
					cLabel := "Responsavel"
				Case ( nCount == 2 )
					cLabel := "Número da Apolice"
				Case ( nCount == 3 )
					cLabel := "Número da Averbação"
			EndCase
			If (nCount > 1)
				oDacte:Line(nLInic, (nCInic - 5), (nLFim + nDifEsq), (nCInic - 5)) // Linha: Separador
			EndIf
			oDacte:Say(nLInic , nCInic, cLabel, oFont08N)
			nCInic += 354
		Next nCount

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ CONTEUDO DO BOX SEGURADORA: RESP / APOLICE E AVERBACAO                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nSoma  := 12
		nCInic := 1318
		nLInic += Char2PixV(oDacte,"X",oFont08N) + nSoma
		oDacte:Say(nLInic, nCInic, cSegDesc, oFont08)
		nCInic += 354
		oDacte:Say(nLInic, nCInic, cSegNrApoli, oFont08)
		nCInic += 354
		oDacte:Say(nLInic, nCInic, cSegNrAverb, oFont08)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Conteudo do Box: Componentes do Valor da Prestacao de Servico          ³
		//³ Conteudo do Box: Informacoes Relativas ao Imposto                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		TMSR25Comp(lXml)

		cAliasPeri := DataSource("PRODUTOS_PERIGOSOS")
		If (cAliasPeri)->(!Eof())
			lPerig := .T.
		EndIf
		(cAliasPeri)->(dbCloseArea())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ BOX: DOCUMENTOS ORIGINARIOS                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nSoma   := 12
		nDifEsq := 200
		nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
		nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)
		
		oDacte:Box(nLInic , 0030, (nLFim + nDifEsq), 2370)
		If Empty(cCtrDpc)
			oDacte:Say(nLInic , 0980, "Documentos Originários", oFont08N)
		Else
			oDacte:Say(nLInic , 0380, "Documentos Originários", oFont08N)
			oDacte:Say(nLInic , 1550, "Documentos Anteriores", oFont08N)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ SUBTITULOS DOCUMENTOS ORIGINARIOS                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nSoma   := 12
		nDifEsq := 170
		nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
		nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)
		
		oDacte:Line(nLInic, 0030, nLInic              , 2370)	// Linha: DOCUMENTOS ORIGINARIOS
		oDacte:Line(nLInic, 1165, (nLFim + nDifEsq)   , 1165)	// Linha: Separador DOCUMENTOS ORIGINARIOS
		
		oDacte:Say(nLInic , 0035, "Tp.Doc"            , oFont08N)
		oDacte:Say(nLInic , 0170, "CNPJ/CPF Emitente" , oFont08N)
		oDacte:Say(nLInic , 0650, "Série/Nr.Documento", oFont08N)
		oDacte:Say(nLInic , 1175, "Tp.Doc"            , oFont08N)
		oDacte:Say(nLInic , 1310, "CNPJ/CPF Emitente" , oFont08N)
		oDacte:Say(nLInic , 1790, "Série/Nr.Documento", oFont08N)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Documentos Originarios                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nSoma    := 12
		nDifEsq  := 50
		nLInic   += Char2PixV(oDacte,"X",oFont08) + nSoma
		nLFim    := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)
		lControl := .F.

		nCount := 0
		aDoc   := {}

		For nCount := 1 to Len( aDocOri )
			lControl := !lControl
			If nCount < 11
				If Empty(cCtrDpc)
					If lControl
						If Empty(AllTrim(aDocOri[nCount][doDTC_NFEID]))
							//-- Imprime a Chave da NF-e, lado esquerdo
							oDacte:Say(nLInic, 0035, "NF", oFont08)
							oDacte:Say(nLInic, 0170, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
							oDacte:Say(nLInic, 0650, AllTrim(aDocOri[nCount][doDTC_SERNFC] + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC])), oFont08)
						Else
							//-- Imprime a Chave da NF-e, lado esquerdo
							cChaveA := AllTrim(aDocOri[nCount][doDTC_NFEID])
							oDacte:Say(nLInic, 0035, "NF-E CHAVE:", oFont08)
							oDacte:Say(nLInic, 0250, cChaveA, oFont08)
							cChaveA := ''
						EndIf
					Else
						//-- Imprime a Chave da NF-e, lado direito
						If Empty(AllTrim(aDocOri[nCount][doDTC_NFEID]))
							oDacte:Say(nLInic, 1175, "NF", oFont08)
							oDacte:Say(nLInic, 1310, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
							oDacte:Say(nLInic, 1790, AllTrim(aDocOri[nCount][doDTC_SERNFC]) + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)
						Else
							//-- Imprime a Chave da NF-e, lado direito
							cChaveB := AllTrim(aDocOri[nCount][doDTC_NFEID])
							oDacte:Say(nLInic, 1175, "NF-E CHAVE:", oFont08)
							oDacte:Say(nLInic, 1380, cChaveB, oFont08)
							cChaveB := ''
						EndIf
					EndIf
				ElseIf lControl
					If Empty(AllTrim(aDocOri[nCount][doDTC_NFEID]))
						oDacte:Say(nLInic, 0035, "NF", oFont08)
						oDacte:Say(nLInic, 0170, Transform(AllTrim(cRemCNPJ),"@r 99.999.999/9999-99"), oFont08)
						oDacte:Say(nLInic, 0650, AllTrim(aDocOri[nCount][doDTC_SERNFC]) + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC]), oFont08)
					Else
						//-- Imprime a Chave da NF-e, lado direito
						cChaveA := AllTrim(aDocOri[nCount][doDTC_NFEID])
						oDacte:Say(nLInic, 0035, "NF-E CHAVE:", oFont08)
						oDacte:Say(nLInic, 0250, cChaveA, oFont08)
						cChaveA := ''
					EndIf
					If !Empty(cCtrDpc)
						If Empty(cCTEDocAnt)
							oDacte:Say(nLInic, 1175, cDesDocAnt, oFont08)
							oDacte:Say(nLInic, 1310, Transform(AllTrim((cAliasCT)->DPC_CNPJ),"@r 99.999.999/9999-99"), oFont08)
							oDacte:Say(nLInic, 1790, AllTrim(cSerDpc) + " / " + AllTrim(cCtrDpc), oFont08)
						Else
							//-- Imprime a Chave da NF-e, lado esquerdo
							cChaveB := AllTrim(cCTEDocAnt)
							oDacte:Say(nLInic, 1175, "NF-E CHAVE:", oFont08)
							oDacte:Say(nLInic, 1380, cChaveB, oFont08)
							cChaveB := ''
						EndIf
					EndIf
				EndIf
			Else
				aadd(aDoc,{ AllTrim(cRemCNPJ),;
				AllTrim(aDocOri[nCount][doDTC_SERNFC]) + " / " + AllTrim(aDocOri[nCount][doDTC_NUMNFC]),;
				AllTrim(aDocOri[nCount][doDTC_NFEID])})
			EndIf
			
			// FORCAR A "QUEBRA" DA LINHA
			If ( (mod(nCount,2)) == 0 )
				If nCount < 11
					nSoma := 12
					If !Empty(cChaveA)
						nLInic += Char2PixV(oDacte,"X",oFont08N) + nSoma
						oDacte:Say(nLInic, 0035, "NF-E CHAVE:", oFont08)
						oDacte:Say(nLInic, 0240, cChaveA, oFont08)
						cChaveA := ''
					EndIf
					If !Empty(cChaveA)
						nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
						oDacte:Say(nLInic, 1175, "NF-E CHAVE:", oFont08)
						oDacte:Say(nLInic, 1380, cChaveB, oFont08)
						cChaveB := ''
					EndIf
					nSoma  := 12
					nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
				EndIf
			EndIf
		Next nCount
		nLInic  := 2000
	Else
		TMSR25Cmp()
		TMSR25Comp(lXml)
	EndIf
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: OBSERVACOES                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nDifEsq:= 220
	nLInic += Char2PixV(oDacte,"X",oFont08)
	nLInic += Char2PixV(oDacte,"X",oFont08)
	nLFim  := (nLInic + Char2PixV(oDacte,"X",oFont08))
	oDacte:Box(nLInic , 0030, (nLFim + nDifEsq), 2370)
	oDacte:Say(nLInic , 1050, "Observações", oFont08N)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSoma  := 12
	nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
	oDacte:Line(nLInic, 0030, nLInic, 2370) // Linha: OBSERVACOES

	If lXml
		If oNfe:_CTE:_INFCTE:_IDE:_TPAMB:TEXT == "2"
			oDacte:Say (nLInic, 0045, "DOCUMENTO GERADO EM AMBIENTE DE HOMOLOGAÇÃO", oFont10N)
			nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
		EndIf
	Else
		If (cAliasCT)->DT6_AMBIEN == 2 .And. Empty(aCab[nCont,7])
			oDacte:Say (nLInic, 0045, "DOCUMENTO GERADO EM AMBIENTE DE HOMOLOGAÇÃO", oFont10N)
			nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
		ElseIf !Empty(aCab[nCont,7]) .And. Substr(aCab[nCont,7],3,1) == "5" .And. cVersaoCTE == "1.04"
			//-- "7-Contingência FS-DA"
			oDacte:Say (nLInic, 0047, "DACTE em Contingência - impresso em decorrência de problemas técnicos", oFont10N)
			nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
		EndIf
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
	Else
		cDT6Obs := MsMM((cAliasCT)->DT6_CODMSG)
		cDT6Obs := StrTran(cDT6Obs,Chr(10)," ")
		cDT6Obs := StrTran(cDT6Obs,Chr(13)," ")
	EndIf

	If lAgdEntr
		cDT6Obs += (" "+Posicione("DYD",2,xFilial("DYD")+(cAliasCT)->DT6_FILDOC+(cAliasCT)->DT6_DOC+(cAliasCT)->DT6_SERIE,"DYD_MOTAGD"))
	EndIf
   
   // --- {2LGI Especifico GEFCO - CT-e
   // --- { Mensagem fiscal para remetente e destinatario  igual a Peugeot  
   // -- Alterado por Ricardo - Em: 09/09/2013
   If (cAliasCT)->DT6_CLIREM+(cAliasCT)->DT6_LOJREM + (cAliasCT)->DT6_CLIDEV+(cAliasCT)->DT6_LOJDEV $ GETMV("MV_XCLIDIF")
		cDT6Obs	+= AllTrim(GetNewPar("MV_XDESDIF","ICMS DIFERIDO CONFORME LEI RJ/6108/11"))
	EndIf
	// --- {2LGI Fim especifico GEFCO

	// Por: Ricardo  -  Em: 22/10/2013 - Objetivo: Tratar a Isenção de ICMS para a filial Sete Lagoas(14)
	If cFilAnt == "14"                                                                                 
		If POSICIONE("SA1",1,xFilial("SA1") + (cAliasCT)->DT6_CLIREM + (cAliasCT)->DT6_LOJREM, "A1_EST") = "MG" .AND.;
			POSICIONE("SA1",1,xFilial("SA1") + (cAliasCT)->DT6_CLIDES + (cAliasCT)->DT6_LOJDES, "A1_EST") = "MG" .AND.;
			POSICIONE("SA1",1,xFilial("SA1") + (cAliasCT)->DT6_CLIDES + (cAliasCT)->DT6_LOJDES, "A1_COD_MUN") <> "67202"

			cDT6Obs	+= AllTrim(FORMULA("014"))
		EndIf	
	EndIf		
	
	cDT6Obs2:= AllTrim(SubStr(cDT6Obs,161,160))
	cDT6Obs := AllTrim(SubStr(cDT6Obs,  1,160))

	cDTCObs2:= AllTrim(SubStr(cDTCObs,161,160))
	cDTCObs := AllTrim(SubStr(cDTCObs,  1,160))

	oDacte:Say (nLInic, 0045, cDT6Obs, oFont08)
	nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
	oDacte:Say (nLInic, 0045, cDT6Obs2, oFont08)

	nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
	oDacte:Say (nLInic, 0045, cDTCObs, oFont08)
	nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
	oDacte:Say (nLInic, 0045, cDTCObs2, oFont08)
	
	nLInic  := CalcLinha(1, 5, nLInic, 0, oDacte, oFont08, 0) // Solicitacao para que sejam "calculadas" as linhas faltantes para completar o BOX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: INFORMACOES ESPECIFICAS DO MODAL                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSoma   := 0
	nDifEsq := 90
	nLInic  := 2250
	nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)
	oDacte:Box(nLInic , 0030, (nLFim + nDifEsq), 2370)
	oDacte:Say(nLInic , 0760, "Dados Especificos do Modal Rodoviário - " + cRNLotacao, oFont08N) // Titulo nao pode ser "FIXO"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DADOS ESPECIFICOS DO MODAL RODOVIARIO                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSoma   := 12
	nDifEsq := 47
	nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
	nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)
	oDacte:Line(nLInic, 0030, nLInic                    , 2370) // Linha: INFORMACOES ESPECIFICAS DO MODAL
	oDacte:Line(nLInic, 0500, (nLFim + nDifEsq)         , 0500) // Linha: Separador CIOT
	oDacte:Line(nLInic, 0730, (nLFim + nDifEsq)         , 0730) // Linha: Separador DATA PREVISTA
	oDacte:Line(nLInic, 1160, (nLFim + nDifEsq)         , 1160) // Linha: Separador TEXTO do CONHECIMENTO DE TRANSPORTE
	oDacte:Say (nLInic , 0570, "CIOT"                    , oFont08N)
	oDacte:Say (nLInic , 0780, "Data Prevista de Entrega", oFont08N)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ RNTRC                                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSoma   := 12
	nLInic  += Char2PixV(oDacte,"X",oFont08N) + nSoma
	oDacte:Say(nLInic, 0035, "RNTRC da Empresa: ", oFont08)
	oDacte:Say(nLInic, 0330, cTmsAntt            , oFont08)
	
	oDacte:Say(nLInic, 0860, cRNDtPrv, oFont08)
	oDacte:Say(nLInic, 1180, cRNMensagem, oFont08)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: DADOS DE LOTACAO/VALE PEDAGIO                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nSoma   := 35
	nDifEsq := 185 //	Usado para calcular a coluna final do Box
	nLInic  += Char2PixV(oDacte,"X",oFont08N) + nSoma
	nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)
	oDacte:Box(nLInic , 0030, (nLFim + nDifEsq), 2370)
	oDacte:Line(nLInic, 0990, (nLFim + nDifEsq), 0990) // Linha: Separador Informações Veículo/Vale Pedágio
	oDacte:Say(nLInic , 0035, "Identificaçao do Conjunto Transportador", oFont08N)
	
	nSoma   := 15
	nDifEsq := 170 // Usado para calcular a coluna final do Box
	nLInic  += Char2PixV(oDacte,"X",oFont08N) + nSoma
	nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)
	oDacte:Box(nLInic , 0030, (nLFim), 990)
	oDacte:Say(nLInic , 0035, "Tipo", oFont08N)
	oDacte:Say(nLInic , 0270, "Placa", oFont08N)
	oDacte:Say(nLInic , 0450, "UF", oFont08N)
	oDacte:Say(nLInic , 0530, "RNTRC", oFont08N)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: DADOS DE LOTAÇÃO/VALE PEDAGIO -- LINHAS DE SEPARAÇÃO              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oDacte:Line(nLInic, 0260, (nLFim+nDifEsq), 0260) // Linha: Separador Tipo|Placa
	oDacte:Line(nLInic, 0440, (nLFim+nDifEsq), 0440) // Linha: Separador Placa|Uf
	oDacte:Line(nLInic, 0520, (nLFim+nDifEsq), 0520) // Linha: Separador Uf|Rntrc
	oDacte:Say(nLInic - nSoma , 1510, "Informações referentes ao vale-pedágio", oFont08N)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: EMPRESA CREDENCIADA                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nSoma   := 15
	nDifEsq := 135 // Usado para calcular o fim da linha do Box
	nLInic  += Char2PixV(oDacte,"X",oFont08N) + nSoma
	nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)
	oDacte:Box(nLInic , 0990, (nLFim + 20), 2370)
	oDacte:Box(nLInic , 0990, (nLFim + 80), 2370)
	oDacte:Say(nLInic + 15 , 1010, "CNPJ Fornecedor", oFont08N)
	oDacte:Say(nLInic + 70 , 1010, "Número Comprovante", oFont08N)
	oDacte:Say(nLInic + 120, 1010, "CNPJ Responsável", oFont08N)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ LINHAS: TIPO (VEICULO)                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lXml
		If (Type("oNFE:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO")) <> "U" .And. (oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LOTA:TEXT) == '1'
			If ValType(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC) == "O" //Se a Tag do Veículo for um Objeto o mesmo possui apenas um veículo
				cTpVei := Tabela('MU',oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_TPROD:TEXT,.F.)
				cPlaca :=  oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_PLACA:TEXT
				cUF    :=  oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_UF:TEXT
				cRNTRC :=  IIf((oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_TPPROP:TEXT) == "P",cTmsAntt,;
				(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_PROP:_RNTRC:TEXT))

				oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N), 0035, cTpVei, oFont08)
				oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N), 0270, cPlaca, oFont08)
				oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N), 0450, cUf   , oFont08)
				oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N), 0530, cRNTRC, oFont08)
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
						nSoma += 40
					EndIf
					oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N)+ nSoma, 0035, cTpVei, oFont08)
					oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N)+ nSoma, 0270, cPlaca, oFont08)
					oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N)+ nSoma, 0450, cUf   , oFont08)
					oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N)+ nSoma, 0530, cRNTRC, oFont08)
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
		ElseIf (Type("oNFE:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO")) <> "U" .And. (oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_LOTA:TEXT) == '1'
			If Type("oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC") == "O" //Se a Tag do Veículo for um Objeto o mesmo possui apenas um veículo
				cTpVei := Tabela('MU',oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_TPROD:TEXT,.F.)
				cPlaca :=  oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_PLACA:TEXT
				cUF    :=  oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_UF:TEXT
				cRNTRC :=  IIf((oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_VEIC:_TPPROP:TEXT) == "P",cTmsAntt,;
				(oNfe:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_RNTRC:TEXT))

				oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N), 0035, cTpVei, oFont08)
				oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N), 0270, cPlaca, oFont08)
				oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N), 0450, cUf   , oFont08)
				oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N), 0530, cRNTRC, oFont08)
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
						nSoma += 40
					EndIf

					oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N)+ nSoma, 0035, cTpVei, oFont08)
					oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N)+ nSoma, 0270, cPlaca, oFont08)
					oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N)+ nSoma, 0450, cUf   , oFont08)
					oDacte:Say(nLInic + Char2PixV(oDacte,"X",oFont08N)+ nSoma, 0530, cRNTRC, oFont08)
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
	ElseIf lLotacao 
		_cTransp := ""
		If SA2->(FieldPos('A2_RNTRC')) > 0
			//-- Veiculos da lotacao
			cAliasDTR := DataSource( 'VEICULOS_DA_LOTACAO' )
			
			While (cAliasDTR)->(!Eof())
				cCodVei:= ''
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
						nSoma += 40
					EndIf
					
					oDacte:Say(nLInic + (Char2PixV(oDacte,"X",oFont08N) + nSoma) , 0035, cTpVei, oFont08)
					oDacte:Say(nLInic + (Char2PixV(oDacte,"X",oFont08N) + nSoma),  0270, cPlaca, oFont08)
					oDacte:Say(nLInic + (Char2PixV(oDacte,"X",oFont08N) + nSoma) , 0450, cUf, oFont08)
					oDacte:Say(nLInic + (Char2PixV(oDacte,"X",oFont08N) + nSoma) , 0530, cRNTRC, oFont08)  
					
					_cTransp := Trim((cAliasDA3)->A2_NOME)
					(cAliasDA3)->(dbCloseArea())
				Next nX 
				
				(cAliasDTR)->(dbSkip())
				
				// --- {2LGI - Especifico GEFCO - CT-e 
				If Mv_par10 == 3  .and. (cAliasDTR)->( Eof())
					nSoma	+= 40
					oDacte:Say(nLInic + (Char2PixV(oDacte,"X",oFont08N) + nSoma) , 0530, _cTransp, oFont08)  
				EndIf
				// --- { 2LGI - Fim especifico GEFCO

			EndDo
			(cAliasDTR)->(dbCloseArea())
			
			//cCodMoto := Posicione("DUP",1,xFilial('DUP')+(cAliasCT)->DT6_FILORI+cViagem,'DUP_CODMOT') Katia Comentou, pois o motorista utilizado serÃ¡ o do lote
			cCodMoto := Posicione("DTP",2,xFilial('DTP')+(cAliasCT)->DT6_FILORI+(cAliasCT)->DT6_LOTNFC,'DTP_CODMOT')
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


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX:  MOTORISTA                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSoma   := 170
	nDifEsq := 250 // Usado para calcular o fim da linha do Box
	nLInic  += Char2PixV(oDacte,"X",oFont08N)+nSoma
	oDacte:Box(nLInic , 0030, (nLFim + nDifEsq), 2370)
	oDacte:Say(nLInic , 0045, "Nome do Motorista", oFont08N)
	
	oDacte:Line(nLInic, 1000, nLFim+nDifEsq, 1000) // Linha: Nome do Motorista|CPF do Motorista
	oDacte:Say(nLInic , 1010, "CPF do Motorista", oFont08N)
	
	oDacte:Line(nLInic, 1290, nLFim+nDifEsq, 1290) // Linha: CPF do Motorista|Identificação dos lacres em Trânsito
	oDacte:Say(nLInic , 1300, "Identificação dos lacres em Trânsitos", oFont08N)
	
	nSoma	:= 035
	nLInic+= Char2PixV(oDacte,"X",oFont08N)+nSoma
	oDacte:Say(nLinic,0045, cNomeMoto, oFont08)
	oDacte:Say(nLinic,1010, cCPFMoto, oFont08)
	oDacte:Say(nLinic,1300, cLacre, oFont08)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: FISCO                                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSoma   := 250
	nDifEsq := 250 // Usado para calcular o fim da linha do Box
	nLInic  += Char2PixV(oDacte,"X",oFont08N)+nSoma
	oDacte:Box(nLInic-50 , 0030, (nLFim + nDifEsq)-50, 2370)
	oDacte:Line(nLInic-nSoma+60, 0030, nLInic-nSoma+60, 2370)
	oDacte:Say(nLInic-nSoma+25 , 0500, "USO EXCLUSIVO DO EMISSOR DO CT-E", oFont08N)
   // --- { 2LGI - Especifico GEFCO - CT-e

   	// Por: J Ricardo - Em: 20/02/2014
   	If isCliPSA((cAliasCT)->DT6_CLIDEV)
 		oDacte:Say(nLInic-nSoma+65, 0045, "C.CUSTO : " + Trim((cAliasCT)->DT6_CCUSTO) + "\  C.CUSTO PSA: " + Trim((cAliasCT)->DT6_CCONT) + "\  CONTA DESP.: " + Trim((cAliasCT)->DT6_CONTA) + "    TABELA: " + (cAliasCT)->DT6_TABFRE  + "   LOTE: " + (cAliasCT)->DT6_LOTNFC, oFont08)

		If cFilAnt == "04"  		
			// Por: Ricardo  -  Em: 04/08/2014 - Objetivo: Tratar a msg. ref. SUBCONTRATACAO TERMACO para a filial Barueri(04)
 			// Buscar informações da ZONA de distribuição na DTC
			DTC->(dbsetorder(3))
			If DTC->(DbSeek(xFilial("DTC")+(cAliasCT)->DT6_FILDOC + (cAliasCT)->DT6_DOC + (cAliasCT)->DT6_SERIE ))
				If GetNewPar("MV_TERMACO","BR: Z-NO-NE") == AllTrim(DTC->DTC_XZONA)
	 				// oDacte:Say(nLInic-nSoma+95, 0045, GetNewPar("MV_TERMSG", "TRANSPORTE SUBCONTRATADO COM A TERMACO TERM MAR CONT SERV ACESS LTDA - CNPJ 11.552.312/0007-10 - IE:336.686.100.114") , oFont08)
	 				oDacte:Say(nLInic-nSoma+095, 0045, GetNewPar("MV_TERMSG", "TRANSPORTE SUBCONTRATADO COM A TERMACO TERM MAR CONT SERV ACESS LTDA") , oFont08)	 				
	 				oDacte:Say(nLInic-nSoma+125, 0045, "CNPJ 11.552.312/0007-10 - IE:336.686.100.114" , oFont08)	 					 				
		 		EndIf	
			EndIf
 		EndIf
	ElseIF ((cAliasCT)->DT6_CLIREM + (cAliasCT)->DT6_LOJREM) $ AllTrim( _cCliMAN) .OR. ((cAliasCT)->DT6_CLIDES + (cAliasCT)->DT6_LOJDES)  $ AllTrim(_cCliMAN)
 		// Buscar informações da MAN na DTC
		DTC->(dbsetorder(3))
		If DTC->(DbSeek(xFilial("DTC")+(cAliasCT)->DT6_FILDOC + (cAliasCT)->DT6_DOC + (cAliasCT)->DT6_SERIE ))
	 		oDacte:Say(nLInic-nSoma+65, 0045, "C.CUSTO : " + Trim((cAliasCT)->DT6_CCUSTO) + "    TABELA: " + (cAliasCT)->DT6_TABFRE  + "   LOTE: " + (cAliasCT)->DT6_LOTNFC, oFont08)
	 		oDacte:Say(nLInic-nSoma+95, 0045, "Tipo Carreg.(MAN): " + DTC->DTC_TPCAR + " - No.CVA(MAN): " + AllTrim(DTC->DTC_NUMCVA) + " - No.Coleta Moniloc(MAN): " + AllTrim(DTC->DTC_COLMON), oFont08)
		EndIf
	ElseIf cFilAnt == "04" 
		// Por: Ricardo  -  Em: 04/08/2014 - Objetivo: Tratar a msg. ref. SUBCONTRATACAO TERMACO para a filial Barueri(04)
 		// Buscar informações da ZONA de distribuição na DTC
		DTC->(dbsetorder(3))
		If DTC->(DbSeek(xFilial("DTC")+(cAliasCT)->DT6_FILDOC + (cAliasCT)->DT6_DOC + (cAliasCT)->DT6_SERIE ))
			If GetNewPar("MV_TERMACO","BR: Z-NO-NE") == AllTrim(DTC->DTC_XZONA)
	 			oDacte:Say(nLInic-nSoma+65, 0045, "C.CUSTO : " + Trim((cAliasCT)->DT6_CCUSTO) + "    TABELA: " + (cAliasCT)->DT6_TABFRE  + "   LOTE: " + (cAliasCT)->DT6_LOTNFC, oFont08)
	 			//oDacte:Say(nLInic-nSoma+95, 0045, GetNewPar("MV_TERMSG", "TRANSP. SUBCONTRATADO COM A TERMACO TERM MAR CONT SERV ACESS LTDA - CNPJ 11.552.312/0007-10 - I.E. 336.686.100.114") , oFont08)
	 			oDacte:Say(nLInic-nSoma+95, 0045, GetNewPar("MV_TERMSG", "TRANSPORTE SUBCONTRATADO COM A TERMACO TERM MAR CONT SERV ACESS LTDA") , oFont08)
	 			oDacte:Say(nLInic-nSoma+125, 0045, "CNPJ 11.552.312/0007-10 - I.E. 336.686.100.114", oFont08)	
	 		EndIf	
		EndIf
	ElseIf cFilAnt == "24"  // Filial Guaíba
		// Por: Ricardo  -  Em: 29/08/2014 - Objetivo: Tratar a msg. para a filial Guaíba(24)
		If  Left((cAliasCT)->DT6_CDRORI,2) == "RS" 
 			oDacte:Say(nLInic-nSoma+65, 0045, "C.CUSTO : " + Trim((cAliasCT)->DT6_CCUSTO) + "    TABELA: " + (cAliasCT)->DT6_TABFRE  + "   LOTE: " + (cAliasCT)->DT6_LOTNFC, oFont08)
 			//oDacte:Say(nLInic-nSoma+95, 0045, GetNewPar("MV_TERMSG", "TRANSP. SUBCONTRATADO COM A TERMACO TERM MAR CONT SERV ACESS LTDA - CNPJ 11.552.312/0007-10 - I.E. 336.686.100.114") , oFont08)
 			oDacte:Say(nLInic-nSoma+95, 0045, GetNewPar("MV_GUAIBA", "AUTORIZADO PAGAMENTO DO IMPOSTO NO PRAZO DO RICMS APENDICE III, ") , oFont08)
 			// oDacte:Say(nLInic-nSoma+125, 0045, GetNewPar("MV_GUAIBA2","SEÇÃO I, ITEM III CFE CONCESSÃO 05401095254."), oFont08)
 			// Alterado por solicitação da Rosa(Fiscal) em 06/04/2015
 			oDacte:Say(nLInic-nSoma+125, 0045, GetNewPar("MV_GUAIBA2","SEÇÃO I, ITEM III CFE CONCESSÃO 0540109203."), oFont08) 			
		EndIf		
	Else
 		oDacte:Say(nLInic-nSoma+65, 0045, "C.CUSTO : " + Trim((cAliasCT)->DT6_CCUSTO) + "    TABELA: " + (cAliasCT)->DT6_TABFRE  + "   LOTE: " + (cAliasCT)->DT6_LOTNFC, oFont08)		
 	EndIf                                                                            
 	
 	// --- Somente FVL imprime o chassi e modelo do veiculo conforme tabela auxiliar
 	If Mv_par10 == 3 .or. SubStr((cAliasCT)->DT6_CCUSTO,1,3) $ "101|102" 
 		SZ8->(dbSetOrder(2))
 		If SZ8->(dbSeek(xFilial("SZ8")+(cAliasCT)->DT6_LOTNFC))
 	 		oDacte:Say(nLInic-nSoma+95, 0045, _cChassi , oFont08)
 	 	EndIf 	
 	EndIf

	// --- Por: Ricardo Guimarães - Em: 19/09/2014 - Para atender projeto CNH
	_cPTranspCNH := Posicione("DF0",1,xFilial("DF0")+(cAliasCT)->DT6_NUMAGD,"DF0_PLANID")
	oDacte:Say(nLInic-nSoma+140, 0045, IIF(!Empty(_cPTranspCNH), "Plano de Transporte CNH: " + StrZero(_cPTranspCNH,9), ""), oFont08)

	// --- Por: Ricardo Guimarães - Em: 29/12/2014 - Para atender legislação - copiado do fonte RTMSR27	
	If (cAliasCT)->DT6_VALIMP > 0
		oDacte:Say(nLInic-nSoma+165, 0045,"O valor aproximado de tributos incidentes sobre o preco deste servico e de R$ ";
		           + PADL(Transform((cAliasCT)->DT6_VALIMP,'@E 999,999.99'),20), oFont08)
	EndIf

   // --- { 2LGI Fim especifico GEFCO

	oDacte:Line(nLInic-50, 1400, nLFim+nDifEsq, 1400) // Linha: Nome do Motorista|CPF do Motorista
	oDacte:Say(nLInic-nSoma+25 , 1800, "RESERVADO AO FISCO", oFont08N)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BOX: USO EXCLUSIVO DO EMISSOR                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSoma   := 0
	nDifEsq := 180
//	nLInic  += Char2PixV(oDacte,"X",oFont08N) + nSoma
	nLInic  := 2935
	nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)
	oDacte:Box(nLInic , 0030, (nLFim + nDifEsq), 2370)
	oDacte:Say(nLInic , 0035, "DECLARO QUE RECEBI OS VOLUMES DESTE CONHECIMENTO EM PERFEITO ESTADO PELO QUE DOU POR CUMPRIDO O PRESENTE CONTRATO DE TRANSPORTE", oFont08N)
	
	nSoma   := 12
	nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
	oDacte:Line(nLInic, 0700, (nLFim + nDifEsq), 0700) // Linha: Separador NOME e RG
	oDacte:Line(nLInic, 1690, (nLFim + nDifEsq), 1690) // Linha: Separador CHEGADA e SAIDA
	oDacte:Line(nLInic, 0030, nLInic           , 2370) // Linha: USO EXCLUSICO DO EMISSOR
	
	For nCount := 1 To 6
		Do Case
			Case ( nCount == 1 )
				oDacte:Say(nLInic , 0035, "Nome"               , oFont08N)
				oDacte:Say(nLInic , 1700, "Chegada Data / Hora", oFont08N)
			Case ( nCount == 6 )
				oDacte:Line(nLInic-50, 0030, nLInic-50               , 0700) // Linha: NOME
				oDacte:Line(nLInic-50, 1690, nLInic-50               , 2370) // Linha: CHEGADA
				oDacte:Say(nLInic-50 , 0035, "R.G"                , oFont08N)
				oDacte:Say(nLInic-50 , 1700, "Saída Data / Hora"  , oFont08N)
		EndCase
		
		nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
	Next nCount
	
	nLInic  := CalcLinha(1, 5, nLInic, 12, oDacte, oFont08N, 0) // Solicitacao para que sejam "calculadas" as linhas faltantes para completar o BOX
	
	
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
		TMSR25Cont(aDoc, aCab[nCont])
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
±±³Programa  ³Char2PixV ³ Autor ³                       ³ Data ³          ³±±
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
±±³Programa  ³CalcLinha ³ Autor ³Adalberto SM           ³ Data ³09/02/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao responsavel por Calcular o numero de linhas necessa- ³±±
±±³          ³rias para completar o layout, da sessao solicitante.        ³±±
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
Static Function CalcLinha(nInic, nTot, nLInic, nSoma, oDacte, oFont, nMod)
Local nCount := 0
Default nMod := 0

For nCount := nInic To nTot
	If ( nMod = 0 )
		nLInic   += Char2PixV(oDacte,"X",oFont) + nSoma
	Else
		// FORCAR UMA "QUEBRA" DE LINHA, SENDO O CAMPO nMod A QUANTIDADE DE "COLUNAS" POR LINHA.
		If ( (mod(nCount, nMod)) == 0 )
			nSoma    := nSoma
			nLInic   += Char2PixV(oDacte,"X",oFont) + nSoma
		EndIf
	EndIf

Next nCount

Return(nLInic)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |TMSR25Cont³ Autor ³Andre Godoi            ³ Data ³04/12/09  ³±±
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
Static Function TMSR25Cont(aDoc, aCab, aPerigo, nCnt)
Local oFont07     := TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)
Local oFont07N    := TFont():New("Times New Roman",07,07,,.T.,,,,.T.,.F.)
Local oFont08     := TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
Local oFont08N    := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local lControl    := .F.
Local nCount      := 0
Local aDoc1       := {}
Local cChaveA     := ''
Local cChaveB     := ''

//Variaveis Produtos Perigosos
Local nCompr		:= 70	//Comprimento Padrao da Primeira Linha
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
TMSR25Cab(aCab)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: DOCUMENTOS ORIGINARIOS                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma   := 26
nDifEsq := 20
nLInic  += Char2PixV(oDacte,"X",oFont08N) + nSoma
nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont07))
oDacte:Box(nLInic, 0030, 3150 , 2370)
oDacte:Say(nLInic, 1000, "DOCUMENTOS ORIGINARIOS", oFont07N)

nSoma   := 30
nDifEsq := 1500
nLInic  += Char2PixV(oDacte,"X",oFont08N) + nSoma
nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08N) + nSoma)

oDacte:Line(nLInic, 0030, nLInic , 2370) // Linha: DOCUMENTOS ORIGINARIOS
oDacte:Line(nLInic, 1165, 2215   , 1165) // Linha: Separador DOCUMENTOS ORIGINARIOS

oDacte:Say(nLInic , 0035, "Tp.Doc"            , oFont08N)
oDacte:Say(nLInic , 0170, "CNPJ/CPF Emitente" , oFont08N)
oDacte:Say(nLInic , 0650, "Série/Nr.Documento", oFont08N)
oDacte:Say(nLInic , 1175, "Tp.Doc"            , oFont08N)
oDacte:Say(nLInic , 1310, "CNPJ/CPF Emitente" , oFont08N)
oDacte:Say(nLInic , 1790, "Série/Nr.Documento", oFont08N)

nSoma    := 12
nLInic   += Char2PixV(oDacte,"X",oFont08N) + nSoma


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime as NF                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lControl := .F.
For nCount := 1 To Len(aDoc)
	lControl := !lControl

	If nCount < 75
		If (lControl == .T.)
			oDacte:Say(nLInic, 0035, "NF",													oFont08)
			oDacte:Say(nLInic, 0170, Transform(aDoc[nCount,1],"@r 99.999.999/9999-99"),	oFont08)
			oDacte:Say(nLInic, 0650, aDoc[nCount,2],										oFont08)
			cChaveA:= aDoc[nCount,3]
		Else
			oDacte:Say(nLInic, 1175, "NF", 													oFont08)
			oDacte:Say(nLInic, 1310, Transform(aDoc[nCount,1],"@r 99.999.999/9999-99"),	oFont08)
			oDacte:Say(nLInic, 1790, aDoc[nCount,2],										oFont08)
			cChaveB :=aDoc[nCount,3]
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³FORCAR A "QUEBRA" DA LINHA                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lControl //( (mod(nCount,2)) == 0 )
			If !Empty(cChaveA) .or. !Empty(cChaveB)
				nLInic   += Char2PixV(oDacte,"X",oFont08N) + nSoma
			EndIf

			If !Empty(cChaveA)
				oDacte:Say(nLInic, 0035, "NF-E CHAVE:",	oFont08)
				oDacte:Say(nLInic, 0240,cChaveA ,		oFont08)
				cChaveA := ''
			EndIf

			If !Empty(cChaveB)
				oDacte:Say(nLInic, 1175, "NF-E CHAVE:",	oFont08)
				oDacte:Say(nLInic, 1380, cChaveB,		oFont08)
				cChaveB := ''
			EndIf
			nLInic   += Char2PixV(oDacte,"X",oFont08N) + nSoma
		EndIf
	Else
		aAdd(aDoc1,{aDoc[nCount,1],;
		aDoc[nCount,2],;
		aDoc[nCount,3]})
	EndIf
Next nCount


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime a ultima Chave.                                                 ³
//³FORCAR A "QUEBRA" DA LINHA                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cChaveA)

	nLInic   += Char2PixV(oDacte,"X",oFont08N) + nSoma

	oDacte:Say(nLInic, 0035, "NF-E CHAVE:",	oFont08)
	oDacte:Say(nLInic, 0240,cChaveA ,		oFont08)
	cChaveA := ''

	oDacte:Say(nLInic, 1175, "NF-E CHAVE:",	oFont08)
	oDacte:Say(nLInic, 1380, cChaveB,		oFont08)
	cChaveB := ''

	nLInic   += Char2PixV(oDacte,"X",oFont08N) + nSoma
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: Produtos Perigosos                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAliasPeri := DataSource("PRODUTOS_PERIGOSOS")
nSoma   := 1380

If (cAliasPeri)->(!Eof())
	nDifEsq:= 110
	nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
	nLInic := 2214
	nLFim  := (nLInic + Char2PixV(oDacte,"X",oFont08))
	oDacte:Box(nLInic , 0030, 3150, 2370)
	oDacte:Say(nLInic , 0980, "Informações sobre Produtos Perigosos", oFont08N)
	nSoma  := 12
	nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
	oDacte:Line(nLInic, 0030, nLInic, 2370)
	oDacte:Line(nLInic, 0030, nLInic, 2370)
	oDacte:Say(nLInic , 0035, "Nro. Onu"			, oFont08N)			
	oDacte:Line(nLInic, 0155, 3150, 0155 )						// Linha Divisoria Nro. Onu X Nome Apropriado
	oDacte:Say(nLInic , 0500, "Nome Apropriado" 	, oFont08N)	
	oDacte:Line(nLInic, 1220, 3150, 1220 )						// Linha Divisoria Nome Apropriado X Classe/Subclasse e Risco Subsidiário
	oDacte:Say(nLInic , 1350, "Classe/Subclasse e Risco Subsidiário", oFont08N)
	oDacte:Line(nLInic, 1870, 3150, 1870 )						// Linha Divisoria Classe Subclasse e Risco Subsidiário X Grupo de Embalagem
	oDacte:Say(nLInic , 1870, "Grupo de Embalagem", oFont08N)
	oDacte:Line(nLInic, 2145, 3150, 2145 )						// Linha Divisoria Grupo de Embalagem X Qto. Tot. Produto
	oDacte:Say(nLInic , 2155, "Qto. Tot. Produto" , oFont08N)
	nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
	If Len(aPerigo) <= 0  
		Do While (cAliasPeri)->(!EoF())
			AAdd(aPerigo,{(cAliasPeri)->DY3_ONU,;
							(cAliasPeri)->DY3_DESCRI,;
							(cAliasPeri)->DY3_CLASSE	 + ' ' +(cAliasPeri)->DY3_NRISCO, ;
							(cAliasPeri)->DY3_GRPEMB,;
							Str((cAliasPeri)->DTC_PESO)})
			(cAliasPeri)->(dbSkip())
		EndDo
	EndIf
	
	For nCnt := nCnt to Len(aPerigo)										//Verifica tamanho do array
		oDacte:Say(nLInic , 0035,     aPerigo[nCnt][1]   , oFont08)		//Nro. Onu
		For nSegLinha:= nSegLinha To Len(aPerigo[nCnt][2])				//	
			oDacte:Say(nLInic , 0165,Substr(aPerigo[nCnt][2],nSegLinha,nCompr), oFont08)	//Nome Apropriado 
			If !lVerif 														//Nao repete valores a cada quebra de linha
				oDacte:Say(nLInic , 1230,aPerigo[nCnt][3]	, oFont08)		//Classe/Subclasse e Risco Subsidiário
				oDacte:Say(nLInic , 1880,aPerigo[nCnt][4] , oFont08)		//Grupo de Embalagem
				oDacte:Say(nLInic , 2155,aPerigo[nCnt][5]	, oFont08)		//Qto. Tot. Produto
				lVerif := .T.	
			EndIf
			nSegLinha += nCompr -1				
			//nCOntLi++
			If Len(aPerigo[nCnt][2]) > nSegLinha 
				nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
			EndIf		
			If nLInic >= 3015		//Verifica se chegou ao fim da pagina
				lFimPerig := .T.
				Exit
			EndIf
		Next
		If lFimPerig
			Exit	
		EndIf
		nSegLinha := 1
		//nCOntLi := 1
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
	TMSR25Cont(aDoc1)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se existir mais prod perigoso para outra pagina, chama a mesma funcao. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLInic >= 3015
	TMSR25Cont(,aCab,aPerigo,nCnt)
EndIf

(cAliasPeri)->(dbCloseArea())
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TMSR25Cab³ Autor ³Andre Godoi            ³ Data ³04/12/09  ³±±
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
Static Function TMSR25Cab(aCab)
Local oFont07    := TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)	//Fonte Times New Roman 07
Local oFont08    := TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)	//Fonte Times New Roman 08
Local oFont08N   := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)	//Fonte Times New Roman 08 Negrito
Local oFont10N   := TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
Local cAliasAll  := GetNextAlias()
Local cStartPath := GetSrvProfString("Startpath","")
Local cTmsAntt   := SuperGetMv( "MV_TMSANTT", .F., .F. )	//Numero do registro na ANTT com 14 dígitos
Local cLogoTp    := cStartPath + "GEFCO.bmp"			   	//Insira o caminho do Logo da empresa, na variavel cLogoTp.
// Local cLogoTp    := cStartPath + "logoCte.bmp"				//Insira o caminho do Logo da empresa, na variavel cLogoTp.
Local nLAnte     := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INICIO ROTINA DE IMPRESSAO                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTAGEM SETOR: INFORMACOES DACTE                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: Empresa / DACTE / MODAL / LOGO                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLInic := 30
nLFim  := (nLInic + 70)
nSoma  := 12
oDacte:Box(nLInic, 0030, 00500, 1395)					//Empresa
oDacte:Box(nLInic, 1400, nLFim, 1990)					//DACTE
oDacte:Box(nLInic, 1995, nLFim, 2370)					//Modal
//oDacte:SayBitmap( nLInic + 10, 80,cLogoTp,990,180 )	//Logo
//oDacte:SayBitmap( nLInic + 10, 80,cLogoTp,400,180 )	//Logo
oDacte:SayBitmap( nLInic + 100, 80,cLogoTp,350,300 )	//Logo

oDacte:Say(nLInic, 1650,"DACTE",oFont08N)
oDacte:Say(nLInic, 2135,"MODAL",oFont08N)

nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
oDacte:Say(nLInic, 2110, "Rodoviário",oFont08)
oDacte:Say(nLInic, 1475, (Upper("Documento Auxiliar do CT-e")),oFont08)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BOX: Modelo / Serie / Numero / Folha / Emis                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma  := 26
nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
nLFim  := (nLInic + 70)
oDacte:Box(nLInic, 1400, nLFim    , 2370)
oDacte:Say(nLInic, 1450, "Modelo" , oFont08N)
oDacte:Say(nLInic, 1600, "Serie"  , oFont08N)
oDacte:Say(nLInic, 1710, "Número" , oFont08N)
oDacte:Say(nLInic, 1900, "Folha"  , oFont08N)
oDacte:Say(nLInic, 2130, "Emissão", oFont08N)

nSoma  := 12
nLInic += Char2PixV(oDacte,"X",oFont08N) + nSoma

// Por: Ricardo
oDacte:Say(nLInic, 40+450, "FILIAL: " + AllTrim(SM0->M0_FILIAL),oFont10N)

oDacte:Say(nLInic, 1485,"57",oFont08)							//Modelo
oDacte:Say(nLInic, 1605,cValtoChar( Val(aCab[2]) ) , oFont08)	//Serie
oDacte:Say(nLInic, 1710, cValtoChar( Val(aCab[1]) ), oFont08)	//Numero
oDacte:Say(nLInic, 1900, AllTrim(Str(nFolhAtu)) + " / " + AllTrim(Str(nFolhas)), oFont08)
nFolhAtu ++
oDacte:Say(nLInic, 2075, SubStr(AllTrim(aCab[3]), 7, 2) + '/' + SubStr(AllTrim(aCab[3]), 5, 2) + "/" +;	//Folha
SubStr(AllTrim(aCab[3]), 1, 4) + " - " + SubStr(AllTrim(aCab[4]), 1, 2) + ":"+;	//Emissao
SubStr(AllTrim(aCab[4]), 3, 2) + ":00")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: Controle do Fisco                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSoma  := 26
	nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
	nLFim  := (nLInic + 308)
	oDacte:Box(nLInic, 1400, nLFim, 2370)
	MSBAR3("CODE128",1.60,12.50,aCab[5],oDacte,/*lCheck*/,/*Color*/,/*lHorz*/,.02960,0.6,/*lBanner*/,/*cFont*/,"C",.F.)
If	AllTrim(aCab[7])<>""
	MSBAR3("CODE128",3.30,12.50,aCab[7],oDacte,/*lCheck*/,/*Color*/,/*lHorz*/,.02960,0.6,/*lBanner*/,/*cFont*/,"C",.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: EMPRESA - NOME                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma  := 30
nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
oDacte:Say(nLInic, 40+450, AllTrim(SM0->M0_NOMECOM),oFont08)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: EMPRESA - ENDERECO                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma  := 26
nDifEsq := 0
nLInic += Char2PixV(oDacte,"X",oFont10N) + nSoma
oDacte:Say(nLInic, 40+450, AllTrim(SM0->M0_ENDENT),oFont08)
oDacte:Line( (nLInic + nDifEsq), 1410, (nLInic + nDifEsq), 2360 )
oDacte:Say( (nLInic + nDifEsq), 1445,"Chave de acesso para consulta de autenticidade no site www.cte.fazenda.gov.br",oFont07)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: EMPRESA - BAIRRO                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma  := 26
nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma

oDacte:Say(nLInic, 40+450, AllTrim(SM0->M0_BAIRENT) ,oFont08)
oDacte:Say(nLInic, 1455, Transform(AllTrim(aCab[5]),"@r 99.9999.99.999.999/9999-99-99-999-999.999.999.999.999.999.9"), oFont08N) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: EMPRESA - UF / MUNICIPIO / CEP                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma  := 26
nLInic += Char2PixV(oDacte,"X",oFont08) + nSoma
oDacte:Say(nLInic, 40+450, AllTrim(SM0->M0_CIDENT) + '  -  ' + AllTrim(SM0->M0_ESTENT) + '  CEP.:  ' + AllTrim(SM0->M0_CEPENT) ,oFont08)
oDacte:Line( (nLInic + nDifEsq), 1410, (nLInic + nDifEsq), 2360 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: EMPRESA - CNPJ e INSCRICAO EST.                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma   := 26
nDifEsq := 5
nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
oDacte:Say(nLInic, 40+450, "CNPJ: " + Transform(AllTrim(SM0->M0_CGC),"@r 99.999.999/9999-99") + "       Inscrição Estadual: " + AllTrim(SM0->M0_INSC), oFont08)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: EMPRESA - TELEFONE                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma   := 20
nDifEsq := 50
nLInic  += Char2PixV(oDacte,"X",oFont08N) + nSoma
oDacte:Say(nLInic, 40+450,'Telefone: ' + AllTrim(SM0->M0_TEL),oFont08)
//oDacte:Say(nLInic, 550, 'RNTRC da Empresa: ' + AllTrim(cTmsAntt),oFont08)
oDacte:Say(nLInic, 1000, 'RNTRC da Empresa: ' + AllTrim(cTmsAntt),oFont08)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  BOX: Tipo do CTe                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma   := 2
nDifEsq := 7
nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma + nDifEsq
nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)

oDacte:Box( nLInic + 6, 0030, 00570 , 2370)
oDacte:Line(nLInic    , 1400, nLInic, 2370) // Linha: Sobre Protocolo e Suframa Dest.

oDacte:Say(nLInic + 6, 0035, "Tipo do CTe"                 , oFont08N)
oDacte:Say(nLInic + 6, 0300, "Tipo de Serviço"             , oFont08N)
oDacte:Say(nLInic + 6, 0635, "Tomador do Serviço"          , oFont08N)
oDacte:Say(nLInic + 6, 1035, "Forma de Pagamento"          , oFont08N)
oDacte:Say(nLInic + 6, 1450, "Número do Protocolo"         , oFont08N)
oDacte:Say(nLInic + 6, 1900, "Insc.Suframa do Destinatário", oFont08N)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  BOX: Tipo do CTe - Divisoes                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma  := 12
nLAnte := nLInic + 6
nLInic += Char2PixV(oDacte,"X",oFont08N) + nSoma
nLFim  := (nLInic + Char2PixV(oDacte,"X",oFont08N) + nSoma)

oDacte:Line(nLAnte, 0295, nLFim, 0295) // Linha: Divide Tp.CTe e Tp.Servico
oDacte:Line(nLAnte, 0630, nLFim, 0630) // Linha: Tp.Servico e Tomador
oDacte:Line(nLAnte, 1030, nLFim, 1030) // Linha: Tomador e Forma Pagto
oDacte:Line(nLAnte, 1395, nLFim, 1395) // Linha: Divide Forma Pagto e Protocolo
oDacte:Line(nLAnte, 1890, nLFim, 1890) // Linha: Divide Protocolo e Suframa Dest.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipo de Conhecimento                                                   ³
//³ 0 - Normal                                                             ³
//³ 1 - Complemento de Valores                                             ³
//³ 2 - Emitido em Hipotese de anulacao de Debito                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( AllTrim((cAliasCT)->DT6_DOCTMS) == "8" )
	oDacte:Say(nLInic,  0035, "COMPLEMENTO", oFont08)
ElseIf ( AllTrim((cAliasCT)->DT6_DOCTMS) == "M" )
	oDacte:Say(nLInic,  0035, "ANULACAO", oFont08)
Else
	oDacte:Say(nLInic,  0035, "NORMAL", oFont08)
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
	oDacte:Say(nLInic, 0300, "NORMAL", oFont08)
ElseIf (cTpServ == '2')
	oDacte:Say(nLInic, 0300, "SUBCONTRATAÇÃO", oFont08)
ElseIf (cTpServ == '3')
	oDacte:Say(nLInic, 0300, "DOC. NÃO FISCAL", oFont08)
ElseIf (cTpServ == '4')
	oDacte:Say(nLInic, 0300, "EXPORTACAO", oFont08)
ElseIf (cTpServ == '5')
	oDacte:Say(nLInic, 0300, "REDESPACHO", oFont08)
ElseIf (cTpServ == '6')
	oDacte:Say(nLInic, 0300, "DOC. NÃO FISCAL", oFont08)
ElseIf (cTpServ == '7')
	oDacte:Say(nLInic, 0300, "DOC. NÃO FISCAL", oFont08)
Else
	oDacte:Say(nLInic, 0300, "NORMAL", oFont08)
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
	oDacte:Say(nLInic,  0635, "REMETENTE"  , oFont08)
	oDacte:Say(nLInic,  1035, "PAGO"       , oFont08)
ElseIf (cAliasCT)->DT6_DEVFRE == "2" 
	oDacte:Say(nLInic,  0635, "DESTINATÁRIO"  , oFont08)
	oDacte:Say(nLInic,  1035, "A PAGAR"       , oFont08)
ElseIf (cAliasCT)->DT6_DEVFRE == "3" 
	oDacte:Say(nLInic,  0635, "OUTROS"  , oFont08)
	oDacte:Say(nLInic,  1035, "OUTROS"  , oFont08)
Else
	oDacte:Say(nLInic,  0635, "EXPEDIDOR"  , oFont08)
	oDacte:Say(nLInic,  1035, "OUTROS"     , oFont08)
EndIf                	

oDacte:Say(nLInic,  1450, aCab[6], oFont08)
oDacte:Say(nLInic,  1900, AllTrim((cAliasCT)->DES_SUFRAMA), oFont08)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TMSR25Comp³ Autor ³Andre Sperandio        ³ Data ³04/12/09  ³±±
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
Static Function TMSR25Comp(lXml)
Local cAliasDT8   	:= GetNextAlias()
Local cAliasRBC		:= ''
Local cLabel      	:= ''
Local nSoma       	:= 0
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
Local lElectrolux  := .F.  // Por: Ricardo
Local aComp			:= {} 
                       
// --- {2LGI Especifico GEFCO - CT-e
Local _aDT3			:= {} 

If ValType(lXml) != 'L'
	lXml:= (MV_PAR08 == 1)
EndIf
//-- Buscar XML do WebService

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: COMPONENTES DA PRESTACAO                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma   := 26
nDifEsq := 168
nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)

oDacte:Box(nLInic , 0030, (nLFim + nDifEsq)                             , 2370)
oDacte:Say(nLInic , 0850, "Componentes do Valor da Prestação de Serviço", oFont08N)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: VALOR TOTAL DO SERVICO                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma   := 12
nDifEsq := 150
nLInic  += Char2PixV(oDacte,"X",oFont08) + nSoma
nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08) + nSoma)

oDacte:Box(nLInic	 , 1700, (nLFim + nDifEsq), 2370)
oDacte:Line(nLInic, 0030, nLInic           , 2370) // Linha: Componentes da Prestacao

nCInic := 35
For nCount := 1 To 6
	lControl := !lControl

	If (lControl == .T.)
		cLabel := "Nome"
	Else
		cLabel := "Valor"
	EndIf

	If (nCount > 1)
		oDacte:Line(nLInic, (nCInic - 5), (nLFim + nDifEsq), (nCInic - 5)) // Linha: Separador
	EndIf

	oDacte:Say(nLInic , nCInic, cLabel, oFont08N)
	nCInic += 278
Next nCount
 
oDacte:Say(nLInic , 1710, "Valor Total do Serviço", oFont08N)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Componentes do Valor da Prestacao de Servico                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³DT8 - Componentes do Frete                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma    := 12
nDifEsq  := 50
nLInic   += Char2PixV(oDacte,"X",oFont08N) + nSoma
nLFim    := (nLInic + Char2PixV(oDacte,"X",oFont08N) + nSoma)
nCount   := 0
nCount_2 := 0
lControl := .F.

nCInic := 35
If (lXml)

	aComp := TMSGetComp( oNfe )
	
	For nCount_3 := 1 To Len( aComp )
		nCount += 2
		oDacte:Say(nLInic, nCInic, AllTrim(aComp[nCount_3][1]), oFont08)
		
		nCInic += 278
		oDacte:Say(nLInic, nCInic, Transform(Val(AllTrim(aComp[nCount_3][2])),'@E 999,999.99'), oFont08)
		
		nCInic += 278
		
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
					oDacte :Line(nLInic, 1700, nLInic, 2370) // Linha: VALOR A RECEBER
					cLabel := "Valor a Receber"
				Case ( nCount_2 == 4 )
					cLabel := PadL(Transform(Val(oNFE:_CTE:_INFCTE:_VPREST:_VREC:TEXT),'@E 999,999.99'),20)
			EndCase
			
			oDacte:Say(nLInic , 1710, cLabel, oFont10N)
			nSoma    := 12
			nLInic   += Char2PixV(oDacte,"X",oFont08N) + nSoma
			nCInic   := 35
		EndIf
	Next nCount_3	
	For nCount := (1 + nCount) To 24
		lControl := !lControl
		nCInic   += 278
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
					oDacte:Line(nLInic, 1700, nLInic, 2370) // Linha: VALOR A RECEBER
					cLabel := "Valor a Receber"
				Case ( nCount_2 == 4 )
					cLabel := PadL(Transform(Val(oNFE:_CTE:_INFCTE:_VPREST:_VREC:TEXT),'@E 999,999.99'),20)
			EndCase
			
			oDacte:Say(nLInic , 1710, cLabel, oFont10N)
			
			nSoma    := 12
			nLInic   += Char2PixV(oDacte,"X",oFont08N) + nSoma
			nCInic   := 35
		EndIf
	Next nCount
Else
	cQuery := ""
	cQuery += " SELECT DOCCOMP.DT8_VALTOT, " +CRLF
	cQuery += " 		 DOCCOMP.DT8_VALPAS, " +CRLF
	cQuery += " 		 DOCCOMP.DT8_VALIMP, " +CRLF	// Por: Ricardo
	cQuery += " 		 COMP.DT3_DESCRI, " +CRLF  
	// --- {2LGI Espcecifico GEFCO - CT-e
	cQuery += " 		 COMP.DT3_COLIMP " +CRLF
	// --- {2LGI Fim especifico GEFCO - CT-e
	cQuery += "   FROM " + RetSqlName('DT8') + " DOCCOMP " +CRLF
	cQuery += " 		 INNER JOIN  " + RetSqlName('DT3') + " COMP " +CRLF
	cQuery += " 				   ON ( COMP.DT3_FILIAL='" + xFilial("DT3") + "'" +CRLF
	cQuery += " 					AND COMP.DT3_FILIAL = DOCCOMP.DT8_FILIAL " +CRLF
	cQuery += "						AND COMP.DT3_CODPAS = DOCCOMP.DT8_CODPAS " +CRLF
	cQuery += "						AND COMP.D_E_L_E_T_=' ')" +CRLF
	cQuery += "  WHERE DOCCOMP.DT8_FILIAL  = '" + xFilial("DT8") + "'" +CRLF
	cQuery += "    AND DOCCOMP.DT8_FILDOC  = '" + AllTrim((cAliasCT)->DT6_FILDOC)	+ "'" +CRLF
	cQuery += "    AND DOCCOMP.DT8_DOC     = '" + AllTrim((cAliasCT)->DT6_DOC)		+ "'" +CRLF
	cQuery += "    AND DOCCOMP.DT8_SERIE   = '" + AllTrim((cAliasCT)->DT6_SERIE)	+ "'" +CRLF
	cQuery += "    AND DOCCOMP.D_E_L_E_T_  = ' '" 
	// --- {2LGI Espcecifico GEFCO - CT-e
	cQuery += "  ORDER BY COMP.DT3_COLIMP"   
	// --- {2LGI Fim especifico GEFCO - CT-e
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasDT8, .F., .T.)
   
	// --- {2LGI  Especifico GEFCO CT-e
	nValImp  := 0.00
	
	While !(cAliasDT8)->(Eof())
	   
		_nPos	:= Ascan( _aDT3, {|x| x[1] == (cAliasDT8)->DT3_COLIMP } )
		If _nPos == 0
			Aadd ( _aDT3 , { (cAliasDT8)->DT3_COLIMP, (cAliasDT8)->DT3_DESCRI, (cAliasDT8)->DT8_VALPAS, (cAliasDT8)->DT8_VALTOT, (cAliasDT8)->DT8_VALIMP } )
		Else
			_aDT3[_nPos, 3]	+= (cAliasDT8)->DT8_VALPAS
			_aDT3[_nPos, 4]	+= (cAliasDT8)->DT8_VALTOT
			_aDT3[_nPos, 5]	+= (cAliasDT8)->DT8_VALIMP
		EndIf
		nValImp += (cAliasDT8)->DT8_VALIMP		

		(cAliasDT8)->(dbSkip())
		
	EndDo

	// Por: Ricardo Guimarães - Em: 07/08/2013 - Objetivo: Atender cliente Electrolux - Parâmetro MV_XELETRO contém o(s) código(s) de cliente+loja
	lElectrolux := AllTrim((cAliasCT)->DT6_CLIDEV) + AllTrim((cAliasCT)->DT6_LOJDEV) $ GETNEWPAR("MV_XELETRO","15883000|15853900|02943100|15886800") // Produção: 15883000
   /*
	cCampoComp:= IIF(lEletrolux,"QDT8->VALPAS", "QDT8->VALTOT")
	nImposto  := IIF(lEletrolux,(cString)->VALICM,0)
	nOutros   := IIF(lEletrolux,nImposto,0)
   */

	// Tratamento para Electrolux - Inclusão do Imposto
	If lElectrolux
		Aadd ( _aDT3 , { "99", "IMPOSTO", nValImp, 0.00, (cAliasDT8)->DT8_VALIMP } )
	EndIf	
	
	// ---While !(cAliasDT8)->(Eof())
	_nX	:= 1
	While _nX <= Len(_aDT3)
		nCount += 2
		// ---oDacte:Say(nLInic, nCInic, SubStr(AllTrim((cAliasDT8)->DT3_DESCRI),1,12)   , oFont08)
		oDacte:Say(nLInic, nCInic, SubStr(AllTrim(_aDT3[_nX,2]),1,12)   , IIF(_aDT3[_nX,2]="IMPOSTO",oFont08N,oFont08))
		
		nCInic += 278
		If lCTEVFRE .OR. lElectrolux  // Valor sem Imposto
			// --- oDacte:Say(nLInic, nCInic, Transform((cAliasDT8)->DT8_VALPAS, '@E 9,999,999.99'), oFont08)
			oDacte:Say(nLInic, nCInic, Transform(_aDT3[_nX,3], '@E 9,999,999.99'), IIF(_aDT3[_nX,2]="IMPOSTO",oFont08N,oFont08))
		Else
			// --- oDacte:Say(nLInic, nCInic, Transform((cAliasDT8)->DT8_VALTOT, '@E 9,999,999.99'), oFont08)
			oDacte:Say(nLInic, nCInic, Transform(_aDT3[_nX,4], '@E 9,999,999.99'), oFont08)
		EndIf
		
		
		nCInic += 278
		
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
					oDacte :Line(nLInic, 1700, nLInic, 2370) // Linha: VALOR A RECEBER
					cLabel := "Valor a Receber"
				Case ( nCount_2 == 4 )
					cLabel := Transform((cAliasCT)->DT6_VALFAT,'@E 999,999.99')
			EndCase

			oDacte:Say(nLInic , 1710, cLabel, oFont10N)

			nSoma    := 12
			nLInic   += Char2PixV(oDacte,"X",oFont08N) + nSoma
			nCInic   := 35
		EndIf
		
		// --- (cAliasDT8)->(DbSkip())
		_nX++
		
	EndDo
	For nCount := (1 + nCount) To 24
		lControl := !lControl
		nCInic   += 278
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
					oDacte:Line(nLInic, 1700, nLInic, 2370) // Linha: VALOR A RECEBER
					cLabel := "Valor a Receber"
				Case ( nCount_2 == 4 )
					cLabel := PadL(Transform((cAliasCT)->DT6_VALFAT,'@E 999,999.99'),20)
			EndCase
			
			oDacte:Say(nLInic , 1710, cLabel, oFont10N)
			
			nSoma    := 12
			nLInic   += Char2PixV(oDacte,"X",oFont08N) + nSoma
			nCInic   := 35
		EndIf
	Next nCount
	
	(cAliasDT8)->(dbCloseArea())
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: INFORMACOES RELATIVAS AO IMPOSTO                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma   := 12
nDifEsq := 64
nLInic  += Char2PixV(oDacte,"X",oFont08N) + nSoma
nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08N) + nSoma)

oDacte:Box(nLInic , 0030, (nLFim + nDifEsq), 2370)
oDacte:Say(nLInic , 0900, "Informações Relativas ao Imposto", oFont08N)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INFORMACOES RELATIVAS AO IMPOSTO                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma   := 12                                                                     
nDifEsq := 30
nLInic  += Char2PixV(oDacte,"X",oFont08N) + nSoma
nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08N) + nSoma)

oDacte:Line(nLInic, 0030, nLInic               , 2370)
oDacte:Line(nLInic, 0990, (nLFim + nDifEsq)    , 0990) // Linha: Separador Base de Calculo
oDacte:Line(nLInic, 1310, (nLFim + nDifEsq)    , 1310) // Linha: Separador Aliq.ICMS
oDacte:Line(nLInic, 1490, (nLFim + nDifEsq)    , 1490) // Linha: Separador Valor ICMS
oDacte:Line(nLInic, 1810, (nLFim + nDifEsq)    , 1810) // Linha: Separador %Red Bc.Calc
oDacte:Line(nLInic, 2060, (nLFim + nDifEsq)    , 2060) // Linha: Separador ICMS ST

oDacte:Say(nLInic , 0035, "Situação Tributária", oFont08N)
oDacte:Say(nLInic , 1000, "Base de Cálculo"    , oFont08N)
oDacte:Say(nLInic , 1320, "Aliq.ICMS"          , oFont08N)
oDacte:Say(nLInic , 1500, "Valor ICMS"         , oFont08N)
oDacte:Say(nLInic , 1820, "%Red.Bc.Calc."      , oFont08N)
oDacte:Say(nLInic , 2070, "ICMS ST"            , oFont08N)

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

		ElseIf SubStr((cAliasImp)->FT_CLASFIS, 2, 2) $ "10,30,60,70"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ - 80: ICMS pagto atribuido ao tomador ou ao 3o previsto para    ³
			//³ substituicao tributaria                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cBaseIcms	:= (cAliasImp)->FT_BASEICM
			cAliqIcms 	:= (cAliasImp)->FT_ALIQICM
			cValIcms 	:= (cAliasImp)->FT_VALICM
			cIcmsSt		:= (cAliasImp)->FT_ICMSRET

		ElseIf SubStr((cAliasImp)->FT_CLASFIS, 2, 2) $ '20,90' .Or. AllTrim((cAliasCT)->CFOP) $ "5932,6932"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ - 81: ICMS DEVIDOS A OUTRAS UF'S                                ³
			//³ - 90: ICMS Outros                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cAliasRBC := GetNextAlias()
			cQuery := " SELECT F4_BASEICM " + CRLF
			cQuery += "   FROM " + RetSqlName("SD2") + " D2," + RetSqlName("SF4") + " F4 " + CRLF
			cQuery += "  WHERE D2.D2_FILIAL  = '"  + xFilial('SD2')	+ "'" + CRLF
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
				cRedBCalc := AllTrim(Str(100-(cAliasRBC)->F4_BASEICM ))
			EndIf
			
			(cAliasRBC)->(DbCloseArea())
			
			cBaseIcms	:= (cAliasImp)->FT_BASEICM
			cAliqIcms	:= (cAliasImp)->FT_ALIQICM
			cIcmsSt		:= (cAliasImp)->FT_ICMSRET
		EndIf
	EndIf
	(cAliasImp)->(DbCloseArea())
ElseIF !Type("oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP")=="U"
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ VALORES DE CTE-COMPLEMENTAR                                     ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS00>     - COMPLEMENTAR                                 ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If !Type("oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS00:_CST:TEXT")=="U"

		cAliasImp := DataSource( 'IMPOSTOS' )
		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS00:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS00:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

		cBaseIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS00:_VBC:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS00:_VBC:TEXT) ))
		cAliqIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS00:_PICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS00:_PICMS:TEXT) ))
		cValIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS00:_VICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS00:_VICMS:TEXT) ))
//		cIcmsSt		:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS00:_CST:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS00:_CST:TEXT) ))
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS45>       - COMPLEMENTAR                               ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !Type("oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS45:_CST:TEXT") == "U"

		cAliasImp := DataSource( 'IMPOSTOS' )
		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS45:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS45:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

		cBaseIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS45:_VBC:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS45:_VBC:TEXT) ))
		cAliqIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS45:_PICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS45:_PICMS:TEXT) ))
		cValIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS45:_VICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS45:_VICMS:TEXT) ))
//		cIcmsSt		:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS45:_CST:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS45:_CST:TEXT) ))
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS90>   - COMPLEMENTAR                                   ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !Type("oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS90:_CST:TEXT") == "U"

		cAliasImp := DataSource( 'IMPOSTOS' )
		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS90:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS90:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

		cBaseIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS90:_VBC:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS90:_VBC:TEXT) ))
		cAliqIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS90:_PICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS90:_PICMS:TEXT) ))
		cValIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS90:_VICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS90:_VICMS:TEXT) ))
//		cIcmsSt		:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS90:_CST:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS90:_CST:TEXT) ))
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS20>      - COMPLEMENTAR                                ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !Type("oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS20:_CST:TEXT") == "U"

		cAliasImp := DataSource( 'IMPOSTOS' )
		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS20:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS20:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

		cBaseIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS20:_VBC:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS20:_VBC:TEXT) ))
		cAliqIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS20:_PICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS20:_PICMS:TEXT) ))
		cValIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS20:_VICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS20:_VICMS:TEXT) ))
//		cIcmsSt		:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS20:_CST:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS20:_CST:TEXT) ))
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS60>    - COMPLEMENTAR                                  ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !Type("oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS60:_CST:TEXT") == "U"

		cAliasImp := DataSource( 'IMPOSTOS' )
		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS60:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS60:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

		cBaseIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS60:_VBC:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS60:_VBC:TEXT) ))
		cAliqIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS60:_PICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS60:_PICMS:TEXT) ))
		cValIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS60:_VICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS60:_VICMS:TEXT) ))
//		cIcmsSt		:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS60:_CST:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_INFCTECOMP:_IMPCOMP:_ICMSCOMP:_ICMS60:_CST:TEXT) ))
	EndIf

Else
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS00>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT")=="U"

		cAliasImp := DataSource( 'IMPOSTOS' )
		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

		cBaseIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT) ))
		cAliqIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT) ))
		cValIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT) ))
//		cIcmsSt		:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT")  =="U"," ", (oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_CST:TEXT) ))
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS45>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT") == "U"

		cAliasImp := DataSource( 'IMPOSTOS' )
		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

//		cIcmsSt		:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS45:_CST:TEXT) ))
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS90>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT") == "U"

		cAliasImp := DataSource( 'IMPOSTOS' )
		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )

		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )

		cBaseIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VBC:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VBC:TEXT) ))
		cAliqIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_PICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_PICMS:TEXT) ))
		cValIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VICMS::TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VICMS:TEXT) ))
//		cIcmsSt		:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_CST:TEXT) ))
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS20>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT") == "U"

		cAliasImp := DataSource( 'IMPOSTOS' )
		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )
		
		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )
		
		cBaseIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VBC:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VBC:TEXT) ))
		cAliqIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_PICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_PICMS:TEXT) ))
		cValIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VICMS:TEXT) ))
//		cIcmsSt		:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_CST:TEXT) ))
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Tag <ICMS60>                                                    ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	ElseIf !Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT") == "U"

		cAliasImp := DataSource( 'IMPOSTOS' )
		cAliasD2  := DataSource( 'DESCRSUBSTTRIBUTARIA' )
		
		cSitTriba	:= Iif( Type("oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT")=="U"," ",;
		oNfe:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT + " - " + SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,40) )
		
		cBaseIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VBC:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VBC:TEXT) ))
		cAliqIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_PICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_PICMS:TEXT) ))
		cValIcms	:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VICMS:TEXT")=="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VICMS:TEXT) ))
//		cIcmsSt		:= Val(Iif( Type("oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT")  =="U"," ",(oNFE:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_CST:TEXT) ))
	EndIf

Endif //-- !XML

nSoma  := 12
nLInic += Char2PixV(oDacte,"X",oFont08N) + nSoma

oDacte:Say(nLInic , 0035, cSitTriba,								oFont08)
oDacte:Say(nLInic , 1000, Transform(cBaseIcms , '@E 999,999.99'),	oFont08)
oDacte:Say(nLInic , 1320, Transform(cAliqIcms , '@E 999,999.99'),	oFont08)
oDacte:Say(nLInic , 1500, Transform(cValIcms  , '@E 999,999.99'),	oFont08)
oDacte:Say(nLInic , 1820, Transform(cRedBcCalc, '@E 999,999.99'),	oFont08)
oDacte:Say(nLInic , 2070, Transform(cIcmsSt   , '@E 999,999.99'),	oFont08)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TMSR25Cmp³ Autor ³Andre Sperandio        ³ Data ³04/12/09  ³±±
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
Static Function TMSR25Cmp()

Local nCount    := 0
Local nCount_2  := 0
Local nSoma     := 0
Local oFont08   := TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
Local oFont08N  := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Local lControl  := .F.
Local cAliasChv := ''


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BOX: COMPONENTES DO VALOR DA PRESTACAO DO SERVICO                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma   := 20
nDifEsq := 282
nLInic  += Char2PixV(oDacte,"X",oFont08N) + nSoma
nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08N) + nSoma)

oDacte:Box(nLInic , 0030, (nLFim + nDifEsq)       , 2370) //
oDacte:Say(nLInic , 0850, "Componentes do Valor da Prestação do Serviço", oFont08N)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma   := 12
nDifEsq := 250
nLInic  += Char2PixV(oDacte,"X",oFont08N) + nSoma
nLFim   := (nLInic + Char2PixV(oDacte,"X",oFont08N) + nSoma)

oDacte:Line(nLInic, 0030, nLInic              , 2370)		// Linha: DOCUMENTOS ORIGINARIOS
oDacte:Line(nLInic, 1165, (nLFim + nDifEsq)   , 1165)	// Linha: Separador DOCUMENTOS ORIGINARIOS

oDacte:Say(nLInic , 0035, "Chave do CT-e Complementado", oFont08N)
oDacte:Say(nLInic , 0840, "Valor Complementado", oFont08N)
oDacte:Say(nLInic , 1175, "Chave do CT-e Complementado", oFont08N)
oDacte:Say(nLInic , 2040, "Valor Complementado", oFont08N)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma    := 12
nDifEsq  := 50
nLInic   += Char2PixV(oDacte,"X",oFont08N) + nSoma
nLFim    := (nLInic + Char2PixV(oDacte,"X",oFont08N) + nSoma)
nCount   := 0
nCount_2 := 0
lControl := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ COMPONENTES DO VALOR DA PRESTACAO DO SERVICO                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
			oDacte:Say(nLInic, 0045, Transform(AllTrim((cAliasChv)->DT6_CHVCTE),"@!")	, oFont08)
			oDacte:Say(nLInic, 0840, PadL(Transform((cAliasCT)->DT6_VALFAT,'@E 9,999,999.9999'),20), oFont08)
		Else
			oDacte:Say(nLInic, 1175, Transform(AllTrim((cAliasChv)->DT6_CHVCTE),"@!")	, oFont08)
		EndIf

	EndIf

	(cAliasChv)->(DbSkip())

EndDo

// Solicitacao para que sejam "calculadas" as linhas faltantes para completar o BOX
nLInic  := CalcLinha((1 + nCount), 16, nLInic, 12, oDacte, oFont08N, 2)
(cAliasChv)->(dbCloseArea())

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³AjustaSX1     ³ Autor ³ Andre Godoi          ³ Data ³10.04.2008³±±
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

//-- Tipo do Documento.
aHelpPor := { "Informe o Tipo de Operacao"      }
aHelpEng := { "Enter the Operation Type"        }
aHelpEsp := { "Introduzca el Tipo de operacion" }
PutSx1(	"RTMSR25", "09", "Tipo de Operacao ?", "Tipo de operacion ?", "Operation Type", ;
			"MV_CH9", "N", 1, 0, 2, "C", "", "", "", "", ;
			"MV_PAR09", "Entrada", "Entrada", "Inflow", "", "Saida", "Salida", "OutFLow", "", ;
			"", "", "", "N", "", "", "", "", ;
			aHelpPor, aHelpEng, aHelpEsp ) 

// --- {2LGI - Especifico GEFCO }
aHelpPor := { "Selecione a unidade de negocio ou todos" }
aHelpEng := { "Selecione a unidade de negocio ou todos" }
aHelpEsp := { "Selecione a unidade de negocio ou todos" }
PutSx1(	"RTMSR25", "10", "Unidade de Negocio ?", "Unidade de Negocio ?", "Unidade de Negocio ?", ;
			"MV_CHA", "N", 1, 0, 1, "C", "", "", "", "", ;
			"MV_PAR10",;
			"OVL "  , "OVL "  , "OVL"  ,"",;
			"OVS"   , "OVS"   , "OVS"  ,;
			"FVL"   , "FVL"   , "FVL"  ,;
			"Todos" , "Todos" , "Todos",;
			"" , "" , "",;
			aHelpPor, aHelpEng, aHelpEsp, ".RTMSR2510." )

aHelpPor := { "Selecione a ordem de impressao dos documentos" }
aHelpEng := { "Selecione a ordem de impressao dos documentos" }
aHelpEsp := { "Selecione a ordem de impressao dos documentos" }
PutSx1(	"RTMSR25", "11", "Ordem de impressao ?", "Ordem de impressao ?", "Ordem de impressao ?", ;
			"MV_CHB", "N", 1, 0, 1, "C", "", "", "", "", ;
			"MV_PAR11",;
			"CT-e + Serie" , "CT-e + Serie" , "CT-e + Serie" ,"",;
			"UF+Munic+CNPJ", "UF+Munic+CNPJ", "UF+Munic+CNPJ",; 
			"" , "" , "",;
			"" , "" , "",;
			"" , "" , "",;
			aHelpPor, aHelpEng, aHelpEsp, ".RTMSR2511." ) 
// --- {2LGI - Fim especifico GEFCO }


RestArea(aArea)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR25   ºAutor  ³Microsiga           º Data ³  03/17/11   º±±
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

If Valtype(XmlChildEx(oObject:_CTE:_INFCTE,"_INFCTECOMP")) <> "U"    //Complemento
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
Else
	If	ValType(oObject:_CTE:_INFCTE:_VPREST:_COMP) == "A"
		aAuxClone := ACLONE( oObject:_CTE:_INFCTE:_VPREST:_COMP )
		For i := 1 To Len( aAuxClone )
			AADD( aResult, {AllTrim(aAuxClone[ i ]:_XNOME:TEXT), AllTrim(aAuxClone[ i ]:_VCOMP:TEXT)} )
		Next i
	ElseIf	ValType(oObject:_CTE:_INFCTE:_VPREST:_COMP) == "O"
		AADD( aAuxComp, AllTrim(oObject:_CTE:_INFCTE:_VPREST:_COMP:_XNOME:TEXT) )
		AADD( aAuxComp, AllTrim(oObject:_CTE:_INFCTE:_VPREST:_COMP:_VCOMP:TEXT) )
		AADD( aResult, aAuxComp )
		aAuxComp := {}
	EndIf
EndIf	

Return ( aResult )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTMSR25   ºAutor  ³Microsiga           º Data ³  03/18/11   º±±
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
±±ºPrograma  ³RTMSR25   ºAutor  ³Microsiga           º Data ³  03/18/11   º±±
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
	cQuery += "    SELECT " + CRLF
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
   // --- {2LGI - Especifico GEFCO - CT-e}
	cQuery += "    CTRC.DT6_CCUSTO,                " +CRLF
	cQuery += "    CTRC.DT6_CCONT,                 " +CRLF
	cQuery += "    CTRC.DT6_CONTA,                 " +CRLF
	cQuery += "    CTRC.DT6_TABFRE,                " +CRLF     
	cQuery += "	   CTRC.DT6_NUMAGD,				   " +CRLF
	cQuery += "	   CTRC.DT6_VALIMP,				   " +CRLF	
   // --- {2LGI - Fim especifico GEFCO
	cQuery += "    CLIREM.A1_NOME REM_NOME,        " +CRLF
	cQuery += "    CLIREM.A1_END REM_END,          " +CRLF
	cQuery += "    CLIREM.A1_BAIRRO REM_BAIRRO,    " +CRLF
	cQuery += "    CLIREM.A1_MUN REM_MUNICI,       " +CRLF
	cQuery += "    CLIREM.A1_EST REM_UF,           " +CRLF
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
	cQuery += "    CLIDES.A1_MUN DES_MUNICI,       " +CRLF
	cQuery += "    CLIDES.A1_EST DES_UF,           " +CRLF
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
	cQuery += "    NF_LF.F2_LOJA                   " + CRLF

	cQuery += "   FROM " + RetSqlName('DT6') + " CTRC " + CRLF
	cQuery += "        LEFT  JOIN " + RetSqlName('SF2') + " NF_LF ON (NF_LF.F2_FILIAL = '" + xFilial('SF2') + "' AND NF_LF.F2_FILIAL = CTRC.DT6_FILDOC AND NF_LF.F2_DOC = CTRC.DT6_DOC AND NF_LF.F2_SERIE = CTRC.DT6_SERIE AND NF_LF.F2_CLIENTE = CTRC.DT6_CLIDEV AND NF_LF.F2_LOJA = CTRC.DT6_LOJDEV AND NF_LF.D_E_L_E_T_ = ' ')" + CRLF
	cQuery += "        INNER JOIN " + RetSqlName('SF3') + " LFISCAL ON(LFISCAL.F3_FILIAL = CTRC.DT6_FILDOC AND LFISCAL.F3_NFISCAL = CTRC.DT6_DOC AND LFISCAL.F3_SERIE = CTRC.DT6_SERIE AND LFISCAL.F3_CLIEFOR = CTRC.DT6_CLIDEV AND LFISCAL.F3_LOJA = CTRC.DT6_LOJDEV) " + CRLF
	cQuery += "        INNER JOIN " + RetSqlName('SA1') + " CLIREM ON (CLIREM.A1_COD = CTRC.DT6_CLIREM AND CLIREM.A1_LOJA = CTRC.DT6_LOJREM) " + CRLF
	cQuery += "        INNER JOIN " + RetSqlName('SA1') + " CLIDES ON (CLIDES.A1_COD = CTRC.DT6_CLIDES AND CLIDES.A1_LOJA = CTRC.DT6_LOJDES AND CLIDES.D_E_L_E_T_ = ' ' ) " + CRLF
	cQuery += "        INNER JOIN " + RetSqlName('SA1') + " CLIDEV ON (CLIDEV.A1_COD = CTRC.DT6_CLIDEV AND CLIDEV.A1_LOJA = CTRC.DT6_LOJDEV AND CLIDEV.D_E_L_E_T_ = ' ' ) " + CRLF
	cQuery += "        LEFT  JOIN " + RetSqlName('SA1') + " CLICON ON (CLICON.A1_FILIAL = '" + xFilial('SA1') + "' AND CLICON.A1_COD = CTRC.DT6_CLICON AND CLICON.A1_LOJA = CTRC.DT6_LOJCON AND CLICON.D_E_L_E_T_ = ' ' ) " + CRLF
	cQuery += "        LEFT  JOIN " + RetSqlName('SA1') + " CLIDPC ON (CLIDPC.A1_FILIAL = '" + xFilial('SA1') + "' AND CLIDPC.A1_COD = CTRC.DT6_CLIDPC AND CLIDPC.A1_LOJA = CTRC.DT6_LOJDPC AND CLIDPC.D_E_L_E_T_ = ' ' ) " + CRLF
	cQuery += "        INNER JOIN " + RetSqlName('DTP') + " LOTE   ON (LOTE.DTP_FILORI = CTRC.DT6_FILORI AND LOTE.DTP_LOTNFC = CTRC.DT6_LOTNFC AND "
	cQuery += "        LOTE.D_E_L_E_T_ = ' ')" + CRLF

	cQuery += "  WHERE CTRC.DT6_FILIAL  = '" + xFilial('DT6') + "'" + CRLF
	cQuery += "    AND CTRC.DT6_FILORI  = '" + cFilAnt  + "'" + CRLF
	cQuery += "    AND CTRC.DT6_LOTNFC >= '" + MV_PAR01 + "'" + CRLF
	cQuery += "    AND CTRC.DT6_LOTNFC <= '" + MV_PAR02 + "'" + CRLF

	cQuery += "    AND (CTRC.DT6_IDRCTE  = '100' OR (CTRC.DT6_CHVCTG  <> ' ' AND SUBSTRING(DT6_RETCTE,1,3) = '004'))" + CRLF

	cQuery += "    AND CTRC.DT6_DOC    >= '" + MV_PAR03 + "'" + CRLF
	cQuery += "    AND CTRC.DT6_DOC    <= '" + MV_PAR04 + "'" + CRLF
	cQuery += "    AND CTRC.DT6_SERIE  >= '" + MV_PAR05 + "'" + CRLF
	cQuery += "    AND CTRC.DT6_SERIE  <= '" + MV_PAR06 + "'" + CRLF
	If !Empty(MV_PAR07)
		cQuery += "    AND CTRC.DT6_DOCTMS  = '" + MV_PAR07 + "'" + CRLF
	EndIf
	
	// --- { 2LGI - Especifico GEFCO - CT-e  
	// --- Verifica selecao de unidade de negocio
	If Mv_par10 < 4
		// --- OVL
		If Mv_par10  == 1
			cQuery += "    AND SUBSTRING(CTRC.DT6_CCUSTO,1,3)  = '211' " + CRLF
		// --- OVS   
		ElseIf Mv_par10 == 2  
			cQuery += "    AND SUBSTRING(CTRC.DT6_CCUSTO,1,3)  = '322' " + CRLF
		// --- FVL   
		ElseIf Mv_par10 == 3  
			cQuery += "    AND SUBSTRING(CTRC.DT6_CCUSTO,1,3)  = '101' OR SUBSTRING(CTRC.DT6_CCUSTO,1,3) = '102' " + CRLF
		EndIf
	EndIf
	// --- { 2LGI - Fim especifico GEFCO 
	
	cQuery += "    AND CTRC.D_E_L_E_T_  = ' ' " + CRLF                                                 

	cQuery += "  AND LFISCAL.F3_FILIAL = '" + xFilial('SF3') + "'" + CRLF
	cQuery += "  AND LFISCAL.D_E_L_E_T_= ' '" + CRLF

	cQuery += "  AND CLIREM.A1_FILIAL  = '"  + xFilial('SA1') + "'" + CRLF
	cQuery += "  AND CLIREM.D_E_L_E_T_ = ' '" + CRLF

	cQuery += "  AND CLIDES.A1_FILIAL  = '"  + xFilial('SA1') + "'" + CRLF
	cQuery += "  AND CLIDES.D_E_L_E_T_ = ' '" + CRLF

	cQuery += "  AND CLIDEV.A1_FILIAL  = '"  + xFilial('SA1') + "'" + CRLF
	cQuery += "  AND CLIDEV.D_E_L_E_T_ = ' '" + CRLF

	cQuery += "  AND LOTE.DTP_FILIAL   = '" + xFilial('DTP') + "'" + CRLF
	cQuery += "  AND LOTE.D_E_L_E_T_   = ' '" + CRLF
   
	// --- {2LGI - Especifico GEFCO - CT-e
	// --- Seleciona ordem de impressao dos documentos
	If Mv_par11 == 1
		// --- Filial do documento, documento e serie
		cQuery += "  ORDER BY CTRC.DT6_FILDOC, " + CRLF
		cQuery += "           CTRC.DT6_DOC,    " + CRLF
		cQuery += "           CTRC.DT6_SERIE   "
   ElseIf Mv_par11 == 2
   	// --- UF, Municipio e CNPJ
   	cQuery += " ORDER BY CTRC.DT6_FILDOC, " + CRLF  
   	cQuery += "          CLIDES.A1_EST,   " + CRLF
   	cQuery += "          CLIDES.A1_MUN,   " + CRLF
   	cQuery += "          CLIDES.A1_CGC    " 
	EndIf
	// --- {2LGI - Fim especifico GEFCO

ElseIf cSource == 'SF1'

	cQuery += " SELECT	DISTINCT "
	cQuery += " D1_FILIAL  DT6_FILIAL, " + CRLF
	cQuery += " D1_DOC     DT6_DOC,    " + CRLF
	cQuery += " D1_SERIE   DT6_SERIE,  " + CRLF
	cQuery += " 'M'	       DT6_DOCTMS, " + CRLF
	cQuery += " ''         DT6_PROCTE, " + CRLF
	cQuery += " ''         DT6_FILDOC, " + CRLF
	cQuery += " ''         DT6_SITCTE, " + CRLF
	cQuery += " ''         DT6_RETCTE, " + CRLF
	cQuery += " ''         DT6_LOTNFC, " + CRLF
	cQuery += " ''         DT6_DOCTMS, " + CRLF
	cQuery += " ''         DT6_FILDCO, " + CRLF
	cQuery += " ''         DT6_DOCDCO, " + CRLF
	cQuery += " ''         DT6_SERDCO, " + CRLF
	cQuery += " ''         DT6_DEVFRE, " + CRLF
	cQuery += " ''         DT6_CHVCTG, " + CRLF
	cQuery += " ''         DT6_CHVCTE, " + CRLF
	cQuery += " D1_DOC     F3_NFISCAL, " + CRLF
	cQuery += " D1_SERIE   F3_SERIE,   " + CRLF
	cQuery += " D1_FORNECE F3_CLIEFOR, " + CRLF
	cQuery += " D1_LOJA    F3_LOJA,    " + CRLF
	cQuery += " ''         DES_SUFRAMA " + CRLF
	cQuery += "  FROM " + RetSqlName('SD1') + " CTRC " + CRLF
/*	cQuery += "        INNER JOIN " + RetSqlName('SF3') + " LFISCAL 
	cQuery += "   ON (LFISCAL.F3_FILIAL  = '" + xFilial('SF3') + "'" + CRLF
	cQuery += "   AND LFISCAL.F3_NFISCAL = CTRC.D1_DOC"     + CRLF
	cQuery += "   AND LFISCAL.F3_SERIE   = CTRC.D1_SERIE"   + CRLF
	cQuery += "   AND LFISCAL.F3_CLIEFOR = CTRC.D1_FORNECE" + CRLF
	cQuery += "   AND LFISCAL.F3_LOJA    = CTRC.D1_LOJA"    + CRLF
	cQuery += "   AND LFISCAL.F3_CODRSEF = '100'" + CRLF
	cQuery += "   AND LFISCAL.D_E_L_E_T_ = ' ') " + CRLF*/
	cQuery += " WHERE CTRC.D1_FILIAL = '" + xFilial('SD1') + "'" + CRLF
	cQuery += "   AND CTRC.D1_DOC     BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + CRLF
	cQuery += "   AND CTRC.D1_SERIE   BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " + CRLF

	cQuery += "  ORDER BY DT6_FILIAL, " + CRLF
	cQuery += "           DT6_DOC,    " + CRLF
	cQuery += "           DT6_SERIE   "


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
	//Katia - Comentou, pois as informaÃ§Ãµes dos veÃ­culos estÃ£o no lote e nÃ£o na viagem
	/*
	cQuery    := " SELECT DTR_CODVEI, DTR_CODRB1, DTR_CODRB2 "
	cQuery    += " FROM " + RetSqlName("DTR")+" DTR "
	cQuery    += " WHERE DTR_FILIAL = '"+xFilial('DTR')+"'"
	cQuery    += "   AND DTR_FILORI = '"+(cAliasCT)->DT6_FILORI+"'"
	cQuery    += "   AND DTR_VIAGEM = '"+cViagem+"'"
	cQuery    += "   AND D_E_L_E_T_ = ' '"
	*/
	//Fim do comentÃ¡rio da Katia
	cQuery    := " SELECT DTP_CODVEI AS DTR_CODVEI, DTP_CODRB1 AS DTR_CODRB1, DTP_CODRB2 AS DTR_CODRB2 "
	cQuery    += " FROM " + RetSqlName("DTP")+" DTP "
	cQuery    += " WHERE DTP_FILIAL = '"+xFilial('DTP')+"'"
	cQuery    += "   AND DTP_FILORI = '"+(cAliasCT)->DT6_FILORI+"'"
	cQuery    += "   AND DTP_LOTNFC = '"+(cAliasCT)->DT6_LOTNFC+"'"
	cQuery    += "   AND D_E_L_E_T_ = ' '"
	//Inicio tratamento Gefco
	
	//Fim do tratamento Gefco
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
	cQuery += "   DA3_ALTINT, DA3_LARINT, DA3_COMINT, " + CRLF
	cQuery += "   A2_CGC, A2_NOME, A2_INSCR, A2_EST, A2_TIPO, A2_RNTRC " + CRLF
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
	cQuery += "        SUM(SFT.FT_BASEICM) FT_BASEICM, " + CRLF
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

	cQuery := " SELECT DISTINCT DTC.DTC_PESO, DY3.DY3_ONU, DY3.DY3_DESCRI, DY3.DY3_GRPEMB, DY3.DY3_CLASSE, DY3.DY3_NRISCO "
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

EndIf

cQuery := ChangeQuery( cQuery )

Return ( cQuery )

/************************************************************************
* Funcao....: isCliPSA()                                                *
* Autor.....: Marcelo Aguiar Pimentel                                   *
* Data......: 14/03/2007                                                *
* Descricao.: Verifica se o cliente está cadastrado na tabela SZE(Clien *
*             Peugeot PSA                                               *
*                                                                       *
************************************************************************/
Static Function isCliPSA(pCliente,lCodSap)
Local lRet:=.t.
Local _aArea := GetArea()

dbSelectArea("SZE")
dbSetOrder(1)

If !dbSeek(xFilial("SZE")+pCliente)
	lRet:=.f.
EndIf

RestArea(_aArea)
Return lRet