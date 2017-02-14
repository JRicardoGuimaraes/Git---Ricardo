#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AtuBase   ³ Autor ³ Nereu Humberto Junior ³ Data ³06/07/04  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de atualizacao de CFOP.                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao do SIGAFIS                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AtuBase()

LOCAL nOpca	   :=	0
LOCAL aSays	   :=	{}
LOCAL aButtons :=	{}

AADD(aSays,"Esta rotina ira fazer o Acerto da Base de dados ")

AADD(aButtons,{ 1,.T.,{|o| nOpca:= 1, o:oWnd:End() }} )
AADD(aButtons,{ 2,.T.,{|o| o:oWnd:End() }} )

FormBatch("De/Para de CFOP",aSays,aButtons,,150,350 ) //190/395
	
IF nOpcA == 1
	Processa({||ValidaGef()},,"Atualizando Livro Fiscal ...")
Endif	

Aviso("Atencao !!", "Processamento Efetuado com Sucesso !!", {" Ok "})

Return(.T.)


Static Function ValidaGef()

dbSelectArea("SF3")         
ProcRegua(RecCount())
Dbgotop()
//dbSeek(xFilial(),Dtini,.T.)

While !Eof() 
	//
	IncProc("Atualizando Base do Imposto (DATA) : "+F3_ENTRADA)
	//
	//If ALLTRIM(SF3->F3_TIPO) == "S"  //FILTRA NOTAS DE ISS
	//   DBSKIP()
	//   LOOP
	//EndIf
    //
    //If SF3->F3_ENTRADA < CTOD("01/01/2001") 
	//   DBSKIP()
	//   LOOP
	//EndIf
	//	
    //If SF3->F3_BASEICM == 0 .AND. SF3->F3_ALIQICM == 0 				
	//
    If SF3->F3_REPROC == "G" .AND. SF3->F3_ISENICM > 0		
        Begin Transaction
		RecLock("SF3",.F.)
		SF3->F3_REPROC  := "A"
		SF3->F3_OUTRICM := 0.00
        //SF3->F3_OUTRICM := SF3->F3_VALCONT
		MsUnlock()
		End Transaction				
   	//  EndIf			
	EndIf
	dbSkip()
EndDo

Return