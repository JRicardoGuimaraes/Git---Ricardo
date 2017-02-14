#include 'TOTVS.CH'  
#include 'Protheus.CH'  

//-------------------------------------------------------------------------------------------------
/*

*/
//-------------------------------------------------------------------------------------------------
User Function TMALTREG()

// --- Variaveis utilizadas
Local _aReg		:= ParamIxb

Local _aArea	:= GetArea()
Local _aAreaDTQ	:= DTQ->(GetArea())
Local _aAreaDA8	:= DA8->(GetArea())
Local _cTipRota	:= "" 

// --- Somente rota administrada
DA8->(dbSetOrder(1))
DA8->(dbSeek(xFilial("DA8")+DTQ->DTQ_ROTA))
_cTipRota	:= DA8->DA8_TIPROT

// --- Somente entrega e rota administrada  
If DTQ->DTQ_SERTMS == "3" .and. _cTipRota == "20"
	_aReg[1] := "BRASIL" 
	_aReg[2] := "BRASIL"     
EndIf                

RestArea(_aAreaDTQ)
RestArea(_aAreaDA8)
RestArea(_aArea)

Return(_aReg)