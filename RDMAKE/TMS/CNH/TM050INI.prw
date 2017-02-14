#Include 'Protheus.ch'

/*
Programa    : TM050INI
Funcao      : PE TM050INI
Data        : 19/01/2016
Autor       : André Costa
Descricao   : Este Ponto de Entrada permite efetuar  validações específicas na rotina de  Alteração de Nota Fiscal
Uso         : Apagar o Campo Observação Autoamtica
Chamenda    : Interna
*/

User Function TM050INI
	Local aArea := GetArea()
/*
	If PARAMIXB[1] == 3
		M->DTC_CODOBS := ""
	EndIf
*/
	RestArea( aArea )

Return Nil



