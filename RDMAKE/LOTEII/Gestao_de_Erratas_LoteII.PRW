#INCLUDE "rwmake.ch"

/*
*---------------------------------------------------------------------------*
* Fun��o     |GEFGESTLT2  |Autor | Jesus Oliveira        | Data | 26.01.10  *
*---------------------------------------------------------------------------*
* Descri��o  |Tela de Manuten�ao das erratas geradas pelo Lote II e         *
*            |verifica��o sobre as informa��es de envio de cada t�tulo.     *
*---------------------------------------------------------------------------*
*/


User Function GEFGESTLT2

Private cCadastro := "Gest�o da interface Lote II - Erratas/Sucesso"
//----------------------------------------------------------------------------------
// Monta um aRotina proprio( estrutura: Titulo, Rotina( Ax... s�o rotinas padr�o) )                                            �
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

//���������������������������������������������������������������������Ŀ
//� Executa a funcao MBROWSE. Sintaxe:                                  �
//�                                                                     �
//� mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              �
//� Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   �
//�                        exibido. Para seguir o padrao da AXCADASTRO  �
//�                        use sempre 6,1,22,75 (o que nao impede de    �
//�                        criar o browse no lugar desejado da tela).   �
//�                        Obs.: Na versao Windows, o browse sera exibi-�
//�                        do sempre na janela ativa. Caso nenhuma este-�
//�                        ja ativa no momento, o browse sera exibido na�
//�                        janela do proprio SIGAADV.                   �
//� Alias                - Alias do arquivo a ser "Browseado".          �
//� aCampos              - Array multidimensional com os campos a serem �
//�                        exibidos no browse. Se nao informado, os cam-�
//�                        pos serao obtidos do dicionario de dados.    �
//�                        E util para o uso com arquivos de trabalho.  �
//�                        Segue o padrao:                              �
//�                        aCampos := { {<CAMPO>,<DESCRICAO>},;         �
//�                                     {<CAMPO>,<DESCRICAO>},;         �
//�                                     . . .                           �
//�                                     {<CAMPO>,<DESCRICAO>} }         �
//�                        Como por exemplo:                            �
//�                        aCampos := { {"TRB_DATA","Data  "},;         �
//�                                     {"TRB_COD" ,"Codigo"} }         �
//� cCampo               - Nome de um campo (entre aspas) que sera usado�
//�                        como "flag". Se o campo estiver vazio, o re- �
//�                        gistro ficara de uma cor no browse, senao fi-�
//�                        cara de outra cor.                           �
//�����������������������������������������������������������������������

dbSelectArea(cString)

mBrowse( 6,1,22,75,cString)
//mBrowse( 6,1,22,75,cString,,,,,,U_GEFLegenda("SZP"))

Return

USER Function GEFLegenda(cAlias, nReg)

Local aLegenda := {{"BR_VERDE"    , "T�tulo Integrado"  },;	
			       {"BR_VERMELHO" , "T�tulo com Errata" } }

Local uRetorno := .T.

uRetorno := {}
Aadd(uRetorno, { 'ZP_ERRATA =  ""', aLegenda[1][1] } )
Aadd(uRetorno, { 'ZP_ERRATA <> ""', aLegenda[2][1] } )

If .NOT. nReg = Nil
	BrwLegenda("Gest�o de Erratas - Lote II", "Legenda", aLegenda)
EndIf	

Return uRetorno 

//Fun��o para retirar o Flag de envio do Lote II na tabela SE1
User Function ReenviarDoc()
	if !MsgYesNo("Deseja realmente reenviar o t�tulo '"+Trim(SZP->ZP_DOC)+"' da filial '"+SZP->ZP_FILIAL+"' na pr�xima interface?","Atencao!")
	  return
	endif 
	
	//Retiro o FLAG da SE1
	dbSelectArea("SE1")
	dbSetOrder(1) // Chave
	If !dbSeek(SZP->ZP_FILIAL+SZP->ZP_PREFIXO+Trim(SZP->ZP_DOC))
  	MsgAlert("O t�tulo - "+Trim(SZP->ZP_DOC)+" n�o foi localizado na tabela SE1!", "Aten��o!")
	Else
		RecLock("SE1",.F.)
    	SE1->E1_FLGLT2 := "" 
		MsUnLock()
	EndIf
	DbSelectArea("SE1")  //; dbCloseArea()
  //Retiro o n�mero do Lote da SZP
	dbSelectArea("SZP")
	dbSetOrder(3) // Chave
	If !dbSeek(SZP->ZP_FILIAL+SZP->ZP_DOC+SZP->ZP_PREFIXO)
  	MsgAlert("O t�tulo - "+Trim(SZP->ZP_DOC)+" n�o foi localizado na tabela SZP!", "Aten��o!")
  //Caso DOC j� exista, atualizo o campo ERRATA
	Else
		RecLock("SZP",.F.)
    	SZP->ZP_LOTE := "" //N�mero do Lote sendo gerado
     	SZP->ZP_DATA := CTOD("  /  /  ") //Data do servidor
	  MsUnLock()
	EndIf
	DbSelectArea("SZP")  //; dbCloseArea()

 
	MsgInfo("Opera��o realizada com sucesso!", "Informa��o")
Return
