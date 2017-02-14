#include "protheus.ch"
#include "tbiconn.ch"

//-----------------------------------------------------------------------
/*/{Protheus.doc} nfseXMLEnv
Função que monta o XML Unico de envio para NFS-e TSS / TOTVS Colaboracao 2.0

@author Marcos Taranta
@since 19.01.2012

@param	cTipo		Tipo do documento.
@param	dDtEmiss	Data de emissão do documento.
@param	cSerie		Serie do documento.
@param	cNota		Numero do documento.
@param	cClieFor	Cliente/Fornecedor do documento.
@param	cLoja		Loja do cliente/fornecedor do documento.
@param	cMotCancela	Motivo do cancelamento do documento.

@return	cString		Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------
User function nfseXMLUni( cCodMun, cTipo, dDtEmiss, cSerie, cNota, cClieFor, cLoja, cMotCancela, aAIDF )

	Local nX		:= 0
	Local nW		:= 0
	Local nZ		:= 0

	Local oWSNfe

	Local cString    := ""
	Local cAliasSE1  := "SE1"
	Local cAliasSD1  := "SD1"
	Local cAliasSD2  := "SD2"
	Local cNatOper   := ""
	Local cModFrete  := ""
	Local cScan      := ""
	Local cEspecie   := ""
	Local cMensCli   := ""
	Local cMensFis   := ""
	Local cNFe       := ""
	Local cMV_LJTPNFE:= SuperGetMV("MV_LJTPNFE", ," ")
	lOCAL cMVSUBTRIB := IIf(FindFunction("GETSUBTRIB"), GetSubTrib(), SuperGetMv("MV_SUBTRIB"))
	Local cLJTPNFE   := ""
	Local cWhere     := ""
	Local cMunISS    := ""
	Local cTipoPcc   := "PIS','COF','CSL','CF-','PI-','CS-"
	Local cCodCli    := ""
	Local cLojCli    := ""
	Local cDescMunP  := ""
	local cMunPSIAFI := ""
	local cMunPrest  := ""
	Local cDescrNFSe := ""
	Local cDiscrNFSe := ""
	Local cField     := ""
	Local cTpCliente := ""
	Local cMVBENEFRJ := AllTrim(GetNewPar("MV_BENEFRJ"," "))
	Local cF4Agreg   := ""
	Local cNatOP     := "1"
	Local cFieldMsg  := ""
	Local cTpPessoa  := ""
	Local cCamSC5    := SuperGetMV("MV_NFSECOM", .F., "") // Parametro que aponta para o campo do SC5 com a data da competencia

	Local dDateCom 	:= Date()

	Local nRetPis   := 0
	Local nRetCof   := 0
	Local nRetCsl   := 0
	Local nPosI     := 0
	Local nPosF     := 0
	Local nAliq     := 0
	Local nCont     := 0
	Local nDescon   := 0
	Local nScan     := 0
	Local nRetDesc  := 0
	Local nBasCsl   := 0
	Local nBasCof   := 0
	Local nBasPis   := 0
	

	Local lQuery    := .F.
	Local lCalSol   := .F.
	Local lEasy     := SuperGetMV("MV_EASY") == "S"
	Local lEECFAT   := SuperGetMv("MV_EECFAT")
	Local lAglutina := AllTrim(GetNewPar("MV_ITEMAGL","N")) == "S" //-- Aglutinar ITENS do RPS na geracao do XML
	Local lNatOper  := GetNewPar("MV_NFESERV","1") == "1" //-- Descr do servico 1-pedido vendas+SX5 ou 2-somente SX5
	Local lNFeDesc  := GetNewPar("MV_NFEDESC",.F.) //-- Descr do servico = pela tab. 60 e do produto = pedidos de vendas
	Local lNfsePcc  := GetNewPar("MV_NFSEPCC",.F.) //-- Considerar retencao de PIS, COF, CSLL
	Local lCrgTrib  := GetNewPar("MV_CRGTRIB",.F.)

	Local aNota     := {}
	Local aDupl     := {}
	Local aDest     := {}
	Local aEntrega  := {}
	Local aProd     := {}
	Local aICMS     := {}
	Local aICMSST   := {}
	Local aIPI      := {}
	Local aPIS      := {}
	Local aCOFINS   := {}
	Local aPISST    := {}
	Local aCOFINSST := {}
	Local aISSQN    := {}
	Local aISS      := {}
	Local aCST      := {}
	Local aRetido   := {}
	Local aTransp   := {}
	Local aImp      := {}
	Local aVeiculo  := {}
	Local aReboque  := {}
	Local aEspVol   := {}
	Local aNfVinc   := {}
	Local aPedido   := {}
	Local aTotal    := {0,0,""}
	Local aOldReg   := {}
	Local aOldReg2  := {}
	Local aMed      := {}
	Local aArma     := {}
	Local aveicProd := {}
	Local aIEST     := {}
	Local aDI       := {}
	Local aAdi      := {}
	Local aExp      := {}
	Local aPisAlqZ  := {}
	Local aCofAlqZ  := {}
	Local aDeducao  := {}
	Local aRetServ  := {}
	Local aDeduz    := {}
	Local aConstr   := {}
	Local aRetISS   := {}
	Local aRetPIS   := {}
	Local aRetCOF   := {}
	Local aRetCSL   := {}
	Local aRetIRR   := {}
	Local aRetINS   := {}

	Private aUF     := {}

	DEFAULT cCodMun     := PARAMIXB[1]
	DEFAULT cTipo       := PARAMIXB[2]
	DEFAULT cSerie      := PARAMIXB[4]
	DEFAULT cNota       := PARAMIXB[5]
	DEFAULT cClieFor    := PARAMIXB[6]
	DEFAULT cLoja       := PARAMIXB[7]
	DEFAULT cMotCancela := PARAMIXB[8]
//	DEFAULT aAIDF       := PARAMIXB[9]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Preenchimento do Array de UF                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aUF,{"RO","11"})
	aadd(aUF,{"AC","12"})
	aadd(aUF,{"AM","13"})
	aadd(aUF,{"RR","14"})
	aadd(aUF,{"PA","15"})
	aadd(aUF,{"AP","16"})
	aadd(aUF,{"TO","17"})
	aadd(aUF,{"MA","21"})
	aadd(aUF,{"PI","22"})
	aadd(aUF,{"CE","23"})
	aadd(aUF,{"RN","24"})
	aadd(aUF,{"PB","25"})
	aadd(aUF,{"PE","26"})
	aadd(aUF,{"AL","27"})
	aadd(aUF,{"MG","31"})
	aadd(aUF,{"ES","32"})
	aadd(aUF,{"RJ","33"})
	aadd(aUF,{"SP","35"})
	aadd(aUF,{"PR","41"})
	aadd(aUF,{"SC","42"})
	aadd(aUF,{"RS","43"})
	aadd(aUF,{"MS","50"})
	aadd(aUF,{"MT","51"})
	aadd(aUF,{"GO","52"})
	aadd(aUF,{"DF","53"})
	aadd(aUF,{"SE","28"})
	aadd(aUF,{"BA","29"})
	aadd(aUF,{"EX","99"})
	
	If cTipo == "1" .And. Empty(cMotCancela)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona NF                                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SF2")
		dbSetOrder(1) //F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, R_E_C_N_O_, D_E_L_E_T_
		DbGoTop()
		If DbSeek(xFilial("SF2")+cNota+cSerie+cClieFor+cLoja)

			//-- Posiciona na condicao de pagamento
			DbSelectArea("SE4")
			DbSetOrder(1) //E4_FILIAL+E4_CODIGO
			DbSeek(xFilial("SE4")+SF2->F2_COND)

			aadd(aNota,SF2->F2_SERIE)
			aadd(aNota,IIF(Len(SF2->F2_DOC)==6,"000","")+SF2->F2_DOC)
			aadd(aNota,SF2->F2_EMISSAO)
			aadd(aNota,cTipo)
			aadd(aNota,SF2->F2_TIPO)
			aadd(aNota,"1")
			aadd(aNota,IIF(Len(SF2->F2_DOC)==6,"000","")+AllTrim(SF2->F2_NFSUBST))
			aadd(aNota,AllTrim(SF2->F2_SERSUBS))
			aadd(aNota,AllTrim(SE4->E4_DESCRI))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona cliente ou fornecedor                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !SF2->F2_TIPO $ "DB"
				If IntTMS()
					DT6->(DbSetOrder(1))
					If DT6->(DbSeek(xFilial("DT6")+SF2->(F2_FILIAL+F2_DOC+F2_SERIE)))
						cCodCli := DT6->DT6_CLIDES
						cLojCli := DT6->DT6_LOJDES
					Else
						cCodCli := SF2->F2_CLIENTE
						cLojCli := SF2->F2_LOJA
					EndIf
				Else
					cCodCli := SF2->F2_CLIENTE
					cLojCli := SF2->F2_LOJA
				EndIf

				dbSelectArea("SA1")
				dbSetOrder(1) //A1_FILIAL+A1_COD+A1_LOJA
				DbSeek(xFilial("SA1")+cCodCli+cLojCli)
				
				aadd(aDest,AllTrim(SA1->A1_CGC))
				aadd(aDest,SA1->A1_NOME)
				aadd(aDest,myGetEnd(SA1->A1_END,"SA1")[1])
				aadd(aDest,convType(IIF(myGetEnd(SA1->A1_END,"SA1")[2]<>0,myGetEnd(SA1->A1_END,"SA1")[2],"SN")))
				aadd(aDest,IIF(SA1->(FieldPos("A1_COMPLEM")) > 0 .And. !Empty(SA1->A1_COMPLEM),SA1->A1_COMPLEM,myGetEnd(SA1->A1_END,"SA1")[4]))
				aadd(aDest,SA1->A1_BAIRRO)
				If !Upper(SA1->A1_EST) == "EX"
					aadd(aDest,SA1->A1_COD_MUN)
					aadd(aDest,SA1->A1_MUN)
				Else
					aadd(aDest,"99999")
					aadd(aDest,"EXTERIOR")
				EndIf
				aadd(aDest,Upper(SA1->A1_EST))
				aadd(aDest,SA1->A1_CEP)
				aadd(aDest,IIF(Empty(SA1->A1_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_SISEXP")))
				aadd(aDest,IIF(Empty(SA1->A1_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR" )))
				aadd(aDest,SA1->A1_DDD+SA1->A1_TEL)
				aadd(aDest,vldIE(SA1->A1_INSCR,IIF(SA1->(FIELDPOS("A1_CONTRIB"))>0,SA1->A1_CONTRIB<>"2",.T.)))
				aadd(aDest,SA1->A1_SUFRAMA)
				aadd(aDest,SA1->A1_EMAIL)
				aadd(aDest,SA1->A1_INSCRM)
				aadd(aDest,SA1->A1_CODSIAF)
				aadd(aDest,SA1->A1_NATUREZ)
				aadd(aDest,Iif(!Empty(SA1->A1_SIMPNAC),SA1->A1_SIMPNAC,"2"))
				aadd(aDest,Iif(SA1->(FieldPos("A1_INCULT"))> 0 , Iif(!Empty(SA1->A1_INCULT),SA1->A1_INCULT,"2"), "2"))
				aadd(aDest,SA1->A1_TPESSOA)
				aadd(aDest,SF2->F2_DOC)
				aadd(aDest,SF2->F2_SERIE)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posiciona Natureza                                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SED")
				DbSetOrder(1) //ED_FILIAL+ED_CODIGO
				DbSeek(xFilial("SED")+SA1->A1_NATUREZ)
				
				If SF2->(FieldPos("F2_CLIENT"))<>0 .And. !Empty(SF2->F2_CLIENT+SF2->F2_LOJENT) .And. SF2->F2_CLIENT+SF2->F2_LOJENT<>SF2->F2_CLIENTE+SF2->F2_LOJA
					dbSelectArea("SA1")
					dbSetOrder(1)
					DbSeek(xFilial("SA1")+SF2->F2_CLIENT+SF2->F2_LOJENT)
					
					aadd(aEntrega,SA1->A1_CGC)
					aadd(aEntrega,myGetEnd(SA1->A1_END,"SA1")[1])
					aadd(aEntrega,convType(IIF(myGetEnd(SA1->A1_END,"SA1")[2]<>0,myGetEnd(SA1->A1_END,"SA1")[2],"SN")))
					aadd(aEntrega,myGetEnd(SA1->A1_END,"SA1")[4])
					aadd(aEntrega,SA1->A1_BAIRRO)
					aadd(aEntrega,SA1->A1_COD_MUN)
					aadd(aEntrega,SA1->A1_MUN)
					aadd(aEntrega,Upper(SA1->A1_EST))

				EndIf

			Else
				dbSelectArea("SA2")
				dbSetOrder(1)
				DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)

				aadd(aDest,AllTrim(SA2->A2_CGC))
				aadd(aDest,SA2->A2_NOME)
				aadd(aDest,myGetEnd(SA2->A2_END,"SA2")[1])
				aadd(aDest,convType(IIF(myGetEnd(SA2->A2_END,"SA2")[2]<>0,myGetEnd(SA2->A2_END,"SA2")[2],"SN")))
				aadd(aDest,IIF(SA2->(FieldPos("A2_COMPLEM")) > 0 .And. !Empty(SA2->A2_COMPLEM),SA2->A2_COMPLEM,myGetEnd(SA2->A2_END,"SA2")[4]))				
				aadd(aDest,SA2->A2_BAIRRO)
				If !Upper(SA2->A2_EST) == "EX"
					aadd(aDest,SA2->A2_COD_MUN)
					aadd(aDest,SA2->A2_MUN)
				Else
					aadd(aDest,"99999")
					aadd(aDest,"EXTERIOR")
				EndIf
				aadd(aDest,Upper(SA2->A2_EST))
				aadd(aDest,SA2->A2_CEP)
				aadd(aDest,IIF(Empty(SA2->A2_PAIS),"1058"  ,Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_SISEXP")))
				aadd(aDest,IIF(Empty(SA2->A2_PAIS),"BRASIL",Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR")))
				aadd(aDest,SA2->A2_DDD+SA2->A2_TEL)
				aadd(aDest,vldIE(SA2->A2_INSCR))
				aadd(aDest,"")//SA2->A2_SUFRAMA
				aadd(aDest,SA2->A2_EMAIL)
				aadd(aDest,SA2->A2_INSCRM)
				aadd(aDest,SA2->A2_CODSIAF)
				aadd(aDest,SA2->A2_NATUREZ)
				aadd(aDest,SA2->A2_SIMPNAC)
				aadd(aDest,"")	//Nota para empresa hospitalar utilizar apenas com SF2
				aadd(aDest,"")	//Serie para empresa hospitalar utilizar apenas com SF2

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posiciona Natureza                                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SED")
				DbSetOrder(1)
				DbSeek(xFilial("SED")+SA2->A2_NATUREZ)

			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona transportador                                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(SF2->F2_TRANSP)
				dbSelectArea("SA4")
				dbSetOrder(1)
				DbSeek(xFilial("SA4")+SF2->F2_TRANSP)
				aadd(aTransp,AllTrim(SA4->A4_CGC))
				aadd(aTransp,SA4->A4_NOME)
				aadd(aTransp,SA4->A4_INSEST)
				aadd(aTransp,SA4->A4_END)
				aadd(aTransp,SA4->A4_MUN)
				aadd(aTransp,Upper(SA4->A4_EST)	)
				If !Empty(SF2->F2_VEICUL1)
					dbSelectArea("DA3")
					dbSetOrder(1)
					DbSeek(xFilial("DA3")+SF2->F2_VEICUL1)
					aadd(aVeiculo,DA3->DA3_PLACA)
					aadd(aVeiculo,DA3->DA3_ESTPLA)
					aadd(aVeiculo,"")//RNTC
					If !Empty(SF2->F2_VEICUL2)
						dbSelectArea("DA3")
						dbSetOrder(1)
						DbSeek(xFilial("DA3")+SF2->F2_VEICUL2)
						aadd(aReboque,DA3->DA3_PLACA)
						aadd(aReboque,DA3->DA3_ESTPLA)
						aadd(aReboque,"") //RNTC
					EndIf
				EndIf
			EndIf
			dbSelectArea("SF2")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Volumes                                                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cScan := "1"
			While ( !Empty(cScan) )
				cEspecie := Upper(FieldGet(FieldPos("F2_ESPECI"+cScan)))
				If !Empty(cEspecie)
					nScan := aScan(aEspVol,{|x| x[1] == cEspecie})
					If ( nScan==0 )
						aadd(aEspVol,{ cEspecie, FieldGet(FieldPos("F2_VOLUME"+cScan)) , SF2->F2_PLIQUI , SF2->F2_PBRUTO})
					Else
						aEspVol[nScan][2] += FieldGet(FieldPos("F2_VOLUME"+cScan))
					EndIf
				EndIf
				cScan := Soma1(cScan,1)
				If ( FieldPos("F2_ESPECI"+cScan) == 0 )
					cScan := ""
				EndIf
			EndDo

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Procura duplicatas                                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If !Empty(SF2->F2_DUPL)	
				cLJTPNFE := (StrTran(cMV_LJTPNFE," ,"," ','"))+" "
				cWhere := cLJTPNFE
				dbSelectArea("SE1")
				dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
				#IFDEF TOP
					lQuery  := .T.
					cAliasSE1 := GetNextAlias()
					BeginSql Alias cAliasSE1
						COLUMN E1_VENCORI AS DATE
						SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VENCORI,E1_VALOR,E1_ORIGEM,E1_CSLL,E1_COFINS,E1_PIS,E1_BASECSL,E1_BASECOF,E1_BASEPIS
						FROM %Table:SE1% SE1
						WHERE
						SE1.E1_FILIAL = %xFilial:SE1% AND
						SE1.E1_PREFIXO = %Exp:SF2->F2_PREFIXO% AND 
						SE1.E1_NUM = %Exp:SF2->F2_DUPL% AND 
						((SE1.E1_TIPO = %Exp:MVNOTAFIS%) OR
						 SE1.E1_TIPO IN (%Exp:cTipoPcc%) OR
						 (SE1.E1_ORIGEM = 'LOJA701' AND SE1.E1_TIPO IN (%Exp:cWhere%))) AND
						SE1.%NotDel%
						ORDER BY %Order:SE1%
					EndSql
					
				#ELSE
					DbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC)
				#ENDIF
				While !Eof() .And. xFilial("SE1") == (cAliasSE1)->E1_FILIAL .And.;
					SF2->F2_PREFIXO == (cAliasSE1)->E1_PREFIXO .And.;
					SF2->F2_DOC == (cAliasSE1)->E1_NUM
					If 	(cAliasSE1)->E1_TIPO = MVNOTAFIS .OR. ((cAliasSE1)->E1_ORIGEM = 'LOJA701' .AND. (cAliasSE1)->E1_TIPO $ cWhere)
						aadd(aDupl,{/*Neogrid não processa alfanumerico*/ "000"+Alltrim((cAliasSE1)->E1_NUM)+Alltrim((cAliasSE1)->E1_PARCELA),(cAliasSE1)->E1_VENCORI,(cAliasSE1)->E1_VALOR,(cAliasSE1)->E1_PARCELA})
					EndIf
					//-- Tratamento para saber se existem titulos de retenção de PIS,COFINS e CSLL
					If lNfsePcc
						If Alltrim((cAliasSE1)->E1_TIPO) $ "NF"
							nRetCsl := (cAliasSE1)->E1_CSLL 
							nRetCof	:= (cAliasSE1)->E1_COFINS
							nRetPis := (cAliasSE1)->E1_PIS
							
						EndIf
					Else
						If 	(cAliasSE1)->E1_TIPO $ cTipoPcc
							If (cAliasSE1)->E1_TIPO $ "PIS,PI-"
								nRetPis	:= 	(cAliasSE1)->E1_VALOR
							ElseIf (cAliasSE1)->E1_TIPO $ "COF,CF-"
								nRetCof	:= 	(cAliasSE1)->E1_VALOR
							ElseIf (cAliasSE1)->E1_TIPO $ "CSL,CS-"
								nRetCsl	:= 	(cAliasSE1)->E1_VALOR
							EndIf
						EndIf
					EndIf
					
					If Alltrim((cAliasSE1)->E1_TIPO) $ "NF"
							nBasCsl := (cAliasSE1)->E1_BASECSL
							nBasCof	:= (cAliasSE1)->E1_BASECOF
							nBasPis := (cAliasSE1)->E1_BASEPIS			
					EndIf
					
					dbSelectArea(cAliasSE1)
					dbSkip()
				EndDo
				If lQuery
					dbSelectArea(cAliasSE1)
					dbCloseArea()
					dbSelectArea("SE1")
				EndIf
			Else
				aDupl := {}
			EndIf

			dbSelectArea("SF3")
			dbSetOrder(4)
			If DbSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
					
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se recolhe ISS Retido ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SF3->(FieldPos("F3_RECISS"))>0
					If SF3->F3_RECISS $"1S"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Pega retencao de ISS por item ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						SFT->(dbSetOrder(1))
						SFT->(dbSeek(xFilial("SFT")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA))
						While !SFT->(EOF()) .And. SFT->FT_FILIAL+SFT->FT_TIPOMOV+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA == xFilial("SFT")+"S"+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA
							aAdd(aRetISS,SFT->FT_VALICM)
							SFT->(dbSkip())
						EndDo

						dbSelectArea("SD2")
						dbSetOrder(3)
						dbSeek(xFilial("SD2")+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA)

						aadd(aRetido,{"ISS",0,SF3->F3_VALICM,SD2->D2_ALIQISS,val(SF3->F3_RECISS),aRetISS})
					Endif
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Pega as deduções ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SF3->(FieldPos("F3_ISSSUB"))>0  .And. SF3->F3_ISSSUB > 0
					If len(aDeducao) > 0
						aDeducao [len(aDeducao)] := SF3->F3_ISSSUB  
					Else
						aadd(aDeducao,{SF3->F3_ISSSUB})
					EndIf
				EndIf

				If SF3->(FieldPos("F3_ISSMAT"))>0 .And. SF3->F3_ISSMAT > 0 
					If len(aDeducao) > 0
						for nW := 1 To len(aDeducao)
							aDeducao[nW][1] += SF3->F3_ISSMAT
							exit
						next nW
					Else
						aadd(aDeducao,{SF3->F3_ISSMAT})
					EndIf
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Analisa os impostos de retencao                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
			aadd(aRetido,{"PIS",nBasPis,nRetPis,SED->ED_PERCPIS,aRetPIS})
			
			aadd(aRetido,{"COFINS",nBasCof,nRetCof,SED->ED_PERCCOF,aRetCOF})
			
			aadd(aRetido,{"CSLL",nBasPis,nRetCsl,SED->ED_PERCCSL,aRetCSL})
			
			If SF2->(FieldPos("F2_VALIRRF"))<>0 .and. SF2->F2_VALIRRF>0
				aadd(aRetido,{"IRRF",SF2->F2_BASEIRR,SF2->F2_VALIRRF,SED->ED_PERCIRF,aRetIRR})
			EndIf
			If SF2->(FieldPos("F2_BASEINS"))<>0 .and. SF2->F2_BASEINS>0
				aadd(aRetido,{"INSS",SF2->F2_BASEINS,SF2->F2_VALINSS,SED->ED_PERCINS,aRetINS})
			EndIf
			
			//Verifica tipo do cliente.
			cTpCliente := Alltrim(SF2->F2_TIPOCLI)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Pesquisa itens de nota                                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//////INCLUSAO DE CAMPOS NA QUERY////////////

			cField := "%"

			If SD2->(FieldPos("D2_TOTIMP"))<>0
				cField  +=",D2_TOTIMP"
			EndIf

			If SD2->(FieldPos("D2_DESCICM"))<>0
				cField  +=",D2_DESCICM"
			EndIf
			
			cField += "%"
			
			
			dbSelectArea("SD2")
			dbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM	
			#IFDEF TOP
				lQuery  := .T.
				cAliasSD2 := GetNextAlias()
				BeginSql Alias cAliasSD2
					SELECT D2_FILIAL,D2_SERIE,D2_DOC,D2_CLIENTE,D2_LOJA,D2_COD,D2_TES,D2_NFORI,D2_SERIORI,D2_ITEMORI,D2_TIPO,D2_ITEM,D2_CF,
						D2_QUANT,D2_TOTAL,D2_DESCON,D2_VALFRE,D2_SEGURO,D2_PEDIDO,D2_ITEMPV,D2_DESPESA,D2_VALBRUT,D2_VALISS,D2_PRUNIT,
						D2_CLASFIS,D2_PRCVEN,D2_CODISS,D2_DESCZFR,D2_PREEMB,D2_BASEISS,D2_VALIMP1,D2_VALIMP2,D2_VALIMP3,D2_VALIMP4,D2_VALIMP5,D2_PROJPMS %Exp:cField%,
						D2_VALPIS,D2_VALCOF,D2_VALCSL,D2_VALIRRF,D2_VALINS
					FROM %Table:SD2% SD2
					WHERE
					SD2.D2_FILIAL = %xFilial:SD2% AND
					SD2.D2_SERIE = %Exp:SF2->F2_SERIE% AND 
					SD2.D2_DOC = %Exp:SF2->F2_DOC% AND 
					SD2.D2_CLIENTE = %Exp:SF2->F2_CLIENTE% AND 
					SD2.D2_LOJA = %Exp:SF2->F2_LOJA% AND 
					SD2.%NotDel%
					ORDER BY %Order:SD2%
				EndSql
					
			#ELSE
				DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
			#ENDIF
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona na Construção Cilvil                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty((cAliasSD2)->D2_PROJPMS)
				dbSelectArea("AF8")
				dbSetOrder(1)
				DbSeek(xFilial("AF8")+((cAliasSD2)->D2_PROJPMS))
				If !Empty(AF8->AF8_ART)
					aadd(aConstr,(AF8->AF8_PROJET))
					aadd(aConstr,(AF8->AF8_ART))
					aadd(aConstr,(AF8->AF8_TPPRJ))
				EndIf

			Else
				dbSelectArea("SC5")
				SC5->( dbSetOrder(1) ) //C5_FILIAL+C5_NUM
				If SC5->( MsSeek( xFilial("SC5") + (cAliasSD2)->D2_PEDIDO) )
					If ( SC5->(FieldPos("C5_OBRA")) > 0 .And. !Empty(SC5->C5_OBRA) ) .And. SC5->(FieldPos("C5_ARTOBRA")) > 0
						aadd(aConstr,(SC5->C5_OBRA)) //-- Codigo da Obra
						aadd(aConstr,(SC5->C5_ARTOBRA))
					EndIf
					If SC5->(FieldPos("C5_TIPOBRA")) > 0 .And. !Empty(SC5->C5_TIPOBRA)
						If Len(aConstr) == 0
							aadd(aConstr,"")
							aadd(aConstr,"")
						EndIf
						aadd(aConstr,(SC5->C5_TIPOBRA))
					EndIf
				EndIf
			EndIf
			
			While !(cAliasSD2)->(Eof()) .And. xFilial("SD2") == (cAliasSD2)->D2_FILIAL .And.;
				SF2->F2_SERIE == (cAliasSD2)->D2_SERIE .And.;
				SF2->F2_DOC == (cAliasSD2)->D2_DOC
				
				nCont++
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica a natureza da operacao                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SC5")
				dbSetOrder(1) //C5_FILIAL+C5_NUM
				If DbSeek(xFilial("SC5")+(cAliasSD2)->D2_PEDIDO)
					lSC5 := .T.
				Else
					lSC5 := .F.
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Pega retencoes por item ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aAdd(aRetPIS,Iif(nRetPis > 0, (cAliasSD2)->D2_VALPIS, 0))
				nScan := aScan(aRetido,{|x| x[1] == "PIS"})
				If nScan > 0
					aRetido[nScan][5] := aRetPIS
				EndIf

				aAdd(aRetCOF,Iif(nRetCof > 0, (cAliasSD2)->D2_VALCOF, 0))
				nScan := aScan(aRetido,{|x| x[1] == "COFINS"})
				If nScan > 0
					aRetido[nScan][5] := aRetCOF
				EndIf

				aAdd(aRetCSL,Iif(nRetCsl > 0, (cAliasSD2)->D2_VALCSL, 0))
				nScan := aScan(aRetido,{|x| x[1] == "CSLL"})
				If nScan > 0
					aRetido[nScan][5] := aRetCSL
				EndIf

				aAdd(aRetIRR,Iif(SF2->(FieldPos("F2_VALIRRF")) <> 0 .and. SF2->F2_VALIRRF > 0, (cAliasSD2)->D2_VALIRRF, 0))
				nScan := aScan(aRetido,{|x| x[1] == "IRRF"})
				If nScan > 0
					aRetido[nScan][5] := aRetIRR
				EndIf

				aAdd(aRetINS,Iif(SF2->(FieldPos("F2_BASEINS")) <> 0 .and. SF2->F2_BASEINS > 0, (cAliasSD2)->D2_VALINS, 0))
				nScan := aScan(aRetido,{|x| x[1] == "INSS"})
				If nScan > 0
					aRetido[nScan][5] := aRetINS
				EndIf

				//TRATAMENTO - INTEGRACAO COM TMS-GESTAO DE TRANSPORTES
				If IntTms()
					DT6->(DbSetOrder(1)) //DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
					If DT6->(DbSeek(xFilial("DT6")+SF2->(F2_FILIAL+F2_DOC+F2_SERIE)))
						cModFrete := DT6->DT6_TIPFRE
						
						SA1->(DbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
						If SA1->(DbSeek(xFilial("SA1")+DT6->(DT6_CLIDES+DT6_LOJDES)))
							cMunPSIAFI := SA1->A1_CODSIAFI
						EndIf
						
						If DUY->(FieldPos("DUY_CODMUN")) > 0
							DUY->(DbSetOrder(1))
							If DUY->(DbSeek(xFilial("DUY")+DT6->DT6_CDRDES))
								nPosUF:=aScan(aUF,{|X| X[1] == DUY->DUY_EST})
								If nPosUF > 0 
									cMunPrest:=aUF[nPosUF][2]+AllTrim(DUY->DUY_CODMUN)
								Else
									cMunPrest:=DUY->DUY_CODMUN
								EndIf
							EndIf
						Else
							SA1->(DbSetOrder(1))
							If SA1->(DbSeek(xFilial("SA1")+DT6->(DT6_CLIDES+DT6_LOJDES)))
								cMunPrest := SA1->A1_COD_MUN
							EndIf
						EndIf
					Else
						If lSC5 .And. SC5->(FieldPos("C5_MUNPRES")) > 0 .And. !Empty(SC5->C5_MUNPRES)
							//Quando for preenchido os campos C5_ESTPRES e C5_MUNPRES concatena as informacoes
							If ( len(Alltrim(SC5->C5_MUNPRES)) == 5 .AND. !empty(SC5->C5_ESTPRES) )
								
								For nZ := 1 to len(aUf)
									If Alltrim(SC5->C5_ESTPRES) == aUf[nZ][1]
										cMunPrest := Alltrim(aUf[nZ][2] + Alltrim(SC5->C5_MUNPRES))
										exit
									EndIf
								Next
							Else
								cMunPrest := SC5->C5_MUNPRES
							EndIf
							
							cDescMunP := SC5->C5_DESCMUN
							
						Else
							cMunPrest := aDest[07]
							cDescMunP := aDest[08]
						EndIf
					EndIf
				Else
					If lSC5 .And. SC5->(FieldPos("C5_MUNPRES")) > 0 .And. !Empty(SC5->C5_MUNPRES)
						//Quando for preenchido os campos C5_ESTPRES e C5_MUNPRES concatena as informacoes
						If ( len(Alltrim(SC5->C5_MUNPRES)) == 5 .AND. !empty(SC5->C5_ESTPRES) )
							
							For nZ := 1 to len(aUf)
								If Alltrim(SC5->C5_ESTPRES) == aUf[nZ][1]
									cMunPrest := Alltrim(aUf[nZ][2] + Alltrim(SC5->C5_MUNPRES))
									exit
								EndIf
							Next
						Else
							cMunPrest := SC5->C5_MUNPRES
						EndIf
						
						cDescMunP := SC5->C5_DESCMUN
						
					Else
						cMunPrest := aDest[07]
						cDescMunP := aDest[08]
					EndIf
					// Tratamento para notas com data de Competencia
					If ! Empty(cCamSC5)
						If Fieldpos(cCamSC5)>0
							dDateCom := SC5->&(cCamSC5)
						Else
							dDateCom := CToD("")
						Endif
					Endif
				EndIf

				dbSelectArea("SF4")
				dbSetOrder(1) //F4_FILIAL+F4_CODIGO
				DbSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)

				cF4Agreg := SF4->F4_AGREG
				If SF4->(FieldPos("F4_NATOP")) > 0
					cNatOP := AllTrim(SF4->F4_NATOP)
				EndIf

				//Pega descricao do pedido de venda-Parametro MV_NFESERV
				cFieldMsg := GetNewPar("MV_CMPUSR","")
				If !lNFeDesc
					If lNatOper .And. lSC5 .And. nCont == 1 .and. !Empty(cFieldMsg) .and. SC5->(FieldPos(cFieldMsg)) > 0 .and. !Empty(&("SC5->"+cFieldMsg))
						cNatOper := If(FindFunction('CleanSpecChar'),CleanSpecChar(Alltrim(&("SC5->"+cFieldMsg))),&("SC5->"+cFieldMsg))+" "
					ElseIf lNatOper .And. lSC5 .And. !Empty(SC5->C5_MENNOTA).And. nCont == 1
						cNatOper += If(FindFunction('CleanSpecChar'),CleanSpecChar(Alltrim(SC5->C5_MENNOTA)),SC5->C5_MENNOTA)
						//cNatOper += "$$$"
					EndIf
				Else
					If lSC5 .And. nCont == 1 .and. !Empty(cFieldMsg) .and. SC5->(FieldPos(cFieldMsg)) > 0 .and. !Empty(&("SC5->"+cFieldMsg))
						cDiscrNFSe := If(FindFunction('CleanSpecChar'),CleanSpecChar(Alltrim(&("SC5->"+cFieldMsg))),&("SC5->"+cFieldMsg))+" "
					ElseIf lSC5 .And. !Empty(SC5->C5_MENNOTA).And. nCont == 1
						cDiscrNFSe := If(FindFunction('CleanSpecChar'),CleanSpecChar(Alltrim(SC5->C5_MENNOTA)),SC5->C5_MENNOTA)
						//cDiscrNFSe += "$$$"
					EndIf
				EndIf

				//-- Pega a descricao da SX5 tabela 60
				dbSelectArea("SB1")
				dbSetOrder(1) //B1_FILIAL+B1_COD
				DbSeek(xFilial("SB1")+(cAliasSD2)->D2_COD)

				dbSelectArea("SX5")
				dbSetOrder(1) //X5_FILIAL+X5_TABELA+X5_CHAVE
				If dbSeek(xFilial("SX5")+"60"+RetFldProd(SB1->B1_COD,"B1_CODISS"))
					If !lNFeDesc
						If nCont == 1
							cNatOper   += If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(SubStr(SX5->X5_DESCRI,1,55))),AllTrim(SubStr(SX5->X5_DESCRI,1,55)))
						EndIf
					ElseIf nCont == 1
							cDescrNFSe := If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(SubStr(SX5->X5_DESCRI,1,55))),AllTrim(SubStr(SX5->X5_DESCRI,1,55)))
					EndIf
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica as notas vinculadas                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty((cAliasSD2)->D2_NFORI) 
					If (cAliasSD2)->D2_TIPO $ "DBN"
						dbSelectArea("SD1")
						dbSetOrder(1)
						If DbSeek(xFilial("SD1")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
							dbSelectArea("SF1")
							dbSetOrder(1)
							DbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO)
							If SD1->D1_TIPO $ "DB"
								dbSelectArea("SA1")
								dbSetOrder(1)
								DbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
							Else
								dbSelectArea("SA2")
								dbSetOrder(1)
								DbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)
							EndIf

							aadd(aNfVinc,{SD1->D1_EMISSAO,SD1->D1_SERIE,SD1->D1_DOC,IIF(SD1->D1_TIPO $ "DB",IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA1->A1_CGC),IIF(SD1->D1_FORMUL=="S",SM0->M0_CGC,SA2->A2_CGC)),SM0->M0_ESTCOB,SF1->F1_ESPECIE})
						EndIf
					Else
						aOldReg  := SD2->(GetArea())
						aOldReg2 := SF2->(GetArea())
						dbSelectArea("SD2")
						dbSetOrder(3)
						If DbSeek(xFilial("SD2")+(cAliasSD2)->D2_NFORI+(cAliasSD2)->D2_SERIORI+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_ITEMORI)
							dbSelectArea("SF2")
							dbSetOrder(1)
							DbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
							If !SD2->D2_TIPO $ "DB"
								dbSelectArea("SA1")
								dbSetOrder(1)
								DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
							Else
								dbSelectArea("SA2")
								dbSetOrder(1)
								DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
							EndIf

							aadd(aNfVinc,{SF2->F2_EMISSAO,SD2->D2_SERIE,SD2->D2_DOC,SM0->M0_CGC,SM0->M0_ESTCOB,SF2->F2_ESPECIE})
						EndIf
						RestArea(aOldReg)
						RestArea(aOldReg2)
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Obtem os dados do produto                                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SB1")
				dbSetOrder(1) //B1_FILIAL+B1_COD
				DbSeek(xFilial("SB1")+(cAliasSD2)->D2_COD)

				dbSelectArea("SB5")
				dbSetOrder(1) //B5_FILIAL+B5_COD
				DbSeek(xFilial("SB5")+(cAliasSD2)->D2_COD)
				//-- Veiculos Novos
				If AliasIndic("CD9")
					dbSelectArea("CD9")
					dbSetOrder(1) //CD9_FILIAL+CD9_TPMOV+CD9_SERIE+CD9_DOC+CD9_CLIFOR+CD9_LOJA+CD9_ITEM+CD9_COD
					DbSeek(xFilial("CD9")+"S"+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_ITEM)
				EndIf
				//-- Medicamentos
				If AliasIndic("CD7")
					dbSelectArea("CD7")
					dbSetOrder(1) //CD7_FILIAL+CD7_TPMOV+CD7_SERIE+CD7_DOC+CD7_CLIFOR+CD7_LOJA+CD7_ITEM+CD7_COD
					DbSeek(xFilial("CD7")+"S"+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_ITEM)
				EndIf
				//-- Armas de Fogo
				If AliasIndic("CD8")
					dbSelectArea("CD8")
					dbSetOrder(1) //CD8_FILIAL+CD8_TPMOV+CD8_SERIE+CD8_DOC+CD8_CLIFOR+CD8_LOJA+CD8_ITEM+CD8_COD
					DbSeek(xFilial("CD8")+"S"+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA+(cAliasSD2)->D2_ITEM)
				EndIf
				//-- Msg Zona Franca de Manaus / ALC
				dbSelectArea("SF3")
				dbSetOrder(4) //F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
				If DbSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
					If !SF3->F3_DESCZFR == 0
						cMensFis := "Total do desconto Ref. a Zona Franca de Manaus / ALC. R$ "+str(SF3->F3_VALOBSE-SF2->F2_DESCONT,13,2)
					EndIf
				EndIf

				dbSelectArea("SC6")
				dbSetOrder(1) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
				DbSeek(xFilial("SC6")+(cAliasSD2)->D2_PEDIDO+(cAliasSD2)->D2_ITEMPV+(cAliasSD2)->D2_COD)

				cFieldMsg := GetNewPar("MV_CMPUSR","")
				If !Empty(cFieldMsg) .and. SC5->(FieldPos(cFieldMsg)) > 0 .and. !Empty(&("SC5->"+cFieldMsg))
					//Permite ao cliente customizar o conteudo do campo dados adicionais por meio de um campo MEMO proprio.
					cMensCli := If(FindFunction('CleanSpecChar'),CleanSpecChar(Alltrim(&("SC5->"+cFieldMsg))),&("SC5->"+cFieldMsg))+" "
				ElseIf !AllTrim(SC5->C5_MENNOTA) $ cMensCli
					cMensCli +=If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(SC5->C5_MENNOTA)),AllTrim(SC5->C5_MENNOTA))
				EndIf
				If !Empty(SC5->C5_MENPAD) .And. !AllTrim(FORMULA(SC5->C5_MENPAD)) $ cMensFis
					cMensFis += If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(FORMULA(SC5->C5_MENPAD))),AllTrim(FORMULA(SC5->C5_MENPAD)))
				EndIf

				cModFrete := IIF(SC5->C5_TPFRETE=="C","0","1")

				If Empty(aPedido)
					aPedido := {"",AllTrim(SC6->C6_PEDCLI),""}
				EndIf

				dbSelectArea("CD2")
				If !(cAliasSD2)->D2_TIPO $ "DB"
					dbSetOrder(1) //CD2_FILIAL+CD2_TPMOV+CD2_SERIE+CD2_DOC+CD2_CODCLI+CD2_LOJCLI+CD2_ITEM+CD2_CODPRO+CD2_IMP
				Else
					dbSetOrder(2)
				EndIf
				If !DbSeek(xFilial("CD2")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA+PadR((cAliasSD2)->D2_ITEM,4)+(cAliasSD2)->D2_COD)

				EndIf
				aadd(aISSQN,{0,0,0,"","",0})
				While !Eof() .And. xFilial("CD2") == CD2->CD2_FILIAL .And.;
					"S" == CD2->CD2_TPMOV .And.;
					SF2->F2_SERIE == CD2->CD2_SERIE .And.;
					SF2->F2_DOC == CD2->CD2_DOC .And.;
					SF2->F2_CLIENTE == IIF(!(cAliasSD2)->D2_TIPO $ "DB",CD2->CD2_CODCLI,CD2->CD2_CODFOR) .And.;
					SF2->F2_LOJA == IIF(!(cAliasSD2)->D2_TIPO $ "DB",CD2->CD2_LOJCLI,CD2->CD2_LOJFOR) .And.;
					(cAliasSD2)->D2_ITEM == SubStr(CD2->CD2_ITEM,1,Len((cAliasSD2)->D2_ITEM)) .And.;
					(cAliasSD2)->D2_COD == CD2->CD2_CODPRO

					Do Case
						Case AllTrim(CD2->CD2_IMP) == "ICM"
							aTail(aICMS) := {CD2->CD2_ORIGEM,CD2->CD2_CST,CD2->CD2_MODBC,CD2->CD2_PREDBC,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,0,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Case AllTrim(CD2->CD2_IMP) == "SOL"
							aTail(aICMSST) := {CD2->CD2_ORIGEM,CD2->CD2_CST,CD2->CD2_MODBC,CD2->CD2_PREDBC,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_MVA,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
							lCalSol := .T.
						Case AllTrim(CD2->CD2_IMP) == "IPI"
							aTail(aIPI) := {"","",0,"999",CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_QTRIB,CD2->CD2_PAUTA,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_MODBC,CD2->CD2_PREDBC}
						Case AllTrim(CD2->CD2_IMP) == "PS2"
							If (cAliasSD2)->D2_VALISS==0
								aTail(aPIS) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
							Else
								If Empty(aISS)
									aISS := {0,0,0,0,0}
								EndIf
								aISS[04]+= CD2->CD2_VLTRIB	
							EndIf
						Case AllTrim(CD2->CD2_IMP) == "CF2"
							If (cAliasSD2)->D2_VALISS==0
								aTail(aCOFINS) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
							Else
								If Empty(aISS)
									aISS := {0,0,0,0,0}
								EndIf
								aISS[05] += CD2->CD2_VLTRIB	
							EndIf
						Case AllTrim(CD2->CD2_IMP) == "PS3" .And. (cAliasSD2)->D2_VALISS==0
							aTail(aPISST) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Case AllTrim(CD2->CD2_IMP) == "CF3" .And. (cAliasSD2)->D2_VALISS==0
							aTail(aCOFINSST) := {CD2->CD2_CST,CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,CD2->CD2_QTRIB,CD2->CD2_PAUTA}
						Case AllTrim(CD2->CD2_IMP) == "ISS"
							If Empty(aISS)
								aISS := {0,0,0,0,0}
							EndIf
							aISS[01] += (cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON
							aISS[02] += CD2->CD2_BC
							aISS[03] += CD2->CD2_VLTRIB
							If !Empty(cMunPrest) .and. (Empty(aDest[01]) .and. Empty(aDest[02]) .and. Empty(aDest[07]) .and. Empty(aDest[09]))
								cMunISS := cMunPrest
							Else
								cMunISS := convType(aUF[aScan(aUF,{|x| x[1] == aDest[09]})][02]+aDest[07])
							EndIf
							If nAliq > 0
								If nAliq == CD2->CD2_ALIQ .And. lAglutina
									aISSQN[1][1] += CD2->CD2_BC
									aISSQN[1][3] += CD2->CD2_VLTRIB
									aISSQN[1][6] += (cAliasSD2)->D2_DESCON
								Else
									lAglutina := .F.
									aTail(aISSQN) := {CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,cMunISS,AllTrim((cAliasSD2)->D2_CODISS),(cAliasSD2)->D2_DESCON}
								EndIf
							Else
								aTail(aISSQN) := {CD2->CD2_BC,CD2->CD2_ALIQ,CD2->CD2_VLTRIB,cMunISS,AllTrim((cAliasSD2)->D2_CODISS),(cAliasSD2)->D2_DESCON}
								nAliq := CD2->CD2_ALIQ
							EndIf
					EndCase
					dbSelectArea("CD2")
					dbSkip()
				EndDo
				If lAglutina
					If Len(aProd) > 0
						nX := aScan(aProd,{|x| x[24] == (cAliasSD2)->D2_CODISS .And. x[23] == IIF(SB1->(FieldPos("B1_TRIBMUN"))<>0,RetFldProd(SB1->B1_COD,"B1_TRIBMUN"),"")})
						If nX > 0
							aProd[nx][13]+= (cAliasSD2)->D2_VALFRE // Valor Frete
							aProd[nx][14]+= (cAliasSD2)->D2_SEGURO // Valor Seguro
							aProd[nx][15]+= ((cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR) // Valor Desconto
							aProd[nx][21]+= SF3->F3_ISSSUB
							aProd[nx][22]+= SF3->F3_ISSMAT
							aProd[nx][25]+= (cAliasSD2)->D2_BASEISS
							aProd[nx][26]+= (cAliasSD2)->D2_VALFRE
							aProd[nx][27]+=	 IIF(!(cAliasSD2)->D2_TIPO$"IP",(cAliasSD2)->D2_PRCVEN,0) * (cAliasSD2)->D2_QUANT // Valor Liquido = I-Compl.ICMS;P-Compl.IPI
							aProd[nx][28]+= IIF(!(cAliasSD2)->D2_TIPO$"IP",(cAliasSD2)->D2_PRCVEN,0) * (cAliasSD2)->D2_QUANT+((cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR) //Valor Total
							aProd[nx][35]+= IIF(lCrgTrib .And. cTpCliente == "F",IIF((cAliasSD2)->(FieldPos("D2_TOTIMP"))<>0,(cAliasSD2)->D2_TOTIMP,0),0)
							//aProd[nx][29]+=	SF3->F3_ISSSUB + SF3->F3_ISSMAT	//Valor Total de deducoes       Comentado para não duplicar o valor na tag ValorDeducoes
						Else
							lAglutina := .F.
						EndIf
					EndIf
				EndIf
				If !lAglutina .Or. Len(aProd) == 0
					aadd(aProd,	{Len(aProd)+1,;
								(cAliasSD2)->D2_COD,;
								IIf(Val(SB1->B1_CODBAR)==0,"",Str(Val(SB1->B1_CODBAR),Len(SB1->B1_CODBAR),0)),;
								IIF(Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI),;
								SB1->B1_POSIPI,;
								SB1->B1_EX_NCM,;
								(cAliasSD2)->D2_CF,;
								SB1->B1_UM,;
								(cAliasSD2)->D2_QUANT,;
								IIF(!(cAliasSD2)->D2_TIPO$"IP",(cAliasSD2)->D2_PRCVEN,0),;
								IIF(Empty(SB5->B5_UMDIPI),SB1->B1_UM,SB5->B5_UMDIPI),;
								IIF(Empty(SB5->B5_CONVDIPI),(cAliasSD2)->D2_QUANT,SB5->B5_CONVDIPI*(cAliasSD2)->D2_QUANT),;
								(cAliasSD2)->D2_VALFRE,;
								(cAliasSD2)->D2_SEGURO,;
								((cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR),;
								IIF(!(cAliasSD2)->D2_TIPO$"IP",(cAliasSD2)->D2_PRCVEN+(((cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR)/(cAliasSD2)->D2_QUANT),0),;
								IIF(SB1->(FieldPos("B1_CODSIMP"))<>0,SB1->B1_CODSIMP,""),; // 17 - codigo ANP do combustivel
								IIF(SB1->(FieldPos("B1_CODIF"))<>0,SB1->B1_CODIF,""),; // 18 - CODIF
								RetFldProd(SB1->B1_COD,"B1_CNAE"),; //19 - Codigo da Atividade CNAE
								SF3->F3_RECISS,;
								SF3->F3_ISSSUB,;
								SF3->F3_ISSMAT,;
								IIF(SB1->(FieldPos("B1_TRIBMUN"))<>0,RetFldProd(SB1->B1_COD,"B1_TRIBMUN"),""),;
								SF3->F3_CODISS,; //24 - Codigo Servico ISS
								(cAliasSD2)->D2_BASEISS,;
								(cAliasSD2)->D2_VALFRE,;
								IIF(!(cAliasSD2)->D2_TIPO$"IP",IIF(SM0->M0_CODMUN == "3550308",(cAliasSD2)->D2_PRCVEN * (cAliasSD2)->D2_QUANT,(cAliasSD2)->D2_TOTAL),0),; // 27 - Valor Liquido
								IIF(!(cAliasSD2)->D2_TIPO$"IP",IIF(SM0->M0_CODMUN == "3550308",(cAliasSD2)->D2_PRCVEN * (cAliasSD2)->D2_QUANT,(cAliasSD2)->D2_TOTAL),0)+((cAliasSD2)->D2_DESCON+(cAliasSD2)->D2_DESCZFR),; //28 - Valor Total
								SF3->F3_ISSSUB + SF3->F3_ISSMAT,; // 29 - Valor Total de deducoes.
								(cAliasSD2)->D2_VALIMP4,; // 30
								(cAliasSD2)->D2_VALIMP5,; // 31
								RetFldProd(SB1->B1_COD,"B1_TRIBMUN"),; // 32
								IIF(SF4->(FieldPos("F4_CFPS")) > 0,SF4->F4_CFPS,""),;// 33 - Codigo Fiscal de Prestacao de Servico (CFPS)
								IIF(SF4->(FieldPos(cMVBENEFRJ))> 0,SF4->(&(cMVBENEFRJ)),"" ),; // 34 - Código Beneficio Fiscal - NFS-e RJ
								IIF(lCrgTrib .And. cTpCliente == "F",IIF((cAliasSD2)->(FieldPos("D2_TOTIMP"))<>0,(cAliasSD2)->D2_TOTIMP,0),0),; // 35 - Lei transparência
					})
				EndIf

				If SC6->(FieldPos("C6_TPDEDUZ")) > 0 .And. !Empty(SC6->C6_TPDEDUZ)
					aadd(aDeduz,{	SC6->C6_TPDEDUZ,; //-- Tipo de Deducao = 1-Percentual;2-Valor
									SC6->C6_MOTDED ,;
									SC6->C6_FORDED ,;
									SC6->C6_LOJDED ,;
									SC6->C6_SERDED ,;
									SC6->C6_NFDED  ,;
									SC6->C6_VLNFD  ,;
									SC6->C6_PCDED  ,;
									if (SC6->C6_VLDED > 0, SC6->C6_VLDED, (SC6->C6_ABTISS + SC6->C6_ABATMAT)),;
					})
				EndIf

				aadd(aCST,{IIF(!Empty((cAliasSD2)->D2_CLASFIS),SubStr((cAliasSD2)->D2_CLASFIS,2,2),'50'),;
				           IIF(!Empty((cAliasSD2)->D2_CLASFIS),SubStr((cAliasSD2)->D2_CLASFIS,1,1),'0')})
				aadd(aICMS,{})
				aadd(aIPI,{})
				aadd(aICMSST,{})
				aadd(aPIS,{})
				aadd(aPISST,{})
				aadd(aCOFINS,{})
				aadd(aCOFINSST,{})
				//aadd(aISSQN,{0,0,0,"","",0})
				aadd(aAdi,{})
				aadd(aDi,{})
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Tratamento para TAG Exportação quando existe a integração com a EEC     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lEECFAT .And. !Empty((cAliasSD2)->D2_PREEMB)
					aadd(aExp,(GETNFEEXP((cAliasSD2)->D2_PREEMB)))
				Else
					aadd(aExp,{})
				EndIf
				If AliasIndic("CD7")
					aadd(aMed,{CD7->CD7_LOTE,CD7->CD7_QTDLOT,CD7->CD7_FABRIC,CD7->CD7_VALID,CD7->CD7_PRECO})
				Else
					aadd(aMed,{})
				EndIf
				If AliasIndic("CD8")
					aadd(aArma,{CD8->CD8_TPARMA,CD8->CD8_NUMARMA,CD8->CD8_DESCR})
				Else
					aadd(aArma,{})
				EndIf
				If AliasIndic("CD9")
					aadd(aveicProd,{IIF(CD9->CD9_TPOPER$"03",1,IIF(CD9->CD9_TPOPER$"1",2,IIF(CD9->CD9_TPOPER$"2",3,IIF(CD9->CD9_TPOPER$"9",0,"")))),;
									CD9->CD9_CHASSI,CD9->CD9_CODCOR,CD9->CD9_DSCCOR,CD9->CD9_POTENC,CD9->CD9_CM3POT,CD9->CD9_PESOLI,;
					                CD9->CD9_PESOBR,CD9->CD9_SERIAL,CD9->CD9_TPCOMB,CD9->CD9_NMOTOR,CD9->CD9_CMKG,CD9->CD9_DISTEI,CD9->CD9_RENAVA,;
					                CD9->CD9_ANOMOD,CD9->CD9_ANOFAB,CD9->CD9_TPPINT,CD9->CD9_TPVEIC,CD9->CD9_ESPVEI,CD9->CD9_CONVIN,CD9->CD9_CONVEI,;
					                CD9->CD9_CODMOD})
				Else
					aadd(aveicProd,{})
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Totaliza todas retencoes por item³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nRetDesc :=	Iif(nRetPis > 0, (cAliasSD2)->D2_VALPIS, 0) + Iif(nRetCof > 0, (cAliasSD2)->D2_VALCOF, 0) + ;
							Iif(nRetCsl > 0, (cAliasSD2)->D2_VALCSL, 0) + Iif(SF2->(FieldPos("F2_VALIRRF")) <> 0 .and. SF2->F2_VALIRRF > 0, (cAliasSD2)->D2_VALIRRF, 0) + ;
							Iif(SF2->(FieldPos("F2_BASEINS")) <> 0 .and. SF2->F2_BASEINS > 0, (cAliasSD2)->D2_VALINS, 0) + Iif(Len(aRetISS) >= nCont, aRetISS[nCont], 0)

				aTotal[01] += (cAliasSD2)->D2_DESPESA
				aTotal[02] += ((cAliasSD2)->D2_TOTAL - nRetDesc)
				aTotal[03] := SF4->F4_ISSST	
				If lCalSol
					dbSelectArea("SF3")
					dbSetOrder(4)
					If DbSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
						nPosI	:=	At (SF3->F3_ESTADO, cMVSUBTRIB)+2
						nPosF	:=	At ("/", SubStr (cMVSUBTRIB, nPosI))-1
						nPosF	:=	IIf(nPosF<=0,len(cMVSUBTRIB),nPosF)
						aAdd (aIEST, SubStr (cMVSUBTRIB, nPosI, nPosF))	//01 - IE_ST
					EndIf
				EndIf
				IF Empty(aPis[Len(aPis)]) .And. SF4->F4_CSTPIS=="06"
					aadd(aPisAlqZ,{SF4->F4_CSTPIS})
				Else
					aadd(aPisAlqZ,{})
				EndIf
				IF Empty(aCOFINS[Len(aCOFINS)]) .And. SF4->F4_CSTCOF=="06"
					aadd(aCofAlqZ,{SF4->F4_CSTCOF})
				Else
					aadd(aCofAlqZ,{})
				EndIf

				//Tratamento para Calcular o Desconto para  Belo Horizonte
				nDescon += (cAliasSD2)->D2_DESCICM

				dbSelectArea(cAliasSD2)
				dbSkip()
			EndDo
			If lQuery
				dbSelectArea(cAliasSD2)
				dbCloseArea()
				dbSelectArea("SD2")
			EndIf

		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Geracao do arquivo XML                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aNota)
			cString := '<rps id="rps:' + allTrim( Str( Val( aNota[02] ) ) ) + '" tssversao="2.00">'
			cString += assina( aDeduz, aNota, aProd, aTotal, aDest )
			cString += ident( aNota, aProd, aTotal, aDest, aISSQN, aAIDF, dDateCom, cNatOp )
			cString += substit( aNota )
			cString += canc()
			cString += ativ( aProd, aISSQN )
			cString += prest( cMunPSIAFI )
			cString += prestacao( cMunPrest, cDescMunP, aDest, cMunPSIAFI )
			cString += tomador( aDest )
			cString += servicos( aProd, aISSQN, aRetido, cNatOper, lNFeDesc, cDiscrNFSe, aCST, aDest[22], SM0->M0_CODMUN, cF4Agreg ,nDescon )
			cString += valores( aISSQN, aRetido, aTotal, aDest, SM0->M0_CODMUN )
			cString += faturas( aDupl )
			cString += pagtos( aDupl )
			cString += deducoes( aISSQN, aDeduz, aDeducao, aConstr )
			cString += infCompl( cMensCli, cMensFis, lNFeDesc, cDescrNFSe )
			cString += '</rps>'
			cString := encodeUTF8( cString )
		EndIf
	ElseIf cTipo == "1" .And. !Empty(cMotCancela)
		cString := u_nfseXMLCan(cNota,cMotCancela)
	EndIf

return { cString, cNfe }

//-----------------------------------------------------------------------
/*/{Protheus.doc} assina
Função para montar a tag de assinatura do XML de envio de NFS-e ao TSS.

@author Marcos Taranta
@since 07.02.2012

@param	aDeduz	Array contendo as informações de deduções.
@param	aNota	Array contendo as informações de identificação sobre a nota.
@param	aProd	Array contendo as informações dos produtos.
@param	aTotal	Array contendo os valores totais do documento.
@param	aDest	Array contendo as informações de destinatário.

@return	cString	Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------
Static Function assina( aDeduz, aNota, aProd, aTotal, aDest )
	Local cAssinatura	:= ""
	Local cMVCODREG		:= superGetMV( "MV_CODREG" ,, " " ) //-- Codigo regime tributario emitente da Nf-e = 1-Simples Nacional; 2-Simples Nacional - Excesso desub-limite de receita bruta; 3- Regime Nacional
	Local nDeduz		:= 0
	Local nX			:= 0

	For nX := 1 To Len( aDeduz )
		nDeduz += iif( aDeduz[nX][1] == "2", aDeduz[nX][8], 0 )
	Next

	cAssinatura	+= strZero( val( SM0->M0_INSCM ), 11 )
	cAssinatura	+= "NF   "
	cAssinatura	+= strZero( val( aNota[02] ), 12 )
	cAssinatura	+= dToS( aNota[03] )
	do case
		case aTotal[3] $ "2"
			if !empty( cMVCODREG ) .and. ( cMVCODREG == "2" .or. cMVCODREG == "1" )
				cAssinatura += "H "
			else
				cAssinatura += "E "
			endif
		case aTotal[3] $ "3"
			cAssinatura += "C "
		case aTotal[3] $ "4"
			cAssinatura += "F "
		case aTotal[3] $ "5"
			cAssinatura += "K "
		case aTotal[3] $ "6"
			cAssinatura += "K "
		case aTotal[3] $ "7"
			cAssinatura += "N "
		case aTotal[3] $ "8"
			cAssinatura += "M "
		otherwise
			if !empty( cMVCODREG ) .and. ( cMVCODREG == "2" .or. cMVCODREG == "1" )
				cAssinatura += "H "
			else
				cAssinatura += "T "
			endif
	endcase
	cAssinatura += "N"
	cAssinatura += iif( ( aProd[1][20] ) == '1', "S", "N" )
	cAssinatura += strZero( ( aTotal[2] - nDeduz ) * 100, 15 )
	cAssinatura += strZero( nDeduz * 100, 15 )
	cAssinatura += allTrim( strZero( val( aProd[1][19] ), 10 ) )
	cAssinatura += allTrim( strZero( val( aDest[1] ), 14 ) )
	cAssinatura := allTrim( Lower( sha1( allTrim( cAssinatura ), 2 ) ) )
	cAssinatura := '<assinatura>' + cAssinatura + '</assinatura>'

Return cAssinatura

//-----------------------------------------------------------------------
/*/{Protheus.doc} ident
Função para montar a tag de identificação do XML de envio de NFS-e ao TSS.

@author Marcos Taranta
@since 19.01.2012

@param	aNota	Array com informações sobre a nota.
@param	aProd	Array com informações sobre os serviços da nota.
@param	aTotal	Array com informações sobre os totais da nota.
@param	aDest	Array com informações sobre o tomador da nota.
@param	aAIDF	Array com informações sobre o AIDF.
@return	cString	Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------
Static Function ident( aNota, aProd, aTotal, aDest, aISSQN, aAIDF, dDateCom, cNatOp )
	Local cMVCODREG		:= getMV( "MV_CODREG" ,, "" ) //-- Codigo regime tributario emitente da Nf-e = 1-Simples Nacional; 2-Simples Nacional - Excesso desub-limite de receita bruta; 3- Regime Nacional
	Local cMVREGIESP	:= getMV( "MV_REGIESP",, "" ) //-- Informar o Regime especial de tributacao para que seja gerada a TAG <RegimeEspecialTributacao>
	Local cMVINCEFIS	:= AllTrim(GetNewPar("MV_INCEFIS","2"))
	Local cString		:= ""

	cString	:= "<identificacao>"
	//-- Data e hora de emissao do documento
	cString	+= "<dthremissao>" + subStr( dToS( aNota[3] ), 1, 4 ) + "-" + subStr( dToS( aNota[3] ), 5, 2 ) + "-" + subStr( Dtos( aNota[3] ), 7, 2 ) + 'T' + time() + "</dthremissao>"
	//-- Serie e numero RPS
	If UsaAidfRps(SM0->M0_CODMUN)
		cString += "<serierps>"  + allTrim( aAIDF[2] ) + "</serierps>"
		cString += "<numerorps>" + allTrim( aAIDF[3] ) + "</numerorps>"
	Else
		cString += "<serierps>"  + allTrim( aNota[1] ) + "</serierps>"
		cString += "<numerorps>" + allTrim( str( val( aNota[2] ) ) ) + "</numerorps>"
	EndIf
	//-- Tipo do documento
	cString += "<tipo>1</tipo>" //-- Fixo pois tanto ABRASF como DSFNET, utilizam esta tag como tipo RPS (1) - Obrigat.
	//-- Situacao do RPS
	cString += "<situacaorps>1</situacaorps>" //-- Fixo pois tanto ABRASF como DSFNET, utilizam esta tag como Normal (1) - Obrigat.
	//-- Tipo de recolhimento do documento
	cString += "<tiporecolhe>" + iif( allTrim( aProd[1][20] ) == "1", "2", "1" ) + "</tiporecolhe>" // 1-A receber; 2-Retido na fonte;
	//-- Tipo de operacao do documento - Nao Obrigat.
	do case
		case aNota[4] $ "DB"
			cString += "<tipooper>4</tipooper>"	// 4-Devolucao Simples Remessa;
		case (DivCem(aISSQN[1][2])) <= 0
			cString += "<tipooper>3</tipooper>" // 3-Imune/Isenta de ISSQN;
		otherWise
			cString += "<tipooper>1</tipooper>" // 1-Sem Deducao;
	endcase
	//-- Tipo de tributacao do documento - Natureza do Pagamento Imposto (F4_ISSST) - Obrigat
	//   1-Isenta de ISS
	//   2-Nao incidencia no municipio
	//   3-Imune
	//   4-Exigibilidade Susp. Dec. J.
	//   5-Nao tributavel
	//   6-Tributavel
	//   7-Tributavel fixo
	//   8-Tributavel S.N
	//   9-Cancelado
	//  10-Extraviado
	//  11-Micro Empreendendor Individual (MEI)
	//  12-Exigibilidade Susp. Proc. A.
	do case
		case aTotal[3] $ "2"
			If !Empty( cMVCODREG ) .And.  ( cMVCODREG == "2" .Or. cMVCODREG == "1" )
				cString += "<tipotrib>8</tipotrib>"	//  8-Tributavel S.N.; - Simples Nacional
			Else
				cString += "<tipotrib>2</tipotrib>"	//  2-Nao incidencia no municipio;
			EndIf
		case aTotal[3] $ "3"
			cString += "<tipotrib>1</tipotrib>"		//  1-Isenta de ISS;
		case aTotal[3] $ "4"
			cString += "<tipotrib>3</tipotrib>"		//  3-Imune;
		case aTotal[3] $ "5"
			cString += "<tipotrib>4</tipotrib>"		//  4-Exigibilidade Susp. Dec. J.;
		case aTotal[3] $ "6"
			cString += "<tipotrib>12</tipotrib>"	// 12-Exigibilidade Susp. Proc. A.;
		case aTotal[3] $ "7"
			cString += "<tipotrib>5</tipotrib>"		//  5-Nao Tributavel;
		case aTotal[3] $ "8"
			cString += "<tipotrib>11</tipotrib>"	// 11-Micro Empreendedor Individual (MEI)
		otherWise
			cString += "<tipotrib>6</tipotrib>"		//  6-Tributavel;
	endcase
	//-- Regime especial de tributacao do documento - Nao Obrigat.
	If !Empty(cMVREGIESP)
		cString += "<regimeesptrib>" + cMVREGIESP + "</regimeesptrib>"
	EndIf
	//-- Forma da pagamento do documento - Nao Obrigat.
	cString += "<formpagto>" + aNota[9] + "</formpagto>"
	//-- Codigo de Natureza da Operacao - Obrigat.
	//   1-Tributacao no Municipio
	//   2-Tributacao fora do Municipio
	//   3-Isento
	//   4-Imune
	//   5-Exigibilidade suspensa por Decisao Judicial
	//   6-Exigibilidade suspensa por Procedimento
	//   7-Exigivel
	//   8-Nao Incidencia
	//   9-Exportacao
	// 107-Sem deducao
	// 108-Com deducao materiais
	// 109-Devolucao/Simples Remessa
	// 110-Intermediacao
	// 121-ISS fixo (Soc. Profissionais)
	// 201-ISS retido pelo Tomador/Intermediario
	// 301-Operacao Imune,Isenta ou Nao Tributada
	// 541-MEI (Simples Nacional)
	// 551-Escritorio Contabil (Simples Nacional)
	// 601-ISS Retido pelo Tomador/Intermediario (Simples Nacional)
	// 701-Operacao Imune, Isenta ou Nao Tributada
	//  51-Imposto devido no Municipio, com obrigacao de retencao na fonte      (servico prestado no Municipio)
	//  52-Imposto devido no Municipio, sem obrigacao de retencao na fonte      (servico prestado no Municipio)
	//  58-Nao tributavel                                                       (servico prestado no Municipio)
	//  59-Imposto recolhido pelo regime unico de arrecadacao Simples Nacional  (servico prestado no Municipio)
	//  61-Imposto devido no Municipio, com obrigacao de retencao na fonte      (servico prestado fora do Municipio)
	//  62-Imposto devido no Municipio, sem obrigacao de retencao na fonte      (servico prestado fora do Municipio)
	//  63-Imposto devido fora do Municipio, com obrigacao de retencao na fonte (servico prestado fora do Municipio)
	//  64-Imposto devido fora do Municipio, sem obrigacao de retencao na fonte (servico prestado fora do Municipio)
	//  68-Nao tributavel                                                       (servico prestado fora do Municipio)
	//  69-Imposto recolhido pelo regime unico de arrecadacao Simples Nacional  (servico prestado fora do Municipio)
	//  78-Nao tributavel                                                       (servico prestado no exterior)
	//  79-Imposto recolhido pelo regime unico de arrecadacao Simples Nacional  (servico prestado no exterior)
	//  81-Imposto recolhido por guia sem escrituracao
	cString += "<natop>"+cNatOp+"</natop>"
	//-- Data competencia (emissao)
	cString += "<dtcompetencia>" + subStr(dToS(aNota[3]), 1, 4) + "-" + subStr(dToS(aNota[3]), 5, 2) + "-" + subStr(Dtos(aNota[3]), 7, 2) + 'T' + time() + "</dtcompetencia>"
	//-- Identificacao de Sim/Nao
	cString += "<incentfiscal>" + cMVINCEFIS + "</incentfiscal>"
	//-- Recolhimento. Identificacao de Sim/Nao
	cString += "<issret>"+ allTrim( aProd[1][20])+"</issret>"
	//-- Codigo do Item da Lista de Servico
	cString += "<itemlistaserv>"+ConvType(aProd[1][24],5)+"</itemlistaserv>"
	//-- Codigo da Atividade CNAE
	cString += "<cnae>" + allTrim( aProd[1][19] ) + "</cnae>"
	//-- Codigo de Tributacao do Municipio
	cString += "<ctributmun>" + ConvType(aProd[1][23],20)+"</ctributmun>"
	//-- Codigo Fiscal de Prestacao de Servico (CFPS)
	cString += "<codigocfps>" + allTrim( aProd[1][33] ) + "</codigocfps>"
	//-- Tipo de lancamento de acordo com o servico prestado: N-devido no munic.prestador;P-Prestadores Simples Nac.T-devido no munic.tomador;R-NF recebida dentro ou fora munic.
	cString += "<ctipolancamento>N</ctipolancamento>"
	//-- Exigibilidade de ISS - Mesmo conteudo do campo NatOp - Nao Obrigat.
	If Len(cNatOp) > 2
		cString += "<cexiss>XX</cexiss>"
	Else
		cString += "<cexiss>"+cNatOp+"</cexiss>"
	EndIf
	cString	+= "</identificacao>"

Return cString

//-----------------------------------------------------------------------
/*/{Protheus.doc} substit
Função para montar a tag de substituição do XML de envio de NFS-e ao TSS. - Nao Obrigat.

@author Marcos Taranta
@since 19.01.2012

@param	aNota	Array com informações sobre a nota.

@return	cString	Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------
Static Function substit( aNota )
	Local cString := ""

	If !Empty(aNota[8] + aNota[7])
		cString += "<substituicao>"
		cString += "<serierps>"      + aNota[8] + "</serierps>"
		cString += "<numerorps>"     + aNota[7] + "</numerorps>"
		cString += "<numeronfse>"    + aNota[2] + "</numeronfse>"
		cString += "<idnfse>"        + aNota[8] +  aNota[7] + "</idnfse>"
		cString += "<tipo>1</tipo>"  //-- Tipo do Documento: 1-RPS;2-Nota Fiscal Conjugada (Mista);3-Cupom;
		cString += "<dtEmissaonfse>" + SubStr(dToS(aNota[3]), 1, 4) + "-" + SubStr(dToS(aNota[3]), 5, 2) + "-" + SubStr(Dtos(aNota[3]), 7, 2) + "</dtEmissaonfse>"
		cString += "</substituicao>"
	EndIf

Return cString

//-----------------------------------------------------------------------
/*/{Protheus.doc} canc
Função para montar a tag de cancelamento do XML de envio de NFS-e ao TSS. - Nao Obrigat.

@author Marcos Taranta
@since 19.01.2012

@return	cString	Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------
Static Function canc()
	Local cString := ""

	If .F. //AQUI
		cString += "<cancelamento>"
		//-- Codigo do motivo do cancelamento do documento: 1-Extravio; 2-Dados Incorretos; 3-Substituicao. - Nao Obrigat.
		cString += "<codmotcanc>" + "" + "</codmotcanc>"
		//-- Motivo do cancelamento do documento.
		cString += "<motcanc>"    + "" + "</motcanc>"
		cString += "</cancelamento>"
	EndIf

Return cString

//-----------------------------------------------------------------------
/*/{Protheus.doc} ativ
Função para montar a tag de atividade do XML de envio de NFS-e ao TSS.

@author Marcos Taranta
@since 19.01.2012

@param	aProd	Array contendo as informações sobre os serviços da nota.

@return	cString	Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------
Static Function ativ( aProd, aISSQN )
	Local cString := ""

	If !Empty( allTrim( aProd[1][19] ) )
		cString += "<atividade>"
		cString += "<codigo>"   + allTrim( aProd[1][19] )     + "</codigo>"
		cString += "<aliquota>" + convType(DivCem(aISSQN[1][2]), 5 ) + "</aliquota>"
		cString += "</atividade>"
	EndIf

Return cString

//-----------------------------------------------------------------------
/*/{Protheus.doc} prest
Função para montar a tag de prestador do XML de envio de NFS-e ao TSS.

@author Marcos Taranta
@since 19.01.2012

@return	cString	Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------
Static Function prest( cMunPSIAFI )
	Local aTemp			:= {}
	Local cImPrestador	:= allTrim( SM0->M0_INSCM )
	Local cIEPrestador	:= allTrim( SM0->M0_INSC )
	Local cMVINCECUL	:= allTrim( GetMV( "MV_INCECUL",, "2" ) ) //-- Contribuinte optante do incentivo a cultura: 1=sim;2=nao
	Local cMVOPTSIMP	:= allTrim( GetMV( "MV_OPTSIMP",, "2" ) ) //-- Contribuinte optante do simples: 1=sim;2=nao
	Local cMVNUMPROC	:= allTrim( GetMV( "MV_NUMPROC",, " " ) ) //-- Numero processo judicial ou adm suspensao da exibilidade
	Local cEmail		:= allTrim( GetMV( "MV_EMAILPT",, " " ) ) //-- email prestador
	Local cString		:= ""

	default	cMunPSIAFI	:= ""

	aTemp := fisGetEnd( SM0->M0_ENDCOB )

	cImPrestador := strTran( cImPrestador, "-", "" )
	cImPrestador := strTran( cImPrestador, "/", "" )

	cIEPrestador := strTran( cIEPrestador, "-", "" )
	cIEPrestador := strTran( cIEPrestador, "/", "" )

	cString += "<prestador>"
	cString += "<inscmun>"       + allTrim( cImPrestador )    + "</inscmun>"
	cString += "<cpfcnpj>"       + allTrim( SM0->M0_CGC )     + "</cpfcnpj>"
	cString += "<razao>"         + allTrim( SM0->M0_NOMECOM ) + "</razao>"
	cString += "<fantasia>"      + allTrim( SM0->M0_NOME )    + "</fantasia>"
	cString += "<codmunibge>"    + allTrim( SM0->M0_CODMUN )  + "</codmunibge>"
	cString += "<codmunsiafi>"   + cMunPSIAFI                  + "</codmunsiafi>"
	If !Empty(SM0->M0_CIDCOB)
		cString += "<cidade>"    + allTrim( SM0->M0_CIDCOB )  + "</cidade>"
	EndIf
	cString += "<uf>" + allTrim( SM0->M0_ESTCOB ) + "</uf>"
	if !Empty(cEmail)
		cString += "<email>"     + cEmail + "</email>
	endif
	//-- DDD do Telefone do Prestador - Obrigat.
	cString += "<ddd>"           + allTrim( str( fisGetTel( SM0->M0_TEL )[2], 3 ) ) + "</ddd>"
	//-- Telefone do Prestador - Obrigat.
	cString += "<telefone>"      + allTrim( str( fisGetTel( SM0->M0_TEL )[3], 15 ) ) + "</telefone>"
	//-- Optante pelo Simples Nacional - 1-Sim;2-Nao - Obrigat.
	cString += "<simpnac>"       + cMVOPTSIMP + "</simpnac>"
	//-- Incentivador Cultural - 1-Sim;2-Nao - Obrigat.
	cString += "<incentcult>"    + cMVINCECUL + "</incentcult>"
	//-- Numero do processo judicial ou administrativo de suspensao da exigibilidade - Nao Obrigat.
	cString += "<numproc>"       + cMVNUMPROC + "</numproc>"
	cString += "<logradouro>"    + allTrim( aTemp[1] ) + "</logradouro>"
	cString += "<numend>"        + allTrim( aTemp[3] ) + "</numend>"
	If !Empty( allTrim( aTemp[4] ) )
		cString += "<complend>" + allTrim( aTemp[4] ) + "</complend>"
	ElseIf !Empty(SM0->M0_COMPCOB)
		cString += "<complend>" + allTrim( SM0->M0_COMPCOB ) + "</complend>"
	EndIf
	cString += "<bairro>"        + allTrim( SM0->M0_BAIRCOB ) + "</bairro>"
	cString += "<tplogradouro>2</tplogradouro>" //-- 2-Rua - Nao Obrigat.
	cString += "<tpbairro>1</tpbairro>"         //-- 1-Bairro - Nao Obrigat.
	cString += "<cep>"           + allTrim( SM0->M0_CEPCOB )  + "</cep>"
	cString += "<cie>"           + allTrim( cIEPrestador )    + "</cie>"
	cString += "</prestador>"

Return cString

//-----------------------------------------------------------------------
/*/{Protheus.doc} prestacao
Função para montar a tag de prestação do XML de envio de NFS-e ao TSS.

@author Marcos Taranta
@since 19.01.2012

@param	cMunPrest	Código de município IBGE da prestação do serviço.
@param	cDescMunP	Nome do município da prestação do serviço.
@param	aDest		Array contendo as informações sobre o tomador da nota.
@param	cMunPSIAFI	Código de município SIAFI da prestação do serviço.

@return	cString		Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------
Static Function prestacao( cMunPrest, cDescMunP, aDest, cMunPSIAFI )
	Local aTabIBGE		:= {}
	Local aMvEndPres	:= &(SuperGetMV("MV_ENDPRES",,"{}"))
	Local cString		:= ""
	Local nScan			:= 0
	
	default	cDescMunP	:= ""
	default	cMunPrest	:= ""
	default	cMunPSIAFI	:= ""

	aTabIBGE := spedTabIBGE()

	If Len( cMunPrest ) <= 5
		nScan := aScan( aTabIBGE, { | x | x[1] == aDest[9] } )
		If nScan <= 0
			nScan := aScan( aTabIBGE, { | x | x[4] == aDest[9] } )
			cMunPrest := aTabIBGE[nScan][1] + cMunPrest
		Else
			cMunPrest := aTabIBGE[nScan][4] + cMunPrest
		EndIf
	EndIf

	If Empty( cMunPrest )
		cMunPrest := allTrim( aDest[7] )
	EndIf
	If Empty( cMunPSIAFI )
		cMunPSIAFI := allTrim( aDest[18] )
	EndIf

	cString += "<prestacao>"
	cString += "<serieprest>99</serieprest>"
	If SC5->(FieldPos("C5_ENDPRES")) > 0
		cString += "<logradouro>" +  IIF( !Empty(FisGetEnd(SC5->C5_ENDPRES)[1] ),   FisGetEnd(SC5->C5_ENDPRES)[1], aDest[3] ) + "</logradouro>"
		cString += "<numend>"     + ConvType(IIF(FisGetEnd(SC5->C5_ENDPRES)[2]<> 0, FisGetEnd(SC5->C5_ENDPRES)[2], aDest[4] )) + "</numend>"
	Else
		cString += "<logradouro>" + IIf(!Empty(aDest[3]),allTrim( aDest[3] ),"") + "</logradouro>"
		cString += "<numend>"     + allTrim( aDest[4] ) + "</numend>"
	EndIf
	If !Empty( allTrim( aDest[5] ) )
		cString += "<complend>"  + allTrim( aDest[5] ) + "</complend>"
	EndIf
	If !Empty( allTrim( cMunPrest ) )
		cString += "<codmunibge>" + allTrim( cMunPrest ) + "</codmunibge>"
	EndIf
	If !Empty( allTrim( cMunPSIAFI ) )
		cString += "<codmunsiafi>" + allTrim( cMunPSIAFI ) + "</codmunsiafi>"
	endif
	cString += "<municipio>" + allTrim( cDescMunP ) + "</municipio>"
	If SC5->(FieldPos("C5_BAIPRES")) > 0	
		cString += "<bairro>" + IIF ( !Empty(SC5->C5_BAIPRES), SC5->C5_BAIPRES, aDest[6] ) + "</bairro>"
	Else
		cString += "<bairro>" + IIf(!Empty(aDest[6]),allTrim( aDest[6] ),"") + "</bairro>"
	EndIf
	If SC5->(FieldPos("C5_ESTPRES")) > 0
		cString += "<uf>" + IIF ( !Empty(SC5->C5_ESTPRES), SC5->C5_ESTPRES, aDest[9] ) + "</uf>" 
	Else
		cString += "<uf>" + IIf(!Empty(aDest[9]),allTrim( aDest[9] ),"") + "</uf>"
	EndIf
	If SC5->(FieldPos("C5_CEPPRES")) > 0
		cString += "<cep>" + IIF ( !Empty(SC5->C5_CEPPRES), SC5->C5_CEPPRES, aDest[10]) + "</cep>"
	Else
		cString += "<cep>" + IIf(!Empty(aDest[10]),allTrim( aDest[10] ),"" ) + "</cep>"
	EndIf
	cString += "</prestacao>"

Return cString

//-----------------------------------------------------------------------
/*/{Protheus.doc} tomador
Função para montar a tag de tomador do XML de envio de NFS-e ao TSS.

@author Marcos Taranta
@since 19.01.2012

@param	aDest	Array com as informações do tomador da nota.

@return	cString	Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------
Static Function tomador( aDest )
	Local cString   := ""
	Local cCodTom   := ""
	Local lTomador  := .T.

	If Empty(aDest[1]) .And. Empty(aDest[2])
		lTomador:=.F.
	EndIf

	If lTomador
		cString	+= "<tomador>"
		If aDest[17] <> "ISENTO" .And. !Empty( aDest[17] )
			cString += "<inscmun>" + allTrim( aDest[17] ) + "</inscmun>"
		Else
			cString +=  "<inscmun></inscmun>"
		EndIf
		//tratativa para geração da tag de Inscricao Estadual no XML
		If !empty(aDest[14]) .and. aDest[14] <> 'ISENTO'
		   cString += "<cietom>" + alltrim(aDest[14]) + "</cietom>"
		Else
		   cString += "<cietom></cietom>"
		EndIf
		cString += "<cpfcnpj>"    + iif( allTrim( aDest[9] ) == "EX", "99999999999999", allTrim( aDest[1] ) ) + "</cpfcnpj>"
		cString += "<razao>"      + allTrim( aDest[2] ) + "</razao>"
		cString += "<tipologr>2</tipologr>" //-- 2-Rua - Nao Obrigat.
		cString += "<logradouro>" + allTrim( aDest[3] ) + "</logradouro>"
		cString += "<numend>"     + allTrim( aDest[4] ) + "</numend>"
		If !Empty( aDest[5] )
			cString += "<complend>" + allTrim( aDest[5] ) + "</complend>"
		EndIf
		cString += "<tipobairro>1</tipobairro>" //-- 1-Bairro - Nao Obrigat.
		cString += "<bairro>" + allTrim( aDest[6] ) + "</bairro>"
		cCodTom := aDest[07] // SA1->A1_COD_MUN
		If Len(cCodTom) <= 5 .And. !(cCodTom$'99999')
			cCodTom := UfIBGEUni(aDest[09]) + cCodTom
		EndIf
		If !Empty( aDest[7] )
			cString += "<codmunibge>" + cCodTom + "</codmunibge>"
		EndIf
		If !Empty( aDest[18] )
			cString += "<codmunsiafi>" + allTrim( aDest[18] ) + "</codmunsiafi>"
		EndIf
		cString += "<cidade>" + allTrim( aDest[ 8] ) + "</cidade>"
		cString += "<uf>"     + allTrim( aDest[ 9] ) + "</uf>"
		cString += "<cep>"    + iif( allTrim( aDest[9] ) == "EX", "99999999", allTrim( aDest[10] ) ) + "</cep>"
		If !Empty( aDest[16] )
			cString += "<email>" + allTrim( aDest[16] ) + "</email>"
		EndIf
		//-- DDD do telefone do Tomador - Nao Obrigat.
		cString += "<ddd>"         + allTrim( str( fisGetTel( aDest[13] )[2], 3 ) ) + "</ddd>"
		//-- Telefone do Tomador - Nao Obrigat.
		cString += "<telefone>"    + allTrim( str( fisGetTel( aDest[13] )[3], 15 ) ) + "</telefone>"
		//-- Codigo do Pais do Tomador (BACEN) - Obrigat.
		cString += "<codpais>"     + allTrim( aDest[11] ) + "</codpais>"
		//-- Nome do Pais do Tomador - Obrigat.
		cString += "<nomepais>"    + allTrim( aDest[12] ) + "</nomepais>"
		//- Define se o Tomador eh estrangeiro - 1-Sim;2-Nao - Obrigat.
		cString += "<estrangeiro>" + iif( allTrim( aDest[9] ) == "EX", "1", "2" ) + "</estrangeiro>"
		//-- Indicativo para notificar tomador por e-mail - Nao Obrigat.
		If Empty( aDest[16] )
			cString += "<notificatomador>2</notificatomador>" // 2-Nao
		Else
			cString += "<notificatomador>1</notificatomador>" // 1-Sim
		EndIf
		//-- Situacao Especial do Tomador: 0-Outros;1-SUS;2-Orgao Poder Executivo;3-Bancos;4-Comercio/Industria;5-Poder Legislativo/Executivo - Obrigat.
		cString += "<csituacaoesptom>0</csituacaoesptom>" //Obrigat.
		//-- Identificacao de 1-Sim/2-Nao - Nao Obrigat.
		cString += "<ctomnaoidentificado>1</ctomnaoidentificado>" //Nao Obrigat.
		cString	+= "</tomador>"
	EndIf

Return cString

//-----------------------------------------------------------------------
/*/{Protheus.doc} servicos
Função para montar a tag de serviços do XML de envio de NFS-e ao TSS.

@author Marcos Taranta
@since 19.01.2012

@param	aProd		Array contendo as informações dos produtos da nota.
@param	aISSQN		Array contendo as informações sobre o imposto.
@param	aRetido		Array contendo as informações sobre impostos retidos.
@param	cNatOper	String contendo discriminacao do servico
@param	lNFeDesc	Logico contendo conteudo do parametro MV_NFEDESC

@return	cString		Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------
Static Function servicos( aProd, aISSQN, aRetido, cNatOper, lNFeDesc, cDiscrNFSe,aCST, cTpPessoa, cCodMun, cF4Agreg, nDescon   )	
	Local aCofinsXML	:= { 0, 0, {} }
	Local aCSLLXML		:= { 0, 0, {} }
	Local aINSSXML		:= { 0, 0, {} }
	Local aIRRFXML		:= { 0, 0, {} }
	Local aISSRet		:= { 0, 0, 0, {} }
	Local aPisXML		:= { 0, 0, {} }

	Local cString		:= ""
	Local cCargaTrb		:= ""
	
	Local nOutRet		:= 0
	Local nScan			:= 0
	Local nValLiq		:= 0
	Local nX			:= 0
	
	Default cTpPessoa	:= ""
	Default cCodMun		:= ""
	Default cF4Agreg	:= ""
	Default nDescon		:= 0
	
	cString += "<servicos>"
	
	For nX := 1 To Len( aProd )
		
		nScan := aScan(aRetido,{|x| x[1] == "ISS"})
		If nScan > 0
			aIssRet[1] += aRetido[nScan][3]
			aIssRet[2] += aRetido[nScan][5]
			aIssRet[3] += aRetido[nScan][4]
			aIssRet[4] := aRetido[nScan][6]
		EndIf
		
		nScan := aScan(aRetido,{|x| x[1] == "PIS"})
		If nScan > 0
			aPisXml[1] := aRetido[nScan][3]
			aPisXml[2] += aRetido[nScan][4]
			aPisXml[3] := aRetido[nScan][5]
		EndIf
		
		nScan := aScan(aRetido,{|x| x[1] == "COFINS"})
		If nScan > 0
			aCofinsXml[1] := aRetido[nScan][3]
			aCofinsXml[2] += aRetido[nScan][4]
			aCofinsXml[3] := aRetido[nScan][5]
		EndIf

		nScan := aScan(aRetido,{|x| x[1] == "IRRF"})
		If nScan > 0
			aIrrfXml[1] := aRetido[nScan][3]
			aIrrfXml[2] += aRetido[nScan][4]
			aIrrfXml[3] := aRetido[nScan][5]
		EndIf

		nScan := aScan(aRetido,{|x| x[1] == "CSLL"})
		If nScan > 0
			aCSLLXml[1] := aRetido[nScan][3]
			aCSLLXml[2] += aRetido[nScan][4]
			aCSLLXml[3] := aRetido[nScan][5]
		EndIf

		nScan := aScan(aRetido,{|x| x[1] == "INSS"})
		If nScan > 0
			aInssXml[1] := aRetido[nScan][3]
			aInssXml[2] += aRetido[nScan][4]
			aInssXml[3] := aRetido[nScan][5]
		EndIf

		//Carga Tributária
		If aProd[Nx][35] > 0
			cCargaTrb := " - Valor aproximado dos tributos: R$ " + ConvType(aProd[Nx][35],15,2) +"."
		EndIf

		//Outras retenções, sera colocado o valor 0 (zero), pois atualmente nao existe valor de Outras retencoes 
		If Len(aRetido) > 0
			nOutRet := 0
		EndIf
		nValLiq := aProd[Nx][27] - aPisXml[3][Nx] - aCofinsXml[3][Nx]  - Iif(Len(aInssXml[3]) > 1 .And. len( aProd ) > 1,aInssXml[3][Nx],aInssXml[1]) - Iif(Len(aIRRFXml[3]) > 1 .And. len( aProd ) > 1,aIRRFXml[3][Nx],aIRRFXml[1]) - aCSLLXml[3][Nx] - Iif(Len(aIssRet[4]) > 1 .And. len( aProd ) > 1,aIssRet[4][Nx],aIssRet[1])
		cString += "<servico>"
		cString += "<codigo>" + allTrim( aProd[nX][24] ) + "</codigo>"
		cString += "<aliquota>" + allTrim((iif(!empty( convType( DivCem(aISSQN[1][2]) ) ), convType( DivCem(aISSQN[1][2]), 7, 4 ),DivCem( aISSRet[3]) ))) + "</aliquota>"
		cString += "<cnae>"    + allTrim( aProd[nX][19] ) + "</cnae>"
		cString += "<codtrib>" + allTrim( aProd[nX][34] ) + allTrim( aProd[nX][32] ) + "</codtrib>"
		If !lNFeDesc
			cString += "<discr>" + AllTrim(cNatOper)+ cCargaTrb + "</discr>"
		Else
			cString += "<discr>" + AllTrim(cDiscrNFSe)+ cCargaTrb + "</discr>"
		EndIf
		cString += "<quant>"     + allTrim( convType( aProd[nX][ 9], 15, 2 ) ) + "</quant>"
		cString += "<valunit>"   + allTrim( convType( aProd[nX][10], 15, 2 ) ) + "</valunit>"
		cString += "<valtotal>"  + allTrim( convType( aProd[nX][28], 15, 2 ) ) + "</valtotal>"
		cString += "<basecalc>"  + allTrim( convType( aProd[nX][25], 15, 2 ) ) + "</basecalc>"
		cString += "<issretido>" + iif( !Empty( aISSRet[2] ), "1", "2" )       + "</issretido>"
		cString += "<valdedu>"   + allTrim( convType( aProd[nX][29], 15, 2 ) ) + "</valdedu>"
		cString += "<valpis>"    + allTrim( convType( aPisXml[1],    15, 2 ) ) + "</valpis>"
		cString += "<valcof>"    + allTrim( convType( aCofinsXml[1], 15, 2 ) ) + "</valcof>"
		cString += "<valinss>"   + allTrim( convType( aInssXml[1],   15, 2 ) ) + "</valinss>"
		cString += "<valir>"     + allTrim( convType( aIRRFXml[1],   15, 2 ) ) + "</valir>"
		cString += "<valcsll>"   + allTrim( convType( aCSLLXml[1],   15, 2 ) ) + "</valcsll>"
		cString += "<valiss>"    + allTrim( convType( aISSQN[1][3],  15, 2 ) ) + "</valiss>"
		cString += "<valissret>" + allTrim( convType( aIssRet[1],    15, 2 ) ) + "</valissret>"
		cString += "<outrasret>" + allTrim( convType( nOutRet,       15, 2 ) ) + "</outrasret>"
		cString += "<valliq>"    + allTrim( convType( nValLiq,       15, 2 ) ) + "</valliq>"
		cString += "<desccond>0</desccond>"
		cString += "<descinc>"   + allTrim( convType( aISSQN[1][6],  15, 2 ) ) + "</descinc>"
		cString += "<unidmed>" + Alltrim(aProd[Nx][08]) + "</unidmed>" //-- Nao Obrigat. - campo descontinuado
//		cString += "<tributavel></tributavel>" //Nao Obrigat. - sem uso, existe no grupo valores
		If !Empty( allTrim( aProd[nX][33] ) )
			cString += "<cfps>" + allTrim( aProd[nX][33] ) + "</cfps>" //-- codigo fiscal de prestacao de servico - Nao Obrigat.
		EndIf
		cString += "</servico>"

	Next nX

	cString += "</servicos>"

Return cString

//-----------------------------------------------------------------------
/*/{Protheus.doc} valores
Função para montar a tag de valores do XML de envio de NFS-e ao TSS.

@author Marcos Taranta
@since 23.01.2012

@param	aISSQN		Array contendo as informações sobre imposto.
@param	aRetido		Array contendo as informações sobre impostos retidos.
@param	aTotal		Array contendo os valores totais da nota.
@param	aDest		Array contendo as informações de destinatário.
@param	cCodMun		string contendo codigo do municipio prestador

@return	cString		Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------
static function valores( aISSQN, aRetido, aTotal, aDest, cCodMun )

	Local aCOFINSXML	:= { 0, 0, 0 }
	Local aCSLLXML	:= { 0, 0, 0 }
	Local aINSSXML	:= { 0, 0, 0 }
	Local aIRRFXML	:= { 0, 0, 0 }
	Local aISSRet		:= { 0, 0, 0 }
	Local aPISXML		:= { 0, 0, 0 }
	Local cString		:= ""
	Local nOutRet		:= 0
	Local nScan		:= 0

	nScan := aScan( aRetido, { | x | x[1] == "ISS" } )
	If nScan > 0
		aISSRet[1]	+= aRetido[nScan][3]
		aISSRet[2]	+= aRetido[nScan][5]
		aISSRet[3]	+= aRetido[nScan][4]
	EndIf

	nScan := aScan( aRetido, { | x | x[1] == "PIS" } )
	If nScan > 0
		aPISXML[1] := aRetido[nScan][3]
		aPISXML[2] += aRetido[nScan][4]
		aPISXML[3] += aRetido[nScan][2]
	EndIf

	nScan := aScan( aRetido, { | x | x[1] == "COFINS" } )
	If nScan > 0
		aCOFINSXML[1] := aRetido[nScan][3]
		aCOFINSXML[2] += aRetido[nScan][4]
		aCOFINSXML[3] += aRetido[nScan][2]
	EndIf

	nScan := aScan( aRetido, { | x | x[1] == "INSS" } )
	If nScan > 0
		aINSSXML[1] := aRetido[nScan][3]
		aINSSXML[2] += aRetido[nScan][4]
		aINSSXML[3] += aRetido[nScan][2]
	EndIf

	nScan := aScan( aRetido, { | x | x[1] == "IRRF" } )
	If nScan > 0
		aIRRFXML[1] := aRetido[nScan][3]
		aIRRFXML[2] += aRetido[nScan][4]
		aIRRFXML[3] += aRetido[nScan][2]
	EndIf

	nScan := aScan( aRetido, { | x | x[1] == "CSLL" } )
	If nScan > 0
		aCSLLXML[1] := aRetido[nScan][3]
		aCSLLXML[2] += aRetido[nScan][4]
		aCSLLXML[3] += aRetido[nScan][2]
	EndIf

	If Len( aRetido ) > 0
		nOutRet	:= 0
	EndIf

	cString	+= "<valores>"
	cString += "<iss>"        + allTrim( convType( aISSQN[1][3],  15, 2 ) ) + "</iss>"
	cString += "<issret>"     + allTrim( convType( aISSRet[1],    15, 2 ) ) + "</issret>"
	cString += "<outrret>"    + allTrim( convType( nOutRet,       15, 2 ) ) + "</outrret>"
	cString += "<pis>"        + allTrim( convType( aPISXML[1],    15, 2 ) ) + "</pis>"
	cString += "<cofins>"     + allTrim( convType( aCOFINSXml[1], 15, 2 ) ) + "</cofins>"
	cString += "<inss>"       + allTrim( convType( aINSSXML[1],   15, 2 ) ) + "</inss>"
	cString += "<ir>"         + allTrim( convType( aIRRFXML[1],   15, 2 ) ) + "</ir>"
	cString += "<csll>"       + allTrim( convType( aCSLLXML[1],   15, 2 ) ) + "</csll>"
	cString += "<aliqiss>"    + allTrim( convType( (DivCem(Iif( !empty( aISSQN[1][02] ), aISSQN[1][02], aISSRet[3] ))), 15, 4 ) ) + "</aliqiss>"
	cString += "<aliqpis>"    + allTrim( convType( aPISXML[2],    15,4 ) ) + "</aliqpis>"
	cString += "<aliqcof>"    + allTrim( convType( aCOFINSXML[2], 15, 4 ) ) + "</aliqcof>"
	cString += "<aliqinss>"   + allTrim( convType( aINSSXML[2],   15, 4 ) ) + "</aliqinss>"
	cString += "<aliqir>"     + allTrim( convType( aIRRFXML[2],   15, 4 ) ) + "</aliqir>"
	cString += "<aliqcsll>"   + allTrim( convType( aCSLLXML[2],   15, 4 ) ) + "</aliqcsll>"
	cString += "<valtotdoc>"  + allTrim( convType( aTotal[2],     15, 2 ) ) + "</valtotdoc>"
	cString += "<basecalculo>"+ allTrim( convType( aISSQN[1][1],  15, 2 ) ) + "</basecalculo>"
	//Novas tags solicitado pela neogrid
	cString += "<basecalculopis>"   + allTrim( convType( aPISXML[3],   15, 2 ) ) + "</basecalculopis>"
	cString += "<basecalculocofins>"+ allTrim( convType( aCOFINSXML[3],15, 2 ) ) + "</basecalculocofins>"
	cString += "<basecalculocsll>"  + allTrim( convType( aCSLLXML[3],  15, 2 ) ) + "</basecalculocsll>"
	cString += "<basecalculoirrf>"  + allTrim( convType( aIRRFXML[3],  15, 2 ) ) + "</basecalculoirrf>"
	cString += "<basecalculoinss>"  + allTrim( convType( aINSSXML[3],  15, 2 ) ) + "</basecalculoinss>"
	
	cString += "<vliquinfse>" + allTrim( convType( aTotal[2],     15, 2 ) ) + "</vliquinfse>"
	cString += "</valores>"

Return cString

//-----------------------------------------------------------------------
/*/{Protheus.doc} faturas
Função para montar a tag de faturas do XML de envio de NFS-e ao TSS.

@author Flavio Luiz Vicco
@since 08.08.2014

@param	aDupl		Array contendo informações sobre as faturas.

@return	cString		Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------
Static Function faturas( aDupl )
	Local cString	:= ""
	Local nX		:= 0

	If Len( aDupl ) > 0
		cString	+= "<faturas>"
		For nX := 1 To Len( aDupl )
			cString += "<fatura>"
			cString += "<numero>" + allTrim( aDupl[nX][1] ) + "</numero>"
			cString += "<valor>"  + allTrim( convType( aDupl[nX][3], 15, 2 ) ) + "</valor>"
			cString += "</fatura>"
		Next nX
		cString += "</faturas>"
	EndIf

Return cString

//-----------------------------------------------------------------------
/*/{Protheus.doc} pagtos
Função para montar a tag de valores do XML de envio de NFS-e ao TSS.

@author Marcos Taranta
@since 06.02.2012

@param	aDupl		Array contendo informações sobre os pagamentos.

@return	cString		Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------
Static Function pagtos( aDupl )
	Local cString	:= ""
	Local cTemp		:= ""
	Local nX		:= 0

	If Len( aDupl ) > 0
		cString	+= "<pagamentos>"
		For nX := 1 To Len( aDupl )
			cTemp := dToS( aDupl[nX][2] )
			cString += "<pagamento>"
			cString += "<parcela>" + iif( !Empty( allTrim( aDupl[nX][4] ) ), allTrim( aDupl[nX][4] ), "1" ) + "</parcela>"
			cString += "<dtvenc>"  + subStr( allTrim( cTemp ), 1, 4 ) + "-" + subStr( allTrim( cTemp ), 5, 2 ) + "-" + subStr( allTrim( cTemp ), 7, 2 ) + "</dtvenc>"
			cString += "<valor>"   + allTrim( convType( aDupl[nX][3], 15, 2 ) ) + "</valor>"
			cString += "</pagamento>"
		Next nX
		cString += "</pagamentos>"
	EndIf

Return cString

//-----------------------------------------------------------------------
/*/{Protheus.doc} deducoes
Função para montar a tag de deduções do XML de envio de NFS-e ao TSS.

@author Marcos Taranta
@since 23.01.2012

@param	aProd	Array contendo as informações sobre os serviços.
@param	aDeduz	Array contendo as informações sobre as deduções.

@return	cString	Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------
Static Function deducoes( aISSQN, aDeduz, aDeducao, aConstr )

	Local cCPFCNPJ	:= ""
	Local cString	:= ""
	Local nX		:= 0

	If Len( aDeduz ) <= 0 .And. Len( aDeducao ) <= 0 
		Return cString
	EndIf

	cString	+= "<deducoes>"
	cString += "<desccond>0</desccond>"
	cString += "<descincond>" + allTrim( convType( aISSQN[1][6], 15, 2 ) ) + "</descincond>"
	If  Len( aDeduz ) > 0
		For nX := 1 To Len( aDeduz )
			cCPFCNPJ := allTrim( posicione( "SA2", 1, xFilial( "SA2" ) + aDeduz[nX][3] + aDeduz[nX][4], "A2_CGC" ) )
			cString += "<deducao>"
			cString += "<tipo>"       + iif( empty( allTrim( aDeduz[nX][1] ) ), "1", iif( allTrim( aDeduz[nX][1] ) == "1", "1", "2") ) + "</tipo>"
			cString += "<modal>"      + iif( empty( allTrim( aDeduz[nX][2] ) ), "1", iif( allTrim( aDeduz[nX][2] ) == "1", "1", "2" ) ) + "</modal>"
			If !Empty( aConstr )
				cString += '<codobra>'+ AllTrim(aConstr[01]) + '</codobra>'
				cString += '<codart>' + AllTrim(aConstr[02]) +'</codart>'
			EndIf
			cString += "<codobra>"    + "</codobra>"
			cString += "<codart>"     + "</codobra>"
			cString += "<cpfcnpj>"    + iif( empty( cCPFCNPJ ), "00000000000191", cCPFCNPJ ) + "</cpfcnpj>"
			cString += "<numeronf>"   + iif( empty( allTrim( aDeduz[nX][6] ) ), "1", allTrim( aDeduz[nX][6] ) ) + "</numeronf>"
			cString += "<totalnf>"    + allTrim( convType( aDeduz[nX][7], 15, 2 ) ) + "</totalnf>"
			cString += "<percentual>" + iif( aDeduz[nX][1] == "1", allTrim( convType( aDeduz[nX][8], 15, 2 ) ), "0.00" ) + "</percentual>"
			cString += "<valor>"      + iif( aDeduz[nX][1] == "2", allTrim( convType( aDeduz[nX][9], 15, 2 ) ), "0.00" ) + "</valor>"
			cString += "</deducao>"
		Next nX
	Else
		For nX := 1 To Len( aDeducao )
			cString += "<deducao>"
			cString += "<tipo>1</tipo>"
			cString += "<modal>1</modal>"
			If !Empty( aConstr )
				cString += '<codobra>'+ AllTrim(aConstr[01]) + '</codobra>'
				cString += '<codart>' + AllTrim(aConstr[02]) +'</codart>'
			EndIf
			cString += "<cpfcnpj>" + iif( empty( cCPFCNPJ ), "00000000000191", cCPFCNPJ ) + "</cpfcnpj>"
			cString += "<numeronf>1</numeronf>"
			cString += "<totalnf>0.00</totalnf>"
			cString += "<percentual>0.00</percentual>"
			cString += "<valor>" + allTrim( convType( aDeducao[nX][1], 15, 2 ) ) + "</valor>"
			cString += "</deducao>"
		Next nX
	EndIf
	cString	+= "</deducoes>"

Return cString

//-----------------------------------------------------------------------
/*/{Protheus.doc} infCompl
Função para montar a tag de informações complementares do XML de envio
de NFS-e ao TSS.

@author Marcos Taranta
@since 23.01.2012

@param	cMensCli	Mensagem complementar ao cliente.
@param	cMensFis	Mensagem complementar ao fisco.

@return	cString		Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------
Static Function infCompl( cMensCli, cMensFis, lNFeDesc, cDescrNFSe )
	Local cString := ""
                
	If Empty(cMensCli + cMensFis)
		cMensCli := "-"
	EndIf
	If Empty(cDescrNFSe)
		cDescrNFSe := "-"
	EndIf
	cString += "<infcompl>"
	//-- Descricao - Tam 2000 - Obrigat.
	If !lNFeDesc
		cString += "<descricao>" + cMensCli + space( 1 ) + cMensFis + "</descricao>"
	Else
		cString += "<descricao>" + Alltrim(cDescrNFSe) + "</descricao>"
	EndIf
	//-- Observacao - Tam 255 - Nao Obrigat.
	cString += "<observacao>" + cMensCli + space( 1 ) + cMensFis + "</observacao>"
	//-- Construcao Civil: <constriciv>  - Nao Obrigat.
	//-- Atividade Portuaria: <ativport> - Nao Obrigat.
	cString += "</infcompl>"

Return cString

//-----------------------------------------------------------------------
/*/{Protheus.doc} convType
Função para converter qualquer tipo de informação para string.

@author Marcos Taranta
@since 19.01.2012

@param	xValor	Informação a ser convertida.
@param	nTam	Tamanho final da string a ser retornada.
@param	nDec	Número de casa decimais para informações numéricas.

@return	cNovo	Informação em forma de string a ser retornada.
/*/
//-----------------------------------------------------------------------
static function convType( xValor, nTam, nDec )
	
	local	cNovo	:= ""
	
	default	nDec	:= 0
	
	do case
		case valType( xValor ) == "N"
			if xValor <> 0
				cNovo	:= allTrim( str( xValor, nTam, nDec ) )
				cNovo	:= strTran( cNovo, ",", "." )
			else
				cNovo	:= "0"
			endif
		case valType( xValor ) == "D"
			cNovo	:= fsDateConv( xValor, "YYYYMMDD" )
			cNovo	:= subStr( cNovo, 1, 4 ) + "-" + subStr( cNovo, 5, 2 ) + "-" + subStr( cNovo, 7 )
		case valType( xValor ) == "C"
			if nTam == nil
				xValor	:= allTrim( xValor )
			endif
			default	nTam	:= 60
			cNovo := allTrim( encodeUTF8( noAcento( subStr( xValor, 1, nTam ) ) ) )
	endcase
	
return cNovo

//-----------------------------------------------------------------------
/*/{Protheus.doc} myGetEnd
Função para pegar partes do endereço de uma única string.

@author Marcos Taranta
@since 24.01.2012

@param	cEndereco	String do endereço único.
@param	cAlias		Alias da base.

@return	aRet		Partes separadas do endereço em um array.
/*/
//-----------------------------------------------------------------------
static function myGetEnd( cEndereco, cAlias )
	
	local aRet		:= { "", 0, "", "" }
	
	local cCmpEndN	:= subStr( cAlias, 2, 2 ) + "_ENDNOT"
	local cCmpEst	:= subStr( cAlias, 2, 2 ) + "_EST"
	
	// Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
	// Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
	if ( &( cAlias + "->" + cCmpEst ) == "DF" ) .Or. ( ( cAlias )->( FieldPos( cCmpEndN ) ) > 0 .And. &( cAlias + "->" + cCmpEndN ) == "1" )
		aRet[1] := cEndereco
		aRet[3] := "SN"
	else
		aRet := fisGetEnd( cEndereco )
	endIf
	
return aRet 

//-----------------------------------------------------------------------
/*/{Protheus.doc} vldIE
Valida IE.

@author Marcos Taranta
@since 24.01.2012

@param	cInsc	IE.
@param	lContr	Caso .F., retorna "ISENTO".

@return	aRet	Retorna a IE.
/*/
//-----------------------------------------------------------------------
Static Function vldIE( cInsc, lContr )
	
	local cRet		:= ""
	
	local nI		:= 1
	
	default lContr	:= .T.
	
	for nI := 1 to len( cInsc )
		if isDigit( subs( cInsc, nI, 1 ) ) .Or. isAlpha( subs( cInsc, nI, 1 ) )
			cRet += subs( cInsc, nI, 1)
		endif
	next
	
	cRet := allTrim( cRet )
	if "ISENT" $ upper( cRet )
		cRet := ""
	endif
	
	if !( lContr ) .And. !empty( cRet )
		cRet := "ISENTO"
	endif
	
return cRet 


//-----------------------------------------------------------------------
/*/{Protheus.doc} UfIBGEUni
Funcao que retorna o codigo da UF do participante, de acordo com a tabela 
disponibilizada pelo IBGE.

@author Simone Oliveira
@since 02.08.2012

@param	cUf 	Sigla da UF do cliente/fornecedor

@return	cCod	Codigo da UF
/*/
//-----------------------------------------------------------------------

Static Function UfIBGEUni (cUf,lForceUF)
Local nX         := 0
Local cRetorno   := ""
Local aUF        := {}

DEFAULT lForceUF := .T.

aadd(aUF,{"RO","11"})
aadd(aUF,{"AC","12"})
aadd(aUF,{"AM","13"})
aadd(aUF,{"RR","14"})
aadd(aUF,{"PA","15"})
aadd(aUF,{"AP","16"})
aadd(aUF,{"TO","17"})
aadd(aUF,{"MA","21"})
aadd(aUF,{"PI","22"})
aadd(aUF,{"CE","23"})
aadd(aUF,{"RN","24"})
aadd(aUF,{"PB","25"})
aadd(aUF,{"PE","26"})
aadd(aUF,{"AL","27"})
aadd(aUF,{"SE","28"})
aadd(aUF,{"BA","29"})
aadd(aUF,{"MG","31"})
aadd(aUF,{"ES","32"})
aadd(aUF,{"RJ","33"})
aadd(aUF,{"SP","35"})
aadd(aUF,{"PR","41"})
aadd(aUF,{"SC","42"})
aadd(aUF,{"RS","43"})
aadd(aUF,{"MS","50"})
aadd(aUF,{"MT","51"})
aadd(aUF,{"GO","52"})
aadd(aUF,{"DF","53"})
aadd(aUF,{"EX","99"})

If !Empty(cUF)
	nX := aScan(aUF,{|x| x[1] == cUF})
	If nX == 0
		nX := aScan(aUF,{|x| x[2] == cUF})
		If nX <> 0
			cRetorno := aUF[nX][1]
		EndIf
	Else
		cRetorno := aUF[nX][2]
	EndIf
Else
	cRetorno := IIF(lForceUF,"",aUF)
EndIf

Return(cRetorno)

//-----------------------------------------------------------------------
/*/{Protheus.doc} Cancela
Função para montar a tag de cancelamento do XML de envio de NFS-e

@author Flavio Luiz Vicco
@since 15.08.2014

@param	cMotCancela	Motivo do cancelamento do documento.

@return	cString		Tag montada em forma de string.
/*/
//-----------------------------------------------------------------------

User Function nfseXMLCan( cNota, cMotCancela )

	Local cString := ""

	cString	+= "<rps>"
	cString	+= "<cancelamento>"
	cString += "<cpfcnpj>"    + allTrim( SM0->M0_CGC ) + "</cpfcnpj>"
	cString += "<numeronfse>" + allTrim( cNota ) + "</numeronfse>"
	cString += "<codmunibge>" + allTrim( SM0->M0_CODMUN ) + "</codmunibge>"
	cString += "<motcanc>"    + cMotCancela + "</motcanc>"
	//-- Existem municipios que fazem varias inscricoes municipais para mesmo CNPJ para controlar cada ramo de atividade.
	cString += "<inmunprest>" + allTrim( SM0->M0_INSCM ) + "</inmunprest>"
	cString	+= "</cancelamento>"
	cString	+= "</rps>"
	cString := encodeUTF8( cString )

Return cString
//-----------------------------------------------------------------------
/*/{Protheus.doc} DivCem
Função para montar a tag de Aliquota do XML de envio de NFS-e

@author Cleiton Genuino
@since 14.06.2015

@return nValor		    Valor de retorno  da Tag "aliquota"
/*/
//-----------------------------------------------------------------------

Static Function DivCem ( nVP )

Default nVP := 0
//VP	Valor Percentual	Valor percentual da alíquotano formato: 0.0000
//Ex: 1% = 0.01 ; 25,5% = 0.255 ; 100% = 1.0000 ou 1

If nVP > 0
nVP := NOROUND((nVP /100), 4)
Endif


Return nVP
