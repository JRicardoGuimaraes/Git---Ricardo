#Include 'Protheus.ch'

User Function TM050COP()
	Local aArea := GetArea()

	M->DTC_CCONT 	:= CRIAVAR("DTC_CCONT"	,.F.) // CC PSA
	M->DTC_OI 		:= CRIAVAR("DTC_OI"		,.F.) // OI PSA
	M->DTC_CONTA	:= CRIAVAR("DTC_CONTA"	,.F.) // CONTA PSA		
	
	RestArea( aArea )
Return

