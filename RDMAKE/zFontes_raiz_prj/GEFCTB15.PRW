#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GEFCTB15  � Autor � SAULO MUNIZ        � Data �  29/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro DE/PARA DE CENTRO DE CUSTOS NOVOS                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEFCO                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GEFCTB15

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZ3"

dbSelectArea("SZ3")
dbSetOrder(1)
DbGotop()
AxCadastro(cString,"Cadastro de Unidade Operacional",cVldAlt,cVldExc)

Return
