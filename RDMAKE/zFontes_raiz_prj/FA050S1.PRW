#include "rwmake.ch"        

User Function FA050SUB()       

//
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FA050S1 � Autor � Saulo Muniz           � Data � 02/09/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tratamento                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//
//

FILIAL  := xFilial("SE2")
PREFIXO := SE2->E2_PREFIXO
NUM	    := SE2->E2_NUM
PARCELA := SE2->E2_PARCELA
TIPO	:= SE2->E2_TIPO
FORNECE := SE2->E2_FORNECE
LOJA    := SE2->E2_LOJA
NATUREZ := SE2->E2_NATUREZ
NOMFOR  := SE2->E2_NOMFOR
EMISSAO := SE2->E2_EMISSAO
EMIS1   := SE2->E2_EMIS1
VENCTO  := SE2->E2_VENCTO 
VENCORI := SE2->E2_VENCORI
VENCREA := SE2->E2_VENCREA
VALOR	:= SE2->E2_VALOR
SALDO	:= SE2->E2_SALDO
VLCRUZ  := SE2->E2_VLCRUZ
HIST    := Alltrim(SE2->E2_HIST)
FLUXO	:= "S"
RATEIO  := "N"
MOEDA	:= 1
OCORREN := "01"
ORIGEM  := "FINA050"

URet :={} 

   // MATRIZ COM OS CAMPOS INICIAIS
   //
   AADD(URet ,"E2_HIST")
   AADD(URet ,"E2_NATUREZ")       
   AADD(URet ,"E2_VENCTO")       
   AADD(URet ,"E2_VENCORI")       
   AADD(URet ,"E2_VENCREA")       
   AADD(URet ,"E2_CCONT")       
   

Return(URet)