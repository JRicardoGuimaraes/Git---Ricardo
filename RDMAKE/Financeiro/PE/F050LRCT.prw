/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  F050LRCT  ºAutor  ³    Marcos Furtado   º Data ³  24/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada executado na validação da linha da digita- ±±
±±º          ³ ção do rateio, quando é utilizado o SIGACTB().             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F050LRCT()
lOCAL aArea := GetArea()
Local lRet  := .T.         

If (( Empty(TMP->CTJ_DEBITO) .And. Empty(TMP->CTJ_CREDIT) ) .Or. ;
   ( Empty(TMP->CTJ_CCD)    .And. Empty(TMP->CTJ_CCC)    ) .Or. ;
   Empty(TMP->CTJ_HIST)) .And. !TMP->CTJ_FLAG

	lRet  := .F.   
	MsgInfo("Todas as Informações devem ser preenchidas!","Rateio CC - CP - F050LRCT")
Else
	If INCLUI .OR. ALTERA
		If !TMP->CTJ_FLAG
			lRet:=u_vldCntCC(TMP->CTJ_CCD,TMP->CTJ_DEBITO)
			If lRet
				lRet:=u_vldCntCC(TMP->CTJ_CCC,TMP->CTJ_CREDIT)
			EndIf
		EndIf
	EndIf
EndIF                                                                      

RestArea(aArea)

return(lRet)
/*                
*--------------------------*                       
User Function F050RAT()     
*--------------------------*

lOCAL aArea := GetArea()
Local lRet  := .T.
Local nRecTmp1                

DbSelectArea("TMP")
nRecTmp1 := RecNo("TMP")
DbGoTop()        
While !Eof()
	If (( Empty(TMP->CTJ_DEBITO) .And. Empty(TMP->CTJ_CREDIT) ) .Or. ;
	   ( Empty(TMP->CTJ_CCD)    .And. Empty(TMP->CTJ_CCC)    ) .Or. ;
	   Empty(TMP->CTJ_HIST))  .And. !TMP->CTJ_FLAG
	
		lRet  := .F.   
		MsgInfo("Todas as Informações devem ser preenchidas!","Rateio CC - CP - F050RAT")
		Exit
	Else
		If INCLUI .OR. ALTERA
			lRet:=u_vldCntCC(TMP->CTJ_CCD,TMP->CTJ_DEBITO)
			If !lRet
				exit
			EndIf
			lRet:=u_vldCntCC(TMP->CTJ_CCC,TMP->CTJ_CREDIT)
			If !lRet
				exit
			EndIf
		EndIf
	EndIF                         
	DbSelectArea("TMP")	                                             
	DbSkip()
End
DbSelectArea("TMP")
DbGoto(nRecTmp)

RestArea(aArea)
                        
// Por: J Ricardo - Em: 07/05/2008 - Validar valor do Rateio
nValorRat := 0

DbSelectArea("TMP")
nRecTmp1 := RecNo("TMP")
DbGoTop()        
While !Eof()

	nValorRat += TMP->CTJ_VALOR

	DbSelectArea("TMP")	                                             
	DbSkip()
End
DbSelectArea("TMP")
DbGoto(nRecTmp)

RestArea(aArea)

IF Str( nValorRat,17,2 ) != IIF((Upper(AllTrim(FunName())) == "FINA050" .OR. Upper(AllTrim(FunName())) == "FINA750") .AND. INCLUI,;
	Str(IIF(mv_par06==1,;
	M->(E2_VALOR+E2_IRRF+E2_ISS+E2_RETENC+E2_SEST+E2_PIS+E2_COFINS+E2_CSLL)+M->E2_INSS,;
	M->E2_VALOR),17,2 ),0)
	Help( " ", 1, "FA050RATEI")
	lRet := .F.
Endif

return(lRet)
*/