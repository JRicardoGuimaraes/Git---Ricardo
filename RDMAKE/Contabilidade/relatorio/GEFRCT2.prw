#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*
*---------------------------------------------------------------------------*
* Fun��o     |GEFRCT2    | Autor | J Ricardo             | Data | 12.09.13  *
*---------------------------------------------------------------------------*
* Descri��o  |Tela de Manuten�ao dos t�tulos importados dos TXT�s para a    *
*            |tabela intermedi�ria (SZR), e est�o com errata, para serem    *
*            |processados novamente pela rotina autom�tica                  *
*            |                                                              *
*---------------------------------------------------------------------------*
*/
User Function GEFRCT2()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg       := "EXPCT2"
Private oGeraTxt

Private cString := "CT2"

//dbSelectArea("CT2")
//dbSetOrder(1)

//CriaSX1()
Pergunte(.F.)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera��o de Arquivo Texto")
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATXT� Autor � AP5 IDE            � Data �  12/09/13   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkGeraTxt

//���������������������������������������������������������������������Ŀ
//� Cria o arquivo texto                                                �
//�����������������������������������������������������������������������

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

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Processa({|| RunCont(0) },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  12/09/13   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� O tratamento dos parametros deve ser feito dentro da logica do seu  �
//� programa.  Geralmente a chave principal e a filial (isto vale prin- �
//� cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- �
//� meiro registro pela filial + pela chave secundaria (codigo por exem �
//� plo), e processa enquanto estes valores estiverem dentro dos parame �
//� tros definidos. Suponha por exemplo o uso de dois parametros:       �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//� Assim o processamento ocorrera enquanto o codigo do registro posicio�
//� nado for menor ou igual ao parametro mv_par02, que indica o codigo  �
//� limite para o processamento. Caso existam outros parametros a serem �
//� checados, isto deve ser feito dentro da estrutura de la�o (WHILE):  �
//�                                                                     �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//� mv_par03 -> Considera qual estado?                                  �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//�     If A1_EST <> mv_par03                                           �
//�         dbSkip()                                                    �
//�         Loop                                                        �
//�     Endif                                                           �
//�����������������������������������������������������������������������


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

    //���������������������������������������������������������������������Ŀ
    //� Incrementa a regua                                                  �
    //�����������������������������������������������������������������������

//    IncProc(AllTrim(Str(_nConta))+"/"+AllTrim(Str(_nTotReg)))
    IncProc()

    //�����������������������������������������������������������������ͻ
    //� Lay-Out do arquivo Texto gerado:                                �
    //�����������������������������������������������������������������͹
    //�Campo           � Inicio � Tamanho                               �
    //�����������������������������������������������������������������Ķ
    //� CNPJ     	� 01   � 14                                �
    //� EMPRESA     � 15   � 40                                �
    //� TPLANC     	� 55   � 01                                �
    //� TPOPER    	� 56   � 01                                �    
    //� DTLANC     	� 57   � 08                                �
    //� CONTA     	� 65   � 15                                �
    //� DESC_CONTA  � 80   � 30                                �
    //� VALOR     	� 110  � 18                                �
    //� MOEDA     	� 128  � 04                                �
    //� CLASSE     	� 132  � 10                                �
    //� USERID     	� 142  � 10                                �
    //� NOMUSER    	� 152  � 30                                �    
    //� CARGO     	� 182  � 15                                �        
    //� PERIODO     � 197  � 15                                �
    //� TPCONTA     � 212  � 01                                �
    //� DOCUMENTO   � 213  � 15                                �
    //� HISTORICO   � 228  � 40                                �        
    //� CC          � 268  � 10                                �            
    //�����������������������������������������������������������������ͼ

    nTamLin := 278
    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

    //���������������������������������������������������������������������Ŀ
    //� Substitui nas respectivas posicioes na variavel cLin pelo conteudo  �
    //� dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     �
    //� string dentro de outra string.                                      �
    //�����������������������������������������������������������������������

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
	    
	    // Pego Id do Usu�rio do Protheus
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

	    //���������������������������������������������������������������������Ŀ
	    //� Gravacao no arquivo texto. Testa por erros durante a gravacao da    �
	    //� linha montada.                                                      �
	    //�����������������������������������������������������������������������
	
	    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	            Exit
	        Endif
	    Endif

	 Next x

 	dbSelectArea("TCT2")
    dbSkip()
EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������

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


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CriaSX1   � Autor �Katia Alves Bianchi    � Data �18/05/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajuste de Perguntas (SX1)                 			      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
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