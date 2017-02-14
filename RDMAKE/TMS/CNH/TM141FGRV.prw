#Include 'Protheus.ch'
#Include 'Totvs.ch'

/*/{Protheus.doc} TM141FGRV
Ponto de entrada utilizado no final da gravação da viagem de coleta / entrega.
@author 	Luiz Alexandre Ferreira
@since 		16/10/2014
@version 	1.0
@param 		ParamIxb, ${Array}, Array contendo 	[1]-Opcao, [2]-lRet
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function TM141FGRV()


// ---	Variaveis utilizadas
// ---	Na versao do programa ainda não exisitia o parametro passado na chamada do PE.
//Local	_nOpcao	:=	ParamIxb[1]
//Local	_lOk		:=	ParamIxb[2]
Local	_cOldFun	:=	FunName()
Local	_lRet141	:=	.f.
Local	_lRet350	:=	.f.
Local	_nOpc350	:=	3
Local	_cAtivSai	:= 	SuperGetMV('MV_ATIVSAI',,'')
Local	_cFilOri	:=	DTQ->DTQ_FILORI
Local	_cViagem	:=	DTQ->DTQ_VIAGEM
Local	_cHora		:=	StrTran(Left(Time(),5),":","")
Local	_aAreaDTW	:=	DTW->(GetArea())
Local	_aAreaDTQ	:=	DTQ->(GetArea())
Local	_aArea		:=	GetArea()

// ---	Somente Coleta / Transporte
If cSerTMS	== '1' .and.	cTipTra == '1'
	
	// ---	Somente inclusao ou alteracao
	If Inclui .or. Altera
		
		// ---	Define a rotina
		SetFunName('TMSA310')
		
		// ---	Chamada da rotina de fechamento da viagem
		_lRet141	:=	TMSA310Mnt('DTQ', DTQ->(Recno()), 3, , .f.)
		
		// ---	Se houve problema no fechamento da viagem
		If ! _lRet141
			MsgStop('Problema no fechamento automático da viagem, contate suporte!','Fechar Viagem ')
		EndIf
		
		// ---	Apontamento da operação de saída
		// ---	Se fechamento foi processado com sucesso.
		If _lRet141
			
			// ---	Defini função de apontamento de operações
			SetFunName('TMSA350')
			
			// ---	Posiciona DTW
			DTW->(dbSetOrder(1))
			DTW->(dbSeek(xFilial('DTW')+DTQ->DTQ_FILORI+DTQ->DTQ_VIAGEM) )
			
			// ---	Chamada da rotina de gravação do apontamento da operação de saída
			_lRet350	:=	TMSA350Grv(_nOpc350, _cFilOri, _cViagem, _cAtivSai, dDataBase, _cHora, dDataBase, _cHora,,,)
			
			// ---	Se houve problema na gravação da operação de saída
			If ! _lRet350
				MsgStop('Problema no fechamento automático da viagem, contate suporte!','Fechar Viagem ')
			EndIf
			
			// ---	Retorna função para viagem modelo 2
			SetFunName('TMSA310')
			
		EndIf
		
		
	EndIf
	
EndIf

// ---	Retorna a função anterior.
SetFunName(_cOldFun)

// ---	Restaura area
RestArea(_aArea)
RestArea(_aAreaDTQ)
RestArea(_aAreaDTW)

Return