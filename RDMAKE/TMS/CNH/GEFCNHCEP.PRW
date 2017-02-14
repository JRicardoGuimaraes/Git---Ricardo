#Include 'Protheus.ch'
#Include 'Fwmvcdef.ch'
#Include 'Fwadaptereai.ch'
#Include 'Fwmbrowse.ch'

//-------------------------------------------------------------------------------------------------
/* {2LGI} GEFCNHCEP
@autor		: Luz Alexandre
@descricao	: Funcao principal da rotina para manutencao de cadastro de distancias por CEP
@since		: Ago./2014
@using		: Interface CNH, para comparar a distancia em Km enviado no 
@using		: plano de transporte Interface060
@review		: 11/12/2014 - Alterada a chave da tabela para comportar o tipo de veiculo
*/
//-------------------------------------------------------------------------------------------------
User Function GEFCNHCEP()

// --- Variaveis utilizadas
Local cCadastro		:= OemToAnsi('Manutenção de cadastro de distância por CNPJ')
Local oMBrowse
Private aRotina		:= {}


// --- Definição do Modelo de Dados
ModelDef()

// --- Definição do Modelo de Dados
ViewDef()


// --- Definição das operacoes de menu disponiveis
aRotina	 :=	MenuDef()

oMBrowse:= FWMBrowse():New()
oMBrowse:SetAlias( "PA4" )
oMBrowse:SetDescription( cCadastro )
oMBrowse:Activate()

Return

//-------------------------------------------------------------------------------------------------
/* {2LGI} ModelDef
@autor		: Luz Alexandre
@descricao	: Funcao que cria o modelo de dados
@since		: Ago./2014
@using		: Interface CNH, para comparar a distancia em Km enviado no 
@using		: 
@review	:
*/
//-------------------------------------------------------------------------------------------------
Static Function ModelDef()

// --- Variaveis utilizadas
Local _cDesCab	:= 'Distancias por CNPJ'
Local _cDesDet	:= 'Dados da Distancia'
Local oModel
Local oStr1		:= FwFormStruct( 1,"PA4", { |cCampo| !AllTrim( cCampo ) + "|" $ "PA4_XTPVEI|PA4_DIST|" } )
Local oStr2		:= FwFormStruct( 1,"PA4", { |cCampo|  AllTrim( cCampo ) + "|" $ "PA4_XTPVEI|PA4_DIST|" } )

oModel := MPFormModel():New("CNHCEP_MVC", /*bPre*/, { |oModel| CNHCEPVLD(oModel) } /*bPost*/, /*bCommit*/, /*bCancel*/)
oModel:SetDescription(_cDesCab)
oModel:addFields('CNHCEPCPA4',,oStr1)
oModel:SetPrimaryKey({ 'PA4_FILIAL', 'PA4_CNPJO', 'PA4_CNPJD', 'PA4_XTPVEI' })
oModel:addGrid('CNHCEPIPA4','CNHCEPCPA4',oStr2)
oModel:SetRelation('CNHCEPIPA4', { { 'PA4_FILIAL', 'PA4_FILIAL' }, { 'PA4_CNPJO', 'PA4_CNPJO' }, { 'PA4_CNPJD', 'PA4_CNPJD' } }, PA4->(IndexKey(1)) )
oModel:GetModel('CNHCEPIPA4'):SetUniqueLine( { 'PA4_XTPVEI' } )
oModel:getModel('CNHCEPCPA4'):SetDescription(_cDesCab)
oModel:getModel('CNHCEPIPA4'):SetDescription(_cDesDet)
oModel:getModel('CNHCEPIPA4'):SetUseOldGrid(.T.)  
  
//oModel:AddCalc('CNHCEPTOT', 'CNHCEPCPA4', 'CNHCEPIPA4','PA4_DIST'	, 'Total de KM'		, "SUM" ) 
//oModel:AddCalc('CNHCEPTOT', 'CNHCEPCPA4', 'CNHCEPIPA4','PA4_VALPDG'	, 'Total de Pedagio', "SUM" ) 
//oModel:SetReportTotal(.F.)

Return oModel 

//-------------------------------------------------------------------------------------------------
/* {2LGI} ViewDef
@autor		: Luz Alexandre
@descricao	: Funcao que cria o modelo de visualizacao dos dados
@since		: Ago./2014
@using		: Interface CNH, para comparar a distancia em Km enviado no 
@using		: 
@review	:
*/
//-------------------------------------------------------------------------------------------------
Static Function ViewDef()
                          
// --- Variaveis utilizadas
Local oModel		:= FwLoadModel( "GEFCNHCEP" )
Local oView	  		:= Nil
Local oStruCPA4		:= FwFormStruct( 2,"PA4", { |cCampo| !AllTrim( cCampo ) + "|" $ "PA4_XTPVEI|PA4_DIST|" } )
Local oStruIPA4		:= FwFormStruct( 2,"PA4", { |cCampo|  AllTrim( cCampo ) + "|" $ "PA4_XTPVEI|PA4_DIST|" } )
Local oCalc1		:= Nil

//oCalc1 := FWCalcStruct( oModel:GetModel('CNHCEPTOT') )

oView := FwFormView():New()
oView:SetUseCursor(.F.)
oView:SetModel( oModel )
oView:AddField( "CNHCEPCPA4", oStruCPA4 )
oView:CreateHorizontalBox( 'TOPO', 30 )
oView:SetOwnerView( "CNHCEPCPA4", "TOPO" )
oView:EnableControlBar(.T.)          

oView:AddGrid( "CNHCEPIPA4", oStruIPA4 )
oView:CreateHorizontalBox( "GRID", 70 )
oView:SetOwnerView( "CNHCEPIPA4"  , "GRID"  )
oView:GetModel('CNHCEPIPA4'):SetOptional(.T.)    

//oView:CreateHorizontalBox( "TOTAL", 10 )
//oView:AddField('VIEWCALC', oCalc1, 'CNHCEPTOT' )   
//oView:SetOwnerView('VIEWCALC', 'TOTAL' )

Return( oView )   


/*/{Protheus.doc} GFEA012VLD
(long_description)
@author Luiz
@since 12/12/2014
@version 1.0
@param oModel, objeto, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function CNHCEPVLD(oModel)

//	---	Variaveis utilizadas
Local 	_lRet     	:=	.T.
local 	_nOpc     	:=	(oModel:GetOperation())
Local 	_aArea    	:=	GetArea()
Local	_nCount	:=	0
Local	_oModelPA4	:=	oModel:GetModel('CNHCEPIPA4')
	
//	---	Se inclusao ou alteracao
If _nOpc == MODEL_OPERATION_INSERT .or. _nOpc == MODEL_OPERATION_UPDATE 

	//	---	Verifica se a chave já foi informada     
	If ! Empty(AllTrim(FwFldGet("PA4_CNPJO"))) .and. ! Empty(AllTrim(FwFldGet("PA4_CNPJD"))) 
	
		
		//	---	Verifica linhas da grid
		For _nCount	:=  1 to 	_oModelPA4:GetQtdLine()
		
			//	--- Posiciona conteudo em cada linha	
			_oModelPA4:GoLine(_nCount)
			//	---	Verifica se não está deletada
			If !_oModelPA4:IsDeleted()
				//	---	Somente campos preenchidos.
				If !Empty(FwFldGet("PA4_XTPVEI",_nCount))
					//	---	
					If ExistChav("PA4",xFilial("PA4")+FwFldGet("PA4_CNPJO",_nCount)+FwFldGet("PA4_CNPJD",_nCount)+FwFldGet("PA4_XTPVEI",_nCount),1)
						
						//	---	Exibe mensagem
						Help( ,, 'CNHCEPVLD',, 'Grupo de veículo já informado para CNPJ', 1, 0)
						_lRet	:= .f.
					
					EndIf
				
				EndIf
			EndIf 
		Next _nCount
	EndIf	
			
EndIf

//	---	Restaura area de trabalho	
RestArea(_aArea)

Return _lRet      
        

//-------------------------------------------------------------------------------------------------
/* {2LGI} CNHCEPIMP
@autor		: Luiz Alexandre
@descricao	: Menu da rotina principal
@since		: Ago./2014
@using		: Relatorio do cadastro de distancias por CEP
@review  	:
*/
//-------------------------------------------------------------------------------------------------
User Function CNHCEPIMP()
         
// --- Variaveis utilizadas
Local oReport
Private _cPerg	:= 'GEFCNHCEP0'

// --- Verifica perguntas
CNHCEP_SX1(_cPerg)

// --- Definicoes do relatorio
oReport := CNHCEPIMP_DEF()

// --- Exibe spool
oReport:PrintDialog()

Return

//-------------------------------------------------------------------------------------------------
/* {2LGI} CNHCEPIMP_DEF
@autor		: Luiz Alexandre
@descricao	: Definicao do relatorio de distancias
@since		: Ago./2014
@using		:
@review	:
*/
//-------------------------------------------------------------------------------------------------
Static Function CNHCEPIMP_DEF()

// --- Variaveis utilizadas
Local _cReport	:= 'GEFCNHCEP'
Local _cTitulo	:= OemToAnsi('Distancias por CNPJ')
Local _cDesc	:= OemtoAnsi('Relação de distancias por CNPJ')
Local oReport
Local oSection1

oReport := TReport():New(_cReport,_cTitulo,_cPerg,{|oReport| CNHCEPPrint(oReport)},_cDesc)   
oReport:lParamPage:= .f.
                                
// --- Secao de CNPJ 
oSection1 := TRSection():New(oReport,"Distancias" ,"PA4")  
oSection1:oReport:nFontBody := 8
TRCell():New(oSection1,"PA4_CNPJO"	,"PA4","CNPJ Origem")
TRCell():New(oSection1,"PA4_CEPO" 	,"PA4","Cep Origem")  
TRCell():New(oSection1,"ENDO" 		,"SA1","Endereco",,25)  
TRCell():New(oSection1,"PA4_CNPJD"	,"PA4","CNPJ Destino")
TRCell():New(oSection1,"PA4_CEPD" 	,"PA4","Cep Destino")
TRCell():New(oSection1,"ENDD" 		,"SA1","Endereco",,25)  
TRCell():New(oSection1,"PA4_XTPVEI"	,"PA4","Grupo")
TRCell():New(oSection1,"PA4_DIST" 	,"PA4","Distancia")
TRFunction():New(oSection1:Cell("PA4_CNPJO"),NIL,"COUNT")
TRFunction():New(oSection1:Cell("PA4_DIST"),NIL,"SUM")      

Return oReport

//-------------------------------------------------------------------------------------------------
/* {2LGI} CNHCEPPrint
@autor		: Luiz Alexandre
@descricao	: Impressão do relatorio
@since		: Ago./2014
@using		:
@review	:
*/
//-------------------------------------------------------------------------------------------------
Static Function CNHCEPPrint(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias	:= GetNextAlias()      
Local cOrder	:= "%PA4_CNPJO%"

// --- Transforma os parametros em expressao SQL
MakeSqlExpr(oReport:uParam)
 
// --- Inicia montagem da query
oSection1:BeginQuery()

BeginSql alias cAlias 
	SELECT
	PA4.PA4_CNPJO,
	PA4.PA4_CEPO,
	PA4.PA4_CNPJD,
	PA4.PA4_CEPD,
	PA4.PA4_DIST,
	PA4.PA4_XTPVEI,
	SA11.A1_END ENDO,
	SA11.A1_CGC,
	SA12.A1_END ENDD,
	SA12.A1_CGC 
	FROM 
	%table:PA4% PA4
        INNER JOIN %table:SA1% SA11
        ON PA4.PA4_FILIAL = SA11.A1_FILIAL AND
        PA4.PA4_CNPJO = SA11.A1_CGC AND
        SA11.D_E_L_E_T_ = ' ' 
        INNER JOIN %table:SA1% SA12
        ON PA4.PA4_FILIAL = SA12.A1_FILIAL AND
        PA4.PA4_CNPJD = SA12.A1_CGC AND
        SA12.D_E_L_E_T_ = ' '     
	WHERE  
	PA4.PA4_FILIAL = %xfilial:PA4% AND
	PA4.PA4_CNPJO = %exp:Mv_par01% AND
	PA4.D_E_L_E_T_= ' ' 
	ORDER BY %exp:cOrder%
EndSql
                            
/*	Prepara relatorio para executar a query gerada pelo Embedded SQL passando como 	parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados 	pela funcao MakeSqlExpr para serem adicionados a query	*/
oSection1:EndQuery() 
oSection1:Print() 

(cAlias)->(dbCloseArea())    

Return

//-------------------------------------------------------------------------------------------------
/* {2LGI} CNHCEPIMP_SX1
@autor		: Luz Alexandre
@descricao	: Atualiza os parametros da rotina
@since		: Ago./2014
@using		:
@review	:
*/
//-------------------------------------------------------------------------------------------------
Static Function CNHCEP_SX1(_cPerg)

// --- Variaveis utilizadas
Local aHelpPor 	:= {}
Local aHelpEng 	:= {}
Local aHelpEsp 	:= {}

// --- Parametros com help
aHelpPor := { "Informe o CNPJ origem" }
aHelpEng := { "Informe o CNPJ origem" }
aHelpEsp := { "Informe o CNPJ origem" }
PutSx1(_cPerg, "01", "CNPJ Origem", "CNPJ Origem", "CNPJ Origem", ;
"MV_CH1", "C",TamSX3("PA4_CNPJO")[1], 0, 0, "G", "", "", "", "", ;
"MV_PAR01", "", "", "", "", "", "", "", "", ;
"", "", "", "N", "", "", "", "", ;
aHelpPor, aHelpEng, aHelpEsp )

// --- Posiciona na pergunta
Pergunte(_cPerg,.f.)

Return    


//-------------------------------------------------------------------------------------------------
/* {2LGI} MenuDef
@autor		: Luz Alexandre
@descricao	: Menu da rotina principal
@since		: Ago./2014
@using		: Manutencao do cadastro de distancias por CEP
@review  	:
*/
//-------------------------------------------------------------------------------------------------
Static Function MenuDef()

Local aRotina 	:= {}

ADD OPTION aRotina TITLE "Pesquisar"  	ACTION "PesqBrw"         	OPERATION 1 ACCESS 0 
ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.GEFCNHCEP" 	OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE "Incluir"    	ACTION "VIEWDEF.GEFCNHCEP" 	OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE "Alterar"    	ACTION "VIEWDEF.GEFCNHCEP" 	OPERATION 4 ACCESS 143
ADD OPTION aRotina TITLE "Excluir"    	ACTION "VIEWDEF.GEFCNHCEP" 	OPERATION 5 ACCESS 144
ADD OPTION aRotina TITLE "Imprimir"     ACTION "U_CNHCEPIMP()" 		OPERATION 8 ACCESS 0

Return aRotina