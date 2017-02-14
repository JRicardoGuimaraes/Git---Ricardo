#INCLUDE "Protheus.CH"


/*
Programa	: FIRSTNFSE
Funcao		: PE FIRSTNFSE
Data		: 16/01/2017
Autor		: André Costa
Descricao	: Este ponto de entrada tem a finalidade de executar a manipulação do array aRotina utilizado
				pelo menu da Nota Fiscal de Serviço Eletrônica.
Chamada	: FISA022
*/

User Function FIRSTNFSE

	Local aArea := GetArea()

	aadd( aRotina , { "Impressao NFS-e"  ,"StaticCall( FIRSTNFSE , fLnkNFSe )" , 0 , 10 } )

	RestArea( aArea )

Return( aRotina )

/*
Programa	: FIRSTNFSE
Funcao		: fLnkNFSe
Data		: 16/01/2017
Autor		: André Costa
Descricao	: Faz a impressao via Link do Internet Explore da NFSe
Chamada	: Via Menu - StaticCall( FIRSTNFSE , fLnkNFSe )
*/


Static Function fLnkNFSe
	Local aArea		:= GetArea()

	Local xMVNFSELNK	:= AllTrim( GetMV("MV_NFSELNK") )

	Begin Sequence

		If Empty( AllTrim( xMVNFSELNK ) )
			MsgAlert("Endereco para consulta NFS-e desta Filial nao configurado no sistema!")
			Break
		EndIf

		If Empty( AllTrim( SF2->F2_CODNFE ) )
			MsgAlert("Nota ainda nao autorizada. Selecione uma nota com codigo de verificacao.")
			Break
		EndIf

		xMVNFSELNK := StrTran( xMVNFSELNK , "xF2NFELETR"	, AllTrim(SF2->F2_NFELETR	)	)
		xMVNFSELNK := StrTran( xMVNFSELNK , "xM0INSCM"	, AllTrim(SM0->M0_INSCM		)	)
		xMVNFSELNK := StrTran( xMVNFSELNK , "xF2CODNFE"	, StrTran( AllTrim(SF2->F2_CODNFE), "-","" )	)

		ShellExecute( "Open", "iexplore.exe", xMVNFSELNK, "C:\", 1 )

		MsgAlert("Nota localizada! Por favor, verifique a janela do I.E. que foi aberta.")

	End Sequence

RestArea(aArea)

Return
