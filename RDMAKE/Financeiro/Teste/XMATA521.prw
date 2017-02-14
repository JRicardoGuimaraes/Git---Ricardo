#DEFINE GD_INSERT 1
#DEFINE GD_UPDATE 2
#DEFINE GD_DELETE 4
#INCLUDE "MATA521.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³MATA521A  ³ Rev.  ³Eduardo Riera          ³ Data ³29.12.2001  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de exclusao dos documentos de Saida                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                        ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AMATA521A()

Local aArea     := GetArea()
Local aIndSF2   := {}
Local cFilSF2   := ""
Local cBakSF2   := ""
Local cQrySF2   := ""
Local cMarca	:= ""
Local lSeleciona:= .F.
Local lCreate   := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para e-Commerce      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lECommerce := SuperGetMV("MV_LJECOMM",,.F.) .AND. GetRpoRelease("R5")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carga das Variaveis Staticas do Programa                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa  ³
//³ ----------- Elementos contidos por dimensao ------------ ³
//³ 1. Nome a aparecer no cabecalho                          ³
//³ 2. Nome da Rotina associada                              ³
//³ 3. Usado pela rotina                                     ³
//³ 4. Tipo de Transa‡„o a ser efetuada                      ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados         ³
//³    2 - Simplesmente Mostra os Campos                     ³
//³    3 - Inclui registros no Bancos de Dados               ³
//³    4 - Altera o registro corrente                        ³
//³    5 - Remove o registro corrente do Banco de Dados      ³
//³    6 - Altera determinados campos sem incluir novos Regs ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE bFiltraBrw := {|| Nil}
PRIVATE bEndFilBrw := {|| EndFilBrw("SF2",aIndSF2),aIndSF2:={}}
PRIVATE cCadastro  := OemToAnsi(STR0001)	//"Exclusao dos Documento de Saida"
PRIVATE aRotina    := { ;
	{ STR0002 ,"PesqBrw"  , 0 , 0},; //"Pesquisa"
	{ STR0004,"Mc090Visua", 0 , 2},; //"Visualizar"
	{ STR0005,"Ma521MarkB", 0 , 5}} //"Excluir"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exibe as perguntas da rotina:                                           ³
//³                                                                        ³
//³1) Modelo de Interface? Marcacao/Selecao                                ³
//³2) Selecionar Itens   ? Sim/Nao                                         ³
//³3) Emissao de         ?                                                 ³
//³4) Emissao ate        ?                                                 ³
//³5) Serie de           ?                                                 ³
//³6) Serie ate          ?                                                 ³
//³7) Documento de       ?                                                 ³
//³8) Documento ate      ?                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
If Pergunte("MT521A",.T.)
	#IFDEF TOP
		SF2->(dbSetOrder(1))
	#ELSE
		SF2->(dbSetOrder(2))    /// colocado para que a função FilBrowse utilize o indice 1 no filtro, a fução utiliza indice -1, tornando o indice 0, neste fonte necessitamos que o fitro utiliza um indice 19/04/2011 TI4501
	#ENDIF

	lSeleciona := MV_PAR02==1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem da expressao de filtro                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFilSF2 := "F2_FILIAL='"+xFilial("SF2")+"' .And. "
	cQrySF2 := "SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
	cFilSF2 += "DTOS(F2_EMISSAO)>='"+Dtos(MV_PAR03)+"' .And. "
	cQrySF2 += "SF2.F2_EMISSAO>='"+Dtos(MV_PAR03)+"' AND "
	cFilSF2 += "DTOS(F2_EMISSAO)<='"+Dtos(MV_PAR04)+"' .And. "
	cQrySF2 += "SF2.F2_EMISSAO<='"+Dtos(MV_PAR04)+"' AND "
	cFilSF2 += "F2_SERIE>='"+MV_PAR05+"' .And. "
	cQrySF2 += "SF2.F2_SERIE>='"+MV_PAR05+"' AND "
	cFilSF2 += "F2_SERIE<='"+MV_PAR06+"' .And. "
	cQrySF2 += "SF2.F2_SERIE<='"+MV_PAR06+"' AND "
	cFilSF2 += "F2_DOC>='"+MV_PAR07+"' .And. "
	cQrySF2 += "SF2.F2_DOC>='"+MV_PAR07+"' AND "
	cFilSF2 += "F2_DOC<='"+MV_PAR08+"'"
	cQrySF2 += "SF2.F2_DOC<='"+MV_PAR08+"'"

	If ExistBlock( "M520FIL" )
		cFilSF2 += ".And."+ExecBlock("M520FIL",.F.,.F.)
	EndIf

	If ExistBlock( "M520QRY" )
		cQrySF2 := ExecBlock("M520QRY",.F.,.F.,{ cQrySF2 , 1 })
	EndIf


	cBakSF2 := cFilSF2

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Realiza a Filtragem                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	bFiltraBrw := {|x,y|IIf(x==Nil,FilBrowse("SF2",@aIndSF2,@cFilSF2),IIf(x==1,{cBakSF2,cQrySF2},IIf(x==2,aIndSF2,cFilSF2:=y))) }
	//Eval(bFiltraBrw)    //Ajustes efetuados para o chamado THSQNC (instruções conforme Framework)

	SF2->(dbSetOrder(1))     /// no CodeBase a função FilBrowse retornará o indice 2 19/04/2011 TI4501
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica o modelo de interface                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MV_PAR01 == 1
		Pergunte("MTA521",.F.)
		SetKey(VK_F12,{||Pergunte("MTA521",.T.)})
		aRotina[3][2] := "Ma521MarkB"

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Ponto de entrada para pre-validar os dados a serem  ³
        //³ exibidos.                                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        IF ExistBlock("M520BROW")
	       ExecBlock("M520BROW",.F.,.F.)
        Endif

		if lECommerce
   		   cMarca	:= GetMark(,"SF2","F2_OK")
		   MarkBrow("SF2","F2_OK",,,lSeleciona,cMarca,,,,,"A521VERPRS('1','" + cMarca + "')",,,,,,,cFilSF2)
		else
		   MarkBrow("SF2","F2_OK",,,lSeleciona,GetMark(,"SF2","F2_OK"),,,,,,,,,,,,cFilSF2)
		endIf
		SetKey(VK_F12,Nil)
	Else
		Pergunte("MTA521",.F.)
		SetKey(VK_F12,{||Pergunte("MTA521",.T.)})
		aRotina[3][2] := "Ma521Mbrow"

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Ponto de entrada para pre-validar os dados a serem  ³
        //³ exibidos.                                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        IF ExistBlock("M520BROW")
	       ExecBlock("M520BROW",.F.,.F.)
        Endif

		mBrowse(7,4,20,74,"SF2")
		SetKey(VK_F12,Nil)
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a integridade da rotina                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EndFilBrw("SF2",aIndSF2)
RetIndex("SF2")

RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³MA521Filtr³ Rev.  ³Eduardo Riera          ³ Data ³29.12.2001	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de filtragem da interface da rotina de exclusao     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      	³±±
±±³          ³                                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias para filtragem                                 	³±±
±±³          ³                                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MA521Filtr(cAlias)

Local aArea   := GetArea()
Local cOldFil := Eval(bFiltraBrw,1)[1]
Local cFiltro := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Fecha todos os indices e restaura a integridade da tabela       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
(cAlias)->(dbClearFilter())
cFiltro := FilterExpr(cAlias)
Eval(bEndFilBrw)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a expressao do filtro                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
If ( Empty(cFiltro) )
	cFiltro := ".T."
EndIf
cFiltro := cOldFil + ".And." + cFiltro
Eval(bFiltraBrw,3,cFiltro)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Recria o novo indice/filtro                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Eval(bFiltraBrw)
RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³MA521Markb³ Rev.  ³Eduardo Riera          ³ Data ³29.12.2001	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de processamento da Exclusao dos documento de saida 	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      	³±±
±±³          ³                                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias                                                	³±±
±±³          ³                                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma521Markb(cAlias,nReg,nOpcX,cMarca,lInverte)

Local aArea    := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis de parametrizacao de lancamentos             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 Mostra Lan‡.Contab ?  Sim/Nao                        ³
//³ mv_par02 Aglut. Lan‡amentos ?  Sim/Nao                        ³
//³ mv_par03 Lan‡.Contab.On-Line?  Sim/Nao                        ³
//³ mv_par04 Retornar PV        ?  Carteira/Apto a faturar        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MsgYesNo(OemToAnsi(STR0006),; //"Confirma estorno dos documentos marcados ?"
		OemToAnsi(STR0007)) //"Aten‡„o"
	PcoIniLan("000101")
	Processa({|lEnd| Ma521Mark2(cAlias,;
		@lEnd,;
		MV_PAR01==1,;
		MV_PAR02==1,;
		MV_PAR03==1,;
		MV_PAR04==1)},,OemToAnsi(STR0008),.T.) //"Estorno dos documentos de saida"
	PcoFinLan("000101")
EndIf
RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³MA521Markb³ Rev.  ³Eduardo Riera          ³ Data ³29.12.2001	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de processamento da Exclusao dos documento de saida 	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      	³±±
±±³          ³                                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias                                                	³±±
±±³          ³ExpL2: Controle de cancelamento                             	³±±
±±³          ³ExpL3: Mostra lancto contabil                               	³±±
±±³          ³ExpL4: Aglutina lancto contabil                             	³±±
±±³          ³ExpL5: Contabiliza On-Line                                  	³±±
±±³          ³ExpL6: Pedido em carteira                                   	³±±
±±³          ³                                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma521Mark2(cAlias,lEnd,lMostraCtb,lAglCtb,lContab,lCarteira)

Local aArea     := GetArea()
Local aAreaSF2  := SF2->(GetArea())
Local aAreaDAK  := DAK->(GetArea())
Local aRegSD2   := {}
Local aRegSE1   := {}
Local aRegSE2   := {}
Local cMensagem := RetTitle("F2_DOC")
Local cAliasSF2 := "SF2"
Local cAliasDAK := "DAK"
Local cMarca    := ThisMark()
Local cIndSF2   := ""
Local cSavFil   := cFilAnt
Local lInverte  := ThisInv()
Local lQuery    := .F.
Local lValido   := .F.
Local lMs520Vld := (existblock("MS520VLD",,.T.))
Local lMs520VldE:= ExistTemplate("MS520VLD")
Local lSF2520ET := ExistTemplate("SF2520E")
Local lSF2520E  := Existblock("SF2520E")
Local lIntACD	:= SuperGetMV("MV_INTACD",.F.,"0") == "1"
Local nVlEntCom := OsVlEntCom()
Local nIndSF2   := 5
Local bWhile1   := {|| !Eof()}
Local bWhile2   := {|| !Eof()}

#IFDEF TOP
	Local aFiltro   := Eval(bFiltraBrw,1)
	Local aStruSF2  := {}
	Local cQuery    := ""
	Local nX        := 0
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a Tabela da MarkBrowse                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento dos Documentos de saida                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case cAlias == "SF2"
	dbSelectArea("SF2")

	#IFDEF TOP

		If TcSrvType()<>"AS/400"
			lQuery    := .T.
			cAliasSF2 := "MA521MarkB"
			aStruSF2  := SF2->(dbStruct())

			cQuery := "SELECT SF2.*,R_E_C_N_O_ SF2RECNO "
			cQuery += "FROM "+RetSqlName("SF2")+" SF2 "
			cQuery += "WHERE SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
			If ( lInverte )
				cQuery += "SF2.F2_OK<>'"+cMarca+"' AND "
			Else
				cQuery += "SF2.F2_OK='"+cMarca+"' AND "
			EndIf
			cQuery += aFiltro[2]+" AND "
			cQuery += "SF2.D_E_L_E_T_=' ' "
			cQuery += "ORDER BY "+SqlOrder(SF2->(IndexKey()))

			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF2,.T.,.T.)

			For nX := 1 To Len(aStruSF2)
				If aStruSF2[nX][2]<>"C"
					TcSetField(cAliasSF2,aStruSF2[nX][1],aStruSF2[nX][2],aStruSF2[nX][3],aStruSF2[nX][4])
				EndIf
			Next nX
		Else
	#ENDIF
			dbSelectArea("SF2")
			MsSeek(xFilial("SF2"))
	#IFDEF TOP
		EndIf
	#ENDIF
	ProcRegua(SF2->(LastRec()))
	dbSelectArea(cAliasSF2)
	While !Eof()
		lValido := .T.
		If !lQuery
			If  !((SF2->F2_OK != cMarca .And. lInverte).Or.(SF2->F2_OK == cMarca .And. !lInverte))
				lValido := .F.
			EndIf
		EndIf
		If lValido
			If lQuery
				dbSelectArea("SF2")
				MsGoto((cAliasSF2)->SF2RECNO)
				cFiltro:= dbFilter()
				If !Empty(cFiltro)
					lValido := &cFiltro
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Integracao com o ACD - Validacao da exclusao da Nota Fiscal de Saida  		 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lIntACD .And. FindFunction("CBMS520VLD")
				lValido := CBMS520VLD()
			ElseIf lMs520VldE
				lValido := ExecTemplate("MS520VLD",.F.,.F.)
			EndIf
			If lValido .And. lMs520Vld
				lValido := ExecBlock("MS520VLD",.F.,.F.)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o estorno do documento de saida pode ser feito     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aRegSD2 := {}
			aRegSE1 := {}
			aRegSE2 := {}
			If MaCanDelF2(cAliasSF2,SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2) .And. lValido .AND. MA521VerSC6(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Integracao com o ACD - Acerto do CB0 na Exclusao da NF de devolucao via Protheus,			³
				//³ Somente se a etiqueta estiver com NF de Devolucao gravada 		  							³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lIntACD .And. FindFunction("CBSF2520E")
					CBSF2520E()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Pontos de Entrada 	 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ElseIf lSF2520ET
					ExecTemplate("SF2520E",.F.,.F.)
				EndIf

				If nModulo == 72
					KEXFA00()
				Endif

				If lSF2520E
					ExecBlock("SF2520E",.F.,.F.)
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Estorna o documento de saida                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,lMostraCtb,lAglCtb,lContab,lCarteira))
			EndIf
			MsUnLockAll()
		EndIf
		dbSelectArea(cAliasSF2)
		dbSkip()
		IncProc(cMensagem+"..:"+(cAliasSF2)->F2_SERIE+"/"+(cAliasSF2)->F2_DOC)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Controle de cancelamento do usuario                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lEnd
			Exit
		EndIf
	EndDo
	If lQuery
		dbSelectArea(cAliasSF2)
		dbCloseArea()
		dbSelectArea("SF2")
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento para as Cargas                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case cAlias == "DAK"
	dbSelectArea("DAK")
	dbSetOrder(1)
	#IFDEF TOP
		If TcSrvType()<>"AS/400"
			lQuery    := .T.
			cAliasSF2 := "MA521MarkB"
			cAliasDAK := "MA521MarkB"
			aStruSF2  := SF2->(dbStruct())

			cQuery := "SELECT SF2.*,R_E_C_N_O_ SF2RECNO "
			cQuery += "FROM "+RetSqlName("DAK")+" DAK,"+RetSqlName("SF2")+" SF2 "
			cQuery += "WHERE DAK.DAK_FILIAL='"+xFilial("DAK")+"' AND "
			If ( lInverte )
				cQuery += "DAK.DAK_OK<>'"+cMarca+"' AND "
			Else
				cQuery += "DAK.DAK_OK='"+cMarca+"' AND "
			EndIf
			cQuery += aFiltro[2]+" AND "
			If nVlEntCom == 1
				cQuery += "SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
			EndIf
			cQuery += "SF2.F2_CARGA=DAK.DAK_COD AND "
			cQuery += "SF2.F2_SEQCAR=DAK.DAK_SEQCAR AND "
			cQuery += "SF2.D_E_L_E_T_=' ' "
			cQuery += "ORDER BY "+SqlOrder(DAK->(IndexKey()))

			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDAK,.T.,.T.)

			For nX := 1 To Len(aStruSF2)
				If aStruSF2[nX][2]<>"C"
					TcSetField(cAliasSF2,aStruSF2[nX][1],aStruSF2[nX][2],aStruSF2[nX][3],aStruSF2[nX][4])
				EndIf
			Next nX
    	Else
	#ENDIF
			If nVlEntCom <> 1
				cIndSF2 := CriaTrab(,.F.)
				dbSelectArea("SF2")
				IndRegua("SF2",cIndSF2,"F2_CARGA+F2_SEQCAR")
				nIndSF2 := RetIndex("SF2")+1
				#IFDEF TOP
					dbSetIndex(cIndSF2+OrdBagExt())
				#ENDIF
				dbSetOrder(nIndSF2)
				dbGotop()
				bWhile2 := {|| !Eof() .And. (cAliasSF2)->F2_CARGA == (cAliasDAK)->DAK_COD .And.;
					(cAliasSF2)->F2_SEQCAR == (cAliasDAK)->DAK_SEQCAR }
			Else
				bWhile2 := {|| !Eof() .And. (cAliasSF2)->F2_FILIAL == xFilial("SF2") .And.;
					(cAliasSF2)->F2_CARGA == (cAliasDAK)->DAK_COD .And.;
					(cAliasSF2)->F2_SEQCAR == (cAliasDAK)->DAK_SEQCAR }
			EndIf
			dbSelectArea("DAK")
			MsSeek(xFilial("DAK"))
	#IFDEF TOP
		EndIf
	#ENDIF
	ProcRegua(DAK->(LastRec()))
	dbSelectArea(cAliasDAK)
	While Eval(bWhile1)
		lValido := .T.
		If !lQuery
			If  !((DAK->DAK_OK != cMarca .And. lInverte).Or.(DAK->DAK_OK == cMarca .And. !lInverte))
				lValido := .F.
			EndIf
		EndIf
		If lValido
			If lQuery
				dbSelectArea("SF2")
				MsGoto((cAliasSF2)->SF2RECNO)
			Else
				If nVlEntCom == 1
					dbSelectArea("SF2")
					dbSetOrder(5)
					MsSeek(xFilial("SF2")+(cAliasDAK)->DAK_COD+(cAliasDAK)->DAK_SEQCAR)
				Else
					dbSelectArea("SF2")
					dbSetOrder(nIndSF2)
					MsSeek((cAliasDAK)->DAK_COD+(cAliasDAK)->DAK_SEQCAR)
				EndIf
			EndIf
			While Eval(bWhile2)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Integracao com o  ACD - Validacao da exclusao da Nota Fiscal de Saida  		³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lIntACD .And. FindFunction("CBMS520VLD")
					lValido := CBMS520VLD()
				ElseIf lMs520VldE
					lValido := ExecTemplate("MS520VLD",.F.,.F.)
				EndIf
				If lValido .And. lMs520Vld
					lValido := ExecBlock("MS520VLD",.F.,.F.)
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica a Filial do SF2                                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cFilAnt := IIf(!Empty(xFilial("SF2")),SF2->F2_FILIAL,cFilAnt)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se o estorno do documento de saida pode ser feito     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aRegSD2 := {}
				aRegSE1 := {}
				aRegSE2 := {}
				If MaCanDelF2(cAliasSF2,SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2) .And. lValido

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Integracao com o  ACD - Acerto do CB0 na Exclusao da NF de devolucao via Protheus,			³
					//³ Somente se a etiqueta estiver com NF de Devolucao gravada 		  							³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lIntACD .And. FindFunction("CBSF2520E")
						CBSF2520E()
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Pontos de Entrada 											   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ElseIf lSF2520ET
						ExecTemplate("SF2520E",.F.,.F.)
					EndIf

					If nModulo == 72
						KEXFA00()
					Endif

					If lSF2520E
						ExecBlock("SF2520E",.F.,.F.)
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Estorna o documento de saida                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,lMostraCtb,lAglCtb,lContab,lCarteira))
				EndIf
				MsUnLockAll()
				dbSelectArea(cAliasSF2)
				dbSkip()
			EndDo
		EndIf
		If lQuery
			dbSelectArea(cAliasDAK)
			dbSkip()
		EndIf
		IncProc(cMensagem+"..:"+(cAliasDAK)->DAK_COD+"/"+(cAliasDAK)->DAK_SEQCAR)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Controle de cancelamento do usuario                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lEnd
			Exit
		EndIf
	EndDo
	If lQuery
		dbSelectArea(cAliasDAK)
		dbCloseArea()
		dbSelectArea("DAK")
	Else
		dbSelectArea("SF2")
		RetIndex("SF2")
		FErase(cIndSF2+OrdBagExt())
	EndIf
EndCase
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt := cSavFil
RestArea(aAreaSF2)
RestArea(aAreaDAK)
RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³MA521Mbrow³ Rev.  ³Eduardo Riera          ³ Data ³01.01.2002	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de processamento da Exclusao dos documento de saida 	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      	³±±
±±³          ³                                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias                                                	³±±
±±³          ³ExpL2: Controle de cancelamento                             	³±±
±±³          ³ExpL3: Mostra lancto contabil                               	³±±
±±³          ³ExpL4: Aglutina lancto contabil                             	³±±
±±³          ³ExpL5: Contabiliza On-Line                                  	³±±
±±³          ³ExpL6: Pedido em carteira                                   	³±±
±±³          ³                                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma521Mbrow(cAlias)

Local aArea     := GetArea()
Local aAreaSF2  := SF2->(GetArea())
Local aAreaDAK  := DAK->(GetArea())
Local aRegSD2   := {}
Local aRegSE1   := {}
Local aRegSE2   := {}
Local cQuery    := ""
Local cAliasSF2 := "SF2"
Local cIndSF2   := ""
Local cSavFil   := cFilAnt
Local lQuery    := .F.
Local lValido   := .T.
Local lMs520Vld := (existblock("MS520VLD",,.T.))
Local lMs520VldE:= ExistTemplate("MS520VLD")
Local lSF2520ET := ExistTemplate("SF2520E")
Local lSF2520E  := Existblock("SF2520E")
Local lIntACD	:= SuperGetMV("MV_INTACD",.F.,"0") == "1"
Local lMostraCtb:= .F.
Local lAglCtb   := .F.
Local lContab   := .F.
Local lCarteira := .F.
Local nVlEntCom := OsVlEntCom()
Local nIndSF2   := 5
Local bWhile   := {|| !Eof()}

#IFDEF TOP
	Local aStruSF2  := {}
	Local nX        := 0
#ENDIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis de parametrizacao de lancamentos             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 Mostra Lan‡.Contab ?  Sim/Nao                        ³
//³ mv_par02 Aglut. Lan‡amentos ?  Sim/Nao                        ³
//³ mv_par03 Lan‡.Contab.On-Line?  Sim/Nao                        ³
//³ mv_par04 Retornar PV        ?  Carteira/Apto a faturar        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MsgYesNo(OemToAnsi(STR0009),OemToAnsi(STR0007)) //"Confirma estorno do documento ?"###"Aten‡„o"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa processo de lançamento no modulo PCO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoIniLan("000101")

	lMostraCtb := MV_PAR01==1
	lAglCtb    := MV_PAR02==1
	lContab    := MV_PAR03==1
	lCarteira  := MV_PAR04==1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a Tabela da MarkBrowse                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento dos Documentos de saida                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case cAlias == "SF2"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Integracao com o ACD - Validacao da exclusao da Nota Fiscal de Saida  		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lIntACD .And. FindFunction("CBMS520VLD")
			lValido := CBMS520VLD()
		ElseIf lMs520VldE
			lValido := ExecTemplate("MS520VLD",.F.,.F.)
		EndIf
		If lValido .And. lMs520Vld
			lValido := ExecBlock("MS520VLD",.F.,.F.)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o estorno do documento de saida pode ser feito     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aRegSD2 := {}
		aRegSE1 := {}
		aRegSE2 := {}
		If MaCanDelF2(cAliasSF2,SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2) .And. lValido .AND. MA521VerSC6(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Integracao com o ACD - Acerto do CB0 na Exclusao da NF de devolucao via Protheus,			³
			//³ Somente se a etiqueta estiver com NF de Devolucao gravada 		  							³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lIntACD .And. FindFunction("CBSF2520E")
				CBSF2520E()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Pontos de Entrada 										       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ElseIf lSF2520ET
				ExecTemplate("SF2520E",.F.,.F.)
			EndIf

			If nModulo == 72
				KEXFA00()
			Endif

			If lSF2520E
				ExecBlock("SF2520E",.F.,.F.)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Estorna o documento de saida                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,lMostraCtb,lAglCtb,lContab,lCarteira))
		EndIf
		MsUnLockAll()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento para as Cargas                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case cAlias == "DAK"
		If DAK->DAK_ACEFIN<>"2"
			Help(" ",1,"OMS320JAFIN") //"Acerto financeiro ja efetuado"
		ElseIf DAK->DAK_ACECAR<>"2"
				Help(" ",1,"OMS320JAAC") //Carga ja encerrada
		Else
			dbSelectArea("SF2")
			dbSetOrder(1)
			#IFDEF TOP
				If TcSrvType()<>"AS/400"
					lQuery    := .T.
					cAliasSF2 := "MA521Mbrow"
					aStruSF2  := SF2->(dbStruct())

					cQuery := "SELECT SF2.*,R_E_C_N_O_ SF2RECNO "
					cQuery += "FROM "+RetSqlName("SF2")+" SF2 "
					cQuery += "WHERE "
					If nVlEntCom == 1
						cQuery += "SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
					EndIf
					cQuery += "SF2.F2_CARGA='"+DAK->DAK_COD+"' AND "
					cQuery += "SF2.F2_SEQCAR='"+DAK->DAK_SEQCAR+"' AND "
					cQuery += "SF2.D_E_L_E_T_=' ' "

					cQuery := ChangeQuery(cQuery)

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF2,.T.,.T.)

					For nX := 1 To Len(aStruSF2)
						If aStruSF2[nX][2]<>"C"
							TcSetField(cAliasSF2,aStruSF2[nX][1],aStruSF2[nX][2],aStruSF2[nX][3],aStruSF2[nX][4])
						EndIf
					Next nX
		    	Else
			#ENDIF
					If nVlEntCom <> 1
						cQuery := "F2_CARGA='"+DAK->DAK_COD+"' .And."
						cQuery += "F2_SEQCAR='"+DAK->DAK_SEQCAR+"'"
						cIndSF2 := CriaTrab(,.F.)
						dbSelectArea("SF2")
						IndRegua("SF2",cIndSF2,"F2_CARGA+F2_SEQCAR",,cQuery)
						nIndSF2 := RetIndex("SF2")+1
						#IFNDEF TOP
							dbSetIndex(cIndSF2+OrdBagExt())
						#ENDIF
						dbSetOrder(nIndSF2)
						dbGotop()
						bWhile := {|| !Eof() .And. (cAliasSF2)->F2_CARGA == DAK->DAK_COD .And.;
							(cAliasSF2)->F2_SEQCAR == DAK->DAK_SEQCAR }
					Else
						dbSelectArea("SF2")
						dbSetOrder(5)
						MsSeek(xFilial("SF2")+DAK->DAK_COD+DAK->DAK_SEQCAR)
						bWhile := {|| !Eof() .And. (cAliasSF2)->F2_FILIAL == xFilial("SF2") .And.;
							(cAliasSF2)->F2_CARGA == DAK->DAK_COD .And.;
							(cAliasSF2)->F2_SEQCAR == DAK->DAK_SEQCAR }
					EndIf
			#IFDEF TOP
				EndIf
			#ENDIF
			dbSelectArea(cAliasSF2)
			While Eval(bWhile)
				If lQuery
					dbSelectArea("SF2")
					MsGoto((cAliasSF2)->SF2RECNO)
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Integracao com o ACD - Validacao da exclusao da Nota Fiscal de Saida  		 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lIntACD .And. FindFunction("CBMS520VLD")
					lValido := CBMS520VLD()
				ElseIf lMs520VldE
					lValido := ExecTemplate("MS520VLD",.F.,.F.)
				EndIf
				If lValido .And. lMs520Vld
					lValido := ExecBlock("MS520VLD",.F.,.F.)
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica a Filial do SF2                                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cFilAnt := IIf(!Empty(xFilial("SF2")),(cAliasSF2)->F2_FILIAL,cFilAnt)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se o estorno do documento de saida pode ser feito     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aRegSD2 := {}
				aRegSE1 := {}
				aRegSE2 := {}
				If MaCanDelF2(cAliasSF2,SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2) .And. lValido

					If lIntACD .And. FindFunction("CBSF2520E")
						CBSF2520E()
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Pontos de Entrada 										       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ElseIf lSF2520ET
						ExecTemplate("SF2520E",.F.,.F.)
					EndIf

					If nModulo == 72
						KEXFA00()
					Endif

					If lSF2520E
						ExecBlock("SF2520E",.F.,.F.)
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Estorna o documento de saida                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,lMostraCtb,lAglCtb,lContab,lCarteira))
				EndIf
				MsUnLockAll()
				dbSelectArea(cAliasSF2)
				dbSkip()
			EndDo
			If lQuery
				dbSelectArea(cAliasSF2)
				dbCloseArea()
				dbSelectArea("SF2")
			Else
				dbSelectArea("SF2")
				RetIndex("SF2")
				FErase(cIndSF2+OrdBagExt())
			EndIf
		Endif
	EndCase

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza processo de lancamento no modulo PCO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoFinLan("000101")

EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt := cSavFil
RestArea(aAreaSF2)
RestArea(aAreaDAK)
RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³MaCanDelF2³ Rev.  ³Eduardo Riera          ³ Data ³29.12.2001	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validacao da exclusao dos Documentos de Saida              	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se o documento pode ser excluido              	³±±
±±³          ³                                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: Alias da tabela                                   (OPC)³±±
±±³          ³ExpN2: Recno da linha da tabela                          (OPC)³±±
±±³          ³ExpA3: Array com os Recnos do SD2                        (OPC)³±±
±±³          ³ExpA4: Array com os Recnos do SE1                        (OPC)³±±
±±³          ³ExpA5: Array com os Recnos do SE2                        (OPC)³±±
±±³          ³ExpC6: Origem a ser considerado na comparacao com registros  ³±±
±±³          ³       gerados no modulo financeiro (Opcional)               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MaCanDelF2(cAlias,nRegSF2,aRegSD2,aRegSE1,aRegSE2,cOrigFin)

Local aArea			:= GetArea()
Local aAreaSF2 		:= SF2->(GetArea())
Local aAreaSD2 		:= SD2->(GetArea())
Local aAreaSE2 		:= SE2->(GetArea())
Local aAreaSE1 		:= SE1->(GetArea())
Local aAreaSB6 		:= SB6->(GetArea())
Local aLockSE1 		:= {}
Local aLockSE2 		:= {}
Local aLockSC5 		:= {}
Local aLockSB2 		:= {}
Local aAreaSIX 		:= {}
Local lRetorno 		:= .T.
Local lQuery   		:= .F.
Local dDtDigit 		:= dDataBase
Local cAliasSD2		:= "SD2"
Local cAliasSE1		:= "SE1"
Local cAliasSE2		:= "SE2"
Local cPrefixo 		:= ""
Local cMunic   		:= PadR(GetMv("MV_MUNIC"),Len(SE2->E2_FORNECE))
Local cEstado		:= SuperGetMv( "MV_ESTADO" , .F. )
Local nExcNfs		:= SuperGetMv( "MV_EXCNFS",,180 )
Local nTpPrz		:= SuperGetMv( "MV_TIPOPRZ",,1 )
Local lVldSbt		:= SuperGetMv( "MV_VLDSBT",,.T. )
Local cSerie   		:= ""
Local cNumero  		:= ""
Local cClieFor 		:= ""
Local cLoja    		:= ""
Local cTipo    		:= ""
Local cEspecie		:= ""
Local cMensagem		:= ""
Local cTipoNfs		:= ""
Local cMunSP    	:= "3550308"
Local cMunSalv    	:= "2927408"
Local cLojaISS 		:= PadR("00",Len(SE2->E2_LOJA))
Local lMa520SE1		:= ExistBlock("MA520SE1")
Local lMa520SE2		:= ExistBlock("MA520SE2")
Local lCondVenda	:= .F.
Local cUniao   		:= PadR(GetMV("MV_UNIAO"),Len(SE2->E2_FORNECE))
Local cLojaIRF 		:= Padr( "00", Len(SE2->E2_LOJA ))
Local lFreteEmb		:= .F. //-- Desabilitado devido a utilização do GFE. Será revisto futuramente
Local nHoras   		:= 0
Local nSpedExc 		:= GetNewPar("MV_SPEDEXC",24)
Local cTipoParc		:= MVNOTAFIS
Local cIndex		:= ''
Local cMsg	 		:= ''
Local cKey      	:= ''
Local cCondicao 	:= ''
Local lDocRelac 	:= .F.
Local lExcnfs		:= .T.
Local lLegMunSp 	:= .F.		// Legislacao apenas do Mun. de Sp (permite exclusão de nota ate 180 dias da emissao)
Local lLegMunBA		:= .F.		// Legislacao apenas do Mun. de BA (permite exclusão de nota ate o ultimo dia do mes subsequente da emissao)
Local lLegMun       := .F.
Local lProcAdm      := .F.
Local nInd      	:= 0
Local nCountSE1 	:= 0
Local lPriParAdtBx 	:= .F.
Local nValorAdtFR3 	:= 0
Local dDataR 		:= CTOD("01/" + StrZero(Month(SF2->F2_EMISSAO),2) + Str(Year(SF2->F2_EMISSAO)),"DD/MM/YYYY")
Local dDataR1       := CTOD("01/" + StrZero(Month(SF2->F2_EMISSAO),2) + Str(Year(SF2->F2_EMISSAO)),"DD/MM/YYYY")
Local dDtVenISS		:= ''

Local aMunic 	:= {}
Local cMunEst 	:= ''
Local nPosMunic := 0

#IFDEF TOP
	Local aStruSD2 := {}
	Local aStruSE1 := {}
	Local aStruSE2 := {}
	Local cQuery   := ""
	Local nX       := 0
	Local cAliasAux:= "cAliasAux"
	Local cQuerySD2:= ""
	Local lAlvoCERTO := .F.
	Local cQrySD2	:= ""
	Local cAliasTmp	:= "cAliasTmp"
#ENDIF


aAdd(aMunic,{"SP","São Bernardo do Campo","3548708"})
aAdd(aMunic,{"AL","Maceió","2704302"})
aAdd(aMunic,{"CE","Fortaleza","2304400"})
aAdd(aMunic,{"RN","Natal","2408102"})
aAdd(aMunic,{"SP","São Paulo","3550308"})
aAdd(aMunic,{"BA","Salvador","2927408"})
aAdd(aMunic,{"PR","Londrina","4113700"})
aAdd(aMunic,{"GO","Goiânia","5208707"})
aAdd(aMunic,{"PE","Recife","2611606"})
aAdd(aMunic,{"PI","Teresina","2211001"})
aAdd(aMunic,{"RS","Porto Alegre","4314902"})
aAdd(aMunic,{"PA","Parauapebas","1505536"})
aAdd(aMunic,{"MG","Belo Horizonte","3106200"})
aAdd(aMunic,{"SP","Guarulhos","3518800"})
aAdd(aMunic,{"MS","Campo Grande","5002704"})
aAdd(aMunic,{"DF","Brasília","5300108"})
aAdd(aMunic,{"RJ","Rio de Janeiro","3304557"})
aAdd(aMunic,{"AL","Rio Largo","2707701"})
aAdd(aMunic,{"RO","Porto Velho","1100205"})
aAdd(aMunic,{"SE","Aracaju","2800308"})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionando registros                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nRegSF2 <> Nil
	dbSelectArea("SF2")
	MsGoto(nRegSF2)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os parametros da Rotina                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFAULT cAlias  := "SF2"
DEFAULT aRegSD2 := {}
DEFAULT aRegSE1 := {}
DEFAULT aRegSE2 := {}
DEFAULT cOrigFin:= "MATA460"

cSerie  := (cAlias)->F2_SERIE
cNumero := (cAlias)->F2_DOC
cClieFor:= (cAlias)->F2_CLIENTE
cLoja   := (cAlias)->F2_LOJA
cEspecie:= (cAlias)->F2_ESPECIE
cTipo   := (cAlias)->F2_TIPO
dDtdigit := IIf((cAlias)->(FieldPos('F2_DTDIGIT'))>0 .And. !Empty((cAlias)->F2_DTDIGIT),(cAlias)->F2_DTDIGIT,(cAlias)->F2_EMISSAO)
cPrefixo := IIf(Empty((cAlias)->F2_PREFIXO) .Or. SuperGetMv("MV_CMPDEVC",.F.,.F.),&(GetMv("MV_1DUPREF")),(cAlias)->F2_PREFIXO)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existe documentos relacionados a nota, caso existir não será possível a exclusão   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(cTipo $ "C/I/P/D")
  	#IFDEF TOP
	cQuerySD2 := "SELECT D2_NFORI,D2_SERIORI "
	cQuerySD2 += "FROM "+RetSqlName("SD2")+" SD2 "
	cQuerySD2 += "WHERE D2_FILIAL = '"+xFilial("SF2")+"' AND D2_NFORI = '"+cNumero+"' AND D2_SERIORI = '"+cSerie+"' AND D2_TIPO IN ('C','I','P') AND D_E_L_E_T_=' ' "
	cQuerySD2 += "ORDER BY D2_FILIAL,D2_NFORI,D2_SERIORI"
	cQuerySD2 := ChangeQuery(cQuerySD2)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerySD2),cAliasAux,.T.,.T.)
	IF cPaisLoc<>"PER" .And. cAliasAux->(!EOF())
		lRetorno 	:= .F.
		lDocRelac 	:= .T.
	EndIf
	cAliasAux->(DbCloseArea())

	#ELSE
	DbSelectArea("SD2")
	DbSetOrder(10)
	If DbSeek(xFilial("SF2")+cNumero+cSerie) .AND. cPaisLoc<>"PER"
		While !SD2->(EOF()) .AND. SD2->D2_FILIAL == xFilial("SF2") .AND. SD2->D2_NFORI==cNumero .AND. SD2->D2_SERIORI == cSerie
		    If SD2->D2_TIPO $ ('C/I/P')
				lRetorno  := .F.
				lDocRelac := .T.
			EndIf
			SD2->(DbSkip())
		EndDo
	EndIf
	RestArea(aAreaSD2)

   	#ENDIF
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificando se encontrou documentos relacionados                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lDocRelac
	//Documento: XXXXXX Serie:XXX não póde ser excluido.
	//Verifique documentos relacionados.
	Alert(STR0015+': '+cNumero+' '+STR0016+': '+cSerie+' '+STR0017+'.'+CRLF+;
	      STR0018+'.')
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Validacao para verificar se possivel a exclusao de NF Serviço pra SP CAPITAL e Salvador BA|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetorno .AND. cPaisLoc == "BRA" .AND. SD2->(FieldPos('D2_ESTOQUE')) > 0 // Verifica se o campo D2_ESTOQUE existe pois o mesmo é criado por update
	#IFDEF TOP
	    cQrySD2 := " SELECT D2_DOC,D2_SERIE,D2_CLIENTE,D2_CF,D2_ESTOQUE,D2_TES,D2_LOJA,D2_CODISS,SD2.R_E_C_N_O_,F4_ISSST,F3_TIPO, F2_NFSUBST, F2_SERSUBS "
		cQrySD2 += " FROM "+RetSqlName("SD2")+" SD2 "
   		cQrySD2 += " INNER JOIN "+RetSqlName("SF2")+" SF2 ON SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.D_E_L_E_T_ = '' "
		cQrySD2 += " INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_ = '' "
		cQrySD2 += " INNER JOIN "+RetSqlName("SF3")+" SF3 ON SF3.F3_FILIAL = '" + xFilial("SF3") + "' AND SF3.F3_NFISCAL = SD2.D2_DOC AND SF3.F3_SERIE = SD2.D2_SERIE AND SF3.F3_CLIEFOR = SD2.D2_CLIENTE AND SF3.F3_LOJA = SD2.D2_LOJA AND SF3.D_E_L_E_T_ = '' "
//		cQrySD2 += " INNER JOIN "+RetSqlName("SF3")+" SF3 ON SF3.F3_FILIAL = '" + xFilial("SF3") + "' AND SF3.F3_NFISCAL = SD2.D2_DOC AND SF3.F3_SERIE = SD2.D2_SERIE AND SF3.F3_CLIEFOR = SD2.D2_CLIENTE AND SF3.F3_LOJA = SD2.D2_LOJA AND SF3.F3_TIPO = 'S' AND SF3.D_E_L_E_T_ = '' "
		cQrySD2 += " WHERE SD2.D2_FILIAL = '"+xFilial("SF2")+"' AND SD2.D2_DOC = '"+cNumero+"' AND SD2.D2_SERIE = '"+cSerie+"' AND SD2.D2_CLIENTE = '"+cClieFor+"' AND SD2.D2_LOJA = '"+cLoja+"' AND SD2.D_E_L_E_T_ = '' "
        //?????
 		If cEstado == "BA" .AND. Alltrim(SM0->M0_CODMUN) == aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Salvador"}),3]
 			cQrySD2 += " AND SF2.F2_NFSUBST = '' AND SF2.F2_SERSUBS = '' "
 		EndIf
 		cQrySD2 := ChangeQuery(cQrySD2)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySD2),cAliasTmp,.T.,.T.)
			While cAliasTmp->(!EOF())
			   //Validaçao de Nf serviço
			    If ((cAliasTmp->F3_TIPO == "S") .AND. ;
			    	cAliasTmp->D2_ESTOQUE == "N" .AND. ;
				    !Empty(cAliasTmp->D2_CODISS) .AND.;
				    cAliasTmp->F4_ISSST == "1" )
		   				lExcNfs := .F.
				Else
				    //Notas que nao sao de servico, mas TES de todos os itens da nf nao controla estoque
				    //exclusçao permitida sem regras
				    If (cAliasTmp->D2_ESTOQUE == "N")
						lExcNfs := .T.
				   		Exit
				   	EndIf
				EndIf
				cAliasTmp->(dBskip())

			EndDo
			cAliasTmp->(dBCloseArea())
	#ELSE
		dBSelectArea("SD2")
		dBSetorder(3)
		dBSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		While ( !Eof() .And. xFilial("SD2") == SD2->D2_FILIAL .And. cNumero == SD2->D2_DOC .And. cSerie == SD2->D2_SERIE .And. cClieFor == SD2->D2_CLIENTE .And. cLoja == SD2->D2_LOJA )
			If !Empty(SD2->D2_CODISS);
			   	.AND. SD2->D2_ESTOQUE == "N";
				.AND. (Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_ISSST") == "1");
				.AND. (Posicione("SF3",4,xFilial("SF3")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_DOC+SD2->D2_SERIE,"F3_TIPO") == "S")

				lExcNfs := .F.
			Else
			    //Notas que nao sao de servico, mas TES de todos os itens da nf nao controla estoque
			    //exclusçao permitida sem regras
				If (SD2->D2_ESTOQUE == "N")
			   		lExcNfs := .T.
			    EndIf
			EndIf
			If !lExcNfs	.And. ((cEstado == "BA" .AND. Alltrim(SM0->M0_CODMUN) == aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Salvador"}),3]) .OR.;
			                    (cEstado == "PR" .AND. Alltrim(SM0->M0_CODMUN) == aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Londrina"}),3]))
			  	If(Empty(Posicione("SF2",1,xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE,AllTrim("F2_NFSUBST")))) .AND.;
			 	(Empty(Posicione("SF2",1,xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE,"F2_SERSUBS")))
					lExcNfs := .F.
				Else
					lExcNfs := .T.
				EndIf
			EndIf
		SD2->(dBSkip())
		EndDo
	#ENDIF
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificando o Fechamento Fiscal                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetorno .And. !FisChkDt(dDtDigit)
	lRetorno := .F.
EndIf

If lRetorno .And. "SPED"$cEspecie .And. ((cAlias)->F2_FIMP$"TS") //verificacao apenas da especie como SPED e notas que foram transmitidas ou impressoo DANFE
	nHoras := SubtHoras(IIF(SF2->(FieldPos("F2_DAUTNFE")) <> 0 .And. !Empty(SF2->F2_DAUTNFE),SF2->F2_DAUTNFE,dDtdigit),IIF(SF2->(FieldPos("F2_HAUTNFE")) <> 0 .And. !Empty(SF2->F2_HAUTNFE),SF2->F2_HAUTNFE,SF2->F2_HORA),dDataBase, substr(Time(),1,2)+":"+substr(Time(),4,2) )
	If nHoras > nSpedExc
		MsgAlert("Não foi possivel excluir a(s) nota(s), pois o prazo para o cancelamento da(s) NF-e é de " + Alltrim(STR(nSpedExc)) +" horas")
		lRetorno := .F.
    EndIf
EndIf

If lRetorno .And. lFreteEmb
	aAreaSIX := SIX->(GetArea())
	SIX->(DbSetOrder(1))
	If	SIX->(DbSeek("DUA9"))
		dbSelectArea("DAK")
		dbSetOrder(1)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Contrato de Carreteiro para a carga da nota fiscal             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	MsSeek(xFilial("DAK")+(cAlias)->F2_CARGA+(cAlias)->F2_SEQCAR)
			dbSelectArea("DTY")
			dbSetOrder(5)
			If	MsSeek(OsFilial("DTY",DAK->DAK_FILIAL)+"2"+DAK->DAK_IDENT)
				Aviso("SIGAOMS",STR0014,{"Ok"}) //"Nao e permitido excluir o documento, ja existe Contrato de Carreteiro gerado"
				lRetorno := .F.
			EndIf
			If	lRetorno
				dbSelectArea("DUA")
				dbSetOrder(9)
				If	MsSeek(OsFilial("DUA",DAK->DAK_FILIAL)+"2"+DAK->DAK_IDENT)
					Aviso("SIGAOMS",STR0014,{"Ok"}) //"Nao e permitido excluir o documento, ja existe Contrato de Carreteiro gerado"
					lRetorno := .F.
				EndIf
			EndIf
		EndIf
	EndIf
	RestArea(aAreaSIX)
EndIf

nPosMunic := aScan(aMunic,{|x| Alltrim(x[3])==AllTrim(SM0->M0_CODMUN)})

If lRetorno .And. !lExcNfs .And. (nPosMunic > 0)

	cMunEst := aMunic[nPosMunic,2] +' - '+ aMunic[nPosMunic,1]

	//Verifica se o municipio tem legislacao especial
	If (aScan(aMunic,{|x| Alltrim(x[3])==AllTrim(SM0->M0_CODMUN)}) <> 0 .And. ;
		(aScan(aMunic,{|x| Alltrim(x[1])==AllTrim(cEstado)}) <> 0))
		lLegMun := .T.
	EndIf

	dbSelectarea("SE2")
   	dbSetOrder(1)

	//Busca a data de vencimento ISS
  	DbSeek(xFilial("SE2")+cPrefixo+cNumero+" "+"TX "+cMunic+"00")
	While (!SE2->(Eof()) .And. ((xFilial("SE2")+cPrefixo+cNumero+" "+"TX "+cMunic+"00") == ;
	                              (SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA)))
		If (AllTrim(SE2->E2_NATUREZ) == "ISS")
			dDtVenISS = SE2->E2_VENCREA
		EndIf
		SE2->(DbSkip())
	End


	If lRetorno .And. lLegMun
		If (nTpPrz == 1)
			dDataR := UltDia(StrZero(Month(dDataR),2), StrZero(Year(dDataR),4)) + nExcNfs
			cMsg   := STR0025 + cMunEst +  STR0028 + str(nExcNfs) + STR0029 + CHR(13)+CHR(10)+ STR0026 + DtOC(dDataR) //"O prazo para exclusão de NF de serviço para o município de XXXXX é de ate o dia XX do mes subsequente da emissao." " Data Limite "
		Else
			If (nTpPrz == 2)
				dDataR := SF2->F2_EMISSAO+nExcNfs
                cMsg := STR0025 + cMunEst + STR0030 + str(nExcNfs) + STR0031 + CHR(13)+CHR(10)+ STR0026 + DtOC(dDataR)  //"O prazo para exclusão de NF de serviço para o município de XXXXXXXX é de ate XX dias a partir da sua emissão." " Data Limite "
			EndIf
		EndIf

	      //Salvador e Londrina
		If (Alltrim(cEstado) == "BA" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Salvador"}),3] == Alltrim(SM0->M0_CODMUN)) .OR.;
			(Alltrim(cEstado) == "PR" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Londrina"}),3] == Alltrim(SM0->M0_CODMUN))
			dDataR := dDataR1+40  // sempre caira no proximo mes
			If MSDATE() > UltDia(StrZero(Month(dDataR),2), StrZero(Year(dDataR),4))
				Aviso("SIGAFAT",STR0025 + cMunEst +  STR0027 + CHR(13)+CHR(10)+ STR0026 + DtOC(UltDia(StrZero(Month(dDataR),3), StrZero(Year(dDataR),4))),{"Ok"},2)//"O prazo para exclusão de NF de serviço para o município de Salvador - BA é de ate o ultimo dia do mes subsequente da emissao. " Data Limite "
				lRetorno:= .F.
			Else
		   		//Vencimento do ISS ja expirado somente por processo administrativo
				If (!Empty(dDtVenISS) .And. (MSDATE() > dDtVenISS))
			    	lProcAdm = .T.
			 	EndIf
			EndIf
		Else
			//tratamento para o municipio de Aracaju se maior que 72 horas(3dias), se menor não pode ter recolhido ISS
	   		If (Alltrim(cEstado) == "SE" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Aracaju"}),3] == Alltrim(SM0->M0_CODMUN))
 	   			If (MSDATE()> dDataR)
	   				Aviso("SIGAFAT",cMsg,{"Ok"},2)
					lRetorno:= .F.
	   			Else
			   		//Vencimento do ISS ja expirado somente por processo administrativo
					If (!Empty(dDtVenISS) .And. (MSDATE() > dDtVenISS))
				    	lProcAdm = .T.
				 	EndIf
			   	EndIf
			Else
				//Tratamento para Porto Velho e Rio Largo sempre por processo administrativo)
				If (Alltrim(cEstado) == "RO" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Porto Velho"}),3] == Alltrim(SM0->M0_CODMUN)) .OR.;
					(Alltrim(cEstado) == "AL" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Rio Largo"}),3] == Alltrim(SM0->M0_CODMUN))
				   	lProcAdm = .T.
				Else
					//Tratamento para Rio de Janeiro por processo administrativo)
					If ((Alltrim(cEstado) == "RJ" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Rio de Janeiro"}),3] == Alltrim(SM0->M0_CODMUN)))
						If ((!Empty(dDtVenISS) .And. (MSDATE() > dDtVenISS)) .Or. ;
							(MSDATE() > dDataR))
		              	    If ((Empty((cAlias)->F2_NFSUBST)) .AND.;
						  		(Empty((cAlias)->F2_SERSUBS)))
					 				If(lVldSbt)
										If !(MsgYesNo(STR0032)) //"Esta nota está sem substituta. Confirma a exclusão?"
											lRetorno:= .F.
										Else
									   		lProcAdm = .T.
										EndIf
									Else
									   	lProcAdm = .T.
	                                EndIf
	         			 	EndIf
						EndIf
					Else
						If MSDATE()> dDataR
							Aviso("SIGAFAT",cMsg,{"Ok"},2)
							lRetorno:= .F.
						Else
							//TipoPrz==1
					 	    If(((Alltrim(cEstado) == "AL" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Maceió"}),3] == Alltrim(SM0->M0_CODMUN)) .OR.;
					          	(Alltrim(cEstado) == "CE" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Fortaleza"}),3] == Alltrim(SM0->M0_CODMUN)) .OR.;
				              	(Alltrim(cEstado) == "RN" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Natal"}),3] == Alltrim(SM0->M0_CODMUN)) .OR.;
				              	(Alltrim(cEstado) == "GO" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Goiânia"}),3] == Alltrim(SM0->M0_CODMUN)) .OR.;
				              	(Alltrim(cEstado) == "PE" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Recife"}),3] == Alltrim(SM0->M0_CODMUN)) .OR.;
				              	(Alltrim(cEstado) == "PI" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Piauí"}),3] == Alltrim(SM0->M0_CODMUN)) .OR.;
				              	(Alltrim(cEstado) == "RS" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Porto Alegre"}),3] == Alltrim(SM0->M0_CODMUN)) .OR.;
				              	(Alltrim(cEstado) == "PA" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Parauapebas"}),3] == Alltrim(SM0->M0_CODMUN)) .OR.;
				              	(Alltrim(cEstado) == "MG" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Belo Horizonte"}),3] == Alltrim(SM0->M0_CODMUN)) .OR.;
				              	(Alltrim(cEstado) == "SP" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Guarulhos"}),3] == Alltrim(SM0->M0_CODMUN)) .OR.;
				              	(Alltrim(cEstado) == "MS" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Campo Grande"}),3] == Alltrim(SM0->M0_CODMUN)) .OR.;
				              	(Alltrim(cEstado) == "DF" .And. aMunic[aScan(aMunic,{|x| Alltrim(x[2])=="Brasília"}),3] == Alltrim(SM0->M0_CODMUN))))
								//Vencimento do ISS ja expirado somente por processo administrativo
								If (!Empty(dDtVenISS) .And. (MSDATE() > dDtVenISS))
							    	lProcAdm = .T.
							 	Else
				              	    If ((Empty((cAlias)->F2_NFSUBST)) .AND.;
								  		(Empty((cAlias)->F2_SERSUBS)))
							 				If(lVldSbt)
												If !(MsgYesNo(STR0032)) //"Esta nota está sem substituta. Confirma a exclusão?"
													lRetorno:= .F.
												Else
											   		lProcAdm = .T.
												EndIf
											Else
											   	lProcAdm = .T.
			                                EndIf
			         			 	EndIf
			         			 EndIf
							Else
								//tipoprz==2
							 	//Vencimento do ISS ja expirado somente por processo administrativo
								If (!Empty(dDtVenISS) .And. (MSDATE() > dDtVenISS))
								   	lProcAdm = .T.
								EndIf
						 	EndIf
					  	EndIf
					EndIf
				EndIf
			Endif
		EndIf
	Endif
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificando o Fechamento dos Estoques³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetorno .And. dDtDigit<=If(FindFunction("MVUlmes"),MVUlmes(),GetMV("MV_ULMES")) .And. !lLegMun
	Help( " ", 1, "FECHTO" )
	lRetorno := .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificando as pendencias de localizacoes                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetorno .And. cPaisLoc<>"BRA" .And. !Empty((cAlias)->F2_PEDPEND)
	dbSelectArea("SC5")
	dbSetOrder(1)
	If MsSeek(xFilial("SC5")+(cAlias)->F2_PEDPEND)
		Help(" ",1,"A520PEND",,RetTitle("F2_DOC")+" "+cSerie+"/"+cNumero+Chr(13)+Chr(10)+RetTitle("C9_PEDIDO")+" "+(cAlias)->F2_PEDPEND,4,2)
		lRetorno := .F.
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificando retornos                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetorno
	If !Empty(SF2->F2_CARGA) .And. !Empty(SF2->F2_SEQCAR)
		DbSelectArea("DAK")
		DbSetOrder(1)
		//Nao permite a exclusao se houve retorno
		If MsSeek(xFilial("DAK")+SF2->F2_CARGA+SF2->F2_SEQCAR)
			If DAK->DAK_ACEFIN<>"2"
				Help(" ",1,"OMS320JAFIN") //"Acerto financeiro ja efetuado"
				lRetorno := .F.
			Else
				If DAK->DAK_ACECAR<>"2"
					Help(" ",1,"OMS320JAAC") //Carga ja encerrada
					lRetorno := .F.
				Endif
			Endif
		Endif
	Endif
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificando as integracoes com o modulo Financeiro             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lRetorno .And. !Empty(SF2->F2_DUPL)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verificando as Notas de Debito ao Fornecedor                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRetorno .And. (cAlias)->F2_TIPO=="D"
		dbSelectArea("SE2")
		dbSetOrder(6)
		#IFDEF TOP
			If TcSrvType()<>"AS/400"
				aStruSE2 := SE2->(dbStruct())
				cAliasSE2:= "MACANDELNF"

				lQuery := .T.
				cQuery := "SELECT SE2.*,SE2.R_E_C_N_O_ SE2RECNO "
				cQuery += "FROM "+RetSqlName("SE2")+" SE2 "
				cQuery += "WHERE SE2.E2_FILIAL='"+xFilial("SE2")+"' AND "
				cQuery += "SE2.E2_PREFIXO='"+cPrefixo+"' AND "
				cQuery += "SE2.E2_NUM='"+(cAlias)->F2_DUPL+"' AND "
				cQuery += "SE2.E2_FORNECE='"+cClieFor+"' AND "
				cQuery += "SE2.E2_LOJA='"+cLoja+"' AND "
				cQuery += "SE2.D_E_L_E_T_=' ' "

				cQuery := ChangeQuery(cQuery)

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE2,.T.,.T.)

				For nX := 1 To Len(aStruSE2)
					If aStruSE2[nX][2] <> "C"
						TcSetField(cAliasSE2,aStruSE2[nX][1],aStruSE2[nX][2],aStruSE2[nX][3],aStruSE2[nX][4])
					EndIf
				Next nX
			Else
		#ENDIF
			MsSeek(xFilial("SE2")+cClieFor+cLoja+cPrefixo+(cAlias)->F2_DUPL)
		#IFDEF TOP
			EndIf
		#ENDIF
		dbSelectArea(cAliasSE2)
		While ( !Eof() .And. xFilial("SE2") == (cAliasSE2)->E2_FILIAL .And.;
				cClieFor == (cAliasSE2)->E2_FORNECE .And.;
				cLoja == (cAliasSE2)->E2_LOJA .And.;
				cPrefixo == (cAliasSE2)->E2_PREFIXO .And.;
				(cAlias)->F2_DUPL == (cAliasSE2)->E2_NUM .And.;
				lRetorno )
			If (cAliasSE2)->E2_TIPO $ MV_CPNEG .And. AllTrim((cAliasSE2)->E2_ORIGEM) $ "MATA460N|MATA466N"

				If !FaCanDelCP(cAliasSE2,cOrigFin)
					lRetorno := .F.
					Exit
				Else
					AAdd(aLockSE2,(cAliasSE2)->E2_PREFIXO+(cAliasSE2)->E2_NUM+(cAliasSE2)->E2_PARCELA+(cAliasSE2)->E2_TIPO+(cAliasSE2)->E2_FORNECE+(cAliasSE2)->E2_LOJA)
					AAdd(aRegSE2,IIf(lQuery,(cAliasSE2)->SE2RECNO,(cAliasSE2)->(RecNo())))
				EndIf
			EndIf
			dbSelectArea(cAliasSE2)
			dbSkip()
		EndDo
		If lQuery
			dbSelectArea(cAliasSE2)
			dbCloseArea()
			dbSelectArea("SE2")
		EndIf
	EndIf

	//-- SIGATMS = Retorna Tipo do Titulo (E1_TIPO) com base no parametro MV_TMSTIPT
	If IntTms() .And. nModulo==43 .And. FindFunction("TmsTpTit")
		TmsTpTit(@cTipoParc)
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verificando os titulos a receber                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	dbSetOrder(2)
	#IFDEF TOP
		If TcSrvType()<>"AS/400"
			aStruSE1 := SE1->(dbStruct())
			cAliasSE1:= "MACANDELNF"

			lQuery := .T.
			cQuery := "SELECT SE1.*,SE1.R_E_C_N_O_ SE1RECNO "
			cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
			cQuery += "WHERE SE1.E1_FILIAL='"+xFilial("SE1")+"' AND "
			cQuery += "SE1.E1_PREFIXO='"+cPrefixo+"' AND "
			cQuery += "SE1.E1_NUM='"+(cAlias)->F2_DUPL+"' AND "
			cQuery += "SE1.E1_CLIENTE='"+cClieFor+"' AND "
			cQuery += "SE1.E1_LOJA='"+cLoja+"' AND "
			cQuery += "SE1.D_E_L_E_T_=' ' "

			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE1,.T.,.T.)

			For nX := 1 To Len(aStruSE1)
				If aStruSE1[nX][2] <> "C"
					TcSetField(cAliasSE1,aStruSE1[nX][1],aStruSE1[nX][2],aStruSE1[nX][3],aStruSE1[nX][4])
				EndIf
			Next nX
		Else
	#ENDIF
		MsSeek(xFilial("SE1")+cClieFor+cLoja+cPrefixo+(cAlias)->F2_DUPL)
	#IFDEF TOP
		EndIf
	#ENDIF
	dbSelectArea(cAliasSE1)

	#IFDEF TOP
		If cPaisLoc $ "BRA|MEX" .and. FunName() = "MATA521A"

    	    // 1- Tem apenas Adiantamento ...

			lAlvoCERTO := .F.

			if (cAlias)->F2_TIPO != "D"
				if lRetorno .And. (cAliasSE1)->(!Eof())
					if (cAliasSE1)->E1_VALOR <> (cAliasSE1)->E1_SALDO
						if A410UsaAdi((cAlias)->F2_COND)
							If AliasInDic("FR3") .And. AliasInDic("FIE")

								cQ := "SELECT SUM(FR3_VALOR) AS FR3_VALOR "
								cQ += "FROM "+RetSqlName("FR3")+" "
								cQ += "WHERE FR3_FILIAL = '"+xFilial("FR3")+"' "
								cQ += "AND FR3_CART = 'R' "
								cQ += "AND FR3_TIPO IN "	+FormatIn(MVRECANT,"/")+" "
								cQ += "AND FR3_CLIENT = '"	+SF2->F2_CLIENTE+"' "
								cQ += "AND FR3_LOJA = '"	+SF2->F2_LOJA+"' "
								cQ += "AND FR3_DOC = '"		+SF2->F2_DOC+"' "
								cQ += "AND FR3_SERIE = '"	+SF2->F2_SERIE+"' "
								cQ += "AND D_E_L_E_T_= ' ' "

								cQ := ChangeQuery(cQ)

								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"TRBFR3",.T.,.T.)

								TcSetField("TRBFR3","FR3_VALOR","N",TamSX3("FR3_VALOR")[1],TamSX3("FR3_VALOR")[2])

								nValorAdtFR3 := TRBFR3->FR3_VALOR

								TRBFR3->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ compara o valor baixado para o titulo ( E1_VALOR - E1_SALDO ), com o valor dos adiantamentos. Se o valor for igual, continua a exclusao   ³
//³ do documento, se o valor for diferente eh porque houveram outras baixas para o titulo, neste caso, nao eh possivel excluir o documento,   ³
//³ primeiro deve-se excluir estas outras baixas no Financeiro.  												                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÙ
								//Para o México os adiantamentos são baixados e não compensados. Portanto se houver adiantamentos apenas estorna a baixa.
								If (cPaisLoc != "MEX" .AND. (cAliasSE1)->(E1_VALOR-E1_SALDO) = nValorAdtFR3) .OR. (cPaisLoc == "MEX" .AND. nValorAdtFR3 > 0)
									If !ApMsgYesNo(STR0020 + CRLF+ STR0021) //"Por tratar-se de condição de pagamento com Adiantamento, a exclusão do Documento de Saída também irá excluir a compensação do(s) título(s) de adiantamento associado(s) a este Documento de Saida no momento da sua geração."#CRLF#"Deseja continuar?"
										lRetorno := .F.
						   			Endif
						   		Else
									lRetorno := .F.
							   		Help(" ",1,"FA040BAIXA")
								Endif

		                    	lAlvoCERTO := .T.
							Endif
						Endif
					Endif
				Endif
			Endif

			If !Empty((cAliasSE1)->E1_BAIXA)	  .And.(cAliasSE1)->E1_SALDO = 0  .And. !lAlvoCERTO
				lRetorno := .F.
		   		Help(" ",1,"FA040BAIXA")
            Elseif !Empty((cAliasSE1)->E1_BAIXA) .And.(cAliasSE1)->E1_VALOR <> (cAliasSE1)->E1_SALDO .And. !lAlvoCERTO
	   			lRetorno := .F.
				Help(" ",1,"BAIXAPARC")
			Endif

		Endif

		dbSelectArea(cAliasSE1)

	#ENDIF

	While ( !Eof() .And. xFilial("SE1") == (cAliasSE1)->E1_FILIAL .And.;
			cClieFor == (cAliasSE1)->E1_CLIENTE .And.;
			cLoja == (cAliasSE1)->E1_LOJA .And.;
			cPrefixo == (cAliasSE1)->E1_PREFIXO .And.;
			(cAlias)->F2_DUPL == (cAliasSE1)->E1_NUM .And.;
			lRetorno )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ se for nota fiscal com adiantamento compensado, valida se a nota fiscal tem somente uma parcela no contas a receber                                          ³
		//³ se for somente 1 parcela, segue o cancelamento e nao valida se o titulo estah baixado, pois a compensacao desta parcela vai ser desfeita na rotina MaDelNfs  ³
		//³ se for mais de uma parcela, valida as parcelas a partir da segunda, para checar se hah alguma parcela baixada                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		//	Criterio "!Empty(SE1->E1_BAIXA)" alterado:
		//  1- Exclusao da NFS sem baixa - Campo E1_BAIXA" esta com a data de baixa
		//  2- Exclusao da NFS com cancelamento de baixa - Campo E1_BAIXA" esta vazio
		//  If !Empty((cAliasSE1)->E1_BAIXA) .and. (cAliasSE1)->E1_VALOR != (cAliasSE1)->E1_SALDO  //tem baixa para o adiantamento


		#IFDEF TOP

		If cPaisLoc == "BRA" .and. FunName() = "MATA521A"
			If (cAlias)->F2_TIPO != "D"
				If nCountSE1 = 0
					If A410UsaAdi((cAlias)->F2_COND) .and. AliasInDic("FR3") .and. AliasInDic("FIE")
		   				If (cAliasSE1)->E1_VALOR != (cAliasSE1)->E1_SALDO  //tem baixa para o adiantamento
		   					lPriParAdtBx := .T.
		   				Endif
			   		Endif
			   	Endif
		   	Endif
		Endif

		#ENDIF

		If (cAliasSE1)->E1_TIPO $ IIf(cPaisLoc == "BRA",cTipoParc,cEspecie)

			If IIf((cPaisLoc == "BRA" .and. FunName() = "MATA521A" .and. lPriParAdtBx),.F.,!FaCanDelCR(cAliasSE1,cOrigFin))
				lRetorno := .F.
				Exit
			Else
				AAdd(aLockSE1,(cAliasSE1)->E1_CLIENTE+(cAliasSE1)->E1_LOJA+(cAliasSE1)->E1_PREFIXO+(cAliasSE1)->E1_NUM+(cAliasSE1)->E1_PARCELA+(cAliasSE1)->E1_TIPO)
				AAdd(aRegSE1,IIf(lQuery,(cAliasSE1)->SE1RECNO,(cAliasSE1)->(RecNo())))
			EndIf
		EndIf

		//
		// Template de GEM - Gestao de Empreendimentos Imobiliarios
		//
		// Verifica se a condicao de pagamento tem vinculacao com uma condicao de venda
		//
		If ExistTemplate("GMCondPagto")
			lCondVenda := ExecTemplate("GMCondPagto",.F.,.F.,{(cAlias)->F2_COND,(cAliasSE1)->E1_TIPO } )

			If lCondVenda
				If IIf((cPaisLoc == "BRA" .and. FunName() = "MATA521A" .and. lPriParAdtBx),.F.,!FaCanDelCR(cAliasSE1,cOrigFin))
					lRetorno := .F.
					Exit
				Else
					AAdd(aLockSE1,(cAliasSE1)->E1_CLIENTE+(cAliasSE1)->E1_LOJA+(cAliasSE1)->E1_PREFIXO+(cAliasSE1)->E1_NUM+(cAliasSE1)->E1_PARCELA+(cAliasSE1)->E1_TIPO)
					AAdd(aRegSE1,IIf(lQuery,(cAliasSE1)->SE1RECNO,(cAliasSE1)->(RecNo())))
				EndIf
			EndIf

			lCondVenda := .F.

		EndIf
		If lMa520SE1 .And. lRetorno
			ExecBlock("MA520SE1",.F.,.F.)
		Endif
		lPriParAdtBx := .F.
		nCountSE1++

		dbSelectArea(cAliasSE1)
		dbSkip()
	EndDo
	If lQuery
		dbSelectArea(cAliasSE1)
		dbCloseArea()
		dbSelectArea("SE1")
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a NFS gerou Imposto ICMS ST(Contas a Pagar)     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisloc=="BRA" .And. SF2->(FieldPos("F2_NFICMST"))>0
	If !Empty(SF2->F2_NFICMST)//Caso nao seja vazio, gerou imposto ICMS ST
		DbSelectArea("SE2")
		SE2->(DbsetOrder(1))//Indice E2_FILIAL+E2_PREFIXO+E2_NUM+E2_SERIE+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		SE2->(DbGoTop())
		If DbSeek(xFilial("SE2")+SF2->F2_NFICMST)
			Do While SE2->(!Eof()) .And. SE2->E2_PREFIXO+SE2->E2_NUM==SF2->F2_NFICMST
				//Se o titulo sofreu pagamento nao permitir excluir a NFS
				If !Empty(SE2->E2_BAIXA).And. SE2->E2_SALDO<>SE2->E2_VALOR .And. ALLTRIM(SE2->E2_TIPO)=="TX"
					cMensagem:=" Não é possível excluir esse documento pelo fato "+CHR(10)+CHR(13)
					cMensagem+="de que existe um título a pagar de imposto "+CHR(10)+CHR(13)
					cMensagem+="( "+SE2->E2_NUM+"/"+SE2->E2_PREFIXO+") baixado total ou parcialmente."+CHR(10)+CHR(13)
					cMensagem+="Para excluir esse documento, será necessário "+CHR(10)+CHR(13)
					cMensagem+="primeiramente estornar esse título através "+CHR(10)+CHR(13)
					cMensagem+="do módulo financeiro."
					Help(" ",1,"NAOEXCNFS","NAOEXCNFS",cMensagem,1,0)
					lRetorno := .F.
				ElseIf !Empty(SE2->E2_NUMBOR) .And. ALLTRIM(SE2->E2_TIPO)=="TX"
						cMensagem:=" Não é possível excluir esse documento pelo fato "+CHR(10)+CHR(13)
						cMensagem+="de que existe um título a pagar de imposto "+CHR(10)+CHR(13)
						cMensagem+="( "+SE2->E2_NUM+"/"+SE2->E2_PREFIXO+") em Borderô."+CHR(10)+CHR(13)
						cMensagem+="Para excluir esse documento, será necessário "+CHR(10)+CHR(13)
						cMensagem+="primeiramente estornar esse título através "+CHR(10)+CHR(13)
						cMensagem+="do módulo financeiro."
						Help(" ",1,"NAOEXCNFS","NAOEXCNFS",cMensagem,1,0)
						lRetorno := .F.
				Endif
				SE2->(DbSkip())
			End
		Endif
	Endif
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificando os itens do documento de Saida                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetorno
	dbSelectArea("SD2")
	dbSetOrder(3)
	#IFDEF TOP
		If TcSrvType()<>"AS/400"
			aStruSD2  := SD2->(dbStruct())
			cAliasSD2 := "MACANDELNF"
			lQuery    := .T.

			cQuery := "SELECT SD2.*,SD2.R_E_C_N_O_ SD2RECNO,SF4.F4_PODER3,SF4.F4_ESTOQUE "
			cQuery += "FROM "+RetSqlName("SD2")+" SD2,"
			cQuery += RetSqlName("SF4")+" SF4 "
			cQuery += "WHERE SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
			cQuery += "SD2.D2_SERIE='"+cSerie+"' AND "
			cQuery += "SD2.D2_DOC='"+cNumero+"' AND "
			cQuery += "SD2.D2_CLIENTE='"+cClieFor+"' AND "
			cQuery += "SD2.D2_LOJA='"+cLoja+"' AND "
			cQuery += "SD2.D2_TIPO='"+cTipo+"' AND "
			cQuery += "SD2.D_E_L_E_T_= ' ' AND "
			cQuery += "SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
			cQuery += "SF4.F4_CODIGO=SD2.D2_TES AND "
			cQuery += "SF4.D_E_L_E_T_= ' '"

			cQuery += "ORDER BY "+SqlOrder(SD2->(IndexKey()))

			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)

			For nX := 1 To Len(aStruSD2)
				If aStruSD2[nX][2] <> "C"
					TcSetField(cAliasSD2,aStruSD2[nX][1],aStruSD2[nX][2],aStruSD2[nX][3],aStruSD2[nX][4])
				EndIf
			Next nX
		Else
	#ENDIF
		MsSeek(xFilial("SD2")+cNumero+cSerie+cClieFor+cLoja)
	#IFDEF TOP
		EndIf
	#ENDIF
	While ( !Eof() .And. xFilial("SD2") == (cAliasSD2)->D2_FILIAL .And.;
			cNumero == (cAliasSD2)->D2_DOC .And.;
			cSerie == (cAliasSD2)->D2_SERIE .And.;
			cClieFor == (cAliasSD2)->D2_CLIENTE .And.;
			cLoja == (cAliasSD2)->D2_LOJA .And. lRetorno )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verificando se for remito de transferencia que ja teve entrada   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc !="BRA" .And. (cAliasSD2)->D2_TIPODOC == "54" .And. (cAliasSD2)->D2_QTDAFAT != (cAliasSD2)->D2_QUANT
			Help(" ",1,"NAOEXCLREM")
			lRetorno := .F.
			Exit
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verificando os embarques do modulo de exportacao - SIGAEEC     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasSD2)->(FieldPos("D2_PREEMB"))>0
			If !Empty((cAliasSD2)->D2_PREEMB) .And. NMODULO <> 29
				Help(" ",1,"MTA520DEL")
				lRetorno := .F.
				Exit
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verificando se este documento possui itens devolvidos          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasSD2)->D2_QTDEDEV <> 0 .Or. (cAliasSD2)->D2_VALDEV<>0
			Help(" ",1,"NAOEXCL")
			lRetorno := .F.
			Exit
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se eh um remito ja faturado (Localizacoes)            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasSD2)->D2_QTDEFAT > 0
			Help(" ",1,"NAOEXCLREM")
			lRetorno := .F.
			Exit
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se as notas não foram geradas pelo faturamento        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasSD2)->D2_ORIGLAN $ "LF|LO"
		    Aviso(OemtoAnsi(STR0011),OemtoAnsi(STR0012),{OemtoAnsi(STR0013)})
			lRetorno := .F.
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o Servico do WMS    						         	  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc <> "BRA" .And. !LocIntDCF(cAliasSD2,.F.)
			lRetorno := .F.
			Exit
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verificando os saldos do poder de terceiros                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lQuery
			dbSelectArea("SF4")
			dbSetOrder(1)
			MsSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)
		EndIf
		If (IIf(lQuery,(cAliasSD2)->F4_PODER3=="R",SF4->F4_PODER3=="R"))
			dbSelectArea("SB6")
			dbSetOrder(1)
			If MsSeek(xFilial("SB6")+(cAliasSD2)->D2_COD+cClieFor+cLoja+(cAliasSD2)->D2_IDENTB6)
				If SB6->B6_QUANT <> CalcTerc((cAliasSD2)->D2_COD,cClieFor,cLoja,(cAliasSD2)->D2_IDENTB6,(cAliasSD2)->D2_TES)[1]
					Help(" ",1,"A520NPODER")
					lRetorno := .F.
					Exit
				EndIf
			EndIf
		EndIf
		If (IIf(lQuery,(cAliasSD2)->F4_ESTOQUE=="S",SF4->F4_ESTOQUE=="S"))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o produto est  sendo inventariado  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If BlqInvent((cAliasSD2)->D2_COD,(cAliasSD2)->D2_LOCAL)
				Help(" ",1,"BLQINVENT",,(cAliasSD2)->D2_COD+" Almox: "+(cAliasSD2)->D2_LOCAL,1,11)
				lRetorno := .F.
				Exit
			EndIf
        EndIf
		If (SC9->(FieldPos("C9_NUMSEQ"))<>0 .And. !Empty(SC9->C9_NUMSEQ) )
			dbSelectArea("SC9")
			dbSetOrder(7)
			If MsSeek(xFilial("SC9")+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_LOCAL+(cAliasSD2)->D2_NUMSEQ) .And. SC9->C9_BLEST == "ZZ" .And. !Empty(SC9->C9_NUMSEQ)
				Help(" ",1,"A520NEST")
				lRetorno := .F.
				Exit
			EndIf
		EndIf
		If lRetorno
			If aScan(aLockSB2,(cAliasSD2)->D2_COD+(cAliasSD2)->D2_LOCAL)==0
				AAdd(aLockSB2,(cAliasSD2)->D2_COD+(cAliasSD2)->D2_LOCAL)
			EndIf
			If aScan(aLockSC5,(cAliasSD2)->D2_PEDIDO)==0
				AAdd(aLockSC5,(cAliasSD2)->D2_PEDIDO)
			EndIf
		EndIf
		AAdd(aRegSD2,IIf(lQuery,(cAliasSD2)->SD2RECNO,(cAliasSD2)->(RecNo())))
		dbSelectArea(cAliasSD2)
		dbSkip()
	EndDo
	If lQuery
		dbSelectArea(cAliasSD2)
		dbCloseArea()
		dbSelectArea("SD2")
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica os documentos de Origem                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SF2->(FieldPos("F2_NEXTSER"))<>0 .And. !Empty(SF2->F2_NEXTDOC)
	dbSelectArea("SF2")
	dbSetOrder(6)
	If MsSeek(xFilial("SF2")+SF2->F2_SERIE+SF2->F2_DOC)
		Help(" ",1,"MA521NFORI")
		lRetorno := .F.
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetuando o travamento dos registros                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetorno .And. !InTransact()
	If MultLock("SF2",{(cAlias)->F2_DOC+(cAlias)->F2_SERIE+(cAlias)->F2_CLIENTE+(cAlias)->F2_LOJA},1) .And.;
			MultLock("SB2",aLockSB2,1) .And.;
			MultLock("SC5",aLockSC5,1) .And.;
			MultLock("SE1",aLockSE1,2) .And.;
			MultLock("SE2",aLockSE2,1) .And.;
			MultLock(IIf((cAlias)->F2_TIPO$"DB","SA2","SA1"),{(cAlias)->F2_CLIENTE+(cAlias)->F2_LOJA},1)
	Else
		MsUnLockAll()
		lRetorno := .F.
	EndIf
EndIf

//Verifica se a factura esta "amarrada" a alguma solicitacao, caso esteja nao
//permite o seu cancelamento...
If lRetorno .And. (cPaisLoc <> "BRA") .And. SuperGetMv('MV_SOLNCP')
	aAreaSCU := SCU->(GetArea())
	SCU->(dbSetOrder(3))
	If SCU->(MsSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE))
		Help(" ",1,"MA055007")
		lRetorno :=	.F.
	EndIf
	RestArea(aAreaSCU)
EndIf

If lRetorno
	If ExistBlock("M521CDEL")
		lRetorno := ExecBlock("M521CDEL",.F.,.F.)
	Endif

	If lProcAdm
		lRetorno := T521Tela(SF2->F2_DOC,SF2->F2_SERIE,"     ",SF2->F2_CLIENTE,SF2->F2_LOJA,"S",SF2->F2_TIPO)
    EndIf

Endif

RestArea(aAreaSF2)
RestArea(aAreaSD2)
RestArea(aAreaSE2)
RestArea(aAreaSE1)
RestArea(aAreaSB6)
RestArea(aArea)
Return(lRetorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³MaDelNFS  ³ Rev.  ³Eduardo Riera          ³ Data ³30.12.2001	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Estorno da Preparacao dos Documentos de Saida              	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se o documento pode ser excluido              	³±±
±±³          ³                                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array com os Recnos do SD2                        (OPC)³±±
±±³          ³ExpA2: Array com os Recnos do SE1                        (OPC)³±±
±±³          ³ExpA3: Array com os Recnos do SE2                        (OPC)³±±
±±³          ³ExpL4: Mostra lancto contabil                            (OPC)³±±
±±³          ³ExpL5: Aglutina lancto contabil                          (OPC)³±±
±±³          ³ExpL6: Contabiliza On-Line                               (OPC)³±±
±±³          ³ExpL7: Pedido em carteira                                (OPC)³±±
±±³          ³ExpL8: Indica se estou apagando um remito                (OPC)³±±
±±³          ³ExpL9: Usado para o controle de localizacao fisica.           ³±±
±±³          ³       para forcar o parametro (MV_PDEVLOC)                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Norbert Waage³16/05/07³125161³Atualizacao do status do orcamento do     ³±±
±±³              ³        ³      ³Televendas(SIGATMK), apos exclusao da NF. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MaDelNfs(aRegSD2,aRegSE1,aRegSE2,lDigita,lAglutina,lContab,lCarteira,lRemito,nPDevLoc,cCodDiario)

Local aArea     := GetArea()
Local aCusto    := {}
Local aCT5      := {}
Local aSd2Carga := {}
Local aRotas    := {}
Local aPedido   := {}
Local nX        := 0
Local nHdlPrv   := 0
Local nTotalCtb := 0
Local nRegSF2   := 0
Local lQuery    := .F.
Local lMSd2520T := ExistTemplate("MSD2520")
Local lMSd2520  := ExistBlock("MSD2520")
Local lM521Cart := ExistBlock("M521CART")
Local lMs520Del := Existblock("MS520DEL")
Local lHeader   := .F.
Local lDetProva := .F.
Local lLctPad30 := VerPadrao("630")	// Credito de Estoque / Debito de C.M.V.
Local lLctPad35 := VerPadrao("635")	// Debito de Cliente  / Credito de Venda
Local lLctPad41 := VerPadrao("641") // Itens de rateio.
Local cLoteCtb  := ""
Local cArqCtb   := ""
Local c630      := Nil
Local c635      := Nil
Local c641      := Nil
Local cAliasSC9 := "SC9"
Local cDepTrf   := GetNewPar("MV_DEPTRANS","95")  // Dep.transferencia
Local lSelLote  := GetNewPar("MV_SELLOTE","2") == "1"
Local lFreteEmb := .F.
Local aAreaTmp
Local aAreaSC5
Local aAreaSC6
Local aAreaSC9
Local aAreaSD2
Local nPrcVen
#IFDEF TOP
	Local cQuery := ""
#ENDIF
Local cPedRem    := ""
Local cItPedRem  := ""
Local cSeqPedRem := ""
Local lRelibWMS  := (SuperGetMV('MV_WMSRELI', .F., '1')=='2')
Local cEndRelWms := ''
Local cEndAnt    := ''
Local cServAnt   := ''
Local cSeekSDB   := ''
Local cFilcar    := ""
Local cBlock     := 'Oms521Car(aSd2Carga,aRotas,cFilCar)'
Local bBlock     := {||.T.}
Local cRetPE     := ''
Local lContinua := .T.
//Gestao de Contratos
Local aContrato  := {}
Local aAreaSD1   := {}
Local aCtbDia    := {}
Local lCtbInTran := IIf(FindFunction("CTBINTRAN") .And. CTBINTRAN(0,.F.),.T.,.F.)	// Verifica se contabilizacao pode ser executada dentro da transacao
Local lIntACD	 := SuperGetMV("MV_INTACD",.F.,"0") == "1"
Local aEmpBN     := {}
Local lAtuSldNat := FindFunction("AtuSldNat") .AND. AliasInDic("FIV") .AND. AliasInDic("FIW")
Local aAreaAt	 := {}
Local lMontaVol  := SuperGetMV('MV_WMSVEMB',.F.,.F.)

//Venda Direta
Local lAuto		 := .F.
Local cFOrcPai 	 := ""
Local cNOrcPai	 := ""
Local aPedBkp	 := {}
Local lIntGC	 := IIf((SuperGetMV("MV_VEICULO",,"N")) == "S",.T.,.F.)

Local oMdl		 := Nil
Local oMdlCarga  := Nil
Local lIntGFE    := SuperGetMv("MV_INTGFE",,.F.)
Local cCarga	 := ""
Local cAliasSF2  := ""
Local aStruModel := {}
Local aFieldValue:= {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para e-Commerce      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lECommerce := SuperGetMV("MV_LJECOMM",,.F.) .AND. GetRpoRelease("R5")
Local aRegSC5    := {}     //Ira gravar s pedidos e-Commerce para liberar no final da rotina
Local lLiberOk   := .F.    //Variavel utilizada para liberar o pedido no final da rotina

DEFAULT lDigita    := .F.
DEFAULT lAglutina  := .F.
DEFAULT lContab    := .F.
DEFAULT lCarteira  := .T.
DEFAULT lRemito    := .F.
DEFAULT cCodDiario := ""
// PRIVATE lAnulaSF3  := .F.  //Determina se anula ou exclui o registro no Livro Fiscal(MaFisAtuSF3) - Localizacoes

lAnulaSF3  := IIf( Type("lAnulaSF3")=="U",.F.,lAnulaSF3)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se o parametro de Reliberacao do WMS (MV_WMSRELI) estiver ativo, ativa tb o parametro de Selecao de Lotes do Faturamento (MV_SELLOTE) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lSelLote := If(!lRelibWMS, lSelLote, .T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o documento foi contabilizado                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lContab .And. !Empty(SF2->F2_DTLANC)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o numero do lote contabil                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX5")
	dbSetOrder(1)
	If MsSeek(xFilial()+"09FAT")
		cLoteCtb := AllTrim(X5Descri())
	Else
		cLoteCtb := "FAT "
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa um execblock                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If At("EXEC",Upper(X5Descri())) > 0
		cLoteCtb := &(X5Descri())
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa o arquivo de contabilizacao                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nHdlPrv:=HeadProva(cLoteCtb,"CTBANFS",cUserName,@cArqCtb)
	If nHdlPrv <= 0
		HELP(" ",1,"SEM_LANC")
	Else
		lHeader := .T.
	EndIf
EndIf
If FindFunction("MaEnvEAI")
	oMdl := MaEnvEAI(,,5,"MATA521",,,.F.)
EndIf
Begin Transaction
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se for processo de adiantamento e o titulo estiver baixado   ³
	//³ exclui a compensacao                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP
		If cPaisLoc == "BRA" .and. FunName() = "MATA521A"
			If Len(aRegSE1) > 0
				If A410UsaAdi(SF2->F2_COND) .and. AliasInDic("FR3") .and. AliasInDic("FIE")
					SE1->(MsGoto(aRegSE1[1]))
					If SE1->(Recno()) = aRegSE1[1]
				//
				//		Criterio "!Empty(SE1->E1_BAIXA)" alterado:
				//		1- Exclusao da NFS sem baixa - Campo E1_BAIXA" esta com data
				//		2- Exclusao da NFS com cancelamento de baixa - Campo E1_BAIXA" esta vazio
				//		If !Empty(SE1->E1_BAIXA) .and. SE1->E1_VALOR != SE1->E1_SALDO
				//
						If SE1->E1_VALOR != SE1->E1_SALDO
							If !A521CCompAd(aRegSE1)
								Aviso(STR0007,STR0022 + CRLF + STR0023,{"Ok"}) //"Atenção"#"Não foi possível excluir a compensação associada ao título deste Documento de Saída."#"Não será possível excluir o Documento de Saída."
								DisarmTransaction()
								RestArea(aArea)

								Return(.F.)
							Endif
						Endif
					Endif
				Endif
			Endif
		// Para o Mexico faz a baixa simples ao inves da compensação pois não há título.
		ElseIf cPaisLoc == "MEX" .AND. A410UsaAdi(SF2->F2_COND) .AND. AliasInDic("FR3") .AND. AliasInDic("FIE")
			If !A521CBxAdt()
				Aviso("Atenção","Não foi possível excluir a baixa do adiantamento associado ao Documento de Saída." + CRLF + "Não será possível excluir o Documento de Saída.",{"OK"}) //"Atenção"#"Não foi possível excluir a baixa do adiantamento associado ao Documento de Saída."#"Não será possível excluir o Documento de Saída."#OK
				DisarmTransaction()
				RestArea(aArea)
				Return(.F.)
			Endif
		Endif
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a NFS gerou Imposto ICMS ST                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc=="BRA"
		DbSelectArea("SE2")
		SE2->(DbsetOrder(1))//Indice E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		SE2->(DbGoTop())
		If SF2->(FieldPos("F2_NFICMST"))>0 .AND. !Empty(SF2->F2_NFICMST)//Caso nao seja vazio, gerou imposto ICMS ST
			If DbSeek(xFilial("SE2")+SF2->F2_NFICMST)
				Do While SE2->(!Eof()).And. SE2->E2_PREFIXO+SE2->E2_NUM==SF2->F2_NFICMST
						If SE2->E2_ORIGEM=="MATA460A" .And. Alltrim(SE2->E2_TIPO)=="TX"
							RecLock("SE2")
							SE2->(dbDelete())
							SE2->(MsUnLock())
						Endif
					SE2->(DbSkip())
				End
			Endif
		EndIf
		If SF2->(FieldPos("F2_NTFECP"))>0 .AND. !Empty(SF2->F2_NTFECP)//Caso nao seja vazio, gerou imposto ICMS ST
			If DbSeek(xFilial("SE2")+SF2->F2_NTFECP)
				Do While SE2->(!Eof()).And. SE2->E2_PREFIXO+SE2->E2_NUM==SF2->F2_NTFECP
						If SE2->E2_ORIGEM=="MATA460A" .And. Alltrim(SE2->E2_TIPO)=="TX"
							RecLock("SE2")
							SE2->(dbDelete())
							SE2->(MsUnLock())
						Endif
					SE2->(DbSkip())
				End
			Endif
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclusão dos Titulos gerados pela TPDP - PB   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If DbSeek(xFilial("SE2")+SF2->F2_SERIE+SF2->F2_DOC) .And. Alltrim(SE2->E2_NATUREZ)=="TPDP"
			Do While SE2->(!Eof()).And. SE2->E2_PREFIXO+SE2->E2_NUM==SF2->F2_SERIE+SF2->F2_DOC
				If AllTrim(SE2->E2_ORIGEM)=="MATA460" .And. Alltrim(SE2->E2_TIPO)=="TX" .And. Alltrim(SE2->E2_NATUREZ)=="TPDP"
					RecLock("SE2")
					SE2->(dbDelete())
					SE2->(MsUnLock())
				Endif
				SE2->(DbSkip())
			End
		EndIf
	Endif
	If ExistTemplate("GEMXEXCON",,.T.)
		ExecTemplate("GEMXEXCON",.F.,.F.,{aRegSD2,aRegSE1})
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona Registros                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF2")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a NFS gerou Guia ICMS ST                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SF6")
	SF6->(DbsetOrder(3))//Indice F6_FILIAL+F6_OPERNF+F6_TIPODOC+F6_DOC+F6_SERIE+F6_CLIFOR+F6_LOJA
	SF6->(DbGoTop())
	If DbSeek(xFilial("SF6")+"2"+SF2->F2_TIPO+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	   While !SF6->(Eof()) .AND. xFilial("SF6") == SF2->F2_FILIAL .AND. SF6->F6_OPERNF=="2" .AND.;
		SF6->F6_TIPODOC == SF2->F2_TIPO .AND. SF6->F6_DOC== SF2->F2_DOC .AND.;
		SF6->F6_SERIE == SF2->F2_SERIE .AND. SF6->F6_CLIFOR==SF2->F2_CLIENTE .AND.;
		SF6->F6_LOJA==SF2->F2_LOJA
			RecLock("SF6")
			SF6->(dbDelete())
			SF6->(MsUnLock())
	   		SF6->(DbSkip())
		EndDo
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a NFS gerou Complemento da Guia                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc=="BRA".And. SF2->(FieldPos("F2_NFICMST"))>0
		If ChkFile("CDC")
			DbSelectArea("CDC")
			CDC->(DbSetOrder(1))//Indice CDC_FILIAL+CDC_TPMOV+CDC_DOC+CDC_SERIE+CDC_CLIFOR+CDC_LOJA+CDC_GUIA+CDC_UF
			If DbSeek(xFilial("CDC")+"S"+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_NFICMST+SF2->F2_EST)
				RecLock("CDC")
				CDC->(dbDelete())
				CDC->(MsUnLock())
			Endif
		Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclusao da tabela CDL (Complemento de Exportacao) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ChkFile("CDL")
			aAreaAt:=GetArea()
			DbSelectArea("CDL")
			CDL->(DbSetOrder(1))
			If DbSeek(xFilial("CDL")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)//+SF2->F2_NFICMST+SF2->F2_EST)
				While !Eof() .And. xFilial("CDL")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA ==;
			    		CDL_FILIAL+CDL_DOC+CDL_SERIE+CDL_CLIENT+CDL_LOJA
					RecLock("CDL")
					CDL->(dbDelete())
					CDL->(MsUnLock())
					CDL->(DbSkip())
				EndDo
			Endif
			RestArea(aAreaAt)
		Endif
	Endif
	dbSelectArea("SF2")
	If SF2->F2_TIPO$"DB"
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
	Else
		dbSelectArea("SA1")
		dbSetOrder(1)
		MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa os lancamentos contabeis ( 635 ) - Cabecalho         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lLctPad35 .And. lHeader
		lDetProva := .T.
		nTotalCtb += DetProva(nHdlPrv,"635","MATA520",cLoteCtb,,,,,@c635,@aCT5)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cancelamento dos titulos financeiros gerados                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len(aRegSE1)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona nos titulos financeiros                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SE1->(MsGoto(aRegSE1[nX]))
		FaAvalSE1(2,"MATA520",,nX)
		If lAtuSldNat
			AtuSldNat(SE1->E1_NATUREZ, SE1->E1_VENCREA, SE1->E1_MOEDA, If(SE1->E1_TIPO$MVRECANT+"/"+MV_CRNEG,"3","2"), "R", SE1->E1_VALOR, SE1->E1_VLCRUZ, If(SE1->E1_TIPO$MVABATIM,"+","-"),,FunName(),"SE1", SE1->(Recno()),0)
		Endif
		RecLock("SE1")
		SE1->(dbDelete())
		FaAvalSE1(3,"MATA520")
	Next nX
	For nX := 1 To Len(aRegSE2)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona nos titulos financeiros                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SE2->(MsGoto(aRegSE2[nX]))
		FaAvalSE2(2,"MATA520")
		RecLock("SE2")
		SE2->(dbDelete())
		FaAvalSE2(3,"MATA520")
	Next nX
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cancelamento dos itens do documento de saida                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len(aRegSD2)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona registros                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SD2->(MsGoto(aRegSD2[nX]))
		RecLock( "SD2", .F. )

		If aScan(aPedBkp,SD2->D2_PEDIDO) == 0
			aAdd(aPedBkp,SD2->D2_PEDIDO)
		EndIf

		dbSelectArea("SF4")
		dbSetOrder(1)
		MsSeek(xFilial("SF4")+SD2->D2_TES)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga movimentacao no SD3 Qdo Documento de transferencica       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc != "BRA" .And. SD2->D2_TIPODOC == '54'
			SD3->(DbSetOrder(3))   //D3_FILIAL+D3_COD+D3_LOCAL+D3_NUMSEQ
			If SD3->(MsSeek(xFilial('SD3')+SD2->D2_COD+cDepTrf+SD2->D2_NUMSEQ))
				If !(FindFunction("LocTranSB2") .And. LocTranSB2(2))
					// Apaga transferencia RE4
					RecLock("SD3",.F.)
					DbDelete()
					MsUnlock()
				EndIf
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza saldo no armazem de poder de terceiros                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If FindFunction("TrfSldPoder3")
			TrfSldPoder3(SD2->D2_TES,"SD2",SD2->D2_COD,.T.)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estorna os dados vinculados ao Pedido de venda                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SD2->D2_PEDIDO) .And. Iif(cPaisloc=="BRA",Empty(SF2->F2_NFORI),.T.)
			dbSelectArea("SC5")
			dbSetOrder(1)
			MsSeek(xFilial("SC5")+SD2->D2_PEDIDO)

			RecLock("SC5")
			MaAvalSC5("SC5",6)

			dbSelectArea("SC6")
			dbSetOrder(1)
			MsSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)

			RecLock("SC6")
			MaAvalSC6("SC6",6,"SC5",,,,,,,,"SD2",lRemito)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Integracao com Average                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If GetNewPar("MV_EECFAT",.F.)
				If FindFunction("AE100STATUS")
					AE100STATUS(SC5->C5_PEDEXP,SC5->C5_NUM)
				EndIf
			EndIf

			If !Empty(SF2->F2_CARGA) .And. !Empty(SF2->F2_SEQCAR)
				AAdd(aSd2Carga,{SD2->D2_PEDIDO, SD2->D2_ITEMPV, SD2->D2_COD, SF2->F2_CARGA, SF2->F2_SEQCAR, SC6->C6_ENDPAD, "3", SF2->F2_SEQENT })
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Estorno dos itens do pedido liberado                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SC9")
			dbSetOrder(1)
			#IFDEF TOP
				If TcSrvType()<>"AS/400"
					cAliasSC9 := "MADELNFS"
					lQuery    := .T.
					cQuery := "SELECT C9_FILIAL,C9_PEDIDO,C9_ITEM,C9_PRODUTO,C9_BLCRED,C9_BLEST,C9_REMITO,C9_SEQUEN,C9_ITEMREM,C9_NFISCAL,C9_SERIENF,C9_BLOQUEI"+Iif(SC9->(FieldPos("C9_IDDCF")) > 0,",C9_IDDCF","")+",C9_CARGA,R_E_C_N_O_ SC9RECNO "
					cQuery += "FROM "+RetSqlName("SC9")+" SC9 "
					cQuery += "WHERE SC9.C9_FILIAL='"+xFilial("SC9")+"' AND "
					cQuery += "SC9.C9_PEDIDO='"+SD2->D2_PEDIDO+"' AND "
					cQuery += "SC9.C9_ITEM='"+SD2->D2_ITEMPV+"' AND "
					cQuery += "SC9.C9_PRODUTO='"+SD2->D2_COD+"' AND "
					If cPaisLoc == "BRA" .Or. !IsRemito(1,'SD2->D2_TIPODOC')
						cQuery += "SC9.C9_NFISCAL='"+SD2->D2_DOC+"' AND "
						cQuery += "SC9.C9_SERIENF='"+SD2->D2_SERIE+"' AND  "
					Else
						cQuery += "SC9.C9_REMITO ='"+SD2->D2_DOC+"' AND "
						cQuery += "SC9.C9_SERIREM='"+SD2->D2_SERIE+"' AND  "
					Endif
					cQuery += "SC9.D_E_L_E_T_=' ' "
					cQuery += "ORDER BY "+SqlOrder(SC9->(IndexKey()))

					cQuery := ChangeQuery(cQuery)

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC9,.T.,.T.)

				Else
			#ENDIF
					MsSeek(xFilial("SC9")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
			#IFDEF TOP
				EndIf
			#ENDIF
			While !Eof() .And. xFilial("SC9") == (cAliasSC9)->C9_FILIAL .And.;
					SD2->D2_PEDIDO == (cAliasSC9)->C9_PEDIDO .And.;
					SD2->D2_ITEMPV == (cAliasSC9)->C9_ITEM

				If SD2->D2_COD == (cAliasSC9)->C9_PRODUTO

					If  lECommerce

      					SC5->(dbSetOrder(1))
						If  SC5->(dbSeek(xFilial("SC5")+(cAliasSC9)->C9_PEDIDO))

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Caso seja pedido e-Commerce não excluirá o SC9.                          ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					    	If !( Empty(SC5->C5_ORCRES) ) .AND. SL1->( FieldPos("L1_ECFLAG") > 0 ) .AND. (Posicione("SL1",1,xFilial("SL1")+SC5->C5_ORCRES,"L1_ECFLAG")=="1") .And. (Ascan(aRegSC5, SC5->(Recno())) <= 0)
						    	aadd(aRegSC5, SC5->(Recno()))
							EndIf
						EndIf
					EndIf

					SC6->(dbSetOrder(1))
					SC6->(dbSeek(xFilial("SC6")+(cAliasSC9)->(C9_PEDIDO+C9_ITEM+C9_PRODUTO)))

					aEmpBN := If(FindFunction("A410CarBen"),A410CarBen(SC9->C9_PEDIDO,SC9->C9_ITEM),{})
					If !Empty(aEmpBN)
						A410LibBen(2,aEmpBN[1,1],aEmpBN[1,2],SC9->C9_QTDLIB,SC9->C9_QTDLIB2)
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Atualiza o campo B2_QEMPN  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					FatAtuEmpN("+",.T.,cAliasSC9)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Para as notas fiscais sem remito³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (cAliasSC9)->C9_BLCRED=="10" .And. (cAliasSC9)->C9_BLEST=="10" .And. Empty(SD2->D2_REMITO) .And.;
						SD2->D2_DOC == (cAliasSC9)->C9_NFISCAL .And. SD2->D2_SERIE == (cAliasSC9)->C9_SERIENF
						If lQuery
							SC9->(MsGoto((cAliasSC9)->SC9RECNO))
						EndIf

						If lMontaVol .And. FindFunction('TMSChkVer') .And. TMSChkVer('11','R5')
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Estorna montagem de Volume      ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If !Empty((cAliasSC9)->C9_IDDCF) .And. FindFunction('Wma390EstN') .And. AliasIndic('DCS') .And. AliasIndic('DCT') .And. AliasIndic('DCU') .And. AliasIndic('DCV')
								Wma390EstN (IIf(!Empty((cAliasSC9)->C9_CARGA),(cAliasSC9)->C9_CARGA,(cAliasSC9)->C9_PEDIDO),(cAliasSC9)->C9_PRODUTO,(cAliasSC9)->C9_IDDCF,IIf(!Empty((cAliasSC9)->C9_CARGA),'2','1'),(cAliasSC9)->C9_SEQUEN)
							EndIf
						EndIf

						RecLock("SC9")
						MaAvalSC9("SC9",12)
						SC9->(dbDelete())
						MsUnLock()

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Para as notas fiscais com remito previo, so limpar os campos de bloqueio ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ElseIf (cAliasSC9)->C9_BLCRED=="10" .And. (cAliasSC9)->C9_BLEST=="10" .And. !Empty(SD2->D2_REMITO).And.;
						SD2->D2_DOC == (cAliasSC9)->C9_NFISCAL .And. SD2->D2_SERIE == (cAliasSC9)->C9_SERIENF
						If lQuery
							SC9->(MsGoto((cAliasSC9)->SC9RECNO))
						EndIf

						RecLock("SC9")
						C9_BLEST	:=	Space(Len(C9_BLEST  ))
						C9_BLCRED	:=	Space(Len(C9_BLCRED ))
						C9_NFISCAL	:=	Space(Len(C9_NFISCAL))
						C9_SERIENF	:=	Space(Len(C9_SERIENF))
						MsUnLock()
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Para os remitos.   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ElseIf Empty((cAliasSC9)->C9_BLCRED+(cAliasSC9)->C9_BLEST) .And.;
						(cAliasSC9)->C9_REMITO+(cAliasSC9)->C9_ITEMREM+(cAliasSC9)->C9_SEQUEN == SD2->D2_DOC+SD2->D2_ITEM+SD2->D2_SEQUEN

						If lQuery
							SC9->(MsGoto((cAliasSC9)->SC9RECNO))
						EndIf

						RecLock("SC9")
						MaAvalSC9("SC9",12,,,,,,,,.T.)
						SC9->(dbDelete())
						MsUnLock()
					Endif
					If	IntDL(SC9->C9_PRODUTO) .And. !Empty(SC9->C9_SERVIC) .And. FindFunction("WmsAtzSDB")
						WmsAtzSDB('6')
					EndIf
				EndIf
				dbSelectArea(cAliasSC9)
				dbSkip()
			EndDo
			If lQuery
				dbSelectArea(cAliasSC9)
				dbCloseArea()
				dbSelectArea("SC9")
			EndIf
		ElseIf !Empty(SD2->D2_REMITO)
			aAreaTmp	:=	GetArea()
			aAreaSD2	:=	SD2->(GetArea())
			SD2->(DbSetOrder(3))
			cPedRem		:= ""
			cItPedRem	:= ""
			cSeqPedRem	:= ""
			If SD2->(MSSeek(xFilial("SD2")+SD2->D2_REMITO+SD2->D2_SERIREM+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_ITEMREM))
				cPedRem		:= SD2->D2_PEDIDO
				cItPedRem	:= SD2->D2_ITEMPV
				cSeqPedRem	:= SD2->D2_SEQUEN
			Endif
			RestArea(aAreaSD2)
			If !Empty(cPedRem)
				aAreaSC5	:=	SC5->(GetArea())
				SC5->(DbSetOrder(1))
				If SC5->(MSSeek(xFilial("SC5")+cPedRem))

					RecLock("SC5")
					MaAvalSC5("SC5",6)

					aAreaSC6 :=	SC6->(GetArea())
					SC6->(dbSetOrder(1))
					If SC6->( MsSeek(xFilial("SC6")+cPedRem+cItPedRem+SD2->D2_COD) )
						RecLock("SC6")
						MaAvalSC6("SC6",6,"SC5",,,,,,,,"SD2",lRemito)

						aAreaSC9	:=	SC9->(GetArea())
						SC9->(DBSetOrder(1))
						If SC9->(MSSeek(xFilial("SC9")+cPedRem+cItPedRem+cSeqPedRem+SD2->D2_COD, .F.))
								AtuSA1Nf('SF2','SD2',SD2->D2_TIPO,'C',.T.,.T.,-1)
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Para as notas fiscais com remito previo, so limpar os campos de bloqueio ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								RecLock("SC9")
								C9_BLEST	:=	Space(Len(C9_BLEST  ))
								C9_BLCRED	:=	Space(Len(C9_BLCRED ))
								C9_NFISCAL	:=	Space(Len(C9_NFISCAL))
								C9_SERIENF	:=	Space(Len(C9_SERIENF))
								MsUnLock()
							Endif
							RestArea(aAreaSC9)
						EndIf
						RestArea(aAreaSC6)
					Endif
					RestArea(aAreaSC5)
				Endif
			RestArea(aAreaTMP)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estorna os dados referentes a devolucao de compra              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SF2->F2_TIPO == "D"
			dbSelectArea("SD1")
			dbSetOrder(1)
			If MsSeek(xFilial("SD1")+SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_ITEMORI)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ13ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Estorna da baixa do CQ                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//				MaCQ2SD2(.T.)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Estorna o item da nota fiscal de entrada                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				RecLock("SD1")
				SD1->D1_QTDEDEV := Max(0,SD1->D1_QTDEDEV-SD2->D2_QUANT)
				SD1->D1_VALDEV  := Max(0,SD1->D1_VALDEV-SD2->D2_TOTAL)
				MsUnLock()

				If cPaisLoc <> "BRA"   //SOMENTE LOCALIZACOES
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Estorna tambem os campos QTDEDEV e VALDEV das notas ou remitos associados        ³
					//³aa nota ou remito original aqui posicionado.                                     ³
					//³Isso garante que futuras notas de credito ou remitos de devolucao considerem o   ³
					//³saldo a devolver corretamente.                                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If "MATA102" $ Funname()
						// Pesquisa pela nota gerada pelo remito original
						cSeekSD1 := SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_ITEM
						DBSelectArea("SD1")
						DBSetOrder(10)
						If MsSeek(xFilial("SD1")+cSeekSD1 ,.F.)
							RecLock("SD1", .F.)
							SD1->D1_QTDEDEV := Max(0,SD1->D1_QTDEDEV-SD2->D2_QUANT)
							SD1->D1_VALDEV  := Max(0,SD1->D1_VALDEV-SD2->D2_TOTAL)
							MsUnlock()
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Na exclusao de uma devolucao de remito de entrada, atualiza a quantida-³
						//³ a classificar do remito de entrada.                                    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If SD2->D2_TIPODOC == "61" .And. Alltrim(SD2->D2_ESPECIE) == "RCD"
							aAreaSD1 := SD1->(GetArea())
							DBSelectArea("SD1")
							DBSetOrder(1)
							If MsSeek(xFilial("SD1")+SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_ITEMORI)
								RecLock("SD1",.F.)
								SD1->D1_QTDACLA := SD1->D1_QTDACLA + SD2->D2_QUANT
								MsUnLock()
							EndIf
							RestArea(aAreaSD1)
						EndIf
					Elseif "MATA466" $ Funname()
						// Pesquisa, se houver, o remito vinculado aa nota original
						If !Empty( SD1->D1_REMITO + SD1->D1_SERIREM )
							cSeekSD1 := SD1->D1_REMITO+SD1->D1_SERIREM+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEMREM
							DBSelectArea("SD1")
							DBSetOrder(1)
							If MsSeek(xFilial("SD1")+cSeekSD1 ,.F.)
								RecLock("SD1", .F.)
								SD1->D1_QTDEDEV := Max(0,SD1->D1_QTDEDEV-SD2->D2_QUANT)
								SD1->D1_VALDEV  := Max(0,SD1->D1_VALDEV-SD2->D2_TOTAL)
								MsUnlock()
							EndIf
						EndIf
					EndIf
				EndIf
				If ( lLctPad30 .And. lLctPad41 .And. lHeader )
					dbSelectArea("SDE")
					dbSetOrder(1)
					MsSeek(xFilial("SDE")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM)
					While ( !Eof() .And. ;
							xFilial("SDE") == SDE->DE_FILIAL .And.;
							SD1->D1_DOC == SDE->DE_DOC .And.;
							SD1->D1_SERIE == SDE->DE_SERIE .And.;
							SD1->D1_FORNECE == SDE->DE_FORNECE .And.;
							SD1->D1_LOJA == SDE->DE_LOJA .And.;
							SD1->D1_ITEM == SDE->DE_ITEMNF)

						nTotalCtb += DetProva(nHdlPrv,"641","MATA520",cLoteCtb,,,,,@c641,@aCT5)

						dbSelectArea("SDE")
						dbSkip()
					EndDo
				EndIf
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estorno dos lancamentos de Poder de Terceiro                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SF4->F4_PODER3<>"N"
			MaAtuSB6("SD2",4)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Estorna os arquivos de Gerenciamento de Projetos - 2:Estorno,3:Exclusao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If IntePms()		// Integracao PMS
			PmsWriteD2(2,"SD2")     // Estorna os custos no Projeto AF9/AFJ.
			PMsWriteD2(3,"SD2")    //  Deleta na tabela "AFS".
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estorno das Demandas                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SF4->F4_ESTOQUE == "S" .And. (Empty(SD2->D2_REMITO).Or.SD2->D2_TPDCENV $ "1A")
			If !(SD2->D2_TIPO $ "DBCIP")
				dbSelectArea("SB3")
				dbSetOrder(1)
				If ( MsSeek(xFilial("SB3")+SD2->D2_COD) )
					RecLock("SB3")
				Else
					RecLock("SB3",.T.)
					SB3->B3_FILIAL := xFilial("SB3")
					SB3->B3_COD    := SD2->D2_COD
				EndIf
				FieldPut(FieldPos("B3_Q"+StrZero(Month(SD2->D2_EMISSAO),2)),FieldGet(FieldPos("B3_Q"+StrZero(Month(SD2->D2_EMISSAO),2)))-SD2->D2_QUANT)
				SB3->B3_MES := SD2->D2_EMISSAO
				MsUnLock()
			EndIf
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa os lancamentos contabeis ( 635 ) - Cabecalho         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lLctPad30 .And. lHeader
			dbSelectArea("SB1")
			dbSetOrder(1)
			MsSeek(xFilial("SB1")+SD2->D2_COD)
			lDetProva := .T.
			nTotalCtb += DetProva(nHdlPrv,"630","MATA520",cLoteCtb,,,,,@c630,@aCT5)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estorno de carga do OMS                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SF2->F2_CARGA)
			aRotas := {}
			OsAvalDAI("DAI",3,@aRotas,.F.,,@cFilcar,@oMdlCarga)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estorno da transferencia da base instalada - Field Service     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SF4->F4_ESTOQUE == "S" .And. SF4->F4_ATUTEC == "S"
			MaEstNfAA3()
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui a amarracao com os conhecimentos                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MsDocument( "SF2", SF2->( RecNo() ), 2, , 3 )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PcoDetLan("000101","01","MATA520",.T.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui a Nota Fiscal - antes de atualizar o estoque por causa  ³
		//³ da INTEGRIDADE REFERENCIAL - NAO REMOVER ESTA ORDEM            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SD2->(dbDelete())
		SD2->(FkCommit())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estorno do estoque baixado na Saida                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SF4->F4_ESTOQUE == "S" .And. (Empty(SD2->D2_REMITO).Or.SD2->D2_TPDCENV $ "1A")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Armazena a tes original para integridade referencial pois      ³
			//³ a tes eh trocada para uma de entrada para o estorno da nota    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aCusto      := PegaCusD2()
			SB2->(B2AtuComD2(aCusto,1,,Iif(cPaisLoc <> "BRA",!Empty(SD2->D2_PEDIDO).Or.(nPDevLoc == 1.And.Localiza(SD2->D2_COD)),Nil),nPDevLoc,,.T.))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Volta a TES original para a integridade referencial validar    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Estorna o Servico do WMS (DCF)                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc <> "BRA"
			LocIntDCF('SD2',.T.)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Estorna saldo do contrato SIGAGCT                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SC6->( FieldPos("C6_ITEMED") ) > 0 .And. !Empty(SC6->C6_ITEMED)
			CtaAvalGCT(2,aContrato,SC5->C5_MDCONTR,SC5->C5_MDPLANI,SC6->C6_ITEMED,SD2->D2_QUANT,,SC5->C5_MDNUMED,SD2->D2_TOTAL)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o orcamento do Televendas, se foi originado a partir³
		//³dele no modulo Call Center (SIGATMK)                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SD2->D2_PEDIDO)
			TkAtuTlv(SD2->D2_PEDIDO,1)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Integracao com o ACD		  				  	  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lIntACD .And. FindFunction("CBMSD2520")
			cRetPE := CBMSD2520()
			cBlock += If(ValType(cRetPE)=="C",cRetPE,"")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa execblock                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf	lMSd2520T
			cRetPE := ExecTemplate("MSD2520",.F.,.F.)
			cBlock += If(ValType(cRetPE)=="C",cRetPE,"")
		EndIf

		If nModulo == 72
			KEXF850()
		EndIf

		If	lMSd2520
			ExecBlock("MSD2520",.F.,.F.)
		EndIf

		//-- CodBlock a ser avaliado na gravacao do SC9
		bBlock := &('{||'+cBlock+'}')

		If lM521Cart
			lCarteira := ExecBlock("M521CART",.F.,.F.)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Liberar pedido de venda                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lCarteira .And. !Empty(SD2->D2_PEDIDO) .And. Empty(SD2->D2_REMITO) .And. Iif(cPaisloc=="BRA",Empty(SF2->F2_NFORI),.T.)
			If lSelLote

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Procura o ultimo endereco do Produto antes do faturamento      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cEndRelWms := ''
				If IntDL(SD2->D2_COD) .And. lRelibWMS
					SDB->(dbSetOrder(1)) //-- DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
					If SDB->(MsSeek(cSeekSDB:=xFilial('SDB')+SD2->D2_COD+SD2->D2_LOCAL+SD2->D2_NUMSEQ, .F.))
						Do While !SDB->(Eof()) .And. cSeekSDB == SDB->DB_FILIAL+SDB->DB_PRODUTO+SDB->DB_LOCAL+SDB->DB_NUMSEQ
							If SDB->DB_ESTORNO == 'S' .And. SDB->DB_ATUEST = 'S' .And. SDB->DB_TM <= '500'
								cEndRelWms := SDB->DB_LOCALIZ
								Exit
							EndIf
							SDB->(dbSkip())
						EndDo
					EndIf
				EndIf

				RecLock("SC6")
				nPrcVen         := SC6->C6_PRCVEN
				SC6->C6_LOTECTL := SD2->D2_LOTECTL
				SC6->C6_NUMLOTE := SD2->D2_NUMLOTE
				SC6->C6_LOCALIZ := SD2->D2_LOCALIZ
				SC6->C6_DTVALID := SD2->D2_DTVALID
				SC6->C6_NUMSERI := SD2->D2_NUMSERI
				SC6->C6_POTENCI := SD2->D2_POTENCI
				SC6->C6_PRCVEN  := ( (SD2->D2_TOTAL+SD2->D2_DESCZFR) / SD2->D2_QUANT)
				SC6->C6_PRCVEN  := xmoeda(SC6->C6_PRCVEN,SF2->F2_MOEDA,SC5->C5_MOEDA,SF2->F2_EMISSAO,TamSX3("D2_PRCVEN")[2])


				If !Empty(cEndRelWms)
					cEndAnt  := SC6->C6_LOCALIZ
					cServAnt := SC6->C6_SERVIC
					Replace SC6->C6_LOCALIZ With cEndRelWms
					Replace SC6->C6_SERVIC  With ''
				EndIf

				MaLibDoFat(SC6->(RecNo()),SD2->D2_QUANT,.T.,.F.,.F.,.T.,.T.,.F.,,bBlock)

				SC6->C6_LOTECTL := ''//aSaldos[nX][1]
				SC6->C6_NUMLOTE := ''//aSaldos[nX][2]
				SC6->C6_LOCALIZ := ''//aSaldos[nX][3]
				SC6->C6_NUMSERI := ''//aSaldos[nX][4]
				SC6->C6_DTVALID := Ctod('')//aSaldos[nX][7]
				SC6->C6_POTENCI := 0//aSaldos[nX][6]
				SC6->C6_PRCVEN  := nPrcVen

				If !Empty(cEndRelWms)
					Replace SC6->C6_LOCALIZ With cEndAnt
					Replace SC6->C6_SERVIC  With cServAnt
					cEndAnt    := ''
					cServAnt   := ''
					cEndRelWms := ''
				EndIf

			Else
				MaLibDoFat(SC6->(RecNo()),SD2->D2_QUANT,.T.,.F.,.F.,.T.,.T.,.F.,,bBlock)
			EndIf
			If aScan(aPedido,SD2->D2_PEDIDO)==0
				AAdd(aPedido,SD2->D2_PEDIDO)
			EndIf
		EndIf
	Next nX
	If lFreteEmb .And. !Empty(SF2->F2_CARGA) .And. !Empty(SF2->F2_SEQCAR)
		dbSelectArea("DAS")
		dbSetOrder(1)
		If MsSeek(xFilial("DAS")+SF2->F2_CARGA+SF2->F2_SEQCAR)
			OmsRatFre(SF2->F2_CARGA,SF2->F2_SEQCAR,Val(DAS->DAS_RATFRE),DAS->DAS_VALFRE,DAS->DAS_FREAUT)
			OmsFretPV(SF2->F2_CARGA,SF2->F2_SEQCAR,3)
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estorna os Livros Fiscais                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaFisAtuSF3(2,"S",SF2->(RecNo()))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estorna Registro da tabela CDA se houver                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MAFISCDA(,,.T.,SF2->("S"+F2_ESPECIE+"S"+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA),"S","SF2")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoDetLan("000101","02","MATA521",.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estorna caucoes do Gestao de Contratos - SIGAGCT               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If len(aContrato) > 0
		CtaAbatCauc(2,aContrato[1], aRegSE1, SF2->F2_CLIENTE, SF2->F2_LOJA, SF2->F2_DOC, SF2->F2_SERIE, NIL, SF2->F2_VALBRUT )
	EndIf

	If AliasInDic("AGH")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Rotina para tratar a exclusao do rateio de itens da nota fiscal de saida.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAreaRat := GetArea()
		dbSelectArea("AGH")
		AGH->(dbSetOrder(1)) 	//AGH_FILIAL+AGH_NUM+AGH_SERIE+AGH_FORNEC+AGH_LOJA+AGH_ITEMPD+AGH_ITEM
		If AGH->(dbSeek(xFilial("AGH") + SF2->F2_DOC + SF2->F2_SERIE +  SF2->F2_CLIENTE  + SF2->F2_LOJA ))
			While AGH->(!Eof()) .And. AGH->(AGH_FILIAL+AGH_NUM+AGH_SERIE+AGH_FORNEC+AGH_LOJA) == xFilial("AGH") + SF2->F2_DOC + SF2->F2_SERIE +  SF2->F2_CLIENTE  + SF2->F2_LOJA
				RecLock("AGH",.F.)
				AGH->(dbDelete())
				MsUnLock()
				AGH->(dbSkip())
			EndDo
		EndIf
		RestArea(aAreaRat)
	EndIf

	If lMs520Del
		ExecBlock("MS520DEL",.F.,.F.)
	EndIf

	//Elimina a Nota Fiscal do SIGAGFE
	//se integração com o mesmo estiver ativa
	If !MATA521IPG()
		DisarmTransaction()
		lContinua := .F.
	EndIf

	If lContinua
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui a Nota Fiscal                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("SF2")
		SF2->(dbDelete())
		MsUnLock()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui o cabecalho da carga conforme integridade               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SF2->F2_CARGA)
			OsAvalDAI("DAI",4,,,,cFilcar,@oMdlCarga)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza a Nota de Origem                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SF2->(FieldPos("F2_NEXTSER"))<>0 .And. !Empty(SF2->F2_NFORI)
			nRegSF2 := SF2->(RecNo())
			dbSelectArea("SF2")
			dbSetOrder(6)
			If !MsSeek(xFilial("SF2")+SF2->F2_SERIORI+SF2->F2_NFORI)
				SF2->(MsGoTo(nRegSF2))
				dbSelectArea("SF2")
				dbSetOrder(1)
				If MsSeek(xFilial("SF2")+SF2->F2_NFORI+SF2->F2_SERIORI)
					RecLock("SF2")
					SF2->F2_NEXTDOC := ""
					SF2->F2_NEXTSER := ""
					MsUnLock()
				EndIf
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha os lancamentos contabeis                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aPedido)
			MaLiberOk(aPedido)
		EndIf

		If lCtbInTran
			If lHeader
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Fecha os lancamentos contabeis                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lHeader   := .F.
				RodaProva(nHdlPrv,nTotalCtb)
				If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
					If Empty(cCodDiario)
						cCodDiario :=CtbaVerdia()
					EndIf
					aCtbDia := {{"SF2",SF2->(RECNO()),cCodDiario,"F2_NODIA","F2_DIACTB"}}
				EndIF
				cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,lDigita,lAglutina,,,,,,aCtbDia)
			EndIf
		EndIf
	EndIf
End Transaction

If lContinua
	If !lCtbInTran
		If lHeader
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Fecha os lancamentos contabeis                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lHeader   := .F.
			RodaProva(nHdlPrv,nTotalCtb)
			If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
				If Empty(cCodDiario)
					cCodDiario :=CtbaVerdia()
				EndIf
				aCtbDia := {{"SF2",SF2->(RECNO()),cCodDiario,"F2_NODIA","F2_DIACTB"}}
			EndIF
			cA100Incl(cArqCtb,nHdlPrv,1,cLoteCtb,lDigita,lAglutina,,,,,,aCtbDia)
		EndIf
	EndIf

	If ExistBlock("M521DNFS")
		ExecBlock("M521DNFS",.F.,.F.,{aPedido})
	Endif

	If FindFunction("MaEnvEAI")
		If oMdl <> Nil
			//--Exclusão NF SAIDA
			MaEnvEAI(,,5,"MATA521",,,,.F.,oMdl)
		EndIf
		If oMdlCarga <> Nil
			MaEnvEAI(,,5,"OMSA200",,,,.F.,oMdlCarga)
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Para os pedidos e-Commerce processa a liberacao novamente    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SC6->( dbSetOrder(1) )

	For  nX := 1 to Len(aRegSC5)

		lLiberOk  := .T.
	    SC5->( DbGoTo(aRegSC5[nX]) )

		Begin Transaction

	    SC6->( dbSeek(xFilial("SC6")+SC5->C5_NUM) )
	    Do  While !( SC6->(Eof()) ) .And. (SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM)
        	MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,,,.T.,.T.,.F.,.F.)

       		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   		//³Verifica se Todos os Itens foram Liberados                              ³
	   		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If  (lLiberOk .And. SC6->C6_QTDVEN > SC6->C6_QTDEMP + SC6->C6_QTDENT .And. AllTrim(SC6->C6_BLQ)<>"R")
				lLiberOk := .F.
			EndIf

			SC6->( dbSkip() )
		EndDo


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza do C5_LIBEROK                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( lLiberOk )
			RecLock("SC5")
			SC5->C5_LIBEROK := "S"
			SC5->( MsUnlock() )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ PCO - Grava o lancamento de liberacao de pedido de venda ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PcoDetLan("000103","02","MATA440")
		EndIf

		End Transaction
	Next nX
EndIf

RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³MATA521A  ³ Rev.  ³Eduardo Riera          ³ Data ³29.12.2001	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de exclusao dos documentos de saida por carga       	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      	³±±
±±³          ³                                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MATA521B()

Local aArea     := GetArea()
Local cFilDAK   := ""
Local aIndDAK   := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carga das Variaveis Staticas do Programa                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa  ³
//³ ----------- Elementos contidos por dimensao ------------ ³
//³ 1. Nome a aparecer no cabecalho                          ³
//³ 2. Nome da Rotina associada                              ³
//³ 3. Usado pela rotina                                     ³
//³ 4. Tipo de Transa‡„o a ser efetuada                      ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados         ³
//³    2 - Simplesmente Mostra os Campos                     ³
//³    3 - Inclui registros no Bancos de Dados               ³
//³    4 - Altera o registro corrente                        ³
//³    5 - Remove o registro corrente do Banco de Dados      ³
//³    6 - Altera determinados campos sem incluir novos Regs ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE bFiltraBrw := {|| ""}
PRIVATE bEndFilBrw := {|| Nil}
PRIVATE cCadastro  := OemToAnsi(STR0010) //"Exclusao dos Documento de Saida por carga"
PRIVATE aRotina    := { ;
	{ STR0002,"PesqBrw"  , 0 , 0},; //"Pesquisa"
	{ STR0005,"Ma521MBrow", 0 , 5}} //"Excluir"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica o modelo de interface                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("MTA521",.F.)
SetKey(VK_F12,{||Pergunte("MTA521",.T.)})

If ExistBlock( "M520FIL" )
	cFilDAK := ExecBlock("M520FIL",.F.,.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para pre-validar os dados a serem  ³
//³ exibidos.                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF ExistBlock("M520BROW")
   ExecBlock("M520BROW",.F.,.F.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Filtragem                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cFilDAK)
	bFiltraBrw := {|x| FilBrowse("DAK",@aIndDAK,@cFilDAK) }
	Eval(bFiltraBrw)
	DAK->(MsSeek(xFilial()))
Endif

mBrowse(7,4,20,74,"DAK",,"DAK_FEZNF=='1'")
SetKey(VK_F12,Nil)

If !Empty(cFilDAK)
	dbSelectArea("DAK")
	RetIndex("DAK")
	dbClearFilter()
	aEval(aIndDAK,{|x| Ferase(x[1]+OrdBagExt())})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a integridade da rotina                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³OMS521CAR ³ Rev.  ³Henry Fila             ³ Data ³29.12.2001	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de remontagem de carga                              	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1 : Array com os campos do SC9 anterior                 	³±±
±±³          ³ExpA2 : Array com dos dados da carga anterior               	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Oms521Car(aSd2Carga,aRotas,cFilCar)

Local nPosPed := 0

If Len(aSd2Carga) > 0
	nPosPed := Ascan(aSd2Carga, {|x| x[1]+x[2]+x[3] == SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO})
	If nPosPed > 0
		If Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_REMITO)
			RecLock("SC9",.F.)
				SC9->C9_CARGA  := aSd2Carga[nPosPed][4]
				SC9->C9_SEQCAR := aSd2Carga[nPosPed][5]
				SC9->C9_ENDPAD := aSd2Carga[nPosPed][6]
				SC9->C9_SEQENT := aSd2Carga[nPosPed][8]
			MsUnlock()
			MaAvalSC9("SC9",7,,,,,,aRotas,,,,,,cFilCar)
		EndIf
	EndIf
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³MaEstNfAA3³ Rev.  ³ Sergio Silveira       ³ Data ³12/08/2002	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de transferencia da base instalada - Estorno NF saida  ³±±
±±³          ³transfere o eqto do AA3 para o cliente padrao de devolucao    ³±±
±±³          ³O SD2 deve estar posicionado.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MaEstNfAA3()

Local aArea     := GetArea()
Local aAreaSA1  := SA1->( GetArea() )

Local cAtEstCli := PadR( &( SuperGetMV( "MV_ATESTCL" ) ), Len( SA1->A1_COD ) )
Local cAtEstLoj := PadR( &( SuperGetMV( "MV_ATESTLJ" ) ), Len( SA1->A1_LOJA ) )
Local lM521Atec := ExistBlock("LM521ATEC")
Local lValidCli := .F.

#IFNDEF TOP
	Local cSeekSDB  := ""
#ENDIF

#IFDEF TOP
	Local cQuery    := ""
	Local cAliasQry := ""
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se foi definido o cliente / loja de retorno           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty( cAtEstCli ) .And. !Empty( cAtEstLoj )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o cliente / loja existe                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SA1->( dbSetOrder( 1 ) )

	lValidCli := SA1->( dbSeek( xFilial( "SA1" ) + cAtEstCli + cAtEstLoj ) )

	If lValidCli

		If !( Localiza(SD2->D2_COD) )
			If ( !Empty(SD2->D2_NUMSERI) )
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Transfere para o cliente / loja de retorno                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				AtTrfEqpto(SD2->D2_CODFAB,SD2->D2_LOJAFA,SD2->D2_COD,SD2->D2_NUMSERI,cAtEstCli,cAtEstLoj)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de entrada - Transferencia                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lM521Atec
					ExecBlock("M521ATEC",.F.,.F.)
				EndIf
			EndIf
		Else

			#IFDEF TOP

				cAliasQry := "MANFESTAA3"

				cQuery := ""

				cQuery += "SELECT DB_NUMSERI FROM " + RetSqlname( "SDB" ) + " "
				cQuery += "WHERE "
				cQuery += "DB_FILIAL='"   + xFilial( "SDB" )             + "' AND "
				cQuery += "DB_PRODUTO='"  + SD2->D2_COD                  + "' AND "
				cQuery += "DB_LOCAL='"    + SD2->D2_LOCAL                + "' AND "
				cQuery += "DB_NUMSEQ='"   + SD2->D2_NUMSEQ               + "' AND "
				cQuery += "DB_DOC='"      + SD2->D2_DOC                  + "' AND "
				cQuery += "DB_SERIE='"    + SD2->D2_SERIE                + "' AND "
				cQuery += "DB_CLIFOR='"   + SD2->D2_CLIENTE              + "' AND "
				cQuery += "DB_LOJA='"     + SD2->D2_LOJA                 + "' AND "
				cQuery += "DB_NUMSERI<>'" + Space(Len( SDB->DB_NUMSERI)) + "' AND "

				cQuery += "D_E_L_E_T_<>'*' "

				cQuery := ChangeQuery( cQuery )

				dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )

				While !( cAliasQry )->( Eof() )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Transfere para o cliente / loja de retorno                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					AtTrfEqpto(SD2->D2_CODFAB,SD2->D2_LOJAFA,SD2->D2_COD, ( cAliasQry )->DB_NUMSERI,cAtEstCli,cAtEstLoj)
   				( cAliasQry )->( dbSkip() )

				EndDo

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Fecha a area de trabalho da query                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				( cAliasQry )->( dbCloseArea() )
				dbSelectArea( "SDB" )

			#ELSE

				SDB->( dbSetOrder( 1 ) )

				cSeekSDB := xFilial("SDB")+SD2->D2_COD+SD2->D2_LOCAL+SD2->D2_NUMSEQ+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
				If ( MsSeek( cSeekSDB ) )

					While !SDB->( Eof() ) .And. cSeekSDB == SDB->DB_FILIAL + SDB->DB_PRODUTO + SDB->DB_LOCAL + SDB->DB_NUMSEQ +;
							SDB->DB_DOC + SDB->DB_SERIE + SDB->DB_CLIFOR + SDB->DB_LOJA

						If !Empty( SDB->DB_NUMSERI )
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Transfere para o cliente / loja de retorno                     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							AtTrfEqpto(SD2->D2_CODFAB,SD2->D2_LOJAFA,SD2->D2_COD,SDB->DB_NUMSERI,cAtEstCli,cAtEstLoj)

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Ponto de entrada - Transferencia                               ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lM521Atec
								ExecBlock("M521ATEC",.F.,.F.)
							EndIf
						EndIf

						SDB->( dbSkip() )

					EndDo

				EndIf

			#ENDIF

		EndIf

	EndIf

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura as areas de trabalho                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea( aAreaSA1 )
RestArea( aArea )

Return( .T. )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³AjustaSX1 ³ Rev.  ³ Marco Bianchi         ³ Data ³ 21/07/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Modifica Titulo e Help da pergunta 03.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}
Local aArea     := GetArea()
Local aAreaSX1  := SX1->(GetArea())


dbSelectArea("SX1")
dbSeek("MTA521    03")
If AllTrim(X1_PERGUNT) <> "Contabiliza?"

	RecLock("SX1",.F.)
	Replace X1_PERGUNT With "Contabiliza?"
	Replace X1_PERSPA  With "¿Contabiliza?"
	Replace X1_PERENG  With "Contabiliza?"
	MsUnLock()

	AAdd(aHelpPor,"Indica se os lançamentos contábeis devem")
	AAdd(aHelpPor,"ser gerados durante a exclusão do docu- ")
	AAdd(aHelpPor,"mento de saída. Não será possível gerá- ")
	AAdd(aHelpPor,"lo pela contabilização Off-Line.")

	AAdd(aHelpSpa,"Indica si los asientos contables deben ")
	AAdd(aHelpSpa,"generarse durante el borrado de la 	  ")
	AAdd(aHelpSpa,"factura. No será posible generarlo por ")
	AAdd(aHelpSpa,"la contabilización off-line.           ")

	AAdd(aHelpEng,"It indicates that the accounting entries")
	AAdd(aHelpEng,"must be generated during the exclusion  ")
	AAdd(aHelpEng,"of document output. You can not generate")
	AAdd(aHelpEng,"it by the accounting Off-Line.          ")

	PutSX1Help("P.MTA52103.",aHelpPor,aHelpEng,aHelpSpa)

EndIf

If dbSeek("MTA521    04")
	aHelpPor := {}

	AADD(aHelpPor,"Informando em carteira o sistema retorna a ")
	AADD(aHelpPor,"situação dos pedido para não liberado, ")
	AADD(aHelpPor,"informando apto a faturar sujeita os pedidos ")
	AADD(aHelpPor,"a liberação novamente.")

	PutSX1Help("P.MTA52104.",aHelpPor)

EndIf
RestArea(aAreaSX1)
RestArea(aArea)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³MA521VerSC6 ³ Rev.  ³ Vendas Clientes       ³ Data ³ 26/12/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que verifica se existe amarracao no Pedido de venda com  ³±±
±±³          ³Pedido de Compra, Caso exista e se jah foi feito recebimento de ³±±
±±³          ³de alguma quantidade no pedido de compra o Pedido de venda nao  ³±±
±±³          ³podera ser cancelado.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico .T. para cancelar - .F. nao Cancela                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³PARAM01 - Filial da nota de Saida (SF2)                         ³±±
±±³          ³PARAM02 - Numero do Documento                                   ³±±
±±³          ³PARAM03 - Serie do Documento                                    ³±±
±±³          ³PARAM04 - Codigo do Cliente									  ³±±
±±³          ³PARAM05 - Codigo da Loja 										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MA521VerSC6(cFILIAL,cDOC,cSERIE,cCLIENTE,cLOJA)
Local lRet     := .T.
Local aArea    := GetArea()
Local cFilPCom := ""        // Filial do Pedido de Compras
Local cPedCom  := ""        // Numero do Pedido de Compras
Local cProd    := ""        // Cod do Produto
Local cItemPC  := ""        // Item do Pedido de Compra
Local cNumC7   := ""        // Guarda o num para nao correr a Tabela Inteira.


Default cFilial   := ""
Default cDoc      := ""
Default cSerie    := ""
Default cCliente  := ""
Default cLoja     := ""

If SC6->(FieldPos("C6_PEDCOM")) > 0 .AND.  SC6->(FieldPos("C6_ITPC")) > 0 .AND. SC6->(FieldPos("C6_FILPED")) > 0
	If !Empty(cFilial) .AND. !Empty(cDoc) .AND. !Empty(cSerie) .AND. !Empty(cCliente) .AND.  !Empty(cLoja)
		DbSelectArea("SD2")
		DbSetOrder(3)
		If DbSeek(cFilial + cDoc + cSerie + cCliente + cLoja )
			cFilPCom  := SD2->D2_FILIAL
			cProd     := SD2->D2_COD
			cPedCom   := SD2->D2_PEDIDO
			cItemPC   := SD2->D2_ITEM
		    DbSelectArea("SC6")
		    DbSetOrder(2)
	   		If DbSeek(cFilPCom + cProd + cPedCom + cItemPC )
	   		    cFilPCom  := SC6->C6_FILPED
		   		cProd     := SC6->C6_PRODUTO
				cPedCom   := SC6->C6_PEDCOM
				cItemPC   := SC6->C6_ITPC
	   			DbSelectArea("SC7")
				DbSetOrder(4)
				If DbSeek(cFilPCom + cProd + cPedCom + cItemPC )
				    cNumC7 := SC7->C7_NUM
					While !Eof()
						lRet := If(SC7->C7_QUJE > 0, .F., .T. )
						If !lRet .OR. cNumC7 <> SC7->C7_NUM
						   Exit
						EndIf
						SC7->(DbSkip())
					End
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
If !lRet
   Aviso(STR0007,STR0019,{ "Ok" } ) // "ATENCAO", "Documento não pode ser Excluido, pois esta associado a um Pedido de Compra",
EndIf
RestArea(aArea)
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³A521CBxAdt  ³ Rev.  ³ Vendas CRM            ³ Data ³ 29/05/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cancela Baixa dos Adiantamentos - Mexico                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico .T. para sucesso  - .F. falha                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A521CBxAdt()
Local lRet 		:= .T.
Local aStrFR3 	:= {}
Local aVetor 	:= {}
Local nX 		:= 0
Local cCpoQry 	:= ""
Local cQ		:= ""
Local nBaixa	:= 1	//Baixa selecionada para cancelar na rotina fina070

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega array com titulos compensados nesta nota    ³
//³fiscal, da tabela de Documento X Adiantamento       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aStrFR3 := FR3->(DbStruct())
For nX := 1 to Len(aStrFR3)
	cCpoQry += aStrFR3[nX][1] +" , "
Next nX

cQ	:= "SELECT "+cCpoQry+" R_E_C_N_O_ AS FR3_RECNO "
cQ += "FROM "+RetSqlName("FR3")+" "
cQ += "WHERE FR3_FILIAL = '"+xFilial("FR3")+"' "
cQ += "AND FR3_CART = 'R' "
cQ += "AND FR3_TIPO IN "+FormatIn(MVRECANT,"/")+" "
cQ += "AND FR3_CLIENT = '"+SF2->F2_CLIENTE+"' "
cQ += "AND FR3_LOJA = '"+SF2->F2_LOJA+"' "
cQ += "AND FR3_DOC = '"+SF2->F2_DOC+"' "
cQ += "AND FR3_SERIE = '"+SF2->F2_SERIE+"' "
cQ += "AND D_E_L_E_T_= ' ' "

cQ := ChangeQuery(cQ)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"TRBFR3",.T.,.T.)
TcSetField("TRBFR3","FR3_VALOR","N",TamSX3("FR3_VALOR")[1],TamSX3("FR3_VALOR")[2])

While !Eof()
	aVetor 	:= {}
	//Procura uma baixa não cancelada com o Valor igual ao relacionado ao adiantamento
	DbSelectArea("SE5")
	DbSetOrder(7)
	If MsSeek(XFilial("SE5")+TRBFR3->FR3_PREFIX+TRBFR3->FR3_NUM+TRBFR3->FR3_PARCEL+TRBFR3->FR3_TIPO+SF2->F2_CLIENTE+SF2->F2_LOJA)
		nBaixa := 1
		While !Eof()
			If SE5->E5_SITUACA == 'C'
				DbSkip()
				Loop
			EndIf
			If SE5->E5_VALOR == TRBFR3->FR3_VALOR
				Exit
			EndIf
			nBaixa++
			DbSkip()
		EndDo
	Else
		lRet := .F.
		Exit
	EndIf

	aVetor 	:= {{"E1_PREFIXO"	, TRBFR3->FR3_PREFIX			,Nil},;
				{"E1_NUM"		, TRBFR3->FR3_NUM      			,Nil},;
				{"E1_PARCELA"	, TRBFR3->FR3_PARCEL			,Nil},;
				{"E1_TIPO"	    , TRBFR3->FR3_TIPO				,Nil}}

	MSExecAuto({|x,y| Fina070(x,y,.F.,nBaixa)},aVetor,5)
	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
		lRet := .F.
		Exit
	Else
		dbSelectArea("FR3")
		dbGoto(TRBFR3->FR3_RECNO)
		RecLock("FR3",.F.)
		DbDelete()
		MsUnlock()
	EndIf
	dbSelectArea("TRBFR3")
	DbSkip()
EndDo

TRBFR3->(dbCloseArea())

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A521CCompAd ³ Autor ³Totvs                ³ Data ³22.04.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz o cancelamento da compensacao do adiantamento           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se a Compensacao foi excluida                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array com o Recno dos titulos gerados                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A521CCompAd(aRegSE1)

Local aArea	:= GetArea()
Local aAreaSE1	:= SE1->(GetArea())
Local lContabiliza := .T.
Local lDigita := .T.
Local lAglutina := .F.
Local aRecRetRA := {}	// Retorno da funcao que carrega os titulos de Adiantamento
Local nCnt := 0 	// Variavel utilizado em loop
Local aRecNoRA := {}	// Recebe o Recno do Titulo de Adiantamento
Local aRecVlrRA := {}	// Recebe o valor limite para compensação do Titulo de Adiantamento
Local cQ := ""
Local aDocCmp := {}
/* estrutura array aDocCmp
//1 - E5_PREFIXO
//2 - E5_NUMERO
//3 - E5_PARCELA
//4 - E5_TIPO
//5 - E5_LOJA
//6 - E5_VALOR
//7 - F2_DOC
//8 - F2_SERIE
//9 - Logico - indica se compensacao foi realizada no momento da geracao do documento de saida
*/
Local nTamPref := TamSX3("E1_PREFIXO")[1]
Local nTamNum := TamSX3("E1_NUM")[1]
Local nTamParc := TamSX3("E1_PARCELA")[1]
Local nTamTipoT := TamSX3("E1_TIPO")[1]
Local nTamLoja := TamSX3("E1_LOJA")[1]
Local nPos := 0
Local aRecnoFR3 := {} // array para guardar o recno dos registros da tabela FR3, referente aos adiantamentos compensados com a nota fiscal, no momento da geracao da nota
Local lRet := .T.
Local aEstorno := {} // array para guardar o conteudo do campo E5_DOCUMEN dos registros usados na compensacao
Local aEstornoTmp := {}
Local aDocCmpTmp := {}
Local nX		:= 0
Local cCpoQry 	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se há ao menos 1 parcela nesta venda³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aRegSE1) >= 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega array com titulos compensados nesta nota    ³
	//³fiscal                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQ	:= "SELECT E5_DOCUMEN,E5_VALOR,E5_NUMERO,E5_PREFIXO,E5_PARCELA,E5_TIPO,E5_CLIFOR,E5_LOJA,E5_SEQ "
	cQ += "FROM "+RetSqlName("SE5")+" "
	cQ += "WHERE E5_FILIAL = '"+xFilial("SE5")+"' "
	cQ += "AND E5_RECPAG = 'R' "
	cQ += "AND E5_SITUACA <> 'C' "
	cQ += "AND E5_DATA = '"+dTos(SF2->F2_EMISSAO)+"' "
	cQ += "AND E5_NUMERO = '"+SF2->F2_DUPL+"' "
	cQ += "AND E5_PREFIXO = '"+SF2->F2_PREFIXO+"' "
	cQ += "AND E5_CLIFOR = '"+SF2->F2_CLIENTEr+"' "
	cQ += "AND E5_LOJA = '"+SF2->F2_LOJA+"' "
	cQ += "AND E5_MOTBX = 'CMP' "
	cQ += "AND E5_TIPODOC = 'CP' "
	cQ += "AND E5_TIPO = '"+MVNOTAFIS+"' "
	cQ += "AND D_E_L_E_T_= ' ' "

	cQ := ChangeQuery(cQ)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"TRBSE5",.T.,.T.)
	TcSetField("TRBSE5","E5_VALOR","N",TamSX3("E5_VALOR")[1],TamSX3("E5_VALOR")[2])

   While !Eof()
		If !TemBxCanc(TRBSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ),.T.)
	   	aAdd(aDocCmpTmp,{Subs(TRBSE5->E5_DOCUMEN,1,nTamPref),Subs(TRBSE5->E5_DOCUMEN,nTamPref+1,nTamNum),Subs(TRBSE5->E5_DOCUMEN,nTamPref+nTamNum+1,nTamParc),;
   		Subs(TRBSE5->E5_DOCUMEN,nTamPref+nTamNum+nTamParc+1,nTamTipoT),Subs(TRBSE5->E5_DOCUMEN,nTamPref+nTamNum+nTamParc+nTamTipoT+1,nTamLoja),TRBSE5->E5_VALOR,;
   		SF2->F2_DOC,SF2->F2_SERIE,.F.})
   	Endif
   	dbSkip()
   Enddo

   TRBSE5->(dbCloseArea())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega array com titulos compensados nesta nota    ³
	//³fiscal, da tabela de Documento X Adiantamento       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aStrFR3 := FR3->(dbStruct())
	For nX := 1 to Len(aStrFR3)
		cCpoQry += aStrFR3[nX][1] +" , "
	Next nX

	cQ	:= "SELECT "+cCpoQry+" R_E_C_N_O_ AS FR3_RECNO "
	cQ += "FROM "+RetSqlName("FR3")+" "
	cQ += "WHERE FR3_FILIAL = '"+xFilial("FR3")+"' "
	cQ += "AND FR3_CART = 'R' "
	cQ += "AND FR3_TIPO IN "+FormatIn(MVRECANT,"/")+" "
	cQ += "AND FR3_CLIENT = '"+SF2->F2_CLIENTE+"' "
	cQ += "AND FR3_LOJA = '"+SF2->F2_LOJA+"' "
	cQ += "AND FR3_DOC = '"+SF2->F2_DOC+"' "
	cQ += "AND FR3_SERIE = '"+SF2->F2_SERIE+"' "
	cQ += "AND D_E_L_E_T_= ' ' "

	cQ := ChangeQuery(cQ)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"TRBFR3",.T.,.T.)
	TcSetField("TRBFR3","FR3_VALOR","N",TamSX3("FR3_VALOR")[1],TamSX3("FR3_VALOR")[2])

   While !Eof()
   	nPos := aScan(aDocCmpTmp,{|x| x[1]+x[2]+x[3]+x[4]+x[5]+Alltrim(Str(x[6]))+x[7]+x[8] == ;
		TRBFR3->(FR3_PREFIX+FR3_NUM+FR3_PARCEL+FR3_TIPO+FR3_LOJA)+Alltrim(Str(TRBFR3->FR3_VALOR))+TRBFR3->(FR3_DOC+FR3_SERIE)})
   	If nPos > 0
	   	aDocCmpTmp[nPos][9] := .T.
	   Endif
	   aAdd(aRecnoFR3,TRBFR3->FR3_RECNO)
   	dbSkip()
   Enddo

   TRBFR3->(dbCloseArea())

	//grava no array aDocCmp soh os adiantamentos que pertencem a compensacao referente a geracao da nota fiscal
	For nCnt:=1 To Len(aDocCmpTmp)
		If aDocCmpTmp[nCnt][9]
			aAdd(aDocCmp,aDocCmpTmp[nCnt])
			aAdd(aRecVlrRA,aDocCmpTmp[nCnt][6])
		Endif
	Next nCnt

   If Len(aDocCmp) > 0
   	//grava array aEstorno com a mesma chave do campo E5_DOCUMEN, para uso na rotina MaIntBxCr
   	For nCnt:=1 To Len(aDocCmp)
	   	aAdd(aEstornoTmp,Alltrim(aDocCmp[nCnt][1]+aDocCmp[nCnt][2]+aDocCmp[nCnt][3]+aDocCmp[nCnt][4]+aDocCmp[nCnt][5]))
   	Next nCnt
   	If Len(aEstornoTmp) > 0
   		aAdd(aEstorno,aEstornoTmp)
   	Endif
   	// grava recno dos adiantamentos compensados
   	dbSelectArea("SE1")
   	dbSetOrder(2) // filial+cliente+loja+prefixo+numero+parcela+tipo
   	For nCnt:=1 To Len(aDocCmp)
	   	If dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+aDocCmp[nCnt][1]+aDocCmp[nCnt][2]+aDocCmp[nCnt][3]+aDocCmp[nCnt][4])
	   		aAdd(aRecnoRA,SE1->(Recno()))
	   	Endif
	   Next nCnt
	   If Len(aRecnoRA) > 0.and. Len(aEstorno) > 0 .and. Len(aRecVlrRA) > 0

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Carrega o pergunte da rotina de compensação financeira³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Pergunte("FIN330",.F.)

			lContabiliza 	:= MV_PAR09 == 1
			lDigita			:= MV_PAR07 == 1

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Excluir Compensacao dos valores no Financeiro³
			//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SE1->(MsGoTo(aRegSE1[1]))
			If SE1->(Recno()) = aRegSE1[1]
				lRet := .F.
				lRet := MaIntBxCR(3,{aRegSE1[1]},,aRecNoRA,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,aEstorno,,,SE1->E1_VALOR,,aRecVlrRA)
			Endif

			Pergunte("MTA521",.F.)

			// busca todas as compensacoes referentes a esta nota fiscal e ajusta o valor compensado para cada pedido de venda
			If Len(aRecnoFR3) > 0 .and. lRet
				SE1->(MsGoTo(aRegSE1[1]))
				If SE1->(Recno()) = aRegSE1[1]

				//
				//		Criterio "!Empty(SE1->E1_BAIXA)" alterado:
				//		1- Exclusao da NFS sem baixa - Campo E1_BAIXA" esta com data
				//		2- Exclusao da NFS com cancelamento de baixa - Campo E1_BAIXA" esta vazio
				//		If SE1->E1_VALOR = SE1->E1_SALDO .and. Empty(SE1->E1_BAIXA) // verifica se o titulo esta em aberto
				//
					If SE1->E1_VALOR = SE1->E1_SALDO // .and. Empty(SE1->E1_BAIXA) // verifica se o titulo esta em aberto
						For nCnt:=1 To Len(aRecnoFR3)
							dbSelectArea("FR3")
							dbGoto(aRecnoFR3[nCnt])
							If Recno() = aRecnoFR3[nCnt]
								SE1->(dbSetOrder(2))
								If SE1->(MsSeek(xFilial("SE1")+FR3->(FR3_CLIENTE+FR3_LOJA+FR3_PREFIXO+FR3_NUM+FR3_PARCELA+FR3_TIPO)))

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Ajuste do saldo do relacionamento no Financeiro³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								    FPedAdtGrv("R",4,FR3->FR3_PEDIDO,{{FR3->FR3_PEDIDO,SE1->(RecNo()),(FR3->FR3_VALOR*-1)}},.T.,SF2->F2_DOC,SF2->F2_SERIE)
					   		Endif
							Endif
						Next nCnt

						//exclui registro do titulo principal da tabela FR3
						SE1->(MsGoTo(aRegSE1[1]))
						If SE1->(Recno()) = aRegSE1[1]
							dbSelectArea("FR3")
							dbSetOrder(2)
							If dbSeek(xFilial("FR3")+"R"+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)+SF2->F2_DOC+SF2->F2_SERIE)
								RecLock("FR3",.F.)
								dbDelete()
								MsUnlock()
							Endif
						Endif
					Else
						lRet := .F.
					Endif
				Endif
			Endif
		Endif
	Endif
EndIf

SE1->(RestArea(aAreaSE1))
RestArea(aArea)

Return(lRet)
//-------------------------------------
/*	Modelo de Dados
@author  	Jefferson Tomaz
@version 	P10 R1.4
@build		7.00.101202A
@since 		06/04/2011
@return 		oModel Objeto do Modelo*/
//-------------------------------------
Static Function ModelDef()
Local oModel
Local oStructSF2      := FWFormStruct(1,"SF2")
Local oStructSD2      := FWFormStruct(1,"SD2")
Local oStruRSA1       := Nil
Local oStruDSA1       := Nil
Local oStructSF3      := Nil
Local oStructSX5	  := Nil
Local cCdclfr         := SuperGetMv("MV_CDCLFR",.F.,"1")
Local lIntGFE   := SuperGetMv('MV_INTGFE',,.F.)

If lIntGFE

	oStruRSA1      := FWFormStruct(1,"SA1",{|cCampo| AllTrim(cCampo)+"|" $ "A1_COD|A1_LOJA|A1_NREDUZ|A1_CGC|A1_END|A1_BAIRRO|A1_MUN|A1_EST|A1_COD_MUN|A1_CEP|A1_ENDENT|A1_BAIRROE|A1_CEPE|A1_MUNE|A1_ESTE|"})
	oStruDSA1      := FWFormStruct(1,"SA1",{|cCampo| AllTrim(cCampo)+"|" $ "A1_COD|A1_LOJA|A1_NREDUZ|A1_CGC|A1_END|A1_BAIRRO|A1_MUN|A1_EST|A1_COD_MUN|A1_CEP|A1_ENDENT|A1_BAIRROE|A1_CEPE|A1_MUNE|A1_ESTE|"})
	oStructSF3     := FWFormStruct(1,"SF3",{|cCampo| AllTrim(cCampo)+"|" $ "F3_SERIE|F3_NFISCAL|F3_CLIEFOR|F3_LOJA|F3_DTCANC|"})
	oStructSX5	   := FWFormStruct(1,"SX5")

	oStructSF2:AddField( ;                    // Ord. Tipo Desc.
	"F2_CDCLF"                       , ;      // [01]  C   Titulo do campo
	"Class.frete"                    , ;      // [02]  C   ToolTip do campo
	"F2_CDCLFR"                      , ;      // [03]  C   Id do Field
	'C'                              , ;      // [04]  C   Tipo do campo
	5                                , ;      // [05]  N   Tamanho do campo
	0                                , ;      // [06]  N   Decimal do campo
	NIL                              , ;      // [07]  B   Code-block de validação do campo
	NIL                              , ;      // [08]  B   Code-block de validação When do campo
	NIL                              , ;      // [09]  A   Lista de valores permitido do campo
	NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
	NIL                              , ;      // [11]  B   Code-block de inicializacao do campo
	NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
	NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
	NIL                              )        // [14]  L   Indica se o campo é virtual

	oStructSF2:AddField( ;                    // Ord. Tipo Desc.
	"CGC Transp"                     , ;      // [01]  C   Titulo do campo
	"CGC Transp"                     , ;      // [02]  C   ToolTip do campo
	"F2_CGCTRP"                      , ;      // [03]  C   Id do Field
	'C'                              , ;      // [04]  C   Tipo do campo
	14                               , ;      // [05]  N   Tamanho do campo
	0                                , ;      // [06]  N   Decimal do campo
	NIL                              , ;      // [07]  B   Code-block de validação do campo
	NIL                              , ;      // [08]  B   Code-block de validação When do campo
	NIL                              , ;      // [09]  A   Lista de valores permitido do campo
	NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
	FwBuildFeature( STRUCT_FEATURE_INIPAD,'Posicione("SA4",1,xFilial("SA4")+SF2->F2_TRANSP,"A4_CGC")' ), ;      // [11]  B   Code-block de inicializacao do campo
	NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
	NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
	.T.                              )        // [14]  L   Indica se o campo é virtual

	oStruRSA1:AddField( ;                    // Ord. Tipo Desc.
	"IBGE Compl"                     , ;      // [01]  C   Titulo do campo
	"Cod.IBGE Compl "                , ;      // [02]  C   ToolTip do campo
	"A1_CDIBGE"                      , ;      // [03]  C   Id do Field
	'C'                              , ;      // [04]  C   Tipo do campo
	7                                , ;      // [05]  N   Tamanho do campo
	0                                , ;      // [06]  N   Decimal do campo
	NIL                              , ;      // [07]  B   Code-block de validação do campo
	NIL                              , ;      // [08]  B   Code-block de validação When do campo
	NIL                              , ;      // [09]  A   Lista de valores permitido do campo
	NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
	FwBuildFeature( STRUCT_FEATURE_INIPAD,'TMS120CdUf(SA1->A1_EST, "1") + SA1->A1_COD_MUN' ), ;   // [11]  B   Code-block de inicializacao do campo
	NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
	NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
	.T.                              )        // [14]  L   Indica se o campo é virtual

	oStruDSA1:AddField( ;                    // Ord. Tipo Desc.
	"IBGE Compl"                     , ;      // [01]  C   Titulo do campo
	"Cod.IBGE Compl "                , ;      // [02]  C   ToolTip do campo
	"A1_CDIBGE"                      , ;      // [03]  C   Id do Field
	'C'                              , ;      // [04]  C   Tipo do campo
	7                                , ;      // [05]  N   Tamanho do campo
	0                                , ;      // [06]  N   Decimal do campo
	NIL                              , ;      // [07]  B   Code-block de validação do campo
	NIL                              , ;      // [08]  B   Code-block de validação When do campo
	NIL                              , ;      // [09]  A   Lista de valores permitido do campo
	NIL                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
	FwBuildFeature( STRUCT_FEATURE_INIPAD,'TMS120CdUf(SA1->A1_EST, "1") + SA1->A1_COD_MUN' ), ;   // [11]  B   Code-block de inicializacao do campo
	NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
	NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
	.T.                              )        // [14]  L   Indica se o campo é virtual

	oStructSF2:SetProperty( '*', MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, '.T.' ) )
	oStructSF2:SetProperty( '*'         , MODEL_FIELD_WHEN,  NIL )

	oStructSD2:SetProperty( '*', MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, '.T.' ) )
	oStructSD2:SetProperty( '*'         , MODEL_FIELD_WHEN,  NIL )

	oStructSF3:SetProperty( '*', MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, '.T.' ) )
	oStructSF3:SetProperty( '*'         , MODEL_FIELD_WHEN,  NIL )


	oStruDSA1:SetProperty( '*', MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, '.T.' ) )
	oStruDSA1:SetProperty( '*'         , MODEL_FIELD_WHEN,  NIL )

	oStruRSA1:SetProperty( '*', MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, '.T.' ) )
	oStruRSA1:SetProperty( '*'         , MODEL_FIELD_WHEN,  NIL )

EndIf
oModel := MPFormModel():New("MATA521",  /*bPre*/, /*bPost*/, Nil /*bCommit*/, /*bCancel*/)

oModel:AddFields("MATA521_SF2", ,oStructSF2,/*bPre*/,/*bPost*/,/*bLoad*/)
oModel:AddGrid("MATA521_SD2","MATA521_SF2",oStructSD2,/*bLinePre*/, ,/*bPre*/,/*bPost*/,/*bLoad*/)

oModel:SetRelation("MATA521_SD2",{{"D2_FILIAL",'xFilial("SF2")'},{"D2_DOC","F2_DOC"},{"D2_SERIE","F2_SERIE"},;
                                  {"D2_CLIENTE","F2_CLIENTE"},{"D2_LOJA","F2_LOJA"}},"D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA")

If lIntGFE

	oModel:AddFields("MATA521_SF3","MATA521_SF2",oStructSF3,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:AddFields("REMETENTE_SA1","MATA521_SF2",oStruRSA1,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:AddFields("DESTINATARIO_SA1","MATA521_SF2",oStruDSA1,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:AddFields("TIPONF_SX5","MATA521_SF2",oStructSX5,/*bPre*/,/*bPost*/,/*bLoad*/)

	oModel:SetRelation("MATA521_SF3",{{"F3_FILIAL",'xFilial("SF3")'},{"F3_SERIE","F2_SERIE"},{"F3_NFISCAL","F2_DOC"},;
                                  {"F3_CLIEFOR","F2_CLIENTE"},{"F3_LOJA","F2_LOJA"}},"F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIEFOR+F3_LOJA")

	oModel:SetRelation("REMETENTE_SA1",{{"A1_FILIAL",'xFilial("SA1")'},{"A1_CGC","SM0->M0_CGC"}},"A1_FILIAL+A1_CGC")

	oModel:SetRelation("DESTINATARIO_SA1",{{"A1_FILIAL",'xFilial("SA1")'},{"A1_COD","F2_CLIENT"},{"A1_LOJA","F2_LOJENT"}};
	                                  ,"A1_FILIAL+A1_COD+A1_LOJA")

	oModel:SetRelation("TIPONF_SX5",{{"X5_FILIAL",'xFilial("SX5")'},{"X5_TABELA","'MQ'"}, {"X5_CHAVE","F2_TIPO"}},"X5_FILIAL+X5_TABELA+X5_CHAVE")

EndIf

oModel:SetPrimaryKey({"F2_FILIAL", "F2_DOC", "F2_SERIE", "F2_CLIENTE", "F2_LOJA" })
oModel:GetModel("MATA521_SD2"):SetDelAllLine(.T.)

oModel:SetDescription( OemToAnsi(STR0001) )

Return oModel

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ T521Tela ³ Autor ³ Mary C. Hergert       ³ Data ³ 21/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta a dialog da consulta                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Numero do documento                                ³±±
±±³          ³ ExpC2 = Serie                                              ³±±
±±³          ³ ExpC3 = Especie                                            ³±±
±±³          ³ ExpC4 = Cliente/Fornecedor                                 ³±±
±±³          ³ ExpC5 = Loja                                               ³±±
±±³          ³ ExpC6 = Tipo - entrada / saida                             ³±±
±±³          ³ ExpC7 = Indica se o documento e de devol/beneficiamento    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum						                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Mata521                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function T521Tela(cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF)

Local aCmp			:= {}
Local aPaineis		:= {}
Local aPnTree		:= {}
Local aOpcao		:= {}
Local aSize 		:= MsAdvSize()
Local aPnlNF		:= {}
Local aGets			:= {}
Local aMantem		:= {{},{},{},{},{},{},{},{},{},{}}  //Arrays 7 e 8 (Anfavea - Cab / Itens), 9 - Informações Complementares
Local aSugerido		:= {}
Local aObrigat		:= {{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}} //Arrays 16 e 17 (Anfavea - Cab / Itens), 18 - Informações Complementares
Local aGNRE			:= {}
Local aLocal		:= {}
Local aObjects 		:= {}
Local aPosObj		:= {}
Local aInfo			:= {}
Local aPosObj2		:= {}
Local aRessarc		:= {}
Local aImport		:= {}

Local cDescr		:= ""
Local cTab			:= ""

Local lRet			:= .F.
Local lValid		:= .F.
Local lExpInd		:= .F.
Local lRetorno      := .F.

Local nX			:= 0
Local nTop    		:= 0
Local nLeft   		:= 0
Local nBottom 		:= 0
Local nRight  		:= 0

Local oDlg
Local oPanel
Local oPanel3
Local oFont			:= TFont():New("Arial",,14,,.F.)
Local oFont16		:= TFont():New("Arial",,16,,.F.)
Local oFont16b		:= TFont():New("Arial",,16,,.T.)

Local oGrpProc
Local oGetProc


Local nAltSay		:= 10
Local nTamSay		:= 50
Local nAltGet		:= 10
Local nPainel		:= 0
Local nCorDisab		:= CLR_HGRAY
Local nPos			:= 0
Local nOpc			:= 0

Private aHProc		:= {}
Private aCProc		:= {}
Private dDatReceb   := CtoD("  /  /    ")

Private cFormul		:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³->Informacoes complementares a gerar:³
//³10 - Processos                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Resolve os objetos lateralmente                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}

AAdd( aObjects, { 72,   40, .T., .T. } )
AAdd( aObjects, { 150,  50, .T., .T. } )

aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }


DEFINE FONT oFont NAME "Arial" SIZE 0, -10
DEFINE FONT oFont2 NAME "Arial" SIZE 0, -10

DEFINE MSDIALOG oDlg FROM 00,00 TO 600,750 TITLE STR0034 OF oMainWnd PIXEL //"Complementos por documento fiscal"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o Cabeçalho padrao para todos os complementos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
T521NF(oFont,nAltSay,nTamSay,nAltGet,cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF,/*@aPnlNF,*/oDlg)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega o aCols e o aHeader dos complementos e das informacoes complementares ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|| T521Cols(cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF,/*@aCompl,*/@aObrigat,@aMantem)})

// Processos referenciados
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o painel onde serao inseridas as informacoes do complemento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPanel3	:= TPanel():New(100,5,'',oDlg,oDlg:oFont,.T.,.T.,,,360,185,.T.,.T.)
oGrpProc:= TGroup():New(5,5,180,355,STR0046,oPanel3,,,.T.,.T.) //"Informações complementares - processos referenciados"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a Getdados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetProc := MsNewGetDados():New(15,10,175,350,GD_INSERT+GD_DELETE+GD_UPDATE,/*LinhaOk*/,/*GetdadosOk*/,/*cIniPos*/,/*aAlter*/,/*.F.*/,990,/*cAmpoOk*/,/*cSuperApagar*/,/*cApagaOk*/,oGrpProc,aHProc,aCProc)
oGetProc:bLinhaOk := &("{|| T521Proc(oGetProc,aObrigat,.F.) }")

aGets := {oGetProc}


ACTIVATE MSDIALOG oDlg ON INIT ;
EnchoiceBar(oDlg,{||(nOpc := 1, lValid := T521Valid(cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF,aMantem,aGets,aObrigat,aMantem),;
Iif(lValid,Processa({||lRet := T521Fim(cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF,aMantem,aGets)}),.F.),;
Iif(lRet,oDlg:End(),.T.))},;
{||(nOpc:= 0, oDlg:End())})

If ((nOpc == 1)  .And. (lRet))
   lRetorno = .T.
EndIf

Return lRetorno


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ T521Cols ³ Autor ³ Mary C. Hergert       ³ Data ³ 26/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta o aHeader e o aCols dos complementos que devem       ³±±
±±³          ³ apresentar informacoes por item - GetDados.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os complementos                          ³±±
±±³          ³ ExpC2 = Numero da nota fiscal                              ³±±
±±³          ³ ExpC3 = Serie da nota fiscal                               ³±±
±±³          ³ ExpC4 = Especie da nota fiscal                             ³±±
±±³          ³ ExpC5 = Cliente/fornecedor                                 ³±±
±±³          ³ ExpC6 = Loja do cliente/fornecedor                         ³±±
±±³          ³ ExpC7 = Indicacao de entrada/saida                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nao ha.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Mata521                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function T521Cols(cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF,/*aCompl,*/aObrigat,aMantem)

Local aCampos 	:= {}
Local aHeader	:= {}
Local aCols		:= {}
Local aPermite	:= {}
Local aCabPer	:= {}

Local cTabela	:= ""
Local cCampo	:= ""
Local cAlias	:= ""
Local cArqInd	:= ""
Local cChave	:= ""

Local lQuery	:= .F.
Local lPossui	:= .F.
Local lDocOri	:= CDL->(FieldPos("CDL_DOCORI")) > 0 .AND. CDL->(FieldPos("CDL_SERORI")) > 0
Local lDocExp	:= CDL->(FieldPos("CDL_NFEXP")) > 0 .AND. CDL->(FieldPos("CDL_SEREXP")) > 0 .AND. CDL->(FieldPos("CDL_ESPEXP")) > 0 .AND. CDL->(FieldPos("CDL_EMIEXP")) > 0 .AND. CDL->(FieldPos("CDL_CHVEXP")) > 0  .AND. CDL->(FieldPos("CDL_QTDEXP")) > 0 .And. CDL->(FieldPos("CDL_ITEMNF")) > 0 .And. CDL->(FieldPos("CDL_ITEORI")) > 0 .And. CDL->(FieldPos("CDL_PRDORI")) > 0 .And. CDL->(FieldPos("CDL_PRODNF")) > 0
Local lTabCDT	:= AliasIndic("CDT")
Local lCompCD0	:= AliasIndic("CD0")

Local nX 		:= 10
Local nY 		:= 0
Local nG 		:= 0
Local nCount	:= 1
Local nI		:= 0
Local nScan		:= 0

Local cValidCpoAnt	:= ""
Local cValidCpoNov	:= ""
Local nA					:= 0


aCampos		:= {}
aCols		:= {}
aHeader		:= {}
aPermite 	:= {}
aCabPer		:= {}

// Informacoes complementares - processos referenciados
aCampos := {"CDG_PROCES","CDG_TPPROC","CDG_IFCOMP"}
cTabela := "CDG"


	If Len(aCampos) > 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montando aHeader                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX3")
		dbSetOrder(2)
		For nY := 1 to Len(aCampos)
			If SX3->(dbSeek(aCampos[nY]))

				If X3USO(SX3->X3_USADO)

					cF3 	:= SX3->X3_F3
					cValid	:= SX3->X3_VALID

					aAdd(aHeader,{Alltrim(X3Titulo(SX3->X3_TITULO)),;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						cValid,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						cF3,;
						SX3->X3_CONTEXT})
				Endif
		   		If X3Obrigat(SX3->X3_CAMPO)
					aAdd(aObrigat[nX],{SX3->X3_CAMPO,SX3->X3_TIPO})
				Endif
			Endif
		Next


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta os filtros para cada uma das tabelas para carregar o aCols ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   	lPossui := T521Filtro(cTabela,@cArqInd,@cChave,@cAlias,@lQuery,cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF)

		If !lPossui
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Para os complementos por item, carrega com o conteudo dos itens do SFT³
			//³que permitem o complemento.                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Len(aPermite) > 0
				For nI := 1 to Len(aPermite)
					aAdd(aCols,Array(Len(aHeader)+1))
					For nY := 1 To Len(aHeader)
						aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
						aCols[Len(aCols)][Len(aHeader)+1] := .F.
						nScan := aScan(aCabPer,{|x| x == Alltrim(aHeader[nY][2])})
						If nScan > 0
							aCols[Len(aCols)][nY] := aPermite[nI][nScan]
						Endif
					Next nY
				Next
			Else
				aAdd(aCols,Array(Len(aHeader)+1))
				For nY := 1 To Len(aHeader)
					aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
					aCols[Len(aCols)][Len(aHeader)+1] := .F.
				Next nY
			Endif
		Else
			nCount := 1
			dbSelectArea(cAlias)
			While !Eof()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄd¿
				//³Sera necessario armazenar os complementos de importacao gravados anteriormente.         ³
				//³Como neste tipo de complemento e possivel alterar o numero do documento de importacao   ³
				//³(que faz parte da chave), armazena-se os complementos existentes para a atualização das ³
				//³informacoes prestadas pelo usuario.                                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄdÙ
				If nX == 10 .And. cTabela == "CDG"
					aAdd(aMantem[2],{CDG_PROCES,CDG_TPPROC,.F.})
				Endif
				nCount++

				Aadd(aCols,Array(Len(aHeader)+1))

				For nY :=1 to Len(aHeader)
					cTipo := aHeader[nY][8]
					If cTipo == "D"
						cData := (cAlias)->(FieldGet(FieldPos(aHeader[nY,2])))
						If !Empty(cData)
							#IFDEF TOP
								cData2:= substr(cdata,7,2)+'/'+substr(cdata,5,2)+'/'+substr(cdata,1,4)
							#ELSE
								cData2:= dtoc(cdata)
							#ENDIF
						Else
							cData2:= "  /  /    "
						Endif
						aCols[Len(aCols)][nY] := Ctod(cData2)
					else
						aCols[Len(aCols)][nY] := (cAlias)->(FieldGet(FieldPos(aHeader[nY,2])))
					EndIf
				Next nY
				aCols[Len(aCols)][Len(aHeader)+1] := .F.
				dbSkip()
			EndDo

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ao reabrir a tela de complementos apos exclusao, deve-se verificar os campos que devem ser preenchidos pela	³
			//³rotina, coloca-los em ordem e apresentar na tela todos os itens da nota fiscal novamente						³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		  	If cTabela $ "CD5/CD6"
			  	For nG := 1 To Len(aPermite)
					If aScan(aCols,{|aX|aX[1]==aPermite[nG,7]})==0
						aAdd(aCols,Array(Len(aHeader)+1))
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Importacao - Itens excluidos sao reabertos com o campo CD5_ITEM preenchido.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	                    If cTabela == "CD5"
							aCols[Len(aCols)][1]	:=	aPermite[nG,7]

							For nY := 2 To Len(aHeader)
								aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
								aCols[Len(aCols)][Len(aHeader)+1] := .F.
							Next nY
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Combustiveis - Itens excluidos sao reabertos com os campos CD6_ITEM e CD6_COD preenchidos.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Elseif cTabela == "CD6"
							aCols[Len(aCols)][1]	:=	aPermite[nG,7]
							aCols[Len(aCols)][2]	:=	aPermite[nG,8]

							For nY := 3 To Len(aHeader)
								aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
								aCols[Len(aCols)][Len(aHeader)+1] := .F.
							Next nY
						Endif

					EndIf
				Next nG
				aSort(aCols,,,{|x,y| x[1]<y[1]})
			 EndIf
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Fecha as areas montadas para o filtro³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		T521Close(cTabela,cArqInd,cAlias,lQuery)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Passa o conteudo do aHeader e do aCols de acordo com o complemento         ³
		//³Carrega o aCols com os itens que devem gerar o complemento em notas fiscais³
		//³que ainda nao possuam o complemento cadastrado.                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			// processos referenciados
			aHProc	:=	aHeader
			aCProc	:=	aCols


          endif


Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³T521Filtro³ Autor ³ Mary C. Hergert       ³ Data ³ 26/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua o filtro/query de todos os complementos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Nome da tabela                                     ³±±
±±³          ³ ExpC2 = Indice criado para codebase                        ³±±
±±³          ³ ExpC3 = Alias criado para top                              ³±±
±±³          ³ ExpL4 = Indicacao de top/codebase                          ³±±
±±³          ³ ExpC5 = Numero da nota fiscal                              ³±±
±±³          ³ ExpC6 = Serie da nota fiscal                               ³±±
±±³          ³ ExpC7 = Especie da nota fiscal                             ³±±
±±³          ³ ExpC8 = Cliente/fornecedor                                 ³±±
±±³          ³ ExpC9 = Loja do cliente/fornecedor                         ³±±
±±³          ³ ExpCA = Indicacao de entrada/saida                         ³±±
±±³          ³ ExpCB = Indica se a NF e de devol./beneficiamento          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nao ha.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Mata521                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function T521Filtro(cTabela,cArqInd,cChave,cAlias,lQuery,cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF)

Local aArea		:= GetArea()
Local cWhere	:= ""
Local cCondicao := ""
Local cCampo	:= ""

Local lPossui	:= .F.

#IFDEF TOP
	Local cFrom		:= ""
	Local cOrder	:= ""
#ENDIF

cAlias := cTabela
dbSelectArea(cTabela)

If Left(cTabela,2) $ "CD"
	cCampo	:= SubStr(cTabela,1,3)
Else
	cCampo	:= SubStr(cTabela,2,3)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a chave e a condicao padrao para todos os filtros³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	cFrom		:= "%" + RetSqlName(cTabela) + " " + cTabela + "%"
	cOrder		:= "%" + SqlOrder((cTabela)->(IndexKey())) + "%"
	cWhere		:= "%" + cTabela + "." + cCampo + "_FILIAL" + " = '" + xFilial(cTabela) + "' AND "
#ELSE
	cChave		:= (cTabela)->(IndexKey())
	cCondicao 	:= cCampo + '_FILIAL == "' + xFilial(cTabela) + '" .AND. '
#ENDIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a expressao para TOP³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cWhere		+= "CDG.CDG_TPMOV = '" + cEntSai + "' AND "
cWhere		+= "CDG.CDG_DOC = '" + cDoc + "' AND "
cWhere		+= "CDG.CDG_SERIE = '" + cSerie + "' AND "
cWhere		+= "CDG.CDG_CLIFOR = '" + cClieFor + "' AND "
cWhere		+= "CDG.CDG_LOJA = '" + cLoja  + "' AND "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a expressao para codebase³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCondicao 	+= 'CDG_TPMOV == "' + cEntSai + '" .AND. '
cCondicao 	+= 'CDG_DOC == "' + cDoc + '" .AND. '
cCondicao 	+= 'CDG_SERIE == "' + cSerie + '" .AND. '
cCondicao 	+= 'CDG_CLIFOR == "' + cClieFor + '" .AND. '
cCondicao 	+= 'CDG_LOJA == "' + cLoja + '"'

If !Empty(cWhere) .Or. !Empty(cCondicao)

	#IFDEF TOP
	    If TcSrvType()<>"AS/400"

			lQuery 	:= .T.
			cAlias	:= GetNextAlias()

			cWhere	+= cTabela + ".D_E_L_E_T_= ' ' %"

			BeginSql Alias cAlias

				SELECT *
				FROM %Exp:cFrom%
				WHERE %Exp:cWhere%
				ORDER BY %Exp:cOrder%
			EndSql

			dbSelectArea(cAlias)

		Else
	#ENDIF
			lQuery	:= .F.
			cArqInd	:=	CriaTrab(Nil,.F.)
			IndRegua(cAlias,cArqInd,cChave,,cCondicao,STR0044) //"Selecionado registros"
			#IFNDEF TOP
				DbSetIndex(cArqInd+OrdBagExt())
			#ENDIF
			(cAlias)->(dbGotop())
	#IFDEF TOP
		Endif
	#ENDIF

Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se possui o complemento ou será incluido.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do While !(cAlias)->(Eof())
	lPossui := .T.
	Exit
Enddo

(cAlias)->(dbGotop())

RestArea(aArea)

Return lPossui

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ T521Close³ Autor ³ Mary C. Hergert       ³ Data ³ 26/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Fecha as areas abertas pela funcao de filtro               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Nome da tabela                                     ³±±
±±³          ³ ExpC2 = Indice criado para codebase                        ³±±
±±³          ³ ExpC3 = Alias criado para top                              ³±±
±±³          ³ ExpL4 = Indicacao de top/codebase                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nao ha.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Mata521                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function T521Close(cTabela,cArqInd,cAlias,lQuery)

If !lQuery
	RetIndex(cTabela)
	dbClearFilter()
	Ferase(cArqInd+OrdBagExt())
Else
	dbSelectArea(cAlias)
	dbCloseArea()
Endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³T521Valid ³ Autor ³ Mary C. Hergert       ³ Data ³ 26/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida as informacoes apresentadas                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC5 = Numero da nota fiscal                              ³±±
±±³          ³ ExpC6 = Serie da nota fiscal                               ³±±
±±³          ³ ExpC7 = Especie da nota fiscal                             ³±±
±±³          ³ ExpC8 = Cliente/fornecedor                                 ³±±
±±³          ³ ExpC9 = Loja do cliente/fornecedor                         ³±±
±±³          ³ ExpCA = Indicacao de entrada/saida                         ³±±
±±³          ³ ExpCB = Indica se a NF e de devol./beneficiamento          ³±±
±±³          ³ ExpAC = Itens do complemento de medicamentos               ³±±
±±³          ³ ExpAD = Itens do complemento de armas de fogo              ³±±
±±³          ³ ExpAE = Itens do complemento de veiculos                   ³±±
±±³          ³ ExpAF = Itens do complemento de combustiveis               ³±±
±±³          ³ ExpAG = Itens do complemento de energia eletrica           ³±±
±±³          ³ ExpAH = Itens do complemento de gas canalizado             ³±±
±±³          ³ ExpAI = Itens do complemento de comunicacao/telecom.       ³±±
±±³          ³ ExpAJ = Complementos sugeridos pelo sistema                ³±±
±±³          ³ Exp1K = Array com as guias de recolhimento referenciadas   ³±±
±±³          ³ Exp1L = Array com os cupons fiscais referenciados          ³±±
±±³          ³ Exp1M = Array com os documentos referenciados              ³±±
±±³          ³ Exp1N = Array com os locais de coleta/entrega              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nao ha.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Mata521                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function T521Valid(cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF,aGets,aObrigat,aMantem)

Local aCols		:= {}
Local aHeader	:= {}
Local aCabec	:= {"aHProc"}
Local aItem		:= {"aCProc"}

Local lGrava	:= .T.
Local lTabCDT	:= AliasIndic("CDT")

Local nX 		:= 0

For nX := 1 to Len(aCabec)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta o aHeader e o aCols generico para efetuar a gravacao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHeader	:= &(aCabec[nX])

	If ValType(aGets[nX]) == "O"
		aCols 	:= aGets[nX]:aCols
	Else
		aCols	:= {}
	Endif

	If ValType(aGets[nX]) == "O"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Efetua as validacoes de todos os complementos que devem ser      ³
		//³gerados para a nota fiscal. Somente apos a validacao de todos os ³
		//³complementos e que sera efetuada a gravacao.                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If T521Exist(aCols) .And. !T521Proc(aGets[nX],aObrigat,.T.)
			lGrava := .F.
		Endif
	Endif
Next


Return lGrava


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³T521Fim   ³ Autor ³ Mary C. Hergert       ³ Data ³ 26/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua as gravacoes nas tabelas                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC5 = Numero da nota fiscal                              ³±±
±±³          ³ ExpC6 = Serie da nota fiscal                               ³±±
±±³          ³ ExpC7 = Especie da nota fiscal                             ³±±
±±³          ³ ExpC8 = Cliente/fornecedor                                 ³±±
±±³          ³ ExpC9 = Loja do cliente/fornecedor                         ³±±
±±³          ³ ExpCA = Indicacao de entrada/saida                         ³±±
±±³          ³ ExpCB = Indica se a NF e de devol./beneficiamento          ³±±
±±³          ³ Exp1M = Array com os documentos referenciados              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nao ha.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Mata521                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function T521Fim(cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF,aMantem,aGets)

Local aArea		:= GetArea()
Local aCols		:= {}
Local aHeader	:= {}
Local aCabec	:= {"aHProc"}
Local aItem		:= {"aCProc"}
Local aDeleta	:= {}
Local aDel		:= {}
Local aPos		:= {0,0,0,0,0,0}

Local lExiste	:= .F.
Local lRet		:= .F.
Local lAtualiza	:= .T.
Local lComplem	:= .T.
Local lGrava	:= .T.
Local lPassou   := .F.

Local nX 		:= 0
Local nY		:= 0
Local nZ		:= 0
Local nI		:= 0
Local nPos		:= 0
Local nPos2		:= 0
Local nPos4		:= 0
Local nCount	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Setando o indice das tabelas que serao atualizadas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CDG->(dbSetOrder(1))

//ProcRegua(Len(aCompl))

Begin Transaction

	For nX := 1 to Len(aCabec)

	   //	IncProc(aCompl[nX][1])

		aDeleta := {}
		aDel	:= {}

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta o aHeader e o aCols generico para efetuar a gravacao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aHeader	:= &(aCabec[nX])

		If ValType(aGets[nX]) == "O"
			aCols 	:= aGets[nX]:aCols
		Else
			aCols	:= {}
		Endif

		If ValType(aGets[nX]) == "O"

			lRet 		:= .T.

			Do Case

				Case nX  == 1

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Somente efetua o processo de gravacao se existir informacoes no aCols³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If T521Exist(aCols)

						nPos	:= aScan(aHeader,{|x| Alltrim(x[2])=="CDG_PROCES"})
						nPos2	:= aScan(aHeader,{|x| Alltrim(x[2])=="CDG_TPPROC"})

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se existem campos deletados e nao deletados de mesma chave³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						For nI := 1 to Len(aCols)
							If aCols[nI][Len(aHeader)+1]
								aAdd(aDel,{aCols[nI][nPos],aCols[nI][nPos2]})
							Endif
						Next

						For nI := 1 to Len(aCols)
							If !aCols[nI][Len(aHeader)+1]
								If aScan(aDel,{|x| x[1] == aCols[nI][nPos] .And. x[2] == aCols[nI][nPos2]}) > 0
									aAdd(aDeleta,{aCols[nI][nPos],aCols[nI][nPos2]})
								Endif
							Endif
						Next

						For nY := 1 to Len(aCols)

							lExiste 	:= CDG->(dbSeek(xFilial("CDG")+cEntSai+cDoc+cSerie+cClieFor+cLoja+aCols[nY][nPos]+aCols[nY][nPos2]))
							lAtualiza 	:= .T.

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o item nao esta excluido no aCols³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If !aCols[nY][Len(aHeader)+1]
								If lExiste
									RecLock("CDG",.F.)
								Else
									RecLock("CDG",.T.)
									CDG->CDG_FILIAL	:= xFilial("CDG")
									CDG->CDG_TPMOV	:= cEntSai
									CDG->CDG_DOC	:= cDoc
									CDG->CDG_SERIE	:= cSerie
									CDG->CDG_CLIFOR	:= cClieFor
									CDG->CDG_LOJA	:= cLoja
									CDG->CDG_CANC   := "S"
									lExiste := .T.
									lPassou := .T.
								Endif
								For nZ := 1 To Len(aHeader)
									CDG->(FieldPut(FieldPos(aHeader[nZ][2]),aCols[nY][nZ]))
									lPassou := .T.
								Next nY

								MsUnLock()
								FkCommit()
							Else
								// Exclusao
								If lExiste .And. aScan(aDeleta,{|x| x[1] == aCols[nY][nPos] .And. x[2] == aCols[nY][nPos2]}) == 0
									If nCount <= 0
						                lAtualiza := .F.
										RecLock("CDG",.F.)
										CDG->(dbDelete())
										MsUnLock()
										FkCommit()
										nCount ++
									Endif
								Endif
							Endif

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Atualiza o array com os documentos que permanecerao na tabela³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lAtualiza
								nPos4 := aScan(aMantem[2],{|x| x[1]+x[2] ==;
										 aCols[nY][nPos]+aCols[nY][nPos2]})
								If nPos4 > 0
									aMantem[2][nPos4][3] := .T.
								Endif
							Endif
						Next
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Como no processo referenciado o numero e tipo de processo e a informacao complementar          ³
						//³fazem parte da chave e e possivel altera-los, apos a atualizacao das informacoes complementares³
						//³exclui-se as referencias que existiam na base mas nao existem mais devido a alteracao no acols.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						For nI := 1 to Len(aMantem[2])
							If !aMantem[2][nI][3]
								If CDG->(dbSeek(xFilial("CDG")+cEntSai+cDoc+cSerie+cClieFor+cLoja+aMantem[2][nI][1]+aMantem[2][nI][2]))
									RecLock("CDG",.F.)
									CDG->(dbDelete())
									MsUnLock()
									FkCommit()
								Endif
							Endif
						Next
					Else
				   		Help("  ",1,"A926ProcObr")
    					lRet := .F.
					Endif
			EndCase
		Endif
	Next

End Transaction

If (!lExiste  .Or. (!lPassou .And. nCount > 0))
   	Help("  ",1,"A926ProcObr")
    lRet := .F.
EndIf


RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³T521Proc  ³ Autor ³ Mary C. Hergert       ³ Data ³ 26/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua as validacoes dos processos referenciados           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto que contem a get dados                      ³±±
±±³Parametros³ ExpA2 = Array com os campos obrigatorios                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nao ha.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Mata521                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function T521Proc(oGetProc,aObrigat,lFinal)

Local aCols		:= oGetProc:aCols
Local aPos		:= {}
Local aProcess	:= {}

Local lRet		:= .T.
Local lRepete	:= .F.
Local lObrigat	:= .F.

Local nX		:= 0
Local nI		:= 0
Local nAt		:= oGetProc:nAt

aAdd(aPos,aScan(aHProc,{|x| Alltrim(x[2])=="CDG_IFCOMP"}))
aAdd(aPos,aScan(aHProc,{|x| Alltrim(x[2])=="CDG_TPPROC"}))
aAdd(aPos,aScan(aHProc,{|x| Alltrim(x[2])=="CDG_PROCES"}))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se algum campo obrigatorio nao foi digitado³
//³(apenas da linha que esta sendo manipulada - aT)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lFinal .And. !(aCols[nAt][Len(aHProc)+1])
	If T521Obrig(aObrigat,aHProc,aCols[nAt],10)
		lObrigat := .T.
	Endif
Endif

For nX := 1 to Len(aCols)

	If !(aCols[nX][Len(aHProc)+1])

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se algum campo obrigatorio nao foi digitado em todos os itens³
		//³(somente quando for validacao do ok da rotina)                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lFinal
			lObrigat := T521Obrig(aObrigat,aHProc,aCols[nX],10)
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o processo + informacao complementar nao foi digitado em outra linha³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aScan(aProcess,{|x| x[1] == aCols[nX][aPos[1]] .And. x[2] == aCols[nX][aPos[2]] .And. x[3] == aCols[nX][aPos[3]]}) > 0
			lRepete := .T.
		Endif
		aAdd(aProcess,{aCols[nX][aPos[1]],aCols[nX][aPos[2]],aCols[nX][aPos[3]]})

	Endif
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informa se o processo + informacao complementar nao foi digitado em outra linha³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRepete
	Help("  ",1,"A926Proc")
	lRet := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informa se existe algum campo obrigatorio que nao foi preenchido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lObrigat
	Help("  ",1,"A926ProcObr")
	lRet := .F.
Endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³T521Exist ³ Autor ³ Mary C. Hergert       ³ Data ³ 26/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o aCols foi preenchido ou se apenas foi criado ³±±
±±³          ³ em branco                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os campos do aCols                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Indicacao da existencia de campos no aCols                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Mata521                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function T521Exist(aCols)

Local lExiste	:= .F.

Local nX		:= 0
Local nY		:= 0

For nX := 1 to Len(aCols)

	If lExiste
		Exit
	Endif

	For nY := 1 to Len(aCols[nX])

		If ValType(aCols[nX][nY]) == "C"
			If !Empty(aCols[nX][nY])
				lExiste := .T.
				Exit
			Endif
		Endif

		If ValType(aCols[nX][nY]) == "N"
			If aCols[nX][nY] <> 0
				lExiste := .T.
				Exit
			Endif
		Endif

	Next

Next

Return lExiste

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ T521NF   ³ Autor ³ Mary C. Hergert       ³ Data ³ 26/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria o cabecalho dos complementos (fixo para todos os mode-³±±
±±³          ³ los com os dados da nota fiscal a ser complementada)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Painel onde os componentes serao inseridos         ³±±
±±³          ³ ExpO2 = Font a ser utilizada                               ³±±
±±³          ³ ExpN3 = Altura padrao dos objetos Say                      ³±±
±±³          ³ ExpN4 = Tamanho padrao dos objetos Say                     ³±±
±±³          ³ ExpN5 = Altura padrao dos objetos Get                      ³±±
±±³          ³ ExpC6 = Numero da nota fiscal                              ³±±
±±³          ³ ExpC7 = Serie da nota fiscal                               ³±±
±±³          ³ ExpC8 = Especie da nota fiscal                             ³±±
±±³          ³ ExpC9 = Codigo do cliente/fornecedor                       ³±±
±±³          ³ ExpCA = Loja do cliente/fornecedor                         ³±±
±±³          ³ ExpCB = Movimento de Entrada ou Saida                      ³±±
±±³          ³ ExpCC = Indica se a NF e de devol./beneficiamento          ³±±
±±³          ³ ExpAD = Coordenadas dos paineis principais                 ³±±
±±³          ³ ExpAE = Painel onde serao montados os dados da NF          ³±±
±±³          ³ ExpOF = Dialog principal                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nao ha.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Mata521                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function T521NF(oFont,nAltSay,nTamSay,nAltGet,cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF,oDlg)

Local aColuna		:= {15,65,145,185,250,298}
Local bSay			:= {|| Nil}
Local bVar			:= {|| Nil}
Local bWhen			:= {|| Nil}

Local cOpcao		:= ""
Local cPesqF3		:= ""

Local nLinSay		:= 19
Local nLinGet		:= 17
Local nTamGet		:= 55
Local nTamGet2		:= 30

Local oGrpNF
Local oPanel

Local   lDatRecb	:= .T.

oPanel	:= TPanel():New(15,5,'',oDlg,oDlg:oFont,.T.,.T.,,,360,75,.T.,.T.)
oGrpNF := TGroup():New(5,5,70,355,STR0042,oPanel,,,.T.,.T.) //"Informações do documento fiscal"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tipo de documento - entrada/saida³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cEntSai == "S")
     cOpcao = STR0038 //"Saída"
Else
	 cOpcao = STR0037 //"Entrada"
EndIf

bSay	:= &('{|| "' + STR0036 + '"}') // "Tipo"
TSay():New(nLinSay,aColuna[1],bSay,oGrpNF,,oFont,.F.,.F.,.F.,.T.,,,nTamSay,nAltSay,.F.,.F.,.F.,.F.,.F.)



bVar     := &("{ | u | If( PCount() == 0, cOpcao,cOpcao := u)}")
TGet():New(nLinGet,aColuna[2],bVar,oGrpNF,nTamGet,nAltGet,"@!",,,,,,,.T.,,, bWhen,,,,.T.,,,cDoc)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Data de Recebimento  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lDatRecb
   If CDT->(FieldPos("CDT_DTAREC")) > 0
		If CDT->(dbSeek(xFilial("CDT")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
			dDatReceb	:=	CDT->CDT_DTAREC
		EndIf

	  	bSay	:= &('{|| "' + "Data Recebimento" + '"}')
		TSay():New(nLinSay,aColuna[5],bSay,oGrpNF,,oFont,.F.,.F.,.F.,.T.,,,nTamSay,nAltSay,.F.,.F.,.F.,.F.,.F.)

		bVar     := &("{|u| If(PCount()== 0,dDatReceb,dDatReceb :=u)}")
		TGet():New(nLinGet,aColuna[6],bVar,oGrpNF,nTamGet,nAltGet,PesqPict("CDT","CDT_DTAREC"),,,,,,,.T.,,,,,,,,,,)

		nLinSay := nLinSay + 18
		nLinGet := nLinGet + 18
	Endif
Endif
lDatRecb := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Numero da nota fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
bSay	:= &('{|| "' + STR0043 + '"}') // "Número"
TSay():New(nLinSay,aColuna[1],bSay,oGrpNF,,oFont,.F.,.F.,.F.,.T.,,,nTamSay,nAltSay,.F.,.F.,.F.,.F.,.F.)

bVar     := &("{ | u | If( PCount() == 0, cDoc,cDoc := u)}")
TGet():New(nLinGet,aColuna[2],bVar,oGrpNF,nTamGet,nAltGet,"@!",,,,,,,.T.,,, bWhen,,,,.T.,,,cDoc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Serie da nota fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
bSay	:= &('{|| "' + STR0035 + '"}') // "Serie"
TSay():New(nLinSay,aColuna[3],bSay,oGrpNF,,oFont,.F.,.F.,.F.,.T.,,,nTamSay,nAltSay,.F.,.F.,.F.,.F.,.F.)

bVar     := &("{ | u | If( PCount() == 0, cSerie,cSerie := u)}")
TGet():New(nLinGet,aColuna[4],bVar,oGrpNF,nTamGet2,nAltGet,"@!",,,,,,,.T.,,, bWhen,,,,.T.,,,cSerie)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Especie da nota fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
bSay	:= &('{|| "' + STR0039 + '"}') // "Espécie"
TSay():New(nLinSay,aColuna[5],bSay,oGrpNF,,oFont,.F.,.F.,.F.,.T.,,,nTamSay,nAltSay,.F.,.F.,.F.,.F.,.F.)

bVar     := &("{ | u | If( PCount() == 0, cEspecie,cEspecie := u)}")
TGet():New(nLinGet,aColuna[6],bVar,oGrpNF,nTamGet2,nAltGet,"@!",,,,,,,.T.,,, bWhen,,,,.T.,,"42")

nLinSay := nLinSay + 18
nLinGet := nLinGet + 18

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cliente/Fornecedor da nota fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
bSay	:= &('{|| "' + STR0040 + '"}') // "Cliente/fornecedor"
TSay():New(nLinSay,aColuna[1],bSay,oGrpNF,,oFont,.F.,.F.,.F.,.T.,,,nTamSay,nAltSay,.F.,.F.,.F.,.F.,.F.)

bVar     := &("{ | u | If( PCount() == 0, cClieFor,cClieFor := u)}")
TGet():New(nLinGet,aColuna[2],bVar,oGrpNF,nTamGet,nAltGet,"@!",,,,,,,.T.,,, bWhen,,,,.T.,,cPesqF3)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Loja da nota fiscal ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
bSay	:= &('{|| "' + STR0041 + '"}') // "Loja"
TSay():New(nLinSay,aColuna[3],bSay,oGrpNF,,oFont,.F.,.F.,.F.,.T.,,,nTamSay,nAltSay,.F.,.F.,.F.,.F.,.F.)

bVar     := &("{ | u | If( PCount() == 0, cLoja,cLoja := u)}")
TGet():New(nLinGet,aColuna[4],bVar,oGrpNF,nTamGet2,nAltGet,"@!",,,,,,,.T.,,, bWhen,,,,.T.,,)


Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³T521Obrig ³ Autor ³ Mary C. Hergert       ³ Data ³ 26/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se existem campos obrigatorios nao preenchidos    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os campos obrigatorios                   ³±±
±±³          ³ ExpA2 = Array com os campos da get dados                   ³±±
±±³          ³ ExpA3 = Array com o conteudo do campo                      ³±±
±±³          ³ ExpN4 = Numero que indica o complemento                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. para existencia de campos obrigatorios em branco       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Mata521                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function T521Obrig(aObrigat,aHeader,aCols,nComp)
Local lRet	:= .F.
Local nX	:= 0
Local nPos	:= 0
Local xConteudo
Local lObrigCmp	:=	.F.

For nX := 1 to Len(aObrigat[nComp])
	lObrigCmp	:=	.F.
	nPos := aScan(aHeader,{|x| x[2] == aObrigat[nComp][nX][1]})

	If nPos > 0
		xConteudo	:= aCols[nPos]

		If aObrigat[nComp][nX][2] == "C"
			If Empty(xConteudo)
				lRet := .T.
				lObrigCmp	:=	.T.
			Endif
		ElseIf aObrigat[nComp][nX][2] == "N"
			If xConteudo == 0
				lRet := .T.
				lObrigCmp	:=	.T.
			Endif
		Endif

		If aObrigat[nComp][nX][1] == "CDD_SERREF" .and. lRet
			aCols[2] := "   "
			lRet := .F.
		EndIf

	Endif

Next

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} A521VERPRS
Verificação e marcação do registro no MarkBrow e Vincula NFs
@sample   A521VERPRS(cId, cMarca)
@param    cId     - Indica o cId da Acao.
@param    cMarca  - valor de marcacao da markbrow().
@return   lRet (Boolean) - sempre verdadeiro.

@author   Eduardo Vicente
@since    27.02.2013
@version  P11.5
/*/
//-------------------------------------------------------------------

Static Function A521VERPRS(cId,cMarca)

Local aArea		:= GetArea()       //Salva a area atual
Local oMark		:= GetMarkBrow()   //Objeto do Browser Markbrow()
Local cInfMarc	:= If(IsMark("F2_OK", cMarca)," ",cMarca)   //Se ja esta marcado ira desmarcar caso contrario ira marcar.
Local cChave	:= ""              //Chave da nota fiscal vinculada

If cId == "1"
	Reclock("SF2",.F.)
	SF2->F2_OK := cInfMarc
	SF2->( MsUnlock() )

	If  (SF2->(FieldPos("F2_ECVINC1")) > 0) .And. (SF2->(FieldPos("F2_ECVINC2")) > 0)
	    cChave := xFilial("SF2")+PadR(SF2->F2_ECVINC1,Len(SF2->F2_DOC))+PadR(SF2->F2_ECVINC2,Len(SF2->F2_SERIE))

		If  SF2->( dbSeek(cChave) )
			While !( SF2->(Eof()) ) .And. (SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE == cChave)
				Reclock("SF2",.F.)
				SF2->F2_OK := cInfMarc
				SF2->( MsUnlock() )

				SF2->( dbSkip() )
			End
		EndIf
	EndIf
EndIf

RestArea(aArea)
oMark:Refresh()
Eval(bFiltraBrw)

Return .T.

//-----------------------------------------------------
/*/Verifica se integração com SIGAGFE para também eliminar as Notas Fiscais
@author Felipe Machado de Oliveira
@version P11
@since 18/04/2013
/*/
//------------------------------------------------------
Static Function MATA521IPG()
	Local lRet := .T.
	Local lIntGFE := SuperGetMv("MV_INTGFE",.F.,.F.)
	Local cIntGFE2 := SuperGetMv("MV_INTGFE2",.F.,"2")
	Local cIntNFS := SuperGetMv("MV_GFEI11",.F.,"2")

	//Integração Protheus com SIGAGFE
	If lIntGFE == .T. .And. cIntGFE2 $ "1" .And. cIntNFS == "1"
		If !MATA521ENF()
			lRet := .F.
		EndIf
	EndIf

Return lRet
//-----------------------------------------------------
/*/	Elimina a Nota Fiscal selecionadas no browse
@author Felipe Machado de Oliveira
@version P11
@since 18/04/2013
/*/
//------------------------------------------------------
Static Function MATA521ENF()
Local aAreaGW1 := GetArea("GW1")
Local lRet := .T.
Local oModelGW1 := FWLoadModel("GFEA044")
Local cF2_CDTPDC := ""
Local cEmisDc := ""
Local aArray := {}

Aadd(aArray, AllTrim(SF2->F2_DOC)     + Space( TamSx3("GW1_CDTPDC")[1] -(Len( AllTrim(SF2->F2_DOC))) ) )
Aadd(aArray, AllTrim(SF2->F2_SERIE)   + Space( TamSx3("GW1_SERDC")[1]  -(Len( AllTrim(SF2->F2_SERIE))) ) )
Aadd(aArray, AllTrim(SF2->F2_CLIENTE) + Space( TamSx3("F2_CLIENTE")[1] -(Len( AllTrim(SF2->F2_CLIENTE))) ) )
Aadd(aArray, AllTrim(SF2->F2_LOJA)    + Space( TamSx3("F2_LOJA")[1]    -(Len( AllTrim(SF2->F2_LOJA))) ) )
Aadd(aArray, AllTrim(SF2->F2_TIPO)    + Space( TamSx3("F2_TIPO")[1]    -(Len( AllTrim(SF2->F2_TIPO))) ) )

cF2_CDTPDC := Posicione("SX5",1,xFilial("SX5")+"MQ"+AllTrim(aArray[5])+"S","X5_DESCRI")

If Empty(cF2_CDTPDC)
	cF2_CDTPDC := Posicione("SX5",1,xFilial("SX5")+"MQ"+AllTrim(aArray[5]),"X5_DESCRI")
EndIf

cF2_CDTPDC := AllTrim(cF2_CDTPDC) + Space( TamSx3("GW1_CDTPDC")[1] -(Len( AllTrim(cF2_CDTPDC))) )
cEmisDc := OMSM011COD(,,,.T.,xFilial("SF2"))

dbSelectArea("GW1")
GW1->( dbSetOrder(1) )
GW1->( dbSeek( xFilial("GW1")+cF2_CDTPDC+cEmisDc+aArray[2]+aArray[1] ) )
If !GW1->( Eof() ) .And. GW1->GW1_FILIAL == xFilial("GW1");
					 .And. AllTrim(GW1->GW1_CDTPDC) == AllTrim(cF2_CDTPDC);
					 .And. AllTrim(GW1->GW1_EMISDC) == AllTrim(cEmisDc);
					 .And. AllTrim(GW1->GW1_SERDC) == AllTrim(aArray[2]);
					 .And. AllTrim(GW1->GW1_NRDC) == AllTrim(aArray[1])

	oModelGW1:SetOperation( MODEL_OPERATION_DELETE )
	oModelGW1:Activate()

	If oModelGW1:VldData()
		oModelGW1:CommitData()
	Else
		Help( ,, STR0007,,"Inconsistência com o Frete Embarcador (SIGAGFE): "+CRLF+CRLF+oModelGW1:GetErrorMessage()[6], 1, 0,,,,,.T. ) //"Atenção"##"Inconsistência com o Frete Embarcador (SIGAGFE): "##
		lRet := .F.
	EndIf

	oModelGW1:Deactivate()

EndIf

If SuperGetMv("MV_FATGFE",.F.,"2") == "2"
	//Exclui a nota da GW0
	OMSM011GW0()
EndIf

RestArea(aAreaGW1)

Return lRet
