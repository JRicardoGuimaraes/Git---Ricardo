#include 'TOTVS.CH'

User Function TMA050FIM
//-------------------------------------------------------------------------------------------------
/* {2LGI} TMA050FIM
@autor		: Luiz Alexandre
@descricao	: Ponto de entrada para gravar o valor informado do pedagio nos lotes CNH.
@since		: Set./2014
@using		: Interface CNH - Gravação do lote
@review		:
*/
//-------------------------------------------------------------------------------------------------
// ---	Variaveis utilizadas
Local	_aArea		:=	GetArea()
Local	_aAreaDTC	:= 	DTC->(GetArea())
Local	_aOpcao	:= 	ParamIxb   
Local 	_cSerCol	:= 	'COL'    
Local	_cProd		:= 	''
Local	_aProd		:=	{}
Local 	_cCompPdg 	:= 	GetMv('ES_CNHCPDG')

// --- Produto do item do agendamento
_cProd		:= 	GetMV('ES_CNHPROD')
_aProd 	:= 	Iif(!Empty(_cProd),&_cProd,{}) 
_cProd		:=	GetAdvFVal('SB1','B1_COD',xFilial('SB1')+_aProd[1],1,'')


// ---	Se foi informada a solicitacao de coleta
If !Empty(DTC->DTC_NUMSOL) 

	// ---	Somente na inclusao ou alteracao
	If (_aOpcao[1]	== 3 .or. _aOpcao[1] == 4)
		
		// --- Localiza o plano de transporte a partir do documento de transporte DT6.
		DF1->(dbSetOrder(3))
		If DF1->(dbSeek(xFilial('DF1')+DTC->DTC_FILORI+DTC->DTC_NUMSOL+_cSerCol))
		
			// --- Localiza o pedagio do item do plano [ja rateado]
			DF3->(dbSetOrder(1))
			If DF3->(dbSeek(xFilial('DF3')+DF1->DF1_NUMAGE+DF1->DF1_ITEAGE+_cProd+_cCompPdg) )
			
			    // ---	Verifica se ja existe e altera
			    DVR->(dbSetOrder(1))
			    If DVR->(dbSeek(xFilial('DVR')+DTP->DTP_FILORI+DTP->DTP_LOTNFC+DTC->DTC_CLIREM+DTC->DTC_LOJREM+DTC->DTC_CLIDES+DTC->DTC_LOJDES+DTC->DTC_SERVIC+DTC->DTC_NUMNFC+DTC->DTC_SERNFC+DTC->DTC_CODPRO+_cCompPdg ) )  
				    // ---	Alteracao do lote
					RecLock("DVR",.f.)
				Else 
					// ---	Inclusao do lote
					RecLock("DVR",.t.)
				EndIf
				
				DVR->DVR_FILIAL :=	xFilial('DVR')
				DVR->DVR_FILORI :=	DTP->DTP_FILORI
				DVR->DVR_LOTNFC :=	DTP->DTP_LOTNFC
				DVR->DVR_CLIREM :=	DTC->DTC_CLIREM
				DVR->DVR_LOJREM :=	DTC->DTC_LOJREM
				DVR->DVR_CLIDES :=	DTC->DTC_CLIDES
				DVR->DVR_LOJDES :=	DTC->DTC_LOJDES
				DVR->DVR_SERVIC :=	DTC->DTC_SERVIC
				DVR->DVR_NUMNFC := 	DTC->DTC_NUMNFC
				DVR->DVR_SERNFC := 	DTC->DTC_SERNFC
				DVR->DVR_CODPRO := 	DTC->DTC_CODPRO
				DVR->DVR_CODPAS := 	DF3->DF3_CODPAS
				DVR->DVR_VALOR  := 	DF3->DF3_VALOR
				DVR->( MsUnLock() )

				//	---	Exibe o valor do pedagio
				MsgInfo('Valor do pedágio obtido R$ '+Transform(DVR->DVR_VALOR,'@E 99,999.99'),'Valor de pedagio' ) 

			// ---	Fim se achou DF3
			EndIf
		// ---	Fim se achou DF1		
		EndIf
	// ---	Fim se alteracao ou inclusao		
	EndIf

// ---	Fim se a solicitacao de coleta esta preenchida	
Else

	//	---	
	VINCSOL()    

EndIf     

Return       

      
/*/{Protheus.doc} VINCSOL
Função responsável por vincular SC mesmo apos viagem encerrada.
@author 	Luiz Alexandre Ferreira
@since 		06/10/2014
@version	1.0
@param 		
@return 	
@example
(examples)
@see (links_or_references)
/*/Static Function VINCSOL()

// ---	Variaveis utilizadas
Local 	_cQuery	:= '' 
Local 	_cAlias	:= '' 
Local	oDlg
Local	oSay, oSay1, oSay2, oSay3, oSay4, oSay5, oSay6
Local	oFont, oFont1
Local	oSButton1, oSButton2
Local	_lRet		:=	.t.
Local	_cFilSC	:=	DTC->DTC_FILORI
Local	_cNumSC	:=	Space(TamSX3('DT6_NUMSOL')[1]) 
Local	_cSerie	:=	'COL' 
Local	_cNumLot	:=	DTC->DTC_LOTNFC
Local	_aAreaDTP	:=	DTP->(GetArea())
Local	_aAreaDTC	:=	DTC->(GetArea())

// ---	Define dialog
oDlg	:= MSDialog():New(0,0,220,550,OemToAnsi('Vincular Solicitação de Coleta'),,,,,CLR_BLACK,CLR_WHITE,,,.t.)

// ---	Define fontes para mensagens
oFont	:= TFont():New('Tahoma',,-16,.T.)
oFont1	:= TFont():New('Tahoma',,-11,.T.)

// --- Apresenta o tSay com a fonte Courier New
oSay	:= TSay():New( 005, 010, {|| OemToAnsi('Vincular Solicitação de Coleta ao lote ')+M->DTC_LOTNFC },oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay:lTransparent:= .F.
oSay1	:= TSay():New( 025, 010, {|| OemToAnsi('Filial ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay1:lTransparent:= .F.
oSay2	:= TSay():New( 045, 010, {|| OemToAnsi('Num. Solicitação ')},oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay2:lTransparent:= .F.
oSay5	:= TSay():New( 065, 010, {|| OemToAnsi('Serie ') },oDlg,, oFont,,,, .T.,CLR_BLUE,CLR_WHITE )
oSay5:lTransparent:= .F.


// 	---	Dados de entrada
@ 023,100 MSGET _cFilSC		SIZE 15, 9 OF oDlg Picture "@!" Pixel When .f. 

@ 043,100 MSGET _cNumSC		SIZE 40, 9 OF oDlg Picture "@!" Pixel Valid( Eval( { |a,b| _cNumSC := StrZero(Val(_cNumSC),TamSx3("DTC_NUMSOL")[1]),.t.} ) )

@ 063,100 MSGET _cSerie		SIZE 15, 9 OF oDlg Picture "@!" Pixel When .f.

// --- Botoes para gravacao dos dados de classificacao do titulo
oSButton1 := SButton():New( 85,10,1, {|| _lRet := .t., oDlg:End() },oDlg,.T.,'Confirma dados',)
oSButton2 := SButton():New( 85,40,2, {|| _lRet := .f., oDlg:End() },oDlg,.T.,'Cancela',)

// --- 	Ativa o objeto
oDlg:Activate()

// ---	Se confirmado transmite interface
If _lRet .and. !Empty(_cNumSC)
	                               
	// ---	Variaveis utilizadas
	_cQuery		:=	"SELECT R_E_C_N_O_,"+ CRLF
	_cQuery		+=	"	DTC_FILORI," 	+ CRLF
	_cQuery		+=	"	DTC_LOTNFC,"	+ CRLF
	_cQuery		+=	"	DTC_NUMSOL"	+ CRLF
	_cQuery		+=	"FROM " + CRLF
	_cQuery		+=	RetSqlName("DTC") + CRLF
	_cQuery		+=	"WHERE " + CRLF
	_cQuery		+=	"DTC_FILORI = '"+_cFilSC+"' AND " + CRLF
	_cQuery		+=	"DTC_LOTNFC = '"+_cNumLot+"' AND " + CRLF
	_cQuery		+=	"DTC_NUMSOL = ' ' AND " + CRLF
	_cQuery		+=	"D_E_L_E_T_ = ' '"
			
	// --- Cria area de trabalho temporaria
	_cAlias		:=	GetNextAlias()
	_cQuery 	:= 	ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias)
			
	// ---	Verifica se houve retorno
	If (_cAlias)->( !  Eof() )
	
		//	---	Grava nos registros
		While (_cAlias)->( ! Eof() ) 
		    
			//	---	Posiciona registro no DTC para gravar o numero do lote.
		    DTC->(dbGoTo(( _cAlias)->R_E_C_N_O_ ) )
		    RecLock('DTC',.f.)
		    DTC->DTC_NUMSOL	:= _cNumSC
		    DTC->(msUnLock())
		      
			//	---	Proximo
			(_cAlias)->(dbSkip())
			
		EndDo 

    EndIf
    
    //	---	Fecha area de trabalho
    (_cAlias)->(dbCloseArea())
    
EndIf

//	---	Restaura area
RestArea(_aAreaDTP)
RestArea(_aAreaDTC)

Return
