#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GEFR077  ³ Autor ³ Ricardo Guimarães     ³ Data ³06/02/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conhecimento de Transporte Rodoviario de Carga             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GEFR077                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO - GEFCO - Imprmir CTRC Gefco TLA                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*---------------------------*
User Function GEFR077()      
*---------------------------*
Local cQuery2	:= ""
Local cQuery3	:= ""
Local nFretePeso:=0
Local nFreteVlr :=0
Local nSetCat	:=0
Local nPedagio  :=0
Local nGris     :=0
Local nItr	  	:=0
Local nSufra	:=0
Local nDespacho :=0
Local nOutros   :=0
Local cNotas1	:=""
Local cNotas2   :=""
Local cNotas3   :=""
Local cQuery	:= ""
Local cCodFis	:= ""
Local cTexto	:= ""   
Local nLinobs   := 1
Local lPulaLin  := .F.
Local _lManual  := .F.
Local _lImp132  := .F.
Local _cTransp  := ""
Local _cLJTra	:= ""

Private cString	:= GetNextAlias()        
Private aObserv	:= Array(7)
Private nAliqiss:= 0
Private nAliqIcm:= 0
Private cSubSt	:= ""
Private nLinobs := 1

cString := GetNextAlias()
cQuery	:= " SELECT DT6_FILDOC        FILDOC, "
cQuery	+= "       DT6.DT6_DOC        DOC, "
cQuery	+= "       DT6.DT6_SERIE      SERIE, "
cQuery	+= "       DT6.DT6_DATEMI     DATEMI, "
cQuery	+= "       DT6.DT6_VALTOT     VALTOT, "
cQuery	+= "       DT6.DT6_TIPFRE     TIPFRE, "
cQuery	+= "       DT6.DT6_CLIREM     CLIREM, "
cQuery	+= "       DT6.DT6_LOJREM     LOJREM, "
cQuery	+= "       DT6.DT6_CLIDES     CLIDES, "
cQuery	+= "       DT6.DT6_LOJDES     LOJDES, "
cQuery	+= "       DT6.DT6_CLICON     CLICON, "
cQuery	+= "       DT6.DT6_LOJCON     LOJCON, "
cQuery	+= "       DT6.DT6_CLIDPC     CLIDPC, "
cQuery	+= "       DT6.DT6_LOJDPC     LOJDPC, "
cQuery	+= "       DT6.DT6_TABFRE     TABFRE, "
cQuery	+= "       DT6.DT6_VOLORI     VOLORI, "
cQuery	+= "       DT6.DT6_PESO       PESO, "
cQuery	+= "       DT6.DT6_PESOM3     PESOM3, "
cQuery	+= "       DT6.DT6_METRO3     METRO3, "
cQuery	+= "       DT6.DT6_VALMER     VALMER, "
cQuery	+= "       DT6.DT6_LOTNFC     LOTNFC, "
cQuery	+= "       DT6.DT6_CCUSTO     CCUSTO, "
cQuery	+= "       DT6.DT6_CCONT      CCONT, "
cQuery	+= "       DT6.DT6_OI         ORDINT, "
cQuery	+= "       DT6.DT6_CONTA      CONTA, "
cQuery	+= "       DT6.DT6_FILORI     FILORI, "
cQuery	+= "       DT6.DT6_FIMP       FLAGIMP, "
cQuery	+= "       DT6.DT6_CDRORI     CDRORI, "
cQuery	+= "       DT6.DT6_CODMSG     CODMSG, "
cQuery	+= "       DT6.DT6_DOCTMS     DOCTMS, "
cQuery	+= "       DT6.DT6_VALFRE     VALFRE, "


cQuery	+= "       SF2.F2_BASEICM     BASEICM, "
cQuery	+= "       SF2.F2_VALICM      VALICM, "
cQuery	+= "       SF2.F2_ICMSRET     ICMRET, "
cQuery	+= "       SF2.F2_BRICMS      BRICMS, " 
cQuery	+= "       SF2.F2_BASEISS     BASEISS, "
cQuery	+= "       SF2.F2_VALISS      VALISS, "


cQuery	+= "       SA1A.A1_CGC        CGCREM, "
cQuery	+= "       SA1A.A1_NOME       NOMEREM, "
cQuery	+= "       SA1A.A1_INSCR      INSCREM, "
cQuery	+= "       SA1A.A1_END        ENDREM, "
cQuery	+= "       SA1A.A1_BAIRRO     BAIREM, "
cQuery	+= "       SA1A.A1_MUN        MUNREM, "
cQuery	+= "       SA1A.A1_CEP        CEPREM, "
cQuery	+= "       SA1A.A1_EST        ESTREM, "

cQuery	+= "       SA1B.A1_CGC        CGCDES, "
cQuery	+= "       SA1B.A1_NOME       NOMEDES, "
cQuery	+= "       SA1B.A1_INSCR      INSCDES, "
cQuery	+= "       SA1B.A1_END        ENDDES, "
cQuery	+= "       SA1B.A1_BAIRRO     BAIDES, "
cQuery	+= "       SA1B.A1_MUN        MUNDES, "
cQuery	+= "       SA1B.A1_CEP        CEPDES, "
cQuery	+= "       SA1B.A1_EST        ESTDES, "

cQuery	+= "       SA1C.A1_CGC        CGCCON, "
cQuery	+= "       SA1C.A1_NOME       NOMECON, "
cQuery	+= "       SA1C.A1_INSCR      INSCCON, "
cQuery	+= "       SA1C.A1_END        ENDCON, "
cQuery	+= "       SA1C.A1_BAIRRO     BAICON, "
cQuery	+= "       SA1C.A1_MUN        MUNCON, "
cQuery	+= "       SA1C.A1_CEP        CEPCON, "
cQuery	+= "       SA1C.A1_EST        ESTCON, "

cQuery	+= "       SA1D.A1_CGC        CGCDPC, "
cQuery	+= "       SA1D.A1_NOME       NOMEDPC, "
cQuery	+= "       SA1D.A1_INSCR      INSCDPC, "
cQuery	+= "       SA1D.A1_END        ENDDPC, "
cQuery	+= "       SA1D.A1_BAIRRO     BAIDPC, "
cQuery	+= "       SA1D.A1_MUN        MUNDPC, "
cQuery	+= "       SA1D.A1_CEP        CEPDPC, "
cQuery	+= "       SA1D.A1_EST        ESTDPC "

cQuery	+= " FROM "+retsqlname("DT6")+ " DT6 "

cQuery	+= " JOIN "+retsqlname("SF2")+ " SF2 ON F2_FILIAL = DT6_FILDOC "
cQuery	+= "  AND F2_DOC = DT6_DOC "
cQuery	+= "  AND F2_SERIE = DT6_SERIE "
cQuery	+= "  AND SF2.D_E_L_E_T_ = ' ' "

cQuery	+= " JOIN "+retsqlname("SA1")+ " SA1A ON SA1A.A1_COD = DT6_CLIREM "
cQuery	+= " AND SA1A.A1_LOJA = DT6_LOJREM "
cQuery	+= " AND SA1A.A1_FILIAL = '"+xFilial("SA1")+ "' "
cQuery	+= " AND SA1A.D_E_L_E_T_ = ' ' "

cQuery	+= " JOIN "+retsqlname("SA1")+ " SA1B ON SA1B.A1_COD = DT6_CLIDES "
cQuery	+= " AND SA1B.A1_LOJA = DT6_LOJDES "
cQuery	+= " AND SA1B.A1_FILIAL = '"+xFilial("SA1")+ "' "
cQuery	+= " AND SA1B.D_E_L_E_T_ = ' ' "

cQuery	+= " LEFT JOIN "+retsqlname("SA1")+ " SA1C ON SA1C.A1_COD = DT6_CLICON "
cQuery	+= " AND SA1C.A1_LOJA = DT6_LOJCON "
cQuery	+= " AND SA1C.A1_FILIAL = '"+xFilial("SA1")+ "' "
cQuery	+= " AND SA1C.D_E_L_E_T_ = ' ' "

cQuery	+= " LEFT JOIN "+retsqlname("SA1")+ " SA1D ON SA1D.A1_COD = DT6_CLIDPC "
cQuery	+= " AND SA1D.A1_LOJA = DT6_LOJDPC "
cQuery	+= " AND SA1D.A1_FILIAL = '"+xFilial("SA1")+ "' "
cQuery	+= " AND SA1D.D_E_L_E_T_ = ' ' " 

cQuery	+= " WHERE DT6_FILDOC = '" + cFilAnt + "' "
cQuery	+= "  AND DT6_LOTNFC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery	+= "  AND DT6_DOC BETWEEN    '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery	+= "  AND DT6_SERIE BETWEEN  '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
//cQuery	+= "  AND DT6_PREFIX <> 'CTR' "  //Só filtra TLA - comentado para teste
cQuery	+= "  AND SUBSTRING(DT6_CCUSTO,1,3) = '101'"  // Só filtra TLA

If MV_PAR07 = 1
	cQuery	+= "  AND DT6.DT6_FIMP = '0' "                                  
ElseIf MV_PAR07 = 2                           
	cQuery	+= "  AND DT6.DT6_FIMP = '1' "
EndIf

cQuery	+= "  AND DT6.D_E_L_E_T_ = ' ' "

If MV_PAR08 = 1
	cQuery	+= " ORDER BY DT6_FILDOC, DT6.DT6_DOC, DT6.DT6_SERIE"
Else                                                             
	cQuery	+= " ORDER BY DT6_FILDOC, SA1B.A1_EST, SA1B.A1_MUN, SA1B.A1_CGC"
EndIf	

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cString,.T.,.T.)

DbSelectArea(cString)
(cString)->(DbGoTop())

If Eof()  
	MsgInfo("Não há dados a serem impressos para os parâmetros informados. Favor verificar os parâmetros.","Informação")
	DbSelectArea(cString) ; (cString)->(dbCloseArea())
	
	If aReturn[5] == 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()	
	Return
EndIf

If cFilAnt = "03"
	_lImp132  := MsgYesNo("Os CTRs serão impressos na impressora grande (132 col.) ?","Pergunta")
EndIf	

dbSelectArea("SZ8") ; dbSetOrder(2) // Lote + CTRC + Série

DbSelectArea(cString)

@ nLin, 000 Psay Chr(027)+Chr(067)+Chr(032) 
@ nLin, 000 Psay Chr(027)+"M"
While (cString)->(!Eof()) 

	DbSelectArea("SD2")
	DbSetOrder(3)   
	If  DbSeek((cString)->FILDOC+PadL((cString)->DOC,(TamSx3("D2_DOC")[1]))+(cString)->SERIE)
		cCodFis := SD2->D2_CF	

		While !SD2->(Eof()) .AND. SD2->D2_FILIAL = (cString)->FILDOC .AND. SD2->D2_DOC = (cString)->DOC .AND. SD2->D2_SERIE = (cString)->SERIE
			If SD2->D2_PICM > 0 .OR. SD2->D2_ALIQISS > 0
				cCodFis := SD2->D2_CF
				nAliqIcm := SD2->D2_PICM
				nAliqISS := SD2->D2_ALIQISS
				DbSelectArea("SF4")
				DbSetOrder(1)
				If DbSeek(xFilial("SF4")+SD2->D2_TES)
					cTEXTO := SF4->F4_TEXTO
					cSubSt := SF4->F4_ICMSST
				EndIf
			EndIf	
			SD2->(dbSkip())
		End	
    EndIf

	// Posiciono o registro na tabela de interface
	SZ8->(dbSeek(xFilial("SZ8")+(cString)->LOTNFC))
            
	nLin := 2

	// @ nLin, 055 PSay POSICIONE("SD2",3, dbSeek(xFilial("SD2")+(cString)->DOC+(cString)->SERIE+(cString)->CLICON+(cString)->LOJCON+GETMV("MV_XPROTLA"),"D2_CF") // Natureza de Operação
	// @ nLin, 055 PSay Transform(cCodFis,POSICIONE("SD2",3, dbSeek(xFilial("SD2")+(cString)->DOC+(cString)->SERIE),"D2_CF"),"@R 9.999") // Natureza de Operação
	@ nLin, 055 PSay Transform(cCodFis,"@R 9.999") // Natureza de Operação	
	@ nLin, 075 PSay SZ8->Z8_RNTC		//RNTC
	nLin++
	@ nLin, 055 PSay SubStr((cString)->DATEMI,7,2)+"/"+SubStr((cString)->DATEMI,5,2)+"/"+SubStr((cString)->DATEMI,1,4)		//Data Emissao 

	nLin +=2
	
    DbSelectArea("DUY")
    DbSetOrder(1)   
    If DbSeek(xFilial("DUY")+ (cString)->CDRORI)
    	@ nLin, 001 PSay DUY->DUY_DESCRI		//Local de Coleta
    EndIf

    If !Empty((cString)->CLIDPC)
		@ nLin, 032 PSay (cString)->MUNDPC		//Local de Entrega
	Else
		@ nLin, 032 PSay (cString)->MUNDES		//Local de Entrega
	EndIf
	//@ nLin, 078 PSay (cString)->TABFRE		//Tabela de Frete
	@ nLin, 075 PSay (cString)->DOC				//No. CTRC
	
	nLin++
	nLin++
	
	@ nLin, 008 Psay SubStr((cString)->NOMEREM,1,60)						//Nome Remetente
	nLin++
	@ nLin, 008 Psay SubStr((cString)->ENDREM,1,60)							//Endereco Remetente
	@ nLin, 060 Psay (cString)->MUNREM										//Municipio Remetente	
	@ nLin, 090 Psay (cString)->ESTREM										//Estado Remetente	
	nLin++
	@ nLin, 008 Psay Transform((cString)->CGCREM,"@R 99.999.999/9999-99")	//Cnpj Remetente
	@ nLin, 049 Psay Transform((cString)->INSCREM,"@R 999.999.999.999.9")		//I.E Remetente
	// @ nLin, 054 Psay (cString)->BAIREM									//Bairro Remetente
	// @ nLin, 085 Psay Transform((cString)->CEPREM,"@R 99999-999")			//CEP Remetente
	
	nLin+=2
	@ nLin, 008 Psay SubStr((cString)->NOMEDES,1,60)					//Nome Destinatario
	nLin++	
	@ nLin, 008 Psay SubStr((cString)->ENDDES,1,60)						//Endereco Destinatario
	@ nLin, 060 Psay (cString)->MUNDES									//Municipio Destinatario
	@ nLin, 090 Psay (cString)->ESTDES									//Estado Destinatario	
	nLin++
	@ nLin, 008 Psay Transform((cString)->CGCDES,"@R 99.999.999/9999-99")	//Cnpj Destinatario
	//@ nLin, 054 Psay (cString)->BAIDES										//Bairro Destinatario
	//@ nLin, 085 Psay Transform((cString)->CEPDES,"@R 99999-999")			//CEP Destinatario
	@ nLin, 049 Psay Transform((cString)->INSCDES,"@R 999.999.999.999.9")	//I.E Destinatario
	
	nLin += 2
	If !Empty((cString)->CLICON)   
	/*
		If !Empty((cString)->CLIDPC)
			@ nLin, 013 Psay "X"
			@ nLin, 006 Psay (cString)->NOMEDPC								//Nome Redespachante
			nLin++
			@ nLin, 006 Psay (cString)->ENDDPC								//Endereco Redespachante
			@ nLin, 073 Psay Transform((cString)->CGCDPC,"@R 99.999.999/9999-99")		//CNPJ Redespachante
			nLin++
			@ nLin, 008 Psay (cString)->MUNDPC								//Municipio Redespachante
			@ nLin, 050 Psay Transform((cString)->CEPDPC,"@R 99999-999")	//CEP Redespachante
			@ nLin, 068 Psay (cString)->ESTDPC								//Estado Redespachante
			@ nLin, 083 Psay Transform((cString)->INSCDPC,"@R 999.999.999.999")//I.E Redespachante
		Else
	*/	
			//@ nLin, 002 Psay "X"
			@ nLin, 008 Psay (cString)->NOMECON							//Nome Conignatario
			nLin++
			@ nLin, 008 Psay (cString)->ENDCON								//Endereco Conignatario
			@ nLin, 060 Psay (cString)->MUNCON								//Municipio Conignatario
			@ nLin, 090 Psay (cString)->ESTCON								//Estado Conignatario
			nLin++						
			@ nLin, 008 Psay Transform((cString)->CGCCON,"@R 99.999.999/9999-99")//CNPJ Conignatario
			@ nLin, 049 Psay Transform((cString)->INSCCON,"@R 999.999.999.999")//I.E Conignatario			
			nLin++

			//@ nLin, 050 Psay Transform((cString)->CEPCON,"@R 99999-999")	//CEP Conignatario

	 //	EndIf  
	EndIf                                                     
	
    If Empty((cString)->CLICON) .and. Empty((cString)->CLIDPC)
    	nLin := nLin + 3
    EndIf
    
    nLin += 2
	@ nLin, 084 PSay "X"		//Consignatário
	// TLA -> Consignatário
	/*
	If (cString)->TIPFRE ='1'
		@ nLin, 077 PSay "X"		//Frete CIF
	Else
		@ nLin, 085 PSay "X"		//Frete Fob
	EndIf                    
    */

	cQuery3:= "	SELECT 	DTC.DTC_FILDOC   FILDOC, "
	cQuery3+= "			DTC.DTC_DOC      DOC, "
	cQuery3+= "			DTC.DTC_SERIE    SERIE, "
	cQuery3+= "			DTC.DTC_CODOBS   CODOBS, "
	cQuery3+= "			DTC.DTC_CODPRO   CODPRO, "	
	cQuery3+= "			DTC.DTC_PESO     PESO,   "		
	cQuery3+= "			DTC.DTC_VALOR    VALOR, "		
	cQuery3+= "	   		DTC.DTC_NUMNFC   NUMNFC, "
	cQuery3+= "	   		DTC.DTC_TRANSP   TRANSP, "	
	cQuery3+= "	   		DTC.DTC_LJTRA    LJTRA "
	cQuery3+= "FROM "+retsqlname("DTC") + " DTC "
	cQuery3+= "WHERE DTC_FILDOC = '"+(cString)->FILDOC+"'"
	cQuery3+= "  AND DTC_DOC = '"+(cString)->DOC+"'"
	cQuery3+= "  AND DTC_SERIE  = '"+(cString)->SERIE+"'"
	cQuery3+= "  AND DTC.D_E_L_E_T_ = ' ' ORDER BY DTC.DTC_NUMNFC"
	cQuery3 := ChangeQuery(cQuery3)
	TCQUERY cQuery3 New Alias "QDTC"

	// Impressão de Item
    nLin += 2	
	dbSelectArea("SZ8") ; dbSetOrder(2) // Lote + CTRC + Série
	If SZ8->(dbSeek(xFilial("SZ8")+(cString)->LOTNFC))
		@ nLin, 001 Psay "1"  // Item
		@ nLin, 004 Psay PadR(SZ8->Z8_VIN,20,"")  // Chassi
		@ nLin, 029 Psay PadR(SZ8->Z8_DESCMOD,30,"") + AllTrim(SZ8->Z8_PESOVEI) + " KG"  // Modelo/Peso
		@ nLin, 069 Psay PadR(SZ8->Z8_NFCLI,09,"")  // Nota do Cliente
		@ nLin, 081 Psay Transform(SZ8->Z8_VALORNF,"@E 99,999,999.99") // Valor do Veículo
		_lManual := .F.
	Else
		dbSelectArea("QDTC")
		// Impressão CTRC Manual do TLA
		@ nLin, 001 Psay "1"  // Item
		@ nLin, 004 Psay PadR(QDTC->CODPRO,20,"")  // Produto
		// @ nLin, 029 Psay PadR(SZ8->Z8_DESCMOD,30,"") + AllTrim(SZ8->Z8_PESOVEI) + " KG"  // Modelo/Peso
		@ nLin, 029 Psay Transform(QDTC->PESO,"@E 99,999,999") + " KG"  // Modelo/Peso		
		@ nLin, 069 Psay PadR(QDTC->NUMNFC,09,"")  // Nota do Cliente
		@ nLin, 081 Psay Transform(QDTC->VALOR,"@E 99,999,999.99") // Valor do Veículo
		_lManual := .T.		
	EndIf

	// Pego a Transportadora
	_cTransp := QDTC->TRANSP
	_cLJTra  := QDTC->LJTRA
		
	// Imprime as Observações
	nLin := 35
		
	AFill(aObserv, Space(80)) 
	While  !QDTC->(EOF())
	    If Len(cNotas1)+Len(Rtrim(QDTC->NUMNFC)+" ")>82 
	       If Len(cNotas2)+Len(Rtrim(QDTC->NUMNFC)+" ")>82
	          cNotas3:="/"+Rtrim(QDTC->NUMNFC)
	       Else
	          cNotas2 += Rtrim(QDTC->NUMNFC) + " "
	       Endif
	    Else
		   cNotas1 += Rtrim(QDTC->NUMNFC) + " "
		Endif   
		If Empty(aObserv[3])
		   aObserv[3]:= StrTran(MsMM(AllTrim(QDTC ->CODOBS),120),Chr(13)," ") 
		   aObserv[3]:= StrTran(aObserv[3], Chr(10),"")
		Endif   
		QDTC->(Dbskip())
	End
	
	QDTC->(DbCloseArea())	
	
	/*
	If !Empty(cNotas3)
	   cNotas2+=cNotas3
	Endif   
	If !Empty(cNotas2)
	   nLin+=1      
	   @ nLin, 007 PSay SubStr(cNotas1,0,121)
	   nLin+=1
	   @ nLin, 007 PSay SubStr(cNotas2,0,121)
	Else    
	   nLin+=2
	   @ nLin, 007 PSay SubStr(cNotas1,0,121)
	Endif   
	cNotas1 := "" 
	cNotas2 := ""
	cNotas3 := ""
	*/ 
	
	
	////////////////Busca Observacoes/////////////////////
	dbSelectArea(cString)
	aObserv[1]:= StrTran(MsMM(AllTrim((cString)->CODMSG),80),Chr(13)," ")
	aObserv[1]:= StrTran(aObserv[1], Chr(10),"")
	If !Empty((cString)->CCUSTO)
		aObserv[2]:= "C.CUSTO:"+AllTrim((cString)->CCUSTO)+"\ "
	EndIf
	If !Empty((cString)->CCONT)
		aObserv[2]+= "C.CUSTO PSA:"+AllTrim((cString)->CCONT)+"\ "
	EndIf
	If !Empty((cString)->CONTA)
		aObserv[2]+= "CONTA DESP.:"+AllTrim((cString)->CONTA)+"\ " 
	EndIf                                             
	If !Empty((cString)->ORDINT)
		aObserv[2]+= "ORD.INTERNA:"+Alltrim((cString)->ORDINT)+"\ "
	EndIf
	
    If cSubst="1"
		aObserv[4]:= "SUBSTITUICAO TRIBUTARIA - BASE ICMS RETIDO : "+Transform((cString)->BRICMS,"@E 99,999,999.99")+"  - ICMS RETIDO : "+Transform((cString)->ICMRET,"@E 99,999,999.99")
	Else
		// Por: Ricardo - Em: 05/01/2012
		// Verifico se o cliente emitente é a PSA, caso seja, imprimo a msg. abaixo
//		If (cString)->CLIREM + (cString)->LOJREM $ "90136500" // AllTrim(GetMV("MV_GEF003"))
//		If AllTrim((cString)->CLIREM) = "901365" .AND. AllTrim((cString)->ESTREM) = "RJ"
//		Alterado por: Ricardo - Em: 18/06/2012 - Mudança de regra		
//		If AllTrim((cString)->CLICON) = "901365" .AND. AllTrim((cString)->ESTCON) = "RJ"		
		If (cString)->CLICON + (cString)->LOJCON = "90136500" .AND. (cString)->CLIREM + (cString)->LOJREM = "90136500"
			aObserv[4]:= "ICMS DIFERIDO CONFORME LEI RJ/6.108/11"
		EndIf
	EndIF
	If (cString)->DOCTMS = "8" 
		aObserv[5]:= "CTRC COMPLEMENTAR"
	EndIf

    ///////////////////////////////////////////////////////
	nLin++
	nLinObs  := 1
	lPulaLin := .T.
	If !Empty(aObserv[5])  // 1a Linha
	   @ nLin, 000 Psay AllTrim(SubStr(aObserv[5],0,58))  // ctrc complementar
	   nLinObs++		
	   nLin++
	   //ImpBasCalc()
	   //nLin++                               
	Else	
       If !Empty(aObserv[3])
	   		@ nLin, 000 Psay AllTrim(SubStr(aObserv[3],1,40))   // Mensagem DTC          	
	    	nLin++ 
	    	nLinObs++
	    	lPulaLin := .F.	   
	    	If !Empty(AllTrim(SubStr(aObserv[3],41,40))) .and. nLinObs<=3
	      		@ nLin, 000 Psay AllTrim(SubStr(aObserv[3],41,40))   // Mensagem DTC 
	   	  		If nLinObs=2 
	   	  			// nLin++
             		//ImpBasCalc()
          		Endif       
	      		nLinObs++          
	      		If !Empty(AllTrim(SubStr(aObserv[3],81,40))) .And. nLinObs<=3
	         		@ nLin, 000 Psay AllTrim(SubStr(aObserv[3],81,40))   // Mensagem DTC
	         		nLin+=1
	         		nLinObs++
	         	Else
	         		nLin+=1
	      		Endif
	      	ELSE
	      		If nLinObs=2 
	      			// nLin++ 
					@ nLin, 000 Psay AllTrim(SubStr(aObserv[4],1,40))
             		//ImpBasCalc()
             		nLin+=1  
	      		   nLinObs++   
          		Endif     
           Endif  
	   Endif
	Endif      
	If nLinObs = 1  // Nao imprimiu nenhuma linha de observacao, tem que imprimir a base de calculo
	   If lPulaLin
	      nLin++
	   Endif      
	   @ nLin, 000 Psay AllTrim(SubStr(aObserv[4],1,40))
	   //ImpBasCalc()
	   nLin+=1
	   nLinObs++
	Endif            
	   
	//@ nLin, 063 Psay  ""//"Tipo de Servico" 
	
	@ nLin, 000 Psay AllTrim(SubStr(aObserv[2],0,58))  // Centro de custo	
	nLin += 4
	
	// Imprime Seguradora
	@ nLin, 001 Psay  PadR(SZ8->Z8_SEGURAD,30,"")
	@ nLin, 035 Psay  PadR(SZ8->Z8_RESPSEG,10,"")
	@ nLin, 047 Psay  PadR(SZ8->Z8_APOLICE,20,"")
	@ nLin, 080 Psay  PadR(SZ8->Z8_AVERB  ,20,"")
		
	cQuery2:= "	SELECT 	DT8.DT8_FILDOC   FILDOC, "
	cQuery2+= "			DT8.DT8_DOC      DOC, "
	cQuery2+= "			DT8.DT8_SERIE    SERIE, "
	cQuery2+= "	   		DT8.DT8_VALTOT   VALTOT, "
	cQuery2+= "	  		DT3.DT3_COLIMP   COLIMP "
		
	cQuery2+= "FROM "+retsqlname("DT8") + " DT8 "
	
	cQuery2+= "JOIN "+retsqlname("DT3") + " DT3 ON DT3_CODPAS = DT8_CODPAS "
	cQuery2+= " AND DT3_FILIAL = '"+xFilial("DT3")+"'"
	cQuery2+= " AND DT3.D_E_L_E_T_ = ' ' "
	
	cQuery2+= "WHERE DT8_FILDOC = '"+(cString)->FILDOC+"'"
	cQuery2+= "  AND DT8_DOC = '"+(cString)->DOC+"'"
	cQuery2+= "  AND DT8_SERIE  = '"+(cString)->SERIE+"'"
	cQuery2+= "	 AND DT8_CODPAS <>'TF' "
	cQuery2+= "  AND DT8_FILIAL = '"+xFilial("DT8")+"'"
	cQuery2+= "  AND DT8.D_E_L_E_T_ = ' ' "
	cQuery2 := ChangeQuery(cQuery2)
	TCQUERY cQuery2 New Alias "QDT8"
		
	nFretePeso	:=0 //Coluna de Impressao 1
	nFreteVlr 	:=0 //Coluna de Impressao 2
	nSetCat		:=0 //Coluna de Impressao 3
	nPedagio  	:=0 //Coluna de Impressao 4
	nGris     	:=0 //Coluna de Impressao 5
	nItr	  	:=0 //Coluna de Impressao 6
	nSufra		:=0 //Coluna de Impressao 7
	nDespacho 	:=0 //Coluna de Impressao 8
	nOutros   	:=0 //Coluna de Impressao 9
		
	While  !QDT8->(EOF())
		If   QDT8->COLIMP=='1'
			nFretePeso+=QDT8->VALTOT
		ElseIf   QDT8->COLIMP=='2'
			nFreteVlr+=QDT8->VALTOT
		ElseIf   QDT8->COLIMP=='3'
			nSetCat+=QDT8->VALTOT
		ElseIf   QDT8->COLIMP=='4'
			nPedagio+=QDT8->VALTOT
		ElseIf   QDT8->COLIMP=='5'
			nGris+=QDT8->VALTOT
		ElseIf   QDT8->COLIMP=='6'
			nItr+=QDT8->VALTOT
		ElseIf   QDT8->COLIMP=='7'
			nSufra+=QDT8->VALTOT
		ElseIf   QDT8->COLIMP=='8'
			nDespacho+=QDT8->VALTOT
		ElseIf   QDT8->COLIMP=='9'
			nOutros+=QDT8->VALTOT
		EndIf
		QDT8->(Dbskip())
	Enddo        
	
	// Peso/Frete
	If _lImp132
		nLin+=11
	Else
		nLin+=10
	EndIf	
//	@ nLin, 000 Psay Transform((nFretePeso),"@E 99,999.99") + " KG"
	@ nLin, 000 Psay Transform((cString)->PESO,"@E 99,999") + " KG"	
	@ nLin, 019 Psay Transform((nFreteVlr),"@E 9,999.99")
//	@ nLin, 019 Psay Transform((cString)->VALFRE,"@E 9,999.99")
	@ nLin, 035 Psay Transform((nSetCat),"@E 9,999.99")
	@ nLin, 052 Psay Transform((nPedagio),"@E 9,999.99")
//	@ nLin, 042 Psay Transform((nGris),"@E 9,999.99")
//	@ nLin, 052 Psay Transform((nItr),"@E 9999.99")
//	@ nLin, 062 Psay Transform((nSufra),"@E 9999.99")
	@ nLin, 068 Psay Transform((nOutros + nDespacho),"@E 9,999.99")
	@ nLin, 085 Psay Transform((cString)->VALTOT,"@E 999,999.99")
	QDT8->(DBCLOSEAREA())
	
	dbSelectArea(cString)
	nLin+=2
	
    // Imprime Base Cálculo
	IF (cString)->VALISS<>0
	   	@ nLin, 054 Psay Transform((cString)->BASEISS,"@E 99,999,999.99")
		@ nLin, 069 Psay Transform(nAliqISS,"@E 999,99")+" %"
		@ nLin, 085 Psay Transform((cString)->VALISS,"@E 99,999,999.99") 
	Else
		If cSubSt <> "1"
		   // @ nLin, 000 Psay AllTrim(SubStr(aObserv[4],1,40))  // Substituicao Tributaria OU Diferido conforme lei RJ/6108/11	
			@ nLin, 054 Psay Transform((cString)->BASEICM,"@E 999,999.99")
			@ nLin, 069 Psay Transform(nAliqIcm,"@E 999,99")+" %"
			@ nLin, 085 Psay Transform((cString)->VALICM,"@E 999,999.99")
		EndIf
	EndIf		

	nLin+=3
	
	
	// If !_lManual  // CTRC Automática, originado da SZ8
	   //	@ nLin, 010 Psay POSICIONE("SA2",3,xFilial("SA2")+SZ8->Z8_CNPJTRA,"A2_NOME")
	// EndIf	
    
	// Por: Ricardo - Em: 21/02/2013 - Motivo: Os CTRC´s manual passou a gerar Compra de Frete
	@ nLin, 010 Psay POSICIONE("SA2",1,xFilial("SA2")+_cTransp + _cLJTra,"A2_NOME")
	
	/*
	@ nLin, 000 Psay "DIVERSOS"
	@ nLin, 019 Psay (cString)->VOLORI
	@ nLin, 027 Psay "VOLUMES"       
	@ nLin, 038 Psay Transform((cString)->PESO,"@E 999,999.999")
	@ nLin, 051 Psay Transform((cString)->PESOM3,"@E 999,999.999")
	@ nLin, 062 Psay Transform((cString)->METRO3,"@E 999,999.999")
	@ nLin, 080 Psay Transform((cString)->VALMER,"@E 99,999,999.99")
	*/
	aObserv[1] := ""
	aObserv[2] := ""
	aObserv[3] := ""
	aObserv[4] := ""
	aObserv[5] := ""
	
	DT6->(Dbsetorder(1))
	If DT6->(Dbseek(xFilial("DT6")+(cString)->FILDOC+(cString)->DOC+(cString)->SERIE))
	   Reclock("DT6",.F.) 
	   DT6->DT6_FIMP := "1"
	   DT6->(MsUnLock())
	Endif                
	
	dbSelectArea(cString)
    nLin+=4	    
    @ nLin, 065 Psay  "Lote :"+(cString)->(LOTNFC)
	@ nLin, 080 Psay  "CTRC: " + (cString)->DOC
	nLin++
	@   nLin, 001 Psay " "
	@ ++nLin, 001 Psay " "
	@ ++nLin, 001 Psay " "
	@ ++nLin, 001 Psay " "	
	SetPgeject(.F.)
	SETPRC(0,0)
    (cString)->(dbSkip())

EndDo        
@ nLin, 000 Psay chr(18)
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpBasCalcºAutor  ³Wilson Gouveia      º Data ³  06/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime Base de Calculo                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpBasCalc()
	                             
IF (cString)->VALISS<>0
	@ nLin, 054 Psay Transform((cString)->BASEISS,"@E 99,999,999.99")
	@ nLin, 069 Psay Transform(nAliqISS,"@E 999,99")+" %"
	@ nLin, 082 Psay Transform((cString)->VALISS,"@E 99,999,999.99")  
	nLin++
Else
	If cSubSt <> "1"
	   // @ nLin, 000 Psay AllTrim(SubStr(aObserv[4],1,40))  // Substituicao Tributaria OU Diferido conforme lei RJ/6108/11	
		@ nLin, 054 Psay Transform((cString)->BASEICM,"@E 99,999,999.99")
		@ nLin, 069 Psay Transform(nAliqIcm,"@E 999,99")+" %"
		@ nLin, 082 Psay Transform((cString)->VALICM,"@E 99,999,999.99")
		nLin++
	Else 
	    @ nLin, 000 Psay AllTrim(SubStr(aObserv[4],1,40))  // Substituicao Tributaria
		nLin++
		nLinObs++
	EndIf
Endif
Return	
