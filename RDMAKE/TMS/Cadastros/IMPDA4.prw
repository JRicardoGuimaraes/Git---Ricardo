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

// Importa Motoristas do ADT
User Function IMPDA4()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cPerg       := "TESTE"
Private oLeTxt

Private cString := "DA4"

dbSelectArea("DA4")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say " DA4                                                           "

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

// LAYOUT DA TABELA DE MATORIAS
/*
DA4_FILIAL	C	2		Filial do Sistema
DA4_COD		C	6		Codigo do Motorista
DA4_FORNEC	C	6		Codigo Fornec Motorista
DA4_LOJA	C	2		Loja Fornecedor
DA4_NOME	C	40		Nome do Motorista
DA4_NREDUZ	C	15		Nome Reduzido Motorista
DA4_END		C	40		Endereco do Motorista
DA4_BAIRRO	C	20		Bairro do Motorista
DA4_MUN		C	15		Municipio do Motorista
DA4_EST		C	2		Federacao
DA4_CEP		C	8		Cod Enderecamento Postal
DA4_CGC		C	14		CNPJ/CPF do Motorista
DA4_TEL		C	15		Numero do Telefone
DA4_AJUDA1	C	6		Ajudante 1
DA4_AJUDA2	C	6		Ajudante 2
DA4_AJUDA3	C	6		Ajudante 3
DA4_TIPMOT	C	1		Tipo Motorista
DA4_NOMFOR	C	30		Nome do Fornecedor
DA4_FILBAS	C	2		Filial Base do motorista
DA4_MAT		C	6		Matricula
DA4_NUMCNH	C	10		No.CNH
DA4_REGCNH	C	10		No.Registro CNH
DA4_DTECNH	D	8		Data Exped. CNH
DA4_DTVCNH	D	8		Data Vencto CNH
DA4_MUNCNH	C	15		Municipio CNH
DA4_ESTCNH	C	2		Estado CNH
DA4_CATCNH	C	3		Categoria CNH
DA4_PAI		C	40		Pai
DA4_MAE		C	40		Mae
DA4_TELREC	C	15		Telefone Recados
DA4_FALCOM	C	15		Falar Com
DA4_RG		C	15		RG
DA4_RGORG	C	3		Orgao Emissor
DA4_RGEST	C	2		Estado do RG
DA4_CORPEL	C	2		Cor Pele
DA4_DESPEL	C	30		Des.Cor Pele
DA4_CORCAB	C	2		Cor Cabelo
DA4_DESCAB	C	30		Des.Cor Cabelo
DA4_CORBAR	C	2		Cor Barba
DA4_DESBAR	C	30		Des.Cor Barba
DA4_COROLH	C	2		Cor Olho
DA4_DESOLH	C	30		Des.Cor Olho
DA4_SINAIS	C	30		Sinais
DA4_ALTURA	N	5	2	Altura
DA4_PESO	N	7	3	Peso
DA4_DATNAS	D	8		Data de Nascimento
DA4_ESTCIV	C	2		Estado Civil
DA4_NUMSEG	C	10		No.Segurado
DA4_LIBSEG	C	10		No.Liberacao Seguro
DA4_VALSEG	N	14	2	Val.Segurado
DA4_CARPER	C	1		Carga Perigosa
DA4_BLQMOT	C	1		Bloqueado
DA4_COMISS	C	1		Motorista Comissionado ?
DA4_BITMAP	C	8		Foto do Motorista
DA4_RGDT	D	8		Data da Emissาo do RG
*/

//dbUseArea(.T., "DBFCDX", (cNomeArq), "MOTOR", .T., .F.)
dbUseArea(.T., "DBFCDXADS", "MOTORISTA", "MOTO", .T., .F.)

ProcRegua(LastRec()) // Numero de registros a processar

dbSelectArea("MOTO") ; dbGoTop()

_nConta := 02
   
//While nBtLidos >= nTamLin
While !MOTO->(EOF())

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Incrementa a regua                                                  ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

    IncProc()


    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Grava os campos obtendo os valores da linha lida do arquivo texto.  ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	dbSelectArea("DA4")
	RecLock("DA4",.T.)

    	// DA3->DA3_FILIAL := Substr(cBuffer,01,02)
		DA4->DA4_FILIAL	:= xFILIAL("DA4") //C	2		Filial do Sistema
		DA4->DA4_COD		:= StrZero(_nConta,6) // GetSX8Num("DA4") ; ConfirmSX8() //) //C	6		Codigo do Motorista  // CriaVar("DA4_COD",.T.)
		_nConta++
		
		dbSelectArea("SA2") ; dbSetOrder(3)
		_cCNPJ := StrTran(StrTran(StrTran(AllTrim(MOTO->CNPJ_),".",""),"/",""),"-","")
//		alert(_cCNPJ)
//		Alert(MOTO->CNPJ_)
		If dbSeek(xFilial("SA2") + _cCNPJ)
			// Grava o RNTRC no cadastro de fornecedor
			SA2->(RecLock("SA2",.F.))
				SA2->A2_RNTRC := MOTO->RNTRCX
			SA2->(MsUnLock())
			
			DA4->DA4_FORNEC	:= SA2->A2_CGC  //C	6		Codigo Fornec Motorista
			DA4->DA4_LOJA		:= SA2->A2_LOJA //C	2		Loja Fornecedor
		EndIf	
		
		dbSelectArea("DA4")
		
		DA4->DA4_NOME		:= AllTrim(MOTO->NOME) + " " + AllTrim(MOTO->SOBRENOME) //C	40		Nome do Motorista
		DA4->DA4_NREDUZ	:= AllTrim(MOTO->NOME)  			//C	15		Nome Reduzido Motorista
		DA4->DA4_END		:= Upper(AllTrim(MOTO->ENDERECO)) 	//C	40		Endereco do Motorista
		DA4->DA4_BAIRRO	:= AllTrim(MOTO->LOCALIDADE)      	//C	20		Bairro do Motorista
		DA4->DA4_MUN		:= AllTrim(MOTO->CIDADE)  			//C	15		Municipio do Motorista
		DA4->DA4_EST		:= "" //C	2		Federacao
		DA4->DA4_CEP		:= "" //C	8		Cod Enderecamento Postal
		DA4->DA4_CGC		:= StrTran(StrTran(AllTrim(MOTO->CPF),".",""),"-","") //C	14		CNPJ/CPF do Motorista
		DA4->DA4_TEL		:= AllTrim(MOTO->TELEFONE2) //C	15		Numero do Telefone
		DA4->DA4_AJUDA1	:= "" //C	6		Ajudante 1
		DA4->DA4_AJUDA2	:= "" //C	6		Ajudante 2
		DA4->DA4_AJUDA3	:= "" //C	6		Ajudante 3
		DA4->DA4_TIPMOT	:= "" //C	1		Tipo Motorista
		// DA4->DA4_NOMFOR	:= AllTrim(MOTO->FORNECEDOR) //C	30		Nome do Fornecedor
		DA4->DA4_FILBAS	:= "" //C	2		Filial Base do motorista
		DA4->DA4_MAT		:= "" //C	6		Matricula
		DA4->DA4_NUMCNH	:= AllTrim(Str(MOTO->HABILITACA)) //C	10		No.CNH
		DA4->DA4_REGCNH	:= ""  //C	10		No.Registro CNH
		DA4->DA4_DTECNH	:= MOTO->DTHABILITA	//D	8		Data Exped. CNH
		DA4->DA4_DTVCNH	:= MOTO->DTVALHABIL  //D	8		Data Vencto CNH
		DA4->DA4_MUNCNH	:= "" //C	15		Municipio CNH
		DA4->DA4_ESTCNH	:= "" //AllTrim(MOTO->ESTADO_RG)//C	2		Estado CNH
		DA4->DA4_CATCNH	:= AllTrim(MOTO->CAT_HABILI) //C	3		Categoria CNH
		DA4->DA4_PAI		:= "" //C	40		Pai
		DA4->DA4_MAE		:= "" //C	40		Mae
		DA4->DA4_TELREC	:= AllTrim(MOTO->NEXTEL) //C	15		Telefone Recados
		DA4->DA4_FALCOM	:= "" //C	15		Falar Com
		DA4->DA4_RG		:= AllTrim(Str(MOTO->RG)) //C	15		RG
		DA4->DA4_RGORG	:= AllTrim(MOTO->EMISSOR_RG) //C	3		Orgao Emissor
		DA4->DA4_RGEST	:= AllTrim(MOTO->ESTADO_RG) //C	2		Estado do RG
		DA4->DA4_RGDT	:= MOTO->(DATA_EMISS) //D	8		Data da Emissาo do RG    			
      /*
		DA4->DA4_CORPEL	:= "" //C	2		Cor Pele
		DA4->DA4_DESPEL	:= "" //C	30		Des.Cor Pele
		DA4->DA4_CORCAB	:= "" //C	2		Cor Cabelo
		DA4->DA4_DESCAB	:= "" //C	30		Des.Cor Cabelo
		DA4->DA4_CORBAR	:= "" //C	2		Cor Barba
		DA4->DA4_DESBAR	:= "" //C	30		Des.Cor Barba
		DA4->DA4_COROLH	:= "" //C	2		Cor Olho
		DA4->DA4_DESOLH	:= "" //C	30		Des.Cor Olho
		DA4->DA4_SINAIS	:= "" //C	30		Sinais
		DA4->DA4_ALTURA	:= "" //N	5	2	Altura
		DA4->DA4_PESO		:= "" //N	7	3	Peso
		DA4->DA4_DATNAS	:= CTOD("//") //D	8		Data de Nascimento
		DA4->DA4_ESTCIV	:= "" //C	2		Estado Civil
		DA4->DA4_NUMSEG	:= "" //C	10		No.Segurado
		DA4->DA4_LIBSEG	:= "" //C	10		No.Liberacao Seguro
		DA4->DA4_VALSEG	:= "" //N	14	2	Val.Segurado
		DA4->DA4_CARPER	:= "" //C	1		Carga Perigosa
		DA4->DA4_BLQMOT	:= "" //C	1		Bloqueado
		DA4->DA4_COMISS	:= "" //C	1		Motorista Comissionado ?
		DA4->DA4_BITMAP	:= "" //C	8		Foto do Motorista
		*/

	DA4->(MSUnLock())

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Leitura da proxima linha do arquivo texto.                          ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    //nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
    
	dbSelectArea("MOTO")
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
