#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F280CAN   º Autor ³ Ricardo            º Data ³  27/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atua no cancelamento de faturas do cliente MAN, verificandoº±±
±±º          ³ outras filiais                                             º±±
±±º          ³ Fatura MAN -> Multi filiais                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIN - Cancelamento de Fatura - MAN                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F280CAN()
Local _cQry := ""
Local cQuery:= ""
Local _cCliMAN := AllTrim(GetNewPar("MV_XCLIMAN","04858701|15882200"))
Local _cCliente:= SE1->E1_CLIENTE
Local _cLoja   := SE1->E1_LOJA
Local _aArea   := GetArea()
Local _nRegSE1 := SE1->(RECNO())

// Variaveis Private da rotina FINA280
// cPrefCan - cFatCan

If SE1->E1_CLIENTE + SE1->E1_LOJA $ _cCliMAN
	_cQry := " SELECT R_E_C_N_O_ AS RECNO FROM " + RetSqlName("SE1") + " SE1 "
	_cQry += "  WHERE D_E_L_E_T_ = '' "
	_cQry += "    AND E1_FATURA  = '" + cFatCan   + "'"
	_cQry += "    AND E1_FATPREF = '" + cPrefCan  + "'"
	_cQry += "    AND E1_CLIENTE = '" + _cCliente + "'"
	_cQry += "    AND E1_LOJA    = '" + _cLoja + "'"
	
	If Select("TSE1") > 0
		dbSelectArea("TSE1") ; dbCloseArea()
	EndiF	

	cQuery := ChangeQuery(_cQry)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSE1")
	
	dbSelectArea("TSE1") ; dbGoTop()

/*
	While !TSE1->(Eof())
		dbSelectArea("SE1")
		SE1->(dbGoTo(TSE1->RECNO))
		
		RecLock("SE1",.F.)
			SE1->E1_BAIXA   := CtoD("  /  /  ")
			SE1->E1_SALDO   := SE1->E1_VALOR
			SE1->E1_FATURA 	:= " "
			SE1->E1_FATPREF	:= " "
			SE1->E1_TIPOFAT	:= " "
			SE1->E1_DTFATUR	:= CtoD("  /  /  ")
			SE1->E1_VALLIQ  := 0
			SE1->E1_STATUS  := "A"
			SE1->E1_MOVIMEN := Ctod("  /  /  ")					
		MsUnLock()
		
		dbSelectArea("TSE1")
		TSE1->(dbSkip())
	
	End
*/
	
	dbSelectArea("TSE1") ; dbCloseArea()
	dbSelectArea("SE1")	
	GoTo(_nRegSE1)
EndIf

RestArea(_aArea)
Return Nil
