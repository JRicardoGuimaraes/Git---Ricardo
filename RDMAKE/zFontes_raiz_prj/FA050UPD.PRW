#include "rwmake.ch"      

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    : FA050UPD ³ Autor : Saulo Muniz            ³ Data :23/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Programa para não Lançar com c.custo bloquados             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FA050INC()    
Local aArea	:=	GetArea()
//vAlias := Alias()
xBloq  := " "
xOk    := .T.
xMens  := " "

DbSelectArea("SED")
DbSetOrder(1)
DbSeek(xFilial("SED")+M->E2_NATUREZ)
cConta := SED->ED_CONTA

DbSelectArea("CT1")
DbSetOrder(1)
DbSeek(xFilial("CT1")+cConta)
xObrg  := CT1->CT1_CCOBRG

DbSelectArea("CTT")
DbSetOrder(1)
DbSeek(xFilial("CTT")+M->E2_CCONT)
xBloq := CTT->CTT_BLOQ



 If xBloq == "1" // C.Custo Bloqueado 
    xOk   := .F.  
    xMens := "1"
 Endif 
 
 If Empty(cConta)
    xOk   := .F.  
    xMens := "2" 
 Endif

 If xObrg == "1" .AND. Empty(M->E2_CCONT) // 1= SIM ; 2 = NÃO
    xOk   := .F.  
    xMens := "3" 
 Endif


 Do Case
     Case xMens == "1"
          ApMsgAlert("Centro de Custo Bloqueado ! ",'Atenção !!!')  
     Case xMens == "2"
          ApMsgAlert("Conta contábil não encontrada ! ",'Atenção !!!')  
     Case xMens == "3"
          ApMsgAlert("Centro de Custo Obrigatório ! ",'Atenção !!!')  

 Endcase

*------------------------------------------------------------------------------------------------------------*
* Por: J Ricardo - Em: 14/09/2007                                                                            *
* Objetivo: Passar para a função vldCntCC a Conta Contabil contido na tabela Natureza, em vez da Natureza.   *
*------------------------------------------------------------------------------------------------------------*
If xOk
	xOK:=u_vldCntCC(M->E2_CCONT,POSICIONE("SED",1,xFilial("SED")+M->E2_NATUREZ,"ED_CONTA"))
EndIf

//DbSelectArea(vAlias)
RestArea(aArea)
Return(xOk) 