#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

User Function DBF2SQL()        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("XVERS,XCHV,XARQ,")

//======================================================
//  Conversao de Arquivos DBF para SQL
//======================================================

xVers := "DBF to SQL"
xChv := Space(3)
//xArq := "D:\SIGA\SIGAADV\"+Space(40)
@ 200,001 TO 360,340 DIALOG oDlg TITLE xVers
@ 010,010 Say "Digite o Alias do Arquivo"
@ 010,100 Get xChv Picture "@!"
//@ 020,010 Say "Digite o Caminho do Arquivo"
//@ 030,010 Get xArq Picture "@!"
@ 045,048 BMPBUTTON TYPE 01 ACTION Roda()// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> @ 045,048 BMPBUTTON TYPE 01 ACTION Execute(Roda)
@ 045,088 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

//=============//
// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==>   Function Roda
Static Function Roda()
//=============//  

If MsgBox("Deseja Realmente Converter o Arquivo de DBF para Base SQL ?","","YESNO")
	xArq := xChv+".DBF"
	DbSelectArea(xChv)
	DbSetOrder(1)
	Appen From &xArq
Endif

MSGINFO("Fim do Append !")

Return .t.

