#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TCONA050  �Autor  �  Suporte Rdmake    � Data �  04/09/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Exemplo Rotina Automatica - Lan�amentos Cont�beis          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TCona050()
Local aCab	:= {}
Local aItem	:= {}
Local aTotItem := {}

lMsErroAuto := .F.
//Adiciona os valores no array de cabe�alho
aCab := {	{"CT2_DATA"		,ctod("11/12/07")	,NIL},;
			{"CT2_LOTE"		,"0000"				,NIL},;
			{"CT2_DOC"	    ,"000007"			,NIL}}
			
//Adiciona os valores no array de itens
aItem := {	{"CT2_LINHA"	,"01"		,NIL},;
			{"CT2_DC"		,"D"		,NIL},;
			{"CT2_DEBITO"	,"112204"	,NIL},;
			{"CT2_VALOR"	,10			,NIL},;
			{"CT2_HIST"		,"TESTE"	,NIL} }

Aadd(aTotItem,aItem)

aItem := {	{"CT2_LINHA"	,"02"		,NIL},;
			{"CT2_DC"		,"C"		,NIL},;
			{"CT2_CREDITO"	,"112101"	,NIL},;
			{"CT2_VALOR"	,10			,NIL},;
			{"CT2_HIST"		,"TESTE"	,NIL}}

Aadd(aTotItem,aItem)

MSExecAuto({|x,y,Z| CTBA102(x,y,Z)},NIL,aCab,aTotItem)

If lMsErroAuto
	Alert("Erro")
Else
	Alert("Ok")
Endif
Return
