#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT1620CR  ºAutor  ³Microsiga           º Data ³  18/08/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para definir as contas contabeis para a geracao de  º±±
±±º          ³ CTRC/NF.                                                   º±±
±±º          ³ Conta Contabil   (CT1)                                     º±±
±±º          ³ Centro de Custos (CTT)                                     º±±
±±º          ³ Item Contabil    (CTD)                                     º±±
±±º          ³ Classe de Valor  (CTH)                                     º±±
±±º          ³ Parametro : _cSequen                                       º±±
±±º          ³ Sequencia do lancamento padrao para tratar as contas       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//
User Function CT1620CR()

// Define retorno padrao para a funcao
//Local _cRet     := "Cta. Invalid."
Local _cRet     := ""
Local _aAreaDT6 := DT6->(GetArea())
Local _aAreaSED := SED->(GetArea())
Local _aAreaDC5 := DC5->(GetArea())

// Desativa a execucao do bloco atraves do cadastro de lancamentos padrao
If "CTBA080" $ Upper(FunName())
	Return _cRet
EndIf

// Verifica se e CTRC ou NF

If AllTrim(SF2->F2_ESPECIE) $ "CTR|CTE" .AND. cModulo == "TMS"
	
	// Localiza a natureza e retorna a conta contabil
	SED->(dbSetOrder(1))
	If SED->(dbSeek(xFilial("SED")+DC5->DC5_NATURE))
		_cRet := SED->ED_CONTA
	EndIf
	// Nota Fiscal de Servico de Transporte
//ElseIf SF2->F2_ESPECIE == PadR("NFST",Len(SF2->F2_ESPECIE))
Else
    // Localiza a natureza do pedido e retorna a conta contabil
	If SED->(dbSeek(xFilial("SED")+SC5->C5_NATUREZ))
		_cRet := SED->ED_CONTA
	EndIf	
EndIf

// Restaura areas das tabelas
RestArea(_aAreaDT6)
RestArea(_aAreaDC5)
RestArea(_aAreaSED)

// Retorna o conteudo
Return _cRet

*------------------------------*
User Function CTT620CC()
*------------------------------*
// Retorno CC para o LP 620

// Define retorno padrao para a funcao
// Local _cRet     := "Cta. Invalid."
Local _cRet     := ""
Local _aAreaDT6 := DT6->(GetArea())
Local _aAreaSC5 := SC5->(GetArea())

// Desativa a execucao do bloco atraves do cadastro de lancamentos padrao
If "CTBA080" $ Upper(FunName())
	Return _cRet
EndIf

// Verifica se e CTRC ou NF
// Contabilização On Line pelo módulo do TMS
If AllTrim(SF2->F2_ESPECIE) $ "CTR|CTE" .AND. cModulo == "TMS"

	// Localiza o CC
	_cRet := DT6->DT6_CCUSTO

//ElseIf SF2->F2_ESPECIE == PadR("CTR",Len(SF2->F2_ESPECIE)) .AND. cModulo == "FAT"
ElseIf AllTrim(SF2->F2_ESPECIE) $ "CTR|CTE" .AND. (cModulo == "FAT" .OR. "CTBANFS" $ Upper(FunName()))

// Contabilização On Line pelo módulo do TMS

	DT6->(dbSetOrder(1))
	If DT6->(dbSeek(xFilial("DT6") + SF2->F2_FILIAL + SF2->F2_DOC + AllTrim(SF2->F2_SERIE)))
		_cRet := DT6->DT6_CCUSTO
	EndIf
Else
    // Localiza o CC
    dbSelectArea("SD2") ; dbSetOrder(3)
    If dbSeek(xFilial("SD2")+SF2->F2_DOC + SF2->F2_SERIE)
		SC5->(dbSetOrder(1))    
		If SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
			_cRet := SC5->C5_CCUSTO
		EndIf
	EndIf
EndIf

// Restaura areas das tabelas
RestArea(_aAreaDT6)
RestArea(_aAreaSC5)

// Retorna o conteudo
Return _cRet


*------------------------------*
User Function CT1620DEB()
*------------------------------*
// Retorno Conta Deb para o LP 620

// Define retorno padrao para a funcao
Local _cRet     := ""
//Local _cRet     := "Cta. Invalid."
Local _aAreaDT6 := DT6->(GetArea())
Local _aAreaSC5 := SC5->(GetArea())

// Desativa a execucao do bloco atraves do cadastro de lancamentos padrao
If "CTBA080" $ Upper(FunName())
	Return _cRet
EndIf

// Verifica se e CTRC ou NF
// Contabilização On Line pelo módulo do TMS
If AllTrim(SF2->F2_ESPECIE) $ "CTR|CTE" .AND. cModulo == "TMS"

	// Localiza o CC
	//_cRet := DC5->DC5_NATURE
	SED->(dbSetOrder(1))
	If SED->(dbSeek(xFilial("DC5")+DC5->DC5_NATURE))
		_cRet := SED->ED_CONTA
	EndIf		
Else
    // Localiza o CC
    dbSelectArea("SD2") ; dbSetOrder(3)
    If dbSeek(xFilial("SD2")+SF2->F2_DOC + SF2->F2_SERIE)
		SC5->(dbSetOrder(1))    
		If SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
			SED->(dbSetOrder(1))
			If SED->(dbSeek(xFilial("SED")+SC5->C5_NATUREZ))
				_cRet := SED->ED_CONTA
			EndIf	
		EndIf
	EndIf
EndIf

// Restaura areas das tabelas
RestArea(_aAreaDT6)
RestArea(_aAreaSC5)

// Retorna o conteudo
Return _cRet

