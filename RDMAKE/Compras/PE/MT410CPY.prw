#INCLUDE "RWMAKE.CH"
/****************************************************************************
* Programa......: MT410CPY                                                  *
* Autor.........: J Ricardo de O Guimarães                                  *
* Data..........: 02/05/2008                                                *
* Descricao.....: PE para limpar o campo centro de custo ao Copiar o Pedido.*
*                 PE executado na rotina de Cópia de Pedido.                *
*                                                                           *
*****************************************************************************
* Modificado por:                                                           *
* Data..........:                                                           *
* Motivo........:                                                           *
*                                                                           *
****************************************************************************/
User Function MT410CPY()
Local _aArea := GetArea()

If ValType("M->C5_CCUSTO") == "C"
//	M->C5_CCUSTO := Space(TAMSX3("C5_CCUSTO")[1])
	If !Empty(U_VLDPSA("CCPAD"))
		M->C5_CCUSTO := Space(TAMSX3("C5_CCUSTO")[1])
	EndIf
	
	dbSelectArea("CTT") ; dbSetOrder(1)
	If DbSeek(xFilial("CTT")+M->C5_CCUSTO)
       	If CTT->CTT_BLOQ == "1"
       		Aviso("Informação","Centro de Custo " + M->C5_CCUSTO + " Bloqueado.",{"Ok"})
			M->C5_CCUSTO := Space(TAMSX3("C5_CCUSTO")[1])
       	Endif
	EndIf
EndIf	

RestArea(_aArea)
Return

