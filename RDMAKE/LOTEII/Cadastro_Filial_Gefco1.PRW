#INCLUDE "rwmake.ch"

/*
*---------------------------------------------------------------------------*
* Função     |GEFFIL     | Autor | Jesus Oliveira        | Data | 21.01.10  *
*---------------------------------------------------------------------------*
* Descrição  |Tela de Manutençao dodo cadastro das filiais GEFCO para       *
*            |integração na interface Lote II.                              *
*---------------------------------------------------------------------------*
*/

User Function GEFFIL()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cString := "SZX"

//	dbSelectArea("SZC")
//	dbSetOrder(1)
	
	AxCadastro(cString,"Cadastro de Filiais GEFCO",cVldExc,cVldAlt)

Return
