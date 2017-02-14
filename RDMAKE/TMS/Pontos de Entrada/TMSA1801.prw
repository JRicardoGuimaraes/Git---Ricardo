//-------------------------------------------------------------------------------------------------
/* {2LGI} TMSA1801
@autor	    : Luiz Alexandre
@descricao	: Funcao princial da rotina
@since		: Mai./2014
@using		: Atualiza condicao do filtro na geracao de solicitacao de coleta automatica.0
@review		:
*/
//-------------------------------------------------------------------------------------------------
User Function TMSA1801

// --- Variaveis utilizadas
Local _cCond	:= ParamIxb                                                                       

// --- Atualiza a cindicao do filtro
_cCond += 'DUE_FILSOL == "'+cFilAnt+'"'

Return _cCond