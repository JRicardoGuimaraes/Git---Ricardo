#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

User Function Gefm13()        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � GEFM13   � Autor �   Saulo Muniz         � Data � 17/12/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza Endereco de Cobranca (Cnab)                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Gefco do Brasil S/A.                       ���
�������������������������������������������������������������������������Ĵ��
���          � ESTADO                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//IIF(SA1->A1_EST == SA1->A1_ESTC,SUBS(SA1->A1_EST,1,2),SUBS(SA1->A1_ESTC,1,2))

//XEST1:= Len(Alltrim(SA1->A1_EST))
//XEST2:= Len(Alltrim(SA1->A1_ESTC))    
XESTCOB:= Alltrim(SA1->A1_ESTC)

//  IF( XEST1 == XEST2)
//     XESTCOB:= Alltrim(SA1->A1_EST)  
//  Else
//     XESTCOB:= Alltrim(SA1->A1_ESTC)
//  EndIf

Return(XESTCOB)        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

