#Include 'rwmake.ch'

/*/{Protheus.doc} GEFA009
Atualização de protocolo por pedido
u_GEFA009()

@author Michael Becker
@since 14/11/2016
@see michael.becker@ideiastecnologia.com.br
/*/
User Function GEFA009()
	Local oPedido
	Local oAs
	Local oViagem
	Local oProtocolo
	Private oDLG
	Private cPedido := Space(TAMSX3("ZA6_PEDCLI")[1])
	Private cAs 	  := Space(TAMSX3("ZA6_AS")[1])
	Private cViagem := Space(TAMSX3("ZA6_VIAGEM")[1])
	Private cProtoc := Space(TAMSX3("ZA6_PROTOC")[1])


	@ 173,242 To 365,546 Dialog oDLG Title OemToAnsi("Atualização de protocolo por pedido")
	@ 003,003 Say OemToAnsi("Pedido:")		Size 50,8
	@ 019,003 Say OemToAnsi("Viagem:")		Size 50,8
	@ 035,003 Say OemToAnsi("As:")			Size 50,8
	@ 051,003 Say OemToAnsi("Protocolo:") 	Size 50,8

	@ 003,040 Get cPedido 	Picture "@!" Size 100,10 Valid validGets(.F.) Object oPedido
	//Pesquisa sera somente pelo Pedido
	@ 019,040 Get cViagem 	Picture "@!" Size 100,10 Valid When .F. Object oViagem
	@ 035,040 Get cAs 		Picture "@!" Size 100,10 Valid When .F. Object oAs
	@ 051,040 Get cProtoc	Picture "@!" Size 100,10 Object oProtocolo

	@ 070,023 Button OemToAnsi("Atualizar")   Size 30,12 Action UpdProtoc()
	@ 070,078 Button OemToAnsi("Fechar") 		Size 50,12 Action Close( oDLG )

	Activate Dialog oDLG CENTERED

Return .T.

/*/{Protheus.doc} GEFA009
Função que realiza o update

Foi realizado via Updade pois foi passado que a chave são estes 3 campos apesar de não existir indice desta forma.

@author Michael Becker
@since 14/11/2016
@see michael.becker@ideiastecnologia.com.br
/*/
Static Function UpdProtoc()
	Local cUpd
	If !validGets(.T.)
		Alert("Nenhum registro foi localizado!")
	ElseIf MsgYesNo("Confirma a atualização do protocolo?","Atenção")
		cUpd := "UPDATE "+RetSqlName("ZA6") +" SET ZA6_PROTOC = '"+cProtoc +"' "
		cUpd += " WHERE ZA6_AS = '"+cAs+"'"
		cUpd += "   AND ZA6_PEDCLI = '"+cPedido+"'"
		cUpd += "   AND ZA6_VIAGEM = '"+cViagem+"'"
		cUpd += "   AND D_E_L_E_T_ = ' '"

		TcSqlExec( cUpd )
		TcSqlExec( "COMMIT" )
		Aviso("Protocolo atualizado","Atualizado!",{"Ok"})

		//Limpa Variaveis
		cPedido := Space(TAMSX3("ZA6_PEDCLI")[1])
		cAs 	 := Space(TAMSX3("ZA6_AS")[1])
		cViagem := Space(TAMSX3("ZA6_VIAGEM")[1])
		cProtoc := Space(TAMSX3("ZA6_PROTOC")[1])

	EndIf

Return .T.


/*/{Protheus.doc} GEFA009
Valida os campos recebidos

@author Michael Becker
@since 14/11/2016
@see michael.becker@ideiastecnologia.com.br
/*/
Static Function validGets(lAtuProtoc)
	Local lRet := .T.
	Local cAliasQry := ""

	cAliasQry  := GetNextAlias()

	If !Empty(cAs) .Or. !Empty(cPedido) .Or. !Empty(cViagem)
		lRet := .F.
		cQuery	:= "SELECT ZA6_PROTOC,ZA6_AS,ZA6_PEDCLI,ZA6_VIAGEM FROM "+RetSqlName("ZA6") +" WHERE"
		cQuery += " D_E_L_E_T_ = ' '"
		//Filial, a principio, desconsiderar.
		If lAtuProtoc
			If !Empty(cAs)
				cQuery += " AND ZA6_AS = '"+cAs+"'"
			EndIf
			If !Empty(cViagem)
				cQuery += " AND ZA6_VIAGEM = '"+cViagem+"'"
			EndIf
		EndIf

		If !Empty(cPedido)
			cQuery += " AND ZA6_PEDCLI = '"+cPedido+"'"
		EndIf
		cQuery := ChangeQuery( cQuery )

		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasQry, .F., .T. )

		While !( cAliasQRY )->( Eof())
			cPedido  	:= ( cAliasQRY )->ZA6_PEDCLI
			cAs 	 	:= ( cAliasQRY )->ZA6_AS
			cViagem	:= ( cAliasQRY )->ZA6_VIAGEM
			If Empty(cProtoc) .And. !lAtuProtoc //Se usuário digitou não sobrescreve se esta verificando antes de fazer update tb não.
				cProtoc  	:= ( cAliasQRY )->ZA6_PROTOC
			EndIf
			lRet := .T.
			( cAliasQRY )->( dbSkip())
		EndDo
		( cAliasQRY )->( dbCloseArea() )
	EndIf

Return lRet
