#include "rwmake.ch" 

User Function GEFL06() 

SetPrvt("VALIAS,CCONTA,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    : GEFL01  � Autor : Saulo Muniz            � Data :14/03/03 ���
�������������������������������������������������������������������������Ĵ��
���Descricao : Posicionamento da Conta do banco para Transferencias
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

vAlias := Alias()
DbSelectArea("SA6")
DbSetOrder(1)
DbSeek(xFilial("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA)
cConta := SA6->A6_CONTA
DbSelectArea(vAlias)
Return(cConta)        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00


