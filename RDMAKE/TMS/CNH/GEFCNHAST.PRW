#Include "Protheus.ch"
#Include "GEFASTFAT.CH"


/*
Programa    : GEFCNHAST
Funcao      : GEFCNHAST
Data        : 17/04/2015
Autor       : André Costa
Descricao   : Chama a função Static GEFCNHAST
Uso         : Externo - GEFCNHBWS
Sintaxe     : GEFCNHAST()
Chamada		: Botao Importar no GEFCNHBWS
*/


User Function GEFCNHAST											//  u_GEFCNHAST()
	Local lRetorno
	
	lRetorno := GEFCNHAST()
	
	If ! ( lRetorno )
		Aviso( MSG0001 , MSG0007 , { MSG0002 } )
	EndIf
		
Return

/*
Programa    : GEFCNHAST
Funcao      : GEFCNHAST
Data        : 17/04/2015
Autor       : J Ricardo Guimarãs
Descricao   : Ler arquivo da CNH e gravar número da AST e Plano na SE1.
Uso         : Interno
Sintaxe     : StaticCall( GEFCNHAST, GEFCNHAST )
Chamada		: GEFCNHBWS.PRW - Rotina que engloba as pricipais Funções - Importar / Dacte / Fatura 
*/

Static Function GEFCNHAST
	Local _nX
	Local cDe			:= GetMv("MV_RELFROM")
	Local cPara			:= UsrRetMail( RetCodUsr() )
	Local cCc			:= ''
	Local cAssunto		:= 'Log de erro da Importação dos AST´S'
	Local cMsg			:= 'Segue em anexo o arquivo com as informações de erro ocorridos na integração.'
	Local cAnexo		:= '\SYSTEM\ImportAST.LOG'
	Local lRetorno		:= .T.
	Local _Mensagem	:= ''
	
	Private cArquivo	:= 'ImportAST.LOG'	
	Private _cPath		:= GetNewPar("ES_CNHFAT","\Interfaces\TMS\PROTHEUS\OUT\CNH\AST\")
	Private _aArqs		:= {}
	Private aMensagem	:= {}
	
	
	Begin Sequence 
	
		_aArqs := Directory( _cPath + "*.csv" )
		
		If Len ( _aArqs ) == 0
			lRetorno := .F.
			Break
		EndIf
		
		For _nX := 1 To Len(_aArqs)
	
			Processa( { || fProcArq( _cPath, _aArqs[_nX][1] ) } , "Leitura de arquivo", "Iniciando processamento..." , .T. )
			
			__CopyFile( _cPath + _aArqs[_nX][1] , _cPath + "Backup\" + _aArqs[_nX][1])
			
			FErase( _cPath + _aArqs[_nX][1] )
	                                  
		Next _nX
	
		If !File( cAnexo )
			Break
		EndIf
	
		u_EnvEmail( cDe , cPara , cCc , cAssunto , cMsg , cAnexo )
		
		FErase( cAnexo )
				
		If Len( aMensagem ) == 0
			Break
		EndIf
		
		_Mensagem := StrTran( ArrayToStr( aMensagem ), ';',CRLF)
		
		MsgInfo( _Mensagem , "Importações das Filiais")
		
	End Sequence
	
Return( lRetorno )

/*
	Autor			: J Ricardo Guimarãs
	Data			: 20/04/2015
	Descricao	: Faz a leitura dos dados do Arquivo informado
	Objetivo		: Faz a leitura dos dados do Arquivo informado
	Chamanda		: Rotina
	Sintaxe		: fProcArq( _cNomArq )
	Parametros	: Nome do Arquivo a ser lido
*/

Static Function fProcArq( p1,p2 )

	Local _cWhile
	Local _cKey
	Local cLinha   	:= ""
	Local _cCNPJFil 	:= ""
	Local _cNumAST  	:= ""
	Local _cNumPlano	:= ""
	Local _aItens  	:= {}
	Local cAlias		:= GetNextAlias()
	Local lOK			:= .T.
	Local nQtdeReg		:= 0
	Local nOrdem		:= 0
	Local aLinha		:= {}
	Local _ItenxAux
	Local _NfTam08		:= GetMv( "MV_NFTAM08" , .F. , '20|21'	)
	Local _NfTam09		:= GetMv( "MV_NFTAM08" , .F. , '01|'	)
	Local aPrefixo		:= {	{'5  ','E1_NUM'	,'CTE'	}	,	;  	// CTE
									{'0  ','E1_NFELTR','RPS'	}	,	;  	// RPS
									{'9  ','E1_NFELTR','RPS'	}  ,	;  	// RPS 20 / 21
									{'   ','E1_NFELTR','RPS'	}	,	;  	// RPS
									{'ND ','E1_NUM'	,'ND'		}		;		// RPS
								}
								
	Local lMenIni		:= .T.  // Controle de Mensagem Inicial
								
	_cNomArq := p1 + p2
	
	FT_FUSE( _cNomArq )
	FT_FGOTOP()
	
	ProcRegua( FT_FLastRec() )
	
	While !FT_FEOF()
	
		cLinha := FT_FREADLN()
		
		IncProc( P2 )
		
		If Empty(cLinha)
			FT_FSKIP()
			Loop
		EndIf
	                                 
		// Pegar CNPJ da Filial		
		If "NUMERO AST" $ AllTrim( Upper(cLinha) )
		
			aLinha	:= StrToKArr( cLinha,  ";" )
			
			If Len( aLinha ) >= 2
				_cNumAST := aLinha[2]
				FT_FSKIP()
				Loop
			EndIf
			
			If lMenIni			
				LogThis( 'Inicio do Processo do Arquivo '+ _cNomArq , cArquivo )
				lMenIni := .f.
			EndIf
			
			LogThis( 'Não consta numero de AST no Arquivo.' , cArquivo )
			
			Exit
			
		EndIf
	
		// Pegar CNPJ da Filial		
		If "CNPJ TRANSPORTADORA" $ AllTrim( Upper( cLinha ) )
		
			aLinha		:= StrToKArr( cLinha,  ";" )
			
			If Len( aLinha ) >= 2
				_cCNPJFil	:= StrZero( Val( aLinha[2] ), GetSx3Cache("A1_CGC" , "X3_TAMANHO") )
				FT_FSKIP() 
				Loop
			EndIf
			
			If lMenIni
				LogThis( 'Inicio do Processo do Arquivo '+ _cNomArq , cArquivo )
				lMenIni := .f.
			EndIf

			LogThis( 'Não consta CNPJ no Arquivo.' , cArquivo )
			
			Exit
			
		EndIf
		
		// Pegar os Itens
		If "N PLANO" $ AllTrim( Upper( cLinha ) )

			// Posiciono no primeiro item
			FT_FSKIP()
				
			// Loop para pegar todos os itens
			While !FT_FEOF() 
			
				cLinha := FT_FREADLN()
				
				If "VALOR TOTAL" $ AllTrim( Upper( cLinha ) )
					Exit
				EndIf
				
				// Se existir a coluna N PEDIDO SPOT retona 4 elementos
				// aItens[1]="N PLANO"; aItens[2]="N PEDIDO SPOT"; aItens[3]="CTRC / NF"; aItens[4]="VALOR R$"
				
				cLinha := StrTran( cLinha, ";;",";0;")
				
				AADD( _aItens , StrToKArr( cLinha , ";" ) )		
				
				_ItenxAux := _aItens[ Len(_aItens) ][3]
				
				_aItens[ Len(_aItens) ][3] := StrToKArr( _ItenxAux , "/" )

				FT_FSKIP()
				
			End While
			
			Exit
						
		EndIf
		
		IncProc()			
				
		FT_FSKIP()
		
	End While
	
	FT_FUSE()
	
	Begin Sequence
	
		If lMenIni
			LogThis( 'Inicio do Processo do Arquivo '+ _cNomArq  , cArquivo )
			lMenIni := .f.
		EndIf
		
		If Len( _aItens ) == 0
			LogThis( 'Não contem informações para processamento.' , cArquivo )
			lOK := .F.
			Break
		EndIf
	
		If Select( cAlias ) # 0
			( cAlias )->( DbCloseArea() )
		EndIf
	
		BeginSql Alias cAlias 
		
			Select ZX_FILIAL,ZX_CNPJ,ZX_DESCRIC
				
				From %Table:SZX% SZX
				
				Where	(
							SZX.%NotDel%
					And	SZX.ZX_CNPJ = %Exp:_cCNPJFil%
						)
					
		EndSql
	
		If ( cAlias )->( Eof() )

			lOK := .F.			
			LogThis( 'CNPJ '+ _cCNPJFil +' não encontrado ' , cArquivo )
			Break
			
		EndIf
	
		For X := 1 To Len( _aItens )
		
			nPos := aScan( aPrefixo, { |Z| AllTrim( _aItens[X][3][2] ) == AllTrim( Z[1] ) } )
								
			Begin Sequence
						
				If aPrefixo[nPos][3] $ 'CTE|ND'
					nOrdem	:= 1			
					_cKey		:= ( cAlias )->( ZX_FILIAL )  + aPrefixo[nPos][1] + StrZero( Val( AllTrim( _aItens[X][3][1] ) ) , GetSX3Cache( aPrefixo[nPos][2] ,'X3_TAMANHO') )
					_cWhile	:= "SE1->( E1_FILIAL+E1_PREFIXO+E1_NUM )"
					Break
				EndIf
				
				If aPrefixo[nPos][3] $ 'RPS'
					nOrdem	:= 22 
					_cWhile	:=  "SE1->( E1_FILIAL+E1_NFELETR )"
					
					If ( cAlias )->( ZX_FILIAL ) $ _NfTAM09  // 20 - 21
						_cKey :=  ( cAlias )->( ZX_FILIAL )  + AllTrim( _aItens[X][3][1] )
						Break
					EndIf
					
					If ( cAlias )->( ZX_FILIAL ) $ _NfTAM08
						_cKey :=  ( cAlias )->( ZX_FILIAL )  + StrZero( Val( AllTrim( _aItens[X][3][1] ) ) , 08 )
						Break
					EndIf
					
					_cKey :=  ( cAlias )->( ZX_FILIAL )  + StrZero( Val( AllTrim( _aItens[X][3][1] ) ) , 09 )

				EndIf
				
			End Sequence
			
			DbSelectArea("SE1")
			DbSetOrder( nOrdem )

			If SE1->( !DbSeek( _cKey ) )
				LogThis( 'Titulo ' + _aItens[X][3][1] + ' não encontrado' , cArquivo  )
				lOK := .F.
				Loop
			EndIf
		
 			While &_cWhile == _cKey .And. ;
					SE1->( !Eof() )
					
				_cNumAST	:= StrZero( Val( AllTrim( _cNumAST )  )		, GetSx3Cache("E1_NUMAST"	,"X3_TAMANHO") )
				_cPLanoID	:= StrZero( Val( AllTrim( _aItens[X][1] ) )	, GetSx3Cache("E1_PLANID"	,"X3_TAMANHO") )
					
				If !Empty( SE1->E1_NUMAST ) .And. SE1->E1_NUMAST # _cNumAST
					LogThis( 'Tiutlo ' + _aItens[X][3][1] + ' foi alterado o AST de '+SE1->E1_NUMAST+' para ' + _cNumAST , cArquivo )
				EndIf
				
				If !Empty( SE1->E1_PLANID ) .And. SE1->E1_PLANID # _cPLanoID
					LogThis( 'Tiutlo ' + _aItens[X][3][1] + ' foi alterado o PLANID de '+SE1->E1_PLANID+' para ' + _cPLanoID , cArquivo )
				EndIf
				
				If SE1->E1_SALDO == 0
					LogThis( 'Tiutlo ' + _aItens[X][3][1] + ' já foi baixado. ' , cArquivo )
				EndIf
		
				RecLock( "SE1" , .F. )
	   
					SE1->E1_NUMAST	:= _cNumAST
					SE1->E1_PLANID 	:= _cPLanoID 

				SE1->( MsUnlock() )
				
				SE1->( DbSkip() )

			End While

		Next X

		nQtdeReg := Len( _aItens )

	End Sequence
	
	LogThis( cValToChar( nQtdeReg ) + ' registros processados neste arquivo' , cArquivo )
	
	LogThis( 'Fim do Processo do Arquivo ' + _cNomArq  + " foi "+ IIf( lOK, 'OK.','NOK.' ) , cArquivo )
	
	If Select( cAlias ) # 0
	
		nPos := aScan( aMensagem , ( cAlias )->( ZX_FILIAL ) ) 
	
		If nPos == 0 
			AADD( aMensagem , ( cAlias )->( ZX_FILIAL ) + " - " +( cAlias )->( ZX_DESCRIC ) )
		EndIf
		
	EndIf
	
Return


/*
	Autor			: Andre Costa
	Data			: 22/04/2015
	Descricao	: Gera Log para a Importação
	Chamada		: Interna
	Sintaxe		: LogThis( cMensagem , xArquivo )
*/

Static Function LogThis( cMensagem , xArquivo )

	Local cConsole		:= IIf( !( __cInternet # Nil ), "Console","Schedule" )
	Local cArquivo		:= xArquivo
	Local cMensagem	:= "[" + DtoC( Date() ) + " " + Time() + " " + cConsole + "] " + cMensagem
	Local nHdlArq
	Local nTamArq
	
	Begin Sequence

		nHdlArq := FOpen( cArquivo , 2 + 64 )

		If nHdlArq < 0		
			nHdlArq := FCreate( cArquivo )
		EndIf			

		If nHdlArq < 0
			Conout("["+cArquivo+"] Erro ao abrir o arquivo de LOG: " + cArquivo )
			Break
		EndIf

		nTamArq := FSeek( nHdlArq , 0 , 2 )

		FWrite( nHdlArq, cMensagem + CRLF )

		FClose( nHdlArq )

	End Sequence

Return

