#Include "Protheus.CH"

/*
Programa    : GEFCNHAST
Funcao      : GEFCNHAST
Data        : 22/06/2015
Autor       : André Costa
Descricao   : Ponto de entrada disparado antes da abertura do Browse, caso Browse inicial da rotina esteja habilitado, ou antes da apresentação do Menu de opções, 
				caso Browse inicial esteja desabilitado.  
				Para habilitar ou desabilitar o Browse, entre na rotina, clique em Configurações/Browse Inicial e selecione	a opção desejada:
					Sim - Habilitar Browse Inicial
					Não - Desabilitar Browse Inicial
Uso         : Este ponto de entrada pode ser utilizado para inserir novas opções no array aRotina.
Chamada		: MATA410
Onde:	Parametros do array aRotina:
			1. Nome a aparecer no cabecalho
			2. Nome da Rotina associada    
			3. Reservado                        
			4. Tipo de Transação a ser efetuada:     
				1 - Pesquisa e Posiciona em um Banco de Dados      
				2 - Simplesmente Mostra os Campos                  
				3 - Inclui registros no Bancos de Dados            
				4 - Altera o registro corrente                     
				5 - Remove o registro corrente do Banco de Dados 
			5. Nivel de acesso                                   
			6. Habilita Menu Funcional
*/

User Function MA410MNU

	aadd( aRotina , {'Integra CCO','ExecBlock( "GEFCCOINT",.F.,.F. )', 0 , 3 , 0 , NIL } )

Return
