User Function TM200SE1()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TM200SE1  ºAutor  ³Francisco Rosemberg º Data ³  15/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para gravacao dos campos centro de custo   º±±
±±º          ³e ordem interna do SE1.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gefco                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Local _cTMSMFAT	:= GETMV("MV_TMSMFAT")
Local cCliDev   := PARAMIXB[1]
Local cLojDev   := PARAMIXB[2]
Local cPrefixo  := PARAMIXB[3]
Local cDocto    := PARAMIXB[4]
Local cFilDeb   := SE1->E1_FILDEB
Local _aAreaSE1 := SE1->(GetArea())

If AllTrim(_cTMSMFAT) == "1"
	SE1->(DbSetOrder(2))
	If SE1->(MsSeek(xFilial("SE1")+cCliDev+cLojDev+cPrefixo+cDocto))
		SE1->E1_CCONT := AllTrim(DT6->DT6_CCUSTO)
		SE1->E1_CCPSA := AllTrim(DT6->DT6_CCONT)
		SE1->E1_OIPSA := AllTrim(DT6->DT6_OI)
		SE1->E1_CTAPSA := AllTrim(DT6->DT6_CONTA)
		SE1->E1_TPDESP := AllTrim(DT6->DT6_TIPDES)
		SE1->E1_REFGEF := AllTrim(DT6->DT6_REFGEF)
	EndIF
EndIf
RestArea(_aAreaSE1)

Return Nil

