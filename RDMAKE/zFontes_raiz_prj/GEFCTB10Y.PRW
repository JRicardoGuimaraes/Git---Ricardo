#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGEFCTB10  บ Autor ณ SAULO MUNIZ        บ Data ณ  24/04/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO DE FECHAMENTO MENSAL                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEFCO                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

// Adicionado controle de Fora SEDE para as unidades Operacionais - Saulo Muniz 25/05/05
// RMA            ==> SALDO ATUAL - SEDE OPER
// ILI/RDVM/RMLAP ==> SALDO ATUAL - RIO DE JANEIRO
// Adicionado controle Filtro por filial na impressใo- Saulo Muniz 20/06/05     
// Adicionado controle Progressใo - Saulo Muniz 23/06/05     
// Incluida filiais : Contagem e Vitoria - Saulo Muniz 28/11/05
// Alterado novo lay-out - Saulo Muniz 28/11/05
// Adicionado pergunta para imprimir o log de processamento. - Saulo Muniz 30/11/05


User Function GEFCTB1X

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Relatorio Fechamento Por U.O."
Local cPict        := ""
Local nLin         := 80
Local Cabec1       := "| DESCRICAO             |  FORA SEDE  |  SEDE ADM  | BENEDITINOS |   RB 45    |    P.REAL    |   BARUERI    |    PAVUNA   |  VILA GUI.  |  SJ PINHAIS  |  CAMPINAS   |  SEPETIBA   |  V.OLIMPIA   |   SANTOS    |  CONTAGEM  " 
//Local Cabec1       := "| DESCRICAO             | FORA SEDE  | SEDE ADM | SEDE OPER | PORTO RJ | RIO JANEIRO |  P.REAL    |  BARUERI    |  DQ CAXIAS  |  VILA GUI. |  SJ PINHAIS  |  CAMPINAS  |  SEPETIBA  |  ST.AMARO  |   SANTOS    | SALDO ATUAL|" 
//Local Cabec1       := "| CODIGO |   DESCRICAO                 |                           SALDO ATUAL |" 
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "G"
Private nomeprog   := "GEFCTB10" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GEFCTB10" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "SZ2"
Private cPerg      := "GEF002"   //"CTR040"

titulo := "Historique "

lData := .F.
lHora := .F.
   
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros								  ณ
//ณ mv_par01				// Data Inicial                  	  		  ณ
//ณ mv_par02				// Data Final                        		  ณ
//ณ mv_par03				// Conta Inicial                         	  ณ
//ณ mv_par04				// Conta Final  							  ณ
//ณ mv_par05				// Unidade Operacional (U.O.)	        	  ณ		
//ณ mv_par06				// Configura็ใo	(001= Historique; 002= FinRm) ณ		
//ณ mv_par07				// Tipo de Processamento    	        	  ณ		
//ณ mv_par08				// Progressใo               	        	  ณ		
//ณ mv_par09				// Imprime Log (Sim/Nใo)       	        	  ณ		
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//cabec1 := "NOME                         JAN      FEV      MAR      ABR      MAI      JUN      JUL      AGO      SET      OUT      NOV      DEZ "

If !Pergunte(cPerg,.T.)                           // Pergunta no SX1
   Return
EndIf

xMes := MesExtenso(Substr(Dtoc(MV_PAR01),4,2))

// Nome do Departamento no Relat๓rio
DbselectArea("SZ1")
DbSetOrder(1) 
Dbgotop()
Dbseek(xFilial("SZ1")+MV_PAR05)
xDescZ1 := Alltrim(SZ1->Z1_DESCR)

 If MV_PAR08 == 1
    titulo  := titulo +"( "+ xDescZ1 +" ) "+xMes
 Else
    titulo  := titulo +"PROGRESSรO ( "+ xDescZ1 +" ) "+xMes 
 Endif
 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  14/04/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cQry := ""

xTotal  := 0
xTotalG := 0

nVl1 := 0
nVl2 := 0
nVl3 := 0
nVl4 := 0
nVl5 := 0
nVl6 := 0
nVl7 := 0
nVl8 := 0
nVl9 := 0
nVl10 := 0
nVl11 := 0
nVl12 := 0
nVl13 := 0
nVl14 := 0
nVl15 := 0
nVlFora := 0
nVlForaSede := 0

xDtProc  := " "  
_xLogDt  := {}  
_xLogHr  := {}  
_xLog    := {}  

If AllTRim(MV_PAR05) == '999'
	cQry := ""
	cQry := "SELECT DISTINCT Z2_COD "
	cQry += "FROM " + RetSqlName("SZ2") + " "
	cQry += "WHERE Z2_FILIAL = '" + xFilial("SZ2") + "' "
	cQry += "AND Z2_MES = '" + DTOS(MV_PAR01) + "' "
	cQry += "AND D_E_L_E_T_ <> '*' "
	cQry += "ORDER BY Z2_COD "	
	
	TcQuery cQry Alias "TSZ2" NEW
	DbSelectArea("TSZ2")
	DbGoTop()
	While !Eof()        
		ImpHistorique(TSZ2->Z2_COD)		
		DbSelectArea("TSZ2")
		DbSkip()
	End
Else 
	ImpHistorique(MV_PAR05)
EndIf	

SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()

Return


//////////////////////////////
Static Function Histcont(cCodigo)  // SEGUNDA PARTE DO RELATORIO - SAULO MUNIZ - 28/11/05
//////////////////////////////

Local nLin         := 80
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Local Cabec1       := "| DESCRICAO               |    VITORIA  |    SALDO    |" 
//Local Cabec1       := "| DESCRICAO             |  CONTAGEM  |  VITORIA  |    SALDO    |" 
Local cPict        := ""
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Relatorio Fechamento Por U.O."
//Local Cabec1       := "| CODIGO |   DESCRICAO                 |                           SALDO ATUAL |" 
//    Cabec1       := "| DESCRICAO             |  CONTAGEM  |  VITORIA  | SEDE OPER | PORTO RJ | RIO JANEIRO |  P.REAL    |  BARUERI    |  DQ CAXIAS  |  VILA GUI. |  SJ PINHAIS  |  CAMPINAS  |  SEPETIBA  |  ST.AMARO  |  SANTOS   |    SALDO    |" 
//xTotal  := 0
//xTotalG := 0

nVl1 := 0
nVl2 := 0
nVl3 := 0
nVl4 := 0
nVl5 := 0
nVl6 := 0
nVl7 := 0
nVl8 := 0
nVl9 := 0
nVl10 := 0
nVl11 := 0
nVl12 := 0
nVl13 := 0
nVl14 := 0
nVl15 := 0
nVlFora := 0
nVlForaSede := 0

dbSelectArea("SZ2")
dbSetOrder(1) // 1
dbGoTop()
Dbseek(xFilial("SZ2")+Alltrim(cCodigo))
SetRegua(RecCount())

While !EOF() .And. Alltrim(SZ2->Z2_COD) ==  Alltrim(cCodigo) 

   IncRegua()

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   
   If SZ2->Z2_MES <> MV_PAR01
      DbSelectArea("SZ2")
      DbSkip()
      Loop
   Endif
   
   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif      
  
   @ nlin, 000 PSAY Chr(15)                // Compressao de Impressao
      
   @nLin,001 PSAY Alltrim(SZ2->Z2_DESCR)
   @nLin,023 PSAY SZ2->Z2_VITORIA Picture "@E 99,999,999.99"                     
   @nLin,039 PSAY SZ2->Z2_SALDO   Picture "@E 999,999,999.99"                     
   //@nLin,046 PSAY SZ2->Z2_SALDO   Picture "@E 999,999,999.99"                     
   //@nLin,058 PSAY SZ2->Z2_PORTORJ Picture "@E 9,999,999.99"                         
   //@nLin,072 PSAY SZ2->Z2_RIO     Picture "@E 9,999,999.99"                         
   //@nLin,086 PSAY SZ2->Z2_PREAL   Picture "@E 99,999,999.99"                         
   //@nLin,098 PSAY SZ2->Z2_BARUERI Picture "@E 9,999,999.99"                             
   //@nLin,111 PSAY SZ2->Z2_CAXIAS  Picture "@E 9,999,999.99"                     
   //@nLin,124 PSAY SZ2->Z2_VILAGUI Picture "@E 9,999,999.99"                     
   //@nLin,139 PSAY SZ2->Z2_SJP     Picture "@E 9,999,999.99"                     
   //@nLin,153 PSAY SZ2->Z2_CAMPINA Picture "@E 9,999,999.99"                         
   //@nLin,166 PSAY SZ2->Z2_SEPETIB Picture "@E 9,999,999.99"                         
   //@nLin,179 PSAY SZ2->Z2_STAMARO Picture "@E 9,999,999.99"                         
   //@nLin,193 PSAY SZ2->Z2_SANTOS  Picture "@E 9,999,999.99"                             
   //@nLin,206 PSAY SZ2->Z2_SALDO   Picture "@E 999,999,999.99"                  
    
     nLin  := nLin + 1 
   // xTotal := xTotal + SZ2->Z2_SALDO       
     
     /*
     nVl1 := nVl1 + Z2_SEDEADM  
	 nVl2 := nVl2 + Z2_SEDEOPE  
     nVl3 := nVl3 + Z2_PORTORJ  
     nVl4 := nVl4 + Z2_RIO      
     nVl5 := nVl5 + Z2_PREAL    
	 nVl6 := nVl6 + Z2_BARUERI  
     nVl7 := nVl7 + Z2_CAXIAS   
	 nVl8 := nVl8 + Z2_VILAGUI  
     nVl9 := nVl9 + Z2_SJP      
     nVl10 := nVl10 + Z2_CAMPINA  
     nVl11 := nVl11 + Z2_SEPETIB  
	 nVl12 := nVl12 + Z2_STAMARO  
	 nVl13 := nVl13 + Z2_SANTOS       	   
     nVl14 := nVl13 + Z2_SANTOS       	   
     nVl15 := nVl13 + Z2_SANTOS       	        
     nVlFora := nVlFora + Z2_FORA
     */
                   
   dbSelectArea("SZ2")
   dbSkip()          
 
EndDo


 nLin := nLin + 1     
 @nLin,001 PSAY Replicate("-",210)
 nLin := nLin + 2 

@ nlin, 000 PSAY Chr(18)                // Impressao Normal
@nLin,180 PSAY "  Total Geral  ..:  " 
@nLin,206 PSAY xTotal   Picture "@E 999,999,999,999.99"  

 
Return

Static Function ImpHistorique(cCodigo)

xMes := MesExtenso(Substr(Dtoc(MV_PAR01),4,2))

// Nome do Departamento no Relat๓rio
DbselectArea("SZ1")
DbSetOrder(1) 
Dbgotop()
Dbseek(xFilial("SZ1")+MV_PAR05)
xDescZ1 := Alltrim(SZ1->Z1_DESCR)

 If MV_PAR08 == 1
    titulo  := titulo +"( "+ xDescZ1 +" ) "+xMes
 Else
    titulo  := titulo +"PROGRESSรO ( "+ xDescZ1 +" ) "+xMes 
 Endif


dbSelectArea("SZ2")
dbSetOrder(1) // 1
dbGoTop()
Dbseek(xFilial("SZ2")+Alltrim(cCodigo))
SetRegua(RecCount())

While !EOF() .And. Alltrim(SZ2->Z2_COD) ==  Alltrim(cCodigo) .And. SZ2->Z2_FILIAL == xFilial("SZ2")

   IncRegua()

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   
   If SZ2->Z2_MES <> MV_PAR01
      DbSelectArea("SZ2")
      DbSkip()
      Loop
   Endif
   
   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif      

   // TRATAMENTO FORA SEDE (  ANTIGO 2005 )
   /*
   If Alltrim(SZ2->Z2_COD) == "103" .OR. Alltrim(SZ2->Z2_COD) == "110"  // (RMA) (RMA+ADUANA)
      nVlForaSede := SZ2->Z2_SALDO - SZ2->Z2_SEDEOPE     // Fora Sede (RMA)
   Else
      nVlForaSede := SZ2->Z2_SALDO - SZ2->Z2_RIO         // Fora Sede (ILI/RDVM/RMLAP)         
   Endif                                                                        
   */
   
   // TRATAMENTO FORA SEDE
      nVlForaSede := SZ2->Z2_SALDO - SZ2->Z2_SEDEADM     // Fora Sede (TODOS)
   
   //@ nlin, 000 PSAY Chr(18)                // Impressao Normal
   @ nlin, 000 PSAY Chr(15)                // Compressao de Impressao
      
   @nLin,001 PSAY Alltrim(SZ2->Z2_DESCR)
   @nLin,024 PSAY nVlForaSede     Picture "@E 99,999,999.99"                     
   @nLin,038 PSAY SZ2->Z2_SEDEADM Picture "@E 99,999,999.99"                     
   //@nLin,046 PSAY SZ2->Z2_SEDEOPE Picture "@E 9,999,999.99"                     
   @nLin,051 PSAY SZ2->Z2_PORTORJ Picture "@E 9,999,999.99"     //58                    
   @nLin,065 PSAY SZ2->Z2_RIO     Picture "@E 9,999,999.99"                         
   @nLin,080 PSAY SZ2->Z2_PREAL   Picture "@E 99,999,999.99"                         
   @nLin,095 PSAY SZ2->Z2_BARUERI Picture "@E 9,999,999.99"                             
   @nLin,109 PSAY SZ2->Z2_CAXIAS  Picture "@E 9,999,999.99"                     
   @nLin,124 PSAY SZ2->Z2_VILAGUI Picture "@E 9,999,999.99"                     
   @nLin,139 PSAY SZ2->Z2_SJP     Picture "@E 9,999,999.99"                     
   @nLin,154 PSAY SZ2->Z2_CAMPINA Picture "@E 9,999,999.99"                         
   @nLin,167 PSAY SZ2->Z2_SEPETIB Picture "@E 9,999,999.99"                         
   @nLin,181 PSAY SZ2->Z2_STAMARO Picture "@E 9,999,999.99"                         
   @nLin,195 PSAY SZ2->Z2_SANTOS  Picture "@E 9,999,999.99"                             
   @nLin,210 PSAY SZ2->Z2_CONTAGE Picture "@E 9,999,999.99"                  
   //@nLin,206 PSAY SZ2->Z2_SALDO   Picture "@E 999,999,999.99"                  
    
     nLin  := nLin + 1 
    xTotal := xTotal + SZ2->Z2_SALDO
    
    //xDtProc:= SZ2->Z2_DATA + " " +SZ2->Z2_HORA    
    //
    // Controle de Data e Hora de Processamento
    //
    //If Ascan(_xLogDt,SZ2->Z2_DATA) == 0
       lData := .T.
    //Endif
    //
    //If Ascan(_xLogHr,SZ2->Z2_HORA) == 0
    //   lHora := .T.
    //Endif
    //
    If lData //.And. lHora         
       AADD(_xLogDt,{SZ2->Z2_DATA,Alltrim(SZ2->Z2_DESCR),SZ2->Z2_HORA})
       //AADD(_xLog,{SZ2->Z2_HORA,Alltrim(SZ2->Z2_DESCR)})               
    Endif       
    
    
     nVl1 := nVl1 + Z2_SEDEADM  
	 nVl2 := nVl2 + Z2_SEDEOPE  
     nVl3 := nVl3 + Z2_PORTORJ  
     nVl4 := nVl4 + Z2_RIO      
     nVl5 := nVl5 + Z2_PREAL    
	 nVl6 := nVl6 + Z2_BARUERI  
     nVl7 := nVl7 + Z2_CAXIAS   
	 nVl8 := nVl8 + Z2_VILAGUI  
     nVl9 := nVl9 + Z2_SJP      
     nVl10 := nVl10 + Z2_CAMPINA  
     nVl11 := nVl11 + Z2_SEPETIB  
	 nVl12 := nVl12 + Z2_STAMARO  
	 nVl13 := nVl13 + Z2_SANTOS       	   
     nVl14 := nVl14 + Z2_CONTAGE       	   
     nVl15 := nVl15 + Z2_VITORIA       	   
     nVlFora := nVlFora + Z2_FORA
                   
   dbSelectArea("SZ2")
   dbSkip()          
 
EndDo


 nLin := nLin + 1     
 @nLin,001 PSAY Replicate("-",210)
 nLin := nLin + 2 

@ nlin, 000 PSAY Chr(18)                // Impressao Normal
@nLin,180 PSAY "  Total Geral  ..:  " 
@nLin,206 PSAY xTotal   Picture "@E 999,999,999,999.99"  

 
  nLin := nLin + 2     
 @nLin,001 PSAY Replicate("-",55)
  nLin := nLin + 1 


 //
 // Quadro das Filiais Distribuidas ==> Lay-out 1
 // 
 

 @nLin,001 PSAY "SEDE ADMINISTRATIVA "
 @nLin,030 PSAY nVl1   Picture "@E 999,999,999,999.99"  
 @nLin,055 PSAY "|"
  nLin := nLin + 1 

// @nLin,001 PSAY "SEDE OPERACIONAL    "
// @nLin,030 PSAY nVl2   Picture "@E 999,999,999,999.99"  
// @nLin,055 PSAY "|"
//  nLin := nLin + 1 

 @nLin,001 PSAY "PORTO DO RIO        "
 @nLin,030 PSAY nVl3   Picture "@E 999,999,999,999.99"  
 @nLin,055 PSAY "|"
  nLin := nLin + 1 

 @nLin,001 PSAY "RIO DE JANEIRO      "
 @nLin,030 PSAY nVl4   Picture "@E 999,999,999,999.99"  
 @nLin,055 PSAY "|"
  nLin := nLin + 1 

 @nLin,001 PSAY "PORTO REAL          "
 @nLin,030 PSAY nVl5   Picture "@E 999,999,999,999.99"  
 @nLin,055 PSAY "|"
  nLin := nLin + 1 

 @nLin,001 PSAY "BARUERI             "
 @nLin,030 PSAY nVl6   Picture "@E 999,999,999,999.99"  
 @nLin,055 PSAY "|"
  nLin := nLin + 1 
                    
 @nLin,001 PSAY "DUQUE DE CAXIAS     "
 @nLin,030 PSAY nVl7   Picture "@E 999,999,999,999.99"  
 @nLin,055 PSAY "|"
  nLin := nLin + 1 

 @nLin,001 PSAY "VILA GUILHERME      "
 @nLin,030 PSAY nVl8   Picture "@E 999,999,999,999.99"  
 @nLin,055 PSAY "|"
  nLin := nLin + 1 

 @nLin,001 PSAY "SรO JOSE DOS PINHAIS"
 @nLin,030 PSAY nVl9   Picture "@E 999,999,999,999.99"  
 @nLin,055 PSAY "|"
  nLin := nLin + 1 
                  
 @nLin,001 PSAY "CAMPINAS            "
 @nLin,030 PSAY nVl10   Picture "@E 999,999,999,999.99"  
 @nLin,055 PSAY "|"
  nLin := nLin + 1 

 @nLin,001 PSAY "SEPETIBA            "
 @nLin,030 PSAY nVl11   Picture "@E 999,999,999,999.99"  
 @nLin,055 PSAY "|"
  nLin := nLin + 1 

 @nLin,001 PSAY "SANTO AMARO         "
 @nLin,030 PSAY nVl12   Picture "@E 999,999,999,999.99"  
 @nLin,055 PSAY "|"
  nLin := nLin + 1 

 @nLin,001 PSAY "SANTOS              "
 @nLin,030 PSAY nVl13   Picture "@E 999,999,999,999.99"  
 @nLin,055 PSAY "|"
  nLin := nLin + 1 

 If nVlFora > 0
    @nLin,001 PSAY "** NENHUM           "
    @nLin,030 PSAY nVlFora   Picture "@E 999,999,999,999.99"  
    @nLin,055 PSAY "|"
     nLin := nLin + 1 
 Endif
 @nLin,001 PSAY Replicate("-",55)


  Histcont()  // SEGUNDA PARTE DO RELATORIO - SAULO MUNIZ - 28/11/05
 
 ////////////////////////////////////
 // Log da Opera็ใo/Processamento  //
 //////////////////////////////////// 
 
 If MV_PAR09 == 1  // Imprime Log de processamento (Sim)
    
    nLin := nLin + 3 
    @nLin,001 PSAY " DATA/HORA DE PROCESSAMENTO :"   
    nLin := nLin + 1 
   
     For I:= 1 To Len(_xLogDt)   
       
       If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
          Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
          nLin := 8
       Endif      
       
       @nLin,001 PSAY "Conta : " + _xLogdt[I][2] + " Procesado em : " + _xLogdt[I][1] + " Hora : " + _xLogdt[I][3]
       nLin := nLin + 1 
       
     Next
   
 Endif
 
nLin := 80
 
Return