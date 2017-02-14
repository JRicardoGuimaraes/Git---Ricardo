#Include 'Protheus.ch'
#INCLUDE "TOPCONN.CH"                                                                                    

//-------------------------------------------------------------------- ----------  
/*/{Protheus.doc} XEDIFIATx()  

Gera EDI de Fatura da FIAT - Para os casos que existe na DTQ e n„o existe na ZA7
// Por: Ricardo Guimar„es - 17/11/2016

@sample XEDITFIATx()  

@return	 Nil  
@author	 Joni Lima  
@since	 12/02/2016  
@version P11  

@comments  
/*/  
//------------------------------------------------------------------------------
User Function XEDIFIATx()
	
	Local cPerg := "EDIFIAT1"

	Private _aDados := {}

	If !fCargaXLS()
		Return Nil
	EndIf
	
	criaSX1(cPerg)

	If Pergunte(cPerg, .T.)

		if empty( MV_PAR12 )
			msgAlert("Informar Data Fatura p/ previsao do pagamento do serviÁo","ValidaÁ„o")
			return nil
		endif

		MV_PAR01 = StrTran(StrTran(StrTran(FormatIn(AllTrim(mv_par01),,2),"'",""),"(",""),")","")
		
		Processa({|| PRCEDI1()})
		
	Else
		
		AVISO('Parametros', 'Problema com parametros "EDIFIAT1", chamar o Administrador do Sistema', { 'OK' }, 1)		
	
	EndIf
	
Return()

//------------------------------------------------------------------------------  
/*/{Protheus.doc} PRCEDI1()  

Gera do EDI

@sample PRCEDI1()

@param   nil
@return	 nil    

@author	 Joni Lima  
@since	 03/03/2016  
@version P11  

@comments  
/*/  
//------------------------------------------------------------------------------
Static Function PRCEDI1()

	Local aDados    := nil
	local oDiat1Edi := nil
	Local oEdi      := nil
	Local lCont     := .T.
	Local nQtdReg   := 0

	oDiat1Edi := CGerEDI():new()
	aDados := ExecQuery()

	nQtdReg   := ScopeCount()

	ProcRegua(nQtdReg + 5)
	IncProc("Iniciando Processamento dos Registro")

	If (Select(aDados) > 0) .And.(nQtdReg > 0)

		IncProc("Verificaco dos Registros")		
		lCont := ValDados(aDados)

		If !lCont
			lCont := (AVISO('Verificar', 'Ja foram Gerados registros para esse renge, Gostaria de refazer esses registros', { 'Sim','Não' }, 1) == 1)
			If lCont
				IncProc("Alterando Log")
				DelChav(aDados)
			EndIf
		EndIf

		If lCont

			IncProc("Processando os Registros")
			oEDI := PreDados(aDados)
			
			IncProc("Gerando Arquivo:")
			oDiat1Edi:SetConteud(oEDI:MontaDad())
			oDiat1Edi:SetCaminho(mv_par11)
			oDiat1Edi:SetArquivo(mv_par10)
			
			oDiat1Edi:GeraArquiv()
			
		EndIf
	EndIf
	
Return

//------------------------------------------------------------------------------  
/*/{Protheus.doc} ValDados()  

Verifica se já foi feito o EDI por registro

@sample ValDados(cQry)

@param   cQry - Area     - Query

@return	 lRet - Booleano - Verifica se já existe    

@author	 Joni Lima  
@since	 01/03/2016  
@version P11  

@comments  
/*/  
//------------------------------------------------------------------------------
Static Function ValDados(cQry)

	Local lRet := .T.
	
	(cQry)->(DbGoTop())
	
	dbSelectArea('ZCT')
	ZCT->(DbSetOrder(2))
	
	While(cQry)->(!EOF())

		If ZCT->(dbSeek(xFilial('ZCT') + (cQry)->(DTQ_FILORI + DTQ_VIAGEM + DTC_LOTNFC + DTC_NUMNFC) ))

			lRet := .F.	
			Exit

		EndIf
		
		(cQry)->(dbSkip())
	
	EndDo
	
Return lRet

//------------------------------------------------------------------------------  
/*/{Protheus.doc} DelChav()  

Deleta os registro da tabela ZCT, conforme localizado pela chave.

@sample DelChav(cQry)

@param   cQry - Area     - Query

@return	 Nil    

@author	 Joni Lima  
@since	 01/03/2016  
@version P11  

@comments  
/*/  
//------------------------------------------------------------------------------
Static Function DelChav(cQry)

	(cQry)->(DbGoTop())
	
	dbSelectArea('ZCT')
	ZCT->(DbSetOrder(2))
	
	While(cQry)->(!EOF())

		If ZCT->(dbSeek(xFilial('ZCT') + (cQry)->(DTQ_FILORI + DTQ_VIAGEM + DTC_LOTNFC + DTC_NUMNFC) ))

			delLog(ZCT->ZCT_CHAVE)

		EndIf
		
		(cQry)->(dbSkip())
	
	EndDo
	
Return

//------------------------------------------------------------------------------  
/*/{Protheus.doc} PreDados()  

	Monta os dados no Obejto para geracao do EDI 

	@sample PreDados(cQuery)  

	@param cQuery - Area - Area conteudo o resultado da query para preenchimento dos atributos do metodo

	@return	 oFiat1Dad - Objeto - Objeto do tipo CFiat1EDI  
	
	@author	 Joni Lima  
	@since	 20/02/2016  
	@version P11  

	@comments

	/*/  
//------------------------------------------------------------------------------
Static Function PreDados(cQuery)

	Local oDad     	:= nil
	Local oFiat1Dad 	:= nil
	Local cCGCRem  	:= ''
	Local cCGCEms  	:= ''
	Local cCGCDes  	:= ''
	Local _cHora   	:= ''
	
	Local _nLin		:= 0
	Local _cPedCli	:= ''
	Local _cProtocolo	:= ''
	Local _cProjeto	:= ''
	Local _cObra		:= ''
	Local _cHrSaida	:= ''
	Local _lDTQSEMZA7	:= .T.
	
	//Local _c 
	
	If Len(_aDados) > 0
		_cProtocolo	:= AllTrim(_aDados[1][02,09])
	EndIf
	oFiat1Dad := CFIAT1EDI():new() 
	
	(cQuery)->(DbGoTop())
	
	While (cQuery)->(!EOF())

//		IncProc("Processando CTR: " + (cQuery)->DTQ_NUMCTR + ' ' + (cQuery)->DTQ_SERCTR + 'Nota: ' + (cQuery)->DTC_NUMNFC )
		IncProc("Processando CTR: " + (cQuery)->F2_DOC + ' ' + (cQuery)->F2_SERIE + 'Nota: ' + (cQuery)->DTC_NUMNFC )

		// Por: Ricardo
		 
		_nLin := aScan(_aDados[1],{|x| x[5] == (cQuery)->DTQ_VIAGEM })
		
		If _nLin > 0
			_cPedCli		:= AllTrim(_aDados[1][_nLin,08])
			// _cProtocolo	:= AllTrim(_aDados[1][_nLin,09])
			_cProjeto		:= AllTrim(_aDados[1][_nLin,12])
			_cObra			:= AllTrim(_aDados[1][_nLin,06])
			_cHrSaida		:= StrTran(AllTrim(_aDados[1][_nLin,12]),":","")									
		Else
			_cPedCli		:= ''
			//_cProtocolo	:= ''
			 _cProjeto		:= ''
			_cObra			:= ''
			_cHrSaida		:= ''
		EndIf			

		_lDTQSEMZA7		:= Empty((cQuery)->ZA6_PEDCLI)

		cCGCRem  := Posicione('SA1',1,xFilial('SA1') + (cQuery)->DTC_CLIREM + (cQuery)->DTC_LOJREM,'A1_CGC')
		cCGCDes  := Posicione('SA1',1,xFilial('SA1') + (cQuery)->DTC_CLIDES + (cQuery)->DTC_LOJDES,'A1_CGC')
		//cCGCCon  := Posicione('SA1',1,xFilial('SA1') + (cQuery)->DTC_CLICAL + (cQuery)->DTC_LOJCAL,'A1_CGC')
		cCGCCon  := Posicione('SA1',1,xFilial('SA1') + (cQuery)->F2_CLIENTE + (cQuery)->F2_LOJA,'A1_CGC')
		cCGCEms  := Posicione('SM0' , 1 , FWCodEmp() + (cQuery)->DTQ_FILORI , 'M0_CGC')

		oDad := CFiat1():new()

		oDad:SetDtViag(sToD((cQuery)->DTQ_DATGER))
		oDad:SetNota((cQuery)->DTC_NUMNFC)
		oDad:SetCGCRem(cCGCRem)
		oDad:SetPeso((cQuery)->DTC_PESO)
		oDad:SetValor((cQuery)->DTC_VALOR)
		IIF(_lDTQSEMZA7, oDad:SetHrSaid(_cHrSaida), oDad:SetHrSaid((cQuery)->ZB3_HORA))		
		If _lDTQSEMZA7
			//		Por: Ricardo
			oDad:SetPlaca(LevPlac((cQuery)->DTC_LOTNFC, (cQuery)->( DTQ_FILORI + _cProjeto + _cObra + DTQ_VIAGEM )  ))
			oDad:SetVeicu(NomVeic((cQuery)->DTC_LOTNFC, (cQuery)->( DTQ_FILORI + _cProjeto + _cObra + DTQ_VIAGEM )  ))
		Else
			oDad:SetPlaca(LevPlac((cQuery)->DTC_LOTNFC, (cQuery)->( DTQ_FILORI + ZA7_PROJET + ZA7_OBRA + DTQ_VIAGEM )  ))
			oDad:SetVeicu(NomVeic((cQuery)->DTC_LOTNFC, (cQuery)->( DTQ_FILORI + ZA7_PROJET + ZA7_OBRA + DTQ_VIAGEM )  ))
		EndIf
		
		//oDad:SetCTE(StrZero(Val(Right(Alltrim((cQuery)->F2_DOC),7)),7) + "-" + StrZero(Val(Substr(cCGCCon,13,2)),2))
		oDad:SetCTE((cQuery)->F2_DOC) //+ "-" + StrZero(Val(Substr(cCGCCon,13,2)),2)) - Frank - 11/08/2016
		oDad:SetCGCDest(cCGCDes)

		// -- Ricardo
		If(_lDTQSEMZA7, oDad:SetOrdColeGFL(_cPedCli), oDad:SetOrdColeGFL((cQuery)->ZA6_PEDCLI))
				
		//	-- Ricardo		
		//If(_lDTQSEMZA7, oDad:SetMVM(_cProtocolo), oDad:SetMVM((cQuery)->ZA6_PROTOC))
		oDad:SetMVM(_cProtocolo)
				
		If _lDTQSEMZA7				
			oDad:SetFatur(_cPedCli + StrZero(Val(Substr(cCGCCon,13,2)),2) ) // Frank - 11/08/2016
		Else
			oDad:SetFatur(alltrim((cQuery)->ZA6_PEDCLI) + StrZero(Val(Substr(cCGCCon,13,2)),2) ) // Frank - 11/08/2016
		EndIf
		oDad:SetCGCEmis(cCGCEms) 
		oDad:SetCGCCont(cCGCCon)
		oDad:SetDtEmisCte(sToD((cQuery)->F2_EMISSAO))
		oDad:SetDtEmisFat(sToD((cQuery)->F2_EMISSAO))
		//oDad:SetDtEmisFat(sToD(DtFatura((cQuery)->F2_EMISSAO)))
		oDad:SetValBrut((cQuery)->F2_VALBRUT)
		oDad:SetTpTransp(TpFatur((cQuery)->DTQ_ORIGEM,(cQuery)->DTQ_DESTIN)) // troquei a DTC pela DTQ Frank Z Fuga 12/04/16
//		oDad:SetDtEmisFat(sToD((cQuery)->F2_EMISSAO))
		//oDad:SetDtEmisFat(sToD(DtFatura((cQuery)->F2_EMISSAO)))
		oDad:SetDtEmisFat( MV_PAR12 )		// par‚metro informado. Chamado #3737 - Cristiam Rossi em 04/10/2016 (ser· gravado em E1_XDTFAT)
		oDad:SetValBrut((cQuery)->F2_VALBRUT)
		//oDad:SetTpTransp(TpFatur( (cQuery)->DTQ_ORIGEM, (cQuery)->DTQ_DESTIN  ) // troquei a DTC pela DTQ Frank Z Fuga 12/04/16
		
		If EMPTY( (cQuery)->DTC_CLIEXP )                                
			_cOrigemX := (cQuery)->DTQ_ORIGEM
		Else
			SA1->(dbSetOrder(1))
			SA1->(dbSeek(xFilial("SA1")+(cQuery)->DTC_CLIEXP+(cQuery)->DTC_LOJEXP))
			_cOrigemX := SA1->A1_MUN+"/"+SA1->A1_EST
		EndIf
		
		If EMPTY((cQuery)->DTC_CLIREC )
			_cDestimX := (cQuery)->DTQ_DESTIN
		Else	
			SA1->(dbSetOrder(1))
			SA1->(dbSeek(xFilial("SA1")+(cQuery)->DTC_CLIREC+(cQuery)->DTC_LOJREC))
			_cDestimX := SA1->A1_MUN+"/"+SA1->A1_EST
		EndIf
		
		oDad:SetTpTransp(TpFatur( _cOrigemX , _cDestimX   )) // troquei a DTC pela DTQ Frank Z Fuga 12/04/16

		oDad:SetSerCTE((cQuery)->F2_SERIE)	// (cQuery)->DTQ_SERCTR)

		if (cQuery)->DTC_NUMNFC == Replicate("0", 10)
			oDad:SetChvCTE( Replicate("0", 44) )
		else
			oDad:SetChvCTE((cQuery)->F2_CHVNFE)
		endif

	    oFiat1Dad:SetArrFiat1(oDad)

	    GerLog((cQuery)->(DTQ_FILORI + DTQ_VIAGEM + DTC_LOTNFC + DTC_NUMNFC) ,;
	    	   Alltrim(mv_par11)+Alltrim(mv_par10),;
	    	   Date(),;
	    	   Time(),;
	    	   'EDIFIAT1')

		SF2->( dbGoto( (cQuery)->F2RECNO ) )		// pesquisa TÌtulos gerados pelo CT-e
		if ! empty( SF2->F2_DUPL )					// atualizaÁ„o do campo E1_XDTFAT
			SE1->( dbSetOrder(1) )					// Cristiam Rossi em 04/10/2016
			SE1->( dbSeek( SF2->( F2_FILIAL + F2_PREFIXO + F2_DUPL ), .T. ) )
			while ! SE1->( EOF() ) .and. SE1->( E1_FILIAL+E1_PREFIXO+E1_NUM ) == SF2->( F2_FILIAL + F2_PREFIXO + F2_DUPL )
				SE1->( RecLock("SE1", .F.) )
				SE1->E1_XDTFAT := MV_PAR12
				SE1->( MsUnlock() )
				SE1->( dbSkip() )
			end
		endif

		(cQuery)->(dbSkip())
			
	EndDo
		
	(cQuery)->(dbCloseArea())
	
Return oFiat1Dad

//------------------------------------------------------------------------------  
/*/{Protheus.doc} TpFatur()  

Retorna o Tipo de Fatura

@sample TpFatur(cOrig,cDest) 

@param	cOrig - Caractere - local de Origem
		cDest - Caractere - local de Destino

@return cMVM - Caractere - Numero MVM

@author	 Joni Lima  
@since	 19/02/2016  
@version P11  

@comments

0001 - Municipal / 
0002 - Intermunicipal / 
0003 - Interestadual SP / 
0004 - Interestadual RJ / 
0005 - Interestadual PR / 
0006 - Interestadual SC / 
0007 - Interestadual RS / 
9999 - Outros casos não identificados

/*/  
//------------------------------------------------------------------------------
Static Function TpFatur(cOrig,cDest)

	Local cTipo := ''
	
	Local aOrig := StrTokArr( cOrig, '/' )
	Local aDest := StrTokArr( cDest, '/' )
	
	Local cOrig := ''
	Local cDest := ''
	Local cEstO := ''
	Local cEstD := ''
	
	If !Empty(aOrig) .and. !Empty(aDest) 
		If (len(aOrig) == 2) .and. (len(aDest) == 2)
			
			cOrig := Alltrim(aOrig[1])
			cDest := Alltrim(aDest[1])
			cEstO := Alltrim(aOrig[2])
			cEstD := Alltrim(aDest[2])
			
			DO CASE
				
				CASE cOrig == cDest
					cTipo := '0001'
				CASE (cOrig <> cDest) .and.(cEstO == cEstD)
					cTipo := '0002'
				CASE (cEstO <> cEstD) .and. (cEstO $ 'SP'.or. cEstD $ 'SP')  
					cTipo := '0003'
				CASE (cEstO <> cEstD) .and. (cEstO $ 'RJ'.or. cEstD $ 'RJ')  
					cTipo := '0004'
				CASE (cEstO <> cEstD) .and. (cEstO $ 'PR'.or. cEstD $ 'PR')	
					cTipo := '0005'
				CASE (cEstO <> cEstD) .and. (cEstO $ 'SC'.or. cEstD $ 'SC')
					cTipo := '0006'
				CASE (cEstO <> cEstD) .and. (cEstO $ 'RS'.or. cEstD $ 'RS')	
					cTipo := '0007'
				OTHERWISE
					cTipo := '9999'
			
			ENDCASE
	    EndIf    
	EndIf

Return cTipo

//------------------------------------------------------------------------------  
/*/{Protheus.doc} DtFatura() 

	Localizar a data de Fatura
	
	@sample DtFatura(cPedCli)  

	@param cPedCli - Caractere - Numero do Pedido Cliente

	@return	dRet - Data - Data da Fatura  
	
	@author	 Joni Lima  
	@since	 20/02/2016  
	@version P11  

	@comments  

	/*/  
//------------------------------------------------------------------------------
Static Function DtFatura(cPedCli)

	Local dRet := cTod('//')
	Local aAreaEDI := QuerDTFat(cPedCli)
	
		If (Select(aAreaEDI) > 0)
			
				While (aAreaEDI)->(!EOF())
					
					dRet :=  (aAreaEDI)->F2_EMISSAO
					
					(aAreaEDI)->(dbSkip())
					
				EndDo
				
				(aAreaEDI)->(dbCloseArea())
			
		EndIf
	
Return dRet

//------------------------------------------------------------------------------  
/*/{Protheus.doc} QuerDTFat() 

	Query para encontrar a data da fatura
	
	@sample QuerDTFat(cPedCli)  

	@param cPedCli - Caractere - Numero do Pedido Cliente

	@return	cNextAlias - Area - Retorna resultado da Query
	
	@author	 Joni Lima  
	@since	 20/02/2016  
	@version P11  

	@comments  

	/*/  
//------------------------------------------------------------------------------
Static Function QuerDTFat(cPedCli)

	Local cNextAlias	:= nil

	If (Select(cNextAlias) > 0)
		(cNextAlias)->(DbCloseArea())
	Endif

	cNextAlias := GetNextAlias()

	BeginSQL Alias cNextAlias
	
	SELECT 
		MAX(F2_EMISSAO) AS F2_EMISSAO
	
	FROM %Table:ZA6% ZA6
	  
	INNER JOIN %Table:ZA7% ZA7
	 ON ZA7_FILIAL = ZA6_FILIAL
	AND ZA7_PROJET = ZA6_PROJET
	AND ZA7_OBRA = ZA6_OBRA
	AND ZA7_SEQTRA = ZA6_SEQTRA
	 
	INNER JOIN %Table:DTQ% DTQ
	 ON ZA7_VIAGEM = DTQ_VIAGEM 
	
	INNER JOIN %Table:SF2% SF2
	 ON DTQ_FILORI = F2_FILIAL
	AND DTQ_NUMCTR = F2_DOC 
	AND DTQ_SERCTR = F2_SERIE
	
	WHERE
	  ZA6.%notdel% AND
	  ZA7.%notdel% AND	 
	  DTQ.%notdel% AND	 
	  SF2.%notdel% AND
      ZA6.ZA6_PEDCLI = %exp:cPedCli%
	
	EndSql

Return cNextAlias

//------------------------------------------------------------------------------  
/*/{Protheus.doc} NumMVM()  

Retorna numero MVM

@sample NumMVM(cViagem) 

@param	cViagem - Caractere - Codigo da viagem

@return cMVM - Caractere - Numero MVM

@author	 Joni Lima  
@since	 17/02/2016  
@version P11  

@comments  
/*/  
//------------------------------------------------------------------------------
Static Function NumMVM(cViagem)

	Local cIndZA7 := val(DbNickIndexKey('ITUPZA7003')) //ZA7_VIAGEM
	Local cMVM  := Posicione('ZA7',cIndZA7,cViagem,'ZA7_MVM')
	
Return cMVM

//------------------------------------------------------------------------------  
/*/{Protheus.doc} NomVeic()  

Retorna nome do Veiculo

@sample NomVeic(cLotNFC) 

@param	cLotNFC - Caractere - Numero da NFC    

@return cDescr - Caractere - Nome do Veiculo

@author	 Joni Lima  
@since	 17/02/2016  
@version P11  

@comments  
/*/  
//------------------------------------------------------------------------------
Static Function NomVeic(cLotNFC, xChave)
Local   cCodVei := ""
Local   cDescr  := ""
Default xChave  := ""

	if Empty( xChave )
		cCodVei := Posicione('DTP' , 1 , xFilial('DTP') + cLotNFC , 'DTP_CODVEI' )
		cDescr  := Posicione('DA3' , 1 , xFilial('DA3') + cCodVei , 'DA3_DESC' )
	else      
		ZL9->(dbSetOrder(1))
		if ZL9->( dbSeek( xChave ) )
			cDescr  := Posicione('DA3' , 3 , xFilial('DA3') + ZL9->ZL9_PLACA , 'DA3_DESC' )
		Else
			DTR->(dbSetOrder(1))
			DTR->(dbSeek(xFilial("DTR")+SUBSTR(XCHAVE,1,2)+SUBSTR(XCHAVE,LEN(XCHAVE)-5,6) ))
			If !DTR->(Eof())
				cCodVei := DTR->DTR_CODVEI			
				cDescr  := Posicione('DA3' , 1 , xFilial('DA3') + cCodVei , 'DA3_DESC' )
			EndIF
		endif
	endif

Return cDescr

//------------------------------------------------------------------------------  
/*/{Protheus.doc} LevPlac()  

Retorna Placa

@sample LevPlac(cLotNFC) 

@param	cLotNFC - Caractere - Numero da NFC    

@return cPlaca - Caractere - Placa do Veiculo

@author	 Joni Lima  
@since	 17/02/2016  
@version P11  

@comments  
/*/  
//------------------------------------------------------------------------------
Static Function LevPlac(cLotNFC, xChave)
Local cCodVei  := ""
Local cPlaca   := ""
Default xChave := ""

	if Empty( xChave )
		cCodVei := Posicione('DTP' , 1 , xFilial('DTP') + cLotNFC , 'DTP_CODVEI' )
		cPlaca  := Posicione('DA3' , 1 , xFilial('DA3') + cCodVei , 'DA3_PLACA' )
	else
		ZL9->(dbSetOrder(1))
		if ZL9->( dbSeek( xChave ) )
			cPlaca := ZL9->ZL9_PLACA
		Else                       
			DTR->(dbSetOrder(1))
			DTR->(dbSeek(xFilial("DTR")+SUBSTR(XCHAVE,1,2)+SUBSTR(XCHAVE,LEN(XCHAVE)-5,6) ))
			If !DTR->(Eof())
				cCodVei := DTR->DTR_CODVEI			
				cPlaca  := Posicione('DA3' , 1 , xFilial('DA3') + cCodVei , 'DA3_PLACA' )
			EndIF
		endif
	endif

Return cPlaca

//------------------------------------------------------------------------------  
/*/{Protheus.doc} HorSaid()  

Hora de Saida

@sample HorSaid(cAS) 

@param	cAS - Caractere - Numero da AS    

@return cHora - Caractere - Horas

@author	 Joni Lima  
@since	 17/02/2016  
@version P11  

@comments  
/*/  
//------------------------------------------------------------------------------
Static Function HorSaid(cAS)

	Local cIndZB2 := val(DbNickIndexKey('ITUPZB2005')) //ZB2_FILIAL + ZB2_AS
	Local cIndZB3 := val(DbNickIndexKey('ITUPZB3003')) //ZB3_FILIAL + ZB3_VIAGEM + ZB3_IDCALC 
	 
	Local cViagem := Posicione('ZB2' , cIndZB2 , xFilial('ZB2') + cAs , "ZB2_VIAGEM")
	Local cHora   := Posicione('ZB3' , cIndZB3 , xFilial('ZB3') + cViagem + 'A00000' , "ZB3_HORA")
	
Return cHora

//------------------------------------------------------------------------------  
/*/{Protheus.doc} ExecQuery()  

Executa a Query

@sample ExecQuery()  

@return	 cNextAlias - Area - Area com a query executada    

@author	 Joni Lima  
@since	 12/02/2016  
@version P11  

@comments  
/*/  
//------------------------------------------------------------------------------
Static Function ExecQuery()
Local cNextAlias := getNextAlias()
Local cQuery


	// DTQ sem ZA7 	
	cQuery := "select DTQ_FILORI,DTQ_DATGER,DTQ_NUMCTR,DTQ_SERCTR,DTQ_AS,DTQ_VIAGEM,DTQ_ORIGEM,DTQ_DESTIN,DTC_CLIREC,DTC_LOJREC, DTC_CLIEXP,DTC_LOJEXP,"+CRLF
	cQuery += "isnull(DTC_NUMNFC, '0000000000') DTC_NUMNFC,"+CRLF
	cQuery += "isnull(DTC_LOTNFC, '000000') DTC_LOTNFC,"+CRLF
	cQuery += "isnull(DTC_CLIREM, '') AS DTC_CLIREM,"+CRLF
	cQuery += "isnull(DTC_LOJREM, '') AS DTC_LOJREM,"+CRLF
	cQuery += "isnull(DTC_CLIDES, '') AS DTC_CLIDES,"+CRLF
	cQuery += "isnull(DTC_LOJDES, '') AS DTC_LOJDES,"+CRLF
	cQuery += "isnull(DTC_CLICAL, '') AS DTC_CLICAL,"+CRLF
	cQuery += "isnull(DTC_LOJCAL, '') AS DTC_LOJCAL,"+CRLF
	cQuery += "isnull(DTC_ORIGEM, DTQ_ORIGEM) DTC_ORIGEM,"+CRLF
	cQuery += "isnull(DTC_DESTIN, DTQ_DESTIN) DTC_DESTIN,"+CRLF
	cQuery += "isnull(DTC_PESO,0) DTC_PESO,"+CRLF
	cQuery += "isnull(DTC_VALOR,0) DTC_VALOR,"+CRLF
	cQuery += "'' AS ZA6_PEDCLI,'' AS ZA6_PROTOC,"+CRLF
	cQuery += "'' AS ZA7_PROJET,'' AS ZA7_OBRA,"+CRLF
	cQuery += "F2_VALBRUT,F2_EMISSAO,F2_CHVNFE,F2_CLIENTE,F2_LOJA,F2_DOC,F2_SERIE,"+CRLF
	cQuery += "F2_VALBRUT,F2_EMISSAO,F2_CHVNFE,F2_CLIENTE,F2_LOJA,F2_DOC,F2_SERIE, SF2.R_E_C_N_O_ F2RECNO,"+CRLF
	cQuery += "'' AS ZB3_HORA"+CRLF

	cQuery += " from "+retSqlName("DTQ")+" DTQ "+CRLF

	cQuery += " join "+retSqlName("SC5")+" SC5 on "+CRLF
	cQuery += 		" C5_FILIAL = DTQ_FILORI and C5_NUM = DTQ_NUMPV and SC5.D_E_L_E_T_=' '"+CRLF

	cQuery += " join "+retSqlName("SF2")+" SF2 on "+CRLF
	cQuery += 		" F2_FILIAL = C5_FILIAL and F2_DOC = C5_NOTA and F2_SERIE = C5_SERIE and SF2.D_E_L_E_T_=' '"+CRLF

//	cQuery += " join "+retSqlName("ZA6")+" ZA6 on "+CRLF
//	cQuery += 		" ZA6_AS = DTQ_AS and ZA6.D_E_L_E_T_=' '"+CRLF

	cQuery += "  join ZA6010 ZA6 on " 
	cQuery += " 	 ZA6_PROJET = DTQ_SOT AND ZA6_OBRA = DTQ_OBRA "

//	cQuery += " join "+retSqlName("ZA7")+" ZA7 on "+CRLF
//	cQuery += " ZA7.ZA7_VIAGEM IN ( SELECT CASE WHEN B.DTQ_CTRORI = '' THEN B.DTQ_VIAGEM ELSE B.DTQ_CTRORI END as B "+CRLF	
// 	cQuery += " FROM DTQ010 AS B WHERE B.DTQ_VIAGEM = DTQ.DTQ_VIAGEM ) "+CRLF	
//	cQuery += " and ZA7.D_E_L_E_T_=' ' "+CRLF	

//	cQuery += " join "+retSqlName("ZB3")+" ZB3 on "+CRLF
//	cQuery += 		" ZB3_FILIAL = DTQ_FILORI and ZB3_VIAGEM = ZA6_VIAGEM and ZB3_IDCALC = 'A00000' and ZB3.D_E_L_E_T_=' '"+CRLF
//	cQuery += 		" ZB3_VIAGEM = ZA6_VIAGEM and ZB3_IDCALC = 'A00000' and ZB3.D_E_L_E_T_=' '"+CRLF

	cQuery += " left join "+retSqlName("DTC")+" DTC on "+CRLF
	cQuery += 		" DTC_FILIAL = DTQ_FILIAL and DTC_VIAGEM = DTQ_VIAGEM and DTC_SOT = DTQ_SOT and DTC.D_E_L_E_T_=' '"+CRLF

	cQuery += " where DTQ_FILIAL = '"+xFilial("DTQ")+"'"+CRLF
	cQuery += 		" and DTQ_FILORI in "+ FormatIn( Alltrim(MV_PAR01) ,"," )+CRLF
	cQuery += 		" and DTQ_DATGER between '"+DtoS(MV_PAR02)+"' and '"+DtoS(MV_PAR03)+"'"+CRLF
	cQuery += 		" and F2_EMISSAO between '"+DtoS(MV_PAR04)+"' and '"+DtoS(MV_PAR05)+"'"+CRLF
	cQuery += 		" and DTQ_SOT between '"+MV_PAR06+"' and '"+MV_PAR07+"'"+CRLF
	cQuery += 		" and ZA6_PEDCLI between '"+MV_PAR08+"' and '"+MV_PAR09+"'"+CRLF
	cQuery += 		" and DTQ.D_E_L_E_T_ = ' ' "+CRLF
	
	// Por: Ricardo 
	cQuery +=	  	" AND NOT EXISTS ( SELECT * FROM ZA7010 WHERE DTQ.DTQ_VIAGEM = ZA7_VIAGEM )"+CRLF // AND DTQ.DTQ_FILORI = ZA7_FILREG

	cQuery += "UNION " +CRLF

	cQuery += "select DTQ_FILORI,DTQ_DATGER,DTQ_NUMCTR,DTQ_SERCTR,DTQ_AS,DTQ_VIAGEM,DTQ_ORIGEM,DTQ_DESTIN,DTC_CLIREC,DTC_LOJREC, DTC_CLIEXP,DTC_LOJEXP,"+CRLF
	cQuery += "isnull(DTC_NUMNFC, '0000000000') DTC_NUMNFC,"+CRLF
	cQuery += "isnull(DTC_LOTNFC, '000000') DTC_LOTNFC,"+CRLF
/*	
	cQuery += "isnull(DTC_CLIREM, '') AS DTC_CLIREM,"+CRLF
	cQuery += "isnull(DTC_LOJREM, '') AS DTC_LOJREM,"+CRLF
	cQuery += "isnull(DTC_CLIDES, '') AS DTC_CLIDES,"+CRLF
	cQuery += "isnull(DTC_LOJDES, '') AS DTC_LOJDES,"+CRLF
	cQuery += "isnull(DTC_CLICAL, '') AS DTC_CLICAL,"+CRLF
	cQuery += "isnull(DTC_LOJCAL, '') AS DTC_LOJCAL,"+CRLF
*/
	cQuery += "isnull(DTC_CLIREM, case when ZA7_DEVEMB='R' and ZA7_CLIDES='' then ZA6_CLIDES when ZA7_DEVEMB='R' and ZA7_CLIDES<>'' then ZA7_CLIDES else ZA7_CODCLI end ) DTC_CLIREM,"+CRLF
	cQuery += "isnull(DTC_LOJREM, case when ZA7_DEVEMB='R' and ZA7_CLIDES='' then ZA6_LOJDES when ZA7_DEVEMB='R' and ZA7_CLIDES<>'' then ZA7_LOJDES else ZA7_LOJCLI end ) DTC_LOJREM,"+CRLF
	cQuery += "isnull(DTC_CLIDES, case when ZA7_DEVEMB='R' then ZA7_CODCLI when ZA7_CLIDES<>'' then ZA7_CLIDES else ZA6_CLIDES end ) DTC_CLIDES,"+CRLF
	cQuery += "isnull(DTC_LOJDES, case when ZA7_DEVEMB='R' then ZA7_LOJCLI when ZA7_CLIDES<>'' then ZA7_LOJDES else ZA6_LOJDES end ) DTC_LOJDES,"+CRLF
	cQuery += "isnull(DTC_CLICAL, case when ZA7_DEVEMB='R' then ZA7_CODCLI when ZA7_CLIDES<>'' then ZA7_CLIDES else ZA6_CLIDES end ) DTC_CLICAL,"+CRLF
	cQuery += "isnull(DTC_LOJCAL, case when ZA7_DEVEMB='R' then ZA7_LOJCLI when ZA7_CLIDES<>'' then ZA7_LOJDES else ZA6_LOJDES end ) DTC_LOJCAL,"+CRLF
	cQuery += "isnull(DTC_ORIGEM, DTQ_ORIGEM) DTC_ORIGEM,"+CRLF
	cQuery += "isnull(DTC_DESTIN, DTQ_DESTIN) DTC_DESTIN,"+CRLF
	cQuery += "isnull(DTC_PESO,0) DTC_PESO,"+CRLF
	cQuery += "isnull(DTC_VALOR,0) DTC_VALOR,"+CRLF
	cQuery += "ZA6_PEDCLI,ZA6_PROTOC,"+CRLF
	cQuery += "ZA7_PROJET,ZA7_OBRA,"+CRLF
	cQuery += "F2_VALBRUT,F2_EMISSAO,F2_CHVNFE,F2_CLIENTE,F2_LOJA,F2_DOC,F2_SERIE,"+CRLF
	cQuery += "F2_VALBRUT,F2_EMISSAO,F2_CHVNFE,F2_CLIENTE,F2_LOJA,F2_DOC,F2_SERIE, SF2.R_E_C_N_O_ F2RECNO,"+CRLF
	cQuery += "ZB3_HORA"+CRLF

	cQuery += " from "+retSqlName("DTQ")+" DTQ "+CRLF

	cQuery += " join "+retSqlName("SC5")+" SC5 on "+CRLF
	cQuery += 		" C5_FILIAL = DTQ_FILORI and C5_NUM = DTQ_NUMPV and SC5.D_E_L_E_T_=' '"+CRLF

	cQuery += " join "+retSqlName("SF2")+" SF2 on "+CRLF
	cQuery += 		" F2_FILIAL = C5_FILIAL and F2_DOC = C5_NOTA and F2_SERIE = C5_SERIE and SF2.D_E_L_E_T_=' '"+CRLF

	cQuery += " join "+retSqlName("ZA6")+" ZA6 on "+CRLF
	cQuery += 		" ZA6_AS = DTQ_AS and ZA6.D_E_L_E_T_=' '"+CRLF

	cQuery += " join "+retSqlName("ZA7")+" ZA7 on "+CRLF
	cQuery += " ZA7.ZA7_VIAGEM IN ( SELECT CASE WHEN B.DTQ_CTRORI = '' THEN B.DTQ_VIAGEM ELSE B.DTQ_CTRORI END as B "+CRLF	
 	cQuery += " FROM DTQ010 AS B WHERE B.DTQ_VIAGEM = DTQ.DTQ_VIAGEM ) "+CRLF	
	cQuery += " and ZA7.D_E_L_E_T_=' ' "+CRLF	

	cQuery += " join "+retSqlName("ZB3")+" ZB3 on "+CRLF
	cQuery += 		" ZB3_FILIAL = DTQ_FILORI and ZB3_VIAGEM = ZA6_VIAGEM and ZB3_IDCALC = 'A00000' and ZB3.D_E_L_E_T_=' '"+CRLF
	//cQuery += 		" ZB3_VIAGEM = ZA6_VIAGEM and ZB3_IDCALC = 'A00000' and ZB3.D_E_L_E_T_=' '"+CRLF

	cQuery += " left join "+retSqlName("DTC")+" DTC on "+CRLF
	cQuery += 		" DTC_FILIAL = DTQ_FILIAL and DTC_VIAGEM = DTQ_VIAGEM and DTC_SOT = DTQ_SOT and DTC.D_E_L_E_T_=' '"+CRLF

	cQuery += " where DTQ_FILIAL = '"+xFilial("DTQ")+"'"+CRLF
	cQuery += 		" and DTQ_FILORI in "+ FormatIn( Alltrim(MV_PAR01) ,"," )+CRLF
	cQuery += 		" and DTQ_DATGER between '"+DtoS(MV_PAR02)+"' and '"+DtoS(MV_PAR03)+"'"+CRLF
	cQuery += 		" and F2_EMISSAO between '"+DtoS(MV_PAR04)+"' and '"+DtoS(MV_PAR05)+"'"+CRLF
	cQuery += 		" and DTQ_SOT between '"+MV_PAR06+"' and '"+MV_PAR07+"'"+CRLF
	cQuery += 		" and ZA6_PEDCLI between '"+MV_PAR08+"' and '"+MV_PAR09+"'"+CRLF
	cQuery += 		" and DTQ.D_E_L_E_T_ = ' ' "+CRLF
	
	cQuery += " order by DTQ_NUMCTR "
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), cNextAlias, .F., .T. )
	
MEMOWRIT("D:\TEMP\EDIFIAT.SQL",cQuery)
Return cNextAlias

/************************************************************************************************/
/*
Static Function ExecQuery()
Local cNextAlias := getNextAlias()
Local cQuery


	cQuery := "select DTQ_FILORI,DTQ_DATGER,DTQ_NUMCTR,DTQ_SERCTR,DTQ_AS,DTQ_VIAGEM,DTQ_ORIGEM,DTQ_DESTIN,"+CRLF
	cQuery := "select DTQ_FILORI,DTQ_DATGER,DTQ_NUMCTR,DTQ_SERCTR,DTQ_AS,DTQ_VIAGEM,DTQ_ORIGEM,DTQ_DESTIN,DTC_CLIREC,DTC_LOJREC, DTC_CLIEXP,DTC_LOJEXP,"+CRLF
	cQuery += "isnull(DTC_NUMNFC, '0000000000') DTC_NUMNFC,"+CRLF
	cQuery += "isnull(DTC_LOTNFC, '000000') DTC_LOTNFC,"+CRLF
	cQuery += "isnull(DTC_CLIREM, case when ZA7_DEVEMB='R' and ZA7_CLIDES='' then ZA6_CLIDES when ZA7_DEVEMB='R' and ZA7_CLIDES<>'' then ZA7_CLIDES else ZA7_CODCLI end ) DTC_CLIREM,"+CRLF
	cQuery += "isnull(DTC_LOJREM, case when ZA7_DEVEMB='R' and ZA7_CLIDES='' then ZA6_LOJDES when ZA7_DEVEMB='R' and ZA7_CLIDES<>'' then ZA7_LOJDES else ZA7_LOJCLI end ) DTC_LOJREM,"+CRLF
	cQuery += "isnull(DTC_CLIDES, case when ZA7_DEVEMB='R' then ZA7_CODCLI when ZA7_CLIDES<>'' then ZA7_CLIDES else ZA6_CLIDES end ) DTC_CLIDES,"+CRLF
	cQuery += "isnull(DTC_LOJDES, case when ZA7_DEVEMB='R' then ZA7_LOJCLI when ZA7_CLIDES<>'' then ZA7_LOJDES else ZA6_LOJDES end ) DTC_LOJDES,"+CRLF
	cQuery += "isnull(DTC_CLICAL, case when ZA7_DEVEMB='R' then ZA7_CODCLI when ZA7_CLIDES<>'' then ZA7_CLIDES else ZA6_CLIDES end ) DTC_CLICAL,"+CRLF
	cQuery += "isnull(DTC_LOJCAL, case when ZA7_DEVEMB='R' then ZA7_LOJCLI when ZA7_CLIDES<>'' then ZA7_LOJDES else ZA6_LOJDES end ) DTC_LOJCAL,"+CRLF
	cQuery += "isnull(DTC_ORIGEM, DTQ_ORIGEM) DTC_ORIGEM,"+CRLF
	cQuery += "isnull(DTC_DESTIN, DTQ_DESTIN) DTC_DESTIN,"+CRLF
	cQuery += "isnull(DTC_PESO,0) DTC_PESO,"+CRLF
	cQuery += "isnull(DTC_VALOR,0) DTC_VALOR,"+CRLF
	cQuery += "ZA6_PEDCLI,ZA6_PROTOC,"+CRLF
	cQuery += "ZA7_PROJET,ZA7_OBRA,"+CRLF
	cQuery += "F2_VALBRUT,F2_EMISSAO,F2_CHVNFE,F2_CLIENTE,F2_LOJA,F2_DOC,F2_SERIE,"+CRLF
	cQuery += "F2_VALBRUT,F2_EMISSAO,F2_CHVNFE,F2_CLIENTE,F2_LOJA,F2_DOC,F2_SERIE, SF2.R_E_C_N_O_ F2RECNO,"+CRLF
	cQuery += "ZB3_HORA"+CRLF

	cQuery += " from "+retSqlName("DTQ")+" DTQ "+CRLF

	cQuery += " join "+retSqlName("SC5")+" SC5 on "+CRLF
	cQuery += 		" C5_FILIAL = DTQ_FILORI and C5_NUM = DTQ_NUMPV and SC5.D_E_L_E_T_=' '"+CRLF

	cQuery += " join "+retSqlName("SF2")+" SF2 on "+CRLF
	cQuery += 		" F2_FILIAL = C5_FILIAL and F2_DOC = C5_NOTA and F2_SERIE = C5_SERIE and SF2.D_E_L_E_T_=' '"+CRLF

	cQuery += " join "+retSqlName("ZA6")+" ZA6 on "+CRLF
	cQuery += 		" ZA6_AS = DTQ_AS and ZA6.D_E_L_E_T_=' '"+CRLF

	cQuery += " join "+retSqlName("ZA7")+" ZA7 on "+CRLF
    cQuery += " ZA7.ZA7_VIAGEM IN ( SELECT CASE WHEN B.DTQ_CTRORI = '' THEN B.DTQ_VIAGEM ELSE B.DTQ_CTRORI END as B "+CRLF	
    cQuery += " FROM DTQ010 AS B WHERE B.DTQ_VIAGEM = DTQ.DTQ_VIAGEM ) "+CRLF	
    cQuery += " and ZA7.D_E_L_E_T_=' ' "+CRLF	

	cQuery += " join "+retSqlName("ZB3")+" ZB3 on "+CRLF
	//cQuery += 		" ZB3_FILIAL = DTQ_FILORI and ZB3_VIAGEM = ZA6_VIAGEM and ZB3_IDCALC = 'A00000' and ZB3.D_E_L_E_T_=' '"+CRLF
	cQuery += 		" ZB3_VIAGEM = ZA6_VIAGEM and ZB3_IDCALC = 'A00000' and ZB3.D_E_L_E_T_=' '"+CRLF

	cQuery += " left join "+retSqlName("DTC")+" DTC on "+CRLF
	cQuery += 		" DTC_FILIAL = DTQ_FILIAL and DTC_VIAGEM = DTQ_VIAGEM and DTC_SOT = DTQ_SOT and DTC.D_E_L_E_T_=' '"+CRLF

	cQuery += " where DTQ_FILIAL = '"+xFilial("DTQ")+"'"+CRLF
	cQuery += 		" and DTQ_FILORI in "+ FormatIn( Alltrim(MV_PAR01) ,"," )+CRLF
	cQuery += 		" and DTQ_DATGER between '"+DtoS(MV_PAR02)+"' and '"+DtoS(MV_PAR03)+"'"+CRLF
	cQuery += 		" and F2_EMISSAO between '"+DtoS(MV_PAR04)+"' and '"+DtoS(MV_PAR05)+"'"+CRLF
	cQuery += 		" and DTQ_SOT between '"+MV_PAR06+"' and '"+MV_PAR07+"'"+CRLF
	cQuery += 		" and ZA6_PEDCLI between '"+MV_PAR08+"' and '"+MV_PAR09+"'"+CRLF
	cQuery += 		" and DTQ.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " order by DTQ_NUMCTR "
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), cNextAlias, .F., .T. )
	

Return cNextAlias
*/

//------------------------------------------------------------------------------  
/*/{Protheus.doc} GerLog()  

Grava Log
 
@sample delLog(cChave)

@param cChave   - Caractere - Chave do Registro

@author	 Joni Lima  
@since	 01/03/2016  
@version P11 

@comments  
/*/  
//------------------------------------------------------------------------------
Static Function GerLog(cChave,cNomArq,dData,cHora,cOrigem)

	Local oMntZTC := CLXMntTab():new('ZCT',,2)
	Local aDados  := {}
	
	AADD(aDados,{'ZCT_FILIAL',xFilial('ZCT')})
	AADD(aDados,{'ZCT_CHAVE',cChave})
	AADD(aDados,{'ZCT_NOMARQ',cNomArq})
	AADD(aDados,{'ZCT_DATA',dData})
	AADD(aDados,{'ZCT_HORA',cHora})
	AADD(aDados,{'ZCT_ORIGEM',cOrigem})
	
	oMntZTC:SetCampDad(aDados)
	oMntZTC:Inclui()
	
Return

//------------------------------------------------------------------------------  
/*/{Protheus.doc} delLog()  

Grava Log
 
@sample delLog(cChave)

@param cChave   - Caractere - Chave do Registro

@author	 Joni Lima  
@since	 01/03/2016  
@version P11  

@comments  
/*/  
//------------------------------------------------------------------------------
Static Function delLog(cChave)

	Local oMntZTC := CLXMntTab():new('ZCT',,2)
	Local aDados  := {}
	
	AADD(aDados,{'ZCT_FILIAL',xFilial('ZCT')})
	AADD(aDados,{'ZCT_CHAVE',cChave})
	
	oMntZTC:SetCampDad(aDados)
	oMntZTC:Delete()
	
Return

//------------------------------------------------------------------------------  
/*/{Protheus.doc} criaSX1()  

	Cria pergunta com os parametros
	
	@sample criaSX1(cPerg)  

	@param - cPerg - Caractere - Nome da pergunta 

	@return	 nil  
	@author	 Joni Lima  
	@since	 12/02/2016  
	@version P11  

	@comments  
	1.1. Filial Emissora De...Até? 
	1.2. Data de Viagem De...Até? 
	1.3. Data de Emissão CTe/NFSe De...Até? 
	1.4. Contrato De...Até? 
	1.5. Numero da Fatura De...Até? 
	1.6. Nome do arquivo ? 
	1.7. Local do arquivo ? 

	/*/  
//------------------------------------------------------------------------------
Static Function criaSX1(cPergunt)

	Local cPerg := padR(cPergunt,10)
	
	//PutSx1(<cGrupo>,<cOrdem>,<cPergunt>                  ,<cPerSpa>,<cPerEng>,<cVar>  ,<cTipo>,<nTamanho>              ,<nDecimal>              ,<nPresel>,<cGSC>,<cValid>,<cF3>   ,<cGrpSXg>,<cPyme>,<cVar01>  ,<cDef01>,<cDefSpa1>,<cDefEng1>,<cCnt01>,<cDef02>,<cDefSpa2>,<cDefEng2>,<cDef03>,<cDef03>,<cDefEng3>,<cDef04>,<cDefSpa4>,<cDefEng4>,<cDef05>,<cDefSpa5>,<cDefEng5>,<aHelpPor>                          ,<aHelpEng>,<aHelpSpa>,<cHelp>)
	PutSx1(cPerg     ,"01"    ,"Filial De:"                ,""       ,""       ,"mv_ch1","C"    ,99                      ,0                       ,00       ,"G"   ,""      ,"SM0"   ,""       ,""     ,"mv_par01",""      ,""        ,""        ,""      ,""      ,""        ,""        ,""      ,""      ,""        ,""      ,""        ,""        ,""      ,""        ,""        ,{"Digite a Filial"}                 ,{}        ,{}        ,"")
	PutSx1(cPerg     ,"02"    ,"Data Viagem  De:"          ,""       ,""       ,"mv_ch2","D"    ,TamSX3("DTQ_DATGER")[1] ,TamSX3("DTQ_DATGER")[2] ,00       ,"G"   ,""      ,""      ,""       ,""     ,"mv_par02",""      ,""        ,""        ,""      ,""      ,""        ,""        ,""      ,""      ,""        ,""      ,""        ,""        ,""      ,""        ,""        ,{"Digite a Data Viagem"}            ,{}        ,{}        ,"")
	PutSx1(cPerg     ,"03"    ,"Data Viagem Ate:"          ,""       ,""       ,"mv_ch3","D"    ,TamSX3("DTQ_DATGER")[1] ,TamSX3("DTQ_DATGER")[2] ,00       ,"G"   ,""      ,""      ,""       ,""     ,"mv_par03",""      ,""        ,""        ,""      ,""      ,""        ,""        ,""      ,""      ,""        ,""      ,""        ,""        ,""      ,""        ,""        ,{"Digite a Data Viagem"}            ,{}        ,{}        ,"")
	PutSx1(cPerg     ,"04"    ,"Data Emissao CTE/NFSE De:" ,""       ,""       ,"mv_ch4","D"    ,TamSX3("F2_EMISSAO")[1] ,TamSX3("F2_EMISSAO")[2] ,00       ,"G"   ,""      ,""      ,""       ,""     ,"mv_par04",""      ,""        ,""        ,""      ,""      ,""        ,""        ,""      ,""      ,""        ,""      ,""        ,""        ,""      ,""        ,""        ,{"Digite a Data Emissao CTE/NFSE"}  ,{}        ,{}        ,"")
	PutSx1(cPerg     ,"05"    ,"Data Emissao CTE/NFSE Ate:",""       ,""       ,"mv_ch5","D"    ,TamSX3("F2_EMISSAO")[1] ,TamSX3("F2_EMISSAO")[2] ,00       ,"G"   ,""      ,""      ,""       ,""     ,"mv_par05",""      ,""        ,""        ,""      ,""      ,""        ,""        ,""      ,""      ,""        ,""      ,""        ,""        ,""      ,""        ,""        ,{"Digite a Data Emissao CTE/NFSE"}  ,{}        ,{}        ,"")
	PutSx1(cPerg     ,"06"    ,"Contrato De:"              ,""       ,""       ,"mv_ch6","C"    ,TamSX3("DTQ_SOT")[1]    ,TamSX3("DTQ_SOT")[2]    ,00       ,"G"   ,""      ,"ZA0C"  ,""       ,""     ,"mv_par06",""      ,""        ,""        ,""      ,""      ,""        ,""        ,""      ,""      ,""        ,""      ,""        ,""        ,""      ,""        ,""        ,{"Digite o Contrato"}               ,{}        ,{}        ,"")
	PutSx1(cPerg     ,"07"    ,"Contrato Ate:"             ,""       ,""       ,"mv_ch7","C"    ,TamSX3("DTQ_SOT")[1]    ,TamSX3("DTQ_SOT")[2]    ,00       ,"G"   ,""      ,"ZA0C"  ,""       ,""     ,"mv_par07",""      ,""        ,""        ,""      ,""      ,""        ,""        ,""      ,""      ,""        ,""      ,""        ,""        ,""      ,""        ,""        ,{"Digite o Contrato"}               ,{}        ,{}        ,"")
	PutSx1(cPerg     ,"08"    ,"Fatura De:"                ,""       ,""       ,"mv_ch8","C"    ,TamSX3("ZA6_PEDCLI")[1] ,TamSX3("ZA6_PEDCLI")[2] ,00       ,"G"   ,""      ,""      ,""       ,""     ,"mv_par08",""      ,""        ,""        ,""      ,""      ,""        ,""        ,""      ,""      ,""        ,""      ,""        ,""        ,""      ,""        ,""        ,{"Digite a Fatura"}                 ,{}        ,{}        ,"")
	PutSx1(cPerg     ,"09"    ,"Fatura Ate:"               ,""       ,""       ,"mv_ch9","C"    ,TamSX3("ZA6_PEDCLI")[1] ,TamSX3("ZA6_PEDCLI")[2] ,00       ,"G"   ,""      ,""      ,""       ,""     ,"mv_par09",""      ,""        ,""        ,""      ,""      ,""        ,""        ,""      ,""      ,""        ,""      ,""        ,""        ,""      ,""        ,""        ,{"Digite a Fatura"}                 ,{}        ,{}        ,"")
	PutSx1(cPerg     ,"10"    ,"Nome Arquivo:"             ,""       ,""       ,"mv_chA","C"    ,10                      ,0                       ,00       ,"G"   ,""      ,""      ,""       ,""     ,"mv_par10",""      ,""        ,""        ,""      ,""      ,""        ,""        ,""      ,""      ,""        ,""      ,""        ,""        ,""      ,""        ,""        ,{"Nome do Arquivo "}                ,{}        ,{}        ,"")
	PutSx1(cPerg     ,"11"    ,"Caminho Arquivo:"          ,""       ,""       ,"mv_chB","C"    ,60                      ,0                       ,00       ,"G"   ,""      ,"HSSDIR",""       ,""     ,"mv_par11",""      ,""        ,""        ,""      ,""      ,""        ,""        ,""      ,""      ,""        ,""      ,""        ,""        ,""      ,""        ,""        ,{"Caminho do Arquivo"}              ,{}        ,{}        ,"")

// novo par‚metro - Cristiam Rossi em 04/10/2016 - esta data ir· para registro novo no SE1
	PutSx1(cPerg     ,"12"    ,"Dt Fatura FIAT:"           ,""       ,""       ,"mv_chC","D"    ,TamSX3("DTQ_DATGER")[1] ,0                       ,00       ,"G"   ,""      ,""      ,""       ,""     ,"mv_par12",""      ,""        ,""        ,""      ,""      ,""        ,""        ,""      ,""      ,""        ,""      ,""        ,""        ,""      ,""        ,""        ,{"Data Fatura p/ previsao de pagto"},{}        ,{}        ,"")
	
Return


/*****************************************************************/
Static Function fCargaXLS
/*****************************************************************/
	Local aArea	 := GetArea()
	Local _lRet	 := .T.
	
	
	Begin Sequence

		_aDados := StaticCall( GEFIMPPA7 , CargaXLS )

		If !( _aDados[2] )
			_lRet	 := .F.
			Break
		EndIf

		If Len( _aDados[1] ) == 0
			Aviso("AtenÁ„o","N„o existe registros para importaÁ„o.",{"OK"})
			_lRet	 := .F.			
			Break
		EndIf

	End Sequence

	RestArea( aArea )

Return _lRet
