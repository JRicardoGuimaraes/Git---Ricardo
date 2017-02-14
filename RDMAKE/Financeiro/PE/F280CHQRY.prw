#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF280CHQRY บ Autor ณ Ricardo            บ Data ณ  13/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Destinado a refazer a qry para considerar todas as filiais บฑฑ
ฑฑบ          ณ na rotina de substituicao Fatura Receber, para atender     บฑฑ
ฑฑบ          ณ projeto da MAN ( FINA280 )                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7 - Financeiro / Ctas Receber / Faturas Receber (FINA280)บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function F280CHQRY()
Local cQuery   := PARAMIXB[1]  // Recebe string com a query inteira gerada na rotina FINA280
Local _cCliMAN := AllTrim(GETNewPar("MV_XCLIMAN","04858701|15882200"))

// cQuery := STUFF(cQuery,AT("E1_FILIAL=",cQuery),14,"") // mant้m o AND, para caso se for utilizar para filtrar Num. CVA
If cCli + cLoja $ _cCliMAN
	// Retiro a filial da Query
	cQuery := STUFF(cQuery,AT("E1_FILIAL=",cQuery),19,"")
	// cQuery := STUFF(cQuery,AT("ORDER BY E1_FILIAL",cQuery),08,"ORDER BY E1_FILIAL, E1_NUMCVA,")
EndIf	
//MEMOWRIT("U:\GEFCTB07.SQL",cQuery)
Return cQuery