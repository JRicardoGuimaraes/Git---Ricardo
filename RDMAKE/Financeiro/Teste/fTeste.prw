#INCLUDE "rwmake.ch"
#INCLUDE "MSOLE.CH"
#INCLUDE "TOPCONN.CH"

/****************************************************************************
* Programa : MSGI002    * Autor  :                   * Data :               *
* Descricao: Integração Excel - Fluxo de Caixa por Naturezas                *
****************************************************************************/

User Function MSGI002

   	Private oDlg
	Private cPerg     := "FLUXO_"
	Private cString   := "SED"   

	Private d1aSemIni := {"//"}
	Private d1aSemFin := {"//"}
	Private d2aSemIni := {"//"}
	Private d2aSemFin := {"//"}
	Private d3aSemIni := {"//"}
	Private d3aSemFin := {"//"}
	Private d4aSemIni := {"//"}
	Private d4aSemFin := {"//"}
	
	ValidPerg()
	
	dbSelectArea("SED")
	dbSetOrder(1)

	@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Integracao Excel")
	@ 02,10 TO 080,190
	@ 10,018 Say " Este programa ira gerar um documento do Excel, composto de uma"
	@ 18,018 Say " planilha de Fluxo de Caixa por Naturezas                      "
	
//	@ 70,068 BMPBUTTON TYPE 04 ACTION PopulaSED()
	@ 70,098 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
	@ 70,128 BMPBUTTON TYPE 01 ACTION Executa()
	@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oDlg)

	Pergunte(cPerg,.F.)	
	
	Activate Dialog oDlg Centered


Return

/****************************************************************************
* Funcao   : ValidPerg  * Autor  :     * Data :                             *
* Descricao: Validacao do SX1 - Perguntas                                   *
****************************************************************************/
Static Function ValidPerg()
	Local aArea := GetArea()
	Local aRegs := {}
	Local i,j
	dbSelectArea("SX1")
	dbSetOrder(1)

	cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))   
	
	aAdd(aRegs,{cPerg,"01","1o.Seman do Mês Começa em ? ","","","MV_CH1","D",008,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//	aAdd(aRegs,{cPerg,"02","Natureza ate:               ","","","MV_CH2","C",010,0,1,"G","","MV_PAR02",""           ,"","","","",""            ,"","","","",""              ,"","","","",""             ,"","","","","","","","","SED",""})
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	RestArea(aArea)
Return

/****************************************************************************
* Funcao   : Integra    * Autor  : Carlos Aquino     * Data :  08/07/2005   *
* Descricao:                                                                *
****************************************************************************/
Static Function Executa()
Local aArea := GetArea()

// Monto os períodos do Mes por semana
// U_IntExData() 
U_fPEGADESPESAS()

ApExcel()
//U_fAbrirPlan("D:\TEMP\TESTE.XLS")
	
RestArea(aArea)
Return

/****************************************************************************
* Funcao   : IntExData  * Autor  :      * Data :                            *
* Descricao: Retorna Períodos das Semanas do Mês usados para filtro         *
****************************************************************************/
*----------------------------*
User Function IntExData()
*----------------------------*
d1aSemIni := MV_PAR01
d1aSemFin := MV_PAR01  + 6
d2aSemIni := d1aSemFin + 1
d2aSemFin := d2aSemIni + 6
d3aSemIni := d2aSemFin + 1
d3aSemFin := d3aSemIni + 6
d4aSemIni := d3aSemFin + 1
d4aSemFin := d4aSemIni + 6

Return()

*---------------------------*
User Function fPegaReceitas()
*---------------------------*
Local _aArea := GetArea()
Local _aRec  := Array(2,4)


//Monto Primeira linha do Array
AADD( _aRec, fLinhaRec({"naturezas"} ))

//Monto Segunda linha do Array
AADD( _aRec, fLinhaRec({"naturezas"} ))

RestArea(_aArea)
Return(_aRec)

*---------------------------*
User Function fPegaDespesas()
*---------------------------*
Local _aArea := GetArea()
Local _aLinha:= {}

Private _aDesp := Array(2,4)

//Monto Primeira linha do Array
_aLinha := U_fLinhaDesp({"INSS"})
_aDesp[1,1] := _aLinha[1,1] 
_aDesp[1,2] := _aLinha[1,2] 
_aDesp[1,3] := _aLinha[1,3] 
_aDesp[1,4] := _aLinha[1,4]

//Monto Segunda linha do Array
_aLinha := U_fLinhaDesp({"COFINS","CSLL"})
_aDesp[2,1] := _aLinha[1,1] 
_aDesp[2,2] := _aLinha[1,2] 
_aDesp[2,3] := _aLinha[1,3] 
_aDesp[2,4] := _aLinha[1,4]

RestArea(_aArea)
Return(_aDesp)
//Return(_aDesp)

*-------------------------------*
User Function fAbrirPlan(_cPlan)   
*-------------------------------*

If !ApOleClient("MsExcel")
   MsgStop("MsExcel nao instalado.")
   Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(_cPlan)
oExcelApp:SetVisible(.T.)

Return

*------------------------------------*
Static Function fLinhaRec(_cNat)
*------------------------------------*
Local _aArea := GetArea()
Local _aRet  := Array(1,4)
Local _cQry  := ""

_cQry := "SELECT "


RestArea(_aArea)
Return

*------------------------------------*
USER Function fLinhaDesp(_aNat)
*------------------------------------*
Local _aArea := GetArea()
Local _aRet  := Array(1,4)
Local _cQry  := ""
Local _cNat  := ""

For _x := 1 To Len(_aNat)
	_cNat += _aNat[_x] + ","
Next _x

If AT(',',_cNat) > 0
	_cNat := SubStr(_cNat,1,Len(_cNat)-1)
EndIf	

Pergunte("FLUXO_",.F.)

// Monto perido do mês por semana
d1aSemIni := ctod("02/07/07") // MV_PAR01
d1aSemFin := d1aSemIni + 6
d2aSemIni := d1aSemFin + 1
d2aSemFin := d2aSemIni + 6
d3aSemIni := d2aSemFin + 1
d3aSemFin := d3aSemIni + 6
d4aSemIni := d3aSemFin + 1
d4aSemFin := d4aSemIni + 6

*-----------------------------------*
* Pego Valor da primeira Semana     *
*-----------------------------------*
_cQry := " SELECT SUM(E2_VLCRUZ) AS VALOR FROM " + RetSqlName("SE2") + " SE2 "
_cQry += " 	WHERE SE2.D_E_L_E_T_ = ' ' "
_cQry += "    AND E2_FILIAL = '" + xFilial("SE2") + "' "
_cQry += "    AND E2_NATUREZ IN ('" + _cNat + "') "
_cQry += "    AND E2_VENCREA >= '" + DTOS(d1aSemIni) + "' "
_cQry += "    AND E2_VENCREA <= '" + DTOS(d1aSemFin) + "' "

TCQUERY _cQry ALIAS "_TST" NEW
dbSelectArea("_TST") ; dbGoTop()

_aRet[1,1] := _TST->VALOR 

_TST->(dbCloseArea())

*-----------------------------------*
* Pego Valor da segunda Semana      *
*-----------------------------------*
_cQry := " SELECT SUM(E2_VLCRUZ) AS VALOR FROM " + RetSqlName("SE2") + " SE2 "
_cQry += " 	WHERE SE2.D_E_L_E_T_ = ' ' "
_cQry += "    AND E2_FILIAL = '" + xFilial("SE2") + "' "
_cQry += "    AND E2_NATUREZ IN ('" + _cNat + "') "
_cQry += "    AND E2_VENCREA >= '" + DTOS(d2aSemIni) + "' "
_cQry += "    AND E2_VENCREA <= '" + DTOS(d2aSemFin) + "' "

TCQUERY _cQry ALIAS "_TST" NEW
dbSelectArea("_TST") ; dbGoTop()

_aRet[1,2] := _TST->VALOR

_TST->(dbCloseArea())

*-----------------------------------*
* Pego Valor da terceira Semana     *
*-----------------------------------*
_cQry := " SELECT SUM(E2_VLCRUZ) AS VALOR FROM " + RetSqlName("SE2") + " SE2 "
_cQry += " 	WHERE SE2.D_E_L_E_T_ = ' ' "
_cQry += "    AND E2_FILIAL = '" + xFilial("SE2") + "' "
_cQry += "    AND E2_NATUREZ IN ('" + _cNat + "') "
_cQry += "    AND E2_VENCREA >= '" + DTOS(d3aSemIni) + "' "
_cQry += "    AND E2_VENCREA <= '" + DTOS(d3aSemFin) + "' "

TCQUERY _cQry ALIAS "_TST" NEW
dbSelectArea("_TST") ; dbGoTop()

_aRet[1,3] := _TST->VALOR

_TST->(dbCloseArea())

*-----------------------------------*
* Pego Valor da quarta Semana       *
*-----------------------------------*
_cQry := " SELECT SUM(E2_VLCRUZ) AS VALOR FROM " + RetSqlName("SE2") + " SE2 "
_cQry += " 	WHERE SE2.D_E_L_E_T_ = ' ' "
_cQry += "    AND E2_FILIAL = '" + xFilial("SE2") + "' "
_cQry += "    AND E2_NATUREZ IN ('" + _cNat + "') "
_cQry += "    AND E2_VENCREA >= '" + DTOS(d4aSemIni) + "' "
_cQry += "    AND E2_VENCREA <= '" + DTOS(d4aSemFin) + "' "

TCQUERY _cQry ALIAS "_TST" NEW
dbSelectArea("_TST") ; dbGoTop()

_aRet[1,4] := _TST->VALOR

_TST->(dbCloseArea())

RestArea(_aArea)
/*
_aRet[1,1] := 123
_aRet[1,2] := 456
_aRet[1,3] := 789
_aRet[1,4] := 111
*/

Return( _aRet )

*---------------------------*
User Function fTESTE
*---------------------------*
Local _aRet := Array(2,4)

Pergunte("FLUXO_",.T.)

dData := ctod("02/07/07")

// Monto perido do mês por semana
d1aSemIni := dData
d1aSemFin := dData  + 6
d2aSemIni := d1aSemFin + 1
d2aSemFin := d2aSemIni + 6
d3aSemIni := d2aSemFin + 1
d3aSemFin := d3aSemIni + 6
d4aSemIni := d3aSemFin + 1
d4aSemFin := d4aSemIni + 6


*-----------------------------------*
* Pego Valor da quarta Semana       *
*-----------------------------------*
_cQry := " SELECT SUM(E2_VLCRUZ) AS VALOR FROM " + RetSqlName("SE2") + " SE2 "
_cQry += " 	WHERE SE2.D_E_L_E_T_ = ' ' "
_cQry += "    AND E2_FILIAL = '" + xFilial("SE2") + "' "
_cQry += "    AND E2_NATUREZ IN ('PIS') "
_cQry += "    AND E2_VENCREA >= '" + DTOS(d1aSemIni) + "' "
_cQry += "    AND E2_VENCREA <= '" + DTOS(d1aSemFin) + "' "

TCQUERY _cQry ALIAS "_TST1" NEW
dbSelectArea("_TST1") ; dbGoTop()

_aRet[1,1] := _TST1->VALOR

_TST1->(dbCloseArea())

_cQry := " SELECT SUM(E2_VLCRUZ) AS VALOR FROM " + RetSqlName("SE2") + " SE2 "
_cQry += " 	WHERE SE2.D_E_L_E_T_ = ' ' "
_cQry += "    AND E2_FILIAL = '" + xFilial("SE2") + "' "
_cQry += "    AND E2_NATUREZ IN ('PIS') "
_cQry += "    AND E2_VENCREA >= '" + DTOS(d2aSemIni) + "' "
_cQry += "    AND E2_VENCREA <= '" + DTOS(d2aSemFin) + "' "

TCQUERY _cQry ALIAS "_TST1" NEW
dbSelectArea("_TST1") ; dbGoTop()

_aRet[1,2] := _TST1->VALOR

_TST1->(dbCloseArea())

_cQry := " SELECT SUM(E2_VLCRUZ) AS VALOR FROM " + RetSqlName("SE2") + " SE2 "
_cQry += " 	WHERE SE2.D_E_L_E_T_ = ' ' "
_cQry += "    AND E2_FILIAL = '" + xFilial("SE2") + "' "
_cQry += "    AND E2_NATUREZ IN ('PIS') "
_cQry += "    AND E2_VENCREA >= '" + DTOS(d3aSemIni) + "' "
_cQry += "    AND E2_VENCREA <= '" + DTOS(d3aSemFin) + "' "

TCQUERY _cQry ALIAS "_TST1" NEW
dbSelectArea("_TST1") ; dbGoTop()

_aRet[1,3] := _TST1->VALOR

_TST1->(dbCloseArea())

_cQry := " SELECT SUM(E2_VLCRUZ) AS VALOR FROM " + RetSqlName("SE2") + " SE2 "
_cQry += " 	WHERE SE2.D_E_L_E_T_ = ' ' "
_cQry += "    AND E2_FILIAL = '" + xFilial("SE2") + "' "
_cQry += "    AND E2_NATUREZ IN ('PIS') "
_cQry += "    AND E2_VENCREA >= '" + DTOS(d4aSemIni) + "' "
_cQry += "    AND E2_VENCREA <= '" + DTOS(d4aSemFin) + "' "

TCQUERY _cQry ALIAS "_TST1" NEW
dbSelectArea("_TST1") ; dbGoTop()

_aRet[1,4] := _TST1->VALOR

_TST1->(dbCloseArea())

*------------------------------------------------------------*
_cQry := " SELECT SUM(E2_VLCRUZ) AS VALOR FROM " + RetSqlName("SE2") + " SE2 "
_cQry += " 	WHERE SE2.D_E_L_E_T_ = ' ' "
_cQry += "    AND E2_FILIAL = '" + xFilial("SE2") + "' "
_cQry += "    AND E2_NATUREZ IN ('INSS') "
_cQry += "    AND E2_VENCREA >= '" + DTOS(d1aSemIni) + "' "
_cQry += "    AND E2_VENCREA <= '" + DTOS(d1aSemFin) + "' "

TCQUERY _cQry ALIAS "_TST1" NEW
dbSelectArea("_TST1") ; dbGoTop()

_aRet[2,1] := _TST1->VALOR

_TST1->(dbCloseArea())

_cQry := " SELECT SUM(E2_VLCRUZ) AS VALOR FROM " + RetSqlName("SE2") + " SE2 "
_cQry += " 	WHERE SE2.D_E_L_E_T_ = ' ' "
_cQry += "    AND E2_FILIAL = '" + xFilial("SE2") + "' "
_cQry += "    AND E2_NATUREZ IN ('INSS') "
_cQry += "    AND E2_VENCREA >= '" + DTOS(d2aSemIni) + "' "
_cQry += "    AND E2_VENCREA <= '" + DTOS(d2aSemFin) + "' "

TCQUERY _cQry ALIAS "_TST1" NEW
dbSelectArea("_TST1") ; dbGoTop()

_aRet[2,2] := _TST1->VALOR

_TST1->(dbCloseArea())

_cQry := " SELECT SUM(E2_VLCRUZ) AS VALOR FROM " + RetSqlName("SE2") + " SE2 "
_cQry += " 	WHERE SE2.D_E_L_E_T_ = ' ' "
_cQry += "    AND E2_FILIAL = '" + xFilial("SE2") + "' "
_cQry += "    AND E2_NATUREZ IN ('INSS') "
_cQry += "    AND E2_VENCREA >= '" + DTOS(d3aSemIni) + "' "
_cQry += "    AND E2_VENCREA <= '" + DTOS(d3aSemFin) + "' "

TCQUERY _cQry ALIAS "_TST1" NEW
dbSelectArea("_TST1") ; dbGoTop()

_aRet[2,3] := _TST1->VALOR

_TST1->(dbCloseArea())

_cQry := " SELECT SUM(E2_VLCRUZ) AS VALOR FROM " + RetSqlName("SE2") + " SE2 "
_cQry += " 	WHERE SE2.D_E_L_E_T_ = ' ' "
_cQry += "    AND E2_FILIAL = '" + xFilial("SE2") + "' "
_cQry += "    AND E2_NATUREZ IN ('INSS') "
_cQry += "    AND E2_VENCREA >= '" + DTOS(d4aSemIni) + "' "
_cQry += "    AND E2_VENCREA <= '" + DTOS(d4aSemFin) + "' "

TCQUERY _cQry ALIAS "_TST1" NEW
dbSelectArea("_TST1") ; dbGoTop()

_aRet[2,4] := _TST1->VALOR

_TST1->(dbCloseArea())


Return _aRet
