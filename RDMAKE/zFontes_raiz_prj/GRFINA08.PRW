#INCLUDE "rwmake.ch"
#INCLUDE "PROTHESP.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GRFINA08  º Autor ³ Andriani           º Data ³  03/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Deposito Identificado                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Granero																	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GRFINA08

Private aRotina := { 	{"Pesquisar"	,"AxPesqui"		,0	,1},;
            				{"Visualizar"	,"AxVisual"		,0	,2},;
								{"Legenda"	  	, "U_FINA08X"	,0	,2},;             
            				{"Incluir"		,"AxInclui"		,0	,3},;
            				{"Alterar"		,"AxAltera"		,0	,4},;
            				{"Identificar"	,"U_FINA08A"	,0	,2}}

Private cCadastro := "Cadastro de Deposito Identificado"
Private cDelFunc := ".T." 
Private cString := "PJ6"
Private aCores := {		{ 'PJ6->PJ6_STATUS=="1"'	, 'BR_PRETO' 	},;		// Identificador Fixo
								{ 'PJ6->PJ6_STATUS=="2"'	, 'BR_VERDE' 	},;  		// Variavel - Nao Identificado
								{ 'PJ6->PJ6_STATUS=="3"'	, 'BR_VERMELHO' 	} }	//	Variavel - Identificado

dbSelectArea(cString)
dbSetOrder(1)

mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º GRFINA08X  ³ Exibicao de Legenda                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FINA08X()
BrwLegenda(cCadastro,"Legenda",{		{"BR_PRETO"  	,'Identificador Fixo'	},;
													{"BR_VERDE"		,'Identificador Variavel - Nao Identificado'},;
													{"BR_VERMELHO"	,'Identificador Variavel - Identificado'}})
Return   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º ValidaOk   ³ Validacao para Inclusao e Alteracao de registros         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FN08OK()
Local lRet := .t., aEstou := GetArea(), lAchou 

DBSelectArea("PX7")
DBSetOrder(1) //FILIAL+TABELA+CHAVE
lAchou :=DBSeek(xFilial("PX7")+'001'+M->PJ6_TPDEP)
if lAchou
	if Alltrim(Upper(PX7->PX7_CONT)) == "S"
		if ( Alltrim(M->PJ6_CODCLI) == "" .and. Alltrim(M->PJ6_LOJA) == "" )
			lRet := .f.
			MsgAlert("Preencha os campos Cliente e Loja corretamente.","Atencao!")
		endif
   endif
else
	lRet := .f.
	MsgAlert("Preenche o campo Tipo de Deposito Corretamente.","Atencao!")
endif 

RestArea(aEstou)
Return(lRet)       
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º IDENTIFICACAO DE DEPOSITOS		                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FINA08A()
Local oDlg
Local cCont := 2
Local cHist	:= Space(100)
Local acampos2 := {}

if Alltrim(PJ6->PJ6_STATUS) == "1" .OR. Alltrim(PJ6->PJ6_STATUS) == "3"
	MsgAlert("Este registro nao pode ser identificado","Atencao!")	
	return
endif

@ 000,000 To 400,720 Dialog oDlg Title " "
aCampos2 := U_BuzzToMemory("PJ6",.F.)
EnChoice("PJ6",,2,,,,aCampos2,{010,002,140,360},NIL,3,,,,,,.f.)
@ 145, 002 to 160,360
@ 150, 005 SAY "Historico " SIZE 40, 7 OF oDlg PIXEL
@ 150, 035 MSGET cHist	Picture "@!S60" SIZE 280, 10 OF oDlg PIXEL
@ 180, 300 BmpButton Type 01 Action (cCont:=1,Close(oDlg))
@ 180, 330 BmpButton Type 02 Action (cCont:=2,Close(oDlg))
Activate Dialog oDlg Centered
If cCont == 1  
	RecLock("PJ6",.f.)
	PJ6->PJ6_HIST 		:= cHist
	PJ6->PJ6_STATUS 	:= "3"
	MsUnlock()
Endif
Return

