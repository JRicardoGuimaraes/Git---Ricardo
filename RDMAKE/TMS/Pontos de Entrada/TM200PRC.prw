#Include 'Protheus.ch'

/*
Programa	: TM2000PRC
Funcao		: xBuildDTCOBS
Data		: 04/01/2016
Autor		: André Costa
Descricao	: Função para a construção dos dados para complementar o OBSERVAÇÂO do campo MEMO VIRTUAL DTC_CODOBS
*/


Static Function xBuildDTCOBS( xFilOri , xLote )
	Private  cAlias	:= GetNextAlias()

   If Select( cAlias ) # 0
		(cAlias)->( DbCloseArea() )
	EndIf

	BeginSql Alias cAlias

		Select	DTC_FILORI	,
				DTC_LOTNFC,
				DTC_CODOBS,
				R_E_C_N_O_

			From %Table:DTC% DTC

			Where	(		DTC.%NotDel%
						And	DTC.DTC_FILORI	=	%Exp:xFilOri%
						And	DTC.DTC_LOTNFC	>=	%Exp:xLote%
						And	DTC_CODOBS			<> ''
					)

	EndSql

	( cAlias )->( DbGoTop() )

Return
