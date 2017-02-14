#include 'rwmake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TM050EDI º Autor ³ Katia Alves Bianchiº Data ³ 22/04/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este Ponto de Entrada, localizado no TMSA050(Notas Fiscais  º±±
±±º          ³ dos Clientes), é utilizado na função A050AtuEDI desta       º±±
±±º          ³ rotina, para atualização de campos de usuário da tabela DTC º±±
±±º          ³ nos casos de notas fiscais EDI.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gefco                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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