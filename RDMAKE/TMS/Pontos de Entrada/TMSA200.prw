#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
/*
*---------------------------------------------------------------------------*
* Fun��o     |TMSA200   | Autor | J Ricardo              | Data | 17.06.14   *
*---------------------------------------------------------------------------*
* Descri��o  |Ponto de Entreda disparado na rotina de C�lculo de Frete.     *
*            |PE desenvolvido para filtrar a tabela DTP no MBrowse, pois    *
*            |estava muito lenta, devido carregar a tabela inteira          *
*            |                                                              *
*---------------------------------------------------------------------------*
*/            

User Function TMSA200()
ALERT(PARAMIXB[1])
ALERT(PARAMIXB[2])
ALERT(PARAMIXB[3])
Return Nil