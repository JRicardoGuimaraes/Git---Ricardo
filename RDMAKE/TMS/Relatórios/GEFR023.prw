Static Function BuildTeste

	Local cSelect 	:= ''
	Local cSelectGPO	:= ''
	Local cSelectTMS	:= ''
	Local cFrom		:= ''
	Local cFromGPO	:= ''
	Local cFromTMS	:= ''
	Local cWhere		:= ''
	Local cWhereGPO	:= ''
	Local cWhereTMS	:= ''
	Local cGroup		:= ''
	Local cGroupGPO	:= ''
	Local cGroupTMS	:= ''

	cSelect += "	DT6_XORICT,DT6_FILORI,DT6_LOTNFC,DT6_DATEMI,DT6_DOC,DT6_SERIE,DT6_VALFRE,DT6_VALIMP						, 	" + CRLF
	cSelect += "	DT6_CLIREM,DT6_LOJREM,DT6_CLIDES,DT6_LOJDES,DT6_CLIDEV,DT6_LOJDEV,DT6_CLICAL,DT6_LOJCAL					, 	" + CRLF
	cSelect += "  DT6_TIPFRE,DT6_SERTMS,DT6_TIPTRA,SPACE(20) AS SELEC_ORIG,DT6_CDRORI,DT6_CDRDES							, 	" + CRLF
	cSelect += "  DT6_CDRCAL,DT6_CCUSTO,DT6_CCONT,DT6_OI,DT6_CONTA,DT6_TIPDES,DT6_REFGEF,Space(100) AS OBS				, 	" + CRLF
	cSelect += "	DEV_FRETE =	CASE	WHEN DT6_DEVFRE = '1' THEN 'Remetente'										 				" + CRLF
	cSelect += "        		  			WHEN DT6_DEVFRE = '2' THEN 'Destinatario'											 		" + CRLF
	cSelect += "        		  			WHEN DT6_DEVFRE = '3' THEN 'Consignatario'										 		" + CRLF
	cSelect += "       		  			WHEN DT6_DEVFRE = '4' THEN 'Despachante'											 		" + CRLF
	cSelect += "  						ELSE 'N/DEFINIDO'																		 		" + CRLF
	cSelect += "            	   END																									, 	" + CRLF

	cFrom	 += 	RetSqlName("DTC") + " DTC		(nolock)																		,	" + CRLF

	cWhere  += "		DT6.D_E_L_E_T_	=	''							 			 				 									" + CRLF
	cWhere  += "	AND	DTC.D_E_L_E_T_	=	''						 			 					 									" + CRLF
	cWhere  += "	AND	DT6_DOC 			= DTC_DOC						 			 					 								" + CRLF
	cWhere  += "	AND	DT6_SERIE 			= DTC_SERIE								 		 			 								" + CRLF
	cWhere  += "	AND	DT6_DATEMI	BETWEEN '" + DtoS(MV_PAR03)	+ "' AND '" + DtoS(MV_PAR04)	+ 	"'	 							" + CRLF
	cWhere  += "	AND	DT6_DOC	BETWEEN '" + MV_PAR05		+ "' AND '" + MV_PAR06			+ 	"'	 							" + CRLF
	cWhere  += "	AND	DT6_CCUSTO	BETWEEN '" + MV_PAR09		+ "' AND '" + MV_PAR10			+ 	"'	 							" + CRLF

	cGroup += "	DT6_XORICT,DT6_FILORI,DT6_DEVFRE,DTC_CODOBS,DT6_LOTNFC,DT6_DATEMI,DT6_DOC	,DT6_SERIE						,	" + CRLF
	cGroup += "	DT6_VALFRE	,DT6_VALIMP,DT6_CLIDES,DT6_LOJDES,DT6_CLIREM,DT6_LOJREM,DT6_CLIDEV,DT6_LOJDEV				, 	" + CRLF
	cGroup += "	DT6_CLICAL	,DT6_LOJCAL,DT6_TIPFRE,DT6_SERTMS,DT6_TIPTRA,DT6_CDRORI,DT6_CDRDES	,DT6_CDRCAL				,	" + CRLF
	cGroup += "	DT6_CCUSTO	,DT6_CCONT	,DT6_OI,DT6_CONTA	,DT6_TIPDES,DT6_REFGEF,DT6_VALMER									,	" + CRLF

	If lAnalitico
		cSelect += "		DTC_NUMNFC AS NOTAS_CLI																					, 	" + CRLF
		cSelect += "		DTC_VALOR																									, 	" + CRLF
		cSelect += "		DTC_PESO																									, 	" + CRLF
		cSelect += "		DTC_QTDVOL																									, 	" + CRLF
		cSelect += "		DTC_PESOM3																									, 	" + CRLF
		cSelect += "		DTC_METRO3																									, 	" + CRLF
		cSelect += "		DTC_SELORI																									,	" + CRLF

		cWhere += " AND DT6_FILORI	BETWEEN '" + MV_PAR07		+ "' AND '" + MV_PAR08			+ 	"'	 						" + CRLF
		cWhere += " AND DT6_FILORI 	= DTC_FILORI					 			 						 								" + CRLF

		cWhereTMS += " AND DT6_LOTNFC	= DTC_LOTNFC						 															" + CRLF

		cGroup += "	DTC_SELORI	,	DTC_PESOM3	,	DTC_METRO3	,	DTC_PESO	,	DTC_VALOR,		DTC_QTDVOL	,	DTC_NUMNFC		,	" + CRLF

	Else

		cSelect += "		'' AS NOTAS_CLI																							, 	" + CRLF
		cSelect += "		DT6_PESO		As DTC_PESO																				, 	" + CRLF
		cSelect += "		DT6_VOLORI		As DTC_QTDVOL																				, 	" + CRLF
		cSelect += "		DT6_PESOM3		As DTC_PESOM3																				, 	" + CRLF
		cSelect += "		DT6_METRO3		AS DTC_METRO3																				, 	" + CRLF

		cWhere += " AND DT6_FILDOC	BETWEEN '" + MV_PAR07     	+ "' AND '" + MV_PAR08			+ 	"'							" + CRLF
		cWhere += " AND DT6_FILDOC 	= DTC_FILORI					 			 						 								" + CRLF

		cGroup += "	DT6_PESOM3	,	DT6_METRO3	,	DT6_PESO	,	DT6_VOLORI	,														" + CRLF

	EndIf

	cSelectGPO += "		DTQ_BASADV AS DT6_VALMER																			, 		" + CRLF
	cSelectGPO += "		DTQ_TOTFRE AS DT6_VALTOT																			, 		" + CRLF
	cSelectGPO += "		ZT0_CODTAB AS DT6_TABFRE																			, 		" + CRLF
	cSelectGPO += "		ZT0_ITEMTB AS DT6_TIPTAB																			, 		" + CRLF
	cSelectGPO += "    	ZA7_CARGA	 AS DT6_SERVIC																		, 		" + CRLF
	cSelectGPO += "    	SERVICO = '" + Space(20) + "' 																	, 		" + CRLF
	cSelectGPO += "    	ZA6_EMERG2																							, 		" + CRLF
	cSelectGPO += "    	ZA7_EMERG2																							, 		" + CRLF
	cSelectGPO += "		SUM(D2_VALBRUT) AS DT8_VALTOT																	, 		" + CRLF
	cSelectGPO += "		SUM(D2_TOTAL)   AS DT8_VALPAS																	, 		" + CRLF
	cSelectGPO += "		SUM(D2_VALICM + D2_VALIMP5 + D2_VALIMP6) AS DT8_VALIMP										, 		" + CRLF
	cSelectGPO += "		'FRETE_PESO'	= SUM(	CASE	WHEN D2_ITEM = '01' 												 		" + CRLF
	cSelectGPO += "										THEN D2_VALBRUT 														 	" + CRLF
	cSelectGPO += "										ELSE 0																	 	" + CRLF
	cSelectGPO += "								END )																		, 		" + CRLF
	cSelectGPO += "    	'FRETE_VAL'	= SUM(	CASE	WHEN	(DTQ_VRPEDA > 0 AND D2_ITEM = '03')					 		" + CRLF
	cSelectGPO += "    										Or	(DTQ_VRPEDA = 0 AND D2_ITEM = '02')					 		" + CRLF
	cSelectGPO += "    									THEN D2_VALBRUT 													 		" + CRLF
	cSelectGPO += "    									ELSE 0 															 		" + CRLF
	cSelectGPO += "    							END )																		, 		" + CRLF
	cSelectGPO += "    	'SEC_CAT'		= ( DTQ_BASADV * DTQ_VALADV ) / 100											, 		" + CRLF
	cSelectGPO += "    	'PEDAGIO'		= SUM( CASE	WHEN (DTQ_VRPEDA > 0 AND D2_ITEM = '02')							 	" + CRLF
	cSelectGPO += "    									THEN D2_VALBRUT														 	" + CRLF
	cSelectGPO += "    									ELSE 0 																 	" + CRLF
	cSelectGPO += "    							END )																		, 		" + CRLF
	cSelectGPO += "		'GRIS'			= ( DT6_VALMER * ZT0_PGRIS ) / 100												, 		" + CRLF
	cSelectGPO += "		'ITR'			= 0																					, 		" + CRLF
	cSelectGPO += "		'SUFRAMA'		= 0																					, 		" + CRLF
	cSelectGPO += "		'DESPACHO'		= 0																					, 		" + CRLF
	cSelectGPO += "		'OUTROS'		= DTQ_VROUTR																		, 		" + CRLF
	cSelectGPO += "		'NFRETEPESO'	= DTQ_EQUIP																		, 		" + CRLF
	cSelectGPO += "		'' 				AS DTC_CODOBS																		, 		" + CRLF
	cSelectGPO += "		DTQ_AS		 	AS ZA6_AS																			, 		" + CRLF
	cSelectGPO += "		DTQ_VIAGEM		AS VIAGEM																			 		" + CRLF

	cFromGPO += RetSqlName("DT6") + " DT6		(nolock)																	,		" + CRLF
	cFromGPO += RetSqlName("DTQ") + " DTQ		(nolock)																	,		" + CRLF
	cFromGPO += RetSqlName("ZA7") + " ZA7		(nolock)																	,		" + CRLF
	cFromGPO += RetSqlName("ZA6") + " ZA6		(nolock)																	,		" + CRLF
	cFromGPO += RetSqlName("ZT0") + " ZT0		(nolock)																	,		" + CRLF
	cFromGPO += RetSqlName("SD2") + " SD2		(nolock)																			" + CRLF

	cWhereGPO += "	AND SD2.D_E_L_E_T_	=	''					 			 						 							" + CRLF
	cWhereGPO += "	AND DTQ.D_E_L_E_T_	=	''							 			 				 							" + CRLF
	cWhereGPO += "	AND ZA6.D_E_L_E_T_	=	''							 			 				 							" + CRLF
	cWhereGPO += "	AND ZA7.D_E_L_E_T_	=	''							 			 				 							" + CRLF
	cWhereGPO += "	AND DT6_XORICT		<>	''							 			 				 							" + CRLF
	cWhereGPO += "	AND DT6_FILDOC		= D2_FILIAL						 			 				 						" + CRLF
	cWhereGPO += "	AND DT6_DOC    		= D2_DOC							 			 			 							" + CRLF
	cWhereGPO += "	AND DT6_SERIE  		= D2_SERIE							 			 				 						" + CRLF
	cWhereGPO += "	AND DT6_FILIAL 		= DTQ_FILIAL						 			 						 				" + CRLF
	cWhereGPO += "	AND DT6_FILDOC 		= DTQ_FILORI							 			 					 				" + CRLF
	cWhereGPO += "	AND DT6_DOC     		= DTQ_NUMCTR				 			 							 					" + CRLF
	cWhereGPO += "	AND DT6_SERIE 		= DTQ_SERCTR				 			 								 				" + CRLF
	cWhereGPO += "	AND DTQ_FILORI 		= ZA7_FILIAL				 			 								 				" + CRLF
	cWhereGPO += "	AND DTQ_VIAGEM 		= ZA7_VIAGEM				 			 								 				" + CRLF
	cWhereGPO += "	AND DTQ_AS 			= ZA6_AS				 			 							 						" + CRLF
	cWhereGPO += "	AND ZA6_TABVEN 		= ZT0_CODTAB			 			 									 				" + CRLF
	cWhereGPO += "	AND ZA6_VERVEN 		= ZT0_VERTAB				 			 							 					" + CRLF
	cWhereGPO += "	AND ZA6_ITTABV 		= ZT0_ITEMTB				 			 							 					" + CRLF

	cGroupGPO += "	DTQ_VALADV,	ZT0_PGRIS	,	DTQ_VROUTR	,	DTQ_EQUIP	,	DTQ_VIAGEM	,	DTQ_AS		,	ZA7_CARGA	,	" + CRLF
	cGroupGPO += "	DTQ_BASADV	,	DTQ_TOTFRE	,	ZT0_CODTAB	,	ZT0_ITEMTB	,	ZA7_CARGA	,	ZA6_EMERG2	,	ZA7_EMERG2		" + CRLF

	cSelectTMS += "		DT6_VALMER																							, 		" + CRLF
	cSelectTMS += "		DT6_VALTOT																							, 		" + CRLF
	cSelectTMS += "		DT6_TABFRE																							, 		" + CRLF
	cSelectTMS += "		DT6_TIPTAB																							, 		" + CRLF
	cSelectTMS += "    	DT6_SERVIC																							, 		" + CRLF
	cSelectTMS += "    	X5_DESCRI AS SERVICO																				, 		" + CRLF
	cSelectTMS += "    	'' AS ZA6_EMERG2																					, 		" + CRLF
	cSelectTMS += "    	'' As ZA7_EMERG2																					, 		" + CRLF
	cSelectTMS += "		SUM(DT8_VALTOT) AS DT8_VALTOT																	, 		" + CRLF
	cSelectTMS += "		SUM(DT8_VALPAS) AS DT8_VALPAS																	, 		" + CRLF
	cSelectTMS += "		SUM(DT8_VALIMP) AS DT8_VALIMP																	, 		" + CRLF
	cSelectTMS += "		'FRETE_PESO'  = SUM( CASE WHEN DT3_COLIMP = '1' THEN DT8_VALTOT ELSE 0 END )				, 		" + CRLF
	cSelectTMS += "		'FRETE_VAL'   = SUM( CASE WHEN DT3_COLIMP = '2' THEN DT8_VALTOT ELSE 0 END )				, 		" + CRLF
	cSelectTMS += "		'SEC_CAT'     = SUM( CASE WHEN DT3_COLIMP = '3' THEN DT8_VALTOT ELSE 0 END )				, 		" + CRLF
	cSelectTMS += "		'PEDAGIO'     = SUM( CASE WHEN DT3_COLIMP = '4' THEN DT8_VALTOT ELSE 0 END )				, 		" + CRLF
	cSelectTMS += "		'GRIS'        = SUM( CASE WHEN DT3_COLIMP = '5' THEN DT8_VALTOT ELSE 0 END )				, 		" + CRLF
	cSelectTMS += "		'ITR'         = SUM( CASE WHEN DT3_COLIMP = '6' THEN DT8_VALTOT ELSE 0 END )				, 		" + CRLF
	cSelectTMS += "		'SUFRAMA'     = SUM( CASE WHEN DT3_COLIMP = '7' THEN DT8_VALTOT ELSE 0 END )				,  		" + CRLF
	cSelectTMS += "		'DESPACHO'    = SUM( CASE WHEN DT3_COLIMP = '8' THEN DT8_VALTOT ELSE 0 END )				, 		" + CRLF
	cSelectTMS += "		'OUTROS'      = SUM( CASE WHEN DT3_COLIMP = '9' THEN DT8_VALTOT ELSE 0 END )				, 		" + CRLF
	cSelectTMS += "		'NFRETEPESO'  = MAX( CASE WHEN DT3_COLIMP = '1' THEN DT3_DESCRI ELSE '' END )			, 		" + CRLF
	cSelectTMS += "		DTC_CODOBS																							, 		" + CRLF
	cSelectTMS += "		'' AS ZA6_AS																						, 		" + CRLF
	cSelectTMS += "		'' AS VIAGEM																						 		" + CRLF

	cFromTMS += RetSqlName("SX5") + " SX5		(nolock)																	,		" + CRLF
	cFromTMS += RetSqlName("DT6") + " DT6		(nolock)																			" + CRLF
	cFromTMS += "			LEFT JOIN DTL010 DTL ON ( DT6_TABFRE = DTL_TABFRE AND DT6_TIPTAB = DTL_TIPTAB )			,		" + CRLF

	cFromTMS += RetSqlName("DT3") + " DT3		(nolock)																	,		" + CRLF
	cFromTMS += RetSqlName("DT8") + " DT8		(nolock)																			" + CRLF

	cWhereTMS += "	AND SX5.D_E_L_E_T_	=	''								 			 				 						" + CRLF
	cWhereTMS += "	AND DT8.D_E_L_E_T_	=	''						 			 					 							" + CRLF
	cWhereTMS += "	AND DTL.D_E_L_E_T_	=	''				 			 							 							" + CRLF
	cWhereTMS += "	AND DT3.D_E_L_E_T_	=	''								 		 			 								" + CRLF
	cWhereTMS += "	AND DT6_FILDOC		= DT8_FILDOC			 			 						 							" + CRLF
	cWhereTMS += "	AND DT6_DOC			= DT8_DOC				 			 					 								" + CRLF
	cWhereTMS += "	AND DT6_SERIE			= DT8_SERIE				 			 					 							" + CRLF
	cWhereTMS += "	AND DT8_CODPAS		= DT3_CODPAS					 			 				 							" + CRLF
	cWhereTMS += "	AND X5_TABELA			= 'L4'					 			 			 										" + CRLF
	cWhereTMS += "	AND DT6_SERVIC 		= X5_CHAVE								 			 			 						" + CRLF

	cGroupTMS += "	DT6_VALTOT	,	DT6_TABFRE	,	DT6_TIPTAB	,	DT6_SERVIC	,	X5_DESCRI										" + CRLF
