#Include 'Protheus.ch'
#Include 'Totvs.ch'
#Include "Fwmvcdef.ch"

#Define nAMARCA 01
#Define nFILIAL 02
#Define nDOC    03
#Define nSERIE  04
#Define nCLIREM 05
#Define nCLIDES 06
#Define nNOTAS 	07

#Define nNFEMARCA	01
#Define nNFECHAVE	02
#Define nNFEDOC    	03
#Define nNFESERIE  	04

/*/{Protheus.doc} GEFCNHNFE
Função responsável por associar notas fiscais com planos de transporte e solicitação de coleta.
@author 	Luiz Alexandre Ferreira
@since 		17/10/2014
@version 	1.0
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function GEFCNHNFE(_cFunName)

// ---	Variaveis utilizadas
Local _cType		:=	"Arquivos XML|*.XML|Todos os Arquivos|*.*"
Local _lReturn		:= .F.
Local _nI       	:= 0
Local _xArqs   		:= {}
Local _cTitulo  	:= OemToAnsi( "XMLs CTE" )
Local _nOpc     	:= 0
Local oOk      		:= LoadBitMap(GetResources(),"LBOK")
Local oNo      		:= LoadBitMap(GetResources(),"LBNO")
Local _oOkNfe  		:= LoadBitMap(GetResources(),'br_verde')
Local _oNoNfe  		:= LoadBitMap(GetResources(),'br_vermelho')
Local _aTitulo  	:= {" ","Filial", "Sol Coleta", "Serie", "Remetente", "Destinatário" }
Local _aTitNfe  	:= {" ", "Chave NF-e", "Nota Fiscal", "Serie" }
Local _aSize		:= MsAdvSize()
Local _aInfo		:= {}
Local _aPosObj		:= {}
Local _aObjects		:= {}
Local _oFont		:=	TFont():New('Tahoma',,-28,.T.)
Local _oFont1		:=	TFont():New('Tahoma',,-14,.T.)
Local _aArea		:=	DF0->(GetArea())
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
Private _aCoors		:=	FWGetDialogSize(oMainWnd)
Private _aList		:= {}
Private _aNfe		:= {}

// ---  Rotina default que vai chamar a funcao
DEFAULT _cFunName	:=	'TMSAF05'

// ---	Carrega dados
If ! CNHNFESEL()
	Return
EndIf

// ---	Dados do objeto
aAdd( _aObjects, { 100, 20, .T., .T., .F. } )
aAdd( _aObjects, { 100, 35,.T., .T., .F. } )
aAdd( _aObjects, { 100, 10,.T., .T., .F. } )
aAdd( _aObjects, { 100, 35,.T., .T., .F. } )
_aInfo		:= { _aSize[ 1 ], _aSize[ 2 ], _aSize[ 3 ], _aSize[ 4 ],1,1 }
_aPosObj 	:= MsObjSize( _aInfo, _aObjects, .T. )


// ---	Definição do Dialog
DEFINE MSDIALOG _oDLG TITLE _cTitulo FROM _aCoors[1], _aCoors[2] TO _aCoors[3], _aCoors[4] PIXEL

// ---	Texto parte superior
_oSay	:= TSay():New( _aPosObj[1][1], _aPosObj[1][2]+10, {|| OemToAnsi('Plano de transporte ')+Transform(DF0->DF0_PLANID,'@E 9,999,999' ) },_oDlg,, _oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
_oSay:lTransparent:= .F.

_oSay1	:= TSay():New( _aPosObj[1][1]+20, _aPosObj[1][2]+10, {|| OemToAnsi('Veículo ')+DF0->DF0_DESVEI },_oDlg,, _oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
_oSay1:lTransparent:= .F.

_oSay2	:= TSay():New( _aPosObj[1][1]+30, _aPosObj[1][2]+10, {|| OemToAnsi('Operação ')+Trim(DF0->DF0_DESOPE)+' - Viagem '+ DF0->DF0_DESVIA },_oDlg,, _oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
_oSay2:lTransparent:= .F.

_oSay3	:= TSay():New( _aPosObj[1][1], _aPosObj[1][2]+350, {|| OemToAnsi('Data do plano : ')+Dtoc(DF0->DF0_DATCAD) },_oDlg,, _oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
_oSay3:lTransparent:= .F.

_oSay4	:= TSay():New( _aPosObj[1][1]+20, _aPosObj[1][2]+350, {|| OemToAnsi('Motorista : ')+GetAdvFVal('DA4','DA4_NOME',xFilial('DA4')+DF0->DF0_CODMOT,1,'') },_oDlg,, _oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
_oSay4:lTransparent:= .F.

_oSay5	:= TSay():New( _aPosObj[1][1]+30, _aPosObj[1][2]+350, {|| OemToAnsi('Placa : ')+Transform(GetAdvFVal('DA3','DA3_PLACA',xFilial('DA4')+DF0->DF0_CODVEI,1,''),'@R XXX-9999' ) },_oDlg,, _oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
_oSay5:lTransparent:= .F.


// ---	Solicitações de coleta
_oListBox := TWBrowse():New( _aPosObj[2][1],_aPosObj[2][2],_aPosObj[2][4],_aPosObj[2][3]-_aPosObj[1][3],,_aTitulo,, _oDlg, ,,,,;
{|nRow,nCol,nFlags|,_oListBox:Refresh()},,,,,,,.F.,,.T.,,.F.,,, )

_oListBox:SetArray(_aList)
_oListBox:bLine := { || _oLsBoxNfe:Refresh(.t.), { If ( _aList[_oListBox:nAt,nAMARCA], oOk, oNo) ,;
_aList[_oListBox:nAt,nFILIAL],;
_aList[_oListBox:nAt,nDOC],;
_aList[_oListBox:nAt,nSERIE],;
_aList[_oListBox:nAt,nCLIREM],;
_aList[_oListBox:nAt,nCLIDES] } }
_oListBox:bLDblClick := {|| _aList[_oListBox:nAt][1] := !_aList[_oListBox:nAt][1], _oListBox:DrawSelect() }

// ---	Chave da nota fiscal
_oLsBoxNfe := TWBrowse():New( _aPosObj[4][1],_aPosObj[4][2],_aPosObj[4][4],_aPosObj[4][3]-_aPosObj[3][3],,_aTitNfe,{ 10,180,50,10 },_oDlg,,,,,;
{|nRow,nCol,nFlags|,_oLsBoxNfe:Refresh()},,,,,,,.F.,,.T.,,.F.,,, )

_oLsBoxNfe:SetArray(_aNfe)
_oLsBoxNfe:bLine := { || { If( _aNfe[_oLsBoxNfe:nAt,nNFEMARCA],_oOkNfe,_oNoNfe),;
_aNfe[_oLsBoxNfe:nAt,nNFECHAVE],;
_aNfe[_oLsBoxNfe:nAt,nNFEDOC],;
_aNfe[_oLsBoxNfe:nAt,nNFESERIE] } }

TButton():Create( _oDlg, _aPosObj[3,1]+5, _aPosObj[3,2]+10 							,"&Ler Chave NFe"	,{|| _nOpc := 1, CNHNFELER()	},45,15,,,,.T.,,,,,,)
TButton():Create( _oDlg, _aPosObj[3,1]+5, ((_aPosObj[3,4]-_aPosObj[3,1])/3)+40		,"&Gravar"			,{|| _nOpc := 2, CNHNFEGRV()	},45,15,,,,.T.,,,,,,)
TButton():Create( _oDlg, _aPosObj[3,1]+5, (((_aPosObj[3,4]-_aPosObj[3,1])/3)*2)+40	,"&Remover Chave"	,{|| _nOpc := 3, CNHNFEDEL()	},45,15,,,,.T.,,,,,,)
TButton():Create( _oDlg, _aPosObj[3,1]+5, _aPosObj[3,4]-50							,"&Sair"			,{|| _nOpc := 0, _oDlg:End()	},45,15,,,,.T.,,,,,,)


ACTIVATE MSDIALOG _oDlg CENTERED

// ---	Restaura area de trabalho
RestArea(_aArea)

Return

/*/{Protheus.doc} CNHNFESEL
Função responsável por associar notas fiscais com planos de transporte e solicitação de coleta.
@author 	Luiz Alexandre Ferreira
@since 		17/10/2014
@version 	1.0
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function CNHNFESEL()

// ---	Variaveis
Local _lRet		:= 	.t.

// ---	Carrega os documentos
If DF0->DF0_STATUS > '1' .and. DF0->DF0_STATUS < '9'
	
	
	// ---	Define indice de pesquisa
	DF1->(dbSetOrder(1))
	DF1->(dbSeek(xFilial('DF1')+DF0->DF0_NUMAGE))
	While DF1->( ! Eof() ) .and. DF0->DF0_FILIAL == DF1->DF1_FILIAL .and. DF0->DF0_NUMAGE == DF1->DF1_NUMAGE
		
		// ---	Adiciona solicitações de coleta geradas para o plano
		Aadd( _aList, {.f., DF1->DF1_FILDOC, DF1->DF1_DOC, DF1->DF1_SERIE,;
		GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DF1->DF1_CLIREM+DF1->DF1_LOJREM,1,'' ),;
		GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DF1->DF1_CLIDES+DF1->DF1_LOJDES,1,'' ), aClone(_aNfe) } )
		
		// ---	Proximo
		DF1->(dbSkip())
		
	EndDo
	
	// ---	Verifica se existem chaves associadas ao plano/solicitação de coleta
	SZ6->(dbSetOrder(3))
	If SZ6->(dbSeek(xFilial('SZ6')+Str(DF0->DF0_PLANID,TamSx3('Z6_PLANID')[1],0)))
		While SZ6->( ! Eof() ) .and. SZ6->Z6_FILIAL == DF0->DF0_FILIAL .and. SZ6->Z6_PLANID == DF0->DF0_PLANID
			
			// ---	Adiciona Chave vazia
			Aadd( _aNfe, { .f., SZ6->Z6_IDNFE, SZ6->Z6_NUMNFE, SZ6->Z6_SERNFE } )
			
			// ---	Proximo registro
			SZ6->(dbSkip())
			
		EndDo
	Else
		// ---	Adicona linha vazia
		Aadd( _aNfe , {.t., '', '', '' } )
		
	EndIf
	
Else
	// ---	Retorno false e exibe mensagem
	_lRet	:= .f.
	// ---	Exibe mensagem
	Help (" ", 1, "GEFCNHNFE01",,OemToAnsi( 'Status não permitido, somente após confirmado !'), 1, 0)
EndIf

Return _lRet


/*/{Protheus.doc} CNHNFELER
Função responsável por associar notas fiscais com planos de transporte e solicitação de coleta.
@author 	Luiz Alexandre Ferreira
@since 		17/10/2014
@version 	1.0
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function CNHNFELER()

// --- Variaveis utilizadas
Local	_oDlg
Local	_oSay
Local	_oSay1
Local	_oFont
Local	_oSButton1, _oSButton2
Local	_cMsg1		:= 	''
Local	_lRet		:=	.t.
Local	_lRetWS		:=	.t.
Local	_cChave		:=	Space(44)
Local	_cOldFun	:=	FunName()

// ---	Define dialog
_oDlg	:= MSDialog():New(0,0,100,450,OemToAnsi('Ler Chave Eletrônica '),,,,,CLR_BLACK,CLR_WHITE,,,.t.)

// ---	Define fontes para mensagens
_oFont	:= TFont():New('Tahoma',,-12,.T.)

// --- Apresenta o tSay com a fonte Courier New
_oSay	:= TSay():New( 007, 010, {|| OemToAnsi('Chave Eletrônica ')  },_oDlg,, _oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
_oSay:lTransparent:= .F.

_oSay1	:= TSay():New( 005, 010, {|| _cMsg1  },_oDlg,, _oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
_oSay1:lTransparent:= .F.

// ---	Leitura da chave eletrônica
@ 005,060 MSGET _cChave	SIZE 160, 9 OF _oDlg PICTURE "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999" PIXEL VALID CNHNFEVLD(_cChave)

// --- Botoes para gravacao dos dados de classificacao do titulo
_oSButton1 := SButton():New( 35,10,1, {|| _lRet := .t., _oDlg:End() },_oDlg,.T.,'Confirma dados',)
_oSButton2 := SButton():New( 35,40,2, {|| _lRet := .f., _oDlg:End() },_oDlg,.T.,'Cancela',)

// --- 	Ativa o objeto
_oDlg:Activate()

// ---	Se confirmado transmite interface
If _lRet
	
	// ---	Prepara variveis para executar o WS de consulta da Chave
	SetFunName('MATA103x')
	cVar		:=	CriaVar('F1_CHVNFE')
	cFormul		:=	CriaVar('F1_FORMUL')
	cEspecie	:=	CriaVar('F1_ESPECIE')
	cVar		:=	_cChave
	cEspecie	:=	'SPED'
	cFormul		:= 	'N'
	
	// ---	Funcao que executa a consulta da chave eletronica
	_lRetWS	:= 	A103ConsNfeSef()
	
	If Len(_aNfe) == 1 .and. Empty(_aNfe[1,2])
		_aNfe[1,1]	:=	.t.
		_aNfe[1,2]	:=	_cChave
		_aNfe[1,3]	:=	SubStr(_cChave,26,9)
		_aNfe[1,4]	:= 	StrZero(Val(SubStr(_cChave,23,3)),3)
	Else
		Aadd( _aNfe , {.t., _cChave, SubStr(_cChave,26,9), StrZero(Val(SubStr(_cChave,23,3)),3) } )
	EndIf
	
EndIf

// ---	Restaura função
SetFunName(_cOldFun)

Return _lRet

/*/{Protheus.doc} CNHNFEVLD
Função responsável por associar notas fiscais com planos de transporte e solicitação de coleta.
@author 	Luiz Alexandre Ferreira
@since 		17/10/2014
@version 	1.0
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function CNHNFEVLD(_cChave)

// ---	Variaveis utilizadas
Local	_lRet	:= .t.

// ---	Verifica se a chave já existe
SZ6->(dbSetOrder(2))
If SZ6->(dbSeek(xFilial("SZ6")+_cChave))
	
	//	---	Localiza a chave, mas se o numero do plano estiver zerado associa
	// 	---	Exibe mensagem
	If (SZ6->Z6_PLANID > 0 )
		_lRet	:= .f.
		Help (" ", 1, "GEFCNHNFE02",,OemToAnsi( 'Chave ja associada ao plano ')+Str(SZ6->Z6_PLANID,TamSx3('Z6_PLANID')[1],0), 1, 0)
	EndIf
	
EndIf

Return _lRet

/*/{Protheus.doc} CNHNFEGRV
Função responsável por associar notas fiscais com planos de transporte e solicitação de coleta.
@author 	Luiz Alexandre Ferreira
@since 		17/10/2014
@version 	1.0
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function CNHNFEGRV()

// ---	Variaveis utilizadas
Local	_nX		:=	0
Local	_lRet	:= .f.
Local _Chave 	:= ""

// ---	Laço nos documentos lidos
For _nX	:= 1 to Len(_aNfe)
	
	// ---	Somente os itens novos
	If _aNfe[_nX,1]
		_cChave :=	_aNfe[_nX,2]
		
		// ---	Inclusao de chaves lidas
		SZ6->(dbSetOrder(2))
		If SZ6->(dbSeek(xFilial("SZ6")+_cChave))
			
			//	---	Verifica se a chave veio antes da associação
			If SZ6->Z6_PLANID == 0
				RecLock('SZ6',.f.)
			EndIf
			
		Else
			
			//	---	Para chaves novas inclui registro
			RecLock('SZ6',.t.)
			
		EndIf
		
		SZ6->Z6_FILIAL	:=	xFilial('SZ6')
		SZ6->Z6_IDNFE	:= 	_aNfe[_nX,2]
		SZ6->Z6_NUMNFE	:=	_aNfe[_nX,3]
		SZ6->Z6_SERNFE	:=	_aNfe[_nX,4]
		SZ6->Z6_PLANID	:=	DF0->DF0_PLANID
		SZ6->(msUnLock())
		
		//	---	Flag de gravação
		_lRet	:= .t.
		
	EndIf
	
Next _nX

//	---	Exibe mensagem de gravação
If _lRet
	MsgInfo(OemToAnsi('Chave(s) gravada(s) com sucesso!'),'Ler Chave NF-e')
EndIf

Return

/*/{Protheus.doc} CNHNFEDEL
Função responsável por associar notas fiscais com planos de transporte e solicitação de coleta.
@author 	Luiz Alexandre Ferreira
@since 		17/10/2014
@version 	1.0
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function CNHNFEDEL()

//	---	Mensagem para validar a exclusão
If MsgYesNo(OemtoAnsi('Confirma remoção da chave NF-e : '+_aNfe[_oLsBoxNfe:nAt,nNFECHAVE] + CRLF +' Nfe : ' + _aNfe[_oLsBoxNfe:nAt,nNFEDOC] +' Serie : ' + _aNfe[_oLsBoxNfe:nAt,nNFESERIE] + ' ?' ),'Remove chave')
	
	//	---	Remove a chave do plano de transporte
	SZ6->(dbSetOrder(2))
	If SZ6->(dbSeek(xFilial('SZ6')+_aNfe[_oLsBoxNfe:nAt,nNFECHAVE]))
		
		//	---	Deleta registro
		RecLock('SZ6',.f.)
		SZ6->(dbDelete())
		SZ6->(msUnLock())
		
		//	---	Remove o elemento
		Adel( _aNfe, _oLsBoxNfe:nAt )
		
		//	---	Reorganiza o tamanho do array
		aSize( _aNfe, Len(_aNfe)-1 )
		
		//	---	Mensagem de remoção da chave
		MsgInfo('Item removido com sucesso!','Remove chave')
		
	EndIf
EndIf

Return
