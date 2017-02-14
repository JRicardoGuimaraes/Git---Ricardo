#include "PROTHEUS.ch"
#include "rwmake.ch"    
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³TMA050GRV ³ Autor ³ Katia Alves Bianchi   ³ Data ³19.04.2010	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizar a qtde de documentos no DTP apos a gravacao da NF 	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gefco                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TMA050GRV()

Local cAliasQry := ''
Local aAreaAtu  := GetArea()
Local aAreaDTC  := DTC->(GetArea())
Local aAreaDC5  := DC5->(GetArea())
Local aAreaDTP  := DTP->(GetArea())
Local cLotNfc   := DTC->DTC_LOTNFC
Local cTipServic:=""
Local cStaLote  :=""
Local nCount	:= 0     
Local nQtdDig   := 0
Local nQtdDTC   := 0 

DTP->(dbSetOrder(2))
If DTP->(dbSeek(xFilial('DTP')+cFilAnt+M->DTC_LOTNFC)) .And. DTP->DTP_QTDLOT == 99999
//	If MsgYesNo('Deseja finalizar o lote?',{'Sim','Não'})
	If MsgYesNo('Deseja finalizar o lote?')	
		
		For nCnt := 1 To Len(aCols)
			If !GdDeleted(nCnt)
				nQtdDig += 1
			EndIf
		Next nCnt
		
		cAliasDTC := GetNextAlias()
		cQuery := "SELECT COUNT(*) QTDDIG"
		cQuery += "  FROM "+RetSqlName("DTC")+ " DTC "
		cQuery += " WHERE DTC.DTC_FILIAL = '"+xFilial("DTC")+"'"
		cQuery += "   AND DTC.DTC_FILORI = '"+cFilAnt+"'"
		cQuery += "   AND DTC.DTC_LOTNFC = '"+M->DTC_LOTNFC+"'"
		cQuery += "   AND DTC.D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTC)
		If (cAliasDTC)->(!Eof())
			nQtdDTC := (cAliasDTC)->QTDDIG
		EndIf
		(cAliasDTC)->(dbCloseArea())
		RecLock('DTP',.F.)
		DTP->DTP_QTDLOT := nQtdDTC+nQtdDig-1
		DTP->DTP_QTDDIG := nQtdDTC+nQtdDig-1
		DTP->DTP_STATUS := '2'
		MsUnLock()
		RestArea(aAreaAtu)
	EndIf 
	
EndIf


Dbselectarea("DC5")
Dbsetorder(1)
If Dbseek(xFilial("DC5")+DTC->DTC_SERVIC) // Verifica se o Servico tem Rateio por qtde de documentos
	If DC5->DC5_Tiprat="4"
		cTipServic:="4"
	Else
		cTipServic:="0"
	Endif
Else
	cTipServic:="0"
Endif

Dbselectarea("DTP")
Dbsetorder(2)
If Dbseek(xFilial("DTP")+DTC->DTC_FILORI+DTC->DTC_LOTNFC) // Verifica se o lote está com status digitado
	cStaLote:=DTP->DTP_STATUS
Endif

If cTipServic=='4' .and. cStaLote=='2' //Se o servico possuir rateio por documento e o lote estiver com status digitado, verifico a quantidade de documentos do lote
	
	cAliasQry := GetNextAlias()
	cQuery := "SELECT DTC_CLIREM, DTC_LOJREM,DTC_CLIDEV, DTC_LOJDEV, DTC_CLIDES,DTC_LOJDES,DTC_CLICON, DTC_LOJCON,DTC_CLIDPC, DTC_LOJDPC, DTC_CLICAL, DTC_LOJCAL,"
	cQuery += "       DTC_CDRORI, DTC_CDRDES,DTC_CDRCAL, DTC_SERVIC,DTC_TIPFRE, SUM(DTC_PESO)PESO, COUNT(DTC_NUMNFC)QTDE_NF "
	cQuery += "  FROM "+RetSqlName('DTC')
	cQuery += " WHERE DTC_FILIAL = '"+xFilial('DTC')+"'"
	cQuery += "   AND DTC_FILORI = '"+cFilAnt+"'"
	cQuery += "   AND DTC_LOTNFC = '"+cLotNfc+"'"
	cQuery += "   AND D_E_L_E_T_ = ' '"
	cQuery += " GROUP BY DTC_CLIREM, DTC_LOJREM,DTC_CLIDEV, DTC_LOJDEV, DTC_CLIDES,DTC_LOJDES,DTC_CLICON, DTC_LOJCON,DTC_CLIDPC, DTC_LOJDPC,DTC_CLICAL, DTC_LOJCAL,DTC_CDRORI, DTC_CDRDES,DTC_CDRCAL, DTC_SERVIC,DTC_TIPFRE"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
	While (cAliasQry)->(!Eof())
		nNfCTRC:=0
		aContrt := TMSContrat( (cAliasQry)->DTC_CLICAL, (cAliasQry)->DTC_LOJCAL,, (cAliasQry)->DTC_SERVIC, .F., (cAliasQry)->DTC_TIPFRE,,,(cAliasQry)->DTC_CLIREM,(cAliasQry)->DTC_LOJREM,(cAliasQry)->DTC_CLIDES,(cAliasQry)->DTC_LOJDES)
		If	aContrt[ 1, 22 ]=='2'
			nNfCTRC:=(cAliasQry)->QTDE_NF
		Else
			nPsCTRC := aContrt[ 1, 20]
			nNfCTRC := aContrt[ 1, 8 ]
			If (cAliasQry)->QTDE_NF>nNfCTRC //Verifica se a quantidade de notas do lote ultrapassa a quantidade de notas por do CTRC
				cPesoDoc:=(cAliasQry)->PESO/Int(((cAliasQry)->QTDE_NF/nNfCTRC)+1)	 //Calcula a média de peso com base na quantidade de ctrc
				If cPesoDoc>nPsCTRC
					nNfCTRC:=Int(((cAliasQry)->PESO/nPsCTRC)+1)			//Int(((cAliasQry)->QTDE_NF/nNfCTRC)+1)+Int((cPesoDoc/nPsCTRC)+1)
				Else
					nNfCTRC:=Int(((cAliasQry)->QTDE_NF/nNfCTRC)+1)
				EndIf
				
			Else
				If (cAliasQry)->PESO>nPsCTRC //Verifica se o peso do  lote ultrapassa o peso maximo por do CTRC
					nNfCTRC:=Int(((cAliasQry)->PESO/nPsCTRC)+1)
				Else
					nNfCTRC:=1
				EndIf
			EndIf
		Endif
		nCount += nNfCTRC
		(cAliasQry)->(Dbskip())
	Enddo
	
	If nCount > 0 //Se a quantidade de documentos for maior que zero, gravo a  quantidade de documentos no DTP (lote)
		Dbselectarea("DTP")
		Dbsetorder(2)
		If Dbseek(xFilial("DTP")+DTC->DTC_FILORI+DTC->DTC_LOTNFC) // Verifica se o lote está com status digitado
			RecLock('DTP',.F.)
			DTP->DTP_XNRDOC:=nCount
			MsUnLock()
		Endif
	EndIf
	(cAliasQry)->(dbCloseArea())
EndIf

If DTC->(FieldPos('DTC_SEQDIG')) > 0
	RecLock('DTC',.F.)
	DTC->DTC_SEQDIG := DTC->(Recno())
	MsUnLock()
EndIf


RestArea(aAreaDTC)
RestArea(aAreaDC5)
RestArea(aAreaDTP)
RestArea(aAreaAtu)

Return NIL