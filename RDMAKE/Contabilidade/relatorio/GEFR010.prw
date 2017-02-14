#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"    
#INCLUDE "TOPCONN.CH"
/************************************************************************
* Programa........: GEFR010                                             *
* Autor...........: Marcelo Aguiar Pimentel                             *
* Data............: 13/04/2007                                          *
* Descricao.......: Relatorio de Vendas MCO POR FILIAL X METIER         *
*                                                                       *
*************************************************************************
* Modificado por..:                                                     *
* Data............:                                                     *
* Motivo..........:                                                     *
*                                                                       *
************************************************************************/
User Function GEFR010()
Local 	nOpcao	:=	0
Local   cLstUO	:= 	""
Private aEst	:=	{}
Private aFilCC	:=	{}
Private oDlgVnd	:= 	nil
Private cPath	:=	space(255)
Private cArquivo:=	space(255)
Private dDataDe	:=	dDataBase
Private dDataAte:=	dDataBase
Private aCmbBx1	 := {}//{"RDVM","RMLAP","ILI","RMA","TODOS"}
Private cCmbBx1	 := "TODOS"

//Buscando Codigo das UO´s
cQry:="SELECT X5_CHAVE "
cQry+="  FROM "+RetSqlName("SX5")
cQry+=" WHERE X5_FILIAL = '"+xFilial("SX5")+"'"
cQry+="   AND X5_TABELA = 'Z4'"
cQry+="   AND D_E_L_E_T_ <> '*'"
TcQuery cQry Alias "TSX5" New
While !Eof()
	cLstUO+="'"+alltrim(TSX5->X5_CHAVE)+"'"
	dbSkip()
	If !Eof()
		cLstUO+=","
	EndIf
EndDo
dbCloseArea()

//Buscando a descricao da UO nesta tabela pq no processamneto das vendas a descricao da UO salva na tabela SZO
//vem da tabela SZ1.
cQry:="SELECT Z1_DESCR "
cQry+="  FROM "+RetSqlName("SZ1")
cQry+=" WHERE Z1_COD IN ("+cLstUO+")"//'102','103','104','105','109','110')"
cQry+="   AND D_E_L_E_T_ <> '*'"
TcQuery cQry Alias "TSZ1" New
While !Eof()
	aAdd(aCmbBx1,allTrim(TSZ1->Z1_DESCR))
	dbSkip()
EndDo
aAdd(aCmbBx1,"TODOS")
dbCloseArea()

SetKey (VK_F3,{|a,b| cPath:=cGetFile( "DBF(*.dbf) | *.dbf ",OemToAnsi("Salvar em..."),,"d:",.f.,GETF_LOCALHARD+GETF_RETDIRECTORY)})
@ 200,1 TO 452,390 DIALOG oDlgVnd TITLE OemToAnsi("Relatorio de Vendas MCO por Filial X Metier")
@ 02,10 TO 109,190 //95
@ 10,018 Say " Este programa ira importar dados do processamento de Vendas MCO"
@ 18,018 Say " por FILIAL X METIER"
@ 26,018 Say "                                                            "
@ 34,018 Say "Diretorio:"
@ 32,050 Get cPath Picture "@!" Size 60,20
@ 32,110 BUTTON "..." SIZE 10,10 ACTION (cPath:=cGetFile( "DBF(*.dbf) | *.dbf ",OemToAnsi("Salvar em..."),,"d:",.f.,GETF_LOCALHARD+GETF_RETDIRECTORY))
@ 50,018 Say "Arquivo:"
@ 48,050 Get cArquivo Picture "@!" Size 60,20
@ 66,018 Say "Data de: "
@ 64,050 Get dDataDe
@ 82,018 Say "Data Ate: "
@ 80,050 Get dDataAte
@ 98,018 Say "U.O.: "
@ 96,050 ComboBox cCmbBx1 Items aCmbBx1 Size C(072),C(010)

@ 108,128 BMPBUTTON TYPE 01 ACTION (nOpcao:=1,iif(fvldOk(),Close(oDlgVnd),))
@ 108,158 BMPBUTTON TYPE 02 ACTION (nOpcao:=2,Close(oDlgVnd))

Activate Dialog oDlgVnd Centered
SetKey (VK_F3,{||})

If nOpcao == 1
	Processa({|| RunExport() },"Processando...")
EndIf
Return

/*************************************************************************
* Funcao....: RUNExport()                                                *
* Autor.....: Marcelo Aguiar Pimentel                                    *
* Data......: 13/04/2007                                                 *
* Descricao.: Funcao responsável pela busca de informacoes na tabela SZO *
*             e geracao de arquivo dbf.                                  *
*                                                                        *
*************************************************************************/
Static Function RunExport()
Local cQry		:=	""
Local aTamSld	:=	{}
Local aTamFil	:=	{}
Private cDbfSZO	:=	""
Private cInd1	:=	""

//Buscando filiais para cricao do arquivo
cQry:="SELECT ZQ_FILCC,ZQ_DESCRIC"
cQry+="  FROM "+RetSqlName("SZQ")
cQry+=" WHERE D_E_L_E_T_ <> '*'"
TcQuery cQry Alias "TSZQ" New
aFilCC:={}
While !Eof()
	aAdd(aFilCC,{allTrim(TSZQ->ZQ_FILCC),allTrim(TSZQ->ZQ_DESCRIC)})
	dbSelectArea("TSZQ")
	dbSkip()
EndDo
dbCloseArea()

dbSelectArea("SZO")
aTamSld := TamSX3("ZO_SALDO")
aTamFil := TamSX3("ZO_FILCC")

//Criando estrutura do arquivo DBF
aEst:={}
aAdd(aEst, { "FILIAL"    , "C",aTamFil[1] ,         0 } )
aAdd(aEst, { "DESCRICAO" , "C",     35    ,         0 } )

//Buscando Metier processados para montar a estrutura do DBF
cQry:="SELECT DISTINCT ZO_METIER"
cQry+="  FROM "+RetSqlName("SZO")
cQry+=" WHERE ZO_FILIAL = '"+xFilial("SZO")+"'"
cQry+="   AND ZO_DATA BETWEEN '"+dtos(dDataDe)+"' AND '"+dtos(dDataAte)+"'"
If ALLTRIM(cCmbBx1) != "TODOS"
	cQry+="  AND ZO_UO = '"+cCmbBx1+"'"
EndIf
cQry+="   AND D_E_L_E_T_ <> '*'"
cQry+="   ORDER BY ZO_METIER"
TcQuery cQry Alias "TSZO" New
	While !Eof()
		aAdd(aEst, { allTrim(TSZO->ZO_METIER)  , "N",aTamSld[1] ,aTamSld[2] } )
		dbSelectArea("TSZO")
		dbSkip()
	EndDo
dbCloseArea("TSZO")
aAdd(aEst, { "TOTAL"      , "N",aTamSld[1] ,aTamSld[2] } )
If len(aEst) <=2
	ApMsgAlert("Não há dados processados!")
	return
EndIf
cdbfSZO	:=	criatrab(aEst)
Use &cDbfSZO Alias cDbfSZO New
cInd1	:= CriaTrab("",.F.)
IndRegua("cDbfSZO",cInd1,"FILIAL+DESCRICAO",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
dbSetIndex( cInd1 +OrdBagExt())

//Criando estrutura de dados no DBF
fModelarDbf()

//Buscando Informacoes processadas
cQry:="SELECT ZO_FILCC,ZO_CONTA,ZO_METIER,ZO_DESCR,SUM(ZO_SALDO) AS ZO_SALDO"
cQry+="  FROM "+RetSqlName("SZO")
cQry+=" WHERE ZO_FILIAL = '"+xFilial("SZO")+"'"
cQry+="   AND ZO_DATA BETWEEN '"+dtos(dDataDe)+"' AND '"+dtos(dDataAte)+"'"
cQry+="   AND ZO_CONTA IN ('A01C','A01B','A01A','B01','B03','B04','B07')"
If ALLTRIM(cCmbBx1) != "TODOS"
	cQry+="  AND ZO_UO = '"+cCmbBx1+"'"
EndIf
cQry+="   AND D_E_L_E_T_ <> '*'"
cQry+=" GROUP BY ZO_FILCC,ZO_CONTA,ZO_METIER,ZO_DESCR"
cQry+=" ORDER BY ZO_FILCC,ZO_CONTA,ZO_METIER"
TcQuery cQry Alias "TSZO" New
ProcRegua(RecCount())
While !EOF()
	IncProc()
	dbSelectArea("cDbfSZO")
	If dbSeek(TSZO->ZO_FILCC+TSZO->ZO_CONTA)
		cCampo:=alltrim(TSZO->ZO_METIER)
		RecLock("cDbfSZO",.f.)
			cDbfSZO->&cCampo +=TSZO->ZO_SALDO
		MsUnLock()
	EndIf	
	dbSelectArea("TSZO")
	dbSkip()
EndDo

dbSelectArea("TSZO")
dbCloseArea()

//Calculando totais
fGeraTotal()

//Formatando DBF para exportar para o excel
fExpExcel()
Return

/****************************************************************************
* Funcao....: fModelarDbf()                                                 *
* Autor.....: Marcelo Aguiar Pimentel                                       *
* Data......: 13/04/2007                                                    *
* Descricao.: Gera arquivo DBF com a estrutura e dados iniciais do arquivo  *
*                                                                           *
****************************************************************************/
Static Function fModelarDbf()

For nX:=1 to len(aFilCC)
	fNewLine(aFilCC[nX,1],aFilCC[nX,2])
	fNewLine(aFilCC[nX,1],"A01C")
	fNewLine(aFilCC[nX,1],"A01B")
	fNewLine(aFilCC[nX,1],"A01A")
	fNewLine(aFilCC[nX,1],"Total das vendas")
	fNewLine("","")   // Inclui linha em branco
	fNewLine(aFilCC[nX,1],"B01")
	fNewLine(aFilCC[nX,1],"B03")
	fNewLine(aFilCC[nX,1],"B04")
	fNewLine(aFilCC[nX,1],"B07")
	fNewLine(aFilCC[nX,1],"Total da compras")
	fNewLine("","")   // Inclui linha em branco
	fNewLine(aFilCC[nX,1],"Margem comercial")
	fNewLine(aFilCC[nX,1],"% sobre as vendas")
	fNewLine("","")   // Inclui linha em branco
Next nX

Return

Static Function fNewLine(pFILCC,pDescri)
	RecLock("cDbfSZO",.t.)
		If !Empty(pFILCC)
			cDbfSZO->FILIAL	  :=pFILCC
			cDbfSZO->DESCRICAO:=pDescri
		EndIf
	MsUnLock()
Return

/****************************************************************************
* Funcao....: fGeraTotal()                                                  *
* Autor.....: Marcelo Aguiar Pimentel                                       *
* Data......: 16/04/2007                                                    *
* Descricao.: Atualiza os totais do arquivo DBF.                            *
*                                                                           *
****************************************************************************/
Static Function fGeraTotal()
Local aTotVnd:=array(len(aEst)-2)
Local aTotCmp:=array(len(aEst)-2)
Local nTotMetier:=0 // Guarda os valores do Metier por registro

dbSelectArea("cDbfSZO")
dbGoTop()
ProcRegua(RecCount())

For nY:=1 to len(aTotVnd)
	aTotVnd[nY]:=0
	aTotCmp[nY]:=0
Next nY

For nX:=1 to len(aFilCC)
	dbSelectArea("cDbfSZO")
	If dbSeek(aFilCC[nX,1])
		While !Eof() .and. aFilCC[nX,1] == alltrim(cDbfSZO->FILIAL)
			IncProc()
			cDesc:=ALLTRIM(cDbfSZO->DESCRICAO)
			If cDesc $ ("A01C|A01B|A01A") // Vendas
				nTotMetier:=0
				For nY:=1 to len(aTotVnd)-1
					aTotVnd[nY]+=cDbfSZO->&(aEst[nY+2,1])
					nTotMetier+=cDbfSZO->&(aEst[nY+2,1])
				Next nY
				aTotVnd[len(aTotVnd)]+=nTotMetier
				RecLock("cDbfSZO",.F.)
					cDbfSZO->TOTAL:=nTotMetier
				MsUnLock()
			ElseIf cDesc $ ("B01|B03|B04|B07") // Compras
				nTotMetier:=0
				For nY:=1 to len(aTotCmp)-1
					aTotCmp[nY]+=cDbfSZO->&(aEst[nY+2,1])
					nTotMetier+=cDbfSZO->&(aEst[nY+2,1])
				Next nY
				aTotCmp[len(aTotVnd)]+=nTotMetier
				RecLock("cDbfSZO",.F.)
					cDbfSZO->TOTAL:=nTotMetier
				MsUnLock()
			EndIf
			dbSelectArea("cDbfSZO")
			dbSkip()
		EndDo
		dbSeek(aFilCC[nX,1]+"Total das vendas")
		For nY:=1 to len(aTotVnd)
			RecLock("cDbfSZO",.f.)
				cDbfSZO->&(aEst[nY+2,1])+=aTotVnd[nY]
			MsUnLock()
		Next nY
		dbSeek(aFilCC[nX,1]+"Total da compras")
		For nY:=1 to len(aTotCmp)
			RecLock("cDbfSZO",.f.)
				cDbfSZO->&(aEst[nY+2,1])+=aTotCmp[nY]
			MsUnLock()
		Next nY

		dbSeek(aFilCC[nX,1]+"Margem comercial")
		For nY:=1 to len(aTotCmp)
			RecLock("cDbfSZO",.f.)
				cDbfSZO->&(aEst[nY+2,1])+=aTotCmp[nY]+aTotVnd[nY]
			MsUnLock()
		Next nY
		
		dbSeek(aFilCC[nX,1]+"% sobre as vendas")
		For nY:=1 to len(aTotCmp)
			nVal:=0
			RecLock("cDbfSZO",.f.)
				If aTotCmp[nY] == 0
					nVal:=0
				Else
					nVal:=(aTotCmp[nY]+aTotVnd[nY])/aTotVnd[nY]
				EndIf
				cDbfSZO->&(aEst[nY+2,1]):=nVal*100
			MsUnLock()
		Next nY
				
		For nY:=1 to len(aTotVnd)
			aTotVnd[nY]:=0
			aTotCmp[nY]:=0
		Next nY
	EndIf
Next nX

Return

/****************************************************************************
* Funcao....: fExpExcel()                                                   *
* Autor.....: Marcelo Aguiar Pimentel                                       *
* Data......: 13/04/2007                                                    *
* Descricao.: Faz as ultimas atualizacoes e abre o DBF no excel             *
*                                                                           *
****************************************************************************/
Static Function fExpExcel()
Local cChvFil	:=""

dbSelectArea("cDbfSZO")
dbGoTop()
ProcRegua(RecCount())

While !Eof()
	IncProc("Finalizando...")
	// Se nao encontrar o nome da filial e for codigo da conta atualiza o campos Descricao como abaixo e zera a filial
	nPos:=aScan(aFilCC, {|aVal| aVal[2] == ALLTRIM(cDbfSZO->DESCRICAO)})
	If nPos == 0
		RecLock("cDbfSZO",.f.)
			cDbfSZO->FILIAL	:=	""
			cDesc:=alltrim(cDbfSZO->DESCRICAO)
			If cDesc == "A01C"
				cDbfSZO->DESCRICAO:="Ventes Hors Groupe PSA"
			ElseIf cDesc == "A01B"
				cDbfSZO->DESCRICAO:="Ventes Groupe GEFCO"
			ElseIf cDesc == "A01A"
				cDbfSZO->DESCRICAO:="Ventes Groupe PSA Consolide"
			ElseIf cDesc == "B01"
				cDbfSZO->DESCRICAO:="Achats Routes"
			ElseIf cDesc == "B03"
				cDbfSZO->DESCRICAO:="Achats Mer"
			ElseIf cDesc == "B04"
				cDbfSZO->DESCRICAO:="Achats Aeriens"
			ElseIf cDesc == "B07"
				cDbfSZO->DESCRICAO:="Achats Autres"
			EndIf
		MsUnLock()
    EndIf
	dbSelectArea("cDbfSZO")
	dbSkip()
EndDo

//Copiando arquivo para abrir no excel
cPath:=alltrim(cPath)
cArquivo:=alltrim(cArquivo)
If CpyS2T(cDbfSZO+".dbf", cPath,.f.)
	If File(cPath+cArquivo+".dbf")
		fErase(cPath+cArquivo+".dbf")
	EndIf
	
	If FRENAME(cPath+cDbfSZO+".dbf", cPath+cArquivo+".dbf") == -1
		MsgAlert("Não foi possível gerar arquivo como o nome solicitado: "+cPath+cArquivo+".dbf","Atenção!")
		cArquivo:=cDbfSZO		
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

dbSelectArea("cDbfSZO")
If FILE(cDbfSZO+".DBF")     //Elimina o arquivo de trabalho
    dbCloseArea()
    Ferase(cDbfSZO+".DBF")
    Ferase("cInd1"+OrdBagExt())
EndIf

Return

/****************************************************************************
* Funcao....: fvldOk()                                                      *
* Autor.....: Marcelo Aguiar Pimentel                                       *
* Data......: 13/04/2007                                                    *
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
Return lRet

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