#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

User Function Gefm11()        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � GEFM11   � Autor �   Saulo Muniz         � Data � 17/12/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza Endereco de Cobranca (Cnab)                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Gefco do Brasil S/A.                       ���
�������������������������������������������������������������������������Ĵ��
���          � BAIRRO                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//IIF(SA1->A1_BAIRRO == SA1->A1_BAIRROC,SUBS(SA1->A1_BAIRRO,1,12),SUBS(SA1->A1_BAIRROC,1,12))

//XBAIRRO1:= Len(Alltrim(SA1->A1_BAIRRO))
//XBAIRRO2:= Len(Alltrim(SA1->A1_BAIRROC))

XBAIRROCOB := Alltrim(SA1->A1_BAIRROC)

//  IF(XBAIRRO1 == XBAIRRO2)
//      XBAIRROCOB := Alltrim(SA1->A1_BAIRRO)
//  Else
//      XBAIRROCOB := Alltrim(SA1->A1_BAIRROC) 
//  EndIF


Return(XBAIRROCOB)        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

