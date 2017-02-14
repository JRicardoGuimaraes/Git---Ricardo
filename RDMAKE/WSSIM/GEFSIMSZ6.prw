#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#Include "TbiConn.ch"

/*
	Autor			: Andre Costa
	Data			: 24/10/2014
	Descricao	: Faz leitura da Tabela SZ6
	Objetivo		: Pesquisar via WebService pela chave da nota no SimConsultas
	Chamanda		: Menu	/	Schedule
	Sintaxe		: GEFSIMWS()
*/

User Function GEFSIMWS(_lAmb)
	Local aArea			:= GetArea()
	Local cRpcEmp		:= '01'
	Local cRpcFil		:= '01'
	Local cEnvMod		:= '43'
	Local cFunName		:= FunName()
	Local aTables		:= {"SA1","SZ6","SM4"}
	
	// If !( __cInternet # Nil )
	If _lAmb == Nil
	
		Processa( { || _GEFSIMWS() } , "Verificando Tabela SZ6. Aguarde..." )		
		
	Else
	
		RpcSetType( 3 )
		
		RpcSetEnv( cRpcEmp,cRpcFil,/*cEnvUser*/,/*cEnvPass*/,cEnvMod,cFunName,aTables,/*lShowFinal*/,/*lAbend*/,/*lOpenSX*/,/*lConnect*/ )	
		
		CONOUT( "Inicio de processamento SIM Consulta: " + Time() )

		_GEFSIMWS()

		CONOUT( "Final de processamento SIM Consulta: " + Time() )
		RpcClearEnv()
		
	EndIf

	RestArea( aArea )
	
Return


/*
	Autor			: Andre Costa
	Data			: 24/10/2014
	Descricao	: Faz leitura da Tabela SZ6
	Objetivo		: Pesquisar via WebService pela chave da nota no SimConsultas
	Chamada		: Interna
	Sintaxe		: _GEFSIMWS()	
*/

Static Function _GEFSIMWS

   Local aArea		:= GetArea()
	Local cAlias	:= GetNextAlias()
	Local nReg		:= 0
	Local lSucesso
	Local aLastQuery
	Local nQtdeQuery
	
	Private oSvc	:= Nil
	
	Begin Sequence
	
		For x := 1 To 2
		
			cSelect := IIf( X == 1,	" Count( * ) As _QtdeQuery "," * " )
						
			cSelect := "%"+cSelect+"%"
					
			BeginSql Alias cAlias 
		
				// %noParser%
				
				Select %Exp:cSelect%
			
					From %Table:SZ6% SZ6
				
					Where	(
								SZ6.%NotDel%
						And	SZ6.Z6_FILIAL	 = %xFilial:SZ6%
						And	SZ6.Z6_DTEMIS	 = ''
						And	SZ6.Z6_DATIMP	 = ''
						And	SZ6.Z6_RESPWEB	 = ''
						And	SZ6.Z6_IDNFE	<> ''						
							)

			EndSql
			
			If X = 1
				nQtdeQuery := 	( cAlias )->( _QtdeQuery )				
				( cAlias )->( DbCloseArea() )
			EndIf
			
			aLastQuery := GetLastQuery()
			
		Next x
		
	End Sequence
	
	( cAlias )->( DbgoTop() )
	
	If !( __cInternet # Nil )
		ProcRegua( nQtdeQuery )
	Endif

	While ( cAlias )->( !Eof() )
	
		If !( __cInternet # Nil )
			IncProc(" Atualizando Consulta " + AllTrim( Str( ++nReg ) ) + " de " + AllTrim( Str( nQtdeQuery ) ) )
		Endif
				
		lSucesso := WSSIMClient( ( cAlias )->( Z6_IDNFE ) )
		
		DbSelectArea("SZ6")
		SZ6->( DbSetOrder(2) )
		
		MsSeek( xFilial( "SZ6" ) + ( cAlias )->( Z6_IDNFE ) )

		RecLock( "SZ6", .F. )
			SZ6->Z6_RESPWEB := IIf( lSucesso ,"OK" ,"NOK" )
		SZ6->( MsUnlock() )
    
    	( cAlias )->( DbSkip() )
		
	End While
	
	( cAlias )->( DbCloseArea() )

	RestArea( aArea )

Return

/*
	Data			: 17/10/2014
	Autor			: Andre Costa / Jose Ricardo
	Descricao	: Funcao chamada para pesquisa no WS da sim Consultas
	Chamada		: Interna
	Sintaxe		: WSSIMClient( _cChave )
*/

Static Function WSSIMClient( _cChave )
	
	Local _cXML				:= ""
	Local _cErrorText		:= ""
	Local _cChaveAcesso	:= GetMv( "MV_XCHASIM" )	// Parametro com a Chave de Acesso ao SimConsultas
	Local _nTipoAcesso	:= GetMv( "MV_XTIPSIM" )	// Parametro com a Tipo de Consulta ao SimConsultas
	Local _cCodigo			:= "0K"
	Local _cTexto			:= "Gravada com Sucesso"
	Local _cCFOP			:= ""
	Local _nVrNfeAux		:= 0.00
	Local lRetorno			:= .T.
	
	Begin Sequence
	
		DbSelectArea("SZ6")
		DbSetOrder(2)
		
		If DbSeek( xFilial("SZ6") + _cChave ) .And. !Empty( SZ6->( Z6_RESPWEB ) )
			_cCodigo	:= "NOK"
			_cTexto	:= "Gravada Anteriormente em " + DTOC( SZ6->Z6_DATIMP ) + " as " + SZ6->Z6_HORAIMP
			lRetorno := .F.
			Break
		EndIf 
		
		oSvc := WSSIMConsultasNfeService():New()
	   
		oSvc:cChaveAcesso	:= _cChaveAcesso
		oSvc:cChaveNfe		:= _cChave
		oSvc:nTipo			:= _nTipoAcesso

		oSvc:GetNfe()
		
		If ValType( oSvc:oWsGetNfeResult ) == 'U'
			_cCodigo	:= "NOK"
			_cTexto	:= "Consulta falhou."
			lRetorno	:= .F.
			Break 
		EndIf
	
		oRetSimConsultas := XmlChildEx( oSvc:oWsGetNfeResult:_GetNfeResult,"_INFCONSULTA" )

		If ValType( oRetSimConsultas ) == 'O'
			
			_cCodigo	:= oRetSimConsultas:_StatusConsulta:Text
		 	_cTexto	:= oRetSimConsultas:_StatusDescricao:Text 
		 	
		 	oWSSimErro := oRetSimConsultas
		 	
		 	lRetorno := .F.
		 	Break
	 		
	 	EndIf
	 		 	
		Save oSvc:oWsGetNfeResult:_GetNfeResult XMLString _cXML
		
		_cNfe		:= PadL( AllTrim( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Ide:_NNF:TEXT	) , 9 , "0" )
		_cSerie	:= PadL( AllTrim( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Ide:_SERIE:TEXT	) , 3 , "0" )
			
		_cModelo	:= AllTrim( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Ide:_MOD:TEXT )
			
		If Valtype( XmlChildex( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Ide , "_DHEMI" ) ) = "O"
			_cDTEmis	:= SubStr( StrTran( AllTrim( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Ide:_DHEMI:TEXT ) , "-" , "" ) , 1 , 8 )
		Else
			_cDTEmis	:= StrTran( AllTrim( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Ide:_DEMI:TEXT ) , "-" , "" )
		EndIf
			
		_cMunic		:= AllTrim( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Emit:_EndEremit:_CMUN:TEXT )
			
		_cCNPJEmit	:= AllTrim( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Emit:_CNPJ:TEXT )

		_cNomeEmit	:= Upper( AllTrim( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Emit:_XNOME:TEXT ) )
		_cUFEmit		:= AllTrim( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Emit:_EndErEmit:_UF:TEXT )

		_cCNPJDest := ""
		
		If XmlChildex( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Dest,"_CPF" ) <> Nil
			_cCNPJDest := AllTrim( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Dest:_CPF:TEXT )
		ElseIf XmlChildex( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Dest,"_CNPJ" ) <> Nil
			_cCNPJDest := AllTrim( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Dest:_CNPJ:TEXT )
		EndIf
			
		_cNomeDest	:= Upper( AllTrim( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Dest:_XNOME:TEXT ) )
		_cUFDest		:= AllTrim(  oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Dest:_EndErDest:_UF:TEXT )
			
		// Pego o CFOP de maior valor   

		If ValType( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Det ) == "A"
			
			// NF-e com vários itens
				
			For X := 1 To Len( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Det )
					
				If Val( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Det[X]:_Prod:_vPROD:TEXT) >= _nVrNfeAux
					_nVrNfeAux	:= Val( oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Det[X]:_Prod:_vPROD:TEXT)
					_cCFOP		:= oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Det[X]:_Prod:_CFOP:TEXT
				EndIf
					
			Next X
				
		Else
			// NF-e somente com um item
			_cCFOP := oSvc:oWsGetNfeResult:_GetNfeResult:_Nfe:_InfNfe:_Det:_Prod:_CFOP:TEXT
		EndIf
		
		// Grava XML
		
		DbSelectArea("SZ6")
		SZ6->( DbSetOrder(2) )
		
		MsSeek( xFilial( "SZ6" ) + _cChave )

		If dbSeek( xFilial( "SZ6" ) + _cChave )
			RecLock("SZ6",.F.)
		Else	
			RecLock("SZ6",.T.)
		EndIf	

			SZ6->Z6_IDNfe	:= _cChave
			SZ6->Z6_NUMNfe	:= _cNfe
			SZ6->Z6_SERNfe	:= _cSerie
			SZ6->Z6_MODELO	:= _cModelo
			SZ6->Z6_DTEMIS	:= StoD( _cDtEmis )
			SZ6->Z6_CODMUN	:= _cMunic
			SZ6->Z6_CNPJEMI	:= _cCNPJEmit
			SZ6->Z6_NOMEEMI	:= _cNomeEmit
			SZ6->Z6_UFEmi	:= _cUFEmit
			SZ6->Z6_CNPJDES	:= _cCNPJDest
			SZ6->Z6_NOMEDES	:= _cNomeDest
			SZ6->Z6_UFDEST 	:= _cUFDest
			SZ6->Z6_CFOPPRI	:= _cCFOP
			SZ6->Z6_XML    	:= IIF(AT("ENCODING",AllTrim(UPPER(_cXML))) > 0, _cXML, '<?xml version="1.0" encoding="ISO-8859-1"?>' + AllTrim(_cXML) )
			SZ6->Z6_DATIMP 	:= Date() //dDatabase
			SZ6->Z6_HORAIMP	:= StrTran( Left( Time() , 5 ) , ':' , '' )
			SZ6->Z6_RESPWEB := "OK"
		SZ6->( MsUnLock() )
		
	End Sequence
	
	LogThis( _cChave + " - " + _cCodigo + ' - ' + _cTexto )
 
Return( lRetorno ) 

/*
	Autor			: Andre Costa
	Data			: 22/10/2014
	Descricao	: Gera Log para o WebService do SimConsultas	
	Chamada		: Interna
	Sintaxe		: LogThis( cMensagem )
*/

Static Function LogThis( cMensagem )

	Local cConsole		:= IIf( !( __cInternet # Nil ), "Console","Schedule" )
	Local cArquivo		:= "CTEWebService.LOG"
	Local cMensagem	:= "[" + DtoC( Date() ) + " " + Time() + " " + cConsole + "] " + cMensagem
	Local nHdlArq
	Local nTamArq
	
	Begin Sequence
			
		nHdlArq := FOpen( cArquivo , 2 + 64 )
		
		If nHdlArq < 0		
			nHdlArq := FCreate( cArquivo )
		EndIf			
	
		If nHdlArq < 0
			Conout("[CTEWebService] Erro ao abrir o arquivo de LOG: " + cArquivo )
			Break
		EndIf
		
		nTamArq := FSeek( nHdlArq , 0 , 2 )
		              
		FWrite( nHdlArq, cMensagem + CRLF )
		
		FClose( nHdlArq )
		
	End Sequence

Return

/*
	Autor			: Andre Costa
	Data			: 27/10/2014
	Descricao	: Gera relatorio conforme os parametros informados pelo usuario.
	Chamada		: Menu
	Sintaxe		: GEFSIMREL()
*/

User Function GEFSIMREL

	Local aArea				:= GetArea()
	Local cDesc1			:= "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2			:= "de acordo com os parametros informados pelo usuario."
	Local cDesc3			:= "Relatório de Informação "
	Local titulo			:= "Relatório de Informação "
	Local Cabec1			:= "Filial   Numero NFE   Serie NFE   Modelo   Emissao-   Emitente----------------------------------   Destinatario------------------------------   Dt. Import.   CFOP   ID NFE.-------------------------------------   Stauts"

	Local Cabec2			:= ""
	Local cPict          := ""
	
	Local nLin				:= 80
	Local imprime			:= .T.
	Local aOrd				:= {}
	
	Private lEnd			:= .F.
	Private lAbortPrint	:= .F.
	
	Private cbtxt			:= Space(10)
	
	Private CbTxt			:= ""
	Private tamanho		:= "G"
	Private cPerg			:= "SIMCONSULT"
	Private cString		:= "SZ6"
	Private wnrel			:= "GEFSIMREL" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private nomeprog		:= "GEFSIMREL" // Coloque aqui o nome do programa para impressao no cabecalho
	
	Private limite			:= 220
	Private nTipo			:= 18
	Private nLastKey		:= 0
	Private cbcont			:= 00
	Private CONTFL			:= 01
	Private m_pag			:= 01
	
	Private aReturn		:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	
	DbSelectArea("SZ6")
	DbSetOrder(1)
	
	Pergunte( cPerg , .F. )
		
	wnrel := SetPrint( cString , NomeProg , cPerg , @titulo , cDesc1 , cDesc2 , cDesc3 , .T. , aOrd , .T. , Tamanho , , .T. )
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault( aReturn , cString )
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If( aReturn[4] == 1 , 15 , 18 )

	RptStatus( { || RunReport( Cabec1 , Cabec2 , Titulo , nLin ) } , Titulo )
	
	RestArea( aArea )

Return

/*
	Autor			: Andre Costa
	Data			: 27/10/2014
	Descricao	: Faz o processamento do relatorio conforme os parametros informados pelo usuario.
	Chamada		: Interna
	Sintaxe		: RunReport( Cabec1 , Cabec2 , Titulo , nLin)
*/

Static Function RunReport( Cabec1 , Cabec2 , Titulo , nLin)

	Local nOrdem	
	Local cSelect
	Local cWhere	:= ''
	Local cOrder	:= ''
	Local aArea		:= GetArea()
	Local cAlias	:= GetNextAlias()
	Local nReg		:= 0
	
	Local aLastQuery
	Local nQtdeQuery
	Local cZ6_RespWeb	
	
	Begin Sequence
	
		For x := 1 To 2
		
			cSelect := IIf( X == 1," Count( * ) As _QtdeQuery "," * " )
					
			cSelect := "%"+cSelect+"%"
			
			If MV_PAR05 == 1
				cZ6_RESPWEB = 'OK'
			ElseIf MV_PAR05 == 2
				cZ6_RESPWEB = 'NOK'
			Else
				cZ6_RESPWEB = 'OK|NOK'
			EndIf
			
			cWhere := " And ( SZ6.Z6_RESPWEB In " + FormatIn( cZ6_RESPWEB,"|") + " ) "
			
			If X = 2
				cOrder := "Order By Z6_FILIAL,Z6_DATIMP"				
				cWhere += CRLF + cOrder				
			EndIf
			
			cWhere := "%"+cWhere+"%"
					
			BeginSql Alias cAlias 
		
				// %noParser% 
				Column Z6_DATIMP As Date
				
				Select %Exp:cSelect%
			
					From %Table:SZ6% SZ6
				
					Where	(
								SZ6.%NotDel%
						And	SZ6.Z6_FILIAL BetWeen %Exp:MV_PAR01% And %Exp:MV_PAR02%
						And	SZ6.Z6_DATIMP BetWeen %Exp:DtoS( MV_PAR03 )% And %Exp:DtoS( MV_PAR04 )%
							)
					
					%Exp:cWhere%
					
			EndSql
						
			If X = 1
				nQtdeQuery := ( cAlias )->( _QtdeQuery )				
				( cAlias )->( DbCloseArea() )
			EndIf
			
			aLastQuery := GetLastQuery()
			
		Next x
		
	End Sequence

	( cAlias )->( DbgoTop() )
	
	ProcRegua( nQtdeQuery )
	
	While ( cAlias )->( !Eof() )
	
	   If lAbortPrint
	      @ nLin , 000 PSay "*** CANCELADO PELO OPERADOR ***"
   	   Exit
	   Endif
	
		IncProc(" Imprimindo " + AllTrim( Str( ++nReg ) ) + " de " + AllTrim( Str( nQtdeQuery ) ) )
		
		If nLin > 55
	      Cabec( Titulo , Cabec1 , Cabec2 , NomeProg , Tamanho , nTipo )
   	   nLin := 8
	   Endif
/*
Filial   Numero NFE   Serie NFE   Modelo   Emissao-   Emitente----------------------------------   Destinatario------------------------------   Dt. Import.   CFOP   ID NFE.-------------------------------------   Stauts----
                                                                                                    1         1         1         1         1         1         1         1         1         1         2         2         2'
          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2'
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
 XX		XXXXXXXXX    XXX			  XX      XX/XX/XX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99/99/99      XXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXX
*/			   	   
	   @ nLin , 001 PSay ( cAlias )->Z6_FILIAL
	   @ nLin , 009 PSay ( cAlias )->Z6_NUMNfe
	   @ nLin , 022 PSay ( cAlias )->Z6_SERNfe
	   @ nLin , 035 PSay ( cAlias )->Z6_MODELO
	   @ nLin , 043 PSay ( cAlias )->Z6_DTEMIS
	   @ nLin , 054 PSay ( cAlias )->Z6_NOMEEMI
	   @ nLin , 100 PSay ( cAlias )->Z6_NOMEDES
	   @ nLin , 145 PSay ( cAlias )->Z6_DATIMP
	   @ nLin , 159 PSay ( cAlias )->Z6_CFOPPRI
	   @ nLin , 166 PSay ( cAlias )->Z6_IDNfe
	   @ nLin , 213 PSay ( cAlias )->Z6_RESPWEB
	   	   			
	   nLin++
	   
		( cAlias )->( DbSkip() )
		
	End While
	
	( cAlias )->( DbCloseArea() )
	
	Set Device To Screen

	If aReturn[5] == 1
   	DbCommitAll()
	   Set Printer To
   	OurSpool(wnrel)
	EndIf

	MS_FLUSH()
	
	RestArea( aArea )

Return

/***
* Por: Ricardo 
* Em : 25/11/2015
****/
User Function SIMBuscaXML( _cChave )        
Return WSSIMClient( _cChave )
