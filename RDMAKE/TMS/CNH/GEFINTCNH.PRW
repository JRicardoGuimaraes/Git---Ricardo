#include 'TOTVS.CH'
#include 'APWEBSRV.CH'
#include 'XMLXFUN.CH'
#include 'Tbiconn.ch'
#include 'ap5mail.ch'

#define _cinterface055	'WS Interface055'
#define _cinterface060	'WS Interface060'
#define _cinterface101	'WS Interface101'
#define _cinterface201	'WS Interface201'
#define _cinterface301	'WS Interface301'
#define _cinterface401	'WS Interface401'
#define _cinterface501	'WS Interface501'
#define _cinterface601	'WS Interface601'
#define _cinterface701	'WS Interface701'
#define _cinterface901	'WS Interface901'

STATIC _cPalavrapasse:=	GetMV('ES_CNHPASS')
STATIC _nKmFaixa		:=	GetMV('ES_CNHFXAK')
STATIC _aCNHOco			:=	GetMV('ES_CNHOCO')
STATIC _aPlanos			:= 	{}
STATIC	_aPlanosView	:= 	{}
STATIC	_aLog			:= 	{}
STATIC cError			:= 	''
STATIC	cWarning		:= 	''
STATIC _cMotivo 		:= 	''
STATIC _cObs	 		:= 	Space(40)
STATIC _nTipo			:= 	0
STATIC _nPlanoId		:=	0
STATIC _aTipoPlano	:= 	{ '1' }

/*/{Protheus.doc} GEFINTCNH
Função principal da rotina para processamento dos WEB Service CNH/IVECO
@author 	Luiz Alexandre Ferreira
@since 		30/09/2014
@version 	1.0
@param 		${_cId}, ${Char}, ${Código da interface}
@param 		${_lAuto}, ${Boolean},${Define se executa a rotina manual ou automático}
@param 		${_cParam}, ${Char},${Parametro generico a ser tratado em interfaces especificas}
@return 	${Nil}, ${Nenhuma}
@example
GEFINTCNH('55',.F.)
@see 		(links_or_references)
/*/User Function GEFINTCNH(_cId,_lAuto,_cControle)
// --- Variaveis utilizadas
Local _nDia		:=	0
Local _nMes		:=	0
Local _nAno		:=	0
Local _lRet		:=	.f.
Local _nPos		:=	0
Local _nPosFil	:=	0
Local _nX			:=	0
Local _aRet		:=	{}
Local _lCentury	:= __SetCentury()

// ---	Variaveis interface401
Local _cnroSID,_ccodigoStatus,_cObs	:= ''

// ---	Variaveis interface601
Local _cQuery		:= 	''
Local _cAlias		:= 	''
Local _cAliasDF0	:= 	''
Local _cNumAge		:=	''
Local _nPlanoId		:=	0

// ---	Variaveis para chamada de rotinas externas
Local _cOldFunName	:=	''

// ---	A variavel de automacao só será considerada quando passada
DEFAULT _lAuto		:=	.f.
DEFAULT _cControle	:=	''

_aLog	:=	{}

// ---	Força o ano no formato de 4 digitos.
If !_lCentury
	SET CENTURY ON
EndIf

CHKFILE("SM4")

// ---	Interface055
If _cId	== '55'
	
	// --- Nao automatico
	If ! _lAuto
		
		// --- Atualiza o cadastro de perguntas
		If INT055SX1()
			_nDia	:= Day(Mv_par01)
			_nMes	:= Month(Mv_par01)
			_nAno	:= Year(Mv_par01)
			
			MsgRun(OemToAnsi('Localizando planos de transporte...Aguarde!'  ), _cinterface055 , { || _lRet := U_CNHINT055(_nDia,_nMes,_nAno,.f.) })
			
			// --- Processa a rotina principal.
			If _lRet
				// ---
				Processa( {|| U_CNHINT060(_aPlanos,_lAuto) }, "Processando...", "Plano de transporte...",.F.)
			Else
				// --- Informa que nao localizou plano de transporte
				Alert('Não existe planos de transporte para a data informada!')
			EndIf
			
		Else
			Return
		EndIf
	Else
		
		// ---	Executa a importação automática
		_nDia	:= Day(dDataBase)
		_nMes	:= Month(dDataBase)
		_nAno	:= Year(dDataBase)
		
		// ---	Mensagem no console
		ConOut(OemToAnsi(_cinterface055+' - Localizando planos de transporte em ['+Dtoc(dDataBase)+'] : '+Time()+'...Aguarde!'))
		_lRet := U_CNHINT055(_nDia,_nMes,_nAno,_lAuto)
		
		// --- Processa a rotina principal.
		If _lRet
			U_CNHINT060(_aPlanos,_lAuto)
		Else
			// --- Informa que nao localizou plano de transporte
			ConOut(OemToAnsi(_cinterface055+' - Não existe planos de transporte para a data informada!'))
		EndIf
		
	EndIf
	// ---	Aceite do plano de transportes - interface101
ElseIf _cId	== '101'
	
	// --- Verifica se foi por rotina automatica
	If ! _lAuto
		
		// --- 	Envia o plano de transporte posicionado no browse
		_nPlanoId	:= DF0->DF0_PLANID
		
		// ---	Exibe mensagem de execucao
		MsgRun(OemToAnsi('Transmitindo aceite do plano de transporte '+AllTrim(Str(_nPlanoId))+'...Aguarde!'  ), _cinterface101 , { || _lRet := U_CNHINT101(_nPlanoId,.f.) })
		
		// --- Tratamento de acordo com retorno do Web Service
		Iif ( _lRet, alert('Plano de transporte '+AllTrim(Str(_nPlanoId))+' ACEITE !'), alert('Plano de transporte '+AllTrim(Str(_nPlanoId))+' NÃO ACEITE !') )
		
		// --- Grava log e define status de gravacao do plano
		If _lRet
			
			// --- Altera conteudo do status a partir do retorno
			_nPos 		:= 	Ascan( aHeader, { |x| x[2] = 'DF1_STACOL' })
			_nPosFil	:=	Ascan( aHeader, { |x| x[2] = 'DF1_FILORI' })
			
			For _nX := 1 to Len(aCols)
				aCols[_nX,_nPos]		:= '2'
				aCols[_nX,_nPosFil]	:= cFilAnt
				GDFieldPut("DF1_STACOL",'2',_nX)
				GDFieldPut("DF1_FILORI",cFilAnt,_nX)
			Next _nX
			
			aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface101, dDataBase, Time() ,'Aceite plano!', 'Plano de transporte aceito!', UsrRetName(RetCodUsr()), '1' } )
		Else
			aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface101, dDataBase, Time() ,'Aceite plano!', 'Plano de transporte nao aceito!', UsrRetName(RetCodUsr()), '0' } )
		EndIf
		
		// ---	Grava log do processo de trasmissão da interface101
		INTCNHGLOG(_aLog)
		
	Else
		
	EndIf
	
	// ---	Chamada da interface que atualiza o status do plano de transporte.
	If	_lRet
		
		// ---	Interface701
		_lRet	:=	U_CNHINT701(_nPlanoId,.t.)
		
	EndIf
	
	// ---	Informar dados do veiculo - interface201
ElseIf _cId	== '201'
	
	// --- Verifica se foi por rotina automatica
	If ! _lAuto
		
		// --- 	Envia o plano de transporte posicionado no browse
		_nPlanoId	:= DF0->DF0_PLANID
		
		// ---	Exibe mensagem de execucao
		MsgRun(OemToAnsi('Transmitindo dados do veículo '+AllTrim(Str(_nPlanoId))+'...Aguarde!'  ), _cinterface201 , { || _lRet := U_CNHINT201(_nPlanoId,.f.) })
		
		// --- Tratamento de acordo com retorno do Web Service
		Iif ( _lRet, alert(_cinterface201+' - Dados do veículo '+AllTrim(Str(_nPlanoId))+' transmitido com sucesso!'), alert(_cinterface201+' - Dados do veículo '+AllTrim(Str(_nPlanoId))+' não transmitido !') )
		
		// --- Grava log e define status de gravacao do plano
		If _lRet
			aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface201, dDataBase, Time() ,'Dados do veiculo', 'Dados do veículo transmitido na data/hora!', UsrRetName(RetCodUsr()),'1' } )
		Else
			aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface201, dDataBase, Time() ,'Dados do veiculo', 'Dados do veículo não transmitido na data/hora!', UsrRetName(RetCodUsr()),'0' } )
		EndIf
		
		// ---	Grava log do processo de trasmissão da interface101
		INTCNHGLOG(_aLog)
		
	Else
		
	EndIf
	
	// ---	Chamada da interface que atualiza o status do plano de transporte.
	If	_lRet
		
		// ---	Interface701
		_lRet	:=	U_CNHINT701(_nPlanoId,.t.)
		
	EndIf
	
	
	// ---	Informar declinio - interface301
ElseIf _cId	== '301'
	
	// --- Verifica se foi por rotina automatica
	If ! _lAuto
		
		// ---	Plano de transporte
		_nPlanoId	:= DF0->DF0_PLANID
		
		// ---	Exibe tela para receber o motivo do declinio
		If CNHINT301A(_nPlanoId,_lAuto)
			
			// ---	Exibe mensagem de execucao
			MsgRun(OemToAnsi('Transmitindo declinio do plano de transporte '+AllTrim(Str(_nPlanoId))+'...Aguarde!'  ), _cinterface301 , { || _lRet := U_CNHINT301(_nPlanoId,.f.) })
			
			// --- Tratamento de acordo com retorno do Web Service
			Iif ( _lRet, alert(_cinterface301+' - Declinio do Plano de transporte '+AllTrim(Str(_nPlanoId))+' ACEITE !'), alert(_cinterface301+' - Declinio do Plano de transporte '+AllTrim(Str(_nPlanoId))+' NÃO ACEITE !') )
			
			// --- Grava log e define status de gravacao do plano
			If _lRet
				
				// ---	Cancela o plano de transporte
				RecLock('DF0',.f.)
				// --- Prepara para gravar o campo Memo
				_mMSMOBS			:= CriaVar('DF0_CODOBC')
				
				// ---	Se nao foi informada observacao busca pelo motivo conforme tabela
				If Empty(_cObs)
					SX5->(dbSetOrder(1))
					SX5->(dbSeek(xFilial('SX5')+'ZV'+_cMotivo))
					_mMSMOBS			:= X5Descri()
				Else
					_mMSMOBS			:= _cObs
				EndIf
				DF0->DF0_CODOBC		:= MSMM(,,,_mMSMOBS,1,,,'DF0','DF0_CODOBC')
				DF0->(MsUnLock())
				
				// --- Grava o log da transacao
				aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface301, dDataBase, Time() ,'Declinio', 'Declinio do plano de transporte aceite na data/hora! ['+_cMotivo+'] - ['+Trim(_cObs)+']', UsrRetName(RetCodUsr()), '1' } )
				
			Else
				// --- Grava o log da transacao
				aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface301, dDataBase, Time() ,'Declinio', 'Declinio do plano de transporte nao aceite na data/hora! ['+_cMotivo+'] - ['+Trim(_cObs)+']', UsrRetName(RetCodUsr()), '0' } )
			EndIf
			
			// ---	Grava log do processo de trasmissão da interface101
			INTCNHGLOG(_aLog)
			
			// ---	Chamada da interface que atualiza o status do plano de transporte.
			// ---	Interface701
			_lRet	:=	U_CNHINT701(_nPlanoId,.t.)
			
		EndIf
		
	Else
		
	EndIf
	
	// ---	Informar dados do veiculo - interface201
ElseIf _cId	== '401'
	
	// --- Verifica se foi por rotina automatica
	If ! _lAuto
		
		// ---	Verifica retorno da tela de parametros
		If U_CNH401A(@_aRet)
			
			// --- Localiza demais informacoes e preenche variaveis
			_nPlanoId		:=	0
			_cnroSID		:=	''
			_ccodigoStatus	:=	_aRet[1]
			_cObs			:= 	_aRet[2]
			
			// --- Pode ser que na mesma viagem exista mais de uma plano de transporte/agendamento
			DUD->(dbSetOrder(2))
			DUD->(dbSeek(xFilial('DUD')+M->DUA_FILORI+M->DUA_VIAGEM))
			While DUD->( !Eof() ) .and. DUD->DUD_FILIAL == M->DUA_FILIAL .and. DUD->DUD_FILORI == M->DUA_FILORI .and. DUD->DUD_VIAGEM == M->DUA_VIAGEM
				
				// ---	Localiza documento de transporte e coleta o agendamento
				DT6->(dbSetOrder(1))
				DT6->(dbSeek(xFilial('DT6')+DUD->DUD_FILDOC+DUD->DUD_DOC+DUD->DUD_SERIE))
				
				// ---	Busca o agendamento e obtem o plano de transporte
				_nPlanoId	:= GetAdvFVal('DF0','DF0_PLANID',xFilial('DF0')+DT6->DT6_NUMAGD,1,"")
				
				// --- Se nao localizou acrescenta na array para transferir
				_nPos	:= Ascan( _aPlanos, { |x| x == _nPlanoId } )
				
				// ---	Somente se encontrou plano de transporte.
				If _nPos  == 0 .and. _nPlanoId > 0
					Aadd( _aPlanos, _nPlanoId )
				EndIf
				
				// ---	Proximo registro
				DUD->(dbSkip())
				
			EndDo
			
			// ---	Transferir os planos
			If Len(_aPlanos) > 0
				
				For _nPos	:= 1 to Len(_aPlanos)
					
					// ---	Exibe mensagem de execucao
					MsgRun(OemToAnsi('Transmitindo status do plano '+AllTrim(Str(_nPlanoId))+'...Aguarde!'  ), _cinterface401 , { || _lRet := U_CNHINT401(_nPlanoId,_cnroSID,_ccodigoStatus,_cObs,.f.) })
					
					// --- Aviso de problema na transmissao do plano.
					If !_lRet
						Alert('Problema na transmissao de execucao de plano, consulte log!')
					EndIf
					
					// --- Tratamento de acordo com retorno do Web Service
					Iif ( _lRet, alert(_cinterface401+' - Status do plano '+AllTrim(Str(_nPlanoId))+' transmitido com sucesso!'), alert(_cinterface401+' - Status do plano '+AllTrim(Str(_nPlanoId))+' não transmitido !') )
					
					// --- Grava log e define status de gravacao do plano
					If _lRet
						aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface401, dDataBase, Time() ,'Status do plano', 'Status do plano transmitido na data/hora!', UsrRetName(RetCodUsr()),'1' } )
					Else
						aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface401, dDataBase, Time() ,'Status do plano', 'Status do plano não transmitido na data/hora!', UsrRetName(RetCodUsr()),'0' } )
					EndIf
					
				Next _nX
				
				// ---	Grava log do processo de trasmissão da interface101
				INTCNHGLOG(_aLog)
				
			EndIf
			
		EndIf
		
	Else
		
	EndIf
	
	// ---	Execução do plano - interface501
ElseIf _cId	== '501'
	
	// --- Verifica se foi por rotina automatica
	If ! _lAuto
		
		// --- 	Envia o plano de transporte posicionado no browse
		_nPlanoId	:= DF0->DF0_PLANID
		
		// ---	Exibe mensagem de execucao
		MsgRun(OemToAnsi('Transmitindo execução do plano '+AllTrim(Str(_nPlanoId))+'...Aguarde!'  ), _cinterface501 , { || _lRet := U_CNHINT501(_nPlanoId,.f.) })
		
		// --- Tratamento de acordo com retorno do Web Service
		Iif ( _lRet, alert(_cinterface501+' - Execução do plano '+AllTrim(Str(_nPlanoId))+' transmitido com sucesso!'), alert(_cinterface501+' - Execução do plano '+AllTrim(Str(_nPlanoId))+' não transmitido !') )
		
		// --- Grava log e define status de gravacao do plano
		If _lRet
			aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface501, dDataBase, Time() ,'Execução do plano', 'Execução do plano transmitido na data/hora!', UsrRetName(RetCodUsr()),'1' } )
		Else
			aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface501, dDataBase, Time() ,'Execução do plano', 'Execução do plano não transmitido na data/hora!', UsrRetName(RetCodUsr()),'0' } )
		EndIf
		
		// ---	Grava log do processo de trasmissão da interface101
		INTCNHGLOG(_aLog)
		
	Else
		
	EndIf
	
	// ---	Informar faturamento - interface601
ElseIf _cId	== '601'
	
	// --- Verifica se foi por rotina automatica
	If ! _lAuto
		
		// --- 	Envia o plano de transporte posicionado no browse
		dbSelectArea('DF0')
		_nPlanoId	:= 	DF0->DF0_PLANID
		_cNumAge	:=	DF0->DF0_NUMAGE
		
		// ---	Monta a consulta dos documentos
		_cQuery		:= "SELECT" + CRLF
		_cQuery		+= "DF0.DF0_NUMAGE," + CRLF
		_cQuery		+= "DF0.DF0_PLANID," + CRLF
		_cQuery		+= "DF1.DF1_NUMAGE," + CRLF
		_cQuery		+= "DF1.DF1_ITEAGE," + CRLF
		_cQuery		+= "DT6.DT6_NUMAGD," + CRLF
		_cQuery		+= "DT6.DT6_ITEAGD," + CRLF
		_cQuery		+= "DT6.DT6_FILIAL," + CRLF
		_cQuery		+= "DT6.DT6_FILDOC," + CRLF
		_cQuery		+= "DT6.DT6_LOTNFC," + CRLF
		_cQuery		+= "DT6.DT6_DOCTMS," + CRLF
		_cQuery		+= "DT6.DT6_DOC," + CRLF
		_cQuery		+= "DT6.DT6_SERIE," + CRLF
		_cQuery		+= "DT6.DT6_DATEMI," + CRLF
		_cQuery		+= "DT6.DT6_VALFRE," + CRLF
		_cQuery		+= "DT6.DT6_VALIMP," + CRLF
		_cQuery		+= "DT6.DT6_VALTOT" + CRLF
		_cQuery		+= "	FROM" + CRLF
		_cQuery		+= RetSqlName("DF0") + " DF0" + CRLF
		_cQuery		+= "    INNER JOIN " + RetSqlName("DF1") + " DF1" + CRLF
		_cQuery		+= "	ON DF1.DF1_FILIAL = DF0.DF0_FILIAL AND " + CRLF
		_cQuery		+= "    DF1.DF1_NUMAGE = DF0.DF0_NUMAGE AND " + CRLF
		_cQuery		+= "    DF1.D_E_L_E_T_ = ' ' " + CRLF
		_cQuery		+= "	INNER JOIN " + RetSqlName("DT6") + " DT6" + CRLF
		_cQuery		+= "    ON DT6.DT6_FILIAL = DF1.DF1_FILIAL AND " + CRLF
		_cQuery		+= "    DT6.DT6_NUMAGD = DF1.DF1_NUMAGE AND " + CRLF
		_cQuery		+= "	DT6.DT6_ITEAGD = DF1.DF1_ITEAGE AND " + CRLF
		_cQuery		+= "	DT6.DT6_DOCTMS <> '1' AND " + CRLF
		_cQuery		+= "	DT6.D_E_L_E_T_ = ' ' " + CRLF
		_cQuery		+= "WHERE " + CRLF
		_cQuery		+= "DF0.DF0_NUMAGE = '"+_cNumAge+"' AND " + CRLF
		_cQuery		+= "DF0.D_E_L_E_T_ = ' '"
		
		// --- Cria area de trabalho temporaria
		_cAlias	:= GetNextAlias()
		_cQuery 	:= ChangeQuery(_cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias)
		
		// ---	Tipo de dados
		TCSetField( (_cAlias), "DT6_DATEMI", "D", 8, 0 )
		
		//	---	{2LGI} 19/03/2015
		//	---	Para a transmissao manual exibe para conferencia os documentos associados ao plano de transporte antes de enviar a interface
		If AllTrim(DF0->DF0_CNHID) == '36'
			
			//	---	Retorna para inicio do arquivo
			(_cAlias)->( dbGotop() )
			If (_cAlias)->( Eof() )
				MsgAlert(_cinterface601 + ', Não existe CT-e associtado para o plano ' + AllTrim(Str(_nPlanoId)), 'Sem CT-e! - '+_cinterface601	)
				(_cAlias)->(dbCloseArea())
				Return
			EndIf
			
			//	---	Caso o usuário não confirme os documentos a interface não será transmitida.
			If ! CNH601A(_cAlias)
				MsgAlert(_cinterface601 +' para o plano ' + AllTrim(Str(_nPlanoId)) +' não transmitida, cancelado pelo usuário!', 'Não transmitida! - '+_cinterface601	)
				(_cAlias)->(dbCloseArea())
				Return
			EndIf
			
		Else
			MsgAlert(OemtoAnsi('Somente status Execução Validada pode enviar essa interface!'),'Interface601')
			(_cAlias)->(dbCloseArea())
			Return
		EndIf
		
		//	---	Retorna para inicio do arquivo
		(_cAlias)->(dbGoTop())
		// --- Verifica se houve retorno
		If (_cAlias)->( !  Eof())
			
			// ---	Exibe mensagem de execucao
			MsgRun(OemToAnsi('Transmitindo faturamento do plano '+AllTrim(Str(_nPlanoId))+'...Aguarde!'  ), _cinterface601 , { || _lRet := U_CNHINT601(_nPlanoId,_cAlias,.f.) })
			
			// --- Tratamento de acordo com retorno do Web Service
			Iif ( _lRet, MsgInfo(_cinterface601+' - Faturamento do plano '+AllTrim(Str(_nPlanoId))+' transmitido com sucesso!', 'Ok! - '+_cinterface601	), MsgStop(_cinterface601+' - Faturamento do plano '+AllTrim(Str(_nPlanoId))+' não transmitido !', 'Erro - '+_cinterface601 ) )
			
			// --- Grava log e define status de gravacao do plano
			If _lRet
				aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface601, dDataBase, Time() ,'Faturamento do plano', 'Faturamento do plano transmitido na data/hora!', UsrRetName(RetCodUsr()),'1' } )
			Else
				aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface601, dDataBase, Time() ,'Faturamento do plano', 'Faturamento do plano não transmitido na data/hora!', UsrRetName(RetCodUsr()),'0' } )
			EndIf
			
			// ---	Grava log do processo de trasmissão da interface101
			INTCNHGLOG(_aLog)
			
			// ---	Chamada da interface que atualiza o status do plano de transporte.
			// ---	Interface701
			_lRet	:=	U_CNHINT701(_nPlanoId,.t.)
			
		EndIf
		
		// ---	Fecha area de trabalho
		(_cAlias)->(dbCloseArea())
		
	Else
		
		// ---	Espaço para execução via Job
		//-- Por: Ricardo - Em: 14/04/2015 - 
		//_cQuery		:=	"SELECT TOP(1) " + CRLF
		_cQuery		:=	"SELECT " + CRLF		
		_cQuery		+=	"DF0_PLANID," + CRLF
		_cQuery		+=	"DF0_NUMAGE" + CRLF
		_cQuery		+=	"FROM " + CRLF
		_cQuery		+=	RetSqlName("DF0") + " DF0 " + CRLF
		_cQuery		+=	"WHERE " + CRLF
		_cQuery		+=	"DF0_CNHID = '36' AND " + CRLF
		_cQuery		+=	"DF0_STWS = '' AND " + CRLF
		_cQuery		+=	"D_E_L_E_T_ = ' '"
		
		// --- Cria area de trabalho temporaria
		_cAliasDF0	:=	GetNextAlias()
		_cQuery 	:= 	ChangeQuery(_cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliasDF0)
		CONOUT("(RICARDO) Inicio de processamento em lote 601." )
		
		// ---	Verifica se houve retorno
		If (_cAliasDF0)->( !  Eof())
			
			// Por: Ricardo Guimarães - Em: 14/04/205
			// Objetivo: Fazer loop para enviar todos os CNHID=36
			While (_cAliasDF0)->( !Eof())
				_nPlanoId	:= (_cAliasDF0)->DF0_PLANID
				
				// ---	Monta a consulta dos documentos
				_cQuery		:= "SELECT" + CRLF
				_cQuery		+= "DF0.DF0_NUMAGE," + CRLF
				_cQuery		+= "DF0.DF0_PLANID," + CRLF
				_cQuery		+= "DF1.DF1_NUMAGE," + CRLF
				_cQuery		+= "DF1.DF1_ITEAGE," + CRLF
				_cQuery		+= "DT6.DT6_NUMAGD," + CRLF
				_cQuery		+= "DT6.DT6_ITEAGD," + CRLF
				_cQuery		+= "DT6.DT6_FILIAL," + CRLF
				_cQuery		+= "DT6.DT6_FILDOC," + CRLF
				_cQuery		+= "DT6.DT6_LOTNFC," + CRLF
				_cQuery		+= "DT6.DT6_DOCTMS," + CRLF
				_cQuery		+= "DT6.DT6_DOC," + CRLF
				_cQuery		+= "DT6.DT6_SERIE," + CRLF
				_cQuery		+= "DT6.DT6_DATEMI," + CRLF
				_cQuery		+= "DT6.DT6_VALFRE," + CRLF
				_cQuery		+= "DT6.DT6_VALIMP," + CRLF
				_cQuery		+= "DT6.DT6_VALTOT" + CRLF
				_cQuery		+= "	FROM" + CRLF
				_cQuery		+= RetSqlName("DF0") + " DF0" + CRLF
				_cQuery		+= "    INNER JOIN " + RetSqlName("DF1") + " DF1" + CRLF
				_cQuery		+= "	ON DF1.DF1_FILIAL = DF0.DF0_FILIAL AND " + CRLF
				_cQuery		+= "    DF1.DF1_NUMAGE = DF0.DF0_NUMAGE AND " + CRLF
				_cQuery		+= "    DF1.D_E_L_E_T_ = ' ' " + CRLF
				_cQuery		+= "	INNER JOIN " + RetSqlName("DT6") + " DT6" + CRLF
				_cQuery		+= "    ON DT6.DT6_FILIAL = DF1.DF1_FILIAL AND " + CRLF
				_cQuery		+= "    DT6.DT6_NUMAGD = DF1.DF1_NUMAGE AND " + CRLF
				_cQuery		+= "	DT6.DT6_ITEAGD = DF1.DF1_ITEAGE AND " + CRLF
				_cQuery		+= "	DT6.DT6_DOCTMS <> '1' AND " + CRLF
				_cQuery		+= "	DT6.D_E_L_E_T_ = ' ' " + CRLF
				_cQuery		+= "WHERE " + CRLF
				_cQuery		+= "DF0.DF0_NUMAGE = '"+(_cAliasDF0)->DF0_NUMAGE+"' AND " + CRLF
				_cQuery		+= "DF0.D_E_L_E_T_ = ' '"
				
				// --- Cria area de trabalho temporaria
				_cAlias		:= GetNextAlias()
				_cQuery 	:= ChangeQuery(_cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias)
				
				// ---	Tipo de dados
				TCSetField( (_cAlias), "DT6_DATEMI", "D", 8, 0 )
				
				// --- Verifica se houve retorno
				If (_cAlias)->( !  Eof())
					
					// ---	Transmite a interface601
					_lRet := U_CNHINT601(_nPlanoId,_cAlias,.t.)
					
					// --- Tratamento de acordo com retorno do Web Service
					Iif ( _lRet, ConOut(_cinterface601+' - Faturamento do plano '+AllTrim(Str(_nPlanoId))+' transmitido com sucesso!'), ConOut(_cinterface601+' - Faturamento do plano '+AllTrim(Str(_nPlanoId))+' não transmitido !' ) )
					
					// --- Grava log e define status de gravacao do plano
					If _lRet
						aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface601, dDataBase, Time() ,'Faturamento do plano', 'Faturamento do plano transmitido na data/hora!', UsrRetName(RetCodUsr()),'1' } )
					Else
						aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface601, dDataBase, Time() ,'Faturamento do plano', 'Faturamento do plano não transmitido na data/hora!', UsrRetName(RetCodUsr()),'0' } )
					EndIf
					
					// ---	Grava log do processo de trasmissão da interface101
					INTCNHGLOG(_aLog)
					
					// ---	Chamada da interface que atualiza o status do plano de transporte.
					// ---	Interface701
					_lRet	:=	U_CNHINT701(_nPlanoId,.t.)
					
				Else
					
					// ---	Mensagem de ocorrência da execução da rotina
					ConOut(_cinterface601+', Não existe CT-e associtado para o plano '+AllTrim(Str(_nPlanoId)) )
					
					// ---	Adiciona mensagem no log
					aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface601, dDataBase, Time() ,'Faturamento do plano', 'Faturamento do plano não transmitido na data/hora!', UsrRetName(RetCodUsr()),'0' } )
					
					// ---	Grava flag para o plano nao travar o processo de envio
					// ---	Esses casos serao tratados manualmente
					DF0->(dbSetOrder(3))
					DF0->(dbSeek(xFilial('DF0')+Str(_nPlanoId,TamSx3('DF0_PLANID')[1],0)))
					RecLock('DF0',.f.)
					DF0->DF0_STWS	:= '0'
					DF0->(msUnLock())
					
					// ---	Grava log do processo de trasmissão da interface101
					INTCNHGLOG(_aLog)
					
					// ---	Chamada da interface que atualiza o status do plano de transporte.
					// ---	Interface701
					_lRet	:=	U_CNHINT701(_nPlanoId,.t.,'35') 
					
					
				EndIf
				
				//	---	 Fecha as areas de trabalho
				(_cAlias)->(dbCloseArea())
				
				(_cAliasDF0)->(dbSkip())
			End					
		Else
				
			// ---	Mensagem de ocorrência da execução da rotina
			ConOut(_cinterface601+', Não há planos de transporte no status Execução Validada em '+Dtoc(dDataBase)+ ' as '+Time())
		EndIf

			
		//	---	 Fecha as areas de trabalho
		(_cAliasDF0)->(dbCloseArea())      
		CONOUT("(RICARDO) Final de processamento em lote 601." )
			
	EndIf
	
	// ---	Buscar status do plano interface701
ElseIf _cId	== '701'
	
	// --- Verifica se foi por rotina automatica
	If ! _lAuto
		
		// --- 	Envia o plano de transporte posicionado no browse
		_nPlanoId	:= DF0->DF0_PLANID
		
		// ---	Exibe mensagem de execucao
		MsgRun(OemToAnsi('Consultando status do plano de transporte '+AllTrim(Str(_nPlanoId))+'...Aguarde!'  ), _cinterface701 , { || _lRet := U_CNHINT701(_nPlanoId,.f.) } )
		
	Else
		
		// ---	Espaço para execução via Job   
		// Comentado por Ricardo - Em: 14/04/2015
		// _cQuery		:=	"SELECT TOP(1) " + CRLF
		_cQuery		:=	"SELECT " + CRLF		
		_cQuery		+=	"DF0_PLANID," + CRLF
		_cQuery		+=	"DF0_NUMAGE" + CRLF
		_cQuery		+=	"FROM " + CRLF
		_cQuery		+=	RetSqlName("DF0") + " DF0 " + CRLF
		_cQuery		+=	"WHERE " + CRLF
		_cQuery		+=	"DF0_CNHID = '" + _cControle + "' AND " + CRLF
		_cQuery		+=	"DF0_STWS = ' ' " + CRLF
		_cQuery		+=	"AND D_E_L_E_T_ = ' '"
		
		// --- Cria area de trabalho temporaria
		_cAlias		:=	GetNextAlias()
		_cQuery 		:= 	ChangeQuery(_cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias)

		CONOUT("(RICARDO) Inicio de processamento em lote 701." )
		
		// ---	Verifica se houve retorno
		If (_cAlias)->( !  Eof())
			// Por: Ricardo Guimaraes - Em: 14/04/2015
			// Objetio Loop para processar todos em único processo
			While (_cAlias)->( !  Eof())
				//	--- Obtem o numero do plano de transporte
				_nPlanoId	:= (_cAlias)->DF0_PLANID
			
				// ---	Exibe mensagem de execucao
				_lRet := U_CNHINT701(_nPlanoId,.t.,_cControle)
				CONOUT("(RICARDO) Processando o plano : " + Str(_nPlanoId) )
				
				(_cAlias)->(dbSkip())
				
			End
			
		EndIf
		
		//	--- Fecha area de trabalho
		(_cAlias)->(dbCloseArea())
		CONOUT("(RICARDO) Final de processamento em lote 701." )
	EndIf
	
	// --- Pesquisa de movimentacao - interface901
ElseIf _cId	== '901'
	
	// --- Verifica se foi por rotina automatica
	If ! _lAuto
		
		// --- 	Envia o plano de transporte posicionado no browse
		_nPlanoId	:= DF0->DF0_PLANID
		// ---	Exibe mensagem de execucao
		MsgRun(OemToAnsi('Movimentação do plano de transporte '+AllTrim(Str(_nPlanoId))+'...Aguarde!'  ), _cinterface901 , { || _lRet := U_CNHINT901(_nPlanoId,.f.) } )
		
	Else
		
	EndIf
	// ---	Opção criada para informar as ocorrências de viagem
ElseIf _cId	== '999'
	
	// ---	Monta query para localizar os registros
	_cQuery := "  SELECT " + CRLF
	_cQuery += "     DTQ.R_E_C_N_O_ DTQREC, DTQ.DTQ_FILORI FILORI, DTQ.DTQ_VIAGEM VIAGEM" + CRLF
	_cQuery += "  FROM " + RetSqlName("DF0") + " DF0 " + CRLF
	_cQuery += " INNER JOIN " + RetSqlName("DF1") + " DF1 ON " + CRLF
	_cQuery += "       DF1.DF1_FILIAL = '" + xFilial("DF1") + "' " + CRLF
	_cQuery += "   AND DF1.DF1_NUMAGE = DF0.DF0_NUMAGE " + CRLF
	_cQuery += "   AND DF1.D_E_L_E_T_ = ' ' " + CRLF
	_cQuery += " INNER JOIN " + RetSqlName("DUD") + " DUD ON " + CRLF
	_cQuery += "       DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF
	_cQuery += "   AND DUD.DUD_FILDOC = DF1.DF1_FILDOC " + CRLF
	_cQuery += "   AND DUD.DUD_DOC    = DF1.DF1_DOC " + CRLF
	_cQuery += "   AND DUD.DUD_SERIE  = DF1.DF1_SERIE " + CRLF
	_cQuery += "   AND DUD.DUD_STATUS <> '1' " + CRLF
	_cQuery += "   AND DUD.D_E_L_E_T_ = ' ' " + CRLF
	_cQuery += " INNER JOIN " + RetSqlName("DTQ") + " DTQ ON " + CRLF
	_cQuery += "       DTQ.DTQ_FILIAL = '" + xFilial("DTQ") + "' " + CRLF
	_cQuery += "   AND DTQ.DTQ_VIAGEM = DUD.DUD_VIAGEM " + CRLF
	_cQuery += "   AND DTQ.D_E_L_E_T_ = ' ' " + CRLF
	_cQuery += " WHERE DF0.R_E_C_N_O_ = " + cValToChar(DF0->(Recno())) + CRLF
	_cQuery := ChangeQuery(_cQuery)
	_cAlias := GetNextAlias()
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), _cAlias, .F., .T.)
	
	// ---	Verifica se retornou registro na consulta
	If (_cAlias)->(Eof())
		Aviso("Inconsistência", "Não há viagem para este plano.",{"Ok"},,"Atenção:")
	Else
		
		// ---	Chamada da função para apontamento da ocorrência.
		_cOldFunName	:=	FunName()
		
		// ---	Define a função registro de ocorrências como ativa
		SetFunName('TMSA360')
		
		// ---	Chama da rotina para apontamento da ocorrência
		TMSA360Mnt(,(_cAlias)->DTQREC ,3, (_cAlias)->FILORI, (_cAlias)->VIAGEM, /*cTipUso*/, /*cIdent*/ )
		
		// --- Restaura a função anterior
		SetFunName(_cOldFunName)
		
	EndIf
	
	// ---	Fecha a area de trabalho
	(_cAlias)->(dbCloseArea())
	
	// ---	Opção criada para chamda da rotina de viagem de coleta modelo 2
ElseIf _cId	== '991'
	
	// ---	Atualiza variaveis
	_cOldFunName	:= FunName()
	
	// ---	Define função
	SetFunName("TMSA144A")
	
	// ---	Rotina viagem de coleta modelo 2
	TMSA144A()
	
	// ---	Restaura a função atual
	SetFunName(_cOldFunName)
	
EndIf

Return


/*/{Protheus.doc} CNHINT055
Função responsavel por obter a lista de planos de transporte para a data informada.
@author 	Luiz Alexandre Ferreira
@since 		30/09/2014
@version 	1.0
@param 		_nDia, ${integer}, Dia
@param 		_nMes, ${integer}, Mês
@param 		_nAno, ${integer}, Ano
@param 		_lAuto, ${Boolean}, Boolean .t. automático .f. manual
@return 	${_lRet}, ${.T. Se o processo foi executado com sucesso.}
@example
(examples)
@see (links_or_references)
/*/User Function CNHINT055(_nDia,_nMes,_nAno,_lAuto)

// --- Variaveis utilizadas
Local _oWSInt055 	:= 	Nil
Local _lRet		:= 	.f.
Local _nCoadminunt		:= 	0
Local _cSequen	:=	'1'
Local _aAuxPlano	:=	{}

// ---	Controle para sempre comecar por CNH
If GetMv('ES_CNHSEQ') <> _cSequen
	PutMv('ES_CNHSEQ','1')
EndIf

// --- Define modo de debug do Web Service
//WSDLDbgLevel( 2 )

// ---	Laco para tratar os tipos de plano de transporte 1 CNH 2 Iveco
For _nCount	:= 1 to Len(_aTipoPlano)
	
	// ---	Sequencia de planos
	_cSequen	:= GetMv('ES_CNHSEQ')
	
	// --- Instancia do webservice
	_oWSInt055	:= WSintegracao_painel():New()
	_oWSInt055:cpalavraPasse	:= _cPalavrapasse
	_oWSInt055:ndiaPlanejamento	:= _nDia
	_oWSInt055:nmesPlanejamento	:= _nMes
	_oWSInt055:nanoPlanejamento	:= _nAno
	
	// --- Verifica retorno da chamada do WebService
	If _oWSInt055:interface055()
		
		// --- Verifica se existe plano de transporte
		If ValType(_oWSInt055:cinterface055Result) <> ''
			
			// --- Carrega planos na array
			_aAuxPlano	:= StrTokArr(_oWSInt055:cinterface055Result,";")
			
			// ---	Adiciona os tipos e planos
			For _nX	:= 1 to Len(_aAuxPlano)
				Aadd (_aPlanos, { _aAuxPlano[_nX], _cSequen } )
			Next
		EndIf
		
	Else
		
		// --- Erro na execução do WebService
		If ! _lAuto
			alert('Erro de Execução : '+GetWSCError())
		Else
			ConOut('Erro de Execução : '+GetWSCError())
		EndIf
		
	Endif
	
	// ---	Modifica o semaforo para o proximo tipo de plano
	PutMV('ES_CNHSEQ', StrZero(_nCount,1) )
	
Next

// --- Chamada do metódo interface060 para obter os detalhes dos planos.
_lRet	:= Iif (Len(_aPlanos) > 0, .t., .f.)

//	---	Ordena a lista
Asort(_aPlanos,,, { |x,y| x[1] < y[1] })

// ---	Devove o semaforo para o primeiro tipo de plano
PutMV('ES_CNHSEQ', '1' )

Return _lRet


/*/{Protheus.doc} CNHINT060
Função responsável por obter os detalhes dos planos de transporte armazenados na
array _aPlanos.
@author 	Luiz Alexandre Ferreira
@since 		30/09/2014
@version 	1.0
@param 		_aPlanos, ${array}, Array com a lista dos planos
@param 		_lAuto, ${boolean}, Se a execução é automática .T. ou manual .F.
@return 	${_lRet}, ${Se o processo foi executado com sucesso .T. ou .F.}
@example
(examples)
@see (links_or_references)
/*/User Function CNHINT060(_aPlanos,_lAuto)

// --- Variaveis utilizadas
Local _oWSInt060	:= Nil
Local _oScript  	:= Nil
Local _cXML		:= ''
Local cError		:= ''
Local cWarning	:= ''
Local _cSchema	:= ''
Local _nX			:= 1
Local _aDados		:= {}

// ---	Limpa variavel de planos para visualizar
_aPlanosView	:= {}

// ---	Se for automático força o segundo parametro para considerar todos os planos.
// ---	Se for manual verifica se o usuário optou pela importação individual.
If ! _lAuto
	If Mv_par02	== 1
		_aPlanos	:= {}
		Aadd( _aPlanos, { AllTrim(Str(DF0->DF0_PLANID)), AllTrim(DF0->DF0_TIPO) }  )
	EndIf
Else
	// ---	Todos os planos
	Mv_par02	:= 2
EndIf

// --- Define tabalho da regua de progresso
Iif ( !_lAuto, ProcRegua(Len(_aPlanos)),Nil)

// --- Define modo de debug do Web Service
//WSDLDbgLevel( 2 )

// --- Laco principal para obter os detalhes dos planos
While _nX <= Len(_aPlanos)
	
	
	// ---	Limpa a variavel
	_aDados		:=	{}
	
	// ---	Ajusta tipo de plano
	If GetMv('ES_CNHSEQ') <> _aPlanos[_nX,2]
		PutMV('ES_CNHSEQ',_aPlanos[_nX,2])
	EndIf
	
	// --- Exibe mensagem de progresso
	If ! _lAuto
		IncProc('Plano de transporte CNH/IVECO -> '+_aPlanos[_nX,1])
	Else
		ConOut(_cinterface060+' - Plano de transporte CNH/IVECO -> '+_aPlanos[_nX,1] )
	EndIf
	
	// --- Define variaveis e inicia Web Service
	_oWSInt060	:= WSintegracao_painel():New()
	_oWSInt060:cpalavraPasse	:= _cPalavrapasse
	_oWSInt060:nnumeroPlano	:= Val(_aPlanos[_nX,1])
	
	// --- Verifica retorno da chamada do WebService
	If _oWSInt060:interface060()
		
		// --- Verifica retorno do WebService, se retornou um objeto
		If ValType(_oWSInt060:oWSinterface060Result) == 'O'
			
			// --- Verifica se existe a funcao que será chamada
			If FindFunction('WSGETCXMLRET')
				
				// --- Extrai arquivo XML a partir do objeto de retorno
				_cXML		:= WSGETCXMLRET(_oWSInt060:oWSinterface060Result)

				// Por: Ricardo Guimarães - Em: 09/10/2015 - Objetivo: Gravar o arquivo XML
				If GetNewPar("ES_CNHXML",.T.)
					ConOut(_cinterface060+' - Gravando arquivo XML -> '+_aPlanos[_nX,1] )				
					_cPath   := "\TMS-CNH-XML\"
					_cNomeArq := _cPath + "CNH-INT060-" + _aPlanos[_nX,1] + ".XML"
					MontaDir(_cPath)
					
					MEMOWRIT(_cNomeArq,_cXML)
				EndIf
				// --- Parser do arquivo
				_oScript	:= XmlParser( _cXML ,'_', @cError, @cWarning )
				
				// ---	{2LGI}
				// ---	08/09/2014} Tratamento para planos sem programacao, a CNH abre o plano, mas vazio.  Assim a tag _SOLICITACAO não é criada
				// ---
				If	AllTrim(ClassDataArr(_oScript:_SOAP_ENVELOPE:_SOAP_BODY:_INTERFACE060RESPONSE:_INTERFACE060RESULT:_DIFFGR_DIFFGRAM)[1][1]) == '_SOLICITACAO'
					
					// Transforma node em uma array, no caso tranforma a estrutura para array
					_aDados		:= ClassDataArr(_oScript:_SOAP_ENVELOPE:_SOAP_BODY:_INTERFACE060RESPONSE:_INTERFACE060RESULT:_DIFFGR_DIFFGRAM:_SOLICITACAO)
					
					// --- Grava plano de transporte como agendamento
					INTCNHGRV(_aDados)
					
					// ---	Adiciona plano com status final
					Aadd( _aPlanosView, { DF0->DF0_PLANID , Iif( DF0->DF0_STPLAN == '1' , OemToAnsi('Plano com pendências!') , OemToAnsi('Importado com sucesso!') ), DF0->DF0_STPLAN } )
					
				Else
					// ---	Adiciona plano com status final
					Aadd( _aPlanosView, { Val(_aPlanos[_nX,1]) , 'Plano SEM PROGRAMAÇÃO', '1' } )
					
				EndIf
				
			Else
				// --- Funcao que recupera o XML do objeto que o WS retorna
				Iif ( !_lAuto, Alert('Funcão WSGETCXMLRET não encontrada no repositório'), ConOut('Funcão WSGETCXMLRET não encontrada no repositório') )
			EndIf
			
		Else
			// --- Funcao nao encontrada
			Iif ( !_lAuto, Alert('Problema com retorno de variavel na '+_cinterface060 ), ConOut('Problema com retorno de variavel na '+_cinterface060) )
		EndIf
		
	Else
		// --- Erro na execucao do WebService
		Iif ( !_lAuto, alert( _cinterface060+GetWSCError()), ConOut(_cinterface060+GetWSCError() ) )
	Endif
	
	// --- Proximo plano
	_nX++
	
EndDo


// --- Exibe os planos importados com resultado da crítica inicial.
If ! _lAuto
	INTCNHVIEW(_aPlanosView)
	//	---	Transmite email com relação dos planos importados
Else
	INTCNHEML(_aPlanosView)
EndIf

Return

/*/{Protheus.doc} CNHINT101
Função responsável por enviar o aceite do plano de transporte CNH/IVECO
através do método interface101.
@author	Luiz Alexandre Ferreira
@since 		01/10/2014
@version 	1.0
@param 		_nPlanoId, ${integer}, Número do plano de transporte
@param 		_lAuto, ${boolean}, .T. automático, .F. manual
@return 	${_lRet}, ${.T. processamento normal, .F. problema no processamento}
@example	(examples)
@see 		(links_or_references)
/*/User Function CNHINT101(_nPlanoId,_lAuto)

// --- Variaveis utilizadas
Local _oWSInt101  		:= 	Nil
Local _lRet		  		:= 	.f.
Local _cXML				:= 	''

// ---	Prepara schema e XML para envio no Web Service
_cXML	+=	'<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns="" id="NewDataSet">'
_cXML	+=	'	<xs:element msdata:UseCurrentLocale="true" msdata:IsDataSet="true" name="NewDataSet">'
_cXML	+=	'		<xs:complexType>'
_cXML	+=	'			<xs:choice maxOccurs="unbounded" minOccurs="0">'
_cXML	+=	'				<xs:element name="Table1">'
_cXML	+=	'					<xs:complexType>'
_cXML	+=	'						<xs:sequence>'
_cXML	+=	'							<xs:element name="nroPlano" minOccurs="0" type="xs:string"/>'
_cXML	+=	'						</xs:sequence>'
_cXML	+=	'					</xs:complexType>'
_cXML	+=	'				</xs:element>'
_cXML	+=	'			</xs:choice>'
_cXML	+=	'		</xs:complexType>'
_cXML	+=	'	</xs:element>'
_cXML	+=	'</xs:schema>'
_cXML	+=	'<diffgr:diffgram xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns:diffgr="urn:schemas-microsoft-com:xml-diffgram-v1">'
_cXML	+=	'	<NewDataSet xmlns="">'
_cXML	+=	'		<Table1 diffgr:id="Table11" msdata:rowOrder="0">'
_cXML	+=	'			<nroPlano>'+AllTrim(Str(_nPlanoId))+'</nroPlano>'
_cXML	+=	'		</Table1>'
_cXML	+=	'	</NewDataSet>'
_cXML	+=	'</diffgr:diffgram>'

// --- Define modo de debug do Web Service
WSDLDbgLevel( 2 )

// --- Instancia do webservice
_oWSInt101	:= WSintegracao_painel():New()
_oWSInt101:cpalavraPasse		:= _cPalavrapasse
_oWSInt101:oWSdsDados		:= _cXML

// --- Verifica retorno da chamada do WebService
If _oWSInt101:interface101()
	
	// --- Verifica se existe plano de transporte
	If ValType(_oWSInt101:linterface101Result) == 'L'
		// --- Carrega planos na array
		_lRet		:= _oWSInt101:linterface101Result
	Else
		// --- Erro no retorno do WebService
		Iif ( ! _lAuto, alert('Erro no retorno '+_cinterface101+' '+GetWSCError()), ConOut('Erro no retorno '+_cinterface101+' '+GetWSCError() ) )
	EndIf
	
Else
	// --- Erro na execução do WebService
	Iif ( ! _lAuto, alert('Erro de Execução do Web Service '+_cinterface101+' '+GetWSCError()), ConOut('Erro de Execução do Web Service '+_cinterface101+' '+GetWSCError() ) )
Endif

Return _lRet


/*/{Protheus.doc} CNHINT201
Função responsável por enviar os dados do motorista e placa do veíulo, interface CNH/IVECO
através do método interface201.
@author 	Luiz Alexandre Ferreira
@since 		06/10/2014
@version 	1.0
@param 		_nPlanoId, ${integer}, Número do plano de transporte
@param 		_cPlaca, ${char}, Placa do veículo
@param 		_cNomeMot, ${char}, Nome do motorista
@param 		_cAnoVei, ${char}, Ano fabricação do veículo
@param 		_lAuto, ${boolean}, .T. execução automática, .F. execução manual
@return 	${boolean}, ${.T. se transmissão com sucesso, .F. problemas na transmissão}
@example	(examples)
@see 		(links_or_references)
/*/User Function CNHINT201(_nPlanoId,_cPlaca,_cNomeMot,_cAnoVei,_lAuto)

// --- Variaveis utilizadas
Local _oWSInt201  		:= 	Nil
Local _lRet		  		:= 	.f.
Local _cXML				:= 	''

// ---	Posiciona no plano para o WS obter a origem CNH ou IVECO.
DF0->(dbSetOrder(3))
DF0->(dbSeek(xFilial('DF0')+Str(_nPlanoId,TamSX3('DF0_PLANID')[1],0)))

// ---	Limpa o log
_aLog	:=	{}

// ---	Prepara schema e XML para envio no Web Service
_cXML	+=	'<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns="" id="NewDataSet">'
_cXML	+=	'	<xs:element msdata:UseCurrentLocale="true" msdata:IsDataSet="true" name="NewDataSet">'
_cXML	+=	'		<xs:complexType>'
_cXML	+=	'			<xs:choice maxOccurs="unbounded" minOccurs="0">'
_cXML	+=	'				<xs:element name="Table1">'
_cXML	+=	'					<xs:complexType>'
_cXML	+=	'						<xs:sequence>'
_cXML	+=	'							<xs:element name="nroPlano" minOccurs="0" type="xs:string"/>'
_cXML	+=	'							<xs:element name="placaVeiculo" type="xs:string" minOccurs="0" />'
_cXML	+=	'							<xs:element name="nomeMotorista" type="xs:string" minOccurs="0" />'
_cXML	+=	'							<xs:element name="anoVeiculo" type="xs:string" minOccurs="0" />'
_cXML	+=	'						</xs:sequence>'
_cXML	+=	'					</xs:complexType>'
_cXML	+=	'				</xs:element>'
_cXML	+=	'			</xs:choice>'
_cXML	+=	'		</xs:complexType>'
_cXML	+=	'	</xs:element>'
_cXML	+=	'</xs:schema>'
_cXML	+=	'<diffgr:diffgram xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns:diffgr="urn:schemas-microsoft-com:xml-diffgram-v1">'
_cXML	+=	'	<NewDataSet xmlns="">'
_cXML	+=	'		<Table1 diffgr:id="Table11" msdata:rowOrder="0">'
_cXML	+=	'			<nroPlano>'+AllTrim(Str(_nPlanoId))+'</nroPlano>'
_cXML	+=	'			<placaVeiculo>'+AllTrim(_cPlaca)+'</placaVeiculo>'
_cXML	+=	'			<nomeMotorista>'+AllTrim(_cNomeMot)+'</nomeMotorista>'
_cXML	+=	'			<anoVeiculo>'+AllTrim(_cAnoVei)+'</anoVeiculo>'
_cXML	+=	'		</Table1>'
_cXML	+=	'	</NewDataSet>'
_cXML	+=	'</diffgr:diffgram>'

// --- Define modo de debug do Web Service
//WSDLDbgLevel( 2 )

// --- Instancia do webservice
_oWSInt201	:= WSintegracao_painel():New()
_oWSInt201:cpalavraPasse	:= _cPalavrapasse
_oWSInt201:oWSdsDados		:= _cXML

// --- Verifica retorno da chamada do WebService
If _oWSInt201:interface201()
	
	// --- Verifica se existe plano de transporte
	If ValType(_oWSInt201:linterface201Result) == 'L'
		// --- Carrega planos na array
		_lRet		:= _oWSInt201:linterface201Result
	Else
		// --- Erro no retorno do WebService
		Iif ( ! _lAuto, alert('Erro no retorno '+_cinterface201+' '+GetWSCError()), ConOut('Erro no retorno '+_cinterface201+' '+GetWSCError() ) )
	EndIf
	
Else
	// --- Erro na execução do WebService
	Iif ( ! _lAuto, alert('Erro de Execução do Web Service '+_cinterface201+' '+GetWSCError()), ConOut('Erro de Execução do Web Service '+_cinterface201+' '+GetWSCError() ) )
Endif

// --- Grava log e define status de gravacao do plano
If _lRet
	aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface201, dDataBase, Time() ,'Dados do veiculo', 'Dados do veículo transmitido na data/hora!', UsrRetName(RetCodUsr()), '1' } )
Else
	aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface201, dDataBase, Time() ,'Dados do veiculo', 'Dados do veículo não transmitido na data/hora!', UsrRetName(RetCodUsr()), '0' } )
EndIf

// ---	Grava log do processo de trasmissão da interface101
INTCNHGLOG(_aLog)

Return


/*/{Protheus.doc} CNH201A
Função responsável por receber a placa do veículo e nome do motorista
para transmitir a interface201.
Esse processo trabalha de forma antecipada a criação da viagem
transmitindo a CNH dados preliminares da captação.
@author 	Luiz Alexandre Ferreira
@since 		06/10/2014
@version	1.0
@param 		_aRet, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function CNH201A()

// --- Variaveis utilizadas
Local	oDlg
Local	oSay, oSay1, oSay2, oSay3, oSay4, oSay5, oSay6
Local	oFont, oFont1
Local	oSButton1, oSButton2
Local	_cMsg1			:= ''
Local	_cMsg2			:= ''
Local	_cMsg3			:= ''
Local	_nPlanoId		:=	DF0->DF0_PLANID
Local	_lRet			:=	.t.
Private	_cPlaca	:=	Space(TamSX3('DA3_COD')[1])
Private	_cMot		:=	Space(TamSX3('DA4_COD')[1])
Private	_cTransp	:=	Space(TamSX3('A2_COD')[1])

// ---	Somente planos de transporte Em Captação
If DF0->DF0_CNHID	<> '33'
	// ---	Exibe mensagem
	Help (" ", 1, "CNH201A",,OemToAnsi('Somente planos Em Captação podem receber placa e motorista!'), 3, 0)
Return
EndIf

// ---	Define dialog
oDlg	:= MSDialog():New(0,0,220,550,OemToAnsi('Dados do veículo '+_cinterface201),,,,,CLR_BLACK,CLR_WHITE,,,.t.)

// ---	Define fontes para mensagens
oFont	:= TFont():New('Tahoma',,-16,.T.)
oFont1	:= TFont():New('Tahoma',,-11,.T.)

// --- Apresenta o tSay com a fonte Courier New
oSay	:= TSay():New( 005, 010, {|| OemToAnsi('Plano de transporte ')+Transform(DF0->DF0_PLANID,'@E 9,999,999' ) },oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay:lTransparent:= .F.
oSay1	:= TSay():New( 025, 010, {|| OemToAnsi('Veículo	')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay1:lTransparent:= .F.
oSay2	:= TSay():New( 045, 010, {|| OemToAnsi('Motorista ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay2:lTransparent:= .F.
oSay5	:= TSay():New( 065, 010, {|| OemToAnsi('Transportadora ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay5:lTransparent:= .F.


// 	---	Dados de entrada
@ 023,065 MSGET _cPlaca		F3 "DA3"	SIZE 20, 9 OF oDlg Picture "@!" Pixel Valid Iif ( Empty(_cPlaca), Vazio(), ExistCpo("DA3") )
oSay3	:= TSay():New( 023, 110, {|| Transform(CNH201B(_cPlaca,@_cMsg2,oDlg,oFont),"@R XXX-9999") },oDlg,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE )
oSay3:lTransparent:= .F.

@ 043,065 MSGET _cMot	F3 "DA4" 	SIZE 20, 9 OF oDlg Picture "@!" Pixel Valid Iif ( Empty(_cMot), Vazio(), ExistCpo("DA4") )
oSay4	:= TSay():New( 043, 110, {|| CNH201C(_cMot,@_cMsg1,oDlg,oFont) },oDlg,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE )
oSay4:lTransparent:= .F.

@ 063,065 MSGET _cTransp	F3 "SA2" 	SIZE 20, 9 OF oDlg Picture "@!" Pixel Valid Iif ( Empty(_cTransp), Vazio() , ExistCpo("SA2") )
oSay6	:= TSay():New( 043, 110, {|| CNH201D(_cTransp,@_cMsg3,oDlg,oFont) },oDlg,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE )
oSay6:lTransparent:= .F.

// --- Botoes para gravacao dos dados de classificacao do titulo
// ---
oSButton1 := SButton():New( 85,10,1, {|| _lRet := .t., oDlg:End() },oDlg,.T.,'Confirma dados',)
oSButton2 := SButton():New( 85,40,2, {|| _lRet := .f., oDlg:End() },oDlg,.T.,'Cancela',)

// --- 	Ativa o objeto
oDlg:Activate()

// ---	Se confirmado transmite interface
If _lRet
	
	// ---	Grava dados informados
	RecLock('DF0',.f.)
	DF0->DF0_CODVEI	:=	_cPlaca
	DF0->DF0_CODMOT	:=	_cMot
	DF0->DF0_XCDTRA	:=	_cTransp
	DF0->(msUnLock())
	
	//	---	Somente envia a interface 201 após preencher placa e motorista
	If ! Empty(_cPlaca) .and. ! Empty(_cMot)
		
		// ---	Transmite interface201
		MsgRun(OemToAnsi('Informando dados do veículo plano '+AllTrim(Str(_nPlanoId))+'...Aguarde!'  ), _cinterface201 , { || U_CNHINT201(_nPlanoId,_cMsg2,_cMsg1,DA3->DA3_ANOFAB,.f.) } )
		
		// ---	Interface701 para atualizar status do plano
		_lRet	:=	U_CNHINT701(_nPlanoId,.t.)
		
	EndIf
	
EndIf

Return


/*/{Protheus.doc} CNHNUMCA
Função responsável por receber os dados da janela de agendamento.
@author 	Luiz Alexandre Ferreira
@since 		06/10/2014
@version	1.0
@param 		_aRet, ${param_type}, (Descrição do parâmetro)
@return	Nil
@example	Nil
(examples)
@see (links_or_references)
/*/User Function CNHNUMCA()

// --- Variaveis utilizadas
Local	oDlg
Local	oSay, oSay1, oSay2, oSay3, oSay4, oSay5, oSay6
Local	oFont, oFont1
Local	oSButton1, oSButton2
Local	_cMsg1			:= ''
Local	_cMsg2			:= ''
Local	_cMsg3			:= ''
Local	_nPlanoId		:=	DF0->DF0_PLANID
Local	_lRet			:=	.t.
Private	_cNumCA	:=	Space(TamSX3('DF0_XCA')[1])
Private	_dDatCA	:=	Ctod('')
Private	_cHrCA		:=	Space(TamSX3('DF0_XHRAGE')[1])

// ---	Define dialog
oDlg	:= MSDialog():New(0,0,220,550,OemToAnsi('Dados do agendamento'),,,,,CLR_BLACK,CLR_WHITE,,,.t.)

// ---	Define fontes para mensagens
oFont	:= TFont():New('Tahoma',,-16,.T.)
oFont1	:= TFont():New('Tahoma',,-11,.T.)

// --- Apresenta o tSay com a fonte Courier New
oSay	:= TSay():New( 005, 010, {|| OemToAnsi('Plano de transporte ')+Transform(DF0->DF0_PLANID,'@E 9,999,999' ) },oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay:lTransparent:= .F.
oSay1	:= TSay():New( 025, 010, {|| OemToAnsi('Código do agendamento ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay1:lTransparent:= .F.
oSay2	:= TSay():New( 045, 010, {|| OemToAnsi('Data do agendamento ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay2:lTransparent:= .F.
oSay5	:= TSay():New( 065, 010, {|| OemToAnsi('Hora do agendamento ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay5:lTransparent:= .F.


// 	---	Dados de entrada
@ 023,100 MSGET _cNumCA		SIZE 50, 9 OF oDlg Picture "@!" Pixel

@ 043,100 MSGET _dDatCA		SIZE 45, 9 OF oDlg Picture "@D" Pixel

@ 063,100 MSGET _cHrCA	 	SIZE 10, 9 OF oDlg Picture "@R 99:99" Pixel

// --- Botoes para gravacao dos dados de classificacao do titulo
// ---
oSButton1 := SButton():New( 85,10,1, {|| _lRet := .t., oDlg:End() },oDlg,.T.,'Confirma dados',)
oSButton2 := SButton():New( 85,40,2, {|| _lRet := .f., oDlg:End() },oDlg,.T.,'Cancela',)

// --- 	Ativa o objeto
oDlg:Activate()

// ---	Se confirmado transmite interface
If _lRet
	
	// ---	Grava dados informados
	RecLock('DF0',.f.)
	DF0->DF0_XCA		:=	_cNumCA
	DF0->DF0_XDTAGE	:=	_dDatCA
	DF0->DF0_XHRAGE	:=	_cHrCA
	DF0->(msUnLock())
	
EndIf

Return


/*/{Protheus.doc} CNH201B
Realiza a busca para retornar descrição de cadastro.
@author 	Luiz Alexandre Ferreira
@since 		06/10/2014
@version 	1.0
@param 		_cTab, ${char}, Alias da tabela
@param 		_cCampo, ${char}, Campo, chave primaria
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function CNH201B(_cPlaca,_cMsg2,oDlg,oFont)

// ---	Variaveis utilizadas
Local	_oSay6

// ---	Localiza a descricao
If ! Empty(_cPlaca)
	DA3->(dbSetOrder(1))
	DA3->(dbSeek(xFilial('DA3')+_cPlaca))
	_cMsg2		:=	DA3->DA3_PLACA
	_cPlaca	:=	DA3->DA3_COD
EndIf

Return _cMsg2

/*/{Protheus.doc} CNH201C
Realiza a busca para retornar descrição de cadastro.
@author 	Luiz Alexandre Ferreira
@since 		06/10/2014
@version 	1.0
@param 		_cTab, ${char}, Alias da tabela
@param 		_cCampo, ${char}, Campo, chave primaria
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function CNH201C(_cMot,_cMsg1,oDlg,oFont)

// ---	Variaveis utilizadas
Local 	oSay5

// ---	Localiza a descricao
If ! Empty(_cMot)
	DA4->(dbSetOrder(1))
	DA4->(dbSeek(xFilial('DA4')+_cMot))
	_cMsg1		:= Trim(DA4->DA4_NOME)
	_cMot		:= DA4->DA4_COD
EndIf

oSay5	:= TSay():New( 043, 110, {|| _cMsg1 },oDlg,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE )
oSay5:lTransparent:= .F.

Return _cMsg1

/*/{Protheus.doc} CNH201D
Realiza a busca para retornar descrição de cadastro.
@author 	Luiz Alexandre Ferreira
@since 		06/10/2014
@version 	1.0
@param 		_cTab, ${char}, Alias da tabela
@param 		_cCampo, ${char}, Campo, chave primaria
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function CNH201D(_cTransp,_cMsg3,oDlg,oFont)

// ---	Variaveis utilizadas
Local 	oSay6

// ---	Localiza a descricao
If ! Empty(_cTransp)
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial('SA2')+_cTransp))
	_cMsg3		:= Trim(SA2->A2_NOME)
	_cTransp	:= SA2->A2_COD
EndIf

oSay6	:= TSay():New( 063, 110, {|| _cMsg3 },oDlg,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE )
oSay6:lTransparent:= .F.

Return _cMsg3


/*/{Protheus.doc} CNHINT301
Função responsável por transmitir a interface de declinio de plano de transporte
conforme manual de integração fornecida pela CNH.
@author	Luiz Alexandre Ferreira
@since 		06/10/2014
@version 	1.0
@param 		_nPlanoId, ${integer}, (Número do plano de transporte)
@param 		_lAuto, ${param_type}, (.T. executa automático, .F. executa manual)
@return 	${boolean}, ${.T. se executado com sucesso, .F. se houve erro na transmissão}
@example
(examples)
@see (links_or_references)
/*/User Function CNHINT301(_nPlanoId,_lAuto)

// --- Variaveis utilizadas
Local _oWSInt301  		:= 	Nil
Local _lRet		  		:= 	.f.
Local _cXML				:= 	''

// ---	Prepara schema e XML para envio no Web Service
_cXML	+=	'<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns="" id="NewDataSet">'
_cXML	+=	'	<xs:element msdata:UseCurrentLocale="true" msdata:IsDataSet="true" name="NewDataSet">'
_cXML	+=	'		<xs:complexType>'
_cXML	+=	'			<xs:choice maxOccurs="unbounded" minOccurs="0">'
_cXML	+=	'				<xs:element name="Table1">'
_cXML	+=	'					<xs:complexType>'
_cXML	+=	'						<xs:sequence>'
_cXML	+=	'							<xs:element name="nroPlano" minOccurs="0" type="xs:string"/>'
_cXML	+=	'							<xs:element name="codigoMotivo" minOccurs="0" type="xs:string"/>'
_cXML	+=	'							<xs:element name="observacao" minOccurs="0" type="xs:string"/>'
_cXML	+=	'						</xs:sequence>'
_cXML	+=	'					</xs:complexType>'
_cXML	+=	'				</xs:element>'
_cXML	+=	'			</xs:choice>'
_cXML	+=	'		</xs:complexType>'
_cXML	+=	'	</xs:element>'
_cXML	+=	'</xs:schema>'
_cXML	+=	'<diffgr:diffgram xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns:diffgr="urn:schemas-microsoft-com:xml-diffgram-v1">'
_cXML	+=	'	<NewDataSet xmlns="">'
_cXML	+=	'		<Table1 diffgr:id="Table11" msdata:rowOrder="0">'
_cXML	+=	'			<nroPlano>'+AllTrim(Str(_nPlanoId))+'</nroPlano>'
_cXML	+=	'			<codigoMotivo>'+AllTrim(_cMotivo)+'</codigoMotivo>'
_cXML	+=	'			<observacao>'+AllTrim(_cObs)+'</observacao>'
_cXML	+=	'		</Table1>'
_cXML	+=	'	</NewDataSet>'
_cXML	+=	'</diffgr:diffgram>'

// --- Define modo de debug do Web Service
//WSDLDbgLevel( 2 )

// --- Instancia do webservice
_oWSInt301	:= WSintegracao_painel():New()
_oWSInt301:cpalavraPasse	:= _cPalavrapasse
_oWSInt301:oWSdsDados		:= _cXML

// --- Verifica retorno da chamada do WebService
If _oWSInt301:interface301()
	
	// --- Verifica se existe plano de transporte
	If ValType(_oWSInt301:linterface301Result) == 'L'
		// --- Carrega planos na array
		_lRet		:= _oWSInt301:linterface301Result
	Else
		// --- Erro no retorno do WebService
		Iif ( ! _lAuto, alert('Erro no retorno '+_cinterface301+' '+GetWSCError()), ConOut('Erro no retorno '+_cinterface301+' '+GetWSCError() ) )
	EndIf
	
Else
	// --- Erro na execução do WebService
	Iif ( ! _lAuto, alert('Erro de Execução do Web Service '+_cinterface301+' '+GetWSCError()), ConOut('Erro de Execução do Web Service '+_cinterface301+' '+GetWSCError() ) )
Endif

Return _lRet


/*/{Protheus.doc} CNHINT401
Função responsável pela transmissão de dados de acompanhamento da viagem.
@author 	Luiz
@since 		15/10/2014
@version 	1.0
@param 		_nPlanoId, ${integer}, Numero do plano de transporte
@param 		_cnroSID, ${string}, (Descrição do parâmetro)
@param 		_ccodigoStatus, ${string}, (Descrição do parâmetro)
@param 		_cObs, ${string}, (Descrição do parâmetro)
@param 		_lAuto, ${boolean}, .T. executado em modo automático, .F. executado manualmente.
@return 	${boolean}, ${.T. execucado com sucesso, .F. problema na execução do método.}
@example
(examples)
@see (links_or_references)
/*/User Function CNHINT401(_nPlanoId,_cnroSID,_ccodigoStatus,_cObs,_lAuto)

// --- Variaveis utilizadas
Local _oWSInt401  		:= 	Nil
Local _lRet		  		:= 	.f.
Local _cXML				:= 	''

// ---	Posiciona no plano para o WS obter a origem CNH ou IVECO.
DF0->(dbSetOrder(3))
DF0->(dbSeek(xFilial('DF0')+Str(_nPlanoId,TamSX3('DF0_PLANID')[1],0)))

// ---	Prepara schema e XML para envio no Web Service
_cXML	+=	'<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns="" id="NewDataSet">'
_cXML	+=	'	<xs:element msdata:UseCurrentLocale="true" msdata:IsDataSet="true" name="NewDataSet">'
_cXML	+=	'		<xs:complexType>'
_cXML	+=	'			<xs:choice maxOccurs="unbounded" minOccurs="0">'
_cXML	+=	'				<xs:element name="Table1">'
_cXML	+=	'					<xs:complexType>'
_cXML	+=	'						<xs:sequence>'
_cXML	+=	'							<xs:element name="nroPlano" minOccurs="0" type="xs:string"/>'
_cXML	+=	'							<xs:element name="nroSID" minOccurs="0" type="xs:string"/>'
_cXML	+=	'							<xs:element name="codigoStatus" minOccurs="0" type="xs:string"/>'
_cXML	+=	'							<xs:element name="observacao" minOccurs="0" type="xs:string"/>'
_cXML	+=	'						</xs:sequence>'
_cXML	+=	'					</xs:complexType>'
_cXML	+=	'				</xs:element>'
_cXML	+=	'			</xs:choice>'
_cXML	+=	'		</xs:complexType>'
_cXML	+=	'	</xs:element>'
_cXML	+=	'</xs:schema>'
_cXML	+=	'<diffgr:diffgram xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns:diffgr="urn:schemas-microsoft-com:xml-diffgram-v1">'
_cXML	+=	'	<NewDataSet xmlns="">'
_cXML	+=	'		<Table1 diffgr:id="Table11" msdata:rowOrder="0">'
_cXML	+=	'			<nroPlano>'+AllTrim(Str(_nPlanoId))+'</nroPlano>'
_cXML	+=	'			<nroSID>'+AllTrim(_cnroSID)+'</nroSID>'
_cXML	+=	'			<codigoStatus>'+AllTrim(_ccodigoStatus)+'</codigoStatus>'
_cXML	+=	'			<observacao>'+AllTrim(_cObs)+'</observacao>'
_cXML	+=	'		</Table1>'
_cXML	+=	'	</NewDataSet>'
_cXML	+=	'</diffgr:diffgram>'


// --- Define modo de debug do Web Service
WSDLDbgLevel( 2 )

// --- Instancia do webservice
_oWSInt401:= WSintegracao_painel():New()
_oWSInt401:cpalavraPasse		:= _cPalavrapasse
_oWSInt401:oWSdsDados		:= _cXML

// --- Verifica retorno da chamada do WebService
If _oWSInt401:interface401()
	
	// --- Verifica se existe plano de transporte
	If ValType(_oWSInt401:linterface401Result) == 'L'
		// --- Carrega planos na array
		_lRet		:= _oWSInt401:linterface401Result
	Else
		// --- Erro no retorno do WebService
		Iif ( ! _lAuto, alert('Erro no retorno '+_cinterface401+' '+GetWSCError()), ConOut('Erro no retorno '+_cinterface401+' '+GetWSCError() ) )
	EndIf
	
Else
	// --- Erro na execução do WebService
	Iif ( ! _lAuto, alert('Erro de Execução do Web Service '+_cinterface401+' '+GetWSCError()), ConOut('Erro de Execução do Web Service '+_cinterface401+' '+GetWSCError() ) )
Endif

Return _lRet


/*/{Protheus.doc} CNH401A
Exibe tela para digitação de dados da interface.
@author 	Luiz Alexandre Ferreira
@since 		15/10/2014
@version 	1.0
@param 		_aRet, ${boolean}, Se foi confirmado.
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function CNH401A(_aRet)

// --- Variaveis utilizadas
Local oDlg
Local oSay, oSay1, oSay2, oSay3
Local oFont, oFont1
Local oSButton1, oSButton2
Local _ccodigoStatus	:=	''
Local _cnroSID		:=	''
Local _cObs			:=	Space(40)
Local _lRet			:=	.t.
Local _aRet			:=	{}

// ---	Define dialog
oDlg	:= MSDialog():New(0,0,200,550,OemToAnsi('Status de plano de transporte '+_cinterface401),,,,,CLR_BLACK,CLR_WHITE,,,.t.)

// ---	Define fontes para mensagens
oFont	:= TFont():New('Tahoma',,-16,.T.)
oFont1	:= TFont():New('Tahoma',,-11,.T.)

// --- Apresenta o tSay com a fonte Courier New
oSay	:= TSay():New( 005, 010, {|| OemToAnsi('Status de plano de transporte '+_cinterface401) },oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay:lTransparent:= .F.
oSay1	:= TSay():New( 025, 010, {|| OemToAnsi('Status informado  :')},oDlg,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay1:lTransparent:= .F.
oSay3	:= TSay():New( 045, 010, {|| OemToAnsi('Observação 		  :')},oDlg,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay3:lTransparent:= .F.

// ---
@ 020,065 MSGET _ccodigoStatus	SIZE 20, 9 OF oDlg PIXEL F3 'ZW' VALID ExistCpo('SX5','ZW'+_ccodigoStatus)
oSay4	:= TSay():New( 022, 090, {|| CNHINT301B('ZW'+_ccodigoStatus,@_ccodigoStatus) },oDlg,,oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay4:lTransparent:= .F.
@ 040,065 MSGET _cObs	 	SIZE 150, 9 OF oDlg PIXEL

// --- Botoes para gravacao dos dados de classificacao do titulo
// ---
oSButton1 := SButton():New( 85,10,1, {|| _lRet := .t., oDlg:End() },oDlg,.T.,'Confirma dados',)
oSButton2 := SButton():New( 85,40,2, {|| _lRet := .f., oDlg:End() },oDlg,.T.,'Cancela',)

// --- 	Ativa o objeto
oDlg:Activate()

// ---	Adiciona retorno
Aadd( _aRet , _ccodigoStatus )
Aadd( _aRet , _cObs )
Aadd( _aRet , _lRet )

Return _lRet

/*/{Protheus.doc} CNHINT501
Função responsável por transmitir a interface501 com dados de tracking do plano.
@author 	Luiz Alexandre Ferreira
@since 		15/10/2014
@version 	1.0
@param 		_nPlanoId, ${param_type}, (Descrição do parâmetro)
@param 		_cColCanc, ${param_type}, (Descrição do parâmetro)
@param 		_cCodCanc, ${param_type}, (Descrição do parâmetro)
@param 		_nRspCanc, ${param_type}, (Descrição do parâmetro)
@param 		_cChegCol, ${param_type}, (Descrição do parâmetro)
@param 		_cSaidCol, ${param_type}, (Descrição do parâmetro)
@param 		_cChegDes, ${param_type}, (Descrição do parâmetro)
@param 		_cObs, ${param_type}, (Descrição do parâmetro)
@param 		_lAuto, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function CNHINT501(_nPlanoId,_cColCanc,_cCodCanc,_nRspCanc,_cChegCol,_cSaidCol,_cChegDes,_cObs,_lAuto)

// --- Variaveis utilizadas
Local _oWSInt501  		:= 	Nil
Local _lRet		  		:= 	.f.
Local _cXML				:= 	''

// ---	Posiciona no plano para o WS obter a origem CNH ou IVECO.
dbSelectArea("DF0")
dbSetOrder(3)
dbSeek( xFilial('DF0')+Str(_nPlanoId,TamSX3('DF0_PLANID')[1],0) )

// ---	Limpa variavel de log
_aLog	:= {}

// ---	Prepara schema e XML para envio no Web Service
_cXML	+=	'<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns="" id="NewDataSet">'
_cXML	+=	'	<xs:element msdata:UseCurrentLocale="true" msdata:IsDataSet="true" name="NewDataSet">'
_cXML	+=	'		<xs:complexType>'
_cXML	+=	'			<xs:choice maxOccurs="unbounded" minOccurs="0">'
_cXML	+=	'				<xs:element name="Table1">'
_cXML	+=	'					<xs:complexType>'
_cXML	+=	'						<xs:sequence>'
_cXML	+=	'							<xs:element name="nroPlano" minOccurs="0" type="xs:string"/>'
_cXML	+=	'							<xs:element name="coletaCanceladaComVeiculo" type="xs:string" minOccurs="0" />'
_cXML	+=	'							<xs:element name="codigoMotivoCancelamento" type="xs:string" minOccurs="0" />'
_cXML	+=	'							<xs:element name="codigoResponsavelCancelamento" type="xs:string" minOccurs="0" />'
_cXML	+=	'							<xs:element name="chegadaColeta" type="xs:string" minOccurs="0" />'
_cXML	+=	'							<xs:element name="saidaColeta" type="xs:string" minOccurs="0" />'
_cXML	+=	'							<xs:element name="chegadaDestino" type="xs:string" minOccurs="0" />'
_cXML	+=	'							<xs:element name="observacao" type="xs:string" minOccurs="0" />'
_cXML	+=	'						</xs:sequence>'
_cXML	+=	'					</xs:complexType>'
_cXML	+=	'				</xs:element>'
_cXML	+=	'			</xs:choice>'
_cXML	+=	'		</xs:complexType>'
_cXML	+=	'	</xs:element>'
_cXML	+=	'</xs:schema>'
_cXML	+=	'<diffgr:diffgram xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns:diffgr="urn:schemas-microsoft-com:xml-diffgram-v1">'
_cXML	+=	'	<NewDataSet xmlns="">'
_cXML	+=	'		<Table1 diffgr:id="Table11" msdata:rowOrder="0">'
_cXML	+=	'			<nroPlano>'+AllTrim(Str(_nPlanoId))+'</nroPlano>'
_cXML	+=	'			<coletaCanceladaComVeiculo>'+_cColCanc+'</coletaCanceladaComVeiculo>'
_cXML	+=	'			<codigoMotivoCancelamento>'+_cCodCanc+'</codigoMotivoCancelamento>'
_cXML	+=	'			<codigoResponsavelCancelamento>'+AllTrim(Str(_nRspCanc))+'</codigoResponsavelCancelamento>'
_cXML	+=	'			<chegadaColeta>'+_cChegCol+'</chegadaColeta>'
_cXML	+=	'			<saidaColeta>'+_cSaidCol+'</saidaColeta>'
_cXML	+=	'			<chegadaDestino>'+_cChegDes+'</chegadaDestino>'
_cXML	+=	'			<observacao>'+AllTrim(_cObs)+'</observacao>'
_cXML	+=	'		</Table1>'
_cXML	+=	'	</NewDataSet>'
_cXML	+=	'</diffgr:diffgram>'

// --- Define modo de debug do Web Service
//WSDLDbgLevel( 2 )

// --- Instancia do webservice
_oWSInt501	:= WSintegracao_painel():New()
_oWSInt501:cpalavraPasse	:= _cPalavrapasse
_oWSInt501:oWSdsDados	:= _cXML

// --- Verifica retorno da chamada do WebService
If _oWSInt501:interface501()
	
	// --- Verifica se existe plano de transporte
	If ValType(_oWSInt501:linterface501Result) == 'L'
		// --- Carrega planos na array
		_lRet		:= _oWSInt501:linterface501Result
	Else
		// --- Erro no retorno do WebService
		Help (" ", 1, "CNH501WSRET",,'Erro no retorno '+_cinterface501+' '+GetWSCError(), 3, 0)
	EndIf
	
Else
	// --- Erro na execução do WebService
	Help (" ", 1, "CNH501WSERRO",,'Erro de Execução do Web Service '+_cinterface501+' '+GetWSCError(), 3, 0)
Endif


// --- Tratamento de acordo com retorno do Web Service
Iif ( _lRet,;
	Help (" ", 1, "CNH501",,_cinterface501+' - Execução do plano '+AllTrim(Str(_nPlanoId))+' transmitido com sucesso!', 3, 0),;
	Help (" ", 1, "CNH501",,_cinterface501+' - Execução do plano '+AllTrim(Str(_nPlanoId))+' não transmitido !', 3, 0) )

// --- Grava log e define status de gravacao do plano
If _lRet
	aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface501, dDataBase, Time() ,'Execução do plano', 'Execução do plano transmitido na data/hora!', UsrRetName(RetCodUsr()),'1' } )
Else
	aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface501, dDataBase, Time() ,'Execução do plano', 'Execução do plano não transmitido na data/hora!', UsrRetName(RetCodUsr()),'0' } )
EndIf

// ---	Grava log do processo de trasmissão da interface101
INTCNHGLOG(_aLog)

Return _lRet


/*/{Protheus.doc} CNH501A
Exibe tela para receber dados da interface501.
@author	Luiz Alexandre Ferreira
@since 		15/10/2014
@version 	1.0
@param 		_aRet, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function CNH501A(_aRet)

// --- Variaveis utilizadas
Local oDlg
Local oSay, oSay1, oSay2, oSay3
Local oFont, oFont1
Local oSButton1, oSButton2
Local oCombo
Local cCombo		:=	''
Local _cMotivo		:=	''
Local _cObs			:=	Space(40)
Local _lRet			:=	.t.
Local _aRet			:=	{}
Local _aItens		:= 	{ 'Nao informado','Transportadora','CNH', 'Fornecedor' }

// ---	Carrega motivo padrao
cCombo	:= _aItens[1]

oDlg	:= MSDialog():New(0,0,200,550,OemToAnsi('Execução de plano '+_cinterface501),,,,,CLR_BLACK,CLR_WHITE,,,.t.)

// ---	Define fontes para mensagens
oFont	:= TFont():New('Tahoma',,-16,.T.)
oFont1	:= TFont():New('Tahoma',,-11,.T.)

// --- Apresenta o tSay com a fonte Courier New
oSay	:= TSay():New( 005, 010, {|| OemToAnsi('Execução de plano de transporte '+_cinterface501) },oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay:lTransparent:= .F.
oSay1	:= TSay():New( 025, 010, {|| OemToAnsi('Motivo do tracking:')},oDlg,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay1:lTransparent:= .F.
oSay2	:= TSay():New( 045, 010, {|| OemToAnsi('Responsavel Canc. :')},oDlg,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay2:lTransparent:= .F.
oSay3	:= TSay():New( 065, 010, {|| OemToAnsi('Observação Canc.  :')},oDlg,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay3:lTransparent:= .F.

// ---
@ 020,065 MSGET _cMotivo	SIZE 20, 9 OF oDlg PIXEL F3 'ZX' VALID ExistCpo('SX5','ZX'+_cMotivo)
oSay4	:= TSay():New( 022, 095, {|| CNHINT301B('ZX'+_cMotivo,@_cMotivo) },oDlg,,oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay4:lTransparent:= .F.
oCombo:= tComboBox():New( 040,065 ,{|u| if(PCount()>0 ,cCombo:=u ,cCombo ) }, _aItens ,100,20,oDlg,,{|| MsgStop('Motivo alterado!') },,,,.T.,,,,,,,,,'cCombo')
@ 060,065 MSGET _cObs	 	SIZE 150, 9 OF oDlg PIXEL

// --- Botoes para gravacao dos dados de classificacao do titulo
// ---
oSButton1 := SButton():New( 85,10,1, {|| _lRet := .t., oDlg:End() },oDlg,.T.,'Confirma dados',)
oSButton2 := SButton():New( 85,40,2, {|| _lRet := .f., oDlg:End() },oDlg,.T.,'Cancela',)

// --- 	Ativa o objeto
oDlg:Activate()

// ---	Adiciona retorno
_nPos	:= Ascan( _aItens, { |x| x == cCombo } )

Aadd( _aRet , _cMotivo )
Aadd( _aRet , Iif( _nPos == 1, 0, _nPos-1 ) )
Aadd( _aRet , _cObs )
Aadd( _aRet , _lRet )

Return _lRet


/*/{Protheus.doc} CNHINT601
Função responsável por transmitir dados para faturamento através do método interface601.
@author	Luiz Alexandre Ferreira
@since 		15/10/2014
@version 	1.0
@param 		_nPlanoId, ${param_type}, (Descrição do parâmetro)
@param 		_cAlias, ${param_type}, (Descrição do parâmetro)
@param 		_lAuto, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function CNHINT601(_nPlanoId,_cAlias,_lAuto)

// --- Variaveis utilizadas
Local _oWSInt601  	:= 	Nil
Local _lRet		  	:= 	.f.
Local _cXML			:= 	''
Local _cXMLNF			:= 	''
Local _nValorFre		:= 	0
Local _nValorPdg		:= 	0
Local _nValorSeg		:= 	0
Local _nValorOut		:= 	0
Local _nValorImp		:= 	0
Local _nNf				:= 	0
Local _nDoc			:= 	0

// ---	Posiciona no plano em caso de automatico
If _lAuto
	DF0->(dbSetOrder(3))
	DF0->(dbSeek(xFilial('DF0')+Str(_nPlanoId,TamSX3('DF0_PLANID')[1],0)))
EndIf

// ---	Prepara schema e XML para envio no Web Service
_cXML	+=	'<xs:schema xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" id="NewDataSet">'
_cXML	+=	'	<xs:element name="NewDataSet" msdata:IsDataSet="true" msdata:UseCurrentLocale="true">'
_cXML	+=	'		<xs:complexType>'
_cXML	+=	'			<xs:choice minOccurs="0" maxOccurs="unbounded">'
_cXML	+=	'				<xs:element name="Table1">'
_cXML	+=	'					<xs:complexType>'
_cXML	+=	'						<xs:sequence>'
_cXML	+=	'							<xs:element name="nroPlano" type="xs:int" minOccurs="0" />'
_cXML	+=	'							<xs:element name="nroCTRC" type="xs:string" minOccurs="0" />'
_cXML	+=	'							<xs:element name="serieCTRC" type="xs:string" minOccurs="0" />'
_cXML	+=	'							<xs:element name="dataEmissaoCTRC" type="xs:string" minOccurs="0"/>'
_cXML	+=	'							<xs:element name="nfServico" type="xs:string" minOccurs="0"/>'
_cXML	+=	'							<xs:element name="valorFrete" type="xs:double" minOccurs="0"/>'
_cXML	+=	'							<xs:element name="valorPedagio" type="xs:double" minOccurs="0" />'
_cXML	+=	'							<xs:element name="valorImpostos" type="xs:double" minOccurs="0" />'
_cXML	+=	'							<xs:element name="valorSeguro" type="xs:double" minOccurs="0" />'
_cXML	+=	'							<xs:element name="valorOutros" type="xs:double" minOccurs="0" />'
_cXML	+=	'							<xs:element name="valorTotal" type="xs:double" minOccurs="0" />'
_cXML	+=	'							<xs:element name="cnpjTransportadora" type="xs:string" minOccurs="0" />'
_cXML	+=	'							<xs:element name="observacao" type="xs:string" minOccurs="0" />'
_cXML	+=	'						</xs:sequence>'
_cXML	+=	'					</xs:complexType>'
_cXML	+=	'				</xs:element>'
_cXML	+=	'			</xs:choice>'
_cXML	+=	'		</xs:complexType>'
_cXML	+=	'	</xs:element>'
_cXML	+=	'</xs:schema>'
_cXML	+=	'<diffgr:diffgram xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns:diffgr="urn:schemas-microsoft-com:xml-diffgram-v1">'
_cXML	+=	'	<NewDataSet xmlns="">'

// ---	Todos os conhecimento encontrados para o plano de transporte
While (_cAlias)->( ! Eof() )
	
	// ---	Reinicia as variaveis
	_nValorFre		:= 0
	_nValorPdg		:= 0
	_nValorSeg		:= 0
	_nValorOut		:= 0
	_nValorImp		:= 0
	_nDoc++
	
	_cXML	+=	'		<Table1 diffgr:id="Table1'+AllTrim(Str(_nDoc,3,0))+'" msdata:rowOrder="'+AllTrim(Str(_nDoc-1,3,0))+'" diffgr:hasChanges="inserted">'
	_cXML	+=	'			<nroPlano>'+AllTrim(Str(_nPlanoId))+'</nroPlano>'
	_cXML	+=	'			<nroCTRC>'+(_cAlias)->DT6_DOC+'</nroCTRC>'
	_cXML	+=	'			<serieCTRC>'+AllTrim((_cAlias)->DT6_SERIE)+'</serieCTRC>'
	_cXML	+=	'			<dataEmissaoCTRC>'+Dtoc((_cAlias)->DT6_DATEMI)+'</dataEmissaoCTRC>'
	_cXML	+=	'			<nfServico>'+Iif( (_cAlias)->DT6_DOCTMS == '2', 'False', 'True' )+'</nfServico>'
	
	// ---	Busca valor de pedagio para o documento
	DT8->(dbSetOrder(2))
	DT8->(dbSeek(xFilial('DT8')+(_cAlias)->DT6_FILDOC+(_cAlias)->DT6_DOC+(_cAlias)->DT6_SERIE))
	While DT8->( ! Eof() ) .and. DT8->DT8_FILIAL == (_cAlias)->DT6_FILIAL .and. DT8->DT8_FILDOC == (_cAlias)->DT6_FILDOC .and.;
			DT8->DT8_DOC == (_cAlias)->DT6_DOC .and. DT8->DT8_SERIE == (_cAlias)->DT6_SERIE
		
		// ---	Analisa os tipos de documento
		If DT8->DT8_CODPAS <> 'TF'
			
			// ---	Acumula os impostos
			_nValorImp	+=	DT8->DT8_VALIMP
			// ---	Frete Km
			If GetAdvFVal('DT3','DT3_FAIXA',xFilial('DT3')+DT8->DT8_CODPAS,1,'') == '08'
				_nValorFre	+= DT8->DT8_VALPAS
				// ---	Advalorem
			ElseIf GetAdvFVal('DT3','DT3_FAIXA',xFilial('DT3')+DT8->DT8_CODPAS,1,'') == '02'
				_nValorSeg	+= DT8->DT8_VALPAS
				// ---	Pedagio
			ElseIf GetAdvFVal('DT3','DT3_FAIXA',xFilial('DT3')+DT8->DT8_CODPAS,1,'') == '07'
				_nValorPdg	+= DT8->DT8_VALPAS
			Else
				// ---	Outros valores
				_nValorOut	+=	DT8->DT8_VALPAS
			EndIf
			
		EndIf
		
		// ---	Proximo registro
		DT8->(dbSkip())
		
	EndDo
	
	// ---	Armazena valores individuais de cada evento.
	_cXML	+=	'			<valorFrete>'+AllTrim(Str(_nValorFre,TamSX3('DT8_VALPAS')[1],2))+'</valorFrete>'
	_cXML	+=	'			<valorPedagio>'+AllTrim(Str(_nValorPdg,TamSX3('DT8_VALPAS')[1],2))+'</valorPedagio>'
	_cXML	+=	'			<valorImpostos>'+AllTrim(Str(_nValorImp,TamSX3('DT8_VALPAS')[1],2))+'</valorImpostos>'
	_cXML	+=	'			<valorSeguro>'+AllTrim(Str(_nValorSeg,TamSX3('DT8_VALPAS')[1],2))+'</valorSeguro>'
	_cXML	+=	'			<valorOutros>'+AllTrim(Str(_nValorOut,TamSX3('DT8_VALPAS')[1],2))+'</valorOutros>'
	_cXML	+=	'			<valorTotal>'+AllTrim(Str((_cAlias)->DT6_VALTOT,TamSX3('DT6_VALTOT')[1],2))+'</valorTotal>'
	_cXML	+=	'			<cnpjTransportadora>'+GetAdvFVal('SM0','M0_CGC',cEmpAnt+(_cAlias)->DT6_FILDOC,1,'')+'</cnpjTransportadora>'
	_cXML	+=	'			<observacao>'+''+'</observacao>'
	_cXML	+=	'		</Table1>'
	
	// ---	Proximo registro
	(_cAlias)->(dbSkip())
	
EndDo

// ---	Fecha as tags que armazenam os documentos
_cXML	+=	'	</NewDataSet>'
_cXML	+=	'</diffgr:diffgram>'

// ---	Abre o schema das notas fiscais do documento de transporte
_cXMLNF	+=	'<xs:schema xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" id="NewDataSet">'
_cXMLNF	+=	'	<xs:element name="NewDataSet" msdata:IsDataSet="true" msdata:UseCurrentLocale="true">'
_cXMLNF	+=	'		<xs:complexType>'
_cXMLNF	+=	'			<xs:choice minOccurs="0" maxOccurs="unbounded">'
_cXMLNF	+=	'				<xs:element name="Table1">'
_cXMLNF	+=	'					<xs:complexType>'
_cXMLNF	+=	'						<xs:sequence>'
_cXMLNF	+=	'							<xs:element name="nroCTRC" type="xs:string" minOccurs="0"/>'
_cXMLNF	+=	'							<xs:element name="nroNF" type="xs:string" minOccurs="0"/>'
_cXMLNF	+=	'							<xs:element name="valorNF" type="xs:double" minOccurs="0"/>'
_cXMLNF	+=	'							<xs:element name="cnpjOrigem" type="xs:string" minOccurs="0"/>'
_cXMLNF	+=	'							<xs:element name="cnpjFontePagadora" type="xs:string" minOccurs="0"/>'
_cXMLNF	+=	'						</xs:sequence>'
_cXMLNF	+=	'					</xs:complexType>'
_cXMLNF	+=	'				</xs:element>'
_cXMLNF	+=	'			</xs:choice>'
_cXMLNF	+=	'		</xs:complexType>'
_cXMLNF	+=	'	</xs:element>'
_cXMLNF	+=	'</xs:schema>'
_cXMLNF	+=	'<diffgr:diffgram xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns:diffgr="urn:schemas-microsoft-com:xml-diffgram-v1">'
_cXMLNF	+=	'	<NewDataSet xmlns="">'

// ---	Reinicia arquivo para obter as notas fiscais
(_cAlias)->(dbGoTop())
While (_cAlias)->( ! Eof() )
	
	// --- Variavel - table11 - rowOrder 0
	DTC->(dbSetOrder(1))
	DTC->(dbSeek(xFilial('DTC')+(_cAlias)->DT6_FILDOC+(_cAlias)->DT6_LOTNFC))
	While DTC->( ! Eof() ) .and. DTC->DTC_FILIAL == (_cAlias)->DT6_FILIAL .and. DTC->DTC_FILORI == (_cAlias)->DT6_FILDOC .and.;
			DTC->DTC_LOTNFC ==  (_cAlias)->DT6_LOTNFC
		
		// ---	Incrementa a table
		_nNf++
		_cXMLNF	+=	'		<Table1 diffgr:id="Table1'+AllTrim(Str(_nNf,3,0))+'" msdata:rowOrder="'+AllTrim(Str(_nNf-1,3,0))+'" diffgr:hasChanges="inserted">'
		_cXMLNF	+=	'			<nroCTRC>'+AllTrim((_cAlias)->DT6_DOC)+'</nroCTRC>'
		_cXMLNF	+=	'			<nroNF>'+AllTrim(DTC->DTC_NUMNFC)+'</nroNF>'
		_cXMLNF	+=	'			<valorNF>'+AllTrim(Str(DTC->DTC_VALOR,TamSX3('DTC_VALOR')[1],2))+'</valorNF>'
		_cXMLNF	+=	'			<cnpjOrigem>'+AllTrim( GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+DTC->DTC_CLIREM+DTC->DTC_LOJREM,1,'') )+'</cnpjOrigem>'
		_cXMLNF	+=	'			<cnpjFontePagadora>'+AllTrim( GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+DTC->DTC_CLIDEV+DTC->DTC_LOJDEV,1,'') )+'</cnpjFontePagadora>'
		_cXMLNF	+=	'		</Table1>'
		
		// ---	Proximo registro
		DTC->(dbSkip())
		
	EndDo
	
	// ---	Proximo registro
	(_cAlias)->(dbSkip())
	
EndDo

// ---	Encerra o schema e xml
_cXMLNF	+=	'	</NewDataSet>'
_cXMLNF	+=	'</diffgr:diffgram>'

// --- Define modo de debug do Web Service
WSDLDbgLevel( 2 )

// --- Instancia do webservice
_oWSInt601	:= WSintegracao_painel():New()
_oWSInt601:cpalavraPasse		:= _cPalavrapasse
_oWSInt601:oWSdsDadosCTRC	:= _cXML
_oWSInt601:oWSdsDadosNFS		:= _cXMLNF

// --- Verifica retorno da chamada do WebService
If _oWSInt601:interface601()
	
	// --- Verifica se existe plano de transporte
	If ValType(_oWSInt601:linterface601Result) == 'L'
		// --- Carrega planos na array
		_lRet		:= _oWSInt601:linterface601Result
	Else
		// --- Erro no retorno do WebService
		Iif ( ! _lAuto, MsgStop('Erro no retorno '+_cinterface601+' '+GetWSCError(), 'Erro '+_cinterface601 ), ConOut('Erro no retorno '+_cinterface601+' '+GetWSCError() ) )
	EndIf

	// Por: Ricardo Guimarães - Em: 09/10/2015 - Objetivo: Gravar o arquivo XML
	If GetNewPar("ES_CNHXML",.T.)
		// ConOut(_cinterface060+' - Gravando arquivo XML -> '+_aPlanos[_nX,1] )
		ConOut(_cinterface060+' - Gravando arquivo XML -> ' + Str(_nPlanoId,TamSX3('DF0_PLANID')[1],0) )		
		_cPath   := "\TMS-CNH-XML\"
		_cNomeArq := _cPath + "CNH-INT601-" + _cinterface601 + "-CT-e.XML"
		MontaDir(_cPath)
	
		MEMOWRIT(_cNomeArq,_cXML)
		_cNomeArq := _cPath + "CNH-INT601-" + _cinterface601 + "-NF-e.XML"
		MEMOWRIT(_cNomeArq,_cXMLNF)		
	EndIf
	
Else
	// --- Erro na execução do WebService
	Iif ( ! _lAuto, MsgStop('Erro de Execução do Web Service '+_cinterface601+' '+GetWSCError(), 'Erro '+_cinterface601 ), ConOut('Erro de Execução do Web Service '+_cinterface601+' '+GetWSCError() ) )
Endif

Return _lRet


/*/{Protheus.doc} CNH601A
Exibe documentos associados ao plano de transporte antes de envio da interface601 manual.
@author 	2LGI -	Luiz Alexandre Ferreira
@since 		19/03/2015
@version 	1.0
@param 		_cAlias, ${array}, (Alias do arquivo com os dados dos documentos)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function CNH601A(_cAlias)

// --- Variaveis utilizadas
Local	_oOK		:=	LoadBitmap(GetResources(),'br_verde')
Local	_oNO		:=	LoadBitmap(GetResources(),'br_vermelho')
Local	_aList		:=	{}
Local	_aListAux	:=	{}
Local	_nTotal		:= 	0
Local   _lRet		:= 	.f.
Local	_oDlg
Local	_oList
Local 	_oBtnCan
Local 	_oBtnOk

// ---	 Cria Vetor
dbSelectArea(_cAlias)
(_cAlias)->(dbGotop())
While ! (_cAlias)->( Eof() )
	
	
	// ---	Adiciona elementos
	_aListAux := {	.T.,;
		(_cAlias)->DT6_FILDOC,;			// 	---	Filial Documento
	(_cAlias)->DT6_DOC   ,;          //	---	Documento
	(_cAlias)->DT6_SERIE ,;          //	---	Serie
	(_cAlias)->DT6_DATEMI,;          //	---	Data de emissao
	(_cAlias)->DT6_DOCTMS,;          //	---	Tipo de documento
	(_cAlias)->DT6_VALTOT }         //	---	Valor
	
	Do case
	case (_cAlias)->DT6_DOCTMS == '2'
		_aListAux[6]	:=	'CT-e'
	case (_cAlias)->DT6_DOCTMS == '8'
		_aListAux[6]	:=	'CT-e Complemento'
	case (_cAlias)->DT6_DOCTMS == '5'
		_aListAux[6]	:=	'NFS-e'
	case (_cAlias)->DT6_DOCTMS == 'G'
		_aListAux[6]	:=	'NFS-e Complemento'
	case (_cAlias)->DT6_DOCTMS == 'P'
		_aListAux[6]	:=	'CT-e Substituição'
	EndCase
	
	//	---	Acumula o valor total dos documentos
	_nTotal	+=	(_cAlias)->DT6_VALTOT
	
	// ---	Adiciona elemento no array
	Aadd(_aList, _aListAux)
	
	//	---	Proximo registro
	(_cAlias)->(dbSkip())
	
EndDo

//	--- Verifica se ficou vazio
If Len(_aList) == 0
Return .f.
EndIf

// ---	Fonte para exibir numero do plano
oFont:= TFont():New('Tahoma',,-16,.T.)
// ---	Cria formulario para exibir
Define MsDialog _oDlg From 0,0 to 400,800 Pixel Title OemToAnsi('Documentos associados ao plano')
// ---	Cria objeto de fonte que sera usado na Browse
Define Font _oFont Name 'Courier New' Size 0, -12
// --- Apresenta o tSay com a fonte Courier New
oSay	:= TSay():New( 005, 010, {|| OemToAnsi('Documentos associados ao plano ')+Transform(DF0->DF0_PLANID, '@E 9,999,999')+' -> Valor Total - R$ '+Transform(_nTotal,'@E 9,999,999.99') },_oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay:lTransparent:= .F.
// ---	Cria Browse
_oList := TCBrowse():New( 25 , 01, 400, 150,,{'','Filial','Documento','Serie','Data','Tipo','Valor'},{10,20,50,20,50,90,50},_oDlg,,,,,{||},,_oFont,,,,,.F.,,.T.,,.F.,,, )
// ---	Seta o vetor a ser utilizado
_oList:SetArray(_aList)
// ---	Monta a linha a ser exibina no Browse
_oList:bLine :=	{ || { If (_aList[_oList:nAt,01],_oOK,_oNO),;
	_aList[_oList:nAt,02],;
	_aList[_oList:nAt,03],;
	_aList[_oList:nAt,04],;
	_aList[_oList:nAt,05],;
	_aList[_oList:nAt,06],;
	Transform (_aList[_oList:nAt,07], '@E 999,999,999.99') } }

_oBtnCan:= 	TButton():New( 180, 010,'Cancelar'			,  	_oDlg ,{|| _lRet := .f. ,  _oDlg:End() }, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
_oBtnOk	:= 	TButton():New( 180, 070,'Enviar Interface'	, 	_oDlg ,{|| _lRet := .t. ,  _oDlg:End() }, 60, 010,,,.F.,.T.,.F.,,.F.,,,.F. )

// ---	Activa dialog
Activate MsDialog _oDlg Centered

Return _lRet


/*/{Protheus.doc} CNHINT701
Função responsável por consultar o status do plano de transporte na CNH,
atraves de método interface701 - Busca status do plano.
@author 	2LGI - Luiz Alexandre Ferreira
@since 		11/08/2014
@version 	1.0
@param 		_nPlanoId, ${param_type}, (Descrição do parâmetro)
@param 		_lAuto, ${param_type}, (Descrição do parâmetro)
@param 		_cStAtu, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function CNHINT701(_nPlanoId,_lAuto,_cStAtu)

// --- Variaveis utilizadas
Local 	_oWSInt701  	:=	Nil
Local 	_lRet			:=	.t.
Local 	_cRetInt701	:=	''
Local	_aAreaDF0		:=	DF0->(GetArea())
Local	_nDias			:=	GetMv('ES_CNHNDIA',,4)
Local	_cPara			:=	''
DEFAULT _cStAtu 		:= 	''


// ---	Posiciona no plano para o WS obter a origem CNH ou IVECO.
DF0->(dbSetOrder(3))
DF0->(dbSeek(xFilial('DF0')+Str(_nPlanoId,TamSX3('DF0_PLANID')[1],0)))

//	---	Obtem status atual do plano para verificar se houve avanço
If ! _lAuto
	_cStAtu	:=	AllTrim(DF0->DF0_CNHID)
EndIf

// --- Instancia do webservice
_oWSInt701:= WSintegracao_painel():New()
_oWSInt701:cpalavraPasse	:= _cPalavrapasse
_oWSInt701:nnroPlano		:= _nPlanoId

// --- Verifica retorno da chamada do WebService
If _oWSInt701:interface701()
	
	// --- Verifica se existe plano de transporte
	If ValType(_oWSInt701:cinterface701Result) == 'C'
		// --- Carrega planos na array
		_cRetInt701	:= _oWSInt701:cinterface701Result
	Else
		// --- Erro no retorno do WebService
		Help (" ", 1, "CNH701WSERR",,'Erro no retorno '+_cinterface701+' '+GetWSCError(), 3, 0)
	EndIf
	
Else
	
	// --- Erro na execução do WebService
	Help (" ", 1, "CNH701WSEXE",,'Erro de execucao do Web Service '+_cinterface701+' '+GetWSCError(), 3, 0)
	
Endif

// --- Chamada do metódo interface060 para obter os detalhes dos planos.
_lRet	:= Iif ( !Empty(_cRetInt701), .t., .f.)

// --- Tratamento de acordo com retorno do Web Service
If _lAuto
	If _lRet
		ConOut(_cinterface701 + ' - Status retornado '+AllTrim(Str(_nPlanoId))+' -> ['+_cRetInt701+']')
	Else
		ConOut(_cinterface701 + ' - Status nao retornado para o plano '+AllTrim(Str(_nPlanoId))+' -> ['+_cRetInt701+']')
	EndIf
Else
	If _lRet
		Help('',1,"CNH701WSRET",, _cinterface701 + ' - Status retornado '+AllTrim(Str(_nPlanoId))+' -> ['+_cRetInt701+']',1,0 )
	Else
		Help('',1,"CNH701WSRET",, _cinterface701 + ' - Status nao retornado para o plano '+AllTrim(Str(_nPlanoId))+' -> ['+_cRetInt701+']',1,0 )
	EndIf
EndIf

// --- Grava log e define status de gravacao do plano
If _lRet
	aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface701, dDataBase, Time() ,'Consulta Status', 'Status do plano de transporte retornado com sucesso! -> ['+AllTrim(_cRetInt701)+']', UsrRetName(RetCodUsr()), '1' } )
Else
	aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface701, dDataBase, Time() ,'Consulta Status', 'Status do plano de transporte não retornado!', UsrRetName(RetCodUsr()), '0' } )
EndIf

// ---	Localiza a descricao do retorno e codigo da tabela
If _lRet
	// --- Retira acentos e retorna a expressao em caixa alta
	_cRetInt701	:=	INT701A(_cRetInt701)
	
	// ---	Localiza a descrição
	SX5->(dbSetOrder(1))
	SX5->(dbSeek(xFilial('SX5')+'ZY'))
	While SX5->( ! Eof() ) .and. SX5->X5_TABELA == 'ZY'
		
		// ---	Identifica a string
		If Alltrim(_cRetInt701) == AllTrim(SX5->X5_DESCRI)
			
			// ---	Grava status no plano
			DF0->(dbSetOrder(3))
			DF0->(dbSeek(xFilial('DF0')+Str(_nPlanoId,TamSX3('DF0_PLANID')[1],0)))
			RecLock('DF0',.f.)
			DF0->DF0_CNHID	:= AllTrim(SX5->X5_CHAVE)
			
			//	---	Controle de semaforo para todos os status
			// 	---	Bloqueia o plano em caso de erro para obter o próximo
			//	---	Ficou definido 4 [ES_CNHNDIA] dias como intervalo para bloquear o plano caso o status nao tenha sido alterado
			If _lAuto
				
				DF0->DF0_STWS	:= Iif( _cStAtu == AllTrim(DF0->DF0_CNHID) .and. (dDatabase-DF0->DF0_DATCAD) > _nDias, '0', '' )
				
				//	---	Envia e-mail para responsável de acordo com o status CNH.
				//	---	Executado para executado validado
				//	---	Envia a mensagem
				//	---	Envia email conforme parametros
				
				If ! Empty(_cStAtu) .and. DF0->DF0_STWS == '0'
					
					//	---	Executado para executado validado
					If _cStAtu	== '35'
						_cPara	:=	AllTrim(GetMv("ES_CNH735"))
						//	---	Executado validado para pagamento pendente
					ElseIf	_cStAtu 	== '36'
						_cPara	:=	AllTrim(GetMv("ES_CNH736"))
						//	---	Pagamento pendente para pagamento em analise
					ElseIf	_cStAtu	== '37'
						_cPara	:=	AllTrim(GetMv("ES_CNH737"))
						//	---	Pagamento em analise para pagamento liberado
					ElseIf	_cStAtu	== '38'
						_cPara	:=	AllTrim(GetMv("ES_CNH738"))
					EndIf
					
					U_EnvEmail( AllTrim(GetMv("MV_RELFROM")) /*cDe*/,;
						_cPara,;
						''/*cCc*/,;
						'Problema com mundança de status [ ' + _cRetInt701 + ' ] no plano de transporte ' + Transform(_nPlanoId,'@E 999,999,999') /*cAssunto*/,;
						'Plano de transporte [ ' + Transform(_nPlanoId,'@E 999,999,999') + ' ] sem alteração de status há mais de ' + Transform(_nDias, '@E 99') +' dia(s).'/*cMsg*/,'')
					
				EndIf
				
			Else
				
				//	---	Verifica se houve progresso no status do plano
				If	 Val(_cStAtu) < Val(DF0->DF0_CNHID)
					DF0->DF0_STWS	:= ''
				EndIf
				
			EndIf
			
			//	---	Libera lock de registro
			DF0->(msUnLock())
			Exit
			
		EndIf
		
		// ---	Proximo registro
		SX5->(dbSkip())
		
	EndDo
	
EndIf

// ---	Grava log do processo de trasmissão da interface101
INTCNHGLOG(_aLog)

Return _lRet


/*/{Protheus.doc} CNHINT901
Interface CNH - Metodo interface901- Pesquisa de movimentacao
@author 	{2LGI} Luiz Alexandre Ferreira
@since 		10/08/2014
@version 	1.0
@param 		_nPlanoId, ${param_type}, (Descrição do parâmetro)
@param 		_lAuto, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function CNHINT901(_nPlanoId,_lAuto)

// --- Variaveis utilizadas
Local _oWSInt901  	:= 	Nil
Local _cXML			:= 	''
Local _aDados901		:= 	{}
Local _oScript		:= 	Nil

// --- Instancia do webservice
_oWSInt901:= WSintegracao_painel():New()
_oWSInt901:cpalavraPasse	:= _cPalavrapasse
_oWSInt901:nnroPlano		:= _nPlanoId

// --- Verifica retorno da chamada do WebService
If _oWSInt901:interface901()
	
	// --- Verifica se existe plano de transporte
	If ValType(_oWSInt901:oWSinterface901Result) == 'O'
		
		// ---	Verifica se a função existe no repositorio
		If FindFunction('WSGETCXMLRET')
			
			// --- Extrai arquivo XML a partir do objeto de retorno
			_cXML		:= WSGETCXMLRET(_oWSInt901:oWSinterface901Result)
			
			// --- Parser do arquivo
			_oScript	:= XmlParser( _cXML ,"", @cError, @cWarning )
			
			// Transforma node em uma array, no caso tranforma a estrutura para array
			_aDados901	:= _oScript:_SOAP_ENVELOPE:_SOAP_BODY:_INTERFACE901RESPONSE:_INTERFACE901RESULT:_DIFFGR_DIFFGRAM:_NEWDATASET:_TABLE
			
		Else
			// --- Funcao que recupera o XML do objeto que o WS retorna
			If !_lAuto
				Alert('Funcão WSGETCXMLRET não encontrada no repositório')
			Else
				ConOut('Funcão WSGETCXMLRET não encontrada no repositório')
			EndIf
		EndIf
		
	Else
		// --- Erro no retorno do WebService
		Iif ( ! _lAuto, alert('Erro no retorno '+_cinterface901+' '+GetWSCError()), ConOut('Erro no retorno '+_cinterface901+' '+GetWSCError() ) )
	EndIf
	
Else
	// --- Erro na execução do WebService
	Iif ( ! _lAuto, alert('Erro de Execução do Web Service '+_cinterface901+' '+GetWSCError()), ConOut('Erro de Execução do Web Service '+_cinterface901+' '+GetWSCError() ) )
Endif

// --- Grava log das movimentações
aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface901, dDataBase, Time() ,'Movimentacao', 'Plano de transporte apresenta ['+AllTrim(Str(Len(_aDados901)))+'] movimentos na data/hora' , UsrRetName(RetCodUsr()), '1' } )

// ---	Grava log do processo de trasmissão da interface101
INTCNHGLOG(_aLog)

// --- Exibe movimentações do plano
CNH901A(_aDados901)

Return

/*/{Protheus.doc} CNH901A
Exibe registro das movimentacoes do plano de acordo com retorno do Web Service, tracking do plano fornecido pela CNH
através do método interface901.
@author 	2LGI -	Luiz Alexandre Ferreira
@since 		20/09/2014
@version 	1.0
@param 		_aDados901, ${array}, (Array com dados do plano)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function CNH901A(_aDados901)

// --- Variaveis utilizadas
Local	_oOK		:=	LoadBitmap(GetResources(),'br_verde')
Local	_oNO		:=	LoadBitmap(GetResources(),'br_vermelho')
Local	_aList		:=	{}
Local	_aListAux	:=	{}
Local	_nX			:= 	0
Local	_oDlg
Local	_oList

// ---	 Cria Vetor
For _nX	:=	1 to Len(_aDados901)
	
	// ---	Adiciona elementos
	_aListAux := {.T.,;
		_aDados901[_nX]:_ACA_STR_DESCRICAO:TEXT,;						// ---	Interface
	Ctod( SubStr(_aDados901[_nX]:_HIS_DAT_DATAHORA:TEXT,9,2)+'/'+;
		SubStr(_aDados901[_nX]:_HIS_DAT_DATAHORA:TEXT,6,2)+'/'+;
		SubStr(_aDados901[_nX]:_HIS_DAT_DATAHORA:TEXT,1,4) ),;    		// ---	Data
	SubStr(_aDados901[_nX]:_HIS_DAT_DATAHORA:TEXT,12,8),;			// ---	Hora
	_aDados901[_nX]:_HIS_INT_ID:TEXT,;
		_aDados901[_nX]:_HIS_STR_OBJETO:TEXT }
	
	// ---	Adiciona elemento no array
	Aadd(_aList, _aListAux)
	
Next

// ---	Fonte para exibir numero do plano
oFont:= TFont():New('Tahoma',,-16,.T.)
// ---	Cria formulario para exibir
Define MsDialog _oDlg From 0,0 to 520,800 Pixel Title OemToAnsi('Movimentações de plano de transporte')
// ---	Cria objeto de fonte que sera usado na Browse
Define Font _oFont Name 'Courier New' Size 0, -12
// --- Apresenta o tSay com a fonte Courier New
oSay	:= TSay():New( 005, 010, {|| OemToAnsi('Movimentação do plano de transporte ')+Transform(DF0->DF0_PLANID, '@E 9,999,999')+' | Até '+Dtoc(dDataBase)+' - '+Time() },_oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay:lTransparent:= .F.
// ---	Cria Browse
_oList := TCBrowse():New( 25 , 01, 400, 210,,{'','Interface','Data','Hora','Protocolo','Histórico'},{20,50,50,50,50,50},_oDlg,,,,,{||},,_oFont,,,,,.F.,,.T.,,.F.,,, )
// ---	Seta o vetor a ser utilizado
_oList:SetArray(_aList)
// ---	Monta a linha a ser exibina no Browse
_oList:bLine :=	{ || { If (_aList[_oList:nAt,01],_oOK,_oNO),;
	_aList[_oList:nAt,02],;
	_aList[_oList:nAt,03],;
	_aList[_oList:nAt,04],;
	_aList[_oList:nAt,05],;
	_aList[_oList:nAt,06] } }

_oBtn 	:= 	TButton():New( 240, 010,'Sair', _oDlg ,{|| _oDlg:End() }, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )

// ---	Activa dialog
Activate MsDialog _oDlg Centered

Return


/*/{Protheus.doc} INTCNHGRV
Função responsável por realizar a gravação do agendamento / plano de transporte conforme
dados recebidos na interface e tratamentos de regra de negócio GEFCO.
@author	Luiz Alexandre Ferreira
@since 		31/07/2014
@version 	1.0
@param 		_aDados, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function INTCNHGRV(_aDados)

// --- Variaveis utilizadas
Local _nItens		:= 	0
Local _nX			:= 	1
Local _nPosTio	:= 	0
Local _nTotDis	:=	0
Local _cNumAge	:= 	''
Local _cMyUseCode	:= 	''
Local _cDDD		:= 	''
Local _cCliRem	:= 	''
Local _cLojRem	:= 	''
Local _cTel		:= 	''
Local _cProd		:= 	''
Local _aProd		:= 	{}
Local _cStatus	:=	'1'
Local _aRetDF0	:= 	{}
Local _aRetDF1	:= 	{}
Local _aRetDF5	:= 	{}
Local _aRetDF3	:= 	{}
Local _aRetTT		:= 	{}
Local _aRetKm		:= 	{}
Local _aRetBox 	:= 	{}
Local _cGrpVei	:= 	''
Local _cCNPJDUE	:=	''
Local _mMSMOBS

// --- Os planos simples vem como objeto, os compostos como array
// --- 1 - Objeto
// --- 2 - Array
_aLog		:= 	{}
_nTipo		:= 	Iif ( ValType(_aDados[1][2]) == 'O', 1, 2  )
_nPlanoId	:= 	Iif ( _nTipo == 1, Val(_aDados[1][2]:_PLA_INT_ID:TEXT), Val(_aDados[1][2][1]:_PLA_INT_ID:TEXT) )
_nItens	:= 	Iif ( _nTipo == 1, 1, Len(_aDados[1][2]) )
_nPosTipo	:= 	Ascan( _aPlanos,  { |x| x[1] == AllTrim(Str(_nPlanoId,9,0)) } )

//	---	Seleciona/abre arquivos
dbSelectArea('DUE')

// --- Verifica se o plano ja foi importado
DF0->(dbSetOrder(3))
If ! DF0->(dbSeek(xFilial('DF0')+Str(_nPlanoId,TamSX3('DF0_PLANID')[1],0)))
	
	// --- Prepara para gravação  do agendamento
	_cNumAge	:=	GetSx8Num("DF0","DF0_NUMAGE",1)
	_cMyUseCode	:=	AllTrim(xFilial('DF0'))+_cNumAge
	
	// --- Verifica se o codigo nao esta sendo chamado na fila de transacao
	If FreeForUse('DF0',_cNumAge) .and. MayIUseCod(_cMyUseCode)
		
		// --- Variaveis para validacao
		_nTotDis	:= 	Iif ( _nTipo == 1, Val(_aDados[1][2]:_ROT_INT_KM:TEXT), Val(_aDados[1][2][1]:_ROT_INT_KM:TEXT) )
		_aRetDF0	:= 	INTCNHVAGE('_DF0',_aDados,1,,,)
		
		Begin Transaction
			// --- Inclui registro
			ConfirmSX8()
			RecLock('DF0',.t.)
			DF0->DF0_FILIAL	:= 	xFilial('DF0') 				// --- Filial
			DF0->DF0_NUMAGE	:= 	_cNumAge						// --- Numero do agendamento
			DF0->DF0_PLANID	:=	_nPlanoId						// --- Numero do plano de transporte
			DF0->DF0_DDD		:= 	_aRetDF0[1]					// --- DDD
			DF0->DF0_TEL		:= 	_aRetDF0[2]                 // --- Telefone
			DF0->DF0_SEQEND	:= 	''
			DF0->DF0_QTDITE	:= 	_nItens
			DF0->DF0_QTDCON	:= 	0
			DF0->DF0_DATCAD	:= 	Iif ( _nTipo == 1,;
				Ctod( SubStr(_aDados[1][2]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT,9,2)+'/'+;
				SubStr(_aDados[1][2]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT,6,2)+'/'+;
				SubStr(_aDados[1][2]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT,1,4) ),;
				Ctod( SubStr(_aDados[1][2][1]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT,9,2)+'/'+;
				SubStr(_aDados[1][2][1]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT,6,2)+'/'+;
				SubStr(_aDados[1][2][1]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT,1,4) ) )
			DF0->DF0_DATCAN	:= 	Ctod('')
			DF0->DF0_CODOBC	:= 	''
			DF0->DF0_STATUS	:= 	'1'
			DF0->DF0_TIPDIS	:= 	'1'
			DF0->DF0_INIDIS	:= 	'2'
			DF0->DF0_KMPLAN	:=	_nTotDis
			DF0->DF0_DISTIV	:= 	'2'
			
			// --- Campos especificos CNH
			DF0->DF0_STPLAN	:=	_aRetDF0[Len(_aRetDF0)]
			DF0->DF0_HORPLA	:= 	Iif ( _nTipo == 1,;
				SubStr(Trim(_aDados[1][2]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT),12,2)+;
				SubStr(Trim(_aDados[1][2]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT),15,2),;
				SubStr(Trim(_aDados[1][2][1]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT),12,2)+;
				SubStr(Trim(_aDados[1][2][1]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT),15,2) )
			DF0->DF0_DESOPE	:=	Iif ( _nTipo == 1, _aDados[1][2]:_OPE_STR_DESCRICAO:TEXT	, _aDados[1][2][1]:_OPE_STR_DESCRICAO:TEXT )
			DF0->DF0_DESVIA	:=	Iif ( _nTipo == 1, _aDados[1][2]:_VIA_STR_DESCRICAO:TEXT	, _aDados[1][2][1]:_VIA_STR_DESCRICAO:TEXT )
			DF0->DF0_DESVEI	:=	Iif ( _nTipo == 1, _aDados[1][2]:_VEI_STR_DESCRICAO:TEXT	, _aDados[1][2][1]:_VEI_STR_DESCRICAO:TEXT )
			DF0->DF0_EMAILC	:=	Iif ( _nTipo == 1, _aDados[1][2]:_USU_STR_EMAIL:TEXT		, _aDados[1][2][1]:_USU_STR_EMAIL:TEXT )
			DF0->DF0_CONTC	:=	Iif ( _nTipo == 1, _aDados[1][2]:_USU_STR_TELEFONE:TEXT		, _aDados[1][2][1]:_USU_STR_TELEFONE:TEXT )
			DF0->DF0_CNHID	:=	Iif ( _nTipo == 1, _aDados[1][2]:_STA_INT_ID:TEXT			, _aDados[1][2][1]:_STA_INT_ID:TEXT )
			
			// ---	Grava tipo do plano
			_cCNPJDUE			:=	GetAdvFVal('DUE','DUE_CGC',xFilial('DUE')+DF0->DF0_DDD+DF0->DF0_TEL,1,'')
			DF0->DF0_TIPO		:=	Iif ( At( Substr(_cCNPJDUE,1,8), GetMv('ES_CGCDEV') ) == 2, '1', '3' )
			DF0->DF0_XTT		:=	Iif ( _nTipo == 1, StrZero(Val(_aDados[1][2]:_ROT_INT_TT:TEXT),2)+"00",	StrZero(Val(_aDados[1][2][_nX]:_ROT_INT_TT:TEXT),2)+"00" )
			
			// --- Prepara para gravar o campo Memo
			_mMSMOBS			:=	CriaVar('DF0_OBS')
			_mMSMOBS			:=	Iif ( _nTipo == 1, _aDados[1][2]:_PLA_STR_OBSERVACAO:TEXT, _aDados[1][2][1]:_PLA_STR_OBSERVACAO:TEXT )
			DF0->DF0_CODOBS		:=	MSMM(,,,_mMSMOBS,1,,,'DF0','DF0_CODOBS')
			DF0->(MsUnLock())
			
			// --- Libera o codigo reservado da pilha
			FreeUsedCode()
			
			// --- Caso surga alguma incosistencia, atualiza o plano, mesmo que tenha passado na primeira validação
			If _aRetDF0[Len(_aRetDF0)] <> '0'
				RecLock('DF0',.f.)
				DF0->DF0_STPLAN		:=	_aRetDF0[Len(_aRetDF0)]
				DF0->(MsUnLock())
			EndIf
			
			// ---	Consistência do Km informado
			_aRetKm	:= INTCNHKM(_aDados)
			
			// --- Inclui os itens do agendamento
			For _nX	:= 1 to _nItens
				
				// --- Variaveis para validacao
				_aRetDF1	:= 	INTCNHVAGE('_DF1',_aDados,_nX,DF0->DF0_TIPO,DF0->DF0_STPLAN)
				
				// --- Inclui registro de itens do agendamento
				RecLock('DF1',.t.)
				DF1->DF1_FILIAL		:=	xFilial('DF1')
				DF1->DF1_NUMAGE		:=	_cNumAge
				DF1->DF1_ITEAGE		:=  StrZero(_nX,TamSX3('DF1_ITEAGE')[1])
				DF1->DF1_STACOL		:= 	'1'
				DF1->DF1_STAENT		:= 	'1'
				DF1->DF1_LOCCOL		:= 	'2'
				DF1->DF1_FILORI		:= 	''	// --- GetAdvFVal('DUY','DUY_FILDES',xFilial('DUY')+_aRetDF1[3],1,'')
				DF1->DF1_CLIREM		:= 	_aRetDF1[1]
				DF1->DF1_LOJREM		:= 	_aRetDF1[2]
				DF1->DF1_SQEREM		:= 	''
				DF1->DF1_TIPTRA		:= 	'1'
				DF1->DF1_SELORI		:= 	'3'
				DF1->DF1_CDRORI		:= 	_aRetDF1[3]
				//	---	Previsao coleta [A]
				DF1->DF1_DATPRC		:= 	Iif ( _nTipo == 1,;
					Ctod( SubStr(_aDados[1][2]:_PUR_DAT_DATACOLETA:TEXT,9,2)+'/'+;
					SubStr(_aDados[1][2]:_PUR_DAT_DATACOLETA:TEXT,6,2)+'/'+;
					SubStr(_aDados[1][2]:_PUR_DAT_DATACOLETA:TEXT,1,4) ),;
					Ctod( SubStr(_aDados[1][2][1]:_PUR_DAT_DATACOLETA:TEXT,9,2)+'/'+;
					SubStr(_aDados[1][2][1]:_PUR_DAT_DATACOLETA:TEXT,6,2)+'/'+;
					SubStr(_aDados[1][2][1]:_PUR_DAT_DATACOLETA:TEXT,1,4) ) )
				
				DF1->DF1_HORPRC		:= 	Iif ( _nTipo == 1,;
					SubStr(Trim(_aDados[1][2]:_PUR_STR_HORARIOCOLETA:TEXT),1,2)+;
					SubStr(Trim(_aDados[1][2]:_PUR_STR_HORARIOCOLETA:TEXT),4,2),;
					SubStr(Trim(_aDados[1][2][_nX]:_PUR_STR_HORARIOCOLETA:TEXT),1,2)+;
					SubStr(Trim(_aDados[1][2][_nX]:_PUR_STR_HORARIOCOLETA:TEXT),4,2) )
				
				_aRetTT				:=	INTCNHTT(DF1->DF1_DATPRC,DF1->DF1_HORPRC,DF0->DF0_XTT)
				//	---	Previsao de saida de coleta B=[A+ES_CNHFRQ] - Parametro franquia em horas
				DF1->DF1_XDTPSC		:=	_aRetTT[1]
				DF1->DF1_XHRPSC		:=	StrZero(_aRetTT[2]*100,4)
				
				//	---	Previsao entrega	C=B+DF0_XTT
				DF1->DF1_DATPRE    	:= 	_aRetTT[3]
				DF1->DF1_HORPRE		:=	StrZero(_aRetTT[4]*100,4)
				
				//	---	Previsao real entrega D=CNH2 ou Agendamento + DF0_XTT
				//	---	DF1->DF1_XDTPEN		:=	_aRetTT[5]
				//	---	DF1->DF1_XHRPEN		:=	_aRetTT[6]
				
				DF1->DF1_SERVIC		:= 	_aRetDF1[10]
				DF1->DF1_CLIDES		:= 	_aRetDF1[4]
				DF1->DF1_LOJDES		:= 	_aRetDF1[5]
				DF1->DF1_SQEDES		:= 	''
				DF1->DF1_CDRDES		:= 	_aRetDF1[6]
				DF1->DF1_CLIDEV		:= 	_aRetDF1[7]
				DF1->DF1_LOJDEV		:=  _aRetDF1[8]
				DF1->DF1_TIPFRE		:= 	Iif ( DF1->DF1_CLIDEV+DF1->DF1_LOJDEV == DF1->DF1_CLIREM+DF1->DF1_LOJREM, '1', '2' )
				DF1->DF1_VLRINF		:= 	0 // --- Iif ( _nTipo == 1, Val(_aDados[1][2]:_CON_DOU_FRETE:TEXT), Val(_aDados[1][2][_nX]:_CON_DOU_FRETE:TEXT) )
				DF1->DF1_NUMCOT		:= 	''
				DF1->DF1_VALFRE		:= 	0
				DF1->DF1_VALIMP		:= 	0
				DF1->DF1_VALTOT		:= 	0
				DF1->DF1_QTDVOL		:= 	0
				DF1->DF1_PESO			:= 	0
				DF1->DF1_PESOM3		:= 	0
				DF1->DF1_METRO3		:= 	0
				DF1->DF1_VALMER		:= 	0
				DF1->DF1_DISTAN		:= 	_aRetKm[_nX,3]
				DF1->DF1_KMFRET		:= 	_aRetKm[_nX,4]
				DF1->DF1_DATCON		:=  Ctod('')
				DF1->DF1_SEQUEN		:=  StrZero(_nX,TamSX3('DF1_SEQUEN')[1])
				DF1->DF1_SEQENT		:=	StrZero(_nX+1,TamSX3('DF1_SEQENT')[1])
				DF1->DF1_DISTIV		:=	'3'
				DF1->DF1_DATCAN		:=  Ctod('')
				DF1->DF1_CODOBC		:=	''
				//DF1->DF1_MRKPAN		:=  ''
				//DF1->DF1_NFBALC		:=	''
				
				// --- Campos especificos CNH
				DF1->DF1_RAIOCN		:=	Iif ( _nTipo == 1, _aDados[1][2]:_CON_BIT_ABAIXO:TEXT		, _aDados[1][2][_nX]:_CON_BIT_ABAIXO:TEXT )
				DF1->DF1_ENDCOL		:=	Iif ( _nTipo == 1, _aDados[1][2]:_EMP_STR_ENDERECO:TEXT		, _aDados[1][2][_nX]:_EMP_STR_ENDERECO:TEXT )
				DF1->DF1_TELCOL		:=	Iif ( _nTipo == 1, _aDados[1][2]:_EMP_STR_FONE:TEXT			, _aDados[1][2][_nX]:_EMP_STR_FONE:TEXT )
				DF1->DF1_CRITIC		:=	Iif ( _nTipo == 1, _aDados[1][2]:_CRI_STR_DESCRICAO:TEXT	, _aDados[1][2][_nX]:_CRI_STR_DESCRICAO:TEXT )
				DF1->DF1_NUMPUR		:=	Iif ( _nTipo == 1, _aDados[1][2]:_PUR_STR_NUMERO:TEXT		, _aDados[1][2][_nX]:_PUR_STR_NUMERO:TEXT )
				DF1->DF1_OBSPUR		:=	Iif ( _nTipo == 1, _aDados[1][2]:_PUR_STR_OBSERVACOES:TEXT	, _aDados[1][2][_nX]:_PUR_STR_OBSERVACOES:TEXT )
				DF1->DF1_HORLIM		:= 	Iif ( _nTipo == 1,;
					SubStr(Trim(_aDados[1][2]:_PUR_STR_HORARIOEXPEDICAO:TEXT),1,2)+;
					SubStr(Trim(_aDados[1][2]:_PUR_STR_HORARIOEXPEDICAO:TEXT),4,2),;
					SubStr(Trim(_aDados[1][2][_nX]:_PUR_STR_HORARIOEXPEDICAO:TEXT),1,2)+;
					SubStr(Trim(_aDados[1][2][_nX]:_PUR_STR_HORARIOEXPEDICAO:TEXT),4,2) )
				DF1->DF1_DESVOL	:=	Iif ( _nTipo == 1, _aDados[1][2]:_VOL_STR_SID:TEXT			, _aDados[1][2][_nX]:_VOL_STR_SID:TEXT )
				DF1->DF1_DEST		:=	Iif ( _nTipo == 1, _aDados[1][2]:_EMPRESADESTINO:TEXT		, _aDados[1][2][_nX]:_EMPRESADESTINO:TEXT )
				
				DF1->(MsUnLock())
				
				// --- Caso surga alguma incosistencia, atualiza o plano, mesmo que tenha passado na primeira validação
				If _aRetDF1[Len(_aRetDF1)] <> '0'
					RecLock('DF0',.f.)
					DF0->DF0_STPLAN		:=	_aRetDF1[Len(_aRetDF1)]
					DF0->(MsUnLock())
				EndIf
				
				// ---	Verifica se houve problema na validacao de KM
				If _aRetKm[_nX,6] <> Val('0')
					RecLock('DF0',.f.)
					DF0->DF0_STPLAN		:=	StrZero(_aRetKm[_nX,6], TamSX3('DF0_STPLAN')[1] )
					DF0->(MsUnLock())
				EndIf
				
				//	--- Verifica descricao de grupo de veiculos para registra no log
				_aRetBox 	:= RetSx3Box( Posicione('SX3', 2, 'PA4_XTPVEI', 'X3CBox()' ),,, Len(_aRetKm[_nX,8]))
				_cGrpVei	:= Iif ( _aRetKm[_nX,8] <> '99', AllTrim( _aRetBox[ Ascan( _aRetBox, { |x| x[2] ==  _aRetKm[_nX,8] } ), 3 ]), 'Grupo não identificado')
				
				// ---	Se houve problema no controle de KM
				If GetMv('ES_CNHBLKM')
					If _aRetKm[_nX,6] == 1
						// --- Grava log e define status de gravacao do plano
						aAdd( _aLog, { _nPlanoId, StrZero(_nX,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Km Frete', 'Divergência de Km '+Transform(_aRetKm[_nX,2], '@R 99.999.999/9999-99')+' - '+Transform(_aRetKm[_nX,7], '@R 99.999.999/9999-99')+ ' Grupo - '+ _cGrpVei 	, UsrRetName(RetCodUsr()),'0' } )
					Else
						// --- Grava log e define status de gravacao do plano
						aAdd( _aLog, { _nPlanoId, StrZero(_nX,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Km Frete', 'Km conferido na margem '+Transform(_aRetKm[_nX,2], '@R 99.999.999/9999-99')+' - '+Transform(_aRetKm[_nX,7], '@R 99.999.999/9999-99')+ ' Grupo - '+ _cGrpVei, UsrRetName(RetCodUsr()),'1' } )
					EndIf
				EndIf
				
				// --- Grava log do item analisado
				INTCNHGLOG(_aLog)
				
				// --- Log gravado na analise dos itens
				
				// --- Produto do item do agendamento
				// --- Nao precisa grava Log do produto
				_cProd		:= 	GetMV('ES_CNHPROD')
				_aProd 		:= 	Iif(!Empty(_cProd),&_cProd,{})
				
				RecLock('DF2',.t.)
				DF2->DF2_FILIAL		:=	xFilial('DF2')
				DF2->DF2_NUMAGE		:=	_cNumAge
				DF2->DF2_ITEAGE		:=	StrZero(_nX,TamSX3('DF2_ITEAGE')[1])
				DF2->DF2_CODPRO		:=  Iif ( Len( _aProd) > 0, _aProd[1],'' )
				DF2->DF2_CODEMB		:=	Iif ( Len( _aProd) > 0, _aProd[2],'' )
				DF2->(MsUnLock())
				
				// ---
				// --- Componentes de valor informado
				// ---
				// --- Variaveis para validacao
				_aRetDF3	:= 	INTCNHVAGE('_DF3',_aDados,_nX,,DF0->DF0_STPLAN)
				
				RecLock('DF3',.t.)
				DF3->DF3_FILIAL		:=	xFilial('DF3')
				DF3->DF3_NUMAGE		:=	_cNumAge
				DF3->DF3_ITEAGE		:=	StrZero(_nX,TamSX3('DF3_ITEAGE')[1])
				DF3->DF3_CODPRO		:=	Iif ( Len( _aProd) > 0, _aProd[1],'' )
				DF3->DF3_CODPAS		:=  _aRetDF3[1]
				DF3->DF3_VALOR		:=	_aRetKm[_nX,5]
				DF3->(MsUnLock())
				
				// --- Caso surga alguma incosistencia, atualiza o plano, mesmo que tenha passado na primeira validação
				If _aRetDF3[Len(_aRetDF3)] <> '0'
					RecLock('DF0',.f.)
					DF0->DF0_STPLAN		:=	_aRetDF3[Len(_aRetDF3)]
					DF0->(MsUnLock())
				EndIf
				
				
				// ---
				// --- Tipo de veiculo
				// ---
				// --- Variaveis para validacao
				_aRetDF5	:= 	INTCNHVAGE('_DF5',_aDados,_nX,,DF0->DF0_STPLAN)
				
				RecLock('DF5',.t.)
				DF5->DF5_FILIAL	:=	xFilial('DF5')
				DF5->DF5_NUMAGE	:=	DF0->DF0_NUMAGE
				DF5->DF5_ITEAGE	:=	DF1->DF1_ITEAGE
				DF5->DF5_ITEM		:=  StrZero(_nX,TamSX3('DF5_ITEM')[1])
				DF5->DF5_TIPVEI	:=	_aRetDF5[1]
				DF5->DF5_QTDVEI	:=	1
				DF5->(MsUnLock())
				
				// --- Caso surga alguma incosistencia, atualiza o plano, mesmo que tenha passado na primeira validação
				If _aRetDF5[Len(_aRetDF5)] <> '0'
					RecLock('DF0',.f.)
					DF0->DF0_STPLAN		:=	_aRetDF5[Len(_aRetDF5)]
					DF0->(MsUnLock())
				EndIf
				
			Next _nX
			
		End Transaction
		
	EndIf
	// --- Alteracao de planos ja recebidos
Else
	
	// --- 	Verifica o plano existente e somente atualiza se houve pendencias
	// ---	{2LGI}
	// ---	08/09/2014 -Permitir que planos declinados sejam atualizados novamente caso a CNH envie o mesmo numero
	// ---				nesse caso o status padrao é 9 - cancelado.
	If (DF0->DF0_STPLAN == '1') .or. (DF0->DF0_STATUS == '9')
		
		// --- Variaveis para validacao
		_nTotDis	:= 	Iif ( _nTipo == 1, Val(_aDados[1][2]:_ROT_INT_KM:TEXT), Val(_aDados[1][2][1]:_ROT_INT_KM:TEXT) )
		_aRetDF0	:= 	INTCNHVAGE('_DF0',_aDados,1,DF0->DF0_TIPO,,DF0->DF0_STPLAN)
		
		// ---	Altera o registro
		RecLock('DF0',.f.)
		DF0->DF0_DDD			:= 	_aRetDF0[1]			// --- DDD
		DF0->DF0_TEL			:= 	_aRetDF0[2]         // --- Telefone
		DF0->DF0_SEQEND		:= 	''
		DF0->DF0_QTDITE		:= 	_nItens
		DF0->DF0_QTDCON		:= 	0
		DF0->DF0_DATCAD		:= 	Iif ( _nTipo == 1,;
			Ctod( SubStr(_aDados[1][2]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT,9,2)+'/'+;
			SubStr(_aDados[1][2]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT,6,2)+'/'+;
			SubStr(_aDados[1][2]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT,1,4) ),;
			Ctod( SubStr(_aDados[1][2][1]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT,9,2)+'/'+;
			SubStr(_aDados[1][2][1]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT,6,2)+'/'+;
			SubStr(_aDados[1][2][1]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT,1,4) ) )
		DF0->DF0_DATCAN		:= 	Ctod('')
		DF0->DF0_CODOBC		:= 	''
		DF0->DF0_STATUS		:= 	'1'
		DF0->DF0_TIPDIS		:= 	'1'
		DF0->DF0_INIDIS		:= 	'2'
		DF0->DF0_KMPLAN		:=	_nTotDis
		DF0->DF0_DISTIV		:= 	'2'
		DF0->DF0_STPLAN		:=	_aRetDF0[Len(_aRetDF0)]
		
		// --- Campos especificos CNH
		DF0->DF0_HORPLA		:= 	Iif ( _nTipo == 1,;
			SubStr(Trim(_aDados[1][2]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT),12,2)+;
			SubStr(Trim(_aDados[1][2]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT),15,2),;
			SubStr(Trim(_aDados[1][2][1]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT),12,2)+;
			SubStr(Trim(_aDados[1][2][1]:_PLA_DAT_DATAHORAPLANEJAMENTO:TEXT),15,2) )
		DF0->DF0_DESOPE		:=	Iif ( _nTipo == 1, _aDados[1][2]:_OPE_STR_DESCRICAO:TEXT, _aDados[1][2][1]:_OPE_STR_DESCRICAO:TEXT )
		DF0->DF0_DESVIA		:=	Iif ( _nTipo == 1, _aDados[1][2]:_VIA_STR_DESCRICAO:TEXT, _aDados[1][2][1]:_VIA_STR_DESCRICAO:TEXT )
		DF0->DF0_DESVEI		:=	Iif ( _nTipo == 1, _aDados[1][2]:_VEI_STR_DESCRICAO:TEXT, _aDados[1][2][1]:_VEI_STR_DESCRICAO:TEXT )
		DF0->DF0_EMAILC		:=	Iif ( _nTipo == 1, _aDados[1][2]:_USU_STR_EMAIL:TEXT	, _aDados[1][2][1]:_USU_STR_EMAIL:TEXT )
		DF0->DF0_CONTC		:=	Iif ( _nTipo == 1, _aDados[1][2]:_USU_STR_TELEFONE:TEXT	, _aDados[1][2][1]:_USU_STR_TELEFONE:TEXT )
		DF0->DF0_CNHID		:=	Iif ( _nTipo == 1, _aDados[1][2]:_STA_INT_ID:TEXT		, _aDados[1][2][1]:_STA_INT_ID:TEXT )
		
		// ---	Verifica o solicitante para gravar o tipo do plano
		_cCNPJDUE			:=	GetAdvFVal('DUE','DUE_CGC',xFilial('DUE')+DF0->DF0_DDD+DF0->DF0_TEL,1,'')
		DF0->DF0_TIPO		:=	If ( At(Substr(_cCNPJDUE,1,8), GetMv('ES_CGCDEV')) == 2, '1', '3' )
		DF0->DF0_XTT		:=	Iif ( _nTipo == 1, StrZero(Val(_aDados[1][2]:_ROT_INT_TT:TEXT),2)+"00",	StrZero(Val(_aDados[1][2][_nX]:_ROT_INT_TT:TEXT),2)+"00" )
		
		// --- Prepara para gravar o campo Memo
		_mMSMOBS				:= CriaVar('DF0_OBS')
		_mMSMOBS				:= Iif ( _nTipo == 1, _aDados[1][2]:_PLA_STR_OBSERVACAO:TEXT, _aDados[1][2][1]:_PLA_STR_OBSERVACAO:TEXT )
		DF0->DF0_CODOBS		:= MSMM(,,,_mMSMOBS,1,,,'DF0','DF0_CODOBS')
		DF0->(MsUnLock())
		
		// --- Caso surga alguma incosistencia, atualiza o plano, mesmo que tenha passado na primeira validação
		If _aRetDF0[Len(_aRetDF0)] <> '0'
			RecLock('DF0',.f.)
			DF0->DF0_STPLAN	:=	_aRetDF0[Len(_aRetDF0)]
			DF0->(MsUnLock())
		EndIf
		
		// ---	Consistência do Km informado
		_aRetKm	:= INTCNHKM(_aDados)
		
		// --- Localiza os itens para atualização
		DF1->(dbSetOrder(1))
		
		// --- Atualiza os itens
		For _nX	:= 1 to _nItens
			
			
			// --- 	Variaveis para validacao
			_aRetDF1	:= 	INTCNHVAGE('_DF1',_aDados,_nX,DF0->DF0_TIPO,DF0->DF0_STPLAN)
			
			If DF1->(dbSeek(xFilial('DF1')+DF0->DF0_NUMAGE+StrZero(_nX,TamSX3('DF1_ITEAGE')[1])))
				// --- Inclui registro de itens do agendamento
				RecLock('DF1',.f.)
			Else
				// --- Inclui registro de itens do agendamento
				RecLock('DF1',.t.)
			EndIf
			
			DF1->DF1_FILIAL		:=	xFilial('DF1')
			DF1->DF1_NUMAGE		:=	DF0->DF0_NUMAGE
			DF1->DF1_ITEAGE		:=  StrZero(_nX,TamSX3('DF1_ITEAGE')[1])
			DF1->DF1_STACOL		:= 	'1'
			DF1->DF1_STAENT		:= 	'1'
			DF1->DF1_LOCCOL		:= 	'2'
			DF1->DF1_FILDOC		:= 	''
			DF1->DF1_DOC			:= 	''
			DF1->DF1_SERIE		:= 	''
			DF1->DF1_FILORI		:= 	'' 	// ---GetAdvFVal('DUY','DUY_FILDES',xFilial('DUY')+_aRetDF1[3],1,'')
			DF1->DF1_CLIREM		:= 	_aRetDF1[1]
			DF1->DF1_LOJREM		:= 	_aRetDF1[2]
			DF1->DF1_SQEREM		:= 	''
			DF1->DF1_TIPTRA		:= 	'1'
			DF1->DF1_SELORI		:= 	'3'
			DF1->DF1_CDRORI		:= 	_aRetDF1[3]
			DF1->DF1_DATPRC		:= 	Iif ( _nTipo == 1,;
				Ctod( SubStr(_aDados[1][2]:_PUR_DAT_DATACOLETA:TEXT,9,2)+'/'+;
				SubStr(_aDados[1][2]:_PUR_DAT_DATACOLETA:TEXT,6,2)+'/'+;
				SubStr(_aDados[1][2]:_PUR_DAT_DATACOLETA:TEXT,1,4) ),;
				Ctod( SubStr(_aDados[1][2][1]:_PUR_DAT_DATACOLETA:TEXT,9,2)+'/'+;
				SubStr(_aDados[1][2][1]:_PUR_DAT_DATACOLETA:TEXT,6,2)+'/'+;
				SubStr(_aDados[1][2][1]:_PUR_DAT_DATACOLETA:TEXT,1,4) ) )
			
			DF1->DF1_HORPRC		:= 	Iif ( _nTipo == 1,;
				SubStr(Trim(_aDados[1][2]:_PUR_STR_HORARIOCOLETA:TEXT),1,2)+;
				SubStr(Trim(_aDados[1][2]:_PUR_STR_HORARIOCOLETA:TEXT),4,2),;
				SubStr(Trim(_aDados[1][2][_nX]:_PUR_STR_HORARIOCOLETA:TEXT),1,2)+;
				SubStr(Trim(_aDados[1][2][_nX]:_PUR_STR_HORARIOCOLETA:TEXT),4,2) )
			
			_aRetTT				:=	INTCNHTT(DF1->DF1_DATPRC,DF1->DF1_HORPRC,DF0->DF0_XTT)
			//	---	Previsao de saida de coleta B=[A+ES_CNHFRQ] - Parametro franquia em horas
			DF1->DF1_XDTPSC		:=	_aRetTT[1]
			DF1->DF1_XHRPSC		:=	StrZero(_aRetTT[2]*100,4)
			
			//	---	Previsao entrega	C=B+DF0_XTT
			DF1->DF1_DATPRE    	:= 	_aRetTT[3]
			DF1->DF1_HORPRE		:=	StrZero(_aRetTT[4]*100,4)
			
			DF1->DF1_SERVIC		:= 	_aRetDF1[10]
			DF1->DF1_CLIDES		:= 	_aRetDF1[4]
			DF1->DF1_LOJDES		:= 	_aRetDF1[5]
			DF1->DF1_SQEDES		:= 	''
			DF1->DF1_CDRDES		:= 	_aRetDF1[6]
			DF1->DF1_CLIDEV		:= 	_aRetDF1[7]
			DF1->DF1_LOJDEV		:= 	_aRetDF1[8]
			DF1->DF1_TIPFRE		:= 	Iif ( DF1->DF1_CLIDEV+DF1->DF1_LOJDEV == DF1->DF1_CLIREM+DF1->DF1_LOJREM, '1', '2' )
			DF1->DF1_VLRINF		:= 	0 // --- Iif ( _nTipo == 1, Val(_aDados[1][2]:_CON_DOU_FRETE:TEXT), Val(_aDados[1][2][_nX]:_CON_DOU_FRETE:TEXT) )
			DF1->DF1_NUMCOT		:= 	''
			DF1->DF1_VALFRE		:= 	0
			DF1->DF1_VALIMP		:= 	0
			DF1->DF1_VALTOT		:= 	0
			DF1->DF1_QTDVOL		:= 	0
			DF1->DF1_PESO		:= 	0
			DF1->DF1_PESOM3		:= 	0
			DF1->DF1_METRO3		:= 	0
			DF1->DF1_VALMER		:= 	0
			DF1->DF1_DISTAN		:= 	_aRetKm[_nX,3]
			DF1->DF1_KMFRET		:= 	_aRetKm[_nX,4]
			DF1->DF1_DATCON		:=  Ctod('')
			DF1->DF1_SEQUEN		:= 	StrZero(_nX,TamSX3('DF1_SEQUEN')[1])
			DF1->DF1_SEQENT		:=	StrZero(_nX+1,TamSX3('DF1_SEQENT')[1])
			DF1->DF1_DISTIV		:=	'3'
			DF1->DF1_DATCAN		:=  Ctod('')
			DF1->DF1_CODOBC		:=	''
			//DF1->DF1_MRKPAN		:=  ''
			//DF1->DF1_NFBALC		:=	''
			
			// --- Campos especificos CNH
			DF1->DF1_RAIOCN		:=	Iif ( _nTipo == 1, _aDados[1][2]:_CON_BIT_ABAIXO:TEXT		, _aDados[1][2][_nX]:_CON_BIT_ABAIXO:TEXT )
			DF1->DF1_ENDCOL		:=	Iif ( _nTipo == 1, _aDados[1][2]:_EMP_STR_ENDERECO:TEXT		, _aDados[1][2][_nX]:_EMP_STR_ENDERECO:TEXT )
			DF1->DF1_TELCOL		:=	Iif ( _nTipo == 1, _aDados[1][2]:_EMP_STR_FONE:TEXT			, _aDados[1][2][_nX]:_EMP_STR_FONE:TEXT )
			DF1->DF1_CRITIC		:=	Iif ( _nTipo == 1, _aDados[1][2]:_CRI_STR_DESCRICAO:TEXT	, _aDados[1][2][_nX]:_CRI_STR_DESCRICAO:TEXT )
			DF1->DF1_NUMPUR		:=	Iif ( _nTipo == 1, _aDados[1][2]:_PUR_STR_NUMERO:TEXT		, _aDados[1][2][_nX]:_PUR_STR_NUMERO:TEXT )
			DF1->DF1_OBSPUR		:=	Iif ( _nTipo == 1, _aDados[1][2]:_PUR_STR_OBSERVACOES:TEXT	, _aDados[1][2][_nX]:_PUR_STR_OBSERVACOES:TEXT )
			DF1->DF1_HORLIM		:= 	Iif ( _nTipo == 1,;
				SubStr(Trim(_aDados[1][2]:_PUR_STR_HORARIOEXPEDICAO:TEXT),1,2)+;
				SubStr(Trim(_aDados[1][2]:_PUR_STR_HORARIOEXPEDICAO:TEXT),4,2),;
				SubStr(Trim(_aDados[1][2][_nX]:_PUR_STR_HORARIOEXPEDICAO:TEXT),1,2)+;
				SubStr(Trim(_aDados[1][2][_nX]:_PUR_STR_HORARIOEXPEDICAO:TEXT),4,2) )
			DF1->DF1_DESVOL		:=	Iif ( _nTipo == 1, _aDados[1][2]:_VOL_STR_SID:TEXT			, _aDados[1][2][_nX]:_VOL_STR_SID:TEXT )
			DF1->DF1_DEST			:=	Iif ( _nTipo == 1, _aDados[1][2]:_EMPRESADESTINO:TEXT		, _aDados[1][2][_nX]:_EMPRESADESTINO:TEXT )
			DF1->(MsUnLock())
			
			// --- Caso surga alguma incosistencia, atualiza o plano, mesmo que tenha passado na primeira validação
			If _aRetDF1[Len(_aRetDF1)] <> '0'
				RecLock('DF0',.f.)
				DF0->DF0_STPLAN	:=	_aRetDF1[Len(_aRetDF1)]
				DF0->(MsUnLock())
			EndIf
			
			// ---	Verifica se houve problema na validacao de KM
			If _aRetKm[_nX,6] <> Val('0')
				RecLock('DF0',.f.)
				DF0->DF0_STPLAN		:=	StrZero(_aRetKm[_nX,6], TamSX3('DF0_STPLAN')[1] )
				DF0->(MsUnLock())
			EndIf
			
			//	--- Verifica descricao de grupo de veiculos para registra no log
			_aRetBox 	:= RetSx3Box( Posicione('SX3', 2, 'PA4_XTPVEI', 'X3CBox()' ),,, Len(_aRetKm[_nX,8]))
			_cGrpVei	:= Iif ( _aRetKm[_nX,8] <> '99', AllTrim( _aRetBox[ Ascan( _aRetBox, { |x| x[2] ==  _aRetKm[_nX,8] } ), 3 ]), 'Grupo não identificado')
			
			// ---	Se houve problema no controle de KM
			If GetMv('ES_CNHBLKM')
				If _aRetKm[_nX,6] == 1
					// --- Grava log e define status de gravacao do plano
					aAdd( _aLog, { _nPlanoId, StrZero(_nX,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Km Frete', 'Divergência de Km '+Transform(_aRetKm[_nX,2], '@R 99.999.999/9999-99')+' - '+Transform(_aRetKm[_nX,7], '@R 99.999.999/9999-99')+ ' Grupo - '+ _cGrpVei 	, UsrRetName(RetCodUsr()),'0' } )
				Else
					// --- Grava log e define status de gravacao do plano
					aAdd( _aLog, { _nPlanoId, StrZero(_nX,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Km Frete', 'Km conferido na margem '+Transform(_aRetKm[_nX,2], '@R 99.999.999/9999-99')+' - '+Transform(_aRetKm[_nX,7], '@R 99.999.999/9999-99')+ ' Grupo - '+ _cGrpVei, UsrRetName(RetCodUsr()),'1' } )
				EndIf
			EndIf
			
			// --- Grava log do item analisado
			INTCNHGLOG(_aLog)
			
			// --- Os logs dos itens ja foram gravados na rotina de avaliacao
			// ---
			// --- Nao ha necessidade de alterar produto do agendamneto
			// ---
			
			// ---
			// --- Componentes de valor informado
			// ---
			// --- Variaveis para validacao
			_cProd		:= 	GetMV('ES_CNHPROD')
			_aProd 	:= 	Iif(!Empty(_cProd),&_cProd,{})
			_cProd		:= 	Padr(_aProd[1],TamSX3('DF3_CODPRO')[1])
			
			// --- Limpa o log e busca retorno de validação do componente
			_aRetDF3	:= 	INTCNHVAGE('_DF3',_aDados,_nX,,DF0->DF0_STPLAN)
			
			// --- Localiza os itens para atualização
			DF3->(dbSetOrder(1))
			If DF3->(dbSeek(xFilial('DF3')+DF1->DF1_NUMAGE+DF1->DF1_ITEAGE+_cProd+_aRetDF3[1]))
				//	--- Altera registro
				RecLock('DF3',.f.)
			Else
				//	---	Inclui novo registro
				RecLock('DF3',.t.)
			EndIf
			
			DF3->DF3_CODPAS		:=	_aRetDF3[1]
			DF3->DF3_VALOR		:=	_aRetKm[_nX,5]
			DF3->(MsUnLock())
			
			// --- Caso surga alguma incosistencia, atualiza o plano, mesmo que tenha passado na primeira validação
			If _aRetDF3[Len(_aRetDF3)] <> '0'
				RecLock('DF0',.f.)
				DF0->DF0_STPLAN		:=	_aRetDF3[Len(_aRetDF3)]
				DF0->(MsUnLock())
			EndIf
			
			// --- Variaveis para validacao
			_aRetDF5	:= 	INTCNHVAGE('_DF5',_aDados,_nX,,DF0->DF0_STPLAN)
			
			// ---
			// --- Tipos de veiculo
			// ---
			DF5->(dbSetOrder(2))
			If DF5->(dbSeek(xFilial('DF5')+DF1->DF1_NUMAGE+DF1->DF1_ITEAGE+_aRetDF5[1]))
				RecLock('DF5',.f.)
			Else
				RecLock('DF5',.t.)
			EndIf
			// ---	Grava dados do tipo de veiculo
			// ---	Inserido para compatibilizar os registros já gravados com a tabela ajustada De/Para
			DF5->DF5_TIPVEI		:=	_aRetDF5[1]
			DF5->DF5_QTDVEI		:=	1
			DF5->(MsUnLock())
			
			// --- Caso surga alguma incosistencia, atualiza o plano, mesmo que tenha passado na primeira validação
			If _aRetDF5[Len(_aRetDF5)] <> '0'
				RecLock('DF0',.f.)
				DF0->DF0_STPLAN		:=	_aRetDF5[Len(_aRetDF5)]
				DF0->(MsUnLock())
			EndIf
			
		Next _nX
		
		// --- Fim se o plano estava bloqueado
	EndIf
	
	// --- Fim se o plano ja existe
EndIf

Return

/*/{Protheus.doc} INTCNHVAGE
Função responsável por realizar a gravação do agendamento / plano de transporte conforme
dados recebidos na interface e tratamentos de regra de negócio GEFCO.
@author	Luiz Alexandre Ferreira
@since 		31/07/2014
@version 	1.0
@param 		_cInf, ${param_type}, (Descrição do parâmetro)
@param 		_aDados, ${param_type}, (Descrição do parâmetro)
@param 		_nPos, ${param_type}, (Descrição do parâmetro)
@param 		_cTipo, ${param_type}, (Descrição do parâmetro)
@param 		_cStPlan, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function INTCNHVAGE(_cInf,_aDados,_nPos,_cTipo,_cStPlan)

// --- Variaveis utilizadas
Local _cCliGen	:=	SubStr(GetMv('MV_CLIGEN'),1,TamSX3('A1_COD')[1])
Local _cLojGen	:= 	SubStr(GetMv('MV_CLIGEN'),Len(_cCliGen)+1,TamSX3('A1_LOJA')[1])
Local _cCNPJ		:= 	''
Local _cCNPJGen	:= 	GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+_cCliGen+_cLojGen,1,'')
Local _cCNPJDes	:= 	''
Local _cTabVei  	:= 	''
Local _cTipVei  	:= 	''
Local _cCompPdg 	:= 	GetMv('ES_CNHCPDG')
Local _nDist		:= 	0
Local _nPosVei	:= 	0
Local _nPosReg	:= 	0
Local _nPosSrv	:= 	0
Local _aValid		:= 	{}
Local _aDDDRet	:= 	{}
Local _aTabVei	:= 	{}
Local _cOper		:=	GetMV('ES_CNHOPER',,'')
Local _cServ		:=	GetMV('ES_CNHSERV',,'')
Local _aServ		:= 	Iif(!Empty(_cServ),&_cServ,{})	// --- Operacoes CNH
Local _aOper		:= 	Iif(!Empty(_cOper),&_cOper,{})	// --- Servicos GEFCO CNH
Local _cEstCDC	:= 	''
Local _cRegCDC	:= 	''
Local _cCliCDC	:=	''
Local _cLojCDC	:= 	''
Local _cTipVia	:=	''
Local _cTipOpe	:=	''
Local _cEmpDest	:= 	''

// ---	Define a chave para tratamento de remetente e destinatário
// ---	Viagem 2 - Simples 3 - Retorno
// --- Operacao 3 - FTL, 4 - LTL, 5 - TRANSFERENCIA, 7 - REENTREGA
_cTipVia	:=	Iif ( _nTipo == 1, Trim(_aDados[1][2]:_VIA_INT_ID:TEXT)		, Trim(_aDados[1][2][_nPos]:_VIA_INT_ID:TEXT) )
_cTipOpe	:=	Iif ( _nTipo == 1, Trim(_aDados[1][2]:_OPE_INT_ID:TEXT)		, Trim(_aDados[1][2][_nPos]:_OPE_INT_ID:TEXT) )


// ---	Limpa a variavel a log
_aLog				:= {}

// --- Validacao do telefone obtido na interface atraves do CNPJ informado
// --- Localiza os dados do solicitante/devedor como Solicitantes
If _cInf == '_DF0'
	
	// ---	Define solicitante
	// ---	Ja identifica o CNPJ para tratamento
	_cCNPJ		:=	Iif ( _nTipo == 1, _aDados[1][2]:_EMP_STR_CNPJ:TEXT, _aDados[1][2][1]:_EMP_STR_CNPJ:TEXT)
	_aDDDRet	:= 	GetAdvFVal('DUE',{'DUE_DDD','DUE_TEL'},xFilial('DUE')+Iif ( _nTipo == 1, _aDados[1][2]:_EMP_STR_CNPJ:TEXT, _aDados[1][2][1]:_EMP_STR_CNPJ:TEXT),5,{'',''} )
	
	// ---	Forca a CNH sempre um dos CNPJ CNH ou Iveco
	//	--- Identifica como o destinatario
	If At(SubStr(_cCNPJ,1,8),GetMv('ES_CGCDEV')) == 0
		
		//	---	Se nao localizou, tenta identificar como fornecedor
		_cCNPJ		:=	Iif ( _nTipo == 1, _aDados[1][2]:_CNPJFORNECEDOR:TEXT, _aDados[1][2][1]:_CNPJFORNECEDOR:TEXT)
		If	At(SubStr(_cCNPJ,1,8),GetMv('ES_CGCDEV')) > 0
			_aDDDRet	:= 	GetAdvFVal('DUE',{'DUE_DDD','DUE_TEL'},xFilial('DUE')+Iif ( _nTipo == 1, _aDados[1][2]:_CNPJFORNECEDOR:TEXT, _aDados[1][2][1]:_CNPJFORNECEDOR:TEXT),5,{'',''} )
			
			//	--- Se nao localicou busca o primeiro CNPJ IVECO ou CNH
		Else
			
			//	---	Tenta localizar o devedor pelo campo empresadestino
			_cEmpDest	:=	Iif ( _nTipo == 1, _aDados[1][2]:_EMPRESADESTINO:TEXT		, _aDados[1][2][_nPos]:_EMPRESADESTINO:TEXT )
			
			//	---	Identifica a palavra IVECO
			If At('IVECO',Upper(_cEmpDest)) > 0
				
				// ---	Sugere primeira IVECO encontrada na base
				// _cCNPJ 	:= Posicione('SA1',1,xFilial('SA1')+SubStr(GetMv('ES_CGCDEV'),11,8),'A1_CGC')
				// Por: Ricardo - Em: 11/06/2015
				_cCNPJ 	:= Posicione('SA1',3,xFilial('SA1')+SubStr(GetMv('ES_CGCDEV'),11,8),'A1_CGC')				
				_aDDDRet	:= 	GetAdvFVal('DUE',{'DUE_DDD','DUE_TEL'},xFilial('DUE') + _cCNPJ,5,{'',''} )
				//	---	CNH
			Else
				
				//	---	Sugere primeira CNH encontrada na base
				// _cCNPJ 	:= Posicione('SA1',1,xFilial('SA1')+SubStr(GetMv('ES_CGCDEV'),2,8),'A1_CGC')
				// Por: Ricardo - Em: 11/06/2015				
				_cCNPJ 	:= Posicione('SA1',3,xFilial('SA1')+SubStr(GetMv('ES_CGCDEV'),2,8),'A1_CGC')				
				_aDDDRet	:= 	GetAdvFVal('DUE',{'DUE_DDD','DUE_TEL'},xFilial('DUE') + _cCNPJ,5,{'',''} )
				
			EndIf
			
		EndIf
		
	EndIf
	
	// --- Se vazio considera o cliente generico
	If Empty(_aDDDRet[1]+_aDDDRet[2])
		
		// --- Localiza os dados do cliente/solicitante generico
		_cCNPJGen	:= 	GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+_cCliGen+_cLojGen,1,'')
		_aDDDRet	:= 	GetAdvFVal('DUE',{'DUE_DDD','DUE_TEL'},xFilial('DUE')+_cCNPJGen,5,{'',''} )
		
		// --- Adiciona outras informacoes do solicitante/destinatario/devedor
		aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJGen,3,'') )
		aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCNPJGen,3,'') )
		aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCNPJGen,3,'') )
		
		// --- Devolve o conteudo do CNPJ para variavel, vai registrar no log
		_cCNPJ		:=	Iif ( _nTipo == 1, _aDados[1][2]:_EMP_STR_CNPJ:TEXT, _aDados[1][2][1]:_EMP_STR_CNPJ:TEXT)
		
		// --- Grava log e define status de gravacao do plano
		aAdd( _aLog, { _nPlanoId, '000', _cinterface060, dDataBase, Time() ,'Solicitante nao cadastrado!', 'CNPJ : '+Transform(_cCNPJ,'@R 99.999.999/9999-99')+' cadastre o cliente e o solicitante e importe o plano novamente!', UsrRetName(RetCodUsr()),'0' } )
		
		// --- Grava na ultima posicao da array o status do plano de transporte -
		aAdd( _aDDDRet, '1' )
		
	Else
		
		// ---	Adiciona dados do solicitante
		aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJ,3,'') )
		aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCNPJ,3,'') )
		aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCNPJ,3,'') )
		
		// --- Grava na ultima posicao da array o status do plano de transporte - Libera o plano
		aAdd( _aDDDRet, '0' )
		
		// --- Grava log e define status de gravacao do plano
		aAdd( _aLog, { _nPlanoId, '000', _cinterface060, dDataBase, Time() ,'Solicitante cadastrado!', 'Importado com sucesso!', UsrRetName(RetCodUsr()),'1' } )
		
	EndIf
	
	// ---	Grava Log com validacao realizada e limpera variavel
	INTCNHGLOG(_aLog)
	
	// --- Validacao de campos para o item do agendamento
ElseIf _cInf == '_DF1'
	
	// ---	Tratamento para as operacoes conforme tabela CNH
	_cOper	:=	Iif ( _nTipo == 1, Trim(_aDados[1][2]:_OPE_INT_ID:TEXT)		, Trim(_aDados[1][2][_nPos]:_OPE_INT_ID:TEXT) )
	
	// ---	Se for operacao LTL direciona o destinatario para o CDC correspondente
	If	_cOper == '4'
		
		// --- 	Obtem a regiao do remetente
		_aDDDRet	:= 	GetAdvFVal('SA1',{'A1_COD','A1_LOJA','A1_CDRDES'},xFilial('SA1')+Iif ( _nTipo == 1, _aDados[1][2]:_CNPJFORNECEDOR:TEXT, _aDados[1][2][_nPos]:_CNPJFORNECEDOR:TEXT),3,{'','',''} )
		
		// --- Se vazio considera o cliente generico
		If Empty(_aDDDRet[1]+_aDDDRet[2]+_aDDDRet[3])
			
			// --- Localiza os dados do cliente/solicitante generico
			_cCNPJGen	:= 	GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+_cCliGen+_cLojGen,1,'')
			_aDDDRet	:= 	GetAdvFVal('SA1',{'A1_COD','A1_LOJA','A1_CDRDES'},xFilial('SA1')+_cCNPJGen,3,{'','',''} )
			
			// --- Devolve o conteudo do CNPJ para variavel, vai registrar no log
			_cCNPJ		:=	Iif ( _nTipo == 1, _aDados[1][2]:_CNPJFORNECEDOR:TEXT, _aDados[1][2][_nPos]:_CNPJFORNECEDOR:TEXT)
			
			// --- Grava log e define status de gravacao do plano
			aAdd( _aLog, { _nPlanoId, StrZero(_nPos,TamSX3('PA3_ITEM')[1]) ,_cinterface060, dDataBase, Time() ,'Remetente nao cadastrado!', 'CNPJ : '+Transform(_cCNPJ,'@R 99.999.999/9999-99')+' cadastre o remetente e importe o plano novamente!', UsrRetName(RetCodUsr()),'0' } )
			
			// ---	Adiciona informacoes sobre o destinatario
			aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCliGen+_cLojGen,1,'') )
			aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCliGen+_cLojGen,1,'') )
			aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCliGen+_cLojGen,1,'') )
			
			
			// ---	Adiciona informacoes sobre o devedor
			aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCliGen+_cLojGen,1,'') )
			aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCliGen+_cLojGen,1,'') )
			aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCliGen+_cLojGen,1,'') )
			
			// --- Bloquea o plano ma posicao da array o status do plano de transporte -
			aAdd( _aDDDRet, '1' )
			
			// --- Se encontrou obtem a regiao de destino CDC
		Else
			
			// ---	Estado de destino
			_cEstCDC	:= GetAdvFVal('DUY','DUY_EST'	,xFilial('DUY')+_aDDDRet[3],1,'')
			_cRegCDC	:= GetAdvFVal('DUY','DUY_GRPVEN',xFilial('DUY')+_aDDDRet[3],1,'')
			
			// ---	Consistencia
			If _cEstCDC	== 'SP'
				
				// ---	CDC do estado de SP
				_cCliCDC	:=	SubStr(GetMv('ES_CDCSP'),1,TamSX3('A1_COD')[1])
				_cLojCDC	:= 	SubStr(GetMv('ES_CDCSP'),Len(_cCliCDC)+1,TamSX3('A1_LOJA')[1])
				
			ElseIf _cEstCDC	== 'PR'
				
				// ---	CDC do estado de PR
				_cCliCDC	:=	SubStr(GetMv('ES_CDCPR'),1,TamSX3('A1_COD')[1])
				_cLojCDC	:= 	SubStr(GetMv('ES_CDCPR'),Len(_cCliCDC)+1,TamSX3('A1_LOJA')[1])
				
			ElseIf _cEstCDC	== 'MG'
				
				// ---	CDC do estado de MG
				// ---	Verifica se a regiao esta dentro de SUL de Minas ou no estado
				_nPosReg :=  At(_cRegCDC,GetMv('ES_CDCMGSR'))
				
				// ---	Se localizou no CDC direciona o destino para o SP
				If _nPosReg	> 0
					
					// ---	CDC do estado de SP
					_cCliCDC	:=	SubStr(GetMv('ES_CDCSP'),1,TamSX3('A1_COD')[1])
					_cLojCDC	:= 	SubStr(GetMv('ES_CDCSP'),Len(_cCliCDC)+1,TamSX3('A1_LOJA')[1])
					
					// ---	Se não pertence direciona para o CDC de Minas Gerais
				Else
					
					// ---	CDC do estado de MG
					_cCliCDC	:=	SubStr(GetMv('ES_CDCMG'),1,TamSX3('A1_COD')[1])
					_cLojCDC	:= 	SubStr(GetMv('ES_CDCMG'),Len(_cCliCDC)+1,TamSX3('A1_LOJA')[1])
					
				EndIf
				
			EndIf
			
			// ---	Adiciona Retorno para destino
			aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCliCDC+_cLojCDC,1,'') )
			aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCliCDC+_cLojCDC,1,'') )
			aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCliCDC+_cLojCDC,1,'') )
			
			// ---	Atualiza CNPJ para definir pagador de frete
			_cCNPJ		:=	Iif ( _nTipo == 1, _aDados[1][2]:_CNPJFORNECEDOR:TEXT, _aDados[1][2][_nPos]:_CNPJFORNECEDOR:TEXT)
			
			// ---	Definir o devedor do frete sempre CNH/IVECO.
			If At(SubStr(_cCNPJ,1,8),GetMv('ES_CGCDEV')) > 0
				
				// ---	Adiciona Retorno para devedor
				aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJ,3,'') )
				aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCNPJ,3,'') )
				aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCNPJ,3,'') )
				
				// --- Libera pelo devedor
				aAdd( _aDDDRet, '0' )
				
			Else
				
				// ---	Definir o devedor do frete sempre CNH/IVECO.
				_cCNPJ		:=	Iif ( _nTipo == 1, _aDados[1][2]:_EMP_STR_CNPJ:TEXT, _aDados[1][2][_nPos]:_EMP_STR_CNPJ:TEXT)
				
				If	At(SubStr(_cCNPJ,1,8),GetMv('ES_CGCDEV')) > 0
					
					// ---	Adiciona Retorno para devedor
					aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJ,3,'') )
					aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCNPJ,3,'') )
					aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCNPJ,3,'') )
					
					// --- Libera pelo devedor
					aAdd( _aDDDRet, '0' )
					
					//	--- O devedor nao foi localizado, forca o primeiro CNPJ IVECO/CNH
				Else
					
					//	---	De acordo com o plano sugere o CNPJ
					// ---	Força a gravação do devedor como sendo do solicitante.
					_cCNPJ	:= GetAdvFVal('DUE','DUE_CGC',xFilial('DUE')+DF0->DF0_DDD+DF0->DF0_TEL,1,'')
					
					// ---	Adiciona Retorno para devedor generico, pois nao localizou
					aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJ,3,'') )
					aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCNPJ,3,'') )
					aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCNPJ,3,'') )
					
					// --- Bloquea pelo devedor
					aAdd( _aDDDRet, '0' )
					
					// --- Grava log e define status de gravacao do plano
					aAdd( _aLog, { _nPlanoId, StrZero(_nPos,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Devedor nao localizado!', 'Sugerido CNPJ '+Transform(_cCNPJ,'@R 99.999.999/9999-99'), UsrRetName(RetCodUsr()), '1' } )
					
					
				EndIf
			EndIf
		EndIf
	Else
		
		// --- 	Verifica se existe o remetente e retorna o DDD
		_aDDDRet	:= 	GetAdvFVal('SA1',{'A1_COD','A1_LOJA','A1_CDRDES'},xFilial('SA1')+Iif ( _nTipo == 1, _aDados[1][2]:_CNPJFORNECEDOR:TEXT, _aDados[1][2][_nPos]:_CNPJFORNECEDOR:TEXT),3,{'','',''} )
		// --- Define CNPJ do remetente
		_cCNPJ		:=	Iif ( _nTipo == 1, _aDados[1][2]:_CNPJFORNECEDOR:TEXT, _aDados[1][2][_nPos]:_CNPJFORNECEDOR:TEXT)
		
		// --- Se vazio considera o cliente generico
		If Empty(_aDDDRet[1]+_aDDDRet[2]+_aDDDRet[3])
			
			// --- Localiza os dados do cliente/solicitante generico
			_cCNPJ		:= 	GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+_cCliGen+_cLojGen,1,'')
			_aDDDRet	:= 	GetAdvFVal('SA1',{'A1_COD','A1_LOJA','A1_CDRDES'},xFilial('SA1')+_cCNPJ,3,{'','',''} )
			
			// ---	Adiciona informacoes de destinatario
			aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCliGen+_cLojGen,1,'') )
			aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCliGen+_cLojGen,1,'') )
			aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCliGen+_cLojGen,1,'') )
			
			
			// ---	Adiciona informacoes de devedor
			aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCliGen+_cLojGen,1,'') )
			aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCliGen+_cLojGen,1,'') )
			aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCliGen+_cLojGen,1,'') )
			
			
			// --- Devolve o conteudo do CNPJ para variavel, vai registrar no log
			_cCNPJ		:=	Iif ( _nTipo == 1, _aDados[1][2]:_CNPJFORNECEDOR:TEXT, _aDados[1][2][_nPos]:_CNPJFORNECEDOR:TEXT)
			
			// --- Grava log e define status de gravacao do plano
			aAdd( _aLog, { _nPlanoId, StrZero(_nPos,TamSX3('PA3_ITEM')[1]) ,_cinterface060, dDataBase, Time() ,'Remetente nao cadastrado!', 'CNPJ : '+Transform(_cCNPJ,'@R 99.999.999/9999-99')+' cadastre o remetente e importe o plano novamente!', UsrRetName(RetCodUsr()),'0' } )
			
			// ---	Bloquea o plano
			aAdd( _aDDDRet, '1' )
			
			
		Else
			
			// --- Grava log e define status de gravacao do plano
			aAdd( _aLog, { _nPlanoId, StrZero(_nPos,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Remetente localizado!', 'Importado com sucesso!', UsrRetName(RetCodUsr()), '1' } )
			
			// ---	Grava Log com validacao realizada e limpera variavel
			INTCNHGLOG(_aLog)
			
			// --- Define o destinatario
			_cCNPJDes	:=	Iif ( _nTipo == 1, _aDados[1][2]:_EMP_STR_CNPJ:TEXT, _aDados[1][2][_nPos]:_EMP_STR_CNPJ:TEXT)
			
			// ---	Verifica se o destinatario e o pagador do frete
			If At(SubStr(_cCNPJDes,1,8),GetMv('ES_CGCDEV')) > 0
				
				// ---	Adiciona informacoes de destinatario
				aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJDes,3,'') )
				aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCNPJDes,3,'') )
				aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCNPJDes,3,'') )
				
				// ---	Adiciona informacoes de devedor
				aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJDes,3,'') )
				aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCNPJDes,3,'') )
				aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCNPJDes,3,'') )
				
				// ---	Libera o plano
				aAdd( _aDDDRet, '0' )
				
			Else
				//	---	Verifica se o remetente e o pagador do frete
				If	At(SubStr(_cCNPJ,1,8),GetMv('ES_CGCDEV')) > 0
					
					//	---	Verifica se o destinatario existe no cadastro
					If Empty( GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJDes,3,'') )
						
						//	---	Considera o gererico como destinatário e bloqueia o plano
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJGen,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCNPJGen,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCNPJGen,3,'') )
						
						// ---	Adiciona informacoes de devedor
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJGen,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCNPJGen,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCNPJGen,3,'') )
						
						//	---	Limpa log
						_aLog	:= {}
						
						// --- Grava log e define status de gravacao do plano
						aAdd( _aLog, { _nPlanoId, StrZero(_nPos,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Destinatario nao localizado!', 'CNPJ : '+Transform(_cCNPJDes,'@R 99.999.999/9999-99')+' cadastre o destinatario e importe o plano novamente!', UsrRetName(RetCodUsr()), '0' } )
						
						// ---	Grava Log com validacao realizada e limpera variavel
						INTCNHGLOG(_aLog)
						
						
						// --- Bloquea o plano
						aAdd( _aDDDRet, '1')
						
					Else
						
						// ---	Adiciona informacoes de destinatario
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJDes,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCNPJDes,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCNPJDes,3,'') )
						
						// ---	Adiciona informacoes de devedor
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJ,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCNPJ,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCNPJ,3,'') )
						
						// --- Libera o plano
						aAdd( _aDDDRet, '0')
						
					EndIf
					
				Else
					
					//	---	O devedor não eh o destinatario nem o remetente
					// ---	Adiciona informacoes de destinatario
					If Empty( GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJDes,3,'') )
						
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJGen,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCNPJGen,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCNPJGen,3,'') )
						
						//	---	De acordo com o plano sugere o CNPJ do solicitante
						_cCNPJ	:= GetAdvFVal('DUE','DUE_CGC',xFilial('DUE')+DF0->DF0_DDD+DF0->DF0_TEL,1,'')
						
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJ,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCNPJ,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCNPJ,3,'') )
						
						//	---	Limpa log
						_aLog	:= {}
						
						// --- Grava log e define status de gravacao do plano
						aAdd( _aLog, { _nPlanoId, StrZero(_nPos,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Destinatario nao localizado!', 'Destinatario nao localizado CNPJ : '+Transform(_cCNPJDes,'@R 99.999.999/9999-99'), UsrRetName(RetCodUsr()), '0' } )
						
						// --- Bloqueia o plano por conta do cliente generico
						aAdd( _aDDDRet, '1')
						
					Else
						
						//	--- Destinatario
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJDes,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCNPJDes,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCNPJDes,3,'') )
						
						//	---	De acordo com o plano sugere o CNPJ do solicitante como devedor
						_cCNPJ	:= GetAdvFVal('DUE','DUE_CGC',xFilial('DUE')+DF0->DF0_DDD+DF0->DF0_TEL,1,'')
						
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_COD',xFilial('SA1')+_cCNPJ,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_LOJA',xFilial('SA1')+_cCNPJ,3,'') )
						aAdd( _aDDDRet, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cCNPJ,3,'') )
						
						//	---	Limpa log
						_aLog	:= {}
						
						// --- Grava log e define status de gravacao do plano
						aAdd( _aLog, { _nPlanoId, StrZero(_nPos,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Devedor nao localizado!', 'Devedor do frete nao identificado, sugerido CNPJ : '+Transform(_cCNPJ,'@R 99.999.999/9999-99'), UsrRetName(RetCodUsr()), '1' } )
						
						// --- Libera o plano
						aAdd( _aDDDRet, '0')
						
					EndIf
					
					// ---	Grava Log com validacao realizada e limpera variavel
					INTCNHGLOG(_aLog)
					
				EndIf
				
			EndIf
			
		EndIf
		
	EndIf
	
	// ---	Grava Log com validacao realizada e limpera variavel
	If Len(_aLog) > 0
		INTCNHGLOG(_aLog)
	EndIf
	
	// --- Verifica se os parametros foram preenchidos
	If Len(_aOper) > 0 .and. Len(_aServ) > 0
		
		// --- Primeira posicao tipo de viagem 2-Simpes ou 3-Retorno
		// --- Viagem | Operacao | Raio
		_cOper	:=	Iif ( _nTipo == 1, Trim(_aDados[1][2]:_VIA_INT_ID:TEXT)		, Trim(_aDados[1][2][_nPos]:_VIA_INT_ID:TEXT) )
		_cOper	+=	Iif ( _nTipo == 1, Trim(_aDados[1][2]:_OPE_INT_ID:TEXT)		, Trim(_aDados[1][2][_nPos]:_OPE_INT_ID:TEXT) )
		_cOper	+=	Iif ( _nTipo == 1, Trim(_aDados[1][2]:_CON_BIT_ABAIXO:TEXT)	, Trim(_aDados[1][2][_nPos]:_CON_BIT_ABAIXO:TEXT) )
		
		// --- Localiza o codigo da operacao no retorno do parametro
		_nPosSrv	:= Ascan( _aOper, { |x| Trim(x) == Trim(_cOper) } )
		
		// --- Se localizou o servico correspondente
		If _nPosSrv	> 0
			
			// --- Obtem o codigo do servico
			_cServ	:= _aServ[_nPosSrv]
			
			// --- Grava log e define status de gravacao do plano
			aAdd( _aLog, { _nPlanoId, StrZero(_nPos,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Viagem Operacao Raio!', 'Tipo de viagem, tipo de operacao e raio localizado!', UsrRetName(RetCodUsr()), '1' } )
			
			// ---	Se o plano estiver bloqueado, grava servico mas mantem bloqueio
			If _aDDDRet[Len(_aDDDRet)] == '1'
				
				// ---	Adiciona servico encontrado mas mantem plano bloqueado
				_aDDDRet[Len(_aDDDRet)] := _cServ
				
				// --- Grava na ultima posicao da array o status do plano de transporte - Libera o plano
				aAdd( _aDDDRet, '1' )
			Else
				// ---	Adiciona servico encontrado mas mantem plano liberado
				_aDDDRet[Len(_aDDDRet)] := _cServ
				
				// --- Grava na ultima posicao da array o status do plano de transporte - Bloqueia o plano
				aAdd( _aDDDRet, '0' )
			EndIf
			
		Else
			// --- Obtem o codigo do servico
			_cServ	:= ''
			
			// --- Grava log e define status de gravacao do plano
			aAdd( _aLog, { _nPlanoId, StrZero(_nPos,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Viagem Operacao Raio!', 'Servico nao localizado para o conjunto Viagem, operacao e raio, verifique cadastros e importe o plano!', UsrRetName(RetCodUsr()),'0' } )
			
			// --- Grava o servico selecionado para gravar no agendamento
			If _aDDDRet[Len(_aDDDRet)] == '0'
				
				// ---	Adiciona servico encontrado mas mantem plano bloqueado
				_aDDDRet[Len(_aDDDRet)] := _cServ
				
				// --- Grava na ultima posicao da array o status do plano de transporte - Libera o plano
				aAdd( _aDDDRet, '1' )
			Else
				// ---	Adiciona servico encontrado mas mantem plano bloqueado
				_aDDDRet[Len(_aDDDRet)] := _cServ
				
				// --- Grava na ultima posicao da array o status do plano de transporte - Libera o plano
				aAdd( _aDDDRet, '1' )
			EndIf
			
		EndIf
		
		// ---	Grava Log com validacao realizada e limpera variavel
		INTCNHGLOG(_aLog)
		
		//--- Problema no conteudo dos parametros
	Else
		
		// --- Obtem o codigo do servico
		_cServ	:= ''
		
		// --- Grava log e define status de gravacao do plano
		aAdd( _aLog, { _nPlanoId, StrZero(_nPos,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Viagem Operacao Raio!', 'Verifique os parametros ES_CNHOPER ou ES_CNHSERV e importe o plano novamente!', UsrRetName(RetCodUsr()), '0' } )
		
		// --- Grava o servico selecionado para gravar no agendamento
		_aDDDRet[Len(_aDDDRet)] := _cServ
		
		// --- Grava na ultima posicao da array o status do plano de transporte - Bloquea o plano
		aAdd( _aDDDRet, '1' )
		
		// ---	Grava Log com validacao realizada e limpera variavel
		INTCNHGLOG(_aLog)
		
	EndIf
	
	
	// --- Validacao de campos para o componente do item do agendamento
ElseIf _cInf == '_DF3'
	
	// --- Verifica se o componente existe
	If ! Empty(GetAdvFVal('DT3','DT3_CODPAS',xFilial('DT3')+_cCompPdg,1,''))
		
		// --- Adiciona elementos da validacao para retorno
		Aadd( _aDDDRet, _cCompPdg )
		Aadd( _aDDDRet, Iif ( _nTipo == 1, Val(_aDados[1][2]:_ROT_DOU_PEDAGIO:TEXT), Val(_aDados[1][2][_nPos]:_ROT_DOU_PEDAGIO:TEXT) ) )
		
		// --- Grava na ultima posicao da array o status do plano de transporte - Libera o plano
		aAdd( _aDDDRet, Iif( _cStPlan == '0', '0', '1') )
		
		// --- Grava log e define status de gravacao do plano
		aAdd( _aLog, { _nPlanoId, StrZero(_nPos,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Componente Pedagio!', 'Componente localizado, importado com sucesso!', UsrRetName(RetCodUsr()),'1' } )
		
	Else
		
		// --- Adiciona elementos da validacao para retorno
		Aadd( _aDDDRet, '' )
		Aadd( _aDDDRet, Iif ( _nTipo == 1, Val(_aDados[1][2]:_ROT_DOU_PEDAGIO:TEXT), Val(_aDados[1][2][_nPos]:_ROT_DOU_PEDAGIO:TEXT) ) )
		
		// --- Grava na ultima posicao da array o status do plano de transporte - Libera o plano
		aAdd( _aDDDRet, '1' )
		
		// --- Grava log e define status de gravacao do plano
		aAdd( _aLog, { _nPlanoId, StrZero(_nPos,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Componente Pedagio!', 'Componente nao localizado, cadastre o componente e importe o plano novamente!', UsrRetName(RetCodUsr()),'0' } )
		
	EndIf
	
	// ---	Grava Log com validacao realizada e limpera variavel
	INTCNHGLOG(_aLog)
	
	// --- Validacao de campos para o tipo de veiculo do item do agendamento
ElseIf _cInf == '_DF5'
	
	// --- Verifica se o veiculo informado existe no cadastro
	// --- Tabela de para no parametro
	_cTabVei	:= 	GetMV('ES_CNHTVEI',,'')
	_aTabVei   	:= 	Iif(!Empty(_cTabVei),&_cTabVei,{})
	
	// --- Verifica se o tipo de veiculo informado no plano consta na tabela origem
	_cTipVei	:=	Iif( _nTipo == 1, Trim(_aDados[1][2]:_VEI_INT_ID:TEXT), Trim(_aDados[1][2][_nPos]:_VEI_INT_ID:TEXT) )
	_nPosVei	:= 	Ascan( _aTabVei[1] , { |x| Trim(x) == Trim(_cTipVei) } )
	
	// --- Nao achou o tipo de veiculo na tabela original
	If _nPosVei == 0
		
		// --- Grava log e define status de gravacao do plano
		aAdd( _aLog, { _nPlanoId, StrZero(_nPos,TamSX3('PA3_ITEM')[1]) ,_cinterface060, dDataBase, Time() ,'Tipo de Veiculo',;
			'O tipo de veiculo ' +_cTipVei+'-'+Iif( _nTipo == 1, Trim(_aDados[1][2]:_VEI_STR_DESCRICAO:TEXT), Trim(_aDados[1][2][_nPos]:_VEI_STR_DESCRICAO:TEXT) )+'recebido nao consta na lista original da CNH!',;
			UsrRetName(RetCodUsr()),'0' } )
		
		
		// --- Grava na ultima posicao da array o status do plano de transporte -
		aAdd( _aDDDRet, '' )
		aAdd( _aDDDRet, '1' )
		
	Else
		
		// --- Verifica relação De/Para com tipos do sistema
		_cTipVei	:= 	GetAdvFVal('DUT','DUT_TIPVEI',xFilial('DUT')+_aTabVei[2,_nPosVei],1,'')
		
		// -- Se o tipo nao estiver cadastrado no sistema
		If Empty(_cTipVei)
			
			// --- Grava log e define status de gravacao do plano
			aAdd( _aLog, { _nPlanoId, StrZero(_nPos,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Tipo de Veiculo',;
				'Tipo de veiculo '+_aTabVei[1,_nPosVei]+' recebido nao localizado no cadastro do sistema, cadastre e importe o plano novamente!', UsrRetName(RetCodUsr()),'0' } )
			
			// --- Grava na ultima posicao da array o status do plano de transporte - Libera o plano
			aAdd( _aDDDRet, '' )
			aAdd( _aDDDRet, '1' )
			
		Else
			
			// --- Grava log e define status de gravacao do plano
			aAdd( _aLog, { _nPlanoId, StrZero(_nPos,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Tipo de Veiculo',;
				'Tipo de veiculo '+_aTabVei[2,_nPosVei]+' recebido com sucesso!', UsrRetName(RetCodUsr()),'1' } )
			
			// --- Grava na ultima posicao da array o status do plano de transporte - Libera o plano
			aAdd( _aDDDRet, _aTabVei[2,_nPosVei] )
			aAdd( _aDDDRet, Iif (_cStPlan == '0','0','1') )
			
		EndIf
		
	EndIf
	
	// ---	Grava Log com validacao realizada e limpera variavel
	INTCNHGLOG(_aLog)
	
EndIf

// --- Copia retorno
_aValid		:= Aclone(_aDDDRet)

Return _aValid


/*/{Protheus.doc} INTCNHTT
Função responsável por realizar os calculos de data e hora a partir da previsao da coleta,
franquia e transit time do plano de transporte.
@author 	Luiz Alexandre Ferreira
@since 		26/11/2014
@version 	1.0
@param 		_aDados, ${param_type}, (Descrição do parâmetro)
@param 		_aRetKm, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function INTCNHTT(_dDtPrevCol,_cHrPrevCol,_cTTime)

//	---	Variaveis utilizadas
Local	_aRet		:=	{}
Local	_nHrAux	:= 	0
Local	_nDtAux 	:=	0
Local	_nMRest	:= 	0

_cHrFranq	:=	GetMv('ES_CNHFRQ',,'01:00')

// ---	Data e hora previsao da Saida da coleta
_nHrAux	:= SomaHoras(  Val(_cHrPrevCol)/100 , Val(StrTran(_cHrFranq,':','.')) )

If NoRound(_nHrAux / 24,0) > 0
	_nDtAux	:=	Round(_nHrAux / 24,0)
	_nMRest	:=	Round( _nHrAux%24,0 )
EndIf

//	---	Adiciona os retornos na array
Aadd( _aRet,	_dDtPrevCol+_nDtAux	)
If _nMRest > 0
	Aadd( _aRet, _nMRest)
Else
	If _nMRest == 0 .and. _nDtAux > 0
		Aadd( _aRet, 0)
	Else
		Aadd( _aRet, _nHrAux)
	EndIf
EndIf

_nDtAux	:=	0
_nMRest	:=	0

// ---	Data e hora previsao de entrega
_nHrAux	:= SomaHoras(  _aRet[2] , Val(_cTTime)/100  )

If NoRound(_nHrAux / 24,0) > 0
	_nDtAux	:=	Round(_nHrAux / 24,0)
	_nMRest	:=	Round( _nHrAux%24,0 )
EndIf

//	---	Adiciona os retornos na array
Aadd( _aRet,	_aRet[1]+_nDtAux	)
If _nMRest > 0
	Aadd( _aRet, _nMRest)
Else
	If _nMRest == 0 .and. _nDtAux > 0
		Aadd( _aRet, 0)
	Else
		Aadd( _aRet, _nHrAux)
	EndIf
EndIf

_nDtAux	:=	0
_nMRest	:=	0

// ---	Data e hora previsao real de entrega
_nHrAux	:= SomaHoras(  Val(_cHrPrevCol)/100 , Val(_cTTime)/100 )

If NoRound(_nHrAux / 24,0) > 0
	_nDtAux	:=	Round(_nHrAux / 24,0)
	_nMRest	:=	Round( _nHrAux%24,0 )
EndIf

//	---	Adiciona os retornos na array
Aadd( _aRet,	_dDtPrevCol+_nDtAux	)
If _nMRest > 0
	Aadd( _aRet, _nMRest)
Else
	If _nMRest == 0 .and. _nDtAux > 0
		Aadd( _aRet, 0)
	Else
		Aadd( _aRet, _nHrAux)
	EndIf
EndIf

Return _aRet


/*/{Protheus.doc} INTCNHKM
Função responsável por realizar o controle de Km, verificar se a distância
enviada no plano está dentro dos parâmetros cadastrados na GEFCO conforme
tabela PA4.
05/01/2015 - Alterado o critério de conferencia por grupo de tipos de veiculos.
@author 	Luiz Alexandre Ferreira
@since 		26/11/2014
@version 	2.0
@param 		_aDados, ${param_type}, (Descrição do parâmetro)
@param 		_aRetKm, ${param_type}, (Descrição do parâmetro)
@return 	${_aRet}, ${Array contendo [1] sequencial, [2] Remetente, [3] Distancia cadastrada, [4] Rateio Km, [5] Rateio Pedagio, [6] Controle Bloqueio }
@example
(examples)
@see (links_or_references)
/*/Static Function INTCNHKM(_aDados)

// ---	Variaveis utilizadas
Local _aRatKm		:= 	{}
Local _aRet		:= 	{}
Local _nRestKm	:= 	0
Local _nRestPdg	:= 	0
Local _nX			:= 	0
Local _nItens		:=	0
Local _nTipo		:= 	0
Local _nPos		:= 	0
Local _nAvalKm	:= 	0
Local _cCNPJ		:= 	''
Local _nTotKm		:= 	0
Local _nKmPlan	:= 	0
Local _nVlrPdg	:= 	0
Local _nPosReg	:= 	0
Local _cOper		:= 	''
Local _cEstCDC	:= 	''
Local _cRegCDC	:= 	''
Local _cCliCDC	:=	''
Local _cLojCDC	:= 	''
Local _alTpVei	:= 	{}
Local _clTpVei	:= 	''
Local _clTpPlan	:= 	''
Local _clTabVei	:=	''
Local _alTabVei	:=	{}
Local _nlTpVei	:=	0
Local _nlPosVei	:=	0
Local _llBlqKm	:=	.f.

// --- Estrutura de retorno _aRet
// --- |Indice	|Km por ponto	|Status	|Km Frete Rateado

// ---	Verifica quantidade de itens do agendamento
// --- _aLog		:= 	{}
_nTipo		:= 	Iif ( ValType(_aDados[1][2]) == 'O', 1, 2  )
_nItens	:= 	Iif ( _nTipo == 1, 1, Len(_aDados[1][2]) )
_nKmPlan	:=	Iif ( _nTipo == 1, Val(_aDados[1][2]:_ROT_INT_KM:TEXT)		, Val(_aDados[1][2][1]:_ROT_INT_KM:TEXT) )
_nVlrPdg  	:=	Iif ( _nTipo == 1, Val(_aDados[1][2]:_ROT_DOU_PEDAGIO:TEXT)	, Val(_aDados[1][2][1]:_ROT_DOU_PEDAGIO:TEXT) )
_cOper		:=	Iif ( _nTipo == 1, Trim(_aDados[1][2]:_OPE_INT_ID:TEXT)		, Trim(_aDados[1][2][1]:_OPE_INT_ID:TEXT) )
_clTpPlan	:=	Iif ( _nTipo == 1, Trim(_aDados[1][2]:_VEI_INT_ID:TEXT)		, Trim(_aDados[1][2][1]:_VEI_INT_ID:TEXT) )

//	---	Se o controle de bloqueio esta ativado
_llBlqKm	:=	GetMv('ES_CNHBLKM',,.f.)

//	---	Grupo de tipos de veiculo
_clTpVei	:= 	GetMV('ES_CNHGVEI')
_alTpVei 	:= 	Iif(!Empty(_clTpVei),&_clTpVei,{})

//	---	Tipo de veiculo do plano de tranporte
_clTabVei	:= 	GetMV('ES_CNHTVEI')
_alTabVei 	:= 	Iif(!Empty(_clTabVei),&_clTabVei,{})

// --- Verifica se o tipo de veiculo informado no plano consta na tabela origem
_nlPosVei	:= 	Ascan( _alTabVei[1] , { |x| Trim(x) == Trim(_clTpPlan) } )
_clTabVei	:=	Iif( _nlPosVei > 0, _alTabVei[2][_nlPosVei], 'NN')

//	---	Localiza o grupo de tipo de veiculo
//	---	Primeiro grupo
_nlTpVei	:=	Ascan( _alTpVei[1] , { |x| Trim(x) == Trim(_clTabVei) } )

//	---	Caso nao localize procura no segundo grupo
If _nlTpVei > 0
	_clTpVei	:=	'01'
	
	//	--- Tenta localizar no segundo grupo
Else
	_nlTpVei	:=	Ascan( _alTpVei[2] , { |x| Trim(x) == Trim(_clTabVei) } )
	_clTpVei	:=	Iif (_nlTpVei > 0, '02','99')
EndIf

// ---	Copia os dados recebidos de fornecedor e destinatario
For _nX	:= 1 to _nItens
	
	
	// ---	Tratamento para LTL
	If _cOper	== '4'
		
		// ---	Obtem Remetente e destinatario
		_cRem	:=	Iif ( _nTipo == 1, _aDados[1][2]:_CNPJFORNECEDOR:TEXT, _aDados[1][2][_nX]:_CNPJFORNECEDOR:TEXT)
		_cDest	:=	Iif ( _nTipo == 1, _aDados[1][2]:_EMP_STR_CNPJ:TEXT, _aDados[1][2][_nX]:_EMP_STR_CNPJ:TEXT)
		
		// ---	Dados do destino
		_cRegCDC	:=	GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cRem	,1,'')
		_cEstCDC	:=	GetAdvFVal('DUY','DUY_EST'	,xFilial('DUY')+_cRegCDC,1,'')
		
		// ---	Consistencia
		If _cEstCDC	== 'SP'
			
			// ---	CDC do estado de SP
			_cCliCDC	:=	SubStr(GetMv('ES_CDCSP'),1,TamSX3('A1_COD')[1])
			_cLojCDC	:= 	SubStr(GetMv('ES_CDCSP'),Len(_cCliCDC)+1,TamSX3('A1_LOJA')[1])
			_cDest		:= 	GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+_cCliCDC+_cLojCDC,1,'')
			
		ElseIf _cEstCDC	== 'PR'
			
			// ---	CDC do estado de PR
			_cCliCDC	:=	SubStr(GetMv('ES_CDCPR'),1,TamSX3('A1_COD')[1])
			_cLojCDC	:= 	SubStr(GetMv('ES_CDCPR'),Len(_cCliCDC)+1,TamSX3('A1_LOJA')[1])
			_cDest		:= 	GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+_cCliCDC+_cLojCDC,1,'')
			
		ElseIf _cEstCDC	== 'MG'
			
			// ---	CDC do estado de MG
			// ---	Verifica se a regiao esta dentro de SUL de Minas ou no estado
			_nPosReg :=  At(_cRegCDC,GetMv('ES_CDCMGSR'))
			
			// ---	Se localizou no CDC direciona o destino para o SP
			If _nPosReg	> 0
				
				// ---	CDC do estado de SP
				_cCliCDC	:=	SubStr(GetMv('ES_CDCSP'),1,TamSX3('A1_COD')[1])
				_cLojCDC	:= 	SubStr(GetMv('ES_CDCSP'),Len(_cCliCDC)+1,TamSX3('A1_LOJA')[1])
				_cDest		:= 	GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+_cCliCDC+_cLojCDC,1,'')
				
				// ---	Se não pertence direciona para o CDC de Minas Gerais
			Else
				
				// ---	CDC do estado de MG
				_cCliCDC	:=	SubStr(GetMv('ES_CDCMG'),1,TamSX3('A1_COD')[1])
				_cLojCDC	:= 	SubStr(GetMv('ES_CDCMG'),Len(_cCliCDC)+1,TamSX3('A1_LOJA')[1])
				_cDest		:= 	GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+_cCliCDC+_cLojCDC,1,'')
				
			EndIf
			
		EndIf
		
		// ---	Soma o Km conforme cadastro de distancias
		_nPos	:= Ascan ( _aRatKm, { |x| x[1] == _cRem } )
		
		// ---	Se nao localizou adiciona a primeira ocorrencia
		If _nPos == 0
			// ---	Adiciona contador
			Aadd( _aRatKm, { _cRem, 1 }  )
		Else
			// ---	Incrementa ocorrencias
			_aRatKm[_nPos,2]++
		EndIf
		
		// ---	Calcula a distancia a partir do final
		If _nX	== _nItens
			
			// ---	Localiza a distancia do cadastro
			PA4->(dbSetOrder(1))
			If PA4->(dbSeek(xFilial('PA4')+_cRem+_cDest+_clTpVei))
				
				// --- 	Adiciona distancia primeiro ponto
				Aadd( _aRet,  { _nX, _cRem, PA4->PA4_DIST, 0, 0, 0, _cDest, _clTpVei } )
			Else
				//	---	Aadd( _aRet,  { _nX, _cRem,0,0,0,1} ) 	//	---	Bloquea o plano
				//	---	Aadd( _aRet,  { _nX, _cRem,0,0,0,0} )	// --- Liberado temporariamente - conforme solicitado pelo Marchine em 17/09/2014
				//	---	[@2LGI - 26/11/2014] - Retorna controle de km somente para operacao FTL - conforme solicitado pela Cristiane em 12/11/2014
				Aadd( _aRet,  { _nX, _cRem ,0,0,0, Iif (_cOper == '3' .and. _llBlqKm , 1, 0), _cDest, _clTpVei  } )
				
			EndIf
			
			// ---	Adianta a distancia ponto a ponto da proxima linha
		Else
			
			// ---	Obtem Remetente e destinatario
			_cRem	:=	Iif ( _nTipo == 1, _aDados[1][2]:_CNPJFORNECEDOR:TEXT, _aDados[1][2][_nX]:_CNPJFORNECEDOR:TEXT)
			_cDest	:=	Iif ( _nTipo == 1, _aDados[1][2]:_CNPJFORNECEDOR:TEXT, _aDados[1][2][_nX+1]:_CNPJFORNECEDOR:TEXT)
			
			// ---	Dados do destino
			_cRegCDC	:=	GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+_cRem	,1,'')
			_cEstCDC	:=	GetAdvFVal('DUY','DUY_EST'	,xFilial('DUY')+_cRegCDC,1,'')
			
			// ---	Consistencia
			If _cEstCDC	== 'SP'
				
				// ---	CDC do estado de SP
				_cCliCDC	:=	SubStr(GetMv('ES_CDCSP'),1,TamSX3('A1_COD')[1])
				_cLojCDC	:= 	SubStr(GetMv('ES_CDCSP'),Len(_cCliCDC)+1,TamSX3('A1_LOJA')[1])
				_cDest		:= 	GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+_cCliCDC+_cLojCDC,1,'')
				
			ElseIf _cEstCDC	== 'PR'
				
				// ---	CDC do estado de PR
				_cCliCDC	:=	SubStr(GetMv('ES_CDCPR'),1,TamSX3('A1_COD')[1])
				_cLojCDC	:= 	SubStr(GetMv('ES_CDCPR'),Len(_cCliCDC)+1,TamSX3('A1_LOJA')[1])
				_cDest		:= 	GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+_cCliCDC+_cLojCDC,1,'')
				
			ElseIf _cEstCDC	== 'MG'
				
				// ---	CDC do estado de MG
				// ---	Verifica se a regiao esta dentro de SUL de Minas ou no estado
				_nPosReg :=  At(_cRegCDC,GetMv('ES_CDCMGSR'))
				
				// ---	Se localizou no CDC direciona o destino para o SP
				If _nPosReg	> 0
					
					// ---	CDC do estado de SP
					_cCliCDC	:=	SubStr(GetMv('ES_CDCSP'),1,TamSX3('A1_COD')[1])
					_cLojCDC	:= 	SubStr(GetMv('ES_CDCSP'),Len(_cCliCDC)+1,TamSX3('A1_LOJA')[1])
					_cDest		:= 	GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+_cCliCDC+_cLojCDC,1,'')
					
					// ---	Se não pertence direciona para o CDC de Minas Gerais
				Else
					
					// ---	CDC do estado de MG
					_cCliCDC	:=	SubStr(GetMv('ES_CDCMG'),1,TamSX3('A1_COD')[1])
					_cLojCDC	:= 	SubStr(GetMv('ES_CDCMG'),Len(_cCliCDC)+1,TamSX3('A1_LOJA')[1])
					_cDest		:= 	GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+_cCliCDC+_cLojCDC,1,'')
					
				EndIf
				
			EndIf
			
			// ---	Verifica se é o mesmo fornecedor para destinos diferentes
			If _cRem == _cDest
				_cDest	:=	Iif ( _nTipo == 1, _aDados[1][2]:_EMP_STR_CNPJ:TEXT, _aDados[1][2][_nX]:_EMP_STR_CNPJ:TEXT)
			EndIf
			
			// ---	Localiza a distancia do cadastro
			PA4->(dbSetOrder(1))
			If PA4->(dbSeek(xFilial('PA4')+_cRem+_cDest+_clTpVei))
				// --- Adiciona distancia primeiro ponto
				Aadd( _aRet,  { _nX, _cRem, PA4->PA4_DIST, 0, 0, 0, _cDest, _clTpVei } )
			Else
				//	---	Aadd( _aRet,  { _nX, _cRem,0,0,0,1} ) 	//	---	Bloquea o plano geral
				//	---	Aadd( _aRet,  { _nX, _cRem,0,0,0,0} )	// --- Liberado temporariamente - conforme solicitado pelo Marchine em 17/09/2014
				//	---	[@2LGI - 26/11/2014] - Retorna controle de km somente para operacao FTL - conforme solicitado pela Cristiane em 12/11/2014
				Aadd( _aRet,  { _nX, _cRem,0,0,0, Iif (_cOper == '3' .and. _llBlqKm , 1, 0), _cDest, _clTpVei } )
				
			EndIf
			
		EndIf
		
	Else
		
		// ---	Obtem Remetente e destinatario
		_cRem	:=	Iif ( _nTipo == 1, _aDados[1][2]:_CNPJFORNECEDOR:TEXT, _aDados[1][2][_nX]:_CNPJFORNECEDOR:TEXT)
		_cDest	:=	Iif ( _nTipo == 1, _aDados[1][2]:_EMP_STR_CNPJ:TEXT, _aDados[1][2][_nX]:_EMP_STR_CNPJ:TEXT)
		
		
		// ---	Soma o Km conforme cadastro de distancias
		_nPos	:= Ascan ( _aRatKm, { |x| x[1] == _cRem } )
		
		// ---	Se nao localizou adiciona a primeira ocorrencia
		If _nPos == 0
			// ---	Adiciona contador
			Aadd( _aRatKm, { _cRem, 1 }  )
		Else
			// ---	Incrementa ocorrencias
			_aRatKm[_nPos,2]++
		EndIf
		
		// ---	Calcula a distancia a partir do final
		If _nX	== _nItens
			
			// ---	Localiza a distancia do cadastro
			PA4->(dbSetOrder(1))
			If PA4->(dbSeek(xFilial('PA4')+_cRem+_cDest+_clTpVei))
				
				// --- 	Adiciona distancia primeiro ponto
				Aadd( _aRet,  { _nX, _cRem, PA4->PA4_DIST, 0, 0, 0, _cDest, _clTpVei } )
			Else
				//	---	Aadd( _aRet,  { _nX, _cRem,0,0,0,1} ) //	---	Bloquea o plano
				// 	---	Liberado temporariamente - conforme solicitado pelo Marchine em 17/09/2014
				//	---	Aadd( _aRet,  { _nX, _cRem,0,0,0,0 } )
				
				//	---	[@2LGI - 26/11/2014] - Retorna controle de km somente para operacao FTL - conforme solicitado pela Cristiane em 12/11/2014
				Aadd( _aRet,  { _nX, _cRem,0,0,0, Iif (_cOper == '3' .and. _llBlqKm  , 1, 0), _cDest, _clTpVei } )
			EndIf
			
			// ---	Adianta a distancia ponto a ponto da proxima linha
		Else
			
			// ---	Obtem Remetente e destinatario
			_cRem	:=	Iif ( _nTipo == 1, _aDados[1][2]:_CNPJFORNECEDOR:TEXT, _aDados[1][2][_nX]:_CNPJFORNECEDOR:TEXT)
			_cDest	:=	Iif ( _nTipo == 1, _aDados[1][2]:_CNPJFORNECEDOR:TEXT, _aDados[1][2][_nX+1]:_CNPJFORNECEDOR:TEXT)
			
			// ---	Verifica se é o mesmo fornecedor para destinos diferentes
			If _cRem == _cDest
				_cDest	:=	Iif ( _nTipo == 1, _aDados[1][2]:_EMP_STR_CNPJ:TEXT, _aDados[1][2][_nX]:_EMP_STR_CNPJ:TEXT)
			EndIf
			
			// ---	Localiza a distancia do cadastro
			PA4->(dbSetOrder(1))
			If PA4->(dbSeek(xFilial('PA4')+_cRem+_cDest+_clTpVei))
				// --- Adiciona distancia primeiro ponto
				Aadd( _aRet,  { _nX, _cRem, PA4->PA4_DIST, 0, 0, 0, _cDest, _clTpVei } )
			Else
				// ---	Aadd( _aRet,  { _nX, _cRem,0,0,0,1} ) - Bloquea o plano
				// --- Liberado temporariamente - conforme solicitado pelo Marchine em 17/09/2014
				//	---	Aadd( _aRet,  { _nX, _cRem,0,0,0,0} )
				//	---	[@2LGI - 26/11/2014] - Retorna controle de km somente para operacao FTL - conforme solicitado pela Cristiane em 12/11/2014
				Aadd( _aRet,  { _nX, _cRem,0,0,0, Iif (_cOper == '3' .and. _llBlqKm , 1, 0), _cDest, _clTpVei } )
				
			EndIf
			
		EndIf
		
	EndIf
	
Next _nX

// ---	Verifica a variavel de rateio e participação do fornecedor
// ---	Analisa a margem de aceite do Km
// ---	Acumula as distancias cadastradas e compara com a margem
aEval( _aRet, { |x| _nTotKm += x[3] ,, } )

// ---	Se fora da margem
If ! ( _nKmPlan <= _nTotKm+_nKmFaixa ) .and. ( _nKmPlan >= _nTotKm-_nKmFaixa )
	
	// --- 	Diferenca de Km considerada a faixa bloqueia qq registro de retorno
	If Len(_aRet) > 0
		
		//	--- Bloquea o plano [1] ou libera [0]
		_aRet[1][6]	:=	Iif ( _llBlqKm, 1, 0 )
		
		// ---	Nao localizou o cadastro de distancia para conferencia, bloqueia o plano
	Else
		
		//	---	[@2LGI - 26/11/2014] - Retorna controle de km somente para operacao FTL - conforme solicitado pela Cristiane em 12/11/2014
		Aadd( _aRet, { 0,'',0,0,0, Iif( _cOper == '3' .and. _llBlqKm , 1, 0 ), _cDest, _clTpVei } )
	EndIf
	
EndIf

//	--- Calculo do rateio do frete e pedagio
// ---	Rateio geral valor do pedagio e Km Frete
_nRestKm	:=	Iif( Len(_aRatKm) > 1, _nKmPlan%Len(_aRatKm), 0)
_nRestPdg	:=	Iif( Len(_aRatKm) > 1, _nVlrPdg%Len(_aRatKm), 0)

// ---	Somente continua se nao houve erro na array de retorno
aEval( _aRet, { |x| _nAvalKm+= x[6] ,, } )

If (_nAvalKm == 0) .or. (_aRet[1,2] <> '')
	
	For _nX	:= 1 to Len(_aRet)
		
		// ---	Verifica se e ultimo elemento e acrescenta o resto da divisao
		If  _nX == Len(_aRet) .and. _nRestKm+_nRestPdg > 0 .and. Len(_aRet) == 1
			
			// ---	Km frete e Valor de pedagio
			_aRet[_nX,4]	+=	_nRestKm
			_aRet[_nX,5]	+=	_nRestPdg
			
		Else
			
			// ---	Verifica as ocorrencias do mesmo fornecedor para dividir os valores obtidos
			_nPos	:=	Ascan( _aRatKm, { |x| x[1] == _aRet[_nX,2] } )
			
			// ---	Armazena o rateio obtido
			_aRet[_nX,4]	:=	Round( ( _nKmPlan/Len(_aRatKm)/_aRatKm[_nPos,2] ), 2 )
			_aRet[_nX,5]	:=	Round( ( _nVlrPdg/Len(_aRatKm)/_aRatKm[_nPos,2] ), 2 )
			
		EndIf
		
	Next _nX
	
	// ---	Descarrega o resto da divisao caso exista
	
EndIf

Return _aRet


/*/{Protheus.doc} INTCNHGLOG
Função responsável por gravar o log de processamento da interface CNH.
@author	Luiz Alexandre Ferreira
@since 		31/08/2014
@version 	1.0
@param 		_aLog, ${param_type}, (Array com os dados a serem gravados)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function INTCNHGLOG(_aLog)

// ---	Ajuste de 1 segundo no processamento devido a chave
If Len(_aLog) > 0
	
	PA3->(dbSetOrder(1))
	If PA3->(dbSeek(xFilial('PA3')+Str(_aLog[1][1],TamSX3('DF0_PLANID')[1],0)+_aLog[1][2]+_aLog[1][3]+Dtos(_aLog[1][4])+_aLog[1][5]))
		
		// --- Incrementa 1 segundo
		_aLog[1][5]	:=	Substr(_aLog[1][5],1,6)+StrZero(Val(Substr(_aLog[1][5],7,2))+1,2)
		
	EndIf
	
	// ---	Adiciona registro de log
	RecLock('PA3',.t.)
	PA3->PA3_FILIAL		:=	xFilial('PA3')
	PA3->PA3_PLANID		:= 	_aLog[1][1]
	PA3->PA3_ITEM		:= 	_aLog[1][2]
	PA3->PA3_WSID		:= 	_aLog[1][3]
	PA3->PA3_DATPRO		:= 	_aLog[1][4]
	PA3->PA3_HORPRO		:= 	_aLog[1][5]
	PA3->PA3_MSGOCO		:= 	_aLog[1][6]
	PA3->PA3_MSGSOL		:= 	_aLog[1][7]
	PA3->PA3_USUARI		:= 	_aLog[1][8]
	PA3->PA3_TIPMSG		:= 	_aLog[1][9]
	PA3->(MsUnLock())
	
	// ---	Limpa a variavel de log
	_aLog	:= {}
	
EndIf

Return



Static Function INTCNHVIEW(_aPlanosView)
	//-------------------------------------------------------------------------------------------------
	/* {2LGI} INTCNHVIEW
	@autor		: Luiz Alexandre
	@descricao	: Atualiza os parametros da rotina
	@since		: Jul./2014
	@using		: Interface CNH - Metodo interface055
	@review		:
	*/
	//-------------------------------------------------------------------------------------------------
	// --- Variaveis utilizadas
	Local aCoords    	:= 	FWGetDialogSize(oMainWnd)
	Local nWidthTree 	:= 	Round(aCoords[4]/4,0)
	Local bOk 			:= 	{|| alert('ok') }
	Local bCancel 		:= 	{|| alert('cancel') }
	Local oConfig	 	:= 	FWControlPanel():New(aCoords[1],aCoords[2],aCoords[3],aCoords[4],,OemToAnsi('Planos de transporte'),nWidthTree,bOk,bCancel)
	Local _nX			:= 	0
	
	//	---	Ordena a lista
	Asort(_aPlanosView,,, { |x,y| x[1] < y[1] })
	
	// Cria segunda sequencia de Itens
	oPanel02 		:= oConfig:AddTree( 'Data '+Dtoc(Mv_par01),'BMPCALEN' )
	oGroup2 		:= TGroup():New(0,0,100,0,'Objeto TGroup 02',oPanel02,,,.T.)
	oGroup2:Align	:= CONTROL_ALIGN_TOP
	
	// Cria SubItens
	For _nX	:= 1 to Len(_aPlanosView)
		
		oPanel03 	:= oConfig:AddTreeItem(  Iif  ( _aPlanosView[_nX,3] == '0', 'Plano : '+Transform(_aPlanosView[_nX,1],'@E 9,999,999')+' - # '+_aPlanosView[_nX,2], 'Plano : '+Transform(_aPlanosView[_nX,1],'@E 9,999,999')+' - # '+_aPlanosView[_nX,2]),;
			Iif  ( _aPlanosView[_nX,3] == '0', 'OK', 'CANCEL' ) ,;
			{|opanel| alert('Entrou AddTreeItem: '+Valtype(opanel) ) } )
		oGroup3 	:= TGroup():New(0,0,100,0,OemToAnsi('Ocorrências'),oPanel03,,,.T.)
		oGroup3:Align := CONTROL_ALIGN_TOP
		
	Next _nX
	
	// ---	Exibe o painel com resumo do processamento
	oConfig:EndTree()
	oConfig:Activate()
	
Return

/*/{Protheus.doc} INTCNHEML
Função responsável por enviar email para o usuário com os planos importados.
@author 	Luiz Alexandre Ferreira
@since 		13/11/2014
@version 	1.0
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function INTCNHEML(_aPlanosView)

//	---	Variaveis utilizadas
Local	_nPlanos	:=	0
Local	lRet		:= .f.
Local	_nTot		:=	Len(_aPlanosView)
Local	cBody		:=	'Relação de plano(s) de transporte(s) importados na execução'
Local 	lResulConn	:=	.t.
Local 	lResulSend	:=	.t.
Local 	cError 	:= 	''
Local 	cServer 	:= 	AllTrim(GetMV("MV_RELSERV"))
Local 	cEmail 	:= 	AllTrim(GetMV("MV_RELFROM"))
Local 	cPass 		:= 	AllTrim(GetMV("MV_RELPSW"))
Local 	lRelauth 	:= 	GetMv("MV_RELAUTH")
Local 	cDe 		:= 	cEmail
Local 	cPara 		:=	GetMv("ES_CNHEML",,"torredecontroleI@gefco.com.br")
Local 	cCc 		:=	''
Local 	cAssunto 	:=	'Importação de plano de transporte [Execução - '+Dtoc(dDataBase) +' : '+Time()+']'
Local 	cAnexo 	:=	''
Local 	_lJob		:= 	.t.


//	---	Preenche corpo do email
For _nPlanos	:= 1 to Len(_aPlanosView)
	
	//	---	Acrescenta lista dos planos
	cBody	+=	'' + CRLF
	cBody	+=	'' + CRLF
	cBody	+=	Iif  ( _aPlanosView[_nPlanos,3] == '0', 'Plano de transporte : '+Transform(_aPlanosView[_nPlanos,1],'@E 9,999,999')+' - # '+_aPlanosView[_nPlanos,2], 'Plano de transporte : '+Transform(_aPlanosView[_nPlanos,1],'@E 9,999,999') + ' - # '+_aPlanosView[_nPlanos,2] )
	
Next _nPlanos

cBody	+= '' + CRLF
cBody	+= 'Resumo da importação' + CRLF
cBody	+= Transform(_nTot,'@E 999,999' )+'  plano(s) de transporte(s) importado(s) em '+Dtoc(dDataBase)+ ' até '+Time()+' ' + CRLF
cBody	+= '' + CRLF
cBody	+= 'email enviado pelo TOTVS Protheus' + CRLF

//	---	Utilizacao de função interna GEFCO.
U_EnvEmail(cEmail,cPara,cCc,cAssunto,cBody,cAnexo)

/*
CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn
If !lResulConn
	GET MAIL ERROR cError
	If _lJob
		ConOut(Padc("Falha na conexao "+cError,80))
	Else
		MsgAlert("Falha na conexao "+cError)
	Endif
Return(.F.)
Endif

// Sintaxe: SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
// Todos os e-mail terão: De, Para, Assunto e Mensagem, porém precisa analisar se tem: Com Cópia e/ou Anexo
If lRelauth
	lResult := MailAuth(Alltrim(cEmail), Alltrim(cPass))
	//Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
	If !lResult
		nA := At("@",cEmail)
		cUser := If(nA>0,Subs(cEmail,1,nA-1),cEmail)
		lResult := MailAuth(Alltrim(cUser), Alltrim(cPass))
	Endif
Endif

If lResult
	If Empty(cCc) .And. Empty(cAnexo)
		SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cBody RESULT lResulSend
	Else
		If Empty(cCc) .And. !Empty(cAnexo)
			SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cBody ATTACHMENT cAnexo RESULT lResulSend
		ElseIf !Empty(cCc) .And. !Empty(cAnexo)
			SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cBody ATTACHMENT cAnexo RESULT lResulSend
		ElseIf Empty(cCc) .And. Empty(cAnexo)
			SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cBody RESULT lResulSend
		Endif
	Endif
	
	If !lResulSend
		GET MAIL ERROR cError
		If _lJob
			ConOut(Padc("Falha no Envio do e-mail "+cError,80))
		Else
			MsgAlert("Falha no Envio do e-mail " + cError)
		Endif
	Endif
Else
	If _lJob
		ConOut(Padc("Falha na autenticação do e-mail: "+cError,80))
	Else
		MsgAlert("Falha na autenticação do e-mail:" + cError)
	Endif
Endif
DISCONNECT SMTP SERVER

If lResulSend
	Conout('Email enviado referente a importação de plano de transporte em '+Dtoc(dDatabase)+' : '+Time())
Else
	Conout('Problema no envio de email referente a importação de plano de transporte em '+Dtoc(dDatabase)+' : '+Time() )
EndIf

*/

Return



Static Function INT055SX1()
	//-------------------------------------------------------------------------------------------------
	/* {2LGI} INT055SX1
	@autor		: Luiz Alexandre
	@descricao	: Atualiza os parametros da rotina
	@since		: Jul./2014
	@using		: Interface CNH - Metodo interface055
	@review	:
	*/
	//-------------------------------------------------------------------------------------------------
	// --- Variaveis utilizadas
	Local aHelpPor 	:= {}
	Local aHelpEng 	:= {}
	Local aHelpEsp 	:= {}
	Local _cPerg	:= 'WCNHINT055'
	
	// --- Cadastro da pergunta com descricao de help
	aHelpPor := { "Informe a data de referencia para ",;
		"importar planos de transporte." }
	aHelpEng := {"Introduzca la fecha." }
	aHelpEsp := {"Enter the date." }
	PutSx1(_cPerg, "01", "Data Referencia ", "Fecha", "Date of", ;
		"MV_CH1", "D",8, 0, 0, "G", "", "", "", "", ;
		"MV_PAR01", "", "", "", "", "", "", "", "", ;
		"", "", "", "N", "", "", "", "", ;
		aHelpPor, aHelpEng, aHelpEsp )
	
	// --- Cadastro da pergunta com descricao de help
	aHelpPor := { "Informe se deseja importar todos ",;
		"ou um plano especifico." }
	aHelpEng := {"Informe se deseja importar todos ",;
		"ou um plano especifico." }
	aHelpEsp := {"Informe se deseja importar todos ",;
		"ou um plano especifico." }
	PutSx1(_cPerg, "02", "Importa plano", "Importa plano", "Importa plano", ;
		"MV_CH2", "N",1, 0, 1, "C", "", "", "", "", ;
		"MV_PAR02",;
		"Especifico", "Especifico", "Especifico",;
		"",/*Cnt1*/;
		"Todos"/*Def2*/,"Todos","Todos",;
		""/*Def3*/,"","",;
		""/*Def4*/,"","",;
		""/*Def5*/,"","",;
		aHelpPor, aHelpEng, aHelpEsp, "" )
	
Return(Pergunte(_cPerg,.t.))


Static Function CNHINT301A(_nPlanoId,_lAuto)
	//-------------------------------------------------------------------------------------------------
	/* {2LGI} CNHINT301A
	@autor		: Luiz Alexandre
	@descricao	: Funcao principal da rotina para processamento Web Service
	@since		: Ago./2014
	@using		: Interface CNH - Metodo interface301- Informar declinio
	@review		:
	*/
	//-------------------------------------------------------------------------------------------------
	// --- Variaveis utilizadas
	Local oDlg
	Local oSay, oSay1, oSay2, oSay3
	Local oFont, oFont1
	Local oSButton1, oSButton2
	Local _lRet			:= .t.
	
	oDlg:= MSDialog():New(0,0,150,550,OemToAnsi('Informar declinio : '+Transform(DF0->DF0_PLANID, '@E 9,999,999')),,,,,CLR_BLACK,CLR_WHITE,,,.t.)
	// ---
	oFont:= TFont():New('Tahoma',,-16,.T.)
	oFont1:= TFont():New('Tahoma',,-11,.T.)
	// --- Apresenta o tSay com a fonte Courier New
	oSay	:= TSay():New( 005, 010, {|| OemToAnsi('Declínio do Plano de transporte '+Transform(DF0->DF0_PLANID, '@E 9,999,999') ) },oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
	oSay:lTransparent:= .F.
	oSay1	:= TSay():New( 025, 010, {|| OemToAnsi('Motivo do declinio    :')},oDlg,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
	oSay1:lTransparent:= .F.
	oSay2	:= TSay():New( 045, 010, {|| OemToAnsi('Observação [Motivo 05]:')},oDlg,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
	oSay2:lTransparent:= .F.
	
	// ---
	@ 021,070 MSGET _cMotivo	SIZE 20, 9 OF oDlg PIXEL F3 'ZV' VALID ExistCpo('SX5','ZV'+_cMotivo)
	oSay3	:= TSay():New( 023, 095, {|| CNHINT301B('ZV'+_cMotivo,@_cMotivo) },oDlg,,oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
	oSay3:lTransparent:= .F.
	
	// ---
	@ 041,070 MSGET _cObs	 	SIZE 150, 9 WHEN (_cMotivo == '05') OF oDlg PIXEL
	
	// --- Botoes para gravacao dos dados de classificacao do titulo
	// ---
	oSButton1 := SButton():New( 60,10,1, {|| _lRet := .t., oDlg:End() },oDlg,.T.,'Confirma dados',)
	oSButton2 := SButton():New( 60,40,2, {|| _lRet := .f., oDlg:End() },oDlg,.T.,'Cancela',)
	
	// --- Ativa o objeto
	oDlg:Activate()
	
Return _lRet


/*/{Protheus.doc} CNHINT301B
Função responsável por retornar a descrição de variavel informada conforme cadastro de tabela generica.
@author 	2LGI - Luiz Alexandre Ferreira
@since 		11/08/2014
@version 	1.0
@param 		_cParam, ${param_type}, (Descrição do parâmetro)
@param 		_cMotivo, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function CNHINT301B(_cParam,_cMotivo)
// ---	Variaveis utilizadas
Local	_cString	:= ''

// ---	Localiza a descricao
If ! Empty(_cParam)
	SX5->(dbSetOrder(1))
	SX5->(dbSeek(xFilial('SX5')+_cParam))
	_cString	:= SX5->X5_DESCRI
	_cMotivo	:= Trim(SX5->X5_CHAVE)
EndIf

Return _cString


/*/{Protheus.doc} INT701A
Função responsável por remover acentos e caracteres especiais para comparar o status CNH com cadastro interno.
@author 	2LGI - Luiz Alexandre Ferreira
@since 		01/08/2014
@version 	1.0
@param 		cString, character, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
Utilizado na interface CNH - metodo interface701
@see (links_or_references)
/*/Static Function INT701A(cString)
// ---	Variaveis utilizadas
Local	cChar  	:= 	""
Local 	nX     	:= 	0
Local 	nY     	:= 	0
Local 	cVogal 	:= 	"aeiouAEIOU"
Local 	cAgudo 	:= 	"áéíóú"+"ÁÉÍÓÚ"
Local 	cCircu 	:= 	"âêîôû"+"ÂÊÎÔÛ"
Local 	cTrema 	:= 	"äëïöü"+"ÄËÏÖÜ"
Local 	cCrase 	:= 	"àèìòù"+"ÀÈÌÒÙ"
Local 	cTio   	:= 	"ãõÃÕ"
Local 	cCecid 	:= 	"çÇ"
Local 	cMaior 	:= 	"&lt;"
Local 	cMenor 	:= 	"&gt;"

// ---	Substitui os caracteres encontrados de acordo com a variavel
For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
		EndIf
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next

If cMaior$ cString
	cString := strTran( cString, cMaior, "" )
EndIf

If cMenor$ cString
	cString := strTran( cString, cMenor, "" )
EndIf

cString := StrTran( cString, CRLF, " " )

For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If (Asc(cChar) < 32 .Or. Asc(cChar) > 123) .and. !cChar $ '|'
		cString:=StrTran(cString,cChar,".")
	Endif
Next nX

Return cString
// --- Fim do fonte
