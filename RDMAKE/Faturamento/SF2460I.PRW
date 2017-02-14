#include "rwmake.ch"        

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SF2460I  ³ Autor ³ Saulo Muniz           ³ Data ³ 18.10.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ P.E. Gravar dados adicionais do pedido                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Utilizacao³ Especifico para Gefco                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SF2460I()     
Local _aArea := GetArea()
       
dbselectarea("SE1")
dbsetorder(1)
dbseek(xfilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC)
      
If !Eof()
      
    Do While SE1->E1_FILIAL==SF2->F2_FILIAL .And.;
             SE1->E1_CLIENTE==SF2->F2_CLIENTE .and. SE1->E1_LOJA==SF2->F2_LOJA .and.;
             SE1->E1_PREFIXO==SF2->F2_PREFIXO .and. SE1->E1_NUM ==SF2->F2_DOC
             
             //MsgInfo("Gravando ... ")
             
             If SF2->F2_TIPO == "N" // Normais
 
                dbselectarea("SE1")
                Reclock("SE1",.F.)
                // Por: J Ricardo - Em: 26/12/2007 - Gravar grupo de cliente
                SE1->E1_GRPCLI  := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_GRUPO")
				SE1->E1_TPDESP  := SC5->C5_TPDESP
				SE1->E1_REFGEF  := SC5->C5_REFGEFC
				SE1->E1_CCPSA   := SC5->C5_CCUSPSA
				SE1->E1_OIPSA   := SC5->C5_OIPSA
				SE1->E1_CCONT   := SC5->C5_CCUSTO
				SE1->E1_CTAPSA  := SC5->C5_CTAPSA
         		SE1->E1_OCORREN := "01"				
         		
   				// Por: Ricardo Guimaraes - Em: 17/03/2014 - Objetivo: Informacoes MAN 		
				SE1->E1_TPCAR  := SC5->C5_TPCAR
				SE1->E1_NUMCVA := SC5->C5_NUMCVA
				SE1->E1_COLMON := SC5->C5_COLMON
                msUnlock() 
             
             Endif
             
             dbselectarea("SE1")
             dbSkip()
         
    Enddo
               
Endif
	
RestArea(_aArea)
Return