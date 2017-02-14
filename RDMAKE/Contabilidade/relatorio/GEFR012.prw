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
* Modificado por..:                                                     *
* Data............:                                                     *
* Motivo..........:                                                     *
*                                                                       *
************************************************************************/
User Function GEFR012()
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Relatorio de Abertura de Vendas PSA"
Local nLin         	 := 80

Local Cabec1       	 := ""
Local Cabec2       	 := ""
Local imprime      	 := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "GEFR012" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	 := Space(10)
Private cbcont     	 := 00
Private CONTFL     	 := 01
Private m_pag      	 := 01
Private wnrel      	 := "GEFR012" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	   	 := "GEFR12"
Private cString 	 := "SZO"

dbSelectArea(cString)
dbSetOrder(1)
Pergunte(cPerg,.f.)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

/*************************************************************************
* Funcao....: RUNReport()                                                *
* Autor.....: Marcelo Aguiar Pimentel                                    *
* Data......: 13/04/2007                                                 *
* Descricao.: Funcao responsável pela busca de informacoes na tabela SZO *
*             e geracao de arquivo dbf.                                  *
*                                                                        *
*************************************************************************/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local cQry		:=	""
Local aPrint	:=	{}
Local nPos		:=	0
Local cTipo		:=	""

aPrint:=fMontaEst()

//Buscando informacoes processadas
cQry:="SELECT ZO_UO,ZO_CONTA,SUM(ZO_SALDO) AS ZO_SALDO"
cQry+="  FROM "+RetSqlName("SZO")
cQry+=" WHERE ZO_FILIAL = '"+xFilial("SZO")+"'"
cQry+="   AND ZO_DATA BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'"
cQry+="   AND ZO_CONTA IN ('A01B','A01C','A01E','A01F','A01G','A01H')"
cQry+="   AND D_E_L_E_T_ <> '*'"
cQry+=" GROUP BY ZO_UO,ZO_CONTA"
cQry+=" ORDER BY ZO_UO,ZO_CONTA"
TcQuery cQry Alias "TSZO" New
SetRegua(RecCount())
While !EOF()
	IncProc()
	//Busca a linha no vetor aPrint pela UO e CONTA
   	nPos:=aScan(aPrint, {|aVal| aVal[1] == ALLTRIM(TSZO->ZO_UO) .and. aVal[2] == allTrim(TSZO->ZO_CONTA)})
	If nPos <> 0
		aPrint[nPos,4]+=TSZO->ZO_SALDO
		//Busca a posicao do Sub-Total da UO
   		nPosTot:=aScan(aPrint, {|aVal| aVal[1] == ALLTRIM(TSZO->ZO_UO) .and. aVal[2] == "TOTAL"})
		aPrint[nPosTot,4]+=TSZO->ZO_SALDO
		aPrint[len(aPrint),4]+=TSZO->ZO_SALDO
	EndIf
	dbSelectArea("TSZO")
	dbSkip()
EndDo
dbSelectArea("TSZO")
dbCloseArea()

ProcRegua(len(aPrint))
For nX:=1 to len(aPrint)
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	cTipo:=subStr(aPrint[nX,3],1, 6)
	nCol:=10
	If  cTipo $ ("RESUMO|TOTAL")
		nLin++
		nCol:=1
	ElseIf  subStr(aPrint[nX,3],1, 9) == "SUB-TOTAL"
		nCol:=1
	EndIf

	@nLin,nCol PSAY aPrint[nX,3]
	If cTipo <> "RESUMO"
		@nLin,030 PSAY aPrint[nX,4] Picture "@E 99,999,999,999.99"
	EndIf
	nLin ++
next nX

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()
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