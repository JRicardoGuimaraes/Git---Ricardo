#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  19/06/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Atualiza SA1 com a tabela atualizada pela SERASA
User Function ATUSA2()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg       := "TESTE"
Private oLeTxt

Private cString := "SA2"

dbSelectArea("SA2")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo FORNENTES_SARASA")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de FORNENTES_SARASA, conFORNme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say " SA2                                                           "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP6 IDE            � Data �  19/06/13   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkLeTxt

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  19/06/13   ���
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
Local _cQry := ""

If Select("FORN") > 0
	dbSelectArea("FORN") 
	dbCloseArea()
EndIf

_cQry := "SELECT * FROM FORNECEDORES_SERASA ORDER BY DOCUMENTO, INCR_EST "

// dbUseArea(.T., "TOPCONN", "FORNENTES_SERASA", "FORN", .T., .F.)

TCQUERY _cQry ALIAS "FORN" NEW
	
dbSelectArea("FORN") ; dbGoTop()

ProcRegua(LastRec()) // Numero de registros a processar

dbSelectArea("FORN") ; dbGoTop()

While !FORN->(EOF())

   //���������������������������������������������������������������������Ŀ
   //� Incrementa a regua                                                  �
   //�����������������������������������������������������������������������
   IncProc("Processando: " + AllTrim(FORN->DOCUMENTO))
/*
   If Empty(AllTrim(FORN->MENSAGEM_DE_ERRO))
		dbSelectArea("FORN")
		dbSkip()
		Loop
   EndIf
*/	
	dbSelectArea("SA2") ; dbSetOrder(3)
	If !dbSeek(xFilial("SA2")+AllTrim(FORN->DOCUMENTO))
		dbSelectArea("FORN")
		dbSkip()
		Loop
	EndIf
	
	RecLock("SA2",.F.)
	  	SA2->A2_NOME 		:= AllTrim(FORN->RAZAO_SOCIAL_NOME_COMPLETO1)
	  	SA2->A2_END  		:= AllTrim(FORN->TIPO2) + " " + AllTrim(FORN->LOGRADOURO1)+ ", " + FORN->NUMERO1
	  	SA2->A2_COMPLEM 	:= AllTrim(FORN->COMPLEMENTO1)
	  	SA2->A2_BAIRRO		:= AllTrim(FORN->BAIRRO1)
	  	SA2->A2_EST			:= AllTrim(FORN->UF2)
	  	SA2->A2_MUN			:= AllTrim(FORN->MUNICIPIO1)
	  	SA2->A2_COD_MUN	:= AllTrim(SubStr(FORN->IBGE1,3,10))
	  	SA2->A2_IBGE		:= AllTrim(FORN->IBGE1)
	  	SA2->A2_CEP			:= AllTrim(FORN->CEP1)
//	  	SA2->A2_INSCR		:= IIF(Empty(AllTrim(FORN->MSG_ERRO)),AllTrim(FORN->INCR_EST),SA2->A2_INSCR)
	  	SA2->A2_PAIS		:= IIF(AllTrim(FORN->UF2)=="EX","","105")
//	  	SA2->A2_TEL			:= IIF(IsDigit(AllTrim(FORN->TELEFONE)) .AND. AllTrim(FORN->TELEFONE)<>"00000000",AllTrim(FORN->TELEFONE),A2_TEL)
//	  	SA2->A2_DDD			:= IIF(IsDigit(AllTrim(FORN->DDD)) .AND. AllTrim(FORN->DDD)<>"000",AllTrim(FORN->DDD),A2_DDD)
	  	SA2->A2_CNAE		:= AllTrim(FORN->COD_CNAE2) + AllTrim(FORN->SEG_COD_CNAE)
//	  	SA2->A2_SIMPLES	:= IIF(AllTrim(FORN->OPTANTE_PELO_SIMPLES)="P","1","2")
	  	SA2->A2_MSBLQL		:= IIF(AllTrim(FORN->DESCRICAO_SITUACAO1)="ATIVA","2","1")	  	
	  	SA2->A2_REPRES    := "SERASA"
	MSUnLock()

	dbSelectArea("FORN")
   dbSkip()
End

dbSelectArea("FORN") ; dbCloseArea()

Alert("Final de Atualiza��o da SA2.")
Return
