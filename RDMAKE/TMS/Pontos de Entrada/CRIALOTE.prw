#include "PROTHEUS.ch"

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    �CRIALOTE � Autor � Katia Alves Bianchi   � Data �02.07.2010	 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Criacao do lote automatico                               	 ���
����������������������������������������������������������������������������Ĵ��
���Uso       � Gefco                                                         ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������*/
User Function CRIALOTE()

Local aAreaAtu  := GetArea()
Local aAreaDUP  := DUP->(GetArea())

If Empty(M->DTC_LOTNFC)
	RecLock('DTP',.T.)            
	DTP->DTP_FILORI := cFilAnt 
	DTP->DTP_LOTNFC := GetSx8Num("DTP","DTP_LOTNFC")                                                                                                    
	DTP->DTP_DATLOT := dDataBase
	DTP->DTP_HORLOT := Substr( Time(), 1, 2 ) + Substr( Time(), 4, 2 )                                                                                 
	DTP->DTP_QTDLOT := 99999
	DTP->DTP_QTDDIG := 0
	DTP->DTP_STATUS := '1'
	DTP->DTP_TIPLOT := IIF(GetMv("MV_TMSCTE",,.F.),'3','1')
	//���������������������������������������������������������������������������������Ŀ
	//�Alterado - 10/01/2013 - Vin�cius Moreira                                         �
	//�Inseridas regras para grava��o dos campos de viagem, motorista e ve�culo no lote,�
	//�quando a rotina Entrada Doc. Cliente for acionada pelo TMSExpress.               �
	//�����������������������������������������������������������������������������������
	If IsInCallStack("TMSA144") .And. TmsExp()
		DTP->DTP_VIAGEM := Posicione("DUP", 1, xFilial("DUP")+M->(DTQ_FILORI+DTQ_VIAGEM), "DUP_VIAGEM")
		DTP->DTP_CODMOT := DUP->DUP_CODMOT
		DTP->DTP_CODVEI := DUP->DUP_CODVEI
	EndIf
	MsUnLock()
	ConfirmSX8()
	
	M->DTC_LOTNFC := DTP->DTP_LOTNFC	
EndIf

RestArea(aAreaDUP)
RestArea(aAreaAtu)
Return .T.