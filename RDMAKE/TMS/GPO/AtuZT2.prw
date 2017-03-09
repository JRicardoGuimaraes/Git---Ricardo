#Include 'Protheus.ch'

User Function AtuZT2				// u_AtuZT2()
	Local aArea	:= GetArea()
	Local aArray	:= {}

	DbSelectArea("ZT2")

	While ZT2->( !Eof() )

		aadd( aArray , ZT2->ZT2_CEPD )
		aadd( aArray , ZT2->ZT2_CEPA )

		ZT2->( DbSkip() )

	End While

	For X := 1 To Len( aArray )

		Begin Sequence

			If DbSeek( xFilial("ZT2") + aArray[X] + aArray[X] )
				Break
			EndIf

			RecLock("ZT2",.T.)

				ZT2->ZT2_CEPD 	:= aArray[X]
				ZT2->ZT2_CEPA		:= aArray[X]
				ZT2->ZT2_BLOQUE	:= "N"

			ZT2->( MsUnlock() )

		End Sequence

	Next X

	RestArea( aArea )
Return

