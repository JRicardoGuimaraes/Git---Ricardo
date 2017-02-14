#include "PROTHEUS.ch" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMALTBAS ³ Autor ³ Wilson Gouveia        ³ Data ³21.08.2009	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Alterar a base dos componentes                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gefco                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±                                
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TMALTBAS()

Local nPesCob   := ParamIXB[02] // PESO COBRADO
Local cTabFre   := ParamIXB[13]
Local cTipTab   := ParamIXB[14]
Local aAreaAtu  := GetArea()
Local aAreaDVE  := DVE->(GetArea())
Local aTmAltBs  := {}
Local cSeekDVE  := ''
Local aNfCTRC   := ParamIXB[16] 
Local nPesCalc  := 0
Local lComp := .T.
Local cCompRat := GetMv('MV_GEF010',.F.,'') // Componentes de Rateio
//-- Tabelas sofrem tratamento de rateio 
Local cTabRat	 := GetMv('MV_GEF011',.F.,'')       
// tabela de frete praticada                                   
Local cTabPratic:= cTabFre+cTipTab

If  cTabPratic $ cTabRat
	aTmAltBs     := Array(11)
	aTmAltBs[01] := ParamIXB[01]
	aTmAltBs[02] := ParamIXB[02]
	aTmAltBs[03] := ParamIXB[03]
	aTmAltBs[04] := ParamIXB[04]
	aTmAltBs[05] := ParamIXB[05]
	aTmAltBs[06] := ParamIXB[06]
	aTmAltBs[07] := ParamIXB[07]
	aTmAltBs[08] := ParamIXB[08]
	aTmAltBs[09] := ParamIXB[09]
	aTmAltBs[10] := ParamIXB[10]
	aTmAltBs[11] := '' //-- Compomentes que alteraram a base de calculo
	
	DVE->(dbSetOrder(1))
	DVE->(dbSeek(cSeekDVE := xFilial('DVE')+cTabFre+cTipTab))
	While DVE->(!Eof()) .And. DVE->(DVE_FILIAL+DVE_TABFRE+DVE_TIPTAB) == cSeekDVE
		If DVE->DVE_CODPAS $ cCompRat
		   aTmAltBs[11] := DVE->DVE_CODPAS
		   lComp := .T.
		   Exit
		Endif   
      DVE->(dbSkip())                        
	EndDo     
	
	IF lComp 
	   nPesCalc := Int((nPesCob/100))
	   If (nPesCob/100) > nPesCalc
	       nPescalc := (nPesCalc + 1) * 100
	   Endif   
	   aTmAltBs[02] :=  nPesCalc  
	EndIf
EndIf
RestArea(aAreaDVE)
RestArea(aAreaAtu)

Return aTmAltBs