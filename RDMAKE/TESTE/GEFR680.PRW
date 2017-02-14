#include "GEFR680.CH"
#Include "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FinR680  ³ Autor ³ Paulo Boschetti       ³ Data ³ 25.10.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Extrato Bancaria - Via CNAB                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinR680(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Sigafin.Adv                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function GEFR680()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1 := "Este relat¢rio ir  emitir o extrato bancario via padr„o CNAB."
LOCAL cDesc2 := "Para que o mesmo seja emitido, dever  ser efetuado a configu-"
LOCAL cDesc3 := "ra‡„o conforme documenta‡„o do banco. GEFCO"
LOCAL cString:="SE5"
LOCAL Tamanho:="M"

PRIVATE titulo := "GEFCO Extrato Bancario - Via CNAB"
PRIVATE cabec1 := OemToAnsi(STR0005)  //"DATA      DOCUM     HISTORICO                             CREDITO              DEBITO               SALDO"
PRIVATE cabec2 := "" , wnrel
PRIVATE aReturn := { OemToAnsi(STR0006), 1,OemToAnsi(STR0007), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog := "FINR680"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := "FIN680"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN680",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros 		³
//³ mv_par01       // Do Banco         	   ³
//³ mv_par02       // Da Agencia       	   ³
//³ mv_par03       // Da Conta       	      ³
//³ mv_par04       // Arquivo Config   	   ³
//³ mv_par05       // Arquivo Extrato  	   ³
//³ mv_par06       // Padrao Banco/Febraban  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="FINR680"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa680Imp(@lEnd,wnRel,cString)},Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ FA680Imp ³ Autor ³ Lu¡s C. Cunha         ³ Data ³ 05/11/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Retorno do Extrato Banc rio                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA680Imp(lEnd,wnRel,cString)

LOCAL CbTxt := space(10)
LOCAL CbCont := 0
LOCAL tamanho := "M"
LOCAL nHdlConf
LOCAL nHdlBco
LOCAL cData, dData , nValor , nTotCred , nTotDeb
LOCAL nLidos := 0
LOCAL aPosicoes:={ }
LOCAL nSaldoInicial := 0
Local lFebraban := .F.
Local cSitLanc := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no cadastro de bancos.                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! (SA6->(dbSeek( xFilial("SA6")+mv_par01+mv_par02+mv_par03 ) ) )
	Set Device To Screen
	Help(" ",1, "AFR680BCO" )
	Return
Endif
dbSelectArea("SEE")
SEE->(dbSeek(xFilial("SEE")+mv_par01+mv_par02+mv_par03))
If !SEE->( found() )
	Set Device To Screen
	Help(" ",1,"PAR150")
	Return .F.
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso esteja usando configuracao 240 bytes/linha p/bancos	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par06 == 1
	lFebraban := IIF(EE_BYTESXT > 200 , .t., .f.)
Endif	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo Configurador.                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHdlConf := Fopen(mv_par04 ,64)
If nHdlConf < 0
	Set Device To Screen
	Help(" ",1, "AFR680CFG" )
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo Configurador.                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHdlBco := Fopen( mv_par05 ,64)
If nHdlBco < 0
	Set Device To Screen
	Help(" ",1, "AFR680BCO" )
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Lˆ arquivo de configura‡„o ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLidos:=0
Fseek(nHdlConf,0,0)
nTamArq:=FSEEK(nHdlConf,0,2)
Fseek(nHdlConf,0,0)

While nTamArq >= 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o tipo de qual registro foi lido ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xBuffer:=Space(85)
	FREAD(nHdlConf,@xBuffer,85)
	If mv_par06 == 1   // Padrao bancos
		IF SubStr(xBuffer,1,1) == CHR(1)
			nTamArq-=85
			Loop
		EndIF
	Endif
	Aadd( aPosicoes, { Substr(xBuffer,2,15),Val(Substr(xBuffer,17,3)),;
							1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3))) })
	nTamArq -=85
Enddo

nTamArq := Fseek( nHdlBco,0, 2 )
Fseek( nHdlBco, 0, 0 )
nBytes := 0
li := 80  // Inicia com quebra de cabecalho
nTamLin := IIF(SEE->EE_BYTESXT > 0, SEE->EE_BYTESXT + 2, 202 )
xBuffer := Space(nTamLin)				// Registro Header 
Fread( nHdlBco, @xBuffer, nTamLin )

SetRegua(nTamArq/Len(xBuffer))

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP") )

xBuffer := Space( nTamLin )			   	// Registro Saldo Inicial
Fread( nHdlBco, @xBuffer, nTamLin )

If SubStr( xBuffer, 1,1 ) == "1" .or. lFebraban .or. mv_par06 == 2 //Febraban
	@ li,20 PSAY repl("*",45)
	li++
	@ li, 20 PSAY OemToAnsi(STR0008)  //"SALDO INICIAL EM "
	If mv_par06 == 1  //Bancos
		cData := SubStr(xBuffer,aPosicoes[6,2],aPosicoes[6,3] )
	ElseIf mv_par06 == 2 // Febraban
		cData := SubStr(xBuffer,aPosicoes[4,2],aPosicoes[4,3] )
	Endif
	cData :=ChangDate(cData,SEE->EE_TIPODAT)
	dData := CtoD(Substr( cData,1,2)+"/"+;
					  SubStr( cData,3,2)+"/"+;
					  SubStr( cData,5,2),"ddmmyy" )

	@ li, 37 PSAY dData 

	cSitLanc := IIF ( mv_par06 == 1 ,;
							SubStr(xBuffer,aPosicoes[7,2],aPosicoes[7,3] ),;
							SubStr(xBuffer,aPosicoes[5,2],aPosicoes[5,3] ) )

	nSaldoInicial := IIF ( mv_par06 == 1 ,;
									Val(SubStr(xBuffer,aPosicoes[5,2],aPosicoes[5,3] ))/100 ,;
									Val(SubStr(xBuffer,aPosicoes[3,2],aPosicoes[3,3] ))/100 )

	@ li,    Iif( cSitLanc == "C", 50,70 ) PSAY nSaldoInicial Picture "@E 9999,999,999.99"
	li++
	@ li,20 PSAY repl("*",45)
	IncRegua()
	li++
Endif
nSaldoInicial *= Iif( cSitLanc == "C", 1,-1) // Inverte o sinal, caso o saldo inicial seja negativo.
While (nTamArq - (nTamLin * 2)) > (nTamLin * 2) // Dois ultimos registros: saldo final e trailler
	xBuffer := Space( nTamLin )			// Lancamentos
	Fread( nHdlBco, @xBuffer, nTamLin )
	If (SubStr( xBuffer, 1,1 ) == "9" .and. mv_par06 == 1 .and. !lFebraban) .or. ;		// Registro Trailler
		(lFebraban  .and. Substr(xBuffer,8,1) $ "5#9") .or. ;		// Registro Saldo Final
		(Substr( xBuffer, 8,1 ) $ "5#9" .and. mv_par06 == 2)		
		Exit
	Endif
	If li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP") )
	Endif
	cCodMov	:=Substr(xBuffer,aPosicoes[11,2],aPosicoes[11,3])
	dbSelectArea("SEJ") 
	If dbSeek(xFilial("SEJ")+mv_par01+cCodMov)
		cSitLanc := SEJ->EJ_DEBCRE 
	Else
		Help(" ",1,"FA470OCOR")
		lSaida := .T.
		Exit
	Endif

	cData := SubStr(xBuffer,aPosicoes[9,2],aPosicoes[9,3] )
	cData := ChangDate(cData,SEE->EE_TIPODAT)
	dData := CtoD(Substr( cData,1,2)+"/"+;
					  SubStr( cData,3,2)+"/"+;
					  SubStr( cData,5,2),"ddmmyy" )
	cNum  := SubStr(xBuffer,aPosicoes[8,2],aPosicoes[8,3] )
	cDesc := SubStr(xBuffer,aPosicoes[12,2],aPosicoes[12,3] )
	nValor := Val(SubStr(xBuffer,aPosicoes[10,2],aPosicoes[10,3] ))/100
	If cSitLanc == "C" 
		nSaldoInicial += nValor
	Else
		nSaldoInicial -= nValor
	Endif

	@ li,00 PSAY dData 
	@ li,10 PSAY cNum 
	@ li,20 PSAY Substr(cDesc,1,30)
   @ li, Iif( cSitLanc == "C"  ,50,70) PSAY nValor Picture "@E 9999,999,999.99"
	@ li,90 PSAY nSaldoInicial Picture "@E 9999,999,999.99" 
	li++
   IncRegua()
	nTamArq -= nTamLin

Enddo

xBuffer := Space( nTamLin )			   	// Registro Saldo Final
Fread( nHdlBco, @xBuffer, nTamLin )
if (!lFebraban .and. SubStr(xBuffer,1,1) == "1") .or. ; // Bancos
	( lFebraban .and. Substr(xBuffer,8,1) == "5") .or. ; // Bancos 240 bytes/linha
	( mv_par06 == 2 .and. Substr(xBuffer,8,1) == "5")	  // Febraban

	@ li,20 PSAY repl("*",45)
	IncRegua()
	li++
	cSitLanc := SubStr(xBuffer,aPosicoes[16,2],aPosicoes[16,3] )
	nValor := Val(SubStr(xBuffer,aPosicoes[15,2],aPosicoes[15,3] ))/100
	cData := SubStr(xBuffer,aPosicoes[14,2],aPosicoes[14,3] )
	cData := ChangDate(cData,SEE->EE_TIPODAT)
	dData := CtoD(Substr( cData,1,2)+"/"+;
					  SubStr( cData,3,2)+"/"+;
					  SubStr( cData,5,2),"ddmmyy" )
	
	If lFebraban  // Extrato de 240 posicoes
		nTotCred := Val(SubStr(xBuffer,aPosicoes[19,2],aPosicoes[19,3] ))/100
		nTotDeb  := Val(SubStr(xBuffer,aPosicoes[18,2],aPosicoes[18,3] ))/100
	Endif	

	@ li, 20 PSAY "SALDO FINAL EM "
	@ li, 37 PSAY dData 
   @ li,    Iif( cSitLanc == "C", 50, 70)  PSAY nValor Picture "@E 9999,999,999.99"
	li++
Endif
IF !lFebraban .and. mv_par06 == 1 
	xBuffer := Space( nTamLin )			   
	Fread( nHdlBco, @xBuffer, nTamLin )
Endif

// Registro Trailler
If (!lFebraban .and. SubStr( xBuffer, 1,1 ) == "9") .or. ;
	lFebraban .or. ;
	mv_par06 == 2

	If !lFebraban .or. mv_par06 == 2
		nTotCred := Val(SubStr(xBuffer,aPosicoes[19,2],aPosicoes[19,3] ))/100
		nTotDeb  := Val(SubStr(xBuffer,aPosicoes[18,2],aPosicoes[18,3] ))/100
	Endif

	@ li,20 PSAY OemToAnsi(STR0009)  //"TOTAL CREDITOS"
	@ li,50 PSAY nTotCred Picture "@E 9999,999,999.99" 
	IncRegua()
	li++
	@ li,20 PSAY OemToAnsi(STR0010)  //"TOTAL DEBITOS "
	@ li,50 PSAY nTotDeb Picture "@E 9999,999,999.99" 
	li++
	@ li,20 PSAY repl("*",45)
	li++
Endif
Roda(cbcont,cbtxt,"M")
Set( 20, "SCREEN" )
Fclose( nHdlBco )  // Fecha sequencial enviado pelo banco
Fclose( nHdlConf ) // Fecha sequencial do configurador
If aReturn[5] = 1
    Set( 24, "" )
    dbCommitAll()
    OurSpool(wnrel)
Endif
MS_FLUSH()

