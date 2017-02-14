#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEFCTB03  º Autor ³ SAULO MUNIZ        º Data ³  14/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ RELATORIO DE FECHAMENTO MENSAL                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEFCO                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Tratamento de filtros com multi config. Por U.O Tabela SZ1 + SX5(Z2) - Saulo Muniz 16/04/05
// Criado Arquivo Dbf apartir do resultado - Saulo Muniz 18/04/05
// Filtro RMA (6,8)- Sem Aduana Cod. 103 - Saulo Muniz 19/04/05
// Filtro RMA+ADUANA (6,7,8)- Com Aduana Cod. 110 - Saulo Muniz 19/04/05

User Function GEFCTB03

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Relatorio Fechamento Por U.O."
Local cPict        := ""
Local titulo       := "Historique "
Local nLin         := 80
Local Cabec1       := "| CODIGO |   DESCRICAO                 |                            SALDO ATUAL |" 
//Local Cabec1       := "| CODIGO |     DESCRICAO     | SALDO ANTERIOR | MOVIMENTO PERIODO | SALDO ATUAL |" 
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 80  //132
Private tamanho    := "P" //"G"
Private nomeprog   := "GEFCTB03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GEFCTB03" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "CTS"
Private cPerg      := "GEF002"   //"CTR040"
Private xDescZ1    := " "
Private V_Erase1   := " "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								  ³
//³ mv_par01				// Data Inicial                  	  		  ³
//³ mv_par02				// Data Final                        		  ³
//³ mv_par03				// Conta Inicial                         	  ³
//³ mv_par04				// Conta Final  							  ³
//³ mv_par05				// Unidade Operacional (U.O.)	        	  ³		// Criado Saulo 04/05/05
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//cabec1 := "NOME                         JAN      FEV      MAR      ABR      MAI      JUN      JUL      AGO      SET      OUT      NOV      DEZ "

// Tabela de centro de custo (4o Digito)
//
// 1 - RDVM
// 2 - RDVM
// 4 - ILI    
// 5 - RMLAP
// 6 - RMA
// 7 - ADUANA 
// 8 - RMA

If !Pergunte(cPerg,.T.)                           // Pergunta no SX1
   Return
EndIf

xMes := MesExtenso(Substr(Dtoc(MV_PAR01),4,2))

// Nome do Departamento no Relatório
DbselectArea("SZ1")
DbSetOrder(1) 
Dbgotop()
Dbseek(xFilial("SZ1")+MV_PAR05)
xDescZ1 := Alltrim(SZ1->Z1_DESCR)
titulo  := titulo +"( "+ xDescZ1 +" ) "+xMes

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

// Gera Dbf
cNomArq1    := "GEFCTB03.DBF"                 // Arquivo
cNomInd1    := "GEFCTB03"+OrdBagExt()         // Indice

If File(cNomArq1)  
   V_Erase1 := FErase(cNomArq1)        
   If V_Erase1 != 0      
      Msgbox("Problemas ao tentar excluir o arquivo : " + cNomArq1  + "." + chr(13)+;
             "Portanto a operacao nao sera realizada." ,"Aviso")
      Return .t.
   Endif   

Endif

//Preparando os Arquivos
//************************
aCampos  := { }
AADD(aCampos, {"MS_COD"  , "C",  9, 0})
AADD(aCampos, {"MS_CONTA", "C", 20, 0})
AADD(aCampos, {"MS_DESCR", "C", 30, 0})
AADD(aCampos, {"MS_SALDO", "N", 17, 2})
AADD(aCampos, {"MS_UO"   , "C", 20, 0})
AADD(aCampos, {"MS_MES"  , "C", 20, 0})

cNomArq := CriaTrab (aCampos, .T.)
dbUseArea (.T., , cNomArq, "TRB", .T. , .F.)
_cArqInd := Criatrab("",.F.)
IndRegua("TRB",_cArqInd,"MS_CONTA",,,"Selecionando Registros.")
dbGoTop ()


nTipo := If(aReturn[4]==1,15,18)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

// Gera Dbf
dbCloseArea ("TRB")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  14/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dDataI  := MV_PAR01
dDataF  := MV_PAR02
cMoeda  := "01"     // REAIS
cTpSald := "1"      // SALDO REAL   
nSaldo  := 0

xTotal  := 0
nSaldo  := 0  
xTotalG := 0
nSldeb  := 0
nSlcre  := 0
nSld    := 0       
xTotAnt := 0
xTAntG  := 0
xTbUO   := Alltrim(MV_PAR05)
xUO     := " " // Alltrim(MV_PAR05)
_xCC    := {}  // Array de Centro de custos  
xTipo   := " "
xUOIni  := " "
xUOFim  := " "
xCodZ1  := " "

/*
// TABELA DE CONFIGURAÇÃO = Z2
CHAVE  DESCRIÇÃO

001    DRH
002    QLT
003    DIR
004    DFC
101    PVNO
102    RDVM
103    RMA
104    ILI
105    RMLAP
106    MATRIZ
107    DMIT
108    DFC - FINANCE
109    ADUANA                                                 
110    RMA + ADUANA
201    AUTOMOTIVE
202    NETWORK
203    SUPPLY
301    TOUTES DIRECTIONS
401    CUM LIGNE A LIGNE
*/

// Calcula Mes Anterior
dMesAnt := Str(Month(MV_PAR01)-1)
dAnoAnt := Str(Year(MV_PAR01))
DtAnteIni := Ctod("01/01/05")
DtAnteFim := MV_PAR02//Ctod("31/"+dMesAnt+"/"+dAnoAnt)

/*
If Empty(DtAnteFim)
   DtAnteFim := Ctod("30/"+dMesAnt+"/"+dAnoAnt) // Mes com 30 Dias
Endif
If Empty(DtAnteFim)
   DtAnteFim := Ctod("28/"+dMesAnt+"/"+dAnoAnt) //Fevereiro 28 dias
Endif
*/

DbselectArea("SZ1")
DbSetOrder(1) 
Dbgotop()
Dbseek(xFilial("SZ1")+xTbUO)
xUO := Alltrim(SZ1->Z1_FILTRO)
//xZ1 := aLLTRIM(SZ1->Z1_DESCR)

If SZ1->Z1_TIPO == "1"
   DbselectArea("CTT")
   DbSetOrder(1)     
   Dbgotop()
   Dbseek(xFilial("CTT")+xUO)  
   xTipo := "1"
Endif

If SZ1->Z1_TIPO == "2"
   DbselectArea("CTT")
   DbSetOrder(5)     
   Dbgotop()
   Dbseek(xFilial("CTT")+xUO)  
   xTipo := "2"   
Endif      

If SZ1->Z1_TIPO == "3"     /// FAZER TRATAMENTO
   xTipo := "3"
Endif


If xTipo == "1" // C.Custo Fixo

   If SZ1->Z1_COD == "106" // Filtro Matriz porque São mais de 1 C.Custo fixo
      xUOIni := "28080"
      xUOFim := "28083"
      DbselectArea("CTT")     
      DbSetOrder(1)       // CTT_FILIAL + CTT_UO
      Dbgotop()
      Dbseek(xFilial("CTT")+xUOIni)  
      While !Eof() .And. Alltrim(CTT->CTT_UO) >= xUOIni .And. Alltrim(CTT->CTT_UO) <= xUOFim
            AADD(_xCC,{CTT->CTT_CUSTO})
            DbselectArea("CTT")
            dbSkip() // Avanca o ponteiro do registro no arquivo      
      EndDo     
   Else
      DbselectArea("CTT")     
      DbSetOrder(1)       
      Dbgotop()
      Dbseek(xFilial("CTT")+xUO)  
      While !Eof() .And. Alltrim(CTT->CTT_CUSTO) == xUO   
            AADD(_xCC,{CTT->CTT_CUSTO})
            DbselectArea("CTT")
            dbSkip() // Avanca o ponteiro do registro no arquivo      
      EndDo
   
   Endif

Endif

If xTipo == "2" // Cod. da U.O   
   // DEFINIÇÕES
   // 102 = RDVM ; 201 = AUTOMOTIVE ; 203 = SUPPLY
   // Filtro Rdvm porque São 2 Cod. (1 e 2) de U.O 
   // Grupo Automotive = Rdvm 
   // Transf. de Grupo(3) para U.O(2) Supply Cod.(203)  
   // Tratamento Aduana (109) = Cod 7
   // Filtro RMA + ADUANA (110)      
   // RMA sem Aduana (103)
   //
   DbselectArea("SZ1")     
   If SZ1->Z1_COD == "102" .Or. SZ1->Z1_COD == "201" .Or. SZ1->Z1_COD == "203" 
      xUOIni := Substr(SZ1->Z1_FILTRO,1,1)
      xUOFim := Substr(SZ1->Z1_FILTRO,3,1)      
      DbselectArea("CTT")     
      DbSetOrder(5)       // CTT_FILIAL + CTT_UO
      Dbgotop()
      Dbseek(xFilial("CTT")+xUOIni)  
      While !Eof() .And. Alltrim(CTT->CTT_UO) >= xUOIni .And. Alltrim(CTT->CTT_UO) <= xUOFim
            AADD(_xCC,{CTT->CTT_CUSTO})
            DbselectArea("CTT")
            dbSkip() // Avanca o ponteiro do registro no arquivo      
      EndDo     
   Endif   
   //
   // RMA - Filtrar os Cod. Com Dg = 8 (Sede + Informatica + Dfc + Dir + Etc.)
   DbselectArea("SZ1")           
   If SZ1->Z1_COD == "103"  // U.O (6,8)
      DbselectArea("CTT")     
      DbSetOrder(5)     
      Dbgotop()
      Dbseek(xFilial("CTT")+"6")  
      While !Eof() .And. Alltrim(CTT->CTT_UO) == "6" .OR. Alltrim(CTT->CTT_UO) == "8" .And. Substr(Alltrim(CTT->CTT_CUSTO),1,1) <> "3" // Apenas Operacional                
         AADD(_xCC,{CTT->CTT_CUSTO})
         DbselectArea("CTT")
         dbSkip() 
      EndDo                          
   Endif
   //
   DbselectArea("SZ1")                 
   If SZ1->Z1_COD == "110" // 103 = RMA (6+7+8); 110 = RMA + ADUANA         
      xUOIni := "6"
      xUOFim := "8"
      xCodZ1 := Alltrim(SZ1->Z1_COD)                        
      DbselectArea("CTT")     
      DbSetOrder(5)       // CTT_FILIAL + CTT_UO
      Dbgotop()
      Dbseek(xFilial("CTT")+xUOIni)  
      While !Eof() .And. Alltrim(CTT->CTT_UO) >= xUOIni .And. Alltrim(CTT->CTT_UO) <= xUOFim .And. Substr(Alltrim(CTT->CTT_CUSTO),1,1) == "3"               
         // Filtro RMA + ADUANA (6,7,8)
         AADD(_xCC,{CTT->CTT_CUSTO})
         DbselectArea("CTT")
         dbSkip() 
      EndDo                             
   Endif
   //
   DbselectArea("SZ1")                 
   //If !(SZ1->Z1_COD $("102|103|110|201|203"))   // Demais Configurações
   If SZ1->Z1_COD <> "102" .And. SZ1->Z1_COD <> "103" .And. SZ1->Z1_COD <> "110" .And. SZ1->Z1_COD <> "201" .And. SZ1->Z1_COD <> "203"   // Demais Configurações
         DbselectArea("CTT")      
         DbSetOrder(5)  
         Dbgotop()
         Dbseek(xFilial("CTT")+xUO)  
         While !Eof() .And. Alltrim(CTT->CTT_UO) == xUO   
               AADD(_xCC,{CTT->CTT_CUSTO})
               DbselectArea("CTT")
               dbSkip() 
         EndDo      
   Endif
Endif

If xTipo == "3" // Grupos
   If SZ1->Z1_COD == "301"  // TOUTES DIRECTION (301)   
      DbselectArea("CTT")     
      DbSetOrder(1)         // CTT_FILIAL + CTT_UO
      Dbgotop()
      Dbseek(xFilial("CTT")+xUOIni)  
      While !Eof() .And. Substr(Alltrim(CTT->CTT_CUSTO),1,1) <> "2"
            AADD(_xCC,{CTT->CTT_CUSTO})
            DbselectArea("CTT")
            dbSkip() 
      EndDo     
   Endif   
   If SZ1->Z1_COD == "401"  // CUM LIGNE À LIGNE (401) - Sem Filtro de C.Custo
      DbselectArea("CTT")     
      DbSetOrder(1)       
      Dbgotop()
      Dbseek(xFilial("CTT")+xUO)  
      While !Eof() 
            AADD(_xCC,{CTT->CTT_CUSTO})
            DbselectArea("CTT")
            dbSkip() // Avanca o ponteiro do registro no arquivo      
      EndDo   
   Endif
Endif

dbSelectArea("CTS")
dbSetOrder(2) // 1
dbGoTop()
Dbseek(xFilial("CTS")+"001")
SetRegua(RecCount())

While !EOF() .And. CTS->CTS_CODPLA ==  "001" //.And. CTS->CTS_CONTAG == xContaG

   IncRegua()

   // DEFINIÇÕES DO ARQUIVO CTS - PLANO GERENCIAL
      xCodPla  := CTS->CTS_CODPLA   // COD. PLANO GER.
      xContaG  := CTS->CTS_CONTAG   // CONTA GERENCIAL
      xContaI  := CTS->CTS_CT1INI   // CONTA INICIO
      xContaF  := CTS->CTS_CT1FIM   // CONTA FIM
      xCcustoI := CTS->CTS_CTTINI   // C.CUSTO INICIO
      xCcustoF := CTS->CTS_CTTFIM   // C.CUSTO FIM
      xDescG   := Alltrim(CTS->CTS_DESCCG)   // DESCRIÇÃO

   /*
     SaldoCCus(cConta,cCusto,dData,cMoeda,cTpSald,nQualSaldo)
     MovCusto(cConta,cCusto,dDataIni,dDataFim,cMoeda,cTpSald,nQualSaldo)
     CtbSmSaldo(cCodigoDe,cCodigoAte,dData,cMoeda,cTpSald,nQualSaldo,cAlias)
   */

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
         
   For I:= 1 To Len(_xCC)   
       nSld    := MovCusto(xContaI,_xCC[I][1],MV_PAR01,MV_PAR02,cMoeda,cTpSald,3)   // Saldo Atual
       nSldAnt := MovCusto(xContaI,_xCC[I][1],DtAnteIni,DtAnteFim,cMoeda,cTpSald,3) // Saldo Anterior   
       xTotal  := xTotal + nSld
       xTotAnt := xTotAnt + nSldAnt        
   Next
   
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif      
  
   dbSelectArea("CTS")
   dbSkip() 
   
   If CTS->CTS_CONTAG <> xContaG  

      If xTotal = 0 // Não Imprime valores zerados 
           
      Else
      
         @nLin,001 PSAY xCodPla
         @nLin,005 PSAY Alltrim(xContaG)
         @nLin,012 PSAY xDescG
         //@nLin,015 PSAY Alltrim(xContaI)
         //@nLin,025 PSAY Alltrim(xContaF)   
         //@nLin,035 PSAY xTotAnt  Picture "@E 999,999,999,999.99"  
         @nLin,060 PSAY xTotal   Picture "@E 999,999,999,999.99"  
                  
          nLin := nLin + 1 // Avanca a linha de impressao
          
          // Gera Dbf
  	      DbSelectArea("TRB")
          RecLock ("TRB",.T.)
          Replace MS_COD     with xCodPla
	      Replace MS_CONTA   with Alltrim(xContaG)
          Replace MS_DESCR   with xDescG
	      Replace MS_SALDO   with xTotal
          Replace MS_UO      with xDescZ1 //xZ1 
	      Replace MS_MES     with xMes
    	  Msunlock ()
          
          xTotalG := xTotalG + xTotal       
          xTAntG  := xTAntG  + xTotAnt
          xTotal  := 0
          nSldeb  := 0
          nSlcre  := 0
          nSld    := 0   
          nSldAnt := 0
         
          dbSelectArea("CTS")          
      Endif   
   Endif             

EndDo

 nLin := nLin + 1     
@nLin,001 PSAY Replicate("-",79)
 nLin := nLin + 2 // Avanca a linha de impressao    

@nLin,015 PSAY "  Total Geral  ..:  " // Alltrim(xContaI)
//@nLin,035 PSAY xTAntG    Picture "@E 999,999,999,999.99"  
@nLin,060 PSAY xTotalG   Picture "@E 999,999,999,999.99"  

// Fim do Relatorio

// Gera Dbf
dbCloseArea ("TRB")


SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()

Return