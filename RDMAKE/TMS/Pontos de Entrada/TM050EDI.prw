#include 'rwmake.ch'
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � TM050EDI � Autor � Katia Alves Bianchi� Data � 22/04/2010   ���
��������������������������������������������������������������������������͹��
���Desc.     � Este Ponto de Entrada, localizado no TMSA050(Notas Fiscais  ���
���          � dos Clientes), � utilizado na fun��o A050AtuEDI desta       ���
���          � rotina, para atualiza��o de campos de usu�rio da tabela DTC ���
���          � nos casos de notas fiscais EDI.                             ���
��������������������������������������������������������������������������͹��
���Uso       � Gefco                                                       ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function TM050EDI()

Local nPos := 0
Local nCnt := Len(aCols)
                             
M->DTC_CCUSTO:=DE5->DE5_CCUSTO
__readvar:='M->DTC_CCUSTO'

M->DTC_TIPDES:=DE5->DE5_TIPDES
__readvar:='M->DTC_TIPDES'

nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == 'DTC_NFEID'})
If nPos > 0
    aCols[nCnt,nPos] := DE5->DE5_NFEID
    __readvar:='M->'+aHeader[nPos][2]
   CheckSX3(aHeader[nPos][2],aCols[nCnt,nPos])
Endif                                   

nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == 'DTC_PEDCLI'})
If nPos > 0
    aCols[nCnt,nPos] := DE5->DE5_PEDCLI
    __readvar:='M->'+aHeader[nPos][2]
   CheckSX3(aHeader[nPos][2],aCols[nCnt,nPos])
Endif                                   

nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == 'DTC_MANIF'})
If nPos > 0
    aCols[nCnt,nPos] := DE5->DE5_MANIF
    __readvar:='M->'+aHeader[nPos][2]
   CheckSX3(aHeader[nPos][2],aCols[nCnt,nPos])
Endif                                   
Return Nil