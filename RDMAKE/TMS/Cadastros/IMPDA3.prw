#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บ Autor ณ AP6 IDE            บ Data ณ  19/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

// Importa Veiculos ADT
User Function IMPDA3()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cPerg       := "TESTE"
Private oLeTxt

Private cString := "DA3"

dbSelectArea("DA3")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say " DA3                                                           "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKLETXT  บ Autor ณ AP6 IDE            บ Data ณ  19/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a leitura do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkLeTxt

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abertura do arquivo texto                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//Private mv_par01 := "\\10.62.160.153\P11_Migracao\Protheus_Data\DadosAdv\Motoritas.prn"
Private cNomeArq := "\\10.62.160.153\P11_Migracao\Protheus_Data\DadosAdv\MotoritasCNPJ.dbf"
//Private nHdl     := fOpen(mv_par01,68)
//Private nHdl    := fOpen("\\10.62.160.153\P11_Migracao\Protheus_Data\DadosAdv\Motoritas.prn",68)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif
/*
If nHdl == -1
    MsgAlert("O arquivo de nome "+mv_par01+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return
Endif
*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Processa({|| RunCont() },"Processando...")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  19/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunCont
Local nTamFile, nTamLin, cBuffer, nBtLidos
Local _cCNPJ := ""

//ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
//บ Lay-Out do arquivo Texto gerado:                                บ
//ฬออออออออออออออออัออออออออัอออออออออออออออออออออออออออออออออออออออน
//บCampo           ณ Inicio ณ Tamanho                               บ
//วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
//บ DA3_FILIAL     ณ 01     ณ 02                                    บ
//ศออออออออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออผ

/*
nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 225+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto
nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da Segunda linha do arquivo texto
*/

// LAYOUT DA TABELA DE VEICULO
/*
X3_CAMPO	X3_TIPO	X3_TAMANHO	X3_DECIMAL	X3_TITULO
DA3_FILIAL	C	2		Filial
DA3_COD		C	8		Veiculo
DA3_DESC		C	30		Modelo
DA3_PLACA	C	8		Placa
DA3_CAPACN	N	9	2	Capac. Nom.
DA3_CAPACM	N	9	2	Capac. Max.
DA3_VOLMAX	N	6	2	Vol. Maximo
DA3_MOTORI	C	6		Motorista
DA3_LIMMAX	N	4		Max.Ptos.Ven
DA3_ATIVO	C	1		Cam. Ativo
DA3_QTDUNI	N	6		Qtde. unitiz
DA3_UNITIZ	C	6		Unit. Padrao
DA3_CODGRU	C	3		Cod. Grupo
DA3_MUNPLA	C	15		Munici.Placa
DA3_ESTPLA	C	2		Estado Placa
DA3_DESCMO	C	40		Nome Motoris
DA3_ALTINT	N	6	2	Alt. Interna
DA3_LARINT	N	6	2	Larg.Interna
DA3_COMINT	N	6	2	Comp.Interno
DA3_ALTEXT	N	6	2	Alt. Externa
DA3_COMEXT	N	6	2	Comp.Externo
DA3_LAREXT	N	6	2	Larg.Externa
DA3_FILATU	C	2		Fil.Atual
DA3_FILVGA	C	2		Fil.Vge.Atu.
DA3_NUMVGA	C	6		Num.Vge.Atu.
DA3_FROVEI	C	1		Frota
DA3_CODBEM	C	16		Cod.Bem
DA3_CODFOR	C	6		Proprietario
DA3_LOJFOR	C	2		Loja Propri.
DA3_DESCFO	C	40		Nome Fornece
DA3_MARVEI	C	2		Marca
DA3_DESMAR	C	30		Desc.Marca
DA3_CORVEI	C	2		Cor
DA3_DESCOR	C	30		Desc.Cor
DA3_ANOMOD	C	4		Ano Modelo
DA3_ANOFAB	C	4		Ano Fabric.
DA3_CHASSI	C	20		Chassi
DA3_TIPVEI	C	2		Tipo Veiculo
DA3_DESTIP	C	30		Desc.Tipo
DA3_QTDEIX	N	2		Qtde.Eixos
DA3_BITMAP	C	8		Foto
DA3_VEIRAS	C	1		Rastreado
DA3_CUSTO1	N	14	2	Custo Moeda1
DA3_CUSTO2	N	14	2	Custo Moeda2
DA3_CUSTO3	N	14	2	Custo Moeda3
DA3_CUSTO4	N	14	2	Custo Moeda4
DA3_CUSTO5	N	14	2	Custo Moeda5
DA3_STATUS	C	1		Status
DA3_TARA		N	9	2	Tara
DA3_RENAVA	C	10		Cod. Renavam
DA3_CODRAS	C	15		Cod. Rastre.
DA3_FILBAS	C	2		Fil. Base
DA3_TIPGRP	C	2		Segmento
DA3_NOMGRP	C	30		Segmento
DA3_TIPTRA	C	1		Tipo Transp.
DA3_DESTRA	C	30		Desc.Tip.Tra
*/

//dbUseArea(.T., "DBFCDX", (cNomeArq), "VEICR", .T., .F.)
dbUseArea(.T., "DBFCDXADS", "VEICULOS", "VEIC", .T., .F.)

ProcRegua(LastRec()) // Numero de registros a processar

dbSelectArea("VEIC") ; dbGoTop()

_nConta := 02
   
//While nBtLidos >= nTamLin
While !VEIC->(EOF())

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Incrementa a regua                                                  ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

    IncProc()


    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Grava os campos obtendo os valores da linha lida do arquivo texto.  ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	dbSelectArea("DA3")
	RecLock("DA3",.T.)

		DA3->DA3_FILIAL	:= xFILIAL("DA3") //C	2		Filial do Sistema
		DA3->DA3_COD		:= GETSXENUM("DA3","DA3_COD") // StrZero(_nConta,8) // C	8		Veiculo
		//ConfirmSXE()
		
		_nConta++

/*		
		dbSelectArea("SA2") ; dbSetOrder(3)
		_cCNPJ := StrTran(StrTran(StrTran(AllTrim(VEIC->CNPJ_),".",""),"/",""),"-","")
		If dbSeek(xFilial("SA2") + _cCNPJ)
			// Grava o RNTRC no cadastro de fornecedor
			SA2->(RecLock("SA2",.F.))
				SA2->A2_RNTRC := VEIC->RNTRCX
			SA2->(MsUnLock())
			
			DA3->DA3_FORNEC	:= SA2->A2_CGC  //C	6		Codigo Fornec VEICrista
			DA3->DA3_LOJA		:= SA2->A2_LOJA //C	2		Loja Fornecedor
		EndIf	
*/		
		dbSelectArea("DA3")
		
		DA3->DA3_DESC		:= VEIC->MARCA  // C	30		Modelo
		DA3->DA3_PLACA		:= VEIC->PLACA  // C	8		Placa
		DA3->DA3_CAPACN	:= Val(VEIC->TARA)   // N	9	2	Capac. Nom.
		DA3->DA3_CAPACM	:= Val(VEIC->VOLUME) // N	9	2	Capac. Max.
		DA3->DA3_VOLMAX	:= Val(VEIC->VOLUM_TOT) // N	6	2	Vol. Maximo
		// DA3->DA3_MOTORI	:= // C	6		Motorista
		// DA3->DA3_LIMMAX	:= // N	4		Max.Ptos.Ven
		DA3->DA3_ATIVO		:= "1" // C	1		Cam. Ativo
		// DA3->DA3_QTDUNI	:= // N	6		Qtde. unitiz
		// DA3->DA3_UNITIZ	:= // C	6		Unit. Padrao
		// DA3->DA3_CODGRU	:= // C	3		Cod. Grupo
		// DA3->DA3_MUNPLA	:= // C	15		Munici.Placa
		// DA3->DA3_ESTPLA	:= // C	2		Estado Placa
		// DA3->DA3_DESCMO	:= SubStr(AllTrim(VEIC->MOTORISTA),RAT(",",AllTrim(VEIC->MOTORISTA))+1,Len(AllTrim(VEIC->MOTORISTA)))
		// + " " +;  // C	40		Nome Motoris
		//							SubStr(AllTrim(VEIC->MOTORISTA),1,AT(",",AllTrim(VEIC->MOTORISTA))-1)
		DA3->DA3_ALTINT	:= VAL(VEIC->ALTURA_MIN) // N	6	2	Alt. Interna
		DA3->DA3_LARINT	:= VAL(VEIC->LARGURA) // N	6	2	Larg.Interna
		// DA3->DA3_COMINT	:= // N	6	2	Comp.Interno
		DA3->DA3_ALTEXT	:= VAL(VEIC->ALTURA) // N	6	2	Alt. Externa
		// DA3->DA3_COMEXT	:= // N	6	2	Comp.Externo
		DA3->DA3_LAREXT	:= VAL(VEIC->LARGURA) // N	6	2	Larg.Externa
		//DA3->DA3_FILATU	:= ""// C	2		Fil.Atual
		//DA3->DA3_FILVGA	:= ""// C	2		Fil.Vge.Atu.
		//DA3->DA3_NUMVGA	:= ""// C	6		Num.Vge.Atu.
		//DA3->DA3_FROVEI	:= "" // C	1		Frota
		//DA3->DA3_CODBEM	:= "" // C	16		Cod.Bem
		//DA3->DA3_CODFOR	:= "" // C	6		Proprietario
		//DA3->DA3_LOJFOR	:= "" // C	2		Loja Propri.
		// DA3->DA3_DESCFO	:= AllTrim(Upper(VEIC->FORNECEDOR)) // C	40		Nome Fornece
		// DA3->DA3_MARVEI	:= // C	2		Marca
		//DA3->DA3_DESMAR	:= VEIC->MARCA // C	30		Desc.Marca
		// DA3->DA3_CORVEI	:= // C	2		Cor
		// DA3->DA3_DESCOR	:= // C	30		Desc.Cor
		DA3->DA3_ANOMOD	:= STR(VEIC->ANO) // C	4		Ano Modelo
		DA3->DA3_ANOFAB	:= STR(VEIC->ANO)// C	4		Ano Fabric.
		DA3->DA3_CHASSI	:= UPPER(VEIC->CHASSIS) // C	20		Chassi
		DA3->DA3_TIPVEI	:= "15" // C	2		Tipo Veiculo
		// DA3->DA3_DESTIP	:= UPPER(VEIC->TIOVEIC) // C	30		Desc.Tipo
		DA3->DA3_QTDEIX	:= VEIC->EIXOS // N	2		Qtde.Eixos
		//DA3->DA3_BITMAP	:= // C	8		Foto
		DA3->DA3_VEIRAS	:= IIF(UPPER(VEIC->GPS)="SIM", "1", "2") // C	1		Rastreado
		/*
		DA3->DA3_CUSTO1	:= // N	14	2	Custo Moeda1
		DA3->DA3_CUSTO2	:= // N	14	2	Custo Moeda2
		DA3->DA3_CUSTO3	:= // N	14	2	Custo Moeda3
		DA3->DA3_CUSTO4	:= // N	14	2	Custo Moeda4
		DA3->DA3_CUSTO5	:= // N	14	2	Custo Moeda5
		*/
		// DA3->DA3_STATUS	:= // C	1		Status
		DA3->DA3_TARA		:= VAL(VEIC->TARA) // N  9	2	Tara
		// DA3->DA3_RENAVA	:= VEIC->// C	10		Cod. Renavam
		DA3->DA3_CODRAS	:= AllTrim(VEIC->NRO__GPS) // C	15		Cod. Rastre.
		// DA3->DA3_FILBAS	:= // C	2		Fil. Base
		// DA3->DA3_TIPGRP	:= // C	2		Segmento
		// DA3->DA3_NOMGRP	:= // C	30		Segmento
		//DA3->DA3_TIPTRA	:= "" // C	1		Tipo Transp.
		//DA3->DA3_DESTRA	:= "" // C	30		Desc.Tip.Tra
	DA3->(MSUnLock())

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Leitura da proxima linha do arquivo texto.                          ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    //nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
    
	dbSelectArea("VEIC")
   dbSkip()
End

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
//ณ cao anterior.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//fClose(nHdl)
//Close(oLeTxt)

Alert("Final de Importa็ใo")
Return
