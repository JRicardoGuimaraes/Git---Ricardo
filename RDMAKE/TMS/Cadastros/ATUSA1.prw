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
User Function ATUSA1()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg       := "TESTE"
Private oLeTxt

Private cString := "SA1"

dbSelectArea("SA1")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo CLIENTES_SARASA")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de CLIENTES_SARASA, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say " SA1                                                           "

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

If Select("CLI") > 0
	dbSelectArea("CLI") 
	dbCloseArea()
EndIf

_cQry := "SELECT * FROM CLIENTES_SERASA ORDER BY DOCUMENTO, INSCRICAO_ESTADUAL"

// dbUseArea(.T., "TOPCONN", "CLIENTES_SERASA", "CLI", .T., .F.)

TCQUERY _cQry ALIAS "CLI" NEW
	
dbSelectArea("CLI") ; dbGoTop()

ProcRegua(LastRec()) // Numero de registros a processar

dbSelectArea("CLI") ; dbGoTop()

While !CLI->(EOF())

   //���������������������������������������������������������������������Ŀ
   //� Incrementa a regua                                                  �
   //�����������������������������������������������������������������������
   IncProc("Processando: " + AllTrim(CLI->DOCUMENTO))
/*
   If Empty(AllTrim(CLI->MENSAGEM_DE_ERRO))
		dbSelectArea("CLI")
		dbSkip()
		Loop
   EndIf
*/	
	dbSelectArea("SA1") ; dbSetOrder(3)
	If !dbSeek(xFilial("SA1")+AllTrim(CLI->DOCUMENTO))
		dbSelectArea("CLI")
		dbSkip()
		Loop
	EndIf
	
	//Ignora os clientes do grupo 1/2/3, pois trata de ser 
	If AllTrim(SA1->A1_GRUPO) $ "1|2|3"
		dbSelectArea("CLI")
		dbSkip()
		Loop
	EndIf
	
	RecLock("SA1",.F.)
	  	SA1->A1_NOME 		:= AllTrim(CLI->RAZAO_SOCIAL_NOME_COMPLETO)
	  	SA1->A1_END  		:= AllTrim(CLI->TIPO2) + " " + AllTrim(CLI->LOGRADOURO1)+ ", " + CLI->NUMERO
	  	SA1->A1_COMPLEM 	:= AllTrim(CLI->COMPLEMENTO1)
	  	SA1->A1_BAIRRO		:= AllTrim(CLI->BAIRRO1)
	  	SA1->A1_EST			:= AllTrim(CLI->UF2)
	  	SA1->A1_MUN			:= AllTrim(CLI->MUNICIPIO1)
	  	SA1->A1_COD_MUN	:= AllTrim(SubStr(CLI->IBGE1,3,10))
	  	SA1->A1_IBGE		:= AllTrim(CLI->IBGE1)
	  	SA1->A1_CEP			:= AllTrim(CLI->CEP1)
//	  	SA1->A1_INSCR		:= IIF(Empty(AllTrim(CLI->MENSAGEM_DE_ERRO)),AllTrim(CLI->INSCRICAO_ESTADUAL),SA1->A1_INSCR)
	  	SA1->A1_PAIS		:= IIF(AllTrim(CLI->UF2)=="EX",SA1->A1_PAIS,"105")
//	  	SA1->A1_TEL			:= IIF(AllTrim(CLI->TELEFONE)="00000000",A1_TEL,AllTrim(CLI->TELEFONE))
//	  	SA1->A1_DDD			:= IIF(AllTrim(CLI->DDD)="000",A1_DDD,AllTrim(CLI->DDD))
	  	SA1->A1_CNAE		:= AllTrim(CLI->COD_CNAE) + AllTrim(CLI->SEG_COD_CNAE)
	  	SA1->A1_SIMPLES	:= IIF(AllTrim(CLI->OPTANTE_PELO_SIMPLES)="P","1","2")
	  	SA1->A1_CONTAT3   := "SERASA"
	MSUnLock()

	dbSelectArea("CLI")
   dbSkip()
End

dbSelectArea("CLI") ; dbCloseArea()

Alert("Final de Atualiza��o da SA1.")
Return
