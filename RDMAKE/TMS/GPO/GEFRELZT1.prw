#Include "PROTHEUS.CH"
#include "TOPCONN.CH"
#include "TBICODE.CH"
#include "TBICONN.CH"

#Define MSG0001 "Aguarde"
#Define MSG0002 "Processando Informações - Relatório "
#Define MSG0003 "Carregando Planilha do Excel"

#Define nAlign01 1		// Left
#Define nAlign02 2		// Center
#Define nAlign03 3		// Right

#Define nFormat01 1		// General
#Define nFormat02 2		// Number
#Define nFormat03 3		// Monetario
#Define nFormat04 4		// Date Time

#Define lTotal01 .T.		// Totaliza
#Define lTotal02 .F.		// Não Totaliza

/*
Programa    : GEFRELZT1
Funcao      :
Data        : 01/02/2017
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Impressao do Relatorio das Tabelas de Preço do GPO
Sintaxe     : GEFRELZT1
Chamenda    : Menu
*/


User Function GEFRELZT1							// u_GEFRELZT1()
	Local aArea			:= GetArea()

	Private oExcel		:= Nil
	Private oXls			:= Nil

	Private cSheet
	Private cTitulo		:= 'Tabela de Preço - '

	Private lEnd			:= .T.
	Private lAbortPrint	:= .F.
	Private cTipoRel

	Private TrabQuery

	If AjustaParam()

		Processa( { |lEnd| View() } , MSG0001, MSG0002 + cTipoRel , .T. )

	EndIf

	If Select( "TrabQuery" ) # 0
		( TrabQuery )->(DbCloseArea())
	EndIf

	RestArea( aArea )

Return


/*
Programa    : GEFRELZT1
Funcao      : Função Estatica  - View
Data        : 01/02/2017
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Faz o Controle da Visualização do Relatorio
Sintaxe     : View()
Chamenda    : Interna
*/

Static Function View()
	Local aArea := GetArea()

	Begin Sequence

		Model()

		If Select( "TrabQuery" ) # 0
			( TrabQuery )->(DbCloseArea())
		EndIf

		If !lEnd
			Break
		EndIf

		Processa( { || ViewExcel() } , MSG0001, MSG0003 , .F. )

	End Sequence

	RestArea( aArea )

Return( Nil )

/*
Programa    : GEFRELZT1
Funcao      : Função Estatica  - ViewExcel
Data        : 01/02/2017
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Faz o carregamento dos dados para visualização da planilha
Chamenda    : Interna
*/

Static Function ViewExcel
	Local aArea := GetArea()

	MV_PAR02 := AllTrim(MV_PAR01) + AllTrim(MV_PAR02) + '_' + cTipoRel + ".XML"

	oExcel:Activate()
	oExcel:GetXMLFile( MV_PAR02 )
	oExcel:DeActivate()

	oXls := MsExcel():New()

	oXls:WorkBooks:Open(MV_PAR02)
	oXls:SetVisible(.T.)
	oXls:Destroy()

	RestArea( aArea )
Return( Nil )

/*
Programa    : GEFRELZT1
Funcao      : Função Estatica  - Model
Data        : 01/02/2017
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Modelagem do Relatorio
Sintaxe     : Model()
Chamenda    : Interna
*/

Static Function Model
	Local aArea	:= GetArea()
	Local nRec		:= 0
	Local nRecTot := 0
	Local nPosTab	:= 0
	Local nPosFlu := 0
	Local nPosDia := 0
	Local aArray
	Local aArrayAux
	Local aTipTab
	Local aTipFlu
	Local aTipDia
	Local xZT1_TIPTAB
	Local xZT1_TIPFLU
	Local xZTF_DIASEM

	If Select( "TrabQuery" ) # 0
		( TrabQuery )->(DbCloseArea())
	EndIf

	( TrabQuery )	:= GetNextAlias()

	Begin Sequence

		BuildQuery()

		DbSelectArea( (TrabQuery) )

		If ( TrabQuery )->( Eof() )
			Aviso("Atenção","Não existem informações a serem impressas.",{"OK"})
			lEnd := .F.
			Break
		EndIf

		aTipTab := RetSX3Box(GetSX3Cache("ZT1_TIPTAB","X3_CBOX"),,,1)
		aTipFlu := RetSX3Box(GetSX3Cache("ZT1_TIPFLU","X3_CBOX"),,,1)
		aTipDia := RetSX3Box(GetSX3Cache("ZTF_DIASEM","X3_CBOX"),,,1)

		( TrabQuery )->( DbGoBottom() )

		( TrabQuery )->( DbEval( { || nRecTot += 1 } ) )

		( TrabQuery )->( DbgoTop() )

		cTitulo := cTitulo + cTipoRel

		cSheet := cTipoRel

		oExcel := FwMsExcel():New()

		oExcel:AddworkSheet( cSheet )
		oExcel:AddTable(cSheet,cTitulo)

		oExcel:AddColumn(cSheet,cTitulo,'Cod. Cliente'		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'Loja Cliente'		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'Cliente'				, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'Cod Fornecedor'		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'Loja Fornecedor'	, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'Nome Fornecedor'	, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'Inicio Vigencia'	, nAlign01, nFormat04, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'Fim Vigencia'		, nAlign01, nFormat04, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'Tipo da Tabela'		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'Versão da Tabela'	, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'Tipo de Fluxo'		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'Mun. Origem'			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'UF Origem'			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'Mun. Destino'		, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'UF Destino'			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'Itinerario'			, nAlign01, nFormat01, lTotal02 )
		oExcel:AddColumn(cSheet,cTitulo,'Veiculo'				, nAlign01, nFormat01, lTotal02 )

		If	MV_PAR10 == 1
			oExcel:AddColumn(cSheet,cTitulo,'Municipio'			, nAlign01, nFormat01, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'Descrição do Mun.'	, nAlign01, nFormat01, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'UF'					, nAlign01, nFormat01, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'Custo Coleta'		, nAlign03, nFormat03, lTotal02 )

		ElseIf MV_PAR10 == 2
			oExcel:AddColumn(cSheet,cTitulo,'Faixa de KM de'		, nAlign03, nFormat02, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'Faixa de KM Ate'	, nAlign03, nFormat02, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'$ Fixo One W'		, nAlign03, nFormat03, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'$ Fixo Round'		, nAlign03, nFormat03, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'$ KM One'			, nAlign03, nFormat03, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'$ KM Round'			, nAlign03, nFormat03, lTotal02 )

		ElseIf MV_PAR10 == 3
			oExcel:AddColumn(cSheet,cTitulo,'Tab.Compras'			, nAlign01, nFormat01, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'Ver.Tabela'			, nAlign01, nFormat01, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'It.Tab.Compr'		, nAlign01, nFormat01, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'Item'					, nAlign01, nFormat01, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'Dia da Semana'		, nAlign01, nFormat01, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'Hora Inicio'			, nAlign01, nFormat01, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'Hora Fim'			, nAlign01, nFormat01, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'Horas Franq.'		, nAlign01, nFormat01, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'Valor KM'			, nAlign03, nFormat03, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'Valor KM Adi'		, nAlign03, nFormat03, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'Valor Hr.Adc'		, nAlign03, nFormat03, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'Limit Hr.Cob'		, nAlign01, nFormat01, lTotal02 )
			oExcel:AddColumn(cSheet,cTitulo,'Valor Diaria'		, nAlign03, nFormat03, lTotal02 )
		EndIf

		ProcRegua( ( TrabQuery )->( nRecTot ) )

		( TrabQuery )->( DbGoTop() )

		While ( TrabQuery )->( ! Eof() ) .And. lEnd

			Store 'VERIFICAR' To xZT1_TIPTAB,xZT1_TIPFLU,xZTF_DIASEM

			nPosTab := aScan( aTipTab , { |Z| Z[2] = ( TrabQuery )->ZT1_TIPTAB } )

			If  nPosTab # 0
				xZT1_TIPTAB := AllTrim( aTipTab[nPosTab][3] )
			EndIf

			nPosFlu := aScan( aTipFlu , { |Z| Z[2] = ( TrabQuery )->ZT1_TIPFLU } )

			If  nPosFlu # 0
				xZT1_TIPFLU := AllTrim( aTipFlu[nPosFlu][3] )
			EndIf

			StaticCall( GEFRGPO2 , ChkAbort )

			IncProc('Atualizando Registro ' + cValToChar( ++nRec ) + ' de ' + cValToChar( nRecTot ) )

			aArray := {	( TrabQuery )->ZT1_CODCLI			,	;
							( TrabQuery )->ZT1_LOJCLI			,	;
							( TrabQuery )->ZT1_NOMCLI			,	;
							( TrabQuery )->ZT1_CODFOR			,	;
							( TrabQuery )->ZT1_LOJFOR			,	;
							( TrabQuery )->ZT1_NOMFOR 			,	;
							StoD( ( TrabQuery )->ZT1_INIVIG )	,	;
							StoD( ( TrabQuery )->ZT1_FIMVIG	 )	,	;
							xZT1_TIPTAB 							,	;
							( TrabQuery )->ZT1_VERTAB			,	;
							xZT1_TIPFLU							,	;
							( TrabQuery )->ZT1_MUNORI			,	;
							( TrabQuery )->ZT1_UFORI			 	,	;
							( TrabQuery )->ZT1_MUNDES			,	;
							( TrabQuery )->ZT1_UFDES				,	;
							( TrabQuery )->ZT1_DESCIT 			,	;
							( TrabQuery )->ZT1_VEICUL			}




			If	MV_PAR10 == 1

				aArrayAux	:= {	( TrabQuery )->ZTB_CODMUN	,;
									( TrabQuery )->ZTB_MUNICI	,;
									( TrabQuery )->ZTB_UF		,;
									( TrabQuery )->ZTB_CUSTO 	 ;
								}

			ElseIf MV_PAR10 == 2

				aArrayAux	:= {	( TrabQuery )->ZTD_FAIXAD	,;
									( TrabQuery )->ZTD_FAIXAA	,;
									( TrabQuery )->ZTD_VRFIXO	,;
									( TrabQuery )->ZTD_VRFIXR	,;
									( TrabQuery )->ZTD_VRKMON	,;
									( TrabQuery )->ZTD_VRKMRO	 ;
								}

			ElseIf MV_PAR10 == 3

				nPosDia := aScan( aTipDia , { |Z| Z[2] = ( TrabQuery )->ZTF_DIASEM } )

				If  nPosDia # 0
					xZTF_DIASEM := AllTrim( aTipDia[nPosDia][3] )
				EndIf

				aArrayAux	:= {	( TrabQuery )->ZTF_TABCOM	,;
									( TrabQuery )->ZTF_VERCOM	,;
									( TrabQuery )->ZTF_ITTABC	,;
									( TrabQuery )->ZTF_ITEM		,;
									xZTF_DIASEM					,;
									( TrabQuery )->ZTF_HRINI		,;
									( TrabQuery )->ZTF_HRFIM		,;
									( TrabQuery )->ZTF_HRFRAN	,;
									( TrabQuery )->ZTF_VALKM		,;
									( TrabQuery )->ZTF_VALKMA	,;
									( TrabQuery )->ZTF_VALHRA	,;
									( TrabQuery )->ZTF_LIMHRC	,;
									( TrabQuery )->ZTF_VALDIA	 ;
								}

			EndIf

			aEval( aArrayAux, { |Z| AADD( aArray , Z ) } )

			oExcel:AddRow(cSheet,cTitulo, aArray )

			( TrabQuery )->( DbSkip() )

		End While

	End Sequence

	RestArea( aArea )

Return( Nil )



/*
Programa    : GEFRELZT1
Funcao      : Função Estatica  - BuildQuery
Data        : 01/02/2017
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Cria a Query com informações necessarias
Sintaxe     : BuildQuery()
Chamenda    : Interna
*/

Static Function BuildQuery
	Local aArea	:= GetArea()
	Local cSelect := ''
	Local cWhere	:= ''
	Local cFrom 	:= ''
	Local cColumn	:= ''

	Begin Sequence

		StaticCall( GEFRGPO2 , ChkAbort )

		If !lEnd
			Break
		EndIf

		If Select( "DbTrab" ) # 0
			( DbTrab )->( DbCloseArea() )
		EndIf

		If ( ValType( MV_PAR07 ) == 'N' ) // MV_PAR07 == 1
			cWhere	+= " And GetDate() BetWeen ZT1_INIVIG And ZT1_FIMVIG "
		Else
			cWhere	+= " And ZT1_INIVIG >= '" +  DtoS( MV_PAR08 ) + "'"
			cWhere	+= " And ZT1_FIMVIG <= '" +  DtoS( MV_PAR09 ) + "'"
		EndIf

		Do Case
			Case MV_PAR10 == 1

				cSelect	+= "ZTB_CODMUN,ZTB_MUNICI,ZTB_UF,ZTB_CUSTO"

				cFrom		+= RetSqlName( "ZTB" ) + " ZTB "

				cWhere		+= " And ZT1_CODTAB = ZTB_TABCOM "
				cWhere		+= " And ZT1_VERTAB = ZTB_VERTAB "
				cWhere 	+= " And ZT1_ITEMTB = ZTB_ITTABC "

				cWhere 	+= " And ZTB.D_E_L_E_T_= ' ' "

			Case MV_PAR10 == 2

				cSelect 	+= "ZTD_FAIXAD,ZTD_FAIXAA,ZTD_VRFIXO,ZTD_VRFIXR,ZTD_VRKMON,ZTD_VRKMRO "

				cFrom		+= RetSqlName( "ZTD" ) + " ZTD "

				cWhere 	+= " And ZT1_CODTAB = ZTD_TABCOM "
				cWhere 	+= " And ZT1_VERTAB = ZTD_VERCOM "
				cWhere 	+= " And ZT1_ITEMTB = ZTD_ITTABC "

				cWhere 	+= " And ZTD.D_E_L_E_T_= ' ' "

			Case MV_PAR10 == 3
				cSelect 	+= "ZTF_TABCOM,ZTF_VERCOM,ZTF_ITTABC,ZTF_ITEM,ZTF_DIASEM,ZTF_HRINI,ZTF_HRFIM, "
				cSelect 	+= "ZTF_HRFRAN,ZTF_VALKM,ZTF_VALKMA,ZTF_VALHRA,ZTF_LIMHRC,ZTF_VALDIA"

				cFrom		+= RetSqlName( "ZTF" ) + " ZTF "

				cWhere 	+= " And ZT1_CODTAB = ZTF_TABCOM "
				cWhere 	+= " And ZT1_VERTAB = ZTF_VERCOM "
				cWhere 	+= " And ZT1_ITEMTB = ZTF_ITTABC "

				cWhere 	+= " And ZTF.D_E_L_E_T_= ' ' "

		End Case

		If	! Empty( MV_PAR05 )
			cWhere 	+= " And ZT1_CODFOR = '" + MV_PAR05 + "' "
			cWhere 	+= " And ZT1_LOJFOR = '" + MV_PAR06 + "' "
		EndIf

		cSelect	:= "%" + cSelect	+ "%"
		cFrom		:= "%" + cFrom	+ "%"
		cWhere		:= "%" + cWhere	+ "%"
		cColumn	:= "%" + cColumn	+ "%"

		BeginSql Alias TrabQuery

			Select	ZT1_CODFOR,ZT1_LOJFOR,ZT1_NOMFOR,ZT1_CODCLI,ZT1_LOJCLI,ZT1_NOMCLI,
					ZT1_INIVIG,ZT1_FIMVIG,ZT1_TIPTAB,ZT1_VERTAB,ZT1_TIPFLU,ZT1_MUNORI,
					ZT1_UFORI,ZT1_MUNDES,ZT1_UFDES,ZT1_DESCIT,ZT1_VEICUL,

					%Exp:cSelect%

			From	%Table:ZT1% ZT1,
					%Exp:cFrom%

			Where (		ZT1.%NotDel%
						And	ZT1_CODCLI = %Exp:MV_PAR03%
						And	ZT1_LOJCLI = %Exp:MV_PAR04%
					)

					%Exp:cWhere%

			Order By ZT1_CODFOR,ZT1_VEICUL

		EndSql

		aQuery := GetLastQuery()

		StaticCall( GEFRGPO2 , ChkAbort )

		If !lEnd
			Break
		EndIf


	End Sequence

	RestArea( aArea )

Return


/*
Programa	: GEFRELZT1
Funcao		: Função Estatica - AjustaParam
Data		: 01/02/2017
Autor		: André Costa
Descricao	: Função de Apoio
Uso			: Ajusta os Parametros do Relatorio
Sintaxe	: AjustaParam()
Chamenda	: Interna
Retorno	: Logico
*/


Static Function AjustaParam

	Local aParamBox	:= {}
	Local aRet			:= {}

	Local lRetorno	:= .F.
	Local lCanSave	:= .F.
	Local lUserSave	:= .T.
	Local cLoad		:= "GEFRELZT1"
	Local aRadio		:= {}
	Local aAux			:= RetSX3Box(GetSX3Cache("ZT1_TIPREG","X3_CBOX"),,,1)
	Local cDiretorio	:= Space(100)
	Local aCombo		:= {"Vigente","Retroativa"}

	For X := 1 To Len( aAux )
		If ! ( Empty( aAux[X][1] ) )
			AADD( aRadio , AllTrim( aAux[X][3] ) )
		EndIf
	Next X

	Aadd(aParamBox,{6,"Diretorio"		,cDiretorio			,"@!"	,"StaticCall(GEFR022,VldDiretorio)","",50,.T.,"XML (*.XML) |*.XML","U:",GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY } )
	aAdd(aParamBox,{1,"Arquivo"			,PadR("RELTAB",50)	,"@!"	,"StaticCall(GEFR022,VldArquivo)" ,"","",50,.T.})

	aAdd(aParamBox,{1,"Cliente"			,Space(GetSx3Cache("ZT1_CODCLI","X3_TAMANHO")),"@!","","SA1","",50,.T.})
	aAdd(aParamBox,{1,"Loja"				,Space(GetSx3Cache("ZT1_LOJCLI","X3_TAMANHO")),"@!","","","",05,.T.})
	aAdd(aParamBox,{1,"Fornecedor"		,Space(GetSx3Cache("ZT1_CODFOR","X3_TAMANHO")),"@!","","SA2","",50,.F.})
	aAdd(aParamBox,{1,"Loja"				,Space(GetSx3Cache("ZT1_LOJFOR","X3_TAMANHO")),"@!","","","",05,.F.})

	aAdd(aParamBox,{2,"Tabelas"			,1,aCombo,50,"",.T.})

	aAdd(aParamBox,{1,"Data Inicial"	,Ctod(Space(8)),"","","","!( ValType( MV_PAR07 ) == 'N' )",50,.F.})
	aAdd(aParamBox,{1,"Data Final"		,Ctod(Space(8)),"","StaticCall(GEFRELZT1,VldDataFim,MV_PAR08,MV_PAR09)"	,"","!( ValType( MV_PAR07 ) == 'N' )",50,.F.})

	aAdd(aParamBox,{3,"Tipo do Relatorio",1,aRadio,50,"",.T.})

	If	ParamBox(aParamBox,"Parâmetros...",@aRet,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPosX*/,/*nPosy*/,/*oDlgWizard*/,cLoad,lCanSave,lUserSave)

		cTipoRel	:= aRadio[MV_PAR10]
		lRetorno	:= .T.

	Endif

Return( lRetorno )

/*
Programa    : GEFRELZT1
Funcao      : Função Estatica - DataFim
Data        : 19/01/2016
Autor       : André Costa
Descricao   : Função de Apoio
Uso         : Ajusta os Parametros do Relatorio
Sintaxe     : StaticCall( GEFRELZT1 , DataFim , dDataIni , dDataFim )
Chamenda    : Interna
*/

Static Function VldDataFim( dDataIni , dDataFim )
	Local lRetorno := .F.

	Begin Sequence

		If ( dDataFim >= dDataIni )
			lRetorno := .T.
			Break
		EndIf

		Aviso("Atenção","Data Final não pode ser menor que Data Inicial.",{"OK"})

	End Sequence

Return( lRetorno )


