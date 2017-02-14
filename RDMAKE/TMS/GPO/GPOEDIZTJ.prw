#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "PARMTYPE.CH"

/*
Programa    : GPOEDIZTJ
Funcao      : GPOEDIZTJ - MVC
Data        : 23/09/2016
Autor       : Ricardo Guimarães
Descricao   : Função Principal - Controller
Uso         : GPOEDIMich
Sintaxe     : GPOEDIZTJ
Chamanda    : Menu
*/

User Function GPOEDIZTJ
	Local aArea		:= GetArea()
	Local oBrowseUp
	Local _cEDIMich	:= GetNewPar('ES_EDIMICH','CONMIC|NOTMIC|WSH241|WSH242') 
	Local _cFiltro	:= "AllTrim(ZTJ_LAYOUT) $ '" + _cEDIMich + "'"

	aRotina	 :=	MenuDef()

	oBrowseUp := FWMBrowse():New()
	oBrowseUp:SetAlias( 'ZTJ' )
	oBrowseUp:SetFilterDefault( _cFiltro)	
	oBrowseUp:SetDescription( "Painel EDI - Michilin" )
	oBrowseUp:SetAmbiente(.F.)
	oBrowseUp:SetWalkthru(.F.)
	oBrowseUp:Activate()

	RestArea( aArea )

Return NIL

/*
Programa    : GPOEDIZTJ
Funcao      : GPOEDIZTJ - MVC
Data        : 23/09/2016
Autor       : Ricardo Guimarães
Descricao   : Função Principal - Controller
Uso         : GPOEDIMich
Sintaxe     : GPOEDIZTJ
Chamanda    : Menu
*/

Static Function ModelDef

	Local oModel	:= Nil
	Local oStrZTJ	:= FwFormStruct( 1,"ZTJ" )

	oModel := MPFormModel():New("MODEL_ZTJ", /*bPre*/,/*bPost*/, /*bCommit*/, /*bCancel*/ )
	oModel:AddFields('FORMZTJ',/*cOwner*/,oStrZTJ)

	oModel:SetPrimaryKey({})

	oModel:SetDescription("Painel EDI - Michelin")

	oModel:GetModel("FORMZTJ"):SetDescription("Painel EDI")

Return oModel

/*
Programa    : GPOEDIZTJ
Funcao      : GPOEDIZTJ - MVC
Data        : 23/09/2016
Autor       : Ricardo Guimarães
Descricao   : Função Principal - Controller
Uso         : GPOEDIMich
Sintaxe     : GPOEDIZTJ
Chamanda    : Menu
*/

Static Function ViewDef

	Local oModel	:= FwLoadModel( "GEFINSZTJ" )
	Local oStruZTJ	:= FwFormStruct( 2,"ZTJ")

	Local oView	  	:= Nil

	oView := FwFormView():New()
	oView:SetModel( oModel )

	oView:AddField( "VIEW_ZTJ", oStruZTJ, "FORMZTJ")

	oView:CreateHorizontalBox( 'TELA', 100 )

	oView:EnableTitleView('VIEW_ZTJ', 'Painel EDI - Michelin' )

	oView:SetCloseOnOk( { || .T. } )

	oView:SetOwnerView( "VIEW_ZTJ", "TELA" )

Return( oView )

/*
Programa    : GPOEDIZTJ
Funcao      : GPOEDIZTJ - MVC
Data        : 23/09/2016
Autor       : Ricardo Guimarães
Descricao   : Função Principal - Controller
Uso         : GPOEDIMich
Sintaxe     : GPOEDIZTJ
Chamanda    : Menu
*/

Static Function MenuDef
    Local aRot		:= {}

    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.GEFINSZTJ'			OPERATION MODEL_OPERATION_VIEW		ACCESS 0
//    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.GEFINSPA7'			OPERATION MODEL_OPERATION_INSERT	ACCESS 0
//    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.GEFINSPA7'			OPERATION MODEL_OPERATION_UPDATE	ACCESS 0
//    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.GEFINSPA7' 		OPERATION MODEL_OPERATION_DELETE	ACCESS 0
    ADD OPTION aRot TITLE 'Gerar EDI'  ACTION 'U_EDIWSH241'					OPERATION MODEL_OPERATION_INSERT	ACCESS 0

Return aRot

