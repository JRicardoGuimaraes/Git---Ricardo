#include 'parmtype.ch'
#include "protheus.ch"
#include "APWEBSRV.CH"

/* -------------------------------------------------------------
Fonte WSSRV01.PRW 
Autor Julio Wittwer
Data 10/06/2015
Descrição Fonte de exemplo de Web Services Server com 
 recebimento e retorno de tipos complexos 
 e array de tipos complexos
------------------------------------------------------------- */

WSSTRUCT Cliente
  WSDATA Msg 		AS String
  WSDATA Nome 		AS String
  WSDATA Endereco 	AS String OPTIONAL
  WSDATA Bairro 	AS String OPTIONAL
  WSDATA Estado 	AS String OPTIONAL
  WSDATA UF 		AS String OPTIONAL  
ENDWSSTRUCT

WSSTRUCT Clientes
  WSDATA Registros AS ARRAY OF Cliente
ENDWSSTRUCT

// Todas as propriedades declaradas nas estruturas (WSDATA) por default são obrigatórias. Para tornar uma propriedade opcional, usamos a palavra reservada “OPTIONAL” 
// após o tipo da propriedade. Feita a declaração das estruturas, vamos agora para a prototipação da classe.
// Prototipação do WebServices
// Serviço de cadastro de cliente
WSSERVICE GEFCO DESCRIPTION "Web Service Gefco"
 
 // propriedades de entrada e retorno, usados 
 // como parametros ou retornos nos metodos
 
 WSDATA _Status 	AS STRING
 WSDATA aRetCli 	AS ARRAY OF STRING
 WSDATA _dados	    AS Clientes 
 WSDATA cParamCli	AS STRING 
 WSDATA cChave		AS STRING
 WSDATA cLogin		AS STRING
 
 // Metodos do WebService
 // WSMETHOD Incluir
 WSMETHOD ConsultaCli

ENDWSSERVICE

// WSMETHOD ConsultaCli WSRECEIVE cParamCli 		WSSEND aRetCli WSSERVICE TORNEIOS
WSMETHOD ConsultaCli WSRECEIVE cParamCli, cChave, cLogin WSSEND aRetCli /*_dados*/ WSSERVICE GEFCO
Local oNewCliente

BEGIN SEQUENCE 

	// Cria a instância de retorno ( WSDATA _dados AS Clientes )
	::_dados := WSClassNew( "Clientes" )
	
	::_dados:Registros := {}
	
	oNewCliente := WSClassNew('Cliente')

	oNewCliente:Msg 		:= 'NIL'
	oNewCliente:Nome 		:= 'NIL'
	oNewCliente:Endereco 	:= 'NIL'
	oNewCliente:Bairro 		:= 'NIL'
	oNewCliente:Estado 		:= 'NIL'
	oNewCliente:UF 			:= 'NIL'

	If Empty(::cChave) .OR. Empty(::cLogin)  
	 	::_Status := 'Chave/Login nao informado'

	 	oNewCliente:Msg 	:= 'Chave/Login nao informado'
	 	AADD(::_dados:Registros, oNewCliente)
	 	
	 	CONOUT(::_Status)
	 	BREAK
	EndIf	

	If ::cChave <> GetNewPar('ES_GEFWSCH', 'C6E1BF9A-C664-48BC-9FAA-17D3288B21D1') .OR. ::cLogin <> GetNewPar('ES_GEFWSLG','gefco.logistica') 
	 	::_Status := 'Login invalido'

	 	oNewCliente:Msg := 'Login invalido'
	 	AADD(::_dados:Registros, oNewCliente)
	 	
	 	CONOUT(::_Status)
	 	BREAK
	EndIf	

	If Empty(::cParamCli) .OR. ::cParamCli == Nil
	 	::_Status := 'Parametro nao informado'

	 	oNewCliente:Msg 		:= 'Parametro nao informado'
	 	AADD(::_dados:Registros, oNewCliente)
	 	
	 	CONOUT(::_Status)
	 	BREAK
	EndIf	
	
	dbSelectArea('SA1') ; dbSetOrder(3)
	If !dbSeek(fwFilial('SA1') + ::cParamCli )
	 	::_Status := 'Cliente nao localizado'
	 	CONOUT(::_Status)
	 	
	 	oNewCliente:Msg 		:= 'Cliente nao localizado'
		AADD(::_dados:Registros, oNewCliente)
			 	
	 	BREAK
	EndIf
	 			
	// Cria e alimenta uma nova instancia do cliente
	// Cria e alimenta uma nova instancia do cliente
	
	// oNewCliente := WSClassNew('Cliente')
	oNewCliente:Msg 		:= 'Cliente localizado'	
	oNewCliente:Nome 		:= AllTrim(SA1->A1_NOME)
	oNewCliente:Endereco 	:= AllTrim(SA1->A1_END)
	oNewCliente:Bairro 		:= AllTrim(SA1->A1_BAIRRO)
	oNewCliente:Estado 		:= AllTrim(SA1->A1_MUN)
	oNewCliente:UF 			:= AllTrim(SA1->A1_EST)
	AADD(::_dados:Registros, oNewCliente)
	
	// AADD(::aRetCli, oNewCliente)	
	
	::_Status := 'Cliente localizado'
	CONOUT(::_Status)
	/*
	// Cria e alimenta uma nova instancia do cliente
	oNewCliente := WSClassNew('Cliente')
	oNewCliente:Nome 		:= 'JPG'
	oNewCliente:Endereco 	:= 'RUA TAL QUE TAL'
	oNewCliente:Bairro 		:= 'TAQUARA'
	oNewCliente:Estado 		:= 'RIO DE JANEIRO'
	oNewCliente:UF 			:= 'RJ'
	AADD(::_dados:Registros, oNewCliente)
	*/	
	// ::aRetCli := ::_dados:Registros
		
	varinfo("oCliente",::_Dados:Registros)
	//varinfo("oCliente",oNewCliente)	
	
	
END SEQUENCE	

IF UPPER(oNewCliente:Msg) <> 'CLIENTE LOCALIZADO'
	::aRetCli := {}
	AADD(::aRetCli,oNewCliente:Msg)
	varinfo("oRetCli",::aRetCli)
Else
	::aRetCli 		:= Array(6)
	::aRetCli[1] 	:= oNewCliente:Msg	
	::aRetCli[2]	:= oNewCliente:Nome
	::aRetCli[3]	:= oNewCliente:Endereco
	::aRetCli[4]	:= oNewCliente:Bairro
	::aRetCli[5]	:= oNewCliente:Estado
	::aRetCli[6]	:= oNewCliente:UF			
EndIf	

Return .T.
