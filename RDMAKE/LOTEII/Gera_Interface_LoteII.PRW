#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"

/*
*----------------------------------------------------------------------------*
* Criado por  : Jesus Oliveira       -          Em: 01/03/2010               *
* Objetivo    : Integração dos títulos da GEFCO com o SAP da PSA pelo Lote II*
*----------------------------------------------------------------------------*
*/

User Function GEFLT2(pMenu)

  if (pMenu = nil)
  	//Abre o processo para exibir em uma tela temporária o progress bar
	If MsgYesNo("Esta rotina é destina a gerar a interface Lote I.  Confirma a EXECUÇÃO ?")
  		Processa( {|lEnd| GerarTXT(@lEnd,pMenu)}, "Aguarde...","Gerando arquivo Lote II.", .T. )
  	EndIf
  else

    //Mensagem de alerta no console para execução da rotina em schedule
	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT	EMPRESA "01" FILIAL "01" TABLES "SF1", "SD1", "SF2", "SD2", "SA1", "SM0", "SE1", "SE1", "SX6"

    ConOut("Iniciado geração do arquivo Lote II - "+dtos(dDatabase)+substr(Time(),1,2)+substr(Time(),4,2)+substr(Time(),7,2))

  	GerarTXT(pMenu)
	RpcClearEnv()	// Libera o Environment
  endif

Return

Static Function GerarTXT(pMenu)
Local _nValorCTRC := 0.00
Local _cMailTo    := GETMV("MV_MAILLT2")
Local _cArquivo	  := ""
Local _aFilADHOC  := Array(21)

  Private cArqTxt := GETMV("MV_CAMLT2")
  Private nHdl    := 0
  Private cEOL    := "CHR(13)+CHR(10)"
  private sNumLote := GETMV("MV_NLOTE2")
  private iNumLote := 0
  private sNumSeq := GETMV("MV_SEQLT2")
  private iNumSeq := 0
  private iCod := 0
  private sPeso := ""
  private sCNPJ := ""
  private sNFs := ""

// Preencho com a filial ADHOC
/*
_aFilADHOC[01] := 4 // Sede
_aFilADHOC[02] := 0 // Beneditinos
_aFilADHOC[03] := 3 // Porto Real
_aFilADHOC[04] := 2 // Barueri
_aFilADHOC[05] := 0 // Pavuna
_aFilADHOC[06] := 1 // Vila Guilherme
_aFilADHOC[07] := 6 // SJP
_aFilADHOC[08] := 7 // Campinas
_aFilADHOC[09] := 0 // Contagem
_aFilADHOC[10] := 13// Sepetiba
_aFilADHOC[11] := 14 // Vila Olímpia
_aFilADHOC[12] := 0  // Santos
_aFilADHOC[13] := 4  // RB45
_aFilADHOC[14] := 0  // Sete Lagoas
_aFilADHOC[15] := 0  // Serra
_aFilADHOC[16] := 0  // Nova Pavuna
_aFilADHOC[17] := 0  // Caçapava
_aFilADHOC[18] := 0  // Porto do Rio
*/

// Preencho com a filial ADHOC
_aFilADHOC[01] := 5 // Sede
_aFilADHOC[02] := 4 // Beneditinos
_aFilADHOC[03] := 3 // Porto Real
_aFilADHOC[04] := 2 // Barueri
_aFilADHOC[05] := 0 // Pavuna
_aFilADHOC[06] := 1 // Vila Guilherme
_aFilADHOC[07] := 6 // SJP
_aFilADHOC[08] := 7 // Campinas
_aFilADHOC[09] := 10 // Contagem
_aFilADHOC[10] := 13// Sepetiba
_aFilADHOC[11] := 14 // Vila Olímpia
_aFilADHOC[12] := 15  // Santos
_aFilADHOC[13] := 4  // RB45
_aFilADHOC[14] := 16  // Sete Lagoas
_aFilADHOC[15] := 17  // Serra
_aFilADHOC[16] := 12 // Nova Pavuna
_aFilADHOC[17] := 18  // Caçapava
_aFilADHOC[18] := 4  // Porto do Rio


/*
// Só será executado o Schedule se não for Sábado/Domingo e Feriados Nacionais
	If dDataBase <> DataValida(dDataBase)
	   	ConOut("Lote II - Sábado/domingo/feriado - rotina abandonada.")
		Return
	EndIf
*/

  // QUERY PARA CONTAR OS REGISTROS
  _CQRY := "SELECT   "
  _CQRY += " count(NUMERO) as QTDE "
  _CQRY += "from "
  _CQRY += " INTERFACE_LOTEII_SF2 "

  TCQUERY _CQRY ALIAS "TINTCnt" NEW

  DBSELECTAREA("TINTCnt") ; DBGOTOP()
  nCnt := TINTCnt->QTDE
  DBSELECTAREA("TINTCnt") ; DBCloseArea()

  // QUERY PARA PEGAR AS FATURAS NA SE1
  _CQRY := "select "
  _CQRY += " * "
  _CQRY += "from "
  _CQRY += " INTERFACE_LOTEII_SF2  "

  TCQUERY _CQRY ALIAS "TLOTEII" NEW

  DBSELECTAREA("TLOTEII") ; DBGOTOP()

  // Verifico se há registro para ser envia no arquivo
  If TLOTEII->(Eof())
	if (pMenu = nil)
		MsgAlert("Não há registros a serem enviados à PSA.","Atencao!")
		TLOTEII->(dbCloseArea())
  	    Return
	else
		ConOut("Não há registros a serem enviados à PSA.")
		TLOTEII->(dbCloseArea())
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

  //Atualiza o número lote
  iNumLote := Val(sNumLote)
  iNumLote := iNumLote+1
  sNumLote := Ltrim(Rtrim(str(iNumLote)))
  //Atualiza o número da sequencia SAP
  iNumSeq := Val(sNumSeq)
  iNumSeq := iNumSeq+1
  sNumSeq := Ltrim(Rtrim(str(iNumSeq)))

	//Cria o arquivo TXT no diretório selecionado
	_cArquivo := cArqTxt+"\evdfiA1_"+sNumLote+"_"+dtos(dDatabase)+".dat"
	//nHdl := fCreate(cArqTxt+"\evdfiA1_"+sNumLote+"_"+dtos(dDatabase)+".dat")
	nHdl := fCreate(_cArquivo)

	//Se a função for chamada pelo menu exibe caixas de mensagens, caso contrário, grava apenas no LOG
	if (pMenu = nil)
		If nHdl == -1
			MsgAlert("O arquivo de nome evdfiA1_"+sNumLote+"_"+dtos(dDatabase)+".dat nao pode ser criado! Verifique os parametros.","Atencao!")
		  Return
		Endif
	else
		If nHdl == -1
			ConOut("O arquivo de nome evdfiA1_"+sNumLote+"_"+dtos(dDatabase)+".dat nao pode ser criado! Verifique os parametros.")
		  Return
		Endif
	endif

	//Se a função for chamada pelo menu exibe caixas de mensagens, caso contrário, grava apenas no LOG

	if (pMenu = nil)
		//Barra de progresso
		ProcRegua(nCnt)
	endif

  //Faço a gravação do cabeçalho do arquivo
  ConOut("Gravando Cabeçalho do Lote II.")

  cLin := "00"
  cLin += SubStr(dtos(dDatabase),7,2)+SubStr(dtos(dDatabase),5,2)+SubStr(dtos(dDatabase),1,4)
  cLin += substr(Time(),1,2)+substr(Time(),4,2)+substr(Time(),7,2)
  cLin += StrZero(iNumLote,10)
  cLin += "X"
  cLin += Substr(dtos(dDatabase),1,6)+StrZero(iNumSeq,5)
  cLin := RTrim(cLin) + Space(222)
  cLin += cEOL
  //Se a função for chamada pelo menu exibo as mensagens, caso contrário, gravo no LOG
	if (pMenu = nil)
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			MsgAlert("Ocorreu um erro na gravacao do lote - "+sNumLote,"Atencao!")
  	  Return
		Endif
	else
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do lote - "+sNumLote)
			Return
		Endif
	endif

	// QUERY PARA PEGAR AS FATURAS NA SE1
/*
	_CQRY := "select "
	_CQRY += " * "
	_CQRY += "from "
	_CQRY += " INTERFACE_LOTEII  "

	TCQUERY _CQRY ALIAS "TLOTEII" NEW
*/
	DBSELECTAREA("TLOTEII") ; DBGOTOP()
	iCod := 0

	conout("Início do Loop de processamento do Lote II. - Total de Registro: " + StrZero(nCnt,10))

	WHILE !TLOTEII->(EOF())

	  if (pMenu = nil)
		  //Barra de progresso
		  IncProc()
	  endif

	  //Verifico se o CNPJ da filial existe na tabela SZX, caso não, vai retornar vazio e gravo uma errata para o título
	  if (TLOTEII->CNPJ_EMITENTE != '0000000000000000').and.(TLOTEII->CNPJ_EMITENTE != nil)
		  //Faz as validações necessárias para os títulos que estão sendgo exportados
		 if U_GEFVALLT2( TLOTEII->NUMERO_SE1				,;
		                   TLOTEII->FILIAL					,;
		                   TLOTEII->PREFIXO					,;
		                   RTrim(TLOTEII->CCPSA)			,;
		                   RTrim(TLOTEII->CONTAPSA)			,;
		                   RTrim(TLOTEII->ORDEMINTERNAPSA)	,;
		                   RTrim(TLOTEII->ORDEMINTERNAPSA)	,;
		                   RTrim(TLOTEII->TIPO_DESPESA)		,;
		                   RTrim(TLOTEII->PROCESSO_RMA)		,;
		                   TLOTEII->NFE               		,;
		                   TLOTEII->F2_ESPECIE             	,;
		                   RTrim(TLOTEII->CHVCTE)           ) // Se for RPS, carrega o número da NF-e

			// Temporário - somente para gerar o arquivo do dia informado
			If CTOD(SubStr(Trim(TLOTEII->DATAEMISSAO),1,2) + "/" + SubStr(Trim(TLOTEII->DATAEMISSAO),3,2) + "/" + SubStr(Trim(TLOTEII->DATAEMISSAO),5,4)) > (dDataBase-1)
//			If AllTrim(TLOTEII->DATAEMISSAO) > "21042011"
				DBSELECTAREA("TLOTEII")
				DBSKIP()
				LOOP
			EndIf

		    //Faço a gravação do registro no arquivo
		    cLin := AllTrim(TLOTEII->TIPO_REGISTRO)
		    cLin += IIF(AllTrim(TLOTEII->SERIE)=="5","CE",AllTrim(TLOTEII->TIPO)) // Em virtude da entrada do CT-e - 12-07-2013
		    cLin += Trim(TLOTEII->NUMERO)
		    //Por: Ricardo - Em: 25/08/2010 - A filia de Curitiba precisa enviar para PSA a série U em vez de UNI
		    cLin += IIF(TLOTEII->FILIAL=="07" .AND. TLOTEII->SERIE=="UNI","U  ",TLOTEII->SERIE)
		    cLin += Trim(TLOTEII->CNPJ_EMITENTE)
		    cLin += TLOTEII->TIPO_OPERACAO
		    cLin += Trim(TLOTEII->DATAEMISSAO)
		    cLin += Trim(TLOTEII->VENCIMENTOREAL)
		    cLin += TLOTEII->TIPO_DESPESA
		    cLin += Trim(TLOTEII->DESTINO_DESPESA)
		    cLin += TLOTEII->PROCESSO_RMA
		    cLin += Trim(TLOTEII->FLAG_IRRF)
		    cLin += Trim(TLOTEII->VALOR)
		    cLin += Trim(TLOTEII->BASEICMS)
		    cLin += Trim(TLOTEII->ALIQICMS)
		    cLin += Trim(TLOTEII->VALORICMS)

		    _cNFCTRCTLA := "00000000000000000000"

		    //Executo a função que irá buscar as NFs e o peso caso o DOC seja CTRC
		    _cEmis:= ""
  			iCod2 := 1
  			sCNPJ := "0000000000000000"
  			sPeso := "000000000000000"
  			sNFs := ""

			// Com base no CC, pego o prefixo do CT-e

			_cPrefixo := IIF(AllTrim(TLOTEII->SERIE)=="9","RPS",PADR(AllTrim(TLOTEII->PREFIXO),03))

			If AllTrim(TLOTEII->TIPO) = "CT" // CT-e
  				_cPrefixo := U_fPrefixo(TLOTEII->FILIAL, TLOTEII->CENTROCUSTO)
  			EndIf

		    if (Trim(TLOTEII->TIPO) = "CT") .AND. !(_cPrefixo $ "CTV|CTA|CTE")
					// Função que busca as NFs dos CTRCs
					// CONOUT("Processando Notas da Filial " + TLOTEII->FILIAL)
					// 20012011
					_cEmis := CTOD(SubStr(TLOTEII->DATAEMISSAO,1,2)+"/"+SubStr(TLOTEII->DATAEMISSAO,3,2)+"/"+SubStr(TLOTEII->DATAEMISSAO,7,2))
					If TLOTEII->FILIAL $ "01|10|11|03|04|06|07|08|14|19|20|21|22|23|24|25|26|27|28|29|30"
						// CONOUT("TMS")
						// If TLOTEII->FILIAL == "03" .AND. SubStr(Trim(TLOTEII->DATAEMISSAO),3,6) < "062010" // Porto Real iniciou em 01/07/2010
						If TLOTEII->FILIAL == "03" .AND. _cEmis < CTOD("01/06/10") // Porto Real iniciou em 01/07/2010
							_CQRY := " select * from BuscarNF_ADHOC_LoteII where Filial = '"+StrZero(_aFilADHOC[Val(TLOTEII->FILIAL)],02) +"' and CTRC = '"+Trim(TLOTEII->NUMERO_SE1)+"' "
						// ElseIf TLOTEII->FILIAL == "07" .AND. SubStr(Trim(TLOTEII->DATAEMISSAO),3,6) < "082010" // Porto Real iniciou em 01/07/2010
						ElseIf TLOTEII->FILIAL == "07" .AND. _cEmis < CTOD("01/08/10") // Porto Real iniciou em 01/07/2010
							_CQRY := " select * from BuscarNF_ADHOC_LoteII where Filial = '"+StrZero(_aFilADHOC[Val(TLOTEII->FILIAL)],02) +"' and CTRC = '"+Trim(TLOTEII->NUMERO_SE1)+"' "
						// ElseIf TLOTEII->FILIAL == "04" .AND. SubStr(Trim(TLOTEII->DATAEMISSAO),3,6) < "102010" // Barueri iniciou em 04/10/2010
						ElseIf TLOTEII->FILIAL == "04" .AND.  _cEmis < CTOD("01/10/10") // Barueri iniciou em 04/10/2010
							_CQRY := " select * from BuscarNF_ADHOC_LoteII where Filial = '"+StrZero(_aFilADHOC[Val(TLOTEII->FILIAL)],02) +"' and CTRC = '"+Trim(TLOTEII->NUMERO_SE1)+"' "
						Else
							_CQRY := " select * from BuscarNF_TMS_LoteII where Filial = '"+Trim(TLOTEII->FILIAL)+"' and CTRC = '"+Trim(TLOTEII->NUMERO_SE1) + "' and SERIE = '"+Trim(TLOTEII->SERIE) + "' "
						EndIf
					Else
						// CONOUT("ADHOC " + StrZero(_aFilADHOC[Val(TLOTEII->FILIAL)],2) + " TITULO : " + Trim(TLOTEII->NUMERO_SE1))
						// _CQRY := " select * from BuscarNF_ADHOC_LoteII where Filial = '"+StrZero(_aFilADHOC[Val(TLOTEII->FILIAL)],02) +"' and CTRC = '"+Trim(TLOTEII->NUMERO_SE1)+"' "
						_CQRY := " select * from BuscarNF_TMS_LoteII where Filial = '"+Trim(TLOTEII->FILIAL)+"' and CTRC = '"+Trim(TLOTEII->NUMERO_SE1) + "' and SERIE = '"+Trim(TLOTEII->SERIE) + "' "
					EndIf

					TCQUERY _CQRY ALIAS "TNFs" NEW
					DBSELECTAREA("TNFs") ; DBGOTOP()

					WHILE !EOF()
				    	//Limitado a QTDE de 10 NFs por registro
		  			    if iCod2 <= 10
					      sNFs := sNFs + TNFs->NotaFiscal
					    endif
  						sCNPJ := TNFs->CNPJ
				    	sPeso := TNFs->SOMA_PESO

						DBSELECTAREA("TNFs") ; DBSKIP()
				    	iCod2 := iCod2 + 1
					END
				  DBSELECTAREA("TNFs") ; DBCloseArea()
		    Else
		    	// Por: Ricardo Guimarães - Em: 21/03/2011
		    	// Para atender necessidade da PSA de enviar NF de CTRC do TLA

		    	If Select("TNFs") > 0
		    		dbSelectArea("TNFs") ; dbCloseArea()
		    	EndIf

				CONOUT("Processando Notas do TLA da Filial " + TLOTEII->FILIAL)
/*
		    	_cQry := "SELECT Z5_FILIAL, Z5_SERIE, Z5_NUM, Z5_DTNOTA, Z5_CGCREM, Z5_VALOR, Z5_CTRC, Z5_SERCTR "
				_cQry += "  FROM " + RetSqlName("SZ5") + " SZ5 "
				_cQry += " WHERE Z5_FILIAL = '" + TLOTEII->FILIAL + "' "
				_cQry += "   AND Z5_CTRC   = '" + AllTrim(TLOTEII->NUMERO_SE1) + "' "
				_cQry += "   AND Z5_SERCTR = '" + AllTrim(TLOTEII->SERIE) + "' "
				_cQry += " ORDER BY Z5_DTNOTA DESC "
*/
		    	_cQry := "SELECT DTC_FILORI, DTC_SERNFC, DTC_NUMNFC, DTC_EMINFC, DTC_CLIREM, DTC_LOJREM, DTC_VALOR, DTC_DOC, DTC_SERIE "
				_cQry += "  FROM " + RetSqlName("DTC") + " DTC "
				_cQry += " WHERE DTC_FILORI = '" + TLOTEII->FILIAL + "' "
				_cQry += "   AND DTC_DOC    = '" + AllTrim(TLOTEII->NUMERO_SE1) + "' "
				_cQry += "   AND DTC_SERIE  = '" + AllTrim(TLOTEII->SERIE) + "' "
				_cQry += " ORDER BY DTC_EMINFC DESC "

				TCQUERY _cQry ALIAS "TNFs" NEW
				dbSelectArea("TNFs") ; dbGoTop()

				If !TNFs->(Eof())
					_cSerie := PadR(iif(Val(TNFs->DTC_SERNFC) > 0, AllTrim(Str(Val(TNFs->DTC_SERNFC),3)), "0  "),3)
					// Por: Ricardo - Em:25/10/12 - Solicitado por Lydia S Barbosa da PSA
		    	   // _cNFCTRCTLA := PadR(TNFs->Z5_NUM,9) + _cSerie + SubStr(TNFs->Z5_DTNOTA,7,2) + SubStr(TNFs->Z5_DTNOTA,5,2) + SubStr(TNFs->Z5_DTNOTA,1,4)
		    	   _cNFCTRCTLA := PadR(VAL(TNFs->DTC_NUMNFC),9) + _cSerie + SubStr(TNFs->DTC_EMINFC,7,2) + SubStr(TNFs->DTC_EMINFC,5,2) + SubStr(TNFs->DTC_EMINFC,1,4)
				EndIf
				TNFs->(dbCloseArea())

				dbSelectArea("TLOTEII")

		    endif
			/* Fim da função que busca as NFs dos CTRCs */

			//Limitado a QTDE de 10 NFs por registro, mas se estiver menos, completa com zeros
			For i:=iCod2 to 10
				sNFs := sNFs + "000000000"
			Next i

		    cLin += sPeso
		    cLin += sPeso
		    cLin += TLOTEII->TIPOUNIDADE
		    cLin += TLOTEII->MEIODETRANSPORTE
		    cLin += "000000000000000" // Seria o Valor do Frete, mas no sistema antigo está zero no codigo fonte
		    cLin += Trim(TLOTEII->VALOR_SEGURO)
		    cLin += Trim(TLOTEII->OUTRAS_DESPESAS)
		    cLin += TLOTEII->CFOP
		    cLin += TLOTEII->CCPSA
		    cLin += TLOTEII->ORDEMINTERNAPSA
		    cLin += Trim(TLOTEII->SERVICO)
		    cLin += Trim(TLOTEII->BENEFICIO_RICMS)
		    cLin += Trim(TLOTEII->ISENCAO_ICMS)
		    cLin += TLOTEII->CONTAPSA
		    cLin += sCNPJ
		    cLin += sNFs // Hoje só vai até 10 Notas Fiscais, por limitação do Layout do Arquivo

		    /*****************************************************************/
		    /* Por: Ricardo - Em: 23/08/11 - Atendendo solicitação da PSA    */
		    /*****************************************************************/
		    // _cPrefixo := TLOTEII->PREFIXO
		    // Tratamento para o TLA
		    // If TLOTEII->PREFIXO == "CTA" .or. TLOTEII->PREFIXO == "CTV"
		    If _cPrefixo $ "CTA|CTV"
		    	// dbSelectArea("SZR") ; dbSetOrder(1) // Filial + Documento + Tipo Doc + Cliente
		    	// Por: Ricardo - Em: 08/11/12
		    	dbSelectArea("DT6") ; dbSetOrder(1) // Filial + Filial Doc + Documento + Serie

		    	If TLOTEII->FILIAL == "18" // Porto do Rio
		    		// Tratamento para DTA - Transferência de Veiculo entre Porto do Rio e EADI

		    		// (SZR) If dbSeek(TLOTEII->FILIAL + TLOTEII->NUMERO_SE1 + TLOTEII->PREFIXO) // + RIGHT(TLOTEII->CNPJ_EMITENTE,14)
		    		If dbSeek(xFilial("DT6") + TLOTEII->FILIAL + TLOTEII->NUMERO_SE1 + TLOTEII->SERIE)
		    	   		// If SZR->ZR_CDDEST = "03214786000138" // TERMINAL LOGISTICO DO VALE DO PARAIBA LT
		    	   		If POSICIONE("SA1",1,xFilial("SA1") + DT6->DT6_CLIDES + DT6->DT6_LOJDES, "A1_CGC") = "03214786000138" // TERMINAL LOGISTICO DO VALE DO PARAIBA LT
							_cPrefixo := "DTA"
						EndIf
					EndIf
					// Por: Ricardo - Em: 15/01/2013 - Tratamento DTA
		    	ElseIf TLOTEII->FILIAL == "17" // Caçapava
		    		// Tratamento para DTA - Transferência de Veiculo entre EADI Resende -> Santos -> São Sebastião

		    		If dbSeek(xFilial("DT6") + TLOTEII->FILIAL + TLOTEII->NUMERO_SE1 + TLOTEII->SERIE)
		    	   		If   DT6->DT6_CLIDES  + DT6->DT6_LOJDES = "00441901" .AND. ;  // TERMINAL LOGISTICO DO VALE DO PARAIBA LT
						   ( DT6->DT6_CLIREM + DT6->DT6_LOJREM = "15873500" .OR.  ;  // Companhia DOCAS DE SÃO SEBASTIÃO
						     DT6->DT6_CLIREM + DT6->DT6_LOJREM = "01014400" ) 	      // DEICMAR S/A
								_cPrefixo := "DTA"
						EndIf
					EndIf

		    	EndIf

		    	If TLOTEII->FILIAL <> "18"

		    		// Tratamento para RET -
		    		If dbSeek(xFilial("DT6") + TLOTEII->FILIAL + TLOTEII->NUMERO_SE1 + TLOTEII->SERIE)
		    		  /*
		    	   		If POSICIONE("SA1",1,xFilial("SA1") + DT6->DT6_CLIDES + DT6->DT6_LOJDES, "A1_GRUPO") <> "5" // Grupo PSA
							_cPrefixo := "RET"
						EndIf
					  */
		    	   		If POSICIONE("SA1",1,xFilial("SA1") + DT6->DT6_CLIREM + DT6->DT6_LOJREM, "A1_GRUPO") <> "5" // Grupo PSA
							_cPrefixo := "RET"
						EndIf
					EndIf
				EndIf
			Else
		    // Tratamento para o OVL
				dbSelectArea("DTC") ; dbSetOrder(3) // DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE+DTC_SERVIC+DTC_CODPRO

				// Prefixo PRE -> Peças de Reposição
		    	If TLOTEII->FILIAL == "04" .AND. AllTrim(TLOTEII->TIPO) = "CT"
		    		_cPrefixo := "PRE"
		    	Else
   					// Prefixo EMB -> Embalagem
   					If TLOTEII->FILIAL == "03" .AND. AllTrim(TLOTEII->TIPO) = "CT"
			    		If dbSeek(xFilial("DTC")+TLOTEII->FILIAL+TLOTEII->NUMERO_SE1+TLOTEII->SERIE)
			    			If AllTrim(DTC->DTC_CODPRO) = "EMBALAGEM"
			    				_cPrefixo := "EMB"
			    			EndIf
			    		EndIf
			    	EndIf
		    	EndIf

		    EndIf

			// Por: Ricardo Guimarães - Em: 03/11/2014 - Tratar CT-e de Complemento
			dbSelectArea("DT6") ; dbSetOrder(1) // Filial + Filial Doc + Documento + Serie
			If DT6->(dbSeek(xFilial("DT6") + TLOTEII->FILIAL + TLOTEII->NUMERO_SE1 + TLOTEII->SERIE))
     			If (Trim(TLOTEII->TIPO) = "CT")  .AND. DT6->DT6_DOCTMS="8"  // CAMPO QUE INDICA CT-e DE COMPLEMENTO
         		_cPrefixo := "COM"
     			EndIf
			EndIf

			dbSelectArea("TLOTEII")

		    // cLin += TLOTEII->PREFIXO
		    cLin += _cPrefixo
		    cLin += Trim(TLOTEII->RECNO_E1)
		    //A despesa só é preenchida para a Expotação
		    if (Trim(TLOTEII->TIPO_DESPESA) = "E")
		    	cLin += Trim(TLOTEII->DESPESA)
		    else
		    	cLin += "000"
		    endif

			// Em: 21/03/2011 - Acrescentado para atender PSA
			cLin += _cNFCTRCTLA

		    //Caracter para indicar fim de linha
		    cLin := RTrim(cLin)
		    cLin += cEOL

		    // Acumulo o valor do CTRC
		    _nValorCTRC += (Val(TLOTEII->VALOR)/100)

			// Conta Registro
			iCod++

			//Se a função for chamada pelo menu exibo as mensagens, caso contrário, gravo no LOG
			if (pMenu = nil)
				//Gravar linha no arquivo TXT
				If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
					If !MsgAlert("Ocorreu um erro na gravacao do lote - "+sNumLote,"Atencao!")
					  Return
				  	Endif
				Endif

				//Incrementa a barra de progressão
				IncProc("Gravando linha: "+Ltrim(Rtrim(str(iCod))))
			else
				//Gravar linha no arquivo TXT
				If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
					ConOut("Ocorreu um erro na gravacao do lote - "+sNumLote)
 					Return
				Endif
			endif

			//Gravo o resultado na SZP
			dbSelectArea("SZP")
			dbSetOrder(3) // Chave
			If !dbSeek(TLOTEII->FILIAL+TLOTEII->NUMERO_SE1+TLOTEII->PREFIXO)
				RecLock("SZP",.T.)
		    	SZP->ZP_FILIAL := TLOTEII->FILIAL // Filial do Documento
		    	SZP->ZP_LOTE := sNumLote //Número do Lote sendo gerado
		     	SZP->ZP_DATA := DDATABASE //Data do servidor
		     	SZP->ZP_DOC := TLOTEII->NUMERO_SE1 //Documento
		    	SZP->ZP_PREFIXO := TLOTEII->PREFIXO //Prefixo do documento
			    SZP->ZP_REG := cLin
			    SZP->ZP_ERRATA := ""
				MsUnLock()
				//Caso DOC já exista, atualizo o campo ERRATA
			Else
				RecLock("SZP",.F.)
		    	SZP->ZP_LOTE := sNumLote //Número do Lote sendo gerado
		     	SZP->ZP_DATA := DDATABASE //Data do servidor
			    SZP->ZP_REG := cLin
		    	SZP->ZP_ERRATA := ""
				MsUnLock()
			EndIf

			DbSelectArea("SZP")  // ; dbCloseArea()

			//Gravo o FLAG da SE1
			dbSelectArea("SE1")
			dbSetOrder(1) // Chave
			// Por: Ricardo Guimraes - Em: 03/08/2013
			// O trecho abaixo foi substituído em virtude da entrada do CT-e o Seek passou a identificar registros antigos
/*
			If !dbSeek(TLOTEII->FILIAL+TLOTEII->PREFIXO+TLOTEII->NUMERO_SE1+TLOTEII->PARCELA+TLOTEII->TIPODOC)
			  	ConOut("O título - "+TLOTEII->NUMERO_SE1+" não foi localizado na tabela SE1 para o lote - "+sNumLote)
			Else
				RecLock("SE1",.F.)
		    	SE1->E1_FLGLT2 := sNumLote //Número do Lote sendo gerado
				MsUnLock()
			EndIf
			DbSelectArea("SE1")  // ; dbCloseArea()
*/
			SE1->(dbGoTo(Val(AllTrim(TLOTEII->RECNO_E1))))
			RecLock("SE1",.F.)
		    	SE1->E1_FLGLT2 := sNumLote //Número do Lote sendo gerado
			MsUnLock()
		 endif

	  else
			//Gravo Erratas na SZP
			dbSelectArea("SZP")
			dbSetOrder(3) // Chave
			If !dbSeek(TLOTEII->FILIAL+TLOTEII->NUMERO_SE1+TLOTEII->PREFIXO)
				RecLock("SZP",.T.)
		    	SZP->ZP_FILIAL := TLOTEII->FILIAL // Filial do Documento
		    	SZP->ZP_LOTE := sNumLote //Número do Lote sendo gerado
		     	SZP->ZP_DATA := DDATABASE //Data do servidor
		     	SZP->ZP_DOC := TLOTEII->NUMERO_SE1 //Documento
		    	SZP->ZP_PREFIXO := TLOTEII->PREFIXO //Prefixo do documento
			    SZP->ZP_ERRATA := "O CNPJ desta filial não foi criado na tabela SZX."
				MsUnLock()
		  //Caso DOC já exista, atualizo o campo ERRATA
			Else
				RecLock("SZP",.F.)
		    	SZP->ZP_LOTE := sNumLote //Número do Lote sendo gerado
		     	SZP->ZP_DATA := DDATABASE //Data do servidor
		    	SZP->ZP_ERRATA := "O CNPJ desta filial não foi criado na tabela SZX."
			MsUnLock()
			EndIf
			DbSelectArea("SZP")  ; dbCloseArea()
  	  endif

	  DBSELECTAREA("TLOTEII") ; DBSKIP()

	END
  //Faço a gravação do rodapé do arquivo
  conout("Início do geração do rodapé do Lote II.")
  cLin := "99"
  cLin += StrZero(iCod,10)
  cLin := RTrim(cLin) + Space(248)
  cLin += cEOL
  //Se a função for chamada pelo menu exibo as mensagens, caso contrário, gravo no LOG
	if (pMenu = nil)
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			MsgAlert("Ocorreu um erro na gravacao do lote - "+sNumLote,"Atencao!")
  	  		Return
		Endif
	else
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do lote - "+sNumLote)
			Return
		Endif
	endif

  //Fecha o arquivo TXT criado
  fClose(nHdl)
  DBSELECTAREA("TLOTEII") ; DBCloseArea()

  //Atualizo o número do Lote e, do sequencial SAP, somente se houver títulos
  PUTMV("MV_NLOTE2",sNumLote)

  if iCod > 0
  	PUTMV("MV_SEQLT2",sNumSeq)

  	if (pMenu = nil)
  		MsgInfo("Arquivo gerado com sucesso! Foram exportados "+Ltrim(Rtrim(str(iCod)))+" registros no lote - "+sNumLote, "Informação")

		EmailCapaLote(iCod, _nValorCTRC, sNumLote, sNumSeq, _cMailTo, _cArquivo)
	else
  		ConOut("Arquivo gerado com sucesso! Foram exportados "+Ltrim(Rtrim(str(iCod)))+" registros no lote - "+sNumLote)
    	// Envia do e-mails de erratas

  		// Envia e-mail de capa de Lote
		ConOut("Envio de e-mails de Capa de Lote: " + _cMailTo)
		EmailCapaLote(iCod, _nValorCTRC, sNumLote, sNumSeq, _cMailTo, _cArquivo)

  		ConOut("Início de envio de e-mails de erratas.")
    	U_GEFMAILLT2(.T.)
  		ConOut("Final de envio de e-mails de erratas.")
  	endif
  Else
  	 // Não foi gerado interface para nenhum título
  	if (pMenu = nil)
  		MsgInfo("Não foi gerado interface para nenhum título", "Informação")
	else
  		ConOut("Não foi gerado interface para nenhum título para o Lote: " + sNumLote )
  	endif
  	If File(_cArquivo)
  		fErase(_cArquivo)
  	EndIf
  EndIf
return

*----------------------------------------------------------------------------------------*
Static Function EmailCapaLote(iCod, _nValorCTRC, sNumLote, sNumSeq, _cMailTo, _cArquivo)
*----------------------------------------------------------------------------------------*

	cAssunto := "Exportação Lote II - " + dTOc(dDataBase)
	cAnexo   := _cArquivo
	cCc      := ""
	cPara    := AllTrim(_cMailTo) // GETMV("MV_MAILLT2")
	cDe      := "relatorio@gefco.com.ar"

	cMsg := "<b>Capa do Lote da Interface Lote II: </b>" + "<BR>"
	cMsg += "<BR>"
	cMsg += "<b>Data Geração:</b> " + dTOc(dDataBase)   + "<BR>"
	cMsg += "<b>Lote:</b> " 		+ AllTrim(sNumLote) + "<BR>"
	cMsg += "<b>Seq. Lote:</b> " 	+ AllTrim(sNumSeq)  + "<BR>"
	cMsg += "<b>Qtd. Título:</b> "  + TransForm(iCod,"@E 999,999,999") + "<BR>"
	cMsg += "<b>Valor Total:</b> "	+ Transform(_nValorCTRC,"@E 999,999,999,999.99") + "<BR>"

  	cMsg += "<BR>"
  	cMsg += "<BR>"
	cMsg += "Esta é uma mensagem automática do sistema Protheus. Favor não responder!"

	*---------------------------------------------*
	U_EnvEmail(cDe,cPara,cCc,cAssunto,cMsg,cAnexo)
	*---------------------------------------------*
Return

//USER Function TstEmail(iCod, _nValorCTRC, sNumLote, sNumSeq, _cMailTo, _cArquivo)
//Return EmailCapaLote(iCod, _nValorCTRC, sNumLote, sNumSeq, _cMailTo, _cArquivo)