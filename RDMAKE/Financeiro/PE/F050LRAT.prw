/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  F050LRAT  ºAutor  ³    Marcos Furtado   º Data ³  24/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada executado na validação da linha da digita- ±±
±±º          ³ ção do rateio, quando é utilizado o SIGACON().             º±±
±±º          ³ Logo não funciona aqui e sim o  F050LRCT()                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                             

***************************************************
// => VER PONTO DE ENTRADA F050LRCT()
***************************************************

User Function F050LRAT()
lOCAL aArea := GetArea()
Local lRet  := .T.          
/*If (Empty(GdFieldGet("CTJ_DEBITO")) .And. Empty(GdFieldGet("CTJ_CREDIT"))) .Or. ;
   (Empty(GdFieldGet("CTJ_CCD")) .And. Empty(GdFieldGet("CTJ_CCC"))) .Or. ;
   Empty(GdFieldGet("CTJ_HIST")) 
	lRet  := .F.   
	MsgInfo("Todas as Informações devem ser preenchidas!","Rateio CC - CP - F050LRAT")
EndIF                                                                      */
RestArea(aArea)
return(lRet)
                        
/*User Function F050RAT()
lOCAL aArea := GetArea()
Local lRet  := .T.

MsgInfo("Entrei","Rateio CC - CP - F050RAT")

FOR N:=1 TO LEN(aCOLS)
	If (Empty(GdFieldGet("CTJ_DEBITO")) .And. Empty(GdFieldGet("CTJ_CREDIT"))) .Or. ;
	   (Empty(GdFieldGet("CTJ_CCD")) .And. Empty(GdFieldGet("CTJ_CCC"))) .Or. ;
	   Empty(GdFieldGet("CTJ_HIST")) 
		lRet  := .F.   
		MsgInfo("Todas as Informações devem ser preenchidas!","Rateio CC - CP")
	EndIF                                                                      
NEXT N


RestArea(aArea)

return(lRet)*/
