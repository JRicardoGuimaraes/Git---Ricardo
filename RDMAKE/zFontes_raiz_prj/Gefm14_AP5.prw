#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

User Function Gefm14()        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � GEFM14   � Autor �   Saulo Muniz         � Data � 17/12/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza Endereco de Cobranca (Cnab)                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Gefco do Brasil S/A.                       ���
�������������������������������������������������������������������������Ĵ��
���          � CEP                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//IIF(SA1->A1_CEP == SA1->A1_CEPC,VAL(SUBS(SA1->A1_CEP,1,5)),VAL(SUBS(SA1->A1_CEPC,1,5)))

//XCEP1:= Len(Alltrim(SA1->A1_CEP))
//XCEP2:= Len(Alltrim(SA1->A1_CEPC))
//XCEPCOB := " "

XCEPCOB := Alltrim(SA1->A1_CEPC)

//    IF(XCEP1 == XCEP2)
//        XCEPCOB := Alltrim(SA1->A1_CEP)
//    Else
//        XCEPCOB :=  Alltrim(SA1->A1_CEPC)
//    EndIF


Return(XCEPCOB)        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

