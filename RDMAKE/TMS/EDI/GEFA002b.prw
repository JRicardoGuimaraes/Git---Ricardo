#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "RwMake.ch"

#DEFINE SZMARCA		01
#DEFINE SZZONA   	02
#DEFINE SZCORTE 	03
#DEFINE SZESPACO 	04

/*/{Protheus.doc} GEFA002b
//TODO Descri��o - Gravar os arquivos DTC-NF Clientes e DTP-Lotes NF, com base no arquivo DE5-Notas Fiscais EDI
//TODO             Executado ap�s a execu��o da rotina GEFA001b
@author u297686 - Ricardo Guimar�es
@since 23/02/2017
@version 1.0

@type function Processamento
/*/
user function GEFA002b()
/*/*
�����������������������������������������������������Ŀ
� Perguntas                      	    		      �
�����������������������������������������������������Ĵ
� mv_par01 - Codigo do Remetente          			  �
� mv_par02 - Loja   				  	   			  �
�������������������������������������������������������*/
Local cTitulo:= "Geracao de Lotes para Calculo do CT-e"
Local cDesc1 := "Este programa atualiza o arquivo de Notas Fiscais de Clientes recebidas via EDI e gera os"
Local cDesc2 := "respectivos lotes deixando-os disponiveis para o calculo do Frete (CT-e) "
Local cDesc3 := ""
Local cDesc4 := ""

Local nOpca
Local nSeqArq
Local nSeqReg
Local cCadastro
Local aSays  := {}, aButtons := {}

Private cPerg 	 := PadR("GEFA02",LEN(SX1->X1_GRUPO))   
Private cZCorte1 := GetNewPar('ES_ZCORTE1', 'BR: SP-4|BR: SP-5|BR: Z-NO-NE|BR: Z. SUL|BRASIL: MG-01; BRASIL: MG-02|BRASIL: PR-01|BRASIL: PR-02|BR: Z. CENTRAL')
Private cZCorte2 := GetNewPar('ES_ZCORTE1', 'BR: RIO - 1|BR: RIO - 2|BR: RIO - 3|BR: RIO - 4|BR: SP-1|BR: SP-2| BR: SP-3|BR: Z. SUDESTE')   
// Tech Center
Private cTC		 := GetNewPar('ES_TCenter','A02|DTC|B01|B02|B03')
// Predio Norte
Private cPN		 := GetNewPar('ES_PNorte','CCQ|CLM|DOC|EXP|NOV|PNE|ZPI|RES|G02|G03|A01|DPN|G01')

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
	fMontPerg()
Endif

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �EdiGeraNf � Autor � Katia Alves Bianchi   � Data � 12.05.09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Gravar os arquivos DTC-NF Clientes e DTP-Lotes NF           ���
���          �, com base no arquivo DE5-Notas Fiscais EDI                 ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EdiGeraNf()                                                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Executar apos importacao NF Clientes via EDI               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
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

/*-----------------------------------------------------
Posiciona no DE5-Notas Fiscais EDI
-----------------------------------------------------*/
dbSelectArea("DE5")
dbSetOrder(1) //-- DE5_FILIAL+DE5_CGCREM+DE5_DOC+DE5_SERIE
ProcRegua(RecCount()) // Numero de registros a processar

aStruDE5  := DE5->(dbStruct())
cAliasDE5 := GetNextAlias()
// DE5_STATUS <> 2, quando do recebimento pode ser trazido com status em branco(1-em Aberto e 2-Encerrado)somente nao trara os que forem 2-Encerrado
cQuery := "SELECT DE5_FILIAL, DE5_CGCREM, DE5_DTAEMB, DE5_CGCDES, DE5_CGCCON, DE5_CGCDPC, DE5_CGCDEV, DE5_TIPTRA, "
cQuery += "DE5_TIPFRE, DE5_DOC, DE5_SERIE, DE5_EMINFC, DE5_CODPRO, DE5_CODEMB, DE5_QTDVOL, DE5_VALOR, DE5_PESO, "
cQuery += "DE5_PESOM3, DE5_VALSEG, DE5_FILDPC, DE5_CTRDPC, DE5_NUMERO, DE5_DATA, DE5_STATUS, DE5_METRO3, DE5_MSBLQL, "
cQuery += "DE5_CCUSTO, DE5_TIPDES, DE5_NFEID, DE5_PEDCLI, DE5_MUN, DE5_ESTADO, R_E_C_N_O_, DE5_MANIF, DE5_SQIDES, "
cQuery += "DE5_BASEIC, DE5_VALICM, DE5_BASIST, DE5_VALIST, DE5_CFOPNF, DE5_LOTEDI, DE5_STAUTO, DE5_SERVIC, DE5_SERTMS, "
cQuery += "DE5_SELORI, DE5_EDIAUT, DE5_EDILOT, DE5_EDIFRT, DE5_FILORI, DE5_LOTNFC, DE5_EMINFE, DE5_CODNFE, DE5_NFELET, "
cQuery += "DE5_XZONA, DE5_SEQEND, DE5_AREFRT, DE5_CODROT, DE5_UNDMED, DE5_XDIA, DE5_XDTPRO, DE5_XCORTE, DE5_XARQ, DE5_XARMAZ "
cQuery += "  FROM "+RetSqlName("DE5")
cQuery += " WHERE DE5_FILIAL = '"+xFilial("DE5")+"'"
cQuery += "   AND DE5_STATUS <> '2'"
cQuery += "   AND DE5_MSBLQL = '2'"
cQuery += "   AND DE5_CGCREM = '"+SA1->A1_CGC+"'"
cQuery += "   AND DE5_TIPTRA = '"+Alltrim(Str(MV_PAR03))+"'"
cQuery += "   AND DE5_XZONA IN " + cZonas
cQuery += "   AND DE5_XDTPRO = '" + DTOS(dDATABASE) + "' "
cQuery += "   AND DE5_XDIA  <> '1'
cQuery += "   AND D_E_L_E_T_ = ' '" 
cQuery += "UNION "
// Pego os itens que n�o foram processados no corte do dia anterior   
cQuery += "SELECT DE5_FILIAL, DE5_CGCREM, DE5_DTAEMB, DE5_CGCDES, DE5_CGCCON, DE5_CGCDPC, DE5_CGCDEV, DE5_TIPTRA, "
cQuery += "DE5_TIPFRE, DE5_DOC, DE5_SERIE, DE5_EMINFC, DE5_CODPRO, DE5_CODEMB, DE5_QTDVOL, DE5_VALOR, DE5_PESO, "
cQuery += "DE5_PESOM3, DE5_VALSEG, DE5_FILDPC, DE5_CTRDPC, DE5_NUMERO, DE5_DATA, DE5_STATUS, DE5_METRO3, DE5_MSBLQL, "
cQuery += "DE5_CCUSTO, DE5_TIPDES, DE5_NFEID, DE5_PEDCLI, DE5_MUN, DE5_ESTADO, R_E_C_N_O_, DE5_MANIF, DE5_SQIDES, "
cQuery += "DE5_BASEIC, DE5_VALICM, DE5_BASIST, DE5_VALIST, DE5_CFOPNF, DE5_LOTEDI, DE5_STAUTO, DE5_SERVIC, DE5_SERTMS, "
cQuery += "DE5_SELORI, DE5_EDIAUT, DE5_EDILOT, DE5_EDIFRT, DE5_FILORI, DE5_LOTNFC, DE5_EMINFE, DE5_CODNFE, DE5_NFELET, "
cQuery += "DE5_XZONA, DE5_SEQEND, DE5_AREFRT, DE5_CODROT, DE5_UNDMED, DE5_XDIA, DE5_XDTPRO, DE5_XCORTE, DE5_XARQ, DE5_XARMAZ "
cQuery += "  FROM "+RetSqlName("DE5")
cQuery += " WHERE DE5_FILIAL = '"+xFilial("DE5")+"'"
cQuery += "   AND DE5_STATUS <> '2'"
cQuery += "   AND DE5_MSBLQL = '2'"
cQuery += "   AND DE5_CGCREM = '"+SA1->A1_CGC+"'"
cQuery += "   AND DE5_TIPTRA = '"+Alltrim(Str(MV_PAR03))+"'"
cQuery += "   AND DE5_XZONA IN " + cZonas
cQuery += "   AND DE5_XDTPRO < '" + DTOS(dDATABASE) + "' "
cQuery += "   AND DE5_XDIA   = '1'
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
	MsgBox("N�o ha dados para processar! ","Lote Nao Gerado","INFO")
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
				Grava lote atual
				-----------------------------------------------------*/
				If Empty(cNumLote)
					// cNumLote := GetSx8Num("DTP","DTP_LOTNFC")
					cNumLote := CriaVar("DTP_LOTNFC",.T.) // inicializa com caracteristica do campo, quando .F. n�o executa inicializador padr�o
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
				Pego informa��es da NF-e na tabela SZ6
				-----------------------------------------------------*/
				_aRetInfNFe[1] := _aRetInfNFe[2] := ""  // 1 = ID NF-e ; 2 = CFOP
				_aRetInfNFe := fBuscaNFEID((cAliasDE5)->DE5_DOC,(cAliasDE5)->DE5_SERIE,(cAliasDE5)->DE5_CGCREM)
				
				// Se for NF-e do dia anterior processa
				If (cAliasDE5)->DE5_XDIA <> '1'
					// Verificar regra para o LPA PSA Porto Real
					If !fVerRegra(AllTrim((cAliasDE5)->DE5_XCORTE), AllTrim((cAliasDE5)->DE5_XZONA), AllTrim((cAliasDE5)->DE5_XARMAZ), AllTrim((cAliasDE5)->DE5_XARQ), ((cAliasDE5)->R_E_C_N_O_))
						dbSelectArea((cAliasDE5))
						(cAliasDE5)->(dbSkip())
						Loop
					EndIf	
				EndIf		
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
				DTC->DTC_CF     := IIF(EMPTY((cAliasDE5)->DE5_CFOPNF),_aRetInfNFe[2],(cAliasDE5)->DE5_CFOPNF)  // Na implatan��o do CT-e - 13-07-2013		
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
				DTC->(MsUnlock())
				
				nQtdNf++
				
				/*----------------------------------------------------
				Atualiza DE5
				-----------------------------------------------------*/
				DE5->(dbGoTo((cAliasDE5)->R_E_C_N_O_))
				RecLock("DE5",.F.)
				DE5->DE5_STATUS := '2'			//-- Encerrado
				DE5->(MsUnLock())

				/*----------------------------------------------------
				Atualiza Status PA9
				-----------------------------------------------------*/
				PA9->(dbSetOrder(2))				
				If PA9->(dbSeek(xFilial('PA9') + DTOS((cAliasDE5)->DE5_XDTPRO) + (cAliasDE5)->DE5_XCORTE + (cAliasDE5)->DE5_XARQ ))
					PA9->(RecLock("PA9",.F.))
						PA9->PA9_STATUS := 'L'			//-- Lote Gerado
					PA9->(MsUnLock())
				EndIf	
				
				(cAliasDE5)->(dbSkip())
			EndDo
		Else
			
			While (cAliasDE5)->( !Eof() ) .AND. (cAliasDE5)->DE5_CGCDES = cCNPJDes //.AND. (cAliasDE5)->DE5_XZONA = cZona_Ant
				
				IncProc()
				
				_cFilOri := SM0->M0_CODFIL //xFilial("DE5") //(cAliasDE5)->DE5_FILIAL
				
				/*-----------------------------------------------------
				Grava lote atual
				-----------------------------------------------------*/
				If Empty(cNumLote)
					// cNumLote := GetSx8Num("DTP","DTP_LOTNFC")
					cNumLote := CriaVar("DTP_LOTNFC",.T.) // inicializa com caracteristica do campo, quando .F. n�o executa inicializador padr�o
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
				Pego informa��es da NF-e na tabela SZ6
				-----------------------------------------------------*/
				_aRetInfNFe[1] := _aRetInfNFe[2] := ""  // 1 = ID NF-e ; 2 = CFOP
				_aRetInfNFe := fBuscaNFEID((cAliasDE5)->DE5_DOC,(cAliasDE5)->DE5_SERIE,(cAliasDE5)->DE5_CGCREM)

				// Se for NF-e do dia anterior processa
				If (cAliasDE5)->DE5_XDIA <> '1'				
					// Verificar regra para o LPA PSA Porto Real
					If !fVerRegra(AllTrim((cAliasDE5)->DE5_XCORTE), AllTrim((cAliasDE5)->DE5_XZONA), AllTrim((cAliasDE5)->DE5_XARMAZ), AllTrim((cAliasDE5)->DE5_XARQ), ((cAliasDE5)->R_E_C_N_O_))
						dbSelectArea((cAliasDE5))
						(cAliasDE5)->(dbSkip())
						Loop
					EndIf	
				EndIf
					
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
				DTC->DTC_CF     := IIF(EMPTY((cAliasDE5)->DE5_CFOPNF),_aRetInfNFe[2],(cAliasDE5)->DE5_CFOPNF)  // Na implatan��o do CT-e - 13-07-2013		
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

				/*----------------------------------------------------
				Atualiza Status PA9
				-----------------------------------------------------*/
				PA9->(dbSetOrder(2))				
				If PA9->(dbSeek(xFilial('PA9') + DTOS((cAliasDE5)->DE5_XDTPRO) + (cAliasDE5)->DE5_XCORTE + (cAliasDE5)->DE5_XARQ ))
					PA9->(RecLock("PA9",.F.))
						PA9->PA9_STATUS := 'L'			//-- Lote Gerado
					PA9->(MsUnLock())
				EndIf	
				
				(cAliasDE5)->(dbSkip())
			EndDo
		EndIf
		/*-----------------------------------------------------
		ReGrava Arquivo de Lotes - Quantidades
		-----------------------------------------------------*/
		If nQtdNf > 0 //regrava quando gerar alguma nota
			EdiGrvLote(cNumLote)
		Else
			MsgBox("N�o ha dados para processar! ","Lote Nao Gerado","INFO")
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

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �EdiGrvLote� Autor � Katia Alves Bianchi   � Data � 18.05.09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Gravar o numero do lote                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � EdiGrvLote()                                               ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
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


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CriaSX1   � Autor �Katia Alves Bianchi    � Data �18/05/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajuste de Perguntas (SX1)                 			      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function CriaSX1()

_sAlias := Alias()																		
dbSelectArea("SX1")
dbSetOrder(1)
aRegs :={}

//(sx1) Grupo/Ordem/Pergunta/X1_PERSPA/X1_PERENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSpa1/DefEng1/Cnt01/Var02/Def02/DefSpa2/DefEng2/Cnt02/Var03/Def03/DefSpa3/DefEng3/Cnt03/Var04/Def04/DefSpa4/DefEng4/Cnt04/Var05/Def05/DefSpa5/DefEng5/Cnt05/F3
aAdd(aRegs,{cPerg,"01","Cliente              ?","�De Cliente    ?","From Customer  ?","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
aAdd(aRegs,{cPerg,"02","Loja                 ?","�De Tienda     ?","From unit      ?","mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Tipo Transporte      ?","�Tipo Transporte ?","Tipo Transporte ?","mv_ch3","N",1,0,0,"C","","mv_par03","Rodoviario","","","","","Aereo","","","","","","","","","","","","","","","","","","","","","","",""})

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
_cEMail := aUser[1,14] // Busca o e-mail do usu�rio 

cCc      := "" 
cPara    := _cEMail 
cDe      := GETMV("MV_RELFROM")

If Empty(_cEMail)
	MsgInfo("Favor informar e-mail no cadastro de usu�rio, para receber Log de Processamento","Informa��o")
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
	
   cMsg += "<BR><BR><BR><BR>e-mail autom�tico, favor n�o respond�-lo"
   
	*---------------------------------------------*
	U_EnvEmail(cDe,cPara,cCc,cAssunto,cMsg,cAnexo)
	*---------------------------------------------*	
EndIf
	              
Return()                                                                                                 

**********************************************************
* Por: Ricardo Guimar�es - Em: 05/11/2013                *
* Objetivo: Buscar o informa��es da NF-e na tabela SZ6   *
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fMontPerg �Autor  � Vin�cius Moreira   � Data � 12/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta tela de filtro por zonas.                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fMontPerg ()

Local lRet      := .F.
Local cQuery    := ""
Local cAliasQry := ""
Local aZonaPri  := Separa(GetMv("ES_XZONAS",,"BR: SP-1,BR: SP-2,BR: SP-3,BR: SP-4,BR: SP-5"), ",")
Local cZonas1   := ""
Local cZonas2   := ""
Local aZonas    := {}
Local nX        := 0
Local cCorte	:= ''

SA1->(dbSetOrder(1))//A1_FILIAL+A1_COD+A1_LOJA
If SA1->(dbSeek(xFilial("SA1")+mv_par01+mv_par02))
	cAliasQry := GetNextAlias()
	//���������������������������������������������������������������������������������Ŀ
	//�Busca zonas disponiveis para escolha.                                            �
	//�����������������������������������������������������������������������������������
	cQuery := " SELECT " + CRLF 
	cQuery += "    DE5.DE5_XZONA ZONA " + CRLF
	cQuery += "   FROM "+RetSqlName("DE5") + " DE5 " + CRLF
	cQuery += "  WHERE DE5.D_E_L_E_T_ = ' '" + CRLF
	cQuery += "    AND DE5.DE5_FILIAL = '" + xFilial("DE5") + "' " + CRLF
	cQuery += "    AND DE5.DE5_STATUS <> '2'" + CRLF
	cQuery += "    AND DE5.DE5_MSBLQL = '2'" + CRLF
	cQuery += "    AND DE5.DE5_CGCREM = '"+SA1->A1_CGC+"'" + CRLF
	cQuery += "    AND DE5.DE5_TIPTRA = '"+Alltrim(Str(MV_PAR03))+"'" + CRLF
	cQuery += "    AND DE5_XDTPRO = '" + DTOS(dDATABASE) + "' "
	cQuery += "    AND DE5_XDIA  <> '1'	
	cQuery += " UNION "
	cQuery += " SELECT " + CRLF 
	cQuery += "    DE5.DE5_XZONA ZONA " + CRLF
	cQuery += "   FROM "+RetSqlName("DE5") + " DE5 " + CRLF
	cQuery += "  WHERE DE5.D_E_L_E_T_ = ' '" + CRLF
	cQuery += "    AND DE5.DE5_FILIAL = '" + xFilial("DE5") + "' " + CRLF
	cQuery += "    AND DE5.DE5_STATUS <> '2'" + CRLF
	cQuery += "    AND DE5.DE5_MSBLQL = '2'" + CRLF
	cQuery += "    AND DE5.DE5_CGCREM = '"+SA1->A1_CGC+"'" + CRLF
	cQuery += "    AND DE5.DE5_TIPTRA = '"+Alltrim(Str(MV_PAR03))+"'" + CRLF
	cQuery += "   AND DE5_XDTPRO < '" + DTOS(dDATABASE) + "' "
	cQuery += "   AND DE5_XDIA   = '1'
		
	cQuery += " GROUP BY " + CRLF
	cQuery += "    DE5.DE5_XZONA " + CRLF
	cQuery += " ORDER BY " + CRLF
	cQuery += "    DE5.DE5_XZONA " + CRLF
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
	
	If (cAliasQry)->(!Eof())
		While (cAliasQry)->(!Eof())
			cCorte := IIF(AllTrim((cAliasQry)->ZONA) $ cZCorte1, '1o.Corte', IIF(AllTrim((cAliasQry)->ZONA) $ cZCorte2, '2.Corte', "Outros" )) 
			aAdd(aZonas,{	.F.,;
							(cAliasQry)->ZONA,;
							cCorte,;
							""})
			(cAliasQry)->(dbSkip())
		EndDo
		//���������������������������������������������������������������������������������Ŀ
		//�Exibe tela para sele��o de zonas disponiveis para calculo.                       �
		//�����������������������������������������������������������������������������������		
		aZonas := fSelZona(aZonas)
		//���������������������������������������������������������������������������������Ŀ
		//�Se alguma zona estiver disponivel, executa processamento.                        �
		//�����������������������������������������������������������������������������������		
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
	Aviso("AVISO","Cliente n�o cadastrado",{"Ok"})
EndIf

Return lRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fSelZona �Autor  � Vin�cius Moreira   � Data � 13/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela para sele��o das zonas de processamento.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*/{Protheus.doc} fSelZona
//TODO Descri��o auto-gerada.
@author u297686
@since 23/02/2017
@version undefined
@param aListBox, array, descricao
@type function
/*/
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
											aListBox[ oListBox:nAT,SZCORTE	],;															
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

/***********************************************
 * Fun��o: Verifica regra para gera��o de lote *
 * Por: Ricardo Guimar�es - Em: 23/02/2017     *
 ***********************************************/
Static Function fVerRegra(_cCorte, _cZona, _cArmazem, _cSeqArq, _nRecNo)
Local _lRet := .F.

// Se Zona do Primeiro Corte
If _cCorte == '01'
	// Se NF-e � do Tech Center(TC)
	If _cArmazem $ cTC
		// Se primeiro arquivo do primeiro corte
		If _cSeqArq == "01"
			_lRet := .T.
		Else
			_lRet := .F.
			// Marco NF para ser processamento no dia seguinte
			DE5->(dbGoTo(_nRecNo))
			DE5->(RecLock('DE5'))
				DE5->DE5_XDIA := '1'
			DE5->(MsUnLock())
		EndIf	
	ElseIf _cArmazem $ cPN
		// Se primeiro ou segundo arquivo do primeiro corte
		If _cSeqArq <= "02"
			_lRet := .T.
		Else
			_lRet := .F.
			// Marco NF para ser processamento no dia seguinte
			DE5->(dbGoTo(_nRecNo))
			DE5->(RecLock('DE5'))
				DE5->DE5_XDIA := '1'
			DE5->(MsUnLock())
		EndIf
	Else
		// Registra no Log
		_lRet := .F.						
	EndIf
// Se Zona do Segundo Corte	
ElseIf _cCorte == '02'
	// Se NF-e � do Tech Center(TC)
	If _cArmazem $ cTC
		// Se primeiro/segundo/terceiro arquivo do segundo corte
		If _cSeqArq <= "03"
			_lRet := .T.
		Else
			_lRet := .F.
			// Marco NF para ser processamento no dia seguinte
			DE5->(dbGoTo(_nRecNo))
			DE5->(RecLock('DE5'))
				DE5->DE5_XDIA := '1'
			MsUnLock
		EndIf	
	ElseIf _cArmazem $ cPN
		_lRet := .T.
	Else
		// Registra no Log
		_lRet := .F.		
	EndIf
Else
	_lRet := .F.	
	// Registra no Log		
EndIf

Return _lRet