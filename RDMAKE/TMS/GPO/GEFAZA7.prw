#Include 'Protheus.ch'


/*/{Protheus.doc} CNH201A
Função responsável por receber a placa do veículo e nome do motorista
para transmitir a interface201.
@author 	J Ricardo Guimarães
@since 		13/05/2016
@version	1.0
@param 		_aRet, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)

/*/User Function GEFAZA7()

// --- Variaveis utilizadas
//Local	oDlg
Local _aArea := GetArea()
Local	oFont, oFont1
Local	oSButton1, oSButton2
Local	_lRet		:=	.t.

Local oGet1
Local oGetAS
Local oGetCodCli
Local oGetCodCliDes
Local oGetCusto
Local oGetLoja
Local oGetLojaDes
Local oGetNomCli
Local oGetNomCliDes
Local oGetNumViagem
Local oGroup1
Local oGroup4
Local oGroup5
Local oSay1CodCli
Local oSay1LojCli
Local oSayCli
Local oSayCliDes
Local oSayCodCliDes
Local oSayCusto
Local oSayLojaDes
Local oSayNumAs
//Local oSayViagem
Local oSButtonCanc
Local oSButtonConfirmar

Private oDlg
Private oSayViagem
Private _cViagem	:=	Space(TamSX3('ZA7_VIAGEM')[1])
Private _cCodCli	:=	Space(TamSX3('ZA7_CODCLI')[1])
Private _cLojaCli	:=	Space(TamSX3('ZA7_LOJCLI')[1])
Private _cDesCli	:=	Space(TamSX3('ZA7_DESCLI')[1])
Private _cCliDes	:=	Space(TamSX3('ZA7_CLIDES')[1])
Private _cLojDes	:=	Space(TamSX3('ZA7_LOJDES')[1])
Private _cNomDes	:=	Space(TamSX3('ZA7_NOMDES')[1])
Private _cAS		:=	Space(TamSX3('ZA7_AS')[1])
Private _nCusto	:=	0.00
Private _cUsuario  	:= UsrRetName(RetCodUsr())

If !( AllTrim(_cUsuario) $ AllTrim(GETMV("ES_USRCUS")) ) 
	MsgInfo("Usuário sem permisão para executar a rotina", "Info")
	Return
Endif
	
// ---	Define fontes para mensagens
oFont	:= TFont():New('Tahoma',,-16,.T.)
oFont1	:= TFont():New('Tahoma',,-11,.T.)

//  DEFINE MSDIALOG oDlg TITLE "Dados Viagem" FROM 000, 000  TO 280, 1000 COLORS 0, 16777215 PIXEL
oDlg := MSDialog():New(0,0,280,1000,OemToAnsi('Dados da Viagem '),,,,,CLR_BLACK,CLR_WHITE,,,.t.)

    // @ 009, 008 SAY oSayViagem PROMPT "Num. Viagem : " SIZE 039, 010 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
    //@ -002, 061 MSGET oGet1 VAR cGet1 SIZE 060, 010 OF oSayViagem COLORS 0, 16777215 PIXEL
	oSayViagem	:= TSay():New( 009, 008, {|| OemToAnsi('Num. Viagem: ')},oDlg,, oFont,,,, .T.,CLR_RED,CLR_WHITE )
	//oSayViagem:lTransparent:= .F.

    // @ 009, 163 SAY oSayNumAs PROMPT "AS :" SIZE 025, 010 OF oDlg COLORS 0, 16777215 PIXEL
	oSayNumAs := TSay():New( 009, 163, {|| OemToAnsi('Num. AS: ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
	oSayNumAs:lTransparent:= .F.

    @ 023, 001 GROUP oGroup1 TO 024, 497 OF oDlg COLOR 0, 16777215 PIXEL
	
    // @ 032, 007 SAY oSay1CodCli PROMPT "Cod.Cliente :" SIZE 033, 010 OF oDlg COLORS 0, 16777215 PIXEL
	oSay1CodCli	:= TSay():New( 032, 007, {|| OemToAnsi('Cod. Cliente : ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
	oSay1CodCli:lTransparent:= .F.
	    
    // @ 032, 099 SAY oSay1LojCli PROMPT "Loja :" SIZE 015, 010 OF oDlg COLORS 0, 16777215 PIXEL
	oSay1LojCli	:= TSay():New( 032, 125, {|| OemToAnsi('Loja : ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
	oSay1LojCli:lTransparent:= .F.
    
    // @ 032, 144 SAY oSayCli PROMPT "Cliente :" SIZE 025, 010 OF oDlg COLORS 0, 16777215 PIXEL
	oSayCli	:= TSay():New( 032, 195, {|| OemToAnsi('Cliente :  ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
	oSayCli:lTransparent:= .F.

    // @ 054, 006 SAY oSayCodCliDes PROMPT "Cod.Cli.Destino :" SIZE 043, 010 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
	oSayCodCliDes := TSay():New( 054, 006, {|| OemToAnsi('Cod.Cli. Destino: ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
	oSaycodCliDes:lTransparent:= .F.

    // @ 054, 100 SAY oSayLojaDes PROMPT "Loja :" SIZE 015, 010 OF oDlg COLORS 0, 16777215 PIXEL
	oSayLojaDes := TSay():New( 054, 125, {|| OemToAnsi('Loja : ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
	oSayLojaDes:lTransparent:= .F.

    // @ 054, 145 SAY oSayCliDes PROMPT "Cliente :" SIZE 023, 010 OF oDlg COLORS 0, 16777215 PIXEL
    oSayCliDes := TSay():New( 054, 195, {|| OemToAnsi('Cliente : ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
	oSayCliDes:lTransparent:= .F.

    //@ 091, 005 SAY oSayCusto PROMPT "Custo :" SIZE 027, 010 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
    oSayCusto := TSay():New( 091, 005, {|| OemToAnsi('Custo : ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
	oSayCusto:lTransparent:= .F.

    @ 008, 060 MSGET oGetNumViagem 	VAR _cViagem 	SIZE 070, 010 OF oDlg COLORS 0, 16777215  Valid IIF( Empty(_cViagem), Vazio(), (fCarregaDados() .AND. oDlg:Refresh()) ) PIXEL
    @ 008, 200 MSGET oGetAS 		VAR _cAS 		SIZE 109, 010 OF oDlg COLORS 0, 16777215 PIXEL WHEN .F.
    
    @ 030, 070 MSGET oGetCodCli VAR _cCodCli SIZE 046, 010 OF oDlg COLORS 0, 16777215 WHEN .F. PIXEL
//	@ 023,065 MSGET _cPlaca		F3 "DA3"	SIZE 20, 9 OF oDlg Picture "@!" Pixel Valid Iif ( Empty(_cPlaca), Vazio(), ExistCpo("DA3") )
//	oSay3	:= TSay():New( 023, 110, {|| Transform(CNH201B(_cPlaca,@_cMsg2,oDlg,oFont),"@R XXX-9999") },oDlg,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE )
//	oSay3:lTransparent:= .F.

    @ 030, 150 MSGET oGetLoja 		VAR _cLojaCli SIZE 023, 010 OF oDlg COLORS 0, 16777215 WHEN .F. PIXEL
    @ 030, 225 MSGET oGetNomCli 	VAR _cDesCli SIZE 275, 010 OF oDlg COLORS 0, 16777215 WHEN .F. PIXEL

    @ 053, 070 MSGET oGetCodCliDes 	VAR _cCliDes SIZE 046, 010 OF oDlg COLORS 0, 16777215 FONT oFont1 WHEN .F. PIXEL
    @ 053, 150 MSGET oGetLojaDes 	VAR _cLojDes SIZE 023, 010 OF oDlg COLORS 0, 16777215 FONT oFont1 WHEN .F. PIXEL
    @ 053, 225 MSGET oGetNomCliDes 	VAR _cNomDes SIZE 275, 010 OF oDlg COLORS 0, 16777215 WHEN .F. PIXEL

    @ 070, 001 GROUP oGroup4 TO 071, 497 OF oDlg COLOR 0, 16777215 PIXEL

//    @ 091, 005 SAY oSayCusto PROMPT "Custo :" SIZE 027, 010 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL

    @ 092, 033 MSGET oGetCusto 		VAR _nCusto 		SIZE 077, 010 OF oDlg PICTURE "@E 999,999,999.99" COLORS 0, 16777215 FONT oFont1 PIXEL
    
    @ 113, 001 GROUP oGroup5 TO 114, 497 OF oDlg COLOR 0, 16777215 PIXEL
    
	// --- Botoes para gravacao dos dados de classificacao do titulo
	// ---
	oSButton1 := SButton():New( 120,411,1, {|| fGravaCusto(), oSayViagem:SetFocus() },oDlg,.T.,'Confirma dados')
	oSButton2 := SButton():New( 120,455,2, {|| _lRet := .f. , oDlg:End()            },oDlg,.T.,'Cancela')

// --- 	Ativa o objeto
oDlg:Activate()

RestArea(_aArea)
Return
/************************************************/
Static Function fCarregaDados()
/************************************************/
Local _lRet := .F.

dbSelectArea("ZA7") ; dbSetOrder(3)
If !ZA7->(dbSeek(_cViagem))
	Alert("Viagem " + _cViagem + " NÃO localizada na tabela ZA7")
	_cViagem := ""
	
	_cViagem	:=	Space(TamSX3('ZA7_VIAGEM')[1])
	_cCodCli	:=	Space(TamSX3('ZA7_CODCLI')[1])
	_cLojaCli	:=	Space(TamSX3('ZA7_LOJCLI')[1])
	_cDesCli	:=	Space(TamSX3('ZA7_DESCLI')[1])
	_cCliDes	:=	Space(TamSX3('ZA7_CLIDES')[1])
	_cLojDes	:=	Space(TamSX3('ZA7_LOJDES')[1])
	_cNomDes	:=	Space(TamSX3('ZA7_NOMDES')[1])
	_cAS		:=	Space(TamSX3('ZA7_AS')[1])
	_nCusto		:=	0.00
			
	_lRet := .F.
Else	
	// Alert("Viagem " + _cViagem + " LOCALIZADA na tabela ZA7")
	
	If ZA7->ZA7_CUSTO > 0
	
		MsgInfo("A Viagem " + _cViagem + " já possui custo informado: " + cValToChar(ZA7->ZA7_CUSTO) + CRLF + " Não é permitido alterar.", "Aviso")
		        
		_cViagem	:=	Space(TamSX3('ZA7_VIAGEM')[1])
		_cCodCli	:=	Space(TamSX3('ZA7_CODCLI')[1])
		_cLojaCli	:=	Space(TamSX3('ZA7_LOJCLI')[1])
		_cDesCli	:=	Space(TamSX3('ZA7_DESCLI')[1])
		_cCliDes	:=	Space(TamSX3('ZA7_CLIDES')[1])
		_cLojDes	:=	Space(TamSX3('ZA7_LOJDES')[1])
		_cNomDes	:=	Space(TamSX3('ZA7_NOMDES')[1])
		_cAS		:=	Space(TamSX3('ZA7_AS')[1])
		_nCusto		:=	0.00
		
		_lRet := .F.
			
	Else
		_cViagem	:=	ZA7->ZA7_VIAGEM
		_cCodCli	:=	ZA7->ZA7_CODCLI
		_cLojaCli	:=	ZA7->ZA7_LOJCLI
		_cDesCli	:=	ZA7->ZA7_DESCLI
		_cCliDes	:=	ZA7->ZA7_CLIDES
		_cLojDes	:=	ZA7->ZA7_LOJDES
		_cNomDes	:=	ZA7->ZA7_NOMDES
		_cAS		:=	ZA7->ZA7_AS
		_nCusto	:=	ZA7->ZA7_CUSTO
		
		_lRet := .T.		
	EndIf
EndIf

Return(_lRet) 

/*/{Protheus.doc} CNHNUMCA
Função responsável por receber os dados da janela de agendamento.
@author 	U297686 - Ricardo Guimarães
@since 		16/05/2016
@version	1.0
@param 		_aRet, ${param_type}, (Descrição do parâmetro)
@return	Nil
@example	Nil
(examples)
@see (links_or_references)
/*/
Static Function fGravaCusto()

If _nCusto <= 0
	MsgInfo("Custo não informado para a Viagem " + _cViagem, "Aviso")
	Return .F.	
EndIf

If MsgNoYes("Você está atualizando o custo da Viagem " + _cViagem + " com o valor de " + Transform(_nCusto, "@R 999,999,999.99") + CRLF +;
            "Este valor NÃO PODERÁ SOFRER ALTERAÇÃO em outra oportunidade.","Alerta")
   
   Begin Transaction         
		RecLock("ZA7",.F.)
			ZA7->ZA7_CUSTO := _nCusto
		MsUnLock()
	
		RecLock("SZV",.T.)
			SZV->ZV_DATA 		:= dDATABASE
			SZV->ZV_USUARIO 	:= _cUsuario
			SZV->ZV_VIAGEM 	:= _cViagem
			SZV->ZV_AS			:= _cAS
			SZV->ZV_CUSTO		:= _nCusto 	
		MsUnLock()
	End Transaction 
	dbSelectArea("ZA7")
		
EndIf

_cViagem	:=	Space(TamSX3('ZA7_VIAGEM')[1])
_cCodCli	:=	Space(TamSX3('ZA7_CODCLI')[1])
_cLojaCli	:=	Space(TamSX3('ZA7_LOJCLI')[1])
_cDesCli	:=	Space(TamSX3('ZA7_DESCLI')[1])
_cCliDes	:=	Space(TamSX3('ZA7_CLIDES')[1])
_cLojDes	:=	Space(TamSX3('ZA7_LOJDES')[1])
_cNomDes	:=	Space(TamSX3('ZA7_NOMDES')[1])
_cAS		:=	Space(TamSX3('ZA7_AS')[1])
_nCusto	:=	0.00
 
oSayViagem:SetFocus()
oDlg:Refresh()
 
Return Nil 
