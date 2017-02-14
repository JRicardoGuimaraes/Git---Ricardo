#Include 'Protheus.ch'
#Include 'XMLXFun.ch'

#Define nNFEMARCA	01
#Define nNFECHAVE	02
#Define nNFEDOC    	03
#Define nNFESERIE  	04

/*/{Protheus.doc} GEFCNHLOT
Exibe tela para o usuário informar as notas fiscais eletrônicas associadas ao plano
de transporte e/ou a solicitação de transporte.
@author 	Luiz Alexandre Ferreira
@since 		04/11/2014
@version 	1.0
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function GEFCNHLOT()

Local 	_cAlias		:=	'TRB'
Local 	_aCores 		:=	{}
Local 	_cFiltra 		:= 	''
Local	_cArqTrab		:= 	''
Local	_aStru			:= 	{}
Local 	_aFields		:=	{}
Local	_cOldFun		:= 	FunName()
Private aRotina		:= 	{}
Private _cCadastro 	:= 	OemToAnsi('Digitação de lote a partir da Solicitação de Coleta')
Private _aIndex	 	:= {}
Private _bFiltraBrw	:= { || FilBrowse(_cAlias,@_aIndex,@_cFiltra) }

// ---	Define a função em execução
SetFunName('GEFCNHLOT')

// ---	Campos que serão exibidos no browse.
AADD(_aFields,	{ 'Plano transp'	,'PLANID' 	, 'N', TamSx3('DF0_PLANID')[1]	, 0, '@E 999,999,999'}	)
AADD(_aFields,	{ 'Fil Docto'		,'FILDOC'	, 'C', TamSx3('DT6_FILDOC')[1]	, 0}	)
AADD(_aFields,	{ 'Documento'		,'DOC'		, 'C', TamSx3('DT6_DOC')[1]		, 0}	)
AADD(_aFields,	{ 'Serie'			,'SERIE' 	, 'C', TamSx3('DT6_SERIE')[1]	, 0}	)
AADD(_aFields,	{ 'Remetente'		,'CLIREM'	, 'C', TamSx3('A1_NOME')[1]		, 0}	)
AADD(_aFields,	{ 'Destinatário'	,'CLIDES'	, 'C', TamSx3('A1_NOME')[1]		, 0}	)

// ---	Estrutura fisica do arquivo
AADD(_aStru,	{ 'LEG' 		, 'C', 1, 0}	)
AADD(_aStru,	{ 'PLANID' 	, 'N', TamSx3('DF0_PLANID')[1]	, 0}	)
AADD(_aStru,	{ 'FILDOC' 	, 'C', TamSx3('DT6_FILDOC')[1]	, 0}	)
AADD(_aStru,	{ 'DOC'		, 'C', TamSx3('DT6_DOC')[1]		, 0}	)
AADD(_aStru,	{ 'SERIE' 		, 'C', TamSx3('DT6_SERIE')[1]	, 0}	)
AADD(_aStru,	{ 'CLIREM'		, 'C', TamSx3('A1_NOME')[1]		, 0}	)
AADD(_aStru,	{ 'CLIDES'		, 'C', TamSx3('A1_NOME')[1]		, 0}	)
AADD(_aStru,	{ 'NUMAGE'		, 'C', TamSx3('DF1_NUMAGE')[1]	, 0}	)
AADD(_aStru,	{ 'ITEAGE'		, 'C', TamSx3('DF1_ITEAGE')[1]	, 0}	)

// ---	Cria arquivo de trabalho
_cArqTrab := CriaTrab(_aStru, .t.)

// ---	Abre o arquivo
USE &_cArqTrab ALIAS 'TRB' NEW

// ---	Localiza as solicitações geradas para o plano de transporte
DF1->(dbSetOrder(1))
DF1->(dbSeek(xFilial('DF1')+DF0->DF0_NUMAGE))
While DF1->( ! Eof() ) .and. DF0->DF0_NUMAGE == DF1->DF1_NUMAGE
	
	// ---	Existe solicitação de coleta gerada
	If ! Empty(DF1->DF1_FILDOC+DF1->DF1_DOC+DF1->DF1_SERIE)
		
		// ---	Inclui registro novo
		RecLock('TRB',.t.)
		TRB->FILDOC	:= 	DF1->DF1_FILDOC
		TRB->DOC		:= 	DF1->DF1_DOC
		TRB->SERIE		:=	DF1->DF1_SERIE
		TRB->CLIREM	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DF1->DF1_CLIREM+DF1->DF1_LOJREM,1,'' )
		TRB->CLIDES	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DF1->DF1_CLIDES+DF1->DF1_LOJDES,1,'' )
		TRB->PLANID	:=	DF0->DF0_PLANID
		TRB->NUMAGE	:=	DF1->DF1_NUMAGE
		TRB->ITEAGE	:=	DF1->DF1_ITEAGE
		TRB->LEG		:=	Iif ( GetAdvFVal('DT5','DT5_STATUS',xFilial('DT5')+DF1->DF1_FILDOC+DF1->DF1_DOC+DF1->DF1_SERIE,4,'') >= '4', '1','')
		
		// ---	Verifica se a solicitação já foi informada em um lote
		TRB->(msUnLock())
		
	EndIf
	
	// ---	Próximo registro
	DF1->(dbSkip())
	
EndDo

// ---	Adiciona rotinas no menu
AADD(aRotina,{"Digitar Lote" 	,"U_CNHADM03()",0,3})
AADD(aRotina,{"Legenda" 		,"U_BLegenda" ,0,3})

// ---	Define cores da legenda
AADD(_aCores,{"Empty(TRB->LEG)" 	,"BR_VERDE"	 })
AADD(_aCores,{"!Empty(TRB->LEG)" 	,"BR_VERMELHO" })

// ---	Seleciona area de trabalho
dbSelectArea(_cAlias)
dbGoTop()

// ---	Monta browse
mBrowse(6,1,22,75,_cAlias,_aFields,'LEG',,,,_aCores)

// ---	Fecha area de trabalho
dbCloseArea(_cAlias)


Return Nil


/*/{Protheus.doc} CNHADM03
Executa a chamada da rotina de inclusão de lote de nota fiscal de cliente.
@author 	Luiz Alexandre Ferreira
@since 		04/11/2014
@version 	1.0
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function CNHADM03()

// ---	Variaveis locais
Private cOldFun	:= FunName()

// ---	Define a função
SetFunName('TMSA050')

// ---	Executa a chamada da função de inclusão de nota fiscal de cliente
TMSA050()

// ---	Restaura função anterior
SetFunName(cOldFun)

Return

/*/{Protheus.doc} BLegenda
Rotina usada para exibir as legendas conforme regra.
@author 	Luiz Alexandre Ferreira
@since 		04/11/2014
@version 	1.0
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function BLegenda()

// ---	Variaveis utilizadas
Local _aLegenda := {}

// ---	Adiciona regras de acordo com a cor.
Aadd(_aLegenda,{"BR_VERDE" 	,"Solicitação Liberada para digitar lote" })
Aadd(_aLegenda,{"BR_AMARELO" ,"Lote já digitado para " +TRB->FILDOC +' - '+TRB->DOC+' - '+TRB->SERIE })

// ---	Legenda
BrwLegenda(_cCadastro, "Legenda", _aLegenda)

Return Nil


/*/{Protheus.doc} INTCNHSX6
Rotina utilizada no gatilho do campo Solicitação de coleta.
Observacao: Referente ao preenchimento automatico da inscricao estadual, nao foi considerado as multiplas inscrições por cliente.
@author 	Luiz Alexandre Ferreira
@since 		06/11/2014
@version 	1.0
@param 		_cDomin, ${param_type}, (Descrição do parâmetro)
@param 		_cContraD, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function INTCNHSX6( _cDomin,_cContraD )

// --- Variaveis utilizadas
Local 	_nKm		:= 0
Local 	_cServ		:= ''
Local 	_aArea		:= GetArea()
Local 	_aAreaDT6	:= DT6->(GetArea())
Local	_cOrigem	:= ''

// ---	Retorno do Km da solicitacao / agendamento
If 	_cDomin+_cContraD == 'DTC_NUMSOL'+'DTC_KM' //.and. FWIsInCallStack('U_GEFCNHLOT')
	
	// --- Altarado em: 29/11/2016 - Por: Ricardo	
	// ---	Define variavel de origem
	_cOrigem	:= "DF1"

	//	---	Posiciona item do agendamento

	DF1->(dbSetOrder(3))
	DF1->(dbSeek(xFilial('DF1')+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE ) )
	
	DF0->(dbSetOrder(1))
	DF0->(dbSeek(xFilial('DF0')+DF1->DF1_NUMAGE ) )	
	
Else
	
	//	---	Via solicitação de coleta sem agendamento
	_cOrigem	:= "DTC"
	
	//	---	Posiciona solicitação de coleta
	// ---	Localiza o agendamento e retorna o KM
	DT6->(dbSetOrder(1))
	DT6->(dbSeek(xFilial('DT6')+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE ) )
	
EndIf

// ---	Demais retornos
M->DTC_FILCFS	:= 	Iif(_cOrigem == "DF1",DF1->DF1_FILDOC,cFilAnt)
M->DTC_CLIREM	:=	Iif(_cOrigem == "DF1",DF1->DF1_CLIREM, DT6->DT6_CLIREM)
M->DTC_LOJREM	:=	Iif(_cOrigem == "DF1",DF1->DF1_LOJREM, DT6->DT6_LOJREM)
M->DTC_NOMREM	:=	Iif(_cOrigem == "DF1",GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DF1->DF1_CLIREM+DF1->DF1_LOJREM,1,'' ),GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DT6->DT6_CLIREM+DT6->DT6_LOJREM,1,'' ) )
M->DTC_DATENT	:=	dDataBase
M->DTC_CLIDES	:=	Iif(_cOrigem == "DF1",DF1->DF1_CLIDES, DT6->DT6_CLIDES )
M->DTC_LOJDES	:=	Iif(_cOrigem == "DF1",DF1->DF1_LOJDES, DT6->DT6_LOJDES )
M->DTC_NOMDES	:=	Iif(_cOrigem == "DF1",GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DF1->DF1_CLIDES+DF1->DF1_LOJDES,1,'' ),GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DT6->DT6_CLIDES+DT6->DT6_LOJDES,1,'' ) )
M->DTC_CLIDEV	:=	Iif(_cOrigem == "DF1",DF1->DF1_CLIDEV, DT6->DT6_CLIDEV )
M->DTC_LOJDEV	:=	Iif(_cOrigem == "DF1",DF1->DF1_LOJDEV, DT6->DT6_LOJDEV )
M->DTC_NOMDEV	:=	Iif(_cOrigem == "DF1",GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DF1->DF1_CLIDEV+DF1->DF1_LOJDEV,1,'' ),GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV,1,'') )

If _cOrigem == "DF1"
	
	//	---	Remetente
	If DF1->DF1_CLIDEV+DF1->DF1_LOJDEV == DF1->DF1_CLIREM+DF1->DF1_LOJREM
		M->DTC_DEVFRE 	:= 	'1'
		M->DTC_CLICAL	:=	M->DTC_CLIREM
		M->DTC_LOJCAL	:=	M->DTC_LOJREM
		M->DTC_CDRDES	:=	GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+M->DTC_CLIREM+M->DTC_LOJREM,1,'')
		M->DTC_CDRCAL	:=	M->DTC_CDRDES
		M->DTC_NOMCAL	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+M->DTC_CLIREM+M->DTC_LOJREM,1,'' )
		M->DTC_INSREM	:=	GetAdvFVal('SA1','A1_INSCR',xFilial('SA1')+M->DTC_CLIREM+M->DTC_LOJREM,1,'' )
		M->DTC_SQIREM	:=	'01'
		
		//	---	Destinatario
	ElseIf 	( DF1->DF1_CLIDEV+DF1->DF1_LOJDEV == DF1->DF1_CLIDES+DF1->DF1_LOJDES ) .or. ;
			( DF1->DF1_CLIDEV+DF1->DF1_LOJDEV # DF1->DF1_CLIREM+DF1->DF1_LOJREM .and. DF1->DF1_CLIDEV+DF1->DF1_LOJDEV # DF1->DF1_CLIDES+DF1->DF1_LOJDES)
		
		M->DTC_DEVFRE 	:= '2'
		M->DTC_CLICAL	:=	M->DTC_CLIDEV
		M->DTC_LOJCAL	:=	M->DTC_LOJDEV
		M->DTC_CDRDES	:=	GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+M->DTC_CLIDEV+M->DTC_LOJDEV,1,'')
		M->DTC_CDRCAL	:=	M->DTC_CDRDES
		M->DTC_NOMCAL	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+M->DTC_CLIDEV+M->DTC_LOJDEV,1,'' )
		M->DTC_INSDES	:=	GetAdvFVal('SA1','A1_INSCR',xFilial('SA1')+M->DTC_CLIDEV+M->DTC_LOJDEV,1,'' )
		M->DTC_SQIDES	:=	'01'
		
		//	---	Verifica tipo de operação para indicar a sequencia de endereço do CDC
		If AllTrim(DF0->DF0_DESOPE)	 == 'LTL'
			
			//	---	Verifica o estado da filial e indica a sequencia de endereço do CDC.
			If SM0->M0_ESTCOB == 'MG'
				M->DTC_SEQEDES	:=	'02'
			ElseIf SM0->M0_ESTCOB == 'SP'
				M->DTC_SEQEDES	:=	'01'
			EndIf
			
		EndIf
		
	EndIf
	
Else
	
	//	---	Remetente
	If DT6->DT6_CLIDEV+DT6->DT6_LOJDEV == DT6->DT6_CLIREM+DT6->DT6_LOJREM
		M->DTC_DEVFRE 	:= 	'1'
		M->DTC_CLICAL	:=	DT6->DT6_CLIREM
		M->DTC_LOJCAL	:=	DT6->DT6_LOJREM
		M->DTC_CDRDES	:=	GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+DT6->DT6_CLIREM+DT6->DT6_LOJREM,1,'')
		M->DTC_CDRCAL	:=	M->DTC_CDRDES
		M->DTC_NOMCAL	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DT6->DT6_CLIREM+DT6->DT6_LOJREM,1,'' )
		M->DTC_INSREM	:=	GetAdvFVal('SA1','A1_INSCR',xFilial('SA1')+DT6->DT6_CLIREM+DT6->DT6_LOJREM,1,'' )
		M->DTC_SQIREM	:=	'01'
		
		//	---	Destinatario
	ElseIf 	( DT6->DT6_CLIDEV+DT6->DT6_LOJDEV == DT6->DT6_CLIDES+DT6->DT6_LOJDES ) .or. ;
			( DF1->DF1_CLIDEV+DF1->DF1_LOJDEV # DF1->DF1_CLIREM+DF1->DF1_LOJREM .and. DF1->DF1_CLIDEV+DF1->DF1_LOJDEV # DF1->DF1_CLIDES+DF1->DF1_LOJDES )
		
		M->DTC_DEVFRE 	:= '2'
		M->DTC_CDRDES	:=	GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV,1,'')
		M->DTC_CDRCAL	:=	M->DTC_CDRDES
		M->DTC_CLICAL	:=	DT6->DT6_CLIDEV
		M->DTC_LOJCAL	:=	DT6->DT6_LOJDEV
		M->DTC_NOMCAL	:=	GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV,1,'' )
		M->DTC_INSDES	:=	GetAdvFVal('SA1','A1_INSCR',xFilial('SA1')+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV,1,'' )
		M->DTC_SQIDES	:=	'01'
		
		//	---	Verifica tipo de operação para indicar a sequencia de endereço do CDC
		If AllTrim(DF0->DF0_DESOPE)	 == 'LTL'
			
			//	---	Verifica o estado da filial e indica a sequencia de endereço do CDC.
			If SM0->M0_ESTCOB == 'MG'
				M->DTC_SEQEDES	:=	'02'
			ElseIf SM0->M0_ESTCOB == 'SP'
				M->DTC_SEQEDES	:=	'01'
			EndIf
			
		EndIf
		
	EndIf
	
EndIf

M->DTC_SERTMS	:=	Iif( _cOrigem == "DF1",GetAdvFVal('DC5','DC5_SERTMS',xFilial('DC5')+DF1->DF1_SERVIC,1,''),'3')
M->DTC_SERVIC	:=	Iif( _cOrigem == "DF1",DF1->DF1_SERVIC , GetAdvFVal('DF1','DF1_SERVIC',xFilial('DF1')+DT6->DT6_NUMAGD+DT6->DT6_ITEAGD,1,'') )
M->DTC_DESSER	:=	Posicione("SX5",1,xFilial('SX5')+'L4'+Iif(_cOrigem == "DF1",DF1->DF1_SERVIC, M->DTC_SERVIC ),"X5DESCRI()")
M->DTC_TIPTRA	:=	Iif(_cOrigem == "DF1",DF1->DF1_TIPTRA, GetAdvFVal('DF1','DF1_TIPTRA',xFilial('DF1')+DT6->DT6_NUMAGD+DT6->DT6_ITEAGD,1,'') )
M->DTC_DESTPT	:=	TMSValField( Iif(_cOrigem=='DF1',"DF1->DF1_TIPTRA", M->DTC_TIPTRA ),.F.,"DTC_DESTPT")
M->DTC_TIPNFC	:=	'0'
M->DTC_TIPFRE	:=	Iif(_cOrigem == "DF1",DF1->DF1_TIPFRE, '2' )
M->DTC_SELORI	:=	Iif(_cOrigem == "DF1",DF1->DF1_SELORI, GetAdvFVal('DF1','DF1_SELORI',xFilial('DF1')+DT6->DT6_NUMAGD+DT6->DT6_ITEAGD,1,'') )
M->DTC_CDRORI	:=	Iif(_cOrigem == "DF1",DF1->DF1_CDRORI, GetAdvFVal('SA1','A1_CDRDES',xFilial('SA1')+DT6->DT6_CLIREM+DT6->DT6_LOJREM,1,'') )
M->DTC_DISTIV	:=	Iif(_cOrigem == "DF1",DF1->DF1_DISTIV, '3')
// _nKm			:= 	Iif(_cOrigem == "DF1",DF1->DF1_KMFRET, GetAdvFVal('DF1','DF1_KMFRET',xFilial('DF1')+DT6->DT6_NUMAGD+DT6->DT6_ITEAGD,1,'') )
_nKm			:= 	Iif(_cOrigem == "DF1",DF0->DF0_KMPLAN, GetAdvFVal('DF1','DF1_KMFRET',xFilial('DF1')+DT6->DT6_NUMAGD+DT6->DT6_ITEAGD,1,'') )

If ExistTrigger('DTC_CDRDES')
	// ---	Verifica se existe trigger para este campo
	RunTrigger(1,nil,nil,,'DTC_CDRDES')
Endif

If ExistTrigger('DTC_CDRCAL')
	// ---	Verifica se existe trigger para este campo
	RunTrigger(1,nil,nil,,'DTC_CDRCAL')
Endif

If ExistTrigger('DTC_SERTMS')
	// ---	Verifica se existe trigger para este campo
	RunTrigger(1,nil,nil,,'DTC_SERTMS')
Endif


// ---	Exibe as notas associadas ao plano/solicitação de coleta
// ---	Restaura area
RestArea(_aArea)
RestArea(_aAreaDT6)

// ---	Executa rotina para localizar as notas e exibir na tela para o usuário
If ! Empty(M->DTC_NUMSOL)
	
	//	---	Faz a criação do lote
	U_CRIALOTE()
	
	//	---	Exibe chaves associadas
	U_CNHLOTNFE(M->DTC_NUMSOL)
	
EndIf


// ---	Retorna o Km do rateio
Return _nKm


/*/{Protheus.doc} CNHLOTNFE
Função responsável por exibir as notas fiscais eletrônicas associadas ao plano de transporte.
@author 	Luiz Alexandre Ferreira
@since 		06/11/2014
@version 	1.0
@param 		_cNumSol, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function CNHLOTNFE(_cNumSol)

// ---	Variaveis utilizadas
Local _lReturn	:= .F.
Local _nI       	:= 0
Local _nOpc     	:= 0
Local oOk      	:= LoadBitMap(GetResources(),"LBOK")
Local oNo      	:= LoadBitMap(GetResources(),"LBNO")
Local _aTitulo  	:= {" ", "Chave NF-e", "Nota Fiscal", "Serie" }
Local _aSize		:= MsAdvSize()
Local _aInfo		:= {}
Local _aPosObj	:= {}
Local _aObjects	:= {}
Local _oFont		:=	TFont():New('Tahoma',,-28,.T.)
Local _oFont1		:=	TFont():New('Tahoma',,-14,.T.)
Local _oSay
Local _oSay1
Local _oSay2
Local _oSay3
Local _oSay4
Local _oSay5
Local _oSay6
Local _oDlg
Private _oListBox
Private _oLsBoxNfe
Private _oDlg		:=	Nil
Private _cTitulo	:=	OemToAnsi('Plano de transporte - Vincular Nota Fiscal Eletronica')
Private _aList	:= {}

// ---	Carrega dados
If FWIsInCallStack('U_GEFCNHLOT')
	If ! CNHLOTSEL()
		Return
	EndIf
Else
Return
EndIf


// ---	Dados do objeto
aAdd( _aObjects, { 100, 20,.T., .T., .F. } )
aAdd( _aObjects, { 100, 70,.T., .T., .F. } )
aAdd( _aObjects, { 100, 10,.T., .T., .F. } )
_aInfo		:= { _aSize[ 1 ], _aSize[ 2 ], _aSize[ 3 ], _aSize[ 4 ],1,1 }
_aPosObj 	:= MsObjSize( _aInfo, _aObjects, .T. )

// ---	Definição do Dialog
DEFINE MSDIALOG _oDLG TITLE _cTitulo FROM _aSize[7], 0 TO _aSize[6], _aSize[5] PIXEL

// ---	Texto parte superior
_oSay	:= TSay():New( _aPosObj[1][1], _aPosObj[1][2]+10, {|| OemToAnsi('Plano de transporte ')+Transform(DF0->DF0_PLANID,'@E 9,999,999' ) },_oDlg,, _oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
_oSay:lTransparent:= .F.

// ---	Listbox com as notas fiscais
_oListBox := TWBrowse():New(_aPosObj[2][1],_aPosObj[2][2],_aPosObj[2][4],_aPosObj[2][3]-_aPosObj[1][3],,_aTitulo,{ 10,180,50,10 },_oDlg,,,,,;
	{|nRow,nCol,nFlags|,_oListBox:Refresh()},,,,,,,.F.,,.T.,,.F.,,, )

_oListBox:SetArray(_aList)
_oListBox:bLine := { || { If ( _aList[_oListBox:nAt,nNFEMARCA], oOk, oNo) ,;
	_aList[_oListBox:nAt,nNFECHAVE],;
	_aList[_oListBox:nAt,nNFEDOC],;
	_aList[_oListBox:nAt,nNFESERIE]  } }

// ---	Double click
_oListBox:bLDblClick := {|| _aList[_oListBox:nAt][1] := !_aList[_oListBox:nAt][1], _oListBox:DrawSelect() }

// ---	Cria botoes
TButton():Create( _oDlg, _aPosObj[3,1]+5, _aPosObj[3,4]-100	,"&Gravar"			,{|| _nOpc := 1, _oDlg:End()	},40,15,,,,.T.,,,,,,)
TButton():Create( _oDlg, _aPosObj[3,1]+5, _aPosObj[3,4]-50	,"&Sair"			,{|| _nOpc := 2, _oDlg:End()	},40,15,,,,.T.,,,,,,)

ACTIVATE MSDIALOG _oDlg CENTERED

// ---	Verifica opcao
If _nOpc	== 1
	// ---	Grava os dados da(s) nota(s) selecionada(s)
	CNHLOTGRV(_aList)
EndIf

Return

/*/{Protheus.doc} CNHLOTSEL
Carrega as notas associadas a partir da tabela de XML.
@author 	Luiz Alexandre Ferreira
@since 		06/11/2014
@version 	1.0
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function CNHLOTSEL()

// ---	Variaveis utilizadas
Local _lRet		:= 	.t.

// ---	Verifica se existem chaves associadas ao plano/solicitação de coleta
SZ6->(dbSetOrder(3))
If SZ6->(dbSeek(xFilial('SZ6')+Str(TRB->PLANID,TamSx3('Z6_PLANID')[1],0)))
	While SZ6->( ! Eof() ) .and. SZ6->Z6_FILIAL == xFilial('SZ6') .and. SZ6->Z6_PLANID == TRB->PLANID
		
		// ---	Adiciona Chave
		Aadd( _aList, { .f., SZ6->Z6_IDNFE, SZ6->Z6_NUMNFE, SZ6->Z6_SERNFE } )
		
		// ---	Proximo registro
		SZ6->(dbSkip())
		
	EndDo
Else
	// ---	Retorna falso
	_lRet	:= .f.
	
EndIf

Return _lRet


/*/{Protheus.doc} CNHLOTGRV
Grava as notas selecionadas para as linhas da grid.
@author 	Luiz Alexandre Ferreira
@since 		06/11/2014
@version 	1.0
@param 		_aList, ${param_type}, (Descrição do parâmetro)
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function CNHLOTGRV(_aList)

// ---	Variaveis utilizadas
Local	_nCount		:= 	0
Local	_nItem		:= 	0
Local	_nCntFor	:= 	0
Local	_cXML		:=	''
Local	cError		:= 	''
Local	cWarning	:=	''
Local	_aProd		:=	{}
Local	_cProd		:= 	''
Private	_oXML	   	:= 	Nil

//	---	Atribui conteúdo a variaveis
_cProd	:=	GetMV('ES_CNHPROD')
_aProd	:= 	Iif(!Empty(_cProd),&_cProd,{})

// --- Laço no array com a lista das notas fiscais
For _nCount	:= 1 to Len(_aList)
	
	// ---	Somente itens selecionados
	If (_aList[_nCount,1])
		
		// --- Adiciona elemento na GetDados
		If ! Empty(GDFieldGet('DTC_NUMNFC',o1Get:oBrowse:nAt))
			o1Get:AddLine()
		EndIf
		
		//	---	Captura o XML
		SZ6->(dbSetOrder(2))
		SZ6->(dbSeek(xFilial('SZ6')+_aList[_nCount,2]))
		_cXML	:=	NoAcento(SZ6->Z6_XML)
		
		If ! Empty(_cXML)
			_oXml := XmlParser( _cXML, "_NFE", @cError, @cWarning )
			
			If (_oXml == NIL )
				Alert("Falha no arquivo XML, digite os dados pela DANFE!: "+cError+" / "+cWarning)
				Return
			Endif
		EndIf
		
		// ---	Grava campos na GetDados
		GDFieldPut('DTC_NUMNFC'		,	_aList[_nCount,3],o1Get:oBrowse:nAt)
		GDFieldPut('DTC_SERNFC'		,	_aList[_nCount,4],o1Get:oBrowse:nAt)
		GDFieldPut('DTC_CODPRO'		,	_aProd[1] ,o1Get:oBrowse:nAt)
		GDFieldPut('DTC_NFEID'		,	_aList[_nCount,2],o1Get:oBrowse:nAt)
		GDFieldPut('DTC_CF'			,	SZ6->Z6_CFOPPRI,o1Get:oBrowse:nAt)
		
		//	---	Somente nos casos em que o XML foi validado a estrutura
		If ValType('_oXML:_NFE') != 'U' 
			GDFieldPut('DTC_EMINFC'		,	Iif ( ! Empty(_cXML), Ctod(SubStr(_oXML:_NFE:_INFNFE:_IDE:_DEMI:TEXT,9,2)+'/'+;
				SubStr(_oXML:_NFE:_INFNFE:_IDE:_DEMI:TEXT,6,2)+'/'+;
				SubStr(_oXML:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,4)), Ctod('') ),o1Get:oBrowse:nAt)
			
			GDFieldPut('DTC_VALOR'		,	Iif ( ! Empty(_cXML), Val(_oXML:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT),0),o1Get:oBrowse:nAt)
			
			//	---	Verifica se a nota possui volumes
			If ValType('_oXML:_NFE:_INFNFE:_TRANSP:_VOL') == 'U'
				
				//	---	Nao localizou os dados preeche padrao
				GDFieldPut('DTC_QTDVOL'		,	1, o1Get:oBrowse:nAt)
				GDFieldPut('DTC_PESO'		,	100,o1Get:oBrowse:nAt)
				GDFieldPut('DTC_PESLIQ'		,	100,o1Get:oBrowse:nAt )
				GDFieldPut('DTC_CODEMB'		,	'CX',o1Get:oBrowse:nAt)
				
			Else
				//	---	Grava dados do XML
				GDFieldPut('DTC_QTDVOL'		,	Iif ( ! Empty(_cXML), Val(_oXML:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT),0), o1Get:oBrowse:nAt)
				GDFieldPut('DTC_PESO'		,	Iif ( ! Empty(_cXML), Val(_oXML:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT),0),o1Get:oBrowse:nAt)
				GDFieldPut('DTC_PESLIQ'		,	Iif ( ! Empty(_cXML), Val(_oXML:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT),0),o1Get:oBrowse:nAt )
				GDFieldPut('DTC_CODEMB'		,	Iif ( ! Empty(_cXML), _oXML:_NFE:_INFNFE:_TRANSP:_VOL:_ESP:TEXT,'CX'),o1Get:oBrowse:nAt)
				
			EndIf
		
		ElseIf ValType('_oXML:_NFPROC') != 'U'
		
			GDFieldPut('DTC_EMINFC'		,	Iif ( ! Empty(_cXML), Ctod(SubStr(_oXML:_NFPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,9,2)+'/'+;
				SubStr(_oXML:_NFPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,6,2)+'/'+;
				SubStr(_oXML:_NFPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,4)), Ctod('') ),o1Get:oBrowse:nAt)
			
			GDFieldPut('DTC_VALOR'		,	Iif ( ! Empty(_cXML), Val(_oXML:_NFPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT),0),o1Get:oBrowse:nAt)
			
			//	---	Verifica se a nota possui volumes
			If ValType('_oXML:_NFPROC:_NFE:_INFNFE:_TRANSP:_VOL') == 'U'
				
				//	---	Nao localizou os dados preeche padrao
				GDFieldPut('DTC_QTDVOL'		,	1, o1Get:oBrowse:nAt)
				GDFieldPut('DTC_PESO'		,	100,o1Get:oBrowse:nAt)
				GDFieldPut('DTC_PESLIQ'		,	100,o1Get:oBrowse:nAt )
				GDFieldPut('DTC_CODEMB'		,	'CX',o1Get:oBrowse:nAt)
				
			Else
				//	---	Grava dados do XML
				GDFieldPut('DTC_QTDVOL'		,	Iif ( ! Empty(_cXML), Val(_oXML:_NFPROC:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT),0), o1Get:oBrowse:nAt)
				GDFieldPut('DTC_PESO'		,	Iif ( ! Empty(_cXML), Val(_oXML:_NFPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT),0),o1Get:oBrowse:nAt)
				GDFieldPut('DTC_PESLIQ'		,	Iif ( ! Empty(_cXML), Val(_oXML:_NFPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT),0),o1Get:oBrowse:nAt )
				GDFieldPut('DTC_CODEMB'		,	Iif ( ! Empty(_cXML), _oXML:_NFPROC:_NFE:_INFNFE:_TRANSP:_VOL:_ESP:TEXT,'CX'),o1Get:oBrowse:nAt)
				
			EndIf
		
		EndIf
		
		If ExistTrigger('DTC_CODEMB')
			// ---	Verifica se existe trigger para este campo
			RunTrigger(2,o1Get:oBrowse:nAt,nil,,'DTC_CODEMB')
		Endif
		
	EndIf
	
Next _nCount

// ---	Refresh do browse e define foco.
o1Get:Refresh()
o1Get:oBrowse:SetFocus()

Return
