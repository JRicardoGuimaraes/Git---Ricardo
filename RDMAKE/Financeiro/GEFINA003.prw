#include "rwmake.ch"
#Include "Topconn.Ch"

/*************************************************************************************
* Programa.....: GEFINA003()                                                         *
* Autor........: Marcelo Aguiar Pimentel                                             *
* Data.........: 21/02/2007                                                          *
* Descricao....: Status dos principais clientes P.M.R.                               *
*                                                                                    *
* Parametros...:                                                                     *
*                MV_PAR01	=	Unidade Operacional                                  *
*                MV_PAR02	=	Data Referencia                                      *
*                MV_PAR03	=	Da Emissao                                           *
*                MV_PAR04	=	Ate a Emissao                                        *
*                MV_PAR05	=	Do Vencimento                                        *
*                MV_PAR06	=	Ate o Vencimento                                     *
*                MV_PAR07	=	Grupo                                                *
*                MV_PAR08	=	Gravar Status                                        *
*                MV_PAR09	=	Imprimir C.C. vazio(SIM/NAO)                         *
*                MV_PAR10	=	Imp.UO. nao encontra(SIM/NAO)                        *
*                                                                                    *
**************************************************************************************
* Alterado por.:                                                                     *
* Data.........:                                                                     *
* Motivo.......:                                                                     *
*                                                                                    *
*************************************************************************************/

User Function GEFINA03()
Local cDesc1		:=	"Este programa tem como objetivo imprimir relatorio "
Local cDesc2		:=	"de acordo com os parametros informados pelo usuario."
Local cDesc3		:=	"trazendo o Status dos principais Clientes P.M.R."
Local cPict			:=	""
Local titulo		:=	"Status dos principais Clientes - P.M.R"
//                       0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22        23        24        25        26        27
//                       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                       999       99999999  AAAAAAAAAAAAAAAAAAAA  AAAAA  999,999,999,999  999,999,999,999  99999  999,999,999,999  999,999,999,999  99999   999,999,999,999
//Private aCol		:=  {00    ,07          ,20                   ,42    ,49              ,66              ,83    ,90              ,107             ,124    ,132}
//						"                                                        DEC/2006                                           JAN/2007"
Local Cabec2		:=	"CLASS  COD.CLIENTE  CLIENTE                U.O.        V.V           SALDO C/C     P.M.R        V.V            SALDO C/C    P.M.R    Total Carteira"
Local Cabec1		:=	""
Local imprime		:=	.T.
Local aOrd			:=	{}

Private cSpcCb1		:= space(55)
Private cSpcCb1A	:= space(51)
Private nLin			:=	80
Private aCol		:=  {00    ,07          ,20                   ,42    ,49              ,66              ,83    ,90              ,107             ,124    ,132}
Private lEnd		:=	.F.
Private lAbortPrint	:=	.F.
Private CbTxt		:=	""
Private limite		:=	220
Private tamanho		:=	"G"
Private nomeprog	:=	"GEFA03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey	:=	0
Private cbtxt		:=	Space(10)
Private cbcont		:=	00
Private CONTFL		:=	01
Private m_pag		:=	01
Private cPerg		:=	"GEFA03" // Coloque aqui o nome do arquivo usado para impressao em disco
Private wnrel		:=	"GEFA03" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString		:= "SZB"
Private cAnoAtu		:= ""
Private cMesAtu		:= ""
Pergunte(cPerg,.f.)

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
If nLastKey == 27
	Return
Endif
lProcessa:=.t.
While .t.
	cAnoAtu:=alltrim(str(year(MV_PAR02)))
	cMesAtu:=strzero(month(MV_PAR02),2)
	// Busca a Evolucao Saldo Dívida do Mes anterior
	cQry := "SELECT ZB_UO"
	cQry += "  FROM "+ RetSqlName("SZB")
	cQry += " WHERE ZB_ANO      = '"+cAnoAtu      +"'"	
	cQry += "   AND ZB_MES      = '"+cMesAtu      +"'"	
	cQry += "   AND D_E_L_E_T_ <> '*'"
	TcQuery cQry Alias "TSZB" New
	lEof:=Eof()
	dbCloseArea()
	If !lEof .and. MV_PAR08 = 1
		MsgAlert("A data de referência já foi processada."+chr(10)+"Por favor, revise o parametro escolhido!","Atençao!")		
		If !Pergunte(cPerg,.t.)
			lProcessa:=.f.
			exit
		EndIf
	Else
		exit
	EndIf
EndDo

If lProcessa

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
	   Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

//	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo) },Titulo)	
EndIf
Return


/**************************************************************************
* Funcao....: RunReport                                                   *
* Autor.....: Marcelo Aguiar Pimentel                                     *
* Data......: 21/02/2007                                                  *
* Descricao.: Funcao de processamento do relatório                        *
*                                                                         *
**************************************************************************/
//Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Static Function RunReport(Cabec1,Cabec2,Titulo)
Local nOrdem
Local aEstruUO	:=	{}	//Estrutura para o DBF Contendo os Valores por UO
Local aTam
Local aTamP
Local cInd1
Local cQry
Local aDados	:=	array(6)
Local cAnoAtu
Local cMesAtu
Local cAnoAnt
Local cMesAnt
Local nVnd
Local nVndP1
Local nVndP2
Local nSldP1
Local nSldP2
Local nVncP1
Local nVncP2
Local nTotCar:=0
Local nPMR
Local n30P1
Local n30P2
Local n60P1
Local n60P2
Local n90P1
Local n90P2
Local n120P1
Local n120P2
Local nM120P1
Local nM120P2

Private cDbfUO:=""
lJaProc:=.f.
If MV_PAR08 = 2
	cAnoAtu:=alltrim(str(year(MV_PAR02)))
	cMesAtu:=strzero(month(MV_PAR02),2)
	cQry := "SELECT count(*) AS QUANT"
	cQry += "  FROM "+ RetSqlName("SZB")
	cQry += " WHERE ZB_ANO      = '"+cAnoAtu      +"'"	
	cQry += "   AND ZB_MES      = '"+cMesAtu      +"'"	
	cQry += "   AND D_E_L_E_T_ <> '*'"
	TcQuery cQry Alias "TSZB" New
	If TSZB->QUANT > 0
		lJaProc:=.t.
	EndIf
	dbCloseArea()
EndIf

dbSelectArea("SZB")          
aTam := TamSX3("ZB_FAT")			// Tam 6 Dec 0 Pict @E 999999
	
aAdd(aEstruUO, { "XGRPCLI"  , "C",      8 ,       0 } )
aAdd(aEstruUO, { "NREDUZ"   , "C",     20 ,       0 } )
aAdd(aEstruUO, { "UO"       , "C",      5 ,       0 } )
aAdd(aEstruUO, { "Ano"      , "C",      4 ,       0 } )
aAdd(aEstruUO, { "MES"      , "C",      2 ,       0 } )
aAdd(aEstruUO, { "FAT"      , "N",aTam[1] , aTam[2] } )
aAdd(aEstruUO, { "SLDCC"    , "N",aTam[1] , aTam[2] } )
aAdd(aEstruUO, { "PMR"      , "N",aTam[1] , aTam[2] } )
	
cDbfUO	:= criatrab(aEstruUO)
Use &cDbfUO Alias cDbfUO New
If MV_PAR08 = 1 .or. (MV_PAR08 = 2 .AND. !lJaProc)// Processa Saldo do mes da data de referencia
	cInd1	:= CriaTrab("",.F.)
	IndRegua("cDbfUO",cInd1,"XGRPCLI+UO",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
	dbSetIndex( cInd1 +OrdBagExt())
	cQry := " SELECT  SA1.A1_XGRPCLI, SUBSTRING(E1_CCONT,2,2) AS UO, "
	cQry += "         SUM(SE1.E1_VALOR) AS E1_VALOR"

	cQry += "   FROM "+RetSqlName("SE1")+" SE1,"+RetSqlName("SA1")+" SA1"
	cQry += "  WHERE SE1.D_E_L_E_T_ <> '*'"
	cQry += "    AND SA1.D_E_L_E_T_ <> '*'"
	cQry +="  AND E1_EMISSAO >= '" +DTOS(ctod("01/"+str(month(MV_PAR02))+"/"+str(year(MV_PAR02))))+"'"        
	cQry +="  AND E1_EMISSAO <= '" +DTOS(MV_PAR02)+"'"
	cQry += "    AND SE1.E1_PREFIXO <> 'FAT'"
	cQry += "    AND SE1.E1_PREFIXO <> 'INV'"
	cQry += "    AND SE1.E1_TIPO <> 'NCC'"
	cQry += "    AND SE1.E1_CCONT <> ' '  "
	cQry += "    AND SE1.E1_MOEDA = '1'"
	cQry += "    AND E1_CLIENTE = A1_COD"
	cQry += "    AND E1_LOJA    = A1_LOJA"
	Do Case
	   Case mv_par01 = 1  //RDVM
			cQry += "   AND (SUBSTRING(E1_CCONT,2,2) = '01' OR SUBSTRING(E1_CCONT,2,2) = '02')"
	   Case mv_par01 = 2 
			cQry += "   AND SUBSTRING(E1_CCONT,2,2) = '21'"
	   Case mv_par01 = 3            
			cQry += "   AND SUBSTRING(E1_CCONT,2,2) = '11'"
	   Case mv_par01 = 4  //RMA
			cQry += "   AND (SUBSTRING(E1_CCONT,2,2) = '22' OR SUBSTRING(E1_CCONT,2,2) = '23')"
	EndCase				
	If !Empty(MV_PAR07)
		cQry += " AND A1_GRUPO IN ( " + AllTrim(MV_PAR07) + ")"				        
	EndIf
//	cQry += "    GROUP BY SA1.A1_XGRPCLI,E1_CCONT,SE1.E1_CLIENTE, SE1.E1_LOJA,SA1.A1_NREDUZ"
	cQry += "    GROUP BY SA1.A1_XGRPCLI,SUBSTRING(E1_CCONT,2,2)"	
	cQry += "    ORDER BY SA1.A1_XGRPCLI,SUBSTRING(E1_CCONT,2,2)"//,SE1.E1_CLIENTE, SE1.E1_LOJA,SA1.A1_NREDUZ"
 
	TcQuery cQry Alias "TSE1" New
//	Count To nTotal ; dbGoTop()
	cAnoAtu:=alltrim(str(year(MV_PAR02)))
	cMesAtu:=strzero(month(MV_PAR02),2)
	cMesAnt:=strzero( month( ctod("01/"+str(month(mv_par02))+"/"+str(year(mv_par02)))-1) ,2 )
	cAnoAnt:=strzero( year(ctod("01/"+str(month(mv_par02))+"/"+str(year(mv_par02)))-1),4)

	SetRegua(RecCount())
	While !Eof()
		IncRegua()
		cUO:= TSE1->UO
		Do Case
		   Case cUO = "01" .OR. cUO = "02"
		        cUO := "RDVM"
		   Case cUO = "21" 
		        cUO := "ILI"
		   Case cUO = "11" 
		        cUO := "RMLAP"
		   Case cUO = "22" .OR. cUO = "23" 
		        cUO := "RMA"
		   OTHERWISE
				If MV_PAR10 = 1 // Imprimir UO nao encontrada Sim
					If !Empty(cUO)
						cUO:="SUO"
					Else
				        cUO := "SCC" // Sem C.Custo
						If MV_PAR09 = 2 // Imprimir C.C. Vazio Nao
							dbSelectArea("TSE1")
							dbSkip()
							loop		
						EndIf
				 	EndIf
				Else
					dbSelectArea("TSE1")
					dbSkip()
					loop		
				EndIf
		EndCase

		aDados[01] := cUO

		cQry:="SELECT A1_NREDUZ "
		cQry+="  FROM "+RetSqlName("SA1")
		cQry+=" WHERE A1_XGRPCLI  = '"+TSE1->A1_XGRPCLI+"'"
		cQry+="   AND D_E_L_E_T_ <> '*'"
		cNome:=""
		TcQuery cQry Alias "TSA1" New
			cNome := TSA1->A1_NREDUZ
		dbCloseArea()
		
		aDados[03] := TSE1->E1_VALOR // FAT
		aDados[04] := 0 // SALDO C/C
		aDados[05] := 0 // PMR
		dbSelectArea("cDbfUO")
		If !dbSeek(TSE1->A1_XGRPCLI+cUO)
			RecLock("cDbfUO",.T.)
				cDbfUO->UO		:= cUO
				cDbfUO->XGRPCLI	:= TSE1->A1_XGRPCLI
				cDbfUO->NREDUZ	:= cNome
				cDbfUO->Ano		:= cAnoAtu
				cDbfUO->MES		:= cMesAtu
				cDbfUO->FAT		:= ROUND(aDados[03],0)
				cDbfUO->SLDCC	:= aDados[04]
				cDbfUO->PMR		:= aDados[05]
			MsUnLock()
		Else
			RecLock("cDbfUO",.F.)
				cDbfUO->FAT		+= ROUND(aDados[03],0)
			MsUnLock()
		EndIf
		dbSelectArea("TSE1")
		dbSkip()
	EndDo
	dbSelectArea("TSE1")
	dbCloseArea()
	dbSelectArea("cDbfUO")
	If cDbfUO->(RecCount()) > 0
		cQry:="SELECT SA1.A1_XGRPCLI, SUBSTRING(E1_CCONT,2,2) AS UO,"
		cQry+="       SUM(SE1.E1_SALDO) AS E1_SALDO"
		cQry+="  FROM "+RetSqlName("SE1")+" SE1,"+RetSqlName("SA1")+" SA1"
		cQry+=" WHERE SE1.D_E_L_E_T_ <> '*'"
		cQry+="   AND SA1.D_E_L_E_T_ <> '*'"
		cQry+="   AND E1_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
		cQry+="   AND E1_VENCREA BETWEEN '"+DTOS(mv_par05)+"' AND '"+DTOS(mv_par06)+"'"
		cQry+="   AND E1_SALDO <> 0 "
		cQry+="   AND E1_MOEDA = '1'"
		cQry+="   AND SE1.E1_TIPO <> 'NCC'"
		If MV_PAR09 = 2 // Nao
			cQry+="  AND SE1.E1_CCONT <> ' '"
		EndIf
		cQry+="   AND E1_CLIENTE = A1_COD"
		cQry+="   AND E1_LOJA    = A1_LOJA"
		If !Empty(MV_PAR07)
			cQry += " AND A1_GRUPO IN ( " + AllTrim(MV_PAR07) + ")"				        
		EndIf
		Do Case
		   Case mv_par01 = 1  //RDVM
				cQry += "   AND (SUBSTRING(E1_CCONT,2,2) = '01' OR SUBSTRING(E1_CCONT,2,2) = '02')"
		   Case mv_par01 = 2 
				cQry += "   AND SUBSTRING(E1_CCONT,2,2) = '21'"
		   Case mv_par01 = 3            
				cQry += "   AND SUBSTRING(E1_CCONT,2,2) = '11'"
		   Case mv_par01 = 4  //RMA
				cQry += "   AND (SUBSTRING(E1_CCONT,2,2) = '22' OR SUBSTRING(E1_CCONT,2,2) = '23')"
		EndCase				
		cQry+="GROUP BY SA1.A1_XGRPCLI,SUBSTRING(E1_CCONT,2,2)"
		cQry+="ORDER BY SA1.A1_XGRPCLI,SUBSTRING(E1_CCONT,2,2)"
		TcQuery cQry Alias "TSE1" New
		nTotCar:=0
		While !Eof()
			IncRegua()
			dbSelectArea("cDbfUO")
			cUO:= TSE1->UO
			Do Case
			   Case cUO = "01" .OR. cUO = "02"
			        cUO := "RDVM"
			   Case cUO = "21" 
			        cUO := "ILI"
			   Case cUO = "11" 
			        cUO := "RMLAP"
			   Case cUO = "22" .OR. cUO = "23" 
			        cUO := "RMA"
			   OTHERWISE
					If MV_PAR10 = 1 // Imprimir UO nao encontrada Sim
						If !Empty(cUO)
							cUO:="SUO"
						Else
					        cUO := "SCC" // Sem C.Custo
							If MV_PAR09 = 2 // Imprimir C.C. Vazio Nao
								dbSelectArea("TSE1")
								dbSkip()
								loop		
							EndIf
					 	EndIf
					Else
						dbSelectArea("TSE1")
						dbSkip()
						loop		
					EndIf
			EndCase
	
			aDados[01] := cUO
			If dbSeek(TSE1->A1_XGRPCLI+cUO)
				aDados[04]:=Round(TSE1->E1_SALDO,0)
				aDados[03]:=cDbfUO->FAT
				// Busca a Evolucao Saldo Dívida do Mes anterior
				cQry := "SELECT ZB_SLD"
				cQry += "  FROM "+ RetSqlName("SZB")
				cQry += " WHERE ZB_UO       = '"+cDbfUO->UO     +"'"
				cQry += "   AND ZB_XGRPCLI  = '"+cDbfUO->XGRPCLI+"'"	
				cQry += "   AND ZB_ANO      = '"+cAnoAnt        +"'"	
				cQry += "   AND ZB_MES      = '"+cMesAnt        +"'"	
				cQry += "   AND D_E_L_E_T_ <> '*'"
				TcQuery cQry Alias "TSZB" New
				If !Eof()
		  			nPMR	:= (((aDados[04]+TSZB->ZB_SLD)/2)/aDados[03])*30
				Else
					nPMR	:= 0
				EndIf
				dbCloseArea()
	
				RecLock("cDbfUO",.F.)
					cDbfUO->SLDCC	+= aDados[04]
					cDbfUO->PMR		:= nPMR
				MsUnLock()
				nTotCar+=aDados[04]
			EndIf
			dbSelectArea("TSE1")
			dbSkip()
		EndDo
		dbSelectArea("TSE1")
		dbCloseArea()

		cQry:="SELECT SA1.A1_XGRPCLI, E1_MOEDA,SUBSTRING(E1_CCONT,2,2) AS UO, E1_SALDO,E1_DTVARIA,E1_TXMOEDA"
		cQry+="  FROM "+RetSqlName("SE1")+" SE1,"+RetSqlName("SA1")+" SA1"
		cQry+=" WHERE SE1.D_E_L_E_T_ <> '*'"
		cQry+="   AND SA1.D_E_L_E_T_ <> '*'"
		cQry+="   AND E1_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
		cQry+="   AND E1_VENCREA BETWEEN '"+DTOS(mv_par05)+"' AND '"+DTOS(mv_par06)+"'"
		cQry+="   AND E1_SALDO <> 0 "
		cQry+="   AND E1_MOEDA <> '1'"
		cQry+="   AND SE1.E1_TIPO <> 'NCC'"
		If MV_PAR09 = 2 // Nao
			cQry+="  AND SE1.E1_CCONT <> ' '"
		EndIf
		cQry+="   AND E1_CLIENTE = A1_COD"
		cQry+="   AND E1_LOJA    = A1_LOJA"
		If !Empty(MV_PAR07)
			cQry += " AND A1_GRUPO IN ( " + AllTrim(MV_PAR07) + ")"				        
		EndIf
		Do Case
		   Case mv_par01 = 1  //RDVM
				cQry += "   AND (SUBSTRING(E1_CCONT,2,2) = '01' OR SUBSTRING(E1_CCONT,2,2) = '02')"
		   Case mv_par01 = 2 
				cQry += "   AND SUBSTRING(E1_CCONT,2,2) = '21'"
		   Case mv_par01 = 3            
				cQry += "   AND SUBSTRING(E1_CCONT,2,2) = '11'"
		   Case mv_par01 = 4  //RMA
				cQry += "   AND (SUBSTRING(E1_CCONT,2,2) = '22' OR SUBSTRING(E1_CCONT,2,2) = '23')"
		EndCase				
		cQry+="ORDER BY SA1.A1_XGRPCLI,E1_MOEDA,SUBSTRING(E1_CCONT,2,2)"
		TcQuery cQry Alias "TSE1" New
//		nTotCar:=0
		While !Eof()
			IncRegua()
			dbSelectArea("cDbfUO")
			cUO:= TSE1->UO
			Do Case
			   Case cUO = "01" .OR. cUO = "02"
			        cUO := "RDVM"
			   Case cUO = "21" 
			        cUO := "ILI"
			   Case cUO = "11" 
			        cUO := "RMLAP"
			   Case cUO = "22" .OR. cUO = "23" 
			        cUO := "RMA"
			   OTHERWISE
					If MV_PAR10 = 1 // Imprimir UO nao encontrada Sim
						If !Empty(cUO)
							cUO:="SUO"
						Else
					        cUO := "SCC" // Sem C.Custo
							If MV_PAR09 = 2 // Imprimir C.C. Vazio Nao
								dbSelectArea("TSE1")
								dbSkip()
								loop		
							EndIf
					 	EndIf
					Else
						dbSelectArea("TSE1")
						dbSkip()
						loop		
					EndIf
			EndCase
	
			aDados[01] := cUO
			If dbSeek(TSE1->A1_XGRPCLI+cUO)
				aDados[04]:=TSE1->E1_SALDO
				aDados[03]:=cDbfUO->FAT
				If Empty(TSE1->E1_DTVARIA)
   	   				aDados[04] := aDados[04] * TSE1->E1_TXMOEDA
		   	   	Else 
		   	   		DbSelectArea("SM2")	
		   	   	   	DbSetOrder(1)
		   	   	   	If DbSeek(Stod(TSE1->E1_DTVARIA))
		   	   	   		If TSE1->E1_MOEDA = 2	
			   	   	   		aDados[04] := aDados[04] * SM2->M2_MOEDA2
			   	   	   	ElseIf TSE1->E1_MOEDA = 4	
			   	   	   	   	aDados[04] := aDados[04] * SM2->M2_MOEDA4
			   	   	   	EndIF
		   	   	   	EndIf
		   	   	EndIf
				aDados[04]:=Round(aDados[04],0)
				// Busca a Evolucao Saldo Dívida do Mes anterior
				cQry := "SELECT ZB_SLD"
				cQry += "  FROM "+ RetSqlName("SZB")
				cQry += " WHERE ZB_UO       = '"+cDbfUO->UO     +"'"
				cQry += "   AND ZB_XGRPCLI  = '"+cDbfUO->XGRPCLI+"'"	
				cQry += "   AND ZB_ANO      = '"+cAnoAnt        +"'"	
				cQry += "   AND ZB_MES      = '"+cMesAnt        +"'"	
				cQry += "   AND D_E_L_E_T_ <> '*'"
				TcQuery cQry Alias "TSZB" New
				If !Eof()
		  			nPMR	:= (((aDados[04]+TSZB->ZB_SLD)/2)/aDados[03])*30
				Else
					nPMR	:= 0
				EndIf
				dbCloseArea()
	
				RecLock("cDbfUO",.F.)
					cDbfUO->SLDCC	+= aDados[04]
					cDbfUO->PMR		:= nPMR
				MsUnLock()
				nTotCar+=aDados[04]
			EndIf
			dbSelectArea("TSE1")
			dbSkip()
		EndDo
		dbSelectArea("TSE1")
		dbCloseArea()
	EndIf

	dbSelectArea("cDbfUO")
	cInd1	:= CriaTrab("",.F.)
	IndRegua("cDbfUO",cInd1,"Str(FAT,17,0)",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
	dbSetIndex( cInd1 +OrdBagExt())
ElseIf MV_PAR08 = 2 .AND. lJaProc
	dbSelectArea("cDbfUO")
	cInd1	:= CriaTrab("",.F.)
	IndRegua("cDbfUO",cInd1,"Str(FAT,17,0)",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
	dbSetIndex( cInd1 +OrdBagExt())
	cAnoAtu:=alltrim(str(year(MV_PAR02)))
	cMesAtu:=strzero(month(MV_PAR02),2)
	cMesAnt:=strzero( month( ctod("01/"+str(month(mv_par02))+"/"+str(year(mv_par02)))-1) ,2 )
	cAnoAnt:=strzero( year(ctod("01/"+str(month(mv_par02))+"/"+str(year(mv_par02)))-1),4)
	cQry:="SELECT * FROM "+RetSqlName("SZB")
	cQry+=" WHERE ZB_ANO	= '"+cAnoAtu+"'"
	cQry+="   AND ZB_MES    = '"+cMesAtu+"'"
	cQry+="   AND D_E_L_E_T_ <> '*'"
	TcQuery cQry Alias "TSZB" New
	While !Eof()
		nTotCar+=TSZB->ZB_SLD // Saldo C/C Faz o somatório do total carteira
		RecLock("cDbfUO",.T.)
			cDbfUO->UO		:= TSZB->ZB_UO
			cDbfUO->XGRPCLI	:= TSZB->ZB_XGRPCLI
			cDbfUO->NREDUZ	:= TSZB->ZB_NOME
			cDbfUO->Ano		:= TSZB->ZB_ANO
			cDbfUO->MES		:= TSZB->ZB_MES
			cDbfUO->FAT		:= TSZB->ZB_FAT
			cDbfUO->SLDCC	:= TSZB->ZB_SLD
			cDbfUO->PMR		:= TSZB->ZB_PMR
		MsUnLock()
		dbSelectArea("TSZB")
		dbSkip()
	EndDo
	dbSelectArea("TSZB")
	dbCloseArea()
EndIf
cAnoAtu:=alltrim(str(year(MV_PAR02)))
cMesAtu:=strzero(month(MV_PAR02),2)

cUOAnt	:=	""
cXGRPCLI:=	""
titulo		:=	"Status dos principais Clientes - P.M.R"
dbSelectArea("cDbfUO")
SetRegua(cDbfUO->(RecCount()))
dbGoTop()
dbGoBottom()
nCont:=1

Cabec1:=cSpcCb1 +substr(cMonth(ctod("01/"+cMesAnt+"/00")),1,3)+"/"+cAnoAnt
Cabec1+=cSpcCb1A+substr(cMonth(ctod("01/"+cMesAtu+"/00")),1,3)+"/"+cAnoAtu
nSFat1:=0
nSFat2:=0
nSSld1:=0
nSSld2:=0
While !BOF()
	IncRegua()
	If lAbortPrint
    	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
 		Exit
   	Endif
   	
   	If nCont > 25
   		exit
   	EndIf

   	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      	nLin := 9
   	Endif

	cQry:="SELECT * FROM "+RetSqlName("SZB")
	cQry+=" WHERE ZB_ANO	  = '"+cAnoAnt		+"'"
	cQry+="   AND ZB_MES	  = '"+cMesAnt		+"'"
	cQry+="   AND ZB_XGRPCLI  = '"+cDbfUO->XGRPCLI+"'"
	cQry+="   AND ZB_UO		  = '"+cDbfUO->UO		+"'"
	cQry+="   AND D_E_L_E_T_ <> '*'"
	TcQuery cQry Alias "TSZB" New
	nSFat1+=TSZB->ZB_FAT
	nSSld1+=TSZB->ZB_SLD
	nSFat2+=cDbfUO->FAT
	nSSld2+=cDbfUO->SLDCC
	ImpDet( nCont,cDbfUO->XGRPCLI,cDbfUO->NREDUZ,cDbfUO->UO,TSZB->ZB_FAT,TSZB->ZB_SLD  ,TSZB->ZB_PMR, cDbfUO->FAT, cDbfUO->SLDCC, cDbfUO->PMR,nTotCar )
	nLin++

	dbCloseArea()

	dbSelectArea("cDbfUO")	
   	dbSkip(-1) // Avanca o ponteiro do registro no arquivo
   	nCont++
EndDo
nLin++
@nLin,aCol[04] PSAY "TOTAL"
@nLin,aCol[05] PSAY nSFat1 					Picture "@E 999,999,999,999"
@nLin,aCol[06] PSAY nSSld1 					Picture "@E 999,999,999,999"
@nLin,aCol[08] PSAY nSFat2 					Picture "@E 999,999,999,999"
@nLin,aCol[09] PSAY nSSld2 					Picture "@E 999,999,999,999"
nLin++
@nLin,aCol[06] PSAY (nSSld1/nTotCar)*100 	Picture "@E 99999999999.99%"
@nLin,aCol[09] PSAY (nSSld2/nTotCar)*100   	Picture "@E 99999999999.99%"

If MV_PAR08 = 1 .and. !lJaProc // Nao gravar saldo
	saveSZB()
EndIf
	
If FILE(cDbfUO+".DBF")     //Elimina o arquivo de trabalho
	dbSelectArea("cDbfUO")
    dbCloseArea()
    Ferase(cDbfUO+".DBF")
    Ferase("cInd1"+OrdBagExt())
EndIf

Set Device To Screen

If aReturn[5] = 1
   SET PRINTER TO
   dbCommit()   
//   dbCommitAll()
   OurSpool(wnrel)
Endif

MS_FLUSH() 


Return

/************************************************************************
* Funcao.....: SaveSZB()                                                *
* Autor......: Marcelo Aguiar Pimentel                                  *
* Data.......: 28/02/2007                                               *
* Descricao..: Funcao para salvar o processamento do faturmento do mes  *
*              de processamento.                                        *
*                                                                       *
************************************************************************/
Static Function SaveSZB()
dbSelectArea("SZB")
dbSetOrder(1)
dbSelectArea("cDbfUO")
dbGoTop()
SetRegua(cDbfUO->(RecCount()))
While !Eof()
	IncRegua()
	RecLock("SZB",.t.)
		SZB->ZB_FILIAL	:=xFilial("SZB")
		SZB->ZB_XGRPCLI	:=cDbfUO->XGRPCLI
		SZB->ZB_NOME	:=cDbfUO->NREDUZ
		SZB->ZB_UO		:=cDbfUO->UO
		SZB->ZB_ANO		:=cDbfUO->ANO
		SZB->ZB_MES		:=cDbfUO->MES
		SZB->ZB_FAT		:=cDbfUO->FAT
		SZB->ZB_SLD  	:=cDbfUO->SLDCC
		SZB->ZB_PMR		:=cDbfUO->PMR
	MsUnLock()
	dbSelectArea("cDbfUO")
	dbSkip()
EndDo
Return


Static Function ImpDet(pClass,pXGRPCLI,pNOME,pUO,pFAT1,pSLD1,pPMR1,pFAT2,pSLD2,pPMR2,pTotCar)
	If nCont = 1
		@nLin,aCol[11] PSAY pTotCar	Picture "@E 999,999,999,999"
	EndIf
	@nLin,aCol[01] PSAY pClass 		Picture "@E 99"
	@nLin,aCol[02] PSAY pXGRPCLI	Picture "@!"
	@nLin,aCol[03] PSAY pNOME   	Picture "@!"
	@nLin,aCol[04] PSAY pUO		 	Picture "@!"
	@nLin,aCol[05] PSAY pFAT1 	 	Picture "@E 999,999,999,999"
	@nLin,aCol[06] PSAY pSLD1 	 	Picture "@E 999,999,999,999"
	@nLin,aCol[07] PSAY pPMR1	 	Picture "@E 9999"
	@nLin,aCol[08] PSAY pFAT2 	 	Picture "@E 999,999,999,999"
	@nLin,aCol[09] PSAY pSLD2 	 	Picture "@E 999,999,999,999"
	@nLin,aCol[10] PSAY pPMR2	 	Picture "@E 9999"
Return