/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  F050LRAT  �Autor  �    Marcos Furtado   � Data �  24/08/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada executado na grava��o (Inclus�o) do titulo���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F050LRAT()
lOCAL aArea := GetArea()
Local lRet  := .T.

If (Empty(GdFieldGet("CTJ_DEBITO")) .And. Empty(GdFieldGet("CTJ_CREDIT"))) .Or. ;
   (Empty(GdFieldGet("CTJ_CCD")) .And. Empty(GdFieldGet("CTJ_CCC"))) .Or. ;
   Empty(GdFieldGet("CTJ_HIST")) 
	lRet  := .F.   
	MsgInfo("Todas as Informa��es devem ser preenchidas!","Rateio CC - CP")
EndIF                                                                      
MsgInfo("Entrei","Rateio CC - CP")

RestArea(aArea)

return(lRet)
                        
