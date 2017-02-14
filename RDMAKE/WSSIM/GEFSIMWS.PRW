#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH" 
#INCLUDE "XMLXFUN.CH"
#Include "TbiConn.ch"

#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://lb.simconsultas.com.br/wsnfe/service.asmx?WSDL
Gerado em        10/28/14 11:50:27
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _ZPMQMNR ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSSIMConsultasNFeService
------------------------------------------------------------------------------- */

WSCLIENT WSSIMConsultasNFeService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GetNfe
	WSMETHOD GetNfeResumido
	WSMETHOD GetNfeTipo
	WSMETHOD GetNfeTipoIP
	WSMETHOD GetNfe310
	WSMETHOD GetNfeResumido310
	WSMETHOD GetNfeTipo310
	WSMETHOD GetNfeTipoIP310
	WSMETHOD RetornaTimeOut
	WSMETHOD RefreshTimeOut
	WSMETHOD ValidaNfe

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cchaveAcesso              AS string
	WSDATA   cchaveNFe                 AS string
	WSDATA   oWSGetNfeResult           AS SCHEMA
	WSDATA   cGetNfeResumidoResult     AS string
	WSDATA   nTipo                     AS int
	WSDATA   oWSGetNfeTipoResult       AS SCHEMA
	WSDATA   cIP                       AS string
	WSDATA   oWSGetNfeTipoIPResult     AS SCHEMA
	WSDATA   oWSGetNfe310Result        AS SCHEMA
	WSDATA   cGetNfeResumido310Result  AS string
	WSDATA   oWSGetNfeTipo310Result    AS SCHEMA
	WSDATA   oWSGetNfeTipoIP310Result  AS SCHEMA
	WSDATA   nRetornaTimeOutResult     AS int
	WSDATA   cxmlFile                  AS string
	WSDATA   ccnpj                     AS string
	WSDATA   oWSValidaNfeResult        AS SCHEMA

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSSIMConsultasNFeService
	::Init()
	If !FindFunction("XMLCHILDEX")
		UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.121227P-20131106] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
	EndIf
Return Self

WSMETHOD INIT WSCLIENT WSSIMConsultasNFeService
	::oWSGetNfeResult				:= NIL
	::oWSGetNfeTipoResult		:= NIL 
	::oWSGetNfeTipoIPResult		:= NIL 
	::oWSGetNfe310Result			:= NIL 
	::oWSGetNfeTipo310Result	:= NIL 
	::oWSGetNfeTipoIP310Result	:= NIL 
	::oWSValidaNfeResult			:= NIL 
Return

WSMETHOD RESET WSCLIENT WSSIMConsultasNFeService
	::cchaveAcesso					:= NIL 
	::cchaveNFe						:= NIL 
	::oWSGetNfeResult				:= NIL 
	::cGetNfeResumidoResult		:= NIL 
	::nTipo							:= NIL 
	::oWSGetNfeTipoResult		:= NIL 
	::cIP								:= NIL 
	::oWSGetNfeTipoIPResult		:= NIL 
	::oWSGetNfe310Result			:= NIL 
	::cGetNfeResumido310Result	:= NIL 
	::oWSGetNfeTipo310Result	:= NIL 
	::oWSGetNfeTipoIP310Result	:= NIL 
	::nRetornaTimeOutResult		:= NIL 
	::cxmlFile						:= NIL 
	::ccnpj							:= NIL 
	::oWSValidaNfeResult			:= NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSSIMConsultasNFeService
	Local oClone := WSSIMConsultasNFeService():New()
	
	oClone:_URL								:= ::_URL 
	oClone:cchaveAcesso					:= ::cchaveAcesso
	oClone:cchaveNFe						:= ::cchaveNFe
	oClone:cGetNfeResumidoResult		:= ::cGetNfeResumidoResult
	oClone:nTipo							:= ::nTipo
	oClone:cIP								:= ::cIP
	oClone:cGetNfeResumido310Result	:= ::cGetNfeResumido310Result
	oClone:nRetornaTimeOutResult		:= ::nRetornaTimeOutResult
	oClone:cxmlFile						:= ::cxmlFile
	oClone:ccnpj							:= ::ccnpj
Return oClone

// WSDL Method GetNfe of Service WSSIMConsultasNFeService

WSMETHOD GetNfe WSSEND cchaveAcesso,cchaveNFe WSRECEIVE oWSGetNfeResult WSCLIENT WSSIMConsultasNFeService

	Local cSoap := ""
	Local oXmlRet
	
	BEGIN WSMETHOD
	
		cSoap += '<GetNfe xmlns="http://nfe.simconsultas.com.br">'
		cSoap += WSSoapValue("chaveAcesso", ::cchaveAcesso, cchaveAcesso , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("chaveNFe", ::cchaveNFe, cchaveNFe , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += "</GetNfe>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,														; 
									  	"http://nfe.simconsultas.com.br/GetNfe",				; 
										"DOCUMENT","http://nfe.simconsultas.com.br",,,		; 
										"http://lb.simconsultas.com.br/wsnfe/service.asmx"	;
									  )
		
		::Init()
		::oWSGetNfeResult    :=  WSAdvValue( oXmlRet,"_GETNFERESPONSE","SCHEMA",NIL,NIL,NIL,"O",NIL,NIL) 
		
	END WSMETHOD
	
	oXmlRet := NIL
	
Return .T.

// WSDL Method GetNfeResumido of Service WSSIMConsultasNFeService

WSMETHOD GetNfeResumido WSSEND cchaveAcesso,cchaveNFe WSRECEIVE cGetNfeResumidoResult WSCLIENT WSSIMConsultasNFeService
	Local cSoap := ""
	Local oXmlRet
	
	BEGIN WSMETHOD
	
		cSoap += '<GetNfeResumido xmlns="http://nfe.simconsultas.com.br">'
		cSoap += WSSoapValue("chaveAcesso", ::cchaveAcesso, cchaveAcesso , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("chaveNFe", ::cchaveNFe, cchaveNFe , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += "</GetNfeResumido>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,														; 
										"http://nfe.simconsultas.com.br/GetNfeResumido",	; 
										"DOCUMENT","http://nfe.simconsultas.com.br",,,		; 
										"http://lb.simconsultas.com.br/wsnfe/service.asmx"	;
								     )
		
		::Init()
		
		::cGetNfeResumidoResult :=  WSAdvValue( oXmlRet,"_GETNFERESUMIDORESPONSE:_GETNFERESUMIDORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 
		
	END WSMETHOD
	
	oXmlRet := NIL
	
Return .T.

// WSDL Method GetNfeTipo of Service WSSIMConsultasNFeService

WSMETHOD GetNfeTipo WSSEND cchaveAcesso,cchaveNFe,nTipo WSRECEIVE oWSGetNfeTipoResult WSCLIENT WSSIMConsultasNFeService
	Local cSoap := ""
	Local oXmlRet

	BEGIN WSMETHOD
	
		cSoap += '<GetNfeTipo xmlns="http://nfe.simconsultas.com.br">'
		cSoap += WSSoapValue("chaveAcesso", ::cchaveAcesso, cchaveAcesso , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("chaveNFe", ::cchaveNFe, cchaveNFe , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("Tipo", ::nTipo, nTipo , "int", .T. , .F., 0 , NIL, .F.) 
		cSoap += "</GetNfeTipo>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,														; 
										"http://nfe.simconsultas.com.br/GetNfeTipo",			; 
										"DOCUMENT","http://nfe.simconsultas.com.br",,,		;
										"http://lb.simconsultas.com.br/wsnfe/service.asmx"	;
									  )
		
		::Init()
		::oWSGetNfeTipoResult :=  WSAdvValue( oXmlRet,"_GETNFETIPORESPONSE","SCHEMA",NIL,NIL,NIL,"O",NIL,NIL) 
		
	END WSMETHOD
	
	oXmlRet := NIL
	
Return .T.

// WSDL Method GetNfeTipoIP of Service WSSIMConsultasNFeService

WSMETHOD GetNfeTipoIP WSSEND cchaveAcesso,cchaveNFe,nTipo,cIP WSRECEIVE oWSGetNfeTipoIPResult WSCLIENT WSSIMConsultasNFeService
	Local cSoap := ""
	Local oXmlRet
	
	BEGIN WSMETHOD
	
		cSoap += '<GetNfeTipoIP xmlns="http://nfe.simconsultas.com.br">'
		cSoap += WSSoapValue("chaveAcesso", ::cchaveAcesso, cchaveAcesso , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("chaveNFe", ::cchaveNFe, cchaveNFe , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("Tipo", ::nTipo, nTipo , "int", .T. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("IP", ::cIP, cIP , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += "</GetNfeTipoIP>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,														;
										"http://nfe.simconsultas.com.br/GetNfeTipoIP",		; 
										"DOCUMENT","http://nfe.simconsultas.com.br",,,		; 
										"http://lb.simconsultas.com.br/wsnfe/service.asmx"	;
									  )
		
		::Init()
		::oWSGetNfeTipoIPResult :=  WSAdvValue( oXmlRet,"_GETNFETIPOIPRESPONSE","SCHEMA",NIL,NIL,NIL,"O",NIL,NIL) 
		
	END WSMETHOD
	
	oXmlRet := NIL
	
Return .T.

// WSDL Method GetNfe310 of Service WSSIMConsultasNFeService

WSMETHOD GetNfe310 WSSEND cchaveAcesso,cchaveNFe WSRECEIVE oWSGetNfe310Result WSCLIENT WSSIMConsultasNFeService
	Local cSoap := ""
	Local oXmlRet
	
	BEGIN WSMETHOD
	
		cSoap += '<GetNfe310 xmlns="http://nfe.simconsultas.com.br">'
		cSoap += WSSoapValue("chaveAcesso", ::cchaveAcesso, cchaveAcesso , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("chaveNFe", ::cchaveNFe, cchaveNFe , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += "</GetNfe310>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,														;
										"http://nfe.simconsultas.com.br/GetNfe310",			;
										"DOCUMENT","http://nfe.simconsultas.com.br",,,		;
										"http://lb.simconsultas.com.br/wsnfe/service.asmx"	;
									  )
		
		::Init()
		::oWSGetNfe310Result :=  WSAdvValue( oXmlRet,"_GETNFE310RESPONSE","SCHEMA",NIL,NIL,NIL,"O",NIL,NIL) 
		
	END WSMETHOD
	
	oXmlRet := NIL
	
Return .T.

// WSDL Method GetNfeResumido310 of Service WSSIMConsultasNFeService

WSMETHOD GetNfeResumido310 WSSEND cchaveAcesso,cchaveNFe WSRECEIVE cGetNfeResumido310Result WSCLIENT WSSIMConsultasNFeService
	Local cSoap := ""
	Local oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<GetNfeResumido310 xmlns="http://nfe.simconsultas.com.br">'
		cSoap += WSSoapValue("chaveAcesso", ::cchaveAcesso, cchaveAcesso , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("chaveNFe", ::cchaveNFe, cchaveNFe , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += "</GetNfeResumido310>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,														;
										"http://nfe.simconsultas.com.br/GetNfeResumido310",; 
										"DOCUMENT","http://nfe.simconsultas.com.br",,,		; 
										"http://lb.simconsultas.com.br/wsnfe/service.asmx"	;
									  )

		::Init()
		::cGetNfeResumido310Result :=  WSAdvValue( oXmlRet,"_GETNFERESUMIDO310RESPONSE:_GETNFERESUMIDO310RESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 
		
	END WSMETHOD
	
	oXmlRet := NIL
	
Return .T.

// WSDL Method GetNfeTipo310 of Service WSSIMConsultasNFeService

WSMETHOD GetNfeTipo310 WSSEND cchaveAcesso,cchaveNFe,nTipo WSRECEIVE oWSGetNfeTipo310Result WSCLIENT WSSIMConsultasNFeService
	Local cSoap := ""
	Local oXmlRet
	
	BEGIN WSMETHOD
	
		cSoap += '<GetNfeTipo310 xmlns="http://nfe.simconsultas.com.br">'
		cSoap += WSSoapValue("chaveAcesso", ::cchaveAcesso, cchaveAcesso , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("chaveNFe", ::cchaveNFe, cchaveNFe , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("Tipo", ::nTipo, nTipo , "int", .T. , .F., 0 , NIL, .F.) 
		cSoap += "</GetNfeTipo310>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,														;
										"http://nfe.simconsultas.com.br/GetNfeTipo310",		; 
										"DOCUMENT","http://nfe.simconsultas.com.br",,,		;
										"http://lb.simconsultas.com.br/wsnfe/service.asmx"	;
									  )

		::Init()
		::oWSGetNfeTipo310Result :=  WSAdvValue( oXmlRet,"_GETNFETIPO310RESPONSE","SCHEMA",NIL,NIL,NIL,"O",NIL,NIL) 

	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method GetNfeTipoIP310 of Service WSSIMConsultasNFeService

WSMETHOD GetNfeTipoIP310 WSSEND cchaveAcesso,cchaveNFe,nTipo,cIP WSRECEIVE oWSGetNfeTipoIP310Result WSCLIENT WSSIMConsultasNFeService
	Local cSoap := ""
	Local oXmlRet
	
	BEGIN WSMETHOD
		
		cSoap += '<GetNfeTipoIP310 xmlns="http://nfe.simconsultas.com.br">'
		cSoap += WSSoapValue("chaveAcesso", ::cchaveAcesso, cchaveAcesso , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("chaveNFe", ::cchaveNFe, cchaveNFe , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("Tipo", ::nTipo, nTipo , "int", .T. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("IP", ::cIP, cIP , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += "</GetNfeTipoIP310>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,														; 
										"http://nfe.simconsultas.com.br/GetNfeTipoIP310",	; 
										"DOCUMENT","http://nfe.simconsultas.com.br",,,		; 
										"http://lb.simconsultas.com.br/wsnfe/service.asmx"	;
									  )
									
		::Init()
		::oWSGetNfeTipoIP310Result :=  WSAdvValue( oXmlRet,"_GETNFETIPOIP310RESPONSE","SCHEMA",NIL,NIL,NIL,"O",NIL,NIL) 
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method RetornaTimeOut of Service WSSIMConsultasNFeService

WSMETHOD RetornaTimeOut WSSEND cChaveAcesso WSRECEIVE nRetornaTimeOutResult WSCLIENT WSSIMConsultasNFeService
	Local cSoap := ""
	Local oXmlRet
	
	BEGIN WSMETHOD
	
		cSoap += '<RetornaTimeOut xmlns="http://nfe.simconsultas.com.br">'
		cSoap += WSSoapValue("ChaveAcesso", ::cChaveAcesso, cChaveAcesso , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += "</RetornaTimeOut>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,														; 
										"http://nfe.simconsultas.com.br/RetornaTimeOut",	; 
										"DOCUMENT","http://nfe.simconsultas.com.br",,,		; 
										"http://lb.simconsultas.com.br/wsnfe/service.asmx"	;
									  )
									
		::Init()
		::nRetornaTimeOutResult :=  WSAdvValue( oXmlRet,"_RETORNATIMEOUTRESPONSE:_RETORNATIMEOUTRESULT:TEXT","int",NIL,NIL,NIL,NIL,NIL,NIL) 
		
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method RefreshTimeOut of Service WSSIMConsultasNFeService

WSMETHOD RefreshTimeOut WSSEND BYREF NULLPARAM WSRECEIVE NULLPARAM WSCLIENT WSSIMConsultasNFeService
	Local cSoap := ""
	Local oXmlRet
	
	BEGIN WSMETHOD
	
		cSoap += '<RefreshTimeOut xmlns="http://nfe.simconsultas.com.br">'
		cSoap += "</RefreshTimeOut>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,														;
										"http://nfe.simconsultas.com.br/RefreshTimeOut",	; 
										"DOCUMENT","http://nfe.simconsultas.com.br",,,		; 
										"http://lb.simconsultas.com.br/wsnfe/service.asmx"	;
									  )
									
		::Init()
	
	END WSMETHOD
	
	oXmlRet := NIL
Return .T.

// WSDL Method ValidaNfe of Service WSSIMConsultasNFeService

WSMETHOD ValidaNfe WSSEND cchaveAcesso,cxmlFile,ccnpj WSRECEIVE oWSValidaNfeResult WSCLIENT WSSIMConsultasNFeService
	Local cSoap := ""
	Local oXmlRet
	
	BEGIN WSMETHOD
	
		cSoap += '<ValidaNfe xmlns="http://nfe.simconsultas.com.br">'
		cSoap += WSSoapValue("chaveAcesso", ::cchaveAcesso, cchaveAcesso , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("xmlFile", ::cxmlFile, cxmlFile , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += WSSoapValue("cnpj", ::ccnpj, ccnpj , "string", .F. , .F., 0 , NIL, .F.) 
		cSoap += "</ValidaNfe>"
		
		oXmlRet := SvcSoapCall(	Self,cSoap,														; 
										"http://nfe.simconsultas.com.br/ValidaNfe",			; 
										"DOCUMENT","http://nfe.simconsultas.com.br",,,		; 
										"http://lb.simconsultas.com.br/wsnfe/service.asmx"	;
									  )

		::Init()
		::oWSValidaNfeResult :=  WSAdvValue( oXmlRet,"_VALIDANFERESPONSE","SCHEMA",NIL,NIL,NIL,"O",NIL,NIL) 
		
	END WSMETHOD
	
	oXmlRet := NIL
	
Return .T.
