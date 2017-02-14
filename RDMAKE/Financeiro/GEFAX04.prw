#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GEFAX04   � Autor � Marcelo Pimentel   � Data �  27/03/07   ���
�������������������������������������������������������������������������͹��
���Descricao � AxCadastro para a tabela SZK do relat�rio de Recapitulatif ���
���          � par client consolide groupe                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GEFAX04()
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZK"

dbSelectArea("SZK")
dbSetOrder(1)

AxCadastro(cString,"Recaptilatif par Client Consolide Groupe",cVldExc,cVldAlt)

Return
