#include 'TOTVS.CH'

#DEFINE _cinterface201	'WS Interface201'

User Function TM350GRV

//-------------------------------------------------------------------------------------------------
/* {2LGI} TM350GRV
@autor		: Luiz Alexandre
@descricao	: Ponto de entrada no apontamento da operacao de saida de viagem.
@since		: Ago./2014
@using		: Interface CNH - Metodo interface201
@review		:
*/
//-------------------------------------------------------------------------------------------------
// ---	Variaveis utilizadas
//Local _aParam	:= 	ParamIxb[3]
Local _aAreaDTQ	:= 	DTQ->(GetArea())
Local _aAreaDTW	:= 	DTW->(GetArea())
Local _aAreaDUP	:= 	DUP->(GetArea())
Local _aAreaDT6	:= 	DT6->(GetArea())
Local _aArea	:= 	GetArea()
Local _cPlaca	:= 	''
Local _cNomeMot	:= 	''
Local _nAnoVei	:= 	0
Local _nPos		:= 	0
Local _aPlanos	:= 	{}
Local _lRet		:=	.t.
                        
// ---	Se opcao de inclusao
If ParamIxb[3] == 3
	
	// ---	Se atividade de saida
	If DTW->DTW_ATIVID == '049'
		
		DTR->(dbSetOrder(1))
		DTR->(dbSeek(xFilial('DTR')+ParamIxb[1]+ParamIxb[2]))
		
		// --- Localiza dados da viagem para transmissao
		_cPlaca		:=	GetAdvFVal('DA3','DA3_PLACA',xFilial('DA3')+DTR->DTR_CODVEI,1,'')
		_cAnoVei	:=	GetAdvFVal('DA3','DA3_ANOFAB',xFilial('DA3')+DTR->DTR_CODVEI,1,'')
		
		// ---	Motorista da viagem
		DUP->(dbSetOrder(1))
		DUP->(dbSeek(xFilial('DUP')+DTR->DTR_FILORI+DTR->DTR_VIAGEM))
		_cNomeMot	:=	GetAdvFVal('DA4','DA4_NOME',xFilial('DA4')+DUP->DUP_CODMOT,1,'')
		
		// ---	Verifica se um dos conteudos esta vazio
		If Empty(_cPlaca) .or. Empty(_cAnoVei) .or. Empty(_cNomeMot)
			// ---	Mensagem de alerta.
			Alert('Campo vazio para envio, verifique : Placa '+_cPlaca+' Ano Fab : '+_cAnoVei+' Nome Motorista : '+_cNomeMot )
			Return
		EndIf
		
		
		// --- Pode ser que na mesma viagem exista mais de uma plano de transporte/agendamento
		DUD->(dbSetOrder(2))
		DUD->(dbSeek(xFilial('DUD')+DTQ->DTQ_FILORI+DTQ->DTQ_VIAGEM))
		While DUD->( !Eof() ) .and. DUD->DUD_FILIAL == DTQ->DTQ_FILIAL .and. DUD->DUD_FILORI == DTQ->DTQ_FILORI .and. DUD->DUD_VIAGEM == DTQ->DTQ_VIAGEM
			
			// ---	Localiza documento de transporte e coleta o agendamento
			DT6->(dbSetOrder(1))
			DT6->(dbSeek(xFilial('DT6')+DUD->DUD_FILDOC+DUD->DUD_DOC+DUD->DUD_SERIE))
			
			// ---	Busca o agendamento e obtem o plano de transporte
			_nPlanoId	:= GetAdvFVal('DF0','DF0_PLANID',xFilial('DF0')+DT6->DT6_NUMAGD,1,"")
			
			// --- 	Se nao localizou acrescenta na array para transferir
			_nPos	:= Ascan( _aPlanos, { |x| x == _nPlanoId } )
			
			// ---  Somente transmite se encontrar plano de transporte
			If _nPos  == 0 .and. _nPlanoId > 0
				Aadd( _aPlanos, _nPlanoId )
			EndIf
			
			// ---	Proximo registro
			DUD->(dbSkip())
			
		EndDo
		
	EndIf
	
	// ---	Transferir os planos
	If Len(_aPlanos) > 0
		
		For _nPos	:= 1 to Len(_aPlanos)
			
			// ---	Mensagem de interface com o usuario
			MsgRun(OemToAnsi('Informando dados do veículo plano '+AllTrim(Str(_aPlanos[_nPos]))+'...Aguarde!'  ), _cinterface201 , { || U_CNHINT201(_aPlanos[_nPos],_cPlaca,_cNomeMot,_cAnoVei,.f.) } )
			
			// ---	Chamada da interface que atualiza o status do plano de transporte.
			// ---	Interface701
			_lRet	:=	U_CNHINT701(_aPlanos[_nPos],.t.)
			
		Next _nX
		
	EndIf
	
EndIf

// ---	Restaura areas
RestArea(_aArea)
RestArea(_aAreaDT6)
RestArea(_aAreaDTW)
RestArea(_aAreaDUP)
RestArea(_aAreaDTQ)
	
Return

