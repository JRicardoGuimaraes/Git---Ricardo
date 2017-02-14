#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  RetCliGrp    � Autor � Marcos Furtado   � Data �  26/07/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorno de Cliente em determinado grupo                    ���
���          � 															  ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RetCliGrp(cGrupo)
Local aArea := GetArea()
Local cRet := ""
                  
cQuery  = "SELECT A1_COD "
cQuery += " FROM " + RetSqlName("SA1") + " SA1 "
cQuery += " WHERE SA1.D_E_L_E_T_ <> '*' AND  "
cQuery += " A1_GRUPO IN ( " + cGrupo + ") "

TCQuery cQuery ALIAS "TRB" New     

dbSelectArea("TRB")  
DbGoTop()

While !Eof()
	cRet := cRet +"'"+ TRB->A1_COD + "', "
    DbSelectArea("TRB")
    DbSkip()
End
                                          
cRet := SubStr(cRet,1,Len(cRet)-2)
                       
DbSelectArea("TRB")     
DbCloseArea()
RestArea(aArea)
Return(cRet)

