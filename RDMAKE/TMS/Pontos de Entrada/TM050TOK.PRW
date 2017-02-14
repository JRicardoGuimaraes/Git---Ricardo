#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.ch"              
#INCLUDE "XMLXFUN.CH"                   
                                                                     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma³TM050TOK   ºAutor  ³ Katia Alves Bianchiº Data ³  14/05/00    º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.   ³Valida a digitacao de algumas informacoes na entrada de NF    º±±
±±º        ³Campo Específico                                              º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³ Gefco                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TM050TOK()

	Local _lRetorno := .T.
	Local cCodPsa   := Alltrim(GetMv("MV_GEF003",,""))
	Local aAreaAtu  := GetArea()
	Local lVeiObrig := .F.    // Indica se o veiculo e obrigatorio
	Local lsoDelet  := .F.    // Indica se ha somente uma linha no acols e essa linha esta deletada
	Local cMensagem := "Para o serviço " + UPPER(ALLTRIM(M->DTC_DESSER)) + " é obrigatório informar o tipo do veiculo, através de botão que se encontra na barra superior !"
	Local nQtdNf    := 0
	Local _cCliMAN  := AllTrim(GETNewPar("MV_XCTEMAN","|04858701|15882200|"))
	Local _cCliVALEO:= AllTrim(GETNewPar("MV_XCLIVAL","02694400|"))

//Se for inclusao

	If l050Inclui
	// Se o cliente for a PSA validar a digitaçao dos campo especificos
	// If Alltrim(M->DTC_CLIDEV) $ cCodPsa
		If isCliPSA(Alltrim(M->DTC_CLIDEV))
			DbSelectArea("SZI")
			DbSetorder(1)
			If EMPTY(Alltrim(M->DTC_CONTA))
				_lRetorno := .F.
				Aviso("Atencao","O campo Cnt.Despesa deve ser preenchido quando o cliente devedor for a PSA!",{"Continuar"})
			ElseIf EMPTY(Alltrim(M->DTC_CCONT))
				_lRetorno := .F.
				Aviso("Atencao","O campo C.Custo PSA deve ser preenchido quando o cliente devedor for a PSA!",{"Continuar"})

		// Por: Ricardo - Em: 12/04/2010
// Por : Ricardo - Em: 11/10/2014 - Solicitado por Laudiceia
/*
		ElseIf Empty(M->DTC_OI) .AND. POSICIONE("SZG",1,xFilial("SZG")+M->DTC_CCONT,"ZG_OIOBRIG") == "S"
			_lRetorno := .F.
			Aviso("Atencao","A Ordem Interna PSA é obrigatória para o C.Custo PSA informado.  Favor preencher o campo.",{"Continuar"})
		ElseIf !Empty(M->DTC_OI) .AND. POSICIONE("SZG",1,xFilial("SZG")+M->DTC_CCONT,"ZG_OIOBRIG") <> "S"
			_lRetorno := .F.
			Aviso("Atencao","O C.Custo PSA informado não requer Ordem Interna.  Favor manter o campo OI em branco ou alterar o CC.",{"Continuar"})

		ElseIf !Empty(M->DTC_OI) .AND. POSICIONE("SZG",1,xFilial("SZG")+M->DTC_CCONT,"ZG_OIOBRIG") == "S"
		    	If !Dbseek(xFilial("SZI")+M->DTC_CCONT+M->DTC_CONTA+M->DTC_OI)
			   		Aviso("Atencao","Os campos C.Custo PSA,Cnt.Despesa e Ord.Interna nãi foram encontrados na tabela SZI!",{"Continuar"})
			   		_lRetorno := .F.
				Endif
*/

		// Por: Ricardo Guimarães - Em: 05/11/2013 - Objetivo: Amarrar CC PSA a Conta PSA para as operações do OVL
			ElseIf Left(M->DTC_CCUSTO,3) $ AllTrim(GETMV("MV_XOVLCC")) .AND. AllTrim(M->DTC_CCONT) $ AllTrim(GETNewPar("MV_CCPSAOV","28230|28510|78430|98270|98310|98320|98540|98750|98760|98770|A8180|A8188|B4803|B5810|B8155|B8194|C4810|C8125|C8140|C8160|D5820|D8155|D8502|D8503|E8135"))
				If Alltrim(M->DTC_CONTA) <> GETNewPar("MV_CTPSAOV","62480000")
					Aviso("Atencao","Para operações do OVL e CC PSA " + AllTrim(M->DTC_CCONT) + ", a conta PSA deve ser " + GETNewPar("MV_CTPSAOV","62480000"),{"Continuar"})
					M->DTC_CONTA := GETNewPar("MV_CTPSAOV","62480000")
				EndIf

//		ElseIf !Empty(M->DTC_OI) .AND. ALLTRIM(LEFT(POSICIONE("SZG",1,xFilial("SZG")+M->DTC_CCONT,"ZG_DESCRIC"),5)) == "ITPA"
//			_lRetorno := .T.
			EndIf

		EndIf

	// Por: Ricardo Guimarães - Em: 31/10/2012
	// Validação dos campos que são obrigatório para a Filial Contagem
	// Em: 22/07/2013 - Em desuso devido entrada do CT-e
	/*
	If cFilAnt == "22" // Contagem
		If Empty(M->DTC_VEICAV)
			Aviso("Campo Obrigatório","Favor informar a marca do veículo(Cavalo). Aba Inf.Transporte - Filial Contagem",{"Continuar"})
			_lRetorno := .F.
		EndIf
		If Empty(M->DTC_PLACAV)
			Aviso("Campo Obrigatório","Favor informar a placa do veículo(Cavalo). Aba Inf.Transporte - Filial Contagem",{"Continuar"})
			_lRetorno := .F.
		EndIf
		If Empty(M->DTC_MUNCAV)
			Aviso("Campo Obrigatório","Favor informar a município de registro do veículo(Cavalo). Aba Inf.Transporte - Filial Contagem",{"Continuar"})
			_lRetorno := .F.
		EndIf
		If Empty(M->DTC_UFCAV)
			Aviso("Campo Obrigatório","Favor informar o estado de registro do veículo(Cavalo). Aba Inf.Transporte - Filial Contagem",{"Continuar"})
			_lRetorno := .F.
		EndIf
	EndIf
	*/

	// Por: Ricardo Guimarães - Em: 05/01/2013
	// Validação do campo Transportadora
	/*
	If Left(AllTrim(M->DTC_CCUSTO),3) $ GetNewPar("MV_XTLACC","101|102")
		If Empty(M->DTC_TRANSP) .OR. Empty(M->DTC_LJTRA)
			Aviso("Campo Obrigatório","Favor informar a transportadora na aba Outros.",{"Continuar"})
			_lRetorno := .F.
		EndIf
	EndIf
	*/

	// Por: Ricardo Guimarães - Em: 03/02/2014
	// Validação dos campos que são obrigatório para a operação MAN
	// If ((M->DTC_CLIREM + M->DTC_LOJREM) $ _cCliMAN .OR. (M->DTC_CLIDES  + M->DTC_LOJDES) $ _cCliMAN) .AND. Left(M->DTC_CCUSTO,3) $ AllTrim(GETMV("MV_XOVLCC"))
	// Alterado por Ricardo: 22/09/2015 - Solicitado por Valter para passar a considerar o cliente DEVEDOR
		If ((M->DTC_CLIDEV  + M->DTC_LOJDEV) $ _cCliMAN) .AND. Left(M->DTC_CCUSTO,3) $ AllTrim(GETMV("MV_XOVLCC"))
			If Empty(M->DTC_TPCAR)
				Aviso("Campo Obrigatório(MAN)","Favor informar a Tipo de Carregamento na aba Outros.(MAN)",{"Continuar"})
				_lRetorno := .F.
			EndIf

			If Empty(M->DTC_NUMCVA)
				Aviso("Campo Obrigatório(MAN)","Favor informar o Número do CVA na aba Outros(MAN).",{"Continuar"})
				_lRetorno := .F.
			EndIf

			If Empty(M->DTC_COLMON)
				Aviso("Campo Obrigatório(MAN)","Favor informar o Número do Coleta do Moniloc na aba utros.(MAN)",{"Continuar"})
				_lRetorno := .F.
			EndIf
		EndIF

	// Por: Ricardo Guimarães - Em: 02/04/2014
	// Validação dos campos que são obrigatório para a operação VALEO
	//If ((M->DTC_CLIREM + M->DTC_LOJREM) $ _cCliVALEO .OR. (M->DTC_CLIDES  + M->DTC_LOJREM) $ _cCliVALEO) .AND. Left(M->DTC_CCUSTO,3) $ AllTrim(GETMV("MV_XOVLCC"))
		If (M->DTC_CLIDEV + M->DTC_LOJDEV) $ _cCliVALEO .AND. Left(M->DTC_CCUSTO,3) $ AllTrim(GETMV("MV_XOVLCC"))
			If Empty(M->DTC_XROTA)
				Aviso("Campo Obrigatório(VALEO)","Favor informar a Rota.(VALEO)",{"Continuar"})
				_lRetorno := .F.
			Else
				_lRetorno := U_fVldRotaValeo(M->DTC_XROTA)
			EndIf

			If Empty(M->DTC_XTPCON)
				Aviso("Campo Obrigatório(VALEO","Favor informar o Tipo de Conhecimento (VALEO).",{"Continuar"})
				_lRetorno := .F.
			EndIf

			If Empty(M->DTC_XCC)
				Aviso("Campo Obrigatório(VALEO)","Favor informar o Centro de Custo (VALEO)",{"Continuar"})
				_lRetorno := .F.
			EndIf
		EndIF



	Endif

	IF _lRetorno .AND. l050Inclui
		IF DC5->(FieldPos("DC5_XVEIC"))>0
			DC5->(DbsetOrder(1))
			If DC5->(Dbseek(xFilial("DC5")+M->DTC_SERVIC))
				If DC5->DC5_XVEIC="S"     // Veiculo obrigatorio
					lVeiObrig := .T.
				Endif
			Endif
			If lVeiObrig
				If Len(aColsDVU)!=0
					If Len(aColsDVU)>1
						_lRetorno := .F.
						Aviso("Atencao","Informar veiculo apenas em uma nota fiscal",{"OK"})
					Else
						For n2:=1 To Len(aColsDVU)
							For n3:=1 To Len(aColsDVU[n2,2])
								IF aColsDVU[n2, 2, 1, Len(aColsDVU[n2][2][n3])]  == .F.
									nQtdNf++
								Endif
							Next
							If nQtdNf>1
								_lRetorno := .F.
								Aviso("Atencao","Informar Apenas um tipo de veiculo por nota fiscal",{"OK"})
								Exit
							Endif
							If aColsDVU[n2, 2, 1, Len(aColsDVU[n2][2][1])]  == .F.
								If !Empty(aColsDVU[n2,2,1,2])
									If aColsDVU[n2,2,1,4]=0
										_lRetorno := .F.
										Aviso("Atencao",cMensagem,{"OK"})
										lsoDelet := .F.
										Exit
									Else
										lsoDelet := .F.
									Endif
								Else
									_lRetorno := .F.
									Aviso("Atencao",cMensagem,{"OK"})
									lsoDelet := .F.
									Exit
								Endif
							Else
								lsoDelet:=.T.
							Endif
						Next
					Endif
				Else
					_lRetorno := .F.
					Aviso("Atencao",cMensagem,{"OK"})
				Endif

				If lsoDelet
					_lRetorno := .F.
					Aviso("Atencao",cMensagem,{"OK"})
				Endif
			Endif
		Endif
	EndIf

// Por: Ricardo Guimarães - Em: 17/03/2010
// Tratamento para Carga Fechada é obrigado a informar o veículo.
/*
IF _lRetorno
	IF "FECH" $ UPPER(ALLTRIM(M->DTC_DESSER))
		If Len(aColsDVU)!=0
			If Len(aColsDVU)>1
				_lRetorno := .F.
				Aviso("Atencao","Informar veiculo apenas em uma nota fiscal",{"OK"})
			Else
				For n2:=1 To Len(aColsDVU)
					For n3:=1 To Len(aColsDVU[n2,2])
						IF aColsDVU[n2, 2, 1, Len(aColsDVU[n2][2][n3])]  == .F.
							nQtdNf++
						Endif
					Next
					If nQtdNf>1
						_lRetorno := .F.
						Aviso("Atencao","Informar Apenas um tipo de veiculo por nota fiscal",{"OK"})
						Exit
					Endif
					If aColsDVU[n2, 2, 1, Len(aColsDVU[n2][2][1])]  == .F.
						If !Empty(aColsDVU[n2,2,1,2])
							If aColsDVU[n2,2,1,4]=0
								_lRetorno := .F.
								Aviso("Atencao",cMensagem,{"OK"})
								lsoDelet := .F.
								Exit
							Else
								lsoDelet := .F.
							Endif
						Else
							_lRetorno := .F.
							Aviso("Atencao",cMensagem,{"OK"})
							lsoDelet := .F.
							Exit
						Endif
					Else
						lsoDelet:=.T.
					Endif
				Next
			Endif
		Else
			_lRetorno := .F.
			Aviso("Atencao",cMensagem,{"OK"})
		Endif

		If lsoDelet
			_lRetorno := .F.
			Aviso("Atencao",cMensagem,{"OK"})
		Endif
	Endif
Endif
*/
Return(_lRetorno)

*********************************************************
* Por: Ricardo Guimarães     Em: 30/10/2013             *
* Objetivo: Busca informações da NF-e PSA na tabela SZ6 *
*           e atualiza linha de grid da tela de entrada *
*           de doc do TMS                               *
*********************************************************
User Function fAtuDTC_IDNF(_cIDNF)
	Local aAreaSA1     := SA1->(GetArea())
	Local _nPosNumNFC  := Ascan(aHeader,{|x|Alltrim(x[2])=="DTC_NUMNFC"})
	Local _nPosSerNFC  := Ascan(aHeader,{|x|Alltrim(x[2])=="DTC_SERNFC"})
	Local _nPosEmiNFC  := Ascan(aHeader,{|x|Alltrim(x[2])=="DTC_EMINFC"})
	Local _nPosQtdVol     := Ascan(aHeader,{|x|Alltrim(x[2])=="DTC_QTDVOL"})
	Local _nPosPeso    := Ascan(aHeader,{|x|Alltrim(x[2])=="DTC_PESO"})
	Local _nPosPesoM3  := Ascan(aHeader,{|x|Alltrim(x[2])=="DTC_PESOM3"})
	Local _nPosValor   := Ascan(aHeader,{|x|Alltrim(x[2])=="DTC_VALOR"})
	Local _nPosCFOP    := Ascan(aHeader,{|x|Alltrim(x[2])=="DTC_CF"})
	Local _nPosProd    := Ascan(aHeader,{|x|Alltrim(x[2])=="DTC_CODPRO"})
	Local _aArea 		 := GetArea()
	Local _lRetorno    := .T.
	Local _cNumNFE 	 := ""
	Local _cSerNFE	 := ""
	Local _nPeso		 := 0
	Local _nQtdVol	 := 0
	Local _nPesoM3	 := 0
	Local _nValor		 := 0.00
	Local _cChassi	 := ""
	Local _cCFOP		 := ""
	Local _cCor		 := ""
	Local _cXML		 := ""
	Local _lRetSIM     := .F.
	Local _cHorIni 	 := ""
	Local _cCodigo 	 := ""
	Local _cTexto	 	 := ""
	Local _cGetAtivo	 := ReadVar()

	PRIVATE	cAviso 	 := ""
	PRIVATE	cErro  	 := ""
	PRIVATE	oWSSimErro	 := Nil
                      

// Por: Guilherme Coronado (ITUP) - Em: 15/12/2016
// Objetivo: Tratamento do preenchimento dos campos DTC_CLIREC e DTC_CLIEXP exclusivos para o caso do EDI-FIAT
   
   If AtIsRotina("U_LOCT004")
      lFixer := GetMv("IT_FIXER")  
      aAreaSA1x := SA1->(GetArea())
      aAreaZA6x := ZA6->(GetArea())                                              
      aAreaZA7x := ZA7->(GetArea())
	  ZA0->(dbSetOrder(1))
	  ZA0->(dbSeek(xFilial('ZA0') + DTQ->DTQ_SOT))
	  If Substr(Alltrim(Posicione("SA1",1,xFilial("SA1") + ZA0->ZA0_CLI+ZA0->ZA0_LOJA, "A1_CGC")),1,8) $ StrTran(Alltrim(GetMv("IT_RPJFIAT")),".","")	
	     _nRegX := SM0->(Recno())
		 _cCgcX := ""
		 _cCliX := ""
		 _cLojX := ""   
	     ZA6->(dbSetOrder(5))
    	 ZA6->(dbSeek(DTQ->DTQ_AS))			 
		 If lFixer
		    _cCgcX := GetMv("IT_EDIER") 
		 Else	                               
	 		 SM0->(dbGotop())
			 While !Eof()       
			 	If SM0->M0_CODFIL == substr(ZA6->ZA6_MLORIG,8,2)//DTQ->DTQ_FILORI
			 		_cCgcX := SM0->M0_CGC
			 		Exit
			 	EndIF	
			 	SM0->(dbSkip())
			 EndDo 
		 EndIf
		 If !empty(_cCgcX)                                                                            
		 	SA1->(dbSetOrder(3))
		 	SA1->(dbSeek(xFilial("SA1")+_cCgcX))
		 	If !SA1->(Eof())                                               
		 		_cCliX := SA1->A1_COD
		 		_cLojX := SA1->A1_LOJA
		 	EndIf
		 EndIF     
	     //cTipo := U_TpOpera(ZA6->ZA6_VIAGEM, ZA6->ZA6_AS)		
		 // Uso do preenchimento especial na manutenção do CTe e Geração da DACTE
		 If !empty(_cCliX)
		  	If substr(ZA6->ZA6_MLORIG,6,1) == "M"  //.Or. cTipo == "M"
			   ZA7->(dbSetOrder(3))
		  	   ZA7->(dbSeek(DTQ->DTQ_VIAGEM))
		  	   If ZA7->ZA7_DEVEMB == "P"
                  cCodDes := Iif(!Empty(ZA7->ZA7_CLIDES),ZA7->ZA7_CLIDES,U_ZA6ZA7( "ZA6_CLIDES" ))//U_ZA6ZA7( "ZA6_CLIDES" )	// ZA6->ZA6_CLIDES
				  cLojDes := Iif(!Empty(ZA7->ZA7_LOJDES),ZA7->ZA7_LOJDES,U_ZA6ZA7( "ZA6_LOJDES" ))//U_ZA6ZA7( "ZA6_LOJDES")	// ZA6->ZA6_LOJDES
			      cSeqEnd := U_xSqeDes(_cClix,_cLojX,cCodDes,cLojDes)		  		  
		  		  cCodRec := _cClix
		  		  cLojRec := _cLojx 
			      cDesRec := Posicione("SA1",1,xFilial("SA1") + cCodRec+cLojRec, "A1_NOME")			  	   
		  		  oCodRec:Refresh()
		  		  oLojRec:Refresh()
		  		  oDesRec:Refresh()
		  		  cDes   := Posicione("SA1",1,xFilial("SA1") + cCodRec+cLojRec, "A1_MUN")			  	   
		  		  cDesUF := Posicione("SA1",1,xFilial("SA1") + cCodRec+cLojRec, "A1_EST")			  	   
		  		  oDes:Refresh()
   		  		  oDesUF:Refresh()    			   		  		  	                 
	              //M->DTC_SQEDES := cSeqEnd		  			
		  	   Else
				  cCodExp := _cClix
				  cLojExp := _cLojx
				  cDesExp := Posicione("SA1",1,xFilial("SA1") + cCodExp+cLojExp, "A1_NOME")
				  oCodExp:Refresh()
				  oLojExp:Refresh()				  		  			  								
				  oDesExp:Refresh()		  						  
		  		  cOri   := Posicione("SA1",1,xFilial("SA1") + cCodExp+cLojExp, "A1_MUN")			  	   
		  		  cOriUF := Posicione("SA1",1,xFilial("SA1") + cCodExp+cLojExp, "A1_EST")			  	   		  		    
		  		  oOri:Refresh()
		  		  oOriUF:Refresh()    			   		  		      	  		  
			   EndIf	
			ElseIf substr(ZA6->ZA6_MLORIG,6,1) == "T" //.Or. cTipo == "T"
			    ZA7->(dbSetOrder(3))
			    ZA7->(dbSeek(DTQ->DTQ_VIAGEM))
				If ZA7->ZA7_DEVEMB == "P"
				   cCodExp := _cClix
				   cLojExp := _cLojx
				   cDesExp := Posicione("SA1",1,xFilial("SA1") + cCodExp+cLojExp, "A1_NOME")
				   oCodExp:Refresh()
				   oLojExp:Refresh()				   	
    			   oDesExp:Refresh()		  		
		  		   cOri   := Posicione("SA1",1,xFilial("SA1") + cCodExp+cLojExp, "A1_MUN")			  	   
		  		   cOriUF := Posicione("SA1",1,xFilial("SA1") + cCodExp+cLojExp, "A1_EST")			  	   		  		    
		  		   oOri:Refresh()
		  		   oOriUF:Refresh()    			   		  		      	  		  
			  	Else
				   cCodDes := ZA7->ZA7_CODCLI
				   cLojDes := ZA7->ZA7_LOJCLI			  		
				   cSeqEnd := U_xSqeDes(_cClix,_cLojX,cCodDes,cLojDes)
			  	   cCodRec := _cClix
			  	   cLojRec := _cLojx
				   cDesRec := Posicione("SA1",1,xFilial("SA1") + cCodRec+cLojRec, "A1_NOME")			  	   
		  		   oCodRec:Refresh()
		  		   oLojRec:Refresh()
		  		   oDesRec:Refresh()
	               //M->DTC_SQEDES := cSeqEnd	 
		  		   cDes   := Posicione("SA1",1,xFilial("SA1") + cCodRec+cLojRec, "A1_MUN")			  	   
		  		   cDesUF := Posicione("SA1",1,xFilial("SA1") + cCodRec+cLojRec, "A1_EST")			  	   
		  		   oDes:Refresh()
   		  		   oDesUF:Refresh()    			   		  		  	                 	               	  			
			  	EndIf	
			ElseIf substr(ZA6->ZA6_MLORIG,6,1) == "6" //.Or. cTipo == "6"
				cCodExp := Space(6)
				cLojExp := Space(2)
				cCodRec := Space(6)
				cLojRec := Space(2)
				oCodExp:Refresh()
				oLojExp:Refresh()		  		
				oDesExp:Refresh()		  		
		  		oCodRec:Refresh()
		  		oLojRec:Refresh()				
		  		oDesRec:Refresh()
		  		oDes:Refresh()
	  		    oDesUF:Refresh()		  		
		  	    oOri:Refresh()
	  		    oOriUF:Refresh()    			  	  		    
			EndIF
		 EndIf
	  EndIF
	  RestArea(aAreaSA1x)
	  RestArea(aAreaZA6x)
	  RestArea(aAreaZA7x)
   EndIf

// Por: Ricardo Guimarães - Em: 09/04/2015
// Objetivo: Estava interferindo no EDI e carga através da tabela DE5, bem como outros comportamentos estranhos de atualização de campos
	If !("DTC_XNFEID" $ AllTrim(_cGetAtivo))
		Return .T.
	EndIf

/*
If Empty(_cIDNF)
	MsgInfo("Campo obrigatório.","Informação")
	Return .F.
EndIf
*/
//	---	Abre arquivos
	dbSelectArea('DF0')
	dbSelectArea('DF1')

	If !Empty(_cIDNF) .AND. Len(AllTrim(_cIDNF)) < 44
		MsgInfo("Chave com tamanho incompátivel.","Informação")
		Return .F.
	EndIf

	If !Empty(_cIDNF) .AND. !ISDIGIT(_cIDNF)
		MsgInfo("A Chave digitada contém dígito(s) incorreto(s).","Informação")
		Return .F.
	EndIf

// Não foi informado nenhum chave
	If Empty(_cIDNF)
		Return .T.
	EndIf

	dbSelectArea("SZ6") ; dbSetOrder(2)

	While .T.
		If dbSeek(xFilial("SZ6") + _cIDNF )
			_cXML := AllTrim(SZ6->Z6_XML)

		// Por: Ricardo - Em: 25/11/2014
		// Se achou a NF-e na tabela SZ6 mas o registro não possui o XML, disparo o Web Service da SIM Consulta para buscar o XML e atualizar a SZ6
			If Empty(SZ6->Z6_XML)
			//	--- Exibe mensagem de busca do XML
				MsgRun(OemToAnsi('Buscando XML no site da SEFAZ ...Aguarde!'  ), 'Consulta XML' , { || 	U_SIMBuscaXML(_cIDNF) } )
				SZ6->( dbSeek(xFilial("SZ6") + _cIDNF ) )
			EndIf

		// Busco informação no XML
			If !Empty(AllTrim(SZ6->Z6_IDCANC))
				MsgInfo("Nota Cancelada.","Informação")
				_lRetorno := .F.
			ElseIf Empty(SZ6->Z6_XML) .OR. SZ6->Z6_RESPWEB = "NOK"
			// Por: Ricardo Guimarães - Em: 10/11/2014 - Em virtude de rotina da CNH passar a incluir registro na SZ6, houve a necessidade do código abaixo
				MsgInfo("NF-e localizada na tabela(SZ6) mas sem o XML ou com erro.  Favor digitar as informações complementares.","Informação")

				_cNumNFE  	:= SZ6->Z6_NUMNFE
				_cSerNFE	:= SZ6->Z6_SERNFE

				aCols[N,_nPosNumNFC] := _cNumNFE
				aCols[N,_nPosSerNFC] := _cSerNFE

				_lRetorno := .T.
			Else

			// oNFE 		:= XmlParser(SZ6->Z6_XML,"_",@cAviso,@cErro)
				oNFE 		:= XmlParser(_cXML,"_",@cAviso,@cErro)

			// verifica se tem erro na abertura
			// If Empty(cErro) .Or. oNFE <> NIL
				If Empty(cErro) .AND. oNFE <> NIL

				// nota fiscal da PSA do FVL
					If AT("VEICPROD",UPPER(SZ6->Z6_XML)) > 0  // NF-e de Veículo
						If SZ6->Z6_RESPWEB <> "OK"
							If AT("NFEPROC",UPPER(SZ6->Z6_XML)) > 0
								_cChassi	:=  AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VEICPROD:_CHASSI:TEXT)
								_cCor  	:=  AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VEICPROD:_xCOR:TEXT)

								If Type("oNFE:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL") == "O"
									_nPeso  	:=  Val(AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOb:TEXT))
								EndIf
							Else
								If Type("oNFE:_NFE:_INFNFE:_DET:_PROD:_VEICPROD:_CHASSI") == "O"
									_cChassi	:=  AllTrim(oNFE:_NFE:_INFNFE:_DET:_PROD:_VEICPROD:_CHASSI:TEXT)
								EndIf

								If Type("oNFE:_NFE:_INFNFE:_DET:_PROD:_VEICPROD:_xCOR") == "O"
									_cCor  		:=  AllTrim(oNFE:_NFE:_INFNFE:_DET:_PROD:_VEICPROD:_xCOR:TEXT)
								EndIf

								If Type("oNFE:_NFE:_INFNFE:_TRANSP:_VOL") == "O"
									_nPeso  	:=  Val(AllTrim(oNFE:_NFE:_INFNFE:_TRANSP:_VOL:_PESOb:TEXT))
								EndIf
							EndIf
						EndIf


					//aCols[N,_nPosProd] := "VEICULO"
						GDFieldPut('DTC_CODPRO', "VEICULO" )

	//				M->DTC_OBS += " CHASSI: " + AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VEICPROD:_CHASSI:TEXT)  + " COR:" +;
	//							                   AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_DET[1]:_PROD:_VEICPROD:_xCOR:TEXT)

					Else 	// nota fiscal da PSA do OVL/OVS

					// _cChassi	:=  AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_DET[1]:_PROD:_VEICPROD:_CHASSI:TEXT)
					// _cCor  	:=  AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_DET[1]:_PROD:_VEICPROD:_xCOR:TEXT)
					//_nPeso  	:=  Val(AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTot:_vNF:TEXT))

						If SZ6->Z6_RESPWEB = "OK" // XML Carregado pelo Web Service da SIM Consulta
						// If Type("oNFE:_NFE:_NFE:_INFNFE:_TRANSP:_VOL:_PESOb") == "O"
						// Peso
							If XMLCHILDEX(oNFE:_NFE:_INFNFE:_TRANSP, "_VOL") <> Nil
								If ValType(oNFE:_NFE:_INFNFE:_TRANSP:_VOL) <> "A"
									If XMLCHILDEX(oNFE:_NFE:_INFNFE:_TRANSP:_VOL,"_PESOB") <> Nil
										_nPeso := Val(AllTrim(oNFE:_NFE:_INFNFE:_TRANSP:_VOL:_PESOb:TEXT))
									EndIf

								// Volume
									If XMLCHILDEX(oNFE:_NFE:_INFNFE:_TRANSP:_VOL,"_QVOL") <> Nil
										_nQtdVol   := Val(AllTrim(oNFE:_NFE:_INFNFE:_TRANSP:_VOL:_qVOL:TEXT))
									EndIf
								Else

							// If XMLCHILDEX(oNFE:_NFE:_INFNFE:_TRANSP, "_VOL") <> Nil
		  						// Quando o XML vem com mais de TAG VOL
									If XMLCHILDEX(oNFE:_NFE:_INFNFE:_TRANSP:_VOL[1],"_PESOB") <> Nil
										_nPeso     := Val(AllTrim(oNFE:_NFE:_INFNFE:_TRANSP:_VOL[1]:_PESOb:TEXT))
									EndIf

								// Volume
									If XMLCHILDEX(oNFE:_NFE:_INFNFE:_TRANSP:_VOL[1],"_QVOL") <> Nil
										_nQtdVol   := Val(AllTrim(oNFE:_NFE:_INFNFE:_TRANSP:_VOL[1]:_qVOL:TEXT))
									EndIf
								EndIf
							EndIf
						Else

						// A linha abaixo foi alterada devido gerar erro quando a NF-e é de Vasilhame - Ricardo - Em: 10/07/2014
						// If Type("oNFE:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL") == "O"
							If AT("NFEPROC",UPPER(SZ6->Z6_XML)) > 0
							// A linha abaixo foi alterada devido gerar erro quando a NF-e é da CNH - Ricardo - Em: 18/09/2014
	//						If Type("oNFE:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOb") == "O"
								If XMLCHILDEX(oNFE:_NFEPROC:_NFE:_INFNFE:_TRANSP, "_VOL") <> Nil
									If VALTYPE(oNFE:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL) <> "A"
										If XMLCHILDEX(oNFE:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL, "_QVOL") <> Nil
											_nQtdVol   := Val(AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_qVOL:TEXT))
										EndIf

										If XMLCHILDEX(oNFE:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL, "_PESOB") <> Nil
											_nPeso  	:=  Val(AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOb:TEXT))
										EndIf
									Else
			  						// Quando o XML vem com mais de TAG VOL
										If XMLCHILDEX(oNFE:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL[1], "_QVOL") <> Nil
											_nQtdVol   := Val(AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL[1]:_qVOL:TEXT))
										EndIf

										If XMLCHILDEX(oNFE:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL[1], "_PESOB") <> Nil
											_nPeso  	:=  Val(AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL[1]:_PESOb:TEXT))
										EndIf
									EndIf
								EndIf
							Else
							// If Type("oNFE:_NFE:_INFNFE:_TRANSP:_VOL:_PESOb") == "O"
								If XMLCHILDEX(oNFE:_NFE:_INFNFE:_TRANSP, "_VOL") <> Nil
									If VALTYPE(oNFE:_NFE:_INFNFE:_TRANSP:_VOL) <> "A"
										If XMLCHILDEX(oNFE:_NFE:_INFNFE:_TRANSP:_VOL, "_PESOB") <> Nil
											_nPeso     :=  Val(AllTrim(oNFE:_NFE:_INFNFE:_TRANSP:_VOL:_PESOb:TEXT))
										EndIf

										If XMLCHILDEX(oNFE:_NFE:_INFNFE:_TRANSP:_VOL, "_QVOL")  <> Nil
											_nQtdVol   := Val(AllTrim(oNFE:_NFE:_INFNFE:_TRANSP:_VOL:_qVOL:TEXT))
										EndIf
									Else
			  						// Quando o XML vem com mais de TAG VOL
										If XMLCHILDEX(oNFE:_NFE:_INFNFE:_TRANSP:_VOL[1], "_PESOB") <> Nil
											_nPeso     :=  Val(AllTrim(oNFE:_NFE:_INFNFE:_TRANSP:_VOL[1]:_PESOb:TEXT))
										EndIf

										If XMLCHILDEX(oNFE:_NFE:_INFNFE:_TRANSP:_VOL[1], "_QVOL")  <> Nil
											_nQtdVol   := Val(AllTrim(oNFE:_NFE:_INFNFE:_TRANSP:_VOL[1]:_qVOL:TEXT))
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					Endif

					_cCFOP 		:= SZ6->Z6_CFOPPRI
					If SZ6->Z6_RESPWEB = "OK" // XML Carregado pelo Web Service da SIM Consulta
						_nValor  	:=  Val(AllTrim(oNFE:_NFE:_INFNFE:_TOTAL:_ICMSTot:_vNF:TEXT))
					Else
						If AT("NFEPROC",UPPER(SZ6->Z6_XML)) > 0
							_nValor  	:=  Val(AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTot:_vNF:TEXT))
						Else
							_nValor  	:=  Val(AllTrim(oNFE:_NFE:_INFNFE:_TOTAL:_ICMSTot:_vNF:TEXT))
						EndIf
					EndIf

				//	---	[2LGI] Inicio ajuste 13/02/2015
				//	---	A partir da leitura substituir o remetente e destinatário
				//	---	Preencher os demais campos para casos com agendamento ou não.

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Alterado - Vinícius Moreira - 10/02/2015                                                   ³
				//³Regra para gatilhar o código e loja do cliente.                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					SA1->(dbSetOrder(3))//A1_FILIAL+A1_CGC
					If SA1->(dbSeek(xFilial("SA1")+SZ6->Z6_CNPJEMI))
						If !Empty(M->DTC_CLIREM) .And. M->DTC_CLIREM != SA1->A1_COD
							MsgInfo("Já exite rementente (" + M->(DTC_CLIREM + "/" + DTC_LOJREM) + ") informado no lote diferente do lido pela chave informada.","Informação")
							_lRetorno := .F.
							Exit
						ElseIf !Empty(M->DTC_LOJREM) .And. M->DTC_LOJREM != SA1->A1_LOJA
							MsgInfo("Já exite rementente (" + M->(DTC_CLIREM + "/" + DTC_LOJREM) + ") informado no lote diferente do lido pela chave informada.","Informação")
							_lRetorno := .F.
							Exit
						Else
							M->DTC_CLIREM := Iif(SA1->A1_EST == 'EX',Space(TamSX3('A1_COD')[1]),SA1->A1_COD)
							M->DTC_LOJREM := Iif(SA1->A1_EST == 'EX',Space(TamSX3('A1_LOJA')[1]),SA1->A1_LOJA)
						EndIf
					EndIf

				//	--- Somente destinos nacionais
					If !Empty(SZ6->Z6_CNPJDES)
						If SA1->(dbSeek(xFilial("SA1")+SZ6->Z6_CNPJDES))
							If !Empty(M->DTC_CLIDES) .And. M->DTC_CLIDES != SA1->A1_COD
								MsgInfo("Já exite destinatario (" + M->(DTC_CLIDES + "/" + DTC_LOJDES) + ") informado no lote diferente do lido pela chave informada.","Informação")
								_lRetorno := .F.
								Exit
							ElseIf !Empty(M->DTC_LOJDES) .And. M->DTC_LOJDES != SA1->A1_LOJA
								MsgInfo("Já exite destinatario (" + M->(DTC_CLIDES + "/" + DTC_LOJDES) + ") informado no lote diferente do lido pela chave informada.","Informação")
								_lRetorno := .F.
								Exit
							Else
								M->DTC_CLIDES := Iif(SA1->A1_EST == 'EX',Space(TamSX3('A1_COD')[1]),SA1->A1_COD)
								M->DTC_LOJDES := Iif(SA1->A1_EST == 'EX',Space(TamSX3('A1_LOJA')[1]),SA1->A1_LOJA)
							EndIf
						EndIf
					EndIf

				//	---	Verifica se a solicitação de coleta foi preenchida
					If 	!Empty(M->DTC_NUMSOL)

					//	---	Busca solicitacao no agendamento
						DF1->(dbSetOrder(3))
						If DF1->(dbSeek(xFilial('DF1')+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE ) )
						// ---	Define variavel de origem
							_cOrigem	:= "DF1"

							DF0->(dbSetOrder(1))
							DF0->(dbSeek(xFilial('DF0')+DF1->DF1_NUMAGE ) )
							
							DT6->(dbSetOrder(1))
							DT6->(dbSeek(xFilial('DT6')+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE ) )
							
						Else
						//	---	Posiciona item do agendamento
						//	---	Via solicitação de coleta sem agendamento
							_cOrigem	:= "DT5"

						//	---	Posiciona solicitação de coleta
						// ---	Localiza o agendamento e retorna o KM
							DT6->(dbSetOrder(1))
							DT6->(dbSeek(xFilial('DT6')+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE ) )

						EndIf

					//	---	Preenche os campos do header
					// ---	Demais retornos
						M->DTC_FILCFS	:= 	Iif(_cOrigem == "DF1",DF1->DF1_FILDOC,cFilAnt)
					//M->DTC_CLIREM	:=	Iif(_cOrigem == "DF1",DF1->DF1_CLIREM, DT6->DT6_CLIREM)
					//M->DTC_LOJREM	:=	Iif(_cOrigem == "DF1",DF1->DF1_LOJREM, DT6->DT6_LOJREM)
					//M->DTC_NOMREM	:=	Iif(_cOrigem == "DF1",GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DF1->DF1_CLIREM+DF1->DF1_LOJREM,1,'' ),GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DT6->DT6_CLIREM+DT6->DT6_LOJREM,1,'' ) )
						M->DTC_NOMREM	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+M->DTC_CLIREM+M->DTC_LOJREM,1,'' )
						M->DTC_DATENT	:=	dDataBase
					//M->DTC_CLIDES	:=	Iif(_cOrigem == "DF1",DF1->DF1_CLIDES, DT6->DT6_CLIDES )
					//M->DTC_LOJDES	:=	Iif(_cOrigem == "DF1",DF1->DF1_LOJDES, DT6->DT6_LOJDES )
					//M->DTC_NOMDES	:=	Iif(_cOrigem == "DF1",GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DF1->DF1_CLIDES+DF1->DF1_LOJDES,1,'' ),GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DT6->DT6_CLIDES+DT6->DT6_LOJDES,1,'' ) )
						M->DTC_NOMDES	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+M->DTC_CLIDES+M->DTC_LOJDES,1,'' )
						M->DTC_CLIDEV	:=	Iif(_cOrigem == "DF1",DF1->DF1_CLIDEV, DT6->DT6_CLIDEV )
						M->DTC_LOJDEV	:=	Iif(_cOrigem == "DF1",DF1->DF1_LOJDEV, DT6->DT6_LOJDEV )
						M->DTC_NOMDEV	:=	Iif(_cOrigem == "DF1",GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DF1->DF1_CLIDEV+DF1->DF1_LOJDEV,1,'' ),GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV,1,'') )

						If _cOrigem == "DF1"

						//	---	Remetente
							If DF1->DF1_CLIDEV+DF1->DF1_LOJDEV == DF1->DF1_CLIREM+DF1->DF1_LOJREM
								M->DTC_DEVFRE 	:= 	'1'
								M->DTC_CLICAL	:=	M->DTC_CLIREM
								M->DTC_LOJCAL	:=	M->DTC_LOJREM
								M->DTC_CDRDES	:=	GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+M->DTC_CLIREM+M->DTC_LOJREM,1,'')
								M->DTC_CDRCAL	:=	M->DTC_CDRDES
								M->DTC_NOMCAL	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+M->DTC_CLIREM+M->DTC_LOJREM,1,'' )
								M->DTC_INSREM	:=	GetAdvFVal('SA1','A1_INSCR',xFilial('SA1')+M->DTC_CLIREM+M->DTC_LOJREM,1,'' )
								M->DTC_SQIREM	:=	'01'

							//	---	Destinatario
							ElseIf 	( DF1->DF1_CLIDEV+DF1->DF1_LOJDEV == DF1->DF1_CLIDES+DF1->DF1_LOJDES ) .or. ;
									( DF1->DF1_CLIDEV+DF1->DF1_LOJDEV # DF1->DF1_CLIREM+DF1->DF1_LOJREM .and. DF1->DF1_CLIDEV+DF1->DF1_LOJDEV # DF1->DF1_CLIDES+DF1->DF1_LOJDES)

								M->DTC_DEVFRE 	:= '2'
								M->DTC_CLICAL	:=	M->DTC_CLIDEV
								M->DTC_LOJCAL	:=	M->DTC_LOJDEV
								M->DTC_CDRDES	:=	GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+M->DTC_CLIDEV+M->DTC_LOJDEV,1,'')
								M->DTC_CDRCAL	:=	M->DTC_CDRDES
								M->DTC_NOMCAL	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+M->DTC_CLIDEV+M->DTC_LOJDEV,1,'' )
								M->DTC_INSDES	:=	GetAdvFVal('SA1','A1_INSCR',xFilial('SA1')+M->DTC_CLIDEV+M->DTC_LOJDEV,1,'' )
								M->DTC_SQIDES	:=	'01'

							//	---	Verifica tipo de operação para indicar a sequencia de endereço do CDC
								DF0->(dbSetOrder(1))
								DF0->(dbSeek(xFilial('DF0')+DF1->DF1_NUMAGE))
								If AllTrim(DF0->DF0_DESOPE)	 == 'LTL'

								//	---	Verifica o estado da filial e indica a sequencia de endereço do CDC.
									If SM0->M0_ESTCOB == 'MG'
										M->DTC_SEQEDES	:=	'02'
									ElseIf SM0->M0_ESTCOB == 'SP'
										M->DTC_SEQEDES	:=	'01'
									EndIf

								EndIf

							EndIf

						Else

						//	---	Remetente
							If DT6->DT6_CLIDEV+DT6->DT6_LOJDEV == DT6->DT6_CLIREM+DT6->DT6_LOJREM
								M->DTC_DEVFRE := 	'1'
								M->DTC_CLICAL	:=	DT6->DT6_CLIREM
								M->DTC_LOJCAL	:=	DT6->DT6_LOJREM
								M->DTC_CDRDES	:=	GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+DT6->DT6_CLIREM+DT6->DT6_LOJREM,1,'')
								M->DTC_CDRCAL	:=	M->DTC_CDRDES
								M->DTC_NOMCAL	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DT6->DT6_CLIREM+DT6->DT6_LOJREM,1,'' )
								M->DTC_INSREM	:=	GetAdvFVal('SA1','A1_INSCR',xFilial('SA1')+DT6->DT6_CLIREM+DT6->DT6_LOJREM,1,'' )
								M->DTC_SQIREM	:=	'01'

							//	---	Destinatario
							ElseIf 	( DT6->DT6_CLIDEV+DT6->DT6_LOJDEV == DT6->DT6_CLIDES+DT6->DT6_LOJDES ) .or. ;
									( DF1->DF1_CLIDEV+DF1->DF1_LOJDEV # DF1->DF1_CLIREM+DF1->DF1_LOJREM .and. DF1->DF1_CLIDEV+DF1->DF1_LOJDEV # DF1->DF1_CLIDES+DF1->DF1_LOJDES )

								M->DTC_DEVFRE 	:= '2'
								M->DTC_CDRDES	:=	GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV,1,'')
								M->DTC_CDRCAL	:=	M->DTC_CDRDES
								M->DTC_CLICAL	:=	DT6->DT6_CLIDEV
								M->DTC_LOJCAL	:=	DT6->DT6_LOJDEV
								M->DTC_NOMCAL	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV,1,'' )
								M->DTC_INSDES	:=	GetAdvFVal('SA1','A1_INSCR',xFilial('SA1')+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV,1,'' )
								M->DTC_SQIDES	:=	'01'

							EndIf

						EndIf
					//	---	Preenche demais campos
						M->DTC_SERTMS	:=	Iif( _cOrigem == "DF1",GetAdvFVal('DC5','DC5_SERTMS',xFilial('DC5')+DF1->DF1_SERVIC,1,''),'3')
						M->DTC_SERVIC	:=	Iif( _cOrigem == "DF1",DF1->DF1_SERVIC , GetAdvFVal('DF1','DF1_SERVIC',xFilial('DF1')+DT6->DT6_NUMAGD+DT6->DT6_ITEAGD,1,'') )
						M->DTC_DESSER	:=	Posicione("SX5",1,xFilial('SX5')+'L4'+Iif(_cOrigem == "DF1",DF1->DF1_SERVIC, M->DTC_SERVIC ),"X5DESCRI()")
						M->DTC_TIPTRA	:=	Iif(_cOrigem == "DF1",DF1->DF1_TIPTRA, GetAdvFVal('DF1','DF1_TIPTRA',xFilial('DF1')+DT6->DT6_NUMAGD+DT6->DT6_ITEAGD,1,'') )
						M->DTC_DESTPT	:=	TMSValField( Iif(_cOrigem=='DF1',"DF1->DF1_TIPTRA", M->DTC_TIPTRA ),.F.,"DTC_DESTPT")
						M->DTC_TIPNFC	:=	'0'
						M->DTC_TIPFRE	:=	Iif(_cOrigem == "DF1",DF1->DF1_TIPFRE, '2' )
					// M->DTC_SELORI	:=	Iif(_cOrigem == "DF1",DF1->DF1_SELORI, GetAdvFVal('DF1','DF1_SELORI',xFilial('DF1')+DT6->DT6_NUMAGD+DT6->DT6_ITEAGD,1,'') )
						M->DTC_SELORI	:=	Iif(_cOrigem == "DF1",DF1->DF1_LOCCOL, GetAdvFVal('DF1','DF1_SELORI',xFilial('DF1')+DT6->DT6_NUMAGD+DT6->DT6_ITEAGD,1,'') )
						M->DTC_CDRORI	:=	Iif(_cOrigem == "DF1",DF1->DF1_CDRORI, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+DT6->DT6_CLIREM+DT6->DT6_LOJREM,1,'') )
						M->DTC_DISTIV	:=	Iif(_cOrigem == "DF1",DF1->DF1_DISTIV, '3')

// -- Por: Ricardo Guimarães - Em: 23/11/2016					
						// M->DTC_KM		:= 	Iif(_cOrigem == "DF1",DF1->DF1_KMFRET, GetAdvFVal('DF1','DF1_KMFRET',xFilial('DF1')+DT6->DT6_NUMAGD+DT6->DT6_ITEAGD,1,M->DTC_KM) )
						M->DTC_KM		:= 	Iif(_cOrigem == "DF1",GetAdvFVal('DF0','DF0_KMPLAN',xFilial('DF0')+DT6->DT6_NUMAGD,1,M->DTC_KM), GetAdvFVal('DF1','DF1_KMFRET',xFilial('DF1')+DT6->DT6_NUMAGD+DT6->DT6_ITEAGD,1,M->DTC_KM) )

						If ExistTrigger('DTC_CLIREM')
						// ---	Verifica se existe trigger para este campo
							RunTrigger(1,nil,nil,,'DTC_CLIREM')
						Endif

						If ExistTrigger('DTC_CLIDES')
						// ---	Verifica se existe trigger para este campo
							RunTrigger(1,nil,nil,,'DTC_CLIDES')
						Endif

						If ExistTrigger('DTC_CDRDES')
						// ---	Verifica se existe trigger para este campo
							RunTrigger(1,nil,nil,,'DTC_CDRDES')
						Endif

						If ExistTrigger('DTC_CDRCAL')
						// ---	Verifica se existe trigger para este campo
							RunTrigger(1,nil,nil,,'DTC_CDRCAL')
						Endif

						If ExistTrigger('DTC_SERTMS')
						// ---	Verifica se existe trigger para este campo
							RunTrigger(1,nil,nil,,'DTC_SERTMS')
						Endif

				//	--- Atualiza somente campos de identificacao do remetente e destinatario
					Else

					//	---	Nome Remetente e destinatario
						M->DTC_NOMREM	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+M->DTC_CLIREM+M->DTC_LOJREM,1,'' )
						M->DTC_DATENT	:=	dDataBase
						M->DTC_NOMDES	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+M->DTC_CLIDES+M->DTC_LOJDES,1,'' )
					//	---	Inscricao estatual do remetente e destinatario
						M->DTC_INSREM	:=	GetAdvFVal('SA1','A1_INSCR',xFilial('SA1')+M->DTC_CLIREM+M->DTC_LOJREM,1,'' )
						M->DTC_SQIREM	:=	'01'
						M->DTC_INSDES	:=	GetAdvFVal('SA1','A1_INSCR',xFilial('SA1')+M->DTC_CLIDES+M->DTC_LOJDES,1,'' )
						M->DTC_SQIDES	:=	'01'

					//	---	Regiao de origem
						M->DTC_CDRORI	:=	GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+M->DTC_CLIREM+M->DTC_LOJREM,1,'')
						M->DTC_CDRDES	:=	GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+M->DTC_CLIDES+M->DTC_LOJDES,1,'')
						M->DTC_CDRCAL	:=	M->DTC_CDRDES

					//	---	Verifica o devedor e preenche os campos
					//	--- Remetente
						If	M->DTC_DEVFRE == 	'1'

							M->DTC_CLIDEV	:=	M->DTC_CLIREM
							M->DTC_LOJDEV	:=	M->DTC_LOJREM
							M->DTC_NOMDEV	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+M->DTC_CLIREM+M->DTC_LOJREM,1,'' )
							M->DTC_CDRCAL	:=	M->DTC_CDRORI
							M->DTC_CLICAL	:=	M->DTC_CLIDEV
							M->DTC_LOJCAL	:=	M->DTC_LOJDEV
							M->DTC_NOMCAL	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+M->DTC_CLICAL+M->DTC_LOJCAL,1,'' )

	                //	---	Destinatario
						ElseIf M->DTC_DEVFRE == '2'

							M->DTC_CLIDEV	:=	M->DTC_CLIDES
							M->DTC_LOJDEV	:=	M->DTC_LOJDES
							M->DTC_NOMDEV	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+M->DTC_CLIDEV+M->DTC_LOJDEV,1,'')
							M->DTC_CDRCAL	:=	M->DTC_CDRDES
							M->DTC_CLICAL	:=	M->DTC_CLIDEV
							M->DTC_LOJCAL	:=	M->DTC_LOJDEV
							M->DTC_NOMCAL	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+M->DTC_CLICAL+M->DTC_LOJCAL,1,'')

	                //	---	Consignatario
						ElseIf M->DTC_DEVFRE == '3'

							M->DTC_CLIDEV	:=	M->DTC_CLICON
							M->DTC_LOJDEV	:=	M->DTC_LOJCON
							M->DTC_NOMDEV	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+M->DTC_CLICON+M->DTC_LOJCON,1,'')
							M->DTC_CDRCAL	:=	GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+M->DTC_CLICON+M->DTC_LOJCON,1,'')
							M->DTC_CLICAL	:=	M->DTC_CLIDEV
							M->DTC_LOJCAL	:=	M->DTC_LOJDEV
							M->DTC_NOMCAL	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+M->DTC_CLICAL+M->DTC_LOJCAL,1,'')

						EndIf

						If ExistTrigger('DTC_CLIREM')
						// ---	Verifica se existe trigger para este campo
							RunTrigger(1,nil,nil,,'DTC_CLIREM')
						Endif

						If ExistTrigger('DTC_CLIDES')
						// ---	Verifica se existe trigger para este campo
							RunTrigger(1,nil,nil,,'DTC_CLIDES')
						Endif

						If ExistTrigger('DTC_CDRDES')
						// ---	Verifica se existe trigger para este campo
							RunTrigger(1,nil,nil,,'DTC_CDRDES')
						Endif

						If ExistTrigger('DTC_CDRCAL')
						// ---	Verifica se existe trigger para este campo
							RunTrigger(1,nil,nil,,'DTC_CDRCAL')
						Endif


					EndIf

				//	---	Grava campos no grid da tela de cadastro
					GDFieldPut('DTC_NUMNFC', SZ6->Z6_NUMNFE )
					GDFieldPut('DTC_SERNFC', SZ6->Z6_SERNFE )
					GDFieldPut('DTC_EMINFC', SZ6->Z6_DTEMIS )
					GDFieldPut('DTC_QTDVOL', _nQtdVol )
					GDFieldPut('DTC_PESO'  , _nPeso )
					GDFieldPut('DTC_PESOM3', _nPesoM3 )
					GDFieldPut('DTC_VALOR' , _nValor )
					GDFieldPut('DTC_CF'    , _cCFOP )
					GDFieldPut('DTC_NFEID' , M->DTC_XNFEID )
					GDFieldPut('DTC_CODEMB', 'CX')

				//	---	Força gravação do produto de transporte
					If Empty(GDFieldGet('DTC_CODPRO'))
						GDFieldPut('DTC_CODPRO', 'PECAS')
					EndIf

				//	---	Atualizar objetos

					If UPPER(Alltrim(Funname())) <> "LOCT004"

						o1Get:Refresh()
						o1Get:oBrowse:Refresh()

					//	---	[2LGI] Fim ajuste
					//	---	Valida a linha e adiciona proxima
						If TMSA050LinOk()
							o1Get:AddLine()        	//Adiciona uma linha nova
						EndIf

					EndIf

				Else
					MsgInfo("NF-e localizada na tabela(SZ6) mas o XML está com erro de leitura : " + Chr(13) + cErro + Chr(13) + "Favor digitar as informações complementares.","Informação")

					_cNumNFE   := SZ6->Z6_NUMNFE
					_cSerNFE	:= SZ6->Z6_SERNFE

					aCols[N,_nPosNumNFC] := _cNumNFE
					aCols[N,_nPosSerNFC] := _cSerNFE

					_lRetorno := .T.
					Loop
				// _lRetorno := .F.
				EndIf
			EndIf
		Else
	    // _lRetorno := .F.
//		MsgInfo("NF-e não localizada na tabela(SZ6) de XML.  Favor digitar as informações complementares.","Informação")
			MsgInfo("NF-e não localizada na tabela(SZ6) de XML.  A rotina irá iniciar a busca na SEFAZ através do WS da SIM Consulta.","Informação.")

		// Dispara o WS da Sim Consulta
			_lRetSIM := .F.
		// _cHorIni := Time()
			Processa( {|| _lRetSIM := U_SIMBuscaXML(_cIDNF), "Aguarde... buscando XML na WEB(SIM Consulta). Inicio: " + _cHorIni } )

		// MsgInfo("Hora Inicial: " + _cHorIni + chr(13) +;
		//         "Hora Final  : " + Time() ,"Informação")

			_lRetorno := .T.

			If _lRetSIM
				LOOP
			Else
			// Por: Ricardo Guimarães - Em: 03/03/2015
				If ValType(oWSSimErro)	== "O"
					_cCodigo := oWSSimErro:_StatusConsulta:Text
					_cTexto	 := oWSSimErro:_StatusDescricao:Text

					MsgInfo("Retorno do WS da SIM Consutla: " + CHR(13) + _cTexto,"Informação.")

				Else
					MsgInfo("Chave da NF-e não localizada na SEFAZ (SIM Consulta).","Informação.")
				EndIf

				Exit
			EndIf

		EndIf

		Exit  // Sai do Loop
	End // Do/EndDo

//aCols[Len(aCols)][nPos] := TRB1->CNA_CONTRA
	RestArea(aAreaSA1)
	RestArea(_aArea)

//	---	Limpa campo para permitir nova leitura ou sair

	M->DTC_XNFEID	:= Space(TamSX3('DTC_XNFEID')[1])

	If UPPER(Alltrim(Funname())) <> "LOCT004"
		_lRetorno		:= .f.
	EndIf

Return _lRetorno

*********************************
User Function gdChangeLine()

	o1Get:AddLine()        //Adiciona uma linha nova
//o1Get:oBrowse:nColPos := nCol1   //Muda a coluna para a 1
	o1Get:Refresh() //Atualiza a Getdados
	o1Get:oBrowse:Refresh() //Atualiza a Getdados do browse em tela.

Return(.t.)

/************************************************************************
* Funcao....: isCliPSA()                                                *
* Autor.....: Marcelo Aguiar Pimentel                                   *
* Data......: 14/03/2007                                                *
* Descricao.: Verifica se o cliente está cadastrado na tabela SZE(Clien *
*             Peugeot PSA                                               *
*                                                                       *
************************************************************************/
Static Function isCliPSA(pCliente,lCodSap)
	Local lRet:=.t.

	dbSelectArea("SZE")
	dbSetOrder(1)

	If !dbSeek(xFilial("SZE")+pCliente)
		lRet:=.f.
	ElseIf lCodSap
/*	If AllTrim(SZE->ZE_CODSAP) == 'BR30' --Marcos Furtado 27/06/2007 - estava ignorando o cliente Peugeot de Porto Real.
		lRet:=.f.
	EndIf*/
	EndIf

Return lRet


/************************************************************************
* Funcao....: VldCtaPSA()                                               *
* Autor.....: Ricardo Guimarães                                         *
* Data......: 05/11/2013                                                *
* Descricao.: Verifica se a operação é OVL e sendo valida CC x Conta    *
*             Cliente PSA                                               *
*                                                                       *
************************************************************************/
User Function VldCtaPSA()
	If isCliPSA(Alltrim(M->DTC_CLIDEV))
		If Left(M->DTC_CCUSTO,3) $ AllTrim(GETMV("MV_XOVLCC")) .AND. AllTrim(M->DTC_CCONT) $ AllTrim(GETNewPar("MV_CCPSAOV","28230|28510|78430|98270|98310|98320|98540|98750|98760|98770|A8180|A8188|B4803|B5810|B8155|B8194|C4810|C8125|C8140|C8160|D5820|D8155|D8502|D8503|E8135"))
			If Alltrim(M->DTC_CONTA) <> GETNewPar("MV_CTPSAOV","62480000")
	   		// Aviso("Atencao","Para operações do OVL e CC PSA " + AllTrim(M->DTC_CCONT) + ", a conta PSA deve ser " + GETNewPar("MV_CTPSAOV","62480000"),{"Continuar"})
				M->DTC_CONTA := GETNewPar("MV_CTPSAOV","62480000")
			EndIf
		EndIf
	EndIf
Return .T.

/************************************************************************
* Funcao....: fVldRotaValeo()                                            *
* Autor.....: Ricardo Guimarães                                         *
* Data......: 11/04/2014                                                *
* Descricao.: Verifica se a ROTA existe numa lista pré definida         *
*             Cliente VALEO                                             *
*                                                                       *
************************************************************************/
User Function fVldRotaValeo(_cRota)  // FORA DE USO - 02/10/2014
	Local _nRotaIni := Val(Left(AllTrim(FORMULA("VAL")),5))
	Local _nRotaFin := Val(Right(AllTrim(FORMULA("VAL")),5))
	Local _cRotasAux:= ""
	Local _cRotas   := ""
	Local _aRotas   := {}
	Local _nX       := 0
	Local _lRetorno := .F.
	Local _cCliVALEO:= AllTrim(GETNewPar("MV_XCLIVALEO","02694400|"))

//If ((M->DTC_CLIREM + M->DTC_LOJREM) $ _cCliVALEO .OR. (M->DTC_CLIDES  + M->DTC_LOJREM) $ _cCliVALEO) .AND. Left(M->DTC_CCUSTO,3) $ AllTrim(GETMV("MV_XOVLCC"))
	If (M->DTC_CLIDEV + M->DTC_LOJDEV) $ _cCliVALEO .AND. Left(M->DTC_CCUSTO,3) $ AllTrim(GETMV("MV_XOVLCC"))

		For _nX := _nRotaIni To _nRotaFin
		// _cRotas += "GE"+StrZero(_nX,5)+"000|"
			_cRotasAux := "GE"+StrZero(_nX,5)+"000"
			_cRotas    += "GE"+StrZero(_nX,5)+"000|"
			AADD(_aRotas, _cRotas )
		Next _nX

		If AllTrim(_cRota) $ _cRotas
			_lRetorno := .T.
		Else
		// MsgInfo("Rota informada inválida." + Chr(13) + "Rotas Válidas: " + Chr(13) + _cRotas ,"Informação")
			_nItem := fViewRotas(_aRotas)
			M->DTC_XROTA := _aRotas[_nItem]
			_lRetorno := .T.
		EndIf
	Else
		_lRetorno := .T.
	EndIf

Return _lRetorno

************************************
Static Function fViewRotas(_aRotas)
************************************
	Local oListBox1
	Local nListBox1 := 1
	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Rotas válidas - VALEO" FROM 000, 000  TO 320, 175 COLORS 0, 16777215 PIXEL

	@ 002, 004 LISTBOX oListBox1 VAR nListBox1 ITEMS _aRotas SIZE 080, 152 OF oDlg COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

Return nListBox1
