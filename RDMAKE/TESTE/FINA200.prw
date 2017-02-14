********************************************************************
* Ponto de Entrada:  FINA200()                                     *
* Este PE e executado após carregar os dados de recepção bancária. *
*   Utilizado para alterar os dados recebidos                      *
*   Programa  : FINA200.PRW                                        *
* Finalidade: Adicionar Outros Créditos no Juros e zerar outros crd*
* Por: J Ricardo     : Em: 05/03/2007                              *
********************************************************************

#include "RWMAKE.CH"

USER Function FINA200()
Local _aPara1 := PARAMIXB[1][08]
Local _aPara2 := PARAMIXB[1][12]

// aValores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nVaLOutrD, nValCc, dDataCred, cOcorr, cMotBan, xBuffer })
//                   1         2      3      4        5         6       7         8        9       10       11       12       13        14       15      16

If _aPara2 > 0
	nJuros += nValcc
	nValcc := 0
EndIf

Return