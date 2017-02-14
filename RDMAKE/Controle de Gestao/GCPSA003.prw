#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCPSA003  � Autor � Marcelo Pimentel   � Data �  16/03/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Centro de Custo PSA                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Controle de Gestao                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GCPSA003()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cString := "SZG"

If __CUSERID $ GetMv("MV_XGRPFAT")
	dbSelectArea("SZG")
	dbSetOrder(1)
	
	AxCadastro(cString,"Cadastro de C.Custo PSA",cVldExc,cVldAlt)
Else
	MsgInfo("Usu�rio n�o permitido para executar esta rotina. <MV_XGRPFAT>") 	
EndIf

Return
