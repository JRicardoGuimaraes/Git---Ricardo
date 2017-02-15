#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

#define userName					1
#define password					2
#define orgCode					3
#define referenceNumber			4
#define tripNumber				5
#define creationDate				6
#define vehicleType				7
#define totalFee					8
#define kmTotal					9
#define cnpjSupplierCollection	10
#define collectionAddress		11
#define collectionOutDate		12
#define targetAddress			13
#define exitFee					14

/*/{Protheus.doc} GEFWSITG
//TODO Descrição auto-gerada.
@author u297686
@since 10/02/2017
@version undefined
@param _cTipoOper, , descricao
@type function
/*/
User Function GEFWSITG(_cTipoOper) // E=Exportação - I=Importação
Local oWsdl
Local xRet
Local aOps 			:= {}
Local aComplex 		:= {}
Local aSimple 		:= {}
Local aDados 		:= {}
Local aRetWS		:= {}
Local cXMLRet		:= ''
Local oXMLRet		:= Nil
Local oRet			:= Nil
Local oReturn		:= Nil
Local _aColeta		:= Array(4)
Local cAviso		:= ''
Local cErro			:= ''
Local cRet			:= ''
Local _cAS			:= ''
Local _aCNPJSupl	:= {}
Local _aColAddress	:= {}
Local _aColOutDt	:= {}
Local _aTarAddress	:= {}
Local _aExitFee		:= {}	
Local _cUserName	:= GetNewPar("ES_ITGUSER",'valeria.vasconcelos')
Local _cPassWord	:= GetNewPar("ES_ITGPASS",'4h8dk983sxy987shkl85ffsw')
Local _cWSDL		:= GetNewPar("ES_ITGWSDL",'http://www.vitgbrasil.com.br:80/vedi/vitgrfqws?wsdl')
Local _aRecNo		:= {}
Local _aLog			:= {}
Local _cAST			:= ''
Local _cViagem		:= ''
Local _cDatColeta	:= ''

AFill(_aColeta,'')

Private Trab		:= GetNextAlias()
Private lSchedule	:= StaticCall(GEFXMLROB,xSchedule,.F.)

DEFAULT _cTipoOper := "I" 

// Cria o objeto da classe TWsdlManager
oWsdl := TWsdlManager():New()

// Faz o parse de uma URL
xRet := oWsdl:ParseURL( _cWSDL ) // "http://www.vitgbrasil.com.br:80/vedi/vitgrfqws?wsdl"

Begin Sequence
	If xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		AADD(_aLog)
		BREAK
	EndIf
	
	If lSchedule
		RpcSetType( 3 )
		RpcSetEnv( cRpcEmp,cRpcFil,/*cEnvUser*/,/*cEnvPass*/,cEnvMod,cFunName,/*aTables*/,/*lShowFinal*/,/*lAbend*/,/*lOpenSX*/,/*lConnect*/ )
	EndIf
	
	 aOps := oWsdl:ListOperations()
	
	If Len( aOps ) == 0
		conout( "Erro: " + oWsdl:cError )
		AADD(_aLog)
		BREAK		
	EndIf
	
	varinfo( "", aOps )
	
	// Define a operação
	
	If _cTipoOper == "I"
		// xRet := oWsdl:SetOperation( "importRfQInfo" )
		xRet := oWsdl:SetOperation( "importRfQAuthInfoArray" )	
	ElseIf	_cTipoOper == "E"
		xRet := oWsdl:SetOperation( "exportRfQAuthInfo" )
		// xRet := oWsdl:SetOperation( aOps[1][1] )
	EndIf	
	
	If xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		AADD(_aLog)
		BREAK
	EndIf
	
	aComplex := oWsdl:NextComplex()
	
	varinfo( "", aComplex )
	
	aDados := oWsdl:SimpleInput()
	
	varinfo( "", aDados )
	
	//				oWsdl:AddHttpHeader( "Username", "valeria.vasconcelos" )
	//				oWsdl:AddHttpHeader( "Password", "4h8dk983sxy987shkl85ffsw" )
	
	xRet := oWsdl:SetValueS( aDados[userName][1], {_cUserName} )
	If xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		AADD(_aLog)
		BREAK
	EndIf
	
	xRet := oWsdl:SetValueS( aDados[password][1], {_cPassWord} )
	If xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		AADD(_aLog)
		BREAK
	EndIf
	
	xRet := oWsdl:SetValueS( aDados[orgCode][1], {'60014'} )
	If xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		AADD(_aLog)
		BREAK
	EndIf
End Sequence

If !xRet
 	fEnvLog(_aLog,1)
 	Return
EndIf

_aLog := {}

If _cTipoOper == "I"
// Define o valor de cada parâmeto necessário
// xRet := oWsdl:SetValue( 0, "90210" )
	
	// Busca viagem para enviar para o Portal
	If fBuscaDados('I')


		While !((TRAB)->(Eof()))
	
			Begin Sequence
				
				xRet := oWsdl:SetValueS( aDados[referenceNumber][1], { AllTrim((TRAB)->(DTQ_AS)) + IIF(Empty(AllTrim((TRAB)->ZA6_PEDCLI)),'','-' + AllTrim((TRAB)->ZA6_PEDCLI))} )
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					AADD(_aLog, { "Erro: " + oWsdl:cError, AllTrim((TRAB)->(DTQ_AS)), AllTrim((TRAB)->DTQ_VIAGEM) })
					Break
				EndIf

				// xRet := oWsdl:SetValue( aDados[creationDate][1], DTOS(DATE())+ " 15:30:00" )
				xRet := oWsdl:SetValueS( aDados[creationDate][1],  {xFormata("creationDate")} ) // 2016-12-28T15:30:00 
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					AADD(_aLog, { "Erro: " + oWsdl:cError, AllTrim((TRAB)->(DTQ_AS)), AllTrim((TRAB)->DTQ_VIAGEM) })
					Break
				EndIf
				
				xRet := oWsdl:SetValueS( aDados[vehicleType][1], {xFormata("vehicleType")} ) // Tipo de Veiculo
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					AADD(_aLog, { "Erro: " + oWsdl:cError, AllTrim((TRAB)->(DTQ_AS)), AllTrim((TRAB)->DTQ_VIAGEM) })
					Break
				EndIf
				
				xRet := oWsdl:SetValueS( aDados[totalFee][1], {xFormata('totalFee')} ) // Pedágio total
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					AADD(_aLog, { "Erro: " + oWsdl:cError, AllTrim((TRAB)->(DTQ_AS)), AllTrim((TRAB)->DTQ_VIAGEM) })
					Break
				EndIf

				xRet := oWsdl:SetValueS( aDados[tripNumber][1], {AllTrim((TRAB)->DTQ_VIAGEM)} )
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					AADD(_aLog, { "Erro: " + oWsdl:cError, AllTrim((TRAB)->(DTQ_AS)), AllTrim((TRAB)->DTQ_VIAGEM) })
					Break
				EndIf

				_aColeta 	:= xFormata('Colecao')
				_cDatColeta	:= _aColeta[4] 
						
				xRet := oWsdl:SetValueS( aDados[kmTotal][1], {_aColeta[1]} )
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					AADD(_aLog, { "Erro: " + oWsdl:cError, AllTrim((TRAB)->(DTQ_AS)), AllTrim((TRAB)->DTQ_VIAGEM) })
					Break
				EndIf

				_cAS 		:= (TRAB)->(DTQ_AS)
				_cViagem 	:= (TRAB)->(DTQ_VIAGEM)
				
				While !((TRAB)->(Eof())) .AND. (TRAB)->(DTQ_AS) == _cAS  

					AADD(_aCNPJSupl, 	_aColeta[2] )
					AADD(_aColAddress, 	_aColeta[3] )
					AADD(_aColOutDt,	IIF( Empty(_aColeta[4]),_cDatColeta,_aColeta[4] ) )
					AADD(_aTarAddress,	_aColeta[5] )
					AADD(_aExitFee,		xFormata('exitFee') )	

					AADD(_aRecNo, (TRAB)->nRecno)
						
					(TRAB)->(dbSkip())
					
					If !((TRAB)->(Eof()))
						_aColeta := xFormata('Colecao')
					EndIf	
					
				End

				// TAG´s que se repete
				xRet := oWsdl:SetValueS( aDados[cnpjSupplierCollection][1], _aCNPJSupl )
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					AADD(_aLog, { "Erro: " + oWsdl:cError, AllTrim(_cAS), AllTrim(_cViagem) })
					Break
				EndIf
							
				xRet := oWsdl:SetValueS( aDados[collectionAddress][1], _aColAddress )
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					AADD(_aLog, { "Erro: " + oWsdl:cError, AllTrim(_cAS), AllTrim(_cViagem) })
					Break
				EndIf
							
				xRet := oWsdl:SetValueS( aDados[collectionOutDate][1], _aColOutDt) // "2016-12-04T16:30:00" 
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					AADD(_aLog, { "Erro: " + oWsdl:cError, AllTrim(_cAS), AllTrim(_cViagem) })
					Break
				EndIf
							
				xRet := oWsdl:SetValueS( aDados[targetAddress][1], _aTarAddress )
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					AADD(_aLog, { "Erro: " + oWsdl:cError, AllTrim(_cAS), AllTrim(_cViagem) })
					Break
				EndIf
							
				xRet := oWsdl:SetValueS( aDados[exitFee][1], _aExitFee )  // Pedágio do Trecho
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					AADD(_aLog, { "Erro: " + oWsdl:cError, AllTrim(_cAS), AllTrim(_cViagem) })
					Break
				EndIf
									
				// Exibe a mensagem que será enviada
				conout( oWsdl:GetSoapMsg() )
				
//				oWsdl:AddHttpHeader( "Username", "valeria.vasconcelos" )
//				oWsdl:AddHttpHeader( "Password", "4h8dk983sxy987shkl85ffsw" )
				
				// Envia a mensagem SOAP ao servidor
				xRet := oWsdl:SendSoapMsg()
				
				If xRet == .F.
					If lSchedule				
						conout( "Erro: " + oWsdl:cError )
					Else
						Alert( "Erro: " + oWsdl:cError )
					EndIf							
					AADD(_aLog, { "Erro: " + oWsdl:cError, AllTrim(_cAS), AllTrim(_cViagem) })
					Break
				EndIf

				// Pega a mensagem de resposta
				// conout( oWsdl:GetSoapResponse() )
				
				cXMLRet	:= oWsdl:GetSoapResponse()

				oXMLRet 	:= XmlParser(cXMLRet,"_",@cAviso,@cErro)
				
				oRet 		:= XmlChildEx( oXMLRet:_S_ENVELOPE:_S_BODY:_NS2_ImportRfQAuthInfoArrayResponse,"_RETURN" ) 

				If !Empty(cErro)
					If lSchedule				
						ConOut('XMLParser: ' + cErro)
					Else
						Alert('XMLParser: ' + cErro)
					EndIf
												
					AADD(_aLog, { "Erro: " + cErro, AllTrim(_cAS), AllTrim(_cViagem) })
					Break
				EndIf
					 								
				// Se o envio foi bem sucedido, atualizar status da Viagem
				If  oRet:TEXT == 'success'
					If lSchedule
						ConOut('AST ' + AllTrim(_cAS) + ' Enviado com sucesso!')
					Else					
						ALERT('AST ' + AllTrim(_cAS) + ' Enviado com sucesso!')
					EndIf
					
					dbSelectArea('DTQ')
					For y := 1 to Len(_aRecNo)
						// DTQ->(dbGoTo((TRAB)->nRecno))
						DTQ->(dbGoTo(_aRecNo[y]))
						If RecLock('DTQ',.F.)
							DTQ->DTQ_XITGDT := dDATABASE
							DTQ->DTQ_XITGHR := Time()
						EndIf
					Next y
					
					dbSelectArea((TRAB))

					AADD(_aLog, { "Incluido com sucesso", AllTrim(_cAS), AllTrim(_cViagem) })

				Else
					If lSchedule
						ConOut(oRet:TEXT)
					Else
						Alert(oRet:TEXT)
					EndIf
						
					AADD(_aLog, { "Erro: " + oRet:TEXT, AllTrim(_cAS), AllTrim(_cViagem) })
				EndIf
				
				_aRecNo := {}
				
				ConOut("Retorno do WS ITG - AST: " + AllTrim(_cAS) + " ==> " + oRet:TEXT)
				
			End Sequence
		End
		
		fEnvLog(_aLog,2)
				
	EndIf		
Else
	// Exportação
	// Busca viagem do Portal e atualiza o GPO
	If fBuscaDados('E')

		While !((TRAB)->(Eof()))
	
			Begin Sequence
			/*
				xRet := oWsdl:SetValue( aDados[orgCode][1], '60014' )
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					Break
				EndIf
			*/				
				xRet := oWsdl:SetValue( aDados[referenceNumber][1], AllTrim((TRAB)->DTQ_AS) + IIF(Empty((TRAB)->ZA6_PEDCLI),'','-' + AllTrim((TRAB)->ZA6_PEDCLI)) )
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					AADD(_aLog, { "Erro: " + oWsdl:cError, AllTrim((TRAB)->(DTQ_AS)), AllTrim((TRAB)->DTQ_VIAGEM) })
					Break
				EndIf
				
				xRet := oWsdl:SetValue( aDados[tripNumber][1], AllTrim((TRAB)->DTQ_VIAGEM) )				
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					AADD(_aLog, { "Erro: " + oWsdl:cError, AllTrim((TRAB)->(DTQ_AS)), AllTrim((TRAB)->DTQ_VIAGEM) })					
					Break
				EndIf
				
				// Exibe a mensagem que será enviada
				conout( oWsdl:GetSoapMsg() )
				
				//oWsdl:AddHttpHeader( "Username", "valeria.vasconcelos" )
				//oWsdl:AddHttpHeader( "Password", "4h8dk983sxy987shkl85ffsw" )
				
				// Envia a mensagem SOAP ao servidor
				xRet := oWsdl:SendSoapMsg()
				
				If xRet == .F.
					If lSchedule
						ConOut( "Erro: " + oWsdl:cError )
					Else
						Alert( "Erro: " + oWsdl:cError )
					EndIf							
					AADD(_aLog, { "Erro: " + oWsdl:cError, AllTrim((TRAB)->(DTQ_AS)), AllTrim((TRAB)->DTQ_VIAGEM) })
					Break
				EndIf

				// Pega a mensagem de resposta
				ConOut( oWsdl:GetSoapResponse() )
				cXMLRet	:= oWsdl:GetSoapResponse()

				oXMLRet 	:= XmlParser(cXMLRet,"_",@cAviso,@cErro)

				If !Empty(cErro)
					If lSchedule				
						ConOut('XMLParser: ' + cErro)
					Else	
						Alert('XMLParser: ' + cErro)
					EndIf						
					AADD(_aLog, { "XMLParser: " + cErro, AllTrim((TRAB)->(DTQ_AS)), AllTrim((TRAB)->DTQ_VIAGEM) })					
					Break
				EndIf

				oReturn		:= XmlChildEx( oXMLRet:_S_ENVELOPE:_S_BODY:_NS2_ExportRfQAuthInfoResponse,"_NS2_MESSAGE" )
				
				If  oReturn:TEXT == 'success'

					If lSchedule
						ConOut("Retornado dados do WS ITG com sucesso - AST: " + AllTrim((TRAB)->DTQ_AS))
					Else
						Alert("Retornado dados do WS ITG com sucesso - AST: " + AllTrim((TRAB)->DTQ_AS))
					EndIf

					AADD(_aLog, { "Retornado dados do WS ITG com sucesso", AllTrim((TRAB)->(DTQ_AS)), AllTrim((TRAB)->DTQ_VIAGEM) })
					
					// Atualiza base do GPO	com os dados do motorias
					oRet 		:= XmlChildEx( oXMLRet:_S_ENVELOPE:_S_BODY,"_NS2_EXPORTRFQAUTHINFORESPONSE" )

					If fIntITGGpo(oRet:_NS2_DriverCPF:TEXT, oRet:_NS2_LicensePlate1:TEXT, oRet:_NS2_LicensePlate2:TEXT, oRet:_NS2_transporterCNPJ:TEXT)
					
						AADD(_aLog, { "Retornado dados do WS ITG com sucesso", AllTrim((TRAB)->(DTQ_AS)), AllTrim((TRAB)->DTQ_VIAGEM) })					
					EndIf	
/*
					dbSelectArea('DTQ')
					DTQ->(dbGoTo((TRAB)->nRecno))
					If RecLock('DTQ',.F.)
						DTQ->DTQ_XEXITG := dDATABASE
						DTQ->DTQ_XHREXP := Time()
					EndIf
					dbSelectArea((TRAB))
*/
				Else	
					// Se o recebimento não foi bem sucedido
					// ALERT(oReturn:TEXT)
					If lSchedule
						ConOut("NÃO Retornado do WS ITG - AST: " + AllTrim((TRAB)->DTQ_AS) + " ==> " + oReturn:TEXT)
					Else
						ConOut("NÃO Retornado do WS ITG - AST: " + AllTrim((TRAB)->DTQ_AS) + " ==> " + oReturn:TEXT)
					EndIf

					AADD(_aLog, { "NÃO Retornado do WS ITG: " + oReturn:TEXT, AllTrim((TRAB)->(DTQ_AS)), AllTrim((TRAB)->DTQ_VIAGEM) })												

				EndIf	

				// Montar Log
				
			End Sequence
						
			(TRAB)->(dbSkip())
		End

		fEnvLog(_aLog,2)

	EndIf			
	
EndIf	

If Select( TRAB ) # 0
	(Trab)->(DbCloseArea())
EndIf

Return

/*/{Protheus.doc} fBuscaDados
(Busca da dados na tabelas do GPO)
@type function Executa query
@author u297686 - Ricardo Guimarães
@since 29/12/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function fBuscaDados(_cTpOPer)
Local _lRet 	:= .F.
Local _Where	:= ''
Local _aLastQuery := {}
Local _cUO		:= ''
Local _cTpViagem:= GetNewPar('ES_TPVIAG','M') // M=MILK RUN - 6=FTL - T=LINE WALL

/*
_cWhere := " And DTC_LOTNFC >= '" + MV_PAR01	+ "' And DTC_LOTNFC <= '" + MV_PAR02 + "' "
_cWhere += " And DTC_NFEID  = '' " 
_cWhere += " And DTC_DOC  	= '' "

If MV_PAR03 == 'OVL'
	_cWhere += " And SUBSTRING(DTC_CCUSTO,1,3) IN " + FORMATIN(GETMV("MV_XOVLCC"),"|")
ElseIf MV_PAR03 == 'FVL'
	_cWhere += " And SUBSTRING(DTC_CCUSTO,1,3) IN " + FORMATIN(GETMV("MV_XTLACC"),"|")
EndIf

*/

_cWhere := " AND DTQ_FILORI='20' "  
_cWhere += " AND DTQ_DATGER = '20170105' " 
_cWhere += " AND DTQ_NUMCTR='' 	" 
_cWhere += " AND DTQ_ACEITE<>''	"
_cWhere += " AND DTQ_STATUS='6'	"
// INCLUR FILTRO PARA NÃO ENVIAR AQUELES QUE JÁ FORAM ENVIADOS
//_cWhere += " AND DTQ_XITGDT<>''	"

If Select( Trab ) # 0
	(Trab)->(DbCloseArea())
EndIf

If _cTpOper == 'I' // Importação ( Envio para o Portal )

	// INCLUR FILTRO PARA NÃO ENVIAR AQUELES QUE JÁ FORAM ENVIADOS
	//_cWhere += " AND DTQ_XITGDT=''	"

//	_cWhere += " And ZA6_MODELO IN " + FORMATIN(_cTpViagem,"|")

	_cWhere := "%"+_cWhere+"%"

	BeginSql Alias Trab
	
		SELECT DTQ_FILORI, DTQ_VIAGEM, DTQ_DATGER, DTQ_HORGER, DTQ_DATINI, DTQ_HORINI, DTQ_DATFIM, DTQ_HORFIM, 
			   DTQ_AS, DTQ_SOT, DTQ_TOTFRE, DTQ_CCC, DTQ_VRPEDA, DTQ_ACEITE, DTQ_OBRA, DTQ.R_E_C_N_O_ AS NRECNO,
			   ZA7_PROJET, ZA7_OBRA, ZA7_SEQTRA, ZA7_SEQCAR, ZA7_CARGA, ZA7_JUNTO, ZA7_DTCAR, ZA7_HRCAR, 
			   ZA7_DTDES, ZA7_HRDES, ZA7_CODCLI, ZA7_LOJCLI, ZA7_DESCLI, ZA7_CLIDES, ZA7_LOJDES, ZA7_NOMDES, 
			   ZA7_KMDESL, ZA7_SKMVEN, ZA7_KMPREV, ZA7_PEDCLI, ZA7_VALPED, ZA6_PEDCLI  
		  FROM %Table:DTQ% DTQ 
		  INNER JOIN %Table:ZA0% ZA0 (NOLOCK) 
		       ON DTQ_CONTRA = ZA0_PROJET AND ZA0_ITGWS='S'		  
		  LEFT JOIN %Table:ZA7% ZA7 (NOLOCK)
		  		ON DTQ_FILORI = ZA7_FILIAL AND DTQ_AS = ZA7_AS AND DTQ_VIAGEM = ZA7_VIAGEM 
		  LEFT JOIN %Table:ZA6% ZA6 (NOLOCK)
		  		ON ZA7_FILIAL = ZA6_FILIAL AND DTQ_AS = ZA6_AS 		  		
		 WHERE DTQ.%NotDel%
		   AND ZA6.%NotDel%		 
		   AND ZA7.%NotDel%
		   AND ZA0.%NotDel%		   

			%Exp:_cWhere%

		   AND NOT EXISTS ( SELECT DTR_FILORI, DTR_VIAGEM 
		                      FROM %Table:DTR% DTR (NOLOCK) 
		                     WHERE DTQ.DTQ_FILORI = DTR.DTR_FILORI AND DTQ.DTQ_VIAGEM = DTR.DTR_VIAGEM AND DTR.%NotDel% )
		ORDER BY DTQ_AS, DTQ_FILORI, DTQ_VIAGEM, ZA7_JUNTO, DTQ_DATGER, DTQ_HORGER		                     
	
	EndSql

Else
	// 'E' - Exportação ( Busca do Portal)
	
	// INCLUR FILTRO PARA IR BUSCAR SOMENTE AQUELES QUE FORAM ENVIADOS E AINDA NÃO RETORNARAM 
	//_cWhere += " AND DTQ_XITGDT<>''	"
	//_cWhere += " AND DTQ_XITGDR=''	"	

	_cWhere := "%"+_cWhere+"%"
		
	BeginSql Alias Trab
	
		SELECT DTQ_FILORI, DTQ_VIAGEM, DTQ_DATGER, DTQ_HORGER, DTQ_DATINI, DTQ_HORINI, DTQ_DATFIM, DTQ_HORFIM, 
			   DTQ_AS, DTQ_SOT, DTQ_TOTFRE, DTQ_CCC, DTQ_VRPEDA, DTQ_ACEITE, DTQ_OBRA, ZA6_PEDCLI, 
			   DTQ.R_E_C_N_O_ AS NRECNO
		  FROM %Table:DTQ% DTQ
		 INNER JOIN %Table:ZA0% ZA0 (NOLOCK) 
		       ON DTQ_CONTRA = ZA0_PROJET AND ZA0_ITGWS='S'
		  LEFT JOIN %Table:ZA6% ZA6 (NOLOCK)
		  	   ON DTQ_FILORI = ZA6_FILIAL AND DTQ_AS = ZA6_AS 		  		
		 WHERE DTQ.D_E_L_E_T_=''
		   AND ZA0.D_E_L_E_T_=''	   
		   AND ZA6.D_E_L_E_T_=''
		   %Exp:_cWhere%
			
		ORDER BY DTQ_AS, DTQ_FILORI, DTQ_VIAGEM, DTQ_JUNTO, DTQ_DATGER, DTQ_HORGER
				                     			
	EndSql
EndIf

_aLastQuery := GetLastQuery()

dbSelectArea(Trab) ; dbGoTop()

If !Eof()
	_lRet := .T.
Else
	If _cTpOper == 'I'
		If lSchedule
			CONOUT("WS ITG - Não há registros de viagem a serem enviados ao portal.")
		Else	
			Alert("WS ITG - Não há registros de viagem a serem enviados ao portal.")
		EndIf			
	Else
		If lSchedule
			CONOUT("WS ITG - Não há registros de viagem a serem retornados do portal.")
		Else
			Alert("WS ITG - Não há registros de viagem a serem retornados do portal.")
		EndIf				
	EndIf				
EndIf
	
Return( _lRet )

/*/{Protheus.doc} xFormata
(formata dados para serem enviado no WS)
@type function xFormata
@author u297686 - Ricardo Guimarães
@since 30/12/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function xFormata(_cTAG)
Local _cCampo 	:= ''
Local _cTransp	:= ''
Local _aColeta	:= Array(5)
Local _aColAux1	:= {}
Local _aColAux2	:= {}

If _cTAG == 'creationDate'
	_cCampo := Transform((TRAB)->DTQ_DATINI, '@R 9999-99-99') + 'T' + Transform((TRAB)->DTQ_HORINI, '@R 99:99') + ':00'    
	
ElseIf _cTAG == 'collectionOutDate'
	_cCampo := Transform((TRAB)->DTQ_DATFIM, '@R 9999-99-99') + 'T' + Transform((TRAB)->DTQ_HORFIM, '@R 99:99') + ':00'

ElseIf _cTAG == 'totalFee'
	_cCampo := AllTrim(Transform((TRAB)->DTQ_VRPEDA, '@R 999999999.99')) 

ElseIf _cTAG == 'exitFee'
	_cCampo := AllTrim(Transform((TRAB)->DTQ_VRPEDA, '@R 999999999.99'))  
	
ElseIf _cTAG == 'vehicleType'
	_cTransp 	:= GetAdvFVal('ZA6','ZA6_TRANSP',(TRAB)->DTQ_FILORI + (TRAB)->DTQ_AS,2,"")
	_cCampo 	:= AllTrim(GetAdvFVal('DUT','DUT_DESCRI',xFilial('DUT') + _cTransp,1,""))	

ElseIf _cTAG == 'Colecao'
	AFill(_aColeta ,'')

	_cViagPri 	:= GetAdvFVal('ZA6','ZA6_VIAGEM',(TRAB)->DTQ_FILORI + (TRAB)->DTQ_AS,2,"")
				
//	_aColAux1	:= GetAdvFVal('ZA7',{'ZA7_CODCLI','ZA7_LOJCLI','ZA7_CLIDES','ZA7_LOJDES','ZA7_KMPREV','ZA7_DTCAR', 'ZA7_HRCAR'},(TRAB)->DTQ_FILORI + (TRAB)->DTQ_SOT + (TRAB)->DTQ_OBRA + _cViagPri,2,{})
	_aColAux1	:= GetAdvFVal('ZA7',{'ZA7_CODCLI','ZA7_LOJCLI','ZA7_CLIDES','ZA7_LOJDES','ZA7_KMPREV','ZA7_DTCAR', 'ZA7_HRCAR'},(TRAB)->DTQ_FILORI + (TRAB)->DTQ_SOT + (TRAB)->DTQ_OBRA + (TRAB)->DTQ_VIAGEM,2,{})	
	_aColAux2	:= GetAdvFVal('SA1',{'A1_CGC','A1_END','A1_COMPLEM','A1_BAIRRO','A1_MUN','A1_EST'},xFilial('SA1') + _aColAux1[1] + _aColAux1[2],1,{})	
	
	If Len(_aColAux1) > 0
		_aColeta[1] := cValtoChar(_aColAux1[5])   // Km Total
	EndIf	  
	
	If Len(_aColAux2) > 0
		_aColeta[2] := _aColAux2[1] // CNPJ
		_aColeta[3] := AllTrim(_aColAux2[2]) + ' - ' + AllTrim(_aColAux2[3]) + IIF(!Empty(AllTrim(_aColAux2[3])),' - ','') + AllTrim(_aColAux2[4]) + ' - ' + AllTrim(_aColAux2[5]) + ' - ' + AllTrim(_aColAux2[6])  // END COLETA
		_aColeta[4] := IIF(Empty(_aColAux1[6]),'',Transform(DTOS(_aColAux1[6]), '@R 9999-99-99') + 'T' + Transform(_aColAux1[7], '@R 99:99')  + ':00')   // Data e Hora
	EndIf
	
	_aColAux2 	:= GetAdvFVal('SA1',{'A1_END','A1_COMPLEM','A1_BAIRRO','A1_MUN','A1_EST'},xFilial('SA1') + _aColAux1[3] + _aColAux1[4],1,{}) // Destino
	If Len(_aColAux2) > 0
		_aColeta[5] := AllTrim(_aColAux2[1]) + ' - ' + AllTrim(_aColAux2[2]) + IIF(!Empty(AllTrim(_aColAux2[2])),' - ','') + AllTrim(_aColAux2[3]) + ' - ' + AllTrim(_aColAux2[4]) + ' - ' + AllTrim(_aColAux2[5])  // END DESTINO 
	EndIf

	_cCampo := _aColeta

EndIf

Return _cCampo


/*/{Protheus.doc} fIntITGGPO ( Atualiza GPO com os dados de Aceite da Transportadora - ITG x GPO)
@type function fIntITGGPO
@author u297686 - Ricardo Guimarães
@since 10/02/2017
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function fIntITGGpo( _cCPFMot, _cPlaca1, _cPlaca2, _cCNPJTransp )

_cCPFMot 		:= StrTran(StrTran(_cCPFMot,'.',''),'-','')
_cCNPJTransp	:= StrTran(StrTran(StrTran(_cCNPJTransp,'.',''),'-',''),'/','')
					
Alert("CPF: " 	+ _cCPFMot 		+ CRLF +; 
	  "Placa: " + _cPlaca1 		+ CRLF +; 
	  "CNPJ: " 	+ _cCNPJTransp 	+ CRLF )

Return .T.

/*/{Protheus.doc} fEnvLog ( Envia Log de Processamento por e-mail)
@type function fEnvLog(_aLog,_nPart)
@author u297686 - Ricardo Guimarães
@since 14/02/2017
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/static Function fEnvLog(_aLog, _nPart)
Local _lRet 	:= .t.
Local _cMail 	:= GetNewPar("ES_ITGLOG", 'jose.guimaraes@gefco.com.br') 
Local _cMsg		:= ''
Local _cAssunto	:= ''

// Envia e-mail
_cAssunto 	:= "Portal de Fornecedores - ITG - Processamento de Viagem "
_cMsg 		:= ''
If _nPart == 1
	_cMsg := ''
	For x:=1 to Len(_aLog)
		_cMsg := _aLog[x] + CRLF
	Next x
Else
	_cMsg := '<HTML>' + CRLF
	_cMsg += '<H1>'   + "Portal de Fornecedores - ITG " + " foi processado em " + DtoC(dDATABASE) + " " + Time() + '</H1>' + CRLF
	// <H2>TESTE</H1>
	_cMsg += '<TABLE border="2">' + CRLF
	_cMsg += '	<th>AST</th>' + CRLF
	_cMsg += '	<th>Viagem</th>' + CRLF
	_cMsg += '	<th>Mensagem</th>' + CRLF
	
	For x := 1 to Len(_aLog)
		_cMsg += '	<tr>' + CRLF
		_cMsg += '		<td>' + cValtoChar(_aLog[x,2]) + '</td>' + CRLF
		_cMsg += '		<td>' + cValtoChar(_aLog[x,3]) + '</td>' + CRLF
		_cMsg += '		<td>' + cValtoChar(_aLog[x,1]) + '</td>' + CRLF
		_cMsg += '	</tr>' + CRLF
	Next x
	
	_cMsg += '</TABLE>' + CRLF
	_cMsg += '</HTML>' 	+ CRLF
EndIf	

U_EnvEmail(GETMV("MV_RELFROM"),_cMail,,_cAssunto,_cMsg)

Return _lRet


// ---------------------- TESTE
/*
BEGIN SEQUENCE
				xRet := oWsdl:SetValueS( aDados[referenceNumber][1], {'TESTE-1'} )
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					Break
				EndIf

				// xRet := oWsdl:SetValue( aDados[creationDate][1], DTOS(DATE())+ " 15:30:00" )
				xRet := oWsdl:SetValueS( aDados[creationDate][1],  {'2016-12-28T15:30:00'}) // 2016-12-28T15:30:00 
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					Break
				EndIf
				
				xRet := oWsdl:SetValueS( aDados[vehicleType][1], {'Carreta Sider'}) // Tipo de Veiculo
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					Break
				EndIf
				
				xRet := oWsdl:SetValueS( aDados[totalFee][1], {'71.99'} ) // Pedágio total
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					Break
				EndIf

						xRet := oWsdl:SetValueS( aDados[tripNumber][1], {'654321'} )
						If xRet == .F.	
							conout( "Erro: " + oWsdl:cError )
							Break
						EndIf
						
						xRet := oWsdl:SetValueS( aDados[kmTotal][1], {'561'} )
						If xRet == .F.
							conout( "Erro: " + oWsdl:cError )
							Break
						EndIf

						_aAux := {}
						AADD(_aAux, '02.042.860/0001-13')
						AADD(_aAux, '03.094.658/0001-06')
						
						xRet := oWsdl:SetValueS( aDados[cnpjSupplierCollection][1], _aAux )
						If xRet == .F.
							conout( "Erro: " + oWsdl:cError )
							Break
						EndIf

						_aAux := {}
						AADD(_aAux, 'AV CONTORNO, 3455-GALPAO 8, PAULO CAMILO, BETIM, MG')
						AADD(_aAux, 'AV CONTORNO, 1234-GALPAO 9, PAULO CAMILO, BETIM, MG')												
						xRet := oWsdl:SetValueS( aDados[collectionAddress][1], _aAux )
						If xRet == .F.
							conout( "Erro: " + oWsdl:cError )
							Break
						EndIf
						
						_aAux := {}
						AADD(_aAux, '2016-12-04T16:30:00')
						AADD(_aAux, '2016-12-10T16:30:00')						
						xRet := oWsdl:SetValueS( aDados[collectionOutDate][1], _aAux) // "2016-12-04T16:30:00" 
						If xRet == .F.
							conout( "Erro: " + oWsdl:cError )
							Break
						EndIf
						
						_aAux := {}
						AADD(_aAux, 'AV CONTORNO, 3455-GALPAO 8, PAULO CAMILO, BETIM, MG')						
						AADD(_aAux, 'AV CONTORNO, 1234-GALPAO 9, PAULO CAMILO, BETIM, MG')						
						xRet := oWsdl:SetValueS( aDados[targetAddress][1], _aAux )
						If xRet == .F.
							conout( "Erro: " + oWsdl:cError )
							Break
						EndIf
						
						_aAux := {}
						AADD(_aAux, '26.60')
						AADD(_aAux, '29.90')
						xRet := oWsdl:SetValueS( aDados[exitFee][1], _aAux)  // Pedágio do Trecho
						If xRet == .F.
							conout( "Erro: " + oWsdl:cError )
							Break
						EndIf

				// Exibe a mensagem que será enviada
				conout( oWsdl:GetSoapMsg() )
				
//				oWsdl:AddHttpHeader( "Username", "valeria.vasconcelos" )
//				oWsdl:AddHttpHeader( "Password", "4h8dk983sxy987shkl85ffsw" )
				
				// Envia a mensagem SOAP ao servidor
				
				xRet := oWsdl:SendSoapMsg()
				
				If xRet == .F.
					conout( "Erro: " + oWsdl:cError )
					Break
				EndIf

				// Pega a mensagem de resposta
				//ConOut( oWsdl:GetSoapResponse() )
				
				cXMLRet	:= oWsdl:GetSoapResponse()

				oXMLRet 	:= XmlParser(cXMLRet,"_",@cAviso,@cErro)
				
				oRet 		:= XmlChildEx( oXMLRet:_S_ENVELOPE:_S_BODY:_NS2_IMPORTRFQAUTHINFOARRAYRESPONSE,"_RETURN" ) 

				If !Empty(cErro)
					ConOut('XMLParser: ' + cErro)
					Break
				EndIf


END SEQUENCE
*/

