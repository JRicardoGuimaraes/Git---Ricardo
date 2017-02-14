#include "rwmake.ch"      

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    : FA050INC ³ Autor : Saulo Muniz            ³ Data :23/06/05 ³±±
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

*-------------------------------------------------------------------------------------------------------------------*
* Por: J Ricardo - Em: 23/10/2007                                                                                   *
* Objetivo: Não permitir data de quinzena(E2_DTRML) passar em branco caso o CC seja de 10 dígitos e iniciar em 211. *
*           Solicitação feita pelo Paulo Abreu.
*-------------------------------------------------------------------------------------------------------------------*
If !Empty(M->E2_CCONT) .AND. Len(AllTrim(M->E2_CCONT))=10 .AND. SubStr(M->E2_CCONT,1,3) == "211"
	If cNivel >= POSICIONE("SX3",2,"E2_DTRML","X3_NIVEL")
		If Empty(M->E2_DTRML)
	       ApMsgAlert("Quinzena da despesa não digitada.",'Atenção !!!')
	       xOK := .F.
		EndIf
	EndIf
EndIf
//
// Por Vitor Sbano - em 06/03/08
// Objetivo: validar o preenchimento dos campos E2_DIRF e E2_CODRET para Titulos com retencao IRRF
//
If M->E2_IRRF <> 0 .and. empty(M->E2_CODRET)             && se Vlr IRF <> 0 e Codigo Retencao nao preenchido
	       ApMsgAlert("Titulo com Retenção de IRRF - Informe DIRF = Sim e Codigo de Retencao devido",'Atenção !!!')
	       xOK := .F.
Endif
//


//DbSelectArea(vAlias)
RestArea(aArea)
Return(xOk) 