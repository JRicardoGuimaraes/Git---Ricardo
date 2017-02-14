#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRGEFE03   บAutor  ณ Vinํcius Moreira   บ Data ณ 18/05/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera็ใo de EDI com quebra por centro de custo especifico   บฑฑ
ฑฑบ          ณ VALEO.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RGEFE03 ()

Local cPerg   := "RGEFE03"
Local cCodCli := ""//GetMv("ES_RGEFE031",,"026944")
Local cLojCli := ""//GetMv("ES_RGEFE032",,"00")
Local cLayCli := GetMv("ES_RGEFE033",,"CECEVL")

PutSx1(cPerg,"01", "Data de?"  , "Data de?"  , "Data de?"  ,"mv_ch1" ,"D",TamSx3("DT6_DATEMI")[1],00,00,"G","",""   ,"","","mv_par01")
PutSx1(cPerg,"02", "Data ate?" , "Data ate?" , "Data ate?" ,"mv_ch2" ,"D",TamSx3("DT6_DATEMI")[1],00,00,"G","",""   ,"","","mv_par02")
PutSx1(cPerg,"03", "Cliente?"  , "Cliente?"  , "Cliente?"  ,"mv_ch3" ,"C",TamSx3("DT6_CLIREM")[1],00,00,"G","","SA1","","","mv_par03")
PutSx1(cPerg,"04", "Loja?"     , "Loja?"     , "Loja?"     ,"mv_ch4" ,"C",TamSx3("DT6_LOJREM")[1],00,00,"G","",""   ,"","","mv_par04")
// Por: Ricardo - Em: 28/05/2015 - Controlar o envio do EDI
PutSx1(cPerg,"05", "Retrasmissao ?",""       , ""          ,"mv_ch5" ,"N",1                      ,00,00,"C","",""	,"","","mv_par05","Sim","","","","Nao","" ,"" ,"","" ,"" ,"","" ,"" ,"" )

If Pergunte(cPerg, .T.)
	cCodCli := MV_PAR03
	cLojCli := MV_PAR04
	
	dbSelectArea("DEC")//Cliente x Layout
	DEC->(dbSetOrder(2))//DEC_FILIAL+DEC_CODCLI+DEC_LOJCLI+DEC_CODLAY
	If DEC->(dbSeek(xFilial("DEC")+cCodCli+cLojCli+cLayCli))
		fPreArq (cCodCli, cLojCli, MV_PAR01, MV_PAR02,MV_PAR05)
	Else
		Help (" ", 1, "RGEFE0301",,"Configura็ใo da tabela DEC - Cliente x Layout - nใo encontrada.", 3, 0)
	EndIf		
EndIf

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fPreArq  บAutor  ณ Vinํcius Moreira   บ Data ณ 18/05/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Prepara informa็๕es para montagem do arquivo.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fPreArq (cCodCli, cLojCli, dDatDe, dDatAte, nRetram)

Local nC         := 1
Local aCCustos   := {}
Local cQuery     := ""
Local cAliasQry  := GetNextAlias()
Local lTME05GRV  := ExistBlock("TME05GRV")
Local lTMSEDIDR  := ExistBlock("TMSEDIDR")
Local cDirPE     := ""
Local cEdiSeqAnt := ""
Local lRet       := .F.
Local cNomArq    := ""

Private lMsErroAuto  := .F.
Private cCadastro    := ""
Private cDirEnv      := GetMv("MV_EDIDIRE")
Private __cEDISeqArq := ""
Private __nEDISeqLin := 0
Private __nEDISeq    := 0
Private __aEDIEnv    := {}
Private cXCCusto     := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica/Inclui barra no final do diretorio.         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Right(cDirEnv,1) # "\"
	cDirEnv += "\"
Endif
             
MV_PAR01 := cCodCli
MV_PAR02 := cLojCli
MV_PAR03 := cCodCli
MV_PAR04 := cLojCli
MV_PAR05 := dDatDe
MV_PAR06 := dDatAte
MV_PAR07 := nRetram // 1

cQuery := "  SELECT " + CRLF 
cQuery += "     DTC.DTC_XCC XCCUSTO " + CRLF 
cQuery += "   FROM " + RetSqlName("DT6") + " DT6 " + CRLF 
cQuery += "   INNER JOIN " + RetSqlName("DTC") + " DTC ON " + CRLF 
cQuery += "        DTC.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += "    AND DTC.DTC_FILIAL = '" + xFilial("DTC") + "' " + CRLF 
cQuery += "    AND DTC.DTC_FILDOC = DT6.DT6_FILDOC " + CRLF 
cQuery += "    AND DTC.DTC_DOC    = DT6.DT6_DOC " + CRLF 
cQuery += "    AND DTC.DTC_SERIE  = DT6.DT6_SERIE " + CRLF 
cQuery += "    AND DTC.DTC_XCC    <> ' '  " + CRLF 
cQuery += "  WHERE DT6.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += "    AND DT6.DT6_FILIAL = '" + xFilial("DT6") + "' " + CRLF 
cQuery += "    AND DT6.DT6_CLIDEV BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR03 + "' " + CRLF 
cQuery += "    AND DT6.DT6_LOJDEV BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR04 + "' " + CRLF 
cQuery += "    AND DT6.DT6_DATEMI BETWEEN '" + dToS(MV_PAR05) + "' AND '" + dToS(MV_PAR06) + "' " + CRLF
// Por: Ricardo Guimarใes - Em: 28/05/2015
If MV_PAR07 = 1
	cQuery	+= "  AND DT6.DT6_DATEDI <> ' ' "
ElseIf MV_PAR07 = 2
	cQuery	+= "  AND DT6.DT6_DATEDI = ' ' "
EndIf
 
cQuery += "  GROUP BY " + CRLF 
cQuery += "     DTC.DTC_XCC " + CRLF 
cQuery := ChangeQuery (cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.F.,.T.)

If (cAliasQry)->(Eof())     
   Aviso("Inform็ใo","Nใo hแ dados para o filtro informado.",{"Ok"})
	(cAliasQry)->(dbCloseArea())
	Return
EndIf

While (cAliasQry)->(!Eof())
	aAdd(aCCustos, allTrim((cAliasQry)->XCCUSTO))
	(cAliasQry)->(dbSkip())
EndDo

(cAliasQry)->(dbCloseArea())

For nC := 1 to Len(aCCustos)
	cXCCusto := aCCustos[nC]
	If lTMSEDIDR
		cDirPE:= AllTrim(ExecBlock("TMSEDIDR",.F.,.F.,{DEC->DEC_CODCLI, DEC->DEC_LOJCLI, DEC->DEC_CODLAY}))
		If ValType(cDirPE) == "C" .And. !Empty(cDirPE) 
			cDirEnv:= cDirPE
		EndIf
	EndIf            
	//-- sequencia do arquivo
	If DEC->(FieldPos("DEC_SEQARQ")) > 0
		cEdiSeqAnt   := DEC->DEC_SEQARQ
		__cEDISeqArq := Soma1(DEC->DEC_SEQARQ)
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida se o nome do Arquivo eh valido.       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If TMSME05Mac(DEC->DEC_NOMARQ,@cNomArq)
		If lTME05GRV 
			ExecBlock("TME05GRV",.F.,.F.,{cNomArq})
		EndIf
		__nEDISeqLin := 1
		cNomArq      := Alltrim(cNomArq)
		
		Processa({|| lRet:= TMSME05Proc(DEC->DEC_CODLAY,cNomArq)})
		
		If lRet
			//-- Atualiza a Sequencia
			If DEC->(FieldPos("DEC_SEQARQ")) > 0
				RecLock("DEC",.F.)
				DEC->DEC_SEQARQ := __cEDISeqArq
				MsUnlock()
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Ponto de Entrada utilizado para atualizacao de dados apartir do DECณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If (ExistBlock("TMSME0501"))
				ExecBlock("TMSME0501",.F.,.F.)
			EndIf
		Else
			//-- Volta a Sequencia Anterior
			If DEC->(FieldPos("DEC_SEQARQ")) > 0
				RecLock("DEC",.F.)
				DEC->DEC_SEQARQ := cEDISeqAnt
				MsUnlock()
			EndIf			
		EndIf
		
	EndIf
Next nC

// Por: Ricardo Guimarใes - Em: 02/06/2015 
// Objetivo: A rotina nใo estava gravando o campo DT6_DATEDI, e era preciso para implementar a op็ใo de retransmissใo
If nC > 1 .AND. MV_PAR07 <> 1
	cQuery := "  SELECT " + CRLF 
	cQuery += "     DT6.R_E_C_N_O_ RECNO " + CRLF 
	cQuery += "   FROM " + RetSqlName("DT6") + " DT6 " + CRLF 
	cQuery += "  WHERE DT6.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += "    AND DT6.DT6_FILIAL = '" + xFilial("DT6") + "' " + CRLF 
	cQuery += "    AND DT6.DT6_CLIDEV BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR03 + "' " + CRLF 
	cQuery += "    AND DT6.DT6_LOJDEV BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR04 + "' " + CRLF 
	cQuery += "    AND DT6.DT6_DATEMI BETWEEN '" + dToS(MV_PAR05) + "' AND '" + dToS(MV_PAR06) + "' " + CRLF
	cQuery	+= "  AND DT6.DT6_DATEDI = ' ' "
	 
	cQuery := ChangeQuery (cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.F.,.T.)
	
	While (cAliasQry)->(!Eof())
		dbSelectArea("DT6")
		DT6->(dbGoTo((cAliasQry)->RECNO))
		DT6->(RecLock("DT6",.F.))
			DT6->DT6_DATEDI := Date()
		DT6->(MsUnLock())
		
		dbSelectArea(cAliasQry)
		(cAliasQry)->(dbSkip())
	End
	
	(cAliasQry)->(dbCloseArea())
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Apresenta o Log na Tela.                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lMSErroAuto
	MostraErro()
EndIf

Return 