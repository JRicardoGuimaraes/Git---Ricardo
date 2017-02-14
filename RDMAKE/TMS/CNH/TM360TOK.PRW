#include 'TOTVS.CH'

#DEFINE _cinterface501	'WS Interface501'

User Function TM360TOK
//-------------------------------------------------------------------------------------------------
/* {2LGI} TM360TOK
@autor		: Luiz Alexandre
@descricao	: Ponto de entrada no apontamento da ocorrencia da viagem.
@since		: Ago./2014
@using		: Interface CNH - Metodo interface501
@review		:
*/
//-------------------------------------------------------------------------------------------------
// ---	Variaveis utilizadas
Local _nOpcao	:= 	ParamIxb[1]
Local _lRet		:=	.t.
Local _cOcoCNH  :=	GetMV('ES_CNHOCO')
Local _aOcoCNH	:= 	Iif(!Empty(_cOcoCNH),&_cOcoCNH,{})
Local _aArea	:= 	GetArea()
Local _aAreaDUA	:= 	DUA->(GetArea())
Local _aAreaDUD	:= 	DUD->(GetArea())
Local _aAreaDT6	:= 	DT6->(GetArea())
Local _nPos		:= 	0

// ---	Se os dados da inclusao foram validados
If _nOpcao == 3 .and. !l360Auto
	
	
	// ---	Verifica a sequencia de ocorrencias
	If M->DUA_CODOCO <> _aOcoCNH[1]
		
		// ---	Localiza qual sequencia esta sendo apontada
		_nPos	:=	Ascan( _aOcoCNH, { |x| x == M->DUA_CODOCO } )
		
		// ---	Se for a segunda verifica se a primeira ja foi apontada
		If _nPos	==	2
			
			// ---	Pesquisa a ocorrencia
			DUA->(dbSetOrder(3))
			If DUA->(dbSeek(xFilial('DUA')+_aOcoCNH[_nPos-1]+GDFieldGet('DUA_FILDOC',n)+GDFieldGet('DUA_DOC',n)+GDFieldGet('DUA_SERIE',n) ) )
				
				// ---	Atualiza ocorrencias do primeiro e segundo apontamentos
				_lRet		:= .t.
				
			Else
				// ---	Alerta
				_lRet		:= .f.
				Alert('Não foi localizada ocorrência '+ CRLF +;
				GetAdvFVal('DT2','DT2_CODOCO',xFilial('DT2')+_aOcoCNH[_nPos-1],1,'')+ ' - ' +;
				GetAdvFVal('DT2','DT2_DESCRI',xFilial('DT2')+_aOcoCNH[_nPos-1],1,'') )
				
			EndIf
			
			// ---	Unifica as ocorrencias anteriores
		ElseIf _nPos	==	3
			
			
			// ---	Pesquisa a segunda ocorrencia
			DUA->(dbSetOrder(3))
			If DUA->(dbSeek(xFilial('DUA')+_aOcoCNH[_nPos-1]+GDFieldGet('DUA_FILDOC',n)+GDFieldGet('DUA_DOC',n)+GDFieldGet('DUA_SERIE',n) ))
				
				// ---	Pesquisa a primeira ocorrencia
				If DUA->(dbSeek(xFilial('DUA')+_aOcoCNH[_nPos-2]+GDFieldGet('DUA_FILDOC',n)+GDFieldGet('DUA_DOC',n)+GDFieldGet('DUA_SERIE',n) ))
					
					// ---	Armazena conteudo da operacao anterior
					_lRet		:= .t.
				Else
					
					// ---	Alerta
					_lRet		:= .f.
					Alert('Não foi localizada ocorrência '+ CRLF +;
					GetAdvFVal('DT2','DT2_CODOCO',xFilial('DT2')+_aOcoCNH[_nPos-2],1,'')+ ' - ' +;
					GetAdvFVal('DT2','DT2_DESCRI',xFilial('DT2')+_aOcoCNH[_nPos-2],1,'') )
					
				EndIf
				
			Else
				
				// ---	Alerta
				_lRet		:= .f.
				Alert('Não foi localizada ocorrência '+ CRLF +;
				GetAdvFVal('DT2','DT2_CODOCO',xFilial('DT2')+_aOcoCNH[_nPos-1],1,'')+ ' - ' +;
				GetAdvFVal('DT2','DT2_DESCRI',xFilial('DT2')+_aOcoCNH[_nPos-1],1,'') )       
				
				
			EndIf
			
		EndIf
		
	Else
		// ---	Atualiza somente os dados da primeira variavel
		_lRet		:=	.t.
		
	EndIf
	
EndIf

// ---	Restaura areas
RestArea(_aArea)
RestArea(_aAreaDT6)
RestArea(_aAreaDUA)
RestArea(_aAreaDUD)

Return _lRet
