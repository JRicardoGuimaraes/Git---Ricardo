#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"
#include 'Tbiconn.ch'
#include 'Fileio.ch'

/*/{Protheus.doc} GEFCNHOTM
//Rotinas para integração com a CNH-OTM.
@author u297686 - Ricardo Guimarães
@since 24/11/2015
@version 1.0

@type function
/*/

#Define _cInterface204 'OTM - Interface 204' // Carga de planos
#Define _cInterface210 'OTM - Interface 210' // Envio de Interface de Faturamento
#Define _cInterface214 'OTM - Interface 214' // Monitoramento
#Define _cInterface990 'OTM - Interface 990' // Aceite - Rejeição
#Define _cInterface999 'OTM - Interface 999' // Registro de Ocorrencia

STATIC cPATH204 
STATIC cPATH210 
STATIC cPATH214 
STATIC cPATH990 
STATIC	_aLog			
STATIC _cError			
STATIC	_cWarning		

/*********************************************/
/* Processa interface CNH-OTM                */
/*********************************************/
User function GEFCNHOTM(_cInterface, _lAuto)
Local _cStatus 	:= ""
Local _nOpc 		:= 0
Local _cPlanoId	:= ""
Local _cRpcEmp	:= '01'
Local _cRpcFil	:= '01'
Local _cEnvMod	:= '43'
Local _cFunName	:= ""
Local _aTables  	:= {"DF0","DF1","DF2","DF3","DF4","DF5","SA1","DUA","DT5","DUE","DA3","PA7","SX6","SF2"}

_lAuto := xSchedule()  // Verifica se a rotina está sendo executado por schedule

If _lAuto
	CONOUT("_cInterface: " + VALTYPE(_cInterface))
	_cInterface := "204"
	RpcClearEnv()
	RpcSetType( 3 )
	RpcSetEnv( _cRpcEmp,_cRpcFil,/*cEnvUser*/,/*cEnvPass*/,_cEnvMod,_cFunName,_aTables,/*lShowFinal*/,/*lAbend*/,/*lOpenSX*/,/*lConnect*/ )
EndIf

DEFAULT _lAuto 		:= .F.
DEFAULT _cInterface := "204"

cPATH204 	:= GETNEWPAR("ES_PATH204","\Interfaces\EDICOM\IN\INT204\")
cPATH210 	:= GETNEWPAR("ES_PATH210","\Interfaces\EDICOM\OUT\INT210\")
cPATH214 	:= GETNEWPAR("ES_PATH214","\Interfaces\EDICOM\OUT\INT214\")
cPATH990 	:= GETNEWPAR("ES_PATH990","\Interfaces\EDICOM\OUT\INT990\")

_aLog		:= {}
_cError		:= ''
_cWarning	:= ''

_cFunName	:= FunName()

If !_lAuto
	_cPlanoId	:= DF0->DF0_PLANID  // --- 	Envia o plano de transporte posicionado no browse
EndIf

// Carga dos Planos
If _cInterface == "204"
	If _lAuto
		CONOUT("Interface 204 - Inicio de processamento: " + DtoC(dDATABASE) + " - " + Time())
		U_CNHOTM204(_lAuto)		
		CONOUT("Interface 204 - Final  de processamento: " + DtoC(dDATABASE) + " - " + Time())		

		If _lAuto
			RpcClearEnv()
		EndIf
	Else
		Processa( {|| U_CNHOTM204(_lAuto) }, "Processando...", "Plano de transporte interface 204...",.F.)
	EndIf

// Aceito do Plano
ElseIf _cInterface == "990"
	/*
	If DF0->DF0_STPLAN	<> "0"  // 0-Importado com sucesso
		Aviso("Interface 990","Pedido de Plano de transporte imporando com pendência",{"Ok"})
		Return
	EndIf
	*/

	_nOpc := Aviso("Interface 990","Pedido de Plano de transporte",{"Aceitar","Rejeitar","Retornar"})
	If _nOpc == 3
		Return .F.
	EndIf

	_cStatus := IIF(_nOpc==1, "A","D")

	If _lAuto
		CONOUT("Interface 990 - Inicio de processamento: " + DtoC(dDATABASE) + " - " + Time())
		U_CNHOTM990(_lAuto, _cPlanoId, _cStatus)		
		CONOUT("Interface 990 - Final  de processamento: " + DtoC(dDATABASE) + " - " + Time())		

		If _lAuto
			RpcClearEnv()
		EndIf
	Else
		Processa( {|| U_CNHOTM990(_lAuto, _cPlanoId, _cStatus) }, "Processando...", "Plano de transporte interface 990...",.F.)
	EndIf
	
// Interface de Faturamento
ElseIf _cInterface == "210"
	If _lAuto
		CONOUT("Interface 210 - Inicio de processamento: " + DtoC(dDATABASE) + " - " + Time())
		U_210CNHOTM(_lAuto, _cPlanoId)		
		CONOUT("Interface 210 - Final  de processamento: " + DtoC(dDATABASE) + " - " + Time())		

		If _lAuto
			RpcClearEnv()
		EndIf
	Else
		Processa( {|| U_210CNHOTM(_lAuto, _cPlanoId) }, "Processando...", "Interface de Faturamento (210) ...",.F.)
	EndIf
// Carga dos Planos
ElseIf _cInterface == "214"
	Processa( {|| U_CNHOTM214(_lAuto, _cPlanoId) }, "Processando...", "Interface de Monitoramneto (214) ...",.F.)

ElseIf _cInterface == '999'

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
	ElseIf Empty(DF0->DF0_CODVEI)
		MsgInfo('Não há veículo informado no Plano de transporte '+AllTrim(Str(_cPlanoId))+' - 214')
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
EndIf

return .F.

/************************************************************/
/* Processa o array com os arquivos de interfaces da CNH 204*/
/************************************************************/
USER function CNHOTM204(_lAuto)
Local _aArqs	:= {}
Local _lReturn 	:= .F.
Local _nX 		:= 0
Local _cArqXML  := ""
Local _oXML     := Nil
Local _cArqORIG	:= ""
Local _cArqDEST := ""
Local _cPathDEST:= ""

// Carregas os XML´s da pasta, recebido da CNH
_aArqs := fCarregaArqs("204")

If Len(_aArqs) < 1
	If _lAuto 
		CONOUT("Interface 204 - Não há arquvios a serem processados")
	Else	
		MsgStop("Não há arquvios a serem processados","Aviso")
	EndIf	
	Return _lReturn
EndIf

ProcRegua(Len(_aArqs))

_cPathDEST := cPATH204 + "BACKUP"
MONTADIR(_cPathDEST)
_cPathDEST := _cPathDEST+"\"

For _nX:=1 to Len(_aArqs)
	IncProc(0)

	_cArqXML    := _aArqs[_nX,1]
	_oXML 		:= fGetObjXML(cPATH204 + _cArqXML)

	// XML com error, não processa e move para a pasta backup
	_cArqORIG := cPATH204 + _aArqs[_nX,1]
	_cArqDEST := _cPathDest + _aArqs[_nX,1]

	If _oXML == Nil
		__CopyFile(_cArqORIG,_cArqDEST+"_ERROR")

		If _lAuto
			CONOUT("Interface 204: Arquivo não processado devido a erros => " + _cArqORIG )
		EndIf

		// Apaga o arquivo
		fErase(_cArqORIG)
		Loop
	EndIf

	/* Grava registro baseado no _oXML */
	// Transforma node em uma array, no caso tranforma a estrutura para array
	// _aDados		:= ClassDataArr(_oScript:_SOAP_ENVELOPE:_SOAP_BODY:_INTERFACE060RESPONSE:_INTERFACE060RESULT:_DIFFGR_DIFFGRAM:_SOLICITACAO)
	fGravaPlano(_oXML,_lAuto)

	/* Move arquivo para a pasta backup */
	__CopyFile(_cArqORIG,_cArqDEST)
	If _lAuto
		CONOUT("Interface 204: Arquivo processado => " + _cArqORIG )
	EndIf	
	
	// Apaga o arquivo
	fErase(_cArqORIG)

Next _nX

If _lAuto .AND. _nX > 0
	CONOUT("Interface 204: Total de Arquivo(s) processado(s) => " + cValToChar((_nX-1)) )
EndIf	

Return _lReturn

/********************************************************/
/* Carrega em um array os arquivos de interfaces da CNH */
/********************************************************/
Static Function fCarregaArqs(_cInterface)
Local _aArqs

If _cInterface == "204"
	// Cria Direotrio
	MontaDir(cPATH204)

	_aArqs := Directory(cPATH204 + "CNH_204"+"*.XML",,NIl,.T.,2)
EndIf

Return _aArqs

/*******************************/
/* Retorna um Objeto com o XML */
/*******************************/
Static Function fGetObjXML(_cArq)
Local _oXml		:= NIl

//a partir do rootpath do ambiente
//_cArq := cPATH204 + _cArq

//Gera o Objeto XML
_oXml := XmlParserFile( _cArq, "_", @_cError, @_cWarning )

If !Empty(_cError)
	If _lAuto
		CONOUT("Interface 204 - Error no XML: " + _cArq + CRLF + @_cError)
	Else	
		MsgStop("Error no XML: " + _cArq + CRLF + @_cError)
	EndIf	
EndIf

If !Empty(_cWarning)
	If _lAuto
		CONOUT("Interface 204 - Error no XML: " + _cArq + CRLF + @_cWarning)
	Else	
		MsgStop("Error no XML: " + _cArq + CRLF + @_cWarning)
	EndIf	
EndIf

Return _oXml

/*******************************/
/* Grava registro do Plano     */
/*******************************/
//Função responsável por realizar a gravação do agendamento / plano de transporte conforme
//dados recebidos na interface e tratamentos de regra de negócio GEFCO.
 Static Function fGravaPlano(_oXML, _lAuto)
 Local _lReturn := .F.

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

Local _aDados 		:= {}
Local _cNumPed		:= ""
Local _cNumModel		:= ""
Local _aCliLoja 		:= {}
Local _aCliLjOri 		:= {}
Local _aCliLjDes 		:= {}
Local _aServ_OP		:= Array(2)
Local _cDesOpe		:= ""
Local _cTipoVe  		:= ""
Local _cDesVe   		:= ""
Local _aNotas   		:= {}
Local _aAltPlano		:= {}
Local _cAssunto 		:= ""
Local _cMsg			:= ""
Local _aColeta  		:= {}
Local _cParada  		:= ''
Local _cSeqRazon		:= ""
Local _mMSMOBS		:= CriaVar('DF0_OBS')
Local _aDF1			:= {}
Local _lRejPlano		:= .F.
Local _lCliDesNInf	:= GetNewPar("ES_DSTNINF",.T.)
Local _lCliOrgNInf	:= GetNewPar("ES_ORGNINF",.T.)
Local _lKmNInf		:= GetNewPar("ES_KMNINF" ,.T.)
Local _lPdgZero		:= GetNewPar("ES_PDGZERO",.T.)
Local _lPdgNInf		:= GetNewPar("ES_PDGNINF",.T.)
Local _lFrtNInf		:= GetNewPar("ES_FRTNINF",.T.)
Local _nKM				:= 0.00
Local _nQtdItem		:= 1
Local _lPlanoSemErro := .T.

Private _nItemLog	:= 1

Afill(_aServ_OP, "") 

// Transforma node em uma array, no caso tranforma a estrutura para array
_aDados		:= ClassDataArr(_oXML:_CAB_204)

_aLog		:= 	{}
_nPlanoId	:= 	Val(_oXML:_CAB_204:_ID_EMB:TEXT) // Iif ( _nTipo == 1, Val(_aDados[1][2]:_PLA_INT_ID:TEXT), Val(_aDados[1][2][1]:_PLA_INT_ID:TEXT) )
_aColeta 	:= fMontaDF1(_oXML)

//ALERT(cValtoChar(nTot))


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
		//_nTotDis	:= 	Iif ( _nTipo == 1, Val(_aDados[1][2]:_ROT_INT_KM:TEXT), Val(_aDados[1][2][1]:_ROT_INT_KM:TEXT) )
		//_aRetDF0	:= 	INTCNHVAGE('_DF0',_aDados,1,,,)

		Begin Transaction
			// --- Inclui registro
			ConfirmSX8()
			RecLock('DF0',.t.)
			DF0->DF0_FILIAL	:= 	xFilial('DF0') 				// --- Filial
			DF0->DF0_NUMAGE	:= 	_cNumAge						// --- Numero do agendamento
			DF0->DF0_PLANID	:=	_nPlanoId						// --- Numero do plano de transporte
			DF0->DF0_SEQEND	:= 	''
			DF0->DF0_QTDITE	:= 	_nItens
			DF0->DF0_QTDCON	:= 	0

			// OTM

			_cTipoVe  := AllTrim(_oXML:_CAB_204:_COD_EQUIP :TEXT)
			_cDesVe   := GetAdvFVal('SX5','X5_DESCRI',xFilial('SX5')+'ZB'+_cTipoVe,1,'TIPO DE VEICULO NÃO LOCALIZADO')  // Caso não localize, retorno o codigo "00"

			DF0->DF0_CNHID	:= "30"  // // Planejado
			DF0->DF0_DATCAD	:= dDatabase
			DF0->DF0_HORPLA	:= SubStr(StrTran(Time(),":",""),1,4)
			DF0->DF0_DATCAN	:= 	Ctod('')
			DF0->DF0_CODOBC	:= 	''
			DF0->DF0_STATUS	:= 	'1'
			DF0->DF0_TIPDIS	:= 	'1'
			DF0->DF0_INIDIS	:= 	'2'
			// DF0->DF0_KMPLAN	:=	_nTotDis
			DF0->DF0_DISTIV	:= 	'2'
			DF0_TRANSP		:= _oXML:_CAB_204:_COD_CAR:TEXT
			DF0_METPGT		:= _oXML:_CAB_204:_METOD_PAGO:TEXT
			DF0_TPTRA		:= _oXML:_CAB_204:_TIPO_TRANS:TEXT
			DF0_REFSOL		:= _oXML:_CAB_204:_REF_SOLIC:TEXT
			DF0_CODARE		:= _oXML:_CAB_204:_COD_AREA:TEXT
			DF0_TIPOVE		:= _cTipoVe
			DF0_DESVEI		:= _cDesVe
			DF0_PESOBT		:= Val(_oXML:_CAB_204:_PESO:TEXT)
			DF0_UNDPES		:= _oXML:_CAB_204:_UM_PESO:TEXT
			DF0_VOLUME		:= Val(_oXML:_CAB_204:_VOLUME:TEXT)
			DF0_UNDVOL		:= _oXML:_CAB_204:_UM_VOLUME:TEXT
			DF0_QTDEMB		:= Val(_oXML:_CAB_204:_QTY_EMB:TEXT)

			_aNotas := fBuscaNotas(_oXML:_CAB_204)
			DF0->DF0_VALFRE		:= _aNotas[01]
			DF0->DF0_PEDAG		:= _aNotas[02]
			DF0->DF0_ESCOLT		:= _aNotas[03]
			DF0->DF0_CURREN		:= _aNotas[04]
			// DF0->DF0_OBS1		:= _aNotas[05]
			DF0->DF0_OBS2		:= _aNotas[05]
			DF0->DF0_OBS3		:= _aNotas[06]
			DF0->DF0_OBS4		:= _aNotas[07]
			DF0->DF0_OBS5		:= _aNotas[08]
			DF0->DF0_OBS6		:= _aNotas[09]

			If Empty(_aNotas[01])  // Valor do Frete  
				aAdd( _aLog, { _nPlanoId, StrZero(_nItemLog,3), _cInterface204, dDataBase, Time() ,"Valor do Frete nao informado.","Importado com pendecia", UsrRetName(RetCodUsr()),'0' } )
				_nItemLog++
				// --- Grava log e define status de gravacao do plano
				INTCNHGLOG(_aLog)
				
				// Por: Ricardo Guimarães - Em: 19/07/2016 - Verifico se o plano deve ser rejeitada automaticamente
				If _lFrtNInf
					_lRejPlano := .T.
				EndIf
				_lPlanoSemErro := .F.			
			EndIf

			If AllTrim(_aNotas[02]) == "0.0"  // Pedagio  
				aAdd( _aLog, { _nPlanoId, StrZero(_nItemLog,3), _cInterface204, dDataBase, Time() ,"Pedagio informado com valor ZERO.","Importado com pendencia", UsrRetName(RetCodUsr()),'0' } )
				_nItemLog++
				// --- Grava log e define status de gravacao do plano
				INTCNHGLOG(_aLog)
				
				// Por: Ricardo Guimarães - Em: 19/07/2016 - Verifico se o plano deve ser rejeitada automaticamente
				If _lPdgZero
					_lRejPlano := .T.
				EndIf					
				_lPlanoSemErro := .F.		
			EndIf

			If Empty(_aNotas[02]) .AND. AllTrim(_aNotas[02]) <> "0.0" // Pedagio  
				aAdd( _aLog, { _nPlanoId, StrZero(_nItemLog,3), _cInterface204, dDataBase, Time() ,"Pedagio nao informado.","Importado com pendencia", UsrRetName(RetCodUsr()),'0' } )
				_nItemLog++
				// --- Grava log e define status de gravacao do plano
				INTCNHGLOG(_aLog)
				
				// Por: Ricardo Guimarães - Em: 19/07/2016 - Verifico se o plano deve ser rejeitada automaticamente
				If _lPdgNInf
					_lRejPlano := .T.
				EndIf					
				_lPlanoSemErro := .F.						
			EndIf

			// Gravo a kilometragem
			_nKM					:= _aColeta[1][2][11]
			DF0->DF0_KMPLAN		:= _nKM

			If Empty(_aColeta[1][2][11])  // KM
				aAdd( _aLog, { _nPlanoId, StrZero(_nItemLog,3), _cInterface204, dDataBase, Time() ,"Km nao informado.","Importado com pendencia", UsrRetName(RetCodUsr()),'0' } )
				_nItemLog++
				// --- Grava log e define status de gravacao do plano
				INTCNHGLOG(_aLog)

				// Por: Ricardo Guimarães - Em: 19/07/2016 - Verifico se o plano deve ser rejeitada automaticamente
				If _lKmNInf
					_lRejPlano := .T.
				EndIf					
				_lPlanoSemErro := .F.									
			EndIf

			DF0->(MsUnLock())

			// --- Libera o codigo reservado da pilha
			FreeUsedCode()

			// ---	Consistência do Km informado
			//_aRetKm	:= INTCNHKM(_aDados)

			// OTM
			_cNumPed	:= ""
			_cNumModel	:= ""
			_cCliOri	:= ""
			_cCliDest	:= ""

			_nQtdItem	:= fContaItem(_aColeta)

			_nItens		:= 	0

			For _nX	:= 1 to Len(_aColeta)  // _nItens // STEP 2 No XML( TAG COLETA ) vem sem sempre dois reistros(ORIGEM e DESTINO) e gerará um registro no DF1
				// --- Inclui registro de itens do agendamento
				If _cCliOri <> AllTrim(_aColeta[_nX][2][1]) .OR. _cCliDest <> AllTrim(_aColeta[_nX][3][1])

					_cCliOri := AllTrim(_aColeta[_nX][2][1])
					_cCliDest:= AllTrim(_aColeta[_nX][3][1])
					_nItens++

					RecLock('DF1',.t.)

					DF1->DF1_FILIAL		:=	xFilial('DF1')
					DF1->DF1_NUMAGE		:=	_cNumAge
					DF1->DF1_ITEAGE		:=  StrZero(_nItens,TamSX3('DF1_ITEAGE')[1]) // StrZero(Val(_aColeta[_nX][2][2]),TamSX3('DF1_ITEAGE')[1]) // :_SEQ_PARADA:TEXT StrZero(_nX,TamSX3('DF1_ITEAGE')[1])
					DF1->DF1_STACOL		:= 	'1'
					DF1->DF1_STAENT		:= 	'1'
					DF1->DF1_LOCCOL		:= 	'2'
					DF1->DF1_FILORI		:= 	''	// --- GetAdvFVal('DUY','DUY_FILDES',xFilial('DUY')+_aRetDF1[3],1,'')

					// CAMPO VIRTUAL => DF1_REFSOL			:= _oXML:_CAB_204:_REF_SOLIC:TEXT

					// Dados de Origem
					//  _aCliLoja := fBuscaCliente(_nPlanoID, AllTrim(_aColeta[IIF(_nColetaNx1 > 1,_nX,_nPosOrig)]:_ID_ORIGEM:TEXT),"ORIGEM")
					 _aCliLjOri := fBuscaCliente(_nPlanoID, AllTrim(_aColeta[_nX][2][1]),"ORIGEM") // :_ID_ORIGEM:TEXT

					// Por: Ricardo Guimarães - Em: 19/07/2016 - Verifico se o plano deve ser rejeitada automaticamente
					If Empty(_aCliLjOri[01]) .and. _lCliOrgNInf
						_lRejPlano 		:= .T.
						_lPlanoSemErro 	:= .F.
					EndIf														

					DF1->DF1_MOTPAR		:=     _aColeta[_nX][2][3] // :_SEQ_RAZON:TEXT
					DF1->DF1_PESOBT		:= Val(_aColeta[_nX][2][4]) // :_PESO:TEXT)
					DF1->DF1_UNDPES		:=     _aColeta[_nX][2][5] // :_UM_PESO:TEXT
					DF1->DF1_UNDSHP		:= Val(_aColeta[_nX][2][6]) // :_QTY_ENVIO:TEXT)
					DF1->DF1_UNDENV		:=     _aColeta[_nX][2][7] // :_UM_QTY_ENVIO:TEXT
					DF1->DF1_VOLUME		:= Val(_aColeta[_nX][2][8]) // :_VOLUME:TEXT)
					DF1->DF1_UNDVOL		:=     _aColeta[_nX][2][9] // :_UM_VOLUME:TEXT
					DF1->DF1_DTRETD		:= STOD(StrTran(SubStr(_aColeta[_nX][2][10],1,10),"-","")) // :_FECHA_RETIRADA:TEXT
					DF1->DF1_HRRETD		:= StrTran(SubStr(_aColeta[_nX][2][10],12,08),":","") // :_FECHA_RETIRADA:TEXT
					DF1->DF1_DATPRC		:= STOD(StrTran(SubStr(_aColeta[_nX][2][10],1,10),"-","")) // :_FECHA_RETIRADA:TEXT
					DF1->DF1_HORPRC		:= StrTran(SubStr(_aColeta[_nX][2][10],12,08),":","") // :_FECHA_RETIRADA:TEXT
					DF1->DF1_IDORIG		:= 	AllTrim(_aColeta[_nX][2][1])  // Origem ( Em: 21/06/2016 )										
					DF1->DF1_CLIREM		:= _aCliLjOri[01]
					DF1->DF1_LOJREM		:= _aCliLjOri[02]
					DF1->DF1_CDRORI		:= _aCliLjOri[03]
					If Empty(DF1->DF1_CLIDEV) .OR. DF1->DF1_CLIDEV = "000000"
						DF1->DF1_CLIDEV		:= _aCliLjOri[04]
						DF1->DF1_LOJDEV		:= _aCliLjOri[05]
						
						RecLock('DF0',.f.)
							DF0->DF0_DDD	:= 	_aCliLjOri[06]					// --- DDD
							DF0->DF0_TEL	:= 	_aCliLjOri[07]                   // --- Telefone
						DF0->(MsUnLock())
						
					EndIf

					// Dados de Destino
					 _aCliLjDes := fBuscaCliente(_nPlanoID,AllTrim(_aColeta[_nX][3][1]),"DESTINO") // :_ID_DESTINO:TEXT

					// Por: Ricardo Guimarães - Em: 19/07/2016 - Verifico se o plano deve ser rejeitada automaticamente
					If Empty(_aCliLjDes[01]) .and. _lCliDesNInf
						_lRejPlano := .T.
					EndIf														

					DF1->DF1_DTENTR		:= STOD(StrTran(SubStr(_aColeta[_nX][3][10],1,10),"-","")) // :_FECHA_ENTREGA
					DF1->DF1_HRENTR		:= StrTran(SubStr(_aColeta[_nX][3][10],12,08),":","") // :_FECHA_ENTREGA:TEXT
					DF1->DF1_DATPRE		:= STOD(StrTran(SubStr(_aColeta[_nX][3][10],1,10),"-","")) // :_FECHA_ENTREGA
					DF1->DF1_HORPRE		:= StrTran(SubStr(_aColeta[_nX][3][10],12,08),":","") // :_FECHA_ENTREGA:TEXT
					DF1->DF1_IDDEST		:= 	AllTrim(_aColeta[_nX][3][1])  // Destino ( Em: 21/06/2016 )
					DF1->DF1_CLIDES		:= _aCliLjDes[01]
					DF1->DF1_LOJDES		:= _aCliLjDes[02]
					DF1->DF1_CDRDES		:= _aCliLjDes[03]
					If Empty(DF1->DF1_CLIDEV) .OR. DF1->DF1_CLIDEV = "000000"
						DF1->DF1_CLIDEV		:= _aCliLjDes[04]
						DF1->DF1_LOJDEV		:= _aCliLjDes[05]
						
						RecLock('DF0',.f.)
							DF0->DF0_DDD	:= 	_aCliLjDes[06]					// --- DDD
							DF0->DF0_TEL	:= 	_aCliLjDes[07]                 // --- Telefone
						DF0->(MsUnLock())						
					EndIf

					DF1->DF1_NUMPUR			:= _aColeta[_nX][1] // :_NUM_PED:TEXT

					DF1->DF1_SQEREM		:= 	''
					DF1->DF1_TIPTRA		:= 	'1'
					DF1->DF1_SELORI		:= 	'3'

					DF1->DF1_SQEDES		:= 	''
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
					// DF1->DF1_DISTAN		:= 	_aRetKm[_nX,3]
					DF1->DF1_KMFRET		:= ( _nKM / _nQtdItem )
					DF1->DF1_DATCON		:=  Ctod('')
					DF1->DF1_SEQUEN		:=  StrZero(_nX,TamSX3('DF1_SEQUEN')[1])
					DF1->DF1_DISTIV		:=	'3'
					DF1->DF1_DATCAN		:=  Ctod('')
					DF1->DF1_CODOBC		:=	''

					// Por: Ricardo Guimarães - Em: 21/06/2016
					DF1->DF1_SEQENT 		:= StrZero(Val(_aColeta[_nX][3][2]),TamSX3('DF1_SEQENT')[1])

					// Por: Ricardo Guimarães - Em: 23/06/2016  -  Tratamento do Tipo de Serviço e Tipo de Operação
					_aServ_OP 			:= fBuscaSrvOp(_aColeta[_nX],_aCliLjOri, _aCliLjDes)
					_cDesOpe 			:= _aServ_OP[02]
					DF1->DF1_SERVIC 	:= _aServ_OP[01]

					DF1->(MsUnLock())

					// --- Grava log do item analisado
					// INTCNHGLOG(_aLog)

					// --- Log gravado na analise dos itens

					// --- Produto do item do agendamento
					// --- Nao precisa grava Log do produto
					_cProd		:= 	GetMV('ES_CNHPROD')
					_aProd 	:= 	Iif(!Empty(_cProd),&_cProd,{})

					RecLock('DF2',.t.)
					DF2->DF2_FILIAL		:=	xFilial('DF2')
					DF2->DF2_NUMAGE		:=	_cNumAge
					DF2->DF2_ITEAGE		:=	StrZero(_nX,TamSX3('DF2_ITEAGE')[1])
					DF2->DF2_CODPRO		:= Iif ( Len( _aProd) > 0, _aProd[1],'' )
					DF2->DF2_CODEMB		:= Iif ( Len( _aProd) > 0, _aProd[2],'' )

					// OTM
					// DF2->DF2_NUMSER		:= _aDados[4][2][_nX]:_DETALHES:_NUM_SERIAL:TEXT
					DF2->DF2_MODEMB		:= _aColeta[_nX][4]   // _cNumModel
					//DF2->DF2_CODPIN		:= _aDados[4][2][_nX]:_DETALHES:_NUM_PIN:TEXT

					DF2->(MsUnLock())

					// aAdd( _aLog, { _nPlanoId, PA3->PA3_ITEM, _cInterface204, dDataBase, Time() ,"Interface 204","Importado com restrição", UsrRetName(RetCodUsr()),'0' } )
					INTCNHGLOG(_aLog)  // _aLog foi alimentado na função fBuscacliente()
				Else
					_cNumPed += IIF(!Empty(_cNumPed),"/","") +  _aColeta[_nX][1]
				EndIf
			Next _nX

			RecLock('DF0',.f.)
				If !Empty(_cNumPed)
					_mMSMOBS			:=	_cNumPed
					DF0->DF0_CODOBS	:=	MSMM(,,,_mMSMOBS,1,,,'DF0','DF0_CODOBS')
					// DF0->DF0_OBS	:= _cNumPed
				EndIf

				// Por: Ricardo Guimarães - Em: 23/06/2016					
				DF0->DF0_DESOPE 	:= _cDesOpe

//				DF0->DF0_DDD	:= 	_aCliLoja[06]					// --- DDD
//				DF0->DF0_TEL	:= 	_aCliLoja[07]                   // --- Telefone
				DF0->DF0_QTDITE	:= _nItens

				// ---	Verifica se houve problema na validacao de KM
				If !_lPlanoSemErro 	// Empty(DF1->DF1_CLIREM) .OR. Empty(DF1->DF1_CLIDEV) //.OR. Empty(DF0->DF0_VALFRE) .OR. Empty(DF0->DF0_PEDAG) .OR. Empty(DF0->DF0_KMPLAN)
					DF0->DF0_STPLAN		:=	"1"

					// --- Grava log e define status de gravacao do plano
					aAdd( _aLog, { _nPlanoId, StrZero(_nItemLog,3), _cInterface204, dDataBase, Time() ,"Interface 204","Importado com restrição", UsrRetName(RetCodUsr()),'0' } )
				Else
					DF0->DF0_STPLAN		:=	"0"  // Importado com sucesso
	
					// --- Grava log e define status de gravacao do plano
					aAdd( _aLog, { _nPlanoId, StrZero(_nItemLog,3), _cInterface204, dDataBase, Time() ,"Interface 204","Importado com sucesso", UsrRetName(RetCodUsr()),'1' } ) // 0-Erro - 1-Normal
				EndIf
				
				INTCNHGLOG(_aLog)
				
			DF0->(MsUnLock())

			// Por: Ricardo Guimarães - Em: 19/07/2016 - Verifico se o plano deve ser rejeitada automaticamente
			If 	_lRejPlano
				U_CNHOTM990(_lAuto, _nPlanoId, "D", "R")
				_lRejPlano := .F.
			EndIf

		End Transaction

	EndIf
	// --- Alteracao de planos ja recebidos
Else
	// Trata Concelamento
	If AllTrim(_oXML:_CAB_204:_TIPO_TRANS:TEXT) = "01" .AND. DF0->DF0_STATUS < '4'
		DF0->(RECLOCK("DF0",.F.))
	 		DF0->DF0_STATUS := "9"
		DF0->(MsUnLock())

		// Envia e-mail
		_cAssunto 	:= "Cancelamento de Plano " + _cInterface204
		_cMsg 		:= "Plano " + Str(_nPlanoId) + " foi CANCELADO em " + DtoC(dDATABASE) + " " + Time()

		U_EnvEmail(GETMV("MV_RELFROM"),GETMV("ES_CNHEML"),,_cAssunto,_cMsg)

		// --- Grava log e define status de gravacao do plano
		aAdd( _aLog, { _nPlanoId, StrZero((_nX+1),TamSX3('PA3_ITEM')[1]), _cInterface204, dDataBase, Time() ,"Cancelado com sucesso", "Plano cancelado."    , UsrRetName(RetCodUsr()),'1' } ) // 0-Erro - 1-Normal

	// Trata alteração
	ElseIf AllTrim(_oXML:_CAB_204:_TIPO_TRANS:TEXT) = "04" .and. (DF0->DF0_STPLAN <> '2') .and. (DF0->DF0_STATUS < '4')
	// --- 	Verifica o plano existente e somente atualiza se houve pendencias
	// ---	{2LGI}
	// ---	08/09/2014 -Permitir que planos declinados sejam atualizados novamente caso a CNH envie o mesmo numero
	// ---				nesse caso o status padrao é 9 - cancelado.

		// --- Variaveis para validacao
	// 	_nTotDis	:= 	Iif ( _nTipo == 1, Val(_aDados[1][2]:_ROT_INT_KM:TEXT), Val(_aDados[1][2][1]:_ROT_INT_KM:TEXT) )
		// _aRetDF0	:= 	INTCNHVAGE('_DF0',_aDados,1,DF0->DF0_TIPO,,DF0->DF0_STPLAN)

		Begin Transaction
			// --- Inclui registro
			dbSelectArea("DF0")
			RecLock('DF0',.f.)
			// DF0->DF0_DDD		:= 	_aRetDF0[1]					// --- DDD
			// DF0->DF0_TEL		:= 	_aRetDF0[2]                 // --- Telefone
			DF0->DF0_SEQEND	:= 	''
			DF0->DF0_QTDITE	:= 	_nItens
			DF0->DF0_QTDCON	:= 	0

			// --- Campos especificos CNH
			// DF0->DF0_STPLAN	:=	_aRetDF0[Len(_aRetDF0)]

			// OTM
			AADD(_aAltPlano, {'DF0_TRANSP',GETSX3CACH("DF0_TRANSP","X3_TITULO"),DF0->DF0_TRANSP, _oXML:_CAB_204:_COD_CAR:TEXT})  // Usado para enviar e-mail com os campos alterados.
			DF0_TRANSP		:= _oXML:_CAB_204:_COD_CAR:TEXT

			AADD(_aAltPlano, {'DF0_METPGT',GETSX3CACH("DF0_METPGT","X3_TITULO"),DF0->DF0_METPGT, _oXML:_CAB_204:_METOD_PAGO:TEXT})  // Usado para enviar e-mail com os campos alterados.
			DF0_METPGT		:= _oXML:_CAB_204:_METOD_PAGO:TEXT

			AADD(_aAltPlano, {'DF0_TPTRA' ,GETSX3CACH("DF0_TPTRA","X3_TITULO") ,DF0->DF0_TPTRA , _oXML:_CAB_204:_TIPO_TRANS:TEXT})  // Usado para enviar e-mail com os campos alterados.
			DF0_TPTRA		:= _oXML:_CAB_204:_TIPO_TRANS:TEXT

			AADD(_aAltPlano, {"DF0_REFSOL",GETSX3CACH("DF0_REFSOL","X3_TITULO"),DF0->DF0_REFSOL, _oXML:_CAB_204:_REF_SOLIC:TEXT})  // Usado para enviar e-mail com os campos alterados.
			DF0_REFSOL		:= _oXML:_CAB_204:_REF_SOLIC:TEXT

			AADD(_aAltPlano, {"DF0_CODARE",GETSX3CACH("DF0_CODARE","X3_TITULO"),DF0->DF0_CODARE, _oXML:_CAB_204:_COD_AREA:TEXT})  // Usado para enviar e-mail com os campos alterados.
			DF0_CODARE		:= _oXML:_CAB_204:_COD_AREA:TEXT

			AADD(_aAltPlano, {"DF0_TIPOVE",GETSX3CACH("DF0_TIPOVE","X3_TITULO"),DF0->DF0_TIPOVE, _oXML:_CAB_204:_COD_EQUIP:TEXT})  // Usado para enviar e-mail com os campos alterados.
			DF0_TIPOVE		:= _oXML:_CAB_204:_COD_EQUIP:TEXT

			AADD(_aAltPlano, {"DF0_PESOBT",GETSX3CACH("DF0_PESOBT","X3_TITULO"),DF0->DF0_PESOBT, Val(_oXML:_CAB_204:_PESO:TEXT)})  // Usado para enviar e-mail com os campos alterados.
			DF0_PESOBT		:= Val(_oXML:_CAB_204:_PESO:TEXT)

			AADD(_aAltPlano, {"DF0_UNDPES",GETSX3CACH("DF0_UNDPES","X3_TITULO"),DF0->DF0_UNDPES, _oXML:_CAB_204:_UM_PESO:TEXT})  // Usado para enviar e-mail com os campos alterados.
			DF0_UNDPES		:= _oXML:_CAB_204:_UM_PESO:TEXT

			AADD(_aAltPlano, {"DF0_VOLUME",GETSX3CACH("DF0_VOLUME","X3_TITULO"),DF0->DF0_VOLUME, Val(_oXML:_CAB_204:_VOLUME:TEXT)})  // Usado para enviar e-mail com os campos alterados.
			DF0_VOLUME		:= Val(_oXML:_CAB_204:_VOLUME:TEXT)

			AADD(_aAltPlano, {"DF0_UNDVOL",GETSX3CACH("DF0_UNDVOL","X3_TITULO"),DF0->DF0_UNDVOL, _oXML:_CAB_204:_UM_VOLUME:TEXT})  // Usado para enviar e-mail com os campos alterados.
			DF0_UNDVOL		:= _oXML:_CAB_204:_UM_VOLUME:TEXT

			AADD(_aAltPlano, {"DF0_QTDEMB",GETSX3CACH("DF0_QTDEMB","X3_TITULO"),DF0->DF0_QTDEMB, Val(_oXML:_CAB_204:_QTY_EMB:TEXT)})  // Usado para enviar e-mail com os campos alterados.
			DF0_QTDEMB		:= Val(_oXML:_CAB_204:_QTY_EMB:TEXT)

			_aNotas := fBuscaNotas(_oXML:_CAB_204)

			AADD(_aAltPlano, {"DF0_VALFRE",GETSX3CACH("DF0_VALFRE","X3_TITULO"),DF0->DF0_VALFRE, _aNotas[01]})  // Usado para enviar e-mail com os campos alterados.
			DF0->DF0_VALFRE		:= _aNotas[01]

			AADD(_aAltPlano, {"DF0_PEDAG",GETSX3CACH("DF0_PEDAG","X3_TITULO"),DF0->DF0_PEDAG, _aNotas[02]})  // Usado para enviar e-mail com os campos alterados.
			DF0->DF0_PEDAG		:= _aNotas[02]

			AADD(_aAltPlano, {"DF0_ESCOLT",GETSX3CACH("DF0_ESCOLT","X3_TITULO"),DF0->DF0_ESCOLT, _aNotas[03]})  // Usado para enviar e-mail com os campos alterados.
			DF0->DF0_ESCOLT		:= _aNotas[03]

			AADD(_aAltPlano, {"DF0_CURREN",GETSX3CACH("DF0_CURREN","X3_TITULO"),DF0->DF0_CURREN, _aNotas[04]})  // Usado para enviar e-mail com os campos alterados.
			DF0->DF0_CURREN		:= _aNotas[04]

			_aNotas := fBuscaNotas(_oXML:_CAB_204)
			DF0->DF0_VALFRE		:= _aNotas[01]
			AADD(_aAltPlano, {"DF0_VALFRE",GETSX3CACH("DF0_VALFRE","X3_TITULO"),DF0->DF0_VALFRE, _aNotas[01]})

			DF0->DF0_PEDAG		:= _aNotas[02]
			AADD(_aAltPlano, {"DF0_PEDAG",GETSX3CACH("DF0_PEDAG","X3_TITULO"),DF0->DF0_PEDAG, _aNotas[02]})

			DF0->DF0_ESCOLT		:= _aNotas[03]
			AADD(_aAltPlano, {"DF0_ESCOLT",GETSX3CACH("DF0_ESCOLT","X3_TITULO"),DF0->DF0_ESCOLT, _aNotas[03]})

			DF0->DF0_CURREN		:= _aNotas[04]
			AADD(_aAltPlano, {"DF0_CORREN",GETSX3CACH("DF0_CURREN","X3_TITULO"),DF0->DF0_CURREN, _aNotas[04]})
/*
			DF0->DF0_OBS1		:= _aNotas[05]
			AADD(_aAltPlano, {"DF0_OBS1",GETSX3CACH("DF0_OBS","X3_TITULO"),DF0->DF0_OBS1, _aNotas[05]})
*/
			DF0->DF0_OBS2		:= _aNotas[05]
			AADD(_aAltPlano, {"DF0_OBS2",GETSX3CACH("DF0_OBS2","X3_TITULO"),DF0->DF0_OBS2, _aNotas[05]})

			DF0->DF0_OBS3		:= _aNotas[06]
			AADD(_aAltPlano, {"DF0_OBS3",GETSX3CACH("DF0_OBS3","X3_TITULO"),DF0->DF0_OBS3, _aNotas[06]})

			DF0->DF0_OBS4		:= _aNotas[07]
			AADD(_aAltPlano, {"DF0_OBS5",GETSX3CACH("DF0_OBS5","X3_TITULO"),DF0->DF0_OBS5, _aNotas[07]})

			DF0->DF0_OBS5		:= _aNotas[08]
			AADD(_aAltPlano, {"DF0_OBS5",GETSX3CACH("DF0_OBS5","X3_TITULO"),DF0->DF0_OBS5, _aNotas[08]})

			DF0->DF0_OBS6		:= _aNotas[09]
			AADD(_aAltPlano, {"DF0_OBS5",GETSX3CACH("DF0_OBS5","X3_TITULO"),DF0->DF0_OBS6, _aNotas[09]})

			// Gravo a kilometragem
			_nKM					:= _aColeta[1][2][11]
			DF0->DF0_KMPLAN		:= _nKM

			DF0->(MsUnLock())

			// --- Caso surga alguma incosistencia, atualiza o plano, mesmo que tenha passado na primeira validação
			/*
			If _aRetDF0[Len(_aRetDF0)] <> '0'
				RecLock('DF0',.f.)
				DF0->DF0_STPLAN		:=	_aRetDF0[Len(_aRetDF0)]
				DF0->(MsUnLock())
			EndIf
			*/
			// ---	Consistência do Km informado
			//_aRetKm	:= INTCNHKM(_aDados)

			// --- Atualiza os itens
			// --- Localiza os itens para atualização
			DF1->(dbSetOrder(1))
			// --- Inclui os itens do agendamento

			// OTM
			_cNumPed	:= ""
			_cNumModel	:= ""
			_cCliOri	:= ""
			_cCliDest	:= ""

			_nQtdItem	:= fContaItem(_aColeta)

			_nItens		:= 	0

			For _nX	:= 1 to Len(_aColeta)  // _nItens // STEP 2 No XML( TAG COLETA ) vem sem sempre dois reistros(ORIGEM e DESTINO) e gerará um registro no DF1
				// --- Inclui registro de itens do agendamento
				If _cCliOri <> AllTrim(_aColeta[_nX][2][1]) .AND. _cCliDest <> AllTrim(_aColeta[_nX][3][1])

					_cCliOri := AllTrim(_aColeta[_nX][2][1])
					_cCliDest:= AllTrim(_aColeta[_nX][3][1])
					_nItens++


					_cParada := StrZero(Val(_aColeta[_nX][2][2]),TamSX3('DF1_ITEAGE')[1])

					If DF1->(dbSeek(xFilial('DF1')+DF0->DF0_NUMAGE+_cParada))
						// --- Inclui registro de itens do agendamento
						RecLock('DF1',.f.)
					Else
						// --- Inclui registro de itens do agendamento
						RecLock('DF1',.t.)
					EndIf

					DF1->DF1_FILIAL		:=	xFilial('DF1')
					DF1->DF1_NUMAGE		:=	DF0->DF0_NUMAGE
					DF1->DF1_ITEAGE		:=  _cParada
					DF1->DF1_STACOL		:= 	'1'
					DF1->DF1_STAENT		:= 	'1'
					DF1->DF1_LOCCOL		:= 	'2'
					DF1->DF1_FILORI		:= 	''	// --- GetAdvFVal('DUY','DUY_FILDES',xFilial('DUY')+_aRetDF1[3],1,'')

					// OTM
					_cNumPed			:= ""
					_cNumModel			:= ""

					// Dados de Origem
					_aCliLoja := fBuscaCliente(_nPlanoID, AllTrim(_aColeta[_nX][2][1]),"ORIGEM") // :_ID_ORIGEM:TEXT

					AADD(_aAltPlano, {"DF1_MOTPAR",GETSX3CACH("DF1_MOTPAR","X3_TITULO"),DF1->DF1_MOTPAR, _aColeta[_nX][2][3]})  // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_MOTPAR		:= _aColeta[_nX][2][3] // _SEQ_RAZON:TEXT

					AADD(_aAltPlano, {"DF1_PESOBT",GETSX3CACH("DF1_PESOBT","X3_TITULO"),DF1->DF1_PESOBT, Val(_aColeta[_nX][2][4])})  // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_PESOBT		:= Val(_aColeta[_nX][2][4])

					AADD(_aAltPlano, {"DF1_UNDPES",GETSX3CACH("DF1_UNDPES","X3_TITULO"),DF1->DF1_UNDPES, _aColeta[_nX][2][5] })  // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_UNDPES		:= _aColeta[_nX][2][5]

					AADD(_aAltPlano, {"DF1_UNDSHP",GETSX3CACH("DF1_UNDSHP","X3_TITULO"),DF1->DF1_UNDSHP, Val(_aColeta[_nX][2][6]) })  // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_UNDSHP		:= Val(_aColeta[_nX][2][6])

					AADD(_aAltPlano, {"DF1_UNDENV",GETSX3CACH("DF1_UNDENV","X3_TITULO"),DF1->DF1_UNDENV, _aColeta[_nX][2][7] } )  // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_UNDENV		:= _aColeta[_nX][2][7]

					AADD(_aAltPlano, {"DF1_VOLUME",GETSX3CACH("DF1_VOLUME","X3_TITULO"),DF1->DF1_VOLUME, Val(_aColeta[_nX][2][8]) } ) // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_VOLUME		:= Val(_aColeta[_nX][2][8])

					AADD(_aAltPlano, {"DF1_UNDVOL",GETSX3CACH("DF1_UNDVOL","X3_TITULO"),DF1->DF1_UNDVOL, _aColeta[_nX][2][9] } ) // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_UNDVOL		:= _aColeta[_nX][2][9]

					AADD(_aAltPlano, {"DF1_DTRETD",GETSX3CACH("DF1_DTRETD","X3_TITULO"),DF1->DF1_DTRETD, STOD(StrTran(SubStr(_aColeta[_nX][2][10],1,10),"-","")) } ) // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_DTRETD		:= STOD(StrTran(SubStr(_aColeta[_nX][2][10],1,10),"-",""))

					AADD(_aAltPlano, {"DF1_HRRETD",GETSX3CACH("DF1_HRRETD","X3_TITULO"),DF1->DF1_HRRETD, StrTran(SubStr(_aColeta[_nX][2][10],12,08),":","") } ) // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_HRRETD		:= StrTran(SubStr(_aColeta[_nX][2][10],12,08),":","")

					AADD(_aAltPlano, {"DF1_CLIREM",GETSX3CACH("DF1_CLIREM","X3_TITULO"),DF1->DF1_CLIREM, _aCliLoja[01] } ) // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_CLIREM		:= _aCliLoja[01]

					AADD(_aAltPlano, {"DF1_LOJREM",GETSX3CACH("DF1_LOJREM","X3_TITULO"),DF1->DF1_LOJREM, _aCliLoja[02] } ) // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_LOJREM		:= _aCliLoja[02]

					AADD(_aAltPlano, {"DF1_CDRORI",GETSX3CACH("DF1_CDRORI","X3_TITULO"),DF1->DF1_CDRORI, _aCliLoja[03] } ) // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_CDRORI		:= _aCliLoja[03]

					AADD(_aAltPlano, {"DF1_NUMPUR",GETSX3CACH("DF1_NUMPUR","X3_TITULO"),DF1->DF1_NUMPUR, _aColeta[_nX]:_DETALHES:_NUM_PED:TEXT } ) // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_NUMPUR			:= _aColeta[_nX]:_DETALHES:_NUM_PED:TEXT

					If Empty(DF1->DF1_CLIDEV) .OR. DF1->DF1_CLIDEV = "000000"
						AADD(_aAltPlano, {"DF1_CLIDEV",GETSX3CACH("DF1_CLIDEV","X3_TITULO"),DF1->DF1_CLIDEV, _aCliLoja[4] } ) // Usado para enviar e-mail com os campos alterados.
						DF1->DF1_CLIDEV		:= _aCliLoja[4]

						AADD(_aAltPlano, {"DF1_LOJDEV",GETSX3CACH("DF1_LOJDEV","X3_TITULO"),DF1->DF1_LOJDEV, _aCliLoja[5] } ) // Usado para enviar e-mail com os campos alterados.
						DF1->DF1_LOJDEV		:= _aCliLoja[5]
						
						RecLock('DF0',.f.)
							DF0->DF0_DDD	:= 	_aCliLoja[06]					// --- DDD
							DF0->DF0_TEL	:= 	_aCliLoja[07]                   // --- Telefone
						DF0->(MsUnLock())						
					EndIf

					// Dados de Destino
					_aCliLoja := fBuscaCliente(_nPlanoID,AllTrim(_aColeta[_nX][3][1]),"DESTINO") // :_ID_DESTINO:TEXT

					AADD(_aAltPlano, {"DF1_DTENTR",GETSX3CACH("DF1_DTENTR","X3_TITULO"),DF1->DF1_DTENTR, STOD(StrTran(SubStr(_aColeta[_nX][3][10],1,10),"-",""))  } ) // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_DTENTR		:= STOD(StrTran(SubStr(_aColeta[_nX][3][10],1,10),"-",""))

					AADD(_aAltPlano, {"DF1_HRENTR",GETSX3CACH("DF1_HRENTR","X3_TITULO"),DF1->DF1_HRENTR, StrTran(SubStr(_aColeta[_nX][3][10],12,08),":","") } ) // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_HRENTR		:= StrTran(SubStr(_aColeta[_nX][3][10],12,08),":","")

					AADD(_aAltPlano, {"DF1_CLIDES",GETSX3CACH("DF1_CLIDES","X3_TITULO"),DF1->DF1_CLIDES, _aCliLoja[1] } ) // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_CLIDES		:= _aCliLoja[1]

					AADD(_aAltPlano, {"DF1_LOJDES",GETSX3CACH("DF1_LOJDES","X3_TITULO"),DF1->DF1_LOJDES, _aCliLoja[2] } ) // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_LOJDES		:= _aCliLoja[2]

					AADD(_aAltPlano, {"DF1_CDRDES",GETSX3CACH("DF1_CDRDES","X3_TITULO"),DF1->DF1_CDRDES, _aCliLoja[3] } ) // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_CDRDES		:= _aCliLoja[3]

					If Empty(DF1->DF1_CLIDEV) .OR. DF1->DF1_CLIDEV = "000000"
						AADD(_aAltPlano, {"DF1_CLIDEV",GETSX3CACH("DF1_CLIDEV","X3_TITULO"),DF1->DF1_CLIDEV, _aCliLoja[4] } ) // Usado para enviar e-mail com os campos alterados.
						DF1->DF1_CLIDEV		:= _aCliLoja[4]

						AADD(_aAltPlano, {"DF1_LOJDEV",GETSX3CACH("DF1_LOJDEV","X3_TITULO"),DF1->DF1_LOJDEV, _aCliLoja[5] } ) // Usado para enviar e-mail com os campos alterados.
						DF1->DF1_LOJDEV		:= _aCliLoja[5]
						
						RecLock('DF0',.f.)
							DF0->DF0_DDD	:= 	_aCliLoja[06]					// --- DDD
							DF0->DF0_TEL	:= 	_aCliLoja[07]                   // --- Telefone
						DF0->(MsUnLock())						
					EndIf
					AADD(_aAltPlano, {"DF1_NUMPUR",GETSX3CACH("DF1_NUMPUR","X3_TITULO"),DF1->DF1_NUMPUR, _aColeta[_nX][1] } ) // Usado para enviar e-mail com os campos alterados.
					DF1->DF1_NUMPUR			:= _aColeta[_nX][1] // :_NUM_PED:TEXT

					/*----------------------------------*/
					DF1->DF1_SQEREM		:= 	''
					DF1->DF1_TIPTRA		:= 	'1'
					DF1->DF1_SELORI		:= 	'3'

					DF1->DF1_SQEDES		:= 	''
					//DF1->DF1_CDRDES		:= 	_aRetDF1[6]
					//DF1->DF1_CLIDEV		:= 	_aRetDF1[7]
					//DF1->DF1_LOJDEV		:=  _aRetDF1[8]
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
					// DF1->DF1_DISTAN		:= 	_aRetKm[_nX,3]
					DF1->DF1_KMFRET		:= ( _nKM / _nQtdItem )
					DF1->DF1_DATCON		:=  Ctod('')
					DF1->DF1_SEQUEN		:=  StrZero(_nX,TamSX3('DF1_SEQUEN')[1])
					DF1->DF1_DISTIV		:=	'3'
					DF1->DF1_DATCAN		:=  Ctod('')
					DF1->DF1_CODOBC		:=	''
					//DF1->DF1_MRKPAN		:=  ''
					//DF1->DF1_NFBALC		:=	''

					// --- Campos especificos CNH

					DF1->(MsUnLock())

					// Envia e-mail com os campos alterados no plano.
					fEnvAltPlano(_nPlanoId, _aAltPlano)

					// --- Caso surga alguma incosistencia, atualiza o plano, mesmo que tenha passado na primeira validação
					/*
					If _aRetDF1[Len(_aRetDF1)] <> '0'
						RecLock('DF0',.f.)
						DF0->DF0_STPLAN		:=	_aRetDF1[Len(_aRetDF1)]
						DF0->(MsUnLock())
					EndIf
					*/

					// ---	Verifica se houve problema na validacao de KM
					/*
					If _aRetKm[_nX,6] <> Val('0')
						RecLock('DF0',.f.)
						DF0->DF0_STPLAN		:=	StrZero(_aRetKm[_nX,6], TamSX3('DF0_STPLAN')[1] )
						DF0->(MsUnLock())
					EndIf
					*/

					//	--- Verifica descricao de grupo de veiculos para registra no log
					//_aRetBox 	:= RetSx3Box( Posicione('SX3', 2, 'PA4_XTPVEI', 'X3CBox()' ),,, Len(_aRetKm[_nX,8]))
					//_cGrpVei	:= Iif ( _aRetKm[_nX,8] <> '99', AllTrim( _aRetBox[ Ascan( _aRetBox, { |x| x[2] ==  _aRetKm[_nX,8] } ), 3 ]), 'Grupo não identificado')

					// ---	Se houve problema no controle de KM
					/*
					If GetMv('ES_CNHBLKM')
						If _aRetKm[_nX,6] == 1
							// --- Grava log e define status de gravacao do plano
							aAdd( _aLog, { _nPlanoId, StrZero(_nX,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Km Frete', 'Divergência de Km '+Transform(_aRetKm[_nX,2], '@R 99.999.999/9999-99')+' - '+Transform(_aRetKm[_nX,7], '@R 99.999.999/9999-99')+ ' Grupo - '+ _cGrpVei 	, UsrRetName(RetCodUsr()),'0' } )
						Else
							// --- Grava log e define status de gravacao do plano
							aAdd( _aLog, { _nPlanoId, StrZero(_nX,TamSX3('PA3_ITEM')[1]), _cinterface060, dDataBase, Time() ,'Km Frete', 'Km conferido na margem '+Transform(_aRetKm[_nX,2], '@R 99.999.999/9999-99')+' - '+Transform(_aRetKm[_nX,7], '@R 99.999.999/9999-99')+ ' Grupo - '+ _cGrpVei, UsrRetName(RetCodUsr()),'1' } )
						EndIf
					EndIf
					*/

					// --- Grava log do item analisado
					// INTCNHGLOG(_aLog)

					// --- Log gravado na analise dos itens

					// --- Produto do item do agendamento
					// --- Nao precisa grava Log do produto
					// --- Tipo de veiculo
					// ---
					// --- Variaveis para validacao

					// --- Grava log e define status de gravacao do plano
					aAdd( _aLog, { _nPlanoId, PA3->PA3_ITEM, _cInterface204, dDataBase, Time() ,"Interface 204","Alterado com sucesso", UsrRetName(RetCodUsr()),'1' } )
					INTCNHGLOG(_aLog)
				Else
					_cNumPed += IIF(!Empty(_cNumPed),"/","") +  _aColeta[_nX][1]
				EndIf
			Next _nX

			RecLock('DF0',.f.)
				If !Empty(_cNumPed)
					_mMSMOBS			:=	_cNumPed
					DF0->DF0_CODOBS		:=	MSMM(,,,_mMSMOBS,1,,,'DF0','DF0_CODOBS')
					// DF0->DF0_OBS		:= _cNumPed
				EndIf

				//DF0->DF0_DDD	:= 	_aCliLoja[06]					// --- DDD
				//DF0->DF0_TEL	:= 	_aCliLoja[07]                   // --- Telefone
				DF0->DF0_QTDITE	:= _nItens

			DF0->(MsUnLock())

			// ---	Verifica se houve problema na validacao de KM
			If Empty(DF1->DF1_CLIREM) .OR. Empty(DF1->DF1_CLIDEV)
				RecLock('DF0',.f.)
				DF0->DF0_STPLAN		:=	"1"
				DF0->(MsUnLock())
				aAdd( _aLog, { _nPlanoId, StrZero((_nX+1),TamSX3('PA3_ITEM')[1]), _cInterface204, dDataBase, Time() ,"Interface 204","Importado com restrições", UsrRetName(RetCodUsr()),'0' } )
				INTCNHGLOG(_aLog)

			Else
				RecLock('DF0',.f.)
				DF0->DF0_STPLAN		:=	"0"  // Importado com sucesso
				DF0->(MsUnLock())

				// --- Grava log e define status de gravacao do plano
				aAdd( _aLog, { _nPlanoId, StrZero((_nX+1),TamSX3('PA3_ITEM')[1]), _cInterface204, dDataBase, Time() ,"Interface 204","Importado com sucesso", UsrRetName(RetCodUsr()),'0' } )
				INTCNHGLOG(_aLog)
			EndIf

		End Transaction

	EndIf

	// --- Fim se o plano ja existe
EndIf

Return

/*******************************/
/* Busca Cliente               */
/*******************************/
Static Function fBuscaCliente(_nPlanoID,_cID_Cliente, _cComplemento)
Local _aArea 		:= GetArea()
Local _aCliLoja 	:= Array(09)
Local _cCliGen		:= SubStr(GetMv('MV_CLIGEN'),1,TamSX3('A1_COD')[1])
Local _cLojGen		:= SubStr(GetMv('MV_CLIGEN'),Len(_cCliGen)+1,TamSX3('A1_LOJA')[1])
Local _cCNPJGen		:= GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+_cCliGen+_cLojGen,1,'')

DEFAULT _cComplemento := ""

/*
Local _cOper		:=	GetMV('ES_CNHOPER',,'')
Local _cServ		:=	GetMV('ES_CNHSERV',,'')
Local _aServ		:= 	Iif(!Empty(_cServ),&_cServ,{})	// --- Operacoes CNH
Local _aOper		:= 	Iif(!Empty(_cOper),&_cOper,{})	// --- Servicos GEFCO CNH
*/

_aCliLoja[1]		:= ""  // Cliente Remetente / Destinatario
_aCliLoja[2]		:= ""  // Loja do Cliente Remetente / Destinatario
_aCliLoja[3]		:= ""  // Região do Cliente
_aCliLoja[4]		:= ""  // Cliente Devedor
_aCliLoja[5]		:= ""  // Loja do Cliente Devedor
_aCliLoja[6]		:= ""  // Cliente Solicitante
_aCliLoja[7]		:= ""  // Loja do Cliente Solicitante
// Por: Ricardo Guimarães - Em: 23/06/2016 - Objetivo: Passar a tratar ORIGEM/DESTINO/KM/TIPO SERVIÇO/TIPO OPERAÇÃO
_aCliLoja[8]		:= ""  // PA7_LOCROL -> Campo que define Origem/Destino da Coleta
_aCliLoja[9]		:= ""  // PA7_PLANT  -> Campo que define qual a plata da CNH será coletado, isto ocorre quando o campo PA7_LOCROL = PLANT

SA1->(dbSetOrder(3))
dbSelectArea("PA7") ; dbSetOrder(2)

If dbSeek(xFilial("PA7")+AllTrim(_cID_Cliente))
	If SA1->(dbSeek(xFilial("SA1") + AllTrim(PA7->PA7_CNPJ)))
 		_aCliLoja[1] := SA1->A1_COD
 		_aCliLoja[2] := SA1->A1_LOJA
 		_aCliLoja[3] := SA1->A1_CDRDES

 		// Pego o devedor
		// ---	Forca a CNH sempre um dos CNPJ CNH ou Iveco
		// --- Identifica como o destinatario
		If At(SubStr(SA1->A1_CGC,1,8),GetMv('ES_CGCDEV')) == 0

			//	---	Se nao localizou, pego o cliente Generico
			_aCliLoja[4] := _cCliGen
			_aCliLoja[5] := _cLojGen
		Else
			_aCliLoja[4] := SA1->A1_COD
			_aCliLoja[5] := SA1->A1_LOJA
			_aCliLoja[6] := SA1->A1_DDD
			_aCliLoja[7] := SA1->A1_TEL
		EndIf
 	Else
 		// --- Grava log e define status de gravacao do plano
		aAdd( _aLog, { _nPlanoID, StrZero(_nItemLog,3), _cInterface204, dDataBase, Time() ,'Cliente ' + _cComplemento + ' localizado na tabela PA7 mas não na SA1!', 'Importado com Pendencia!', UsrRetName(RetCodUsr()),'1' } )
		_nItemLog++
 	EndIf
 	
 	_aCliLoja[08] := PA7->PA7_LOCROL
 	_aCliLoja[09] := PA7->PA7_PLANT
 	 	
Else
	// --- Grava log e define status de gravacao do plano
	aAdd( _aLog, { _nPlanoID, StrZero(_nItemLog,3), _cInterface204, dDataBase, Time() ,'Cliente ' + _cComplemento + ' não localizado na tabela PA7!', 'Importado com Pendencia!', UsrRetName(RetCodUsr()),'1' } )
	_nItemLog	
EndIf

RestArea(_aArea)
Return _aCliLoja

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
	PA3->PA3_ITEM			:= 	_aLog[1][2]
	PA3->PA3_WSID			:= 	_aLog[1][3]
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

 /*/
 {Protheus.doc} CNHINT990
Função responsável por enviar o aceite do plano de transporte CNH/IVECO
através do método interface204.
@author	U297686 - Ricardo Guimarães
@since 		07/12/2015
@version 	1.0
@param 		_nPlanoId, ${integer}, Número do plano de transporte
@param 		_lAuto, ${boolean}, .T. automático, .F. manual
@return 	${_lRet}, ${.T. processamento normal, .F. problema no processamento}
@example	(examples)
@see 		(links_or_references)
/*---------------------------------------------------*/
User Function CNHOTM990(_lAuto, _nPlanoId, _cStatus, _cRejAuto)
// --- Variaveis utilizadas
Local _aArea		:= GetArea()
Local _lRet		:= .f.
Local _cXML		:= ''
Local _cArqORIG 	:= ""
Local _cArq990  	:= GetNewPar("ES_ARQ990","CNH_990_")
LOCAL _nHandle 	:= 0
LOCAL _nItem		:= 1

DEFAULT _lAuto 	:= .F.

// ---	Prepara XML para envio
_cXML	:=	'<?xml version="1.0" encoding="UTF-8"?>'
_cXML	+=	'<CAB_990 xmlns:xsd="http://www.w3.org/2001/XMLSchema">'
_cXML	+=	'	<COD_CAR> '      + AllTrim(DF0->DF0_TRANSP) + '</COD_CAR>'
_cXML	+=	'	<REF_SOLIC> '    + AllTrim(DF0->DF0_REFSOL) + '</REF_SOLIC>'
_cXML	+=	'	<FECHA_ACCEPT> ' + TRANSFORM(DTOS(DDATABASE),"@R 9999-99-99") + '</FECHA_ACCEPT>'
_cXML	+=	'	<ESTATUS_PED> '  + AllTrim(_cStatus) + '</ESTATUS_PED>'
_cXML	+=	'	<COD_AREA> ' 	 + AllTrim(DF0->DF0_CODARE) + '</COD_AREA>'
_cXML	+=	'</CAB_990>'

// XML com error, não processa e move para a pasta backup
MONTADIR(cPATH990)
_cArqORIG := cPATH990 + AllTrim(_cArq990) + AllTrim(Str(_nPlanoId)) + ".xml"

// Gravação do arquivo com a interface 990
_nHandle := FCREATE(_cArqOrig, FC_NORMAL)
If _nHandle == -1
	If !_lAuto
   		MsgAlert("Não foi possível a criação do Arquivo :" + STR(FERROR()))
   	Else
   		ConOut("Não foi possível a criação do Arquivo :" + STR(FERROR()))   		
   	EndIf	

   Return .f.
Else
	// --- Tratamento de acordo com retorno do Web Service
	If _lAuto
		Iif ( _cStatus=="A", ConOut('Plano de transporte '+AllTrim(Str(_nPlanoId))+' ACEITO !','Aceite - 990'), ConOut('Plano de transporte '+AllTrim(Str(_nPlanoId))+' NÃO ACEITO !','Não Aceite'))
	Else	
		Iif ( _cStatus=="A", MsgInfo('Plano de transporte '+AllTrim(Str(_nPlanoId))+' ACEITO !','Aceite - 990'), MsgInfo('Plano de transporte '+AllTrim(Str(_nPlanoId))+' NÃO ACEITO !','Não Aceite'))
	EndIf
	
   FWRITE(_nHandle, _cXML)
   FCLOSE(_nHandle)

	If _cStatus == "A"
		aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cInterface990, dDataBase, Time() ,'Aceite plano!', 'Plano de transporte aceito!', UsrRetName(RetCodUsr()), '1' } )
	Else
		_nItem := IIF(_cRejAuto=='R',_nItemLog,_nItem)
		aAdd( _aLog, { _nPlanoId, StrZero(_nItem,TamSX3('PA3_ITEM')[1]), _cInterface990, dDataBase, Time() ,'Aceite plano!', 'Plano de transporte NAO aceito! ' + IIF(_cRejAuto=='R','Rotina automatica',''), UsrRetName(RetCodUsr()), '0' } )
	EndIf

	DF0->(RecLock("DF0",.F.))
		// Gravo Status
		DF0->DF0_STATUS := IIF(_cStatus=="A", "2","6"  )
		DF0->DF0_STPLAN := IIF(_cStatus=="A", "0","2"  )  // Aceito/Rejeitado
		DF0->DF0_CNHID	:= IIF(_cStatus=="A", "33","32") // 33 -> Em Captação - 32 -> Declinado
    DF0->(MsUnLock())

	IF _cStatus=="A"
		dbSelectArea("DF1") ; dbSetOrder(1)
		If dbSeek(xFilial("DF1")+DF0->DF0_NUMAGE)
			While !Eof() .AND. DF1->DF1_FILIAL = DF0->DF0_FILIAL .AND. DF1->DF1_NUMAGE = DF0->DF0_NUMAGE

				RecLock("DF1",.F.)
					DF1->DF1_STACOL := "2"
					DF1->DF1_FILORI := cFilAnt
				MsUnLock()
				DF1->(dbSkip())
			End
		EndIf
    EndIf

    // ---	Grava log do processo de trasmissão da interface101
    INTCNHGLOG(_aLog)

EndIf

RestArea(_aArea)
Return _lRet

/*/{Protheus.doc} CNHOTM214 ===> 501
Função responsável por transmitir a interface214 com dados de tracking do plano.
@author 	U297686 - Ricardo Guimarães
@since 		11/12/2015
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
/*/
User Function CNHOTM214(_lAuto, _nPlanoId, _cIteAge)

// --- Variaveis utilizadas
Local _lRet			:= 	.F.
Local _cXML			:= 	''
Local _cArq214  		:= GetNewPar("ES_ARQ214","CNH_214_")
Local _nHandle 		:= 0
Local _cData    		:= DTOS(dDataBase)
Local _aVeiculo 		:= {}
Local _aStatus  		:= {}
Local _cStatus_Emb	:= ""
Local _cRazao_AP		:= ""
Local _cDtEvento 		:= ""
Local _cSeqParada		:= ""

DEFAULT _lAuto 	:= .F.
DEFAULT _cIteAge  := ""

cPATH214 	:= GETNEWPAR("ES_PATH214","\Interfaces\EDICOM\OUT\INT214\")

// ---	Posiciona no plano para obter a origem CNH ou IVECO.
dbSelectArea("DF0")
dbSetOrder(3)
dbSeek( xFilial('DF0')+Str(_nPlanoId,TamSX3('DF0_PLANID')[1],0) )

dbSelectArea("DA3") ; dbSetOrder(1)
dbSeek(xFilial('DA3')+DF0->DF0_CODVEI)
_aVeiculo 	:= GetAdvFVal('DA3',{'DA3_DESC','DA3_ANOMOD','DA3_MARVEI'},xFilial('DA3')+DF0->DF0_CODVEI,1,'')
If Empty(_aVeiculo[1])
	// MsgInfo('Não há veículo informado no Plano de transporte '+AllTrim(Str(_nPlanoId))+' - 214')
	MsgAlert('Não há veículo informado no Plano de transporte '+AllTrim(Str(_nPlanoId))+' - 214')	
	Return .F.
EndIf

DF1->(dbSetOrder(1))
DF1->(dbSeek( xFilial('DF1')+DF0->DF0_NUMAGE + _cIteAge ))

_cIteAge := DF1->DF1_ITEAGE

// ---	Limpa variavel de log
_aLog	:= {}

// ---	Prepara schema e XML para envio no Web Service

//	DF0->DF0_CODVEI	:=	_cPlaca
//	DF0->DF0_CODMOT	:=	_cMot

// Pego infações de Status (STATUS_EMB e RAZAO_AP)
_aStatus := fOTM214OCO()
_cstatus_Emb 	:= _aStatus[1,1]
_cRazao_AP   	:= _aStatus[1,2]
_cDtEvento   	:= _aStatus[1,3]
// Por: Ricardo Guimarães - Em: 22/06/2015 
_cSeqParada	:= IIF(_aStatus[1,4] $ "CNH3|CNH4" .and. !Empty(DF1->DF1_SEQENT), DF1->DF1_SEQENT, _cIteAge )

_cXML	:=	'<?xml version="1.0" encoding="UTF-8"?>'
_cXML	+=	'<CAB_214 xmlns:xsd="http://www.w3.org/2001/XMLSchema">'
 _cXML	+=	'	<NUM_FAT>'      + AllTrim(Str(DF0->DF0_PLANID))  + '</NUM_FAT>'
_cXML	+=	'	<ID_EMB>'       + AllTrim(Str(DF0->DF0_PLANID))  + '</ID_EMB>'
_cXML	+=	'	<COD_CAR>'      + AllTrim(DF0->DF0_TRANSP)       + '</COD_CAR>'
_cXML	+=	'	<COD_AREA>'     + AllTrim(DF0->DF0_CODARE)       + '</COD_AREA>'
_cXML	+=	'	<STATUS>'
//_cXML	+=	'		<SEQ_PARADA>' + AllTrim(_cIteAge)     		 + '</SEQ_PARADA>'
_cXML	+=	'		<SEQ_PARADA>' + AllTrim(_cSeqParada)  			+ '</SEQ_PARADA>'
If !Empty(_cStatus_Emb) .AND. !Empty(_cRazao_AP)
	_cXML	+=	'		<STATUS_EMB>' + AllTrim(_cStatus_Emb)		+ '</STATUS_EMB>'
	_cXML	+=	'		<RAZAO_AP>'   + AllTrim(_cRazao_AP)  		+ '</RAZAO_AP>'
Else
	_cXML	+=	'		<STATUS_EMB>' + "X2"    				 		+ '</STATUS_EMB>'
	_cXML	+=	'		<RAZAO_AP>'   + "NS"      					+ '</RAZAO_AP>'
EndIf
_cXML	+=	'		<DT_EVENTO>'  + _cDtEvento 				 		+ '</DT_EVENTO>'
_cXML	+=	'		<VEI_MODELO>' + AllTrim(_aVeiculo[01])   		+ '</VEI_MODELO>'
_cXML	+=	'		<VEI_ANO>'    + AllTrim(_aVeiculo[02])   		+ '</VEI_ANO>'
_cXML	+=	'		<VEI_MARCA>'  + AllTrim(_aVeiculo[03])   		+ '</VEI_MARCA>'
/*
_cXML	+=	'		<OBS>'        + AllTrim("") + '</OBS>'
_cXML	+=	'		<OBS_2>'      + AllTrim("") + '</OBS_2>'
_cXML	+=	'		<OBS_3>'      + AllTrim("") + '</OBS_3>'
_cXML	+=	'		<OBS_4>'      + AllTrim("") + '</OBS_4>'
_cXML	+=	'		<OBS_5>'      + AllTrim("") + '</OBS_5>'
_cXML	+=	'		<OBS_6>'      + AllTrim("") + '</OBS_6>'
_cXML	+=	'		<OBS_7>'      + AllTrim("") + '</OBS_7>'
_cXML	+=	'		<OBS_8>'      + AllTrim("") + '</OBS_8>'
_cXML	+=	'		<OBS_9>'      + AllTrim("") + '</OBS_9>'
_cXML	+=	'		<OBS_10>'     + AllTrim("") + '</OBS_10>'
_cXML	+=	'		<OBS_11>'     + AllTrim("") + '</OBS_11>'
_cXML	+=	'		<OBS_12>'     + AllTrim("") + '</OBS_12>'
_cXML	+=	'		<OBS_13>'     + AllTrim("") + '</OBS_13>'
_cXML	+=	'		<OBS_14>'     + AllTrim("") + '</OBS_14>'
_cXML	+=	'		<OBS_15>'     + AllTrim("") + '</OBS_15>'
_cXML	+=	'		<OBS_16>'     + AllTrim("") + '</OBS_16>'
_cXML	+=	'		<OBS_17>'     + AllTrim("") + '</OBS_17>'
_cXML	+=	'		<OBS_18>'     + AllTrim("") + '</OBS_18>'
_cXML	+=	'		<OBS_19>'     + AllTrim("") + '</OBS_19>'
_cXML	+=	'		<OBS_20>'     + AllTrim("") + '</OBS_20>'
*/
_cXML	+=	'	</STATUS>'
_cXML	+=	'</CAB_214>'

// --- Tratamento de acordo com retorno do Web Service
//	Help (" ", 1, "CNH501",,_cinterface501+' - Execução do plano '+AllTrim(Str(_nPlanoId))+' transmitido com sucesso!', 3, 0),;

// XML com error, não processa e move para a pasta backup
MONTADIR(cPATH214)
_cArqORIG := cPATH214 + AllTrim(_cArq214) + AllTrim(Str(_nPlanoId)) + "_" + DTOS(dDATABASE) + StrTran(Time(),":","") + ".xml"

// --- Verifica se foi por rotina automaticaU
If !_lAuto

	// Gravação do arquivo com a interface 990
	_nHandle := FCREATE(_cArqOrig, FC_NORMAL)
	If _nHandle == -1
          MsgAlert("Não foi possível a criação do Arquivo :" + STR(FERROR()))

          _lRet := .F.
	Else
	    FWRITE(_nHandle, _cXML)
	    FCLOSE(_nHandle)


		// --- Grava log e define status de gravacao do plano
//		If _lRet
			aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cInterface214, dDataBase, Time() ,'Execução do plano', 'Informações de Monitoramento do plano transmitido na data/hora!', UsrRetName(RetCodUsr()),'1' } )
//		Else
//			aAdd( _aLog, { _nPlanoId, StrZero(1,TamSX3('PA3_ITEM')[1]), _cinterface501, dDataBase, Time() ,'Execução do plano', 'Execução do plano não transmitido na data/hora!', UsrRetName(RetCodUsr()),'0' } )
//		EndIf

	    // ---	Grava log do processo de trasmissão da interface214
	    INTCNHGLOG(_aLog)
	    
		_lRet := .T.
	
	MsgInfo('Track do Plano de transporte '+AllTrim(Str(_nPlanoId))+' gerado ! - 214')
	
	EndIf

Else

EndIf

Return _lRet

/*/{Protheus.doc} OTM214A
Função responsável por receber a placa do veículo e nome do motorista
para transmitir a interface201.
Esse processo trabalha de forma antecipada a criação da viagem
transmitindo a CNH dados preliminares da captação.
@author 	U297686 - Ricardo Guimarães
@since 		17/12/2015
@version	1.0
@param 		_aRet, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function OTM214A()

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
Private	_cPlaca			:=	Space(TamSX3('DA3_COD')[1])
Private	_cMot			:=	Space(TamSX3('DA4_COD')[1])
Private	_cTransp		:=	Space(TamSX3('A2_COD')[1])

// ---	Somente planos de transporte Em Captação

If DF0->DF0_CNHID	<> '33'
	// ---	Exibe mensagem
	Help (" ", 1, "CNH214",,OemToAnsi('Somente planos Em Captação podem receber placa e motorista!'), 3, 0)
Return
EndIf

// ---	Define dialog
oDlg	:= MSDialog():New(0,0,220,550,OemToAnsi('Dados do veículo '+_cInterface214),,,,,CLR_BLACK,CLR_WHITE,,,.t.)

// ---	Define fontes para mensagens
oFont	:= TFont():New('Tahoma',,-16,.T.)
oFont1	:= TFont():New('Tahoma',,-11,.T.)

// --- Apresenta o tSay com a fonte Courier New
oSay	:= TSay():New( 005, 010, {|| OemToAnsi('Plano de transporte ')+Transform(DF0->DF0_PLANID,'@E 999,999,999' ) },oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay:lTransparent:= .F.
oSay1	:= TSay():New( 025, 010, {|| OemToAnsi('Veículo	')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay1:lTransparent:= .F.
oSay2	:= TSay():New( 045, 010, {|| OemToAnsi('Motorista ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay2:lTransparent:= .F.
oSay5	:= TSay():New( 065, 010, {|| OemToAnsi('Transportadora ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay5:lTransparent:= .F.


// 	---	Dados de entrada
@ 023,065 MSGET _cPlaca		F3 "DA3"	SIZE 20, 9 OF oDlg Picture "@!" Pixel Valid Iif ( Empty(_cPlaca), Vazio(), ExistCpo("DA3") )
oSay3	:= TSay():New( 023, 110, {|| Transform(OTM214B(_cPlaca,@_cMsg2,oDlg,oFont),"@R XXX-9999") },oDlg,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE )
oSay3:lTransparent:= .F.

@ 043,065 MSGET _cMot	F3 "DA4" 	SIZE 20, 9 OF oDlg Picture "@!" Pixel Valid Iif ( Empty(_cMot), Vazio(), ExistCpo("DA4") )
oSay4	:= TSay():New( 043, 110, {|| OTM214C(_cMot,@_cMsg1,oDlg,oFont) },oDlg,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE )
oSay4:lTransparent:= .F.

@ 063,065 MSGET _cTransp	F3 "SA2" 	SIZE 20, 9 OF oDlg Picture "@!" Pixel Valid Iif ( Empty(_cTransp), Vazio() , ExistCpo("SA2") )
oSay6	:= TSay():New( 043, 110, {|| OTM214D(_cTransp,@_cMsg3,oDlg,oFont) },oDlg,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE )
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

		// ---	Transmite interface214
		// MsgRun(OemToAnsi('Informando dados do veículo plano '+AllTrim(Str(_nPlanoId))+'...Aguarde!'  ), _cInterface214 , { || U_CNHOTM214(.F., _nPlanoId,_cMsg2,_cMsg1,DA3->DA3_ANOFAB,.f.) } )
		MsgRun(OemToAnsi('Informando dados do veículo plano '+AllTrim(Str(_nPlanoId))+'...Aguarde!'  ), _cInterface214 , { || U_CNHOTM214(.F., _nPlanoId,) } )

		// ---	Interface701 para atualizar status do plano
		//_lRet	:=	U_CNHINT701(_nPlanoId,.t.)

	EndIf
	MsgInfo("Dados Gravados.")
EndIf

Return

 /*/{Protheus.doc} OTM214B
Realiza a busca para retornar descrição de cadastro.
@author 	U297686 - Ricardo Guimarães
@since 		17/12/2015
@version 	1.0
@param 		_cTab, ${char}, Alias da tabela
@param 		_cCampo, ${char}, Campo, chave primaria
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function OTM214B(_cPlaca,_cMsg2,oDlg,oFont)

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

/*/{Protheus.doc} OTM214C
Realiza a busca para retornar descrição de cadastro.
@author 	U297686 - Ricardo Guimarães
@since 		17/12/2015
@version 	1.0
@param 		_cTab, ${char}, Alias da tabela
@param 		_cCampo, ${char}, Campo, chave primaria
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function OTM214C(_cMot,_cMsg1,oDlg,oFont)

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

/*/{Protheus.doc} OTM214D
Realiza a busca para retornar descrição de cadastro.
@author 	U297686 - Ricardo Guimarães
@since 		17/12/2015
@version 	1.0
@param 		_cTab, ${char}, Alias da tabela
@param 		_cCampo, ${char}, Campo, chave primaria
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function OTM214D(_cTransp,_cMsg3,oDlg,oFont)

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

/****************************************/
/*/{Protheus.doc} fOTM214OCO
//TODO Função para retornar para a interface 201 os status da ocorrência.
@author u297686
@since 25/01/2016
@version 1.0

@type function
/*/
Static Function fOTM214OCO(_lInt210)
/****************************************/
Local _aQuery 	:= {}
Local _aRet    	:= {}
Local _cNumAge 	:= DF1->DF1_NUMAGE
Local _cIteAge 	:= DF1->DF1_ITEAGE
Local _aArea 	 	:= GetArea()
Local TRAB       	:= GetNextAlias()
Local _cDtEvento 	:= ""
Local _aCNHOCO	:= &(GETMV("ES_CNHOCO"))
Local _cCodOcoIN 	:= ""

DEFAULT _lInt210 := .F.

AADD(_aCNHOCO, "1")
AADD(_aCNHOCO, "GC01")

For x:=1 To Len(_aCNHOCO)
	_cCodOcoIN += _aCNHOCO[x] + IIF(x==Len(_aCNHOCO),"","/")
Next x

_cCodOcoIN := " AND DUA_CODOCO IN " + FormatIN(_cCodOcoIN,"/") //AND DUA_CODOCO IN ('CNH1','CNH2','CNH3','CNH4','1','GC01')
_cCodOcoIN := "%"+_cCodOcoIN+"%" 

BeginSql Alias TRAB

	// column ZA6_DTINI as Date, ZA7_VALOR  as Numeric(18,2), DATA_INI as Date

	%noparser%

	SELECT DUA_CODMOT, DUA_CODOCO, DUA_DATCHG, DUA_DATOCO, DUA_DOC, DUA_SERIE, DUA_HORCHG, DUA_HOROCO, DUA_NUMOCO
	 FROM %Table:DF1% DF1, %Table:DUA% DUA
	WHERE DF1_NUMAGE 	= %Exp:_cNumAge%
	  AND DF1_ITEAGE 	= %Exp:_cIteAge%
  	  AND DF1_DOC 	 	= DUA_DOC
	  AND DF1_SERIE 	= DUA_SERIE
	  AND DF1_FILDOC 	= DUA_FILDOC
	  AND DF1.%NotDel%
	  AND DUA.%NotDel%
	  
	  %exp:_cCodOcoIN%
  	ORDER BY DUA_DATOCO DESC, DUA_HOROCO DESC

EndSql
//	  AND (DUA_CODOCO LIKE 'CNH%' OR DUA_CODOCO = '1' OR DUA_CODOCO = 'GC01')
_aQuery := GetLastQuery()
(TRAB)->( DbGoTop() )
If !(TRAB)->(Eof())
	// Pega a última ocorrência e converto para o padrão CNH para envia na interface 214

	If _lInt210  // Interface 210
		AADD(_aRet, {(TRAB)->DUA_CODMOT, (TRAB)->DUA_CODOCO, (TRAB)->DUA_DATCHG, (TRAB)->DUA_DATOCO, (TRAB)->DUA_DOC, (TRAB)->DUA_SERIE, (TRAB)->DUA_HORCHG, (TRAB)->DUA_HOROCO, (TRAB)->DUA_NUMOCO })
	Else
		_cDtEvento := SubStr((TRAB)->DUA_DATOCO,1,4) + SubStr((TRAB)->DUA_DATOCO,5,2) + SubStr((TRAB)->DUA_DATOCO,7,2) + AllTrim((TRAB)->DUA_HOROCO)
		If (TRAB)->DUA_CODOCO == _aCNHOCO[01] // 'CNH1'
			AADD(_aRet,{'X3','NS', _cDtEvento, ''})

		ElseIf (TRAB)->DUA_CODOCO == _aCNHOCO[02] // 'CNH2'
			AADD(_aRet,{'CP','NS', _cDtEvento, ''})

		ElseIf (TRAB)->DUA_CODOCO == _aCNHOCO[03] // 'CNH3'
			AADD(_aRet,{'X1','NS', _cDtEvento, _aCNHOCO[03]})

		ElseIf (TRAB)->DUA_CODOCO == _aCNHOCO[04] // 'CNH4'
			AADD(_aRet,{'D1','NS', _cDtEvento, _aCNHOCO[04]})

		ElseIf (TRAB)->DUA_CODOCO == '1'
			AADD(_aRet,{'CA','', _cDtEvento, ''})
			
		ElseIf (TRAB)->DUA_CODOCO == 'GC01'
			AADD(_aRet,{'X2','NS', _cDtEvento, ''})
			
		Else
			AADD(_aRet,{'','','',''})
		EndIf
	EndIf
Else
	If _lInt210  // Interface 210
		_aRet := {}
	Else
		_cDtEvento := SubStr(DTOS(dDataBase),1,4) + SubStr(DTOS(dDataBase),5,2) + SubStr(DTOS(dDataBase),7,2) + Left(StrTran(Time(),":",""),4)	
		AADD(_aRet,{'', '', _cDtEvento, ''})
	EndIf
EndIf

If Select( (TRAB) ) # 0
	( TRAB )->( DbCloseArea() )
EndIf

RestArea(_aArea)
Return _aRet

/*---------------------------------------*/
 * Função para tratar as TAG´s da Notas  *
/*---------------------------------------*/
Static Function fBuscaNotas(_oXML)
Local _aRet 	:= Array(10)
Local _aAux 	:= {}
Local _nPosFrete:= 0
Local _nPosPedag:= 0
Local _nPosMoeda:= 0
Local _nPosEsco := 0
Local _nVal 	:= 0
Local _nX		:= 0
Local _nProx    := 0

AFill(_aRet,"",1,10)

AADD(_aAux, IIF(XmlChildEx( _oXML,"_NOTAS"    )==Nil, "",_oXML:_NOTAS:TEXT   ))
AADD(_aAux, IIF(XmlChildEx( _oXML,"_NOTAS_2"  )==Nil, "",_oXML:_NOTAS_2:TEXT ))
AADD(_aAux, IIF(XmlChildEx( _oXML,"_NOTAS_3"  )==Nil, "",_oXML:_NOTAS_3:TEXT ))
AADD(_aAux, IIF(XmlChildEx( _oXML,"_NOTAS_4"  )==Nil, "",_oXML:_NOTAS_4:TEXT ))
AADD(_aAux, IIF(XmlChildEx( _oXML,"_NOTAS_5"  )==Nil, "",_oXML:_NOTAS_5:TEXT ))
AADD(_aAux, IIF(XmlChildEx( _oXML,"_NOTAS_6"  )==Nil, "",_oXML:_NOTAS_6:TEXT ))
AADD(_aAux, IIF(XmlChildEx( _oXML,"_NOTAS_7"  )==Nil, "",_oXML:_NOTAS_7:TEXT ))
AADD(_aAux, IIF(XmlChildEx( _oXML,"_NOTAS_8"  )==Nil, "",_oXML:_NOTAS_8:TEXT ))
AADD(_aAux, IIF(XmlChildEx( _oXML,"_NOTAS_9"  )==Nil, "",_oXML:_NOTAS_9:TEXT ))
AADD(_aAux, IIF(XmlChildEx( _oXML,"_NOTAS_10" )==Nil, "",_oXML:_NOTAS_10:TEXT))

// Pego valor do Frete
_nPosFrete := aScan(_aAux,{|x| "CNHILA.FREIGHT" $ alltrim(x) })
If _nPosFrete = 0
	_aRet[01] := ""
Else
	_aRet[01] := AllTrim(SUBSTR(_aAux[_nPosFrete],RAT(" ",_aAux[_nPosFrete]),25))
EndIf
_nProx := 1
	
// Pego valor do Pedágio
_nPosPedag := aScan(_aAux,{|x| "CNHILA.TOLL" $ alltrim(x) })
If _nPosPedag = 0
	_aRet[02] := ""
Else
	_aRet[02] := AllTrim(SUBSTR(_aAux[_nPosPedag],RAT(" ",_aAux[_nPosPedag]),25))
EndIf
_nProx := 2
	
// Pego valor do Escolt
_nPosEsco := aScan(_aAux,{|x|  "ESCOLT" $ alltrim(x) })
If _nPosEsco = 0
	_aRet[03] := ""
Else
	// _aRet[03] := Val(AllTrm(SUBSTR(_aAux[_nPosEsco],RAT(" ",_aAux[_nPosEsco]),25)))
	_aRet[03] := AllTrim(_aAux[_nPosEsco])
EndIf
_nProx := 3

// Pego descrição da Moeda
_nPosMoeda := aScan(_aAux,{|x| "CURRENCY" $ alltrim(x) })
If _nPosMoeda = 0
	_aRet[04] := ""
Else
	_aRet[04] := AllTrim(_aAux[_nPosMoeda])
EndIf
_nProx := 4

// Preencho os outros elementos, independente da sequencia
_nProx++

For _nX := 1 To Len(_aAux)
	If _nX == _nPosFrete .OR. _nX == _nPosPedag .OR. _nX == _nPosEsco .OR. _nX == _nPosMoeda
		Loop
	EndIf

	_aRet[_nProx] := _aAux[_nX]
	_nProx++

	If _nProx > 10
		Exit
	EndIf

Next _nX


//("CNHILA.FREIGHT 3000.0",RAT(" ","CNHILA.FREIGHT 3000.0"),22))

Return _aRet

/*/{Protheus.doc} fEnvAltPlano
//TODO  Função usada para enviar e-mail para os usuários informado em ES_CNHEML, com a lista dos campos alterados no plano
@author u297686 - Ricardo Guimarães
@since 01/03/2016
@version 1.0
@param _nPlano, Numerico, Número do Plano
@param _aCamposAtu, Array, Lista de todos os campos envolvido na atualização
@type function
/*/
Static Function fEnvAltPlano(_nPlanoId, _aCamposAtu)
Local _cAssunto := ""
Local _cMsg		:= ""
Local _nN		:= 0
Local _cAlt		:= ""

//_cMsg 		:= "Plano " + Str(_nPlanoId) + " foi ALTERADO em " + DtoC(dDATABASE) + " " + Time()

_cMsg := '<HTML>' + CRLF
_cMsg += '<H1>'   + "Plano " + Str(_nPlanoId) + " foi ALTERADO em " + DtoC(dDATABASE) + " " + Time() + '</H1>' + CRLF
// <H2>TESTE</H1>
_cMsg += '<TABLE border="2">' + CRLF
_cMsg += '	<th>Campo</th>' + CRLF
_cMsg += '	<th>Valor Anterior</th>' + CRLF
_cMsg += '	<th>Valor Alterado</th>' + CRLF

For _nN := 1 to Len(_aCamposAtu)
	If AllTrim(cValtoChar(_aCamposAtu[_nN,3])) <> AllTrim(cValtoChar(_aCamposAtu[_nN,4]))
		_cMsg += '	<tr>' + CRLF
		_cMsg += '		<td>' + cValtoChar(_aCamposAtu[_nN,2]) + '</td>' + CRLF
		_cMsg += '		<td>' + cValtoChar(_aCamposAtu[_nN,3]) + '</td>' + CRLF
		_cMsg += '		<td>' + cValtoChar(_aCamposAtu[_nN,4]) + '</td>' + CRLF
		_cMsg += '	</tr>' + CRLF
	EndIf
Next _nN

_cMsg += '</TABLE>' + CRLF
_cMsg += '</HTML>' + CRLF

// Envia e-mail
_cAssunto 	:= "Alteração de Plano " + _cInterface204

U_EnvEmail(GETMV("MV_RELFROM"),GETMV("ES_CNHEML"),,_cAssunto,_cMsg)

Return Nil


/*
Programa	: GEFCNHOTM
Funcao		: Static Fucntion GEFLEROTM
Data		: 23/03/2016
Autor		: André Costa
Descricao	: Leitura dos Arquivos XML da CNH-OTM
Uso			: Programa de Leitura de XML da CNH-OTM
Sintaxe	: GEFLEROTM()
Retorno	: Array
Chamada	:
*/

Static Function fMontaDF1(oXML)
	Local aArea	:= GetArea()
	Local aDados	:= {}
	Local nPos

	For X := 1 To Len( oXML:_Cab_204:_Coleta )

		If oXML:_Cab_204:_Coleta[X]:_SEQ_PARADA:TEXT == "0"
			Loop
		EndIf

		If ValType( oXML:_Cab_204:_Coleta[X]:_Detalhes ) == 'A'

			For Y := 1 To Len( oXML:_Cab_204:_Coleta[X]:_Detalhes )

				If UPPER(oXML:_Cab_204:_Coleta[X]:_Seq_Razon:Text) $ "LD|PL"

					nPos := aScan( aDados , { |A| UPPER(A[1]) == UPPER(oXML:_Cab_204:_Coleta[X]:_Detalhes[Y]:_Num_Ped:TEXT) } )

					// Se o pedido estiver com o pedido repetido
					If nPos # 0
						Loop
					EndIf

					AADD( aDados, {	oXML:_Cab_204:_Coleta[X]:_Detalhes[Y]:_Num_Ped:TEXT 			,;
										xRetArray(oXML,X)													,;
										{}																	,;
										IIF( ValType(oXML:_Cab_204:_Coleta[X]:_Detalhes[Y]:_Num_Model ) == 'A', oXML:_Cab_204:_Coleta[X]:_Detalhes[Y]:_Num_Model[1]:Text, oXML:_Cab_204:_Coleta[X]:_Detalhes[Y]:_Num_Model:Text ) ,;
										"" } )
				Else

					nPos := aScan( aDados , { |A| UPPER(A[1]) == UPPER(oXML:_Cab_204:_Coleta[X]:_Detalhes[Y]:_Num_Ped:TEXT) } )

					aDados[nPos][3] 	:= xRetArray(oXML,X)
					
					aDados[nPos][5] 	:= oXML:_Cab_204:_Coleta[X]:_Seq_Parada:Text

				EndIf

			Next Y

		Else

			If UPPER(oXML:_Cab_204:_Coleta[X]:_Seq_Razon:Text) $ "LD|PL"

				AADD( aDados, {	oXML:_Cab_204:_Coleta[X]:_Detalhes:_Num_Ped:TEXT				,;
									xRetArray(oXML,X)														,;
									{}  																,;
									IIF( ValType(oXML:_Cab_204:_Coleta[X]:_Detalhes:_Num_Model)=="A", oXML:_Cab_204:_Coleta[X]:_Detalhes:_Num_Model[1]:Text, oXML:_Cab_204:_Coleta[X]:_Detalhes:_Num_Model:Text	) ,;
									"" } )
			Else

				nPos := aScan( aDados , { |A| UPPER(A[1]) == UPPER(oXML:_Cab_204:_Coleta[X]:_Detalhes:_Num_Ped:TEXT) } )

				aDados[nPos][3] := xRetArray(oXML,X)

				aDados[nPos][5] 	:= oXML:_Cab_204:_Coleta[X]:_Seq_Parada:Text 

			EndIf

		EndIf

	Next X
	ASort(aDados, , , {|x,y|y[5] > x[5]})
	RestArea( aArea )

Return( aDados )

/*
Programa	: GEFCNHOTM
Funcao		: Static Fucntion xRetArray
Data		: 23/03/2016
Autor		: André Costa
Descricao	: Leitura dos Arquivos XML da CNH-OTM
Uso			: Programa de Leitura de XML da CNH-OTM
Sintaxe	: GEFLEROTM()
Retorno	: Array
Chamada	: GEFLEROTM
*/

Static Function xRetArray(oXML,X)
	Local aArea		:= GetArea()
	Local aRetorno	:= {}
	Local _nKm			:= 0

	If XMLCHILDEX(oXML:_Cab_204:_Coleta[X],"_NOTAS") <> Nil  // Kilometragem
		_nKm := GetDtoVal(oXML:_Cab_204:_Coleta[X]:_NOTAS:Text)
	EndIf

	If UPPER(oXML:_Cab_204:_Coleta[X]:_Seq_Razon:Text) $ "LD|PL"
		xIdText	:= oXML:_Cab_204:_Coleta[X]:_Id_Origem:Text
		xFechaText	:= oXML:_Cab_204:_Coleta[X]:_Fecha_Retirada:Text
	Else
		xIdText	:= oXML:_Cab_204:_Coleta[X]:_Id_Destino:Text
		xFechaText	:= oXML:_Cab_204:_Coleta[X]:_Fecha_Entrega:Text
	EndIf

	aRetorno := {	UPPER(xIdText)											,;
					oXML:_Cab_204:_Coleta[X]:_Seq_Parada:Text				,;
					oXML:_Cab_204:_Coleta[X]:_Seq_Razon:Text				,;
					oXML:_Cab_204:_Coleta[X]:_Peso:Text					,;
					oXML:_Cab_204:_Coleta[X]:_Um_Peso:Text					,;
					oXML:_Cab_204:_Coleta[X]:_Qty_Envio:Text				,;
					oXML:_Cab_204:_Coleta[X]:_Um_Qty_Envio:Text			,;
					oXML:_Cab_204:_Coleta[X]:_Volume:Text					,;
					oXML:_Cab_204:_Coleta[X]:_Um_Volume:Text				,;
					xFechaText													,;
					_nKm }

	RestArea( aArea )

Return( aRetorno )

/*/{Protheus.doc} 210CNHOTM
Função responsável por transmitir a interface210 com dados de Faturamento.
@author 	U297686 - Ricardo Guimarães
@since 		28/03/2016
@version 	1.0
@param 		_lAuto, ${param_type}, (Descrição do parâmetro)
@param 		_nPlanoId, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
/****************************************/
User Function 210CNHOTM(_lAuto, _nPlan)
/****************************************/
Local _aQuery 	:= {}
Local _aRet   	:= {}
Local _cNumAge	:= DF0->DF0_NUMAGE
Local _aArea 		:= GetArea()
Local TRAB      	:= GetNextAlias()
Local _dDtIni   	:= GetMV("ES_CNH210")
Local _cCNH		:= AllTrim(GETMV("ES_CGCDEV"))
Local _aMenNota 	:= {}
Local _aLog210  	:= {}
Local _cArqORIG 	:= ""
Local _cArq210  	:= GetNewPar("ES_ARQ210","CNH_210_")
LOCAL _nHandle 	:= 0
Local _aDF1		:= {}
Local _aSF2 		:= {}
Local _aLogCria 	:= Array(1,5)
Local _lRet		:= .T.
Local _nConta		:= 0
Local _nQtdNFe  	:= 0
Local _nQtdInfo 	:= 7
Local _aInfoAux 	:= Array(_nQtdInfo)
Local _nCntAux  	:= 0
Local _nPlanoId 	:= 0
Local _aInt210  	:= {}
Local _cDtEntreg	:= ""

DEFAULT _lAuto 	:= .F.

// --- Verifica se foi por rotina automaticaU

// Gravação do arquivo com a interface 210
_nHandle := FCREATE(_cArqOrig, FC_NORMAL)

_cCNH := " AND SUBSTRING(A1_CGC,1,8) IN" + FORMATIN(_cCNH,"/")
_cCNH += " AND F2_XCNH210 = '' "
_cCNH := "%"+_cCNH+"%"

BeginSql Alias TRAB

	// column ZA6_DTINI as Date, ZA7_VALOR  as Numeric(18,2), DATA_INI as Date

	%noparser%

	SELECT DISTINCT F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, A1_CGC, A1_NOME, F2_EMISSAO, C5_MENNOTA, C5_NOTA, C5_NUM,
	       F2_VALBRUT, F2_VALICM, F2_VALISS, SF2.R_E_C_N_O_ AS SF2_RECNO
		FROM %Table:SF2% SF2, %Table:SC5% SC5, %Table:SA1% SA1 // , %Table:DF0%  DF0
	   WHERE ( F2_EMISSAO    >= %Exp:_dDtIni%
	     AND F2_FILIAL 		= C5_FILIAL
	     AND F2_SERIE  		= C5_SERIE
	     AND F2_DOC    		= C5_NOTA
	     AND F2_CLIENTE 	= A1_COD
	     AND F2_LOJA    	= A1_LOJA
	     AND SF2.%NotDel%
	     AND SC5.%NotDel%
	     AND SA1.%NotDel% )
	     // AND DF0.%NotDel% )

	    %Exp:_cCNH%

EndSql

_aQuery := GetLastQuery()
// MEMOWRIT("C:\TEMP\GEFCNHOTM.SQL",_aQuery[2])

(TRAB)->( DbGoTop() )
If (TRAB)->(Eof())
	If _lAuto
		ConOut('Não há faturamento da CNH pendente de geração de interface 210')
	Else
		Aviso("Aviso - Interface 210",'Não há faturamento da CNH pendente de geração de interface 210',{"Ok"},1)
	EndIf
	RestArea(_aArea)

	If Select( (TRAB) ) # 0
		( TRAB )->( DbCloseArea() )
	EndIf
	Return Nil
EndIf

dbSelectArea("DF0") ; dbOrderNickName("PLANID")
dbSelectArea("DF1") ; dbSetOrder(1)
dbSelectArea(TRAB)

While !(TRAB)->(Eof())
	_nConta++

	_aMenNota := StrTOKArr((TRAB)->C5_MENNOTA,"/")

	//          1         2          3         4       5        6         7           8           9        10        11
	_aSF2 := {F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, A1_CGC, A1_NOME, F2_EMISSAO, F2_VALBRUT, F2_VALICM, F2_VALISS, A1_CGC}

	If Mod(Len(_aMenNota), _nQtdInfo) # 0  // 7 = Quantidade de INFO
/*
			Aviso("Aviso - Interface 210",'As informações informadas no campo Mens.Nota não estão no padrão INFO1/INFO2/INFO3/INFO4/INFO5/INFO6' + CRLF + CRLF +;
			      "RPS: " + ((TRAB)->C5_NOTA) + CRLF +;
			      " Mens.Nota " + AllTrim((TRAB)->C5_MENNOTA),{"Ok"},3)
*/
		AADD(_aLog210, { (TRAB)->C5_NOTA, (TRAB)->C5_NUM, "", (TRAB)->C5_MENNOTA, +;
		     "As informações informadas no campo Mens.Nota não estão no padrão INFO1/INFO2/INFO3/INFO4/INFO5/INFO6/INFO7" } )

		(TRAB)->(dbSkip())
		Loop
	EndIf

	dbSelectArea(TRAB)

	_nQtdNFe := Len(_aMenNota) / _nQtdInfo
	_nCntAux := 0
	_nPlanoId:= Val(_aMenNota[7])

	If DF0->(dbSeek(xFilial("DF0") + Str(_nPlanoId,9,0) )) // AllTrim(_aMenNota[_x * _nQtdInfo])))
		// Monto XML com dados da DFO

		dbSelectArea("DF1")
		If DF1->(dbSeek(xFilial("DF1") + DF0->DF0_NUMAGE))
			
			// Monto XML com dados da DFO
			/*-----------------------------------------------------------------------------------------------------------------------*/
			//				1			2			    3			   4			5		6			   7			8			9
			//			DUA_CODMOT, DUA_CODOCO, DUA_DATCHG, DUA_DATOCO, DUA_DOC, DUA_SERIE, DUA_HORCHG, DUA_HOROCO, DUA_NUMOCO
			_aInt210  := fOTM214OCO(.T.) // Pego informação da última ocorrência
			/*------------------------------------------------------------------------------------------------------------------------*/

			If Len(_aInt210) = 0
				AADD(_aLog210, { (TRAB)->C5_NOTA, (TRAB)->C5_NUM, cValToChar(_nPlanoId), (TRAB)->C5_MENNOTA ,+;
				     "Plano sem Ocorrência" } )
				(TRAB)->(dbSkip())     
				Loop
			EndIf
				
			// Por: Ricardo Guimarães - Em: 07/06/2016 - Valter solicitou para trocar de campo
			//_cDtEntreg := _aInt210[1,3] + _aInt210[1,7]
			_cDtEntreg	:= _aInt210[1,4] // + _aInt210[1,8]
			_aDF1 		:= {}

			While !DF1->(Eof()) .AND. DF1->DF1_NUMAGE == DF0->DF0_NUMAGE

				AADD(_aDF1, { DF1->DF1_NUMAGE, DF1->DF1_ITEAGE, DF1->DF1_NUMPUR } )
				DF1->(dbSkip())
			End

			If Len(_aDF1) > 0
				// Gero o arquivo de interface 210
				_aInfoAux[1] := _aMenNota[++_nCntAux]
				_aInfoAux[2] := _aMenNota[++_nCntAux]
				_aInfoAux[3] := _aMenNota[++_nCntAux]
				_aInfoAux[4] := _aMenNota[++_nCntAux]
				_aInfoAux[5] := _aMenNota[++_nCntAux]
				_aInfoAux[6] := _aMenNota[++_nCntAux]
				_aInfoAux[7] := _aMenNota[++_nCntAux]

				For _x := 1 TO _nQtdNFe // Len(_aMenNota)

					If fGerInt210(_aInfoAux,_aDF1,_aSF2, _cDtEntreg, _x)

						// Grava Status
						dbSelectArea("SF2")
						SF2->(dbGoTo((TRAB)->SF2_RECNO))
						RecLock('SF2',.F.)
							SF2->F2_XCNH210 := dDATABASE
						MsUnLock()
						dbSelectArea((TRAB))

						// Grava Log
						aAdd( _aLog, { _nPlanoId, "001", _cInterface210, dDataBase, Time() ,'Interface de Faturamento', 'Geração de interface de faturamento - 210!', UsrRetName(RetCodUsr()),'1' } )
						// ---	Grava log do processo de trasmissão da interface214
						INTCNHGLOG(_aLog)
					EndIf
				EndFor _x
			EndIf
		EndIf
	Else
		AADD(_aLog210, { (TRAB)->C5_NOTA, (TRAB)->C5_NUM, cValToChar(_nPlanoId), AllTrim((TRAB)->C5_MENNOTA), "Plano não localizado no Agendamento"  } )			
	EndIf
	(TRAB)->(dbSkip())
End

If Select( (TRAB) ) # 0
	( TRAB )->( DbCloseArea() )
EndIf

If Len(_aLog210) > 0
	fEnvLog210(_aLog210)
EndIf

If _nConta > 0
	If _lAuto
		ConOut('Foram processado(s) ' + Strzero(_nConta,4) + ' RPS(s).')
	Else		
		Aviso("Aviso - Interface 210",'Foram processado(s) ' + Strzero(_nConta,4) + ' RPS(s).',{"Ok"},1)
	EndIf	
EndIf

RestArea(_aArea)
Return _aRet

/*/{Protheus.doc} fEnvAltPlano
//TODO  Função usada para enviar e-mail para os usuários informado em ES_CNHEML, com a lista dos RPS com informações inconsitentes no campo C5_MENNOTA
@author u297686 - Ricardo Guimarães
@since 31/03/2016
@version 1.0
@param
@type function
/*/
Static Function fEnvLog210(_aLog210)
Local _cAssunto := ""
Local _cMsg		:= ""
Local _nN		:= 0

//_cMsg 		:= "Plano " + Str(_nPlanoId) + " foi ALTERADO em " + DtoC(dDATABASE) + " " + Time()

_cMsg := '<HTML>' + CRLF
_cMsg += '<H1>'   + "RPS´s não enviadas na interface 210. Gerado em " + DtoC(dDATABASE) + " " + Time() + '</H1>' + CRLF
// <H2>TESTE</H1>
_cMsg += '<TABLE border="2">' 	+ CRLF
_cMsg += '	<th>RPS</th>' 		+ CRLF
_cMsg += '	<th>Pedido</th>' 	+ CRLF
_cMsg += '	<th>Plano</th>' 	+ CRLF
_cMsg += '	<th>Mensagem</th>' 	+ CRLF
_cMsg += '	<th>Msg.Compl.</th>'+ CRLF

For _nN := 1 to Len(_aLog210)
	_cMsg += '	<tr>' + CRLF
	_cMsg += '		<td>' + cValtoChar(_aLog210[_nN,1]) + '</td>' + CRLF
	_cMsg += '		<td>' + cValtoChar(_aLog210[_nN,2]) + '</td>' + CRLF
	_cMsg += '		<td>' + cValtoChar(_aLog210[_nN,3]) + '</td>' + CRLF
	_cMsg += '		<td>' + cValtoChar(_aLog210[_nN,4]) + '</td>' + CRLF
	_cMsg += '		<td>' + cValtoChar(_aLog210[_nN,5]) + '</td>' + CRLF
	_cMsg += '	</tr>' + CRLF
Next _nN

_cMsg += '</TABLE>' + CRLF
_cMsg += '</HTML>' + CRLF

// Envia e-mail
_cAssunto 	:= "RPS´s que não foram enviadas na interface - " + _cInterface210

U_EnvEmail(GETMV("MV_RELFROM"),GETMV("ES_CNHEML"),,_cAssunto,_cMsg)

Return Nil

/*/{Protheus.doc} fGerInt210
//TODO  Função usada gerar o arquivo de inteface 210
@author u297686 - Ricardo Guimarães
@since 05/04/2016
@version 1.0
@param
@type function
/*/

Static Function fGerInt210(_aInfo, _aDF1, _aSF2, _cDtEntreg, _nLin)
Local _cNumAge	:= _aDF1[1/*_nLin*/,1] // DF0->DF0_NUMAGE
Local _cArqORIG 	:= ""
Local _cArq210  	:= GetNewPar("ES_ARQ210","CNH_210_")
LOCAL _nHandle 	:= 0
Local _cXML		:= ""
Local _lRet		:= .T.
Local _nPlanoId 	:= Val(_aInfo[7]) // DF0->DF0_PLANID
Local _aInt210  	:= {}
//Local _cDtEntreg:= ""

//              1         2          3         4       5        6         7           8           9        10
// _aSF2 := {F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, A1_CGC, A1_NOME, F2_EMISSAO, F2_VALBRUT, F2_VALICM, F2_VAISS}

// ---	Prepara XML para envio
_cXML	:=	'<?xml version="1.0" encoding="UTF-8"?>'
_cXML	+=	'<CAB_210 xmlns:xsd="http://www.w3.org/2001/XMLSchema">'
_cXML	+=	'	<NUM_FAT_TRANSPORTISTA>'+ AllTrim(_aSF2[2]+_aSF2[1]) + '</NUM_FAT_TRANSPORTISTA>'
_cXML	+=	'	<ID_EMB>'   			+ AllTrim(cValtoChar(_nPlanoId)) + '</ID_EMB>'
_cXML	+=	'	<MET_PAGO>' 			+ 'TP' 					+ '</MET_PAGO>'
_cXML	+=	'	<DT_FAT_TRANSPORTISTA>' + SubStr(_aSF2[07],1,4) + '-' + SubStr(_aSF2[07],5,2) + '-' + SubStr(_aSF2[07],7,2) + 'T00:00' + '</DT_FAT_TRANSPORTISTA>'
//_cXML	+=	'	<VL_FAT_TRANSPORTISTA>' + StrTran(StrTran(AllTrim(TransForm(_aSF2[08], "@R 999999999.99")),',','.'),'.','') + '</VL_FAT_TRANSPORTISTA>'
_cXML	+=	'	<VL_FAT_TRANSPORTISTA>' + AllTrim(StrTran(TransForm(_aSF2[08], "@R 999999999.99"),",","")) + '</VL_FAT_TRANSPORTISTA>'
//_cXML	+=	'	<TIPO_FAT>'    			+ '' 					+ '</TIPO_FAT>'
_cXML	+=	'	<DT_ENTREGA>'  			+ _cDtEntreg 			+ '</DT_ENTREGA>'
_cXML	+=	'	<COD_CAR>'    			+ AllTrim(GETMV("ES_SERVPRV")) + '</COD_CAR>' // AllTrim(DF0->DF0_TRANSP)
_cXML	+=	'	<MOEDA>'      			+ 'BRL' 				+ '</MOEDA>'
_cXML	+=	'	<NUM_FAT_FORNECEDOR>'  	+ AllTrim(_aInfo[01])   + '</NUM_FAT_FORNECEDOR>'
_cXML	+=	'	<VL_FAT_FORNECEDOR>'  	+ AllTrim(StrTran(_aInfo[03],',','')) + '</VL_FAT_FORNECEDOR>'
_cXML	+=	'	<VL_MAT>'	      		+ AllTrim(StrTran(StrTran(TransForm(_aInfo[04], "@R 999999999.99"),',','.'),'.','')) + '</VL_MAT>'
_cXML	+=	'	<ID_TRANS>'     		+ GetAdvFVal('SM0','M0_CGC','01'+_aSF2[05],1,'CGC NAO LOCALIZADO')  + '</ID_TRANS>'
_cXML	+=	'	<ID_PLANTA>'    		+ cValToChar(_aSF2[11]) + '</ID_PLANTA>'
//_cXML	+=	'	<NUM_CHASSI>'    		+ '' 					+ '</NUM_CHASSI>'
_cXML	+=	'	<ID_ORDEM_LIB>'    		+ AllTrim(_aDF1[1/*_nLin*/][3]) 	+ '</ID_ORDEM_LIB>'
_cXML	+=	'	<CFOP>'    				+ cValToChar(_aInfo[05])+ '</CFOP>'
_cXML	+=	'	<PERC_IRRF>'    		+ cValToChar(_aInfo[06])+ '</PERC_IRRF>'
_cXML	+=	'	<DT_RETIRADA>'    		+ _cDtEntreg            + '</DT_RETIRADA>'
/*
_cXML	+=	'	<OBS>'     + '' 		+ '</OBS>'
_cXML	+=	'	<OBS1>'    + '' 		+ '</OBS1>'
_cXML	+=	'	<OBS2>'    + '' 		+ '</OBS2>'
_cXML	+=	'	<OBS3>'    + '' 		+ '</OBS3>'
_cXML	+=	'	<OBS4>'    + '' 		+ '</OBS4>'
_cXML	+=	'	<OBS5>'    + '' 		+ '</OBS5>'
_cXML	+=	'	<OBS6>'    + '' 		+ '</OBS6>'
_cXML	+=	'	<OBS7>'    + '' 		+ '</OBS7>'
_cXML	+=	'	<OBS8>'    + '' 		+ '</OBS8>'
_cXML	+=	'	<OBS9>'    + '' 		+ '</OBS9>'
*/
_cXML	+=	'	<DETALHES>'
_cXML	+=	'		<SEQ_EMB>'  + _aDF1[1/*_nLin*/][2] + '</SEQ_EMB>'
_cXML	+=	'		<VL_FRETE>' + StrTran(AllTrim(Transform(_aSF2[08], "@R 999999999.99")),',','.') + '</VL_FRETE>'
_cXML	+=	'		<VL_ICMS>'  + StrTran(AllTrim(Transform(_aSF2[09], "@R 999999999.99")),',','.') + '</VL_ICMS>'
_cXML	+=	'		<VL_ISS>'   + StrTran(AllTrim(Transform(_aSF2[10], "@R 999999999.99")),',','.') + '</VL_ISS>'
_cXML	+=	'		<VL_PEDAGIO>' + '0' + '</VL_PEDAGIO>'
_cXML	+=	'		<VL_SEGURO>'  + '0' + '</VL_SEGURO>'
_cXML	+=	'		<VL_ESCOLTA>' + '0' + '</VL_ESCOLTA>'
_cXML	+=	'		<VL_ICMSST>'  + '0' + '</VL_ICMSST>'
_cXML	+=	'	</DETALHES> '
_cXML	+=	'</CAB_210>'

// XML com error, não processa e move para a pasta backup
MONTADIR(cPATH210)
_cArqORIG := cPATH210 + AllTrim(_cArq210) + AllTrim(Str(_nPlanoId)) + "-" + DTOS(dDATABASE) + "-" + AllTrim(StrTran(Time(),":","")) + ".xml"

// Gravação do arquivo com a interface 990
_nHandle := FCREATE(_cArqOrig, FC_NORMAL)
If _nHandle == -1
	If _lAuto
		ConOut("Não foi possível a criação do Arquivo :" + STR(FERROR()))
	Else
		MsgAlert("Não foi possível a criação do Arquivo :" + STR(FERROR()))
	EndIf
	
	// --- Grava log e define status de gravacao do plano
	aAdd( _aLog, { _nPlanoId, "001", _cInterface210, dDataBase, Time() ,'Interface de Faturamento', 'Não foi possível geração do arquivo - 210!', UsrRetName(RetCodUsr()),'1' } )

    _lRet := .F.

Else
    FWRITE(_nHandle, _cXML)
    FCLOSE(_nHandle)

	// --- Grava log e define status de gravacao do plano
	aAdd( _aLog, { _nPlanoId, "001", _cInterface210, dDataBase, Time() ,'Interface de Faturamento', 'Geração de interface de faturamento - 210!', UsrRetName(RetCodUsr()),'1' } )
    _lRet := .T.

EndIf

// ---	Grava log do processo de trasmissão da interface214
INTCNHGLOG(_aLog)

Return( _lRet)

/*/{Protheus.doc} CNH214A
Exibe tela para receber dados da interface214.
@author	Luiz Alexandre Ferreira / Ricardo Guimarães
@since 		11/04/2016
@version 	1.0
@param 		_aRet, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function CNH214A(_aRet)

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

oDlg	:= MSDialog():New(0,0,200,550,OemToAnsi('Execução de plano '+_cInterface214),,,,,CLR_BLACK,CLR_WHITE,,,.t.)

// ---	Define fontes para mensagens
oFont	:= TFont():New('Tahoma',,-16,.T.)
oFont1	:= TFont():New('Tahoma',,-11,.T.)

// --- Apresenta o tSay com a fonte Courier New
oSay	:= TSay():New( 005, 010, {|| OemToAnsi('Execução de plano de transporte '+_cInterface214) },oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay:lTransparent:= .F.
oSay1	:= TSay():New( 025, 010, {|| OemToAnsi('Motivo do tracking:')},oDlg,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay1:lTransparent:= .F.
oSay2	:= TSay():New( 045, 010, {|| OemToAnsi('Responsavel Canc. :')},oDlg,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay2:lTransparent:= .F.
oSay3	:= TSay():New( 065, 010, {|| OemToAnsi('Observação Canc.  :')},oDlg,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay3:lTransparent:= .F.

// ---
@ 020,065 MSGET _cMotivo	SIZE 20, 9 OF oDlg PIXEL F3 'ZX' VALID ExistCpo('SX5','ZX'+_cMotivo)
oSay4	:= TSay():New( 022, 095, {|| CNHOTM301B('ZX'+_cMotivo,@_cMotivo) },oDlg,,oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
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

/*/{Protheus.doc} CNHINT301B
Função responsável por retornar a descrição de variavel informada conforme cadastro de tabela generica.
@author 	U297686 - Ricardo Guimarães
@since 		11/04/2016
@version 	1.0
@param 		_cParam, ${param_type}, (Descrição do parâmetro)
@param 		_cMotivo, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function CNHOTM301B(_cParam,_cMotivo)
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

/*
Programa	: GEFXMLROB
Funcao		: Função Estatica - xSchedule
Data		: 03/08/2015
Autor		: André Costa
Descricao	: Função de Apoio
Uso			: Verifica se a rotina esta esta rodando por Schedule ou via IDE
Sintaxe	: xSchedule()
Retorno	: Logico Verdadeiro / Falso
*/

Static Function xSchedule
	Local aArea		:= GetArea()
	Local lRetorno	:= .F.

	Begin Sequence

		If ( Type( "__cInternet" ) == "U" )

			If Select("SX6") == 0
				lRetorno := .T.
				Break
			EndIf

			If __cInternet == "AUTOMATICO"
				lRetorno := .T.
				Break
			EndIf

		EndIf

	End Sequence

	RestArea( aArea )

Return( lRetorno )


/*/{Protheus.doc} fBuscaSrvOp
Função responsável por retornar o Tipo de Serviço e a Operação.
@author 	U297686 - Ricardo Guimarães
@since 		23/06/2016
@version 	1.0
@param 		_aOrigem, ${param_type}, (Descrição do parâmetro)
@param 		_aDestino, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fBuscaSrvOp(_aColeta, _aOrigem, _aDestino)
Local _nKm 		:= _aColeta[2][11]
Local _nKmRaio	:= GetNewPar("ES_OTMKM", 125)
Local _cLocRolOri	:= AllTrim(_aOrigem[8]) 
Local _cLocRolDes	:= AllTrim(_aDestino[8])
Local _cPlantaOri	:= _aOrigem[9] 
Local _cPlantaOri	:= _aDestino[9]
Local _cFornec	:= GetNewPar("ES_OTMFOR" , "SUPPLIER")
Local _cPlanta	:= GetNewPar("ES_OTMPLAN", "PLANT")
Local _cCDC		:= GetNewPar("ES_OTMDOCK", "XDOCK")
Local _cCarrier	:= GetNewPar("ES_OTMCARR", "CARRIER")
Local _aServ		:= {"273","274","275","276","277"} // Tabela: L4(SX5)
Local _aServ_OP	:= {"",""}

If _cLocRolOri = _cFornec .and. _cLocRolDes = _cCDC		 
	If _nKm <= _nKmRaio // Coleta dentro do Raio --> DESC. SERVIÇO   
               
		_aServ_OP[1] := _aServ[1] 	//  Serviço é 273 --> DF1_SERVIC
       _aServ_OP[2] := "LTL" 		//  Tipo de Operação é LTL --> DF0_DESOPE.
    Else
		_aServ_OP[1] := _aServ[2] 	//  Serviço é 274 --> DF1_SERVIC
       _aServ_OP[2] := "LTL" 		//  Tipo de Operação é LTL --> D       
    EndIf   

ElseIf _cLocRolOri = _cFornec .and. _cLocRolDes = _cPlanta		 
	If _nKm <= _nKmRaio // Coleta dentro do Raio --> DESC. SERVIÇO   
               
		_aServ_OP[1] := _aServ[3] 	//  Serviço é 275 --> DF1_SERVIC
       _aServ_OP[2] := "FTL" 		//  Tipo de Operação é FTL --> DF0_DESOPE.
    Else
		_aServ_OP[1] := _aServ[4] 	//  Serviço é 276 --> DF1_SERVIC
       _aServ_OP[2] := "FTL" 		//  Tipo de Operação é FTL --> DF0_DESOPE.       
    EndIf   
ElseIf _cLocRolOri = _cCDC .and. _cLocRolDes = _cPlanta		 
	If _nKm <= _nKmRaio // Coleta dentro do Raio --> DESC. SERVIÇO   
               
		_aServ_OP[1] := _aServ[3] 	//  Serviço é 275 --> DF1_SERVIC
       _aServ_OP[2] := "FTL" 		//  Tipo de Operação é FTL --> DF0_DESOPE.
    Else
		_aServ_OP[1] := _aServ[4] 	//  Serviço é 276 --> DF1_SERVIC
       _aServ_OP[2] := "FTL" 		//  Tipo de Operação é FTL --> DF0_DESOPE.       
    EndIf    
ElseIf _cLocRolOri = _cCDC .and. _cLocRolDes = _cFornec		 
	If _nKm <= _nKmRaio // Coleta dentro do Raio --> DESC. SERVIÇO   
               
		_aServ_OP[1] := _aServ[3] 	//  Serviço é 275 --> DF1_SERVIC
       _aServ_OP[2] := "FTL" 		//  Tipo de Operação é FTL --> DF0_DESOPE.
    Else
		_aServ_OP[1] := _aServ[4] 	//  Serviço é 276 --> DF1_SERVIC
       _aServ_OP[2] := "FTL" 		//  Tipo de Operação é FTL --> DF0_DESOPE.       
    EndIf    
ElseIf _cLocRolOri = _cPlanta .and. _cLocRolDes = _cCDC		 
	If _nKm <= _nKmRaio // Coleta dentro do Raio --> DESC. SERVIÇO   
               
		_aServ_OP[1] := _aServ[1] 	//  Serviço é 273 --> DF1_SERVIC
       _aServ_OP[2] := "LTL" 		//  Tipo de Operação é LTL --> DF0_DESOPE.
    Else
		_aServ_OP[1] := _aServ[2] 	//  Serviço é 274 --> DF1_SERVIC
       _aServ_OP[2] := "LTL" 		//  Tipo de Operação é FTL --> DF0_DESOPE.       
    EndIf
ElseIf _cLocRolOri = _cPlanta .and. _cLocRolDes = _cFornec		 
	If _nKm <= _nKmRaio // Coleta dentro do Raio --> DESC. SERVIÇO   
               
		_aServ_OP[1] := _aServ[3] 	//  Serviço é 275 --> DF1_SERVIC
       _aServ_OP[2] := "FTL" 		//  Tipo de Operação é FTL --> DF0_DESOPE.
    Else
		_aServ_OP[1] := _aServ[4] 	//  Serviço é 276 --> DF1_SERVIC
       _aServ_OP[2] := "FTL" 		//  Tipo de Operação é FTL --> DF0_DESOPE.       
    EndIf
ElseIf _cLocRolOri = _cPlanta .and. _cLocRolDes = _cPlanta		 
		_aServ_OP[1] := _aServ[5] 			//  Serviço é 277 --> DF1_SERVIC
       _aServ_OP[2] := "TRANSFERENCIA" 	//  Tipo de Operação é TRANSFERENCIA --> DF0_DESOPE.
Else       
		_aServ_OP[1] := ''
       _aServ_OP[2] := ''    	  
EndIf
 
Return( _aServ_OP ) 


/*----------------------------------------------------------*
* Conta quantidade de Item a ser gravado na tabela DF1,    *
* para dividir o KM vindo no XML                           *
*----------------------------------------------------------*/
Static Function fContaItem(_aColeta)
Local _nItens 	:= 0
Local _cCliOri 	:= ''
Local _cCliDest	:= ''
Local _nX			:= 0

For _nX	:= 1 to Len(_aColeta)  // _nItens // STEP 2 No XML( TAG COLETA ) vem sem sempre dois reistros(ORIGEM e DESTINO) e gerará um registro no DF1
	// --- Inclui registro de itens do agendamento
	If _cCliOri <> AllTrim(_aColeta[_nX][2][1]) .OR. _cCliDest <> AllTrim(_aColeta[_nX][3][1])

		_cCliOri := AllTrim(_aColeta[_nX][2][1])
		_cCliDest:= AllTrim(_aColeta[_nX][3][1])
		
		
		_nItens++		
	EndIf
Next _nX
	
Return( IIF(Empty(_nItens)	,1,_nItens) )
			