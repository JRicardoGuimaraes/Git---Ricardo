#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

#DEFINE IMP_SPOOL 2
#DEFINE MAXMENLIN 250                                                // M�ximo de caracteres por linha de dados adicionais
#DEFINE MAXLINOBS 018                                                // M�ximo de linhas nas observa�oes.

User Function DAMDFE(cIdEnt,oDamdfe,oSetup,cFilePrint)

Local aArea     := GetArea()
Local lExistMDfe := .F. 

Private nConsNeg := 0.4 // Constante para concertar o c�lculo retornado pelo GetTextWidth para fontes em negrito.
Private nConsTex := 0.5 // Constante para concertar o c�lculo retornado pelo GetTextWidth.

oDamdfe:SetResolution(72) //Tamanho estipulado para a DamDfe
oDamdfe:SetLandscape()
oDamdfe:SetPaperSize(DMPAPER_A4)
oDamdfe:SetMargin(60,60,60,60)
oDamdfe:lServer := oSetup:GetProperty(PD_DESTINATION)==AMB_SERVER

// ----------------------------------------------
// Define saida de impress�o
// ----------------------------------------------

If oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
	oDamdfe:nDevice := IMP_SPOOL
	// ----------------------------------------------
	// Salva impressora selecionada
	// ----------------------------------------------
	fwWriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
	oDamdfe:cPrinter := oSetup:aOptions[PD_VALUETYPE]
ElseIf oSetup:GetProperty(PD_PRINTTYPE) == IMP_PDF
	oDamdfe:nDevice := IMP_PDF
	// ----------------------------------------------
	// Define para salvar o PDF
	// ----------------------------------------------
	oDamdfe:cPathPDF := oSetup:aOptions[PD_VALUETYPE]
Endif

Private PixelX := oDamdfe:nLogPixelX()
Private PixelY := oDamdfe:nLogPixelY()



RptStatus({|lEnd| DamdfeProc(@oDamdfe,@lEnd,cIdEnt,@lExistMDfe)},"Imprimindo Danfe...")

If lExistMDfe
	oDamdfe:Preview()//Visualiza antes de imprimir
Else
	Aviso("DAMDFE","Nenhum MDF-e a ser impresso nos parametros utilizados.",{"OK"},3)
EndIf


FreeObj(oDamdfe)
oDamdfe := Nil
RestArea(aArea)
Return(.T.)


Static Function DamdfeProc(oDamdfe,lEnd,cIdEnt,lExistMDfe) 

Local aArea		:= GetArea()
Local aAreaCC0		:= {}
Local aNotas		:= {}
Local aXML			:= {}

Local cNaoAut		:= ""
Local cAliasMDF	:= GetNextAlias()
Local cAviso     	:= ""
Local cErro      	:= ""
Local cAutoriza  	:= ""
Local cModalidade	:= ""
Local cCondicao	:= ""
Local cIndex	 	:= ""

Local lQuery		:= .F.

Local oNfe

Local nLenNotas
Local nIndex		:= 0
Local nX			:= 0

If Pergunte("DAMDFE",.T.) 
	
	dbSelectArea("CC0")
	dbSetOrder(1)	
	
	#IFDEF TOP
				
		lQuery		:= .T.
		
		cWhere	  	:= '%'			
		cWhere		+= " CC0_SERMDF = '" + MV_PAR01 + "' " 
		cWhere		+= " AND CC0_NUMMDF >= '" + MV_PAR02 + "' "  
		cWhere		+= " AND CC0_NUMMDF <= '" + MV_PAR03	+ "' "
		cWhere		+= " AND CC0_STATUS = '3' " //Somente MDF-e Autorizados
		cWhere		+= ' %' 
		

		BeginSql Alias cAliasMDF
							
			SELECT	CC0_FILIAL,CC0_DTEMIS,CC0_SERMDF,CC0_NUMMDF,CC0_PROTOC
			FROM %Table:CC0% CC0
			WHERE
			CC0.CC0_FILIAL = %xFilial:CC0% AND			
			%Exp:cWhere% AND
			CC0.%notdel%
		EndSql
					
		
	#ELSE
		cIndex    		:= CriaTrab(NIL, .F.)
		cChave			:= IndexKey(1)
		cCondicao 		:= 'CC0_FILIAL == "' + xFilial("CC0") + '" .And. '
		cCondicao 		+= 'CC0->CC0_SERMDF == "'+ MV_PAR01+'" .And. '
		cCondicao 		+= 'CC0->C00_NUMMDF >="'+ MV_PAR02+'" .And. '
		cCondicao		+= 'CC0->C00_NUMMDF <="'+ MV_PAR03+'" .And. '
		cCondicao		+= 'CC0->C00_STATUS == 3'		
		IndRegua(cAliasMDF, cIndex, cChave, , cCondicao)
		nIndex := RetIndex(cAliasMDF)
        DBSetIndex(cIndex + OrdBagExt())
        DBSetOrder(nIndex + 1)
		DBGoTop()
	
	#ENDIF
	
	While !Eof() .And. xFilial("SF3") == (cAliasMDF)->CC0_FILIAL .And.;
		(cAliasMDF)->CC0_SERMDF == MV_PAR01 .And.;
		(cAliasMDF)->CC0_NUMMDF >= MV_PAR02 .And.;
		(cAliasMDF)->CC0_NUMMDF <= MV_PAR03
					
							
				
		aadd(aNotas,{})
		aadd(Atail(aNotas),(cAliasMDF)->CC0_SERMDF)
		aadd(Atail(aNotas),(cAliasMDF)->CC0_NUMMDF)
					
		dbSelectArea(cAliasMDF)
		dbSkip()
		
		If lEnd
			Exit
		EndIf
	EndDo	
		
	If Len(aNotas) > 0
		aAreaCC0 := CC0->(GetArea())
		aXml := GetXML(cIdEnt,aNotas)
		nLenNotas := Len(aNotas)
		For nX := 1 To nLenNotas
			If !Empty(aXML[nX][2])
				If !Empty(aXml[nX])
					cAutoriza   := aXML[nX][1]
					cModalidade := aXML[nX][4]
				Else
					cAutoriza   := ""		
					cModalidade := "1"			
				EndIf
				If (!Empty(cAutoriza) .Or. Alltrim(aXML[nX][4]) $ "2")
					
					cAviso := ""
					cErro  := ""
					oNfe := XmlParser(aXML[nX][2],"_",@cAviso,@cErro)					
					
					If Empty(cAviso) .And. Empty(cErro)
						ImpDet(@oDamdfe,oNFe,cAutoriza,cModalidade,aXML[nX][5],aXML[nX][6])																	
						lExistMDfe := .T.
					EndIf
					oNfe     := nil
					oNfeDPEC := nil
				Else
					cNaoAut += aNotas[nX][04]+aNotas[nX][05]+CRLF
				EndIf
			EndIf
			
		Next nX
		aNotas := {}
		
		RestArea(aAreaCC0)
		DelClassIntF()
	EndIf
	If !lQuery
		DBClearFilter()
		Ferase(cIndex+OrdBagExt())
	EndIf
	If !Empty(cNaoAut)
		Aviso("SPED","As seguintes notas n�o foram autorizadas: "+CRLF+CRLF+cNaoAut,{"Ok"},3)
	EndIf

EndIF
RestArea(aArea)
Return(.T.)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   � ImpDet   � Autor � Eduardo Riera         � Data �16.11.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Controle de Fluxo do Relatorio.                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto grafico de impressao                    (OPC) ���
���          �ExpC2: String com o XML da NFe                              ���
���          �ExpC3: Codigo de Autorizacao do fiscal                (OPC) ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//----------------------------------------------------------------------
/*/{Protheus.doc} ImpDet
Controle do Fluxo do relatorio.

@author Rafael Iaquinto
@since 27/02/2014
@version 1.0 

@param	oDamdfe 		 Objeto gr�fico da FWMSPrinter 
		oNFe 		 	Objeto XML do MDF-e
		cAutoriza	 	Numero de autoriza��o do MDF-e
		cModalidade	Modalidade que o MDF-e foi autorizado.

@return .T.
/*/
//-----------------------------------------------------------------------

Static Function ImpDet(oDamdfe,oNFe,cAutoriza,cModalidade,cRecDthora,cRecDt)
	
Private oFont07    	:= TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)	//Fonte Times New Roman 07
Private oFont08		:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
Private oFont08N		:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
Private oFont10		:= TFont():New("Times New Roman",10,10,,.F.,,,,.T.,.F.)
Private oFont10N		:= TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
Private oFont12N   	:= TFont():New("Times New Roman",12,12,,.T.,,,,.T.,.F.)	//Fonte Times New Roman 12 Negrito

PrtDamdfe(@oDamdfe,oNfe,cAutoriza,cModalidade,cRecDthora,cRecDt)

Return(.T.)


//-----------------------------------------------------------------------
/*/{Protheus.doc} PrtDamdfe
Impressao do formulario DANFE grafico conforme laytout no formato retrato

@author Rafael Iaquinto
@since 27/02/2014
@version 1.0 

@param	oDamdfe 		 Objeto gr�fico da FWMSPrinter 
		oNFe 		 	Objeto XML do MDF-e
		cAutoriza	 	Numero de autoriza��o do MDF-e
		cModalidade	Modalidade que o MDF-e foi autorizado.

@return .T.
/*/
//-----------------------------------------------------------------------

Static Function PrtDamdfe(oDamdfe,oMdfe,cAutoriza,cModalidade,cRecDthora,cRecDt)

Local lSeqDes	:=.F.

Local cCiot	:= ""
Local cAux		:= ""
Local nCont	:= 0
Local nQCTE	:= 0
Local nQCT		:= 0
Local nQNFE	:= 0
Local nQNF		:= 0
Local nCount	:= 0
Local nX		:= 0

Local aCab			:= {}
Local aMensagem	:= {}

//-- Variaveis Private
Private nLInic		:= 0	// Linha Inicial
Private nLFim		:= 0	// Linha Inicial
Private nDifEsq		:= 0	// Variavel com Diferenca para alinhar os Print da Esquerda com os da Direita
Private cInsRemOpc	:= ''	// Remetente com sequencia de IE
Private nFolhas		:= 0
Private nFolhAtu	:= 1
Private PixelX		:= nil
Private PixelY		:= nil
Private nMM			:= 0
Private lComp		:= .F.	//CTE Complementar
Private oNfe		:= oMdfe

nFolhas := 1

//������������������������������������������������������������������������Ŀ
//� Controla o documento a ser enviado para montagem do cabecalho.         �
//��������������������������������������������������������������������������
nCont += 1

aAdd(aCab, {;
AllTrim(oNfe:_MDFE:_INFMDFE:_IDE:_nMDF:TEXT),;
AllTrim(oNfe:_MDFE:_INFMDFE:_IDE:_SERIE:TEXT),;
AllTrim(STRTRAN( SUBSTR( oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT, 1, AT('T', oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT) - 1) , '-', '')),;
AllTrim(STRTRAN( SUBSTR( oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT, AT('T', oNfe:_MDFE:_INFMDFE:_IDE:_dhEmi:TEXT) + 1, 5) , ':', '')),;
AllTrim(STRTRAN(UPPER(oNFE:_MDFE:_INFMDFE:_ID:TEXT),'MDFE','')),;
AllTrim(cAutoriza),;
AllTrim(cModalidade),;
cRecDt,;
cRecDthora })


nFolhAtu := 1
lSeqDes  :=.F.

oDamdfe:StartPage()

DamdfeCab(@oDamdfe,aCab[nCont],oNfe )

//������������������������������������������������������������������������Ŀ
//� BOX: MODAL RODOVIARIO DE CARGA                                         �
//��������������������������������������������������������������������������
oDamdfe:Box(0165, 0000, 180, 0800)
oDamdfe:Say(0175, 0350, "Modal Rodovi�rio de Carga", oFont08N)

oDamdfe:Box(0180, 0000, 230, 0800)
oDamdfe:Say(0188, 0005, "CIOT", oFont08)
If Type("oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_CIOT") <> "U"
	cCiot:= oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_CIOT:TEXT	
EndIf
oDamdfe:Say(0208, 0010, cCiot, oFont10)

oDamdfe:Box(0180, 0150, 230, 0800)
oDamdfe:Say(0188, 0155, "Qtd. CT-e", oFont08)

If Type("oNfe:_MDFE:_INFMDFE:_TOT:_QCTE") <> "U"
	nQCTE:= oNfe:_MDFE:_INFMDFE:_TOT:_QCTE:TEXT	
EndIf

oDamdfe:Say(0208, 0160, cValtoChar( nQCTE ), oFont10)

oDamdfe:Box(0180, 0280, 230, 0800)
oDamdfe:Say(0188, 0285, "Qtd. CTRC", oFont08)
If Type("oNfe:_MDFE:_INFMDFE:_TOT:_QCT") <> "U"
	nQCT:= oNfe:_MDFE:_INFMDFE:_TOT:_QCT:TEXT	
EndIf

oDamdfe:Say(0208, 0295, cValtoChar(nQCT), oFont10)


oDamdfe:Box(0180, 0410, 230, 0800)
oDamdfe:Say(0188, 0415, "Qtd. NF-e", oFont08)
If Type("oNfe:_MDFE:_INFMDFE:_TOT:_QNFE") <> "U"
	nQNFE := 	oNfe:_MDFE:_INFMDFE:_TOT:_QNFE:TEXT
EndIf

oDamdfe:Say(0208, 0430, cValtoChar(nQNFE), oFont10)

oDamdfe:Box(0180, 0540, 230, 0800)
oDamdfe:Say(0188, 0545, "Qtd. NF", oFont08)
If Type("oNfe:_MDFE:_INFMDFE:_TOT:_QNF") <> "U"
	nQNF := 	oNfe:_MDFE:_INFMDFE:_TOT:_QNF:TEXT
EndIf

oDamdfe:Say(0208, 0565, cValtoChar(nQNF), oFont10)

oDamdfe:Box(0180, 0670, 230, 0800)
oDamdfe:Say(0188, 0675, "Peso Total (Kg)", oFont08)
nQCarga:= oNfe:_MDFE:_INFMDFE:_TOT:_QCARGA:TEXT

oDamdfe:Say(0208, 0685, cValtoChar(nQCarga), oFont10)

oDamdfe:Box(0230, 0000, 245, 0300)
oDamdfe:Say(0237, 0005, "Ve�culo", oFont08)

oDamdfe:Box(0230, 0300, 245, 0800)
oDamdfe:Say(0237, 0305, "Condutor", oFont08)

oDamdfe:Box(0245, 0000, 260, 0150)
oDamdfe:Say(0252, 0005, "Placa", oFont08)

oDamdfe:Box(0245, 0150, 260, 0300)
oDamdfe:Say(0252, 0155, "RNTRC", oFont08)

oDamdfe:Box(0245, 0300, 260, 0400)
oDamdfe:Say(0252, 0305, "CPF", oFont08)

oDamdfe:Box(0245, 0400, 260, 0800)
oDamdfe:Say(0252, 0405, "Nome", oFont08)

//-- Dados da Placa
oDamdfe:Box(0260, 0000, 310, 0150)

oDamdfe:Say(0270, 0005, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_PLACA:TEXT), oFont08)
If Type( 'oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE:_PLACA' ) <> 'U'
	oDamdfe:Say(0278, 0005, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE:_PLACA:TEXT), oFont08)
EndIf

//--- Dados do RNTRC
oDamdfe:Box(0260, 0150, 310, 0300)

If Type('oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_PROP:_RNTRC') <> 'U'
	oDamdfe:Say(0270, 0155, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_PROP:_RNTRC:TEXT), oFont08)
EndIf
If Type( 'oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE:_PROP:_RNTRC' ) <> 'U'
	oDamdfe:Say(0278, 0155, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICREBOQUE:_PROP:_RNTRC:TEXT), oFont08)
EndIf

//--- Vale Pedagio
oDamdfe:Box(0310, 0000, 325, 0300)
oDamdfe:Say(0320, 0005, "Vale Ped�gio", oFont08)

oDamdfe:Box(0325, 0000, 390, 0300)
oDamdfe:Say(0335, 0005, "Respons�vel CNPJ", oFont08)

oDamdfe:Box(0325, 0100, 390, 0300)
oDamdfe:Say(0335, 0105, "Fornecedora CNPJ", oFont08)

oDamdfe:Box(0325, 0200, 390, 0300)
oDamdfe:Say(0335, 0205, "Nro Comprovante", oFont08)

//--- Dados Condutor CPF  e Nome
oDamdfe:Box(0260, 0300, 390, 0400)
oDamdfe:Box(0260, 0400, 390, 0800)


If Type( "oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR" ) <> "A"
	oDamdfe:Say(0270, 0305, Transform(AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR:_CPF:TEXT),"@r 999.999.999-99"), oFont08)
	oDamdfe:Say(0270, 0405, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR:_XNOME:TEXT), oFont08)
Else
	nLinha:= 270
	For nCount := 1 To Len( oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR )
		oDamdfe:Say(nLinha, 0305, Transform(AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR[nCount]:_CPF:TEXT),"@r 999.999.999-99"), oFont08)
		oDamdfe:Say(nLinha, 0405, AllTrim(oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_VEICTRACAO:_CONDUTOR[nCount]:_XNOME:TEXT), oFont08)
		nLinha+= 10
	Next nCount
EndIf

//--- Observacoes
oDamdfe:Box(0390, 0000, 0600, 0800)
oDamdfe:Say(0400, 0005, "Observa��o", oFont08)
If (oNfe:_MDFE:_INFMDFE:_IDE:_TPAMB:TEXT == '2') 
	oDamdfe:Say(0410, 0005, "MANIFESTO GERADO EM AMBIENTE DE HOMOLOGA��O", oFont10N)
EndIf

nLin := 420

If Type("oNfe:_MDfe:_InfMDfe:_infAdic:_infAdFisco:TEXT")<>"U"
	cAux := oNfe:_MDfe:_InfMDfe:_infAdic:_infAdFisco:TEXT	
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf

If Type("oNfe:_MDfe:_InfMDfe:_infAdic:_infCpl:TEXT")<>"U"
	cAux := oNfe:_MDfe:_InfMDfe:_infAdic:_infCpl:TEXT	
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf

nLenMensagens:= Len(aMensagem)

For nX := 1 To Min(nLenMensagens,MAXLINOBS)
  	    	
  	oDamdfe:Say(nLin,0005,aMensagem[nX],oFont08)
  	nLin:= nLin+10
  	  	
Next

if nLenMensagens > MAXLINOBS
	oDamdfe:EndPage()
	oDamdfe:StartPage()
	
	//Box da nova pagina
	oDamdfe:Box(0036, 0000, 0600, 0800)
	oDamdfe:Say(0046,0005,"Continua��o das observa��es...",oFont10N)
	nLin := 0056
		
	For nX := MAXLINOBS+1 To nLenMensagens
  	    	
	  	oDamdfe:Say(nLin,0005,aMensagem[nX],oFont08)
	  	nLin:= nLin+10
  	  	
	Next
		
EndIf


oDamdfe:EndPage()

Return(.T.)



Static Function DamdfeCab(oDamdfe,aCab,oXml)

Local cStartPath	:= GetSrvProfString("Startpath","")
Local cTmsAntt		:= SuperGetMv( "MV_TMSANTT", .F., .F. )	//Numero do registro na ANTT com 14 d�gitos
Local cLogoTp		:= cStartPath + cEmpAnt + cFilAnt + "logodamdfe.bmp"				//Insira o caminho do Logo da empresa, na variavel cLogoTp.
Local cUF           := ""
Local cCodEst       := ""
Local aUF           := {}
Local aAreaSM0      := {}

Private oCab		:= oXml

If IsSrvUnix() .And. GetRemoteType() == 1
	cLogoTp := StrTran(cLogoTp,"/","\")
Endif

//������������������������������������������������������������������������Ŀ
//�Preenchimento do Array de UF                                            �
//��������������������������������������������������������������������������
aAdd(aUF,{"RO","11"})
aAdd(aUF,{"AC","12"})
aAdd(aUF,{"AM","13"})
aAdd(aUF,{"RR","14"})
aAdd(aUF,{"PA","15"})
aAdd(aUF,{"AP","16"})
aAdd(aUF,{"TO","17"})
aAdd(aUF,{"MA","21"})
aAdd(aUF,{"PI","22"})
aAdd(aUF,{"CE","23"})
aAdd(aUF,{"RN","24"})
aAdd(aUF,{"PB","25"})
aAdd(aUF,{"PE","26"})
aAdd(aUF,{"AL","27"})
aAdd(aUF,{"MG","31"})
aAdd(aUF,{"ES","32"})
aAdd(aUF,{"RJ","33"})
aAdd(aUF,{"SP","35"})
aAdd(aUF,{"PR","41"})
aAdd(aUF,{"SC","42"})
aAdd(aUF,{"RS","43"})
aAdd(aUF,{"MS","50"})
aAdd(aUF,{"MT","51"})
aAdd(aUF,{"GO","52"})
aAdd(aUF,{"DF","53"})
aAdd(aUF,{"SE","28"})
aAdd(aUF,{"BA","29"})
aAdd(aUF,{"EX","99"})

//������������������������������������������������������������������������Ŀ
//� BOX: Empresa                                                           �
//��������������������������������������������������������������������������
oDamdfe:Box(0036, 0000, 0140, 0400)
oDamdfe:SayBitmap(0038, 0005,cLogoTp,0300,0040 )		//Logo
oDamdfe:Say(0098, 0005, 'CNPJ: ' + Transform(oCab:_MDFE:_INFMDFE:_EMIT:_CNPJ:TEXT,"@r 99.999.999/9999-99"), oFont08)
oDamdfe:Say(0098, 0110, 'IE: ' + oCab:_MDFE:_INFMDFE:_EMIT:_IE:TEXT, oFont08)	//CNPJ e IE
oDamdfe:Say(0098, 0190, 'RNTRC: ' + IIF(Type("oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_RNTRC") <> "U", oNfe:_MDFE:_INFMDFE:_INFMODAL:_RODO:_RNTRC:TEXT,""),oFont08)	//RNTRC da Empresa

oDamdfe:Say(0108, 0005, oCab:_MDFE:_INFMDFE:_EMIT:_XNOME:TEXT ,oFont08) 	//Nome Comercial
oDamdfe:Say(0118, 0005, oCab:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_XLGR:TEXT+","+oCab:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_NRO:TEXT ,oFont08)	//Endereco
oDamdfe:Say(0128, 0005, oCab:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT,oFont08)	//Bairro
oDamdfe:Say(0138, 0005, oCab:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_UF:TEXT + ' - ' + oCab:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_XMUN:TEXT + '  -  ' + oCab:_MDFE:_INFMDFE:_EMIT:_ENDEREMIT:_CEP:TEXT, oFont08)	//Cidade, UF, CEP

//������������������������������������������������������������������������Ŀ
//� BOX: DACTE                                                             �
//��������������������������������������������������������������������������
oDamdfe:Box(0036, 402, 0053, 0800)	
oDamdfe:Say(0046, 430, "DAMDFE", oFont12N)
oDamdfe:Say(0042, 490, "Documento Auxiliar de Manifesto Eletr�nico de",oFont08)
oDamdfe:Say(0050, 490, "Documentos Fiscais",oFont08) 

//������������������������������������������������������������������������Ŀ
//� BOX: Controle do Fisco                                                 �
//��������������������������������������������������������������������������
oDamdfe:Box(0055, 402, 0140, 0800)
If	AllTrim(aCab[7])<>''
	oDamdfe:Code128C(100.6,425,aCab[5], 29)
//	oDamdfe:Code128C(150.4,425,aCab[7], 29)
Else
	oDamdfe:Code128C(100.6,425,aCab[5], 29)
EndIf
oDamdfe:Line(0110, 0402, 0110, 0800 )	//Linha Separadora
oDamdfe:Say( 0118, 0425,"CHAVE DE ACESSO",oFont07)
oDamdfe:Say( 0128, 0425, Transform(AllTrim(aCab[5]),"@r 99.9999.99.999.999/9999-99-99-999-999.999.999.999.999.999.9"), oFont08N) 

//������������������������������������������������������������������������Ŀ
//�BOX: Modelo / Serie / Numero / Folha / Emis / UF                        �
//��������������������������������������������������������������������������

oDamdfe:Box(0142, 000, 162, 0400)

oDamdfe:Say(0150, 0005, "Modelo" , oFont08N)	//Modelo
oDamdfe:Say(0158, 0005, "58",oFont08)

oDamdfe:Say(0150, 0045, "Serie"  , oFont08N)	//Serie
oDamdfe:Say(0158, 0050, cValtoChar( Val(aCab[2]) ), oFont08)

oDamdfe:Say(0150, 0090, "N�mero" , oFont08N)	//Numero
oDamdfe:Say(0158, 0095, cValtoChar( Val(aCab[1]) ), oFont08)

oDamdfe:Say(0150, 0145, "Folha"  , oFont08N)	//Folha
oDamdfe:Say(0158, 0149, AllTrim(Str(nFolhAtu)) + " / " + AllTrim(Str(nFolhas)), oFont08)
nFolhAtu ++

oDamdfe:Say(0150, 0199, "Emiss�o", oFont08N)//Emissao
oDamdfe:Say(0158, 0192, SubStr(AllTrim(aCab[3]), 7, 2) + '/'   +;
						SubStr(AllTrim(aCab[3]), 5, 2) + "/"   +; 
						SubStr(AllTrim(aCab[3]), 1, 4) + " - " +;
						SubStr(AllTrim(aCab[4]), 1, 2) + ":"   +;	
						SubStr(AllTrim(aCab[4]), 3, 2) + ":00", oFont08)

oDamdfe:Say(0150, 0284, "UF Carreg."  , oFont08N)	//Folha

//cCodEst:= Substr(oCab:_MDFE:_INFMDFE:_IDE:_INFMUNCARREGA:_CMUNCARREGA:TEXT,1,2)
cCodEst:= oCab:_MDFE:_INFMDFE:_IDE:_UFINI:TEXT
/*If aScan(aUF,{|x| x[2] ==  AllTrim(cCodEst) }) != 0
	cUF := aUF[ aScan(aUF,{|x| x[2] == AllTrim(cCodEst) }), 1]
EndIf
*/
oDamdfe:Say(0158, 0288,cCodEst, oFont08)

//������������������������������������������������������������������������Ŀ
//�BOX: PROTOCOLO                                                          �
//��������������������������������������������������������������������������
oDamdfe:Box(0142, 0402, 162, 0800)
oDamdfe:Say(0150, 0425, "PROTOCOLO DE AUTORIZACAO DE USO"  , oFont08N)
If ( aCab[7] <> "2" )  //Modalidade
	oDamdfe:Say(0158, 0425,aCab[6], oFont08)
	oDamdfe:Say(0158, 0495,cValToChar(aCab[8]), oFont08)
	oDamdfe:Say(0158, 0535,cValToChar(aCab[9]), oFont08)
Else
	oDamdfe:Say(0158, 0425,'Impress�o em conting�ncia. Obrigat�ria a autoriza��o em 24 horas ap�s esta impress�o.', oFont08)

	oDamdfe:Say(0158, 0700, "(" + cValToChar(aCab[8]) + '-'+  aCab[9] +")" , oFont08)
EndIf

Return

//----------------------------------------------------------------------
/*/{Protheus.doc} GetXML
Busca o XML do MDF-e no TSS.

@author Rafael Iaquinto
@since 27/02/2014
@version 1.0 

@param	cIdEnt 		 	Entidade no TSS 
		aIdNFe 		 	aIdNFe - Array com os ID a serem consultados.				

@return .aRetorno		Retorno com os dados do MDF-e.
/*/
//-----------------------------------------------------------------------
Static Function GetXML(cIdEnt,aIdNFe)  

Local aRetorno		:= {}
Local aDados		:= {}

Local nZ			:= 0
Local nCount		:= 0
        
oWs := nil

For nZ := 1 To len(aIdNfe) 

    nCount++

	aDados := executeRetorna( aIdNfe[nZ], cIdEnt )
	
	if ( nCount == 10 )
		delClassIntF()
		nCount := 0
	endif
	
	aAdd(aRetorno,aDados)
	
Next nZ

Return(aRetorno)

//-----------------------------------------------------------------------
/*/{Protheus.doc} executeRetorna
Executa o retorna de notas

@author Rafael Iaquinto
@since 27/02/2014
@version 1.0 

@param  aNFe 		 Numer e serie para montar o CID para solicitar o XML 

@return aRetorno   Array com os dados da nota
/*/
//-----------------------------------------------------------------------
static function executeRetorna( aNfe, cIdEnt )

Local aExecute		:= {}  
Local aFalta		:= {}
Local aResposta		:= {}
Local aRetorno		:= {}
Local aDados		:= {} 
Local aIdNfe		:= {}

Local cAviso		:= "" 
Local cErro			:= "" 
Local cModTrans		:= ""
Local cProtocolo	:= ""
Local cRetorno		:= ""
Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://localhost:8080/sped"),250)
Local cDtHrRec1	:= ""

Local dDtRecib		:= CToD("")

Local lFlag			:= .T.

Local nDtHrRec1		:= 0
Local nL			:= 0
Local nX			:= 0
Local nY			:= 0
Local nZ			:= 1
Local nCount		:= 0
Local nLenNFe
Local nLenWS

Local oWS

Private oNFeRet
Private oDHRecbto

aAdd(aIdNfe,aNfe)

oWS:= WSNFeSBRA():New()
oWS:cUSERTOKEN        := "TOTVS"
oWS:cID_ENT           := cIdEnt
oWS:nDIASPARAEXCLUSAO := 0
oWS:_URL 			  := AllTrim(cURL)+"/NFeSBRA.apw"
oWS:oWSNFEID          := NFESBRA_NFES2():New()
oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()  

aadd(aRetorno,{"","",aIdNfe[nZ][1]+aIdNfe[nZ][2],"","",""})

aadd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := aIdNfe[nZ][1]+aIdNfe[nZ][2]

If oWS:RETORNANOTASNX()
	If Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5) > 0
		For nX := 1 To Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5)
			cRetorno        := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CXML
			cProtocolo      := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CPROTOCOLO
			cDHRecbto    := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CXMLPROT			
			oNFeRet			:= XmlParser(cRetorno,"_",@cAviso,@cErro)
			cModTrans		:= IIf(Type("oNFeRet:_MDFe:_infMDFe:_ide:_tpEmis:TEXT") <> "U",IIf (!Empty("oNFeRet:_MDFe:_infMDFe:_ide:_tpEmis:TEXT"),oNFeRet:_MDFe:_infMDFe:_ide:_tpEmis:TEXT,1),1)			
								
			nY := aScan(aIdNfe,{|x| x[1]+x[2] == SubStr(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:CID,1,Len(x[1]+x[2]))})
			
			If !Empty(cProtocolo)
				oDHRecbto := XmlParser(cDHRecbto,"","","")
				cDtHrRec  := IIf(Type("oDHRecbto:_ProtMDfe:_INFPROT:_DHRECBTO:TEXT")<>"U",oDHRecbto:_ProtMDfe:_INFPROT:_DHRECBTO:TEXT,"")
				nDtHrRec1 := RAT("T",cDtHrRec)

				If nDtHrRec1 <> 0
					cDtHrRec1 := SubStr(cDtHrRec,nDtHrRec1+1)
					dDtRecib  := SToD(StrTran(SubStr(cDtHrRec,1,AT("T",cDtHrRec)-1),"-",""))
				EndIf
			Else				
				cDtHrRec  := IIf(Type("oNFeRet:_MDFe:_infMDFe:_ide:_dhEmi:TEXT")<>"U",oNFeRet:_MDFe:_infMDFe:_ide:_dhEmi:TEXT,"")
				nDtHrRec1 := RAT("T",cDtHrRec)

				If nDtHrRec1 <> 0
					cDtHrRec1 := SubStr(cDtHrRec,nDtHrRec1+1)
					dDtRecib  := SToD(StrTran(SubStr(cDtHrRec,1,AT("T",cDtHrRec)-1),"-",""))
				EndIf						
			EndIf
			
			If nY > 0
				aRetorno[nY][1] := cProtocolo 
				aRetorno[nY][2] := cRetorno
				aRetorno[nY][4] := cModTrans
				aRetorno[nY][5] := cDtHrRec1
				aRetorno[nY][6] := dDtRecib				
				
				//aadd(aResposta,aIdNfe[nY])
			EndIf			
		Next nX		
	EndIf
Else
	Aviso("DANFE",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
EndIf 

oWS       := Nil
oNFeRet   := Nil

return aRetorno[len(aRetorno)]


//-----------------------------------------------------------------------
/*/{Protheus.doc} EspacoAt
Pega uma posi��o (nTam) na string cString, e retorna o 
caractere de espa�o anterior. 

@author Rafael Iaquinto
@since 27/02/2014
@version 1.0 

@param	cString	String para ser verificada. 
		nTam		Posi��o da string.

@return aRetorno   Array com os dados da nota
/*/
//-----------------------------------------------------------------------
Static Function EspacoAt(cString, nTam)

Local nRetorno := 0
Local nX       := 0

/**
* Caso a posi��o (nTam) for maior que o tamanho da string, ou for um valor
* inv�lido, retorna 0.
*/
If nTam > Len(cString) .Or. nTam < 1
	nRetorno := 0
	Return nRetorno
EndIf

/**
* Procura pelo caractere de espa�o anterior a posi��o e retorna a posi��o
* dele.
*/
nX := nTam
While nX > 1
	If Substr(cString, nX, 1) == " "
		nRetorno := nX
		Return nRetorno
	EndIf
	
	nX--
EndDo

/**
* Caso n�o encontre nenhum caractere de espa�o, � retornado 0.
*/
nRetorno := 0

Return nRetorno