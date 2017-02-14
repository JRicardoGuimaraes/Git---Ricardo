#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"    
#INCLUDE "TOPCONN.CH"
/************************************************************************
* Programa........: GEFR20                                              *
* Autor...........: J Ricardo de O Guimarães                            *
* Data............: 27/05/2010                                          *
* Descricao.......: Relatório de CTRC´S Emitidios pelo TMS, em Excel    *
*                                                                       *
*************************************************************************
* Modificado por..:                                                     *
* Data............:                                                     *
* Motivo..........:                                                     *
*                                                                       *
************************************************************************/
User Function GEFR20()
Local 	nOpcao	 :=	0
Private oDlgVnd	 := 	nil
Private cPath	 :=	space(255)
Private cArquivo :=	space(255)
Private _dDataIni:=	ctod("//")
Private _dDataFim:=	ctod("//")
Private _cCTRCIni:=	Space(TAMSX3("DTC_DOC")[1])
Private _cCTRCFim:=	Space(TAMSX3("DTC_DOC")[1])
Private _cFilial :=	Space(TAMSX3("DTC_FILORI")[1])

cArquivo := "CTRCs"

SetKey (VK_F3,{|a,b| cPath:=cGetFile( "DBF(*.dbf) | *.dbf ",OemToAnsi("Salvar em..."),,"U:",.f.,GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_LOCALFLOPPY)})

// @ 200,1 TO 472,420 DIALOG oDlgVnd TITLE OemToAnsi("Relatorio de CTRCs Emitidos pelo TMS.")
@ 200,1 TO 600,420 DIALOG oDlgVnd TITLE OemToAnsi("Relatorio de CTRCs Emitidos pelo TMS.")
//@ 02,10 TO 120,190
@ 02,10 TO 150,190
@ 10,018 Say " Este programa ira gerar arquivo de CTRCs emitidos p/ ser lido em Excel. "
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
@ 98,018 Say "CTRC Inicial : "
@ 100,050 Get _cCTRCIni 
@ 116,018 Say "CTRC Final   : "
@ 118,050 Get _cCTRCFim 
@ 132,018 Say "Filial : "
@ 134,050 Get _cFilial

@ 160,128 BMPBUTTON TYPE 01 ACTION (nOpcao:=1,iif(fvldOk(),Close(oDlgVnd),))
@ 160,158 BMPBUTTON TYPE 02 ACTION (nOpcao:=2,Close(oDlgVnd))

Activate Dialog oDlgVnd Centered
SetKey (VK_F3,{||})

If nOpcao == 1
	Processa({|| RunExport() },"Processando...")
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
Local cTipo		:=	""

Private cdbfFAT	:=	""
Private cInd1	:=	""

cdbfFAT	:=	criatrab("",.F.)

//Buscando informacoes processadas 
// cQry := " EXEC SP_LISTA_CTRC '" + DTOS(_dDataIni) + "', '" + DTOS(_dDataFim) + "', '" + _cCTRCIni + "', '" + _cCTRCFim + "', '" + cFilAnt + "', 'C'"
cQry := "SELECT DTC_FILORI, DTC_LOTNFC, DTC_DATENT, DTC_DOC   , DTC_SERIE ,DTC_NUMNFC, DTC_SERNFC, DTC_EMINFC, DTC_QTDVOL, DTC_PESO,   DTC_PESOM3, DTC_VALOR, "
cQry += "	DTC_METRO3, DTC_QTDUNI, DTC_CLIREM, DTC_LOJREM, SA1R.A1_CGC AS REM_CNPJ, SA1R.A1_NOME AS REMETENTE, DTC_CLIDES, DTC_LOJDES, SA1D.A1_CGC AS DES_CNPJ, SA1D.A1_NOME AS DESTINAT, "
cQry += "  	DEV_FRETE = CASE "
cQry += "                  WHEN DTC_DEVFRE = '1' THEN 'Remetente'    "
cQry += "                  WHEN DTC_DEVFRE = '2' THEN 'Destinatario' "
cQry += "                  WHEN DTC_DEVFRE = '3' THEN 'Consignatario'"
cQry += "	       WHEN DTC_DEVFRE = '4' THEN 'Despachante'  		 "
cQry += "		       ELSE 'N/DEFINIDO' "
cQry += "          END, "
cQry += "  DTC_CLIDEV, DTC_LOJDEV, DTC_CLICAL, DTC_LOJCAL, DTC_TIPFRE, DTC_SERTMS, DTC_TIPTRA, DTC_SERVIC, "
cQry += "  X5_DESCRI AS SERVICO  , SEL_ORIGEM = CASE "
cQry += "                  				WHEN DTC_SELORI = '1' THEN 'Transportadora'   "
cQry += "                  				WHEN DTC_SELORI = '2' THEN 'Cliente Remetente'"
cQry += "                  				WHEN DTC_SELORI = '3' THEN 'Local de Coleta'  "
cQry += "			       				ELSE 'N/DEFINIDO' "
cQry += "              			      END, "
cQry += "  DTC_CDRORI, DUYO.DUY_DESCRI AS REG_ORIGEM, DTC_CDRDES, DUYD.DUY_DESCRI AS REG_DEST, "
cQry += "  DTC_CDRCAL, DUYC.DUY_DESCRI AS REG_CALC  , DTC_FILDOC,                                "
cQry += "  DTC_VLRINF, DTC_CCUSTO, DTC_CCONT, DTC_OI, DTC_CONTA , DTC_TIPDES, DTC_REFGEF, "
cQry += "  ISNULL(DT3_DESCRI,'') AS DT3_DESCRI, DT8_VALPAS, DT8_VALIMP, DT8_VALTOT, DT8_TABFRE, DT8_TIPTAB, ISNULL(DTL_DESCR,'') AS DTL_DESCR, DT8_CODPAS, DTC.DTC_CODOBS, SPACE(100) AS OBS "
cQry += "	 FROM  ((" + RetSqlName("DT8") + " DT8 LEFT JOIN " + RetSqlName("DT3") + " DT3 ON DT8_CODPAS = DT3_CODPAS) LEFT JOIN DTL010 DTL ON DT8_TABFRE = DTL_TABFRE AND DT8_TIPTAB = DTL_TIPTAB), "
cQry += 		 RetSqlName("DTC") + " DTC, "  + RetSqlName("SA1") + " SA1R, " + RetSqlName("SA1") + " SA1D, " + RetSqlName("SX5") + " SX5, "
cQry += 		 RetSqlName("DUY") + " DUYO, " + RetSqlName("DUY") + " DUYD, " + RetSqlName("DUY") + " DUYC " 
cQry += "	WHERE DTC.D_E_L_E_T_='' "
cQry += "	  AND DTC_FILORI = '" + _cFilial + "' "
cQry += "	  AND DTC_DATENT BETWEEN '" + DTOS(_dDataIni) + "' AND '" + DTOS(_dDataFim) + "' "
cQry += "	  AND DTC_DOC BETWEEN '" + _cCTRCIni + "' AND '" + _cCTRCFim + "' "
cQry += "	  AND DTC_CLIREM + DTC_LOJREM = SA1R.A1_COD + SA1R.A1_LOJA "
cQry += "	  AND DTC_CLIDES + DTC_LOJDES = SA1D.A1_COD + SA1D.A1_LOJA "
cQry += "	  AND DTC_SERVIC = X5_CHAVE AND X5_TABELA='L4' "
cQry += "	  AND DTC_CDRORI = DUYO.DUY_GRPVEN  "
cQry += "	  AND DTC_CDRDES = DUYD.DUY_GRPVEN  "
cQry += "	  AND DTC_CDRCAL = DUYC.DUY_GRPVEN  "
cQry += "	  AND DTC_FILDOC = DT8_FILDOC       "
cQry += "	  AND DTC_DOC    = DT8_DOC          "
cQry += "	  AND DTC_SERIE  = DT8_SERIE 		"
cQry += "	  AND DTC_DOC    <> '' 				"
cQry += "	ORDER BY DTC_LOTNFC, DTC_DOC, DTC_SERIE, DTC_NUMNFC, DTC_SERNFC, DT8_CODPAS "  

//MEMOWRIT("D:\TEMP\QRYFATURA.TXT",cQry)

 TcQuery cQry Alias "TFAT" New
//TcQuery cQry Alias (cdbfFAT) New            
//DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),cdbfFAT,.T.,.T.)

TcSetField("TFAT" ,"DTC_QTDVOL" ,"N",09,0)	
TcSetField("TFAT" ,"DTC_PESO"   ,"N",15,5)
TcSetField("TFAT" ,"DTC_PESOM3" ,"N",09,3)
TcSetField("TFAT" ,"DTC_VALOR"  ,"N",15,2)
TcSetField("TFAT" ,"DTC_METRO3" ,"N",09,3)
TcSetField("TFAT" ,"DTC_QTDUNI" ,"N",09,2)
TcSetField("TFAT" ,"DT8_VALPAS" ,"N",15,2)
TcSetField("TFAT" ,"DT8_VALIMP" ,"N",15,2)
TcSetField("TFAT" ,"DT8_VALTOT" ,"N",15,2)

/*
TcSetField((cdbfFAT),"DTC_QTDVOL" ,"N",09,0)	
TcSetField((cdbfFAT),"DTC_PESO"   ,"N",15,5)
TcSetField((cdbfFAT),"DTC_PESOM3" ,"N",09,3)
TcSetField((cdbfFAT),"DTC_VALOR"  ,"N",15,2)
TcSetField((cdbfFAT),"DTC_METRO3" ,"N",09,3)
TcSetField((cdbfFAT),"DTC_QTDUNI" ,"N",09,2)
TcSetField((cdbfFAT),"DT8_VALPAS" ,"N",15,2)
TcSetField((cdbfFAT),"DT8_VALIMP" ,"N",15,2)
TcSetField((cdbfFAT),"DT8_VALTOT" ,"N",15,2)
TcSetField((cdbfFAT),"DT8_VALIMP" ,"N",15,2)
*/

/*
cQuery := ChangeQuery(cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TFAT', .T., .T.)
*/
dbSelectArea("TFAT") ; dbGoTop()

//dbSelectArea(cdbfFAT) ; dbGoTop()

COPY TO (cdbfFAT) VIA "DBFCDXADS"

dbSelectArea("TFAT") ; dbCloseArea()

dbUseArea(.T.,, (cdbfFAT), "TRB", .T. , .F.)
dbSelectArea("TRB")
dbGoTop()

INCLUI := .F.
While !Eof()
	RecLock("TRB",.f.)
		TRB->OBS := E_MSMM(TRB->DTC_CODOBS,80)
    MsunLock()

	dbSelectArea("TRB") 
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
If CpyS2T((cDBFFat)+".DBF", cPath,.f.)
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

If Empty(_cFilial)
	ApMsgAlert("Filial não informada!","Atenção")
	lRet:=.f.
EndIf

Return lRet

