#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*
*---------------------------------------------------------------------------*
* Função     |GEFRCT2    | Autor | J Ricardo             | Data | 12.09.13  *
*---------------------------------------------------------------------------*
* Descrição  |Tela de Manutençao dos títulos importados dos TXT´s para a    *
*            |tabela intermediária (SZR), e estão com errata, para serem    *
*            |processados novamente pela rotina automática                  *
*            |                                                              *
*---------------------------------------------------------------------------*
*/
User Function GEFRCT2()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cPerg       := "EXPCT2"
Private oGeraTxt

Private cString := "CT2"

//dbSelectArea("CT2")
//dbSetOrder(1)

//CriaSX1()
Pergunte(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geração de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " CT2                                                           "

@ 70,098 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 70,128 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³ AP5 IDE            º Data ³  12/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkGeraTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private nHdl    := fCreate(mv_par03)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+mv_par03+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| RunCont(0) },"Processando...")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  12/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont
Local nTamLin, cLin, cCpo
Local _cQry   		:= ""
Local _nDup   		:= 0
Local _cConta 		:= ""
Local _cCC			:= ""
Local _cOper  		:= ""
Local _cIdUser 	:= ""
Local _cNomUser	:= ""
Local _nCntReg  := 0
Local _nSomaReg := 0.00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O tratamento dos parametros deve ser feito dentro da logica do seu  ³
//³ programa.  Geralmente a chave principal e a filial (isto vale prin- ³
//³ cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- ³
//³ meiro registro pela filial + pela chave secundaria (codigo por exem ³
//³ plo), e processa enquanto estes valores estiverem dentro dos parame ³
//³ tros definidos. Suponha por exemplo o uso de dois parametros:       ³
//³ mv_par01 -> Indica o codigo inicial a processar                     ³
//³ mv_par02 -> Indica o codigo final a processar                       ³
//³                                                                     ³
//³ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ³
//³ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ³
//³                                                                     ³
//³ Assim o processamento ocorrera enquanto o codigo do registro posicio³
//³ nado for menor ou igual ao parametro mv_par02, que indica o codigo  ³
//³ limite para o processamento. Caso existam outros parametros a serem ³
//³ checados, isto deve ser feito dentro da estrutura de laço (WHILE):  ³
//³                                                                     ³
//³ mv_par01 -> Indica o codigo inicial a processar                     ³
//³ mv_par02 -> Indica o codigo final a processar                       ³
//³ mv_par03 -> Considera qual estado?                                  ³
//³                                                                     ³
//³ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ³
//³ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ³
//³                                                                     ³
//³     If A1_EST <> mv_par03                                           ³
//³         dbSkip()                                                    ³
//³         Loop                                                        ³
//³     Endif                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


_cQry := " SELECT CT2_LOTE+CT2_SBLOTE+CT2_DOC AS DOCUMENTO, CT2_DATA AS DTLANC, CT2_LOTE AS LOTE, CT2_CREDIT AS CREDITO, "
_cQry += "        CT2_DEBITO AS DEBITO, CT2_VALOR AS VALOR, CT2_USERGI AS USUARIO, 'REAL' AS MOEDA, CT2_HIST AS HISTORICO, "
_cQry += "        CT2_CCC AS CC_CREDITO, CT2_CCD AS CC_DEBITO "
_cQry += "   FROM " + RetSqlName("CT2") + " CT2 "
_cQry += "    WHERE CT2_DATA >= '" + DTOS(MV_PAR01) + "' "
_cQry += "      AND CT2_DATA <= '" + DTOS(MV_PAR02) + "' "
_cQry += "      AND D_E_L_E_T_='' "
_cQry += "      AND CT2_VALOR > 0 "

// Se estiver aberto, fecho
If Select("TCT2") > 0
	dbSelectArea("TCT2")
	dbCloseArea()
EndIf

_cQry := ChangeQuery(_cQry)
DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQry), "TCT2", .F., .T.)

dbSelectArea("TCT2")
dbGoTop()

_nConta  := 0
_nTotReg := TCT2->(RecCount())

//ProcRegua(RecCount()) // Numero de registros a processar
ProcRegua(_nTotReg) // Numero de registros a processar

While !EOF()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Incrementa a regua                                                  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//    IncProc(AllTrim(Str(_nConta))+"/"+AllTrim(Str(_nTotReg)))
    IncProc()

    //ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
    //º Lay-Out do arquivo Texto gerado:                                º
    //ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
    //ºCampo           ³ Inicio ³ Tamanho                               º
    //ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
    //º CNPJ     	³ 01   ³ 14                                º
    //º EMPRESA     ³ 15   ³ 40                                º
    //º TPLANC     	³ 55   ³ 01                                º
    //º TPOPER    	³ 56   ³ 01                                º    
    //º DTLANC     	³ 57   ³ 08                                º
    //º CONTA     	³ 65   ³ 15                                º
    //º DESC_CONTA  ³ 80   ³ 30                                º
    //º VALOR     	³ 110  ³ 18                                º
    //º MOEDA     	³ 128  ³ 04                                º
    //º CLASSE     	³ 132  ³ 10                                º
    //º USERID     	³ 142  ³ 10                                º
    //º NOMUSER    	³ 152  ³ 30                                º    
    //º CARGO     	³ 182  ³ 15                                º        
    //º PERIODO     ³ 197  ³ 15                                º
    //º TPCONTA     ³ 212  ³ 01                                º
    //º DOCUMENTO   ³ 213  ³ 15                                º
    //º HISTORICO   ³ 228  ³ 40                                º        
    //º CC          ³ 268  ³ 10                                º            
    //ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

    nTamLin := 278
    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Substitui nas respectivas posicioes na variavel cLin pelo conteudo  ³
    //³ dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     ³
    //³ string dentro de outra string.                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	 _nDup := 1
	 If !Empty(TCT2->DEBITO) .AND. !Empty(TCT2->CREDITO)
	   _nDup := 2
	 EndIf   
	 
	 For x := 1 to _nDup 
	 	 If _nDup = 2
		 	 If x = 1
				 _cOper  := "D"
		 	 	 _cConta := TCT2->DEBITO
		 	 	 _cCC    := TCT2->CC_DEBITO
		 	 Else
				 _cOper  := "C"		 	 
		 	 	 _cConta := TCT2->CREDITO
		 	 	 _cCC    := TCT2->CC_CREDITO
		 	 EndIf   
		 Else 
		 	 _cConta := IIF(!Empty(TCT2->DEBITO),TCT2->DEBITO, TCT2->CREDITO)
		 	 _cCC	 := IIF(!Empty(TCT2->DEBITO),TCT2->CC_DEBITO, TCT2->CC_CREDITO)	
		 	 _cOper  := IIF(!Empty(TCT2->DEBITO),"D", "C")
		 EndIf	 
	 	 	 	 
	    cCpo := PADR("03094658000106",14)
	    cLin := Stuff(cLin,01,14,cCpo)
	    cCpo := PADR("GEFCO LOGISTICA DO BRASIL LTDA",40)
	    cLin := Stuff(cLin,15,40,cCpo)
	    cCpo := PADR(IIF(SubStr(TCT2->LOTE,1,4)="0099","M","A"),01)
	    cLin := Stuff(cLin,55,01,cCpo)
	    cCpo := PADR(_cOper,01)
	    cLin := Stuff(cLin,56,01,cCpo)
	    cCpo := PADR(TCT2->DTLANC,08)
	    cLin := Stuff(cLin,57,08,cCpo)
	    cCpo := PADR(_cConta,15)
	    cLin := Stuff(cLin,65,15,cCpo)
	    cCpo := PADR(Posicione("CT1",1,xFilial("CT1") + _cConta, "CT1_DESC01"),30)
	    cLin := Stuff(cLin,80,30,cCpo)
	    cCpo := Str(TCT2->VALOR,18,02)
	    cLin := Stuff(cLin,110,18,cCpo)
	    cCpo := PADR(TCT2->MOEDA,04)
	    cLin := Stuff(cLin,128,04,cCpo)
	    cCpo := PADR(IIF(LEFT(_cConta,1)="1","ATIVO",IIF(LEFT(_cConta,1)="2","PASSIVO",IIF(LEFT(_cConta,1)="7","DESPESAS",IIF(LEFT(_cConta,1)="8","RECEITA",IIF(LEFT(_cConta,1)="9","APURACAO",""))))),10)  // CT2->CLASSE
	    cLin := Stuff(cLin,132,10,cCpo)
	    
	    // Pego Id do Usuário do Protheus
	    _cIdUser := AllTrim(SubStr(embaralha(TCT2->USUARIO,1),1,15))
	   _cNomUser := Upper(UsrFullName(_cIdUser))
	   
	    cCpo := PADR(_cIdUser,10)  // USERID
	    cLin := Stuff(cLin,142,10,cCpo)
		cCpo := PADR(_cNomUser,30)  // Nome User
	    cLin := Stuff(cLin,152,30,cCpo)	        
		 cCpo := PADR("",15)  // Cargo
	    cLin := Stuff(cLin,182,15,cCpo)	        	    
	    cCpo := PADR(Upper(AllTrim(MesExtenso(STOD(TCT2->DTLANC)))+"/"+SubStr(TCT2->DTLANC,1,4)),15)  // CT2->PERIODO
	     cLin := Stuff(cLin,197,15,cCpo)
	    cCpo := PADR(IIF(AllTrim(_cConta) $ "111401|111402|213118","T",""),01)
	    cLin := Stuff(cLin,212,01,cCpo)
	    cCpo := PADR(TCT2->DOCUMENTO,15)
	    cLin := Stuff(cLin,213,15,cCpo)
	    cCpo := PADR(TCT2->HISTORICO,40)
	    cLin := Stuff(cLin,228,40,cCpo)
	    cCpo := PADR(_cCC,10)
	    cLin := Stuff(cLin,268,10,cCpo)	    

		_nCntReg++
		_nConta++
		_nSomaReg += TCT2->VALOR

	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    //³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
	    //³ linha montada.                                                      ³
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	            Exit
	        Endif
	    Endif

	 Next x

 	dbSelectArea("TCT2")
    dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("TCT2")
dbCloseArea()

fClose(nHdl)
Close(oGeraTxt)

_cQry := "Tamanho                 : " + StrZero((nTamLin * _nCntReg)/1024,25) + " KBytes;" + cEOL
_cQry += "Quantidade de Registros : " + StrZero(_nCntReg,25) + ";" + cEOL
_cQry += "Total do Campo Valor Contabil: R$ " + Transform(_nSomaReg, "@E 999,999,999,999.99") +";"+ cEOL
_cQry += "Programa utilizado na geracao: Sistema Microsiga Protheus - modulo Contabil;" + cEOL
_cQry += "O arquivo foi enviado em: ;" + cEOL

MEMOWRIT(AllTrim(MV_PAR03) + "-CONTROLE",_cQry)

Alert("Arquivo gerado: " + AllTrim(MV_PAR03))

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CriaSX1   ³ Autor ³Katia Alves Bianchi    ³ Data ³18/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ajuste de Perguntas (SX1)                 			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CriaSX1()

_sAlias := Alias()																		
dbSelectArea("SX1")
dbSetOrder(1)
aRegs :={}

//(sx1) Grupo/Ordem/Pergunta/X1_PERSPA/X1_PERENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSpa1/DefEng1/Cnt01/Var02/Def02/DefSpa2/DefEng2/Cnt02/Var03/Def03/DefSpa3/DefEng3/Cnt03/Var04/Def04/DefSpa4/DefEng4/Cnt04/Var05/Def05/DefSpa5/DefEng5/Cnt05/F3
aAdd(aRegs,{cPerg,"01","Data Inicial   ?","Data Inicial   ?","Data Inicial   ?","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Final     ?","Data Final     ?","Data Final     ?","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Pasta\Arquivo  ?","Pasta\Arquivo  ?","Pasta\Arquivo  ?","mv_ch3","C",50,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
dbSelectArea(_sAlias)

Return()