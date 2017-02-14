#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

User Function Gefm10()        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � GEFM10   � Autor �   Saulo Muniz         � Data � 17/12/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza Endereco de Cobranca (Cnab)                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Gefco do Brasil S/A.                       ���
�������������������������������������������������������������������������Ĵ��
���          � ENDERECO                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//XEND1:= Len(Alltrim(SA1->A1_END))
//XEND2 := Len(Alltrim(SA1->A1_ENDCOB))

XENDCOB := Alltrim(SA1->A1_ENDCOB)

//   IF(XEND1 == XEND2)
//      XENDCOB := Alltrim(SA1->A1_END)
//   Else
//      XENDCOB:= Alltrim(SA1->A1_ENDCOB)
//   EndIF                                  
 
//IIF(Len(Alltrim(SA1->A1_END)) == Len(Alltrim(SA1->A1_ENDCOB)),SA1->A1_END,IIF(!Empty(SA1->A1_ENDCOB),SA1->A1_ENDCOB,SA1->A1_END))


Return(XENDCOB)        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

