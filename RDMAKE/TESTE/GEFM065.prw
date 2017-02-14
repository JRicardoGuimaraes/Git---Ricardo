#INCLUDE "rwmake.ch"
//#include "protheus.ch"
#include "topconn.ch"
/***************************************************************************
* Programa.......: GEFM065()                                               *
* Autor..........: J Ricardo de Oliveira Guimar�es                         *
* Data...........: 18/03/09                                                *
* Descricao......: Gera��o de arquivo TXT com informa��oes fiscais de ISS  *
*                  para serem importadas no site ISSDigital, seguindo o    *
*                  lay out estabelecido pela prefeitura de Campinas.       *
****************************************************************************
* Alt. por.......:                                                         *
* Data...........:                                                         *
* Motivo.........:                                                         *
*                                                                          *
***************************************************************************/

*------------------------*
User Function GEFM065
*------------------------*

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg       := "GEFM65"
Private oGeraTxt

Private cString := "SF3"

AjustaSX1()
Pergunte(cPerg,.F.)

dbSelectArea("SF3")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 390,410 DIALOG oGeraTxt TITLE OemToAnsi("Gera��o de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " SF3                                                           "
/*
@ 70,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
*/
@ 80,100 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 80,130 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 80,160 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATXT� Autor � AP5 IDE            � Data �  18/03/09   ���
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

Private cArqTxt := MV_PAR03
Private nHdl    := 0 
Private cEOL    := "CHR(13)+CHR(10)"

cPath:=cGetFile( "DBF(*.txt) | *.txt ",OemToAnsi("Salvar em..."),,"d:",.f.,GETF_LOCALHARD+GETF_RETDIRECTORY)

If Empty(cArqTXT)
	Aviso("Info","N�o foi informado um nome de arquivo destino.",{"Ok"})
	Return
EndIf

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

nHdl := fCreate(cPath+"\"+cArqTxt)

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser criado! Verifique os parametros.","Atencao!")
    Return
Endif

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  18/03/09   ���
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
Local _cQry
Local _cTipoRecIss


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

// dbSelectArea(cString)

// Sa�das
_cQry := " SELECT F3_FILIAL, F3_ENTRADA, F3_EMISSAO, F3_NFISCAL, F3_SERIE, F3_CLIEFOR, F3_LOJA, F3_CFO, "
_cQry += " 		F3_CODISS, F3_ESTADO, F3_ALIQICM, F3_VALCONT, F3_BASEICM, F3_VALICM, F3_ISENICM, F3_OUTRICM, "
_cQry += " 		F3_VALOBSE, F3_ICMSRET, F3_TIPO, F3_ICMSCOM, F3_NRLIVRO, F3_ESPECIE, F3_DTCANC, F3_CNAE, " 
_cQry += " 		F3_NFELETR, F3_EMINFE, F3_HORNFE, F3_CODNFE, F3_OBSERV "
_cQry += " 	FROM " + RetSqlName("SF3") + " SF3 "
_cQry += " 	WHERE F3_EMISSAO >= '" + DTOS(MV_PAR01) + "' "
_cQry += " 	  AND F3_EMISSAO <= '" + DTOS(MV_PAR02) + "' "
_cQry += " 	  AND F3_FILIAL   = '" + cFilAnt + "' "
_cQry += " 	  AND F3_TIPO = 'S' "
_cQry += " 	ORDER BY F3_CFO, F3_EMISSAO "

TCQuery _cQry ALIAS "TSF3" NEW

dbSelectArea("SA1") ; dbSetOrder(1)

dbSelectArea("TSF3")
dbGoTop()

ProcRegua(0) // Numero de registros a processar

// Gera��o do registro Tipo "H"
cLin := "H"
cLin += IIF(Empty(SM0->M0_INSCM),"00000749290",PadR(AllTrim(SM0->M0_INSCM),11)) // Inscri��o Municipal - CAMPINAS
cLin += "100" // Vers�o do sistema da ISS
cLin += cEOL  // Final de Linha

// Gravo registro de Header
If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
      Return
   Endif
Endif

While !EOF()

    //���������������������������������������������������������������������Ŀ
    //� Incrementa a regua                                                  �
    //�����������������������������������������������������������������������

    IncProc()

    //�����������������������������������������������������������������ͻ
    //� Lay-Out do arquivo Texto gerado:                                �
    //�����������������������������������������������������������������͹
    //�Campo           � Inicio � Tamanho                               �
    //�����������������������������������������������������������������Ķ
    //� ??_FILIAL     � 01     � 02                                    �
    //�����������������������������������������������������������������ͼ
    
    nTamLin := 2


	// A pedido da C�lia - pos as NFs modelo 7 n�o deveria ter reten��o de imposto.
	If TSF3->F3_ESTADO == "EX"
		dbSelectArea("TSF3")
	    dbSkip()
	    Loop
	EndIf

	dbSelectArea("SA1")
	dbSeek(xFilial("SA1")+TSF3->F3_CLIEFOR + TSF3->F3_LOJA)
	
    _cTipoRecIss := IIF(SA1->A1_RECISS=="1","A","R")  // Tipo de recolhimento do ISS
    
    
    cLin    := "E"  // Indica��o do Registro
    cLin    += SubStr(TSF3->F3_EMISSAO,7,2) + "/" + SubStr(TSF3->F3_EMISSAO,5,2) + "/" + SubStr(TSF3->F3_EMISSAO,1,4) // Data de emiss�o (DD/MM/AAAA)
    cLin    += IIF(TSF3->F3_ESPECIE=="CTRC","CF", "72") // Left(TSF3->F3_SERIE,2)  // S�rie da NF - S�ries NF=72 e CTRC=CF - Tabela 4.1
    cLin    += "A" // TSF3->F3_        // Modelo da NF - Segundo a tabela 4.2 � livre(obrigat�rio) - S�ries NF=72 e CTRC=CF
    cLin    += IIF(TSF3->F3_ALIQICM>0,"T","C") // Tributa��o NF emitida - Tabela 4.3
    cLin    += StrZero(Val(AllTrim(TSF3->F3_NFISCAL)),09)  // N�mero de NF
	If EMPTY(TSF3->F3_DTCANC)    
    	cLin    += STRTRAN(STRZERO(TSF3->F3_VALCONT,15,2),".",",") // Valor Bruto da NF
	    cLin    += STRTRAN(STRZERO(TSF3->F3_BASEICM,15,2),".",",") // Valor do Servi�o
	Else
    	cLin    += STRTRAN(STRZERO(0,15,2),".",",") // Valor Bruto da NF
	    cLin    += STRTRAN(STRZERO(0,15,2),".",",") // Valor do Servi�o	    
	EndIf    
    cLin    += IIF(EMPTY(TSF3->F3_DTCANC),_cTipoRecISS," ") // Tipo de recolhimento do ISS
	cLin    += StrZero(TSF3->F3_ALIQICM,05)  // Aliquota de ISS
	cLin    += IIF(SA1->A1_PESSOA=='J' .AND. SA1->A1_TIPO<>'X',StrZero(Val(SA1->A1_CGC),14),StrZero(0,14))        // CNPJ do tomador de servi�os
	cLin    += IIF(SA1->A1_PESSOA=='F' .AND. SA1->A1_TIPO<>'X',StrZero(Val(SA1->A1_CGC),11),StrZero(0,11))        // CPF do tomador de servi�os	
	cLin    += PadR(AllTrim(IIF(EMPTY(TSF3->F3_DTCANC),SA1->A1_NOME,"")),40) // Nome do tomador de servi�os
	cLin    += PadR(SA1->A1_CODSIAF,10) // C�digo SIAFI do munic�pio do tomador de servi�os	
	cLin    += PadR("0493020100",10) // SB1->B1_CNAE - C�digo da Atividade CNAE relacionada ao servi�o	
	cLin    += PadR("6291",10) // CAMPINAS - C�digo SIAFI do munic�pio do Local da Presta��o de servi�os
	cLin    += PadR("000000000",09) // N�mero final do intervalo (utilizado somente para emiss�o de notas fiscais em lote) 	
    cLin    += IIF(EMPTY(TSF3->F3_DTCANC),"N","C") // Situa��o da nota fiscal - N-Normal, C-Cancelada, E-Extraviada
    cLin    += " " // Enquadramento no Simples Nacional do Tomador de servi�os
    cLin    += "B" // Opera��o da nota fiscal emitida
    
    cLin    += cEOL // Variavel para criacao da linha do registros para gravacao

    //���������������������������������������������������������������������Ŀ
    //� Substitui nas respectivas posicioes na variavel cLin pelo conteudo  �
    //� dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     �
    //� string dentro de outra string.                                      �
    //�����������������������������������������������������������������������

//    cCpo := PADR(SF3->??_FILIAL,02)
//    cLin := Stuff(cLin,01,02,cCpo)

    //���������������������������������������������������������������������Ŀ
    //� Gravacao no arquivo texto. Testa por erros durante a gravacao da    �
    //� linha montada.                                                      �
    //�����������������������������������������������������������������������

    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            Exit
        Endif
    Endif
	
	dbSelectArea("TSF3")
    dbSkip()
EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������

fClose(nHdl)
Close(oGeraTxt)         

dbSelectArea("TSF3")
dbCloseArea()

Return

*----------------------------------*
Static Function AjustaSX1()
*----------------------------------*
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

DbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))

Aadd(aRegs,{cPerg,"01","Data de Emissao de    :","","","mv_ch1","D",008,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data de Emissao Ate   :","","","mv_ch2","D",008,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Nome Arquivo Destino  :","","","mv_ch3","C",030,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
/*
Aadd(aRegs,{cPerg,"03","Filial de             :","","","mv_ch3","C",002,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Filial ate            :","","","mv_ch4","C",002,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Tipo de Doc           :","","","mv_ch5","C",001,0,0,"C","","mv_par03","Entrada","Entrada","Entrada","","","Saida","Saida","Saida","","Todos","Todos","Todos","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Quebra pag. por filial:","","","mv_ch6","C",001,0,0,"C","","mv_par06","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Exibe Fin sem Cont     :","","","mv_ch3","C",001,0,0,"C","","mv_par03","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Exibe Fiscal sem Cont  :","","","mv_ch4","C",001,0,0,"C","","mv_par04","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","",""})
*/
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
