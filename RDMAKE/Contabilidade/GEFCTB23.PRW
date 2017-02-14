#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "TopConn.ch"
/****************************************************************************
* Programa....: GEFCTB23()                                                  *
* Autor.......: Marcelo Aguiar Pimentel								        *
* Data........: 05/04/07                                                    *
* Descricao...: Atualiza a tabela SZO com dados UO + Metier                 *
*                                                                           *
*****************************************************************************
* Alterado por:                                                             *
* Data........:                                                             *
* Motivo......:                                                             *
*                                                                           *
****************************************************************************/

User Function GEFCTB23(xAuto)
Private xWorkFlow   := IIF(xAuto <> nil,.T.,.F.)
Private xProcesso   := " "
Private xRelease    := GetMv("MV_HISTVER")  // Versão do Centro de custo (2005 ou 2006) 
Private aEst		:= {}
Private cDbfSZO		:= ""
Private cInd1		:= ""
Private cContas		:= ""

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
	Private cPerg   := "GEF023"   
	If !Pergunte(cPerg,.T.)
		return
	EndIf

	If MV_PAR01 < CTOD("01/01/2006")  // PARA APENAS RODAR NO ANO DE 2005
		ApMsgAlert("Periodo Bloqueado - Selecione uma data apartir de 2006 ! ",'Atenção !!!')  
		Return
	Endif

//	HISTCLEAR(MV_PAR07)
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
   
	Private cPerg   := "GEF023"   
	Pergunte(cPerg,.F.)           

	If MV_PAR01 < CTOD("01/01/2006")  // PARA APENAS RODAR NO ANO DE 2005
		ApMsgAlert("Periodo Bloqueado - Selecione uma data apartir de 2006 ! ",'Atenção !!!')  
		Return
	Endif
	   
	MV_PAR03 := "                  "
	MV_PAR04 := "ZZZZZZZZZZZZZZZZZZ"
	MV_PAR06 := "016" // CONFIGURAÇÃO
	MV_PAR07 := 2     // 1= APENAS A U.O ; 2= TODOS

	ConOut("")
	ConOut("Processando : Aguarde ... ")
	ConOut("")
//	HISTCLEAR(MV_PAR07)
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
dbSelectArea("SX5")
dbSetOrder(1)
DbselectArea("SZ1")
DbSetOrder(1) 
dbSeek(xFilial("SZ1"))


While !Eof() .and. xFilial("SZ1") = SZ1->Z1_FILIAL
	DbselectArea("SZO")
	DbSetOrder(1) 
	If DbSeek(xFilial("SZO") + Alltrim(SZ1->Z1_COD))   
		If SZO->ZO_MES == MV_PAR01  // Mes ja Processado
			DbselectArea("SZ1")
			dbSkip() 
			Loop     
		Endif        
	Endif
	dbSelectArea("SX5")
	If !dbSeek(xFilial("SX5")+"Z4"+SZ1->Z1_COD)
		dbSelectArea("SZ1")
		dbSkip()
		Loop
	EndIf
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


STATIC FUNCTION HISTORIQUE(lEnd,oObj,MV_PAR05) // PROCESSAR \ 
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

// Calcula Mes Anterior
dMesAnt := Str(Month(MV_PAR01)-1)
dAnoAnt := Str(Year(MV_PAR01))
DtAnteIni := Ctod("01/01/05")
DtAnteFim := MV_PAR02 //Ctod("31/"+dMesAnt+"/"+dAnoAnt)

dbSelectArea("SZQ")
dbSetOrder(1)
DbselectArea("SZ1")
DbSetOrder(1) 
Dbseek(xFilial("SZ1")+xTbUO)

xUO := Alltrim(SZ1->Z1_FILTRO) // U.O (2DIG.)
xDescZ1 := SZ1->Z1_DESCR
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
		xUOFim := IIF(xRelease == "2005","28083","439001")      

		_cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTS_FORMUL, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
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
	Endif

	If SZ1->Z1_COD == "111" // MATRIZ - DCM       
		_cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTS_FORMUL, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
		_cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT, " + RetSqlName("CT3") + " CT3 "
		_cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND CT3.D_E_L_E_T_ <> '*' "
		_cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
		_cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
		_cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
		_cQry += " AND CT3.CT3_FILIAL =  '" + xFilial("CT3") + "' "	  	  	  
		_cQry += " AND CTT_CUSTO = CT3_CUSTO " 
		_cQry += " AND CTS_CT1INI = CT3_CONTA " 
		_cQry += " AND (CTT_CUSTO = '431001' "     //Diretoria Geral
		_cQry += "      OR CTT_CUSTO = '432001' "  //DFCP
		_cQry += "      OR CTT_CUSTO = '433001' "  //DRHCO	  
		_cQry += "      OR CTT_CUSTO = '435001' "  //Qualidade	  
		_cQry += "      OR CTT_CUSTO = '437001') " //Administrativo	  
		_cQry += "      OR CTT_CUSTO = '438001' "  //DIR LOG PSA 	  
		_cQry += "      OR CTT_CUSTO = '439001' "  //
		_cQry += " ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "
		
		TCQUERY _cQry ALIAS "TCTS" NEW
	  dbSelectArea("TCTS") 
	  dbGoTop()
	Endif
   
	If SZ1->Z1_COD == "008"      
		xUOIni := "431001"
		
		_cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTS_FORMUL, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
		_cQry += " FROM "  + RetSqlName("CTS") + " CTS,  "+ RetSqlName("CTT") + " CTT, " + RetSqlName("CT3") + " CT3 "
		_cQry += " WHERE CTS.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*' AND CT3.D_E_L_E_T_ <> '*' "
		_cQry += " AND  RTRIM(CTS.CTS_CODPLA) = '" + Alltrim(MV_PAR06) + "' "
		_cQry += " AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
		_cQry += " AND CTT.CTT_FILIAL =  '" + xFilial("CTT") + "' "	  	  
		_cQry += " AND CT3.CT3_FILIAL =  '" + xFilial("CT3") + "' "	  	  	  
		_cQry += " AND CTT_CUSTO = CT3_CUSTO " 
		_cQry += " AND CTS_CT1INI = CT3_CONTA " 
		_cQry += " AND (CTT_CUSTO = '431001' "
		_cQry += "      OR CTT_CUSTO = '438001' " 
		_cQry += "      OR CTT_CUSTO = '439001' " 		
		_cQry += "      OR CTT_CUSTO = '437001') "	  
		_cQry += "  ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "
			  
		TCQUERY _cQry ALIAS "TCTS" NEW
	  dbSelectArea("TCTS") 
	  dbGoTop()
	Endif

	// Por: Ricardo - Em: 11/02/2008
   	If SZ1->Z1_COD == "113" .OR. SZ1->Z1_COD == "114" .OR. SZ1->Z1_COD == "115" // ADUANA ( RDVM ) / ADUANA ( RML ) / ADUANA ( RMA )
      
      	xUOIni := Alltrim(SZ1->Z1_FILTRO)
      	xUOFim := Alltrim(SZ1->Z1_FILTRO) + "999999"

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
	  	_cQry += "  ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "

//	  MEMOWRIT("D:\TEMP\SQL113.TXT",_cQry)
	  
	 	TCQUERY _cQry ALIAS "TCTS" NEW
	  	dbSelectArea("TCTS") 
	  	dbGoTop()
   	EndIf
	   
	If  SZ1->Z1_COD <> "008" .And. SZ1->Z1_COD <> "106" .And. SZ1->Z1_COD <> "111" .AND. ;
		SZ1->Z1_COD <> "113" .AND. SZ1->Z1_COD <> "114" .AND. SZ1->Z1_COD <> "115" // ADUANA ( RDVM ) / ADUANA ( RML ) / ADUANA ( RMA )	
		
		_cQry := "SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTS_FORMUL, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
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
      
		_cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTS_FORMUL, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
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
/*
	Comentado por: Ricardo - Em: 09/04/08 - Devido alteração de CC da Aduana, Conform orientação da Silvana
	// RMA + Aduana
	DbselectArea("SZ1")           
	If SZ1->Z1_COD == "110"  // U.O (6,8)
		xUOIni := "22"
		xUOFim := "23"
		
		_cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTS_FORMUL, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
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
*/
	// Aduana Total ( Aduana - RDVM + Aduana - RML + Aduana - RMA + Aduana - ( 4 )
	DbselectArea("SZ1")           
	If SZ1->Z1_COD == "109"
	   xUOIni := Substr(SZ1->Z1_FILTRO,1,2)
	   xUOFim := ''
	   xCCIni := '3231'
	   xCCFim := '3233' + "999999"
	
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
	   _cQry += " AND CTT_CUSTO >= '" + xCCIni + "' "
	   _cQry += " AND CTT_CUSTO <= '" + xCCFim + "' "
	   _cQry += " ORDER BY  CTS_CODPLA, CTS_CONTAG, CTS_CT1INI, CTT_CUSTO "
		  
	   TCQUERY _cQry ALIAS "TCTS" NEW
	   dbSelectArea("TCTS") 
	   dbGoTop()
    Endif         

	DbselectArea("SZ1")                 
	If SZ1->Z1_COD <> "102" .and. SZ1->Z1_COD <> "109" .And. SZ1->Z1_COD <> "110"  // Demais Configurações


		_cQry := " SELECT DISTINCT CTS_CODPLA, CTS_CONTAG, CTS_FORMUL, CTT_CUSTO, CTS_CT1INI, CTS_CT1FIM, CTS_CTTINI, CTS_CTTFIM, CTS_DESCCG "
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
  
dbSelectArea("SZO")
aEst	:=	dbStruct("SZO")

cdbfSZO	:=	criatrab(aEst)
Use &cDbfSZO Alias cDbfSZO New
cInd1	:= CriaTrab("",.F.)
IndRegua("cDbfSZO",cInd1,"ZO_FILCC+ZO_COD+ZO_CONTA+ZO_UO+ZO_METIER+DTOS(ZO_MES)",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
dbSetIndex( cInd1 +OrdBagExt())

dbSelectArea("TCTS") ; dbGoTop()
While !EOF() // .And. Alltrim(CTS->CTS_CODPLA) ==  Alltrim(MV_PAR06) 
	xCodPla  := TCTS->CTS_CODPLA   // COD. PLANO GER.
	xContaG  := TCTS->CTS_CONTAG   // CONTA GERENCIAL
	_tmp:=""
	IF alltrim(xContaG) == "A01G"
		_tmp+="Conta: "+xContaG+char(13)
	EndIf
	xContaI  := TCTS->CTS_CT1INI   // CONTA INICIO
	xContaF  := TCTS->CTS_CT1FIM   // CONTA FIM
	xCcustoI := TCTS->CTS_CTTINI   // C.CUSTO INICIO
	xCcustoF := TCTS->CTS_CTTFIM   // C.CUSTO FIM
	xDescG   := Alltrim(TCTS->CTS_DESCCG)   // DESCRIÇÃO
   
	// Reprocessa apenas a conta gerencial informada
// Por: Ricardo - Em: 10/03/08	
	If !Empty(Alltrim(MV_PAR10)) .And. Alltrim(xContaG) <> Alltrim(MV_PAR10)
		Exit
	Endif

	If !xWorkFlow  // Manual
		oObj:IncRegua1("Arquivo : "+xDescG)   
		oObj:SetRegua2(Len(_xCC))	        //segunda regua
	Endif  

	//Busca a Filial no Centro de Custo e busca a correspondente no Microsiga pelo vetor aFilCC
	cFilCC		:= Substr(TCTS->CTT_CUSTO,4,3)
	cFilCCAux	:= Substr(TCTS->CTT_CUSTO,4,3)	
	cAtiv		:= subStr(TCTS->CTT_CUSTO,7,3)
	IF alltrim(xContaG) == "A01G"
		_tmp+="Atividade: "+cAtiv+char(13)
	EndIf

	// Por: Ricardo - Em: 10/04/08 -     
	If Left(TCTS->CTT_CUSTO,3) == '323' .AND. SubStr(TCTS->CTT_CUSTO,4,1) $ ("1|2|3")
		cFilCC := StrZero(Val(SubStr(cFilCC,2,2)),3)
	EndIf

	dbSelectArea("SZQ")
	If !dbSeek(xFilial("SZQ")+cFilCC)
		dbSelectArea("TCTS")
		dbSkip() 
		loop
	EndIf

	cMetier		:= ""
	dbSelectArea("SZL")
	cQry:="SELECT ZL_METIER "
	cQry+="  FROM "+RetSqlName("SZL")
	cQry+=" WHERE ZL_FILIAL   = '"+xFilial("SZL")+"'"
	cQry+="   AND ZL_ATIV     = '"+cAtiv+"'" 
	cQry+="   AND D_E_L_E_T_ <> '*'"
	TcQuery cQry Alias "TSZL" New
		cMetier:=TSZL->ZL_METIER
	dbCloseArea()
	IF alltrim(xContaG) == "A01G"
		_tmp+="Metier: "+cMetier+char(13)
	EndIf

/*
	DbSelectArea("SZO")
	DbSetOrder(1)      
	If dbSeek(xFilial("SZO")+cFilCC+xCodZ1+space(6)+xContaG+xDescZ1+cMetier+dtos(MV_PAR01))
//	If DbSeek(xFilial("SZO")+ xCodZ1 + Space(6) + xContaG + DTOS(MV_PAR01))                    
		If UPPER(SZO->ZO_OK) == "S"  // ja Processado
			DbselectArea("CTS")
			dbSkip() 
			Loop           
			//pos := 1
			//HLog()
		Else
			alert(1)
//			pos := 2
			//HLog()
//			HISTCLEAR() // Refaz Historique      
		Endif          
	Else  // Novo Processamento
		pos := 3  
		//HLog()
	Endif
*/      
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

 	nSldOper := nSld
//	IF alltrim(xContaG) == "A01G"
//		_tmp+="Saldo: "+alltrim(str(nSldOper))+char(13)
//		alert(_tmp)
//	EndIf

	If !xWorkFlow  // Manual	   
		oObj:IncRegua2("Calculando C.Custo : "+TCTS->CTT_CUSTO )	//incrementa segunda regua       	      
	Endif

	If !Empty(cMetier) .and. nSldOper <> 0 //.and. alltrim(xContaG) $ cContas
		dbSelectArea("cDbfSZO")
		//indice ZO_FILCC+ZO_COD+ZO_CONTA+ZO_UO+ZO_METIER+DTOS(ZO_MES)
		lInclui:=!dbSeek(cFilCC+xCodZ1+space(6)+xContaG+xDescZ1+cMetier+dtos(MV_PAR01))
//		lInclui:=.t.
		RecLock("cDbfSZO",lInclui)
			If lInclui
				cDbfSZO->ZO_FILIAL	:= xFilial("SZO")
				cDbfSZO->ZO_FILCC	:= cFilCC
				cDbfSZO->ZO_COD		:= xCodZ1
	 			cDbfSZO->ZO_CONTA	:= xContaG
				cDbfSZO->ZO_DESCR	:= xDescG
				cDbfSZO->ZO_UO		:= xDescZ1
				cDbfSZO->ZO_METIER	:= cMetier
				cDbfSZO->ZO_MES		:= MV_PAR01
				cDbfSZO->ZO_DATA	:= MsDate()
				cDbfSZO->ZO_HORA	:= Time()
				cDbfSZO->ZO_OK		:= "S"
			EndIf
			cDbfSZO->ZO_SALDO	+= nSldOper
//			cDbfSZO->ZO_SALDO	:= nSldOper
		MsUnLock()
	EndIf       
	dbSelectArea("TCTS")
	dbSkip() 
	nSldOper:=0
EndDo

dbSelectArea("SZO")
dbSetOrder(1)
dbSelectArea("cDbfSZO")
dbGoTop()

//Zerar Metier
/*
If !Eof()
	cQry:="UPDATE "+RETSQLNAME("SZO")
	cQry+="   SET D_E_L_E_T_ = '*'"
	cQry+=" WHERE ZO_FILIAL = '"+xFilial("SZO")+"'"
	cQry+="   AND ZO_DATA BETWEEN ='"+dtos(dDataBase)+"'
	cQry+="   AND ZO_OK     = 'N'"
	cQry+="   AND D_E_L_E_T_ <> '*'"
	TcSQLExec(cQry)
	TcSQLExec("COMMIT")
	dbSelectArea("cDbfSZO")
	dbGoTop()
EndIf
*/	

While !Eof()
	dbSelectArea("SZO")
    //ZO_FILIAL+ZO_FILCC+ZO_COD+ZO_CONTA+ZO_UO+ZO_METIER+DTOS(ZO_MES)                                                                                                 
	lInclui:=!dbSeek(xFilial("SZO")+cDbfSZO->ZO_FILCC+cDbfSZO->ZO_COD+cDbfSZO->ZO_CONTA+cDbfSZO->ZO_UO+cDbfSZO->ZO_METIER+dtos(cDbfSZO->ZO_MES))
//	lInclui:=.t.
	If SZO->ZO_OK == "N"
		lInclui:=.t.
		RecLock("SZO",.F.)
			dbDelete()
		MsUnLock()
	EndIf
	If lInclui
	RecLock("SZO",.t.)
//		If lInclui
			SZO->ZO_FILIAL	:=	cDbfSZO->ZO_FILIAL
			SZO->ZO_FILCC	:=	cDbfSZO->ZO_FILCC
			SZO->ZO_COD		:=	cDbfSZO->ZO_COD
			SZO->ZO_CONTA	:=	cDbfSZO->ZO_CONTA
			SZO->ZO_DESCR	:=	cDbfSZO->ZO_DESCR
			SZO->ZO_METIER	:=	cDbfSZO->ZO_METIER
			SZO->ZO_MES		:=	cDbfSZO->ZO_MES
			SZO->ZO_DATA	:=	cDbfSZO->ZO_DATA
			SZO->ZO_HORA	:=	cDbfSZO->ZO_HORA
			SZO->ZO_OK		:=	cDbfSZO->ZO_OK
			SZO->ZO_UO		:=	cDbfSZO->ZO_UO
//		EndIf
		SZO->ZO_SALDO	:=	cDbfSZO->ZO_SALDO
//		SZO->ZO_SALDO	:=	cDbfSZO->ZO_SALDO
	MsUnLock()
	EndIf
	dbSelectArea("cDbfSZO")
	dbSkip()
EndDo

dbSelectArea("cDbfSZO")
If FILE(cDbfSZO+".DBF")     //Elimina o arquivo de trabalho
    dbCloseArea()
    Ferase(cDbfSZO+".DBF")
    Ferase("cInd1"+OrdBagExt())
EndIf
                                     
dbSelectArea("TCTS")          
DbCloseArea()

dbCloseArea ("SZO")          
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

Static Function HISTCLEAR(pApUO)
//pApUO ==> MV_PAR07 // 1 Apenas UO 2 Todas
cQry:="UPDATE "+RETSQLNAME("SZO")
cQry+="   SET D_E_L_E_T_ = '*'"
cQry+=" WHERE ZO_FILIAL = '"+xFilial("SZO")+"'"
cQry+="   AND ZO_MES    ='"+dtos(MV_PAR01)+"'
cQry+="   AND ZO_OK     = 'N'"
If pApUO == 1
	dbSelectArea("SZ1")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ1")+MV_PAR05)
		cQry+="  AND ZO_UO = '"+ALLTRIM(SZ1->Z1_DESCR)+"'"
	EndIf
EndIf
cQry+="   AND D_E_L_E_T_ <> '*'"
TcSQLExec(cQry)
TcSQLExec("COMMIT")
  
/*
If UPPER(SZO->ZO_OK) == "N"
	DbSelectArea("SZO")
    RecLock("SZO",.F.)
    	SZO->(dbDelete())
    MsUnlock()         
Endif
*/
Return
