#Include "Rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TM200QBR  ºAutor  ³Katia Alves Bianchi º Data ³  14/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para efetuar o rateio de frete             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gefco                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TM200QBR()
Local aFrt 		 := AClone(PARAMIXB[1])
Local aRetorno 	 := {}
Local _aArea 	 := GetArea()
Local cComponente:= " "
Local _nValor    := 0
Local _nValorMer := 0
Local _nPesMer 	 := 0
Local _nQtdVol 	 := 0
Local _nQtdUnit  := 0
Local nValMernf  := 0
Local nPesMernf  := 0
Local nQtdVolnf  := 0
Local nQtdUninf  := 0
Local cTipServic := " "
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
//-- [28]         = Notas Fiscais (aNfCTRC)`

//	aFrt[ x, 2 ] = Valor do componente. Tipo numerico.
//	aFrt[ x, 3 ] = Codigo do componente. Tipo caracter.

Dbselectarea("DC5")
Dbsetorder(1)
If Dbseek(xFilial("DC5")+Paramixb[16]) // Verifica se o Servico tem Rateio
	If DC5->DC5_Tiprat="1"              // Fara o Rateio do Lote pelo peso das mercadorias.
		cTipServic:="1"                  //Rateio por peso para um lote com remetentes ou destinatarios diferentes
	ElseIf DC5->DC5_Tiprat="2"          // Fara o Rateio do Lote pelo valor das mercadorias.
		cTipServic:="2"                  //Rateio por valor para um lote com remetentes ou destinatarios diferentes
	ElseIf DC5->DC5_Tiprat="3"          // Fara o Rateio do Lote pela quantidade de volumes.
		cTipServic:="3"                  //Rateio pela quantidade de volumes para um lote com remetentes ou destinatarios diferentes
	ElseIf DC5->DC5_Tiprat="5"          // Fara o Rateio do Lote pela quantidade de unitizadores.
		cTipServic:="5"                  //Rateio pela quantidade de unitizadores para um lote com remetentes ou destinatarios diferentes
	Else
		cTipServic:="0"
	Endif
Else
	cTipServic:="0"
Endif

If cTipServic<>"0"
	DbSelectArea("DTC")
	DbSetOrder(1)
	IF DbSeek(xFilial("DTC")+DTP->DTP_FILORI+DTP->DTP_LOTNFC)
		While xFilial("DTC")=DTC_FILIAL .AND. DTC_FILORI=DTP->DTP_FILORI .AND. DTC_LOTNFC=DTP->DTP_LOTNFC
			If cTipServic='1'
				_nPesMer += DTC->DTC_PESO
			ElseIf cTipServic='2'
				_nValorMer += DTC->DTC_VALOR
			ElseIf cTipServic='3'
				_nQtdVol += DTC->DTC_QTDVOL
			ElseIf cTipServic='5'
				_nQtdUnit += DTC->DTC_QTDUNI
			EndIf
			Dbskip()
		EndDo
	Endif
Endif

nValMernf := Paramixb[3]
nPesMernf := Paramixb[4]
nQtdVolnf := Paramixb[2]
nQtdUninf := Paramixb[9]

For x:=1 to Len(aFrt)
	Dbselectarea("DT3")
	Dbsetorder(1)
	If Dbseek(xFilial("DT3")+aFrt[x,3])
		If cTipServic="1" // Rateio por Peso
			
			cComponente := aFrt[x][3]      // Codigo do Componente
			_nValor     := aFrt[x][2]      // Valor do Frete
			nperc		:= ((nPesMernf/_nPesMer)*100)
			_nValor 	:= (_nValor*nperc)/100
			AAdd(aRetorno,{aFrt[x,3],_nValor})		// Valor do Frete
			
		ElseIf cTipServic="2" //Rateio por valor de mercadoria
			
			cComponente := aFrt[x][3]      // Codigo do Componente
			_nValor     := aFrt[x][2]      // Valor do Frete
			nperc:= (nValMernf/_nValorMer)*100
			_nValor := (_nValor*nperc)/100
			AAdd(aRetorno,{aFrt[x,3],_nValor})		// Valor do Frete
			
		ElseIf cTipServic="3"  //Rateio por quantidade de volumes
			
			cComponente := aFrt[x][3]      // Codigo do Componente
			_nValor     := aFrt[x][2]      // Valor do Frete
			nperc:= (nQtdVolnf/_nQtdVol)*100
			_nValor := (_nValor*nperc)/100
			AAdd(aRetorno,{aFrt[x,3],_nValor})		// Valor do Frete
			
		ElseIf cTipServic="5"  //Rateio por quantidade de unitizadores
			
			cComponente := aFrt[x][3]      // Codigo do Componente
			_nValor     := aFrt[x][2]      // Valor do Frete
			nperc:= (nQtdUninf/_nQtdUnit)*100
			_nValor := (_nValor*nperc)/100
			AAdd(aRetorno,{aFrt[x,3],_nValor})		// Valor do Frete
			
		Endif
	Endif
Next

RestArea(_aArea)

Return(aRetorno)
