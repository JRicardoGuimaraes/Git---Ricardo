#include "protheus.ch"
#include "rwMake.ch"
#include "topconn.ch"
/***************************************************************************
* Programa.......: gefpf002()                                              *
* Autor..........: Marcelo Aguiar Pimentel                                 *
* Data...........: 01/06/07                                                *
* Descricao......: Visualiza titulos librerados/bloqueados do prefat       *
*                                                                          *
****************************************************************************
* Alt. por.......:                                                         *
* Data...........:                                                         *
* Motivo.........:                                                         *
*                                                                          *
***************************************************************************/
User Function gefpf002()
Local oDlg		:=	Nil
Local oDe		:=	Nil
Local oAte		:=	Nil
Local oLstDados	:=	Nil
Private cDados	
Private cCli	:=	space(len(CriaVar("SA1->A1_COD" )))
Private cLoja	:=	space(len(CriaVar("SA1->A1_LOJA")))
Private cFilDe	:=	cFilAnt
Private cFilAte	:=	cFilAnt
Private cDe		:=	ctod("  /  /  ")
Private cAte	:=	ctod("  /  /  ")
Private aEstSE1	:=	{}
Private aEst	:=	{}
Private cDbf	:=	""
Private cInd1	:=	""
Private oBlq	:=	Nil
Private lBlq	:=	.f.
Private cCampos	:=	"E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,"+;
					"E1_NATUREZ,E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_EMISSAO,E1_VENCTO,E1_VENCREA,E1_XDTLIB,E1_XPREFAT,E1_VALOR"
Private aDados	:=	{}
Private aTotal	:=	{}
Private aCab	:=	{}
Private aTit	:= 	{}
Private aPic 	:= 	{}
Private aSizeCol:= 	{}
Private olblist	:=	Nil

dbSelectArea("SE1")          
dbSetOrder(1)
aEstSE1 := dbStruct("SE1")
aTmp:={}

//Configurando Grid de dados
dbSelectArea("SX3")
dbSetOrder(2)
For nX:=1 to len(aEstSE1)
	If allTrim(aEstSE1[nX,1]) $(cCampos)
		If dbSeek(allTrim(aEstSE1[nX,1]))
			aAdd(aEst,{aEstSE1[nX,1],aEstSE1[nX,2],aEstSE1[nX,3],aEstSE1[nX,4],SX3->X3_TITULO,SX3->X3_PICTURE})
			aAdd(aTit,allTrim(SX3->X3_TITULO))
			aAdd(aPic,allTrim(SX3->X3_PICTURE))
			aAdd(aSizeCol,aEstSE1[nX,2])
			aAdd(aTmp,{})
		EndIf
	EndIf
Next nX
aAdd(aDados,aTmp)

DEFINE MSDIALOG oDlg TITLE "Visualiza Pré-faturas" From 000,000 To 28,80 OF oMainWnd
@ 001,0.5 TO 3.5,008  LABEL "Filial:
@ 22,007 SAY "De: " 
@ 20,027 Get cFilDe
@ 35,007 SAY "Ate: "
@ 35,027 Get cFilAte
@ 001,8.5 TO 3.5,18.5 LABEL "Cliente:
@ 22,075 SAY "Codigo: " 
@ 20,095 Get cCli F3 "SA1"
@ 35,075 SAY "Loja: "
@ 35,095 Get cLoja
@ 020,154 CHECKBOX "Bloqueado" VAR lBlq OBJECT oBlq
@ 002,19 TO 3.5,33 LABEL "Liberado em:"
@ 35,154 SAY "De: "
@ 35,168 Get cDe Object oDe
@ 35,211 SAY "Ate: "
@ 35,225 Get cAte Object oAte

oBlq:BCHANGE:={|| iif(lBlq,(oDe:Disable(),oAte:Disable()),(oDe:Enable(),oAte:Enable()))}

@ 20,280 BUTTON "Consultar" SIZE 50,10 Action (fConsult())
@ 35,280 BUTTON "Imprimir"  SIZE 50,10 AcTION (fPrint())
@ 50,001 TO oMainWnd:nClientHeight-340,oMainWnd:nClientWidth-520 TITLE "" Object oLt1

olblist  := TWBrowse():New( 004,1, oMainWnd:nClientWidth-530,oMainWnd:nClientHeight-430,,aTit,aSizeCol,oLt1,,,,,,,,,,,, .F.,, .F.,, .F.,,, )
fUpdDados()

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||nOpcA:=2,oDlg:End()})
Return

/*****************************************************************************
* Funcao....: fConsult()                                                     *
* Autor.....: Marcelo Aguiar Pimentel                                        *
* Data......: 08/06/07                                                       *
* Descricao.: Consulta na tabela SE1 titulos que estao liberados/bloqueados  *
*                                                                            *
*****************************************************************************/
Static Function fConsult()
If Empty(cCli) .and. Empty(cLoja) 
	ApMsgAlert("Por favor informe os parametros Cliente/Loja para a consulta!")
ElseIf !lBlq .and. Empty(cDe) .and. Empty(cAte)
	ApMsgAlert("Por favor informe os parametros Data de liberacao!")
Else
	If Empty(cFilDe)
		cFilAte:="ZZ"
	EndIf
	dbSelectarea("SA1")
	DBsETORDER(1)
	If dbSeek(xFilial("SA1")+cCli+cLoja)
		cQry:="SELECT "+cCampos
		cQry+="  FROM "+RetSqlName("SE1")
		cQry+=" WHERE E1_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"'"
		cQry+="   AND E1_PREFIXO = 'CTR'"
		cQry+="   AND E1_CLIENTE = '"+cCli+"'"
		cQry+="   AND E1_LOJA    = '"+cLoja+"'"
		If !lBlq
			cQry+="   AND E1_XDTLIB BETWEEN '"+dtos(cDe)+"' AND '"+dtos(cAte)+"'"
		Else
			cQry+="   AND E1_XDTLIB = ' '"
		EndIf
		cQry+="   AND E1_SALDO <> 0"
		cQry+="   AND D_E_L_E_T_ <> '*'"
		cQry+=" ORDER BY "+cCampos
		TcQuery cQry Alias "TSE1" New
		Processa({|| fCarregar() },"Processando...")
		dbCloseArea()		
	Else
		ApMsgAlert("Codigo de cliente inválido")
	EndIf
EndIf
Return

/*****************************************************************************
* Funcao....: fCarregar()                                                    *
* Autor.....: Marcelo Aguiar Pimentel                                        *
* Data......: 08/06/07                                                       *
* Descricao.: Carrega no listbox o vetor aDados com dados retornados da con- *
*             sulta.                                                         *
*                                                                            *
*****************************************************************************/
Static Function fCarregar()
Local aRet:={}
Local nPos:=0
ProcRegua(TSE1->(RecCount()))
If !Eof()
	aDados:={}
	aTotal:={}
	fUpdDados()
	While !Eof()
		IncProc()
		aRet:={}
		For nX:=1 to len(aEst)
			If alltrim(aEst[nX,2]) == "D"
				aAdd(aRet,stod(TSE1->&(aEst[nX,1])))
			Else
				aAdd(aRet,TransForm(TSE1->&(aEst[nX,1]),aEst[nX,6]))
			EndIf
			If allTrim(aEst[nX,1]) == "E1_VALOR"
				nPos:=aScan(aTotal, {|aVal| aVal[1] == TSE1->E1_FILIAL})
				If nPos > 0
					aTotal[nPos,2]+=TSE1->E1_VALOR
				Else
					aAdd(aTotal,{TSE1->E1_FILIAL,TSE1->E1_VALOR})
				EndIf
			EndIf
		Next nX
		dbSelectArea("TSE1")
		TSE1->(dbSkip())
		aAdd(aDados,aRet)
	EndDo
	fUpdDados()
Else
	ApMsgInfo("Dados não encontrado!")
EndIf
Return

/*****************************************************************************
* Funcao....: fUpdDados()                                                    *
* Autor.....: Marcelo Aguiar Pimentel                                        *
* Data......: 08/06/07                                                       *
* Descricao.: Atualiza vetor do listbox para ser mostrado na tela.           *
*                                                                            *
*****************************************************************************/
Static Function fUpdDados()
	olblist:SetArray(aDados)                   
	olblist:nAt	:=	1
	olblist:bLine := { || aDados[olblist:nAT]}
	olblist:Refresh()
Return

/*****************************************************************************
* Funcao....: fPrint()                                                       *
* Autor.....: Marcelo Aguiar Pimentel                                        *
* Data......: 11/06/07                                                       *
* Descricao.: Funcao responsavel pela configuracao da impressao da consulta. *
*                                                                            *
*****************************************************************************/
Static Function fPrint()
Local cDesc1       	:= "Este programa tem como objetivo imprimir o resultado"
Local cDesc2       	:= "da consulta de título liberados ou bloqueados."
Local cDesc3       	:= ""
Local cPict        	:= ""
Local titulo       	:= iif(lBlq,"Relação de CTR Bloqueados","Relação de CTR Liberados")
Local nLin         	:= 80
//					   {0 ,3   ,08    ,15  ,20 ,24        ,35    ,42,45                  ,66      ,75        ,86       ,96                ,115         }
//                      0         1         2         3         4         5         6         7         8         9         10        11        12        13        140
//                      012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       	:= "Fl Pref Numero Parc Tip Natureza   Client Lj Nome                 Emissao  Vencimento Venc.Real Vlt.Tit            Dt.Liberacao" 
//                      XX XXX  XXXXXX XX   XX  XXXXXXXXXX XXXXXX XX XXXXXXXXXXXXXXXXXXXX XX/XX/XX XX/XX/XX   XX/XX/XX  99,999,999,999.99  XX/XX/XX
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd 			:= {}
Local cString		:= ""
Private aCol		:= {0 ,3   ,08    ,15  ,20 ,24        ,35    ,42,45                  ,66      ,75        ,86       ,96                ,115         }
Private lEnd      	:= .F.
Private lAbortPrint	:= .F.
Private CbTxt      	:= ""
Private limite     	:= 132
Private tamanho   	:= "M"
Private nomeprog  	:= "GEFPF02" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo    	:= 18
Private aReturn   	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey  	:= 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "GEFPF02" // Coloque aqui o nome do arquivo usado para impressao em disco

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*****************************************************************************
* Funcao....: RunReport()                                                    *
* Autor.....: Marcelo Aguiar Pimentel                                        *
* Data......: 11/06/07                                                       *
* Descricao.: Imprime o resultado da consulta                                *
*                                                                            *
*****************************************************************************/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nX
Local nTotGeral:=0

SetRegua(len(aDados))
For nX:=1 to len(aDados)
	IncRegua()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

	For nY:= 1 to len(aDados[nX])
		@nLin,aCol[nY] PSAY aDados[nX,nY]
	Next nY
	If nX+1 <= len(aDados)
		If aDados[nX,1] != aDados[nX+1,1]
			nLin+=2
			nPos:=aScan(aTotal, {|aVal| aVal[1] == aDados[nX,1]})
			@nLin,00 PSAY "Sub-Total: "
			@nLin,13 PSAY aTotal[nPos,2] Picture "@E 99,999,999,999.99"
			nTotGeral+=aTotal[nPos,2]
			nLin++
		EndIf
	Else
		nLin+=2
		nPos:=aScan(aTotal, {|aVal| aVal[1] == aDados[nX,1]})
		@nLin,00 PSAY "Sub-Total: "
		@nLin,13 PSAY aTotal[nPos,2] Picture "@E 99,999,999,999.99"
		nTotGeral+=aTotal[nPos,2]
		nLin+=2
		@nLin,00 PSAY "TOTAL: "
		@nLin,13 PSAY nTotGeral Picture "@E 99,999,999,999.99"
	EndIf
	nLin++
Next nX

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()
Return