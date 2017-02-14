#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://www.vitgbrasil.com.br:80/vedi/vitgws?wsdl
Gerado em        12/26/16 11:48:12
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _OSKQKPK ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSVirtualITGService
------------------------------------------------------------------------------- */

WSCLIENT WSVirtualITGService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD getAuthInfo

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   narg0                     AS int
	WSDATA   carg1                     AS string
	WSDATA   narg2                     AS int
	WSDATA   creturn                   AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSVirtualITGService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20161027] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSVirtualITGService
Return

WSMETHOD RESET WSCLIENT WSVirtualITGService
	::narg0              := NIL 
	::carg1              := NIL 
	::narg2              := NIL 
	::creturn            := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSVirtualITGService
Local oClone := WSVirtualITGService():New()
	oClone:_URL          := ::_URL 
	oClone:narg0         := ::narg0
	oClone:carg1         := ::carg1
	oClone:narg2         := ::narg2
	oClone:creturn       := ::creturn
Return oClone

// WSDL Method getAuthInfo of Service WSVirtualITGService

WSMETHOD getAuthInfo WSSEND narg0,carg1,narg2 WSRECEIVE creturn WSCLIENT WSVirtualITGService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<getAuthInfo xmlns="http://ws.vitgbrasil.com/">'
cSoap += WSSoapValue("arg0", ::narg0, narg0 , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("arg1", ::carg1, carg1 , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("arg2", ::narg2, narg2 , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += "</getAuthInfo>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.vitgbrasil.com/",,,; 
	"http://www.vitgbrasil.com.br:80/vedi/vitgws")

::Init()
::creturn            :=  WSAdvValue( oXmlRet,"_GETAUTHINFORESPONSE:_RETURN:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



