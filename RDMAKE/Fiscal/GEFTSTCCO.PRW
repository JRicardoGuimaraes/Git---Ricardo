#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://54.232.215.246/CCO/WEbSERVICECCO.ASMX?wsdl
Gerado em        01/30/15 11:54:40
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _ZOXNMTN ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWebServiceCCO
------------------------------------------------------------------------------- */

WSCLIENT WSWebServiceCCO

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GetVins

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSvin                    AS WebServiceCCO_ArrayOfEcom

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWebServiceCCO
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.121227P-20131106] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWebServiceCCO
	::oWSvin             := WebServiceCCO_ARRAYOFECOM():New()
Return

WSMETHOD RESET WSCLIENT WSWebServiceCCO
	::oWSvin             := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWebServiceCCO
Local oClone := WSWebServiceCCO():New()
	oClone:_URL          := ::_URL 
	oClone:oWSvin        :=  IIF(::oWSvin = NIL , NIL ,::oWSvin:Clone() )
Return oClone

// WSDL Method GetVins of Service WSWebServiceCCO

WSMETHOD GetVins WSSEND NULLPARAM WSRECEIVE oWSvin WSCLIENT WSWebServiceCCO
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetVins xmlns="http://CCO/WebServiceCCO/">'
cSoap += "</GetVins>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://CCO/WebServiceCCO/GetVins",; 
	"DOCUMENT","http://CCO/WebServiceCCO/",,,; 
	"http://54.232.215.246/CCO/WEbSERVICECCO.ASMX")

::Init()
::oWSvin:SoapRecv( WSAdvValue( oXmlRet,"_GETVINSRESPONSE:_VIN","ArrayOfEcom",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfEcom

WSSTRUCT WebServiceCCO_ArrayOfEcom
	WSDATA   oWSEcom                   AS WebServiceCCO_Ecom OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WebServiceCCO_ArrayOfEcom
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WebServiceCCO_ArrayOfEcom
	::oWSEcom              := {} // Array Of  WebServiceCCO_ECOM():New()
Return

WSMETHOD CLONE WSCLIENT WebServiceCCO_ArrayOfEcom
	Local oClone := WebServiceCCO_ArrayOfEcom():NEW()
	oClone:oWSEcom := NIL
	If ::oWSEcom <> NIL 
		oClone:oWSEcom := {}
		aEval( ::oWSEcom , { |x| aadd( oClone:oWSEcom , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WebServiceCCO_ArrayOfEcom
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ECOM","Ecom",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSEcom , WebServiceCCO_Ecom():New() )
			::oWSEcom[len(::oWSEcom)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure Ecom

WSSTRUCT WebServiceCCO_Ecom
	WSDATA   nId                       AS int
	WSDATA   cDatadeMovimentos         AS dateTime
	WSDATA   cVIN                      AS string OPTIONAL
	WSDATA   cPatios                   AS string OPTIONAL
	WSDATA   cTransacoes               AS string OPTIONAL
	WSDATA   cMercados                 AS string OPTIONAL
	WSDATA   cOrigem                   AS string OPTIONAL
	WSDATA   cMarca                    AS string OPTIONAL
	WSDATA   cModos                    AS string OPTIONAL
	WSDATA   cCores                    AS string OPTIONAL
	WSDATA   cVersao                   AS string OPTIONAL
	WSDATA   cTransporte               AS string OPTIONAL
	WSDATA   cDataLiberacao            AS string OPTIONAL
	WSDATA   cData1_Recepcao           AS string OPTIONAL
	WSDATA   cPatio1_Recepcao          AS string OPTIONAL
	WSDATA   cDestino                  AS string OPTIONAL
	WSDATA   dDataImportacao           AS date
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WebServiceCCO_Ecom
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WebServiceCCO_Ecom
Return

WSMETHOD CLONE WSCLIENT WebServiceCCO_Ecom
	Local oClone := WebServiceCCO_Ecom():NEW()
	oClone:nId                  := ::nId
	oClone:cDatadeMovimentos    := ::cDatadeMovimentos
	oClone:cVIN                 := ::cVIN
	oClone:cPatios              := ::cPatios
	oClone:cTransacoes          := ::cTransacoes
	oClone:cMercados            := ::cMercados
	oClone:cOrigem              := ::cOrigem
	oClone:cMarca               := ::cMarca
	oClone:cModos               := ::cModos
	oClone:cCores               := ::cCores
	oClone:cVersao              := ::cVersao
	oClone:cTransporte          := ::cTransporte
	oClone:cDataLiberacao       := ::cDataLiberacao
	oClone:cData1_Recepcao      := ::cData1_Recepcao
	oClone:cPatio1_Recepcao     := ::cPatio1_Recepcao
	oClone:cDestino             := ::cDestino
	oClone:dDataImportacao      := ::dDataImportacao
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WebServiceCCO_Ecom
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::nId                :=  WSAdvValue( oResponse,"_ID","int",NIL,"Property nId as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::cDatadeMovimentos  :=  WSAdvValue( oResponse,"_DATADEMOVIMENTOS","dateTime",NIL,"Property cDatadeMovimentos as s:dateTime on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cVIN               :=  WSAdvValue( oResponse,"_VIN","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPatios            :=  WSAdvValue( oResponse,"_PATIOS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTransacoes        :=  WSAdvValue( oResponse,"_TRANSACOES","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMercados          :=  WSAdvValue( oResponse,"_MERCADOS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cOrigem            :=  WSAdvValue( oResponse,"_ORIGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cMarca             :=  WSAdvValue( oResponse,"_MARCA","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cModos             :=  WSAdvValue( oResponse,"_MODOS","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCores             :=  WSAdvValue( oResponse,"_CORES","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cVersao            :=  WSAdvValue( oResponse,"_VERSAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cTransporte        :=  WSAdvValue( oResponse,"_TRANSPORTE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDataLiberacao     :=  WSAdvValue( oResponse,"_DATALIBERACAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cData1_Recepcao    :=  WSAdvValue( oResponse,"_DATA1_RECEPCAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cPatio1_Recepcao   :=  WSAdvValue( oResponse,"_PATIO1_RECEPCAO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDestino           :=  WSAdvValue( oResponse,"_DESTINO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::dDataImportacao    :=  WSAdvValue( oResponse,"_DATAIMPORTACAO","date",NIL,"Property dDataImportacao as s:date on SOAP Response not found.",NIL,"D",NIL,NIL) 
Return


USER FUNCTION TSTWSPCO()
Local _oVIN := Nil

_oVIN := WSWebServiceCCO():New()
_oVIN:GetVins()

Return