#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://www.vitgbrasil.com.br/vedi/vitgrfqws?wsdl
Gerado em        01/30/17 11:23:08
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _SJUGQSG ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSRFQImporterService
------------------------------------------------------------------------------- */

WSCLIENT WSRFQImporterService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD importRfQInfo
	WSMETHOD importRfQInfoArray
	WSMETHOD importRfQAuthInfoArray
	WSMETHOD exportRfQInfo

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   norgCode                  AS int
	WSDATA   creferenceNumber          AS string
	WSDATA   ctripNumber               AS string
	WSDATA   ccreationDate             AS dateTime
	WSDATA   cvehicleType              AS string
	WSDATA   ctotalFee                 AS string
	WSDATA   ckmTotal                  AS string
	WSDATA   ccnpjSupplierCollection   AS string
	WSDATA   ccollectionAddress        AS string
	WSDATA   ccollectionOutDate        AS dateTime
	WSDATA   ctargetAddress            AS string
	WSDATA   cexitFee                  AS string
	WSDATA   creturn                   AS string
	WSDATA   cuserName                 AS string
	WSDATA   cpassword                 AS string
	WSDATA   cmessage                  AS string
	WSDATA   ctransporterCNPJ          AS string
	WSDATA   cdriverCPF                AS string
	WSDATA   clicensePlate1            AS string
	WSDATA   clicensePlate2            AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSRFQImporterService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20161027] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSRFQImporterService
Return

WSMETHOD RESET WSCLIENT WSRFQImporterService
	::norgCode           := NIL 
	::creferenceNumber   := NIL 
	::ctripNumber        := NIL 
	::ccreationDate      := NIL 
	::cvehicleType       := NIL 
	::ctotalFee          := NIL 
	::ckmTotal           := NIL 
	::ccnpjSupplierCollection := NIL 
	::ccollectionAddress := NIL 
	::ccollectionOutDate := NIL 
	::ctargetAddress     := NIL 
	::cexitFee           := NIL 
	::creturn            := NIL 
	::cuserName          := NIL 
	::cpassword          := NIL 
	::cmessage           := NIL 
	::ctransporterCNPJ   := NIL 
	::cdriverCPF         := NIL 
	::clicensePlate1     := NIL 
	::clicensePlate2     := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSRFQImporterService
Local oClone := WSRFQImporterService():New()
	oClone:_URL          := ::_URL 
	oClone:norgCode      := ::norgCode
	oClone:creferenceNumber := ::creferenceNumber
	oClone:ctripNumber   := ::ctripNumber
	oClone:ccreationDate := ::ccreationDate
	oClone:cvehicleType  := ::cvehicleType
	oClone:ctotalFee     := ::ctotalFee
	oClone:ckmTotal      := ::ckmTotal
	oClone:ccnpjSupplierCollection := ::ccnpjSupplierCollection
	oClone:ccollectionAddress := ::ccollectionAddress
	oClone:ccollectionOutDate := ::ccollectionOutDate
	oClone:ctargetAddress := ::ctargetAddress
	oClone:cexitFee      := ::cexitFee
	oClone:creturn       := ::creturn
	oClone:cuserName     := ::cuserName
	oClone:cpassword     := ::cpassword
	oClone:cmessage      := ::cmessage
	oClone:ctransporterCNPJ := ::ctransporterCNPJ
	oClone:cdriverCPF    := ::cdriverCPF
	oClone:clicensePlate1 := ::clicensePlate1
	oClone:clicensePlate2 := ::clicensePlate2
Return oClone

// WSDL Method importRfQInfo of Service WSRFQImporterService

WSMETHOD importRfQInfo WSSEND norgCode,creferenceNumber,ctripNumber,ccreationDate,cvehicleType,ctotalFee,ckmTotal,ccnpjSupplierCollection,ccollectionAddress,ccollectionOutDate,ctargetAddress,cexitFee WSRECEIVE creturn WSCLIENT WSRFQImporterService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<importRfQInfo xmlns="http://ws.vitgbrasil.com/">'
cSoap += WSSoapValue("orgCode", ::norgCode, norgCode , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("referenceNumber", ::creferenceNumber, creferenceNumber , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("tripNumber", ::ctripNumber, ctripNumber , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("creationDate", ::ccreationDate, ccreationDate , "dateTime", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("vehicleType", ::cvehicleType, cvehicleType , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("totalFee", ::ctotalFee, ctotalFee , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("kmTotal", ::ckmTotal, ckmTotal , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("cnpjSupplierCollection", ::ccnpjSupplierCollection, ccnpjSupplierCollection , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("collectionAddress", ::ccollectionAddress, ccollectionAddress , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("collectionOutDate", ::ccollectionOutDate, ccollectionOutDate , "dateTime", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("targetAddress", ::ctargetAddress, ctargetAddress , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("exitFee", ::cexitFee, cexitFee , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</importRfQInfo>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.vitgbrasil.com/",,,; 
	"http://www.vitgbrasil.com.br:80/vedi/vitgrfqws")

::Init()
::creturn            :=  WSAdvValue( oXmlRet,"_IMPORTRFQINFORESPONSE:_RETURN:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method importRfQInfoArray of Service WSRFQImporterService

WSMETHOD importRfQInfoArray WSSEND norgCode,creferenceNumber,ctripNumber,ccreationDate,cvehicleType,ctotalFee,ckmTotal,ccnpjSupplierCollection,ccollectionAddress,ccollectionOutDate,ctargetAddress,cexitFee WSRECEIVE creturn WSCLIENT WSRFQImporterService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<importRfQInfoArray xmlns="http://ws.vitgbrasil.com/">'
cSoap += WSSoapValue("orgCode", ::norgCode, norgCode , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("referenceNumber", ::creferenceNumber, creferenceNumber , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("tripNumber", ::ctripNumber, ctripNumber , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("creationDate", ::ccreationDate, ccreationDate , "dateTime", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("vehicleType", ::cvehicleType, cvehicleType , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("totalFee", ::ctotalFee, ctotalFee , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("kmTotal", ::ckmTotal, ckmTotal , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("cnpjSupplierCollection", ::ccnpjSupplierCollection, ccnpjSupplierCollection , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("collectionAddress", ::ccollectionAddress, ccollectionAddress , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("collectionOutDate", ::ccollectionOutDate, ccollectionOutDate , "dateTime", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("targetAddress", ::ctargetAddress, ctargetAddress , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("exitFee", ::cexitFee, cexitFee , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</importRfQInfoArray>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.vitgbrasil.com/",,,; 
	"http://www.vitgbrasil.com.br:80/vedi/vitgrfqws")

::Init()
::creturn            :=  WSAdvValue( oXmlRet,"_IMPORTRFQINFOARRAYRESPONSE:_RETURN:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method importRfQAuthInfoArray of Service WSRFQImporterService

WSMETHOD importRfQAuthInfoArray WSSEND cuserName,cpassword,norgCode,creferenceNumber,ctripNumber,ccreationDate,cvehicleType,ctotalFee,ckmTotal,ccnpjSupplierCollection,ccollectionAddress,ccollectionOutDate,ctargetAddress,cexitFee WSRECEIVE creturn WSCLIENT WSRFQImporterService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<importRfQAuthInfoArray xmlns="http://ws.vitgbrasil.com/">'
cSoap += WSSoapValue("userName", ::cuserName, cuserName , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("orgCode", ::norgCode, norgCode , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("referenceNumber", ::creferenceNumber, creferenceNumber , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("tripNumber", ::ctripNumber, ctripNumber , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("creationDate", ::ccreationDate, ccreationDate , "dateTime", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("vehicleType", ::cvehicleType, cvehicleType , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("totalFee", ::ctotalFee, ctotalFee , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("kmTotal", ::ckmTotal, ckmTotal , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("cnpjSupplierCollection", ::ccnpjSupplierCollection, ccnpjSupplierCollection , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("collectionAddress", ::ccollectionAddress, ccollectionAddress , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("collectionOutDate", ::ccollectionOutDate, ccollectionOutDate , "dateTime", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("targetAddress", ::ctargetAddress, ctargetAddress , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("exitFee", ::cexitFee, cexitFee , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</importRfQAuthInfoArray>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.vitgbrasil.com/",,,; 
	"http://www.vitgbrasil.com.br:80/vedi/vitgrfqws")

::Init()
::creturn            :=  WSAdvValue( oXmlRet,"_IMPORTRFQAUTHINFOARRAYRESPONSE:_RETURN:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method exportRfQInfo of Service WSRFQImporterService

WSMETHOD exportRfQInfo WSSEND norgCode,creferenceNumber,ctripNumber WSRECEIVE cmessage,ctransporterCNPJ,cdriverCPF,clicensePlate1,clicensePlate2 WSCLIENT WSRFQImporterService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<exportRfQInfo xmlns="http://ws.vitgbrasil.com/">'
cSoap += WSSoapValue("orgCode", ::norgCode, norgCode , "int", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("referenceNumber", ::creferenceNumber, creferenceNumber , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("tripNumber", ::ctripNumber, ctripNumber , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</exportRfQInfo>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://ws.vitgbrasil.com/",,,; 
	"http://www.vitgbrasil.com.br:80/vedi/vitgrfqws")

::Init()
::cmessage           :=  WSAdvValue( oXmlRet,"_EXPORTRFQINFORESPONSE:_MESSAGE:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 
::ctransporterCNPJ   :=  WSAdvValue( oXmlRet,"_EXPORTRFQINFORESPONSE:_TRANSPORTERCNPJ:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 
::cdriverCPF         :=  WSAdvValue( oXmlRet,"_EXPORTRFQINFORESPONSE:_DRIVERCPF:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 
::clicensePlate1     :=  WSAdvValue( oXmlRet,"_EXPORTRFQINFORESPONSE:_LICENSEPLATE1:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 
::clicensePlate2     :=  WSAdvValue( oXmlRet,"_EXPORTRFQINFORESPONSE:_LICENSEPLATE2:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


User Function GEFITGWS
Local _oObjITG := Nil
Local _oWSAux  := Nil

_oObjITG := WSRFQImporterService():New()

_oObjITG:cuserName 					:= 'valeria.vasconcelos'
_oObjITG:cpassword 					:= '4h8dk983sxy987shkl85ffsw'
_oObjITG:norgCode  					:= '6014'
_oObjITG:creferenceNumber			:= 'TRANSPORT'
_oObjITG:ctripNumber					:= '123456'
_oObjITG:ccreationDate				:= '2016-12-28T15:30:00'
_oObjITG:cvehicleType				:= 'Carreta Sider'
_oObjITG:ctotalFee					:= 71.99
_oObjITG:ckmTotal						:= 561
_oObjITG:ccnpjSupplierCollection	:= '02.042.860/0001-13'
_oObjITG:ccollectionAddress			:= 'AV CONTORNO, 3455-GALPAO 8, PAULO CAMILO, BETIM, MG'
_oObjITG:ccollectionOutDate			:= '2016-12-28T16:30:00'
_oObjITG:ctargetAddress				:= 'AV CONTORNO, 3455-GALPAO 8, PAULO CAMILO, BETIM, MG'
_oObjITG:cexitFee						:= 26.60

_oWSAux  := _oObjITG:importRfQAuthInfoArray()

Alert(_oObjITG:cReturn)

Return Nil
