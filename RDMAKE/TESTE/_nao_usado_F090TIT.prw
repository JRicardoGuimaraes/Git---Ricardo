#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA090TIT � Autor � Vitor Sbano        � Data �  03/03/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada - destinado a ajustar o conteudo do campo ���
���          � E2_TXMOEDA com o valor registrado no parametro 5 da        ���
���          � rotina (MV_PAR05 - Cotacao Moeda Estrangeira), mantendo no ���
���          � campo especifico E2_XTXMOED o valor da Tx Original         ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 8.11 -  Financeiro / Baixa Automatica Tit Pagar   ���
���          � (Fina090)                                                  ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function F090TIT


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
// 
//alert("PE F090TIT - Vlr  Cotacao ."+transform(MV_PAR05,"@E 999,999.9999"))
//
lRet	:= .t.
_mOldArea	:=	alias()
_mOldRecn	:=	recno()
_mOldInde	:=	Indexord()

DbSelectArea("SE2")
If SE2->E2_MOEDA <> 1 .and. MV_PAR05 > 0 
	//
	RecLock("SE2",.F.)
	If SE2->E2_XTXMOED == 0							&&
		SE2->E2_XTXMOED :=	SE2->E2_TXMOEDA			&& Salvo o valor da Moeda Original Contratada
	Endif                                           &&
	SE2->E2_TXMOEDA := MV_PAR05                     && Ajusto a Moeda Contratada conforme Valor Cotacao
	MsUnlock()
	//
Endif
//
DbSelectArea(_mOldArea)
DbSetOrder(_mOldInde)
DbGoto(_mOldRecn)

Return(lRet)