#include "rwmake.ch"     

User Function EXCEL07()  

SetPrvt("V_PRODUTO,V_PRODUTO1,V_PRODUTO2,V_DT_DE,V_DT_ATE,PEDIDO")
SetPrvt("PEDIDO1,PEDIDO2,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Excel01  ³ Autor ³ Saulo Muniz/Fabio     ³ Data ³ 29.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa p/ gerar cal. da qtde. na planilha de logistica   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

  // Fora Grupo
  // Grupo GEFCO
  // Grupo PSA

   v_Emissao := CTOD(Substr(PARAMIXB,1,2) + "/" + Substr(PARAMIXB,4,2) + "/" + Substr(PARAMIXB,7,4),"ddmmyyyy")    // DD/MM/AAAA
   v_Emissao2 := LastDay(v_Emissao)
   cUO := ""

  NQUANTRDVM := 0
  NQUANTILI := 0
  NQUANTRML := 0
  NQUANTRMA := 0
  NQUANT := 0
  NCAT1  := 0
  NCAT2  := 0
  NCAT3  := 0
  cTpVen := ""  

  DBSELECTAREA("SE1")
  //DBSETORDER(6)
  DBGOTOP()
  //DBSEEK("01"+v_Emissao,.T.)

     While !Eof() 

	  If SE1->E1_EMISSAO < v_Emissao .Or. SE1->E1_EMISSAO > v_Emissao2
	     DbSkip()
	     Loop
	  Endif
                                                 
         DBSELECTAREA("SA1")
     	 DBSETORDER(1)
    	 DBGOTOP()
	     DBSEEK(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
         
         cTpVen := SA1->A1_GEFCAT1         

         DBSELECTAREA("SE1")       
         
         If cTpVen == "1" 
  	          NCAT1++
         ElseIF cTpVen == "2"
		      NCAT2++
         ElseIF cTpVen == "3"		    
 		      NCAT3++
         Endif
         
         DBSKIP()

     EndDo

                                
Return(NCAT2)