#INCLUDE "PROTHEUS.CH"

/*
+-----------------------------------------------------------------------------+
|Programa  : GEFM070   | Autor : J Ricardo Guimarães | Data :  22/09/09       |
|-----------------------------------------------------------------------------+
| Desc.    : Rotina para alterar os parâmetros de Fechamento de movimentação  |
|          : dos módulos Financeiro, Faturamento, Compras e Fiscal, que traba-|
|          : rá junto com o calendário Contábil                               |
|-----------------------------------------------------------------------------|
| Uso      : Fechamento - Contabilidade                                       |
+-----------------------------------------------------------------------------+
*/

User Function GEFM070()
// Variaveis Locais da Funcao
Local cdDataFin	 := GETMV("MV_DATAFIN")
Local cdDataFis	 := GETMV("MV_DATAFIS")
Local cdULMES	 := GETMV("MV_ULMES")
Local odDataFin
Local odDataFis
Local odULMES

// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.                        
Private INCLUI := .F.                        
Private ALTERA := .F.                        
Private DELETA := .F.                        

DEFINE MSDIALOG _oDlg TITLE "Fechamento" FROM C(178),C(177) TO C(379),C(541) PIXEL

	// Cria as Groups do Sistema
	@ C(000),C(001) TO C(034),C(183) LABEL "" PIXEL OF _oDlg
	@ C(033),C(001) TO C(083),C(183) LABEL "" PIXEL OF _oDlg

	// Cria Componentes Padroes do Sistema
	@ C(005),C(006) Say "Todas as operações nos Módulos Campras, Faturamento, Financeiro e " Size C(170),C(008) COLOR CLR_RED PIXEL OF _oDlg
	@ C(014),C(008) Say "Fiscal serão impedidos, caso a data do sistema esteja inferior a dos" Size C(159),C(008) COLOR CLR_RED PIXEL OF _oDlg
	@ C(022),C(006) Say " parâmetros abaixo." Size C(048),C(008) COLOR CLR_RED PIXEL OF _oDlg
	@ C(037),C(114) MsGet odDataFin Var cdDataFin Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(039),C(037) Say "Data Fechamento Financeiro :" Size C(073),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(054),C(114) MsGet odDataFis Var cdDataFis Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg     
	@ C(055),C(048) Say "Data Fechamento Fiscal :" Size C(062),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(069),C(114) MsGet odULMES Var cdULMES Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(071),C(006) Say "Data Fechamento Compras e Faturamento :" Size C(105),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(087),C(138) Button "&Ok" Size C(037),C(012) PIXEL OF _oDlg  Action(fConfirma(cdDataFin,cdDataFis,cdULMES))
	

ACTIVATE MSDIALOG _oDlg CENTERED 

Return(.T.)

******************************************************************************
// Função para atualizar os Parâmetros.
Static Function fConfirma(cdDataFin, cdDataFis,cdULMES)
******************************************************************************

PUTMV("MV_DATAFIN",cdDataFin)
PUTMV("MV_DATAFIS",cdDataFis)
PUTMV("MV_ULMES"   ,cdULMES)

Aviso("Informação","Parâmetros de fechamento alterados.",{"Ok"})

_oDlg:End()

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³Tratamento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)                                                                
