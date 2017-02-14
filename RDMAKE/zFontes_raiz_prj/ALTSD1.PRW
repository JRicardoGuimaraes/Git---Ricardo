#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ALTSD1   ³ Autor ³   Saulo Muniz         ³ Data ³ 16/12/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Altera campos relacionados a entrada de compras            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Gefco do Brasil S/A.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Manutenc. ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER FUNCTION ALTSD1

// Adicionado campo de Cfop - Saulo Muniz 21/12/04

aRotina := {{ "Pesquisa","AxPesqui", 0 , 1},;
{ "Visual","AxVisual", 0 , 2},;
{ "Altera","U_ALTLIVRO", 0 , 3, 20 }}

cCadastro := OemToAnsi("Dados complementares da Nota Fiscal")

//mBrowse( 06, 01, 22, 75, 'SC5',,,,'EMPTY(SC5->C5_NOTA)')
mBrowse( 06, 01, 22, 75, 'SD1',,,,)

RETURN

USER FUNCTION ALTLIVRO

Public _cNomeTransp

//If !EMPTY(SC5->C5_NOTA)
//	MsgAlert("Desculpe, não é permitido alterar pedido totalmente faturado.")
//	Return
//Endif	  

cNum     := SD1->D1_DOC+"/"+SD1->D1_SERIE
cDescric := SD1->D1_FORNECE+" - "+SD1->D1_LOJA
cProduto := SD1->D1_COD                                        
cDescPro := Alltrim(Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC"))
cTES     := SD1->D1_TES
cClasfis := SD1->D1_CLASFIS
cCfop    := SD1->D1_CF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 081,019 To 543,674 Dialog oDlg Title OemToAnsi("Dados Complementares da Nota")

@ 008,009 Say OemToAnsi("NF/Serie :") Size 35,15
@ 007,045 Say cNUM                    Size 35,15

@ 007,120 Say OemToAnsi("Fornecedor:") Size 35,15
@ 006,160 Say cDescric                 Size 150,20

@ 007,220 Say OemToAnsi("Filial : ")   Size 38,18
@ 006,240 Say xFilial("SD1")           Size 76,21


@ 025,008 To 199,311 Title OemToAnsi("Dados Complementares")

@ 039,018 Say OemToAnsi("Produto : ")  Size 41,08
@ 039,054 Get cProduto 	               Valid FAtuNome() .And. NaoVazio() .and. ExistCpo("SB1") F3 "SB1" Size 40,15
@ 039,110 Get cDescPro                 Size 156,10

@ 057,018 Say OemToAnsi("Cfop : ") Size 38,8
@ 055,054 Get cCfop    Valid NaoVazio() .and. ExistCpo("SX5","13"+cCfop)  F3 "13"            Size 76,21

@ 075,018 Say OemToAnsi("TES :")  Size 70,8
@ 074,054 Get cTES Valid NaoVazio() .and. ExistCpo("SF4")  F3 "SF4" Size 40,15

@ 075,110 Say OemToAnsi("Sit.Tributária : ")  Size 70,8
@ 074,157 Get cClasfis                        Size 40,10

@ 208,224 Button OemToAnsi("_OK") Size 36,16 Action FGRAVADADOS()
@ 208,274 Button OemToAnsi("_SAIR") Size 36,16 Action Close(oDlg)
     

Activate Dialog oDlg Center
Return



Static Function FGRAVADADOS()

Close(odlg)

If MsgYesNo(OemToAnsi("Confirma Gravacao"),OemToAnsi('ATENCAO'))
	
	_aArea := GetArea()
	
	dbSelectArea("SD1")
	RecLock("SD1",.F.)
	SD1->D1_COD := cProduto
	SD1->D1_TES := cTES
	SD1->D1_CLASFIS := cClasfis
    SD1->D1_CF  := cCfop 
	MsUnLock()
	
	RestArea(_aArea)
	
Endif

Return


Static Function FAtuNome()

cDescPro := SB1->B1_DESC 

Return .T.
