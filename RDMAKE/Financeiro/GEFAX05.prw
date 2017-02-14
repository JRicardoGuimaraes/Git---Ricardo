#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GEFAX05   � Autor � Marcelo Pimentel   � Data �  02/04/07   ���
�������������������������������������������������������������������������͹��
���Descricao � AxCadastro para a tabela SZL calend�rio de exporta��o de   ���
���          � t�tulos para Argentina.                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GEFAX05()
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZL"

dbSelectArea("SZL")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Calend�rio de Exporta��o de t�tulos",cVldExc,cVldAlt)

Return
