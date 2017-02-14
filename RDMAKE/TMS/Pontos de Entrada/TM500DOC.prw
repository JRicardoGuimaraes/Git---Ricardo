#Include 'Protheus.ch'
/*
@ Nome: J Ricardo Guimarães
@ Data: 26/05/2015
@ Descrição: PE executado na rotina TMSA500 após geração da CT-e de Complemento e Devolução
@            Usado para carregar campos customizados na tabela do financeiro
*/

User Function TM500DOC()
	Local cFilDoc   := PARAMIXB[1]
	Local cDocto 	  := PARAMIXB[2]
	Local cSerie 	  := PARAMIXB[3]
	Local _aArea	  := GetArea()
	Local _aAreaSE1 := SE1->(GetArea())
	Local _aAreaDTC := DTC->(GetArea())
	Local _cPrefixo := ""
	Local _cTipoCar := ""
	Local _cNumCVA  := ""
	Local _cColMon  := ""
	Local _cTMSMFAT := GetMV("MV_TMSMFAT")
	Local cDocOri   := DT6->DT6_DOCDCO
	Local cSerOri   := DT6->DT6_SERDCO
	Local aDT6NUMAGD

	Private cCcont	:= PadR(GetMV("MV_GEF006"),TamSX3("DTC_CCONT")[1])
	Private cRefGef	:= Space(TamSX3("DTC_REFGEF")[1])
	Private cConta	:= If(Empty(GetMV("MV_GEF008")),Space(TamSX3("DTC_CONTA")[1]),PadR(GetMV("MV_GEF008"),TamSX3("DTC_CONTA")[1]))
	Private cOi		:= If(Empty(GetMV("MV_GEF007")),Space(TamSX3("DTC_OI")[1]),PadR(GetMV("MV_GEF007"),TamSX3("DTC_OI")[1]))
	Private cCcusto	:= If(Empty(GetMV("MV_GEF005")),Space(TamSX3("DTC_CCUSTO")[1]),PadR(GetMV("MV_GEF005"),TamSX3("DTC_CCUSTO")[1]))
	Private cTipDes	:= "O"
	Private cNotas 	:= ""

// Grava informações de Agendamento para a CNH do Documento de Original

	aDT6NUMAGD	:= GetAdvFVal("DT6",{"DT6_NUMAGD","DT6_ITEAGD"},xFilial("DT6")+DT6->(DT6_FILORI+cDocOri+cSerOri),1,{} )

	If Len( aDT6NUMAGD ) # 0

		DT6->( RecLock("DT6",.F.) )
			DT6->DT6_NUMAGD	:= aDT6NUMAGD[1]
			DT6->DT6_ITEAGD	:= aDT6NUMAGD[2]
		DT6->( MsUnlock() )

	EndIf

// Fim

	cChave := xFilial("DTC") + cFilDoc + cDocOri + cSerOri

	DbSelectArea( "DTC" )
	DTC->( DbSetOrder(3) )

	If DTC->( MSseek(cChave) )

		// Objetivo: Pegar Informacoes MAN

		_cTipoCar 	:= DTC->DTC_TPCAR
		_cNumCVA  	:= DTC->DTC_NUMCVA
		_cColMon  	:= DTC->DTC_COLMON
		cCcont 	:= DTC->DTC_CCONT
		cConta 	:= DTC->DTC_CONTA
		cOi 		:= DTC->DTC_OI
		cTipDes	:= DTC->DTC_TIPDES
		cRefGef	:= DTC->DTC_REFGEF
		cCcusto	:= DTC->DTC_CCUSTO

		RecLock("DT6",.F.)
			DT6->DT6_CCONT 	:= cCcont
			DT6->DT6_CONTA 	:= cConta
			DT6->DT6_OI		:= cOi
			DT6->DT6_TIPDES 	:= cTipDes
			DT6->DT6_REFGEF 	:= cRefGef
			DT6->DT6_CCUSTO 	:= cCcusto
		MsUnLock()

	EndIf

	If AllTrim( _cTMSMFAT ) == "1"

		SE1->( DbSetOrder(2) )

		If SE1->(MsSeek(xFilial("SE1")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV+SF2->F2_PREFIXO+DT6->DT6_DOC))

			// Por: Ricardo
			// Objetivo: Como o parametro MV_1DUPREF não atende adequadamente a regra para pegar o CC, no momento do cálculo,
			//           quando a filial operam em diversos modais ( FVL / OVL / OVS ), então tive que fazer este artifício

			_cPrefixo := SF2->F2_PREFIXO

			If cFilAnt $ Formula("MOD")
				_cPrefixo := &( GetMV("MV_1DUPREF") )
			EndIf

			RecLock("SE1",.F.)
				SE1->E1_CCONT		:= AllTrim(DT6->DT6_CCUSTO)
				SE1->E1_CCPSA		:= AllTrim(DT6->DT6_CCONT)
				SE1->E1_OIPSA		:= AllTrim(DT6->DT6_OI)
				SE1->E1_CTAPSA	:= AllTrim(DT6->DT6_CONTA)
				SE1->E1_TPDESP	:= AllTrim(DT6->DT6_TIPDES)
				SE1->E1_REFGEF	:= AllTrim(DT6->DT6_REFGEF)
				SE1->E1_TRANSP	:= POSICIONE("SA2",1,xFilial("SA2")+DTC->DTC_TRANSP+DTC->DTC_LJTRA,"A2_CGC")
				SE1->E1_PREFIXO	:= _cPrefixo

				// Objetivo: Informacoes MAN
				SE1->E1_TPCAR		:= _cTipoCar
				SE1->E1_NUMCVA	:= _cNumCVA
				SE1->E1_COLMON	:= _cColMon

			SE1->( MsUnlock() )

			DT6->( RecLock("DT6",.F.) )
				DT6->DT6_PREFIX	:= _cPrefixo
				DT6->DT6_TIPO		:= SE1->E1_TIPO
			DT6->( MsUnlock() )

			SF2->(RecLock("SF2"))
				SF2->F2_PREFIXO	:= _cPrefixo
			SF2->( MsUnLock() )

		EndIf

	EndIf

	SE1->( RestArea( _aAreaSE1 ) )

	RestArea( _aArea )

	DTC->( RestArea( _aAreaDTC ) )

Return( Nil )
