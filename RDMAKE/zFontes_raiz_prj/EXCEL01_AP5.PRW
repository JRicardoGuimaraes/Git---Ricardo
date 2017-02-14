#include "rwmake.ch"     
#INCLUDE "TOPCONN.ch"

User Function EXCEL01()  

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

  v_Emissao  := CTOD("  /  /  ")
  v_Emissao2 := CTOD("  /  /  ")

  v_Emissao := CTOD(Substr(PARAMIXB,1,2) + "/" + Substr(PARAMIXB,4,2) + "/" + Substr(PARAMIXB,7,4),"ddmmyyyy")    // DD/MM/AAAA
  v_Emissao2 := LastDay(v_Emissao)

  //dDtIni := Ctod("01/"+StrZero(mv_par01,2)+"/"+mv_par02,"ddmmyyyy")
  //dDtFim := LastDay(dDtIni)


  cUO := ""

  // Fora Grupo
  // Grupo GEFCO
  // Grupo PSA

  NQUANTRDVM := 0
  NQUANTILI := 0
  NQUANTRML := 0
  NQUANTRMA := 0
  NQUANT := 0

/*  
cQuery := ""
V_Se1  := RETSQLNAME("SE1")
xTotal :=0

cQuery = "SELECT A.E1_FILIAL ,A.E1_NUM ,A.E1_PREFIXO ,A.E1_CCONT ,A.E1_CLIENTE ,A.E1_LOJA ,A.E1_EMISSAO ,A.E1_VALOR"
cQuery += " FROM "+V_Se1+" AS A"
cQuery += " WHERE A.E1_EMISSAO >=" + "'"+DTOS(v_Emissao)+"'" +  " AND "
cQuery += " A.E1_EMISSAO <=" + "'"+DTOS(v_Emissao2)+"'" +  " AND "
cQuery += " A.E1_TIPO <> 'FAT' AND"
cQuery += " A.D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY A.E1_EMISSAO "

//cQuery := ChangeQuery(cQuery)		                   
//MEMOWRIT("GEFCTB06.SQL",cQuery)
//TCQuery cQuery ALIAS "TRB" New     

TcQuery cQuery ALIAS "XLS" NEW

dbSelectArea("XLS")
//dbSetOrder(1)
dbGoTop()

*/  

  DBSELECTAREA("SE1")
  //DBSETORDER(6)
  DBGOTOP()
  //DBSEEK("01"+v_Emissao,.T.)

     //While !Eof() 
     While !Eof() //.And. SE1->E1_EMISSAO >= v_Emissao .And. SE1->E1_EMISSAO <= v_Emissao2
     //While !Eof() //.And. SE1->E1_EMISSAO >= v_Emissao .And. SE1->E1_EMISSAO <= v_Emissao2

	  If SE1->E1_EMISSAO < v_Emissao .Or. SE1->E1_EMISSAO > v_Emissao2
	     DbSkip()
	     Loop
	  Endif
	        
         //If SE1->E1_PREFIXO == "FAT" .And. SE1->E1_TIPO == "FAT"
         //   DbSkip()
         //   Loop
         //Endif
         //  NQUANT := 2                                        
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
        
        dbSelectArea("SE1")
        DBSKIP()

     EndDo

//Return(v_Emissao2)
Return(NQUANT)