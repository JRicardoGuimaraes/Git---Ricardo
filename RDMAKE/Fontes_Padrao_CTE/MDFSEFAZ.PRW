#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³XmlMdfSef ³ Autor ³ Katia                 ³ Data ³02.04.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rdmake de exemplo para geracao do Manifesto Eletronico da   ³±±
±±³          ³SEFAZ - Versao 1.00                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³String do MDFe                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Tipo do MDFe                                         ³±±
±±³          ³       [1] Envio                                            ³±±
±±³          ³       [2] Encerramento                                     ³±±
±±³          ³       [3] Cancelamento                                     ³±±
±±³          ³ExpC2: Filial de Origem                                     ³±±
±±³          ³ExpC3: Numero da Viagem                                     ³±±
±±³          ³ExpC4: Filial do Manifesto                                  ³±±
±±³          ³ExpC5: Numero do Manifesto                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function XmlMdfSef()           

Local cString     := ""
Local nSerieMDF   := 0
Local aXMLMDFe    := {}
Local cDV         := ''
Local nMDF        := ''
Local cMDF        := ''
Local cChvAcesso  := ''
Local nCount      := 0 
Local cCodUF      := ''
Local cTpEmis     := ''
Local cUFIni      := ''
Local cCdMunIni	  := ''
Local cCidIni     := ''
Local cNFe        := ""
Local cTmsAntt    := SuperGetMv( "MV_TMSANTT", .F., .F. )
Local cCodVei     := ''
Local cAliasDTR   := ''
Local nX          := 0
Local nCapcM3     := 0 
Local cAliasDA4   := ''
Local cAliasDVB   := ''
Local cAliasDUD   := ''
Local cAliasDT6   := ''
Local lChvCTG     := DT6->(FieldPos('DT6_CHVCTG')) > 0
Local cFilDCAOld  := ''
Local cObs		  := ''
Local cQuery      := ''
Local cAliasDTX   := ''
Local aAreaDTX    := {}         
Local cFilMan     := PARAMIXB[1]
Local cNumMan     := PARAMIXB[2]
Local cAmbiente   := PARAMIXB[3]
Local cVerAmb     := PARAMIXB[4]
Local cModalidade := PARAMIXB[5]
Local cEvento     := PARAMIXB[6]
Local cUFPer      := ""
Local cFilOri     := ""
Local cViagem     := "" 
Local cAliasDUN   := ""                     
Local cSeqIni     := StrZero(0,Len(DUN->DUN_SEQUEN))
Local cSeqFim     := StrZero(0,Len(DUN->DUN_SEQUEN))
Local nCont       := 0      
Local nQtdCte     := 0
Local nQtdCtr     := 0
Local cMdfeDoc    := SuperGetMV('MV_MDFEDOC',,'')
Local aTipoDoc	  := Iif(!Empty(cMdfeDoc),Str2Arr(Upper(cMdfeDoc), ","),'')  //quebra em array por delimitador ","
Local lRet        := .T.
Local aPercurso   := {}   
Local nPos        := 0

Private aUF       := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenchimento do Array de UF                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aUF,{"RO","11"})
aAdd(aUF,{"AC","12"})
aAdd(aUF,{"AM","13"})
aAdd(aUF,{"RR","14"})
aAdd(aUF,{"PA","15"})
aAdd(aUF,{"AP","16"})
aAdd(aUF,{"TO","17"})
aAdd(aUF,{"MA","21"})
aAdd(aUF,{"PI","22"})
aAdd(aUF,{"CE","23"})
aAdd(aUF,{"RN","24"})
aAdd(aUF,{"PB","25"})
aAdd(aUF,{"PE","26"})
aAdd(aUF,{"AL","27"})
aAdd(aUF,{"MG","31"})
aAdd(aUF,{"ES","32"})
aAdd(aUF,{"RJ","33"})
aAdd(aUF,{"SP","35"})
aAdd(aUF,{"PR","41"})
aAdd(aUF,{"SC","42"})
aAdd(aUF,{"RS","43"})
aAdd(aUF,{"MS","50"})
aAdd(aUF,{"MT","51"})
aAdd(aUF,{"GO","52"})
aAdd(aUF,{"DF","53"})
aAdd(aUF,{"SE","28"})
aAdd(aUF,{"BA","29"})
aAdd(aUF,{"EX","99"})

If cEvento == "I" //-- Envio Manifesto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona MDF                                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("DTX")
	dbSetOrder(2)
	If dbSeek(xFilial("DTX")+cFilMan+cNumMan)

		cFilOri := DTX->DTX_FILORI
		cViagem := DTX->DTX_VIAGEM
		
		cString := ''
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Header do Arquivo XML                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString += '<MDFe xmlns="http://www.portalfiscal.inf.br/mdfe">'

		aAdd(aXMLMDFe,AllTrim(cString))
				
		If aScan(aUF,{|x| x[1] ==  AllTrim(SM0->M0_ESTENT) }) != 0 // Confere se Uf do Emitente esta OK
			cCodUF := aUF[ aScan(aUF,{|x| x[1] == AllTrim(SM0->M0_ESTENT) }), 2]
		Else
			cCodUF := ''
		EndIf                                                
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Formato de Impressao do MDF-e                                   ³
		//³ 1 - Normal                                                      ³
		//³ 2 - Contingência                   								³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cModalidade == '1'
			cTpEmis := '1'
		ElseIf cModalidade == '2'
			cTpEmis := '2'
		EndIf
				
		cDV := cTpEmis + Inverte(StrZero( val(PadR(DTX->DTX_MANIFE,8)), 8))
		
		cChvAcesso := MDFCHVAC( cCodUF,;
							   ( SubStr(DToS(DTX->DTX_DATMAN),3, 2) +  SubStr(DToS(DTX->DTX_DATMAN),5, 2) ),;
							    AllTrim(SM0->M0_CGC),;
								 '58',;
								 StrZero( nSerieMDF, 3),;
								 StrZero( val(PadR(DTX->DTX_MANIFE,9)), 9),;
								 cDV)								 

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicio dos Dados do MDFe                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cDV := Inverte(StrZero( val(Padr(DTX->DTX_MANIFE,8)), 8))
		cNFe    := 'MDFe' + AllTrim(cChvAcesso)
		cString := ''
					
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Versao do MDF-e, de acordo com o parametro                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString += '<infMDFe Id="MDFe' + AllTrim(cChvAcesso) + '" versao="' + cVerAmb + '">'
								
		aAdd(aXMLMDFe,AllTrim(cString))
					
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TAG: IDE -- Identificacao do MDF-e                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Identificacao do Ambiente.                                      ³
		//³ 1 - Producao                                                    ³
		//³ 2 - Homologacao                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                         
		cString:= ""
		cString += '<ide>'
		cString += '<cUF>'  + NoAcentoCte( cCodUF )	 + '</cUF>'
		cString += '<tpAmb>' + cAmbiente + '</tpAmb>'          		
		cString += '<tpEmit>1</tpEmit>'   
		cString += '<mod>58</mod>'                  
		cString += '<serie>' + StrZero( nSerieMDF, 1) + '</serie>'		
		cString += '<nMDF>'+ NoAcentoCte( cValtoChar( Val( AllTrim(DTX->DTX_MANIFE) ) ) ) + '</nMDF>'

		cMDF := Inverte(StrZero( val(DTX->DTX_MANIFE), 8))                                           
		
		cString += '<cMDF>'+ NoAcentoCte(cMDF) + '</cMDF>'
		
		cString += '<cDV>' + SubStr( AllTrim(cChvAcesso), Len( AllTrim(cChvAcesso) ), 1) + '</cDV>'

		cString += '<modal>1</modal>'  //Rodoviario
		
		cString += '<dhEmi>'+ SubStr(DToS(DTX->DTX_DATMAN), 1, 4) + "-";
							+ SubStr(DToS(DTX->DTX_DATMAN), 5, 2) + "-";
							+ SubStr(DToS(DTX->DTX_DATMAN), 7, 2) + "T";
							+ SubStr(AllTrim(DTX->DTX_HORMAN), 1, 2) + ":";
							+ SubStr(AllTrim(DTX->DTX_HORMAN), 3, 2) + ':00</dhEmi>'

		cString += '<tpEmis>' + cTpEmis + '</tpEmis>'

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processo de Emissao do CT-e                                     ³
		//³ 0 - emissao com aplicativo do contribuinte                      ³
		//³ 3 - pelo contribuinte com aplicativo fornecido pelo Fisco       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString += '<procEmi>0</procEmi>'
		
		cString += '<verProc>' + cVerAmb + '</verProc>'                                     

		aAreaSM0 := SM0->(GetArea())
		cUFIni   := Posicione("SM0",1,cEmpAnt+DTX->DTX_FILMAN,"M0_ESTENT")      			
		cCdMunIni:= Posicione("SM0",1,cEmpAnt+DTX->DTX_FILMAN,"M0_CODMUN")
		cCidIni  := Posicione("SM0",1,cEmpAnt+DTX->DTX_FILMAN,"M0_CIDENT")
		
		cString += '<UFIni>' + NoAcentoCte(cUFIni) + '</UFIni>'   	
		cString += '<UFFim>' + Posicione("SM0",1,cEmpAnt+DTX->DTX_FILDCA,"M0_ESTENT") + '</UFFim>'   
		RestArea(aAreaSM0)

		cString += '<infMunCarrega>'  
		cString += '<cMunCarrega>' + NoAcentoCte(cCdMunIni) + '</cMunCarrega>'
		cString += '<xMunCarrega>' + NoAcentoCte(cCidIni) + '</xMunCarrega>'
		cString += '</infMunCarrega>'     
		                                                         
		cUFPer:= "'" + AllTrim(DTX->DTX_FILMAN) + "','" + AllTrim(DTX->DTX_FILDCA) + "'"  //Uf Inicial e Final do Manifesto 
	                                  
	    DTQ->(DbSetOrder(2))
		If DTQ->(MsSeek(xFilial("DTQ")+DTX->DTX_FILORI+DTX->DTX_VIAGEM)) .And. DTQ->DTQ_SERTMS == StrZero(2,Len(DTQ->DTQ_SERTMS))  
		
	 		
			cAliasDUN := GetNextAlias()
			cQuery := " SELECT DUN_FILDES, DUN_SEQUEN "
			cQuery += "   FROM " + RetSqlName("DUN") 
			cQuery += " WHERE DUN_FILIAL = '" + xFilial('DUN') + "' "
			cQuery += "   AND DUN_ROTEIR = '" + DTQ->DTQ_ROTA + "' "  
			cQuery += "   AND D_E_L_E_T_ = ' ' "
			cQuery += " ORDER BY DUN_ROTEIR, DUN_SEQUEN "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDUN)		
			While (cAliasDUN)->(!Eof())
				If (cAliasDUN)->DUN_FILDES == DTX->DTX_FILMAN  //Inicio Percurso
					cSeqIni:= (cAliasDUN)->DUN_SEQUEN 
				EndIf
				If (cAliasDUN)->DUN_FILDES == DTX->DTX_FILDCA  //Final do Percurso
				    cSeqFim:= (cAliasDUN)->DUN_SEQUEN 
				EndIf 
				(cAliasDUN)->(DbSkip())
			EndDo
	 		(cAliasDUN)->(DbCloseArea())
	 		
			cAliasDUN := GetNextAlias()
			cQuery := " SELECT DUN_FILDES, DUN_CDRDES "
			cQuery += "   FROM " + RetSqlName("DUN") 
			cQuery += " WHERE DUN_FILIAL = '" + xFilial('DUN') + "' "
			cQuery += "   AND DUN_ROTEIR = '" + DTQ->DTQ_ROTA + "' "  
	   		cQuery += "   AND DUN_SEQUEN >= '" + cSeqIni + "' "
	   		cQuery += "   AND DUN_SEQUEN <= '" + cSeqFim + "' "       
	   		cQuery += "   AND DUN_FILDES NOT IN (" + cUfPer + ") "		
			cQuery += "   AND D_E_L_E_T_ = ' ' "
			cQuery += " ORDER BY DUN_ROTEIR, DUN_SEQUEN "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDUN)		
			While (cAliasDUN)->(!Eof())                    
				DUY->(DbSetOrder(1))
				If DUY->(MsSeek(xFilial("DUY")+(cAliasDUN)->DUN_CDRDES))
					If ( nPos:= Ascan(aPercurso, { | x | x == DUY->DUY_EST } ) ) == 0   //Nao repetir a mesma UF 
						Aadd( aPercurso, DUY->DUY_EST )
					EndIf
				EndIf
				(cAliasDUN)->(DbSkip())
			EndDo						
			(cAliasDUN)->(DbCloseArea())
			
			If Len(aPercurso) > 0	            
				For nCount:= 1 to Len(aPercurso)
					If nCount <= 25
						cString += '<infPercurso>' 
						cString += '<UFPer>' + NoAcentoCte( aPercurso[nCount] ) + '</UFPer>'
						cString += '</infPercurso>'
					EndIf 			
				Next nCount
			EndIf

		EndIf                   
        
        cString += '</ide>'

		aAdd(aXMLMDFe,AllTrim(cString))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TAG: Emit -- Identificacao do Emitente do Manifesto              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString := ''
		cString += '<emit>'
		cString += '<CNPJ>' + NoPontos(SM0->M0_CGC) + '</CNPJ>'
			
		If (AllTrim(SM0->M0_INSC) == 'ISENTO')
			cString += '<IE>ISENTO</IE>'
		Else
			cString += '<IE>' + NoPontos(SM0->M0_INSC) + '</IE>'
		EndIf
					
		cString += '<xNome>' + NoAcentoCte(SubStr(SM0->M0_NOMECOM,1,60)) + '</xNome>'
		cString += '<xFant>' + NoAcentoCte(SM0->M0_NOME) + '</xFant>'
		cString += '<enderEmit>'
		cString += '<xLgr>' + NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[1]) + '</xLgr>'
		cString += '<nro>'  + Iif(FisGetEnd(SM0->M0_ENDENT)[2]<>0, AllTrim(cValtoChar( FisGetEnd(SM0->M0_ENDENT)[2])),"S/N") + '</nro>'
		If !Empty(NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[4]))
			cString += '<xCpl>' + NoAcentoCte(FisGetEnd(SM0->M0_ENDENT)[4]) + '</xCpl>'
		EndIf
		If Empty(AllTrim(SM0->M0_BAIRENT))
			cString += '<xBairro>BAIRRO NAO CADASTRADO</xBairro>'
		Else
			cString += '<xBairro>' + NoAcentoCte( SM0->M0_BAIRENT ) + '</xBairro>'
		EndIf
					
		cString += '<cMun>' + NoAcentoCte( SM0->M0_CODMUN ) + '</cMun>'
		cString += '<xMun>' + NoAcentoCte( SM0->M0_CIDENT ) + '</xMun>'
		cString += '<CEP>'  + NoAcentoCte( SM0->M0_CEPENT ) + '</CEP>'
		cString += '<UF>'   + NoAcentoCte( SM0->M0_ESTENT ) + '</UF>'
		If !Empty (NoPontos(SM0->M0_TEL))
			cString += '<fone>' + cValtoChar(NoPontos(SM0->M0_TEL))      + '</fone>'
		EndIf
		cString += '</enderEmit>'
		cString += '</emit>'

		aAdd(aXMLMDFe,AllTrim(cString))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TAG: InfModal -- Informacoes do modal Rodoviario                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString:= ""
		cString += '<infModal versaoModal="'+cVerAmb+'">'
		cString += '<rodo>'		
		cString += '<RNTRC>' + SubStr(AllTrim(cTmsAntt),1,8) + '</RNTRC>'	
		
		cAliasDTR := GetNextAlias()                           
		                                              
		If DTR->(FieldPos('DTR_CIOT')) > 0
			cQuery    := "SELECT DTR_CODVEI, DTR_CODRB1, DTR_CODRB2, DTR_CIOT, DTR_ITEM  "
		Else                                                          
			cQuery    := "SELECT DTR_CODVEI, DTR_CODRB1, DTR_CODRB2  "
		EndIf	
		cQuery    += " FROM " + RetSqlName("DTR")+" DTR "
		cQuery    += " WHERE DTR_FILIAL = '"+xFilial('DTR')+"'"
		cQuery    += "   AND DTR_FILORI = '"+DTX->DTX_FILORI+"'"
		cQuery    += "   AND DTR_VIAGEM = '"+DTX->DTX_VIAGEM+"'"
		cQuery    += "   AND DTR.D_E_L_E_T_ = ' '"
		cQuery    := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDTR,.F.,.T.)
		If (cAliasDTR)->(!Eof())
		
			cCodVei:= ''
			For nX := 1 To 3                                              
				If nX == 1                                                
					If DTR->(FieldPos('DTR_CIOT')) > 0 .And. !Empty((cAliasDTR)->DTR_CIOT)
						cString += '<CIOT>' + SubStr(AllTrim((cAliasDTR)->DTR_CIOT),1,12) + '</CIOT>'			
					EndIf                                    
					cCodVei := (cAliasDTR)->DTR_CODVEI
				ElseIf nX == 2
					If !Empty((cAliasDTR)->DTR_CODRB1)
						cCodVei := (cAliasDTR)->DTR_CODRB1
					Else
						Exit
					EndIf
				ElseIf !Empty((cAliasDTR)->DTR_CODRB2)
					cCodVei := (cAliasDTR)->DTR_CODRB2
				Else
					Exit
				EndIf
				
				cAliasDA3 := GetNextAlias()
				cQuery := ""
				cQuery += " SELECT DA3_COD   , DA3_PLACA , DA3_RENAVA, DA3_TARA  ,DA3_CAPACM, DA3_FROVEI, " + CRLF
				cQuery += "        DA3_ESTPLA, DA3_CODFOR, DA3_LOJFOR, DUT_TIPROD, DUT_TIPCAR, "            + CRLF
				cQuery += "        DA3_ALTINT, DA3_LARINT, DA3_COMINT, "                                    + CRLF
				cQuery += "        A2_CGC    , A2_NOME   , A2_INSCR  , A2_EST    , A2_TIPO  , A2_RNTRC,    " + CRLF
				cQuery += "        A2_TPRNTRC, A2_EQPTAC     " + CRLF
				cQuery += " FROM " + RetSqlName("DA3") + " DA3 " + CRLF

				cQuery += " INNER JOIN " + RetSqlName("DUT") + " DUT " + CRLF
				cQuery += "   ON DUT.DUT_TIPVEI = DA3.DA3_TIPVEI " + CRLF
				cQuery += "   AND DUT.D_E_L_E_T_ = ' ' " + CRLF

				cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 ON " + CRLF
				cQuery += "           SA2.A2_COD    = DA3.DA3_CODFOR AND " + CRLF
				cQuery += "           SA2.A2_LOJA   = DA3.DA3_LOJFOR AND " + CRLF
				cQuery += "           SA2.D_E_L_E_T_= '' " + CRLF

				cQuery += " WHERE DA3.DA3_FILIAL = '"+xFilial("DA3")+"'" + CRLF
				cQuery += "   AND DA3.DA3_COD    = '"+cCodVei+"'"        + CRLF
				cQuery += "   AND DA3.D_E_L_E_T_ = ' '"                  + CRLF
				cQuery += "   AND DUT.DUT_FILIAL = '"+xFilial('DUT')+"'" + CRLF
				cQuery += "   AND SA2.A2_FILIAL  = '"+xFilial('SA2')+"'" + CRLF
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDA3,.F.,.T.)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ TAG: Veic -- Tag com informacoes do veiculo                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nX == 1
					cString += '<veicTracao>'
				Else
					cString += '<veicReboque>'
				EndIf
					
				cString += '<cInt>'    + NoAcentoCte((cAliasDA3)->DA3_COD)    + '</cInt>'
				cString += '<placa>'   + NoAcentoCte((cAliasDA3)->DA3_PLACA)  + '</placa>'
				cString += '<tara>'    + ConvType(((cAliasDA3)->DA3_TARA) 	, 6,0, "N")    + '</tara>'
				cString += '<capKG>'   + ConvType(((cAliasDA3)->DA3_CAPACM) , 6, 0, "N") + '</capKG>'
				//Converte Valor da capacidade em KG para M3
				nCapcM3 := Round((cAliasDA3)->DA3_ALTINT * (cAliasDA3)->DA3_LARINT * (cAliasDA3)->DA3_COMINT,0)
				cString += '<capM3>'   + ConvType((nCapcM3) , 3, 0, "N") + '</capM3>'

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ TAG: Prop -- Se o veiculo for de terceiros, preencher tags com  ³
				//³ informacoes do proprietário                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (cAliasDA3)->DA3_FROVEI <> '1'
					cString += '<prop>'
					If Len(Alltrim((cAliasDA3)->A2_CGC)) > 11
						cString += '<CNPJ>'	+ NoAcentoCte( (cAliasDA3)->A2_CGC )	+ '</CNPJ>'
					Else
						cString += '<CPF>'	+ NoAcentoCte( (cAliasDA3)->A2_CGC )	+ '</CPF>'
					EndIf
					
					If !Empty((cAliasDA3)->A2_RNTRC)
						cString += '<RNTRC>' + StrZero(Val(AllTrim((cAliasDA3)->A2_RNTRC)),8) + '</RNTRC>'
					EndIf
					
					cString += '<xNome>'+ NoAcentoCte((cAliasDA3)->A2_NOME) + '</xNome>'
					
					If Empty((cAliasDA3)->A2_INSCR) .Or. 'ISENT' $ Upper(AllTrim((cAliasDA3)->A2_INSCR))
						cString += '<IE></IE>'
					Else
						cString += '<IE>' + NoPontos((cAliasDA3)->A2_INSCR) + '</IE>'
					EndIf	
					
					cString += '<UF>'		+ NoAcentoCte( (cAliasDA3)->A2_EST )		+ '</UF>'
					
					If ((cAliasDA3)->A2_TPRNTRC = '1' .OR. (cAliasDA3)->A2_EQPTAC = '1') .And. (cAliasDA3)->DA3_FROVEI = '3'  //TAC Agregado 
						cString += '<tpProp>0</tpProp>'
					ElseIf( (cAliasDA3)->A2_TPRNTRC = '1' .OR. (cAliasDA3)->A2_EQPTAC = '1') .And. (cAliasDA3)->DA3_FROVEI = '2'  //TAC Independente
						cString += '<tpProp>1</tpProp>'
					Else //Outros
						cString += '<tpProp>2</tpProp>'
					EndIf
					
					cString += '</prop>'
				EndIf
                     
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ TAG: Condutor -- Condutor do Veiculo                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nX == 1
					cAliasDA4 := GetNextAlias()
					cQuery := " SELECT DA4_COD,DA4_NOME,DA4_CGC "
					cQuery += CRLF+" FROM " + RetSqlName("DA4") + " DA4 "
	        	
					cQuery += CRLF+" INNER JOIN " + RetSqlName("DUP") + " DUP ON "
					cQuery += CRLF+"        DUP.DUP_CODMOT = DA4.DA4_COD AND "
					cQuery += CRLF+"        DUP.D_E_L_E_T_ = '' "

					cQuery += CRLF+ " WHERE DA4_FILIAL     = '" + xFilial("DA4") + "' AND "
					cQuery += CRLF+ "       DUP.DUP_FILIAL = '" + xFilial("DUP") + "' AND "
					cQuery += CRLF+ "       DUP_FILORI     = '" + DTX->DTX_FILORI + "' AND "
					cQuery += CRLF+ "       DUP_VIAGEM     = '" + DTX->DTX_VIAGEM + "' AND "
					cQuery += CRLF+ "       DUP_ITEDTR     = '" + (cAliasDTR)->DTR_ITEM + "' AND "
					cQuery += CRLF+ "       DA4.D_E_L_E_T_ = '' "
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDA4,.F.,.T.)

					While (cAliasDA4)->(!Eof())
						cString += '<condutor>'
						cString +=   '<xNome>' + NoAcentoCte((cAliasDA4)->DA4_NOME) +'</xNome>
						cString +=   '<CPF>'   + AllTrim((cAliasDA4)->DA4_CGC) +'</CPF>'
						cString += '</condutor>'
						(cAliasDA4)->(dbSkip())
					EndDo
					(cAliasDA4)->(dbCloseArea())
					cString +=   '<tpRod>'   + AllTrim((cAliasDA3)->DUT_TIPROD) +'</tpRod>'
					
				EndIf		
				
				cString +=   '<tpCar>'   + AllTrim((cAliasDA3)->DUT_TIPCAR) +'</tpCar>'
				cString +=   '<UF>'   + AllTrim((cAliasDA3)->DA3_ESTPLA) +'</UF>'
				
				
				If nX == 1
					cString += '</veicTracao>'
				Else
					cString += '</veicReboque>'
				EndIf
	                                  
			Next nX			
		EndIf
		(cAliasDTR)->(dbCloseArea())

		cString += '</rodo>'
		cString += '</infModal>'                           
		
		aAdd(aXMLMDFe,AllTrim(cString)) 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TAG: InfDoc -- Informacoes dos Doctos Fiscais vinculados ao Manifesto ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		cString  := ""
		cString += '<infDoc>'                                      
                       
		nQtdCte:= 0
		nQtdCtr:= 0
		
		aAreaSM0  := SM0->(GetArea())
		cAliasDT6 := GetNextAlias()
		cQuery := " SELECT DUD_FILDOC, DUD_DOC, DUD_SERIE, DUD_FILATU, DUD_CDRDES, DUD_CDRCAL, DUD_FILDCA, DT6_DATEMI, DT6_CHVCTE, DT6_CHVCTG, DT6_VALMER, DT6_DOCTMS "
		cQuery += " FROM "
		cQuery += RetSqlName('DUD')+" DUD, "
		cQuery += RetSqlName('DT6')+" DT6  "
		cQuery += " WHERE DUD.DUD_FILIAL  = '"+xFilial("DUD")+"'"
		cQuery += "		AND DUD.DUD_FILORI  = '"+DTX->DTX_FILORI+"'"
		cQuery += "		AND DUD.DUD_VIAGEM  = '"+DTX->DTX_VIAGEM+"'"
		cQuery += "		AND DUD.DUD_FILMAN  = '"+DTX->DTX_FILMAN+"'"
		cQuery += "		AND DUD.DUD_MANIFE  = '"+DTX->DTX_MANIFE+"'"
		cQuery += "     AND DUD.DUD_STATUS <> '" + StrZero(9,Len(DUD->DUD_STATUS)) + "'" //Cancelado
		cQuery += "		AND DUD.D_E_L_E_T_  = ' '"
		cQuery += "		AND DT6.DT6_FILIAL  = '"+xFilial("DT6")+"'"
		cQuery += "		AND DT6.DT6_FILDOC  = DUD.DUD_FILDOC "
		cQuery += "		AND DT6.DT6_DOC     = DUD.DUD_DOC"
		cQuery += "		AND DT6.DT6_SERIE   = DUD.DUD_SERIE"
		cQuery += "		AND DT6.D_E_L_E_T_  = ' '"
		cQuery += " ORDER BY DUD.DUD_FILDCA, DT6.DT6_AMBIEN DESC"
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDT6,.T.,.T.)
		While (cAliasDT6)->(!Eof())	
			lRet:= .T.
			If Len(aTipoDoc) > 0 .And. Ascan(aTipoDoc,{|x| x == (cAliasDT6)->DT6_DOCTMS})  > 0
				lRet:= .F.
			EndIf         
			
			If lRet
			    If (cAliasDT6)->DUD_FILDCA <> cFilDCAOld		
			    	If !Empty(cFilDCAOld)
						cString += '</infMunDescarga>'
					EndIf	                          
					cString += '<infMunDescarga>'
					cString += '<cMunDescarga>' + NoAcentoCte(Posicione("SM0",1,cEmpAnt+(cAliasDT6)->DUD_FILDCA,"M0_CODMUN")) + '</cMunDescarga>'		
					cString += '<xMunDescarga>' + NoAcentoCte(Posicione("SM0",1,cEmpAnt+(cAliasDT6)->DUD_FILDCA,"M0_CIDENT")) + '</xMunDescarga>'		
	            EndIf
		        cFilDCAOld:= (cAliasDT6)->DUD_FILDCA                                       
		                    
				If !Empty((cAliasDT6)->DT6_CHVCTE) .Or. !Empty((cAliasDT6)->DT6_CHVCTG)
					cString += '<infCTe>'                              
					cString += '<chCTe>' + Iif(!Empty((cAliasDT6)->DT6_CHVCTE),(cAliasDT6)->DT6_CHVCTE,(cAliasDT6)->DT6_CHVCTG) + '</chCTe>'	
					                                                                                    
					If !Empty((cAliasDT6)->DT6_CHVCTG)
						cString += '<SegCodBarra>'+ (cAliasDT6)->DT6_CHVCTG + '</SegCodBarra>'
					EndIf	
					cString += '</infCTe>'         
					nQtdCte += 1				
				Else	
					cString += '<infCT>'                              
					cString += '<nCT>' + NoAcentoCte((cAliasDT6)->DUD_DOC) + '</nCT>'		
					cString += '<serie>' + NoAcentoCte((cAliasDT6)->DUD_SERIE)  + '</serie>'		
					cString += '<subser>0</subser>'		
					cString += '<dEmi>'  + SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 1, 4) + "-" + SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 5, 2) + "-" + SubStr(AllTrim((cAliasDT6)->DT6_DATEMI), 7, 2) + '</dEmi>' //-- Data Emissao
					cString += '<vCarga>' + ConvType((cAliasDT6)->DT6_VALMER, 13, 2, "N") + '</vCarga>'		
					cString += '</infCT>'
					
					nQtdCtr += 1
				EndIf	     
			EndIf	
			(cAliasDT6)->(dbSkip())
		Enddo
		(cAliasDT6)->(dbCloseArea())		
		RestArea(aAreaSM0)
		
		cString += '</infMunDescarga>'                                              		
		cString += '</infDoc>'
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TAG: Tot -- Totalizadores da carga transportada e seus doctos fiscais ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cString += '<tot>'
		If nQtdCte > 0
			cString += '<qCTe>' + cValtoChar(nQtdCte) + '</qCTe>'				
		EndIf
		If nQtdCtr > 0
			cString += '<qCT>' + cValtoChar(nQtdCtr) + '</qCT>'						
		EndIf	

		cString += '<vCarga>'   + ConvType(DTX->DTX_VALMER, 13, 2, "N") + '</vCarga>'
		cString += '<cUnid>01</cUnid>'			        	//01- KG, 02- TON
		cString += '<qCarga>'   + ConvType(DTX->DTX_PESO, 11, 4, "N") + '</qCarga>'
		cString += '</tot>'

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TAG: Lacres -- Lacres do MDF-e                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAliasDVB := GetNextAlias()
		cQuery := " SELECT DVB_LACRE "
		cQuery += CRLF+" FROM " + RetSqlName("DVB")	+ " DVB "
		cQuery += CRLF+" WHERE DVB_FILIAL = '" + xFilial("DVB") + "' AND "
		cQuery += CRLF+"       DVB_FILORI = '" + DTX->DTX_FILORI + "' AND "
		cQuery += CRLF+"       DVB_VIAGEM = '" + DTX->DTX_VIAGEM + "' AND "
		cQuery += CRLF+"       DVB.D_E_L_E_T_ = '' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDVB,.F.,.T.)

		While (cAliasDVB)->(!Eof())
			cString+=	'<lacres>'
			cString+= 		'<nLacre>' + AllTrim((cAliasDVB)->DVB_LACRE) + '</nLacre>'
			cString+=	'</lacres>'
			dbskip()
		Enddo
		(cAliasDVB)->(dbCloseArea())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TAG: infAdic -- Informacoes adicionais                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cObs)                   
			cString += '<infAdic>'              
			cString +=  '<infAdFisco>' + NoAcentoCte(SubStr(cObs,1,320)) + '</infAdFisco>'
			cString += '</infAdic>'              
		EndIf
				
		cString += '</infMDFe>'
		aAdd(aXMLMDFe,AllTrim(cString))
				
		cString := ''
		cString += '</MDFe>'
				
		aAdd(aXMLMDFe,AllTrim(cString))				

		cString := ''			
		For nCount := 1 To Len(aXMLMDFe)
			cString += AllTrim(aXMLMDFe[nCount])
		Next nCount
	                                                                         
		If Empty(DTX->DTX_CHVMDF)		
		    RecLock('DTX',.F.)         
			DTX->DTX_CHVMDF:= cChvAcesso
			If cTpEmis == '2' .And.  Empty(DTX->DTX_CTGMDF)  //Contingencia
				DTX->DTX_CTGMDF:= cChvAcesso
			EndIf				
			MsUnlock()	
		EndIf                           

	EndIf
EndIf

Return({cNfe,EncodeUTF8(cString)})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ConvType  ºAutor  ³Totvs               º Data ³  08/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ConvType(xValor,nTam,nDec)

Local   cNovo := ""
Default nDec  := 0

Do Case
	Case ValType(xValor)=="N"
		cNovo := AllTrim(Str(xValor,nTam,nDec))
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		Default nTam := 60
		cNovo := NoAcentoCte(SubStr(xValor,1,nTam))
EndCase
Return(cNovo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Inverte   ºAutor  ³Totvs               º Data ³  08/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Inverte(uCpo)

Local cCpo	:= uCpo
Local cRet	:= ""
Local cByte	:= ""
Local nAsc	:= 0
Local nI	:= 0
Local aChar	:= {}
Local nDiv	:= 0

aAdd(aChar,	{"0", "9"})
aAdd(aChar,	{"1", "8"})
aAdd(aChar,	{"2", "7"})
aAdd(aChar,	{"3", "6"})
aAdd(aChar,	{"4", "5"})
aAdd(aChar,	{"5", "4"})
aAdd(aChar,	{"6", "3"})
aAdd(aChar,	{"7", "2"})
aAdd(aChar,	{"8", "1"})
aAdd(aChar,	{"9", "0"})

For nI:= 1 to Len(cCpo)
	cByte := Upper(Subs(cCpo,nI,1))
	If	(Asc(cByte) >= 48 .And. Asc(cByte) <= 57) .Or. ;	// 0 a 9
		(Asc(cByte) >= 65 .And. Asc(cByte) <= 90) .Or. ;	// A a Z
		Empty(cByte)	// " "
		nAsc	:= Ascan(aChar,{|x| x[1] == cByte})
		If nAsc > 0
			cRet := cRet + aChar[nAsc,2]	// Funcao Inverte e chamada pelo rdmake de conversao
		EndIf
	Else
		// Caracteres <> letras e numeros: mantem o caracter
		cRet := cRet + cByte
	EndIf
Next
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MDFCHVAC ³       ³                       ³ Data ³02.04.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao responsavel em montar a Chave de Acesso             ³±±
±±³          ³ a SEFAZ e calcular o seu digito verIficador.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MDFCHVAC(cUF, cAAMM, cCNPJ, cMod, cSerie, nMDF, cDV)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ cUF...: Codigo da UF                                       ³±±
±±³          ³ cAAMM.: Ano (2 Digitos) + Mes da Emissao do CTe            ³±±
±±³          ³ cCNPJ.: CNPJ do Emitente do CTe                            ³±±
±±³          ³ cMod..: Modelo (58 = MDFe)                                 ³±±
±±³          ³ cSerie: Serie do MDFe                                      ³±±
±±³          ³ nCT...: Numero do MDF                                      ³±±
±±³          ³ cDV...: Numero do Lote de Envio a SEFAZ                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Explicacao do Calculo se encontra no manual do MDF-e       ³±±
±±³          ³ disponibilizado pela SEFAZ na versao atual 1.00,           ³±±
±±³          ³ pag: 68                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MDFCHVAC(cUF, cAAMM, cCNPJ, cMod, cSerie, nMDF, cDV)
Local nCount      := 0
Local nSequenc    := 2
Local nPonderacao := 0
Local cResult     := ''
Local cChvAcesso  := cUF +  cAAMM + cCNPJ + cMod + cSerie + nMDF + cDV

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³SEQUENCIA DE MULTIPLICADORES (nSequenc), SEGUE A SEGUINTE        ³
//³ORDENACAO NA SEQUENCIA: 2,3,4,5,6,7,8,9,2,3,4... E PRECISA SER   ³
//³GERADO DA DIREITA PARA ESQUERDA, SEGUINDO OS CARACTERES          ³
//³EXISTENTES NA CHAVE DE ACESSO INFORMADA (cChvAcesso)             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCount := Len( AllTrim(cChvAcesso) ) To 1 Step -1
	nPonderacao += ( Val( SubStr( AllTrim(cChvAcesso), nCount, 1) ) * nSequenc )
	nSequenc += 1
	If (nSequenc == 10)
		nSequenc := 2
	EndIf
Next nCount

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quando o resto da divisão for 0 (zero) ou 1 (um), o DV devera   ³
//³ ser igual a 0 (zero).                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( mod(nPonderacao,11) > 1)
	cResult := (cChvAcesso + cValToChar( (11 - mod(nPonderacao,11) ) ) )
Else
	cResult := (cChvAcesso + '0')
EndIf

Return(cResult)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NoPontos  ºAutor  ³                    º Data ³  20/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retira caracteres dIferentes de numero, como, ponto,       º±±
±±º          ³virgula, barra, traco                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function NoPontos(cString)
Local cChar     := ""
Local nX        := 0
Local cPonto    := "."
Local cBarra    := "/"
Local cTraco    := "-"
Local cVirgula  := ","
Local cBarraInv := "\"
Local cPVirgula := ";"
Local cUnderline:= "_"
Local cParent   := "()"

For nX:= 1 To Len(cString)
	cChar := SubStr(cString, nX, 1)
	If cChar$cPonto+cVirgula+cBarra+cTraco+cBarraInv+cPVirgula+cUnderline+cParent
		cString := StrTran(cString,cChar,"")
		nX := nX - 1
	EndIf
Next
cString := AllTrim(_NoTags(cString))

Return cString

