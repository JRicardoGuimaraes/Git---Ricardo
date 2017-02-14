#Include "Protheus.Ch"
#Include "TopConn.Ch"

*---------------------------------------------------------------------------------------------*

/*/{Protheus.doc} MTDescrNFE

Ponto de Entrada com o Objetivo de Compor a descrição dos serviços prestados na operação. Essa 
descrição será utilizada para a impressão do RPS e para geração do arquivo de exportação para a prefeitura. 

@author Rafael Rezende

@since 16/01/2014

@version 1.0		
                   
@param 01 - Número do RPS gerado ( F3_NFISCAL ) 
@param 02 - Série do RPS gerado
@param 03 - Código do Cliente 
@param 04 - Loja do Cliente 

@return String de String com a Descrição a ser apresentada

@see 

A string deverá ter, no máximo, 999 caracteres. Caso a descrição retornada pelo ponto de entrada ultrapasse esse 
limite, o programa irá reduzir o retorno em 999 caracteres. 
Caso sejam necessárias quebras de linha na descrição a ser apresentada, inserir o caracter pipe “|” (chr124), 
porque, para o arquivo magnético de envio à prefeitura, é necessária a configuração de quebra de linha. 
Vale ressaltar que serão impressos 999 caracteres, incluindo as quebras de linha, ou seja, quanto mais quebras 
de linha forem configuradas, menos caracteres serão impressos, devido ao número de caracteres perdidos com a quebra. 

Exemplo 
O ponto de entrada irá retornar quebras de linha da seguinte forma: 
“Serviços prestados:|Lavagem|Polimento|” Que, durante a impressão, serão apresentados como: 

Serviços prestados: 
Lavagem 
Polimento


/*/
*------------------------*
User Function MTDescrNFE() 
*------------------------*
Local _aArea := GetArea()
Local _cNumeroRPS := ParamIxb[01]
Local _cSerieRPS  := ParamIxb[02]
Local _cCliente   := ParamIxb[03]
Local _cLoja      := ParamIxb[04]
Local _cAliasC5   := GetNextAlias()
Local _cQuery     := ""
Local _cRet  	  := ""

_cQuery := " 		SELECT DISTINCT C5_XOBS		 			   			  		" + CRLF
_cQuery += "    	  FROM " + RetSQLName( "SC5" ) + " SC5						" + CRLF
_cQuery += "	INNER JOIN " + RetSQLName( "SC6" ) + " SC6					" + CRLF
_cQuery += "	        ON C5.D_E_L_E_T_ = C6.D_E_L_E_T_						" + CRLF
_cQuery += "	       AND C5.C5_FILIAL  = C6.C6_FILIAL						" + CRLF
_cQuery += "	       AND C5.C5_NUM     = C6.C6_NUM							" + CRLF
_cQuery += "	       AND C5.C5_CLIENTE = C6.C6_CLI							" + CRLF
_cQuery += "	       AND C5.C5_LOJA    = C6.C6_LOJA							" + CRLF
_cQuery += "	     WHERE C5.D_E_L_E_T_ = ' ' 			   			  		" + CRLF
_cQuery += "	       AND C5.C5_FILIAL  = '" + XFilial( "SC5" ) 	+ "' 	" + CRLF
_cQuery += "	       AND C5.C5_CLIENTE = '" + _cCliente 		 	+ "'	" + CRLF
_cQuery += "	       AND C5.C5_LOJA    = '" + _cLoja    		 	+ "' 	" + CRLF
_cQuery += "	       AND C6.C6_NOTA    = '" + _cNumeroRPS 			+ "'	" + CRLF
_cQuery += "	       AND C6.C6_SERIE   = '" + _cSerieRPS  	 		+ "'	" + CRLF

If Select( _cAliasC5 ) > 0 
	( _cAliasC5 )->( DbCloseArea() )
End If 
TcQuery _cQuery Alias ( _cAliasC5 ) New 
_cRet := ""
If !( _cAliasC5 )->( Eof() )
	_cRet := ( _cAliasC5 )->C5_XOBS
EndIf 
( _cAliasC5 )->( DbCloseArea() )

RestArea( _aArea ) 

Return _cRet