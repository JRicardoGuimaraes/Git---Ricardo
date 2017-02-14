#include "rwmake.ch"
#include "topconn.ch"

/************************************************************************************
* Programa.......: GEFMCTB()                                                        *
* Autor..........: J Ricardo de O Guimarães                                         *
* Data...........: 30/10/2008                                                       *
* Descricao......: Função responsável pela verificação se a data do sistema está    *
*                  em um período contábil aberto ou fechado                         *
*                  Verificar em Geração/Exclusão de NF(Faturamento), Inclusão no    *
*                  Financeiro e as interfaces de CTRC                               *
*************************************************************************************
* Modificado por.:                                                                  *
* Data...........:                                                                  *
* Motivo.........: 																	*
*                                                                                   *
************************************************************************************/

*--------------------------------*
* Prepara Documento de Saída(NF) *
*--------------------------------*
User FUNCTION MATA460AX()
If U_GEFMCTB()
	MATA460A()
EndIf

*---------------------------------*
* Exclusão Documento de Saída(NF) *
*---------------------------------*
User FUNCTION MATA521AX()
If U_GEFMCTB()
	MATA521A()
EndIf

*---------------------------------*
* Exclusão Documento de Saída(NF) *
*---------------------------------*
User FUNCTION MATA410X()
If U_GEFMCTB()
	MATA410()
EndIf

Return

*---------------------------------*
USER FUNCTION GEFMCTB()
*---------------------------------*
Local _cQry  := ""
Local _aArea := GetArea()
Local _cMsg  := ""
Local _cRet  := .T.

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

	_cMSg := "O Período Contabil de " + DTOC(STOD(TCTG->CTG_DTINI)) + " até " + DTOC(STOD(TCTG->CTG_DTFIM)) + " encontra-se "
	
	If TCTG->CTG_STATUS = '2'
		_cMsg := _cMsg + "FECHADO. "
	ElseIf TCTG->CTG_STATUS = '3'
		_cMsg := _cMsg + "TRANSPORTADO. "
	ElseIf TCTG->CTG_STATUS = '4'
		_cMsg := _cMsg + "BLOQUEADO. "
	EndIf

	_cMsg := _cMsg + Chr(13) + "Favor contactar o depto. Contabil ou informar uma data de um período contabil aberto."
	
	If TCTG->CTG_STATUS <> '1'
		Aviso("Atenção",_cMsg,{"Ok"})

//		dbSelectArea("TCTG") ; dbCloseArea()
//		RestArea(_aArea)
		_cRet  := .F.
	EndIf
Else
	Aviso("Atenção","Não existe um período contábil cadastrado para a data informado ao sistema." + Chr(13) +;
	      "Favor informar ao depto. contábil.",{"Ok"})
	_cRet  := .F.
EndIf

dbSelectArea("TCTG") ; dbCloseArea()
RestArea(_aArea)

RETURN _cRet
