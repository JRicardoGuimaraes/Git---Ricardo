#include "topconn.ch"
#include "protheus.ch"
static CR := chr(13) + chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEPUPDSX   บAutor  ณERP Plus            บ Data ณ  10/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para atualizacao de dicionario de dados             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Os registros que deverao ser incluidos nos arquivos SX de- บฑฑ
ฑฑบ          ณ vem ser gravados no diretorio definido na variavel _cDirOriบฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function UPDSX()
local _ni
Local _cMask     := "Arquivos Texto (*.TXT) |*.txt|"
local _oDlg

Private _cDirOri 	:= "\UPDSX\" // Caminho em relacao ao RootPath do Protheus
Private _aEmpresas	:= {}                                                
// Tabelas que serao usadas como base para atualizacao {}
Private _aArqAtu 	:= {"SX5","SXB","SIX","SX2","SX3","SX6","SX7","SXA"} 
Private _cLog 		:= ""
Private _cArqLog	:= _cDirOri + "ATUSX.LOG"
PRIVATE oMainWnd 
Private _cTexto

set deleted on

if !OpenSM0Exc() // Tenta abrir o SM0 Exclusivo
	Return
endif

RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL) // Abre ambiente da empresa

_aEmpresas := ProcEmp() // Carrega vetor com os codigos das empresas que serao consideradas na atualizacao

// Faz uma ultima confirmacao antes de executar a atualizacao
if !MsgYesNo("Confirma atualiza็ใo dos dicionแrios das empresas selecionadas?")
	SM0->(dbclosearea())
	return
endif

If ValidaArq() // Se achou os arquivos necessarios
/*
	DEFINE WINDOW oMainWnd FROM 000,000 TO 001,030 TITLE "Atualiza็ใo de Dicionแrio" 
	ACTIVATE WINDOW oMainWnd ON INIT (Processa({||ProcAtuSX()},"Atualizando Dicionแrios","Aguarde, processando preparacao dos arquivos",.F.),oMainWnd:end())
*/
	// Monta tela para executar a atualiza็ใo
	_cTexto := "Log da atualizacao" + CR
	DEFINE FONT _oFont NAME "Mono AS" SIZE 5,12   //6,15
	DEFINE MSDIALOG _oDlg TITLE "Atualiza็ใo do Dicionแrio." From 3,0 to 340,417 PIXEL OF oMainWnd
	@ 5,5 GET _oMemo  VAR _cTexto MEMO SIZE 200,145 OF _oDlg PIXEL
	_oMemo:bRClicked := {||AllwaysTrue()}
	_oMemo:oFont:= _oFont
	DEFINE SBUTTON  FROM 153,115 TYPE 1 ACTION Processa({||ProcAtuSX()},"Atualizando Dicionแrios","Aguarde, processando preparacao dos arquivos",.F.) ENABLE OF _oDlg PIXEL //Executa
	DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (_cFile := cGetFile(_cMask,""),If(_cFile="",.t.,MemoWrite(_cFile,_cTexto))) ENABLE OF _oDlg PIXEL //Salva e Apaga //"Salvar Como..."
	DEFINE SBUTTON  FROM 153,175 TYPE 2 ACTION _oDlg:End() ENABLE OF _oDlg PIXEL //Apaga
	ACTIVATE MSDIALOG _oDlg CENTER
else
	msgstop("Nใo existem dados a serem processados na pasta " + _cDirOri + ".")
	return
endif

return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcAtuSX บAutor  ณM Zanetti ERP Plus  บ Data ณ  10/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerencia atualizacao dos dicionarios                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function ProcAtuSX()
local _ni, _nj

_cTexto += "Inํcio: " + dtoc(date()) + " - " + time() + CR
_oMemo:Refresh()

ProcRegua(len(_aArqAtu)*len(_aEmpresas))

RpcClearEnv() // Para limpar a empresa aberta

// Varre todas empresas previamente selecionadas
for _ni := 1 to len(_aEmpresas)
	
	RpcSetType(3)
	RpcSetEnv(_aEmpresas[_ni, 1], _aEmpresas[_ni, 2]) // Abre ambiente da empresa
	
	_cTexto += "Processando empresa " + _aEmpresas[_ni, 1] + CR
	_oMemo:Refresh()
	
	for _nj := 1 to len(_aArqAtu) // Process a os arquivos colocados na pasta de trabalho
		
		IncProc("Processando empresa " + _aEmpresas[_ni, 1] + " - Arquivo " + _aArqAtu[_nj])
		
		dbUseArea(.T.,, _cDirOri + _aArqAtu[_nj] + GetDBExtension() , "MODELO", .F., .F.)
		AtuSX(_aArqAtu[_nj], _aEmpresas[_ni, 3])
		MODELO->(dbclosearea())
	next _nj
	
	_cTexto += "T้rmino empresa " + _aEmpresas[_ni, 1] + ": " + dtoc(date()) + " - " + time() + CR
	_oMemo:Refresh()
	memowrite(_cArqLog, _cTexto) // Grava o arquivo de log no final do processamento de cada empresa
	
	RpcClearEnv()
	
	If !( lOpen := OpenSM0Exc() )
		Exit
	EndIf
	
next _ni

SM0->(dbclosearea())

MsgInfo("Processo Finalizado!")

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuSX     บAutor  ณM Zanetti ERP Plus  บ Data ณ  10/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz atualizacao dos dicionarios                            บฑฑ
ฑฑบparametro ณ _cArq - Alias do Arquivo SX a ser verificado / atualizado  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function AtuSX(_cArq, _cFiliais)
local _aStru 	:= (_cArq)->(dbstruct())
local _aTabAlt	:= {}
local _ni
local _lNewReg
local _lAltReg

if _cArq == "SIX"
	
	SIX->(dbsetorder(1)) // INDICE + ORDEM
	DbSelectArea("MODELO")
	MODELO->(dbgotop())
	while MODELO->(!eof())
	
		_lNewReg := .T.
		_cOrdem  := ''
	
		DbSelectArea("SIX")
		DbSeek(MODELO->INDICE)
		Do While !Eof() .AND. SIX->INDICE = MODELO->INDICE
			_cOrdem := SIX->ORDEM
			If ALLTRIM(STRTRAN(SIX->CHAVE,' ','')) = ALLTRIM(STRTRAN(MODELO->CHAVE,' ','')) 
				_lNewReg := .F.
				Exit
			EndIf
			DbSkip()
		EndDo
		
		//_lNewReg := SIX->(!dbseek(MODELO->INDICE + MODELO->ORDEM))

		If _lNewReg
			_cOrdem := iif(!empty(_cOrdem), SOMA1(_cOrdem), '1')
		EndIf

		CriaReg(_cArq, _aStru, _lNewReg)

		RecLock("SIX",.F.) // Muda a ordem do indice
		SIX->ORDEM := _cOrdem
		MsUnlock()

		if ascan(_aTabAlt, SIX->INDICE) == 0
			aadd(_aTabAlt, SIX->INDICE)
		EndIf
		
		_cTexto += iif(_lNewReg, "Incluido", "Alterando") + " Registro no SIX - INDICE: " + SIX->INDICE +" - ORDEM: " + SIX->ORDEM + " - CHAVE: " + SIX->CHAVE + CR
		
		MODELO->(dbskip())
	enddo
	_oMemo:Refresh()
	
	// Forca atualizacao dos indices
	for _ni := 1 to len(_aTabAlt)
		If Select(_aTabAlt[_ni]) > 0
			dbSelecTArea(_aTabAlt[_ni])
			dbCloseArea()
		EndIf
		X31UpdTable(_aTabAlt[_ni])
		_cTexto += "Alterando indice da tabela: " + RetSQLName(_aTabAlt[_ni]) + CR
		_oMemo:Refresh()
	next _ni

elseif _cArq == "SX2"
	
	SX2->(dbsetorder(1)) // X2_CHAVE
	MODELO->(dbgotop())
	while MODELO->(!eof())

		_lNewReg := SX2->(!dbseek(MODELO->X2_CHAVE))

		CriaReg(_cArq, _aStru, _lNewReg)

		if Empty(SX2->X2_ARQUIVO)
			RecLock("SX2",.F.) // Muda o nome da tabela
			SX2->X2_ARQUIVO := SX2->X2_CHAVE + cEmpAnt + "0"
			MsUnlock()
		endif
		
		_cTexto += iif(_lNewReg, "Incluido", "Alterando") + " Registro no SX2 - X2_CHAVE: " + MODELO->X2_CHAVE + " - X2_ARQUIVO: " + SX2->X2_ARQUIVO + CR

		MODELO->(dbskip())
	enddo
	_oMemo:Refresh()
	

elseif _cArq == "SX3"
	
	SX3->(dbsetorder(2)) // X3_CAMPO
	MODELO->(dbgotop())
	while MODELO->(!eof())

		_lNewReg := SX3->(!dbseek(MODELO->X3_CAMPO))
			
		If _lNewReg
			_cOrdem := Soma1(RetMaxOrdem(MODELO->X3_ARQUIVO))
		Else
			_lAltReg := MODELO->X3_TAMANHO <> SX3->X3_TAMANHO .or. MODELO->X3_DECIMAL <> SX3->X3_DECIMAL .or. MODELO->X3_CONTEXT <> SX3->X3_CONTEXT
			_cOrdem := SX3->X3_ORDEM
		EndIf
			
		CriaReg(_cArq, _aStru, _lNewReg)
			
		RecLock("SX3",.F.) // Muda a ordem do campo para ultima disponivel para o arquivo
		SX3->X3_ORDEM := _cOrdem
		MsUnlock()
		
		// Adiciona na lista das tabelas a serem alteradas, caso o campo nao seja virtual
		if SX3->X3_CONTEXT <> "V" .and. ascan(_aTabAlt, SX3->X3_ARQUIVO) == 0 .and. (_lNewReg .or. _lAltReg)
			aadd(_aTabAlt, SX3->X3_ARQUIVO)
		endif

		_cTexto += iif(_lNewReg, "Incluido", "Alterando") + " Registro no SX3 - X3_CAMPO: " + MODELO->X3_CAMPO + CR

		MODELO->(dbskip())
	enddo
	_oMemo:Refresh()
	
	// Forca atualizacao das tabelas
	for _ni := 1 to len(_aTabAlt)
		If Select(_aTabAlt[_ni]) > 0
			dbSelecTArea(_aTabAlt[_ni])
			dbCloseArea()
		EndIf
		X31UpdTable(_aTabAlt[_ni])
		_cTexto += "Alterando estrutura da tabela: " + RetSQLName(_aTabAlt[_ni]) + CR
		_oMemo:Refresh()
	next _ni
	

elseif _cArq == "SX5"
	
	// Cuidado ao tratar SX5 compartilhado ou exclusivo
	if empty(xFilial("SX5"))
		_aFilial := {"  "}
	else
		_aFilial := {}
		_nPos 	 := 1
		_cFilial := substr(_cFiliais, _nPos, 2)
		while !empty(_cFilial)
			aadd(_aFilial, _cFilial)
			_nPos += 2
			_cFilial := substr(_cFiliais, _nPos, 2)
		enddo
	endif
	
	// Processa todas as filiais. No caso de SX5, processa apenas umas vez, com filial em branco
	for _ni := 1 to len(_aFilial)

		SX5->(dbsetorder(1)) // X5_FILIAL + X5_TABELA + X5_CHAVE
		MODELO->(dbgotop())

		while MODELO->(!eof())

			_lNewReg := SX5->(!dbseek(_aFilial[_ni] + MODELO->X5_TABELA + MODELO->X5_CHAVE))

			CriaReg(_cArq, _aStru, _lNewReg)

			RecLock("SX5",.F.) // Muda a filial para a escolhida
			SX5->X5_FILIAL := _aFilial[_ni]
			MsUnlock()

			_cTexto += iif(_lNewReg, "Incluido", "Alterando") + " Registro no SX5 - X5_FILIAL: " + _aFilial[_ni] + " - X5_TABELA: " + MODELO->X5_TABELA + " - X5_CHAVE: " + MODELO->X5_CHAVE + CR
			
			MODELO->(dbskip())
		enddo
		_oMemo:Refresh()
	next _ni

	
elseif _cArq == "SX6"
	
	SX6->(dbsetorder(1)) // X6_FIL + X6_VAR
	MODELO->(dbgotop())
	while MODELO->(!eof())

		_lNewReg := SX6->(!dbseek("  " + MODELO->X6_VAR))

		CriaReg(_cArq, _aStru, _lNewReg)

		RecLock("SX6",.F.) // Muda a filial para branco
		SX6->X6_FIL := "  "
		MsUnlock()

		_cTexto += iif(_lNewReg, "Incluido", "Alterando") + " Registro no SX6 - X6_VAR: " + MODELO->X6_VAR + CR
		
		MODELO->(dbskip())
	enddo
	_oMemo:Refresh()
	

elseif _cArq == "SX7"
	
	// ************************  TRATAR GATILHOS JA EXISTENTES ************************
	
	// LEMBRAR DE GRAVAR X3_TRIGGER
	SX7->(dbsetorder(1)) // X7_CAMPO + X7_SEQUENC
	SX3->(dbsetorder(2)) // X3_CAMPO
	MODELO->(dbgotop())
	while MODELO->(!eof())

		_lNewReg := SX7->(!dbseek(MODELO->X7_CAMPO + MODELO->X7_SEQUENC))
        
		if _lNewReg // *********** POR ENQUANTO, TRATA APENAS INCLUSAO - VERIFICAR CRITEIROS PARA ALTERACOES *************

			CriaReg(_cArq, _aStru, _lNewReg)

			if SX3->(dbseek(MODELO->X7_CAMPO))
				Reclock("SX3",.F.)
				SX3->X3_TRIGGER := "S"
				MsUnlock()
			endif
	
			_cTexto += iif(_lNewReg, "Incluido", "Alterando") + " Registro no SX7 - X7_CAMPO: " + MODELO->X7_CAMPO + " - X7_CDOMIN: " + MODELO->X7_CDOMIN + CR

		endif
		
		MODELO->(dbskip())
	enddo
	_oMemo:Refresh()

elseif _cArq == "SXA"
	
	SXA->(dbsetorder(1)) // XA_ALIAS + XA_ORDEM
	MODELO->(dbgotop())
	while MODELO->(!eof())

		_lNewReg := SXA->(!dbseek(MODELO->XA_ALIAS + MODELO->XA_ORDEM))

		CriaReg(_cArq, _aStru, _lNewReg)

		_cTexto += iif(_lNewReg, "Incluido", "Alterando") + " Registro no SXA - XA_ALIAS: " + MODELO->XA_ALIAS + " - XA_ORDEM: " + MODELO->XA_ORDEM + CR
		
		MODELO->(dbskip())
	enddo
	_oMemo:Refresh()
	

elseif _cArq == "SXB"  // Inclui apenas a consulta inteira
	
	SXB->(dbsetorder(1)) // XB_ALIAS + XB_TIPO + XB_SEQ + XB_COLUNA
	MODELO->(dbgotop())
	while MODELO->(!eof())

		_lNewReg := SXB->(!dbseek(MODELO->XB_ALIAS))

		_cAlias := MODELO->XB_ALIAS

		If _lNewReg

			while MODELO->(!eof()) .and. MODELO->XB_ALIAS == _cAlias
				CriaReg(_cArq, _aStru, .T.)
				MODELO->(dbskip())
			enddo

			_cTexto += "Incluidos Registros no SXB - XB_ALIAS: " + _cAlias + CR
		else
			DbSelectArea("SXB")
			Do While !Eof() .and. SXB->XB_ALIAS = MODELO->XB_ALIAS
				
				RecLock("SXB", .F.)
				DbDelete()
				SXB->(MsUnLock())
				
				SXB->(DbSkip())
			EndDo
			
			while MODELO->(!eof()) .and. MODELO->XB_ALIAS == _cAlias
				CriaReg(_cArq, _aStru, .T.)
				MODELO->(dbskip())
			enddo

			_cTexto += "Alterados Registros no SXB - XB_ALIAS: " + _cAlias + CR
		endif
	enddo
	_oMemo:Refresh()
endif

return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaReg   บAutor  ณM Zanetti ERP Plus  บ Data ณ  10/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria registro no arquivo SX                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function CriaReg(_cArq, _aStru, _lInclui)
local _nCampo

RecLock(_cArq,_lInclui)
for _nCampo := 1 to len(_aStru)
	&(_cArq + "->" + _aStru[_nCampo,1] + " := MODELO->" + _aStru[_nCampo,1])
next _nCampo
MsUnlock()

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetMaxOrdeบAutor  ณM Zanetti ERP Plus  บ Data ณ  10/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a maior ordem do SX3 para um arquivo               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function RetMaxOrdem(_cArquivo)
local _nReg := SX3->(Recno())
local _cRet	:= "00"

SX3->(dbsetorder(1))

if SX3->(dbseek(_cArquivo))
	while SX3->(!eof()) .and. SX3->X3_ARQUIVO == _cArquivo
		_cRet := SX3->X3_ORDEM
		SX3->(dbskip())
	enddo
endif

SX3->(dbsetorder(2))
SX3->(dbgoto(_nReg))

return(_cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPROCEMP   บAutor  ณM Zanetti ERP Plus  บ Data ณ  10/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Selecao das empresas que serao atualizadas                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function ProcEmp()
Local cMarca	:= "XX" //GetMark()
local nOpca 	:= 1
local lInverte	:= .F.
local _cEmpTroca	:= '  '
local _nRecSM0 	:= SM0->(recno())
Local oDlg
local _cFiliais := ""
local _aRet		:= {}
Local aCampos	:= {{"M0_OK","C",02,0 },{"M0_CODIGO","C",02,0 },{"M0_NOME","C",15,0 },{"M0_FILIAL","C",02,0 },{"M0_FILIAIS","C",200,0 }}
Local aCampos2 	:= {{"M0_OK",,"  ",""},{"M0_CODIGO",,"Cod. Empresa","@X"},{"M0_NOME",,"Nome Empresa","@X"}}
local _cArq 	:= CriaTrab(aCampos,.T.)

dbUseArea(.T.,,_cArq,"EMPRESA",.F.,.F.)
IndRegua("EMPRESA",CriaTrab(NIL,.F.),"M0_CODIGO",,,"Indexando Empresas")

// Carga do Alias EMPRESA com os dados do SM0
SM0->(dbgotop())
while SM0->(!eof())
	
	If _cEmpTroca <> SM0->M0_CODIGO
		_cFiliais := SM0->M0_CODFIL
		_cEmpTroca 	:= SM0->M0_CODIGO
		RecLock("EMPRESA",.T.)
		EMPRESA->M0_OK 		:= cMarca
		EMPRESA->M0_CODIGO	:= SM0->M0_CODIGO
		EMPRESA->M0_FILIAL	:= SM0->M0_CODFIL
		EMPRESA->M0_NOME	:= SM0->M0_NOME
	else
		_cFiliais += SM0->M0_CODFIL
		RecLock("EMPRESA",.F.)
	endif
	EMPRESA->M0_FILIAIS	:= _cFiliais
	MsUnlock()
	
	SM0->(dbskip())
	
enddo
SM0->(dbgoto(_nRecSM0))

EMPRESA->( dbGotop() )
DEFINE MSDIALOG oDlg TITLE "Selecione as empresas que deverใo ser consideradas" From 009,000 To 030,063 OF oMainWnd
oMark := MsSelect():New("EMPRESA","M0_OK","",aCampos2,@lInverte,@cMarca,{20,2,140,248})
oMark:oBrowse:bAllMark := {|| EMPRESA->(DBEVAL({||RecLock("EMPRESA",.F.),EMPRESA->M0_OK := iif(empty(EMPRESA->M0_OK),cMarca,""),MsUnlock()})), EMPRESA->(dbgotop())}
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End()},{|| nOpca := 2,oDlg:End()}) CENTERED

if nOpca == 1 // Confirmou o processamento
	EMPRESA->(dbgotop())
	while EMPRESA->(!eof())
		dbselectarea("EMPRESA")
		if IsMark("M0_OK",cMarca,lInverte) // Se a empresa foi marcada, checa os modos de compartilhamento dos arquivos
			AADD( _aRet, {EMPRESA->M0_CODIGO, EMPRESA->M0_FILIAL, EMPRESA->M0_FILIAIS} )
		endif
		EMPRESA->(dbskip())
	enddo
endif

EMPRESA->(dbclosearea())

return(_aRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณValidaArq  ณ Autor ณERP Plus              ณ Data ณ10/07/2008ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica os arquivos que serao atualizados                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function ValidaArq()
local _ni
local _aRet := {}
local _lRet	:= .F.

for _ni := 1 to len(_aArqAtu)
	if file(_cDirOri + _aArqAtu[_ni] + GetDBExtension())
		aadd(_aRet, _aArqAtu[_ni])
		_lRet	:= .T.
	endif
next _ni

_aArqAtu := aclone(_aRet)

return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณOpenSM0Exc ณ Autor ณERP Plus              ณ Data ณ10/07/2008ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Efetua a abertura do SM0 exclusivo                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static Function OpenSM0Exc()
Local _lOpen := .F.
Local _nLoop := 0

For _nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. )
	If !Empty( Select( "SM0" ) )
		_lOpen := .T.
		dbSetIndex("SIGAMAT.IND")
		Exit
	EndIf
	Sleep( 500 )
Next _nLoop

If !_lOpen
	MsgStop("Nao foi possivel a abertura da tabela de empresas de forma exclusiva !")
EndIf

Return(_lOpen )
