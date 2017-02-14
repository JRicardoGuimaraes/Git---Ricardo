#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGEFCTB08  บ Autor ณ SAULO MUNIZ        บ Data ณ  14/04/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza Tabela p/ Fechamento                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEFCO                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

// Tratamento de Gera็ใo do arquivo por agendamento
// Incluido Vendas Fora Sede
// Incluido Data/Hora de Gera็ใo - Saulo Muniz 23/06/05
// Incluido Recof (Dig.9) no Rma - 110/103 - Saulo Muniz 29/06/05
// Processamento por Agendamento - Saulo Muniz 11/07/05
// Processar apenas as contas alteradas - Matrix - Saulo Muniz 01/08/05
// Incluida filiais : Contagem e Vitoria - Saulo Muniz 28/11/05
// Alterado novo lay-out - Saulo Muniz 28/11/05
// Novo tratamento para estrutura dos centro de custo  - Saulo Muniz 22/12/05
// Alterado Novo indice(Ordem 7) devido a atualiza็ใo do sistema ver.8  - Saulo Muniz 26/12/05
// Alterado Novo nova configura็ใo do centro de custo - Saulo Muniz 26/12/05
// Criado resumo para Metier - Saulo Muniz 02/02/06
// Separada Rma e Aduana nos codigos (103 e 109) - Saulo Muniz 14/02/06
// Ativado recurso de processamento da conta informada - Saulo Muniz 20/02/06
// Ativado nova configura็ใo 008 (DG + DCM + ADM) - Saulo Muniz 05/04/06
// Criado tratamento para gera็ใo de Rma separado de Aduana - Saulo Muniz 02/04/06


User Function GEFCTB08(xAuto)

Private xWorkFlow   := IIF(xAuto <> nil,.T.,.F.)
Private xProcesso   := " "
Private xRelease    := GetMv("MV_HISTVER")  // Versใo do Centro de custo (2005 ou 2006) 
lTroca := .F.

    
// criacao do arquivo Log
//=======================
pos   := 0
cNL   := CHR(13)+CHR(10)
Arq01 := "\ENVIAR\HISTLOG.TXT"
nHdl  := fCreate(Arq01)
te1   :="Historico de processamento do Historique - Data: "+dtoc(ddatabase)+cNL
fWrite(nHdl,te1,Len(te1))
te1   :="======================================================================================"+cNL
fWrite(nHdl,te1,Len(te1))


If xRelease == "2005"
   lTroca := .F.
Else
   lTroca := .T.
Endif

If !xWorkFlow  // Manual
   Private cPerg   := "GEF002"   
   Pergunte(cPerg,.T.)

   If MV_PAR01 < CTOD("01/01/2006")  // PARA APENAS RODAR NO ANO DE 2005
      ApMsgAlert("Periodo Bloqueado - Selecione uma data apartir de 2006 ! ",'Aten็ใo !!!')  
      Return
   Endif

   If MV_PAR07 == 1         // Processar apenas a U.O.
      Private oProcess := NIL
      oProcess := MsNewProcess():New({|lEnd| HISTORIQUE(lEnd,oProcess,MV_PAR05)},"Processando","Aguarde...Manual",.T.)
      oProcess:Activate()   
   Else                       // Processar Todas
      Private oProcess := NIL
      oProcess := MsNewProcess():New({|lEnd| AUTOHIST(lEnd,oProcess)},"Processando","Aguarde...Automatico",.T.)
      oProcess:Activate()
   Endif

Else // HISTORIQUE AGENDADO
   
   Private cPerg   := "GEF002"   
   Pergunte(cPerg,.F.)           

   If MV_PAR01 < CTOD("01/01/2006")  // PARA APENAS RODAR NO ANO DE 2005
      ApMsgAlert("Periodo Bloqueado - Selecione uma data apartir de 2006 ! ",'Aten็ใo !!!')  
      Return
   Endif
	   
   MV_PAR03 := "                  "
   MV_PAR04 := "ZZZZZZZZZZZZZZZZZZ"
   MV_PAR06 := "001" // CONFIGURAวรO
   MV_PAR07 := 2     // 1= APENAS A U.O ; 2= TODOS

   ConOut("")
   ConOut("Processando : Aguarde ... ")
   ConOut("")

   If MV_PAR07 == 1         
      HISTORIQUE(MV_PAR05)
   Else                     
      AUTOHIST()
   Endif  
   
Endif

fClose(nHdl)

// Envia Relatorio por email


Return Nil


STATIC FUNCTION AUTOHIST(lEnd,oObj)

DbselectArea("SZ1")
DbSetOrder(1) 
Dbgotop()

While !Eof()       
  
  If Eof()
     Return
  Endif
  
  DbselectArea("SZ2")
  DbSetOrder(1) 
  Dbgotop()
  If DbSeek(xFilial("SZ2") + Alltrim(SZ1->Z1_COD))   
     If SZ2->Z2_MES == MV_PAR01  // Mes ja Processado
        DbselectArea("SZ1")
        dbSkip() 
        Loop     
     Endif        
  Endif
  
  MV_PAR05 := Alltrim(SZ1->Z1_COD)                          
  
  If xWorkFlow  
     HISTORIQUE(MV_PAR05)  
  Else  
     HISTORIQUE(lEnd,oProcess,MV_PAR05)  
  Endif
  
  DbselectArea("SZ1")
  dbSkip() 

Enddo


Return


STATIC FUNCTION HISTORIQUE(lEnd,oObj,MV_PAR05) // PROCESSAR UO 

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
xUO     := Space(2) // Alltrim(MV_PAR05)
_xCC    := {}  // Array de Centro de custos  

xTipo   := " "
xUOIni  := " "
xUOFim  := " "
xCodZ1  := " "

nVlFora := 0
nVl280  := 0
nVl300  := 0
nVl305  := 0
nVl310  := 0
nVl315  := 0
nVl320  := 0
nVl325  := 0
nVl330  := 0
nVl335  := 0
nVl340  := 0
nVl350  := 0
nVl355  := 0
nVl360  := 0
nVl365  := 0
nVl345  := 0
nVl370  := 0
nSldOper := 0

//lOk := .T.
//If nLastKey == 27
//   Return
//Endif

// Calcula Mes Anterior
dMesAnt := Str(Month(MV_PAR01)-1)
dAnoAnt := Str(Year(MV_PAR01))
DtAnteIni := Ctod("01/01/05")
DtAnteFim := MV_PAR02 //Ctod("31/"+dMesAnt+"/"+dAnoAnt)

DbselectArea("SZ1")
DbSetOrder(1) 
Dbgotop()
Dbseek(xFilial("SZ1")+xTbUO)

//xUO := IIF(xRelease == "2005",Alltrim(SZ1->Z1_FILTRO),Alltrim(SZ1->Z1_OUNEW)) // U.O (2DIG.)
xUO := Alltrim(SZ1->Z1_FILTRO) // U.O (2DIG.)
xDescZ1 := Alltrim(SZ1->Z1_DESCR)
xCodZ1 := Alltrim(SZ1->Z1_COD)                        

If SZ1->Z1_TIPO == "1"
   DbselectArea("CTT")
   DbSetOrder(1)     
   Dbgotop()
   Dbseek(xFilial("CTT")+xUO)  
   xTipo := "1"
Endif

If SZ1->Z1_TIPO == "2"
   DbselectArea("CTT")
   IIF(xRelease == "2005",DbSetOrder(6),DbSetOrder(7))     
   Dbgotop()
   Dbseek(xFilial("CTT")+xUO)  
   xTipo := "2"   
Endif      

If SZ1->Z1_TIPO == "3"     /// FAZER TRATAMENTO
   xTipo := "3"
   Return
Endif


If xTipo == "1" // C.Custo Fixo
   DbselectArea("SZ1")   
   If SZ1->Z1_COD == "106" // Filtro Matriz porque Sใo varios C.Custo fixo
      xUOIni := IIF(xRelease == "2005","28080","431001")
      xUOFim := IIF(xRelease == "2005","28083","437001")
      DbselectArea("CTT")     
      DbSetOrder(1)       // CTT_FILIAL + CTT_UO
      Dbgotop()
      Dbseek(xFilial("CTT")+xUOIni)  
      While !Eof() .And. Alltrim(CTT->CTT_CUSTO) >= xUOIni .And. Alltrim(CTT->CTT_CUSTO) <= xUOFim
            AADD(_xCC,{CTT->CTT_CUSTO})
            DbselectArea("CTT")
            dbSkip() // Avanca o ponteiro do registro no arquivo      
      EndDo     
   
   Endif
   
   If SZ1->Z1_COD == "008"      
      xUOIni := "431001"
      DbselectArea("CTT")     
      DbSetOrder(1)       // CTT_FILIAL + CTT_UO
      Dbgotop()
      //Dbseek(xFilial("CTT")+"43")  
      Dbseek(xFilial("CTT")+xUOIni)  
      While !Eof() 
            If Alltrim(CTT->CTT_CUSTO) == "431001" .Or. Alltrim(CTT->CTT_CUSTO) == "434001" .Or. Alltrim(CTT->CTT_CUSTO) == "437001"
               AADD(_xCC,{CTT->CTT_CUSTO})            
            Endif            
            DbselectArea("CTT")
            dbSkip() // Avanca o ponteiro do registro no arquivo      
      EndDo     
   
   Endif
   
   If SZ1->Z1_COD <> "008" .And. SZ1->Z1_COD <> "106"
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
   DbselectArea("SZ1")     
   If SZ1->Z1_COD == "102" //.Or. SZ1->Z1_COD == "201" .Or. SZ1->Z1_COD == "203" 
      xUOIni := Substr(SZ1->Z1_FILTRO,1,2)
      xUOFim := Substr(SZ1->Z1_FILTRO,4,2)
      DbselectArea("CTT")     
      IIF(xRelease == "2005",DbSetOrder(6),DbSetOrder(7))     
      Dbgotop()
      Dbseek(xFilial("CTT")+xUOIni)  
      While !Eof() .And. Alltrim(CTT->CTT_UONEW) >= xUOIni .And. Alltrim(CTT->CTT_UONEW) <= xUOFim
            AADD(_xCC,{CTT->CTT_CUSTO})
            DbselectArea("CTT")
            dbSkip() // Avanca o ponteiro do registro no arquivo      
      EndDo     
   Endif   
   //
   // RMA + Aduana
   DbselectArea("SZ1")           
   If SZ1->Z1_COD == "110"  // U.O (6,8)
      xUOIni := "22"
      xUOFim := "23"
      DbselectArea("CTT")     
      DbSetOrder(7)     
      Dbgotop()
      Dbseek(xFilial("CTT")+xUOIni)        
         While !Eof() .And. Alltrim(CTT->CTT_UONEW) >= "22" .And. Alltrim(CTT->CTT_UONEW) <= "23" 
	         AADD(_xCC,{CTT->CTT_CUSTO})
   	         DbselectArea("CTT")
	         dbSkip() 
	     EndDo                          	      
   Endif

   If MV_PAR11 == 2 //.And.
	   // RMA Separado da Aduana
	   DbselectArea("SZ1")           
	   If SZ1->Z1_COD == "103"  
	      xUOIni := "22"
	      xUOFim := "23"
	      DbselectArea("CTT")     
	      DbSetOrder(7)     
	      Dbgotop()
	      Dbseek(xFilial("CTT")+xUOIni)        
	         While !Eof() .And. Alltrim(CTT->CTT_UONEW) == "22" 
		         AADD(_xCC,{CTT->CTT_CUSTO})
	   	         DbselectArea("CTT")
		         dbSkip() 
		     EndDo                          	      
	   Endif
	
	   DbselectArea("SZ1")           
	   If SZ1->Z1_COD == "109"  
	      xUOIni := "22"
	      xUOFim := "23"
	      DbselectArea("CTT")     
	      DbSetOrder(7)     
	      Dbgotop()
	      Dbseek(xFilial("CTT")+xUOIni)        
	         While !Eof() .And. Alltrim(CTT->CTT_UONEW) == "23" 
		         AADD(_xCC,{CTT->CTT_CUSTO})
	   	         DbselectArea("CTT")
		         dbSkip() 
		     EndDo                          	      
	   Endif

   Endif

   //
   /*
   DbselectArea("SZ1")  // RMA         
   If SZ1->Z1_COD == "103"  // U.O (6,8)
      xUOIni := "22"
      DbselectArea("CTT")     
      DbSetOrder(7))     
      Dbgotop()
      Dbseek(xFilial("CTT")+xUOIni)        
      While !Eof() .And. Alltrim(CTT->CTT_UONEW) == xUOIni
         AADD(_xCC,{CTT->CTT_CUSTO})
         DbselectArea("CTT")
         dbSkip() 
      EndDo                          	      
   Endif
   */
   //
   //

   If MV_PAR11 == 1
	   DbselectArea("SZ1")                 
	   If SZ1->Z1_COD <> "102" .And. SZ1->Z1_COD <> "110" .And. SZ1->Z1_COD <> "103" .And. SZ1->Z1_COD <> "109"// Demais Configura็๕es
	   //If SZ1->Z1_COD <> "102" .And. SZ1->Z1_COD <> "110"  // Demais Configura็๕es
	      DbselectArea("CTT")      
	      DbSetOrder(7)    
	      Dbgotop()
	      Dbseek(xFilial("CTT")+xUO)  
	      While !Eof() .And. Alltrim(CTT->CTT_UONEW) == xUO   
		        AADD(_xCC,{CTT->CTT_CUSTO})
		        DbselectArea("CTT")
		        dbSkip() 
		  EndDo      
	   Endif   
   Endif   
   
Endif


If !xWorkFlow  // Manual
   If MV_PAR06 == "001"    // HISTORIQUE
      oObj:SetRegua1(194)	
   Else
      oObj:SetRegua1(11)	
   Endif
Endif

If Empty(MV_PAR06)
   MV_PAR06 := "001"
Endif

dbSelectArea("CTS")
dbSetOrder(2) // 1
dbGoTop()
Dbseek(xFilial("CTS")+Alltrim(MV_PAR06)+Alltrim(MV_PAR10))
//Dbseek(xFilial("CTS")+Alltrim(MV_PAR06))

While !EOF() .And. Alltrim(CTS->CTS_CODPLA) ==  Alltrim(MV_PAR06) 
      
   xCodPla  := CTS->CTS_CODPLA   // COD. PLANO GER.
   xContaG  := CTS->CTS_CONTAG   // CONTA GERENCIAL
   xContaI  := CTS->CTS_CT1INI   // CONTA INICIO
   xContaF  := CTS->CTS_CT1FIM   // CONTA FIM
   xCcustoI := CTS->CTS_CTTINI   // C.CUSTO INICIO
   xCcustoF := CTS->CTS_CTTFIM   // C.CUSTO FIM
   xDescG   := Alltrim(CTS->CTS_DESCCG)   // DESCRIวรO
   
   // Reprocessa apenas a conta gerencial informada
   If !Empty(Alltrim(MV_PAR10)) .And. Alltrim(xContaG) <> Alltrim(MV_PAR10)
       Exit
   Endif

   If !xWorkFlow  // Manual
      oObj:IncRegua1("Arquivo : "+xDescG)   
      oObj:SetRegua2(Len(_xCC))	        //segunda regua
   //Else
      //ConOut("")
      //ConOut("Processando : Unidade Operacional - "+xDescG)
      //ConOut("")
   Endif  

   DbSelectArea("SZ2")
   DbSetOrder(1)      
   DbGoTop()
   If DbSeek(xFilial("SZ2")+ xCodZ1 + Space(6) + xContaG + DTOS(MV_PAR01))                    
      If UPPER(SZ2->Z2_OK) == "S"  // ja Processado
         DbselectArea("CTS")
         dbSkip() 
         Loop           
         //pos := 1
         //HLog()
         
      Else
      
         pos := 2
         //HLog()
         HISTCLEAR() // Refaz Historique      
      
      Endif          
   
   Else  // Novo Processamento
      
      pos := 3  
      //HLog()

   Endif
      
   For I:= 1 To Len(_xCC)   
       nSld     := MovCusto(xContaI,_xCC[I][1],MV_PAR01,MV_PAR02,cMoeda,cTpSald,3)   // Saldo Atual
       //nSld     := SaldoCcus(xContaI,_xCC[I][1],MV_PAR02,cMoeda,cTpSald,1)   // Saldo Atual       
       xTotal   := xTotal + nSld
	   nSldOper := nSld

       If !xWorkFlow  // Manual	   
	      oObj:IncRegua2("Calculando C.Custo : "+_xCC[I][1])	//incrementa segunda regua       
       Endif
       
       // FILTRA POR FILIAL
       Do Case
          Case Substr(_xCC[I][1],4,3) == "001"  // SEDE ADMINISTRATIVA
               nVl280 := nVl280 + nSldOper
          //Case Substr(_xCC[I][1],4,3) == "300"  // SEDE OPERACIONAL
          //     nVl300 := nVl300 + nSldOper
          Case Substr(_xCC[I][1],4,3) == "002"  // PORTO DO RIO
               nVl305 := nVl305 + nSldOper
          Case Substr(_xCC[I][1],4,3) == "014"  // RIO DE JANEIRO
               nVl310 := nVl310 + nSldOper
          Case Substr(_xCC[I][1],4,3) == "004"  // PORTO REAL
               nVl315 := nVl315 + nSldOper
          Case Substr(_xCC[I][1],4,3) == "005"  // BARUERI
               nVl320 := nVl320 + nSldOper
          Case Substr(_xCC[I][1],4,3) == "006"  // DUQUE DE CAXIAS  -> PAVUNA
               nVl325 := nVl325 + nSldOper
          Case Substr(_xCC[I][1],4,3) == "007"  // VILA GUILHERME
               nVl330 := nVl330 + nSldOper
          Case Substr(_xCC[I][1],4,3) == "008"  // SรO JOSษ DO PINHAIS
               nVl335 := nVl335 + nSldOper
          Case Substr(_xCC[I][1],4,3) == "010"  // CAMPINAS
               nVl340 := nVl340 + nSldOper
          Case Substr(_xCC[I][1],4,3) == "011"  // SEPETIBA
               nVl350 := nVl350 + nSldOper
          Case Substr(_xCC[I][1],4,3) == "012"  // SANTO AMARO -> VILA OLIMPIA
               nVl355 := nVl355 + nSldOper
          Case Substr(_xCC[I][1],4,3) == "013"  // SANTOS
               nVl360 := nVl360 + nSldOper
          Case Substr(_xCC[I][1],4,3) == "009"  // CONTAGEM - 28/11/05
               nVl345 := nVl345 + nSldOper
          Case Substr(_xCC[I][1],4,3) == "015"  // VITORIA  - 28/11/05
               nVl365 := nVl365 + nSldOper
          Case Substr(_xCC[I][1],4,3) == "016"  // SETE LAGOAS - 03/07/06
               nVl370 := nVl370 + nSldOper
               
          OtherWise
               nVlFora := nVlFora + nSldOper
       EndCase                                     
       
   Next

   dbSelectArea("CTS")
   dbSkip() 
   
   If CTS->CTS_CONTAG <> xContaG  

      If xTotal = 0 // Nใo Imprime valores zerados 
           
      Else
         
  	      DbSelectArea("SZ2")
          DbSetOrder(1)      // FILIAL + COD + CONTA + DTOS(MES)
          DbGoTop()
          If !DbSeek(xFilial("SZ2")+ xCodZ1 + Space(6) + xContaG + DTOS(MV_PAR01))                    

             RecLock ("SZ2",.T.)
             Replace Z2_FILIAL  with "  "
             Replace Z2_COD     with xCodZ1
	         Replace Z2_CONTA   with Alltrim(xContaG)
             Replace Z2_DESCR   with xDescG
    	     Replace Z2_SALDO   with xTotal
             Replace Z2_UO      with xDescZ1 //xZ1 
	         Replace Z2_MES     with MV_PAR01
    	     //
    	     // Valores Por Filial
    	     Replace Z2_SEDEADM   with  nVl280  
	         //Replace Z2_SEDEOPE   with  nVl300  
             Replace Z2_PORTORJ   with  nVl305  
    	     Replace Z2_RIO       with  nVl310  
             Replace Z2_PREAL     with  nVl315  
	         Replace Z2_BARUERI   with  nVl320  
    	     Replace Z2_CAXIAS    with  nVl325  
	         Replace Z2_VILAGUI   with  nVl330  
             Replace Z2_SJP       with  nVl335  
    	     Replace Z2_CAMPINA   with  nVl340  
             Replace Z2_SEPETIB   with  nVl350  
	         Replace Z2_STAMARO   with  nVl355  
	         Replace Z2_SANTOS    with  nVl360  
	         Replace Z2_CONTAGE   with  nVl345  // Alterado em 28/11/05
	         Replace Z2_VITORIA   with  nVl365	
	         Replace Z2_SLAGOAS   with  nVl370	
             Replace Z2_FORA      with  nVlFora
             //
             // Contole de Data e Hora Processamento Efetuado - 23/06/05
             Replace Z2_DATA      with  Dtoc(MsDate()) 
             Replace Z2_HORA      with  Time()                          
             Replace Z2_OK        with  "S"             
    	     Msunlock()
          
          Else                 
          
              //HISTCLEAR() // Refaz Historique

              //If xWorkFlow  
              //   ConOut("")
              //   ConOut("Processando : Atualizando Registros ...   " + xDescG)
              //   ConOut("")
              //Endif
 
              RecLock ("SZ2",.F.)
              Replace Z2_FILIAL    with "  "
              Replace Z2_COD       with xCodZ1
              Replace Z2_CONTA     with Alltrim(xContaG)
              Replace Z2_DESCR     with xDescG
              Replace Z2_SALDO     with xTotal
              Replace Z2_UO        with xDescZ1 //xZ1 
	          Replace Z2_MES       with MV_PAR01
        	  Replace Z2_SEDEADM   with  nVl280  
   	          //Replace Z2_SEDEOPE   with  nVl300  
              Replace Z2_PORTORJ   with  nVl305  
    	      Replace Z2_RIO       with  nVl310  
              Replace Z2_PREAL     with  nVl315  
	          Replace Z2_BARUERI   with  nVl320  
    	      Replace Z2_CAXIAS    with  nVl325  
	          Replace Z2_VILAGUI   with  nVl330  
              Replace Z2_SJP       with  nVl335  
     	      Replace Z2_CAMPINA   with  nVl340  
              Replace Z2_SEPETIB   with  nVl350  
   	          Replace Z2_STAMARO   with  nVl355  
    	      Replace Z2_SANTOS    with  nVl360  
	          Replace Z2_CONTAGE   with  nVl345  // Alterado em 28/11/05
	          Replace Z2_VITORIA   with  nVl365	 // Alterado em 28/11/05           
   	          Replace Z2_SLAGOAS   with  nVl370	
              Replace Z2_FORA      with  nVlFora
              Replace Z2_DATA      with  Dtoc(MsDate()) 
              Replace Z2_HORA      with  Time()                                       
              Replace Z2_OK        with  "S"    	      
    	      Msunlock()

          Endif
          
          xTotalG := xTotalG + xTotal       
          xTAntG  := xTAntG  + xTotAnt
          xTotal  := 0
          nSldeb  := 0
          nSlcre  := 0
          nSld    := 0   
          nSldAnt := 0                                      
          nVlFora := 0
          nVl280  := 0
          nVl300  := 0
          nVl305  := 0
          nVl310  := 0
          nVl315  := 0
          nVl320  := 0
          nVl325  := 0
          nVl330  := 0
          nVl335  := 0
          nVl340  := 0
          nVl345  := 0
          nVl350  := 0
          nVl355  := 0
          nVl360  := 0
          nVl365  := 0          
          nVl370  := 0            
          nSldOper := 0
          
          dbSelectArea("CTS")          

      Endif   
   
   Endif             

EndDo

dbCloseArea ("SZ2")

Return

////////////////////////////
Static Function HISTCLEAR() //
////////////////////////////
// LIMPA O ARQUIVO DO HISTORIQUE 
    
 //If xWorkFlow  
 //   ConOut("")
 //   ConOut("Processando : Atualizando Registros ...   " + xCodZ1 + " " + xDescG)
 //   ConOut("")
 //Endif
  
 If UPPER(SZ2->Z2_OK) == "N"
    DbSelectArea("SZ2")
    RecLock("SZ2",.F.)
    DBdelete()
    MsUnlock()         
 Endif
 
Return


///////////////////////////
Static Function HLog() //
///////////////////////////

If pos == 1
	te1:="Atualizado Registros ..:        "  + xCodZ1 + " " + xDescG + cNL
	fWrite(nHdl,te1,Len(te1))
Endif

If pos == 2                                  
	te1:="Recalculado Registros ..:        " + xCodZ1 + " " + xDescG + cNL
	fWrite(nHdl,te1,Len(te1))
Endif

If pos == 3
	te1:="Inserindo   Registros ..:        " + xCodZ1 + " " + xDescG + cNL
	fWrite(nHdl,te1,Len(te1))
Endif

Return