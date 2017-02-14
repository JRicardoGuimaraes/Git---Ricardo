#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  FA060QRY     � Autor � Marcos Furtado   � Data �  20/04/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Seleciona somente clientes na gera��o de borderos que      ���
���          �com parametriza��o de imprime boleto igual a "sim"          ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
