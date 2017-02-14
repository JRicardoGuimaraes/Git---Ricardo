#include 'TOTVS.CH'

//-------------------------------------------------------------------------------------------------
/* {2LGI} TMF05MNU
@autor		: Luz Alexandre
@descricao	: Adiciona botao para interface com a CNH
@since		: Jul./2014
@using		: Interface CNH
@review		:
*/
//-------------------------------------------------------------------------------------------------
User Function TMF05MNU
	
// --- Variaveis utilizadas	
Local _aCNHRotina 	:= {}
Local _aCNHOTMRot 	:= {}
Local _aCNHManut	:= {}

// --- Rotinas especificas CNH
_aCNHRotina	:=	{	{ 'Importar Planos'		, "U_GEFINTCNH('55')"	,0 ,3,0,.f. },;
						{ 'Informar Veiculo', "U_CNH201A()"			,0 ,3,0,.f. },;
						{ 'Informar CA'		, "U_CNHNUMCA()"			,0 ,3,0,.f. },;
						{ 'Viagem de Coleta', "U_GEFINTCNH('991')"	,0 ,3,0,.f. },;
						{ 'Imprimir Plano'		, "U_GEFCNHR3()"			,0 ,3,0,.f. },;
						{ 'Buscar Status'			, "U_GEFINTCNH('701')"	,0 ,3,0,.f. },;
						{ 'Pesq. Movimentacao'	, "U_GEFINTCNH('901')"	,0 ,3,0,.f. },;
						{ 'Informar Faturamento'	, "U_GEFINTCNH('601')"	,0 ,3,0,.f. },;
						{ 'Distancias por CNPJ'	, "U_GEFCNHCEP()"			,0 ,3,0,.f. },;
						{ 'Relação de planos'	, "U_GEFCNHR1()"			,0 ,3,0,.f. },;
;//						{ 'Dash'					, "U_EXEMPLO()"			,0 ,3,0,.f. },;
;//						{ 'Gestão Painel'			, "U_CNHPNLADM()"			,0 ,3,0,.f. },;
						{ 'Imprimir Log'			, "U_GEFCNHR2()"			,0 ,3,0,.f. },;
						{ 'Reg.Ocorrências'		, "U_GEFINTCNH('999')"	,0 ,3,0,.f. } }
	
_aCNHManut	:=	{	{ 'Vincular NFe'			, "U_GEFCNHNFE()"	,0 ,3,0,.f. },;
					{ 'Digita Lote'			, "U_GEFCNHLOT()"	,0 ,3,0,.f. }  }
	
	//-   ;						{ 'Dashboard'				, "U_EXEMPLO()"			,0 ,3,0,.f. },;
		
// --- 	Adiciona botões
// ---	Rotina principal
Aadd(aRotina, { "Interface CNH"     , _aCNHRotina	,0,3,0,.f. } )
Aadd(aRotina, { "Interface CNH-OTM" , _aCNHOTMRot	,0,3,0,.f. } )
	
// ---	Manutenção de planos
Aadd(aRotina, { "Filial" , _aCNHManut	,0,3,0,.f. } )

// --- Rotinas Especificas CNH - OTM
Aadd(_aCNHOTMRot,	{ "Importar Planos(204)"    , "U_GEFCNHOTM('204',.F.)" ,0,3,0,.f. } )
Aadd(_aCNHOTMRot,	{ "Aceitar/Rejeitar(990)"   , "U_GEFCNHOTM('990',.F.)" ,0,3,0,.f. } )
Aadd(_aCNHOTMRot,	{ "Informar Veiculo(214)"   , "U_OTM214A()"            ,0,3,0,.f. } )
Aadd(_aCNHOTMRot,	{ 'Reg.Ocorrências(214)'    , "U_GEFCNHOTM('999',.F.)" ,0,3,0,.f. } )
Aadd(_aCNHOTMRot,	{ "Gerar Monitoramento(214)", "U_GEFCNHOTM('214',.F.)" ,0,3,0,.f. } )
Aadd(_aCNHOTMRot,	{ 'Interf. Faturamento(210)', "U_GEFCNHOTM('210',.F.)" ,0,3,0,.f. } )
Aadd(_aCNHOTMRot,	{ 'Imprimir Log'				, "U_GEFCNHR2()			" ,0 ,3,0,.f. } )	

Return(aRotina)
