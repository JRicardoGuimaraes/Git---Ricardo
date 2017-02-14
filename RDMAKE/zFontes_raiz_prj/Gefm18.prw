#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

User Function Gefm18()        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � GEFM18   � Autor �   Saulo Muniz         � Data � 10/09/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza NossoNum (Cnab)                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Gefco do Brasil S/A.                       ���
�������������������������������������������������������������������������Ĵ��
���          �                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

_xNumE1 := Substr(SE1->E1_NUMBCO,1,7)  
_xNumEE := Alltrim(SEE->EE_NUMBCO)
_xNossoNum:=Space(7)
   
   DbSelectArea("SE1")
   IF(Empty(SE1->E1_NUMBCO))            
       xNum :=Soma1(_xNumEE,6)
       DbSelectArea("SEE")
       RecLock("SEE",.F.)
         SEE->EE_NUMBCO := xNum
       MsunLock()   
//     _xNossoNum:= "9"+xNum
       _xNossoNum:= "       "
    Else
       _xNossoNum:= _xNumEE   
   EndIF                                  
 

Return(_xNossoNum)        

