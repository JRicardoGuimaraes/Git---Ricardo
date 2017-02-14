#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "folder.ch"
#include "colors.ch"
#include "Font.ch"
#include "tbiconn.ch"
#INCLUDE "Vkey.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XMLLEGADO º Autor ³ E.L.O.		     º Data ³  11/03/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ XML Legados da GEFCO, sao listados, feito uma busca na SF1,º±±
±±º          ³ se encontrar a NF, grava o XML no campo MEMO e o caminho.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEFCO                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function XMLLEGADO()
Private _aRegs	:= {}
Private _cPerg  := "XMLLEGADO"

// variaveis usadas em outras funcoes
Private _oCNPJ	    , _cCNPJ	  := ""
Private _oCNPJFO    , _cCNPJFO	  := ""
Private _oNumero    , _cNumero    := ""
Private _oHistorico , _cHistorico := ""
Private _oRemetente , _cRemetente := ""
Private _oMunicipio , _cMunicipio := ""
Private _oInscricao , _cInscricao := ""
Private _oChave     , _cChave     := ""
Private _oEmissao   , _dEmissao   := CTOD("")
Private _oDocSF1    , _cDocSF1    := ""
Private _oFilSF1    , _cFilSF1    := ""
Private _oForSF1    , _cForSF1    := ""
Private _oEmiSF1    , _dEmiSF1    := CTOD("")
Private _oDigSF1    , _dDigSF1    := CTOD("")

//Pergunta a série das RPS e a data de inicio para a busca
AADD(_aRegs,{_cPerg,"01","Caminho do(s) arquivo(s):    ","","","MV_CHA","C",050,0,0,"G","U_CAMINHO","MV_PAR01",""     ,"","","","",""          ,"","","","","","","","","","","","","","","","","",""," ","",""})

ValidPerg(_aRegs,_cPerg)

If !Pergunte(_cPerg,.T.)
	Return
Endif

// exibe tela com os arquivos XML's disponiveis para importacao
LjMsgRun("Listando os arquivos XML...","GEFCO - Importa XML legado.",{|| fListXML()})

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fListXML

// declaracao de varivaeis
Local _aArea      := GetArea()
Local _cDirXML    := mv_par01
Local _cDirCNPJ   := _cDirXML + SM0->M0_CGC + "\"
Private _aListXML := {}, _oListXML
Private oEnable   := LoadBitmap( GetResources(), "ENABLE" )
Private oDisable  := LoadBitmap( GetResources(), "DISABLE" )
Private _oSeleciona
Private _oEmpresa, _cEmpresa := SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL
Private _oDiretorio, _cDiretorio := "", _aDiretorio := {}

// analisa caixa inbox
Processa({|| fOrgInbox(.F.,.F.)},"Aguarde")

// busca arquivos no diretorio
Processa({|| fBuscaXML(.F.,.F.)},"Aguarde")

// monta tela para exibir os registros
DEFINE MSDIALOG _oSeleciona TITLE OemToAnsi("Importacao de XML legado") FROM 000,000 TO 467,980 PIXEL OF GetWndDefault()

@ 001,002 TO 022,274 LABEL "Empresa/Filial"  OF _oSeleciona PIXEL
@ 009,007 MSGET _oEmpresa VAR _cEmpresa SIZE 260,8  WHEN .F. OF _oSeleciona PIXEL
@ 001,280 TO 022,450 LABEL "CNPJ destino: "  OF _oSeleciona PIXEL
@ 009,285 MSGET _oCNPJ VAR _cCNPJ SIZE 150,8  WHEN .F. OF _oSeleciona PIXEL

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
@ 170,395 SAY "Filial" SIZE 50,8 OF _oSeleciona PIXEL
@ 168,435 MSGET _oFilSF1 VAR _cFilSF1 SIZE 50,8 WHEN .F. OF _oSeleciona PIXEL
@ 185,285 SAY "Fornecedor:" SIZE 50,8 OF _oSeleciona PIXEL
@ 183,325 MSGET _oForSF1 VAR _cForSF1 SIZE 160,8 PICTURE "@!" WHEN .F. OF _oSeleciona PIXEL
@ 200,285 SAY "Emissao:" SIZE 50,8 OF _oSeleciona PIXEL
@ 198,325 MSGET _oEmiSF1 VAR _dEmiSF1 SIZE 50,8 WHEN .F. OF _oSeleciona PIXEL
@ 200,395 SAY "Digitacao" SIZE 50,8 OF _oSeleciona PIXEL
@ 198,435 MSGET _oDigSF1 VAR _dDigSF1 SIZE 50,8 WHEN .F. OF _oSeleciona PIXEL

// botoes controle
@ 220,283 BUTTON OemToAnsi("Importar XML posicionado")    	SIZE 65,12 OF _oSeleciona ACTION(fImpXMLP())  PIXEL WHEN .T. 
@ 220,353 BUTTON OemToAnsi("Importar Todos")    			SIZE 65,12 OF _oSeleciona ACTION(fImpXMLT())  PIXEL WHEN .T.
//@ 220,423 BUTTON OemToAnsi("Relatorio")    				SIZE 65,12 OF _oSeleciona ACTION(fRelImp())  PIXEL WHEN .T.
@ 220,423 BUTTON OemToAnsi("Log de processamento")			SIZE 65,12 OF _oSeleciona ACTION(msginfo("Em desenvolvimento."))  PIXEL WHEN .T.

/*
@ 220,318 BUTTON OemToAnsi("Filtra N.Imp")    SIZE 30,12 OF _oSeleciona ACTION(fFiltraXML()) PIXEL WHEN .F.
@ 220,353 BUTTON OemToAnsi("Abrir XML")       SIZE 30,12 OF _oSeleciona ACTION(fAbreXML())   PIXEL
@ 220,388 BUTTON OemToAnsi("Check Link")      SIZE 30,12 OF _oSeleciona ACTION(fLinkXML())   PIXEL
@ 220,423 BUTTON OemToAnsi("Mover XML")       SIZE 30,12 OF _oSeleciona ACTION(fMoveXML())   PIXEL
@ 220,458 BUTTON OemToAnsi("Seleciona")       SIZE 30,12 OF _oSeleciona ACTION(fSeleciona()) PIXEL
*/

// ativa tela
ACTIVATE DIALOG _oSeleciona CENTERED

// retorna
RestArea(_aArea)
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fOrgInbox(_lConsole,_lxmlerro,cTo,_cArqMail)

// declaracao de variaveis
Local cPath := mv_par01
Local nHdl, nTamFile, cBuffer, nBtLidos, cAviso, cErro, oNFE, cArqXML, _cArqDel, _lcnpj , _recsm0_, _lxmlCanc 

// busca arquivos xml
_aFiles := Directory(cPath + "*.XML")
If !_lConsole
	ProcRegua(Len(_aFiles))
Endif
For _na := 1 To Len(_aFiles)
	If _lConsole
		ConOut("XML Organizando : " +_aFiles[_nA,1])
	Else
		IncProc("Buscando : "+_aFiles[_nA,1])
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
	oNFE 		:= XmlParser(cBuffer,"_",@cErro,@cAviso)
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

		//Verifica se o XML esta cancelado      
		IF AT("NFSECANCELAMENTO",UPPER(cBuffer)) > 0
			_lxmlCanc := .t.       
		else
			_lxmlCanc := .f.		
		endif                                             
	
	elseif !empty(cErro) 
		//Xml com erro
		if _lxmlerro
			_cArqDel := mv_par01+cArqXML
			//no arquivo txt, as vezes vem o nome antes do e-mail, pego somente o e-mail que esta entre os caracteres < e >.
			_nposini := AT("<",cto)
			_nposfim := AT(">",cto)
			_ndif	 := _nposfim - _nposini
			cto	:= substr(cto,_nposini+1,_ndif)
			cto	:= strtran(cTo,"<","")
			cto	:= strtran(cTo,">","")		
			cto := alltrim(cto)	             
			U_EnvEMail('relatorio@gefco.com.ar',cto,,"Arquivo XML com erro.","Arquivo: " + cArqXML + ", com erro, envie o arquivo valido para o e-mail : 'nfe@gefco.com.ar'.                MENSAGEM AUTOMÁTICA, NÃO RESPONDA!",)
			if _lConsole
				ConOut("Arquivo: " + cArqXML + ", com erro. Remetente notificado atraves do e-mail: "+cTo)					
			else
				Msginfo("Arquivo: " + cArqXML + ", com erro. Remetente notificado atraves do e-mail: "+cTo,"Atenção")	
			endif
			if file(_cArqDel)
			    Ferase(_cArqDel)
			endif
			if file(_cArqMail)			
			    Ferase(_cArqMail)			
			endif
		endif              
	Endif
	//Se o xml estiver cancelado apaga arquivo recebido.{ 
	if _lxmlCanc                 
		if file(mv_par01+cArqXML)  
		    Ferase(mv_par01+cArqXML)
		endif
		_lxmlCanc := .f.
    endif
    
Next

// retorna
Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fBuscaXML(_lRefresh,_lFiltro)

// declaracao de variaveis
Local _aFiles   := {}
Local _lNFEImport := .T.

// busca arquivos do diretorio
_aFiles := Directory(MV_PAR01 + "*.XML")

ProcRegua(Len(_aFiles))

// adiciona no array
_aListXML := {}
For _nI := 1 To Len(_aFiles)
	IncProc("Organizando : "+_aFiles[_nI,1])
	AADD(_aListXML,Array(99))
	// verifica se nota ja foi importada
	_cQrySF1 := "SELECT F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_EMISSAO, F1_DTDIGIT"
	_cQrySF1 += "  FROM " + RetSqlName("SF1")
	_cQrySF1 += "  WHERE D_E_L_E_T_ <> '*' AND"
	_cQrySF1 += "        F1_XARQXML LIKE '%" + AllTrim(_aFiles[_nI,1]) + "%'"
	TCQUERY _cQrySF1 NEW ALIAS "TSF1"
	If !Empty(TSF1->F1_DOC)
		_lNFeImport := .F.
	Else
		_lNFeImport := .T.
	Endif
	TSF1->(DbCloseArea())
	// adiciona no array
	_aListXML[Len(_aListXML),01] := _lNFeImport
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
_cCNPJ		:= ""

// abre arquivo
If !Empty(_aListXML[_oListXML:nAT,2])
	nHdl := fOpen(mv_par01+AllTrim(_aListXML[_oListXML:nAT,7]+_aListXML[_oListXML:nAT,2]),0)
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
				_cCNPJ		:= oNFE:_CONSULTARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_TOMADORSERVICO:_IDENTIFICACAOTOMADOR:_CPFCNPJ:_CNPJ:TEXT
				_cCNPJFO	:= oNFE:_CONSULTARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_PRESTADORSERVICO:_IDENTIFICACAOPRESTADOR:_CNPJ:TEXT				
			Endif
			If AT("NFEPROC",UPPER(cBuffer)) > 0
//				_cHistorico := oNFE:_NFEPROC:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT
				_cHistorico := ""
				_dEmissao   := oNFE:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT
				_cNumero    := oNFE:_NFEPROC:_NFE:_INFNFE:_IDE:_CNF:TEXT
				_cRemetente := oNFE:_NFEPROC:_NFE:_INFNFE:_EMIT:_XNOME:TEXT
				_cInscricao := oNFE:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
				_cCNPJ		:= oNFE:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
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
	_oCNPJ:Refresh()
	// busca dados da NFE caso ja importada
	_cQrySF1 := "SELECT F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_EMISSAO, F1_DTDIGIT"
	_cQrySF1 += "  FROM " + RetSqlName("SF1")
	_cQrySF1 += "  WHERE D_E_L_E_T_ <> '*' AND"
	_cQrySF1 += "        F1_XARQXML LIKE '%" + _aListXML[_oListXML:nAT,2] + "%'"
	TCQUERY _cQrySF1 NEW ALIAS "TSF1"
	If !Empty(TSF1->F1_DOC)
		_cDocSF1    := TSF1->F1_DOC + "/" + TSF1->F1_SERIE
		_cForSF1    := POSICIONE("SA2",1,xFilial("SA2")+TSF1->F1_FORNECE+TSF1->F1_LOJA,"A2_NOME")
		_dEmiSF1    := STOD(TSF1->F1_EMISSAO)
		_dDigSF1    := STOD(TSF1->F1_DTDIGIT)
		_cFilSF1    := TSF1->F1_FILIAL
	Else
		_cDocSF1    := ""
		_cForSF1    := ""
		_dEmiSF1    := CTOD("")
		_dDigSF1    := CTOD("")
		_cFilSF1    := ""
	Endif
	TSF1->(DbCloseArea())
	// refresh no quadro
	_oDocSF1:Refresh()
	_oForSF1:Refresh()
	_oEmiSF1:Refresh()
	_oDigSF1:Refresh()
	_oFilSF1:Refresh()
	// refresh na tela
	_oSeleciona:Refresh()
Endif

// retorna
Return


//Escolhe o caminho para geração do arquivo.
User Function caminho()
private cPath := space(50)

	cPath := cGetFile(,OemToAnsi("Selecione Diretorio"),,,.f.,GETF_LOCALHARD+GETF_RETDIRECTORY+GETF_NETWORKDRIVE,.f.)
	if !empty(cpath)
		mv_par01 := alltrim(cpath)
		return(.t.)
	else
		msgstop("Informe o caminho para geração do arquivo.","Atenção")
		return(.f.)
	endif
	
return()

//Importa XML Posicionado.
Static function fImpXMLP()
local nRecSM0 := 0
local nOrdSM0 := 0         
local cfilial := ""
local cfornece:= ""
local cloja   := ""

//if !_aListXML[_oListXML:nAT,1]
//	msginfo("XML ja importado.","Atencao")
//	return
//endif 

//Localiza a filial do CNPJ destino.
dbSelectArea("SM0")
nRecSM0 := SM0->(Recno())
nOrdSM0 := SM0->(IndexOrd())
dbGoTop()
While !SM0->(Eof())
	If alltrim(sm0->m0_cgc) == alltrim(_cCNPJ)
		cfilial := sm0->m0_codfil
		exit
	endif
	SM0->(dbSkip())
EndDo
SM0->(dbSetOrder(nOrdSM0))
SM0->(dbGoTo(nRecSM0))

if empty(cfilial)
	msginfo("CNPJ : "+_cCNPJ+", nao encontrado no cadastro de empresas.","Verifique")
	return
endif

//Localiza o codigo do fornecedor pelo CNPJ
dbselectarea("SA2")
dbsetorder(3)
if dbseek(xfilial("SA2")+_cCNPJFO)
	cfornece := sa2->a2_cod
	cloja	 := sa2->a2_loja
else
	msginfo("Fornecedor nao encontrado, CNPJ : "+_cCNPJFO)
endif	

//Localiza Nota fiscal de entrada
dbselectarea("SF1")      
dbsetorder(2)
if dbseek(cfilial+cfornece+cloja+_cnumero)
	msginfo("Encontrou a NF ")                                 
elseif dbseek(cfilial+cfornece+cloja+strzero(val(_cnumero),9)) 
	msginfo("Encontrou a NF ") 
else	
	msginfo("Nao encontrou a NF, na tabela de cabecalho (SF1), indice 2 (filial+fornecedor+loja+numero) : "+cfilial+cfornece+cloja+_cnumero)
	gravalog(1,ddatabase,cfilial,cfornece,cloja,_cnumero)
endif

return

//Grava log de pocessamento
Static function Gravalog(ntipo,dataimp,filial,fornece,loja,numero)
LOCAL cDirDocs   := MsDocPath() 
Local aStru	 	 := {}
Local cArquivo   := iif(ntipo == 1,"log-naoencontrados","log-encontrados")
Local cPath		 := AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	 := Chr(13) + Chr(10)
Local nX     
Local cnome		 := posicione("SA2",1,xfilial("SA2")+fornece+loja,"A2_NOME")
Local cLinha	 := ""

if !file(cDirDocs+"\"+cArquivo+".CSV")

	aStru := {	{"Data Imp."	, "D", 08, 0},;
				{"Filial"		, "C", 02, 0},;
				{"Cod. Forn."	, "C", TAMSX3("A2_COD")[1], 0},;
				{"Loja Forn."	, "C", TAMSX3("A2_LOJA")[1], 0},;
				{"Nome"			, "C", TAMSX3("A2_NOME")[1], 0},;
				{"Numero"		, "C", TAMSX3("F1_DOC")[1], 0}}
	
	nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

	If nHandle > 0
		// Grava o cabecalho do arquivo
		aEval(aStru, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aStru), ";", "") ) } )
		fWrite(nHandle, cCrLf ) 
	Endif		

	fWrite(nHandle, dtoc(dataimp) + ";" + filial + ";" + fornece + ";" + loja + ";" + cnome	+ ";" + numero  + Chr(13) + Chr(10),500)
	fClose(nHandle)              
	
else

	msginfo("Arquivo de log existe.","Atencao")

	nHandle := fopen(cDirDocs+"\"+cArquivo+".CSV",FO_EXCLUSIVE + FO_WRITE )   
	
	If nHandle > 0

		fWrite(nHandle, dtoc(dataimp) + ";" + filial + ";" + fornece + ";" + loja + ";" + cnome	+ ";" + numero  + Chr(13) + Chr(10),500)
		fClose(nHandle)

	else
		
		msginfo("Nao foi possivel abrir o arquivo : "+cDirDocs+"\"+cArquivo+".CSV","Atencao")
	
	endif

	msginfo("vamos ver o resultado")		
		
endif

msginfo("Log gravado.","Atencao")

Return