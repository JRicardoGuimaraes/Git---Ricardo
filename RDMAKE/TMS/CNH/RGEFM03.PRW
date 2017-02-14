#Include "aArray.ch"
#Include "jSon.ch"
#Include "Protheus.ch"
#Include "RwMake.ch"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posição das informações do vetor de origem.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#Define nOCODEXT 01
#Define nODESCRI 02
#Define nOLOGRAD 03
#Define nONUMERO 04
#Define nOCOMPLE 05
#Define nOBAIRRO 06
#Define nOCEP    07
#Define nOCIDADE 08
#Define nOESTADO 09
#Define nOLATITU 10
#Define nOLONGIT 11
#Define nOBANDEI 12
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posição das informações do vetor de documentos.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#Define nDCODEXT 01
#Define nDDESCRI 02
#Define nDLOGRAD 03
#Define nDNUMERO 04
#Define nDCOMPLE 05
#Define nDBAIRRO 06
#Define nDCEP    07
#Define nDCIDADE 08
#Define nDESTADO 09
#Define nDLATITU 10
#Define nDLONGIT 11
#Define nDBANDEI 12
#Define nDTIPPAR 13
#Define nDHORINI 14
#Define nDHORFIM 15
#Define nDPRVCHG 16
#Define nDNOTAS  17
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posição das informações do vetor de notas fiscais.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#Define nNCHASSI 01
#Define nNNUMNFC 02
#Define nNSERNFC 03
#Define nNPRODUT 04
#Define nNVALOR  05
#Define nNVOLUME 06
#Define nNPESO   07
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RGEFM03   ºAutor  ³ Vinícius Moreira   º Data ³ 16/09/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fonte responsavel pela integração com a Buonny.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RGEFM03 (cFilVia, cNumVia, lExibe, lMonRet)

Local aArea			:= GetArea()
Local aAreaDTQ		:= DTQ->(GetArea())
Local aAreaDTR		:= DTR->(GetArea())
Local aAreaDA3		:= DA3->(GetArea())
Local aAreaSA2		:= SA2->(GetArea())
Local aAreaDUP		:= DUP->(GetArea())
Local aAreaDA4		:= DA4->(GetArea())
Local aAreaSM0		:= SM0->(GetArea())
Local aAreaDTC		:= DTC->(GetArea())
Local lRet			:= .F.
Local cSerBuonny	:= SuperGetMv("ES_GEFM03C",,"1|3")
Default lMonRet 	:= .F.
Private lMonite 	:= lMonRet
Default lExibe 		:= .T.
Private lShowMsg 	:= lExibe

dbSelectArea("DTQ")		//Viagens
DTQ->(dbSetOrder(2))	//DTQ_FILIAL+DTQ_FILORI+DTQ_VIAGEM+DTQ_ROTA
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posicionando tabela de viagens.                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If DTQ->(dbSeek(xFilial("DTQ")+cFilVia+cNumVia)) .And. DTQ->DTQ_SERTMS $ cSerBuonny
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posicionando tabela de movimento de veículos da viagem.                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("DTR")		//Veiculos da Viagem
	DTR->(dbSetOrder(1))	//DTR_FILIAL+DTR_FILORI+DTR_VIAGEM+DTR_ITEM
	DTR->(dbSeek(DTQ->(DTQ_FILIAL+DTQ_FILORI+DTQ_VIAGEM) + StrZero(1, Len(DTR->DTR_ITEM))))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posicionando tabela de veículo da viagem.                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("DA3")		//Cadastro de veículos
	DA3->(dbSetOrder(1))	//DA3_FILIAL+DA3_COD
	DA3->(dbSeek(xFilial("DA3")+DTR->DTR_CODVEI))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posicionando tabela de movimento de motoristas da viagem.                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("DUP")		//Motoristas da Viagem
	DUP->(dbSetOrder(1))	//DUP_FILIAL+DUP_FILORI+DUP_VIAGEM+DUP_ITEDTR+DUP_CODMOT
	DUP->(dbSeek(DTR->(DTR_FILIAL+DTR_FILORI+DTR_VIAGEM) + StrZero(1, Len(DUP->DUP_ITEDTR))))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posicionando tabela de motoristas da viagem.                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("DA4")		//Cadastro de motoristas
	DA4->(dbSetOrder(1))	//DA4_FILIAL+DA4_COD
	DA4->(dbSeek(xFilial("DA4")+DUP->DUP_CODMOT))	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define indice de pesquisa de nota, para uso posterior.                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("DTC")
	DTC->(dbSetOrder(3))//DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE+DTC_SERVIC+DTC_CODPRO
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define indice de pesquisa de coletas, para uso posterior.                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("DT5")
	DT5->(dbSetOrder(4))//DT5_FILIAL+DT5_FILDOC+DT5_DOC+DT5_SERIE

	lRet := fIntegra ()
EndIf

RestArea(aAreaDTC)
RestArea(aAreaSM0)
RestArea(aAreaDA4)
RestArea(aAreaDUP)
RestArea(aAreaSA2)
RestArea(aAreaDA3)
RestArea(aAreaDTR)
RestArea(aAreaDTQ)
RestArea(aArea)

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fIntegra ºAutor  ³ Vinícius Moreira   º Data ³ 16/09/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integração com Buonny.                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fIntegra ()

Local lRet 			:= .F.
Local cUrl 			:= SuperGetMv("ES_GEFM03A",,"http://tstportal.buonny.com.br/portal/viagens.json")
Local cToken  		:= SuperGetMv("ES_GEFM03B",,"47ce0f1111cc03ad94b877ea6c86f875")
Local cDirBkp 		:= SuperGetMv("ES_GEFM03F",,"")
Local aAlvos 		:= {}
Local aaAlvo 
Local aDadosCarga 	:= {}
Local aaCarga 
Local aVeiculos 	:= {}
Local aaVeiculo
Local aIscas 		:= {}
Local aaIsca 
Local aEmpresas 	:= {}
Local aaEmpresa
Local cJson 		:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tipos de transporte Buonny.                                               ³
//³1 - Transferência                                                         ³
//³2 - Distribuição                                                          ³
//³9 - Coleta                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aSerTms		:= {9,1,2}
Local aOrigem 	:= {}
Local aDocs		:= {}
Local nDoc 		:= 1
Local nNota		:= 1
Local cRetorno  	:= ""
Local aaRetorno 	:= {}
Local cMsgAvi		:= ""
Local cArqEnvio	:= DTQ->DTQ_FILORI + "-" + DTQ->DTQ_VIAGEM + "_envio.txt"
Local cArqRetorno	:= DTQ->DTQ_FILORI + "-" + DTQ->DTQ_VIAGEM + "_retorno.txt"
Local nNumSol 		:= 0
Local aErros 		:= ""
Local nErro 		:= 0
Local lErro 		:= .F.
Private aaBuonny

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Checa se diretorio esta configurado.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cDirBkp)
	Help (" ", 1, "RGEFM0301",,"Diretorio de backup de arquivos não configurado.", 3, 0)
	Return lRet
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Checa se previsao de inicio de viagem foi preenchido.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Empty(DTR->DTR_DATINI) .Or. Empty(DTR->DTR_HORINI)
	Help (" ", 1, "RGEFM0302",,"Data ou hora de previsão de inicio viagem não preenchida.", 3, 0)
	Return lRet	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Checa se previsao de fim de viagem foi preenchido.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Empty(DTR->DTR_DATFIM) .Or. Empty(DTR->DTR_HORFIM)
	Help (" ", 1, "RGEFM0303",,"Data ou hora de previsão de fim viagem não preenchida.", 3, 0)
	Return lRet	
EndIf

aaBuonny := Array(#)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Chave de autenticação                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aaBuonny[#'autenticacao'] := Array(#)
aaBuonny[#'autenticacao'][#'token'] := cToken
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados da viagem                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aaBuonny[#'cnpj_cliente'] 				:= fCGCClient()
aaBuonny[#'cnpj_embarcador'] 			:= fCGCClient()
aaBuonny[#'cnpj_transportador'] 		:= fCGCTransp()
aaBuonny[#'cnpj_gerenciadora_de_risco']	:= fCGCGRisco()
aaBuonny[#'pedido_cliente'] 			:= DTQ->DTQ_FILORI+DTQ->DTQ_VIAGEM
aaBuonny[#'numero_liberacao'] 			:= 0
aaBuonny[#'tipo_de_transporte'] 		:= aSerTms[Val(DTQ->DTQ_SERTMS)]
aaBuonny[#'observacao'] 					:= fGetOBS ()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados do motorista da viagem                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aaBuonny[#'motorista'] := Array(#)
aaBuonny[#'motorista'][#'nome']		:= Capital(AllTrim(DA4->DA4_NOME))
aaBuonny[#'motorista'][#'cpf'] 		:= AllTrim(DA4->DA4_CGC)
aaBuonny[#'motorista'][#'telefone']	:= AllTrim(DA4->DA4_TEL)
If DA4->(FieldPos("DA4_XRADIO")) > 0
	aaBuonny[#'motorista'][#'radio' ]	:= DA4->DA4_XRADIO
Else
	aaBuonny[#'motorista'][#'radio' ]	:= ""
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados das placas da viagem                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aaBuonny[#'veiculos'] := Array(#)
aaBuonny[#'veiculos'][#'placa'] := fGetPlacas()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados da origem da viagem                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aOrigem := fGetOrigem()
If Len(aOrigem) == 0
	U_RGEFM03A(DTQ->DTQ_FILORI, DTQ->DTQ_VIAGEM, "Informação de origem não encontrada.")
	Help (" ", 1, "RGEFM0304",,"Informação de origem não encontrada.", 3, 0)
Else
	aaBuonny[#'origem'] := Array(#)
	aaBuonny[#'origem'][#'codigo_externo']	:= aOrigem[nOCODEXT]
	aaBuonny[#'origem'][#'descricao'] 		:= aOrigem[nODESCRI]
	aaBuonny[#'origem'][#'logradouro'] 		:= aOrigem[nOLOGRAD]
	aaBuonny[#'origem'][#'numero'] 			:= aOrigem[nONUMERO]
	aaBuonny[#'origem'][#'complemento'] 	:= aOrigem[nOCOMPLE]
	aaBuonny[#'origem'][#'bairro'] 			:= aOrigem[nOBAIRRO]
	aaBuonny[#'origem'][#'cep'] 			:= aOrigem[nOCEP]
	aaBuonny[#'origem'][#'cidade'] 			:= aOrigem[nOCIDADE]
	aaBuonny[#'origem'][#'estado'] 			:= aOrigem[nOESTADO]
	aaBuonny[#'origem'][#'latitude'] 		:= aOrigem[nOLATITU]
	aaBuonny[#'origem'][#'longitude'] 		:= aOrigem[nOLONGIT]
	aaBuonny[#'origem'][#'bandeira'] 		:= aOrigem[nOBANDEI]
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Continuação - Dados da viagem                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMonite
		aaBuonny[#'monitorar_retorno'] 	:= 1
	Else
		aaBuonny[#'monitorar_retorno'] 	:= 0
	EndIf
	aaBuonny[#'data_previsao_inicio']	:= Transform(GravaData(DTR->DTR_DATINI, .F., 5) + " " + DTR->DTR_HORINI+"00", "@R 99\/99/\9999 99:99:99")
	aaBuonny[#'data_previsao_fim'] 		:= Transform(GravaData(DTR->DTR_DATFIM, .F., 5) + " " + DTR->DTR_HORFIM+"00", "@R 99\/99/\9999 99:99:99")
	aaBuonny[#'itinerario'] 				:= Array(#)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Dados dos documentos da viagem.                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	aDocs := fGetDocs ()
	If Len(aDocs) == 0
		U_RGEFM03A(DTQ->DTQ_FILORI, DTQ->DTQ_VIAGEM, "Não foram encontrados documentos na viagem.")
		Help (" ", 1, "RGEFM0305",,"Não foram encontrados documentos na viagem.", 3, 0)
	Else
		For nDoc := 1 to Len(aDocs)
			aaAlvo := Array (#)
			aaAlvo[#'codigo_externo'] 		:= aDocs[nDoc, nDCODEXT]
			aaAlvo[#'descricao'] 			:= aDocs[nDoc, nDDESCRI]
			aaAlvo[#'logradouro'] 			:= aDocs[nDoc, nDLOGRAD]
			aaAlvo[#'numero'] 				:= aDocs[nDoc, nDNUMERO]
			aaAlvo[#'complemento'] 			:= aDocs[nDoc, nDCOMPLE]
			aaAlvo[#'bairro'] 				:= aDocs[nDoc, nDBAIRRO]
			aaAlvo[#'cep'] 					:= aDocs[nDoc, nDCEP]
			aaAlvo[#'cidade'] 				:= aDocs[nDoc, nDCIDADE]
			aaAlvo[#'estado'] 				:= aDocs[nDoc, nDESTADO]
			aaAlvo[#'latitude'] 				:= aDocs[nDoc, nDLATITU]
			aaAlvo[#'longitude'] 			:= aDocs[nDoc, nDLONGIT]
			aaAlvo[#'bandeira'] 				:= aDocs[nDoc, nDBANDEI]
			aaAlvo[#'tipo_parada'] 			:= aDocs[nDoc, nDTIPPAR]
			aaAlvo[#'janela_inicio'] 		:= aDocs[nDoc, nDHORINI]
			aaAlvo[#'janela_fim' ] 			:= aDocs[nDoc, nDHORFIM]
			aaAlvo[#'previsao_de_chegada']	:= aDocs[nDoc, nDPRVCHG]
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Dados das notas fiscais dos documentos.                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
			For nNota := 1 to Len(aDocs[nDoc, nDNOTAS])
				aaCarga := Array(#)
				aaCarga[#'loadplan_chassi']	:= aDocs[nDoc, nDNOTAS, nNota, nNCHASSI]
				aaCarga[#'nf'] 				:= aDocs[nDoc, nDNOTAS, nNota, nNNUMNFC]
				aaCarga[#'serie_nf'] 		:= aDocs[nDoc, nDNOTAS, nNota, nNSERNFC]
				aaCarga[#'tipo_produto'] 	:= aDocs[nDoc, nDNOTAS, nNota, nNPRODUT]
				aaCarga[#'valor_total_nf']	:= aDocs[nDoc, nDNOTAS, nNota, nNVALOR]
				aaCarga[#'volume' ] 			:= aDocs[nDoc, nDNOTAS, nNota, nNVOLUME]
				aaCarga[#'peso'] 				:= aDocs[nDoc, nDNOTAS, nNota, nNPESO]
				aAdd(aDadosCarga, aaCarga)
			Next nNota
			aaAlvo[#'dados_da_carga'] := Array(#)
			aaAlvo[#'dados_da_carga'][#'carga'] := aDadosCarga
			aAdd(aAlvos, aaAlvo)
			aDadosCarga := {}
		Next nDoc
		aaBuonny[#'itinerario'][#'alvo'] := aAlvos
		
		cJson := ToJson(aaBuonny)
		cJson := StrTran(cJson, "\\","")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Salva JSon enviado para analise.                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
		MemoWrite(cDirBkp + cArqEnvio, JsonPrettify(cJson, 4))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Envia dados para a Buonny.                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
		If fSendData(cUrl, cJson, @cRetorno)
			lRet := .T.
			MemoWrite(cDirBkp + cArqRetorno, cRetorno)
			aaRetorno := ReadJsonFile(cDirBkp + cArqRetorno)
			
			If ValType(aaRetorno) == "O"
				nNumSol	:= aaRetorno[#'sucesso']
				aErros 	:= aaRetorno[#'erros']
			EndIf
			
			If !Empty(nNumSol)
				RecLock("DTQ", .F.)
					DTQ->DTQ_XSMBNY := cValToChar(nNumSol)
				DTQ->(MsUnlock())
				cMsgAvi := "Inclusao de SM " + AllTrim(DTQ->DTQ_XSMBNY) + "."
				U_RGEFM03A(DTQ->DTQ_FILORI, DTQ->DTQ_VIAGEM, cMsgAvi)
			Else
				cMsgAvi := "Mensagem da Buonny:" + CRLF
				For nErro := 1 to Len(aErros)
					cMsgAvi += aErros[nErro] + CRLF 
				Next
				
				U_RGEFM03A(DTQ->DTQ_FILORI, DTQ->DTQ_VIAGEM, cMsgAvi, "Erros durante tentativa de inclusao de SM.")
				lErro := .T.
			EndIf
		Else
			cMsgAvi := "Ocorreu um erro durante a tentativa de integracao:" + CRLF
			cMsgAvi += cRetorno
			U_RGEFM03A(DTQ->DTQ_FILORI, DTQ->DTQ_VIAGEM, cMsgAvi, "Problemas na chamada do WS.")
			lErro := .T.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Limpa numero da solicitação em caso de erro.                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ								
		If lErro
			RecLock("DTQ", .F.)
				DTQ->DTQ_XSMBNY := ""
			DTQ->(MsUnlock())
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Exibe mensagem de retorno para o usuário.                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
		If !Empty(cMsgAvi)
			Aviso("Solic.Monit.", cMsgAvi,{"Ok"},3,"Retorno da Buonny")
			If lShowMsg .And. lErro
				If (lRet := MsgBox("Autoriza fechamento da viagem não liberada pela Buonny?", "Confirmação", "YESNO"))
					U_RGEFM03A(DTQ->DTQ_FILORI, DTQ->DTQ_VIAGEM, "Fechamento da viagem nao liberado pela Buonny autorizado por " + AllTrim(cUserName) + ".")
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

Return lRet 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSendData ºAutor  ³ Vinícius Moreira   º Data ³ 16/09/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Conecta ao WS Buonny.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fSendData(cUrl, cParams, cRetorno)

Local lRet     := .T.
Local nTimeOut := 120 
Local aHeadOut := {}
Local cHeadRet := ""

aAdd(aHeadOut,'Content-Type: application/json')
cRetorno := HttpPost(cUrl,"",cParams,nTimeOut,aHeadOut,@cHeadRet)

If Empty(cRetorno)
	cRetorno := cHeadRet
	lRet := .F.
EndIf

U_RGEFM03A(DTQ->DTQ_FILORI, DTQ->DTQ_VIAGEM, cRetorno, "Conexão com o servidor.")

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCGCClientºAutor  ³ Vinícius Moreira   º Data ³ 22/09/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca CNPJ do cliente Gefco cadastrado na Buonny.          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCGCClient()

Local cRet := SuperGetMv("ES_GEFM03G",,"")

If Left(cRet, 1) == "#"
	MacExec(SubStr(cRet, 2), @cRet)
EndIf

Return cRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCGCTranspºAutor  ³ Vinícius Moreira   º Data ³ 16/09/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca CGC do transportador.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCGCTransp ()

Local cRet := ""

dbSelectArea("SA2") //Cadastro de Veículos
If SA2->(dbSeek(xFilial("SA2")+DA3->(DA3_CODFOR+DA3_LOJFOR)))
	cRet := SA2->A2_CGC
EndIf

Return cRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCGCGRiscoºAutor  ³ Vinícius Moreira   º Data ³ 16/09/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca CGC da gerenciadora de risco.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCGCGRisco()

Local cRet := SuperGetMv("ES_GEFM03E",,"")

If Left(cRet, 1) == "#"
	MacExec(SubStr(cRet, 2), @cRet)
EndIf

Return cRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGetOBS   ºAutor  ³ Vinícius Moreira   º Data ³ 16/09/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca observação para envio a Buonny.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGetOBS ()

Local cRet := SuperGetMv("ES_GEFM03D",,"Definir onde observacao sera informada.")

If Left(cRet, 1) == "#"
	MacExec(SubStr(cRet, 2), @cRet)
EndIf

Return cRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGetPlacasºAutor  ³ Vinícius Moreira   º Data ³ 16/09/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca placas relacionadas a viagem.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGetPlacas()

Local aAreaDA3 := DA3->(GetArea())
Local aRet := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Placa do reboque.                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aRet, Transform(DA3->DA3_PLACA, "@R XXX-9999"))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Placa do semi reboque 1.                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(DTR->DTR_CODRB1) .And. DA3->(dbSeek(xFilial("DA3")+DTR->DTR_CODRB1))
	aAdd(aRet, Transform(DA3->DA3_PLACA, "@R XXX-9999"))
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Placa do semi reboque 2.                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(DTR->DTR_CODRB2) .And. DA3->(dbSeek(xFilial("DA3")+DTR->DTR_CODRB2))
	aAdd(aRet, Transform(DA3->DA3_PLACA, "@R XXX-9999"))
EndIf

RestArea(aAreaDA3)

Return aRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGetOrigemºAutor  ³ Vinícius Moreira   º Data ³ 17/09/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca origem das viagens.                                  º±±
±±º          ³ Se coleta, busca origem do primeiro documento.             º±±
±±º          ³ Se entrega, busca origem da filial.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGetOrigem()

Local aArea 	:= GetArea()
Local aAreaSM0 	:= SM0->(GetArea())
Local aRet 		:= {}
Local aEndereco := {}
Local cQuery    := ""
Local cAliasQry := ""
Local cSeq      := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alterado - Vinícius Moreira - 02/09/2014                                        ³
//³Antes a origem da viagem de coleta era o endereço da primeira coleta da viagem. ³
//³Em reunião com o Reginaldo Brum e Jorge, ficou acordado que a origem da coleta  ³
//³passaria a ser a filial que digitou a coleta.                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Origem da coleta.                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If DTQ->DTQ_SERTMS == "1"
	cAliasQry := GetNextAlias()
	cQuery += " SELECT MIN(DUD.DUD_SEQUEN) MINSEQ " + CRLF
	cQuery += "   FROM "+ RetSqlName("DUD") + " DUD " + CRLF
	cQuery += "  WHERE DUD.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "    AND DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF
	cQuery += "    AND DUD.DUD_FILORI = '" + DTQ->DTQ_FILORI + "' " + CRLF
	cQuery += "    AND DUD.DUD_VIAGEM = '" + DTQ->DTQ_VIAGEM + "' " + CRLF
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .T.)
	cSeq := AllTrim((cAliasQry)->MINSEQ)
	(cAliasQry)->(dbCloseArea())
	
	cQuery := " SELECT " + CRLF
	cQuery += "    SA1.A1_CGC CODIGO " + CRLF
	cQuery += "   ,SA1.A1_NOME DESCRICAO " + CRLF
	cQuery += "   ,SA1.A1_END LOGRADOURO " + CRLF
	cQuery += "   ,SA1.A1_COMPLEM COMPLEMENTO " + CRLF
	cQuery += "   ,SA1.A1_BAIRRO BAIRRO " + CRLF
	cQuery += "   ,SA1.A1_CEP CEP " + CRLF
	cQuery += "   ,SA1.A1_MUN CIDADE " + CRLF
	cQuery += "   ,SA1.A1_EST ESTADO " + CRLF
	cQuery += "  FROM " + RetSqlName("DUD") + " DUD " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DT5") + " DT5 ON " + CRLF
	cQuery += "       DT5.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "   AND DT5.DT5_FILIAL = DUD.DUD_FILDOC " + CRLF
	cQuery += "   AND DT5.DT5_FILDOC = DUD.DUD_FILDOC " + CRLF
	cQuery += "   AND DT5.DT5_DOC    = DUD.DUD_DOC " + CRLF
	cQuery += "   AND DT5.DT5_SERIE  = DUD.DUD_SERIE " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DUE") + " DUE ON " + CRLF
	cQuery += "       DUE.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "   AND DUE.DUE_FILIAL = '" + xFilial("DUE") + "' " + CRLF
	cQuery += "   AND DUE.DUE_DDD    = DT5.DT5_DDD " + CRLF
	cQuery += "   AND DUE.DUE_TEL    = DT5.DT5_TEL " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON " + CRLF
	cQuery += "       SA1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "   AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "' " + CRLF
	cQuery += "   AND SA1.A1_COD     = DUE.DUE_CODCLI " + CRLF
	cQuery += "   AND SA1.A1_LOJA    = DUE.DUE_LOJCLI " + CRLF
	cQuery += " WHERE DUD.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "   AND DUD.DUD_FILIAL = '" + xFilial("DUD")  + "' " + CRLF
	cQuery += "   AND DUD.DUD_FILORI = '" + DTQ->DTQ_FILORI + "' " + CRLF
	cQuery += "   AND DUD.DUD_VIAGEM = '" + DTQ->DTQ_VIAGEM + "' " + CRLF
	cQuery += "   AND DUD.DUD_SEQUEN = '" + cSeq + "' " + CRLF
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .T.)
	
	If (cAliasQry)->(!Eof())
		aEndereco := Separa((cAliasQry)->LOGRADOURO, ",")
		If Len(aEndereco) <= 1
			aAdd(aEndereco, "1")
		EndIf
		
		aRet := {	(cAliasQry)->CODIGO,;					//01 - Codigo Externo
					AllTrim((cAliasQry)->DESCRICAO),;		//02 - Descrição
					AllTrim(aEndereco[1]),;					//03 - Logradouro
					AllTrim(aEndereco[2]),;					//04 - Numero
					AllTrim((cAliasQry)->COMPLEMENTO),;	//05 - Complemento
					AllTrim((cAliasQry)->BAIRRO	),;			//06 - Bairro
					AllTrim((cAliasQry)->CEP),;			//07 - Cep
					AllTrim((cAliasQry)->CIDADE),;  		//08 - Cidade
					AllTrim((cAliasQry)->ESTADO),;			//09 - Estado
					,;										//10 - Latitude
					,;								   		//11 - Longitude
					"";//AllTrim((cAliasQry)->DESCRICAO);   		//12 - Bandeira
			}
	EndIf
	(cAliasQry)->(dbCloseArea())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Origem da entrega\transferência.                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
Else
	SM0->(dbSeek( cEmpAnt + DTQ->DTQ_FILORI ))
	aEndereco := Separa(SM0->M0_ENDENT, ",")
	If Len(aEndereco) <= 1
		aAdd(aEndereco, "1")
	EndIf
	
	aRet := {	DTQ->DTQ_FILORI,;			//01 - Codigo Externo
				AllTrim(SM0->M0_FILIAL),;	//02 - Descrição
				AllTrim(aEndereco[1]),;		//03 - Logradouro
				AllTrim(aEndereco[2]),;		//04 - Numero
				AllTrim(SM0->M0_COMPENT),;	//05 - Complemento
				AllTrim(SM0->M0_BAIRENT),;	//06 - Bairro
				AllTrim(SM0->M0_CEPENT),;	//07 - Cep
				AllTrim(SM0->M0_CIDENT),;	//08 - Cidade
				AllTrim(SM0->M0_ESTENT),;	//09 - Estado
				,;							//10 - Latitude
				,;							//11 - Longitude
				"";//AllTrim(SM0->M0_NOME);		//12 - Bandeira
		}
EndIf
*/
SM0->(dbSeek( cEmpAnt + DTQ->DTQ_FILORI ))
aEndereco := Separa(SM0->M0_ENDENT, ",")
If Len(aEndereco) <= 1
	aAdd(aEndereco, "1")
EndIf

aRet := {	DTQ->DTQ_FILORI,;			//01 - Codigo Externo
			AllTrim(SM0->M0_FILIAL),;	//02 - Descrição
			AllTrim(aEndereco[1]),;		//03 - Logradouro
			AllTrim(aEndereco[2]),;		//04 - Numero
			AllTrim(SM0->M0_COMPENT),;	//05 - Complemento
			AllTrim(SM0->M0_BAIRENT),;	//06 - Bairro
			AllTrim(SM0->M0_CEPENT),;	//07 - Cep
			AllTrim(SM0->M0_CIDENT),;	//08 - Cidade
			AllTrim(SM0->M0_ESTENT),;	//09 - Estado
			,;							//10 - Latitude
			,;							//11 - Longitude
			"";//AllTrim(SM0->M0_NOME);		//12 - Bandeira
}

RestArea(aAreaSM0)
RestArea(aArea)

Return aRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fGetDocs ºAutor  ³ Vinícius Moreira   º Data ³ 19/09/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca documentos da viagem.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGetDocs ()

Local aDocs		:= {}
Local aNotas	:= {}
Local cDocAtu   := ""
Local cCgcAtu   := ""
Local cQuery 	:= ""
Local cAliasQry	:= GetNextAlias()
Local aEndereco := {}
Local dDatIni   := cToD("\\")
Local cHorIni   := ""
Local dDatFim   := cToD("\\")
Local cHorFim   := ""
Local nHorAux   := 0
Local cIniJan   := ""
Local cFimJan   := ""
Local nTmpCole  := Val(StrTran(SuperGetMv("ES_CNHINVG",,"02:00"), ":","."))
Local nTmpTran  := Val(StrTran(SuperGetMv("ES_CNHFRQ" ,,"01:00"), ":","."))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Documentos da coleta.                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If DTQ->DTQ_SERTMS == "1"
	cQuery := " SELECT " + CRLF 
	cQuery += "    MAX ( DUD.DUD_FILDOC || DUD.DUD_DOC || DUD.DUD_SERIE ) NUMDOC " + CRLF 
	cQuery += "   ,SA1.A1_CGC     CGC " + CRLF 
	cQuery += "   ,SA1.A1_NOME    NOME " + CRLF 
	cQuery += "   ,SA1.A1_END     ENDERECO " + CRLF 
	cQuery += "   ,SA1.A1_COMPLEM COMPLEMENTO " + CRLF 
	cQuery += "   ,SA1.A1_BAIRRO  BAIRRO " + CRLF 
	cQuery += "   ,SA1.A1_CEP     CEP " + CRLF 
	cQuery += "   ,SA1.A1_MUN     CIDADE " + CRLF 
	cQuery += "   ,SA1.A1_EST     ESTADO " + CRLF 
	cQuery += "   ,DF1.DF1_DATPRC DATPRC " + CRLF 
	cQuery += "   ,DF1.DF1_HORPRC HORPRC " + CRLF 
	cQuery += "   ,DF1.DF1_XDTPSC XDTPSC " + CRLF 
	cQuery += "   ,DF1.DF1_XHRPSC XHRPSC" + CRLF 
	cQuery += "   ,DF1.DF1_DATPRE DATPRE" + CRLF 
	cQuery += "   ,DF1.DF1_HORPRE HORPRE" + CRLF 
	cQuery += "   ,DF1.DF1_XDTPEN XDTPEN" + CRLF 
	cQuery += "   ,DF1.DF1_XHRPEN XHRPEN" + CRLF 
	// Por: Ricardo Guimarães - Em: 04/08/2015 - Objetivo: Tratar os registros que não fazem agendamento(DF1 - CNH)
	// 								 Quando existir agendamento pegar da tabela DF1, caso contrário DT5	
	cQuery += "   ,DT5.DT5_DATPRV DATPRV" + CRLF 
	cQuery += "   ,DT5.DT5_HORPRV HORPRV" + CRLF 
	cQuery += "   ,DT5.DT5_DATENT DATENT" + CRLF 
	cQuery += "   ,DT5.DT5_HORENT HORENT" + CRLF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Movimento de viagens                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery += "  FROM " + RetSqlName("DUD") + " DUD " + CRLF 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Solicitações de coleta                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery += " INNER JOIN " + RetSqlName("DT5") + " DT5 ON " + CRLF 
	cQuery += "       DT5.DT5_FILIAL = DUD.DUD_FILDOC " + CRLF 
	cQuery += "   AND DT5.DT5_FILDOC = DUD.DUD_FILDOC " + CRLF 
	cQuery += "   AND DT5.DT5_DOC    = DUD.DUD_DOC " + CRLF 
	cQuery += "   AND DT5.DT5_SERIE  = DUD.DUD_SERIE " + CRLF 
	cQuery += "   AND DT5.D_E_L_E_T_ = ' ' " + CRLF 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Itens dos Agendamentos                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	cQuery += " LEFT OUTER JOIN " + RetSqlName("DF1") + " DF1 ON " + CRLF 
	cQuery += "       DF1.DF1_FILIAL = '" + xFilial("DF1") + "' " + CRLF 
	cQuery += "   AND DF1.DF1_FILDOC = DUD.DUD_FILDOC " + CRLF 
	cQuery += "   AND DF1.DF1_DOC    = DUD.DUD_DOC " + CRLF 
	cQuery += "   AND DF1.DF1_SERIE  = DUD.DUD_SERIE " + CRLF 
	cQuery += "   AND DF1.D_E_L_E_T_ = ' ' " + CRLF 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Solicitantes                                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery += " INNER JOIN " + RetSqlName("DUE") + " DUE ON " + CRLF
	cQuery += "       DUE.DUE_FILIAL = '" + xFilial("DUE") + "' " + CRLF
	cQuery += "   AND DUE.DUE_DDD    = DT5.DT5_DDD " + CRLF
	cQuery += "   AND DUE.DUE_TEL    = DT5.DT5_TEL " + CRLF
	cQuery += "   AND DUE.D_E_L_E_T_ = ' ' " + CRLF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Clientes                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON " + CRLF
	cQuery += "       SA1.A1_FILIAL  = '" + xFilial("SA1") + "' " + CRLF
	cQuery += "   AND SA1.A1_COD     = DUE.DUE_CODCLI " + CRLF
	cQuery += "   AND SA1.A1_LOJA    = DUE.DUE_LOJCLI " + CRLF
	cQuery += "   AND SA1.D_E_L_E_T_ = ' ' " + CRLF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Movimento de viagens - Filtro dos registros                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery += " WHERE DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF 
	cQuery += "   AND DUD.DUD_FILORI = '" + DTQ->DTQ_FILORI + "' " + CRLF 
	cQuery += "   AND DUD.DUD_VIAGEM = '" + DTQ->DTQ_VIAGEM + "' " + CRLF 
	cQuery += "   AND DUD.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " GROUP BY " + CRLF 
	cQuery += "    SA1.A1_CGC     " + CRLF 
	cQuery += "   ,SA1.A1_NOME    " + CRLF 
	cQuery += "   ,SA1.A1_END     " + CRLF 
	cQuery += "   ,SA1.A1_COMPLEM " + CRLF 
	cQuery += "   ,SA1.A1_BAIRRO  " + CRLF 
	cQuery += "   ,SA1.A1_CEP     " + CRLF 
	cQuery += "   ,SA1.A1_MUN     " + CRLF 
	cQuery += "   ,SA1.A1_EST     " + CRLF 
	cQuery += "   ,DF1.DF1_DATPRC " + CRLF 
	cQuery += "   ,DF1.DF1_HORPRC " + CRLF 
	cQuery += "   ,DF1.DF1_XDTPSC " + CRLF 
	cQuery += "   ,DF1.DF1_XHRPSC " + CRLF 
	cQuery += "   ,DF1.DF1_DATPRE " + CRLF 
	cQuery += "   ,DF1.DF1_HORPRE " + CRLF 
	cQuery += "   ,DF1.DF1_XDTPEN " + CRLF 
	cQuery += "   ,DF1.DF1_XHRPEN " + CRLF 
	cQuery += "   ,DT5.DT5_DATPRV " + CRLF 
	cQuery += "   ,DT5.DT5_HORPRV " + CRLF       
	cQuery += "   ,DT5.DT5_DATENT " + CRLF 
	cQuery += "   ,DT5.DT5_HORENT " + CRLF	
	cQuery += " ORDER BY " + CRLF 
//	cQuery += "    DF1.DF1_DATPRC " + CRLF 
//	cQuery += "   ,DF1.DF1_HORPRC " + CRLF 
	cQuery += "    DT5.DT5_DATPRV " + CRLF 
	cQuery += "   ,DT5.DT5_HORPRV " + CRLF	
	cQuery += "   ,SA1.A1_CGC " + CRLF 	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .T.)
	If (cAliasQry)->(!Eof())
		TcSetField(cAliasQry,"XDTPSC",TamSx3("DF1_XDTPSC")[3],TamSx3("DF1_XDTPSC")[1],TamSx3("DF1_XDTPSC")[2])
		TcSetField(cAliasQry,"DATPRE",TamSx3("DF1_DATPRE")[3],TamSx3("DF1_DATPRE")[1],TamSx3("DF1_DATPRE")[2])
		TcSetField(cAliasQry,"XDTPEN",TamSx3("DF1_XDTPEN")[3],TamSx3("DF1_XDTPEN")[1],TamSx3("DF1_XDTPEN")[2])
		TcSetField(cAliasQry,"DATPRC",TamSx3("DF1_DATPRC")[3],TamSx3("DF1_DATPRC")[1],TamSx3("DF1_DATPRC")[2])
		TcSetField(cAliasQry,"DATPRV",TamSx3("DT5_DATPRV")[3],TamSx3("DT5_DATPRV")[1],TamSx3("DT5_DATPRV")[2])
		TcSetField(cAliasQry,"DATENT",TamSx3("DT5_DATENT")[3],TamSx3("DT5_DATENT")[1],TamSx3("DT5_DATENT")[2])
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ajustando previsão de inicio de viagem, conforme coletas.                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		// Por: Ricardo Guimarães - Em: 04/08/2015 - Objetivo: Tratar os registros que não fazem agendamento(DF1 - CNH)
		// 								 Quando existir agendamento pegar da tabela DF1, caso contrário DT5
		//dDatIni := (cAliasQry)->DATPRC
		//cHorIni := (cAliasQry)->HORPRC
		dDatIni := IIF(Empty((cAliasQry)->DATPRC),(cAliasQry)->DATPRV,(cAliasQry)->DATPRC)
		cHorIni := IIF(Empty((cAliasQry)->HORPRC),(cAliasQry)->HORPRV,(cAliasQry)->HORPRC)
		
		nHorAux := Val(Left(cHorIni, 2)+"."+Right(cHorIni,2))
		nHorAux := SubHoras(nHorAux, nTmpCole)
		If nHorAux < 0
			dDatIni -= 1
			cHorIni := StrZero(SubHoras(24, nHorAux*-1)*100, 4)
		EndIf
		
		aaBuonny[#'data_previsao_inicio']	:= Transform(GravaData(dDatIni, .F., 5) + " " + cHorIni+"00", "@R 99\/99/\9999 99:99:99")
		RecLock("DTR", .F.)
			DTR->DTR_DATINI := dDatIni
			DTR->DTR_HORINI := cHorIni
		DTR->(MsUnLock())
		While (cAliasQry)->(!Eof())
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona coleta.                                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DT5->(dbSeek(xFilial("DT5")+(cAliasQry)->NUMDOC))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Hora de inicio e fim de janela.                                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			cIniJan := (cAliasQry)->HORPRC
			cFimJan := (cAliasQry)->HORPRC
			nHorAux := Val(Left(cFimJan, 2) + "." + Right(cFimJan, 2))
			nHorAux := SomaHoras(nHorAux, nTmpTran)
			If nHorAux > 24
				nHorAux := SubHoras(nHorAux, 24)
				cFimJan := StrZero(nHorAux*100, 4)
			EndIf
			
			aEndereco := Separa((cAliasQry)->ENDERECO, ",")
			If Len(aEndereco) <= 1
				aAdd(aEndereco, "1")
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Guarda informações da coleta.                                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aDocs,{	(cAliasQry)->CGC,;					//01 - Codigo Externo
							AllTrim((cAliasQry)->NOME),;		//02 - Descricao
							AllTrim(aEndereco[1]),;				//03 - Logradouro
							AllTrim(aEndereco[2]),;				//04 - Numero 
							AllTrim((cAliasQry)->COMPLEMENTO),;//05 - Complemento 
							AllTrim((cAliasQry)->BAIRRO),;		//06 - Bairro
							(cAliasQry)->CEP,;					//07 - Cep 
							AllTrim((cAliasQry)->CIDADE),;		//08 - Cidade 
							(cAliasQry)->ESTADO,;				//09 - Estado 
							Nil,;									//10 - Latitude
							Nil,;									//11 - Longitude
							"",;//AllTrim((cAliasQry)->NOME),;		//12 - Bandeira
							2,;										//13 - Tipo de Parada
							cIniJan,;								//14 - Janela Inicio
							cFimJan,;								//15 - Janela Fim 
							Transform(GravaData(IIF(Empty((cAliasQry)->DATPRC),(cAliasQry)->DATPRV,(cAliasQry)->DATPRC), .F., 5) + " " + cIniJan+"00", "@R 99\/99/\9999 99:99:99"),;	//16 - Previsao de Chegada
							{}})									//17 - Vetor de Notas Fiscais
							
			// Por: Ricardo - Em: 05/08/2015
			// dDatFim := (cAliasQry)->DATPRE
			// cHorFim := (cAliasQry)->HORPRE
			dDatFim := IIF(Empty((cAliasQry)->DATPRE),(cAliasQry)->DATENT,(cAliasQry)->DATPRE)
			cHorFim := IIF(Empty((cAliasQry)->HORPRE),(cAliasQry)->HORENT,(cAliasQry)->HORPRE)
			(cAliasQry)->(dbSkip())
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ajustando previsão de inicio de viagem, conforme coletas.                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aaBuonny[#'data_previsao_fim']	:= Transform(GravaData(dDatFim, .F., 5) + " " + cHorFim+"00", "@R 99\/99/\9999 99:99:99")
		RecLock("DTR", .F.)
			DTR->DTR_DATFIM := dDatFim
			DTR->DTR_HORFIM := cHorFim
		DTR->(MsUnLock())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Carregando informação do destinatario.                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(DT5->DT5_CLIDES)
			SA1->(dbSeek(xFilial("SA1")+DT5->DT5_CLIDES+DT5->DT5_LOJDES))
			
			aEndereco := Separa(SA1->A1_END, ",")
			If Len(aEndereco) <= 1
				aAdd(aEndereco, "1")
			EndIf
			aAdd(aDocs,{	SA1->A1_CGC,;					//01 - Codigo Externo
							AllTrim(SA1->A1_NOME),;		//02 - Descricao
							AllTrim(aEndereco[1]),;		//03 - Logradouro
							AllTrim(aEndereco[2]),;		//04 - Numero 
							AllTrim(SA1->A1_COMPLEM),;	//05 - Complemento 
							AllTrim(SA1->A1_BAIRRO),;	//06 - Bairro
							SA1->A1_CEP,;					//07 - Cep 
							AllTrim(SA1->A1_MUN),;		//08 - Cidade 
							SA1->A1_EST,;					//09 - Estado 
							Nil,;							//10 - Latitude
							Nil,;							//11 - Longitude
							"",;//AllTrim(SA1->A1_NOME),;			//12 - Bandeira
							2,;								//13 - Tipo de Parada
							DT5->DT5_HORPRV,;				//14 - Janela Inicio
							DT5->DT5_HORPRV,;				//15 - Janela Fim 
							Transform(GravaData(dDatFim, .F., 5) + " " + cHorFim+"00", "@R 99\/99/\9999 99:99:99"),;//Transform(GravaData(Date()+2, .F., 5) + " " + DT5->DT5_HORPRV+"00", "@R 99\/99/\9999 99:99:99"),;	//16 - Previsao de Chegada
							{}})							//17 - Vetor de Notas Fiscais
		EndIf
	EndIf
	(cAliasQry)->(dbCloseArea())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Documentos da entrega\transferência.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Else
	cQuery := " SELECT " + CRLF 
	cQuery += "    DUD.DUD_FILDOC FILDOC " + CRLF 
	cQuery += "   ,DUD.DUD_DOC    DOC " + CRLF 
	cQuery += "   ,DUD.DUD_SERIE  SERIE " + CRLF 
	cQuery += "   ,DT6.DT6_FILDCO FILDCO " + CRLF 
	cQuery += "   ,DT6.DT6_DOCDCO DOCDCO " + CRLF 
	cQuery += "   ,DT6.DT6_SERDCO SERDCO " + CRLF 
	cQuery += "   ,SA1.A1_CGC     CGC " + CRLF 
	cQuery += "   ,SA1.A1_NOME    NOME " + CRLF 
	cQuery += "   ,SA1.A1_END     ENDERECO " + CRLF 
	cQuery += "   ,SA1.A1_COMPLEM COMPLEMENTO " + CRLF 
	cQuery += "   ,SA1.A1_BAIRRO  BAIRRO " + CRLF 
	cQuery += "   ,SA1.A1_CEP     CEP " + CRLF 
	cQuery += "   ,SA1.A1_MUN     CIDADE " + CRLF 
	cQuery += "   ,SA1.A1_EST     ESTADO " + CRLF 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Movimento de viagens                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery += "  FROM " + RetSqlName("DUD") + " DUD " + CRLF 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Documentos de transporte                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 ON " + CRLF 
	cQuery += "       DT6.DT6_FILIAL = '" + xFilial("DT6") + "' " + CRLF 
	cQuery += "   AND DT6.DT6_FILDOC = DUD.DUD_FILDOC " + CRLF 
	cQuery += "   AND DT6.DT6_DOC    = DUD.DUD_DOC " + CRLF 
	cQuery += "   AND DT6.DT6_SERIE  = DUD.DUD_SERIE " + CRLF 
	cQuery += "   AND DT6.D_E_L_E_T_ = ' ' " + CRLF 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Clientes                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON " + CRLF
	cQuery += "       SA1.A1_FILIAL  = '" + xFilial("SA1") + "' " + CRLF
	cQuery += "   AND SA1.A1_COD     = DT6.DT6_CLIDES " + CRLF
	cQuery += "   AND SA1.A1_LOJA    = DT6.DT6_LOJDES " + CRLF
	cQuery += "   AND SA1.D_E_L_E_T_ = ' ' " + CRLF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Movimento de viagens - Filtro dos registros                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery += " WHERE DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF 
	cQuery += "   AND DUD.DUD_FILORI = '" + DTQ->DTQ_FILORI + "' " + CRLF 
	cQuery += "   AND DUD.DUD_VIAGEM = '" + DTQ->DTQ_VIAGEM + "' " + CRLF 
	cQuery += "   AND DUD.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " GROUP BY " + CRLF 
	cQuery += "    DUD.DUD_FILDOC " + CRLF 
	cQuery += "   ,DUD.DUD_DOC    " + CRLF 
	cQuery += "   ,DUD.DUD_SERIE  " + CRLF 
	cQuery += "   ,DT6.DT6_FILDCO " + CRLF 
	cQuery += "   ,DT6.DT6_DOCDCO " + CRLF 
	cQuery += "   ,DT6.DT6_SERDCO " + CRLF 
	cQuery += "   ,SA1.A1_CGC     " + CRLF 
	cQuery += "   ,SA1.A1_NOME    " + CRLF 
	cQuery += "   ,SA1.A1_END     " + CRLF 
	cQuery += "   ,SA1.A1_COMPLEM " + CRLF 
	cQuery += "   ,SA1.A1_BAIRRO  " + CRLF 
	cQuery += "   ,SA1.A1_CEP     " + CRLF 
	cQuery += "   ,SA1.A1_MUN     " + CRLF 
	cQuery += "   ,SA1.A1_EST     " + CRLF 
	cQuery += " ORDER BY " + CRLF 
	cQuery += "    SA1.A1_COD " + CRLF 
	cQuery += "   ,SA1.A1_LOJA " + CRLF 
	cQuery += "   ,DT6.DT6_FILDOC " + CRLF 
	cQuery += "   ,DT6.DT6_DOC " + CRLF 
	cQuery += "   ,DT6.DT6_SERIE " + CRLF 
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .T.)
	While (cAliasQry)->(!Eof())	
		aEndereco := Separa((cAliasQry)->ENDERECO, ",")
		If Len(aEndereco) <= 1
			aAdd(aEndereco, "1")
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Checa se a documento original.                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty((cAliasQry)->(FILDCO+DOCDCO+SERDCO))
			cDocAtu := (cAliasQry)->(FILDCO+DOCDCO+SERDCO)
		Else
			cDocAtu := (cAliasQry)->(FILDOC+DOC+SERIE)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca notas fiscais.                                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If DTC->(dbSeek(xFilial("DTC")+cDocAtu))
			While DTC->(DTC_FILDOC+DTC_DOC+DTC_SERIE) == cDocAtu
				aAdd(aNotas,{	Nil,;				//01 - Loadplan Chassi
								DTC->DTC_NUMNFC,;	//02 - Numero da Nota Fiscal
								DTC->DTC_SERNFC,;	//03 - Serie da Nota Fiscal
								"231",;				//04 - Tipo de Produto
								DTC->DTC_VALOR,;	//05 - Valor da Nota Fiscal
								DTC->DTC_QTDVOL,;	//06 - Quantidade de Volumes da Nota Fiscal
								DTC->DTC_PESO})		//07 - Peso da Nota Fiscal
				DTC->(dbSkip())
			EndDo
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Guarda informações do documento.                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		//aAdd(aDocs,{	cDocAtu,;								//01 - Codigo Externo
		aAdd(aDocs,{	(cAliasQry)->CGC,;						//01 - Codigo Externo
						AllTrim((cAliasQry)->NOME),;			//02 - Descricao 
						AllTrim(aEndereco[1]),;					//03 - Logradouro
						AllTrim(aEndereco[2]),;					//04 - Numero
						AllTrim((cAliasQry)->COMPLEMENTO),;	//05 - Complemento 
						AllTrim((cAliasQry)->BAIRRO),;			//06 - Bairro
						(cAliasQry)->CEP,;						//07 - Cep
						AllTrim((cAliasQry)->CIDADE),;			//08 - Cidade 
						(cAliasQry)->ESTADO,;					//09 - Estado
						Nil,;									//10 - Latitude
						Nil,;									//11 - Longitude
						"",;//cDocAtu,;								//12 - Bandeira
						3,;										//13 - Tipo de Parada
						DTR->DTR_HORINI,;						//14 - Janela Inicio
						DTR->DTR_HORFIM,;						//15 - Janela Fim
						Transform(GravaData(Date()+2, .F., 5) + " " + DTR->DTR_HORINI+"00", "@R 99\/99/\9999 99:99:99"),;	//16 - Previsao de Chegada
						aNotas})								//17 - Vetor de Notas Fiscais
		aNotas := {}
		(cAliasQry)->(dbSkip())
	EndDo
	(cAliasQry)->(dbCloseArea())
EndIf

Return aDocs
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MacExec  ºAutor  ³ Vinícius Moreira   º Data ³ 21/03/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina verificadora da macro digitada.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MacExec (cMacro,xResult)

Local bBlock := ErrorBlock()
Local bErro  := ErrorBlock( { |e| MacChk(e) } )

Private lRet:=.T.

If Empty(cMacro)
	Return .T.
Endif

xResult := &cMacro

ErrorBlock(bBlock)

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RGEFM03A ºAutor  ³ Vinícius Moreira   º Data ³ 21/09/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava log referente integração.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RGEFM03A (cFilOri, cViagem, cMsg, cLinObs)

Default cLinObs := cMsg

RecLock("PA5", .T.)
	PA5->PA5_FILIAL := xFilial("PA5")
	PA5->PA5_FILORI := cFilOri
	PA5->PA5_VIAGEM := cViagem
	PA5->PA5_DATA   := Date()
	PA5->PA5_HORA   := Left(StrTran(Time(), ":", ""), 4)
	PA5->PA5_LINOBS := cLinObs
PA5->(MsUnLock())

PA5->(MSMM(,80,,cMsg,1,,,"PA5","PA5_CODOBS"))

Return 

