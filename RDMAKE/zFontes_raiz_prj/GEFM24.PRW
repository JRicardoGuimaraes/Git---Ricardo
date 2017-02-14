#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GEFM24    ³ Autor ³ Saulo Muniz           ³ Data ³ 11.04.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Replicaçãodos dados cadastrais para os campo de cobrança    ³±±
±±³          ³quando os clientes importados não possuir estes.            ³±±
±±³                                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GEFM24()    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Atualiza dados Clientes ADHOC - Cobrança")
@ 02,10 TO 080,190
@ 10,018 Say " Este Programa ira ler o conteudo do Arquivo,"
@ 18,018 Say " de Clientes AP5 e Atualizar o endereço de Cobrança"
@ 26,018 Say " em Branco, com o Endereço Principal."
@ 60,098 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 60,128 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
Activate Dialog oLeTxt Centered
Return

Static Function OkLeTxt

Processa({|| RunCont() },"Processando...")
Close(oLeTxt)
Return

Static Function RunCont

DbSelectArea("SA1") 
Dbgotop()

While !EOF()
   
   IncProc()  
   DbSelectArea("SA1") 
   IF Empty(A1_ENDCOB)
    RecLock("SA1",.F.)     
    SA1->A1_ENDCOB  := Alltrim(SA1->A1_END)
    SA1->A1_BAIRROC := SA1->A1_BAIRRO
    SA1->A1_MUNC    := SA1->A1_MUN
    SA1->A1_ESTC    := SA1->A1_EST
    SA1->A1_CEPC    := SA1->A1_CEP   
    MSUnLock() 
   Endif
 
   dbSkip()    

EndDo           

Return