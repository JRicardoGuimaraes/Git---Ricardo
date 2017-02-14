#include "protheus.ch"
#include "topconn.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"

/////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa:   IMPRTXML   						             Data 27/08/12 //
// Descricao:  Importacao do arquivo XML ref. NFe preenchendo a tela do documento de entrada.      //
// Autor:      Leandro Passos                                                                      //
// Manutencao: 24/10/2012 - Marcelo Hruschka                                                       //
//                          Adequacao da tela para leitura de todos tipos de NFe                   //
//                          Rotina para ler e baixar XML da conta de email                         //
/////////////////////////////////////////////////////////////////////////////////////////////////////

User Function IMPRTXML()

// declaracao de variaveis
Local _aArea       := GetArea()
Private _aCabecNFE := {}
Private _aItensNFE := {}
Private _lOkaCols  := .F.

// variaveis usadas em outras funcoes
Private _oNumero    , _cNumero    := ""
Private _oHistorico , _cHistorico := ""
Private _oRemetente , _cRemetente := ""
Private _oMunicipio , _cMunicipio := ""
Private _oInscricao , _cInscricao := ""
Private _oChave     , _cChave     := ""
Private _oEmissao   , _dEmissao   := CTOD("")
Private _oDocSF1    , _cDocSF1    := ""
Private _oForSF1    , _cForSF1    := ""
Private _oEmiSF1    , _dEmiSF1    := CTOD("")
Private _oDigSF1    , _dDigSF1    := CTOD("")

// variaveis que serao usadas no ponto de entrada de gravacao da nota fiscal
Public _mArqXML    := ""
Public _mMemoXML   := ""

// exibe tela com os arquivos XML's disponiveis para importacao
LjMsgRun("Listando os arquivos XML...","GEFCO - Importa XML",{|| fListXML()})
If Empty(_mArqXML)
	RestArea(_aArea)
	Return
Endif

// chama tela para escolha do codigo de produto, TES, natureza entre outros.
LjMsgRun("Montando Tela com Dados do XML para complementacao...","GEFCO - Importa XML",{|| fTelaDADOS()})

// chama tela para preenchimento do aCols
If _lOkaCols
	LjMsgRun("Transferindo itens para o documento de entrada...","GEFCO - Importa XML",{|| faCols()})
Endif

// retorna
RestArea(_aArea)
Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fTelaDADOS

// declaracao de variaveis
Local nTamFile, nTamLin, cBuffer, nBtLidos

// efetua leitura do arquivo
nHdl 		:= fOpen(AllTrim(_mArqXML),0)
nTamFile 	:= fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
cBuffer  	:= Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
nBtLidos 	:= fRead(nHdl,@cBuffer,nTamFile) // Leitura da primeira linha do arquivo texto
fClose(nHdl)
cAviso 		:= ""
cErro  		:= ""
oNfe 		:= XmlParser(cBuffer,"_",@cAviso,@cErro)

// define codigo do estado
_aCodUF := {}
AADD(_aCodUF,{"11","RO","RONDÔNIA"})
AADD(_aCodUF,{"12","AC","ACRE"})
AADD(_aCodUF,{"13","AM","AMAZONAS"})
AADD(_aCodUF,{"14","RR","RORAIMA"})
AADD(_aCodUF,{"15","PA","PARÁ"})
AADD(_aCodUF,{"16","AP","AMAPÁ"})
AADD(_aCodUF,{"17","TO","TOCANTINS"})
AADD(_aCodUF,{"21","MA","MARANHÃO"})
AADD(_aCodUF,{"22","PI","PIAUÍ"})
AADD(_aCodUF,{"23","CE","CEARÁ"})
AADD(_aCodUF,{"24","RN","RIO GRANDE DO NORTE"})
AADD(_aCodUF,{"25","PB","PARAÍBA"})
AADD(_aCodUF,{"26","PE","PERNAMBUCO"})
AADD(_aCodUF,{"27","AL","ALAGOAS"})
AADD(_aCodUF,{"28","SE","SERGIPE"})
AADD(_aCodUF,{"29","BA","BAHIA"})
AADD(_aCodUF,{"31","MG","MINAS GERAIS"})
AADD(_aCodUF,{"32","ES","ESPIRITO SANTO"})
AADD(_aCodUF,{"33","RJ","RIO DE JANEIRO"})
AADD(_aCodUF,{"35","SP","SÃO PAULO"})
AADD(_aCodUF,{"41","PR","PARANÁ"})
AADD(_aCodUF,{"42","SC","SANTA CATARINA"})
AADD(_aCodUF,{"43","RS","RIO GRANDE DO SUL"})
AADD(_aCodUF,{"50","MS","MATO GROSSO DO SUL"})
AADD(_aCodUF,{"51","MT","MATO GROSSO"})
AADD(_aCodUF,{"52","GO","GOIÁS"})
AADD(_aCodUF,{"53","DF","DISTRITO FEDERAL"})


// posiciona no arquivo de configuracao
If !Empty(_cMunicipio) .And. _cMunicipio <> "SEFAZ"
	// busca o nome do municpio na tabela de municipio
	_cCodUF  := LEFT(_cMunicipio,2)
	_cUF     := _aCodUF[aScan(_aCodUF,{|x| x[1] == _cCodUF }),2]
	_cCodMun := RIGHT(_cMunicipio,5)
	_cNomMun := AllTrim(POSICIONE("CC2",1,xFilial("CC2")+_cUF+_cCodMun,"CC2_MUN"))
	// busca configuracao
	DbSelectArea("SZU")
	DbSetOrder(1)
	If !DbSeek(xFilial("SZU")+_cMunicipio)
		MsgAlert("Municipio [ " + _cMunicipio + " ] [ " + _cNomMun+"/"+_cUF + " ] nao foi encontrado na tabela de configuracao de XML x UF, verifique!")
		Return
	Endif
Endif


// busca configuracao da nota fiscal de produtos
If _cMunicipio == "SEFAZ"
	DbSelectArea("SZU")
	DbSetOrder(1)
	If !DbSeek(xFilial("SZU")+"SEFAZ")
		MsgAlert("Configuracao para nota fiscal de produtos nao foi encontrada, por favor, cadastre na tabela de XML x UF, como SEFAZ!")
		Return
	Endif
Endif

// Valida Empresa Tomadora (GEFCO)
_cCnpjTomador:= &("oNfe:"+SZU->ZU_CNPJTO)
If _cCnpjTomador <> SM0->M0_CGC
	If !MsgYesNo("CNPJ [ " + TransForm(_cCnpjTomador,"@R 99.999.999/9999-99") + " ] do XML não confere com o CNPJ [ "  + TransForm(SM0->M0_CGC,"@R 99.999.999/9999-99") + " ] da empresa atual. Deseja continuar mesmo assim?")
		Return
	Endif
Endif

// Valida Prestador conferindo se o CNPJ bate com o do fornecedor informado
_cCnpjFornecedor := &("oNfe:"+SZU->ZU_CNPJ)
DbSelectArea("SA2")
DbSetOrder(3)
DbGoTop()
If !DbSeek(xFilial("SA2")+_cCnpjFornecedor)
	MsgAlert("CNPJ [ " + TransForm(_cCnpjFornecedor,"@R 99.999.999/9999-99") + " ] do Fornecedor não foi encontrado no cadastro, verifique!")
	Return
Endif

// preenche itens para cabecalho para nota fiscal
AADD(_aCabecNFE,Array(99))
_aCabecNFE[1,01] := "Nao"
_aCabecNFE[1,02] := &("oNfe:"+SZU->ZU_NFISCA)
_aCabecNFE[1,03] := Space(3)
_aCabecNFE[1,04] := "NFS"
_aCabecNFE[1,05] := &("oNfe:"+SZU->ZU_UFORIG)
_aCabecNFE[1,06] := SA2->A2_COD
_aCabecNFE[1,07] := SA2->A2_LOJA
_aCabecNFE[1,08] := dDataBase

// preenche os itens
If _cMunicipio <> "SEFAZ"
	AADD(_aItensNFE,Array(99))
	_aItensNFE[1,01] := "01"
	_aItensNFE[1,02] := Space(15)
	_aItensNFE[1,03] := AllTrim(&("oNfe:"+SZU->ZU_DESC)) 			// descricao
	_aItensNFE[1,04] := 1 											// quantidade
	_aItensNFE[1,05] := val(&("oNfe:"+SZU->ZU_VLUNIT)) 			// valor unitario
	_aItensNFE[1,06] := val(&("oNfe:"+SZU->ZU_VLTOTAL)) 			// valor total
	_aItensNFE[1,07] := Space(3)									// tes
	_aItensNFE[1,08] := Space(10)									// natureza
	_aItensNFE[1,09] := val(&("oNfe:"+SZU->ZU_VLISS )) 			// valor ISS
	_aItensNFE[1,10] := val(&("oNfe:"+SZU->ZU_VLALIQ)) 			// aliq iss
	_aItensNFE[1,11] := val(&("oNfe:"+SZU->ZU_BASECA)) 	   		// base calculo iss
Else
	aItens := oNFE:_NFEPROC:_NFE:_INFNFE:_DET
	For _nI := 1 To Len(aItens)
		AADD(_aItensNFE,Array(99))
		_aItensNFE[_nI,01] := StrZero(_nI,2) //aItens[_nI]:_nItem:Text
		_aItensNFE[_nI,02] := Space(15)
		_aItensNFE[_nI,03] := AllTrim(aItens[_nI]:_PROD:_XPROD:TEXT)	// descricao
		_aItensNFE[_nI,04] := VAL(aItens[_nI]:_PROD:_QCOM:TEXT)			// quantidade
		_aItensNFE[_nI,06] := VAL(aItens[_nI]:_PROD:_VPROD:TEXT) 		// valor total
		_aItensNFE[_nI,05] := _aItensNFE[_nI,06]/_aItensNFE[_nI,04]		// valor unitario
		_aItensNFE[_nI,07] := Space(3)									// tes
		_aItensNFE[_nI,08] := Space(10)									// natureza
		_aItensNFE[_nI,09] := 0 										// valor ISS
		_aItensNFE[_nI,10] := 0 										// aliq iss
		_aItensNFE[_nI,11] := 0	   										// base calculo iss
		_aItensNFE[_nI,12] := aItens[_nI]:_PROD:_CEAN:TEXT				// codigo ean
		_aItensNFE[_nI,13] := aItens[_nI]:_PROD:_NCM:TEXT				// codigo ncm
		_aItensNFE[_nI,14] := aItens[_nI]:_PROD:_CFOP:TEXT				// cfop
		_aItensNFE[_nI,15] := aItens[_nI]:_PROD:_CPROD:TEXT				// codigo fornecedor
	Next
Endif

// monta tela para define os campos
DEFINE MSDIALOG _oTelaDados TITLE OemToAnsi("Tela para confirmacao dos dados do XML") FROM 000,000 TO 445,980 PIXEL OF GetWndDefault()
@ 005,002 LISTBOX _oCabecNFE FIELDS HEADER OemToAnsi("Form.Proprio"),OemToAnsi("Nota Fiscal"),OemToAnsi("Serie"),OemToAnsi("Especie"),OemToAnsi("UF Orig"),OemToAnsi("Codigo"),OemToAnsi("Loja"),OemToAnsi("Emissao") SIZE 330,30 OF _oTelaDados PIXEL
_oCabecNFE:SetArray(_aCabecNFE)
_oCabecNFE:bLine      := { ||{_aCabecNFE[_oCabecNFE:nAT,1],_aCabecNFE[_oCabecNFE:nAT,2],_aCabecNFE[_oCabecNFE:nAT,3],_aCabecNFE[_oCabecNFE:nAT,4],_aCabecNFE[_oCabecNFE:nAT,5],_aCabecNFE[_oCabecNFE:nAT,6],_aCabecNFE[_oCabecNFE:nAT,7],_aCabecNFE[_oCabecNFE:nAT,8]}}
_oCabecNFE:bLDblClick := {|| fCabecNFE()}

@ 040,002 LISTBOX _oItensNFE FIELDS HEADER OemToAnsi("Item"),;
OemToAnsi("Codigo"),;
OemToAnsi("Descricao"),;
OemToAnsi("Quant"),;
OemToAnsi("V.Unit"),;
OemToAnsi("V.Total"),;
OemToAnsi("TES"),;
OemToAnsi("Natureza"),;
OemToAnsi("V.ISS"),;
OemToAnsi("A.ISS"),;
OemToAnsi("B.ISS"),;
OemToAnsi("EAN"),;
OemToAnsi("NCM"),;
OemToAnsi("CFOP"),;
OemToAnsi("Produto"),;
OemToAnsi(""),OemToAnsi(""),OemToAnsi(""),OemToAnsi(""),;
OemToAnsi("") SIZE 490,180 OF _oTelaDados PIXEL
_oItensNFE:SetArray(_aItensNFE)
_oItensNFE:bLine      := { ||{_aItensNFE[_oItensNFE:nAT,1],_aItensNFE[_oItensNFE:nAT,2],_aItensNFE[_oItensNFE:nAT,3],_aItensNFE[_oItensNFE:nAT,4],_aItensNFE[_oItensNFE:nAT,5],_aItensNFE[_oItensNFE:nAT,6],_aItensNFE[_oItensNFE:nAT,7],_aItensNFE[_oItensNFE:nAT,8],_aItensNFE[_oItensNFE:nAT,9],_aItensNFE[_oItensNFE:nAT,10],_aItensNFE[_oItensNFE:nAT,11],_aItensNFE[_oItensNFE:nAT,12],_aItensNFE[_oItensNFE:nAT,13],_aItensNFE[_oItensNFE:nAT,14],_aItensNFE[_oItensNFE:nAT,15],_aItensNFE[_oItensNFE:nAT,16],_aItensNFE[_oItensNFE:nAT,17],_aItensNFE[_oItensNFE:nAT,18],_aItensNFE[_oItensNFE:nAT,19],_aItensNFE[_oItensNFE:nAT,20]}}
_oItensNFE:bLDblClick := {|| fItensNFE()}

// botoes controle
@ 015,423 BUTTON OemToAnsi("Confirma")        SIZE 30,12 OF _oTelaDados ACTION(fConfirma()) PIXEL
@ 015,458 BUTTON OemToAnsi("Cancelar")        SIZE 30,12 OF _oTelaDados ACTION(_oTelaDados:End()) PIXEL

// ativa tela
ACTIVATE DIALOG _oTelaDados CENTERED

// retorna
Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fConfirma()
// declaracao de variaveis
Local _lCod := .T.
Local _lTes := .T.
Local _lNat := .T.
Local _xMsg := ""
// valida itens
For _nI := 1 To Len(_aItensNFE)
	If Empty(_aItensNFE[_nI,2]); _lCod := .F.; Endif
	If Empty(_aItensNFE[_nI,7]); _lTes := .F.; Endif
	If Empty(_aItensNFE[_nI,8]); _lNat := .F.; Endif
Next
// caso tenha algum item sem preenchimento informa usuario
If !_lCod .Or. !_lTes .Or. !_lNat
	_xMsg := "Por favor, verifique os itens listas, pois faltam preenchimento de campos obrigatorios!"
	_xMsg += IIF(!_lCod,Chr(13)+"Codigo Produto/Servico","")
	_xMsg += IIF(!_lTes,Chr(13)+"Tipo de Entrada/Saida","")
	_xMsg += IIF(!_lNat,Chr(13)+"Codigo Natureza","")
	MsgAlert(_xMsg)
Else
	_lOkaCols := .T.
	_oTelaDados:End()
Endif
Return


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fCabecNFE
//MsgInfo("fCabecNFE")
Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fItensNFE

// declaracao de variveis
Local _lOk  := .F.
Local _cIte := _aItensNFE[_oItensNFE:nAT,1]
Local _cCod := _aItensNFE[_oItensNFE:nAT,2]
Local _cTes := _aItensNFE[_oItensNFE:nAT,7]
Local _cNat := _aItensNFE[_oItensNFE:nAT,8]
Local _cDes := _aItensNFE[_oItensNFE:nAT,3]
Local _nTot := _aItensNFE[_oItensNFE:nAT,6]
Private _oDesSB1, _cDesSB1 := IIF(!Empty(_cCod),POSICIONE("SB1",1,xFilial("SB1")+_cCod,"B1_DESC"),"")
Private _oDesSF4, _cDesSF4 := IIF(!Empty(_cTes),POSICIONE("SF4",1,xFilial("SF4")+_cTes,"F4_TEXTO"),"")
Private _oDesSED, _cDesSED := IIF(!Empty(_cNat),POSICIONE("SED",1,xFilial("SED")+_cNat,"ED_DESCRIC"),"")

// monta tela para digitacao das informacoes
DEFINE MSDIALOG _oDigita TITLE OemToAnsi("Informe os dados do Item") FROM 000,000 TO 340,427 PIXEL OF GetWndDefault()

// informacoes nao editaveis
@ 005,005 TO 045,210 LABEL "Detalhe do Item" OF _oDigita PIXEL
@ 017,010 SAY "Item:" SIZE 50,8 OF _oDigita PIXEL
@ 015,045 GET _cIte SIZE 15,8  WHEN .F. OF _oDigita PIXEL
@ 017,110 SAY "Total:" SIZE 50,8 OF _oDigita PIXEL
@ 015,145 GET _nTot SIZE 60,8  WHEN .F. PICTURE "@e 999,999,999.99" OF _oDigita PIXEL
@ 030,010 SAY "Descricao:" SIZE 50,8 OF _oDigita PIXEL
@ 028,045 GET _cDes SIZE 160,8  WHEN .F. OF _oDigita PIXEL

@ 055,005 TO 150,210 LABEL "Complemente as informacoes abaixo:" OF _oDigita PIXEL
@ 067,010 SAY "Codigo:" SIZE 50,8 OF _oDigita PIXEL
@ 065,045 MSGET _cCod SIZE 70,8 F3 "SB1" Valid(fValidCod(_cCod)) OF _oDigita PIXEL
@ 077,045 MSGET _oDesSB1 VAR _cDesSB1 SIZE 160,8 WHEN .F. OF _oDigita PIXEL
@ 094,010 SAY "Tipo E/S:" SIZE 50,8 OF _oDigita PIXEL
@ 092,045 MSGET _cTes SIZE 70,8 F3 "SF4" Valid(fValidTes(_cTes)) OF _oDigita PIXEL
@ 104,045 MSGET _oDesSF4 VAR _cDesSF4 SIZE 160,8 WHEN .F. OF _oDigita PIXEL
@ 121,010 SAY "Natureza:" SIZE 50,8 OF _oDigita PIXEL
@ 119,045 MSGET _cNat SIZE 70,8 F3 "SED" Valid(fValidNat(_cNat)) OF _oDigita PIXEL
@ 131,045 MSGET _oDesSED VAR _cDesSED SIZE 160,8 WHEN .F. OF _oDigita PIXEL

@ 155,180 BUTTON OemToAnsi("Confirma")  SIZE 30,10 OF _oDigita ACTION(_lOk:=.T.,_oDigita:End()) PIXEL

// ativa tela
ACTIVATE DIALOG _oDigita CENTERED

// atualiza listboxk
If _lOk
	_aItensNFE[_oItensNFE:nAT,2] := _cCod
	_aItensNFE[_oItensNFE:nAT,7] := _cTes
	_aItensNFE[_oItensNFE:nAT,8] := _cNat
	_oItensNFE:aArray := aClone(_aItensNFE)
	_oItensNFE:Refresh()
endif

// retonra
Return

Static Function fValidCod(_xCod)
Local _lRet := .F.
DbSelectArea("SB1")
DbSetOrder(1)
If DbSeek(xFilial("SB1")+_xCod)
	_cDesSB1 := SB1->B1_DESC
	_oDesSB1:Refresh()
	_lRet := .T.
Else
	MsgAlert("Codigo digitado nao foi encontrado no cadastro de produtos, verifique!")
Endif
Return(_lRet)

Static Function fValidTes(_xTes)
Local _lRet := .F.
DbSelectArea("SF4")
DbSetOrder(1)
If DbSeek(xFilial("SF4")+_xTes)
	_cDesSF4 := SF4->F4_TEXTO
	_oDesSF4:Refresh()
	_lRet := .T.
Else
	MsgAlert("Codigo digitado nao foi encontrado no cadastro de Tipo de Entrada/Saida, verifique!")
Endif
Return(_lRet)

Static Function fValidNat(_xNat)
Local _lRet := .F.
DbSelectArea("SED")
DbSetOrder(1)
If DbSeek(xFilial("SED")+_xNat)
	_cDesSED := SED->ED_DESCRIC
	_oDesSED:Refresh()
	_lRet := .T.
Else
	MsgAlert("Codigo digitado nao foi encontrado no cadastro de Naturezas, verifique!")
Endif
Return(_lRet)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function faCols

// atualiza dados do cabecalho
CA103FORM	:= _aCabecNFE[1,01]
CNFISCAL	:= _aCabecNFE[1,02]
CESPECIE	:= _aCabecNFE[1,04]
CUFORIG		:= _aCabecNFE[1,05]
CA100FOR 	:= _aCabecNFE[1,06]
CLOJA 		:= _aCabecNFE[1,07]

// inicia itens
MaFisClear()
aRefImpos 	:= MaFisRelImp('MT100',{"SF1","SD1"})
MaFisIni(cA100For,cLoja,"F",cTipo,Nil,MaFisRelImp("MT100",{"SF1","SD1"}),,!l103Visual)

// processa itens
aCols := {}
For _nI := 1 To Len(_aItensNFE)
	
	// Faz a montagem de uma linha em branco no aCols.
	nUsado := Len(aHeader)
	AADD(aCols,Array(nUsado+1))
	n := Len(aCols)
	
	For nY := 1 To Len(aHeader)
		If AllTrim(aHeader[nY,2]) == "D1_ALI_WT"
			aCOLS[n,nY] := "SD1"  //aCOLS[Len(aCols)][nY] := "SD1"
		ElseIf AllTrim(aHeader[nY,2]) == "D1_REC_WT"
			aCOLS[n,nY] := 0
		Else
			aCols[n,nY] := CriaVar(aHeader[nY][2])
		EndIf
	Next nY
	aCols[n,nUsado+1] := .F.
	
	// posiciona no cadastro de produtos
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+_aItensNFE[_nI,02])
	
	// posiciona na TES
	DbSelectArea("SF4")
	DbSetOrder(1)
	DbSeek(xFilial("SF4")+_aItensNFE[_nI,07])
	
	// atualiza itens do aCols
	nPosCod     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"});		aCols[n,nPosCod]   := _aItensNFE[_nI,02]
	nPosUni     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_UM"});			aCols[n,nPosUni]   := SB1->B1_UM
	nPosItem    := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEM"});		aCols[n,nPosItem]  := _aItensNFE[_nI,01]
	nPosTotal   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TOTAL"});		aCols[n,nPosTotal] := _aItensNFE[_nI,06]
	nPosTes     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"});		aCols[n,nPosTes]   := _aItensNFE[_nI,07]
	nPosVlr     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_VUNIT"});		aCols[n,nPosVlr]   := _aItensNFE[_nI,05]
	nPosQuant   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_QUANT"}); 		aCols[n,nPosQuant] := _aItensNFE[_nI,04]
	nPosLoc   	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOCAL"}); 		aCols[n,nPosLoc] 	:= SB1->B1_LOCPAD
	nPosCF   	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_CF"}); 		aCols[n,nPosCF] 	:= SF4->F4_CF
	nPosCFis   	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_CLASFIS"}); 	aCols[n,nPosCFis] 	:= SB1->B1_ORIGEM+SF4->F4_SITTRIB
	
	// refresh na tela
	MaFisToCols(aHeader,aCols,,"MT100")
	MaFisIniLoad(n)
	For nI := 1 To Len(aRefImpos)
		_nPosRef := aScan(aHeader,{|x| AllTrim(x[2]) == aRefImpos[nI][2]})
		If _nPosRef > 0
			MaFisLoad(aRefImpos[nI][3],aCols[n,_nPosRef],n)
		Endif
	Next
	MaFisEndLoad(n,2)
	
Next
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fListXML

// declaracao de varivaeis
Local _aArea      := GetArea()
Local _cDirXML    := GetNewPar("MV_XDIRXML","\xml-recebida\")
Local _cDirCNPJ   := _cDirXML + SM0->M0_CGC + "\"
Private _aListXML := {}, _oListXML
Private oEnable   := LoadBitmap( GetResources(), "ENABLE" )
Private oDisable  := LoadBitmap( GetResources(), "DISABLE" )
Private _oSeleciona
Private _oEmpresa, _cEmpresa := SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL
Private _oDiretorio, _cDiretorio := "", _aDiretorio := {}

// cria direotiro caso tenha sido apagado
MontaDir(_cDirXML)

// define os diretorios
DbSelectArea("SM0")
DbSetOrder(1)
_nRegSM0 := Recno()
DbGoTop()
While !SM0->(EOF())
	If SM0->M0_CODIGO == cEmpAnt
		AADD(_aDiretorio,_cDirXML + SM0->M0_CGC + "\")
	Endif
	SM0->(DbSkip())
End
DbGoTo(_nRegSM0)
_cDiretorio := _cDirCNPJ

// analisa caixa inbox
Processa({|| fOrgInbox(.F.)},"Organizando pastas inbox...")

// busca arquivos no diretorio
Processa({|| fBuscaXML(.F.,.F.)},"Buscando arquivos XML salvos no servidor...")

// monta tela para exibir os registros
DEFINE MSDIALOG _oSeleciona TITLE OemToAnsi("Selecione o XML que deseja importar") FROM 000,000 TO 467,980 PIXEL OF GetWndDefault()

@ 001,002 TO 022,274 LABEL "Empresa/Filial"  OF _oSeleciona PIXEL
@ 009,007 MSGET _oEmpresa VAR _cEmpresa SIZE 260,8  WHEN .F. OF _oSeleciona PIXEL
@ 001,280 TO 022,490 LABEL "Verificar XML de outras empresas"  OF _oSeleciona PIXEL
@ 009,285 COMBOBOX _oDiretorio VAR _cDiretorio ITEMS _aDiretorio VALID(fDiretorio()) SIZE 200,10 OF _oSeleciona PIXEL

// lista os arquivos XML
@ 025,002 LISTBOX _oListXML FIELDS HEADER OemToAnsi(""),;
OemToAnsi("Arquivo"),;
OemToAnsi("Data"),;
OemToAnsi("Hora"),;
OemToAnsi("Tamanho") SIZE 274,208 OF _oSeleciona PIXEL
_oListXML:SetArray(_aListXML)
_oListXML:bLine   := { ||{IIF(_aListXML[_oListXML:nAT,1],oEnable,oDisable),_aListXML[_oListXML:nAT,2],_aListXML[_oListXML:nAT,3],_aListXML[_oListXML:nAT,4],_aListXML[_oListXML:nAT,5]}}
_oListXML:bChange := {|| fXMLChange()}
_oListXML:SetFocus(.T.)

// informacoes do XML
@ 025,280 TO 150,490 LABEL "Dados do XML" OF _oSeleciona PIXEL
@ 035,285 SAY "Numero:" SIZE 50,8 OF _oSeleciona PIXEL
@ 033,325 MSGET _oNumero VAR _cNumero SIZE 60,8  WHEN .F. OF _oSeleciona PIXEL
@ 035,405 SAY "Municipio:" SIZE 50,8 OF _oSeleciona PIXEL
@ 033,445 MSGET _oMunicipio VAR _cMunicipio SIZE 40,8  WHEN .F. OF _oSeleciona PIXEL
@ 050,285 SAY "Chave:" SIZE 50,8 OF _oSeleciona PIXEL
@ 048,325 MSGET _oChave VAR _cChave SIZE 160,8  WHEN .F. OF _oSeleciona PIXEL
@ 065,285 SAY "Emissao:" SIZE 50,8 OF _oSeleciona PIXEL
@ 063,325 MSGET _oEmissao VAR _dEmissao SIZE 70,8  WHEN .F. OF _oSeleciona PIXEL
@ 080,285 SAY "Remetente:" SIZE 50,8 OF _oSeleciona PIXEL
@ 078,325 MSGET _oRemetente VAR _cRemetente SIZE 160,8  WHEN .F. OF _oSeleciona PIXEL
@ 095,285 SAY "Informacoes:" SIZE 50,8 OF _oSeleciona PIXEL
@ 093,325 GET _oHistorico VAR _cHistorico OF _oSeleciona WHEN .F. MEMO SIZE 160,53 PIXEL

@ 155,280 TO 215,490 LABEL "Dados da NF ( caso ja importado )" OF _oSeleciona PIXEL
@ 170,285 SAY "Doc/Serie:" SIZE 50,8 OF _oSeleciona PIXEL
@ 168,325 MSGET _oDocSF1 VAR _cDocSF1 SIZE 60,8 PICTURE "@!" WHEN .F. OF _oSeleciona PIXEL
@ 185,285 SAY "Fornecedor:" SIZE 50,8 OF _oSeleciona PIXEL
@ 183,325 MSGET _oForSF1 VAR _cForSF1 SIZE 160,8 PICTURE "@!" WHEN .F. OF _oSeleciona PIXEL
@ 200,285 SAY "Emissao:" SIZE 50,8 OF _oSeleciona PIXEL
@ 198,325 MSGET _oEmiSF1 VAR _dEmiSF1 SIZE 50,8 WHEN .F. OF _oSeleciona PIXEL
@ 200,395 SAY "Digitacao" SIZE 50,8 OF _oSeleciona PIXEL
@ 198,435 MSGET _oDigSF1 VAR _dDigSF1 SIZE 50,8 WHEN .F. OF _oSeleciona PIXEL

// botoes controle
@ 220,283 BUTTON OemToAnsi("Baixar Email")    SIZE 30,12 OF _oSeleciona ACTION(fBaixaXML())  PIXEL WHEN .F.
@ 220,318 BUTTON OemToAnsi("Filtra N.Imp")    SIZE 30,12 OF _oSeleciona ACTION(fFiltraXML()) PIXEL WHEN .F.
@ 220,353 BUTTON OemToAnsi("Abrir XML")       SIZE 30,12 OF _oSeleciona ACTION(fAbreXML())   PIXEL
@ 220,388 BUTTON OemToAnsi("Check Link")      SIZE 30,12 OF _oSeleciona ACTION(fLinkXML())   PIXEL
@ 220,423 BUTTON OemToAnsi("Mover XML")       SIZE 30,12 OF _oSeleciona ACTION(fMoveXML())   PIXEL
@ 220,458 BUTTON OemToAnsi("Seleciona")       SIZE 30,12 OF _oSeleciona ACTION(fSeleciona()) PIXEL

// ativa tela
ACTIVATE DIALOG _oSeleciona CENTERED

// retorna
RestArea(_aArea)
Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fBuscaXML(_lRefresh,_lFiltro)

// declaracao de variaveis
Local _aFiles   := {}

// monta diretorio
MontaDir(_cDiretorio)

// busca arquivos do diretorio
_aFiles := Directory(_cDiretorio + "*.XML")

// adiciona no array
_aListXML := {}
For _nI := 1 To Len(_aFiles)
	AADD(_aListXML,Array(99))
	_aListXML[Len(_aListXML),01] := .T.
	_aListXML[Len(_aListXML),02] := _aFiles[_nI,1]
	_aListXML[Len(_aListXML),03] := _aFiles[_nI,3]
	_aListXML[Len(_aListXML),04] := _aFiles[_nI,4]
	_aListXML[Len(_aListXML),05] := _aFiles[_nI,2]
	_aListXML[Len(_aListXML),06] := DTOS(_aFiles[_nI,3])+_aFiles[_nI,4]
	_aListXML[Len(_aListXML),07] := _cDiretorio
Next

// caso retorne vazio, informa usuario
If Len(_aListXML) <= 0
	MsgAlert("Nao foram encontrados arquivos no diretorio [ " + _cDiretorio + "], verifique!")
	AADD(_aListXML,Array(99))
	_aListXML[Len(_aListXML),01] := .F.
Else
	_aListXML := aSort( _aListXML,,, { | x , y | x[6] > y[6] } )
Endif

// atualiza listbox
If _lRefresh
	_oListXML:aArray := aClone(_aListXML)
	_oListXML:nAT := 1
	_oListXML:Refresh()
Endif

// retorna
Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fSeleciona
// valida se arquivo conseguiu ser lido
If "ERRO"$ _cNumero
	MsgAlert("XML nao pode ser importado, pois nao esta no formato correto de nota fiscal, verifique!")
	Return
Endif
// confirma se sera importado
_mArqXML := AllTrim(_aListXML[_oListXML:nAT,7]+_aListXML[_oListXML:nAT,2])
If MsgYesNo("Confirma a selecao do arquivo ?" + Chr(13) + _mArqXML)
	_oSeleciona:End()
Else
	_mArqXML := ""
Endif
Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fAbreXML
Local _cArqSER := AllTrim(_aListXML[_oListXML:nAT,7]+_aListXML[_oListXML:nAT,2])
Local _cArqXML := AllTrim("C:\XMLTMP\"+_aListXML[_oListXML:nAT,2])
// copia arquivo para pasta local
MontaDir("C:\XMLTMP\")
If File(_cArqXML); fErase(_cArqXML); Endif
CPYS2T(_cArqSER,"C:\XMLTMP\",.T.)
If !File(_cArqXML)
	MsgAlert("Arquivo XML [" + _cArqSER + "] nao pode ser copiado para maquina local, para que pudesse ser aberto, verifique permissoes de rede!")
	Return
Endif
// executa explorer para abir o arquivo
ShellExecute( "Open", "iexplore.exe", _cArqXML, "C:\", 1 )
// retorna
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fLinkXML
//declaracao de variaveis
Local _cLnk := ""
//Monta link completo
If !Empty(_cMunicipio)
	If _cMunicipio == "3304557"  // rio de janeiro
		_cLnk := "https://notacarioca.rio.gov.br/nfse.aspx?"
		_cLnk += AllTrim("ccm=" + AllTrim(_cInscricao) + "&nf=" + AllTrim(_cNumero) + "&cod=" + AllTrim(StrTran(_cChave,"-","")))
	Endif
	If _cMunicipio == "9999999"  // guarulhos
		_cLnk = "https://visualizar.ginfes.com.br/report/consultarNota?__report=nfs_ver4&"
		_cLnk += AllTrim("cdVerificacao=" + AllTrim(StrZero(_cChave,"-","")) + "&nf=" + AllTrim(_cNumero)) + "&cnpjPrestador=null"
	Endif
	

	If _cMunicipio == "SEFAZ"  // Receita
       _cLnk := "http://www.nfe.fazenda.gov.br/PORTAL/consultaResumo.aspx?tipoConteudo=d09fwabTnLk="
	Endif
	
Else
	// link da receita
	_cLnk := ""
Endif

// abre o link com a nota fiscal
If !Empty(_cLnk)
	ShellExecute( "Open", "iexplore.exe", _cLnk, "C:\", 1 )
Else
	MsgAlert("Link para o municipio em questao, nao esta configurado, verifique!")
Endif

// retorna
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fXMLChange
// declaracao de variaveis
Local nHdl, nTamFile, cBuffer, nBtLidos, cAviso, cErro, oNFE
// limpa variaveis
_cHistorico := ""
_dEmissao   := ""
_cNumero    := ""
_cRemetente := ""
_cChave     := ""
_cMunicipio := ""
_cInscricao := ""

// abre arquivo
If !Empty(_aListXML[_oListXML:nAT,2])
	nHdl := fOpen(AllTrim(_aListXML[_oListXML:nAT,7]+_aListXML[_oListXML:nAT,2]),0)
	If nHdl > 0
		nTamFile 	:= fSeek(nHdl,0,2)
		fSeek(nHdl,0,0)
		cBuffer  	:= Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
		nBtLidos 	:= fRead(nHdl,@cBuffer,nTamFile) // Leitura da primeira linha do arquivo texto
		fClose(nHdl)
		// efetua leitura do xml
		cAviso 		:= ""
		cErro  		:= ""
		oNFE 		:= XmlParser(cBuffer,"_",@cAviso,@cErro)
		// verifica se tem erro na abertura
		If !Empty(cErro) .Or. oNFE == NIL
			_cHistorico := AllTrim(cErro + " " + cAviso)
			_dEmissao   := ""
			_cNumero    := "*** ERRO AO LER XML"
			_cRemetente := ""
			_cChave     := ""
			_cMunicipio := ""
			_cInscricao := ""
		Else
			If AT("CONSULTARNFSERESPOSTA",UPPER(cBuffer)) > 0
				_cHistorico := ""
				_dEmissao   := oNFE:_CONSULTARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_DATAEMISSAO:TEXT
				_cNumero    := oNFE:_CONSULTARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_NUMERO:TEXT
				_cRemetente := oNFE:_CONSULTARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_PRESTADORSERVICO:_RAZAOSOCIAL:TEXT
				_cInscricao := oNFE:_CONSULTARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_PRESTADORSERVICO:_IDENTIFICACAOPRESTADOR:_INSCRICAOMUNICIPAL:TEXT
				_cChave     := oNFE:_CONSULTARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_CODIGOVERIFICACAO:TEXT
				_cMunicipio := oNFE:_CONSULTARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_ORGAOGERADOR:_CODIGOMUNICIPIO:TEXT
			Endif
			If AT("NFEPROC",UPPER(cBuffer)) > 0
				_cHistorico := oNFE:_NFEPROC:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT
				_dEmissao   := oNFE:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT
				_cNumero    := oNFE:_NFEPROC:_NFE:_INFNFE:_IDE:_CNF:TEXT
				_cRemetente := oNFE:_NFEPROC:_NFE:_INFNFE:_EMIT:_XNOME:TEXT
				_cInscricao := oNFE:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
				_cChave     := oNFE:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT
				_cMunicipio := "SEFAZ"
			Endif
		Endif
	Else
		_cHistorico := "*** ERRO AO ABRIR ARQUIVO XML"
		_dEmissao   := ""
		_cNumero    := "*** ERRO AO LER XML"
		_cRemetente := ""
		_cChave     := ""
		_cMunicipio := ""
		_cInscricao := ""
	Endif
	// retorna
	_oHistorico:Refresh()
	_oEmissao:Refresh()
	_oNumero:Refresh()
	_oRemetente:Refresh()
	_oChave:Refresh()
	_oMunicipio:Refresh()
	_oEmissao:Refresh()
	_oSeleciona:Refresh()
Endif

// retorna
Return


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fBaixaXML
Processa({||fProcPop(.F.)},"Verificando conta de email...")
fDiretorio()
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SchedXML
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
fProcPop(.T.)
RESET ENVIRONMENT
Return


Static Function fProcPop(_lConsole)

// declaracao de variaveis
Local lResulConn 	:= .T.
Local lResulPop 	:= .T.
Local lResult 		:= .T.
Local cError 		:= ""
Local cEmail 		:= ""
Local cPass 		:= ""
Local lRelauth 		:= ""
Local cDe 		    := ""
Local cPara 		:= ""
Local cCc 		    := ""
Local cBcc 		    := ""
Local cAssunto 		:= ""
Local aAnexo 		:= {}
Local cMsg 		    := ""
Local cPath 		:= ""
Local nMsgCount		:= 0
Local nNumber 		:= 0
Local nTimeOut		:= 1000
Local lDeleta  		:= .T.  //apaga mensagens apos baixar?
Local nA 		    := ""
Local cUser 		:= ""

// variaveis de configuracao do servidor de email
/*
cSrvPop 	:= GetNewPar("MV_XMLPOP3","imap.maisolucoes.com.br")
cSrvSmtp 	:= GetNewPar("MV_XMLSMTP","smtp.maisolucoes.com.br")
cEmail 		:= GetNewPar("MV_XMLMAIL","gefco@maisolucoes.com.br")
cUser 		:= GetNewPar("MV_XMLUSER","gefco@maisolucoes.com.br")
cPass 		:= GetNewPar("MV_XMLPASS","gefco9913")
lRelauth 	:= GetNewPar("MV_XMLAUTH",.F.)
*/
cSrvPop 	:= GetNewPar("MV_XMLPOP3","10.62.160.192")
cSrvSmtp 	:= GetNewPar("MV_XMLSMTP","10.62.160.89")
cEmail 		:= GetNewPar("MV_XMLMAIL","nfe@gefco.com.ar")
cUser 		:= GetNewPar("MV_XMLUSER","nfe")
cPass 		:= GetNewPar("MV_XMLPASS","teywrimlinlexMoi")
lRelauth 	:= GetNewPar("MV_XMLAUTH",.F.)
cPath 		:= GetNewPar("MV_XMLPATH","\xml-recebida\inbox\")

// cria direotrio
MontaDir(cPath)

// conecta no servidor de emails
lResulConn := MailPopOn(cSrvPOP,cUser,cPass,nTimeOut)
If !lResulConn
	cError := MailGetErr()
	If _lConsole
		ConOut("SCHED-XML: Falha na conexao com o servidor de email: "+cError)
	Else
		MsgAlert("Falha na conexao com o servidor de email"+Chr(13)+"---"+Chr(13)+cError)
	Endif
	Return
Endif

// caso tenha que ter autenticacao
If lRelauth
	lResult := MailAuth(Alltrim(cEmail), Alltrim(cPass))
	If !lResult
		lResult := MailAuth(Alltrim(cUser), Alltrim(cPass))
	Endif
Endif

// continua
If lResult
	
	//Confere quantidade de mensagens para baixar
	PopMsgCount(@nMsgCount)
	
	// processa mensagens
	If !_lConsole
		ProcRegua(nMsgCount)
	Endif
	For nNumber := 1 to nMsgCount
		
		// incrementa regua
		If _lConsole
			ConOut("SCHED-XML: Transferindo email " + AllTrim(Str(nNumber)) + " de " + AllTrim(Str(nMsgCount)))
		Else
			IncProc("Transferindo email " + AllTrim(Str(nNumber)) + " de " + AllTrim(Str(nMsgCount)))
		Endif
		
		//Baixa os anexos para o diretorio temporario _Inbox
		lResulPop := MailReceive(nNumber,@cDe,@cPara,@cCc,@cBcc,@cAssunto,@cMsg,@aAnexo,cPath,lDeleta)
		
		// analisa se apresentou erro
		If !lResulPop
			
			// exibe mensagem de erro
			cError := MailGetErr()
			If _lConsole
				ConOut("SCHED-XML: Falha no recebimento do e-mail [ " + AllTrim(Str(nNumber)) + " ]" + Chr(13) + cError)
			Else
				MsgAlert("Falha no recebimento do e-mail [ " + AllTrim(Str(nNumber)) + " ]" + Chr(13) + cError)
			Endif
			
		Else
			
			// salva detalhes da mensagem num arquivo texto
			_cDirTXT := GetNewPar("MV_XDIRXML","\xml-recebida\")+"mail_txt\"
			MontaDir(_cDirTXT)
			_cArqMail := _cDirTXT+DTOS(date())+"_"+StrTran(time(),":","")+"_"+StrZero(nNumber,9)+".txt"
			_nHandle  := fCreate(_cArqMail,0)
			
			// monta linha com o conteudo do email
			_xLinha   := "DE:       " + cDe 	+CRLF
			_xLinha   += "PARA:     " + cPara 	+CRLF
			_xLinha   += "CC:       " + cCc		+CRLF
			_xLinha   += "BCC:      " + cBcc	+CRLF
			_xLinha   += Replicate("-",30)		+CRLF
			_xLinha   += "ASSUNTO:  " + cAssunto	+CRLF
			_xLinha   += Replicate("-",30)		+CRLF
			_xLinha   += "MENSAGEM: " + cMsg	+CRLF
			_xLinha   += Replicate("-",30)		+CRLF
			_XLinha   += "ANEXOS:"+CRLF
			
			// grava no arquivo
			fWrite(_nHandle,_xLinha,Len(_xLinha))
			
			// fecha arquivo
			fClose(_nHandle)
			
			// mostra arquivos salvos
			If _lConsole
				For _nA := 1 To Len(aAnexo)
					ConOut("SCHED-XML: Salvando Anexo email " + AllTrim(Str(nNumber)) + " Arquivo " + aAnexo[_nA,1])
				Next
			Endif
			
			
		Endif
		
	Next
	
Else
	
	If _lConsole
		ConOut("SCHED-XML: Falha na autenticação do e-mail:" + cError)
	Else
		MsgAlert("Falha na autenticação do e-mail:" + cError)
	Endif
	
Endif

//Fecha conexão
MailPopOff()

// efetua organizacao dos arquivos...
If _lConsole
	fOrgInbox(.T.)
Else
	Processa({|| fOrgInbox(.F.)},"Organizando pastas inbox...")
Endif
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fMoveXML

// declaracao de variaveis
Local _cArqXML    := _aListXML[_oListXML:nAT,2]
Private _cDirDest := "", _aDirDest := aClone(_aDiretorio), _oDirDest
Private _cEmpDest := "", _oEmpDest

DEFINE MSDIALOG _oMover TITLE OemToAnsi("Mover arquivo XML de pasta") FROM 000,000 TO 245,427 PIXEL OF GetWndDefault()

@ 001,002 TO 024,212 LABEL "Arquivo XML:"  OF _oMover PIXEL
@ 009,007 MSGET _cArqXML SIZE 200,8 WHEN .F. OF _oMover PIXEL

@ 031,002 TO 064,212 LABEL "Localizacao atual do arquivo:"  OF _oMover PIXEL
@ 039,007 MSGET _cEmpresa   SIZE 200,8 WHEN .F. OF _oMover PIXEL
@ 051,007 MSGET _cDiretorio SIZE 200,8 WHEN .F. OF _oMover PIXEL

@ 071,002 TO 104,212 LABEL "Informe o local para onde deseja mover"  OF _oMover PIXEL
@ 079,007 COMBOBOX _oDirDest VAR _cDirDest ITEMS _aDirDest SIZE 200,10 VALID(fMoveVLD()) OF _oMover PIXEL
@ 091,007 MSGET _oEmpDest VAR _cEmpDest SIZE 200,8 WHEN .F. OF _oMover PIXEL

@ 108,182 BUTTON OemToAnsi("Confirma") SIZE 30,12 OF _oMover ACTION(fMoveConf(_cArqXML)) PIXEL

// ativa tela
ACTIVATE DIALOG _oMover CENTERED

// retonra
Return

Static Function fMoveConf(_cArqXML)
// valida diretorio
If _cDirDest == _cDiretorio
	MsgAlert("O diretorio/empresa de destino escolhido, e o mesmo que o atual, nao sera possivel mover, verifique!")
	Return
Endif
// move arquivo
MontaDir(_cDirDest)
__CopyFile(_cDiretorio+_cArqXML,_cDirDest+_cArqXML)
If !File(_cDirDest+_cArqXML)
	MsgAlert("Problemas na copia do arquivo para diretorio de destino, verifique!")
	Return
Else
	fErase(_cDiretorio+_cArqXML)
	MsgInfo("Arquivo movido com sucesso!")
	_oMover:End()
Endif
// atualiza listbox
fDiretorio()
Return

Static Function fMoveVLD
// busca dados da empresa destino
_cEmpDest := ""
DbSelectArea("SM0")
DbSetOrder(1)
_nRegSM0 := Recno()
DbGoTop()
While !SM0->(EOF())
	If SM0->M0_CODIGO == cEmpAnt
		If SM0->M0_CGC == LEFT(RIGHT(_cDirDest,15),14)
			_cEmpDest := SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL
		Endif
	Endif
	SM0->(DbSkip())
End
DbGoTo(_nRegSM0)
// retorna
_oEmpDest:Refresh()
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDiretorio
Processa({|| fBuscaXML(.T.,.F.)},"Atualizando lista dos arquivos XML salvos no servidor...")
// refresh na tela
_cHistorico := ""
_dEmissao   := ""
_cNumero    := ""
_cRemetente := ""
_cChave     := ""
_cMunicipio := ""
_cInscricao := ""
_oHistorico:Refresh()
_oEmissao:Refresh()
_oNumero:Refresh()
_oRemetente:Refresh()
_oChave:Refresh()
_oMunicipio:Refresh()
_oEmissao:Refresh()
_oSeleciona:Refresh()
fXMLChange()
Return(.T.)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ChkNfeLnk(cEmp,cFil)
DEFAULT cEmp := "01"
DEFAULT cFil := "01"
//PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil
fCheckLink()
//RESET ENVIRONMENT
Return

Static Function fCheckLink

// declaracao de vairaveis

_nHoras := GetMV("MV_SPEDEXC")


Return


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fOrgInbox(_lConsole)

// declaracao de variaveis
Local cPath := GetNewPar("MV_XMLPATH","\xml-recebida\inbox\")
Local nHdl, nTamFile, cBuffer, nBtLidos, cAviso, cErro, oNFE, cArqXML

// busca arquivos xml
_aFiles := Directory(cPath + "*.XML")
If !_lConsole
	ProcRegua(Len(_aFiles))
Endif
For _na := 1 To Len(_aFiles)
	If _lConsole
		ConOut("XML OrgInbox: " +_aFiles[_nA,1])
	Else
		IncProc(_aFiles[_nA,1])
	Endif
	
	// abre arquivo
	cArqXML     := _aFiles[_nA,1]
	nHdl 		:= fOpen(cPath+cArqXML,0)
	nTamFile 	:= fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	cBuffer  	:= Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
	nBtLidos 	:= fRead(nHdl,@cBuffer,nTamFile) // Leitura da primeira linha do arquivo texto
	fClose(nHdl)
	
	// efetua leitura do xml
	cAviso 		:= ""
	cErro  		:= ""
	oNFE 		:= XmlParser(cBuffer,"_",@cAviso,@cErro)
	
	// verifica se tem erro na abertura
	If Empty(cErro) .Or. oNFE <> NIL
		
		// zera variavel
		_cCNPJDest := ""
		
		// nota fiscal de produtos ( sefaz )
		If AT("NFEPROC",UPPER(cBuffer)) > 0
			_cCNPJDest := oNFE:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
		Endif
		
		// nota fiscal de servicos ( rio de janeiro )
		If AT("CONSULTARNFSERESPOSTA",UPPER(cBuffer)) > 0
			_cCNPJDest := oNFE:_CONSULTARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_TOMADORSERVICO:_IDENTIFICACAOTOMADOR:_CPFCNPJ:_CNPJ:TEXT
		Endif
		
		// caso encontre o CNPJ move o arquivo de diretorio
		If !Empty(_cCNPJDest)
			_cArqDEST := GetNewPar("MV_XDIRXML","\xml-recebida\")+_cCNPJDest+"\"+cArqXML
			_cArqORIG := GetNewPar("MV_XMLPATH","\xml-recebida\inbox\")+cArqXML
			// cria diretorio
			If _lConsole
				ConOut("XML OrgInbox: Diretorio " + GetNewPar("MV_XDIRXML","\xml-recebida\")+_cCNPJDest+"\")
			Endif
			MontaDir(GetNewPar("MV_XDIRXML","\xml-recebida\")+_cCNPJDest+"\")
			// verifica se ja existe o arquivo
			If File(_cArqDEST)
				If !_lConsole
					MsgInfo("Ja existe o arquivo [ " + cArqXML + " ], " + Chr(13) + "no diretorio do CNPJ [ " + _cCNPJDest + " ]." + Chr(13)+ "O arquivo sera renomeado com uma numeracao sequencial para que seja copiado.")
				Endif
				_cSeqDEST := "002"
				While File(_cArqDEST)
					_cArqDEST := LEFT(_cArqDEST,Len(_cArqDEST)-4)+"_"+_cSeqDEST+".XML"
					_cSeqDEST := SOMA1(_cSeqDEST)
				End
			Endif
			// efetua copia
			__CopyFile(_cArqORIG,_cArqDEST)
			If !File(_cArqDEST)
				If _lConsole
					ConOut("XML OrgInbox: Problemas na copia do arquivo [ " + cArqXML + " ] para diretorio do CNPJ [ " + _cCNPJDest + " ] de destino, verifique!")
				Else
					MsgAlert("Problemas na copia do arquivo [ " + cArqXML + " ] para diretorio do CNPJ [ " + _cCNPJDest + " ] de destino, verifique!")
				Endif
			Else
				fErase(_cArqORIG)
			Endif
		Endif
		
	Endif
Next

// retorna
Return

