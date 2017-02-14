#include "rwmake.ch"
#include "topconn.ch"

/************************************************************************************
* Programa.......: SIGAFIN()                                                        *
* Autor..........: J Ricardo de O Guimarães                                         *
* Data...........: 28/05/2008                                                       *
* Descricao......: Ponto de entrada executado ao acesso o módulo Financeiro         *
*                                                                                   *
*************************************************************************************
* Modificado por.:                                                                  *
* Data...........:                                                                  *
* Motivo.........: 																	*
*                                                                                   *
************************************************************************************/

*------------------------*
USER FUNCTION SIGAFIN
*------------------------*
Local _cQry  := ""
Local _aArea := GetArea()
Local _cMsg  := ""

// STATUS: 1-Aberto, 2-Fechado, 3-Transportado, 4-Bloqueado
_cQry := "SELECT CTG_CALEND, CTG_EXERC, CTG_DTINI, CTG_DTFIM, CTG_STATUS " 
_cQry += "		 FROM " + RetSqlName("CTG010") + " CTG " 
_cQry += "		WHERE D_E_L_E_T_ = '' "
_cQry += "		  AND CTG_FILIAL = '" + xFilial("CTG") + "' "
_cQry += "		  AND CTG_EXERC  = '" + StrZero(Year(dDatabase),4) + "' "
_cQry += "		  AND '" + DTOS(dDatabase) + "' BETWEEN CTG_DTINI AND CTG_DTFIM "

TCQUERY _cQry ALIAS "TCTG" NEW

dbSelectArea("TCTG") ; dbGoTop()
If !Eof()

	_cMSg := "Período Contabil "
	
	If TCTG->CTG_STATUS = '2'
		_cMsg := _cMsg + "FECHADO. "
	ElseIf TCTG->CTG_STATUS = '3'
		_cMsg := _cMsg + "TRANSPORTADO. "
	ElseIf TCTG->CTG_STATUS = '4'
		_cMsg := _cMsg + "BLOQUEADO. "
	EndIf

	_cMsg := _cMsg + "Favor contactar o depto. Contabil ou informar uma data de um período contabil aberto."
	                                  	
	If TCTG->CTG_STATUS <> '1'
		Aviso("Atenção",_cMsg,{"Ok"})

		dbSelectArea("TCTG") ; dbCloseArea()
		RestArea(_aArea)
		// QUIT // Abadona o módulo
		Final("Atenção","O Módulo do sistema será fechado")
	EndIf
		
EndIf

dbSelectArea("TCTG") ; dbCloseArea()
RestArea(_aArea)

/*
+-----------------------------------------------------------------------------+
|Programa  : SIGAFIN   | Autor : J Ricardo Guimarães | Data :  09/22/09       |
|-----------------------------------------------------------------------------+
| Desc.    : Ponto de entrada que atuará no módulo financeiro para impedir    |
|          : operação com a data do sistema inferior a data informada no      |
|          : parâmetro MV_DATAFIN                                             |
|-----------------------------------------------------------------------------|
| Uso      : Financeiro                                                       |
+-----------------------------------------------------------------------------+
*/

If dDataBase < GetMV("MV_DATAFIN") 
	// Aviso("Atenção","Simtema bloqueado para o módululo Financeiro para data inferior a " + dTOc(GetMV("MV_DATAFIN")) ,{"Sair"})
	// Sair do Sistema
	Final("Atenção","Simtema bloqueado para o módululo Financeiro para data inferior a " + dTOc(GetMV("MV_DATAFIN")))
EndIf

RETURN
