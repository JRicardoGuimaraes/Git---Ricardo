#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
//#INCLUDE "RPTDEF.CH"
//#INCLUDE "FWPrintSetup.ch"
//#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"


user function uConSitSef(oXml,pFileOpen)

local cChave :=  ALLTrim(StrTran( oXml:_NFE:_INFNFE:_ID:TEXT,'NFe',''))
local cCNPJ1 := ALLTrim(oXml:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
local cCNPJ2 := ALLTrim(oXml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
local cNNFE  := ALLTrim(oXml:_NFE:_INFNFE:_IDE:_NNF:TEXT)
local cSNFE  := ALLTrim(oXml:_NFE:_INFNFE:_IDE:_SERIE:TEXT)
local cIdentif := ""
local cAutoriza := .f.
local nStatus1
local cNomArqVal := ""

cIdentif := IdentifTss(cCNPJ1,cCNPJ2)

if !Empty(cIdentif) .and. cIdentif <> "Erro"
	cAutoriza := ConsSitNFE(cChave,cIdentif,cNNFE,cSNFE)
	if cAutoriza
		nStatus1 := FRENAME(pFileOpen,Substr(pFileOpen,1,RAT("\",pFileOpen))+"AUTORIZADA_nfe"+cNNFE+"_s"+cSNFE+".xml")
		IF nStatus1 == -1
			MsgStop('Falha ao renomear o arquivo, erro: '+str(ferror(),4))
		else
			cNomArqVal := Substr(pFileOpen,1,RAT("\",pFileOpen))+"AUTORIZADA_nfe"+cNNFE+"_s"+cSNFE+".xml"
		endif
	else
		nStatus1 := FRENAME(pFileOpen,Substr(pFileOpen,1,RAT("\",pFileOpen))+"NAO_AUTORIZADA_nfe"+cNNFE+"_s"+cSNFE+".xml")
		IF nStatus1 == -1
			MsgStop('Falha ao renomear o arquivo, erro: '+str(ferror(),4))
		else
			cNomArqVal := Substr(pFileOpen,1,RAT("\",pFileOpen))+"NAO_AUTORIZADA_nfe"+cNNFE+"_s"+cSNFE+".xml"
		endif
	endif
else
	alert("Nao foi possivel encontrar a identificacao da empresa corrente no TSS para o CNPJ contido no XML")
endif

return({cAutoriza,cNomArqVal})


static Function IdentifTss(pCNPJ1,pCNPJ2)

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OpenSm0()
dbSetOrder(1)
DBSeek(cEmpAnt+cFilAnt)

if ALLTrim(SM0->M0_CGC) <> pCNPJ1 .and. ALLTrim(SM0->M0_CGC) <> pCNPJ2
	MsgInfo(" O CNPJ nº " + ALLTrim(SM0->M0_CGC) + " da empresa corrente nao foi encontrado no arquivo XML ")
	cIdEnt := "Erro"
else
	
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
		cIdEnt := oWs:cADMEMPRESASRESULT
	endif
	
endif

return cIdEnt



Static Function ConsSitNFE(pChaveNFe,pIdEnt,pNNFE,pSNFE)

Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cMensagem:= ""
local cAutoriza1 := .F.
Local oWS
Local lErro := .F.

oWs:= WsNFeSBra():New()

oWs:cUserToken   := "TOTVS"
oWs:cID_ENT      := pIdEnt
ows:cCHVNFE		 := pChaveNFe
oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"

If oWs:CONSULTADTCHAVENFE()  // ConsultaChaveNFE
	
	cMensagem += "NF-e Numero: "+pNNFE+CRLF
	cMensagem += "Serie: "+pSNFE+CRLF
	cMensagem += "Situacao atual: "+oWs:oWSCONSULTADTCHAVENFERESULT:cMSGRETNFE+CRLF
	cMensagem += "Ambiente: "+IIf(oWs:oWSCONSULTADTCHAVENFERESULT:nAMBIENTE==1,"Produção","Homologação")+CRLF
	cMensagem += "Codigo de Retorno: "+oWs:oWSCONSULTADTCHAVENFERESULT:cCODRETNFE+CRLF
	
	If !Empty(oWs:oWSCONSULTADTCHAVENFERESULT:cVERSAO)
		cMensagem += "Versão da Mensagem: "+oWs:oWSCONSULTADTCHAVENFERESULT:cVERSAO+CRLF
	EndIf
	
	If !Empty(oWs:oWSCONSULTADTCHAVENFERESULT:cPROTOCOLO)
		cMensagem += "Protocolo: "+oWs:oWSCONSULTADTCHAVENFERESULT:cPROTOCOLO+CRLF
	EndIf
	
	Iif( oWs:oWSCONSULTADTCHAVENFERESULT:cCODRETNFE == "100",cAutoriza1 := .T.,cAutoriza1 := .F.)
	
	cMensagem += "Data do Recebimento no Sefaz: "+DTOC(oWs:oWSCONSULTADTCHAVENFERESULT:DRECBTO)+CRLF
	
	Aviso("Consulta NF-e Sefaz",cMensagem,{"Ok"},3)
	
Else
	Aviso("Totvs Sped Service",GetWscError(),{"Ok"},3)
EndIf

Return cAutoriza1
