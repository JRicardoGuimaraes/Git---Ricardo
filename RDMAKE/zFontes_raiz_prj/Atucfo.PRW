#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³UPDCFO    ³ Autor ³ Nereu Humberto Junior ³ Data ³04/12/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de atualizacao de CFOP.                           ³±±
±±³          ³ Atualiza SF4/SC6/SCK                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao do SIGAFIS                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Atucfo()

LOCAL nOpca	   :=	0
LOCAL aSays	   :=	{}
LOCAL aButtons :=	{}

AADD(aSays,"Esta rotina ira fazer o De/Para de CFOP")

AADD(aButtons,{ 1,.T.,{|o| nOpca:= 1, o:oWnd:End() }} )
AADD(aButtons,{ 2,.T.,{|o| o:oWnd:End() }} )

FormBatch("De/Para de CFOP",aSays,aButtons,,150,350 ) //190/395
	
IF nOpcA == 1
	Processa({||FisProcCfo()},,"Atualizando CFOP no cadastro de TES")
//	Processa({||AtuCfoP()},,"Atualizando CFOP nos itens do pedido de venda")
Endif	

Aviso("Atencao !!", "Processamento Efetuado com Sucesso !!", {" Ok "})

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AtuCfoP  ³ Autor ³ Nereu Humberto Jr.    ³ Data ³05/12/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de De/Para de CFOP na tabela SC6                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao FIS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FisProcCfo()

dbSelectArea("SF4")
ProcRegua(RecCount())
dbSeek(xFilial("SF4"),.T.)
While !Eof() .And. xFilial("SF4") == SF4->F4_FILIAL
	IncProc("Efetuando De/Para CFOP: "+F4_CF)
	If !Empty(F4_CFNOVO)
		Begin Transaction
		RecLock("SF4",.F.)
		SF4->F4_CF := SF4->F4_CFNOVO
		MsUnlock()
		End Transaction
	EndIf
	dbSkip()
EndDo

Return
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AtuCfoP  ³ Autor ³ Nereu Humberto Jr.    ³ Data ³05/12/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de De/Para de CFOP na tabela SC6                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao FIS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuCfoP()

Local cQuery    := ""
Local cFiltro   := ""
Local cIndex    := ""
Local nIndex
Local cAliasSC6 := ""
Local aArea := GetArea()

dbSelectArea("SF3")
ProcRegua(RecCount())

#IFDEF TOP
	cAliasSC6 := "AliasSF3"
	cQuery    := "SELECT R_E_C_N_O_ AS RECSF3, D1_CF "
	cQuery    += "FROM "+RetSqlName("SF3")+" SF3 "
	cQuery    += "WHERE SF3.F3_FILIAL='"+xFilial("SF3")+"' AND "
	cQuery    += "F3_CFO <> ' ' AND "
	cQuery    += "F3_ENTRADA >= '20030101' AND "
	cQuery    += "SF3.D_E_L_E_T_=' ' "
	
    cQuery    := ChangeQuery(cQuery)
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC6,.T.,.T.)
		
	While !Eof()
		IncProc("Atualizando CFOP's das Notas Fiscais...")
		SF3->(MsGoTo( (cAliasSF3)->RECSF3))
		If SF4->(dbSeek(xFilial("SF4")+(cAliasSF3)->F3_TES)) .And. !Empty(SF4->F4_CFNOVO)
			Begin Transaction
				dbSelectArea("SF3")
				RecLock("SF3",.F.)
				SF3->F3_CFO := Left(SF3->F3_CFO,1)+Substr(SF4->F4_CF,2,3)
				MsUnlock()
			End Transaction
		Endif
		dbSelectArea(cAliasSF3)
		dbSkip()
	EndDo
	(cAliasSF3)->(dbCloseArea())
#ELSE
	cIndex := CriaTrab(,.F.)
	//cFiltro := "F3_FILIAL=='"+xFilial("SF3")+"' "
	//cFiltro += ".And.C6_QTDVEN > C6_QTDENT "
	//cFiltro += ".And.C6_BLQ <> 'R ' "
		
	IndRegua("SF3",cIndex,SF3->(IndexKey()),,,"Selecionando Registros")
	nIndex := RetIndex("SF3")
    
	dbSelectArea("SD1")
		
	dbSelectArea("SF3")
	dbSetIndex(cIndex+OrdBagExt())
	DbSetOrder(nIndex+1)
	DbGoTop()
	While !Eof()
		IncProc("Atualizando CFOP's dos Pedidos...")
		If SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES)) .And. !Empty(SF4->F4_CFNOVO)
			Begin Transaction
				dbSelectArea("SF3")
				Reclock("SF3",.F.)
				SD1->D1_CF := Left(SF3->F3_CF,1)+Substr(SF4->F4_CF,2,3)
				MsUnlock()
			End Transaction
		Endif
		dbSelectArea("SF3")
		dbSkip()
	EndDo
	
	dbSelectArea("SF3")
	Set Filter To
	RetIndex("SF3")
	Ferase(cIndex+OrdBagExt())
#ENDIF
	
RestArea(aArea)
	
Return