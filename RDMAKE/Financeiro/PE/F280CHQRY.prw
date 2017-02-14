#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F280CHQRY � Autor � Ricardo            � Data �  13/03/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Destinado a refazer a qry para considerar todas as filiais ���
���          � na rotina de substituicao Fatura Receber, para atender     ���
���          � projeto da MAN ( FINA280 )                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP7 - Financeiro / Ctas Receber / Faturas Receber (FINA280)���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function F280CHQRY()
Local cQuery   := PARAMIXB[1]  // Recebe string com a query inteira gerada na rotina FINA280
Local _cCliMAN := AllTrim(GETNewPar("MV_XCLIMAN","04858701|15882200"))

// cQuery := STUFF(cQuery,AT("E1_FILIAL=",cQuery),14,"") // mant�m o AND, para caso se for utilizar para filtrar Num. CVA
If cCli + cLoja $ _cCliMAN
	// Retiro a filial da Query
	cQuery := STUFF(cQuery,AT("E1_FILIAL=",cQuery),19,"")
	// cQuery := STUFF(cQuery,AT("ORDER BY E1_FILIAL",cQuery),08,"ORDER BY E1_FILIAL, E1_NUMCVA,")
EndIf	
//MEMOWRIT("U:\GEFCTB07.SQL",cQuery)
Return cQuery