#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GEFM24    � Autor � Saulo Muniz           � Data � 11.04.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Replica��odos dados cadastrais para os campo de cobran�a    ���
���          �quando os clientes importados n�o possuir estes.            ���
���                                                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GEFM24()    

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Atualiza dados Clientes ADHOC - Cobran�a")
@ 02,10 TO 080,190
@ 10,018 Say " Este Programa ira ler o conteudo do Arquivo,"
@ 18,018 Say " de Clientes AP5 e Atualizar o endere�o de Cobran�a"
@ 26,018 Say " em Branco, com o Endere�o Principal."
@ 60,098 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 60,128 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
Activate Dialog oLeTxt Centered
Return

Static Function OkLeTxt

Processa({|| RunCont() },"Processando...")
Close(oLeTxt)
Return

Static Function RunCont

DbSelectArea("SA1") 
Dbgotop()

While !EOF()
   
   IncProc()  
   DbSelectArea("SA1") 
   IF Empty(A1_ENDCOB)
    RecLock("SA1",.F.)     
    SA1->A1_ENDCOB  := Alltrim(SA1->A1_END)
    SA1->A1_BAIRROC := SA1->A1_BAIRRO
    SA1->A1_MUNC    := SA1->A1_MUN
    SA1->A1_ESTC    := SA1->A1_EST
    SA1->A1_CEPC    := SA1->A1_CEP   
    MSUnLock() 
   Endif
 
   dbSkip()    

EndDo           

Return