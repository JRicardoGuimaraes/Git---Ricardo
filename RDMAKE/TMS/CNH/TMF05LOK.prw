#include 'TOTVS.CH'

User Function TMF05LOK
//-------------------------------------------------------------------------------------------------
/* {2LGI} TMF05LOK
@autor		: Luiz Alexandre
@descricao	: Ponto de entrada para o codigo da filial de origem como sendo a filial de confirmacao
@since		: Ago./2014
@using		: Interface CNH - Confirmacao do agendamento
@review		:
*/
//-------------------------------------------------------------------------------------------------
// ---	Variaveis utilizadas
Local _nOpcao	:=	ParamIxb
Local _nPos		:= 	0   
Local _nX		:=	0

// --- Altera conteudo do status a partir do retorno
_nPos 	:= Ascan( aHeader, { |x| x[2] = 'DF1_FILORI' }) 

// ---	Atualiza o campo na grid
For _nX	:= 1	to Len(aCols)
	aCols[_nX,nPos]	:= cFilAnt  
	M->DF1_FILORI	:= cFilAnt	
Next

Return

