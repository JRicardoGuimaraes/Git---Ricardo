#include "totvs.ch"
#include "tbiconn.ch"

Static aLegenda  := {}
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ XMLENT    ºAutor  ³Cristiam Rossi      º Data ³  03/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monitor de XML de entrada p/ integração ao Guarda Fiscal e  º±±
±±º          ³ CT-e (Remoções)                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Itup                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XMLENT( cParam1 )
Local   _aArea    := GetArea()
Local   _aAreaSM0 := SM0->( GetArea() )
Local   aCoors    := FWGetDialogSize( oMainWnd )
Local   oPanelUp, oFWLayer
Local   _cEmpAnt  := cEmpAnt
Local   _cFilAnt  := cFilAnt
Local   aBkpaRot  := iif( Type("aRotina") == "A", aClone( aRotina ), {} )	// Backup do aRotina
Private cCadastro := "Monitoramento de XML de DANFE"
Private oDlgPrinc
Private oBrowseUp

Private bLegend   := {|| fLegend()    }
Private bVincula  := {|| fVincular()  }
Private bPesquisa := {|| fPesquisar() }
Private bRefresh  := {|| fRefresh()   }
Private bDesVinc  := {|| fDesVinc()   }
Private bCancelar := {|| fCancelar()  }
Private bIncluir  := {|| fIncluir()   }
Private bAlterar  := {|| fAlterar()   }
Private bMotorist := {|| fMotorist()  }
Private bItens    := {|| fItens()     }

Default cParam1   := ""

	if Type("aRotina") == "A"
		aSize(aRotina, 0)	// Limpo o conteudo do aRotina
	endif

	dbSelectArea( "ZUC" )

	fTriagem()	// Atualiza os registros

	fCorLeg( "Zerar" )		// Reinicia contador de cores p/ legenda

	Define MsDialog oDlgPrinc Title cCadastro From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

	oFWLayer := FWLayer():New()
	oFWLayer:Init( oDlgPrinc, .F., .T. )
	oFWLayer:AddLine( 'UP', 100, .F. )
	oFWLayer:AddCollumn( 'ALL', 100, .T., 'UP' )
	oPanelUp := oFWLayer:GetColPanel( 'ALL', 'UP' )
//	oBrowseUp:= FWmBrowse():New()
	oBrowseUp := FWMarkBrowse():New()
	oBrowseUp:SetFieldMark( 'ZUC_OK' )

	oBrowseUp:SetOwner( oPanelUp )

// Aqui se associa o browse ao componente de tela
	oBrowseUp:SetDescription( cCadastro )
	oBrowseUp:SetAlias( 'ZUC' )

	oBrowseUp:SetMenuDef( 'XMLENT' )
	oBrowseUp:DisableDetails()

// Define de onde virao os botoes deste browse
//	oBrowseUp:SetProfileID( '1' )
	oBrowseUp:ForceQuitButton()
	oBrowseUp:SetWalkThru(.F.)
	oBrowseUp:SetAmbiente(.F.)

	oBrowseUp:SetOnlyFields( {'ZUC_CHVNFE','ZUC_MOTNOM','ZUC_SERIE','ZUC_DOC','ZUC_CLIP','ZUC_CNPJE','ZUC_RAZAOE','ZUC_CLIEMI','ZUC_LOJAE','ZUC_DTEMIS','ZUC_CNPJD','ZUC_RAZAOD','ZUC_CLIDES','ZUC_LOJAD','ZUC_CFOP','ZUC_CFOPD','ZUC_1PROD','ZUC_DITIN','ZUC_DROTA','ZUC_DTIMP','ZUC_VIAGEM','ZUC_AS'} )

// Filtros e Legenda
	oBrowseUp:AddLegend( "Empty(ZUC_XML)"   , fCorLeg( "Falta Pesquisar Chave"              ), "Falta Pesquisar Chave"              )
	oBrowseUp:AddLegend( "ZUC_STATUS == 'C'", fCorLeg( "Chave Cancelada"                    ), "Chave Cancelada"                    )
	oBrowseUp:AddLegend( "ZUC_STATUS == 'S'", fCorLeg( "Chave sem Vínculo"                  ), "Chave sem Vínculo"                  )
	oBrowseUp:AddLegend( "ZUC_STATUS == 'V'", fCorLeg( "Chave Vinculada"                    ), "Chave Vinculada"                    )
	oBrowseUp:AddLegend( "ZUC_STATUS == 'F'", fCorLeg( "CT-e Gerado"                        ), "CT-e Gerado"                        )
	oBrowseUp:AddLegend( "ZUC_STATUS == 'M'", fCorLeg( "Motorista nao Encontrado"           ), "Motorista nao Encontrado"           )
	oBrowseUp:AddLegend( "ZUC_STATUS == 'E'", fCorLeg( "Cliente Remetente nao Encontrado"   ), "Cliente Remetente nao Encontrado"    )
	oBrowseUp:AddLegend( "ZUC_STATUS == 'D'", fCorLeg( "Cliente Destinatario nao Encontrado"), "Cliente Destinatario nao Encontrado")


// Filtro Padrão
//	_cFil := "ZUC->ZUC_TRIAGE == 'S'"
//	oBrowseUp:SetFilterDefault( _cFil )

	Set Key VK_F5 to oBrowseUp:Refresh()

	oBrowseUp:Activate()

	Activate MsDialog oDlgPrinc Center

	Set Key VK_F5 to 

	aSize(aLegenda, 0)
	
	if len( aBkpaRot ) > 0
		aRotina := aClone( aBkpaRot )
	endif

	RestArea( _aArea )
Return nil


//-------------------------------------
Static Function MenuDef()
Local aRotina := {}
	aAdd( aRotina, { 'Visualizar'         , 'AxVisual'           , 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Pesq.Chave'         , 'Eval(bPesquisa)'    , 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Vincular'           , 'Eval(bVincula)'     , 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Desvincular'        , 'Eval(bDesVinc)'     , 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Incluir'            , 'Eval(bIncluir)'     , 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Cancelar'           , 'Eval(bCancelar)'    , 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Alterar'            , 'Eval(bAlterar)'     , 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Alterar Motorista'  , 'Eval(bMotorist)'    , 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Visualizar Itens'   , 'Eval(bItens)'       , 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Legenda'            , 'Eval(bLegend)'      , 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Refresh (F5)'       , 'Eval(bRefresh)'     , 0, 3, 0, NIL } )

Return aClone(aRotina)


//------------------------------------- Retorna array com os registros selecionados
Static Function RetSel( cCpoParam )
Local   aArea     := GetArea()
Local   aSelecao  := {}
Local   cMarca    := oBrowseUp:Mark()
Local   nPosField
Default cCpoParam := "ZUC_DESCST"

	dbSelectArea( "ZUC" )
	dbGotop()

	nPosField := FieldPos( cCpoParam )

	while ! EOF()
		if ZUC_OK == cMarca
			aadd( aSelecao, { Recno(), ZUC_STATUS, iif(nPosField > 0, FieldGet(nPosField), nil) } )
		endif
		dbSkip()
	end

	RestArea( aArea )
Return aClone( aSelecao )


//------------------------------------- Alterar o Motorista
Static Function ValMoto()

	if Empty( cNewMot )
		cDescMot := ""
		oMotoris:Refresh()
	else
		if ExistCPO("DA4", cNewMot)
			if DA4->DA4_BLQMOT != "1"
				cDescMot := DA4->DA4_NOME
				oMotoris:Refresh()
			else
				MsgStop("Motorista Bloqueado!","Alterar Motorista")
				cDescMot := ""
				oMotoris:Refresh()
				Return .F.
			endif
		else
			cDescMot := ""
			oMotoris:Refresh()
			Return .F.
		endif
	endif

Return .T.


//------------------------------------- Alterar o Motorista
Static Function fMotorist()
Local   aMarcados := RetSel()
Local   lRet      := .F.
Local   nI
//Local   bValid    := {|| iif(ExistCPO("DA4"), ( cDescMot := DA4->DA4_NOME, oMotoris:Refresh() ,.T.), (cDescMot := "", oMotoris:Refresh(),.F.) ) }
Private cNewMot   := CriaVar("ZUC_MOTCOD")
Private oDlg, oMotoris
Private cDescMot  := ""

	if len(aMarcados) == 0
		aadd( aMarcados, { Recno(), ZUC_STATUS, nil } )
	endif

	for nI := 1 to len( aMarcados )
		if aMarcados[nI][2] $ "C;V;F"	// Cancelada, Vinculada ou CT-e Gerado
			MsgAlert("Status invalido, verifique a selecao!","Alteracao de Motorista")
			Return nil
		endif
	next

	DEFINE MSDIALOG oDlg TITLE "Alteracao de Motorista" FROM 0,0 TO 150,450 PIXEL
	@ 010,010 SAY "Motorista:" OF oDlg PIXEL
	@ 021,010 MsGet cNewMot F3 "DA4" Size 50,8 of oDlg Pixel Valid ValMoto()	// Eval( bValid )
	@ 021,070 MsGet oMotoris VAR cDescMot Size 140,8 PIXEL OF oDlg when .F.

	@ 50,120 BUTTON "Fechar"    SIZE 35,14 PIXEL OF oDlg Action oDlg:End()
	@ 50,175 BUTTON "Confirmar" SIZE 35,14 PIXEL OF oDlg Action ( iif( Empty(cNewMot), MsgAlert("Favor preencher Motorista","Motorista obrigatorio"), ( lRet := .T., oDlg:End() ) ) )

	ACTIVATE MSDIALOG oDlg CENTERED  

	if lRet
		for nI := 1 to len( aMarcados )
			ZUC->( dbGoto( aMarcados[nI][1] ) )
			RecLock("ZUC", .F.)
			ZUC_MOTCOD := cNewMot
			ZUC_MOTNOM := cDescMot
			ZUC_OBS    := DtoC(Date()) + " " + Time() + " - " + Alltrim(UsrRetName(__cUserID)) + " - Alteracao Motorista" + CRLF + Alltrim(ZUC_OBS)
			MsUnlock()

			fTriagem( .T. )	// atualizar Status
		next

		oBrowseUp:Refresh()
	endif

Return nil


//-------------------------------------
Static Function fCancelar()

	if ZUC->ZUC_STATUS $ "C;V;F"	// Cancelada, Vinculada ou CT-e Gerado
		MsgAlert("Status invalido, verifique!","Cancelamento")
		Return nil
	endif

	if Aviso("Cancelar Chave","Voce confirma o Cancelamento da Chave posicionada?",{"Ok","Cancela"}) == 1
		RecLock("ZUC", .F.)
		ZUC_STATUS := "C"
		ZUC_OBS    := DtoC(Date()) + " " + Time() + " - " + Alltrim(UsrRetName(__cUserID)) + " - Cancelamento" + CRLF + Alltrim(ZUC->ZUC_OBS)
		MsUnlock()

		oBrowseUp:Refresh()
	endif

Return .T.


//-------------------------------------
Static Function fIncluir()
	if AxInclui( Alias(), Recno(), 3) == 1	// Incluiu
		RecLock("ZUC", .F.)
		ZUC_OBS := DtoC(Date()) + " " + Time() + " - " + Alltrim(UsrRetName(__cUserID)) + " - Inclusao Manual"
		MsUnlock()

		fTriagem( .T. )	// atualizar Status
	endif
Return .T.


//-------------------------------------
Static Function fAlterar()

	if ZUC->ZUC_STATUS $ "C;V;F"	// Cancelada, Vinculada ou CT-e Gerado
		MsgAlert("Status invalido, verifique!","Alteracao")
		Return nil
	endif

	if __cUserID $ SuperGetMV("IT_ALTXML",,"000000;000791")  // Admin e siga
		if AxAltera( Alias(), Recno(), 4) == 1
			RecLock("ZUC", .F.)
			ZUC_OBS := DtoC(Date()) + " " + Time() + " - " + Alltrim(UsrRetName(__cUserID)) + " - Alteracao" + CRLF + Alltrim(ZUC->ZUC_OBS)
			MsUnlock()

			fTriagem( .T. )	// atualizar Status
		endif
	endif
Return .T.


//-------------------------------------
Static Function fRefresh()

	fTriagem()	// Atualiza os registros

	oBrowseUp:Refresh()
Return .T.


//-------------------------------------
Static Function fHeader( cAlias, aCpoSIM )
Local aArea   := GetArea()
Local aHeader := {}
Local aTabAux

	dbSelectArea("SX3")
	dbSetOrder(2)  //X3_ARQUIVO+X3_ORDEM

	for nI := 1 to len( aCpoSIM )
		if dbSeek( aCpoSIM[nI], .T.)
			aTabAux := {}
			AAdd(aTabAux,TRIM(x3Titulo()))		// 1
			AAdd(aTabAux,x3_campo        )
			AAdd(aTabAux,x3_picture      )
			AAdd(aTabAux,x3_tamanho      )
			AAdd(aTabAux,x3_decimal      )		// 5
			AAdd(aTabAux,x3_valid        )
			AAdd(aTabAux,x3_usado        )
			AAdd(aTabAux,x3_tipo         )
			AAdd(aTabAux,x3_f3           )
			AAdd(aTabAux,x3_context      )		// 10
			AAdd(aTabAux,x3_cbox         )
			AAdd(aTabAux,x3_relacao      )
			AAdd(aTabAux,x3_when         )
			AAdd(aTabAux,x3_visual       )		// 14
			AAdd(aTabAux,X3_VLDUSER      )		// 15
			AAdd(aTabAux,X3_PICTVAR      )		// 16
			AAdd(aTabAux,X3_OBRIGAT      )		// 17
			AAdd(aHeader,aTabAux         )
		endif
	next
/*
	while ! EOF() .and. cAlias == X3_ARQUIVO
		if aScan(aCpoSIM, Alltrim(x3_campo) ) > 0 // X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
			aTabAux := {}
			AAdd(aTabAux,TRIM(x3Titulo()))		// 1
			AAdd(aTabAux,x3_campo        )
			AAdd(aTabAux,x3_picture      )
			AAdd(aTabAux,x3_tamanho      )
			AAdd(aTabAux,x3_decimal      )		// 5
			AAdd(aTabAux,x3_valid        )
			AAdd(aTabAux,x3_usado        )
			AAdd(aTabAux,x3_tipo         )
			AAdd(aTabAux,x3_f3           )
			AAdd(aTabAux,x3_context      )		// 10
			AAdd(aTabAux,x3_cbox         )
			AAdd(aTabAux,x3_relacao      )
			AAdd(aTabAux,x3_when         )
			AAdd(aTabAux,x3_visual       )		// 14
			AAdd(aTabAux,X3_VLDUSER      )		// 15
			AAdd(aTabAux,X3_PICTVAR      )		// 16
			AAdd(aTabAux,X3_OBRIGAT      )		// 17
			AAdd(aHeader,aTabAux         )
		endif

		dbSkip()
	end
*/

	RestArea( aArea )
Return aClone(aHeader)


//-------------------------------------
Static Function fVincular()
Local   aArea     := GetArea()
Local   aMarcados := RetSel( "ZUC_CLIEMI+ZUC_LOJAE+ZUC_CLIDES+ZUC_LOJAD+ZUC_MOTCOD" )
Local   lRet      := .F.
Local   oDlg, oCombo
Local   nI, nPos, cQuery
Local   aValid    := {}
Local   cAliasQry := GetNextAlias()
Local   aHeader   := {}
Local   aCbox     := RetSx3Box( GetSx3Cache("ZA7_CARGA","X3_CBOX"),,, 15 )
Private aCols     := {}

	if len(aMarcados) == 0
		aadd( aMarcados, { Recno(), ZUC_STATUS, ZUC_CLIEMI+ZUC_LOJAE+ZUC_CLIDES+ZUC_LOJAD+ZUC_MOTCOD } )
	endif

	for nI := 1 to len( aMarcados )
		if aMarcados[nI][2] != "S"	// Sem Vinculo
			MsgAlert("Status invalido, verifique a selecao!","Vincular Chave")
			Return nil
		endif
		
		nPos := aScan(aValid, aMarcados[nI][3] )
		if nPos == 0
			aadd( aValid, aMarcados[nI][3] )
		endif
	next

	if len( aValid ) != 1
		MsgAlert("Para vinculo multiplo os Clientes Remetente/Destinatario e o Motorista devem ser iguais!. Verifique a selecao!","Vincular Chave")
		Return nil
	endif

	aHeader := fHeader( "DTQ", {"DTQ_DATGER","DTQ_VIAGEM","DTQ_AS","DTQ_SOT","DTQ_OBRA","ZA0_CLINOM","ZA6_DESCRO","ZA3_NOMROT","DUT_DESCRI","ZA7_CARGA"} )			// carga campos do browse da DTQ

	ZUC->( dbGoto( aMarcados[1][1] ) )	// posicionamos no 1o. registro selecionado

// selecionar Viagens....
	cQuery := "select distinct DTQ_VIAGEM, DTQ_DATFEC, DTQ_DATENC, DTQ_STATUS, ZA0_CLINOM"
	cQuery += ", ZA6_DESCRO, ZA3_NOMROT, DUT_DESCRI, ZA7_CARGA"
	cQuery += ", DTQ.R_E_C_N_O_ DTQRECNO, ZA6.R_E_C_N_O_ ZA6RECNO, ZA7.R_E_C_N_O_ ZA7RECNO, ZA3.R_E_C_N_O_ ZA3RECNO"
	cQuery += " from " + RetSqlName("DTQ") + " DTQ (noLock)"
//	cQuery += " join " + RetSqlName("DTC") + " DTC (noLock)"
//	cQuery +=	" on DTC_FILIAL='"+xFilial("DTC")+"' and DTC_SOT=DTQ_SOT and DTC_OBRA=DTQ_OBRA and DTC_VIAGEM=DTQ_VIAGEM"

	cQuery += " join " + RetSqlName("ZA0") + " ZA0 (noLock)"		// Projeto / Orcamento
	cQuery +=	" on ZA0_FILIAL='"+xFilial("ZA0")+"' and ZA0_PROJET=DTQ_SOT and ZA0.D_E_L_E_T_ = ''"

	cQuery += " join " + RetSqlName("ZA6") + " ZA6 (noLock)"		// Cliente Destino
	cQuery +=	" on ZA6_AS=DTQ_AS "
//	cQuery +=	" on ZA6_FILIAL=DTQ_FILORI and ZA6_AS=DTQ_AS and ZA6_VIAGEM=DTQ_VIAGEM"
//	cQuery +=	" on ZA6_AS=DTQ_AS and ZA6_VIAGEM=DTQ_VIAGEM"

	cQuery += " join " + RetSqlName("ZA7") + " ZA7 (noLock)"		// Cliente Origem
//	cQuery +=	" on ZA7_FILIAL='"+xFilial("ZA7")+"' and ZA7_PROJET=DTQ_SOT and ZA7_OBRA=DTQ_OBRA and ZA7_VIAGEM=DTQ_VIAGEM"
	cQuery +=	" on ZA7_PROJET=DTQ_SOT and ZA7_OBRA=DTQ_OBRA and ZA7_VIAGEM=DTQ_VIAGEM"

	cQuery += " join " + RetSqlName("DTR") + " DTR (noLock)"		// Motorista
	cQuery +=	" on DTR_FILIAL='"+xFilial("DTR")+"' and DTR_SOT=DTQ_SOT and DTR_OBRA=DTQ_OBRA and DTR_VIAGEM=DTQ_VIAGEM"

	cQuery += " join " + RetSqlName("ZAM") + " ZAM (noLock)"
	cQuery +=	" on ZAM_PROJET=DTQ_SOT and ZAM_OBRA=DTQ_OBRA and ZAM.D_E_L_E_T_=' '"
//	cQuery +=	" on ZAM_FILIAL=DTQ_FILORI and ZAM_PROJET=DTQ_SOT and ZAM_OBRA=DTQ_OBRA and ZAM.D_E_L_E_T_=' '"

	cQuery += " join " + RetSqlName("ZA3") + " ZA3 (noLock)"
	cQuery +=	" on ZA3_FILIAL='"+xFilial("ZA3")+"' and ZA3_ORIGEM=ZAM_ORIGEM and ZA3_DESTIN=ZAM_DESTIN and ZA3_ROTA=ZAM_ROTA and ZA3.D_E_L_E_T_=' '"

	cQuery += " join " + RetSqlName("DUT") + " DUT (noLock)"
	cQuery +=	" on DUT_FILIAL='"+xFilial("DUT")+"' and DUT_TIPVEI=DTQ_EQUIP and DUT.D_E_L_E_T_=' '"

	cQuery += " where DTQ_FILIAL='"+xFilial("DTQ")+"'"
	cQuery += " and (DTQ_TPAS='T'  or DTQ_TPAS='M')"
	cQuery += " and (DTQ_NUMCTR='' or DTQ_NUMCTR='-')"
	cQuery += " and (DTQ_STATUS != '9'"  
	cQuery += "  or DTQ_STATUS != '1')"

//	cQuery += " and ZA6_CLIORI='"+ZUC->ZUC_CLIEMI+"'"
//	cQuery += " and ZA6_LOJORI='"+ZUC->ZUC_LOJAE +"'"
/*	cQuery += " and ZA6_CLIDES='"+ZUC->ZUC_CLIDES+"'"	// usar o Cliente Destino da ZA6
	cQuery += " and ZA6_LOJDES='"+ZUC->ZUC_LOJAD +"'"

	cQuery += " and ZA7_CODCLI='"+ZUC->ZUC_CLIEMI+"'"	// usar o Cliente Origem da ZA7
	cQuery += " and ZA7_LOJCLI='"+ZUC->ZUC_LOJAE +"'"*/
	
	//Para Ida Emb e Peça
	cQuery += " and (ZA6_CLIDES='"+ZUC->ZUC_CLIDES+"' and ZA6_LOJDES='"+ZUC->ZUC_LOJAD +"' and ZA7_CODCLI='"+ZUC->ZUC_CLIEMI+"' and ZA7_LOJCLI='"+ZUC->ZUC_LOJAE +"')"
    //Para Retorno Emb
    cQuery += "  or (ZA6_CLIDES='"+ZUC->ZUC_CLIEMI+"' and ZA6_LOJDES='"+ZUC->ZUC_LOJAE +"' and ZA7_CODCLI='"+ZUC->ZUC_CLIDES+"' and ZA7_LOJCLI='"+ZUC->ZUC_LOJAD +"')"
	
	
	cQuery += " and DTR_CODMOT='"+ZUC->ZUC_MOTCOD+"'"
	cQuery += " and ZA3_ETAPA='001'"
	cQuery += " and DTQ.D_E_L_E_T_=''"
//	cQuery += " and DTC.D_E_L_E_T_=''"
	cQuery += " and ZA6.D_E_L_E_T_=''"
	cQuery += " and ZA7.D_E_L_E_T_=''"
	cQuery += " and DTR.D_E_L_E_T_=''"	
	cQuery += " Order by DTQ_VIAGEM"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .T.)

	while ! EOF()

		DTQ->( dbGoto( (cAliasQry)->DTQRECNO ) )
		aTmp := {}

		for nI := 1 to len(aHeader)
			if Left(aHeader[nI][2],3) != "DTQ"
				if Trim(aHeader[nI][2]) == "ZA7_CARGA"
					nPos := aScan( aCbox, {|x| Trim(x[2]) == ZA7_CARGA } )
					aadd( aTmp, iif( nPos > 0, aCbox[nPos][3], ZA7_CARGA ) )
				else
					aadd( aTmp, &(aHeader[nI][2]) )
				endif
			else
				aadd( aTmp, DTQ->( FieldGet( FieldPos(aHeader[nI][2] ) ) ) )
			endif
		next
		aadd( aTmp, (cAliasQry)->DTQRECNO )
		aadd( aTmp, (cAliasQry)->ZA6RECNO )
		aadd( aTmp, (cAliasQry)->ZA7RECNO )
		aadd( aTmp, (cAliasQry)->ZA3RECNO )

		aadd( aCols, aTmp )

		dbSkip()
	end
	dbCloseArea()

	if Len(aCols) == 0
		MsgStop("Nao existem Viagens com este Cliente Remetente/Destinatario e Motorista, verifique!","Vincular Chave")
		Return nil
	endif

	DEFINE MSDIALOG oDlg TITLE "Vincular Chave" FROM 0,0 TO 400,800 PIXEL
	
	oBrw := TCBrowse():New(02, 02, (oDlg:nWidth/2)-6, (oDlg:nHeight/2)-30, , , , oDlg, , , , , {||}, , /*oFont*/, , , , , .F., , .T., , .F., , , .F.)

	for nI := 1 to len( aHeader )
//		oBrw:AddColumn(TCColumn():New( aHeader[nI][1], &("{|| aCols[oBrw:nAt]["+Alltrim(Str(nI))+"] }"), aHeader[nI][3],,,"LEFT",,.F.,.F.,,,,.F.))
		oBrw:AddColumn(TCColumn():New( aHeader[nI][1], &("{|| aCols[oBrw:nAt]["+Alltrim(Str(nI))+"] }"), ,,,"LEFT",,.F.,.F.,,,,.F.))
	next
	oBrw:SetArray(aCols)
	oBrw:Refresh(.T.)

	ACTIVATE MSDIALOG oDlg CENTERED On Init EnchoiceBar( oDlg, {|| lRet := .T., nPos := oBrw:nAt, oDlg:End()}, {|| oDlg:End()} )

	if lRet

		DTQ->( dbGoto( aCols[nPos][ Len(aHeader)+1 ] ) )
		ZA6->( dbGoto( aCols[nPos][ Len(aHeader)+2 ] ) )
		ZA7->( dbGoto( aCols[nPos][ Len(aHeader)+3 ] ) )
		ZA3->( dbGoto( aCols[nPos][ Len(aHeader)+4 ] ) )

		for nI := 1 to len( aMarcados )
			ZUC->( dbGoto( aMarcados[nI][1] ) )
			fGravarDTC()
		next

		fTriagem()	// Atualiza os registros

		oBrowseUp:Refresh()
	endif

	RestArea( aArea )
Return .T.


//-------------------------------------
Static Function fDesVinc()
Local   aArea     := GetArea()
Local   aMarcados := RetSel( "ZUC_VIAGEM" )
Local   nI

	if Aviso("Desvincular Chave","Deseja continuar o desvinculo das Chaves marcadas ou posicionada?",{"Sim","Nao"}) != 1
		Return nil
	endif

	if len(aMarcados) == 0
		aadd( aMarcados, { Recno(), ZUC_STATUS, ZUC_VIAGEM } )
	endif

	DTQ->( dbSetOrder(1) )

	for nI := 1 to len( aMarcados )
		if aMarcados[nI][2] != "V"	// Sem Vinculo
			MsgAlert("Status invalido, verifique a selecao!","Desvincular Chave")
			Return nil
		endif

		if Empty( aMarcados[nI][3] )
			MsgAlert("Chave sem Viagem","Nao e possivel desvincular")
			Return nil
		endif

		if ! DTQ->( dbSeek( xFilial("DTQ")+aMarcados[nI][3] ) )
			MsgAlert("Viagem "+aMarcados[nI][3]+" nao encontrada, verifique!" ,"Nao e possivel desvincular")
			Return nil
		endif

		if ! Empty(DTQ->DTQ_NUMCTR) .AND. DTQ->DTQ_NUMCTR != '-'
			MsgAlert("Viagem "+aMarcados[nI][3]+" com CT-e gerado!" ,"Nao e possivel desvincular")
			Return nil
		endif

		aMarcados[nI][3] := DTQ->( Recno() )
	next

	DTC->( dbSetOrder(10) )

	for nI := 1 to len( aMarcados )
		ZUC->( dbGoto( aMarcados[nI][1] ) )
		DTQ->( dbGoto( aMarcados[nI][3] ) )

		// Encontrar DTC e excluir
		DTC->( dbSetOrder(10) )
		If DTC->( DBSeek( xFilial("DTC")+DTQ->(DTQ_SOT+DTQ_OBRA+DTQ_VIAGEM) ) )
			RecLock("DTC", .F.)
			dbDelete()
			MSUnlock()
		EndIf

		// remover ZUC_VIAGEM
		RecLock("ZUC", .F.)
		ZUC_VIAGEM := ""
		ZUC_AS     := ""
		ZUC_CLIPAG := ""
		ZUC_DROTA  := ""
		ZUC_DITIN  := ""
 		ZUC_OBS    := DtoC(Date()) + " " + Time() + " - " + Alltrim(UsrRetName(__cUserID)) + " - Desvinculado" + CRLF + Alltrim(ZUC->ZUC_OBS)
		MSUnlock()

		ZA7->( dbSetOrder(2) )	// ZA7_FILIAL+ZA7_PROJET+ZA7_OBRA+ZA7_VIAGEM+ZA7_SEQTRA+ZA7_SEQCAR
		if ZA7->( dbSeek( DTQ->DTQ_FILORI + DTQ->DTQ_SOT + DTQ->DTQ_OBRA + DTQ->DTQ_VIAGEM, .T. ) )
			AtuZA7( DTQ->DTQ_VIAGEM )	// atualiza Peso e Valor do CT-e
		ENDIF

		fTriagem( .T. )
	next

	oBrowseUp:Refresh()
Return .T.


//-------------------------------------
Static Function fPesquisar()
Local aArea := GetArea()
Local cChamada  := "http://www.guardafiscal.com.br/integracao/itup/index.php" 
Local cChave    := "?key=" + ZUC->ZUC_CHVNFE
Local cAmbiente := SuperGetMV("IT_AMBSEF",,"2")	// 2 eh Homolocacao (SEFAZ)
Local cRetorno  := "&retorno=" + SuperGetMV("IT_HTTP",,"http://54.207.114.39:1254") + "/u_receivexml.apw"
Local lRet      := .T.

	if ZUC->ZUC_STATUS $ "C;V;F"	// Cancelada, Vinculada ou CT-e Gerado
		MsgAlert("Status invalido, verifique!","Pesquisar")
		Return nil
	endif

	if ! Empty(ZUC->ZUC_XML)
		MsgAlert("Esta chave ja foi pesquisada, verifique!","Pesquisar")
		Return nil
	endif

	if U_SIMBuscaXML( ZUC->ZUC_CHVNFE ) .or. ( SZ6->Z6_IDNFE == ZUC->ZUC_CHVNFE .and. !Empty(SZ6->Z6_XML) ) // Pesquisa na SIM
		lRet := ! StaticCall( ReceiveXML, Destrincha, SZ6->Z6_XML )
	endif

	if lRet
		if cAmbiente == "2"
			cChave += "&amb=2"
		endif

		ShellExecute( "Open", cChamada + cChave + cRetorno, "", "C:\", 1 )
	endif

	RestArea( aArea )

Return nil


//-------------------------------------
Static Function fTriagem( lPosic )
Local   aArea := GetArea()
Default lPosic := .F.

	SA1->( dbSetOrder(3) )	// Filial + CGC

	dbSelectArea("ZUC")

	if ! lPosic
		dbGotop()
	endif

	DTQ->( dbSetOrder(1) )

	while ! EOF()

		if ! Empty(ZUC_CFOP) .and. Empty(ZUC_CFOPD)
			RecLock("ZUC", .F.)
			ZUC->ZUC_CFOPD := Tabela("13",ZUC->ZUC_CFOP)
			ZUC->( MsUnlock() )
			dbSelectArea("ZUC")
		endif

		if ! Empty(ZUC->ZUC_DOC) .and. Len(Alltrim(ZUC->ZUC_DOC)) != 9
			// Normalizacao
			RecLock("ZUC", .F.)
		    ZUC->ZUC_DOC    := Right( Replicate("0", 9) + Alltrim(ZUC->ZUC_DOC  ), 9)
		    ZUC->ZUC_SERIE  := Right( Replicate("0", 3) + Alltrim(ZUC->ZUC_SERIE), 3)
		    MsUnlock()
		endif

		if ! Empty( ZUC_VIAGEM )
			if ! DTQ->( dbSeek( xFilial("DTQ")+ZUC->ZUC_VIAGEM ) )	// Viagem nao encontrada
				RecLock("ZUC", .F.)
				ZUC_VIAGEM := ""
				ZUC_AS     := ""
				ZUC_CLIPAG := ""
				ZUC_DROTA  := ""
				ZUC_DITIN  := ""
				ZUC_STATUS := "S"
				ZUC_DESCST := "Chave sem Vínculo"
				MsUnLock()
			else
				if ! Empty(DTQ->DTQ_NUMCTR) .and. Alltrim(DTQ->DTQ_NUMCTR) != '-'		// tem CT-e
					RecLock("ZUC", .F.)
					ZUC_STATUS := "F"
					ZUC_DESCST := "CT-e Gerado"
					MsUnLock()
				else
					RecLock("ZUC", .F.)
					ZUC_STATUS := "V"
					ZUC_DESCST := "Chave Vínculada"
					MsUnLock()
				endif
			endif

			DTC->( dbOrderNickName("DTCCHVNFE") )
			if ! DTC->( dbSeek( ZUC->ZUC_CHVNFE ) )
				RecLock("ZUC", .F.)
				ZUC_VIAGEM := ""
				ZUC_AS     := ""
				ZUC_CLIPAG := ""
				ZUC_DROTA  := ""
				ZUC_DITIN  := ""
				ZUC_STATUS := "S"
				ZUC_DESCST := "Chave sem Vínculo"
				MsUnLock()
			endif
		endif

		if ZUC_STATUS == "V" .and. Empty( ZUC_VIAGEM )
			RecLock("ZUC", .F.)
			ZUC_AS     := ""
			ZUC_STATUS := "S"
			ZUC_CLIPAG := ""
			ZUC_DROTA  := ""
			ZUC_DITIN  := ""
			ZUC_DESCST := "Chave sem Vínculo"
			MsUnLock()
		endif

		if ! ZUC_STATUS $ "C;V;F"	// Diferente de ... Cancelada, Vinculada ou CT-e Gerado

			if Empty( ZUC_CLIEMI )	// Pesquisa Cliente Emitente
				if Empty( ZUC_CNPJE)
					RecLock("ZUC", .F.)
					ZUC_STATUS := "E"
					ZUC_DESCST := "Cliente Remetente nao encontrado"
					MsUnLock()
				else
					if SA1->( dbSeek( xFilial("SA1")+ZUC->ZUC_CNPJE ) )
						RecLock("ZUC", .F.)
						ZUC_CLIEMI := SA1->A1_COD
						ZUC_LOJAE  := SA1->A1_LOJA
						ZUC_STATUS := "S"
						ZUC_DESCST := "Chave sem Vínculo"
						MsUnLock()
					Else
						RecLock("ZUC", .F.)
						ZUC_STATUS := "E"
						ZUC_DESCST := "Cliente Remetente nao encontrado"
						MsUnLock()
					endif
				endif
			else
				if ZUC_STATUS == "E"
					RecLock("ZUC", .F.)
					ZUC_STATUS := "S"
					ZUC_DESCST := "Chave sem Vínculo"
					MsUnLock()
				endif
			endif


			if Empty( ZUC_CLIDES )		// Pesquisa Cliente Destino
				if Empty( ZUC_CNPJD)
					if ZUC_STATUS != "E"
						RecLock("ZUC", .F.)
						ZUC_STATUS := "D"
						ZUC_DESCST := "Cliente Destinatario nao encontrado"
						MsUnLock()
					endif
				else
					if SA1->( dbSeek( xFilial("SA1")+ZUC->ZUC_CNPJD ) )
						RecLock("ZUC", .F.)
						ZUC_CLIDES := SA1->A1_COD
						ZUC_LOJAD  := SA1->A1_LOJA
						if ZUC_STATUS != "E"
							ZUC_STATUS := "S"
							ZUC_DESCST := "Chave sem Vínculo"
						endif
						MsUnLock()
					Else
						if ZUC_STATUS != "E"
							RecLock("ZUC", .F.)
							ZUC_STATUS := "D"
							ZUC_DESCST := "Cliente Destinatario nao encontrado"
							MsUnLock()
						endif
					endif
				endif
			else
				if ZUC_STATUS != "E"
					RecLock("ZUC", .F.)
					ZUC_STATUS := "S"
					ZUC_DESCST := "Chave sem Vínculo"
					MsUnLock()
				endif
			endif


			if Empty( ZUC_MOTCOD )	// Pesquisa Motorista
				if Empty( ZUC_USER )
					if ! ZUC_STATUS $ "E;D"
						RecLock("ZUC", .F.)
						ZUC_STATUS := "M"
						ZUC_DESCST := "Motorista nao Encontrado"
						MsUnLock()
					endif
				else
					DA4->( dbSetOrder(3) )	// Filial + CGC
//					if DA4->( dbSeek( xFilial("DA4") + Alltrim(ZUC->ZUC_USER) ) )
					if DA4->( dbSeek( xFilial("DA4") + Alltrim(ZUC->ZUC_CPF) ) )
						RecLock("ZUC", .F.)
						ZUC_MOTCOD := DA4->DA4_COD
						ZUC_MOTNOM := DA4->DA4_NOME
						if ! ZUC_STATUS $ "E;D"
							ZUC_STATUS := "S"
							ZUC_DESCST := "Chave sem Vínculo"
						endif
						MsUnlock()
					else
						if ! ZUC_STATUS $ "E;D"
							RecLock("ZUC", .F.)
							ZUC_STATUS := "M"
							ZUC_DESCST := "Motorista nao Encontrado"
							MsUnLock()
						endif
					endif
				endif
			else
				DA4->( dbSetOrder(1) )	// Filial + Cod
				if DA4->( dbSeek( xFilial("DA4") + ZUC->ZUC_MOTCOD ) ) .and. DA4->DA4_BLQMOT != "1"
					if ! ZUC_STATUS $ "E;D"
						RecLock("ZUC", .F.)
						ZUC_STATUS := "S"
						ZUC_DESCST := "Chave sem Vínculo"
						MsUnLock()
					endif
				else
					RecLock("ZUC", .F.)
					ZUC_MOTCOD := ""
					ZUC_MOTNOM := ""
					if ! ZUC_STATUS $ "E;D"
						ZUC_STATUS := "M"
						ZUC_DESCST := "Motorista nao Encontrado"
					endif
					MsUnlock()
                endif
			endif

		endif

		if lPosic
			exit
		else
    		dbSkip()
		endif
    end

	RestArea( aArea )
Return nil


//-------------------------------------
Static Function fLegend()
	BrwLegenda( cCadastro, "Legenda do XML", aLegenda )
Return .T.


//-------------------------------------
Static Function fCorLeg( cAcao )
Local   cCor
Local   aCores  := {'BR_AZUL','BR_CINZA','BR_AMARELO','BR_VERDE','fwocn_chk_ckd','BR_VERMELHO','BR_LARANJA','BR_PINK','br_verde_escuro','br_azul_claro','BR_BRANCO','BR_MARROM','BR_AZUL'}
Static  nLast   := 1
Default cAcao   := ""

	if cAcao == "Zerar"
		nLast := 1
		Return nil
	endif

	if nLast > Len(aCores)
		nLast := 2
	endif

	cCor := aCores[ nLast++ ]

	aadd( aLegenda, { cCor, cAcao } )		// Adiciona na Legenda

Return cCor


//-------------------------------------
Static Function fGravarDTC()
Local nI

	RegToMemory("DTC", .T., .T., .T.)
    M->DTC_FILIAL := xFilial("DTC")
    M->DTC_FILORI := DTQ->DTQ_FILORI
	M->DTC_SOT    := DTQ->DTQ_SOT
	M->DTC_OBRA   := DTQ->DTQ_OBRA
	M->DTC_VIAGEM := DTQ->DTQ_VIAGEM
	M->DTC_NUMNFC := ZUC->ZUC_DOC
	M->DTC_SERNFC := ZUC->ZUC_SERIE
	M->DTC_EMINFC := ZUC->ZUC_DTEMIS
	M->DTC_QTDVOL := ZUC->ZUC_VOLUME
	M->DTC_PESO   := ZUC->ZUC_PESO
	M->DTC_VALOR  := ZUC->ZUC_VLNF
	M->DTC_NFEID  := ZUC->ZUC_CHVNFE
	M->DTC_CF     := ZUC->ZUC_CFOP
	M->DTC_CLIREM := ZUC->ZUC_CLIEMI
	M->DTC_LOJREM := ZUC->ZUC_LOJAE
	M->DTC_CLIDES := ZUC->ZUC_CLIDES
	M->DTC_LOJDES := ZUC->ZUC_LOJAD
	M->DTC_CLICON := iif( ZA6->ZA6_TPFRETE == "F", ZUC->ZUC_CLIDES, ZUC->ZUC_CLIEMI )
	M->DTC_LOJCON := iif( ZA6->ZA6_TPFRETE == "F", ZUC->ZUC_LOJAD , ZUC->ZUC_LOJAE  )
	M->DTC_CLICAL := iif( ZA6->ZA6_TPFRETE == "F", ZUC->ZUC_CLIDES, ZUC->ZUC_CLIEMI )
	M->DTC_LOJCAL := iif( ZA6->ZA6_TPFRETE == "F", ZUC->ZUC_LOJAD , ZUC->ZUC_LOJAE  )
	M->DTC_CLIDEV := iif( ZA6->ZA6_TPFRETE == "F", ZUC->ZUC_CLIDES, ZUC->ZUC_CLIEMI )
	M->DTC_LOJDEV := iif( ZA6->ZA6_TPFRETE == "F", ZUC->ZUC_LOJAD , ZUC->ZUC_LOJAE  )
	M->DTC_CCONT  := Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_CCCLIE')//ZA6->ZA6_CCCLIE
	M->DTC_CCUSTO := Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_CCGEFC')//ZA6->ZA6_CCGEFC
	M->DTC_OI     := Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_OI')//ZA6->ZA6_OI
	M->DTC_CONTA  := Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_CONTA')//ZA6->ZA6_CONTA
	M->DTC_TIPDES := Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_TIPDES')//ZA6->ZA6_TIPDES
	M->DTC_REFGEF := Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_REFGEF')//ZA6->ZA6_REFGEF
	M->DTC_DPROD  := Posicione("SB1",1,xFilial("SB1")+M->DTC_CODPRO,"B1_DESC")
                                             
	RecLock("DTC", .T.)
	for nI := 1 to FCount()
		FieldPut( nI, &("M->"+FieldName(nI)) )
	next
	MsUnlock()


	ZA0->( dbSetOrder(1) )		// Projeto
	ZA0->( dbSeek( DTQ->DTQ_FILORI + DTQ->DTQ_SOT ) )

	RecLock("ZUC", .F.)
	ZUC_VIAGEM := DTQ->DTQ_VIAGEM
	ZUC_AS     := DTQ->DTQ_AS
	ZUC_CLIPAG := ZA0->ZA0_CLINOM
	ZUC_DROTA  := ZA6->ZA6_DESCRO
	ZUC_DITIN  := ZA3->ZA3_NOMROT
	ZUC_OBS    := DtoC(Date()) + " " + Time() + " - " + Alltrim(UsrRetName(__cUserID)) + " - Vinculado" + CRLF + Alltrim(ZUC->ZUC_OBS)
	MsUnlock()

	AtuZA7( DTC->DTC_VIAGEM )	// atualiza Peso e Valor do CT-e
	
Return nil


//-------------------------------------
Static Function AtuZA7( cViagem )
Local aArea  := GetArea()
Local nValor := 0
Local nPeso  := 0

	DTC->( dbOrderNickName("DTCIND09") )
	DTC->( dbSeek( xFilial("DTC") + cViagem ) )
	while ! DTC->( EOF() ) .and. DTC->DTC_FILIAL==xFilial("DTC") .and. DTC->DTC_VIAGEM==cViagem

		nValor += DTC->DTC_VALOR
		nPeso  += DTC->DTC_PESO

		DTC->( dbSkip() )
	end
	DTC->( dbSeek( xFilial("DTC") + cViagem ) )

	RecLock("ZA7", .F.)
	ZA7_VRCARG := nValor
	ZA7_PESO   := nPeso
	MsUnlock()
	
	
	RecLock("DTQ",.F.)
		
	DTQ->DTQ_BASADV	:=	nValor
	DTQ->DTQ_VALADV	:=	(DTQ->DTQ_BASADV * (DTQ->DTQ_PERADV/100))	 

	addValor()
	
	DTQ->(MsUnlock())

	RestArea( aArea )
Return nil


//------------------------------------ Parte do Calculo dos Impostos do Frete
Static Function AddValor()
Local aRetorno

	aRetorno  := fCalcImposto( { { 1, DTQ->DTQ_XFRETE+DTQ->DTQ_VRPEDA+DTQ->DTQ_VROUTR },{1, DTQ->DTQ_VALADV} } )
	DTQ->DTQ_VLRINF	:= aRetorno[1]
	DTQ->DTQ_VALICM	:= aRetorno[2]
	DTQ->DTQ_BASICM := aRetorno[3]

	If SubStr(DTQ->DTQ_ORIGEM,Len(Trim(DTQ->DTQ_ORIGEM))-1,2) == "PR"	// nao incidir Valor do Pedagio na Base do ICMS no estado do Parana - Cristiam Rossi em 18/08/2015
		DTQ->DTQ_BASICM := aRetorno[3]-DTQ->DTQ_VRPEDA
	EndIf 

	aRetorno        := fCalcImposto( { { 1, DTQ->DTQ_XFRETE } } )
	DTQ->DTQ_TOTFRE := aRetorno[1]			// Frete Peso

Return nil


//-------------------------------------
Static Function fCalcImposto( aItens )		// { qtde, valor }
Local nI
Local aArea     := getArea()
Local aAreaDTC  := DTC->( getArea() )
Local aRet      := { 0, 0, 0}
Local _CTRCProd := getMV("MV_CTRCPRO")
Local cTes      := DTQ->DTQ_TES

	DTC->( dbSetOrder(11) )
	DTC->( dbSeek( xFilial("DTC") + DTQ->DTQ_VIAGEM ) )

	MaFisSave()

	MaFisEnd()
	MaFisIni( DTC->DTC_CLIDEV, DTC->DTC_LOJDEV, "C", "N" /*tipo da NF*/, Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIDEV+DTC->DTC_LOJDEV,"A1_TIPO"),nil,nil,nil,nil,"MATA461")

	for nI := 1 to len( aItens )
		MaFisAdd( _CTRCProd, cTes, aItens[nI][1] /*quantidade*/, aItens[nI][2], 0, "", "", 0, 0, 0, 0, 0, aItens[nI][2] * aItens[nI][1], 0 )
	next

	aRet[1] := MaFisRet(, "NF_TOTAL"   )
	aRet[2] := MaFisRet(, "NF_VALICM"  )
	aRet[3] := MaFisRet(, "NF_BASEICM" )

	MaFisEnd()
	MaFisRestore()

	DTC->( restArea( aAreaDTC ) )
	restArea( aArea )

Return aClone( aRet )


//-------------------------------------
Static Function fItens()
Local aArea  := GetArea()
Local oDlg, oList
Local aItens := {}

	ZUD->( dbSetOrder(2) )
	ZUD->( dbSeek( xFilial("ZUD") + ZUC->ZUC_ID, .T.) )
	
	while ! ZUD->( EOF() ) .and. ZUD->ZUD_FILIAL == xFilial("ZUD") .and. ZUD->ZUD_IDORIG == ZUC->ZUC_ID

		aadd( aItens, { ZUD->ZUD_SEQ ,;
						ZUD->ZUD_NOMPF ,;
						ZUD->ZUD_UMF ,;
						ZUD->ZUD_QTDF ,;
						ZUD->ZUD_VLUNIT})
		ZUD->( dbSkip() )
	end

	if Len(aItens) == 0
		MsgStop("Nao foram encontrados itens nesta chave, verifique!","Visualizar Itens da DANFE")
		RestArea( aArea )
		Return nil
	endif

	DEFINE MSDIALOG oDlg TITLE "Visualizar Itens da DANFE" FROM 0,0 TO 400,800 PIXEL

	@ 02,02 LISTBOX oList VAR cVarGrp FIELDS HEADER 'Seq','Produto','UM','Qtde','Valor Unit' SIZE (oDlg:nWidth/2)-6,(oDlg:nHeight/2)-30 OF oDlg PIXEL

	oList:SetArray(aItens)
	oList:bLine := {||{	aItens[oList:nAt,1],;
						aItens[oList:nAt,2],;
						aItens[oList:nAt,3],;
						Transform( aItens[oList:nAt,4], "@E 9,999,999.99" ),;
						Transform( aItens[oList:nAt,5], "@E 999,999,999,999.99" )}}

	ACTIVATE MSDIALOG oDlg CENTERED On Init EnchoiceBar( oDlg, {|| oDlg:End()}, {|| oDlg:End()} )

	RestArea( aArea )
Return nil


//-------------------------------------
User Function XmlVal()
Local aArea := GetArea()
/*
Chave do DANFE: 42100484684182000157550010000000020108042108
42- código do estado emissor ( 42 corresponde a SC)
42-10/04 ano/mês
42-10/04-84.684.182/0001-57 CNPJ
42-10/04-84.684.182/0001-57-55- modelo do documento
42-10/04-84.684.182/0001-57-55-001- serie da nota fiscal
42-10/04-84.684.182/0001-57-55-001-000.000.002- numero da nota
42-10/04-84.684.182/0001-57-55-001-000.000.002-010.804.210- numero a ser utilizado pelo contribuinte emissor da nota fiscal, sugerido fazer criptografia
*/
	if len( Alltrim(M->ZUC_CHVNFE) ) != 44
		MsgStop("Verifique a chave digitada, possui tamanho errado","Chave Invalida")
		Return .F.
	endif

	ZUC->( dbSetOrder(2) )
	if ZUC->( dbSeek( xFilial("ZUC") + Alltrim(M->ZUC_CHVNFE)) )
		MsgStop("A chave digitada já existe na base, verifique!","Chave Existente")
		RestArea( aArea )
		Return .F.
	endif

	if ! Empty(M->ZUC_CNPJE) .and. M->ZUC_CNPJE != Substr( M->ZUC_CHVNFE,  7, 14)
		if Aviso("CNPJ Cliente Emissor","Esta chave nao pertence ao CNPJ do Cliente Emissor, continua? Neste caso sera substituido o Cliente Emissor",{"Ok","Cancela"}) != 1
			RestArea( aArea )
			Return .F.
		endif

		M->ZUC_CNPJE  := Substr( M->ZUC_CHVNFE,  7, 14)
		SA1->( dbSetOrder(3) )
		if SA1->( dbSeek( xFilial("SA1")+M->ZUC_CNPJE ) )
			M->ZUC_CLIEMI := SA1->A1_COD
			M->ZUC_LOJAE  := SA1->A1_LOJA
			M->ZUC_RAZAOE := SA1->A1_NOME
		else
			M->ZUC_CLIEMI := Space( Len( SA1->A1_COD  ) )
			M->ZUC_LOJAE  := Space( Len( SA1->A1_LOJA ) )
			M->ZUC_RAZAOE := Space( Len( SA1->A1_NOME ) )
		endif
	endif

    M->ZUC_DOC    := Substr( M->ZUC_CHVNFE, 26, 9)
	M->ZUC_SERIE  := Substr( M->ZUC_CHVNFE, 23, 3)

	RestArea( aArea )
Return .T.


//----------------------------------------------
User Function VincXML()
Local aArea     := GetArea()
Local lRet      := .F.
Local cAliasQry := GetNextAlias()
Local cQuery, oDlg, oList, nI, nJ, aTmp
Local aChaves   := {}
Local oOk       := LoadBitmap( GetResources(), "LBOK")
Local oNo       := LoadBitmap( GetResources(), "LBNO")  

Local cCliEmi   := cCodRem
Local cLojEmi   := cLojRem
Local cCliDes   := cCodDes
Local _cLojDes  := cLojDes
Local cCodMoto  := ""

	for nI := 1 to len( oDlgVei:aCols )
		if ! aTail( oDlgVei:aCols[nI] )
			cCodMoto := gdFieldGet("DTR_CODMOT", nI, .F., oDlgVei:aHeader, oDlgVei:aCols)
			if ! Empty( cCodMoto )
				exit
			endif
		endif
	next

	if Empty( cCliEmi )
		ZA7->( dbSetOrder(2) )
		if ZA7->( dbSeek( cFilOri + cProjeto + cObra + cViagem, .T. ) )
			cCliEmi := ZA7->ZA7_CODCLI
			cLojEmi := ZA7->ZA7_LOJCLI
		endif
	endif
	if Empty( cCliEmi )
		MsgAlert("Favor preencher Cliente Remetente","Falta informacao")
		Return nil
	endif


	if Empty( cCliDes )
		ZA6->( dbSetOrder(2) )
		if ZA6->( dbSeek( cFilOri + cNoAs + cViagem ) )
			cCliDes  := ZA6->ZA6_CLIDES
			_cLojDes := ZA6->ZA6_LOJDES
		endif
	endif
	if Empty( cCliDes )
		MsgAlert("Favor preencher Cliente Destinatario","Falta informacao")
		Return nil
	endif

	if Empty( cCodMoto )
		MsgAlert("Favor preencher Motorista","Falta informacao")
		Return nil
	endif

	cQuery := "select ZUC.R_E_C_N_O_ ZUCRECNO from "+RetSqlName("ZUC")+" ZUC"
	cQuery += " where ZUC_FILIAL='"+xFilial("ZUC")+"'"
	cQuery += " and ZUC_STATUS='S'"
	cQuery += " and ZUC_CLIEMI='"+cCliEmi+"'"
	cQuery += " and ZUC_LOJAE='"+cLojEmi+"'"
	cQuery += " and ZUC_CLIDES='"+cCliDes+"'"
	cQuery += " and ZUC_LOJAD='"+_cLojDes+"'"
	cQuery += " and ZUC_MOTCOD='"+cCodMoto+"'"
	cQuery += " and ZUC.D_E_L_E_T_=''"
	cQuery += " order by ZUC_CHVNFE"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .T.)

	while ! EOF()

		ZUC->( dbGoto( (cAliasQry)->ZUCRECNO ) )

		aadd( aChaves, {.F.,;
						ZUC->ZUC_DOC    ,;
						ZUC->ZUC_SERIE  ,;
						ZUC->ZUC_DTEMIS ,;
						ZUC->ZUC_VLNF   ,;
						ZUC->ZUC_VOLUME ,;
						ZUC->ZUC_CFOP   ,;
						ZUC->ZUC_CFOPD  ,;
						ZUC->ZUC_1PROD  ,;
						ZUC->ZUC_CHVNFE ,;
						(cAliasQry)->ZUCRECNO })
		dbSkip()
	end
	dbCloseArea()

	if Len(aChaves) == 0
		MsgStop("Nao existem Chaves para este Cliente Remetente/Destinatario e Motorista, verifique!","Vincular Chave")
		RestArea( aArea )
		Return nil
	endif

	DEFINE MSDIALOG oDlg TITLE "Vincular Chave" FROM 0,0 TO 400,800 PIXEL

	@ 02,02 LISTBOX oList VAR cVarGrp FIELDS HEADER '','Documento','Serie','Emissao','Valor','Volumes','CFOP','Nat. Operacao','1o.Produto','Chave' SIZE (oDlg:nWidth/2)-6,(oDlg:nHeight/2)-30 ON DBLCLICK ( aChaves[oList:nAt][1] := ! aChaves[oList:nAt][1], oList:Refresh()) OF oDlg PIXEL

	oList:SetArray(aChaves)
	oList:bLine := {||{	iif(aChaves[oList:nAt, 1],oOk,oNo),;
							aChaves[oList:nAt, 2],;
							aChaves[oList:nAt, 3],;
							aChaves[oList:nAt, 4],;
							aChaves[oList:nAt, 5],;
							Transform( aChaves[oList:nAt,6], "@E 999,999,999,999.99" ),;
							aChaves[oList:nAt, 7],;
							aChaves[oList:nAt, 8],;
							aChaves[oList:nAt, 9],;
							aChaves[oList:nAt,10],;
							aChaves[oList:nAt,11] }}

	ACTIVATE MSDIALOG oDlg CENTERED On Init EnchoiceBar( oDlg, {|| lRet := .T., oDlg:End()}, {|| oDlg:End()} )

    if lRet

		ZA6->( dbSetOrder(2) )
		ZA6->( dbSeek( cFilOri + cNoAs + cViagem ) )

		for nI := 1 to len( aChaves )
    		if aChaves[nI][1]

    			aTmp := {}
    			for nJ := 1 to len( oDlgNot:aHeader )

					ZUC->( dbGoto( aTail(aChaves[nI]) ) )

    				cCampo := Alltrim( oDlgNot:aHeader[nJ][2] )
    				aadd(aTmp, CriaVar( cCampo ) )

    				do Case
    					Case cCampo == "DTC_NUMNFC"
    						aTail(aTmp) := ZUC->ZUC_DOC
    					Case cCampo == "DTC_SERNFC"
    						aTail(aTmp) := ZUC->ZUC_SERIE
    					Case cCampo == "DTC_EMINFC"
    						aTail(aTmp) := ZUC->ZUC_DTEMIS
    					Case cCampo == "DTC_QTDVOL"
    						aTail(aTmp) := ZUC->ZUC_VOLUME
    					Case cCampo == "DTC_PESO"
    						aTail(aTmp) := ZUC->ZUC_PESO
    					Case cCampo == "DTC_VALOR"
    						aTail(aTmp) := ZUC->ZUC_VLNF
    					Case cCampo == "DTC_NFEID"
    						aTail(aTmp) := ZUC->ZUC_CHVNFE
    					Case cCampo == "DTC_CF"
    						aTail(aTmp) := ZUC->ZUC_CFOP
    					Case cCampo == "DTC_CLIREM"
    						aTail(aTmp) := ZUC->ZUC_CLIEMI
    					Case cCampo == "DTC_LOJREM"
    						aTail(aTmp) := ZUC->ZUC_LOJAE
    					Case cCampo == "DTC_NOMREM"
    						aTail(aTmp) := ZUC->ZUC_RAZAOE
    					Case cCampo == "DTC_CLIDES"
    						aTail(aTmp) := ZUC->ZUC_CLIDES
    					Case cCampo == "DTC_LOJDES"
    						aTail(aTmp) := ZUC->ZUC_LOJAD
    					Case cCampo == "DTC_NOMDES"
    						aTail(aTmp) := ZUC->ZUC_RAZAOD
    					Case cCampo == "DTC_CCONT"
    						aTail(aTmp) := Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_CCCLIE')//ZA6->ZA6_CCCLIE
    					Case cCampo == "DTC_CCUSTO"
    						aTail(aTmp) := Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_CCGEFC')//ZA6->ZA6_CCGEFC
    					Case cCampo == "DTC_OI"
    						aTail(aTmp) := Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_OI')//ZA6->ZA6_OI
    					Case cCampo == "DTC_CONTA"
    						aTail(aTmp) := Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_CONTA')//ZA6->ZA6_CONTA
    					Case cCampo == "DTC_TIPDES"
    						aTail(aTmp) := Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_TIPDES')//ZA6->ZA6_TIPDES
    					Case cCampo == "DTC_REFGEF"
    						aTail(aTmp) := Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_REFGEF')//ZA6->ZA6_REFGEF
    					Case cCampo == "DTC_TIPFRE"
    						aTail(aTmp) := cTipo
    					Case cCampo == "DTC_DESEMB"
    						aTail(aTmp) := TABELA("MG", CriaVar( "DTC_CODEMB" ),.F.)
    					Case cCampo == "DTC_CLIDEV"
    						aTail(aTmp) := cCodCon
    					Case cCampo == "DTC_LOJDEV"
    						aTail(aTmp) := cLojCon
    					Case cCampo == "DTC_NOMDEV"
    						aTail(aTmp) := cDesCon
    					Case cCampo == "DTC_DPROD"
    						aTail(aTmp) := Posicione("SB1",1,xFilial("SB1")+CriaVar("DTC_CODPRO"),"B1_DESC")
    				endCase
    			next

    			aadd( aTmp, .F. )

				if Empty( gdFieldGet("DTC_NFEID", oDlgNot:oBrowse:nAt, .F., oDlgNot:aHeader, oDlgNot:aCols) )
					oDlgNot:aCols[oDlgNot:oBrowse:nAt] := aClone(aTmp)
				else
					aadd( oDlgNot:aCols, aClone(aTmp) )
				endif

    		endif
		next
		oDlgNot:oBrowse:nAt := 1
		oDlgNot:oBrowse:Refresh()
	endif

	RestArea( aArea )
Return nil


//----------------------------------------------
User Function TratXML( cOper )
Local   nI
Local   cChvTmp
Default cOper   := ""

	if cOper == "GRV"

		DTQ->( dbSetOrder(1) )	// AS
		DTQ->( dbSeek( xFilial("DTQ") + cViagem ) )

		Begin Transaction

		for nI := 1 to len( oDlgNot:aCols )

			cChvTmp := gdFieldGet("DTC_NFEID", nI, .F., oDlgNot:aHeader, oDlgNot:aCols)

			if ! Empty( cChvTmp )

				ZUC->( dbSetOrder(2) )
				if ZUC->( dbSeek( xFilial("ZUC")+cChvTmp ) )
					if aTail( oDlgNot:aCols[nI] )		// Deletada
						if ZUC->ZUC_VIAGEM == cViagem
							RecLock("ZUC", .F.)
							ZUC_VIAGEM := ""
							ZUC_AS     := ""
							ZUC_CLIPAG := ""
							ZUC_DROTA  := ""
							ZUC_DITIN  := ""
							ZUC_STATUS := "S"
							ZUC_DESCST := "Chave sem vinculo"
							ZUC_OBS    := DtoC(Date()) + " " + Time() + " - " + Alltrim(UsrRetName(__cUserID)) + " - Desvinculo" + CRLF + Alltrim(ZUC->ZUC_OBS)
							MsUnlock()
						endif
					else								// Linha Ativa
						if ! Empty(ZUC->ZUC_VIAGEM) .and. ZUC->ZUC_VIAGEM != cViagem .and. Empty(DTQ->DTQ_CTRORI)	// nao consistir se CT-e for Complementar
							MsgStop("A chave "+ZUC->ZUC_CHVNFE+" esta vinculada em outro registro","Chave invalida")
					  		DisarmTransaction()
							Return .F.
						endif

//						if Empty(ZUC->ZUC_VIAGEM)

							ZA0->( dbSetOrder(1) )	// Projeto
							ZA0->( dbSeek( cFilOri + cProjeto ) )

							ZAM->( dbSetOrder(1) )		// Itinerarios
							ZAM->( dbSeek( DTQ->DTQ_FILORI + DTQ->DTQ_SOT + DTQ->DTQ_OBRA, .T.) )
						
							ZA3->( dbSetOrder(1) )		// Itinerarios
							ZA3->( dbSeek( xFilial("ZA3") + ZAM->ZAM_ORIGEM + ZAM->ZAM_DESTIN + ZAM->ZAM_ROTA, .T.) )

							DA8->( dbSetOrder(1) )	// Rota
							DA8->( dbSeek( xFilial("DA8") + ZAM->ZAM_ROTA ) )

							RecLock("ZUC", .F.)
							ZUC_CLIPAG := ZA0->ZA0_CLINOM
							ZUC_VIAGEM := cViagem
							ZUC_AS     := cNoAs
							ZUC_DROTA  := DA8->DA8_DESC
							ZUC_DITIN  := ZA3->ZA3_NOMROT
							ZUC_STATUS := "V"
							ZUC_DESCST := "Chave Vinculada"
							ZUC_OBS    := DtoC(Date()) + " " + Time() + " - " + Alltrim(UsrRetName(__cUserID)) + " - Vinculado" + CRLF + Alltrim(ZUC->ZUC_OBS)
							MsUnlock()

//						endif
                    endif

				endif
			endif
        next

		End Transaction

	endif

Return .T.



//--------------------------------------------------
User Function JOBXMLSIM( lJOB )
Local   lBusca := .F.
Default lJOB   := .T.

	ConOut( "JOBXMLSIM - Inicio em "+DtoC( Date() )+" "+Time() + " " + iif(lJOB, "JOB", UsrRetName(__cUserID) ) )

	if lJOB
		RPCSetType(3)	// Não consumir licença.
		Prepare Environment Empresa "01" Filial "01"
	endif

	if ! LockByName("JOBXMLSIM", .F., .F.)		//	Semáforo, caso job esteja em execução finaliza esta chamada
		ConOut( "Job em execucao, encerrando rotina - XMLENT.PRW( JOBXMLSIM ) em "+DtoC( Date() )+" "+Time() )
		Return nil
	endif

	SZ6->( dbSetOrder(2) )	// Filial + CHVNFE

	dbSelectArea("ZUC")
	dbGotop()

	while ! ZUC->( EOF() )

		if ZUC_STATUS $ "C;V;F"		// nao fazer pra Chave Cancelada, Vinculada ou Finalizada
			ZUC->( dbSkip() )
			Loop
		endif

		if ! Empty( ZUC->ZUC_CHVNFE ) .and. Empty( ZUC->ZUC_XML )	// tem chave e nao tem XML
			if SZ6->( dbSeek( xFilial("SZ6") + ZUC->ZUC_CHVNFE ) )
				lBusca := Empty( SZ6->Z6_XML )
			else
				lBusca := .T.
			endif

			if lBusca
				lRet := U_SIMBuscaXML( ZUC->ZUC_CHVNFE )	// ele retorna, mas posso pegar numa segunda vez...
			else
				aArea := GetArea()

				lRet := StaticCall( ReceiveXML, Destrincha, SZ6->Z6_XML )

				RestArea( aArea )
			endif
		endif

		ZUC->( dbSkip() )
	end

	fTriagem()	// rastreia os Status

	UnLockByName("JOBXMLSIM", .F., .F.)		// liberação do semáforo

	ConOut( "JOBXMLSIM - Termino em "+DtoC( Date() )+" "+Time() )

Return nil



//--------------------------------------------------
User Function JTaskuMov( lJOB )
Local   lBusca    := .F.
Local   cAliasQry := GetNextAlias()
Default lJOB      := .T.

	ConOut( "JTaskuMov - Inicio em "+DtoC( Date() )+" "+Time() + " " + iif(lJOB, "JOB", UsrRetName(__cUserID) ) )

	if lJOB
		RPCSetType(3)	// Não consumir licença.
		Prepare Environment Empresa "01" Filial "01"
	endif

	if ! LockByName("JTASKUMOV", .F., .F.)		//	Semáforo, caso job esteja em execução finaliza esta chamada
		ConOut( "Job em execucao, encerrando rotina - XMLENT.PRW( JTASKUMOV ) em "+DtoC( Date() )+" "+Time() )
		Return nil
	endif

	cQuery := "select ZUC.ZUC_USER, ZUC.ZUC_PLACA, "
	cQuery +=		" SF2.R_E_C_N_O_ SF2RECNO,"
	cQuery += 		" DTQ.R_E_C_N_O_ DTQRECNO"
	cQuery += " from "+ RetSqlName("DTQ") +" DTQ "
	cQuery += 		" join "+ RetSqlName("SF2")+ " SF2 on F2_FILIAL=DTQ_FILORI and F2_DOC=DTQ_NUMCTR and F2_SERIE=DTQ_SERCTR and SF2.D_E_L_E_T_=''"
	cQuery += 		" join "+ RetSqlName("ZUC")+ " ZUC on ZUC.R_E_C_N_O_ = "
	cQuery += 				"( select top 1 ZUC1.R_E_C_N_O_ from "+ RetSqlName("ZUC")+ " ZUC1 where ZUC1.ZUC_FILIAL='"+xFilial("ZUC")+"'"
	cQuery += 						" and ZUC1.ZUC_VIAGEM=DTQ_VIAGEM and ZUC1.ZUC_USER!='' and ZUC1.ZUC_STATUS!='C' and ZUC1.D_E_L_E_T_='' )"
	cQuery += " where DTQ_FILIAL='"+xFilial("DTQ")+"'"
	cQuery += " and DTQ_NUMCTR != ''"
	cQuery += " and DTQ_SOT != ''"
	cQuery += " and DTQ_TASK = ''"
	cQuery += " and DTQ.D_E_L_E_T_= ''"
	cQuery += " and F2_FIMP in ('T','S')"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .T.)

	while ! (cAliasQry)->( EOF() )

		SF2->( dbGoto( (cAliasQry)->SF2RECNO ) )

		cFilAnt := SF2->F2_FILIAL

		SM0->( dbSeek( cEmpAnt + cFilAnt ) )

		if GerPdfDacte( (cAliasQry)->ZUC_PLACA, (cAliasQry)->ZUC_USER )
			DTQ->( dbGoto( (cAliasQry)->DTQRECNO ) )
			RecLock("DTQ", .F.)
			DTQ->DTQ_TASK := DtoC( Date() ) + " " + Time()
			MsUnlock()
		endif

		(cAliasQry)->( dbSkip() )
	end

	dbSelectArea( cAliasQry )
	dbCloseArea()

	UnLockByName("JTASKUMOV", .F., .F.)		// liberação do semáforo

	ConOut( "JTASKUMOV - Termino em "+DtoC( Date() )+" "+Time() )

Return nil


//---------------------------------------------
Static Function GerPdfDacte( cPlaca, cUsuar )
Local aArea := GetArea()
Local lRet  := .F.
Local cArquivo
Local aRet
Local cDest
Local cLink

	cArquivo := Alltrim(SF2->F2_CHVNFE)
	aRet     := U_RTMSR27p( SF2->F2_DOC, SF2->F2_SERIE, cArquivo )

	if aRet[1]		// DACTE gerado

		lRet   := u_wsLocal(SF2->F2_CLIENTE, SF2->F2_LOJA)

		cDest  := SF2->F2_CLIENTE + SF2->F2_LOJA
		cLink  := Alltrim( SuperGetMV("IT_HTTP",,"http://localhost") ) + "/" + cArquivo + ".pdf"

		lRet   := u_WsCriaTarefa(SF2->F2_DOC, Alltrim(cPlaca), Date(), Time(), cDest, cUsuar, cLink)
//					WsCriaTarefa(cDacte     , cPlaca         , dData , cHora , cDest, cIDMob, cLink)
	else
		Conout("GerPdfDacte: Problema - " + aRet[2] + " - Dacte: " + SF2->F2_FILIAL + " " + SF2->F2_DOC + " " + SF2->F2_SERIE)
	endif

	restArea( aArea )
Return lRet
