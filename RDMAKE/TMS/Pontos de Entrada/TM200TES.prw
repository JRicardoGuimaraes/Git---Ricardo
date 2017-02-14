#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณTM200TES  บ Autor ณ Katia Alves Bianchiบ Data ณ  27/07/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ PE para alterar a TES do calculo do frete - TMSA200        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gefco                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
