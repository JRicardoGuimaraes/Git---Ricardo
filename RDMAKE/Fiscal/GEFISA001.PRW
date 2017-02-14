#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGEFISR001 Autor ณ MARCOS FURTADO       บ Data ณ  11/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Contabiliza็ใo de ICMS com a redu็ใo de 80%                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEFCO                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GEFISR001

Local cDesc1       := "Este programa tem como objetivo de contabilizar o  "
Local cDesc2       := "ICMS conforme lancamento padrao definido."
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
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "GEFISA001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GEFISA001" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "SZ2"
Private cPerg      := "GEFA19"   //"CTR040"

titulo := "Verifica Cobran็a "

ValidPerg()

If !Pergunte(cPerg,.T.)                           // Pergunta no SX1
   Return
EndIf

wnrel := SetPrint(cString,NomeProg,"",titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  14/04/05   บฑฑ
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
Private nPos   := 0
Private cQuery := ""

//Variแveis utilizadas no lan็amento contแbil
Private nValCred := 0
Private nValDeb  := 0
Private cArquivo  := ""
Private nTotal    := 0
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

nlin := 80

_cFilial := ""

nTotalG   := 0
_cFilAnt  := ""   
   
Titulo := "Rela็ใo de Cotabiliza็ใo de ICMS : Perํodo ( " + DTOC(MV_PAR01) + " - " + DTOC(MV_PAR02) + " )"
If MV_PAR06 = 2
	Cabec1 := " Filial  EMISSAO  NFISCAL ESPECIE           VALOR  ALIQICM       VALICM    VALICM * " + AllTrim(STR(nPerc)) + "%" + " INSCR               CCUSTO       CFOP" 
Else
	Cabec1 := " Filial  VALOR CONT      VALICM      VALICM * " + AllTrim(STR(nPerc)) + "%" 
EndIf

cCfop := "('6921', '5921', '5552','6552', '5553', '6553', '6949','5949','5556','6556','5901','6901'," 
cCfop += "'5902', '6902', '5915','6915', '6903', '5903', '5916','6916','5908','6908','5909','6909'," 
cCfop += "'5913', '6913', '5210','6210', '5910', '6910','5556','6556','6552','5552','5553','6553'," 
cCfop += "'5557', '6557','5357', '6357','5551', '6551')" 


If MV_PAR06 = 2 
	cQuery = "SELECT DISTINCT F3_FILIAL ,F3_EMISSAO, F3_NFISCAL, F3_ESPECIE,F3_CLIEFOR, F3_LOJA, F3_VALCONT,F3_ALIQICM, F3_VALICM, A1_INSCR, E1_CCONT, F3_CFO"
Else
	//cQuery = "SELECT DISTINCT F3_FILIAL ,A1_COD, A1_LOJA, A1_NOME, A1_INSCR, A1_CGC"
	cQuery = "SELECT F3_FILIAL ,E1_CCONT, SUM(F3_VALCONT) F3_VALCONT, SUM(F3_VALICM) F3_VALICM "
EndIF
cQuery += " FROM " + RETSQLNAME("SF3") + " AS SF3,"+RETSQLNAME("SA1")+" AS SA1, " +RETSQLNAME("SE1")+" AS SE1 " "
cQuery += " WHERE SA1.D_E_L_E_T_ <> '*' AND SE1.D_E_L_E_T_ <> '*' AND SF3.D_E_L_E_T_ <> '*' AND "
cQuery += " E1_FILIAL >=" + "'"+ Mv_Par03 +"'" +  " AND "
cQuery += " E1_FILIAL <=" + "'"+ Mv_Par04 +"'" +  " AND "
cQuery += " F3_FILIAL >=" + "'"+ Mv_Par03 +"'" +  " AND "
cQuery += " F3_FILIAL <=" + "'"+ Mv_Par04 +"'" +  " AND "
cQuery += " F3_EMISSAO >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " F3_EMISSAO <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " E1_EMISSAO >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " E1_EMISSAO <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "
//cQuery += " F3_CFO NOT IN " + cCfop + " AND "
If MV_PAR08 == 1
	cQuery += " F3_CFO >= '5' AND F3_CFO < '6' AND "
	cQuery += " A1_INSCR <> '' AND A1_INSCR <> 'ISENTO' AND "	
	cQuery += " F3_CFO  NOT IN " + cCfop + " AND "
	cQuery += " F3_ESTADO = '" + GetMv("MV_ESTADO")+  "' AND "	
Else
	cQuery += " F3_CFO >= '5' AND F3_CFO <= '7999' AND "
	cQuery += " F3_CFO  IN (" + Alltrim(MV_PAR09) + Alltrim(MV_PAR10) + ") AND "
EndIf
cQuery += " F3_TIPO = '' AND F3_ALIQICM <> 0  AND "
cQuery += " F3_NFISCAL = E1_NUM AND "
cQuery += " F3_DTCANC = ' ' AND "
cQuery += " F3_FILIAL = E1_FILIAL AND "
//cQuery += " F3_ESPECIE = E1_PREFIXO AND "
//cQuery += " E1_VALOR = F3_VALCONT AND "  
cQuery += " A1_COD = F3_CLIEFOR AND A1_LOJA = F3_LOJA "
//cQuery += " (A1_INSCR = '' OR A1_INSCR = 'ISENTO') AND"
If MV_PAR06 = 2 
	cQuery += " ORDER BY F3_FILIAL, F3_EMISSAO, F3_NFISCAL"
//	cQuery += " ORDER BY A1_COD, A1_LOJA "
Else
	cQuery += " GROUP BY F3_FILIAL ,E1_CCONT "
	cQuery += " ORDER BY F3_FILIAL ,E1_CCONT "	
EndIf

//TcQuery cQuery  ALIAS "GFR" NEW
//cQuery := ChangeQuery(cQuery)
//dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)

TcQuery cQuery Alias "TSF3" NEW
DbSelectArea("TSF3")
DbGoTop()         
SetRegua(RecCount())

_cFilial := TSF3->F3_FILIAL
                          
nValorCTB := 0    
While !Eof() 
    
	IncRegua()

    If nLin > 70 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    	nLin := 8
		nLin ++		
    Endif       
    
	If MV_PAR06 = 2
	   	If _cFilial <> TSF3->F3_FILIAL
			nLin ++		       
	       @nLin,030 PSAY " Total da Filial ( " + _cFilial + " )  : " 

           @nLin,036 PSAY nValorFil PICTURE "@E 999,999,999.99"   	
		   @nLin,057 PSAY nBaseIcm  PICTURE "@E 999,999,999.99"   		
		   @nLin,072 PSAY nValIcm PICTURE "@E 999,999,999.99"   				
	       
	       nTotalG := nTotalG + nValorFil
	       nValorFil := 0
	       nBaseIcm  := 0
           nValIcm   := 0
	       
	       _cFilAnt := _cFilial
	       _cFilial := TSF3->F3_FILIAL   
			nLin ++		                    
	    Endif
		@nLin,003 PSAY DTOC(STOD(TSF3->F3_EMISSAO))	
		@nLin,013 PSAY TSF3->F3_NFISCAL  
		@nLin,021 PSAY TSF3->F3_ESPECIE
		@nLin,025 PSAY TSF3->F3_CLIEFOR
		@nLin,033 PSAY TSF3->F3_LOJA   
		@nLin,036 PSAY TSF3->F3_VALCONT PICTURE "@E 999,999,999.99"   	
		@nLin,049 PSAY TSF3->F3_ALIQICM PICTURE "@E 999.99"   		    
		@nLin,057 PSAY TSF3->F3_VALICM  PICTURE "@E 999,999,999.99"   		
		@nLin,072 PSAY TSF3->F3_VALICM * (nPerc/100) PICTURE "@E 999,999,999.99"   				
		@nLin,087 PSAY TSF3->A1_INSCR   
		@nLin,107 PSAY TSF3->E1_CCONT   	
		@nLin,120 PSAY TSF3->F3_CFO  		
	
	/*	@nLin,003 PSAY TSF3->A1_COD
		@nLin,010 PSAY TSF3->A1_LOJA
		@nLin,013 PSAY TSF3->A1_NOME
		@nLin,050 PSAY TSF3->A1_INSCR
		@nLin,065 PSAY TSF3->A1_CGC	*/
	
	ELSE
		@nLin,000 PSAY TSF3->F3_FILIAL
		@nLin,003 PSAY TSF3->E1_CCONT   	
		@nLin,015 PSAY TSF3->F3_VALCONT PICTURE "@E 999,999,999.99"   	
		@nLin,030 PSAY TSF3->F3_VALICM  PICTURE "@E 999,999,999.99"   		
		@nLin,045 PSAY TSF3->F3_VALICM * (nPerc/100) PICTURE "@E 999,999,999.99"   			
		
	EndIF
	   
    nLin ++		       
    nValorFil := nValorFil + F3_VALCONT        
	nBaseIcm  := nBaseIcm  + TSF3->F3_VALICM
	nValIcm   := nValIcm   + TSF3->F3_VALICM * (nPerc/100)
    
    
	DbSelectArea("TSF3")
  	DbSkip()
    IncRegua()
Enddo

 If nLin > 70 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
  	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   	nLin := 6
	nLin ++		
 Endif      
 
 nLin ++		       
                   
If MV_PAR06 = 2
    nTotalG := nTotalG + nValorFil
	If MV_PAR03 <> MV_PAR04
		nLin ++		       
	    @nLin,010 PSAY " Total da Filial ( " + _cFilial + " )  : " 
        @nLin,036 PSAY nValorFil PICTURE "@E 999,999,999.99"   	
	    @nLin,057 PSAY nBaseIcm  PICTURE "@E 999,999,999.99"   		
	    @nLin,072 PSAY nValIcm PICTURE "@E 999,999,999.99"   				

	   // nValorFil := 0
	   // _cFilAnt := _cFilial
	   // _cFilial := TSF3->E1_FILIAL   
		nLin ++		           
		nLin ++		           
	 
	Endif
	
	@nLin,054 PSAY " Total Geral  :  "
	@nLin,080 PSAY nTotalG  PICTURE "@E 999,999,999,999.99"       
Else
    @nLin,015 PSAY nValorFil PICTURE "@E 999,999,999.99"   	
    @nLin,030 PSAY nBaseIcm  PICTURE "@E 999,999,999.99"   		
    @nLin,045 PSAY nValIcm PICTURE "@E 999,999,999.99"   				

EndIF

If MV_PAR05 = 1 
	//Rotina de Contabiliza็ใo
	CTB()
EndIF


DbSelectArea("TSF3")
DbCloseArea()        



SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()


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
Aadd(aRegs,{cPerg,"03","Filial de              :","","","mv_ch3","C",002,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Filial ate             :","","","mv_ch4","C",002,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Contabiliza?           :","","","mv_ch5","C",001,0,0,"C","","mv_par05","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Imprimir Aglt por C.C.?:","","","mv_ch6","C",001,0,0,"C","","mv_par06","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","% ?                    :","","","mv_ch7","N",003,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})                  
Aadd(aRegs,{cPerg,"08","Tipo Contabilizacao    :","","","mv_ch8","N",001,0,0,"C","","mv_par08","Cred. Decreto","Cred. Decreto","Cred. Decreto","","","Cred. Presumido","Cred. Presumido","Cred. Presumido","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"09","CFOP Cred. Presumido   :","","","mv_ch9","C",080,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"10","CFOP Cred. Presumido   :","","","mv_cha","C",080,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณCTBCRED      บ Autor ณ Marcos Furtado  บ Data ณ  10/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Esta fun็ใo contalibiliza os valores de cr้dito            บฑฑ
ฑฑบ          ณ da tabela temporแria totalizada por centro de custo        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATURAMENTO                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

/*/
                         
                                             
Static Function CTB()
                           
//Variแveis Utilizadas na Rotina de Lan็camentos Contแbeis

cPadrao  := "060" // CODIGO DO LANCAMENTO PADRAO PARA CONTABILIZACAO


nHdlPrv := HeadProva("000001","CTBA102",Substr(cUsuario,7,6),@cArquivo) //Abre o lan็amento contแbil


DbSelectArea("TSF3")
DbGotop()    
nValorCTB := 0
While !Eof()
	
	cCusto    := TSF3->E1_CCONT
	nValCred  := TSF3->F3_VALICM * (nPerc/100)
	nValorCTB := nValorCTB + nValCred
	nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CTBA102","000001") //Inclui uma linha no lan็amento contแbil
    
	nValCred := 0

	DbSkip()
EndDo
	
If nValorCTB <> 0 
    nValCred := 0 
    nValDeb  := nValorCTB  
	nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CTBA102","000001") //inclui o ฺltimo Lan็amento de D้bito
	RodaProva(nHdlPrv,nTotal) //Roda o Lan็amento
	cA100Incl(cArquivo,nHdlPrv,3,"000001",lDigita,.F.) 	// Envia para Lancamento Contabil

    nValDeb  := 0
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณCTBDEB      บ Autor ณ Marcos Furtado  บ Data ณ  10/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Esta fun็ใo contalibiliza os valores de D้bitos            บฑฑ
ฑฑบ          ณ da tabela temporแria totalizada por centro de custo        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATURAMENTO                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

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
			nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CTBA102","000001") // Inlui o lan็amento de d้bito
			
			nVistaD := 0
			nPrazoD := 0
			//Coloca o valor nas variแveis de Compara็ใo
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
	nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CTBA102","000001") //inclui o ฺltimo Lan็amento de D้bito
	RodaProva(nHdlPrv,nTotal) //Roda o Lan็amento
	cA100Incl(cArquivo,nHdlPrv,3,"000001",lDigita,.F.) 	// Envia para Lancamento Contabil
	nTotal := 0
	nVistaD := 0
	nPrazoD := 0
	
EndIf

Return

/*
//SELECT DISTINCT F3_FILIAL ,F3_EMISSAO, F3_NFISCAL, F3_ESPECIE,F3_CLIEFOR, F3_LOJA, F3_VALCONT,F3_ALIQICM, F3_VALICM, A1_INSCR, E1_CCONT, F3_CFO
SELECT F3_FILIAL ,E1_CCONT, SUM(F3_VALCONT) F3_VALCONT, SUM(F3_VALICM) F3_VALICM 
FROM SF3010 AS SF3,SA1010 AS SA1, SE1010 AS SE1 
 WHERE SA1.D_E_L_E_T_ <> '*' AND SE1.D_E_L_E_T_ <> '*' AND SF3.D_E_L_E_T_ <> '*' AND 
 E1_FILIAL >= '02' AND 
 E1_FILIAL <= '02' AND 
 F3_FILIAL >= '02' AND 
 F3_FILIAL <= '02' AND 
F3_ESTADO = 'RJ' AND 
F3_EMISSAO >= '20060601' AND 
F3_EMISSAO <= '20060630' AND 
" E1_EMISSAO >= '20060601' AND 
E1_EMISSAO <= '20060630' AND 
F3_CFO >= '5' AND F3_CFO < '6' AND 
F3_CFO NOT IN 
('6921', '5921', '5552','6552', '5553', '6553', '6949','5949','5556','6556','5901','6901', 
'5902', '6902', '5915','6915', '6903', '5903', '5916','6916','5908','6908','5909','6909', 
'5913', '6913', '5210','6210', '5910', '6910','5556','6556','6552','5552','5553','6553', 
'5557', '6557') AND 
F3_TIPO = ' ' AND F3_ALIQICM <> 0  AND 
F3_NFISCAL = E1_NUM AND 
E1_VALOR = F3_VALCONT AND 
A1_INSCR <> '' AND A1_INSCR <> 'ISENTO' AND 
A1_COD = F3_CLIEFOR AND A1_LOJA = F3_LOJA 
//ORDER BY F3_FILIAL ,F3_EMISSAO, F3_NFISCAL
GROUP BY F3_FILIAL ,E1_CCONT 

*/