#INCLUDE "RWMAKE.CH"
#INCLUDE "Topconn.ch"

/****************************************************************************
* Programa......: M460MARK()                                                *
* Autor.........: J Ricardo de O Guimarães                                  *
* Data..........: 09/01/2009                                                *
* Descricao.....: PE para checar se a data de emissao da NF a ser emitida,  *
*                 é maior ou igual a data de emissão da última emitida      *
*                                                                           *
*****************************************************************************
* Modificado por:                                                           *
* Data..........:                                                           *
* Motivo........:                                                           *
*                                                                           *
****************************************************************************/
User Function M460MARK()
Local _lRet		:= .T.
Local _lRetCTB	:= .T.
Local _aArea	:= GetArea()
Local _TpSeqNum := GETMV("MV_TPNRNFS") // Tipo de Controle de Numeração de NF.
Local _cSerie 	:= "" // Série selecionada
Local _cQry     := ""

If _TpSeqNum == "2" // Controle pela SXE/SXF
	_cSerie 	:= AllTrim(Left(SXF->XF_FILIAL,3))
Else
	_cSerie 	:= AllTrim(SX5->X5_CHAVE)
EndIf

_cQry := " SELECT TOP 1 F2_DOC AS DOC, F2_SERIE AS SERIE, MAX(F2_EMISSAO) AS EMISSAO, D_E_L_E_T_ "
_cQry += " 	FROM  " + RetSqlName("SF2") + " SF2 " 
_cQry += " 	WHERE F2_FILIAL = '" + xFilial("SF2") + "' "
_cQry += " 	  AND F2_SERIE  = '" + _cSerie + "' "
_cQry += " 	GROUP BY F2_DOC, F2_SERIE, F2_EMISSAO, D_E_L_E_T_ "
_cQry += " 	ORDER BY EMISSAO DESC "

If Select("TNOTA") > 0 
	dbSelectArea("TNOTA") ; dbCloseArea()	
EndIf

TCQUERY _cQry ALIAS "TNOTA" NEW

dbSelectArea("TNOTA") ; dbGoTop()

If !TNOTA->(Eof())
	If dDataBase < STOD(TNOTA->EMISSAO)
	   _lRet :=	.F.
		Aviso("Atenção","Última NF " + TNOTA->DOC + "-" + TNOTA->SERIE + " emitida em " + DTOC(STOD(TNOTA->EMISSAO)) +;
		      ".  Não é possível emitir NF com data de emissão anterior a última NF emitida." ,{"Ok"})
	EndIf
EndIf

If Select("TNOTA") > 0 
	dbSelectArea("TNOTA") ; dbCloseArea()	
EndIf

*-------------------------------------------------*
* Verifico Calendário Contábil                    *
*-------------------------------------------------*
If !U_GEFMCTB()
	_lRetCTB := .F.
EndIf	

If _lRet .AND. _lRetCTB
	_lRet := .T.
Else
	_lRet := .F.
EndIf	

RestArea(_aArea)
Return _lRet
