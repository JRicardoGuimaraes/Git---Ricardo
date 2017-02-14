#DEFINE SZMARCA	  01
#DEFINE SZZONA   02
#DEFINE SZESPACO 03
#INCLUDE "RwMake.ch"
#INCLUDE "Protheus.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEFA002   ³ Autor ³ Katia Alves Bianchi   ³ Data ³ 12.05.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gravar os arquivos DTC-NF Clientes e DTP-Lotes NF           ³±±
±±³          ³, com base no arquivo DE5-Notas Fiscais EDI                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Executar apos importacao NF Clientes via EDI                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GEFA002 ()
/*/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Perguntas                      	    		      ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ mv_par01 - Codigo do Remetente          			  ³
³ mv_par02 - Loja   				  	   			  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local cTitulo:= "Geracao de Lotes para Calculo do CTRC"
Local cDesc1 := "Este programa atualiza o arquivo de Notas Fiscais de Clientes recebidas via EDI e gera os"
Local cDesc2 := "respectivos lotes deixando-os disponiveis para o calculo do Frete (CTRC) "
Local cDesc3 := ""
Local cDesc4 := ""

Local nOpca
Local nSeqArq
Local nSeqReg
Local cCadastro
Local aSays  := {}, aButtons := {}

Private cPerg := PadR("GEFA02",LEN(SX1->X1_GRUPO))   

criasx1()

AADD(aSays,OemToAnsi(cDesc1))
AADD(aSays,OemToAnsi(cDesc2))
AADD(aSays,OemToAnsi(cDesc3))
AADD(aSays,OemToAnsi(cDesc4))

nOpca := 0
cCadastro:=OemToAnsi(cTitulo)
AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T.)}})
AADD(aButtons, { 1,.T.,{|o| Pergunte(cPerg,.F.), nOpca:= 1, o:oWnd:End()}})
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End()}})

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	//Processa({|lEnd| EdiGeraNf(1)},"Gerando lotes de todas zonas, exceto SP-1, SP-2 e SP-3")
	//Processa({|lEnd| EdiGeraNf(2)},"Gerando lotes das zonas SP-1, SP-2 e SP-3")
	fMontPerg ()
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
Static Function EdiGeraNf(_nProc, cZonas)

Local aAreaDE5  := DE5->(GetArea())
Local aAreaDTC  := DTC->(GetArea())
Local aAreaDTP  := DTP->(GetArea())
Local aAreaSA1  := SA1->(GetArea())
Local cCodRegOri, cCodRegDes, cCodFilDes, nX, _cRegCal
Local cNumLote  := ""
Local cQuery    := ""
Local aStruDE5  := {}
Local cAliasDE5 := ""
Local cZona_Ant := ""
Local _aMsgLote := {}
Local _aMsgCFOP := {}   
Local _cWhile   := "" 
Local cCNPJDes  := ""
Local _aRetInfNFe := Array(2)

Private nQtdNf  := 0
Pergunte(cPerg,.F.)

// AADD(_aMsgLote, {"ZONA 01", "TESTE001"})
// AADD(_aMsgCFOP, {"ZONA 01", "TESTE001","001","5"})

/*
-----------------------------------------------------
Posiciona no Remetente selecionado
-----------------------------------------------------*/
/*
SA1->(dbSetOrder(1))
If SA1->(!MsSeek(xFilial("SA1")+mv_par01+mv_par02))
	Aviso("AVISO","Cliente não cadastrado",{"Ok"})
	Return
EndIf
*/

/*
-----------------------------------------------------
Posiciona no DE5-Notas Fiscais EDI
-----------------------------------------------------*/
dbSelectArea("DE5")
dbSetOrder(1) //-- DE5_FILIAL+DE5_CGCREM+DE5_DOC+DE5_SERIE
ProcRegua(RecCount()) // Numero de registros a processar

aStruDE5  := DE5->(dbStruct())
cAliasDE5 := GetNextAlias()
// DE5_STATUS <> 2, quando do recebimento pode ser trazido com status em branco(1-em Aberto e 2-Encerrado)somente nao trara os que forem 2-Encerrado
cQuery := "SELECT * "
cQuery += "  FROM "+RetSqlName("DE5")
cQuery += " WHERE DE5_FILIAL = '"+xFilial("DE5")+"'"
cQuery += "   AND DE5_STATUS <> '2'"
cQuery += "   AND DE5_MSBLQL = '2'"
cQuery += "   AND DE5_CGCREM = '"+SA1->A1_CGC+"'"
cQuery += "   AND DE5_TIPTRA = '"+Alltrim(Str(MV_PAR03))+"'"
cQuery += "   AND DE5_XZONA IN " + cZonas
cQuery += "   AND D_E_L_E_T_ = ' '" 
If _nProc = 1 // Gera lotes de todas zonas
	//cQuery += "   AND DE5_XZONA NOT IN ('BR: SP-1','BR: SP-2','BR: SP-3')"
	cQuery += " ORDER BY DE5_XZONA,DE5_FILIAL,DE5_CGCREM,DE5_DOC,DE5_SERIE "
Else // Gera lotes das zonas SP-1, SP-2, SP-3
	//cQuery += "   AND DE5_XZONA IN ('BR: SP-1','BR: SP-2','BR: SP-3')"
	cQuery += " ORDER BY DE5_CGCDES, DE5_XZONA, DE5_DOC, DE5_SERIE "
EndIf
//cQuery += " ORDER BY "+SqlOrder(DE5->(IndexKey()))
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDE5)
For nX := 1 To Len(aStruDE5)
	If aStruDE5[nX][2] <> "C"
		TcSetField(cAliasDE5,aStruDE5[nX][1],aStruDE5[nX][2],aStruDE5[nX][3],aStruDE5[nX][4])
	EndIf
Next nX

(cAliasDE5)->(dbGoTop())
If (cAliasDE5)->(Eof())
	MsgBox("Não ha dados para processar! ","Lote Nao Gerado","INFO")
Else
	cCodRegOri  := GETMV("MV_CDRORI")

	While (cAliasDE5)->( !Eof() )	

		cZona_Ant := (cAliasDE5)->DE5_XZONA    
		cCNPJDes  := (cAliasDE5)->DE5_CGCDES

		If _nProc = 1
			While (cAliasDE5)->( !Eof() ) .AND. (cAliasDE5)->DE5_XZONA = cZona_Ant
				
				IncProc()
				
				_cFilOri := SM0->M0_CODFIL //xFilial("DE5") //(cAliasDE5)->DE5_FILIAL
				
				/*-----------------------------------------------------
				Verifica se a NF ja foi importada para o sistema
				-----------------------------------------------------*/
			   /*
					DTC->(dbSetOrder(5)) //DTC_FILIAL+DTC_CLIREM+DTC_LOJREM+DTC_NUMNFC+DTC_SERNFC
				If DTC->(MsSeek(xFilial("DTC")+SUBSTR((cAliasDE5)->DE5_CGCREM,1,12)+(cAliasDE5)->DE5_DOC+(cAliasDE5)->DE5_SERIE))
					(cAliasDE5)->(dbSkip())
					Loop
				EndIf
	         */
				/*-----------------------------------------------------
				Grava lote atual
				-----------------------------------------------------*/
				If Empty(cNumLote)
					// cNumLote := GetSx8Num("DTP","DTP_LOTNFC")
					cNumLote := CriaVar("DTP_LOTNFC",.T.) // inicializa com caracteristica do campo, quando .F. não executa inicializador padrão
					ConfirmSx8()
					EdiGrvLote(cNumLote)
					
					// Chamo a rotina para informar Motorista/Veiculo
					While !U_DadosViagem("ZONA: " + AllTrim((cAliasDE5)->DE5_XZONA), "")
					EndDo
					AADD(_aMsgLote, {AllTrim((cAliasDE5)->DE5_XZONA), cNumLote})
				EndIf
				      
				If Empty((cAliasDE5)->DE5_CFOPNF)
					AADD(_aMsgCFOP, {AllTrim((cAliasDE5)->DE5_XZONA), cNumLote, (cAliasDE5)->DE5_DOC, (cAliasDE5)->DE5_SERIE})
				EndIf
				                  
				/*-----------------------------------------------------
				Pego informações da NF-e na tabela SZ6
				-----------------------------------------------------*/
				_aRetInfNFe[1] := _aRetInfNFe[2] := ""  // 1 = ID NF-e ; 2 = CFOP
				_aRetInfNFe := fBuscaNFEID((cAliasDE5)->DE5_DOC,(cAliasDE5)->DE5_SERIE,(cAliasDE5)->DE5_CGCREM)
				
				/*-----------------------------------------------------
				Grava as notas fiscais - DTC
				-----------------------------------------------------*/
				Reclock("DTC",.T.)
				DTC->DTC_FILIAL := xFilial("DTC")
				DTC->DTC_FILORI := SM0->M0_CODFIL //(cAliasDE5)->DE5_FILIAL
				DTC->DTC_LOTNFC := cNumLote
				DTC->DTC_DATENT := DATE()
				DTC->DTC_NFEID  := IIF(Empty((cAliasDE5)->DE5_NFEID),_aRetInfNFe[1],(cAliasDE5)->DE5_NFEID)
				DTC->DTC_NUMNFC := (cAliasDE5)->DE5_DOC
				DTC->DTC_SERNFC := (cAliasDE5)->DE5_SERIE
				DTC->DTC_EMINFC := (cAliasDE5)->DE5_EMINFC
				DTC->DTC_CF     := IIF(EMPTY((cAliasDE5)->DE5_CFOPNF),_aRetInfNFe[2],(cAliasDE5)->DE5_CFOPNF)  // Na implatanção do CT-e - 13-07-2013		
				DTC->DTC_QTDVOL := (cAliasDE5)->DE5_QTDVOL
				DTC->DTC_PESO   := (cAliasDE5)->DE5_PESO
				DTC->DTC_PESOM3 := (cAliasDE5)->DE5_PESOM3
				DTC->DTC_VALOR  := (cAliasDE5)->DE5_VALOR
				DTC->DTC_BASSEG := (cAliasDE5)->DE5_VALSEG
				DTC->DTC_CLIREM := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCREM)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCREM,"A1_COD"),"")
				DTC->DTC_LOJREM := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCREM)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCREM,"A1_LOJA"),"")
				DTC->DTC_CLIDES := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDES)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDES,"A1_COD"),"")
				DTC->DTC_LOJDES := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDES)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDES,"A1_LOJA"),"")
				DTC->DTC_CLICON := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCCON)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCCON,"A1_COD"),"")
				DTC->DTC_LOJCON := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCCON)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCCON,"A1_LOJA"),"")
				DTC->DTC_CLIDPC := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDPC)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDPC,"A1_COD"),"")
				DTC->DTC_LOJDPC := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDPC)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDPC,"A1_LOJA"),"")
				DTC->DTC_TIPFRE := (cAliasDE5)->DE5_TIPFRE                    //1.CIF 2.FOB
				DTC->DTC_DEVFRE := If((cAliasDE5)->DE5_TIPFRE == "1","1","2")
				DTC->DTC_CLIDEV := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDEV)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDEV,"A1_COD"),"")
				DTC->DTC_LOJDEV := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDEV)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDEV,"A1_LOJA"),"")
				DTC->DTC_CLICAL := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDEV)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDEV,"A1_COD"),"")
				DTC->DTC_LOJCAL := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDEV)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDEV,"A1_LOJA"),"")
				DTC->DTC_CODEMB := (cAliasDE5)->DE5_CODEMB
				DTC->DTC_CODPRO := (cAliasDE5)->DE5_CODPRO
				// DTC->DTC_SERTMS := "3"
				DTC->DTC_TIPTRA := (cAliasDE5)->DE5_TIPTRA
				// DTC->DTC_SERVIC := GetMV("MV_GEF002")
				DTC->DTC_CDRORI := Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCREM,"A1_CDRDES")//cCodRegOri
				DTC->DTC_CDRDES := Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDES,"A1_CDRDES")
				DTC->DTC_CDRCAL := Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDES,"A1_CDRDES")
				DTC->DTC_EDI    := "1"
				DTC->DTC_SELORI := "2"
				DTC->DTC_TIPNFC := "0"
				DTC_CCUSTO		:= GETMV("MV_GEF005") // '2110052034', 
				DTC_TIPDES		:='O'
				DTC_CCONT		:= GETMV("MV_GEF006") // 'BRR41', 
				DTC_CONTA		:= GETMV("MV_GEF008") //'62424000'

				// Por: Ricardo Guimaraes - Em: 03/04/2014 - Objetivo: Atender Projeto Full TMS - Tratamento de transferencia
				DTC->DTC_SERTMS := (cAliasDE5)->DE5_SERTMS // IIF(AllTrim((cAliasDE5)->DE5_XZONA) $ GETMV("MV_GEF014"),"2","3")
				DTC->DTC_SERVIC := (cAliasDE5)->DE5_SERVIC // IIF(AllTrim((cAliasDE5)->DE5_XZONA) $ GETMV("MV_GEF014"),GetMV("MV_GEF013"), GetMV("MV_GEF002"))
				                                  
				DTC->DTC_XZONA := (cAliasDE5)->DE5_XZONA
				MsUnlock()
				
				nQtdNf++
				
				/*----------------------------------------------------
				Atualiza DE5
				-----------------------------------------------------*/
				DE5->(dbGoTo((cAliasDE5)->R_E_C_N_O_))
				RecLock("DE5",.F.)
				DE5->DE5_STATUS := '2'			//-- Encerrado
				MsUnLock()

				
				(cAliasDE5)->(dbSkip())
			EndDo
		Else
			
			While (cAliasDE5)->( !Eof() ) .AND. (cAliasDE5)->DE5_CGCDES = cCNPJDes //.AND. (cAliasDE5)->DE5_XZONA = cZona_Ant
				
				IncProc()
				
				_cFilOri := SM0->M0_CODFIL //xFilial("DE5") //(cAliasDE5)->DE5_FILIAL
				
				/*-----------------------------------------------------
				Verifica se a NF ja foi importada para o sistema
				-----------------------------------------------------*/
			   /*
					DTC->(dbSetOrder(5)) //DTC_FILIAL+DTC_CLIREM+DTC_LOJREM+DTC_NUMNFC+DTC_SERNFC
				If DTC->(MsSeek(xFilial("DTC")+SUBSTR((cAliasDE5)->DE5_CGCREM,1,12)+(cAliasDE5)->DE5_DOC+(cAliasDE5)->DE5_SERIE))
					(cAliasDE5)->(dbSkip())
					Loop
				EndIf
	         */
				/*-----------------------------------------------------
				Grava lote atual
				-----------------------------------------------------*/
				If Empty(cNumLote)
					// cNumLote := GetSx8Num("DTP","DTP_LOTNFC")
					cNumLote := CriaVar("DTP_LOTNFC",.T.) // inicializa com caracteristica do campo, quando .F. não executa inicializador padrão
					ConfirmSx8()
					EdiGrvLote(cNumLote)
					
					// Chamo a rotina para informar Motorista/Veiculo
					While !U_DadosViagem("ZONA: " + AllTrim((cAliasDE5)->DE5_XZONA), "DEST.: " + Transform((cAliasDE5)->DE5_CGCDES, "@R 99.999.999/9999-99") + "-" + POSICIONE("SA1",3,XFILIAL("SA1")+(cAliasDE5)->DE5_CGCDES,"A1_NOME"))
					EndDo
					AADD(_aMsgLote, {AllTrim((cAliasDE5)->DE5_XZONA), cNumLote})
				EndIf
				      
				If Empty((cAliasDE5)->DE5_CFOPNF)
					AADD(_aMsgCFOP, {AllTrim((cAliasDE5)->DE5_XZONA), cNumLote, (cAliasDE5)->DE5_DOC, (cAliasDE5)->DE5_SERIE})
				EndIf

				/*-----------------------------------------------------
				Pego informações da NF-e na tabela SZ6
				-----------------------------------------------------*/
				_aRetInfNFe[1] := _aRetInfNFe[2] := ""  // 1 = ID NF-e ; 2 = CFOP
				_aRetInfNFe := fBuscaNFEID((cAliasDE5)->DE5_DOC,(cAliasDE5)->DE5_SERIE,(cAliasDE5)->DE5_CGCREM)
				
				/*-----------------------------------------------------
				Grava as notas fiscais - DTC
				-----------------------------------------------------*/
				Reclock("DTC",.T.)
				DTC->DTC_FILIAL := xFilial("DTC")
				DTC->DTC_FILORI := SM0->M0_CODFIL //(cAliasDE5)->DE5_FILIAL
				DTC->DTC_LOTNFC := cNumLote
				DTC->DTC_DATENT := DATE()              
				DTC->DTC_NFEID  := IIF(Empty((cAliasDE5)->DE5_NFEID),_aRetInfNFe[1],(cAliasDE5)->DE5_NFEID)
				DTC->DTC_NUMNFC := (cAliasDE5)->DE5_DOC
				DTC->DTC_SERNFC := (cAliasDE5)->DE5_SERIE
				DTC->DTC_EMINFC := (cAliasDE5)->DE5_EMINFC
				DTC->DTC_CF     := IIF(EMPTY((cAliasDE5)->DE5_CFOPNF),_aRetInfNFe[2],(cAliasDE5)->DE5_CFOPNF)  // Na implatanção do CT-e - 13-07-2013		
				DTC->DTC_QTDVOL := (cAliasDE5)->DE5_QTDVOL
				DTC->DTC_PESO   := (cAliasDE5)->DE5_PESO
				DTC->DTC_PESOM3 := (cAliasDE5)->DE5_PESOM3
				DTC->DTC_VALOR  := (cAliasDE5)->DE5_VALOR
				DTC->DTC_BASSEG := (cAliasDE5)->DE5_VALSEG
				DTC->DTC_CLIREM := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCREM)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCREM,"A1_COD"),"")
				DTC->DTC_LOJREM := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCREM)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCREM,"A1_LOJA"),"")
				DTC->DTC_CLIDES := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDES)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDES,"A1_COD"),"")
				DTC->DTC_LOJDES := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDES)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDES,"A1_LOJA"),"")
				DTC->DTC_CLICON := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCCON)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCCON,"A1_COD"),"")
				DTC->DTC_LOJCON := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCCON)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCCON,"A1_LOJA"),"")
				DTC->DTC_CLIDPC := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDPC)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDPC,"A1_COD"),"")
				DTC->DTC_LOJDPC := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDPC)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDPC,"A1_LOJA"),"")
				DTC->DTC_TIPFRE := (cAliasDE5)->DE5_TIPFRE                    //1.CIF 2.FOB
				DTC->DTC_DEVFRE := If((cAliasDE5)->DE5_TIPFRE == "1","1","2")
				DTC->DTC_CLIDEV := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDEV)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDEV,"A1_COD"),"")
				DTC->DTC_LOJDEV := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDEV)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDEV,"A1_LOJA"),"")
				DTC->DTC_CLICAL := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDEV)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDEV,"A1_COD"),"")
				DTC->DTC_LOJCAL := If(!Empty(Alltrim((cAliasDE5)->DE5_CGCDEV)),Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDEV,"A1_LOJA"),"")
				DTC->DTC_CODEMB := (cAliasDE5)->DE5_CODEMB
				DTC->DTC_CODPRO := (cAliasDE5)->DE5_CODPRO
				// DTC->DTC_SERTMS := "3"
				DTC->DTC_TIPTRA := (cAliasDE5)->DE5_TIPTRA
				// DTC->DTC_SERVIC := GetMV("MV_GEF002")
				DTC->DTC_CDRORI := Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCREM,"A1_CDRDES")//cCodRegOri
				DTC->DTC_CDRDES := Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDES,"A1_CDRDES")
				DTC->DTC_CDRCAL := Posicione("SA1",3,xFilial("SA1")+(cAliasDE5)->DE5_CGCDES,"A1_CDRDES")
				DTC->DTC_EDI    := "1"
				DTC->DTC_SELORI := "2"
				DTC->DTC_TIPNFC := "0"
				DTC_CCUSTO		:= GETMV("MV_GEF005") // '2110052034', 
				DTC_TIPDES		:='O'
				DTC_CCONT		:= GETMV("MV_GEF006") // 'BRR41', 
				DTC_CONTA		:= GETMV("MV_GEF008") //'62424000'
				
				// Por: Ricardo Guimaraes - Em: 03/04/2014 - Objetivo: Atender Projeto Full TMS - Tratamento de transferencia
				DTC->DTC_SERTMS := IIF(AllTrim((cAliasDE5)->DE5_XZONA) $ GETMV("MV_GEF014"),"2","3")
				DTC->DTC_SERVIC := IIF(AllTrim((cAliasDE5)->DE5_XZONA) $ GETMV("MV_GEF014"),GetMV("MV_GEF013"), GetMV("MV_GEF002"))
				
				DTC->DTC_XZONA := (cAliasDE5)->DE5_XZONA				
				MsUnlock()
				
				nQtdNf++
				
				/*----------------------------------------------------
				Atualiza DE5
				-----------------------------------------------------*/
				DE5->(dbGoTo((cAliasDE5)->R_E_C_N_O_))
				RecLock("DE5",.F.)
				DE5->DE5_STATUS := '2'			//-- Encerrado
				MsUnLock()
				
				(cAliasDE5)->(dbSkip())
			EndDo
		EndIf
		/*-----------------------------------------------------
		ReGrava Arquivo de Lotes - Quantidades
		-----------------------------------------------------*/
		If nQtdNf > 0 //regrava quando gerar alguma nota
			EdiGrvLote(cNumLote)
		Else
			MsgBox("Não ha dados para processar! ","Lote Nao Gerado","INFO")
		EndIf               
		
		// Inicializo o Lote
		cNumLote := ""
		nQtdNf	:= 0
	EndDo	
EndIf

dbSelectArea(cAliasDE5)
dbCloseArea()

RestArea ( aAreaDE5 )
RestArea ( aAreaDTC )
RestArea ( aAreaDTP )
RestArea ( aAreaSA1 )

// Envia e-mail
If Len(_aMsgLote) > 0
	fEnvMail(_aMsgLote, _aMsgCFOP)
EndIf

Return

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
Static Function EdiGrvLote(cNumLote)
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
aAdd(aRegs,{cPerg,"01","Cliente              ?","¿De Cliente    ?","From Customer  ?","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
aAdd(aRegs,{cPerg,"02","Loja                 ?","¿De Tienda     ?","From unit      ?","mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Tipo Transporte      ?","¿Tipo Transporte ?","Tipo Transporte ?","mv_ch3","N",1,0,0,"C","","mv_par03","Rodoviario","","","","","Aereo","","","","","","","","","","","","","","","","","","","","","","",""})

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

*-------------------------------------------------*
Static Function FEnvMail(_aMsgLote, _aMsgCFOP)
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

If Empty(_cEMail)
	MsgInfo("Favor informar e-mail no cadastro de usuário, para receber Log de Processamento","Informação")
EndIf

If Len(_aMsgLote) > 0

	cAssunto := "Lotes Gerados no TMS - Interface NOTFIS PSA - " + dTOc(dDataBase) + " - " + ALLTRIM(cFilAnt)
	
	cMsg := "<b>Segue Lista de Lotes gerados no TMS: <BR>"
	cMsg += "Filial: " + ALLTRIM(cFilAnt)         + "<BR>"
	cMsg += "Data  : " + dtoc(dDatabase)          + "<BR>"
	cMsg += "Hora  : " + Left(Time(),5)           + "</b><BR>"
	cMsg += "<BR>"
	cMsg += "<BR>"

	cMsg += "<table border='1'>"  

	cMsg += "<tr><td>Zona</td><td>Lote</td></tr>" 
	
	For x:= 1 To Len(_aMsgLote)
		cMsg += "<tr><td>"+_aMsgLote[x,1]+"</td>"+"<td>"+_aMsgLote[x,2]+"</td></tr>" 
	Next x

	cMsg	 += "</table>"

	If Len(_aMsgCFOP) > 0
		cMsg += "<BR><BR><b>Segue Lista de Lotes com item sem CFOP : <BR>"

		cMsg += "<table border='1'>"  
	
		cMsg += "<tr><td>Zona</td><td>Lote</td><td>NF</td><td>Serie</td></tr>" 
		
		For x:= 1 To Len(_aMsgCFOP)
			cMsg += "<tr><td>"+_aMsgCFOP[x,1]+"</td>"+"<td>"+_aMsgCFOP[x,2]+"</td>"+"<td>"+_aMsgCFOP[x,3]+"</td><td>"+_aMsgCFOP[x,4]+"</td></tr>" 
		Next x
		
	EndIf

	cMsg	 += "</table>"
	
   cMsg += "<BR><BR><BR><BR>e-mail automático, favor não respondê-lo"
   
	*---------------------------------------------*
	U_EnvEmail(cDe,cPara,cCc,cAssunto,cMsg,cAnexo)
	*---------------------------------------------*	
EndIf
	              
Return()                                                                                                 

**********************************************************
* Por: Ricardo Guimarães - Em: 05/11/2013                *
* Objetivo: Buscar o informações da NF-e na tabela SZ6   *
**********************************************************
Static Function fBuscaNFEID(_cNumNFE, _cSerNFE, _cCNPJRem)
Local _aArea  := GetArea()
Local _aInfNFE:= Array(2)

_aInfNFE[1] := "" // IDNFE
_aInfNFE[2] := "" // CFOP

dbSelectArea("SZ6") ; dbSetOrder(1)
If dbSeek(xFilial("SZ6") + StrZero(Val(_cNumNFE),9) + StrZero(Val(_cSerNFE),3) + _cCNPJRem)
	_aInfNFE[1] := SZ6->Z6_IDNFE
	_aInfNFE[2] := SZ6->Z6_CFOPPRI
EndIf

Return _aInfNFE
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fMontPerg ºAutor  ³ Vinícius Moreira   º Data ³ 12/07/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta tela de filtro por zonas.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fMontPerg ()

Local lRet      := .F.
Local cQuery    := ""
Local cAliasQry := ""
Local aZonaPri  := Separa(GetMv("ES_XZONAS",,"BR: SP-1,BR: SP-2,BR: SP-3"), ",")
Local cZonas1   := ""
Local cZonas2   := ""
Local aZonas    := {}
Local nX        := 0

SA1->(dbSetOrder(1))//A1_FILIAL+A1_COD+A1_LOJA
If SA1->(dbSeek(xFilial("SA1")+mv_par01+mv_par02))
	cAliasQry := GetNextAlias()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca zonas disponiveis para escolha.                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := " SELECT " + CRLF 
	cQuery += "    DE5.DE5_XZONA ZONA " + CRLF
	cQuery += "   FROM "+RetSqlName("DE5") + " DE5 " + CRLF
	cQuery += "  WHERE DE5.D_E_L_E_T_ = ' '" + CRLF
	cQuery += "    AND DE5.DE5_FILIAL = '" + xFilial("DE5") + "' " + CRLF
	cQuery += "    AND DE5.DE5_STATUS <> '2'" + CRLF
	cQuery += "    AND DE5.DE5_MSBLQL = '2'" + CRLF
	cQuery += "    AND DE5.DE5_CGCREM = '"+SA1->A1_CGC+"'" + CRLF
	cQuery += "    AND DE5.DE5_TIPTRA = '"+Alltrim(Str(MV_PAR03))+"'" + CRLF
	cQuery += " GROUP BY " + CRLF
	cQuery += "    DE5.DE5_XZONA " + CRLF
	cQuery += " ORDER BY " + CRLF
	cQuery += "    DE5.DE5_XZONA " + CRLF
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
	
	If (cAliasQry)->(!Eof())
		While (cAliasQry)->(!Eof())
			aAdd(aZonas,{	.F.,;
							(cAliasQry)->ZONA,;
							""})
			(cAliasQry)->(dbSkip())
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Exibe tela para seleção de zonas disponiveis para calculo.                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		aZonas := fSelZona(aZonas)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se alguma zona estiver disponivel, executa processamento.                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If Len(aZonas) > 0 
			For nX := 1 to Len(aZonas)
				If aScan(aZonaPri, {|x| Upper(AllTrim(x)) == Upper(AllTrim(aZonas[nX, SZZONA])) } ) == 0
					cZonas1 += If (Len(cZonas1) > 0, ",","") + aZonas[nX, SZZONA]
				Else
					cZonas2 += If (Len(cZonas2) > 0, ",","") + aZonas[nX, SZZONA]
				EndIf
			Next nX
			
			If !Empty(cZonas1)
				Processa({|lEnd| EdiGeraNf(1, FormatIn(cZonas1, ","))}, "Gerando lotes das zonas " + cZonas1 )
			EndIf
			If !Empty(cZonas2)
				Processa({|lEnd| EdiGeraNf(2, FormatIn(cZonas2, ","))}, "Gerando lotes das zonas " + cZonas2 )
			EndIf
		EndIf
	EndIf
Else
	Aviso("AVISO","Cliente não cadastrado",{"Ok"})
EndIf

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fSelZona ºAutor  ³ Vinícius Moreira   º Data ³ 13/07/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para seleção das zonas de processamento.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fSelZona(aListBox)

Local aSize     := MsAdvSize(.F. )
Local aObjects  := {}
Local aInfo     := {}
Local aPosObj   := {}  
Local oOk       := LoadBitMap(GetResources(),"LBOK")
Local oNo       := LoadBitMap(GetResources(),"LBNO")
Local nOpca		:= 0
Local oDlg      := Nil
Local oBtn01
Local oBtn02
Local nX        := 0
Local aRet      := {}
	
aAdd( aObjects, { 100, 000, .T., .F., .T.  } )
aAdd( aObjects, { 100, 100, .T., .T. } )
aAdd( aObjects, { 100, 005, .T., .T. } )

aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ]*0.60, aSize[ 4 ]*0.68, 3, 3, .T.  }
aPosObj := MsObjSize( aInfo, aObjects, .T. )
	
DEFINE MSDIALOG oDlg TITLE "Zonas" From aSize[7],0 to aSize[6]*0.68,aSize[5]*0.61 OF oMainWnd PIXEL
	
	oPanel := TPanel():New(aPosObj[1,1],aPosObj[1,2],"",oDlg,,,,,CLR_WHITE,(aPosObj[1,3]), (aPosObj[1,4]), .T.,.T.)
		
	//-- Cabecalho dos campos do Monitor.                                                        
	@ aPosObj[2,1],aPosObj[2,2] LISTBOX oListBox Fields HEADER;
	  "","Zona","" SIZE aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1] PIXEL
	 		   
	oListBox:SetArray( aListBox )
	oListBox:bLDblClick := { || aListBox[oListBox:nAt, SZMARCA] := !aListBox[oListBox:nAt, SZMARCA] }
	oListBox:bLine      := { || {	Iif(aListBox[ oListBox:nAT,SZMARCA	 	],oOk,oNo),;	
											aListBox[ oListBox:nAT,SZZONA	],;				
											aListBox[ oListBox:nAT,SZESPACO	]}}
 								
	//-- Botoes da tela do monitor.
	@ aPosObj[3,1],001 BUTTON oBtn01	PROMPT "Confirmar"	ACTION (nOpca := 1, oDlg:End()) OF oDlg PIXEL SIZE 035,011	//-- "Confirmar"
	@ aPosObj[3,1],040 BUTTON oBtn02	PROMPT "Sair"		ACTION oDlg:End() OF oDlg PIXEL SIZE 035,011	//-- "Sair"																										                                                    		

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 1
	aRet := aClone(aListBox)
	While (nX := aScan(aRet, {|x| !x[SZMARCA] })) > 0
		aDel(aRet, nX)
		aSize(aRet, Len (aRet)-1)		
	EndDo
EndIf

Return aRet