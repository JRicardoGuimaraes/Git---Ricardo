#include "rwmake.ch"

User Function GEF650()

Local aArea := getarea()
//Funcao    : GEF650  ³ Autor : PAPA            ³ Data :31/05/07
//Descricao : Posicionamento dos valores de retencao

SetPrvt("VALIAS,CPIS,")

//vAlias := Alias()

dbSelectArea("SE2")
dbSetOrder(6)
cChave:=xFilial("SE2") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_PREFIXO + SF1->F1_DOC
dbSeek(cChave)
While !Eof() .and. cChave == (SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO + SE2->E2_NUM)
	cPIS := SE2->E2_VRETPIS
	If cPIS == 0
		dbSelectArea("SE2")
		dbSkip()
	Else
		exit
	EndIf
EndDo
//Endif
	
	
Return(cPIS)    

