#INCLUDE "PROTHESP.CH"
#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGRFINA09  บ Autor ณ Andriani           บ Data ณ  04/09/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Movimento de Depositos Identificados                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Granero                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function GRFINA09

Private cString := "PJ7"
Private cCadastro := "Movimento de Deposito Identificado"
Private aRotina := 	{ 	{"Pesquisar"			, "AxPesqui"		,	0,	1} ,;
             				{"Visualizar"			, "AxVisual"		,	0,	2} ,;
             				{"Legenda"	      	, "U_FINA09X"		,	0,	2} ,;
             				{"Importar Arquivo"	, "U_GRFINA10()"	,	0,	3} ,;
             				{"Identificar"			, "U_FINA09A()"	,	0,	3} }

Private aCores := {		{ 'PJ7->PJ7_STATUS=="1"'	, 'BR_VERDE' 	 	},;	// Em Aberto
								{ 'PJ7->PJ7_STATUS=="2"'	, 'BR_VERMELHO' 	}}		// Identificado

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,aCores)
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ GRFINA09   ณ Exibicao de Legenda                                      บฑฑ
ฑฑศออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function FINA09X()
BrwLegenda(cCadastro,"Legenda",{		{"BR_VERDE"  	,'Em Aberto'	},;
													{"BR_VERMELHO"	,'Identificado'}})
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ VERIFICA SE TIPO DE DEPOSITO PERMITE A BAIXA DE TITULO OU SOMENTE     บฑฑ
ฑฑบ A IDENTIFICACAO DO DEPOSTIO.                                          บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function FINA09A()
/*
VERIFICA SE IRA CHAMAR A TELA DE BAIXA DE TITULO OU DE IDENTIFICACAO
*/
DBSelectArea("PX7")
DBSetOrder(1) //FILIAL+TABELA+CHAVE
lAchou :=DBSeek(xFilial("PX7")+'001'+PJ7->PJ7_TPDEP)
If !lAchou
   Aviso("Atencao","Tipo de deposito nao Localizado. Fazer verificar!",{"Ok"})
	return
elseif lAchou .and. PJ7->PJ7_STATUS == "2"
   Aviso("Atencao","Este deposito ja foi identificado!",{"Ok"})
	return
elseif lAchou .and. Alltrim(Upper(PX7->PX7_CONT)) == "S"
	U_FINA09B()
elseif lAchou .and. Alltrim(Upper(PX7->PX7_CONT)) == "N"
	U_FINA09C()
else
   Aviso("","Favor verificar a Tabela de Tipo de deposito!",{"Ok"})
Endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ PERMITE A BAIXA DE TITULOS                                            บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function FINA09B()

Local aEstou			:= GetArea(), lErro := .f.
Private oMark 	 		:= 0
Private cMarca			:= GetMark()
Private lInverte 		:= .f.
Private lTudo			:= .f.
Private oDgl, nOpc	:=1 
Private nDeposito		:= PJ7->PJ7_VALTOT
Private nSomaSelecao	:= 0
Private nDiferenca	:= nDeposito - nSomaSelecao

//Montagem do Arquivo a Exibir
aFields := {}
AADD(aFields,{"XOK" 		,"C",02,0})
AADD(aFields,{"XPX"		,"C",03,0})
AADD(aFields,{"XNM"		,"C",06,0})
AADD(aFields,{"XPC" 		,"C",01,0})
AADD(aFields,{"XTP"		,"C",03,0})
AADD(aFields,{"XVC"		,"D",08,0})
AADD(aFields,{"XVL"		,"N",17,2})
AADD(aFields,{"XSD"		,"N",17,2})
AADD(aFields,{"XDC"		,"N",17,2})
AADD(aFields,{"XMU"		,"N",17,2})
AADD(aFields,{"XJU"		,"N",17,2})
AADD(aFields,{"XVR"		,"N",17,2})

acampos := {}
AADD(acampos,{"XOK"	,""	,	"",					""	})
AADD(acampos,{"XPX"	,""	,	"Prefixo",			""	})
AADD(acampos,{"XNM"	,""	,	"Num. Titulo"	,	""	})
AADD(acampos,{"XPC"	,""	,	"Parcela",			""	})
AADD(acampos,{"XTP"	,""	,	"Tipo",				""	})
AADD(acampos,{"XVC"	,""	,	"Vencimento"	,	""	})
AADD(acampos,{"XVL"	,""	,	"Valor"	,			"@E 999,999,999.99"	})
AADD(acampos,{"XSD"	,""	,	"Saldo"	,			"@E 999,999,999.99"	})
AADD(acampos,{"XDC"	,""	,	"Desconto",			"@E 999,999,999.99"	})
AADD(acampos,{"XMU"	,""	,	"Multa",				"@E 999,999,999.99"	})
AADD(acampos,{"XJU"	,""	,	"Juros",				"@E 999,999,999.99"	})
AADD(acampos,{"XVR"	,""	,	"Valor Recebido",	"@E 999,999,999.99"	})

cArq := CriaTrab(aFields,.t.)
dbUseArea(.t.,,cArq,"TRB",.f.,.f.)
DbSelectArea("TRB")

Processa({|| MontaArquivo() },"Processando...")

if trb->(eof())
	aviso("Aten็ใo","Nใo existem titulos pendentes para este Cliente!",{"OK"})
	//Retorna ambiente
	DbSelectArea("TRB")
	DbCloseArea()
	RestArea(aEstou)
	return
endif	

cCont := 2
@ 000,000 To 460,720 Dialog oDlg Title "Titulos Pendentes"
DBSelectArea("PJ6")
DBSetOrder(1)
if DBSeek(xFilial("PJ6")+PJ7->PJ7_IDENT)
	acampos2 := {}
	aCampos2 := U_BuzzToMemory("PJ6",.F.)
	@ 001, 002 to 100, 360   
	@ 003, 135 Say " D E P O S I T O   I N F O R M A D O "
  	EnChoice("PJ6",,2,,,,aCampos2,{010,002,100,360},NIL,3,,,,,,.f.)
endif
@ 105, 002 to 205, 360
@ 108, 140 Say "T I T U L O S   P E N D E N T E S"
oMark	:= MsSelect():New("TRB","XOK",,acampos,@lInverte,@cMarca,{115,002,205,360})
oMark:oBrowse:lhasMark := .t.
oMark:oBrowse:bLDblClick	:= { ||Inverte() }
oMark:oBrowse:lColDrag := .f.  

@210,300 BmpButton Type 01 Action (cCont:=1,Close(oDlg))
@210,330 BmpButton Type 02 Action (cCont:=2,Close(oDlg))
@210,250 BmpButton Type 11 Action (cCont:=3,U_FINA09D())

Activate Dialog oDlg Centered

If cCont==1 
	DbSelectArea("TRB")
	DbGoTop()
	While !eof()
		If Marked("XOK") //Marcado
			lMsErroAuto := .F.
			cHist:='BX AUT - DEP IDENTIFICADO ' + PJ7->PJ7_IDENT + PJ7->PJ7_DIGITO
			aVetor :=	{	{"E1_PREFIXO"		, TRB->XPX			,Nil},;
								{"E1_NUM"		 	, TRB->XNM 			,Nil},;
								{"E1_PARCELA"	 	, TRB->XPC 			,Nil},;
								{"E1_TIPO"	    	, TRB->XTP 			,Nil},;
								{"AUTMOTBX"	   	, "NOR"     		,Nil},;
								{"AUTBANCO" 		, PJ7->PJ7_BANCO	,Nil},;
								{"AUTAGENCIA" 		, PJ7->PJ7_AG    ,Nil},;
								{"AUTCONTA" 		, PJ7->PJ7_CC    ,Nil},;
								{"AUTDTBAIXA"	 	, dDataBase       ,Nil},;
								{"AUTDTCREDITO"	, dDataBase       ,Nil},;
								{"AUTHIST"	    	, cHist				,Nil},;
								{"AUTDESCONT" 		, TRB->XDC        ,Nil},;
								{"AUTMULTA" 		, TRB->XMU        ,Nil},;
								{"AUTJUROS" 		, TRB->XJU        ,Nil},;
								{"AUTVALREC"	 	, TRB->XVR        ,Nil }}

			MSExecAuto({|x,y| fina070(x,y)},aVetor,3) //Inclusao

			If lMsErroAuto
				lErro := .t.
				aviso("Aten็ใo","Erro ao Baixar Titulo nr. " + TRB->XNM,{"OK"})
			Endif 
			
		Endif      
		DbSelectArea("TRB")
		DbSkip()
	End
	DBSelectArea("PJ7")
	RecLock("PJ7",.f.)
	PJ7->PJ7_STATUS := "2"
	MsUnlock()
	DBSelectArea("PJ6")
	DBSetOrder(1)
	If DBSeek(xFilial("PJ6")+PJ7->PJ7_IDENT)
		if PJ6->PJ6_TPIDEN == "2"
			RecLock("PJ6",.f.)
			PJ6->PJ6_STATUS := "3"
			MsUnlock()
		endif
	Endif
	If lErro
		aviso("Aten็ใo","A operacao foi realizada, porem, algum titulo nao foi baixado Verificar...",{"OK"})
	else
		aviso("Aten็ใo","Operacao realizada com sucesso!",{"OK"})
	Endif 
Endif
         
//Retorna ambiente
DbSelectArea("TRB")
DbCloseArea()

RestArea(aEstou)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ MARCA E DESMARCA O OBJETO MARK BROWSE                                 บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function Inverte()
RecLock("TRB",.f.)
IF TRB->XOK == "  "
	TRB->XOK := cMarca	
	TRB->XVR := TRB->XSD
Else
	TRB->XOK := "  "
	TRB->XDC := 0
	TRB->XJU := 0	
	TRB->XMU := 0	
	TRB->XVR := 0
Endif
MsUnlock()
oMark:oBrowse:Refresh(.t.)
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ VERIFICA TITULOS A RECEBER                                            บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FINA09C()

Local 	aEstou	:= GetArea()
Private 	oDgl

@ 000,000 To 410,630 Dialog oDlg Title "Identificacao de Depositos"

// Enchoice Do Movimento de Depositos
// ----------------------------------
DBSelectArea("PJ7")
acampos3 := {}
aCampos3 := U_BuzzToMemory("PJ7",.F.)

// Enchoice Do Cadastro de Depositos
// ---------------------------------
DBSelectArea("PJ6")
DBSetOrder(1)
acampos2 := {}
if DBSeek(xFilial("PJ6")+PJ7->PJ7_IDENT)
	aCampos2 := U_BuzzToMemory("PJ6",.F.)
endif

// Mostra campos
// ----------------------------------

EnChoice("PJ6",,2,,,,aCampos2,{010,002,100,275},NIL,3,,,,,,.f.)
EnChoice("PJ7",,2,,,,aCampos3,{115,002,205,275},NIL,3,,,,,,.f.)

@ 002,002 Say "D E P O S I T O   I N F O R M A D O" Size 90,8 Pixel
@ 106,002 Say "D E P O S I T O   E F E T U A D O" Size 90,8 Pixel

@010,281 BmpButton Type 01 Action (cCont:=1,Close(oDlg))
@030,281 BmpButton Type 02 Action (cCont:=2,Close(oDlg))

Activate Dialog oDlg Centered

If cCont==1 //Efetua Processamento
	DBSelectArea("PJ7")
	RecLock("PJ7",.f.)
	PJ7->PJ7_STATUS := "2"
	MsUnlock()
	DBSelectArea("PJ6")
	DBSetOrder(1)
	If DBSeek(xFilial("PJ6")+PJ7->PJ7_IDENT)
		if PJ6->PJ6_TPIDEN == "2"
			RecLock("PJ6",.f.)
			PJ6->PJ6_STATUS := "3"
			MsUnlock()
		endif
	Endif
Endif

//Retorna ambiente
RestArea(aEstou)
return
                          
/*
Static Function AtualizaValores( tipo )
Local lRet :=.t.

if upper(tipo) == "SOMA"
	if TRB->XSD <= nDiferenca
		nSomaSelecao += TRB->XSD
		nDiferenca := nDeposito - nSomaSelecao
	else
		lRet := .f.	
	endif	
elseif upper(tipo) == "SUBTRAI"
	nSomaSelecao -= TRB->XVR
	nDiferenca := nDeposito - nSomaSelecao
endif
@ 215, 005 clear to 235, 055
@ 215, 005 say "Valor de Deposito" 
@ 215, 055 say Transform(nDeposito, "@EB 999,999,999.99")
@ 225, 005 say "Soma dos Titulos " 
@ 225, 055 say Transform(nSomaSelecao, "@B 999,999,999.99")
@ 235, 005 say "Diferenca        " 
@ 235, 055 say Transform(nDiferenca, 	  "@B 999,999,999.99")

return(lRet)
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ ALTERACAO DOS VALORES DO TITULO                                       บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FINA09D()
Local cCont1 := 2
Local oDlg1
Private cXPX := TRB->XPX
Private cXNM := TRB->XNM
Private cXPC := TRB->XPC
Private cXTP := TRB->XTP
Private dXVC := TRB->XVC
Private nXVL := TRB->XVL
Private nXSD := TRB->XSD
Private nXDC := TRB->XDC
Private nXMU := TRB->XMU
Private nXJU := TRB->XJU
Private nXVR := TRB->XVR

if !Marked("XOK")
	aviso("Aten็ใo","Este titulo nao esta marcado para baixa!",{"OK"})	
	return
endif
	
@ 000,000 To 240,310 Dialog oDlg1 Title "Alterar Titulo"
@ 001,002 To 120,122

@ 005, 005 SAY "Prefixo " SIZE 40, 7 OF oDlg1 PIXEL 
@ 005, 050 MSGET cXPX	Picture "@!" when .f.  SIZE 30, 10 OF oDlg1 PIXEL

@ 015, 005 SAY "Num. Titulo " SIZE 40, 7 OF oDlg1 PIXEL 
@ 015, 050 MSGET cXNM	Picture "@!" when .f.  SIZE 30, 10 OF oDlg1 PIXEL

@ 025, 005 SAY "Parcela " SIZE 40, 7 OF oDlg1 PIXEL 
@ 025, 050 MSGET cXPC	Picture "@!" when .f.  SIZE 30, 10 OF oDlg1 PIXEL

@ 035, 005 SAY "Tipo " SIZE 40, 7 OF oDlg1 PIXEL 
@ 035, 050 MSGET cXTP	Picture "@!" when .f.  SIZE 30, 10 OF oDlg1 PIXEL

@ 045, 005 SAY "Vencimento " SIZE 40, 7 OF oDlg1 PIXEL 
@ 045, 050 MSGET dXVC	Picture "@!" when .f.  SIZE 30, 10 OF oDlg1 PIXEL

@ 055, 005 SAY "Valor " SIZE 40, 7 OF oDlg1 PIXEL 
@ 055, 050 MSGET nXVL	Picture "@E 999,999,999.99 " when .f.  SIZE 70, 7 OF oDlg1 PIXEL

@ 065, 005 SAY "Saldo " SIZE 40, 7 OF oDlg1 PIXEL 
@ 065, 050 MSGET nXSD	Picture "@E 999,999,999.99 " when .f.  SIZE 70, 7 OF oDlg1 PIXEL

@ 075, 005 SAY "Desconto " SIZE 40, 7 OF oDlg1 PIXEL 
@ 075, 050 MSGET nXDC	Picture "@E 999,999,999.99 " valid(ValAltTit("nXDC")) when .t.  SIZE 70, 10 OF oDlg1 PIXEL

@ 085, 005 SAY "Multa " SIZE 40, 7 OF oDlg1 PIXEL 
@ 085, 050 MSGET nXMU	Picture "@E 999,999,999.99 " valid(ValAltTit("nXMU")) when .t.  SIZE 70, 10 OF oDlg1 PIXEL

@ 095, 005 SAY "Juros " SIZE 40, 7 OF oDlg1 PIXEL 
@ 095, 050 MSGET nXJU	Picture "@E 999,999,999.99 " valid(ValAltTit("nXJU")) when .t.  SIZE 70, 10 OF oDlg1 PIXEL

@ 105, 005 SAY "Valor Recebido " SIZE 40, 7 OF oDlg1 PIXEL 
@ 105, 050 MSGET nXVR	Picture "@E 999,999,999.99 " valid(ValAltTit("nXVR")) when nXVR > 0  SIZE 70, 10 OF oDlg1 PIXEL

@005,125 BmpButton Type 01 Action (cCont1:=1,Close(oDlg1))
@025,125 BmpButton Type 02 Action (cCont1:=2,Close(oDlg1))

Activate Dialog oDlg1 Centered

If cCont1==1 
	RecLock("TRB",.f.)
	TRB->XPX := cXPX
	TRB->XNM := cXNM
	TRB->XPC := cXPC
	TRB->XTP := cXTP
	TRB->XVC := dXVC
	TRB->XVL := nXVL
	TRB->XSD := nXSD
	TRB->XDC := nXDC
	TRB->XMU := nXMU
	TRB->XJU := nXJU
	TRB->XVR := nXVR
	MsUnlock()
Endif
         
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Valida alteracao de valores no titulo                                 บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValAltTit( xCampo )
Local lRet := .t.

if Upper(xcampo) == "NXVR"
	If ( ( nXMU + nXJU + nXSD ) - nXDC ) < nXVR 
	   lRet := .f.
		nXVR := nXSD + ( nXMU + nXJU -nXDC )
		Aviso("Atencao","O Valor recebido nao pode ser maior que o Saldo Liquido!", {"OK"} )
	endif
else
	nXVR := nXSD + ( nXMU + nXJU -nXDC )
endif	

return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ MONTAARQUIVO - Montagem do Arquivo o MarkBrowse                       บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaArquivo()

Local aEstou 	:= GetArea()
LOCAL cQuery 	:= ""	

CQUERY := " SELECT "
CQUERY += " 	E1_NUM AS XNM, "
CQUERY += "		E1_PARCELA AS XPC, "
CQUERY += "		E1_VENCREA AS XVC, "
CQUERY += "		E1_VALOR AS XVL, "
CQUERY += "		E1_SALDO AS XSD, "
CQUERY += "		E1_PREFIXO AS XPX, "
CQUERY += "		E1_TIPO AS XTP "
CQUERY += " FROM "
CQUERY += RETSQLNAME("SE1") 
CQUERY += " WHERE "
CQUERY += "		D_E_L_E_T_ <> '*' "  
CQUERY += " 	AND E1_CLIENTE = '" + POSICIONE("PJ6",1,XFILIAL("PJ6")+PJ7->PJ7_IDENT,"PJ6_CODCLI") + "'" 
CQUERY += " 	AND E1_LOJA = '" + POSICIONE("PJ6",1,XFILIAL("PJ6")+PJ7->PJ7_IDENT,"PJ6_LOJA") + "'" 
CQUERY += "		AND E1_TIPO <> 'NF' "
CQUERY += "		AND E1_SALDO > 0 " 
CQUERY += "		AND ROWNUM < 10 " 
CQUERY += " ORDER BY "
CQUERY += "		E1_FILIAL, "
CQUERY += "		E1_NUM, "
CQUERY += "		E1_PARCELA, "
CQUERY += "		E1_TIPO, "
CQUERY += " 	E1_PREFIXO "

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery) , 'TMP3', .T., .F.)

ProcRegua(4)

DbSelectArea("TRB")
Zap
IncProc()
	
DbSelectArea("TMP3")
While !eof()
	DbSelectArea("TRB")
	RecLock("TRB",.t.)
	TRB->XOK := Space(2)
   TRB->XNM := TMP3->XNM
   TRB->XPC := TMP3->XPC
   TRB->XVC := stod(TMP3->XVC)
   TRB->XVL := TMP3->XVL
   TRB->XSD := TMP3->XSD
   TRB->XPX := TMP3->XPX
   TRB->XTP := TMP3->XTP
	MsUnLock()
	DbSelectArea("TMP3")
	DbSkip()
End
IncProc()

DbSelectArea("TMP3")
DbCloseArea()
IncProc()

DbSelectArea("TRB")
DbGoTop()
IncProc()

RestArea(aEstou)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ BUZZINVERTE - Inversao de Marcacao de Browse                          บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
Static Function BuzzInverte()
Local nReg := TRB->(Recno())
Local cAlias := Alias()

dbSelectArea("TRB")
DbGoTop()
While !Eof() 
	RecLock("TRB",.f.)
	IF lTudo == .t.
		TRB->XOK := "  "
	Else
		TRB->XOK := cMarca
	Endif
	MsUnlock()
	dbSkip()
Enddo

lTudo := iif(lTudo,.f.,.t.)

DbSelectArea("TRB")
DbGoTop()
DbGoto(nReg)

oMark:oBrowse:Refresh(.t.)
Return Nil   
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ                                                                       บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//Static Function AchaFlagTpDep( xTpDep )
//Local aEstou := GetArea(), lAchou

//DBSelectArea("PX7")
//DBSetOrder(1) //FILIAL+TABELA+CHAVE
//if DBSeek(xFilial("PX7")+'001'+ xTpDep )
//	cRet := Alltrim(Upper(PX7->PX7_CONT))
//endif
//RestArea( aEstou )
//return( cRet )
