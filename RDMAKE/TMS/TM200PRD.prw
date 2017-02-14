#Include 'Protheus.ch'

User Function TM200PRD
	Local _cProd		:= AllTrim(PARAMIXB[1])
	Local _cDocTMS	:= (PARAMIXB[2])
	Local _cCdrOri	:= (PARAMIXB[3])
	Local _cCdrDes	:= (PARAMIXB[4])
	Local _cCdrCal	:= (PARAMIXB[5])
	Local cNewPrd		:= ''
	Local _aDTC		:= PARAMIXB[6]

	//-- Customização do usuário para retornar o novo produto de imposto

	DTC->( DbGoto( _aDTC ) )

Return cNewPrd



