/*
�������������������������������������������������������������������������͹��
���Programa  �SF1100I   �Autor  � PAPA        � Data �  10/07/07          ���
���Desc.     � Ponto de Entrada apos a gera��o dos titulos no financeiro  ���
���          � e antes da contabiliza��o de compras.                      ���
���Uso       � Compras                                                    ���
�������������������������������������������������������������������������͹��
*/


User Function SF1100I()

Local aAreaSE2	:= SE2->(GetArea())
Local aArea		:= GetArea()

// Pontera no SE2 e soma todos os impostos que realmente foram gerados
DbSelectArea("SE2")
DbSetOrder(6)
DbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DOC)
// Busca Todas as parcelas do Titulos para verificar valor de impostos total
nTotCof:=0
nTotCsl:=0
nTotPis:=0
Do While xFilial("SE2")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM==xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DOC
	nTotCof	+=SE2->E2_VRETCOF
	nTotCsl	+=SE2->E2_VRETCSL
	nTotPis	+=SE2->E2_VRETPIS
	DbSkip()
EndDo
// Grava no SF1 valor total de Impostos que gerar�o titulos
RecLock("SF1",.F.)
	SF1->F1_VALCOFI	:=nTotCof
	SF1->F1_VALPIS	:=nTotPis
	SF1->F1_VALCSSL	:=nTotCsl
MsUnlock()

RestArea(aAreaSE2)
RestArea(aArea)
Return