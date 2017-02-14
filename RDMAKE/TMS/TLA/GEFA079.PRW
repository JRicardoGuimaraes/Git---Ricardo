#INCLUDE "rwmake.ch"  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"   
#INCLUDE "tbiconn.ch"     

/*
*---------------------------------------------------------------------------*
* Função     |GEFA079    | Autor | J Ricardo             | Data | 07.03.12  *
*---------------------------------------------------------------------------*
* Descrição  |Rotina para geração de interface de CTRC´s do TMS para as     *
*            |Transportadora.                                               *
*            |                                                              *
*            |                                                              *
*---------------------------------------------------------------------------*
*/

User Function GEFA079(pMenu)

If (pMenu = nil)
  	//Abre o processo para exibir em uma tela temporária o progress bar
  	If MsgYesNo("Confirma a geração da Interface de CTRCs para as Transportadoras?","Atenção")
	  	Processa( {|lEnd| GerarTXT(@lEnd,pMenu)}, "Aguarde...","Gerando arquivo de CTRCs do TLA emitidos.", .T. )
	EndIf  	
Else
  
    //Mensagem de alerta no console para execução da rotina em schedule
	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT	EMPRESA "01" FILIAL "01" TABLES "SZ8", "SA1", "SA2"

    ConOut("Iniciado geração do arquivo de CTRCs do TLA emitidos - "+dtos(dDatabase)+substr(Time(),1,2)+substr(Time(),4,2)+substr(Time(),7,2)) 
  
  	GerarTXT(pMenu)
	RpcClearEnv()	// Libera o Environment  	
EndIf

Return

*------------------------------------*
Static Function GerarTXT(pMenu)
*------------------------------------*
Local _cArquivo	  := ""
Local _cTranspAnt := ""
Local _cCodTranp  := ""
Local _cData	  := SubStr(dtos(dDatabase),7,2)+"/"+SubStr(dtos(dDatabase),5,2)+"/"+SubStr(dtos(dDatabase),1,4)
Local _cHora	  := StrTran(Time(),":","")
Local _nComFrete  := 0.00
Local _nPedagio	  := 0.00
Local _aComFrete  := {}

Private cArqTxt := AllTrim(GETMV("MV_XTLATRA"))
Private nHdl    := 0 
Private cEOL    := "CHR(13)+CHR(10)"
private _cNumSeq:= ""
private iCod 	:= 0 

If Right(cArqTxt,1) <> "\"
	cArqTxt += "\"
EndIf

// Query para pegar os CTRCS do TLA
  
If Select("TSZ8") > 0
	dbSelectArea("TSZ8") 
	dbCloseArea()
EndIf	

_cQry := " SELECT * FROM " + RetSqlName("SZ8010") + " SZ8 "
_cQry += "  WHERE Z8_DTEMIS >= '20120301' "
_cQry += "    AND Z8_SERSIPC = '' "                      
//_cQry += "    AND Z8_FILIAL  = '" + cFilAnt + "' "
_cQry += " ORDER BY Z8_CNPJTRA, Z8_NUMCTRC, Z8_SERCTRC, Z8_DTEMIS " 
						 
TCQUERY _cQry ALIAS "TSZ8" NEW
	
dbSelectArea("TSZ8") ; dbGoTop()  
    
// Verifco se há registro para ser enviado no arquivo
If TSZ8->(Eof())
	if (pMenu = nil)
		MsgAlert("Não há registros a serem enviados à Transportadoras.","Atencao!")
		TSZ8->(dbCloseArea())
    	Return
	else
		ConOut("Não há registros a serem enviados à Transportadoras.")
		TSZ8->(dbCloseArea())
		Return
	endif  	
EndIf
	
//Variável para fazer a quebra de linha 
If Empty(cEOL)
  	cEOL := CHR(13)+CHR(10)
Else
   	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

dbSelectArea("TSZ8") ; dbGoTop()
conout("Início do Loop de processamento da geração de interface de CTRCs à Transportadoras " )	

While !TSZ8->(Eof())
	// Gero o número sequencia para ser usado no nome do arquivo
	_cNumSeq := Soma1(GETMV("MV_XTLASEQ"))
	PutMV("MV_XTLASEQ",_cNumSeq)
	_cNumSeq := PadL(AllTrim(_cNumSeq),06,"0")

    
	// Código da Transportadora
	_cCodTransp := Right(TSZ8->Z8_CNPJTRA,02)
	
	//Cria o arquivo TXT no diretório selecionado
	_cArquivo := cArqTxt+"NFGEFCO"+_cCodTransp+_cNumSeq+".txt"
	nHdl := fCreate(_cArquivo)
	
	//Se a função for chamada pelo menu exibe caixas de mensagens, caso contrário, grava apenas no LOG
	If (pMenu = nil)
		If nHdl == -1
			MsgAlert("O arquivo de nome "+_cArquivo+" nao pode ser criado! Verifique os parametros.","Atencao!")
			Return
		EndIf
	Else
		If nHdl == -1
			ConOut("O arquivo de nome "+_cArquivo+" nao pode ser criado! Verifique os parametros.")
			Return
		EndIf
	EndIf
		  
	//Faço a gravação do cabeçalho do arquivo
	ConOut("Gravando Cabeçalho da Interface de CTRC do TLA.")
  
	cLin := "0"
	cLin += PadR(_cCodTransp,02)	// Código do Transportadora
	cLin += PadR(_cNumSeq,06) 		// Sequencia de arquivo
	cLin += _cData 					// Data de Envio - 99/99/9999
	cLin += _cHora  				// Hora de Envio hhmmss
	cLin += Space(523)
	cLin += cEOL

	//Se a função for chamada pelo menu exibo as mensagens, caso contrário, gravo no LOG
	If (pMenu = nil)
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			MsgAlert("Ocorreu um erro na gravacao do arquivo - "+_cArquivo,"Atencao!")
		  	Return
		EndIf  	
	Else
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo - "+_cArquivo)
			Return
		EndIf
	EndIf

	_cTranspAnt := TSZ8->Z8_CNPJTRA

	While !TSZ8->(EOF()) .AND. TSZ8->Z8_CNPJTRA == _cTranspAnt
		
		If (pMenu = nil)
			//Barra de progresso
			IncProc(0)
		EndIf
	
	    //Faço a gravação do registro no arquivo
	    cLin := "1"				// Tipo de Registro
	    cLin += PadR(TSZ8->Z8_CNPJORI,14)  		// CNPJ Emitente
	    cLin += PadR(TSZ8->Z8_CNPJDES,14)		// CNPJ Venda
	    cLin += PadR(TSZ8->Z8_CNPJDES,14)		// CNPJ Entrega
	    // Pego dados do cliente de venda
	    dbSelectArea("SA1") ; dbSetOrder(3)
	    SA1->(dbSeek(xFilial("SA1")+AllTrim(TSZ8->Z8_CNPJDES)))
	    cLin += PadR(SA1->A1_NOME,40)			// Nome do Cliente de Venda
	    cLin += PadR(AllTrim(SA1->A1_END) + " - " + AllTrim(SA1->A1_BAIRRO), 66) // Endereço + Bairro do cliente de venda
   	    cLin += PadR(AllTrim(SA1->A1_MUN),35)	// Município do cliente de venda
   	    cLin += PadR(AllTrim(SA1->A1_EST),02)	// Estado do cliente de venda
	    cLin += PadR(TSZ8->Z8_CNPJDES,14)		// CNPJ do cliente de Venda
   	    cLin += PadR(SA1->A1_INSCR,15)			// Inscrição Estadual do cliente de Venda
   	    // Fim de dados cliente de venda
   	    dbSelectArea("TSZ8")
	    cLin += "2"								// Devedor do frete -> 1-Emitente; 2-Cliente Venda; 3-Cliente Entrega
	    cLin += "J"								// J-Pessoa Jurídica; F-Pessoa Física	    
	    cLin += "3"								// Ramo de Atividade -> 1-Transporte; 2-Industria; 3-Comércio; 4-Comunicação; 5-Energia Elétrica; 6-Rural; 
	    // Pego dados da coleta 
		dbSelectArea("SA1") ; dbSetOrder(3)
	    SA1->(dbSeek(xFilial("SA1")+AllTrim(TSZ8->Z8_CNPJORI)))
	    // cLin += PadR(SA1->A1_NOME,40)			// Nome do Cliente de Coleta
	    cLin += PadR(AllTrim(SA1->A1_END) + " - " + AllTrim(SA1->A1_BAIRRO), 66) // Endereço + Bairro do cliente de venda
   	    cLin += PadR(AllTrim(SA1->A1_MUN),35)	// Município do cliente de coleta
   	    cLin += PadR(AllTrim(SA1->A1_EST),02)	// Estado do cliente de venda
	    // Fim dados de coleta
		dbSelectArea("TSZ8")
   	    cLin += SubStr(TSZ8->Z8_NFCLI,1,8)		// Número da NF
   	    cLin += SubStr(TSZ8->Z8_SERIENF,1,2)	// Série da NF
   	    cLin += SubStr(TSZ8->Z8_DATANF,7,2)+"/"+SubStr(TSZ8->Z8_DATANF,5,2)+"/"+SubStr(TSZ8->Z8_DATANF,1,4)	    // Data da NF
   	    //cLin += PADL(StrTran(ALLTRIM(STR(TSZ8->Z8_VALORNF)),".",""),14,"0")	// Valor total da NF
   	    cLin += STRTRAN(ALLTRIM(STRZERO(TSZ8->Z8_VALORNF,15,2)),".","") // Valor total da NF
   	    cLin += PadR(TSZ8->Z8_VIN,17)			// VIN/CHASSI
   	    cLin += Space(08)						// Pedido
   	    cLin += Space(09)						// Código do Item
   	    cLin += PadR(TSZ8->Z8_CODMOD,16)		// Código do Modelo   	    
   	    cLin += PadR(TSZ8->Z8_CODCOR,08)		// Código da Cor
   	    cLin += PadR(TSZ8->Z8_ANOFAB,04)		// Ano de Fabricação
   	    cLin += PadR(TSZ8->Z8_ANOMOD,04)		// Ano do Modelo
   	    cLin += PadR(TSZ8->Z8_PESOVEI,06)		// Peso Veículo
   	    cLin += Space(09)						// Código do Item
   	    cLin += Right(TSZ8->Z8_NUMCTRC,08)		// Número do CTRC
   	    cLin += Left(TSZ8->Z8_SERCTRC,02)		// Série do CTRC
   	    cLin += SubStr(TSZ8->Z8_DTEMIS,7,2)+"/"+SubStr(TSZ8->Z8_DTEMIS,5,2)+"/"+SubStr(TSZ8->Z8_DTEMIS,1,4)	    // Data de Emissão do CTRC
   	    cLin += StrTran(ALLTRIM(STRZERO(TSZ8->Z8_VENDA,15,2)),".","")	// Valor total do CTRC
   	    cLin += PADR(Val(TSZ8->Z8_ORIGEM),02,"0")	// Tipo de Entrada
   	    cLin += PADR(Val(TSZ8->Z8_DESTINO),02,"0")	// Tipo de Venda
   	    cLin += Space(46)							// Espaço reservado
   	    // // Por: Ricardo Guimarães - Em: 26/08/2014 - Objetivo: Inclui CHAVE do CT-e e NF-e
		cLin += PadR(AllTrim(POSICIONE("DT6",1,xFilial("DT6") + TSZ8->Z8_FILIAL + TSZ8->Z8_NUMCTRC + TSZ8->Z8_SERCTRC, "DT6_CHVCTE")),44)
		cLin += PadR(AllTrim(POSICIONE("DTC",1,xFilial("DTC") + TSZ8->Z8_FILIAL + TSZ8->Z8_LOTNFC, "DTC_NFEID")),44)   	    

		// Por: Ricardo Guimarães - Em: 09/10/2014 - Incluir colunas com valor de Compra de Frete e Pedágio
		_aComFrete := fVrComFrete(TSZ8->Z8_FILIAL, TSZ8->Z8_NUMCTRC, TSZ8->Z8_SERCTRC)
		_nComFrete := _aComFrete[1] // Valor da Compra de Frete
		_nPedagio  := _aComFrete[2] // Valor do Pedágio
		
		cLin += StrTran(ALLTRIM(STRZERO(_nComFrete,15,2)),".","")
		cLin += StrTran(ALLTRIM(STRZERO(_nPedagio ,15,2)),".","")

		cLin += cEOL
		
		//Se a função for chamada pelo menu exibo as mensagens, caso contrário, gravo no LOG
		If (pMenu = nil)
			//Gravar linha no arquivo TXT
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do registro da interface de CTRCs do TLA ","Atencao!")
				  Return
			  	Endif
			Endif
			 
			//Incrementa a barra de progressão
			IncProc("Gravando linha: "+Ltrim(Rtrim(str(iCod))))
		Else
			//Gravar linha no arquivo TXT
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				ConOut("Ocorreu um erro na gravacao do registro da interface de CTRCs do TLA ")
				Return
			Endif
		EndIf
	
		//Gravo o FLAG de geração da interfa na tabela SZ8
		dbSelectArea("SZ8")
		dbGoTo(TSZ8->R_E_C_N_O_) // Registro
		RecLock("SZ8",.F.)
	    	SZ8->Z8_SERSIPC := StrTran(DTOC(dDataBase),"/","")
		MsUnLock()
		
		iCod++
	
		dbSelectArea("TSZ8") 
		TSZ8->(dbSkip())
	End

	//Faço a gravação do rodapé do arquivo
	conout("Início do geração do rodapé da interface de CTRCs do TLA.")	
	cLin := "9"
	cLin += PadR(_cCodTransp,02)  	// Código da Transportadora
	cLin += PadR(_cNumSeq,06)     	// Sequencia usado no nome do arquivo
	cLin += Padr(_cData,10)			// Data de Envio
	cLin += Padr(_cHora,06)			// Hora de Envio	
	cLin += PadL(iCod,06,"0")		// Data de Envio	
	cLin += Space(489) + cEOL
	
	//Se a função for chamada pelo menu exibo as mensagens, caso contrário, gravo no LOG
	If (pMenu = nil)
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			MsgAlert("Ocorreu um erro na gravacao da interface CTRCs do TLA ","Atencao!")
	  		Return
		Endif
	Else
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao da interface CTRCs do TLA ")
			Return
		EndIf
	Endif
	
	iCod := 0
	
	//Fecha o arquivo TXT criado
	fClose(nHdl)    
End
	
dbSelectArea("TSZ8") ; dbCloseArea()

Alert("Processo concluído com sucesso!!!")

Return

*----------------------------------------------------------*
Static Function fVrComFrete(_cFilial, _cDoc, _cSerie)
*----------------------------------------------------------*
Local _cProd 	:= ""
Local _cCompCom := ""
Local _cSQL		:= ""
Local _aFrete   := Array(2)
Local _nCompra  := 0.00
Local _nPedagio := 0.00

dbSelectArea("DT8") ; dbSetOrder(2) // Fil.Doc+No.Docto+Série Docto+Produto+Componente
_cProd 		:= PadR(AllTrim(GETMV("MV_XPROTLA")),(TamSX3("DT8_CODPRO")[1]))
_cCompCom 	:= AllTrim(GETMV("MV_XTLACOM"))  // Componentes de compra de frete (CT, I3, TP, I2)
_cSQL		:= ""

_cSQL := " SELECT * FROM " + RetSqlName("DT8") + " DT8 "
_cSQL += "  WHERE DT8_FILIAL = '" + xFilial("DT8")  + "' "
_cSQL += "    AND DT8_FILDOC = '" + _cFilial + "' " 
_cSQL += "    AND DT8_DOC    = '" + _cDoc    + "' "
_cSQL += "    AND DT8_SERIE  = '" + _cSerie  + "' "
_cSQL += "    AND DT8_CODPAS IN " + _cCompCom
	
If Select("TDT8") > 0
	dbSelectArea("TDT8")
	dbCloseArea()
EndIf
	
cQuery := ChangeQuery(_cSQL)
DbUseArea(.T.,"TOPCONN",TCGenQry(,,_cSQL),"TDT8",.T.,.T.)

DbSelectArea("TDT8")
TDT8->(DbGoTop())
	
If !TDT8->(Eof())
	While !TDT8->(Eof())
	
		// Valor da Compra de Frete
		If AllTrim(TDT8->DT8_CODPAS) $ "CT|I3"
			_nCompra += TDT8->DT8_VALPAS
			
		// Valor do pedágio	
		ElseIf AllTrim(TDT8->DT8_CODPAS) $ "TP|I2"
			_nPedagio += TDT8->DT8_VALPAS
		EndIf	
		
		dbSkip()
	End
EndIf
	
TDT8->(dbCloseArea())

_aFrete[1] := _nCompra
_aFrete[2] := _nPedagio

Return _aFrete