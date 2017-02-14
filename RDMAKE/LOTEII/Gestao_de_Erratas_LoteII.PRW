#INCLUDE "rwmake.ch"

/*
*---------------------------------------------------------------------------*
* Função     |GEFGESTLT2  |Autor | Jesus Oliveira        | Data | 26.01.10  *
*---------------------------------------------------------------------------*
* Descrição  |Tela de Manutençao das erratas geradas pelo Lote II e         *
*            |verificação sobre as informações de envio de cada título.     *
*---------------------------------------------------------------------------*
*/


User Function GEFGESTLT2

Private cCadastro := "Gestão da interface Lote II - Erratas/Sucesso"
//----------------------------------------------------------------------------------
// Monta um aRotina proprio( estrutura: Titulo, Rotina( Ax... são rotinas padrão) )                                            ³
//----------------------------------------------------------------------------------

Private aRotina := { {"Pesquisar" ,"AxPesqui" ,0,1},;
                     {"Legenda","U_GEFLegenda",0,6},; //"Legenda"   
                     {"Reenviar","U_ReenviarDoc",0,7}}
/*
             		 {"Visualizar","AxVisual",0,2},;
                     {"Incluir","AxInclui",0,3},;
             		 {"Alterar","AxAltera",0,4},;
                     {"Excluir","AxDeleta",0,5} }             
*/                                     
/*
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }
*/

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SZP"

dbSelectArea(cString)
dbSetOrder(3)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a funcao MBROWSE. Sintaxe:                                  ³
//³                                                                     ³
//³ mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              ³
//³ Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   ³
//³                        exibido. Para seguir o padrao da AXCADASTRO  ³
//³                        use sempre 6,1,22,75 (o que nao impede de    ³
//³                        criar o browse no lugar desejado da tela).   ³
//³                        Obs.: Na versao Windows, o browse sera exibi-³
//³                        do sempre na janela ativa. Caso nenhuma este-³
//³                        ja ativa no momento, o browse sera exibido na³
//³                        janela do proprio SIGAADV.                   ³
//³ Alias                - Alias do arquivo a ser "Browseado".          ³
//³ aCampos              - Array multidimensional com os campos a serem ³
//³                        exibidos no browse. Se nao informado, os cam-³
//³                        pos serao obtidos do dicionario de dados.    ³
//³                        E util para o uso com arquivos de trabalho.  ³
//³                        Segue o padrao:                              ³
//³                        aCampos := { {<CAMPO>,<DESCRICAO>},;         ³
//³                                     {<CAMPO>,<DESCRICAO>},;         ³
//³                                     . . .                           ³
//³                                     {<CAMPO>,<DESCRICAO>} }         ³
//³                        Como por exemplo:                            ³
//³                        aCampos := { {"TRB_DATA","Data  "},;         ³
//³                                     {"TRB_COD" ,"Codigo"} }         ³
//³ cCampo               - Nome de um campo (entre aspas) que sera usado³
//³                        como "flag". Se o campo estiver vazio, o re- ³
//³                        gistro ficara de uma cor no browse, senao fi-³
//³                        cara de outra cor.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea(cString)

mBrowse( 6,1,22,75,cString)
//mBrowse( 6,1,22,75,cString,,,,,,U_GEFLegenda("SZP"))

Return

USER Function GEFLegenda(cAlias, nReg)

Local aLegenda := {{"BR_VERDE"    , "Título Integrado"  },;	
			       {"BR_VERMELHO" , "Título com Errata" } }

Local uRetorno := .T.

uRetorno := {}
Aadd(uRetorno, { 'ZP_ERRATA =  ""', aLegenda[1][1] } )
Aadd(uRetorno, { 'ZP_ERRATA <> ""', aLegenda[2][1] } )

If .NOT. nReg = Nil
	BrwLegenda("Gestão de Erratas - Lote II", "Legenda", aLegenda)
EndIf	

Return uRetorno 

//Função para retirar o Flag de envio do Lote II na tabela SE1
User Function ReenviarDoc()
	if !MsgYesNo("Deseja realmente reenviar o título '"+Trim(SZP->ZP_DOC)+"' da filial '"+SZP->ZP_FILIAL+"' na próxima interface?","Atencao!")
	  return
	endif 
	
	//Retiro o FLAG da SE1
	dbSelectArea("SE1")
	dbSetOrder(1) // Chave
	If !dbSeek(SZP->ZP_FILIAL+SZP->ZP_PREFIXO+Trim(SZP->ZP_DOC))
  	MsgAlert("O título - "+Trim(SZP->ZP_DOC)+" não foi localizado na tabela SE1!", "Atenção!")
	Else
		RecLock("SE1",.F.)
    	SE1->E1_FLGLT2 := "" 
		MsUnLock()
	EndIf
	DbSelectArea("SE1")  //; dbCloseArea()
  //Retiro o número do Lote da SZP
	dbSelectArea("SZP")
	dbSetOrder(3) // Chave
	If !dbSeek(SZP->ZP_FILIAL+SZP->ZP_DOC+SZP->ZP_PREFIXO)
  	MsgAlert("O título - "+Trim(SZP->ZP_DOC)+" não foi localizado na tabela SZP!", "Atenção!")
  //Caso DOC já exista, atualizo o campo ERRATA
	Else
		RecLock("SZP",.F.)
    	SZP->ZP_LOTE := "" //Número do Lote sendo gerado
     	SZP->ZP_DATA := CTOD("  /  /  ") //Data do servidor
	  MsUnLock()
	EndIf
	DbSelectArea("SZP")  //; dbCloseArea()

 
	MsgInfo("Operação realizada com sucesso!", "Informação")
Return
