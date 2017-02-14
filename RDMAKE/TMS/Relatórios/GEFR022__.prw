#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"    
#INCLUDE "TOPCONN.CH"
/************************************************************************
* Programa........: GEFR022                                             *
* Autor...........: J Ricardo de O Guimarães                            *
* Data............: 27/05/2010                                          *
* Descricao.......: Relatório de CTRC´S Emitidios pelo TMS, em Excel    *
*                                                                       *
*************************************************************************
* Modificado por..: J Ricardo de O Guimarães                            *
* Data............: 02/09/2015                                          *
* Motivo..........: Passar a processar os CT-e´s emitidos pelo GPO      *
*                   Projeto RENOVA(IT UP)                               *
*                   Rel. baseado no GEFR21                              *
************************************************************************/
User Function GEFR022()
Local 	nOpcao	 :=	0
Private oDlgVnd	 := 	nil
Private cPath	 :=	space(255)
Private cArquivo :=	space(255)
Private _dDataIni:=	ctod("//")
Private _dDataFim:=	ctod("//")
Private _cCTRCIni:=	Space(TAMSX3("DTC_DOC")[1])
Private _cCTRCFim:=	Space(TAMSX3("DTC_DOC")[1])
Private _cFilialIni :=	Space(TAMSX3("DTC_FILORI")[1])
Private _cFilialFim :=	Space(TAMSX3("DTC_FILORI")[1])
Private _cTipoRel   := ""
Private _cCCIni		:= 	Space(TAMSX3("CTT_CUSTO")[1])
Private _cCCFim		:= 	Space(TAMSX3("CTT_CUSTO")[1])

cArquivo := PadR("CT-e",50)

//SetKey (VK_F3,{|a,b| cPath:=cGetFile( "DBF(*.dbf) | *.dbf ",OemToAnsi("Salvar em..."),,"U:",.f.,GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_LOCALFLOPPY)})
// @ 200,1 TO 472,420 DIALOG oDlgVnd TITLE OemToAnsi("Relatorio de CTRCs Emitidos pelo TMS.")

@ 200,1 TO 650,420 DIALOG oDlgVnd TITLE OemToAnsi("Relatorio de CT-e´s Emitidos pelo TMS e GPO.")
@ 02,10 TO 220,190
@ 10,018 Say " Este programa ira gerar arquivo de CT-e´s emitidos p/ ser lido em Excel. "
@ 18,018 Say " Defina abaixo os parâmetros do relatório"
@ 26,018 Say "                                                            "
@ 34,018 Say "Diretorio:"
@ 32,050 Get cPath Picture "@!" Size 60,20
@ 32,110 BUTTON "..." SIZE 10,10 ACTION (cPath:=cGetFile( "DBF(*.dbf) | *.dbf ",OemToAnsi("Salvar em..."),,"U:",.f.,GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY))
@ 50,018 Say "Arquivo:"
@ 48,050 Get cArquivo Picture "@!" Size 60,20
@ 66,018 Say "Data Inicial : "
@ 64,050 Get _dDataIni Picture "@D"
@ 82,018 Say "Data Final   : "
@ 80,050 Get _dDataFim Picture "@D"
@ 98,018 Say "CT-e Inicial : "
@ 98,050 Get _cCTRCIni Size 60,20
@ 116,018 Say "CT-e Final   : "
@ 116,050 Get _cCTRCFim Size 60,20
@ 132,018 Say "Filial Inicial : "
@ 132,050 Get _cFilialIni 
@ 148,018 Say "Filial Final : "
@ 148,050 Get _cFilialfim
@ 164,018 Say "C.Custo Inicial : "
@ 164,050 Get _cCCIni F3 "CTT" Size 60,20
@ 180,018 Say "C.Custo Final   : "
@ 180,050 Get _cCCfim F3 "CTT" Size 60,20
@ 198,018 Say "Tipo de Rel. : "
@ 200,050 MSCOMBOBOX oCmb1 VAR _cTipoRel ITEMS {"Analitico","Sintetico"} SIZE 60, 150 OF oDlgVnd COLORS 0, 16777215 PIXEL


@ 200,128 BMPBUTTON TYPE 01 ACTION (nOpcao:=1,iif(fvldOk(),Close(oDlgVnd),))
@ 200,158 BMPBUTTON TYPE 02 ACTION (nOpcao:=2,Close(oDlgVnd))

Activate Dialog oDlgVnd Centered
SetKey (VK_F3,{||})

If nOpcao == 1
	If Left(_cTipoRel,1) == "A"  // Analítico
		Processa({|| RunExport2() },"Processando...")
	Else 
		Processa({|| RunExport() },"Processando...")
	EndIf	
EndIf

Return

/*************************************************************************
* Funcao....: RUNReport()                                                *
* Autor.....: J Ricardo de O Guimarães                                   *
* Data......: 27/05/2010                                                 *
* Descricao.: Funcao responsável pela busca de informacoes na tabela DTC *
*                                                                        *
*************************************************************************/
Static Function RunExport(Cabec1,Cabec2,Titulo,nLin)
Local cQry		:=	""
Local aPrint	:=	{}
Local nPos		:=	0
Local cTipo		:= ""
Local _cNFs		:= ""
Local _cObs		:= ""
Local _cSelOri	:= ""

Private cdbfFAT	:=	""
Private cInd1	:=	""

cdbfFAT	:=	criatrab("",.F.)

//Buscando informacoes processadas 
//Relatório Sintético

cQry := " SELECT DT6_FILORI, DT6_LOTNFC = CASE WHEN DT6_LOTNFC = '' THEN 'GPO' ELSE DT6_LOTNFC END, "
cQry += "    DT6_DATEMI, DT6_DOC, DT6_SERIE, '' AS NOTAS_CLI, DT6_VALMER, DT6_VOLORI, "
cQry += "    DT6_PESO, DT6_PESOM3, DT6_METRO3, DT6_VALFRE, DT6_VALIMP, DT6_VALTOT, ZT0_CODTAB AS DT8_TABFRE, ZT0_ITEMTB AS DT8_TIPTAB, "
cQry += "	 DT6_CLIREM, DT6_LOJREM, SA1R.A1_CGC AS REM_CNPJ, SA1R.A1_NOME AS REMETENTE, DT6_CLIDES, DT6_LOJDES, SA1D.A1_CGC AS DES_CNPJ, SA1D.A1_NOME AS DESTINAT, "
cQry += "    DEV_FRETE = CASE "
cQry += "                  WHEN DT6_DEVFRE = '1' THEN 'Remetente'     "
cQry += "                  WHEN DT6_DEVFRE = '2' THEN 'Destinatario'  "
cQry += "                  WHEN DT6_DEVFRE = '3' THEN 'Consignatario' "
cQry += "      		       WHEN DT6_DEVFRE = '4' THEN 'Despachante'   "
cQry += "      			   ELSE 'N/DEFINIDO' "
cQry += "                END, "
cQry += "  	DT6_CLIDEV, DT6_LOJDEV, SA1DEV.A1_NOME AS CLI_DEV, DT6_CLICAL, DT6_LOJCAL, DT6_TIPFRE, DT6_SERTMS, DT6_TIPTRA, DT6_SERVIC, "
cQry += "  	X5_DESCRI AS SERVICO, SPACE(20) AS SELEC_ORIG, DT6_CDRORI, DTQ_ORIGEM AS REG_ORIGEM, DT6_CDRDES, DTQ_DESTIN AS REG_DEST, "
cQry += "  	DT6_CDRCAL, SA1DEV.A1_MUN AS REG_CALC, DT6_CCUSTO, DT6_CCONT, DT6_OI, DT6_CONTA , DT6_TIPDES, DT6_REFGEF, "
cQry += "	SUM(DT8_VALTOT) AS DT8_VALTOT, "
cQry += "	SUM(DT8_VALPAS) AS DT8_VALPAS, SUM(DT8_VALIMP) AS DT8_VALIMP, "
cQry += "       'FRETE_PESO'  = SUM( CASE WHEN DT8_CODPAS = 'FR' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'FRETE_VAL'   = SUM( CASE WHEN DT8_CODPAS = 'TF' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'SEC_CAT'     = ( DTQ_BASADV * DTQ_VALADV ) / 100, "
cQry += "       'PEDAGIO'     = DTQ_VRPEDA, "
cQry += "       'GRIS'        = ( DT6_VALMER * ZT0_PGRIS ) / 100, "
cQry += "       'ITR'         = 0, "
cQry += "       'SUFRAMA'     = 0, "
cQry += "       'DESPACHO'    = 0, "
cQry += "       'OUTROS'      = DTQ_VROUTR, "
cQry += "       'NFRETEPESO'  = '', SPACE(100) AS OBS, DTQ_VIAGEM AS VIAGEM " 
cQry += " FROM  DT6010 DT6, DT8010 DT8, DTQ010 DTQ, ZA7010 ZA7, ZA6010 ZA6, ZT0010 ZT0, "
cQry += "	    SA1010 SA1R, SA1010 SA1D, SA1010 SA1DEV, SX5010 SX5 "
cQry += " WHERE DT6.D_E_L_E_T_='' "
cQry += "   AND DT6_FILDOC BETWEEN '" + _cFilialIni     + "' AND '" + _cFilialFim + "' "
cQry += "   AND DT6_DATEMI BETWEEN '" + DTOS(_dDataIni) + "' AND '" + DTOS(_dDataFim) + "' "
cQry += "   AND DT6_DOC BETWEEN    '" + _cCTRCIni       + "' AND '" + _cCTRCFim + "' "
cQry += "   AND DT6_CCUSTO BETWEEN '" + _cCCIni         + "' AND '" + _cCCFim + "' "
cQry += "   AND DT6_LOTNFC='' " //--- CT-e gerado pelo GPO
cQry += "   AND DT6_FILDOC = DT8_FILDOC "  
cQry += "   AND DT6_DOC    = DT8_DOC    "    
cQry += "   AND DT6_SERIE  = DT8_SERIE  "
cQry += "   AND DT6_CLIREM + DT6_LOJREM = SA1R.A1_COD   + SA1R.A1_LOJA   "
cQry += "   AND DT6_CLIDES + DT6_LOJDES = SA1D.A1_COD   + SA1D.A1_LOJA   "
cQry += "   AND DT6_CLIDEV + DT6_LOJDEV = SA1DEV.A1_COD + SA1DEV.A1_LOJA "
cQry += "   AND DT6_SERVIC = X5_CHAVE AND X5_TABELA='L4' "
cQry += "   AND DT6_FILIAL = DTQ_FILIAL "
cQry += "   AND DT6_FILDOC = DTQ_FILORI "
cQry += "   AND DT6_DOC    = DTQ_NUMCTR "
cQry += "   AND DT6_SERIE  = DTQ_SERCTR "
cQry += "   AND DTQ_FILORI = ZA7_FILIAL "
cQry += "   AND DTQ_VIAGEM = ZA7_VIAGEM "
cQry += "   AND DTQ_AS     = ZA6_AS     "
cQry += "   AND ZA6_TABVEN = ZT0_CODTAB "
cQry += "   AND ZA6_VERVEN = ZT0_VERTAB "
cQry += "   AND ZA6_ITTABV = ZT0_ITEMTB "
cQry += "   AND DT8.D_E_L_E_T_   ='' "
cQry += "   AND SA1R.D_E_L_E_T_  ='' " 
cQry += "   AND SA1D.D_E_L_E_T_  ='' "
cQry += "   AND SA1DEV.D_E_L_E_T_='' "
cQry += "   AND SX5.D_E_L_E_T_   ='' " 
cQry += "   AND DTQ.D_E_L_E_T_   ='' "
cQry += "   AND ZA6.D_E_L_E_T_   ='' "   
cQry += "   AND ZA7.D_E_L_E_T_   ='' " 
cQry += " GROUP BY DT6_FILORI, DT6_DATEMI, DT6_LOTNFC, DT6_DOC, DT6_SERIE, DT6_VALMER, DT6_VOLORI, DT6_PESO, DT6_PESOM3, DT6_METRO3, DT6_VALFRE, DT6_VALIMP, DT6_VALTOT, ZT0_CODTAB, ZT0_ITEMTB, "
cQry += "	DT6_CLIREM, DT6_LOJREM, SA1R.A1_CGC, SA1R.A1_NOME, DT6_CLIDES, DT6_LOJDES, SA1D.A1_CGC, SA1D.A1_NOME, DT6_DEVFRE, "
cQry += " 	DT6_CLIDEV, DT6_LOJDEV, SA1DEV.A1_NOME, DT6_CLICAL, DT6_LOJCAL, DT6_TIPFRE, DT6_SERTMS, DT6_TIPTRA, DT6_SERVIC, "
cQry += "  	X5_DESCRI, DT6_CDRORI, DTQ_ORIGEM, DT6_CDRDES, DTQ_DESTIN, DT6_CDRCAL, SA1DEV.A1_MUN, "
cQry += "   DT6_CCUSTO, DT6_CCONT, DT6_OI, DT6_CONTA , DT6_TIPDES, DT6_REFGEF, DTQ_BASADV, DTQ_VALADV, DTQ_VRPEDA, DT6_VALMER, ZT0_PGRIS, DTQ_VROUTR, DTQ_VIAGEM "

cQry += " UNION "

cQry += " SELECT DT6_FILORI, DT6_LOTNFC, DT6_DATEMI, DT6_DOC, DT6_SERIE, SPACE(100) AS NOTAS_CLI, DT6_VALMER, DT6_VOLORI, DT6_PESO, DT6_PESOM3, DT6_METRO3, DT6_VALFRE, DT6_VALIMP, DT6_VALTOT, DT8_TABFRE, DT8_TIPTAB, "
cQry += "	DT6_CLIREM, DT6_LOJREM, SA1R.A1_CGC AS REM_CNPJ, SA1R.A1_NOME AS REMETENTE, DT6_CLIDES, DT6_LOJDES, SA1D.A1_CGC AS DES_CNPJ, SA1D.A1_NOME AS DESTINAT, "
cQry += "        DEV_FRETE = CASE "
cQry += "                       WHEN DT6_DEVFRE = '1' THEN 'Remetente'     "
cQry += "                       WHEN DT6_DEVFRE = '2' THEN 'Destinatario'  "
cQry += "                       WHEN DT6_DEVFRE = '3' THEN 'Consignatario' "
cQry += "		       			WHEN DT6_DEVFRE = '4' THEN 'Despachante'   "
cQry += "		       			ELSE 'N/DEFINIDO' "
cQry += "                   END,"
cQry += "       	DT6_CLIDEV, DT6_LOJDEV, SA1DEV.A1_NOME AS CLI_DEV, DT6_CLICAL, DT6_LOJCAL, DT6_TIPFRE, DT6_SERTMS, DT6_TIPTRA, DT6_SERVIC, "
cQry += "       	X5_DESCRI AS SERVICO, SPACE(20) AS SELEC_ORIG, "
cQry += "        DT6_CDRORI, DUYO.DUY_DESCRI AS REG_ORIGEM, DT6_CDRDES, DUYD.DUY_DESCRI AS REG_DEST, DT6_CDRCAL, DUYC.DUY_DESCRI AS REG_CALC, "
cQry += "        DT6_CCUSTO, DT6_CCONT, DT6_OI, DT6_CONTA , DT6_TIPDES, DT6_REFGEF, "
cQry += "	SUM(DT8_VALTOT) AS DT8_VALTOT, "
cQry += "	SUM(DT8_VALPAS) AS DT8_VALPAS, SUM(DT8_VALIMP) AS DT8_VALIMP, "
cQry += "       'FRETE_PESO'  = SUM( CASE WHEN DT3_COLIMP = '1' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'FRETE_VAL'   = SUM( CASE WHEN DT3_COLIMP = '2' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'SEC_CAT'     = SUM( CASE WHEN DT3_COLIMP = '3' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'PEDAGIO'     = SUM( CASE WHEN DT3_COLIMP = '4' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'GRIS'        = SUM( CASE WHEN DT3_COLIMP = '5' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'ITR'         = SUM( CASE WHEN DT3_COLIMP = '6' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'SUFRAMA'     = SUM( CASE WHEN DT3_COLIMP = '7' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'DESPACHO'    = SUM( CASE WHEN DT3_COLIMP = '8' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'OUTROS'      = SUM( CASE WHEN DT3_COLIMP = '9' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'NFRETEPESO'  = MAX(CASE WHEN DT3_COLIMP = '1' THEN DT3_DESCRI ELSE '' END ), SPACE(100) AS OBS, '' AS VIAGEM  "  // Alterado por: Ricardo - Em: 20/08/12 - Inclusão de colunaSPACE(100) AS OBS "
cQry += " FROM  " + RetSqlName("DT6") + " DT6 LEFT JOIN DTL010 DTL ON DT6_TABFRE = DTL_TABFRE AND DT6_TIPTAB = DTL_TIPTAB, " 
cQry +=             RetSqlName("DT3") + " DT3,  " + RetSqlName("DT8") + " DT8, " + RetSqlName("SA1") + " SA1R, " + RetSqlName("SA1") + " SA1D, "
cQry += 			RetSqlName("SA1") + " SA1DEV, " + RetSqlName("SX5") + " SX5, " + RetSqlName("DUY") + " DUYO, " 
cQry += 			RetSqlName("DUY") + " DUYD, "   + RetSqlName("DUY") + " DUYC "
cQry += " WHERE DT6.D_E_L_E_T_='' "
cQry += "   AND DT6_FILDOC BETWEEN '" + _cFilialIni + "'     AND '" + _cFilialFim + "' "
cQry += "   AND DT6_DATEMI BETWEEN '" + DTOS(_dDataIni) + "' AND '" + DTOS(_dDataFim) + "' "
cQry += "   AND DT6_DOC BETWEEN    '" + _cCTRCIni + "'       AND '" + _cCTRCFim + "' "
cQry += "   AND DT6_FILDOC = DT8_FILDOC "              
cQry += "   AND DT6_CCUSTO BETWEEN '" + _cCCIni + "' AND '" + _cCCFim + "' "
cQry += "   AND DT6_DOC    = DT8_DOC    "
cQry += "   AND DT6_SERIE  = DT8_SERIE  "
cQry += "   AND DT8_CODPAS = DT3_CODPAS "
cQry += "   AND DT8.D_E_L_E_T_   ='' "
cQry += "   AND DTL.D_E_L_E_T_   ='' "
cQry += "   AND DT3.D_E_L_E_T_   ='' "
cQry += "   AND SA1R.D_E_L_E_T_  ='' "
cQry += "   AND SA1D.D_E_L_E_T_  ='' "
cQry += "   AND SA1DEV.D_E_L_E_T_='' "
cQry += "   AND DUYD.D_E_L_E_T_  ='' "
cQry += "   AND DUYC.D_E_L_E_T_  ='' "
cQry += "   AND SX5.D_E_L_E_T_   ='' "
cQry += "   AND DT6_CLIREM + DT6_LOJREM = SA1R.A1_COD   + SA1R.A1_LOJA   "
cQry += "   AND DT6_CLIDES + DT6_LOJDES = SA1D.A1_COD   + SA1D.A1_LOJA   "
cQry += "   AND DT6_CLIDEV + DT6_LOJDEV = SA1DEV.A1_COD + SA1DEV.A1_LOJA "
cQry += "   AND DT6_SERVIC = X5_CHAVE AND X5_TABELA='L4' "
cQry += "   AND DT6_CDRORI = DUYO.DUY_GRPVEN "
cQry += "   AND DT6_CDRDES = DUYD.DUY_GRPVEN "
cQry += "   AND DT6_CDRCAL = DUYC.DUY_GRPVEN "
cQry += " GROUP BY DT6_FILORI, DT6_DATEMI, DT6_LOTNFC, DT6_DOC, DT6_SERIE, DT6_VALMER, DT6_VOLORI, DT6_PESO, DT6_PESOM3, DT6_METRO3, DT6_VALFRE, DT6_VALIMP, DT6_VALTOT, DT8_TABFRE, DT8_TIPTAB, "
cQry += "		   DT6_CLIREM, DT6_LOJREM, SA1R.A1_CGC, SA1R.A1_NOME, DT6_CLIDES, DT6_LOJDES, SA1D.A1_CGC, SA1D.A1_NOME, DT6_DEVFRE, "
cQry += "          DT6_CLIDEV, DT6_LOJDEV, SA1DEV.A1_NOME, DT6_CLICAL, DT6_LOJCAL, DT6_TIPFRE, DT6_SERTMS, DT6_TIPTRA, DT6_SERVIC, "
cQry += "          X5_DESCRI, DT6_CDRORI, DUYO.DUY_DESCRI, DT6_CDRDES, DUYD.DUY_DESCRI, DT6_CDRCAL, DUYC.DUY_DESCRI, " 
cQry += "          DT6_CCUSTO, DT6_CCONT, DT6_OI, DT6_CONTA , DT6_TIPDES, DT6_REFGEF "
cQry += " ORDER BY DT6_FILORI, DT6_LOTNFC, DT6_DATEMI, DT6_DOC "

//MEMOWRIT("D:\TEMP\QRYFATURA.TXT",cQry)

 TcQuery cQry Alias "TFAT" New
//TcQuery cQry Alias (cdbfFAT) New            
//DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),cdbfFAT,.T.,.T.)

TcSetField("TFAT" ,"DT6_VOLORI" ,"N",09,0)	
TcSetField("TFAT" ,"DT6_PESO"   ,"N",15,5)
TcSetField("TFAT" ,"DT6_PESOM3" ,"N",15,3)
TcSetField("TFAT" ,"DT6_VALFRE" ,"N",15,2)
TcSetField("TFAT" ,"DT6_METRO3" ,"N",15,3)
TcSetField("TFAT" ,"DT6_VALMER" ,"N",15,2)
TcSetField("TFAT" ,"DT6_VALIMP" ,"N",15,2)
TcSetField("TFAT" ,"DT6_VALPAS" ,"N",15,2)
TcSetField("TFAT" ,"DT6_VALTOT" ,"N",15,2)
TcSetField("TFAT" ,"DT8_VALPAS" ,"N",15,2)
TcSetField("TFAT" ,"DT8_VALIMP" ,"N",15,2)
TcSetField("TFAT" ,"DT8_VALTOT" ,"N",15,2)
TcSetField("TFAT" ,"DT6_VALMER" ,"N",15,2)
TcSetField("TFAT" ,"ZT0_PGRIS"  ,"N",15,2)
TcSetField("TFAT" ,"DTQ_BASADV" ,"N",15,2)
TcSetField("TFAT" ,"DTQ_VALADV" ,"N",15,2)
TcSetField("TFAT" ,"DTQ_VRPEDA" ,"N",15,2)
TcSetField("TFAT" ,"DTQ_VROUTR" ,"N",15,2)
/*
cQuery := ChangeQuery(cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TFAT', .T., .T.)
*/
dbSelectArea("TFAT") ; dbGoTop()

//dbSelectArea(cdbfFAT) ; dbGoTop()

COPY TO (cdbfFAT) VIA "DBFCDXADS"

dbSelectArea("TFAT") ; dbCloseArea()

//dbUseArea(.T.,, (cdbfFAT), "TRB", .T. , .F.)
dbUseArea(.T.,"DBFCDXADS", (cdbfFAT), "TRB", .T. , .F.)

dbSelectArea("TRB")
dbGoTop()

INCLUI := .F.
While !Eof()
	IncProc()
	
	Qry := " SELECT DTC_FILORI, DTC_LOTNFC, DTC_DATENT, DTC_NUMNFC AS NF, DTC_SERNFC, DTC_SERIE, DTC_DOC, DTC_CODOBS, DTC_SELORI "
	Qry += "  FROM " + RetSqlName("DTC") + " DTC " 
	Qry += " WHERE DTC_FILORI = '" + TRB->DT6_FILORI + "' "
	Qry += "   AND DTC_LOTNFC = '" + TRB->DT6_LOTNFC + "' "
	Qry += "   AND DTC_DOC    = '" + TRB->DT6_DOC    + "' "
	Qry += "   AND DTC_SERIE  = '" + TRB->DT6_SERIE  + "' "
	Qry += "   AND D_E_L_E_T_ = '' "	
	Qry += " ORDER BY DTC_NUMNFC, DTC_SERNFC "

	If Select("NF") > 0
		dbSelectArea("NF") ; dbCloseArea()
	EndIf

//	MEMOWRIT("D:\TEMP\QRYFATURA.TXT",cQry)
	
	TcQuery Qry Alias "NF" New

    _cNFs := ""
    _cObs := ""
    _cSelOri := ""

	dbSelectArea("NF") ; dbGoTop()
	While !NF->(Eof())

	    _cNFs += AllTrim(NF->NF) + "/"

		If AllTrim(TRB->DT6_LOTNFC) == "GPO"
			_cObs := GetAdvFVal('ZA7','ZA7_OBS',TRB->VIAGEM,3,"") // LEFT(TRB->DTC_CODOBS,80)
		Else	
	    	_cObs := E_MSMM(NF->DTC_CODOBS,80)
	    EndIf	    

	    _cSelOri := IIF(NF->DTC_SELORI=="1","Transportadora",IIF(NF->DTC_SELORI=="2","Cliente Remetente",IIF(NF->DTC_SELORI=="2","Local Coleta","")))
		
		dbSelectArea("NF")
		dbSkip()
	End

	dbSelectArea("TRB") 
	RecLock("TRB",.f.)
		TRB->OBS := _cObs
		TRB->NOTAS_CLI  := SubStr(_cNFs,1,Len(_cNFs)-1) 
		TRB->SELEC_ORIG := _cSelOri
   	MsunLock()		

	dbSkip()
End

If Select("NF") > 0
	dbSelectArea("NF") ; dbCloseArea()
EndIf

dbSelectArea("TRB") ; dbCloseArea()

ProcRegua(0)

//Formatando DBF para exportar para o excel
fExpExcel()

Return


/*************************************************************************
* Funcao....: RUNReport2()                                                *
* Autor.....: J Ricardo de O Guimarães                                   *
* Data......: 27/05/2010                                                 *
* Descricao.: Funcao responsável pela busca de informacoes na tabela DTC *
*                                                                        *
*************************************************************************/
// Relatório Analítico
Static Function RunExport2(Cabec1,Cabec2,Titulo,nLin)
Local cQry		:=	""
Local aPrint	:=	{}
Local nPos		:=	0
Local cTipo		:= ""
Local _cNFs		:= ""
Local _cObs		:= ""
Local _cSelOri	:= ""

Private cdbfFAT	:=	""
Private cInd1	:=	""

cdbfFAT	:=	criatrab("",.F.)

//Buscando informacoes processadas 
// CT-e´s emitidos pelo GPO( Projeto RENOVA - IT UP) 
cQry += "SELECT DT6_FILORI, DT6_LOTNFC = CASE WHEN DT6_LOTNFC = '' THEN 'GPO' ELSE DT6_LOTNFC END, " 
cQry += "       DT6_DATEMI, DT6_DOC, DT6_SERIE, DTC_NUMNFC AS NOTA_CLI, DTC_VALOR, DTC_QTDVOL,     " 
cQry += "       DTC_PESO, DTC_PESOM3, DTC_METRO3, DT6_VALFRE, DT6_VALIMP, DT6_VALTOT, ZT0_CODTAB AS DT8_TABFRE, ZT0_ITEMTB AS DT8_TIPTAB, " 
cQry += "    	  DT6_CLIREM, DT6_LOJREM, SA1R.A1_CGC AS REM_CNPJ, SA1R.A1_NOME AS REMETENTE, DT6_CLIDES, DT6_LOJDES, SA1D.A1_CGC AS DES_CNPJ, SA1D.A1_NOME AS DESTINAT, " 
cQry += "       DEV_FRETE = CASE " 
cQry += "              		  WHEN DT6_DEVFRE = '1' THEN 'Remetente'    "
cQry += "              		  WHEN DT6_DEVFRE = '2' THEN 'Destinatario' "
cQry += "              		  WHEN DT6_DEVFRE = '3' THEN 'Consignatario'"
cQry += "    		     		  WHEN DT6_DEVFRE = '4' THEN 'Despachante'  "
cQry += "    					ELSE 'N/DEFINIDO' " 
cQry += "                   END, "
cQry += "    	DT6_CLIDEV, DT6_LOJDEV, SA1DEV.A1_NOME AS CLI_DEV, DT6_CLICAL, DT6_LOJCAL, DT6_TIPFRE, DT6_SERTMS, DT6_TIPTRA, DT6_SERVIC, " 
cQry += "    	X5_DESCRI AS SERVICO, SPACE(20) AS SELEC_ORIG, DT6_CDRORI, DTQ_ORIGEM AS REG_ORIGEM, DT6_CDRDES, DTQ_DESTIN AS REG_DEST,   " 
cQry += "    	DT6_CDRCAL, SA1DEV.A1_MUN AS REG_CALC, DT6_CCUSTO, DT6_CCONT, DT6_OI, DT6_CONTA , DT6_TIPDES, DT6_REFGEF, " 
cQry += "     SUM(DT8_VALTOT) AS DT8_VALTOT, " 
cQry += "	    SUM(DT8_VALPAS) AS DT8_VALPAS, SUM(DT8_VALIMP) AS DT8_VALIMP, " 
cQry += "     'FRETE_PESO'  = SUM( CASE WHEN DT8_CODPAS = 'FR' THEN DT8_VALTOT ELSE 0 END ), " 
cQry += "     'FRETE_VAL'   = SUM( CASE WHEN DT8_CODPAS = 'TF' THEN DT8_VALTOT ELSE 0 END ), " 
cQry += "     'SEC_CAT'     = ( DTQ_BASADV * DTQ_VALADV ) / 100, " 
cQry += "     'PEDAGIO'     = DTQ_VRPEDA,                        " 
cQry += "     'GRIS'        = ( DT6_VALMER * ZT0_PGRIS ) / 100,  " 
cQry += "     'ITR'         = 0, " 
cQry += "     'SUFRAMA'     = 0, "
cQry += "     'DESPACHO'    = 0, " 
cQry += "     'OUTROS'      = DTQ_VROUTR, " 
cQry += "     'NFRETEPESO'  = '',  '' AS DTC_CODOBS, SPACE(100) AS OBS, DTC_SELORI, DTQ_VIAGEM AS VIAGEM  " 
cQry += "FROM " + RetSqlName("DT6") + " DT6,  " + RetSqlName("DT8") + " DT8,  " + RetSqlName("DTC") + " DTC,    " + RetSqlName("DTQ") + " DTQ, "
cQry +=           RetSqlName("ZA7") + " ZA7,  " + RetSqlName("ZA6") + " ZA6,  " + RetSqlName("ZT0") + " ZT0,    "
cQry +=           RetSqlName("SA1") + " SA1R, " + RetSqlName("SA1") + " SA1D, " + RetSqlName("SA1") + " SA1DEV, " + RetSqlName("SX5") + " SX5 "
cQry += "WHERE DT6.D_E_L_E_T_='' " 
cQry += "  AND DT6_FILDOC BETWEEN '" + _cFilialIni     + "' AND '" + _cFilialFim     + "' "
cQry += "  AND DT6_DATEMI BETWEEN '" + DTOS(_dDataIni) + "' AND '" + DTOS(_dDataFim) + "' "
cQry += "  AND DT6_DOC BETWEEN    '" + _cCTRCIni       + "' AND '" + _cCTRCFim       + "' "
cQry += "  AND DT6_FILDOC = DT8_FILDOC "
cQry += "  AND DT6_CCUSTO BETWEEN '" + _cCCIni         + "' AND '" + _cCCFim + "' "
cQry += "  AND DT6_LOTNFC='' " //-- CT-e gerado pelo GPO -> Projeto RENOVA ( IT UP ) "
cQry += "  AND DT6_FILDOC = DT8_FILDOC "   
cQry += "  AND DT6_DOC    = DT8_DOC    "    
cQry += "  AND DT6_SERIE  = DT8_SERIE  "  
cQry += "  AND DT6_CLIREM + DT6_LOJREM = SA1R.A1_COD   + SA1R.A1_LOJA   "   
cQry += "  AND DT6_CLIDES + DT6_LOJDES = SA1D.A1_COD   + SA1D.A1_LOJA   "   
cQry += "  AND DT6_CLIDEV + DT6_LOJDEV = SA1DEV.A1_COD + SA1DEV.A1_LOJA " 
cQry += "  AND DT6_SERVIC = X5_CHAVE AND X5_TABELA='L4' " 
cQry += "  AND DT6_FILIAL = DTQ_FILIAL "
cQry += "  AND DT6_FILDOC = DTQ_FILORI "
cQry += "  AND DT6_DOC    = DTQ_NUMCTR "
cQry += "  AND DT6_SERIE  = DTQ_SERCTR "
cQry += "  AND DTQ_FILORI = ZA7_FILIAL "
cQry += "  AND DTQ_VIAGEM = ZA7_VIAGEM "
cQry += "  AND DTQ_AS     = ZA6_AS     "
cQry += "  AND ZA6_TABVEN = ZT0_CODTAB "
cQry += "  AND ZA6_VERVEN = ZT0_VERTAB "
cQry += "  AND ZA6_ITTABV = ZT0_ITEMTB "
cQry += "  AND DT6_FILORI = DTC_FILORI "
cQry += "  AND DT6_DOC    = DTC_DOC    "
cQry += "  AND DT6_SERIE  = DTC_SERIE  "
cQry += "  AND DTC.D_E_L_E_T_=''       "
cQry += "  AND DT8.D_E_L_E_T_=''       "  
cQry += "  AND SA1R.D_E_L_E_T_=''      " 
cQry += "  AND SA1D.D_E_L_E_T_=''      " 
cQry += "  AND SA1DEV.D_E_L_E_T_=''    " 
cQry += "  AND SX5.D_E_L_E_T_=''       "  
cQry += "  AND DTQ.D_E_L_E_T_=''       "
cQry += "  AND ZA6.D_E_L_E_T_=''       "
cQry += "  AND ZA7.D_E_L_E_T_=''       "
cQry += "GROUP BY DT6_FILORI, DT6_DATEMI, DT6_LOTNFC, DT6_DOC, DT6_SERIE, DTC_NUMNFC, DTC_VALOR, DTC_QTDVOL, DTC_PESO, DTC_PESOM3, DTC_METRO3, DT6_VALFRE, DT6_VALIMP, DT6_VALTOT, ZT0_CODTAB, ZT0_ITEMTB, " 
cQry += "   	    DT6_CLIREM, DT6_LOJREM, SA1R.A1_CGC, SA1R.A1_NOME, DT6_CLIDES, DT6_LOJDES, SA1D.A1_CGC, SA1D.A1_NOME, DT6_DEVFRE, " 
cQry += "   	    DT6_CLIDEV, DT6_LOJDEV, SA1DEV.A1_NOME, DT6_CLICAL, DT6_LOJCAL, DT6_TIPFRE, DT6_SERTMS, DT6_TIPTRA, DT6_SERVIC,   " 
cQry += "   	    X5_DESCRI, DT6_CDRORI, DTQ_ORIGEM, DT6_CDRDES, DTQ_DESTIN, DT6_CDRCAL, SA1DEV.A1_MUN, " 
cQry += "         DT6_CCUSTO, DT6_CCONT, DT6_OI, DT6_CONTA , DT6_TIPDES, DT6_REFGEF, DTC_SELORI, DTC_CODOBS, DTQ_BASADV, DTQ_VALADV, DTQ_VRPEDA, DT6_VALMER, ZT0_PGRIS, DTQ_VROUTR, DTQ_VIAGEM "
// 
cQry += "UNION "
// CT-e´s emitidos pelo TMS
cQry += "SELECT DT6_FILORI, DT6_LOTNFC, DT6_DATEMI, DT6_DOC, DT6_SERIE, DTC_NUMNFC AS NOTA_CLI, DTC_VALOR, DTC_QTDVOL, DTC_PESO, DTC_PESOM3, DTC_METRO3, DT6_VALFRE, DT6_VALIMP, DT6_VALTOT, DT8_TABFRE, DT8_TIPTAB, "
cQry += "	DT6_CLIREM, DT6_LOJREM, SA1R.A1_CGC AS REM_CNPJ, SA1R.A1_NOME AS REMETENTE, DT6_CLIDES, DT6_LOJDES, SA1D.A1_CGC AS DES_CNPJ, SA1D.A1_NOME AS DESTINAT, "
cQry += "        DEV_FRETE = CASE "
cQry += "                       WHEN DT6_DEVFRE = '1' THEN 'Remetente'     "
cQry += "                       WHEN DT6_DEVFRE = '2' THEN 'Destinatario'  "
cQry += "                       WHEN DT6_DEVFRE = '3' THEN 'Consignatario' "
cQry += "		       			WHEN DT6_DEVFRE = '4' THEN 'Despachante'   "
cQry += "		       			ELSE 'N/DEFINIDO' "
cQry += "                   END,"
cQry += "       	DT6_CLIDEV, DT6_LOJDEV, SA1DEV.A1_NOME AS CLI_DEV, DT6_CLICAL, DT6_LOJCAL, DT6_TIPFRE, DT6_SERTMS, DT6_TIPTRA, DT6_SERVIC, "
cQry += "       	X5_DESCRI AS SERVICO, SPACE(20) AS SELEC_ORIG, "
cQry += "        DT6_CDRORI, DUYO.DUY_DESCRI AS REG_ORIGEM, DT6_CDRDES, DUYD.DUY_DESCRI AS REG_DEST, DT6_CDRCAL, DUYC.DUY_DESCRI AS REG_CALC, "
cQry += "        DT6_CCUSTO, DT6_CCONT, DT6_OI, DT6_CONTA , DT6_TIPDES, DT6_REFGEF, "
cQry += "	SUM(DT8_VALTOT) AS DT8_VALTOT, "
cQry += "	SUM(DT8_VALPAS) AS DT8_VALPAS, SUM(DT8_VALIMP) AS DT8_VALIMP, "
cQry += "       'FRETE_PESO'  = SUM( CASE WHEN DT3_COLIMP = '1' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'FRETE_VAL'   = SUM( CASE WHEN DT3_COLIMP = '2' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'SEC_CAT'     = SUM( CASE WHEN DT3_COLIMP = '3' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'PEDAGIO'     = SUM( CASE WHEN DT3_COLIMP = '4' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'GRIS'        = SUM( CASE WHEN DT3_COLIMP = '5' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'ITR'         = SUM( CASE WHEN DT3_COLIMP = '6' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'SUFRAMA'     = SUM( CASE WHEN DT3_COLIMP = '7' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'DESPACHO'    = SUM( CASE WHEN DT3_COLIMP = '8' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'OUTROS'      = SUM( CASE WHEN DT3_COLIMP = '9' THEN DT8_VALTOT ELSE 0 END ), "
cQry += "       'NFRETEPESO'  = MAX(CASE WHEN DT3_COLIMP = '1' THEN DT3_DESCRI ELSE '' END ), DTC_CODOBS, SPACE(100) AS OBS, DTC_SELORI, '' AS VIAGEM  "  // Alterado por: Ricardo - Em: 20/08/12 - Inclusão de colunaDTC_SELORI, DTC_CODOBS, SPACE(100) AS OBS "
cQry += " FROM  " + RetSqlName("DT6") + " DT6 LEFT JOIN DTL010 DTL ON DT6_TABFRE = DTL_TABFRE AND DT6_TIPTAB = DTL_TIPTAB, " 
cQry +=             RetSqlName("DT3") + " DT3,  "   + RetSqlName("DT8") + " DT8, " + RetSqlName("DTC") + " DTC, "  + RetSqlName("SA1") + " SA1R, " + RetSqlName("SA1") + " SA1D, "
cQry +=             RetSqlName("SA1") + " SA1DEV, " + RetSqlName("SX5") + " SX5, " + RetSqlName("DUY") + " DUYO, " 
cQry +=             RetSqlName("DUY") + " DUYD, "   + RetSqlName("DUY") + " DUYC "
cQry += "WHERE DT6.D_E_L_E_T_='' "
cQry += "  AND DT6_FILORI BETWEEN '" + _cFilialIni + "' AND '" + _cFilialFim + "' "
cQry += "  AND DT6_DATEMI BETWEEN '" + DTOS(_dDataIni) + "' AND '" + DTOS(_dDataFim) + "' "
cQry += "  AND DT6_DOC BETWEEN '" + _cCTRCIni + "' AND '" + _cCTRCFim + "' "
cQry += "  AND DT6_FILDOC = DT8_FILDOC "
cQry += "  AND DT6_CCUSTO BETWEEN '" + _cCCIni + "' AND '" + _cCCFim + "' "
cQry += "  AND DT6_DOC    = DT8_DOC    "
cQry += "  AND DT6_SERIE  = DT8_SERIE  "
cQry += "  AND DT8_CODPAS = DT3_CODPAS "
cQry += "  AND DT8.D_E_L_E_T_='' "
cQry += "  AND DT6_CLIREM + DT6_LOJREM = SA1R.A1_COD   + SA1R.A1_LOJA   "
cQry += "  AND DT6_CLIDES + DT6_LOJDES = SA1D.A1_COD   + SA1D.A1_LOJA   "
cQry += "  AND DT6_CLIDEV + DT6_LOJDEV = SA1DEV.A1_COD + SA1DEV.A1_LOJA "
cQry += "  AND DT6_SERVIC = X5_CHAVE AND X5_TABELA='L4' "
cQry += "  AND DT6_CDRORI = DUYO.DUY_GRPVEN "
cQry += "  AND DT6_CDRDES = DUYD.DUY_GRPVEN "
cQry += "  AND DT6_CDRCAL = DUYC.DUY_GRPVEN "
cQry += "  AND DT6_FILORI = DTC_FILORI "
cQry += "  AND DT6_LOTNFC = DTC_LOTNFC "
cQry += "  AND DT6_DOC    = DTC_DOC    "
cQry += "  AND DT6_SERIE  = DTC_SERIE  "
cQry += "  AND DTC.D_E_L_E_T_='' "
cQry += "  AND DT8.D_E_L_E_T_='' "  
cQry += "  AND DTL.D_E_L_E_T_='' "
cQry += "  AND DT3.D_E_L_E_T_='' "
cQry += "  AND SA1R.D_E_L_E_T_='' "
cQry += "  AND SA1D.D_E_L_E_T_='' "
cQry += "  AND SA1DEV.D_E_L_E_T_='' "
cQry += "  AND DUYD.D_E_L_E_T_='' "
cQry += "  AND DUYC.D_E_L_E_T_='' "
cQry += "  AND DUYO.D_E_L_E_T_='' "
cQry += "  AND SX5.D_E_L_E_T_=''  "
cQry += "GROUP BY DT6_FILORI, DT6_DATEMI, DT6_LOTNFC, DT6_DOC, DT6_SERIE, DTC_NUMNFC, DTC_VALOR, DTC_QTDVOL, DTC_PESO, DTC_PESOM3, DTC_METRO3, DT6_VALFRE, DT6_VALIMP, DT6_VALTOT, DT8_TABFRE, DT8_TIPTAB, "
cQry += "	DT6_CLIREM, DT6_LOJREM, SA1R.A1_CGC, SA1R.A1_NOME, DT6_CLIDES, DT6_LOJDES, SA1D.A1_CGC, SA1D.A1_NOME, DT6_DEVFRE, "
cQry += "       	DT6_CLIDEV, DT6_LOJDEV, SA1DEV.A1_NOME, DT6_CLICAL, DT6_LOJCAL, DT6_TIPFRE, DT6_SERTMS, DT6_TIPTRA, DT6_SERVIC, "
cQry += "       	X5_DESCRI, DT6_CDRORI, DUYO.DUY_DESCRI, DT6_CDRDES, DUYD.DUY_DESCRI, DT6_CDRCAL, DUYC.DUY_DESCRI, " 
cQry += "        DT6_CCUSTO, DT6_CCONT, DT6_OI, DT6_CONTA , DT6_TIPDES, DT6_REFGEF, DTC_SELORI, DTC_CODOBS "
cQry += "ORDER BY DT6_FILORI, DT6_LOTNFC, DT6_DATEMI, DT6_DOC "


//MEMOWRIT("D:\TEMP\QRYFATURA.TXT",cQry)

 TcQuery cQry Alias "TFAT" New
//TcQuery cQry Alias (cdbfFAT) New            
//DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),cdbfFAT,.T.,.T.)

TcSetField("TFAT" ,"DTC_QTDVOL" ,"N",09,0)	
TcSetField("TFAT" ,"DTC_PESO"   ,"N",15,5)
TcSetField("TFAT" ,"DTC_PESOM3" ,"N",15,3)
TcSetField("TFAT" ,"DTC_VALOR"  ,"N",15,2)
TcSetField("TFAT" ,"DT6_VALFRE" ,"N",15,2)
TcSetField("TFAT" ,"DTC_METRO3" ,"N",15,3)
TcSetField("TFAT" ,"DT6_VALIMP" ,"N",15,2)
TcSetField("TFAT" ,"DT6_VALPAS" ,"N",15,2)
TcSetField("TFAT" ,"DT6_VALTOT" ,"N",15,2)
TcSetField("TFAT" ,"DT8_VALPAS" ,"N",15,2)
TcSetField("TFAT" ,"DT8_VALIMP" ,"N",15,2)
TcSetField("TFAT" ,"DT8_VALTOT" ,"N",15,2)
TcSetField("TFAT" ,"DT6_VALMER" ,"N",15,2)
TcSetField("TFAT" ,"ZT0_PGRIS"  ,"N",15,2)
TcSetField("TFAT" ,"DTQ_BASADV" ,"N",15,2)
TcSetField("TFAT" ,"DTQ_VALADV" ,"N",15,2)
TcSetField("TFAT" ,"DTQ_VRPEDA" ,"N",15,2)
TcSetField("TFAT" ,"DTQ_VROUTR" ,"N",15,2)

/*
cQuery := ChangeQuery(cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TFAT', .T., .T.)
*/
dbSelectArea("TFAT") ; dbGoTop()

//dbSelectArea(cdbfFAT) ; dbGoTop()

COPY TO (cdbfFAT) VIA "DBFCDXADS"

dbSelectArea("TFAT") ; dbCloseArea()

dbUseArea(.T.,"DBFCDXADS", (cdbfFAT), "TRB", .T. , .F.)
dbSelectArea("TRB")
dbGoTop()

ProcRegua(RecCount())

INCLUI := .F.
While !Eof()
	IncProc()
	
    _cObs := ""
    _cSelOri := ""

	If AllTrim(TRB->DT6_LOTNFC) == "GPO"
		_cObs := GetAdvFVal('ZA7','ZA7_OBS',TRB->VIAGEM,3,"") // LEFT(TRB->DTC_CODOBS,80) 
	Else	
    	_cObs := E_MSMM(TRB->DTC_CODOBS,80)
    EndIf
    	
    _cSelOri := IIF(TRB->DTC_SELORI=="1","Transportadora",IIF(TRB->DTC_SELORI=="2","Cliente Remetente",IIF(TRB->DTC_SELORI=="2","Local Coleta","")))
		
	dbSelectArea("TRB") 
	RecLock("TRB",.f.)
		TRB->OBS := _cObs
		TRB->SELEC_ORIG := _cSelOri
   	MsunLock()

	dbSkip()
End

dbSelectArea("TRB") ; dbCloseArea()

ProcRegua(0)

//Formatando DBF para exportar para o excel
fExpExcel()

Return


/****************************************************************************
* Funcao....: C()                                                           *
* Autor.....: GAIA 1.0                                                      *
* Data......: 13/04/2007                                                    *
* Descricao.: Configura o tamanho da tela de acordo com o tamanho e tema    *
*                                                                           *
****************************************************************************/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³Tratamento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)


/****************************************************************************
* Funcao....: fExpExcel()                                                   *
* Autor.....: J Ricardo de Oliveira Guimarães                               *
* Data......: 20/08/2008                                                    *
* Descricao.: Faz as ultimas atualizacoes e abre o DBF no excel             *
*                                                                           *
****************************************************************************/
Static Function fExpExcel()

//Use &cDbfSZO Alias cDbfSZO New

//dbSelectArea("TFAT")
//dbGoTop()

ProcRegua(0)
//Copiando arquivo para abrir no excel
cPath:=alltrim(cPath)
cArquivo:=alltrim(cArquivo)   

If CpyS2T((cDBFFat)+".DBF", cPath,.F.)
	If File(cPath+cArquivo+".dbf")
		fErase(cPath+cArquivo+".dbf")
	EndIf
	
	If FRENAME(cPath+cDbfFAT+".dbf", cPath+cArquivo+".dbf") == -1
		MsgAlert("Não foi possível gerar arquivo como o nome solicitado: "+cPath+cArquivo+".dbf","Atenção!")
		cArquivo:=cDbfFAT		
	EndIf

	//Abrindo arquivo no Excel
	If ! ApOleClient( 'MsExcel' ) 
		MsgStop( "MsExcel não encontrado!" ) //'MsExcel nao instalado'
    Else
		oXls:= MsExcel():New()
		oXls:WorkBooks:Open(cPath+cArquivo+".dbf")
		oXls:SetVisible(.T.)
		oXls:Destroy()
	EndIf
Else
	MsgAlert("Nao foi possível gerar arquivo com o nome solicitado!","Erro!")
EndIf

//dbSelectArea("TFAT")
If FILE(cDbfFat+".DBF")     //Elimina o arquivo de trabalho
    // dbCloseArea()
    Ferase(cDbfFAT+".DBF")
//    Ferase("cInd1"+OrdBagExt())
EndIf

Return

/****************************************************************************
* Funcao....: fvldOk()                                                      *
* Autor.....: J Ricardo de Oliveira Guimarães                               *
* Data......: 27/05/2010                                                    *
* Descricao.: Verifica se o arquivo dbf existe.                             *
*                                                                           *
****************************************************************************/
Static Function fvldOk()
Local lRet:=.f.
Local cArq:=alltrim(cPath)+alltrim(carquivo)+".dbf"

If !lIsDir(alltrim(cPath))
	ApMsgAlert("Diretório inválido!","Atenção")
EndIf

For nX:=1 to len(alltrim(carquivo))
	If substr(cArquivo,nX,1) $ ("\/:*?<>"+char(34)) // char(34) = "
		ApMsgAlert("Nome de arquivo inválido!"+char(10)+"Não pode conter:"+char(10)+"  \ / : * ? < > "+char(34),"Atenção")
		return .f.
	EndIf
Next nX

If File(cArq)
	lRet:=ApMsgYesNo("Deseja sobreescrever o arquivo?")
Else
	lRet:=.t.
EndIf

If Empty(alltrim(cPath)) .or. Empty(alltrim(cArquivo))
	ApMsgAlert("Diretório/Arquivo em branco!","Atenção")
	lRet:=.f.
EndIf

If _dDataFim < _dDataIni 
	ApMsgAlert("Data Final informado é menor que a Data Inicial!","Atenção")
	lRet:=.f.
EndIf

If _cCTRCFim < _cCTRCIni
	ApMsgAlert("CTRC final informado é menor que o CTRC inicial!","Atenção")
	lRet:=.f.
EndIf

If _cFilialFim < _cFilialIni
	ApMsgAlert("Filial final informada é menor que a Filial inicial!","Atenção")
	lRet:=.f.
EndIf

Return lRet

