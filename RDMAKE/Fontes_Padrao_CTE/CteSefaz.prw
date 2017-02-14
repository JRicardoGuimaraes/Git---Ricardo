#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �XmlCteSef � Autor � Eduardo Riera         � Data �13.02.2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rdmake de exemplo para geracao da Nota Fiscal Eletronica do ���
���          �SEFAZ - Versao T01.00                                       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �String da Nota Fiscal Eletronica                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Tipo da NF                                           ���
���          �       [0] Entrada                                          ���
���          �       [1] Saida                                            ���
���          �ExpC2: Serie da NF                                          ���
���          �ExpC3: Numero da nota fiscal                                ���
���          �ExpC4: Codigo do cliente ou fornecedor                      ���
���          �ExpC5: Loja do cliente ou fornecedor                        ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function XmlCteSef(cTipo,cSerie,cNota,cClieFor,cLoja)

Local nX          := 0
Local oWSNfe      := Nil
Local cString     := ""
Local cString20   := ""
Local cStringCh   := ""
Local cStringTmp  := ""  
Local cStringExp  := ""
Local cStringOut  := ""
Local cAliasCol   := ""
Local cAliasSE1   := "SE1"
Local cAliasSD1   := "SD1"
Local cAliasSD2   := "SD2"
Local cAliasDUE   := "DUE"
Local cNatOper    := ""
Local cModFrete   := ""
Local cScan       := ""
Local cEspecie    := ""
Local cMensCli    := ""
Local cMensFis    := ""
Local cNFe        := ""
Local cMV_LJTPNFE := SuperGetMV("MV_LJTPNFE", ," ")
Local cMVSUBTRIB  := SuperGetMv("MV_SUBTRIB")
Local cLJTPNFE    := ""
Local cWhere      := ""
Local cMunISS     := ""
Local cCFOP       := ""
Local nPosI       := 0
Local nPosF       := 0
Local lCompl
Local cCompl
Local lQuery      := .F.
Local lCalSol     := .F.

Local aNota       := {}
Local aDupl       := {}
Local aDest       := {}
Local aEntrega    := {}
Local aProd       := {}
Local aICMS       := {}
Local aICMSST     := {}
Local aIPI        := {}
Local aPIS        := {}
Local aCOFINS     := {}
Local aPISST      := {}
Local aCOFINSST   := {}
Local aISSQN      := {}
Local aISS        := {}
Local aCST        := {}
Local aRetido     := {}
Local aTransp     := {}
Local aImp        := {}
Local aVeiculo    := {}
Local aReboque    := {}
Local aEspVol     := {}
Local aNfVinc     := {}
Local aPedido     := {}
Local aTotal      := {0,0}
Local aOldReg     := {}
Local aOldReg2    := {}
Local aMed	      := {}
Local aArma       := {}
Local aveicProd   := {}
Local aIEST       := {}
Local aDI         := {}
Local aAdi        := {}
Local aExp        := {}
Local aPisAlqZ    := {}
Local aCofAlqZ    := {}
Local aCarga      := {0,0,0,0,""}
Local cGerDup     := 'S'
Local cUfEnt      := ''
Local cViagem     := ''
Local cFilVia     := ''
Local cRespSeg    := ''
Local cNomSeg     := ''
Local cApolice    := ''

//-- Inicio das variaveis para CTe //
Local cAliasDT6   := ''
Local cAliasSM0   := ''
Local cAliasRBC   := ''
Local cAliasAll   := ''
Local cAliasTagE  := ''
Local cAliasTagJ  := ''
Local cAliasTagO  := ''
Local cAliasCPL   := ''
Local cAliasChv   := ''
Local cAliasDY3   := ''
Local cAliasVPrest:= ''
Local cAliasDev   := ''
Local cAliasCTG   := ''
Local cAliasTES   := ''
Local cQuery      := ''
Local nSerieCTe   := 0
Local cAmbiente   := PARAMIXB[2]
Local cVerAmb     := PARAMIXB[3]
Local cModalidade := PARAMIXB[4]
Local aMotivoCont := PARAMIXB[1,7] //-- Obtem as informacoes de contigencia
Local aXMLCTe     := {}
Local cCT         := ''
Local cChvAcesso  := ''
Local nCount      := 0
Local cProdPred   := ''
Local cCodPred    := ''
Local cCodUF      := ''
Local cCodUFRem   := ''
Local cCodUFDes   := ''
Local cCodUFCon   := ''
Local cCodUFDpc   := ''
Local lTMSCTe     := SuperGetMv( "MV_TMSCTE" , .F., .F. )
Local cTmsAntt    := SuperGetMv( "MV_TMSANTT", .F., .F. )
Local lNatOper    := GetNewPar ( "MV_SPEDNAT", .F.)
Local lEECFAT     := SuperGetMv( "MV_EECFAT" )
Local lInscrito   := .F.
Local cCNPJToma   := ''
Local cpRedBC     := ''
Local cInsRemOpc  := ''
Local lSelOcor    := .F.
Local cSeekDUL    := ''
Local cSeqEntr    := ''
Local lNFe        := .F.
Local cObs        := ''
Local cDTCObs     := ''
Local cCtrDpc     := ''
Local cSerDpc     := ''
Local cTpDocAnt   := ''
Local cDtEmi      := ''
Local cCTEDocAnt  := ''
Local cTipoNF     := '2'
Local lCTEVFRE    := SuperGetMv("MV_CTEVFRE",.F.,.F.)
Local cSelOri     := '2'
Local cCodUFOri   := ''
Local lLotacao    := .F.
Local lDocApoio   := .F.
Local cCodVei     := ''
Local cRb1        := ''
Local cRb2        := ''
Local cLacre      := ''
Local nQtdDev     := 0
Local nCapcM3     := 0
Local cAliasDT5   := ''
Local cFilOri     := ''
Local cNumSol     := ''
Local cTpEmis     := ''
Local cDtCont     := ''
Local ValTot      := ''
Local cChvCTG     := ''
Local lContrib    :=.F.
Local lRedesp     := .F. 
Local nVcred      := 0
Local nBASEICM    := 0
Local nBASICMRET  := 0
Local nCREDPRES   := 0
Local nALIQICM    := 0
Local nVALICM     := 0
Local nALIQSOL    := 0
Local nICMSRET    := 0

Local cForSeg     := SuperGetMv( "MV_FORSEG",,'' )
Local lForApol    := SA2->(FieldPos('A2_APOLICE')) > 0
Local nTamCod     := Len(SA2->A2_COD)
Local nTamLoj     := Len(SA2->A2_LOJA)

Private aUF       := {}

Default cTipo     := PARAMIXB[1,1]
Default cSerie    := PARAMIXB[1,3]
Default cNota     := PARAMIXB[1,4]
Default cClieFor  := PARAMIXB[1,5]
Default cLoja     := PARAMIXB[1,6]

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


DbSelectArea ("SX6")
SX6->(DbSetOrder (1))
If (SX6->(DbSeek (xFilial ("SX6")+"MV_SUBTRI")))
	Do While !SX6->(Eof ()) .And. xFilial ("SX6")==SX6->X6_FIL .And. "MV_SUBTRI"$SX6->X6_VAR
		If !Empty(SX6->X6_CONTEUD)
			cMVSUBTRIB += "/"+AllTrim (SX6->X6_CONTEUD)
		EndIf
		SX6->(DbSkip ())
	EndDo
EndIf

If cTipo == "1" //-- Saida
	//������������������������������������������������������������������������Ŀ
	//�Posiciona NF                                                            �
	//��������������������������������������������������������������������������
	dbSelectArea("SF2")
	dbSetOrder(1)
	If MsSeek(xFilial("SF2")+cNota+cSerie+cClieFor+cLoja)
		//������������������������������������������������������������������������Ŀ
		//�Tratamento temporario do CTe                                            �
		//��������������������������������������������������������������������������
		If (lTMSCTe) .Or. (AModNot(SF2->F2_ESPECIE)=="57") .Or. (FunName()$"TMSA200" .Or. FunName()$"TMSA500")
			cAliasDT6 := "DT6_TMP"

			If (Select(cAliasDT6) > 0)
				(cAliasDT6)->(DbCloseArea())
			EndIf

			cQuery := " SELECT CTRC.DT6_FILDOC, " + CRLF
			cQuery += "        CTRC.DT6_FILORI, " + CRLF
			cQuery += "        CTRC.DT6_SERIE,  " + CRLF
			cQuery += "        CTRC.DT6_DOC,    " + CRLF
			cQuery += "        CTRC.DT6_DATEMI, " + CRLF
			cQuery += "        CTRC.DT6_HOREMI, " + CRLF
			cQuery += "        CTRC.DT6_DOCTMS, " + CRLF
			cQuery += "        CTRC.DT6_TIPTRA, " + CRLF
			cQuery += "        CTRC.DT6_FILIAL, " + CRLF
			cQuery += "        CTRC.DT6_FILDOC, " + CRLF
			cQuery += "        CTRC.DT6_CLIDEV, " + CRLF
			cQuery += "        CTRC.DT6_LOJDEV, " + CRLF
			cQuery += "        CTRC.DT6_CLIREM, " + CRLF
			cQuery += "        CTRC.DT6_LOJREM, " + CRLF
			cQuery += "        CTRC.DT6_CLIDES, " + CRLF
			cQuery += "        CTRC.DT6_LOJDES, " + CRLF
			cQuery += "        CTRC.DT6_CLICON, " + CRLF
			cQuery += "        CTRC.DT6_LOJCON, " + CRLF
			cQuery += "        CTRC.DT6_CLIDPC, " + CRLF
			cQuery += "        CTRC.DT6_LOJDPC, " + CRLF
			cQuery += "        CTRC.DT6_VALFRE, " + CRLF
			cQuery += "        CTRC.DT6_VALTOT, " + CRLF
			cQuery += "        CTRC.DT6_VALIMP, " + CRLF
			cQuery += "        CTRC.DT6_PRZENT, " + CRLF
			cQuery += "        CTRC.DT6_VOLORI, " + CRLF
			cQuery += "        CTRC.DT6_SERVIC, " + CRLF
			cQuery += "        CTRC.DT6_LOTNFC, " + CRLF
			cQuery += "        CTRC.DT6_VALMER, " + CRLF
			cQuery += "        CTRC.DT6_FILDCO, " + CRLF
			cQuery += "        CTRC.DT6_DOCDCO, " + CRLF
			cQuery += "        CTRC.DT6_SERDCO, " + CRLF
			cQuery += "        CTRC.DT6_CODMSG, " + CRLF
			cQuery += "        CTRC.DT6_CDRORI, " + CRLF
			cQuery += "        CTRC.DT6_PREFIX, " + CRLF
			cQuery += "        CTRC.DT6_NUM,    " + CRLF
			cQuery += "        CTRC.DT6_TIPO,   " + CRLF
			cQuery += "        CTRC.DT6_CODOBS, " + CRLF
			cQuery += "        CTRC.DT6_CHVCTE, " + CRLF
			cQuery += "        CTRC.DT6_SITCTE, " + CRLF
			
			//-- Remetente
			cQuery += "        CLIREM.A1_CGC REM_CNPJ,			" + CRLF
			cQuery += "        CLIREM.A1_INSCR REM_INSC,		" + CRLF
			cQuery += "        CLIREM.A1_CONTRIB REM_CONTRIB,	" + CRLF
			cQuery += "        CLIREM.A1_NOME REM_NOME,			" + CRLF
			cQuery += "        CLIREM.A1_NREDUZ REM_NMEFANT,	" + CRLF
			cQuery += "        CLIREM.A1_DDD REM_DDDTEL,		" + CRLF
			cQuery += "        CLIREM.A1_TEL REM_TEL,			" + CRLF
			cQuery += "        CLIREM.A1_END REM_END,			" + CRLF
			cQuery += "        CLIREM.A1_BAIRRO REM_BAIRRO,		" + CRLF
			cQuery += "        CLIREM.A1_MUN REM_MUNICI,		" + CRLF
			cQuery += "        CLIREM.A1_CEP REM_CEP,			" + CRLF
			cQuery += "        CLIREM.A1_EST REM_UF,			" + CRLF
			cQuery += "        CLIREM.A1_PAIS REM_PAIS,			" + CRLF
			cQuery += "        CLIREM.A1_PESSOA REM_TPPESSOA,	" + CRLF
			cQuery += "        CLIREM.A1_SUFRAMA REM_SUFRAMA,	" + CRLF
			cQuery += "        CLIREM.A1_COD_MUN REM_COD_MUN,	" + CRLF
			cQuery += "        CLIREM.A1_EMAIL   REM_EMAIL,		" + CRLF
			//-- Destinatario
			cQuery += "        CLIDES.A1_CGC DES_CNPJ,			" + CRLF
			cQuery += "        CLIDES.A1_INSCR DES_INSC,		" + CRLF
			cQuery += "        CLIDES.A1_CONTRIB DES_CONTRIB,	" + CRLF
			cQuery += "        CLIDES.A1_NOME DES_NOME,			" + CRLF
			cQuery += "        CLIDES.A1_DDD DES_DDDTEL,		" + CRLF
			cQuery += "        CLIDES.A1_TEL DES_TEL,			" + CRLF
			cQuery += "        CLIDES.A1_PESSOA DES_TPPESSOA, 	" + CRLF
			cQuery += "        CLIDES.A1_SUFRAMA	DES_SUFRAMA," + CRLF
			cQuery += "        CLIDES.A1_END DES_END,			" + CRLF
			cQuery += "        CLIDES.A1_BAIRRO DES_BAIRRO,		" + CRLF
			cQuery += "        CLIDES.A1_MUN DES_MUNICI,		" + CRLF
			cQuery += "        CLIDES.A1_CEP DES_CEP,			" + CRLF
			cQuery += "        CLIDES.A1_EST DES_UF,			" + CRLF
			cQuery += "        CLIDES.A1_PAIS DES_PAIS,			" + CRLF
			cQuery += "        CLIDES.A1_COD_MUN DES_COD_MUN,	" + CRLF
			cQuery += "        CLIDES.A1_EMAIL   DES_EMAIL,		" + CRLF
			//-- Consignatario			
			cQuery += "        CLICON.A1_CGC CON_CNPJ,			" + CRLF
			cQuery += "        CLICON.A1_INSCR CON_INSC,		" + CRLF
			cQuery += "        CLICON.A1_CONTRIB CON_CONTRIB,	" + CRLF
			cQuery += "        CLICON.A1_NOME CON_NOME,			" + CRLF
			cQuery += "        CLICON.A1_DDD CON_DDDTEL,		" + CRLF
			cQuery += "        CLICON.A1_TEL CON_TEL,			" + CRLF
			cQuery += "        CLICON.A1_PESSOA CON_TPPESSOA,	" + CRLF
			cQuery += "        CLICON.A1_SUFRAMA	CON_SUFRAMA," + CRLF
			cQuery += "        CLICON.A1_END CON_END,			" + CRLF
			cQuery += "        CLICON.A1_BAIRRO CON_BAIRRO,		" + CRLF
			cQuery += "        CLICON.A1_MUN CON_MUNICI,		" + CRLF
			cQuery += "        CLICON.A1_CEP CON_CEP,			" + CRLF
			cQuery += "        CLICON.A1_EST CON_UF,			" + CRLF
			cQuery += "        CLICON.A1_PAIS CON_PAIS, 		" + CRLF
			cQuery += "        CLICON.A1_COD_MUN CON_COD_MUN,	" + CRLF
			cQuery += "        CLICON.A1_EMAIL   CON_EMAIL,		" + CRLF
			//-- Despachante
			cQuery += "        CLIDPC.A1_CGC DPC_CNPJ,			" + CRLF
			cQuery += "        CLIDPC.A1_INSCR DPC_INSC,		" + CRLF
			cQuery += "        CLIDPC.A1_CONTRIB DPC_CONTRIB,	" + CRLF
			cQuery += "        CLIDPC.A1_NOME DPC_NOME,			" + CRLF
			cQuery += "        CLIDPC.A1_DDD DPC_DDDTEL,		" + CRLF
			cQuery += "        CLIDPC.A1_TEL DPC_TEL,			" + CRLF
			cQuery += "        CLIDPC.A1_PESSOA DPC_TPPESSOA,	" + CRLF
			cQuery += "        CLIDPC.A1_SUFRAMA DPC_SUFRAMA,	" + CRLF
			cQuery += "        CLIDPC.A1_END DPC_END,			" + CRLF
			cQuery += "        CLIDPC.A1_BAIRRO DPC_BAIRRO,		" + CRLF
			cQuery += "        CLIDPC.A1_MUN DPC_MUNICI,		" + CRLF
			cQuery += "        CLIDPC.A1_CEP DPC_CEP,			" + CRLF
			cQuery += "        CLIDPC.A1_EST DPC_UF,			" + CRLF
			cQuery += "        CLIDPC.A1_PAIS DPC_PAIS,			" + CRLF
			cQuery += "        CLIDPC.A1_COD_MUN DPC_COD_MUN,	" + CRLF
			cQuery += "        CLIDPC.A1_EMAIL   DPC_EMAIL		" + CRLF
			
			cQuery += "   FROM " + RetSqlName('DT6') + " CTRC " + CRLF
			cQuery += "        INNER JOIN " + RetSqlName('SA1') + " CLIREM  ON (CLIREM.A1_COD = CTRC.DT6_CLIREM AND CLIREM.A1_LOJA = CTRC.DT6_LOJREM   ) " + CRLF
			cQuery += "        INNER JOIN " + RetSqlName('SA1') + " CLIDES  ON (CLIDES.A1_COD = CTRC.DT6_CLIDES AND CLIDES.A1_LOJA = CTRC.DT6_LOJDES   ) " + CRLF
			cQuery += "        LEFT  JOIN " + RetSqlName('SA1') + " CLICON  ON (CLICON.A1_FILIAL = '" + xFilial('SA1') + "' AND CLICON.A1_COD = CTRC.DT6_CLICON AND CLICON.A1_LOJA = CTRC.DT6_LOJCON AND CLICON.D_E_L_E_T_ = ' ' ) " + CRLF
			cQuery += "        LEFT  JOIN " + RetSqlName('SA1') + " CLIDPC  ON (CLIDPC.A1_FILIAL = '" + xFilial('SA1') + "' AND CLIDPC.A1_COD = CTRC.DT6_CLIDPC AND CLIDPC.A1_LOJA = CTRC.DT6_LOJDPC AND CLIDPC.D_E_L_E_T_ = ' ' ) " + CRLF

			cQuery += "  WHERE CTRC.DT6_FILIAL   = '" + xFilial('DT6') + "'" + CRLF
			cQuery += "    AND CTRC.DT6_FILDOC   = '" + cFilAnt + "'" + CRLF
			cQuery += "    AND CTRC.DT6_DOC      = '" + cNota + "'" + CRLF
			cQuery += "    AND CTRC.DT6_SERIE    = '" + cSerie + "'" + CRLF
			cQuery += "    AND CTRC.D_E_L_E_T_   = ' '" + CRLF
			
			cQuery += "    AND CLIREM.A1_FILIAL  = '" + xFilial('SA1') + "'" + CRLF
			cQuery += "    AND CLIREM.D_E_L_E_T_ = ' '" + CRLF
			
			cQuery += "    AND CLIDES.A1_FILIAL  = '" + xFilial('SA1') + "'" + CRLF
			cQuery += "    AND CLIDES.D_E_L_E_T_ = ' '"
			
			cQuery += "  ORDER BY CTRC.DT6_FILDOC, " + CRLF
			cQuery += "           CTRC.DT6_DOC,    " + CRLF
			cQuery += "           CTRC.DT6_SERIE   "
			
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasDT6, .F., .T.)
			(cAliasDT6)->(DbGoTop())
			
			If (!(cAliasDT6)->(Eof())) // (01)
				cString := ''
				//�����������������������������������������������������������������Ŀ
				//� Header do Arquivo XML                                           �
				//�������������������������������������������������������������������
				cString += '<infNFe versao="T02.00" modelo="57">'
				cString += '<CTe xmlns="http://www.portalfiscal.inf.br/cte">'
				aAdd(aXMLCTe,AllTrim(cString))
				
				While !(cAliasDT6)->(Eof()) // (02)

					If aScan(aUF,{|x| x[1] ==  AllTrim(SM0->M0_ESTENT) }) != 0 // Confere se Uf do Emitente esta OK
						cCodUF := aUF[ aScan(aUF,{|x| x[1] == AllTrim(SM0->M0_ESTENT) }), 2]
					Else
						cCodUF := ''
					EndIf
					
					If aScan(aUF,{|x| x[1] == (cAliasDT6)->REM_UF }) != 0   //Confere se Uf do Remetente esta OK
						cCodUFRem  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT6)->REM_UF }), 2]
					Else
						cCodUFRem  := ''
					EndIf
					
					If aScan(aUF,{|x| x[1] == (cAliasDT6)->DES_UF }) != 0   //Confere se Uf do Destinatario esta OK
						cCodUFDes  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT6)->DES_UF }), 2]
					Else
						cCodUFDes := ''
					EndIf
					
					cMail := Posicione('SA1',1,xFilial('SA1')+(cAliasDT6)->(DT6_CLIDEV+DT6_LOJDEV),'A1_EMAIL')
					
					dbSelectArea("SF3")
					SF3->(DbSetOrder(4))
					If SF3->(DbSeek(xFilial("SF3")+(cAliasDT6)->(DT6_CLIDEV+DT6_LOJDEV+DT6_DOC+DT6_SERIE)))
						cCFOP := SF3->F3_CFO
					EndIf
					
					If !Empty((cAliasDT6)->CON_UF) // Confere se Uf do Consignatario esta OK
						If (aScan(aUF,{|x| x[1] == (cAliasDT6)->CON_UF }) != 0)
							cCodUFCon  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT6)->CON_UF }), 2]
						Else
							cCodUFCon := ''
						EndIF
					EndIf
					
					If !Empty((cAliasDT6)->DPC_UF)
						If (aScan(aUF,{|x| x[1] == (cAliasDT6)->DPC_UF }) != 0) //Confere se Uf do Despachante esta OK
							cCodUFDpc  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT6)->DPC_UF }), 2]
						Else
							cCodUFDpc  := ''
						EndIf
					EndIf
					
					//�����������������������������������������������������������������Ŀ
					//� Gerar Chave de Acesso do CT-e                                   �
					//�������������������������������������������������������������������
					nSerieCTe := Val( AllTrim((cAliasDT6)->DT6_SERIE))
					
					//�����������������������������������������������������������������Ŀ
					//� Formato de Impressao do CT-e                                    �
					//� 1 - Normal    
					//� 4 - EPEC  	                                                    �
					//� 5 - Contingencia versao 1.04 - 7-Conting�ncia FS-DA             �
					//� 7 - Contingencia versao 1.04 - SVC-RS                           �
					//� 8 - Contingencia versao 1.04 - SVC-SP                           �
					//�������������������������������������������������������������������
					If (cModalidade == '1')
						cTpEmis := '1'
					ElseIf cModalidade == '5'
						cTpEmis := '4'
					ElseIf cModalidade == '7'
						cTpEmis := '5'
					ElseIf cModalidade == '8'
						cTpEmis := '8'
					ElseIf cModalidade == '9'
						cTpEmis := '7'
					EndIf

					cCT := cTpEmis + Inverte(StrZero(Val(PadR((cAliasDT6)->DT6_DOC, 8)), 8))
					
					//�����������������������������������������������������������������Ŀ
					//� Voltar rotina abaixo                                            �
					//�������������������������������������������������������������������
					cChvAcesso := CTeCHVAC( cCodUF,;
											( SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 3, 2) + SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 5, 2) ),;
											AllTrim(SM0->M0_CGC),;
											'57',;
											StrZero(nSerieCTe, 3),;
											StrZero(Val(PadR((cAliasDT6)->DT6_DOC,9)), 9),;
											cCT)
					cCT := Inverte(StrZero(Val(PadR((cAliasDT6)->DT6_DOC,8)), 8))
					

					//�����������������������������������������������������������������Ŀ
					//� Inicio dos Dados do CTe                                         �
					//�������������������������������������������������������������������
					cNFe    := 'CTe' + AllTrim(cChvAcesso)
					cString := ''
					
					//�����������������������������������������������������������������Ŀ
					//� Versao do Ct-e, de acordo com o parametro                       �
					//�������������������������������������������������������������������
					cString += '<infCte Id="CTe' + AllTrim(cChvAcesso) + '" versao="' + cVerAmb + '">'
					
					
					aAdd(aXMLCTe,AllTrim(cString))
					
					//�����������������������������������������������������������������Ŀ
					//� TAG: B - IdentIfica��o do Conhecimento de Transporte Eletronico �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� CFOP - Natureza da Prestacao                                    �
					//�������������������������������������������������������������������
					cAliasD2 := GetNextAlias()
					cQuery := " SELECT SX5.X5_DESCRI" + CRLF
					cQuery += "   FROM " +	RetSqlName("SX5") + " SX5 " + CRLF
					cQuery += "  WHERE SX5.X5_FILIAL ='"  + xFilial("SX5") + "'" + CRLF
					cQuery += "    AND SX5.X5_TABELA ='13'" + CRLF
					cQuery += "    AND SX5.X5_CHAVE  ='" + cCFOP + "'" + CRLF
					cQuery += "    AND SX5.D_E_L_E_T_<>'*'"
					cQuery := ChangeQuery(cQuery)
					
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasD2, .F., .T.)
					
					If !(cAliasD2)->(Eof())
						cNatOper := SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,55)
					EndIf
					(cAliasD2)->(DbCloseArea())
					
					cString := ''
					cString += '<ide>'
					cString += '<cUF>'  + NoAcentoCte( cCodUF )		+ '</cUF>'
					cString += '<cCT>'  + NoAcentoCte( cCT )		+ '</cCT>'
					cString += '<CFOP>' + NoAcentoCte(cCFOP)		+ '</CFOP>'
					cString += '<natOp>'+ NoAcentoCte( cNatOper )	+ '</natOp>'
					
					//�����������������������������������������������������������������Ŀ
					//� Forma de Pagamento do Servico                                   �
					//� 0 - Pago / 1 - A pagar / 2 - Outros                             �
					//�������������������������������������������������������������������
					If (	((cAliasDT6)->DT6_CLIREM = (cAliasDT6)->DT6_CLIDEV) .and.;
							((cAliasDT6)->DT6_LOJREM = (cAliasDT6)->DT6_LOJDEV) )
						cString += '<forPag>0</forPag>'
						//-- Verifica contribuinte de ICMS
						If (cAliasDT6)->REM_CONTRIB == '1'
							lContrib := .T.
						EndIf
					ElseIf (((cAliasDT6)->DT6_CLIDES = (cAliasDT6)->DT6_CLIDEV) .and.;
							((cAliasDT6)->DT6_LOJDES = (cAliasDT6)->DT6_LOJDEV) )
						cString += '<forPag>1</forPag>'
						If (cAliasDT6)->DES_CONTRIB == '1'
							lContrib := .T.
						EndIf
					Else
						cString += '<forPag>2</forPag>'
					EndIf
					
					//�����������������������������������������������������������������Ŀ
					//�                                                                 �
					//�                                                                 �
					//�������������������������������������������������������������������

					cString += '<mod>' 	+ "57" + '</mod>'
					cString += '<serie>'+ NoAcentoCte( cValtoChar( nSerieCTe ) ) + '</serie>'
					cString += '<nCT>'	+ NoAcentoCte( cValtoChar( Val( AllTrim((cAliasDT6)->DT6_DOC) ) ) ) + '</nCT>'

					//�����������������������������������������������������������������Ŀ
					//�Data e hora de emiss�o                                           �
					//�Formato = AAAA-MM-DDTHH:MM:SS                                    �
					//�Preenchido com data e hora de emiss�o.                           �
					//�������������������������������������������������������������������
					cString += '<dhEmi>' + SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 1, 4) + "-";
					+ SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 5, 2) + "-";
					+ SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 7, 2) + "T";
					+ SubStr(AllTrim((cAliasDT6)->DT6_HOREMI), 1, 2) + ":";
					+ SubStr(AllTrim((cAliasDT6)->DT6_HOREMI), 3, 2) + ':00</dhEmi>'

					//�����������������������������������������������������������������Ŀ
					//� Formato de Impressao do DACTE                                   �
					//� 1 - Retrato                                                     �
					//� 2 - Paisagem                                                    �
					//�������������������������������������������������������������������
					cString += '<tpImp>1</tpImp>'

					//�����������������������������������������������������������������Ŀ
					//� Formato de Impressao do CT-e                                    �
					//� 1 - Normal                                                      �
					//� 4 - EPEC                                                        �
					//� 5 - Contingencia versao 1.04                                    �
					//� 7 - Contingencia versao 1.04  - SVC-RS                          �
					//� 8 - Contingencia versao 1.04  - SVC-SP                          �
					//�������������������������������������������������������������������
					If (cModalidade == '1')
						cString += '<tpEmis>1</tpEmis>'
					ElseIf cModalidade == '5'
						cString += '<tpEmis>4</tpEmis>'
					ElseIf cModalidade == '7'
						cString += '<tpEmis>5</tpEmis>'
					ElseIf cModalidade == '8'
						cString += '<tpEmis>8</tpEmis>'
					ElseIf cModalidade == '9'
						cString += '<tpEmis>7</tpEmis>'
					EndIf

					cString += '<cDV>' + SubStr( AllTrim(cChvAcesso), len( AllTrim(cChvAcesso) ), 1) + '</cDV>'

					//�����������������������������������������������������������������Ŀ
					//� Identificacao do Ambiente.                                      �
					//� 1 - Producao                                                    �
					//� 2 - Homologacao                                                 �
					//�������������������������������������������������������������������
					cString += '<tpAmb>' + cAmbiente + '</tpAmb>'

					//�����������������������������������������������������������������Ŀ
					//� Tipo de Conhecimento                                            �
					//� 0 - Normal                                                      �
					//� 1 - Complemento de Valores                                      �
					//� 2 - Emitido em Hipotese de anulacao de Debito                   �
					//�������������������������������������������������������������������
					If ( AllTrim((cAliasDT6)->DT6_DOCTMS) $ "A/E/2/6/7/9" )
						cString += '<tpCTe>0</tpCTe>'
					ElseIf ( AllTrim((cAliasDT6)->DT6_DOCTMS) $ "8" )
						cString += '<tpCTe>1</tpCTe>'
					ElseIf ( AllTrim((cAliasDT6)->DT6_DOCTMS) = "M" )
						cString += '<tpCTe>2</tpCTe>'
					ElseIf ( AllTrim((cAliasDT6)->DT6_DOCTMS) = "P" )
						cString += '<tpCTe>3</tpCTe>'
					Else
						cString += '<tpCTe>0</tpCTe>'
					EndIf
					
					//�����������������������������������������������������������������Ŀ
					//� Processo de Emissao do CT-e                                     �
					//� 0 - emissao com aplicativo do contribuinte                      �
					//� 1 - avulsa pelo fisco                                           �
					//� 2 - avulsa pelo contrinbuinte com seu certificado digital,      �
					//�     atraves do site do Fisco                                    �
					//� 3 - pelo contribuinte com aplicativo fornecido pelo Fisco       �
					//�������������������������������������������������������������������
					cString += '<procEmi>0</procEmi>'
					
					//�����������������������������������������������������������������Ŀ
					//�                                                                 �
					//�������������������������������������������������������������������
					cString += '<verProc>' + cVerAmb + '</verProc>'
					cString += '<cMunEnv>' + NoAcentoCte( SM0->M0_CODMUN ) + '</cMunEnv>'
					cString += '<xMunEnv>' + NoAcentoCte( SM0->M0_CIDENT ) + '</xMunEnv>'
					cString += '<UFEnv>'   + NoAcentoCte( SM0->M0_ESTENT ) + '</UFEnv>'
				
					
					//�����������������������������������������������������������������Ŀ
					//� Modal                                                           �
					//� 01 - Rodoviario;                                                �
					//� 02 - Aereo;                                                     �
					//� 03 - Aquaviario;                                                �
					//� 04 - Ferroviario;                                               �
					//� 05 - Dutoviario.                                                �
					//� 06-Multimodal;                                                  �
					//�������������������������������������������������������������������

					cString += '<modal>01</modal>'
					
					//�����������������������������������������������������������������Ŀ
					//� Tipo de Servico                                                 �
					//� 0 - Normal                                                      �
					//� 1 - SubContratacao                                              �
					//� 2 - Redespacho                                                  �
					//� 3 - Redespacho Intermediario                                    �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� DTC - Notas Fiscais: (Informacao do campo DTC_TIPNFC)           �
					//� 0 - Normal                                                      �
					//� 1 - Devolucao                                                   �
					//� 2 - SubContratacao                                              �
					//� 3 - Dcto Nao Fiscal                                             �
					//� 4 - Exportacao                                                  �
					//� 5 - Redespacho                                                  �
					//� 6 - Dcto Nao Fiscal 1                                           �
					//� 7 - Dcto Nao Fiscal 2                                           �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� Seleciona as informacoes do produto, baseado na DTC             �
					//� Pega o produto com maior valor de mercadoria, definido como     �
					//� o produto predominante                                          �
					//�������������������������������������������������������������������
					cAliasAll := GetNextAlias()
					cQuery := " SELECT MAX(DTC.DTC_VALOR),	" + CRLF
					cQuery += " 		 DTC.DTC_TIPNFC,	" + CRLF
					cQuery += " 		 DTC.DTC_CODOBS,	" + CRLF
					cQuery += " 		 DTC.DTC_CTRDPC,	" + CRLF
					cQuery += " 		 DTC.DTC_SERDPC,	" + CRLF
					cQuery += " 		 DTC.DTC_TIPANT,	" + CRLF
					cQuery += " 		 DTC.DTC_DPCEMI,	" + CRLF
					cQuery += " 		 DTC.DTC_CTEANT,	" + CRLF
					cQuery += " 		 DTC.DTC_SELORI,	" + CRLF
					cQuery += " 		 DTC.DTC_SQEDES,	" + CRLF
					cQuery += " 		 DTC.DTC_FILORI,	" + CRLF
					cQuery += " 		 DTC.DTC_NUMSOL,	" + CRLF
					cQuery += " 		 DV3.DV3_INSCR,		" + CRLF
					cQuery += " 		 SB1.B1_DESC,		" + CRLF
					cQuery += " 		 SB1.B1_COD,		" + CRLF
					cQuery += " 		 SB1.B1_UM			" + CRLF
					cQuery += "   FROM " + RetSqlName("DTC") + " DTC " + CRLF

					cQuery += " 		INNER JOIN " + RetSqlName('SB1') + " SB1 "	+ CRLF
					cQuery += "					ON ( SB1.B1_COD = DTC.DTC_CODPRO ) "+ CRLF

					cQuery += " 		 LEFT JOIN " + RetSqlName('DV3') + " DV3 " + CRLF
					cQuery += "					ON (DV3.DV3_FILIAL = '" + xFilial("DV3") + "'"  + CRLF
					cQuery += "					AND DV3.DV3_CODCLI = DTC.DTC_CLIREM " + CRLF
					cQuery += "					AND DV3.DV3_LOJCLI = DTC.DTC_LOJREM " + CRLF
					cQuery += "					AND DV3.DV3_SEQUEN = DTC.DTC_SQIREM " + CRLF
					cQuery += "					AND DV3.D_E_L_E_T_ = ' ') " + CRLF

					cQuery += "  WHERE DTC.DTC_FILIAL = '" + xFilial('DTC') + "'" + CRLF

					cQuery += "	 	AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'" + CRLF
					cQuery += "		AND SB1.D_E_L_E_T_ = ' '

					//�����������������������������������������������������������������Ŀ
					//� Se o tipo de Conhecimento for de Complemento, seleciona as      �
					//� informacoes do CTR principal, pois o complemento nao tem DTC    �
					//�������������������������������������������������������������������
					If !Empty((cAliasDT6)->DT6_DOCDCO)
						cQuery += " AND DTC.DTC_FILDOC   = '" + (cAliasDT6)->DT6_FILDCO + "'" + CRLF
						cQuery += " AND DTC.DTC_DOC      = '" + (cAliasDT6)->DT6_DOCDCO + "'" + CRLF
						cQuery += " AND DTC.DTC_SERIE    = '" + (cAliasDT6)->DT6_SERDCO + "'" + CRLF
					Else
						cQuery += " AND DTC.DTC_FILDOC   = '" + (cAliasDT6)->DT6_FILDOC + "'" + CRLF
						cQuery += " AND DTC.DTC_DOC      = '" + (cAliasDT6)->DT6_DOC    + "'" + CRLF
						cQuery += " AND DTC.DTC_SERIE    = '" + (cAliasDT6)->DT6_SERIE  + "'" + CRLF
					EndIf
					cQuery += " AND DTC.D_E_L_E_T_   = ' '" + CRLF
					cQuery += " GROUP BY DV3.DV3_INSCR,  DTC.DTC_TIPNFC, DTC.DTC_CODOBS, DTC.DTC_CTRDPC, DTC.DTC_SERDPC, DTC.DTC_TIPANT, "+ CRLF
					cQuery += "          DTC.DTC_DPCEMI, DTC.DTC_CTEANT, DTC.DTC_SELORI, DTC.DTC_SQEDES, DTC.DTC_FILORI, DTC.DTC_NUMSOL, SB1.B1_DESC, SB1.B1_COD , SB1.B1_UM " + CRLF
					cQuery += " ORDER BY MAX(DTC.DTC_VALOR) DESC" + CRLF
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAll, .F., .T.)
					If ((cAliasAll)->(Eof()))
						//-- Nao localizou documentos... Procura documentos de apoio...
						(cAliasAll)->(DbCloseArea())
						cQuery := " SELECT MAX(DTC.DTC_VALOR),		" + CRLF
						cQuery += " 		 DTC.DTC_TIPNFC,		" + CRLF
						cQuery += " 		 DTC.DTC_CODOBS,		" + CRLF
						cQuery += " 		 DTC.DTC_CTRDPC,		" + CRLF
						cQuery += " 		 DTC.DTC_SERDPC,		" + CRLF
						cQuery += " 		 DTC.DTC_TIPANT,		" + CRLF
						cQuery += " 		 DTC.DTC_DPCEMI,		" + CRLF
						cQuery += " 		 DTC.DTC_CTEANT,		" + CRLF
						cQuery += " 		 DTC.DTC_SELORI,		" + CRLF
						cQuery += " 		 DTC.DTC_SQEDES,		" + CRLF
						cQuery += " 		 DTC.DTC_FILORI,		" + CRLF
						cQuery += " 		 DTC.DTC_NUMSOL,		" + CRLF
						cQuery += " 		 DV3.DV3_INSCR,			" + CRLF
						cQuery += " 		 SB1.B1_DESC,			" + CRLF
						cQuery += " 		 SB1.B1_COD,			" + CRLF
						cQuery += " 		 SB1.B1_UM				" + CRLF
						cQuery += "   FROM " + RetSqlName("DTC") + " DTC "

						cQuery += " 		INNER JOIN " + RetSqlName('SB1') + " SB1 " 		+ CRLF
						cQuery += "					ON ( SB1.B1_COD = DTC.DTC_CODPRO ) "   + CRLF
						cQuery += "					AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'" + CRLF
						cQuery += "					AND SB1.D_E_L_E_T_ = ' '

						cQuery += " 		 LEFT JOIN " + RetSqlName('DV3') + " DV3 " + CRLF
						cQuery += "					ON (DV3.DV3_FILIAL = '" + xFilial("DV3") + "'"  + CRLF
						cQuery += "					AND DV3.DV3_CODCLI = DTC.DTC_CLIREM " + CRLF
						cQuery += "					AND DV3.DV3_LOJCLI = DTC.DTC_LOJREM " + CRLF
						cQuery += "					AND DV3.DV3_SEQUEN = DTC.DTC_SQIREM " + CRLF
						cQuery += "					AND DV3.D_E_L_E_T_ = ' ') " + CRLF

						cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 " + CRLF
						cQuery += "   ON DT6.DT6_CLIDEV   = '" + (cAliasDT6)->DT6_CLIDEV + "'" + CRLF
						cQuery += "  AND DT6.DT6_LOJDEV   = '" + (cAliasDT6)->DT6_LOJDEV + "'" + CRLF
						cQuery += "  AND DT6.DT6_PREFIX   = '" + (cAliasDT6)->DT6_PREFIX + "'" + CRLF
						cQuery += "  AND DT6.DT6_NUM      = '" + (cAliasDT6)->DT6_NUM    + "'" + CRLF
						cQuery += "  AND DT6.DT6_TIPO     = '" + (cAliasDT6)->DT6_TIPO   + "'" + CRLF
						cQuery += "  AND DT6.DT6_DOCTMS IN('B','C','H','I','N','O') "
						cQuery += "  AND DT6.D_E_L_E_T_   = ' '" + CRLF

						cQuery += " WHERE DTC.DTC_FILIAL = '" + xFilial('DTC') + "'" + CRLF
						cQuery += "  AND DTC.DTC_FILDOC   = DT6.DT6_FILDOC " + CRLF
						cQuery += "  AND DTC.DTC_DOC      = DT6.DT6_DOC    " + CRLF
						cQuery += "  AND DTC.DTC_SERIE    = DT6.DT6_SERIE  " + CRLF
						cQuery += "  AND DTC.D_E_L_E_T_   = ' '" + CRLF

						cQuery += " GROUP BY DV3.DV3_INSCR,  DTC.DTC_TIPNFC, DTC.DTC_CODOBS, DTC.DTC_CTRDPC, DTC.DTC_SERDPC, DTC.DTC_TIPANT, "+ CRLF
						cQuery += "          DTC.DTC_DPCEMI, DTC.DTC_CTEANT, DTC.DTC_SELORI, DTC.DTC_SQEDES, DTC.DTC_FILORI, DTC.DTC_NUMSOL, SB1.B1_DESC, SB1.B1_COD , SB1.B1_UM " + CRLF
						cQuery += " ORDER BY MAX(DTC.DTC_VALOR) DESC" + CRLF
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAll, .F., .T.)
						lDocApoio := !(cAliasAll)->(Eof())
					EndIf

					If !(cAliasAll)->(Eof())
						cDTCObs    := NoAcentoCte( StrTran(MsMM((cAliasALL)->DTC_CODOBS),Chr(13),"") )
						If ( AllTrim((cAliasDT6)->DT6_DOCTMS) $ "8" )
							cDTCObs    := NoAcentoCte( StrTran(MsMM((cAliasDT6)->DT6_CODOBS),Chr(13),"") )
						EndIf

						cCtrDpc    := NoAcentoCte( (cAliasALL)->DTC_CTRDPC )
						cSerDpc    := NoAcentoCte( (cAliasALL)->DTC_SERDPC )
						cTpDocAnt  := NoAcentoCte( (cAliasALL)->DTC_TIPANT )
						cDtEmi     := SubStr(AllTrim((cAliasALL)->DTC_DPCEMI), 1, 4) + "-";
									+ SubStr(AllTrim((cAliasALL)->DTC_DPCEMI), 5, 2) + "-";
									+ SubStr(AllTrim((cAliasALL)->DTC_DPCEMI), 7, 2)
						cCTEDocAnt := NoAcentoCte( (cAliasALL)->DTC_CTEANT)

						cTipoNF    := NoAcentoCte( (cAliasAll)->DTC_TIPNFC )
						cSelOri    := (cAliasAll)->( DTC_SELORI )
						cSeqEntr   := (cAliasAll)->( DTC_SQEDES )
						cFilOri    := (cAliasAll)->( DTC_FILORI )
						cNumSol    := (cAliasAll)->( DTC_NUMSOL )

						If !Empty((cAliasAll)->DV3_INSCR)
							cInsRemOpc := NoPontos((cAliasALL)->DV3_INSCR)
						EndIf

						cProdPred := NoAcentoCte( (cAliasAll)->B1_DESC )
						cCodPred  := NoAcentoCte( (cAliasAll)->B1_COD )
						aCarga[5] := NoAcentoCte( (cAliasAll)->B1_UM )
					EndIf
					(cAliasAll)->(DbCloseArea())

					If cTipoNF $ '0,1,3,4,6,7'
						cString   += '<tpServ>0</tpServ>'
					ElseIf cTipoNF == '2'
						cString   += '<tpServ>1</tpServ>'
					ElseIf cTipoNF == '5'
						cString   += '<tpServ>2</tpServ>'
					EndIf

					//�����������������������������������������������������������������Ŀ
					//� Municipio inicio e termino da prestacao                         �
					//�������������������������������������������������������������������
					DUY->(DbSetOrder(1))
					If DUY->(MsSeek(xFilial("DUY")+(cAliasDT6)->DT6_CDRORI))
						If (aScan(aUF,{|x| x[1] == DUY->DUY_EST }) != 0)
							cCodUFOri := aUF[ aScan(aUF,{|x| x[1] == DUY->DUY_EST }), 2]
						Else
							cCodUFOri := ''
						EndIf
						cString += '<cMunIni>' + NoAcentoCte( AllTrim(cCodUFOri ) +  Alltrim( DUY->DUY_CODMUN ) )  + '</cMunIni>'
						cString += '<xMunIni>' + NoAcentoCte( Posicione('CC2',1,xFilial("CC2")+ DUY->DUY_EST + DUY->DUY_CODMUN,"CC2_MUN") ) + '</xMunIni>'
						cString += '<UFIni>'   + NoAcentoCte( DUY->DUY_EST ) + '</UFIni>'
					EndIf					
					
					If !Empty(cSeqEntr) .And. (cAliasDT6)->DT6_DOCTMS <> StrZero(6,Len(DT6->DT6_DOCTMS)) //Devolucao
						cSeekDUL := xFilial('DUL')+(cAliasDT6)->DT6_CLIDES + (cAliasDT6)->DT6_LOJDES + cSeqEntr
						DUL->(DbSetOrder(2))
						If	DUL->(MsSeek(cSeekDUL))
							If aScan(aUF,{|x| x[1] == DUL->DUL_EST }) != 0
								cUfEnt := aUF[ aScan(aUF,{|x| x[1] == DUL->DUL_EST }), 2]
							Else
								cUfEnt := ''
							EndIf
							cString += '<cMunFim>'	+ NoAcentoCte( AllTrim(cUfEnt) + AllTrim(DUL->DUL_CODMUN) ) + '</cMunFim>'
							cString += '<xMunFim>'	+ NoAcentoCte( DUL->DUL_MUN )  + '</xMunFim>'
							cString += '<UFFim>'	+ NoAcentoCte( DUL->DUL_EST )  + '</UFFim>'
						EndIf
					Else
						cString += '<cMunFim>'	+ NoAcentoCte( AllTrim(cCodUFDes ) + AllTrim((cAliasDT6)->DES_COD_MUN ) ) + '</cMunFim>'
						cString += '<xMunFim>'	+ NoAcentoCte( (cAliasDT6)->DES_MUNICI ) + '</xMunFim>'
						cString += '<UFFim>'	+ NoAcentoCte( (cAliasDT6)->DES_UF ) + '</UFFim>'
					EndIf

					//�����������������������������������������������������������������Ŀ
					//� Recebedor retira no aeroporto,filial, porto ou Estacao Destino? �
					//� 0 - SIM / 1 - NAO                                               �
					//�������������������������������������������������������������������
					cString += '<retira>0</retira>'
					cString += '<xDetRetira>NAO SE APLICA</xDetRetira>'

					If	( Empty((cAliasDT6)->DT6_CLICON) .And. Empty((cAliasDT6)->DT6_CLIDPC) ) .Or. ;
						(IIf(!Empty((cAliasDT6)->DT6_CLICON),((cAliasDT6)->DT6_CLICON+(cAliasDT6)->DT6_LOJCON <> (cAliasDT6)->DT6_CLIDEV+(cAliasDT6)->DT6_LOJDEV),.T.)) .And. ;
						(IIf(!Empty((cAliasDT6)->DT6_CLIDPC) ,((cAliasDT6)->DT6_CLIDPC+(cAliasDT6)->DT6_LOJDPC <> (cAliasDT6)->DT6_CLIDEV+(cAliasDT6)->DT6_LOJDEV),.T.))

						cString += '<toma03>'

						//����������������������������Ŀ
						//� Tomador do Servico         �
						//� 0 - Remetente;             �
						//� 1 - Expedidor;             �
						//� 2 - Recebedor;             �
						//� 3 - Destinatario.          �
						//������������������������������
						If (((cAliasDT6)->DT6_CLIREM = (cAliasDT6)->DT6_CLIDEV) .And.;
							((cAliasDT6)->DT6_LOJREM = (cAliasDT6)->DT6_LOJDEV))
							cCNPJToma 		:= AllTrim((cAliasDT6)->REM_CNPJ)
							cPessoaToma 	:= AllTrim((cAliasDT6)->REM_TPPESSOA)
							cString   += '<toma>0</toma>'

						ElseIf (((cAliasDT6)->DT6_CLIDES = (cAliasDT6)->DT6_CLIDEV) .And.;
								((cAliasDT6)->DT6_LOJDES = (cAliasDT6)->DT6_LOJDEV))
							cCNPJToma 		:= AllTrim((cAliasDT6)->DES_CNPJ)
							cPessoaToma 	:= AllTrim((cAliasDT6)->DES_TPPESSOA)
							cString   += '<toma>3</toma>'
						Else
							cString += '<toma>1</toma>'
						EndIf

						cString += '</toma03>'

					ElseIf (((cAliasDT6)->DT6_CLICON = (cAliasDT6)->DT6_CLIDEV) .And.;
							((cAliasDT6)->DT6_LOJCON = (cAliasDT6)->DT6_LOJDEV))
						
						cCNPJToma 		:= AllTrim((cAliasDT6)->CON_CNPJ)
						cPessoaToma 	:= AllTrim((cAliasDT6)->CON_TPPESSOA)
						
						cString += '<toma4>'
						
						//��������������������������������������Ŀ
						//� Tomador do Servico Consignatario     �
						//� 4 - Outros;                          �
						//����������������������������������������
						cString += '<toma>4</toma>'
						
						If (AllTrim((cAliasDT6)->CON_TPPESSOA) == "J")
							cString += '<CNPJ>' + AllTrim((cAliasDT6)->CON_CNPJ) + '</CNPJ>'
						Else
							cString += '<CPF>'  + AllTrim((cAliasDT6)->CON_CNPJ) + '</CPF>'
						EndIf
						
						If Empty((cAliasDT6)->CON_INSC) .Or. "ISENT" $ Upper(AllTrim((cAliasDT6)->CON_INSC))
							cString += '<IE>ISENTO</IE>'
						Else
							cString += '<IE>' + NoPontos((cAliasDT6)->CON_INSC) + '</IE>'
						EndIf
						
						cString += '<xNome>' + NoAcentoCte(SubStr((cAliasDT6)->CON_NOME,1,60)) + '</xNome>'
						If  !Empty(NoPontos((cAliasDT6)->CON_TEL))
							cString += '<fone>'  +  cValtoChar(NoPontos((cAliasDT6)->CON_DDDTEL)) +;
							cValtoChar(NoPontos((cAliasDT6)->CON_TEL)) + '</fone>'
						EndIf
						cString += '<enderToma>'
						cString += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasDT6)->CON_END)[1]) + '</xLgr>'
						cString += '<nro>'  + Iif(FisGetEnd((cAliasDT6)->CON_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasDT6)->CON_END)[2])),"S/N") + '</nro>'
						
						If !Empty(NoAcentoCte(FisGetEnd((cAliasDT6)->CON_END)[4]))
							cString += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasDT6)->CON_END)[4]) + '</xCpl>'
						EndIf
						
						If Empty(AllTrim((cAliasDT6)->CON_BAIRRO))
							cString += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
						Else
							cString += '<xBairro>' +NoAcentoCte( (cAliasDT6)->CON_BAIRRO ) + '</xBairro>'
						EndIf
						
						cString += '<cMun>' + NoAcentoCte( AllTrim(cCodUFCon)         + AllTrim((cAliasDT6)->CON_COD_MUN) ) + '</cMun>'
						cString += '<xMun>' + NoAcentoCte( (cAliasDT6)->CON_MUNICI ) + '</xMun>'
						cString += '<CEP>'  + NoAcentoCte( (cAliasDT6)->CON_CEP )    + '</CEP>'
						cString += '<UF>'   + NoAcentoCte( (cAliasDT6)->CON_UF )     + '</UF>'
						cString += '</enderToma>'
						If !Empty((cAliasDT6)->CON_EMAIL)
							cString += '<email>' + AllTrim((cAliasDT6)->CON_EMAIL) + '</email>'
						EndIf
						cString += '</toma4>'
						
					ElseIf (((cAliasDT6)->DT6_CLIDPC = (cAliasDT6)->DT6_CLIDEV) .And.;
							((cAliasDT6)->DT6_LOJDPC = (cAliasDT6)->DT6_LOJDEV))
						
						cCNPJToma 	:= AllTrim((cAliasDT6)->DPC_CNPJ)
						cPessoaToma := AllTrim((cAliasDT6)->DPC_TPPESSOA)  
						
						cString += '<toma4>'
						
						//��������������������������������������Ŀ
						//� Tomador do Servico Despachante       �
						//� 4 - Outros;                          �
						//����������������������������������������
						cString += '<toma>4</toma>'
						If (AllTrim((cAliasDT6)->DPC_TPPESSOA) == "J")
							cString += '<CNPJ>' + NoAcentoCte( (cAliasDT6)->DPC_CNPJ ) + '</CNPJ>'
						Else
							cString += '<CPF>'  + NoAcentoCte( (cAliasDT6)->DPC_CNPJ ) + '</CPF>'
						EndIf

						If Empty((cAliasDT6)->DPC_INSC) .Or. 'ISENT' $ Upper(AllTrim((cAliasDT6)->DPC_INSC)) .Or. ((cAliasDT6)->DPC_CONTRIB =='1' .And. 'ISENT' $ Upper(AllTrim((cAliasDT6)->DPC_INSC)))
							cString += '<IE>ISENTO</IE>'
						Else
							cString += '<IE>' + NoPontos((cAliasDT6)->DPC_INSC) + '</IE>'
						EndIf

						cString += '<xNome>' + NoAcentoCte(SubStr((cAliasDT6)->DPC_NOME,1,60)) + '</xNome>'
						cString += '<enderToma>'
						cString += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasDT6)->DPC_END)[1]) + '</xLgr>'
						cString += '<nro>' + Iif(FisGetEnd((cAliasDT6)->DPC_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasDT6)->DPC_END)[2])),"S/N") + '</nro>'
						If !Empty(NoAcentoCte(FisGetEnd((cAliasDT6)->DPC_END)[4]))
							cString += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasDT6)->DPC_END)[4]) + '</xCpl>'
						EndIf
						If Empty(AllTrim((cAliasDT6)->DPC_BAIRRO))
							cString += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
						Else
							cString += '<xBairro>' + NoAcentoCte( (cAliasDT6)->DPC_BAIRRO ) + '</xBairro>'
						EndIf
						cString += '<cMun>' + NoAcentoCte( AllTrim(cCodUFDpc) + Alltrim((cAliasDT6)->DPC_COD_MUN) ) + '</cMun>'
						cString += '<xMun>' + NoAcentoCte( (cAliasDT6)->DPC_MUNICI ) + '</xMun>'
						cString += '<CEP>'  + NoAcentoCte( (cAliasDT6)->DPC_CEP )    + '</CEP>'
						cString += '<UF>'   + NoAcentoCte( (cAliasDT6)->DPC_UF )     + '</UF>'
						cString += '</enderToma>'
						If !Empty((cAliasDT6)->DPC_EMAIL)
							cString += '<email>' + AllTrim((cAliasDT6)->DPC_EMAIL) + '</email>'
						EndIf
						cString += '</toma4>'
					EndIf

					//�����������������������������������������������������������������Ŀ
					//�Contigencia 1.04                                                 �
					//�Data e hora de entrada em contigencia                            �
					//�Formato = AAAA-MM-DDTHH:MM:SS                                    �
					//�Justificativa da Contigencia -                                   �
					//�Preenchida no momento de escolha da opcao de Contigencia FSDA    �
					//�������������������������������������������������������������������
					If	cModalidade == '7'
						If	Len(aMotivoCont) >= 3
							cDtCont := DTOS(aMotivoCont[2])
							cString += '<dhCont>' + SubStr(AllTrim(cDtCont), 1, 4) + "-";
							+ SubStr(AllTrim(cDtCont), 5, 2) + "-";
							+ SubStr(AllTrim(cDtCont), 7, 2) + "T";
							+ SubStr(AllTrim(aMotivoCont[3]), 1, 2) + ":";
							+ SubStr(AllTrim(aMotivoCont[3]), 4, 2) + ':00</dhCont>'
							cString += '<xJust>' + aMotivoCont[1] + '</xJust>'
						EndIf
					EndIf

					//�����������������������������������������������������������������Ŀ
					//�Contigencia EPEC 1.04                                            �
					//�Data e hora de entrada em contigencia EPEC                       �
					//�Formato = AAAA-MM-DDTHH:MM:SS                                    �
					//�Justificativa da Contigencia - EPEC                              �
					//�Preenchida no momento de escolha da opcao de Contigencia FSDA    �
					//�������������������������������������������������������������������
					/*
					If	cModalidade == '5'   
						If	Len(aMotivoCont) >= 3
							cDtCont := DTOS(aMotivoCont[2])
							cString += '<dhCont>' + SubStr(AllTrim(cDtCont), 1, 4) + "-";
							+ SubStr(AllTrim(cDtCont), 5, 2) + "-";
							+ SubStr(AllTrim(cDtCont), 7, 2) + "T";
							+ SubStr(AllTrim(aMotivoCont[3]), 1, 2) + ":";
							+ SubStr(AllTrim(aMotivoCont[3]), 4, 2) + ':00</dhCont>'
							cString += '<xJust>' + aMotivoCont[1] + '</xJust>'
						EndIf					
					EndIf
                     */
					cString += '</ide>'
					aAdd(aXMLCTe,AllTrim(cString))

					//������������������������������������������������������������������Ŀ
					//� TAG: Dados complementares do CT-e para fins operacionais ou      �
					//� comerciaisEmitente do CT-e                                       �
					//��������������������������������������������������������������������
					If !Empty(cDTCObs) .Or. (cAliasDT6)->DT6_VALIMP > 0
						cString := '<compl>'
						//-- Observacoes Gerais
						If !Empty(cDTCObs)
							cString +=  '<xObs>' + NoAcentoCte(SubStr(cDTCObs,1,320)) + '</xObs>'
						EndIf
						//-- Observacoes Contribuintes - Uso exclusivo do emissor CT-E
						If (cAliasDT6)->DT6_VALIMP > 0
							cTxtObs := 'O valor aproximado de tributos incidentes sobre o preco deste servico e de R$ ' + PADL(Transform((cAliasDT6)->DT6_VALIMP,'@E 999,999.99'),20)
							cString +=  '<ObsCont xCampo="LeidaTransparencia">'
							cString +=    '<xTexto>'+cTxtObs+'</xTexto>'
							cString +=  '</ObsCont>'
							cString += '</compl>'
						Else
							cString += '</compl>'	
						EndIf
						aAdd(aXMLCTe,AllTrim(cString))
					EndIf

					//������������������������������������������������������������������Ŀ
					//� TAG: D - Emitente do CT-e                                        �
					//��������������������������������������������������������������������
					cString := '<emit>'
					cString += '<CNPJ>' + NoPontos(SM0->M0_CGC) + '</CNPJ>'

					If (AllTrim(SM0->M0_INSC) == 'ISENTO')
						cString += '<IE>ISENTO</IE>'
					Else
						cString += '<IE>' + NoPontos(SM0->M0_INSC) + '</IE>'
					EndIf

					cString += '<xNome>' + NoAcentoCte(SubStr(SM0->M0_NOMECOM,1,60)) + '</xNome>'
					cString += '<xFant>' + NoAcentoCte(SM0->M0_NOME) + '</xFant>'
					cString += '<enderEmit>'
					cString += '<xLgr>' + NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[1]) + '</xLgr>'
					cString += '<nro>'  + Iif(FisGetEnd(SM0->M0_ENDENT)[2]<>0, AllTrim(cValtoChar( FisGetEnd(SM0->M0_ENDENT)[2])),"S/N") + '</nro>'
					If !Empty(NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[4]))
						cString += '<xCpl>' + NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[4]) + '</xCpl>'
					EndIf
					If Empty(AllTrim(SM0->M0_BAIRENT))
						cString += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
					Else
						cString += '<xBairro>' + NoAcentoCte( SM0->M0_BAIRENT ) + '</xBairro>'
					EndIf

					cString += '<cMun>' + NoAcentoCte( SM0->M0_CODMUN ) + '</cMun>'
					cString += '<xMun>' + NoAcentoCte( SM0->M0_CIDENT ) + '</xMun>'
					cString += '<CEP>'  + NoAcentoCte( SM0->M0_CEPENT ) + '</CEP>'
					cString += '<UF>'   + NoAcentoCte( SM0->M0_ESTENT ) + '</UF>'
					If !Empty (NoPontos(SM0->M0_TEL))
						cString += '<fone>' + cValtoChar(NoPontos(SM0->M0_TEL)) + '</fone>'
					EndIf
					cString += '</enderEmit>'
					cString += '</emit>'

					aAdd(aXMLCTe,AllTrim(cString))

					//������������������������������������������������������������������Ŀ
					//� TAG: E - Remetente das mercadorias transportadas pelo CT-e       �
					//��������������������������������������������������������������������
					cString := ''
					cString += '<rem>'
					If (AllTrim((cAliasDT6)->REM_TPPESSOA) == "J")
						cString += '<CNPJ>' + IIf((cAliasDT6)->REM_UF <> 'EX',NoAcentoCte( (cAliasDT6)->REM_CNPJ ),StrZero(0,14)) + '</CNPJ>'
						
						//-- Qdo sequencia do IE estiver preenchida.
						If Empty(cInsRemOpc)
							If Empty((cAliasDT6)->REM_INSC) .Or. "ISENT" $ Upper(AllTrim((cAliasDT6)->REM_INSC))
								cString += '<IE>ISENTO</IE>'
							Else
								cString += '<IE>' + NoPontos((cAliasDT6)->REM_INSC) + '</IE>'
							EndIf
						ElseIf 'ISENT' $ Upper(cInsRemOpc)
							cString += '<IE>ISENTO</IE>'
						Else
							cString += '<IE>' + NoPontos(cInsRemOpc) + '</IE>'
						EndIf
						
					Else
						cString += '<CPF>' + IIf((cAliasDT6)->REM_UF <> 'EX',NoAcentoCte( (cAliasDT6)->REM_CNPJ ),StrZero(0,14) ) + '</CPF>'

						//-- Qdo sequencia do IE estiver preenchida.
						If Empty(cInsRemOpc)
							If Empty((cAliasDT6)->REM_INSC) .Or. 'ISENT' $ Upper(AllTrim((cAliasDT6)->REM_INSC))
								cString += '<IE>ISENTO</IE>'
							Else
								cString += '<IE>' + NoPontos((cAliasDT6)->REM_INSC) + '</IE>'
							EndIf
						Else
							If 'ISENT' $ Upper(AllTrim(cInsRemOpc))
								cString += '<IE>ISENTO</IE>'
							Else
								cString += '<IE>' + NoPontos(cInsRemOpc) + '</IE>'
							EndIf
						EndIf
						
					EndIf

					If cAmbiente == '2'  //--Homologacao / Nota T�cnica 2012/005 
						cString += '<xNome>' + (SubStr('CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
					Else
						cString += '<xNome>' + NoAcentoCte(SubStr((cAliasDT6)->REM_NOME,1,60)) + '</xNome>'
					EndIf
					cString += '<xFant>' + NoAcentoCte((cAliasDT6)->REM_NMEFANT) + '</xFant>'
					If !Empty((cAliasDT6)->REM_TEL)
						cString += '<fone>' + cValtoChar(NoPontos((cAliasDT6)->REM_DDDTEL)) +;
						cValtoChar(NoPontos((cAliasDT6)->REM_TEL)) + '</fone>'
					EndIf
					
					cString += '<enderReme>'
					cString += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasDT6)->REM_END)[1]) + '</xLgr>'
					cString += '<nro>' + Iif(FisGetEnd((cAliasDT6)->REM_END)[2] <> 0, AllTrim(cValtoChar( FisGetEnd((cAliasDT6)->REM_END)[2])),"S/N") + '</nro>'
					If !Empty(NoAcentoCte(FisGetEnd((cAliasDT6)->REM_END)[4]))
						cString += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasDT6)->REM_END)[4]) + '</xCpl>'
					EndIf
					If Empty(AllTrim((cAliasDT6)->REM_BAIRRO))
						cString += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
					Else
						cString += '<xBairro>' + NoAcentoCte( (cAliasDT6)->REM_BAIRRO ) + '</xBairro>'
					EndIf
					cString += '<cMun>' + NoAcentoCte( AllTrim(cCodUFRem) + AllTrim((cAliasDT6)->REM_COD_MUN) ) + '</cMun>'
					cString += '<xMun>' + NoAcentoCte( (cAliasDT6)->REM_MUNICI ) + '</xMun>'
					cString += '<CEP>'  + NoAcentoCte( (cAliasDT6)->REM_CEP ) + '</CEP>'
					cString += '<UF>'   + NoAcentoCte( (cAliasDT6)->REM_UF ) + '</UF>'
					If !Empty(AllTrim((cAliasDT6)->REM_PAIS))
						cString += '<cPais>'+ NoAcentoCte( (cAliasDT6)->REM_PAIS ) + '</cPais>'
						cString += '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+(cAliasDT6)->REM_PAIS,"YA_DESCR") ) + '</xPais>'
					EndIf
					cString += '</enderReme>'
					If !Empty((cAliasDT6)->REM_EMAIL)
						cString += '<email>' + AllTrim((cAliasDT6)->REM_EMAIL) + '</email>'
					EndIf
										
					//������������������������������������������������������������������Ŀ
					//� TAG: locColeta - Local de Coleta                                 �
					//��������������������������������������������������������������������
					
					If cVerAmb == '2.00'					
						If !AllTrim(cNumSol) == ''
			   				cAliasDT5:= GetNextAlias()
							cQuery := " SELECT A1_COD, A1_LOJA, A1_CGC, A1_PESSOA, "
				   			cQuery += "   DUE_CODCLI, DUE_LOJCLI, DUE_NREDUZ, DUE_END, DUE_BAIRRO, DUE_CODMUN,DUE_MUN, DUE_EST, "
				   			cQuery += "   DUL_CODRED, DUL_LOJRED, DUL_CODCLI, DUL_LOJCLI, DUL_END, DUL_BAIRRO, DUL_CODMUN, DUL_MUN, DUL_EST "
				   			cQuery += "	FROM " + RetSQLName("DT5") + " DT5 "
				   			cQuery += "  JOIN " + RetSQLName("DUE") + " DUE "
					 		cQuery += "   ON DUE_FILIAL = '" + xFilial('DUE') + "'" 
					    	cQuery += "    AND DUE_DDD   = DT5_DDD "
					   		cQuery += "    AND DUE_TEL   = DT5_TEL " 
					 		cQuery += "    AND DUE.D_E_L_E_T_ = ' ' "
					 		cQuery += "  JOIN " + RetSQLName("SA1") + " SA1 "
					 		cQuery += "    ON A1_COD = DUE_CODCLI "
					 		cQuery += "    AND  A1_LOJA = DUE_LOJCLI "
					 		cQuery += "    AND SA1.D_E_L_E_T_ = ' ' "
				     		cQuery += "  LEFT JOIN " + RetSqlName("DUL") + " DUL "
					 		cQuery += "   ON DUL_FILIAL = '" + xFilial('DUL') + "'"
							cQuery += "	   AND DUL_DDD    = DT5_DDD "
							cQuery += "	   AND DUL_TEL    = DT5_TEL "
							cQuery += "	   AND DUL_SEQEND = DT5_SEQEND "
							cQuery += "	   AND DUL.D_E_L_E_T_ = ' ' "
							cQuery += "  WHERE DT5_FILIAL	= '" + xFilial("DT5") + "' "
							cQuery += "    AND DT5_FILORI  = '" + cFilOri + "' "
							cQuery += "    AND DT5_NUMSOL  = '" + cNumSol + "' "
							cQuery += "    AND DT5.D_E_L_E_T_ = ' ' "
							cQuery := ChangeQuery(cQuery)
							DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDT5,.T.,.T.)
					
							If !(cAliasDT5)->(Eof())
								If (!Empty(Alltrim((cAliasDT5)->DUE_CODCLI)) .And. (!Empty(AllTrim((cAliasDT5)->DUE_LOJCLI))))
									If ((cAliasDT6)->DT6_CLIREM == (cAliasDT5)->DUE_CODCLI .And. (cAliasDT6)->DT6_LOJREM == (cAliasDT5)->DUE_LOJCLI)
										If (Empty(Alltrim((cAliasDT5)->DUL_CODRED)) .And. Empty(Alltrim((cAliasDT5)->DUL_LOJRED)))
										    If !Empty((cAliasDT5)->(DUL_END))
												cString += '<locColeta>'
												// Enderenco Solicitante DUL
												If aScan(aUF,{|x| x[1] == (cAliasDT5)->DUL_EST }) != 0   //Confere se Uf do End.Solicitante esta OK
													cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT5)->DUL_EST }), 2]
												Else
													cCodUFOri  := ''
												EndIf
												If (AllTrim((cAliasDT5)->A1_PESSOA) == "J")
													cString += '<CNPJ>' + NoPontos((cAliasDT5)->A1_CGC) + '</CNPJ>'
												Else
													cString += '<CPF>' + AllTrim((cAliasDT5)->A1_CGC) + '</CPF>'
												EndIf
												cString += '<xNome>'+ NoAcentoCte( (cAliasDT5)->(DUE_NREDUZ) ) +'</xNome>'
												cString += '<xLgr>'+ NoAcentoCte( (cAliasDT5)->(DUL_END) ) +'</xLgr>'
												cString += '<nro>'  + Iif(FisGetEnd((cAliasDT5)->DUL_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasDT5)->DUL_END)[2])),"S/N") + '</nro>'								
												cString += '<xBairro>'+ NoAcentoCte( (cAliasDT5)->(DUL_BAIRRO) ) +'</xBairro>'
												cString += '<cMun>'+ NoAcentoCte( AllTrim(cCodUFOri) + AllTrim((cAliasDT5)->(DUL_CODMUN)) ) +'</cMun>'
												cString += '<xMun>'+ NoAcentoCte( (cAliasDT5)->(DUL_MUN) ) +'</xMun>' 
												cString += '<UF>'+ NoAcentoCte( (cAliasDT5)->(DUL_EST) ) +'</UF>'
												cString += '</locColeta>'
											EndIf	
										Else
											//Faz um select na SA1 para pegar o Redespachante / Origem da Coleta	   
								   			cAliasCol:= GetNextAlias()									                  
											cQuery := " SELECT DUL_CODRED, DUL_LOJRED, "
											cQuery += "	A1_COD, A1_LOJA, A1_CGC, A1_PESSOA,A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST," 
											cQuery += "   A1_COD_MUN, A1_INSCR, A1_PAIS, A1_DDD, A1_TEL, A1_CEP  "
											cQuery += "  FROM " + RetSqlName("DUL") + " DUL, " 
											cQuery += RetSqlName("SA1") + " SA1 "
											cQuery += "  WHERE SA1.A1_FILIAL = '" + xFilial('SA1') + "'"
											cQuery += "	 AND DUL.DUL_FILIAL = '" + xFilial('DUL') + "'"
											cQuery += "	 AND A1_COD = '" + (cAliasDT5)->DUL_CODRED + "'"
											cQuery += "     AND A1_LOJA = '" + (cAliasDT5)->DUL_LOJRED + "'"
											cQuery += "     AND SA1.D_E_L_E_T_ = ' ' "
											cQuery += "     AND DUL.D_E_L_E_T_ = ' ' "
											cQuery := ChangeQuery(cQuery)
											DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasCol,.T.,.T.)
											If !(cAliasCol)->(Eof())
												cStringExp := ""
												cStringExp += '<exped>'
												// Enderenco Solicitante DUL
												If aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }) != 0   //Confere se Uf do End.Solicitante esta OK
													cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }), 2]
												Else
													cCodUFOri  := ''
												EndIf
												If (AllTrim((cAliasCol)->(A1_PESSOA)) == "J")
													cStringExp += '<CNPJ>' + NoPontos((cAliasCol)->A1_CGC) + '</CNPJ>'
												Else
													cStringExp += '<CPF>' + AllTrim((cAliasCol)->A1_CGC) + '</CPF>'
												EndIf
												
												If 'ISENT' $ Upper(AllTrim((cAliasCol)->A1_INSCR))
													cStringExp += '<IE>ISENTO</IE>'
												Else
													cStringExp += '<IE>' + NoPontos((cAliasCol)->A1_INSCR) + '</IE>'
												EndIf
				
												If cAmbiente == '2'  //--Homologacao / Nota T�cnica 2012/005 
													cStringExp += '<xNome>' + (SubStr('CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
												Else
													cStringExp += '<xNome>' + NoAcentoCte(SubStr((cAliasCol)->A1_NOME,1,60)) + '</xNome>'
												EndIf
												
												If !Empty((cAliasCol)->A1_TEL)
													cStringExp += '<fone>' + cValtoChar(NoPontos((cAliasCol)->A1_DDD)) +;
													cValtoChar(NoPontos((cAliasCol)->A1_TEL)) + '</fone>'
												EndIf
												
												cStringExp += '<enderExped>'
												cStringExp += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasCol)->A1_END)[1]) + '</xLgr>'
												cStringExp += '<nro>' + Iif(FisGetEnd((cAliasCol)->A1_END)[2] <> 0, AllTrim(cValtoChar( FisGetEnd((cAliasCol)->A1_END)[2])),"S/N") + '</nro>'
												If !Empty(NoAcentoCte(FisGetEnd((cAliasCol)->A1_END)[4]))
													cStringExp += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasCol)->A1_END)[4]) + '</xCpl>'
												EndIf
												If Empty(AllTrim((cAliasCol)->A1_BAIRRO))
													cStringExp += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
												Else
													cStringExp += '<xBairro>' + NoAcentoCte( (cAliasCol)->A1_BAIRRO ) + '</xBairro>'
												EndIf
												cStringExp += '<cMun>' + NoAcentoCte( AllTrim(cCodUFOri) + AllTrim((cAliasCol)->A1_COD_MUN) ) + '</cMun>'
												cStringExp += '<xMun>' + NoAcentoCte( (cAliasCol)->A1_MUN ) + '</xMun>'
												cStringExp += '<CEP>'  + NoAcentoCte( (cAliasCol)->A1_CEP ) + '</CEP>'
												cStringExp += '<UF>'   + NoAcentoCte( (cAliasCol)->A1_EST ) + '</UF>'
												If !Empty(AllTrim((cAliasCol)->A1_PAIS))
													cStringExp += '<cPais>'+ NoAcentoCte( (cAliasCol)->A1_PAIS ) + '</cPais>'
													cStringExp += '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+(cAliasCol)->A1_PAIS,"YA_DESCR") ) + '</xPais>'
												EndIf
												cStringExp += '</enderExped>'
												cStringExp += '</exped>'
												
												(cAliasCol)->(DbCloseArea())
											EndIF
										EndIf
									Else
										//Faz um Select no SA1 para codigo do remetente diferente do solicitante
							   			cAliasCol:= GetNextAlias()								                  
										cQuery := " SELECT DUE_CODCLI, DUE_LOJCLI, "
										cQuery += "	A1_COD, A1_LOJA, A1_CGC, A1_PESSOA,A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_COD_MUN "
										cQuery += "  FROM " + RetSqlName("DUE") + " DUE, "
										cQuery += RetSqlName("SA1") + " SA1 "
										cQuery += "  WHERE SA1.A1_FILIAL = '" + xFilial('SA1') + "'"
										cQuery += "	 AND DUE.DUE_FILIAL = '" + xFilial('DUE') + "'"
										cQuery += "	 AND A1_COD = '" + (cAliasDT5)->DUE_CODCLI + "'"
										cQuery += "     AND A1_LOJA = '" + (cAliasDT5)->DUE_LOJCLI + "'"
										cQuery += "     AND SA1.D_E_L_E_T_ = ' '
										cQuery += "     AND DUE.D_E_L_E_T_ = ' '
										cQuery := ChangeQuery(cQuery)
										DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasCol,.T.,.T.)
										If !(cAliasCol)->(Eof())
											cString += '<locColeta>'
											// Enderenco Solicitante DUL
											If aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }) != 0   //Confere se Uf do End.Solicitante esta OK
												cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }), 2]
											Else
												cCodUFOri  := ''
											EndIf
											If (AllTrim((cAliasCol)->(A1_PESSOA)) == "J")
												cString += '<CNPJ>' + NoPontos((cAliasCol)->A1_CGC) + '</CNPJ>'
											Else
												cString += '<CPF>' + AllTrim((cAliasCol)->A1_CGC) + '</CPF>'
											EndIf
											cString += '<xNome>'+ NoAcentoCte((cAliasCol)->(A1_NOME) ) +'</xNome>'
											cString += '<xLgr>'+ NoAcentoCte( (cAliasCol)->(A1_END) ) +'</xLgr>'
											cString += '<nro>'  + Iif(FisGetEnd((cAliasCol)->A1_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasCol)->A1_END)[2])),"S/N") + '</nro>'								
											cString += '<xBairro>'+ NoAcentoCte( (cAliasCol)->(A1_BAIRRO) ) +'</xBairro>'
											cString += '<cMun>'+ NoAcentoCte( AllTrim(cCodUFOri) + AllTrim((cAliasCol)->(A1_COD_MUN)) ) +'</cMun>'
											cString += '<xMun>'+ NoAcentoCte( (cAliasCol)->(A1_MUN) ) +'</xMun>' 
											cString += '<UF>'+ NoAcentoCte( (cAliasCol)->(A1_EST) ) +'</UF>'
											cString += '</locColeta>'
											(cAliasCol)->(DbCloseArea())
										EndIF
									EndIf
								EndIf
							EndIf
							(cAliasDT5)->(DbCloseArea())			
						EndIf 
					EndIf	
					
					aAdd(aXMLCTe,AllTrim(cString))
					cString	  := ""		
						
					//������������������������������������������������������������������Ŀ
					//� TAG: E - Grupos de informacoes das NF                            �
					//��������������������������������������������������������������������
					cAliasTagE := GetNextAlias()
					cQuery := " SELECT DTC.DTC_NUMNFC, DTC.DTC_SERNFC, DTC.DTC_EMINFC, " + CRLF
					cQuery += "	       DTC.DTC_NFEID,  DTC.DTC_SQEDES, DTC.DTC_TIPNFC, " + CRLF
					cQuery += "        DTC.DTC_TIPNFC, DTC.DTC_FILORI, DTC.DTC_NUMSOL, " + CRLF
					cQuery += "        DTC.DTC_SELORI, DTC_CF, DTC_DTENTR, DTC_FILCFS, " + CRLF
					cQuery += "        SUM(DTC.DTC_BASICM) DTC_BASICM, SUM(DTC.DTC_VALICM) DTC_VALICM, " + CRLF
					cQuery += "        SUM(DTC.DTC_BASESU) DTC_BASESU, SUM(DTC.DTC_VALIST) DTC_VALIST, " + CRLF
					cQuery += "        SUM(DTC.DTC_VALOR)  DTC_VALOR,  SUM(DTC.DTC_PESO)   DTC_PESO,   " + CRLF
					cQuery += "        SUM(DTC.DTC_PESOM3) DTC_PESOM3, SUM(DTC.DTC_METRO3) DTC_METRO3, " + CRLF
					cQuery += "        SUM(DTC.DTC_QTDVOL) DTC_QTDVOL " + CRLF
					cQuery += "   FROM " + RetSqlName('DTC') + " DTC " + CRLF
					If	lDocApoio
						cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 " + CRLF
						cQuery += "   ON DT6.DT6_CLIDEV   = '" + (cAliasDT6)->DT6_CLIDEV + "'" + CRLF
						cQuery += "  AND DT6.DT6_LOJDEV   = '" + (cAliasDT6)->DT6_LOJDEV + "'" + CRLF
						cQuery += "  AND DT6.DT6_PREFIX   = '" + (cAliasDT6)->DT6_PREFIX + "'" + CRLF
						cQuery += "  AND DT6.DT6_NUM      = '" + (cAliasDT6)->DT6_NUM    + "'" + CRLF
						cQuery += "  AND DT6.DT6_TIPO     = '" + (cAliasDT6)->DT6_TIPO   + "'" + CRLF
						cQuery += "  AND DT6_DOCTMS IN('B','C','H','I','N','O') "
						cQuery += "  AND DT6.D_E_L_E_T_   = ' '" + CRLF
					EndIf
					If !lDocApoio .And. !Empty((cAliasDT6)->DT6_DOCDCO)
						cQuery += "    INNER JOIN " + RetSqlName('DT6') + " DT6 ON " + CRLF
						cQuery += "    DT6.DT6_DOC = '" + (cAliasDT6)->DT6_DOCDCO + "'" + CRLF
						cQuery += "    AND DT6.DT6_SERIE   = '" + (cAliasDT6)->DT6_SERDCO + "'" + CRLF
						cQuery += "    AND DT6.DT6_FILDOC  = '" + (cAliasDT6)->DT6_FILDCO + "'" + CRLF
						cQuery += "    AND DT6.D_E_L_E_T_  = ' '" + CRLF
					EndIf
					//-- DTC - Documento Cliente para Transporte
					cQuery += "  WHERE DTC.DTC_FILIAL	= '" + xFilial('DTC') + "'" + CRLF
					//������������������������������������������������������������������Ŀ
					//� Se o tipo de Conhecimento for de Complemento, seleciona as       �
					//� informacoes do CTR principal, pois o complemento nao tem DTC     �
					//��������������������������������������������������������������������
					If lDocApoio
						cQuery += "  AND DTC.DTC_FILDOC   = DT6.DT6_FILDOC " + CRLF
						cQuery += "  AND DTC.DTC_DOC      = DT6.DT6_DOC    " + CRLF
						cQuery += "  AND DTC.DTC_SERIE    = DT6.DT6_SERIE  " + CRLF
					Else
						If !Empty((cAliasDT6)->DT6_DOCDCO)
							cQuery += "    AND DTC.DTC_FILDOC   = '" + (cAliasDT6)->DT6_FILDCO + "'" + CRLF
							cQuery += "    AND DTC.DTC_DOC      = '" + (cAliasDT6)->DT6_DOCDCO + "'" + CRLF
							cQuery += "    AND DTC.DTC_SERIE    = '" + (cAliasDT6)->DT6_SERDCO + "'" + CRLF
						Else
							cQuery += "    AND DTC.DTC_FILDOC   = '" + (cAliasDT6)->DT6_FILDOC + "'" + CRLF
							cQuery += "    AND DTC.DTC_DOC      = '" + (cAliasDT6)->DT6_DOC    + "'" + CRLF
							cQuery += "    AND DTC.DTC_SERIE    = '" + (cAliasDT6)->DT6_SERIE  + "'" + CRLF
						EndIf
					EndIf
					cQuery += "  AND DTC.D_E_L_E_T_ = ' '" + CRLF
					cQuery += "  GROUP BY DTC.DTC_NUMNFC, DTC.DTC_SERNFC, DTC.DTC_EMINFC, DTC_FILCFS,  " + CRLF
					cQuery += "           DTC.DTC_NFEID,  DTC.DTC_SQEDES, DTC.DTC_TIPNFC, DTC_DTENTR,  " + CRLF
					cQuery += "           DTC.DTC_FILORI, DTC.DTC_NUMSOL, DTC.DTC_SELORI, DTC_CF" + CRLF
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTagE, .F., .T.)

					lSelOcor := (cAliasTagE)->DTC_SELORI == '3'
					cSeqEntr := (cAliasTagE)->DTC_SQEDES

					//������������������������������������������������������������������Ŀ
					//� Verifica se possui viagem                                        �
					//��������������������������������������������������������������������
					cViagem  := Posicione('DTP',2,xFilial('DTP')+(cAliasDT6)->DT6_FILORI+(cAliasDT6)->DT6_LOTNFC,'DTP_VIAGEM')
					cFilVia  := ''
					
					//Busca a viagem quando for coleta com entrega direta
					If Empty(cViagem) .And. !Empty((cAliasTagE)->DTC_DTENTR)
						cAliasViag := GetNextAlias()
						cQuery := " SELECT Max(DUD.R_E_C_N_O_) DUDRECNO"
						cQuery += "  FROM " + RetSqlName('DUD') + " DUD "
						cQuery += "  WHERE DUD.DUD_FILIAL	 = '" + xFilial("DUD")  + "'" + CRLF
						cQuery += "    AND DUD.DUD_FILDOC	 = '" + (cAliasTagE)->DTC_FILCFS + "'" + CRLF
						cQuery += "    AND DUD.DUD_DOC   	 = '" + (cAliasTagE)->DTC_NUMSOL + "'" + CRLF
						cQuery += "    AND DUD.DUD_SERIE   	 = 'COL'" + CRLF
						cQuery += "    AND DUD.D_E_L_E_T_ 	 = '' "
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasViag, .F., .T.)
						If (cAliasViag)->(!Eof())
							DUD->( DbGoto( (cAliasViag)->DUDRECNO ) )
							cFilVia := DUD->DUD_FILORI
							cViagem := DUD->DUD_VIAGEM							
						EndIf
						(cAliasViag)->(dbCloseArea())
					EndIf
					
					If !Empty(cViagem)
						cAliasDev := GetNextAlias()
						cQuery := " SELECT DT6.DT6_CLIDEV, DT6.DT6_LOJDEV "
						cQuery += "  FROM " + RetSqlName('DT6') + " DT6 "
						cQuery += "  WHERE DT6_FILIAL     = '" + xFilial("DT6")  + "'" + CRLF
						cQuery += "    AND DT6.DT6_FILORI = '" + DTP->DTP_FILORI + "'" + CRLF
						cQuery += "    AND DT6.DT6_LOTNFC = '" + DTP->DTP_LOTNFC + "'" + CRLF
						cQuery += "    AND D_E_L_E_T_     = '' "
						cQuery += "  GROUP BY DT6.DT6_CLIDEV, DT6.DT6_LOJDEV " + CRLF
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasDev, .F., .T.)
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

					If ((cAliasTagE)->DTC_TIPNFC) $ '3,6,7'	// -- Documento Nao Fiscal
						//����������������������������������������������������Ŀ
						//� TAG de grupo de informacoes dos demais documentos  �
						//� Ex: Delaracao, Outros                              �
						//������������������������������������������������������
						While !(cAliasTagE)->(Eof())					 //Preenche aCarga totalizando todos os produtos do Ct-e
						
							cString += '<infOutros>'
							cString += '<tpDoc>99</tpDoc>'
							cString += '<nDoc>'+NoAcentoCte(AllTrim((cAliasTagE)->DTC_NUMNFC))+'</nDoc>'
							cString += '<dEmi>'	+ SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 1, 4) + "-" ;
							+ SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 5, 2) + "-" ;
							+ SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 7, 2) + '</dEmi>'
							cString += '</infOutros>'

							aCarga[1] += (cAliasTagE)->DTC_PESO
							aCarga[2] += (cAliasTagE)->DTC_PESOM3
							aCarga[3] += (cAliasTagE)->DTC_METRO3
							aCarga[4] += (cAliasTagE)->DTC_QTDVOL
							(cAliasTagE)->(dbSkip())
						Enddo
						   
						If cVerAmb == '2.00'
						    cStringOut	+= cString  
						    cString 		:= ''
						Endif
					Else
					

						While (cAliasTagE)->(!Eof())

							If !Empty((cAliasTagE)->DTC_NFEID)
								
								//���������������������������������Ŀ
								//� INFNFE: IdentIficador da NF-e   �
								//�����������������������������������
								lNfe := .T.
								cStringCh += '<infNFe>'
								cStringCh += '<chave>' + (cAliasTagE)->DTC_NFEID + '</chave>'		//-- IdentIficador da NF-e
								cStringCh += '</infNFe>'

								If cVerAmb == '1.04' 
									cString := cStringCh
									cStringCh  := ''
                            EndIf                   								
								
								aCarga[1] += (cAliasTagE)->DTC_PESO
								aCarga[2] += (cAliasTagE)->DTC_PESOM3
								aCarga[3] += (cAliasTagE)->DTC_METRO3
								aCarga[4] += (cAliasTagE)->DTC_QTDVOL
							Else
								
								If Empty(cStringTmp)
									cStringTmp := cString 
									cString    := ''  
								Else
									cStringTmp += cString 
									cString    := ''   
								EndIf
								
                            cString += '<infNF>'
								cString += '<mod>01</mod>'
								cString += '<serie>' + NoAcentoCte( (cAliasTagE)->DTC_SERNFC ) + '</serie>'			//-- Serie da NF
								cString += '<nDoc>'  + NoAcentoCte( (cAliasTagE)->DTC_NUMNFC ) + '</nDoc>'				//-- Num. da NF
								cString += '<dEmi>'  + SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 1, 4) + "-" + SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 5, 2) + "-" + SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 7, 2) + '</dEmi>' //-- Data Emissao
								cString += '<vBC>'   + ConvType((cAliasTagE)->DTC_BASICM, 15, 2, "N") + '</vBC>'		//-- Base de C�lculo do ICMS
								cString += '<vICMS>' + ConvType((cAliasTagE)->DTC_VALICM, 15, 2, "N") + '</vICMS>'		//-- Valor total do ICMS
								cString += '<vBCST>' + ConvType((cAliasTagE)->DTC_BASESU, 15, 2, "N") + '</vBCST>'		//-- Base de c�lculo do ICMS ST
								cString += '<vST>'   + ConvType((cAliasTagE)->DTC_VALIST, 15, 2, "N") + '</vST>'		//-- Valor total do ICMS ST
								cString += '<vProd>' + ConvType((cAliasTagE)->DTC_VALOR,  15, 2, "N") + '</vProd>'		//-- Valor total do Produto
								cString += '<vNF>'   + ConvType((cAliasTagE)->DTC_VALOR,  15, 2, "N") + '</vNF>'		//-- Valor total da Nota Fiscal
								cString += '<nCFOP>' + ConvType((cAliasTagE)->DTC_CF, 4, "N") + '</nCFOP>'				//-- CFOP predominante
								//-- Preenche aCarga totalizando todos os produtos do Ct-e
								aCarga[1] += (cAliasTagE)->DTC_PESO
								aCarga[2] += (cAliasTagE)->DTC_PESOM3
								aCarga[3] += (cAliasTagE)->DTC_METRO3
								aCarga[4] += (cAliasTagE)->DTC_QTDVOL

								
								//������������������������������������������������������������������Ŀ
								//� TAG: locColeta - Local de Retirada                                �
								//��������������������������������������������������������������������
								If cVerAmb == '1.04'					
									If !AllTrim(cNumSol) == ''
						   				cAliasDT5:= GetNextAlias()
										cQuery := " SELECT A1_COD, A1_LOJA, A1_CGC, A1_PESSOA, "
							   			cQuery += "   DUE_CODCLI, DUE_LOJCLI, DUE_NREDUZ, DUE_END, DUE_BAIRRO, DUE_CODMUN,DUE_MUN, DUE_EST, "
							   			cQuery += "   DUL_CODRED, DUL_LOJRED, DUL_CODCLI, DUL_LOJCLI, DUL_END, DUL_BAIRRO, DUL_CODMUN, DUL_MUN, DUL_EST "
							   			cQuery += "	FROM " + RetSQLName("DT5") + " DT5 "
							   			cQuery += "  JOIN " + RetSQLName("DUE") + " DUE "
								 		cQuery += "   ON DUE_FILIAL = '" + xFilial('DUE') + "'" 
								    	cQuery += "    AND DUE_DDD   = DT5_DDD "
								   		cQuery += "    AND DUE_TEL   = DT5_TEL " 
								 		cQuery += "    AND DUE.D_E_L_E_T_ = ' ' "
								 		cQuery += "  JOIN " + RetSQLName("SA1") + " SA1 "
								 		cQuery += "    ON A1_COD = DUE_CODCLI "
								 		cQuery += "    AND  A1_LOJA = DUE_LOJCLI "
								 		cQuery += "    AND SA1.D_E_L_E_T_ = ' ' "
							     		cQuery += "  LEFT JOIN " + RetSqlName("DUL") + " DUL "
								 		cQuery += "   ON DUL_FILIAL = '" + xFilial('DUL') + "'"
										cQuery += "	   AND DUL_DDD    = DT5_DDD "
										cQuery += "	   AND DUL_TEL    = DT5_TEL "
										cQuery += "	   AND DUL_SEQEND = DT5_SEQEND "
										cQuery += "	   AND DUL.D_E_L_E_T_ = ' ' "
										cQuery += "  WHERE DT5_FILIAL	= '" + xFilial("DT5") + "' "
										cQuery += "    AND DT5_FILORI  = '" + cFilori + "' "
										cQuery += "    AND DT5_NUMSOL  = '" + cNumSol + "' "
										cQuery += "    AND DT5.D_E_L_E_T_ = ' ' "
										cQuery := ChangeQuery(cQuery)
										DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDT5,.T.,.T.)
								
										If !(cAliasDT5)->(Eof())
											If (!Empty(Alltrim((cAliasDT5)->DUE_CODCLI)) .And. (!Empty(AllTrim((cAliasDT5)->DUE_LOJCLI))))
												If ((cAliasDT6)->DT6_CLIREM == (cAliasDT5)->DUE_CODCLI .And. (cAliasDT6)->DT6_LOJREM == (cAliasDT5)->DUE_LOJCLI)
													If (Empty(Alltrim((cAliasDT5)->DUL_CODRED)) .And. Empty(Alltrim((cAliasDT5)->DUL_LOJRED)))
													    If !Empty((cAliasDT5)->(DUL_END))
															cString += '<locRet>'
															// Enderenco Solicitante DUL
															If aScan(aUF,{|x| x[1] == (cAliasDT5)->DUL_EST }) != 0   //Confere se Uf do End.Solicitante esta OK
																cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT5)->DUL_EST }), 2]
															Else
																cCodUFOri  := ''
															EndIf
															If (AllTrim((cAliasDT5)->A1_PESSOA) == "J")
																cString += '<CNPJ>' + NoPontos((cAliasDT5)->A1_CGC) + '</CNPJ>'
															Else
																cString += '<CPF>' + AllTrim((cAliasDT5)->A1_CGC) + '</CPF>'
															EndIf
															cString += '<xNome>'+ NoAcentoCte( (cAliasDT5)->(DUE_NREDUZ) ) +'</xNome>'
															cString += '<xLgr>'+ NoAcentoCte( (cAliasDT5)->(DUL_END) ) +'</xLgr>'
															cString += '<nro>'  + Iif(FisGetEnd((cAliasDT5)->DUL_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasDT5)->DUL_END)[2])),"S/N") + '</nro>'								
															cString += '<xBairro>'+ NoAcentoCte( (cAliasDT5)->(DUL_BAIRRO) ) +'</xBairro>'
															cString += '<cMun>'+ NoAcentoCte( AllTrim(cCodUFOri) + AllTrim((cAliasDT5)->(DUL_CODMUN)) ) +'</cMun>'
															cString += '<xMun>'+ NoAcentoCte( (cAliasDT5)->(DUL_MUN) ) +'</xMun>' 
															cString += '<UF>'+ NoAcentoCte( (cAliasDT5)->(DUL_EST) ) +'</UF>'
															cString += '</locRet>'
														EndIf	
													Else
														//Faz um select na SA1 para pegar o Redespachante / Origem da Coleta	   
											   			cAliasCol:= GetNextAlias()									                  
														cQuery := " SELECT DUL_CODRED, DUL_LOJRED, "
														cQuery += "	A1_COD, A1_LOJA, A1_CGC, A1_PESSOA,A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST," 
														cQuery += "   A1_COD_MUN, A1_INSCR, A1_PAIS, A1_DDD, A1_TEL, A1_CEP  "
														cQuery += "  FROM " + RetSqlName("DUL") + " DUL, " 
														cQuery += RetSqlName("SA1") + " SA1 "
														cQuery += "  WHERE SA1.A1_FILIAL = '" + xFilial('SA1') + "'"
														cQuery += "	 AND DUL.DUL_FILIAL = '" + xFilial('DUL') + "'"
														cQuery += "	 AND A1_COD = '" + (cAliasDT5)->DUL_CODRED + "'"
														cQuery += "     AND A1_LOJA = '" + (cAliasDT5)->DUL_LOJRED + "'"
														cQuery += "     AND SA1.D_E_L_E_T_ = ' ' "
														cQuery += "     AND DUL.D_E_L_E_T_ = ' ' "
														cQuery := ChangeQuery(cQuery)
														DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasCol,.T.,.T.)
														If !(cAliasCol)->(Eof())
															cStringExp := ""
															cStringExp += '<exped>'
															// Enderenco Solicitante DUL
															If aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }) != 0   //Confere se Uf do End.Solicitante esta OK
																cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }), 2]
															Else
																cCodUFOri  := ''
															EndIf
															If (AllTrim((cAliasCol)->(A1_PESSOA)) == "J")
																cStringExp += '<CNPJ>' + NoPontos((cAliasCol)->A1_CGC) + '</CNPJ>'
															Else
																cStringExp += '<CPF>' + AllTrim((cAliasCol)->A1_CGC) + '</CPF>'
															EndIf
															
															If 'ISENT' $ Upper(AllTrim((cAliasCol)->A1_INSCR))
																cStringExp += '<IE>ISENTO</IE>'
															Else
																cStringExp += '<IE>' + NoPontos((cAliasCol)->A1_INSCR) + '</IE>'
															EndIf
							
															If cAmbiente == '2'  //--Homologacao / Nota T�cnica 2012/005 
																cStringExp += '<xNome>' + (SubStr('CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
															Else
																cStringExp += '<xNome>' + NoAcentoCte(SubStr((cAliasCol)->A1_NOME,1,60)) + '</xNome>'
															EndIf
															
															If !Empty((cAliasCol)->A1_TEL)
																cStringExp += '<fone>' + cValtoChar(NoPontos((cAliasCol)->A1_DDD)) +;
																cValtoChar(NoPontos((cAliasCol)->A1_TEL)) + '</fone>'
															EndIf
															
															cStringExp += '<enderExped>'
															cStringExp += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasCol)->A1_END)[1]) + '</xLgr>'
															cStringExp += '<nro>' + Iif(FisGetEnd((cAliasCol)->A1_END)[2] <> 0, AllTrim(cValtoChar( FisGetEnd((cAliasCol)->A1_END)[2])),"S/N") + '</nro>'
															If !Empty(NoAcentoCte(FisGetEnd((cAliasCol)->A1_END)[4]))
																cStringExp += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasCol)->A1_END)[4]) + '</xCpl>'
															EndIf
															If Empty(AllTrim((cAliasCol)->A1_BAIRRO))
																cStringExp += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
															Else
																cStringExp += '<xBairro>' + NoAcentoCte( (cAliasCol)->A1_BAIRRO ) + '</xBairro>'
															EndIf
															cStringExp += '<cMun>' + NoAcentoCte( AllTrim(cCodUFOri) + AllTrim((cAliasCol)->A1_COD_MUN) ) + '</cMun>'
															cStringExp += '<xMun>' + NoAcentoCte( (cAliasCol)->A1_MUN ) + '</xMun>'
															cStringExp += '<CEP>'  + NoAcentoCte( (cAliasCol)->A1_CEP ) + '</CEP>'
															cStringExp += '<UF>'   + NoAcentoCte( (cAliasCol)->A1_EST ) + '</UF>'
															If !Empty(AllTrim((cAliasCol)->A1_PAIS))
																cStringExp += '<cPais>'+ NoAcentoCte( (cAliasCol)->A1_PAIS ) + '</cPais>'
																cStringExp += '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+(cAliasCol)->A1_PAIS,"YA_DESCR") ) + '</xPais>'
															EndIf
															cStringExp += '</enderExped>'
															cStringExp += '</exped>'
															
															(cAliasCol)->(DbCloseArea())
														EndIF
													EndIf
												Else
													//Faz um Select no SA1 para codigo do remetente diferente do solicitante
										   			cAliasCol:= GetNextAlias()								                  
													cQuery := " SELECT DUE_CODCLI, DUE_LOJCLI, "
													cQuery += "	A1_COD, A1_LOJA, A1_CGC, A1_PESSOA,A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_COD_MUN "
													cQuery += "  FROM " + RetSqlName("DUE") + " DUE, "
													cQuery += RetSqlName("SA1") + " SA1 "
													cQuery += "  WHERE SA1.A1_FILIAL = '" + xFilial('SA1') + "'"
													cQuery += "	 AND DUE.DUE_FILIAL = '" + xFilial('DUE') + "'"
													cQuery += "	 AND A1_COD = '" + (cAliasDT5)->DUE_CODCLI + "'"
													cQuery += "     AND A1_LOJA = '" + (cAliasDT5)->DUE_LOJCLI + "'"
													cQuery += "     AND SA1.D_E_L_E_T_ = ' '
													cQuery += "     AND DUE.D_E_L_E_T_ = ' '
													cQuery := ChangeQuery(cQuery)
													DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasCol,.T.,.T.)
													If !(cAliasCol)->(Eof())
														cString += '<locRet>'
														// Enderenco Solicitante DUL
														If aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }) != 0   //Confere se Uf do End.Solicitante esta OK
															cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }), 2]
														Else
															cCodUFOri  := ''
														EndIf
														If (AllTrim((cAliasCol)->(A1_PESSOA)) == "J")
															cString += '<CNPJ>' + NoPontos((cAliasCol)->A1_CGC) + '</CNPJ>'
														Else
															cString += '<CPF>' + AllTrim((cAliasCol)->A1_CGC) + '</CPF>'
														EndIf
														cString += '<xNome>'+ NoAcentoCte((cAliasCol)->(A1_NOME) ) +'</xNome>'
														cString += '<xLgr>'+ NoAcentoCte( (cAliasCol)->(A1_END) ) +'</xLgr>'
														cString += '<nro>'  + Iif(FisGetEnd((cAliasCol)->A1_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasCol)->A1_END)[2])),"S/N") + '</nro>'								
														cString += '<xBairro>'+ NoAcentoCte( (cAliasCol)->(A1_BAIRRO) ) +'</xBairro>'
														cString += '<cMun>'+ NoAcentoCte( AllTrim(cCodUFOri) + AllTrim((cAliasCol)->(A1_COD_MUN)) ) +'</cMun>'
														cString += '<xMun>'+ NoAcentoCte( (cAliasCol)->(A1_MUN) ) +'</xMun>' 
														cString += '<UF>'+ NoAcentoCte( (cAliasCol)->(A1_EST) ) +'</UF>'
														cString += '</locRet>'
														(cAliasCol)->(DbCloseArea())
													EndIF
												EndIf
											EndIf
										EndIf
										(cAliasDT5)->(DbCloseArea())			
									EndIf 
								EndIf	
					
			
								cString += '</infNF>'    
								If cVerAmb == '2.00'
								    cString20	+= cString  
								    cString 	:= ''
								Endif
							EndIf  
							(cAliasTagE)->(dbSkip())
						EndDo						
					EndIf
						(cAliasTagE)->(DbCloseArea())
					cString += '</rem>'
					cStringTmp += cString
					aAdd(aXMLCTe,AllTrim(cStringTmp))
					cStringTmp  := ""
					cString	  := ""	
					
					If !Empty(cStringExp)
						aAdd(aXMLCTe,AllTrim(cStringExp))
					EndIf
					cStringExp	:= ""				
					
					//�����������������������������������������������������������������Ŀ
					//� TAG: Dados do Recebedor                               �
					//�������������������������������������������������������������������
					DUL->(DbSetOrder(2))
					If DUL->(MsSeek(xFilial('DUL')+(cAliasDT6)->DT6_CLIDES + (cAliasDT6)->DT6_LOJDES + cSeqEntr))
						If !Empty(DUL->DUL_CODRED+DUL->DUL_LOJRED)
							lRedesp := .T.
							cString := '<receb>'
							SA1->(DbSetOrder(1))
							If SA1->(dbSeek(xFilial('SA1') + DUL->DUL_CODRED + DUL->DUL_LOJRED))
								If (AllTrim(SA1->A1_PESSOA) == "J")
									cString += '<CNPJ>' + NoPontos(SA1->A1_CGC) + '</CNPJ>'
								Else
									cString += '<CPF>' + AllTrim(SA1->A1_CGC) + '</CPF>'
								EndIf
							If Empty(DUL->DUL_INSCR) .Or. 'ISENT' $ Upper(AllTrim(DUL->DUL_INSCR))
								cString += '<IE>ISENTO</IE>'
							Else
								cString += '<IE>' + NoPontos(DUL->DUL_INSCR) + '</IE>'
							EndIf	
							If cAmbiente == '2'  //--Homologacao / Nota T�cnica 2012/005 
								cString += '<xNome>' + (SubStr('CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
							Else
								cString += '<xNome>'+ NoAcentoCte(SubStr(DUL->DUL_NOMRED,1,40)) + '</xNome>'
							EndIf
								
							cString += '<fone>'+ NoAcentoCte(SubStr(SA1->A1_TEL,1,15)) + '</fone>'
								
							EndIf
							cString += '<enderReceb>'
							cString += '<xLgr>' + NoAcentoCte(FisGetEnd(DUL->DUL_END)[1]) + '</xLgr>'
							cString += '<nro>'  + Iif(FisGetEnd(DUL->DUL_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd(DUL->DUL_END)[2])),"S/N") + '</nro>'
							If !Empty(NoAcentoCte(FisGetEnd(DUL->DUL_END)[4]))
								cString += '<xCpl>' + NoAcentoCte(FisGetEnd(DUL->DUL_END)[4]) + '</xCpl>'
							EndIf
							cString += '<xBairro>'	+ NoAcentoCte( DUL->DUL_BAIRRO )+ '</xBairro>'
							If aScan(aUF,{|x| x[1] == DUL->DUL_EST }) != 0
								cUfEnt := aUF[ aScan(aUF,{|x| x[1] == DUL->DUL_EST }), 2]
							Else
								cUfEnt := ''
							EndIf
							cString += '<cMun>'		+ NoAcentoCte( AllTrim(cUfEnt) + AllTrim(DUL->DUL_CODMUN) )	+ '</cMun>'
							cString += '<xMun>'		+ NoAcentoCte( DUL->DUL_MUN )		+ '</xMun>'
							cString += '<CEP>'		+ NoAcentoCte( DUL->DUL_CEP )		+ '</CEP>'
							cString += '<UF>'		+ NoAcentoCte( DUL->DUL_EST )		+ '</UF>'
							
							If !Empty(AllTrim(SA1->A1_PAIS))
								cString += '<cPais>'+ NoAcentoCte( SA1->A1_PAIS ) + '</cPais>'
								cString += '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR") ) + '</xPais>'
							EndIf
							cString += '</enderReceb>'
							If !Empty(SA1->A1_EMAIL)
								cString += '<email>' + AllTrim(SA1->A1_EMAIL) + '</email>'
							EndIf
							cString += '</receb>'
						
						aAdd(aXMLCTe,AllTrim(cString))
						
						EndIf
					EndIf	
																			
					//�����������������������������������������������������������������Ŀ
					//� TAG: H - Dados do Destinatario                                  �
					//�������������������������������������������������������������������
					cString := '<dest>'
					If (AllTrim((cAliasDT6)->DES_TPPESSOA) == "J")
						cString += '<CNPJ>' + Iif((cAliasDT6)->DES_UF <> 'EX', NoPontos((cAliasDT6)->DES_CNPJ), '00000000000000') + '</CNPJ>'
						If Empty((cAliasDT6)->DES_INSC) .Or. 'ISENT' $ Upper(NoAcentoCte( (cAliasDT6)->DES_INSC ))
							cString += '<IE>ISENTO</IE>'
						Else
							cString += '<IE>' + NoPontos((cAliasDT6)->DES_INSC) + '</IE>'
						EndIf
					Else
						cString += '<CPF>' + Iif((cAliasDT6)->DES_UF <> 'EX', NoAcentoCte( (cAliasDT6)->DES_CNPJ ), '00000000000') + '</CPF>'
						If Empty((cAliasDT6)->DES_INSC) .Or. 'ISENT' $ Upper(AllTrim((cAliasDT6)->DES_INSC))
							cString += '<IE>ISENTO</IE>'
						Else
							cString += '<IE>' + NoPontos((cAliasDT6)->DES_INSC) + '</IE>'
						EndIf
					EndIf

					If cAmbiente == '2'  //--Homologacao / Nota T�cnica 2012/005 
						cString += '<xNome>' + (SubStr('CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
					Else
						cString += '<xNome>' + NoAcentoCte(SubStr((cAliasDT6)->DES_NOME,1,60)) + '</xNome>'
					EndIf
					If !Empty((cAliasDT6)->DES_TEL)
						cString += '<fone>' + cValtoChar(NoPontos((cAliasDT6)->DES_DDDTEL)) + ;
						cValtoChar(NoPontos((cAliasDT6)->DES_TEL)) + '</fone>'
					EndIf
					cString += '<enderDest>'
					cString += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasDT6)->DES_END)[1]) + '</xLgr>'
					cString += '<nro>' + Iif(FisGetEnd((cAliasDT6)->DES_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasDT6)->DES_END)[2])),"S/N") + '</nro>'
					If !Empty(NoAcentoCte(FisGetEnd((cAliasDT6)->DES_END)[4]))
						cString += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasDT6)->DES_END)[4]) + '</xCpl>'
					EndIf
					If Empty(AllTrim((cAliasDT6)->DES_BAIRRO))
						cString += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
					Else
						cString += '<xBairro>' + NoAcentoCte( (cAliasDT6)->DES_BAIRRO ) + '</xBairro>'
					EndIf
					cString += '<cMun>'+ NoAcentoCte( AllTrim(cCodUFDes) + AllTrim((cAliasDT6)->DES_COD_MUN) ) + '</cMun>'
					cString += '<xMun>'+ NoAcentoCte( (cAliasDT6)->DES_MUNICI ) + '</xMun>'
					cString += '<CEP>' + NoAcentoCte( (cAliasDT6)->DES_CEP    ) + '</CEP>'
					cString += '<UF>'  + NoAcentoCte( (cAliasDT6)->DES_UF     ) + '</UF>'
					If !Empty(AllTrim((cAliasDT6)->DES_PAIS))
						cString += '<cPais>'+ NoAcentoCte( (cAliasDT6)->DES_PAIS ) + '</cPais>'
						cString += '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+(cAliasDT6)->DES_PAIS,"YA_DESCR") ) + '</xPais>'
					EndIf
					cString += '</enderDest>'
					If !Empty((cAliasDT6)->DES_EMAIL)
						cString += '<email>' + AllTrim((cAliasDT6)->DES_EMAIL) + '</email>'
					EndIf
					
					If !Empty(cSeqEntr) .And. (cAliasDT6)->DT6_DOCTMS <> StrZero(6,Len(DT6->DT6_DOCTMS)) .And. !lRedesp //Devolucao
						
						DUL->(DbSetOrder(2))
						If DUL->(MsSeek(xFilial('DUL')+(cAliasDT6)->DT6_CLIDES + (cAliasDT6)->DT6_LOJDES + cSeqEntr))
							
							cString += '<locEnt>'
							If (AllTrim((cAliasDT6)->DES_TPPESSOA) == "J")
								cString += '<CNPJ>' + NoPontos((cAliasDT6)->DES_CNPJ) + '</CNPJ>'
							Else
								cString += '<CPF>' + AllTrim((cAliasDT6)->DES_CNPJ) + '</CPF>'
							EndIf
							cString += '<xNome>'+ NoAcentoCte(SubStr((cAliasDT6)->DES_NOME,1,60)) + '</xNome>'

							cString += '<xLgr>' + NoAcentoCte(FisGetEnd(DUL->DUL_END)[1]) + '</xLgr>'
							cString += '<nro>'  + Iif(FisGetEnd(DUL->DUL_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd(DUL->DUL_END)[2])),"S/N") + '</nro>'
							If !Empty(NoAcentoCte(FisGetEnd(DUL->DUL_END)[4]))
								cString += '<xCpl>' + NoAcentoCte(FisGetEnd(DUL->DUL_END)[4]) + '</xCpl>'
							EndIf
							cString += '<xBairro>'	+ NoAcentoCte( DUL->DUL_BAIRRO )+ '</xBairro>'
							If aScan(aUF,{|x| x[1] == DUL->DUL_EST }) != 0
								cUfEnt := aUF[ aScan(aUF,{|x| x[1] == DUL->DUL_EST }), 2]
							Else
								cUfEnt := ''
							EndIf
							cString += '<cMun>'		+ NoAcentoCte( AllTrim(cUfEnt) + AllTrim(DUL->DUL_CODMUN) )	+ '</cMun>'
							cString += '<xMun>'		+ NoAcentoCte( DUL->DUL_MUN )		+ '</xMun>'
							cString += '<UF>'		+ NoAcentoCte( DUL->DUL_EST )		+ '</UF>'
							cString += '</locEnt>'
						EndIf
						
					EndIf
					
					//-- Strings incluidas para envio de email para tomador.
					//-- Necessario incluir SPED_DELMAIL=1 no SERVER.INI do TSS/SPED
					//-- para excluir este conteudo do arquivo XML final.
					If !Empty(cMail)
						cString += '[EMAIL=' + cMail + ']'
					EndIf
					
					cString += '</dest>'
					aAdd(aXMLCTe,AllTrim(cString))

					If	AllTrim((cAliasDT6)->DT6_DOCTMS) == StrZero( 8, Len(DT6->DT6_DOCTMS))
						//-- Para TES configurada gerar duplicata = N somente para CTE complemento ICMS / destaque de ICMS.
						cGerDup := "S"
						cAliasTES := GetNextAlias()
						cQuery := " SELECT F4_DUPLIC " + CRLF
						cQuery += "   FROM " + RetSqlName("SD2") + " D2," + RetSqlName("SF4") + " F4 "  + CRLF
						cQuery += "  WHERE D2.D2_FILIAL  = '" + xFilial('SD2') + "'" + CRLF
						cQuery += "    AND D2.D2_DOC     = '" + cNota    + "'" + CRLF
						cQuery += "    AND D2.D2_SERIE   = '" + cSerie   + "'" + CRLF
						cQuery += "    AND D2.D2_CLIENTE = '" + cClieFor + "'" + CRLF
						cQuery += "    AND D2.D2_LOJA    = '" + cLoja    + "'" + CRLF
						cQuery += "    AND D2.D_E_L_E_T_ = ''" + CRLF
						//-- Cadastro de TES
						cQuery += "    AND F4.F4_FILIAL	 = '"  + xFilial('SF4') + "'" + CRLF
						cQuery += "    AND F4.F4_CODIGO	 = D2.D2_TES" + CRLF
						cQuery += "    AND F4.D_E_L_E_T_ =''"
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTES, .F., .T.)
						If !(cAliasTES)->(Eof())
							cGerDup := (cAliasTES)->F4_DUPLIC
						EndIf
						(cAliasTES)->(DbCloseArea())
					EndIf

					//�����������������������������������������������������������������Ŀ
					//� TAG: I - Valores da prestacao de servico                        �
					//�������������������������������������������������������������������
					If cGerDup == "S"
						cAliasTagI := GetNextAlias()
						cQuery := " SELECT DOCCOMP.DT8_VALPAS, " +CRLF
						cQuery += " 		 DOCCOMP.DT8_VALTOT, " +CRLF
						cQuery += " 		 COMP.DT3_DESCRI " +CRLF
						cQuery += "   FROM " + RetSqlName('DT8') + " DOCCOMP " +CRLF
						cQuery += " 		 INNER JOIN  " + RetSqlName('DT3') + " COMP " +CRLF
						cQuery += " 				   ON ( COMP.DT3_FILIAL='" + xFilial("DT3") + "'" +CRLF
						cQuery += "						AND COMP.DT3_CODPAS = DOCCOMP.DT8_CODPAS " +CRLF
						cQuery += "						AND COMP.D_E_L_E_T_=' ')" +CRLF
						cQuery += "  WHERE DOCCOMP.DT8_FILIAL  = '" + xFilial("DT8") + "'" +CRLF

						//�����������������������������������������������������������������Ŀ
						//� Se o tipo de Conhecimento for de Complemento, seleciona as      �
						//�informacoes do CTR principal, pois o complemento nao tem DTC     �
						//�������������������������������������������������������������������
						If !Empty((cAliasDT6)->DT6_DOCDCO) .And. !((cAliasDT6)->DT6_DOCTMS $ "7/6") 
							cQuery += "    AND DOCCOMP.DT8_FILDOC  = '" + (cAliasDT6)->DT6_FILDCO + "'" +CRLF
							cQuery += "    AND DOCCOMP.DT8_DOC     = '" + (cAliasDT6)->DT6_DOCDCO + "'" +CRLF
							cQuery += "    AND DOCCOMP.DT8_SERIE   = '" + (cAliasDT6)->DT6_SERDCO + "'" +CRLF
						Else
							cQuery += "    AND DOCCOMP.DT8_FILDOC  = '" + AllTrim((cAliasDT6)->DT6_FILDOC)	+ "'" +CRLF
							cQuery += "    AND DOCCOMP.DT8_DOC     = '" + AllTrim((cAliasDT6)->DT6_DOC)	+ "'" +CRLF
							cQuery += "    AND DOCCOMP.DT8_SERIE   = '" + AllTrim((cAliasDT6)->DT6_SERIE)	+ "'" +CRLF
						EndIf

						cQuery += "    AND DOCCOMP.D_E_L_E_T_  = ' '"
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTagI, .F., .T.)

						cString := '<vPrest>'

						cAliasVPrest := GetNextAlias()
					
						cQuery := " SELECT DT6.DT6_VALTOT, " + CRLF
						cQuery += "        DT6.DT6_VALFAT  " + CRLF
						cQuery += "  FROM " + RetSqlName('DT6') + " DT6 " + CRLF
						cQuery += "  WHERE DT6.DT6_FILIAL  = '" + xFilial("DT6") + "'" + CRLF
						If AllTrim((cAliasDT6)->DT6_DOCTMS) == "M"
							cQuery += "    AND DT6.DT6_FILDOC  = '" + (cAliasDT6)->DT6_FILDCO + "'" + CRLF
							cQuery += "    AND DT6.DT6_DOC     = '" + (cAliasDT6)->DT6_DOCDCO    + "'" + CRLF
							cQuery += "    AND DT6.DT6_SERIE   = '" + (cAliasDT6)->DT6_SERDCO	  + "'" + CRLF
						Else
							cQuery += "    AND DT6.DT6_FILDOC  = '" + (cAliasDT6)->DT6_FILDOC + "'" + CRLF
							cQuery += "    AND DT6.DT6_DOC     = '" + (cAliasDT6)->DT6_DOC    + "'" + CRLF
							cQuery += "    AND DT6.DT6_SERIE   = '" + (cAliasDT6)->DT6_SERIE  + "'" + CRLF
						EndIf
						cQuery += "    AND DT6.D_E_L_E_T_  = ' '"
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasVPrest, .F., .T.)
						If !Empty((cAliasDT6)->DT6_DOCTMS)
							cString += '<vTPrest>' + ConvType((cAliasVPrest)->DT6_VALTOT, 15, 2, "N") + '</vTPrest>'
							cString += '<vRec>'    + ConvType((cAliasVPrest)->DT6_VALFAT, 15, 2, "N") + '</vRec>'
						Else
							cString += '<vTPrest>' + ConvType((cAliasDT6)->DT6_VALTOT, 15, 2, "N") + '</vTPrest>'
							cString += '<vRec>'    + ConvType((cAliasDT6)->DT6_VALFAT, 15, 2, "N") + '</vRec>'
						EndIf

						If	!AllTrim((cAliasDT6)->DT6_DOCTMS) == StrZero( 8, Len(DT6->DT6_DOCTMS))
						
							While !(cAliasTagI)->(Eof())
								cString +='<Comp>'
								cString += '<xNome>' + AllTrim(NoAcentoCte(SubStr((cAliasTagI)->DT3_DESCRI,1,15))) + '</xNome>'
								If lCTEVFRE
									cString += '<vComp>' + ConvType((cAliasTagI)->DT8_VALPAS, 15, 2, "N") + '</vComp>'
								Else
									cString += '<vComp>' + ConvType((cAliasTagI)->DT8_VALTOT, 15, 2, "N") + '</vComp>'
								EndIf
								cString +='</Comp>'
								(cAliasTagI)->(dbSkip())
							EndDo
						
						EndIf
						(cAliasVPrest)->(DbCloseArea())

						cString += '</vPrest>'
						aAdd(aXMLCTe,AllTrim(cString))
					
						(cAliasTagI)->(DbCloseArea())
					Else
						//-- Para TES configurada gerar duplicata = N somente para CTE complemento ICMS / destaque de ICMS -> sem valor prestado.
						cString := '<vPrest>'
						cString += '<vTPrest>' + ConvType(0, 15, 2, "N") + '</vTPrest>'
						cString += '<vRec>'    + ConvType(0, 15, 2, "N") + '</vRec>'
						cString += '</vPrest>'
						aAdd(aXMLCTe,AllTrim(cString))
					EndIf

					//�����������������������������������������������������������������Ŀ
					//� Valores referente a base icms e valor do credito presumido      �
					//�������������������������������������������������������������������
					cAliasRBC := GetNextAlias()
					cQuery := " SELECT F4_BASEICM, F4_CRDPRES, D2_VALICM " + CRLF
					cQuery += "   FROM " + RetSqlName("SD2") + " D2," + RetSqlName("SF4") + " F4 "  + CRLF
					cQuery += "  WHERE D2.D2_FILIAL  = '" + xFilial('SD2') + "'" + CRLF
					If AllTrim((cAliasDT6)->DT6_DOCTMS) == "M"
						cQuery += "    AND D2.D2_DOC   = '" + (cAliasDT6)->DT6_DOCDCO + "'" + CRLF
						cQuery += "    AND D2.D2_SERIE = '" + (cAliasDT6)->DT6_SERDCO + "'" + CRLF
					Else
						cQuery += "    AND D2.D2_DOC   = '" + cNota   + "'" + CRLF
						cQuery += "    AND D2.D2_SERIE = '" + cSerie  + "'" + CRLF
					EndIf	
					cQuery += "    AND D2.D2_CLIENTE   = '" + cClieFor + "'" + CRLF
					cQuery += "    AND D2.D2_LOJA      = '" + cLoja    + "'" + CRLF
					cQuery += "    AND D2.D_E_L_E_T_<>'*'" + CRLF
					//-- Cadastro de TES
					cQuery += "    AND F4.F4_FILIAL	= '"  + xFilial('SF4') + "'" + CRLF
					cQuery += "    AND F4.F4_CODIGO	= D2.D2_TES" + CRLF
					cQuery += "    AND F4.D_E_L_E_T_<>'*'"
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasRBC, .F., .T.)
					If !(cAliasRBC)->(Eof())
						If (cAliasRBC)->F4_BASEICM > 0
							cpRedBC := AllTrim(Str(100-(cAliasRBC)->F4_BASEICM))
						EndIf
						nVcred  := ((cAliasRBC)->F4_CRDPRES*(cAliasRBC)->D2_VALICM)
					EndIf
					(cAliasRBC)->(DbCloseArea())

					//�����������������������������������������������������������������Ŀ
					//� TAG: J- Informacoes relativas aos Impostos                      �
					//�������������������������������������������������������������������
					
					//�����������������������������������������������������������������Ŀ
					//� Incluso as TAGS referentes as modalidades de tributacao do ICMS �
					//�������������������������������������������������������������������
					cAliasTagJ := GetNextAlias()
					cQuery := "SELECT SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS, " + CRLF
					cQuery += "  MAX(SFT.FT_ALIQICM) FT_ALIQICM, " + CRLF
					cQuery += "	 MAX(SFT.FT_ALIQSOL) FT_ALIQSOL, " + CRLF
					cQuery += "  SUM(SFT.FT_BASEICM) FT_BASEICM, " + CRLF
					cQuery += "  SUM(SFT.FT_BASERET) FT_BASERET, " + CRLF
					cQuery += "  SUM(SFT.FT_VALICM)  FT_VALICM,  " + CRLF
					cQuery += "  SUM(SFT.FT_CRPRST)  FT_CRPRST,  " + CRLF
					cQuery += "  SUM(SFT.FT_ICMSRET) FT_ICMSRET, " + CRLF
					cQuery += "  MAX(SD2.D2_ALIQSOL) D2_ALIQSOL, " + CRLF
					cQuery += "  SUM(SD2.D2_BASEICM) D2_BASEICM, " + CRLF 
					cQuery += "  SUM(SD2.D2_VALICM)  D2_VALICM,  " + CRLF
					cQuery += "  SUM(SD2.D2_ICMSRET) D2_ICMSRET  " + CRLF
					cQuery += "  FROM " + RetSqlName('SFT') + " SFT, "+ RetSqlName('SD2') +" SD2   " + CRLF
					cQuery += "  WHERE SFT.FT_FILIAL  = '" + xFilial('SFT') + "'" + CRLF
					If AllTrim((cAliasDT6)->DT6_DOCTMS) == "M"
						cQuery += " AND SFT.FT_NFISCAL = '" + (cAliasDT6)->DT6_DOCDCO + "'" + CRLF
						cQuery += " AND SFT.FT_SERIE   = '" + (cAliasDT6)->DT6_SERDCO + "'" + CRLF
					Else
						cQuery += " AND SFT.FT_NFISCAL = '" + (cAliasDT6)->DT6_DOC   + "'" + CRLF
						cQuery += " AND SFT.FT_SERIE   = '" + (cAliasDT6)->DT6_SERIE + "'" + CRLF
					EndIf
					cQuery += " AND SFT.FT_CLIEFOR = '" + (cAliasDT6)->DT6_CLIDEV + "'" + CRLF
					cQuery += " AND SFT.FT_LOJA    = '" + (cAliasDT6)->DT6_LOJDEV + "'" + CRLF
					cQuery += " AND SFT.D_E_L_E_T_ = ' '" + CRLF
					cQuery += " AND SD2.D2_FILIAL  = '" + xFilial('SD2') + "'" + CRLF
					If AllTrim((cAliasDT6)->DT6_DOCTMS) == "M"
						cQuery += " AND SD2.D2_DOC   = SFT.FT_NFISCAL " + CRLF
						cQuery += " AND SD2.D2_SERIE = SFT.FT_SERIE   " + CRLF
					Else
						cQuery += " AND SD2.D2_DOC   = SFT.FT_NFISCAL " + CRLF
						cQuery += " AND SD2.D2_SERIE = SFT.FT_SERIE   " + CRLF
					EndIf
					cQuery += " AND SD2.D2_CLIENTE = SFT.FT_CLIEFOR " + CRLF
					cQuery += " AND SD2.D2_LOJA    = SFT.FT_LOJA    " + CRLF
					cQuery += " AND SD2.D2_ITEM    = SFT.FT_ITEM    " + CRLF
					cQuery += " AND SD2.D_E_L_E_T_ = ' '" + CRLF
					cQuery += " GROUP BY SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS "
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTagJ, .F., .T.)
					While !(cAliasTagJ)->(Eof())
						If (cAliasTagJ)->FT_VALICM > 0
							nBASEICM := (cAliasTagJ)->FT_BASEICM
							nALIQICM := (cAliasTagJ)->FT_ALIQICM
							nVALICM  := (cAliasTagJ)->FT_VALICM
							nALIQSOL := (cAliasTagJ)->FT_ALIQSOL
							nICMSRET := (cAliasTagJ)->FT_ICMSRET
                      	Else
							nBASEICM := (cAliasTagJ)->D2_BASEICM
							nALIQICM := (cAliasTagJ)->D2_ALIQSOL
							nVALICM  := (cAliasTagJ)->D2_VALICM
							nALIQSOL := (cAliasTagJ)->D2_ALIQSOL
							nICMSRET := (cAliasTagJ)->D2_ICMSRET
						EndIf 
						
						If (cAliasTagJ)->FT_BASERET > 0
							nBASICMRET 	:= (cAliasTagJ)->FT_BASERET
							nALIQSOL 	:= (cAliasTagJ)->FT_ALIQSOL
							nICMSRET	:= (cAliasTagJ)->FT_ICMSRET  
							nCREDPRES	:= (cAliasTagJ)->FT_CRPRST  
						EndIf             
						
						//-- CT-e complemento ICMS campos preenchidos somente para permitir a validacao do CT-e
						If (cAliasDT6)->DT6_DOCTMS == "8" .And. nBASEICM == 0 .And. nALIQICM == 0 .And. nVALICM > 0
							nBASEICM := nVALICM
							nALIQICM := 100
						EndIf
						cString := '<imp>'
						//���������������������������������Ŀ
						//� Informacoes relativas ao ICMS   �
						//�����������������������������������
						cString += '<ICMS>'
						If SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '00'
							cString += '<ICMS00>'
							cString += '<CST>00</CST>'
							cString += '<vBC>'  + ConvType(nBASEICM, 15, 2, "N") + '</vBC>'
							cString += '<pICMS>'+ ConvType(nALIQICM,  6, 2, "N") + '</pICMS>'
							cString += '<vICMS>'+ ConvType(nVALICM , 15, 2, "N") + '</vICMS>'
							cString += '</ICMS00>'						
						ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) $ "40,41,51"
							//�����������������������������������������Ŀ
							//� ICMS Isento, nao Tributado ou dIferido  �
							//� - 40: ICMS Isencao                      �
							//� - 41: ICMS Nao Tributada                �
							//� - 51: ICMS DIferido                     �
							//�������������������������������������������
							cString += '<ICMS45>'
							If SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2)  == '40'
								cString += '<CST>40</CST>'
							ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '41'
								cString += '<CST>41</CST>'
							ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '51'
								cString += '<CST>51</CST>'
							EndIf
							cString += '</ICMS45>'
						ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == "60"
							//�����������������������������������������������������������������Ŀ
							//� - 60: ICMS cobrado por substitui��o tribut�ria.                 �
							//� Responsabilidade do recolhimento do ICMS atribu�do              �
							//� ao tomadorou 3o por ST.                                         �
							//� CST60 - ICMS cobrado anteriormente por substituicao tributaria  �
							//�������������������������������������������������������������������
							cString += '<ICMS60>'
							//-- ICMS cobrado anteriormente por substituicao tributaria
							cString += '<CST>60</CST>'
							cString += '<vBCSTRet>'  + ConvType(nBASICMRET	, 15, 2, "N") + '</vBCSTRet>'
							cString += '<vICMSSTRet>'+ ConvType(nICMSRET + nCREDPRES	, 15, 2, "N") + '</vICMSSTRet>'
							cString += '<pICMSSTRet>'+ ConvType(nALIQSOL	,  6, 2, "N") + '</pICMSSTRet>'
							cString += '<vCred>'     + ConvType(nCREDPRES	, 15, 2, "N") + '</vCred>'
							cString += '</ICMS60>'
						ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) $ "10,30,70"
							//�����������������������������������������������������������������Ŀ
							//� - 80: ICMS pagto atribuido ao tomador ou ao 3o previsto para    �
							//� substituicao tributaria                                         �
							//�������������������������������������������������������������������
							cString += '<ICMS90>'
							cString += '<CST>90</CST>'
							If !Empty(cpRedBC)
								cString += '<pRedBC>' + ConvType(cpRedBC, 5, 2, "N") + '</pRedBC>'
							EndIf
							cString += '<vBC>'    + ConvType(nBASEICM, 15, 2, "N") + '</vBC>'
							cString += '<pICMS>'  + ConvType(nALIQICM,  6, 2, "N") + '</pICMS>'
							cString += '<vICMS>'  + ConvType(nVALICM , 15, 2, "N") + '</vICMS>'
							cString += '<vCred>'  + ConvType(nVcred  , 15, 2, "N") + '</vCred>'
							cString += '</ICMS90>'
						ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) $ '20,90' .And. !(AllTrim(cCFOP) $ "5932,6932")
							//�����������������������������������������������������������������Ŀ
							//� - 81: ICMS DEVIDOS A OUTRAS UF'S                                �
							//� - 90: ICMS Outros                                               �
							//�������������������������������������������������������������������
							If SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '20'
								cString += '<ICMS20>'
								cString += '<CST>20</CST>'
								If !Empty(cpRedBC)
									cString += '<pRedBC>' + ConvType(cpRedBC, 5, 2, "N") + '</pRedBC>'
								EndIf
								cString += '<vBC>'  + ConvType(nBASEICM, 15, 2, "N") + '</vBC>'
								cString += '<pICMS>'+ ConvType(nALIQICM,  6, 2, "N") + '</pICMS>'
								cString += '<vICMS>'+ ConvType(nVALICM , 15, 2, "N") + '</vICMS>'
								cString += '</ICMS20>'
							Else
								If SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '90'
									cString += '<ICMS90>'
								Else
									cString += '<CST81>'
								EndIf
								cString += '<CST>90</CST>'
								If !Empty(cpRedBC)
									cString += '<pRedBC>' + ConvType(cpRedBC, 5, 2, "N") + '</pRedBC>'
								EndIf
								cString += '<vBC>'    + ConvType(nBASEICM, 13, 2, "N") + '</vBC>'
								cString += '<pICMS>'  + ConvType(nALIQICM,  6, 2, "N") + '</pICMS>'
								cString += '<vICMS>'  + ConvType(nVALICM , 13, 2, "N") + '</vICMS>'
								cString += '<vCred>'  + ConvType(nICMSRET, 15, 2, "N") + '</vCred>'
								If SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) == '90'
									cString += '</ICMS90>'
								Else
									cString += '</CST81>'
								EndIf
							EndIf
						ElseIf SubStr((cAliasTagJ)->FT_CLASFIS, 2, 2) $ '20,90' .And. AllTrim(cCFOP) $ "5932,6932"
							//�����������������������������������������������������������������Ŀ
							//� - 81: ICMS DEVIDOS A OUTRAS UF'S                                �
							//� - 90: ICMS Outros                                               �
							//�������������������������������������������������������������������
							cString += '<ICMSOutraUF>'
							cString += '<CST>90</CST>'
							If !Empty(cpRedBC)
								cString += '<pRedBCOutraUF>' + ConvType(cpRedBC, 5, 2, "N") + '</pRedBCOutraUF>'
							EndIf
							cString += '<vBCOutraUF>'    + ConvType(nBASEICM	, 13, 2, "N") + '</vBCOutraUF>'
							cString += '<pICMSOutraUF>'  + ConvType(nALIQICM	,  6, 2, "N") + '</pICMSOutraUF>'
							cString += '<vICMSOutraUF>'  + ConvType(nVALICM  , 13, 2, "N") + '</vICMSOutraUF>'
							cString += '</ICMSOutraUF>'
						EndIf
						cString += '</ICMS>'
						//-- Valor Total dos impostos - Lei da Transparencia
						cString += '<vTotTrib>' + ConvType((cAliasDT6)->DT6_VALIMP, 13, 2, "N") + '</vTotTrib>'
						//-- Observa��es das regras de Tributa��o (campo Memo)
						DbSelectArea("DT6")
						cObs := StrTran(MsMM((cAliasDT6)->DT6_CODMSG),Chr(13),"")
						If !Empty(cObs)
							cString +=  '<infAdFisco>' + NoAcentoCte(SubStr(cObs,1,320)) + '</infAdFisco>'
						EndIf
						cString += '</imp>'
						(cAliasTagJ)->(dbSkip())
						aAdd(aXMLCTe,AllTrim(cString))
					EndDo
					(cAliasTagJ)->(DbCloseArea())

					//�����������������������������������������������������������������Ŀ
					//� TAG: K - Informacoes de CT-e Normal                             �
					//�������������������������������������������������������������������
					If	!AllTrim((cAliasDT6)->DT6_DOCTMS) == StrZero( 8, Len(DT6->DT6_DOCTMS)) .And.;
						!AllTrim((cAliasDT6)->DT6_DOCTMS) == "M"
						
						cString := '<infCTeNorm>'
						
						//�����������������������������������������������������������������Ŀ
						//� TAG: L - Informacoes da Carga Transportada                      �
						//�������������������������������������������������������������������
						cAliasAll := GetNextAlias()
						cQuery    := " SELECT SX5.X5_DESCRI" + CRLF
						cQuery    += "   FROM " +	RetSqlName("SB1") + " SB1 " + CRLF
						cQuery    += "        INNER JOIN " + RetSqlName("DB0") + " DB0 " + CRLF
						cQuery    += "                ON DB0.DB0_FILIAL = '"  + xFilial("DB0")	+ "'" + CRLF
						cQuery    += "               AND DB0.DB0_CODMOD = SB1.B1_TIPCAR " + CRLF
						cQuery    += "               AND DB0.D_E_L_E_T_ = ' ' " + CRLF
						cQuery    += "        INNER JOIN " + RetSqlName("SX5") + " SX5 " + CRLF
						cQuery    += "                ON SX5.X5_FILIAL ='"  + xFilial("SX5") + "'" + CRLF
						cQuery    += "               AND SX5.X5_TABELA ='DU'" + CRLF
						cQuery    += "               AND SX5.X5_CHAVE  = DB0.DB0_TIPCAR " + CRLF
						cQuery    += "               AND SX5.D_E_L_E_T_=' '"
						cQuery    += "  WHERE SB1.B1_FILIAL  = '" + xFilial("SB1")	+ "'" + CRLF
						cQuery    += "               AND SB1.B1_COD = '" + cCodPred + "'" + CRLF
						cQuery    += "               AND SB1.D_E_L_E_T_ = ' '" + CRLF
						cQuery    := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAll, .F., .T.)
						cString += '<infCarga>'
						//-- Produto predominante.
						cString += '<vCarga>'   + ConvType((cAliasDT6)->DT6_VALMER, 15, 2, "N") + '</vCarga>'
						cString += '<proPred>' + NoAcentoCte( cProdPred ) + '</proPred>'
						cString += '<xOutCat>' + NoAcentoCte( (cAliasAll)->X5_DESCRI ) + '</xOutCat>'
						(cAliasAll)->(DbCloseArea())
						
						//-- Caracteristica de todos os produtos.
						If aCarga[1] <> 0 //-- DTC_PESO - KG
							cString += '<infQ>'
							cString += '<cUnid>' + '01' + '</cUnid>'
							cString += '<tpMed>' + 'PESO DECLARADO' + '</tpMed>'
							cString += '<qCarga>' + ConvType(aCarga[1], 15, 4, "N") + '</qCarga>'
							cString += '</infQ>'
						EndIf
						
						If aCarga[2] <> 0 //-- DTC_PESOM3 - M3
							cString += '<infQ>'
							cString += '<cUnid>' + '00' + '</cUnid>'
							cString += '<tpMed>' + 'PESO CUBADO' + '</tpMed>'
							cString += '<qCarga>' + ConvType(aCarga[2], 15, 4, "N") + '</qCarga>'
							cString += '</infQ>'
						EndIf
						
						If aCarga[3] <> 0 //-- DT6_METRO3 - M3
							cString += '<infQ>'
							cString += '<cUnid>' + '00' + '</cUnid>'
							cString += '<tpMed>' + 'METROS CUBICOS' + '</tpMed>'
							cString += '<qCarga>' + ConvType(aCarga[3], 15, 4, "N") + '</qCarga>'
							cString += '</infQ>'
						EndIf
						
						If aCarga[4] <> 0 //-- DTC_QTDVOL - UNI
							cString += '<infQ>'
							If AllTrim(aCarga[5]) == 'L'
								cString += '<cUnid>' + '04' + '</cUnid>'
								cString += '<tpMed>' + 'LITRAGEM' + '</tpMed>'
							Else
								cString += '<cUnid>' + '03' + '</cUnid>'
								cString += '<tpMed>' + 'VOLUME' + '</tpMed>'
							EndIf
							cString += '<qCarga>' + ConvType(aCarga[4], 15, 4, "N") + '</qCarga>'
							cString += '</infQ>'
						EndIf
						aCarga := {0,0,0,0,""}
						cString += '</infCarga>'
						
						aAdd(aXMLCTe,AllTrim(cString))
						cString :='' 

						If cVerAmb == '2.00' 
							If !Empty(cString20)
								 cString20 := '<infDoc>' + cString20 +'</infDoc>'
								aAdd(aXMLCTe,AllTrim(cString20))
								cString20 :=''					
			              EndIf

							If !Empty(cStringCh)						
								cStringCh := '<infDoc>' + cStringCh +'</infDoc>'
								aAdd(aXMLCTe,AllTrim(cStringCh))
								cStringCh :=''	
	      					EndIf

							If !Empty(cStringOut)						
								cStringOut := '<infDoc>' + cStringOut +'</infDoc>'
								aAdd(aXMLCTe,AllTrim(cStringOut))
								cStringOut :=''	
	      					EndIf
      					EndIf
						
						//�����������������������������������������������������������������Ŀ
						//� TAG:  Informacao dos Documentos de Transporte Anterior          �
						//�������������������������������������������������������������������
						If (cTipoNF == '2' .Or. cTipoNF == '5') .And. !Empty(cCtrDpc)
							cString += '<docAnt>'

							cString += '<emiDocAnt>'

							If (AllTrim((cAliasDT6)->DPC_TPPESSOA) == "J")
								cString += '<CNPJ>'	+ IIf((cAliasDT6)->DPC_UF <> 'EX',NoAcentoCte( (cAliasDT6)->DPC_CNPJ ),StrZero(0,14)) + '</CNPJ>'
							Else
								cString += '<CPF>'	+ IIf((cAliasDT6)->DPC_UF <> 'EX',NoAcentoCte( (cAliasDT6)->DPC_CNPJ ),StrZero(0,14)) + '</CPF>'
							EndIf
							If Empty((cAliasDT6)->DPC_INSC) .Or. 'ISENT' $ Upper(AllTrim((cAliasDT6)->DPC_INSC)) .Or. ((cAliasDT6)->DPC_CONTRIB =='1' .And. 'ISENT' $ Upper(AllTrim((cAliasDT6)->DPC_INSC)))
								cString += '<IE>ISENTO</IE>'
							Else
								cString += '<IE>' + NoPontos((cAliasDT6)->DPC_INSC) + '</IE>'
							EndIf
							cString += '<UF>' + NoAcentoCte( (cAliasDT6)->DPC_UF ) + '</UF>'
							cString += '<xNome>' + NoAcentoCte(SubStr((cAliasDT6)->DPC_NOME,1,60)) + '</xNome>'

							cString += '<idDocAnt>'
							//���������������������������������������������������Ŀ
							//� Tipo do Documento origin�rio:                     �
							//� 00 - CTRC                                         �
							//� 01 - CTAC                                         �
							//� 02 - ACT                                          �
							//� 03 - NF Modelo 7                                  �
							//� 04 - NF Modelo 27                                 �
							//� 05 - Conhecimento Aereo Nacional                  �
							//� 06 - CTMC                                         �
							//� 07 - ATRE                                         �
							//� 08 - DTA (Despacho de Transito Aduaneiro)         �
							//� 09 - Conhecimento A�reo Internacional             �
							//� 10 - Conhecimento - Carta de Porte Internacional  �
							//� 11 - Conhecimento Avulso                          �
							//� 12 - TIF (Transporte Internacional Ferroviario)   �
							//� 99 - Outro                                        �
							//�����������������������������������������������������
							
							If Empty()
								cString += '<idDocAntPap>'
								
								If cTpDocAnt == '0'
									cString += '<tpDoc>00</tpDoc>'
								ElseIf cTpDocAnt == '2'
									cString += '<tpDoc>02</tpDoc>'
								ElseIf cTpDocAnt == '3'
									cString += '<tpDoc>03</tpDoc>'
								ElseIf cTpDocAnt == '4'
									cString += '<tpDoc>04</tpDoc>'
								ElseIf cTpDocAnt == '5'
									cString += '<tpDoc>05</tpDoc>'
								EndIf
								
								cString += '<serie>' + cSerDpc   + '</serie>'
								cString += '<nDoc>'  + cCtrDpc   + '</nDoc>'
								cString += '<dEmi>'  + cDtEmi    + '</dEmi>'
								cString += '</idDocAntPap>'
							Else
								cString += '<idDocAntEle>'
								cString += '<chave>' + cCTEDocAnt + '</chave>'
								cString += '</idDocAntEle>'
							EndIf
							
							cString += '</idDocAnt>'
							
							cString += '</emiDocAnt>'
							
							cString += '</docAnt>'
							
						EndIf

						//�����������������������������������������������������������������Ŀ
						//� TAG: - Seguradora                                               �
						//�������������������������������������������������������������������
						//-- Valida se existe Responsavel pelo seguro
						aResp := TMSAvbCli(	(cAliasDT6)->DT6_CLIDEV, (cAliasDT6)->DT6_LOJDEV, '', ;
											(cAliasDT6)->DT6_CLIREM, (cAliasDT6)->DT6_LOJREM,     ;
											(cAliasDT6)->DT6_CLIDES, (cAliasDT6)->DT6_LOJDES, .F. )
						If !Empty(aResp) .And. lForApol //-- Cliente Responsavel pelo Seguro
							cAliasSeg := GetNextAlias()
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
							cQuery := ChangeQuery(cQuery)
							DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSeg, .F., .T.)
							If (cAliasSeg)->(!EoF())
								cNomSeg   := (cAliasSeg)->A2_NOME
								cApolice  := (cAliasSeg)->DV6_APOL
									If aResp[1]+aResp[2] == (cAliasDT6)->DT6_CLIREM + (cAliasDT6)->DT6_LOJREM
									cRespSeg  := '0' //-- Remetente;
								ElseIf aResp[1]+aResp[2] == (cAliasDT6)->DT6_CLIDES + (cAliasDT6)->DT6_LOJDES
									cRespSeg  := '3' //-- Destinatario;
								ElseIf aResp[1]+aResp[2] == (cAliasDT6)->DT6_CLIDEV + (cAliasDT6)->DT6_LOJDEV
									cRespSeg  := '5' //-- Tomador de Servico;
								EndIf
							EndIf
							(cAliasSeg)->(DbCloseArea())
						EndIf

						//-- Caso o Cliente n�o esteja registrado na tabela de Averba��o
						//-- Transportadora Responsavel pelo Seguro
						If !Empty(cForSeg) .And. (Empty(cNomSeg) .And. Empty(cApolice) .And. Empty(cRespSeg)) .And. lForApol
							cAliasSeg := GetNextAlias()
							cQuery := "SELECT  SA2.A2_NOME, SA2.A2_APOLICE"
							cQuery += " FROM  " + RetSqlName("SA2") + " SA2 "
							cQuery += " WHERE A2_COD = '" + Substr(cForSeg,1,nTamCod) + "'"
							cQuery += " AND A2_LOJA  = '" + Substr(cForSeg,nTamCod+1,nTamLoj) + "'"
							cQuery += " AND SA2.A2_FILIAL  = '" + xFilial("SA2") + "'"
							cQuery += " AND SA2.D_E_L_E_T_ = ' '"
							cQuery := ChangeQuery(cQuery)
							DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSeg, .F., .T.)
							If (cAliasSeg)->(!EoF())
								cRespSeg  := '4' //-- Emitente do CT-e;
								cNomSeg   := (cAliasSeg)->A2_NOME 
								cApolice  := (cAliasSeg)->A2_APOLICE
							EndIf
							(cAliasSeg)->(DbCloseArea())
						EndIf

						If !Empty(cRespSeg) .And. !Empty(cNomSeg) .And. !Empty(cApolice)
							cString += '<seg>'
								cString += '<respSeg>'+ NoAcentoCte(AllTrim(cRespSeg))  + '</respSeg>'
								cString += '<xSeg>'   + NoAcentoCte(AllTrim(cNomSeg))   + '</xSeg>'
								cString += '<nApol>'  + NoAcentoCte(AllTrim(cApolice))  + '</nApol>'
								cString += '<vCarga>' + ConvType((cAliasDT6)->DT6_VALMER, 15, 2, "N") +'</vCarga>'
							cString += '</seg>'
						EndIf

						//�����������������������������������������������������������������Ŀ
						//� TAG: M - Dados Especificos do Modal Rodoviario                  �
						//�������������������������������������������������������������������
						//Verifica se possui viagem para verificar se a mesma se trata de lota��o.
						cString += '<infModal versaoModal="'+cVerAmb+'">'
						cString += '<rodo>'
						cString += '<RNTRC>' + SubStr(AllTrim(cTmsAntt),1,8) + '</RNTRC>'
						cString += '<dPrev>' + SubStr(AllTrim((cAliasDT6)->DT6_PRZENT), 1, 4) + "-" + SubStr(AllTrim((cAliasDT6)->DT6_PRZENT), 5, 2) + "-" + SubStr(AllTrim((cAliasDT6)->DT6_PRZENT), 7, 2) + '</dPrev>' //-- Data previsao entrega
						If !lLotacao
							cString   += '<lota>'  + '0' + '</lota>'
						ElseIf SA2->(FieldPos('A2_RNTRC')) > 0
							//-- Veiculos da lotacao
							If Empty(cFilVia)
								cFilVia := (cAliasDT6)->DT6_FILORI
							EndIf
							
							cAliasDTR := GetNextAlias()
							cString   += '<lota>'  + '1' + '</lota>'
							cQuery    := "SELECT DTR_CODVEI, DTR_CODRB1, DTR_CODRB2 "
							cQuery    += " FROM " + RetSqlName("DTR")+" DTR "
							cQuery    += " WHERE DTR_FILIAL = '"+xFilial('DTR')+"'"
							cQuery    += "   AND DTR_FILORI = '"+cFilVia+"'"
							cQuery    += "   AND DTR_VIAGEM = '"+cViagem+"'"
							cQuery    += "   AND D_E_L_E_T_ = ' '"
							cQuery    := ChangeQuery(cQuery)
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTR,.F.,.T.)
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
									cAliasDA3 := GetNextAlias()
									cQuery := ""
									cQuery += " SELECT DA3_COD   , DA3_PLACA , DA3_RENAVA, DA3_TARA  ,DA3_CAPACM, DA3_FROVEI, " + CRLF
									cQuery += "        DA3_ESTPLA, DA3_CODFOR, DA3_LOJFOR, DUT_TIPROD, DUT_TIPCAR, "            + CRLF
									cQuery += "        DA3_ALTINT, DA3_LARINT, DA3_COMINT, "                                    + CRLF
									cQuery += "        A2_CGC    , A2_NOME   , A2_INSCR  , A2_EST    , A2_TIPO  , A2_RNTRC    " + CRLF
									cQuery += " FROM " + RetSqlName("DA3") + " DA3 " + CRLF

									cQuery += " INNER JOIN " + RetSqlName("DUT") + " DUT " + CRLF
									cQuery += "   ON DUT.DUT_TIPVEI = DA3.DA3_TIPVEI " + CRLF
									cQuery += "   AND DUT.D_E_L_E_T_ = ' ' " + CRLF

									cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 ON " + CRLF
									cQuery += "           SA2.A2_COD    = DA3.DA3_CODFOR AND " + CRLF
									cQuery += "           SA2.A2_LOJA   = DA3.DA3_LOJFOR AND " + CRLF
									cQuery += "           SA2.D_E_L_E_T_= '' " + CRLF

									cQuery += " WHERE DA3.DA3_FILIAL = '"+xFilial("DA3")+"'" + CRLF
									cQuery += "   AND DA3.DA3_COD    = '"+cCodVei+"'"        + CRLF
									cQuery += "   AND DA3.D_E_L_E_T_ = ' '"                  + CRLF
									cQuery += "   AND DUT.DUT_FILIAL = '"+xFilial('DUT')+"'" + CRLF
									cQuery += "   AND SA2.A2_FILIAL  = '"+xFilial('SA2')+"'" + CRLF
									cQuery := ChangeQuery(cQuery)
									dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDA3,.F.,.T.)

									//�����������������������������������������������������������������Ŀ
									//� TAG: Veic -- Tag com informacoes do veiculo quando o servico for�
									//� de lotacao e possuir viagem relacionada                         �
									//�������������������������������������������������������������������
									cString += '<veic>'
									cString += '<cInt>'    + NoAcentoCte((cAliasDA3)->DA3_COD)    + '</cInt>'
									cString += '<RENAVAM>' + NoacentoCte((cAliasDA3)->DA3_RENAVA) + '</RENAVAM>'
									cString += '<placa>'   + NoAcentoCte((cAliasDA3)->DA3_PLACA)  + '</placa>'
									cString += '<tara>'    + ConvType(((cAliasDA3)->DA3_TARA) 	, 6,0, "N")    + '</tara>'
									cString += '<capKG>'   + ConvType(((cAliasDA3)->DA3_CAPACM) , 6, 0, "N") + '</capKG>'
									//Converte Valor da capacidade em KG para M3
									nCapcM3 := Round((cAliasDA3)->DA3_ALTINT * (cAliasDA3)->DA3_LARINT * (cAliasDA3)->DA3_COMINT,0)
									cString += '<capM3>'   + ConvType((nCapcM3) , 3, 0, "N") + '</capM3>'
									cString += '<tpProp>'  + IIf((cAliasDA3)->DA3_FROVEI == '1', 'P','T')    + '</tpProp>'
									//�����������������������������������������������������������������Ŀ
									//� TAG: tpVei -- Se for o primeiro veiculo ser� Tra��o = 0         �
									//� caso contr�rio ser� reboque = 1                                 �
									//�������������������������������������������������������������������
									If nX == 1
										cString += '<tpVeic>' + '0' + '</tpVeic>'
									Else
										cString += '<tpVeic>' + '1'+ '</tpVeic>'
									EndIf
									cString += '<tpRod>' + (cAliasDA3)->DUT_TIPROD + '</tpRod>'
									cString += '<tpCar>' + (cAliasDA3)->DUT_TIPCAR + '</tpCar>'
									cString += '<UF>' + (cAliasDA3)->DA3_ESTPLA + '</UF>'
									//�����������������������������������������������������������������Ŀ
									//� TAG: Prop -- Se o veiculo for de terceiros, preencher tags com  �
									//� informacoes do propriet�rio                                     �
									//�������������������������������������������������������������������
									If (cAliasDA3)->DA3_FROVEI <> '1'
										cString += '<prop>'
										If (cAliasDA3)->A2_TIPO == 'F'
											cString += '<CPF>' + StrZero(Val(AllTrim((cAliasDA3)->A2_CGC)),11) + '</CPF>'
										Else
											cString += '<CNPJ>' + StrZero(Val(AllTrim((cAliasDA3)->A2_CGC)),14) + '</CNPJ>'
										EndIf
										If !Empty((cAliasDA3)->A2_RNTRC)
											cString += '<RNTRC>' + StrZero(Val(AllTrim((cAliasDA3)->A2_RNTRC)),8) + '</RNTRC>'
										EndIf
										cString += '<xNome>' + NoAcentoCte((cAliasDA3)->A2_NOME) + '</xNome>'
										If Empty((cAliasDA3)->A2_INSCR) .Or. "ISENT" $ Upper(AllTrim((cAliasDA3)->A2_INSCR))
											cString += '<IE>ISENTO</IE>'
										Else
											cString += '<IE>' + NoPontos((cAliasDA3)->A2_INSCR) + '</IE>'
										EndIf
										cString += '<UF>' 	 + (cAliasDA3)->A2_EST + '</UF>'
										If (cAliasDA3)->DA3_FROVEI   == '3'
											cString += '<tpProp>'+ '0' + '</tpProp>' //--0(Agregado)--1(Independente)--2(Outros	)
										Else
											cString += '<tpProp>'+ '1' + '</tpProp>'
										EndIf
										cString += '</prop>'
									EndIf
									cString += '</veic>'
								Next nX
								(cAliasDTR)->(dbSkip())
							EndDo
							(cAliasDTR)->(dbCloseArea())
							
							//-- Lacres dos veiculos da lotacao
							cAliasDVB := GetNextAlias()

							cQuery := " SELECT DVB_LACRE "
							cQuery += CRLF+" FROM " + RetSqlName("DVB")	+ " DVB "
							cQuery += CRLF+" WHERE DVB_FILIAL = '" + xFilial("DVB") + "' AND "
							cQuery += CRLF+"       DVB_FILORI = '" + cFilVia + "' AND "
							cQuery += CRLF+"       DVB_VIAGEM = '" + cViagem + "' AND "
							cQuery += CRLF+"       DVB.D_E_L_E_T_ = '' "
							cQuery := ChangeQuery(cQuery)
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDVB,.F.,.T.)

							While (cAliasDVB)->(!Eof())
								cString+=	'<lacRodo>'
								cString+= 		'<nLacre>' + AllTrim((cAliasDVB)->DVB_LACRE) + '</nLacre>'
								cString+=	'</lacRodo>'
								dbskip()
							Enddo							
							(cAliasDVB)->(dbCloseArea())
							
							//-- Motoristas dos veiculos da lotacao
							cAliasDA4 := GetNextAlias()
							cQuery := " SELECT DA4_COD,DA4_NOME,DA4_CGC "
							cQuery += CRLF+" FROM " + RetSqlName("DA4") + " DA4 "
							cQuery += CRLF+" INNER JOIN " + RetSqlName("DUP") + " DUP ON "
							cQuery += CRLF+"        DUP.DUP_CODMOT = DA4.DA4_COD AND "
							cQuery += CRLF+"        DUP.D_E_L_E_T_ = '' "
							cQuery += CRLF+ " WHERE DA4_FILIAL     = '" + xFilial("DA4") + "' AND "
							cQuery += CRLF+ "       DUP.DUP_FILIAL = '" + xFilial("DUP") + "' AND "
							cQuery += CRLF+ "       DUP_FILORI     = '" + cFilVia + "' AND "
							cQuery += CRLF+ "       DUP_VIAGEM     = '" + cViagem + "' AND "
							cQuery += CRLF+ "       DA4.D_E_L_E_T_ = '' "
							cQuery := ChangeQuery(cQuery)
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDA4,.F.,.T.)

							While (cAliasDA4)->(!Eof())
								cString += '<moto>'
								cString +=   '<xNome>' + NoAcentoCte((cAliasDA4)->DA4_NOME) +'</xNome>
								cString +=   '<CPF>'   + AllTrim((cAliasDA4)->DA4_CGC) +'</CPF>'
								cString += '</moto>'
								(cAliasDA4)->(dbSkip())
							EndDo
							(cAliasDA4)->(dbCloseArea())
						EndIf
						cString += '</rodo>'
						cString += '</infModal>'

						//�����������������������������������������������������������������Ŀ
						//� TAG: N - Dados EspecIficos do Transporte de Produtos Perigosos  �
						//�������������������������������������������������������������������
						If AliasInDic("DY3")
							cAliasDY3 := GetNextAlias()
							cQuery := " SELECT DY3.DY3_ONU, DY3.DY3_DESCRI, DY3.DY3_CLASSE, DY3.DY3_GRPEMB, DY3.DY3_LIMVEI " + CRLF
							cQuery += "  ,SUM(DTC.DTC_PESO) DTC_PESO " + CRLF
							cQuery += "       FROM " + RetSqlName("DTC") + " DTC " + CRLF
							cQuery += "           INNER JOIN " + RetSqlName("SB5") + " SB5 ON " + CRLF
							cQuery += "                 SB5.B5_FILIAL = '"  + xFilial('SB5')	+ "' AND " + CRLF
							cQuery += "                 SB5.B5_COD = DTC.DTC_CODPRO AND " + CRLF
							cQuery += "                 SB5.B5_CARPER = '1' AND " + CRLF
							cQuery += "                 SB5.D_E_L_E_T_ = '' " + CRLF
							cQuery += "           INNER JOIN " + RetSqlName("DY3") + " DY3 ON " + CRLF
							cQuery += "                 DY3.DY3_FILIAL = '"  + xFilial('DY3')	+ "' AND " + CRLF
							cQuery += "                 DY3.DY3_ONU    = SB5.B5_ONU AND " + CRLF
							cQuery += "                 DY3.DY3_ITEM   = SB5.B5_ITEM AND " + CRLF
							cQuery += "                 DY3.D_E_L_E_T_ = '' " + CRLF
							If	lDocApoio
								cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 " + CRLF
								cQuery += "     ON DT6.DT6_CLIDEV   = '" + (cAliasDT6)->DT6_CLIDEV + "'" + CRLF
								cQuery += "    AND DT6.DT6_LOJDEV   = '" + (cAliasDT6)->DT6_LOJDEV + "'" + CRLF
								cQuery += "    AND DT6.DT6_PREFIX   = '" + (cAliasDT6)->DT6_PREFIX + "'" + CRLF
								cQuery += "    AND DT6.DT6_NUM      = '" + (cAliasDT6)->DT6_NUM    + "'" + CRLF
								cQuery += "    AND DT6.DT6_TIPO     = '" + (cAliasDT6)->DT6_TIPO   + "'" + CRLF
								cQuery += "    AND DT6_DOCTMS IN('B','C','H','I','N','O') " + CRLF
								cQuery += "    AND DT6.D_E_L_E_T_   = ' '" + CRLF
								cQuery += "  WHERE DTC.DTC_FILIAL	= '" + xFilial('DTC') + "'" + CRLF
								cQuery += "    AND DTC.DTC_FILDOC   = DT6.DT6_FILDOC " + CRLF
								cQuery += "    AND DTC.DTC_DOC      = DT6.DT6_DOC    " + CRLF
								cQuery += "    AND DTC.DTC_SERIE    = DT6.DT6_SERIE  " + CRLF
							Else
								cQuery += CRLF+" WHERE DTC.DTC_FILIAL = '" + xFilial('DTC')				+ "'" + CRLF
								cQuery += CRLF+"   AND DTC.DTC_FILDOC = '" + (cAliasDT6)->DT6_FILDOC	+ "'" + CRLF
								cQuery += CRLF+"   AND DTC.DTC_DOC    = '" + (cAliasDT6)->DT6_DOC		+ "'" + CRLF
								cQuery += CRLF+"   AND DTC.DTC_SERIE  = '" + (cAliasDT6)->DT6_SERIE	+ "'" + CRLF
							EndIf
							cQuery += "   AND DTC.D_E_L_E_T_ = '' " + CRLF
							cQuery += "GROUP BY DY3.DY3_ONU, DY3.DY3_DESCRI, DY3.DY3_CLASSE, DY3.DY3_GRPEMB, DY3.DY3_LIMVEI " + CRLF
							cQuery += "ORDER BY DY3.DY3_ONU " + CRLF

							cQuery := ChangeQuery(cQuery)
							DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasDY3, .F., .T.)
							
							If !(cAliasDY3)->(Eof())
								While !(cAliasDY3)->(Eof())
									cString += '<peri>'
									cString += '<nONU>'+ Alltrim(Str(Val((cAliasDY3)->DY3_ONU))) +'</nONU>'
									cString += '<xNomeAE>'+ Upper(NoAcentoCte(SubStr((cAliasDY3)->DY3_DESCRI,1,150))) +'</xNomeAE>'
									cString += '<xClaRisco>'+ NoPontos((cAliasDY3)->DY3_CLASSE) +'</xClaRisco>'
									If !Empty((cAliasDY3)->DY3_GRPEMB)
										cString += '<grEmb>'+AllTrim((cAliasDY3)->DY3_GRPEMB)+'</grEmb>'
									EndIf
									cString += '<qTotProd>'+AllTrim(STR((cAliasDY3)->DTC_PESO))+'</qTotProd>'
									cString += '</peri>'
									(cAliasDY3)->(DbSkip())
								EndDo
							EndIf							
							(cAliasDY3)->(DbCloseArea())
						EndIf
						
						If AllTrim((cAliasDT6)->DT6_DOCTMS) == "P"
							cString += '<infCteSub>'
						
							//-- Query para pesquisar a chave do CTE original
							cAliasChv :=  GetNextAlias()
							cQuery := " SELECT DT6.DT6_CHVCTE " +CRLF
							cQuery += "   FROM " + RetSqlName('DT6') + " DT6 " +CRLF
							cQuery += "  WHERE DT6.DT6_FILIAL = '" + xFilial('DT6') + "'" +CRLF
							cQuery += "    AND DT6.DT6_FILDOC = '" + (cAliasDT6)->DT6_FILDCO + "'" +CRLF
							cQuery += "    AND DT6.DT6_DOC    = '" + (cAliasDT6)->DT6_DOCDCO + "'" +CRLF
							cQuery += "    AND DT6.DT6_SERIE  = '" + (cAliasDT6)->DT6_SERDCO + "'" +CRLF
							cQuery += "    AND DT6.D_E_L_E_T_ = ' '"
							cQuery := ChangeQuery(cQuery)
							DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasChv, .F., .T.)
							//-- Chave do Cte Original
							If (!(cAliasChv)->(Eof()))
								cString += '<chCte>' + (cAliasChv)->DT6_CHVCTE + '</chCte>'
							EndIf
							(cAliasChv)->(DbCloseArea())

							If lContrib
								cAliasChv :=  GetNextAlias()
								cQuery := " SELECT SF1.F1_CHVNFE, SF1.F1_EMISSAO, SF1.F1_SERIE, SF1.F1_DOC, SF1.F1_VALBRUT  " +CRLF
								cQuery += "   FROM " + RetSqlName('SF1') + " SF1 " +CRLF
								cQuery += "  WHERE SF1.F1_FILIAL = '" + xFilial('SF1') + "'" +CRLF
								cQuery += "    AND SF1.F1_NFORIG = '" + (cAliasDT6)->DT6_DOCDCO + "'" +CRLF
								cQuery += "    AND SF1.F1_SERORIG = '" + (cAliasDT6)->DT6_SERDCO + "'" +CRLF
								cQuery += "    AND SF1.D_E_L_E_T_ = ' '"
								cQuery := ChangeQuery(cQuery)
								DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasChv, .F., .T.)

								cString +=   '<tomaICMS>'
								If (!(cAliasChv)->(Eof()))
									cDtEmi	:= SubStr((cAliasChv)->F1_EMISSAO, 1, 4) + "-";
											+  SubStr((cAliasChv)->F1_EMISSAO, 5, 2) + "-";
											+  SubStr((cAliasChv)->F1_EMISSAO, 7, 2)
									cString +=   '<refNF>'
									If cPessoaToma == "J"
										cString += '<CNPJ>' +cCNPJToma+ '</CNPJ>'
									Else
										cString += '<CPF>' +cCNPJToma+ '</CPF>'
									EndIf
									cString +=   '<mod>'  +'55'+'</mod>'
									cString +=   '<serie>'+'0'+'</serie>'
									cString +=   '<nro>'  +Alltrim((cAliasChv)->F1_DOC)+'</nro>'
									cString +=   '<valor>'+ConvType((cAliasChv)->F1_VALBRUT, 15, 2, "N")+'</valor>'
									cString +=   '<dEmi>' +cDtEmi+'</dEmi>'
									cString +=   '</refNF>'
								EndIf
								cString +=   '</tomaICMS>'
							Else
								cAliasChv :=  GetNextAlias()
								cQuery := ''
								cQuery += " SELECT SF1.F1_CHVNFE " + CRLF
								cQuery += "   FROM " + RetSqlName('SF1') + " SF1 " + CRLF
								cQuery += "  WHERE SF1.F1_FILIAL  = '" + (cAliasDT6)->DT6_FILDCO + "'" + CRLF
								cQuery += "    AND SF1.F1_NFORIG  = '" + (cAliasDT6)->DT6_DOCDCO + "'" + CRLF
								cQuery += "    AND SF1.F1_SERORIG = '" + (cAliasDT6)->DT6_SERDCO + "'" + CRLF
								cQuery += "    AND SF1.D_E_L_E_T_ = ' '"
								cQuery := ChangeQuery(cQuery)
								DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasChv, .F., .T.)
								cString +=   '<tomaNaoICMS>'
								//-- Chave do Cte Anulacao
								If (!(cAliasChv)->(Eof()))
									cString +=   '<refCteAnu>'+(cAliasChv)->F1_CHVNFE+'</refCteAnu>'
								EndIf
								cString +=   '</tomaNaoICMS>'
							EndIf
							(cAliasChv)->(DbCloseArea())
							cString += '</infCteSub>'
						EndIf

						cString += '</infCTeNorm>'

						aAdd(aXMLCTe,AllTrim(cString))
					EndIf

					//�����������������������������������������������������������������Ŀ
					//� TAG: O - CT-e Complementar                                      �
					//�������������������������������������������������������������������
					If AllTrim((cAliasDT6)->DT6_DOCTMS) == StrZero( 8, Len(DT6->DT6_DOCTMS))

						cString := '<infCteComp>'

						//-- Query para pesquisar a chave do CTE original
						cAliasChv :=  GetNextAlias()
						cQuery := " SELECT DT6.DT6_CHVCTE, DT6.DT6_VALTOT " + CRLF
						cQuery += "   FROM " + RetSqlName('DT6') + " DT6 " + CRLF
						cQuery += "  WHERE DT6.DT6_FILIAL = '" + xFilial('DT6') + "'" + CRLF
						cQuery += "    AND DT6.DT6_FILDOC = '" + (cAliasDT6)->DT6_FILDCO + "'" + CRLF
						cQuery += "    AND DT6.DT6_DOC    = '" + (cAliasDT6)->DT6_DOCDCO + "'" + CRLF
						cQuery += "    AND DT6.DT6_SERIE  = '" + (cAliasDT6)->DT6_SERDCO + "'" + CRLF
						cQuery += "    AND DT6.D_E_L_E_T_ = ' '"
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasChv, .F., .T.)
						//-- Chave do Cte Original
						If (!(cAliasChv)->(Eof()))
							cString += '<chave>' + (cAliasChv)->DT6_CHVCTE + '</chave>'
							If cVerAmb == '1.04'
								cString += '<vPresComp>'
								cString += '<vTPrest>' + ConvType((cAliasChv)->DT6_VALTOT, 15, 2, "N") + '</vTPrest>'
								EndIf
						EndIf
						(cAliasChv)->(DbCloseArea())
						
						If cVerAmb == '1.04'
							//-- Valor do complemento gerado
							//�����������������������������������������������������������������Ŀ
							//� Se o tipo de Conhecimento for de Complemento, seleciona as      �
							//�informacoes do CTR principal, pois o complemento nao tem DTC     �
							//�������������������������������������������������������������������
							cAliasVPrest := GetNextAlias()
							cQuery := " SELECT DOCCOMP.DT8_VALPAS, " + CRLF
							cQuery += "        DOCCOMP.DT8_VALTOT, " + CRLF
							cQuery += "           COMP.DT3_DESCRI  " + CRLF
							cQuery += "        FROM " + RetSqlName('DT8') + " DOCCOMP " + CRLF
							cQuery += " INNER JOIN  " + RetSqlName('DT3') + " COMP "    + CRLF
							cQuery += "   ON (COMP.DT3_FILIAL = '" + xFilial("DT3") + "'" + CRLF
							cQuery += "   AND COMP.DT3_CODPAS = DOCCOMP.DT8_CODPAS " + CRLF
							cQuery += "   AND COMP.D_E_L_E_T_=' ')" + CRLF
							cQuery += " WHERE DOCCOMP.DT8_FILIAL  = '" + xFilial("DT8") + "'" + CRLF
							cQuery += "   AND DOCCOMP.DT8_FILDOC  = '" + AllTrim((cAliasDT6)->DT6_FILDCO) + "'" + CRLF
							cQuery += "   AND DOCCOMP.DT8_DOC     = '" + AllTrim((cAliasDT6)->DT6_DOCDCO) + "'" + CRLF
							cQuery += "   AND DOCCOMP.DT8_SERIE   = '" + AllTrim((cAliasDT6)->DT6_SERDCO) + "'" + CRLF
							cQuery += "   AND DOCCOMP.D_E_L_E_T_  = ' '"
							cQuery := ChangeQuery(cQuery)
							DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasVPrest, .F., .T.)
							//-- Componentes do valor da prestacao
							While !(cAliasVPrest)->(Eof())
								cString +='<compComp>'
								cString += '<xNome>' + AllTrim(SubStr(NoAcentoCte((cAliasVPrest)->DT3_DESCRI),1,15)) + '</xNome>'
								If lCTEVFRE
									cString += '<vComp>' + ConvType((cAliasVPrest)->DT8_VALPAS, 15, 2, "N") + '</vComp>'
								Else
									cString += '<vComp>' + ConvType((cAliasVPrest)->DT8_VALTOT, 15, 2, "N") + '</vComp>'
								EndIf
								cString +='</compComp>'
								(cAliasVPrest)->(dbSkip())
							EndDo
							(cAliasVPrest)->(DbCloseArea())
							cString += '</vPresComp>'
	
							//-- Impostos complementares.
							cAliasTagO := GetNextAlias()
							cQuery := " SELECT SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS, " + CRLF
							cQuery += "    MAX(SFT.FT_ALIQICM) FT_ALIQICM, " + CRLF
							cQuery += "    SUM(SFT.FT_BASEICM) FT_BASEICM, " + CRLF
							cQuery += "    SUM(SFT.FT_VALICM)  FT_VALICM   " + CRLF
							cQuery += "              FROM " + RetSqlName('SFT') + " SFT " + CRLF
							cQuery += "        INNER JOIN " + RetSqlName('SF3') + " SF3 " + CRLF
							cQuery += "                ON SF3.F3_FILIAL  = '" + xFilial('SF3') + "'" + CRLF
							cQuery += "               AND SF3.F3_NFISCAL = SFT.FT_NFISCAL " + CRLF
							cQuery += "               AND SF3.F3_SERIE   = SFT.FT_SERIE   " + CRLF
							cQuery += "               AND SF3.F3_CLIEFOR = SFT.FT_CLIEFOR " + CRLF
							cQuery += "               AND SF3.F3_LOJA    = SFT.FT_LOJA    " + CRLF
							cQuery += "               AND SF3.F3_DTCANC  = '' " + CRLF
							cQuery += "               AND SF3.D_E_L_E_T_ = '' " + CRLF
							cQuery += "  WHERE SFT.FT_FILIAL  = '" + xFilial('SFT') + "'" + CRLF
							cQuery += "    AND SFT.FT_NFISCAL = '" + (cAliasDT6)->DT6_DOCDCO  + "'" + CRLF
							cQuery += "    AND SFT.FT_SERIE   = '" + (cAliasDT6)->DT6_SERDCO  + "'" + CRLF
							cQuery += "    AND SFT.FT_TIPOMOV = 'S'" + CRLF
							cQuery += "    AND SFT.D_E_L_E_T_ = ' '" + CRLF
							cQuery += "  GROUP BY SFT.FT_NFISCAL, SFT.FT_SERIE, SFT.FT_CLASFIS "
							cQuery := ChangeQuery(cQuery)
							DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTagO, .F., .T.)
							If !(cAliasTagO)->(Eof())
								cString += '<impComp>'
								//���������������������������������������������Ŀ
								//� Informacoes relativas ao ICMS Complementar	�
								//�����������������������������������������������
								cString += '<ICMSComp>'
								If SubStr((cAliasTagO)->FT_CLASFIS, 2, 2) == '00'
									cString += '<ICMS00>'
									cString += '<CST>00</CST>'
									cString += '<vBC>'  + ConvType((cAliasTagO)->FT_BASEICM, 15, 2, "N") + '</vBC>'
									cString += '<pICMS>'+ ConvType((cAliasTagO)->FT_ALIQICM,  5, 2, "N") + '</pICMS>'
									cString += '<vICMS>'+ ConvType((cAliasTagO)->FT_VALICM , 15, 2, "N") + '</vICMS>'
									cString += '</ICMS00>'
								ElseIf SubStr((cAliasTagO)->FT_CLASFIS, 2, 2) $ "40/41/51"
									//�����������������������������������������Ŀ
									//� ICMS Isento, nao Tributado ou dIferido  �
									//� - 40: ICMS Isencao                      �
									//� - 41: ICMS Nao Tributada                �
									//� - 51: ICMS DIferido                     �
									//�������������������������������������������
									cString += '<ICMS45>'
									If SubStr((cAliasTagO)->FT_CLASFIS, 2, 2)  == '40'
										cString += '<CST>40</CST>'
									ElseIf SubStr((cAliasTagO)->FT_CLASFIS, 2, 2) == '41'
										cString += '<CST>41</CST>'
									ElseIf SubStr((cAliasTagO)->FT_CLASFIS, 2, 2) == '51'
										cString += '<CST>51</CST>'
									EndIf
									cString += '</ICMS45>'
								ElseIf SubStr((cAliasTagO)->FT_CLASFIS, 2, 2) $ "10,30,60,70"
									//�����������������������������������������������������������������Ŀ
									//� - 80: ICMS pagto atribuido ao tomador ou ao 3o previsto para    �
									//� substituicao tributaria                                         �
									//�������������������������������������������������������������������
									cString += '<ICMS90>'
									cString += '<CST>90</CST>'
									cString += '<vBC>'  + ConvType((cAliasTagO)->FT_BASEICM, 13, 2, "N") + '</vBC>'
									cString += '<pICMS>'+ ConvType((cAliasTagO)->FT_ALIQICM,  5, 2, "N") + '</pICMS>'
									cString += '<vICMS>'+ ConvType((cAliasTagO)->FT_VALICM , 13, 2, "N") + '</vICMS>'
									cString += '</ICMS90>'
								ElseIf SubStr((cAliasTagO)->FT_CLASFIS, 2, 2) $ '20,90' .Or. AllTrim(cCFOP) $ "5932,6932"
									//�����������������������������������������������������������������Ŀ
									//� - 81: ICMS DEVIDOS A OUTRAS UF'S                                �
									//� - 90: ICMS Outros                                               �
									//�������������������������������������������������������������������
									cAliasRBC := GetNextAlias()
									cQuery := " SELECT F4_BASEICM " + CRLF
									cQuery += "   FROM " + RetSqlName("SD2") + " D2," + RetSqlName("SF4") + " F4 "  + CRLF
									cQuery += "  WHERE D2.D2_FILIAL  = '"   + xFilial('SD2') + "'" + CRLF
									cQuery += "    AND D2.D2_DOC     = '"   + cNota    + "'" + CRLF
									cQuery += "    AND D2.D2_SERIE   = '"   + cSerie   + "'" + CRLF
									cQuery += "    AND D2.D2_CLIENTE = '"   + cClieFor + "'" + CRLF
									cQuery += "    AND D2.D2_LOJA    = '"   + cLoja    + "'" + CRLF
									cQuery += "    AND D2.D_E_L_E_T_ = ' '" + CRLF
									//-- Cadastro de TES
									cQuery += "    AND F4.F4_FILIAL  = '"  + xFilial('SF4') + "'" + CRLF
									cQuery += "    AND F4.F4_CODIGO  = D2.D2_TES" + CRLF
									cQuery += "    AND F4.D_E_L_E_T_ = ' '"
									cQuery := ChangeQuery(cQuery)
									DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasRBC, .F., .T.)
									If !(cAliasRBC)->(Eof())
										If (cAliasRBC)->F4_BASEICM > 0
											cpRedBC := AllTrim(Str(100-(cAliasRBC)->F4_BASEICM ))
										EndIf
									EndIf
									(cAliasRBC)->(DbCloseArea())
									If SubStr((cAliasTagO)->FT_CLASFIS, 2, 2) == '20'
										cString += '<ICMS20>'
										cString += '<CST>20</CST>'
										If !Empty(cpRedBC)
											cString += '<pRedBC>' + ConvType(cpRedBC, 5, 2, "N") + '</pRedBC>'
										EndIf
										cString += '<vBC>'  + ConvType((cAliasTagO)->FT_BASEICM, 13, 2, "N") + '</vBC>'
										cString += '<pICMS>'+ ConvType((cAliasTagO)->FT_ALIQICM,  5, 2, "N") + '</pICMS>'
										cString += '<vICMS>'+ ConvType((cAliasTagO)->FT_VALICM , 13, 2, "N") + '</vICMS>'
										cString += '</ICMS20>'
									Else
										If SubStr((cAliasTagO)->FT_CLASFIS, 2, 2) == '90'
											cString += '<ICMS90>'
											cString += '<CST>90</CST>'
										Else
											cString += '<ICMS81>'
											cString += '<CST>81</CST>'
										EndIf
										If !Empty(cpRedBC)
											cString += '<pRedBC>' + ConvType(cpRedBC, 5, 2, "N") + '</pRedBC>'
										EndIf
										cString += '<vBC>'  + ConvType((cAliasTagO)->FT_BASEICM, 13, 2, "N") + '</vBC>'
										cString += '<pICMS>'+ ConvType((cAliasTagO)->FT_ALIQICM,  5, 2, "N") + '</pICMS>'
										cString += '<vICMS>'+ ConvType((cAliasTagO)->FT_VALICM , 13, 2, "N") + '</vICMS>'
										cString += '<vCred>' + ConvType(nVcred, 15, 2, "N") + '</vCred>'
										If SubStr((cAliasTagO)->FT_CLASFIS, 2, 2) == '90'
											cString += '</ICMS90>'
										Else
											cString += '</ICMS81>'
										EndIf
									EndIf
								EndIf
								cString += '</ICMSComp>'
								// Observa��es das regras de Tributa��o (campo Memo)
								DbSelectArea("DT6")
								cObs := StrTran(MsMM((cAliasDT6)->DT6_CODMSG),Chr(13),"")
								If !Empty(cObs)
									cString +=  '<infAdFisco>' + NoAcentoCte(SubStr(cObs,1,320)) + '</infAdFisco>'
								EndIf
								cString += '</impComp>'
							EndIf
							(cAliasTagO)->(DbCloseArea())
						EndIf
						
						cString += '</infCteComp>'
						aAdd(aXMLCTe,AllTrim(cString))
					EndIf

					//�����������������������������������������������������������������Ŀ
					//� TAG: P - CT-e do Tipo Anulacao de Valores                       �
					//�������������������������������������������������������������������
					If AllTrim((cAliasDT6)->DT6_DOCTMS) == "M"
						//-- Query para pesquisar a chave do CTE original
						cAliasChv :=  GetNextAlias()
						cQuery := ''
						cQuery += " SELECT DT6.DT6_CHVCTE " +CRLF
						cQuery += "   FROM " + RetSqlName('DT6') + " DT6 " +CRLF
						cQuery += "  WHERE DT6.DT6_FILIAL = '" + xFilial('DT6') + "'" +CRLF
						cQuery += "    AND DT6.DT6_FILDOC = '" + (cAliasDT6)->DT6_FILDCO + "'" +CRLF
						cQuery += "    AND DT6.DT6_DOC    = '" + (cAliasDT6)->DT6_DOCDCO + "'" +CRLF
						cQuery += "    AND DT6.DT6_SERIE  = '" + (cAliasDT6)->DT6_SERDCO + "'" +CRLF
						cQuery += "    AND DT6.D_E_L_E_T_ = ' '"
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasChv, .F., .T.)
						cString := '<infCteAnu>'
						//-- Chave do Cte Original
						If (!(cAliasChv)->(Eof()))
							cString += '<chCte>' + (cAliasChv)->DT6_CHVCTE + '</chCte>'
						EndIf
						(cAliasChv)->(DbCloseArea())
						cString += '<dEmi>'+ SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 1, 4) + "-";
						+ SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 5, 2) + "-";
						+ SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 7, 2) + '</dEmi>'
						cString += '</infCteAnu>'
						aAdd(aXMLCTe,AllTrim(cString))
					EndIf
					//�����������������������������������������������������������������Ŀ
					//�Chave auxiliar para contigencia                                  �
					//�������������������������������������������������������������������
					If	cModalidade == '7'
						cAliasCTG := GetNextAlias()
						cQuery := " SELECT F4.F4_ICM,     " + CRLF
						cQuery += "        F4.F4_STDESC,  " + CRLF
						cQuery += "        DT6.DT6_VALTOT," + CRLF
						cQuery += "        DT6.DT6_DATEMI " + CRLF
						cQuery += "   FROM " + RetSqlName("SD2") + " D2," + RetSqlName("SF4") + " F4, "  + RetSqlName("DT6") + " DT6 "  + CRLF
						cQuery += "  WHERE D2.D2_FILIAL   = '" + xFilial('SD2') + "'" + CRLF
						cQuery += "    AND D2.D2_DOC      = '" + cNota    + "'" + CRLF
						cQuery += "    AND D2.D2_SERIE    = '" + cSerie   + "'" + CRLF
						cQuery += "    AND D2.D2_CLIENTE  = '" + cClieFor + "'" + CRLF
						cQuery += "    AND D2.D2_LOJA     = '" + cLoja    + "'" + CRLF
						cQuery += "    AND D2.D_E_L_E_T_  = ' '" + CRLF
						cQuery += "    AND F4.F4_FILIAL   = '" + xFilial('SF4') + "'" + CRLF
						cQuery += "    AND F4.F4_CODIGO   = D2.D2_TES" + CRLF
						cQuery += "    AND F4.D_E_L_E_T_  = ' '"
						cQuery += "    AND DT6.DT6_FILIAL = '" + xFilial('SF4') + "'" + CRLF
						cQuery += "    AND DT6.DT6_DOC    = '" + cNota   + "'" + CRLF
						cQuery += "    AND DT6.DT6_SERIE  = '" + cSerie  + "'" + CRLF
						cQuery += "    AND DT6.D_E_L_E_T_ = ' '"
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasCTG, .F., .T.)
						VALTOT:= padL(Alltrim(str(round(noround((cAliasCTG)->DT6_VALTOT,3),2)*100)),14,'0')
						cChvCTG := CTeCHCTG(	cCodUF,;
												cTpEmis,;
												AllTrim(SM0->M0_CGC),;
												VALTOT,;
												Iif((cAliasCTG)->F4_ICM <>'N', '1','2'),;
												Iif(!EMPTY((cAliasCTG)->F4_STDESC),'1','2'),;
												SubStr(AllTrim((cAliasCTG)->DT6_DATEMI), 7, 2))
						(cAliasCTG)->(dbCloseArea())
					Else
						cChvCTG := ""
					EndIf

					//�����������������������������������������������������������������Ŀ
					//� TAG Responsavel em Fechar os Dados do CTe                       �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//�                                                                 �
					//�������������������������������������������������������������������
					If Empty((cAliasDT6)->DT6_CHVCTE) .Or. ( cModalidade $ '5;7;8;9' .And. (cAliasDT6)->DT6_SITCTE <> '1'  )
						cQuery := " UPDATE " + RetSqlName("DT6") + CRLF
						cQuery += "    SET DT6_CHVCTE = '" + cChvAcesso + "' " + CRLF
						cQuery += "  WHERE DT6_FILIAL = '" + xFilial('DT6') + "'" + CRLF
						cQuery += "    AND DT6_FILDOC = '" + (cAliasDT6)->DT6_FILDOC + "' " + CRLF
						cQuery += "    AND DT6_DOC    = '" + (cAliasDT6)->DT6_DOC    + "' " + CRLF
						cQuery += "    AND DT6_SERIE  = '" + (cAliasDT6)->DT6_SERIE  + "' " + CRLF
						cQuery += "    AND D_E_L_E_T_ = ' ' "
						TCSqlExec( cQuery )
					EndIf

					//�����������������������������������������������������������������������������Ŀ
					//�  Variavel Private Responsavel Pela Grava��o da Chave de contingencia na DT6 �
					//�������������������������������������������������������������������������������
					If DT6->(FieldPos('DT6_CHVCTG')) > 0
						If !Empty(cChvCTG)
							cPChvCtg := cChvCTG
						EndIf
					EndIf

					(cAliasDT6)->(DbSkip())
				End // (02)
				
				cString := '</infCte>'
				aAdd(aXMLCTe,AllTrim(cString))
				
				//�����������������������������������������������������������������Ŀ
				//� Botton do Arquivo XML                                           �
				//�������������������������������������������������������������������
				cString := ''
				cString += '</CTe>'
				cString += '</infNFe>'
				
				aAdd(aXMLCTe,AllTrim(cString))
				
			EndIf // (01)
			
			cString := ''
			
			For nCount := 1 To Len(aXMLCTe)
				cString += AllTrim(aXMLCTe[nCount])
			Next nCount
		EndIf
	EndIf
Else //-- Entrada
	//������������������������������������������������������������������������Ŀ
	//�Posiciona NF                                                            �
	//��������������������������������������������������������������������������
	dbSelectArea("SF1")
	dbSetOrder(1)
	If MsSeek(xFilial("SF1")+cNota+cSerie+cClieFor+cLoja)
	
		DbSelectArea("SD1")
		DbSetOrder(1)
		MsSeek(xFilial("SD1")+cNota+cSerie+cClieFor+cLoja)
		
		//������������������������������������������������������������������������Ŀ
		//�Tratamento temporario do CTe                                            �
		//��������������������������������������������������������������������������
		If (lTMSCTe) .Or. (AModNot(SF2->F2_ESPECIE)=="57") .Or. (FunName()$"TMSA200" .Or. FunName()$"TMSA500")
			cAliasDT6 := "DT6_TMP"
			
			If (Select(cAliasDT6) > 0)
				(cAliasDT6)->(DbCloseArea())
			EndIf
			
			cQuery := " SELECT CTRC.DT6_FILDOC, " + CRLF
			cQuery += "        CTRC.DT6_FILORI, " + CRLF
			cQuery += "        CTRC.DT6_SERIE,  " + CRLF
			cQuery += "        CTRC.DT6_DOC,    " + CRLF
			cQuery += "        CTRC.DT6_DATEMI, " + CRLF
			cQuery += "        CTRC.DT6_HOREMI, " + CRLF
			cQuery += "        CTRC.DT6_DOCTMS, " + CRLF
			cQuery += "        CTRC.DT6_TIPTRA, " + CRLF
			cQuery += "        CTRC.DT6_FILIAL, " + CRLF
			cQuery += "        CTRC.DT6_FILDOC, " + CRLF
			cQuery += "        CTRC.DT6_CLIDEV, " + CRLF
			cQuery += "        CTRC.DT6_LOJDEV, " + CRLF
			cQuery += "        CTRC.DT6_CLIREM, " + CRLF
			cQuery += "        CTRC.DT6_LOJREM, " + CRLF
			cQuery += "        CTRC.DT6_CLIDES, " + CRLF
			cQuery += "        CTRC.DT6_LOJDES, " + CRLF
			cQuery += "        CTRC.DT6_CLICON, " + CRLF
			cQuery += "        CTRC.DT6_LOJCON, " + CRLF
			cQuery += "        CTRC.DT6_CLIDPC, " + CRLF
			cQuery += "        CTRC.DT6_LOJDPC, " + CRLF
			cQuery += "        CTRC.DT6_VALFRE, " + CRLF
			cQuery += "        CTRC.DT6_VALTOT, " + CRLF
			cQuery += "        CTRC.DT6_PRZENT, " + CRLF
			cQuery += "        CTRC.DT6_VOLORI, " + CRLF
			cQuery += "        CTRC.DT6_SERVIC, " + CRLF
			cQuery += "        CTRC.DT6_LOTNFC, " + CRLF
			cQuery += "        CTRC.DT6_VALMER, " + CRLF
			cQuery += "        CTRC.DT6_FILDCO, " + CRLF
			cQuery += "        CTRC.DT6_DOCDCO, " + CRLF
			cQuery += "        CTRC.DT6_SERDCO, " + CRLF
			cQuery += "        CTRC.DT6_CODMSG, " + CRLF
			cQuery += "        CTRC.DT6_CDRORI, " + CRLF
			cQuery += "        CTRC.DT6_CHVCTE, " + CRLF
			cQuery += "        CTRC.DT6_SITCTE, " + CRLF				

			cQuery += "        CLIREM.A1_CGC REM_CNPJ,			" + CRLF
			cQuery += "        CLIREM.A1_INSCR REM_INSC,		" + CRLF
			cQuery += "        CLIREM.A1_CONTRIB REM_CONTRIB,	" + CRLF
			cQuery += "        CLIREM.A1_NOME REM_NOME,			" + CRLF
			cQuery += "        CLIREM.A1_NREDUZ REM_NMEFANT,	" + CRLF
			cQuery += "        CLIREM.A1_DDD REM_DDDTEL,		" + CRLF
			cQuery += "        CLIREM.A1_TEL REM_TEL,			" + CRLF
			cQuery += "        CLIREM.A1_END REM_END,			" + CRLF
			cQuery += "        CLIREM.A1_BAIRRO REM_BAIRRO,		" + CRLF
			cQuery += "        CLIREM.A1_MUN REM_MUNICI,		" + CRLF
			cQuery += "        CLIREM.A1_CEP REM_CEP,			" + CRLF
			cQuery += "        CLIREM.A1_EST REM_UF,			" + CRLF
			cQuery += "        CLIREM.A1_PAIS REM_PAIS,			" + CRLF
			cQuery += "        CLIREM.A1_PESSOA REM_TPPESSOA,	" + CRLF
			cQuery += "        CLIREM.A1_SUFRAMA	REM_SUFRAMA," + CRLF
			cQuery += "        CLIREM.A1_COD_MUN REM_COD_MUN,	" + CRLF
			
			cQuery += "        CLIDES.A1_CGC DES_CNPJ,			" + CRLF
			cQuery += "        CLIDES.A1_INSCR DES_INSC,		" + CRLF
			cQuery += "        CLIDES.A1_CONTRIB DES_CONTRIB,	" + CRLF
			cQuery += "        CLIDES.A1_NOME DES_NOME,			" + CRLF
			cQuery += "        CLIDES.A1_DDD DES_DDDTEL,		" + CRLF
			cQuery += "        CLIDES.A1_TEL DES_TEL,			" + CRLF
			cQuery += "        CLIDES.A1_PESSOA DES_TPPESSOA, 	" + CRLF
			cQuery += "        CLIDES.A1_SUFRAMA	DES_SUFRAMA," + CRLF
			cQuery += "        CLIDES.A1_END DES_END,			" + CRLF
			cQuery += "        CLIDES.A1_BAIRRO DES_BAIRRO,		" + CRLF
			cQuery += "        CLIDES.A1_MUN DES_MUNICI,		" + CRLF
			cQuery += "        CLIDES.A1_CEP DES_CEP,			" + CRLF
			cQuery += "        CLIDES.A1_EST DES_UF,			" + CRLF
			cQuery += "        CLIDES.A1_PAIS DES_PAIS,			" + CRLF
			cQuery += "        CLIDES.A1_COD_MUN DES_COD_MUN,	" + CRLF
			
			cQuery += "        CLICON.A1_CGC CON_CNPJ,			" + CRLF
			cQuery += "        CLICON.A1_INSCR CON_INSC,		" + CRLF
			cQuery += "        CLICON.A1_CONTRIB CON_CONTRIB,	" + CRLF
			cQuery += "        CLICON.A1_NOME CON_NOME,			" + CRLF
			cQuery += "        CLICON.A1_DDD CON_DDDTEL,		" + CRLF
			cQuery += "        CLICON.A1_TEL CON_TEL,			" + CRLF
			cQuery += "        CLICON.A1_PESSOA CON_TPPESSOA,	" + CRLF
			cQuery += "        CLICON.A1_SUFRAMA	CON_SUFRAMA," + CRLF
			cQuery += "        CLICON.A1_END CON_END,			" + CRLF
			cQuery += "        CLICON.A1_BAIRRO CON_BAIRRO,		" + CRLF
			cQuery += "        CLICON.A1_MUN CON_MUNICI,		" + CRLF
			cQuery += "        CLICON.A1_CEP CON_CEP,			" + CRLF
			cQuery += "        CLICON.A1_EST CON_UF,			" + CRLF
			cQuery += "        CLICON.A1_PAIS CON_PAIS, 		" + CRLF
			cQuery += "        CLICON.A1_COD_MUN CON_COD_MUN,	" + CRLF
			
			cQuery += "        CLIDPC.A1_CGC DPC_CNPJ,			" + CRLF
			cQuery += "        CLIDPC.A1_INSCR DPC_INSC,		" + CRLF
			cQuery += "        CLIDPC.A1_CONTRIB DPC_CONTRIB,	" + CRLF
			cQuery += "        CLIDPC.A1_NOME DPC_NOME,			" + CRLF
			cQuery += "        CLIDPC.A1_DDD DPC_DDDTEL,		" + CRLF
			cQuery += "        CLIDPC.A1_TEL DPC_TEL,			" + CRLF
			cQuery += "        CLIDPC.A1_PESSOA DPC_TPPESSOA,	" + CRLF
			cQuery += "        CLIDPC.A1_SUFRAMA DPC_SUFRAMA,	" + CRLF
			cQuery += "        CLIDPC.A1_END DPC_END,			" + CRLF
			cQuery += "        CLIDPC.A1_BAIRRO DPC_BAIRRO,		" + CRLF
			cQuery += "        CLIDPC.A1_MUN DPC_MUNICI,		" + CRLF
			cQuery += "        CLIDPC.A1_CEP DPC_CEP,			" + CRLF
			cQuery += "        CLIDPC.A1_EST DPC_UF,			" + CRLF
			cQuery += "        CLIDPC.A1_PAIS DPC_PAIS,			" + CRLF
			cQuery += "        CLIDPC.A1_COD_MUN DPC_COD_MUN	" + CRLF
			
			cQuery += "   FROM " + RetSqlName('DT6') + " CTRC " + CRLF
			cQuery += "        INNER JOIN " + RetSqlName('SA1') + " CLIREM  ON (CLIREM.A1_COD = CTRC.DT6_CLIREM AND CLIREM.A1_LOJA = CTRC.DT6_LOJREM   ) " + CRLF
			cQuery += "        INNER JOIN " + RetSqlName('SA1') + " CLIDES  ON (CLIDES.A1_COD = CTRC.DT6_CLIDES AND CLIDES.A1_LOJA = CTRC.DT6_LOJDES   ) " + CRLF
			cQuery += "        LEFT  JOIN " + RetSqlName('SA1') + " CLICON  ON (CLICON.A1_FILIAL = '" + xFilial('SA1') + "' AND CLICON.A1_COD = CTRC.DT6_CLICON AND CLICON.A1_LOJA = CTRC.DT6_LOJCON AND CLICON.D_E_L_E_T_ = ' ' ) " + CRLF
			cQuery += "        LEFT  JOIN " + RetSqlName('SA1') + " CLIDPC  ON (CLIDPC.A1_FILIAL = '" + xFilial('SA1') + "' AND CLIDPC.A1_COD = CTRC.DT6_CLIDPC AND CLIDPC.A1_LOJA = CTRC.DT6_LOJDPC AND CLIDPC.D_E_L_E_T_ = ' ' ) " + CRLF
			
			cQuery += "  WHERE CTRC.DT6_FILIAL   = '" + xFilial('DT6') + "'" + CRLF
			cQuery += "    	AND CTRC.DT6_FILDOC   = '" + cFilAnt + "'" + CRLF
			cQuery += "    	AND CTRC.DT6_DOC      = '" + SD1->D1_NFORI + "'" + CRLF
			cQuery += "    	AND CTRC.DT6_SERIE    = '" + SD1->D1_SERIORI + "'" + CRLF
			cQuery += "    	AND CTRC.D_E_L_E_T_   = ' '" + CRLF
			
			cQuery += "		AND CLIREM.A1_FILIAL  = '" + xFilial('SA1') + "'" + CRLF
			cQuery += "		AND CLIREM.D_E_L_E_T_ = ' '" + CRLF
			
			cQuery += "		AND CLIDES.A1_FILIAL  = '" + xFilial('SA1') + "'" + CRLF
			cQuery += "		AND CLIDES.D_E_L_E_T_ = ' '"
			
			cQuery += "  ORDER BY CTRC.DT6_FILDOC, " + CRLF
			cQuery += "           CTRC.DT6_DOC,    " + CRLF
			cQuery += "           CTRC.DT6_SERIE   "
			
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasDT6, .F., .T.)
			(cAliasDT6)->(DbGoTop())
			If (!(cAliasDT6)->(Eof())) // (01)
				//�����������������������������������������������������������������Ŀ
				//� Header do Arquivo XML                                           �
				//�������������������������������������������������������������������
				cString := '<infNFe versao="T02.00" modelo="57">'
				cString += '<CTe xmlns="http://www.portalfiscal.inf.br/cte">'


				aAdd(aXMLCTe,AllTrim(cString))

				While !(cAliasDT6)->(Eof()) // (02)
					//-- Confere se Uf do Emitente esta OK
					If aScan(aUF,{|x| x[1] ==  AllTrim(SM0->M0_ESTENT) }) != 0
						cCodUF := aUF[ aScan(aUF,{|x| x[1] == AllTrim(SM0->M0_ESTENT) }), 2]
					Else
						cCodUF := ''
					EndIf
					//-- Confere se Uf do Remetente esta OK
					If aScan(aUF,{|x| x[1] == (cAliasDT6)->REM_UF }) != 0
						cCodUFRem  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT6)->REM_UF }), 2]
					Else
						cCodUFRem  := ''
					EndIf
					//-- Confere se Uf do Destinatario esta OK
					If aScan(aUF,{|x| x[1] == (cAliasDT6)->DES_UF }) != 0
						cCodUFDes  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT6)->DES_UF }), 2]
					Else
						cCodUFDes := ''
					EndIf
					//-- Confere se Uf do Consignatario esta OK
					If !Empty((cAliasDT6)->CON_UF)
						If (aScan(aUF,{|x| x[1] == (cAliasDT6)->CON_UF }) != 0)
							cCodUFCon  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT6)->CON_UF }), 2]
						Else
							cCodUFCon := ''
						EndIF
					EndIf
					//-- Confere se Uf do Despachante esta OK
					If !Empty((cAliasDT6)->DPC_UF)
						If (aScan(aUF,{|x| x[1] == (cAliasDT6)->DPC_UF }) != 0)
							cCodUFDpc  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT6)->DPC_UF }), 2]
						Else
							cCodUFDpc  := ''
						EndIf
					EndIf
					//--
					cMail   := Posicione('SA1',1,xFilial('SA1')+cClieFor+cLoja,'A1_EMAIL')
					cDTCObs := "Este documento esta vinculado ao documento fiscal numero " + AllTrim(SD1->D1_NFORI) + " serie " + AllTrim(SD1->D1_SERIORI) + " da data " + DToC(SToD((cAliasDT6)->DT6_DATEMI)) + " em virtude de "
					cDTCObs += NoAcentoCte(SF1->F1_MENNOTA)
					//--
					dbSelectArea("SF3")
					SF3->(DbSetOrder(4))
					If SF3->(DbSeek(xFilial("SF3")+cClieFor+cLoja+cNota+cSerie))
						cCFOP := SF3->F3_CFO
					EndIf
					//�����������������������������������������������������������������Ŀ
					//� Gerar Chave de Acesso do CT-e                                   �
					//�������������������������������������������������������������������
					nSerieCTe := Val(AllTrim(cSerie))

					//�����������������������������������������������������������������Ŀ
					//� Formato de Impressao do CT-e                                    �
					//� 1 - Normal                                                      �
					//� 2 - Contingencia                                                �
					//�������������������������������������������������������������������
					If (cModalidade == '1')
						cTpEmis := '1'
					Else
						cTpEmis := '2'
					EndIf

					cCT := Inverte(StrZero(Val(PadR(cNota,8)), 8))
										
					//�����������������������������������������������������������������Ŀ
					//� Voltar rotina abaixo                                            �
					//�������������������������������������������������������������������
					cChvAcesso := CTeCHVAC(	cCodUF,;
											( SubStr(DToS(SF1->F1_EMISSAO), 3, 2) + SubStr(DToS(SF1->F1_EMISSAO), 5, 2) ),;
											AllTrim(SM0->M0_CGC),;
											'57',;
											StrZero(nSerieCTe, 3),;
											StrZero(Val(PadR(cNota,9)), 9),;
											cTpEmis + cCT)

					//�����������������������������������������������������������������Ŀ
					//� Inicio dos Dados do CTe                                         �
					//�������������������������������������������������������������������
					cNFe    := 'CTe' + AllTrim(cChvAcesso)

					//�����������������������������������������������������������������Ŀ
					//� Versao do Ct-e, de acordo com o parametro                       �
					//�������������������������������������������������������������������
					cString := '<infCte Id="CTe' + AllTrim(cChvAcesso) + '" versao="' + cVerAmb + '">'

					aAdd(aXMLCTe,AllTrim(cString))
					
					//�����������������������������������������������������������������Ŀ
					//� TAG: B - IdentIfica��o do Conhecimento de Transporte Eletronico �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� CFOP - Natureza da Prestacao                                    �
					//�������������������������������������������������������������������
					cAliasD2 := GetNextAlias()
					cQuery := " SELECT SX5.X5_DESCRI" + CRLF
					cQuery += "   FROM " +	RetSqlName("SX5") + " SX5 " + CRLF
					cQuery += "  WHERE SX5.X5_FILIAL ='"  + xFilial("SX5") + "'" + CRLF
					cQuery += "    AND SX5.X5_TABELA = '13'" + CRLF
					cQuery += "    AND SX5.X5_CHAVE  = '" + cCFOP + "'" + CRLF
					cQuery += "    AND SX5.D_E_L_E_T_= ' '"
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasD2, .F., .T.)
					If !(cAliasD2)->(Eof())
						cNatOper := SubStr(AllTrim((cAliasD2)->X5_DESCRI),1,55)
					EndIf
					(cAliasD2)->(DbCloseArea())

					cString :=	'<ide>'
					cString +=	'<cUF>'		+ NoAcentoCte( cCodUF	) + '</cUF>'
					cString +=	'<cCT>'		+ NoAcentoCte( cCT 		) + '</cCT>'
					cString +=	'<CFOP>'	+ NoAcentoCte( cCFOP 	) + '</CFOP>'
					cString +=	'<natOp>'	+ NoAcentoCte( cNatOper	) + '</natOp>'

					//�����������������������������������������������������������������Ŀ
					//� Forma de Pagamento do Servico                                   �
					//� 0 - Pago / 1 - A pagar / 2 - Outros                             �
					//�������������������������������������������������������������������
					If (((cAliasDT6)->DT6_CLIREM = (cAliasDT6)->DT6_CLIDEV) .and.;
						((cAliasDT6)->DT6_LOJREM = (cAliasDT6)->DT6_LOJDEV))
						cString += '<forPag>0</forPag>'
					ElseIf (((cAliasDT6)->DT6_CLIDES = (cAliasDT6)->DT6_CLIDEV) .and.;
						((cAliasDT6)->DT6_LOJDES = (cAliasDT6)->DT6_LOJDEV) )
						cString += '<forPag>1</forPag>'
					Else
						cString += '<forPag>2</forPag>'
					EndIf

					//�����������������������������������������������������������������Ŀ
					//�                                                                 �
					//�                                                                 �
					//�������������������������������������������������������������������
					cString += '<mod>' 	+ "57" + '</mod>'
					cString += '<serie>'+ NoAcentoCte(cValtoChar(nSerieCTe)) + '</serie>'
					cString += '<nCT>'	+ NoAcentoCte(cValtoChar(Val(AllTrim(SF1->F1_DOC)))) + '</nCT>'

					//�����������������������������������������������������������������Ŀ
					//�Data e hora de emiss�o                                           �
					//�Formato = AAAA-MM-DDTHH:MM:SS                                    �
					//�Preenchido com data e hora de emiss�o.                           �
					//�������������������������������������������������������������������
					cString += '<dhEmi>'+ SubStr(DToS(SF1->F1_EMISSAO), 1, 4) + "-";
										+ SubStr(DToS(SF1->F1_EMISSAO), 5, 2) + "-";
										+ SubStr(DToS(SF1->F1_EMISSAO), 7, 2) + "T";
										+ SubStr(AllTrim(Time()), 1, 2) + ":";
										+ SubStr(AllTrim(Time()), 4, 2) + ':00</dhEmi>'

					//�����������������������������������������������������������������Ŀ
					//� Formato de Impressao do DACTE                                   �
					//� 1 - Retrato                                                     �
					//� 2 - Paisagem                                                    �
					//�������������������������������������������������������������������
					cString += '<tpImp>1</tpImp>'

					//�����������������������������������������������������������������Ŀ
					//� Formato de Impressao do CT-e                                    �
					//� 1 - Normal                                                      �
					//� 2 - Contingencia                                                �
					//�������������������������������������������������������������������
					If (cModalidade == '1')
						cString += '<tpEmis>1</tpEmis>'
					Else
						cString += '<tpEmis>2</tpEmis>'
					EndIf

					cString += '<cDV>' + SubStr( AllTrim(cChvAcesso), Len( AllTrim(cChvAcesso) ), 1) + '</cDV>'

					//�����������������������������������������������������������������Ŀ
					//� Identificacao do Ambiente.                                      �
					//� 1 - Producao                                                    �
					//� 2 - Homologacao                                                 �
					//�������������������������������������������������������������������
					cString += '<tpAmb>' + cAmbiente + '</tpAmb>'

					//�����������������������������������������������������������������Ŀ
					//� Tipo de Conhecimento                                            �
					//� 0 - Normal                                                      �
					//� 1 - Complemento de Valores                                      �
					//� 2 - Emitido em Hipotese de anulacao de Debito                   �
					//�������������������������������������������������������������������
					cString += '<tpCTe>2</tpCTe>'

					//�����������������������������������������������������������������Ŀ
					//� Processo de Emissao do CT-e                                     �
					//� 0 - emissao com aplicativo do contribuinte                      �
					//� 1 - avulsa pelo fisco                                           �
					//� 2 - avulsa pelo contrinbuinte com seu certificado digital,      �
					//�     atraves do site do Fisco                                    �
					//� 3 - pelo contribuinte com aplicativo fornecido pelo Fisco       �
					//�������������������������������������������������������������������
					cString += '<procEmi>0</procEmi>'

					//�����������������������������������������������������������������Ŀ
					//�                                                                 �
					//�������������������������������������������������������������������
					cString += '<verProc>' + cVerAmb + '</verProc>'
					cString += '<cMunEnv>' + NoAcentoCte( SM0->M0_CODMUN ) + '</cMunEnv>'
					cString += '<xMunEnv>' + NoAcentoCte( SM0->M0_CIDENT ) + '</xMunEnv>'
					cString += '<UFEnv>'   + NoAcentoCte( SM0->M0_ESTENT ) + '</UFEnv>'
					//�����������������������������������������������������������������Ŀ
					//� Modal                                                           �
					//� 01 - Rodoviario;                                                �
					//� 02 - Aereo;                                                     �
					//� 03 - Aquaviario;                                                �
					//� 04 - Ferroviario;                                               �
					//� 05 - Dutoviario.                                                �
					//�������������������������������������������������������������������
					cString += '<modal>' + StrZero(Val(AllTrim((cAliasDT6)->DT6_TIPTRA)), 2) + '</modal>'
					
					//�����������������������������������������������������������������Ŀ
					//� Tipo de Servico                                                 �
					//� 0 - Normal                                                      �
					//� 1 - SubContratacao                                              �
					//� 2 - Redespacho                                                  �
					//� 3 - Redespacho Intermediario                                    �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� DTC - Notas Fiscais: (Informacao do campo DTC_TIPNFC)           �
					//�	0 - Normal                                                      �
					//�	1 - Devolucao                                                   �
					//�	2 - SubContratacao                                              �
					//�	3 - Dcto Nao Fiscal                                             �
					//�	4 - Redespacho                                                  �
					//� 5 - Redespacho                                                  �
					//� 6 - Dcto Nao Fiscal 1                                           �
					//� 7 - Dcto Nao Fiscal 2                                           �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� Seleciona as informacoes do produto, baseado na DTC             �
					//� Pega o produto com maior valor de mercadoria, definido como     �
					//� o produto predominante                                          �
					//�������������������������������������������������������������������
					cAliasAll := GetNextAlias()
					cQuery := " SELECT MAX(DTC.DTC_VALOR),	" + CRLF
					cQuery += " 		 DTC.DTC_TIPNFC,	" + CRLF
					cQuery += " 		 DTC.DTC_CODOBS,	" + CRLF
					cQuery += " 		 DTC.DTC_CTRDPC,	" + CRLF
					cQuery += " 		 DTC.DTC_SERDPC,	" + CRLF
					cQuery += " 		 DTC.DTC_TIPANT,	" + CRLF
					cQuery += " 		 DTC.DTC_DPCEMI,	" + CRLF
					cQuery += " 		 DTC.DTC_CTEANT,	" + CRLF
					cQuery += " 		 DTC.DTC_SELORI,	" + CRLF
					cQuery += " 		 DTC.DTC_SQEDES,	" + CRLF
					cQuery += " 		 DTC.DTC_FILORI,	" + CRLF
					cQuery += " 		 DTC.DTC_NUMSOL,	" + CRLF
					cQuery += " 		 DV3.DV3_INSCR,		" + CRLF
					cQuery += " 		 SB1.B1_DESC, 		" + CRLF
					cQuery += " 		 SB1.B1_COD, 		" + CRLF
					cQuery += " 		 SB1.B1_UM			" + CRLF
					cQuery += "   FROM " + RetSqlName('DTC') + " DTC " + CRLF
					//-- Cadastro de Produtos
					cQuery += " 		INNER JOIN " + RetSqlName('SB1') + " SB1 " + CRLF
					cQuery += "                     ON (SB1.B1_COD = DTC.DTC_CODPRO " + CRLF
					cQuery += "                    AND  SB1.B1_FILIAL  = '" + xFilial("SB1") + "'" + CRLF
					cQuery += "                    AND  SB1.D_E_L_E_T_ = ' ') "
					//-- Inscricoes Estaduais Clientes
					cQuery += " 		 LEFT JOIN " + RetSqlName('DV3') + " DV3 " + CRLF
					cQuery += "					  ON (DV3.DV3_FILIAL = '" + xFilial("DV3") + "'"  + CRLF
					cQuery += "					 AND DV3.DV3_CODCLI = DTC.DTC_CLIREM " + CRLF
					cQuery += "					 AND DV3.DV3_LOJCLI = DTC.DTC_LOJREM " + CRLF
					cQuery += "					 AND DV3.DV3_SEQUEN = DTC.DTC_SQIREM " + CRLF
					cQuery += "					 AND DV3.D_E_L_E_T_ = ' ') " + CRLF
					cQuery += "  WHERE DTC.DTC_FILIAL = '" + xFilial('DTC') + "'" + CRLF
					//�����������������������������������������������������������������Ŀ
					//� Tipo de Conhecimento de Anulacao, seleciona as                  �
					//� informacoes do CTE principal, pois nao tem DTC                  �
					//�������������������������������������������������������������������
					If !Empty((cAliasDT6)->DT6_DOCDCO)
						cQuery += "    AND DTC.DTC_FILDOC  = '" + (cAliasDT6)->DT6_FILDCO + "'" + CRLF
						cQuery += "    AND DTC.DTC_DOC     = '" + (cAliasDT6)->DT6_DOCDCO + "'" + CRLF
						cQuery += "    AND DTC.DTC_SERIE   = '" + (cAliasDT6)->DT6_SERDCO + "'" + CRLF
					Else
						cQuery += "    AND DTC.DTC_FILDOC  = '" + (cAliasDT6)->DT6_FILDOC + "'" + CRLF
						cQuery += "    AND DTC.DTC_DOC     = '" + (cAliasDT6)->DT6_DOC    + "'" + CRLF
						cQuery += "    AND DTC.DTC_SERIE   = '" + (cAliasDT6)->DT6_SERIE  + "'" + CRLF
					EndIf
					cQuery += " AND DTC.D_E_L_E_T_   = ' '" + CRLF
					cQuery += " GROUP BY DV3.DV3_INSCR, DTC.DTC_TIPNFC,DTC.DTC_CODOBS, DTC.DTC_CTRDPC, DTC.DTC_SERDPC, DTC.DTC_TIPANT, "+ CRLF
					cQuery += "          DTC.DTC_DPCEMI, DTC.DTC_CTEANT, DTC.DTC_SELORI, DTC.DTC_SQEDES, DTC.DTC_FILORI, DTC.DTC_NUMSOL, SB1.B1_DESC, SB1.B1_COD , SB1.B1_UM " + CRLF
					cQuery += " ORDER BY MAX(DTC.DTC_VALOR) DESC" + CRLF
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasAll, .F., .T.)
					If (!(cAliasAll)->(Eof()))					
						cCtrDpc    := NoAcentoCte( (cAliasALL)->DTC_CTRDPC )
						cSerDpc    := NoAcentoCte( (cAliasALL)->DTC_SERDPC )
						cTpDocAnt  := NoAcentoCte( (cAliasALL)->DTC_TIPANT )
						cDtEmi     := SubStr(AllTrim((cAliasALL)->DTC_DPCEMI), 1, 4) + "-";
									+ SubStr(AllTrim((cAliasALL)->DTC_DPCEMI), 5, 2) + "-";
									+ SubStr(AllTrim((cAliasALL)->DTC_DPCEMI), 7, 2)
						cCTEDocAnt := NoAcentoCte( (cAliasALL)->DTC_CTEANT)
						cTipoNF    := NoAcentoCte( (cAliasAll)->DTC_TIPNFC )
						cSelOri    := (cAliasAll)->( DTC_SELORI )
						cSeqEntr   := (cAliasAll)->( DTC_SQEDES )
						cFilOri    := (cAliasAll)->( DTC_FILORI )
						cNumSol    := (cAliasAll)->( DTC_NUMSOL )
						If !Empty((cAliasAll)->DV3_INSCR)
							cInsRemOpc := NoPontos((cAliasALL)->DV3_INSCR)
						EndIf
						cProdPred 	:= NoAcentoCte( (cAliasAll)->B1_DESC )
						cCodPred	:= NoAcentoCte( (cAliasAll)->B1_COD )
						aCarga[5] 	:= NoAcentoCte( (cAliasAll)->B1_UM )
					EndIf
					(cAliasAll)->(DbCloseArea())

					If cTipoNF $ '0,1,3,4,6,7'
						cString   += '<tpServ>0</tpServ>'
					ElseIf cTipoNF == '2'
						cString   += '<tpServ>1</tpServ>'
					ElseIf cTipoNF == '5'
						cString   += '<tpServ>2</tpServ>'
					EndIf
					
					//�����������������������������������������������������������������Ŀ
					//� Municipio inicio e termino da prestacao                         �
					//�������������������������������������������������������������������
					
					If cSelOri == StrZero(1,Len(DTC->DTC_SELORI))   //Transportadora
						DUY->(DbSetOrder(1))
						If DUY->(MsSeek(xFilial("DUY")+(cAliasDT6)->DT6_CDRORI))
							If (aScan(aUF,{|x| x[1] == DUY->DUY_EST }) != 0)
								cCodUFOri := aUF[ aScan(aUF,{|x| x[1] == DUY->DUY_EST }), 2]
							Else
								cCodUFOri := ''
							EndIf
							cString += '<cMunIni>' + NoAcentoCte( AllTrim(cCodUFOri ) +  Alltrim( DUY->DUY_CODMUN ) )  + '</cMunIni>'
							cString += '<xMunIni>' + NoAcentoCte( Posicione('CC2',1,xFilial("CC2")+ DUY->DUY_EST + DUY->DUY_CODMUN,"CC2_MUN") ) + '</xMunIni>'
							cString += '<UFIni>'   + NoAcentoCte( DUY->DUY_EST ) + '</UFIni>'
						EndIf
					ElseIf cSelOri == StrZero(2,Len(DTC->DTC_SELORI))   //Remetente
						cString += '<cMunIni>' + NoAcentoCte( AllTrim(cCodUFRem ) +  Alltrim((cAliasDT6)->(REM_COD_MUN)) )  + '</cMunIni>'
						cString += '<xMunIni>' + NoAcentoCte( (cAliasDT6)->(REM_MUNICI) ) + '</xMunIni>'
						cString += '<UFIni>'   + NoAcentoCte( (cAliasDT6)->(REM_UF) ) + '</UFIni>'  
					ElseIf cSelOri == StrZero(3,Len(DTC->DTC_SELORI))   //Coleta
						cAliasDT5:= GetNextAlias()
						cQuery := " SELECT DUE_MUN, DUE_CODMUN, DUE_EST, DUL_MUN, DUL_CODMUN, DUL_EST "
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
						cQuery += "    AND DT5_FILORI = '" + cFilOri + "' "
						cQuery += "    AND DT5_NUMSOL = '" + cNumSol + "' "
						cQuery += "    AND DT5.D_E_L_E_T_ = ' ' "
						cQuery := ChangeQuery(cQuery)
						DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDT5,.T.,.T.)
						If !(cAliasDT5)->(Eof())
							//-- Endereco do Solicitante
							If !Empty((cAliasDT5)->DUL_CODMUN)
								If aScan(aUF,{|x| x[1] == (cAliasDT5)->DUL_EST }) != 0   //Confere se Uf do End.Solicitante esta OK
							  		cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT5)->DUL_EST }), 2]
								Else
									cCodUFOri  := ''
								EndIf     
								cString += '<cMunIni>' + NoAcentoCte( AllTrim(cCodUFOri) + Alltrim((cAliasDT5)->(DUL_CODMUN)) )  + '</cMunIni>'
								cString += '<xMunIni>' + NoAcentoCte( (cAliasDT5)->(DUL_MUN) ) + '</xMunIni>'
								cString += '<UFIni>'   + NoAcentoCte( (cAliasDT5)->(DUL_EST) ) + '</UFIni>'
							Else                        
								//-- Solicitante
								If aScan(aUF,{|x| x[1] == (cAliasDT5)->DUE_EST }) != 0   //Confere se Uf do Solicitante esta OK
							  		cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT5)->DUE_EST }), 2]
								Else
									cCodUFOri  := ''
								EndIf              
								cString += '<cMunIni>' + NoAcentoCte( AllTrim(cCodUFOri) +  Alltrim((cAliasDT5)->(DUE_CODMUN)) )  + '</cMunIni>'
								cString += '<xMunIni>' + NoAcentoCte( (cAliasDT5)->(DUE_MUN) ) + '</xMunIni>'
								cString += '<UFIni>'   + NoAcentoCte( (cAliasDT5)->(DUE_EST) ) + '</UFIni>'
							EndIf	
						EndIf
						(cAliasDT5)->(DbCloseArea())
					EndIf	
					
					If !Empty(cSeqEntr)
						DUL->(DbSetOrder(2))
						If DUL->(MsSeek(xFilial('DUL')+(cAliasDT6)->DT6_CLIDES + (cAliasDT6)->DT6_LOJDES + cSeqEntr ))
							If aScan(aUF,{|x| x[1] == DUL->DUL_EST }) != 0
								cUfEnt := aUF[ aScan(aUF,{|x| x[1] == DUL->DUL_EST }), 2]
							Else
								cUfEnt := ''
							EndIf
							cString += '<cMunFim>'	+ NoAcentoCte( AllTrim(cUfEnt) + AllTrim(DUL->DUL_CODMUN) )	+ '</cMunFim>'
							cString += '<xMunFim>'	+ NoAcentoCte( DUL->DUL_MUN )	+ '</xMunFim>'
							cString += '<UFFim>'	+ NoAcentoCte( DUL->DUL_EST )	+ '</UFFim>'
						EndIf
					Else
						cString += '<cMunFim>'	+ NoAcentoCte( AllTrim(cCodUFDes ) + AllTrim((cAliasDT6)->DES_COD_MUN ) ) + '</cMunFim>'
						cString += '<xMunFim>'	+ NoAcentoCte( (cAliasDT6)->DES_MUNICI ) + '</xMunFim>'
						cString += '<UFFim>'	+ NoAcentoCte( (cAliasDT6)->DES_UF ) + '</UFFim>'
					EndIf
					
					//�����������������������������������������������������������������Ŀ
					//� Recebedor retira no aeroporto,filial, porto ou Estacao Destino? �
					//� 0 - SIM / 1 - NAO                                               �
					//�������������������������������������������������������������������
					cString += '<retira>0</retira>'
					cString += '<xDetRetira>NAO SE APLICA</xDetRetira>'
					
					If	( Empty((cAliasDT6)->DT6_CLICON) .And. Empty((cAliasDT6)->DT6_CLIDPC) ) .Or. ;
						(!Empty((cAliasDT6)->DT6_CLIDPC) .And. ( (cAliasDT6)->DT6_CLIDPC+(cAliasDT6)->DT6_LOJDPC <> (cAliasDT6)->DT6_CLIDEV+(cAliasDT6)->DT6_LOJDEV ))

						cString += '<toma03>'

						//����������������������������Ŀ
						//� Tomador do Servico         �
						//� 0 - Remetente;             �
						//� 1 - Expedidor;             �
						//� 2 - Recebedor;             �
						//� 3 - Destinatario.          �
						//������������������������������
						If (((cAliasDT6)->DT6_CLIREM = (cAliasDT6)->DT6_CLIDEV) .And.;
							((cAliasDT6)->DT6_LOJREM = (cAliasDT6)->DT6_LOJDEV))
							cCNPJToma := AllTrim((cAliasDT6)->REM_CNPJ)
							cString   += '<toma>0</toma>'
						ElseIf (((cAliasDT6)->DT6_CLIDES = (cAliasDT6)->DT6_CLIDEV) .And.;
								((cAliasDT6)->DT6_LOJDES = (cAliasDT6)->DT6_LOJDEV))
							cCNPJToma := AllTrim((cAliasDT6)->DES_CNPJ)
							cString   += '<toma>3</toma>'
						Else
							cString += '<toma>1</toma>'
						EndIf
						cString += '</toma03>'

					ElseIf (((cAliasDT6)->DT6_CLICON = (cAliasDT6)->DT6_CLIDEV) .And.;
							((cAliasDT6)->DT6_LOJCON = (cAliasDT6)->DT6_LOJDEV))

						cCNPJToma := AllTrim((cAliasDT6)->CON_CNPJ)

						cString += '<toma4>'
						
						//��������������������������������������Ŀ
						//� Tomador do Servico Consignatario     �
						//� 4 - Outros;                          �
						//����������������������������������������
						cString += '<toma>4</toma>'

						If (AllTrim((cAliasDT6)->CON_TPPESSOA) == "J")
							cString += '<CNPJ>' + AllTrim((cAliasDT6)->CON_CNPJ) + '</CNPJ>'
						Else
							cString += '<CPF>'  + AllTrim((cAliasDT6)->CON_CNPJ) + '</CPF>'
						EndIf
						If Empty((cAliasDT6)->CON_INSC) .Or. "ISENT" $ Upper(AllTrim((cAliasDT6)->CON_INSC))
							cString += '<IE>ISENTO</IE>'
						Else
							cString += '<IE>' + NoPontos((cAliasDT6)->CON_INSC) + '</IE>'
						EndIf

						cString += '<xNome>' + NoAcentoCte(SubStr((cAliasDT6)->CON_NOME,1,60)) + '</xNome>'
						If  !Empty(NoPontos((cAliasDT6)->CON_TEL))
							cString += '<fone>'  +  cValtoChar(NoPontos((cAliasDT6)->CON_DDDTEL)) +;
							cValtoChar(NoPontos((cAliasDT6)->CON_TEL)) + '</fone>'
						EndIf
						cString += '<enderToma>'
						cString += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasDT6)->CON_END)[1]) + '</xLgr>'
						cString += '<nro>'  + Iif(FisGetEnd((cAliasDT6)->CON_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasDT6)->CON_END)[2])),"S/N") + '</nro>'
						
						If !Empty(NoAcentoCte(FisGetEnd((cAliasDT6)->CON_END)[4]))
							cString += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasDT6)->CON_END)[4]) + '</xCpl>'
						EndIf
						
						If Empty(AllTrim((cAliasDT6)->CON_BAIRRO))
							cString += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
						Else
							cString += '<xBairro>' +NoAcentoCte( (cAliasDT6)->CON_BAIRRO ) + '</xBairro>'
						EndIf
						
						cString += '<cMun>' + NoAcentoCte( AllTrim(cCodUFCon)         + AllTrim((cAliasDT6)->CON_COD_MUN) ) + '</cMun>'
						cString += '<xMun>' + NoAcentoCte( (cAliasDT6)->CON_MUNICI ) + '</xMun>'
						cString += '<CEP>'  + NoAcentoCte( (cAliasDT6)->CON_CEP )    + '</CEP>'
						cString += '<UF>'   + NoAcentoCte( (cAliasDT6)->CON_UF )     + '</UF>'
						cString += '</enderToma>'
						cString += '</toma4>'
						
					ElseIf (((cAliasDT6)->DT6_CLIDPC = (cAliasDT6)->DT6_CLIDEV) .And.;
							((cAliasDT6)->DT6_LOJDPC = (cAliasDT6)->DT6_LOJDEV))
						
						cCNPJToma := AllTrim((cAliasDT6)->DPC_CNPJ)
						
						cString += '<toma4>'
						
						//��������������������������������������Ŀ
						//� Tomador do Servico Despachante       �
						//� 4 - Outros;                          �
						//����������������������������������������
						cString += '<toma>4</toma>'
						If (AllTrim((cAliasDT6)->DPC_TPPESSOA) == "J")
							cString += '<CNPJ>' + NoAcentoCte( (cAliasDT6)->DPC_CNPJ ) + '</CNPJ>'
						Else
							cString += '<CPF>'  + NoAcentoCte( (cAliasDT6)->DPC_CNPJ ) + '</CPF>'
						EndIf
						If Empty((cAliasDT6)->DPC_INSC) .Or. 'ISENT' $ Upper(AllTrim((cAliasDT6)->DPC_INSC)) .Or. ((cAliasDT6)->DPC_CONTRIB =='1' .And. 'ISENT' $ Upper(AllTrim((cAliasDT6)->DPC_INSC)))
							cString += '<IE>ISENTO</IE>'
						Else
							cString += '<IE>' + NoPontos((cAliasDT6)->DPC_INSC) + '</IE>'
						EndIf

						cString += '<xNome>' + NoAcentoCte(SubStr((cAliasDT6)->DPC_NOME,1,60)) + '</xNome>'
						cString += '<enderToma>'
						cString += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasDT6)->DPC_END)[1]) + '</xLgr>'
						cString += '<nro>' + Iif(FisGetEnd((cAliasDT6)->DPC_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasDT6)->DPC_END)[2])),"S/N") + '</nro>'
						If !Empty(NoAcentoCte(FisGetEnd((cAliasDT6)->DPC_END)[4]))
							cString += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasDT6)->DPC_END)[4]) + '</xCpl>'
						EndIf
						If Empty(AllTrim((cAliasDT6)->DPC_BAIRRO))
							cString += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
						Else
							cString += '<xBairro>' + NoAcentoCte( (cAliasDT6)->DPC_BAIRRO ) + '</xBairro>'
						EndIf
						cString += '<cMun>' + NoAcentoCte( AllTrim(cCodUFDpc) + Alltrim((cAliasDT6)->DPC_COD_MUN) ) + '</cMun>'
						cString += '<xMun>' + NoAcentoCte( (cAliasDT6)->DPC_MUNICI ) + '</xMun>'
						cString += '<CEP>'  + NoAcentoCte( (cAliasDT6)->DPC_CEP )    + '</CEP>'
						cString += '<UF>'   + NoAcentoCte( (cAliasDT6)->DPC_UF )     + '</UF>'
						cString += '</enderToma>'
						cString += '</toma4>'
					EndIf
					cString += '</ide>'
					
					aAdd(aXMLCTe,AllTrim(cString))
					
					//������������������������������������������������������������������Ŀ
					//� TAG: Dados complementares do CT-e para fins operacionais ou      �
					//� comerciaisEmitente do CT-e                                       �
					//��������������������������������������������������������������������
					If !Empty(cDTCObs)
						cString := ''
						cString += '<compl>'
						cString +=  '<xObs>' + NoAcentoCte(SubStr(cDTCObs,1,320)) + '</xObs>'
						cString += '</compl>'
						aAdd(aXMLCTe,AllTrim(cString))
					EndIf
					
					//������������������������������������������������������������������Ŀ
					//� TAG: D - Emitente do CT-e                                        �
					//��������������������������������������������������������������������
					cString := '<emit>'
					cString += '<CNPJ>' + NoPontos(SM0->M0_CGC) + '</CNPJ>'
					If (AllTrim(SM0->M0_INSC) == 'ISENTO')
						cString += '<IE>00000000000</IE>'
					Else
						cString += '<IE>' + NoPontos(SM0->M0_INSC) + '</IE>'
					EndIf
					
					If cAmbiente == '2'  //--Homologacao / Nota T�cnica 2012/005 
						cString += '<xNome>' + (SubStr('CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
					Else
						cString += '<xNome>' + NoAcentoCte(SubStr(SM0->M0_NOMECOM,1,60)) + '</xNome>'
					EndIf
					cString += '<xFant>' + NoAcentoCte(SM0->M0_NOME) + '</xFant>'
					cString += '<enderEmit>'
					cString += '<xLgr>' + NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[1]) + '</xLgr>'
					cString += '<nro>'  + Iif(FisGetEnd(SM0->M0_ENDENT)[2]<>0, AllTrim(cValtoChar( FisGetEnd(SM0->M0_ENDENT)[2])),"S/N") + '</nro>'
					If !Empty(NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[4]))
						cString += '<xCpl>' + NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[4]) + '</xCpl>'
					EndIf
					If Empty(AllTrim(SM0->M0_BAIRENT))
						cString += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
					Else
						cString += '<xBairro>' + NoAcentoCte( SM0->M0_BAIRENT ) + '</xBairro>'
					EndIf
					
					cString += '<cMun>' + NoAcentoCte( SM0->M0_CODMUN ) + '</cMun>'
					cString += '<xMun>' + NoAcentoCte( SM0->M0_CIDENT ) + '</xMun>'
					cString += '<CEP>'  + NoAcentoCte( SM0->M0_CEPENT ) + '</CEP>'
					cString += '<UF>'   + NoAcentoCte( SM0->M0_ESTENT ) + '</UF>'
					If !Empty (NoPontos(SM0->M0_TEL))
						cString += '<fone>' + cValtoChar(NoPontos(SM0->M0_TEL))      + '</fone>'
					EndIf
					cString += '</enderEmit>'
					cString += '</emit>'
					
					aAdd(aXMLCTe,AllTrim(cString))

					//������������������������������������������������������������������Ŀ
					//� TAG: E - Remetente das mercadorias transportadas pelo CT-e		 �
					//��������������������������������������������������������������������
					cString := '<rem>'
					If (AllTrim((cAliasDT6)->REM_TPPESSOA) == "J")
						cString += '<CNPJ>' + IIf((cAliasDT6)->REM_UF <> 'EX',NoAcentoCte( (cAliasDT6)->REM_CNPJ ),StrZero(0,14)) + '</CNPJ>'
						//-- Qdo sequencia do IE estiver preenchida.
						If Empty(cInsRemOpc)
							If (cAliasDT6)->REM_CONTRIB=="2"
								cString += '<IE></IE>'
							ElseIf Empty((cAliasDT6)->REM_INSC) .Or. "ISENT" $ Upper(AllTrim((cAliasDT6)->REM_INSC))
								cString += '<IE>ISENTO</IE>'
							Else
								cString += '<IE>' + NoPontos((cAliasDT6)->REM_INSC) + '</IE>'
							EndIf
						ElseIf 'ISENT' $ Upper(cInsRemOpc)
							cString += '<IE>ISENTO</IE>'
						Else
							cString += '<IE>' + NoPontos(cInsRemOpc) + '</IE>'
						EndIf
					Else
						cString += '<CPF>' + IIf((cAliasDT6)->REM_UF <> 'EX',NoAcentoCte( (cAliasDT6)->REM_CNPJ ),StrZero(0,14)) + '</CPF>'
						//-- Qdo sequencia do IE estiver preenchida.
						If Empty(cInsRemOpc)
							If (cAliasDT6)->REM_CONTRIB=="2"
								cString += '<IE></IE>'
							ElseIf Empty((cAliasDT6)->REM_INSC) .Or. 'ISENT' $ Upper(AllTrim((cAliasDT6)->REM_INSC))
								cString += '<IE>ISENTO</IE>'
							Else
								cString += '<IE>' + NoPontos((cAliasDT6)->REM_INSC) + '</IE>'
							EndIf
						Else
							If 'ISENT' $ Upper(AllTrim(cInsRemOpc))
								cString += '<IE>ISENTO</IE>'
							Else
								cString += '<IE>' + NoPontos(cInsRemOpc) + '</IE>'
							EndIf
						EndIf
					EndIf
					
					If cAmbiente == '2'  //--Homologacao / Nota T�cnica 2012/005 
						cString += '<xNome>' + (SubStr('CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
					Else
						cString += '<xNome>' + NoAcentoCte(SubStr((cAliasDT6)->REM_NOME,1,60)) + '</xNome>'
					EndIf
					cString += '<xFant>' + NoAcentoCte((cAliasDT6)->REM_NMEFANT) + '</xFant>'
					If !Empty((cAliasDT6)->REM_TEL)
						cString += '<fone>' + cValtoChar(NoPontos((cAliasDT6)->REM_DDDTEL)) +;
						cValtoChar(NoPontos((cAliasDT6)->REM_TEL)) + '</fone>'
					EndIf
					
					cString += '<enderReme>'
					cString += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasDT6)->REM_END)[1]) + '</xLgr>'
					cString += '<nro>' + Iif(FisGetEnd((cAliasDT6)->REM_END)[2] <> 0, AllTrim(cValtoChar( FisGetEnd((cAliasDT6)->REM_END)[2])),"S/N") + '</nro>'
					If !Empty(NoAcentoCte(FisGetEnd((cAliasDT6)->REM_END)[4]))
						cString += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasDT6)->REM_END)[4]) + '</xCpl>'
					EndIf
					If Empty(AllTrim((cAliasDT6)->REM_BAIRRO))
						cString += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
					Else
						cString += '<xBairro>' + NoAcentoCte( (cAliasDT6)->REM_BAIRRO ) + '</xBairro>'
					EndIf
					
					cString += '<cMun>' + NoAcentoCte( AllTrim(cCodUFRem) + AllTrim((cAliasDT6)->REM_COD_MUN) ) + '</cMun>'
					cString += '<xMun>' + NoAcentoCte((cAliasDT6)->REM_MUNICI) + '</xMun>'
					cString += '<CEP>'  + NoAcentoCte((cAliasDT6)->REM_CEP)    + '</CEP>'
					cString += '<UF>'   + NoAcentoCte((cAliasDT6)->REM_UF)     + '</UF>'
					If !Empty(AllTrim((cAliasDT6)->REM_PAIS))
						cString += '<cPais>'+ NoAcentoCte( (cAliasDT6)->REM_PAIS ) + '</cPais>'
						cString += '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+(cAliasDT6)->REM_PAIS,"YA_DESCR") ) + '</xPais>'
					EndIf
					cString += '</enderReme>'

					
					//������������������������������������������������������������������Ŀ
					//� TAG: locColeta - Local de Coleta                                 �
					//��������������������������������������������������������������������
					
					If cVerAmb == '2.00'					
						If !AllTrim(cNumSol) == ''
			   				cAliasDT5:= GetNextAlias()
							cQuery := " SELECT A1_COD, A1_LOJA, A1_CGC, A1_PESSOA, "
				   			cQuery += "   DUE_CODCLI, DUE_LOJCLI, DUE_NREDUZ, DUE_END, DUE_BAIRRO, DUE_CODMUN,DUE_MUN, DUE_EST, "
				   			cQuery += "   DUL_CODRED, DUL_LOJRED, DUL_CODCLI, DUL_LOJCLI, DUL_END, DUL_BAIRRO, DUL_CODMUN, DUL_MUN, DUL_EST "
				   			cQuery += "	FROM " + RetSQLName("DT5") + " DT5 "
				   			cQuery += "  JOIN " + RetSQLName("DUE") + " DUE "
					 		cQuery += "   ON DUE_FILIAL = '" + xFilial('DUE') + "'" 
					    	cQuery += "    AND DUE_DDD   = DT5_DDD "
					   		cQuery += "    AND DUE_TEL   = DT5_TEL " 
					 		cQuery += "    AND DUE.D_E_L_E_T_ = ' ' "
					 		cQuery += "  JOIN " + RetSQLName("SA1") + " SA1 "
					 		cQuery += "    ON A1_COD = DUE_CODCLI "
					 		cQuery += "    AND  A1_LOJA = DUE_LOJCLI "
					 		cQuery += "    AND SA1.D_E_L_E_T_ = ' ' "
				     		cQuery += "  LEFT JOIN " + RetSqlName("DUL") + " DUL "
					 		cQuery += "   ON DUL_FILIAL = '" + xFilial('DUL') + "'"
							cQuery += "	   AND DUL_DDD    = DT5_DDD "
							cQuery += "	   AND DUL_TEL    = DT5_TEL "
							cQuery += "	   AND DUL_SEQEND = DT5_SEQEND "
							cQuery += "	   AND DUL.D_E_L_E_T_ = ' ' "
							cQuery += "  WHERE DT5_FILIAL	= '" + xFilial("DT5") + "' "
							cQuery += "    AND DT5_FILORI  = '" + cFilOri + "' "
							cQuery += "    AND DT5_NUMSOL  = '" + cNumSol + "' "
							cQuery += "    AND DT5.D_E_L_E_T_ = ' ' "
							cQuery := ChangeQuery(cQuery)
							DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDT5,.T.,.T.)
					
							If !(cAliasDT5)->(Eof())
								If (!Empty(Alltrim((cAliasDT5)->DUE_CODCLI)) .And. (!Empty(AllTrim((cAliasDT5)->DUE_LOJCLI))))
									If ((cAliasDT6)->DT6_CLIREM == (cAliasDT5)->DUE_CODCLI .And. (cAliasDT6)->DT6_LOJREM == (cAliasDT5)->DUE_LOJCLI)
										If (Empty(Alltrim((cAliasDT5)->DUL_CODRED)) .And. Empty(Alltrim((cAliasDT5)->DUL_LOJRED)))
										    If !Empty((cAliasDT5)->(DUL_END))
												cString += '<locColeta>'
												// Enderenco Solicitante DUL
												If aScan(aUF,{|x| x[1] == (cAliasDT5)->DUL_EST }) != 0   //Confere se Uf do End.Solicitante esta OK
													cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT5)->DUL_EST }), 2]
												Else
													cCodUFOri  := ''
												EndIf
												If (AllTrim((cAliasDT5)->A1_PESSOA) == "J")
													cString += '<CNPJ>' + NoPontos((cAliasDT5)->A1_CGC) + '</CNPJ>'
												Else
													cString += '<CPF>' + AllTrim((cAliasDT5)->A1_CGC) + '</CPF>'
												EndIf
												cString += '<xNome>'+ NoAcentoCte( (cAliasDT5)->(DUE_NREDUZ) ) +'</xNome>'
												cString += '<xLgr>'+ NoAcentoCte( (cAliasDT5)->(DUL_END) ) +'</xLgr>'
												cString += '<nro>'  + Iif(FisGetEnd((cAliasDT5)->DUL_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasDT5)->DUL_END)[2])),"S/N") + '</nro>'								
												cString += '<xBairro>'+ NoAcentoCte( (cAliasDT5)->(DUL_BAIRRO) ) +'</xBairro>'
												cString += '<cMun>'+ NoAcentoCte( AllTrim(cCodUFOri) + AllTrim((cAliasDT5)->(DUL_CODMUN)) ) +'</cMun>'
												cString += '<xMun>'+ NoAcentoCte( (cAliasDT5)->(DUL_MUN) ) +'</xMun>' 
												cString += '<UF>'+ NoAcentoCte( (cAliasDT5)->(DUL_EST) ) +'</UF>'
												cString += '</locColeta>'
											EndIf	
										Else
											//Faz um select na SA1 para pegar o Redespachante / Origem da Coleta	   
								   			cAliasCol:= GetNextAlias()									                  
											cQuery := " SELECT DUL_CODRED, DUL_LOJRED, "
											cQuery += "	A1_COD, A1_LOJA, A1_CGC, A1_PESSOA,A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST," 
											cQuery += "   A1_COD_MUN, A1_INSCR, A1_PAIS, A1_DDD, A1_TEL, A1_CEP  "
											cQuery += "  FROM " + RetSqlName("DUL") + " DUL, " 
											cQuery += RetSqlName("SA1") + " SA1 "
											cQuery += "  WHERE SA1.A1_FILIAL = '" + xFilial('SA1') + "'"
											cQuery += "	 AND DUL.DUL_FILIAL = '" + xFilial('DUL') + "'"
											cQuery += "	 AND A1_COD = '" + (cAliasDT5)->DUL_CODRED + "'"
											cQuery += "     AND A1_LOJA = '" + (cAliasDT5)->DUL_LOJRED + "'"
											cQuery += "     AND SA1.D_E_L_E_T_ = ' ' "
											cQuery += "     AND DUL.D_E_L_E_T_ = ' ' "
											cQuery := ChangeQuery(cQuery)
											DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasCol,.T.,.T.)
											If !(cAliasCol)->(Eof())
												cStringExp := ""
												cStringExp += '<exped>'
												// Enderenco Solicitante DUL
												If aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }) != 0   //Confere se Uf do End.Solicitante esta OK
													cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }), 2]
												Else
													cCodUFOri  := ''
												EndIf
												If (AllTrim((cAliasCol)->(A1_PESSOA)) == "J")
													cStringExp += '<CNPJ>' + NoPontos((cAliasCol)->A1_CGC) + '</CNPJ>'
												Else
													cStringExp += '<CPF>' + AllTrim((cAliasCol)->A1_CGC) + '</CPF>'
												EndIf
												
												If 'ISENT' $ Upper(AllTrim((cAliasCol)->A1_INSCR))
													cStringExp += '<IE>ISENTO</IE>'
												Else
													cStringExp += '<IE>' + NoPontos((cAliasCol)->A1_INSCR) + '</IE>'
												EndIf
				
												If cAmbiente == '2'  //--Homologacao / Nota T�cnica 2012/005 
													cStringExp += '<xNome>' + (SubStr('CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
												Else
													cStringExp += '<xNome>' + NoAcentoCte(SubStr((cAliasCol)->A1_NOME,1,60)) + '</xNome>'
												EndIf
												
												If !Empty((cAliasCol)->A1_TEL)
													cStringExp += '<fone>' + cValtoChar(NoPontos((cAliasCol)->A1_DDD)) +;
													cValtoChar(NoPontos((cAliasCol)->A1_TEL)) + '</fone>'
												EndIf
												
												cStringExp += '<enderExped>'
												cStringExp += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasCol)->A1_END)[1]) + '</xLgr>'
												cStringExp += '<nro>' + Iif(FisGetEnd((cAliasCol)->A1_END)[2] <> 0, AllTrim(cValtoChar( FisGetEnd((cAliasCol)->A1_END)[2])),"S/N") + '</nro>'
												If !Empty(NoAcentoCte(FisGetEnd((cAliasCol)->A1_END)[4]))
													cStringExp += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasCol)->A1_END)[4]) + '</xCpl>'
												EndIf
												If Empty(AllTrim((cAliasCol)->A1_BAIRRO))
													cStringExp += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
												Else
													cStringExp += '<xBairro>' + NoAcentoCte( (cAliasCol)->A1_BAIRRO ) + '</xBairro>'
												EndIf
												cStringExp += '<cMun>' + NoAcentoCte( AllTrim(cCodUFOri) + AllTrim((cAliasCol)->A1_COD_MUN) ) + '</cMun>'
												cStringExp += '<xMun>' + NoAcentoCte( (cAliasCol)->A1_MUN ) + '</xMun>'
												cStringExp += '<CEP>'  + NoAcentoCte( (cAliasCol)->A1_CEP ) + '</CEP>'
												cStringExp += '<UF>'   + NoAcentoCte( (cAliasCol)->A1_EST ) + '</UF>'
												If !Empty(AllTrim((cAliasCol)->A1_PAIS))
													cStringExp += '<cPais>'+ NoAcentoCte( (cAliasCol)->A1_PAIS ) + '</cPais>'
													cStringExp += '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+(cAliasCol)->A1_PAIS,"YA_DESCR") ) + '</xPais>'
												EndIf
												cStringExp += '</enderExped>'
												cStringExp += '</exped>'
												
												(cAliasCol)->(DbCloseArea())
											EndIF
										EndIf
									Else
										//Faz um Select no SA1 para codigo do remetente diferente do solicitante
							   			cAliasCol:= GetNextAlias()								                  
										cQuery := " SELECT DUE_CODCLI, DUE_LOJCLI, "
										cQuery += "	A1_COD, A1_LOJA, A1_CGC, A1_PESSOA,A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_COD_MUN "
										cQuery += "  FROM " + RetSqlName("DUE") + " DUE, "
										cQuery += RetSqlName("SA1") + " SA1 "
										cQuery += "  WHERE SA1.A1_FILIAL = '" + xFilial('SA1') + "'"
										cQuery += "	 AND DUE.DUE_FILIAL = '" + xFilial('DUE') + "'"
										cQuery += "	 AND A1_COD = '" + (cAliasDT5)->DUE_CODCLI + "'"
										cQuery += "     AND A1_LOJA = '" + (cAliasDT5)->DUE_LOJCLI + "'"
										cQuery += "     AND SA1.D_E_L_E_T_ = ' '
										cQuery += "     AND DUE.D_E_L_E_T_ = ' '
										cQuery := ChangeQuery(cQuery)
										DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasCol,.T.,.T.)
										If !(cAliasCol)->(Eof())
											cString += '<locColeta>'
											// Enderenco Solicitante DUL
											If aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }) != 0   //Confere se Uf do End.Solicitante esta OK
												cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }), 2]
											Else
												cCodUFOri  := ''
											EndIf
											If (AllTrim((cAliasCol)->(A1_PESSOA)) == "J")
												cString += '<CNPJ>' + NoPontos((cAliasCol)->A1_CGC) + '</CNPJ>'
											Else
												cString += '<CPF>' + AllTrim((cAliasCol)->A1_CGC) + '</CPF>'
											EndIf
											cString += '<xNome>'+ NoAcentoCte((cAliasCol)->(A1_NOME) ) +'</xNome>'
											cString += '<xLgr>'+ NoAcentoCte( (cAliasCol)->(A1_END) ) +'</xLgr>'
											cString += '<nro>'  + Iif(FisGetEnd((cAliasCol)->A1_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasCol)->A1_END)[2])),"S/N") + '</nro>'								
											cString += '<xBairro>'+ NoAcentoCte( (cAliasCol)->(A1_BAIRRO) ) +'</xBairro>'
											cString += '<cMun>'+ NoAcentoCte( AllTrim(cCodUFOri) + AllTrim((cAliasCol)->(A1_COD_MUN)) ) +'</cMun>'
											cString += '<xMun>'+ NoAcentoCte( (cAliasCol)->(A1_MUN) ) +'</xMun>' 
											cString += '<UF>'+ NoAcentoCte( (cAliasCol)->(A1_EST) ) +'</UF>'
											cString += '</locColeta>'
											(cAliasCol)->(DbCloseArea())
										EndIF
									EndIf
								EndIf
							EndIf
							(cAliasDT5)->(DbCloseArea())			
						EndIf 
					EndIf	
					
					aAdd(aXMLCTe,AllTrim(cString))
					cString	  := ""		
					
					
					
					//������������������������������������������������������������������Ŀ
					//� TAG: E - Grupos de informacoes das NF                            �
					//��������������������������������������������������������������������
					cAliasTagE := GetNextAlias()
					cQuery := " SELECT DTC.DTC_NUMNFC, DTC.DTC_SERNFC, DTC.DTC_EMINFC,		" + CRLF
					cQuery += "        DTC.DTC_BASICM, DTC.DTC_VALICM, DTC.DTC_BASESU,		" + CRLF
					cQuery += "        DTC.DTC_VALIST, DTC.DTC_VALOR,  DTC_CF,	" + CRLF
					cQuery += "        DTC.DTC_PESO,   DTC.DTC_PESOM3, DTC.DTC_METRO3, DTC.DTC_QTDVOL, " + CRLF
					cQuery += "        DTC.DTC_NFEID,  DTC.DTC_TIPNFC, SB1.B1_UM, " + CRLF
					cQuery += "        DTC.DTC_FILORI, DTC.DTC_NUMSOL, DTC.DTC_SELORI, DTC.DTC_SQEDES " + CRLF
					cQuery += "   FROM " + RetSqlName('DTC') + " DTC " + CRLF
					//-- 
					If	!Empty((cAliasDT6)->DT6_DOCDCO)
						cQuery += "   INNER JOIN " + RetSqlName('DT6') + " DT6 " + CRLF
						cQuery += "     ON DT6.DT6_FILDOC = '" + xFilial("DT6")  + "'" + CRLF
						cQuery += "    AND DT6.DT6_DOC    = '" + SD1->D1_NFORI   + "'" + CRLF
						cQuery += "    AND DT6.DT6_SERIE  = '" + SD1->D1_SERIORI + "'" + CRLF
						cQuery += "    AND DT6.D_E_L_E_T_ = ' '" + CRLF
					EndIf
					//-- Cadastro de Produtos
					cQuery += "        INNER JOIN " + RetSqlName('SB1') + " SB1 " + CRLF
					cQuery += "               ON  SB1.B1_COD     = DTC.DTC_CODPRO " + CRLF
					cQuery += "               AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'" + CRLF
					cQuery += "               AND SB1.D_E_L_E_T_ = ' ' " + CRLF
					cQuery += "  WHERE DTC.DTC_FILIAL	= '" + xFilial('DTC') + "'" + CRLF
					//�����������������������������������������������������������������Ŀ
					//� Tipo de Conhecimento de Anulacao, seleciona as                  �
					//� informacoes do CTE principal, pois nao tem DTC                  �
					//�������������������������������������������������������������������
					If !Empty((cAliasDT6)->DT6_DOCDCO)
						cQuery += "    AND DTC.DTC_FILDOC  = '" + (cAliasDT6)->DT6_FILDCO + "'" + CRLF
						cQuery += "    AND DTC.DTC_DOC     = '" + (cAliasDT6)->DT6_DOCDCO + "'" + CRLF
						cQuery += "    AND DTC.DTC_SERIE   = '" + (cAliasDT6)->DT6_SERDCO + "'" + CRLF
					Else
						cQuery += "    AND DTC.DTC_FILDOC  = '" + AllTrim((cAliasDT6)->DT6_FILDOC) + "'" + CRLF
						cQuery += "    AND DTC.DTC_DOC     = '" + AllTrim((cAliasDT6)->DT6_DOC)    + "'" + CRLF
						cQuery += "    AND DTC.DTC_SERIE   = '" + AllTrim((cAliasDT6)->DT6_SERIE)  + "'" + CRLF
					EndIf
					cQuery += " AND DTC.D_E_L_E_T_   = ' '" + CRLF
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTagE, .F., .T.)

					lSelOcor := (cAliasTagE)->DTC_SELORI == '3'
					cSeqEntr := (cAliasTagE)->DTC_SQEDES
					If (cAliasTagE)->DTC_TIPNFC $ '3,6,7'	// -- Documento Nao Fiscal
						
						While !(cAliasTagE)->(Eof())					 //Preenche aCarga totalizando todos os produtos do Ct-e
						
							//����������������������������������������������������Ŀ
							//� TAG de grupo de informacoes dos demais documentos  �
							//� Ex: Delaracao, Outros                              �
							//������������������������������������������������������
							cString += '<infOutros>'
							cString += '<tpDoc>99</tpDoc>'
							cString += '<nDoc>'+NoAcentoCte(AllTrim((cAliasTagE)->DTC_NUMNFC))+'</nDoc>'
							cString += '<dEmi>'	+ SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 1, 4) + "-" ;
							+ SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 5, 2) + "-" ;
							+ SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 7, 2) + '</dEmi>'
							cString += '</infOutros>'

							aCarga[1] += (cAliasTagE)->DTC_PESO
							aCarga[2] += (cAliasTagE)->DTC_PESOM3
							aCarga[3] += (cAliasTagE)->DTC_METRO3
							aCarga[4] += (cAliasTagE)->DTC_QTDVOL
							(cAliasTagE)->(dbSkip())
						Enddo
						   
						If cVerAmb == '2.00'
						    cStringOut	+= cString  
						    cString 		:= ''
						Endif						
					Else
												
						//������������������������������������������������������������������Ŀ
						//� Verifica se possui viagem                                        �
						//��������������������������������������������������������������������
						cViagem  := Posicione('DTP',2,xFilial('DTP')+(cAliasDT6)->DT6_FILORI+(cAliasDT6)->DT6_LOTNFC,'DTP_VIAGEM')
						If !Empty(cViagem)
							cAliasDev := GetNextAlias()
							cQuery := " SELECT DT6.DT6_CLIDEV, DT6.DT6_LOJDEV "
							cQuery += " FROM " + RetSqlName('DT6') + " DT6 "
							cQuery += "   WHERE DT6_FILIAL    = '" + xFilial("DT6") + "'" + CRLF
							cQuery += "    AND DT6.DT6_FILORI = '" + DTP->DTP_FILORI + "'" + CRLF
							cQuery += "    AND DT6.DT6_LOTNFC = '" + DTP->DTP_LOTNFC + "'" + CRLF
							cQuery += "    AND D_E_L_E_T_     = '' "
							cQuery += " GROUP BY DT6.DT6_CLIDEV, DT6.DT6_LOJDEV " + CRLF
							cQuery := ChangeQuery(cQuery)
							DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasDev, .F., .T.)
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
						
						While (cAliasTagE)->(!Eof())
							If !Empty((cAliasTagE)->DTC_NFEID)
								
								//���������������������������������Ŀ
								//� INFNFE: IdentIficador da NF-e   �
								//�����������������������������������
								lNfe := .T.
								cStringCh += '<infNFe>'
								cStringCh += '<chave>' + (cAliasTagE)->DTC_NFEID + '</chave>'		//-- IdentIficador da NF-e
								cStringCh += '</infNFe>'

								If cVerAmb == '1.04' 
									cString := cStringCh
									cStringCh  := ''
                            EndIf                   								
								
								aCarga[1] += (cAliasTagE)->DTC_PESO
								aCarga[2] += (cAliasTagE)->DTC_PESOM3
								aCarga[3] += (cAliasTagE)->DTC_METRO3
								aCarga[4] += (cAliasTagE)->DTC_QTDVOL
							Else
								
								If Empty(cStringTmp)
									cStringTmp := cString 
									cString    := ''  
								Else
									cStringTmp += cString 
									cString    := ''   
								EndIf
								
                            cString += '<infNF>'
								cString += '<mod>01</mod>'
								cString += '<serie>' + NoAcentoCte( (cAliasTagE)->DTC_SERNFC ) + '</serie>'			//-- Serie da NF
								cString += '<nDoc>'  + NoAcentoCte( (cAliasTagE)->DTC_NUMNFC ) + '</nDoc>'				//-- Num. da NF
								cString += '<dEmi>'  + SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 1, 4) + "-" + SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 5, 2) + "-" + SubStr(AllTrim((cAliasTagE)->DTC_EMINFC), 7, 2) + '</dEmi>' //-- Data Emissao
								cString += '<vBC>'   + ConvType((cAliasTagE)->DTC_BASICM, 15, 2, "N") + '</vBC>'		//-- Base de C�lculo do ICMS
								cString += '<vICMS>' + ConvType((cAliasTagE)->DTC_VALICM, 15, 2, "N") + '</vICMS>'		//-- Valor total do ICMS
								cString += '<vBCST>' + ConvType((cAliasTagE)->DTC_BASESU, 15, 2, "N") + '</vBCST>'		//-- Base de c�lculo do ICMS ST
								cString += '<vST>'   + ConvType((cAliasTagE)->DTC_VALIST, 15, 2, "N") + '</vST>'		//-- Valor total do ICMS ST
								cString += '<vProd>' + ConvType((cAliasTagE)->DTC_VALOR,  15, 2, "N") + '</vProd>'		//-- Valor total do Produto
								cString += '<vNF>'   + ConvType((cAliasTagE)->DTC_VALOR,  15, 2, "N") + '</vNF>'		//-- Valor total da Nota Fiscal
								cString += '<nCFOP>' + ConvType((cAliasTagE)->DTC_CF, 4, "N") + '</nCFOP>'				//-- CFOP predominante
								//-- Preenche aCarga totalizando todos os produtos do Ct-e
								aCarga[1] += (cAliasTagE)->DTC_PESO
								aCarga[2] += (cAliasTagE)->DTC_PESOM3
								aCarga[3] += (cAliasTagE)->DTC_METRO3
								aCarga[4] += (cAliasTagE)->DTC_QTDVOL

								
								//������������������������������������������������������������������Ŀ
								//� TAG: locColeta - Local de Retirada                                �
								//��������������������������������������������������������������������
								If cVerAmb == '1.04'					
									If !AllTrim(cNumSol) == ''
						   				cAliasDT5:= GetNextAlias()
										cQuery := " SELECT A1_COD, A1_LOJA, A1_CGC, A1_PESSOA, "
							   			cQuery += "   DUE_CODCLI, DUE_LOJCLI, DUE_NREDUZ, DUE_END, DUE_BAIRRO, DUE_CODMUN,DUE_MUN, DUE_EST, "
							   			cQuery += "   DUL_CODRED, DUL_LOJRED, DUL_CODCLI, DUL_LOJCLI, DUL_END, DUL_BAIRRO, DUL_CODMUN, DUL_MUN, DUL_EST "
							   			cQuery += "	FROM " + RetSQLName("DT5") + " DT5 "
							   			cQuery += "  JOIN " + RetSQLName("DUE") + " DUE "
								 		cQuery += "   ON DUE_FILIAL = '" + xFilial('DUE') + "'" 
								    	cQuery += "    AND DUE_DDD   = DT5_DDD "
								   		cQuery += "    AND DUE_TEL   = DT5_TEL " 
								 		cQuery += "    AND DUE.D_E_L_E_T_ = ' ' "
								 		cQuery += "  JOIN " + RetSQLName("SA1") + " SA1 "
								 		cQuery += "    ON A1_COD = DUE_CODCLI "
								 		cQuery += "    AND  A1_LOJA = DUE_LOJCLI "
								 		cQuery += "    AND SA1.D_E_L_E_T_ = ' ' "
							     		cQuery += "  LEFT JOIN " + RetSqlName("DUL") + " DUL "
								 		cQuery += "   ON DUL_FILIAL = '" + xFilial('DUL') + "'"
										cQuery += "	   AND DUL_DDD    = DT5_DDD "
										cQuery += "	   AND DUL_TEL    = DT5_TEL "
										cQuery += "	   AND DUL_SEQEND = DT5_SEQEND "
										cQuery += "	   AND DUL.D_E_L_E_T_ = ' ' "
										cQuery += "  WHERE DT5_FILIAL	= '" + xFilial("DT5") + "' "
										cQuery += "    AND DT5_FILORI  = '" + cFilori + "' "
										cQuery += "    AND DT5_NUMSOL  = '" + cNumSol + "' "
										cQuery += "    AND DT5.D_E_L_E_T_ = ' ' "
										cQuery := ChangeQuery(cQuery)
										DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDT5,.T.,.T.)
								
										If !(cAliasDT5)->(Eof())
											If (!Empty(Alltrim((cAliasDT5)->DUE_CODCLI)) .And. (!Empty(AllTrim((cAliasDT5)->DUE_LOJCLI))))
												If ((cAliasDT6)->DT6_CLIREM == (cAliasDT5)->DUE_CODCLI .And. (cAliasDT6)->DT6_LOJREM == (cAliasDT5)->DUE_LOJCLI)
													If (Empty(Alltrim((cAliasDT5)->DUL_CODRED)) .And. Empty(Alltrim((cAliasDT5)->DUL_LOJRED)))
													    If !Empty((cAliasDT5)->(DUL_END))
															cString += '<locRet>'
															// Enderenco Solicitante DUL
															If aScan(aUF,{|x| x[1] == (cAliasDT5)->DUL_EST }) != 0   //Confere se Uf do End.Solicitante esta OK
																cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasDT5)->DUL_EST }), 2]
															Else
																cCodUFOri  := ''
															EndIf
															If (AllTrim((cAliasDT5)->A1_PESSOA) == "J")
																cString += '<CNPJ>' + NoPontos((cAliasDT5)->A1_CGC) + '</CNPJ>'
															Else
																cString += '<CPF>' + AllTrim((cAliasDT5)->A1_CGC) + '</CPF>'
															EndIf
															cString += '<xNome>'+ NoAcentoCte( (cAliasDT5)->(DUE_NREDUZ) ) +'</xNome>'
															cString += '<xLgr>'+ NoAcentoCte( (cAliasDT5)->(DUL_END) ) +'</xLgr>'
															cString += '<nro>'  + Iif(FisGetEnd((cAliasDT5)->DUL_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasDT5)->DUL_END)[2])),"S/N") + '</nro>'								
															cString += '<xBairro>'+ NoAcentoCte( (cAliasDT5)->(DUL_BAIRRO) ) +'</xBairro>'
															cString += '<cMun>'+ NoAcentoCte( AllTrim(cCodUFOri) + AllTrim((cAliasDT5)->(DUL_CODMUN)) ) +'</cMun>'
															cString += '<xMun>'+ NoAcentoCte( (cAliasDT5)->(DUL_MUN) ) +'</xMun>' 
															cString += '<UF>'+ NoAcentoCte( (cAliasDT5)->(DUL_EST) ) +'</UF>'
															cString += '</locRet>'
														EndIf	
													Else
														//Faz um select na SA1 para pegar o Redespachante / Origem da Coleta	   
											   			cAliasCol:= GetNextAlias()									                  
														cQuery := " SELECT DUL_CODRED, DUL_LOJRED, "
														cQuery += "	A1_COD, A1_LOJA, A1_CGC, A1_PESSOA,A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST," 
														cQuery += "   A1_COD_MUN, A1_INSCR, A1_PAIS, A1_DDD, A1_TEL, A1_CEP  "
														cQuery += "  FROM " + RetSqlName("DUL") + " DUL, " 
														cQuery += RetSqlName("SA1") + " SA1 "
														cQuery += "  WHERE SA1.A1_FILIAL = '" + xFilial('SA1') + "'"
														cQuery += "	 AND DUL.DUL_FILIAL = '" + xFilial('DUL') + "'"
														cQuery += "	 AND A1_COD = '" + (cAliasDT5)->DUL_CODRED + "'"
														cQuery += "     AND A1_LOJA = '" + (cAliasDT5)->DUL_LOJRED + "'"
														cQuery += "     AND SA1.D_E_L_E_T_ = ' ' "
														cQuery += "     AND DUL.D_E_L_E_T_ = ' ' "
														cQuery := ChangeQuery(cQuery)
														DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasCol,.T.,.T.)
														If !(cAliasCol)->(Eof())
															cStringExp := ""
															cStringExp += '<exped>'
															// Enderenco Solicitante DUL
															If aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }) != 0   //Confere se Uf do End.Solicitante esta OK
																cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }), 2]
															Else
																cCodUFOri  := ''
															EndIf
															If (AllTrim((cAliasCol)->(A1_PESSOA)) == "J")
																cStringExp += '<CNPJ>' + NoPontos((cAliasCol)->A1_CGC) + '</CNPJ>'
															Else
																cStringExp += '<CPF>' + AllTrim((cAliasCol)->A1_CGC) + '</CPF>'
															EndIf
															
															If 'ISENT' $ Upper(AllTrim((cAliasCol)->A1_INSCR))
																cStringExp += '<IE>ISENTO</IE>'
															Else
																cStringExp += '<IE>' + NoPontos((cAliasCol)->A1_INSCR) + '</IE>'
															EndIf
							
															If cAmbiente == '2'  //--Homologacao / Nota T�cnica 2012/005 
																cStringExp += '<xNome>' + (SubStr('CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
															Else
																cStringExp += '<xNome>' + NoAcentoCte(SubStr((cAliasCol)->A1_NOME,1,60)) + '</xNome>'
															EndIf
															
															If !Empty((cAliasCol)->A1_TEL)
																cStringExp += '<fone>' + cValtoChar(NoPontos((cAliasCol)->A1_DDD)) +;
																cValtoChar(NoPontos((cAliasCol)->A1_TEL)) + '</fone>'
															EndIf
															
															cStringExp += '<enderExped>'
															cStringExp += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasCol)->A1_END)[1]) + '</xLgr>'
															cStringExp += '<nro>' + Iif(FisGetEnd((cAliasCol)->A1_END)[2] <> 0, AllTrim(cValtoChar( FisGetEnd((cAliasCol)->A1_END)[2])),"S/N") + '</nro>'
															If !Empty(NoAcentoCte(FisGetEnd((cAliasCol)->A1_END)[4]))
																cStringExp += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasCol)->A1_END)[4]) + '</xCpl>'
															EndIf
															If Empty(AllTrim((cAliasCol)->A1_BAIRRO))
																cStringExp += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
															Else
																cStringExp += '<xBairro>' + NoAcentoCte( (cAliasCol)->A1_BAIRRO ) + '</xBairro>'
															EndIf
															cStringExp += '<cMun>' + NoAcentoCte( AllTrim(cCodUFOri) + AllTrim((cAliasCol)->A1_COD_MUN) ) + '</cMun>'
															cStringExp += '<xMun>' + NoAcentoCte( (cAliasCol)->A1_MUN ) + '</xMun>'
															cStringExp += '<CEP>'  + NoAcentoCte( (cAliasCol)->A1_CEP ) + '</CEP>'
															cStringExp += '<UF>'   + NoAcentoCte( (cAliasCol)->A1_EST ) + '</UF>'
															If !Empty(AllTrim((cAliasCol)->A1_PAIS))
																cStringExp += '<cPais>'+ NoAcentoCte( (cAliasCol)->A1_PAIS ) + '</cPais>'
																cStringExp += '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+(cAliasCol)->A1_PAIS,"YA_DESCR") ) + '</xPais>'
															EndIf
															cStringExp += '</enderExped>'
															cStringExp += '</exped>'
															
															(cAliasCol)->(DbCloseArea())
														EndIF
													EndIf
												Else
													//Faz um Select no SA1 para codigo do remetente diferente do solicitante
										   			cAliasCol:= GetNextAlias()								                  
													cQuery := " SELECT DUE_CODCLI, DUE_LOJCLI, "
													cQuery += "	A1_COD, A1_LOJA, A1_CGC, A1_PESSOA,A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_COD_MUN "
													cQuery += "  FROM " + RetSqlName("DUE") + " DUE, "
													cQuery += RetSqlName("SA1") + " SA1 "
													cQuery += "  WHERE SA1.A1_FILIAL = '" + xFilial('SA1') + "'"
													cQuery += "	 AND DUE.DUE_FILIAL = '" + xFilial('DUE') + "'"
													cQuery += "	 AND A1_COD = '" + (cAliasDT5)->DUE_CODCLI + "'"
													cQuery += "     AND A1_LOJA = '" + (cAliasDT5)->DUE_LOJCLI + "'"
													cQuery += "     AND SA1.D_E_L_E_T_ = ' '
													cQuery += "     AND DUE.D_E_L_E_T_ = ' '
													cQuery := ChangeQuery(cQuery)
													DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasCol,.T.,.T.)
													If !(cAliasCol)->(Eof())
														cString += '<locRet>'
														// Enderenco Solicitante DUL
														If aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }) != 0   //Confere se Uf do End.Solicitante esta OK
															cCodUFOri  := aUF[ aScan(aUF,{|x| x[1] == (cAliasCol)->(A1_EST) }), 2]
														Else
															cCodUFOri  := ''
														EndIf
														If (AllTrim((cAliasCol)->(A1_PESSOA)) == "J")
															cString += '<CNPJ>' + NoPontos((cAliasCol)->A1_CGC) + '</CNPJ>'
														Else
															cString += '<CPF>' + AllTrim((cAliasCol)->A1_CGC) + '</CPF>'
														EndIf
														cString += '<xNome>'+ NoAcentoCte((cAliasCol)->(A1_NOME) ) +'</xNome>'
														cString += '<xLgr>'+ NoAcentoCte( (cAliasCol)->(A1_END) ) +'</xLgr>'
														cString += '<nro>'  + Iif(FisGetEnd((cAliasCol)->A1_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasCol)->A1_END)[2])),"S/N") + '</nro>'								
														cString += '<xBairro>'+ NoAcentoCte( (cAliasCol)->(A1_BAIRRO) ) +'</xBairro>'
														cString += '<cMun>'+ NoAcentoCte( AllTrim(cCodUFOri) + AllTrim((cAliasCol)->(A1_COD_MUN)) ) +'</cMun>'
														cString += '<xMun>'+ NoAcentoCte( (cAliasCol)->(A1_MUN) ) +'</xMun>' 
														cString += '<UF>'+ NoAcentoCte( (cAliasCol)->(A1_EST) ) +'</UF>'
														cString += '</locRet>'
														(cAliasCol)->(DbCloseArea())
													EndIF
												EndIf
											EndIf
										EndIf
										(cAliasDT5)->(DbCloseArea())			
									EndIf 
								EndIf	
								cString += '</infNF>'    
								If cVerAmb == '2.00'
								    cString20	+= cString  
								    cString 	:= ''
								Endif
							EndIf  
							(cAliasTagE)->(dbSkip())
						EndDo					
					EndIf
					(cAliasTagE)->(DbCloseArea())
					cString += '</rem>'
					cStringTmp += cString
					aAdd(aXMLCTe,AllTrim(cStringTmp))
					cStringTmp  := ""
					cString	  := ""	
					
					If !Empty(cStringExp)
						aAdd(aXMLCTe,AllTrim(cStringExp))
					EndIf
					cStringExp	:= ""	
					
					//�����������������������������������������������������������������Ŀ
					//� TAG: H - Dados do Destinatario                                  �
					//�������������������������������������������������������������������
					cString := '<dest>'
					If (AllTrim((cAliasDT6)->DES_TPPESSOA) == "J")
						cString += '<CNPJ>' + Iif((cAliasDT6)->DES_UF <> 'EX', NoPontos((cAliasDT6)->DES_CNPJ), StrZero(0,14)) + '</CNPJ>'
						If (cAliasDT6)->DES_CONTRIB=="2"
							cString += '<IE></IE>'
						ElseIf Empty((cAliasDT6)->DES_INSC) .Or. 'ISENT' $ Upper(NoAcentoCte((cAliasDT6)->DES_INSC))
							cString += '<IE>ISENTO</IE>'
						Else
							cString += '<IE>' + NoPontos((cAliasDT6)->DES_INSC) + '</IE>'
						EndIf
					Else
						cString += '<CPF>' + Iif((cAliasDT6)->DES_UF <> 'EX', NoAcentoCte( (cAliasDT6)->DES_CNPJ ), StrZero(0,14)) + '</CPF>'
						If (cAliasDT6)->DES_CONTRIB=="2"
							cString += '<IE></IE>'
						ElseIf Empty((cAliasDT6)->DES_INSC) .Or. 'ISENT' $ Upper(AllTrim((cAliasDT6)->DES_INSC))
							cString += '<IE>ISENTO</IE>'
						Else
							cString += '<IE>' + NoPontos((cAliasDT6)->DES_INSC) + '</IE>'
						EndIf
					EndIf

					If cAmbiente == '2'  //--Homologacao / Nota T�cnica 2012/005 
						cString += '<xNome>' + (SubStr('CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',1,60)) + '</xNome>'
					Else
						cString += '<xNome>' + NoAcentoCte(SubStr((cAliasDT6)->DES_NOME,1,60)) + '</xNome>'
					EndIf
					If !Empty((cAliasDT6)->DES_TEL)
						cString += '<fone>' + cValtoChar(NoPontos((cAliasDT6)->DES_DDDTEL)) + ;
						cValtoChar(NoPontos((cAliasDT6)->DES_TEL)) + '</fone>'
					EndIf
					cString += '<enderDest>'
					cString += '<xLgr>' + NoAcentoCte(FisGetEnd((cAliasDT6)->DES_END)[1]) + '</xLgr>'
					cString += '<nro>' + Iif(FisGetEnd((cAliasDT6)->DES_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd((cAliasDT6)->DES_END)[2])),"S/N") + '</nro>'
					If !Empty(NoAcentoCte(FisGetEnd((cAliasDT6)->DES_END)[4]))
						cString += '<xCpl>' + NoAcentoCte(FisGetEnd((cAliasDT6)->DES_END)[4]) + '</xCpl>'
					EndIf
					If Empty(AllTrim((cAliasDT6)->DES_BAIRRO))
						cString += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
					Else
						cString += '<xBairro>' + NoAcentoCte( (cAliasDT6)->DES_BAIRRO ) + '</xBairro>'
					EndIf
					cString += '<cMun>'+ NoAcentoCte(AllTrim(cCodUFDes) + AllTrim((cAliasDT6)->DES_COD_MUN) ) + '</cMun>'
					cString += '<xMun>'+ NoAcentoCte((cAliasDT6)->DES_MUNICI) + '</xMun>'
					cString += '<CEP>' + NoAcentoCte((cAliasDT6)->DES_CEP) + '</CEP>'
					cString += '<UF>'  + NoAcentoCte((cAliasDT6)->DES_UF)  + '</UF>'
					If !Empty(AllTrim((cAliasDT6)->DES_PAIS))
						cString += '<cPais>'+ NoAcentoCte( (cAliasDT6)->DES_PAIS ) + '</cPais>'
						cString += '<xPais>'+ NoAcentoCte( Posicione("SYA",1,xFilial("SYA")+(cAliasDT6)->REM_PAIS,"YA_DESCR") ) + '</xPais>'
					EndIf
					cString += '</enderDest>'
					
					If !Empty(cSeqEntr)
						DUL->(DbSetOrder(2))
						If DUL->(MsSeek(xFilial('DUL')+(cAliasDT6)->DT6_CLIDES + (cAliasDT6)->DT6_LOJDES + cSeqEntr))
							cString += '<locEnt>'
							SA1->(DbSetOrder(1))
							If SA1->(dbSeek(xFilial('SA1') + DUL->DUL_CODRED + DUL->DUL_LOJRED))
								If (AllTrim(SA1->A1_PESSOA) == "J")
									cString += '<CNPJ>' + NoPontos(SA1->A1_CGC) + '</CNPJ>'
								Else
									cString += '<CPF>' + AllTrim(SA1->A1_CGC) + '</CPF>'
								EndIf
								cString += '<xNome>'+ NoAcentoCte(SubStr(SA1->A1_NOME,1,60)) + '</xNome>'
							Else
								If (AllTrim((cAliasDT6)->DES_TPPESSOA) == "J")
									cString += '<CNPJ>' + NoPontos((cAliasDT6)->DES_CNPJ) + '</CNPJ>'
								Else
									cString += '<CPF>' + AllTrim((cAliasDT6)->DES_CNPJ) + '</CPF>'
								EndIf
								cString += '<xNome>'+ NoAcentoCte(SubStr((cAliasDT6)->DES_NOME,1,60)) + '</xNome>'
							EndIf
							cString += '<xLgr>' + NoAcentoCte(FisGetEnd(DUL->DUL_END)[1]) + '</xLgr>'
							cString += '<nro>'  + Iif(FisGetEnd(DUL->DUL_END)[2]<>0, AllTrim(cValtoChar( FisGetEnd(DUL->DUL_END)[2])),"S/N") + '</nro>'
							If !Empty(NoAcentoCte(FisGetEnd(DUL->DUL_END)[4]))
								cString += '<xCpl>' + NoAcentoCte(FisGetEnd(DUL->DUL_END)[4]) + '</xCpl>'
							EndIf
							cString += '<xBairro>'	+ NoAcentoCte( DUL->DUL_BAIRRO )+ '</xBairro>'
							If aScan(aUF,{|x| x[1] == DUL->DUL_EST }) != 0
								cUfEnt := aUF[ aScan(aUF,{|x| x[1] == DUL->DUL_EST }), 2]
							Else
								cUfEnt := ''
							EndIf
							cString += '<cMun>' + NoAcentoCte( AllTrim(cUfEnt) + AllTrim(DUL->DUL_CODMUN) ) + '</cMun>'
							cString += '<xMun>' + NoAcentoCte( DUL->DUL_MUN ) + '</xMun>'
							cString += '<UF>'   + NoAcentoCte( DUL->DUL_EST ) + '</UF>'
							cString += '</locEnt>'
						EndIf
					EndIf

					If !Empty(cMail)
						cString += '[EMAIL=' + cMail + ']'
					EndIf

					cString += '</dest>'
					aAdd(aXMLCTe,AllTrim(cString))

					//�����������������������������������������������������������������Ŀ
					//� TAG: I - Valores da prestacao de servico                        �
					//�������������������������������������������������������������������
					cAliasTagI := GetNextAlias()
					cQuery := " SELECT DOCCOMP.DT8_VALPAS, " +CRLF
					cQuery += "        DOCCOMP.DT8_VALTOT, " +CRLF
					cQuery += "           COMP.DT3_DESCRI  " +CRLF
					cQuery += "   FROM " + RetSqlName('DT8') + " DOCCOMP " +CRLF
					cQuery += " 		 INNER JOIN  " + RetSqlName('DT3') + " COMP " +CRLF
					cQuery += " 				   ON ( COMP.DT3_FILIAL='" + xFilial("DT3") + "'" +CRLF
					cQuery += "						AND COMP.DT3_CODPAS = DOCCOMP.DT8_CODPAS " +CRLF
					cQuery += "						AND COMP.D_E_L_E_T_=' ')" +CRLF
					cQuery += "  WHERE DOCCOMP.DT8_FILIAL  = '" + xFilial("DT8") + "'" +CRLF
					//�����������������������������������������������������������������Ŀ
					//� Tipo de Conhecimento de Anulacao, seleciona as                  �
					//� informacoes do CTE principal, pois nao tem DTC                  �
					//�������������������������������������������������������������������
					If !Empty((cAliasDT6)->DT6_DOCDCO)
						cQuery += "    AND DOCCOMP.DT8_FILDOC  = '" + (cAliasDT6)->DT6_FILDCO + "'" + CRLF
						cQuery += "    AND DOCCOMP.DT8_DOC     = '" + (cAliasDT6)->DT6_DOCDCO + "'" + CRLF
						cQuery += "    AND DOCCOMP.DT8_SERIE   = '" + (cAliasDT6)->DT6_SERDCO + "'" + CRLF
					Else
						cQuery += "    AND DOCCOMP.DT8_FILDOC  = '" + AllTrim((cAliasDT6)->DT6_FILDOC) + "'" + CRLF
						cQuery += "    AND DOCCOMP.DT8_DOC     = '" + AllTrim((cAliasDT6)->DT6_DOC)    + "'" + CRLF
						cQuery += "    AND DOCCOMP.DT8_SERIE   = '" + AllTrim((cAliasDT6)->DT6_SERIE)  + "'" + CRLF
					EndIf
					cQuery += "    AND DOCCOMP.D_E_L_E_T_  = ' '"
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTagI, .F., .T.)
					
					cString := '<vPrest>'
					
					cAliasVPrest := GetNextAlias()
					cQuery := " SELECT DT6.DT6_VALTOT, " + CRLF
					cQuery += "        DT6.DT6_VALFAT  " +CRLF
					cQuery += "  FROM " + RetSqlName('DT6') + " DT6 " + CRLF
					cQuery += "  WHERE DT6.DT6_FILIAL  = '" + xFilial("DT6") + "'" + CRLF
					cQuery += "    AND DT6.DT6_FILDOC  = '" + (cAliasDT6)->DT6_FILDOC + "'" + CRLF
					cQuery += "    AND DT6.DT6_DOC     = '" + (cAliasDT6)->DT6_DOC    + "'" + CRLF
					cQuery += "    AND DT6.DT6_SERIE   = '" + (cAliasDT6)->DT6_SERIE  + "'" + CRLF
					cQuery += "    AND DT6.D_E_L_E_T_  = ' '"
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasVPrest, .F., .T.)
					If !Empty((cAliasDT6)->DT6_DOCTMS)
						cString += '<vTPrest>' + ConvType((cAliasVPrest)->DT6_VALTOT, 15, 2, "N") + '</vTPrest>'
						cString += '<vRec>'    + ConvType((cAliasVPrest)->DT6_VALFAT, 15, 2, "N") + '</vRec>'
					Else
						cString += '<vTPrest>' + ConvType((cAliasDT6)->DT6_VALTOT, 15, 2, "N") + '</vTPrest>'
						cString += '<vRec>'    + ConvType((cAliasDT6)->DT6_VALFAT, 15, 2, "N") + '</vRec>'
					EndIf
					If	!AllTrim((cAliasDT6)->DT6_DOCTMS) == StrZero( 8, Len(DT6->DT6_DOCTMS))
						While !(cAliasTagI)->(Eof())
							cString +='<Comp>'
							cString += '<xNome>' + AllTrim(NoAcentoCte(SubStr((cAliasTagI)->DT3_DESCRI,1,15))) + '</xNome>'
							If lCTEVFRE
								cString += '<vComp>' + ConvType((cAliasTagI)->DT8_VALPAS, 15, 2, "N") + '</vComp>'
							Else
								cString += '<vComp>' + ConvType((cAliasTagI)->DT8_VALTOT, 15, 2, "N") + '</vComp>'
							EndIf
							cString +='</Comp>'
							(cAliasTagI)->(dbSkip())
						EndDo
					EndIf
					(cAliasVPrest)->(DbCloseArea())
					cString += '</vPrest>'
					aAdd(aXMLCTe,AllTrim(cString))
					(cAliasTagI)->(DbCloseArea())

					//�����������������������������������������������������������������Ŀ
					//� Valores referente a base icms e valor do credito presumido      �
					//�������������������������������������������������������������������
					nVcred  := 0
					cAliasRBC := GetNextAlias()
					cQuery := " SELECT F4_BASEICM, F4_CRDPRES, D1_VALICM " + CRLF
					cQuery += "   FROM " + RetSqlName("SD1") + " D1," + RetSqlName("SF4") + " F4 "  + CRLF
					cQuery += "  WHERE D1.D1_FILIAL  = '"  + xFilial('SD1') + "'" + CRLF
					cQuery += "    AND D1.D1_DOC     = '"  + cNota		+ "'" + CRLF
					cQuery += "    AND D1.D1_SERIE   = '"  + cSerie		+ "'" + CRLF
					cQuery += "    AND D1.D1_FORNECE = '"  + cClieFor	+ "'" + CRLF
					cQuery += "    AND D1.D1_LOJA    = '"  + cLoja		+ "'" + CRLF
					cQuery += "    AND D1.D_E_L_E_T_ = ' '" + CRLF
					//-- Cadastro TES
					cQuery += "    AND F4.F4_FILIAL	= '"  + xFilial('SF4') + "'" + CRLF
					cQuery += "    AND F4.F4_CODIGO	= D1.D1_TES" + CRLF
					cQuery += "    AND F4.D_E_L_E_T_= ' '"
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasRBC, .F., .T.)
					While !(cAliasRBC)->(Eof())
						If (cAliasRBC)->F4_BASEICM > 0
							cpRdBC := AllTrim(Str(100-(cAliasRBC)->F4_BASEICM ))
						EndIf
						nVcred  += ((cAliasRBC)->F4_CRDPRES*(cAliasRBC)->D1_VALICM)
						(cAliasRBC)->(dbSkip())
					EndDo
					(cAliasRBC)->(DbCloseArea())

					//�����������������������������������������������������������������Ŀ
					//� TAG: J- Informacoes relativas aos Impostos                      �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� Incluso as TAGS referentes as modalidades de tributacao do ICMS �
					//�������������������������������������������������������������������
					cAliasTagJ := GetNextAlias()
					cQuery := " SELECT SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_CLASFIS, SD1.D1_PICM, " + CRLF
					cQuery += "    MAX(SD1.D1_ALIQSOL) D1_ALIQSOL, " + CRLF
					cQuery += "    SUM(SD1.D1_BASEICM) D1_BASEICM, " + CRLF
					cQuery += "    SUM(SD1.D1_VALICM)  D1_VALICM   " + CRLF
					cQuery += "  FROM " + RetSqlName('SD1') + " SD1 " + CRLF
					cQuery += "  WHERE SD1.D1_FILIAL  = '" + xFilial('SD1') + "'" + CRLF
					cQuery += "    AND SD1.D1_DOC     = '" + cNota    + "'" + CRLF
					cQuery += "    AND SD1.D1_SERIE   = '" + cSerie   + "'" + CRLF
					cQuery += "    AND SD1.D1_FORNECE = '" + cClieFor + "'" + CRLF
					cQuery += "    AND SD1.D1_LOJA    = '" + cLoja    + "'" + CRLF
					cQuery += "    AND SD1.D_E_L_E_T_ = ' '" + CRLF
					cQuery += "  GROUP BY SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_CLASFIS, SD1.D1_PICM "
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTagJ, .F., .T.)
					While !(cAliasTagJ)->(Eof())
						cString := '<imp>'
						
						//���������������������������������Ŀ
						//� Informacoes relativas ao ICMS	�
						//�����������������������������������
						cString += '<ICMS>'
						
						If SubStr((cAliasTagJ)->D1_CLASFIS, 2, 2) == '00'
							
							cString += '<ICMS00>'
							cString += '<CST>00</CST>'
							cString += '<vBC>'  + ConvType((cAliasTagJ)->D1_BASEICM, 15, 2, "N") + '</vBC>'
							cString += '<pICMS>'+ ConvType((cAliasTagJ)->D1_PICM,     5, 2, "N") + '</pICMS>'
							cString += '<vICMS>'+ ConvType((cAliasTagJ)->D1_VALICM , 15, 2, "N") + '</vICMS>'
							cString += '</ICMS00>'
						ElseIf SubStr((cAliasTagJ)->D1_CLASFIS, 2, 2) $ "40,41,51"
							//�����������������������������������������Ŀ
							//� ICMS Isento, nao Tributado ou dIferido  �
							//� - 40: ICMS Isencao                      �
							//� - 41: ICMS Nao Tributada                �
							//� - 51: ICMS DIferido                     �
							//�������������������������������������������
							cString += '<ICMS45>'
							
							If SubStr((cAliasTagJ)->D1_CLASFIS, 2, 2)  == '40'
								cString += '<CST>40</CST>'
							ElseIf SubStr((cAliasTagJ)->D1_CLASFIS, 2, 2) == '41'
								cString += '<CST>41</CST>'
							ElseIf SubStr((cAliasTagJ)->D1_CLASFIS, 2, 2) == '51'
								cString += '<CST>51</CST>'
							EndIf
							cString += '</ICMS45>'
						ElseIf SubStr((cAliasTagJ)->D1_CLASFIS, 2, 2) == "60"
							//�����������������������������������������������������������������Ŀ
							//� - 60: ICMS cobrado por substitui��o tribut�ria.                 �
							//� Responsabilidade do recolhimento do ICMS atribu�do              �
							//� ao tomadorou 3o por ST.                                         �
							//� CST60 - ICMS cobrado anteriormente por substituicao tributaria  �
							//�������������������������������������������������������������������
							cString += '<ICMS60>'
							//-- ICMS cobrado anteriormente por substituicao tributaria
							cString += '<CST>60</CST>'
							If !Empty((cAliasTagJ)->D1_BASEICM) .And. !Empty((cAliasTagJ)->D1_PICM) .And. !Empty((cAliasTagJ)->D1_VALICM) 
								cString += '<vBCSTRet>'  + ConvType((cAliasTagJ)->D1_BASEICM	, 15, 2, "N") + '</vBCSTRet>'
								cString += '<vICMSSTRet>'+ ConvType((cAliasTagJ)->D1_VALICM	, 15, 2, "N") + '</vICMSSTRet>'
								cString += '<pICMSSTRet>'+ ConvType((cAliasTagJ)->D1_PICM		,  5, 2, "N") + '</pICMSSTRet>'
								cString += '<vCred>'     + ConvType(nVcred						, 15, 2, "N") + '</vCred>'
							EndIf
							cString += '</ICMS60>'
						ElseIf SubStr((cAliasTagJ)->D1_CLASFIS, 2, 2) $ "10,30,70"
							//�����������������������������������������������������������������Ŀ
							//� - 80: ICMS pagto atribuido ao tomador ou ao 3o previsto para    �
							//� substituicao tributaria                                         �
							//�������������������������������������������������������������������
							cString += '<ICMS90>'
							cString += '<CST>90</CST>'
							cString += '<vBC>'  + ConvType((cAliasTagJ)->D1_BASEICM, 13, 2, "N") + '</vBC>'
							cString += '<pICMS>'+ ConvType((cAliasTagJ)->D1_PICM   ,  5, 2, "N") + '</pICMS>'
							cString += '<vICMS>'+ ConvType((cAliasTagJ)->D1_VALICM , 13, 2, "N") + '</vICMS>'
							cString += '</ICMS90>'
						ElseIf SubStr((cAliasTagJ)->D1_CLASFIS, 2, 2) $ '20,90' .Or. AllTrim(cCFOP) $ "5932,6932"
							//�����������������������������������������������������������������Ŀ
							//� - 81: ICMS DEVIDOS A OUTRAS UF'S                                �
							//� - 90: ICMS Outros                                               �
							//�������������������������������������������������������������������
							If (SubStr((cAliasTagJ)->D1_CLASFIS, 2, 2) == '20')
								cString += '<ICMS20>'
								cString += '<CST>20</CST>'
								If !Empty(cpRedBC)
									cString += '<pRedBC>' + ConvType(cpRedBC, 5, 2, "N") + '</pRedBC>'
								EndIf
								cString += '<vBC>'  + ConvType((cAliasTagJ)->D1_BASEICM, 13, 2, "N") + '</vBC>'
								cString += '<pICMS>'+ ConvType((cAliasTagJ)->D1_PICM   ,  5, 2, "N") + '</pICMS>'
								cString += '<vICMS>'+ ConvType((cAliasTagJ)->D1_VALICM , 13, 2, "N") + '</vICMS>'
								cString += '</CST20>'
								cString += '</ICMS20>'
							Else
								If (SubStr((cAliasTagJ)->D1_CLASFIS, 2, 2) == '90')
									cString += '<ICMS90>'
								Else
									cString += '<CST81>'
								EndIf
								cString += '<CST>90</CST>'
								If !Empty(cpRedBC)
									cString += '<pRedBC>' + ConvType(cpRedBC, 5, 2, "N") + '</pRedBC>'
								EndIf
								cString += '<vBC>'  + ConvType((cAliasTagJ)->D1_BASEICM, 13, 2, "N") + '</vBC>'
								cString += '<pICMS>'+ ConvType((cAliasTagJ)->D1_PICM   ,  5, 2, "N") + '</pICMS>'
								cString += '<vICMS>'+ ConvType((cAliasTagJ)->D1_VALICM , 13, 2, "N") + '</vICMS>'

								If (SubStr((cAliasTagJ)->D1_CLASFIS, 2, 2) == '90') 
									cString += '</ICMS90>'
								Else
									cString += '</CST81>'
								EndIf
							EndIf
						EndIf
						cString += '</ICMS>'
						// Observa��es das regras de Tributa��o (campo Memo)
						DbSelectArea("DT6")
						cObs := StrTran(MsMM((cAliasDT6)->DT6_CODMSG),Chr(13),"")
						If !Empty(cObs)
							cString +=  '<infAdFisco>' + NoAcentoCte(SubStr(cObs,1,320)) + '</infAdFisco>'
						EndIf
						cString += '</imp>'
						(cAliasTagJ)->(dbSkip())
						aAdd(aXMLCTe,AllTrim(cString))
					EndDo
					(cAliasTagJ)->(DbCloseArea())

					//�����������������������������������������������������������������Ŀ
					//� TAG: K - Informacoes de CT-e Normal                             �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� TAG: L - Informacoes da Carga Transportada                      �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� TAG:  Informacao dos Documentos de Transporte Anterior          �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� TAG: M - Dados Especificos do Modal Rodoviario                  �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� TAG: Veic -- Tag com informacoes do veiculo quando o servico for�
					//� de lotacao e possuir viagem relacionada                         �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� TAG: tpVei -- Se for o primeiro veiculo ser� Tra��o = 0         �
					//� caso contr�rio ser� reboque = 1                                 �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� TAG: Prop -- Se o veiculo for de terceiros, preencher tags com  �
					//� informacoes do propriet�rio                                     �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� TAG: N - Dados EspecIficos do Transporte de Produtos Perigosos  �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� TAG: O - CT-e Complementar                                      �
					//�������������������������������������������������������������������
					//�����������������������������������������������������������������Ŀ
					//� TAG: P - CT-e do Tipo Anulacao de Valores	                    �
					//�������������������������������������������������������������������
					cString := '<infCteAnu>'
					//-- Chave do Cte Original
					cString += '<chCte>'	+ (cAliasDT6)->DT6_CHVCTE + '</chCte>'
					cString += '<dEmi>'		+ SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 1, 4) + "-";
											+ SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 5, 2) + "-";
											+ SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 7, 2) + '</dEmi>'
					cString += '</infCteAnu>'
					aAdd(aXMLCTe,AllTrim(cString))
					//�����������������������������������������������������������������Ŀ
					//� TAG Responsavel em Fechar os Dados do CTe                       �
					//�������������������������������������������������������������������
					(cAliasDT6)->(DbSkip())
				EndDo // (02)

				cString := '</infCte>'
				aAdd(aXMLCTe,AllTrim(cString))
				
				//�����������������������������������������������������������������Ŀ
				//� Botton do Arquivo XML                                           �
				//�������������������������������������������������������������������
				cString := '</CTe>'
				cString += '</infNFe>'
				
				aAdd(aXMLCTe,AllTrim(cString))
				
				//�����������������������������������������������������������������Ŀ
				//�  Atualiza��o da chave de acesso na tabela SF1                   �
				//�������������������������������������������������������������������
				If Empty(SF1->F1_CHVNFE) 
					cQuery := " UPDATE " + RetSqlName("SF1") + CRLF
					cQuery += "    SET F1_CHVNFE = '" + cChvAcesso + "' " + CRLF
					cQuery += "  WHERE F1_FILIAL  = '" + xFilial('SF1') + "'" + CRLF
					cQuery += "    AND F1_DOC     = '" + cNota    + "' " + CRLF
					cQuery += "    AND F1_SERIE   = '" + cSerie  + "' " + CRLF
					cQuery += "    AND F1_FORNECE = '" + cClieFor    + "' " + CRLF
					cQuery += "    AND F1_LOJA    = '" + cLoja  + "' " + CRLF
					cQuery += "    AND D_E_L_E_T_ = ' ' "
					TCSqlExec( cQuery )
				EndIf
			EndIf // (01)
			
			cString := ''
			For nCount := 1 To Len(aXMLCTe)
				cString += AllTrim(aXMLCTe[nCount])
			Next nCount
		EndIf
	EndIf
EndIf

Return({cNfe,EncodeUTF8(cString)})
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NFESEFAZ  �Autor  �Microsiga           � Data �  08/03/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ConvType(xValor,nTam,nDec)

Local   cNovo := ""
Default nDec  := 0

Do Case
	Case ValType(xValor)=="N"
		cNovo := AllTrim(Str(xValor,nTam,nDec))
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		Default nTam := 60
		cNovo := NoAcentoCte(SubStr(xValor,1,nTam))
EndCase
Return(cNovo)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NFESEFAZ  �Autor  �Microsiga           � Data �  08/03/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Inverte(uCpo)

Local cCpo	:= uCpo
Local cRet	:= ""
Local cByte	:= ""
Local nAsc	:= 0
Local nI	:= 0
Local aChar	:= {}
Local nDiv	:= 0

aAdd(aChar,	{"0", "9"})
aAdd(aChar,	{"1", "8"})
aAdd(aChar,	{"2", "7"})
aAdd(aChar,	{"3", "6"})
aAdd(aChar,	{"4", "5"})
aAdd(aChar,	{"5", "4"})
aAdd(aChar,	{"6", "3"})
aAdd(aChar,	{"7", "2"})
aAdd(aChar,	{"8", "1"})
aAdd(aChar,	{"9", "0"})

For nI:= 1 to Len(cCpo)
	cByte := Upper(Subs(cCpo,nI,1))
	If	(Asc(cByte) >= 48 .And. Asc(cByte) <= 57) .Or. ;	// 0 a 9
		(Asc(cByte) >= 65 .And. Asc(cByte) <= 90) .Or. ;	// A a Z
		Empty(cByte)	// " "
		nAsc	:= Ascan(aChar,{|x| x[1] == cByte})
		If nAsc > 0
			cRet := cRet + aChar[nAsc,2]	// Funcao Inverte e chamada pelo rdmake de conversao
		EndIf
	Else
		// Caracteres <> letras e numeros: mantem o caracter
		cRet := cRet + cByte
	EndIf
Next
Return(cRet)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CTeCHVAC �       � N3-DL                 � Data �19.03.2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao responsavel em montar a Chave de Acesso             ���
���          � a SEFAZ e calcular o seu digito verIficador.               ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CTeCHVAC(cUF, cAAMM, cCNPJ, cMod, cSerie, nCT, cCT)        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cUF...: Codigo da UF                                       ���
���          � cAAMM.: Ano (2 Digitos) + Mes da Emissao do CTe            ���
���          � cCNPJ.: CNPJ do Emitente do CTe                            ���
���          � cMod..: Modelo (57 = CTe)                                  ���
���          � cSerie: Serie do CTe                                       ���
���          � nCT...: Numero do CTe                                      ���
���          � cCT...: Numero do Lote de Envio a SEFAZ                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Explicacao do Calculo se encontra no manual do CT-e        ���
���          � disponibilizado pela SEFAZ na versao atual 1.02,           ���
���          � pag: 77 e 78                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CTeCHVAC(cUF, cAAMM, cCNPJ, cMod, cSerie, nCT, cCT)
Local nCount      := 0
Local nSequenc    := 2
Local nPonderacao := 0
Local cResult     := ''
Local cChvAcesso  := cUF +  cAAMM + cCNPJ + cMod + cSerie + nCT + cCT

// A partir da vers�o 1.04 do leiaute do CT-e, o campo tpEmis (forma de emiss�o da CT-e) passou
// a compor a chave de acesso da seguinte forma:
// O tamanho do campo cCT � c�digo num�rico do CT-e �foi reduzido para oito posi��espara n�o
// alterar o tamanho da chave de acesso do CT-e de 44 posi��es que passa sercomposta pelos
// seguintes campos que se encontram dispersos no CT-e :
// cUF    - Codigo da UF do emitente do Documento Fiscal
// AAMM   - Ano (2 Digitos) e Mes de emiss�o do CT-e
// CNPJ   - CNPJ do emitente
// mod    - Modelo do Documento Fiscal (57 = CTe)
// serie  - Serie do Documento Fiscal
// nCT    - Numero do Documento Fiscal
// tpEmis - Forma de emiss�o do CT-e
// cCT    - Codigo Numurico que compoe a Chave de Acesso
// cDV    - Digito Verificador da Chave de Acesso

//�����������������������������������������������������������������Ŀ
//�SEQUENCIA DE MULTIPLICADORES (nSequenc), SEGUE A SEGUINTE        �
//�ORDENACAO NA SEQUENCIA: 2,3,4,5,6,7,8,9,2,3,4... E PRECISA SER   �
//�GERADO DA DIREITA PARA ESQUERDA, SEGUINDO OS CARACTERES          �
//�EXISTENTES NA CHAVE DE ACESSO INFORMADA (cChvAcesso)             �
//�������������������������������������������������������������������
For nCount := Len( AllTrim(cChvAcesso) ) To 1 Step -1
	nPonderacao += ( Val( SubStr( AllTrim(cChvAcesso), nCount, 1) ) * nSequenc )
	nSequenc += 1
	If (nSequenc == 10)
		nSequenc := 2
	EndIf
Next nCount

//�����������������������������������������������������������������Ŀ
//� Quando o resto da divis�o for 0 (zero) ou 1 (um), o DV devera   �
//� ser igual a 0 (zero).                                           �
//�������������������������������������������������������������������
If ( mod(nPonderacao,11) > 1)
	cResult := (cChvAcesso + cValToChar( (11 - mod(nPonderacao,11) ) ) )
Else
	cResult := (cChvAcesso + '0')
EndIf

Return(cResult)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NoPontos  �Autor  �Andre Godoi         � Data �  20/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retira caracteres dIferentes de numero, como, ponto,       ���
���          �virgula, barra, traco                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function NoPontos(cString)
Local cChar     := ""
Local nX        := 0
Local cPonto    := "."
Local cBarra    := "/"
Local cTraco    := "-"
Local cVirgula  := ","
Local cBarraInv := "\"
Local cPVirgula := ";"
Local cUnderline:= "_"
Local cParent   := "()"

For nX:= 1 To Len(cString)
	cChar := SubStr(cString, nX, 1)
	If cChar$cPonto+cVirgula+cBarra+cTraco+cBarraInv+cPVirgula+cUnderline+cParent
		cString := StrTran(cString,cChar,"")
		nX := nX - 1
	EndIf
Next
cString := AllTrim(_NoTags(cString))

Return cString
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CTeCHCTG �Autor  � JfsBarreto            � Data �19.03.2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao responsavel em montar a Chave de Acesso auxiliar    ���
���          � a SEFAZ e calcular o seu digito verIficador.               ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CTeCHCTG(cUF, tpEmis,CNPJ,VCT,ICMSp,ICMSs,DD)              ���
�������������������������������������������������������������������������Ĵ��
���          �- cUF    - 02 = C�digo da UF                                ���
���          �- tpEmis - 01 = Forma de Emiss�o                            ���
���          �- CNPJ   - 14 = CNPJ do destinat�rio                        ���
���          �- vCT    - 14 = Valor Total do Servi�o                      ���
���          �- ICMSp  - 01 = Destaque de ICMS pr�prio                    ���
���          �- ICMSs  - 01 = Destaque de ICMS por substitui��o tribut�ria���
���          �- DD     - 02 = Dia da emiss�o                              ���
���          �- DV     - 01 = D�gito Verificador                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Explicacao do Calculo se encontra no manual do CT-e        ���
���          � disponibilizado pela SEFAZ na versao atual 1.02,           ���
���          � pag: 77 e 78                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CTeCHCTG(cUF,tpEmis,cCNPJ, cvCT, cICMSp, cICMSs, cDD)
Local nCount      := 0
Local nSequenc    := 2
Local nPonderacao := 0
Local cResult     := ''
Local cChvCTG  := cUF +  tpEmis + cCNPJ + cvCT + cICMSp + cICMSs + cDD

//�����������������������������������������������������������������Ŀ
//�SEQUENCIA DE MULTIPLICADORES (nSequenc), SEGUE A SEGUINTE        �
//�ORDENACAO NA SEQUENCIA: 2,3,4,5,6,7,8,9,2,3,4... E PRECISA SER   �
//�GERADO DA DIREITA PARA ESQUERDA, SEGUINDO OS CARACTERES          �
//�EXISTENTES NA CHAVE DE ACESSO INFORMADA (cChvAcesso)             �
//�������������������������������������������������������������������
For nCount := Len( AllTrim(cChvCTG) ) To 1 Step -1
	nPonderacao += ( Val( SubStr( AllTrim(cChvCTG), nCount, 1) ) * nSequenc )
	nSequenc += 1
	If (nSequenc == 10)
		nSequenc := 2
	EndIf

Next nCount

//�����������������������������������������������������������������Ŀ
//� Quando o resto da divis�o for 0 (zero) ou 1 (um), o DV devera   �
//� ser igual a 0 (zero).                                           �
//�������������������������������������������������������������������
If ( mod(nPonderacao,11) > 1)
	cResult := (cChvCTG + cValToChar( (11 - mod(nPonderacao,11) ) ) )
Else
	cResult := (cChvCTG + '0')
EndIf

Return(cResult)
