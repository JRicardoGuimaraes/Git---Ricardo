#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
//#include "FIVEWIN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGEFM50     บ Autor ณ Saulo Muniz       บ Data ณ  06/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Arquivo de exporta็ใo de dados para Adhoc                  บฑฑ
ฑฑบ          ณ Versใo 1.01                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gefco                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GEFM50()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local oDlg,oGet
Local cFile := Space(200)

Private oGeraTxt

arqimp  := SPACE( 35 )
arquivo := "D:\MICROSIGA\SIGAADV\ARQUIVO.MZP"

dbSelectArea("SE1")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gerao de Arquivo Microsiga -> Adhoc - Versใo 1.03")
@ 002,10 TO 080,190
@ 10,018 Say " Este programa ira exportar as faturas recebidas pelo banco de "
@ 18,018 Say " acordo com os parโmetros definidos pelo usuario, retornando as"
@ 26,018 Say " Baixas para o sistema Adhoc.                                  "

//@ 036,013 Get arqimp Picture "@!" WHEN .f. VALID VARQIMP() Size 150,10 Object oarqimp
//@ 050,013 Button OemToAnsi("Arquivo")                      Size 30,12 Action VARQIMP()
//@ 050,056 BUTTON "Zip" SIZE 50,10 ACTION MyComp(arqimp)  
//@ 050,095 BUTTON "UnZip" SIZE 50,10 ACTION IIF(MsDecomp(arqimp),MsgInfo("OK"),MsgStop("ERRO"))
@ 055,088 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 055,119 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 055,150 BMPBUTTON TYPE 05 ACTION Pergunte("GEFM50",.T.) //pergunte("MTR730",.F.)
Activate Dialog oGeraTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERATXTบ Autor ณ AP7 IDE            บ Data ณ  06/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkGeraTxt

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo texto                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//Private cArqTxt := "D:\MICROSIGA\Faturas\ARQUIVO.TXT"
Private cArqTxt  := "\\geatj1appl1\Protheus8\Protheus_Data\Importar\FaturasAdhoc\Receber\Faturas.txt"
Private cArqSai  := "\\geatj1appl1\Protheus8\Protheus_Data\Importar\FaturasAdhoc\Receber\Faturas.gef"
Private nHdl     := fCreate(cArqTxt)
Private cEOL     := "CHR(13)+CHR(10)"
Private cPathori := "\\geatj1appl1\Protheus8\Protheus_Data\Importar\FaturasAdhoc\Receber\"

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

Pergunte("GEFM50",.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cabec. do arquivo          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
xIndice  := "AAA"
Dttrans  := Gravadata(Ddatabase,.F.,8) //Substr(Dtoc(Ddatabase),1,2) + Substr(Dtoc(Ddatabase),4,2) + Substr(Dtoc(Ddatabase),7,2)
Hrtrans  := Substr(Time(),1,2) + Substr(Time(),4,2)
DtPar01  := Gravadata(MV_PAR01,.F.,8) //Substr(Dtoc(MV_PAR01),1,2) + Substr(Dtoc(MV_PAR01),4,2) + Substr(Dtoc(MV_PAR01),7,2) //Dtoc(MV_PAR01)
DtPar02  := Gravadata(MV_PAR02,.F.,8) //Substr(Dtoc(MV_PAR02),1,2) + Substr(Dtoc(MV_PAR02),4,2) + Substr(Dtoc(MV_PAR02),7,2) //Dtoc(MV_PAR02)
xUser    := Substr(Alltrim(cUsername),1,10) // ou maquina GetComputerName 
System   := "MICROSIGA"
xBrancos := Space(97)

// UsrRetMail(cCodUsr) ' Retorna o endere็o de e-mail do usuแrio cujo c๓digo ้ cCodUsr.

_FHeader := xIndice + Dttrans + Hrtrans + DtPar01 + DtPar02 + xUser + System + xBrancos + cEOL

fWrite(nHdl,_FHeader,Len(_FHeader))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Processa({|| RunCont() },"Processando...")

	If File(cPathori)
       Resposta := MSGBOX("Arquivo texto jแ existe, Deseja atualizar o arquivo !","Informaao","YESNO")
       If Resposta
		  Ferase(cPathori)             
       Else	      
	      //MsgBox("Arquivo texto jแ existe !","Informaao","INFO")
	      Return
	   Endif	   
	Endif

    cCmd := "Decifrador.exe /c " + cArqTxt + " " + cArqSai   
    WinExec(cCmd)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  06/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunCont()

Local nTamLin, cLin, cCpo, nReg

nReg := 0

/*

// SE1->E1_OBS == "Fatura Adhoc"
dbSelectArea("SE1")
DbSetOrder(1) 
dbGoTop()
//DbSeek(xFilial("SE1") + "FAT" + MV_PAR03,.T.) 

ProcRegua(RecCount()) // Numero de registros a processar

While !EOF() //.And. SE1->E1_PREFIXO == "FAT" .And. SE1->E1_NUM >= MV_PAR03 .And. SE1->E1_NUM <= MV_PAR04

	IncRegua()
*/

V_Se1     := RETSQLNAME("SE1")
V_Sa1     := RETSQLNAME("SA1")
_cFilial  := ""
nValorFil := 0
nTotalG   := 0
_cFilAnt  := ""   
 
cQuery = "SELECT A.E1_FILIAL ,A.E1_NUM ,A.E1_PREFIXO ,A.E1_NOMCLI ,A.E1_CLIENTE ,A.E1_LOJA ,A.E1_EMISSAO ,A.E1_VALOR ,B.A1_COD ,B.A1_LOJA ,B.A1_CONTA ,B.A1_NREDUZ,A.E1_BAIXA ,A.E1_OCORREN ,A.E1_NUMBCO,A.E1_HIST,A.E1_VALLIQ,A.E1_MULTA,A.E1_PORTADO,A.E1_AGEDEP,A.E1_CONTA,A.E1_HIST,A.E1_JUROS"
cQuery += " FROM "+V_Se1+" AS A,"+V_Sa1+" AS B "
cQuery += " WHERE A.E1_CLIENTE = B.A1_COD AND A.E1_LOJA = B.A1_LOJA AND"
cQuery += " A.E1_BAIXA >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " A.E1_BAIXA <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " A.E1_OBS <> '' AND "
cQuery += " A.E1_SALDO = 0 AND A.E1_PREFIXO = 'FAT' AND A.E1_FATPREF = 'FAT'"
cQuery += " A.E1_TIPO = 'FAT' AND A.E1_FLAGFAT = 'S' AND "
cQuery += " A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*'"

TcQuery cQuery Alias "ADH" NEW
DbSelectArea("ADH")
DbGoTop()         

_cFilial := ADH->E1_FILIAL
    
While !Eof() 
    
    IncProc()
                      
    nTamLin := 150
    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao    
    cEmissao := ADH->E1_EMISSAO //Gravadata(ADH->E1_EMISSAO,.F.,8)
    cBaixa   := ADH->E1_BAIXA //Gravadata(ADH->E1_BAIXA,.F.,8)
    cHist    := Substr(Alltrim(ADH->E1_HIST),1,20) 
    cTamHist := Len(Substr(Alltrim(ADH->E1_HIST),1,20))     
    cIndice   := "RET"
    cNossonum := Strzero(Val(ADH->E1_NUMBCO),15)
    cFatura   := SUBSTR(cEmissao,3,2) + SUBSTR(cEmissao,5,2) + ADH->E1_NUM  
    DtFat     := cEmissao //Substr(Dtoc(ADH->E1_EMISSAO),1,2) + Substr(Dtoc(ADH->E1_EMISSAO),4,2) + Substr(Dtoc(ADH->E1_EMISSAO),7,2)
    DtBaixa   := IIF(Empty(cBaixa),Space(8),cBaixa) //Substr(Dtoc(ADH->E1_BAIXA),1,2) + Substr(Dtoc(ADH->E1_BAIXA),4,2) + Substr(Dtoc(ADH->E1_BAIXA),7,2)
    cOcorren  := Strzero(Val(ADH->E1_OCORREN),4)
    nValPag   := Strzero(Int(ADH->E1_VALLIQ * 100),17) 
    nValJur   := Strzero(Int(ADH->E1_JUROS  * 100),17)  
    nValMulta := Strzero(Int(ADH->E1_MULTA  * 100),17)  
    cObserv   := Substr(Alltrim(ADH->E1_HIST),1,20) + Space(20 - cTamHist)
    cBanco    := ADH->E1_PORTADO + Space(7)
    cAgencia  := ADH->E1_AGEDEP  
    cConta    := ADH->E1_CONTA   
    cBrancos  := Space(55)
    cLin := cIndice + cNossonum + cFatura + DtFat + DtBaixa + cOcorren + nValPag + nValJur + nValMulta + cObserv + cBanco + cAgencia + cConta + cBrancos + cEOL
    nReg++

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
    //ณ linha montada.                                                      ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            Exit
        Endif
    Endif

    dbSkip()

EndDo

If nReg == 0   
   Ferase(cPathori)                   
Endif


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Rodape do arquivo          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
tIndice  := "ZZZ"
nQtdReg  := Strzero(nReg,10)
tBrancos := Space(137)

_FTrailler := tIndice + nQtdReg + tBrancos + cEOL
fWrite(nHdl,_FTrailler,Len(_FTrailler))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
//ณ cao anterior.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fClose(nHdl)
Close(oGeraTxt)

Return()

Static Function MyComp( cFile )
	MsgInfo( Mscompress(cFile) )
Return Nil

STATIC FUNCTION VARQIMP()

  cTipo :="Arquivo Texto *.TXT)        | *.TXT | "
  cFile := cGetFile(cTipo,"Selecione o arquivo para compactar")
  
  If !Empty(cFile)
     Aviso("Arquivo Selecionado",cFile,{"Ok"})
  Endif     
  
  arqimp := PADR(ALLTRIM(cFile),35)
  oarqimp:Refresh()

RETURN(.t.)