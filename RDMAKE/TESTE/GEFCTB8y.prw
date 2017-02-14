#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "TopConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEFCTB08  º Autor ³ SAULO MUNIZ        º Data ³  14/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualiza Tabela p/ Fechamento                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEFCO                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Tratamento de Geração do arquivo por agendamento
// Incluido Vendas Fora Sede
// Incluido Data/Hora de Geração - Saulo Muniz 23/06/05
// Incluido Recof (Dig.9) no Rma - 110/103 - Saulo Muniz 29/06/05
// Processamento por Agendamento - Saulo Muniz 11/07/05
// Processar apenas as contas alteradas - Matrix - Saulo Muniz 01/08/05
// Incluida filiais : Contagem e Vitoria - Saulo Muniz 28/11/05
// Alterado novo lay-out - Saulo Muniz 28/11/05
// Novo tratamento para estrutura dos centro de custo  - Saulo Muniz 22/12/05
// Alterado Novo indice(Ordem 7) devido a atualização do sistema ver.8  - Saulo Muniz 26/12/05
// Alterado Novo nova configuração do centro de custo - Saulo Muniz 26/12/05
// Criado resumo para Metier - Saulo Muniz 02/02/06
// Separada Rma e Aduana nos codigos (103 e 109) - Saulo Muniz 14/02/06
// Ativado recurso de processamento da conta informada - Saulo Muniz 20/02/06
// Ativado nova configuração 008 (DG + DCM + ADM) - Saulo Muniz 05/04/06
// Adicionado Tratamento para campo Z2_INTPR - Saulo Muniz 30/11/06

User Function GEFCTB8y(xAuto)

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
   If !Pergunte(cPerg,.T.)
   		return
   EndIf

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
   MV_PAR06 := "001" // CONFIGURAÇÃO
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
// Dbgotop()
dbSeek(xFilial("SZ1"))

While !Eof() .and. xFilial("SZ1") = SZ1->Z1_FILIAL

/*  
  If Eof()
     Return
  Endif
*/  

  DbselectArea("SZ2")
  DbSetOrder(1) 
  // Dbgotop()
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
nPrInt  := 0

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
// Dbgotop()
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
   If SZ1->Z1_COD == "106" // Filtro Matriz porque São varios C.Custo fixo
      xUOIni := IIF(xRelease == "2005","28080","431001")
//      xUOFim := IIF(xRelease == "2005","28083","437001")
      xUOFim := IIF(xRelease == "2005","28083","438001")      

	  _cQry := ""
	  _cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTS_FORMUL, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
	  _cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT, " + RetSqlName("CT3") + " CT3 "
	  _cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND CT3.D_E_L_E_T_ <> '*' "
	  _cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
	  _cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	  _cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
	  _cQry += " AND CT3.CT3_FILIAL =  '" + xFilial("CT3") + "' "	  	  	  
	  _cQry += " AND CT3.CT3_DATA >= " + "'"+DTOS(Mv_Par01)+"' "
	  _cQry += " AND CT3.CT3_DATA <= " + "'"+DTOS(Mv_Par02)+"' "
	  _cQry += " AND CTT_CUSTO = CT3_CUSTO " 
	  _cQry += " AND CTS_CT1INI = CT3_CONTA " 
	  _cQry += " AND CTT_CUSTO >= '" + xUOIni + "' "
	  _cQry += " AND CTT_CUSTO <= '" + xUOFim + "' "	  
	  _cQry += " ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "


/*	  _cQry := ""
	  _cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
	  _cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT "
	  _cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*'
	  _cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
	  _cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	  _cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
	  _cQry += " AND CTT_CUSTO >= '" + xUOIni + "' "
	  _cQry += " AND CTT_CUSTO <= '" + xUOFim + "' "	  
	  _cQry += " AND (CTT_CUSTO) IN "
	  _cQry += " (SELECT DISTINCT CT3_CUSTO "
	  _cQry += "  FROM " + RetSqlName("CT3") + " CT3 "
	  _cQry += "  WHERE CT3_FILIAL =  '" + xFilial("CT3") + "' AND D_E_L_E_T_ <> '*' ) "
	  _cQry += " ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "*/
	  
	  TCQUERY _cQry ALIAS "TCTS" NEW
	  dbSelectArea("TCTS") 
	  dbGoTop()
/*


      DbselectArea("CTT")     
      DbSetOrder(1)       // CTT_FILIAL + CTT_UO
//      Dbgotop()
      Dbseek(xFilial("CTT")+xUOIni)  
      While !Eof() .And. Alltrim(CTT->CTT_CUSTO) >= xUOIni .And. Alltrim(CTT->CTT_CUSTO) <= xUOFim
            AADD(_xCC,{CTT->CTT_CUSTO})
            DbselectArea("CTT")
            dbSkip() // Avanca o ponteiro do registro no arquivo      
      EndDo     */
   
   Endif


   If SZ1->Z1_COD == "111" // MATRIZ - DCM       

	  _cQry := ""
	  _cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTS_FORMUL, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
	  _cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT, " + RetSqlName("CT3") + " CT3 "
	  _cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND CT3.D_E_L_E_T_ <> '*' "
	  _cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
	  _cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	  _cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
	  _cQry += " AND CT3.CT3_FILIAL =  '" + xFilial("CT3") + "' "	  	  	  
	  _cQry += " AND CT3.CT3_DATA >= " + "'"+DTOS(Mv_Par01)+"' "
	  _cQry += " AND CT3.CT3_DATA <= " + "'"+DTOS(Mv_Par02)+"' "
	  _cQry += " AND CTT_CUSTO = CT3_CUSTO " 
	  _cQry += " AND CTS_CT1INI = CT3_CONTA " 
	  _cQry += " AND (CTT_CUSTO = '431001' "     //Diretoria Geral
	  _cQry += "      OR CTT_CUSTO = '432001' "  //DFCP
	  _cQry += "      OR CTT_CUSTO = '433001' "  //DRHCO	  
	  _cQry += "      OR CTT_CUSTO = '435001' "  //Qualidade	  
	  _cQry += "      OR CTT_CUSTO = '438001' "  //DIR LOG PSA 	  
  	  _cQry += "      OR CTT_CUSTO = '437001') " //Administrativo	  
	  _cQry += " ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "

	  
	  TCQUERY _cQry ALIAS "TCTS" NEW
	  dbSelectArea("TCTS") 
	  dbGoTop()
   
   Endif


   
   If SZ1->Z1_COD == "008"      
      xUOIni := "431001"

	  _cQry := ""
	  _cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTS_FORMUL, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
	  _cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT, " + RetSqlName("CT3") + " CT3 "
	  _cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND CT3.D_E_L_E_T_ <> '*' "
	  _cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
	  _cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	  _cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
	  _cQry += " AND CT3.CT3_FILIAL =  '" + xFilial("CT3") + "' "	  	  	  
	  _cQry += " AND CT3.CT3_DATA >= " + "'"+DTOS(Mv_Par01)+"' "
	  _cQry += " AND CT3.CT3_DATA <= " + "'"+DTOS(Mv_Par02)+"' "
	  _cQry += " AND CTT_CUSTO = CT3_CUSTO " 
	  _cQry += " AND CTS_CT1INI = CT3_CONTA " 
	  _cQry += " AND (CTT_CUSTO = '431001' "
	  _cQry += "      OR CTT_CUSTO = '438001' " 
  	  _cQry += "      OR CTT_CUSTO = '437001') "	  
	  _cQry += "  ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "
	  
	  TCQUERY _cQry ALIAS "TCTS" NEW
	  dbSelectArea("TCTS") 
	  dbGoTop()
/*
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
      EndDo                                                           */
   
   Endif
   
   If SZ1->Z1_COD <> "008" .And. SZ1->Z1_COD <> "106" .And. SZ1->Z1_COD <> "111"

	  _cQry := ""
	  _cQry := "SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTS_FORMUL, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
	  _cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT, " + RetSqlName("CT3") + " CT3 "
	  _cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND CT3.D_E_L_E_T_ <> '*' "
	  _cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
	  _cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	  _cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
	  _cQry += " AND CT3.CT3_FILIAL =  '" + xFilial("CT3") + "' "	  	  	  
	  _cQry += " AND CT3.CT3_DATA >= " + "'"+DTOS(Mv_Par01)+"' "
	  _cQry += " AND CT3.CT3_DATA <= " + "'"+DTOS(Mv_Par02)+"' "
	  _cQry += " AND CTT_CUSTO = CT3_CUSTO " 
	  _cQry += " AND CTS_CT1INI = CT3_CONTA " 
	  _cQry += " AND CTT_CUSTO = '" + xUO + "' "
	  _cQry += " ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "
	  
	  TCQUERY _cQry ALIAS "TCTS" NEW
	  dbSelectArea("TCTS") 
	  dbGoTop()


/*      DbselectArea("CTT")     
      DbSetOrder(1)       
      Dbgotop()
      Dbseek(xFilial("CTT")+xUO)  
      While !Eof() .And. Alltrim(CTT->CTT_CUSTO) == xUO   
            AADD(_xCC,{CTT->CTT_CUSTO})
            DbselectArea("CTT")
            dbSkip() // Avanca o ponteiro do registro no arquivo      
      EndDo   */
   Endif
   
Endif

If xTipo == "2" // Cod. da U.O   
   DbselectArea("SZ1")     
   If SZ1->Z1_COD == "102" //.Or. SZ1->Z1_COD == "201" .Or. SZ1->Z1_COD == "203" 
      xUOIni := Substr(SZ1->Z1_FILTRO,1,2)
      xUOFim := Substr(SZ1->Z1_FILTRO,4,2)
      
	  _cQry := ""
	  _cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTS_FORMUL, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
	  _cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT, " + RetSqlName("CT3") + " CT3 "
	  _cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND CT3.D_E_L_E_T_ <> '*' "
	  _cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
	  _cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	  _cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
	  _cQry += " AND CT3.CT3_FILIAL =  '" + xFilial("CT3") + "' "	  	  	  
	  _cQry += " AND CT3.CT3_DATA >= " + "'"+DTOS(Mv_Par01)+"' "
	  _cQry += " AND CT3.CT3_DATA <= " + "'"+DTOS(Mv_Par02)+"' "
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

/*      
      DbselectArea("CTT")     
      IIF(xRelease == "2005",DbSetOrder(6),DbSetOrder(7))     
      Dbgotop()
      Dbseek(xFilial("CTT")+xUOIni)  
      While !Eof() .And. Alltrim(CTT->CTT_UONEW) >= xUOIni .And. Alltrim(CTT->CTT_UONEW) <= xUOFim
            AADD(_xCC,{CTT->CTT_CUSTO})
            DbselectArea("CTT")
            dbSkip() // Avanca o ponteiro do registro no arquivo      
      EndDo     */
   Endif   
   //
   // RMA + Aduana
   DbselectArea("SZ1")           
   If SZ1->Z1_COD == "110"  // U.O (6,8)
      xUOIni := "22"
      xUOFim := "23"

	  _cQry := ""
	  _cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTS_FORMUL, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
	  _cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT, " + RetSqlName("CT3") + " CT3 "
	  _cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND CT3.D_E_L_E_T_ <> '*' "
	  _cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
	  _cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	  _cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
	  _cQry += " AND CT3.CT3_FILIAL =  '" + xFilial("CT3") + "' "	  	  	  
	  _cQry += " AND CT3.CT3_DATA >= " + "'"+DTOS(Mv_Par01)+"' "
	  _cQry += " AND CT3.CT3_DATA <= " + "'"+DTOS(Mv_Par02)+"' "
	  _cQry += " AND CTT_CUSTO = CT3_CUSTO " 
	  _cQry += " AND CTS_CT1INI = CT3_CONTA " 
	  _cQry += " AND CTT_UONEW >= '" + xUOIni + "' "
	  _cQry += " AND CTT_UONEW <= '" + xUOFim + "' "	  
	  _cQry += " ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "
	  
	  TCQUERY _cQry ALIAS "TCTS" NEW
	  dbSelectArea("TCTS") 
	  dbGoTop()


/*      DbselectArea("CTT")     
      DbSetOrder(7)     
      Dbgotop()
      Dbseek(xFilial("CTT")+xUOIni)        
         While !Eof() .And. Alltrim(CTT->CTT_UONEW) >= "22" .And. Alltrim(CTT->CTT_UONEW) <= "23" 
	         AADD(_xCC,{CTT->CTT_CUSTO})
   	         DbselectArea("CTT")
	         dbSkip() 
	     EndDo                          	      */
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
   DbselectArea("SZ1")                 
   If SZ1->Z1_COD <> "102" .And. SZ1->Z1_COD <> "110"  // Demais Configurações
   
	  _cQry := ""
	  _cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTS_FORMUL, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
	  _cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT, " + RetSqlName("CT3") + " CT3 "
	  _cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND CT3.D_E_L_E_T_ <> '*' "
	  _cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
	  _cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	  _cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
	  _cQry += " AND CT3.CT3_FILIAL =  '" + xFilial("CT3") + "' "	  	  	  
	  _cQry += " AND CT3.CT3_DATA >= " + "'"+DTOS(Mv_Par01)+"' "
	  _cQry += " AND CT3.CT3_DATA <= " + "'"+DTOS(Mv_Par02)+"' "
	  _cQry += " AND CTT_CUSTO = CT3_CUSTO " 
	  _cQry += " AND CTS_CT1INI = CT3_CONTA " 
	  _cQry += " AND CTT_UONEW = '" + xUO + "' "
	  _cQry += " ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "
	  
	  TCQUERY _cQry ALIAS "TCTS" NEW
	  dbSelectArea("TCTS") 
	  dbGoTop()
     
/*      DbselectArea("CTT")      
      DbSetOrder(7)    
      Dbgotop()
      Dbseek(xFilial("CTT")+xUO)  
      While !Eof() .And. Alltrim(CTT->CTT_UONEW) == xUO   
	        AADD(_xCC,{CTT->CTT_CUSTO})
	        DbselectArea("CTT")
	        dbSkip() 
	  EndDo      */

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
   If MV_PAR06 == "001"    // HISTORIQUE
      oObj:SetRegua1(194)	
   Else
      oObj:SetRegua1(11)	
   Endif
Endif

If Empty(MV_PAR06)
   MV_PAR06 := "001"
Endif
  
/*                 
Comentado Por: J Ricardo
dbSelectArea("CTS")
dbSetOrder(2) // 1
dbGoTop()
Dbseek(xFilial("CTS")+Alltrim(MV_PAR06)+Alltrim(MV_PAR10))
*/
//Dbseek(xFilial("CTS")+Alltrim(MV_PAR06))

*-------------------------------------------*
* Por: J Ricardo - Em: 08/05/2006           *
* Objetivo: Otimizar o processo             *
*-------------------------------------------*
/*_cQry := ""

_cQry := "SELECT * FROM " + RetSqlName("CTS") + " CTS "
_cQry += "	WHERE RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
// _cQry += "	  AND RTRIM(CTS.CTS_CONTAG) = '" + Alltrim(MV_PAR10) + "' "
_cQry += "	  AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
_cQry += "	  AND CTS.D_E_L_E_T_ <> '*' "                  
_cQry += "	  ORDER BY CTS_CODPLA, CTS_CONTAG "                  


If Select("TCTS") > 0
   dbSelectArea("TCTS") ; dbCloseArea()
EndIf

TCQUERY _cQry ALIAS "TCTS" NEW*/
dbSelectArea("TCTS") ; dbGoTop()


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
   //Else
      //ConOut("")
      //ConOut("Processando : Unidade Operacional - "+xDescG)
      //ConOut("")
   Endif  

   DbSelectArea("SZ2")
   DbSetOrder(1)      
//   DbGoTop()
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
      
//   For I:= 1 To Len(_xCC)        
  //	   dbSelectArea("CT3")
//	   dbSetOrder(2)
//	   MsSeek(xFilial("CT3")+xContaI+cCusto+cMoeda+cTpSald+DTOS(dData),.T.)
//	   iF DBSeek(xFilial("CT3")+xContaI+_xCC[I][1])	   
   dbSelectArea("TCTS")
		IF empty(TCTS->CTS_FORMUL)
	       nSld     := MovCusto(xContaI, TCTS->CTT_CUSTO,MV_PAR01,MV_PAR02,cMoeda,cTpSald,3)   // Saldo Atual		
		Else                       
			/*
			Alteração  - Marcos Furtado - 24/02/2007
			
			O campo CTS_FORMUL passou a ser utilizado em 24/02/2007 para abertura de vendas (PSA, GEFCO, Fora Grupo e um 
			grupo criado por sergurança para pegar faturamento de venda fora do normal). 
			Para isto foram incluídas contas na visão gerencial para cada abertura.
			*/
			If &(TCTS->CTS_FORMUL)
				If AllTrim(TCTS->CTS_FORMUL) == "SUBSTR(CTT_CUSTO,10,1) == ''"                                        
				    nSld     := MovCusto(xContaI, TCTS->CTT_CUSTO,MV_PAR01,MV_PAR02,cMoeda,cTpSald,3)   // Saldo Atual				
				Else
				    nSld     := MovCusto(xContaI, TCTS->CTT_CUSTO,MV_PAR01,MV_PAR02,cMoeda,cTpSald,3)   // Saldo Atual
				EndIF
			Else
				   nSld     := 0    
			EndIf 					
		EndIf
       //nSld     := SaldoCcus(xContaI,_xCC[I][1],MV_PAR02,cMoeda,cTpSald,1)   // Saldo Atual       
/*
         Else           
		   nSld     := 0      
       EndIF	
*/                                            


		
       xTotal   := xTotal + nSld
	   nSldOper := nSld

       If !xWorkFlow  // Manual	   
//	      oObj:IncRegua2("Calculando C.Custo : "+TCTS->CTT_CUSTO + " - " + str(I))	//incrementa segunda regua       
	      oObj:IncRegua2("Calculando C.Custo : "+TCTS->CTT_CUSTO )	//incrementa segunda regua       	      
       Endif
       
       // FILTRA POR FILIAL
       Do Case
          Case Substr(TCTS->CTT_CUSTO,4,3) == "001"  // SEDE ADMINISTRATIVA
               nVl280 := nVl280 + nSldOper
          //Case Substr(_xCC[I][1],4,3) == "300"  // SEDE OPERACIONAL
          //     nVl300 := nVl300 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "002"  // PORTO DO RIO
               nVl305 := nVl305 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "014"  // RIO DE JANEIRO
               nVl310 := nVl310 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "004"  // PORTO REAL
               nVl315 := nVl315 + nSldOper
			   If (Substr(TCTS->CTT_CUSTO,7,3) == "202" .Or. Substr(TCTS->CTT_CUSTO,7,3) == "209") .And. Substr(TCTS->CTT_CUSTO,10,1) == "3"
				   nPrInt := nPrInt + nSldOper
			   Endif			   
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
		  *------------------------------------------------------------------------------------------------*
		  * Por: Ricardo - Em: 15/10/2007 - Motivo: Solicitação para tratamento das Filias junto com a UO  * 
		  *------------------------------------------------------------------------------------------------*
          Case Substr(TCTS->CTT_CUSTO,4,3) == "901" .AND. Substr(TCTS->CTT_CUSTO,2,2) == "22"  // VILA OLIMPIA (Antena - Guarulhos / RMA)
               nVl355 := nVl355 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "901" .AND. Substr(TCTS->CTT_CUSTO,2,2) == "23"  // VILA GUILHERME (Antena - Guarulhos / Aduana)
               nVl330 := nVl330 + nSldOper
          Case Substr(TCTS->CTT_CUSTO,4,3) == "902" .AND.;
           		(Substr(TCTS->CTT_CUSTO,2,2) == "22" .OR. Substr(TCTS->CTT_CUSTO,2,2) == "23")  // VILA OLIMPIA (Antena - Rezende / RMA+Aduana)
               nVl315 := nVl315 + nSldOper
          OtherWise
               nVlFora := nVlFora + nSldOper
       EndCase                                     
       
//   Next

   dbSelectArea("TCTS")
   dbSkip() 
   
   If TCTS->CTS_CONTAG <> xContaG  

      If xTotal = 0 // Não Imprime valores zerados 
           
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
	         Replace Z2_VITORIA   with  nVl365	// Alterado em 28/11/05           
             Replace Z2_FORA      with  nVlFora
	         Replace Z2_SLAGOAS   with  nVl370	
	         Replace Z2_INTPR     with  nPrInt 
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
  	          Replace Z2_INTPR     with  nPrInt 
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
          nPrInt   := 0        
           
          dbSelectArea("TCTS")          

      Endif   
   
   Endif             

EndDo

                                       
dbSelectArea("TCTS")          
DbCloseArea()

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

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MovCusto   ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 04.07.01³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Devolve Movimentos do SIGACTB - CT3 - Planilha              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³aMovimento[nQualSaldo]									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Planilha                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cConta     = Codigo da Conta                               ³±±
±±³          ³ cCusto     = Codigo do Centro de Custo                     ³±±
±±³          ³ dDataIni   = Data Inicial                                  ³±±
±±³          ³ dDataFim   = Data Final                                    ³±±
±±³          ³ cMoeda     = Moeda                                         ³±±
±±³          ³ cTpSald    = Tipo de Saldo                                 ³±±
±±³          ³ nQualSaldo = Retorno Desejado                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MovCustoX(cConta,cCusto,dDataIni,dDataFim,cMoeda,cTpSald,nQualSaldo)

Local aSaldoIni	:= {}
Local aSaldoFim	:= {}
Local aMovimento:= {}
Local nDebito
Local nCredito
Local lTodoCT1	:= .F.
Local lTodoCTT	:= .F.

/*DEFAULT cConta := ""
DEFAULT cCusto := ""*/

cTpSald		:= Iif(cTpSald==Nil,"1",cTpSald)
nQualSaldo	:= Iif(nQualSaldo==Nil,1,nQualSaldo)

// Devolve valor somente do Centro de Custo (Soma todas as contas)
If !Empty(cCusto)
	lTodoCT1	:= !Empty(cConta) .and. UPPER(cConta) == Replicate("Z",Len(cConta)) 
	lTodoCTT	:= !Empty(cCusto) .and. UPPER(cCusto) == Replicate("Z",Len(cCusto))
	If Empty(cConta)
		cCusto	  := PadR(cCusto,Len(CTU->CTU_CODIGO))					
		aSaldoIni := SaldoCTU("CTT",cCusto,dDataIni,cMoeda,cTpSald)
		aSaldoFim := SaldoCTU("CTT",cCusto,dDataFim,cMoeda,cTpSald)		
	ElseIf lTodoCT1 .or. lTodoCTT
		/// Saldo de uma ou todas entidades de acordo com os parâmetros ZZZZ
		If lTodoCT1
			cContaIni := ""
			cContaFim := Replicate("Z",Len(CTI->CTI_CONTA))
		Else
			cContaIni	:= PadR(cConta,Len(CTI->CTI_CONTA))					
			cContaFim	:= cContaIni
		Endif
		If lTodoCTT
			cCustoIni	:= ""
			cCustoFim	:= Replicate("Z",Len(CTI->CTI_CUSTO))
		Else
			cCustoIni	:= PadR(cCusto,Len(CTI->CTI_CUSTO))									
			cCustoFim	:= cCustoIni
		Endif
		aSaldoIni := SaldTotCT3X(cCustoIni,cCustoFim,cContaIni,cContaFim,dDataIni,cMoeda,cTpSald)
		aSaldoFim := SaldTotCT3X(cCustoIni,cCustoFim,cContaIni,cContaFim,dDataFim,cMoeda,cTpSald)
	Else                                                                    
		cConta	  := PadR(cConta,Len(CT3->CT3_CONTA))							
		cCusto	  := PadR(cCusto,Len(CT3->CT3_CUSTO))						
	// Devolve valor do Centro de Custo + Conta
		aSaldoIni 	:= SaldoCt3X(cConta,cCusto,dDataIni,cMoeda,cTpSald)
		aSaldoFim	:= SaldoCT3X(cConta,cCusto,dDataFim,cMoeda,cTpSald)
	EndiF	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno:                                          ³
//³ [1] Movimento Devedor 	                           ³
//³ [2] Movimento Credor		                        ³
//³ [3] Movimento do Mes		                        ³
//³ [4] Saldo Final                                	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nDebito		:= aSaldoFim[4] - aSaldoIni[7]
nCredito	:= aSaldoFim[5] - aSaldoIni[8]
 
aMovimento 	:= {nDebito,nCredito,nCredito-nDebito,aSaldoFim[1]}

Return aMovimento[nQualSaldo]


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SaldoCT3  ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 15.12.99 			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Saldo do Centro de custo                                   			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ SaldoCT3(cConta,cCusto,dData,cMoeda,cTpSald)               			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³{nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt,nAntDeb,nAntCrd}³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Conta Contabil                                    		    ³±±
±±³          ³ ExpC2 = Centro de Custo                                   		    ³±±
±±³          ³ ExpD1 = Data                                              		    ³±±
±±³          ³ ExpC3 = Moeda                                             		    ³±±
±±³          ³ ExpC4 = Tipo de Saldo                                     		    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                       
Static Function SaldoCT3X(cConta,cCusto,dData,cMoeda,cTpSald,cRotina,lImpAntLP,dDataLP)

//Local aSaveArea	:= CT3->(GetArea())
Local aSaveAnt	:= GetArea()
Local lNaoAchei	:= .F.
Local nDebito	:= 0					// Valor Debito na Data
Local nCredito 	:= 0					// Valor Credito na Data
Local nAtuDeb  	:= 0					// Saldo Atual Devedor
Local nAtuCrd	:= 0					// Saldo Atual Credor
Local nAntDeb	:= 0					// Saldo Anterior Devedor
Local nAntCrd	:= 0					// Saldo Anterior Credor
Local nSaldoAnt	:= 0					// Saldo Anterior (com sinal)
Local nSaldoAtu	:= 0					// Saldo Atual (com sinal)
Local bCondicao	:= { || CT3->CT3_FILIAL==xFilial("CT3") .And. CT3->CT3_CUSTO == cCusto .And.;
						CT3->CT3_CONTA == cConta .And. CT3->CT3_MOEDA == cMoeda .And.;
						CT3->CT3_TPSALD == cTpSald .and. CT3->CT3_DATA <= dData }
Local bCondLP	:= {|| CT3->CT3_FILIAL==xFilial("CT3") .And. CT3->CT3_CUSTO == cCusto .And.;
						CT3->CT3_CONTA == cConta .And. CT3->CT3_MOEDA == cMoeda .And.;
						CT3->CT3_TPSALD == cTpSald .and. CT3->CT3_LP == "Z" .And.;
						dDataLP <= dData }
Local cChaveLP	:=(xFilial("CT3")+"Z"+cConta+cCusto+cMoeda+cTpSald)						
Local aSldLP	:= {0,0}

cTpSald		:= Iif(Empty(cTpSald),"1",cTpSald)
dDataLp		:= Iif(dDataLP==Nil,CTOD("  /  /  "),dDataLP)              
cRotina		:= Iif(cRotina==Nil,"",cRotina)
lImpAntLP	:= Iif(lImpAntLP==Nil,.F.,lImpAntLP)
cConta		:= Left(AllTrim(cConta) + Space(Len(CT3->CT3_CONTA)), Len(CT3->CT3_CONTA))
cCusto		:= Left(AllTrim(cCusto) + Space(Len(CT3->CT3_CUSTO)), Len(CT3->CT3_CUSTO))

// Saldo composto pela Conta + C.Custo
If !Empty(cConta)
	dbSelectArea("CT3")
	dbSetOrder(2)
	MsSeek(xFilial()+cConta+cCusto+cMoeda+cTpSald+DTOS(dData),.T.)

/*CT3->CT3_FILIAL==xFilial("CT3") .And. CT3->CT3_CUSTO == cCusto .And.;
						CT3->CT3_CONTA == cConta .And. CT3->CT3_MOEDA == cMoeda .And.;
						CT3->CT3_TPSALD == cTpSald .and. CT3->CT3_DATA <= dData*/
	If ! Eval(bCondicao)
/*	If ! (CT3->CT3_FILIAL==xFilial("CT3") .And. CT3->CT3_CUSTO == cCusto .And.;
						CT3->CT3_CONTA == cConta .And. CT3->CT3_MOEDA == cMoeda .And.;
						CT3->CT3_TPSALD == cTpSald .and. CT3->CT3_DATA <= dData)	*/
		DbSkip(-1)
		lNaoAchei := .T.
	Else	//Verificar se existe algum registro de zeramento na mesma data 
		dbSkip()
		If !Eval(bCondicao) //Se nao existir registro na mesma data, volto para o registro anterior. 
/*		If ! (CT3->CT3_FILIAL==xFilial("CT3") .And. CT3->CT3_CUSTO == cCusto .And.;
						CT3->CT3_CONTA == cConta .And. CT3->CT3_MOEDA == cMoeda .And.;
						CT3->CT3_TPSALD == cTpSald .and. CT3->CT3_DATA <= dData) //Se nao existir registro na mesma data, volto para o registro anterior. 		*/
			dbSkip(-1)
		EndIf		
	Endif
	If Eval(bCondicao)
/*	If (CT3->CT3_FILIAL==xFilial("CT3") .And. CT3->CT3_CUSTO == cCusto .And.;
						CT3->CT3_CONTA == cConta .And. CT3->CT3_MOEDA == cMoeda .And.;
						CT3->CT3_TPSALD == cTpSald .and. CT3->CT3_DATA <= dData)	*/
		
		// Movimentacoes na data
		If CT3->CT3_DATA == dData
			nDebito	:= CT3->CT3_DEBITO
			nCredito	:= CT3->CT3_CREDITO
		Endif	
		nAtuDeb	:= CT3->CT3_ATUDEB
		nAtuCrd  := CT3->CT3_ATUCRD
		If lNaoAchei
			// Neste caso, como a data nao foi encontrada, considera-se como saldo anterior
			// o saldo atual do registro anterior! -> dbskip(-1)
			nAntDeb  := CT3->CT3_ATUDEB
			nAntCrd  := CT3->CT3_ATUCRD
		Else		
			nAntDeb  := CT3->CT3_ANTDEB
			nAntCrd  := CT3->CT3_ANTCRD
		Endif    
		
		If cRotina = "CTBA210"
			//Se foi chamado pela rotina de apuracao de lucros/perdas,existe um registro
			//na data solcitada e o saldo nao eh o do proprio zeramento, considero como 
			//saldo anterior, o saldo atual antes do zeramento. 
			If CT3->CT3_LP	<> 'Z'
				nAntDeb  := CT3->CT3_ATUDEB
				nAntCrd  := CT3->CT3_ATUCRD
			Endif
		Endif
		
		nSaldoAtu:= nAtuCrd - nAtuDeb
		nSaldoAnt:= nAntCrd - nAntDeb
	EndIf	
	//Se considera saldo anterior a apuracao de lucros/perdas
	If lImpAntLP
		dbSelectArea("CT3")
		dbSetOrder(8)
		If MsSeek(cChaveLP)				
			aSldLP	:= CtbSldLP("CT3",dDataLP,bCondLP,dData)		
			nAtuDeb	-= aSldLP[1]
			nAtuCrd	-= aSldLP[2]		
			nSaldoAtu := nAtuCrd - nAtuDeb
//			If lNaoAchei
				nAntDeb	-= aSldLP[1]
				nAntCrd -= aSldLP[2]    
				nSaldoAnt	:= nAntCrd - nAntDeb
//			EndIf
		EndIf
	EndIf	
Else
	nDebito		:= 0
	nCredito	:= 0
	nAtuDeb 	:= 0
	nAtuCrd		:= 0
	nAntDeb		:= 0
	nAntCrd		:= 0
	nSaldoAnt	:= 0
	nSaldoAtu	:= 0
EndIf	
//Ct3->(RestArea(aSaveArea))
RestArea(aSaveAnt)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno:                                             ³
//³ [1] Saldo Atual (com sinal)                          ³
//³ [2] Debito na Data                                   ³
//³ [3] Credito na Data                                  ³
//³ [4] Saldo Atual Devedor                              ³
//³ [5] Saldo Atual Credor                               ³
//³ [6] Saldo Anterior (com sinal)                       ³               sunday
//³ [7] Saldo Anterior Devedor                           ³
//³ [8] Saldo Anterior Credor                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//      [1]       [2]     [3]      [4]     [5]     [6]       [7]     [8]
Return {nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt,nAntDeb,nAntCrd}


#include "protheus.ch"

Static Function TableExcel()
Local aRet	:= {}
Local aFilter  := {}
Local cDirDocs  := MsDocPath() 
Local aStru2	:= {}
Local cPath		  := AllTrim(GetTempPath())
Local nX        := 0
Local nz
Local xValue    := ""
Local aRead		:= {}
Local cBuffer   := ""
Local oExcelApp := Nil
Local nHandle   := 0
Local cArquivo  := CriaTrab(,.F.)
Local aAuxRet   := {}
Local cTitle    := ""



If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")
	Return
EndIf

If ParamBox( {	{1,"Tabela ","   ","@!","ExistCpo('SX2',MV_PAR01,1)","SX21","",25,.T.} },"Edição de Tabelas via Ms-Excel",@aRet)  
	SX2->(dbSetOrder(1))
	SX2->(dbSeek(aRet[1]))
	If ParamBox( {	{7,"Filtro Tarefas",aRet[1],""},;
						{1,"Ordem",1,"@E 9","Positivo(mv_par02)","","",15,.T.}  },"Selecione o Filtro",@aFilter)
		dbSelectArea(aRet[1])
		dbSetOrder(aFilter[2])
		If !Empty(aFilter[1])
			dbSetFilter({||&(aFilter[1])},aFilter[1])
		EndIf

		aStru2		:= dbStruct()

		// gera o arquivo em formato .CSV
		cArquivo += "I.CSV"
	
		nHandle := FCreate(cDirDocs + "\" +cArquivo)

		If nHandle == -1
			MsgStop("A planilha não pode ser exportada.")
			Return
		EndIf
	
		For nx := 1 To Len(aStru2)
			xValue := FieldName(FieldPos(aStru2[nx][1]))

			cBuffer += XlsFormat(xValue) + ";"
		Next

		cBuffer += XlsFormat("Delete ?")+ ";"
		cBuffer += XlsFormat("ID_RecNo")

		FWrite(nHandle, cBuffer)
		FWrite(nHandle, CRLF)

		dbGotop()
		ProcRegua(LastRec())		
		While !Eof()
			IncProc()
			cBuffer := ""
			
			For nx := 1 To Len(aStru2)
				xValue := FieldGet(FieldPos(aStru2[nx][1]))
	
				cBuffer += XlsFormat(xValue) + ";"
			Next

			cBuffer += "N" + ";"
			cBuffer += XlsFormat(RecNo()) 
			
			FWrite(nHandle, cBuffer)
			FWrite(nHandle, CRLF)
		 	
			dbSkip()
		End
	
		FClose(nHandle)
  
		// copia o arquivo do servidor para o remote
		CpyS2T(cDirDocs + "\" +cArquivo, cPath, .T.)
		FErase(cDirDocs + "\" +cArquivo)

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cPath + cArquivo)
		oExcelApp:SetVisible(.T.)

		dbSelectArea(aRet[1])
		dbSetOrder(aFilter[2])
		dbClearFilter()

		While Aviso("Assistente de Importação Microsoft Excel","Para realizar a importação da tabela para o sistema utilize a opção Salvar no Microsoft Excel e realize a importação.",{"Importar","Sair"},2) == 1
			If (nHandle := FT_FUse(cPath + cArquivo) )== -1
				Help(" ",1,"NOFILEIMPOR")
			EndIf
			FT_FGOTOP()  
			FT_FSKIP()
			cSep := ";"
			While !FT_FEOF()
				PmsIncProc(.T.)
				cLinha := FT_FREADLN()
				AADD(aRead,{})
				nCampo := 1
				While (At(cSep,cLinha) > 0)
					aAdd(aRead[Len(aRead)],StrTran(SubStr(cLinha,1,At(cSep,cLinha)-1),'"',''))
					nCampo ++                                    
					
					cLinha := StrTran(Substr(cLinha,At(cSep,cLinha)+1,Len(cLinha)-At(cSep,cLinha)),'"','')
				End 
				
				If Len(cLinha) > 0
					aAdd(aRead[Len(aRead)],StrTran(Substr(cLinha,1,Len(cLinha)),'"',''))
				EndIf	
	

				FT_FSKIP()
			End
			FT_FUSE()
			dbSelectArea(aRet[1])
			ProcRegua(len(aRead))
			For nz := 1 To Len(aRead)
				IncProc("Atualizando tabela.Aguarde...")
				If UPPER(AllTrim(aRead[nz,Len(aStru2)+1]))=="S"
					dbGoto(Val(aRead[nz,Len(aStru2)+2]))
					RecLock(aRet[1],.F.)
					dbDelete()
					MsUnlock()
				Else
					If Len(aRead[nz])<Len(aStru2)+2 .Or. Empty(aRead[nz,Len(aStru2)+2])
						RecLock(aRet[1],.T.)
						For nx := 1 To Len(aStru2)
							xValue := XlsImport(aRead[nz,nx],aStru2[nx,2])
							
							FieldPut(nx,xValue)

						Next nx
						MsUnlock()
					Else
						dbGoto(Val(aRead[nz,Len(aStru2)+2]))
						RecLock(aRet[1],.F.)
						For nx := 1 To Len(aStru2)
							xValue := XlsImport(aRead[nz,nx],aStru2[nx,2])
							
							FieldPut(nx,xValue)
						Next nx
						MsUnlock()
					EndIf
				EndIf
			Next
		End
	EndIf
EndIf

Return

static Function XlsImport(xValue,cType)
	Do Case
		Case cType == "C"
			If Empty(xValue)
				xValue := ""
			Else
				xValue := Substr(xValue,2)
			EndIf
		Case cType == "N"
			If Empty(xValue)
				xValue := 0
			Else
				xValue := Val(xValue)
			EndIf
		Case cType == "D"
			If Empty(xValue)
				xValue := DTOC("  /  /  ")
			Else
				xValue := CTOD(xValue)
			EndIf
		Case cType == "U"
			xValue := ""
	EndCase
Return xValue

static Function XlsFormat(xValue)
	Do Case
		Case ValType(xValue) == "C" 
			xValue := "&"+StrTran(xValue, Chr(34), Chr(34) + Chr(34))
			xValue := Chr(34) + AllTrim(xValue) + Chr(34)
		Case ValType(xValue) == "N"
			xValue := Strtran(AllTrim(Str(xValue)),".",",")
		Case ValType(xValue) == "D"
			xValue := DToC(xValue)
		Case ValType(xValue) == "U"
			xValue := ""
	EndCase
Return xValue