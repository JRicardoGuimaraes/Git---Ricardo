#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA280QRY  º Autor ³ Saulo Muniz        º Data ³  18/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Destinado a gravacao de dados complementares (especifico   º±±
±±º          ³ Gefco) na rotina de substituicao Fatura Receber            º±±
±±º          ³ ( FINA280 )                                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7 - Financeiro / Ctas Receber / Faturas Receber (FINA280)º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FA280QRY
Local aArea:=GetArea()
Local aAreaSA1:=SA1->(GetArea())
Local cQuery := ""
Local oGetNumCVA
Local oMoldura
Local oNumCVA
Local oSButton1


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//  
Static oDlg

Private cCusto   := Space(10)
Private _cCliMAN := AllTrim(GETNewPar("MV_XCLIMAN","04858701|15882200"))
PRIVATE cGetNumCVA := SPACE(TAMSX3("E1_NUMCVA")[1])

lRet := ""

// Verifica se existe portador - Saulo Muniz ( 18/07/06 )

lRet := " E1_PORTADO = '' "  
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+cCli+cLoja)

If SA1->A1_XLIBPG == "2"  //Libera mediante preenchimento do campo SE1->E1_XDTLIB
	lRet+=" AND E1_XDTLIB <> ' ' "
EndIf

// Por: Ricardo Guimarães - Em: 14/03/14 - Para atender o Projeto MAN
If cCli + cLoja $ _cCliMAN
  DEFINE MSDIALOG oDlg TITLE "Informar Numero do CVA(MAN)" FROM 000, 000  TO 120, 250 COLORS 0, 16777215 PIXEL

    @ 002, 002 GROUP oMoldura TO 043, 116 OF oDlg COLOR 0, 16777215 PIXEL
    @ 014, 007 SAY oNumCVA PROMPT "Informe o Número do CVA" SIZE 091, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 023, 007 MSGET oGetNumCVA VAR cGetNumCVA SIZE 090, 010 OF oDlg PICTURE "@!" COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 046, 090 TYPE 01 OF oDlg ENABLE ACTION oDlg:End()

  ACTIVATE MSDIALOG oDlg CENTERED
  
  If !Empty(cGetNumCVA)
  	lRet += " AND E1_NUMCVA = '" + AllTrim(cGetNumCVA) + "' "
  	PUTMV("MV_XNUMCVA",cGetNumCVA)
  EndIf	
EndIf

RestArea(aAreaSA1)
RestArea(aArea)
Return lRet
