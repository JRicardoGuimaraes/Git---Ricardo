#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  RetCliGrp    � Autor � Marcelo Pimentel � Data �  26/01/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorno de Cliente em determinado grupo                    ���
���          � 															  ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GFI130QRY()
Local aArea 	:= GetArea()
local cQueryTmp := ""
Private cGrupo 	:= mv_par40
Private cRet 	

If !Empty(mv_par40)
	cQueryTmp  := " AND EXISTS (SELECT A1_COD "
	cQueryTmp += " FROM " + RetSqlName("SA1") + " SA1 "
	cQueryTmp += " WHERE SA1.D_E_L_E_T_ <> '*' AND  "
	cQueryTmp += " A1_COD = E1_CLIENTE AND "
	cQueryTmp += " A1_LOJA = E1_LOJA AND  "
	cQueryTmp += " A1_GRUPO IN ( " + cGrupo + ")) "
EndIf
cRet :=    cQueryTmp

RestArea(aArea)
Return(cRet)
