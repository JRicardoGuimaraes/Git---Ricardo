#INCLUDE "rwmake.ch"

User Function GEFM17

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString
Private cString := "SE2"

dbSelectArea("SE2")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Contas a Pagar ",cVldAlt,cVldExc)

Return
