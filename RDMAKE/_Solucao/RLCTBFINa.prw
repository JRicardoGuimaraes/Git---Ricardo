#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

///////////////////////////////////////////////////////////////////////////////
// Programa:  RLCTBFIN                                      Data: 02/05/2011 //
// Descricao: Gera comparativo dos movimentos do financeiro com o contabil   //
// Autor:     +Soluções Consultoria                                          //
///////////////////////////////////////////////////////////////////////////////

// monta arquivo temporario
If MV_PAR01 == 1 // receber
	If MV_PAR02 == 1 .Or. MV_PAR02 == 3 // emissao
		Processa({||fTrbCrEm()},"Montando arquivo temporario...")
		Processa({||fTRBCRINV()},"Montando arquivo de Invoice...")		
	Endif
	If MV_PAR02 == 2 .Or. MV_PAR02 == 3 // baixa
		Processa({||fTrbCrBx()},"Montando arquivo temporario...")		
	Endif
	Processa({||fTrbCrOri()},"Processando diferencas do financeiro...")
ELSE	
	If MV_PAR02 == 1 .Or. MV_PAR02 == 3 // emissao
		Processa({||U_fPgEm()},"Montando arquivo temporario...")
	Endif
	If MV_PAR02 == 2 .Or. MV_PAR02 == 3 // baixa
		Processa({||U_fPgBx()},"Montando arquivo temporario...")		
	Endif	
Endif
// monta o arquivo de resumo
Processa({||fTrbResumo()},"Atualizando Resumo diário...")

// atualiza hora final
_vHrFim := {time(),seconds()}

// geracao da planilha
If MV_PAR08 == 2
	
	// define o nome do arquivo
	_cScript := _cDrive+"SigaExcel\Scripts\"+StrTran(AllTrim(cUserName),"+","")+"_"+DTOS(dDataBase)+"_"+StrTran(time(),":","")+".txt"
	If File(_cScript); fErase(_cScript); Endif
	_nHandle := FCreate(_cScript,0)
	If _nHandle == -1 .Or. !File(_cScript)
		MsgAlert("Arquivo [" + _cScript + "] nao pode ser criado corretamente. Verifique!")
	Else
		
		// gera o arquivo em excel
		Processa({|| fScript()},"Gerando Script para Excel...")
		
		// define nome do arquivo
		MontaDir(_cDrive+"SigaExcel\Planilhas")
		cPlan := _cDrive+"SigaExcel\Planilhas\Analise - Carteira ("
		cPlan += IIF(MV_PAR01==1,"Rec",IIF(MV_PAR01==2,"Pag","Ambas"))
		cPlan += ") Tipo ("
		cPlan += IIF(MV_PAR02==1,"Emissao",IIF(MV_PAR02==2,"Baixa","Ambas"))
		If MV_PAR04 <> MV_PAR05
			cPlan += ") Periodo ("
			cPlan += StrTran(DTOC(MV_PAR04),"/","-")+" A "+StrTran(DTOC(MV_PAR05),"/","-")
		Else
			cPlan += ") Data ("
			cPlan += StrTran(DTOC(MV_PAR04),"/","-")
		Endif
		cPlan += ").xls"
		
		// exclui o arquivo caso exista
		If File(cPlan)
			If MsgYesNo("Confirma exclusão do arquivo [" + cPlan + "] ?")
				fErase(cPlan)
			Endif
		Endif
		
		// inclui no script do excel
		_xLin := "GravaArquivo|"+cPlan+"|"; fGrvLinha(_xLin,.F.)
		
		// fecha o arquivo criado
		fClose(_nHandle)
		
		// chama rotina do Excel
		If !Empty(_cScript)
			WaitRun(_cDrive+"sigaExcel\rezende.Exe "+_cScript)
			//fErase(_cScript)
		Else
			MsgAlert("Problema na geracao do arquivo de script...")
		Endif
	Endif
	
Endif

// geracao em relatorio
If MV_PAR08 == 1
	// Monta a interface padrao com o usuario...
	dbSelectArea("CT1")
	dbSetOrder(1)
	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
	If nLastKey == 27
		Return
	Endif
	SetDefault(aReturn,cString)
	If nLastKey == 27
		Return
	Endif
	nTipo := If(aReturn[4]==1,15,18)
	// Processamento. RPTSTATUS monta janela com a regua de processamento
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Endif

// fecha e exclui arquivo temporario
DbSelectArea("TRB")
TRB->(DbCloseArea())
fErase(_cNomArq)
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

// SETREGUA -> Indica quantos registros serao processados para a regua ³
DbSelectArea("TRB")
SetRegua(TRB->(RecCount()))
dbGoTop()
While !TRB->(EOF())
	
	// Verifica o cancelamento pelo usuario...
	IncRegua()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	// Impressao do cabecalho do relatorio...
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	// totalizacao
	_aTotal[1] += TRB->F_VALOR
	_aTotal[2] += TRB->K_VALOR
	_aTotal[3] += TRB->C_VALOR
	_aTotal[4] += TRB->D_VALOR
	
	// totalizacao das diferencas
	If TRB->D_VALOR <> 0
		_aTotDif[1] += TRB->F_VALOR
		_aTotDif[2] += TRB->K_VALOR
		_aTotDif[3] += TRB->C_VALOR
		_aTotDif[4] += TRB->D_VALOR
	Endif
	
	// verifica se imprime tudo ou somente diferencas
	If MV_PAR03 == 1
		If TRB->D_VALOR == 0
			TRB->(DbSkip())
			Loop
		Endif
	Endif
	
	// layout de impressao
	/*
	.         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19
	01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	***************************** FINANCEIRO **************************** ************************************************** CONTABILIDADE **************************************************          VALOR
	ORIGEM DOCUMENTO             CLIENTE   CONTA  DATA              VALOR CTK-DATA CTK-CTA        CTK-VLR CTK-LP CTK-ROT CT2-DATA CT2-DOCUMENTO         CT2-CTA        CT2-VLR CT2-LP CT2-ROT      DIFERENÇA
	XXX    XXX-XXXXXXXXX-XXX-XXX XXXXXX-XX XXXXXX XX/XX/XX XXX,XXX,XXX.99 XX/XX/XX XXXXXX  XXX,XXX,XXX.99 999-99 XXXXXXX XX/XX/XX XXXXXX-XXX-XXXXXX-XXX XXXXXX  XXX,XXX,XXX.99 999-99 XXXXXXX XXX,XXX,XXX.99
	*/
	
	// dados financeiros
	@ nLin,000 PSay TRB->F_ORIGEM
	@ nLin,007 PSay TRB->F_DOCUME
	@ nLin,029 PSay TRB->F_CLIENT
	@ nLin,039 PSay TRB->F_CONTA
	@ nLin,046 PSay TRB->F_DATA
	@ nLin,055 PSay TRB->F_VALOR Picture "@E 999,999,999.99"
	
	// dados contabil - contra prova
	@ nLin,070 PSay TRB->K_DATA
	@ nLin,079 PSay TRB->K_CONTA
	@ nLin,087 PSay TRB->K_VALOR Picture "@E 999,999,999.99"
	@ nLin,102 PSay TRB->K_LP
	@ nLin,109 PSay TRB->K_ROT
	
	// dados contabil - lancamentos
	@ nLin,117 PSay TRB->C_DATA
	@ nLin,126 PSay TRB->C_DOCUME
	@ nLin,148 PSay TRB->C_CONTA
	@ nLin,156 PSay TRB->C_VALOR Picture "@E 999,999,999.99"
	@ nLin,171 PSay TRB->C_LP
	@ nLin,178 PSay TRB->C_ROT
	
	// diferenca
	@ nLin,186 PSay TRB->D_VALOR Picture "@E 999,999,999.99"
	@ nLin,201 PSay TRB->D_OBS
	
	// proxima linha
	nLin += 1
	TRB->(dbSkip())
End

// totaliza diferencas
nLin += 1
@ nLin,000 PSay Replicate("-",220)
nLin += 1
@ nLin,000 PSay "TOTAL SOMENTE DAS DIFERENÇAS"
@ nLin,055 PSay _aTotDIF[1] Picture "@E 999,999,999.99"
@ nLin,087 PSay _aTotDIF[2] Picture "@E 999,999,999.99"
@ nLin,146 PSay _aTotDIF[3] Picture "@E 999,999,999.99"
@ nLin,176 PSay _aTotDIF[4] Picture "@E 999,999,999.99"

// total geral
nLin += 1
@ nLin,000 PSay Replicate("=",220)
nLin += 1
@ nLin,000 PSay "TOTAL GERAL"
@ nLin,055 PSay _aTotal[1] Picture "@E 999,999,999.99"
@ nLin,087 PSay _aTotal[2] Picture "@E 999,999,999.99"
@ nLin,146 PSay _aTotal[3] Picture "@E 999,999,999.99"
@ nLin,176 PSay _aTotal[4] Picture "@E 999,999,999.99"

// resumo por dia
Cabec1 := "RESUMO POR DIA"
Cabec2 := ""
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 9

/*
.         1         2         3         4         5         6         7         8         9        10        11
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
+---------------------------------+---------------------------------+---------------------------------+
| ********** FINANCEIRO ********* | ******** CONTABILIDADE ******** | ********** DIFERENÇAS ********* |
+----------+----------------+----------------+----------------+----------------+----------------+----------------+
| DATA     |         DEBITO |        CREDITO |         DEBITO |        CREDITO |         DEBITO |        CREDITO |
+----------+----------------+----------------+----------------+----------------+----------------+----------------+
| 99/99/99 | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 |
.         1         2         3         4         5         6         7         8         9        10        11
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*/

@ nLin,000 PSay "           +---------------------------------+---------------------------------+---------------------------------+"; nLin += 1
@ nLin,000 PSay "           | ********** FINANCEIRO ********* | ******** CONTABILIDADE ******** | ********** DIFERENÇAS ********* |"; nLin += 1
@ nLin,000 PSay "+----------+----------------+----------------+----------------+----------------+----------------+----------------+"; nLin += 1
@ nLin,000 PSay "| DATA     |         DEBITO |        CREDITO |         DEBITO |        CREDITO |         DEBITO |        CREDITO |"; nLin += 1
@ nLin,000 PSay "+----------+----------------+----------------+----------------+----------------+----------------+----------------+"; nLin += 1
For nR := 1 To Len(_aResumo)
	@ nLin,000 PSay "|"
	@ nLin,002 PSay _aResumo[nR,1]
	@ nLin,011 PSay "|"
	@ nLin,013 PSay _aResumo[nR,2] Picture "@E 999,999,999.99"
	@ nLin,028 PSay "|"
	@ nLin,030 PSay _aResumo[nR,3] Picture "@E 999,999,999.99"
	@ nLin,045 PSay "|"
	@ nLin,047 PSay _aResumo[nR,4] Picture "@E 999,999,999.99"
	@ nLin,062 PSay "|"
	@ nLin,064 PSay _aResumo[nR,5] Picture "@E 999,999,999.99"
	@ nLin,079 PSay "|"
	@ nLin,081 PSay _aResumo[nR,6] Picture "@E 999,999,999.99"
	@ nLin,096 PSay "|"
	@ nLin,098 PSay _aResumo[nR,7] Picture "@E 999,999,999.99"
	@ nLin,113 PSay "|"
	nLin += 1
	@ nLin,000 PSay "+----------+----------------+----------------+----------------+----------------+----------------+----------------+"
	nLin += 1
Next

// Finaliza a execucao do relatorio...
Roda(cbCont,cbTxt,Tamanho)
SET DEVICE TO SCREEN

// Se impressao em disco, chama o gerenciador de impressao...
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function CriaSX1
// declaracao de variaveis
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
// define perguntas
aRegs :={}
aAdd(aRegs,{cPerg,"01","Carteira?"     ,"","","mv_ch1","N",1,0,0,"C","","mv_par01","Receber"   ,"","","","","Pagar"    ,"","","","",""     ,"","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Tipo Analise?" ,"","","mv_ch2","N",1,0,0,"C","","mv_par02","Emissao"   ,"","","","","Baixa"    ,"","","","","Ambas","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Listagem?"     ,"","","mv_ch3","N",1,0,0,"C","","mv_par03","Diferenças","","","","","Movimento","","","","",""     ,"","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data de?"      ,"","","mv_ch4","D",8,0,0,"G","","mv_par04",""          ,"","","","",""         ,"","","","",""     ,"","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Data ate?"     ,"","","mv_ch5","D",8,0,0,"G","","mv_par05",""          ,"","","","",""         ,"","","","",""     ,"","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Cli/For de?"   ,"","","mv_ch6","C",6,0,0,"G","","mv_par06",""          ,"","","","",""         ,"","","","",""     ,"","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Cli/For ate?"  ,"","","mv_ch7","C",6,0,0,"G","","mv_par07",""          ,"","","","",""         ,"","","","",""     ,"","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Saida Via?"    ,"","","mv_ch8","N",1,0,0,"C","","mv_par08","Relatorio" ,"","","","","Planilha" ,"","","","",""     ,"","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Emite Faturas?","","","mv_ch8","N",1,0,0,"C","","mv_par09","Sim"       ,"","","","","Nao"      ,"","","","",""     ,"","","","","","","","","","","","","","","","","","",""})
// cria perguntas no dicionario
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
// retorna
dbSelectArea(_sAlias)
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function rfRecCount(_cAlias)
Local _nReg := 0
DbSelectArea(_cAlias)
DbGoTop()
While !EOF()
	_nReg += 1
	DbSkip()
End
DbGoTop()
Return(_nReg)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Clientes / Emissao

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Clientes / Emissao
Static Function fTrbCrBx()

// declaracao de variaveis
Local nRegAtu := 0
Local nRegTot := 0
Local nRegCtk := 0
Local cQrySE5
Local cQrySF2
Local cQryCTK
Local cQryCT2
Local aRegCt2 := {}

// regua processamento
ProcRegua(3)

// busca baixados no mes
cQrySE5 := "SELECT E5_DTDIGIT, E5_DATA, E5_CLIFOR, E5_LOJA, E5_SITUACA, E5_TIPODOC, E5_RECPAG, E5_FILIAL, "
cQrySE5 += "       E5_NUMERO, E5_PREFIXO, E5_PARCELA, E5_TIPO, E5_VALOR, E5_MOEDA, E5_MOTBX, R_E_C_N_O_,"
cQrySE5 += "       E5_VLCORRE, E5_VLMULTA, E5_VLJUROS, E5_VLDESCO, E5_FATURA, E5_FATPREF"
cQrySE5 += " FROM " + RetSqlName("SE5")
cQrySE5 += " WHERE D_E_L_E_T_ <> '*' AND"
cQrySE5 += "       E5_DTDIGIT BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "' AND"
cQrySE5 += "       E5_CLIFOR  BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "' AND"
cQrySE5 += "       E5_SITUACA    <> 'C' AND"
cQrySE5 += "       E5_SITUACA    <> 'X' AND"
cQrySE5 += "       E5_TIPODOC IN ('VL','VM','BA','CP','LJ','V2','ES') AND"
cQrySE5 += "     ((E5_RECPAG  = 'R'  AND E5_TIPODOC <> 'ES') OR"
cQrySE5 += "      (E5_TIPODOC IN('ES','NCC') AND E5_RECPAG = 'P'))"
IncProc("1/2 Receber/Baixa [ Executando consulta ]")
TCQUERY cQrySE5 NEW ALIAS "TSE5"
IncProc("1/2 Receber/Baixa [ Verificando Registros ]")
nRegTot := rfRecCount("TSE5")
nInicio := Seconds()
ProcRegua(nRegTot)
While !TSE5->(EOF())
	
	// mensagem processamento
	cTempo  := fTempo(nInicio,nRegAtu,nRegTot)
	nRegAtu += 1
	nPerc   := Round((nRegAtu*100)/nRegTot,0)
	IncProc("1/2 Receber/Baixa [ " + AllTrim(TransForm(nRegAtu,"@E 999,999,999")) + " de " + AllTrim(TransForm(nRegTot,"@E 999,999,999")) + " ] " + AllTrim(Str(nPerc)) + "% - " + cTempo)
	
	// nao considera titulos de credito de fornecedor que estao como R
	If AllTrim(TSE5->E5_TIPO) $ MVPAGANT+"/"+MVABATIM+"/"+MV_CPNEG
		TSE5->(DbSkip())
		Loop
	Endif
	
	// busca variacoes cambiais do mesmo titulo
	_cQrySE5 := "SELECT SUM(E5_VALOR) AS E5_VALOR FROM " + RetSqlName("SE5")
	_cQrySE5 += "    WHERE D_E_L_E_T_ <> '*' AND"
	_cQrySE5 += "          E5_DATA     < '" + TSE5->E5_DATA    + "' AND"
	_cQrySE5 += "          E5_TIPODOC  = 'VM' AND"
	_cQrySE5 += "          E5_FILIAL   = '" + TSE5->E5_FILIAL  + "' AND"
	_cQrySE5 += "          E5_PREFIXO  = '" + TSE5->E5_PREFIXO + "' AND"
	_cQrySE5 += "          E5_NUMERO   = '" + TSE5->E5_NUMERO  + "' AND"
	_cQrySE5 += "          E5_PARCELA  = '" + TSE5->E5_PARCELA + "' AND"
	_cQrySE5 += "          E5_TIPO     = '" + TSE5->E5_TIPO    + "' AND"
	_cQrySE5 += "          E5_CLIFOR   = '" + TSE5->E5_CLIFOR  + "' AND"
	_cQrySE5 += "          E5_LOJA     = '" + TSE5->E5_LOJA    + "'"
	TCQUERY _cQrySE5 NEW ALIAS "WSE5"
	_nFinCor := WSE5->E5_VALOR
	WSE5->(DbCloseArea())
	
	// define o tipo de movimento
	If TSE5->E5_RECPAG == "R"
		_nFinVlr := TSE5->E5_VALOR
		_nFinOut := TSE5->E5_VLMULTA+TSE5->E5_VLJUROS+TSE5->E5_VLCORRE-TSE5->E5_VLDESCO+_nFinCor
		_nFinVlr -= _nFinOut
		_xTipCta := "_CREDIT"
	Else
		_nFinVlr := TSE5->E5_VALOR * (-1)
		_nFinOut := (TSE5->E5_VLMULTA+TSE5->E5_VLJUROS+TSE5->E5_VLCORRE-TSE5->E5_VLDESCO+_nFinCor) * (-1)
		_nFinVlr -= _nFinOut
		_xTipCta := "_DEBITO"
	Endif
	
	// define numero da fatura
	_cFinFat := ""
	If TSE5->E5_MOTBX == "FAT"
		_cFinFat := TSE5->E5_FATPREF+"-"+TSE5->E5_FATURA
		_nFinVlr := _nFinVlr * (-1)
	Endif
	If !Empty(_cFinFat) .And. MV_PAR09 == 2
		TSE5->(DbSkip())
		Loop
	Endif
	
	// inicia variaveis
	_cFinTab := "SE5"
	_nRegOri := TSE5->R_E_C_N_O_
	_cFinDoc := TSE5->E5_FILIAL+"-"+TSE5->E5_PREFIXO+"-"+TSE5->E5_NUMERO+"-"+TSE5->E5_PARCELA+"-"+TSE5->E5_TIPO
	_cFinCli := TSE5->E5_CLIFOR+"/"+TSE5->E5_LOJA
	_dFinDat := STOD(TSE5->E5_DTDIGIT)
	_cFinCta := ""
	
	// atualiza quadro de resumo
	_nResumo := 0
	For _nR := 1 To Len(_aResumo)
		If _aResumo[_nR,1] == _dFinDat
			_nResumo := _nR
		Endif
	Next
	If _nResumo <= 0
		AADD(_aResumo,{_dFinDat,0,0,0,0,0,0})
		_nResumo := Len(_aResumo)
	Endif
	_aResumo[_nResumo,3] += _nFinVlr
	
	// posiciona no cadastro de clientes
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+TSE5->E5_CLIFOR+TSE5->E5_LOJA)
		_cFinCta := SA1->A1_CONTA
	Endif
	If !Empty(_cFinCta)
		If ASCAN(_aContas,_cFinCta) <= 0
			AADD(_aContas,_cFinCta)
		Endif
	Endif
	
	// busca registro no CTK
	cQryCTK := "SELECT CTK_DEBITO, CTK_CREDIT, CTK_VLR01, CTK_ORIGEM, CTK_DATA, CTK_RECDES, CTK_LP, CTK_LPSEQ, CTK_ROTINA"
	cQryCTK += "  FROM " + RetSqlName("CTK")
	cQryCTK += "  WHERE D_E_L_E_T_ <> '*' AND"
	cQryCTK += "        CTK_TABORI = '" + _cFinTab + "' AND"
	cQryCTK += "        CTK_RECORI =  " + AllTrim(Str(_nRegOri)) + " AND"
	cQryCTK += "        CTK"+_xTipCta+" = '" + _cFinCta + "'"
	//MsgAlert("1/2 Receber/Emissão [ Query CTK ] " + cQryCTK)
	TCQUERY cQryCTK NEW ALIAS "TCTK"
	nRegCtk := rfRecCount("TCTK")
	//MsgAlert("1/2 Receber/Emissão [ Query CTK depois ] " + AllTrim(Str(nRegCtk)))
	If nRegCtk <= 0
		// adiciona no arquivo temporario
		DbSelectArea("TRB")
		If RecLock("TRB",.T.)
			// financeiro
			F_ORIGEM := "B-"+_cFinTab
			F_DOCUME := _cFinDoc
			F_FATURA := _cFinFat
			F_CLIENT := _cFinCli
			F_DATA   := _dFinDat
			F_CONTA  := _cFinCta
			F_TOTAL  := _nFinVlr+_nFinOut
			F_OUTROS := _nFinOut
			F_VALOR  := _nFinVlr
			// diferenca
			D_VALOR  := _nFinVlr
			XVLR     := IIF(D_VALOR<0,D_VALOR*(-1),D_VALOR)
			X_INDICE := DTOS(_dFinDat)+" "+AllTrim(Str(XVLR))
			// fecha
			MsUnlock()
		Endif
	Else
		While !TCTK->(EOF())
			
			// zera varivaeis
			_dLanDat := CTOD("")
			_cLanDoc := ""
			_cLanCta := ""
			_nLanVlr := 0
			_cLanLan := ""
			_cLanRot := ""
			//MsgAlert("1/2 Receber/Emissão [ Posiciona CT2 ]")
			
			// busca lancamento na contabilidade
			DbSelectArea("CT2")
			DbGoTo(Val(TCTK->CTK_RECDES))
			If CT2->(RECNO()) == Val(TCTK->CTK_RECDES)
				_dLanDat := CT2->CT2_DATA
				_cLanDoc := CT2->CT2_LOTE+"-"+CT2->CT2_SBLOTE+"-"+CT2->CT2_DOC+"-"+CT2->CT2_LINHA
				_cLanCta := &("CT2->CT2"+_xTipCta)
				If "DEB" $ _xTipCta
					_nLanVlr := CT2->CT2_VALOR * (-1)
				Else
					_nLanVlr := CT2->CT2_VALOR
				Endif
				_cLanLan := CT2->CT2_ORIGEM
				_cLanRot := CT2->CT2_ROTINA
				AADD(aRegCT2,AllTrim(Str(Val(TCTK->CTK_RECDES))))
			Endif
			
			//MsgAlert("1/2 Receber/Emissão [ Grava TRB ]")
			
			// adiciona no arquivo temporario
			DbSelectArea("TRB")
			If RecLock("TRB",.T.)
				// financeiro
				F_ORIGEM := "B-"+_cFinTab
				F_DOCUME := _cFinDoc
				F_FATURA := _cFinFat
				F_CLIENT := _cFinCli
				F_DATA   := _dFinDat
				F_CONTA  := _cFinCta
				F_TOTAL  := _nFinVlr+_nFinOut
				F_OUTROS := _nFinOut
				F_VALOR  := _nFinVlr
				// contra prova
				K_DATA   := STOD(TCTK->CTK_DATA)
				K_CONTA  := &("TCTK->CTK"+_xTipCta)
				If "DEB" $ _xTipCta
					K_VALOR  := TCTK->CTK_VLR01 * (-1)
				Else
					K_VALOR  := TCTK->CTK_VLR01
				Endif
				K_LP     := TCTK->CTK_LP+"-"+TCTK->CTK_LPSEQ
				K_ROT    := TCTK->CTK_ROTINA
				// lancamento
				C_DATA   := _dLanDat
				C_DOCUME := _cLanDoc
				C_CONTA  := _cLanCta
				C_VALOR  := _nLanVlr
				C_LP     := _cLanLan
				C_ROT    := _cLanRot
				// diferenca
				D_VALOR  := _nFinVlr-_nLanVlr
				XVLR     := IIF(D_VALOR<0,D_VALOR*(-1),D_VALOR)
				X_INDICE := DTOS(_dFinDat)+" "+AllTrim(Str(XVLR))
				// fecha
				MsUnlock()
			Endif
			
			// proximo registro
			DbSelectArea("TCTK")
			TCTK->(DbSkip())
		End
	Endif
	TCTK->(DbCloseArea())
	
	// proximo registro
	DbSelectArea("TSE5")
	TSE5->(DbSkip())
End
TSE5->(DbCloseArea())

// efetua processamento de todos lançamentos manuais que nao foram contabilizados automaticamente
If MV_PAR06 <> MV_PAR07
	ProcRegua(3)
	cQryCT2 := "SELECT R_E_C_N_O_ "
	cQryCT2 += "   FROM " + RetSqlName("CT2")
	cQryCT2 += "   WHERE D_E_L_E_T_ <> '*' AND"
	cQryCT2 += "         CT2_TPSALD = '1'  AND"
	cQryCT2 += "         CT2_MOEDLC = '01' AND"
	cQryCT2 += "         CT2_CREDIT IN ("
	For nC := 1 To Len(_aContas)
		cQryCT2 += "'"+_aContas[nC]+"'"
		If nC < Len(_aContas)
			cQryCT2 += ","
		Else
			cQryCT2 += ") AND"
		Endif
	Next
	cQryCT2 += " CT2_DATA BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "'"
	IncProc("2/2 Receber/Baixa [ Executando consulta ]")
	TCQUERY cQryCT2 NEW ALIAS "TCT2"
	IncProc("2/2 Receber/Baixa [ Verificando Registros ]")
	nRegTot := rfRecCount("TCT2")
	nRegAtu := 0
	ProcRegua(nRegTot)
	nInicio := Seconds()
	While !TCT2->(EOF())
		
		// mensagem processamento
		cTempo  := fTempo(nInicio,nRegAtu,nRegTot)
		nRegAtu += 1
		nPerc   := Round((nRegAtu*100)/nRegTot,0)
		IncProc("2/2 Receber/Emissão [ " + AllTrim(TransForm(nRegAtu,"@E 999,999,999")) + " de " + AllTrim(TransForm(nRegTot,"@E 999,999,999")) + " ] " + AllTrim(Str(nPerc)) + "% - " + cTempo)
		
		// verifica se registro foi computado
		If ASCAN(aRegCT2,AllTrim(Str(TCT2->R_E_C_N_O_))) <= 0
			
			// posiciona no registro
			DbSelectArea("CT2")
			DbGoTo(TCT2->R_E_C_N_O_)
			
			// atualiza variaveis
			_dLanDat := CT2->CT2_DATA
			_cLanDoc := CT2->CT2_LOTE+"-"+CT2->CT2_SBLOTE+"-"+CT2->CT2_DOC+"-"+CT2->CT2_LINHA
			_cLanCta := CT2->CT2_CREDIT
			_nLanVlr := CT2->CT2_VALOR * (-1)
			_cLanLan := CT2->CT2_ORIGEM
			_cLanRot := CT2->CT2_ROTINA
			_cLanHis := CT2->CT2_HIST
			_cLanKey := CT2->CT2_KEY
			_nLanRec := CT2->(RECNO())

			// caso for reversao de correcao, busca lancamento
			_xTipCta := "CRE"
			_kLanDat := CTOD("")
			_kLanCta := ""
			_kLanVlr := 0
			_kLanTab := ""
			_kLanReg := ""
			_kLanRot := ""
			IF CT2->CT2_ROTINA $ "FINA110/FINA070" .AND. CT2->CT2_LP == "520"
				// busca CTK
				_cQryCTK := "SELECT CTK_TABORI, CTK_RECORI, CTK_DATA, CTK_VLR01, CTK_ROTINA, CTK_DEBITO, CTK_CREDIT"
				_cQryCTK += " FROM " + RetSqlName("CTK")
				_cQryCTK += " WHERE D_E_L_E_T_ <> '*' AND"
				_cQryCTK += "       CTK_RECDES = " + AllTrim(Str(CT2->(RECNO())))
				TCQUERY _cQryCTK NEW ALIAS "TCTK"
				_kLanDat := STOD(TCTK->CTK_DATA)
				_lLanCta := TCTK->CTK_CREDIT
				_kLanVlr := TCTK->CTK_VLR01
				_kLanTab := TCTK->CTK_TABORI
				_kLanReg := AllTrim(Str(TCTK->CTK_RECORI))
				_kLanRot := TCKT->CTK_ROTINA
				TCTK->(DbCloseArea())
			Endif
			
			_nFinVlr := 0
			
			// adiciona no arquivo temporario
			DbSelectArea("TRB")
			If RecLock("TRB",.T.)
				// conta prova
				K_DATA   := _kLanDat
				K_CONTA  := _kLanCta
				If "DEB" $ _xTipCta
					K_VALOR  := _kLanVlr
				Else
					K_VALOR  := _kLanVlr * (-1)
				Endif
				K_LP     := _kLanTab+"-"+_kLanReg
				K_ROT    := _kLanRot
				// lancamento
				C_DATA   := _dLanDat
				C_DOCUME := _cLanDoc
				C_CONTA  := _cLanCta
				C_VALOR  := _nLanVlr
				C_LP     := _cLanLan
				C_ROT    := _cLanRot
				// diferenca
				D_VALOR  := _nFinVlr-_nLanVlr
				XVLR     := IIF(D_VALOR<0,D_VALOR*(-1),D_VALOR)
				X_INDICE := DTOS(_dFinDat)+" "+AllTrim(Str(XVLR))
				D_OBS    := _cLanHis
				D_KEY	 := _cLanKey
				// fecha
				MsUnlock()
			Endif
			
		Endif
		
		// proximo registro
		DbSelectArea("TCT2")
		TCT2->(DbSkip())
	End
	TCT2->(DbCloseArea())
Endif

// retorna
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fTrbResumo
// define regua de processamento
ProcRegua(Len(_aResumo)*3)
// atualiza valores do resumo por dia via contabilidade
For _nR := 1 To Len(_aResumo)
	// valores de debito no contabil
	IncProc("Resumo Diario " + DTOC(_aResumo[_nR,1]) + " - Debito")
	cQryCT2 := "SELECT SUM(CT2_VALOR) AS DEBITO"
	cQryCT2 += "   FROM " + RetSqlName("CT2")
	cQryCT2 += "   WHERE D_E_L_E_T_ <> '*' AND"
	cQryCT2 += "         CT2_TPSALD = '1'  AND"
	cQryCT2 += "         CT2_MOEDLC = '01' AND"
	cQryCT2 += "         CT2_DEBITO IN ("
	For nC := 1 To Len(_aContas)
		cQryCT2 += "'"+_aContas[nC]+"'"
		If nC < Len(_aContas)
			cQryCT2 += ","
		Else
			cQryCT2 += ") AND"
		Endif
	Next
	cQryCT2 += " CT2_DATA = '" + DTOS(_aResumo[_nR,1]) + "'"
	TCQUERY cQryCT2 NEW ALIAS "TCT2"
	_aResumo[_nR,4] := TCT2->DEBITO
	TCT2->(DbCloseArea())
	// valores de credito no contabil
	IncProc("Resumo Diario " + DTOC(_aResumo[_nR,1]) + " - Credito")
	cQryCT2 := "SELECT SUM(CT2_VALOR) AS CREDITO"
	cQryCT2 += "   FROM " + RetSqlName("CT2")
	cQryCT2 += "   WHERE D_E_L_E_T_ <> '*' AND"
	cQryCT2 += "         CT2_TPSALD = '1'  AND"
	cQryCT2 += "         CT2_MOEDLC = '01' AND"
	cQryCT2 += "         CT2_CREDIT IN ("
	For nC := 1 To Len(_aContas)
		cQryCT2 += "'"+_aContas[nC]+"'"
		If nC < Len(_aContas)
			cQryCT2 += ","
		Else
			cQryCT2 += ") AND"
		Endif
	Next
	cQryCT2 += " CT2_DATA = '" + DTOS(_aResumo[_nR,1]) + "'"
	TCQUERY cQryCT2 NEW ALIAS "TCT2"
	_aResumo[_nR,5] := TCT2->CREDITO
	TCT2->(DbCloseArea())
	// atualiza valores das diferencas
	IncProc("Resumo Diario " + DTOC(_aResumo[_nR,1]) + " - Diferenças" )
	_aResumo[_nR,6] := _aResumo[_nR,2]-_aResumo[_nR,4]
	_aResumo[_nR,7] := _aResumo[_nR,3]-_aResumo[_nR,5]
Next

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fScript()

// declaracao de variaveis
Private _aColunas := {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP","AQ","AR","AS","AT","AU","AV","AW","AX","AY","AZ"}
Private _nCol     := "000"

// abre o excel
_xLin := "AbreExcel|"; fGrvLinha(_xLin,.F.)

// geracao de scritps
fSheet1() // planilha de parametros
fSheet2() // planilha comparativa
fSheet3() // planilha resumo
fSheet4() // planilha de comparativo de Invoice e Fat X Faturas
// retorna
Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fSheet1

// inicia planilha 1 - parametros
_xLin := "AdicionaSheet;4;"; fGrvLinha(_xLin,.F.)
_cSheet := "1"
_xLin   := "Escreve|01|01|£|"+_cSheet+"|Arial|05|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)

// defini cabeçalho
_xLin := "Escreve|007|02|SEQ|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|03|DESCRIÇÃO|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|04|CONTEUDO|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)

// processa perguntas
_nLin := "0008"
_nCol := "0002"
DbSelectArea("SX1")
DbSetOrder(1)
DbGoTop()
DbSeek(cPerg)
While !SX1->(EOF()) .And. SX1->X1_GRUPO == cPerg
	// define variavel
	_xResposta := &(SX1->X1_VAR01)
	If Type("_xResposta") == "N"
		_xResposta := AllTrim(Str(_xResposta))
	Endif
	If Type("_xResposta") == "D"
		_xResposta := DTOC(_xResposta)
	Endif
	// caso for combo
	If SX1->X1_GSC == "C"
		_aCombo := {}
		AADD(_aCombo,SX1->X1_DEF01)
		AADD(_aCombo,SX1->X1_DEF02)
		AADD(_aCombo,SX1->X1_DEF03)
		AADD(_aCombo,SX1->X1_DEF04)
		AADD(_aCombo,SX1->X1_DEF05)
		_xResposta := _aCombo[Val(_xResposta)]
	Endif
	// emite dados
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|'"+UPPER(SX1->X1_VAR01)+"|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|'"+SX1->X1_PERGUNT+"|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|'"+_xResposta+"|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.T.)
	// proximo registro
	SX1->(DbSkip())
	_nCol := "0002"
	_nLin := Soma1(_nLin)
End

// calcula tempo da execucao total
yTm := _vHrFim[2]-_vHrIni[2]
xHr := Int(yTm/3600)
yHr := yTm-(xHr*3600)
xMn := Int(yHr/60)
yMn := yTm-(xHr*3600)-(xMn*60)
xTempo := StrZero(xHr,2)+":"+StrZero(xMn,2)+":"+StrZero(yMn,2)

// hora do inicial/final e tempo de execucao
_nLin := Soma1(_nLin)
_xLin := "Escreve|"+_nLin+"|02|Hora Inicio|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|"+_nLin+"|03|"+_vHrIni[1]+"|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.T.)
_nLin := Soma1(_nLin)
_xLin := "Escreve|"+_nLin+"|02|Hora Termino|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|"+_nLin+"|03|"+_vHrFim[1]+"|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.T.)
_nLin := Soma1(_nLin)
_xLin := "Escreve|"+_nLin+"|02|Tempo Execucao|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|"+_nLin+"|03|"+xTempo+"|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.T.)

// autoformata
_xLin := "AutoFormata|1|040|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)

// titulo
_xLin := "Escreve|02|02|"+SM0->M0_NOMECOM+"|"+_cSheet+"|Arial|15|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|03|02|Comparativo Financeiro x Contabil|" +_cSheet+"|Arial|15|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|04|02|Emissao: ["+ DTOC(dDataBase)+"]|"+_cSheet+"|Arial|10|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|05|02|Empresa: ["+ SM0->M0_CODIGO + " - " + AllTrim(SM0->M0_NOME) +"]|"+_cSheet+"|Arial|10|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)

// configura pagina
//_xLin := "ConfiguraPagina|P|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)
_xLin := "RenomeiaSheet|"+_cSheet+"|Parametros|"; fGrvLinha(_xLin,.F.)

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fSheet2

// inicia planilha 2 - comparativo
_cSheet := "2"
_xLin   := "Escreve|01|01|£|"+_cSheet+"|Arial|05|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
//_xLin   := "Escreve|"+_nLin+"|"+_nCol+"|'"+ _aDados[_Nx,1] +"|"+_cSheet+"|Arial|08|N|N|N|"+_xCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)

// cabecalho do resumo
_nCol := "002"
_xLin := "MergeCelulas|007|02|007|10|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|02|FINANCEIRO|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|03||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|04||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|05||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|06||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|07||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|08||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|09||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|10||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|001|11|.|"+_cSheet+"|Arial|05|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
_xLin := "MergeCelulas|007|12|007|16|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|12|CONTRA PROVA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|13||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|14||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|15||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|16||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|001|17|.|"+_cSheet+"|Arial|05|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
_xLin := "MergeCelulas|007|18|007|23|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|18|CONTABILIDADE|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|19||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|20||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|21||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|22||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|23||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|001|24|.|"+_cSheet+"|Arial|05|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|001|26|.|"+_cSheet+"|Arial|05|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)

// cabecalho complemento
_nCol := "002"
_xLin := "Escreve|008|"+_nCol+"|ORIGEM|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|DOCUMENTO|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|FATURA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|CLIENTE|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|CONTA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|DATA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|TOTAL|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|OUTROS|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|VALOR|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_nCol := Soma1(_nCol)
_xLin := "Escreve|008|"+_nCol+"|CTK-DATA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|CTK-CONTA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|CTK-VALOR|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|CTK-LP|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|CTK-ROTINA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_nCol := Soma1(_nCol)
_xLin := "Escreve|008|"+_nCol+"|CT2-DATA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|CT2-DOCUMENTO|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|CT2-CONTA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|CT2-VALOR|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|CT2-LP|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|CT2-ROTINA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_nCol := Soma1(_nCol)
_xLin := "Escreve|008|"+_nCol+"|DIFERENÇA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_nCol := Soma1(_nCol)
_xLin := "Escreve|008|"+_nCol+"|OBSERVAÇAO|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)

// define linha inicial
_nLin := "00009"
_nIni := _nLin
_nUlt := _nLin

// variaveis regua
nRegTot := TRB->(RecCount())
nRegAtu := 0

// SETREGUA -> Indica quantos registros serao processados para a regua ³
DbSelectArea("TRB")
ProcRegua(nRegTot)
dbGoTop()
nInicio := Seconds()
While !TRB->(EOF())
	
	// Verifica o cancelamento pelo usuario...
	cTempo  := fTempo(nInicio,nRegAtu,nRegTot)
	nRegAtu += 1
	nPerc   := Round((nRegAtu*100)/nRegTot,0)
	IncProc("Script Excel [ " + AllTrim(TransForm(nRegAtu,"@E 999,999,999")) + " de " + AllTrim(TransForm(nRegTot,"@E 999,999,999")) + " ] " + AllTrim(Str(nPerc)) + "% - " + cTempo)
	
	// verifica se imprime tudo ou somente diferencas
	If MV_PAR03 == 1
		If TRB->D_VALOR == 0
			TRB->(DbSkip())
			Loop
		Endif
	Endif
	
	// define a cor da linha
	If TRB->D_VALOR == 0
		_cCor := "10"
	Else
		If TRB->D_VALOR < 0.10 .And. TRB->D_VALOR > -0.10
			_cCor := "01"
		Else
			_cCor := "05"
		Endif
	Endif
	
	// coluna inicial
	_nCol := "002"
	
	// dados financeiros
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TRB->F_ORIGEM+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TRB->F_DOCUME+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TRB->F_FATURA+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TRB->F_CLIENT+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TRB->F_CONTA+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|'"+DTOC(TRB->F_DATA)+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(TRB->F_TOTAL))+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(TRB->F_OUTROS))+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(TRB->F_VALOR))+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	_nCol := Soma1(_nCol)
	
	// dados contabil - contra prova
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|'"+DTOC(TRB->K_DATA)+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TRB->K_CONTA+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(TRB->K_VALOR))+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TRB->K_LP+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TRB->K_ROT+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_nCol := Soma1(_nCol)
	
	// dados contabil - lancamentos
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|'"+DTOC(TRB->C_DATA)+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TRB->C_DOCUME+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TRB->C_CONTA+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(TRB->C_VALOR))+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TRB->C_LP+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TRB->C_ROT+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_nCol := Soma1(_nCol)
	
	// diferenca
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(TRB->D_VALOR))+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	_nCol := Soma1(_nCol)
	
	// observacao
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+StrTran(TRB->D_OBS,"|"," ")+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	
	// proxima linha
	_nLin := Soma1(_nLin)
	TRB->(dbSkip())
End

// autoformata
_xLin := "AutoFormata|1|040|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)

// titulo
_xLin := "Escreve|02|02|"+SM0->M0_NOMECOM+"|"+_cSheet+"|Arial|15|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|03|02|Comparativo Financeiro x Contabil|" +_cSheet+"|Arial|15|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|04|02|Emissao: ["+ DTOC(dDataBase)+"]|"+_cSheet+"|Arial|10|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|05|02|Empresa: ["+ SM0->M0_CODIGO + " - " + AllTrim(SM0->M0_NOME) +"]|"+_cSheet+"|Arial|10|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)

// configura pagina
//_xLin := "ConfiguraPagina|P|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)
_xLin := "RenomeiaSheet|"+_cSheet+"|Comparativo|"; fGrvLinha(_xLin,.F.)

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fSheet3

// inicia planilha 3 - resumo
_cSheet := "3"
_xLin   := "Escreve|01|01|£|"+_cSheet+"|Arial|05|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
//_xLin   := "Escreve|"+_nLin+"|"+_nCol+"|'"+ _aDados[_Nx,1] +"|"+_cSheet+"|Arial|08|N|N|N|"+_xCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)

// cabecalho do resumo
_xLin := "MergeCelulas|007|003|007|004|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|03|FINANCEIRO|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|04||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "MergeCelulas|007|005|007|006|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|05|CONTABILIDADE|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|06||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "MergeCelulas|007|007|007|008|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|07|DIFERENÇAS|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|08||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|008|02|DATA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|008|03|DEBITO|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|008|04|CREDITO|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|008|05|DEBITO|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|008|06|CREDITO|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|008|07|DEBITO|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|008|08|CREDITO|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)

// emite os dados do resumo na planilha
_nLin := "0009"
_nIni := _nLin
_nUlt := _nLin
For _nR := 1 To Len(_aResumo)
	
	// coluna inicial - data
	_nCol := "002"
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|'"+DTOC(_aResumo[_nR,1])+"|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.T.)
	
	// financeiro - debito
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(_aResumo[_nR,2]))+"|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	
	// financeiro - credito
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(_aResumo[_nR,3]))+"|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	
	// contabilidade - debito
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(_aResumo[_nR,4]))+"|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	
	// contabilidade - credito
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(_aResumo[_nR,5]))+"|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	
	// diferenças - debito
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(_aResumo[_nR,6]))+"|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	
	// diferenças - credito
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(_aResumo[_nR,7]))+"|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	
	// proxima linha
	_nUlt := _nLin
	_nLin := Soma1(_nLin)
Next

// total geral
If _nIni <> _nUlt
	_nCol := "002"
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|'TOTAL GERAL|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.T.)
	For _nT := 1 To 6
		_cTot := "=SOMA("+_aColunas[Val(_nCol)]+_nIni+":"+_aColunas[Val(_nCol)]+_nUlt+")"
		_xLin := "EscreveFormula|"+_nLin+"|"+_nCol+"|"+_cTot+"|"+_cSheet+"|Arial|08|N|N|N|10|N|10|02|"; fGrvLinha(_xLin,.F.)
		_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	Next
Endif

// autoformata
_xLin := "AutoFormata|1|040|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)

// titulo
_xLin := "Escreve|02|02|"+SM0->M0_NOMECOM+"|"+_cSheet+"|Arial|15|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|03|02|Comparativo Financeiro x Contabil|" +_cSheet+"|Arial|15|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|04|02|Emissao: ["+ DTOC(dDataBase)+"]|"+_cSheet+"|Arial|10|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|05|02|Empresa: ["+ SM0->M0_CODIGO + " - " + AllTrim(SM0->M0_NOME) +"]|"+_cSheet+"|Arial|10|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)

// configura pagina
//_xLin := "ConfiguraPagina|P|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)
_xLin := "RenomeiaSheet|"+_cSheet+"|Resumo|"; fGrvLinha(_xLin,.F.)

Return


Static Function fSheet4

// inicia planilha 2 - comparativo
_cSheet := "4"
_xLin   := "Escreve|01|01|£|"+_cSheet+"|Arial|05|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
//_xLin   := "Escreve|"+_nLin+"|"+_nCol+"|'"+ _aDados[_Nx,1] +"|"+_cSheet+"|Arial|08|N|N|N|"+_xCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)

// cabecalho do resumo
_nCol := "002"
_xLin := "MergeCelulas|007|02|007|10|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|02|INVOICE|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|03||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|04||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|05||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|06||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|07||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|08||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|09||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|10||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|001|11|.|"+_cSheet+"|Arial|05|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
_xLin := "MergeCelulas|007|12|007|12|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|12|FATURAS|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|13||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|14||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|007|15||"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.F.)

// cabecalho complemento
_nCol := "002"
_xLin := "Escreve|008|"+_nCol+"|ORIGEM|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|DOCUMENTO|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|FATURA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|CLIENTE|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|CONTA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|DATA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|TOTAL|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|OUTROS|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|VALOR|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_nCol := Soma1(_nCol)
_xLin := "Escreve|008|"+_nCol+"|DATA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|FATURA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_xLin := "Escreve|008|"+_nCol+"|VALOR|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)
_nCol := Soma1(_nCol)
_xLin := "Escreve|008|"+_nCol+"|DIFERENÇA|"+_cSheet+"|Arial|08|S|N|N|10|N|10|15|"; fGrvLinha(_xLin,.T.)

// define linha inicial
_nLin := "00009"
_nIni := _nLin
_nUlt := _nLin

// variaveis regua
nRegTot := TINV->(RecCount())
nRegAtu := 0

// SETREGUA -> Indica quantos registros serao processados para a regua ³
DbSelectArea("TINV")
ProcRegua(nRegTot)
dbGoTop()
nInicio := Seconds()
While !TINV->(EOF())
	
	// Verifica o cancelamento pelo usuario...
	cTempo  := fTempo(nInicio,nRegAtu,nRegTot)
	nRegAtu += 1
	nPerc   := Round((nRegAtu*100)/nRegTot,0)
	IncProc("Script Excel [ " + AllTrim(TransForm(nRegAtu,"@E 999,999,999")) + " de " + AllTrim(TransForm(nRegTot,"@E 999,999,999")) + " ] " + AllTrim(Str(nPerc)) + "% - " + cTempo)
	
	// verifica se imprime tudo ou somente diferencas
	
	// define a cor da linha
	If TINV->C_VALOR == 0
		_cCor := "10"
	Else
		If TINV->C_VALOR < 0.10 .And. TINV->C_VALOR > -0.10
			_cCor := "01"
		Else
			_cCor := "05"
		Endif
	Endif
	
	// coluna inicial
	_nCol := "002"
	
	// dados financeiros
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TINV->A_ORIGEM+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TINV->A_DOCUME+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TINV->A_FATURA+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TINV->A_CLIENT+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TINV->A_CONTA+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|'"+DTOC(TINV->A_DATA)+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(TINV->A_TOTAL))+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(TINV->A_OUTROS))+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(TINV->A_VALOR))+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	_nCol := Soma1(_nCol)
	
	// dados contabil - contra prova
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|'"+DTOC(TINV->B_DATA)+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+TINV->A_FATURA+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.T.)
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(TINV->B_VALOR))+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	_nCol := Soma1(_nCol)
	
	
	// diferenca
	_xLin := "Escreve|"+_nLin+"|"+_nCol+"|"+AllTrim(Str(TINV->C_VALOR))+"|"+_cSheet+"|Arial|08|N|N|N|"+_cCor+"|N|10|02|"; fGrvLinha(_xLin,.F.)
	_xLin := "FormataNumeroCelula|"+_nLin+"|"+_nCol+"|12|2|"+_cSheet+"|"; fGrvLinha(_xLin,.T.)
	_nCol := Soma1(_nCol)	
	
	// proxima linha
	_nLin := Soma1(_nLin)
	TINV->(dbSkip())
End

// autoformata
_xLin := "AutoFormata|1|040|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)

// titulo
_xLin := "Escreve|03|02|Comparativo INV/FAT X Faturas|" +_cSheet+"|Arial|15|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|04|02|Emissao: ["+ DTOC(dDataBase)+"]|"+_cSheet+"|Arial|10|S|N|N|10|N|"; fGrvLinha(_xLin,.F.)

// configura pagina
//_xLin := "ConfiguraPagina|P|"+_cSheet+"|"; fGrvLinha(_xLin,.F.)
_xLin := "RenomeiaSheet|"+_cSheet+"|INV X FAT|"; fGrvLinha(_xLin,.F.)

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fGrvLinha(_cLin,_lCol)
_cLin += (CHR(13)+CHR(10))
fWrite(_nHandle,_cLin,Len(_cLin))
If _lCol; _nCol := Soma1(_nCol); Endif
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fTempo(xInicio,xRegAtu,xRegTot)
Local xHr, xMn, xSg
Local xTempo := ""
Local xAtual := Seconds()
Local xGasto := xAtual-xInicio

If xRegAtu > 0
	// calcula tempo
	yTmpReg := xGasto/xRegAtu
	yTmpFal := (xRegTot-xRegAtu)*yTmpReg
	
	// calcula em horas
	xHr := Int(yTmpFal / 3600)
	yHr := yTmpFal-(xHr*3600)
	xMn := Int(yHr/60)
	yMn := yTmpFal-(xHr*3600)-(xMn*60)
	xTempo := StrZero(xHr,2)+"h"+StrZero(xMn,2)+"m" //+StrZero(yMn,2),5)
	
	// mensagem
	/*
	_cMsg := "Inicio " + AllTrim(TransForm(xInicio,"@E 999,999,999")) + Chr(13)
	_cMsg += "Atual  " + AllTrim(TransForm(xAtual ,"@E 999,999,999")) + Chr(13)
	_cMsg += "Gasto  " + AllTrim(TransForm(xGasto ,"@E 999,999,999")) + Chr(13)
	_cMsg += "----" + Chr(13)
	_cMsg += "Reg.Tot " + AllTrim(TransForm(xRegTot,"@E 999,999,999")) + Chr(13)
	_cMsg += "Reg.Atu " + AllTrim(TransForm(xRegAtu,"@E 999,999,999")) + Chr(13)
	_cMsg += "----" + Chr(13)
	_cMsg += "Tmp.Reg " + AllTrim(TransForm(yTmpReg,"@E 999,999,999")) + Chr(13)
	_cMsg += "Tmp.Fal " + AllTrim(TransForm(yTmpFal,"@E 999,999,999")) + Chr(13)
	_cMsg += "----" + Chr(13)
	_cMsg += "Retorno " + xTempo
	MsgAlert(_cMsg)
	*/
Endif

// retorna
Return(xTempo)

**************************************************************************************************************************************************
Static Function fTrbPgEm()

// declaracao de variaveis
Local nRegAtu := 0
Local nRegTot := 0
Local nRegCtk := 0
Local cQrySE2
Local cQrySF1
Local cQryCTK
Local cQryCT2
Local aRegCt2 := {}

// regua processamento
ProcRegua(3)

// busca titulos emitidos no mes
cQrySE2 := "SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_EMIS1, E2_VLCRUZ, E2_ORIGEM, R_E_C_N_O_,"
cQrySE2 += "       E2_HIST, E2_FATURA"
cQrySE2 += "   FROM " + RetSqlName("SE2")
cQrySE2 += "   WHERE D_E_L_E_T_ <> '*' AND"
cQrySE2 += "         E2_EMIS1   BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "' AND"
cQrySE2 += "         E2_FORNECE BETWEEN '" + MV_PAR06       + "' AND '" + MV_PAR07       + "'"
cQrySE2 += "   ORDER BY E2_EMIS1, E2_FORNECE, E2_LOJA, E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO"
IncProc("1/2 Pagar/Emissão [ Executando consulta ]")
TCQUERY cQrySE2 NEW ALIAS "TSE2"
IncProc("1/2 Pagar/Emissão [ Verificando Registros ]")
nRegTot := rfRecCount("TSE2")
nInicio := Seconds()
ProcRegua(nRegTot)
While !TSE2->(EOF())
	
	// mensagem processamento
	cTempo  := fTempo(nInicio,nRegAtu,nRegTot)
	nRegAtu += 1
	nPerc   := Round((nRegAtu*100)/nRegTot,0)
	IncProc("1/2 Pagar/Emissão [ " + AllTrim(TransForm(nRegAtu,"@E 999,999,999")) + " de " + AllTrim(TransForm(nRegTot,"@E 999,999,999")) + " ] " + AllTrim(Str(nPerc)) + "% - " + cTempo)
	
	// define o tipo do movimenot
	If TSE2->E2_TIPO $ MVRECANT+"/"+MVABATIM+"/"+MV_CRNEG+"/PIS#COF#CSL" //PIS/COF/CSL = PCC Baixa CR
		_nFinVlr := TSE2->E2_VLCRUZ * (-1)
		_nFinOut := 0
		_xTipCta := "_CREDIT"
	Else
		_nFinVlr := TSE2->E2_VLCRUZ
		_nFinOut := 0
		_xTipCta := "_DEBITO"
	Endif
	
	// filtra faturas
	If AllTrim(TSE2->E2_FATURA) == "NOTFAT" .And. MV_PAR09 == 2
		TSE2->(DbSkip())
		Loop
	Endif
	
	// inicia variaveis
	_cFinTab := "SE2"
	_nRegOri := TSE2->R_E_C_N_O_
	_cFinDoc := TSE2->E2_FILIAL+"-"+TSE2->E2_PREFIXO+"-"+TSE2->E2_NUM+"-"+TSE2->E2_PARCELA+"-"+TSE2->E2_TIPO
	_cFinCli := TSE2->E2_FORNECE+"/"+TSE2->E2_LOJA
	_dFinDat := STOD(TSE2->E2_EMIS1)
	_cFinCta := ""
	_cFinNum := AllTrim(TSE2->E2_NUM)
	_cFinFil := TSE2->E2_FILIAL
	_cFinHis := AllTrim(TSE2->E2_HIST)
	
	// atualiza quadro de resumo
	_nResumo := 0
	For _nR := 1 To Len(_aResumo)
		If _aResumo[_nR,1] == _dFinDat
			_nResumo := _nR
		Endif
	Next
	If _nResumo <= 0
		AADD(_aResumo,{_dFinDat,0,0,0,0,0,0})
		_nResumo := Len(_aResumo)
	Endif
	_aResumo[_nResumo,2] += _nFinVlr
	
	// posiciona no cadastro de clientes
	DbSelectArea("SA2")
	DbSetOrder(1)
	If DbSeek(xFilial("SA2")+TSE2->E2_FORNECE+TSE2->E2_LOJA)
		_cFinCta := SA2->A2_CONTA
	Else
		_cFinCta := "NAO DEFINIDA"
	Endif
	If !Empty(_cFinCta)
		If ASCAN(_aContas,_cFinCta) <= 0
			AADD(_aContas,_cFinCta)
		Endif
	Endif
	// busca titulo no faturamento
	If "MATA" $ TSE2->E2_ORIGEM
		DbSelectArea("SF1")
		DbSetOrder(1) // F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA
		If DbSeek(TSE2->E2_FILIAL+TSE2->E2_NUM+TSE2->E2_PREFIXO+TSE2->E2_FORNECE+TSE2->E2_LOJA)
			_cFinTab := "SF1"
			_nRegOri := SF1->(RECNO())
		Endif
	Endif
	
	// busca registro no CTK
	cQryCTK := "SELECT CTK_DEBITO, CTK_CREDIT, CTK_VLR01, CTK_ORIGEM, CTK_DATA, CTK_RECDES, CTK_LP, CTK_LPSEQ, CTK_ROTINA"
	cQryCTK += "  FROM " + RetSqlName("CTK")
	cQryCTK += "  WHERE D_E_L_E_T_ <> '*' AND"
	cQryCTK += "        CTK_TABORI = '" + _cFinTab + "' AND"
	cQryCTK += "        CTK_RECORI =  " + AllTrim(Str(_nRegOri)) + " AND"
	cQryCTK += "        CTK"+_xTipCta+" = '" + _cFinCta + "'"

	TCQUERY cQryCTK NEW ALIAS "TCTK"
	nRegCtk := rfRecCount("TCTK")

	If nRegCtk <= 0
		
		// busca valor no CT2 diretamente
		cQryCT2 := "SELECT R_E_C_N_O_ AS REG FROM " + RetSqlName("CT2")
		cQryCT2 += "   WHERE D_E_L_E_T_ <> '*' AND
		cQryCT2 += "         CT2_DATA  = '" + DTOS(_dFinDat) + "' AND"
		cQryCT2 += "         CT2_VALOR = " + AllTrim(Str(_nFinVlr)) + " AND"
		cQryCT2 += "         CT2_KEY LIKE '%" + AllTrim(_cFinNum) + "%' AND"
		cQryCT2 += "         CT2"+_xTipCta+" = '" + _cFinCta + "' AND"
		cQryCT2 += "         CT2_FILORI = '" + _cFinFil + "'"
		TCQUERY cQryCT2 NEW ALIAS "TCT2"
		nRegCT2 := TCT2->REG
		TCT2->(DbCloseArea())
		
		
		If nRegCT2 > 0
			
			// zera varivaeis
			_dLanDat := CTOD("")
			_cLanDoc := ""
			_cLanCta := ""
			_nLanVlr := 0
			_cLanLan := ""
			_cLanRot := ""
			
			// busca lancamento na contabilidade
			DbSelectArea("CT2")
			DbGoTo(nRegCT2)
			_dLanDat := CT2->CT2_DATA
			_cLanDoc := CT2->CT2_LOTE+"-"+CT2->CT2_SBLOTE+"-"+CT2->CT2_DOC+"-"+CT2->CT2_LINHA
			_cLanCta := &("CT2->CT2"+_xTipCta)
			If "DEB" $ _xTipCta
				_nLanVlr := CT2->CT2_VALOR
			Else
				_nLanVlr := CT2->CT2_VALOR * (-1)
			Endif
			_cLanLan := CT2->CT2_ORIGEM
			_cLanRot := CT2->CT2_ROTINA
			AADD(aRegCT2,AllTrim(Str(nRegCT2)))
			
			// adiciona no arquivo temporario
			DbSelectArea("TRB")
			If RecLock("TRB",.T.)
				// financeiro
				F_ORIGEM := "E-"+_cFinTab
				F_DOCUME := _cFinDoc
				F_CLIENT := _cFinCli
				F_DATA   := _dFinDat
				F_CONTA  := _cFinCta
				F_TOTAL  := _nFinVlr+_nFinOut
				F_OUTROS := _nFinOut
				F_VALOR  := _nFinVlr
				// lancamento
				C_DATA   := _dLanDat
				C_DOCUME := _cLanDoc
				C_CONTA  := _cLanCta
				C_VALOR  := _nLanVlr
				C_LP     := _cLanLan
				C_ROT    := _cLanRot
				// diferenca
				D_VALOR  := _nFinVlr-_nLanVlr
				XVLR     := IIF(D_VALOR<0,D_VALOR*(-1),D_VALOR)
				//X_INDICE := DTOS(_dFinDat)+" "+AllTrim(Str(XVLR))
				// fecha
				MsUnlock()
			Endif
			
		Else
			
			// adiciona no arquivo temporario
			DbSelectArea("TRB")
			If RecLock("TRB",.T.)
				// financeiro
				F_ORIGEM := "E-"+_cFinTab
				F_DOCUME := _cFinDoc
				F_CLIENT := _cFinCli
				F_DATA   := _dFinDat
				F_CONTA  := _cFinCta
				F_TOTAL  := _nFinVlr+_nFinOut
				F_OUTROS := _nFinOut
				F_VALOR  := _nFinVlr
				// diferenca
				D_VALOR  := _nFinVlr
				XVLR     := IIF(D_VALOR<0,D_VALOR*(-1),D_VALOR)
				X_INDICE := DTOS(_dFinDat)+" "+AllTrim(Str(XVLR))
				// fecha
				MsUnlock()
			Endif
		Endif
	Else
		While !TCTK->(EOF())
			
			// zera varivaeis
			_dLanDat := CTOD("")
			_cLanDoc := ""
			_cLanCta := ""
			_nLanVlr := 0
			_cLanLan := ""
			_cLanRot := ""
			//MsgAlert("1/2 Receber/Emissão [ Posiciona CT2 ]")
			
			// busca lancamento na contabilidade
			DbSelectArea("CT2")
			DbGoTo(Val(TCTK->CTK_RECDES))
			If CT2->(RECNO()) == Val(TCTK->CTK_RECDES)
				_dLanDat := CT2->CT2_DATA
				_cLanDoc := CT2->CT2_LOTE+"-"+CT2->CT2_SBLOTE+"-"+CT2->CT2_DOC+"-"+CT2->CT2_LINHA
				_cLanCta := &("CT2->CT2"+_xTipCta)
				If "DEB" $ _xTipCta
					_nLanVlr := CT2->CT2_VALOR
				Else
					_nLanVlr := CT2->CT2_VALOR * (-1)
				Endif
				_cLanLan := CT2->CT2_ORIGEM
				_cLanRot := CT2->CT2_ROTINA
				AADD(aRegCT2,AllTrim(Str(Val(TCTK->CTK_RECDES))))
			Endif
			
			//MsgAlert("1/2 Receber/Emissão [ Grava TRB ]")
			
			// adiciona no arquivo temporario
			DbSelectArea("TRB")
			If RecLock("TRB",.T.)
				// financeiro
				F_ORIGEM := "E-"+_cFinTab
				F_DOCUME := _cFinDoc
				F_CLIENT := _cFinCli
				F_DATA   := _dFinDat
				F_CONTA  := _cFinCta
				F_TOTAL  := _nFinVlr+_nFinOut
				F_OUTROS := _nFinOut
				F_VALOR  := _nFinVlr
				// contra prova
				K_DATA   := STOD(TCTK->CTK_DATA)
				K_CONTA  := &("TCTK->CTK"+_xTipCta)
				If "DEB" $ _xTipCta
					K_VALOR  := TCTK->CTK_VLR01
				Else
					K_VALOR  := TCTK->CTK_VLR01 * (-1)
				Endif
				K_LP     := TCTK->CTK_LP+"-"+TCTK->CTK_LPSEQ
				K_ROT    := TCTK->CTK_ROTINA
				// lancamento
				C_DATA   := _dLanDat
				C_DOCUME := _cLanDoc
				C_CONTA  := _cLanCta
				C_VALOR  := _nLanVlr
				C_LP     := _cLanLan
				C_ROT    := _cLanRot
				// diferenca
				D_VALOR  := _nFinVlr-_nLanVlr
				XVLR     := IIF(D_VALOR<0,D_VALOR*(-1),D_VALOR)
				//X_INDICE := DTOS(_dFinDat)+" "+AllTrim(Str(XVLR))
				// fecha
				MsUnlock()
			Endif
			
			// proximo registro
			DbSelectArea("TCTK")
			TCTK->(DbSkip())
		End
	Endif
	TCTK->(DbCloseArea())
	
	// proximo registro
	DbSelectArea("TSE2")
	TSE2->(DbSkip())
End
TSE2->(DbCloseArea())

// efetua processamento de todos lançamentos manuais que nao foram contabilizados automaticamente
If MV_PAR06 <> MV_PAR07
	ProcRegua(3)
	cQryCT2 := "SELECT R_E_C_N_O_ "
	cQryCT2 += "   FROM " + RetSqlName("CT2")
	cQryCT2 += "   WHERE D_E_L_E_T_ <> '*' AND"
	cQryCT2 += "         CT2_TPSALD = '1'  AND"
	cQryCT2 += "         CT2_MOEDLC = '01' AND"
	IF LEN(_aContas) <> 0
		cQryCT2 += "         CT2_DEBITO IN ("
		For nC := 1 To Len(_aContas)
			cQryCT2 += "'"+_aContas[nC]+"'"
			If nC < Len(_aContas)
				cQryCT2 += ","
			Else
				cQryCT2 += ") AND"
			Endif
		Next
	EndIF
	cQryCT2 += " CT2_DATA BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "'"
	IncProc("2/2 Pagar/Emissão [ Executando consulta ]")
	TCQUERY cQryCT2 NEW ALIAS "TCT2"
	IncProc("2/2 Pagar/Emissão [ Verificando Registros ]")
	nRegTot := rfRecCount("TCT2")
	nRegAtu := 0
	ProcRegua(nRegTot)
	nInicio := Seconds()
	While !TCT2->(EOF())
		
		// mensagem processamento
		cTempo  := fTempo(nInicio,nRegAtu,nRegTot)
		nRegAtu += 1
		nPerc   := Round((nRegAtu*100)/nRegTot,0)
		IncProc("2/2 Pagar/Emissão [ " + AllTrim(TransForm(nRegAtu,"@E 999,999,999")) + " de " + AllTrim(TransForm(nRegTot,"@E 999,999,999")) + " ] " + AllTrim(Str(nPerc)) + "% - " + cTempo)
		
		// verifica se registro foi computado
		If ASCAN(aRegCT2,AllTrim(Str(TCT2->R_E_C_N_O_))) <= 0
			
			// posiciona no registro
			DbSelectArea("CT2")
			DbGoTo(TCT2->R_E_C_N_O_)
			
			// atualiza variaveis
			_dLanDat := CT2->CT2_DATA
			_cLanDoc := CT2->CT2_LOTE+"-"+CT2->CT2_SBLOTE+"-"+CT2->CT2_DOC+"-"+CT2->CT2_LINHA
			_cLanCta := CT2->CT2_DEBITO
			_nLanVlr := CT2->CT2_VALOR
			_cLanLan := CT2->CT2_ORIGEM
			_cLanRot := CT2->CT2_ROTINA
			_cLanHis := CT2->CT2_HIST
			_cLanKey := CT2->CT2_KEY
			
			// caso for reversao de correcao, busca lancamento
			_xTipCta := "DEB"
			_kLanDat := CTOD("")
			_kLanCta := ""
			_kLanVlr := 0
			_kLanTab := ""
			_kLanReg := ""
			_kLanRot := ""
			IF CT2->CT2_ROTINA $ "FINA110/FINA070" .AND. CT2->CT2_LP == "530"
				// busca CTK
				_cQryCTK := "SELECT CTK_TABORI, CTK_RECORI, CTK_DATA, CTK_VLR01, CTK_ROTINA, CTK_DEBITO, CTK_CREDIT"
				_cQryCTK += " FROM " + RetSqlName("CTK")
				_cQryCTK += " WHERE D_E_L_E_T_ <> '*' AND"
				_cQryCTK += "       CTK_RECDES = " + AllTrim(Str(CT2->(RECNO())))
				TCQUERY _cQryCTK NEW ALIAS "TCTK"
				_kLanDat := STOD(TCTK->CTK_DATA)
				_kLanCta := TCTK->CTK_DEBITO
				_kLanVlr := TCTK->CTK_VLR01
				_kLanTab := TCTK->CTK_TABORI
				_kLanReg := AllTrim(Str(TCTK->CTK_RECORI))
				_kLanRot := TCKT->CTK_ROTINA
				TCTK->(DbCloseArea())
			Endif
			
			_nFinVlr := 0
			
			// adiciona no arquivo temporario
			DbSelectArea("TRB")
			If RecLock("TRB",.T.)
				// conta prova
				K_DATA   := _kLanDat
				K_CONTA  := _kLanCta
				If "DEB" $ _xTipCta
					K_VALOR  := _kLanVlr
				Else
					K_VALOR  := _kLanVlr * (-1)
				Endif
				K_LP     := _kLanTab+"-"+_kLanReg
				K_ROT    := _kLanRot
				// lancamento
				C_DATA   := _dLanDat
				C_DOCUME := _cLanDoc
				C_CONTA  := _cLanCta
				C_VALOR  := _nLanVlr
				C_LP     := _cLanLan
				C_ROT    := _cLanRot
				// diferenca
				D_VALOR  := _nFinVlr-_nLanVlr
				XVLR     := IIF(D_VALOR<0,D_VALOR*(-1),D_VALOR)
				//X_INDICE := DTOS(_dFinDat)+" "+AllTrim(Str(XVLR))
				D_OBS    := _cLanHis
				D_KEY	 := _cLanKey
				// fecha
				MsUnlock()
			Endif
			
		Endif
		
		// proximo registro
		DbSelectArea("TCT2")
		TCT2->(DbSkip())
	End
	TCT2->(DbCloseArea())
Endif

// retorna
Return

********************************************************************************************************************************************
// Clientes / Emissao
Static Function fTrbPGBx()

// declaracao de variaveis
Local nRegAtu := 0
Local nRegTot := 0
Local nRegCtk := 0
Local cQrySE5
Local cQrySF2
Local cQryCTK
Local cQryCT2
Local aRegCt2 := {}

// regua processamento
ProcRegua(3)

// busca baixados no mes
cQrySE5 := "SELECT E5_DTDIGIT, E5_DATA, E5_CLIFOR, E5_LOJA, E5_SITUACA, E5_TIPODOC, E5_RECPAG, E5_FILIAL, "
cQrySE5 += "       E5_NUMERO, E5_PREFIXO, E5_PARCELA, E5_TIPO, E5_VALOR, E5_MOEDA, E5_MOTBX, R_E_C_N_O_,"
cQrySE5 += "       E5_VLCORRE, E5_VLMULTA, E5_VLJUROS, E5_VLDESCO, E5_FATURA, E5_FATPREF"
cQrySE5 += " FROM " + RetSqlName("SE5")
cQrySE5 += " WHERE D_E_L_E_T_ <> '*' AND"
cQrySE5 += "       E5_DTDIGIT BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "' AND"
cQrySE5 += "       E5_CLIFOR  BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "' AND"
cQrySE5 += "       E5_SITUACA    <> 'C' AND"
cQrySE5 += "       E5_SITUACA    <> 'X' AND"
cQrySE5 += "       E5_TIPODOC IN ('VL','VM','BA','CP','LJ','V2','ES') AND"
cQrySE5 += "     ((E5_RECPAG  = 'P'  AND E5_TIPODOC <> 'ES') OR"
cQrySE5 += "      (E5_TIPODOC = 'ES' AND E5_RECPAG = 'R'))"
IncProc("1/2 Pagar/Baixa [ Executando consulta ]")
TCQUERY cQrySE5 NEW ALIAS "TSE5"
IncProc("1/2 Pagar/Baixa [ Verificando Registros ]")
nRegTot := rfRecCount("TSE5")
nInicio := Seconds()
ProcRegua(nRegTot)
While !TSE5->(EOF())
	
	// mensagem processamento
	cTempo  := fTempo(nInicio,nRegAtu,nRegTot)
	nRegAtu += 1
	nPerc   := Round((nRegAtu*100)/nRegTot,0)
	IncProc("1/2 Pagar/Baixa [ " + AllTrim(TransForm(nRegAtu,"@E 999,999,999")) + " de " + AllTrim(TransForm(nRegTot,"@E 999,999,999")) + " ] " + AllTrim(Str(nPerc)) + "% - " + cTempo)
	
	// nao considera titulos de credito de fornecedor que estao como R
	If AllTrim(TSE5->E5_TIPO) $ MVPAGANT+"/"+MVABATIM+"/"+MV_CPNEG
		TSE5->(DbSkip())
		Loop
	Endif
	
	// busca variacoes cambiais do mesmo titulo
	_cQrySE5 := "SELECT SUM(E5_VALOR) AS E5_VALOR FROM " + RetSqlName("SE5")
	_cQrySE5 += "    WHERE D_E_L_E_T_ <> '*' AND"
	_cQrySE5 += "          E5_DATA     < '" + TSE5->E5_DATA    + "' AND"
	_cQrySE5 += "          E5_TIPODOC  = 'VM' AND"
	_cQrySE5 += "          E5_FILIAL   = '" + TSE5->E5_FILIAL  + "' AND"
	_cQrySE5 += "          E5_PREFIXO  = '" + TSE5->E5_PREFIXO + "' AND"
	_cQrySE5 += "          E5_NUMERO   = '" + TSE5->E5_NUMERO  + "' AND"
	_cQrySE5 += "          E5_PARCELA  = '" + TSE5->E5_PARCELA + "' AND"
	_cQrySE5 += "          E5_TIPO     = '" + TSE5->E5_TIPO    + "' AND"
	_cQrySE5 += "          E5_CLIFOR   = '" + TSE5->E5_CLIFOR  + "' AND"
	_cQrySE5 += "          E5_LOJA     = '" + TSE5->E5_LOJA    + "'"
	TCQUERY _cQrySE5 NEW ALIAS "WSE5"
	_nFinCor := WSE5->E5_VALOR
	WSE5->(DbCloseArea())
	
	// define o tipo de movimento
	If TSE5->E5_RECPAG == "P"
		_nFinVlr := TSE5->E5_VALOR
		_nFinOut := TSE5->E5_VLMULTA+TSE5->E5_VLJUROS+TSE5->E5_VLCORRE-TSE5->E5_VLDESCO+_nFinCor
		_nFinVlr -= _nFinOut
		_xTipCta := "_CREDIT"
	Else
		_nFinVlr := TSE5->E5_VALOR * (-1)
		_nFinOut := (TSE5->E5_VLMULTA+TSE5->E5_VLJUROS+TSE5->E5_VLCORRE-TSE5->E5_VLDESCO+_nFinCor) * (-1)
		_nFinVlr -= _nFinOut
		_xTipCta := "_DEBITO"
	Endif
	
	// define numero da fatura
	_cFinFat := ""
	If TSE5->E5_MOTBX == "FAT"
		_cFinFat := TSE5->E5_FATPREF+"-"+TSE5->E5_FATURA
		_nFinVlr := _nFinVlr * (-1)
	Endif
	If !Empty(_cFinFat) .And. MV_PAR09 == 2
		TSE5->(DbSkip())
		Loop
	Endif
	
	// inicia variaveis
	_cFinTab := "SE5"
	_nRegOri := TSE5->R_E_C_N_O_
	_cFinDoc := TSE5->E5_FILIAL+"-"+TSE5->E5_PREFIXO+"-"+TSE5->E5_NUMERO+"-"+TSE5->E5_PARCELA+"-"+TSE5->E5_TIPO
	_cFinCli := TSE5->E5_CLIFOR+"/"+TSE5->E5_LOJA
	_dFinDat := STOD(TSE5->E5_DTDIGIT)
	_cFinCta := ""
	
	// atualiza quadro de resumo
	_nResumo := 0
	For _nR := 1 To Len(_aResumo)
		If _aResumo[_nR,1] == _dFinDat
			_nResumo := _nR
		Endif
	Next
	If _nResumo <= 0
		AADD(_aResumo,{_dFinDat,0,0,0,0,0,0})
		_nResumo := Len(_aResumo)
	Endif
	_aResumo[_nResumo,3] += _nFinVlr
	
	// posiciona no cadastro de fornecedores
	DbSelectArea("SA2")
	DbSetOrder(1)
	If DbSeek(xFilial("SA2")+TSE5->E5_CLIFOR+TSE5->E5_LOJA)
		_cFinCta := SA2->A2_CONTA
	Endif
	If !Empty(_cFinCta)
		If ASCAN(_aContas,_cFinCta) <= 0
			AADD(_aContas,_cFinCta)
		Endif
	Endif
	
	// busca registro no CTK
	cQryCTK := "SELECT CTK_DEBITO, CTK_CREDIT, CTK_VLR01, CTK_ORIGEM, CTK_DATA, CTK_RECDES, CTK_LP, CTK_LPSEQ, CTK_ROTINA"
	cQryCTK += "  FROM " + RetSqlName("CTK")
	cQryCTK += "  WHERE D_E_L_E_T_ <> '*' AND"
	cQryCTK += "        CTK_TABORI = '" + _cFinTab + "' AND"
	cQryCTK += "        CTK_RECORI =  " + AllTrim(Str(_nRegOri)) + " AND"
	cQryCTK += "        CTK"+_xTipCta+" = '" + _cFinCta + "'"
	//MsgAlert("1/2 Receber/Emissão [ Query CTK ] " + cQryCTK)
	TCQUERY cQryCTK NEW ALIAS "TCTK"
	nRegCtk := rfRecCount("TCTK")
	//MsgAlert("1/2 Receber/Emissão [ Query CTK depois ] " + AllTrim(Str(nRegCtk)))
	If nRegCtk <= 0
		// adiciona no arquivo temporario
		DbSelectArea("TRB")
		If RecLock("TRB",.T.)
			// financeiro
			F_ORIGEM := "B-"+_cFinTab
			F_DOCUME := _cFinDoc
			F_FATURA := _cFinFat
			F_CLIENT := _cFinCli
			F_DATA   := _dFinDat
			F_CONTA  := _cFinCta
			F_TOTAL  := _nFinVlr+_nFinOut
			F_OUTROS := _nFinOut
			F_VALOR  := _nFinVlr
			// diferenca
			D_VALOR  := _nFinVlr
			XVLR     := IIF(D_VALOR<0,D_VALOR*(-1),D_VALOR)
			//X_INDICE := DTOS(_dFinDat)+" "+AllTrim(Str(XVLR))
			// fecha
			MsUnlock()
		Endif
	Else
		While !TCTK->(EOF())
			
			// zera varivaeis
			_dLanDat := CTOD("")
			_cLanDoc := ""
			_cLanCta := ""
			_nLanVlr := 0
			_cLanLan := ""
			_cLanRot := ""
			//MsgAlert("1/2 Receber/Emissão [ Posiciona CT2 ]")
			
			// busca lancamento na contabilidade
			DbSelectArea("CT2")
			DbGoTo(Val(TCTK->CTK_RECDES))
			If CT2->(RECNO()) == Val(TCTK->CTK_RECDES)
				_dLanDat := CT2->CT2_DATA
				_cLanDoc := CT2->CT2_LOTE+"-"+CT2->CT2_SBLOTE+"-"+CT2->CT2_DOC+"-"+CT2->CT2_LINHA
				_cLanCta := &("CT2->CT2"+_xTipCta)
				If "DEB" $ _xTipCta
					_nLanVlr := CT2->CT2_VALOR * (-1)
				Else
					_nLanVlr := CT2->CT2_VALOR
				Endif
				_cLanLan := CT2->CT2_ORIGEM
				_cLanRot := CT2->CT2_ROTINA
				AADD(aRegCT2,AllTrim(Str(Val(TCTK->CTK_RECDES))))
			Endif
			
			//MsgAlert("1/2 Receber/Emissão [ Grava TRB ]")
			
			// adiciona no arquivo temporario
			DbSelectArea("TRB")
			If RecLock("TRB",.T.)
				// financeiro
				F_ORIGEM := "B-"+_cFinTab
				F_DOCUME := _cFinDoc
				F_FATURA := _cFinFat
				F_CLIENT := _cFinCli
				F_DATA   := _dFinDat
				F_CONTA  := _cFinCta
				F_TOTAL  := _nFinVlr+_nFinOut
				F_OUTROS := _nFinOut
				F_VALOR  := _nFinVlr
				// contra prova
				K_DATA   := STOD(TCTK->CTK_DATA)
				K_CONTA  := &("TCTK->CTK"+_xTipCta)
				If "DEB" $ _xTipCta
					K_VALOR  := TCTK->CTK_VLR01 * (-1)
				Else
					K_VALOR  := TCTK->CTK_VLR01
				Endif
				K_LP     := TCTK->CTK_LP+"-"+TCTK->CTK_LPSEQ
				K_ROT    := TCTK->CTK_ROTINA
				// lancamento
				C_DATA   := _dLanDat
				C_DOCUME := _cLanDoc
				C_CONTA  := _cLanCta
				C_VALOR  := _nLanVlr
				C_LP     := _cLanLan
				C_ROT    := _cLanRot
				// diferenca
				D_VALOR  := _nFinVlr-_nLanVlr
				XVLR     := IIF(D_VALOR<0,D_VALOR*(-1),D_VALOR)
				//X_INDICE := DTOS(_dFinDat)+" "+AllTrim(Str(XVLR))
				// fecha
				MsUnlock()
			Endif
			
			// proximo registro
			DbSelectArea("TCTK")
			TCTK->(DbSkip())
		End
	Endif
	TCTK->(DbCloseArea())
	
	// proximo registro
	DbSelectArea("TSE5")
	TSE5->(DbSkip())
End
TSE5->(DbCloseArea())

// efetua processamento de todos lançamentos manuais que nao foram contabilizados automaticamente
If MV_PAR06 <> MV_PAR07
	ProcRegua(3)
	cQryCT2 := "SELECT R_E_C_N_O_ "
	cQryCT2 += "   FROM " + RetSqlName("CT2")
	cQryCT2 += "   WHERE D_E_L_E_T_ <> '*' AND"
	cQryCT2 += "         CT2_TPSALD = '1'  AND"
	cQryCT2 += "         CT2_MOEDLC = '01' AND"
	cQryCT2 += "         CT2_CREDIT IN ("
	For nC := 1 To Len(_aContas)
		cQryCT2 += "'"+_aContas[nC]+"'"
		If nC < Len(_aContas)
			cQryCT2 += ","
		Else
			cQryCT2 += ") AND"
		Endif
	Next
	cQryCT2 += " CT2_DATA BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "'"
	IncProc("2/2 Pagar/Baixa [ Executando consulta ]")
	TCQUERY cQryCT2 NEW ALIAS "TCT2"
	IncProc("2/2 Pagar/Baixa [ Verificando Registros ]")
	nRegTot := rfRecCount("TCT2")
	nRegAtu := 0
	ProcRegua(nRegTot)
	nInicio := Seconds()
	While !TCT2->(EOF())
		
		// mensagem processamento
		cTempo  := fTempo(nInicio,nRegAtu,nRegTot)
		nRegAtu += 1
		nPerc   := Round((nRegAtu*100)/nRegTot,0)
		IncProc("2/2 Receber/Emissão [ " + AllTrim(TransForm(nRegAtu,"@E 999,999,999")) + " de " + AllTrim(TransForm(nRegTot,"@E 999,999,999")) + " ] " + AllTrim(Str(nPerc)) + "% - " + cTempo)
		
		// verifica se registro foi computado
		If ASCAN(aRegCT2,AllTrim(Str(TCT2->R_E_C_N_O_))) <= 0
			
			// posiciona no registro
			DbSelectArea("CT2")
			DbGoTo(TCT2->R_E_C_N_O_)
			
			// atualiza variaveis
			_dLanDat := CT2->CT2_DATA
			_cLanDoc := CT2->CT2_LOTE+"-"+CT2->CT2_SBLOTE+"-"+CT2->CT2_DOC+"-"+CT2->CT2_LINHA
			_cLanCta := CT2->CT2_CREDIT
			_nLanVlr := CT2->CT2_VALOR * (-1)
			_cLanLan := CT2->CT2_ORIGEM
			_cLanRot := CT2->CT2_ROTINA
			_cLanHis := CT2->CT2_HIST
			_cLanKey := CT2->CT2_KEY
			

			// caso for reversao de correcao, busca lancamento
			_xTipCta := "CRE"
			_kLanDat := CTOD("")
			_kLanCta := ""
			_kLanVlr := 0
			_kLanTab := ""
			_kLanReg := ""
			_kLanRot := ""
			IF CT2->CT2_ROTINA $ "FINA110/FINA070" .AND. CT2->CT2_LP == "530"
				// busca CTK
				_cQryCTK := "SELECT CTK_TABORI, CTK_RECORI, CTK_DATA, CTK_VLR01, CTK_ROTINA, CTK_DEBITO, CTK_CREDIT"
				_cQryCTK += " FROM " + RetSqlName("CTK")
				_cQryCTK += " WHERE D_E_L_E_T_ <> '*' AND"
				_cQryCTK += "       CTK_RECDES = " + AllTrim(Str(CT2->(RECNO())))
				TCQUERY _cQryCTK NEW ALIAS "TCTK"
				_kLanDat := STOD(TCTK->CTK_DATA)
				_lLanCta := TCTK->CTK_CREDIT
				_kLanVlr := TCTK->CTK_VLR01
				_kLanTab := TCTK->CTK_TABORI
				_kLanReg := AllTrim(Str(TCTK->CTK_RECORI))
				_kLanRot := TCKT->CTK_ROTINA
				TCTK->(DbCloseArea())
			Endif
			
			_nFinVlr := 0
			
			// adiciona no arquivo temporario
			DbSelectArea("TRB")
			If RecLock("TRB",.T.)
				// conta prova
				K_DATA   := _kLanDat
				K_CONTA  := _kLanCta
				If "DEB" $ _xTipCta
					K_VALOR  := _kLanVlr
				Else
					K_VALOR  := _kLanVlr * (-1)
				Endif
				K_LP     := _kLanTab+"-"+_kLanReg
				K_ROT    := _kLanRot
				// lancamento
				C_DATA   := _dLanDat
				C_DOCUME := _cLanDoc
				C_CONTA  := _cLanCta
				C_VALOR  := _nLanVlr
				C_LP     := _cLanLan
				C_ROT    := _cLanRot
				// diferenca
				D_VALOR  := _nFinVlr-_nLanVlr
				XVLR     := IIF(D_VALOR<0,D_VALOR*(-1),D_VALOR)
				//X_INDICE := DTOS(_dFinDat)+" "+AllTrim(Str(XVLR))
				D_OBS    := _cLanHis
				D_KEY	 := _cLanKey
				// fecha
				MsUnlock()
			Endif
			
		Endif
		
		// proximo registro
		DbSelectArea("TCT2")
		TCT2->(DbSkip())
	End
	TCT2->(DbCloseArea())
Endif

// retorna
Return


Static Function fTRBCRINV()
Local nRegAtu := 0
Local nRegTot := 0
Local nRegCtk := 0
Local cQrySE1
Local cQrySF2
Local cQryCTK
Local cQryCT2
Local aRegCt2 := {}
Local iRegistro
Local iTotal

// regua processamento
ProcRegua(3)

// busca titulos emitidos no mes
cQrySE1 := "SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_EMIS1, E1_VLCRUZ, E1_ORIGEM, R_E_C_N_O_,"
cQrySE1 += "       E1_SERIE, E1_HIST, E1_FATURA"
cQrySE1 += "   FROM " + RetSqlName("SE1")
cQrySE1 += "   WHERE D_E_L_E_T_ <> '*' AND"
cQrySE1 += "         E1_FATURA = 'NOTFAT'   AND"
cQrySE1 += "         E1_EMIS1   BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "' AND"
cQrySE1 += "         E1_CLIENTE BETWEEN '" + MV_PAR06       + "' AND '" + MV_PAR07       + "'"
cQrySE1 += "   ORDER BY E1_EMIS1, E1_CLIENTE, E1_LOJA, E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO"
IncProc("1/2 Receber/Emissão [ Executando consulta ]")
TCQUERY cQrySE1 NEW ALIAS "TSE1"
IncProc("1/2 Receber/Emissão [ Verificando Registros ]")
nRegTot := rfRecCount("TSE1")
nInicio := Seconds()
ProcRegua(nRegTot)
While !TSE1->(EOF())
	
	// mensagem processamento
	cTempo  := fTempo(nInicio,nRegAtu,nRegTot)
	nRegAtu += 1
	nPerc   := Round((nRegAtu*100)/nRegTot,0)
	IncProc("1/2 Receber/Emissão [ " + AllTrim(TransForm(nRegAtu,"@E 999,999,999")) + " de " + AllTrim(TransForm(nRegTot,"@E 999,999,999")) + " ] " + AllTrim(Str(nPerc)) + "% - " + cTempo)
	
	// define o tipo do movimenot
	If TSE1->E1_TIPO $ MVRECANT+"/"+MVABATIM+"/"+MV_CRNEG+"/PIS#COF#CSL" //PIS/COF/CSL = PCC Baixa CR
		_nFinVlr := TSE1->E1_VLCRUZ * (-1)
		_nFinOut := 0
		_xTipCta := "_CREDIT"
	Else
		_nFinVlr := TSE1->E1_VLCRUZ
		_nFinOut := 0
		_xTipCta := "_DEBITO"
	Endif
	
	// inicia variaveis
	_cFinTab := "SE1"
	_nRegOri := TSE1->R_E_C_N_O_
	_cFinDoc := TSE1->E1_FILIAL+"-"+TSE1->E1_PREFIXO+"-"+TSE1->E1_NUM+"-"+TSE1->E1_PARCELA+"-"+TSE1->E1_TIPO
	_cFinCli := TSE1->E1_CLIENTE+"/"+TSE1->E1_LOJA
	_dFinDat := STOD(TSE1->E1_EMIS1)
	_cFinCta := ""
	_cFinNum := AllTrim(TSE1->E1_NUM)
	_cFinFil := TSE1->E1_FILIAL
	_cFinHis := AllTrim(TSE1->E1_HIST)
	
	// atualiza quadro de resumo
	_nResumo := 0
	For _nR := 1 To Len(_aResumo)
		If _aResumo[_nR,1] == _dFinDat
			_nResumo := _nR
		Endif
	Next
	If _nResumo <= 0
		AADD(_aResumo,{_dFinDat,0,0,0,0,0,0})
		_nResumo := Len(_aResumo)
	Endif
	_aResumo[_nResumo,2] += _nFinVlr
	
	// posiciona no cadastro de clientes
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+TSE1->E1_CLIENTE+TSE1->E1_LOJA)
		_cFinCta := SA1->A1_CONTA
	Else
		_cFinCta := "NAO DEFINIDA"
	Endif
	If !Empty(_cFinCta)
		If ASCAN(_aContas,_cFinCta) <= 0
			AADD(_aContas,_cFinCta)
		Endif
	Endif
	
	// busca titulo no faturamento
	If "MATA" $ TSE1->E1_ORIGEM
		DbSelectArea("SF2")
		DbSetOrder(1) // F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA
		If DbSeek(TSE1->E1_FILIAL+TSE1->E1_NUM+TSE1->E1_SERIE+TSE1->E1_CLIENTE+TSE1->E1_LOJA)
			_cFinTab := "SF2"
			_nRegOri := SF2->(RECNO())
		Endif
	Endif
	
	DbSelectArea("TINV")
	If RecLock("TINV",.T.)
		// financeiro
		A_ORIGEM := TSE1->E1_PREFIXO
		A_DOCUME := TSE1->E1_NUM
		A_CLIENT := TSE1->E1_CLIENTE
		A_DATA   := STOD(TSE1->E1_EMIS1)
		A_CONTA  := _cFinCta
		A_TOTAL  := TSE1->E1_VLCRUZ
		A_OUTROS := 0
		A_VALOR  := TSE1->E1_VLCRUZ
		TINV->(MSUNLOCK())
	ENDIF	

	// busca registro das Invoices
	// busca titulos emitidos no mes
	cQryCTK := "SELECT * "
	cQryCTK += "   FROM " + RetSqlName("SE1")
	cQryCTK += "   WHERE D_E_L_E_T_ <> '*' AND"
	cQryCTK += "         E1_FATURA = '"+TSE1->E1_NUM+"'   AND"
	cQryCTK += "         E1_CLIENTE BETWEEN '" + MV_PAR06       + "' AND '" + MV_PAR07       + "'"
	cQryCTK += "   ORDER BY E1_FATURA"
	IncProc("1/2 Receber/Emissão [ Executando consulta ]")		
	TCQUERY cQryCTK NEW ALIAS "TCTK"
	nRegCtk   := rfRecCount("TCTK")
	iRegistro := 0
	iTotal    := 0
	While !TCTK->(EOF())
		
		// zera varivaeis
		_dLanDat := CTOD("")
		_cLanDoc := ""
		_cLanCta := ""
		_nLanVlr := 0
		_cLanLan := ""
		_cLanRot := ""
		//MsgAlert("1/2 Receber/Emissão [ Posiciona CT2 ]")
		
	
		// adiciona no arquivo temporario
		DbSelectArea("TINV")	
		IF iRegistro = 0
			RecLock("TINV",.F.)
		Else
			RecLock("TINV",.T.)
		EndIF	
		// financeiro
		B_DATA	:= STOD(TCTK->E1_EMIS1)
		//K_CONTA  := &("TCTK->CTK"+_xTipCta)
		//If "DEB" $ _xTipCta
		A_FATURA:= TCTK->E1_NUM
		B_VALOR := TCTK->E1_VLCRUZ
		iTotal  += TCTK->E1_VLCRUZ
		//Else
		//	K_VALOR  := TCTK->CTK_VLR01 * (-1)
		//Endif
		//K_LP     += TCTK->E1_PREFIXO+TCTK->E1_NUM+";"
		
		// fecha
		MsUnlock()
	
		iRegistro ++	
		// proximo registro
		DbSelectArea("TCTK")
		TCTK->(DbSkip())
	End

	TCTK->(DbCloseArea())
	IF iRegistro > 1
		DbSelectArea("TINV")
		If RecLock("TINV",.T.)
			// financeiro
			A_ORIGEM:= "TOTAL"
			A_DOCUME:= TSE1->E1_NUM
			A_TOTAL := TSE1->E1_VLCRUZ
			A_VALOR := TSE1->E1_VLCRUZ
			A_FATURA:= "TOTAL"
			B_VALOR := iTotal
			C_VALOR	:= TSE1->E1_VLCRUZ - iTotal
			TINV->(MSUNLOCK())	
		ENDIF	
	ELSE
		RecLock("TINV",.F.)		
		C_VALOR	:= TSE1->E1_VLCRUZ - iTotal
		TINV->(MSUNLOCK())	
	EndIF

	// proximo registro
	DbSelectArea("TSE1")
	TSE1->(DbSkip())
End
TSE1->(DbCloseArea())


// retorna
Return

Static Function fTrbCrOri()
	LOCAL cQrySE1 := ""
	DbSelectArea("TRB")
	While TRB->(!EOF()) 
	
	
	
	End
	
Return

User Function TesteEdu01()
	PREPARE ENVIRONMENT	EMPRESA "01" FILIAL "11" 
	Private _aCampos := {}
	MV_PAR04 := STOD("20110408")
	MV_PAR05 := STOD("20110408")
	MV_PAR06 := ""
	MV_PAR07 := "ZZZZZZZ"
	AADD(_aCampos,{"F_ORIGEM","C",05,0})
	AADD(_aCampos,{"F_DOCUME","C",21,0})
	AADD(_aCampos,{"F_FATURA","C",30,0})
	AADD(_aCampos,{"F_CLIENT","C",09,0})
	AADD(_aCampos,{"F_CONTA" ,"C",06,0})
	AADD(_aCampos,{"F_DATA"  ,"D",08,0})
	AADD(_aCampos,{"F_TOTAL" ,"N",12,2})
	AADD(_aCampos,{"F_OUTROS","N",12,2})
	AADD(_aCampos,{"F_VALOR" ,"N",12,2})
	AADD(_aCampos,{"K_DATA"  ,"D",08,0})
	AADD(_aCampos,{"K_CONTA" ,"C",06,0})
	AADD(_aCampos,{"K_VALOR" ,"N",12,2})
	AADD(_aCampos,{"K_LP"    ,"C",06,0})
	AADD(_aCampos,{"K_ROT"   ,"C",08,0})
	AADD(_aCampos,{"C_DATA"  ,"D",08,0})
	AADD(_aCampos,{"C_DOCUME","C",21,0})
	AADD(_aCampos,{"C_CONTA" ,"C",06,0})
	AADD(_aCampos,{"C_VALOR" ,"N",12,2})
	AADD(_aCampos,{"C_LP"    ,"C",06,0})
	AADD(_aCampos,{"C_ROT"   ,"C",08,0})
	AADD(_aCampos,{"C_RECNO" ,"N",15,0})
	AADD(_aCampos,{"D_VALOR" ,"N",12,2})
	AADD(_aCampos,{"D_OBS"   ,"C",40,0})
	AADD(_aCampos,{"D_KEY"   ,"C",40,0})
	AADD(_aCampos,{"X_INDICE","C",90,0})

	_cNomArq := CriaTrab(_aCampos)
	If SELECT("TRB") > 0; TRB->(DbCloseArea()); Endif
	dbUseArea( .T.,, _cNomArq, "TRB", NIL, .F. )
	IndRegua("TRB",_cNomArq,"X_INDICE",,,"Selecionando Registros.")
	Private cArqTxt := "h:\teste.txt"
	Private nHdl := fCreate(cArqTxt)	
	cEOL := CHR(13)+CHR(10)
	
	If nHdl == -1
    	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	    Return
	Endif
	
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
	C_DATA   := MV_PAR04
	C_DOCUME := "008820-001-000059-001"
	C_CONTA  := "112101"
	C_VALOR  := 810.61
	C_LP     := "520-03"
	C_ROT    := "FINA070"
	// diferenca
	D_VALOR  := -810.61
	D_OBS	 := "PAG NFB20101119 HENCO GLOBAL SA DE CV- B"
	TRB->(MsUnlock())
	
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
	C_DATA   := MV_PAR04
	C_DOCUME := "008850-001-000377-031"
	C_CONTA  := "112101"
	C_VALOR  := 56.96
	C_LP     := "520-00"
	C_ROT    := "FINA110"
	// diferenca
	D_VALOR  := -56.96
	D_OBS	 := "REG VAR CAM S/ BX INV 100494003339 - INV"	
	TRB->(MsUnlock())
	
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
	C_DATA   := MV_PAR04
	C_DOCUME := "008850-001-000377-031"
	C_CONTA  := "112101"
	C_VALOR  := 56.96
	C_LP     := "520-00"
	C_ROT    := "FINA110"
	// diferenca
	D_VALOR  := -56.96
	D_OBS	 := "REG VAR CAM S/ BX INV 100494001481 - INV"	
	TRB->(MsUnlock())
		
	_FHeader := ""
	DbSelectArea("TRB")
	TRB->(DBGOTOP())
	Do While TRB->(!EOF()) 
	
		cQrySE1 := "SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_EMIS1, E1_VLCRUZ, E1_ORIGEM, R_E_C_N_O_,"
		cQrySE1 += "       E1_SERIE, E1_HIST, E1_FATURA, E1_VALOR, E1_VALLIQ, E1_INVOICE, E1_CORREC "
		cQrySE1 += "   FROM " + RetSqlName("SE1")
		cQrySE1 += "   WHERE D_E_L_E_T_ = '' AND"
		cQrySE1 += "        (E1_EMIS1   BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "' OR "
		cQrySE1 += "         E1_BAIXA   BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "') AND "	
		cQrySE1 += "         E1_CLIENTE BETWEEN '" + MV_PAR06       + "' AND '" + MV_PAR07       + "' AND"
		cQrySE1 += "        (E1_NUM LIKE '%" + AllTrim(TRB->D_OBS) + "%' OR"			

		cQrySE1 += "         E1_NUM LIKE '%" + AllTrim(TRB->D_KEY) + "%' OR "				                                                                                    
		cQrySE1 += "         E1_INVOICE LIKE '%" + AllTrim(TRB->D_OBS) + "%' ) "			
		TCQUERY cQrySE1 NEW ALIAS "DSE1"
		
		DbSelectArea("DSE1")
		Do While DSE1->(!eof()) 		
			_FHeader += DSE1->E1_NUM + " --- " + ALLTRIM(TRB->D_OBS)+ " --- " + ALLTRIM(TRB->D_KEY)
			IF (ALLTRIM(DSE1->E1_NUM) $ TRB->D_KEY .OR. ALLTRIM(DSE1->E1_NUM) $ TRB->D_OBS .OR. ALLTRIM(DSE1->E1_INVOICE) $ TRB->D_OBS)
				_FHeader += " <==========="
				If RecLock("TRB",.F.)				
					// financeiro
					TRB->F_ORIGEM := "I-SE1"
					TRB->F_DOCUME := DSE1->E1_FILIAL+"-"+DSE1->E1_PREFIXO+"-"+DSE1->E1_NUM+"-"+DSE1->E1_PARCELA+"-"+DSE1->E1_TIPO
					TRB->F_FATURA := DSE1->E1_INVOICE
					TRB->F_CLIENT := DSE1->E1_CLIENTE+"/"+DSE1->E1_LOJA
					TRB->F_DATA   := STOD(DSE1->E1_EMIS1)
					TRB->F_CONTA  := TRB->C_CONTA
					TRB->F_TOTAL  += DSE1->E1_VLCRUZ
					TRB->F_OUTROS += DSE1->E1_CORREC 
					IF DSE1->E1_VLCRUZ > DSE1->E1_VALLIQ
						TRB->F_VALOR  += (DSE1->E1_VLCRUZ - DSE1->E1_VALLIQ) - IIF(DSE1->E1_CORREC < 0, DSE1->E1_CORREC * (-1), DSE1->E1_CORREC)
					ELSE
						TRB->F_VALOR  += DSE1->E1_VALLIQ
					ENDIF	
					MsUnlock()
				Endif
				_FHeader += ALLTRIM(STR(TRB->F_VALOR))
			ENDIF
			_FHeader += cEOL
			DbSelectArea("DSE1")
			DSE1->(DBSKIP())
		ENDDO					
		DSE1->(DbCloseArea())   
		DbSelectArea("TRB")
		TRB->(DBSKIP())
	ENDDO							
	fWrite(nHdl,_FHeader,Len(_FHeader))
return