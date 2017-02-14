#INCLUDE "FIVEWIN.CH"
#INCLUDE "RWMAKE.CH"
/*
+-------------------------------------------------------------------------------+
|Programa  : TM050BUT   | Autor : J Ricardo Guimarães | Data :  29/09/10        |
|-------------------------------------------------------------------------------+
| Desc.    : Ponto de Entrada executado na rotina TMSA050 que permite adicionar |
|          : botões à tela de entrada de doc de cliente.                        |
|          :                                                                    |
|-------------------------------------------------------------------------------|
| Uso      : Módulo TMS                                                         |
+-------------------------------------------------------------------------------+
*/
USER Function TM050BUT()
Local aButtons := {}
	Aadd(aSetKey , { VK_F10   ,{|| fSomaVol() } }  )
	AAdd(aButtons, {'BMPPARAM',{|| fSomaVol() }, "Soma Volume <F10>", "Soma Vol." }) //"Cotacoes Realizadas - <F9>"
RETURN aButtons                                                       

*-----------------------------*
Static Function fSomaVol()
*-----------------------------*
Local _nI
Local _nTotVol   := 0
Local _nTotPeso  := 0
Local _nTotPeso3 := 0
Local _nValorTot := 0
Local _nValorTot3:= 0
Local _nPosVol   := Ascan(aHeader, { |x| AllTrim(x[2]) == 'DTC_QTDVOL' })
Local _nPosPeso  := Ascan(aHeader, { |x| AllTrim(x[2]) == 'DTC_PESO' })
Local _nPosPeso3 := Ascan(aHeader, { |x| AllTrim(x[2]) == 'DTC_PESOM3' })
Local _nPosVrTot := Ascan(aHeader, { |x| AllTrim(x[2]) == 'DTC_VALOR' })
//Local _nPosVrTot3:= Ascan(aHeader, { |x| AllTrim(x[2]) == 'DTC_QTDVOL' })

For _nI := 1 To Len(aCols)
	_nTotVol    += aCols[_nI,_nPosVol]
	_nTotPeso   += aCols[_nI,_nPosPeso]
	_nTotPeso3  += aCols[_nI,_nPosPeso3]
	_nValorTot  += aCols[_nI,_nPosVrTot]
//	_nValorTot3 += aCols[_nI,12]
Next x
Aviso("Totais dos Itens", "Total de Volumes: " + AllTrim(Str(_nTotVol  )) + chr(13)+chr(10) +;
      				      "Peso Total      : " + AllTrim(TransForm(_nTotPeso , "@E 999,999,999.9999" )) + chr(13)+chr(10) +;
       				      "Valor Total     : " + AllTrim(Transform(_nValorTot, "@E 999,999,999.99" )), {"Ok"} )
Return