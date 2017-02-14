#include "rwmake.ch"
#include "protheus.ch"

*--------------------------*
User Function Sf1100i()
*--------------------------*
Local _aAreaSF1 := SF1->(GetArea())
Local _aAreaSD1 := SD1->(GetArea())
Local _aAreaSF4 := SF4->(GetArea())
Local _aAreaSE1 := SE1->(GetArea())

Local _nRecNoSD1:= SD1->(Recno())
Local _nRecNoSF1:= SF1->(Recno())
Local _nRecNoSF4:= SF4->(Recno())
Local _nRecNoSA2:= SA2->(Recno())

Private V_Tipo,V_Alias,V_Order,V_Recno
Private V_LinDig := "", V_CodBar := ""

V_Alias := Alias()
V_Order := IndexOrd()
V_Recno := 0
xDUPLIC := .T.
GefConta := " "
GefCusto := " "
xPrefixo := ""
xNumero  := ""
V_Tipo := " "

If !Eof()
	V_Recno := Recno()
Endif

// Gera ou não Titulo a pagar
DbSelectArea("SE2")
// Substituído por Ricardo - Em: 16/05/2008 - Não estava tratando o fornecedor na Chave, então quando existia NF
// iguais de fornecedores diferente estava pegando o CC errado.
dbSetOrder(6)
dbGoTop()
// xDUPLIC := IIF(dbSeek(xFilial("SE2")+SF1->F1_SERIE+SF1->F1_DOC),.T.,.F.)
xDUPLIC := IIF(dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC),.T.,.F.)
// xDUPLIC := IIF(dbSeek(xFilial("SE2")SF1->F1_SERIE+SF1->F1_DOC),.T.,.F.)

xPrefixo := SF1->F1_SERIE
xNumero  := SF1->F1_DOC 
xFornece := SF1->F1_FORNECE
xLoja    := SF1->F1_LOJA

DbSelectArea("SD1")
dbSetOrder(1)
dbGoTop()
If dbSeek(xFilial("SD1")+ xNumero + xPrefixo + SF1->F1_FORNECE + SF1->F1_LOJA)
	GefConta := Alltrim(SD1->D1_CONTA)
	GefCusto := Alltrim(SD1->D1_CC)
Endif

// Grava no SF1 que a nota foi originada de um XML importado para evitar duplicidade de importacao.
If Type("_mArqXML") <> "U"
	RecLock("SF1",.F.)
	SF1->F1_XARQXML	:= _mArqXML
	SF1->F1_XTXTXML := _mMemoXML
	MsUnlock()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o Arquivo SF4.                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('SF4')
dbSetOrder(1)
MsSeek(xFilial()+SD1->D1_TES)

aAreaSE2	:= SE2->(GetArea())
aArea		:= GetArea()

// Sem gerar Financeiro
If !xDUPLIC
	Return
Endif

/*
@ 190,001 TO 350,420 DIALOG _oDlg1 TITLE "Dados adicionais da Nota : " + SF1->F1_DOC
//@ 005,005 TO 130,180
@ 005,005 TO 060,110
@ 015,010 Say OEMTOANSI("Forma de Pagamento : ")
@ 015,080 Get V_Tipo Picture "@!"
@ 035,010 Say OEMTOANSI("Digite : 1- Boleto 2- Doc 3- Cheque ")
@ 015,120 BMPBUTTON TYPE 01 ACTION CLOSE(_ODLG1)
Activate Dialog _oDlg1 centered
*/
*-------------------*
// fFormaPag()
*-------------------*
//fTipoPag()

nTotCof:=0
nTotCsl:=0
nTotPis:=0

// Avalia o(s) Titulo(s) Financeiro e a Nota Fiscal
//While !Eof() .And. xFilial() == SE2->E2_FILIAL .And. xPrefixo == SE2->E2_PREFIXO .And.  xNumero == SE2->E2_NUM
DbSelectArea("SE2")
//	DbSetOrder(1)
DbSetOrder(6)	
// DbSeek(xFilial("SE2")+SF1->F1_SERIE+SF1->F1_DOC)
dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)
While !Eof() .and. SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM ==  SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC

	*-------------------*
	If SD1->D1_XCOMTLA <> "S"  // Se for ref. Compra de Frete do TLA
		fFormaPag()
	EndIf	
	*-------------------*
		
	If Reclock("SE2",.F.)
		Replace SE2->E2_FORMPAG    With  V_Tipo
		Replace SE2->E2_CODBAR     With  V_CodBar
		Replace SE2->E2_XLINDIG    With  V_LinDig
		Replace SE2->E2_CCONT      With  GefCusto
		Replace SE2->E2_CONTAD     With  GefConta
		MsUnlock()
	Endif

	// Busca Todas as parcelas do Titulos para verificar valor de impostos total		
	nTotCof	+=SE2->E2_VRETCOF
	nTotCsl	+=SE2->E2_VRETCSL
	nTotPis	+=SE2->E2_VRETPIS		
		
	dbSelectArea("SE2")
	DbSkip()
End
	
// Grava no SF1 valor total de Impostos que gerarão titulos
RecLock("SF1",.F.)
	SF1->F1_VALCOF	:=nTotCof
	SF1->F1_VALPIS	:=nTotPis
	SF1->F1_VALCSLL	:=nTotCsl    
MsUnlock()

RestArea(_aAreaSF1)
RestArea(_aAreaSD1)
RestArea(_aAreaSF4)
RestArea(_aAreaSE1)
RestArea(_aAreaSD1)

SF4->(dbGoTo(_nRecNoSF4))
SA2->(dbGoTo(_nRecNoSA2))
SD1->(dbGoTo(_nRecNoSD1))
SF1->(dbGoTo(_nRecNoSF1))

SD1->(dbSeek(xFilial("SD1")+ xNumero  + xPrefixo + xFornece + xLoja))
SA2->(dbSeek(xFilial("SA2")+ xFornece + xLoja))

Return

*-----------------------------*
Static Function fFormaPag()     
*-----------------------------*
Local oCboBox1
Local nCboBox1 := "1"
Local oGet1
Local cGet1 := Space(48)
Local oGet2
Local cGet2 := Space(48)
Local oGroup1
Local oSay1
Local oSay2
Local oSay3
Local oSButton1

Private lTST := .T.
//Private E2_XLINDIG

Static oDlg

While lTST                        

  DEFINE MSDIALOG oDlg TITLE "Dados adicionais da Duplicata : " + SF1->F1_DOC + " - Parcela: " + SE2->E2_PARCELA FROM 000, 000  TO 150, 500 COLORS 0, 16777215 PIXEL  

    @ 003, 001 GROUP oGroup1 TO 056, 248 OF oDlg COLOR 0, 16777215 PIXEL
    @ 010, 062 MSCOMBOBOX oCboBox1 VAR nCboBox1 ITEMS {"1 - Boleto","2 - DOC","3 - Cheque"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 011, 003 SAY oSay1 PROMPT "Forma de Pagamento :" SIZE 057, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 024, 062 MSGET oGet1 VAR cGet1 WHEN nCboBox1 = "1" SIZE 177, 010 OF oDlg COLORS 0, 16777215 PIXEL        
    @ 026, 016 SAY oSay2 PROMPT "Código de Barras :" SIZE 043, 007 OF oDlg COLORS 0, 16777215 PIXEL

    DEFINE SBUTTON oSButton1 FROM 059, 218 TYPE 01 OF oDlg ONSTOP "Confirmar Informações" ENABLE ACTION u_VldBotao(@cGet1,@cGet2,"1",nCboBox1)

  ACTIVATE MSDIALOG oDlg CENTERED
  
End

V_Tipo   := Left(nCboBox1,1)
V_LinDig := ConvLD(cGet1)
V_CodBar := ConvLD(cGet1)

Return

*----------------------------------------------*
User Function VldBotao(cGet1,cGet2,lcOp, cCBO)  
*----------------------------------------------*
If lcOP == "1"	
	// cGet2 := cGet1
	// E2_XLINDIG := cGet1
	//cGet2 := U_CONVLD()
	V_LinDig := cGet1	

	If cCBO = "1" .AND. Empty(cGet1)
		Alert("Favor informar o código de barras do Boleto.")
		lTST := .T.
		Return lTST
	EndIf	
	
	If U_CodBar(cGet1)
		lTST := .F.
		oDlg:End()
	Else
		lTST := .T.
	EndIf
	
ElseIf lcOp == "1" .AND. cCBO <> "1"
	cGet2 := cGet1 := Space(48)	
	lTST := .F.	
	oDlg:End()
Else
	lTST := .F.
	oDlg:End()
EndIf		
oDlg:Refresh()     	
Return .T.

*-----------------------------*
Static Function fTipoPag()     
*-----------------------------*
Local oCboBox1
Local nCboBox1 := "1"
Local oGroup1

Local oSButton1

Private lTST := .T.

Static oDlg1

DEFINE MSDIALOG oDlg1 TITLE "Dados adicionais da Duplicata : " + SF1->F1_DOC + " - Parcela: " + SE2->E2_PARCELA FROM 000, 000  TO 150, 500 COLORS 0, 16777215 PIXEL  

    @ 003, 001 GROUP oGroup1 TO 056, 248 OF oDlg COLOR 0, 16777215 PIXEL
    @ 010, 062 MSCOMBOBOX oCboBox1 VAR nCboBox1 ITEMS {"1 - Boleto","2 - DOC","3 - Cheque"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 011, 003 SAY oSay1 PROMPT "Forma de Pagamento :" SIZE 057, 007 OF oDlg COLORS 0, 16777215 PIXEL

DEFINE SBUTTON oSButton1 FROM 059, 218 TYPE 01 OF oDlg1 ONSTOP "Confirmar Informações" ENABLE ACTION Close(oDlg1)

ACTIVATE MSDIALOG oDlg1 CENTERED
  
V_Tipo   := Left(nCboBox1,1)

Return

///--------------------------------------------------------------------------\
//| Função: CONVLD 
//|--------------------------------------------------------------------------|
//| Descrição: Função para Conversão da Representação Numérica do Código de  |
//|            Barras - Linha Digitável (LD) em Código de Barras (CB).       |
//|                                                                          |
//|            Para utilização dessa Função, deve-se criar um Gatilho para o |
//|            campo E2_CODBAR, Conta Domínio: E2_CODBAR, Tipo: Primário,    |
//|            Regra: EXECBLOCK("CONVLD",.T.), Posiciona: Não.               |
//|                                                                          |
//|            Utilize também a Validação do Usuário para o Campo E2_CODBAR  |
//|            EXECBLOCK("CODBAR",.T.) para Validar a LD ou o CB.            |
//\--------------------------------------------------------------------------/
Static FUNCTION ConvLD(_cCodBar)
Local _cStr
//
_cStr := AllTRIM(_cCodBar)

IF VALTYPE(_cCodBar) == NIL .OR. EMPTY(_cCodBar)
	// Se o Campo está em Branco não Converte nada.
	_cStr := ""
ELSE
	// Se o Tamanho do String for menor que 44, completa com zeros até 47 dígitos. Isso é
	// necessário para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
	_cStr := IF(LEN(_cStr)<44,_cStr+REPL("0",47-LEN(_cStr)),_cStr)
ENDIF

DO CASE
CASE LEN(_cStr) == 47
	_cStr := SUBSTR(_cStr,1,4)+SUBSTR(_cStr,33,15)+SUBSTR(_cStr,5,5)+SUBSTR(_cStr,11,10)+SUBSTR(_cStr,22,10)
CASE LEN(_cStr) == 48
   _cStr := SUBSTR(_cStr,1,11)+SUBSTR(_cStr,13,11)+SUBSTR(_cStr,25,11)+SUBSTR(_cStr,37,11)
OTHERWISE
	_cStr := _cStr+SPACE(48-LEN(_cStr))
ENDCASE

RETURN(_cStr)
