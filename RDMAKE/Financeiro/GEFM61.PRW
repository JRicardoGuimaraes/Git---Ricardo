#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"    
#INCLUDE "TOPCONN.CH"

/************************************************************************************
* Programa.......: GEFM6101()                                                       *
* Autor..........: J Ricardo de O Guimarães                                         *
* Data...........: 05/09/2007                                                       *
* Descricao......: Integração ISYGO x MICROSIGA                                     *
*                                                                                   *
*************************************************************************************
* Modificado por.:                                                                  *
* Data...........:                                                                  *
* Motivo.........:                                                                  *
*                                                                                   *
************************************************************************************/

USER FUNCTION GEFM61()
Local 	nOpcao	:=	0

Private _oDlg
Private cPath	    :=	space(255)
Private aFilesLegs  := {}
Private aFilesHouse	:= {}
Private aFilesMaster:= {}

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

// SetKey (VK_F3,{||})
Return

*-----------------------------*
STATIC FUNCTION fProcessa()
*-----------------------------*

cPath:=alltrim(cPath)
If substr(cPath,len(cPath),1) != "\"
	cPath+="\"
EndIf

//aFilesLegs := Directory(cPath + "CISY_TAXF*.txt")  // Todos os arquivos da Legs presente na pasta
//aFilesHouse:= Directory(cPath + "CISY_TAXH*.txt")  // Todos os arquivos da Legs presente na pasta

aFilesLegs  := Directory(cPath + "F0841*_bresil0841")  // Todos os arquivos da Legs presente na pasta
aFilesHouse := Directory(cPath + "H0841*_bresil0841")  // Todos os arquivos da Legs presente na pasta
aFilesMaster:= Directory(cPath + "M0841*_bresil0841")  // Todos os arquivos da Legs presente na pasta

If Len(aFilesLegs) > 0
	If Len(aFilesHouse) > 0
		Processa({|| RunImport() },"Processando...")
	Else 
		APMsgAlert("Não foi possível encontrar arquivo de HOUSE na pasta informada!")
	EndIf	
Else
	APMsgAlert("Não foi possível encontrar arquivo na pasta informada!")
EndIf

Return

*---------------------------------*
Static Function RunImport()
*---------------------------------*
Local aCampos     := {}
Local cQry
Local cLog
Local cArqLog     := ""
Local cNL         := CHR(13)+CHR(10)
Local nLin        := 0
Local _lError     := .F.
Local _lErrorLog  := .F.
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
Local _cDesNFT312:= ""

Local _cDescNFT  := ""
Local _cDescNFS  := ""

Private nTamFile
Private nSizeTot	:=	0
Private cIndHouse   := ""
Private cArqHouse   := ""

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

	IncProc()
	
	// Carrego o arquivo temporário com os dados do TXT
	APPEND FROM (cPath + aFilesLegs[nX,1]) SDF
	ISY->(dbGoTop())
	
	// Pego a Filial
	cFil := AllTrim(SubStr(ISY->LINHA,35,5))

	cQry:="SELECT ZC_FILIAL, ZC_FILRMA, ZC_FILSAP, ZC_FILCC FROM "+RetSqlName("SZC")
	cQry+=" WHERE ZC_FILRMA = '"+cFil+"'"
	
	TcQuery cQry Alias "TFIL" New
	
	cFilRMA     := AllTrim(cFil)
	cFilCC      := AllTrim(TFIL->ZC_FILCC)
	cFilSAP     := AllTrim(TFIL->ZC_FILSAP)
	cFil		:=TFIL->ZC_FILIAL
	TFIL->(dbCloseArea())
	
	If cFil = cFilAnt

		nLin     := 0		// Número de linhas lidas
		_lError  := .F. 	// Controla de houve erro para gravação do arquivo de LOG
		
		*=========================*
		* criacao do arquivo Log  *
		*=========================*		
		cLog := "Criacao do arquivo de erros gerados pelo sistema de importacao - Data: "+dtoc(ddatabase)+cNL
		cLog += "======================================================================================" +cNL		
		
		dbSelectArea("ISY") ; dbGoTop()

		While !ISY->(eof())
		
			_cChave := ''
			// A chave é composta pelo Nr. Master + Nr.House
			_cChave := SubStr(ISY->LINHA,01,17) + SubStr(ISY->LINHA,18,17)
			             
			// Controle se será incluso o registro
			_lGera := .F.
			_aNFS := {}
			_aNFS := {}
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
					// Aqui irei provisionar o registro ref. compra
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
					
					// Pedigo o número do pedido
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
						EndIf
					Else
							cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Já foi importado o registro ref. ao Master/House/Invoice Number :" + _cChaveIsy + cNL											
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
						_lError  := .T.
						_lErrorLog := .T.						
						cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => CNPJ (" + _cCNPJ + ") não cadastrado " + cNL
						
						dbSelectArea("ISY")
						_lError := .T.
						_lErrorLog := .T.						
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
						_lError  := .T.
						_lErrorLog := .T.						
						cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código do Cliente (" + _cCodCli + ") não cadastrado " + cNL
						_lError := .T.
						_lErrorLog := .T.						
												
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
					_lError := .T.
					_lErrorLog := .T.					
					dbSelectArea("ISY")
//					ISY->(dbSkip())
//					Loop				
				EndIf
	           
				_cProc := SubStr(ISY->LINHA,18,17) // HOU->PROCESSO
				If Empty(_cProc)
					cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Número de Processo em branco " + cNL
					_lError := .T.					
					_lErrorLog := .T.					
					dbSelectArea("ISY")
//					ISY->(dbSkip())
//					Loop
				EndIf			
				
				_cAtivid := HOU->CODATIVID
				If Empty(_cAtivid)
					cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código de Atividade em branco " + cNL
					_lError := .T.					
					_lErrorLog := .T.					
					dbSelectArea("ISY")
//					ISY->(dbSkip())
//					Loop
				EndIf
	
				// Pego o código do produto do Microsiga através do Fee (code) 
				_cProd := AllTrim(SubStr(ISY->LINHA,587,008))
				If Empty(_cProd)
					cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código de Produto - fee(code) em branco. " + cNL
					_lError := .T.
					_lErrorLog := .T.					
					dbSelectArea("ISY")
//					ISY->(dbSkip())
//					Loop
				EndIf			
				             
				// Busco produto na tabela depara de produto do RMA
				If _cProd $ "5100|5101"
					_cCodSiga := fPegaProd(_cProd)
					If Empty(_cCodSiga)
						cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Código de Produto - fee(code) (" + _cProd + ") não relacionado na tabela PRODUTO_RMA. " + cNL
						_lError := .T.
						_lErrorLog := .T.
						dbSelectArea("ISY")
//						ISY->(dbSkip())
//						Loop
					EndIf
				EndIf
                            
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
					If Empty(Val(SubStr(ISY->LINHA,713,15)))
						cLog += "Erro linha " + StrZero(nLin,3) + " " + _cLogLinha + " => Moeda diferente de REAL sem taxa de conversão." + cNL
						_lError := .T.						
						_lErrorLog := .T.						
						dbSelectArea("ISY")
						ISY->(dbSkip())
						Loop
					EndIf
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
				EndIf

				// Data de Transmissão do arquivo
				_cDataTran:= SubStr(ISY->LINHA,797,08)


				// Código do Cliente + Loja				
				_cCodCli := _cCodCli + _cLojCli
				
				If _cTipoNF == "NFS"
					// Descrição do Produto
					// Tratamento para separa Profit Share(531) e Desembaraço (312)
					// _cDesNFT531:= ""
					// _cDesNFS312:= ""					
					If _cProd == "531"
						_cDesNFT531 += StrTran(AllTrim(SubStr(ISY->LINHA,638,35)),"'","") + ", "
						
						AADD(_aNFS,{cFil     ,;	// Filial
								   _cCodCli  ,; // Código de Cliente
								   _nVrNFS531,; // Valor Total
								   _cCC      ,; // Centro de Custo
								   _cProc    ,; // Processo
								   _cObs     ,; // Observação
								   _cTipo    ,; // Tipo
								   _cTipoDoc ,; // Tipo de Documento
								   _cDataTran,; // Data da Transação
								   ""        ,; // 
								   IIF(_cProd='5101',_cCodSiga,"") ,; // // Código do Produto no Microsiga
								   _nVrUNFS531 ,; // Valor Unitário
								               ,; // Quantidade
								   _nVrNFS531  ,; // Valor Total
								   _cDesNFT531 }) // 15 - Descrição do Prod.
								   
					ElseIf _cProd == "312"
						_cDesNFT312 += StrTran(AllTrim(SubStr(ISY->LINHA,638,35)),"'","") + ", "
						
						AADD(_aNFS,{cFil     ,;	// Filial
								   _cCodCli  ,; // Código de Cliente
								   _nVrNFS312,; // Valor Total
								   _cCC      ,; // Centro de Custo
								   _cProc    ,; // Processo
								   _cObs     ,; // Observação
								   _cTipo    ,; // Tipo
								   _cTipoDoc ,; // Tipo de Documento
								   _cDataTran,; // Data da Transação
								   ""        ,; // 
								   IIF(_cProd='5101',_cCodSiga,"") ,; // // Código do Produto no Microsiga
								   _nVrUNFS312 ,; // Valor Unitário
								               ,; // Quantidade
								   _nVrNFS312  ,; // Valor Total
								   _cDesNFT312 }) // 15 - Descrição do Prod.
					Else						
						_cDescNFS  +=  StrTran(AllTrim(SubStr(ISY->LINHA,638,35)),"'","") + ", "
							
						AADD(_aNFS,{cFil     ,;	// Filial
								   _cCodCli  ,; // Código de Cliente
								   _nValorNFS,; // Valor Total
								   _cCC      ,; // Centro de Custo
								   _cProc    ,; // Processo
								   _cObs     ,; // Observação
								   _cTipo    ,; // Tipo
								   _cTipoDoc ,; // Tipo de Documento
								   _cDataTran,; // Data da Transação
								   ""        ,; // 
								   IIF(_cProd='5101',_cCodSiga,"") ,; // // Código do Produto no Microsiga
								   _nVrUnitNFS ,; // Valor Unitário
								               ,; // Quantidade
								   _nValorNFS  ,; // Valor Total
								   _cDescNFS   }) // 15 - Descrição do Prod.
					EndIf
				Else // NFT 
					// Descrição do Produto
					_cDescNFT  +=  AllTrim(SubStr(ISY->LINHA,638,35)) + ", "
									
					_aNFT := { cFil      ,;	// 01 - Filial
							   _cCodCli  ,; // 02 - Código de Cliente
							   _nValorNFT,; // 03 - Valor Total
							   _cCC      ,; // 04 - Centro de Custo
							   _cProc    ,; // 05 - Processo
							   _cObs     ,; // 06 - Observação
							   _cTipo    ,; // 07 -Tipo
							   _cTipoDoc ,; // 08 - Tipo de Documento
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
			If _lError
				_lError := .F.
			
				// Gravo o arquivo de LOG
				_lError  := .F.
				If Rat(".",aFilesLegs[nX,1]) > 0 
					cArqLog  := SubStr(aFilesLegs[nX,1],1,Rat(".",aFilesLegs[nX,1])-1)+".LOG"
				Else
					cArqLog  := AllTrim(aFilesLegs[nX,1])+".LOG"
				EndIf						
				MemoWrit(cPath + "Errata\" + cArqLog, cLog)
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
					_aNFS[x,15] := ""  // Limpra vetor temporariamente.
					
					    		
					// Se não houver os código "5100 e 5101", então fixo o código "06637"
			       	If Empty(_aNFS[x,11])
			       		_aNFS[x,11] = "06637"
		       		EndIf
		       		
					cQry := "INSERT INTO CABEC_PRESTACAO (FILIAL, IDSEQ, CODSISTEMA, CODCLIENTE, VALOR, CCUSTO, PROCESSO, OBS, TIPO, TIPODOC, DATAP, CONTAPSA, CCUSTOPSA, OIPSA) "
					cQry += "	VALUES ('" + _aNFS[x,01] + "','" + _cIdSeq + "','" + _cCodSis + "','" + _aNFS[x,02] + "','" +;
								   Str(_aNFS[x,03]) + "','" + _aNFS[x,04] + "','" + _aNFS[x,05] + "','" + SubStr(_aNFS[x,15],1,Len(_aNFS[x,15])-2) + "','" +;
								   _aNFS[x,07] + "','" + _aNFS[x,08] + "'," + _aNFS[x,09] + ",'','','' ) "
		
					cQry += "INSERT INTO ITENS_PRESTACAO (FILIAL, IDSEQ, ITEM, CODSISTEMA, CODCLIENTE, PRODUTO, VLRUNIT, QTD, VLRTOTAL, ISY_CHAVE ) "
					cQry += "	VALUES ('" + _aNFS[x,01] + "','" + _cIdSeq + "','" + _cItem + "','" + _cCodSis + "','" + _aNFS[x,02] + "','" +;
								   _aNFS[x,11] + "','" + Str(_aNFS[x,14]) + "','" + Str(_nQuant) + "','" + Str(_aNFS[x,14]) + "','" + _cChaveIsy + "' ) " 
	
					If TcSQLExec(cQry) < 0
						Alert(TcSqlError())
					EndIf
				Next x	
			EndIf

            If Len(_aNFT) > 0
		       	If Empty(_aNFT[11])
		       		_aNFT[11] = "00220002"
	       		EndIf	            
				_cIdSeq   := fPegaSeq()
				_cItem    := "01"      
				
				_aNFT[15] := ""  // Limpra vetor temporariamente.				
				
				cQry := "INSERT INTO CABEC_PRESTACAO (FILIAL, IDSEQ, CODSISTEMA, CODCLIENTE, VALOR, CCUSTO, PROCESSO, OBS, TIPO, TIPODOC, DATAP, CONTAPSA, CCUSTOPSA, OIPSA) "
				cQry += "	VALUES ('" + _aNFT[01] + "','" + _cIdSeq + "','" + _cCodSis + "','" + _aNFT[02] + "','" +;
							   Str(_aNFT[03]) + "','" + _aNFT[04] + "','" + _aNFT[05] + "','" + SubStr(_aNFT[15],1,Len(_aNFT[15])-2) + "','" +;
							   _aNFT[07] + "','" + _aNFT[08] + "'," + _aNFT[09] + ",'','','' ) "
							   
				cQry += "INSERT INTO ITENS_PRESTACAO (FILIAL, IDSEQ, ITEM, CODSISTEMA, CODCLIENTE, PRODUTO, VLRUNIT, QTD, VLRTOTAL, ISY_CHAVE ) "
				cQry += "	VALUES ('" + _aNFT[01] + "','" + _cIdSeq + "','" + _cItem + "','" + _cCodSis + "','" + _aNFT[02] + "','" +;
							   _aNFT[11] + "','" + Str(_aNFT[14]) + "','" + Str(_nQuant) + "','" + Str(_aNFT[14]) + "','" + _cChaveIsy + "' ) " 
							   
				If TcSQLExec(cQry) < 0
					Alert(TcSqlError())
				EndIf
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
			_cDesNFS312:= ""

			_aNFS := {}
			_aNFT := {}
		End
		If _lErrorLog
			_lErrorLog := .F.
			
			// Gravo o arquivo de LOG
			If Rat(".",aFilesLegs[nX,1]) > 0 
				cArqLog  := SubStr(aFilesLegs[nX,1],1,Rat(".",aFilesLegs[nX,1])-1)+".LOG"
			Else
				cArqLog  := AllTrim(aFilesLegs[nX,1])+".LOG"
			EndIf
			MemoWrit(cPath +"Errata\" + cArqLog, cLog)
		EndIf		
	Else
		cFilNaoP+="Filial: ("+cFil+")-"+cFilRMA+" nao importado."+chr(10)
	EndIf	

	// Apago os dados do arquivo temporário
	dbSelectArea("ISY")
	ZAP
	
	// Move o arquivo TXT para uma pasta de Backup
	If Empty(cFilNaoP)
   		__CopyFile(cPath + aFilesLegs[nX,1], cPath + "Backup\" +  aFilesLegs[nX,1])
   		Ferase( cPath + aFilesLegs[nX,1] )
    EndIf
Next nX	

If !Empty(cFilNaoP)
	APMsgAlert("Relação de filiais não importadas por não pertencerem a filial("+cFilAnt+"):"+chr(10)+cFilNaoP)
EndIf      
                   
// Copia os arquivos de House para a paste de backup
If Empty(cFilNaoP)
	For nX:=1 To Len(aFilesHouse)
		__CopyFile(cPath + aFilesHouse[nX,1], cPath + "Backup\" +  aFilesHouse[nX,1])
		Ferase( cPath + aFilesHouse[nX,1] )
	Next nX
EndIf

// Copia os arquivos de Master para a paste de backup
If Empty(cFilNaoP)
	For nX:=1 To Len(aFilesMaster)
		__CopyFile(cPath + aFilesMaster[nX,1], cPath + "Backup\" +  aFilesMaster[nX,1])
		Ferase( cPath + aFilesMaster[nX,1] )
	Next nX
EndIf

// Apago o arquivo temporário usado
FERASE(cNomArq+".DBF")

// Apago o arquivo de House temporário usado
FERASE(cArqHouse+".DBF")
FERASE(cIndHouse+OrdBagExt())

If File(cPath+"Errata\"+cArqLog)
	APMsgAlert("Arquivo foi importado porém com errata de alguns registros."+Chr(13)+"Favor consultar o arquivo de errata(LOG) na pasta "+cPath+"Errata\")
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
		_c10DigCC := SubStr(CTT->CTT_CCUSTO,1,10)
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
