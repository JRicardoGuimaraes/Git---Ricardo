#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "TOPCONN.CH"
#include "tbicode.ch"
#include "tbiconn.ch"


/************************************************************************************
* Programa.......: GEFM6101()                                                       *
* Autor..........: J Ricardo de O Guimarães                                         *
* Data...........: 05/09/2007                                                       *
* Descricao......: Integração ISYGO x MICROSIGA                                     *
*                                                                                   *
*************************************************************************************
* Modificado por.: J Ricardo                                                        *
* Data...........: 11/03/2008                                                       *
* Motivo.........: Todos os arquivos de todas as filiais irão cair numa mesma pasta,*
*                  Tratar cada filial e enviar log de erro por e-mail               *
************************************************************************************/

USER FUNCTION GEFM61x(lAutoR)
Local 	nOpcao	:=	0

Private _oDlg
Private cPath	    :=	space(255)
Private aFilesLegs  := {}
Private aFilesHouse	:= {}
Private aFilesMaster:= {}

//Private lAutoRot:=iif(lAutoR = Nil,.f.,lAutoR)
Private lAutoRot:=iif(lAutoR = Nil,.f.,.T.)

If lAutoRot //Se a rotina for automática.
	RPCSetType(3) // Nao consome o numero de licencas
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT" TABLES "SA1","SB1","SC5","SC6","SED","CTT","SF4"
	
	fProcessa()

	RESET ENVIRONMENT

Else

	// SetKey (VK_F3,{|a,b| cPath:=cGetFile( "Arqvuivo de Interface (.txt) | *.txt ",OemToAnsi("Selecione O Arquivo"),,"d:",.f.,GETF_LOCALHARD+GETF_RETDIRECTORY)})
	@ 200,1 TO 380,380 DIALOG _oDlg TITLE OemToAnsi("Importação de Docs. Fiscais do RMA")
	@ 02,10 TO 080,190
	@ 10,018 Say " Este programa ira ler o conteudo de um ou mais arquivo(s), contido"
	@ 18,018 Say " no diretório informado abaixo com extencao .txt"
	@ 26,018 Say "                                                            "
	@ 34,018 Say "Diretório: "
	@ 32,050 Get cPath Picture "@!" Size 60,20
	@ 32,110 BUTTON "..." SIZE 10,10 ACTION (cPath:=cGetFile( "Arqvuivo de Interface (.txt) | *.txt ",OemToAnsi("Selecione O Arquivo"),,"s:\Protheus_Data\Importar",.f.,GETF_LOCALHARD+GETF_RETDIRECTORY))
	@ 60,128 BMPBUTTON TYPE 01 ACTION (nOpcao:=1,fProcessa(),Close(_oDlg))
	@ 60,158 BMPBUTTON TYPE 02 ACTION (nOpcao:=2,Close(_oDlg))
	
	Activate Dialog _oDlg Centered
EndIf	
// SetKey (VK_F3,{||})
Return

*-----------------------------*
STATIC FUNCTION fProcessa()
*-----------------------------*

If Empty(cPath)
	cPath := "\IMPORTAR\ISYGO\"
EndIf

cPath:=alltrim(cPath)
If substr(cPath,len(cPath),1) != "\"
	cPath+="\"
EndIf

cPathErro:=alltrim(cPath)+"Errata\"


//aFilesLegs := Directory(cPath + "CISY_TAXF*.txt")  // Todos os arquivos da Legs presente na pasta
//aFilesHouse:= Directory(cPath + "CISY_TAXH*.txt")  // Todos os arquivos da Legs presente na pasta

aFilesLegs  := Directory(cPath + "F0841*_bresil0841")  // Todos os arquivos da Legs presente na pasta
aFilesHouse := Directory(cPath + "H0841*_bresil0841")  // Todos os arquivos da Legs presente na pasta
aFilesMaster:= Directory(cPath + "M0841*_bresil0841")  // Todos os arquivos da Legs presente na pasta

If Len(aFilesLegs) > 0
	If Len(aFilesHouse) > 0
		If lAutoRot
			RunImport()
		Else
			Processa({|| RunImport() },"Processando...")
		EndIf				
	Else
		If lAutoRot	
			ConOut("Não foi possível encontrar arquivo de HOUSE na pasta informada!")
		Else
			APMsgAlert("Não foi possível encontrar arquivo de HOUSE na pasta informada!")		
		EndIf	
	EndIf
Else                
	If lAutoRot	
		ConOut("Não foi possível encontrar arquivo na pasta informada!")
	Else	
		APMsgAlert("Não foi possível encontrar arquivo na pasta informada!")		
	EndIf	
EndIf

Return

*---------------------------------*
Static Function RunImport()
*---------------------------------*
Local aCampos     := {}
Local cQry
Local _cFilRMA    := ""
Local _cAtivid    := ""
Local _cProd      := ""
Local _cCodSiga   := ""
Local _cHouseChav := ""
Local _cTipoReg   := ""
Local _cTipoNF    := ""
Local _cDataTran  := ""
Local _ChaveIsy   := ""
Local _Chave      := ""
Local _lGera      := .F.
Local _aNFS       := {}
Local _aNFT       := {}
Local _aNFS531    := {}  // Tratamento para serviço de código 531
Local _aNFS512    := {}  // Tratamento para serviço de código 312
Local _cDesProd   := ""
//Local _lErrorIsy  := .F.
// Local _lErrorSiga := .F.
Local _lMoveArq   := .T.

Local _nValorNFT := 0.00
Local _nVrUnitNFT:= 0.00

Local _nValorNFS := 0.00
Local _nVrUnitNFS:= 0.00

Local _nVrNFS531 := 0.00
Local _nVrUNFS531:= 0.00

Local _nVrNFS312 := 0.00
Local _nVrUNFS312:= 0.00

Local _cDesNFT531:= ""
Local _cDesNFS531:= ""
Local _cDesNFS312:= ""

Local _cDescNFT  := ""
Local _cDescNFS  := ""

Private _aArqLog    := {} // Array contendo os arquivos de Logs de erro a serem enviados aos remetente por e-mail
Private _aLog       := {} // Array contendo os arquivos de Logs de erro a serem enviados aos remetente por e-mail

Private nLin        := 0
Private cNL        	:= CHR(13)+CHR(10)

Private cLog
Private cArqLog     := ""
Private _lError     := .F.
Private _lErrorLog  := .F.

Private nTamFile
Private nSizeTot	:=	0
Private cIndHouse   := ""
Private cArqHouse   := ""

Private _aNFSCom    := {}  // Usado para armazenar informações de Compra das NFS´s
Private _aNFTCom    := {}  // Usado para armazenar informações de Compra das NFT´s

// Monta arquivo de houve para pegar o número do processo processo
*---------------*
fMontaHouse()
*---------------*

*----------------------------------*
* Preparando Arquivo temporário    *
*----------------------------------*
AADD(aCampos, {"LINHA", "C",  809, 0})

If Select("ISY") > 0
	dbSelectArea("ISY") ; dbCloseArea()
EndIf

cNomArq := CriaTrab (aCampos, .T.)
dbUseArea (.T., , cNomArq, "ISY", .F. , .F.)  // Exclusivo
dbGoTop()

nSizeTot := Len(aFilesLegs)

ProcRegua(nSizeTot) // Numero de arquivos

cFilNaoP:="" //Filial Nao Processada


For nX:=1 to len(aFilesLegs)

	_lMoveArq   := .T.	// Flag de controle se move o arquivo para pasta Backup ou Não
	IncProc()
	
	// Carrego o arquivo temporário com os dados do TXT
	APPEND FROM (cPath + aFilesLegs[nX,1]) SDF
	ISY->(dbGoTop())
	/*
	// Pego a Filial
	cFil := AllTrim(SubStr(ISY->LINHA,35,5))
	
	cQry:="SELECT ZC_FILIAL, ZC_FILRMA, ZC_FILSAP, ZC_FILCC FROM "+RetSqlName("SZC")
	cQry+=" WHERE ZC_FILRMA = '"+cFil+"'"
	
	TcQuery cQry Alias "TFIL" New
	
	cFilRMA     := AllTrim(cFil)
	cFilCC      := AllTrim(TFIL->ZC_FILCC)
	cFilSAP     := AllTrim(TFIL->ZC_FILSAP)
	cFil		:=TFIL->ZC_FILIAL
	cFilSiga    :=TFIL->ZC_FILIAL
	TFIL->(dbCloseArea())
	*/
	// 	If cFil = cFilAnt
	//	If !Empty(cFil)
	
	nLin     := 0		// Número de linhas lidas
	_lError  := .F. 	// Controla de houve erro para gravação do arquivo de LOG
	
	*=========================*
	* criacao do arquivo Log  *
	*=========================*
	cLog := "Criacao do arquivo de erros gerados pelo sistema de importacao - Data: "+dtoc(ddatabase)+cNL
	cLog += "======================================================================================" +cNL
	
	dbSelectArea("ISY") ; dbGoTop()
	_cFilOld := ""
	_cFil    := ""
	
	While !ISY->(eof())
		
		// Pego a Filial
		cFil := AllTrim(SubStr(ISY->LINHA,35,5))
		
		If _cFilOld <> cFil
			cQry:="SELECT ZC_FILIAL, ZC_FILRMA, ZC_FILSAP, ZC_FILCC FROM "+RetSqlName("SZC")
			cQry+=" WHERE ZC_FILRMA = '"+cFil+"'"
			
			TcQuery cQry Alias "TFIL" New
			
			cFilRMA     := AllTrim(cFil)
			cFilCC      := AllTrim(TFIL->ZC_FILCC)
			cFilSAP     := AllTrim(TFIL->ZC_FILSAP)
			cFil		:= TFIL->ZC_FILIAL
			cFilSiga    := TFIL->ZC_FILIAL
			TFIL->(dbCloseArea())
			
			dbSelectArea("ISY")
			
			If Empty(cFil)
				// Filial não cadastrada na tabela SZC
				cFilNaoP+="Filial: ("+cFil+")-"+cFilRMA+" nao importado.  Favor verificar na tabela SZC."+chr(10)
				
				// Gravo o arquivo de LOG
				If Rat(".",aFilesLegs[nX,1]) > 0
					cArqLog  := SubStr(aFilesLegs[nX,1],1,Rat(".",aFilesLegs[nX,1])-1)+".LOG"
				Else
					cArqLog  := AllTrim(aFilesLegs[nX,1])+".LOG"
				EndIf
				
				// Gravo o arquivo de Log
				//			MemoWrit(cPath +"Errata\" + cArqLog, aFilesLegs[nX,1] + " -> " + cFilNaoP)
				
				// Armazeno no array para ser enviado por e-mail
				AADD(_aArqLog, {cFilSiga, cPathErro + cArqLog})
				AADD(_aLog   , {cFilSiga, cFilNaoP})
				
				dbSelectArea("ISY")
				dbSkip()
				Loop
			EndIf
			_cFilOld := cFil
		EndIf
		
		_cChave := ''
		// A chave é composta pelo Nr. Master + Nr.House
		_cChave := SubStr(ISY->LINHA,01,17) + SubStr(ISY->LINHA,18,17)
		
		// Controle se será incluso o registro
		_lGera := .F.
		_aNFS := {}
		_aNFS := {}
		
		_aNFSCom := {}  // Usado para armazenar informações de Compra das NFS´s
		_aNFTCom := {}  // Usado para armazenar informações de Compra das NFT´s
		
		_cCodSiga := ""
		
		While !ISY->(eof()) .and. _cChave == SubStr(ISY->LINHA,01,17) + SubStr(ISY->LINHA,18,17)
			
			nLin++
			IncProc()
			
			_cLogLinha :=  "Master/House/Leg Line Nbr.=>" + AllTrim(SubStr(ISY->LINHA,01,17)) + "/" + AllTrim(SubStr(ISY->LINHA,18,17)) + "/" + AllTrim(SubStr(ISY->LINHA,41,12))
			
			// P=Compra - S=Venda
			_cTipoReg := AllTrim(SubStr(ISY->LINHA,40,01))
			If !(_cTipoReg $ ("P|S"))
				dbSelectArea("ISY")
				dbSkip()
				Loop
			EndIf
			
			// NFS=Nota de Serviço - NFT=Nota de Transporte
			_cTipoNF := AllTrim(SubStr(ISY->LINHA,755,03))
			If !(_cTipoNF $ ("NFS|NFT"))
				dbSelectArea("ISY")
				dbSkip()
				Loop
			EndIf
			
			// Verifico se já foi importado anteriormente
			// A chave é composta pelo Nr. Master + Nr.House + Invoice Number + Fee(Code)"Cod.Prod."
			//				_cChaveIsy := SubStr(ISY->LINHA,01,17) + SubStr(ISY->LINHA,18,17) + SubStr(ISY->LINHA,136,17) + SubStr(ISY->LINHA,587,08)
			
			// A chave é composta pelo Nr. Master + Nr.House + Leg Line nbr."
			//				_cChaveIsy := SubStr(ISY->LINHA,01,17) + SubStr(ISY->LINHA,18,17) + SubStr(ISY->LINHA,136,17) + SubStr(ISY->LINHA,587,08)
			_cChaveIsy := SubStr(ISY->LINHA,01,17) + SubStr(ISY->LINHA,18,17) + SubStr(ISY->LINHA,41,12) + SubStr(ISY->LINHA,587,08)
			
			// Linha em branco
			If Empty(_cChaveIsy)
				dbSelectArea("ISY")
				dbSkip()
				Loop
			EndIf
			
			If _cTipoReg == "P"
				// 11/2008 - Armazenar em matriz as informações ref. campo a ser provisionada
				*----------------------------*
				// GeraProvCom(_cTipoNF)
				*----------------------------*
				dbSelectArea("ISY")
				dbSkip()
				Loop
			EndIf
			
			_cInvoice := SubStr(ISY->LINHA,136,17) // HOU->PROCESSO
			
			If Select("_TRB") > 0
				dbSelectArea("_TRB") ; dbCloseArea()
			EndIf
			
			_cQry := " SELECT * FROM ITENS_PRESTACAO WHERE ISY_CHAVE = '" + _cChaveIsy + "' "
			TCQUERY _cQry ALIAS _TRB NEW
			
			dbSelectArea("_TRB") ; dbGoTop()
			_cPedidos := ""
			If !EOF()
				_lError    := .T.
				_lErrorLog := .T.
				
				// Pego o número do pedido
				While !EOF()
					_cPedidos += _TRB->PEDIDO +", "
					dbSelectArea("_TRB")
					dbSkip()
				End
				
				// Retiro a vírgula no final da string
				If !Empty(_cPedidos)
					_cPedidos := SubStr(_cPedidos,1,Len(_cPedidos)-2)
				EndIf
				
				If SubStr(ISY->LINHA,104,02) == 'AD'  // Trata de Cancelamento
					If !Empty(_cInvoice)
						cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Houve cancelamento, favor verificar os pedidos : " + _cPedidos + cNL
						AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Houve cancelamento, favor verificar os pedidos : " + _cPedidos})
					EndIf
				Else
					cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Já foi importado o registro ref. ao Master/House/Invoice Number :" + _cChaveIsy + cNL
					AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Já foi importado o registro ref. ao Master/House/Invoice Number :" + _cChaveIsy})
				EndIf
				
				_TRB->(dbCloseArea())
				dbSelectArea("ISY")
				//					dbSkip()
				//					Loop
			Else
				If SubStr(ISY->LINHA,104,02) == 'AD'  // Trata de Cancelamento
					If !Empty(_cInvoice)
						// cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Linha cancelada : " + _cPedidos + cNL
						dbSelectArea("ISY")
						dbSkip()
						Loop
					EndIf
				EndIF
			EndIf
			
			If Select("_TRB") > 0
				dbSelectArea("_TRB")
				_TRB->(dbCloseArea())
			EndIf
			
			// *** ATENÇÃO *** Compilar na para produção
			_cInvoice := SubStr(ISY->LINHA,136,17) // HOU->PROCESSO
			// Se não existir INVOICE, ignoro o processo
			If Empty(_cInvoice)
				cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Sem Número de Invoice " + cNL
				AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Sem Número de Invoice "})
				_lError := .T.
				_lErrorLog := .T.
				dbSelectArea("ISY")
				//					ISY->(dbSkip())
				//					Loop
			EndIf
			
			dbSelectArea("ISY")
			
			// Registro no TXT sem valor(zerado)
			If Empty(Val(SubStr(ISY->LINHA,733,11)))
				// cLog += "Erro linha " + StrZero(nLin,3) + " => Registro com valor 0.00" + cNL
				dbSelectArea("ISY")
				ISY->(dbSkip())
				Loop
			EndIf
			
			_cCNPJ   := AllTrim(SubStr(ISY->LINHA,87,17))
			_cCodCli := AllTrim(SubStr(ISY->LINHA,53,17))
			_cCodCli := SubStr(AllTrim(_cCodCli),5,6)
			_cLojCli := ""
			
			If !Empty(_cCNPJ)
				// Posiciono no cliente através do CNPJ
				dbSelectArea("SA1") ; dbSetOrder(3)
				
				If !dbSeek(xFilial("SA1")+_cCNPJ)  // CNPJ
					// Gero erro de LOG e não importo
					// _lError  := .T.
					_lErrorLog := .T.
					cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => CNPJ (" + _cCNPJ + ") não cadastrado " + cNL
					AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => CNPJ (" + _cCNPJ + ") não cadastrado "})
					dbSelectArea("ISY")
					 _lError 	:= .T.
					_lErrorLog 	:= .T.
					_lMoveArq   := .F.  // Não move o arquivo para a pasta Backup, ficando para o próximo processo					
					//						ISY->(dbSkip())
					//						Loop
				Else
					_cCodCli := SA1->A1_COD
					_cLojCli := SA1->A1_LOJA
				EndiF
			Else
				// Posiciono no cliente através do Código
				dbSelectArea("SA1") ; dbSetOrder(1)
				If !dbSeek(xFilial("SA1")+_cCodCli)  // Código do Cliente
					// Gero erro de LOG e não importo
					// _lError  := .T.
					_lErrorLog := .T.
					cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código do Cliente (" + _cCodCli + ") não cadastrado " + cNL
					AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código do Cliente (" + _cCodCli + ") não cadastrado "})
					 _lError 	:= .T.
					_lErrorLog 	:= .T.
					_lMoveArq   := .F.  // Não move o arquivo para a pasta Backup, ficando para o próximo processo					
					
					dbSelectArea("ISY")
					//						ISY->(dbSkip())
					//						Loop
				Else
					_cLojCli := SA1->A1_LOJA
				EndiF
			EndIf
			
			// Busco o número do processo contido no arquivo de House
			_cHouseChav := SubStr(ISY->LINHA,01,17) + AllTrim(SubStr(ISY->LINHA,18,17)) // Master + House Nbr.
			dbSelectArea("HOU")
			If !dbSeek(_cHouseChav)
				cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Registro não encontrado no arquivo HOUSE " + cNL
				AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Registro não encontrado no arquivo HOUSE "})
				 _lError 	:= .T.
				_lErrorLog 	:= .T.
				_lMoveArq   := .F.  // Não move o arquivo para a pasta Backup, ficando para o próximo processo				
				dbSelectArea("ISY")
				//					ISY->(dbSkip())
				//					Loop
			EndIf
			
			_cProc := SubStr(ISY->LINHA,18,17) // HOU->PROCESSO
			If Empty(_cProc)
				cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Número de Processo em branco " + cNL
				AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Número de Processo em branco "})
				_lError := .T.
				_lErrorLog := .T.
				dbSelectArea("ISY")
				//					ISY->(dbSkip())
				//					Loop
			EndIf
			
			_cAtivid := HOU->CODATIVID
			If Empty(_cAtivid)
				cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código de Atividade em branco " + cNL
				AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código de Atividade em branco "})
				_lError 	:= .T.
				_lErrorLog 	:= .T.
				dbSelectArea("ISY")
				//					ISY->(dbSkip())
				//					Loop
			EndIf
			
			// Pego o código do produto do Microsiga através do Fee (code)
			_cProd := AllTrim(SubStr(ISY->LINHA,587,008))
			If Empty(_cProd)
				cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código de Produto - fee(code) em branco. " + cNL
				AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código de Produto - fee(code) em branco. "})
				_lError := .T.
				_lErrorLog := .T.
				dbSelectArea("ISY")
				//					ISY->(dbSkip())
				//					Loop
			EndIf
			
			// Busco produto na tabela depara de produto do RMA
			If _cProd $ "5100|5101|312|531"
				_cCodSiga := fPegaProd(_cProd)
				If Empty(_cCodSiga)
					cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código de Produto - fee(code) (" + _cProd + ") não relacionado na tabela PRODUTO_RMA. " + cNL
					AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código de Produto - fee(code) (" + _cProd + ") não relacionado na tabela PRODUTO_RMA. "})
					_lError := .T.
					_lErrorLog := .T.
					dbSelectArea("ISY")
					//						ISY->(dbSkip())
					//						Loop
				EndIf
			EndIf
			
			// Se houve erro, leio o próximo
			If _lErrorLog
				_lErrorLog := .F.
				dbSelectArea("ISY")
				ISY->(dbSkip())
				Loop
			EndIf
			
			// Busco o Centro de Custo conforme regra
			_cCC := fBuscaCC(SA1->A1_GEFCAT1, SA1->A1_COD, SA1->A1_LOJA, _cAtivid, cFilCC)
			
			dbSelectArea("ISY")
			
			_cTipoDoc := AllTrim(SubStr(ISY->LINHA,755,003))  // VAT(code)
			_cTipo    := ""
			_cObs     := AllTrim(SubStr(ISY->LINHA,314,070))  // Observations
			
			If AllTrim(SubStr(ISY->LINHA,106,03)) == "BRL"
				If _cTipoNF == "NFS"
					// Tratamento para separa Profit Share(531) e Desembaraço (312)
					If _cProd == "531"
						_nVrNFS531  += Val(SubStr(ISY->LINHA,733,12))/100
						_nVrUNFS531 := Val(SubStr(ISY->LINHA,733,12))/100
					ElseIf _cProd == "312"
						_nVrNFS312 += Val(SubStr(ISY->LINHA,733,12))/100
						_nVrUNFS312:= Val(SubStr(ISY->LINHA,733,12))/100
					Else
						_nValorNFS   += Val(SubStr(ISY->LINHA,733,12))/100
						_nVrUnitNFS  := Val(SubStr(ISY->LINHA,733,12))/100
					EndIf
				Else
					_nValorNFT   += Val(SubStr(ISY->LINHA,733,12))/100
					_nVrUnitNFT  := Val(SubStr(ISY->LINHA,733,12))/100
				EndIf
				
			Else
				// Por: Ricardo de Oliveira - Em: 17/11/2008 - Definido pelo Valter Silva
				// Tratamento de conversão de moeda - a taxa é informada no campo observação (314 a 383) 
				// XXX 9,999 - onde XXX é o código da moeda.  O campo Currency code indica a moeda do documento na posição 106 a 108
				 
				_nTaxa := 0
				_nTaxa := Val(StrTran(AllTrim(SubStr(ISY->LINHA,327,5)),',','.'))
				/*
				If Empty(Val(SubStr(ISY->LINHA,713,15)))
					cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Moeda diferente de REAL sem taxa de conversão." + cNL
					AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Moeda diferente de REAL sem taxa de conversão."})
					_lError := .T.
					_lErrorLog := .T.
					dbSelectArea("ISY")
					ISY->(dbSkip())
					Loop
				EndIf
				*/

				/*
				   A rotina abaixo é para tratamento de moeda estrageira.
				*/				
				/*
				If Empty(_nTaxa)
					cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Moeda diferente de REAL sem taxa de conversão." + cNL
					AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Moeda diferente de REAL sem taxa de conversão."})
					_lError := .T.
					_lErrorLog := .T.
					dbSelectArea("ISY")
					ISY->(dbSkip())
					Loop
				EndIf
				*/
				If _cTipoNF == "NFS"
					// Tratamento para separa Profit Share(531) e Desembaraço (312)
					If _cProd == "531"
						_nVrNFS531  += Val(SubStr(ISY->LINHA,733,12))/100 * _nTaxa 
						_nVrUNFS531 := Val(SubStr(ISY->LINHA,733,12))/100 * _nTaxa 
					ElseIf _cProd == "312"
						_nVrNFS312 += Val(SubStr(ISY->LINHA,733,12))/100 * _nTaxa 
						_nVrUNFS312:= Val(SubStr(ISY->LINHA,733,12))/100 * _nTaxa 
					Else
						_nValorNFS   += Val(SubStr(ISY->LINHA,733,12))/100 * _nTaxa 
						_nVrUnitNFS  := Val(SubStr(ISY->LINHA,733,12))/100 * _nTaxa 
					EndIf
				Else
					_nValorNFT   += Val(SubStr(ISY->LINHA,733,12))/100 * _nTaxa 
					_nVrUnitNFT  := Val(SubStr(ISY->LINHA,733,12))/100 * _nTaxa 
				EndIf
				/*
				If _cTipoNF == "NFS"
					// Tratamento para separa Profit Share(531) e Desembaraço (312)
					If _cProd == "531"
						_nVrNFS531  += Val(SubStr(ISY->LINHA,733,12))/100 * Val(SubStr(ISY->LINHA,713,15))/100000
						_nVrUNFS531 := Val(SubStr(ISY->LINHA,733,12))/100 * Val(SubStr(ISY->LINHA,713,15))/100000
					ElseIf _cProd == "312"
						_nVrNFS312 += Val(SubStr(ISY->LINHA,733,12))/100 * Val(SubStr(ISY->LINHA,713,15))/100000
						_nVrUNFS312:= Val(SubStr(ISY->LINHA,733,12))/100 * Val(SubStr(ISY->LINHA,713,15))/100000
					Else
						_nValorNFS   += Val(SubStr(ISY->LINHA,733,12))/100 * Val(SubStr(ISY->LINHA,713,15))/100000
						_nVrUnitNFS  := Val(SubStr(ISY->LINHA,733,12))/100 * Val(SubStr(ISY->LINHA,713,15))/100000
					EndIf
				Else
					_nValorNFT   += Val(SubStr(ISY->LINHA,733,12))/100 * Val(SubStr(ISY->LINHA,713,15))/100000
					_nVrUnitNFT  := Val(SubStr(ISY->LINHA,733,12))/100 * Val(SubStr(ISY->LINHA,713,15))/100000
				EndIf
				*/
			EndIf
			
			// Data de Transmissão do arquivo
			_cDataTran:= SubStr(ISY->LINHA,797,08)
			
			
			// Código do Cliente + Loja
			_cCodCli := _cCodCli + _cLojCli
			
			// Descrição do VAT COD ( Produto )
			_cDesProd := StrTran(AllTrim(SubStr(ISY->LINHA,638,35)),"'","")
			
			If _cTipoNF == "NFS"
				// Descrição do Produto
				// Tratamento para separa Profit Share(531) e Desembaraço (312)
				// _cDesNFT531:= ""
				// _cDesNFS312:= ""
				
				// Se não houver os código "5100 e 5101", então fixo o código "06637"
//				If Empty(_cCodSiga)
					_cCodSiga = "06637"
//				EndIf
				
				If _cCodSiga == "06637" .AND. cFil == "02" // Filial = Beneditinos
					If _cAtivid == "647"  // Importação Maritima
						_cCodSiga = "00260004"
					ElseIf _cAtivid == "648"  // Exportação Maritima
						_cCodSiga = "00260002"
					ElseIf _cAtivid == "637"  // Importação Aérea
						_cCodSiga = "00260001"
					ElseIf _cAtivid == "638"  // Exportação Aérea
						_cCodSiga = "00260003"
					EndIf
				EndIf				
				
				If _cProd == "531"
					If AT(_cDesProd, _cDesNFS531) == 0
						_cDesNFS531 += _cDesProd + ", "
					EndIf
					
					AADD(_aNFS,{cFil     ,;	// Filial
					_cCodCli  ,; // Código de Cliente
					_nVrNFS531,; // Valor Total
					_cCC      ,; // Centro de Custo
					_cProc    ,; // Processo
					_cObs     ,; // Observação
					_cTipo    ,; // Tipo
					_cTipoNF  ,; // Tipo de Documento
					_cDataTran,; // Data da Transação
					""        ,; //
					IIF(_cProd='531',_cCodSiga,"") ,; // // Código do Produto no Microsiga
					_nVrUNFS531 ,; // Valor Unitário
					,; // Quantidade
					_nVrNFS531  ,; // Valor Total
					_cDesNFS531 }) // 15 - Descrição do Prod.
					
				ElseIf _cProd == "312"
					If AT(_cDesProd, _cDesNFS312) == 0
						_cDesNFS312 += _cDesProd + ", "
					EndIf
					
					AADD(_aNFS,{cFil     ,;	// Filial
					_cCodCli  ,; // Código de Cliente
					_nVrNFS312,; // Valor Total
					_cCC      ,; // Centro de Custo
					_cProc    ,; // Processo
					_cObs     ,; // Observação
					_cTipo    ,; // Tipo
					_cTipoNF  ,; // Tipo de Documento
					_cDataTran,; // Data da Transação
					""        ,; //
					IIF(_cProd='312',_cCodSiga,"") ,; // // Código do Produto no Microsiga
					_nVrUNFS312 ,; // Valor Unitário
					,; // Quantidade
					_nVrNFS312  ,; // Valor Total
					_cDesNFS312 }) // 15 - Descrição do Prod.
				Else                                
					_nPosProd := AT(_cDesProd, _cDescNFS)
					If _nPosProd == 0
						_cDescNFS  +=  _cDesProd + ", "
					EndIf
					   
					_nPosVet := aScan(_aNFS,{|x| alltrim(x[11] ) == _cCodSiga})
					
					If _nPosVet > 0                                                                
						// Se ja estiver processo os produtos 531 - PROFIT SHARE e 312 - CUSTOMS CLEARANCE FEES
						If aScan(_aNFS,{|x| ('PROFIT SHARE' $ alltrim(x[15])) }) > 0 .OR. aScan(_aNFS,{|x| ('CUSTOMS CLEARANCE FEES' $ alltrim(x[15])) }) > 0
							_nPosVet := 0
						EndIf
					EndIf
					
					If _nPosVet == 0
						AADD(_aNFS,{cFil     ,;	// Filial
						_cCodCli  ,; // Código de Cliente
						_nValorNFS,; // Valor Total
						_cCC      ,; // Centro de Custo
						_cProc    ,; // Processo
						_cObs     ,; // Observação
						_cTipo    ,; // Tipo
						_cTipoNF  ,; // Tipo de Documento
						_cDataTran,; // Data da Transação
						""        ,; //
						_cCodSiga ,; // IIF(_cProd='5101',_cCodSiga,"") ,; // // Código do Produto no Microsiga
						_nVrUnitNFS ,; // Valor Unitário
						,; // Quantidade
						_nValorNFS  ,; // Valor Total
						_cDescNFS   }) // 15 - Descrição do Prod.
					Else
						_aNFS[_nPosVet,01] := cFil	     // Filial
						_aNFS[_nPosVet,02] := _cCodCli   // Código de Cliente
						_aNFS[_nPosVet,03] := _nValorNFS // Valor Total
						_aNFS[_nPosVet,04] := _cCC       // Centro de Custo
						_aNFS[_nPosVet,05] := _cProc     // Processo
						_aNFS[_nPosVet,06] := _cObs      // Observação
						_aNFS[_nPosVet,07] := _cTipo     // Tipo
						_aNFS[_nPosVet,08] := _cTipoNF   // Tipo de Documento
						_aNFS[_nPosVet,09] := _cDataTran // Data da Transação
						_aNFS[_nPosVet,10] := ""         //
						_aNFS[_nPosVet,11] := _cCodSiga  // IIF(_cProd='5101',_cCodSiga,"") // Código do Produto no Microsiga
						_aNFS[_nPosVet,12] := _nVrUnitNFS // Valor Unitário
						//_aNFS[_nPosVet,13] := // Quantidade
						_aNFS[_nPosVet,14] := _nValorNFS  // Valor Total
						_aNFS[_nPosVet,15] := _cDescNFS   // 15 - Descrição do Prod.
					EndIf
				EndIf
			Else // NFT
				// Descrição do Produto
				// Não permito duplicidade de descrição
				If AT(_cDesProd, _cDescNFT) == 0
					_cDescNFT  +=  _cDesProd + ", "
				EndIf
				
				_aNFT := { cFil      ,;	// 01 - Filial
				_cCodCli  ,; // 02 - Código de Cliente
				_nValorNFT,; // 03 - Valor Total
				_cCC      ,; // 04 - Centro de Custo
				_cProc    ,; // 05 - Processo
				_cObs     ,; // 06 - Observação
				_cTipo    ,; // 07 -Tipo
				_cTipoNF  ,; // 08 - Tipo de Documento
				_cDataTran,; // 09 - Data da Transação
				""        ,; // 10 -
				IIF(_cProd='5100',_cCodSiga,""),; // 11 - Código do Produto no Microsiga
				_nVrUnitNFT,; // 12 - Valor Unitário
				1         ,; // 13 - Quantidade
				_nValorNFT,; // 14 - Valor Total
				_cDescNFT  } // 15 - Descrição do Prod.
			EndIf
			
			dbSelectArea("ISY")
			ISY->(dbSkip())
			
		End
		
		_nQuant   := 1
		
		// Houve erro em algum registro do Master/House e não será importado
		cArqLog  := ""
		If _lError
			_lError := .F.
			
			// Gravo o arquivo de LOG
			_lError  := .F.
			If Rat(".",aFilesLegs[nX,1]) > 0
				cArqLog  := SubStr(aFilesLegs[nX,1],1,Rat(".",aFilesLegs[nX,1])-1)+".LOG"
			Else
				cArqLog  := AllTrim(aFilesLegs[nX,1])+".LOG"
			EndIf
			MemoWrit(cPathErro + cArqLog, cLog)
			
			// Armazeno no array para ser enviado por e-mail
			AADD(_aArqLog, {cFil, cPathErro + cArqLog})
			// AADD(_aLog   , {cFilSiga,  cLog})
			
			dbSelectArea("ISY")
			Loop
		EndIf
		
		_cCodSis  := "02" // ISYGO
		_cIdSeq   := fPegaSeq()
		_cItem    := "01"
		
		// Exportar os dados do TXT da ISYGO para as tabelas CABEC_PRESTACAO e ITENS_PRESTACAO
		If Len(_aNFS) > 0
			For x:=1 To Len(_aNFS)
				
				_cIdSeq   := fPegaSeq()
				_cItem    := "01"
				
				// Se não houver os código "5100 e 5101", então fixo o código "06637"
//				If Empty(_aNFS[x,11])
					_aNFS[x,11] = "06637"
//				EndIf
				
				If _aNFS[x,11] == "06637" .AND. _aNFS[x,01] == "02" // Filial = Beneditinos
					If _cAtivid == "647"  // Importação Maritima
						_aNFS[x,11] = "00260004"
					ElseIf _cAtivid == "648"  // Exportação Maritima
						_aNFS[x,11] = "00260002"
					ElseIf _cAtivid == "637"  // Importação Aérea
						_aNFS[x,11] = "00260001"
					ElseIf _cAtivid == "638"  // Exportação Aérea
						_aNFS[x,11] = "00260003"
					EndIf
				EndIf
				                                                                           
				If _aNFS[x,11] == "06637" .AND. _aNFS[x,01] == "07" // Filial = Beneditinos
					If _cAtivid == "647"  // Importação Maritima
						_aNFS[x,11] = "00260002"
					ElseIf _cAtivid == "648"  // Exportação Maritima
						_aNFS[x,11] = "00260004"
					ElseIf _cAtivid == "637"  // Importação Aérea
						_aNFS[x,11] = "00220001"
					ElseIf _cAtivid == "638"  // Exportação Aérea
						_aNFS[x,11] = "00260003"
					EndIf
				EndIf				
				
				cQry := "INSERT INTO CABEC_PRESTACAO (FILIAL, IDSEQ, CODSISTEMA, CODCLIENTE, VALOR, CCUSTO, PROCESSO, OBS, TIPO, TIPODOC, DATAP, CONTAPSA, CCUSTOPSA, OIPSA, TIPOREG) "
				cQry += "	VALUES ('" + _aNFS[x,01] + "','" + _cIdSeq + "','" + _cCodSis + "','" + _aNFS[x,02] + "','" +;
				Str(_aNFS[x,03]) + "','" + _aNFS[x,04] + "','" + _aNFS[x,05] + "','" + SubStr(_aNFS[x,15],1,Len(_aNFS[x,15])-2) + "','" +;
				_aNFS[x,07] + "','" + _aNFS[x,08] + "'," + _aNFS[x,09] + ",'','','','VEN' ) "
				
				cQry += "INSERT INTO ITENS_PRESTACAO (FILIAL, IDSEQ, ITEM, CODSISTEMA, CODCLIENTE, PRODUTO, VLRUNIT, QTD, VLRTOTAL, ISY_CHAVE ) "
				cQry += "	VALUES ('" + _aNFS[x,01] + "','" + _cIdSeq + "','" + _cItem + "','" + _cCodSis + "','" + _aNFS[x,02] + "','" +;
				_aNFS[x,11] + "','" + Str(_aNFS[x,14]) + "','" + Str(_nQuant) + "','" + Str(_aNFS[x,14]) + "','" + _cChaveIsy + "' ) "
				
				If TcSQLExec(cQry) < 0
					Alert(TcSqlError())
				EndIf
			Next x
			
			// Provisionar Compras
			/*
			For x:=1 To Len(_aNFSCom)
				
				_cIdSeq   := fPegaSeq()
				_cItem    := "03"

				cQry := "INSERT INTO CABEC_PRESTACAO (FILIAL, IDSEQ, CODSISTEMA, CODCLIENTE, VALOR, CCUSTO, PROCESSO, OBS, TIPO, TIPODOC, DATAP, CONTAPSA, CCUSTOPSA, OIPSA, TIPOREG) "
				cQry += "	VALUES ('" + _aNFSCom[x,02] + "','" + _cIdSeq + "','" + _cCodSis + "','" + _aNFSCom[x,03] + "','" +;
				Str(_aNFSCom[x,04]) + "','" + _aNFSCom[x,05] + "','" + _aNFSCom[x,06] + "','" + SubStr(_aNFSCom[x,16],1,Len(_aNFSCom[x,16])-2) + "','" +;
				_aNFSCom[x,08] + "','" + _aNFSCom[x,09] + "'," + _aNFSCom[x,10] + ",'','','','COM' ) "

				cQry += "INSERT INTO ITENS_PRESTACAO (FILIAL, IDSEQ, ITEM, CODSISTEMA, CODCLIENTE, PRODUTO, VLRUNIT, QTD, VLRTOTAL, ISY_CHAVE ) "
				cQry += "	VALUES ('" + _aNFSCom[x,02] + "','" + _cIdSeq + "','" + _cItem + "','" + _cCodSis + "','" + _aNFSCom[x,03] + "','" 
				cQry += _aNFSCom[x,12] + "','" + Str(_aNFSCom[x,13]) + "','" + Str(_aNFSCom[x,14]) + "','" + Str(_aNFSCom[x,15]) + "','" + _cChaveIsy + "' ) "

				If TcSQLExec(cQry) < 0
					Alert(TcSqlError())
				EndIf
			Next x			
			*/
		EndIf
		
		If Len(_aNFT) > 0
			If Empty(_aNFT[11])
				_aNFT[11] = "00220002"
			EndIf
			_cIdSeq   := fPegaSeq()
			_cItem    := "01"
			cQry := "INSERT INTO CABEC_PRESTACAO (FILIAL, IDSEQ, CODSISTEMA, CODCLIENTE, VALOR, CCUSTO, PROCESSO, OBS, TIPO, TIPODOC, DATAP, CONTAPSA, CCUSTOPSA, OIPSA, TIPOREG) "
			cQry += "	VALUES ('" + _aNFT[01] + "','" + _cIdSeq + "','" + _cCodSis + "','" + _aNFT[02] + "','" +;
			Str(_aNFT[03]) + "','" + _aNFT[04] + "','" + _aNFT[05] + "','" + SubStr(_aNFT[15],1,Len(_aNFT[15])-2) + "','" +;
			_aNFT[07] + "','" + _aNFT[08] + "'," + _aNFT[09] + ",'','','','VEN' ) "
			
			cQry += "INSERT INTO ITENS_PRESTACAO (FILIAL, IDSEQ, ITEM, CODSISTEMA, CODCLIENTE, PRODUTO, VLRUNIT, QTD, VLRTOTAL, ISY_CHAVE ) "
			cQry += "	VALUES ('" + _aNFT[01] + "','" + _cIdSeq + "','" + _cItem + "','" + _cCodSis + "','" + _aNFT[02] + "','" +;
			_aNFT[11] + "','" + Str(_aNFT[14]) + "','" + Str(_nQuant) + "','" + Str(_aNFT[14]) + "','" + _cChaveIsy + "' ) "
			
			If TcSQLExec(cQry) < 0
				Alert(TcSqlError())
			EndIf
			
			// Provisão de Compra Ref. NFT
			/*
			For x:=1 To Len(_aNFtCom)
				
				_cIdSeq   := fPegaSeq()
				_cItem    := "04"
				
				cQry := "INSERT INTO CABEC_PRESTACAO (FILIAL, IDSEQ, CODSISTEMA, CODCLIENTE, VALOR, CCUSTO, PROCESSO, OBS, TIPO, TIPODOC, DATAP, CONTAPSA, CCUSTOPSA, OIPSA, TIPOREG) "
				cQry += "	VALUES ('" + _aNFTCom[x,02] + "','" + _cIdSeq + "','" + _cCodSis + "','" + _aNFTCom[x,03] + "','" +;
				Str(_aNFTCom[x,04]) + "','" + _aNFTCom[x,05] + "','" + _aNFTCom[x,06] + "','" + SubStr(_aNFTCom[x,16],1,Len(_aNFTCom[x,16])-2) + "','" +;
				_aNFTCom[x,08] + "','" + _aNFTCom[x,09] + "'," + _aNFTCom[x,10] + ",'','','','COM' ) "

				cQry += " INSERT INTO ITENS_PRESTACAO (FILIAL, IDSEQ, ITEM, CODSISTEMA, CODCLIENTE, PRODUTO, VLRUNIT, QTD, VLRTOTAL, ISY_CHAVE ) "
				cQry += "	VALUES ('" + _aNFTCom[x,02] + "','" + _cIdSeq + "','" + _cItem + "','" + _cCodSis + "','" + _aNFTCom[x,03] + "','" +;
				_aNFTCom[x,12] + "','" + Str(_aNFTCom[x,13]) + "','" + Str(_aNFSCom[x,14]) + "','" + Str(_aNFTCom[x,15]) + "','" + _cChaveIsy + "' ) "

				If TcSQLExec(cQry) < 0
					Alert(TcSqlError())
				EndIf
			Next x	
			*/
		EndIf
		
		_nValorNFS  := 0.00
		_nVrUnitNFS := 0.00
		
		_nVrNFS531  := 0.00
		_nVrUNFS531 := 0.00
		
		_nVrNFS312  := 0.00
		_nVrUNFS312 := 0.00
		
		_nVrUnitNFT := 0.00
		_nValorNFT  := 0.00
		
		// Descrição do Produto
		_cDescNFS  := ""
		_cDescNFT  := ""
		_cDesNFT531:= ""
		_cDesNFS531:= ""
		_cDesNFS312:= ""
		
		_aNFS 	 := {}
		_aNFT 	 := {}
		_aNFTCom := {}
		_aNFSCom := {}
	End
	
	If _lErrorLog
		_lErrorLog := .F.
		
		// Gravo o arquivo de LOG
		If Rat(".",aFilesLegs[nX,1]) > 0
			cArqLog  := SubStr(aFilesLegs[nX,1],1,Rat(".",aFilesLegs[nX,1])-1)+".LOG"
		Else
			cArqLog  := AllTrim(aFilesLegs[nX,1])+".LOG"
		EndIf
		MemoWrit(cPathErro + cArqLog, cLog)
		// __CopyFile(cPath + cArqLog, cPath + "Errata\" +  cArqLog)
		//Ferase( cPath + cArqLog )
		
	EndIf
	/*
	Else
	// Filial não cadastrada na tabela SZC
	cFilNaoP+="Filial: ("+cFil+")-"+cFilRMA+" nao importado.  Favor verificar na tabela SZC."+chr(10)
	
	// Gravo o arquivo de LOG
	If Rat(".",aFilesLegs[nX,1]) > 0
	cArqLog  := SubStr(aFilesLegs[nX,1],1,Rat(".",aFilesLegs[nX,1])-1)+".LOG"
	Else
	cArqLog  := AllTrim(aFilesLegs[nX,1])+".LOG"
            	EndIf
	
	// Gravo o arquivo de Log
	MemoWrit(cPath +"Errata\" + cArqLog, aFilesLegs[nX,1] + " -> " + cFilNaoP)
	
	// Armazeno no array para ser enviado por e-mail
	AADD(_aArqLog, {cFil, cPathErro + cArqLog})
	EndIf
	*/
	// Apago os dados do arquivo temporário
	dbSelectArea("ISY")
	ZAP
	
	// Move o arquivo TXT para uma pasta de Backup
	If Empty(cFilNaoP)
//		If _lMoveArq .AND. !Empty(cArqLog)
			__CopyFile(cPath + aFilesLegs[nX,1], cPath + "Backup\" +  aFilesLegs[nX,1])
			Ferase( cPath + aFilesLegs[nX,1] )

			// Mover o arquivo de House
			_cArqHouse := "H"+ SubStr(aFilesLegs[nX,1],2,Len(aFilesLegs[nX,1]))
			__CopyFile(cPath + _cArqHouse, cPath + "Backup\" + _cArqHouse)
			Ferase( cPath + _cArqHouse )
//		EndIf	
	EndIf
Next nX

If !Empty(cFilNaoP)
	If lAutoRot
		ConOut("Relação de filiais não importadas por não pertencerem a filial("+cFilAnt+"):"+chr(10)+cFilNaoP)
	Else 
		APMsgAlert("Relação de filiais não importadas por não pertencerem a filial("+cFilAnt+"):"+chr(10)+cFilNaoP)	
	EndIf	
EndIf

// Copia os arquivos de House para a paste de backup
If Empty(cFilNaoP)
/*
	For nX:=1 To Len(aFilesHouse)
		__CopyFile(cPath + aFilesHouse[nX,1], cPath + "Backup\" +  aFilesHouse[nX,1])
		Ferase( cPath + aFilesHouse[nX,1] )
	Next nX
*/	
EndIf

// Copia os arquivos de Master para a paste de backup
If Empty(cFilNaoP)
	For nX:=1 To Len(aFilesMaster)
		__CopyFile(cPath + aFilesMaster[nX,1], cPath + "Backup\" +  aFilesMaster[nX,1])
		Ferase( cPath + aFilesMaster[nX,1] )
	Next nX
EndIf

// Copia os arquivos de Legs para a paste de backup
If Empty(cFilNaoP)
/*
	For nX:=1 To Len(aFilesLegs)
		__CopyFile(cPath + aFilesLegs[nX,1], cPath + "Backup\" +  aFilesLegs[nX,1])
		Ferase( cPath + aFilesLegs[nX,1] )
	Next nX
*/	
EndIf

// Apago o arquivo temporário usado
FERASE(cNomArq+".DBF")

// Apago o arquivo de House temporário usado
FERASE(cArqHouse+".DBF")
FERASE(cIndHouse+OrdBagExt())

If File(cPathErro+cArqLog)
	If lAutoRot
		ConOut("Arquivo foi importado porém com errata de alguns registros."+Chr(13)+"Favor consultar o arquivo de errata(LOG) na pasta "+cPath+"Errata\")
	Else
		APMsgAlert("Arquivo foi importado porém com errata de alguns registros."+Chr(13)+"Favor consultar o arquivo de errata(LOG) na pasta "+cPath+"Errata\")	
	EndIf
EndIf

// Envia o arquivo de Log de Erro por E-Mail.
//If Len(_aArqLog) > 0
If Len(_aLog) > 0
	fEnviaLog(_aLog)
EndIf

Return

*------------------------------------------------------------------*
Static Function fBuscaCC(cCatCli, cCliente, cLoja, cAtivid, cFilCC)
*------------------------------------------------------------------*
Local _aArea    := GetArea()
Local _cQry     := ""
Local _c10DigCC := ""
// Local _cCC      := "322" + cFilCC + "401"// + cAtivid
Local _cCC      := "322" + cFilCC //+ "401"// + cAtivid

If AllTrim(cAtivid) == "637"	  // Importação Aérea
	_cCC += "403"
ElseIf AllTrim(cAtivid) == "647"  // Importação Marítima
	_cCC += "401"
ElseIf AllTrim(cAtivid) == "638"  // Exportação Aéria
	_cCC += "404"
ElseIf AllTrim(cAtivid) == "648"  // Exportação Maritma
	_cCC += "402"
Else
	_cCC += "401"
EndIf

// Composição do CC com 10 Digitos
/*
ABBCCCDDDE -> Centro de Custo, onde:
A   = Divisão
BB  = Unidade Operacional
CCC = Código da Filial
DDD = Atividade(Produto)
E   = Designação da Venda
*/

_cQry := "SELECT * FROM " + RetSqlName("SZD") + " SZD "
_cQry += "	WHERE ZD_FILIAL = '" + xFilial("SZD") + "' "
If isCliPSA(cCliente+cLoja,.f.)
	_cQry += "	  AND ZD_UO LIKE '%22%' "
EndIf
_cQry += "	  AND ZD_GEFCAT1 = '" + cCatCli + "' "
_cQry += "	  AND SZD.D_E_L_E_T_ = ' ' "

TCQUERY _cQry ALIAS "TRB" NEW

dbSelectArea("TRB") ; dbGoTop()
If !Eof()
	_c10DigCC := TRB->ZD_10DIGIT
	//	If Empty(_c10DigCC) ; _c10DigCC := "3" ; EndIf
EndIf

If Empty(_c10DigCC)
	dbSelectArea("CTT") ; dbSetOrder(1)
	If dbSeek(xFilial("CTT") + _cCC, .T.)
		_c10DigCC := SubStr(CTT->CTT_CUSTO,1,10)
	EndIf
EndIf

_cCC +=	_c10DigCC

dbSelectArea("TRB") ; dbCloseArea()

RestArea(_aArea)
Return _cCC

/************************************************************************
* Funcao....: isCliPSA()                                                *
* Autor.....: Marcelo Aguiar Pimentel                                   *
* Data......: 14/03/2007                                                *
* Descricao.: Verifica se o cliente está cadastrado na tabela SZE(Clien *
*             Peugeot PSA                                               *
*                                                                       *
************************************************************************/
Static Function isCliPSA(pCliente,lCodSap)
Local lRet:=.t.
Local _aArea := GetArea()

dbSelectArea("SZE") ; dbSetOrder(1)

If !dbSeek(xFilial("SZE")+pCliente)
	lRet:=.f.
EndIf

RestArea(_aArea)
Return lRet

*----------------------------------*
Static Function fPegaProd(_cCodRMA)
*----------------------------------*
Local _aArea := GetArea()
Local _cProdSiga
Local _cQry

_cQry := "SELECT PROD_RMA, PROD_SIGA, DESCRICAO "
_cQry += "  FROM PRODUTO_RMA "
_cQry += " WHERE PROD_RMA = '" + _cCodRMA + "' "

TCQUERY _cQry ALIAS "_TRB" NEW

dbSelectArea("_TRB") ; dbGoTop()
_cProdSiga := _TRB->PROD_SIGA

_TRB->(dbCloseArea())

RestArea(_aArea)
Return _cProdSiga

*----------------------------------*
Static Function fPegaSeq()
*----------------------------------*
Local _aArea := GetArea()
Local _cProxSeq
Local _cQry

If Select("_TRB") > 0
	dbSelectArea("_TRB") ; dbCloseArea()
EndIf

_cQry := "SELECT MAX(IDSEQ) AS SEQ FROM CABEC_PRESTACAO "

TCQUERY _cQry ALIAS "_TRB" NEW

dbSelectArea("_TRB") ; dbGoTop()
_cProxSeq := StrZero(Val(_TRB->SEQ)+1,9)

_TRB->(dbCloseArea())

RestArea(_aArea)
Return _cProxSeq

*----------------------------*
Static Function fMontaHouse()
*----------------------------*
Local aCampos := {}
Local _aArea := GetArea()

Private cNomArq1 := ""

*----------------------------------*
* Preparando Arquivo temporário    *
*----------------------------------*
AADD(aCampos, {"LINHA", "C",  1378, 0})

If Select("_TXT") > 0
	dbSelectArea("_TXT") ; dbCloseArea()
EndIf

cNomArq1 := CriaTrab (aCampos, .T.)
dbUseArea (.T., , cNomArq1, "_TXT", .F. , .F.)  // Exclusivo
dbGoTop()

For nX:=1 to len(aFilesHouse)
	
	IncProc()
	
	// Carrego o arquivo temporário com os dados do TXT
	APPEND FROM (cPath + aFilesHouse[nX,1]) SDF
	_TXT->(dbGoTop())
Next nX

// Crio o DBF com os números dos processos contidos no arquivo  HOUSE
If Len(aFilesHouse) > 0
	aCampos := {}
	AADD(aCampos, {"PROCESSO" , "C",  70, 0})
	AADD(aCampos, {"MASTERNUM", "C",  17, 0})
	AADD(aCampos, {"HOUSENUM" , "C",  17, 0})
	AADD(aCampos, {"CODATIVID", "C",  03, 0})
	
	If Select("HOU") > 0
		dbSelectArea("HOU") ; dbCloseArea()
	EndIf
	
	cArqHouse := CriaTrab (aCampos, .T.)
	dbUseArea (.T., , cArqHouse, "HOU", .F. , .F.)  // Exclusivo
	
	cIndHouse := CriaTrab (aCampos, .T.)
	
	//	IndRegua("HOU",cIndHouse,"PROCESSO",,,"Selecionando Registros")
	IndRegua("HOU",cIndHouse,"MASTERNUM+HOUSENUM",,,"Selecionando Registros")
	DbSelectArea("HOU")
	DbClearIndex()
	DbSetIndex(cIndHouse+OrdBagExt())
	
	dbSelectArea("_TXT") ; dbGoTop()
	While !EOF()
		dbSelectArea("HOU")
		RecLock("HOU",.T.)
		HOU->MASTERNUM:= AllTrim(SubStr(_TXT->LINHA,231,17)) 	// Número do Master
		HOU->HOUSENUM := AllTrim(SubStr(_TXT->LINHA,248,17)) 	// Número House
		HOU->PROCESSO := AllTrim(SubStr(_TXT->LINHA,657,70)) 	// Número do Processo(Other reference) - rEF. gefco
		HOU->CODATIVID:= AllTrim(SubStr(_TXT->LINHA,946,03)) 	// Número do Processo(Other reference) - rEF. gefco
		MsUnLock()
		
		dbSelectArea("_TXT")
		dbSkip()
	End
	
	dbSelectArea("_TXT") ; dbCloseArea()
	FERASE(cNomArq1+".DBF")
	
EndIf

RestArea(_aArea)
Return

*-----------------------------------*
Static Function fEnviaLog(_aLog)
*-----------------------------------*
Local aFiles      := {}
Local _cFilAnt    := ""
Local _cMsgLog    := ""
Local cNL         := CHR(13)+CHR(10)

// Ordeno o Array por Filial
_aLog := aSort( _aLog,,, { | x , y | x[1] < y[1] } )

// Envio e-mail com os logs de erro para a Filial
_cFilAnt := _aLog[1,1]
For x:=1 To Len(_aLog)
	
	If _cFilAnt == _aLog[x,1]
		_cMsgLog += _aLog[x,2] + cNL
	Else
		*-----------------------------*
		fEnviaEMail(_cFilAnt,_cMsgLog)
		*-----------------------------*
		_cMsgLog := ''
		_cMsgLog += _aLog[x,2] + cNL
		_cFilAnt := _aLog[x,1]
	EndIf
	/*
	_nPosArq := aScan(_aArquivos,{|x| alltrim(x[1] ) == _aArqs[x,1]})
	
	If _nPosArq = 0
		AADD(_aArquivos,{ _aArqs[x,1], "'" + _aArqs[x,2] + "'" + "; " })
	Else
		_aArquivos[_nPosArq,2] +=  "'" + _aArqs[x,2] + "'" + "; "
	EndIf
	*/
	
Next x

// Envio o log da a última filial
If !Empty(_cMsgLog)
	fEnviaEMail(_cFilAnt,_cMsgLog)
EndIf

Return

*--------------------------------------------*
Static Function fEnviaEmail(_cFilial,_cMsgLog)
*--------------------------------------------*

//Local cMailServer := GetMv("MV_WFSMTP")
Local cMailServer :=GetMV("MV_RELSERV")
Local cSubject    := ""
Local cBody       := ""
Local aFiles      := {}
Local cToCC       := AllTrim("")
Local _cMsg       := ""
Local cEmail      := ""

/*cPass     := GetMv("MV_WFPASSW")
cAccount  := GetMv("MV_WFACC")*/

// cEmail := GETMV('"'+('MV_ISYGO'+_cFilial)+'"')  // "jose.guimaraes@gefco.com.br"
If _cFilial = '02'
	cEmail := GETMV("MV_ISYGO02")
ElseIf _cFilial = '07'
	cEmail := GETMV("MV_ISYGO07")
ElseIf _cFilial = '08'
	cEmail := GETMV("MV_ISYGO08")             	
ElseIf _cFilial = '11' .OR. _cFilial = '21'
	cEmail := GETMV("MV_ISYGO11")
EndIf

If Empty(cEmail)
	cEmail := "jose.guimaraes@gefco.com.br"
	cBody  := _cFilial + " - Sem parametrização de e-mails no configurador para os usuários que irão receber a errada do Isygo."
EndIf

cEmailOri := "jose.guimaraes@gefco.com.br"
cAccount  := GetMV("MV_RELACNT")
cPass     := GetMV("MV_RELPSW")
cFrom     := GetMV("MV_RELFROM")

cTo       := AllTrim(cEmail)

cSubject  := "ISYGO - Crítica"
_cMsg     += "Seque Lista de errata da interface ISYGO! - Filial = " + _cFilial + " - " + DTOC(dDATABASE) + " - " + SubStr(Time(),1,5) + Chr(13) + Chr(10)
_cMsg     += "=================================================================================================" + Chr(13) + Chr(10)

cBody     := _cMsg + _cMsgLog

cErrorMsg := ""

//EnvEmail(cDe,cPara,cCc,cAssunto,cMsg,cAnexo)
U_EnvEmail(cFrom,cTo,,cSubject,cBody)

/*
connect smtp server cMailServer account cAccount password cPass RESULT _lOk

If _lOk
	send mail from cFrom to cTo subject cSubject body cBody // attachment &(_cArquivos)
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR _cError
	CONOUT("Erro no envio do E-Mail - " + _cError)
EndIf

//GET MAIL ERROR cErrorMsg

DISCONNECT SMTP SERVER

WFSENDMAIL({cEmpAnt,cFilAnt})
*/

Return

*-------------------------------------*
Static Function GeraProvCom(_cTipoNF)
*-------------------------------------*
Local _aArea 	:= GetArea()
Local _cInvoice := ""
Local _cCNPJ    := ""
Local _cCodFor  := ""
Local _cLojFor  := ""

_cInvoice := SubStr(ISY->LINHA,136,17) // HOU->PROCESSO
			
dbSelectArea("ISY")
			
// Registro no TXT sem valor(zerado)
If Empty(Val(SubStr(ISY->LINHA,733,11)))
	RestArea(_aArea)
	Return
EndIf
			
_cCNPJ   := AllTrim(SubStr(ISY->LINHA,87,17))
_cCodFor := AllTrim(SubStr(ISY->LINHA,53,17))
_cCodFor := SubStr(AllTrim(_cCodFor),5,6)
_cLojFor := ""
			
If !Empty(_cCNPJ)
	// Posiciono no fornecedor através do CNPJ
	dbSelectArea("SA2") ; dbSetOrder(3)
				
	If !dbSeek(xFilial("SA2")+_cCNPJ)  // CNPJ
		// Gero erro de LOG e não importo
		_lError    := .T.
		_lErrorLog := .T.
		cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => CNPJ (" + _cCNPJ + ") do fornecedor não cadastrado " + cNL
		AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => CNPJ (" + _cCNPJ + ") do fornecedor não cadastrado "})
		dbSelectArea("ISY")
		_lError    := .T.
		_lErrorLog := .T.
	Else
		_cCodCli := SA2->A2_COD
		_cLojCli := SA2->A2_LOJA
	EndIf
Else
	// Posiciono no fornecedor através do Código
	dbSelectArea("SA2") ; dbSetOrder(1)
	If !dbSeek(xFilial("SA2")+_cCodFor)  // Código do Fornecedor
		// Gero erro de LOG e não importo
		_lError    := .T.
		_lErrorLog := .T.
		cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código do Fornecedor (" + _cCodCli + ") não cadastrado " + cNL
		AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código do Fornecedor (" + _cCodCli + ") não cadastrado "})
		_lError    := .T.
		_lErrorLog := .T.
					
		dbSelectArea("ISY")
	Else
		_cLojCli := SA2->A2_LOJA
	EndiF
EndIf
			
// Busco o número do processo contido no arquivo de House
_cHouseChav := SubStr(ISY->LINHA,01,17) + AllTrim(SubStr(ISY->LINHA,18,17)) // Master + House Nbr.
dbSelectArea("HOU")
If !dbSeek(_cHouseChav)
	cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Registro não encontrado no arquivo HOUSE " + cNL
	AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Registro não encontrado no arquivo HOUSE "})
	_lError := .T.
	_lErrorLog := .T.
	dbSelectArea("ISY")
EndIf
			
_cProc := SubStr(ISY->LINHA,18,17) // HOU->PROCESSO
If Empty(_cProc)
	cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Número de Processo em branco " + cNL
	AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Número de Processo em branco "})
	_lError    := .T.
	_lErrorLog := .T.
	dbSelectArea("ISY")
EndIf
			
_cAtivid := HOU->CODATIVID
If Empty(_cAtivid)
	cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código de Atividade em branco " + cNL
	AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código de Atividade em branco "})
	_lError    := .T.
	_lErrorLog := .T.
	dbSelectArea("ISY")
EndIf

// Pego o código do produto do Microsiga através do Fee (code)
_cProd := AllTrim(SubStr(ISY->LINHA,587,008))
If Empty(_cProd)
	cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código de Produto - fee(code) em branco. " + cNL
	AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código de Produto - fee(code) em branco. "})
	_lError := .T.
	_lErrorLog := .T.
	dbSelectArea("ISY")
EndIf

// Verificar a implementação correta do CC.			
// Busco o Centro de Custo conforme regra
// _cCC := fBuscaCC(SA1->A1_GEFCAT1, SA2->A2_COD, SA2->A2_LOJA, _cAtivid, cFilCC)
_cCC := fBuscaCC("", SA2->A2_COD, SA2->A2_LOJA, _cAtivid, cFilCC)
			
dbSelectArea("ISY")
			
_cTipoDoc := AllTrim(SubStr(ISY->LINHA,755,003))  // VAT(code)
_cTipo    := ""
_cObs     := AllTrim(SubStr(ISY->LINHA,314,070))  // Observations

_nVrNFS   := 0.00
_nVrUNFS  := 0.00
_nVrNFT   := 0.00
_nVrUNFT  := 0.00
			
//If AllTrim(SubStr(ISY->LINHA,106,03)) == "BRL"
	If _cTipoNF == "NFS"
		_nVrNFS  := Val(SubStr(ISY->LINHA,733,12))/100
		_nVrUNFS := Val(SubStr(ISY->LINHA,733,12))/100
	Else
		_nVrNFT  := Val(SubStr(ISY->LINHA,733,12))/100
		_nVrUNFT := Val(SubStr(ISY->LINHA,733,12))/100
	EndIf
/*	
Else
	// Por: Ricardo de Oliveira - Em: 17/11/2008 - Definido pelo Valter Silva
	// Tratamento de conversão de moeda - a taxa é informada no campo observação (314 a 383) 
	// XXX 9,999 - onde XXX é o código da moeda.  O campo Currency code indica a moeda do documento na posição 106 a 108
				 
	_nTaxa := 0
	_nTaxa := Val(StrTran(AllTrim(SubStr(ISY->LINHA,327,5)),',','.'))
				
	If Empty(_nTaxa)
		cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Moeda diferente de REAL sem taxa de conversão." + cNL
		AADD(_aLog, {cFilSiga, "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Moeda diferente de REAL sem taxa de conversão."})
		_lError    := .T.
		_lErrorLog := .T.
		dbSelectArea("ISY")
		// ISY->(dbSkip())
		// Loop
		RestArea(_aArea)
		Return
	EndIf

	If _cTipoNF == "NFS"
		_nVrNFS  := Val(SubStr(ISY->LINHA,733,12))/100 * _nTaxa 
		_nVrUNFS := Val(SubStr(ISY->LINHA,733,12))/100 * _nTaxa 
	Else
		_nVrNFT  := Val(SubStr(ISY->LINHA,733,12))/100 * _nTaxa 
		_nVrUNFT := Val(SubStr(ISY->LINHA,733,12))/100 * _nTaxa
	EndIf
EndIf
*/

// Data de Transmissão do arquivo
_cDataTran:= SubStr(ISY->LINHA,797,08)
			
// Código do Fornecedor + Loja
_cCodFor := _cCodFor + _cLojFor
			
// Descrição do VAT COD ( Produto )
_cDesProd := StrTran(AllTrim(SubStr(ISY->LINHA,638,35)),"'","")

_cCodSiga = "06637"
			
If _cTipoNF == "NFS"
	_cCodSiga = "06637"

	_nPos    := aScan(_aNFSCom,{|x| ('NFS' $ AllTrim(x[1])) })
	
	If Empty(_nPos)
		AADD(_aNFSCom,{;
			_cTipoNF  ,; // Tipo de Documento
			cFil      ,; // Filial
			_cCodfor  ,; // Código do Fornecedor
			_nVrNFS   ,; // Valor Total
			Left(_cCC,10) ,; // Centro de Custo
			_cProc    ,; // Processo
			_cObs     ,; // Observação
			_cTipo    ,; // Tipo
			_cTipoNF  ,; // Tipo de Documento
			_cDataTran,; // Data da Transação
			""        ,; //
			_cCodSiga ,; // Código do Produto no Microsiga
			_nVrUNFS  ,; // Valor Unitário
			1         ,; // Quantidade
			_nVrNFS   ,; // Valor Total
			_cDesProd+", " }) // 15 - Descrição do Prod.
	Else
		_nPosProd := AT(AllTrim(_cDesProd), _aNFSCom[_nPos,16])
	
		_aNFSCom[_nPos,01] := _cTipoNF   // 01-Tipo de Documento
		_aNFSCom[_nPos,02] := cFil       // 02-Filial
		_aNFSCom[_nPos,03] := _cCodfor   // 03-Código do Fornecedor
		_aNFSCom[_nPos,04] += _nVrNFS    // 04-Valor Total
		_aNFSCom[_nPos,05] := Left(_cCC,10) // 05-Centro de Custo
		_aNFSCom[_nPos,06] := _cProc     // 06-Processo
		_aNFSCom[_nPos,07] += _cObs      // 07-Observação
		_aNFSCom[_nPos,08] := _cTipo     // 08-Tipo
		_aNFSCom[_nPos,09] := _cTipoNF   // 09-Tipo de Documento
		_aNFSCom[_nPos,10] := _cDataTran // 10-Data da Transação
		_aNFSCom[_nPos,11] := ""         // 11-
		_aNFSCom[_nPos,12] := _cCodSiga  // 12-Código do Produto no Microsiga
		_aNFSCom[_nPos,13] := _nVrUNFS   // 13-Valor Unitário
		_aNFSCom[_nPos,14] := 1		     // 14-Quantidade
		_aNFSCom[_nPos,15] += _nVrNFS    // 15-Valor Total
		_aNFSCom[_nPos,16] +=	IIF(Empty(_nPosProd),_cDesProd + ", ", "") // 16 - Descrição do Prod.
	EndIf
Else // NFT
	// Descrição do Produto
	// Não permito duplicidade de descrição
				
	_nPos    := aScan(_aNFTCom,{|x| ('NFT' $ AllTrim(x[1])) })
	
	If Empty(_nPos)
		AADD(_aNFTCom ,{; 
			_cTipoNF  ,; // Tipo de Documento
			cFil      ,; // Filial
			_cCodfor  ,; // Código do Fornecedor
			_nVrNFT   ,; // Valor Total
			Left(_cCC,10) ,; // Centro de Custo
			_cProc    ,; // Processo
			_cObs     ,; // Observação
			_cTipo    ,; // Tipo
			_cTipoNF  ,; // Tipo de Documento
			_cDataTran,; // Data da Transação
			""        ,; //
			_cCodSiga ,; // Código do Produto no Microsiga
			_nVrUNFT  ,; // Valor Unitário
			1         ,; // Quantidade
			_nVrNFT   ,; // Valor Total
			_cDesProd + ", "}) // 15 - Descrição do Prod.
	Else
		_nPosProd := AT(_cDesProd, _aNFTCom[_nPos,16])
	
		_aNFTCom[_nPos,01] := _cTipoNF   // 1-Tipo de Documento
		_aNFTCom[_nPos,02] := cFil       // 2-Filial
		_aNFTCom[_nPos,03] := _cCodfor   // 3-Código do Fornecedor
		_aNFTCom[_nPos,04] += _nVrNFT    // 4-Valor Total
		_aNFTCom[_nPos,05] := Left(_cCC,10) // 5-Centro de Custo
		_aNFTCom[_nPos,06] := _cProc     // 6-Processo
		_aNFTCom[_nPos,07] += _cObs      // 7-Observação
		_aNFTCom[_nPos,08] := _cTipo     // 8-Tipo
		_aNFTCom[_nPos,09] := _cTipoNF   // 9-Tipo de Documento
		_aNFTCom[_nPos,10] := _cDataTran // 10-Data da Transação
		_aNFTCom[_nPos,11] := ""         // 11-
		_aNFTCom[_nPos,12] := _cCodSiga  // 12-Código do Produto no Microsiga
		_aNFTCom[_nPos,13] := _nVrUNFT   // 13-Valor Unitário
		_aNFTCom[_nPos,14] := 1		     // 14-Quantidade
		_aNFTCom[_nPos,15] += _nVrNFT    // 15-Valor Total
		_aNFTCom[_nPos,16] += IIF(Empty(_nPosProd),_cDesProd + ", ","") // 16 - Descrição do Prod.				
	EndIf
EndIf

RestArea(_aArea)
Return