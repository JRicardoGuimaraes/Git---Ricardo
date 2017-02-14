#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGECTBA24 Autor ณ DO IT                 บ Data ณ  30/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio de fechamento Contแbil 			              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEFCO                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GECTBA26()

Local cDesc1       := "Este programa tem como objetivo imprir relat๓rios de  "
Local cDesc2       := " fechamento contแbil."
Local cDesc3       := ""
Local cPict        := ""
Local imprime      := .T.
Local aOrd         := {}
Private Cabec1       := "" 
Private Cabec2       := ""
Private nLin       := 80
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 225
Private tamanho    := "G"
Private nomeprog   := "GECTBA26" // Coloque aqui o nome do programa para impressao no cabecalho
//Private nTipo      := 18
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
//Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GECTBA26" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "CT2"
Private cPerg      := "GECT26"   //"CTR040"
Private aArea      := {}
              

titulo := "Relat๓rio de Fechamento Mensal"

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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  30/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo)

Local cCfop := ""
Local cTitComp := ""
Private nPos   := 0
Private cQuery := ""

//Variแveis utilizadas no lan็amento contแbil
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
Private aCampos   := {}
Private cCampo     := ""
Private cIndex, cChave,nIndex 

Private cUOS    := "01,02,11,21,22,23,31,32,33,34,35,36,37,38,51,61"  // Rela็ใo de UOs que tem cr้dito de PIS e COFINS. O seu valor ้ adicionado ao rateio.
Private aUO     := {{"01",0,0},{"02",0,0},{"11",0,0},{"21",0,0},{"22",0,0},{"23",0,0},{"31",0,0},{"32",0,0},{"33",0,0},{"34",0,0},{"35",0,0},{"36",0,0},{"37",0,0},{"38",0,0},{"51",0,0},{"61",0,0}}
Private aTotal     := {0,0,0,0,0,0,0,0,0,0,0,0} 
Private nVlrTot    := 0 
Private nVlrTot2   := 0 
Private nCRDVM    := 0  // Valor de Pis RDVM
Private nCRMLAP   := 0 // Valor de Pis RMLAP.
Private nCRMA     := 0 // Valor de Pis RMA.
Private nCILI     := 0 // Valor de Pis ILI.


Private cGrupo     := ""  //Variแvel para controlar o agrupamento da impressใo
Private nVlrPis    := 0
Private nVlrCofins := 0
Private aContas    := {}
Private nCol       := 0
Private cContas    := ""                 
Private nCont      := 0


//Cria็ใo de temporแrio (Dbf)
cQuery := "SELECT DISTINCT CTS_CT1INI " 
cQuery += " FROM " + RetSqlName("CTS") + "  "
cQuery += " WHERE CTS_CODPLA = '001' AND CTS_CONTAG = " + "'" + Mv_Par05 +"'" +  " "
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY CTS_CT1INI "

cQuery := ChangeQuery(cQuery)

TcQuery cQuery Alias "TCTS" NEW
DbSelectArea("TCTS")
DbGoTop()         

aCampos:={}
Aadd(aCampos,{"CT_CUSTO"  ,"C",10,0 })
Aadd(aCampos,{"CT_UO"     ,"C",03,0 })
While !Eof()        
	Aadd(aCampos,{"CT_" + TCTS->CTS_CT1INI ,"N",15,2 })	
	Aadd(aContas,{TCTS->CTS_CT1INI ,0})		
	DbSelectArea("TCTS")
	DbSkip()
End
	

cArqTemp := CriaTrab(aCampos)

dbUseArea(.T.,__LocalDriver,cArqTemp,"TST") 
cChave := "CT_UO+CT_CUSTO"
IndRegua("TST",cArqTemp,cChave)		
DbSelectArea("TST")

                        
DbSelectArea("TCTS")
DbCloseArea()

nlin := 80

dbSelectArea("SX5")
dbSetOrder(1)
If DbSeek(xFilial("SX5")+"TX"+MV_PAR05)
	cTitComp := SX5->X5_DESCRI
EndIF  
Titulo := " Relatorio de Fechamento Contแbil - " + AllTRIM(cTitComp) + " -  Periodo ( " + DTOC(MV_PAR01) + " - " + DTOC(MV_PAR02) + " )"
Cabec1 := "Cod C.C     UO   "
cContas := ""

For I:= 1 to len(aContas)
	Cabec1 := Cabec1 + Space(12 - len(AllTrim(aContas[I][1]))) + AllTrim(aContas[I][1])
	cContas := cContas + "'"+ AllTrim(aContas[I][1]) + "',"
Next I

If !Empty(cContas)
	cContas := SubStr(cContas,1,Len(cContas)-1)
EndIF

//Incluindo os campos relativos a centro de custo de 6 digitos
cQuery := "SELECT DISTINCT SUBSTRING(CT3_CUSTO,1,3) CT3_UO,CT3_CUSTO " 
cQuery += " FROM " + RetSqlName("CT3") + "  "
cQuery += " WHERE CT3_DATA >= " + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " CT3_DATA <= " + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " SUBSTRING(CT3_CUSTO,2,2) IN (" + cUOS + ") AND (LEN(CT3_CUSTO) = 6 OR LEN(CT3_CUSTO) = 10) AND "
//cQuery += " CT3_CONTA IN ('811101','811104','811105','811107','812101','812203','812204') AND D_E_L_E_T_ <> '*' "
cQuery += " CT3_CONTA IN ( " + cContas + " ) AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY SUBSTRING(CT3_CUSTO,1,3), CT3_CUSTO "

cQuery := ChangeQuery(cQuery)

TcQuery cQuery Alias "TCT3" NEW
DbSelectArea("TCT3")
DbGoTop()         

While !eof() 
	DbSelectArea("TST") 	
	RecLock("TST",.T.)
	TST->CT_CUSTO	:= TCT3->CT3_CUSTO	
	TST->CT_UO	    := TCT3->CT3_UO		                                                                    
	For I:= 1 to len(aContas)                                                                                                      
			cCampo := "CT_" + AllTrim(aContas[I][1])
			TST->&(cCampo) := MovCusto(AllTrim(aContas[I][1]), TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)
	Next I
	

	MsUnLock()  
	
	DbSelectArea("TCT3")
	DbSkip()
end

DbSelectArea("TCT3")
DbCloseArea()


//Imprimindo
DbSelectArea("TST") 
//DbSetOrder(1)
DbGoTop()
SetRegua(RecCount())
//         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

nCol := 19
While !Eof() 
    
	IncRegua()

    If nLin > 56 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    	nLin := 8
		nLin ++		
    Endif       

	nVlrTot    := 0
	nCol := 19
    @nLin,000 PSAY TST->CT_CUSTO
    @nLin,014 PSAY TST->CT_UO
    
	
	For I := 1 to len(aContas)
			nPos := aScan( aUo, { |x| SubStr(TST->CT_UO,2,2) == x[1] })
			If nPos > 0   
				aUo[nPos][2] := aUo[nPos][2] + TST->&("CT_" + AllTrim(aContas[I][1]))
			EndIf             
			
		    @nLin,nCol PSAY TST->&("CT_" + AllTrim(aContas[I][1]))  PICTURE "@E 999,999.99"
			nCol := nCol + 12
			nVlrTot := nVlrTot + TST->&("CT_" + AllTrim(aContas[I][1]))
			
			aContas[I][2] := aContas[I][2] + TST->&("CT_" + AllTrim(aContas[I][1]))
	Next I
    @nLin,nCol PSAY nVlrTot  PICTURE "@E 9,999,999.99" //  		 
	
	nLin ++

	DbSelectArea("TST")
  	DbSkip()
    IncRegua()
Enddo


                          
**************************************************************
** Buscando movimento de compara็ใo                         **
**************************************************************

//Incluindo os campos relativos a centro de custo de 6 digitos
cQuery := "SELECT DISTINCT SUBSTRING(CT3_CUSTO,1,3) CT3_UO,CT3_CUSTO " 
cQuery += " FROM " + RetSqlName("CT3") + "  "
cQuery += " WHERE CT3_DATA >= " + "'"+DTOS(Mv_Par03)+"'" +  " AND "
cQuery += " CT3_DATA <= " + "'"+DTOS(Mv_Par04)+"'" +  " AND "
cQuery += " SUBSTRING(CT3_CUSTO,2,2) IN (" + cUOS + ") AND (LEN(CT3_CUSTO) = 6 OR LEN(CT3_CUSTO) = 10) AND "
//cQuery += " CT3_CONTA IN ('811101','811104','811105','811107','812101','812203','812204') AND D_E_L_E_T_ <> '*' "
cQuery += " CT3_CONTA IN ( " + cContas + " ) AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY SUBSTRING(CT3_CUSTO,1,3), CT3_CUSTO "

cQuery := ChangeQuery(cQuery)

TcQuery cQuery Alias "TCT3" NEW
DbSelectArea("TCT3")
DbGoTop()         
SetRegua(RecCount())

While !eof() 

	For I := 1 to len(aContas)
			nPos := aScan( aUo, { |x| SubStr(TCT3->CT3_UO,2,2) == x[1] })
			If nPos > 0   
				aUo[nPos][3] := aUo[nPos][3] + MovCusto(AllTrim(aContas[I][1]), TCT3->CT3_CUSTO,MV_PAR03,MV_PAR04,"01","1",3)
			EndIf             
	Next I
	

	MsUnLock()  
	
	DbSelectArea("TCT3")
	DbSkip()
	IncRegua()
end

DbSelectArea("TCT3")
DbCloseArea()

//Impressใo de Totais"

@nLin,000 PSAY Replicate("-",ncol+12)
nLin ++

nCol := 17
@nLin,000 PSAY "Total"
nVlrTot := 0
For I := 1 to len(aContas)
		
	    @nLin,nCol PSAY aContas[I][2]  PICTURE "@E 9,999,999.99"
		nCol := nCol + 12
		nVlrTot := nVlrTot + aContas[I][2]
	
Next I
@nLin,nCol PSAY nVlrTot  PICTURE "@E 9,999,999.99"


nLin ++
nLin ++                            
@nLin,01 PSAY "UO          " + cMonth(MV_PAR01) + "/" + Alltrim(Str(Year(MV_PAR01))) + "     " + cMonth(MV_PAR03) + "/" + AllTRim(Str(Year(MV_PAR03)))
nLin ++                                                                                                                                               
@nLin,000 PSAY Replicate("-",35)
nLin ++
    
nVlrTot    := 0 	
nVlrTot2   := 0
For I := 1 to Len(aUo)

    If nLin > 56 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    	nLin := 8
		nLin ++		
    Endif       
	@nLin,01 PSAY aUo[I][1] 
	@nLin,10 PSAY aUo[I][2]  			PICTURE "@E 9,999,999.99"
	@nLin,23 PSAY aUo[I][3]  			PICTURE "@E 9,999,999.99"	
	
	nVlrTot    := nVlrTot  +  aUo[I][2]
	nVlrTot2   := nVlrTot2 +  aUo[I][3]	
	nLin ++			
	
Next I     

If nVlrTot <> 0 .Or. nVlrTot2 <> 0     
	@nLin,000 PSAY Replicate("-",35)
	nLin ++
	@nLin,000 PSAY "Total"
	@nLin,10 PSAY nVlrTot  			PICTURE "@E 9,999,999.99"
	@nLin,23 PSAY nVlrTot2 			PICTURE "@E 9,999,999.99"	
EndIF

  
SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()

DbSelectArea( "TST" )		//Selecionando a area
fErase( cArqTemp + OrdBagExt() )	//Deletando arquivo de trabalho*/


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

Aadd(aRegs,{cPerg,"01","Data de          :","","","mv_ch1","D",008,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data Ate         :","","","mv_ch2","D",008,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Data de Comp. de :","","","mv_ch3","D",008,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Data de Comp. Ate:","","","mv_ch4","D",008,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Grupo            :","","","mv_ch5","C",003,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//Aadd(aRegs,{cPerg,"03","Contabiliza?           :","","","mv_ch3","C",001,0,0,"C","","mv_par03","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","",""})
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
