#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

#DEFINE FIAT_PATH		"\Interfaces\TMS\PROTHEUS\OUT\FIAT\"
#DEFINE FIAT_BACKUP	"\Interfaces\TMS\PROTHEUS\OUT\FIAT\BACKUP\"
#DEFINE FILELOG		"ImportEDI.LOG"

/*
Programa    : GEFBRWEDI
Funcao      : GEFBRWEDI - MVC
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função Principal - Controller
Uso         : Externo
Sintaxe     : GEFBRWEDI
Chamanda    : Menu
*/

User Function teste_FWBROWSE
	Local aArea	:= GetArea()
	Local aCoors 	:= FWGetDialogSize( oMainWnd )

	Local oDlgPrinc
	Local oFWLayer

	Local oFont
	Local oSay
	Local oSay1
	Local oArqs
	Local _cArqs	:= ""
	Local nRadio 	:= 1                     
	Local aItens 	:= {'DTC','TOP'}
	Local oRadio 	

	Local cAlias01	:= GetNextAlias()
	Local cAlias02	:= GetNextAlias()
	Local cAlias03	:= GetNextAlias()
	Local cAlias04	:= GetNextAlias()

	Local nInterval		:= 40000
	Local bTimerAction	:= { || xAtualiza()  }
/*
	Local aField		:= {	{ "PA8_FILORI" , "Filial" 	, 04 } ,;
								{ "PA8_ARQUIV" , "Arquivo" 	, 30 } }

	Local aLegenda	:=	{	{" Empty( PA8_FILORI ) .And.  Empty( PA8_OPERAC ) .And.  Empty( PA8_STATUS )"	,"BR_LARANJA"		,"EDI - Problemas na Leitura"	} ,;
								{"!Empty( PA8_FILORI ) .And. !Empty( PA8_OPERAC ) .And.  Empty( PA8_STATUS )"	,"BR_VERDE"		,"EDI - Não Processado"			} ,;
					 			{"!Empty( PA8_FILORI ) .And. !Empty( PA8_OPERAC ) .And. !Empty( PA8_STATUS )"	,"BR_VERMELHO"	,"EDI - Processado"				} }

	Private aOper 	:=	{	{ "1", "Operação - FTL" 			, "PA8_OPERAC == '6' .And. Empty( PA8_STATUS )" } ,;
								{ "2", "Operação - Milk Run"	, "PA8_OPERAC == 'M' .And. Empty( PA8_STATUS )" } ,;
								{ "3", "Operação - LineHaul"	, "PA8_OPERAC == 'T' .And. Empty( PA8_STATUS )" } ,;
								{ "4", "Inconsistencias do EDI"	, "PA8_OPERAC == ''	.And. Empty( PA8_STATUS )" } }
*/
	Private oBrowse1
	Private oBrowse2

	Private oPanel1
	Private oPanel2
	Private oPanel3
	Private oPanel4
	
	Private oDlgPrinc
	Private _aArqs 	:= {}
		
	DbSelectArea("SX2")
	SX2->(DbSetOrder(1))
	dbChangeAlias("SX2",cAlias01)

/*
	DbSelectArea("PA8")
	PA8->(DbSetOrder(2))
	dbChangeAlias("PA8",cAlias02)
*/

//	AjustaSX6()

	MsgRun("Aguarde... Montando lista de arquivos(DTC)... ",,{|| fGetArqs(1) })

	Define MsDialog oDlgPrinc Title 'Registros' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

	oFWLayer	:= FWLayer():New()
	oFWLayer:Init( oDlgPrinc, .F., .T. )

	oFWLayer:AddLine( 'UP', 20, .F. )
	oFWLayer:AddCollumn( '01' , 100, .T., 'UP' )
//	oFWLayer:AddCollumn( '02' , 50, .T., 'UP' )

	oPanel1	:= oFWLayer:GetColPanel( '01', 'UP' )
	//oPanel2	:= oFWLayer:GetColPanel( '02', 'UP' )

	oFWLayer:AddLine( 'DOWN', 80, .F. )
	oFWLayer:AddCollumn( '03' , 100, .T., 'DOWN' )
//	oFWLayer:AddCollumn( '04' , 50, .T., 'DOWN' )

	oPanel3	:= oFWLayer:GetColPanel( '03' , 'DOWN' )
//	oPanel4	:= oFWLayer:GetColPanel( '04', 'DOWN' )

/*
	oBrowse1:= FWBrowse():New()
	oBrowse1:SetDataTable()
	oBrowse1:SetOwner( oPanel3 )

	oBrowse1:SetAlias( cAlias01 )
*/

//	oBrowse1:SetProfileID("1")
//	oBrowse1:SetDescription("Operação - FTL")
	//oBrowse1:SetFilterDefault("PA8_OPERAC == '6' .And. Empty( PA8_STATUS )")
//	oBrowse1:OptionReport(.F.)
//	oBrowse1:DisableConfig()
//	oBrowse1:SetUseFilter()

/*
	For X := 1 To Len( aLegenda )
		ADD Legend Data aLegenda[X][1] Color aLegenda[X][2] Title aLegenda[X][3] Of oBrowse1
	Next X
*/
/*
	ADD Column oColumn Data { || X2_CHAVE 	} Title "Filial"	Size 04 OF oBrowse1
	ADD Column oColumn Data { || X2_ARQUIVO } Title "Arquivo"	Size 30 OF oBrowse1
	ADD Column oColumn Data { || X2_NOME  	} Title "Arquivo"	Size 30 OF oBrowse1	
*/
//	oBrowse1:Activate()

/*
	oBrowse2:= FWBrowse():New()
	oBrowse2:SetDataTable()
	oBrowse2:SetOwner( oPanel4 )
	oBrowse2:SetAlias( cAlias02 )
	oBrowse2:SetProfileID("1")
	oBrowse2:SetDescription("Operação - XXX")
	oBrowse2:SetFilterDefault("PA8_OPERAC == '6' .And. Empty( PA8_STATUS )")
	oBrowse2:OptionReport(.F.)
	oBrowse2:DisableConfig()

	For X := 1 To Len( aLegenda )
		ADD Legend Data aLegenda[X][1] Color aLegenda[X][2] Title aLegenda[X][3] Of oBrowse2
	Next X

	ADD Column oColumn Data { || PA8_FILORI } Title "Filial"	Size 04 OF oBrowse2
	ADD Column oColumn Data { || PA8_ARQUIV } Title "Arquivo"	Size 30 OF oBrowse2

	oBrowse2:Activate()
*/

//   oTimer := TTimer():New( nInterval , bTimerAction , oDlgPrinc )
//   oTimer:Activate()

     // Cria Fonte para visualização
     oFont := TFont():New('Courier new',,-18,.T.)

	nRadio := 1                     
	aItens := {'DTC','TOP'}
	oRadio := TRadMenu():Create (oPanel1,,aCoors[1]+03,aCoors[2]+05,aItens,,,,,,,,100,20,,,,.T.) 
	oRadio:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}
    //oRadio:bChange := {|u|Iif (PCount()==0,nRadio,(MsgRun("Aguarde... Montando lista de arquivos... ",,{|| _aArqs  := fGetArqs(nRadio,oArqs)}),nRadio:=u)) } 
	
	oRadio:bChange := {|u|Iif (PCount()==0,nRadio,nRadio := fGetArqs(nRadio,oArqs)) }	
	      
     // Usando o método New
     oSay1:= TSay():New(aCoors[1]+03,aCoors[2]+50,{||'Lista de Tabelas:'},oPanel1,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)
       
    // Usando o método Create
    // oSay:= TSay():Create(oPanel1,{||'Texto para exibição'},aCoors[1]+20,aCoors[2]+01,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)

	oArqs := TComboBox():Create(oPanel1,{|u|IIF(PCOUNT() > 0, (_cArqs := u, fBrowse1(_cArqs)),_cArqs)},aCoors[1]+03,aCoors[2]+150,_aArqs,100,20,,{||},,,,.T.,,,,,,,,,'_cArqs')
//	oArqs:bSetGet 	:= {|u|DbSelectArea(_cArqs),DbSetOrder(1),dbChangeAlias((_cArqs),cAlias01) }
//	oArqs:bSetGet 	:= {|u|_cArqs := u, fteste(u, oArqs) }	
	oArqs:bChange	:= {|u|_cArqs := u, , xAtualiza() }	
	
	Activate MsDialog oDlgPrinc Center

	RestArea(aArea)

Return NIL

/*
Programa    : GEFBRWEDI
Funcao      : xAtualiza
Data        : 17/03/2016
Autor       : André Costa
Descricao   : Função de Atualização de Browse com novas informações
Uso         : Interno
Sintaxe     : xAtualiza()
Chamanda    : GEFBRWEDI
*/

Static Function xAtualiza
//	Local aArea := GetArea()

	Begin Sequence

		oBrowse1:SetFocus()
		oBrowse1:GoTop()
		oBrowse1:Refresh()

	End Sequence

//	RestArea( aArea )

Return


//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author u297686

@since 16/11/2016
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

@author u297686

@since 16/11/2016
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel

oModel := MPFormModel():New('ModelName')

Return oModel

/*--------------------------------------*/
Static Function fGetArqs(_nRadio, _oArqs)
/*--------------------------------------*/
Local _aRet 	:= {}

If _nRadio == 1 // "DTC"
    _aArqs := Directory("SX*.DTC",,NIl,.T.,2)
    
    For x := 1 to Len(_aArqs)
    	AADD(_aRet, _aArqs[x][1])
    Next x
Else

	MsgRun("Aguarde... Montando lista das tabelas(SX2)... ",,{|| _aRet := fGetSX2() })

EndIf

_aArqs := _aRet

If ValType(_oArqs) == "O" 
	_oArqs:aItems 		:= _aArqs
	_oArqs:lModified 	:= .F.
EndIf

Return _nRadio	

/*--------------------------------------*/
Static Function fGetSX2()
/*--------------------------------------*/
Local _aRet 	:= {}
Local _aArea 	:= GetArea()
Local _nConta   := 0 

dbSelectArea("SX2") ; dbGoTop()
    
While !SX2->(Eof()) 
    AADD(_aRet, SX2->X2_ARQUIVO)
	SX2->(dbSkip()) 
End

RestArea(_aArea)    
Return _aRet

/*--------------------------------------*/
Static Function fBrowse1(_cArq, nRadio)
/*--------------------------------------*/
Local _aRet 	:= {}

	If ValType(oBrowse1) == "O"
		oBrowse1:DeActivate(.T.)
	EndIf
		
	oBrowse1:= FWBrowse():New()
	oBrowse1:SetDataTable()
	oBrowse1:SetOwner( oPanel3 )

	oBrowse1:SetAlias( 'SX2' )

//	oBrowse1:SetProfileID("1")
	oBrowse1:SetDescription("Operação - FTL")
//	oBrowse1:SetFilterDefault("PA8_OPERAC == '6' .And. Empty( PA8_STATUS )")
	oBrowse1:OptionReport(.F.)
	oBrowse1:DisableConfig()
	oBrowse1:SetUseFilter()

	ADD Column oColumn Data { || X2_CHAVE 	} Title "Filial"	Size 04 OF oBrowse1
	ADD Column oColumn Data { || X2_ARQUIVO } Title "Arquivo"	Size 30 OF oBrowse1
	ADD Column oColumn Data { || X2_NOME  	} Title "Nome Arq"	Size 30 OF oBrowse1

	oBrowse1:Activate()

Return( _cArq )
