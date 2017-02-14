#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 23/03/01

User Function Gefl98()        // incluido pelo assistente de conversao do AP5 IDE em 23/03/01

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("VALIAS,CCONTA,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    : GEFL04  � Autor : Flavio Souza            � Data :26/11/99 ���
�������������������������������������������������������������������������Ĵ��
���Descricao : Posicionamento da natureza para Lancamento Padrao 510      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

vAlias := Alias()
DbSelectArea("SI3")
DbSetOrder(1)
DbSeek(xFilial("SI3")+SE1->E1_CCONT)
cConta := SI3->I3_CRED
DbSelectArea(vAlias)
// Substituido pelo assistente de conversao do AP5 IDE em 23/03/01 ==> __Return(cConta)
Return(cConta)        // incluido pelo assistente de conversao do AP5 IDE em 23/03/01
