#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://10.63.249.78:8083/ws/GEFCO.apw?WSDL
Gerado em        03/13/17 16:54:46
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _KPVBSOD ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSGEFCO
------------------------------------------------------------------------------- */

WSCLIENT WSGEFCO

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CONSULTACLI

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCPARAMCLI                AS string
	WSDATA   cCCHAVE                   AS string
	WSDATA   cCLOGIN                   AS string
	WSDATA   oWSCONSULTACLIRESULT      AS GEFCO_ARRAYOFSTRING

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSGEFCO
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20150410] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSGEFCO
	::oWSCONSULTACLIRESULT := GEFCO_ARRAYOFSTRING():New()
Return

WSMETHOD RESET WSCLIENT WSGEFCO
	::cCPARAMCLI         := NIL 
	::cCCHAVE            := NIL 
	::cCLOGIN            := NIL 
	::oWSCONSULTACLIRESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSGEFCO
Local oClone := WSGEFCO():New()
	oClone:_URL          := ::_URL 
	oClone:cCPARAMCLI    := ::cCPARAMCLI
	oClone:cCCHAVE       := ::cCCHAVE
	oClone:cCLOGIN       := ::cCLOGIN
	oClone:oWSCONSULTACLIRESULT :=  IIF(::oWSCONSULTACLIRESULT = NIL , NIL ,::oWSCONSULTACLIRESULT:Clone() )
Return oClone

// WSDL Method CONSULTACLI of Service WSGEFCO

WSMETHOD CONSULTACLI WSSEND cCPARAMCLI,cCCHAVE,cCLOGIN WSRECEIVE oWSCONSULTACLIRESULT WSCLIENT WSGEFCO
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CONSULTACLI xmlns="http://10.63.249.78:8083/">'
cSoap += WSSoapValue("CPARAMCLI", ::cCPARAMCLI, cCPARAMCLI , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CCHAVE", ::cCCHAVE, cCCHAVE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CLOGIN", ::cCLOGIN, cCLOGIN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CONSULTACLI>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://10.63.249.78:8083/CONSULTACLI",; 
	"DOCUMENT","http://10.63.249.78:8083/",,"1.031217",; 
	"http://10.63.249.78:8083/ws/GEFCO.apw")

::Init()
::oWSCONSULTACLIRESULT:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTACLIRESPONSE:_CONSULTACLIRESULT","ARRAYOFSTRING",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ARRAYOFSTRING

WSSTRUCT GEFCO_ARRAYOFSTRING
	WSDATA   cSTRING                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT GEFCO_ARRAYOFSTRING
	::Init()
Return Self

WSMETHOD INIT WSCLIENT GEFCO_ARRAYOFSTRING
	::cSTRING              := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT GEFCO_ARRAYOFSTRING
	Local oClone := GEFCO_ARRAYOFSTRING():NEW()
	oClone:cSTRING              := IIf(::cSTRING <> NIL , aClone(::cSTRING) , NIL )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT GEFCO_ARRAYOFSTRING
	Local oNodes1 :=  WSAdvValue( oResponse,"_STRING","string",{},NIL,.T.,"S",NIL,"a") 
	::Init()
	If oResponse = NIL ; Return ; Endif 
	aEval(oNodes1 , { |x| aadd(::cSTRING ,  x:TEXT  ) } )
Return

//-----------------------------------
User Function GEFWSCli01()
Local oWSClient 
Local oCli
Local aCli := Array(6)

SET DATE BRITISH
SET CENTURY ON 
SET EPOCH TO 1960
 
// Cria a instância da classe Client do WebService da Gefco
oWSClient := WSGEFCO():New()

oWSClient:CCPARAMCLI 	:= '03094658000106'
oWSClient:CCCHAVE		:= 'C6E1BF9A-C664-48BC-9FAA-17D3288B21D1'
oWSClient:CCLOGIN		:= 'gefco.logistica'

oCli := oWSClient:ConsultaCli()

// If Upper(oWSClient:c_Status) == "CLIENTE LOCALIZADO"
	// For x:=1 to Len(oWSClient:owsconsultacliresult:owsregistros:owscliente)
	//	CONOUT('CLIENTE ==> ' + StrZero(x,3))
	/* usando registros
		aCli[1] := oWSClient:owsconsultacliresult:owsregistros:owscliente[1]:CNOME
		aCli[2] := oWSClient:owsconsultacliresult:owsregistros:owscliente[1]:CENDERECO 
		aCli[3] := oWSClient:owsconsultacliresult:owsregistros:owscliente[1]:CBAIRRO
		aCli[4] := oWSClient:owsconsultacliresult:owsregistros:owscliente[1]:CESTADO
		aCli[5] := oWSClient:owsconsultacliresult:owsregistros:owscliente[1]:CUF
	*/

		aCli[1] := oWSClient:owsconsultacliresult:cstring[1]
		aCli[2] := oWSClient:owsconsultacliresult:cstring[2] 
		aCli[3] := oWSClient:owsconsultacliresult:cstring[3]
		aCli[4] := oWSClient:owsconsultacliresult:cstring[4]
		aCli[5] := oWSClient:owsconsultacliresult:cstring[5]
		aCli[6] := oWSClient:owsconsultacliresult:cstring[6]		

		CONOUT(aCli[1])
		CONOUT(aCli[2])
		CONOUT(aCli[3])
		CONOUT(aCli[4])
		CONOUT(aCli[5])
		
		Aviso('Cliente', 'Msg.: ' + aCli[1] + CRLF +;
						 'Nome: ' + aCli[2] + CRLF +;
		 				 'End.: ' + aCli[3] + CRLF +;
		 				 'Bai.: ' + aCli[4] + CRLF +;
		 				 'Est.: ' + aCli[5] + CRLF +;
		 				 'UF  : ' + aCli[6] + CRLF  , {'Ok'}, 3 )				
// Else
		// Aviso('Cliente', 'Msg.: ' + oWSClient:_Status, {'Ok'} )
// EndIf
		 				 
// Next x

// teste
Return



