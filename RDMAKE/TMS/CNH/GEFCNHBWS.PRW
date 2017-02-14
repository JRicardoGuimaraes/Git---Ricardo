#Include "Protheus.CH"
#Include "FwBrowse.CH"
#Include "GEFASTFAT.CH"

/*
Programa    : GEFCNHBWS
Funcao      : User Fucntion GEFCNHBWS
Data        : 17/04/2015
Autor       : André Costa
Descricao   : Função de Principal 
Uso         : Browse de manutenção das AST
Sintaxe     : GEFCNHBWS()
Chamada		: Menu - Financeiro\Atualizaçoes\
*/


User Function GEFCNHBWS	// u_GEFCNHBWS()
	
	GEFCNHBWS()
		
Return

/*
Programa    : GEFCNHBWS
Funcao      : Static Function GEFCNHBWS
Data        : 17/04/2015
Autor       : André Costa
Descricao   : Manutenção da Browse
Uso         : Browse de manutenção das AST
Sintaxe     : StaticCall( GEFCNHBWS, GEFCNHBWS )
Chamada		: Interna
*/

Static Function GEFCNHBWS
	Local aArea := GetArea()
	Local lBuildData := .F.
	Local aSize
	Local aSize1
	Local aSize2
	
	Local aObjects
	Local aInfo
	
	Local aPosObj0
	Local aPosObj1
	Local aPosObj2

	Local oFontBold
	
	Local oGrpAST
	Local oASTGrp
	Local oAstPanel
			
	Local oCTeGrp
	Local oInfGrp
	Local oOpcGrp
	
	// Tela Principal
	Static oDlg
	Static oPanel
	Static oAstBrowse
	Static oCTeBrowse
	Static oCliAST
	Static oTotAST
	Static oSalAST
	
	
	// Totalização do Faturmento 
	Static nTotAST	:= 0
	Static nSalAST	:= 0
	
	Static dDataInicio := "20140601"   // Inicio da pesquisa na Tabela SE1
	
// Carregando os Dados

	Private aASTMarcado	:= {}	
	Private aDadosInfo	:= {}
	
	Private cAlias			:= GetNextAlias()
	
	Processa( { || _BuildData( @lBuildData , @aDadosInfo ) } , MSG0004, MSG0005 , .f. )	//  Aguarde - Processando informaçõe da Tabela SE1
	
	If !( lBuildData )
		Aviso( MSG0001 , MSG0003 , { MSG0002 } )
		
		If ! ( MsgYesNo( MSG0026 , MSG0018 ) )
			Return			
		EndIf
		
		If ! ( _RefreshData() )
			Return
		EndIf
		
	EndIf
	
// Tela Inicial

	aSize := MsAdvSize(.F.)
	
	aObjects := {}	
						//  X     Y
	AAdd( aObjects, { 100 , 100, .T. , .T.  } )
	AAdd( aObjects, { 100 , 090, .T. , .F.  } )
			
	aInfo		:= { aSize[1], aSize[2], aSize[3], aSize[4],1,1,0,0 }	
	aPosObj0	:= MsObjSize( aInfo, aObjects, .F. , .F. )
	
// Telas Verticais

	aObjects := {}
						//  X     Y                        	
	AAdd( aObjects, { 150 , 100, .F. , .T.  } )
	AAdd( aObjects, { 160 , 100, .T. , .T.  } )
	
	aSize1	:= aClone( aPosObj0[1] )
	
	aInfo		:= { aSize1[2], aSize1[1], aSize1[4], aSize1[3],1,1,0,0 }
	aPosObj1	:= MsObjSize( aInfo, aObjects, .T. , .T. )  							// Vertical
	
// Tela Horizontais
	
 	aObjects := {}
 	
	AAdd( aObjects, { 100 , 100, .T. , .T.  } )
	AAdd( aObjects, { 050 , 100, .F. , .T.  } )
	
	aSize2	:= aClone( aPosObj0[2] )
			
	aInfo		:= { aSize2[2], aSize2[1], aSize2[4], aSize2[3],1,1,0,0 }	
	aPosObj2 := MsObjSize( aInfo, aObjects, .T. , .T. ) 							 // Vertical
	
	Define FONT oFontBold Name "ARIAL" Size 0, -11 BOLD
	
	Define MsDialog oDlg Title MSG0013 From aSize[7],aSize[1] To aSize[6],aSize[5] Of GetWndDefault() Pixel  // Informações de Faturmento

		oGrpAST	:= TGroup():New(aPosObj2[1][1]+TAMCOL01,aPosObj2[1][2]+TAMCOL01,aPosObj2[1][3]-TAMCOL01,aPosObj2[1][4]-TAMCOL01,MSG0014,oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )  // "Perido de Faturamento"
		
		@ 000,000 MsPanel oPanel Of oDlg
		oPanel:Align	:= CONTROL_ALIGN_ALLCLIENT

		// AST
						
		oASTGrp			:= TGroup():New(aPosObj1[1][1]+TAMCOL01,aPosObj1[1][2]+TAMCOL01,aPosObj1[1][3]-TAMCOL01,aPosObj1[1][4]-TAMCOL01,/*cTitle*/,oPanel,CLR_BLACK,CLR_WHITE,.T.,.F. )
 		oAstPanel		:= TPanel():New(aPosObj1[1][1]+TAMCOL08,aPosObj1[1][2]+TAMCOL03,/*cText*/,oASTGrp	,/*[oFont]*/,/*[lCentered]*/,/*[uParam7]*/,0,14215660, aPosObj1[1][4]-TAMCOL05 , aPosObj1[1][3]-TAMCOL10,.F.,.T. )
 		
 		oAstBrowse		:= FWBrowse():New()
 		
		bAstSetChange	:= { || _AstMudaCampo() , _InfoView() }
		bMarca	  		:= { || If( ( nPos := aScan( aASTMarcado , oAstBrowse:oData:aArray[oAstBrowse:nAT][1] ) ) == 0 , aAdd(aASTMarcado, oAstBrowse:oData:aArray[oAstBrowse:nAT][1] ), ( aDel( aASTMarcado, nPos ), aSize( aASTMarcado, Len( aASTMarcado ) - 1 ) ) ) , oAstBrowse:Refresh() }
		bMarcaTodos		:= { |oAstBrowse| If( Len( aASTMarcado ) > 0, aASTMarcado := {}, aASTMarcado := _GetAllItens() ), oAstBrowse:Refresh() }
 		
 		oAstBrowse:DisableConfig()
 		oAstBrowse:DisableReport()
		oAstBrowse:SetDataArray()		
		oAstBrowse:SetArray( aDadosInfo )
		oAstBrowse:SetChange( bAstSetChange )
		
		oAstMarca		:= { || If( ( nPos := aScan( aASTMarcado , oAstBrowse:oData:aArray[oAstBrowse:nAT][1] ) ) # 0 ,'LBOK','LBNO' ) }
				
		oAstBrowse:AddMarkColumns( oAstMarca , bMarca , bMarcaTodos )
		
		ADD Column	oColumn Data { || oAstBrowse:oData:aArray[oAstBrowse:nAT][1]   } Title MSG0015 Size  GetSx3Cache("E1_NUMAST","X3_TAMANHO") Picture GetSx3Cache("E1_NUMAST","X3_PICTURE") Of oAstBrowse // "Numero AST"
 	 		
		oAstBrowse:SetOwner( oAstPanel )
		oAstBrowse:Activate()
				
		// CTE´S
		oCTeGrp		:= TGroup():New(aPosObj1[2][1]+TAMCOL01,aPosObj1[2][2]+TAMCOL01,aPosObj1[2][3]-TAMCOL01,aPosObj1[2][4]-TAMCOL01,/*cTitle*/,oPanel,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oCTePanel	:= TPanel():New(aPosObj1[2][1]+TAMCOL08,aPosObj1[2][2]+TAMCOL03,/*cText*/,oCteGrp	,/*[oFont]*/,/*[lCentered]*/,/*[uParam7]*/,0,14215660, ( aPosObj1[2][4] / 1.2 ) - 55 , aPosObj1[2][3]-TAMCOL10,.F.,.T. )

		oCTeBrowse	:= FWBrowse():New()
		oCTeBrowse:DisableConfig()
		oCTeBrowse:DisableReport()
		oCTeBrowse:SetDataArray()
		oCTeBrowse:SetArray( aDadosInfo[oAstBrowse:nAT][2] )
				
		bCTeSetChange	:= { || _InfoView() }
		oCTeBrowse:SetChange( bCTeSetChange )
		
		ADD Column	oColumn	Data { || oCTeBrowse:oData:aArray[oCTeBrowse:nAT][01]	}				Title GetSx3Cache("E1_FILIAL"		,"X3_TITULO") Size	GetSx3Cache("E1_FILIAL"		,"X3_TAMANHO") Picture GetSx3Cache("E1_FILIAL"	,"X3_PICTURE") Of oCTeBrowse
		ADD Column	oColumn	Data { || oCTeBrowse:oData:aArray[oCTeBrowse:nAT][09]	}				Title GetSx3Cache("E1_PREFIXO"	,"X3_TITULO") Size	GetSx3Cache("E1_PREFIXO"	,"X3_TAMANHO") Picture GetSx3Cache("E1_PREFIXO"	,"X3_PICTURE") Of oCTeBrowse
		ADD Column	oColumn	Data { || oCTeBrowse:oData:aArray[oCTeBrowse:nAT][10]	}				Title GetSx3Cache("E1_SERIE"		,"X3_TITULO") Size	GetSx3Cache("E1_SERIE"		,"X3_TAMANHO") Picture GetSx3Cache("E1_SERIE"	,"X3_PICTURE") Of oCTeBrowse
		ADD Column	oColumn	Data { || oCTeBrowse:oData:aArray[oCTeBrowse:nAT][02]	}				Title GetSx3Cache("E1_NUM"			,"X3_TITULO") Size	GetSx3Cache("E1_NUM"			,"X3_TAMANHO") Picture GetSx3Cache("E1_NUM"		,"X3_PICTURE") Of oCTeBrowse
		ADD Column	oColumn	Data { || oCTeBrowse:oData:aArray[oCTeBrowse:nAT][03]	}				Title GetSx3Cache("E1_PLANID"	,"X3_TITULO") Size	GetSx3Cache("E1_PLANOID"	,"X3_TAMANHO") Picture GetSx3Cache("E1_PLANOID"	,"X3_PICTURE") Of oCTeBrowse		
		ADD Column	oColumn	Data { || StoD( oCTeBrowse:oData:aArray[oCTeBrowse:nAT][04] )	}	Title GetSx3Cache("E1_EMISSAO"	,"X3_TITULO") Size	GetSx3Cache("E1_EMISSAO"	,"X3_TAMANHO") Picture "99/99/9999" 									Of oCTeBrowse
		
		ADD Column	oColumn	Data { || oCTeBrowse:oData:aArray[oCTeBrowse:nAT][05]	}				Title GetSx3Cache("E1_VALOR"		,"X3_TITULO") Size	GetSx3Cache("E1_VALOR"		,"X3_TAMANHO")	Picture GetSx3Cache("E1_VALOR"	,"X3_PICTURE") Of oCTeBrowse
		ADD Column	oColumn	Data { || oCTeBrowse:oData:aArray[oCTeBrowse:nAT][06]	}				Title GetSx3Cache("E1_SALDO"		,"X3_TITULO") Size	GetSx3Cache("E1_SALDO"		,"X3_TAMANHO") Picture GetSx3Cache("E1_SALDO"	,"X3_PICTURE") Of oCTeBrowse

		ADD Column	oColumn	Data { || StoD( oCTeBrowse:oData:aArray[oCTeBrowse:nAT][07] )	}	Title GetSx3Cache("E1_BAIXA"		,"X3_TITULO") Size	GetSx3Cache("E1_BAIXA"		,"X3_TAMANHO") Picture "99/99/9999"										Of oCTeBrowse
		ADD Column	oColumn	Data { || oCTeBrowse:oData:aArray[oCTeBrowse:nAT][08]	}				Title GetSx3Cache("E1_NUMBOR"		,"X3_TITULO") Size	GetSx3Cache("E1_NUMBOR"		,"X3_TAMANHO") Picture GetSx3Cache("E1_NUMBOR"	,"X3_PICTURE") Of oCTeBrowse
				
		oCTeBrowse:SetOwner( oCTePanel )
		oCTeBrowse:Activate()

		// Informações
		oInfGrp		:= TGroup():New(aPosObj2[1][1]+001,aPosObj2[1][2]+001,aPosObj2[1][3]-001,aPosObj2[1][4]-001,MSG0016,oPanel,CLR_BLACK,CLR_WHITE,.T.,.F. )  // "Informações"
		
		oCliAST		:= TSay():New(aPosObj2[1][1]+007,aPosObj2[1][2]+005,{||	''	}	,oInfGrp	,/*cPicture*/,oFontBold,/*[uParam7]*/,/*[uParam8]*/,/*[uParam9]*/,.T.,CLR_BLACK,CLR_WHITE,250,015,/*[uParam15]*/,/*[uParam16]*/,/*[uParam17]*/,/*[uParam18]*/,/*[uParam19]*/,/*[lHTML]*/ )
		oTotAST		:= TSay():New(aPosObj2[1][1]+014,aPosObj2[1][2]+005,{||	''	}	,oInfGrp	,/*cPicture*/,oFontBold,/*[uParam7]*/,/*[uParam8]*/,/*[uParam9]*/,.T.,CLR_BLACK,CLR_WHITE,100,015,/*[uParam15]*/,/*[uParam16]*/,/*[uParam17]*/,/*[uParam18]*/,/*[uParam19]*/,/*[lHTML]*/ )
		oSalAST		:= TSay():New(aPosObj2[1][1]+021,aPosObj2[1][2]+005,{||	''	}	,oInfGrp	,/*cPicture*/,oFontBold,/*[uParam7]*/,/*[uParam8]*/,/*[uParam9]*/,.T.,CLR_BLACK,CLR_WHITE,100,015,/*[uParam15]*/,/*[uParam16]*/,/*[uParam17]*/,/*[uParam18]*/,/*[uParam19]*/,/*[lHTML]*/ )
				
		// Opcoes
  		oOpcGrp		:= TGroup():New(aPosObj2[2][1]+001,aPosObj2[2][2]+001,aPosObj2[2][3]-001,aPosObj2[2][4]-001,MSG0017,oPanel,CLR_BLACK,CLR_WHITE,.T.,.F. )  // Opções
  		  		
  		nLinTButton := aPosObj2[2][1]+010
  		nColTButton := aPosObj2[2][2]+005

		oTButton1	:= TButton():Create ( oOpcGrp,nLinTButton			,nColTButton	,MSG0018	,{ || _RefreshData()	, _RefreshBrowse()																					}, 40, 10,/*[uParam8]*/,/*[oFont]*/,/*[uParam10]*/,.T.,/*[uParam12]*/,MSG0008		,/*[uParam14]*/,/*[bWhen]*/,/*[bValid]*/,/*[uParam17]*/ ) 	// IMPORTAR - Importação das AST
		oTButton2	:= TButton():Create ( oOpcGrp,nLinTButton + 013	,nColTButton	,MSG0031	,{ || Processa( { || _DacteAst()						}	, MSG0004, MSG0027 , .f. ) , oAstBrowse:SetFocus()	}, 40, 10,/*[uParam8]*/,/*[oFont]*/,/*[uParam10]*/,.T.,/*[uParam12]*/,MSG0030		,/*[uParam14]*/,/*[bWhen]*/,/*[bValid]*/,/*[uParam17]*/ )	// IMPRIMIR	- Impresão da DACTE
		oTButton3	:= TButton():Create ( oOpcGrp,nLinTButton	+ 026	,nColTButton	,MSG0019	,{ || Processa( { || _DactePrint()					}	, MSG0004, MSG0027 , .f. ) , oAstBrowse:SetFocus()	}, 40, 10,/*[uParam8]*/,/*[oFont]*/,/*[uParam10]*/,.T.,/*[uParam12]*/,MSG0009		,/*[uParam14]*/,/*[bWhen]*/,/*[bValid]*/,/*[uParam17]*/ )	// DACTE		- Impresão do RPS
		oTButton4	:= TButton():Create ( oOpcGrp,nLinTButton	+ 039	,nColTButton	,""		,{ || MsgAlert( "Em Construção", "Atenção" )																				}, 40, 10,/*[uParam8]*/,/*[oFont]*/,/*[uParam10]*/,.T.,/*[uParam12]*/,/*[cMSG]*/	,/*[uParam14]*/,/*[bWhen]*/,/*[bValid]*/,/*[uParam17]*/ )	// 
		oTButton5	:= TButton():Create ( oOpcGrp,nLinTButton	+ 052	,nColTButton	,MSG0021	,{ || Processa( { || _FaturaPrint()					}	, MSG0004, MSG0027 , .f. ) , oAstBrowse:SetFocus()	}, 40, 10,/*[uParam8]*/,/*[oFont]*/,/*[uParam10]*/,.T.,/*[uParam12]*/,MSG0011		,/*[uParam14]*/,/*[bWhen]*/,/*[bValid]*/,/*[uParam17]*/ )	// FATURA	- Impresão da Fatura
		oTButton6	:= TButton():Create ( oOpcGrp,nLinTButton	+ 065	,nColTButton	,MSG0022	,{ || oDlg:End()																																					}, 40, 10,/*[uParam8]*/,/*[oFont]*/,/*[uParam10]*/,.T.,/*[uParam12]*/,MSG0022		,/*[uParam14]*/,/*[bWhen]*/,/*[bValid]*/,/*[uParam17]*/ )	// FECHAR	- Fechar rotina
  		  		
 		_InfoView()
  		
  		oAstBrowse:SetFocus()

	Activate MsDialog oDlg
	
	RestArea( aArea )
		
Return 

/*
Programa    : GEFCNHBWS
Funcao      : Static Function _BuildData
Data        : 17/04/2015
Autor       : André Costa
Descricao   : Marca / Desmarca todos os itens do browse da AST
Sintaxe     : _BuildData( lBuildData , @aDadosInfo )
Parametro	: Parametro logico passado por referencia 
Chamada		: Interna
*/

Static Function _BuildData( lBuildData , aDadosInfo )
   Local aArea			:= GetArea()
   Local cAlias		:= GetNextAlias()   
   Local nPos			:= 0
   Local nTotReg		:= 0
   
   If Select( cAlias ) # 0	
		(cAlias)->( DbCloseArea() )
	EndIf

	BeginSql Alias cAlias
		
		Select Distinct	E1_NUMAST 	,E1_FILIAL	,E1_PLANID	,
								E1_NUM		,E1_EMISSAO	,E1_BAIXA	,
								E1_VALOR		,E1_SALDO	,E1_NUMBOR	,
								E1_CLIENTE	,E1_LOJA		,E1_PREFIXO	,
								E1_SERIE		,E1_VALLIQ
				
			From %Table:SE1% SE1
				
			Where	(			SE1.%NotDel%
						And	SE1.E1_FILIAL	= %Exp:SubStr(cNumEmp,3,2)%
						And	SE1.E1_EMISSAO	>=	%Exp:dDataInicio%
						And	SE1.E1_NUMAST	<> ''
						And	SE1.E1_SALDO	<> 0 
					)
					
			Order By E1_NUMAST
					
	EndSql
	
	aLastQuery := GetLastQuery()
		
	ProcRegua( ( cAlias )->( RecCount() ) )
	
	( cAlias )->( DbGoBottom() )
			
	( cAlias )->( DbGoTop() )
	
	aDadosInfo := {}
	
	While ! ( cAlias )->( Eof() )
	
		IncProc()
	
		nPos := aScan( aDadosInfo, { |Z| Z[1] == ( cAlias )->( E1_NUMAST ) } )
		
		If nPos == 0		   
			AADD( aDadosInfo, {	( cAlias )->( E1_NUMAST )	,	;			//1 - Numero da AST
										{}									,	;			//2 - Array dos Itens
										( cAlias )->( E1_FILIAL )	,	;			//3 - Numero da Filial
										0									,	;			//4 - Valor total da AST
										0									,	;			//5 - Saldo total da AST
										(cAlias)->( E1_CLIENTE )	,	;			//6 - Cliente da AST										
										(cAlias)->( E1_LOJA	)		,	;			//7 - Loja do Cliente da ASt
										0 } )												//8 - Valor Liquido da ASt
										
			nPos := Len( aDadosInfo )
		EndIf
		
		aDadosInfo[nPos][4] += (cAlias)->( E1_VALOR )
		aDadosInfo[nPos][5] += (cAlias)->( E1_SALDO )
		aDadosInfo[nPos][8] += (cAlias)->( E1_VALLIQ )
		
		AADD( aDadosInfo[nPos][2] ,	{		(cAlias)->( E1_FILIAL	)	,	; // 01 - Filial
										  	  			(cAlias)->( E1_NUM		)	,	; // 02 - Numero do Titulo
										  	  			(cAlias)->( E1_PLANID	)	,	; // 03 - Numero do Plano da AST
														(cAlias)->( E1_EMISSAO	)	,	; // 04 - Data Emissao
														(cAlias)->( E1_VALOR		)	,	; // 05 - Valor od Titulo
														(cAlias)->( E1_SALDO		)	,	; // 06 - Saldo do Titulo
														(cAlias)->( E1_BAIXA		)	,	; // 07 - Baixa do Titulo
														(cAlias)->( E1_NUMBOR	)	,	; // 08 - Numero do Bordero
														(cAlias)->( E1_PREFIXO	)	,	; // 09 - Prefixo do Titulo
														(cAlias)->( E1_SERIE		)		; // 10 - Serie do Titulo
												} )

		
		( cAlias )->( DbSkip() )

	End While 

	lBuildData := ( Len( aDadosInfo ) > 0 )
	
   If Select( cAlias ) # 0	
		(cAlias)->( DbCloseArea() )
	EndIf
	
	RestArea( aArea )

Return


/*
Programa    : GEFCNHBWS
Funcao      : Static Function _RefreshBrowse
Data        : 17/04/2015
Autor       : André Costa
Descricao   : Atualização do Browse apo pressionado o botao de Importar.
Sintaxe     : _RefreshBrowse
Chamada		: Interna
*/

Static Function _RefreshBrowse
	Local aArea := GetArea()
	
	oAstBrowse:nAT := 1
	oCTeBrowse:nAT := 1
	
	oAstBrowse:SetArray( aDadosInfo )
	oAstBrowse:SetFocus()			
	oCTeBrowse:SetArray( aDadosInfo[oAstBrowse:nAT][2] )
	
	oAstBrowse:Refresh()
	oCTeBrowse:Refresh()
	
	RestArea( aArea )
Return

/*
Programa    : GEFCNHBWS
Funcao      : Static Function _RefreshData
Data        : 17/04/2015
Autor       : André Costa
Descricao   : Importação das informações dos arquivos CSV
Sintaxe     : _RefreshData
Chamada		: Interna
*/

Static Function _RefreshData
	Local aArea			:= GetArea()
	Local lRetorno		:= .T.
	Local lBuildData	:= .F.
	
	Begin Sequence
		
		If ! ( StaticCall( GEFCNHAST , GEFCNHAST ) )
			Aviso( MSG0001 , MSG0007 , { MSG0002 } )  //  Atencao - Nao Existem dados a serem Importados - OK
			lRetorno := .F.
			Break
		EndIf
		
		Processa( { || _BuildData( @lBuildData , @aDadosInfo ) } , MSG0004, MSG0006 , .f. )   //  Aguarde - Importando dados para Tabela SE1
	
		If !( lBuildData )
			Aviso( MSG0001 , MSG0003 , { MSG0002 } )		//  Atencao - Nao Existem dados a serem Importados - OK
			lRetorno := .F.
			Break
		EndIf
				
	End Sequence
	
	RestArea( aArea )
	
Return( lRetorno )


/*
Programa    : GEFCNHBWS
Funcao      : Static Function _InfoView()
Data        : 17/04/2015
Autor       : André Costa
Descricao   : Controle as informações da tela 
Sintaxe     : _InfoView()
Chamada		: Interna
*/

Static Function _InfoView()
	Local aCliAst
	Local nTotAst
	Local nSalAst	
	Local _Chave
	
	Begin Sequence
	
		If ( ValType( oCliAST ) == "U" )
			Break		
		EndIf
		
		nTotAst	:= aDadosInfo[oAstBrowse:nAT][4]
		nSalAst	:= aDadosInfo[oAstBrowse:nAT][5]
		_Chave	:= xFilial("SA1")+aDadosInfo[oAstBrowse:nAT][6]+aDadosInfo[oAstBrowse:nAT][7]
		
		aCliAST := GetAdvFVal("SA1", { "A1_NOME", "A1_END", "A1_BAIRRO", "A1_CEP", "A1_MUN", "A1_EST", "A1_CGC", "A1_CEINSS", "A1_PESSOA" }, _Chave , 1, { "", "", "", "", "", "", "", "", "" })

		oCliAST:cCaption	:= MSG0023 + aCliAST[1]
		oTotAST:cCaption	:= MSG0024 + TransForm( nTotAST , "@E 99,999,999,999.99" )
		oSalAST:cCaption	:= MSG0025 + TransForm( nSalAST , "@E 99,999,999,999.99" )
		
	End Sequence
	
Return( .T. )

/*
Programa    : GEFCNHBWS
Funcao      : Static Function _DactePrint
Data        : 17/04/2015
Autor       : André Costa
Descricao   : Controle de impressão das DACTEs por CTE
Sintaxe     : _DactePrint()
Chamada		: Interna
*/


Static Function _DactePrint
	Local aArea		:= GetArea()
	Local _KeyDT6	:= xFilial("DT6")+oCTeBrowse:oData:aArray[oCTeBrowse:nAT][01]+oCTeBrowse:oData:aArray[oCTeBrowse:nAT][02]+oCTeBrowse:oData:aArray[oCTeBrowse:nAT][10]
	
	Local cDe			:= GetMv("MV_RELFROM")
	Local cPara			:= UsrRetMail( RetCodUsr() )
	Local cCc			:= ''
	Local cAssunto		:= "Log de erro da Impressão das DACTE´S"
	Local cMsg			:= 'Segue em anexo o arquivo com as informações de erro ocorridos na integração.'
	Local cAnexo		:= '\SYSTEM\DACTE.LOG'
	Private cArquivo	:= "DACTE.LOG"
	
	DbSelectArea("DT6")
	
	ProcRegua(1)
	
	SM0->( DbSeek( cEmpAnt + AllTrim( oCTeBrowse:oData:aArray[oCTeBrowse:nAT][01] ) ) )
	
	MV_PAR53 := oCTeBrowse:oData:aArray[oCTeBrowse:nAT][02]	// Numero do Documento
	MV_PAR54 := oCTeBrowse:oData:aArray[oCTeBrowse:nAT][02]	// Numero do Documento
	MV_PAR55 := oCTeBrowse:oData:aArray[oCTeBrowse:nAT][10]	//	Serie do Documento Inicial
	MV_PAR56 := oCTeBrowse:oData:aArray[oCTeBrowse:nAT][10]	//	Serie do Documento Final
	MV_PAR57 := GetAdvFval( "DT6", "DT6_DOCTMS", _KeyDT6 , 1 , '' , .T. )
	
	IncProc()
			
	u_RTMSR27()
	
	If File( cAnexo )
		u_EnvEmail( cDe , cPara , cCc , cAssunto , cMsg , cAnexo )		
		FErase( cAnexo )
	EndIf
	
	MV_PAR53 := ''
	MV_PAR54 := ''
	MV_PAR55 := ''
	MV_PAR56 := ''
	MV_PAR57 := ''
		
	oCTEBrowse:SetFocus()
	
	RestArea( aArea )

Return( Nil )


/*
Programa    : GEFCNHBWS
Funcao      : Static Function _DacteAST
Data        : 17/04/2015
Autor       : André Costa
Descricao   : Controle de impressão das DACTEs pelas AST
Sintaxe     : _DacteAST()
Chamada		: Interna
*/


Static Function _DacteAST()
	Local aArea := GetArea()
	Local Y,Z
	Local nPos
	Local _KeyDT6		
	Local cDe			:= GetMv("MV_RELFROM")
	Local cPara			:= UsrRetMail( RetCodUsr() )
	Local cCc			:= ''
	Local cAssunto		:= "Log de erro da Impressão das DACTE´S"
	Local cMsg			:= 'Segue em anexo o arquivo com as informações de erro ocorridos na integração.'
	Local cAnexo		:= '\SYSTEM\DACTE.LOG'	
	Private cArquivo	:= "DACTE.LOG"

	For Y := 1 To Len( aASTMarcado )
	
		SM0->( DbSeek( cEmpAnt + AllTrim( oCTeBrowse:oData:aArray[oCTeBrowse:nAT][01] ) ) )
	
		nPos := aScan( aDadosInfo, { |W| aASTMarcado[Y] == W[1] } )
		
		ProcRegua( Len( aDadosInfo[nPos][2] ) )
		
		For Z := 1 To Len( aDadosInfo[nPos][2] )
						
			DbSelectArea("DT6")
		
			_KeyDT6 := xFilial("DT6")+aDadosInfo[nPos][2][Z][1]+aDadosInfo[nPos][2][Z][2]+aDadosInfo[nPos][2][Z][10]

			MV_PAR53 := aDadosInfo[nPos][2][Z][2]												// Numero do Documento
			MV_PAR54 := aDadosInfo[nPos][2][Z][2]  												// Numero do Documento
			MV_PAR55 := aDadosInfo[nPos][2][Z][10]												//	Serie do Documento Inicial
			MV_PAR56 := aDadosInfo[nPos][2][Z][10]												//	Serie do Documento Final
			MV_PAR57 := GetAdvFval( "DT6", "DT6_DOCTMS", _KeyDT6 , 1 , '' , .T. )
			
			IncProc()
							
			u_RTMSR27()
					
		Next Z
		
  //	_FaturaPrint()				// Impressão da Fatura da AST
		
	Next X
		
	If File( cAnexo )
		u_EnvEmail( cDe , cPara , cCc , cAssunto , cMsg , cAnexo )
		FErase( cAnexo )
	EndIf
	
	MV_PAR53 := ''
	MV_PAR54 := ''
	MV_PAR55 := ''
	MV_PAR56 := ''
	MV_PAR57 := ''
			
	aASTMarcado := {}
	
	oAstBrowse:Refresh()
	
	RestArea( aArea )

Return( Nil )

/*
Programa    : GEFCNHBWS
Funcao      : Static Function _FaturaPrint
Data        : 17/04/2015
Autor       : André Costa
Descricao   : Controle de impressão das Faturas das AST
Sintaxe     : _FaturaPrint()
Chamada		: Interna
*/


Static Function _FaturaPrint   // Andre
	Local aArea := GetArea()
	Local X,Z
	Local nPos
	Local xFilial
	Local xNumDoc
	Local xPrefixo
	Local xSerie
	
	If Len( aASTMarcado )== 0
		Aviso("Atenção","Nenhuma AST marcada para Impressão. Verifique.",{"OK"})
		Return
	EndIf
		
	For X := 1 To Len( aASTMarcado )
	
		nPos := aScan( aDadosInfo, { |W| aASTMarcado[X] == W[1] } )	
			
		If nPos == 0
			Exit
		EndIf
	
		If !( SE1->( DbSeek( xFilial + xPrefixo + xNumDoc ) ) )
			Exit
		EndIf
				
		If !( SA1->( DbSeek( xFilial("SA1") + xCliente + xLoja  ) ) )
			Exit
		EndIf
					
		If !( DT6->( DbSeek( xFilial("DT6")+ xFilial + xNumDoc + xSerie  ) ) )
			Exit
		EndIf

		ProcRegua( Len( aDadosInfo[nPos][2] ) )
		
		SM0->( DbSeek( cEmpAnt + AllTrim( aDadosInfo[nPos][01] ) ) )
		
		xValAST	:= aDadosInfo[nPos][04]						//	Valor AST
		xCliente	:= aDadosInfo[nPos][06]						//	Cliente
		xLoja		:= aDadosInfo[nPos][07]						//	Loja
		xValDes	:= aDadosInfo[nPos][08]						//	Desconto Oferecido
		xFilial	:= aDadosInfo[nPos][2][1][01]				// Filial
		xNumDoc	:= aDadosInfo[nPos][2][1][02]				// Titulo
		xPrefixo	:= aDadosInfo[nPos][2][1][09]				//	Prefixo
		xSerie	:= aDadosInfo[nPos][2][1][10]				//	Serie

		StaticCall( GEFCNHFAT , GEFCNHFAT , xValAST , xValDes , aDadosInfo[nPOS][2]  )
							
		IncProc()
			
	Next X
	
	RestArea( aArea )

Return( Nil )




/*
Programa    : GEFCNHBWS
Funcao      : Static Function _AstMudaCampo
Data        : 17/04/2015
Autor       : André Costa
Descricao   : Controla o change do browse das AST
Sintaxe     : _AstMudaCampo()
Chamada		: Interna
*/

Static Function _AstMudaCampo
	Local nPos

	Begin Sequence

		If ( ValType( oCTeBrowse ) # "O" )
			Break
		EndIf
		
		oCTeBrowse:SetArray(aDadosInfo[oAstBrowse:nAT][2] )
		
		oCTeBrowse:nAT := 1
		
	 	oCTeBrowse:Refresh()
		
	End Sequence
	
Return( .T. )

/*
Programa    : GEFCNHBWS
Funcao      : Static Function _GetAllItens
Data        : 17/04/2015
Autor       : André Costa
Descricao   : Marca / Desmarca todos os itens do browse da AST
Sintaxe     : _GetAllItens()
Chamada		: Interna
*/

Static Function _GetAllItens
	Local aArea		:= GetArea()
	Local aItens	:= {}
	
	For X := 1 To Len( aDadosInfo )
	
		aAdd(aItens, aDadosInfo[X][1]  )
	
	Next X
		   
   oAstBrowse:Refresh()

	RestArea( aArea )
	
Return( aItens )
