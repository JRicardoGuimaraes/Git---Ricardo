#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://10.63.249.78:8083/ws/GEFWS.apw?WSDL
Gerado em        03/10/17 15:57:42
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _WZVQJSW ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSGEFWS
------------------------------------------------------------------------------- */

WSCLIENT WSGEFWS

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CONSULTACLI

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCPARAMCLI                AS string
	WSDATA   oWSCONSULTACLIRESULT      AS GEFWS_CLIENTES

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSGEFWS
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20150410] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSGEFWS
	::oWSCONSULTACLIRESULT := GEFWS_CLIENTES():New()
Return

WSMETHOD RESET WSCLIENT WSGEFWS
	::cCPARAMCLI         := NIL 
	::oWSCONSULTACLIRESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSGEFWS
Local oClone := WSGEFWS():New()
	oClone:_URL          := ::_URL 
	oClone:cCPARAMCLI    := ::cCPARAMCLI
	oClone:oWSCONSULTACLIRESULT :=  IIF(::oWSCONSULTACLIRESULT = NIL , NIL ,::oWSCONSULTACLIRESULT:Clone() )
Return oClone

// WSDL Method CONSULTACLI of Service WSGEFWS

WSMETHOD CONSULTACLI WSSEND cCPARAMCLI WSRECEIVE oWSCONSULTACLIRESULT WSCLIENT WSGEFWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CONSULTACLI xmlns="http://10.63.249.78:8083/">'
cSoap += WSSoapValue("CPARAMCLI", ::cCPARAMCLI, cCPARAMCLI , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CONSULTACLI>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://10.63.249.78:8083/CONSULTACLI",; 
	"DOCUMENT","http://10.63.249.78:8083/",,"1.031217",; 
	"http://10.63.249.78:8083/ws/GEFWS.apw")

::Init()
::oWSCONSULTACLIRESULT:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTACLIRESPONSE:_CONSULTACLIRESULT","CLIENTES",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure CLIENTES

WSSTRUCT GEFWS_CLIENTES
	WSDATA   oWSREGISTROS              AS GEFWS_ARRAYOFCLIENTE
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT GEFWS_CLIENTES
	::Init()
Return Self

WSMETHOD INIT WSCLIENT GEFWS_CLIENTES
Return

WSMETHOD CLONE WSCLIENT GEFWS_CLIENTES
	Local oClone := GEFWS_CLIENTES():NEW()
	oClone:oWSREGISTROS         := IIF(::oWSREGISTROS = NIL , NIL , ::oWSREGISTROS:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT GEFWS_CLIENTES
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_REGISTROS","ARRAYOFCLIENTE",NIL,"Property oWSREGISTROS as s0:ARRAYOFCLIENTE on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSREGISTROS := GEFWS_ARRAYOFCLIENTE():New()
		::oWSREGISTROS:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure ARRAYOFCLIENTE

WSSTRUCT GEFWS_ARRAYOFCLIENTE
	WSDATA   oWSCLIENTE                AS GEFWS_CLIENTE OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT GEFWS_ARRAYOFCLIENTE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT GEFWS_ARRAYOFCLIENTE
	::oWSCLIENTE           := {} // Array Of  GEFWS_CLIENTE():New()
Return

WSMETHOD CLONE WSCLIENT GEFWS_ARRAYOFCLIENTE
	Local oClone := GEFWS_ARRAYOFCLIENTE():NEW()
	oClone:oWSCLIENTE := NIL
	If ::oWSCLIENTE <> NIL 
		oClone:oWSCLIENTE := {}
		aEval( ::oWSCLIENTE , { |x| aadd( oClone:oWSCLIENTE , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT GEFWS_ARRAYOFCLIENTE
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLIENTE","CLIENTE",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCLIENTE , GEFWS_CLIENTE():New() )
			::oWSCLIENTE[len(::oWSCLIENTE)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure CLIENTE

WSSTRUCT GEFWS_CLIENTE
	WSDATA   cBAIRRO                   AS string OPTIONAL
	WSDATA   cENDERECO                 AS string OPTIONAL
	WSDATA   cESTADO                   AS string OPTIONAL
	WSDATA   cNOME                     AS string
	WSDATA   cUF                       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT GEFWS_CLIENTE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT GEFWS_CLIENTE
Return

WSMETHOD CLONE WSCLIENT GEFWS_CLIENTE
	Local oClone := GEFWS_CLIENTE():NEW()
	oClone:cBAIRRO              := ::cBAIRRO
	oClone:cENDERECO            := ::cENDERECO
	oClone:cESTADO              := ::cESTADO
	oClone:cNOME                := ::cNOME
	oClone:cUF                  := ::cUF
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT GEFWS_CLIENTE
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cBAIRRO            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cENDERECO          :=  WSAdvValue( oResponse,"_ENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cESTADO            :=  WSAdvValue( oResponse,"_ESTADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNOME              :=  WSAdvValue( oResponse,"_NOME","string",NIL,"Property cNOME as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cUF                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

//-----------------------------------
User Function GEFWSCli01()
Local oWSClient 
Local oCli
Local aCli := Array(5)

SET DATE BRITISH
SET CENTURY ON 
SET EPOCH TO 1960
 
// Cria a instância da classe Client do WebService da Gefco
oWSClient := WSGEFWS():New()

oWSClient:CCPARAMCLI := '03094658000106'

oCli := oWSClient:ConsultaCli()

// For x:=1 to Len(oWSClient:owsconsultacliresult:owsregistros:owscliente)
//	CONOUT('CLIENTE ==> ' + StrZero(x,3))
	aCli[1] := oWSClient:owsconsultacliresult:owsregistros:owscliente[1]:CNOME
	aCli[2] := oWSClient:owsconsultacliresult:owsregistros:owscliente[1]:CENDERECO 
	aCli[3] := oWSClient:owsconsultacliresult:owsregistros:owscliente[1]:CBAIRRO
	aCli[4] := oWSClient:owsconsultacliresult:owsregistros:owscliente[1]:CESTADO
	aCli[5] := oWSClient:owsconsultacliresult:owsregistros:owscliente[1]:CUF
	
	CONOUT(aCli[1])
	CONOUT(aCli[2])
	CONOUT(aCli[3])
	CONOUT(aCli[4])
	CONOUT(aCli[5])
	
	Aviso('Cliente', 'Nome: ' + aCli[1] + CRLF +;
	 				 'End.: ' + aCli[2] + CRLF +;
	 				 'Bai.: ' + aCli[3] + CRLF +;
	 				 'Est.: ' + aCli[4] + CRLF +;
	 				 'UF  : ' + aCli[5] + CRLF  , {'Ok'}, 3 )				
// Next x

Return



