#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCPSA005  � Autor � Marcelo Pimentel   � Data �  16/03/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de CONTA X C.CUSTO X ORDEM INTERNA                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Controle de Gestao                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GCPSA005()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cString := "SZI"

If __CUSERID $ GetMv("MV_XGRPFAT")
	dbSelectArea("SZI")
	dbSetOrder(1)
	
	AxCadastro(cString,"Cadastro de Conta X C.Custo X Ordem Interna",cVldExc,cVldAlt)
Else
	MsgInfo("Usu�rio n�o permitido para executar esta rotina. <MV_XGRPFAT>") 	
EndIf

Return
