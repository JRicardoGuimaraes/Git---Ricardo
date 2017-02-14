#Include 'Protheus.ch'


/*
Programa	: TM200DEL
Funcao		: User Function M200DEL - Estorno de C�lculo de Frete
Data		: 04/01/2016
Autor		: Andr� Costa
Descricao	: PE localizado no TMSA200.PRW(C�lculo do Frete), � executado durante o Estorno de um c�lculo de frete.
				Vale lembrar que  o PE n�o impede o estorno do c�lculo, somente efetua procedimentos como mensagens e outras valida��es.
Chamada	: TMSA200
*/

User Function TM200DEL

	Local aArea		:= GetArea()
	Local xFilOri		:= DT6->(DT6_FILDOC)
	Local xLote		:= DT6->(DT6_LOTNFC)

	Private  cAlias	:= GetNextAlias()

	Begin Sequence

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
						)

		EndSql

		( cAlias )->( DbGoTop() )

		If ( cAlias )->(Eof())
			Break
		EndIf

		Msmm( ( cAlias )->(DTC_CODOBS),TamSX3("YP_TEXTO")[1],/*[nLin]*/,/*cString*/,2,/*[nTamSize]*/,/*[lWrap]*/,'DTC','DTC_CODOBS',/*[cRealAlias]*/,/*[lSoInclui]*/ )

		While (cAlias)->( ! Eof() )

			DTC->( DbGoTo( (cAlias)->(R_E_C_N_O_) ) )

			RecLock('DTC',.f.)
				DTC->DTC_CODOBS	:= ''
			DTC->( MsUnLock() )

			(cAlias)->(dbSkip())

		End While

	End Sequence

	If Select( cAlias ) # 0
		(cAlias)->( DbCloseArea() )
	EndIf

	RestArea( aArea )

Return
