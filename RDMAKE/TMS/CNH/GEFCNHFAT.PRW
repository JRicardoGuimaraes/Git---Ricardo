#Include "ProtheusS.CH"
#Include "TbiConn.CH"
#Include "Colors.CH"
#Include "RptDef.CH"
#Include "FWPrintSetup.ch"
#Include "TopConn.ch"

#Define IMP0001 "GEFCO LOGÍSTICA DO BRASIL LTDA"
#Define IMP0002 "Praça Quinze de Novembro, 20 - Salas 401 Parte e 402 - Centro"
#Define IMP0003 "RIO DE JANEIRO - RJ - CEP 20010-010"
#Define IMP0004 "CNPJ: 03.094.658/0001-06"
#Define IMP0005 "IE: 75.819.625"
#Define IMP0006 "TEL: (5521) 2103-8100"
#Define IMP0007 "FAX: (5521) 2103-8101"
#Define IMP0008 "LOGISTICS FOR MANUFACTURES"
#Define IMP0009 "Observações : "
#Define IMP0010 "Cobrança através de Deposíto Bancário identificado com nº CNPJ de sua Empresa"
#Define IMP0011 "Código :"
#Define IMP0012 "Sacado :"
#Define IMP0013 "Endereço :"
#Define IMP0014 "Bairro :"
#Define IMP0015 "Municipio :"
#Define IMP0016 "Estado :"
#Define IMP0017 "CNPJ :"
#Define IMP0018 "Insc Est :"
#Define IMP0019 "Local da operação :"
#Define IMP0020 "Data de Emissão :"
#Define IMP0021 "Faturamento referente a semana :"
#Define IMP0022 "Fatura / Nota Fiscal :"
#Define IMP0023 "Valor R$ :"
#Define IMP0024 "Data de Vencimento :"
#Define IMP0025 "Cobrança em :"
#Define IMP0026 "Carteira"
#Define IMP0027 "Boleto Bancario"
#Define IMP0028 "Depósito em C/C"
#Define IMP0029 "Nº Bco"
#Define IMP0030 "Agência "
#Define IMP0031 "C/C "
#Define IMP0032 "Sub Total :"
#Define IMP0033 "Desconto Oferecido :"
#Define IMP0034 "Total desta Fatura :"
#Define IMP0035 "Reservado a Intiuição"
#Define IMP0036 "Financeira"
#Define IMP0037 "SEQ."
#Define IMP0038 "EMISSÃO"
#Define IMP0039 "DESCRIÇÃO DOS SERVIÇOS"
#Define IMP0040 "VALORES PRESTADOS R$"
#Define IMP0041 "Loja :"
#Define IMP0042 'SERVIÇOS PRESTADOS DE FRETE'
#Define IMP0043 ' / DIVERSOS'


/*
Programa	: GEFCNHFAT
Funcao		: Static Fucntion GEFCNHFAT
Data		: 18/08/2015
Autor		: André Costa
Descricao	: Função principal
Uso			: Faz a chamada da função Static GEFCNHFAT
Sintaxe	: GEFCNHFAT()
Chamada	: Externa
*/


User Function GEFCNHFAT
	Private aDadosInfo

	GEFCNHFAT( aDadosInfo )

Return


/*
Programa	: GEFCNHFAT
Funcao		: Static Fucntion GEFCNHFAT
Data		: 17/04/2015
Autor		: André Costa
Descricao	: Função de Controle de Impressão
Uso			: Usada para imprimir a Fatura das AST
Sintaxe	:
Chamada	: Via TButton em GEFCNHBWS
*/

//Static Function GEFCNHFAT( xFilial , xNum , xEmissao , nValorFat, aInfoItens , aObs , lSM0EndCob )

Static Function GEFCNHFAT( aInfoItens , aObs , lSM0EndCob )

	Local aArea			:= GetArea()
	Local cArquivo		:= "FAT"+aInfoItens[2]
	Local cLogo01			:= GetSrvProfString("Startpath","") + "logo_gefco_01.bmp"
	Local aMen				:= Array(2)
	Local nItensFim		:= Len( aInfoItens[14] )
	Local aTotais			:= aFill( Array(3) , 0 )
	Local X,Y,Z			:= 0
	Local nItensIni		:= 1
	Local nQtdePag		:= 1
	Local nQtde			:= 0
	Local nItensFolhas	:= 37
	Local xPagIni
	Local xPagFim

	Private oFont07		:= TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)
	Private oFont08		:= TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
	Private oFont07N		:= TFont():New("Times New Roman",07,07,,.T.,,,,.T.,.F.)
	Private oFont08N		:= TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
	Private oFatura

	Default lSM0EndCob	:= .F.

	oFatura := FWMsPrinter():New( cArquivo,nDevice,.F.,cPathInServer,.T.,/*[lTReport]*/,@oFatura,/*/cPrinter]*/,/*[lServer]*/,/*[lPDFAsPNG]*/,/*[lRaw]*/,lViewPDF,/*[nQtdCopy]*/ )

	oFatura:cPrinter		:= IIf( ! Empty( cPrinter ) 		, cPrinter		, oFatura:cPrinter	)
	oFatura:cPathPDF		:= IIf( ! Empty( cPathPDF ) 		, cPathPDF		, oFatura:cPathPDF	)
	oFatura:nDevice		:= IIf( oFatura:cPrinter == "PDF"	, 6				, 2						)
	oFatura:nModalResult	:= 1

	oFatura:SetResolution(72)
	oFatura:SetPortrait()
	oFatura:SetPaperSize(DMPAPER_A4)
	oFatura:SetMargin(60,60,60,60)

	If oFatura:nModalResult # 1
		oFatura:Cancel()
	EndIf

	If oFatura:Canceled()
		If !lDisableSetup
			oFatura:DeActivate()
			lEnd := .F.
			Return
		EndIf
	EndIf

	If nItensFim > nItensFolhas
		nQtdePag := Round( nItensFim / nItensFolhas , 0 )
	EndIf

	oProcess:SetRegua2( nItensFim )

	xEmissao := DtoC( StoD( aInfoItens[9] ) )

	nBoxIten := 0670

	For Z := 1 To nQtdePag

		oFatura:StartPage()

		// Cabecalho

		oFatura:Say( 0030 , 0240 , IMP0001		, oFont08N	)				// GEFCO LOGÍSTICA DO BRASIL LTDA

		If lSM0EndCob
			aLocal := GetAdvFval( "SM0",{"M0_FILIAL","M0_ENDCOD","M0_COMPCOB","M0_CIDCOB","M0_ESTCOB","M0_CEPCOB","M0_CGC","M0_INSC","M0_TEL","M0_FAX"}, cEmpAnt+aInfoItens[1],1, {'','','','','','','','','',''}, .T. )
		Else
			aLocal := GetAdvFval( "SM0",{"M0_FILIAL","M0_ENDENT","M0_COMPENT","M0_CIDENT","M0_ESTENT","M0_CEPENT","M0_CGC","M0_INSC","M0_TEL","M0_FAX"}, cEmpAnt+aInfoItens[1],1, {'','','','','','','','','',''}, .T. )
		EndIf

		xIMP0002 := Capital( AllTrim( aLocal[02] ) + " - " + AllTrim( aLocal[03] ) )
		xIMP0003 := Capital( AllTrim( aLocal[04] ) + " - " + AllTrim( aLocal[05] ) + " - CEP " + AllTrim( aLocal[06] ) )
		xIMP0004 := "CNPJ : " + Transform( aLocal[07] , GetSX3Cache("A1_CGC","X3_PICTURE") )
		xIMP0005 := "IE   : " + aLocal[08]
		xIMP0006 := "TEL  : " + aLocal[09]
		xIMP0007 := "FAX  : " + aLocal[10]

		oFatura:Say( 0037 , 0240 , xIMP0002	, oFont07	)				// Praça Quinze de novembro, 20 - Salas 401 Parte e 402 - Centro
		oFatura:Say( 0044 , 0240 , xIMP0003	, oFont07	)				// RIO DE JANEIRO - RJ - CEP 20010-010
		oFatura:Say( 0051 , 0240 , xIMP0004 	, oFont07	)				// CNPJ: 03.094.658/0001-06
		oFatura:Say( 0058 , 0240 , xIMP0005 	, oFont07	)				// IE: 75.819.625
		oFatura:Say( 0065 , 0240 , xIMP0006 	, oFont07	)				// TEL: (5521) 2103-8100
		oFatura:Say( 0073 , 0240 , xIMP0007 	, oFont07	)				// FAX: (5521) 2103-8101

		oFatura:SayBitmap( 0080, 0005 , cLogo01 , 0150 , 0070 )			// Logo Gefco


		If SA1->( DbSeek( xFilial("SA1") + aInfoItens[3] + aInfoItens[4] ) )

			oFatura:Box( 0080 , 0230 , 0170 			, 0559		)
			oFatura:Say( 0090 , 0240 , IMP0011 		, oFont07N	) 			// Código	:
			oFatura:Say( 0090 , 0280 , SA1->A1_COD		, oFont07	)

			oFatura:Say( 0090 , 0500 , IMP0041			, oFont07N	) 			// Loja :
			oFatura:Say( 0090 , 0520 , SA1->A1_LOJA	, oFont07	)

			oFatura:Say( 0100 , 0240 , IMP0012			, oFont07N	)			// Sacado	:
			oFatura:Say( 0100 , 0280 , SA1->A1_NOME 	, oFont07	)

			oFatura:Say( 0110 , 0240 , IMP0013 		, oFont07N	)			// Endereço	:
			oFatura:Say( 0110 , 0280 , SA1->A1_END 	, oFont07	)

			oFatura:Say( 0120 , 0240 , IMP0014 		, oFont07N	)			// Bairro	:
			oFatura:Say( 0120 , 0280 , SA1->A1_BAIRRO , oFont07	)

			oFatura:Say( 0130 , 0240 , IMP0015 		, oFont07N	) 			// Municipio:
			oFatura:Say( 0130 , 0280 , SA1->A1_MUN	 	, oFont07	)

			oFatura:Say( 0140 , 0240 , IMP0016 		, oFont07N	)			// Estado	:
			oFatura:Say( 0140 , 0280 , SA1->A1_EST		, oFont07	)

			xA1_CGC := Transform( SA1->A1_CGC , GetSX3Cache("A1_CGC","X3_PICTURE") )

			oFatura:Say( 0150 , 0240 , IMP0017			, oFont07N	)			// CNPJ		:
			oFatura:Say( 0150 , 0280 , xA1_CGC			, oFont07	)

			oFatura:Say( 0160 , 0240 , IMP0018			, oFont07N	)			// Insc Est :
			oFatura:Say( 0160 , 0280 , SA1->A1_INSCR	, oFont07	)

		EndIf

		xLocal := aLocal[4]+aLocal[5]

		oFatura:Box( 0180 , 0000 , 0200 , 0559 )
		oFatura:Say( 0190 , 0010 , IMP0019	, oFont08N	)			 		// Local de Operação
		oFatura:Say( 0190 , 0080 , xLocal	, oFont08	)

		xData := Transform( DtoC( dDataBase ) , "99/99/9999" )

		oFatura:Say( 0190 , 0400 , IMP0020	, oFont08N	)	 				// Data de Emissão
		oFatura:Say( 0190 , 0480 , xData	, oFont08	)

		aMen[1] := "Deve(mos) à GEFCO LOGÍSTICA DO BRASIL LTDA, estabelecida à "+ xIMP0002 + " " + xIMP0003 + ","
		aMen[2] := " a importância demonstrada abaixo:"

		oFatura:Box( 0205 , 0000 , 0230		, 0559 )					 	// Devemos
		oFatura:Say( 0215 , 0010 , aMen[1]	, oFont08N	)
		oFatura:Say( 0225 , 0010 , aMen[2]	, oFont08N	)

		oFatura:Box( 0235 , 0000 , 0270 , 0559 )							// Informações AST
		oFatura:Say( 0245 , 0010 , IMP0021 , oFont08N	)					// Faturamento referente a semana
		oFatura:Say( 0265 , 0010 , IMP0042 , oFont08	)
		oFatura:Line(0235 , 0150 , 0270 , 0150)							// Linha vertical

		xFatura := aInfoItens[2] + IIf( FunName() # "GEFFINR001",IMP0043,'')

		oFatura:Say( 0245 , 0160 , IMP0022 , oFont08N	)					// Fatura / Nota Fiscal :
		oFatura:Say( 0265 , 0160 , xFatura , oFont08	)
		oFatura:Line(0235 , 0300 , 0270 , 0300)							// Linha vertical

		oFatura:Say( 0245 , 0310 , IMP0023 , oFont08N	)					// Valor R$ :
		oFatura:Say( 0265 , 0310 , Transform( aInfoItens[12] , GetSX3Cache("E1_VALOR","X3_PICTURE") , oFont08N	) )

		oFatura:Line(0235 , 0450 , 0270 , 0450)							// Linha vertical

		oFatura:Say( 0245 , 0460 , IMP0024	, oFont08N	)					// Data de Vencimento :
		oFatura:Say( 0265 , 0460 , xEmissao , oFont08	)

		// Itens

		oFatura:Box( 0275 , 0000 , nBoxIten		, 0450		)		// Box ITENS

		oFatura:Say( 0285 , 0010 , IMP0037			, oFont08N	)		// SEQ.
		oFatura:Line(0275 , 0045 , nBoxIten		, 0045		)		// Linha vertical

		oFatura:Say( 0285 , 0050 , IMP0038			, oFont08N	)		// EMISSAO
		oFatura:Line(0275 , 0095 , nBoxIten		, 0095		)		// Linha vertical

		oFatura:Say( 0285 , 0100 , 'TITULO'		, oFont08N	)		// DESCRIÇÂO
		oFatura:Line(0275 , 0150 , nBoxIten 		, 0150		)		// Linha vertical

		oFatura:Say( 0285 , 0160 , 'VALOR BRUTO R$'	, oFont08N	)	// VALOR BRUTO R$
		oFatura:Line(0275 , 0250 , nBoxIten 			, 0250		)		// Linha vertical

		oFatura:Say( 0285 , 0260 , 'DESCONTO R$'	, oFont08N	)		// DESCONTO R$
		oFatura:Line(0275 , 0350 , nBoxIten 		, 0350		)		// Linha vertical

		oFatura:Say( 0285 , 0365 , 'VALOR LIQUIDO R$', oFont08N	)	// VALORE LIQUIDO R$

		oFatura:Line( 0290 ,0000 , 0290 , 0450 )						// Linha Horizontal

		oFatura:Box( 0275 , 0459 , 0350 , 0559 )						// Primeiro Box
		oFatura:Box( 0360 , 0459 , 0430 , 0559 )						// Segundo Box
		oFatura:Say( 0285 , 0477 , IMP0035 , oFont08N	)				// Reservado a Intiuição
		oFatura:Say( 0295 , 0488 , IMP0036 , oFont08N	)				// Financeiro

		nLin := 0300

		For X := nItensIni To nItensFim

			nQtde += 1

			oProcess:IncRegua2("Documento : " + aInfoItens[14][X][02] )

			xValBruto	:= aInfoItens[14][X][04]
			xValLiqui	:= aInfoItens[14][X][06]
//			xValDesc	:= aInfoItens[14][X][04] - aInfoItens[14][X][06]

			xValDesc	:= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

			xValBruto	:= Transform(	xValBruto	, GetSX3Cache("E1_VALOR" , "X3_PICTURE") )
			xValDesc	:= Transform(	xValDesc	, GetSX3Cache("E1_VALOR" , "X3_PICTURE") )
			xValLiqui	:= Transform(	xValLiqui	, GetSX3Cache("E1_VALOR" , "X3_PICTURE") )

			oFatura:Say( nLin , 0003, StrZero(X,10)							, oFont08	)		// SEQ.
	 		oFatura:Say( nLin , 0050, DtoC( StoD( aInfoItens[14][X][03] ) ), oFont08	)		// Emissao
			oFatura:Say( nLin , 0100, aInfoItens[14][X][02]					, oFont08	)		// Descricao

			oFatura:SayAlign( nLin - 007, 0140, xValBruto, oFont08, 100,/*nHeigth*/,/*[nClrText]*/, 1, 1)
			oFatura:SayAlign( nLin - 007, 0240, xValDesc , oFont08, 100,/*nHeigth*/,/*[nClrText]*/, 1, 1)
			oFatura:SayAlign( nLin - 007, 0340, xValLiqui, oFont08, 100,/*nHeigth*/,/*[nClrText]*/, 1, 1)

			nLin += 10

			If nQtde == nItensFolhas
				nItensIni		+= nQtde
				nItensFolhas	:= 47
				nQtde			:= 0
				Exit
			EndIf

		Next X

		// Rodape

		If	Z == 1

			oFatura:Box( 0675 , 0000 , 0695		, 0450 )
			oFatura:Say( 0687 , 0010 , IMP0032	, oFont08N	)					// Sub Total

			oFatura:Box( 0700 , 0000 , 0720 	, 0450 )
			oFatura:Say( 0712 , 0010 , IMP0033	, oFont08N	)					// Desconto Oferecido

			oFatura:Box( 0725 , 0000 , 0745 	, 0450 )
			oFatura:Say( 0737 , 0010 , IMP0034	, oFont08N	)					// Total desta Fatura

			oFatura:Box( 0750 , 0000 , 0770 	, 0559	)						// Extenso
			oFatura:Say( 0762 , 0010 , 'Valor por Extenso :' , oFont08N	 )

			oFatura:SayAlign( 0682	, 0330 , Transform( aInfoItens[11]	, GetSX3Cache("E1_VALOR","X3_PICTURE")	)	, oFont08,100,/*nHeigth*/,/*[nClrText]*/, 1, 1	)		// Sub Total
			oFatura:SayAlign( 0707	, 0330 , Transform( aInfoItens[13]	, GetSX3Cache("E1_VALOR","X3_PICTURE")	)	, oFont08,100,/*nHeigth*/,/*[nClrText]*/, 1, 1	)		// Desconto Oferecido
			oFatura:SayAlign( 0732	, 0330 , Transform( aInfoItens[12]	, GetSX3Cache("E1_VALOR","X3_PICTURE")	)	, oFont08,100,/*nHeigth*/,/*[nClrText]*/, 1, 1	)		// Total desta Fatura

			oFatura:Say( 0762 , 0080 , AllTrim( Extenso( aInfoItens[12] , .F. , 1 ) ) , oFont08N	 )

			nBoxIten := 0770

		EndIf

		_nBanco	:= SA1->A1_BCO1
		_nAgencia	:= AllTrim( SA1->A1_XAGENC1 )
		_nContaC	:= AllTrim( SA1->A1_XCONTA1 )

		oFatura:Box( 0675 , 0459 , 0745 , 0559 )
		oFatura:Say( 0685 , 0460 , IMP0025			, oFont08N	)			// Cobrança em :
		oFatura:Say( 0692 , 0460 , "( ) "+IMP0026	, oFont07N	)			// Carteira
		oFatura:Say( 0702 , 0460 , "( ) "+IMP0027	, oFont07N	)			// Boleto Bancario
		oFatura:Say( 0712 , 0460 , "(X) "+IMP0028	, oFont07N	)			// Deposito em C/C
		oFatura:Say( 0722 , 0460 , 		 IMP0029	, oFont07N	)			// Nº Bco
		oFatura:Say( 0722 , 0490 , _nBanco			, oFont07	)
		oFatura:Say( 0732 , 0460 , 		 IMP0030	, oFont07N	)			// Agência
		oFatura:Say( 0732 , 0490 , _nAgencia		, oFont07	)
		oFatura:Say( 0742 , 0460 , 		 IMP0031	, oFont07N	)			// C/C
		oFatura:Say( 0742 , 0490 , _nContaC		, oFont07	)

		oFatura:Box( 0775 , 0000 , 0805 	, 0559		)
		oFatura:Say( 0785 , 0010 , IMP0009	, oFont08N	)	  				// Observaçoes
		oFatura:Say( 0785 , 0060 , IMP0010	, oFont08	)

		nLin := 0785

		For Y := 1 To Len( aObs )
			If Empty( aObs[Y] )
				Loop
			EndIf
			oFatura:Say( nLin + 7 , 0060 , aObs[Y] , oFont08	)
			nLin += 7
		Next y

		xPagIni := cValToChar( Z )
		xPagFim := cValToChar( nQtdePag )

		oFatura:Say( 0812 , 0530 , 'Pág. ' + xPagIni + '/' + xPagFim , oFont07N		)

	Next Z

	oFatura:Preview()

	If File( oFatura:cFilePrint )
		FErase( oFatura:cFilePrint )
	EndIf

	oFatura:EndPage()

	oFatura:DeActivate()

	RestArea( aArea )

Return
