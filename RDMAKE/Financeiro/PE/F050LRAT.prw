/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  F050LRAT  �Autor  �    Marcos Furtado   � Data �  24/08/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada executado na valida��o da linha da digita- ��
���          � ��o do rateio, quando � utilizado o SIGACON().             ���
���          � Logo n�o funciona aqui e sim o  F050LRCT()                 ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                             

***************************************************
// => VER PONTO DE ENTRADA F050LRCT()
***************************************************

User Function F050LRAT()
lOCAL aArea := GetArea()
Local lRet  := .T.          
/*If (Empty(GdFieldGet("CTJ_DEBITO")) .And. Empty(GdFieldGet("CTJ_CREDIT"))) .Or. ;
   (Empty(GdFieldGet("CTJ_CCD")) .And. Empty(GdFieldGet("CTJ_CCC"))) .Or. ;
   Empty(GdFieldGet("CTJ_HIST")) 
	lRet  := .F.   
	MsgInfo("Todas as Informa��es devem ser preenchidas!","Rateio CC - CP - F050LRAT")
EndIF                                                                      */
RestArea(aArea)
return(lRet)
                        
/*User Function F050RAT()
lOCAL aArea := GetArea()
Local lRet  := .T.

MsgInfo("Entrei","Rateio CC - CP - F050RAT")

FOR N:=1 TO LEN(aCOLS)
	If (Empty(GdFieldGet("CTJ_DEBITO")) .And. Empty(GdFieldGet("CTJ_CREDIT"))) .Or. ;
	   (Empty(GdFieldGet("CTJ_CCD")) .And. Empty(GdFieldGet("CTJ_CCC"))) .Or. ;
	   Empty(GdFieldGet("CTJ_HIST")) 
		lRet  := .F.   
		MsgInfo("Todas as Informa��es devem ser preenchidas!","Rateio CC - CP")
	EndIF                                                                      
NEXT N


RestArea(aArea)

return(lRet)*/
