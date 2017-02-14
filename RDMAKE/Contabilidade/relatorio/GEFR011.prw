#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"    
#INCLUDE "TOPCONN.CH"
/************************************************************************
* Programa........: GEFR011                                             *
* Autor...........: Marcelo Aguiar Pimentel                             *
* Data............: 26/04/2007                                          *
* Descricao.......: Relatorio de Vendas                                 *
*                                                                       *
*************************************************************************
* Modificado por..:                                                     *
* Data............:                                                     *
* Motivo..........:                                                     *
*                                                                       *
************************************************************************/
User Function GEFR011()
Local 	nOpcao	:=	0
Private aEst	:=	{}
Private aFilCC	:=	{}
Private oDlgVnd	:= 	nil
Private cPath	:=	space(255)
Private cArquivo:=	space(255)
Private dDataDe	:=	dDataBase
Private dDataAte:=	dDataBase
Private aUO		:={}//"RDVM","RMLAP","RMA","ILI"}


SetKey (VK_F3,{|a,b| cPath:=cGetFile( "DBF(*.dbf) | *.dbf ",OemToAnsi("Salvar em..."),,"d:",.f.,GETF_LOCALHARD+GETF_RETDIRECTORY)})
@ 200,1 TO 422,390 DIALOG oDlgVnd TITLE OemToAnsi("Relatorio de Vendas")
@ 02,10 TO 095,190
@ 10,018 Say " Este programa ira importar dados do processamento de Vendas"
@ 18,018 Say " Defina abaixo os parâmetros do relatório"
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

@ 097,128 BMPBUTTON TYPE 01 ACTION (nOpcao:=1,iif(fvldOk(),Close(oDlgVnd),))
@ 097,158 BMPBUTTON TYPE 02 ACTION (nOpcao:=2,Close(oDlgVnd))

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
Local cUO		:=  ""
Local cLstUO	:=	""
Private cDbfSZO	:=	""
Private cInd1	:=	""

dbSelectArea("SZO")
aTamSld := TamSX3("ZO_SALDO")
aTamFil := TamSX3("ZO_FILCC")

//Criando estrutura do arquivo DBF
aEst:={}
aAdd(aEst, { "UO"        , "C",     15    ,         0 } )
aAdd(aEst, { "DESCRICAO" , "C",     35    ,         0 } )

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
cQry+=" WHERE Z1_COD IN ("+cLstUO+")"
cQry+="   AND D_E_L_E_T_ <> '*'"
TcQuery cQry Alias "TSZ1" New
While !Eof()
	cUO:=allTrim(TSZ1->Z1_DESCR)
	cUO:=cUO+space(aEst[1,3]-len(cUO))
	aAdd(aUO,cUO)
	dbSkip()
EndDo
dbCloseArea()

//Buscando filiais para cricao do arquivo
cQry:="SELECT ZQ_FILCC,ZQ_DESCRIC,ZQ_NREDUZ"
cQry+="  FROM "+RetSqlName("SZQ")
cQry+=" WHERE D_E_L_E_T_ <> '*'"
TcQuery cQry Alias "TSZQ" New
aFilCC:={}
While !Eof()
	aAdd(aEst, { TSZQ->ZQ_NREDUZ, "N" ,aTamSld[1],aTamSld[2]})
	aAdd(aFilCC,{allTrim(TSZQ->ZQ_FILCC),allTrim(TSZQ->ZQ_NREDUZ)})
	dbSelectArea("TSZQ")
	dbSkip()
EndDo
dbCloseArea()

cdbfSZO	:=	criatrab(aEst)
Use &cDbfSZO Alias cDbfSZO New
cInd1	:= CriaTrab("",.F.)
IndRegua("cDbfSZO",cInd1,"UO+DESCRICAO",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
dbSetIndex( cInd1 +OrdBagExt())

//Criando estrutura de dados no DBF
fModelarDbf()

//Buscando informacoes na tabela de processamento SZO
cQry:="SELECT ZO_UO,ZO_CONTA,ZO_FILCC,SUM(ZO_SALDO) AS ZO_SALDO"
cQry+="  FROM "+RetSqlName("SZO")
cQry+=" WHERE ZO_FILIAL = '"+xFilial("SZO")+"'"
cQry+="   AND ZO_DATA BETWEEN '"+dtos(dDataDe)+"' AND '"+dtos(dDataAte)+"'"
cQry+="   AND ZO_CONTA IN (  'A01C','A01B','A01E','A01F','A01G','A01H',"
cQry+="                      'B01A','B01B','B01C','B03A','B03B','B03C',"
cQry+="                      'B04A','B04B','B04C','B07A','B07B','B07C' "
cQry+="                   )"
cQry+="   AND D_E_L_E_T_ <> '*'"
cQry+=" GROUP BY ZO_UO,ZO_CONTA,ZO_FILCC"
cQry+=" ORDER BY ZO_UO,ZO_CONTA,ZO_FILCC"
TcQuery cQry Alias "TSZO" New
ProcRegua(RecCount())
While !EOF()
	IncProc()
	dbSelectArea("cDbfSZO")
	If dbSeek(substr(TSZO->ZO_UO,1,aEst[1,3])+TSZO->ZO_CONTA)
    	nPos:=aScan(aFilCC, {|aVal| aVal[1] == ALLTRIM(TSZO->ZO_FILCC)})
		If nPos <> 0
			cCampo:=alltrim(aFilCC[nPos,2])
			RecLock("cDbfSZO",.f.)
				cDbfSZO->&cCampo +=TSZO->ZO_SALDO
			MsUnLock()
		EndIf
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
For nX:=1 to len(aUO)
	fNewLine(aUO[nX],"")
	fNewLine(aUO[nX],"A01C") //Ventes Hors Groupe PSA
	fNewLine(aUO[nX],"A01B") //Ventes Groupe GEFCO
//	fNewLine(aUO[nX],"A01A") //Ventes Groupe PSA Consolide
	fNewLine(aUO[nX],"Ventes Groupe PSA") //Ventes Groupe PSA Consolide
	If alltrim(aUO[nX]) == "RDVM"
		fNewLine(aUO[nX],"A01E") //MARCA AP
		fNewLine(aUO[nX],"A01F") //MARCA AC
	Else
		fNewLine(aUO[nX],"A01G") //DIFA
		fNewLine(aUO[nX],"A01H") //DLPR
	EndIf
	fNewLine(aUO[nX],"Total Vendas "+aUO[nX])
	fNewLine("","")// Inclui linha em branco
	fNewLine(aUO[nX],"Achats Routes")	//Achats Routes-B01
	fNewLine(aUO[nX],"B01A")			//	Achats Routes Hors Groupe")
	fNewLine(aUO[nX],"B01B")			//	Achats Routes Groupe GEFCO")
	fNewLine(aUO[nX],"B01C")			//	Achats Routes Groupe PSA")
	fNewLine(aUO[nX],"Achats Mer") 		//Achats Mer-B03
	fNewLine(aUO[nX],"B03A") 			//	Achats Mer Hors Groupe")
	fNewLine(aUO[nX],"B03B") 			//	Achats Mer Groupe GEFCO")
	fNewLine(aUO[nX],"B03C") 			//	Achats Mer Groupe PSA")
	fNewLine(aUO[nX],"Achats Aeriens") 	//Achats Aeriens-B04
	fNewLine(aUO[nX],"B04A") 			//	Achats Aeriens Hors Groupe")
	fNewLine(aUO[nX],"B04B") 			//	Achats Aeriens Groupe GEFCO")
	fNewLine(aUO[nX],"B04C") 			//	Achats Aeriens Groupe PSA")
	fNewLine(aUO[nX],"Achats Autres") 	//Achats Autres-B07
	fNewLine(aUO[nX],"B07A") 			//	Achats Autres Hors Groupe")
	fNewLine(aUO[nX],"B07B") 			//	Achats Autres Groupe GEFCO")
	fNewLine(aUO[nX],"B07C") 			//	Achats Autres Groupe PSA")
	fNewLine(aUO[nX],"Total Compras "+aUO[nX])

	fNewLine("","")// Inclui linha em branco
	fNewLine(aUO[nX],"Margem comercial")
	fNewLine(aUO[nX],".    Margem comercial Hors Groupe")
	fNewLine(aUO[nX],".    Margem comercial Groupe GEFCO")
	fNewLine(aUO[nX],".    Margem comercial Groupe PSA")
	fNewLine(aUO[nX],"% sobre as vendas")
	fNewLine("","")// Inclui linha em branco
Next nX

Return

Static Function fNewLine(pUO,pDescri)
	RecLock("cDbfSZO",.t.)
		If !Empty(pUO)
			cDbfSZO->UO	:=pUO
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
Local aTotHVnd:=array(len(aEst)-2)
Local aTotGVnd:=array(len(aEst)-2)
Local aTotPVnd:=array(len(aEst)-2)
Local aTotHCmp:=array(len(aEst)-2)
Local aTotGCmp:=array(len(aEst)-2)
Local aTotPCmp:=array(len(aEst)-2)

Local nTotGV :=0
Local nTotGC :=0

dbSelectArea("cDbfSZO")
dbGoTop()
ProcRegua(RecCount())

For nY:=1 to len(aTotVnd)
	aTotVnd[nY]:=0
	aTotCmp[nY]:=0
	aTotHVnd[nY]:=0
	aTotGVnd[nY]:=0
	aTotPVnd[nY]:=0
	aTotHCmp[nY]:=0
	aTotGCmp[nY]:=0
	aTotPCmp[nY]:=0
Next nY

For nX:=1 to len(aUO)
	dbSelectArea("cDbfSZO")
	If dbSeek(aUO[nX])
		While !Eof() .and. ALLTRIM(aUO[nX]) == alltrim(cDbfSZO->UO)
			IncProc()
			cDesc:=ALLTRIM(cDbfSZO->DESCRICAO)
			If cDesc $ ("A01C|A01B|A01E|A01F|A01G|A01H")//("A01C|A01B|A01A") // Vendas
				For nY:=1 to len(aTotVnd)
					aTotVnd[nY]+=cDbfSZO->&(aEst[nY+2,1])
					If cDesc =="A01C" // Hour Groupe
						aTotHVnd[nY]+=cDbfSZO->&(aEst[nY+2,1])
					ElseIf cDesc == "A01B" // Groupe Gefco
						aTotGVnd[nY]+=cDbfSZO->&(aEst[nY+2,1])
					ElseIf cDesc $("A01E|A01F|A01G|A01H") // PSA
						aTotPVnd[nY]+=cDbfSZO->&(aEst[nY+2,1])
					EndIf					
				Next nY
			ElseIf cDesc $ ("B01A|B01B|B01C|B03A|B03B|B03C|B04A|B04B|B04C|B07A|B07B|B07C") //("B01|B03|003|B07") // Compras
				For nY:=1 to len(aTotCmp)
					aTotCmp[nY]+=cDbfSZO->&(aEst[nY+2,1])
					If cDesc $("B01A|B03A|B04A|B07A") // Achats Routes/MER/AERIENS/AUTRES - Hour
						aTotHCmp[nY]+=cDbfSZO->&(aEst[nY+2,1])
					ElseIf cDesc $("B01B|B03B|B04B|B07B") // Achats Routes/MER/AERIENS/AUTRES - GEFCO
						aTotGCmp[nY]+=cDbfSZO->&(aEst[nY+2,1])
					ElseIf cDesc $("B01C|B03C|B04C|B07C") // Achats Routes/MER/AERIENS/AUTRES - PSA
						aTotPCmp[nY]+=cDbfSZO->&(aEst[nY+2,1])
					EndIf					
				Next nY
			EndIf
			dbSelectArea("cDbfSZO")
			dbSkip()
		EndDo

		cUO:=aUO[nX]+space(aEst[1,3]-len(aUO[nX]))

		dbSeek(cUO+".    Margem comercial Hors Groupe")
		For nY:=1 to len(aTotVnd)
			RecLock("cDbfSZO",.f.)
				cDbfSZO->&(aEst[nY+2,1])+=aTotHCmp[nY]+aTotHVnd[nY]
			MsUnLock()
		Next nY

		dbSeek(cUO+".    Margem comercial Groupe GEFCO")
		RecLock("cDbfSZO",.f.)
			For nY:=1 to len(aTotVnd)
				cDbfSZO->&(aEst[nY+2,1])+=aTotGCmp[nY]+aTotGVnd[nY]
			Next nY
		MsUnLock()

		dbSeek(cUO+".    Margem comercial Groupe PSA")
		RecLock("cDbfSZO",.f.)
			For nY:=1 to len(aTotVnd)
				cDbfSZO->&(aEst[nY+2,1])+=aTotPCmp[nY]+aTotPVnd[nY]
			Next nY
		MsUnLock()

		dbSeek(cUO+"Total Vendas "+cUO)
		RecLock("cDbfSZO",.f.)
			For nY:=1 to len(aTotVnd)
				cDbfSZO->&(aEst[nY+2,1])+=aTotVnd[nY]
				nTotGV+=aTotVnd[nY]
			Next nY
		MsUnLock()
		dbSeek(cUO+"Total Compras "+cUO)
		RecLock("cDbfSZO",.f.)
			For nY:=1 to len(aTotCmp)
				cDbfSZO->&(aEst[nY+2,1])+=aTotCmp[nY]
				nTotGC+=aTotCmp[nY]
			Next nY
		MsUnLock()

		dbSeek(cUO+"Margem comercial")
		RecLock("cDbfSZO",.f.)
			For nY:=1 to len(aTotCmp)
				cDbfSZO->&(aEst[nY+2,1])+=aTotCmp[nY]+aTotVnd[nY]
			Next nY
		MsUnLock()
		
		dbSeek(cUO+"% sobre as vendas")
		RecLock("cDbfSZO",.f.)
			For nY:=1 to len(aTotCmp)
				nVal:=0
				If aTotCmp[nY] == 0
					nVal:=0
				Else
					nVal:=(aTotCmp[nY]+aTotVnd[nY])/aTotVnd[nY]
				EndIf
				cDbfSZO->&(aEst[nY+2,1]):=nVal*100
			Next nY
		MsUnLock()
				
		For nY:=1 to len(aTotVnd)
			aTotVnd[nY]:=0
			aTotCmp[nY]:=0
			aTotHVnd[nY]:=0
			aTotGVnd[nY]:=0
			aTotPVnd[nY]:=0
			aTotHCmp[nY]:=0
			aTotGCmp[nY]:=0
			aTotPCmp[nY]:=0
		Next nY
	EndIf
Next nX

dbSelectArea("cDbfSZO")
RecLock("cDbfSZO",.T.)
	cDbfSZO->DESCRICAO	:=	"TOTAL GERAL DAS VENDAS"
	cDbfSZO->&(aEst[3,1]):=nTotGV
MsUnLock()

RecLock("cDbfSZO",.T.)
	cDbfSZO->DESCRICAO	:=	"TOTAL GERAL DAS COMPRAS"
	cDbfSZO->&(aEst[3,1]):=nTotGC
MsUnLock()

RecLock("cDbfSZO",.T.)
	cDbfSZO->DESCRICAO	:=	"MARGEM COMERCIAL"
	cDbfSZO->&(aEst[3,1]):=nTotGC+nTotGV
MsUnLock()

RecLock("cDbfSZO",.T.)
	nVal:=0
	If nTotGC <> 0
		nVal:=(nTotGC+nTotGV)/nTotGV
	EndIf
	cDbfSZO->DESCRICAO	:=	"MARGEM COMERCIAL S/ VENDAS"
	cDbfSZO->&(aEst[3,1]):=nVal*100
MsUnLock()

Return

/****************************************************************************
* Funcao....: fExpExcel()                                                   *
* Autor.....: Marcelo Aguiar Pimentel                                       *
* Data......: 13/04/2007                                                    *
* Descricao.: Faz as ultimas atualizacoes e abre o DBF no excel             *
*                                                                           *
****************************************************************************/
Static Function fExpExcel()
dbSelectArea("cDbfSZO")
DBClearIndex()
dbGoTop()
ProcRegua(RecCount())

While !Eof()
	IncProc("Finalizando...")
	RecLock("cDbfSZO",.f.)
		If !Empty(cDbfSZO->DESCRICAO)
			cDbfSZO->UO:=""
		EndIf
		cDesc:=alltrim(cDbfSZO->DESCRICAO)
		If cDesc == "A01C"
			cDbfSZO->DESCRICAO:="Ventes Hors Groupe"
		ElseIf cDesc == "A01B"
			cDbfSZO->DESCRICAO:="Ventes Groupe GEFCO"
		ElseIf cDesc == "A01E"
			cDbfSZO->DESCRICAO:=".   MARCA AP"
		ElseIf cDesc == "A01F"
			cDbfSZO->DESCRICAO:=".   MARCA AC"
		ElseIf cDesc == "A01G"
			cDbfSZO->DESCRICAO:=".   DIFA"
		ElseIf cDesc == "A01H"
			cDbfSZO->DESCRICAO:=".   DLPR"
		ElseIf cDesc == "B01A"
			cDbfSZO->DESCRICAO:=".   Achats Routes Hors"
		ElseIf cDesc == "B01B"
			cDbfSZO->DESCRICAO:=".   Achats Routes GEFCO"
		ElseIf cDesc == "B01C"
			cDbfSZO->DESCRICAO:=".   Achats Routes PSA"
		ElseIf cDesc == "B03A"
			cDbfSZO->DESCRICAO:=".   Achats Mer Hors"
		ElseIf cDesc == "B03B"
			cDbfSZO->DESCRICAO:=".   Achats Mer GEFCO"
		ElseIf cDesc == "B03C"
			cDbfSZO->DESCRICAO:=".   Achats Mer PSA"
		ElseIf cDesc == "B04A"
			cDbfSZO->DESCRICAO:=".   Achats Aeriens Hors"
		ElseIf cDesc == "B04B"
			cDbfSZO->DESCRICAO:=".   Achats Aeriens GEFCO"
		ElseIf cDesc == "B04C"
			cDbfSZO->DESCRICAO:=".   Achats Aeriens PSA"
		ElseIf cDesc == "B07A"
			cDbfSZO->DESCRICAO:=".   Achats Autres Hors"
		ElseIf cDesc == "B07B"
			cDbfSZO->DESCRICAO:=".   Achats Autres GEFCO"
		ElseIf cDesc == "B07C"
			cDbfSZO->DESCRICAO:=".   Achats Autres PSA"
		EndIf
	MsUnLock()
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