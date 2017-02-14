#INCLUDE "rwmake.ch"
#include "topconn.ch"
/***************************************************************************
* Programa.........: GEFINA04()                                            *
* Autor............: Marcelo Aguiar Pimentel                               *
* Data.............: 20/03/2007                                            *
* Descricao........: RECAPITULATIF PAR CLIENT CONSOLIDE GROUPE             *
*                    Relaciona faturamento mes e saldo final statment  da  *
*                    moeda em questao                                      *
*                                                                          *
* Prametros........:                                                       *
*					MV_PAR01 = Da emissao:                                 *
*					MV_PAR02 = Ate emissao:                                *
*					MV_PAR03 = Da entrada:                                 *
*					MV_PAR04 = Ate entrada:                                *
*					MV_PAR05 = Da Filial:                                  *
*					MV_PAR06 = Ate Filial:                                 *
*					MV_PAR07 = (Moeda 1,Moeda 2,Moeda 3,Moeda 4,Moeda 5)   *
*					MV_PAR08 = Grp Cliente de:                             *
*					MV_PAR09 = Grp Cliente ate:                            *
*					MV_PAR10 = Word:(Impressora,Salvar,Abrir)              *
*					MV_PAR12 = Grava Processamento:(Sim,Nao)               *
*					MV_PAR13 = Grupo                                       *
*					MV_PAR14 = Responsavel                                 *
*					MV_PAR15 = Telefone                                    *
*					MV_PAR16 = Fax                                         *
*                                                                          *
****************************************************************************
* Alterado por.....:                                                       *
* Data alteracao...:                                                       *
* Motivo...........:                                                       *
*                                                                          *
***************************************************************************/

User Function GEFINA04()
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RECAPITULATIF PAR CLIENT CONSOLIDE GROUPE"
Local cPict          := ""
Local titulo       := "RECAPITULATIF PAR CLIENT CONSOLIDE GROUPE"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "GEF004" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GEF004" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	   := "GEF004"

Private cString := "SZJ"

dbSelectArea("SZJ")
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

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local lProcessa:=.f.
Local lJaProc:=.f.
Local aAtt:={}
Local cMon:=""
Local nTrimes:=1
Local nX:=1
Local nMont :=0
Local nSolde:=0
Local cFileOpen := ""
Local cFileSave := ""
Local oWord


dbSelectArea("SE1")          
aTam := TamSX3("E1_SALDO")			// Tam 6 Dec 0 Pict @E 999999
aEstru:={}	
aAdd(aEstru, { "XGRPCLI"  , "C",      8 ,       0 } )
aAdd(aEstru, { "COD"      , "C",      4 ,       0 } )
aAdd(aEstru, { "DESC"     , "C",     40 ,       0 } )
aAdd(aEstru, { "MOEDA"    , "C",      2 ,       0 } )
aAdd(aEstru, { "ANO"      , "C",      4 ,       0 } )
aAdd(aEstru, { "MES"      , "C",      2 ,       0 } )
aAdd(aEstru, { "MONT"     , "N",aTam[1] , 4})//aTam[2] } )
aAdd(aEstru, { "SOLDE"    , "N",aTam[1] , 4})//aTam[2] } )
aAdd(aEstru, { "GRAVA"    , "C",      1 ,       0 } )
	
cDbf	:= criatrab(aEstru)
Use &cDbf Alias cDbf New
cInd1	:= CriaTrab("",.F.)
IndRegua("cDbf",cInd1,"XGRPCLI+MOEDA+ANO+MES",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
dbSetIndex( cInd1 +OrdBagExt())

dbSelectArea("SZK")
cQry:="SELECT * "
cQry+="  FROM "+RetSqlName("SZK")
//cQry+=" WHERE ZK_FILIAL   = '"+xFilial("SZK")                +"'"
cQry+=" WHERE ZK_ANO      = '"+allTrim(str( year(dDataBase)))+"'"
cQry+="   AND ZK_MES      = '"+strzero(month(dDataBase),2)+"'"
cQry+="   AND ZK_MOEDA    = '"+allTrim(str(MV_PAR07))+"'"
If MV_PAR08 == MV_PAR09
	cQry+="    AND ZK_XGRPCLI = '"+MV_PAR08+"'"
EndIf
cQry+="   AND D_E_L_E_T_ <> '*'"

TcQuery cQry Alias "TSZK" New
If !Eof()
	lJaProc:=.t.
Else
	lJaProc:=.f.
EndIf
dbCloseArea()

If lJaProc
	If MV_PAR11 == 1 //Sim (Gravar Processamento)
		ApMsgInfo("Período informado já processado!")
		lProcessa:=.f.
	Else
		lProcessa:=.t.	
	EndIf
Else
	lProcessa:=.t.
EndIf

If lProcessa .and. !lJaProc
	SetRegua(10000)
	cQry := "SELECT DISTINCT A1_XGRPCLI,E1_MOEDA,A1_COD, A1_LOJA, A1_NOME, A1_EMAIL, A1_NREDUZ, E1_NUM, E1_PREFIXO,E1_TIPO, E1_EMIS1, "
	cQry += "                E1_REFGEF, E1_INVOICE, E1_VALOR, E1_SALDO, E1_MOEDA, E1_TXMOEDA, E1_VLCRUZ, E1_EMISSAO, E1_VENCREA, "
	cQry += "                E1_CLIENTE, E1_LOJA , E1_DTVARIA, E1_EMIS1"
	cQry += "  FROM " + RetSqlName("SA1") + " SA1, " + RetSqlName("SE1") + " SE1  "
	cQry += " WHERE SA1.D_E_L_E_T_ <> '*'"
	cQry += "   AND SE1.D_E_L_E_T_ <> '*'"
	cQry += "   AND E1_CLIENTE = A1_COD"
	cQry += "   AND E1_LOJA = A1_LOJA"
	cQry += "   AND E1_MOEDA = '"+allTrim(str(MV_PAR07))+"'"
	cQry += "   AND E1_INVOICE <> ' '"
	cQry += "   AND E1_FILIAL >= '" + MV_PAR05 + "' AND E1_FILIAL <= '" + MV_PAR06 + "'"
	cQry += "   AND E1_EMIS1 >= '" + DTOS(MV_PAR03) + "' AND E1_EMIS1 <= '" + DTOS(MV_PAR04) +"'"
	cQry += "   AND A1_XGRPCLI >= '" + MV_PAR08 +"' AND A1_XGRPCLI <= '" +  MV_PAR09 + "' "
	cQry += "  AND EXISTS (SELECT ZJ_XGRPCLI FROM "+RetSqlName("SZJ")+" SZJ WHERE ZJ_XGRPCLI = A1_XGRPCLI AND SZJ.D_E_L_E_T_ <> '*')"
	cQry += " ORDER BY A1_XGRPCLI, E1_MOEDA, E1_EMIS1, E1_INVOICE, E1_CLIENTE, E1_LOJA " 
	TcQuery cQry Alias "TSE1" New
	While !Eof()
		lInclui:=.f.
		lJaProc:=.t.
		nValor:=TSE1->E1_VALOR
/*
		If Empty(TSE1->E1_DTVARIA)
   	   		nValor := nValor * TSE1->E1_TXMOEDA
   	   	ELSE 
   	   		DbSelectArea("SM2")	
   	   	   	DbSetOrder(1)
   	   	   	If DbSeek(Stod(TSE1->E1_DTVARIA))
   	   	   		If TSE1->E1_MOEDA = 2	
	   	   	   		nValor := TSE1->E1_VALOR * SM2->M2_MOEDA2
	   	   	   	ElseIf TSE1->E1_MOEDA = 4	
	   	   	   	   	nValor := TSE1->E1_VALOR * SM2->M2_MOEDA4
	   	   	   	EndIF
   	   	   	EndIf
   	   	EndIf
*/
	   	If TSE1->E1_TIPO == "NCC"
			nValor*=(-1)
	   	EndIF

		dbSelectArea("cDbf")
		lInclui:=!dbSeek(TSE1->A1_XGRPCLI+alltrim(str(TSE1->E1_MOEDA)))
		RecLock("cDbf",lInclui)
			If lInclui
				cDbf->XGRPCLI	:=	TSE1->A1_XGRPCLI
				cDbf->COD		:=  Posicione("SZJ",2,xFilial("SZJ")+TSE1->A1_XGRPCLI,"ZJ_COD")
				cDbf->DESC		:=  Posicione("SZJ",2,xFilial("SZJ")+TSE1->A1_XGRPCLI,"ZJ_DESC")
				cDbf->MOEDA		:=	alltrim(str(TSE1->E1_MOEDA))
				cDbf->ANO		:=	allTrim(str(year(dDataBase)))
				cDbf->MES		:=	strzero(month(dDataBase),2)
				cDbf->SOLDE		:=	0
				cDbf->GRAVA		:=  "S"
			EndIf
			cDbf->MONT		+=	nValor
		MsUnLock()
		dbSelectArea("TSE1")
		dbSkip()
	EndDo
	dbSelectArea("TSE1")
	dbCloseArea()
	
	cQry := "SELECT DISTINCT A1_XGRPCLI,E1_MOEDA,A1_COD, A1_LOJA, A1_NOME, A1_EMAIL, A1_NREDUZ, E1_NUM, E1_PREFIXO,E1_TIPO, E1_EMIS1, "
	cQry += "                E1_REFGEF, E1_INVOICE, E1_VALOR, E1_SALDO, E1_MOEDA, E1_TXMOEDA, E1_VLCRUZ, E1_EMISSAO, E1_VENCREA, "
	cQry += "                E1_CLIENTE, E1_LOJA , E1_DTVARIA"
	cQry += "  FROM " + RetSqlName("SA1") + " SA1, " + RetSqlName("SE1") + " SE1  "
	cQry += " WHERE SA1.D_E_L_E_T_ <> '*'"
	cQry += "   AND SE1.D_E_L_E_T_ <> '*'"
	cQry += "   AND E1_CLIENTE = A1_COD"
	cQry += "   AND E1_LOJA = A1_LOJA"
	cQry += "   AND E1_MOEDA = '"+allTrim(str(MV_PAR07))+"'"
	cQry += "   AND E1_INVOICE <> ' '"
	cQry += "   AND E1_SALDO <> 0"
	cQry += "   AND E1_FILIAL >= '" + MV_PAR05 + "' AND E1_FILIAL <= '" + MV_PAR06 + "'"
	cQry += "   AND E1_EMISSAO >= '" + DTOS(MV_PAR01) + "' AND E1_EMISSAO <= '" + DTOS(MV_PAR02) +"'"
	cQry += "   AND A1_XGRPCLI >= '" + MV_PAR08 +"' AND A1_XGRPCLI <= '" +  MV_PAR09 + "' "
	cQry += "  AND EXISTS (SELECT ZJ_XGRPCLI FROM "+RetSqlName("SZJ")+" SZJ WHERE ZJ_XGRPCLI = A1_XGRPCLI AND SZJ.D_E_L_E_T_ <> '*')"
	cQry += " ORDER BY A1_XGRPCLI, E1_MOEDA, E1_EMISSAO, E1_INVOICE, E1_CLIENTE, E1_LOJA " 
	TcQuery cQry Alias "TSE1" New
	While !Eof()
		lInclui:=.f.
		lJaProc:=.t.
		nSaldo:=TSE1->E1_SALDO
/*
		If Empty(TSE1->E1_DTVARIA)
   	   		nSaldo := nSaldo * TSE1->E1_TXMOEDA
   	   	ELSE 
   	   		DbSelectArea("SM2")	
   	   	   	DbSetOrder(1)
   	   	   	If DbSeek(Stod(TSE1->E1_DTVARIA))
   	   	   		If TSE1->E1_MOEDA = 2	
	   	   	   		nSaldo := TSE1->E1_SALDO * SM2->M2_MOEDA2
	   	   	   	ElseIf TSE1->E1_MOEDA = 4	
	   	   	   	   	nSaldo := TSE1->E1_SALDO * SM2->M2_MOEDA4
	   	   	   	EndIF
   	   	   	EndIf
   	   	EndIf
*/
	   	If TSE1->E1_TIPO == "NCC"
			nSaldo*=(-1)
	   	EndIF

		dbSelectArea("cDbf")
		lInclui:=!dbSeek(TSE1->A1_XGRPCLI+alltrim(str(TSE1->E1_MOEDA)))
		RecLock("cDbf",lInclui)
			If lInclui
				cDbf->XGRPCLI	:=	TSE1->A1_XGRPCLI
				cDbf->COD		:=  Posicione("SZJ",2,xFilial("SZJ")+TSE1->A1_XGRPCLI,"ZJ_COD")
				cDbf->DESC		:=  Posicione("SZJ",2,xFilial("SZJ")+TSE1->A1_XGRPCLI,"ZJ_DESC")
				cDbf->MOEDA		:=	alltrim(str(TSE1->E1_MOEDA))
				cDbf->ANO		:=	allTrim(str(year(dDataBase)))
				cDbf->MES		:=	strzero(month(dDataBase),2)
				cDbf->MONT		:=	0
				cDbf->GRAVA		:=  "S"
			EndIf
			cDbf->SOLDE		+=	nSaldo
		MsUnLock()
		dbSelectArea("TSE1")
		dbSkip()
	EndDo
	dbSelectArea("TSE1")
	dbCloseArea()
EndIf	

If lProcessa
/*
	cQry:="SELECT * "
	cQry+="  FROM "+RetSqlName("SZK")
//	cQry+=" WHERE ZK_FILIAL   = '"+xFilial("SZK")                  +"'"
	cQry+=" WHERE ZK_XGRPCLI BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"'"
	cQry+="   AND ZK_MOEDA    = '"+allTrim(str(MV_PAR07))+"'"
	cQry+="   AND ZK_ANO      = '"+allTrim(str( year(dDataBase)))  +"'"
*/
	cQry:="SELECT ZK_XGRPCLI,ZK_MOEDA,ZK_ANO,ZK_MES,sum(ZK_MONT) AS ZK_MONT ,sum(ZK_SOLDE) AS ZK_SOLDE"
	cQry+="  FROM "+RetSqlName("SZK")
	cQry+=" WHERE ZK_XGRPCLI BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"'"
	cQry+="   AND ZK_MOEDA    = '"+allTrim(str(MV_PAR07))+"'"
	cQry+="   AND ZK_ANO      = '"+allTrim(str( year(dDataBase)))  +"'"
	If !lJaProc
		cQry+="   AND ZK_MES     <> '"+strzero(month(dDataBase),2)     +"'"
	EndIf
	cQry+="   AND D_E_L_E_T_ <> '*'"
	cQry+=" GROUP BY ZK_XGRPCLI,ZK_MOEDA,ZK_ANO,ZK_MES"
	cQry+=" ORDER BY ZK_XGRPCLI,ZK_MOEDA,ZK_ANO,ZK_MES"
	TcQuery cQry Alias "TSZK" New
	While !Eof()
		dbSelectArea("cDbf")
		RecLock("cDbf",.t.)
			cDbf->XGRPCLI	:=	TSZK->ZK_XGRPCLI
			cDbf->COD		:=  Posicione("SZJ",2,xFilial("SZJ")+TSZK->ZK_XGRPCLI,"ZJ_COD")
			cDbf->DESC		:=  Posicione("SZJ",2,xFilial("SZJ")+TSZK->ZK_XGRPCLI,"ZJ_DESC")
			cDbf->MOEDA		:=	alltrim(str(TSZK->ZK_MOEDA))
			cDbf->ANO		:=	TSZK->ZK_ANO
			cDbf->MES		:=	TSZK->ZK_MES
			cDbf->MONT		:=	TSZK->ZK_MONT
			cDbf->SOLDE		:=	TSZK->ZK_SOLDE
			cDbf->GRAVA		:=  "N"
		MsUnLock()
		dbSelectArea("TSZK")
		dbSkip()
	EndDo
	dbSelectArea("TSZK")
	dbCloseArea()
	dbSelectArea("cDbf")
	SetRegua(RecCount())
	dbGoTop()
	aTrime:=array(4,2)
	aTrime[1][1]:=0
	aTrime[1][2]:=0
	aTrime[2][1]:=0
	aTrime[2][2]:=0
	aTrime[3][1]:=0
	aTrime[3][2]:=0
	aTrime[4][1]:=0
	aTrime[4][2]:=0
	cChave1:=cDbf->XGRPCLI+cDbf->MOEDA
	cChave2:=cChave1
	
	cBkMes:=""
	cBkTri:=""
	lFirst:=.t.
	cNewFile:=""
	nMesAnt:=0
	cAnoAnt:=""
	While !EOF()
	    IncRegua()
		aAtt:={}
		aAtt:=fFindAtt(cDbf->XGRPCLI)
		cMon:=substr(cMonth(ctod("01/"+cDbf->MES+"/00")),1,3)+"/"+cDbf->ANO
		nTrimes:=VAL(cDbf->MES)/3
		nX:=1
		If nTrimes <=1
			nX:=1
		ElseIf nTrimes > 1 .and. nTrimes <=2
			nX:=2
		ElseIf nTrimes > 2 .and. nTrimes <=3
			nX:=3
		ElseIf nTrimes > 3 .and. nTrimes <=4
			nX:=4
		EndIf

		aTrime[nX][1]+=cDbf->MONT
		aTrime[nX][2]+=cDbf->SOLDE
		nMont :=aTrime[1][1]+aTrime[2][1]+aTrime[3][1]+aTrime[4][1]
		nSolde:=aTrime[1][2]+aTrime[2][2]+aTrime[3][2]+aTrime[4][2]
		
		If MV_PAR07 = 1
			cDescM := "BRL"
		ElseIf MV_PAR07 = 2
			cDescM := "USD"
		ElseIf MV_PAR07 = 3
			cDescM := "UFIR"
		ElseIf MV_PAR07 = 4
			cDescM := "EUR"
		ElseIf MV_PAR07 = 5
			cDescM := "" //FRANCO
		EndIf    
		If lFirst
			cNewFile:=cDbf->COD+"-"+cDbf->DESC
			lFirst:=.f.
			cFileOpen := "D:\relato\Modelo\recapitulatif.dot"
			OLE_CloseLink( )   
			oWord := OLE_CreateLink('TMsOleWord97')		
			OLE_NewFile( oWord, cFileOpen )
		EndIf

		OLE_SetDocumentVar( oWord, 'VARMOEDA' 		, cDescM) //cDbf->MOEDA 				)
		OLE_SetDocumentVar( oWord, 'VARCLIENTE'		, cDbf->COD+" "+cDbf->DESC 	)
		OLE_SetDocumentVar( oWord, 'VARRESPON'		, alltrim(MV_PAR13)			)
		OLE_SetDocumentVar( oWord, 'VARNOMECONTATO'	, alltrim(aAtt[1,1])		)
		OLE_SetDocumentVar( oWord, 'VARTEL01'  		, alltrim(MV_PAR14)			)
		OLE_SetDocumentVar( oWord, 'VARTEL02'  		, alltrim(aAtt[1,2])		)
		OLE_SetDocumentVar( oWord, 'VARFAX01'  		, alltrim(MV_PAR15)			)
		OLE_SetDocumentVar( oWord, 'VARFAX02'		, alltrim(aAtt[1,3])		)

//                    Jan/2006      99.999.999.999,99  99.999.999.999,99        -              -      -       -  99.999.999.999,99        -
//					  TOTAL TRIM 01 99.999.999.999,99  99.999.999.999,99        -              -      -       -  99.999.999.999,99        -
//					  CUMUL ANNUEL  99.999.999.999,99  99.999.999.999,99        -              -      -       -  99.999.999.999,99        -
		cDetalhe:=cMon+space(6)+Transform(cDbf->MONT,"@E 99,999,999,999.99") +space(2)+Transform(cDbf->MONT,"@E 99,999,999,999.99") +"        -              -      -       -  "+Transform(cDbf->SOLDE,"@E 99,999,999,999.99")  +"        -"
		OLE_SetDocumentVar( oWord, 'VARM'+cDbf->MES	, cDetalhe					)
		cBkMes+=cDbf->MES+"|"
		nMesAnt:=val(cDbf->MES)
		cAnoAnt:=cDbf->ANO
		dbSelectArea("cDbf")
	   	dbSkip() // Avanca o ponteiro do registro no arquivo
		lImpTot:=.f.
		If !Eof()
			cChave2:=cDbf->XGRPCLI+cDbf->MOEDA
			If cChave1 != cChave2
				lImpTot:=.t.
			Else
				lImpTot:=.f.
			EndIf
		Else
			lImpTot:=.t.
		EndIf
		If lImpTot
			cDetalhe:="CUMUL ANNUEL  "+Transform(nMont,"@E 99,999,999,999.99") +space(2)+Transform(nMont,"@E 99,999,999,999.99") +"        -              -      -       -  "+Transform(nSolde,"@E 99,999,999,999.99")  +"        -"
			OLE_SetDocumentVar( oWord, 'VARTOTAL'		, cDetalhe 				)
			For nX:=1 to 12
				_mes:=strzero(nX,2)
				If !(_mes $ cBkMes)
					cDetalhe:=substr(cMonth(ctod("01/"+_mes+"/00")),1,3)+"/"+alltrim(str(year(dDataBase)))+"                      -                 -         -              -      -       -                 -         -"
					OLE_SetDocumentVar( oWord, 'VARM'+_mes	, cDetalhe					)
				EndIf
			Next nX
			cBkMes:=cDbf->MES+"|"
			
			For nX:=1 to 4
				_tri:=alltrim(str(nX))
				If aTrime[nX,1]+aTrime[nX,2] == 0
					cDetalhe:="TOTAL TRIM 0"+_tri+"                 -                 -         -              -      -       -                 -         -"
				Else
					cDetalhe:="TOTAL TRIM 0"+_tri+" "+Transform(aTrime[nX][1],"@E 99,999,999,999.99") +space(2)+Transform(aTrime[nX][1],"@E 99,999,999,999.99") +"        -              -      -       -  "+Transform(aTrime[nX][2],"@E 99,999,999,999.99")  +"        -"
				EndIf
				OLE_SetDocumentVar( oWord, 'VARTM'+_tri		, cDetalhe)
			Next nX
			OLE_UpDateFields( oWord )			

			lFirst:=.t.
			cChave1:=cDbf->XGRPCLI+cDbf->MOEDA
			cChave2:=cChave1
			aTrime[1][1]:=0
			aTrime[1][2]:=0
			aTrime[2][1]:=0
			aTrime[2][2]:=0
			aTrime[3][1]:=0
			aTrime[3][2]:=0
			aTrime[4][1]:=0
			aTrime[4][2]:=0
		   	If mv_par10==1 //Impressora
			   	OLE_SetProperty( oWord, '208', .F. )
			   	OLE_PrintFile( oWord )
			   	OLE_CloseLink( oWord )	   
		   	Elseif mv_par10 == 2 // Salvar
		      	cFileSave := SubStr(cFileOpen,1,At(".",Trim(cFileOpen))-1)
		      	OLE_SaveAsFile( oWord, "D:\Relato\Modelo\Recapitulatif-" +allTRim(cNewFile)+".doc" )
		      	OLE_CloseLink( oWord )            
			Endif
		EndIf
	EndDo

EndIf

If MV_PAR11 == 1 //Sim
	fSaveSZK()
EndIf

If FILE(cDbf+".DBF")     //Elimina o arquivo de trabalho
	dbSelectArea("cDbf")
    dbCloseArea()
    Ferase(cDbf+".DBF")
    Ferase("cInd1"+OrdBagExt())
EndIf

/*
If MV_PAR10 == 1 //Microsiga
	SET DEVICE TO SCREEN

	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif

	MS_FLUSH()
EndIf
*/
Return


Static Function fFindAtt(pCliente)
Local aAtt:={}
Local cFilAc8:=""
Local cFilSU5:=""
dbSelectArea("AC8")
cFilAC8:=xFilial("AC8")
dbSelectArea("SU5")
cFilSU5:=xFilial("SU5")
cQry:="SELECT U5_CONTAT,U5_FONE,U5_FAX"
cQry+="  FROM "+RetSqlName("SU5")
cQry+=" WHERE U5_FILIAL = '"+cFilSU5+"'"
cQry+="   AND U5_CODCONT = (SELECT AC8_CODCON"
cQry+="                       FROM "+RetSqlName("AC8")
cQry+="                      WHERE AC8_FILIAL ='"+cFilAC8+"'"
cQry+="                        AND AC8_ENTIDA ='SA1'"
cQry+="                        AND AC8_CODENT ='"+pCliente+"'"
cQry+="                        AND D_E_L_E_T_ <> '*'"
cQry+="		                )"
cQry+="   AND D_E_L_E_T_ <> '*'"
TcQuery cQry Alias "TSU5" New
If !Eof()
	aAdd(aAtt,{TSU5->U5_CONTAT,TSU5->U5_FONE,TSU5->U5_FAX })
Else
	aAdd(aAtt,{"","","" })
EndIf
dbCloseArea()
Return aAtt

Static Function fSaveSZK()
dbSelectArea("cDbf")
dbGoTop()
While !Eof()
	If cDbf->GRAVA == "S"
		dbSelectArea("SZK")
		RecLock("SZK",.T.)
			SZK->ZK_FILIAL	:= 	xFilial("SZK")
			SZK->ZK_XGRPCLI	:=	cDbf->XGRPCLI
			SZK->ZK_MOEDA	:=	val(cDbf->MOEDA)
			SZK->ZK_ANO		:=	cDbf->ANO		
			SZK->ZK_MES		:=	cDbf->MES		
			SZK->ZK_MONT	:=	cDbf->MONT		
			SZK->ZK_SOLDE	:=	cDbf->SOLDE		
		MsUnLock()
	EndIf
	dbSelectArea("cDbf")
	dbSkip()
EndDo
Return