#INCLUDE "rwmake.ch"

/************************************************************************
* Programa........: GEFR014                                             *
* Autor...........: Marcelo Aguiar Pimentel                             *
* Data............: 30/04/2007                                          *
* Descricao.......: AxCadastro para os dados processados da Tabela SZO  *
*                   Vendas Metier                                       *
*                                                                       *
*************************************************************************
* Modificado por..:                                                     *
* Data............:                                                     *
* Motivo..........:                                                     *
*                                                                       *
************************************************************************/
User Function GEFCTB14()

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZO"

dbSelectArea("SZO")
dbSetOrder(1)

AxCadastro(cString,"Arquivo de Vendas Metier",cVldAlt,cVldExc)

Return
