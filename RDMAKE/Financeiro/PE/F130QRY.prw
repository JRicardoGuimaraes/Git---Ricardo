#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RetCliGrp    บ Autor ณ Marcos Furtado   บ Data ณ  26/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retorno de Cliente em determinado grupo                    บฑฑ
ฑฑบ          ณ 															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function F130QRY
Local aArea 	:= GetArea()
local cQueryTmp := ""
Private cGrupo 	:= Space(20)
Private cRet 	

                     
/*If MsgYesNo("Deseja informar parโmetros Adicionais?") .And. Empty(cRet)
	alert("Executei Perg")
     
	@ 000,000 To 120,360 Dialog oDlg Title "Parโmetro Adicional - FINR130"
//	@ 010,003 To 042,350 Title OemToAnsi("Pesquisa")	
	@ 010,003 To  30,180 
	@ 015,010 Say "Grupo de Clientes:"
	@ 015,070 Say ":"
	@ 015,080 Get  cGrupo  Size 35,10 
	@ 040,110 BmpButton Type 01 Action (fConfirma())
	@ 040,150 BmpButton Type 02 Action (oDlg:End())
	
	Activate Dialog oDlg Centered
     
EndIf
RestArea(aArea)
Return(cRet)

Static Function fConfirma()
Local aArea 	:= GetArea()

oDlg:End()	*/

/*cQueryTmp  = "SELECT A1_COD "
cQueryTmp += " FROM " + RetSqlName("SA1") + " SA1 "
cQueryTmp += " WHERE SA1.D_E_L_E_T_ <> '*' AND  "
//cQueryTmp += " A1_GRUPO IN ( " + cGrupo + ") "
cQueryTmp += " A1_GRUPO <> '9' "

TcQuery cQueryTmp ALIAS "TRB" New     

dbSelectArea("TRB")  
DbGoTop()

While !Eof()
	cRet := cRet +"'"+ TRB->A1_COD + "', "
    DbSelectArea("TRB")
    DbSkip()
End
                                          
cRet := " AND E1_CLIENTE EIN ("+ SubStr(cRet,1,Len(cRet)-2) + ") "
Alert(cRet)		                       
Alert(len(cRet))*/

If ALLTRIM(FUNNAME()) == "GFINR13Y"
	cQueryTmp  := " AND EXISTS (SELECT A1_COD "
	cQueryTmp += " FROM " + RetSqlName("SA1") + " SA1 "
	cQueryTmp += " WHERE SA1.D_E_L_E_T_ <> '*' AND  "
	cQueryTmp += " A1_COD = E1_CLIENTE AND "
	cQueryTmp += " A1_LOJA = E1_LOJA "
	//cQueryTmp += " A1_GRUPO IN ( " + cGrupo + ") "
	//cQueryTmp += " A1_GRUPO IN (1,2,3,4) ) "        

	cQueryTmp += " AND A1_GRUPO IN (1,2,3,4,5,6,7,8,9) ) "
Else
	// cQueryTmp += " A1_GRUPO IN ( " + cGrupo + ") "
	
	If Empty(cQueryTmp)
		cQueryTmp := ""
	EndIf	
EndIf	

/*TcQuery cQueryTmp ALIAS "TRB" New     

dbSelectArea("TRB")  
DbGoTop()

While !Eof()
	cRet := cRet +"'"+ TRB->A1_COD + "', "
    DbSelectArea("TRB")
    DbSkip()
End*/
     
cRet :=    cQueryTmp

/*cRet := " AND E1_CLIENTE IN ("+ SubStr(cRet,1,Len(cRet)-2) + ") "*/


/*DbSelectArea("TRB")     
DbCloseArea()  */                 
RestArea(aArea)
Return(cRet)
