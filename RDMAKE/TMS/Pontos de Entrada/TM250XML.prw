#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TM250XML  �Autor  �Microsiga           � Data � 26/02/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ajusta XML que ser� enviado ao REPOM de acordo com as      ���
���          � necessidades da Gefco.                                     ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TM250XML()

Local aARea := GetArea()
Local aAReaDTQ := DTQ->(GetArea())
Local aAReaDTR := DTR->(GetArea())
Local cXml    := ParamIxb[1]
Local _nTam	  := Len("<operacao_codigo></operacao_codigo>")
Local nPosTxt := At("<operacao_codigo></operacao_codigo>", cXml)

If nPosTxt > 0
	//�������������������������������������������������������������������Ŀ
	//�Busca codigo da opera��o no cadastro de Operadoras de Frota.       �
	//���������������������������������������������������������������������
	DEJ->(dbSetOrder(2))//DEJ_FILIAL+DEJ_CODOPE+DEJ_SERTMS+DEJ_TIPTRA
	If DEJ->(dbSeek(xFilial("DEJ")+DTR->DTR_CODOPE+DTQ->(DTQ_SERTMS+DTQ_TIPTRA)))
		cXml	:= Stuff(cXml,nPosTxt,_nTam,"<operacao_codigo>" + allTrim(DEJ->DEJ_OPERAC) + "</operacao_codigo>")
	EndIf
EndIf

RestArea(aAreaDTR)
RestArea(aAreaDTQ)
RestArea(aArea)

Return cXml