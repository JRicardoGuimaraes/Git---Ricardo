#Include "rwmake.ch"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³chgx5fil  ºAutor  ³Anderson Crepaldi   º Data ³  07/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para controle de numeracao exclusiva      º±±
±±º          ³ do CTRC                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³   Gefco                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION CHGX5FIL()

Return cFilAnt


User Function TMSA150Ser()

	Local lChgX5Fil := ExistBlock("CHGX5FIL")
	Local cFilSX5   := xFilial('SX5')
	Local aSerNF    := {}
	Local cTitle    := "STR0002"
	Local lOk       := .F.
	Local oDlg, oItem, nOAt

	IF lChgX5Fil
		cFilSX5 := ExecBlock("CHGX5FIL",.F.,.F.)
	Endif

	//-- Verifica se a serie esta cadastrada na tabela 01 - Series de notas fiscais.
	SX5->( DbSetOrder( 1 ) )
	SX5->( MsSeek( cFilSX5 + '01' ) )

	While SX5->X5_FILIAL == cFilSX5 .And. SX5->X5_TABELA == "01"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se a S‚rie for CPF, n„o mostra no aChoice, pois ‚ utilizada ³
		//³ internamente para emissao de Cupom Fiscal.                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If AllTrim(SX5->X5_CHAVE)!="CPF" .And. AllTrim(SX5->X5_CHAVE)!="CP"
			AADD(aSerNF, {PadR(SX5->X5_CHAVE,3), X5Descri()})
		EndIf
		dbSelectArea("SX5")
		dbSkip()
	EndDo

	If Len(aSerNF) == 0
		Help('',1,'NORECNO')
		Return .F.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem da janela de exibicao                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg TITLE cTitle From 150,200 To 305,600 OF oMainWnd PIXEL
	@ 05,10 LISTBOX oItem VAR cOpc Fields HEADER "OemToAnsi(STR0002)", "OemToAnsi(STR0003)" SIZE 140,65  OF oDlg PIXEL
	oItem:SetArray(aSerNF)
	oItem:bLine := { || {aSerNF[oItem:nAt,1], aSerNF[oItem:nAt,2]}}
	DEFINE SBUTTON FROM 03,160 TYPE 1 ENABLE OF oDlg ACTION (lOk:=.T.,oDlg:End())
	DEFINE SBUTTON FROM 18,160 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg VALID (nOAT := oItem:nAT,.T.) CENTERED

	If lOk .And. (Inclui .Or. Altera)
		If SX5->( MsSeek( cFilSX5 + '01' + aSerNF[nOAt, 1]) )
			&(ReadVar()) := aSerNF[nOAt, 1]
		EndIf
	EndIf

Return lOk

