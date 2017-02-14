#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"    
#INCLUDE "TOPCONN.CH"
/************************************************************************
* Programa........: GEFR012                                             *
* Autor...........: Marcelo Aguiar Pimentel                             *
* Data............: 26/04/2007                                          *
* Descricao.......: Abertura de Vendas PSA                              *
*                                                                       *
*************************************************************************
* Modificado por..: Ricardo de Oliveira                                 *
* Data............: 14/04/2008                                          *
* Motivo..........: Exportar dados para Excel                           *
*                                                                       *
************************************************************************/
User Function GEFR012E()
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
@ 200,1 TO 422,390 DIALOG oDlgVnd TITLE OemToAnsi("Relatorio de Abertura de Vendas PSA.")
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
* Funcao....: RUNReport()                                                *
* Autor.....: Marcelo Aguiar Pimentel                                    *
* Data......: 13/04/2007                                                 *
* Descricao.: Funcao responsável pela busca de informacoes na tabela SZO *
*             e geracao de arquivo dbf.                                  *
*                                                                        *
*************************************************************************/
Static Function RunExport(Cabec1,Cabec2,Titulo,nLin)
Local cQry		:=	""
Local aPrint	:=	{}
Local nPos		:=	0
Local cTipo		:=	""

Private cDbfSZO	:=	""
Private cInd1	:=	""

dbSelectArea("SZO")
aTamSld := TamSX3("ZO_SALDO")
aTamFil := TamSX3("ZO_FILCC")

//Criando estrutura do arquivo DBF
aEst:={}
aAdd(aEst, { "UO"        , "C", 30, 0 } )
aAdd(aEst, { "CONTA"     , "C", 10, 0 } )
aAdd(aEst, { "DESCRICAO" , "C", 35, 0 } )
aAdd(aEst, { "SALDO", "N",aTamSld[1],aTamSld[2]})

cdbfSZO	:=	criatrab(aEst)
Use &cDbfSZO Alias cDbfSZO New
cInd1	:= CriaTrab("",.F.)
IndRegua("cDbfSZO",cInd1,"UO+CONTA",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
dbSetIndex( cInd1 +OrdBagExt())

// aPrint:=fMontaEst()

//Alimenta DBF
fModelarDbf()

//Buscando informacoes processadas
cQry:="SELECT ZO_UO,ZO_CONTA,SUM(ZO_SALDO) AS ZO_SALDO"
cQry+="  FROM "+RetSqlName("SZO")
cQry+=" WHERE ZO_FILIAL = '"+xFilial("SZO")+"'"
cQry+="   AND ZO_DATA BETWEEN '"+dtos(dDataDe)+"' AND '"+dtos(dDataAte)+"'"
cQry+="   AND ZO_CONTA IN ('A01B','A01C','A01E','A01F','A01G','A01H')"
cQry+="   AND D_E_L_E_T_ <> '*'"
cQry+=" GROUP BY ZO_UO,ZO_CONTA"
cQry+=" ORDER BY ZO_UO,ZO_CONTA"
TcQuery cQry Alias "TSZO" New

// MEMOWRIT("D:\TEMP\QRYVENDAS.TXT",cQry)

dbSelectArea("TSZO")
ProcRegua(RecCount())

While !EOF()
	IncProc()
	//Busca a linha no vetor aPrint pela UO e CONTA
   	// nPos:=aScan(aPrint, {|aVal| aVal[1] == ALLTRIM(TSZO->ZO_UO) .and. aVal[2] == allTrim(TSZO->ZO_CONTA)})
   	dbSelectArea("cDbfSZO")
   	If dbSeek(PADR(TSZO->ZO_UO,30) + PADR(TSZO->ZO_CONTA,10))
   		RecLock("cDbfSZO",.f.)
			cDbfSZO->SALDO := cDbfSZO->SALDO + TSZO->ZO_SALDO
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
* Funcao....: fMontaEst()                                                   *
* Autor.....: Marcelo Aguiar Pimentel                                       *
* Data......: 16/05/2007                                                    *
* Descricao.: Funcao responsavel pela cricao do vetor de impressao do rela- *
*             orio.                                                         *
****************************************************************************/

Static Function fMontaEst()
Local cQry	:=	""
Local aRet	:=	{}
Local cUO	:=	""
Local cLstUO:=	""

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
	If cUO == "RDVM"
		aAdd(aRet,{cUO	,""		,"RESUMO "+cUO	,0})
		aAdd(aRet,{cUO	,"A01E"	,"MARCA AP"		,0})
		aAdd(aRet,{cUO	,"A01F"	,"MARCA AC"		,0})
		aAdd(aRet,{cUO	,"A01B"	,"GRUPO GEFCO"	,0})
		aAdd(aRet,{cUO	,"A01C"	,"FORA GRUPO"	,0})
		aAdd(aRet,{cUO	,"TOTAL","SUB-TOTAL"	,0})
	Else
		aAdd(aRet,{cUO	,""		,"RESUMO "+cUO	,0})
		aAdd(aRet,{cUO	,"A01G"	,"DIFA"			,0})
		aAdd(aRet,{cUO	,"A01H"	,"DLPR"			,0})
		aAdd(aRet,{cUO	,"A01B"	,"GRUPO GEFCO"	,0})
		aAdd(aRet,{cUO	,"A01C"	,"FORA GRUPO"	,0})
		aAdd(aRet,{cUO	,"TOTAL","SUB-TOTAL"	,0})
	EndIf
	dbSkip()
EndDo
aAdd(aRet,{"TOTAL"		,""		,"TOTAL"		,0})

dbCloseArea()
Return aRet


/****************************************************************************
* Funcao....: fModelarDBF()                                                 *
* Autor.....: J Ricardo                                                     *
* Data......: 14/04/2008                                                    *
* Descricao.: Funcao responsavel pela alimentação do DBF de impressao do re-*
*             latorio.                                                      *
****************************************************************************/

Static Function fModelarDBF()
Local cQry	:=	""
Local aRet	:=	{}
Local cUO	:=	""
Local cLstUO:=	""

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

dbSelectArea("TSZ1") ; dbGoTop()
While !Eof()
	cUO:=allTrim(TSZ1->Z1_DESCR)
	If cUO == "RDVM"
		fNewLine("RESUMO "+cUO,"","",0)
		fNewLine(cUO,"A01E" ,"MARCA AP"   ,0)
		fNewLine(cUO,"A01F"	,"MARCA AC"   ,0)
		fNewLine(cUO,"A01B"	,"GRUPO GEFCO",0)
		fNewLine(cUO,"A01C"	,"FORA GRUPO" ,0)
		fNewLine(cUO,"TOTAL","SUB-TOTAL"  ,0)
		fNewLine("","","",0)		
	Else
		// fNewLine(cUO,""		,"RESUMO "+cUO,0)
		fNewLine("RESUMO "+cUO,"","",0)
		fNewLine(cUO,"A01G"	,"DIFA"		  ,0)
		fNewLine(cUO,"A01H"	,"DLPR"		  ,0)
		fNewLine(cUO,"A01B"	,"GRUPO GEFCO",0)
		fNewLine(cUO,"A01C"	,"FORA GRUPO" ,0)
		fNewLine(cUO,"TOTAL","SUB-TOTAL"  ,0)
		fNewLine("","","",0)		
	EndIf
	dbSelectArea("TSZ1")
	dbSkip()
EndDo
fNewLine("TOTAL","","TOTAL",0)

dbSelectArea("TSZ1")
dbCloseArea()
Return aRet

*----------------------------------------------------*
Static Function fNewLine(pUO,pConta, pDescri, pSaldo) 
*----------------------------------------------------*
	RecLock("cDbfSZO",.t.)
		If !Empty(pUO)
			cDbfSZO->UO	      := pUO
			cDbfSZO->CONTA    := pConta
			cDbfSZO->DESCRICAO:= pDescri
			cDbfSZO->SALDO    := pSaldo
		EndIf
	MsUnLock()
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
* Funcao....: fGeraTotal()                                                  *
* Autor.....: Marcelo Aguiar Pimentel                                       *
* Data......: 16/04/2007                                                    *
* Descricao.: Atualiza os totais do arquivo DBF.                            *
*                                                                           *
****************************************************************************/
Static Function fGeraTotal()
Local nTotSG := 0
Local nTotG  := 0
Local cUO    := ""

dbSelectArea("cDbfSZO")
dbGoTop()
ProcRegua(RecCount())

dbSelectArea("cDbfSZO")
dbGoTop()

While !Eof()
       
	cUO := cDbfSZO->UO
	
	If "RESUMO" $ cDbfSZO->UO
		cDbfSZO->(dbSkip())
		Loop
	EndIf	
	
	If Empty(cDbfSZO->UO) .AND. Empty(cDbfSZO->CONTA) .AND. Empty(cDbfSZO->DESCRICAO)
		cDbfSZO->(dbSkip())
		Loop
	EndIf	
	
	While !EOF() .AND. cDbfSZO->UO == cUO
	
		nTotSG   += cDbfSZO->SALDO
		nTotG    += cDbfSZO->SALDO
		
		cDbfSZO->(dbSkip())
		
		If AllTrim(cDbfSZO->CONTA) == "TOTAL" .AND. AllTrim(cDbfSZO->DESCRICAO) == "SUB-TOTAL"
			RecLock("cDbfSZO",.F.)
				cDbfSZO->SALDO := nTotSG
			MsUnLock()
			
			cDbfSZO->(dbSkip())
			/*
			// Gero linha em braco para separação de grupo
			RecLock("cDbfSZO",.T.)
				cDbfSZO->UO := ""
			MsUnLock()
			cDbfSZO->(dbSkip()) 
			*/
		EndIf
	End
	
	nTotSG   := 0

	// Gero total geral na planilha	
	If AllTrim(cDbfSZO->UO) == "TOTAL" .AND. AllTrim(cDbfSZO->DESCRICAO) == "TOTAL"
		RecLock("cDbfSZO",.F.)
			cDbfSZO->SALDO := nTotG
		MsUnLock()
			
		cDbfSZO->(dbSkip())
	EndIf			
	
End

Return
