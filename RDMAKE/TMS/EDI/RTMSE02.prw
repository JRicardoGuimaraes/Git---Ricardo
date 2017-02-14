#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTMSE02   บAutor  ณ Vinํcius Moreira   บ Data ณ 08/04/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera NOTIFIS por viagem.                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RTMSE02 ()

Local cPerg     := PadR("RTMSE02", Len(SX1->X1_GRUPO))
Private cViagem := ""

PutSx1(	cPerg, "01", "Viagem", "", "", ;
			"MV_CH1", "C", TamSX3("DTQ_VIAGEM")[1], 0, 0, "G", "", "DTQ", "", "", ;
			"MV_PAR01", "", "", "", "", "", "", "", "", ;
			"", "", "", "N", "", "", "", "")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณViagens                                                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("DTQ")
DTQ->(dbSetOrder(1))//DTQ_FILIAL+DTQ_VIAGEM
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณComplemento de Viagens                                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("DTR")
DTR->(dbSetOrder(1))//DTR_FILIAL+DTR_FILORI+DTR_VIAGEM+DTR_ITEM
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMovimento de Viagens                                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("DUD")
DUD->(dbSetOrder(2))//DUD_FILIAL+DUD_FILORI+DUD_VIAGEM+DUD_SEQUEN+DUD_FILDOC+DUD_DOC+DUD_SERIE
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDocumentos de Transporte                                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("DT6")
DT6->(dbSetOrder(1))//DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE

While Pergunte (cPerg, .T.)
	cViagem := MV_PAR01
	If DTQ->(dbSeek(xFilial("DTQ")+cViagem)) .And. DTR->(dbSeek(xFilial("DTR")+DTQ->(DTQ_FILORI+DTQ_VIAGEM)))
		Processa({|| fProcessa() } , "Gera็ใo de arquivo", "Iniciando processamento..." , .T. )	
	Else
		Help (" ", 1, "RTMSE0201",,"Viagem nใo encontrada.", 3, 0)
	EndIf
EndDo

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfProcessa บAutor  ณ Vinํcius Moreira   บ Data ณ 08/04/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento do arquivo.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fProcessa ()

Local cAliasQry := GetNextAlias()
Local cLinha    := ""
Local cDirOri   := "\"
Local cDirDes   := ""
Local cNomArq   := "V" + cViagem + "_" + dToS(Date()) + strTran(Time(), ":", "") + ".txt"
Local cDatEdi   := GravaData(dDataBase, .F., 1)
Local cHorEdi   := StrTran(Time(), ":", "")
Local nTotMer   := 0
Local nTotPes   := 0
Local nTotVol   := 0
Private nHnd    := fCreate( cDirOri + cNomArq, 0)

If nHnd < 0
	Help (" ", 1, "RTMSE0202",,"Nใo foi possํvel criar o arquivo temporario.", 3, 0)
ElseIf fGetRegs(cAliasQry)

	cLinha := "000"										//01 - IDENTIFICADOR DE REGISTRO
	cLinha += PadR(SM0->M0_NOMECOM, 35, " ")			//02 - IDENTIFICAวรO DO REMETENTE
	cLinha += PadR(Posicione("SA2", 1, xFilial("SA2")+DTR->(DTR_CREADI+DTR_LOJCRE), "A2_NOME"), 35, " ") //03 - IDENTIFICAวรO DO DESTINATมRIO
	cLinha += cDatEdi									//04 - DATA
	cLinha += Left(cHorEdi, 4)							//05 - HORA
	cLinha += "NOT"										//06 - IDENTIFICAวรO DO INTERCยMBIO - PARTE 1
	cLinha += Left(cDatEdi, 4)							//06 - IDENTIFICAวรO DO INTERCยMBIO - PARTE 2
	cLinha += Left(cHorEdi, 4)							//06 - IDENTIFICAวรO DO INTERCยMBIO - PARTE 3
	cLinha += "0"										//06 - IDENTIFICAวรO DO INTERCยMBIO - PARTE 4
	cLinha += Space(145)								//07 - FILLER
	fGrvLin (cLinha)
	
	cLinha := "310"										//01 - IDENTIFICADOR DE REGISTRO
	cLinha += "NOTFI"									//02 - IDENTIFICAวรO DO DOCUMENTO - PARTE 1
	cLinha += Left(cDatEdi, 4)							//02 - IDENTIFICAวรO DO DOCUMENTO - PARTE 2
	cLinha += Left(cHorEdi, 4)							//02 - IDENTIFICAวรO DO DOCUMENTO - PARTE 3
	cLinha += "0"										//02 - IDENTIFICAวรO DO DOCUMENTO - PARTE 4
	cLinha += Space(223)								//03 - FILLER
	fGrvLin (cLinha)
	
	DUD->(dbSeek(xFilial("DUD")+DTQ->(DTQ_FILORI+DTQ_VIAGEM)))
	DT6->(dbSeek(xFilial("DT6")+DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE)))
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosicionando informa็๕es do remetente.                                               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SA1->(dbSeek(xFilial("SA1")+DT6->(DT6_CLIREM+DT6_LOJREM)))
	
	cLinha := "311"										//01 - IDENTIFICADOR DE REGISTRO
	cLinha += PadR(SA1->A1_CGC, 14, " ")				//02 - CNPJ EMBARCADORA
	cLinha += PadR(SA1->A1_INSCR, 15, " ")				//03 - INSCRIวรO ESTADUAL EMBARCADORA
	cLinha += PadR(SA1->A1_END, 40, " ")				//04 - ENDEREวO (LOGRADOURO)
	cLinha += PadR(SA1->A1_MUN, 35, " ")				//05 - CIDADE (MUNICอPIO)
	cLinha += PadR(SA1->A1_CEP, 09, " ")				//06 - CำDIGO POSTAL
	cLinha += PadR(SA1->A1_EST, 09, " ")				//07 - SUBENTIDADE DE PAอS
	cLinha += GravaData(dDataBase, .F., 5)				//08 - DATA DO EMBARQUE DAS MERCADORIAS
	cLinha += PadR(SA1->A1_NOME, 40, " ")				//09 - NOME DA EMPRESA EMBARCADORA (RAZรO SOCIAL)
	cLinha += Space(67)									//10 - FILLER
	fGrvLin (cLinha)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosicionando informa็๕es do destinatario.                                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	SA1->(dbSeek(xFilial("SA1")+DT6->(DT6_CLIREM+DT6_LOJREM)))
	
	cLinha := "312"										//01 - IDENTIFICADOR DE REGISTRO
	cLinha += PadR(SA1->A1_NOME, 40, " ")				//02 - RAZรO SOCIAL
	cLinha += PadR(SA1->A1_CGC, 14, " ")				//03 - C.G.C. / C. P. F.
	cLinha += PadR(SA1->A1_INSCR, 15, " ")				//04 - INSCRIวรO ESTADUAL
	cLinha += PadR(SA1->A1_END, 40, " ")				//05 - ENDEREวO (LOGRADOURO)
	cLinha += PadR(SA1->A1_BAIRRO, 20, " ")			//06 - BAIRRO
	cLinha += PadR(SA1->A1_MUN, 35, " ")				//07 - CIDADE (MUNICอPIO)
	cLinha += PadR(SA1->A1_CEP, 09, " ")				//08 - CำDIGO POSTAL
	cLinha += Space(09)									//09 - CำDIGO DE MUNICอPIO
	cLinha += PadR(SA1->A1_EST, 09, " ")				//10 - SUBENTIDADE DE PAอS
	cLinha += Space(04)									//11 - มREA DE FRETE
	cLinha += Space(35)									//12 - NฺMERO DE COMUNICAวรO
	cLinha += If(SA1->A1_PESSOA=="J","1","2")			//13 - TIPO DE IDENTIFICAวรO DO DESTINATมRIO
	cLinha += Space(06)									//14 - FILLER
	fGrvLin (cLinha)
	
	While (cAliasQry)->(!Eof())
		
		DTC->(dbGoTo((cAliasQry)->DTCREC))
		
		cLinha := "313" 								//01 - IDENTIFICADOR DE REGISTRO
		cLinha += PadR(DTQ->DTQ_VIAGEM, 15, " ") 		//02 - NUM. ROMANEIO/COLETA.RESUMO DE CARGA
		cLinha += PadR(DTQ->DTQ_ROTA  , 07, " ") 		//03 - CำDIGO DA ROTA
		cLinha += "1" 									//04 - MEIO DE TRANSPORTE
		cLinha += "1" 									//05 - TIPO DO TRANSPORTE DA CARGA
		cLinha += "1" 									//06 - TIPO DE CARGA
		cLinha += If(DTC->DTC_DEVFRE=="2", "F", "C") 	//07 - CONDIวรO DE FRETE
		cLinha += PadR(DTC->DTC_SERNFC  , 03, " ")  	//08 - SษRIE DA NOTA FISCAL
		cLinha += SubStr(DTC->DTC_NUMNFC  , 02, 08) 	//09 - NษMERO DA NOTA FISCAL
		cLinha += GravaData(dDataBase, .F., 5) 		//10 - DATA DE EMISSรO
		cLinha += PadR("PEวAS", 15, " ") 				//11 - NATUREZA (TIPO) DA MERCADORIA
		cLinha += PadR("CAIXAS", 15, " ") 				//12 - ESPษCIE DE ACONDICIONAMENTO
		cLinha += StrZero(DTC->DTC_QTDVOL*100, 07) 	//13 - QTDE DE VOLUMES
		cLinha += StrZero(DTC->DTC_VALOR *100, 15) 	//14 - VALOR TOTAL DA NOTA
		cLinha += StrZero(DTC->DTC_PESO  *100, 15) 	//15 - PESO TOTAL DA MERCADORIA A TRANSP.
		cLinha += StrZero(0, 05) 						//16 - PESO DENSIDADE/CUBAGEM
		cLinha += "S" 									//17 - INCIDสNCIA DE ICMS (S/N)?
		cLinha += "S" 									//18 - SEGURO Jม EFETUADO (S/N)?
		cLinha += StrZero(0, 15) 						//19 - VALOR DO SEGURO
		cLinha += StrZero(0, 15) 						//20 - VALOR A SER COBRADO
		cLinha += Space(07) 							//21 - NO DA PLACA CAMINHรO OU DA CARRETA
		cLinha += "N" 									//22 - PLANO DE CARGA RมPIDA (S/N)?
		cLinha += StrZero(0, 15) 						//23 - 2VALOR DO FRETE PESO-VOLUME
		cLinha += StrZero(0, 15) 						//24 - VALOR AD VALOREM
		cLinha += StrZero(0, 15) 						//25 - VALOR TOTAL DAS TAXAS
		cLinha += StrZero(0, 15) 						//26 - VALOR TOTAL DO FRETE
		cLinha += " " 									//27 - AวรO DO DOCUMENTO
		cLinha += StrZero(0, 10) 						//28 - VALOR DO ICMS
		cLinha += StrZero(0, 10) 						//29 - VALOR DO ICMS RETIDO
		cLinha += " " 									//30 - INDICAวรO DE BONIFICAวรO (S/N)
		cLinha += "  " 									//31 - FILLER
		cLinha += PadR(DTC->DTC_SERIE, 05, " ") 		//32 - SษRIE DO CTRC
		cLinha += PadR(DTC->DTC_DOC  , 12, " ") 		//33 - NฺMERO DO CTRC
		fGrvLin (cLinha)
		
		nTotMer += DTC->DTC_VALOR
		nTotPes += DTC->DTC_PESO
		nTotVol += DTC->DTC_QTDVOL
		
		(cAliasQry)->(dbSkip())
	EndDo
	
	cLinha := "318"										//01 - IDENTIFICADOR DE REGISTRO
	cLinha += StrZero(nTotMer * 100, 15)				//02 - VALOR TOTAL DAS NOTAS FISCAIS
	cLinha += StrZero(nTotPes * 100, 15)				//03 - PESO TOTAL DAS NOTAS FISCAIS
	cLinha += StrZero(0, 15)							//04 - PESO TOTAL DENSIDADE/CUBAGEM
	cLinha += StrZero(nTotVol * 100, 15)				//05 - QUANTIDADE TOTAL DE VOLUMES
	cLinha += StrZero(0, 15)							//06 - VALOR TOTAL A SER COBRADO
	cLinha += StrZero(0, 15)							//07 - VALOR TOTAL DO SEGURO
	cLinha += Space(147)								//08 - FILLER
	fGrvLin (cLinha)
	
	fClose(nHnd)	
	cDirDes := Alltrim(Upper(cGetFile( "Op็ใo indisponํvel no momento| " , "Selecione o Diret๓rio", Nil, "", .F. , GETF_LOCALHARD + GETF_RETDIRECTORY)))
	If !Empty(cDirDes)
		CpyS2T(cDirOri + cNomArq, cDirDes)
		Aviso("ATENวรO","Arquivo transferido com sucesso.",{"OK"},1,"")
	EndIf
	fErase(cDirOri + cNomArq)
EndIf

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fGetRegs บAutor  ณ Vinํcius Moreira   บ Data ณ 08/04/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Captura registros para gera็ใo do arquivo.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGetRegs (cAliasQry)

Local lRet   := .F.
Local cQuery := ""

cQuery += "  SELECT " + CRLF
cQuery += "    DTC.R_E_C_N_O_ DTCREC " + CRLF
cQuery += "   FROM " + RetSqlName("DUD") + " DUD " + CRLF
cQuery += "  INNER JOIN " + RetSqlName("DTC") + " DTC ON " + CRLF
cQuery += "        DTC.DTC_FILIAL = '" + xFilial("DTC") + "' " + CRLF
cQuery += "    AND DTC.DTC_FILDOC = DUD.DUD_FILDOC " + CRLF
cQuery += "    AND DTC.DTC_DOC    = DUD.DUD_DOC " + CRLF
cQuery += "    AND DTC.DTC_SERIE  = DUD.DUD_SERIE " + CRLF
cQuery += "    AND DTC.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "  WHERE DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF
cQuery += "    AND DUD.DUD_FILORI = '" + cFilAnt + "' " + CRLF
cQuery += "    AND DUD.DUD_VIAGEM = '" + cViagem + "' " + CRLF
cQuery += "    AND DUD.D_E_L_E_T_ = ' ' " + CRLF
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .T.)
lRet := (cAliasQry)->(!Eof())

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fGrvLin  บAutor  ณ Vinํcius Moreira   บ Data ณ 08/04/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava linha no arquivo.                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGrvLin (cLinha)
cLinha += CRLF
FWrite(nHnd,cLinha,Len(cLinha))
Return 