#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/09/00

User Function Lvriss()        // incluido pelo assistente de conversao do AP5 IDE em 13/09/00


SetPrvt("CMUNICIPIO,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ARETURN,LIMITE,ALINHA,NOMEPROG,NLASTKEY,CPERG")
SetPrvt("ADRIVER,NPAGINA,ASF3,CSTRING,CABEC1,CABEC2")
SetPrvt("WNREL,LIMPLIVRO,LIMPTERMOS,_F3_FILIAL,_F3_REPROC,_F3_ENTRADA")
SetPrvt("_F3_NFISCAL,_F3_SERIE,_F3_CLIEFOR,_F3_LOJA,_F3_CFO,_F3_CODISS")
SetPrvt("_F3_ESTADO,_F3_EMISSAO,_F3_CONTA,_F3_ALIQICM,_F3_VALCONT,_F3_BASEICM")
SetPrvt("_F3_VALICM,_F3_ISENICM,_F3_OUTRICM,_F3_BASEIPI,_F3_VALIPI,_F3_ISENIPI")
SetPrvt("_F3_OUTRIPI,_F3_OBSERV,_F3_VALOBSE,_F3_ICMSRET,_F3_TIPO,_F3_LANCAM")
SetPrvt("_F3_DOCOR,_F3_ICMSCOM,_F3_IPIOBS,_F3_NRLIVRO,_F3_CAMPOS,LHOUVEMOV")
SetPrvt("_F3_DTCANC")
SetPrvt("LIN,NPOSALIQ,CCODISS,LFIMREL,ATRANSPORTE,AALIQ")
SetPrvt("ATOTMENSAL,ALINDET,LIMPTOTAL,LIMPRESUMO,LFIRST,LTOTALIZA")
SetPrvt("NINDEX,CARQIND,CCHAVE,CFILTRO,LLOOP,CCODIGO")
SetPrvt("CLINDET,CMESINCID,CANO,CDRIVER,CPAGINA,LIMPCABEC")
SetPrvt("NQTDLINHAS,CLINHATOT,I,")


cMUNICIPIO:="Rio de Janeiro"
tamanho:="G"
titulo    := PADC("Apuracao de I.S.S.",74)
cDesc1    := PADC("Este programa ira emitir a Apuracao de I.S.S.",74)
cDesc2    := PADC("Exclusivo GEFCO",74)
cDesc3    := "  "
aReturn := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
Limite  := 220
aLinha:= {}
nomeprog:="MATRISS"
nLastKey := 0
cPerg   :="MTRISS"
aDriver :=ReadDriver()
nPagina:=1
aSF3:={}

cString  :="SF3"
cabec1   := ""
cabec2   := ""
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // da Data                              ³
//³ mv_par02             // ate a Data                           ³
//³ mv_par03             // Pagina Inicial                       ³
//³ mv_par04             // Nr do Livro                          ³
//³ mv_par05             // Livro ou Livro+termos ou Termos      ³
//³ mv_par06             // Imprime Nome do Cliente ou Municipio ³
//³ mv_par07             // Livro Selecionado                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:="MATRISS"   
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"")
nPagina:=mv_par03
nPagina:=IIF(nPagina<2,2,nPagina)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Return
Endif

RptStatus({|| RptDetail()})

Static Function RptDetail()

SetRegua(RecCount())

	dbSelectArea("SF3")	
	_F3_FILIAL :=FieldPos("F3_FILIAL")
	_F3_REPROC :=FieldPos("F3_REPROC")
	_F3_ENTRADA:=FieldPos("F3_ENTRADA")
	_F3_NFISCAL:=FieldPos("F3_NFISCAL")
	_F3_SERIE  :=FieldPos("F3_SERIE")
	_F3_CLIEFOR:=FieldPos("F3_CLIEFOR")
	_F3_LOJA   :=FieldPos("F3_LOJA")
	_F3_CFO    :=FieldPos("F3_CFO")
	_F3_CODISS :=FieldPos("F3_CODISS")
	_F3_ESTADO :=FieldPos("F3_ESTADO")
	_F3_EMISSAO:=FieldPos("F3_EMISSAO")
	_F3_CONTA  :=FieldPos("F3_CONTA")
	_F3_ALIQICM:=FieldPos("F3_ALIQICM")
	_F3_VALCONT:=FieldPos("F3_VALCONT")
	_F3_BASEICM:=FieldPos("F3_BASEICM")
	_F3_VALICM :=FieldPos("F3_VALICM")
	_F3_ISENICM:=FieldPos("F3_ISENICM")
	_F3_OUTRICM:=FieldPos("F3_OUTRICM")
	_F3_BASEIPI:=FieldPos("F3_BASEIPI")
	_F3_VALIPI :=FieldPos("F3_VALIPI")
	_F3_ISENIPI:=FieldPos("F3_ISENIPI")
	_F3_OUTRIPI:=FieldPos("F3_OUTRIPI")
	_F3_OBSERV :=FieldPos("F3_OBSERV")
	_F3_VALOBSE:=FieldPos("F3_VALOBSE")
	_F3_ICMSRET:=FieldPos("F3_ICMSRET")
	_F3_TIPO   :=FieldPos("F3_TIPO")
	_F3_LANCAM :=FieldPos("F3_LANCAM")
	_F3_DOCOR  :=FieldPos("F3_DOCOR")
	_F3_ICMSCOM:=FieldPos("F3_ICMSCOM")
	_F3_IPIOBS :=FieldPos("F3_IPIOBS")
	_F3_NRLIVRO:=FieldPos("F3_NRLIVRO")
	_F3_DTCANC :=FieldPos("F3_DTCANC")
    _F3_ESPECIE:=FieldPos("F3_ESPECIE")
	_F3_CAMPOS :=FCount()  // Numero de Campos do SF3

	Livro()
	
dbSelectArea("SF3")
dbSetOrder(1)
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

Return

Static Function Livro()

lHouveMov := .f.
Lin:= 80
nPosAliq:=0
nPosDia := MV_PAR01
cCodISS:=""
lFimRel:=.f.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acumuladores Fiscais e variaveis auxiliares                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTransporte:= {0,0,0,0,0,0}
aAliq      := {}
aDia       := {}
aToTMensal := {}
aToTDiario := {}
aLinDet	   := {}
lImpTotal  := .f.
lImpResumo := .f.
lFirst	   := .t.
lTotaliza  := .f.
cLinhaTotDia := 0
cLinhaSubTot := 0
lImpTotdia := .f.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Condicional                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SF3")
nIndex	:=RetIndex("SF3")
cArqInd	:=CriaTrab(NIL,.F.)


If !lAS400
//	cChave	:="F3_CODISS+DTOS(F3_ENTRADA)+F3_SERIE+F3_NFISCAL"
	cChave	:="DTOS(F3_ENTRADA)+F3_SERIE+F3_NFISCAL+F3_CODISS"
	If mv_par07=="*"
		cFiltro	:="F3_TIPO=='S' .and. Substr(F3_CFO,1,1) >= '5'"
	Else
		cFiltro	:="F3_TIPO=='S' .and. Substr(F3_CFO,1,1) >= '5' .and. F3_NRLIVRO=='"+mv_par07+"'"
	Endif
	cFiltro :=cFiltro+".and. F3_FILIAL=='"+xFilial()+"'"
Else
//	cChave	:='F3_CODISS+F3_ENTRADA+F3_SERIE+F3_NFISCAL'
	cChave	:='F3_ENTRADA+F3_SERIE+F3_NFISCAL+F3_CODISS'
	If mv_par07=="*"
		cFiltro	:='F3_TIPO == "S" .and. Substr(F3_CFO,1,1) >= "5"'
	Else
		cFiltro  :='F3_TIPO == "S" .and. Substr(F3_CFO,1,1) >= "5" .and. F3_NRLIVRO=="'+mv_par07+'"'
	EndIf
	cFiltro :=cFiltro+'.and. F3_FILIAL == "'+xFilial()+'"'
Endif

If LastRec()>0
	IndRegua("SF3",cArqInd,cChave,,cFiltro,"Selecionando Registros...")
	dbGotop()
Endif

While !eof()

    lLoop:=MontaSF3(mv_par07)

	IncRegua()

	If aSf3[_F3_ENTRADA] < mv_par01 .or. aSf3[_F3_ENTRADA] > mv_par02 .or. lLoop
		dbSkip()
		Loop
	Endif
    
    	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Controle de Quebra de Pagina                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dDia := aSf3[_F3_ENTRADA]
	If lFirst
		cCodISS:=aSf3[_F3_CODISS]
		lFirst:=.f.
	Else
		Totais()   // Imprime Totais do Livro
	Endif
	
	If Lin>55
		CabLivro() // Imprime o Cabecalho do Livro
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estrutura do Array aLinDet                          ³
	//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	//³ [01] = Numero da Nota                               ³
	//³ [02] = Data Emissao                                 ³
	//³ [03] = Valor da Nota == Base de Calculo             ³
	//³ [04] = Valor dos Materiais = 0                      ³
	//³ [05] = Valor das SubEmpreitadas = 0                 ³
	//³ [06] = Base de Calculo                              ³
	//³ [07] = Aliquota                                     ³
	//³ [08] = Valor do Imposto                             ³
	//³ [09] = Valor do N F fora Municipio                  ³
	//³ [10] = Observacao                                   ³
	//³ [11] = Serie                                        ³
	//³ [12] = Especie                                      ³
	//³ [13] = Cod.Fiscal                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aLinDet:={"","",0,0,0,0,0,0,0,"","","",""}

	aLinDet[01]:=aSf3[_F3_NFISCAL]
	aLinDet[02]:=StrZero(Day(aSf3[_F3_ENTRADA]),2)
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial()+aSf3[_F3_CLIEFOR]+aSf3[_F3_LOJA])

	dbSelectArea("SF3")
	If Empty(aSF3[_F3_DTCANC])
		aLinDet[03]:=aSf3[_F3_BASEICM]
		aLinDet[06]:=aLinDet[03]
		aLinDet[07]:=aSf3[_F3_ALIQICM]
		aLinDet[08]:=aSf3[_F3_VALICM]
	EndIf
	
	aLinDet[10]:=Rtrim(aSf3[_F3_OBSERV])
    aLinDet[11]:=Rtrim(aSf3[_F3_SERIE])
    aLinDet[12]:=Rtrim(aSf3[_F3_ESPECIE])	
	aLinDet[13]:=Rtrim(aSf3[_F3_CODISS])
	
	cCodigo:=" "
	cLinDet:="|"
	cLinDet:=cLinDet+aLinDet[02]+" |"
	cLinDet:=cLinDet+aLinDet[12]+"    | "
    cLinDet:=cLinDet+aLinDet[11]+"   |   "
    cLinDet:=cLinDet+aLinDet[01]+"|"
	cLinDet:=cLinDet+TransForm(aLinDet[03],"@E 999,999,999.99")+"|   "
    cLinDet:=cLinDet+aLinDet[13]+"      | "
	cLinDet:=cLinDet+TransForm(aLinDet[07],"99")+"%   |"
	cLinDet:=cLinDet+Replicate(" ",60)+"|"    
	cLinDet:=cLinDet+aLinDet[10]+"|"
    
	@ Lin,00 PSAY cLinDet
	@ Lin,219 PSAY "|"
      Lin:=Lin+1
      
//    If  aLinDet[02]==aSf3[_F3_ENTRADA] //.and. !EOF()
//        cLinhaTotDia:=cLinhaTotDia+aLinDet[03]
//    	cLinhaTotDia:=cLinhaTotDia+Transform(aTransporte[01],"@E 999,999,999,999.99")//+" | "
//    Else
//        dDia:=aSf3[_F3_ENTRADA]
//    	cLinhaSubTot := cLinhaTotDia
//	    cLinhaTotDia := 0
//    	cLinhaTotDia :=cLinhaTotDia+aLinDet[03]
//    	lImpTotdia   := .t.
//    Endif
	 	 
	// Valores de Transporte
	aTransporte[01]:=aTransporte[01]+aLinDet[03] // Valor da Nota
	aTransporte[02]:=aTransporte[02]+aLinDet[06] // Base de Calculo
	aTransporte[03]:=aTransporte[03]+aLinDet[08] // Valor do Imposto
	aTransporte[04]:=aTransporte[04]+aLinDet[09] // Nota fiscal para fora do Municipio
	
    // Valores Diarios
	nPosDia:=Ascan(aDia,aLinDet[02])
	
	If nPosDia>0
		aTotDiario[nPosDia,1]:=aTotMensal[nPosDia,1]+aLinDet[03] // Valor da Nota
		aTotDiario[nPosDia,2]:=aTotMensal[nPosDia,2]+aLinDet[08] // Valor do Imposto
		aTotDiario[nPosDia,3]:=aTotMensal[nPosDia,3]+aLinDet[02] // Data
	Else
		AADD(aDia,aLinDet[02])
		AADD(aTotDiario,{aLinDet[06],aLinDet[03]})
	Endif


	// Valores Mensais
	nPosAliq:=Ascan(aAliq,aLinDet[07])
	
	If nPosAliq>0
		aTotMensal[nPosAliq,1]:=aTotMensal[nPosAliq,1]+aLinDet[06] // Base
		aTotMensal[nPosAliq,2]:=aTotMensal[nPosAliq,2]+aLinDet[08] // Tributado
	Else
		AADD(aAliq,aLinDet[07])
		AADD(aTotMensal,{aLinDet[06],aLinDet[08]})
	Endif
  
	dbSkip()
	
	lTotaliza:=.t.
	lHouveMov := .T.
	
End
lFimRel:=.t.

if !lHouveMov
	MontaSf3(mv_par07)
	CabLivro() // Imprime o Cabecalho do Livro
	Lin:=Lin+1
	@ Lin,00 PSAY	"|   *** NAO HOUVE MOVIMENTO ***     |                    |                    |                    |     |                    |     |                    |                                                                 |"
	lTotaliza:=.t.
Endif

If lTotaliza
	Totais()   // Imprime Totais do Livro
Endif                                           

	For i:=1 to Len(aDia)
		cLinhaTotdia:=aDia[i]
		cLinhaTotdia1:=aTotDiario[i,01]
		cLinhaTotdia2:=aTotDiario[i,02]
		Lin:=Lin+1
		@ Lin, 00 PSAY cLinhaTotDia
		@ Lin, 15 PSAY cLinhaTotDia1
    	@ Lin, 35 PSAY cLinhaTotDia2
		@ Lin,219 PSAY "|"
    	lImpTotdia   := .t.
	Next

		
RetIndex("SF3")
dbSetOrder(1)
Set Filter to

If !lAS400
	Ferase(cArqInd+OrdBagExt())
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CabLivro() ³ Autor ³ Juan Jose Pereira     ³ Data ³01/06/95³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Cabecalho do Livro                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATRISS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CabLivro()

cMesIncid:=MesExtenso(Month(mv_par01))
cAno:=Ltrim(Str(Year(mv_par01)))
cPagina:=StrZero(nPagina,4)

lin := 01
@ lin, 000 PSAY "EMPRESA: " + SM0->M0_NOMECOM
@ lin, 055 PSAY "*** REGISTRO DE APURACAO DO I.S.S ***"
  lin := lin + 1
@ lin,000 PSAY "CNPJ: " + LEFT(SM0->M0_CGC,2) +"." + SUBSTR(SM0->M0_CGC,3,3) + "." + SUBSTR(SM0->M0_CGC,6,3) + "/" + SUBSTR(SM0->M0_CGC,9,4) + "-" + RIGHT(SM0->M0_CGC,2)
  lin := lin + 1
@ lin,000 PSAY "I.M. " // + mv_par07
  lin := lin + 1
@ lin, 000 PSAY "MES/ANO DE INCIDENCIA: " + MESEXTENSO(MONTH(mv_par01)) + " de " + RIGHT(DTOC(mv_par01),2)
  lin := lin + 1
@ lin,000 PSAY "PAGINA : " + cPagina
  lin := lin + 2
@ lin, 00 PSAY REPLICATE("_",150)
  lin := lin + 1
@ lin, 000 PSAY "DOCUMENTO FISCAL"
@ lin, 030 PSAY "|"
@ lin, 031 PSAY "MOVIMENTO ECONOMICO TRIBUTAVEL"
@ lin, 065 PSAY "|"
@ lin, 066 PSAY "MOVIMENTO ECONOMICO ISENTO"
@ lin, 093 PSAY "|"
@ lin, 094 PSAY "SERVICOS EXEC.POR TERCEIROS"
@ lin, 123 PSAY "|"
  lin := lin + 1
@ lin, 030 PSAY "|"
@ lin, 065 PSAY "|"
@ lin, 068 PSAY "OU NAO TRIBUTAVEL"
@ lin, 093 PSAY "|"
@ lin, 095 PSAY "COM RETENCAO DE IMPOSTO"
@ lin, 123 PSAY "|"
  lin := lin + 1
@ lin, 000 PSAY REPLICATE("-",123)
@ lin, 123 PSAY "|"
@ lin, 124 PSAY "O B S E R V A C O E S"
  lin := lin + 1
@ lin, 000 PSAY "DIA"
@ lin, 004 PSAY "|"
@ lin, 005 PSAY "ESPECIE"
@ lin, 012 PSAY "|"
@ lin, 013 PSAY "SERIE"
@ lin, 018 PSAY "|"
@ lin, 020 PSAY "NUMERO"
@ lin, 030 PSAY "|"
@ lin, 031 PSAY "VALOR DOCTO"
@ lin, 043 PSAY "|"
@ lin, 044 PSAY "COD.FISCAL"
@ lin, 055 PSAY "|"
@ lin, 056 PSAY "ALIQUOTA"
@ lin, 065 PSAY "|"
@ lin, 066 PSAY "VALOR DOCTO FISCAL"
@ lin, 093 PSAY "|"
@ lin, 123 PSAY "|"
  lin := lin + 1
@ lin, 000 PSAY REPLICATE("_",150)
  lin := lin + 1

nPagina:=nPagina+1
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Totais()   ³ Autor ³ Juan Jose Pereira     ³ Data ³01/06/95³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao dos Totais do Livro                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATRISS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Totais()

lImpCabec:=.f.
cLinhaTotDia := 0
cLinhaTotDia1 := 0
cLinhaTotDia2 := 0
cLinhaSubTot := 0
lImpTotdia := .f.

If (EOF() .or. lFimRel)
	lImpTotal:=.t.
	lImpResumo:=.t.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controle de Totais por dia                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//    If  dDia==aSf3[_F3_ENTRADA] //.and. !EOF()
//        cLinhaTotDia:=cLinhaTotDia+aLinDet[03]
//    Else
//        dDia:=aSf3[_F3_ENTRADA]
//    	cLinhaSubTot := cLinhaTotDia
//	    cLinhaTotDia := 0
//    	cLinhaTotDia :=cLinhaTotDia+aLinDet[03]
//    	lImpTotdia   := .t.
//    Endif
	
//    If lImpTotdia
//	     Lin:=Lin+1
//	   @ Lin, 000 PSAY "|SUBTOTAL ==> "
//       @ Lin, 015 PSAY cLinhaSubTot
//	   @ Lin, 219 PSAY "|"
//         cLinhaSubTot := 0  
//  	     lImpTotdia   := .f.
//   	     Lin:=Lin+1
//    Endif	


If (cCodISS#aSf3[_F3_CODISS] .or. Lin>55)
	lImptotal:=.t.
Endif

If (lImpTotal .or. lImpResumo)
	If lImpResumo
		nQtdLinhas:=50-Len(aAliq)
		If Lin>nQtdLinhas
			lImpCabec:=.t.
			nQtdLinhas:=55
		Endif
	Else
		nQtdLinhas:=55
	Endif
	
	While Lin<nQtdLinhas
		Lin:=Lin+1          
		@ Lin,00 PSAY "|   |       |     |           |            |           |         |                           |                             |                                                                                            |"
	End
	
	If lImpTotal
		Lin:=Lin+1
		@ Lin, 00 PSAY "|"+Replic("-",218)+"|"
		If cCodISS==aSf3[_F3_CODISS] .and. !EOF()
			cLinhaTot:="|A TRANSPORTAR    |   "
		Else
			cLinhaTot:="| TOTAL           |   "
		Endif
		cLinhaTot:=cLinhaTot+Transform(aTransporte[01],"@E 999,999,999,999.99")+"   "
		cLinhaTot:=cLinhaTot+Transform(aTransporte[03],"@E 999,999,999,999.99")+"   "
		Lin:=Lin+1
		@ Lin, 00 PSAY cLinhaTot
		@ Lin, 219 PSAY "|"
		lImpTotal:=.f.
//		If cCodIss#aSf3[_F3_CODISS]
//			aTransporte:= {0,0,0,0,0,0}
//			cCodISS:=aSf3[_F3_CODISS]
//		Endif
	EndIf
	If !lImpResumo
		Lin:=Lin+1
		@ Lin, 00 PSAY "+"+Replic("-",218)+"+"
	Else
		If lImpCabec
			Lin:=Lin+1
			@ Lin, 00 PSAY "+"+Replic("-",218)+"+"
			cCodISS:="    "
			nQtdLinhas:=50-Len(aAliq)
			CabLivro()
			While Lin<nQtdLinhas
				Lin:=Lin+1
				@ Lin,00 PSAY "|        |     |                    |                    |                    |                    |     |                    |     |                    |                                                                 |"
			End
		EndIf

		Lin:=Lin+1
		@ Lin, 00 PSAY "|"+Replic("-",218)+"|"
		Lin:=Lin+1
		
/*
        @ Lin, 022 PSAY REPLICATE("_",60)
          Lin := Lin + 1

        @ Lin, 022 PSAY "|"
        @ Lin, 024 PSAY "SOMA                                  |"
        @ Lin, 063 PSAY MSOMA PICTURE "@E 999,999,999,999.99"
        @ Lin, 081 PSAY "|"
        @ Lin, 022 PSAY "|"
          Lin := Lin + 1

        @ Lin, 022 PSAY "|"
        @ Lin, 024 PSAY "DEDUCOES                              |"
        @ Lin, 063 PSAY mv_par09 PICTURE "@E 999,999,999,999.99"
        @ Lin, 081 PSAY "|"
          Lin := Lin + 1
          
        @ Lin, 022 PSAY "|"
        @ Lin, 024 PSAY "BASE DE CALCULO                       |"
        @ Lin, 063 PSAY xBase PICTURE "@E 999,999,999,999.99"
        @ Lin, 081 PSAY "|"
          Lin := Lin + 1
        
        @ Lin, 022 PSAY "|"
        @ Lin, 024 PSAY "IMPOSTO INCIDENTE                     |"
        @ Lin, 063 PSAY  _cBase PICTURE "@E 999,999,999,999.99"       
        @ Lin, 081 PSAY "|"
          Lin := Lin + 1
          
        @ Lin, 022 PSAY "|"
        @ Lin, 024 PSAY "TOTAL ECONOMICO TRIBUTAVEL            |"
        @ Lin, 063 PSAY MSOMA PICTURE "@E 999,999,999,999.99"
        @ Lin, 081 PSAY "|"
          Lin := Lin + 1
          
        @ Lin, 022 PSAY "|"
        @ Lin, 024 PSAY "TOTAL IMPOSTO A RECOLHER              |"
        @ Lin, 063 PSAY   _cBase PICTURE "@E 999,999,999,999.99"      
        @ Lin, 081 PSAY "|"
          Lin := Lin + 1

        @ Lin, 022 PSAY REPLICATE("_",60)
          Lin:=Lin+1
  
*/
		@ Lin, 00 PSAY "+"+Replic("-",218)+"+"
		
	Endif
Endif

Return