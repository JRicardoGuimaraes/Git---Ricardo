#Include "Protheus.ch"

#Define COL_ID			01
#Define COL_PERIODO		02
#Define COL_DESCPER		03       
#Define COL_TAXAISS		04
#Define COL_VOLUME		05
#Define COL_RESULTA		06
#Define COL_CCUSPSA		07
#Define COL_OIPSA			08
#Define COL_CTAPSA		09
#Define COL_DESCSER		10
#Define COL_CNPJ			11
#Define COL_CCUSTO		12
#Define COL_TES			13
#Define COL_NATUREZA		14
#Define COL_PRODUTO		15
#Define COL_CFOP			16


#Define MSG0001 "Atenção"
#Define MSG0002 "Não existe arquivo do CCO para Importação."
#Define MSG0003 "OK"


/*
Programa	: GEFCCOINT
Funcao		: GEFCCOINT
Data		: 17/04/2015
Autor		: André Costa
Descricao	: Chama a função Static GEFCCOINT
Uso			: Externo - MA410MNU
Sintaxe	: GEFCCOINT()
Chamada	: Botao Importar CCO
Menu		: \Faturamento\Atualizações\Pedido\Acoes Relacionais\Integra CCO
*/


User Function GEFCCOINT
	Local lRetorno
	
	lRetorno := GEFCCOINT()
	
	If ! ( lRetorno )
		Aviso( MSG0001 , MSG0002 , { MSG0003 } )
	EndIf
		
Return

/*
Programa    : GEFCCOINT
Funcao      : GEFCCOINT
Data        : 17/04/2015
Autor       : André Costa
Descricao   : Ler arquivo do CCO e gera Pedido de Vendas.
Uso         : Interno
Sintaxe     : StaticCall( GEFCCOINT, GEFCCOINT )
*/

Static Function GEFCCOINT
	Local _nX
	Local cDe			:= GetMv("MV_RELFROM")
	Local cPara		:= UsrRetMail( RetCodUsr() )
	Local cCc			:= ''
	Local cAssunto	:= 'Log da Importação do CCO'
	Local cMsg			:= 'Segue em anexo o arquivo com as informações de erro ocorridos na integração. Filial :'+SM0->( M0_CODFIL+" "+M0_FILIAL )
	Local cAnexo		:= '\SYSTEM\ImportCCO.LOG'
	Local lRetorno	:= .F.
	Local _Mensagem	:= ''
	
	Private cArquivo	:= 'ImportCCO.LOG'	
	Private _cPath	:= GetNewPar("ES_CCOPED","\Interfaces\CCO\")
	Private _aArqs	:= {}
	
    Private oProcess := NIL
   
	Begin Sequence 
	
		_aArqs := Directory( _cPath + "*.csv" )
		
		If Len ( _aArqs ) == 0
			Break
		EndIf
		
		lRetorno := .T.
		
		oProcess := MsNewProcess():New( { |lEnd| fProcArq( lEnd , oProcess , _cPath, _aArqs )  } , "Processando Arquivo" , "Aguarde..." , .T.)
		oProcess:Activate()
			
		If !File( cAnexo )
			Break
		EndIf
	
		u_EnvEmail( cDe , cPara , cCc , cAssunto , cMsg , cAnexo )
		
		FErase( cAnexo )
		
	End Sequence
	
Return( lRetorno )



/*
	Autor		: André Costa
	Data		: 20/04/2015
	Descricao	: Faz a leitura dos dados do Arquivo informado
	Objetivo	: Faz a leitura dos dados do Arquivo informado
	Chamanda	: Rotina
	Sintaxe	: fProcArq( PATCH , ARQUIVO )
	Parametros	: Nome do Arquivo a ser lido

*/


Static Function fProcArq( lEnd , oRegua , p1, p2 )
	Local aArea		:= GetArea()
	Local cAlias		:= GetNextAlias()
	Local cString  	:= ""
	Local aString		:= {}
	Local lOk
	Local nQtdeReg					
	Local aCabec
	Local aItens
	Local aLinha
	Local xC5_CCUSTO
	Local xC5_CTAPSA
	Local xC5_OIPSA
	Local xC5_CCUSPSA
	Local xC6_PRCVEN
	Local xC5_XOBS
	Local xLogAux		:= "LogAux.LOG"
	Local xCNPJ
	Local cMay 

	Private lMsErroAuto := .F.
		
	oRegua:SetRegua1( Len( p2 ) )
	
	For A := 1 To Len( p2 )
	
		lOk			:= .T.
	
		oRegua:IncRegua1( "Arquvio : "+p2[A][1] + " - " + cValToChar( A ) + " / " + cValToChar( Len( p2 ) ) )
		
		LogThis( 'Inicio do Processo do Arquivo ' + p2[A][1] , cArquivo )
	
		FT_FUSE( p1+p2[A][1] )
		FT_FGOTOP()
		
		nLastRec := FT_FLastRec()
		
		oRegua:SetRegua2( nLastRec )
		
		FT_FGOTOP()
		
		nQtdeReg := 0		
	
		While !FT_FEOF()
	
			cString := FT_FREADLN()
			
			oRegua:IncRegua2("Registro "+ StrZero( ++nQtdeReg , 4 )+" / "+ StrZero( nLastRec , 4 ) )
		
			If Empty(cString) .Or. nQtdeReg == 1
				FT_FSKIP()
				Loop
			EndIf
			
			Begin Sequence
			
				cString	:= StrTran( cString	, ";;",";VAZIO;")
			
				aString	:= StrToKArr( cString,  ";" )
				
				DbSelectArea("SA1")
				SA1->( DbSetOrder(3) )
				
				xCNPJ := StrZero( Val( AllTrim( aString[COL_CNPJ] ) ), GetSx3Cache("A1_CGC" , "X3_TAMANHO") )
				
				If Len( xCNPJ ) # 14
					LogThis( "Erro no ID "+aString[COL_ID]+" na linha "+ StrZero( nQtdeReg , 4 ) + '. CNPJ com quantidade de caracteres inferior a 14. Verifique.' , cArquivo )
					Break
				EndIf
				
				If !DbSeek( xFilial("SA1")+aString[COL_CNPJ] )			// CNPJ Tomador do Serviço
					LogThis( "Erro no ID "+aString[COL_ID]+" na linha "+ StrZero(  nQtdeReg , 4 ) + '. CNPJ '+ aString[COL_CNPJ] +' não encontrado.' , cArquivo )
					Break
				EndIf
				
				
				aCabec := {}		
				aItens := {}
				aLinha := {}
				
/*				COL_DESCSER	//	(Coluna J) Descrição do Serviço
				COL_DESCPER	//	(Coluna C) Descrição do Período
				COL_CCUSPSA	//	(Coluna G) Centro de Custo PSA
				COL_OIPSA		//	(Coluna H) Ordem Interna PSA
				COL_CTAPSA		//	(Coluna I) Conta PSA				
*/				
				xC5_XOBS		:= aString[COL_DESCSER] + CRLF + aString[COL_DESCPER] + aString[COL_CCUSPSA] + aString[COL_OIPSA] + aString[COL_CTAPSA]
	
				xC5_CCUSTO		:= AllTrim(	StrTran(	aString[COL_CCUSTO]	,"."		, '')	)
				xC5_CTAPSA		:= AllTrim(	StrTran(	aString[COL_CTAPSA]	,"VAZIO"	,'' )	)
				xC5_OIPSA		:= AllTrim(	StrTran(	aString[COL_OIPSA]	,"VAZIO"	,'' )	)
				xC5_CCUSPSA	:= AllTrim(	StrTran(	aString[COL_CCUSPSA]	,"VAZIO"	,'' )	)
				xC6_PRCVEN		:= Val(		StrTran(	aString[COL_TAXAISS]	, ","		,'.')	)
				xC6_QTDVEN		:= Val(					aString[COL_VOLUME]						) 
				  		 				  		
				AADD( aCabec,{"C5_TIPO"		,"N"						,	Nil	}	)
				AADD( aCabec,{"C5_CLIENTE"	,SA1->A1_COD				,	Nil	}	)
				AADD( aCabec,{"C5_XTIPONF"	,"NFS"						,	Nil	}	)

				AADD( aCabec,{"C5_CCUSTO"	,xC5_CCUSTO				,	Nil	}	)		// Centro de custo GEFCO
				AADD( aCabec,{"C5_CTAPSA"	,xC5_CTAPSA				,	Nil	}	)		// Conta PSA
				AADD( aCabec,{"C5_OIPSA"		,xC5_OIPSA					,	Nil	}	)		// Ordem Interna PSA
				AADD( aCabec,{"C5_CCUSPSA"	,xC5_CCUSPSA				,	Nil	}	)		// Centro Custo PSA
				AADD( aCabec,{"C5_XOBS"		,xC5_XOBS					,	Nil	}	)		// Observação da Nota
	
				AADD( aLinha,{"C6_ITEM"		,"01"						,	Nil	}	)
				AADD( aLinha,{"C6_PRODUTO"	,aString[COL_PRODUTO]	,	Nil	}	)		// Produto
				AADD( aLinha,{"C6_QTDVEN"	,xC6_QTDVEN				,	Nil	}	)		// Quantidade
				AADD( aLinha,{"C6_PRCVEN"	,xC6_PRCVEN				,	Nil	}	)		// Valor Unitário
				AADD( aLinha,{"C6_TES"		,aString[COL_TES]			,	Nil	}	)		// TES

				AADD( aItens,aLinha	)
				 
				MATA410( aCabec , aItens , 3 )
				
				If lMsErroAuto
				
					RollBackSx8()
									
					MostraErro( "System\",xLogAux )
					
					LogThis( "Erro no ID "+aString[COL_ID]+" na linha "+ StrZero( nQtdeReg , 4 ) + '. Abaixo a descrição do erro.' , cArquivo )
					
					LogThis(  CRLF + MemoRead( xLogAux ) , cArquivo )
					
					lOk := .F.
					lMsErroAuto := .F.

					Break

				EndIf
				
				ConfirmSX8()				

				LogThis( "ID "+aString[COL_ID]+" na linha "+ StrZero( nQtdeReg , 4 ) + ' gerou o Pedido de Venda ' + SC5->C5_NUM  , cArquivo )
							
			End Sequence

			FT_FSKIP()
			
		End While
		
		FT_FUSE()
		
		LogThis( cValToChar( nQtdeReg ) + ' registros processados neste arquivo' , cArquivo )		
		LogThis( 'Fim do Processo do Arquivo ' + p2[A][1]  + " foi "+ IIf( lOK, 'OK.','NOK.' )+CRLF , cArquivo )
		
		__CopyFile( p1+p2[A][1] , p1 + "Backup\" + p2[A][1])
			
		FErase( p1+p2[A][1] )
		
		FErase( xLogAux )
			
	Next A	
	
Return


/*
	Autor		: Andre Costa
	Data		: 22/04/2015
	Descricao	: Gera Log para a Importação
	Chamada		: Interna
	Sintaxe		: LogThis( cMensagem , xArquivo )
*/

Static Function LogThis( cMensagem , xArquivo )

	Local cConsole	:= IIf( !( __cInternet # Nil ), "Console","Schedule" )
	Local cArquivo	:= xArquivo
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