#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ALTSF3   ³ Autor ³   Saulo Muniz         ³ Data ³ 07/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Altera campos relacionados ao Livro Fiscal                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Gefco do Brasil S/A.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Manutenc. ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER FUNCTION ALTSF3

aRotina := {{ "Pesquisa","AxPesqui", 0 , 1},;
{ "Visual","AxVisual", 0 , 2},;
{ "Altera","U_GEFLIVRO", 0 , 3, 20 }}

cCadastro := OemToAnsi("Dados complementares da Nota Fiscal")
mBrowse( 06, 01, 22, 75, 'SF3',,,,)

RETURN

USER FUNCTION GEFLIVRO


cNum     := SF3->F3_NFISCAL+"/"+SF3->F3_SERIE
cDescric := SF3->F3_CLIEFOR+" - "+SF3->F3_LOJA
//cProduto := SF3->F3_COD                                        
//cDescPro := Alltrim(Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC"))
//cTES     := SF3->F3_TES
//cClasfis := SF3->F3_CLASFIS
cCfop    := SF3->F3_CFO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 081,019 To 543,674 Dialog oDlg Title OemToAnsi("Dados Complementares da Nota")

@ 008,009 Say OemToAnsi("NF/Serie :") Size 35,15
@ 007,045 Say cNUM                    Size 35,15

@ 007,120 Say OemToAnsi("Fornecedor:") Size 35,15
@ 006,160 Say cDescric                 Size 150,20

@ 007,220 Say OemToAnsi("Filial : ")   Size 38,18
@ 006,240 Say xFilial("SF3")           Size 76,21

@ 025,008 To 199,311 Title OemToAnsi("Dados Complementares")

//@ 039,018 Say OemToAnsi("Produto : ")  Size 41,08
//@ 039,054 Get cProduto 	               Valid FAtuNome() .And. NaoVazio() .and. ExistCpo("SB1") F3 "SB1" Size 40,15
//@ 039,110 Get cDescPro                 Size 156,10

@ 057,018 Say OemToAnsi("Cfop : ") Size 38,8
@ 055,054 Get cCfop    Valid NaoVazio() .and. ExistCpo("SX5","13"+cCfop)  F3 "13"            Size 76,21

//@ 075,018 Say OemToAnsi("TES :")  Size 70,8
//@ 074,054 Get cTES Valid NaoVazio() .and. ExistCpo("SF4")  F3 "SF4" Size 40,15

//@ 075,110 Say OemToAnsi("Sit.Tributária : ")  Size 70,8
//@ 074,157 Get cClasfis                        Size 40,10

@ 208,224 Button OemToAnsi("_OK") Size 36,16 Action FGRAVADADOS()
@ 208,274 Button OemToAnsi("_SAIR") Size 36,16 Action Close(oDlg)
     

Activate Dialog oDlg Center
Return


Static Function FGRAVADADOS()

Close(odlg)

If MsgYesNo(OemToAnsi("Confirma Gravacao"),OemToAnsi('ATENCAO'))
	
	_aArea := GetArea()
	
	dbSelectArea("SF3")
	RecLock("SF3",.F.)
	//SF3->F3_COD := cProduto
	//SF3->F3_TES := cTES
	//SF3->F3_CLASFIS := cClasfis
    SF3->F3_CFO  := cCfop 
	MsUnLock()
	
	RestArea(_aArea)
	
Endif

Return


Static Function FAtuNome()

cDescPro := SB1->B1_DESC 

Return .T.
