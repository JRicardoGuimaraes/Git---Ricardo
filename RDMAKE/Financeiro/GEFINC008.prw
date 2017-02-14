#INCLUDE "rwmake.ch"

/*************************************************************************************
* Programa.....: GEFINC008()                                                         *
* Autor........: Marcelo Aguiar Pimentel                                             *
* Data.........: 23/02/2007                                                          *
* Descricao....: AxCadastro da Tabela SZ9 PDD                                        *
*                                                                                    *
**************************************************************************************
* Alterado por.:                                                                     *
* Data.........:                                                                     *
* Motivo.......:                                                                     *
*                                                                                    *
*************************************************************************************/

User Function GEFINC008()
Local cVldAlt := ".F."
Local cVldExc := ".F."

Private cString := "SZ9"

dbSelectArea("SZ9")
dbSetOrder(1)

AxCadastro(cString,"Relação de Provisão de Devedores Duvidosos",cVldExc,cVldAlt)

Return