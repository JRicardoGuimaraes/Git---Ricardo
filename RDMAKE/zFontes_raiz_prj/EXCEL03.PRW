#include "rwmake.ch"     

User Function EXCEL03()  

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

   v_Emissao := CTOD(Substr(PARAMIXB,1,2) + "/" + Substr(PARAMIXB,4,2) + "/" + Substr(PARAMIXB,7,4),"ddmmyyyy")    // DD/MM/AAAA
   v_Emissao2 := LastDay(v_Emissao)
   cParamUO := Substr(PARAMIXB,11,2)
   cUO := ""

  NQUANTRDVM := 0
  NQUANTILI := 0
  NQUANTRML := 0
  NQUANTRMA := 0
  NQUANT := 0
  nRet   := 0

  DBSELECTAREA("SE1")
  //DBSETORDER(6)
  DBGOTOP()
  //DBSEEK("01"+v_Emissao,.T.)

     While !Eof() .And. SE1->E1_EMISSAO >= v_Emissao .And. SE1->E1_EMISSAO <= v_Emissao2

	  //If SE1->E1_EMISSAO < v_Emissao .Or. SE1->E1_EMISSAO > v_Emissao2
	  //   DbSkip()
	  //   Loop
	  //Endif                                                 
                                                 
             NQUANT++
         
         cUO := SUBSTRING(SE1->E1_CCONT,2,2)         
       
         If cUO == "01" 
  	          NQUANTRDVM++
         ElseIF cUO == "11"
		      NQUANTRML++
         ElseIF cUO == "21"		    
 		      NQUANTILI++
		 ElseIF cUO == "22" 
    	      NQUANTRMA++
		 ElseIF cUO == "23"  	    
    	      NQUANTRMA++

         Endif
         
        DBSKIP()

     EndDo
/*
 Do case
    
    case cParamUO == "01"
         nRet := NQUANTRDVM    
    case cParamUO == "11"
         nRet := NQUANTRML    
    case cParamUO == "21"
         nRet := NQUANTILI    
    case cParamUO == "22"
         nRet := NQUANTRMA
    case cParamUO == "23"
         nRet := NQUANTRMA
 EndCase
                                
Return(nRet)
*/

//Return(DTOC(v_Emissao))
Return(NQUANTRML)

