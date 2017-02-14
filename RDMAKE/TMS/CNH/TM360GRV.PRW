#include 'TOTVS.CH'

#define _cinterface501	'WS Interface501'
#define _cInterface214	'WS Interface214'

User Function TM360GRV
//-------------------------------------------------------------------------------------------------
/* {2LGI} TM360GRV
@autor		: Luiz Alexandre
@descricao	: Ponto de entrada no apontamento da ocorrencia da viagem.
@since		: Ago./2014
@using		: Interface CNH - Metodo interface501
@review	:
*/
//-------------------------------------------------------------------------------------------------
// ---	Variaveis utilizadas
Local _nOpcao   := 	ParamIXB[1]
Local _cFilOCo  := 	ParamIXB[2]
Local _cNumOco  := 	ParamIXB[3]
Local _cFilOri  := 	ParamIXB[4]
Local _cViagem  := 	ParamIXB[5]
Local _cCodOco	:= 	GetAdvFVal('DUA','DUA_CODOCO',xFilial('DUA')+_cNumOco,5,'')
Local _cOcoCNH  :=	GetMV('ES_CNHOCO')
Local _cOcoTrk  :=	SuperGetMV('ES_CNHTRK',,'CNH4')
Local _aOcoCNH	:= 	Iif(!Empty(_cOcoCNH),&_cOcoCNH,{})
Local _aArea	:= 	GetArea()
Local _aAreaDUA	:= 	DUA->(GetArea())
Local _aAreaDUD	:= 	DUD->(GetArea())
Local _aAreaDT6	:= 	DT6->(GetArea())
Local _aAreaDF0	:= 	DF0->(GetArea())

// ---	Variaveis utilizadas para envio no metodo
Local _aPlanos	:= 	{}
Local _aRet		:=	{}
Local _cColCanc	:=	'false'
Local _cCodCanc	:= 	''
Local _nRspCanc	:= 	0
Local _cChegCol	:= 	''
Local _cSaidCol	:= 	''
Local _cChegDes	:= 	''
Local _cObs		:= 	''
Local _nPos		:= 	0
Local _nCount	:= 	0
Local _lRet		:= 	.t.
Local _lRet214	:= 	.f.
Local _lRet501	:= 	.f.
Local _lRet701	:= 	.f.
Private _nPlanoId	:=	0
Private _nTT		:=	'0100'

// ---	Se os dados da inclusao foram validados
If _nOpcao == 3
	
	// ---	Verifica se as ocorrencias sao de entregas conforme parametros
	_nPos	:=	Ascan( _aOcoCNH, { |x| x == _cCodOco } )
	
	// ---	Se nao é nenhuma das ocorrencias de eventos verifica se existe plano de transporte
	// ---	Transmite a interface 401 atraves da ocorrência CNH4
	If _nPos == 0 .and. _cCodOco == _cOcoTrk
		_lRet		:= 	.T.		
		// ---	Localiza documento de transporte e coleta o agendamento
		/*
		DT6->(dbSetOrder(1))
		If DT6->(dbSeek(xFilial('DT6')+GDFieldGet('DUA_FILDOC',n)+GDFieldGet('DUA_DOC',n)+GDFieldGet('DUA_SERIE',n)))
			
			// ---	Se existe agendamento transmite a interface 401
			DF0->(dbSetOrder(1))
			_nPlanoId	:=	GetAdvFVal("DF0","DF0_PLANID"	,xFilial("DF0")+DT6->DT6_NUMAGD,1,"")
			_nTT		:= 	GetAdvFVal("DF0","DF0_XTT"		,xFilial("DF0")+DT6->DT6_NUMAGD,1,"")

			If  ! Empty(_nPlanoId)
				
				// ---	Envia interface 401
				U_GEFINTCNH('401')
				
				// ---	Chamada da interface que atualiza o status do plano de transporte.
				// ---	Interface701
				_lRet701	:=	U_CNHINT701(_nPlanoId,.t.)
				
			EndIf
			
		EndIf
		
		// ---	Ocorrencias da interface 501
		*/
	Else
		
		// ---	Verifica a sequencia de ocorrencias
		If _cCodOco <> _aOcoCNH[1]
			
			// ---	Localiza qual sequencia esta sendo apontada
			_nPos	:=	Ascan( _aOcoCNH, { |x| x == _cCodOco } )
			
			// ---	Se for a segunda verifica se a primeira ja foi apontada
			If _nPos	==	2
				
				// ---	Pesquisa a ocorrencia
				DUA->(dbSetOrder(3))
				If DUA->(dbSeek(xFilial('DUA')+_aOcoCNH[_nPos-1]+GDFieldGet('DUA_FILDOC',n)+GDFieldGet('DUA_DOC',n)+GDFieldGet('DUA_SERIE',n)))
	
					// ---	Localiza documento de transporte e coleta o agendamento
					DT6->(dbSetOrder(1))
					DT6->(dbSeek(xFilial('DT6')+GDFieldGet('DUA_FILDOC',n)+GDFieldGet('DUA_DOC',n)+GDFieldGet('DUA_SERIE',n)))
			
					// ---	Se existe agendamento transmite a interface 401
					DF0->(dbSetOrder(1))
					_nPlanoId	:=	GetAdvFVal("DF0","DF0_PLANID"	,xFilial('DF0')+DT6->DT6_NUMAGD,1,"")
					_nTT		:= 	GetAdvFVal("DF0","DF0_XTT"		,xFilial('DF0')+DT6->DT6_NUMAGD,1,"")
	
					// ---	Atualiza ocorrencias do primeiro e segundo apontamentos
					_lRet		:= 	.T. // T360GRV01(_cFilOri, _cViagem,_cCodOco,_aOcoCNH)
					_cChegCol	:= 	Dtoc(DUA->DUA_DATOCO)+' '+Transform(DUA->DUA_HOROCO+'00', '@R 99:99:99')
					_cSaidCol	:= 	Dtoc(GDFieldGet('DUA_DATOCO',n))+' '+Transform(GDFieldGet('DUA_HOROCO',n)+'00', '@R 99:99:99')
						
				Else
					// ---	Alerta
					_lRet		:= .f.
					// Help (" ", 1, "CNH501A",,OemToAnsi('Não foi localizada ocorrência '+ CRLF +;
					Help (" ", 1, "CNH214A",,OemToAnsi('Não foi localizada ocorrência '+ CRLF +;					
					GetAdvFVal('DT2','DT2_CODOCO',xFilial('DT2')+_aOcoCNH[_nPos-1],1,'')+ ' - ' +;
					GetAdvFVal('DT2','DT2_DESCRI',xFilial('DT2')+_aOcoCNH[_nPos-1],1,'')), 3, 0)
					
				EndIf
				
				// ---	Unifica as ocorrencias anteriores
			ElseIf _nPos	==	3
				
				// ---	Pesquisa a segunda ocorrencia
				DUA->(dbSetOrder(3))
				If DUA->(dbSeek(xFilial('DUA')+_aOcoCNH[_nPos-1]+GDFieldGet('DUA_FILDOC',n)+GDFieldGet('DUA_DOC',n)+GDFieldGet('DUA_SERIE',n)))
					
					// ---	Atualiza ocorrencias do primeiro e segundo apontamentos
					_cSaidCol	:=  Dtoc(DUA->DUA_DATOCO)+' '+Transform(DUA->DUA_HOROCO+'00', '@R 99:99:99')
					
					// ---	Pesquisa a primeira ocorrencia
					If DUA->(dbSeek(xFilial('DUA')+_aOcoCNH[_nPos-2]+GDFieldGet('DUA_FILDOC',n)+GDFieldGet('DUA_DOC',n)+GDFieldGet('DUA_SERIE',n)))
						
						// ---	Armazena conteudo da operacao anterior
						_cChegCol	:= 	Dtoc(DUA->DUA_DATOCO)+' '+Transform(DUA->DUA_HOROCO+'00', '@R 99:99:99')
						_lRet		:= .t.
					Else
						
						// ---	Alerta
						_lRet		:= .f.
						Help (" ", 1, "CNH214A",,OemToAnsi('Não foi localizada ocorrência '+ CRLF +;
						GetAdvFVal('DT2','DT2_CODOCO',xFilial('DT2')+_aOcoCNH[_nPos-2],1,'')+ ' - ' +;
						GetAdvFVal('DT2','DT2_DESCRI',xFilial('DT2')+_aOcoCNH[_nPos-2],1,'')), 3, 0)
						
					EndIf
					
				Else
					
					// ---	Alerta
					_lRet		:= .f.
					Help (" ", 1, "CNH214A",,OemToAnsi('Não foi localizada ocorrência '+ CRLF + ;
					GetAdvFVal('DT2','DT2_CODOCO',xFilial('DT2')+_aOcoCNH[_nPos-1],1,'')+ ' - ' +;
					GetAdvFVal('DT2','DT2_DESCRI',xFilial('DT2')+_aOcoCNH[_nPos-1],1,'')), 3, 0)
					
				EndIf
				
				// ---	Armazena conteudo da ultima ocorrencia
				_cChegDes	:= 	Dtoc(GDFieldGet('DUA_DATOCO',n))+' '+Transform(GDFieldGet('DUA_HOROCO',n)+'00', '@R 99:99:99')
				
			EndIf
			
		Else
			// 	---	Atualiza somente os dados da primeira variavel
			//	---	Verifica se ja foi apontada a primeira entrada no alvo [Milk run]
			_lRet		:= 	.T. // T360GRV01(_cFilOri, _cViagem,_cCodOco,_aOcoCNH)
			_cChegCol	:= 	Dtoc(GDFieldGet('DUA_DATOCO',n))+' '+Transform(GDFieldGet('DUA_HOROCO',n)+'00', '@R 99:99:99')
			
		EndIf
		
	EndIf
	
	// ---	Se validada transmite a interface
	If _lRet .and. !l360Auto
		
		// --- Exibe a interface com usuario
		If U_CNH214A(@_aRet)
			
			// --- Localiza demais informacoes e preenche variaveis
			_nPlanoId	:=	0
			_cColCanc	:=	Iif( _aRet[1] <> '00', 'true'	, 'false')
			_cCodCanc	:= 	Iif( _aRet[1] <> '00', _aRet[1]	, '' )
			_nRspCanc	:= 	_aRet[2]
			_cObs		:= 	_aRet[3]
			
			// --- Pode ser que na mesma viagem exista mais de uma plano de transporte/agendamento
			DUD->(dbSetOrder(2))
			DUD->(dbSeek(xFilial('DUD')+M->DUA_FILORI+M->DUA_VIAGEM))
			While DUD->( !Eof() ) .and. DUD->DUD_FILIAL == M->DUA_FILIAL .and. DUD->DUD_FILORI == M->DUA_FILORI .and. DUD->DUD_VIAGEM == M->DUA_VIAGEM
				
				// ---	Localiza documento de transporte e coleta o agendamento
				DT6->(dbSetOrder(1))
				DT6->(dbSeek(xFilial('DT6')+DUD->DUD_FILDOC+DUD->DUD_DOC+DUD->DUD_SERIE))
				
				// ---	Busca o agendamento e obtem o plano de transporte
				DF0->(dbSetOrder(1))
				_nPlanoId	:= 	GetAdvFVal("DF0","DF0_PLANID"	,xFilial("DF0")+DT6->DT6_NUMAGD,1,"")
				_nTT		:= 	GetAdvFVal("DF0","DF0_XTT"		,xFilial("DF0")+DT6->DT6_NUMAGD,1,"")
				
				// --- Se nao localizou acrescenta na array para transferir
				_nPos	:= Ascan( _aPlanos, { |x| x == _nPlanoId } )
				If _nPos  == 0
					Aadd( _aPlanos, _nPlanoId )
				EndIf

				// ---	Proximo registro
				DUD->(dbSkip())
				
			EndDo
			
			// ---	Transferir os planos
			/*
			For _nCount	:= 1 to Len(_aPlanos)
				
				// ---	Mensagem de interface com o usuario
				MsgRun(OemToAnsi('Execução de plano de transporte '+AllTrim(Str(_aPlanos[_nCount]))+'...Aguarde!'  ),;
				_cInterface214 , { || _lRet214 := U_CNHOTM214(.F.,_aPlanos[_nCount],_cColCanc,_cCodCanc,_nRspCanc,_cChegCol,_cSaidCol,_cChegDes,_cObs,.f.) } )
				//_cinterface501 , { || _lRet501 := U_CNHINT501(_aPlanos[_nCount],_cColCanc,_cCodCanc,_nRspCanc,_cChegCol,_cSaidCol,_cChegDes,_cObs,.f.) } )
				
	
				
				// --- Aviso de problema na transmissao do plano.
				// If ! _lRet501
				// OTM
				If ! _lRet214				
					// Help (" ", 1, "CNH501A",,OemToAnsi('Problema na transmissao de execucao de plano, consulte o log!'), 3, 0)
					Help (" ", 1, "CNH214A",,OemToAnsi('Problema de execucao de plano, consulte o log!'), 3, 0)					
				EndIf
				
				// ---	Chamada da interface que atualiza o status do plano de transporte.
				// ---	Interface701
				//_lRet701	:=	U_CNHINT701(_aPlanos[_nCount],.t.)
				
			Next 
			*/
		EndIf
		//	---	Execução automática
	
	ElseIf _lRet .and. l360Auto
/*		
		// --- Localiza demais informacoes e preenche variaveis
		_nPlanoId	:=	0
		_cColCanc	:=	'false'
		_cCodCanc	:= 	'00'
		_nRspCanc	:= 	0
		_cObs		:= 	''
		
		// --- Pode ser que na mesma viagem exista mais de uma plano de transporte/agendamento
		DUD->(dbSetOrder(2))
		DUD->(dbSeek(xFilial('DUD')+M->DUA_FILORI+M->DUA_VIAGEM))
		While DUD->( !Eof() ) .and. DUD->DUD_FILIAL == M->DUA_FILIAL .and. DUD->DUD_FILORI == M->DUA_FILORI .and. DUD->DUD_VIAGEM == M->DUA_VIAGEM
			
			// ---	Localiza documento de transporte e coleta o agendamento
			DT6->(dbSetOrder(1))
			DT6->(dbSeek(xFilial('DT6')+DUD->DUD_FILDOC+DUD->DUD_DOC+DUD->DUD_SERIE))
			
			// ---	Busca o agendamento e obtem o plano de transporte
			DF0->(dbSetOrder(1))
			DF0->(dbSeek(xFilial("DF0")+DT6->DT6_NUMAGD))
			_nPlanoId	:= DF0->DF0_PLANID
			_nTT		:= DF0->DF0_XTT
			
			// --- Se nao localizou acrescenta na array para transferir
			_nPos	:= Ascan( _aPlanos, { |x| x == _nPlanoId } )
			If _nPos  == 0
				Aadd( _aPlanos, _nPlanoId )
			EndIf
	
			// ---	Proximo registro
			DUD->(dbSkip())
			
		EndDo
		
		// ---	Transferir os planos
		For _nCount	:= 1 to Len(_aPlanos)
			
			// ---	Mensagem de interface com o usuario
			// ConOut(_cinterface501 + OemToAnsi(' Execucao de plano de transporte '+_cCodOco+' - '+AllTrim( Str(_aPlanos[_nCount]) )) )
			ConOut(_cInterface214 + OemToAnsi(' Execucao de plano de transporte '+_cCodOco+' - '+AllTrim( Str(_aPlanos[_nCount]) )) )			
			//_lRet501 := U_CNHINT501(_aPlanos[_nCount],_cColCanc,_cCodCanc,_nRspCanc,_cChegCol,_cSaidCol,_cChegDes,_cObs,.t.)
			// OTM
			_lRet214 := U_CNHOTM214(.F.,_aPlanos[_nCount],_cColCanc,_cCodCanc,_nRspCanc,_cChegCol,_cSaidCol,_cChegDes,_cObs,.t.)			
		
			// --- Aviso de problema na transmissao do plano.
			// If ! _lRet501
			// OTM
			If ! _lRet214
				Help (" ", 1, "CNH214A",,'Problema na transmissao de execucao de plano, consulte o log!', 3, 0)
			EndIf
			
			// ---	Chamada da interface que atualiza o status do plano de transporte.
			// ---	Interface701
			//_lRet701	:=	U_CNHINT701(_aPlanos[_nCount],.t.)
			
		Next
*/			
	EndIf

EndIf

//	---	Somente grava a data e hora quando for o utimo documento.	
//	---	Se retorno valido para registrar a ocorrencia e transferir para CNH, grava a data e hora
//	---	de previsão real de entrega                                                                 
If _lRet .and. _cCodOco == _aOcoCnh[2]	                                            

	_aDF1Pen	:=	StaticCall(GEFINTCNH, INTCNHTT, GDFieldGet('DUA_DATOCO',n), GDFieldGet('DUA_HOROCO',n), _nTT )
			
	//	---	Seleciona tabela para pesquisa de documento
	DF1->(dbSetOrder(3))
	DF1->(dbSeek(xFilial("DF1")+DUA->DUA_FILDOC+DUA->DUA_DOC+DUA->DUA_SERIE))
	Reclock('DF1',.f.)
	DF1->DF1_XDTPEN	:=	_aDF1Pen[5]
	DF1->DF1_XHRPEN	:=	StrZero(_aDF1Pen[6]*100,4)
	DF1->(msUnLock())
 
Endif

If _lRet //.AND. !_lRet
	// ---	Localiza documento de transporte e coleta o agendamento
	DF1->(dbSetOrder(3))
	DF1->(dbSeek(xFilial('DF1')+GDFieldGet('DUA_FILDOC',n)+GDFieldGet('DUA_DOC',n)+GDFieldGet('DUA_SERIE',n)))
			
	// ---	Se existe agendamento transmite a interface 401
	dbSelectArea("DF0")
	DF0->(dbSetOrder(1))
//	_nPlanoId	:=	GetAdvFVal("DF0","DF0_PLANID",xFilial('DF0')+DF1->DF1_NUMAGE,1,"")
	DF0->(dbSeek(xFilial("DF0")+DF1->DF1_NUMAGE))
	_nPlanoId	:=	DF0->DF0_PLANID

	If Empty(DF0->DF0_CODVEI)
		// MsgInfo('Não há veículo informado no Plano de transporte '+AllTrim(Str(_nPlanoId))+' - 214')
///		MsgAlert('Não há veículo informado no Plano de transporte '+AllTrim(Str(_nPlanoId))+' - 214')	
		Help (" ", 1, "CNH214A",,'Não há veículo informado no Plano de transporte '+AllTrim(Str(_nPlanoId)), 3, 0)
	Else
	 	// _nPlanoId := DF0->DF0_PLANID
		_lRet214  	:= U_CNHOTM214(.F.,_nPlanoID,DF1->DF1_ITEAGE,_cColCanc,_cCodCanc,_nRspCanc,_cChegCol,_cSaidCol,_cChegDes,_cObs,.t.)	
	EndIf

EndIf

// ---	Restaura areas
RestArea(_aArea)
RestArea(_aAreaDT6)
RestArea(_aAreaDUA)
RestArea(_aAreaDUD)
RestArea(_aAreaDF0)

Return


/*/{Protheus.doc} T360GRV01
Função responsável por fazer o controle de envio das ocorrências CNH2 ou CNH1 para interface.
@author	Luiz Alexandre Ferreira
@since 		19/12/2014
@version 	1.0
@param 		_cFilOri, ${param_type}, (Filial de origem)
@param 		_cViagem, ${param_type}, (Numero da viagem)
@param 		_cCodOco, ${param_type}, (Codigo da ocorrência)
@param 		_aOcoCNH, ${param_type}, (Array com as ocorrências CNH)
@return 	${boolean}, ${Variavel boolean referente ao retorno da busca}
@example
(examples)
@see (links_or_references)
/*/Static Function T360GRV01(_cFilOri, _cViagem,_cCodOco,_aOcoCNH)

//	---	Variaveis utilizadas
Local 	_cQuery	:=	''
Local 	_cAlias	:=	''
Local	_lRet		:=	.f.  
Local	_nTotOco	:=	0
Local	_nTotDoc	:=	0
Local	_aDF1Pen	:=	{}
	 
//	---	Primeiro evento
If _cCodOco	==	_aOcoCNH[1]

	// ---	Monta a consulta dos documentos
	_cQuery		:= "SELECT COUNT(*) AS TOTAL " + CRLF
	_cQuery		+= "	FROM" + CRLF
	_cQuery		+= RetSqlName("DUA") + CRLF
	_cQuery		+= "WHERE " + CRLF
	_cQuery		+= "DUA_FILORI = '"+_cFilOri+"' AND " + CRLF
	_cQuery		+= "DUA_CODOCO = '"+_cCodOco+"' AND " + CRLF
	_cQuery		+= "DUA_VIAGEM = '"+_cViagem+"' AND " + CRLF
	_cQuery		+= "D_E_L_E_T_ = ' '"
	
	// --- Cria area de trabalho temporaria
	_cAlias		:= GetNextAlias()
	_cQuery 	:= ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias)
	
	//	---	Tratamento de retorno
	_lRet	:=	Iif ( (_cAlias)->TOTAL >= 1, .t., .f. )
	
	//	---	Segundo evento
ElseIf	_cCodOco	==	_aOcoCNH[2]

	// ---	Monta a consulta dos documentos
	_cQuery		:= 	"SELECT COUNT(*) AS TOTOCO " + CRLF
	_cQuery		+= 	"	FROM" + CRLF
	_cQuery		+= 	RetSqlName("DUA") + CRLF
	_cQuery		+= 	"WHERE " + CRLF
	_cQuery		+= 	"	DUA_FILORI = '"+_cFilOri+"' AND " + CRLF
	_cQuery		+= 	"	DUA_CODOCO = '"+_cCodOco+"' AND " + CRLF
	_cQuery		+= 	"	DUA_VIAGEM = '"+_cViagem+"' AND " + CRLF  
	_cQuery		+=	"	DUA_FILDOC <> '' AND " + CRLF
	_cQuery		+=	"	DUA_DOC <> '' AND	" + CRLF
	_cQuery		+=	"	DUA_SERIE <> '' AND " + CRLF 
	_cQuery		+= 	"D_E_L_E_T_ = ' '"
	
	// --- Cria area de trabalho temporaria
	_cAlias		:= GetNextAlias()
	_cQuery 	:= ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias)     
	
	_nTotOco	:=	(_cAlias)->TOTOCO		

	//	---	Fecha area de trabalho
	(_cAlias)->(dbCloseArea())
	
	//	---	Conta documentos da viagem
	_cQuery		:= 	"SELECT COUNT(*) AS TOTDOC " + CRLF
	_cQuery		+= 	"	FROM" + CRLF
	_cQuery		+= 	RetSqlName("DUD") + CRLF
	_cQuery		+= 	"WHERE " + CRLF
	_cQuery		+= 	"DUD_FILIAL = '"+''+"' AND " + CRLF
	_cQuery		+= 	"DUD_FILORI = '"+_cFilOri+"' AND " + CRLF
	_cQuery		+= 	"DUD_VIAGEM = '"+_cViagem+"' AND " + CRLF  
	_cQuery		+= 	"D_E_L_E_T_ = ' '"
	
	// --- Cria area de trabalho temporaria
	_cAlias		:= GetNextAlias()
	_cQuery 	:= ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias)     
	
	//	---	Quantidade de documentos da viagem
	_nTotDoc	:=	(_cAlias)->TOTDOC		
               
	//	---	Retorna variavel para validar a ocorrencia
	_lRet		:=	(_nTotDoc == _nTotOco)
	
EndIf     

//	---	Fecha area de trabalho
(_cAlias)->(dbCloseArea())

Return _lRet
