#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CONVLD   � Autor � Vitor Sbano        � Data �  27/04/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para conversao de representacao numerica do Cod     ���
���          � Barras (E2_XLINDIG) - Linha Digitavel em Codigo de Barras  ���
���          � (E2_CODBAR)                                                ���
���          �                                                            ���
���          � Para esta funcao, deve-se criar gatilho a partir do campo  ���
���          � E2_XLINDIG                                                 ���
���          �                                                            ���
���          � Dominio.......:   E2_XLINDIG                               ���
���          � Contra Dominio:   E2_CODBAR                                ���
���          � Regra.........:   M->E2_CODBAR := u_CONVLD()               ���
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 8 - Financeiro - Contas a Pagar (FINA050/FINA750  ���
���          � (Gatilho)                                                  ���
���          �                                                            ���
������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

USER FUNCTION ConvLD()

SETPRVT("cStr")
//
cStr := LTRIM(RTRIM(M->E2_XLINDIG))

IF VALTYPE(M->E2_XLINDIG) == NIL .OR. EMPTY(M->E2_XLINDIG)
    // Se o Campo est� em Branco n�o Converte nada.
    cStr := ""
ELSE
   // Se o Tamanho do String for menor que 44, completa com zeros at� 47 d�gitos. Isso �
   // necess�rio para Bloquetos que N�O t�m o vencimento e/ou o valor informados na LD.

   cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)
ENDIF

DO CASE

CASE LEN(cStr) == 47

	cStr := SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10)

CASE LEN(cStr) == 48
    cStr := SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11)
OTHERWISE
    cStr := cStr+SPACE(48-LEN(cStr))
ENDCASE

RETURN(cStr)