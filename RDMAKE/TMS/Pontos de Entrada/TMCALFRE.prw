#include "PROTHEUS.ch"
#include "RWMAKE.ch"
#INCLUDE "TBICONN.CH"

Static aCompFre :={}
Static nQtdNf	:=0
Static _cLote	:=""

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMCALFRE ³ Autor ³ Analista IP           ³ Data ³        	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Alterar o valor do calculo do frete                        	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TMCALFRE()

Local nCnt      := 0
Local aRet      := ParamIXB[01]
Local nPeso     := ParamIXB[04]   // Peso CTRC
Local nValMer   := ParamIXB[03]   // Valor Mercadoria CTRC
Local nQtdVol   := ParamIXB[02]   // QTD Volumes ctrc
Local nQtdUni   := ParamIXB[13]
Local cLotNfc   := ParamIXB[29]
Local aNfCTRC   := ParamIXB[28]
Local _cCliDev  := IIF(!Empty(ParamIXB[18]),ParamIXB[18],ParamIXB[30])
Local _cLojDev  := IIF(!Empty(ParamIXB[19]),ParamIXB[19],ParamIXB[31])
Local _cCGCDev  := ""
Local nQtdeDoc  := Posicione('DTP',1,XFILIAL('DTP')+cLotNfc,'DTP_XNRDOC')
Local aTmCalFr  := {}
Local cAliasQry := ''
Local cAliasQry2:= ''
Local aAreaAtu  := GetArea()
Local nVlComp   := 0
Local cSerNeg   := ParamIXB[23] //-- Codigo servico negociado
Local aRet2     := {}
Local cTipServic:= ""
Local _lCNH     :=  .f.

_cCGCDev  := GetAdvFVal('SA1','A1_CGC',xFilial('SA1')+_cCliDev+_cLojDev,1,'')
_lCNH     := IIF(Empty(_cCGCDev), .F., LEFT(_cCGCDev,8) $ GETMV("ES_CGCDEV"))

// Código do PE
// aTmCalFr:=ExecBlock('TMCALFRE',.F.,.F.,{aRet,nQtdVol,nValMer,nPeso,nPesoM3,nMetro3,nSeguro,nQtdDco,nDiaSem,nKm,nPerNoi,nQtdEnt,nQtdUni,nValDpc,nDocSImp,nDocCImp,nDiaFimSem,cCodCli,cLojCli,cOriAux,cDesAux,cCodPro,cServic,cTabFre,cTipTab,cSeqTab,nDiaArm,aNfCTRC})
//-- Parametros passados para o ponto de entrada
		//-- [01]			= Vetor com a composicao do frete
		//-- [02 ate 17]	= Base de calculo
		//-- [18]			= Codigo do cliente devedor
		//-- [19]			= Loja do cliente devedor
		//-- [20]			= Codigo da regiao de origem
		//-- [21]			= Codigo da regiao de destino
		//-- [22]			= Codigo do produto
		//-- [23]			= Codigo do servico de negociacao
		//-- [24]			= Tabela de Frete
		//-- [25]			= Tipo da Tabela de Frete
		//-- [26]			= Sequencia da Tabela de Frete
		//-- [27]			= Dias de Armazenagem
		//-- [28]         = Notas Fiscais (aNfCTRC)

// [01] Vetor com a composicao do frete
	//-- aRet[01] = Descricao do componente
		//-- aRet[02] = Valor do componente
		//-- aRet[03] = Codigo do componente
		//-- aRet[04] = Item SD2. Atualizado pelas funcoes que geram o SD2
		//-- aRet[05] = Na cotacao eh gravado o valor do imposto do componente
		//-- aRet[06] = Total do componente ( valor + imposto )
		//-- aRet[07] = Codigo da regiao origem
		//-- aRet[08] = Codigo da regiao destino
		//-- aRet[09] = Tabela de Frete
		//-- aRet[10] = Tipo da Tabela de Frete
		//-- aRet[11] = Sequencia da Tabela de Frete
		//-- aRet[12] = Forca a linha totalizadora para a ultima linha
		//-- aRet[13] = Desconto dado ao valor do componente
		//-- aRet[14] = Acrescimo dado ao valor do componente
		//-- aRet[15] = Indica se o componente foi calculado com o valor minimo. "1"= Sim, "2"= Nao
		// Aadd( aRet, { AllTrim(DT3->DT3_DESCRI), 0, DT3->DT3_CODPAS, '', 0, 0, Space(Len(cCdrOri)), Space(Len(cCdrDes)), '', '', '','00', 0, 0 , Iif(lCalMin, StrZero(2,Len(DT8->DT8_CALMIN)),"2") } )		

//Public _nTotFret := 0

//-- Formato do vetor aRet
//-- aRet[01] = Descricao do componente
//-- aRet[02] = Valor do componente
//-- aRet[03] = Codigo do componente
//-- aRet[04] = Item SD2. Atualizado pelas funcoes que geram o SD2
//-- aRet[05] = Na cotacao eh gravado o valor do imposto do componente
//-- aRet[06] = Total do componente ( valor + imposto )
//-- aRet[07] = Codigo da regiao origem
//-- aRet[08] = Codigo da regiao destino
//-- aRet[09] = Tabela de Frete
//-- aRet[10] = Tipo da Tabela de Frete
//-- aRet[11] = Sequencia da Tabela de Frete
//-- aRet[12] = Forca a linha totalizadora para a ultima linha
//-- aRet[13] = Desconto dado ao valor do componente
//-- aRet[14] = Acrescimo dado ao valor do componente
//-- aRet[15] = Indica se o componente foi calculado com o valor minimo. "1"= Sim, "2"= Nao

If ( 'TMSA040'$FunName() .or. 'TMSA500'$FunName()) // quando cotação de frete e ctrc`s gerados pela rotina de manutencao não executa as customizações.
	Return aRet2
EndIf

//Verifica o total do frete, esse valor sera utilizado no ponto de entrada TM200FIM
/*
For nCnt := 1 To Len(aRet)
_nTotFret+= aRet[nCnt,2]
Next nCnt
MsgAlert(Str(_nTotFret))
*/
//Se o numero  do lote mudou zero as variaveis
If _cLote<>cLotNfc
	_cLote   :=cLotNfc
	aCompFre :={}
	nQtdNf	 :=0
EndIf

Dbselectarea("DC5")
Dbsetorder(1)
If Dbseek(xFilial("DC5")+cSerNeg) // Verifica se o Servico tem Rateio
	If DC5->DC5_Tiprat="1"              // Fara o Rateio do Lote pelo peso das mercadorias.
		cTipServic:="1"                  //Rateio por peso para um lote com remetentes ou destinatarios diferentes
	ElseIf DC5->DC5_Tiprat="2"          // Fara o Rateio do Lote pelo valor das mercadorias.
		cTipServic:="2"                  //Rateio por valor para um lote com remetentes ou destinatarios diferentes
	ElseIf DC5->DC5_Tiprat="3"          // Fara o Rateio do Lote pela quantidade de volumes.
		cTipServic:="3"                  //Rateio pela quantidade de volumes para um lote com remetentes ou destinatarios diferentes
	ElseIf DC5->DC5_Tiprat="4"          // Fara o Rateio do Lote pela quantidade de DOCUMENTOS.
		cTipServic:="4"                  //Rateio pela quantidade de DOCUMENTOS para um lote com remetentes ou destinatarios diferentes
	ElseIf DC5->DC5_Tiprat="5"          // Fara o Rateio do Lote pela quantidade de unitizadores.
		cTipServic:="5"                  //Rateio pela quantidade de unitizadores para um lote com remetentes ou destinatarios diferentes
	Else
		cTipServic:="0"
	Endif
Else
	cTipServic:="0"
Endif

If cTipServic=="4" //Rateio por documento  incluido pela analista Katia no dia 19/04/10
	nQtdLot:=Posicione('DTP',2, xFilial('DTP')+cFilAnt+cLotNfc, 'DTP_QTDLOT')//Busca quantidade do lote
	aEval(aNfCTRC,{|e, nX| nQtdNf++})
	If nQtdNf<nQtdLot

		For nCnt := 1 To Len(aRet)
			nVlComp := aRet[nCnt,2] / nQtdeDoc
			If nVlComp > 0
				Aadd(aTmCalFr,{ aRet[nCnt,3], round(nVlComp,2) })
				Aadd(aCompFre,{ aRet[nCnt,3], round(nVlComp,2) })
			EndIf
		Next nCnt
		aRet2:= aTmCalFr
		
	Else
		
		For nCnt := 1 To Len(aRet)
			nTotFre:=0
			aEval(aCompFre,{|e, nX| If(e[1]=aRet[nCnt,3],nTotFre+=e[2],)})
			Aadd(aTmCalFr,{ aRet[nCnt,3], aRet[nCnt,2]-nTotFre })
		Next nCnt
		aRet2:= aTmCalFr
	EndIf

ElseIf cTipServic=="2" .AND. _lCNH // Rateio pelo valor da mercadoria (CNH)
	// Por: Ricardo Guimarães - Em: 11/01/2016 - Objetivo: Atender exigências da CNH-OTM
	
//	nQtdLot:=Posicione('DTP',2, xFilial('DTP')+cFilAnt+cLotNfc, 'DTP_QTDLOT') //Busca quantidade do lote
//	aEval(aNfCTRC,{|e, nX| nQtdNf++})
// teste
//	If nQtdNf<nQtdLot
		cAliasQry := GetNextAlias()
		cQuery := "SELECT SUM(DTC_VALOR)  DTC_VALOR , SUM(DTC_PESO)   DTC_PESO  , "
		cQuery += "       SUM(DTC_QTDVOL) DTC_QTDVOL, "
		cQuery += "       SUM(DTC_QTDUNI) DTC_QTDUNI, COUNT(DTC_NUMNFC) QtdNF   "
		cQuery += "  FROM "+RetSqlName('DTC')
		cQuery += " WHERE DTC_FILIAL = '"+xFilial('DTC')+"'"
		cQuery += "   AND DTC_FILORI = '"+cFilAnt+"'"
		cQuery += "   AND DTC_LOTNFC = '"+cLotNfc+"'"
		cQuery += "   AND D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
//		TcSetField(cAliasQry,"DTC_VALOR" ,"N",TamSX3("DTC_VALOR" )[1],TamSX3("DTC_VALOR" )[2])
		TcSetField(cAliasQry,"DTC_VALOR" ,"N",TamSX3("DTC_VALOR" )[1],05)		
		TcSetField(cAliasQry,"DTC_PESO"  ,"N",TamSX3("DTC_PESO"  )[1],TamSX3("DTC_PESO"  )[2])
		TcSetField(cAliasQry,"DTC_QTDVOL","N",TamSX3("DTC_QTDVOL")[1],TamSX3("DTC_QTDVOL")[2])
		TcSetField(cAliasQry,"DTC_QTDUNI","N",TamSX3("DTC_QTDUNI")[1],TamSX3("DTC_METRO3")[2])
		If (cAliasQry)->(!Eof())
			DT3->(dbSetOrder(1))
			For nCnt := 1 To Len(aRet)
				DT3->(dbSeek(xFilial('DT3')+aRet[nCnt,3]))
				nVlComp := 0
				If DT3->DT3_TIPFAI == '08' .OR.  DT3->DT3_TIPFAI == '07' //-- 08=Por Km ; 07=Valor Informado(Pedágio)
					nVlComp := ( nValMer / (cAliasQry)->DTC_VALOR ) * aRet[nCnt,2] 
				EndIf
				If nVlComp > 0
					Aadd(aTmCalFr,{ aRet[nCnt,3], round(nVlComp,2) })
					Aadd(aCompFre,{ aRet[nCnt,3], round(nVlComp,2) })
				EndIf
				
			Next nCnt
		EndIf
		aRet2:= aTmCalFr
		(cAliasQry)->(dbCloseArea())
//	EndIf		 

ElseIf cTipServic<>"0" .AND. !_lCNH
	
	nQtdLot:=Posicione('DTP',2, xFilial('DTP')+cFilAnt+cLotNfc, 'DTP_QTDLOT')//Busca quantidade do lote
	aEval(aNfCTRC,{|e, nX| nQtdNf++})
	
	If nQtdNf<nQtdLot
		cAliasQry := GetNextAlias()
		cQuery := "SELECT SUM(DTC_VALOR)  DTC_VALOR , SUM(DTC_PESO)   DTC_PESO  , "
		cQuery += "       SUM(DTC_QTDVOL) DTC_QTDVOL, "
		cQuery += "       SUM(DTC_QTDUNI) DTC_QTDUNI, COUNT(DTC_NUMNFC) QtdNF   "
		cQuery += "  FROM "+RetSqlName('DTC')
		cQuery += " WHERE DTC_FILIAL = '"+xFilial('DTC')+"'"
		cQuery += "   AND DTC_FILORI = '"+cFilAnt+"'"
		cQuery += "   AND DTC_LOTNFC = '"+cLotNfc+"'"
		cQuery += "   AND D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
		TcSetField(cAliasQry,"DTC_VALOR" ,"N",TamSX3("DTC_VALOR" )[1],TamSX3("DTC_VALOR" )[2])
		TcSetField(cAliasQry,"DTC_PESO"  ,"N",TamSX3("DTC_PESO"  )[1],TamSX3("DTC_PESO"  )[2])
		TcSetField(cAliasQry,"DTC_QTDVOL","N",TamSX3("DTC_QTDVOL")[1],TamSX3("DTC_QTDVOL")[2])
		TcSetField(cAliasQry,"DTC_QTDUNI","N",TamSX3("DTC_QTDUNI")[1],TamSX3("DTC_METRO3")[2])
		If (cAliasQry)->(!Eof())
			DT3->(dbSetOrder(1))
			For nCnt := 1 To Len(aRet)
				DT3->(dbSeek(xFilial('DT3')+aRet[nCnt,3]))
				nVlComp := 0
				If DT3->DT3_TIPFAI == '01' //-- Peso Mercadoria
					nVlComp := (aRet[nCnt,2] / (cAliasQry)->DTC_PESO)   * nPeso
				ElseIf DT3->DT3_TIPFAI == '02' //-- Valor Mercadoria
					nVlComp := (aRet[nCnt,2] / (cAliasQry)->DTC_VALOR)  * nValMer
				ElseIf DT3->DT3_TIPFAI == '03' //-- Qtde. de volumes
					nVlComp := (aRet[nCnt,2] / (cAliasQry)->DTC_QTDVOL) * nQtdVol
				ElseIf DT3->DT3_TIPFAI == '05' //-- Qtde.Unitizador
					nVlComp := (aRet[nCnt,2] / (cAliasQry)->DTC_QTDUNI) * nQtdUni
				EndIf
				If nVlComp > 0
					Aadd(aTmCalFr,{ aRet[nCnt,3], round(nVlComp,2) })
					Aadd(aCompFre,{ aRet[nCnt,3], round(nVlComp,2) })
				EndIf
				
			Next nCnt
		EndIf
		aRet2:= aTmCalFr
		(cAliasQry)->(dbCloseArea())
	Else
		
		For nCnt := 1 To Len(aRet)
			nTotFre:=0
			aEval(aCompFre,{|e, nX| If(e[1]=aRet[nCnt,3],nTotFre+=e[2],)})
			Aadd(aTmCalFr,{ aRet[nCnt,3], aRet[nCnt,2]-nTotFre })			
		Next nCnt
		aRet2:= aTmCalFr		
	EndIf
EndIf

RestArea(aAreaAtu)

Return aRet2