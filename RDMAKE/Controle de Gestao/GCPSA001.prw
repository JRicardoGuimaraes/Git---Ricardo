#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCPSA001  � Autor � Marcelo Pimentel   � Data �  16/03/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Clientes PSA-Peugeot.                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Controle de Gestao                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GCPSA001()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cString := "SZE"

If __CUSERID $ GetMv("MV_XGRPFAT")
	dbSelectArea("SZE")
	dbSetOrder(1)
	
	AxCadastro(cString,"Cadastro de Clientes Peugeot PSA",cVldExc,cVldAlt)
Else
	MsgInfo("Usu�rio n�o permitido para executar esta rotina. <MV_XGRPFAT>") 	
EndIf

Return
