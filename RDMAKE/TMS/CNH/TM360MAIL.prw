#Include 'Protheus.ch'

/*/{Protheus.doc} TM360MAIL
Função responsável por incluir informações adicionais no corpo do email enviado
pelo registro de ocorrências.
@author 	Luiz Alexandre Ferreira
@since 		07/10/2014
@version 	1.0
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function TM360MAIL()

// ---	Variaveis utilizadas
Local _cBody		:= 	''
Local _aRet		:=	{}
Local _nCount		:=	0
Local _nPlanId	:=	0
Local _cSub		:=	''
Local _nNumAgd	:=	''
Local _cPlaca		:=	''
Local _cAux		:=	''
Local _cNomeMot	:=	''

//	---	Verifica se o ano está com 4 digitos.
If !__SetCentury()
	Set Century On
EndIf

For _nCount	:= 1 to Len(ParamIxb[3])
	
	// ---	Adiciona 
	_nNumAgd	:= 	GetAdvFVal('DT6','DT6_NUMAGD'	,xFilial('DT6')+ParamIxb[3,_nCount,3]+ParamIxb[3,_nCount,4]+ParamIxb[3,_nCount,5],1,'')
	_nPlanId	:=	GetAdvFVal('DF0','DF0_PLANID'	,xFilial('DF0')+_nNumAgd,1,'')
	
	//	---	Placa do veículo
	_cAux		:= 	GetAdvFVal('DTR','DTR_CODVEI'	,xFilial('DTR')+M->DUA_FILORI+M->DUA_VIAGEM,1,'')
	_cPlaca		:=	GetAdvFVal('DA3','DA3_PLACA'	,xFilial('DA3')+_cAux,1,'')
	     
	// 	---	Nome do motorista
	_cAux		:= 	GetAdvFVal('DUP','DUP_CODMOT'	,xFilial('DUP')+M->DUA_FILORI+M->DUA_VIAGEM,1,'')
	_cNomeMot	:=	GetAdvFVal('DA4','DA4_NOME'		,xFilial('DA4')+_cAux,1,'')	
	
	_cBody	+=	Iif( Inclui, 'Inclusão de ocorrencia : ', 'Estorno de ocorrência : ' ) + Transform(M->DUA_NUMOCO,'@R 999.999') + CRLF
	_cBody	+=	'' + CRLF
	_cBody	+=	'Plano de transporte : ' + Transform(_nPlanId,'@E 999,999,999') + CRLF
	_cBody	+=	'Placa : ' + Transform(_cPlaca,'@R XXX-9999' ) + CRLF
	_cBody	+=	'Motorista : ' + _cNomeMot + CRLF
	_cBody	+=	'Viagem : ' + M->DUA_VIAGEM + CRLF
	_cBody	+=	'Documento : ' + ParamIxb[3,_nCount,4] +' / Serie : ' + ParamIxb[3,_nCount,5] + CRLF
	_cBody	+=	'Filial : ' + ParamIxb[3,_nCount,3] + ' - '+FWFilialName(,ParamIxb[3,_nCount,3],1) + CRLF
	_cBody	+=	'Data Ocorrência : ' + SubStr(ParamIxb[3,_nCount,2],1,10) + CRLF
	_cBody	+=	'Hora da Ocorrência : ' + Transform(SubStr(ParamIxb[3,_nCount,2],11,4),'@R 99:99' ) + CRLF
	
	
Next

_cBody		+=	CRLF
_cBody		+=	CRLF
_cBody    	+= 	'Atenciosamente,' + CRLF
_cBody		+= 	Posicione("SM0",1,SM0->M0_CODIGO+M->DUA_FILORI,"M0_NOMECOM")

//	---	Considera inclusão ou estorno     
If Inclui      
	_cSub	:=	'Apontamento de ocorrência : ' + M->DUA_CODOCO + ' : ' + GetAdvFVal('DT2','DT2_DESCRI',xFilial('DT2')+M->DUA_CODOCO,1,'')
Else
    _cSub	:=	'Desconsiderar apontamento de ocorrência : ' + M->DUA_CODOCO + ' : ' + GetAdvFVal('DT2','DT2_DESCRI',xFilial('DT2')+M->DUA_CODOCO,1,'')
EndIf	      

//	---	Trata retorno
Aadd( _aRet , _cSub )
Aadd( _aRet , _cBody )
Aadd( _aRet , ParamIxb[1] )
Aadd( _aRet , ParamIxb[2] )

Return _aRet

