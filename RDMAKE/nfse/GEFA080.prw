/*__________________________________________________________________________________
|¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦|
|¦¦+----------------------------------------------------------------------------+¦¦|
|¦¦| Cliente   | Gefico                                   | Data   | 15/10/2013 |¦¦|
|¦¦|-----------+----------------------------------------------------------------|¦¦|
|¦¦| Programa  | GEFA008   | Tipo |Rotina de Envio E-mail   | Módulo | SIGAFAT  |¦¦|
|¦¦|-----------+----------------------------------------------------------------|¦¦|
|¦¦| Autor     | Rafael Rezende        | Empresa | Idéias Tecnologia            |¦¦|
|¦¦|-----------+----------------------------------------------------------------|¦¦|
|¦¦| Descrição |   Rotina com o objetivo de enviar o arquivo XML de uma nota de |¦¦|
|¦¦|           |serviços para o Cliente.                                        |¦¦|
|¦¦|-----------+----------------------------------------------------------------|¦¦|
|¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦|
|¦¦|----------------------------------------------------------------------------|¦¦|
|¦¦| Alteração da Rotina                                  | Data   | 14/11/2013 |¦¦|
|¦¦|----------------------------------------------------------------------------|¦¦|
|¦¦| Autor     |  André Costa          | Empresa | Idéias Tecnologia            |¦¦|
|¦¦|----------------------------------------------------------------------------|¦¦|
|¦¦| Motivo    | Colocação do filtro de Filial, acerto no envio do XML das      |¦¦|
|¦¦|           | empresas 07,20 e 21 pois não saia correto e colocação do Check |¦¦|
|¦¦|           | Box de Inversão de Seleção												  |¦¦|
|¦¦+----------------------------------------------------------------------------+¦¦|
|¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦|
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

//#Include "RDmAKe.Ch"
#Include "Protheus.Ch"
#Include "TopConn.Ch"
#Include "Ap5Mail.Ch"
#Include "TbiConn.Ch"

*---------------------*
User Function GEFA080
*---------------------*
	Local _nOpc       := 0
	Local _oBtnOk		:= Nil
	Local _oBtnParam	:= Nil
	Local _oBtnSair	:= Nil
	Local _oGroupMsg	:= Nil
	Local _oSayMsg		:= Nil
	Local _oFontMsg	:= TFont():New( "Arial",, 018,, .F.,,,,, .F., .F. )
	Local _oFontBtn 	:= TFont():New( "Arial",, 017,, .T.,,,,, .F., .F. )
	Local _cMensagem	:= "Selecione os Parâmetros desejados através do Botão Parâmetros e então confirme o Processamento."

	Private _cPerg 	:= "GEFA008X"
	Private _oDlgTela	:= Nil

	MsgRun(	"Aguarde, gerando as perguntas de parâmetros",;
				"Aguarde, gerando as perguntas de parâmetros",;
				{ || FAjustaSX1( _cPerg ) } )

	Pergunte( _cPerg, .F. )

	Define MsDialog _oDlgTela Title "Envio de Arquivo XML da NF Serviço para o Cliente" From 000, 000  To 190, 340 Colors 0, 16777215 Pixel

		@ 005, 005 Group _oGroupMsg To 069, 163 Of _oDlgTela Color 0, 16777215 Pixel
		@ 013, 010 Say _oSayMsg Prompt _cMensagem Size 145, 060 Of _oDlgTela Font _oFontMsg Colors 16711680, 16777215 HTML Pixel

		_oSayMsg:lWordWrap := .T.

		@ 075, 010 Button _oBtnOk    Prompt "Selec. NFs" Size 040, 012 Of _oDlgTela Font _oFontBtn Pixel Action( _nOpc := 01, _oDlgTela:End() )
		@ 075, 065 Button _oBtnParam Prompt "Parâmetros" Size 040, 012 Of _oDlgTela Font _oFontBtn Pixel Action( Pergunte( _cPerg, .T. ) )
		@ 075, 118 Button _oBtnSair  Prompt "Sair" 		 Size 040, 012 Of _oDlgTela Font _oFontBtn Pixel Action( _nOpc := 00, _oDlgTela:End() )

	Activate MsDialog _oDlgTela Centered

	If _nOpc == 01
		FMostraNFs()
	End If

Return

*--------------------------*
Static Function FMostraNFs()
*--------------------------*
	Local _nY     					:= 0
	Local _nPosSelecionou 		:= 01
	Local _aAnexos 				:= {}
	Local _cEmailTo 		   	:= ""

	Private _cArqXML				:= ""
	Private _aNotas 				:= {}
	Private _cTabSpedEntidades := AllTrim( GetNewPar( "MV_XTSPDEN", "DADOSADV.dbo.SPED001" ) )      // Aletração com Ricarco em 04/12/2013
//	Private _cTabSpedNFSE      := AllTrim( GetNewPar( "MV_XTSNFSE", "DADOSADV_TSS.dbo.SPED051" ) )  // Aletração com Ricarco em 04/12/2013
	Private _cTabSpedNFSE      := AllTrim( GetNewPar( "MV_XTSNFSE", "DADOSADV.dbo.SPED051" ) )  // Aletração com Ricarco em 04/12/2013

//Testa os Parâmetros
	If AllTrim( MV_PAR02 ) == ""
		Aviso( "Atenção", "O Parâmetro [Nota Até] é obrigatório.", { "Voltar" } )
		Return
	End If

	If AllTrim( MV_PAR05 ) == ""
		Aviso( "Atenção", "O Parâmetro [Cliente Até] é obrigatório.", { "Voltar" } )
		Return
	End If

	If AllTrim( MV_PAR07 ) == ""
		Aviso( "Atenção", "O Parâmetro [Loja Até] é obrigatório.", { "Voltar" } )
		Return
	End If

	If Empty( MV_PAR09 )
		Aviso( "Atenção", "O Parâmetro [Emissão Até] é obrigatório.", { "Voltar" } )
		Return
	End If

	FSelNFs()

	_lMarcou := .F.

	If Len( _aNotas ) > 0
	   _lCritica := .F.
		For _nY := 01 To Len( _aNotas )

			If _aNotas[_nY][01]

				_lMarcou := .T.

				//Pega as Informações para montar o E-mail
				_cCliente := Upper( AllTrim( _aNotas[_nY][06] ) )
				_cEmailTo := Lower( AllTrim( _aNotas[_nY][08] ) )

				If AllTrim( _cEmailTo ) != ""

					//Monta o Arquivo XML
					_aAnexos := {}
					MsgRun( "Montando XML NF " + AllTrim( _aNotas[_nY][02] ) + "/" + AllTrim( _aNotas[_nY][03] ) + ", aguarde...",;
							  "Montando XML NF " + AllTrim( _aNotas[_nY][02] ) + "/" + AllTrim( _aNotas[_nY][03] ) + ", aguarde...",;
							  { || FGetXML( _aNotas[_nY][03], _aNotas[_nY][02], _aNotas[_nY][07] ) } )

					If File( _cArqXML )

						//Realiza o Envio do E-mail
						FEnvXMLMail( Nil, ;
										_cEmailTo, ;
										Nil, ;
										"NFSE de Serviço N. " + AllTrim( _aNotas[_nY][02] ) + "/" + AllTrim( _aNotas[_nY][03] ), ;
										"Caro(a) <b>" +  AllTrim( _cCliente ) + "</b>, <br>Segue em anexo arquivo XML referente à Nota Fiscal de Serviço de número " + AllTrim( _aNotas[_nY][02] ) + " - Série " + AllTrim( _aNotas[_nY][03] ) + ".<br><br>Atenciosamente, <br> <b>" + Capital( AllTrim( SM0->M0_NOME ) ) + ".</b>", ;
										_cArqXML )
					Else
						Aviso( "Atenção", "Não foi possível gerar o arquivo XML para a Nota Fiscal de Serviço de número " + AllTrim( _aNotas[_nY][02] ) + "/" + AllTrim( _aNotas[_nY][03] ) + ". O E-mail não será enviado.", { "Continuar" } )
						_lCritica := .T.
					End If

				Else
					Aviso( "Atenção", "O Campo de [E-mail NFSE] para o Cliente abaixo não está preenchido." + CRLF + "CNPJ: " + AllTrim( _aNotas[_nY][05] ) + " - " + AllTrim( _cCliente ) + ".", { "Continuar" } )
					_lCritica := .T.
				End If

			End If

		Next _nY

		If _lMarcou
			If _lCritica
				Aviso( "Atenção", "O(s) Processo de envio do(s) Arquivo(s) XML(s) foi concluído, porém com críticas que podem ter inviabilizado o envio do(s) mesmos.", { "Ok" } )
			Else
				Aviso( "Atenção", "O(s) Arquivo(s) XML foram enviados com sucesso.", { "Ok" } )
			End If
		Else
			Aviso( "Atenção", "Nenhuma NFSE foi selecionada para envio.", { "Ok" } )
		End If

	Else
		Aviso( "Atenção", "Nenhuma Nota de Serviço foi selecionada.", { "Sair" } )
	End If

Return

*----------------------------------*
Static Function FAjustaSX1( _cPerg )
*----------------------------------*
	Local aArea		:= GetArea()

//   Sintaxe PutSx1
//  PutSx1( "X1_GRUPO"  , "X1_, "X1_PERGUNT", "X1_PERSPA", "X1_PERENG", "X1_VARIAV, "X1_TIPO" , "X1_TAMANHO", "X1_DECIMAL", "X1_PRESEL" , "X1_GSC", "X1_VALID"                                                    , "X1_F3" , "X1_GRPSXG" , "SX1->X1_PYME"                                                , "X1_VAR01"  , "X1_DEF01"                                                    , "X1_DEFSPA1"                                                  , "X1_DEFENG1"                                                  , "", "X1_DEF02"                                                    , "X1_DEFSPA2"                                                  , "X1_DEFENG2"                                                  , "X1_DEF03"                                                    , "X1_DEFSPA3"                                                  , "X1_DEFENG3"                                                  , "X1_DEF04"                                                    , "X1_DEFSPA4"                                                  , "X1_DEFENG4"                                                  , "X1_DEF05"                                                    , "X1_DEFSPA5"                                                  , "X1_DEFENG5"                                                  , { "HelpPor1#3"                                                ,   "HelpPor2#3"                                                ,   "HelpPor3#3" }     , { "HelpPor1#3","HelpPor2#3","HelpPor3#3"},{"HelpPor1#3","HelpPor2#3","HelpPor3#3" },"X1_HELP")
	PutSx1( _cPerg      , "01", "Nota de  ?", "Nota de  ?", "Nota de  ?", "mv_ch1", "C"       , 9           , 0           , 0           , "G"     , ""                                                            , "SF2"   , ""          , "S"                                                           , "mv_par01"  , ""                                                            , ""                                                            , ""                                                            , "", ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , { ""                                                          ,   ""                                                          ,   "" }             , {"","",""},{"","",""},"")
	PutSx1( _cPerg      , "02", "Nota até ?", "Nota até ?", "Nota até ?", "mv_ch2", "C"       , 9           , 0           , 0           , "G"     , ""                                                            , "SF2"   , ""          , "S"                                                           , "mv_par02"  , ""                                                            , ""                                                            , ""                                                            , "", ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , { ""                                                          ,   ""                                                          ,   "" }             , {"","",""},{"","",""},"")
	PutSx1( _cPerg      , "03", "Série ?"   , "Série ?", "Série ?", "mv_ch3", "C", 3           , 0           , 0           , "G"     , ""                                                            , ""      , ""          , "S"                                                           , "mv_par03"  , ""			                                                   , ""                                                            , ""                                                            , "", ""															  				    , ""                                                            , ""                                                            , "Ambos"                                                       , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , { ""                                                          ,   ""                                                          ,   "" }        ,{"","",""},{"","",""},"")
	PutSx1( _cPerg      , "04", "Cliente de  ?", "Cliente de  ?", "Cliente de  ?", "mv_ch4"  , "C"       , 6           , 0           , 0           , "G"     , ""                                                            , "SA1"   , ""          , "S"                                                           , "mv_par04"  , ""                                                            , ""                                                            , ""                                                            , "", ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , { ""                                                          ,   ""                                                          ,   "" }   ,{"","",""},{"","",""},"")
	PutSx1( _cPerg      , "05", "Cliente até ?"	, "Cliente até ?", "Cliente até ?", "mv_ch5"  , "C"       , 6           , 0           , 0           , "G"     , ""                                                            , "SA1"   , ""          , "S"                                                           , "mv_par05"  , ""                                                            , ""                                                            , ""                                                            , "", ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , { ""                                                          ,   ""                                                          ,   "" },{"","",""},{"","",""},"")
	PutSx1( _cPerg      , "06", "Loja de  ?", "Loja de  ?", "Loja de  ?"	, "mv_ch6"  , "C"       , 2           , 0           , 0           , "G"     , ""                                                            , ""   	, ""          , "S"                                                           , "mv_par06"  , ""                                                            , ""                                                            , ""                                                            , "", ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , { ""                                                          ,   ""                                                          ,   "" }           , {"","",""},{"","",""},"")
	PutSx1( _cPerg      , "07", "Loja até ?", "Loja até ?", "Loja até ?", "mv_ch7"  , "C"       , 2           , 0           , 0           , "G"     , ""                                                            , ""   	, ""          , "S"                                                           , "mv_par07"  , ""                                                            , ""                                                            , ""                                                            , "", ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , { ""                                                          ,   ""                                                          ,   "" }               , {"","",""},{"","",""},"")
	PutSx1( _cPerg      , "08", "Emissão de  ?", "Emissão de  ?", "Emissão de  ?", "mv_ch8"  , "D"       , 8           , 0           , 0           , "G"     , ""                                                            , ""   	, ""          , "S"                                                           , "mv_par08"  , ""                                                            , ""                                                            , ""                                                            , "", ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , { ""                                                          ,   ""                                                          ,   "" }     , {"","",""},{"","",""},"")
	PutSx1( _cPerg      , "09", "Emissão até ?", "Emissão até ?", "Emissão até ?", "mv_ch9"  , "D"       , 8           , 0           , 0           , "G"     , ""                                                            , ""   	, ""          , "S"                                                           , "mv_par09"  , ""                                                            , ""                                                            , ""                                                            , "", ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , ""                                                            , { ""                                                          ,   ""                                                          ,   "" }     , {"","",""},{"","",""},"")

	RestArea( aArea )

Return Nil


*-----------------------*
Static Function FSelNFs()
*-----------------------*
	Local _oDlgEnvio		:= Nil
	Local _oGrpNotas		:= Nil
	Local _oBtnOk			:= Nil
	Local _oBtnCancelar	:= Nil

	Local _oCheck1			:= Nil

	Private lCheck			:= .F.

	Private _oListNFs		:= Nil

	_oDlgEnvio := MsDialog():New( 091, 232, 519, 927, "Seleção de Notas para Envio",,, .F.,,,,,, .T.,,, .T. )
	_oGrpNotas := TGroup():New( 008, 008, 200, 304, " Selecione as Notas para Envio ", _oDlgEnvio, CLR_BLUE, CLR_WHITE, .T., .F. )
	_oListNFs  := TcBrowse():New( 020, 016, 280, 170,, { "", "Nota", "Série", "Data", "CNPJ", "Razão Social" }, { 015, 040, 030, 030, 020, 50 }, _oGrpNotas,,,,, { ||  },,,,,,, .F.,, .T.,{ ||  }, .F.,,, )

	MsgRun(	"Carregando Notas, aguarde...",;
				"Carregando Notas, aguarde...",;
				{ || FCarregaNotas() } )

	_oBtnOk    := SButton():New( 010, 312, 01,{ || _oDlgEnvio:End() }, _oDlgEnvio,,"", )

	_oCheck1 := TCheckBox():New( 205,008,'Inverter Seleção',{|| lCheck },_oDlgEnvio,100,210,,{|| FTMarca() },,,,,,.T.,,,)

	_oDlgEnvio:Activate( ,,, .T. )

Return

*-----------------------------*
Static Function FCarregaNotas()
*-----------------------------*
	Local _aArea  := GetArea()
	Local _cAlias := GetNextAlias()
	Local _oOk    := LoadBitmap( GetResources(), "LBOK" )
	Local _oNo    := LoadBitmap( GetResources(), "LBNO" )
	Local _cQuery := ""

	_cQuery := "  SELECT DISTINCT "
	_cQuery += "         F.F2_FILIAL	 AS Filial  , "   // Solicitacao da Priscila em 06/11/2013
	_cQuery += "         F.F2_SERIE 	 AS SERIE   , "
	_cQuery += "         F.F2_DOC 	 AS NOTA    , "
	_cQuery += "         N.DATE_NFSE	 AS EMISSAO , "
	_cQuery += "         C.A1_CGC		 AS CNPJ	   , "
	_cQuery += "         C.A1_NOME 	 AS NOME	   , "
	_cQuery += "         N.ID_ENT 	 AS ID_ENT  , "
	_cQuery += "         C.A1_XNFSEM  AS EMAIL	  "
	_cQuery += "    FROM " + _cTabSpedEntidaes   + " E,       "
	_cQuery += "         " + _cTabSpedNFSE       + " N,       "
	_cQuery += "         " + RetSQLName( "SA1" ) + " C,       "
	_cQuery += "         " + RetSQLName( "SF2" ) + " F        "
	_cQuery += "    WHERE N.STATUS 	    	   = 6 			    "
	_cQuery += "      AND N.STATUSCANC   		= 0 				 "
	_cQuery += "      AND E.ID_ENT    			= N.ID_ENT		 "
	_cQuery += "      AND E.CNPJ              = '" + AllTrim( SM0->M0_CGC ) + "' "
	_cQuery += "      AND LEFT ( N.NFSE_ID, 03 ) = F.F2_SERIE "
	_cQuery += "      AND RIGHT( LEFT( N.NFSE_ID, 12 ), 09 ) = F.F2_DOC "

	// Solicitação da Priscila em 06/11/2013
	_cQuery += " 		AND F.F2_FILIAL  = '" + cFilAnt + "' "
	// Andre Costa

	_cQuery += " 		AND F.F2_CLIENTE = C.A1_COD "
	_cQuery += "      AND F.F2_LOJA    = C.A1_LOJA "
	_cQuery += " 		AND F.F2_DOC     >= '" + MV_PAR01 + "' "
	_cQuery += " 		AND F.F2_DOC     <= '" + MV_PAR02 + "' "

	If AllTrim( MV_PAR03 ) != ""
		_cQuery += " 		AND F.F2_SERIE    = '" + MV_PAR03 + "' "
	End If

	_cQuery += " 		AND F.F2_CLIENTE >= '" + MV_PAR04 + "' "
	_cQuery += " 		AND F.F2_CLIENTE <= '" + MV_PAR05 + "' "
	_cQuery += "      AND F.F2_LOJA    >= '" + MV_PAR06 + "' "
	_cQuery += "      AND F.F2_LOJA    <= '" + MV_PAR07 + "' "
	_cQuery += "      AND F.F2_LOJA    >= '" + MV_PAR06 + "' "
	_cQuery += "      AND F.F2_LOJA    <= '" + MV_PAR07 + "' "
	_cQuery += "      AND N.DATE_NFSE  >= '" + DtoS( MV_PAR08 ) + "' "
	_cQuery += "      AND N.DATE_NFSE  <= '" + DtoS( MV_PAR09 ) + "' "

	If Select( _cAlias ) > 0
		DbSelectArea( _cAlias )
		( _cAlias )->( DbCloseArea() )
	End If

	_aNotas := {}
	TcQuery _cQuery Alias ( _cAlias ) New

	Do While !( _cAlias )->( Eof() )

		aAdd( _aNotas, {	.F.							,;      // 01
						 		( _cAlias )->NOTA			,;		 // 02
						 		( _cAlias )->SERIE  		,;		 // 03
								( _cAlias )->EMISSAO		,;		 // 04
							 	( _cAlias )->CNPJ 		,;		 // 05
						 		( _cAlias )->NOME 		,;		 // 06
						 		( _cAlias )->ID_ENT 		,;		 // 07
						 		( _cAlias )->EMAIL  } ) 		 // 08

		DbSelectArea( _cAlias )
		( _cAlias )->( DbSkip() )

	End Do

	DbSelectArea( _cAlias )
	( _cAlias )->( DbCloseArea() )

	If Len( _aNotas ) == 0

		aAdd( _aNotas, { .F., "", "", "", "", "", "", "" } )

	End If

	_oListNFs:SetArray( _aNotas )

	_oListNFs:bLDblClick := { || FMarca( _oListNFs:nAt ) }
	_oListNFs:bLine 		:= { || { Iif( 	_aNotas[_oListNFs:nAt][01], _oOk, _oNo ) 	, ;
	    							   	  			_aNotas[_oListNFs:nAt][02]		  				, ;
	    							   				_aNotas[_oListNFs:nAt][03]		  				, ;
		    				   		DtoC( StoD( _aNotas[_oListNFs:nAt][04] ) )	  			, ;
			    							   		_aNotas[_oListNFs:nAt][05]		  				, ;
	    									   		_aNotas[_oListNFs:nAt][06]		  			} }

	_oListNFs:Refresh()

	RestArea( _aArea )

Return


*-----------------------------------------------------*
Static Function FGetXML( _cSerie, _cNota, _cIdentNFSE )
*-----------------------------------------------------*
	Local _cCNPJ 			  	:= AllTrim( SM0->M0_CGC )
	Local _cAliasTmp 		 	:= GetNextAlias()
	Local _cQuery    	 		:= ""
	Local _cChave    			:= PadR( _cSerie, 03 ) + AllTrim( _cNota )

	Local _cNumeroNFSE	 	:= ""
	Local _cCodVerificacao 	:= ""
	Local _dDataNFSE 			:= CtoD( "" )
	Local _cTimeNFSE			:= ""

	Default _cIdentNFSE 			:= ""

// Busca dados da NFSE no Banco do TSS
	_cQuery := "   SELECT NFSE_ID,
	_cQuery += "  	      NFSE_PROT	, "
	_cQuery += "  	      NFSE		, "
	_cQuery += "	      STATUS	, "
	_cQuery += "	      STATUSCANC, "
	_cQuery += "	      DATE_NFSE	, "
	_cQuery += "	      TIME_NFSE	, "
	_cQuery += "	      CONVERT( VARCHAR( 8000 ), CONVERT( BINARY( 8000 ), XML_ERP ) ) AS XML_ERP  "
	_cQuery += "     FROM " + _cTabSpedNFSE
	_cQuery += "    WHERE STATUS 	    	= 6 "
	_cQuery += "      AND STATUSCANC   		= 0 "
	_cQuery += "      AND ID_ENT 	        = '" + _cIdentNFSE       + "' "
	_cQuery += "      AND NFSE_ID    		= '" + _cChave           + "' "
	_cQuery += " ORDER BY DATE_NFSE, NFSE "
	_cAliasXML := GetNextAlias()

	If Select( _cAliasXML ) > 0
		DbSelectArea( _cAliasXML )
		( _cAliasXML )->( DbCloseArea() )
	End If

	TcQuery _cQuery Alias ( _cAliasXML ) New

	If !( _cAliasXML )->( Eof() )

		_cStringXML := ( _cAliasXML )->XML_ERP          // <?xml version="1.0" encoding="UTF-8"?>

	// Alteração para acerto do Envio para empresa 07, 20 e 21 - Andre Costa EM 13/11/2013 Priscila Gama

		If !'encoding' $ _cStringXML
			_cStringXML := '<?xml version="1.0" encoding="UTF-8"?>' + _cStringXML
		EndIf

		If 'tipos:' $ _cStringXML
			_cStringXML := StrTran(_cStringXML,'tipos:','')
		EndIf

	// Fim do Acerto

	//Coloca no Arquivo as Informações da Nota Fiscal
		_cNumeroNFSE		:= ( _cAliasXML )->NFSE
		_cCodVerificacao 	:= ( _cAliasXML )->NFSE_ID
		_dDataNFSE 			:= StoD( ( _cAliasXML )->DATE_NFSE )
		_cTimeNFSE		 	:= Left( ( _cAliasXML )->TIME_NFSE, 08 )
		_cDataEmissao   	:= AllTrim( Str( Year( _dDataNFSE ) ) ) + "-" + StrZero( Month( _dDataNFSE ), 02 ) + "-" + StrZero( Day( _dDataNFSE ), 02 ) + "T" + Left( _cTimeNFSE, 08 )
		_cTagNFSE 		 	:= "<InfNfse><Numero></Numero><CodigoVerificacao></CodigoVerificacao><DataEmissao></DataEmissao></InfNfse>"
		_cTagNFSE 		 	:= Replace( _cTagNFSE, "<Numero></Numero>"					  , "<Numero>" 			  + _cNumeroNFSE	 + "</Numero>"			  )
		_cTagNFSE 		 	:= Replace( _cTagNFSE, "<CodigoVerificacao></CodigoVerificacao>", "<CodigoVerificacao>" + _cCodVerificacao + "</CodigoVerificacao>" )
		_cTagNFSE 		 	:= Replace( _cTagNFSE, "<DataEmissao></DataEmissao>"			  , "<DataEmissao>" 	  + _cDataEmissao 	 + "</DataEmissao>"		  )

	//Incluindo a Tag <InfNfse> no arquivo XML
		_cTagNFSE += "<IdentificacaoRps>"
		_cStringXML := Replace( _cStringXML, "<IdentificacaoRps>", _cTagNFSE )

		If AllTrim( _cStringXML ) != ""
			FCriaArqXML( _cStringXML, _cNota , AllTrim( ( _cAliasXML )->NFSE_PROT ), ( _cAliasXML )->DATE_NFSE )
		End If

	End If
	DbSelectArea( _cAliasXML )
	( _cAliasXML )->( DbCloseAre() )

Return


*----------------------------------------------------------------------------*
Static Function FCriaArqXML( _cStringXML, _cNotaNFSE, _cNFSEProt, _cDataNFSE )
*----------------------------------------------------------------------------*
	Local _cPath   := GetNewPar( "MV_XDIRXML", "\xml-nfse-export\" )
	Local _nHandle := Nil

	//Cria o Arquivo Físico
	MontaDir( _cPath )
	_cArqXml := _cPath + "nfe_empresa_" + cEmpAnt + "_filial_" + cFilAnt + "_nfse_" + Alltrim( _cNotaNFSE ) + "_protocolo_" + Alltrim( _cNFSEProt ) + "_data_" + _cDataNFSE + ".xml"
	If File( _cArqXML )
		FErase( _cArqXML )
	End If

	_nHandle := FCreate( _cArqXml, 0 )
	FWrite( _nHandle, _cStringXML )
	FClose( _nHandle )

Return

*-------------------------------*
Static Function FMarca( _nLinha )
*-------------------------------*

	_aNotas[_nLinha][01] := !_aNotas[_nLinha][01]
	_oListNFs:Refresh()

Return


*-------------------------------*
Static Function FTMarca
*-------------------------------*

	For x := 1 To Len(_aNotas)
		_aNotas[x][01] := !_aNotas[x][01]
		_oListNFs:Refresh()
	Next x

	lCheck := !lCheck

Return

*---------------------------------------------------------------------------*
Static Function FEnvXMLMail( _cFrom, _cTo, _cCC, _cAssunto, _cBody, _cAnexo )
*---------------------------------------------------------------------------*
	Local _lHabilitado 	  	:= AllTrim( GetNewPar( "MV_XENVEMA", "S" ) ) == "S" // Parâmetro para Desabilitar o Envio dos E-mail. . .

//Inicializa as Variaveis
	Default _cFrom   	  		:= If( AllTrim( GetMv( "MV_RELFROM" ) ) == "", _cContaEmail, AllTrim( GetMv( "MV_RELFROM" ) ) )
	Default _cTo     	  		:= ""

	Default _cCC     	  		:= GetNewPar( "MV_XCCNFSE", "priscila.gama@gefco.com.br" )
	Default _cAssunto     	:= "<Mensagem sem assunto>"
	Default _cBody        	:= "<Mensagem sem corpo>"
	Default _cAnexo 			:= ""

	If !_lHabilitado
		Return .T.
	End If

	MsgRun(	"Enviando e-mail, aguarde...",;
				"Enviando e-mail, aguarde...",;
				{ || U_EnvEmail( _cFrom, _cTo, _cCC, _cAssunto,_cBody, _cAnexo ) } )
