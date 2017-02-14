#INCLUDE "rwmake.ch"
/*
*---------------------------------------------------------------------------*
* Fun��o     |GEFM076    | Autor | J Ricardo             | Data | 31.01.12  *
*---------------------------------------------------------------------------*
* Descri��o  |Tela de Manuten�ao dos t�tulos importados dos TXT�s para a    *
*            |tabela intermedi�ria (SZR), e est�o com errata, para serem    *
*            |processados novamente pela rotina autom�tica                  *
*            |                                                              *
*---------------------------------------------------------------------------*
*/
User Function GEFA076()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := "Manuten��o das NFs Importadas do SIPCO para gera��o de CTRC no TMS"
//���������������������������������������������������������������������Ŀ
//� Array (tambem deve ser aRotina sempre) com as definicoes das opcoes �
//� que apareceram disponiveis para o usuario. Segue o padrao:          �
//� aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
//�              . . .                                                  �
//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }                      �
//� Onde: <DESCRICAO> - Descricao da opcao do menu                      �
//�       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas  �
//�                     duplas e pode ser uma das funcoes pre-definidas �
//�                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA �
//�                     e AXDELETA) ou a chamada de um EXECBLOCK.       �
//�                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-�
//�                     clarar uma variavel chamada CDELFUNC contendo   �
//�                     uma expressao logica que define se o usuario po-�
//�                     dera ou nao excluir o registro, por exemplo:    �
//�                     cDelFunc := 'ExecBlock("TESTE")'  ou            �
//�                     cDelFunc := ".T."                               �
//�                     Note que ao se utilizar chamada de EXECBLOCKs,  �
//�                     as aspas simples devem estar SEMPRE por fora da �
//�                     sintaxe.                                        �
//�       <TIPO>      - Identifica o tipo de rotina que sera executada. �
//�                     Por exemplo, 1 identifica que sera uma rotina de�
//�                     pesquisa, portando alteracoes nao podem ser efe-�
//�                     tuadas. 3 indica que a rotina e de inclusao, por�
//�                     tanto, a rotina sera chamada continuamente ao   �
//�                     final do processamento, ate o pressionamento de �
//�                     <ESC>. Geralmente ao se usar uma chamada de     �
//�                     EXECBLOCK, usa-se o tipo 4, de alteracao.       �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� aRotina padrao. Utilizando a declaracao a seguir, a execucao da     �
//� MBROWSE sera identica a da AXCADASTRO:                              �
//�                                                                     �
//� cDelFunc  := ".T."                                                  �
//� aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               �
//�                { "Visualizar"   ,"AxVisual" , 0, 2},;               �
//�                { "Incluir"      ,"AxInclui" , 0, 3},;               �
//�                { "Alterar"      ,"AxAltera" , 0, 4},;               �
//�                { "Excluir"      ,"AxDeleta" , 0, 5} }               �
//�                                                                     �
//�����������������������������������������������������������������������


//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := { {"Pesquisar" ,"AxPesqui" ,0,1} ,;
             		 {"Visualizar","AxVisual",0,2} ,;
             		 {"Alterar"   ,"AxAltera",0,4} ,;
					 {"Legenda"	  ,"U_Gef076Legenda",0,6} } //"Legenda"   

//             		 {"Alterar"   ,"AxAltera",0,4}},;
//             {"Incluir","AxInclui",0,3} ,;
//             {"Excluir","AxDeleta",0,5} }             

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZ8"

dbSelectArea("SZ8")
dbSetOrder(1)

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
mBrowse( 6,1,22,75,cString,,,,,,U_Gef076Legenda("SZ8"))
//mBrowse( 6,1,22,75,cString,,"SZR->ZR_IMPORT")
//mBrowse( 6, 1,22,75,"SE1" ,,,,,,Fa040Legenda("SE1"))

Return

*------------------------*
USER Function fAltGEF75()
*------------------------*
If !Empty(SZ8->Z8_NUMCTRC)
	Alert("Registro j� importado para os m�dulos do Microsiga.")
Else
//	AXALTERA()
	// ExecBlock("AXALTERA",.F.)	
EndIf
Return

*-------------------------------------------*
USER Function Gef076Legenda(cAlias, nReg)
*-------------------------------------------*
Local aLegenda := { 	{"BR_AMARELO"    , "Lote Gerado s/CTRC" },;
						{"BR_AZUL"       , "Lote Gerado c/CTRC" },;
						{"BR_VERDE"      , "Lote Pendente de Proc." },;
						{"BR_VERMELHO"   , "Registro c/Errata"  },;
						{"BR_PRETO"      , "CANCELADO"  } }	

Local uRetorno := .T.

uRetorno := {}
Aadd(uRetorno, { '!EMPTY(Z8_LOTNFC) .AND.  EMPTY(Z8_NUMCTRC) .AND. Z8_STATUS<>"00" ', aLegenda[1][1] } )
Aadd(uRetorno, { '!EMPTY(Z8_LOTNFC) .AND. !EMPTY(Z8_NUMCTRC) .AND. Z8_STATUS<>"00" ', aLegenda[2][1] } )
Aadd(uRetorno, { ' EMPTY(Z8_LOTNFC) .AND.  EMPTY(Z8_NUMCTRC) .AND. Z8_ERRATA=""'    , aLegenda[3][1] } )
Aadd(uRetorno, { ' EMPTY(Z8_LOTNFC) .AND.  EMPTY(Z8_NUMCTRC) .AND. Z8_ERRATA<>""'   , aLegenda[4][1] } )
Aadd(uRetorno, { '!EMPTY(Z8_LOTNFC) .AND. !EMPTY(Z8_NUMCTRC) .AND. Z8_STATUS="00" ' , aLegenda[5][1] } )

/*
		If cAlias = "SE1"
			Aadd(aLegenda,{"BR_AMARELO", STR0029}) //"Titulo Protestado"
		Endif
*/		
If .NOT. nReg = Nil
	BrwLegenda("Manuten��o de T�tulos", "Legenda", aLegenda)
EndIf

Return uRetorno
