#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "PARMTYPE.CH"

/*
Programa    : GEFINSPA7
Funcao      : GEFINSPA7 - MVC
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Principal - Controller
Uso         : Externo
Sintaxe     : GEFINSPA7
Chamanda    : Menu
*/

User Function GEFINSPA7		// u_GEFINSPA7()
	Local aArea		:= GetArea()
	Local oBrowseUp

	aRotina	 :=	MenuDef()

	oBrowseUp := FWMBrowse():New()
	oBrowseUp:SetAlias( 'PA7' )
	oBrowseUp:SetDescription( "Registro CNH - OTM" )
	oBrowseUp:SetAmbiente(.F.)
	oBrowseUp:SetWalkthru(.F.)
	oBrowseUp:Activate()

	RestArea( aArea )

Return NIL


/*
Programa    : GEFINSPA7
Funcao      : ModelDef - MVC
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Statica - Modelagem dos Dados
Uso         : Interno
Sintaxe     : ModelDef()
Chamanda    : GEFINSPA7
*/

Static Function ModelDef

	Local oModel	:= Nil
	Local oStrPA7	:= FwFormStruct( 1,"PA7" )

	oModel := MPFormModel():New("MODEL_PA7", /*bPre*/,/*bPost*/, /*bCommit*/, /*bCancel*/ )
	oModel:AddFields('FORMPA7',/*cOwner*/,oStrPA7)

	oModel:SetPrimaryKey({})

	oModel:SetDescription("Cadastro CNH - OTM")

	oModel:GetModel("FORMPA7"):SetDescription("Formulário do Cadastro")

Return oModel

/*
Programa    : GEFINSPA7
Funcao      : ViewDef - MVC
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Statica - Visualização dos Dados
Uso         : Interno
Sintaxe     : ViewDef()
Chamanda    : GEFINSPA7
*/

Static Function ViewDef

	Local oModel	:= FwLoadModel( "GEFINSPA7" )
	Local oStruPA7	:= FwFormStruct( 2,"PA7")

	Local oView	  	:= Nil

	oView := FwFormView():New()
	oView:SetModel( oModel )

	oView:AddField( "VIEW_PA7", oStruPA7, "FORMPA7")

	oView:CreateHorizontalBox( 'TELA', 100 )

	oView:EnableTitleView('VIEW_PA7', 'Formulário do Cadastro - CNH OTM' )

	oView:SetCloseOnOk( { || .T. } )

	oView:SetOwnerView( "VIEW_PA7", "TELA" )

Return( oView )

/*
Programa    : GEFINSPA7
Funcao      : MenuDef - MVC
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Statica - Menus
Uso         : Interno
Sintaxe     : MenuDef()
Chamanda    : GEFINSPA7
*/

Static Function MenuDef
    Local aRot		:= {}

    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.GEFINSPA7'						OPERATION MODEL_OPERATION_VIEW		ACCESS 0
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.GEFINSPA7'						OPERATION MODEL_OPERATION_INSERT	ACCESS 0
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.GEFINSPA7'						OPERATION MODEL_OPERATION_UPDATE	ACCESS 0
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.GEFINSPA7' 						OPERATION MODEL_OPERATION_DELETE	ACCESS 0
    ADD OPTION aRot TITLE 'Importar'   ACTION 'StaticCall(GEFIMPPA7 , GEFIMPPA7 )'	OPERATION MODEL_OPERATION_INSERT	ACCESS 0

Return aRot


