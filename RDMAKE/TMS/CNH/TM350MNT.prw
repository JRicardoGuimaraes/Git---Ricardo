#include 'TOTVS.CH'

#DEFINE _cinterface201	'WS Interface201'

User Function TM350MNT
//-------------------------------------------------------------------------------------------------
/* {2LGI} TM350MNT
@autor		: Luiz Alexandre
@descricao	: Ponto de entrada no apontamento da operacao de saida de viagem.
@since		: Ago./2014
@using		: Interface CNH - Metodo interface201
@review		:
*/
//-------------------------------------------------------------------------------------------------
// ---	Variaveis utilizadas
Local _aParam	:= 	ParamIxb
Local _aAreaDTQ	:= 	DTQ->(GetArea())
Local _aAreaDTW	:= 	DTW->(GetArea())
Local _aAreaDUP	:= 	DUP->(GetArea())
Local _aAreaDT6	:= 	DT6->(GetArea())
Local _aArea	:= 	GetArea()

// --- Tratamento temporário
U_TM350GRV( {_aParam[5],_aParam[6],_aParam[2] } ) 


// ---	Restaura areas
RestArea(_aArea)
RestArea(_aAreaDT6)
RestArea(_aAreaDTW)
RestArea(_aAreaDUP)
RestArea(_aAreaDTQ)

Return
