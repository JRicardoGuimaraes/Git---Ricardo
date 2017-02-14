#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  FA060QRY     บ Autor ณ Marcos Furtado   บ Data ณ  20/04/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Seleciona somente clientes na gera็ใo de borderos que      บฑฑ
ฑฑบ          ณcom parametriza็ใo de imprime boleto igual a "sim"          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FA060QRY
Local aArea 	:= GetArea()
local cQueryTmp := ""
Private cGrupo 	:= Space(20)
Private cRet 	


cQueryTmp  := " EXISTS (SELECT A1_COD "
cQueryTmp += " FROM " + RetSqlName("SA1") + " SA1 "
cQueryTmp += " WHERE SA1.D_E_L_E_T_ <> '*' AND  "
cQueryTmp += " A1_COD = E1_CLIENTE AND "
cQueryTmp += " A1_LOJA = E1_LOJA AND  "
cQueryTmp += " A1_BOLETO = 'S' )"

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
