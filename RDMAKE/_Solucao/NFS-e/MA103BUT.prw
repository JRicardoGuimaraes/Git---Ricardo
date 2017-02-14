#include "protheus.ch"
#include "folder.ch"
#include "colors.ch"
#include "Font.ch"
#include "tbiconn.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA103BUT �Autor  � Leandro Passos     � Data �  27/08/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada, para criar bot�o com finalidade de       ���
���          � buscar arquivos .XML para importar Notas de Servicos       ���
�������������������������������������������������������������������������͹��
���Uso       � Compras - Entrada de Nota Fiscal                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA103BUT()   

// declaracao de variaveis
Local _aBotao     := {}
Local _aInfo      := PARAMIXB[1]
Public _mArqXML   := ""
Public _mMemoXML  := ""
Public _aInfoRPS  := {"","",CTOD(""),"","",0}

// adiciona botao
aAdd(_aBotao,{ "CARGA",{|| U_IMPRTXML()},"Importa XML"})

// retorna
Return(_aBotao)
