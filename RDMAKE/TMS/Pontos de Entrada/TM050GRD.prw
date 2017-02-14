#Include 'Protheus.ch'

/*
Programa    : TM050GRD
Funcao      : PE TM050GRD
Data        : 01/03/2016
Autor       : André Costa
Descricao   : Este PE, localizado no TMSA050 (Notas-Fiscais do Cliente), permite ao usuário efetuar manipulação na Getdados e aCols.
Uso         : Apagar o Campo Observação Autoamtica
Chamenda    : Interna
*/

User Function TM050GRD
	Local aArea := GetArea()

	If PARAMIXB[1] == 3
		M->DTC_OBS := ""
	EndIf

	RestArea( aArea )

Return Nil

