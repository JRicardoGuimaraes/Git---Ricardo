#INCLUDE "rwmake.ch"

/************************************************************************
* Programa........: GEFR025                                             *
* Autor...........: Marcelo Aguiar Pimentel                             *
* Data............: 30/04/2007                                          *
* Descricao.......: AxCadastro de Filial x Centro de Custo              *
*                                                                       *
*************************************************************************
* Modificado por..:                                                     *
* Data............:                                                     *
* Motivo..........:                                                     *
*                                                                       *
************************************************************************/
User Function GEFCTB25()

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZQ"

dbSelectArea("SZQ")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Filial x Centro Custo",cVldAlt,cVldExc)

Return
