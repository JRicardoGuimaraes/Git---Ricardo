#include "protheus.ch"
#include "topconn.ch"

///////////////////////////////////////////////////////////////////////////////
// Programa:   GEFCORTE                                    	Data: 23/10/2012 //
// Descricao:  Rotina para Corte na Base de Dados                            //
// Autor:      +Solucos Consultoria                                          //
///////////////////////////////////////////////////////////////////////////////

User Function GEFCORTE

// Declaracao de Variaveis
Private cCadastro := "Tabelas para Corte na Base"
Private aRotina   := {}
Private cDelFunc  := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString   := "SZZ"

// cria diretorios
MontaDir("\corte_base\")
MontaDir("\corte_base\backup\")
MontaDir("\corte_base\historico\")

// define rotinas proprias
AADD(aRotina,{"Pesquisar"   ,"AxPesqui"    ,0,1})
AADD(aRotina,{"Visualizar"  ,"AxVisual"    ,0,2})
AADD(aRotina,{"Incluir"     ,"AxInclui"    ,0,3})
AADD(aRotina,{"Alterar"     ,"AxAltera"    ,0,4})
AADD(aRotina,{"Excluir"     ,"AxDeleta"    ,0,5})
AADD(aRotina,{"Historico"   ,"U_fZZHist"   ,0,5})
AADD(aRotina,{"Simular"     ,"U_fZZSimular",0,5})
AADD(aRotina,{"Executar"    ,"U_fZZExec"   ,0,5})
AADD(aRotina,{"Lista Tab BD","U_fTabBanco" ,0,3})

// abre o browse
dbSelectArea("SZZ")
dbSetOrder(1)
dbSelectArea(cString)
dbGoTop()
mBrowse( 6,1,22,75,cString)

// retorna
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function fZZCampo
// declaracao de variaveis
Local _aArea    := GetArea()
Local _aAreaSX3 := SX3->(GetArea())
Local _lRet     := .T.

// busca se campo existe
DbSelectArea("SX3")
DbSetOrder(2)
DbGoTop()
If DbSeek(M->ZZ_DATA)
	If SX3->X3_TIPO <> "D"
		MsgAlert("Campo informado, deve ser do tipo DATA para que possa ser filtrado no momento da execucao do Corte na Base, verifique!")
		_lRet := .F.
	Endif
Else
	MsgAlert("Campo informado nao foi encontrado, verifique!")
	_lRet := .F.
Endif

// retorna
RestArea(_aAreaSX3)
RestArea(_aArea)
Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function fZZRetCampo
Local _cRet := POSICIONE("SX3",2,SZZ->ZZ_DATA,"X3_TITULO")+" / "+POSICIONE("SX3",2,SZZ->ZZ_DATA,"X3_DESCRIC")
Return(_cRet)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function fZZSimular

// declaracao de variaveis
Local _aArea := GetArea()
Private _aListSTA := {}, _oListSTA
Private _aListTAB := {}, _oListTAB
Private _dSimData := CTOD(""), _oSimData
Private _nSimTam  := 0       , _oSimTam
Private _nSimReg  := 0       , _oSimReg
Private _nSimPer  := 0       , _oSimPer

// busca informacoes do Banco de Dados
_cQry := "SELECT DISTINCT TABLE_CATALOG FROM INFORMATION_SCHEMA.TABLES"
TCQUERY _cQry NEW ALIAS "TRB"
_cDataBase := TRB->TABLE_CATALOG
TRB->(DbCloseArea())

//AADD(_aListSTA,{"TopConnect Alias: " + Space(20),""})
AADD(_aListSTA,{"Banco de Dados: "+Space(10),TcGetDB()})
AADD(_aListSTA,{"DataBase: "      ,_cDataBase})

// EXECUTA STORED PROCEDURE PARA BUSCAR NOME DO BANCO DE DADOS
_aResult := TcSpExec("sp_apaceused",100)
/*
If Empty(_aResult)
MsgInfo('Erro na execução da Stored Procedure [sp_spaceused] : '+TcSqlError())
Else
MsgInfo("Procedure Executada")
Endif
*/

// busca espaco total do banco de dados
_cQry := "SELECT sum(dpages)   AS TAM_DB,"
_cQry += "       sum(reserved) AS TAM_RE,"
_cQry += "       sum(used)     AS TAM_US"
_cQry += " FROM sysindexes"
_cQry += " WHERE indid in (1,0) and objectproperty(id,'isusertable')=1"
TCQUERY _cQry NEW ALIAS "TRB"
_nTamBase   := Round((TRB->TAM_DB*8)/1024,2)
_nReservado := Round((TRB->TAM_RE*8)/1024,2)
_nUsado     := Round((TRB->TAM_US*8)/1024,2)
_nEspaco    := _nReservado-_nUsado
_nTamLog    := 0
AADD(_aListSTA,{"Tamanho DataBase [MB]"   ,TransForm(_nTamBase  ,"@E 999,999,999")})
AADD(_aListSTA,{"Tamanho Log [MB]"        ,TransForm(_nTamLog   ,"@E 999,999,999")})
AADD(_aListSTA,{"Tamanho Reservado [MB]"  ,TransForm(_nReservado,"@E 999,999,999")})
AADD(_aListSTA,{"Tamanho Usado [MB]"      ,TransForm(_nUsado    ,"@E 999,999,999")})
AADD(_aListSTA,{"Espaco nao alocado [MB]" ,TransForm(_nEspaco   ,"@E 999,999,999")})
TRB->(DbCloseArea())

// busca dados por tabela
Processa({|| fListTAB(.F.)},"GEFCO - Corte na Base [ Info Tabelas ]")

// monta tela para exibir os registros
DEFINE MSDIALOG _oSimular TITLE OemToAnsi("Status Atual das Tabelas e Banco de Dados") FROM 000,000 TO 565,950 PIXEL OF GetWndDefault()

@ 005,002 LISTBOX _oListSTA FIELDS HEADER OemToAnsi("Descricao"),OemToAnsi("Conteudo") SIZE 190,81 OF _oSimular PIXEL
_oListSTA:SetArray(_aListSTA)
_oListSTA:bLine   := { ||{_aListSTA[_oListSTA:nAT,1],_aListSTA[_oListSTA:nAT,2]}}
_oListSTA:SetFocus(.T.)

@ 091,002 LISTBOX _oListTAB FIELDS HEADER OemToAnsi("Tabela"),;
OemToAnsi("Nome"),;
OemToAnsi("Banco"),;
OemToAnsi("Tamanho"),;
OemToAnsi("Registros"),;
OemToAnsi("Simulacao (Tam)"),;
OemToAnsi("Simulacao (Reg)"),;
OemToAnsi("Percentual") SIZE 474,190 OF _oSimular PIXEL
_oListTAB:SetArray(_aListTAB)
_oListTAB:bLine   := { ||{_aListTAB[_oListTAB:nAT,1],_aListTAB[_oListTAB:nAT,2],_aListTAB[_oListTAB:nAT,3],_aListTAB[_oListTAB:nAT,4],_aListTAB[_oListTAB:nAT,5],_aListTAB[_oListTAB:nAT,7],_aListTAB[_oListTAB:nAT,8],_aListTAB[_oListTAB:nAT,9]}}

@ 005,200 TO 081,474 LABEL "Simulacao Corte na Base" OF _oSimular PIXEL
@ 015,205 SAY "Data de Corte" SIZE 50,08 OF _oSimular PIXEL
@ 013,255 MSGET _oSimData VAR _dSimData SIZE 50,10 OF _oSimular PIXEL
@ 015,335 SAY "Tamanho [MB]" SIZE 50,08 OF _oSimular PIXEL
@ 013,390 MSGET _oSimTam  VAR _nSimTam When .F. Picture "@E 999,999,999" SIZE 35,10 OF _oSimular PIXEL
@ 030,335 SAY "Registros" SIZE 50,08 OF _oSimular PIXEL
@ 028,390 MSGET _oSimReg  VAR _nSimReg When .F. Picture "@E 999,999,999" SIZE 35,10 OF _oSimular PIXEL
@ 045,335 SAY "Percentual" SIZE 50,08 OF _oSimular PIXEL
@ 043,390 MSGET _oSimPer  VAR _nSimPer When .F. Picture "@E 999.99" SIZE 35,10 OF _oSimular PIXEL

@ 060,205 BUTTON OemToAnsi("Simular") SIZE 30,10 OF _oSimular ACTION(fSimular()) PIXEL

ACTIVATE DIALOG _oSimular CENTERED


// retorna
RestArea(_aArea)
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fSimular
LjMsgRun("Simulando tamanho/registros do corte na base...","GEFCO - Corte na Base",{|| fExecSimula()})
Return

Static Function fExecSimula
Local _aArea := GetArea()
For _nI := 1 To Len(_aListTAB)
	// busca quantidade de registros que seram excluidos
	_cQry := "SELECT COUNT(*) AS REGISTROS FROM " + _aListTAB[_nI,3]
	_cQry += "    WHERE " + AllTrim(_aListTAB[_nI,10]) + " <= '" + DTOS(_dSimData) + "'"
	If !Empty(_aListTAB[_nI,11])
		_cQry += " AND " + AllTrim(_aListTAB[_nI,11])
	Endif
	TCQUERY _cQry NEW ALIAS "TRB"
	_nRegistros := TRB->REGISTROS
	_nPerc      := Round((TRB->REGISTROS*100)/_aListTAB[_nI,15],2)
	_nTamanho   := _nRegistros * (_aListTAB[_nI,14]/_aListTAB[_nI,15])
	_aListTAB[_nI,07] := TransForm(_nTamanho,"@E 999,999,999") + " MB"
	_aListTAB[_nI,08] := TransForm(_nRegistros,"@E 999,999,999")
	_aListTAB[_nI,09] := TransForm(_nPerc,"@E 999.99")
	_nSimReg += TRB->REGISTROS
	_nSimTam += _nTamanho
	TRB->(DbCloseArea())
Next
// atualiza percentual da base de dados completa
_nSimPer := Round((_nSimTam*100)/_nUsado,2)
// atualiza registros na tela
_oListTAB:aArray := aClone(_aListTAB)
_oListTAB:Refresh()
_oSimReg:Refresh()
_oSimTam:Refresh()
_oSimPer:Refresh()
_oSimular:Refresh()
// retonra
RestArea(_aArea)
Return



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fListTAB(_lExecuta)
// declaracao de variaveis
Local _aArea := Getarea()
// variaveis de simulacao
_nSimTam := 0
_nSimReg := 0
_nSimPer := 0
// processa tabelas
DbSelectArea("SZZ")
DbSetOrder(1)
ProcRegua(RecCount())
While !SZZ->(EOF())
	IncProc("Tabela: " + SZZ->ZZ_TABELA + " " + POSICIONE("SX2",1,SZZ->ZZ_TABELA,"X2_NOME"))
	// busca numero do ID da tabela no banco de dados
	_cQry := "SELECT ID FROM sysobjects WHERE NAME = '" + RetSqlName(SZZ->ZZ_TABELA) + "'"
	TCQUERY _cQry NEW ALIAS "TRB"
	_nIdTabela := TRB->ID
	TRB->(DbCloseArea())
	// busca tamanho da tabela
	_cQry := "SELECT dpages as Tamanho, rowcnt as Registros"
	_cQry += " FROM sysindexes"
	_cQry += " WHERE id = "  + AllTrim(Str(_nIdTabela)) + " and"
	_cQry += " indid in (1,0) and objectproperty(id,'isusertable')=1"
	TCQUERY _cQry NEW ALIAS "TRB"
	_nTamanho   := Round((TRB->TAMANHO*8)/1024,2)
	_nRegistros := TRB->REGISTROS
	TRB->(DbCloseArea())
	// busca registros excluidos
	_cQry := "SELECT COUNT(*) AS EXCLUIDOS FROM " + RetSqlName(SZZ->ZZ_TABELA)
	_cQry += "  WHERE D_E_L_E_T_ = '*'"
	TCQUERY _cQry NEW ALIAS "TRB"
	_nExcluidos := TRB->EXCLUIDOS
	TRB->(DbCloseArea())
	// adiciona no array
	AADD(_aListTAB,Array(99))
	_aListTAB[Len(_aListTAB),01] := SZZ->ZZ_TABELA
	_aListTAB[Len(_aListTAB),02] := POSICIONE("SX2",1,SZZ->ZZ_TABELA,"X2_NOME")
	_aListTAB[Len(_aListTAB),03] := RetSqlName(SZZ->ZZ_TABELA)
	_aListTAB[Len(_aListTAB),04] := TransForm(_nTamanho,"@E 999,999,999") + " MB"
	_aListTAB[Len(_aListTAB),05] := TransForm(_nRegistros,"@E 999,999,999")
	_aListTAB[Len(_aListTAB),06] := TransForm(_nExcluidos,"@E 999,999,999")
	_aListTAB[Len(_aListTAB),07] := TransForm(_nSimTam,"@E 999,999,999") + " MB"
	_aListTAB[Len(_aListTAB),08] := TransForm(_nSimReg,"@E 999,999,999")
	_aListTAB[Len(_aListTAB),09] := TransForm(_nSimPer,"@E 999.99")
	_aListTAB[Len(_aListTAB),10] := SZZ->ZZ_DATA
	_aListTAB[Len(_aListTAB),11] := SZZ->ZZ_FILTRO
	_aListTAB[Len(_aListTAB),14] := _nTamanho
	_aListTAB[Len(_aListTAB),15] := _nRegistros
	_aListTAB[Len(_aListTAB),16] := _nExcluidos
	_aListTAB[Len(_aListTAB),17] := _nSimTam
	_aListTAB[Len(_aListTAB),18] := _nSimReg
	_aListTAB[Len(_aListTAB),19] := _nSimPer
	_aListTAB[Len(_aListTAB),99] := .T.
	// caso seja execuacao
	If _lExecuta
		_nI := Len(_aListTAB)
		// busca quantidade de registros que seram excluidos
		_cQry := "SELECT COUNT(*) AS REGISTROS FROM " + _aListTAB[_nI,3]
		_cQry += "    WHERE " + AllTrim(_aListTAB[_nI,10]) + " <= '" + DTOS(_dSimData) + "'"
		If !Empty(_aListTAB[_nI,11])
			_cQry += " AND " + AllTrim(_aListTAB[_nI,11])
		Endif
		TCQUERY _cQry NEW ALIAS "TRB"
		_nRegistros := TRB->REGISTROS
		_nPerc      := Round((TRB->REGISTROS*100)/_aListTAB[_nI,15],2)
		_nTamanho   := _nRegistros * (_aListTAB[_nI,14]/_aListTAB[_nI,15])
		_aListTAB[_nI,07] := TransForm(_nTamanho,"@E 999,999,999") + " MB"
		_aListTAB[_nI,08] := TransForm(_nRegistros,"@E 999,999,999")
		_aListTAB[_nI,09] := TransForm(_nPerc,"@E 999.99")
		_nSimReg += TRB->REGISTROS
		_nSimTam += _nTamanho
		TRB->(DbCloseArea())
	Endif
	// proxima tabela
	DbSelectArea("SZZ")
	DbSkip()
End
// atualiza percentual
If _lExecuta
	_nSimPer := Round((_nSimTam*100)/_nUsado,2)
Endif
// retorna
RestArea(_aArea)
Return


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function fZZExec

// declaracao de variaveis
Local _aArea := GetArea()
Local oNoMarked   := LoadBitmap( GetResources(), "LBNO" )
Local oMarked     := LoadBitmap( GetResources(), "LBOK" )
Private _aListSTA := {}, _oListSTA
Private _aListTAB := {}, _oListTAB
Private _dSimData := CTOD(""), _oSimData
Private _nSimTam  := 0       , _oSimTam
Private _nSimReg  := 0       , _oSimReg
Private _nSimPer  := 0       , _oSimPer
Private _aRegs	  := {}
Private _cPerg    := "GEFCOREXEC"

// busca informacoes do Banco de Dados
_cQry := "SELECT DISTINCT TABLE_CATALOG FROM INFORMATION_SCHEMA.TABLES"
TCQUERY _cQry NEW ALIAS "TRB"
_cDataBase := TRB->TABLE_CATALOG
TRB->(DbCloseArea())

//AADD(_aListSTA,{"TopConnect Alias: " + Space(20),""})
AADD(_aListSTA,{"Banco de Dados: "+Space(10),TcGetDB()})
AADD(_aListSTA,{"DataBase: "      ,_cDataBase})

//Pergunta a série das RPS e a data de inicio para a busca
AADD(_aRegs,{_cPerg,"01","Data Corte","","","MV_CHA","D",008,0,0,"G","","MV_PAR01",""     ,"","","","",""          ,"","","","","","","","","","","","","","","","","","","   ","",""})
ValidPerg(_aRegs,_cPerg)
If !Pergunte(_cPerg,.T.)
	RestArea(_aArea)
	Return
Endif

// data do corete
_dSimData := MV_PAR01

// busca espaco total do banco de dados
_cQry := "SELECT sum(dpages)   AS TAM_DB,"
_cQry += "       sum(reserved) AS TAM_RE,"
_cQry += "       sum(used)     AS TAM_US"
_cQry += " FROM sysindexes"
_cQry += " WHERE indid in (1,0) and objectproperty(id,'isusertable')=1"
TCQUERY _cQry NEW ALIAS "TRB"
_nTamBase   := Round((TRB->TAM_DB*8)/1024,2)
_nReservado := Round((TRB->TAM_RE*8)/1024,2)
_nUsado     := Round((TRB->TAM_US*8)/1024,2)
_nEspaco    := _nReservado-_nUsado
_nTamLog    := 0
AADD(_aListSTA,{"Tamanho DataBase [MB]"   ,TransForm(_nTamBase  ,"@E 999,999,999")})
AADD(_aListSTA,{"Tamanho Log [MB]"        ,TransForm(_nTamLog   ,"@E 999,999,999")})
AADD(_aListSTA,{"Tamanho Reservado [MB]"  ,TransForm(_nReservado,"@E 999,999,999")})
AADD(_aListSTA,{"Tamanho Usado [MB]"      ,TransForm(_nUsado    ,"@E 999,999,999")})
AADD(_aListSTA,{"Espaco nao alocado [MB]" ,TransForm(_nEspaco   ,"@E 999,999,999")})
TRB->(DbCloseArea())

// busca dados por tabela
Processa({|| fListTAB(.T.)},"GEFCO - Corte na Base [ Info Tabelas ]")

// monta tela para exibir os registros
DEFINE MSDIALOG _oSimular TITLE OemToAnsi("Status Atual das Tabelas e Banco de Dados") FROM 000,000 TO 565,950 PIXEL OF GetWndDefault()

@ 005,002 LISTBOX _oListSTA FIELDS HEADER OemToAnsi("Descricao"),OemToAnsi("Conteudo") SIZE 190,81 OF _oSimular PIXEL
_oListSTA:SetArray(_aListSTA)
_oListSTA:bLine   := { ||{_aListSTA[_oListSTA:nAT,1],_aListSTA[_oListSTA:nAT,2]}}
_oListSTA:SetFocus(.T.)

@ 091,002 LISTBOX _oListTAB FIELDS HEADER OemToAnsi(""),;
OemToAnsi("Tabela"),;
OemToAnsi("Nome"),;
OemToAnsi("Banco"),;
OemToAnsi("Tamanho"),;
OemToAnsi("Registros"),;
OemToAnsi("Simulacao (Tam)"),;
OemToAnsi("Simulacao (Reg)"),;
OemToAnsi("Percentual") SIZE 474,190 OF _oSimular PIXEL
_oListTAB:SetArray(_aListTAB)
_oListTAB:bLine   := { ||{IIF(_aListTAB[_oListTAB:nAT,99],oMarked,oNoMarked),_aListTAB[_oListTAB:nAT,1],_aListTAB[_oListTAB:nAT,2],_aListTAB[_oListTAB:nAT,3],_aListTAB[_oListTAB:nAT,4],_aListTAB[_oListTAB:nAT,5],_aListTAB[_oListTAB:nAT,7],_aListTAB[_oListTAB:nAT,8],_aListTAB[_oListTAB:nAT,9]}}
_oListTAB:bLDblClick := { || fMarkTAB() }
@ 005,200 TO 081,474 LABEL "Execucao Corte na Base" OF _oSimular PIXEL
@ 015,205 SAY "Data de Corte" SIZE 50,08 OF _oSimular PIXEL
@ 013,255 MSGET _oSimData VAR _dSimData WHEN .F. SIZE 50,10 OF _oSimular PIXEL
@ 030,205 SAY "Tamanho [MB]" SIZE 50,08 OF _oSimular PIXEL
@ 028,255 MSGET _oSimTam  VAR _nSimTam When .F. Picture "@E 999,999,999" SIZE 35,10 OF _oSimular PIXEL
@ 045,205 SAY "Registros" SIZE 50,08 OF _oSimular PIXEL
@ 043,255 MSGET _oSimReg  VAR _nSimReg When .F. Picture "@E 999,999,999" SIZE 35,10 OF _oSimular PIXEL
@ 060,205 SAY "Percentual" SIZE 50,08 OF _oSimular PIXEL
@ 058,255 MSGET _oSimPer  VAR _nSimPer When .F. Picture "@E 999.99" SIZE 35,10 OF _oSimular PIXEL

@ 045,440 BUTTON OemToAnsi("Executar") SIZE 30,10 OF _oSimular ACTION(fExecutar()) PIXEL
@ 060,440 BUTTON OemToAnsi("Cancela")  SIZE 30,10 OF _oSimular ACTION(_oSimular:End()) PIXEL

ACTIVATE DIALOG _oSimular CENTERED


// retorna
RestArea(_aArea)
Return

Static Function fMarkTAB
If _aListTAB[_oListTAB:nAT,99]
	_aListTAB[_oListTAB:nAT,99] := .F.
Else
	_aListTAB[_oListTAB:nAT,99] := .T.
Endif
_oListTAB:aArray := aClone(_aListTAB)
_oListTAB:Refresh()
Return

Static Function fExecutar
If MsgYesNo("Confirma a execu;áo do corte na base de dados para excluir definitivamente os registros das tabelas?")
	oProcess := MsNewProcess():New({|lEnd| fExecCorte(oProcess)},"GEFCO - Corte na Base [ Executando ]","Lendo...",.T.)
	oProcess:Activate()
	MsgInfo("Corte na Base concluido com sucesso, para consultas use o botao de historico no browe!")
	_oSimular:End()
Endif
Return

Static Function fExecCorte(oObj)

// quebra linha
_cEOF := Chr(13)+Chr(10)

// define nome do arquivo de log
_cDataHora := dtos(date())+"_"+LEFT(StrTran(time(),":",""),4)
_cArqHist  := "\corte_base\historico\"+_cDataHora+".txt"
_aArqHist  := {}
_cDirBack  := "\corte_base\backup\"+_cDataHora+"\"
_nHandle   := FCreate(_cArqHist,0)
If _nHandle == -1 .Or. !File(_cArqHist)
	MsgAlert("Arquivo de historico [" + _cArqHist + "] nao pode ser criado corretamente. Verifique!")
	Return
Endif

// cria diretorio para os registros de backup
MontaDir(_cDirBack)

// cria linhas com informacoes iniciais da base de dados
AADD(_aArqHist,"INICIO EXECUCAO DO CORTE NA BASE DE DADOS: " + DTOC(DATE()) + " " + LEFT(TIME(),5))
AADD(_aArqHist,"FINAL EXECUCAO DO CORTE NA BASE DE DADOS: " + DTOC(DATE()) + " " + LEFT(TIME(),5))
AADD(_aArqHist,"***")
AADD(_aArqHist,"DATA REFERENCIA: " + DTOC(MV_PAR01))
AADD(_aArqHist,"***")

// grava detalhes do banco de dados
AADD(_aArqHist,"Status Base de Dados [ ANTES ]")
For _nS := 1 To Len(_aListSTA)
	AADD(_aArqHist,_aListSTA[_nS,1]+" "+_aListSTA[_nS,2])
Next
AADD(_aArqHist,"***")

// acerta para visualizar registros excluidos
SET DELETED OFF

// processa tabelas
oObj:SetRegua1(Len(_aListTAB))
For _nT := 1 to Len(_aListTAB)
	oObj:IncRegua1(_aListTAB[_nT,3]+" "+_aListTAB[_nT,2])
	If _aListTAB[_nT,99]
		// monta linha para LOG
		_cLogTAB := "\corte_base\historico\"+_cDataHora+"_"+_aListTAB[_nT,3]+".txt"
		_nHanTAB := FCreate(_cLogTAB,0)
		_cLinTAB := "CORTE NA BASE"+_cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
		_cLinTAB := "TABELA " + _aListTAB[_nT,1] + " " + _aListTAB[_nT,2]+_cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
		_cLinTAB := "CAMPO DATA " + _aListTAB[_nT,10] +_cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
		If !Empty(_aListTAB[_nT,11])
			_cLinTAB := "FILTRO ADICIONAL " + _aListTAB[_nT,11] +_cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
		Endif
		_cLinTAB := "Arquivo Log [ " + _cLogTAB + " ]"+_cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
		// abre tabela no banco de dados
		_cTabela := _aListTAB[_nT,3]
		// atualiza log
		_cArqBkp := _cDirBack + _cTabela + ".dbf"
		_cLinTAB := "Arquivo Backup [ " + _cArqBkp + " ]"+_cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
		_cLinTAB := "***"+_cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
		_cLinTAB := "Tamanho Tabela [ " + _aListTAB[_nT,04] + " ]"+_cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
		_cLinTAB := "Registros na Tabela [ " + _aListTAB[_nT,05] + " ]"+_cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
		// cria tabela de backup
		_nTotReg := 0
		If GetNewPar("MV_XBKPCOR",.F.)
			DbUseArea(.T.,"TOPCONN",_cTabela,"TAB",.T.,.F.)
			If File(_cArqBkp); fErase(_cArqBkp); Endif
			COPY STRUCTURE TO &(_cArqBkp)
			DbUseArea(.T.,,_cArqBkp,"BKP",.T.,.F.)
			// abre tabela no top
			oObj:SetRegua2(3)
			oObj:IncRegua2("Abrindo tabela no banco de dados...")
			_cQry := "SELECT R_E_C_N_O_ AS REG FROM " + _aListTAB[_nT,3]
			_cQry += "    WHERE " + AllTrim(_aListTAB[_nT,10]) + " <= '" + DTOS(MV_PAR01) + "'"
			If !Empty(_aListTAB[_nT,11])
				_cQry += " AND " + AllTrim(_aListTAB[_nT,11])
			Endif
			_cQry += " ORDER BY  " + AllTrim(_aListTAB[_nT,10])
			TCQUERY _cQry NEW ALIAS "TRB"
			oObj:IncRegua2("Verificando registros...")
			_nTabReg := rfRecCount("TRB")
			oObj:SetRegua2(_nTabReg)
			// copia os registros
			DbSelectArea("TRB")
			While !TRB->(Eof())
				// posiciona na tabela original
				DbSelectArea("TAB")
				DbGoTo(TRB->REG)
				_dData := &("TAB->"+_aListTAB[_nT,10])
				oObj:IncRegua2("Data  Referencia...: " + DTOC(_dData))
				// copia registro
				DbSelectArea("BKP")
				If RecLock("BKP",.T.)
					For _nI := 1 To fCount()
						FieldPut(FieldPos(FieldName(_nI)),&("TAB->"+FieldName(_nI)))
					Next
					If TAB->(Deleted())
						BKP->(DbDelete())
					Endif
					BKP->(MsUnlock())
				Endif
				_nTotReg++
				DbSelectArea("TRB")
				TRB->(DbSkip())
			End
			// fecha todas tabelas
			TRB->(DbCloseArea())
			BKP->(DbCloseArea())
			TAB->(DbCloseArea())
		Else
			_cLinTAB := "Optado por não realizar arquivo Backup [ " + _cArqBkp + " ]"+_cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
		Endif
		oObj:IncRegua2("Limpando registros da tabela")
		_cDelReg := "DELETE FROM " + _aListTAB[_nT,3]
		_cDelReg += "    WHERE " + AllTrim(_aListTAB[_nT,10]) + " <= '" + DTOS(_dSimData) + "'"
		If !Empty(_aListTAB[_nT,11])
			_cDelReg += " AND " + AllTrim(_aListTAB[_nT,11])
		Endif
		If TcSQLExec(_cDelReg) < 0
			_cErroTAB := TcSqlError()
			_cLinTAB := "Erro ao excluir registros da tabela: " + _cEOF + _cErroTAB + _cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
			MsgAlert(_cLinTAB)
		EndIf
		oObj:IncRegua2("Verificando status atual da tabela")
		_cLinTAB := "***"+_cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
		_cLinTAB := "Registros Exportados [ " + TransForm(_nTotReg,"@E 999,999,999") + " ]"+_cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
		_cLinTAB := "***"+_cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
		// busca numero do ID da tabela no banco de dados
		_cQry := "SELECT ID FROM sysobjects WHERE NAME = '" + _aListTAB[_nT,3] + "'"
		TCQUERY _cQry NEW ALIAS "TRB"
		_nIdTabela := TRB->ID
		TRB->(DbCloseArea())
		// busca tamanho da tabela
		_cQry := "SELECT dpages as Tamanho, rowcnt as Registros"
		_cQry += " FROM sysindexes"
		_cQry += " WHERE id = "  + AllTrim(Str(_nIdTabela)) + " and"
		_cQry += " indid in (1,0) and objectproperty(id,'isusertable')=1"
		TCQUERY _cQry NEW ALIAS "TRB"
		_nTamanho   := Round((TRB->TAMANHO*8)/1024,2)
		_nRegistros := TRB->REGISTROS
		TRB->(DbCloseArea())
		_cLinTAB := "Tamanho Atual [ " +TransForm(_nTamanho,"@E 999,999,999") + " MB" + " ]"+_cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
		_cLinTAB := "Registros Atuais [ " + TransForm(_nRegistros,"@E 999,999,999") + " ]"+_cEOF; fWrite(_nHanTAB,_cLinTAB,Len(_cLinTAB))
		// fecha arquivo de log
		fClose(_nHanTAB)
	Endif
Next

// realiza shrink
oObj:SetRegua1(2)
oObj:IncRegua1("Shrink Database")

// realiza shrink
oObj:SetRegua2(2)
oObj:IncRegua2("Executando...")

// efetua shrink depois da exclusao
/*
_cShrink := "DBCC SHRINKDATABASE("+_aListSTA[2,2]+",1)"  // PERCENTUAL DE ESPA;O LIVRE
If TcSqlExec(_cShrink) < 0
	_cErroTAB := TcSqlError()
	_cLinTAB := "Erro ao excluir executar SHRINKFILE: " + _cEOF + _cErroTAB + _cEOF
	AADD(_aArqHist,"Status Base de Dados [ SHRINK-ERRO ]")
	AADD(_aArqHist,_cErroTAB)
	AADD(_aArqHist,"****")
	MsgAlert(_cLinTAB)
Endif
*/

// grava status da base de dados, depois
_aListDEP := {}
_cQry := "SELECT sum(dpages)   AS TAM_DB,"
_cQry += "       sum(reserved) AS TAM_RE,"
_cQry += "       sum(used)     AS TAM_US"
_cQry += " FROM sysindexes"
_cQry += " WHERE indid in (1,0) and objectproperty(id,'isusertable')=1"
TCQUERY _cQry NEW ALIAS "TRB"
_nTamBase   := Round((TRB->TAM_DB*8)/1024,2)
_nReservado := Round((TRB->TAM_RE*8)/1024,2)
_nUsado     := Round((TRB->TAM_US*8)/1024,2)
_nEspaco    := _nReservado-_nUsado
_nTamLog    := 0
AADD(_aListDEP,{"Tamanho DataBase [MB]"   ,TransForm(_nTamBase  ,"@E 999,999,999")})
AADD(_aListDEP,{"Tamanho Log [MB]"        ,TransForm(_nTamLog   ,"@E 999,999,999")})
AADD(_aListDEP,{"Tamanho Reservado [MB]"  ,TransForm(_nReservado,"@E 999,999,999")})
AADD(_aListDEP,{"Tamanho Usado [MB]"      ,TransForm(_nUsado    ,"@E 999,999,999")})
AADD(_aListDEP,{"Espaco nao alocado [MB]" ,TransForm(_nEspaco   ,"@E 999,999,999 ")})
TRB->(DbCloseArea())
AADD(_aArqHist,"Status Base de Dados [ DEPOIS ]")
For _nS := 1 To Len(_aListDEP)
	AADD(_aArqHist,_aListDEP[_nS,1]+" "+_aListDEP[_nS,2])
Next
AADD(_aArqHist,"*** FINAL")

// efetua a gravacao da linhas no arquivo de historico
_aArqHist[2] := "FINAL EXECUCAO DO CORTE NA BASE DE DADOS: " + DTOC(DATE()) + " " + LEFT(TIME(),5)
oObj:SetRegua1(Len(_aArqHist))
oObj:SetRegua2(Len(_aArqHist))
For _nL := 1 to Len(_aArqHist)
	oObj:IncRegua1("Gravando arquivo de historico...")
	oObj:IncRegua2("Gravando arquivo de historico...")
	_cLinLog := _aArqHist[_nL]+_cEOF
	fWrite(_nHandle,_cLinLog,Len(_cLinLog))
Next

// acerta para visualizar registros excluidos
SET DELETED ON

// fecha arquivo
fClose(_nHandle)
Return

Static Function rfRecCount(_cAlias)
Local _nRet := 0
DbSelectArea(_cAlias)
DbGoTop()
While !EOF()
	_nRet++
	DbSkip()
End
DbGoTop()
Return(_nRet)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function fTabBanco

// declaracao de variaveis
Local _aArea := GetArea()
Private _oListBCO, _aListBCO := {}

// busca tabelas do banco de dados
Processa({|| fListBCO(.f.)},"GEFCO - Corte na Base [ Tabelas Banco ]")

// monta tela para exibir os registros
DEFINE MSDIALOG _oTabelas TITLE OemToAnsi("Status Atual das Tabelas e Banco de Dados") FROM 000,000 TO 420,760 PIXEL OF GetWndDefault()

@ 002,002 LISTBOX _oListBCO FIELDS HEADER OemToAnsi("Tabela"),;
OemToAnsi("Nome"),;
OemToAnsi("Schema"),;
OemToAnsi("Catalog"),;
OemToAnsi("Tamanho MB"),;
OemToAnsi("Registros") SIZE 380,190 OF _oTabelas PIXEL
_oListBCO:SetArray(_aListBCO)
_oListBCO:bLine   := { ||{_aListBCO[_oListBCO:nAT,1],_aListBCO[_oListBCO:nAT,2],_aListBCO[_oListBCO:nAT,3],_aListBCO[_oListBCO:nAT,4],_aListBCO[_oListBCO:nAT,5],_aListBCO[_oListBCO:nAT,6]}}

@ 195,005 BUTTON OemToAnsi("Drop Table") SIZE 30,10 OF _oTabelas ACTION(fDropTable()) PIXEL
@ 195,045 BUTTON OemToAnsi("Imprimir")   SIZE 30,10 OF _oTabelas ACTION(fRelatorio()) PIXEL
@ 195,085 BUTTON OemToAnsi("Registros")  SIZE 30,10 OF _oTabelas ACTION(_oTabelas:End()) PIXEL
@ 195,125 BUTTON OemToAnsi("Cancela")    SIZE 30,10 OF _oTabelas ACTION(_oTabelas:End()) PIXEL

ACTIVATE DIALOG _oTabelas CENTERED

// retorna
RestArea(_aArea)
Return

Static Function fListBCO(_lRefresh)
// zera array
_aListBCO := {}

// busca tabelas no banco de dados
_cQry := "SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES"
_cQry += "   WHERE TABLE_TYPE = 'BASE TABLE'"
_cQry += "   ORDER BY TABLE_NAME"
TCQUERY _cQry NEW ALIAS "TRB"
ProcRegua(rfRecCount("TRB"))
dbGoTop()
While !TRB->(EOF())
	
	// Verifica o cancelamento pelo usuario...
	IncProc(TRB->TABLE_NAME)
	
	// busca numero do ID da tabela no banco de dados
	_cQry := "SELECT ID FROM sysobjects WHERE NAME = '" + TRB->TABLE_NAME + "'"
	TCQUERY _cQry NEW ALIAS "TRC"
	_nIdTabela := TRC->ID
	TRC->(DbCloseArea())
	
	// busca tamanho da tabela
	_cQry := "SELECT dpages as Tamanho, rowcnt as Registros"
	_cQry += " FROM sysindexes"
	_cQry += " WHERE id = "  + AllTrim(Str(_nIdTabela)) + " and"
	_cQry += " indid in (1,0) and objectproperty(id,'isusertable')=1"
	TCQUERY _cQry NEW ALIAS "TRC"
	_nTamanho   := Round((TRC->TAMANHO*8)/1024,2)
	_nRegistros := TRC->REGISTROS
	TRC->(DbCloseArea())
	
	// busca tabela no SX2
	_xNome := Space(50)
	DbSelectArea("SX2")
	DbSetOrder(1)
	DbGoTop()
	If DbSeek(LEFT(TRB->TABLE_NAME,3))
		If AllTrim(TRB->TABLE_NAME) == AllTrim(SX2->X2_ARQUIVO)
			_xNome := SX2->X2_NOME
		Endif
	Endif
	
	// adiciona no array
	AADD(_aListBCO,Array(99))
	_aListBCO[Len(_aListBCO),01] := AllTrim(TRB->TABLE_NAME)+Space(20)
	_aListBCO[Len(_aListBCO),02] := _xNome
	_aListBCO[Len(_aListBCO),03] := AllTrim(TRB->TABLE_SCHEMA)
	_aListBCO[Len(_aListBCO),04] := AllTrim(TRB->TABLE_CATALOG)
	_aListBCO[Len(_aListBCO),05] := TransForm(_nTamanho,"@E 999,999,999,999")
	_aListBCO[Len(_aListBCO),06] := TransForm(_nRegistros,"@E 999,999,999,999")
	
	// proxima tabela
	TRB->(DbSkip())
End
TRB->(DbCloseArea())
If _lRefresh
	_oListBCO:aArray := aClone(_aListBCO)
	_oListBCO:Refresh()
Endif
Return

Static Function fDropTable
Local _cTabBco := AllTrim(_aListBCO[_oListBCO:nAT,1])
If MsgYesNo("Para a exclusao fisica da tabela [ " + _cTabBco + " ], se necessario gerar uma tabela em DBF para backup, deseja proceder com a exclusao?")
	Processa({||fExecDrop()},"GEFCO - Corte na Base [ Excluindo Tabela ]")
	Processa({|| fListBCO(.f.)},"GEFCO - Corte na Base [ Tabelas Banco ]")
Endif
Return

Static Function fExecDrop

// acerta para visualizar registros excluidos
SET DELETED OFF

// define nome da tabela
_cTabela := AllTrim(_aListBCO[_oListBCO:nAT,1])

// cria tabela de backup
MontaDir("\corte_base\drop_table\")
_cArqBKP := "\corte_base\drop_table\"+_cTabela+".DBF"
If File(_cArqBkp)
	MsgAlert("Ja existe a tabela " + _cArqBKP + " o backup nao podera ser efetuado, verifique!")
	Return
Endif

// abre tabela no banco de dados
DbUseArea(.T.,"TOPCONN",_cTabela,"TAB",.T.,.F.)

// copia estrutura
COPY STRUCTURE TO &(_cArqBkp)
DbUseArea(.T.,,_cArqBkp,"BKP",.T.,.F.)

// copia os registros
DbSelectArea("TAB")
DbGoTop()
ProcRegua(RecCount())
While !TAB->(Eof())
	// Incrementa Regua
	IncProc("Copiando tabela para DBF...")
	// copia registro
	DbSelectArea("BKP")
	If RecLock("BKP",.T.)
		For _nI := 1 To fCount()
			FieldPut(FieldPos(FieldName(_nI)),&("TAB->"+FieldName(_nI)))
		Next
		If TAB->(Deleted())
			BKP->(DbDelete())
		Endif
		BKP->(MsUnlock())
	Endif
	DbSelectArea("TAB")
	TAB->(DbSkip())
End
// fecha todas tabelas
BKP->(DbCloseArea())
TAB->(DbCloseArea())
// efetua drop table
_cDelReg := "DROP TABLE " + _cTabela
If TcSQLExec(_cDelReg) < 0
	_cErroTAB := TcSqlError()
	MsgAlert("Erro ao excluir tabela: " + _cEOF + _cErroTAB)
EndIf

// acerta para visualizar registros excluidos
SET DELETED OFF

Return

Static Function fRelatorio
// Declaracao de Variaveis
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Tabelas do Banco de Dados"
Local cPict          := ""
Local titulo         := "Tabelas do Banco de Dados"
Local nLin           := 80
Local Cabec1         := "TABELA               SCHEMA     CATALOG                   TAMANHO MB   REGISTROS"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "GEFCORTE" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "GEFCORTE" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SX2"

// Monta a interface padrao com o usuario..
dbSelectArea("SX2")
dbSetOrder(1)
wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif
nTipo := If(aReturn[4]==1,15,18)

// Processamento. RPTSTATUS monta janela com a regua de processamento
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
DbSelectArea("SZZ")
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

// declaracao de variaveis
Local _nTamTot := 0
Local _nRegTot := 0
Local _nTotTab := 0

// busca tabelas no banco de dados
_cQry := "SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES"
_cQry += "   WHERE TABLE_TYPE = 'BASE TABLE'"
_cQry += "   ORDER BY TABLE_NAME"
TCQUERY _cQry NEW ALIAS "TRB"
SetRegua(rfRecCount("TRB"))
dbGoTop()
While !TRB->(EOF())
	
	// Verifica o cancelamento pelo usuario...
	IncRegua(TRB->TABLE_NAME)
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	// Impressao do cabecalho do relatorio...
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	// busca numero do ID da tabela no banco de dados
	_cQry := "SELECT ID FROM sysobjects WHERE NAME = '" + TRB->TABLE_NAME + "'"
	TCQUERY _cQry NEW ALIAS "TRC"
	_nIdTabela := TRC->ID
	TRC->(DbCloseArea())
	
	// busca tamanho da tabela
	_cQry := "SELECT dpages as Tamanho, rowcnt as Registros"
	_cQry += " FROM sysindexes"
	_cQry += " WHERE id = "  + AllTrim(Str(_nIdTabela)) + " and"
	_cQry += " indid in (1,0) and objectproperty(id,'isusertable')=1"
	TCQUERY _cQry NEW ALIAS "TRC"
	_nTamanho   := Round((TRC->TAMANHO*8)/1024,2)
	_nRegistros := TRC->REGISTROS
	TRC->(DbCloseArea())
	
	// filtra tabelas sem tamanho/registro
	If _nTamanho <= 0 .And. _nRegistros <= 0
		TRB->(DbSkip())
		Loop
	Endif
	
	// layout de impressao
	// TABELA               SCHEMA     CATALOG                   TAMANHO MB   REGISTROS
	// XXXXXXXXXXXXXXXXXXXX XXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXX.XXX.XXX.XXX XXX.XXX.XXX
	// 01234567890123456789012345678901234567890123456789012345678901234567890123456789
	//           1         2         3         4         5         6         7
	
	@ nLin,000 PSay LEFT(TRB->TABLE_NAME,20)
	@ nLin,021 PSay LEFT(TRB->TABLE_SCHEMA,10)
	@ nLin,032 PSay LEFT(TRB->TABLE_CATALOG,20)
	@ nLin,053 PSay _nTamanho Picture "@E 999,999,999,999"
	@ nLin,069 PSay _nRegistros Picture "@E 999,999,999"
	nLin += 1
	
	// totaliza
	_nTotTab += 1
	_nTamTot += _nTamanho
	_nRegTot += _nRegistros
	
	// proximo registro
	DbSelectArea("TRB")
	TRB->(dbSkip())
End
TRB->(DbCloseArea())

// total geral
@ nLin,000 PSay Replicate("-",80)
nLin += 2
@ nLin,000 PSay "Total tabelas: " + TransForm(_nTotTab,"@E 999,999")
@ nLin,053 PSay _nTamTot Picture "@E 999,999,999,999"
@ nLin,069 PSay _nRegTot Picture "@E 999,999,999"

// Finaliza a execucao do relatorio...
Roda(cbCont,cbTxt,Tamanho)
SET DEVICE TO SCREEN

// Se impressao em disco, chama o gerenciador de impressao...
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
DbSelectArea("SZZ")
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function fZZHist
// declaracao de variaveis
Local _aArea := GetArea()
Private _oListHIS, _aListHIS := {}
Private _oListTAB, _aListTAB := {}
Private _oHisMEMO, _cHisMEMO := ""
Private _oTabMEMO, _cTabMEMO := ""

// busca tabelas do banco de dados
Processa({|| fListHIS(.f.)},"GEFCO - Corte na Base [ Historico ]")
If Len(_aListHIS) <= 0
	MsgAlert("Nao foram encontrados registros/arquivos de historico de Corte na Base, verifique!")
	RestArea(_aArea)
	Return
Endif

// monta tela para exibir os registros
DEFINE MSDIALOG _oTabelas TITLE OemToAnsi("Historico do Corte Realizado") FROM 000,000 TO 425,760 PIXEL OF GetWndDefault()

@ 002,002 LISTBOX _oListHIS FIELDS HEADER OemToAnsi("Arquivo"),;
OemToAnsi("Data"),;
OemToAnsi("Hora") SIZE 150,100 OF _oTabelas PIXEL
_oListHIS:SetArray(_aListHIS)
_oListHIS:bLine   := { ||{_aListHIS[_oListHIS:nAT,1],_aListHIS[_oListHIS:nAT,2],_aListHIS[_oListHIS:nAT,3]}}
_oListHIS:bChange := {|| fHISChange()}
@ 002,160 GET _oHisMemo VAR _cHisMemo OF _oTabelas MEMO SIZE 215,100 PIXEL

@ 107,002 LISTBOX _oListTAB FIELDS HEADER OemToAnsi("Tabela"),;
OemToAnsi("Data"),;
OemToAnsi("Hora") SIZE 150,100 OF _oTabelas PIXEL
_oListTAB:SetArray(_aListTAB)
_oListTAB:bLine   := { ||{_aListTAB[_oListTAB:nAT,1],_aListTAB[_oListTAB:nAT,3],_aListTAB[_oListTAB:nAT,4]}}
_oListTAB:bChange := {|| fTABChange()}
@ 107,160 GET _oTabMemo VAR _cTabMemo OF _oTabelas MEMO SIZE 215,100 PIXEL


//@ 195,005 BUTTON OemToAnsi("Drop Table") SIZE 30,10 OF _oTabelas ACTION(fDropTable()) PIXEL
//@ 195,045 BUTTON OemToAnsi("Imprimir")   SIZE 30,10 OF _oTabelas ACTION(fRelatorio()) PIXEL
//@ 195,085 BUTTON OemToAnsi("Registros")  SIZE 30,10 OF _oTabelas ACTION(_oTabelas:End()) PIXEL
//@ 195,125 BUTTON OemToAnsi("Cancela")    SIZE 30,10 OF _oTabelas ACTION(_oTabelas:End()) PIXEL

ACTIVATE DIALOG _oTabelas CENTERED

// retorna
RestArea(_aArea)
Return

Static Function fListHIS()

// define diretorio
cPath := "\corte_base\historico\"

// zera array
_aListHIS := {}

// busca tabelas no banco de dados
_aFiles := Directory(cPath + "*.TXT")
ProcRegua(Len(_aFiles))

For _nF := 1 To Len(_aFiles)
	
	// Verifica o cancelamento pelo usuario...
	IncProc(_aFiles[_nF,1])
	
	// adiciona no array
	If Len(AllTrim(_aFiles[_nF,1])) == 17
		AADD(_aListHIS,Array(99))
		_aListHIS[Len(_aListHIS),01] := _aFiles[_nF,1]
		_aListHIS[Len(_aListHIS),02] := _aFiles[_nF,3]
		_aListHIS[Len(_aListHIS),03] := _aFiles[_nF,4]
	Endif
	
Next

Return

Static Function fHISChange

// declaracao de variaveis
Local _aCampos := {{"TEXTO","C",255,0 }}
Local _cArqTRB
Local _cArqTXT := "\corte_base\historico\"+_aListHIS[_oListHIS:nAT,1]
Local _cArqHist := LEFT(_aListHIS[_oListHIS:nAT,1],Len(_aListHIS[_oListHIS:nAT,1])-4)
Local cPath := "\corte_base\historico\"

// limpa historico
_cHisMEMO := ""

// zera array das tabelas
_aListTAB := {}

// abre DBF
If File(_cArqTXT)
	_cArqTRB := CriaTrab(_aCampos)
	DbUseArea( .T.,,_cArqTRB,"TRB",.F. )
	DbSelectArea("TRB")
	APPEND FROM &(_cArqTXT) SDF
	DbGoTop()
	While !TRB->(EOF())
		_cHisMEMO += TRB->TEXTO
		TRB->(DbSkip())
	End
	TRB->(DbCloseArea())
	
	// apagar arquivo
	fErase(_cArqTRB)
Else
	_cHisMEMO := "Erro ao abrir arquivo de historico [" + _cArqTXT + "]"
Endif
_oHisMEMO:Refresh()

// atualiza array com as tabelas
_aFiles := Directory(cPath + "*.TXT")
For _nF := 1 To Len(_aFiles)
	If _aFiles[_nF,1] = _cArqHist
		If Len(AllTrim(_aFiles[_nF,1])) > 17
			_aFiles[_nF,1] := UPPER(_aFiles[_nF,1])
			_cArqTAB := Substr(_aFiles[_nF,1],Len(_cArqHist)+2,Len(_aFiles[_nF,1]))
			_cArqTAB := LEFT(_cArqTAB,AT(".TXT",_cArqTAB)-1)
			AADD(_aListTAB,Array(99))
			_aListTAB[Len(_aListTAB),01] := _cArqTAB
			_aListTAB[Len(_aListTAB),02] := _aFiles[_nF,1]
			_aListTAB[Len(_aListTAB),03] := _aFiles[_nF,3]
			_aListTAB[Len(_aListTAB),04] := _aFiles[_nF,4]
		Endif
	Endif
Next
If Len(_AListTAB) <= 0
	AADD(_aListTAB,Array(99))
Endif

// atualiza array
_oListTAB:aArray := aClone(_aListTAB)
_oListTAB:Refresh()

// retorna
Return

Static Function fTABChange
// declaracao de variaveis
Local _aCampos := {{"TEXTO","C",255,0 }}
Local _cArqTRB
Local _cArqTXT := "\corte_base\historico\"+_aListTAB[_oListTAB:nAT,2]

// limpa historico
_cTabMemo := ""

// abre DBF
If File(_cArqTXT)
	_cArqTRB := CriaTrab(_aCampos)
	DbUseArea( .T.,,_cArqTRB,"TRB",.F. )
	DbSelectArea("TRB")
	APPEND FROM &(_cArqTXT) SDF
	DbGoTop()
	While !TRB->(EOF())
		_cTabMemo += TRB->TEXTO
		TRB->(DbSkip())
	End
	TRB->(DbCloseArea())
	
	// apagar arquivo
	fErase(_cArqTRB)
Else
	_cTabMEMO := "Erro ao abrir arquivo de historico [" + _cArqTXT + "]"
Endif
_oTabMEMO:Refresh()

Return
