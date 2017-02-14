#Include 'Protheus.ch'

/*
Programa    : TM050INI
Funcao      : PE TM050INI
Data        : 19/01/2016
Autor       : Andr� Costa
Descricao   : Este Ponto de Entrada permite efetuar  valida��es espec�ficas na rotina de  Altera��o de Nota Fiscal
Uso         : Apagar o Campo Observa��o Autoamtica
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



