#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GECTBA27 Autor ³ Ricardo de Guimarães  º Data ³  25/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Contabilização de Pis e Confins (Crédito)                  º±±
±±º          ³ Evolução do fonte GECTBA24                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEFCO                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GECTBA27()

Local cDesc1       := "Este programa tem como objetivo de contabilizar o  "
Local cDesc2       := "PIS e COFINS - Crédito"
Local cDesc3       := ""
Local cPict        := ""
Local imprime      := .T.
Local aOrd         := {}
Private Cabec1     := "" 
Private Cabec2     := ""
Private nLin       := 80
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "G"
Private nomeprog   := "GECTBA27" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GECTBA27" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "CT2"
Private cPerg      := "GECT27"   //"CTR040"
Private aArea      := {}
              

titulo := "Contabilização de PIS e COFINS (Crédito)"

ValidPerg()

Pergunte(cPerg,.F.)                           // Pergunta no SX1

wnrel := SetPrint(cString,NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo) },Titulo)


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  30/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo)

Local cCfop := ""
Private nPos   := 0
Private cQuery := ""

//Variáveis utilizadas no lançamento contábil
Private nValCred := 0
Private nValDeb  := 0
Private cArquivo  := ""
Private nTotal    := 0
Private nContador := 1
Private lDigita   := .T.
Private cPadrao := ""
Private nPrazoC  := 0  
Private nVistaC  := 0  
Private nPrazoD  := 0  
Private nVistaD  := 0  
Private nHdlPrv := ""
Private nValorFil := 0
Private nBaseIcm  := 0
Private nValIcm   := 0
Private nValorCTB := 0
Private nPerc      := MV_PAR07  // % 
Private aCampos   := {}
Private cNome     := ""
Private cIndex, cChave,nIndex 
Private cUONCred   := "31,32,33,34,35,37,38,51,61" // GetMvPar("MV_XUONPF") // Relação de UOs que não tem crédito de PIS e COFINS. O valor é utilizado rateio.
Private cUOSCred   := "01,02,11,21,22,23" // GetMvPar("MV_XUOSPF") // Relação de UOs que tem crédito de PIS e COFINS. O seu valor é adicionado ao rateio.
Private nPcRDVM    := GetMv("MV_XPCRDVM")  //0.36  // Porcentagem de rateio do RDVM.
Private nPcRMLAP   := GetMv("MV_XPCRMLA") //0.382  // Porcentagem de rateio do RMLAP.
Private nPcRMA     := GetMv("MV_XPCRMA") //0.203   // Porcentagem de rateio do RMA.
Private nPcILI     := GetMv("MV_XPCILI") // 0.055  // Porcentagem de rateio do ILI.
Private cCtPIS     := GetMv("MV_XCTPIS") //Parâmetro de conta contábil - PIS
Private cCtPISA    := GetMv("MV_XCTPISA") //Parâmetro de conta contábil - PIS a Recolher
Private cCtCOFINS  := GetMv("MV_XCTCOF") //Parâmetro de conta contábil - COFINS
Private cCtCOFINSA := GetMv("MV_XCTCOFA") //Parâmetro de conta contábil - COFINS a Recolher
Private cTp        := "C"
Private nValPis    := 0
Private nValCofins := 0
Private nAliqPIS   := (GetMv("MV_XALQPIS") /100) //Parâmetro de conta contábil - PIS

Private nAliqCofins:= (GetMv("MV_XALQCOF") /100) //Parâmetro de conta contábil - COFINS

Private aSede      := {0,0,0,0,0} 
Private aTotUo     := {0,0,0,0,0} 
Private aTotal     := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} 
Private nVlrTot    := 0 
Private nCRDVM    := 0  // Valor de Pis RDVM
Private nCRMLAP   := 0 // Valor de Pis RMLAP.
Private nCRMA     := 0 // Valor de Pis RMA.
Private nCILI     := 0 // Valor de Pis ILI.

Private nPRDVM    := 0  // Valor de COFINS RDVM
Private nPRMLAP   := 0 // Valor de COFINS RMLAP.
Private nPRMA     := 0 // Valor de COFINS RMA.
Private nPILI     := 0 // Valor de COFINS ILI.

Private n713201    := 0  // Valor da conta 713201
Private n713203    := 0 // VValor da conta 713203
Private n711101    := 0 // Valor da conta 711101
Private n711107    := 0 // Valor da conta 711107

// Por: Ricardo - Em: 25/01/2010
Private n711109    := 0  // Valor da conta 711109
Private n713408    := 0  // Valor da conta 713408
Private n713706    := 0  // Valor da conta 713706
Private n713709    := 0  // Valor da conta 713709
Private n713710    := 0  // Valor da conta 713710
Private n713711    := 0  // Valor da conta 713711
// Por: Ricardo - Em: 05/11/2014
Private n713911    := 0  // Valor da conta 713911

aCampos:={}
Aadd(aCampos,{"INDICE" ,"N",03,0 })
Aadd(aCampos,{"CT_CUSTO"  ,"C",10,0 })
Aadd(aCampos,{"CT_713201" ,"N",15,2 })
Aadd(aCampos,{"CT_713203" ,"N",15,2 })
Aadd(aCampos,{"CT_711101" ,"N",15,2 })
Aadd(aCampos,{"CT_711107" ,"N",15,2 })

// Por: Ricardo - Em: 25/01/2010
Aadd(aCampos,{"CT_711109" ,"N",15,2 })
Aadd(aCampos,{"CT_713408" ,"N",15,2 })
Aadd(aCampos,{"CT_713706" ,"N",15,2 })
Aadd(aCampos,{"CT_713709" ,"N",15,2 })
Aadd(aCampos,{"CT_713710" ,"N",15,2 })
Aadd(aCampos,{"CT_713711" ,"N",15,2 })
// Por: Ricardo - Em: 05/11/2014
Aadd(aCampos,{"CT_713911" ,"N",15,2 })

Aadd(aCampos,{"CT_CTB"    ,"L",1,0  })
Aadd(aCampos,{"CT_VRAT"   ,"N",15,2 })
Aadd(aCampos,{"CT_VTOT"   ,"N",17,2 })
			

/*PRD	:=	CriaTrab(aCampos)

dbUseArea(.T.,__LocalDriver,cNome,"TST",.T.,.F.)
IndRegua("TST",cNome,"INDICE+CT_CUSTO",,,"Selecionando Registros")
DbSelectArea("TST")
DbClearIndex()
DbSetIndex(cNome+OrdBagExt())*/
                                
cArqTemp := CriaTrab(aCampos)

dbUseArea(.T.,__LocalDriver,cArqTemp,"TST") 
cChave := "str(INDICE)+CT_CUSTO"
IndRegua("TST",cArqTemp,cChave)		
DbSelectArea("TST")


/*cNome	:=	CriaTrab(aCampos)
dbUseArea(.T.,__LocalDriver,cNome,"TST",.T.,.F.)

cIndex := CriaTrab(nil,.f.)
IndRegua("TST",cIndex,cChave,,,"Selecionando Registros...TRA")
DbSelectArea("TST")*/
/*DbClearIndex()
DbSetIndex(cIndex+OrdBagExt())*/

nlin := 80
  
Titulo := "APURACAO DO CREDITO DO PIS/COFINS POR UO -  Periodo ( " + DTOC(MV_PAR01) + " - " + DTOC(MV_PAR02) + " )"
//Cabec1 := "Cod C.C      UO  713201          713203          711101          711107          Total           Rat.Sede    T. c/rateio" 
  Cabec1 := "Cod C.C      UO       713201         713203          711101          711107          711109          713408        713706        713709         713710        713711       713911         Total       Rat. da Sede   Total c/rateio"

//Incluindo os campos relativos a centro de custo que não possuem credito de Pis e Cofins e seu valor é feito rateio
cQuery := "SELECT DISTINCT SUBSTRING(CT3_CUSTO,2,2),CT3_CUSTO " 
cQuery += " FROM " + RetSqlName("CT3") + "  "
cQuery += " WHERE CT3_DATA >= " + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " CT3_DATA <= " + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " SUBSTRING(CT3_CUSTO,2,2) IN (" + cUONCred + ") AND LEN(CT3_CUSTO) = 6 AND "
cQuery += " CT3_CONTA IN ('713201','713203','711101','711107','711109','713408','713706','713709','713710','713711','713911')
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY SUBSTRING(CT3_CUSTO,2,2), CT3_CUSTO "

cQuery := ChangeQuery(cQuery)

TcQuery cQuery Alias "TCT3" NEW
DbSelectArea("TCT3")
DbGoTop()         

While !eof() 
	n713201    := MovCusto("713201", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713201
	n713203    := MovCusto("713203", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3) // VValor da conta 713203
	n711101    := MovCusto("711101", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3) // Valor da conta 711101
	n711107    := MovCusto("711107", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3) // Valor da conta 711107
		
	// Por: Ricardo - Em: 25/01/2010
	n711109    := MovCusto("711109", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 711109
	n713408    := MovCusto("713418", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713408
	n713706    := MovCusto("713706", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713706
	n713709    := MovCusto("713709", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713709
	n713710    := MovCusto("713710", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713710
	n713711    := MovCusto("713711", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713711	
	// Por: Ricardo - Em: 05/11/2014	
	n713911    := MovCusto("713911", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713911

	DbSelectArea("TST") 
	RecLock("TST",.T.)
//	aArea := GetArea()
	TST->INDICE 	:= nContador
	TST->CT_CUSTO	:= TCT3->CT3_CUSTO	
	TST->CT_713201	:= n713201 //
	TST->CT_713203	:= n713203 //
	TST->CT_711101	:= n711101 //
	TST->CT_711107	:= n711107 //
	TST->CT_CTB		:= .F.       

	// Por: Ricardo - Em: 25/01/2010	
	TST->CT_711109	:= n711109 //
	TST->CT_713408	:= n713408 //	
	TST->CT_713706	:= n713706 //		
	TST->CT_713709	:= n713709 //		
	TST->CT_713710	:= n713710 //			
	TST->CT_713711	:= n713711 //			
// Por: Ricardo - Em: 05/11/2014
	TST->CT_713911	:= n713911 //
		
//	RestArea(aArea)      
	MsUnLock()
	//fazendo somatório da Sede apra aplicar o rateio
    aSede[1] := aSede[1] + TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107    
	// Por: Ricardo - Em: 25/01/2010	    
    aSede[1] += TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911
    
	nContador ++  	
	DbSelectArea("TCT3")
	DbSkip()
end                                   

//fazendo o cálculo do rateio
aSede[2] :=     aSede[1] * nPcRDVM    // Porcentagem de rateio do RDVM.
aSede[3] :=     aSede[1] * nPcRMLAP   // Porcentagem de rateio do RMLAP.
aSede[4] :=     aSede[1] * nPcRMA     // Porcentagem de rateio do RMA.
aSede[5] :=     aSede[1] * nPcILI     // Porcentagem de rateio do ILI.

DbSelectArea("TCT3")
DbCloseArea()


//Incluindo os campos relativos a centro de custo de 6 digitos
cQuery := "SELECT DISTINCT SUBSTRING(CT3_CUSTO,2,2),CT3_CUSTO " 
cQuery += " FROM " + RetSqlName("CT3") + "  "
cQuery += " WHERE CT3_DATA >= " + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " CT3_DATA <= " + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " SUBSTRING(CT3_CUSTO,2,2) IN (" + cUOSCred + ") AND LEN(CT3_CUSTO) = 6 AND "
cQuery += " CT3_CONTA IN ('713201','713203','711101','711107','711109','713408','713706','713709','713710','713711','713911')  
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY SUBSTRING(CT3_CUSTO,2,2), CT3_CUSTO "

cQuery := ChangeQuery(cQuery)

TcQuery cQuery Alias "TCT3" NEW
DbSelectArea("TCT3")
DbGoTop()         

While !eof() 


	n713201    := MovCusto("713201", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713201
	n713203    := MovCusto("713203", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3) // VValor da conta 713203
	n711101    := MovCusto("711101", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3) // Valor da conta 711101
	n711107    := MovCusto("711107", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3) // Valor da conta 711107

	// Por: Ricardo - Em: 25/01/2010
	n711109    := MovCusto("711109", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 711109
	n713408    := MovCusto("713418", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713408
	n713706    := MovCusto("713706", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713706
	n713709    := MovCusto("713709", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713709
	n713710    := MovCusto("713710", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713710
	n713711    := MovCusto("713711", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713711	
	// Por: Ricardo - Em: 05/11/2014
	n713911    := MovCusto("713911", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713911
	
	DbSelectArea("TST") 	
	RecLock("TST",.T.)
	TST->INDICE 	:= nContador
	TST->CT_CUSTO	:= TCT3->CT3_CUSTO	
	TST->CT_713201	:= n713201 //
	TST->CT_713203	:= n713203 //
	TST->CT_711101	:= n711101 //
	TST->CT_711107	:= n711107 //       
	
	// Por: Ricardo - Em: 25/01/2010	
	TST->CT_711109	:= n711109 //
	TST->CT_713408	:= n713408 //	
	TST->CT_713706	:= n713706 //		
	TST->CT_713709	:= n713709 //		
	TST->CT_713710	:= n713710 //			
	TST->CT_713711	:= n713711 //			
	// Por: Ricardo - Em: 05/11/2014	
	TST->CT_713911	:= n713911 //
		
	TST->CT_CTB		:= .T.
    
    aTotUO[1] := aTotUO[1] + TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911
	If SubStr(TCT3->CT3_CUSTO,2,2) $ "01|02" // RDVM
	    aTotUO[2] := aTotUO[2] + TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911
	ElseIf	SubStr(TCT3->CT3_CUSTO,2,2) == "11" //  RMLAP
	    aTotUO[3] := aTotUO[3] + TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911
	ElseIf	SubStr(TCT3->CT3_CUSTO,2,2) $ "22|23" // RMA	
	    aTotUO[4] := aTotUO[4] + TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911
	ElseIf	SubStr(TCT3->CT3_CUSTO,2,2) == "21" // ILI 	
	    aTotUO[5] := aTotUO[5] + TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911
	EndIF

	MsUnLock()  
	
	nContador ++	
	DbSelectArea("TCT3")
	DbSkip()
end

DbSelectArea("TCT3")
DbCloseArea()


//Incluindo os campos relativos a centro de custo de 10 digitos
cQuery := "SELECT DISTINCT SUBSTRING(CT3_CUSTO,2,2),CT3_CUSTO " 
cQuery += " FROM " + RetSqlName("CT3") + "  "
cQuery += " WHERE CT3_DATA >= " + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " CT3_DATA <= " + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " SUBSTRING(CT3_CUSTO,2,2) IN (" + cUOSCred + ") AND LEN(CT3_CUSTO) = 10 AND "
cQuery += " CT3_CONTA IN ('713201','713203','711101','711107','711109','713408','713706','713709','713710','713711','713911')  AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY SUBSTRING(CT3_CUSTO,2,2), CT3_CUSTO "

cQuery := ChangeQuery(cQuery)

TcQuery cQuery Alias "TCT3" NEW
DbSelectArea("TCT3")
DbGoTop()         

While !eof() 

	n713201    := MovCusto("713201", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713201
	n713203    := MovCusto("713203", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3) // VValor da conta 713203
	n711101    := MovCusto("711101", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3) // Valor da conta 711101
	n711107    := MovCusto("711107", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3) // Valor da conta 711107

	// Por: Ricardo - Em: 25/01/2010
	n711109    := MovCusto("711109", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 711109
	n713408    := MovCusto("713418", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713408
	n713706    := MovCusto("713706", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713706
	n713709    := MovCusto("713709", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713709
	n713710    := MovCusto("713710", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713710
	n713711    := MovCusto("713711", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713711	
	// Por: Ricardo - Em: 25/01/2010
	n713911    := MovCusto("713911", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 713911	

	DbSelectArea("TST") 
	RecLock("TST",.T.)
	TST->INDICE 	:= nContador
	TST->CT_CUSTO	:= TCT3->CT3_CUSTO	
	TST->CT_713201	:= n713201 //
	TST->CT_713203	:= n713203 //
	TST->CT_711101	:= n711101 //
	TST->CT_711107	:= n711107 //
	
	// Por: Ricardo - Em: 25/01/2010
	TST->CT_711109	:= n711109 //
	TST->CT_713408	:= n713408 //
	TST->CT_713706	:= n713706 //
	TST->CT_713709	:= n713709 //
	TST->CT_713710	:= n713710 //
	TST->CT_713711	:= n713711 //
	TST->CT_713911	:= n713911 //
	
	TST->CT_CTB		:= .T.
    
    aTotUO[1] := aTotUO[1] + TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911
	If SubStr(TCT3->CT3_CUSTO,2,2) $ "01|02" // RDVM
	    aTotUO[2] := aTotUO[2] + TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911
	ElseIf	SubStr(TCT3->CT3_CUSTO,2,2) == "11" //  RMLAP
	    aTotUO[3] := aTotUO[3] + TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911
	ElseIf	SubStr(TCT3->CT3_CUSTO,2,2) $ "22|23" // RMA	
	    aTotUO[4] := aTotUO[4] + TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911
	ElseIf	SubStr(TCT3->CT3_CUSTO,2,2) == "21" // ILI 	
	    aTotUO[5] := aTotUO[5] + TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107+ TST->CT_711109  + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911
	EndIF
	DbSelectArea("TST")
	MsUnLock()
	
	nContador++
	DbSelectArea("TCT3")
	DbSkip()
end

DbSelectArea("TCT3")
DbCloseArea()

//Atulizando os valores para rateio
DbSelectArea("TST")
//DbSetOrder(1)
DbGoTop()
//IndRegua("TST",cArqTemp,cChave)		

While !Eof()             

	If TST->CT_CTB                  
		RecLock("TST",.F.)
		If SubStr(TST->CT_CUSTO,2,2) $ "01|02" // RDVM
		    TST->CT_VRAT := ((TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911) / aTotUO[2]) * aSede[2] 			
			TST->CT_VTOT := TST->CT_VRAT + TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911
		ElseIf	SubStr(TST->CT_CUSTO,2,2) == "11" //  RMLAP
		    TST->CT_VRAT := ((TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911) / aTotUO[3]) * aSede[3] 					
			TST->CT_VTOT := TST->CT_VRAT + TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911
		ElseIf	SubStr(TST->CT_CUSTO,2,2) $ "22|23" // RMA	
		    TST->CT_VRAT := ((TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911) / aTotUO[4]) * aSede[4] 			
			TST->CT_VTOT := TST->CT_VRAT + TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911
		ElseIf	SubStr(TST->CT_CUSTO,2,2) == "21" // ILI 
		    TST->CT_VRAT := ((TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911) / aTotUO[5]) * aSede[5]
			TST->CT_VTOT := TST->CT_VRAT + TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911
		EndIF           
		DbSelectArea("TST") 
		MsUnLock()		
	EndIf
	
	DbSelectArea("TST")	
	DbSkip()
End

//Imprimindo
DbSelectArea("TST") 
//DbSetOrder(1)
DbGoTop()
SetRegua(RecCount())
//         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
//12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234

//Cod C.C     UO  713201	      713203	      711101		  711107    	  Total			  Rat. da Sede	  Total com rateio
//XXXXXXXXXX  XX  XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX

//Cod C.C     UO  713201	      713203	      711101		  711107    	  711109          713408          713706          713709          713710          713711          713911         Total		   Rat. da Sede	Total com rateio
//XXXXXXXXXX  XX  XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX
                          
nValorCTB := 0    
While !Eof() 
    
	IncRegua()

    If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    	nLin := 8
		nLin ++		
    Endif       

    @nLin,000 PSAY TST->CT_CUSTO
    @nLin,013 PSAY SubStr(TST->CT_CUSTO,2,2)
    @nLin,017 PSAY TST->CT_713201 PICTURE "@E 99,999,999.99"
    @nLin,032 PSAY TST->CT_713203 PICTURE "@E 99,999,999.99"
    @nLin,047 PSAY TST->CT_711101 PICTURE "@E 99,999,999.99"
    @nLin,062 PSAY TST->CT_711107 PICTURE "@E 99,999,999.99"
	// Por: Ricardo - Em: 25/01/2010        
    @nLin,077 PSAY TST->CT_711109 PICTURE "@E 99,999,999.99"
    @nLin,092 PSAY TST->CT_713408 PICTURE "@E 99,999,999.99"
    @nLin,107 PSAY TST->CT_713706 PICTURE "@E 99,999,999.99"
    @nLin,122 PSAY TST->CT_713709 PICTURE "@E 99,999,999.99"    
    @nLin,137 PSAY TST->CT_713710 PICTURE "@E 99,999,999.99"    
    @nLin,152 PSAY TST->CT_713711 PICTURE "@E 99,999,999.99"    
    // Por: Ricardo - Em: 05/11/2014
    @nLin,167 PSAY TST->CT_713911 PICTURE "@E 99,999,999.99"    
    
    //@nLin,081 PSAY (TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 ) PICTURE "@E 999,999,999.99"   		
    
    @nLin,182 PSAY (TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911 ) PICTURE "@E 999,999,999.99"   	
    @nLin,197 PSAY TST->CT_VRAT PICTURE "@E 999,999,999.99"   	
    @nLin,212 PSAY TST->CT_VTOT PICTURE "@E 999,999,999.99"   	
	nLin++

	aTotal[1] :=    aTotal[1]  +    TST->CT_713201  
	aTotal[2] :=    aTotal[2]  +    TST->CT_713203  
	aTotal[3] :=    aTotal[3]  +    TST->CT_711101 
	aTotal[4] :=    aTotal[4]  +    TST->CT_711107 
	aTotal[5] :=    aTotal[5]  +    (TST->CT_713201 + TST->CT_713203 + TST->CT_711101 + TST->CT_711107 + TST->CT_711109 + TST->CT_713408 + TST->CT_713706 + TST->CT_713709 + TST->CT_713710 + TST->CT_713711 + TST->CT_713911) 
	aTotal[6] :=    aTotal[6]  +    TST->CT_VRAT 
	aTotal[7] :=    aTotal[7]  +    TST->CT_VTOT 

	// Por: Ricardo - Em: 25/01/2010
	aTotal[09] :=    aTotal[09]  +    TST->CT_711109  
	aTotal[10] :=    aTotal[10]  +    TST->CT_713408  
	aTotal[11] :=    aTotal[11]  +    TST->CT_713706 
	aTotal[12] :=    aTotal[12]  +    TST->CT_713709 
	aTotal[13] :=    aTotal[13]  +    TST->CT_713710
	aTotal[14] :=    aTotal[14]  +    TST->CT_713711
	// Por: Ricardo - Em: 05/11/2014	
	aTotal[15] :=    aTotal[15]  +    TST->CT_713911	

	DbSelectArea("TST")
  	DbSkip()
    IncRegua()
Enddo

If 	aTotal[1]  + aTotal[2]  + aTotal[3]  + aTotal[4]  + aTotal[5]  + aTotal[6]  + aTotal[7] +;
	aTotal[09] + aTotal[10] + aTotal[11] + aTotal[12] + aTotal[13] + aTotal[14] + aTotal[15] <> 0
	
	nLin++             
    @nLin,000 PSAY Replicate("-",Iif(tamanho=="G",220,132))
	nLin++                 
    @nLin,000 PSAY "Total"
    @nLin,016 PSAY aTotal[01] PICTURE "@E 999,999,999.99"   	
    @nLin,031 PSAY aTotal[02] PICTURE "@E 999,999,999.99"   	
    @nLin,046 PSAY aTotal[03] PICTURE "@E 999,999,999.99"   	
    @nLin,061 PSAY aTotal[04] PICTURE "@E 999,999,999.99"   	
	// Por: Ricardo - Em: 25/01/2010            
    @nLin,076 PSAY aTotal[09] PICTURE "@E 999,999,999.99"   	    
    @nLin,091 PSAY aTotal[10] PICTURE "@E 999,999,999.99"   	        
    @nLin,106 PSAY aTotal[11] PICTURE "@E 999,999,999.99"   	            
    @nLin,121 PSAY aTotal[12] PICTURE "@E 999,999,999.99"   	            
    @nLin,136 PSAY aTotal[13] PICTURE "@E 999,999,999.99"
    @nLin,151 PSAY aTotal[14] PICTURE "@E 999,999,999.99"    
    // Por: Ricardo - Em: 05/11/2014
    @nLin,166 PSAY aTotal[15] PICTURE "@E 999,999,999.99"    
        
    @nLin,181 PSAY aTotal[05] PICTURE "@E 999,999,999.99"   	
    @nLin,196 PSAY aTotal[06] PICTURE "@E 999,999,999.99"   	
    @nLin,211 PSAY aTotal[07] PICTURE "@E 9,999,999,999.99"   	
	nLin++
	
EndIF

Cabec1 := "                  PIS             CONTA           COFINS          CONTA"

nLin := 120

 If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
  	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   	nLin := 6
	nLin ++		
 Endif      
 
 nLin ++		       

DbSelectArea("TST") 
//DbSetOrder(1)
DbGoTop()
SetRegua(RecCount())

@nLin,019 PSAY nAliqPIS*100
@nLin,051 PSAY nAliqCofins*100
     
nLin ++
nLin ++
                             
aTotal[1] := 0
aTotal[2] := 0 

While !Eof()
	 If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
	  	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	nLin := 6
		nLin ++		
	 Endif      
	
	@nLin,019 PSAY TST->CT_VTOT * 0.0165 PICTURE "@E 999,999,999.99"
	aTotal[1]	:= aTotal[1] + (TST->CT_VTOT * nAliqPIS)
	@nLin,035 PSAY cCtPIS
	@nLin,051 PSAY TST->CT_VTOT * 0.076 PICTURE "@E 999,999,999.99"
	aTotal[2]	:= aTotal[2] + (TST->CT_VTOT * nAliqCofins)
	@nLin,067 PSAY cCtCOFINS
	nLin ++
	DbSelectArea("TST")
	DbSkip()
End

If aTotal[1] <> 0 .Or. aTotal[2] <> 0                       
	@nLin,000 PSAY Replicate("-",70)
	nLin++
	@nLin,000 PSAY "Total"
	@nLin,019 PSAY aTotal[1] PICTURE "@E 999,999,999.99"   	
	@nLin,051 PSAY aTotal[2] PICTURE "@E 999,999,999.99"   	
EndIF

Cabec1 := ""

nLin := 120

 If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
  	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   	nLin := 6
	nLin ++		
 Endif      

/* Imprimir o Resumo da apuração - total dos vetores */ 

//         1         2         3         4         5         6         7         8         9        10        11        12        10
//1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

//					Total           RDVM		    RMLAP	        RMA		   	    ILI
//Sede              XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX
//UO                XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX
//
//UO + rateio       XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX
//                           9.25              9.25            9.25            9.25            9.25
//
//                  XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX

//                  PIS             CONTA           COFINS          CONTA

@nLin,019 PSAY "Total "
@nLin,035 PSAY "RDVM (" + AllTrim(Str(nPCRDVM)) + ")"
@nLin,051 PSAY "RMLAP (" +  AllTrim(Str(nPCRMLAP))+ ")"
@nLin,067 PSAY "RMA (" +  AllTrim(Str(nPCRMA))+ ")"
@nLin,083 PSAY "ILI (" +  AllTrim(Str(nPCILI))+ ")"
nLin ++
@nLin,018 PSAY Replicate("-",70)
nLin ++
@nLin,001 PSAY "Sede"
@nLin,019 PSAY aSede[1] PICTURE "@E 999,999,999.99"   	
@nLin,035 PSAY aSede[2] PICTURE "@E 999,999,999.99"   	
@nLin,051 PSAY aSede[3] PICTURE "@E 999,999,999.99"   		
@nLin,067 PSAY aSede[4] PICTURE "@E 999,999,999.99"   				
@nLin,083 PSAY aSede[5] PICTURE "@E 999,999,999.99"   				
nLin ++
@nLin,001 PSAY "UO"
@nLin,019 PSAY aTotUO[1] PICTURE "@E 999,999,999.99"   	
@nLin,035 PSAY aTotUO[2] PICTURE "@E 999,999,999.99"   	
@nLin,051 PSAY aTotUO[3] PICTURE "@E 999,999,999.99"   		
@nLin,067 PSAY aTotUO[4] PICTURE "@E 999,999,999.99"   				
@nLin,083 PSAY aTotUO[5] PICTURE "@E 999,999,999.99"   				
nLin ++
nLin ++
@nLin,001 PSAY "UO + rateio"
@nLin,019 PSAY aTotUO[1] + aSede[1] PICTURE "@E 999,999,999.99"   	
@nLin,035 PSAY aTotUO[2] + aSede[2] PICTURE "@E 999,999,999.99"   	
@nLin,051 PSAY aTotUO[3] + aSede[3] PICTURE "@E 999,999,999.99"   		
@nLin,067 PSAY aTotUO[4] + aSede[4]  PICTURE "@E 999,999,999.99"   				
@nLin,083 PSAY aTotUO[5] + aSede[5]  PICTURE "@E 999,999,999.99"   				
nLin ++                     
@nLin,001 PSAY "                            9.25             9.25            9.25            9.25            9.25"                                                                       
nLin ++                     
nLin ++                     
@nLin,018 PSAY Replicate("-",70)
nLin ++

nPRDVM    := ((aTotUO[2] + aSede[2]) * 0.0165)
nPRMLAP   := ((aTotUO[3] + aSede[3]) * 0.0165)
nPRMA     := ((aTotUO[4] + aSede[4]) * 0.0165)
nPILI     := ((aTotUO[5] + aSede[5]) * 0.0165)

nCRDVM    := ((aTotUO[2] + aSede[2]) * 0.076)
nCRMLAP   := ((aTotUO[3] + aSede[3]) * 0.076)
nCRMA     := ((aTotUO[4] + aSede[4]) * 0.076)
nCILI     := ((aTotUO[5] + aSede[5]) * 0.076)

@nLin,019 PSAY (nPRDVM  + nCRDVM)  +;
			   (nPRMLAP + nCRMLAP) +; 
			   (nPRMA 	+ nCRMA)   +; 
			   (nPILI   + nCILI)    PICTURE "@E 999,999,999.99"   	
			   
@nLin,035 PSAY (nPRDVM  + nCRDVM) PICTURE "@E 999,999,999.99"   	
@nLin,051 PSAY (nPRMLAP + nCRMLAP) PICTURE "@E 999,999,999.99"   		
@nLin,067 PSAY (nPRMA 	+ nCRMA) PICTURE "@E 999,999,999.99"   				
@nLin,083 PSAY (nPILI   + nCILI) PICTURE "@E 999,999,999.99"   				
nLin ++                     
nLin ++                     

@nLin,001 PSAY "PIS"
@nLin,019 PSAY nPRDVM  + ;
			   nPRMLAP + ; 
			   nPRMA   +; 
			   nPILI       PICTURE "@E 999,999,999.99"   	
			   
@nLin,035 PSAY nPRDVM  PICTURE "@E 999,999,999.99"   	
@nLin,051 PSAY nPRMLAP PICTURE "@E 999,999,999.99"   		
@nLin,067 PSAY nPRMA   PICTURE "@E 999,999,999.99"   				
@nLin,083 PSAY nPILI   PICTURE "@E 999,999,999.99"   				
nLin ++                     
@nLin,001 PSAY "COFINS"
@nLin,019 PSAY nCRDVM  +;
			   nCRMLAP +; 
			   nCRMA   +; 
			   nCILI    PICTURE "@E 999,999,999.99"   	
			   
@nLin,035 PSAY nCRDVM  PICTURE "@E 999,999,999.99"   	
@nLin,051 PSAY nCRMLAP PICTURE "@E 999,999,999.99"   		
@nLin,067 PSAY nCRMA   PICTURE "@E 999,999,999.99"   				
@nLin,083 PSAY nCILI   PICTURE "@E 999,999,999.99"   				

nLin ++                     
@nLin,001 PSAY "Total"
@nLin,019 PSAY (nPRDVM  + nCRDVM)  +;
			   (nPRMLAP + nCRMLAP) +; 
			   (nPRMA 	+ nCRMA)   +; 
			   (nPILI   + nCILI)    PICTURE "@E 999,999,999.99"   	
			   
@nLin,035 PSAY (nPRDVM  + nCRDVM) PICTURE "@E 999,999,999.99"   	
@nLin,051 PSAY (nPRMLAP + nCRMLAP) PICTURE "@E 999,999,999.99"   		
@nLin,067 PSAY (nPRMA 	+ nCRMA) PICTURE "@E 999,999,999.99"   				
@nLin,083 PSAY (nPILI   + nCILI) PICTURE "@E 999,999,999.99"   				

SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()

If MV_PAR03 = 1 
	If MsgYesNo("Deseja contabilizar o crédito do PIS/COFINS?")//Rotina de Contabilização
		CTB()
	EndIF
EndIF

DbSelectArea( "TST" )		//Selecionando a area
//DbSetOrder( 1 )			//Posicionando na ordem de origem
fErase( cNome + OrdBagExt() )	//Deletando arquivo de trabalho*/

Return

***************************
Static Function ValidPerg()
***************************

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

DbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))

Aadd(aRegs,{cPerg,"01","Data de Emissao de     :","","","mv_ch1","D",008,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data de Emissao Ate    :","","","mv_ch2","D",008,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Contabiliza?           :","","","mv_ch3","C",001,0,0,"C","","mv_par03","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"06","Quebra pag. por filial :","","","mv_ch6","C",001,0,0,"C","","mv_par06","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","",""})

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

DbSelectArea(_sAlias)

Return(.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³CTBCRED      º Autor ³ Marcos Furtado  º Data ³  10/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Esta função contalibiliza os valores de crédito            º±±
±±º          ³ da tabela temporária totalizada por centro de custo        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FATURAMENTO                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*/
                         
                                             
Static Function CTB()
                           
//Variáveis Utilizadas na Rotina de Lançcamentos Contábeis
//************************
//Contabalizacao do PIS 
//************************
cPadrao  := "063" // CODIGO DO LANCAMENTO PADRAO PARA CONTABILIZACAO PIS

nHdlPrv := HeadProva("000001","CTBA102",Substr(cUsuario,7,6),@cArquivo) //Abre o lançamento contábil

nValorCTB := 0
                       
DbSelectArea("TST")
DbGoTop()
nValPis := 0
nTotal := 0
While !Eof()
	
	cCusto    := TST->CT_CUSTO
	iF TST->CT_VTOT < 0 
		cTp := "C"
		nValPis := (TST->CT_VTOT * nAliqPIS) * -1
	Else
		cTp := "D"	
		nValPis := TST->CT_VTOT * nAliqPIS
	EndIf
	
	nValorCTB := nValorCTB + nValPis
	nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CTBA102","000001") //Inclui uma linha no lançamento contábil
    
	nValPis := 0

	DbSelectArea("TST")
	DbSkip()

EndDo
	
If nValorCTB <> 0 
//	nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CTBA102","000001") //inclui o Último Lançamento de Débito
	RodaProva(nHdlPrv,nTotal) //Roda o Lançamento
	cA100Incl(cArquivo,nHdlPrv,3,"000001",lDigita,.F.) 	// Envia para Lancamento Contabil

EndIf

nValPis := 0

//Variáveis Utilizadas na Rotina de Lançcamentos Contábeis

//************************
//Contabalizacao do Cofins 
//************************

cPadrao  := "064" // CODIGO DO LANCAMENTO PADRAO PARA CONTABILIZACAO do cofins

nHdlPrv := HeadProva("000001","CTBA102",Substr(cUsuario,7,6),@cArquivo) //Abre o lançamento contábil

nValorCTB := 0
                                               
DbSelectArea("TST")
DbGoTop()

nValCofins := 0
nTotal := 0
While !Eof()

	cCusto    := TST->CT_CUSTO
	iF TST->CT_VTOT < 0 
		cTp := "C"
		nValCofins := (TST->CT_VTOT * nAliqCofins) * -1
	Else
		cTp := "D"	
		nValCofins := TST->CT_VTOT * nAliqCofins
	EndIf
	
	nValorCTB := nValorCTB + nValCofins
	nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CTBA102","000001") //Inclui uma linha no lançamento contábil
    
	nValCofins := 0

	DbSelectArea("TST")
	DbSkip()

EndDo
	
If nValorCTB <> 0 
//	nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CTBA102","000001") //inclui o Último Lançamento de Débito
	RodaProva(nHdlPrv,nTotal) //Roda o Lançamento
	cA100Incl(cArquivo,nHdlPrv,3,"000001",lDigita,.F.) 	// Envia para Lancamento Contabil

EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³CTBDEB      º Autor ³ Marcos Furtado  º Data ³  10/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Esta função contalibiliza os valores de Débitos            º±±
±±º          ³ da tabela temporária totalizada por centro de custo        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FATURAMENTO                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*/
                         
                                             
Static Function CTBDEB()

IndRegua("PRD",PRD,"REF+CONVENIO",,,"")
DbSelectArea("PRD")
DbClearIndex()
DbSetIndex(PRD+OrdBagExt())
DbGoTop()

If !Eof()
	If AllTrim(PRD->ERRO) = ""
		cRefencia := PRD->REF   
	Else 
		While AllTrim(PRD->ERRO) <> "" .and. !Eof()
			DbSkip()
		End
		If !Eof()
			cRefencia := PRD->REF   
		EndIf
	EndIf		

	While !Eof()
		If 	AllTrim(PRD->ERRO) <> ""
			DbSkip()
			Loop
		EndIf
	
		If 	cRefencia == PRD->REF   
			If PRD->PRAZO <> 0
				nPrazoD := nPrazoD + PRD->PRAZO
			EndIf
			If PRD->VISTA <> 0
				nVistaD := nVistaD + PRD->VISTA
			EndIf
	
		Else 
			nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CTBA102","000001") // Inlui o lançamento de débito
			
			nVistaD := 0
			nPrazoD := 0
			//Coloca o valor nas variáveis de Comparação
			cRefencia := PRD->REF   						
			If PRD->PRAZO <> 0
				nPrazoD := nPrazoD + PRD->PRAZO
			EndIf
			If PRD->VISTA <> 0
				nVistaD := nVistaD + PRD->VISTA
			EndIf
				
		EndIf
		
		DbSkip()
	EndDo
		
EndIf

If nPrazoD <> 0 .Or. nVistaD <> 0
	nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CTBA102","000001") //inclui o Último Lançamento de Débito
	RodaProva(nHdlPrv,nTotal) //Roda o Lançamento
	cA100Incl(cArquivo,nHdlPrv,3,"000001",lDigita,.F.) 	// Envia para Lancamento Contabil
	nTotal := 0
	nVistaD := 0
	nPrazoD := 0
	
EndIf

Return
