#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA030TOK � Autor �  Saulo Muniz        � Data � 05-11-2003 ���
�������������������������������������������������������������������������͹��
���Descricao � Verifica��o de clientes                                    ���
�������������������������������������������������������������������������͹��
���Uso       �  Gefco                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

*---------------------------*
User Function MA030TOK()
*---------------------------*
Local _Ok := .T.      


   //���������������������������������������������������������������������Ŀ
   //� VERIFICA TIPO DO CLIENTE EXPORTA��O                                 �
   //�����������������������������������������������������������������������
   //
    DbSelectArea("SA1")
    _Tipo := SA1->A1_TIPO 
    
    //CNPJ VAZIO
    IF EMPTY(M->A1_CGC)
       //
       IF M->A1_TIPO == "X"
          //RECEBE CODIGO AUTOMATICO
          M->A1_CGC := (M->A1_COD+M->A1_LOJA)
          _Ok := .T.    
       ELSE
          Alert("Informe O CNPJ do Cliente !!")
          _Ok := .F.    
       ENDIF  
       //
    ELSE
    //
    //CNPJ PREENCHIDO
    //
          CGC(M->A1_CGC)          
          _Ok := .T.          
    ENDIF
    
    // Por: Ricardo Guimar�es - Para Cliente estrageiro o e-mail � o pais � obrigat�rio.
    If M->A1_TIPO == "X"
    	If Empty(M->A1_PAIS) 
          _Ok := .F.        	
           Alert("Para fornecedor extrageiro, favor informar o Pais.")    	
    	EndIf
    	    
    	If Empty(M->A1_EMAIL)
          _Ok := .F.        	
           Alert("Para fornecedor extrageiro, favor informar o e-Mail.")
    	EndIf
	EndIf
Return(_Ok)