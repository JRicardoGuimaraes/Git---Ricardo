#include "rwmake.ch"
#Include "Topconn.Ch"


/*************************************************************************************
* Programa.....: GEFINA002()                                                         *
* Autor........: Marcelo Aguiar Pimentel                                             *
* Data.........: 21/02/2007                                                          *
* Descricao....: Evolução Saldo em Dívida                                            *
*                Relaciona o faturamento das U.O. por filial Mês-a-mês de todos   os *
*                títulos em reais menos o tipo ND.  Trazendo Vendas, Saldo, Vencidos *
*                                                                                    *
* Parametros...:                                                                     *
*                MV_PAR01	=	Unidade Operacional                                  *
*                MV_PAR02	=	Da Filial                                            *
*                MV_PAR03	=	Ate Filial                                           *
*                MV_PAR04	=	Data Referencia                                      *
*                MV_PAR05	=	Da Emissao                                           *
*                MV_PAR06	=	Ate a Emissao                                        *
*                MV_PAR07	=	Do Vencimento                                        *
*                MV_PAR08	=	Ate o Vencimento                                     *
*                MV_PAR09	=	Gravar saldo                                         *
*                                                                                    *
**************************************************************************************
* Alterado por.:                                                                     *
* Data.........:                                                                     *
* Motivo.......:                                                                     *
*                                                                                    *
*************************************************************************************/

User Function GEFINA002()
Local cDesc1		:=	"Este programa tem como objetivo imprimir relatorio "
Local cDesc2		:=	"de acordo com os parametros informados pelo usuario."
Local cDesc3		:=	"trazendo a Evolução Saldo em Dívida."
Local cPict			:=	""
Local titulo		:=	"Evolucao Saldo em Dívida"
//                       0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22        23        24        25        26        27
//                       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                       31/JAN 999999  999.9%  999.9%  999999  999.9%  999.9%  999999  999.9%  999.9%  999  999999  999.9%  999.9%  999999  999.9%  999.9%  999999  999.9%  999.9%  999999  999.9%  999.9%  999999  999.9%  999.9%  999999  999.9%  999.9%  
//Private aCol		:=  {00    ,07     ,15     ,23     ,31     ,39     ,47     ,55     ,63     ,71     ,79  ,84     ,092    ,100    ,108    ,116    ,124    ,132    ,140    ,148    ,156    ,164    ,172    ,180    ,188    ,196    ,204    ,212    ,220}
Local Cabec1		:=	"            VENDAS                 SALDO C/C             SALDO VENCIDO         PMR         0 a 30                 30 a 60                 60 a 90                 90 a 120                  > 120"
Local Cabec2		:=	"            $    %     %Total       $    %     %Total      $     %     %Total           $     %     %Total      $     %     %Total      $     %     %Total      $     %     %Total      $     %     %Total"
Local imprime		:=	.T.
Local aOrd			:=	{}

Private nLin			:=	80
Private aCol		:=  {00    ,07     ,15     ,23     ,31     ,39     ,47     ,55     ,63     ,71     ,79  ,84     ,092    ,100    ,108    ,116    ,124    ,132    ,140    ,148    ,156    ,164    ,172    ,180    ,188    ,196    ,204    ,212    ,220}
Private lEnd		:=	.F.
Private lAbortPrint	:=	.F.
Private CbTxt		:=	""
Private limite		:=	220
Private tamanho		:=	"G"
Private nomeprog	:=	"GEFA02" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey	:=	0
Private cbtxt		:=	Space(10)
Private cbcont		:=	00
Private CONTFL		:=	01
Private m_pag		:=	01
Private cPerg		:=	"GEFA02" // Coloque aqui o nome do arquivo usado para impressao em disco
Private wnrel		:=	"GEFA02" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString		:= "SZA"
Private cAnoAtu		:= ""
Private cMesAtu		:= ""
Pergunte(cPerg,.f.)

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
If nLastKey == 27
	Return
Endif

lProcessa:=.t.
While .t.
	cAnoAtu:=alltrim(str(year(MV_PAR04)))
	cMesAtu:=strzero(month(MV_PAR04),2)
	// Busca a Evolucao Saldo Dívida do Mes anterior
	cQry := "SELECT ZA_UO"
	cQry += "  FROM "+ RetSqlName("SZA")
	cQry += " WHERE ZA_ANO      = '"+cAnoAtu      +"'"	
	cQry += "   AND ZA_MES      = '"+cMesAtu      +"'"	
	cQry += "   AND D_E_L_E_T_ <> '*'"
	TcQuery cQry Alias "TSZA" New
	lEof:=Eof()
	dbCloseArea()
	If !lEof .and. MV_PAR09 = 1
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
Local aDados	:=	array(11)
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
Local aSoma:={0,0,0,0,0,0,0,0}
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
If MV_PAR09 = 2
	cAnoAtu:=alltrim(str(year(MV_PAR04)))
	cMesAtu:=strzero(month(MV_PAR04),2)
	cQry := "SELECT count(*) AS QUANT"
	cQry += "  FROM "+ RetSqlName("SZA")
	cQry += " WHERE ZA_ANO      = '"+cAnoAtu      +"'"	
	cQry += "   AND ZA_MES      = '"+cMesAtu      +"'"	
	cQry += "   AND D_E_L_E_T_ <> '*'"
	TcQuery cQry Alias "TSZA" New
	If TSZA->QUANT > 0
		lJaProc:=.t.
	EndIf
	dbCloseArea()
EndIf

If MV_PAR09 = 1 .or. (MV_PAR09 = 2 .AND. !lJaProc)// Processa Saldo do mes da data de referencia
	dbSelectArea("SZA")          
	aTam := TamSX3("ZA_30")			// Tam 6 Dec 0 Pict @E 999999
	aTamP:= TamSX3("ZA_30P1")    	// Tam 6  Dec 2 Pict @E 999.99
	
	aAdd(aEstruUO, { "UO"       , "C",      5 ,       0 } )
	aAdd(aEstruUO, { "FILIAL"   , "C",      5 ,       0 } )
	aAdd(aEstruUO, { "Ano"      , "C",      4 ,       0 } )
	aAdd(aEstruUO, { "MES"      , "C",      2 ,       0 } )
	aAdd(aEstruUO, { "VND"      , "N",aTam[1] , aTam[2] } )
	aAdd(aEstruUO, { "VNDP1"    , "N",aTamP[1], aTamP[2]} )
	aAdd(aEstruUO, { "VNDP2"    , "N",aTamP[1], aTamP[2]} )
	aAdd(aEstruUO, { "SLD"      , "N",aTam[1] , aTam[2] } )
	aAdd(aEstruUO, { "SLDP1"    , "N",aTamP[1], aTamP[2]} )
	aAdd(aEstruUO, { "SLDP2"    , "N",aTamP[1], aTamP[2]} )
	aAdd(aEstruUO, { "VNC"      , "N",aTam[1] , aTam[2] } )
	aAdd(aEstruUO, { "VNCP1"    , "N",aTamP[1], aTamP[2]} )
	aAdd(aEstruUO, { "VNCP2"    , "N",aTamP[1], aTamP[2]} )
	aAdd(aEstruUO, { "PMR"      , "N",aTam[1] , aTam[2] } )
	aAdd(aEstruUO, { "_30"      , "N",aTam[1] , aTam[2] } ) // 0 a 30
	aAdd(aEstruUO, { "_30P1"    , "N",aTamP[1], aTamP[2]} )
	aAdd(aEstruUO, { "_30P2"    , "N",aTamP[1], aTamP[2]} )
	aAdd(aEstruUO, { "_60"      , "N",aTam[1] , aTam[2] } ) // 31 a 60
	aAdd(aEstruUO, { "_60P1"    , "N",aTamP[1], aTamP[2]} )
	aAdd(aEstruUO, { "_60P2"    , "N",aTamP[1], aTamP[2]} )
	aAdd(aEstruUO, { "_90"      , "N",aTam[1] , aTam[2] } ) // 61 a 90
	aAdd(aEstruUO, { "_90P1"    , "N",aTamP[1], aTamP[2]} )
	aAdd(aEstruUO, { "_90P2"    , "N",aTamP[1], aTamP[2]} )
	aAdd(aEstruUO, { "_120"     , "N",aTam[1] , aTam[2] } ) // 91 a 180
	aAdd(aEstruUO, { "_120P1"   , "N",aTamP[1], aTamP[2]} )
	aAdd(aEstruUO, { "_120P2"   , "N",aTamP[1], aTamP[2]} )
	aAdd(aEstruUO, { "M120"     , "N",aTam[1] , aTam[2] } ) // 181 a 365
	aAdd(aEstruUO, { "M120P1"   , "N",aTamP[1], aTamP[2]} )
	aAdd(aEstruUO, { "M120P2"   , "N",aTamP[1], aTamP[2]} )
	
	cDbfUO	:= criatrab(aEstruUO)
	Use &cDbfUO Alias cDbfUO New
	cInd1	:= CriaTrab("",.F.)
	IndRegua("cDbfUO",cInd1,"UO+FILIAL+ANO+MES",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
	dbSetIndex( cInd1 +OrdBagExt())

	cQry := "SELECT SE1.E1_FILIAL,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,"
	cQry += "       SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_MOEDA,SE1.E1_NATUREZ,SE1.E1_CCONT,"
	cQry += "       SE1.E1_TXMOEDA,SE1.E1_EMISSAO,SE1.E1_XVENCRE,SE1.E1_VENCREA,"
	cQry += "       SE1.E1_VALOR,SE1.E1_SALDO,SE1.E1_SDACRES,SE1.E1_ACRESC,SE1.E1_DECRESC,"
	cQry += "       SE1.E1_SDDECRE,SE1.R_E_C_N_O_"
	cQry += "  FROM "+ RetSqlName("SE1") + " SE1 "//, " +	RetSqlName("SA1") +  " SA1"
	cQry += " WHERE SE1.D_E_L_E_T_ <> '*'"
	//cQry += "   AND SA1.D_E_L_E_T_ <> '*'"
	cQry += "   AND E1_FILIAL  BETWEEN '"+mv_par02      +"' AND '"+mv_par03      +"'"
	cQry += "   AND E1_EMISSAO BETWEEN '"+DTOS(mv_par05)+"' AND '"+DTOS(mv_par06)+"'"
	cQry += "   AND E1_VENCREA BETWEEN '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"'"
	cQry += "   AND E1_MOEDA = '1'"
//	cQry += "   AND E1_TIPO <> 'ND'"
//	cQry += "   AND E1_SALDO <> 0"
     cQry += " AND (E1_BAIXA > '"  + DTOS(dDataBase) + "' OR E1_BAIXA = ' ' OR E1_SALDO <> 0)  "         	
	//cQry += "   AND E1_CLIENTE = A1_COD"
	//cQry += "   AND E1_LOJA    = A1_LOJA"
	        
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
//	cQry +=" AND E1_CCONT <> ' '"	
	cQry += " ORDER BY E1_FILIAL,SUBSTRING(E1_CCONT,2,2),E1_CLIENTE, E1_LOJA, E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
	TcQuery cQry Alias "TSE1" New
	SetRegua(1000)
	While !Eof()
		IF lEnd
			lContinua := .F.
			Exit
		Endif
	
		cUO:=Substr(TSE1->E1_CCONT,2,2)
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
		        cUO := "SCC" // Sem C.Custo
		EndCase
	
		cFilAnt := cUO+TSE1->E1_FILIAL
		dbSelectArea("TSE1")
	
		aDados[01] := cUO
		aDados[02] := TSE1->E1_FILIAL
		aDados[03] := 0 // Vendas
		aDados[04] := 0 // Saldo
		aDados[05] := 0 // Vencido
		aDados[06] := 0 // 0   a 30
		aDados[07] := 0 // 31  a 60
		aDados[08] := 0 // 61  a 90
		aDados[09] := 0 // 91  a 120
		aDados[10] := 0 // >120
		aTmp:={}	
		While cUO+TSE1->E1_FILIAL == cFilAnt .And. !Eof()	
			lSoma := .T.
			IncRegua()
	
	        If TSE1->E1_TIPO $ MVABATIM+"/"+MVRECANT+"/"+MV_CRNEG
				lSoma := .F.
			EndIf                         
	  
//			nSaldo := TSE1->E1_SALDO
			dbSelectArea("SE1")
			dbGoTo(TSE1->R_E_C_N_O_)
			nSaldo := SaldoTit(TSE1->E1_PREFIXO,TSE1->E1_NUM,TSE1->E1_PARCELA,TSE1->E1_TIPO,TSE1->E1_NATUREZ,"R",TSE1->E1_CLIENTE,1,dDataBase-1,,TSE1->E1_LOJA,,If(cPaisLoc=="BRA",TSE1->E1_TXMOEDA,0),1)
			dbSelectArea("TSE1")	
			// Subtrai decrescimo para recompor o saldo na data escolhida.
			If Str(TSE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. TSE1->E1_DECRESC > 0 .And. TSE1->E1_SDDECRE == 0
				nSaldo -= TSE1->E1_DECRESC
			Endif
			// Soma Acrescimo para recompor o saldo na data escolhida.
			If Str(TSE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. TSE1->E1_ACRESC > 0 .And. TSE1->E1_SDACRES == 0
				nSaldo += TSE1->E1_ACRESC
			Endif
			aAdd(aTmp,{TSE1->E1_NUM,nSaldo,TSE1->E1_SALDO})
			If sToD(TSE1->E1_VENCREA) <= MV_PAR04 .and. nSaldo != 0
				
				nDiasAtraso := MV_PAR04 - sToD(TSE1->E1_VENCREA)
				If lSoma
					aDados[05] += nSaldo  // Valor Em Atraso
				Else
					aDados[05] -= nSaldo  // Valor Em Atraso
	            Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Calcula a Quantidade de Dias em Atraso.                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
				xI:=1
				If nDiasAtraso <= 30
					xI := 06 //Array[1][06]
				ElseIf nDiasAtraso > 30 .And. nDiasAtraso <= 60
					xI := 07 //Array[1][07]			
				ElseIf nDiasAtraso > 60 .And. nDiasAtraso <= 90
					xI := 08 //Array[1][08]			
				ElseIf nDiasAtraso > 90 .And. nDiasAtraso <= 120
					xI := 09 //Array[1][09]			
				ElseIf nDiasAtraso > 120 //.And. nDiasAtraso <= 365
					xI := 10 //Array[1][10]			
				EndIf                 
				
				If xI >= 06                           
					If lSoma
						aDados[xI] += nSaldo  // Valor Em Atraso
					Else
						aDados[xI] -= nSaldo  // Valor Em Atraso
		            Endif
				EndIF	
				xI := 0
			Else // A Vencer
				aDados[04]	+= nSaldo
			Endif
	
			dbSelectArea("TSE1")
			dbSkip()
	
			If !Eof()
				cUO:=Substr(TSE1->E1_CCONT,2,2)
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
				        cUO := "SCC" // Sem C.Custo
				EndCase
			EndIf
		EndDo
	
		// Faz o somatório do que foi vendido dentro do Mes
		cQry:="SELECT SUM(CASE E1_TIPO WHEN 'NCC' THEN E1_VALOR * (-1) ELSE E1_VALOR END) AS E1_VALOR"
		cQry+="  FROM "+RetSqlName("SE1")+" SE1"
		cQry+=" WHERE SE1.D_E_L_E_T_ <> '*'"
		cQry+="   AND E1_FILIAL   = '" + aDados[02] +"'"
		cQry += " AND E1_EMISSAO >= '" +DTOS(ctod("01/"+str(month(MV_PAR04))+"/"+str(year(MV_PAR04))))+"'"        
		cQry += " AND E1_EMISSAO <= '" +DTOS(MV_PAR04)+"'"
		cQry+="   AND E1_MOEDA = 1"
//		cQry+="   AND E1_PREFIXO <> 'ND' AND E1_TIPO <> 'FAT'"
		cQry+="   AND E1_TIPO <> 'FAT'"
		Do Case
		   Case aDados[01] = "RDVM"
				cQry += "   AND (SUBSTRING(E1_CCONT,2,2) = '01' OR SUBSTRING(E1_CCONT,2,2) = '02')"
		   Case aDados[01] = "ILI"
				cQry += "   AND SUBSTRING(E1_CCONT,2,2) = '21'"
		   Case aDados[01] = "RMLAP" 
				cQry += "   AND SUBSTRING(E1_CCONT,2,2) = '11'"
		   Case aDados[01] = "RMA"
				cQry += "   AND (SUBSTRING(E1_CCONT,2,2) = '22' OR SUBSTRING(E1_CCONT,2,2) = '23')"
		EndCase
//		cQry +=" AND E1_CCONT <> ' '"	
		
		TcQuery cQry Alias "TFAT" NEW
		aDados[03]:=TFAT->E1_VALOR

		dbCloseArea("TFAT")
	
		cMesAnt:=strzero( month( ctod("01/"+str(month(mv_par04))+"/"+str(year(mv_par04)))-1) ,2 )
		cAnoAnt:=strzero( year(ctod("01/"+str(month(mv_par04))+"/"+str(year(mv_par04)))-1),4)
	
		cAnoAtu:=alltrim(str(year(MV_PAR04)))
		cMesAtu:=strzero(month(MV_PAR04),2)
		// Busca a Evolucao Saldo Dívida do Mes anterior
		cQry := "SELECT ZA_VND,ZA_SLD,ZA_VNC,ZA_30,ZA_60,ZA_90,ZA_120,ZA_M120"
		cQry += "  FROM "+ RetSqlName("SZA")
		cQry += " WHERE ZA_UO       = '"+aDados[01]+"'"
		cQry += "   AND ZA_FILIAL   = '"+aDados[02]+"'"
		cQry += "   AND ZA_ANO      = '"+cAnoAnt      +"'"	
		cQry += "   AND ZA_MES      = '"+cMesAnt      +"'"	
		cQry += "   AND D_E_L_E_T_ <> '*'"
		TcQuery cQry Alias "TSZA" New
		For nX:=3 to 10
			aDados[nx]:=Round(aDados[nX]/1000,0)
		Next nX	

		aDados[5]:=aDados[6]+aDados[7]+aDados[8]+aDados[9]+aDados[10]
		aDados[4]+=aDados[5]
		//((((Venda Atual+Venda Anterior)/2)/Venda Atual)+30 dias
		If !Eof()
  			nPMR	:= (((aDados[04]+TSZA->ZA_SLD)/2)/aDados[03])*30
  			
			nVndP1	:= ((aDados[03]/TSZA->ZA_VND )-int(aDados[03]/TSZA->ZA_VND ) )*100
			nSldP1	:= ((aDados[04]/TSZA->ZA_SLD )-int(aDados[04]/TSZA->ZA_SLD  ) )*100
			nVncP1	:= ((aDados[05]/TSZA->ZA_VNC )-int(aDados[05]/TSZA->ZA_VNC  ) )*100
			n30P1	:= ((aDados[06]/TSZA->ZA_30  )-int(aDados[06]/TSZA->ZA_30   ) )*100
			n60P1	:= ((aDados[07]/TSZA->ZA_60  )-int(aDados[07]/TSZA->ZA_60   ) )*100
			n90P1	:= ((aDados[08]/TSZA->ZA_90  )-int(aDados[08]/TSZA->ZA_90   ) )*100
			n120P1	:= ((aDados[09]/TSZA->ZA_120 )-int(aDados[09]/TSZA->ZA_120  ) )*100
			nM120P1	:= ((aDados[10]/TSZA->ZA_M120)-int(aDados[10]/TSZA->ZA_M120 ) )*100
		Else
			nPMR	:= 0
			nVndP1	:= 0
			nSldP1	:= 0
			nVncP1	:= 0
			n30P1	:= 0
			n60P1	:= 0
			n90P1	:= 0
			n120P1	:= 0
			nM120P1	:= 0
		EndIf
		dbCloseArea()
		
		aSoma[1]+=aDados[03] // Vendas
		aSoma[2]+=aDados[04] // Saldo
		aSoma[3]+=aDados[05] // Vencido
		aSoma[4]+=aDados[06] // 0   a 30
		aSoma[5]+=aDados[07] // 31  a 60
		aSoma[6]+=aDados[08] // 61  a 90
		aSoma[7]+=aDados[09] // 91  a 120
		aSoma[8]+=aDados[10] // >120

		nVndP2	:= 0
		nSldP2	:= 0
		nVncP2	:= 0
		n30P2	:= 0
		n60P2	:= 0
		n90P2	:= 0
		n120P2	:= 0
		nM120P2	:= 0

		RecLock("cDbfUO",.T.)
			cDbfUO->UO		:= aDados[01]
			cDbfUO->FILIAL	:= aDados[02]
			cDbfUO->Ano		:= cAnoAtu
			cDbfUO->MES		:= cMesAtu
			cDbfUO->VND		:= aDados[03]
			cDbfUO->VNDP1	:= nVndP1
			cDbfUO->VNDP2	:= nVndP2
			cDbfUO->SLD		:= aDados[04]
			cDbfUO->SLDP1	:= nSldP1
			cDbfUO->SLDP2	:= nSldP2
			cDbfUO->VNC		:= aDados[05]
			cDbfUO->VNCP1	:= nVncP1
			cDbfUO->VNCP2	:= nVncP2
			cDbfUO->PMR		:= nPMR
			cDbfUO->_30		:= aDados[06]
			cDbfUO->_30P1	:= n30P1
			cDbfUO->_30P2	:= n30P2
			cDbfUO->_60		:= aDados[07]
			cDbfUO->_60P1	:= n60P1
			cDbfUO->_60P2	:= n60P2
			cDbfUO->_90		:= aDados[08]
			cDbfUO->_90P1	:= n90P1
			cDbfUO->_90P2	:= n90P2
			cDbfUO->_120	:= aDados[09]
			cDbfUO->_120P1	:= n120P1
			cDbfUO->_120P2	:= n120P2
			cDbfUO->M120	:= aDados[10]
			cDbfUO->M120P1	:= nM120P1
			cDbfUO->M120P2	:= nM120P2
		MsUnLock()
	
		dbSelectArea("TSE1")
	EndDo

	
	dbSelectArea("cDbfUO")
	dbGoTop()
//	SetRegua(cDbfUO->(RecCount())
	While !Eof()
		IncRegua()
		nVndP2	:= ((cDbfUO->VND  /aSoma[1])-int(cDbfUO->VND /aSoma[1] ) )*100
		nSldP2	:= ((cDbfUO->SLD  /aSoma[2])-int(cDbfUO->SLD /aSoma[2] ) )*100
		nVncP2	:= ((cDbfUO->VNC  /aSoma[3])-int(cDbfUO->VNC /aSoma[3] ) )*100
		n30P2	:= ((cDbfUO->_30  /aSoma[4])-int(cDbfUO->_30 /aSoma[4] ) )*100
		n60P2	:= ((cDbfUO->_60  /aSoma[5])-int(cDbfUO->_60 /aSoma[5] ) )*100
		n90P2	:= ((cDbfUO->_90  /aSoma[6])-int(cDbfUO->_90 /aSoma[6] ) )*100
		n120P2	:= ((cDbfUO->_120 /aSoma[7])-int(cDbfUO->_120/aSoma[7] ) )*100
		nM120P2	:= ((cDbfUO->M120 /aSoma[8])-int(cDbfUO->M120/aSoma[8] ) )*100

		RecLock("cDbfUO",.F.)
			cDbfUO->VNDP2	:= nVndP2
			cDbfUO->SLDP2	:= nSldP2
			cDbfUO->VNCP2	:= nVncP2
			cDbfUO->_30P2	:= n30P2
			cDbfUO->_60P2	:= n60P2
			cDbfUO->_90P2	:= n90P2
			cDbfUO->_120P2	:= n120P2
			cDbfUO->M120P2	:= nM120P2
		MsUnLock()
		dbSkip()
	EndDo

	
	dbSelectArea("TSE1")
	dbCloseArea()
	If !lJaProc // Grava Saldo	
		saveSZA()
	EndIf
EndIf
cAnoAtu:=alltrim(str(year(MV_PAR04)))
cMesAtu:=strzero(month(MV_PAR04),2)
cQry:="SELECT COUNT(*) AS QUANT FROM "+RetSqlName("SZA")
cQry+=" WHERE ZA_ANO      = '"+cAnoAtu+"'"
cQry+="   AND D_E_L_E_T_ <> '*'"
TcQuery cQry Alias "TSZA" New
nQuant:=TSZA->QUANT
dbCloseArea()

SetRegua(nQuant)
	
cQry:="SELECT * FROM "+RetSqlName("SZA")
cQry+=" WHERE ZA_ANO      = '"+cAnoAtu+"'"
cQry+="   AND D_E_L_E_T_ <> '*'"
cQry+=" ORDER BY ZA_UO+ZA_FILIAL+ZA_MES"
TcQuery cQry Alias "TSZA" New
cUOAnt	:=	""
cFilAnt	:=	""
aDiaMes:={}
cDiaMesBk:=""
titulo		:=	"Evolução Saldo em Dívida "+alltrim(cAnoAtu)
dbSelectArea("TSZA")
lEof:=Eof()



While !EOF()
	IncRegua()
	If lAbortPrint
    	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
 		Exit
   	Endif

   	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      	nLin := 9
   	Endif
	If cUOAnt+cFilAnt != TSZA->ZA_UO+TSZA->ZA_FILIAL
		If cUOAnt !=TSZA->ZA_UO
			@nLin,000 PSAY Replicate("-",limite)
			nLin++
			cUOAnt	:=	TSZA->ZA_UO
			If cUOAnt !="SCC"
				@ nLin,00 PSAY "U.O.  : "+cUOAnt
			Else
				@ nLin,00 PSAY "U.O.  : SEM C.CUSTO"
			EndIf
			nLin++
		EndIf
		cFilAnt	:=	TSZA->ZA_FILIAL

		nLin++
		@ nLin,00 PSAY "FILIAL: "+alltrim(Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_FILIAL"))
		nLin++
	EndIf

	cMes:=iif(TSZA->ZA_MES = "12","00",TSZA->ZA_MES)
   	cDia:=alltrim(str(day((cToD("01/"+ALLTRIM(STR(VAL(cMes)+1))+"/"+TSZA->ZA_ANO)-1))))
   	cDiaMes:=cDia+"/"+substr(cMonth(ctod("01/"+TSZA->ZA_MES+"/00")),1,3)
	If !(cDiaMes $ cDiaMesBk)
		cDiaMesBk+="|"+cDiaMes
		aAdd(aDiaMes,{strZERO(Month(ctod("01/"+TSZA->ZA_MES+"/00")),2),cDiaMes})
	EndIf
	ImpDet( nLin,cDiaMes,TSZA->ZA_VND,TSZA->ZA_VNDP1,TSZA->ZA_VNDP2,;
			TSZA->ZA_SLD,TSZA->ZA_SLDP1,TSZA->ZA_SLDP2,;
			TSZA->ZA_VNC,TSZA->ZA_VNCP1,TSZA->ZA_VNCP2,;
			TSZA->ZA_PMR,TSZA->ZA_30,TSZA->ZA_30P1,TSZA->ZA_30P2,;
			TSZA->ZA_60,TSZA->ZA_60P1,TSZA->ZA_60P2,;
			TSZA->ZA_90,TSZA->ZA_90P1,TSZA->ZA_90P2,;
			TSZA->ZA_120,TSZA->ZA_120P1,TSZA->ZA_120P2,;
			TSZA->ZA_M120,TSZA->ZA_M120P1,TSZA->ZA_M120P2)
	nLin++          
	dbSelectArea("TSZA")	
   	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

	
dbSelectArea("TSZA")	
dbCloseArea()
If !lEof
	@nLin,000 PSAY Replicate("-",limite)
	nLin++
	
	//Imprimindo Total
	@ nLin,00 PSAY "TOTAL"
	nLin++

	cQryIni:="SELECT SUM(ZA_VND) AS ZA_VND ,SUM(ZA_VNDP1) AS ZA_VNDP1  , SUM(ZA_VNDP2) AS ZA_VNDP2 ,"
	cQryIni+="       SUM(ZA_SLD) AS ZA_SLD ,SUM(ZA_SLDP1) AS ZA_SLDP1  , SUM(ZA_SLDP2) AS ZA_SLDP2 ,"
	cQryIni+="       SUM(ZA_VNC) AS ZA_VNC ,SUM(ZA_VNCP1) AS ZA_VNCP1  , SUM(ZA_VNCP2) AS ZA_VNCP2 ,"
	cQryIni+="       SUM(ZA_30)  AS ZA_30  ,SUM(ZA_30P1)  AS ZA_30P1   , SUM(ZA_30P2)  AS ZA_30P2  ,"
	cQryIni+="       SUM(ZA_60)  AS ZA_60  ,SUM(ZA_60P1)  AS ZA_60P1   , SUM(ZA_60P2)  AS ZA_60P2  ,"
	cQryIni+="       SUM(ZA_90)  AS ZA_90  ,SUM(ZA_90P1)  AS ZA_90P1   , SUM(ZA_90P2)  AS ZA_90P2  ,"
	cQryIni+="       SUM(ZA_120) AS ZA_120 ,SUM(ZA_120P1) AS ZA_120P1  , SUM(ZA_120P2) AS ZA_120P2 ,"
	cQryIni+="       SUM(ZA_M120)AS ZA_M120,SUM(ZA_M120P1)AS ZA_M120P1 , SUM(ZA_M120P2)AS ZA_M120P2,"
	cQryIni+="       SUM(ZA_PMR) AS ZA_PMR"
	cQryIni+="  FROM "+ RetSqlName("SZA")
	
	
	For nX:=1 to len(aDiaMes)
		cQry:=" WHERE ZA_ANO = '"+cAnoAtu+"'"
		cQry+="   AND ZA_MES = '"+aDiaMes[nX,1]+"'"
		cQry+="   AND D_E_L_E_T_ <>  '*'"
		If aDiaMes[nX,1] = "01"
			cAnoAnt:=alltrim(str(val(cAnoAtu)-1))
			cMesAnt:="12"
		Else
			cAnoAnt:=cAnoAtu
			cMesAnt:=strzero(val(cMesAtu)-1,2)
		EndIf
		cQryAnt:=" WHERE ZA_ANO      = '"+cAnoAnt+"'"
		cQryAnt+="   AND ZA_MES      = '"+cMesAnt+"'"
		cQryAnt+="   AND D_E_L_E_T_ <> '*'"
		TcQuery cQryIni+cQry Alias "TSZA" New
		TcQuery cQryIni+cQryAnt Alias "TSZAnt" New
	
	   	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	      	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      	nLin := 9
	   	Endif
		nPMR	:= (((TSZA->ZA_SLD+TSZAnt->ZA_SLD)/2)/TSZA->ZA_VND)*30
		
		nVndP1	:= ((TSZA->ZA_VND /TSZAnt->ZA_VND )-int(TSZA->ZA_VND /TSZAnt->ZA_VND  ) )*100
		nSldP1	:= ((TSZA->ZA_SLD /TSZAnt->ZA_SLD )-int(TSZA->ZA_SLD /TSZAnt->ZA_SLD  ) )*100
		nVncP1	:= ((TSZA->ZA_VNC /TSZAnt->ZA_VNC )-int(TSZA->ZA_VNC /TSZAnt->ZA_VNC  ) )*100
		n30P1	:= ((TSZA->ZA_30  /TSZAnt->ZA_30  )-int(TSZA->ZA_30  /TSZAnt->ZA_30   ) )*100
		n60P1	:= ((TSZA->ZA_60  /TSZAnt->ZA_60  )-int(TSZA->ZA_60  /TSZAnt->ZA_60   ) )*100
		n90P1	:= ((TSZA->ZA_90  /TSZAnt->ZA_90  )-int(TSZA->ZA_90  /TSZAnt->ZA_90   ) )*100
		n120P1	:= ((TSZA->ZA_120 /TSZAnt->ZA_120 )-int(TSZA->ZA_120 /TSZAnt->ZA_120  ) )*100
		nM120P1	:= ((TSZA->ZA_M120/TSZAnt->ZA_M120)-int(TSZA->ZA_M120/TSZAnt->ZA_M120 ) )*100

		nVnd	:=TSZA->ZA_VND
		nSld	:=TSZA->ZA_SLD
		nVnc	:=TSZA->ZA_VNC
		n30		:=TSZA->ZA_30
		n60		:=TSZA->ZA_60
		n90		:=TSZA->ZA_90
		n120	:=TSZA->ZA_120
		nM120	:=TSZA->ZA_M120

		ImpDet(nLin, aDiaMes[nX,2],nVND,nVNDP1,TSZA->ZA_VNDP2,;
				nSLD,nSLDP1,TSZA->ZA_SLDP2,;
				nVNC,nVNCP1,TSZA->ZA_VNCP2,;
			    nPMR,n30,n30P1,TSZA->ZA_30P2,;
				n60,n60P1,TSZA->ZA_60P2,;
				n90,n90P1,TSZA->ZA_90P2,;
				n120,n120P1,TSZA->ZA_120P2,;
				nM120,nM120P1,TSZA->ZA_M120P2)
		nLin++
		dbSelectArea("TSZA")
		dbCloseArea()
		dbSelectArea("TSZAnt")
		dbCloseArea()
	Next nX
	nLin++
	@nLin,000 PSAY Replicate("-",limite)
EndIf
	
If MV_PAR09 = 2 .and. !lJaProc // Nao gravar saldo
	cQry:="delete from "+RETSQLNAME("SZA")
	cQry+="   	WHERE ZA_ANO      = '"+cAnoAtu+"'"
	cQry+="   	  AND ZA_MES      = '"+cMesAtu+"'"
	cQry+="       AND D_E_L_E_T_ <> '*'"
	TcSQLExec(cQry)
	TcSQLExec("COMMIT")
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
* Funcao.....: SaveSZA()                                                *
* Autor......: Marcelo Aguiar Pimentel                                  *
* Data.......: 22/02/2007                                               *
* Descricao..: Funcao para salvar o processamento do faturmento do mes  *
*              de processamento.                                        *
*                                                                       *
************************************************************************/
Static Function SaveSZA()
dbSelectArea("SZA")
dbSetOrder(1)
dbSelectArea("cDbfUO")
dbGoTop()
While !Eof()
	IncRegua()
	RecLock("SZA",.t.)
		SZA->ZA_UO		:=cDbfUO->UO
		SZA->ZA_FILIAL	:=cDbfUO->FILIAL
		SZA->ZA_MES		:=cDbfUO->MES
		SZA->ZA_ANO		:=cDbfUO->ANO
		SZA->ZA_VND		:=cDbfUO->VND
		SZA->ZA_VNDP1	:=cDbfUO->VNDP1
		SZA->ZA_VNDP2	:=cDbfUO->VNDP2
		SZA->ZA_SLD		:=cDbfUO->SLD
		SZA->ZA_SLDP1	:=cDbfUO->SLDP1
		SZA->ZA_SLDP2	:=cDbfUO->SLDP2
		SZA->ZA_VNC		:=cDbfUO->VNC
		SZA->ZA_VNCP1	:=cDbfUO->VNCP1
		SZA->ZA_VNCP2	:=cDbfUO->VNCP2
		SZA->ZA_PMR		:=cDbfUO->PMR
		SZA->ZA_30		:=cDbfUO->_30
		SZA->ZA_30P1	:=cDbfUO->_30P1
		SZA->ZA_30P2	:=cDbfUO->_30P2
		SZA->ZA_60		:=cDbfUO->_60
		SZA->ZA_60P1	:=cDbfUO->_60P1
		SZA->ZA_60P2	:=cDbfUO->_60P2
		SZA->ZA_90		:=cDbfUO->_90
		SZA->ZA_90P1	:=cDbfUO->_90P1
		SZA->ZA_90P2	:=cDbfUO->_90P2
		SZA->ZA_120		:=cDbfUO->_120
		SZA->ZA_120P1	:=cDbfUO->_120P1
		SZA->ZA_120P2	:=cDbfUO->_120P2
		SZA->ZA_M120	:=cDbfUO->M120
		SZA->ZA_M120P1	:=cDbfUO->M120P1
		SZA->ZA_M120P2	:=cDbfUO->M120P2
	MsUnLock()
	dbSelectArea("cDbfUO")
	dbSkip()
EndDo
Return


Static Function ImpDet(nLin,pDiaMes,pVnd,pVndP1,pVndP2,pSld,pSldP1,pSldP2,pVnc,pVncP1,pVncP2,pPMR,p30,p30P1,p30P2,p60,p60P1,p60P2,p90,p90P1,p90P2,p120,p120P1,p120P2,pM120,pM120P1,pM120P2)
    @nLin,aCol[01] PSAY pDiaMes			Picture "@!"

	@nLin,aCol[02] PSAY pVND 	Picture "@E 999999"
	@nLin,aCol[03] PSAY pVNDP1 	Picture "@E 9999.9"
	@nLin,aCol[04] PSAY pVNDP2 	Picture "@E 9999.9"
	
	@nLin,aCol[05] PSAY pSLD 	Picture "@E 999999"
	@nLin,aCol[06] PSAY pSLDP1 	Picture "@E 9999.9"
	@nLin,aCol[07] PSAY pSLDP2 	Picture "@E 9999.9"
	
	@nLin,aCol[08] PSAY pVNC 	Picture "@E 999999"
	@nLin,aCol[09] PSAY pVNCP1 	Picture "@E 9999.9"
	@nLin,aCol[10] PSAY PVNCP2 	Picture "@E 9999.9"
	
	@nLin,aCol[11] PSAY pPMR 	Picture "@E 999"
	
	@nLin,aCol[12] PSAY p30  	Picture "@E 999999"
	@nLin,aCol[13] PSAY p30P1 	Picture "@E 9999.9"
	@nLin,aCol[14] PSAY p30P2 	Picture "@E 9999.9"
	
	@nLin,aCol[15] PSAY p60  	Picture "@E 999999"
	@nLin,aCol[16] PSAY p60P1 	Picture "@E 9999.9"
	@nLin,aCol[17] PSAY p60P2 	Picture "@E 9999.9"
	
	@nLin,aCol[18] PSAY p90  	Picture "@E 999999"
	@nLin,aCol[19] PSAY p90P1 	Picture "@E 9999.9"
	@nLin,aCol[20] PSAY p90P2 	Picture "@E 9999.9"
	
	@nLin,aCol[21] PSAY p120  	Picture "@E 999999"
	@nLin,aCol[22] PSAY p120P1	Picture "@E 9999.9"
	@nLin,aCol[23] PSAY p120P2	Picture "@E 9999.9"
	
	@nLin,aCol[24] PSAY pM120  	Picture "@E 999999"
	@nLin,aCol[25] PSAY pM120P1	Picture "@E 9999.9"
	@nLin,aCol[26] PSAY pM120P2	Picture "@E 9999.9"
Return
