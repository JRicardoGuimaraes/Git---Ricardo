
#include "rwmake.ch"       

User Function GEFL08()     

Local xBanco,xAgencia,xConta

SetPrvt("VALIAS,CCONTA,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    : GEFL08  � Autor : Saulo Muniz            � Data :05/10/05  ���
�������������������������������������������������������������������������Ĵ��
���Descricao : Posicionamento Lancamento Padrao 530                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

vAlias := Alias()

/*
DbSelectArea("SE5")
DbSetOrder(1)
DbGotop()
DbSeek(xFilial("SE5") + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA,.T.)
   //MsgInfo(xBanco + xAgencia + xConta)

*/   

   xBanco   := SE5->E5_BANCO
   xAgencia := SE5->E5_AGENCIA
   xConta   := SE5->E5_CONTA


   DbSelectArea("SA6")
   DbSetOrder(1)
   DbGotop()
   DbSeek(xFilial("SA6") + xBanco + xAgencia + xConta)
   cConta := SA6->A6_CONTA                            
   //MsgStop(cConta)
   
DbSelectArea(vAlias)

Return(cConta)        