#Include 'Protheus.ch'

User Function F090AFIL
	Local cFiltro := PARAMIXB[1]
	Local cForDe	:= Space( TAMSX3("E2_FORNECE")[1] )
	Local cForAte	:= Space( TAMSX3("E2_FORNECE")[1] )
	Local nOpca	:= 0

	DEFINE MSDIALOG oDlg FROM 30,16 To 280, 300  TITLE "Filtrar Fornecedor" PIXEL

	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,40,40,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	@ 002,002 TO 107, 142 PIXEL OF oPanel

	@ 004,005 SAY OemToAnsi("Fornecedor") SIZE 40,08 PIXEL OF oPanel
	@ 013,005 MSGET cForDe	PICTURE "@!" F3 "SA2"  SIZE 45,08  PIXEL OF oPanel HASBUTTON
	@ 013,060 SAY	OemToAnsi("Até") SIZE 10,08  PIXEL OF oPanel
	@ 013,080 MSGET cForAte	PICTURE "@!" F3 "SA2" VALID cForAte >= cForDe SIZE 45,08  PIXEL OF oPanel HASBUTTON

	DEFINE SBUTTON FROM 110,083 TYPE 1 ACTION (nOpca := 1,oDlg:End() )	ENABLE OF oDlg
	DEFINE SBUTTON FROM 110,113 TYPE 2 ACTION oDlg:End()					ENABLE OF oDlg

	ACTIVATE MSDIALOG oDlg CENTER

	If nOpca == 1
		If ! Empty( cForDe ) .And. ! Empty( cForAte )
			cFiltro += " .And. E2_FORNECE >= '" + cForDe + "' .And. E2_FORNECE <= '" + cForAte + "'"
		EndIf
	EndIf

Return cFiltro
