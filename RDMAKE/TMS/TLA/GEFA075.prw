#INCLUDE "rwmake.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEFA075   ³ Autor ³ J Ricardo Guimarães   ³ Data ³ 24.01.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gravar os arquivos DTC-NF Clientes e DTP-Lotes NF           ³±±
±±³          ³, com base no arquivo SZ8-Notas Fiscais importadas do SIPCO ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GEFA075()
/*/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Perguntas                      	    		      ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ mv_par01 - Codigo do Remetente          			  ³
³ mv_par02 - Loja   				  	   			  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local cTitulo:= "Geracao de Lotes para Calculo do CTRC - TLA"
Local cDesc1 := "Este programa atualiza o arquivo de Notas Fiscais de Clientes, importadas "
Local cDesc2 := "do sistema SIPCO(TLA) e gera os respectivos lotes deixando-os disponiveis "
Local cDesc3 := "para o calculo do Frete (CTRC) "
Local cDesc4 := ""

Local nOpca
Local nSeqArq
Local nSeqReg
Local cCadastro
Local aSays  := {}, aButtons := {}

Private cPerg := PadR("GEFA75",LEN(SX1->X1_GRUPO))

criasx1()

AADD(aSays,OemToAnsi(cDesc1))
AADD(aSays,OemToAnsi(cDesc2))
AADD(aSays,OemToAnsi(cDesc3))
AADD(aSays,OemToAnsi(cDesc4))

nOpca := 0
cCadastro:=OemToAnsi(cTitulo)
AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T.)}})
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End()}})
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End()}})

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|lEnd| EdiGeraNf()})
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³EdiGeraNf ³ Autor ³ Katia Alves Bianchi   ³ Data ³ 12.05.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gravar os arquivos DTC-NF Clientes e DTP-Lotes NF           ³±±
±±³          ³, com base no arquivo DE5-Notas Fiscais EDI                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ EdiGeraNf()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Executar apos importacao NF Clientes via EDI               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function EdiGeraNf()

Local aAreaDE5  := DE5->(GetArea())
Local aAreaDTC  := DTC->(GetArea())
Local aAreaDTP  := DTP->(GetArea())
Local aAreaSA1  := SA1->(GetArea())
Local cCodRegOri, cCodRegDes, cCodFilDes, nX, _cRegCal
Local cNumLote  := ""
Local cQuery    := ""
Local aStruSZ8  := {}
Local cAliasSZ8 := ""
Local cErrata   := ""
Local cLotesGer := ""
Local cCodOri   := ""
Local cCodDes   := ""
Local cCodCon	:= ""
Local cFamilia  := "" 
Local aErrata   := {}
Local aLotesGer := {}
Local cMsg		 := ""
Local cCCGefco  := ""
Local cCodTra   := ""
Local cLojTra   := ""
Local _aTransp  := {}            
Local _cNumNFC  := ""
Local _cSerNFC  := ""  
Local _cCFOP    := ""
Local _cNFEID   := ""
Local _cCNPJOri := ""

Private nQtdNf      := 0
Pergunte(cPerg,.F.)

/*
// Tabela enviada pelo Flávio Vitório
// Com a entada do CT-e, houve a necessidade de informar Motorista/Veículo, e na interface(SZ8) só vem transportadora
CNPJ Trans.		TRANSPORTADORA				COD MOT.	NOME DO MOTORISTA						COD. CARRETA	PLACA DA CARRETA
07677704000223	Autoport - Porto Real	120003	JOSÉ LUIZ JOAQUIM						00001856	MPH 6096
19199348000188	SADA - Rio de Janeiro	120004	Everaldo Teófilo dos Santos		00001857	HGJ 6951 
92644483000185	GABARDO						120006	Sergio Flaviano Araujo Vieira		00001858	
11968619000100	290 AUTO SOCORRO			120007	JAIR FIDELIS DE OLIVEIRA			00001860	LKN2555
60395589000104	BRAZUL						120005	 Marco Aurélio de Paula				00001859	kQN 7421
02351144000118	TEGMA							120008	ERASMO CARLOS DE ALMEIDA MACHADO	00001861	IQC2160
32681371001144	VIX							120003	JOSÉ LUIZ JOAQUIM						00001862	MPH 6096
04968037000320	SMARTCAR						120016	Denis Brito dos Santos				00001874	DVA4457
	14-SETE LAGOAS				
19199348000188	SADA - Sete Lagoas		120011	WILLIAN DE SOUZA SOARES	00001866	BUP4212
	17-CAÇAPAVA				
19199348000188	BRAZUL						120020	Marco Aurélio de Paula	00001880	kQN 7421
*/

// Matriz com:  CNPJ da Transp    Mot.    Veículo
AADD(_aTransp, {"07677704000223","120003","00001856"})
AADD(_aTransp, {"19199348000188","120004","00001857"})
AADD(_aTransp, {"92644483000185","120006","00001858"})
AADD(_aTransp, {"11968619000100","120007","00001860"})
AADD(_aTransp, {"60395589000104","120005","00001859"})
AADD(_aTransp, {"02351144000118","120008","00001861"})
AADD(_aTransp, {"32681371001144","120003","00001862"})
AADD(_aTransp, {"04968037000320","120016","00001874"})
AADD(_aTransp, {"04968037000169","120016","00001874"})
// Por: Ricardo - Em: 07/01/2016
AADD(_aTransp, {"07677731000549","120003","00001856"})

/*
-----------------------------------------------------
Posiciona no SZ8-Notas Fiscais do SIPCO
-----------------------------------------------------*/
dbSelectArea("SZ8")
dbSetOrder(1) //-- Z8_FILIAL+Z8_SEQUEN
ProcRegua(RecCount()) // Numero de registros a processar

aStruSZ8  := SZ8->(dbStruct())
cAliasSZ8 := GetNextAlias()

cQuery := "SELECT * "
cQuery += "  FROM "+RetSqlName("SZ8")
cQuery += " WHERE Z8_FILIAL  = '"+xFilial("SZ8")+"'"
cQuery += "   AND Z8_DTCRIA >= '" + DTOS(mv_par01) + "' "
cQuery += "   AND Z8_DTCRIA <= '" + DTOS(mv_par02) + "' "
cQuery += "   AND Z8_LOTNFC  = '' "
cQuery += "   AND Z8_NUMCTRC = '' "
cQuery += "   AND D_E_L_E_T_ = ' '"
cQuery += " ORDER BY "+SqlOrder(SZ8->(IndexKey()))
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSZ8)
For nX := 1 To Len(aStruSZ8)
	If aStruSZ8[nX][2] <> "C"
		TcSetField(cAliasSZ8,aStruSZ8[nX][1],aStruSZ8[nX][2],aStruSZ8[nX][3],aStruSZ8[nX][4])
	EndIf
Next nX

(cAliasSZ8)->(dbGoTop())
If (cAliasSZ8)->(Eof())
	MsgBox("Não há dados a serem impressos para os parâmetros informados! ","Lote Nao Gerado","INFO")
Else
	cCodRegOri  := GETMV("MV_CDRORI")
	

	While (cAliasSZ8)->( !Eof() )
		
		IncProc()
		
		_cFilOri := SM0->M0_CODFIL //xFilial("DE5") //(cAliasDE5)->DE5_FILIAL
		
		// Validação dos campos 
		
		// Valida cliente emitente
		dbSelectArea("SA1") ; dbSetOrder(3)
		If !Empty((cAliasSZ8)->Z8_CNPJORI) .AND. (cAliasSZ8)->Z8_CNPJORI <> "00000000000000"
			If !(SA1->(dbSeek(xFilial("SA1")+(cAliasSZ8)->Z8_CNPJORI)))
				cErrata := "Cliente remetente inexistente "
			Else
				If SA1->A1_MSBLQL = "1"
					cErrata := "Cliente remetente Bloqueado "
				EndIf			
				cCodOri := SA1->A1_COD + A1_LOJA
			EndIf
		Else
			dbSelectArea("SA1") ; dbSetOrder(1)
			If !(SA1->(dbSeek(xFilial("SA1")+AllTrim((cAliasSZ8)->Z8_CODORI))))
				cErrata := "Cliente remetente inexistente "
			Else    
				If SA1->A1_MSBLQL = "1"
					cErrata := "Cliente remetente Bloqueado "
				EndIf
				cCodOri := SA1->A1_COD + A1_LOJA				
			EndIf			
		EndIf		
		
		// Valida cliente destinatário
		dbSelectArea("SA1") ; dbSetOrder(3)
		If !Empty((cAliasSZ8)->Z8_CNPJDES) .AND. (cAliasSZ8)->Z8_CNPJDES <> "00000000000000"
			If !(SA1->(dbSeek(xFilial("SA1")+AllTrim((cAliasSZ8)->Z8_CNPJDES))))
				cErrata += " - Cliente destinatario inexistente "
			Else     
				If SA1->A1_MSBLQL = "1"
					cErrata += "- Cliente destinatário Bloqueado "
				EndIf			
				If Empty(SA1->A1_CDRDES)
					cErrata += " - Região do cliente destinatário não informada no Cad.Cliente. "
				EndIf					
				cCodDes := SA1->A1_COD + A1_LOJA
			EndIf
		Else
			dbSelectArea("SA1") ; dbSetOrder(1)
			If !(SA1->(dbSeek(xFilial("SA1")+AllTrim((cAliasSZ8)->Z8_CODDES))))
				cErrata += " - Cliente destinatario inexistente "
			Else                     
				If Empty(SA1->A1_CDRDES)
					cErrata += " - Região do cliente destinatário não informada no Cad.Cliente. "
				EndIf	
				If SA1->A1_MSBLQL = "1"
					cErrata += "Cliente destinatário Bloqueado "
				EndIf				
				cCodDes := SA1->A1_COD + A1_LOJA
			EndIf			
		EndIf

		// Pego CC Gefco
		cCCGefco  := AllTrim((cAliasSZ8)->Z8_CCGEFCO)
		If Empty(cCCGefco)
			cCCGefco  := fPegaCC()
		EndIf
		
		If Empty(cCCGefco)
			cErrata += " - CC Gefco não localizado na tabela SX5(99). "	
		EndIf

		// Valida a CC Gefco 
		dbSelectArea("CTT") ; dbSetOrder(1)
		If !Empty(cCCGefco)
			If !(CTT->(dbSeek(xFilial("CTT")+cCCGefco)))
				cErrata += " - CC Gefco " + cCCGefco + " inexistente (CTT) "
			EndIf
		Else
        	If CTT->CTT_BLOQ == "1"			
        		cErrata += " - CC Gefco " + cCCGefco + " Bloqueado "
        	EndIf
		EndIf
		                              
		// Valida cliente consignatário - Pagador do Frete
		_lAchou := .F.
		dbSelectArea("SA1") ; dbSetOrder(3)
		If !Empty((cAliasSZ8)->Z8_CNPJCON).AND. (cAliasSZ8)->Z8_CNPJCON <> "00000000000000"
			If !(SA1->(dbSeek(xFilial("SA1")+AllTrim((cAliasSZ8)->Z8_CNPJCON))))
				cErrata += " - Cliente consignatário inexistente "
			Else
				If Empty(SA1->A1_CDRDES)
					cErrata += " - Região do cliente consignatário não informada no Cad.Cliente. "
				EndIf			
					                                
				If SA1->A1_MSBLQL = "1"
					cErrata += " - Cliente consignatário Bloqueado "
				EndIf							
				
				cCodCon := SA1->A1_COD + A1_LOJA
				_lAchou := .T.
			EndIf
		Else
			dbSelectArea("SA1") ; dbSetOrder(1)
			If !(SA1->(dbSeek(xFilial("SA1")+AllTrim((cAliasSZ8)->Z8_CODCON))))
				cErrata += " - Cliente consignatario inexistente "
			Else
				If Empty(SA1->A1_CDRDES)
					cErrata += " - Região do cliente consignatário não informada no Cad.Cliente. "
				EndIf				
							
				If SA1->A1_MSBLQL = "1"
					cErrata += " - Cliente consignatário Bloqueado "
				EndIf			
				cCodCon := SA1->A1_COD + A1_LOJA								
				_lAchou := .T.				
			EndIf			
		EndIf		
        
		// Acordo com Flávio Vitório em 23/03/2012 - Devido no TMS ja existir uma validação através da tabela SX5010->99, fica desnecessário esta verificação
		/*
		If _lAchou .and. !Empty(cCCGefco)
			// Valida a Categoria do Cliente pagador do Frete ( Consignatário )
			If Empty(SA1->A1_GEFCAT1)
				cErrata += " - Cliente consignatário sem categoria no cad. "
			EndIf
	
	        DbSelectArea("SZD") ;  DbSetOrder(1)
	        If DbSeek(xFilial("SZD")+SubStr(cCCGefco,10,1)+SA1->A1_GEFCAT1)
	            IF !Empty(SZD->ZD_UO) 
	            	IF !(SubStr(cCCGefco,2,2) $ SZD->ZD_UO)
	            		// Uo nAo autoriazada pra esta configuração de faturamento: UO X 10ºDigito Centro de custo.
	            	    cErrata += " - Faturamento imcompatível: UO X 10ºDigito Centro de custo. "
	            	EndIf
	            EndIf
			Else
	    	    cErrata += " - Faturamento não permitido: 10º Digito CC X Categoria do Cliente.	"
			EndIF
		EndIf
		*/
		
		// Valida a Transportadora
		dbSelectArea("SA2") ; dbSetOrder(3)
		If !Empty((cAliasSZ8)->Z8_CNPJTRA)
			If !(SA2->(dbSeek(xFilial("SA2")+(cAliasSZ8)->Z8_CNPJTRA)))
				cErrata += " - Transportadora inexistente(SA2) - " + (cAliasSZ8)->Z8_CNPJTRA
			Else
				cCodTra := SA2->A2_COD
				cLojTra := SA2->A2_LOJA	
			EndIf
		EndIf
		
		If isCliPSA(cCodCon,.F.)
			_cOIObriga := ""

			//Procutra C.Custo PSA em SZG
			If !Empty((cAliasSZ8)->Z8_CCPSA)
				dbSelectArea("SZG") ; dbSetOrder(1)
				If !dbSeek(xFilial("SZG")+AllTrim((cAliasSZ8)->Z8_CCPSA))
   					cErrata += " - CC PSA N/Cadastrado "
				Else
					_cOIObriga := SZG->ZG_OIOBRIG
				EndIf
			Else
				cErrata += " - CC PSA N/Informado no SIPCO "
			EndIf
			
			//Procutra Conta Despesa PSA em SZF
			If !Empty(AllTrim((cAliasSZ8)->Z8_CTAPSA))
				dbSelectArea("SZF") ; dbSetOrder(1)
				If !dbSeek(xFilial("SZF")+AllTrim((cAliasSZ8)->Z8_CTAPSA))
   					cErrata += " - Conta Despesa N/Cadastrado. "
				EndIf
			Else
				cErrata += " - Conta Despesa N/Informada. "
			EndIf
/*		
/*
Por André Costa / Ricardo
Em  31/10/2014
Problema de Validãção do da Orddem Interna da PSA
*//*
 
			//Procura Ordem Interna PSA
			If Empty((cAliasSZ8)->Z8_OIPSA)
				If _cOIObriga = "S"
				cErrata += " - OI Obrigatoria. "
				EndIf
			Else
				If _cOIObriga = "S"
					dbSelectArea("SZI") ; 	dbSetOrder(1)
					cChave:= ""
					//cChave:=lTrim((cAliasSZ8)->Z8_CCPSA)+space(len((cAliasSZ8)->Z8_CCPSA)-len(LTRIM((cAliasSZ8)->Z8_CCPSA)))
					//cChave+=ltrim((cAliasSZ8)->Z8_CTAPSA)+space(len((cAliasSZ8)->Z8_CTAPSA)-len(LTRIM((cAliasSZ8)->Z8_CTAPSA)))
					//cChave+=ltrim((cAliasSZ8)->Z8_OIPSA)+space(len((cAliasSZ8)->Z8_OIPSA)-len(LTRIM((cAliasSZ8)->Z8_OIPSA)))
					
					cChave:=PadR(AllTrim((cAliasSZ8)->Z8_CCPSA),TamSX3("ZI_CCONT")[1])
					cChave+=PadR(AllTrim((cAliasSZ8)->Z8_CTAPSA),TamSX3("ZI_CONTA")[1])
					cChave+=PadR(AllTrim((cAliasSZ8)->Z8_OIPSA),TamSX3("ZI_OI")[1])
					If !dbSeek(xFilial("SZI")+cChave)
						cErrata += " - CC X CONTA X OI N/Cad. na tab. SZI. "
					EndIf
				Else       
					cErrata += " - O Centro de Custo "+(cAliasSZ8)->Z8_CCPSA + " não exige OI. "
				EndIf
			EndIf
*/								
		EndIf
		
		// Verifico se NF já foi usada em outro Lote
		/* Disponibilizar em produção
		dbSelectArea("DTC") ; dbSetOrder(2) // DTC_FILIAL+DTC_NUMNFC+DTC_SERNFC+DTC_CLIREM+DTC_LOJREM+DTC_CODPRO+DTC_FILORI+DTC_LOTNFC                                                                         
		If dbSeek(xFilial("DTC")+(cAliasSZ8)->Z8_NFCLI+(cAliasSZ8)->Z8_SERIENF+cCodOri+PadR(GETMV("MV_XPROTLA"),TamSX3("DTC_CODPRO")[1])+(cAliasSZ8)->Z8_FILIAL)
			cErrata += " - A Nota "+AllTrim((cAliasSZ8)->Z8_NFCLI) + "Série " + AllTrim((cAliasSZ8)->Z8_SERIENF) + " ja foi usada no lote " + DTC->DTC_LOTNFC
		EndIf
        */
        
		// Valido o Serviço
		cFamilia := AllTrim((cAliasSZ8)->Z8_FAMILIA)
		cFamilia := StrTran(cFamilia,"P","TL")  // No SIPCO: P2,P3,P4,P5 - No TMS: TL2, TL3, TL4, TL5 -> Há correspondência de 1->1
		
		If AllTrim((cAliasSZ8)->Z8_MERCADO) = "2" .AND. cFamilia <> "TL5"		// Exportação
			cFamilia := "TLX"
		EndIf     

		// Por: Ricardo - Em: 25/10/2013		
		If AllTrim((cAliasSZ8)->Z8_MERCADO) = "2" .AND. cFilAnt='14' .AND. cFamilia = "TL5"	// Exportação
			cFamilia := "TLY"
		EndIf     
		
		If !Empty(Val(AllTrim((cAliasSZ8)->Z8_CODDES)))     
			If AllTrim((cAliasSZ8)->Z8_CODDES) $ AllTrim(GETMV("MV_XTLATRF"))  // "4426200|44261100" ) // Transferência
				If cFamilia = "TL4"			
					cFamilia := "TRF"
				Else
			    	cFamilia = "TRG"	
			    EndIf	
			EndIf 
		EndIf
					
		If !(SX5->(dbSeek(xFilial("SX5")+"L4"+cFamilia)))
			cErrata += " - O SERVIÇO/FAMILIA "+(cAliasSZ8)->Z8_FAMILIA + " não cadastrado no TMS. "			
		EndIf

		_cRegCal := Posicione("SA1",1,xFilial("SA1")+cCodDes,"A1_CDRDES")

		// Por: Ricardo - Em: 24/09/2014 - O trecho abaixo foi incluído sob orientação do Flávio Vitorio
		IF	AllTrim((cAliasSZ8)->Z8_FILIAL) = "14" .AND. AllTrim((cAliasSZ8)->Z8_MERCADO) = "2"
			cCodCon := "00022400" // Cod+Loja --// GEFCO ARGENTINA
			
			// Por: Ricardo Em: 08/07/2015 - O trecho abaixo foi incluído conforme especificação do Flávio Vitorio
			cCodOri := "05443401"
			cCodRem := "05443401"
			cCodDev := "00022400"
			// CLICAL := cCodCon
			
			_cRegCal := "RJ0068" 
		EndIf
		
		// Por: Ricardo - Em: 08/07/2015 - O trecho abaixo foi incluído conforme especificação do Flávio Vitorio
		IF	AllTrim((cAliasSZ8)->Z8_FILIAL) = "03" .AND. AllTrim((cAliasSZ8)->Z8_ORIGEM) = "2"
			cCodOri := "90136501"
			cCodCon := "90136501" // Cod+Loja --// PSA EXPORTAÇÃO
			cCodRem := "90136501"
			cCodDev := "90136501"
			// CLICAL := cCodCon
		EndIf		
		
		// Pego o CFOP 
		dbSelectArea("SZ6") ; dbSetOrder(1)
		_cCFOP  := ""
		_cNFEID := ""
		_cNumNFC  := StrZero(Val(AllTrim((cAliasSZ8)->Z8_NFCLI  )),TamSX3("Z8_NFCLI")[1])
		_cSerNFC  := IIF(ISDIGIT(AllTrim((cAliasSZ8)->Z8_SERIENF)),StrZero(Val(AllTrim((cAliasSZ8)->Z8_SERIENF)),TamSX3("Z8_SERIENF")[1]),AllTrim((cAliasSZ8)->Z8_SERIENF))

		// Por: Ricardo - Em: 05/08/2015 - Objetivo: Passar a buscar pelo CNPJ do cCodOri
		_cCNPJOri := Posicione("SA1",1,xFilial("SA1")+cCodOri,"A1_CGC")
		 
		// If dbSeek(xFilial("SZ6")+_cNumNFC+_cSerNFC+AllTrim((cAliasSZ8)->Z8_CNPJORI))
		If dbSeek(xFilial("SZ6")+_cNumNFC+_cSerNFC+AllTrim(_cCNPJOri))
			_cCFOP  := SZ6->Z6_CFOPPRI
			_cNFEID := SZ6->Z6_IDNFE
      	EndIf
        
		// Deixar enquanto estiver analisando as baixas dos XMLs.
		//If Empty(_cCFOP)
			//cErrata += " - CFOP não informado "
		//EndIf
			
		// Se não houve erro, gero o Lote( DTC )	
		If Empty(cErrata)
		
			/*-----------------------------------------------------
			Grava lote atual
			-----------------------------------------------------*/
			If Empty(cNumLote)
				// cNumLote := GetSx8Num("DTP","DTP_LOTNFC")
				nQtdNf := 1				
				cNumLote := CriaVar("DTP_LOTNFC",.T.) // inicializa com caracteristica do campo, quando .F. não executa inicializador padrão
				ConfirmSx8()
				EdiGrvLote(cNumLote, _aTransp, (cAliasSZ8)->Z8_CNPJTRA)
			EndIf

			// Pego mensgem do cliente e gravo no lote
			cMsg := ""
			cMsg := fMsgCli(cCodDes)

			/*-----------------------------------------------------
			Grava as notas fiscais - DTC
			-----------------------------------------------------*/
			Reclock("DTC",.T.)
			DTC->DTC_FILIAL := xFilial("DTC")
			DTC->DTC_FILORI := SM0->M0_CODFIL //(cAliasDE5)->DE5_FILIAL
			DTC->DTC_LOTNFC := cNumLote
			DTC->DTC_DATENT := DATE()
			DTC->DTC_NFEID  := _cNFEID
			DTC->DTC_NUMNFC := _cNumNFC
			DTC->DTC_SERNFC := _cSerNFC
			DTC->DTC_EMINFC := (cAliasSZ8)->Z8_DATANF
			DTC->DTC_QTDVOL := 1 // (cAliasSZ8)->Z8_QTDVOL
			DTC->DTC_PESO   := Val((cAliasSZ8)->Z8_PESOVEI)
			//DTC->DTC_PESOM3 := (cAliasSZ8)->Z8_PESOM3
			DTC->DTC_VALOR  := (cAliasSZ8)->Z8_VALORNF
			//DTC->DTC_BASSEG := (cAliasSZ8)->Z8_VALSEG
			DTC->DTC_CLIREM := Left(cCodOri,TamSX3("DTC_CLIREM")[1])
			DTC->DTC_LOJREM := Right(cCodOri,2)
			DTC->DTC_CLIDES := Left(cCodDes,TamSX3("DTC_CLIDES")[1])
			DTC->DTC_LOJDES := Right(cCodDes,2)
			DTC->DTC_CLICON := Left(cCodCon,TamSX3("DTC_CLICON")[1])
			DTC->DTC_LOJCON := Right(cCodCon,2)
			//DTC->DTC_CLIDPC := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDPC)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDPC,"A1_COD"),"")
			//DTC->DTC_LOJDPC := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDPC)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDPC,"A1_LOJA"),"")
			DTC->DTC_TIPFRE := If(cCodOri == cCodCon, "2", "1")                  //1.CIF 2.FOB
			DTC->DTC_DEVFRE := "3" // 1-Cliente remetente; 2-Cliente Destinatário; 3-Consignatario // If((cAliasDE5)->DE5_TIPFRE == "1","1","2")
			DTC->DTC_CLIDEV := Left(cCodCon,TamSX3("DTC_CLICON")[1])
			DTC->DTC_LOJDEV := Right(cCodCon,2)  
			DTC->DTC_CLICAL := Left(cCodCon,TamSX3("DTC_CLICON")[1])
			DTC->DTC_LOJCAL := Right(cCodCon,2)
			DTC->DTC_CODEMB := GETMV("MV_XEMBTLA") //(cAliasDE5)->DE5_CODEMB
			DTC->DTC_CODPRO := GETMV("MV_XPROTLA") // (cAliasDE5)->DE5_CODPRO
			DTC->DTC_SERTMS := "3"
			DTC->DTC_TIPTRA := "1" // (cAliasDE5)->DE5_TIPTRA - 1-Rodoviário; 2-Aerio; 3-Fluvial
			DTC->DTC_SERVIC := cFamilia
			DTC->DTC_CDRORI := GetMV("MV_CDRORI") // Posicione("SA1",1,xFilial("SA1")+cCodOri,"A1_CDRDES")//cCodRegOri
			DTC->DTC_CDRDES := Posicione("SA1",1,xFilial("SA1")+cCodDes,"A1_CDRDES")
			// DTC->DTC_CDRCAL := Posicione("SA1",1,xFilial("SA1")+cCodCon,"A1_CDRDES")
			DTC->DTC_CDRCAL := _cRegCal // Por: Ricardo - Em: 08/07/2015
			DTC->DTC_EDI    := "1"
			DTC->DTC_SELORI := IIF(SM0->M0_CODFIL="18","1","2") //1-Transportadora; 2-Cliente Remetente; 3-Local de Coleta
			DTC->DTC_TIPNFC := "0" //0-Normal; 1-Devolução; 2-SubContratação; 3-Docto. N/Fiscal
			DTC_CCUSTO		:= cCCGefco // (cAliasSZ8)->Z8_CCGEFCO // '2110052034', 
			DTC_TIPDES		:='O'
			DTC_CCONT		:= (cAliasSZ8)->Z8_CCPSA     // 'BRR41', 
			DTC_CONTA		:= (cAliasSZ8)->Z8_CTAPSA  //'62424000'
			DTC_OI			:= (cAliasSZ8)->Z8_OIPSA	 //'62424000' 
			DTC_TRANSP		:= cCodTra // Transportadora(SA2)
			DTC_LJTRA		:= cLojTra // Loja da Transportadora               
			
			// Por: Ricardo - Em: 24/09/2014 - O trecho abaixo foi incluído sob orientação do Flávio Vitorio
			IF	AllTrim((cAliasSZ8)->Z8_FILIAL) = "14" .AND. AllTrim((cAliasSZ8)->Z8_MERCADO) = "2"			
				DTC->DTC_CF		:= "7101"
			Else	
				// Gravo o CFOP - Em: 13/08/2013 - Ricardo
				DTC->DTC_CF		:= IIF(Empty(_cCFOP),MV_PAR03,_cCFOP)
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava o campo MEMO                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MSMM(DTC->DTC_CODOBS,,,cMsg,1,,,"DTC","DTC_CODOBS")
			MsUnlock()
			
			/*----------------------------------------------------
			Atualiza tabela de NF-e (SZ6)
			-----------------------------------------------------*/
			If !Empty(_cCFOP)
				RecLock("SZ6",.F.)
					SZ6->Z6_USADO := dDATABASE
				MsUnLock()
			EndIf	
						
			/*----------------------------------------------------
			Atualiza Lote Gerado na SZ8
			-----------------------------------------------------*/
			SZ8->(dbGoTo((cAliasSZ8)->R_E_C_N_O_))
			RecLock("SZ8",.F.)
				SZ8->Z8_LOTNFC := cNumLote
				SZ8->Z8_ERRATA := ""
				SZ8->Z8_CCGEFCO:= cCCGefco
			MsUnLock()
			
			// Guardo Log dos Lotes gerados para ser enviado por e-mail
			// cLotesGer += " VIN: " + AllTrim((cAliasSZ8)->Z8_VIN) + "  Lote: " + cNumLote + " / "
			AADD(aLotesGer," VIN: " + AllTrim((cAliasSZ8)->Z8_VIN) + "  |  Lote: " + cNumLote)
		Else
			/*----------------------------------------------------
			Atualiza Lote Gerado na SZ8
			-----------------------------------------------------*/
			SZ8->(dbGoTo((cAliasSZ8)->R_E_C_N_O_))
			RecLock("SZ8",.F.)
				SZ8->Z8_ERRATA := SubStr(cErrata,1,250)
			MsUnLock()
			
			//Guardo a errata para ser enviado por e-mail
			AADD(aErrata, {"VIN: " + (cAliasSZ8)->Z8_VIN, cErrata})
		EndIf
				
		cNumLote := ""
		cErrata  := ""
		cCodOri  := ""
		cCodDes  := ""
		cCodCon  := ""
		
		(cAliasSZ8)->(dbSkip())
	EndDo
	
	/*-----------------------------------------------------
	ReGrava Arquivo de Lotes - Quantidades
	-----------------------------------------------------*/
	/*
	If nQtdNf > 0 
		EdiGrvLote(cNumLote)
	Else
		MsgBox("Não ha dados para processar! ","Lote Nao Gerado","INFO")
	EndIf
	*/
EndIf

dbSelectArea(cAliasSZ8)
dbCloseArea()

If Len(aErrata) > 0 .OR. Len(aLotesGer) > 0
	*----------------------------*
	FEnvMail(aErrata, aLotesGer)
	*----------------------------*
EndIf	

RestArea ( aAreaDE5 )
RestArea ( aAreaDTC )
RestArea ( aAreaDTP )
RestArea ( aAreaSA1 )

Return

*-------------------------------------------------*
Static Function FEnvMail(_aErrata, _aLotes)
*-------------------------------------------------*
Local aUser    	:= {}
Local _cMail   	:= ""
Local cAssunto 	:= ""
Local cCc		:= ""
Local cPara		:= ""
Local cDe		:= ""
Local cMsg		:= ""
Local cAnexo	:= ""

//PswOrder(2)
//PswSeek(cUserID,.t.)
aUser   := PswRet(1)
_cEMail := aUser[1,14] // Busca o e-mail do usuário 

cCc      := "" 
cPara    := _cEMail 
cDe      := GETMV("MV_RELFROM")


If Len(_aLotes) > 0

	cAssunto := "Lotes Gerados no TMS - Interface SIPCO - " + dTOc(dDataBase) + " - " + ALLTRIM(cFilAnt)
	
	cMsg     := "<b>Segue Lista de Lotes gerados no TMS - TLA-TMS: <BR>"
	cMsg     += "Filial: " + ALLTRIM(cFilAnt)         + "<BR>"
	cMsg     += "Data  : " + dtoc(dDatabase)          + "<BR>"
	cMsg     += "Hora  : " + Left(Time(),5)           + "</b><BR>"
	cMsg     += "<BR>"
	cMsg     += "<BR>"

	cMsg	 += "<table border='1'>"  
		    
	For x:= 1 To Len(_aLotes)
		cMsg += "<tr><td>"+_aLotes[x]+"</td></tr>" 
	Next x
	
	cMsg	 += "</table>"
	
    cMsg += "<BR><BR><BR><BR>e-mail automático, favor não respondê-lo"

	*---------------------------------------------*
	U_EnvEmail(cDe,cPara,cCc,cAssunto,cMsg,cAnexo)
	*---------------------------------------------*	
EndIf
	              
If Len(_aErrata) > 0                                                                                     

	cAssunto := "Errata de Importação da Interface SIPCO - " + dTOc(dDataBase) + " - " + ALLTRIM(cFilAnt)

	cMsg     := "<b>Segue Lista de Erratas na geração de Lotes - TLA-TMS: <BR>"
	cMsg     += "Filial: " + ALLTRIM(cFilAnt) + "<BR>"
	cMsg     += "Data  : " + dtoc(dDatabase)  + "<BR>"
	cMsg     += "Hora  : " + Left(Time(),5)   + "</b><BR>"
	cMsg     += "<BR>"
	cMsg     += "<BR>" 

	cMsg	 += "<table border='1'>"
	
	For x:=1 to Len(_aErrata)
		cMsg     += "<tr><td>"+_aErrata[x,1] + " - " + _aErrata[x,2] + "</td></tr>"
    Next x
	cMsg	 += "</table>"    
    cMsg += "<BR><BR><BR><BR>e-mail automático, favor não respondê-lo</p>"
    
	*---------------------------------------------*
	U_EnvEmail(cDe,cPara,cCc,cAssunto,cMsg,cAnexo)
	*---------------------------------------------*	
EndIf	

Return()
/*
      // Coloca uma mensagem em HTML
      cHTML += "<p><h1 align='center'>Hello World!!!</h1></p>"
      
      // Coloca um separador de linha em HTML
      cHTML += '<hr>'
      
      If Len(__aProcParms) = 0
      	cHTML += '<p>Nenhum parâmetro informado na linha de URL.'
      Else
      	For i := 1 To Len(__aProcParms)	
      
      		cHTML += '<p>Parâmetro: ' + __aProcParms[i,1] + '    -      Valor: ' + __aProcParms[i,2] + '</p>'
      
      	Next i
      Endif
*/
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³EdiGrvLote³ Autor ³ Katia Alves Bianchi   ³ Data ³ 18.05.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gravar o numero do lote                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ EdiGrvLote()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function EdiGrvLote(cNumLote, _aTransp, _cTransp)
Local _nPosTransp  := 0
Local  _cVeiculo   := ""
Local  _cMotorista := ""

// Pesquiso o CNPJ da transportadora no Vetor.
_nPosTransp := AScan(_aTransp, {|x| alltrim(x[1]) == AllTrim(_cTransp)})

If _nPosTransp > 0
	_cMotorista:= _aTransp[_nPosTransp,2]
	_cVeiculo  := _aTransp[_nPosTransp,3]
EndIf 

DTP->(dbSetOrder(1))
If !DTP->(MsSeek(xFilial("DTP")+cNumLote))
	RecLock("DTP",.T.)
	DTP->DTP_FILIAL := xFilial("DTP")
	DTP->DTP_FILORI := _cFilOri
	DTP->DTP_LOTNFC := cNumLote
	DTP->DTP_DATLOT := DATE()
	DTP->DTP_HORLOT := STRTRAN(TIME(),":","")
	DTP->DTP_QTDLOT := nQtdNf
	DTP->DTP_QTDDIG := nQtdNf
	DTP->DTP_NUMSOL := ""
	DTP->DTP_STATUS := "2"   //1.Aberto 2.Digitado 3.Calculado 4.Bloqueado 5.Erro Grav
	DTP->DTP_TIPLOT := (IIF(GETNEWPAR("MV_TMSCTE",.F.),"3","1")) // "1"  // 1=normal; 2=refaturamento
	DTP->DTP_CODMOT := _cMotorista
	DTP->DTP_CODVEI := _cVeiculo
	MsUnlock()
Else
	RecLock("DTP",.F.)
	DTP->DTP_QTDLOT := nQtdNf
	DTP->DTP_QTDDIG := nQtdNf
	MsUnlock()
EndIf
Return    


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CriaSX1   ³ Autor ³Katia Alves Bianchi    ³ Data ³18/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ajuste de Perguntas (SX1)                 			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CriaSX1()

_sAlias := Alias()																		
dbSelectArea("SX1")
dbSetOrder(1)
aRegs :={}

//(sx1) Grupo/Ordem/Pergunta/X1_PERSPA/X1_PERENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSpa1/DefEng1/Cnt01/Var02/Def02/DefSpa2/DefEng2/Cnt02/Var03/Def03/DefSpa3/DefEng3/Cnt03/Var04/Def04/DefSpa4/DefEng4/Cnt04/Var05/Def05/DefSpa5/DefEng5/Cnt05/F3
/*
aAdd(aRegs,{cPerg,"01","Cliente              ?","¿De Cliente    ?","From Customer  ?","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
aAdd(aRegs,{cPerg,"02","Loja                 ?","¿De Tienda     ?","From unit      ?","mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Tipo Transporte      ?","¿Tipo Transporte ?","Tipo Transporte ?","mv_ch3","N",1,0,0,"C","","mv_par03","Rodoviario","","","","","Aereo","","","","","","","","","","","","","","","","","","","","","","",""})
*/
aAdd(aRegs,{cPerg,"01","Data Inicial         ?","¿Data Inicial  ?","Data Inial  ?","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Final           ?","¿Data Final    ?","Data Final  ?","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","CFOP                 ?","¿CFOP          ?","CFOP        ?","mv_ch3","C",4,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
dbSelectArea(_sAlias)

Return()

*--------------------------------------------*
Static Function isCliPSA(pCliente,lCodSap)
*--------------------------------------------*
Local lRet:=.t.

dbSelectArea("SZE")
dbSetOrder(1)

If !dbSeek(xFilial("SZE")+pCliente)
	lRet:=.f.
ElseIf lCodSap
	If AllTrim(SZE->ZE_CODSAP) == 'BR30'
		lRet:=.f.
	EndIf
EndIf

Return lRet

*-------------------------------------------------*
Static Function EnvMail()
*-------------------------------------------------*
PswOrder(2)
PswSeek(c_User,.t.)
aUser := PswRet(1)   
oP:cTo:= aUser[1,14] // Busca o e-mail do comprador que inseriu o pedido para enviar o Html de Retorno
Return

*-------------------------------------------------*
Static Function fMsgCli(_cCli)
*-------------------------------------------------*
Local _aArea    := GetArea()
Local cAliasDV2 := GetNextAlias()
Local cQuery    := ""
Local _cMsg     := ""

cQuery := "SELECT * "
cQuery += "  FROM "+RetSqlName("DV2")
cQuery += " WHERE DV2_FILUSO  = '"+cFilAnt+"'"
cQuery += "   AND DV2_CODCLI + DV2_LOJCLI = '" + _cCli + "' "
cQuery += "   AND D_E_L_E_T_ = ' '"

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDV2)

dbSelectArea(cAliasDV2) ; dbGoTop()

If !Eof()
	_cMsg := StrTran(MsMM(AllTrim((cAliasDV2)->DV2_CODOBS),120),Chr(13)," ") 
	_cMsg := StrTran(_cMsg, Chr(10),"")
EndIf

(cAliasDV2)->(dbCloseArea())

RestArea(_aArea)
Return(_cMsg)

*-------------------------------------------------*
Static Function fPegaCC(_cCC)
*-------------------------------------------------*
Local _aArea    := GetArea()
Local _cCCGefco := ""
Local _cChave   := SZ8->Z8_FILIAL + AllTrim(SZ8->Z8_CODMAR) + AllTrim(SZ8->Z8_MERCADO) + IIF(SZ8->Z8_CNPJDES=="67405936000173", "T","N")

_cCCGefco := POSICIONE("SX5",1,xFilial("SX5")+"99"+_cChave,"X5_DESCRI")

RestArea(_aArea)
Return(AllTrim(_cCCGefco))