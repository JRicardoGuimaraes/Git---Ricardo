#include "protheus.ch"
#include "topconn.ch"
#include "ap5mail.ch"
#include "tbiconn.ch"
#INCLUDE "XMLXFUN.CH"

/////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa:   GETMXML baseado em IMPRTXML   	       Data 01/08/13                               //
// Descricao:  Importacao do arquivo XML ref. NFe preenchendo a tabela SZ6 para ser usada em CT-e  //
// Autor:      Ricardo Guimarães                                                                   //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Static Function fBaixaXML
USER Function fBxXML_CTe(_lBxEmail)
If _lBxEmail == NIL
	_lBxEmail := .F.            
EndIf	
If _lBxEmail
	Processa({||fProcPop(.F.)},"Verificando conta de email...")
EndIf	
Processa({|| fOrgInbox(.F.)},"Organizando pastas inbox...")
//fDiretorio()
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SchedBXXML
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "43" TABLES "SA1","SZ6","SM4"
fProcPop(.T.)
RESET ENVIRONMENT
Return

User Function SchedGRVXML
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" TABLES "SA1","SZ6","SM4"
fOrgInbox(.T.)
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
Local lRelauth 	:= ""
Local cDe 		   := ""
Local cPara 		:= ""
Local cCc 		   := ""
Local cBcc 		   := ""
Local cAssunto 	:= ""
Local aAnexo 		:= {}
Local cMsg 		   := ""
Local cPath 		:= ""
Local nMsgCount	:= 0
Local nNumber 		:= 0
Local nTimeOut		:= 1600
Local lDeleta  	:= .T.  //apaga mensagens apos baixar?
Local nA 		   := ""
Local cUser 		:= ""
Local bError := ErrorBlock( { |oError| MyErrorXML( oError ) } )

// variaveis de configuracao do servidor de email
/*
cSrvPop 	:= GetNewPar("MV_XMLPOP3","imap.maisolucoes.com.br")
cSrvSmtp 	:= GetNewPar("MV_XMLSMTP","smtp.maisolucoes.com.br")
cEmail 		:= GetNewPar("MV_XMLMAIL","gefco@maisolucoes.com.br")
cUser 		:= GetNewPar("MV_XMLUSER","gefco@maisolucoes.com.br")
cPass 		:= GetNewPar("MV_XMLPASS","gefco9913")
lRelauth 	:= GetNewPar("MV_XMLAUTH",.F.)
*/                    

/*
cSrvPop   	:= GetNewPar("MV_XMLPOP3","10.62.160.192")
cSrvSmtp 	:= GetNewPar("MV_XMLSMTP","10.62.160.89")
cEmail 		:= GetNewPar("MV_XMLMAIL","cte@gefco.com.ar")
cUser 		:= GetNewPar("MV_XMLUSER","cte")
cPass 		:= GetNewPar("MV_XMLPASS","Gefc0+123")
lRelauth 	:= GetNewPar("MV_XMLAUTH",.f.)
cPath 		:= GetNewPar("MV_XMLPATH","\xml-recebida-CTe\inbox\")
*/
// Por: Ricardo Guimarães - Em: 05/08/2015(vide e-mail do Rogério do dia) - Antes usar o servidor Linux, a partir desta data passou a usar o servidor Exchange da Gefco
cSrvPop   	:= GetNewPar("MV_XMLPOP3","10.62.160.131")
cSrvSmtp 	:= GetNewPar("MV_XMLSMTP","10.62.160.131")
cEmail 		:= GetNewPar("MV_XMLMAIL","cte@gefco.com.ar")
cUser 		:= GetNewPar("MV_XMLUSER","gm-gbal-mbg2060")
cPass 		:= GetNewPar("MV_XMLPASS","2015+cte")
lRelauth 	:= GetNewPar("MV_XMLAUTH",.f.)
cPath 		:= GetNewPar("MV_XMLPATH","\xml-recebida-CTe\inbox\")

// cria direotrio
MontaDir(cPath)

BEGIN SEQUENCE

	// conecta no servidor de emails
	lResulConn := MailPopOn(cSrvPop,cUser,cPass,nTimeOut)
	If !lResulConn
		cError := MailGetErr()
		If _lConsole
			ConOut("SCHED-XML: Falha na conexao com o servidor de email: "+cError)
			MsgAlet("SCHED-XML: Falha na conexao com o servidor de email: "+cError)		
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
		Else
			CONOUT("Total de Msg ==> " + AllTrim(Str(nMsgCount)) )
		Endif
		
		For nNumber := 1 to nMsgCount
			
			// incrementa regua
			If _lConsole
				// ConOut("SCHED-XML: Transferindo email " + AllTrim(Str(nNumber)) + " de " + AllTrim(Str(nMsgCount)))
				//MsgAlert("SCHED-XML: Transferindo email " + AllTrim(Str(nNumber)) + " de " + AllTrim(Str(nMsgCount)))			
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
					//MsgAlert("SCHED-XML: Falha no recebimento do e-mail [ " + AllTrim(Str(nNumber)) + " ]" + Chr(13) + cError)				
				Else
					MsgAlert("Falha no recebimento do e-mail [ " + AllTrim(Str(nNumber)) + " ]" + Chr(13) + cError)
				Endif
				
			Else
			/*				
				// salva detalhes da mensagem num arquivo texto
				_cDirTXT := GetNewPar("MV_XDIRXML","\xml-recebida-CTe\")+"mail_txt\"
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
						// ConOut("SCHED-XML: Salvando Anexo email " + AllTrim(Str(nNumber)) + " Arquivo " + aAnexo[_nA,1])
					Next
				Endif
				
			*/	
			Endif
			
		Next
		
	Else
		
		If _lConsole
			ConOut("SCHED-XML: Falha na autenticação do e-mail:" + cError)
			MsgAlert("SCHED-XML: Falha na autenticação do e-mail:" + cError)		
			
		Else
			MsgAlert("Falha na autenticação do e-mail:" + cError)
		Endif
		
	Endif
	
	//Fecha conexão
	MailPopOff()

RECOVER //"Se ocorreu erro, após o BREAK, venho para cá"

	//Restaurando bloco de erro do sistema
	ErrorBlock( bError )
			
END SEQUENCE		

// efetua organizacao dos arquivos...
If _lConsole
	fOrgInbox(.T.)
Else
	Processa({|| fOrgInbox(.F.)},"Organizando pastas inbox...")
Endif
Return

// Por: Ricardo - Em: 15/05/2015
// Objetivo: Tratamento de erro
*------------------------------------------------*
Static Function MyErrorXML( oError )
*------------------------------------------------*
Local _cMsg := ""
Local _cDe  := GETMV("MV_RELFROM")
Local _cPara:= GETNEWPAR("MV_XLOGXML","jose.guimaraes@gefco.com.br")
Local _cCC  := ""
Local _cAssunto := "LOG ERRO DE CONEXAO COM A CAIXA DE E-MAIL DE XML DE NF-e"

_cMsg := "LOG ERRO DE BAIXA DE XML DE NF-e" + CRLF
_cMsg += "================================" + CRLF
_cMsg += "" + CRLF
_cMsg += "Data/Hora			: " + DTOC(DDATABASE) + " - " + Time() 	+ CRLF
_cMsg += "" + CRLF
_cMsg += "" + CRLF
_cMsg += "" + CRLF
_cMsg += "Mensagem de erro	: " + oError:Description + CRLF
_cMsg += "" + CRLF
_cMsg += "Msg. de error		: " + oError:ErrorStack + CRLF

U_EnvEmail(_cDe,_cPara,,_cAssunto,_cMsg)

BREAK
Return( NIL )


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

*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fOrgInbox(_lConsole)
//dfafdsdfs
// declaracao de variaveis
//Local cPath := GetNewPar("MV_XMLPATH","\xml-recebida-CTe\inbox\")
//Local cPath := GetNewPar("MV_XMLPATH","\xml-recebida-CTe\inbox\TEMP\")
//Local cPath := "\xml-recebida-CTe\inbox\erro\"
Local nHdl, nTamFile, cBuffer, nBtLidos, cAviso, cErro, oNFE // , cArqXML
Local _lAchou := .F.
Local _oTST   := Nil
Local _oNFEAux:= Nil
Local bError := ErrorBlock( { |oError, cPath, cArqXML| MyError( oError ) } )

Private cPath 	:= GetNewPar("MV_XMLPATH","\xml-recebida-CTe\inbox\") 
Private cArqXML := ""

Chkfile("SZ6")  // Tabela de armazenamento de XML
dbSelectArea("SZ6") ; dbSetOrder(1)

// busca arquivos xml
_aFiles := Directory(cPath + "*.XML")
If !_lConsole
	ProcRegua(Len(_aFiles))
Endif

	For _na := 1 To Len(_aFiles)
		
		BEGIN SEQUENCE	
			If _lConsole
				// ConOut("XML OrgInbox: " +_aFiles[_nA,1])
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
			
			// Por: Ricardo - Em: 14/04/2015
			// Tratramento para não processar arquivo XML de CT-e
			If "CT-E" $ UPPER(cArqXML) .OR.  "CTE" $ UPPER(cArqXML)
				_cArqDEST := GetNewPar("MV_XDIRXML","\xml-recebida-CTe\")+"CT-e\"+cArqXML
				_cArqORIG := GetNewPar("MV_XMLPATH","\xml-recebida-CTe\inbox\")+cArqXML
				MontaDir(GetNewPar("MV_XDIRXML","\xml-recebida-CTe\")+"CT-e\")
				__CopyFile(_cArqORIG,_cArqDEST)
				fErase(_cArqORIG)				

				BREAK // Loop
			EndIf	
			
			// efetua leitura do xml
			cAviso 		:= ""
			cErro  		:= ""
			oNFE 		:= XmlParser(cBuffer,"_",@cAviso,@cErro)
			
			// verifica se tem erro na abertura
			If Empty(cErro) .Or. oNFE <> NIL
				
				// zera variavel
				_cCNPJDest := ""
				_cCNPJEmit := ""		
				
				// nota fiscal de produtos ( sefaz )
				If AT("NFEPROC",UPPER(cBuffer)) > 0
					//_cCNPJDest := oNFE:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
					_cCNPJEmit := AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
					_lAchou := .T.
				Else                      
					If !("CANCELAMENTO" $ AllTrim(Upper(cbuffer))) .AND. !("CARTA DE CORRE" $ AllTrim(Upper(cbuffer)))
					 	If XMLCHILDEX(oNFE:_NFE,"_INFNFE") <> Nil		
							_cCNPJEmit := AllTrim(oNFE:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
							_lAchou := .T.							
						EndIf	
					EndIf	
				Endif
		
				// nota fiscal de servicos ( rio de janeiro )
				If AT("CONSULTARNFSERESPOSTA",UPPER(cBuffer)) > 0
					_cCNPJDest := oNFE:_CONSULTARNFSERESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_TOMADORSERVICO:_IDENTIFICACAOTOMADOR:_CPFCNPJ:_CNPJ:TEXT
					_lAchou := .T.			
				Endif
		
				// Se for NF-e ou NFSE não processo
				If _lAchou                                     
					If AT("NFEPROC",UPPER(cBuffer)) > 0
						If AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT) == "EX"
							_cCNPJEmit := "ESTRANGEIRO"
						EndIf
						
						If AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT) == "EX"
							_cCNPJDest := "ESTRANGEIRO"
						EndIf		                                                            
					Else
						If AllTrim(oNFE:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT) == "EX"
							_cCNPJEmit := "ESTRANGEIRO"
						EndIf
						
						If AllTrim(oNFE:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT) == "EX"
							_cCNPJDest := "ESTRANGEIRO"
						EndIf		
					EndIf					
				EndIf
		
				// ID da NF-e
				_cIDNFe 	   := "" 
				_cIDNFeCanc    := ""
				_cIDCanc	   := ""
					
				// CT-e não processado, somente foi movido o XML de pasta	
				If "CANCCTE" $ UPPER(AllTrim(cBuffer)) .OR. "CTEPROC" $ UPPER(AllTrim(cBuffer))
					_cArqDEST := GetNewPar("MV_XDIRXML","\xml-recebida-CTe\")+"CT-e\"+cArqXML
					_cArqORIG := GetNewPar("MV_XMLPATH","\xml-recebida-CTe\inbox\")+cArqXML
					MontaDir(GetNewPar("MV_XDIRXML","\xml-recebida-CTe\")+"CT-e\")
					//__CopyFile(_cArqORIG,_cArqDEST)
					fErase(_cArqORIG)			
				EndIf
									
				// caso encontre o CNPJ move o arquivo de diretorio
				If !Empty(_cCNPJEmit) 
					_cArqDEST := GetNewPar("MV_XDIRXML","\xml-recebida-CTe\")+_cCNPJEmit+"\"+cArqXML
					_cArqORIG := GetNewPar("MV_XMLPATH","\xml-recebida-CTe\inbox\")+cArqXML
					// cria diretorio
					If _lConsole
						// ConOut("XML OrgInbox: Diretorio " + GetNewPar("MV_XDIRXML","\xml-recebida-CTe\")+_cCNPJEmit+"\")
					Endif     
					
					/*
					// Comentado por Ricardo - em: 09/02/2015
					MontaDir(GetNewPar("MV_XDIRXML","\xml-recebida-CTe\")+_cCNPJEmit+"\")
					// verifica se ja existe o arquivo
					If File(_cArqDEST)
						//If !_lConsole
						  //	MsgInfo("Ja existe o arquivo [ " + cArqXML + " ], " + Chr(13) + "no diretorio do CNPJ [ " + _cCNPJEmit + " ]." + Chr(13)+ "O arquivo sera renomeado com uma numeracao sequencial para que seja copiado.")
						//Endif
						_cSeqDEST := "002"
						While File(_cArqDEST)
							_cArqDEST := LEFT(_cArqDEST,Len(_cArqDEST)-8)+"_"+_cSeqDEST+".XML"
							_cSeqDEST := SOMA1(_cSeqDEST)
						End
					Endif 
					*/
					
					// Por: Ricardo Guimarães - Em: 09/08/2013
					// Objetivo: Carregar dados do XML na tabela TABXML   
					******************************************************                    
		 			If AT("NFEPROC",UPPER(cBuffer)) > 0	
						_cIDNFe   := Right(AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_ID:TEXT),44)			
						_cNFe 	  := PadL(AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_IDE:_nNF:TEXT),9,"0")
						_cSerie	  := PadL(AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT),3,"0")
					Else
						_cIDNFe   := Right(AllTrim(oNFE:_NFE:_INFNFE:_ID:TEXT),44)			
						_cNFe 	  := PadL(AllTrim(oNFE:_NFE:_INFNFE:_IDE:_nNF:TEXT),9,"0")
						_cSerie	  := PadL(AllTrim(oNFE:_NFE:_INFNFE:_IDE:_SERIE:TEXT),3,"0")
					EndIf					
		
		 			If AT("NFEPROC",UPPER(cBuffer)) > 0
						If XMLCHILDEX(oNFE:_NFEPROC:_NFE:_INFNFE:_IDE,"_DHEMI") <> Nil
							_cDTEmis   := SubStr(StrTran(AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT),"-",""),1,8)
						Else
							_cDTEmis   := StrTran(AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_IDE:_dEMI:TEXT),"-","")			
						EndIf
					Else
						If XMLCHILDEX(oNFE:_NFE:_INFNFE:_IDE,"_DHEMI") <> Nil
							_cDTEmis   := SubStr(StrTran(AllTrim(oNFE:_NFE:_INFNFE:_IDE:_DHEMI:TEXT),"-",""),1,8)
						Else
							_cDTEmis   := StrTran(AllTrim(oNFE:_NFE:_INFNFE:_IDE:_dEMI:TEXT),"-","")			
						EndIf
					EndIf								                                  
					
					If AT("NFEPROC",UPPER(cBuffer)) > 0
						//_cModelo   := AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_IDE:_MOD:TEXT)
						_cMunic    := AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_IDE:_cMUNFG:TEXT)
						_cModelo   := AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_IDE:_MOD:TEXT)
						// _cCNPJEmit := AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
						_cNomeEmit := UPPER(AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_EMIT:_xNOME:TEXT))
						_cUFEmit   := AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT)
						
						
						If XMLCHILDEX(oNFE:_NFEPROC:_NFE:_INFNFE:_DEST,"_CPF") <> Nil
							_cCNPJDest := AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT)
						Else
							If _cCNPJDest == "ESTRANGEIRO"
								_cCNPJDest := ""
							Else	
								_cCNPJDest := AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
							EndIf	
						EndIf
						_cNomeDest := UPPER(AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_DEST:_xNOME:TEXT))
						_cUFDest   := AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT)
					Else
						//_cModelo   := AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_IDE:_MOD:TEXT)
						_cMunic    := AllTrim(oNFE:_NFE:_INFNFE:_IDE:_cMUNFG:TEXT)
						_cModelo   := AllTrim(oNFE:_NFE:_INFNFE:_IDE:_MOD:TEXT)
						// _cCNPJEmit := AllTrim(oNFE:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
						_cNomeEmit := UPPER(AllTrim(oNFE:_NFE:_INFNFE:_EMIT:_xNOME:TEXT))
						_cUFEmit   := AllTrim(oNFE:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT)
						
						
						If XMLCHILDEX(oNFE:_NFE:_INFNFE:_DEST,"_CPF") <> Nil
							_cCNPJDest := AllTrim(oNFE:_NFE:_INFNFE:_DEST:_CPF:TEXT)
						Else
							If _cCNPJDest == "ESTRANGEIRO"
								_cCNPJDest := ""
							Else	
								_cCNPJDest := AllTrim(oNFE:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
							EndIf	
						EndIf
						_cNomeDest := UPPER(AllTrim(oNFE:_NFE:_INFNFE:_DEST:_xNOME:TEXT))
						_cUFDest   := AllTrim(oNFE:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT)
					EndIf							
					// Pego o CFOP de maior valor   
					_cCFOP 	 := ""
					_nVrNFE	 := 0.00
					_cCFOPAux := ""
					_nVrNFEAux:= 0.00			              
		
					If AT("NFEPROC",UPPER(cBuffer)) > 0
						If VALTYPE(oNFE:_NFEPROC:_NFE:_INFNFE:_DET) == "A"
							// NF-e com vários itens
							For x := 1 TO Len(oNFE:_NFEPROC:_NFE:_INFNFE:_DET)
								_cCFOPAux  := oNFE:_NFEPROC:_NFE:_INFNFE:_DET[x]:_PROD:_CFOP:TEXT
								_nVrNFEAux := Val(oNFE:_NFEPROC:_NFE:_INFNFE:_DET[x]:_PROD:_vPROD:TEXT)
								If _nVrNFEAux >= _nVrNFEAux
									_cCFOP := _cCFOPAux
								EndIf
							Next x	
						Else
							// NF-e somente com um item
							_cCFOP := oNFE:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT
						EndIf	
					Else
						If VALTYPE(oNFE:_NFE:_INFNFE:_DET) == "A"
							// NF-e com vários itens
							For x := 1 TO Len(oNFE:_NFE:_INFNFE:_DET)
								_cCFOPAux  := oNFE:_NFE:_INFNFE:_DET[x]:_PROD:_CFOP:TEXT
								_nVrNFEAux := Val(oNFE:_NFE:_INFNFE:_DET[x]:_PROD:_vPROD:TEXT)
								If _nVrNFEAux >= _nVrNFEAux
									_cCFOP := _cCFOPAux
								EndIf
							Next x	
						Else
							// NF-e somente com um item
							_cCFOP := oNFE:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT
						EndIf	
					EndIf
												
					dbSelectArea("SZ6") ; dbSetOrder(2)  // Tabela de XML
					If !dbSeek( xFilial("SZ6") + _cIDNFE ) // + _cNFe + _cSerie + _cCNPJEmit)
						// Grava XML
						RecLock("SZ6",.T.)
							SZ6->Z6_IDNFE 	:= _cIDNFE
							SZ6->Z6_NUMNFE := _cNFe
							SZ6->Z6_SERNFE := _cSerie
							SZ6->Z6_MODELO := _cModelo
							SZ6->Z6_DTEMIS := STOD(_cDtEmis)
							SZ6->Z6_CODMUN := _cMunic
							SZ6->Z6_CNPJEMI:= _cCNPJEmit
							SZ6->Z6_NOMEEMI:= _cNomeEmit
							SZ6->Z6_UFEmi  := _cUFEmit
							SZ6->Z6_CNPJDES:= _cCNPJDest
							SZ6->Z6_NOMEDES:= _cNomeDest
							SZ6->Z6_UFDEST := _cUFDest
							SZ6->Z6_CFOPPRI:= _cCFOP
							SZ6->Z6_XML    := AllTrim(cBuffer)
							SZ6->Z6_DATIMP := dDatabase
							SZ6->Z6_HORAIMP:= StrTran(Left(Time(),5),':','')
						MsUnLock()
					Else
						// Grava XML
						// Por: Ricardo Guimarães - Em: 10/11/2014 - Em virtude de rotina da CNH passar a incluir registro incompleto na SZ6
						If SZ6->Z6_RESPWEB <> 'OK'
							RecLock("SZ6",.F.)
								//SZ6->Z6_IDNFE 	:= _cIDNFE
								//SZ6->Z6_NUMNFE := _cNFe
								//SZ6->Z6_SERNFE := _cSerie
								SZ6->Z6_MODELO := _cModelo
								SZ6->Z6_DTEMIS := STOD(_cDtEmis)
								SZ6->Z6_CODMUN := _cMunic
								SZ6->Z6_CNPJEMI:= _cCNPJEmit
								SZ6->Z6_NOMEEMI:= _cNomeEmit
								SZ6->Z6_UFEmi  := _cUFEmit
								SZ6->Z6_CNPJDES:= _cCNPJDest
								SZ6->Z6_NOMEDES:= _cNomeDest
								SZ6->Z6_UFDEST := _cUFDest
								SZ6->Z6_CFOPPRI:= _cCFOP
								SZ6->Z6_XML    := AllTrim(cBuffer)
								SZ6->Z6_DATIMP := dDatabase
								SZ6->Z6_HORAIMP:= StrTran(Left(Time(),5),':','')
								SZ6->Z6_RESPWEB:=""
							MsUnLock()		  
						EndIf
					EndIf
					
					
					******************************************************
					
					// Efetua copia
					If GetNewPar("MV_XBKPXML",.F.)
						_cArqDEST := GetNewPar("MV_XDIRXML","\xml-recebida-CTe\inbox\")+"BACKUP\"+cArqXML
						MontaDir(GetNewPar("MV_XDIRXML","\xml-recebida-CTe\inbox\")+"BACKUP\")
						__CopyFile(_cArqORIG,_cArqDEST)
                    EndIf                    
                    
					// Apaga o arquivo
					fErase(_cArqORIG)

					/*
					If !File(_cArqDEST)
						If _lConsole
							ConOut("XML OrgInbox: Problemas na copia do arquivo [ " + cArqXML + " ] para diretorio do CNPJ [ " + _cCNPJEmit + " ] de destino, verifique!")
						Else
							MsgAlert("Problemas na copia do arquivo [ " + cArqXML + " ] para diretorio do CNPJ [ " + _cCNPJEmit + " ] de destino, verifique!")
						Endif
					Else
					*/

					//Endif
				Else
					If "CARTA DE CORRE" $ UPPER(AllTrim(cBuffer))
						_cArqDEST := GetNewPar("MV_XDIRXML","\xml-recebida-CTe\")+"CARTA_CORRECAO\"+cArqXML
						_cArqORIG := GetNewPar("MV_XMLPATH","\xml-recebida-CTe\inbox\")+cArqXML
						MontaDir(GetNewPar("MV_XDIRXML","\xml-recebida-CTe\")+"CARTA_CORRECAO\")
						__CopyFile(_cArqORIG,_cArqDEST)
						fErase(_cArqORIG)
					ElseIf "CANCELAMENTO" $ UPPER(AllTrim(cBuffer)) .AND. "PROCEVENTONFE" $ UPPER(AllTrim(cBuffer))
						// Tratar cancelamento                                
		 //				 _oTST := XmlChildEx( oNFE:_PROCEVENTONFE, "_CHNFE" )
		//				If XmlChildEx( oNFE:_PROCEVENTONFE:_EVENTO, "_CHNFE" ) != "Nil"
						If AT("ENVEVENTO", UPPER(AllTrim(cBuffer)) ) > 0 
							_cIDNFeCanc := AllTrim(oNFE:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO:_INFEVENTO:_CHNFE:TEXT)                           
							_cIDCanc	   := Right(AllTrim(oNFE:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO:_INFEVENTO:_ID:TEXT),44)					
							
						Else
							_cIDNFeCanc := AllTrim(oNFE:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_CHNFE:TEXT)          
							_cIDCanc	   := Right(AllTrim(oNFE:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_ID:TEXT),44)					
						EndIf
		/*
						If XmlChildex( oNFE:_PROCEVENTONFE:_EVENTO, "_ID" ) != Nil
							_cIDCanc	   := Right(AllTrim(oNFE:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_ID:TEXT),44)
						Else	
							_cIDCanc	   := Right(AllTrim(oNFE:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO:_INFEVENTO:_ID:TEXT),44)					
						EndIf
		*/					
						dbSelectArea("SZ6") ; dbSetOrder(2)
						// Localizar a NF-e na tabela SZ6 e gravar o ID e o XML
						If dbSeek(xFilial("SZ6") + _cIDNFeCanc )
							SZ6->(RecLock("SZ6"),.F.)
								SZ6->Z6_IDCANC  := _cIDCanc
								SZ6->Z6_XMLCANC := AllTrim(cBuffer)
							SZ6->(MsUnLock())
							
							_cArqDEST := GetNewPar("MV_XDIRXML","\xml-recebida-CTe\")+"CANCELAMENTO\"+cArqXML
							_cArqORIG := GetNewPar("MV_XMLPATH","\xml-recebida-CTe\inbox\")+cArqXML
							MontaDir(GetNewPar("MV_XDIRXML","\xml-recebida-CTe\")+"CANCELAMENTO\")
							__CopyFile(_cArqORIG,_cArqDEST)
							fErase(_cArqORIG)
						EndIf
					Else   
						BREAK
						// U_EnvEmail(GETMV("MV_RELFROM"),GETNEWPAR("MV_XLOGXML","jose.guimaraes@gefco.com.br"),,"e-mail de XML de NF-e com erro na pasta inbox","MSG:e-mail de XML de NF-e com erro na pasta inbox")	
					EndIf	
				Endif
			Else
				// U_EnvEmail(GETMV("MV_RELFROM"),GETNEWPAR("MV_XLOGXML","jose.guimaraes@gefco.com.br"),,"e-mail de XML de NF-e com erro na pasta inbox","MSG:e-mail de XML de NF-e com erro na pasta inbox")
				BREAK
			Endif
			_lAchou := .F.

		RECOVER //"Se ocorreu erro, após o BREAK, venho para cá"

			// Move o arquivo com erro para a pasta de quarentena
			_cArqDEST := GetNewPar("MV_XDIRXML","\xml-recebida-CTe\inbox\")+"QUARENTENA\"+cArqXML
			_cArqORIG := GetNewPar("MV_XMLPATH","\xml-recebida-CTe\inbox\")+cArqXML
			MontaDir(GetNewPar("MV_XDIRXML","\xml-recebida-CTe\inbox\")+"QUARENTENA\")
			__CopyFile(_cArqORIG,_cArqDEST)
			fErase(_cArqORIG)
			
			//Restaurando bloco de erro do sistema
			ErrorBlock( bError )
			
		END SEQUENCE		
	
	Next

	// Apago arquivos de msg. desnecessária
	_aFiles := Directory(cPath + "att*.*")
	For x := 1 To Len(_aFiles)
		IncProc(0)
		fErase(cPath + _aFiles[x,1] )
	Next x
	
	// Apago arquivos de msg. desnecessária
	// Por: Ricardo Guimarães - Em: 02/01/2014
	_aFiles := Directory(cPath + "*.PDF")
	For x := 1 To Len(_aFiles)
		IncProc(0)
		fErase(cPath + _aFiles[x,1] )
	Next x	
		
	_aFiles := Directory(cPath + "*.jpg")
	For x := 1 To Len(_aFiles)
		IncProc(0)
		fErase(cPath + _aFiles[x,1] )
	Next x		
		
	_aFiles := Directory(cPath + "*.")
	For x := 1 To Len(_aFiles)
		IncProc(0)
		fErase(cPath + _aFiles[x,1] )
	Next x		
	_aFiles := Directory(cPath + "*.jpeg")
	For x := 1 To Len(_aFiles)
		IncProc(0)
		fErase(cPath + _aFiles[x,1] )
	Next x			
		
	_aFiles := Directory(cPath + "*.png")
	For x := 1 To Len(_aFiles)
		IncProc(0)
		fErase(cPath + _aFiles[x,1] )
	Next x				
		
// retorna
Return

// Por: Ricardo - Em: 29/04/2015
// Objetivo: Tratamento de erro
*------------------------------------------------*
Static Function MyError( oError )
*------------------------------------------------*
Local _cMsg := ""
Local _cDe  := GETMV("MV_RELFROM")
Local _cPara:= GETNEWPAR("MV_XLOGXML","jose.guimaraes@gefco.com.br")
Local _cCC  := ""
Local _cAssunto := "LOG ERRO DE CARGA DE XML DE NF-e"

// MsgInfo( oError:Description , "Deu Erro" )

_cMsg := "LOG ERRO DE CARGA DE XML DE NF-e" + CRLF
_cMsg += "================================" + CRLF
_cMsg += "" + CRLF
_cMsg += "Data/Hora			: " + DTOC(DDATABASE) + " - " + Time() 	+ CRLF
_cMsg += "Arquivo			: "  + cArqXML + CRLF
_cMsg += "" + CRLF
_cMsg += "Arquivo movido para a pasta: " + cPath + "QUARENTENA" + CRLF
_cMsg += "" + CRLF
_cMsg += "" + CRLF
_cMsg += "Mensagem de erro	: " + oError:Description + CRLF
_cMsg += "" + CRLF
_cMsg += "Msg. de error		: " + oError:ErrorStack + CRLF

U_EnvEmail(_cDe,_cPara,,_cAssunto,_cMsg)

BREAK
Return( NIL )

*********************************************************************************************
* Ler arquivo XML de um determinado CNPJ
*********************************************************************************************
User Function fXMLLer(_cCNPJ)
// declaracao de variaveis
Local nHdl, nTamFile, cBuffer, nBtLidos, cAviso, cErro, oNFE, _aListaXML
Local cPath := GetNewPar("MV_XMLPATH","\xml-recebida-CTe\"+_cCNPJ+"\")
// limpa variaveis
_cHistorico := ""
_dEmissao   := ""
_cNumero    := ""
_cRemetente := ""
_cChave     := ""
_cMunicipio := ""
_cInscricao := ""

// Monta Lista com arquivos XMLs
_aListaXML := fListaXML(_cCNPJ)

// abre arquivo
For x:=1 To Len(_aListaXML)
	nHdl := fOpen(AllTrim(cPath+_aListaXML[x,1]),0)
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
				_cCFOP      := oNFE:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT
				_cMunicipio := "SEFAZ"
				//ALERT(_cMunicipio)
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
Next x

// retorna
Return

***************************
*
**************************
Static Function fListaXML(_cCNPJ)

// declaracao de variaveis
Local _aFiles   := {}
Local _cDirXML    := GetNewPar("MV_XDIRXML","\xml-recebida-CTe\"+_cCNPJ+"\")
// Local _cDirCNPJ   := _cDirXML + SM0->M0_CGC + "\"

// monta diretorio
MontaDir(_cDirXML)

// busca arquivos do diretorio
_aFiles := Directory(_cDirXML + "*"+_cCNPJ+"*.XML")
ALERT(STRZERO(LEN(_aFILES),10))
// adiciona no array
/*
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
*/
// caso retorne vazio, informa usuario
/*
If Len(_aListXML) <= 0
	MsgAlert("Nao foram encontrados arquivos no diretorio [ " + _cDiretorio + "], verifique!")
	AADD(_aListXML,Array(99))
	_aListXML[Len(_aListXML),01] := .F.
Else
	_aListXML := aSort( _aListXML,,, { | x , y | x[6] > y[6] } )
Endif
*/
// retorna
Return _aFiles
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

/*
User Function TryCatch
Local x
Local y              := "TryTest"

Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )

Local oError

BEGIN SEQUENCE
	TRY
       x := &y.(,)    
       CATCH e as IdxException
       ConOut( ProcName() + " " + Str(ProcLine()) + " " + e:cErrorText )
    END TRY
RECOVER
    ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:Description )
END SEQUENCE 
ErrorBlock( bErrorBlock )    

Return( NIL )

*/

/*
Function TrySample1()

//Salvando o bloco de erro do sistema e Atribuindo tratamento personalizado Local bError := ErrorBlock( { |oError| MyError( oError ) } )

BEGIN SEQUENCE

//Forçando um erro para avalia-lo.
__EXCEPTION__->ERROR := "__EXCEPTION__"
RECOVER
//"Se ocorreu erro, após o BREAK, venho para cá"
MsgInfo( "Peguei o Desvio do BREAK" )
END SEQUENCE

MsgInfo( "Continuo após o tratamento de erro" )

//Restaurando bloco de erro do sistema
ErrorBlock( bError )

Return( NIL )

Static Function MyError( oError )
MsgInfo( oError:Description , "Deu Erro" )
BREAK
Return( NIL )
*/