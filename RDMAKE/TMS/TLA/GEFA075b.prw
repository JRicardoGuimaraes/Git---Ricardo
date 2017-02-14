#Include 'Protheus.ch'

/*/{Protheus.doc} GEFA075b
(Programa responsável quem buscar chave de NF-e da SZ6 para os Lotes gerados )
@type Function: Atualização
@author u297686 - Ricardo Guimarães
@since 16/12/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function GEFA075b()
Local _lDados := .F.

Private Trab	:= GetNextAlias()

If AjustaParam()

	Processa( { |lEnd| _lDados := fBuscaDados() } , 'Processando Lotes', 'Aguarde... Listando lotes com NF-e sem chave...', .T. )	
	If _lDados
		Processa( { |lEnd| fGravaDTC() } 	, 'Gravando Chaves', 'Aguarde... Gravando chave de NF-e(DTC)...', .T. )
	EndIf
EndIf

Return Nil


/*/{Protheus.doc} fBuscaDados
(Busca da dados na tabela DTC com NF-e sem chave)
@type function Executa query
@author u297686 - Ricardo Guimarães
@since 16/12/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function fBuscaDados()
Local _lRet 	:= .F.
Local _Where	:= ''
Local _aLastQuery := {}
Local _cUO		:= ''

_cWhere := " And DTC_LOTNFC >= '" + MV_PAR01	+ "' And DTC_LOTNFC <= '" + MV_PAR02 + "' "
_cWhere += " And DTC_NFEID  = '' " 
_cWhere += " And DTC_DOC  	= '' "

If MV_PAR03 == 'OVL'
	_cWhere += " And SUBSTRING(DTC_CCUSTO,1,3) IN " + FORMATIN(GETMV("MV_XOVLCC"),"|")
ElseIf MV_PAR03 == 'FVL'
	_cWhere += " And SUBSTRING(DTC_CCUSTO,1,3) IN " + FORMATIN(GETMV("MV_XTLACC"),"|")
EndIf

_cWhere := "%"+_cWhere+"%"

If Select( Trab ) # 0
	(Trab)->(DbCloseArea())
EndIf

BeginSql Alias Trab

	Select DTC_FILORI, DTC_LOTNFC, DTC_NUMNFC, DTC_SERNFC, DTC_EMINFC, DTC_CLIDES, DTC_LOJDES, DTC_CLIREM, DTC_LOJREM, DTC_CLIDEV, DTC_LOJDEV, DTC.R_E_C_N_O_ AS RECNO

		From 	%Table:DTC% DTC
		Where	( 	DTC.%NotDel%
		  			And	DTC.DTC_FILORI	= %Exp:cFilAnt% 
				)			
					%Exp:_cWhere%
EndSql

_aLastQuery := GetLastQuery()

dbSelectArea(Trab) ; dbGoTop()

If !Eof()
	_lRet := .t.
Else
	Aviso("Aviso","Não há registros a serem processados para o filtro informado.",{"Ok"})	
EndIf
	
Return( _lRet )

/*/{Protheus.doc} fGravaDTC
(long_description)
@type function
@author u297686 - Ricardo Guimarães
@since 16/12/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function fGravaDTC() 
Local cCodOri 	:= ''
Local _nRecTot	:= 0
Local _nRec		:= 0
Local _nRecAtu	:= 0
Local _nRecNAtu	:= 0
Local _cCNPJOri	:= ''
Local _cCFOP  	:= ""
Local _cNFEID 	:= ""
Local _cNumNFC  	:= ""
Local _cSerNFC  	:= "" 

( Trab )->( DbGoBottom() )

( Trab )->( DbEval( { || _nRecTot += 1 } ) )

ProcRegua( ( Trab )->( _nRecTot ) )

( Trab )->( DbgoTop() )

While !(TRAB)->(Eof())

		IncProc('Atualizando Registro '+cValToChar(++_nRec)+' de '+cValToChar(_nRecTot))

		// Pego o CFOP e Chave 
		dbSelectArea("SZ6") ; dbSetOrder(1)
		_cCFOP  := ""
		_cNFEID := ""
		_cNumNFC  := AllTrim((TRAB)->DTC_NUMNFC)
		_cSerNFC  := AllTrim((TRAB)->DTC_SERNFC)

		_cCNPJOri := GetAdvFVal('SA1','A1_CGC',xFilial("SA1") + (TRAB)->DTC_CLIREM + (TRAB)->DTC_LOJREM,1,'')
		 
		If dbSeek(xFilial("SZ6")+_cNumNFC+_cSerNFC+AllTrim(_cCNPJOri))
			_cCFOP  := SZ6->Z6_CFOPPRI
			_cNFEID := SZ6->Z6_IDNFE
			_nRecAtu++
		Else
			_nRecNAtu++
      	EndIf
        
		/*-----------------------------------------------------
		Atualiza Chave das notas fiscais - DTC
		-----------------------------------------------------*/
		DTC->(dbGoTo((TRAB)->RECNO))
		If	Reclock("DTC",.F.)
			DTC->DTC_NFEID  := _cNFEID
		EndIf	
	(TRAB)->(dbSkip())			
End			

If _nRecTot > 0

	Aviso('Aviso','Total de Registros processados     : ' + cValToChar(_nRecTot)  + CRLF +;
					'Total de Chaves localizadas(SZ6)   : ' + cValToChar(_nRecAtu)  + CRLF +;
					'Total de Chaves N/Localizadas(SZ6) : ' + cValToChar(_nRecNAtu) + CRLF, {'Ok'} )

EndIf

Return


Static Function AjustaParam

	Local aParamBox	:= {}
	Local aRet			:= {}

	Local lRetorno	:= .F.
	Local lCanSave	:= .T.
	Local lUserSave	:= .T.

	Local cLoad		:= "GEFA075b"
	Local aCombo		:= {"FVL","OVL","TODAS"}

	aAdd(aParamBox,{1,"Lote Inicial"	,Space(GetSx3Cache("DT6_LOTNFC","X3_TAMANHO"))	,"@!","",""		,"",50 ,.F.})
	aAdd(aParamBox,{1,"Lote Final"		,Space(GetSx3Cache("DT6_LOTNFC","X3_TAMANHO"))	,"@!","",""		,"",50	,.F.})

	aAdd(aParamBox,{2,"Qual UO?",1,aCombo,50,"",.F.})

	If	ParamBox(aParamBox,"Parâmetros...",@aRet,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPosX*/,/*nPosy*/,/*oDlgWizard*/,cLoad,lCanSave,lUserSave)
		If ValType( MV_PAR03 ) == 'N'
			MV_PAR03 := 'FVL'
		EndIf
		lRetorno	:= .T.
	Endif

Return( lRetorno )
