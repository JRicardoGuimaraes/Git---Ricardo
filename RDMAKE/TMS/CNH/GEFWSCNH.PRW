#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH" 

/* ===============================================================================
WSDL Location    http://www.cnhlog.com.br/sgi/integracao-painel.asmx?WSDL
                 http://www.cnhlog.com.br/sgi-iveco/integracao-painel.asmx
                 Gerado em        08/30/14 10:49:02
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _LJQEJVQ ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSintegracao_painel
------------------------------------------------------------------------------- */

WSCLIENT WSintegracao_painel

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD interface050
	WSMETHOD interface055
	WSMETHOD interface060
	WSMETHOD interface101
	WSMETHOD interface201
	WSMETHOD interface301
	WSMETHOD interface401
	WSMETHOD interface501
	WSMETHOD interface601
	WSMETHOD interface701
	WSMETHOD interface801
	WSMETHOD interface901
	WSMETHOD SalvarXML
	WSMETHOD ReceberXml
	WSMETHOD UpLoadGNT

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cpalavraPasse             AS string
	WSDATA   ndiaPlanejamento          AS int
	WSDATA   nmesPlanejamento          AS int
	WSDATA   nanoPlanejamento          AS int
	WSDATA   oWSinterface050Result     AS integracao_painel_ArrayOfInt
	WSDATA   cinterface055Result       AS string
	WSDATA   nnumeroPlano              AS int
	WSDATA   oWSinterface060Result     AS SCHEMA
	WSDATA   oWSdsDados                AS SCHEMA
	WSDATA   linterface101Result       AS boolean
	WSDATA   linterface201Result       AS boolean
	WSDATA   linterface301Result       AS boolean
	WSDATA   linterface401Result       AS boolean
	WSDATA   linterface501Result       AS boolean
	WSDATA   oWSdsDadosCTRC            AS SCHEMA
	WSDATA   oWSdsDadosNFs             AS SCHEMA
	WSDATA   linterface601Result       AS boolean
	WSDATA   nnroPlano                 AS int
	WSDATA   cinterface701Result       AS string
	WSDATA   ccnpjOrigem               AS string
	WSDATA   cdataColeta               AS dateTime
	WSDATA   choraColeta               AS string
	WSDATA   ctipoVeiculo              AS string
	WSDATA   cdestino                  AS string
	WSDATA   csolicitacaoOrigem        AS string
	WSDATA   linterface801Result       AS boolean
	WSDATA   oWSinterface901Result     AS SCHEMA
	WSDATA   oWSxmlDoc                 AS SCHEMA
	WSDATA   cnomeArquivo              AS string
	WSDATA   lReceberXmlResult         AS boolean
	WSDATA   cArquivo                  AS string
	WSDATA   oWSUpLoadGNTResult        AS SCHEMA

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSintegracao_painel
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.121227P-20131106] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSintegracao_painel
	::oWSinterface050Result := integracao_painel_ARRAYOFINT():New()
	::oWSinterface060Result := NIL 
	::oWSdsDados         := NIL 
	::oWSdsDadosCTRC     := NIL 
	::oWSdsDadosNFs      := NIL 
	::oWSinterface901Result := NIL 
	::oWSxmlDoc          := NIL 
	::oWSUpLoadGNTResult := NIL 
Return

WSMETHOD RESET WSCLIENT WSintegracao_painel
	::cpalavraPasse      := NIL 
	::ndiaPlanejamento   := NIL 
	::nmesPlanejamento   := NIL 
	::nanoPlanejamento   := NIL 
	::oWSinterface050Result := NIL 
	::cinterface055Result := NIL 
	::nnumeroPlano       := NIL 
	::oWSinterface060Result := NIL 
	::oWSdsDados         := NIL 
	::linterface101Result := NIL 
	::linterface201Result := NIL 
	::linterface301Result := NIL 
	::linterface401Result := NIL 
	::linterface501Result := NIL 
	::oWSdsDadosCTRC     := NIL 
	::oWSdsDadosNFs      := NIL 
	::linterface601Result := NIL 
	::nnroPlano          := NIL 
	::cinterface701Result := NIL 
	::ccnpjOrigem        := NIL 
	::cdataColeta        := NIL 
	::choraColeta        := NIL 
	::ctipoVeiculo       := NIL 
	::cdestino           := NIL 
	::csolicitacaoOrigem := NIL 
	::linterface801Result := NIL 
	::oWSinterface901Result := NIL 
	::oWSxmlDoc          := NIL 
	::cnomeArquivo       := NIL 
	::lReceberXmlResult  := NIL 
	::cArquivo           := NIL 
	::oWSUpLoadGNTResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSintegracao_painel
Local oClone := WSintegracao_painel():New()
	oClone:_URL          := ::_URL 
	oClone:cpalavraPasse := ::cpalavraPasse
	oClone:ndiaPlanejamento := ::ndiaPlanejamento
	oClone:nmesPlanejamento := ::nmesPlanejamento
	oClone:nanoPlanejamento := ::nanoPlanejamento
	oClone:oWSinterface050Result :=  IIF(::oWSinterface050Result = NIL , NIL ,::oWSinterface050Result:Clone() )
	oClone:cinterface055Result := ::cinterface055Result
	oClone:nnumeroPlano  := ::nnumeroPlano
	oClone:linterface101Result := ::linterface101Result
	oClone:linterface201Result := ::linterface201Result
	oClone:linterface301Result := ::linterface301Result
	oClone:linterface401Result := ::linterface401Result
	oClone:linterface501Result := ::linterface501Result
	oClone:linterface601Result := ::linterface601Result
	oClone:nnroPlano     := ::nnroPlano
	oClone:cinterface701Result := ::cinterface701Result
	oClone:ccnpjOrigem   := ::ccnpjOrigem
	oClone:cdataColeta   := ::cdataColeta
	oClone:choraColeta   := ::choraColeta
	oClone:ctipoVeiculo  := ::ctipoVeiculo
	oClone:cdestino      := ::cdestino
	oClone:csolicitacaoOrigem := ::csolicitacaoOrigem
	oClone:linterface801Result := ::linterface801Result
	oClone:cnomeArquivo  := ::cnomeArquivo
	oClone:lReceberXmlResult := ::lReceberXmlResult
	oClone:cArquivo      := ::cArquivo
Return oClone

// WSDL Method interface050 of Service WSintegracao_painel

WSMETHOD interface050 WSSEND cpalavraPasse,ndiaPlanejamento,nmesPlanejamento,nanoPlanejamento WSRECEIVE oWSinterface050Result WSCLIENT WSintegracao_painel
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<interface050 xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("palavraPasse", ::cpalavraPasse, cpalavraPasse , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("diaPlanejamento", ::ndiaPlanejamento, ndiaPlanejamento , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("mesPlanejamento", ::nmesPlanejamento, nmesPlanejamento , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("anoPlanejamento", ::nanoPlanejamento, nanoPlanejamento , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += "</interface050>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface050",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi/integracao-painel.asmx")

::Init()
::oWSinterface050Result:SoapRecv( WSAdvValue( oXmlRet,"_INTERFACE050RESPONSE:_INTERFACE050RESULT","ArrayOfInt",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method interface055 of Service WSintegracao_painel

WSMETHOD interface055 WSSEND cpalavraPasse,ndiaPlanejamento,nmesPlanejamento,nanoPlanejamento WSRECEIVE cinterface055Result WSCLIENT WSintegracao_painel
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<interface055 xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("palavraPasse", ::cpalavraPasse, cpalavraPasse , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("diaPlanejamento", ::ndiaPlanejamento, ndiaPlanejamento , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("mesPlanejamento", ::nmesPlanejamento, nmesPlanejamento , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("anoPlanejamento", ::nanoPlanejamento, nanoPlanejamento , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += "</interface055>"

If GetMv('ES_CNHSEQ') == '1'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface055",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi/integracao-painel.asmx" )
Else
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface055",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi-iveco/integracao-painel.asmx" )
EndIf

::Init()
::cinterface055Result :=  WSAdvValue( oXmlRet,"_INTERFACE055RESPONSE:_INTERFACE055RESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method interface060 of Service WSintegracao_painel

WSMETHOD interface060 WSSEND cpalavraPasse,nnumeroPlano WSRECEIVE oWSinterface060Result WSCLIENT WSintegracao_painel
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<interface060 xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("palavraPasse", ::cpalavraPasse, cpalavraPasse , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("numeroPlano", ::nnumeroPlano, nnumeroPlano , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += "</interface060>"

If GetMv('ES_CNHSEQ') == '1'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface060",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi/integracao-painel.asmx" )
Else
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface060",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi-iveco/integracao-painel.asmx" )
EndIf

::Init()
::oWSinterface060Result :=  WSAdvValue( oXmlRet,"_INTERFACE060RESPONSE","SCHEMA",NIL,NIL,NIL,"O",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method interface101 of Service WSintegracao_painel

WSMETHOD interface101 WSSEND cpalavraPasse,oWSdsDados WSRECEIVE linterface101Result WSCLIENT WSintegracao_painel
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<interface101 xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("palavraPasse", ::cpalavraPasse, cpalavraPasse , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("dsDados", ::oWSdsDados, oWSdsDados , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoap += "</interface101>"

// ---	Plano CNH
If AllTrim(DF0->DF0_TIPO) == '1'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface101",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi/integracao-painel.asmx")  
// ---	Plano IVECO
ElseIf AllTrim(DF0->DF0_TIPO) == '2'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface101",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi-iveco/integracao-painel.asmx")
EndIf

::Init()
::linterface101Result :=  WSAdvValue( oXmlRet,"_INTERFACE101RESPONSE:_INTERFACE101RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method interface201 of Service WSintegracao_painel

WSMETHOD interface201 WSSEND cpalavraPasse,oWSdsDados WSRECEIVE linterface201Result WSCLIENT WSintegracao_painel
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<interface201 xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("palavraPasse", ::cpalavraPasse, cpalavraPasse , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("dsDados", ::oWSdsDados, oWSdsDados , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoap += "</interface201>"

// ---	Plano CNH
If AllTrim(DF0->DF0_TIPO) == '1'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface201",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi/integracao-painel.asmx")
// ---	Plano IVECO
ElseIf AllTrim(DF0->DF0_TIPO) == '2'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface201",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi-iveco/integracao-painel.asmx")
EndIf

::Init()
::linterface201Result :=  WSAdvValue( oXmlRet,"_INTERFACE201RESPONSE:_INTERFACE201RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method interface301 of Service WSintegracao_painel

WSMETHOD interface301 WSSEND cpalavraPasse,oWSdsDados WSRECEIVE linterface301Result WSCLIENT WSintegracao_painel
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<interface301 xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("palavraPasse", ::cpalavraPasse, cpalavraPasse , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("dsDados", ::oWSdsDados, oWSdsDados , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoap += "</interface301>"

// ---	Plano CNH
If AllTrim(DF0->DF0_TIPO) == '1'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface301",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi/integracao-painel.asmx")
// ---	Plano IVECO
ElseIf AllTrim(DF0->DF0_TIPO) == '2'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface301",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi-iveco/integracao-painel.asmx")   
EndIf 

::Init()
::linterface301Result :=  WSAdvValue( oXmlRet,"_INTERFACE301RESPONSE:_INTERFACE301RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method interface401 of Service WSintegracao_painel

WSMETHOD interface401 WSSEND cpalavraPasse,oWSdsDados WSRECEIVE linterface401Result WSCLIENT WSintegracao_painel
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<interface401 xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("palavraPasse", ::cpalavraPasse, cpalavraPasse , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("dsDados", ::oWSdsDados, oWSdsDados , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoap += "</interface401>"

// ---	Plano CNH
If AllTrim(DF0->DF0_TIPO) == '1'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface401",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi/integracao-painel.asmx")
// ---	Plano IVECO
ElseIf AllTrim(DF0->DF0_TIPO) == '2'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface401",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi-iveco/integracao-painel.asmx")
EndIf

::Init()
::linterface401Result :=  WSAdvValue( oXmlRet,"_INTERFACE401RESPONSE:_INTERFACE401RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method interface501 of Service WSintegracao_painel

WSMETHOD interface501 WSSEND cpalavraPasse,oWSdsDados WSRECEIVE linterface501Result WSCLIENT WSintegracao_painel
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<interface501 xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("palavraPasse", ::cpalavraPasse, cpalavraPasse , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("dsDados", ::oWSdsDados, oWSdsDados , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoap += "</interface501>"

// ---	Plano CNH
If AllTrim(DF0->DF0_TIPO) == '1'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface501",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi/integracao-painel.asmx")
// ---	Plano IVECO
ElseIf AllTrim(DF0->DF0_TIPO) == '2'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface501",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi-iveco/integracao-painel.asmx")
EndIf

::Init()
::linterface501Result :=  WSAdvValue( oXmlRet,"_INTERFACE501RESPONSE:_INTERFACE501RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method interface601 of Service WSintegracao_painel

WSMETHOD interface601 WSSEND cpalavraPasse,oWSdsDadosCTRC,oWSdsDadosNFs WSRECEIVE linterface601Result WSCLIENT WSintegracao_painel
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<interface601 xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("palavraPasse", ::cpalavraPasse, cpalavraPasse , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("dsDadosCTRC", ::oWSdsDadosCTRC, oWSdsDadosCTRC , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("dsDadosNFs", ::oWSdsDadosNFs, oWSdsDadosNFs , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoap += "</interface601>"

// ---	Plano CNH
If AllTrim(DF0->DF0_TIPO) == '1'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface601",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi/integracao-painel.asmx")
// ---	Plano IVECO
ElseIf AllTrim(DF0->DF0_TIPO) == '2'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface601",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi-iveco/integracao-painel.asmx")
EndIf

::Init()
::linterface601Result :=  WSAdvValue( oXmlRet,"_INTERFACE601RESPONSE:_INTERFACE601RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method interface701 of Service WSintegracao_painel

WSMETHOD interface701 WSSEND cpalavraPasse,nnroPlano WSRECEIVE cinterface701Result WSCLIENT WSintegracao_painel
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<interface701 xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("palavraPasse", ::cpalavraPasse, cpalavraPasse , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("nroPlano", ::nnroPlano, nnroPlano , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += "</interface701>"

// ---	Plano CNH
If AllTrim(DF0->DF0_TIPO) == '1'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface701",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi/integracao-painel.asmx")
// ---	Plano IVECO
ElseIf AllTrim(DF0->DF0_TIPO) == '2'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface701",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi-iveco/integracao-painel.asmx")
EndIf

::Init()
::cinterface701Result :=  WSAdvValue( oXmlRet,"_INTERFACE701RESPONSE:_INTERFACE701RESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method interface801 of Service WSintegracao_painel

WSMETHOD interface801 WSSEND cpalavraPasse,ccnpjOrigem,cdataColeta,choraColeta,ctipoVeiculo,cdestino,csolicitacaoOrigem WSRECEIVE linterface801Result WSCLIENT WSintegracao_painel
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<interface801 xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("palavraPasse", ::cpalavraPasse, cpalavraPasse , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("cnpjOrigem", ::ccnpjOrigem, ccnpjOrigem , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("dataColeta", ::cdataColeta, cdataColeta , "dateTime", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("horaColeta", ::choraColeta, choraColeta , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("tipoVeiculo", ::ctipoVeiculo, ctipoVeiculo , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("destino", ::cdestino, cdestino , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("solicitacaoOrigem", ::csolicitacaoOrigem, csolicitacaoOrigem , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</interface801>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface801",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi/integracao-painel.asmx")

::Init()
::linterface801Result :=  WSAdvValue( oXmlRet,"_INTERFACE801RESPONSE:_INTERFACE801RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method interface901 of Service WSintegracao_painel

WSMETHOD interface901 WSSEND cpalavraPasse,nnroPlano WSRECEIVE oWSinterface901Result WSCLIENT WSintegracao_painel
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<interface901 xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("palavraPasse", ::cpalavraPasse, cpalavraPasse , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("nroPlano", ::nnroPlano, nnroPlano , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += "</interface901>"

// ---	Plano CNH
If AllTrim(DF0->DF0_TIPO) == '1'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface901",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi/integracao-painel.asmx")
// ---	Plano IVECO
ElseIf AllTrim(DF0->DF0_TIPO) == '2'
	oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/interface901",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi-iveco/integracao-painel.asmx")
EndIf

::Init()
::oWSinterface901Result :=  WSAdvValue( oXmlRet,"_INTERFACE901RESPONSE","SCHEMA",NIL,NIL,NIL,"O",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SalvarXML of Service WSintegracao_painel

WSMETHOD SalvarXML WSSEND oWSxmlDoc,cnroPlano WSRECEIVE NULLPARAM WSCLIENT WSintegracao_painel
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SalvarXML xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("xmlDoc", ::oWSxmlDoc, oWSxmlDoc , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("nroPlano", ::cnroPlano, cnroPlano , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</SalvarXML>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/SalvarXML",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi/integracao-painel.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ReceberXml of Service WSintegracao_painel

WSMETHOD ReceberXml WSSEND oWSxmlDoc,cnomeArquivo WSRECEIVE lReceberXmlResult WSCLIENT WSintegracao_painel
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ReceberXml xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("xmlDoc", ::oWSxmlDoc, oWSxmlDoc , "SCHEMA", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("nomeArquivo", ::cnomeArquivo, cnomeArquivo , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ReceberXml>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ReceberXml",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi/integracao-painel.asmx")

::Init()
::lReceberXmlResult  :=  WSAdvValue( oXmlRet,"_RECEBERXMLRESPONSE:_RECEBERXMLRESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpLoadGNT of Service WSintegracao_painel

WSMETHOD UpLoadGNT WSSEND cpalavraPasse,cArquivo WSRECEIVE oWSUpLoadGNTResult WSCLIENT WSintegracao_painel
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpLoadGNT xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("palavraPasse", ::cpalavraPasse, cpalavraPasse , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("Arquivo", ::cArquivo, cArquivo , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</UpLoadGNT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/UpLoadGNT",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cnhlog.com.br/sgi/integracao-painel.asmx")

::Init()
::oWSUpLoadGNTResult :=  WSAdvValue( oXmlRet,"_UPLOADGNTRESPONSE","SCHEMA",NIL,NIL,NIL,"O",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfInt

WSSTRUCT integracao_painel_ArrayOfInt
	WSDATA   nint                      AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT integracao_painel_ArrayOfInt
	::Init()
Return Self

WSMETHOD INIT WSCLIENT integracao_painel_ArrayOfInt
	::nint                 := {} // Array Of  0
Return

WSMETHOD CLONE WSCLIENT integracao_painel_ArrayOfInt
	Local oClone := integracao_painel_ArrayOfInt():NEW()
	oClone:nint                 := IIf(::nint <> NIL , aClone(::nint) , NIL )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT integracao_painel_ArrayOfInt
	Local oNodes1 :=  WSAdvValue( oResponse,"_INT","int",{},NIL,.T.,"N",NIL,"a") 
	::Init()
	If oResponse = NIL ; Return ; Endif 
	aEval(oNodes1 , { |x| aadd(::nint ,  val(x:TEXT)  ) } )
Return


