#include "rwmake.ch"   

User Function GEFM40() 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � GEFM40    � SAULO MUNIZ                  � Data � 15.03.05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �  							              		          ���
�������������������������������������������������������������������������Ĵ��
���Utilizacao� Especifico para GEFCO                                      ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���   /  /   � Saulo         �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

_mOldArea	:=	Alias()
_mOldInde	:=	IndexOrd()
_mOldRecn	:=	Recno()


xPedido := ParamIxb[1]
xItem   := ParamIxb[2]
xSeq    := ParamIxb[3]

MsgInfo(xPedido+"-"+xItem+"-"+xSeq)

//DbSelectArea("SC9")
//xPed := SC9->C9_PEDIDO


DbSelectArea("SE1")
DbsetOrder(1)
If DbSeek(xFilial()+xPedido)
   cNumero := SC5->C5_GEFDOC
   cSerie  := SC5->C5_GEFSER  
Endif


DbSelectArea(_mOldArea)
DbSetOrder(_mOldInde)
DbGoto(_mOldRecn)

Return