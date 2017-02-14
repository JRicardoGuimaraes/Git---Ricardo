#INCLUDE "rwmake.ch"
/************************************************************************************
* Programa.......: GEFMSZP()                                                        *
* Autor..........: J Ricardo de O Guimar�es                                         *
* Data...........: 22/07/2008                                                       *
* Descricao......: Cadastro de par�metros da rotina de Interface                    *
*                                                                                   *
*************************************************************************************
* Modificado por.:                                                                  *
* Data...........:                                                                  *
* Motivo.........:                                                                  *
*                                                                                   *
************************************************************************************/

User Function GEFMSZP()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZS"

dbSelectArea("SZS")
//dbSetOrder(1)

AxCadastro("SZS","Cadastro de Par�metro de Interface",cVldExc,cVldAlt)

Return
