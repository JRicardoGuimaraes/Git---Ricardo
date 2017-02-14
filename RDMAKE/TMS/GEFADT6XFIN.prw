#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEFADT6XFIN         º Autor ³ Ricardo  º Data ³  28/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para suprir falta de PE na rotina TMSA500()         º±±
±±º          ³ complmento de CT-e, que ao gerar há necessidade de carregarº±±
±±º          ³ do CT-e original para o CT-e de complmento e para a tabela º±±
±±º          ³ SE1 - Financeiro                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TMS - CT-e de Complemento - TMSA500                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GEFADT6XFIN()
Local _cQry  := ""
Local _aArea := GetArea()

If !MsgYesNo("Esta rotina serve para carregar os dados complementares(CC Gefco e Inf. PSA) do CT-e complementado no CT-e gerado e no Financeiro."  + Chr(13) + Chr(13) + Chr(13) + " Confirma a executação desta rotina?")
	Return 
EndIf	

_cQry := " SELECT X.DT6_FILDOC, X.DT6_DOC, X.DT6_SERIE, X.DT6_DOCDCO, X.DT6_SERDCO, CP.R_E_C_N_O_ AS RECNO_COMPL, "
_cQry += "    	  CP.DT6_DOC DOC_COMPL, CP.DT6_SERIE SER_COMPL, X.DT6_CCUSTO, X.DT6_CCONT AS CCPSA, DT6_CONTA AS CTAPSA, DT6_OI AS OIPSA, "
_cQry += "	      CP.DT6_CLIDEV, CP.DT6_LOJDEV, SE1.R_E_C_N_O_ AS RECNO_SE1 "
_cQry += " FROM " + RetSqlName("DT6") + " X,  (SELECT A.DT6_FILDOC, A.DT6_DOC, A.DT6_SERIE, A.DT6_DOCDCO, A.DT6_SERDCO, A.R_E_C_N_O_, A.DT6_CLIDEV, A.DT6_LOJDEV "
_cQry += "		FROM " + RetSqlName("DT6") + " A "
_cQry += "		WHERE A.DT6_DATEMI >= '20140201' AND A.DT6_DOCTMS='8' AND A.DT6_CCUSTO='' AND A.DT6_DOCDCO <> '' AND A.D_E_L_E_T_='' "
_cQry += "		) CP, " + RetSqlName("SE1") + " SE1 "
_cQry += " WHERE X.DT6_FILDOC = CP.DT6_FILDOC "
_cQry += "  AND X.DT6_DOC = CP.DT6_DOCDCO "
_cQry += "  AND X.DT6_SERIE = CP.DT6_SERDCO "
_cQry += "  AND X.D_E_L_E_T_='' "  
_cQry += "  AND CP.DT6_FILDOC = E1_FILIAL "
_cQry += "  AND CP.DT6_DOC = E1_NUM "
_cQry += "  AND CP.DT6_SERIE = E1_SERIE "
_cQry += "  AND CP.DT6_CLIDEV = E1_CLIENTE "

_cQry := ChangeQuery(_cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"TDT6")

dbSelectArea("TDT6") ; dbGoTop()
ProcRegua(0)

While !TDT6->(Eof())
	IncProc("Atualizando dados complementar do CT-e de complemento")
	// Atualizo dados complementar no CT-e de complemento 
	dbSelectArea("DT6")
	dbGoTo(TDT6->RECNO_COMPL)
	RecLock("DT6",.F.)
		DT6->DT6_CCUSTO := TDT6->DT6_CCUSTO
		DT6->DT6_CCONT  := TDT6->CCPSA
		DT6->DT6_CONTA	:= TDT6->CTAPSA
		DT6->DT6_OI		:= TDT6->OIPSA
	MsUnLock()

	// Atualizo dados complementar no título do CT-e de complemento 
	dbSelectArea("SE1")
	dbGoTo(TDT6->RECNO_SE1)
	RecLock("SE1",.F.)
		SE1->E1_CCONT := TDT6->DT6_CCUSTO
		SE1->E1_CCPSA := TDT6->CCPSA
		SE1->E1_CTAPSA:= TDT6->CTAPSA
		SE1->E1_OIPSA := TDT6->OIPSA
	MsUnLock()
	
	dbSelectArea("TDT6")	
	TDT6->(dbSkip())
End

dbSelectArea("TDT6")
TDT6->(dbCloseArea())

MsgInfo("Processo concluído.", "INFO")
	
RestArea(_aArea)
Return Nil