#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GEFDUP  � Autor � Marcos Furtado       � Data �  03/04/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa que elimina as duplicidades no fiscal             ���
�������������������������������������������������������������������������͹��
���Uso       � Fiscal, financeiro                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GEFDUP


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private oGeraSE2

Private cString := "SF3"

dbSelectArea("SF3")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������
                             
Pergunte("MTR180",.F.)
@ 200,1 TO 380,380 DIALOG oGeraSE2  TITLE OemToAnsi("Deletar Duplicidades - Fiscal")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira deletar o registro que estiver duplicado no fiscal"
@ 18,018 Say " "
@ 26,018 Say " "

@ 70,098 BMPBUTTON TYPE 01 ACTION Processa({|| OkGeraSF3() },"Processando...")
@ 70,128 BMPBUTTON TYPE 02 ACTION Close(oGeraSE2)
@ 70,158 BMPBUTTON TYPE 05 ACTION Pergunte("MTR180",.T.)

Activate Dialog oGeraSE2 Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATXT� Autor � AP5 IDE            � Data �  04/10/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkGeraSF3()
Local cQuery := ""                               

cQuery := " SELECT DISTINCT F3_FILIAL,F3_ENTRADA, F3_NFISCAL, F3_SERIE, F3_CLIEFOR, F3_LOJA, F3_CFO, F3_VALCONT "
cQuery += " FROM " + RetSqlName("SF3") + " SF3A "
cQuery += " WHERE F3_FILIAL = '" + xFilial("SF3") + "' AND F3_EMISSAO >= '" + DTOS(MV_PAR01) + "' AND  "
cQuery += " F3_EMISSAO <= '" + DTOS(MV_PAR02) + "'  AND D_E_L_E_T_ <> '*' AND EXISTS (SELECT COUNT(*)  "
cQuery += "	FROM " + RetSqlName("SF3") + " SF3 "
cQuery += "	WHERE SF3.F3_FILIAL = '" + xFilial("SF3") + "' AND SF3.F3_EMISSAO >= '" + DTOS(MV_PAR01) + "' AND  
cQuery += "	             SF3.F3_EMISSAO <= '" + DTOS(MV_PAR02) + "' AND "
cQuery += "              SF3.F3_FILIAL = SF3A.F3_FILIAL AND "
cQuery += "              SF3.F3_NFISCAL = SF3A.F3_NFISCAL AND  "
cQuery += "              SF3.F3_ENTRADA = SF3A.F3_ENTRADA AND   SF3.D_E_L_E_T_ <> '*' AND "
cQuery += "              SF3.F3_VALCONT = SF3A.F3_VALCONT HAVING COUNT(*) >1) "
cQuery += " ORDER BY F3_NFISCAL "

TcQuery cQuery Alias "TRA" New 

ProcRegua(RecCount())

DbSelectArea("TRA")
dbGoTop()
While !Eof()
    IncProc()
	DbselectArea("SF3")             
	dbSetOrder(1)//F3_FILIAL+DTOS(F3_ENTRADA)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA+F3_CFO+STR(F3_ALIQICM,5,2)	
	
	If Dbseek(TRA->F3_FILIAL+TRA->F3_ENTRADA+TRA->F3_NFISCAL+TRA->F3_SERIE+TRA->F3_CLIEFOR+TRA->F3_LOJA+TRA->F3_CFO)
		Reclock("SF3",.F.)
		DbDelete()
		Msunlock()                           
	Endif
	DbSelectArea("TRA")
	DbSkip()
End                                                                   
MsgInfo("Fim do Processamento!")
Close(oGeraSE2)
Return

