/***************************************************************************
* Programa........: VLDPSA()                                               *
* Autor...........: Marcelo Aguiar Pimentel                                *
* Data............: 15/03/2007                                             * 
* Descricao.......: Faz críticas quando o cliente e Peugeot na Inclusao e  *
*                   Alteracao do Pedido de venda e Contas a Receber        *
*                                                                          *
****************************************************************************
* Modificado por..:                                                        *
* Data............:                                                        *
* Motivo..........:                                                        *
*                                                                          *
***************************************************************************/

*------------------------*
USER FUNCTION MT100TOK
*------------------------*
Local cNat, lRet := .T.
cNat := MaFisRet(,"NF_NATUREZA")

If Empty(cNat)
	Aviso("ATENÇÃO","Favor informar o Natureza do documento de entrada.",{"Ok"})
	lRet := .F.
EndIf

Return lRet