#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"
/* ===============================================================================
WSDL Location    http://10.63.249.78:8083/ws/TORNEIOS.apw?WSDL
Gerado em        03/07/17 19:02:40
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _FUTRTKO ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSTORNEIOS
------------------------------------------------------------------------------- */

WSCLIENT WSTORNEIOS

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD CONSULTACLI
	WSMETHOD INCLUIR

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCPARAMCLI                AS string
	WSDATA   oWSCONSULTACLIRESULT      AS TORNEIOS_CLIENTES
	WSDATA   oWSTORNEIOIN              AS TORNEIOS_TORNEIO
	WSDATA   nINCLUIRRESULT            AS integer

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSTORNEIO                AS TORNEIOS_TORNEIO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSTORNEIOS
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20150410] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSTORNEIOS
	::oWSCONSULTACLIRESULT := TORNEIOS_CLIENTES():New()
	::oWSTORNEIOIN       := TORNEIOS_TORNEIO():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSTORNEIO         := ::oWSTORNEIOIN
Return

WSMETHOD RESET WSCLIENT WSTORNEIOS
	::cCPARAMCLI         := NIL 
	::oWSCONSULTACLIRESULT := NIL 
	::oWSTORNEIOIN       := NIL 
	::nINCLUIRRESULT     := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSTORNEIO         := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSTORNEIOS
Local oClone := WSTORNEIOS():New()
	oClone:_URL          := ::_URL 
	oClone:cCPARAMCLI    := ::cCPARAMCLI
	oClone:oWSCONSULTACLIRESULT :=  IIF(::oWSCONSULTACLIRESULT = NIL , NIL ,::oWSCONSULTACLIRESULT:Clone() )
	oClone:oWSTORNEIOIN  :=  IIF(::oWSTORNEIOIN = NIL , NIL ,::oWSTORNEIOIN:Clone() )
	oClone:nINCLUIRRESULT := ::nINCLUIRRESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSTORNEIO    := oClone:oWSTORNEIOIN
Return oClone

// WSDL Method CONSULTACLI of Service WSTORNEIOS

WSMETHOD CONSULTACLI WSSEND cCPARAMCLI WSRECEIVE oWSCONSULTACLIRESULT WSCLIENT WSTORNEIOS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CONSULTACLI xmlns="http://10.63.249.78:8083/">'
cSoap += WSSoapValue("CPARAMCLI", ::cCPARAMCLI, cCPARAMCLI , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</CONSULTACLI>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://10.63.249.78:8083/CONSULTACLI",; 
	"DOCUMENT","http://10.63.249.78:8083/",,"1.031217",; 
	"http://10.63.249.78:8083/ws/TORNEIOS.apw")

::Init()
::oWSCONSULTACLIRESULT:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTACLIRESPONSE:_CONSULTACLIRESULT","CLIENTES",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method INCLUIR of Service WSTORNEIOS

WSMETHOD INCLUIR WSSEND oWSTORNEIOIN WSRECEIVE nINCLUIRRESULT WSCLIENT WSTORNEIOS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<INCLUIR xmlns="http://10.63.249.78:8083/">'
cSoap += WSSoapValue("TORNEIOIN", ::oWSTORNEIOIN, oWSTORNEIOIN , "TORNEIO", .T. , .F., 0 , NIL, .F.) 
cSoap += "</INCLUIR>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://10.63.249.78:8083/INCLUIR",; 
	"DOCUMENT","http://10.63.249.78:8083/",,"1.031217",; 
	"http://10.63.249.78:8083/ws/TORNEIOS.apw")

::Init()
::nINCLUIRRESULT     :=  WSAdvValue( oXmlRet,"_INCLUIRRESPONSE:_INCLUIRRESULT:TEXT","integer",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure CLIENTES

WSSTRUCT TORNEIOS_CLIENTES
	WSDATA   oWSREGISTROS              AS TORNEIOS_ARRAYOFCLIENTE
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TORNEIOS_CLIENTES
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TORNEIOS_CLIENTES
Return

WSMETHOD CLONE WSCLIENT TORNEIOS_CLIENTES
	Local oClone := TORNEIOS_CLIENTES():NEW()
	oClone:oWSREGISTROS         := IIF(::oWSREGISTROS = NIL , NIL , ::oWSREGISTROS:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TORNEIOS_CLIENTES
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_REGISTROS","ARRAYOFCLIENTE",NIL,"Property oWSREGISTROS as s0:ARRAYOFCLIENTE on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSREGISTROS := TORNEIOS_ARRAYOFCLIENTE():New()
		::oWSREGISTROS:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure TORNEIO

WSSTRUCT TORNEIOS_TORNEIO
	WSDATA   oWSATLETAS                AS TORNEIOS_ARRAYOFATLETA
	WSDATA   cDESCRICAO                AS string
	WSDATA   dFINAL                    AS date
	WSDATA   dINICIO                   AS date
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TORNEIOS_TORNEIO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TORNEIOS_TORNEIO
Return

WSMETHOD CLONE WSCLIENT TORNEIOS_TORNEIO
	Local oClone := TORNEIOS_TORNEIO():NEW()
	oClone:oWSATLETAS           := IIF(::oWSATLETAS = NIL , NIL , ::oWSATLETAS:Clone() )
	oClone:cDESCRICAO           := ::cDESCRICAO
	oClone:dFINAL               := ::dFINAL
	oClone:dINICIO              := ::dINICIO
Return oClone

WSMETHOD SOAPSEND WSCLIENT TORNEIOS_TORNEIO
	Local cSoap := ""
	cSoap += WSSoapValue("ATLETAS", ::oWSATLETAS, ::oWSATLETAS , "ARRAYOFATLETA", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("DESCRICAO", ::cDESCRICAO, ::cDESCRICAO , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("FINAL", ::dFINAL, ::dFINAL , "date", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("INICIO", ::dINICIO, ::dINICIO , "date", .T. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ARRAYOFCLIENTE

WSSTRUCT TORNEIOS_ARRAYOFCLIENTE
	WSDATA   oWSCLIENTE                AS TORNEIOS_CLIENTE OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TORNEIOS_ARRAYOFCLIENTE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TORNEIOS_ARRAYOFCLIENTE
	::oWSCLIENTE           := {} // Array Of  TORNEIOS_CLIENTE():New()
Return

WSMETHOD CLONE WSCLIENT TORNEIOS_ARRAYOFCLIENTE
	Local oClone := TORNEIOS_ARRAYOFCLIENTE():NEW()
	oClone:oWSCLIENTE := NIL
	If ::oWSCLIENTE <> NIL 
		oClone:oWSCLIENTE := {}
		aEval( ::oWSCLIENTE , { |x| aadd( oClone:oWSCLIENTE , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TORNEIOS_ARRAYOFCLIENTE
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_CLIENTE","CLIENTE",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSCLIENTE , TORNEIOS_CLIENTE():New() )
			::oWSCLIENTE[len(::oWSCLIENTE)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFATLETA

WSSTRUCT TORNEIOS_ARRAYOFATLETA
	WSDATA   oWSATLETA                 AS TORNEIOS_ATLETA OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TORNEIOS_ARRAYOFATLETA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TORNEIOS_ARRAYOFATLETA
	::oWSATLETA            := {} // Array Of  TORNEIOS_ATLETA():New()
Return

WSMETHOD CLONE WSCLIENT TORNEIOS_ARRAYOFATLETA
	Local oClone := TORNEIOS_ARRAYOFATLETA():NEW()
	oClone:oWSATLETA := NIL
	If ::oWSATLETA <> NIL 
		oClone:oWSATLETA := {}
		aEval( ::oWSATLETA , { |x| aadd( oClone:oWSATLETA , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT TORNEIOS_ARRAYOFATLETA
	Local cSoap := ""
	aEval( ::oWSATLETA , {|x| cSoap := cSoap  +  WSSoapValue("ATLETA", x , x , "ATLETA", .F. , .F., 0 , NIL, .F.)  } ) 
Return cSoap

// WSDL Data Structure CLIENTE

WSSTRUCT TORNEIOS_CLIENTE
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

WSMETHOD NEW WSCLIENT TORNEIOS_CLIENTE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TORNEIOS_CLIENTE
Return

WSMETHOD CLONE WSCLIENT TORNEIOS_CLIENTE
	Local oClone := TORNEIOS_CLIENTE():NEW()
	oClone:cBAIRRO              := ::cBAIRRO
	oClone:cENDERECO            := ::cENDERECO
	oClone:cESTADO              := ::cESTADO
	oClone:cNOME                := ::cNOME
	oClone:cUF                  := ::cUF
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT TORNEIOS_CLIENTE
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cBAIRRO            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cENDERECO          :=  WSAdvValue( oResponse,"_ENDERECO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cESTADO            :=  WSAdvValue( oResponse,"_ESTADO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNOME              :=  WSAdvValue( oResponse,"_NOME","string",NIL,"Property cNOME as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cUF                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ATLETA

WSSTRUCT TORNEIOS_ATLETA
	WSDATA   nALTURA                   AS float OPTIONAL
	WSDATA   cCPF                      AS string
	WSDATA   dNASCIM                   AS date
	WSDATA   cNOME                     AS string
	WSDATA   nPESOKG                   AS float OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT TORNEIOS_ATLETA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT TORNEIOS_ATLETA
Return

WSMETHOD CLONE WSCLIENT TORNEIOS_ATLETA
	Local oClone := TORNEIOS_ATLETA():NEW()
	oClone:nALTURA              := ::nALTURA
	oClone:cCPF                 := ::cCPF
	oClone:dNASCIM              := ::dNASCIM
	oClone:cNOME                := ::cNOME
	oClone:nPESOKG              := ::nPESOKG
Return oClone

WSMETHOD SOAPSEND WSCLIENT TORNEIOS_ATLETA
	Local cSoap := ""
	cSoap += WSSoapValue("ALTURA", ::nALTURA, ::nALTURA , "float", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("CPF", ::cCPF, ::cCPF , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("NASCIM", ::dNASCIM, ::dNASCIM , "date", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("NOME", ::cNOME, ::cNOME , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("PESOKG", ::nPESOKG, ::nPESOKG , "float", .F. , .F., 0 , NIL, .F.) 
Return cSoap




//-----------------------------------
User Function fWSAtleta()
Local oWSClient 
Local oAtleta
SET DATE BRITISH
SET CENTURY ON 
SET EPOCH TO 1960
 
// Cria a instância da classe Client do WebService de Torneios
oWSClient := WSTORNEIOS():New()
/*
Vamos chamar a inclusao de torneios. para isso, primeiro vemos qual foi o metodo 
de inclusao gerado na classe client Advpl
WSMETHOD INCLUIR WSSEND oWSTORNEIOIN WSRECEIVE nINCLUIRRESULT WSCLIENT WSTORNEIOS
*/
// o parametro oWSTorneioIn é uma estrutura nomeada de TORNEIOS_TORNEIO
// Como esta estrutura é um parâmetro de um método, ela já vem 
// criada, mas seus valores nao estao preenchidos 
// vamos preencher as propriedades desta estrutura
// consultamos as propriedades da estrutura no fonte Client Advpl gerado
/*
WSSTRUCT TORNEIOS_TORNEIO
 WSDATA oWSATLETAS AS TORNEIOS_ARRAYOFATLETA
 WSDATA cDESCRICAO AS string
 WSDATA dFINAL AS date
 WSDATA dINICIO AS date
(...)
*/
oWSClient:oWSTORNEIOIN:cDESCRICAO := 'Torneio de Teste'
oWSClient:oWSTORNEIOIN:dInicio := date()+1
oWSClient:oWSTORNEIOIN:dFinal := date()+2
// Dentro da estrutura de torneio, temos tambem a propriedade oWSAtletas
// Como ela nao vem criada, vamos criar uma instância dela
oWSClient:oWSTORNEIOIN:oWSATLETAS := TORNEIOS_ARRAYOFATLETA():New()
// Como a estrutura é um encapsulamento de array de objetos, 
// a propriedade oWSATLETA desta estrutura vem com {} um array vazio 
// ::oWSATLETA := {} // Array Of TORNEIOS_ATLETA():New()
// Para cada atleta a acrescentar, criamos uma nova instancia da estrutura 
// TORNEIOS_ATLETA . Devemos ver a declaração da estrutura para saber 
// quais propriedades devem ser preenchidas
 
/*
WSSTRUCT TORNEIOS_ATLETA
 WSDATA nALTURA AS float OPTIONAL
 WSDATA cCPF AS string
 WSDATA dNASCIM AS date
 WSDATA cNOME AS string
 WSDATA nPESOKG AS float OPTIONAL
(...)
*/
oAtleta := TORNEIOS_ATLETA():New()
oAtleta:cNome := "Joao da Silva"
oAtleta:cCPF := "123456789-09"
oAtleta:dNASCIM := ctod('02/02/1981')
oAtleta:nPESOKG := 72.5
// agora acrescentamos o atleta da propriedade correta
aadd( oWSClient:oWSTORNEIOIN:oWSATLETAS:oWSATLETA , oAtleta ) 
 
// Criamos um novo atleta
oAtleta := TORNEIOS_ATLETA():New()
oAtleta:cNome := "Jose da Silva"
oAtleta:cCPF := "111111111-11"
oAtleta:dNASCIM := ctod('03/03/1980')
oAtleta:nPESOKG := 75.2
// agora acrescentamos o segundo atleta da propriedade correta
aadd( oWSClient:oWSTORNEIOIN:oWSATLETAS:oWSATLETA , oAtleta )
// vamos ver como ficou a estrutura 
// varinfo("oWSClient:oWSTORNEIOIN",oWSClient:oWSTORNEIOIN)
// agora vamos chamar o metodo de inclusao
If oWSClient:Incluir() 
 
 // Chamada realizada com sucesso. 
 // Vamos ver o que chegou na propriedade de retorno
 msgInfo("Codigo de retorno = "+cValToChar(oWSClient:nINCLUIRRESULT),"Chamada realizada.")
Else
// houve algum erro na chamada
 // ou no processamento do webservice 
 MsgStop(getwscerror(3))
Endif
Return

//-----------------------------------
User Function fWSListaCli()
Local oWSClient 
Local oAtleta
Local oCli
SET DATE BRITISH
SET CENTURY ON 
SET EPOCH TO 1960
 
// Cria a instância da classe Client do WebService de Torneios
oWSClient := WSTORNEIOS():New()

oWSClient:CCPARAMCLI := 'TESTE'

oCli := oWSClient:ConsultaCli()

For x:=1 to Len(oWSClient:owsconsultacliresult:owsregistros:owscliente)
	CONOUT('CLIENTE ==> ' + StrZero(x,3))
	CONOUT(oWSClient:owsconsultacliresult:owsregistros:owscliente[x]:CNOME)
	CONOUT(oWSClient:owsconsultacliresult:owsregistros:owscliente[x]:CENDERECO)
	CONOUT(oWSClient:owsconsultacliresult:owsregistros:owscliente[x]:CBAIRRO)
	CONOUT(oWSClient:owsconsultacliresult:owsregistros:owscliente[x]:CESTADO)
	CONOUT(oWSClient:owsconsultacliresult:owsregistros:owscliente[x]:CUF)				
Next x
/*
Vamos chamar a inclusao de torneios. para isso, primeiro vemos qual foi o metodo 
de inclusao gerado na classe client Advpl
WSMETHOD INCLUIR WSSEND oWSTORNEIOIN WSRECEIVE nINCLUIRRESULT WSCLIENT WSTORNEIOS
*/
Return


/*----------------------------------------*/
User Function fTSTSP()
 
  Local aResult := {}
  Local lRet 	:= TCSPExist('SP_tstConemb')
  Local cSP		:= 'SP_tstConemb'
  Local cDBSQL  := "MSSQL/P11_DEV" // alterar o alias/dsn para o banco/conexão que está utilizando
  Local cSrvSQL := "GEWL3BPROTJDB01" // alterar para o ip do DbAccess
  Local TRAB    := GetNextAlias()
  Local cQuery	:= ''
  Local cRet	:= ''
  
 /*  
  nHwnd := TCLink(cDBSQL, cSrvSQL, 7890)
   
  if nHwnd >= 0
    Alert("Conectado")
  endif
  // TCLink() 
  
  If lRet == .F.
    Alert("Store Procedure not exist!")
  Else
    Alert("Store Procedure exist!")    
  EndIf
  
  // aResult := TCSPEXEC("Nome da SP", "Param")
  aResult := TCSPEXEC(cSP)  
   
  IF empty(aResult)
    Alert('Erro na execução da Stored Procedure : '+TcSqlError())
  Else
    Alert("Retorno String : "+aResult[1])
    Alert("Retorno Numerico : "+str(aResult[2]))
    MsgInfo("Procedure Executada")
  Endif
   
  TCUnLink(nHwnd)
*/

If Select( (TRAB) ) # 0
	( TRAB )->( DbCloseArea() )
EndIf

/*
BeginSql Alias TRAB

	// column ZA6_DTINI as Date, ZA7_VALOR  as Numeric(18,2), DATA_INI as Date

	//%noparser%
	%parser%

	//Cabecalho_Intercambio
   SELECT
	   	'000' AS Identificador_Registro,-- REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER (ORDER BY SA1010_2.A1_NOME))) + RTrim(ROW_NUMBER() OVER (ORDER BY SA1010_2.A1_NOME) -1) AS Identificador_Registro,
			CAST(SIGAMAT.M0_NOMECOM as char(35)) AS Identificacao_Remetente,
			CAST(SA1.A1_NOME as char(35)) AS Identificacao_Destinatario,  
			REPLICATE('0', 2 - LEN(DAY(getdate()))) + CAST(DAY(getdate()) as varchar) + REPLICATE('0', 2 - LEN(Month(getdate()))) + CAST(Month(getdate()) as varchar) + RIGHT(Year(getdate()),2) AS Data,
			REPLACE(CONVERT(varchar(5), GETDATE(), 108), ':', '') AS Hora,
			'CON' +  CAST(DAY(getdate()) as varchar) + CAST(Month(getdate()) as varchar) + CAST(Year(getdate()) as varchar) + REPLACE(CONVERT(varchar(5), GETDATE(), 108), ':', '') + '4' AS Identificacao_Intercambio, 
			CAST('' as char(583)) AS Filler_583
		FROM SIGAMAT, SA1010 SA1 WHERE SIGAMAT.M0_CODFIL='03' AND A1_COD='000486' AND A1_LOJA='00'
//		FOR XML PATH('Cabecalho_Intercambio'), TYPE
	
EndSql

_aQuery := GetLastQuery()
*/
/*
cQuery := "SELECT "
cQuery += "	'000' AS Identificador_Registro,REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER (ORDER BY SA1.A1_NOME))) + RTrim(ROW_NUMBER() OVER (ORDER BY SA1.A1_NOME) -1) AS Identificador_Registro, "
cQuery += "	CAST(SIGAMAT.M0_NOMECOM as char(35)) AS Identificacao_Remetente, "
cQuery += "	CAST(SA1.A1_NOME as char(35)) AS Identificacao_Destinatario, "  
cQuery += "	REPLICATE('0', 2 - LEN(DAY(getdate()))) + CAST(DAY(getdate()) as varchar) + REPLICATE('0', 2 - LEN(Month(getdate()))) + CAST(Month(getdate()) as varchar) + RIGHT(Year(getdate()),2) AS Data, "
cQuery += "	REPLACE(CONVERT(varchar(5), GETDATE(), 108), ':', '') AS Hora, "
cQuery += "	'CON' +  CAST(DAY(getdate()) as varchar) + CAST(Month(getdate()) as varchar) + CAST(Year(getdate()) as varchar) + REPLACE(CONVERT(varchar(5), GETDATE(), 108), ':', '') + '4' AS Identificacao_Intercambio, " 
cQuery += "	CAST('' as char(583)) AS Filler_583 "
cQuery += "	FROM SIGAMAT, SA1010 SA1 WHERE SIGAMAT.M0_CODFIL='03' AND A1_COD='000486' AND A1_LOJA='00' "
cQuery += "	FOR XML PATH('Cabecalho_Intercambio') " //", TYPE "
*/
cQuery := " SELECT RTRIM(A1_NOME), A1_COD, A1_CGC FROM SA1010 WHERE A1_EST='AC' FOR XML PATH('GEFCO') "

If fDoQuery(cQuery, TRAB)
	ConOut('Retornou dados.')
	cRet := 'Retornou dados.'
Else
	cRet := 'NAO Retornou dados.'	
EndIf
   
Return cRet

Static Function fDoQuery (cQuery, cAliasQry)
ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .F.) 
Return (cAliasQry)->(!Eof())
