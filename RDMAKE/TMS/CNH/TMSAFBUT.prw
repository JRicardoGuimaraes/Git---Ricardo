#include 'TOTVS.CH'

User Function TMSAFBUT 
//-------------------------------------------------------------------------------------------------
/* {2LGI} TMSAFBUT
@autor		: Luz Alexandre
@descricao	: Valida se o plano pode ser confirmado
@since		: Ago./2014
@using		: Interface CNH 
@review		:
*/
//-------------------------------------------------------------------------------------------------
// ---	Variaveis utilizadas
Local	_aButtom	:= {} 
Local	_lRet		:= .f.  

// ---	Confirmacao
If ParamIxb[1] == 6

	If DF0->DF0_STPLAN == '0' 	
		
		// --- Adiciona para transmitir aceite	
		AAdd(aSetKey  ,{ VK_F9     ,{ || U_GEFINTCNH('101') } } )
		AAdd(_aButtom ,{ 'SDUPROP' ,{ || U_GEFINTCNH('101') }, '<F9>', 'CNH Aceite Plano' })  

	EndIf

EndIf  
 
Return _aButtom 
