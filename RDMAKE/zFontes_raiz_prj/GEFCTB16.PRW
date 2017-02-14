#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "TopConn.ch"

User Function GEFCTB16(xAuto)

Private xWorkFlow   := IIF(xAuto <> nil,.T.,.F.)
Private xProcesso   := " "
Private xRelease    := GetMv("MV_HISTVER")  // Versão do Centro de custo (2005 ou 2006) 
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
      ApMsgAlert("Periodo Bloqueado - Selecione uma data apartir de 2006 ! ",'Atenção !!!')  
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
      ApMsgAlert("Periodo Bloqueado - Selecione uma data apartir de 2006 ! ",'Atenção !!!')  
      Return
   Endif
	   
   MV_PAR03 := "                  "
   MV_PAR04 := "ZZZZZZZZZZZZZZZZZZ"
   MV_PAR06 := "015" // CONFIGURAÇÃO
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


Return Nil


STATIC FUNCTION AUTOHIST(lEnd,oObj)

DbselectArea("SZ1")
DbSetOrder(1) 
dbSeek(xFilial("SZ1"))

While !Eof() .and. xFilial("SZ1") = SZ1->Z1_FILIAL
  
  /*
  DbselectArea("SZ2")
  DbSetOrder(1) 
  If DbSeek(xFilial("SZ2") + Alltrim(SZ1->Z1_COD))   
     If SZ2->Z2_MES == MV_PAR01  // Mes ja Processado
        DbselectArea("SZ1")
        dbSkip() 
        Loop     
     Endif        
  Endif
  */
  
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

// Calcula Mes Anterior
dMesAnt := Str(Month(MV_PAR01)-1)
dAnoAnt := Str(Year(MV_PAR01))
DtAnteIni := Ctod("01/01/05")
DtAnteFim := MV_PAR02 //Ctod("31/"+dMesAnt+"/"+dAnoAnt)

DbselectArea("SZ1")
DbSetOrder(1) 
Dbseek(xFilial("SZ1")+xTbUO)

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
   If SZ1->Z1_COD == "106" // Filtro Matriz porque São varios C.Custo fixo
      xUOIni := IIF(xRelease == "2005","28080","431001")
      xUOFim := IIF(xRelease == "2005","28083","437001")

	  _cQry := ""
	  _cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
	  _cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT, " + RetSqlName("CT3") + " CT3 "
	  _cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND CT3.D_E_L_E_T_ <> '*' "
	  _cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
	  _cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	  _cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
	  _cQry += " AND CT3.CT3_FILIAL =  '" + xFilial("CT3") + "' "	  	  	  
	  _cQry += " AND CTT_CUSTO = CT3_CUSTO " 
	  _cQry += " AND CTS_CT1INI = CT3_CONTA " 
	  _cQry += " AND CTT_CUSTO >= '" + xUOIni + "' "
	  _cQry += " AND CTT_CUSTO <= '" + xUOFim + "' "	  
	  _cQry += " ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "
	  
	  TCQUERY _cQry ALIAS "TCTS" NEW
	  dbSelectArea("TCTS") 
	  dbGoTop()
   
   Endif
   
   If SZ1->Z1_COD == "008"      
      xUOIni := "431001"

	  _cQry := ""
	  _cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
	  _cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT, " + RetSqlName("CT3") + " CT3 "
	  _cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND CT3.D_E_L_E_T_ <> '*' "
	  _cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
	  _cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	  _cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
	  _cQry += " AND CT3.CT3_FILIAL =  '" + xFilial("CT3") + "' "	  	  	  
	  _cQry += " AND CTT_CUSTO = CT3_CUSTO " 
	  _cQry += " AND CTS_CT1INI = CT3_CONTA " 
	  _cQry += " AND (CTT_CUSTO = '431001' "
	  _cQry += "      OR CTT_CUSTO = '434001' " 
  	  _cQry += "      OR CTT_CUSTO = '437001') "	  
	  _cQry += "  ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "
	  
	  TCQUERY _cQry ALIAS "TCTS" NEW
	  dbSelectArea("TCTS") 
	  dbGoTop()
   
   Endif
   
   If SZ1->Z1_COD <> "008" .And. SZ1->Z1_COD <> "106"

	  _cQry := ""
	  _cQry := "SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
	  _cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT, " + RetSqlName("CT3") + " CT3 "
	  _cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND CT3.D_E_L_E_T_ <> '*' "
	  _cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
	  _cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	  _cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
	  _cQry += " AND CT3.CT3_FILIAL =  '" + xFilial("CT3") + "' "	  	  	  
	  _cQry += " AND CTT_CUSTO = CT3_CUSTO " 
	  _cQry += " AND CTS_CT1INI = CT3_CONTA " 
	  _cQry += " AND CTT_CUSTO = '" + xUO + "' "
	  _cQry += " ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "
	  
	  TCQUERY _cQry ALIAS "TCTS" NEW
	  dbSelectArea("TCTS") 
	  dbGoTop()

   Endif
   
Endif

If xTipo == "2" // Cod. da U.O   
   DbselectArea("SZ1")     
   If SZ1->Z1_COD == "102" //.Or. SZ1->Z1_COD == "201" .Or. SZ1->Z1_COD == "203" 
      xUOIni := Substr(SZ1->Z1_FILTRO,1,2)
      xUOFim := Substr(SZ1->Z1_FILTRO,4,2)
      
	  _cQry := ""
	  _cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
	  _cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT, " + RetSqlName("CT3") + " CT3 "
	  _cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND CT3.D_E_L_E_T_ <> '*' "
	  _cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
	  _cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	  _cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
	  _cQry += " AND CT3.CT3_FILIAL =  '" + xFilial("CT3") + "' "	  	  	  
	  _cQry += " AND CTT_CUSTO = CT3_CUSTO " 
	  _cQry += " AND CTS_CT1INI = CT3_CONTA " 
	  If xRelease == "2005"
	  	  _cQry += " AND CTT_UO >= '" + xUOIni + "' "
	  EndIF
	  _cQry += " AND CTT_UONEW >= '" + xUOIni + "' "
	  _cQry += " AND CTT_UONEW <= '" + xUOFim + "' "	  
	  _cQry += " ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "
	  
	  TCQUERY _cQry ALIAS "TCTS" NEW
	  dbSelectArea("TCTS") 
	  dbGoTop()

   Endif   
   //
   // RMA + Aduana
   DbselectArea("SZ1")           
   If SZ1->Z1_COD == "110"  // U.O (6,8)
      xUOIni := "22"
      xUOFim := "23"

	  _cQry := ""
	  _cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
	  _cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT, " + RetSqlName("CT3") + " CT3 "
	  _cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND CT3.D_E_L_E_T_ <> '*' "
	  _cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
	  _cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	  _cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
	  _cQry += " AND CT3.CT3_FILIAL =  '" + xFilial("CT3") + "' "	  	  	  
	  _cQry += " AND CTT_CUSTO = CT3_CUSTO " 
	  _cQry += " AND CTS_CT1INI = CT3_CONTA " 
	  _cQry += " AND CTT_UONEW >= '" + xUOIni + "' "
	  _cQry += " AND CTT_UONEW <= '" + xUOFim + "' "	  
	  _cQry += " ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "
	  
	  TCQUERY _cQry ALIAS "TCTS" NEW
	  dbSelectArea("TCTS") 
	  dbGoTop()

   Endif


   DbselectArea("SZ1")                 
   If SZ1->Z1_COD <> "102" .And. SZ1->Z1_COD <> "110"  // Demais Configurações
   
	  _cQry := ""
	  _cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
	  _cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT, " + RetSqlName("CT3") + " CT3 "
	  _cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND CT3.D_E_L_E_T_ <> '*' "
	  _cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
	  _cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	  _cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
	  _cQry += " AND CT3.CT3_FILIAL =  '" + xFilial("CT3") + "' "	  	  	  
	  _cQry += " AND CTT_CUSTO = CT3_CUSTO " 
	  _cQry += " AND CTS_CT1INI = CT3_CONTA " 
	  _cQry += " AND CTT_UONEW = '" + xUO + "' "
	  _cQry += " ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "
	  
	  TCQUERY _cQry ALIAS "TCTS" NEW
	  dbSelectArea("TCTS") 
	  dbGoTop()
     
      DbselectArea("TCTS")      
      Dbgotop()
      While !Eof()
            AADD(_xCC,{CTT->CTT_CUSTO})
	        DbselectArea("TCTS")
	        dbSkip() 
	  EndDo      

   Endif
Endif

If !xWorkFlow  // Manual
   If MV_PAR06 == "015"    // HISTORIQUE
      oObj:SetRegua1(194)	
   Else
      oObj:SetRegua1(11)	
   Endif
Endif

If Empty(MV_PAR06)
   MV_PAR06 := "015"
Endif
  
dbSelectArea("TCTS") 
dbGoTop()

While !EOF() // .And. Alltrim(CTS->CTS_CODPLA) ==  Alltrim(MV_PAR06) 
      
   xCodPla  := TCTS->CTS_CODPLA   // COD. PLANO GER.
   xContaG  := TCTS->CTS_CONTAG   // CONTA GERENCIAL
   xContaI  := TCTS->CTS_CT1INI   // CONTA INICIO
   xContaF  := TCTS->CTS_CT1FIM   // CONTA FIM
   xCcustoI := TCTS->CTS_CTTINI   // C.CUSTO INICIO
   xCcustoF := TCTS->CTS_CTTFIM   // C.CUSTO FIM
   xDescG   := Alltrim(TCTS->CTS_DESCCG)   // DESCRIÇÃO
   
   // Reprocessa apenas a conta gerencial informada
   If !Empty(Alltrim(MV_PAR10)) .And. Alltrim(xContaG) <> Alltrim(MV_PAR10)
       Exit
   Endif

   If !xWorkFlow  // Manual
      oObj:IncRegua1("Arquivo : "+xDescG)   
      oObj:SetRegua2(Len(_xCC))	        //segunda regua
   Endif  

   DbSelectArea("SZ2")
   DbSetOrder(1)      
   If DbSeek(xFilial("SZ2")+ xCodZ1 + Space(6) + xContaG + DTOS(MV_PAR01))                    
      If UPPER(SZ2->Z2_OK) == "S"  // ja Processado
         DbselectArea("CTS")
         dbSkip() 
         Loop                   
      Else      
         pos := 2
         COMPRASCLEAR() // Refaz Historique            
      Endif             
   Else  // Novo Processamento      
      pos := 3  
   Endif
      
       nSld     := MovCusto(xContaI, TCTS->CTT_CUSTO,MV_PAR01,MV_PAR02,cMoeda,cTpSald,3)   // Saldo Atual
       xTotal   := xTotal + nSld
	   nSldOper := nSld

       If !xWorkFlow  // Manual	   
	      oObj:IncRegua2("Calculando C.Custo : "+TCTS->CTT_CUSTO )	//incrementa segunda regua       	      
       Endif
       
       // FILTRA POR FILIAL
       Do Case
          Case Substr(TCTS->CTT_CUSTO,4,3) == "001"  // SEDE ADMINISTRATIVA
               nVl280 := nVl280 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "002"  // PORTO DO RIO
               nVl305 := nVl305 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "014"  // RIO DE JANEIRO
               nVl310 := nVl310 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "004"  // PORTO REAL
               nVl315 := nVl315 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "005"  // BARUERI
               nVl320 := nVl320 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "006"  // DUQUE DE CAXIAS  -> PAVUNA
               nVl325 := nVl325 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "007"  // VILA GUILHERME
               nVl330 := nVl330 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "008"  // SÃO JOSÉ DO PINHAIS
               nVl335 := nVl335 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "010"  // CAMPINAS
               nVl340 := nVl340 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "011"  // SEPETIBA
               nVl350 := nVl350 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "012"  // SANTO AMARO -> VILA OLIMPIA
               nVl355 := nVl355 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "013"  // SANTOS
               nVl360 := nVl360 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "009"  // CONTAGEM - 28/11/05
               nVl345 := nVl345 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "015"  // VITORIA  - 28/11/05
               nVl365 := nVl365 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "016"       // SETE LAGOAS - 03/07/06
               nVl370 := nVl370 + nSldOper
               
          OtherWise
               nVlFora := nVlFora + nSldOper
       EndCase                                     
       
   dbSelectArea("TCTS")
   dbSkip() 
   
   If TCTS->CTS_CONTAG <> xContaG  

      If xTotal = 0 // Não Imprime valores zerados 
           
      Else

       //
       // GRAVAR MOV. POR ATIVIDADE
       //   
       xFilOrig   := Substr(TCTS->CTT_CUSTO,4,3)
       xAtividade := Substr(TCTS->CTT_CUSTO,7,3)

    
       DbSelectArea("SZ4")
       DbSetOrder(1)      // FILIAL + COD + CONTA + FILORI + ATIVIDADE
       DbGoTop()
       If !DbSeek(xFilial("SZ4") + Alltrim(xCodZ1) + Alltrim(xContaG)+ " " + Alltrim(xFilOrig) + Alltrim(xAtividade))
          RecLock("SZ4",.T.)
          Replace Z4_FILIAL  with xFilial("SZ4")
          Replace Z4_COD     with xCodZ1
          Replace Z4_CONTA   with xContaG
          Replace Z4_FILORIG with xFilOrig
	      Replace Z4_ATIVIDA with xAtividade
          Replace Z4_SALDO   with nSldOper
          Replace Z4_UO      with xDescZ1 
          Replace Z4_DESCR   with xDescG  
          Msunlock()          
       Else                 
          nAcm := SZ4->Z4_SALDO + nSld
          RecLock("SZ4",.F.)
          Replace Z4_SALDO   with nAcm
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
          
          dbSelectArea("TCTS")          

      Endif   
   
   Endif             

EndDo

                                       
dbSelectArea("TCTS")          
DbCloseArea()

dbCloseArea ("SZ2")          
Return

////////////////////////////
Static Function COMPRASCLEAR() //
////////////////////////////
  
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