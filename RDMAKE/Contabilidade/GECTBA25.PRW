#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GECTBA24 Autor ³ DO IT                 º Data ³  30/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Apuração - Débitos de Pis e Confins 					              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEFCO                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GECTBA25()

Local cDesc1       := "Este programa tem como objetivo imprir a apuração de  "
Local cDesc2       := " débitos PIS e COFINS."
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
Private nomeprog   := "GECTBA25" // Coloque aqui o nome do programa para impressao no cabecalho
//Private nTipo      := 18
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
//Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GECTBA25" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "CT2"
Private cPerg      := "GECT25"   //"CTR040"
Private aArea      := {}
              

titulo := "Apuração Débitos de PIS e COFINS"

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
Private cUOSDeb    := "01,02,11,21,22,23" // GetMvPar("MV_XUOSPF") // Relação de UOs que tem crédito de PIS e COFINS. O seu valor é adicionado ao rateio.
Private nPcRDVM    := 0.36  // GetMvPar("MV_XPCRDVM") // Porcentagem de rateio do RDVM.
Private nPcRMLAP   := 0.382 // GetMvPar("MV_XPCRMLAP") // Porcentagem de rateio do RMLAP.
Private nPcRMA     := 0.203 // GetMvPar("MV_XPCRMA") // Porcentagem de rateio do RMA.
Private nPcILI     := 0.055 // GetMvPar("MV_XPCILI") // Porcentagem de rateio do ILI.
Private cCtPIS     := GetMv("MV_XCTPIS") //Parâmetro de conta contábil - PIS
Private cCtCOFINS  := GetMv("MV_XCTCOF") //Parâmetro de conta contábil - COFINS
Private nAliqPIS   := (GetMv("MV_XALQPIS") /100) //Parâmetro de conta contábil - PIS
Private nAliqCofins:= (GetMv("MV_XALQCOF") /100) //Parâmetro de conta contábil - COFINS
Private aTotal     := {0,0,0,0,0,0,0,0,0,0,0,0} 
Private nVlrTot    := 0 
Private nCRDVM    := 0  // Valor de Pis RDVM
Private nCRMLAP   := 0 // Valor de Pis RMLAP.
Private nCRMA     := 0 // Valor de Pis RMA.
Private nCILI     := 0 // Valor de Pis ILI.

Private nPRDVM    := 0  // Valor de COFINS RDVM
Private nPRMLAP   := 0 // Valor de COFINS RMLAP.
Private nPRMA     := 0 // Valor de COFINS RMA.
Private nPILI     := 0 // Valor de COFINS ILI.

Private n811101    := 0  // Valor da conta 811101
Private n811104    := 0 // VValor da conta 811104
Private n811105    := 0 // Valor da conta 811105
Private n811107    := 0 // Valor da conta 811107
Private n812101    := 0 // VValor da conta 812101
Private n812203    := 0 // Valor da conta 812203
Private n812204    := 0 // Valor da conta 812204

Private cGrupo     := ""  //Variável para controlar o agrupamento da impressão
Private nVlrPis    := 0
Private nVlrCofins := 0

aCampos:={}
Aadd(aCampos,{"CT_CUSTO"  ,"C",10,0 })
Aadd(aCampos,{"CT_UO"     ,"C",03,0 })
Aadd(aCampos,{"CT_811101" ,"N",15,2 })
Aadd(aCampos,{"CT_811104" ,"N",15,2 })
Aadd(aCampos,{"CT_811105" ,"N",15,2 })
Aadd(aCampos,{"CT_811107" ,"N",15,2 })
Aadd(aCampos,{"CT_812101" ,"N",15,2 })
Aadd(aCampos,{"CT_812203" ,"N",15,2 })
Aadd(aCampos,{"CT_812204" ,"N",15,2 })

/*PRD	:=	CriaTrab(aCampos)

dbUseArea(.T.,__LocalDriver,cNome,"TST",.T.,.F.)
IndRegua("TST",cNome,"INDICE+CT_CUSTO",,,"Selecionando Registros")
DbSelectArea("TST")
DbClearIndex()
DbSetIndex(cNome+OrdBagExt())*/
                                

cArqTemp := CriaTrab(aCampos)

dbUseArea(.T.,__LocalDriver,cArqTemp,"TST") 
cChave := "CT_UO+CT_CUSTO"
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

  
Titulo := "APURACAO DO DEBITO DO PIS/COFINS POR UO -  Periodo ( " + DTOC(MV_PAR01) + " - " + DTOC(MV_PAR02) + " )"
Cabec1 := "Cod C.C     UO   811101          811104          811105          811107          812101          812203          812204          Total           7,6%            1,65%           Dif PIS         Dif Cofins "






//Incluindo os campos relativos a centro de custo de 6 digitos
cQuery := "SELECT DISTINCT SUBSTRING(CT3_CUSTO,1,3) CT3_UO,CT3_CUSTO " 
cQuery += " FROM " + RetSqlName("CT3") + "  "
cQuery += " WHERE CT3_DATA >= " + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " CT3_DATA <= " + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " SUBSTRING(CT3_CUSTO,2,2) IN (" + cUOSDeb + ") AND (LEN(CT3_CUSTO) = 6 OR LEN(CT3_CUSTO) = 10) AND "
cQuery += " CT3_CONTA IN ('811101','811104','811105','811107','812101','812203','812204') AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY SUBSTRING(CT3_CUSTO,1,3), CT3_CUSTO "

cQuery := ChangeQuery(cQuery)

TcQuery cQuery Alias "TCT3" NEW
DbSelectArea("TCT3")
DbGoTop()         

While !eof() 


	n811101    := MovCusto("811101", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3)  // Valor da conta 811101
	n811104    := MovCusto("811104", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3) // VValor da conta 811104
	n811105    := MovCusto("811105", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3) // Valor da conta 811105
	n811107    := MovCusto("811107", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3) // Valor da conta 811107
	n812101    := MovCusto("812101", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3) // Valor da conta 812101
	n812203    := MovCusto("812203", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3) // Valor da conta 812203
	n812204    := MovCusto("812204", TCT3->CT3_CUSTO,MV_PAR01,MV_PAR02,"01","1",3) // Valor da conta 812204

	DbSelectArea("TST") 	
	RecLock("TST",.T.)
	TST->CT_CUSTO	:= TCT3->CT3_CUSTO	
	TST->CT_UO	    := TCT3->CT3_UO		
	TST->CT_811101	:= n811101 //
	TST->CT_811104	:= n811104 //
	TST->CT_811105	:= n811105 //
	TST->CT_811107	:= n811107 //
	TST->CT_812101	:= n812101 //
	TST->CT_812203	:= n812203 //
	TST->CT_812204	:= n812204 //
	
/*	nPos := ascan(A_PED,{|x| x[1] == AllTrim(cPesquisa)})		

	If nPos = 0
		AADD(A_PED, {oNo,TRB->C6_NUM,TRB->C6_CLI,TRB->C6_LOJA,SA1->A1_NOME,PadL(TransForm(TRB->ESPACO,"@E 9999.999"),25)})	
	Else
	EndIf*/

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

//"Cod C.C     UO   811101          811104          811105          811107          812101          812203          812204          Total           7,6%            1,65%           Dif PIS         Dif Cofins "
//XXXXXXXXXX   XXX  XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX
//UO  COFINS         PIS            TOTAL                          
While !Eof() 
    
	IncRegua()

    If nLin > 56 // Salto de Página. Neste caso o formulario tem 55 linhas...
    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    	nLin := 8
		nLin ++		
    Endif       

	nVlrTot    := (TST->CT_811101 + TST->CT_811104 + TST->CT_811105 + TST->CT_811107 + TST->CT_812101  )

    @nLin,000 PSAY TST->CT_CUSTO
    @nLin,014 PSAY TST->CT_UO
    @nLin,019 PSAY TST->CT_811101  PICTURE "@E 999,999,999.99"   	
    @nLin,035 PSAY TST->CT_811104  PICTURE "@E 999,999,999.99"   	
    @nLin,051 PSAY TST->CT_811105 PICTURE "@E 999,999,999.99"   	
    @nLin,067 PSAY TST->CT_811107 PICTURE "@E 999,999,999.99"   	
    @nLin,083 PSAY TST->CT_812101 PICTURE "@E 999,999,999.99"   	
    @nLin,099 PSAY TST->CT_812203 PICTURE "@E 999,999,999.99"   	
    @nLin,115 PSAY TST->CT_812204 PICTURE "@E 999,999,999.99"   	
    @nLin,131 PSAY nVlrTot PICTURE "@E 999,999,999.99"   	
    @nLin,147 PSAY nVlrTot * nAliqCofins PICTURE "@E 9,999,999,999.99"   	
    @nLin,163 PSAY nVlrTot * nAliqPis PICTURE "@E 9,999,999,999.99"   	
    @nLin,179 PSAY (nVlrTot * nAliqPis) + TST->CT_812203 PICTURE "@E 9,999,999,999.99"   	
    @nLin,195 PSAY (nVlrTot * nAliqCofins) + TST->CT_812204 PICTURE "@E 9,999,999,999.99"   	

    
	nLin ++
                   


	aTotal[1]  += TST->CT_811101  
	aTotal[2]  += TST->CT_811104  
	aTotal[3]  += TST->CT_811105 
	aTotal[4]  += TST->CT_811107 
	aTotal[5]  += TST->CT_812101
	aTotal[6]  += TST->CT_812203
	aTotal[7]  += TST->CT_812204
	aTotal[8]  += nVlrTot
	aTotal[9]  += nVlrTot * nAliqCofins
	aTotal[10] += nVlrTot * nAliqPis
    aTotal[11] += (nVlrTot * nAliqPis) + TST->CT_812203 
    aTotal[12] += (nVlrTot * nAliqCofins) + TST->CT_812204 
	

	DbSelectArea("TST")
  	DbSkip()
    IncRegua()
Enddo
                                     

If 	aTotal[1]  <> 0 .or. ;
	aTotal[2]  <> 0 .or. ;
	aTotal[3]  <> 0 .or. ;
	aTotal[4]  <> 0 .or. ;
	aTotal[5]  <> 0 .or. ;
	aTotal[6]  <> 0 .or. ;
	aTotal[7]  <> 0 .or. ;
	aTotal[8]  <> 0 .or. ;
	aTotal[9]  <> 0 .or. ;
	aTotal[10]  <> 0 .or. ;
	aTotal[11]  <> 0 .or. ;		
	aTotal[12] <> 0 
	
	nLin ++             
    @nLin,000 PSAY Replicate("-",132)
	nLin ++                 
    @nLin,000 PSAY "Total"
    @nLin,019 PSAY aTotal[1]  PICTURE "@E 999,999,999.99"   	
    @nLin,035 PSAY aTotal[2]  PICTURE "@E 999,999,999.99"   	
    @nLin,051 PSAY aTotal[3]  PICTURE "@E 999,999,999.99"   	
    @nLin,067 PSAY aTotal[4]  PICTURE "@E 999,999,999.99"   	
    @nLin,083 PSAY aTotal[5]  PICTURE "@E 999,999,999.99"   	
    @nLin,099 PSAY aTotal[6]  PICTURE "@E 999,999,999.99"   	
    @nLin,115 PSAY aTotal[7]  PICTURE "@E 999,999,999.99"   	
    @nLin,131 PSAY aTotal[8]  PICTURE "@E 999,999,999.99"   	
    @nLin,147 PSAY aTotal[9]  PICTURE "@E 9,999,999,999.99"   	
    @nLin,163 PSAY aTotal[10] PICTURE "@E 9,999,999,999.99"   	
    @nLin,179 PSAY aTotal[11]  PICTURE "@E 9,999,999,999.99"   	
    @nLin,195 PSAY aTotal[12] PICTURE "@E 9,999,999,999.99"   	
    
	nLin ++
	
EndIF


Cabec1 := "UO  COFINS         PIS            TOTAL"

nLin := 120

 If nLin > 56 // Salto de Página. Neste caso o formulario tem 55 linhas...
  	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   	nLin := 6
	nLin ++		
 Endif      
 
 nLin ++		       

DbSelectArea("TST") 
//DbSetOrder(1)
DbGoTop()
SetRegua(RecCount())

@nLin,015 PSAY nAliqPIS*100
@nLin,025 PSAY nAliqCofins*100
     
nLin ++
nLin ++
                             
aTotal[1] := 0
aTotal[2] := 0 
aTotal[3] := 0 

cGrupo     := TST->CT_UO
nVlrCofins := 0
nVlrPis    := 0

While !Eof()
	If nLin > 56 // Salto de Página. Neste caso o formulario tem 55 linhas...
	  	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   	nLin := 6
		nLin ++		
	Endif      
	If TST->CT_UO <> cGrupo
		@nLin,001 PSAY cGrupo
		@nLin,005 PSAY nVlrCofins PICTURE "@E 999,999,999.99"		
		aTotal[1]	+= nVlrCofins
		@nLin,020 PSAY nVlrPis    PICTURE "@E 999,999,999.99"
		aTotal[2]	+= nVlrPis   		                     
		@nLin,035 PSAY nVlrCofins + nVlrPis   PICTURE "@E 999,999,999.99"		
		aTotal[3]	+= nVlrCofins + nVlrPis 
		nlin ++
				
		nVlrCofins := 0
		nVlrPis    := 0
	EndIF
	nVlrTot    := (TST->CT_811101 + TST->CT_811104 + TST->CT_811105 + TST->CT_811107 + TST->CT_812101 )
	
	cGrupo     := TST->CT_UO	 
	nVlrCofins += nVlrTot * nAliqCofins 
	nVlrPis    += nVlrTot * nAliqPIS 
	DbSelectArea("TST")
	DbSkip()
End


If aTotal[1] <> 0 .Or. aTotal[2] <> 0                       
	@nLin,001 PSAY cGrupo
	@nLin,005 PSAY nVlrCofins PICTURE "@E 999,999,999.99"		
	aTotal[1]	+= nVlrCofins
	@nLin,020 PSAY nVlrPis    PICTURE "@E 999,999,999.99"
	aTotal[2]	+= nVlrPis   		                     
	@nLin,035 PSAY nVlrCofins + nVlrPis    PICTURE "@E 999,999,999.99"		
	aTotal[3]	+= nVlrCofins + nVlrPis 
	nlin ++

	@nLin,000 PSAY Replicate("-",70)
	nLin++
	@nLin,000 PSAY "Tot"
	@nLin,005 PSAY aTotal[1] PICTURE "@E 999,999,999.99"   	
	@nLin,020 PSAY aTotal[2] PICTURE "@E 999,999,999.99"   	
	@nLin,035 PSAY aTotal[3] PICTURE "@E 999,999,999.99"   		
EndIF

aTotal[1] := 0
aTotal[2] := 0 
aTotal[3] := 0 

cGrupo     := ""
nVlrCofins := 0
nVlrPis    := 0


SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()

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

cPadrao  := "060" // CODIGO DO LANCAMENTO PADRAO PARA CONTABILIZACAO


nHdlPrv := HeadProva("000001","CTBA102",Substr(cUsuario,7,6),@cArquivo) //Abre o lançamento contábil


DbSelectArea("TSF3")
DbGotop()    
nValorCTB := 0
While !Eof()
	
	cCusto    := TSF3->E1_CCONT
	nValCred  := TSF3->F3_VALICM * (nPerc/100)
	nValorCTB := nValorCTB + nValCred
	nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CTBA102","000001") //Inclui uma linha no lançamento contábil
    
	nValCred := 0

	DbSkip()
EndDo
	
If nValorCTB <> 0 
    nValCred := 0 
    nValDeb  := nValorCTB  
	nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"CTBA102","000001") //inclui o Último Lançamento de Débito
	RodaProva(nHdlPrv,nTotal) //Roda o Lançamento
	cA100Incl(cArquivo,nHdlPrv,3,"000001",lDigita,.F.) 	// Envia para Lancamento Contabil

    nValDeb  := 0
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
