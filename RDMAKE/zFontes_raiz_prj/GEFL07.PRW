#include "rwmake.ch"      

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    : GEFL07  � Autor : Saulo Muniz             � Data :23/06/05 ���
�������������������������������������������������������������������������Ĵ��
���Descricao : Programa para n�o Lan�ar com c.custo bloquados             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GEFL07()    

vAlias := Alias()
xBloq  := " "
xOk    := .T.

DbSelectArea("CTT")
DbSetOrder(1)
DbSeek(xFilial("CTT")+M->E2_CCONT)
xBloq := CTT->CTT_BLOQ

 If Empty(xBloq) .Or. xBloq == "1" // C.Custo Bloqueado
    xOk := .F.  
 Endif 

  ApMsgAlert("Centro de Custo Bloqueado ! ",'Aten��o !!!')  
	
DbSelectArea(vAlias)

Return(xOk) 