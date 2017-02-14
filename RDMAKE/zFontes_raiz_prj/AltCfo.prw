#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AltCfo   � Autor � Saulo Muniz        � Data � 03-Jun-2004 ���
�������������������������������������������������������������������������͹��
���Descricao � Tela para alteracao de CFOP das notas antiga               ���
�������������������������������������������������������������������������͹��
���Uso       � Gefco                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ALTCFO

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local   cArq,cInd
Private cCadastro := "Alteracao de Titulos"
Private lAltera := .T. //Validacao para alteracao
Private cDelFunc := ".T." // Validacao para a exclusao.
Private _xValid := "" //Guarda o valor de X3_VALID

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Alterar","AxAltera",0,3} } //"AxAltera",0,3} }

//���������������������������������������������������������������������Ŀ
//� Monta array com os campos para o Browse                             �
//�����������������������������������������������������������������������'
Private aCampos := { {"Nota Fiscal","D1_DOC"},;
			{"Serie","D1_SERIE"},;
			{"CFOP","D1_CF"}}


//���������������������������������������������������������������������Ŀ
//� Altera temporariamente a validacao do X3_VALID para liberar a alte- �
//� cao da Natureza dos titulos, mesmo que estejam baixados.            �
//�����������������������������������������������������������������������'
dbSelectArea("SX3")
dbSetOrder(2)
Dbgotop()

dbSeek("D1_CF")
_xValid1 := AllTrim(SX3->X3_VALID)
RecLock("SX3",.F.)
SX3->X3_VALID := AllTrim(SX3->X3_VALID) //+ " .OR. .T."
MsUnLock("SX3")

dbSeek("D1_PICM")
_xValid2 := AllTrim(SX3->X3_VALID)
RecLock("SX3",.F.)
SX3->X3_VALID := AllTrim(SX3->X3_VALID) //+ " .OR. .T."
MsUnLock("SX3")

dbSeek("D1_IPI")
_xValid3 := AllTrim(SX3->X3_VALID)
RecLock("SX3",.F.)
SX3->X3_VALID := AllTrim(SX3->X3_VALID) //+ " .OR. .T."
MsUnLock("SX3")

dbSeek("D1_LOCPAD")
_xValid4 := AllTrim(SX3->X3_VALID)
RecLock("SX3",.F.)
SX3->X3_VALID := AllTrim(SX3->X3_VALID) //+ " .OR. .T."
MsUnLock("SX3")


//���������������������������������������������������������������������Ŀ
//� Fim da alteracao do X3                                              �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� Gera a tela do Browse                                               �
//�����������������������������������������������������������������������
mBrowse(06,01,22,75,"SD1",,"D1_CF")

//���������������������������������������������������������������������Ŀ
//� Alteracao do X3 para retornar a condicao inicial                    �
//�����������������������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(2)

dbSeek("D1_CF")
RecLock("SX3",.F.)
SX3->X3_VALID := _xValid1
MsUnLock("SX3")

dbSeek("D1_PICM")
RecLock("SX3",.F.)
SX3->X3_VALID := _xValid2
MsUnLock("SX3")

dbSeek("D1_IPI")
RecLock("SX3",.F.)
SX3->X3_VALID := _xValid3
MsUnLock("SX3")

dbSeek("D1_LOCPAD")
RecLock("SX3",.F.)
SX3->X3_VALID := _xValid4
MsUnLock("SX3")


//���������������������������������������������������������������������Ŀ
//� Fim da alteracao do X3                                              �
//�����������������������������������������������������������������������

Return