#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA040B01  � Autor � MARCOS FURTADO     � Data �  01/08/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada executado na exlusao do   titulo a receber���
���          � com retorno .T. ou .F. . Utilizado para deletar o registro ���
���          � de prorroga��o de t�tulos da tabela SZ6                    ���
�������������������������������������������������������������������������͹��
���Uso       � FINANCEIRO                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FA040B01
Local aArea := GetArea()
Local lRet := .T.

CHKFILE("SZ6")

DbSelectArea("SZ6")
DbSetOrder(1)
If dbSeek(SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
	While !Eof() .And. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO == ;
		SZ6->Z6_FILIAL+SZ6->Z6_PREFIXO+SZ6->Z6_NUM+	SZ6->Z6_PARCELA+SZ6->Z6_TIPO
	
		RecLock("SZ6",.F.)
		DbDelete()
		Msunlock()
		DbSelectArea("SZ6")		
		DbSkip()
	End
EndIf

RestArea(aArea)
Return(lRet)
