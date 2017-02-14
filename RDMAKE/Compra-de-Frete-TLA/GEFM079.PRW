#INCLUDE "rwmake.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#INCLUDE "AVPRINT.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"

/*
*---------------------------------------------------------------------------*
* Função     |GEFM079   | Autor | J Ricardo             | Data | 09.10.12   *
*---------------------------------------------------------------------------*
* Descrição  |Rotina para grava o CTRC em compras baseado no CTRC emitido   *
*            |pelo TMS                                                      *
*            |Esta função será chamada após gravar o CTRC no TMS no PE      *
*            |TM200FIM()                                                    *
*---------------------------------------------------------------------------*
*/

********************************************************************************
USER Function GEFM079(lAutoR, _cCodTra, _cLojTra, _nVrCompra, _cCC, _dDtEmis)
********************************************************************************

Private lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.

Private lAutoRot
Private _aLogImp:= {}
Private cLinha  := ""
Private _cTransp := _cCodTra
Private _cLJTra  := _cLojTra
Private _nVlrCom := _nVrCompra
Private _cCCusto := _cCC
Private _dEmissao:= IIF(_dDtEmis = Nil, CTOD("  /  /  "), _dDtEmis)

lAutoRot:=iif(lAutoR = Nil,.F.,.T.)

ConOut("Inicio geração de CTRC do TLA em Compras  ")

if lAutoRot //Se a rotina for automática.
	// Importa os arquivos do WMS-AR para as tabelas SF1 / SD1
	ConOut("Inicio de Geração Compra de Frete TLA - Entrada")
/*	
	// Gera Documento de Entrada no Microsiga dos registros importados do WMS
	RPCSetType(3) // Nao consome o numero de licencas
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "COM" TABLES "SA1","SA2","SB1","SD1","SF1","CTT","CT2","CT1","CTK","SF4","SE2","SED","SE4"
	
	fGeraEntrada()
*/	
	ConOut("Final de Geração de CTRC de compra de frete TLA.")
	
//	RESET ENVIRONMENT

Else
/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da tela de processamento.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 200,001 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Processamento de Interface WMS - Entrada - PROTHEUS.")
	@ 002,010 TO 080,190
	@ 10,018 Say " Este programa ira ler as entradas do WMS - AR           "
	@ 18,018 Say " ADT e gerar documentos de entrada no módulo de Compras. "
	@ 60,098 BMPBUTTON TYPE 01 ACTION Processa({|| fGeraEntrada(), Close(oLeTxt) },"Processando....")
	@ 60,128 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
		
	Activate Dialog oLeTxt Centered
*/
	// Processa({|| fGeraEntrada(), Close(oLeTxt) },"Gerando Compra de Frete TLA - Processando....")
	Processa({|| fGeraEntrada() },"Gerando Compra de Frete TLA - Processando....")	
	
	Return

EndIf

Return

*---------------------------------*
Static Function fGeraEntrada()
*---------------------------------*
Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local cDoc   := ""
Local lOk    := .T.
Local _cQry  := ""
Local _aArea := GetArea()
Local _nFrete:= 0.00

Private _cArqXmlSrv := "" // Criada para não gerar erro no ponto de entrada SF1100I

If lAutoRot
	ConOut(OemToAnsi("Inicio da Importação: ")+Time())
EndIf

// Alterado em 05/02/2013 - Por: Ricardo Guimarães
// Pega a transportadora
//dbSelectArea("SZ8") ; dbSetOrder(1)
//SZ8->(dbSeek(xFilial("SF2")+SF2->F2_DOC+SF2->F2_SERIE))

//_cTransp := SZ8->Z8_CNPJTRA
// _nFrete  := SZ8->Z8_COMPRA
_nFrete  := _nVlrCom

//SA2->(dbSetOrder(3))
//If !SA2->(dbSeek(xFilial("SA2")+_cTransp))
SA2->(dbSetOrder(1))
If !SA2->(dbSeek(xFilial("SA2") + _cTransp + _cLJTra))
	MsgInfo("Trasnportadora não localizada.","Informação")
	Return
EndIf	

//While !TWMS->(Eof())

	aCabec := {}
	aItens := {}
	
	// Monto cabeçalho da NF
	aadd(aCabec,{"F1_TIPO"   ,"N"})
	aadd(aCabec,{"F1_FORMUL" ,"N"})
	aadd(aCabec,{"F1_FILIAL" ,xFilial("SF1")})
	aadd(aCabec,{"F1_DOC"    ,SF2->F2_DOC})
	aadd(aCabec,{"F1_DUPL"   ,SF2->F2_DOC})	
	aadd(aCabec,{"F1_SERIE"  ,SF2->F2_SERIE})
	aadd(aCabec,{"F1_EMISSAO",IIF(Empty(_dEmissao), SF2->F2_EMISSAO, _dEmissao)})
	aadd(aCabec,{"F1_FORNECE",SA2->A2_COD})
	aadd(aCabec,{"F1_LOJA"   ,SA2->A2_LOJA})
	aadd(aCabec,{"F1_ESPECIE",SF2->F2_ESPECIE})
	aadd(aCabec,{"F1_COND"   ,IIF(Empty(_dEmissao),GETMV("MV_XTLAPG"),"001")})
//	aadd(aCabec,{"F1_DTLANC" ,""})
	aadd(aCabec,{"F1_PREFIXO",SF2->F2_PREFIXO})
	aadd(aCabec,{"F1_DTDIGIT",DDATABASE})
//	aadd(aCabec,{"F1_STATUS",""})
	aadd(aCabec,{"E2_NATUREZ",GETMV("MV_XNATTLA")})

//	While !TWMS->(Eof()) .AND. _cNFAnt = TWMS->NUMERO_NF_ENTRADA

		aLinha := {}
		aadd(aLinha,{"D1_COD"  ,GETMV("MV_XTLAPRD"),Nil})		
		aadd(aLinha,{"D1_QUANT",1,Nil})
		aadd(aLinha,{"D1_VUNIT",_nFrete,Nil})
		// aadd(aLinha,{"D1_TOTAL",_nFrete,Nil})
		// aadd(aLinha,{"D1_CC"   ,SZ8->Z8_CCGEFCO,Nil})
		aadd(aLinha,{"D1_CC"   ,_cCCusto,Nil})		// Foi alterado quando o CTRC manual passou a gerar Compra de Frete - 22/02/2013
		aadd(aLinha,{"D1_TES"  ,AllTrim(GETMV("MV_XTESTLA")),Nil})
		aadd(aLinha,{"D1_XCOMTLA","S",Nil})
		aadd(aItens,aLinha)
                                            	
//		dbSelectArea("TWMS")
//		dbSkip()	
//	End

	// Altero o parâmetro de contabilização para contabilizar no processo Off-Line.
/*	
	SX1->(dbSetOrder(1))
	If SX1->(dbSeek(PadR("MTA103",Len(SX1->X1_GRUPO))+"06"))
		SX1->(RecLock("SX1",.F.))
		SX1->X1_
		SX1->(MsUnLock())
	EndIf
*/	
	******************************************************************
	// Teste de Inclusao \\
	******************************************************************
    MSExecAuto({|x,y,z| mata103(x,y,z)}, aCabec, aItens, 3 )
    //Pergunte("MTA103",.F.)
	//mv_par01:=2 // Mostra lançamento contábil = Não
	//mv_par06:=2 // Contabilização on line = Não

	If !lMsErroAuto
		If lAutoRot
			ConOut(OemToAnsi("Compra de Frete TLA Incluido com sucesso! CTRC: ")+aCabec[4,2])
		Else
			// MsgInfo(OemToAnsi("Compra de Frete TLA Incluido com sucesso! CTRC:")+aCabec[4,2],"Informação")
		EndIf

		conout("DOC : " + aCabec[3,2])
		
	Else
		If lAutoRot
			// ConOut(OemToAnsi("Erro na inclusao!") + Left(cLinha,200))
			ConOut("Erro na inclusao! - " + StrTran(StrTran(Left(cLinha,55),chr(10),""),chr(13),""))
			ConOut(FunName())
		Else
			// Alert(OemToAnsi("Erro na inclusao!"))
			Alert(MostraErro())			
			// ConOut("WMS - Entrada " + cLinha)
		EndIf	
	EndIf

//End

ConOut(OemToAnsi("Fim Geração do CTRC de compra de Frete TLA : ")+Time())

RestArea(_aArea)
Return(.T.)


/*
*---------------------------------------------------------------------------*
* Função     |GEFAFRETE   | Autor | J Ricardo             | Data | 12.12.13 *
*---------------------------------------------------------------------------*
* Descrição  |Rotina para gerar compra de frete para os títulos que não     *
*            |foi gerado durante a executação da rotina automática          * 
*            |                                                              * 
*---------------------------------------------------------------------------*
*/                                                      
User Function GEFAFRETE()
Local _aArea 	:= GetArea()
Local _cSQL  	:= ""
Local _nVrFrete := 0.00
Local _cPrefixo := ""
Local _cEmisIni := ""
Local _cEmisFim := ""
Local _dDtaEmis := CTOD("  /  /  ")

cPerg   := "GEFAFRETE "
CriaSX1()
Pergunte(cPerg,.T.)

_cPrefixo := MV_PAR03
_cEmisIni := DTOS(MV_PAR01)
_cEmisFim := DTOS(MV_PAR02)
_dDtaEmis := MV_PAR04

_cSQL := " SELECT DT6_FILDOC, DT6_LOTNFC, DT6_DOC, DT6_SERIE, DT6_PREFIX, DT6_VALTOT, DT6_TABFRE, DT6_SERVIC, "
_cSQL += " 	      DT6_CLIREM, DT6_LOJREM, DT6_CLIDEV, DT6_LOJDEV, DT6_CCUSTO, DTP_CODVEI, DTP_CODMOT, "
_cSQL += " 	      A2_CGC, A2_COD, A2_LOJA, A2_NOME "
_cSQL += "  FROM DT6010, DTP010, DA3010, SA2010 "
_cSQL += " WHERE DT6_FILDOC='" + cFilAnt + "' AND DT6_PREFIX='" + _cPrefixo + "' AND DT6_DATEMI BETWEEN '" + _cEmisIni + "' AND '" + _cEmisFim +"' "
_cSQL += "   AND SUBSTRING(DT6_CCUSTO,1,3) IN ('101','102') "
_cSQL += "   AND DT6010.D_E_L_E_T_='' "
_cSQL += "   AND (DT6_FILDOC + DT6_DOC + DT6_PREFIX ) NOT IN "
_cSQL += "       ( SELECT E2_FILIAL + E2_NUM + E2_PREFIXO FROM SE2010 WHERE E2_FILIAL=DT6_FILDOC AND E2_EMISSAO BETWEEN '" + _cEmisIni + "' AND '"  + _cEmisFim + "' AND SE2010.D_E_L_E_T_='' ) "
_cSQL += "   AND DT6_LOTNFC = DTP_LOTNFC "
_cSQL += "   AND DTP_CODVEI = DA3_COD "
_cSQL += "   AND DTP010.D_E_L_E_T_='' "
_cSQL += "   AND DA3_CODFOR = A2_COD  "
_cSQL += "   AND DA3_LOJFOR = A2_LOJA "
_cSQL += "   AND DA3010.D_E_L_E_T_='' "

If Select("TDT6") > 0
	dbSelectArea("TDT6")
	dbCloseArea()
EndIf
	
_cSQL := ChangeQuery(_cSQL)
DbUseArea(.T.,"TOPCONN",TCGenQry(,,_cSQL),"TDT6",.T.,.T.)

dbSelectArea("TDT6") ; dbGoTop()   
ProcRegua(0)

While !TDT6->(Eof())   
	IncProc()
	
	// Posiciona na SF2
	dbSelectArea("SF2") ; dbSetOrder(1)
	dbSeek(xFilial("SF2") + TDT6->DT6_DOC + TDT6->DT6_SERIE + TDT6->DT6_CLIDEV + TDT6->DT6_LOJDEV )

	// Pego o valor da compra de Frete no TMS	
	_nVrFrete := fGEFCFRT(TDT6->DT6_FILDOC, TDT6->DT6_DOC, TDT6->DT6_SERIE)
	
	// Gero título de compra de frete no Contas a Pagar
    U_GEFM079(NIL, TDT6->A2_COD, TDT6->A2_LOJA, _nVrFrete, TDT6->DT6_CCUSTO, _dDtaEmis)
 
	dbSelectArea("TDT6")
	dbSkip()
End

TDT6->(dbCloseArea())

RestArea(_aArea)
Return

/*
*---------------------------------------------------------------------------*
* Função     |fGEFCFRT   | Autor | J Ricardo             | Data | 12.12.13 *
*---------------------------------------------------------------------------*
* Descrição  |Rotina para pegar o valor de compra de Frete do FVL do TMS    *
*---------------------------------------------------------------------------*
*/
Static Function fGEFCFRT(_cFilial, _cDoc, _cSerie )
Local _aArea := GetArea()
Local _cCompCom := ""
Local _nVrCompra:= 0.00
Local _cSQL     := ""
Local _cProd    := ""

// dbSelectArea("DT8") ; dbSetOrder(2) // Fil.Doc+No.Docto+Série Docto+Produto+Componente
_cProd 		:= PadR(AllTrim(GETMV("MV_XPROTLA")),(TamSX3("DT8_CODPRO")[1]))
_cCompCom 	:= AllTrim(GETMV("MV_XTLACOM"))  // Componentes de compra de frete (CT, I3, TP, I2)
_cSQL		:= ""

// Por: Ricardo Guimarães - Em: 25/04/2012 - Passou a considerar a pedágio no valor de compra de frete
_cSQL := " SELECT SUM(DT8_VALPAS) AS DT8_VALPAS FROM " + RetSqlName("DT8") + " DT8 "
_cSQL += "  WHERE DT8_FILIAL = '" + xFilial("DT8")  + "' "
_cSQL += "    AND DT8_FILDOC = '" + _cFilial + "' "
_cSQL += "    AND DT8_DOC    = '" + _cDoc    + "' "
_cSQL += "    AND DT8_SERIE  = '" + _cSerie  + "' "
_cSQL += "    AND DT8_CODPAS IN " + _cCompCom

If Select("TDT8") > 0
	dbSelectArea("TDT8")
	dbCloseArea()
EndIf
	
cQuery := ChangeQuery(_cSQL)
DbUseArea(.T.,"TOPCONN",TCGenQry(,,_cSQL),"TDT8",.T.,.T.)

DbSelectArea("TDT8")
TDT8->(DbGoTop())
	
If !TDT8->(Eof())
	_nVrCompra := TDT8->DT8_VALPAS
EndIf
	
TDT8->(dbCloseArea())

RestArea(_aArea)
Return( _nVrCompra )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CriaSX1   ³ Autor ³Katia Alves Bianchi    ³ Data ³18/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ajuste de Perguntas (SX1)                 			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CriaSX1()

_sAlias := Alias()																		
dbSelectArea("SX1")
dbSetOrder(1)
aRegs :={}

//(sx1) Grupo/Ordem/Pergunta/X1_PERSPA/X1_PERENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSpa1/DefEng1/Cnt01/Var02/Def02/DefSpa2/DefEng2/Cnt02/Var03/Def03/DefSpa3/DefEng3/Cnt03/Var04/Def04/DefSpa4/DefEng4/Cnt04/Var05/Def05/DefSpa5/DefEng5/Cnt05/F3
/*
aAdd(aRegs,{cPerg,"01","Cliente              ?","¿De Cliente    ?","From Customer  ?","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
aAdd(aRegs,{cPerg,"02","Loja                 ?","¿De Tienda     ?","From unit      ?","mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Tipo Transporte      ?","¿Tipo Transporte ?","Tipo Transporte ?","mv_ch3","N",1,0,0,"C","","mv_par03","Rodoviario","","","","","Aereo","","","","","","","","","","","","","","","","","","","","","","",""})
*/
aAdd(aRegs,{cPerg,"01","Data Inicial         ?","¿Data Inicial  ?","Data Inial  ?","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Final           ?","¿Data Final    ?","Data Final  ?","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Prefixo              ?","¿Prefixo       ?","Prefixo     ?","mv_ch3","C",3,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data Emissão         ?","¿Data Emissão  ?","Data Emissão?","mv_ch4","D",8,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
dbSelectArea(_sAlias)

Return()