#Include 'Protheus.ch'

/*
Programa    : TM050GRD
Funcao      : PE TM050GRD
Data        : 01/03/2016
Autor       : Andr� Costa
Descricao   : Este PE, localizado no TMSA050 (Notas-Fiscais do Cliente), permite ao usu�rio efetuar manipula��o na Getdados e aCols.
Uso         : Apagar o Campo Observa��o Autoamtica
Chamenda    : Interna
*/

User Function TM050GRD
	Local aArea := GetArea()

	If PARAMIXB[1] == 3
		M->DTC_OBS := ""
	EndIf

	RestArea( aArea )

Return Nil

