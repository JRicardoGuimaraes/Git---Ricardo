#Include "Totvs.ch"
#Include "Fwmvcdef.ch"
#Include "FwBrowse.ch"

User Function GEFCNHLG()
//-------------------------------------------------------------------------------------------------
/* {2LGI} GEFCNHLOG
@autor		: Luiz Alexandre
@descricao	: Funcao principal da rotina
@since		: Ago./2014
@using		: Interface CNH
@review
*/
//-------------------------------------------------------------------------------------------------
// --- Variaveis utilizadas
Local aCoors  		:= FWGetDialogSize(oMainWnd)
Local cTitulo 		:= 'Log'
Local _nCount			:= 1

Private _lEnd			:= .f.
Private _aTipos		:= {}
Private _aFiltros		:= {}
Private _aFields		:= {}
Private _aBrowses		:= {}
Private _aBco			:= {}
Private _aPgtos		:= {}
Private _aPgtosForn	:= {}
Private _aModelos		:= {}
Private _aTabelas		:= {}
Private _aStruc		:= {}
Private _cFileTmp		:= ""
Private _nFolder  	:= 1
Private oPnlSE2, oFWLayerSE2
Private oPnl, oFWLayer
Private aGrfTpc, aGrfCom , aGrfTPDF, aGrfCTDF, aGrfDCTo, aGrfDCNo, aGrfIRT, aGrfIRN, aGrfIPT, aGrfIPN, aGrfNeg, aGrfCatTrp, aGrfTpLot, aGrfCCon
Private oGrfTpc, oGrfCom , oGrfTPDF, oGrfCTDF, oGrfDCTo, oGrfDCNo, oGrfImp, oGrfNeg, oGrfCatTrp, oGrfTpLot, oGrfCCon
Private oFolder, oDLG
Private oBrowseCal, oBrowseMod, oBrowseBco, oBrowseIfin, oBrowsePfor 

// --- Define estrutura das tabelas utilizadas
Aadd(_aFields, { "E2_FILIAL"			,"C", TAMSX3("E2_FILIAL")[1]	, TAMSX3("E2_FILIAL")[2]	, "Filial"				, .T., X3Picture("E2_FILIAL")} )
Aadd(_aFields, { "E2_CODBAR"			,"C", TAMSX3("E2_CODBAR")[1]	, TAMSX3("E2_CODBAR")[2]	, "Codigo de Barras"	, .T., X3Picture("E2_CODBAR")} )
Aadd(_aFields, { "E2_MODELO"			,"C", TAMSX3("E2_MODELO")[1]	, TAMSX3("E2_MODELO")[2]	, "Modelo"				, .T., X3Picture("E2_MODELO")} )
Aadd(_aFields, { "E2_TIPOPAG"			,"C", TAMSX3("E2_TIPOPAG")[1]	, TAMSX3("E2_TIPOPAG")[2]	, "Forma"				, .T., X3Picture("E2_TIPOPAG")} )
Aadd(_aFields, { "E2_PREFIXO"			,"C", TAMSX3("E2_PREFIXO")[1]	, TAMSX3("E2_PREFIXO")[2]	, "Prefixo"				, .T., X3Picture("E2_PREFIXO")} )
Aadd(_aFields, { "E2_NUM"				,"C", TAMSX3("E2_NUM")[1]		, TAMSX3("E2_NUM")[2]		, "Numero"				, .T., X3Picture("E2_NUM")} )
Aadd(_aFields, { "E2_TIPO"				,"C", TAMSX3("E2_TIPO")[1]		, TAMSX3("E2_TIPO")[2]		, "Tipo"				, .T., X3Picture("E2_TIPO")} )
Aadd(_aFields, { "E2_PARCELA"			,"C", TAMSX3("E2_PARCELA")[1]	, TAMSX3("E2_PARCELA")[2]	, "Parcela"	  			, .T., X3Picture("E2_PARCELA")} )
Aadd(_aFields, { "E2_SALDO"				,"N", TAMSX3("E2_SALDO")[1]		, TAMSX3("E2_SALDO")[2]		, "Valor"				, .T., X3Picture("E2_SALDO")} )
Aadd(_aFields, { "E2_VENCREA"			,"D", TAMSX3("E2_VENCREA")[1]	, TAMSX3("E2_VENCREA")[2]	, "Vencimento"			, .T., X3Picture("E2_VENCREA")} )
Aadd(_aFields, { "E2_NOMFOR"			,"C", TAMSX3("E2_NOMFOR")[1]	, TAMSX3("E2_NOMFOR")[2]	, "Fornecedor"			, .T., X3Picture("E2_NOMFOR")} )
Aadd(_aFields, { "E2_FORNECE"			,"C", TAMSX3("E2_FORNECE")[1]	, TAMSX3("E2_FORNECE")[2]	, "Codigo"				, .T., X3Picture("E2_FORNECE") } )
Aadd(_aFields, { "E2_LOJA"	   			,"C", TAMSX3("E2_LOJA")[1]		, TAMSX3("E2_LOJA")[2]		, "Loja"				, .T., X3Picture("E2_LOJA")} )

// --- Adiciona chave de indice para os arquivos
_aStruc 				:= { _aFields, { "E2_FILIAL+E2_PREFIXO+E2_NUM+E2_TIPO+E2_PARCELA" } }

// --- Cria dialog principal
Define MsDialog oDLG Title cTitulo From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel
oDLG:Activate(,,,.T.,,,{|| RptStatus({|| CNHLOG01()},"Aguarde", "Realizando consultas dos dados")})

Return



Static Function CNHLOG01()
//-------------------------------------------------------------------------------------------------
/* {2LGI} CNHLOG01
@autor		: Luiz Alexandre
@descricao	: Rotina que faz carga inicial e cria interface
@since		: Ago./2013
@using		: Central de pagamentos
@review
*/
//-------------------------------------------------------------------------------------------------
// ---	
Local cBrowseFiltro
Local oPnl,oFolderEst,oFolderGrf,oPnlGrf
Local oFWLayer, oWIN_TOP, oWIN_LEFT, oWIN_RIGHT, oWIN_MIDDLE
Local aColFrtCal, aColFrtPre, aColunas
Local nCount := 0
Local oData

// --- Cria folders conforme tipos de pagamento
oFolder 	:=  tFolder():New(30,0, {'Log'}, {'Log'}, oDLG)
oFolder	:Align 	:= CONTROL_ALIGN_ALLCLIENT
//
// --- Aba Contas a pagar
//                               
cBrowseTIT := "E2_FILIAL  >= '" + cFilAnt      + "' .AND. E2_FILIAL  <= '" + cFilAnt   + "' .AND. "
cBrowseTIT += "E2_VENCREA >= '" + Dtos(Mv_par01)  + "' .AND. E2_VENCREA <= '" + Dtos(Mv_par02) + "' .AND. "
cBrowseTIT += "Empty(E2_NUMBOR) .AND. "
cBrowseTIT += "Empty(E2_MODELO) .AND. Empty(E2_TIPOPAG) .AND. "
cBrowseTIT += "E2_SALDO > 0"

oPnlSE2 		:= tPanel():New(30,0,,oFolder:aDialogs[oFolder:nOption],,,,,,)
oPnlSE2:Align := CONTROL_ALIGN_ALLCLIENT

oFWLayerSE2 := FWLayer():New()
oFWLayerSE2:Init(oPnlSE2,.F.)
oFWLayerSE2:AddLine('LINE_TOP',65,.F.)
oFWLayerSE2:AddLine('LINE_MIDDLE',35,.F.)
oFWLayerSE2:AddCollumn('COL_TOP',100,.T.,'LINE_TOP')
oFWLayerSE2:AddCollumn('COL_LEFT',50,.T.,'LINE_MIDDLE')
oFWLayerSE2:AddCollumn('COL_RIGHT',50,.T.,'LINE_MIDDLE')
oFWLayerSE2:AddWindow('COL_RIGHT','WIN_RIGHT','Forma(s) de pagamento',100,.F.,.F.,,'LINE_MIDDLE',)
oFWLayerSE2:AddWindow('COL_LEFT','WIN_LEFT','Informações financeiras',100,.F.,.F.,,'LINE_MIDDLE',)

oWIN_TOP   := oFWLayerSE2:GetColPanel('COL_TOP','LINE_TOP')
oWIN_LEFT  := oFWLayerSE2:GetWinPanel('COL_LEFT','WIN_LEFT','LINE_MIDDLE')
oWIN_RIGHT := oFWLayerSE2:GetWinPanel('COL_RIGHT','WIN_RIGHT','LINE_MIDDLE')

//
// --- Contas a pagar
//
oBrowseCal:= FWMBrowse():New()
oBrowseCal:SetOwner(oWIN_TOP)
oBrowseCal:SetAlias('SE2')
oBrowseCal:SetDescription("Contas a pagar")
oBrowseCal:SetAmbiente(.F.)
oBrowseCal:SetWalkthru(.F.)
oBrowseCal:DisableDetails()
oBrowseCal:DisableConfig()
oBrowseCal:DisableReport()
oBrowseCal:SetOnlyFields( {	'E2_CODBAR'	, 'E2_MODELO'	, 'E2_TIPOPAG',;
'E2_PREFIXO', 'E2_NUM'		, 'E2_TIPO' 	, 'E2_PARCELA',;
'E2_SALDO'	, 'E2_VENCREA'	, 'E2_NOMFOR'	, 'E2_FORNECE', 'E2_LOJA' } ) 
oBrowseCal:SetDoubleClick( {|| CPP_DbClick(0) } )
oBrowseCal:AddButton("Gerar Borderô", {|| oDLG:End() },,1)
oBrowseCal:AddButton("Sair", { || CPP_DelTab(oDLG)   },,3)
oBrowseCal:ForceQuitButton(.T.)
oBrowseCal:SetProfileID("1")
oBrowseCal:SetFilterDefault(cBrowseTIT)
oBrowseCal:Activate()

Return


/*
//
// Valor de Frete por Tipo de cálculo
//
oGrfTpc := FWChartFactory():New()
oGrfTpc := oGrfTpc:GetInstance(PIECHART)
oGrfTpc:SetTitle("Valor por tipo de cálculo",CONTROL_ALIGN_CENTER)
oGrfTpc:Init(oWIN_LEFT,.F.)
oGrfTpc:SetPicture("@E 999,999,999.99")
oGrfTpc:SetLegend(CONTROL_ALIGN_BOTTOM)
Grafico(oGrfTpc,,aGrfTpc)

//
// Valor de Frete por Componente
//
oGrfCom := FWChartFactory():New()
oGrfCom := oGrfCom:GetInstance(PIECHART)
oGrfCom:SetTitle("Valor por componente",CONTROL_ALIGN_CENTER)
oGrfCom:Init(oWIN_MIDDLE,.F.)
oGrfCom:SetPicture("@E 999,999,999.99")
oGrfCom:SetLegend(CONTROL_ALIGN_BOTTOM)
Grafico(oGrfCom,,aGrfCom)

//
// Valor de Frete por Tipo de Negociação
//
oGrfNeg := FWChartFactory():New()
oGrfNeg := oGrfNeg:GetInstance(PIECHART)
oGrfNeg:SetTitle("Valor por tipo de negociação",CONTROL_ALIGN_CENTER)
oGrfNeg:Init(oWIN_RIGHT,.F.)
oGrfNeg:SetPicture("@E 999,999,999.99")
oGrfNeg:SetLegend(CONTROL_ALIGN_BOTTOM)
Grafico(oGrfNeg,,aGrfNeg)

IncRegua()

//
// Aba Frete Realizado
//

cBrowseFiltro := "GW3_EMISDF == '" + cCodEmit        + "' .AND. "
cBrowseFiltro += "GW3_FILIAL >= '" + cFilialDe      + "'  .AND. GW3_FILIAL <= '" + cFilialAte     + "' .AND. "
cBrowseFiltro += "GW3_DTENT  >= '" + DtoS(dDataDe) + "'  .AND. GW3_DTENT <= '" + DtoS(dDataAte) + "'"

oPnl := tPanel():New(30,0,,oFolder:aDialogs[2],,,,,,)
oPnl:Align := CONTROL_ALIGN_ALLCLIENT

oFWLayer := FWLayer():New()
oFWLayer:Init(oPnl,.F.)
oFWLayer:AddLine('LINE_TOP',50,.F.)
oFWLayer:AddLine('LINE_MIDDLE',50,.F.)
oFWLayer:AddCollumn('COL_TOP',100,.T.,'LINE_TOP')
oFWLayer:AddCollumn('COL_LEFT',50,.T.,'LINE_MIDDLE')
oFWLayer:AddCollumn('COL_RIGHT',50,.T.,'LINE_MIDDLE')
oFWLayer:AddWindow('COL_LEFT','WIN_LEFT','Tipo de Documento de Frete',100,.F.,.F.,,'LINE_MIDDLE',)
oFWLayer:AddWindow('COL_RIGHT','WIN_RIGHT','Categoria de Valor de Frete',100,.F.,.F.,,'LINE_MIDDLE',)

oWIN_TOP   := oFWLayer:GetColPanel('COL_TOP','LINE_TOP')
oWIN_LEFT  := oFWLayer:GetWinPanel('COL_LEFT','WIN_LEFT','LINE_MIDDLE')
oWIN_RIGHT := oFWLayer:GetWinPanel('COL_RIGHT','WIN_RIGHT','LINE_MIDDLE')

//
// Documentos de frete
//
oBrowseDoc:= FWMBrowse():New()
oBrowseDoc:SetOwner(oWIN_TOP)
oBrowseDoc:SetAlias('GW3')
oBrowseDoc:SetDescription("Documentos de frete")
oBrowseDoc:SetLocate()
oBrowseDoc:SetAmbiente(.F.)
oBrowseDoc:SetWalkthru(.F.)
oBrowseDoc:DisableDetails()
oBrowseDoc:AddButton("Visualizar","VIEWDEF.GFEC065",,2)
oBrowseDoc:ForceQuitButton(.T.)
oBrowseDoc:SetProfileID("2")
oBrowseDoc:SetFilterDefault(cBrowseFiltro)
oBrowseDoc:BVLDEXECFILTER := {|aParam| GFEC001KDF(aParam)}
oBrowseDoc:Activate()

//
// Valor de Frete por Tipo de Doc Frete
//
oGrfTPDF := FWChartFactory():New()
oGrfTPDF := oGrfTPDF:GetInstance(PIECHART)
oGrfTPDF:SetTitle("Valor por tipo de Doc Frete",CONTROL_ALIGN_CENTER)
oGrfTPDF:Init(oWIN_LEFT,.F.)
oGrfTPDF:SetPicture("@E 999,999,999.99")
oGrfTPDF:SetLegend(CONTROL_ALIGN_BOTTOM)
Grafico(oGrfTPDF,,aGrfTPDF)

//
// Valor de Frete por Categoria de Valor de Frete
//
oGrfCTDF := FWChartFactory():New()
oGrfCTDF := oGrfCTDF:GetInstance(PIECHART)
oGrfCTDF:SetTitle("Valor por Categoria",CONTROL_ALIGN_CENTER)
oGrfCTDF:Init(oWIN_RIGHT,.F.)
oGrfCTDF:SetPicture("@E 999,999,999.99")
oGrfCTDF:SetLegend(CONTROL_ALIGN_BOTTOM)
Grafico(oGrfCTDF,,aGrfCTDF)

IncRegua()

//
// Aba Previsto x Realizado
//

oPnl := tPanel():New(30,0,,oFolder:aDialogs[3],,,,,,)
oPnl:Align := CONTROL_ALIGN_ALLCLIENT

oFWLayer := FWLayer():New()
oFWLayer:Init(oPnl,.F.)
oFWLayer:AddLine('LINE_TOP',50,.F.)
oFWLayer:AddLine('LINE_MIDDLE',50,.F.)
oFWLayer:AddCollumn('COL_TOP',100,.T.,'LINE_TOP')
oFWLayer:AddCollumn('COL_LEFT',33,.T.,'LINE_MIDDLE')
oFWLayer:AddCollumn('COL_MIDDLE',34,.T.,'LINE_MIDDLE')
oFWLayer:AddCollumn('COL_RIGHT',33,.T.,'LINE_MIDDLE')
oFWLayer:AddWindow('COL_LEFT','WIN_LEFT','Estatísticas',100,.F.,.F.,,'LINE_MIDDLE',)
oFWLayer:AddWindow('COL_MIDDLE','WIN_MIDDLE','Previsto x Realizado',100,.F.,.F.,,'LINE_MIDDLE',)
oFWLayer:AddWindow('COL_RIGHT','WIN_RIGHT','',100,.F.,.F.,,'LINE_MIDDLE',)

oWIN_TOP    := oFWLayer:GetColPanel('COL_TOP','LINE_TOP')
oWIN_LEFT   := oFWLayer:GetWinPanel('COL_LEFT','WIN_LEFT','LINE_MIDDLE')
oWIN_MIDDLE := oFWLayer:GetWinPanel('COL_MIDDLE','WIN_MIDDLE','LINE_MIDDLE')
oWIN_RIGHT  := oFWLayer:GetWinPanel('COL_RIGHT','WIN_RIGHT','LINE_MIDDLE')

//Campos calculados do Browse Doc Carga
aColFrtCal := {"Frt Calculado", {||CalcFrtTip("1")}, "N","@E 999,999,999.99",2,15,2,.F.}
aColFrtPre := {"Frt Realizado", {||CalcFrtTip("2")}, "N","@E 999,999,999.99",2,15,2,.F.}
aColunas    := { aColFrtCal, aColFrtPre }

//
// Documentos de carga
//
oBrowseCar:= FWMBrowse():New()
oBrowseCar:SetOwner(oWIN_TOP)
oBrowseCar:SetAlias('GW1')
oBrowseCar:SetDescription("Documentos de carga")
oBrowseCar:SetLocate()
oBrowseCar:SetAmbiente(.F.)
oBrowseCar:SetWalkthru(.F.)
oBrowseCar:DisableDetails()
oBrowseCar:AddButton("Visualizar","VIEWDEF.GFEC040",,2)
oBrowseCar:ForceQuitButton(.T.)
oBrowseCar:SetFields(aColunas)
oBrowseCar:SetProfileID("3")
oBrowseCar:SetFilterDefault("GFEC001GW1()")
oBrowseCar:AddFilter("Somente documentos com Previsto e Realizado", "GFEC001REL()")
oBrowseCar:SetVldExecFilter({|aParam| GFEC001KEF(aParam)})
oBrowseCar:Activate()

oBrowseCar:SetColumnOrder(1,9)
oBrowseCar:SetColumnOrder(2,10)
oBrowseCar:UpdateBrowse()

//
// Estatísticas
//
oFolderEst :=  tFolder():New(30,0,{"Frete Previsto","Frete Realizado"},{"G1","G2"},oWIN_LEFT,)
oFolderEst:Align := CONTROL_ALIGN_ALLCLIENT

oBrowsePre := FWBrowse():New()
oBrowsePre:SetOwner(oFolderEst:aDialogs[1])
oBrowsePre:SetDescription("Dados")
oBrowsePre:SetDataArray()
oBrowsePre:DisableFilter()
oBrowsePre:DisableConfig()
oBrowsePre:SetColumns(GFEC001COL("Descrição",1,,,20,"oBrowsePre"))
oBrowsePre:SetColumns(GFEC001COL("Valor"    ,2,,2,14,"oBrowsePre"))
oBrowsePre:SetArray(aStatPre)
oBrowsePre:Activate()

oBrowseRea := FWBrowse():New()
oBrowseRea:SetOwner(oFolderEst:aDialogs[2])
oBrowseRea:SetDescription("Dados")
oBrowseRea:SetDataArray()
oBrowseRea:DisableFilter()
oBrowseRea:DisableConfig()
oBrowseRea:SetColumns(GFEC001COL("Descrição",1,,,20,"oBrowseRea"))
oBrowseRea:SetColumns(GFEC001COL("Valor",2,,2,14,"oBrowseRea"))
oBrowseRea:SetArray(aStatRea)
oBrowseRea:Activate()

//
// Folder Gráficos de valor de frete total e normal (Previsto x Realizado)
//
// Últimos parametros do folder: Consultar chamado TFKSA9
oFolderGrf := TFolder():New( 0,0,{"Total","Normal"},,oWIN_MIDDLE,,,,.T.,,(oWIN_MIDDLE:nwidth/2),(oWIN_MIDDLE:nHeight/2))
oFolderGrf:Align := CONTROL_ALIGN_ALLCLIENT
oFolderGrf:bSetOption := {|nOption|AtuFolder(nOption)} // Atualiza o gráfico de impostos ao mudar aba

//
// Gráfico com a soma total do valor de frete
//
oGrfDCTo := FWChartFactory():New()
oGrfDCTo := oGrfDCTo:GetInstance(BARCHART)
oGrfDCTo:SetTitle("Valor de Frete Total",CONTROL_ALIGN_CENTER)
oGrfDCTo:Init(oFolderGrf:aDialogs[1],.F.)
oGrfDCTo:SetPicture("@E 999,999,999")
oGrfDCTo:SetLegend(CONTROL_ALIGN_BOTTOM)
oGrfDCTo:SetSerieAction({|nSerie| AtuImpostos(nSerie,"T") })
Grafico(oGrfDCTo,,aGrfDCTo)

//
// Gráfico com a soma do frete normal GWD_TPDF/GWF_TPCALC 1 e 6
//
oGrfDCNo := FWChartFactory():New()
oGrfDCNo := oGrfDCNo:GetInstance(BARCHART)
oGrfDCNo:SetTitle("Valor de Frete Normal",CONTROL_ALIGN_CENTER)
oGrfDCNo:Init(oFolderGrf:aDialogs[2],.F.)
oGrfDCNo:SetPicture("@E 999,999,999")
oGrfDCNo:SetLegend(CONTROL_ALIGN_BOTTOM)
oGrfDCNo:SetSerieAction({|nSerie| AtuImpostos(nSerie,"N") })
Grafico(oGrfDCNo,,aGrfDCNo)

//
// Gráfico impostos
//
oGrfImp := FWChartFactory():New()
oGrfImp := oGrfImp:GetInstance(PIECHART)
oGrfImp:SetTitle("Impostos Frete Previsto Total",CONTROL_ALIGN_CENTER)
oGrfImp:Init(oWIN_RIGHT,.F.)
oGrfImp:SetPicture("@E 999,999,999")
oGrfImp:SetLegend(CONTROL_ALIGN_BOTTOM)
Grafico(oGrfImp,,aGrfIPT)

IncRegua()
*/


//-------------------------------------------------------------------------------------------------
/* {2LGI} CPP_Modelo
@autor		: Luiz Alexandre
@descricao	: Grava o tipo e modelo de pagamento dos titulos enviados para bordero de pagamento
@since		: 27/Mai./2013
@using		: Comunicacao bancaria
@review
*/
//-------------------------------------------------------------------------------------------------
Static Function	CPP_Modelo()

// --- Variaveis locais
Local _cTipos		:= GetNewPar('CP_TIPOPG', {} )
Local _aParTipo     := Iif(!Empty(_cTipos),&_cTipos,{})
Local _nCount		:= 0
_aTipos				:= Array(1)

// --- Adiciona folder principal
_aTipos[1]	:= 'Contas a pagar'

// --- Ordena os tipos de pagamento
Asort(_aParTipo)

// --- Se o parametro nao estiver vazio considera os tipos do parametro
If Len(_aParTipo) > 0
	// --- Adiciona os tipos contidos no parametro
	For _nCount	:= 1 to Len(_aParTipo)
		aSize( _aTipos, Len(_aTipos)+1)
		_aTipos[_nCount+1] := _aParTipo[_nCount]
	Next _nCount
	
	// --- Caso contrario pega os tipos contidos na tabela 58
Else
	// --- Adiciona tipos na array
	SX5->(dbSetOrder(1))
	SX5->(dbSeek(xFilial('SX5')+'58'))
	While SX5->( ! Eof()) .and.  SX5->X5_FILIAL == xFilial("SX5") .and. SX5->X5_TABELA == '58'
		aSize( _aTipos, Len(_aTipos)+1)
		_aTipos[Len(_aTipos)] := SX5->X5_CHAVE
		SX5->(dbSkip())
	EndDo
EndIf

Return _aTipos


//------------------------------------------------------------------------------------------------
/* {2LGI} CPP_Dados
@autor		: Luiz Alexandre
@descricao	: Carga de dados das tabelas utilizadas
@since		: 01/Out./2013
@using		: Central de pagamentos
@review
*/
//-------------------------------------------------------------------------------------------------
Static Function CPP_Dados(_aTipos,_aTabelas,_aBco)

// --- Variaveis locais
Local _nCount 	:= 0
Local _cQuery	:= ""
Local _cFile	:= ""
Local _cAlias	:= ""
Local _lCont	:= .t.
Local _dData	:= dDataBase

// --- Verifica o saldo do banco
SE8->(dbSetOrder(1))
If ! SE8->(dbSeek(xFilial('SE8')+Mv_par03+Mv_par04+Mv_par05+Dtos(_dData)))
	
	// --- Caso nao encontre para a database localiza ultimo saldo mesmo que seja Zero.
	While _lCont
		
		// --- Decresce o dia, no Top nao tem skip-1
		_dData--
		If SE8->(dbSeek(xFilial('SE8')+Mv_par03+Mv_par04+Mv_par05+Dtos(_dData)))
			// --- Grava o saldo encontrado como atual e estimado e sai do loop
			_aBco[1,2]	:= SE8->E8_SALATUA
			_aBco[1,3]	:= SE8->E8_SALATUA
			_lCont	:= .f.
		EndIf
		
	EndDo
	// --- Caso encontre o saldo na database
Else
	_aBco[1,2]	:= SE8->E8_SALATUA
	_aBco[1,3]	:= SE8->E8_SALATUA
EndIf

// ---  Laco no modelos de pagamento para criar tabelas temporarias
For _nCount := 2 to Len(_aTipos)
	
	// --- Alias do arquivo temporario do modelo de pagamento
	_cAlias		:= _aTabelas[_nCount-1,1]
	
	// --- Monta a query com os registros para cada tipo
	_cQuery		:= "SELECT	E2_FILIAL," 	+ CRLF
	_cQuery 	+= "		E2_CODBAR," 	+ CRLF
	_cQuery 	+= "		E2_MODELO," 	+ CRLF
	_cQuery 	+= "		E2_TIPOPAG," 	+ CRLF
	_cQuery 	+= "		E2_PREFIXO," 	+ CRLF
	_cQuery 	+= "		E2_NUM," 		+ CRLF
	_cQuery 	+= "		E2_TIPO," 		+ CRLF
	_cQuery 	+= "		E2_PARCELA," 	+ CRLF
	_cQuery 	+= "		E2_SALDO," 		+ CRLF
	_cQuery 	+= "		E2_VENCREA,"	+ CRLF
	_cQuery 	+= "		E2_NOMFOR," 	+ CRLF
	_cQuery 	+= "		E2_FORNECE," 	+ CRLF
	_cQuery 	+= "		E2_LOJA"   		+ CRLF
	_cQuery 	+= "FROM " + RetSQLName("SE2") + CRLF
	_cQuery		+= "WHERE " + CRLF
	_cQuery		+= "E2_FILIAL  >= '" + cFilAnt + "' AND E2_FILIAL  <= '" + cFilAnt + "' AND " + CRLF
	_cQuery		+= "E2_VENCREA >= '" + Dtos(Mv_par01) + "' AND E2_VENCREA <= '" + Dtos(Mv_par02) + "' AND " + CRLF
	_cQuery		+= "E2_MODELO ='" +_aTipos[_nCount]+"' AND " + CRLF
	_cQuery		+= "E2_SALDO > 0 AND " + CRLF
	_cQuery		+= "D_E_L_E_T_ = ''"
	
	// --- Verifica se o parametro de liberação de pagamentoADMNI está ativado.
	If _lCTLibPag
		_cQuery += " AND E2_STATLIB = '03'"
	EndIf
	// --- Ordem da query
	_cQuery		+= "ORDER BY E2_FILIAL+E2_MODELO"
	
	_cFile		:= GetNextAlias()
	_cQuery 	:= ChangeQuery(_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),_cFile,.F.,.T.)
	TCSetField(_cFile,"E2_VENCREA","D",8,0)
	
	dbSelectArea(_cFile)
	While (_cFile)->( !Eof())
		
		// --- Verifica modelo para definir a tabela de destino
		RecLock(_cAlias, .t. )
		
		(_cAlias)->E2_FILIAL	:= (_cFile)->E2_FILIAL
		(_cAlias)->E2_CODBAR	:= (_cFile)->E2_CODBAR
		(_cAlias)->E2_MODELO	:= (_cFile)->E2_MODELO
		(_cAlias)->E2_TIPOPAG	:= (_cFile)->E2_TIPOPAG
		(_cAlias)->E2_PREFIXO	:= (_cFile)->E2_PREFIXO
		(_cAlias)->E2_NUM		:= (_cFile)->E2_NUM
		(_cAlias)->E2_TIPO		:= (_cFile)->E2_TIPO
		(_cAlias)->E2_PARCELA	:= (_cFile)->E2_PARCELA
		(_cAlias)->E2_SALDO		:= (_cFile)->E2_SALDO
		(_cAlias)->E2_VENCREA	:= (_cFile)->E2_VENCREA
		(_cAlias)->E2_NOMFOR	:= (_cFile)->E2_NOMFOR
		(_cAlias)->E2_FORNECE	:= (_cFile)->E2_FORNECE
		(_cAlias)->E2_LOJA		:= (_cFile)->E2_LOJA
		
		(_cAlias)->(MsUnLock())
		
		// --- Atualiza o saldo do banco na carga inicial
		CPP_SldBco(2, (_cFile)->E2_SALDO )
		
		// --- Somatoria dos modelos de pagamento na carga inicial
		CPP_TotTip(2, (_cFile)->E2_MODELO ,(_cFile)->E2_SALDO)
		
		// --- Somatoria dos pagamentos por data
		CPP_Pgtos(2, (_cFile)->E2_VENCREA ,(_cFile)->E2_SALDO )
		
		// --- Somatoria dos pagamentos por fornecedor       
		CPP_PgtosForn(2, (_cFile)->E2_FORNECE, (_cFile)->E2_LOJA, (_cFile)->E2_NOMFOR,(_cFile)->E2_SALDO )

		(_cFile)->(dbSkip())
		
	EndDo
	
	// --- Fecha area de trabalho
	(_cFile)->(dbCloseArea())
	
Next _nCount

Return

/*/{Protheus.doc} CPP_SldBco
@author Luiz
@since 18/11/2013
@version 1.0
@param _aBco, nTipo, (_aBco, array com o codigo do banco, nTipo tipo de saldo 0 abertura, 1 acrescentar, 2 diminuir)
@return ${return}, ${return_description}
@description
(long_description)
@example
(examples)
@see (links_or_references)
/*/
Static Function CPP_SldBco(_nTipo,_nValor)

// --- Variaveis utilizadas
Local _aArea	:= GetArea()

// --- Verifica se o banco tem saldo para a data base do sistema
If _nTipo == 0
	SE8->(dbSetOrder(1))
	SE8->(dbSeek(xFilial('SE8')+Mv_par03+Mv_par04+Mv_par05+Dtos(dDataBase)))
	_aBco[1,2]	:= SE8->E8_SALATUA
	
	// --- Aumenta o saldo
ElseIf _nTipo == 1
	_aBco[1,3]	+= _nValor
	
	// --- Diminui o saldo
ElseIf _nTipo == 2
	_aBco[1,3]	-= _nValor
	
EndIf

// --- Restaura area
RestArea(_aArea)

Return

/*/{Protheus.doc} CPP_PgtosForn
@author Luiz
@since 18/11/2013
@version 1.0
@param dData, 2 acrescentar, 1 diminuir)
@return ${return}, ${return_description}
@description
(long_description)
@example
(examples)
@see (links_or_references)
/*/
Static Function CPP_PgtosForn(_nTipo, _cCod, _cLoja, _cNome, _nValor)

// --- Variaveis utilizadas
Local _nPos

// --- Localiza posicao da array conforme o modelo
_nPos	:= Ascan( _aPgtosForn, { |x| x[1]+x[2] == _cCod+_cLoja } )

// --- Localiza a posicao na array
If _nPos > 0
	
	// --- Soma
	If _nTipo == 2
		_aPgtosForn[_nPos,4] += _nValor
	// --- Subtrai
	Else
		_aPgtosForn[_nPos,4] -= _nValor
	EndIf
// --- Nao encontrou	
Else
	Aadd(_aPgtosForn, { _cCod, _cLoja, _cNome, _nValor } )
EndIf

// --- Indexa a array
Asort(_aPgtosForn,,, { |x,y| x[1] < y[1] })


Return


/*/{Protheus.doc} CPP_Pgtos
@author Luiz
@since 18/11/2013
@version 1.0
@param dData, 2 acrescentar, 1 diminuir)
@return ${return}, ${return_description}
@description
(long_description)
@example
(examples)
@see (links_or_references)
/*/
Static Function CPP_Pgtos(_nTipo, _dVencto, _nValor)


// --- Variaveis utilizadas
Local _nPos

// --- Localiza posicao da array conforme o modelo
_nPos	:= Ascan( _aPgtos, { |x| x[1] == _dVencto } )

// --- Localiza a posicao na array
If _nPos > 0
	
	// --- Soma
	If _nTipo == 2
		_aPgtos[_nPos,3] += _nValor
	// --- Subtrai
	Else
		_aPgtos[_nPos,3] -= _nValor
	EndIf
// --- Nao encontrou	
Else
	Aadd(_aPgtos, { _dVencto, FG_CDOW(_dVencto) ,_nValor } )
EndIf

// --- Indexa a array
Asort(_aPgtos,,, { |x,y| x[1] < y[1] })

Return

/*/{Protheus.doc} CPP_TotTip
@author Luiz
@since 18/11/2013
@version 1.0
@param nTipo, Modelo, Valor, 2 acrescentar, 1 diminuir)
@return ${return}, ${return_description}
@description
(long_description)
@example
(examples)
@see (links_or_references)
/*/
Static Function CPP_TotTip(_nTipo, _cModelo, _nValor)

// --- Variaveis utilizadas
Local _nPos

// --- Localiza posicao da array conforme o modelo
_nPos	:= Ascan( _aModelos, { |x| x[1] == _cModelo } )

// --- Localiza a posicao na array
If _nPos > 0
	
	// --- Soma
	If _nTipo == 2
		_aModelos[_nPos,3] += _nValor
	// --- Subtrai
	Else
		_aModelos[_nPos,3] -= _nValor
	EndIf
	
EndIf

Return
		
/*/{Protheus.doc} CPP_Colunas
@author Luiz
@since 04/09/2013
@version 1.0
@param cTipo, character, (DescriÃ§Ã£o do parÃ¢metro)
@return ${return}, ${return_description}
@description
(long_description)
@example
(examples)
@see (links_or_references)
/*/
Static Function CPP_Colunas(_cTipo,cBrowse,_cAlias)

// --- Variaveis utilizadas
Local aColumn	:= {}
Local _aColumn	:= {}
Local _aFields	:= {}

If _cTipo == 'TIT'
	
	//Aadd( aColumn, {"Filial"			,"{||"+cBrowse+":oData:aArray["+cBrowse+":At(),"+STR(1)+"]}","C","@!",1,TAMSX3("E2_FILIAL")[1],TAMSX3("E2_FILIAL")[2],.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{} } )
	//Aadd( aColumn, {"Código de barras"	,"{||"+cBrowse+":oData:aArray["+cBrowse+":At(),"+STR(2)+"]}","C","@!",1,TAMSX3("E2_CODBAR")[1],TAMSX3("E2_CODBAR")[2],.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{} } )
	
	//Return aColumn
	
	
	Aadd(_aFields, { "E2_FILIAL"	, "Filial"				,"C", TAMSX3("E2_FILIAL")[1]	, TAMSX3("E2_FILIAL")[2]	, X3Picture("E2_FILIAL")	,1 	} )
	Aadd(_aFields, { "E2_CODBAR"	, "Codigo de Barras"	,"C", TAMSX3("E2_CODBAR")[1]	, TAMSX3("E2_CODBAR")[2]	, X3Picture("E2_CODBAR") 	,1	} )
	Aadd(_aFields, { "E2_MODELO"	, "Modelo"				,"C", TAMSX3("E2_MODELO")[1]	, TAMSX3("E2_MODELO")[2]	, X3Picture("E2_MODELO") 	,1	} )
	Aadd(_aFields, { "E2_TIPOPAG"	, "Forma"				,"C", TAMSX3("E2_TIPOPAG")[1]	, TAMSX3("E2_TIPOPAG")[2]	, X3Picture("E2_TIPOPAG") 	,1	} )
	Aadd(_aFields, { "E2_PREFIXO"	, "Prefixo"				,"C", TAMSX3("E2_PREFIXO")[1]	, TAMSX3("E2_PREFIXO")[2]	, X3Picture("E2_PREFIXO") 	,1	} )
	Aadd(_aFields, { "E2_NUM"		, "Numero"				,"C", TAMSX3("E2_NUM")[1]		, TAMSX3("E2_NUM")[2]		, X3Picture("E2_NUM")		,1	} )
	Aadd(_aFields, { "E2_TIPO"		, "Tipo"				,"C", TAMSX3("E2_TIPO")[1]		, TAMSX3("E2_TIPO")[2]		, X3Picture("E2_TIPO")		,1	} )
	Aadd(_aFields, { "E2_PARCELA"	, "Parcela"				,"C", TAMSX3("E2_PARCELA")[1]	, TAMSX3("E2_PARCELA")[2]	, X3Picture("E2_PARCELA") 	,1	} )
	Aadd(_aFields, { "E2_SALDO"		, "Valor"				,"N", TAMSX3("E2_SALDO")[1]		, TAMSX3("E2_SALDO")[2]		, X3Picture("E2_SALDO") 	,2	} )
	Aadd(_aFields, { "E2_VENCREA"	, "Vencimento"			,"D", TAMSX3("E2_VENCREA")[1]	, TAMSX3("E2_VENCREA")[2]	, X3Picture("E2_VENCREA") 	,2	} )
	Aadd(_aFields, { "E2_NOMFOR"	, "Fornecedor"			,"C", TAMSX3("E2_NOMFOR")[1]	, TAMSX3("E2_NOMFOR")[2]	, X3Picture("E2_NOMFOR") 	,1	} )
	Aadd(_aFields, { "E2_FORNECE"	, "Codigo"				,"C", TAMSX3("E2_FORNECE")[1]	, TAMSX3("E2_FORNECE")[2]	, X3Picture("E2_FORNECE") 	,1	} )
	Aadd(_aFields, { "E2_LOJA"	   	, "Loja"				,"C", TAMSX3("E2_LOJA")[1]		, TAMSX3("E2_LOJA")[2]		, X3Picture("E2_LOJA") 		,1	} )
	
	// --- Ponto de entrada para adicionar novas colunas ao browse
	If _lCPPINCOL
		_aCampos := ExecBlock("CPPINCOL",.F.,.F., _aFields )
		If Valtype(_aCampos) <> "A"
			_aFields := _aCampos
		EndIf
	EndIf
	
	
	
	For _nCount	:= 1 to Len(_aFields)
		
		// --- Objeto
		oColumn := FWBrwColumn():New()
		oColumn:SetData( &( '{ || ' + _cAlias + '->' + _aFields[_nCount,1]+ ' }' ) )
		oColumn:SetTitle( _aFields[_nCount,2] )
		oColumn:SetSize( _aFields[_nCount,4] )
		oColumn:SetDecimal( _aFields[_nCount,5] )
		oColumn:SetPicture( _aFields[_nCount,6] )
		oColumn:SetEdit(.T.)
		oColumn:SetReadVar(_aFields[_nCount,1])  
		oColumn:SetAlign(_aFields[_nCount,7])
		
		Aadd(_aColumn, oColumn )
		
	Next _nX
	
	Return(_aColumn)
	
EndIf

Return

//-----------------------------------------------------------------------------------------
/* {2LGI} CPP_DbClick
@autor		: Luiz Alexandre
@descricao	: Grava o tipo e modelo de pagamento dos titulos enviados para bordero de pagamento
@since		: 27/Mai./2013
@using		: Comunicacao bancaria
@review
*/
//-----------------------------------------------------------------------------------------
Static Function CPP_DbClick(cArqTmp)

// --- Variaveis utilizadas
Local oDlg
Local _cModPag 	:= ""
Local _cTipPag 	:= ""
Local _cBarras 	:= ""
Local oSay, oSay1, oSay2, oSay3, oSay4, oSay5
Local oFont, oFont1
Local oSButton1, oSButton2, oSButton3
cArqTmp			:= Iif( cArqTmp > 0, _aTabelas[cArqTmp-1,1], 'SE2')

dbSelectArea(cArqTmp)

_cModPag		:= (cArqTmp)->E2_MODELO
_cTipPag 		:= (cArqTmp)->E2_TIPOPAG
_cBarras 		:= (cArqTmp)->E2_CODBAR
_cMsg1	 		:= ''
_cMsg2	 		:= ''

oDlg:= MSDialog():New(0,0,230,650,OemToAnsi('Edição: '+(cArqTmp)->E2_PREFIXO +' | '+ (cArqTmp)->E2_NUM +' | '+ (cArqTmp)->E2_PARCELA +' | '+ (cArqTmp)->E2_NOMFOR),,,,,CLR_BLACK,CLR_WHITE,,,.t.)
// ---
oFont:= TFont():New('Tahoma',,-16,.T.)
oFont1:= TFont():New('Tahoma',,-11,.T.)
// --- Apresenta o tSay com a fonte Courier New
oSay := TSay():New( 005, 010, {|| OemToAnsi('Título: '+(cArqTmp)->E2_PREFIXO +' | '+ (cArqTmp)->E2_NUM +' | Parcela '+ (cArqTmp)->E2_PARCELA +' | '+ (cArqTmp)->E2_NOMFOR+' | R$ '+Transform((cArqTmp)->E2_SALDO, "@E 99,999,999.99" ) ) },oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay:lTransparent:= .F.
oSay1 := TSay():New( 025, 010, {|| OemToAnsi('Modelo de pagamento: ')},oDlg,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay1:lTransparent:= .F.
oSay2 := TSay():New( 040, 010, {|| OemToAnsi('Forma de pagamento: ')},oDlg,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay2:lTransparent:= .F.
oSay3 := TSay():New( 055, 010, {|| OemToAnsi('Passe o Leitor ou Digite:')},oDlg,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay3:lTransparent:= .F.
oSay4 := TSay():New( 070, 010, {|| OemToAnsi('Código de barras: ')},oDlg,, oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay4:lTransparent:= .F.

// ---
@ 021,070 MSGET _cModPag SIZE 20, 9 OF oDlg PIXEL F3 '58' VALID ExistCpo('SX5','58'+_cModPag)
oSay5 := TSay():New( 023, 095, {|| CPP_Descr('58'+_cModPag) },oDlg,,oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay5:lTransparent:= .F.
@ 036,070 MSGET _cTipPag SIZE 20, 9 OF oDlg PIXEL F3 '59' VALID ExistCpo('SX5','59'+_cTipPag)
oSay6 := TSay():New( 038, 095, {|| CPP_Descr('59'+_cTipPag) },oDlg,,oFont1,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay6:lTransparent:= .F.

// --- Exibe o codigo de barras convertido e a mensagem do interpretador do codigo de barras 
// ---
@ 051,070 MSGET _cBarras 	SIZE 250, 9 OF oDlg PIXEL VALID U_ConvCBar(_cBarras,@_cMsg1,_cMsg2,oDlg)   
@ 066,070 MSGET _cMsg1		SIZE 250, 9 WHEN .F. OF oDlg PIXEL  
 
// --- Botoes para gravacao dos dados de classificacao do titulo
// ---
oSButton1 := SButton():New( 95,10,1, {|| U_CPP_Grava(oFolder:nOption,_cModPag, SE2->(Recno()), _aTabelas ) },oDlg,.T.,'Confirma dados',)
oSButton2 := SButton():New( 95,40,2, {|| Alert('SButton02') },oDlg,.T.,'Cancela',)

// --- Ativa o objeto
oDlg:Activate() 

Return

//-----------------------------------------------------------------------------------------
/* {2LGI} CPP_Descr
@autor		: Luiz Alexandre
@descricao	: Grava o tipo e modelo de pagamento dos titulos enviados para bordero de pagamento
@since		: 27/Mai./2013
@using		: Comunicacao bancaria
@review
*/
//-----------------------------------------------------------------------------------------
Static Function CPP_Descr(cParam)
Local _cString := ''

If ! Empty(cParam)
	SX5->(dbSetOrder(1))
	SX5->(dbSeek(xFilial('SX5')+cParam))
	_cString	:= SX5->X5_DESCRI
EndIf

Return _cString

//-----------------------------------------------------------------------------------------
/* {2LGI} CPP_Filtros
@autor		: Luiz Alexandre
@descricao	: Grava o tipo e modelo de pagamento dos titulos enviados para bordero de pagamento
@since		: 27/Mai./2013
@using		: Comunicacao bancaria
@review
*/
//-----------------------------------------------------------------------------------------
Static Function CPP_Filtros(_aTipos, _aFiltros)

// --- Variaveis utilizaldas
Local _nCount	:= 0
Local cFiltro	:= ''

// --- Monta os filtros conforme modelos de pagamento
For _nCount := 2 to Len(_aTipos)
	
	// ---  Monta filtro para os modelos utilizados
	cFiltro := "E2_FILIAL  >= '" + cFilAnt      + "' .AND. E2_FILIAL  <= '" + cFilAnt   + "' .AND. "
	cFiltro += "E2_VENCREA >= '" + DtoS(Mv_par01)  + "' .AND. E2_VENCREA <= '" + DtoS(Mv_par02) + "' .AND. "
	cFiltro += "E2_MODELO = '" +_aTipos[_nCount]+ "' "
	
	// --- Adiciona filtro do tipo
	Aadd( _aFiltros, { cFiltro } )
	
Next _nCount

Return

//-----------------------------------------------------------------------------------------
/* {2LGI} CPP_ModBrw
@autor		: Luiz Alexandre
@descricao	: Grava o tipo e modelo de pagamento dos titulos enviados para bordero de pagamento
@since		: 27/Mai./2013
@using		: Comunicacao bancaria
@review
*/
//-----------------------------------------------------------------------------------------
Static Function CPP_ModBrw(_aTipos)

// --- Variaveis utilizadas
Local _nCount	:= 0

// --- Laco
SX5->(dbSetOrder(1))
For _nCount := 2 to Len(_aTipos)
	
	// --- Localiza os tipos na tabela 58
	SX5->(dbSeek(xFilial('SX5')+'58'+_aTipos[_nCount]))
	Aadd( _aModelos, { _aTipos[_nCount], SX5->X5_DESCRI, 0 } )
	
Next _nCount

Return _aModelos

//-----------------------------------------------------------------------------------------
/* {2LGI} F240SOMA
@autor		: Luiz Alexandre
@descricao	: Grava o tipo e modelo de pagamento dos titulos enviados para bordero de pagamento
@since		: 27/Mai./2013
@using		: Comunicacao bancaria
@review
*/
//-----------------------------------------------------------------------------------------
Static Function AtuFiltro(_cFiltro)
CPP_Filtros()
Return Nil


//-----------------------------------------------------------------------------------------
/* {2LGI} CPP_ModCol
@autor		: Luiz Alexandre
@descricao	: Grava o tipo e modelo de pagamento dos titulos enviados para bordero de pagamento
@since		: 27/Mai./2013
@using		: Comunicacao bancaria
@review
*/
//-----------------------------------------------------------------------------------------
Static Function CPP_ModCol(cTitulo,nArrData,cPicture,nAlign,nSize,nDec,cTipo,cBrowse)
Local aColumn
Local bData		:= {||}
Default nAlign	:= 1
Default nSize	:= 20
Default nDec	:= 0
Default nArrData:= 0

If nArrData > 0
	bData := &("{||"+cBrowse+":oData:aArray["+cBrowse+":At(),"+STR(nArrData)+"]}")
EndIf

aColumn := {cTitulo,bData,cTipo,cPicture,nAlign,nSize,nDec,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}

Return {aColumn}                 


//-------------------------------------------------------------------------------------------------
/* {2LGI} CPP_CriaTab
@autor		: Luiz Alexandre
@descricao	: Cria tabela temporaria com base na estrutura da informada
@since		: 30/Set./2013
@using		: Central de pagamentos
@review		:
@param 		: Estrutura da tabela a ser criada (array)
@param 		: Indices da tabela a ser criada (array)
*/
//-------------------------------------------------------------------------------------------------
Static Function CPP_CriaTab()

// --- Variaveis utilizadas
Local _cFileTab := ""		// --- Cria o arquivo da tabela temporaria
Local _cAliasTab:= ""    	// --- Obtem o alias para a tabela temporaria
Local _aAlfa    := {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
Local _nI       := 0
Local _nCount	:= 0

// ---
For _nCount := 2 to Len(_aTipos)
	
	_cFileTab	:= CriaTrab(_aStruc[1])
	_cAliasTab	:= GetNextAlias()
	
	// Disponibiliza a tabela temporaria para uso pelo programa
	dbUseArea(.T.,,_cFileTab,(_cAliasTab),.F.)
	
	// Cria o arquivo de indice para a tabela temporaria
	For _nI := 1 to len(_aStruc[2])
		IndRegua(_cAliasTab, Left(_cFileTab,7) + _aAlfa[_nI], _aStruc[2,_nI],,, "Selecionando Registros")
	Next _nI
	
	dbClearIndex()
	// ---
	For _nI := 1 to len(_aStruc[2])
		dbSetIndex(Left(_cFileTab,7) + _aAlfa[_nI] + OrdBagExt())
	Next nI
	
	Aadd( _aTabelas, { _cAliasTab, _cFileTab , '' } )
	
Next _nCount

Return _aTabelas


//-----------------------------------------------------------------------------------------
/* {2LGI} CPP_DelTab
@autor		: Luiz Alexandre
@descricao	: Elimina a tabela temporaria e os respectivos indices
@since		: 30/Set./2013
@using		: Central de pagamentos
@review
*/
//-----------------------------------------------------------------------------------------
Static Function CPP_DelTab(oDLG)

Local _cFileTab := ""
Local _cTreePath:= ""
Local _aFileInd := {} // Armazena os nomes completos dos arquivos de indice
Local _aDelFiles:= {}
Local _nQtdInd  := 0
Local _nCount   := 0
Local _nI		:= 0

// --- Verifica se o dialog foi fechado
If oDLG:End()
	_lEnd	:= .t.
EndIf


// --- Deleta as tabelas criadas
For _nCount := 1 to Len(_aTabelas)
	
	// --- Verifica o browse para desativar
	_aTabelas[_nCount,3]:DeActivate(.t.)
	_aFileInd := {}
	
	If Select(_aTabelas[_nCount,1]) > 0
		
		dbSelectArea(_aTabelas[_nCount,1])
		_cFileTab := dbInfo(DBI_FULLPATH)
		
		If Empty(_cFileTab)
			Return .T.
		EndIf
		
		_nQtdInd  := dbOrderInfo(9 /* DBOI_ORDERCOUNT */)
		
		// Em ambientes com LocalFiles=CTREE, dbOrderInfo(9) considera um índice a mais nas tabelas,
		// correspondente à ordem de inserção na tabela. Quando LocalFiles=ADS, este índice não é contado.
		// LocalFiles é uma opção do arquivo AppServer.ini, informada na sessão correspondente ao ambiente
		// que se quer utilizar.
		If ("CTREE"$RealRDD())
			_nQtdInd--
		EndIf
		
		For _nI := 1 to _nQtdInd
			dbSetOrder(_nI)
			aAdd(_aFileInd, dbOrderInfo(20 /* DBOI_FULLPATH */))
		Next _nI
		
		// Fecha e elimina o arquivo correspondente à tabela temporária
		USE
		
		_cTreePath := GetSrvProfString("RootPath", "")
		
		If At(Lower(_cTreePath), Lower(_cFileTab)) > 0
			
			_cTreePath := Substr(_cFileTab, Len(_cTreePath) + 1)
			
		EndIf
		
		FErase(_cTreePath)
		
		If "CTREE" $ RealRDD()
			
			_cTreePath := GetSrvProfString("StartPath", "") + "CTREEINT\"
			
			_aDelFiles := Directory(_cTreePath + FileNoExt(ATail(StrTokArr(_cFileTab,"\"))) + "*.*")
			
			For _nI := 1 To Len(_aDelFiles)
				
				FErase(_cTreePath + _aDelFiles[_nI][1])
				
			Next _nI
			
		EndIf
		
		// Elimina os arquivos de índice da tabela temporária
		For _nI := 1 to _nQtdInd
			
			If "CTREE" $ RealRDD()
				
				_cTreePath := GetSrvProfString("RootPath", "")
				
				If At(Lower(_cTreePath), Lower(_aFileInd[_nI])) > 0
					
					_cTreePath := Substr(_aFileInd[_nI], Len(_cTreePath) + 1)
					
				EndIf
				
				FErase(_cTreePath)
				
			Else
				FErase(_aFileInd[_nI])
			EndIf
			
		Next _nI
		
	EndIf
	
Next _nCount

Return

//-----------------------------------------------------------------------------------------
/* {2LGI} CPP_Brws
@autor		: Luiz Alexandre
@descricao	: Cria browse de acordo com o tipo de pagamento
@since		: 30/Set./2013
@using		: Central de pagamentos
@review
*/
//-----------------------------------------------------------------------------------------
Static Function CPP_Brws(_aTipos)

Local _nCount	:= 0
Local oPnl, oFWLayer, oWin_Top, oBrowse
Local _cFileTmp

//
// --- Laco para criacao dos objetos conforme os tipos selecionados
//
For _nCount := 2 to Len(_aTipos)
	
	// --- Cria painel para receber o browse filtrado
	oPnl 		:= 'oPnl'+_aTipos[_nCount]
	&oPnl 		:= tPanel():New(30,0,,oFolder:aDialogs[_nCount],,,,,,)
	&oPnl:Align := CONTROL_ALIGN_ALLCLIENT
	
	oFWLayer 	:= 'oFWLayer'+_aTipos[_nCount]
	&oFWLayer 	:= FWLayer():New()
	&oFWLayer	:Init(&oPnl,.F.)
	&oFWLayer	:AddLine('LINE_TOP',100,.F.)
	&oFWLayer	:AddCollumn('COL_TOP',100,.T.,'LINE_TOP')
	
	oWin_Top	:= 'oWin_Top'+_aTipos[_nCount]
	&oWIN_TOP   := &oFWLayer:GetColPanel('COL_TOP','LINE_TOP')
	
	_cFileTmp	:= _aTabelas[_nCount-1,1]
	oBrowse 	:= 'oBrowse'+_aTipos[_nCount]
	&oBrowse 	:= FWBrowse():New( &oWIN_TOP )
	
	&oBrowse 	:SetOwner(&oWIN_TOP)
	&oBrowse 	:SetDescription(__CTITULO)
	&oBrowse 	:SetDataTable()
	&oBrowse 	:SetAlias(_cFileTmp)
	&oBrowse 	:SetColumns(CPP_Colunas('TIT',@oBrowse,_cFileTmp))
	&oBrowse 	:SetDoubleClick( { || CPP_DbClick(oFolder:nOption) })
	&oBrowse 	:Refresh()
	&oBrowse 	:GoUp()
	_aTabelas[_nCount-1,3] := &oBrowse
	&oBrowse :Activate()
	
	// ---
	Aadd( _aBrowses, { @oBrowse, &oBrowse }  )
	
Next _nCount

/*
oBrowse30 := FWBrowse():New()
oBrowse30 :SetOwner(oWIN_TOP)
oBrowse30 :SetDescription(__CTITULO)
oBrowse30 :SetDataTable()
oBrowse30 :SetAlias(_aTabelas[2])
oBrowse30 :SetColumns(CPP_Colunas('TIT',oBrowse30,_aTabelas[2]))
oBrowse30 :SetDoubleClick( {|| CPP_DbClick() } )
oBrowse30:Activate()

oBrowse31 := FWBrowse():New()
oBrowse31 :SetOwner(oWIN_TOP)
oBrowse31 :SetDescription(__CTITULO)
oBrowse31 :SetDataTable()
oBrowse31 :SetAlias(_aTabelas[3])
oBrowse31 :SetColumns(CPP_Colunas('TIT',oBrowse31,_aTabelas[3]))
oBrowse31 :SetDoubleClick( {|| CPP_DbClick() } )
oBrowse31:Activate()
*/

Return


Static Function CPP_AtuBrw(nFolder)

Local _cAlias


// --- Variaveis utilizadas 
/*
If nFolder > 1
	
	_cAlias		:= _aTabelas[nFolder,1]
	dbSelectArea(_cAlias)
	dbGoTop()
	
	oBrowse := 'oBrowse'+_aTipos[nFolder]
	&oBrowse:Refresh()
Else
	oBrowseCal:Refresh()
EndIf
*/ 

//oFWLayerSE2:Init(oPnlSE2,.F.)
_nFolder := nFolder

Return 


//-----------------------------------------------------------------------------------------
/* {2LGI} CPP_SX1
@autor		: Luiz Alexandre
@descricao	: Atualiza cadastro de perguntas
@since		: 30/Set./2013
@using		: Central de pagamentos
@review
*/
//-----------------------------------------------------------------------------------------
Static Function CPP_SX1(_cPerg)
Local aArea    	:= GetArea()
Local aHelpPor 	:= {}
Local aHelpEng 	:= {}
Local aHelpEsp 	:= {}

// ---
aHelpPor := {"Informe a data de vencimento inicial."}
aHelpEng := {"Introduzca la fecha inicial."}
aHelpEsp := {"Enter the initial date."}
PutSx1(_cPerg, "01", "Vencimento de?", "Fecha inicial?", "Date of?", ;
"MV_CH1", "D",8, 0, 0, "G", "", "", "", "", ;
"MV_PAR01", "", "", "", "", "", "", "", "", ;
"", "", "", "N", "", "", "", "", ;
aHelpPor, aHelpEng, aHelpEsp )

// ---
aHelpPor := {"Informe a data de vencimento final."}
aHelpEng := {"Introduzca la fecha final."}
aHelpEsp := {"Enter the end date."}
PutSx1(_cPerg, "02", "Vencimento ate?", "Fecha finale?", "Date end?", ;
"MV_CH2", "D",8, 0, 0, "G", "", "", "", "", ;
"MV_PAR02", "", "", "", "", "", "", "", "", ;
"", "", "", "N", "", "", "", "", ;
aHelpPor, aHelpEng, aHelpEsp )

// ---
aHelpPor := {"Informe o codigo do banco."}
aHelpEng := {"Introduzca el codigo do banco."}
aHelpEsp := {"Enter the bank id."}
PutSx1(_cPerg, "03", "Codigo do banco", "Codigo del banco", "Bank id", ;
"MV_CH3", "C", TamSX3("A6_COD")[1], 0, 0, "G", "", "SA6", "", "", ;
"MV_PAR03", "", "", "", "", "", "", "", "", ;
"", "", "", "N", "", "", "", "", ;
aHelpPor, aHelpEng, aHelpEsp )

// ---
aHelpPor := {"Informe o numero da agencia bancaria"}
aHelpEng := {"Introduzca el codigo da agencia."}
aHelpEsp := {"Enter the bank id."}
PutSx1(_cPerg, "04", "Agencia", "Agencia", "Agencia", ;
"MV_CH4", "C", TamSX3("A6_AGENCIA")[1], 0, 0, "G", "", "", "", "", ;
"MV_PAR04", "", "", "", "", "", "", "", "", ;
"", "", "", "N", "", "", "", "", ;
aHelpPor, aHelpEng, aHelpEsp )

// ---
aHelpPor := {"Informe o numero da Conta bancaria"}
aHelpEng := {"Informe o numero da Conta bancaria"}
aHelpEsp := {"Informe o numero da Conta bancaria"}
PutSx1(_cPerg, "05", "Numero da conta", "Numero da Conta", "Numero da conta", ;
"MV_CH5", "C", TamSX3("A6_NUMCON")[1], 0, 0, "G", "", "", "", "", ;
"MV_PAR05", "", "", "", "", "", "", "", "", ;
"", "", "", "N", "", "", "", "", ;
aHelpPor, aHelpEng, aHelpEsp )

RestArea(aArea)

Return Pergunte(_cPerg,.t.)

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author Luiz

@since 07/07/2014
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView
Local oModel := ModelDef()

oView := FWFormView():New()

oView:SetModel(oModel)

Return oView
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author Luiz

@since 07/07/2014
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel

oModel := MPFormModel():New('ModelName')

Return oModel