#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"    
#INCLUDE "TOPCONN.CH"
/************************************************************************
* Programa........: GEFINR11                                           *
* Autor...........: J Ricardo de O Guimarães                            *
* Data............: 20/08/2008                                          *
* Descricao.......: Relatório de Faturamento em Excel dos títulos       *
*                   importados dos sistemas ADHOC/SIPCO                 *
*                                                                       *
*************************************************************************
* Modificado por..:                                                     *
* Data............:                                                     *
* Motivo..........:                                                     *
*                                                                       *
************************************************************************/
User Function GEFINR11()
Local 	nOpcao	:=	0
Private aEst	:=	{}
Private aFilCC	:=	{}
Private oDlgVnd	:= 	nil
Private cPath	:=	space(255)
Private cArquivo:=	space(255)
Private cMes	:=	StrZero(Month(dDataBase),2)
Private cAno    :=	strZero(Year(dDataBase),4)

cArquivo := "FATURA"

SetKey (VK_F3,{|a,b| cPath:=cGetFile( "DBF(*.dbf) | *.dbf ",OemToAnsi("Salvar em..."),,"d:",.f.,GETF_LOCALHARD+GETF_RETDIRECTORY)})
// @ 200,1 TO 422,420 DIALOG oDlgVnd TITLE OemToAnsi("Relatorio de Faturamento dos títulos importados do SIPCO/ADHOC.")
@ 200,1 TO 472,420 DIALOG oDlgVnd TITLE OemToAnsi("Relatorio de Faturamento dos títulos importados do SIPCO/ADHOC.")
//@ 02,10 TO 120,190
@ 02,10 TO 100,190
@ 10,018 Say " Este programa ira gerar arquivo de Faturamento p/ ser lido em Excel. "
@ 18,018 Say " Defina abaixo os parâmetros do relatório"
@ 26,018 Say "                                                            "
@ 34,018 Say "Diretorio:"
@ 32,050 Get cPath Picture "@!" Size 60,20
@ 32,110 BUTTON "..." SIZE 10,10 ACTION (cPath:=cGetFile( "DBF(*.dbf) | *.dbf ",OemToAnsi("Salvar em..."),,"d:",.f.,GETF_LOCALHARD+GETF_RETDIRECTORY))
@ 50,018 Say "Arquivo:"
@ 48,050 Get cArquivo Picture "@!" Size 60,20
@ 66,018 Say "Mês    : "
@ 64,050 Get cMes
@ 82,018 Say "Ano    : "
@ 80,050 Get cAno
/*
@ 96,018 Say "Pedido de: "
@ 94,050 Get cPedidoDe Picture "999999"
@ 110,018 Say "Pedido Ate: "
@ 112,050 Get cPedidoAte Picture "999999"
*/
@ 116,128 BMPBUTTON TYPE 01 ACTION (nOpcao:=1,iif(fvldOk(),Close(oDlgVnd),))
@ 116,158 BMPBUTTON TYPE 02 ACTION (nOpcao:=2,Close(oDlgVnd))

Activate Dialog oDlgVnd Centered
SetKey (VK_F3,{||})

If nOpcao == 1
	Processa({|| RunExport() },"Processando...")
EndIf

Return

/*************************************************************************
* Funcao....: RUNReport()                                                *
* Autor.....: J Ricardo de O Guimarães                                   *
* Data......: 20/08/2008                                                 *
* Descricao.: Funcao responsável pela busca de informacoes na tabela SZR *
*             e geracao de arquivo dbf.                                  *
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
cMes    := StrZero(Val(cMes),2)

//Buscando informacoes processadas 
cQry := "SELECT A.ZR_FILIAL AS FILIAL, A.ANO_MES, ISNULL(A.VALOR_IMP,0) AS VR_IMPORT, ISNULL(B.IMP_ADHOC,0) AS IMP_ADHOC, "
cQry += "	ISNULL(C.IMP_SIPCO,0) AS IMP_SIPCO, ISNULL(D.INT_ADHOC,0) AS INT_ADHOC, "
cQry += "	ISNULL(E.INT_SIPCO,0) AS INT_SIPCO, ISNULL(F.N_INT_ADHO,0) AS N_INT_ADHO, "
cQry += "	ISNULL(G.N_INT_SIPC,0) AS N_INT_SIPC "
cQry += "FROM "
cQry += "( "
// Total importado para a tabela intermediária
cQry += " SELECT ZR_FILIAL, SUBSTRING(ZR_XDATA,1,6) AS ANO_MES, SUM(ROUND(ZR_VLCONT,2)) AS VALOR_IMP "
cQry += "	FROM SZR010 SZR, SZS010 SZS "
cQry += "	WHERE SUBSTRING(ZR_XDATA,1,6) = '" + cAno+cMes + "' "
cQry += "	  AND SZR.D_E_L_E_T_='' "
cQry += "	  AND ZR_FILIAL = ZS_FILIAL "
//cQry += "	  AND ZS_ATIVO = 'S' "
cQry += "	  AND SZS.D_E_L_E_T_='' "
cQry += " GROUP BY ZR_FILIAL, SUBSTRING(ZR_XDATA,1,6) ) A "

cQry += " LEFT JOIN "

cQry += "( "
// Total importado do ADHOC
cQry += " SELECT ZR_FILIAL, SUBSTRING(ZR_XDATA,1,6) AS ANO_MES, SUM(ROUND(ZR_VLCONT,2)) AS IMP_ADHOC "
cQry += "	FROM SZR010 SZR, SZS010 SZS "
cQry += "	WHERE SUBSTRING(ZR_XDATA,1,6)  = '" + cAno+cMes + "' "
cQry += "	  AND SZR.D_E_L_E_T_='' "
cQry += "	  AND ZR_FILIAL = ZS_FILIAL "
//cQry += "	  AND ZS_ATIVO = 'S' "
cQry += "	  AND SZS.D_E_L_E_T_='' "
cQry += "	  AND ZR_SISORIG = 'ADHOC' "
cQry += " GROUP BY ZR_FILIAL, SUBSTRING(ZR_XDATA,1,6) ) B ON A.ZR_FILIAL = B.ZR_FILIAL "

cQry += " LEFT JOIN "

cQry += "( "
// Total importado do SIPCO
cQry += "SELECT ZR_FILIAL, SUBSTRING(ZR_XDATA,1,6) AS ANO_MES, SUM(ROUND(ZR_VLCONT,2)) AS IMP_SIPCO "
cQry += "	FROM SZR010 SZR, SZS010 SZS "
cQry += "	WHERE SUBSTRING(ZR_XDATA,1,6) = '" + cAno+cMes + "' "
cQry += "	  AND SZR.D_E_L_E_T_='' "
cQry += "	  AND ZR_FILIAL = ZS_FILIAL "
//cQry += "	  AND ZS_ATIVO = 'S' "
cQry += "	  AND SZS.D_E_L_E_T_='' "
cQry += "	  AND ZR_SISORIG = 'SIPCO' "
cQry += " GROUP BY ZR_FILIAL, SUBSTRING(ZR_XDATA,1,6) ) C ON A.ZR_FILIAL = C.ZR_FILIAL "

cQry += " LEFT JOIN "

cQry += "( "
// Total de títulos sem errata e já integrado ao Financeiro(ADHOC)
cQry += "SELECT ZR_FILIAL, SUBSTRING(ZR_XDATA,1,6) AS ANO_MES, SUM(ROUND(ZR_VLCONT,2)) AS INT_ADHOC "
cQry += "	FROM SZR010 SZR, SZS010 SZS "
cQry += "	WHERE SUBSTRING(ZR_XDATA,1,6)  = '" + cAno+cMes + "' "
cQry += "	  AND ZR_IMPORT='S' "
cQry += "	  AND SZR.D_E_L_E_T_='' "
cQry += "	  AND ZR_FILIAL = ZS_FILIAL "
cQry += "	  AND ZR_SISORIG = 'ADHOC' "
//cQry += "	  AND ZS_ATIVO = 'S' "
cQry += "	  AND SZS.D_E_L_E_T_='' "
cQry += " GROUP BY ZR_FILIAL, SUBSTRING(ZR_XDATA,1,6) ) D ON A.ZR_FILIAL = D.ZR_FILIAL "

cQry += " LEFT JOIN "

cQry += " ( "
// Total de títulos sem errata e já integrado ao Financeiro(SIPCO)
cQry += " SELECT ZR_FILIAL, SUBSTRING(ZR_XDATA,1,6) AS ANO_MES, SUM(ROUND(ZR_VLCONT,2)) AS INT_SIPCO "
cQry += "	FROM SZR010 SZR, SZS010 SZS "
cQry += "	WHERE SUBSTRING(ZR_XDATA,1,6) = '" + cAno+cMes + "' "
cQry += "	  AND ZR_IMPORT='S' "
cQry += "	  AND SZR.D_E_L_E_T_='' "
cQry += "	  AND ZR_FILIAL = ZS_FILIAL "
cQry += "	  AND ZR_SISORIG = 'SIPCO' "
//cQry += "	  AND ZS_ATIVO = 'S' "
cQry += "	  AND SZS.D_E_L_E_T_='' "
cQry += " GROUP BY ZR_FILIAL, SUBSTRING(ZR_XDATA,1,6)) E ON A.ZR_FILIAL = E.ZR_FILIAL "

cQry += " LEFT JOIN "

cQry += "( "
// Total de títulos com errata do ADHOC
cQry += " SELECT ZR_FILIAL, SUBSTRING(ZR_XDATA,1,6) AS ANO_MES, SUM(ROUND(ZR_VLCONT,2)) AS N_INT_ADHO "
cQry += "	FROM SZR010 SZR, SZS010 SZS "
cQry += "	WHERE SUBSTRING(ZR_XDATA,1,6) = '" + cAno+cMes + "' "
cQry += "	  AND ZR_IMPORT<>'S' "
cQry += "	  AND SZR.D_E_L_E_T_='' "
cQry += "	  AND ZR_FILIAL = ZS_FILIAL "
cQry += "	  AND ZR_SISORIG = 'ADHOC' "
//cQry += "	  AND ZS_ATIVO = 'S' "
cQry += "	  AND SZS.D_E_L_E_T_='' "
cQry += " GROUP BY ZR_FILIAL, SUBSTRING(ZR_XDATA,1,6) ) F ON A.ZR_FILIAL = F.ZR_FILIAL "

cQry += " LEFT JOIN "

cQry += "( "
// Total de títulos com errata do SIPCO
cQry += " SELECT ZR_FILIAL, SUBSTRING(ZR_XDATA,1,6) AS ANO_MES, SUM(ROUND(ZR_VLCONT,2)) AS N_INT_SIPC "
cQry += "	FROM SZR010 SZR, SZS010 SZS "
cQry += "	WHERE SUBSTRING(ZR_XDATA,1,6) = '" + cAno+cMes + "' "
cQry += "	  AND ZR_IMPORT<>'S' "
cQry += "	  AND SZR.D_E_L_E_T_='' "
cQry += "	  AND ZR_FILIAL = ZS_FILIAL "
cQry += "	  AND ZR_SISORIG = 'SIPCO' "
//cQry += "	  AND ZS_ATIVO = 'S' "
cQry += "	  AND SZS.D_E_L_E_T_='' "
cQry += " GROUP BY ZR_FILIAL, SUBSTRING(ZR_XDATA,1,6) ) G ON A.ZR_FILIAL = G.ZR_FILIAL "

//MEMOWRIT("D:\TEMP\QRYFATURA.TXT",cQry)

TcQuery cQry Alias "TFAT" New

TcSetField("TFAT" ,"VR_IMPORT","N",15,2)	
TcSetField("TFAT" ,"IMP_ADHOC","N",15,2)
TcSetField("TFAT" ,"IMP_SIPCO","N",15,2)
TcSetField("TFAT" ,"INT_ADHOC","N",15,2)
TcSetField("TFAT" ,"INT_SIPCO","N",15,2)
TcSetField("TFAT" ,"N_INT_ADHO","N",15,2)
TcSetField("TFAT" ,"N_INT_SIPC","N",15,2)


/*
cQuery := ChangeQuery(cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TFAT', .T., .T.)
*/
dbSelectArea("TFAT") ; dbGoTop()

COPY TO (cdbfFAT)

ProcRegua(RecCount())

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

dbSelectArea("TFAT")
dbGoTop()

ProcRegua(0)
//Copiando arquivo para abrir no excel
cPath:=alltrim(cPath)
cArquivo:=alltrim(cArquivo)

If CpyS2T(cDBFFat+".DBF", cPath,.f.)
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

dbSelectArea("TFAT")
If FILE(cDbfFat+".DBF")     //Elimina o arquivo de trabalho
    dbCloseArea()
    Ferase(cDbfFAT+".DBF")
//    Ferase("cInd1"+OrdBagExt())
EndIf

Return

/****************************************************************************
* Funcao....: fvldOk()                                                      *
* Autor.....: J Ricardo de Oliveira Guimarães                               *
* Data......: 20/08/2008                                                    *
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

If Empty(cMes) 
	ApMsgAlert("Mês não informado!","Atenção")
	lRet:=.f.
EndIf

If Empty(cAno)
	ApMsgAlert("Ano não informado!","Atenção")
	lRet:=.f.
EndIf

Return lRet

