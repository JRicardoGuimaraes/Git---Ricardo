#INCLUDE "rwmake.ch"
/************************************************************************************
* Programa.......: GEFMSZS()                                                        *
* Autor..........: J Ricardo de O Guimarães                                         *
* Data...........: 22/07/2008                                                       *
* Descricao......: Cadastro de parâmetros da rotina de Interface                    *
*                                                                                   *
*************************************************************************************
* Modificado por.:                                                                  *
* Data...........:                                                                  *
* Motivo.........:                                                                  *
*                                                                                   *
************************************************************************************/

User Function GEFMSZS()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZS"

dbSelectArea("SZS")
//dbSetOrder(1)

AxCadastro("SZS","Cadastro de Parâmetro de Interface",cVldExc,cVldAlt)

Return
