#Include "aArray.ch"
#Include "jSon.ch"
#Include "Protheus.ch"
#Include "ApWebSrv.ch"

#Define nSAIORI 01
#Define nENTALV 02
#Define nSAIALV 03
#Define nLOGIST 04
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRGEFM04   บAutor  ณ Vinํcius Moreira   บ Data ณ 20/10/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ WS de integra็ใo com a Buonny.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
WSSTRUCT request
	WSDATA sm	As integer  			//-- String de entrada dos metodos que processa XML.
	WSDATA latitude	As float  			//-- String de entrada dos metodos que processa XML.
	WSDATA longitude	As float  		//-- String de entrada dos metodos que processa XML.
	WSDATA evento	As String  			//-- String de entrada dos metodos que processa XML.
	WSDATA codigo_externo	As String  	//-- String de entrada dos metodos que processa XML.
	WSDATA alvo	As String  				//-- String de entrada dos metodos que processa XML.
	WSDATA data_hora	As String  		//-- String de entrada dos metodos que processa XML.
ENDWSSTRUCT 

WSSTRUCT result
	WSDATA sucesso	As integer  		//-- String de entrada dos metodos que processa XML.
	WSDATA erro	As String  				//-- String de entrada dos metodos que processa XML.
ENDWSSTRUCT 

WsService RGEFM04 Description "Integra็ใo Buonny"

WSDATA evento as request
WSDATA evento_result as result

WsMethod ReceberEvento Description "Receber eventos Buonny."

EndWsService
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReceberEventosบAutorณ Vinํcius Moreira บ Data ณ  10/20/14   บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Recebe os eventos da Buonny.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
WsMethod ReceberEvento WSReceive evento WSSend evento_result WsService RGEFM04

Local lTudoOk   := .F.
Local cMsgErr   := ""
Local dDatEve   := cToD("//")
Local cHorEve   := ""

Conout("//--  RGEFM04 - Inicio - Recebendo informa็๕es --//")
Conout("SM            - " + cValToChar(::evento:sm) )
Conout("Latitude      - " + cValToChar(::evento:latitude) )
Conout("Longitude     - " + cValToChar(::evento:longitude) )
Conout("Evento        - " + ::evento:evento )
Conout("Cod.Externo   - " + ::evento:codigo_externo )
Conout("Alvo          - " + ::evento:alvo )
Conout("Data Hora     - " + ::evento:data_hora )
Conout("//--  RGEFM04 - Fim    - Recebendo informa็๕es --//")

If Empty(::evento:sm)
	cMsgErr := "Sem informacoes para processamento."
Else
	dDatEve  := sToD(StrTran(SubStr(::evento:data_hora, 01, 10), "-", ""))
	cHorEve  := StrTran(SubStr(::evento:data_hora, 12, 08), ":", "")
	
	U_RGEFM04A (	cValToChar(::evento:sm),;
					::evento:latitude,;
					::evento:longitude,;
					::evento:evento,;
					::evento:codigo_externo,;
					::evento:alvo,;
					dDatEve,;
					cHorEve)
	lTudoOk := .T.
EndIf

If lTudoOk 
	::evento_result:sucesso := 1
	::evento_result:erro    := ""
Else
	::evento_result:sucesso := 0
	::evento_result:erro    := cMsgErr
EndIf

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RGEFM04A บAutor  ณ Vinํcius Moreira   บ Data ณ 21/09/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava log referente integra็ใo.                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RGEFM04A (nSm, nLatit, nLongi, cEvento, cCodExt, cAlvo, dDatEve, cHorEve, cMsg)

Local cStatus   := "1"
Local lAutoOco  := GetMv("ES_GEFM04B",,.T.)
Default cMsg    := ""
Default cCodExt := ""
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCheca se deve ser gerada ocorr๊ncia ao receber informa็ใo da Buonny.   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lAutoOco
	cStatus := fIncOco(nSm, cEvento, cCodExt, dDatEve, cHorEve)
EndIf

RecLock("PA6", .T.)
	PA6->PA6_FILIAL := xFilial("PA6")
	PA6->PA6_NUMSM  := nSm
	PA6->PA6_LATIT  := nLatit
	PA6->PA6_LONGI  := nLongi
	PA6->PA6_EVENTO := cEvento
	PA6->PA6_CODEXT := cCodExt
	PA6->PA6_ALVO   := cAlvo
	PA6->PA6_DATEVE := dDatEve
	PA6->PA6_HOREVE := cHorEve
	PA6->PA6_DATREC := Date()
	PA6->PA6_HORREC := Left(StrTran(Time(), ":", ""), 4)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPossiveis status.                                                      ณ
	//ณ1=Recebido                                                             ณ
	//ณ2=Oco.Gerada                                                           ณ
	//ณ3=Erro                                                                 ณ
	//ณ4=SM Invalida                                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If PA6->(FieldPos("PA6_STATUS")) > 0
		PA6->PA6_STATUS := cStatus
	EndIf
PA6->(MsUnLock())

If !Empty(cMsg)
	PA6->(MSMM(,80,,cMsg,1,,,"PA6","PA6_CODOBS"))
EndIf

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fIncOco  บAutor  ณ Vinํcius Moreira   บ Data ณ 09/11/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava็ใo da ocorr๊ncia.                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fIncOco (nSm, cEvento, cCodExt, dDatEve, cHorEve)

Local cRet          := "1"
Local cQuery        := ""
Local cAliasQry     := GetNextAlias()
Local aCabec        := {}
Local aItem         := {}
Local aItens        := {}
Local cNumOco       := ""
Local cFilBkp       := ""
Local cDirLog       := GetMv("ES_GEFM04A",,"\2LGI\Buonny\ReceberEvento\")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณUtilizo os mesmos parโmetros do painel TDC para centralizar informa็ใo.           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aOco          := {{	GetMv("ES_GEFM02H",,"GC01"),;
							GetMv("ES_GEFM02I",,"GC02"),;
							GetMv("ES_GEFM02L",,"GC05"),;
							GetMv("ES_GEFM02O",,"GC08")},;
						{	GetMv("ES_GEFM02P",,"GE01"),;
							GetMv("ES_GEFM02Q",,"GE02"),;
							GetMv("ES_GEFM02T",,"GE05"),;
							GetMv("ES_GEFM02X",,"GE08")}}
Local nTipOco		:= 1
Private INCLUI      := .T.
Private lMsErroAuto := .F.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPossiveis eventos da Buonny.                                            ณ
//ณentrada_alvo - Por alvo                                                 ณ
//ณlogistico    - Por viagem                                               ณ
//ณsaida_alvo   - Por alvo                                                 ณ
//ณsaida_origem - Por viagem                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If cEvento $ "logistico|saida_origem"
	cQuery := "  SELECT " + CRLF
	cQuery += "    DTQ.R_E_C_N_O_ DTQREC " + CRLF
	cQuery += "   ,DUD.R_E_C_N_O_ DUDREC " + CRLF
	cQuery += "   ,DT6.R_E_C_N_O_ DT6REC " + CRLF
	cQuery += "  FROM " + RetSqlName("DTQ") + " DTQ " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DUD") + " DUD ON " + CRLF
	cQuery += "       DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF
	cQuery += "   AND DUD.DUD_FILORI = DTQ.DTQ_FILORI " + CRLF
	cQuery += "   AND DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM " + CRLF
	cQuery += "   AND DUD.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 ON " + CRLF
	cQuery += "       DT6.DT6_FILIAL = '" + xFilial("DT6") + "' " + CRLF
	cQuery += "   AND DT6.DT6_FILDOC = DUD.DUD_FILDOC " + CRLF
	cQuery += "   AND DT6.DT6_DOC    = DUD.DUD_DOC " + CRLF
	cQuery += "   AND DT6.DT6_SERIE  = DUD.DUD_SERIE " + CRLF
	cQuery += "   AND DT6.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " WHERE DTQ.DTQ_FILIAL = '" + xFilial("DTQ") + "' " + CRLF
	cQuery += "   AND DTQ.DTQ_XSMBNY = '" + cValToChar(nSm) + "' " + CRLF
	cQuery += "   AND DTQ.D_E_L_E_T_ = ' ' " + CRLF
Else
	cQuery := "  SELECT " + CRLF
	cQuery += "    DTQ.R_E_C_N_O_ DTQREC " + CRLF
	cQuery += "   ,DUD.R_E_C_N_O_ DUDREC " + CRLF
	cQuery += "   ,DT6.R_E_C_N_O_ DT6REC " + CRLF
	cQuery += "  FROM " + RetSqlName("DTQ") + " DTQ " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DUD") + " DUD ON " + CRLF
	cQuery += "       DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF
	cQuery += "   AND DUD.DUD_FILORI = DTQ.DTQ_FILORI " + CRLF
	cQuery += "   AND DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM " + CRLF
	cQuery += "   AND DUD.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 ON " + CRLF
	cQuery += "       DT6.DT6_FILIAL = '" + xFilial("DT6") + "' " + CRLF
	cQuery += "   AND DT6.DT6_FILDOC = DUD.DUD_FILDOC " + CRLF
	cQuery += "   AND DT6.DT6_DOC    = DUD.DUD_DOC " + CRLF
	cQuery += "   AND DT6.DT6_SERIE  = DUD.DUD_SERIE " + CRLF
	cQuery += "   AND DT6.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON " + CRLF
	cQuery += "       SA1.A1_FILIAL  = '" + xFilial("SA1") + "' " + CRLF
	cQuery += "   AND SA1.A1_COD     = DT6.DT6_CLIDES " + CRLF
	cQuery += "   AND SA1.A1_LOJA    = DT6.DT6_LOJDES " + CRLF
	cQuery += "   AND SA1.A1_CGC     = '" + cCodExt + "' " + CRLF
	cQuery += "   AND SA1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " WHERE DTQ.DTQ_FILIAL = '" + xFilial("DTQ") + "' " + CRLF
	cQuery += "   AND DTQ.DTQ_XSMBNY = '" + cValToChar(nSm) + "' " + CRLF
	cQuery += "   AND DTQ.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " UNION ALL " + CRLF
	cQuery += "  SELECT " + CRLF
	cQuery += "    DTQ.R_E_C_N_O_ DTQREC " + CRLF
	cQuery += "   ,DUD.R_E_C_N_O_ DUDREC " + CRLF
	cQuery += "   ,DT6.R_E_C_N_O_ DT6REC " + CRLF
	cQuery += "  FROM " + RetSqlName("DTQ") + " DTQ " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DUD") + " DUD ON " + CRLF
	cQuery += "       DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF
	cQuery += "   AND DUD.DUD_FILORI = DTQ.DTQ_FILORI " + CRLF
	cQuery += "   AND DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM " + CRLF
	cQuery += "   AND DUD.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 ON " + CRLF
	cQuery += "       DT6.DT6_FILIAL = '" + xFilial("DT6") + "' " + CRLF
	cQuery += "   AND DT6.DT6_FILDOC = DUD.DUD_FILDOC " + CRLF
	cQuery += "   AND DT6.DT6_DOC    = DUD.DUD_DOC " + CRLF
	cQuery += "   AND DT6.DT6_SERIE  = DUD.DUD_SERIE " + CRLF
	cQuery += "   AND DT6.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DT5") + " DT5 ON " + CRLF
	cQuery += "       DT5.DT5_FILIAL = DUD.DUD_FILDOC " + CRLF
	cQuery += "   AND DT5.DT5_FILDOC = DUD.DUD_FILDOC " + CRLF
	cQuery += "   AND DT5.DT5_DOC    = DUD.DUD_DOC " + CRLF
	cQuery += "   AND DT5.DT5_SERIE  = DUD.DUD_SERIE " + CRLF
	cQuery += "   AND DT5.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DUE") + " DUE ON " + CRLF
	cQuery += "       DUE.DUE_FILIAL = '" + xFilial("DUE") + "' " + CRLF
	cQuery += "   AND DUE.DUE_DDD    = DT5.DT5_DDD " + CRLF
	cQuery += "   AND DUE.DUE_TEL    = DT5.DT5_TEL " + CRLF
	cQuery += "   AND DUE.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON " + CRLF
	cQuery += "       SA1.A1_FILIAL  = '" + xFilial("SA1") + "' " + CRLF
	cQuery += "   AND SA1.A1_COD     = DUE.DUE_CODCLI " + CRLF
	cQuery += "   AND SA1.A1_LOJA    = DUE.DUE_LOJCLI " + CRLF
	cQuery += "   AND SA1.A1_CGC     = '" + cCodExt + "' " + CRLF
	cQuery += "   AND SA1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " WHERE DTQ.DTQ_FILIAL = '" + xFilial("DTQ") + "' " + CRLF
	cQuery += "   AND DTQ.DTQ_XSMBNY = '" + cValToChar(nSm) + "' " + CRLF
	cQuery += "   AND DTQ.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "  GROUP BY " + CRLF
	cQuery += "    DTQ.R_E_C_N_O_ " + CRLF
	cQuery += "   ,DUD.R_E_C_N_O_ " + CRLF
	cQuery += "   ,DT6.R_E_C_N_O_ " + CRLF
EndIf

cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .T.)
If (cAliasQry)->(Eof())
	cRet := "4"
Else
	fCriaDir (cDirLog)

	DTQ->(dbGoTo((cAliasQry)->DTQREC))
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefine posi็ใo onde estใo localizadas as ocorr๊ncias de acordo com o servi็o.  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If DTQ->DTQ_SERTMS == "1"
		nTipOco := 1
	Else
		nTipOco := 2
	EndIf
	While (cAliasQry)->(!Eof())
		DUD->(dbGoTo((cAliasQry)->DUDREC))
		DT6->(dbGoTo((cAliasQry)->DT6REC))
		
		//cNumOco := GetSx8Num ("DUA","DUA_NUMOCO",Nil)
		aCabec := {;
			{"DUA_FILORI", DUD->DUD_FILORI, NIL},;
			{"DUA_VIAGEM", DUD->DUD_VIAGEM, NIL};
		}
		
		//aAdd(aItem, {"DUA_NUMOCO", cNumOco 							,NIL})
		aAdd(aItem, {"DUA_SEQOCO", '0001'							,NIL})
		aAdd(aItem, {"DUA_DATOCO", dDatEve							,NIL})
		aAdd(aItem, {"DUA_HOROCO", cHorEve							,NIL})
		If cEvento == "saida_origem"
			aAdd(aItem, {"DUA_CODOCO", aOco[nTipOco, nSAIORI]	  	,NIL})
		ElseIf cEvento == "entrada_alvo"
			aAdd(aItem, {"DUA_CODOCO", aOco[nTipOco, nENTALV]	  	,NIL})
		ElseIf cEvento == "saida_alvo"
			aAdd(aItem, {"DUA_CODOCO", aOco[nTipOco, nSAIALV]	  	,NIL})
		ElseIf cEvento == "logistico"
			aAdd(aItem, {"DUA_CODOCO", aOco[nTipOco, nLOGIST]	  	,NIL})
		EndIf		
		aAdd(aItem, {"DUA_SERTMS", DUD->DUD_SERTMS					,NIL})
		aAdd(aItem, {"DUA_FILDOC", DT6->DT6_FILDOC					,NIL})
		aAdd(aItem, {"DUA_DOC"   , DT6->DT6_DOC						,NIL})
		aAdd(aItem, {"DUA_SERIE" , DT6->DT6_SERIE					,NIL})
		aAdd(aItem, {"DUA_QTDVOL", DT6->DT6_VOLORI					,NIL})
		aAdd(aItem, {"DUA_PESO"  , DT6->DT6_PESO 					,NIL})
		
		If DUD->DUD_SERTMS == "1"
			aAdd(aItem, {"DUA_QTDOCO", Iif(DT6->DT6_QTDVOL == 0, 1, DT6->DT6_QTDVOL)	,NIL})
			aAdd(aItem, {"DUA_PESOCO", Iif(DT6->DT6_PESO == 0  , 1, DT6->DT6_PESO)		,NIL})
		EndIf
		
		aAdd(aItens, aItem)			
		cFilAnt := DTQ->DTQ_FILDES 

		INCLUI   := .T.
		//-- Inclusao da Ocorrencia
		MsExecAuto({|x,y,z| Tmsa360(x,y,z)}, aCabec, aItens, {}, 3)
		If lMsErroAuto
			MostraErro(cDirLog, DTQ->DTQ_VIAGEM + "_" + DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE) + ".txt")
			Conout(DT6->(DT6_FILDOC+"-"+DT6_DOC+"/"+DT6_SERIE) + " - Problemas durante tentativa de grava็ใo de ocorr๊ncia.")
			cRet := "3"
		Else
			//ConfirmSx8()
			Conout(DT6->(DT6_FILDOC+"-"+DT6_DOC+"/"+DT6_SERIE) + " - Documento baixado com sucesso.")
			cRet := "2"
		EndIf	
		lMsErroAuto := .F.
		
		cFilAnt := cFilBkp
		aCabec  := {}
		aItens  := {}
		aItem   := {}
		(cAliasQry)->(dbSkip())
	EndDo
EndIf

Return cRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fCriaDir บAutor  ณ Vinํcius Moreira   บ Data ณ 24/07/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria diretorios utilizados pelo programa.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCriaDir (cPatch)

Local lRet   := .T.
Local aDirs  := {}
Local nPasta := 1
Local cPasta := ""
Local cBarra   := If(IsSrvUnix(), "/", "\")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriando diret๓rio de configura็๕es de usuแrios.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aDirs := Separa(cPatch, cBarra)
For nPasta := 1 to Len(aDirs)
	If !Empty (aDirs[nPasta])
		cPasta += cBarra + aDirs[nPasta]
		If !ExistDir (cPasta) .And. MakeDir(cPasta) != 0
			lRet := .F.
			Exit
		EndIf
	EndIf
Next nPasta

Return lRet 