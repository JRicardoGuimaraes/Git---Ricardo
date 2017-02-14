#include "PROTHEUS.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ VlQtdLot ³ Autor ³Katia Alves Bianchi    ³ Data ³14.08.2009	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida alteração do lote                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gefco                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function VlQtdLot()

Local lRet      := .T.
Local aAreaAtu  := GetArea()
Local aAreaDTC  := DTC->(GetArea())
Local aAreaDE5  := DC5->(GetArea())


If M->DTP_QTDLOT==M->DTP_QTDDIG
	DTC->(DbSetOrder(1))
	If DTC->(DbSeek(cSeekDVE := xFilial('DTC')+M->DTP_FILORI+M->DTP_LOTNFC))
		While DTC->(!Eof()) .And. xFilial('DTC')+DTC->DTC_FILORI+DTC->DTC_LOTNFC == cSeekDVE
			DbSelectArea("DC5")
			DC5->(DbSetOrder(1))
			If DC5->(DbSeek(xFilial('DC5')+DTC->DTC_SERVIC))
				If DC5->DC5_TIPRAT=='4'
				    Aviso("Atencao","O lote possui rateio por documento, a quantidade do lote não poderá ser alterada para quantidade igual a digitada!",{"Continuar"})
				 	lRet:=.F.
					Exit
				EndIf
			Endif
			DTC->(dbSkip())
		EndDo
	EndIf
EndIf

RestArea(aAreaDTC)
RestArea(aAreaDE5)
RestArea(aAreaAtu)

Return lRet