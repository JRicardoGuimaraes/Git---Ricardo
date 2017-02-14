#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
/*
*---------------------------------------------------------------------------*
* Função     |TMSA200   | Autor | J Ricardo              | Data | 17.06.14   *
*---------------------------------------------------------------------------*
* Descrição  |Ponto de Entreda disparado na rotina de Cálculo de Frete.     *
*            |PE desenvolvido para filtrar a tabela DTP no MBrowse, pois    *
*            |estava muito lenta, devido carregar a tabela inteira          *
*            |                                                              *
*---------------------------------------------------------------------------*
*/            
/*
User Function TMSA200()
ALERT(PARAMIXB[1])
ALERT(PARAMIXB[2])
ALERT(PARAMIXB[3])
Return Nil
*/
User Function GEFTMSA200()

Local cTop200 := '791000' // --- Ele vai montar um filtro a partir do lote 791000
Local cBot200 := '999999'
Local cIndex  := 1

TMSA200(cTop200,cBot200,cIndex)

Return
