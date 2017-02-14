#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Programa  �TM200TES  � Autor � Katia Alves Bianchi� Data �  27/07/09   ���
�������������������������������������������������������������������������͹��
���Descricao � PE para alterar a TES do calculo do frete - TMSA200        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gefco                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TM200TES()    

Local cNumNFC, cSerNFC, cCliRem, cLojRem, cLojCon, cCliCon, cUfCons, cTesEsp, cCliDes, cLojDes, cRegDes
Local cTesSImp:= GETMV('MV_GEF009')
Local aNotas   := PARAMIXB[1]

If Alltrim(FunName())=='TMSA200' .and. !Empty(cTesSImp) // somente quando chamado do calculo e o paramatro MV_GEF009 estiver preenchido
	
	cNumNFC  := aNotas[1][1]
	cSerNFC  := aNotas[1][2]
	cCliRem  := ParamIXB[2]
	cLojRem  := ParamIXB[3]
	cCliDes  := Posicione('DTC',2,XFILIAL('DTC')+cNumNFC+cSerNFC+cCliRem+cLojRem,'DTC_CLIDES')
	cLojDes  := Posicione('DTC',2,XFILIAL('DTC')+cNumNFC+cSerNFC+cCliRem+cLojRem,'DTC_LOJDES')
	cCliCon  := Posicione('DTC',2,XFILIAL('DTC')+cNumNFC+cSerNFC+cCliRem+cLojRem,'DTC_CLICON')
	cLojCon  := Posicione('DTC',2,XFILIAL('DTC')+cNumNFC+cSerNFC+cCliRem+cLojRem,'DTC_LOJCON')
	cRegDes  := Posicione('SA1',1,XFILIAL('DTC')+cCliDes+cLojDes,'A1_REGALFA')
	cUfCons  := Posicione('SA1',1,XFILIAL('DTC')+cCliCon+cLojCon,'A1_EST')
	// somente quando cliente destinatario estiver em regiao alfandegaria e o consignatario estiver no exterior
	If cRegDes=='1' .AND. cUfCons=='EX'
		cTesEsp := cTesSImp
	Endif
Endif
Return cTesEsp
