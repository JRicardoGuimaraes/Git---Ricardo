#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCPSA004  � Autor � Marcelo Pimentel   � Data �  16/03/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Ordem Interna PSA                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Controle de Gestao                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GCPSA004()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cString := "SZH"

If __CUSERID $ GetMv("MV_XGRPFAT")
	dbSelectArea("SZH")
	dbSetOrder(1)
	
	AxCadastro(cString,"Cadastro de Ordem Interna PSA",cVldExc,cVldAlt)
Else
	MsgInfo("Usu�rio n�o permitido para executar esta rotina. <MV_XGRPFAT>") 	
EndIf

Return
