#Include "ProtheusS.CH"
#Include "TbiConn.CH"
#Include "Colors.CH"
#Include "RptDef.CH"
#Include "FWPrintSetup.ch"
#Include "TopConn.ch"


/*
Programa	: GEFFINR001
Funcao		: Static Fucntion GEFFINR001
Data		: 18/08/2015
Autor		: André Costa
Descricao	: Função principal
Uso			: Faz a chamada da função Static GEFFINR001
Sintaxe	: GEFFINR001()
Chamada	: Externa
*/


User Function GEFFINR001					// u_GEFFINR001()
	Local aArea 			:= GetArea()
	Local aParamBox		:= {}
	Local aPerg			:= {}
	Local lCanSave		:= .F.
	Local lUserSave		:= .T.
	Local cLoad			:= FunName()

	Local bOK				:= { || VldDiretorio(MV_PAR08,MV_PAR06) }

	Private oProcess		:= NIL

	Private lEnd			:= .T.
	Private lAbortPrint	:= .F.
	Private aBuildInfo	:= {}

	Begin Sequence

		AADD(aPerg,{01,"Data Inicial"		,Ctod(Space(8))	,""		,""																,"","",50,.F.})	// Tipo data
		AADD(aPerg,{01,"Data Final"			,Ctod(Space(8))	,""		,"StaticCall( GEFFINR001,VldDataFim,MV_PAR01,MV_PAR02)"	,"","",50,.F.})	// Tipo data
		AADD(aPerg,{01,"Fatura Inicial"		,Space(09)			,"@!"	,""																,"","",30,.F.})		// Tipo caractere
		AADD(aPerg,{01,"Fatura Final"		,Space(09)			,"@!"	,"StaticCall( GEFFINR001,VldFatura,MV_PAR03,MV_PAR04)"	,"","",30,.F.})		// Tipo caractere
		AADD(aPerg,{01,"Prefixo da Fat"		,Space(03)			,"@!"	,"!Empty( MV_PAR05 )"										,"","",15,.F.})		// Tipo caractere

		AADD(aPerg,{03,"Impressão em"		,1,{"SPOOL","PDF"},50,"",.F.})

		AADD(aPerg,{11,"Observação"			,""	,".T.",".T.",.F.})

		AADD(aPerg,{06,"Diretorio"			,Space(50)			,"@!"	,"StaticCall( GEFFINR001,VldDiretorio,MV_PAR08,MV_PAR06)","MV_PAR06 == 2",50,.F.,"*.* (*.*) |*.*","C:",GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY } )

		If ! ( ParamBox( aPerg , "Parametros de Impressão" , aParamBox,bOk,/*aButtons*/,/*lCentered*/,/*nPosX*/,/*nPosy*/,/*oDlgWizard*/,cLoad,lCanSave,lUserSave) )

			Break

		EndIf

		oProcess := MsNewProcess():New( { |lEnd| xBuildFatura() } ,"Processando Informações","Aguarde...",.T.)
		oProcess:Activate()

		oProcess := MsNewProcess():New( { |lEnd| GEFFINR001() } ,"Imprimindo Fatura","Aguarde...",.T.)
		oProcess:Activate()

	End Sequence

	RestArea( aArea )

Return

Static Function xBuildFatura
	Local aArea		:= GetArea()
	Local Trab01		:= GetNextAlias()
	Local cSelect 	:= "Count(*) As xContFat"
	Local xQtdeReg	:= 0
	Local xDesc		:= 0
	Local aLastQuery

	For X := 1 To 2

		StaticCall( GEFRGPO2 , ChkAbort )

		If !lEnd
			Exit
		EndIf

		If X == 2
			cSelect := "E1_NUM,E1_VENCREA,E1_OBS,E1_CLIENTE,E1_LOJA,E1_TIPO,E1_FATURA	,E1_FATPREF,E1_SALDO,"
			cSelect += "E1_VALOR,E1_NATUREZ	,E1_VALLIQ	,E1_TPCAR,E1_NUMCVA,E1_COLMON,E1_FILIAL,E1_EMISSAO"
		EndIf

		cSelect := "%" + cSelect + "%"

		If Select( Trab01 ) # 0
			(Trab01)->(DbCloseArea())
		EndIf

		BeginSql Alias Trab01

			Select %Exp:cSelect%

			From 	%Table:SE1% SE1

			Where	SE1.%NotDel%
				And	SE1.E1_FILIAL		=		 %Exp:xFilial("SE1")%
				And	SE1.E1_PREFIXO	=	 	 %Exp:MV_PAR05%
				And	SE1.E1_EMISSAO	BetWeen %Exp:MV_PAR01% And %Exp:MV_PAR02%
				And	SE1.E1_NUM			BetWeen %Exp:MV_PAR03% And %Exp:MV_PAR04%

		EndSql

		If X # 2
			xQtdeReg := ( Trab01 )->xContFat
		EndIf

		aLastQuery := GetLastQuery()

	Next X

	oProcess:SetRegua1( xQtdeReg )

	While (Trab01)->( ! Eof() ) .And. lEnd

		StaticCall( GEFRGPO2 , ChkAbort )

		oProcess:IncRegua1("Processando Fatura : " + ( Trab01 )->E1_NUM )
/*
		DbSelectArea("SE1")
		DbSetOrder(1)

		If ( DbSeek(xFilial("SE1")+MV_PAR05+( Trab01 )->E1_NUM+" "+"AB-"))
			xDesc := SE1->E1_VALOR
		EndIf
*/
		xDesc := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

		AADD( aBuildInfo ,  {	( Trab01 )->E1_FILIAL			,;
									( Trab01 )->E1_NUM				,;
									( Trab01 )->E1_CLIENTE			,;
									( Trab01 )->E1_LOJA				,;
									( Trab01 )->E1_TIPO				,;
									( Trab01 )->E1_TPCAR				,;
									( Trab01 )->E1_NUMCVA			,;
									( Trab01 )->E1_COLMON			,;
									( Trab01 )->E1_VENCREA			,;
									( Trab01 )->E1_OBS				,;
									( Trab01 )->E1_VALOR				,;
									( Trab01 )->E1_VALOR - xDesc	,;
									xDesc								,;
									{}									 ;
								} )

		xBuildManInfo()

		(Trab01)->( DbSkip() )

 	End While

	(Trab01)->( DbCloseArea() )

	RestArea( aArea )

Return


Static Function xBuildManInfo
	Local aArea		:= GetArea()
	Local Trab02		:= GetNextAlias()
	Local cInfMAN		:= AllTrim( aBuildInfo[Len(aBuildInfo)][10] )
	Local lInfMan		:= IIf( aBuildInfo[Len(aBuildInfo)][3]+aBuildInfo[Len(aBuildInfo)][4] $ AllTrim(GETNewPar("MV_XCLIMAN","04858701|15882200")) .And. aBuildInfo[Len(aBuildInfo)][5] = MV_PAR05 , .T. , .F.)
	Local xQtdeReg	:= 0
	Local cSelect		:= "Count(*) As xContTit"
	Local cWhere
	Local X

	cWhere := " And SE1.E1_FATURA = '" + aBuildInfo[Len(aBuildInfo)][2]	+ "'"

	If lInfMan

		cInfMAN += IIf( Empty( cInfMAN ),'', "|" ) + "Inf. MAN => Tipo Carreg.: " + AllTrim(aBuildInfo[Len(aBuildInfo)][6]) + " - " + "No.CVA: " + AllTrim(aBuildInfo[Len(aBuildInfo)][7]) + " - " + "No.Moniloc: " + AllTrim(aBuildInfo[Len(aBuildInfo)][8])

		cWhere += " And	SE1.E1_FATPREF 	= '" + MV_PAR05		+ "'"
		cWhere += " And	SE1.E1_CLIENTE 	= '" + aBuildInfo[Len(aBuildInfo)][3]	+ "'"
		cWhere += " And	SE1.E1_LOJA		= '" + aBuildInfo[Len(aBuildInfo)][4]	+ "'"

	Else
		cWhere += " And E1_NATUREZ <> 'ISS' "
	EndIf

	cWhere := "%"+cWhere+"%"

	For X := 1 To 2

		StaticCall( GEFRGPO2 , ChkAbort )

		If !lEnd
			Exit
		EndIf

		If X == 2
			cSelect := "E1_FILIAL,E1_NUM,E1_SALDO,E1_EMISSAO,E1_VALOR,E1_VALLIQ,E1_FATURA"
		EndIf

		cSelect := "%" + cSelect + "%"

		If Select( Trab02 ) # 0
			(Trab02)->(DbCloseArea())
		EndIf

		BeginSql Alias Trab02

			Select %Exp:cSelect%

			From 	%Table:SE1% SE1
			Where	( SE1.%NotDel%
				And	SE1.E1_FILIAL	= %Exp:xFilial("SE1")% )

			%Exp:cWhere%

		EndSql

		If X # 2
			xQtdeReg := ( Trab02 )->xContTit
		EndIf

		aLastQuery := GetLastQuery()

	Next X

	oProcess:SetRegua2( xQtdeReg )

	While (Trab02)->( ! Eof() ) .And. lEnd

		StaticCall( GEFRGPO2 , ChkAbort )

		oProcess:IncRegua2("Processando Titulo : " + ( Trab02 )->E1_NUM )

		AADD( aBuildInfo[Len(aBuildInfo)][14] ,{	( Trab02 )->E1_FILIAL	,;
														( Trab02 )->E1_NUM		,;
														( Trab02 )->E1_EMISSAO	,;
														( Trab02 )->E1_VALOR		,;
														( Trab02 )->E1_SALDO		,;
														( Trab02 )->E1_VALLIQ	 ;
													} )
		(Trab02)->( DbSkip() )

 	End While

	(Trab02)->( DbCloseArea() )

	RestArea( aArea )

Return


Static Function GEFFINR001
	Local aArea 				:= GetArea()
	Local xObs
	Local X

	Private aObs 				:= {}
	Private lDisableSetup	:= .T.
	Private lViewPDF			:= .F.

	Private cPrinter			:= IIf( Empty( MV_PAR06 ) .Or. MV_PAR06 == 1	, GetImpWindows(.F.)[1]	, "PDF" )
	Private cPathPDF			:= IIf( Empty( MV_PAR06 ) .Or. MV_PAR06 == 1	, ""						, AllTrim(MV_PAR08 ) )
	Private nDevice			:= IIf( Empty( MV_PAR06 ) .Or. MV_PAR06 == 1	, IMP_SPOOL				, IMP_PDF )
	Private cPathInServer	:= GetTempPath(.T.)

	Private nModalResult

	If Len( aBuildInfo ) == 0
		MsgInfo( "Não foram encontrados registros com os parametros informados." , "Atenção" )
		Return
	EndIf

	oProcess:SetRegua1( Len( aBuildInfo ) )

	For X := 1 To Len( aBuildInfo )

		StaticCall( GEFRGPO2 , ChkAbort )

		If !lEnd
			Exit
		EndIf

		If !( SA1->( DbSeek( xFilial("SA1") + aBuildInfo[X][3] + aBuildInfo[X][4]  ) ) )

			cMensagem := "Cliente : " + aBuildInfo[X][3] + " Loja : " + aBuildInfo[X][4] + "" + CRLF
			cMensagem += "Não encontrado " + CRLF
			cMensagem += "Verifique Cadastro de Clientes" + CRLF

			MsgInfo( cMensagem , "Atenção" )

			Loop

		EndIf

		oProcess:IncRegua1("Processando Fatura : " + aBuildInfo[X][2] )

		xObs := MV_PAR07 + "|" + aBuildInfo[X][10]

		aObs := StrToKArr( xObs , "|" )

		StaticCall( GEFCNHFAT , GEFCNHFAT , aBuildInfo[X] , aObs , .F.)

	Next X

	RestArea( aArea )

Return


/*
Programa    : GEFFINR001
Data        : 07/04/2016
Autor       : André Costa
Funcao      : Static Function - Controle
Descricao   : Faz a validação do diretorio do arquivo
Sintaxe     : xValDiretorio()
Chamanda    : xParambox
Uso         : Interno
*/


Static Function xValDiretorio
	Local aArea		:= GetArea()
	Local lRetorno	:= .F.

	Begin Sequence

		If Empty( MV_PAR01 )
			Aviso("Atenção","Necessario o prenchimento do diretorio.",{"OK"})
			Break
		EndIf

		lRetorno := .T.

	End Sequence

	RestArea( aArea )

Return( lRetorno )



/*
Programa	: GEFFINR001
Funcao		: Função Estatica - VldDiretorio
Data		: 19/10/2016
Autor		: Andre Costa
Descricao	: Função de Apoio
Uso			: Validação do Nome do Diretorio
Sintaxe	: VldDiretorio( xMVPAR01 )
Chamenda	: Interna
Retorno	: Logico
*/


Static Function VldDiretorio( xMVPAR01 , xMVPAR02 )
	Local lRetorno	:= .T.

	Begin Sequence

		If xMVPAR02 == 1
			Break
		EndIf

		If ExistDir( Alltrim( xMVPAR01 ) )
			Break
		EndIf

		Aviso("Atenção","Diretorio Invalido.",{"OK"})

		lRetorno := .F.

	End Sequence

Return( lRetorno )

/*
Programa    : GEFFINR001
Funcao      : Função Estatica - VldCTE
Data        : 19/01/2016
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Ajusta os Parametros do Relatorio
Sintaxe     :
Chamenda    : Interna
*/

Static Function VldFatura(xMVPAR01,xMVPAR02)
	Local lRetorno := .T.

	Begin Sequence

		If Empty( xMVPAR02 )
			Break
		EndIf

		If xMVPAR02 >= xMVPAR01
			Break
		EndIf

		Aviso("Atenção","Fatura Final informada é menor que a Fatura Inicial.",{"OK"})

		lRetorno := .F.

	End Sequence

Return( lRetorno )


/*
Programa    : GEFFINR001
Funcao      : Função Estatica - DataFim
Data        : 19/01/2016
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Ajusta os Parametros do Relatorio
Sintaxe     :
Chamenda    : Interna
*/

Static Function VldDataFim( xMVPAR01 , xMVPAR02 )
	Local lRetorno := .T.

	Begin Sequence

		If Empty( xMVPAR02 )
			Break
		EndIf

		If xMVPAR02 >= xMVPAR01
			Break
		EndIf

		Aviso("Atenção","Data Final não pode ser menor que Data Inicial.",{"OK"})

		lRetorno := .F.

	End Sequence

Return( lRetorno )


