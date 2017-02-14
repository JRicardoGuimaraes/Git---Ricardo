#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

User Function GEFL05()        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("VALIAS,CCONTA,CITEM,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    : GEFL02  � Autor : Ronaldo Pena            � Data :17/09/99 ���
�������������������������������������������������������������������������Ĵ��
���Descricao : Posicionamento na conta para retorno do item               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

vAlias := Alias()

If     ParamIxb == 1
       DbSelectArea("SED")
       DbSetOrder(1)
       DbSeek(xFilial("SED")+SE1->E1_NATUREZ)
       cConta := SED->ED_CONTA
ElseIf ParamIxb == 2
       cConta := "812201"
ElseIf ParamIxb == 3
       cConta := "812202"
ElseIf ParamIxb == 4
       cConta := SED->ED_CONTA
ElseIf ParamIxb == 5
       cConta := "714199"
Endif


DbSelectArea("SI1")
DbSetOrder(1)
DbSeek(xFilial("SI1")+cConta)
cItem := SI1->I1_ITEM
DbSelectArea(vAlias)
// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> __Return(cItem)
Return(cItem)        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00
