#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCTGA001  � Autor � Marcos Furtado     � Data �  05/03/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de amarracao de faturamento.                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Controle de Gestao                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GCTGA001


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cString := "SZD"

If __CUSERID $ GetMv("MV_XGRPFAT")
	dbSelectArea("SZD")
	dbSetOrder(1)
	
	AxCadastro(cString,"Cadastro de amarracao de Faturamento",cVldExc,cVldAlt)
Else
	MsgInfo("Usu�rio n�o permitido para executar esta rotina. <MV_XGRPFAT>") 	
EndIf

Return
