#include "rwmake.ch"
#include "topconn.ch"
/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Funcao    � TLCAD004         � Autor � Sidnei Vides   � Data �  09/05/05  ��
����������������������������������������������������������������������������Ĵ��
���Descricao � Tela de manutencao da tabela 63 do SX5 de Tipos de Servico    ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/
User Function GFCAD004()
cCadastro := "Tipos de Servico"
aAutoCab    := {}
aAutoItens  := {}
PRIVATE aRotina := { { "" ,  "AxPesqui"  , 0 , 1},;  // "Pesquisar"
       				  { "",   "C160Visual", 0 , 2},;  // "Visualizar"
					  { "",   "C160Inclui", 0 , 3},;  // "Incluir"
					  { "",   "C160Altera", 0 , 4},;  // "Alterar"
					  { "",   "C160Deleta", 0 , 5} }  // "Excluir"
DbSelectArea("SX5")           
DbSetOrder(1)
If !DbSeek(xFilial("SX5")+"L4",.F.)
   MsgAlert(xFilial("SX5"))
   MsgAlert("Nao foi possivel localizar a tabela L4 no cadastro de tabelas (SX5) !")
Else   
   c160altera("SX5",,3)
Endif   
return         