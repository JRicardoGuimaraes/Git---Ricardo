#include 'protheus.ch'
#include "topconn.ch"

/*
Programa		: AtuMoedas
Funcao			: Função Usuario - AtuMoedas
Data			: 17/10/2016
Autor			: André Costa
Descricao		: Função de controle
Uso				: Atualização das Moedas
Sintaxe		: AtuMoedas()
Retorno		:
*/

User Function AtuMoedas						// u_AtuMoedas()
	Local aArea		:= GetArea()
	Local cRpcEmp		:= '01'
	Local cRpcFil		:= '01'
	Local cEnvMod		:= '06'
	Local cFunName	:= FunName()
	Local aTables		:= {"SM2"}


	If Select("SX2") # 0

		Processa( { || AtuMoedas() } , "Atualizando Moedas do Sistema. Aguarde..." )

	Else

		RpcSetType( 3 )

		RpcSetEnv( cRpcEmp,cRpcFil,/*cEnvUser*/,/*cEnvPass*/,cEnvMod,cFunName,aTables,/*lShowFinal*/,/*lAbend*/,/*lOpenSX*/,/*lConnect*/ )

		Conout( "Inicio da Atualizacao das Moedas." + Time() )

		AtuMoedas()

		Conout( "Final da Atualizacao das Moedas. " + Time() )

		RpcClearEnv()

	EndIf

	RestArea( aArea )

Return

/*
Programa		: AtuMoedas
Funcao			: Função Estatica - AtuMoedas
Data			: 17/10/2016
Autor			: André Costa
Descricao		: Função de Atualização
Uso				: Faz a atualização das moedas do sistema pelos codigos das moedas no parametro
Sintaxe		: AtuMoedas()
Retorno		:
*/


Static Function AtuMoedas
	Local aArea		:= GetArea()
	Local aLinha
	Local cTexto
	Local aMoedas
	Local nValIATA	:= 0
	Local Y

	Begin Sequence

		AjustaSX6()

		aMoedas	:= StrTokArr( GetMv( "MV_XBANCEN" ) , "|" )

		dDataRef := Date()

		If cValToChar( Dow( dDataRef ) ) $ '1|7'
			Break
		EndIf

		cTexto := HttpGet('http://www4.bcb.gov.br/Download/fechamento/' + DtoS( dDataRef ) + '.csv')

		If AT( "404 - " , cTexto ) # 0
			Break
		EndIf

		nQtdeLinha := MlCount( cTexto )

		DbSelectArea("SM2")
		SM2->( DbSetorder(1) )

		SM2->( DbGoBottom() )

		If SM2->M2_DATA == dDataRef
			DbSkip(-1)
		EndIf

		nValIATA := SM2->M2_MOEDA2

		For Y := 1 To nQtdeLinha

			aLinha := { StrTokArr( MemoLine( cTexto ,, Y ) , ";" ) }

			nPos := aScan( aMoedas , { |A| SubStr(A,2) == aLinha[1][2] } )

			If nPos == 0
				Loop
			EndIf

			If SM2->( DbSeek( DtoS( dDataRef ) ) )
				Reclock('SM2' , .F. )
				SM2->M2_MOEDA6	:= nValIATA
			Else
				Reclock('SM2' , .T. )
					SM2->M2_DATA		:= dDataRef
					SM2->M2_INFORM	:= "S"
					SM2->M2_MOEDA6	:= nValIATA
			EndIf

			&("SM2->M2_MOEDA" + cValToChar(nPos) ) := Val(StrTran( aLinha[1][6],",","."))

			SM2->( MsUnlock() )

			SM2->( DbCloseArea() )

		Next Y

	End Sequence

	RestArea( aArea )

Return



/*
Programa		: AtuMoedas
Funcao			: Função Estatica - AjustaSX6
Data			: 11/10/2016
Autor			: André Costa
Descricao		: Função de Apoio
Uso				: Ajusta os Parametros da Rotina de Atualização de Moedas
Sintaxe		: AjustaSX6()
Retorno		: Conteudo do Parametro
*/


Static Function AjustaSX6
	Local aArea := GetArea()

	DbSelectArea("SX6")
	SX6->( DbSetOrder(1) )

	If ( !MsSeek( Space( FWSizeFilial() ) + "MV_XBANCEN" , .F. ) )
		Conout('Parametro MV_XBANCEN Criado')
		RecLock( "SX6",.T. )
			SX6->X6_VAR     := "MV_XBANCEN"
			SX6->X6_TIPO    := "C"
			SX6->X6_CONTEUD := "0000|2220|0000|4540|5978"
			SX6->X6_CONTSPA := "REAL|USD|UFIR|GRP|EUR"
			SX6->X6_CONTENG := ""

			SX6->X6_DESCRIC := "Codigo Internacional das Moedas a serem atualizadas."
			SX6->X6_DESC1   := ""
			SX6->X6_DSCSPA  := "Codigo Internacional das Moedas a serem atualizadas."
			SX6->X6_DSCSPA1 := ""
			SX6->X6_DSCENG  := "Codigo Internacional das Moedas a serem atualizadas."
			SX6->X6_DSCENG1 := ""
		MsUnLock()
	EndIf

	RestArea(aArea)

Return



