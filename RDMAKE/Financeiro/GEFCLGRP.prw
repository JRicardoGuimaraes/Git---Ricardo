#INCLUDE "rwmake.ch"

/**********************************************************************
* Programa....: GEFCLGRP()                                            *
* Autor.......: Marcelo Aguair Pimentel                               *
* Data........: 26/03/2007                                            *
* Descricao...: AxCadastro de Recapitulatif Client Consolide          *
*                                                                     *
**********************************************************************/

User Function GEFCLGRP()


Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZJ"

dbSelectArea("SZJ")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Client Consolide Groupe",cVldExc,cVldAlt)

Return
