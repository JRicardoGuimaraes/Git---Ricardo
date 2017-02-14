#INCLUDE "rwmake.ch"
/*
*---------------------------------------------------------------------------*
* Função     |TM200EXC   | Autor | J Ricardo             | Data | 10.02.12  *
*---------------------------------------------------------------------------*
* Descrição  |Ponto de Entreda disparado após o Cancelamento de um CTRC.    *
*            |PE desenvolvido para duplicar o registro na tabela SZ8, infor-*
*            |mando no campo Z8_Status="00", para CTRC do TLA               *
*            |                                                              *
*---------------------------------------------------------------------------*
*/            
*--------------------------*
User Function TM200EXC()    
*--------------------------*
Local aArea     := GetArea()
Local cQuery    := ""
Local aStruSZ8  := SZ8->(dbStruct())
Local cAliasSZ8 := GetNextAlias()
Local _cTransp  := ""

Private lMsErroAuto := .F.

// If SubStr(DT6->DT6_CCUSTO,1,3) <> "101"  // TLA
If !(SubStr(DT6->DT6_CCUSTO,1,3) $ "101|102")  // TLA
	Return
EndIf     

cQuery := "SELECT * "
cQuery += "  FROM "+RetSqlName("SZ8")
cQuery += " WHERE Z8_FILIAL  = '" + DT6->DT6_FILDOC + "' "
cQuery += "   AND Z8_LOTNFC  = '" + DT6->DT6_LOTNFC + "' "
cQuery += "   AND Z8_NUMCTRC = '" + DT6->DT6_DOC    + "' "
cQuery += "   AND Z8_SERCTRC = '" + DT6->DT6_SERIE  + "' "
cQuery += "   AND Z8_STATUS <> '00' "
cQuery += "   AND D_E_L_E_T_ = ' '"
cQuery += " ORDER BY "+SqlOrder(SZ8->(IndexKey()))
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSZ8)
For nX := 1 To Len(aStruSZ8)
	If aStruSZ8[nX][2] <> "C"
		TcSetField(cAliasSZ8,aStruSZ8[nX][1],aStruSZ8[nX][2],aStruSZ8[nX][3],aStruSZ8[nX][4])
	EndIf
Next nX

dbSelectArea(cAliasSZ8) ; dbGoTop()

Begin Transaction 
		// Duplica registro da tabela SZ8 - Cancela SZ8
	If !((cAliasSZ8)->(Eof()))	// Se existir o registro na SZ8 0 CTRC é Automático caso contrário é um CTRC Manual
	// ALERT("PASSO 1 - SZ8")	
		dbSelectArea("SZ8")
		SZ8->(RecLock("SZ8",.T.))
			SZ8->Z8_FILIAL  := (cAliasSZ8)->Z8_FILIAL
			SZ8->Z8_DTCRIA  := dDataBase // (cAliasSZ8)->Z8_DTCRIA
			SZ8->Z8_NUMCTRC := (cAliasSZ8)->Z8_NUMCTRC
			SZ8->Z8_SERCTRC := (cAliasSZ8)->Z8_SERCTRC	
			SZ8->Z8_DTEMIS  := (cAliasSZ8)->Z8_DTEMIS
			SZ8->Z8_STATUS  := "00" // Cancelado
			SZ8->Z8_COMPRA  := (cAliasSZ8)->Z8_COMPRA
			SZ8->Z8_VENDA   := (cAliasSZ8)->Z8_VENDA
			SZ8->Z8_NCOLETA := (cAliasSZ8)->Z8_NCOLETA
			SZ8->Z8_CNPJORI := (cAliasSZ8)->Z8_CNPJORI
			SZ8->Z8_CODORI  := (cAliasSZ8)->Z8_CODORI
			SZ8->Z8_CNPJDES := (cAliasSZ8)->Z8_CNPJDES
			SZ8->Z8_CODDES  := (cAliasSZ8)->Z8_CODDES
			SZ8->Z8_CNPJCON := (cAliasSZ8)->Z8_CNPJCON
			SZ8->Z8_CODCON  := (cAliasSZ8)->Z8_CODCON
			SZ8->Z8_CNPJTRA := (cAliasSZ8)->Z8_CNPJTRA
			SZ8->Z8_NFCLI   := (cAliasSZ8)->Z8_NFCLI
			SZ8->Z8_SERIENF := (cAliasSZ8)->Z8_SERIENF
			SZ8->Z8_DATANF  := (cAliasSZ8)->Z8_DATANF
			SZ8->Z8_VALORNF := (cAliasSZ8)->Z8_VALORNF
			SZ8->Z8_SERSIPC := (cAliasSZ8)->Z8_SERSIPC
			SZ8->Z8_PATIO   := (cAliasSZ8)->Z8_PATIO
			SZ8->Z8_VIN     := (cAliasSZ8)->Z8_VIN
			SZ8->Z8_MARCA   := (cAliasSZ8)->Z8_MARCA
			SZ8->Z8_CODMAR  := (cAliasSZ8)->Z8_CODMAR
			SZ8->Z8_FAMILIA := (cAliasSZ8)->Z8_FAMILIA
			SZ8->Z8_ORIGEM  := (cAliasSZ8)->Z8_ORIGEM
			SZ8->Z8_MERCADO := (cAliasSZ8)->Z8_MERCADO
			SZ8->Z8_DESTINO := (cAliasSZ8)->Z8_DESTINO
			SZ8->Z8_CODMOD  := (cAliasSZ8)->Z8_CODMOD
			SZ8->Z8_DESCMOD := (cAliasSZ8)->Z8_DESCMOD
			SZ8->Z8_CODCOR  := (cAliasSZ8)->Z8_CODCOR
			SZ8->Z8_DESCCOR := (cAliasSZ8)->Z8_DESCCOR
			SZ8->Z8_ANOFAB  := (cAliasSZ8)->Z8_ANOFAB
			SZ8->Z8_ANOMOD  := (cAliasSZ8)->Z8_ANOMOD
			SZ8->Z8_PESOVEI := (cAliasSZ8)->Z8_PESOVEI
			SZ8->Z8_CCGEFCO := (cAliasSZ8)->Z8_CCGEFCO
			SZ8->Z8_CCPSA   := (cAliasSZ8)->Z8_CCPSA
			SZ8->Z8_OIPSA   := (cAliasSZ8)->Z8_OIPSA
			SZ8->Z8_CTAPSA  := (cAliasSZ8)->Z8_CTAPSA
			SZ8->Z8_RNTC    := (cAliasSZ8)->Z8_RNTC
			SZ8->Z8_SEGURAD := (cAliasSZ8)->Z8_SEGURAD
			SZ8->Z8_AVERB   := (cAliasSZ8)->Z8_AVERB
			SZ8->Z8_RESPSEG := (cAliasSZ8)->Z8_RESPSEG
			SZ8->Z8_APOLICE := (cAliasSZ8)->Z8_APOLICE
			SZ8->Z8_ISIPCO  := "0" // (cAliasSZ8)->Z8_ISIPCO
			SZ8->Z8_DTSIPCO := CTOD("  /  /  ") // (cAliasSZ8)->Z8_DTSIPCO - Em: 10/10/12 - Por:ricardo
			SZ8->Z8_LOTNFC  := (cAliasSZ8)->Z8_LOTNFC
		MSUnLock()
		
		// Excluir Compra de Frete TLA 
		dbSelectArea("SA2") ; dbSetOrder(3)
		dbSeek(xFilial("SA2")+(cAliasSZ8)->Z8_CNPJTRA)
		_cTransp  := SA2->A2_COD + SA2->A2_LOJA
	Else // CTRC Manual
		// ALERT("PASSO 2 - "+DTC->DTC_DOC+" TRANSP "+DTC->DTC_TRANSP)	
		dbSelectArea("SA2") ; dbSetOrder(1)
		dbSeek(xFilial("SA2")+DTC->DTC_TRANSP + DTC->DTC_LJTRA)	
		_cTransp  := SA2->A2_COD + SA2->A2_LOJA
	EndIf	
		
	If POSICIONE("SD1",1,xFilial("SD1")+DT6->DT6_DOC + DT6->DT6_SERIE + _cTransp, "D1_XCOMTLA") == "S"
	//ALERT("PASSO 3 - SD1")
		aCabec := {}
		aItens := {}
		
		// Monto cabeçalho da NF
		aadd(aCabec,{"F1_FILIAL" ,xFilial("SF1")})
		aadd(aCabec,{"F1_DOC"    ,DT6->DT6_DOC})
		aadd(aCabec,{"F1_SERIE"  ,DT6->DT6_SERIE})
		aadd(aCabec,{"F1_FORNECE",SA2->A2_COD})
		aadd(aCabec,{"F1_LOJA"   ,SA2->A2_LOJA})
		aadd(aCabec,{"F1_TIPO"   ,"N"})
		aadd(aCabec,{"F1_FORMUL" ,"N"})
		aadd(aCabec,{"F1_EMISSAO",DT6->DT6_DATEMI})
		aadd(aCabec,{"F1_ESPECIE",SF2->F2_ESPECIE})
		aadd(aCabec,{"F1_COND"   ,GETMV("MV_XTLAPG")})
		aadd(aCabec,{"F1_PREFIXO",SF2->F2_PREFIXO})
		aadd(aCabec,{"E2_NATUREZ",GETMV("MV_XNATTLA")})
	
		aLinha := {}
		aadd(aLinha,{"D1_FILIAL" ,xFilial("SD1"),Nil})		
		aadd(aLinha,{"D1_DOC"	 ,DT6->DT6_DOC,Nil})
		aadd(aLinha,{"D1_SERIE"	 ,DT6->DT6_SERIE,Nil})
		aadd(aLinha,{"D1_FORNECE",SA2->A2_COD,Nil})
		aadd(aLinha,{"D1_LOJA"   ,SA2->A2_LOJA,Nil})
		aadd(aItens,aLinha)
	                                            	
		******************************************************************
		// Teste de Ixclusão  \\
		******************************************************************
	    Pergunte("MTA103",.F.)
		mv_par01:=2 // Mostra lançamento contábil = Não
		mv_par06:=2 // Contabilização on line = Não
		
	    MSExecAuto({|x,y,Z| mata103(x,y,Z)}, aCabec, aItens, 5 )
	
		If !lMsErroAuto
			// MsgInfo(OemToAnsi("Compra de Frete TLA Excluído com sucesso! CTRC:")+aCabec[2,2],"Informação")
		Else
			MostraErro()
		EndIf
	EndIf
	
End Transaction
SZ8->(dbCloseArea()) 

RestArea(aArea)
Return
/*
*------------------------*
User Function ExEntrada()
Private lMsErroAuto := .F.

	aCabec := {}
	aItens := {}

	_CARQXMLSRV := ""
	
	dbSelectArea("SF1") ; dbSetOrder(1)
	If dbSeek(xFilial("SF1")+"0009410602  UNIGI 00")
		Alert("achou")
	Else
		Alert("NÃO ACHOU")	
	EndIf	
	// Monto cabeçalho da NF
	aadd(aCabec,{"F1_FILIAL" ,"03"})
	aadd(aCabec,{"F1_TIPO"   ,"N"})
	aadd(aCabec,{"F1_FORMUL" ,"N"})
	aadd(aCabec,{"F1_DOC"    ,"000941060"})
	aadd(aCabec,{"F1_SERIE"  ,"2  "})
	aadd(aCabec,{"F1_EMISSAO",CTOD("16/10/12")})
	aadd(aCabec,{"F1_FORNECE","UNIGI "})
	aadd(aCabec,{"F1_LOJA"   ,"00"})	
	aadd(aCabec,{"F1_ESPECIE","CTR"})
	aadd(aCabec,{"F1_EST","SP"})	
	aadd(aCabec,{"F1_COND"   ,GETMV("MV_XTLAPG")})
	aadd(aCabec,{"F1_PREFIXO",SF2->F2_PREFIXO})
	aadd(aCabec,{"E2_NATUREZ",GETMV("MV_XNATTLA")})

	aLinha := {}
	aadd(aLinha,{"D1_FILIAL" ,"03",Nil})		
	aadd(aLinha,{"D1_DOC"	 ,"000941060",Nil})
	aadd(aLinha,{"D1_SERIE"	 ,"2  ",Nil})
	aadd(aLinha,{"D1_FORNECE","UNIGI ",Nil})
	aadd(aLinha,{"D1_LOJA"   ,"00",Nil})
	aadd(aLinha,{"D1_COD"  ,GETMV("MV_XTLAPRD"),Nil})		
	aadd(aLinha,{"D1_QUANT",1,Nil})
	aadd(aLinha,{"D1_VUNIT",100,Nil})
	// aadd(aLinha,{"D1_TOTAL",_nFrete,Nil})
	aadd(aLinha,{"D1_CC"   ,'1010040012',Nil})
	aadd(aLinha,{"D1_TES"  ,AllTrim(GETMV("MV_XTESTLA")),Nil})
	aadd(aLinha,{"D1_XCOMTLA","S",Nil})	
	aadd(aItens,aLinha)
                                            	
	******************************************************************
	// Teste de Ixclusão  \\
	******************************************************************
//    Pergunte("MTA103",.F.)
//	mv_par01:=2 // Mostra lançamento contábil = Não
//	mv_par06:=2 // Contabilização on line = Não
	
    MSExecAuto({|x,y,z| mata103(x,y,z)}, aCabec, aItens, 5 )
//    MSExecAuto({|x,y| mata103(x,y)},aCabec,aItens, 3 )

	If !lMsErroAuto
		MsgInfo(OemToAnsi("Compra de Frete TLA Excluído com sucesso! CTRC:")+aCabec[4,2],"Informação")
	Else
		MostraErro()
	EndIf
RETURN	
*/