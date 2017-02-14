#Include 'Protheus.ch'


/*
Programa	: TM200DEL
Funcao		: User Function TM200REM - Exclus�o do Documento de Transporte
Data		: 04/01/2016
Autor		: Andr� Costa
Descricao	: PE executado no Estorno do C�lculo do Frete, antes de excluir o registro DT6 - Documento de Transporte.
				* Vale lembrar que o PE n�o impede o estorno do c�lculo, somente efetua procedimentos como mensagens e outras valida��es.
Chamada	: TMSA200
*/

User Function TM200DEL

	Local aArea := GetArea()
	Local cChave

	Begin Sequence

		cChave := xFilial("DTC")+DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE)

		DbSelectArea("DTC")
		DTC->( DbSetOrder(3) )

		If !( DbSeek( cChave ) )
			Break
		EndIf

		Msmm(DTC->DTC_CODOBS,TamSX3("YP_TEXTO")[1],/*[nLin]*/,AllTrim( xNoteMessages ),2,/*[nTamSize]*/,/*[lWrap]*/,'DTC','DTC_CODOBS',/*[cRealAlias]*/,/*[lSoInclui]*/ )

		While	xFilial("DTC")+DTC->(DTC_FILDOC+DTC_DOC+DTC_SERIE) == cChave .And. ;
				DTC->( !Eof() )

			RecLock("DTC",.F.)
				DTC->DTC_CODOBS	:= ''
			MsUnlock()

			DTC->(dbSkip())

		End While

	End Sequence

	RestArea( aArea )

Return
