#Include 'Protheus.ch'


/*
Ex:
A tabela 2005 que é composta por frete peso somente, através do ponto de entrada poderíamos acrescentar o ,
componente frete valor na composição de frete de um determinado conhecimento, desde que o componente esteja
cadastrado corretamente na tabela de componentes de frete.
(Vale lembrar que ao tentar acrescentar um componente que não exista, o sistema apenas irá ignorá-lo.)
Lembramos que o cálculo do frete permite ter um preço diferenciado para cada produto na tabela de frete ou ajuste
de frete, por isso, o ponto de entrada será chamado uma vez para cada produto que estiver dentro da nota fiscal
do cliente.

Ex:
O conhecimento contém 1 nota fiscal sendo que a sua estrutura:
contém o produto	000001 – cosméticos
contém o produto	000002 – embalagens
Ao efetuar o cálculo de frete, no exemplo acima, o ponto de entrada será chamado 2
vezes, uma vez para o produto 000001 e uma vez para 000002 pois o sistema permite que sejam aplicados preços
diferenciados para cada produto.

Obs: Caso o conhecimento seja proveniente de uma cotação de frete o ponto de
entrada não será chamado visto que o valor já está pré-fixado.

Obs: Lembramos que pelo fato do ponto de entrada estar sendo chamado em uma transação recomendamos
que não seja utilizado para apresentação de telas para entrada de dados pelo usuário para não haver bloqueios
de registros do sistema para outros usuários.

Exemplo:
Neste exemplo iremos alterar o valor de cada componente indiscriminadamente para R$ 100.
Excluindo somente o componente ‘TF’ que seria o total de todos os outros componentes.
No exemplo, também mostramos como receber todos os parâmetros que são passados ao ponto de entrada para que o
cliente sua própria regra.
*/

User Function TM200QBR()

	Local aFrete := AClone( PARAMIXB[1] )
	Local nQtdVol:= PARAMIXB[2]
	Local nValor := PARAMIXB[3]
	Local nPeso  := PARAMIXB[4]
	Local nPesoM3:= PARAMIXB[5]
	Local nMetro3:= PARAMIXB[6]
	Local nSeguro:= PARAMIXB[7]
	Local nNfCTRC:= PARAMIXB[8]
	Local nQtdUni:= PARAMIXB[9]
	Local nValDpc:= PARAMIXB[10]
	Local cCliDev:= PARAMIXB[11]
	Local cLojDev:= PARAMIXB[12]
	Local cCdrOri:= PARAMIXB[13]
	Local cCdrDes:= PARAMIXB[14]
	Local cCodPro:= PARAMIXB[15]
	Local cServic:= PARAMIXB[16]
	Local cTabFre:= PARAMIXB[17]
	Local cTipTab:= PARAMIXB[18]
	Local cSeqTab:= PARAMIXB[19]
	Local aNfCTRC:= AClone( PARAMIXB[20] )
	Local nCount := 0
	Local aRet   := {}

	For nCount := 1 To Len(aFrete)
		If aFrete[nCount,3] <> 'TF'
			Aadd(aRet,{aFrete[nCount,3],100 })
		EndIf
	Next nCount

Return aRet
