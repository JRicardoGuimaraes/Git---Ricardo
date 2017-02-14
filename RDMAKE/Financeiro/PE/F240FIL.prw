#include "topconn.ch"   
#Include "PROTHEUS.CH" 
#include "rwmake.ch"    
 
/*
*---------------------------------------------------------------------------*
* Função     |F240FIL   | Autor | J Ricardo             | Data | 23.03.10   *
*---------------------------------------------------------------------------*
* Descrição  |Ponto de entrada que atua na rotina FINA240, Borderô de pagto.*
*            |PE utilizado para criar filtro por fornecedor                 *
*            |                                                              *
*---------------------------------------------------------------------------*
*/

USER FUNCTION F240FIL()
Local oGetForn
Local oGetNatAte
Local cGetNatAte := Space(TamSX3("ED_CODIGO")[1])
Local oGetNatDe
Local cGetNatDe := Space(TamSX3("ED_CODIGO")[1])
Local oGetPrefAte
Local cGetPrefAte := Space(TamSX3("E2_PREFIXO")[1])
Local oGetPrefDe
Local cGetPrefDe := Space(TamSX3("E2_PREFIXO")[1])
Local oGetTipo
Local cGetTipo := Space(TamSX3("E2_TIPO")[1])
Local oGetTitAte
Local cGetTitAte := Space(TamSX3("E2_NUM")[1])
Local oGetTitDe
Local cGetTitDe := Space(TamSX3("E2_NUM")[1])
Local oGroup1
Local oOk
Local oSay1
Local oSayForn
Local oSayNat1
Local oSayNat2
Local oSayPref1
Local oSayPref2
Local oSayTipo
Local oSayTit1
Local oSayTit2
Local _cStr    := ""
//Local _aArea   := GetArea()
Static oDlg

PRIVATE cGetForn := Space(TamSX3("A2_COD")[1])

DEFINE MSDIALOG oDlg TITLE "Filtrar Dados" FROM 000, 000  TO 300, 295 COLORS 0, 16777215 PIXEL

    @ 007, 004 GROUP oGroup1 TO 126, 144 PROMPT " Filtro " OF oDlg COLOR 0, 16777215 PIXEL
    @ 016, 014 SAY oSayForn PROMPT "Fornecedor :" SIZE 032, 008 OF oDlg COLORS 0, 16777215 PIXEL
//    @ 020, 008 SAY oSay1 PROMPT "Fornecedor :" SIZE 037, 008 OF oSayForn COLORS 0, 16777215 PIXEL
    @ 029, 014 SAY oSayTit1 PROMPT "Título de:" SIZE 029, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 042, 014 SAY oSayTit2 PROMPT "Título até :" SIZE 030, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 057, 014 SAY oSayPref1 PROMPT "Prefixo de :" SIZE 031, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 071, 014 SAY oSayPref2 PROMPT "Prefixo até :" SIZE 031, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 084, 014 SAY oSayTipo PROMPT "Tipo :" SIZE 034, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 098, 014 SAY oSayNat1 PROMPT "Natureza de :" SIZE 035, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 110, 014 SAY oSayNat2 PROMPT "Nature até :" SIZE 034, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 015, 050 MSGET oGetForn VAR cGetForn SIZE 050, 010 OF oDlg PICTURE "@!" VALID Empty(cGetForn) .OR. ExistCPO("SA2") COLORS 0, 16777215 F3 "SA2" PIXEL
    @ 028, 050 MSGET oGetTitDe VAR cGetTitDe SIZE 050, 010 OF oDlg PICTURE "@!" COLORS 0, 16777215 PIXEL
    @ 042, 050 MSGET oGetTitAte VAR cGetTitAte SIZE 050, 010 OF oDlg PICTURE "@!" COLORS 0, 16777215 PIXEL
    @ 056, 050 MSGET oGetPrefDe VAR cGetPrefDe SIZE 025, 010 OF oDlg PICTURE "@!" COLORS 0, 16777215 PIXEL
    @ 069, 050 MSGET oGetPrefAte VAR cGetPrefAte SIZE 025, 010 OF oDlg PICTURE "@!" COLORS 0, 16777215 PIXEL
    @ 083, 050 MSGET oGetTipo VAR cGetTipo SIZE 050, 010 OF oDlg PICTURE "@!" COLORS 0, 16777215 F3 "05" PIXEL
    @ 097, 050 MSGET oGetNatDe VAR cGetNatDe SIZE 075, 010 OF oDlg PICTURE "@!" COLORS 0, 16777215 F3 "SED" PIXEL
    @ 110, 050 MSGET oGetNatAte VAR cGetNatAte SIZE 075, 010 OF oDlg PICTURE "@!" COLORS 0, 16777215 F3 "SED" PIXEL
    DEFINE SBUTTON oOk FROM 132, 117 TYPE 01 OF oDlg ENABLE ACTION (oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

// Fornecedor
If !Empty(cGetForn)
  _cStr    := 'E2_FORNECE = "' + cGetForn + '"'
EndIf

// Título                   
If !Empty(cGetTitDe) .OR. !Empty(cGetTitAte)
   If !Empty(_cStr)
   	_cStr += ' .AND. '
   EndIf
   	
  _cStr    += 'E2_NUM >= "' + cGetTitDe + '" .AND. E2_NUM <= "' + cGetTitAte + '"'
EndIf

// Prefixo
If !Empty(cGetPrefDe) .OR. !Empty(cGetPrefAte)
   If !Empty(_cStr)
   	_cStr += ' .AND. '
   EndIf
   	
  _cStr    += 'E2_PREFIXO >= "' + cGetPrefDe + '" .AND. E2_PREFIXO <= "' + cGetPrefAte + '"'
EndIf  

// Tipo
If !Empty(cGetTipo)
   If !Empty(_cStr)
   	_cStr += ' .AND. '
   EndIf
   	
  _cStr    += 'E2_TIPO = "' + cGetTipo + '"'
EndIf  

// Natureza
If !Empty(cGetNatDe) .OR. !Empty(cGetNatAte)
   If !Empty(_cStr)
   	_cStr += ' .AND. '
   EndIf
   	
  _cStr    += 'E2_NATUREZ >= "' + cGetNatDe + '" .AND. E2_NATUREZ <= "' + cGetNatAte + '"'
EndIf  

//RestArea(_aArea)

Return _cStr
