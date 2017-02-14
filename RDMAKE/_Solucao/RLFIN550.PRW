#INCLUDE "FINR550.CH"                          
#INCLUDE "PROTHEUS.CH"
#TRANSLATE INSIDE(<cTp>)  ;
	=> If(mv_par11 != 1, .T.,<cTp> $ cTipos)

#DEFINE S1_DAT					1
#DEFINE S1_HISTORICO			2
#DEFINE S1_TITULO				3
#DEFINE S1_EMISSAO			4
#DEFINE S1_VENCIMENTO		5
#DEFINE S1_BAIXA				6
#DEFINE S1_DEBITO				7
#DEFINE S1_CREDITO			8
#DEFINE S1_SALDO_ATU			9
#DEFINE S1_DIGITO				10

#DEFINE S2_DESCRICAO			1
#DEFINE S2_SD_ANTERIOR		2
#DEFINE S2_DIG1				3
#DEFINE S2_DEB					4
#DEFINE S2_CRED				5
#DEFINE S2_SD_ATUAL			6
#DEFINE S2_DIG2				7

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR550  ³ Autor ³ Daniel Tadashi Batori ³ Data ³ 23.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Razonete de Cliente/Fornecedores							        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR550(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FINR550()
Local oReport
Private cAuxFoot	:= ""
Private lImprime	:= .F.
Private nSaldoAtu	:= 0

If FindFunction("TRepInUse") .And. TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	Return FINR550R3() // Executa versão anterior do fonte
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ReportDef³ Autor ³ Daniel Batori         ³ Data ³ 23.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Definicao do layout do Relatorio									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
Local oReport  
Local oSection1
Local oSection2
Local nTamTit     

oReport := TReport():New("FINR550",STR0007,"FIN550", {|oReport| ReportPrint(oReport)},STR0001+STR0002+STR0003) //"RAZONETE DE CONTAS CORRENTES DE "

AjustaSX1()

Pergunte("FIN550",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01            // A partir de                          ³
//³ mv_par02            // Ate a data                           ³
//³ mv_par03            // Carteira (Receber ou Pagar)          ³
//³ mv_par04            // Do Codigo                            ³
//³ mv_par05            // Ate o Codigo                         ³
//³ mv_par06            // Imprime Valores Financeiros (Sim/Nao)³
//³ mv_par07            // Impime (Todos,Normais,Adiantamentos) ³
//³ mv_par08            // Do Prefixo                           ³
//³ mv_par09            // Ate o Prefixo                        ³
//³ mv_par10            // Lista Por 1 - Filial     2 -Empresa  ³
//³ mv_par11            // Seleciona Tipos                      ³
//³ mv_par12            // Natureza de  ?                       ³
//³ mv_par13            // Natureza ate ?                       ³
//³ mv_par14            // Anal¡tico/Sint‚tico                  ³
//³ mv_par15            // Filtra Prefixo para Saldo Anterior   ³
//³ mv_par16            // Folha De ?                           ³
//³ mv_par17            // Folha Ate ?                          ³
//³ mv_par18            // Filtra Contas Contabeis              ³
//³ mv_par19            // Conta Inicial                        ³
//³ mv_par20            // Conta Final                          ³
//³ mv_par21            // Impr. Saldo Contabil                 ³
//³ mv_par22            // Impr. Cli/Forn s/ Movim.?            ³
//³ mv_par23  			   // Linhas por Página ?                  ³
//| mv_par24            // Historico                            |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:SetPortrait(.T.)

nTamTit	:= TamSX3("E1_PREFIXO")[1] + TamSX3("E1_NUM")[1] + TamSX3("E1_PARCELA")[1] + 3

oSection1 := TRSection():New(oReport,STR0068,{"cNomeArq"},) //"Analítico"
TRCell():New(oSection1,"E1_VENCTO","SE1",STR0056,,10,.F.,) //"DATA"
TRCell():New(oSection1,"E1_HIST","SE1",STR0057,,30,.F.,) //"HISTORICO"
TRCell():New(oSection1,"TITULO",,STR0058,,nTamTit,.F.,)  //"PRF NUMERO PC"
TRCell():New(oSection1,"E1_EMISSAO"	,"SE1",STR0059,,,.F.,) //"EMISSAO"
TRCell():New(oSection1,"E1_VENCREA","SE1",STR0060,,,.F.,) //"VENCTO"
TRCell():New(oSection1,"E2_DTFATUR","SE2",STR0061,,,.F.,) //"BAIXA"
TRCell():New(oSection1,"E1_VLCRUZ","SE1",STR0062,,,.F.,) //"DEBITO"
TRCell():New(oSection1,"E2_VLCRUZ","SE2",STR0063,,,.F.,) //"CREDITO"
TRCell():New(oSection1,"E1_SALDO","SE1",STR0064,,,.F.,) //"SALDO ATUAL"
TRCell():New(oSection1,"DIGITO",,"DC",,1,.F.,) 
oSection1:AutoSize()

oSection2 := TRSection():New( oReport,STR0069, {"cNomeArq"},) //Sintético"
TRCell():New(oSection2,"DESCRICAO",,,,62,.F.,) //"CLIENTE"/"FORNECEDOR"
TRCell():New(oSection2,"E2_SALDO","SE2",STR0067,,,.F.,) //"SALDO ANTERIOR"
TRCell():New(oSection2,"DIGITO1",,"DC1",,1,.F.,) 
TRCell():New(oSection2,"E1_VLCRUZ","SE1",STR0062,,,.F.,) //"DEBITO"
TRCell():New(oSection2,"E2_VLCRUZ","SE2",STR0063,,,.F.,) //"CREDITO"
TRCell():New(oSection2,"E1_SALDO","SE1",STR0064,,,.F.,) //"SALDO ATUAL"
TRCell():New(oSection2,"DIGITO2",,"DC2",,1,.F.,)
oSection2:AutoSize() 

Return oReport                                                                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Daniel Batori          ³ Data ³22.08.06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport)
Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)

Local aSec1[11]
Local aSec2[7]
Local cTexto
LOCAL cString:="SE1"
Local cTitulo
LOCAL CbCont,CbTxt
LOCAL nQuebra:=0,lImprAnt := .F.
LOCAL cNome,nTotDeb:=0,nTotCrd:=0,nTotDebG:=0,nTotCrdG:=0,nSalAtuG:=0,nSalAntG:=0
LOCAL dEmissao:=CTOD(""),dVencto:=CTOD("")
LOCAL nRec,nPrim,cPrefixo,cNumero,cParcela,cTipo,cNaturez,nValliq
LOCAL nAnterior:=0,cAnterior,cFornece,dDtDigit,cRecPag,cSeq
LOCAL cCodigo, cLoja
LOCAL lNoSkip := .T.
LOCAL lFlag := .F.
LOCAL nSaldoFinal:=0
LOCAL aCampos:={},aTam:={}
LOCAL aInd:={}
LOCAL cCondE1:=cCondE2:=cCondE5:=" "
LOCAL cIndE1 :=cIndE2 :=cIndE5 :=cIndA1 :=cIndA2 :=" "
LOCAL nRegAtu
Local bBlockDC := {| nNum | if(int(nNum*100)=0," ",if(nNum>0,"C","D")) }
Local nX := 0

Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
#IFDEF TOP
	Local aStru 	:= {}
#ELSE
	Local nRec1
#ENDIF	
Local aSdoContabil
Local nTamNro	:= TamSx3("E1_NUM")[1]
Local nTamParc := TamSx3("E1_PARCELA")[1]
Local nTamTitulo := TamSx3("E1_PREFIXO")[1] + nTamNro + nTamParc + 3
Local nI
Local aDados := Array(If(lPccBaixa,17,11))
Local aImp10925:= {}
Local aDadosAbat:= {}
Local nLinReport := 8
Local nLinPag	 := 0
Local nSaldoTra  := 0
//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default))
Local lPccBxCr			:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)

Local cCtContAnt	:= ""

If !Empty(mv_par23)
	nLinPag := IIf(MV_PAR23>=70,70,MV_PAR23)
Else
	nLinPag := 70	
EndIf		



lImprime := .F.

cTipos := ""

oSection1:Cell("E1_VENCTO"):SetBlock( { || aSec1[S1_DAT] })
oSection1:Cell("E1_HIST"):SetBlock( { || aSec1[S1_HISTORICO] })
oSection1:Cell("TITULO"):SetBlock( { || aSec1[S1_TITULO] })
oSection1:Cell("E1_EMISSAO"):SetBlock( { || aSec1[S1_EMISSAO] })
oSection1:Cell("E1_VENCREA"):SetBlock( { || aSec1[S1_VENCIMENTO] })
oSection1:Cell("E2_DTFATUR"):SetBlock( { || aSec1[S1_BAIXA] })
oSection1:Cell("E1_VLCRUZ"):SetBlock( { || aSec1[S1_DEBITO] })
oSection1:Cell("E2_VLCRUZ"):SetBlock( { || aSec1[S1_CREDITO] })
oSection1:Cell("E1_SALDO"):SetBlock( { || aSec1[S1_SALDO_ATU] })
oSection1:Cell("DIGITO"):SetBlock( { || aSec1[S1_DIGITO] })
oSection1:Cell("DIGITO"):HideHeader()

oSection2:Cell("DESCRICAO"):SetBlock( { || aSec2[S2_DESCRICAO] })
oSection2:Cell("DESCRICAO"):SetTitle(If(mv_par03==1,STR0008,STR0009))
oSection2:Cell("E2_SALDO"):SetBlock( { || aSec2[S2_SD_ANTERIOR] })
oSection2:Cell("DIGITO1"):SetBlock( { || aSec2[S2_DIG1] })
oSection2:Cell("DIGITO1"):HideHeader()
oSection2:Cell("E1_VLCRUZ"):SetBlock( { || aSec2[S2_DEB] })
oSection2:Cell("E2_VLCRUZ"):SetBlock( { || aSec2[S2_CRED] })
oSection2:Cell("E1_SALDO"):SetBlock( { || aSec2[S2_SD_ATUAL] })
oSection2:Cell("DIGITO2"):SetBlock( { || aSec2[S2_DIG2] })
oSection2:Cell("DIGITO2"):HideHeader()
                                                                           
If mv_par14 == 1  // Analitico
	oSection1:SetHeaderPage()
	oSection2:SetHeaderSection(.F.)
	oSection1:OnPrintLine({|| F550LinPag(nLinPag,@nLinReport,oReport,@nSaldoTra)})
Else
	oSection1:SetHeaderSection(.F.)
	oSection2:OnPrintLine({|| F550LinPag(nLinPag,@nLinReport,oReport,@nSaldoTra)})
EndIf

//impressao do numero de pagina conforme pergunta 16 e 17
oReport:SetPageNumber(MV_PAR16)
oReport:OnPageBreak({||	If ( oReport:Page() > MV_PAR17, oReport:SetPageNumber(2), "") })

oReport:SetPageFooter( 5 , {|| IIF((lImprime .Or. (nSaldoAtu != 0)),;
									F550RODAPE(oReport,nSaldoTra,Eval(bBlockDC,nSaldoTra),aSec1), nil) } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para Filtrar os tipos sem entrar na tela do ³
//³ FINRTIPOS(), localizacao Argentina.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF cPaisLoc # "BRA"
	IF EXISTBLOCK("FARGTIP")
		cTipos	:=	EXECBLOCK("FARGTIP")
	ENDIF
ENDIF		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alimenta vetor com os impostos que devem gerar movimentos de historico ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aImp10925,{"SE2->E2_VRETPIS","Pis"})
aadd(aImp10925,{"SE2->E2_VRETCOF","Cofins"})
aadd(aImp10925,{"SE2->E2_VRETCSL","Csll"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Referencia para imprimir descricao dos tipos de cliente A1_TIPO ³
//ÀÄLocalizacoesÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc # "BRA"
	SX3->(dbSetOrder(2))
	SX3->(dbSeek("A1_TIPO"))
	If SX3->(Found())
		cTipoCli := AllTrim(SX3->(X3CBox()) )
		cTipoCli := '{"'+StrTran(cTipoCli,';','","')+'"}'
		aTipoCli := &(cTipoCli)
	Else            
		cTipoCli := ""
		aTipoCli := {}
	EndIf
EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se seleciona tipos                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par11 == 1
	finRTipos()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ For‡a ser por filial quando exista somente 1 filial,indepen- ³
//³ dente da resposta                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mv_par10 := If(SM0->(Reccount())==1,1,mv_par10) // Lista Por 1 - Filial     2 -Empresa

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo := oReport:Title() + " " + If(mv_par03==1,STR0008,STR0009)  //"RAZONETE DE CONTAS CORRENTES DE "###"CLIENTES"###"FORNECEDORES"
oReport:SetTitle(cTitulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("E1_CLIENTE")
aAdd(aCampos,{"CODIGO" ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E1_LOJA")
aAdd(aCampos,{"LOJA"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E1_EMISSAO")
aAdd(aCampos,{"DATAEM"   ,"D",aTam[1],aTam[2]})
aAdd(aCampos,{"NUMERO" ,"C",nTamTitulo,0})
aTam:=TamSX3("E1_TIPO")
aAdd(aCampos,{"TIPO"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E1_PORTADO")
aAdd(aCampos,{"BANCO"  ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E1_EMISSAO")
aAdd(aCampos,{"EMISSAO","D",aTam[1],aTam[2]})
aAdd(aCampos,{"BAIXA"  ,"D",aTam[1],aTam[2]})
aTam:=TamSX3("E1_VENCREA")
aAdd(aCampos,{"VENCTO" ,"D",aTam[1],aTam[2]})
aAdd(aCampos,{"VALOR"  ,"N",18,2})
aAdd(aCampos,{"HISTOR" ,"C",40,0})
aAdd(aCampos,{"DC"     ,"C", 1,0})
aAdd(aCampos,{"MOEDA"  ,"N", TamSX3("E1_MOEDA")[1],0}) // Utilizada para saldo contabil
aAdd(aCampos,{"CONTA"	,"C", TamSX3(IIf(mv_par03 == 1, "A1_CONTA", "A2_CONTA"))[1],0})	//Incluido este campo para a aglutinacao por loja
cNomeArq := CriaTrab(aCampos)
dbUseArea( .T., __cRDDNTTS, cNomeArq, "cNomeArq", if(.F. .Or. .F., !.F., NIL), .F. )

IF mv_par03 == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza e grava titulos a receber dentro dos parametros     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	dbSetOrder(2)
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			aStru:= SE1->(dbStruct())
			cCondE1:=".T."
			cQuery := "SELECT * FROM " + RetSqlName("SE1") + " WHERE"
			cIndE1	:=IndexKey()
			If mv_par10 = 1
				cQuery += " E1_FILIAL = '" + xFilial("SE1") + "' AND "
			else
				cQuery += " E1_FILIAL BETWEEN '  ' AND 'ZZ' AND"	  
				cIndE1 :=Right(cIndE1,Len(cIndE1)-10)
			endif
			cIndE1 := SqlOrder(cIndE1)
			
			dbSelectArea("SE1")
			dbCloseArea()
			dbSelectArea("SA1")
			
			cQuery += " E1_CLIENTE BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'"
			cQuery += " AND E1_EMISSAO <= '" + DTOS(dDataBase) + "'"
			cQuery += " AND E1_EMISSAO <= '" + DTOS(mv_par02) + "'"
			cQuery += " AND E1_TIPO NOT LIKE 'PR%'"
			If mv_par15 == 1
				cQuery += " AND E1_PREFIXO BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
			Endif
			cQuery += " AND E1_NATUREZ BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "'"
			If mv_par11 == 1
				cQuery += " AND E1_TIPO IN " + FORMATIN(cTipos,"/")
			Endif
			cQuery += " AND D_E_L_E_T_ <> '*'"  
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica quais serao impressos                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
			If mv_par07 == 2 // So'Normais
				cQuery += " And E1_TIPO NOT IN " + FORMATIN(MVRECANT,"/") 
			Endif                                            
					
			If mv_par07 == 3 // So'Adiantamentos
				cQuery += " And E1_TIPO IN " + FORMATIN(MVRECANT,"/")
			End			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Le registros com data anterior a data inicial (para compor   ³
			//³ os saldos anteriores) ate a data final.                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery += " And E1_EMISSAO <= '" + dtos(mv_par02) + "'"																	
			
			If mv_par18 == 1 .And. TcGetDb() $ "MSSQL/MSSQL7/ORACLE"		// Seleciona clientes por conta contabil
				cFilial := xFilial()
				cQuery += " AND E1_CLIENTE IN ("					
				cQuery += "SELECT SA1.A1_COD FROM " + RetSqlName("SA1") + " SA1 "
				cQuery += "WHERE SA1.A1_FILIAL = '" + cFilial + "' And SA1.A1_COD = E1_CLIENTE AND SA1.A1_LOJA = E1_LOJA AND "
				cQuery += "SA1.A1_CONTA BETWEEN '" + mv_par19 + "' AND '" + mv_par20 + "' AND SA1.D_E_L_E_T_ <> '*')"			
			Endif									
			cQuery += " ORDER BY " + cIndE1
			
			cQuery := ChangeQuery(cQuery)
			
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)
			
			For ni := 1 to Len(aStru)
				If aStru[ni,2] != 'C'
					TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next
		else
	#ENDIF
		If mv_par10 = 1
			dbSeek(xFilial()+mv_par04,.T.)
			cCondE1:="xFilial()==SE1->E1_FILIAL .and. SE1->E1_CLIENTE >= mv_par04 .And. SE1->E1_CLIENTE <= mv_par05"
		Else
			cArqTrab :=CriaTrab(NIL,.F.)
			aAdd(aInd,cArqTrab)
			cIndE1   :=IndexKey()
			cIndE1   :=Right(cIndE1,Len(cIndE1)-10)
			IndRegua("SE1",cArqTrab,cIndE1,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
			cCondE1:="SE1->E1_CLIENTE >= mv_par04 .And. SE1->E1_CLIENTE <= mv_par05"
			dbCommit()
			nIndex:=RetIndex("SE1")
			dbSelectArea("SE1")
			#IFNDEF TOP
				dbSetIndex(cArqTrab+OrdBagExt())
			#ENDIF
			dbSetOrder(nIndex+1)
			dbSeek(mv_par04,.T.)
		EndIf
	#IFDEF TOP
		EndIf
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posicionamento do SE5 neste ponto que servira para   ³
	//³pesquisa de descarte de registros geradores de       ³
	//³desdobramento                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE5")
	SE5->(dbSetOrder(7))	//E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
	
	While !SE1->(Eof()) .and. &(cCondE1)		
		If SE1->E1_NATUREZ < mv_par12 .Or. SE1->E1_NATUREZ > mv_par13
			SE1->(dbSkip())
			Loop
		EndIf
		If mv_par18 == 1 .And. !(TcGetDb() $ "MSSQL/MSSQL7/ORACLE")		// Seleciona clientes por conta contabil
			dbSelectArea("SA1")
			MsSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
			If SA1->A1_CONTA < mv_par19 .or. SA1->A1_CONTA > mv_par20
				dbSelectArea("SE1")
				dbSkip()
				Loop
			Endif
		Endif
		dbSelectArea("SE1")

		IF SE1->E1_TIPO $ MVPROVIS
			SE1->(dbSkip())
			Loop
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quais serao impressos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par07 == 2 .and. E1_TIPO $ MVRECANT  // So'Normais
			dbSkip( )
			Loop
		Endif
		
		If mv_par07 == 3 .and. !E1_TIPO $ MVRECANT // So'Adiantamentos
			dbSkip( )
			Loop
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Le registros com data anterior a data inicial (para compor   ³
		//³ os saldos anteriores) ate a data final.                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SE1->E1_EMISSAO > mv_par02
			SE1->(dbSkip( ) )
			Loop
		End

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa de descarte de registros geradores de       ³
		//³desdobramento                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SE5->(dbSeek(xFilial("SE5") + SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)))
			If AllTrim(SE5->E5_TIPODOC) == "BA" .AND. AllTrim(SE5->E5_MOTBX) == "DSD"
				SE1->(dbSkip())
				Loop
			Endif
		Endif		
		
		IF !Inside(SE1->E1_TIPO)
			dbSkip()
			Loop
		EndIf
		
		IF SE1->E1_EMISSAO >= mv_par01 .OR. mv_par15 == 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica prefixo caso a movimenta‡„o n„o seja interpretada   ³
			//³ para calculo do saldo anterior ou quando solicitado.         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SE1->E1_PREFIXO < mv_par08 .Or. SE1->E1_PREFIXO > mv_par09
				SE1->(dbSkip())
				Loop
			Endif
		Endif
		
		If SE1->E1_TIPO $ MVABATIM
			AAdd( aDadosAbat, {SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_EMISSAO,SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA,;
									 SE1->E1_PORTADO,SE1->E1_EMISSAO,SE1->E1_VENCREA,SE1->E1_VLCRUZ,SE1->E1_BAIXA} )
		EndIf			
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava debito no arquivo de trabalho                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("cNomeArq")
		Reclock("cNomeArq",.t.)
		Replace CODIGO  With SE1->E1_CLIENTE
		Replace LOJA    With SE1->E1_LOJA
		Replace DATAEM  With SE1->E1_EMISSAO
		Replace NUMERO  With SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
		Replace TIPO    With SE1->E1_TIPO
		Replace BANCO   With SE1->E1_PORTADO
		Replace EMISSAO With SE1->E1_EMISSAO
		Replace VENCTO  With SE1->E1_VENCREA
		Replace VALOR   With SE1->E1_VLCRUZ
		Replace MOEDA   With SE1->E1_MOEDA
		If cPaisLoc # "BRA"
			If SE1->E1_TIPO $ MV_CRNEG
				cHistor := OemToAnsi(STR0030)  //"NOTA DE CREDITO No. "
			ElseIf SE1->E1_TIPO $ MV_CPNEG
				cHistor := OemToAnsi(STR0031)  //"NOTA DE DEBITO No. "
			ElseIf ALLTRIM(SE1->E1_TIPO) $ "NF|FT"
				cHistor := OemToAnsi(STR0032)  //"FACTURA No. "
			ElseIf SE1->E1_TIPO == "RA "
				cHistor := OemToAnsi(STR0033)  //"ANTICIPO"
			ElseIf SE1->E1_TIPO == "NCI"
				cHistor := OemToAnsi(STR0034)  //"NOTA DE CRED. INTERNA"
			ElseIf SE1->E1_TIPO == "NDI"
				cHistor := OemToAnsi(STR0035)  //"NOTA DE DEB. INTERNA"
			Else
			    cHistor := SE1->E1_HIST	
			EndIf
			Replace HISTOR  With cHistor
		ElseIf SE1->E1_FATURA=="NOTFAT".and. cPaisLoc == "BRA"
			Replace HISTOR  With IIF(Empty(SE1->E1_HIST),OemToAnsi(STR0029),SE1->E1_HIST)  //"Pela Emissao da Fatura"
		Else
			Replace HISTOR  With IIF(Empty(SE1->E1_HIST),OemToAnsi(STR0012),SE1->E1_HIST)  //"Pela Emissao do Titulo"
		Endif
		If SE1->E1_TIPO $ MVRECANT+"/"+MVABATIM+"/"+MV_CRNEG+"/PIS#COF#CSL" //PIS/COF/CSL = PCC Baixa CR
			Replace DC   With "C"
		Else
			Replace DC   With "D"
		Endif    

		If mv_par18 == 2
			If mv_par10 == 1
				Replace CONTA With GetAdvfVal("SA1","A1_CONTA",xFilial("SA1") + SE1->(E1_CLIENTE + E1_LOJA),1)
			Else          
				Replace CONTA With FR550RetCF(SE1->E1_CLIENTE, SE1->E1_LOJA, "A1_CONTA")
			Endif
		Endif
		MsUnlock()
	
		dbSelectArea("SE1")
		dbSkip()
	Enddo
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			DBSelectArea("SE1")
			DbCloseArea()
			ChkFile("SE1")
		Endif
	#ENDIF
Endif

IF mv_par03 == 2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza e grava titulos a pagar dentro dos parametros       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder (6)
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			aStru:= SE2->(dbStruct())
			cCondE2:=".T."
			cQuery := "SELECT * FROM " + RetSqlName("SE2") + " WHERE"
			cIndE2	:=IndexKey()
			If mv_par10 = 1
				cQuery += " E2_FILIAL = '" + xFilial("SE2") + "' AND "
			else
				cQuery += " E2_FILIAL BETWEEN '  ' AND 'ZZ' AND"
				cIndE2 :=Right(cIndE2,Len(cIndE2)-10)
			endif
			cIndE2 := SqlOrder(cIndE2)
			
			dbSelectArea("SE2")
			dbCloseArea()
			dbSelectArea("SA1")
			cQuery += " E2_FORNECE BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'"
			cQuery += " AND E2_EMIS1 <= '" + DTOS(mv_par02)  + "'"
			cQuery += " AND E2_EMIS1 <= '" + DTOS(dDataBase) + "'"
			If mv_par15 == 1
				cQuery += " AND E2_PREFIXO BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
			Endif
			cQuery += " AND E2_TIPO NOT LIKE '"+MVPROVIS+"'"
			cQuery += " AND E2_NATUREZ BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "'"
			If mv_par11 == 1
				cQuery += " AND E2_TIPO IN " + FORMATIN(cTipos,"/")
			Endif
			cQuery += " AND D_E_L_E_T_ <> '*'" 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica quais serao impressos                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
			If mv_par07 == 2 // So'Normais
				cQuery += " And E2_TIPO NOT IN " + FORMATIN(MVPAGANT,"/") 
			Endif                                            
					
			If mv_par07 == 3 // So'Adiantamentos
				cQuery += " And E2_TIPO IN " + FORMATIN(MVPAGANT,"/")
			End			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Le registros com data anterior a data inicial (para compor   ³
			//³ os saldos anteriores) ate a data final.                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery += " And E2_EMIS1 <= '" + dtos(mv_par02) + "'"																	
			
			If mv_par18 == 1 .And. TcGetDb() $ "MSSQL/MSSQL7/ORACLE"		// Seleciona clientes por conta contabil
				cFilial := xFilial()
				cQuery += " AND E2_FORNECE IN ("					
				cQuery += "SELECT SA2.A2_COD FROM " + RetSqlName("SA2") + " SA2 "
				cQuery += "WHERE SA2.A2_FILIAL = '" + cFilial + "' AND SA2.A2_COD = E2_FORNECE AND SA2.A2_LOJA = E2_LOJA AND "
				cQuery += "SA2.A2_CONTA BETWEEN '" + mv_par19 + "' AND '" + mv_par20 + "' AND SA2.D_E_L_E_T_ <> '*')"			
			Endif									
			cQuery += " ORDER BY " + cIndE2			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE2', .F., .T.)
			
			For ni := 1 to Len(aStru)
				If aStru[ni,2] != 'C'
					TCSetField('SE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next
		Else
	#ENDIF
			dbSetOrder (6)
			If mv_par10 = 1
				dbSeek(xFilial()+mv_par04,.T.)
				cCondE2:="SE2->E2_FILIAL==xFilial() .and. SE2->E2_FORNECE >= mv_par04 .And. SE2->E2_FORNECE <= mv_par05"
			Else
				cArqTrab :=CriaTrab(NIL,.F.)
				aAdd(aInd,cArqTrab)
					cIndE2   :=IndexKey()
				cIndE2   :=Right(cIndE2,Len(cIndE2)-10)
				IndRegua("SE2",cArqTrab,cIndE2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
				cCondE2:="SE2->E2_FORNECE >= mv_par04 .And. SE2->E2_FORNECE <= mv_par05"
				dbCommit()
				nIndex:=RetIndex("SE2")
				dbSelectArea("SE2")
				#IFNDEF TOP
					dbSetIndex(cArqTrab+OrdBagExt())
				#ENDIF
				dbSetOrder(nIndex+1)
				dbSeek(mv_par04,.T.)
			EndIf
	#IFDEF TOP
		EndIf
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posicionamento do SE5 neste ponto que servira para   ³
	//³pesquisa de descarte de registros geradores de       ³
	//³desdobramento                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE5")
	SE5->(dbSetOrder(7))	//E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
	
	While !SE2->(Eof()) .AND. &(cCondE2)
		
		If ( SE2->E2_NATUREZ < mv_par12 .Or. SE2->E2_NATUREZ > mv_par13 )
			SE2->(dbSkip())
			Loop
		EndIf
		
		IF SE2->E2_TIPO $ MVPROVIS
			SE2->(dbSkip())
			Loop
		End

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa de descarte de registros geradores de       ³
		//³desdobramento                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SE5->(dbSeek(xFilial("SE5") + SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
			If AllTrim(SE5->E5_TIPODOC) == "BA" .AND. AllTrim(SE5->E5_MOTBX) == "DSD"
				SE2->(dbSkip())
				Loop
			Endif
		Endif		
		
		If mv_par18 == 1 .And. !(TcGetDb() $ "MSSQL/MSSQL7/ORACLE")		// Seleciona fornecedores por conta contabil
			dbSelectArea("SA2")
			MsSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
			If SA2->A2_CONTA < mv_par19 .or. SA2->A2_CONTA > mv_par20
				dbSelectArea("SE2")
				dbSkip()
				Loop
			Endif
		Endif
	    dbSelectArea("SE2")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quais serao impressos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par07 == 2 .and. SE2->E2_TIPO $ MVPAGANT // So'Normais
			dbSkip()
			Loop
		Endif
		
		If mv_par07 == 3 .and. !SE2->E2_TIPO $ MVPAGANT //So'Adiantamentos
			dbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Le registros com data anterior a data inicial (para compor   ³
		//³ os saldos anteriores) ate a data final.                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//Verificar se a data de contabilizacao eh menor que o de emissao, caso seja considerar o de emissao
		If IIf(SE2->E2_EMIS1 < SE2->E2_EMISSAO, SE2->E2_EMISSAO, SE2->E2_EMIS1) > mv_par02
			SE2->(dbSkip())
			Loop
		EndIf
		
		If ! Inside(SE2->E2_TIPO)
			SE2->(dbSkip())
			Loop
		End
		
		//Verificar se a data de contabilizacao eh menor que o de emissao, caso seja considerar o de emissao		
		If IIf(SE2->E2_EMIS1 < SE2->E2_EMISSAO, SE2->E2_EMISSAO, SE2->E2_EMIS1) >= mv_par01 .OR. mv_par15 == 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica prefixo caso a movimenta‡„o n„o seja interpretada   ³
			//³ para calculo do saldo anterior ou quando solicitado.         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SE2->E2_PREFIXO < mv_par08 .Or. SE2->E2_PREFIXO > mv_par09
				SE2->(dbSkip())
				Loop
			EndIf
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava debito no arquivo de trabalho                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Reclock("cNomeArq",.t.)
		Replace CODIGO  	With SE2->E2_FORNECE
		Replace LOJA    	With SE2->E2_LOJA
		Replace DATAEM   	With IIf(SE2->E2_EMIS1 < SE2->E2_EMISSAO, SE2->E2_EMISSAO, SE2->E2_EMIS1)
		Replace NUMERO		With SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
		Replace TIPO    	With SE2->E2_TIPO
		Replace BANCO   	With SE2->E2_PORTADO
		Replace EMISSAO 	With SE2->E2_EMISSAO
		Replace VENCTO  	With SE2->E2_VENCREA
		Replace VALOR   	With SE2->E2_VLCRUZ
		Replace MOEDA   	With SE2->E2_MOEDA
		If cPaisLoc <> "BRA"
			cHistor := ""
			If SE2->E2_TIPO == "NCP"
				cHistor := OemToAnsi(STR0030)  //"NOTA DE CREDITO No. "
			ElseIf SE2->E2_TIPO == "NDP"
				cHistor := OemToAnsi(STR0031)  //"NOTA DE DEBITO No. "
			ElseIf ALLTRIM(SE2->E2_TIPO) $ "NF|FT"
				cHistor := OemToAnsi(STR0032)  //"FACTURA No. "
			ElseIf SE2->E2_TIPO == "NCE"
				cHistor := OemToAnsi(STR0036)  //"NOTA DE CRED. EXTERNA"
			ElseIf SE2->E2_TIPO == "NDE"
				cHistor := OemToAnsi(STR0037)  //"NOTA DE DEB. EXTERNA"
			EndIf
			Replace HISTOR  With IIF(Empty(SE2->E2_HIST),cHistor,SE2->E2_HIST)
		ElseIf SE2->E2_FATURA=="NOTFAT" .and. cPaisLoc == 'BRA'
			Replace HISTOR  With IIF(Empty(SE2->E2_HIST),OemToAnsi(STR0029),SE2->E2_HIST)  //"Pela Emissao da Fatura"
		Else
			Replace HISTOR  With IIF(Empty(SE2->E2_HIST),OemToAnsi(STR0012),SE2->E2_HIST)  //"Pela Emissao do Titulo"
		Endif
		IF SE2->E2_TIPO$ MVPAGANT+"/"+MVABATIM+"/"+MV_CPNEG
			Replace DC     With "D"
		Else
			Replace DC     With "C"     //Abatimentos
		Endif

		If mv_par18 == 2
			If mv_par10 == 1
				Replace CONTA With GetAdvfVal("SA2","A2_CONTA",xFilial("SA2") + SE2->(E2_FORNECE + E2_LOJA),1)
			Else 
				Replace CONTA With FR550RetCF(SE2->E2_FORNECE, SE2->E2_LOJA, "A2_CONTA")
			Endif
		Endif
		MsUnlock()

		//Abatimentos que fizeram parte da fatura
		IF SE2->E2_TIPO $ MVABATIM .AND. !Empty(SE2->E2_FATURA) .AND. ;
				SE2->E2_FATURA != "NOTFAT" .AND. SE2->E2_DTFATUR <= mv_par02

			Reclock("cNomeArq",.t.)
			Replace CODIGO  With SE2->E2_FORNECE
			Replace LOJA    With SE2->E2_LOJA
			Replace DATAEM  With IIf(SE2->E2_EMIS1 < SE2->E2_EMISSAO, SE2->E2_EMISSAO, SE2->E2_EMIS1)
			Replace NUMERO  With SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
			Replace TIPO    With SE2->E2_TIPO
			Replace BANCO   With SE2->E2_PORTADO
			Replace EMISSAO With SE2->E2_EMISSAO
			Replace VENCTO  With SE2->E2_VENCREA
			Replace VALOR   With SE2->E2_VLCRUZ
			Replace BAIXA   With SE2->E2_DTFATUR
			Replace HISTOR  With OemToAnsi(STR0013)+SE2->E2_FATURA  //"BX EMIS FAT "
			Replace DC      With "C"     //Baixa de Abatimento por emissao de fatura

			If mv_par18 == 2
				If mv_par10 == 1
					Replace CONTA With GetAdvfVal("SA2","A2_CONTA",xFilial("SA2") + SE2->(E2_FORNECE + E2_LOJA),1)
				Else 
					Replace CONTA With FR550RetCF(SE2->E2_FORNECE, SE2->E2_LOJA, "A2_CONTA")
				Endif
			Endif
			MsUnlock()
		Endif	
		
		//Gera movimentos de histórico em casos de retenção de pis, cofins e csll
		If lPCCBaixa .And. SE2->E2_TIPO $ MVPAGANT  //Verifico se eh PA para exibir tx's na emissao
			For nX:= 1 To Len(aImp10925)
				If &(aImp10925[nX][1]) > 0
					Reclock("cNomeArq",.T.)
					Replace CODIGO 	With SE2->E2_FORNECE
					Replace LOJA		With SE2->E2_LOJA
					Replace DATAEM		With IIf(SE2->E2_EMIS1 < SE2->E2_EMISSAO, SE2->E2_EMISSAO, SE2->E2_EMIS1)
					Replace NUMERO 	With SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
					Replace EMISSAO	With SE2->E2_EMISSAO
					Replace VALOR		With &(aImp10925[nX][1])
					Replace HISTOR 	With STR0047 + " - " + aImp10925[nX][2]  //Desc.Imposto
					Replace VENCTO		With SE2->E2_VENCREA
					Replace DC	  		With "D"

					If mv_par18 == 2
						If mv_par10 == 1
							Replace CONTA With GetAdvfVal("SA2","A2_CONTA",xFilial("SA2") + SE2->(E2_FORNECE + E2_LOJA),1)
						Else 
							Replace CONTA With FR550RetCF(SE2->E2_FORNECE, SE2->E2_LOJA, "A2_CONTA")
						Endif
					Endif
					MsUnlock()
				Endif
			Next
		Endif
			
		dbSelectArea("SE2")
		dbSkip()
	Enddo
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			DBSelectArea("SE2")
			DbCloseArea()
			ChkFile("SE2")
		Endif
	#ENDIF
Endif

//Ordeno Array de abatimentos de C.Receber
If Len(aDadosAbat) > 0
	aSort(aDadosAbat,,,{|x,y| x[1]+x[2]+x[4] > y[1]+y[2]+y[4]})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza na movimentacao bancaria, os titulos do periodo     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE5")               
ChkFile("SE5",.F.,"NEWSE5")
dbSelectArea("SE5")
dbSetOrder(7)
#IFDEF TOP
	If TcSrvType() != "AS/400"
		// Alterado por Alex Sandro Valario  em desenvolvimento 1Inicio
		aStru := SE5->(dbStruct())
		
		cCondE5:=".T."
		cQuery := "SELECT * FROM " + RetSqlName("SE5") + " WHERE"
		cIndE5	:=IndexKey()
		If mv_par10 = 1
			cQuery += " E5_FILIAL = '" + xFilial("SE5") + "' AND "
		else
			cQuery += " E5_FILIAL BETWEEN '  ' AND 'ZZ' AND"
			cIndE5 :=Right(cIndE5,Len(cIndE5)-10)
		endif
		cIndE5 := SqlOrder(cIndE5)
		
		dbSelectArea("SE5")
		dbCloseArea()
		dbSelectArea("SA1")
		
		cQuery += " E5_DTDIGIT <= '" + DTOS(mv_par02) + "'"
		cQuery += " AND E5_NUMERO <> '" +space(6)+"'"
		cQuery += " AND E5_SITUACA    <> 'C'"
		cQuery += " AND E5_SITUACA    <> 'X'"
		cQuery += " AND E5_DTDIGIT    <= '"+DTOS(dDataBase)+ "'"
		If mv_par15 == 1
			cQuery += " AND E5_PREFIXO BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
		Endif
		cQuery += " AND E5_CLIFOR BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'"
		cQuery += " AND E5_NATUREZ BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "'"
		If mv_par11 == 1
			cQuery += " AND E5_TIPO IN " + FORMATIN(cTipos,"/")
		Endif
		cQuery += " AND E5_TIPODOC IN ('VL','VM','BA','CP','LJ','V2','ES')" 
		cQuery += " AND D_E_L_E_T_ <> '*'"
		If mv_par03 == 1
			cQuery += " AND ((E5_RECPAG = 'R' AND E5_TIPODOC <> 'ES')"
			cQuery += " OR (E5_TIPODOC = 'ES' AND E5_RECPAG = 'P')"
			cQuery += " OR (E5_TIPO IN ('"+MV_CRNEG+"','"+MVRECANT+"')))"
		Endif
		If mv_par03 == 2
			cQuery += " AND ((E5_RECPAG = 'P' AND E5_TIPODOC <> 'ES')"
			cQuery += " OR  (E5_TIPODOC = 'ES' AND E5_RECPAG = 'R')"
			cQuery += " OR (E5_TIPO IN ('"+MV_CPNEG+"','"+MVPAGANT+"')))"
		Endif
		
		// Tratamento para restringir os registros da query do SE5 aos que possuam seus respectivos SE1 ou SE2
		If TcGetDb() $ "MSSQL/MSSQL7/ORACLE"
		
			cQuery += "AND EXISTS ("		
			
			cQuery += " SELECT SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_CLIENTE, SE1.E1_LOJA FROM "+RetSqlName("SE1")+" SE1, "+RetSqlName("SE5")+" SE5 WHERE "
			cQuery += " SE1.E1_FILIAL = SE5.E5_FILIAL AND "
			cQuery += " SE1.E1_PREFIXO = SE5.E5_PREFIXO AND "
			cQuery += " SE1.E1_NUM = SE5.E5_NUMERO AND "
			cQuery += " SE1.E1_PARCELA = SE5.E5_PARCELA AND "
			cQuery += " SE1.E1_TIPO	= SE5.E5_TIPO AND "
			cQuery += " SE1.E1_CLIENTE = SE5.E5_CLIFOR AND "
			cQuery += " SE1.E1_LOJA = SE5.E5_LOJA "
			cQuery += " UNION "
			cQuery += " SELECT SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, SE2.E2_FORNECE, SE2.E2_LOJA FROM "+RetSqlName("SE2")+" SE2, "+RetSqlName("SE5")+" SE5 WHERE "
			cQuery += " SE2.E2_FILIAL = SE5.E5_FILIAL AND "
			cQuery += " SE2.E2_PREFIXO = SE5.E5_PREFIXO AND "
			cQuery += " SE2.E2_NUM = SE5.E5_NUMERO AND "
			cQuery += " SE2.E2_PARCELA = SE5.E5_PARCELA AND "
			cQuery += " SE2.E2_TIPO	= SE5.E5_TIPO AND "
			cQuery += " SE2.E2_FORNECE = SE5.E5_CLIFOR AND "
			cQuery += " SE2.E2_LOJA	= SE5.E5_LOJA"
			
			cQuery += ") "
			
		Endif

		cQuery += " ORDER BY " + cIndE5
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5', .F., .T.)
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
	Else
#ENDIF
	If mv_par10 = 1
		dbSeek(xFilial(),.T.) // Com SoftSeek ON
		cCondE5:="xFilial('SE5') == SE5->E5_FILIAL"
	Else
		cArqTrab :=CriaTrab(NIL,.F.)
		aAdd(aInd,cArqTrab)
		cIndE5   :=IndexKey()
		cIndE5   :=Right(cIndE5,Len(cIndE5)-10)
		IndRegua("SE5",cArqTrab,cIndE5,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
		cCondE5:=".T."
		dbCommit()
		nIndex:=RetIndex("SE5")
		dbSelectArea("SE5")
		#IFNDEF TOP
			dbSetIndex(cArqTrab+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndex+1)
		dbGoTop()
	EndIf
#IFDEF TOP
	EndIf
#ENDIF
If mv_par03 == 1 //Carteira a Receber
	dbSelectArea("SE1")
	dbSetOrder(1)
	cArqTrab :=CriaTrab(NIL,.F.)
	aAdd(aInd,cArqTrab)
	cIndE1   :=IndexKey()
	cIndE1   :=Right(cIndE1,Len(cIndE1)-10)
	IndRegua("SE1",cArqTrab,cIndE1,,,OemToAnsi(STR0011)) //"Selecionando Registros..."
	dbCommit()
	nIndexSE1:=RetIndex("SE1")
	dbSelectArea("SE1")
	#IFNDEF TOP
		dbSetIndex(cArqTrab+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndexSE1+1)
	dbGoTop()
Endif

If mv_par03 == 2 //Carteira a Pagar
	dbSelectArea("SE2")
	dbSetOrder(1)
	cArqTrab :=CriaTrab(NIL,.F.)
	aAdd(aInd,cArqTrab)
	cIndE2   :=IndexKey()
	cIndE2   :=Right(cIndE2,Len(cIndE2)-10)
	IndRegua("SE2",cArqTrab,cIndE2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
	dbCommit()
	nIndexSE2:=RetIndex("SE2")
	dbSelectArea("SE2")
	#IFNDEF TOP
		dbSetIndex(cArqTrab+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndexSE2+1)
	dbGotop()
Endif	

dbSelectArea("SE5")

While !SE5->(Eof()) .and. &(cCondE5)

	#IFNDEF TOP
		
		// Tratamento das consistencias dos registros do SE5 quando o mesmo
		// não for tratado por Query
		
		If !ValidSE5()
			SE5->(dbSkip())
			Loop
		Endif
	
	#ELSE
		If TcSrvType() == "AS/400"
	
			If !ValidSE5()
				SE5->(dbSkip())
				Loop
			Endif
	
		Endif
	#ENDIF
	
	dbSelectArea("SE5")
	
	If SE5->E5_RECPAG == "R" .and. mv_par03 == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quais serao impressos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par07 == 2 .and. E5_TIPO $ MVRECANT   // So'Normais
			dbSkip()
			Loop
		Endif
		
		If mv_par07 == 3 .and. !E5_TIPO $ MVRECANT  // So'Adiantamentos
			dbSkip()
			Loop
		Endif
	ElseIf SE5->E5_RECPAG == "P" .and. mv_par03 == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quais serao impressos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par07 == 2 .and. E5_TIPO $ MVPAGANT  // So'Normais
			dbSkip( )
			Loop
		Endif
		
		If mv_par07 == 3 .and. !E5_TIPO $ MVPAGANT // So'Adiantamentos
			dbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ignora PA's pagos com Junta de Cheque                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If E5_TIPO $ MVPAGANT .and. E5_TIPODOC == "BA" .And. !E5_MOTBX $ "CMP"
			DbSkip()
			Loop
		Endif
	Endif

	IF mv_par03 == 1 .and. SE5->E5_RECPAG != "R"
		If (!(SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG ) .AND. SE5->E5_TIPODOC !="ES") .or. ; //Baixa de RA
			(SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .AND. SE5->E5_TIPODOC =="ES") .or. ; //Estorno da Baixa de PA
			((SE5->E5_TIPO $ MVRECANT) .AND. MV_PAR07 == 2).or. ;
			(!(SE5->E5_TIPO $ MVRECANT) .AND. MV_PAR07 == 3)
			SE5->(dbSkip())
			Loop
		Endif
	EndIF
	IF mv_par03 == 2 .and. SE5->E5_RECPAG != "P"
		If (!( SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG ) .AND. SE5->E5_TIPODOC !="ES") .or.;   //Baixa de PA
			(SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG .AND. SE5->E5_TIPODOC =="ES") .or. ; //Estorno da Baixa de RA
			(( SE5->E5_TIPO $ MVPAGANT) .AND. mv_par07 == 2).or. ;
			(!(SE5->E5_TIPO $ MVPAGANT) .AND. mv_par07 == 3)
			SE5->(dbSkip())
			Loop
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Descartar registros geradores de desdobramento       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
	If AllTrim(SE5->E5_TIPODOC) == "BA" .AND. AllTrim(SE5->E5_MOTBX) == "DSD"
		SE5->(dbSkip())
		Loop
	Endif

	If mv_par03 == 1        // Se for baixa de adiantamentos
		If SE5->E5_RECPAG == "R" .and. E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .AND. SE5->E5_TIPODOC $ "VL/BA/DC/D2/MT/JR/J2/M2/CM/C2/CX"
			dbSkip()
			LOOP
		EndIf
	EndIf
	
	If mv_par03 == 2        // Se for baixa de adiantamentos
		If SE5->E5_RECPAG == "P" .and. E5_TIPO $ MVRECANT+"/"+MV_CRNEG .AND. SE5->E5_TIPODOC $ "VL/BA/DC/D2/MT/JR/J2/M2/CM/C2/CX"
			dbSkip()
			LOOP
		End
	End          

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
	//³ Não considera registro de estorno de compensação de cheques³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
	If SE5->E5_TIPODOC = "ES" .And. SE5->E5_RECPAG = "P"
		aAreaSE5 := SE5->(GetArea())	
		dbSelectArea("NEWSE5")
		dbSetOrder(2)
		If MsSeek(xFilial("SE5")+"CH"+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
			SE5->(dbSkip())
			Loop
		EndIf
		RestArea(aAreaSE5)
	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza o cliente ou fornecedor                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCarteira := SE5->E5_RECPAG
	If SE5->E5_RECPAG == "R"
		If ((SE5->E5_TIPO$MVPAGANT+"/"+MV_CPNEG));
			.OR. ((!SE5->E5_TIPO$MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG) .And. SE5->E5_TIPODOC =="ES")
			cCarteira := "P"        //Baixa de adiantamento (inverte)
		Endif 
	Endif
	
	If SE5->E5_RECPAG == "P"
		If ((SE5->E5_TIPO$MVRECANT+"/"+MV_CRNEG));
			.OR. ((!SE5->E5_TIPO$MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG) .And. SE5->E5_TIPODOC =="ES")
			cCarteira := "R"        //Baixa de adiantamento (inverte)
		Endif 
	Endif
                               
	IF cCarteira == "R"   
		dbSelectArea("SE1")
		If mv_par10 = 1
			dbSetOrder(1)
			dbSeek(xFilial()+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
		Else
			dbSetOrder(nIndexSE1+1)
			dbSeek(SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
		EndIf
		//Caso nÆo ache o registro no SE1, nÆo considero os movimentos
		If !Found()
			dbSelectArea("SE5")
			DbSkip()
			Loop
		Else
			If mv_par18 == 1		// Seleciona clientes por conta contabil
				dbSelectArea("SA1")
				MsSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
				If SA1->A1_CONTA < mv_par19 .or. SA1->A1_CONTA > mv_par20
					dbSelectArea("SE5")
					dbSkip()
					Loop
				Endif
			Endif	
		Endif				
	Else
		dbSelectArea("SE2")
		If mv_par10 = 1
			dbSetOrder(1)
			dbSeek(xFilial()+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)
		Else
			dbSetOrder(nIndexSE2+1)
			dbSeek(SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)
		Endif
		//Caso nÆo ache o registro no SE2, nÆo considero os movimentos
		If !Found()
			dbSelectArea("SE5")
			DbSkip()
			Loop
		Else
			If mv_par18 == 1		// Seleciona fornecedores por conta contabil
				dbSelectArea("SA2")
				MsSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
				If SA2->A2_CONTA < mv_par19 .or. SA2->A2_CONTA > mv_par20
					dbSelectArea("SE5")
					dbSkip()
					Loop
				Endif
			Endif	
		Endif
	Endif		
	dbSelectArea("SE5")
	IF cCarteira == "R"
		dEmissao := SE1->E1_EMISSAO
		dVencto  := SE1->E1_VENCREA
	Else
		dEmissao := SE2->E2_EMISSAO
		dVencto  := SE2->E2_VENCREA                                                              
	Endif  

	aDados[1] := E5_CLIFOR
	aDados[2] := E5_LOJA
	aDados[3] := E5_DTDIGIT
	aDados[4] := E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA
	aDados[5] := E5_BANCO
	aDados[6] := E5_DATA
	aDados[7] := E5_HISTOR
	aDados[8] := E5_RECPAG
	aDados[9] := E5_TIPO
	aDados[10]:= E5_TIPODOC
	aDados[11]:= E5_VALOR

	If lPccBaixa .AND. mv_par03 == 2 //Carteira a Pagar
		aDados[12]:= E5_PRETPIS
		aDados[13]:= E5_PRETCOF
		aDados[14]:= E5_PRETCSL
		
		aDados[15]:= E5_VRETPIS
		aDados[16]:= E5_VRETCOF
		aDados[17]:= E5_VRETCSL
	Endif	

	nValliq := E5_VALOR
	If mv_par06 == 2  //  Nao Imprime valor Financeiro
		nValliq -=	(E5_VLJUROS + E5_VLMULTA + E5_VLCORRE - E5_VLDESCO)
	Endif
	If E5_TIPODOC == "VM" // Correcao Monetaria

		If E5_VALOR > 0
			cTipo  := "C"
		Else
			If E5_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG
				cTipo  := "D"			
			Else
				cTipo  := "C"			
			Endif			
		Endif

		GravaTrab(cTipo,dEmissao,dVencto,nValliq,aDados,aDadosAbat,,.T.)  // Registro principal
	Else
		GravaTrab("B",dEmissao,dVencto,nValliq,aDados,aDadosAbat,.T.)  // Registro principal
	Endif
	If mv_par06 == 1  // Imprime valor financeiro
		For nX := 1 to 4
			DO CASE
				CASE nX == 1		
					cCampo := "E5_VLJUROS"
					cTipo  := "J"
					aDados[7] := STR0050 //"Juros s/ Baixa"
				CASE nX == 2		
					cCampo := "E5_VLMULTA"
					cTipo  := "M"
					aDados[7] := STR0051 //"Multa s/ Baixa"
				CASE nX == 3		
					cCampo := "E5_VLDESCO"
					cTipo  := "D"
					aDados[7] := STR0052 //"Desconto s/ Baixa"
				CASE nX == 4		
					cCampo := "E5_VLCORRE"
					If &(cCampo) > 0
						cTipo  := "C" //IIF(E5_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVRECANT+"/"+MV_CRNEG,"D","C")
					Else
						cTipo  := "D" //IIF(E5_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVRECANT+"/"+MV_CRNEG,"D","C")
					Endif
					aDados[7] := STR0053 //"C.Monetaria s/ Baixa"
			ENDCASE
			If &(cCampo) > 0 .or. (cCampo == "E5_VLCORRE" .and. &(cCampo) != 0)  //Correcao pode ter valor negativo
				GravaTrab(cTipo,dEmissao,dVencto,&(cCampo),aDados,aDadosAbat,,(cCampo == "E5_VLCORRE"))  // Registro principal	
			Endif
		Next				
	Endif
	dbSelectArea("SE5")
	dbSkip()
End
#IFDEF TOP
	If TcSrvType() != "AS/400"
		DBSelectArea("SE5")
		DbCloseArea()
		ChkFile("SE5")
	Endif
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia rotina de impressao                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1:Init()
oSection2:Init()
aFill(aSec1,nil)
aFill(aSec2,nil)

dbSelectArea("cNomeArq")
If mv_par25 == 2 .OR. mv_par18 == 1	//Se usa filtro por conta ou nao aglutina por loja
	IndRegua("cNomeArq",cNomeArq,"CODIGO+LOJA+Dtos(DATAEM)+Numero",,,OemToAnsi(STR0011))  		//"Selecionando Registros..."
Else 
	If  mv_par21 == 1	//saldo contabil
		//Aglutinado por loja. A conta contabil precede a loja, pois a aglutinacao das lojas somente sera permitida caso as contas sejam iguais
		IndRegua("cNomeArq",cNomeArq,"CODIGO+CONTA+LOJA+DtoS(DATAEM)+Numero",,,OemToAnsi(STR0011))
	Else 
		IndRegua("cNomeArq",cNomeArq,"CODIGO+LOJA+Dtos(DATAEM)+Numero",,,OemToAnsi(STR0011))
	Endif
Endif
dbGoTop()
nTotDebG := 0
nTotCrdG := 0
nSalAtuG := 0
While !Eof()
	//Se o parametro de filtro por conta contabil estiver marcado como SIM, a opcao de aglutinar por loja sera desconsiderado
	If mv_par25 == 2 .OR. mv_par18 == 1
		cCodigo	:= CODIGO
		cLoja		:= LOJA
		nSaldoAtu:= 0
		nTotDeb	:= 0
		nTotCrd	:= 0
	
		nRegAtu := Recno()
		lImprime := .F.
	
		While cNomeArq->CODIGO == cCodigo .And. cNomeArq->LOJA == cLoja .And. ! Eof()
			If DATAEM >= mv_par01     // Procura titulos no intervalo e
				lImprime := .T.     // se houver, dever  imprimir
				Exit
			EndIf
			dbSkip()
		EndDo
	
		dbGoto(nRegAtu)
		aSdoContabil := {} // Saldo da conta contabil do fornecedor
		cConta := ""
		While cNomeArq->CODIGO == cCodigo .And. cNomeArq->LOJA == cLoja .And. ! Eof()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Loop para calculo do saldo anterior                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While cNomeArq->CODIGO == cCodigo .And. cNomeArq->LOJA == cLoja .And.;
				cNomeArq->DATAEM < mv_par01 .And. !Eof() .And. (mv_par22 == 1 .or. lImprime)
				If DC == "C"
					nSaldoAtu += ABS(cNomeArq->VALOR)
				Else
					nSaldoAtu -= ABS(cNomeArq->VALOR)
				EndIf
			
				dbSkip()
				If cNomearq->CODIGO != ccodigo .Or. cNomeArq->LOJA != cLoja
					lNoSkip := .T.
				Endif
			Enddo
        	
			If lImprime .Or. nSaldoAtu != 0
				If cAuxFoot = "A TRANSPORTAR"
					
					If nQuebra == 1
						If mv_par03==1
							dbSelectArea("SA1")
							If mv_par10 = 1
								dbSeek(xFilial()+cCodigo+cLoja)
							Else
								If cIndA1 == " "
									cArqTrab :=CriaTrab(NIL,.F.)
									aAdd(aInd,cArqTrab)
									cIndA1   :=IndexKey()
									cIndA1   :=Right(cIndA1,Len(cIndA1)-10)
									IndRegua("SA1",cArqTrab,cIndA1,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
									dbCommit()
									nIndex:=RetIndex("SA1")
									dbSelectArea("SA1")
									#IFNDEF TOP
										dbSetIndex(cArqTrab+OrdBagExt())
									#ENDIF
									dbSetOrder(nIndex+1)
								EndIf
								dbSeek(cCodigo+cLoja)
							EndIf
							If mv_par14 == 1  // Analitico
								cNome := SA1->A1_NOME+" "+SA1->A1_CGC+" "+SA1->A1_CONTA
							Else
								cNome := Substr(SA1->A1_NOME,1,33)+" "+IIF(mv_par18 == 1,SA1->A1_CONTA,SA1->A1_CGC)
							Endif
							cConta := SA1->A1_CONTA
							If mv_par21 ==1 .And. Empty(aSdoContabil) .And. !Empty(SA1->A1_CONTA)
								// Obtem o saldo da conta do fornecedor
								aSdoContabil := SdoContabil(SA1->A1_CONTA,MV_PAR02,"01","1")	
							Endif	
						Else
							dbSelectArea("SA2")
							If mv_par10 = 1
								dbSeek(xFilial()+cCodigo+cLoja)
							Else
								If cIndA2 == " "
									cArqTrab :=CriaTrab(NIL,.F.)
									aAdd(aInd,cArqTrab)
									cIndA2   :=IndexKey()
									cIndA2   :=Right(cIndA2,Len(cIndA2)-10)
									IndRegua("SA2",cArqTrab,cIndA2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
									dbCommit()
									nIndex:=RetIndex("SA2")
									dbSelectArea("SA2")
									#IFNDEF TOP
										dbSetIndex(cArqTrab+ordBagExt())
									#ENDIF
									dbSetOrder(nIndex+1)
								EndIf
								dbSeek(cCodigo+cLoja)
							EndIf
							If mv_par14 == 1  // Analitico
								cNome := SA2->A2_NOME+" "+SA2->A2_CGC+" "+SA2->A2_CONTA
							Else
								cNome := Substr(SA2->A2_NOME,1,33)+" "+IIF(mv_par18 == 1,SA2->A2_CONTA,SA2->A2_CGC)
							Endif
							cConta := SA2->A2_CONTA
							If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(SA2->A2_CONTA)
								// Obtem o saldo da conta do fornecedor
								aSdoContabil := SdoContabil(SA2->A2_CONTA,MV_PAR02,"01","1")	
							Endif	
						EndIf
						
						If cPaisLoc == 'BRA'
							If mv_par14 == 1   // Analitico
								oReport:PrintText(cCodigo + "-" + cLoja + " " + cNome)
								dbSelectArea("cNomeArq")
								aSec1[S1_HISTORICO]	:= STR0028 //"DE TRANSPORTE : "
								aSec1[S1_SALDO_ATU]	:= Abs(nSaldoAtu)
								aSec1[S1_DIGITO]		:= Eval(bBlockDC,nSaldoAtu)
								F550Print(oReport,If(Len(Trim(HISTOR))>20,.T.,.F.))
								aFill(aSec1,nil)
								
							Endif
						Else  //If cPaisLoc == "ARG"
							If mv_par03 == 1
								SA1->( dbSetOrder(1) )
								SA1->( dbSeek(xFilial("SA1")+cCodigo+cLoja) )
							Else
								SA2->( dbSetOrder(1) )
								SA2->( dbSeek(xFilial("SA2")+cCodigo+cLoja) )
							Endif
							
							cTexto := PadR(If(mv_par03==1,Subs(SA1->A1_NOME,1,40),Subs(SA2->A2_NOME,1,40) ),50) + ;
										PadR(cCodigo + "-" + cLoja,42) + ;
										PadR(STR0028,24) + ;  //"TRANSPORTAR : "
										Transform(Abs(nSaldoAtu),tm(Abs(nSaldoAtu),14)) + ;
										" " + Eval(bBlockDC,nSaldoAtu)
							oReport:PrintText(cTexto)
								
							cPosTp := aScan( aTipoCli, {|x| Subs(x,1,1) == If(mv_par03==1,SA1->A1_TIPO,SA2->A2_TIPO)  } )
							cTipoCli := If( cPosTp>0 , aTipoCli[cPosTp] , "" )
							
							SX5->( dbSetOrder(1) )
							SX5->( dbSeek(xFilial("SX5")+"12"+If(mv_par03==1,SA1->A1_EST,SA2->A2_EST)) )
							
							If mv_par03 == 1 //Carteira (Receber ou Pagar)
								cTexto :=	PadR(SA1->A1_END,50) + ;
												PadR("Te: "+Subs(Alltrim(SA1->A1_TEL),1,36),42) + ;
												PadR(STR0038+SA1->A1_VEND,50) //"VENDEDOR: "
								oReport:PrintText(cTexto)
								
								cTexto := PadR(SA1->A1_CEP + " - " + SA1->A1_MUN,92) 
								If SX5->( Found() ) .or. !Empty(X5Descri())
									cTexto += AllTrim(X5Descri())
								EndIf
								oReport:PrintText(cTexto)
								
								cTexto :=	PadR(cTipoCli,50) + ;
												Trans(SA1->A1_CGC,PesqPict("SA1","A1_CGC"))
								oReport:PrintText(cTexto)
							Else
								cTexto :=	PadR(SA2->A2_END,50) + ;
												PadR("Te: "+ Subs(Alltrim(SA2->A2_TEL),1,36),42) + ;
												STR0039  //"COMPRADOR: "
								oReport:PrintText(cTexto)
								
								cTexto := PadR(SA2->A2_CEP+" - " +SA2->A2_MUN,42) 
								If SX5->( Found() ) .or. !Empty(X5Descri())
									cTexto += AllTrim(X5Descri())
								Endif
								oReport:PrintText(cTexto)
								
								cTexto :=	PadR(cTipoCli,50) + ;
												Trans(SA2->A2_CGC,PesqPict("SA2","A2_CGC"))
							EndIf
						EndIf
					EndIf
					cAuxFoot = "X"
				Endif
			EndIf
			
			If nQuebra == 0 .and. (lImprime .Or. nSaldoAtu != 0 )
				nQuebra  := 1
				lImprAnt := .F.
				IF mv_par03 == 1
					dbSelectArea("SA1")
					If mv_par10 = 1
						dbSeek(xFilial()+cCodigo+cLoja)
					Else
						If cIndA1 == " "
							cArqTrab :=CriaTrab(NIL,.F.)
							aAdd(aInd,cArqTrab)
							cIndA1   :=IndexKey()
							cIndA1   :=Right(cIndA1,Len(cIndA1)-10)
							IndRegua("SA1",cArqTrab,cIndA1,,,STR0011 )  //"Selecionando Registros..."
							dbCommit()
							nIndex:=RetIndex("SA1")
							dbSelectArea("SA1")
							#IFNDEF TOP
								dbSetIndex(cArqTrab+OrdBagEXt())
							#ENDIF
							dbSetOrder(nIndex+1)
						EndIf
						dbSeek(cCodigo+cLoja)
					EndIf
					If mv_par14 == 1  // Analitico
						cNome := SA1->A1_NOME+" "+SA1->A1_CGC+" "+SA1->A1_CONTA
					Else	
						cNome := Substr(SA1->A1_NOME,1,33)+" "+IIF(mv_par18 == 1,SA1->A1_CONTA,SA1->A1_CGC)
					Endif
					cConta := SA1->A1_CONTA
					If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(SA1->A1_CONTA)
						// Obtem o saldo da conta do fornecedor
						aSdoContabil := SdoContabil(SA1->A1_CONTA,MV_PAR02,"01","1")	
					Endif	
				Else
					dbSelectArea("SA2")
					If mv_par10 = 1
						dbSeek(xFilial()+cCodigo+cLoja)
					Else
						If cIndA2 == " "
							cArqTrab :=CriaTrab(NIL,.F.)
							aAdd(aInd,cArqTrab)
							cIndA2   :=IndexKey()
							cIndA2   :=Right(cIndA2,Len(cIndA2)-10)
							IndRegua("SA2",cArqTrab,cIndA2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
							dbCommit()
							nIndex:=RetIndex("SA2")
							dbSelectArea("SA2")
							#IFNDEF TOP
								dbSetIndex(cArqTrab+OrdBagExt())
							#ENDIF
							dbSetOrder(nIndex+1)
						EndIf
						dbSeek(cCodigo+cLoja)
					EndIf
					If mv_par14 == 1  // Analitico
						cNome := SA2->A2_NOME+" "+SA2->A2_CGC+" "+SA2->A2_CONTA
					Else
						cNome := Substr(SA2->A2_NOME,1,33)+" "+IIF(mv_par18 == 1,SA2->A2_CONTA,SA2->A2_CGC)
					Endif
					cConta := SA2->A2_CONTA
					If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(SA2->A2_CONTA)
						// Obtem o saldo da conta do fornecedor
						aSdoContabil := SdoContabil(SA2->A2_CONTA,MV_PAR02,"01","1")	
					Endif	
				EndIF
				
				If cPaisLoc == "BRA"
					If mv_par14 == 1  // Analitico
						oReport:PrintText(cCodigo + "-" + cLoja + " " + cNome)
						dbSelectArea("cNomeArq")
						aSec1[S1_HISTORICO] := STR0016  //"SALDO ANTERIOR : "
						aSec1[S1_SALDO_ATU] := Abs(nSaldoAtu)
						aSec1[S1_DIGITO]:= Eval(bBlockDC,nSaldoAtu)
						F550Print(oReport,If(Len(Trim(HISTOR))>20,.T.,.F.))
						aFill(aSec1,nil)
						oReport:SkipLine()
						
						nSalAntG += nSaldoAtu
					Else
						aSec2[S2_DESCRICAO] := Substr(cCodigo + "-" + cLoja + " " + cNome,1,64)
						aSec2[S2_SD_ANTERIOR] := Abs(nSaldoAtu)
						aSec2[S2_DIG1] := Eval(bBlockDC,nSaldoAtu)
						nSalAntG += nSaldoAtu
					Endif	
				Else  //If cPaisLoc == "ARG" // MariSol Argentina Jose Lucas 17/04/99
					
					If mv_par03 == 1 // Carteira (Receber ou Pagar)
						SA1->( dbSetOrder(1) )
						SA1->( dbSeek(xFilial("SA1")+cCodigo+cLoja) )
					Else
						SA2->( dbSetOrder(1) )
						SA2->( dbSeek(xFilial("SA2")+cCodigo+cLoja) )
					Endif
					
					cTexto :=	PadR( If(mv_par03==1,Subs(SA1->A1_NOME,1,40),Subs(SA2->A2_NOME,1,40) ),50) + ;
									PadR( cCodigo + "-" + cLoja,42) + ;
									PadR( STR0016,24 ) + ;  //"SALDO ANTERIOR : "
									PadR( Transform(Abs(nSaldoAtu),tm(Abs(nSaldoAtu),14) ),15 ) + ;
									" " + Eval(bBlockDC,nSaldoAtu)
					oReport:PrintText(cTexto)
					oReport:SkipLine()
					
					nSalAntG += nSaldoAtu
                	
					cPosTp := aScan( aTipoCli, {|x| Subs(x,1,1) == Iif(mv_par03==1,SA1->A1_TIPO,SA2->A2_TIPO)  } )
					cTipoCli := Iif( cPosTp>0 , aTipoCli[cPosTp] , "" )
					
					SX5->( dbSetOrder(1) )
					SX5->( dbSeek(xFilial("SX5")+"12"+If(mv_par03==1,SA1->A1_EST,SA2->A2_EST)) )
					
					If mv_par03 == 1 // Carteira (Receber ou Pagar)
						cTexto :=	PadR(SA1->A1_END,50) + ;
										PadR("Te: "+Subs(Alltrim(SA1->A1_TEL),1,36),42) + ;
										STR0038+SA1->A1_VEND  // "VENDEDOR : "
						oReport:PrintText(cTexto)
	
						cTexto :=	PadR(SA1->A1_CEP+" - " +SA1->A1_MUN,92)
						If SX5->( Found() ) .or. !Empty(X5Descri())
							cTexto += AllTrim(X5Descri())   // Diego
						EndIf
						oReport:PrintText(cTexto)
						
						cTexto :=	PadR(cTipoCli,50) + Trans(SA1->A1_CGC,PesqPict("SA1","A1_CGC"))
						oReport:PrintText(cTexto)
						oReport:SkipLine()
					Else
						cTexto :=	PadR(SA2->A2_END,50) + ;
										PadR("Te: "+Subs(Alltrim(SA2->A2_TEL),1,36),42) + ;
										STR0039 // "COMPRADOR: "
						oReport:PrintText(cTexto)
						
						cTexto := PadR(SA2->A2_CEP+" - " +SA2->A2_MUN,92)
						If SX5->( Found() ) .or. !Empty(X5Descri())
							cTexto += AllTrim(X5Descri())
						EndIf
						oReport:PrintText(cTexto)
						
						cTexto :=	PadR(cTipoCli,50) + ;
										Trans(SA2->A2_CGC,PesqPict("SA2","A2_CGC"))
						oReport:PrintText(cTexto)
						oReport:SkipLine()
					EndIf
				EndIf
			EndIf
		
			dbSelectArea("cNomeArq")
			
			If cNomeArq->DATAEM >= mv_par01 .And. !lNoSkip
				If DC == "D"
					nSaldoAtu -= ABS(cNomeArq->VALOR)
					nTotDeb   += ABS(cNomeArq->VALOR)
					nTotDebG  += ABS(cNomeArq->VALOR)
					nSalAtuG  -= ABS(cNomeArq->VALOR)
				Else
					nSaldoAtu += ABS(cNomeArq->VALOR)
					nTotCrd   += ABS(cNomeArq->VALOR)
					nTotCrdG  += ABS(cNomeArq->VALOR)
					nSalAtuG  += ABS(cNomeArq->VALOR)
				End
				If mv_par14 == 1  // Analitico
					//li++
            	
					aSec1[S1_DAT] := DATAEM
					If OemToAnsi(STR0040)$ HISTOR  //"Recibo"/"Receipt"
						aSec1[S1_HISTORICO] := If(mv_par24=1,Substr(HISTOR, At(OemToAnsi(STR0040),HISTOR),20),HISTOR)
					Else
						aSec1[S1_HISTORICO] := If(mv_par24=1,SubStr(HISTOR,1,20),HISTOR)
					EndIf
					aSec1[S1_TITULO] := SubStr(NUMERO, 1,3) + " " + SubStr(NUMERO, 4,nTamNro) + " " + SubStr(NUMERO,nTamNro+4,nTamParc)
					aSec1[S1_EMISSAO] := EMISSAO
					aSec1[S1_VENCIMENTO] := VENCTO
					IF !Empty(BAIXA)
						aSec1[S1_BAIXA] := BAIXA
					End
					If DC=="D"
						aSec1[S1_DEBITO] := ABS(cNomeArq->VALOR)
					Else
						aSec1[S1_CREDITO] := ABS(cNomeArq->VALOR)
					EndIf
					aSec1[S1_SALDO_ATU] := Abs(nSaldoAtu)
					aSec1[S1_DIGITO] := Eval(bBlockDC,nSaldoAtu)
					F550Print(oReport,If(Len(Trim(HISTOR))>20,.T.,.F.))
					aFill(aSec1,nil)
				Endif
			End
			lFlag := .T.
			If ! lNoSkip
				dbSkip( )
			End
			lNoSkip := .F.
		End

	Else		//Aglutinar todas lojas de fornecedor / cliente
		
		cCodigo		:= cNomeArq->CODIGO
		cLoja		:= ""
		nSaldoAtu	:= 0
		nTotDeb		:= 0
		nTotCrd		:= 0
		nRegAtu 	:= cNomeArq->(Recno())
		lImprime 	:= .F.
		While !cNomeArq->(Eof()) .AND. cNomeArq->CODIGO == cCodigo 
			If DATAEM >= mv_par01     // Procura titulos no intervalo e
				lImprime := .T.     // se houver, dever  imprimir
				Exit
			EndIf
			dbSkip()
		EndDo
		dbGoto(nRegAtu)
		aSdoContabil := {} // Saldo da conta contabil do fornecedor
		cCtContAnt := cNomeArq->CONTA
		While !cNomeArq->(Eof()) .AND. cNomeArq->CODIGO == cCodigo
			If mv_par21 == 1 .AND. (mv_par22 == 1 .OR. lImprime)
				//Pesquisar se o cliente / fornecedor esta utilizando um conta diferente entre as lojas
				If FR550RetCF(cCodigo, cNomeArq->LOJA, IIf(mv_par03 == 1,"A1_CONTA","A2_CONTA")) # cCtContAnt
					//Sair
					Exit
				Endif
			Endif
			cCtContAnt := cNomeArq->CONTA
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Loop para calculo do saldo anterior                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While !cNomeArq->(Eof()) .AND. cNomeArq->CODIGO == cCodigo .AND. ;
				cNomeArq->DATAEM < mv_par01 .AND. (mv_par22 == 1 .OR. lImprime)
				If DC == "C"
					nSaldoAtu += ABS(cNomeArq->VALOR)
				Else
					nSaldoAtu -= ABS(cNomeArq->VALOR)
				EndIf
				cCtContAnt := cNomeArq->CONTA
				cNomeArq->(dbSkip())
				If cNomearq->CODIGO != cCodigo
					lNoSkip := .T.
				Else
					If mv_par21 == 1
						//Pesquisar se o cliente / fornecedor esta utilizando um conta diferente entre as lojas
						If FR550RetCF(cCodigo, cNomeArq->LOJA, IIf(mv_par03 == 1,"A1_CONTA","A2_CONTA")) # cCtContAnt
							lNoSkip := .T.
						Endif
					Endif
				Endif
			Enddo
        	
			If lImprime .Or. nSaldoAtu != 0
				If cAuxFoot = "A TRANSPORTAR"
					If nQuebra == 1
						If mv_par03==1
							dbSelectArea("SA1")   
							If cIndA1 == " " .OR. cIndA1 # SA1->(IndexKey())
								If cIndA1 == " "
									cArqTrab := CriaTrab(Nil,.F.)
									aAdd(aInd,cArqTrab)
								Endif
								cIndA1   :=IndexKey()
								If mv_par21 == 1
									cIndA1   :=Right(cIndA1,Len(cIndA1)-IIf(mv_par10 == 1,0,IIf(At("FILIAL",cIndA1)==0,0,10)))+"+A1_CONTA"  //Indice de pesquisa sem filial
								Else
									cIndA1   :=Right(cIndA1,Len(cIndA1)-IIf(mv_par10==1,0,IIf(At("FILIAL",cIndA1)==0,0,10)))	//Indice de pesquisa sem filial
								Endif
								IndRegua("SA1",cArqTrab,cIndA1,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
								dbCommit()
								nIndex:=RetIndex("SA1")
								dbSelectArea("SA1")
								#IFNDEF TOP
									dbSetIndex(cArqTrab+OrdBagExt())
								#ENDIF
								dbSetOrder(nIndex + 1)
							EndIf
							If mv_par21 == 1
								SA1->(dbSeek(IIf(mv_par10==1,xFilial("SA1"),"")+cCodigo + cNomeArq->LOJA + cCtContAnt))
							Else
								SA1->(dbSeek(IIf(mv_par10==1,xFilial("SA1"),"")+cCodigo))
							Endif
							If mv_par21 == 1
								If mv_par14 == 1  // Analitico
									cNome := SA1->A1_NOME+" "+SA1->A1_CGC+" "+cCtContAnt
								Else
									cNome := Substr(SA1->A1_NOME,1,33)+" "+IIF(mv_par18 == 1,cCtContAnt,SA1->A1_CGC)
								Endif
							Else 
								If mv_par14 == 1  // Analitico
									cNome := SA1->A1_NOME+" "+SA1->A1_CGC
								Else
									cNome := Substr(SA1->A1_NOME,1,33)+" "+SA1->A1_CGC
								Endif							
							Endif
							cConta := SA1->A1_CONTA
							If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(cCtContAnt)
								// Obtem o saldo da conta do fornecedor
								aSdoContabil := SdoContabil(cCtContAnt,MV_PAR02,"01","1")	
							Endif	
						Else
							dbSelectArea("SA2")
							If cIndA2 == " " .OR. cIndA2 # SA2->(IndexKey())
								If cIndA2 == " "
									cArqTrab :=CriaTrab(NIL,.F.)
									aAdd(aInd,cArqTrab)
								Endif
								cIndA2 := IndexKey()
								If mv_par21 == 1
									cIndA2 := Right(cIndA2,Len(cIndA2)-IIf(mv_par10==1,0,IIf(At("FILIAL",cIndA2)==0,0,10))) + "+A2_CONTA"
								Else
									cIndA2 := Right(cIndA2,Len(cIndA2)-IIf(mv_par10==1,0,IIf(At("FILIAL",cIndA2)==0,0,10)))
								Endif
								IndRegua("SA2",cArqTrab,cIndA2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
								dbCommit()
								nIndex:=RetIndex("SA2")
								dbSelectArea("SA2")
								#IFNDEF TOP
									dbSetIndex(cArqTrab+ordBagExt())
								#ENDIF
								dbSetOrder(nIndex + 1)
							EndIf                       
							If mv_par21 == 1
								dbSeek(IIf(mv_par10==1,xFilial("SA2"),"")+cCodigo + cNomeArq->LOJA + cCtContAnt)
							Else
								dbSeek(IIf(mv_par10==1,xFilial("SA2"),"")+cCodigo)
							Endif
							If mv_par21 == 1
								If mv_par14 == 1  // Analitico
									cNome := SA2->A2_NOME+" "+SA2->A2_CGC+" "+cCtContAnt
								Else
									cNome := Substr(SA2->A2_NOME,1,33)+" "+IIF(mv_par18 == 1,cCtContAnt,SA2->A2_CGC)
								Endif
							Else 
								If mv_par14 == 1  // Analitico
									cNome := SA2->A2_NOME+" "+SA2->A2_CGC
								Else
									cNome := Substr(SA2->A2_NOME,1,33)+" "+SA2->A2_CGC
								Endif
							Endif
							cConta := SA2->A2_CONTA
							If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(cCtContAnt)
								// Obtem o saldo da conta do fornecedor
								aSdoContabil := SdoContabil(cCtContAnt,MV_PAR02,"01","1")	
							Endif	
						EndIf
						
						If cPaisLoc == 'BRA'
							If mv_par14 == 1   // Analitico
								oReport:PrintText(cCodigo + "-" + cNome)
								dbSelectArea("cNomeArq")
								aSec1[S1_HISTORICO]	:= STR0028 //"DE TRANSPORTE : "
								aSec1[S1_SALDO_ATU]	:= Abs(nSaldoAtu)
								aSec1[S1_DIGITO]	:= Eval(bBlockDC,nSaldoAtu)
								F550Print(oReport,If(Len(Trim(HISTOR)) > 20,.T.,.F.))
								aFill(aSec1,nil)
							Endif
						Else  //If cPaisLoc == "ARG"
							If mv_par03 == 1
								SA1->(dbSetOrder(1))
								SA1->(dbSeek(xFilial("SA1")+cCodigo+cNomeArq->LOJA))
							Else
								SA2->(dbSetOrder(1))
								SA2->(dbSeek(xFilial("SA2")+cCodigo+cNomeArq->LOJA))
							Endif
							cTexto := PadR(If(mv_par03==1,Subs(SA1->A1_NOME,1,40),Subs(SA2->A2_NOME,1,40) ),50) + ;
										PadR(cCodigo,42) + ;
										PadR(STR0028,24) + ;  //"TRANSPORTAR : "
										Transform(Abs(nSaldoAtu),tm(Abs(nSaldoAtu),14)) + ;
										" " + Eval(bBlockDC,nSaldoAtu)
							oReport:PrintText(cTexto)
								
							cPosTp := aScan(aTipoCli, {|x| Subs(x,1,1) == If(mv_par03==1,SA1->A1_TIPO,SA2->A2_TIPO)})
							cTipoCli := If(cPosTp>0 , aTipoCli[cPosTp] , "")
							
							SX5->( dbSetOrder(1) )
							SX5->( dbSeek(xFilial("SX5")+"12"+If(mv_par03==1,SA1->A1_EST,SA2->A2_EST)) )
							
							If mv_par03 == 1 //Carteira (Receber ou Pagar)
								cTexto :=	PadR(SA1->A1_END,50) + ;
												PadR("Te: "+Subs(Alltrim(SA1->A1_TEL),1,36),42) + ;
												PadR(STR0038+SA1->A1_VEND,50) //"VENDEDOR: "
								oReport:PrintText(cTexto)
								
								cTexto := PadR(SA1->A1_CEP + " - " + SA1->A1_MUN,92) 
								If SX5->( Found() ) .or. !Empty(X5Descri())
									cTexto += AllTrim(X5Descri())
								EndIf
								oReport:PrintText(cTexto)
								
								cTexto :=	PadR(cTipoCli,50) + ;
												Trans(SA1->A1_CGC,PesqPict("SA1","A1_CGC"))
								oReport:PrintText(cTexto)
							Else
								cTexto :=	PadR(SA2->A2_END,50) + ;
												PadR("Te: "+ Subs(Alltrim(SA2->A2_TEL),1,36),42) + ;
												STR0039  //"COMPRADOR: "
								oReport:PrintText(cTexto)
								
								cTexto := PadR(SA2->A2_CEP+" - " +SA2->A2_MUN,42) 
								If SX5->( Found() ) .or. !Empty(X5Descri())
									cTexto += AllTrim(X5Descri())
								Endif
								oReport:PrintText(cTexto)
								
								cTexto :=	PadR(cTipoCli,50) + ;
												Trans(SA2->A2_CGC,PesqPict("SA2","A2_CGC"))
							EndIf
						EndIf
					EndIf
					cAuxFoot = "X"
				Endif
			EndIf
			
			If nQuebra == 0 .and. (lImprime .Or. nSaldoAtu != 0 )
				nQuebra  := 1
				lImprAnt := .F.
				IF mv_par03 == 1
					dbSelectArea("SA1")
					If cIndA1 == " " .OR. cIndA1 # SA1->(IndexKey())
						If cIndA1 == " "
							cArqTrab :=CriaTrab(NIL,.F.)
							aAdd(aInd,cArqTrab)
						Endif
						cIndA1 := IndexKey()
						If mv_par21 == 1
							cIndA1 := Right(cIndA1,Len(cIndA1)-IIf(mv_par10==1,0,IIf(At("FILIAL",cIndA1)==0,0,10))) + "+A1_CONTA"
						Else
							cIndA1 := Right(cIndA1,Len(cIndA1)-IIf(mv_par10==1,0,IIf(At("FILIAL",cIndA1)==0,0,10)))						
						Endif
						IndRegua("SA1",cArqTrab,cIndA1,,,STR0011 )  //"Selecionando Registros..."
						dbCommit()
						nIndex:=RetIndex("SA1")
						dbSelectArea("SA1")
						#IFNDEF TOP
							dbSetIndex(cArqTrab+OrdBagEXt())
						#ENDIF
						dbSetOrder(nIndex+1)
					EndIf
					If mv_par21 == 1
						dbSeek(IIf(mv_par10==1,xFilial("SA1"),"")+cCodigo + cNomeArq->LOJA + cCtContAnt)
					Else
						dbSeek(IIf(mv_par10==1,xFilial("SA1"),"")+cCodigo)
					Endif
					If mv_par21 == 1
						If mv_par14 == 1  // Analitico
							cNome := SA1->A1_NOME+" "+SA1->A1_CGC+" "+cCtContAnt
						Else	
							cNome := Substr(SA1->A1_NOME,1,33)+" "+IIF(mv_par18 == 1,cCtContAnt,SA1->A1_CGC)
						Endif
					Else
						If mv_par14 == 1  // Analitico
							cNome := SA1->A1_NOME+" "+SA1->A1_CGC
						Else	
							cNome := Substr(SA1->A1_NOME,1,33)+" "+SA1->A1_CGC
						Endif
					Endif
					cConta := SA1->A1_CONTA
					If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(cCtContAnt)
						// Obtem o saldo da conta do fornecedor
						aSdoContabil := SdoContabil(cCtContAnt,MV_PAR02,"01","1")	
					Endif	
				Else
					dbSelectArea("SA2")
					If cIndA2 == " " .OR. cIndA2 # SA2->(IndexKey())
						If cIndA2 == " "
							cArqTrab :=CriaTrab(NIL,.F.)
							aAdd(aInd,cArqTrab)
						Endif
						cIndA2   :=IndexKey()
						If mv_par21 == 1
							cIndA2 := Right(cIndA2,Len(cIndA2)-IIf(mv_par10==1,0,IIf(At("FILIAL",cIndA2)==0,0,10))) + "+A2_CONTA"
						Else
							cIndA2 := Right(cIndA2,Len(cIndA2)-IIf(mv_par10==1,0,IIf(At("FILIAL",cIndA2)==0,0,10)))
						Endif
						IndRegua("SA2",cArqTrab,cIndA2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
						dbCommit()
						nIndex:=RetIndex("SA2")
						dbSelectArea("SA2")
						#IFNDEF TOP
							dbSetIndex(cArqTrab+OrdBagExt())
						#ENDIF
						dbSetOrder(nIndex+1)
					EndIf
					If mv_par21 == 1
						dbSeek(IIf(mv_par10==1,xFilial("SA2"),"")+cCodigo + cNomeArq->LOJA + cCtContAnt)
					Else
						dbSeek(IIf(mv_par10==1,xFilial("SA2"),"")+cCodigo)
					Endif
					If mv_par21 == 1
						If mv_par14 == 1  // Analitico
							cNome := SA2->A2_NOME+" "+SA2->A2_CGC+" "+cCtContAnt
						Else
							cNome := Substr(SA2->A2_NOME,1,33)+" "+IIF(mv_par18 == 1,cCtContAnt,SA2->A2_CGC)
						Endif
					Else 
						If mv_par14 == 1  // Analitico
							cNome := SA2->A2_NOME+" "+SA2->A2_CGC
						Else
							cNome := Substr(SA2->A2_NOME,1,33)+" "+SA2->A2_CGC
						Endif
					Endif
					cConta := SA2->A2_CONTA
					If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(cCtContAnt)
						// Obtem o saldo da conta do fornecedor
						aSdoContabil := SdoContabil(cCtContAnt,MV_PAR02,"01","1")	
					Endif	
				EndIF
				
				If cPaisLoc == "BRA"
					If mv_par14 == 1  // Analitico
						oReport:PrintText(cCodigo + "-" + cNome)
						dbSelectArea("cNomeArq")
						aSec1[S1_HISTORICO] := STR0016  //"SALDO ANTERIOR : "
						aSec1[S1_SALDO_ATU] := Abs(nSaldoAtu)
						aSec1[S1_DIGITO]:= Eval(bBlockDC,nSaldoAtu)
						F550Print(oReport,If(Len(Trim(HISTOR))>20,.T.,.F.))
						aFill(aSec1,nil)
						oReport:SkipLine()
						
						nSalAntG += nSaldoAtu
					Else
						aSec2[S2_DESCRICAO] := Substr(cCodigo + "-" + cNome,1,64)
						aSec2[S2_SD_ANTERIOR] := Abs(nSaldoAtu)
						aSec2[S2_DIG1] := Eval(bBlockDC,nSaldoAtu)
						nSalAntG += nSaldoAtu
					Endif	
				Else  //If cPaisLoc == "ARG" // MariSol Argentina Jose Lucas 17/04/99
					
					If mv_par03 == 1 // Carteira (Receber ou Pagar)
						SA1->( dbSetOrder(1) )
						SA1->( dbSeek(xFilial("SA1")+cCodigo+cNomeArq->LOJA) )
					Else
						SA2->( dbSetOrder(1) )
						SA2->( dbSeek(xFilial("SA2")+cCodigo+cNomeArq->LOJA) )
					Endif
					
					cTexto :=	PadR( If(mv_par03==1,Subs(SA1->A1_NOME,1,40),Subs(SA2->A2_NOME,1,40) ),50) + ;
									PadR( cCodigo,42) + ;
									PadR( STR0016,24 ) + ;  //"SALDO ANTERIOR : "
									PadR( Transform(Abs(nSaldoAtu),tm(Abs(nSaldoAtu),14) ),15 ) + ;
									" " + Eval(bBlockDC,nSaldoAtu)
					oReport:PrintText(cTexto)
					oReport:SkipLine()
					
					nSalAntG += nSaldoAtu
                	
					cPosTp := aScan( aTipoCli, {|x| Subs(x,1,1) == Iif(mv_par03==1,SA1->A1_TIPO,SA2->A2_TIPO)  } )
					cTipoCli := Iif( cPosTp>0 , aTipoCli[cPosTp] , "" )
					
					SX5->( dbSetOrder(1) )
					SX5->( dbSeek(xFilial("SX5")+"12"+If(mv_par03==1,SA1->A1_EST,SA2->A2_EST)) )
					
					If mv_par03 == 1 // Carteira (Receber ou Pagar)
						cTexto :=	PadR(SA1->A1_END,50) + ;
										PadR("Te: "+Subs(Alltrim(SA1->A1_TEL),1,36),42) + ;
										STR0038+SA1->A1_VEND  // "VENDEDOR : "
						oReport:PrintText(cTexto)
	
						cTexto :=	PadR(SA1->A1_CEP+" - " +SA1->A1_MUN,92)
						If SX5->( Found() ) .or. !Empty(X5Descri())
							cTexto += AllTrim(X5Descri())   // Diego
						EndIf
						oReport:PrintText(cTexto)
						
						cTexto :=	PadR(cTipoCli,50) + Trans(SA1->A1_CGC,PesqPict("SA1","A1_CGC"))
						oReport:PrintText(cTexto)
						oReport:SkipLine()
					Else
						cTexto :=	PadR(SA2->A2_END,50) + ;
										PadR("Te: "+Subs(Alltrim(SA2->A2_TEL),1,36),42) + ;
										STR0039 // "COMPRADOR: "
						oReport:PrintText(cTexto)
						
						cTexto := PadR(SA2->A2_CEP+" - " +SA2->A2_MUN,92)
						If SX5->( Found() ) .or. !Empty(X5Descri())
							cTexto += AllTrim(X5Descri())
						EndIf
						oReport:PrintText(cTexto)
						
						cTexto :=	PadR(cTipoCli,50) + ;
										Trans(SA2->A2_CGC,PesqPict("SA2","A2_CGC"))
						oReport:PrintText(cTexto)
						oReport:SkipLine()
					EndIf
				EndIf
			EndIf
		
			dbSelectArea("cNomeArq")
			
			If cNomeArq->DATAEM >= mv_par01 .And. !lNoSkip 
				If DC == "D"
					nSaldoAtu -= ABS(cNomeArq->VALOR)
					nTotDeb   += ABS(cNomeArq->VALOR)
					nTotDebG  += ABS(cNomeArq->VALOR)
					nSalAtuG  -= ABS(cNomeArq->VALOR)
				Else
					nSaldoAtu += ABS(cNomeArq->VALOR)
					nTotCrd   += ABS(cNomeArq->VALOR)
					nTotCrdG  += ABS(cNomeArq->VALOR)
					nSalAtuG  += ABS(cNomeArq->VALOR)
				End
				If mv_par14 == 1  // Analitico
					//li++
            	
					aSec1[S1_DAT] := DATAEM
					If OemToAnsi(STR0040)$ HISTOR  //"Recibo"/"Receipt"
						aSec1[S1_HISTORICO] := If(mv_par24=1,Substr(HISTOR, At(OemToAnsi(STR0040),HISTOR),20),HISTOR)
					Else
						aSec1[S1_HISTORICO] := If(mv_par24=1,SubStr(HISTOR,1,20),HISTOR)
					EndIf
					aSec1[S1_TITULO] := SubStr(NUMERO, 1,3) + " " + SubStr(NUMERO, 4,nTamNro) + " " + SubStr(NUMERO,nTamNro+4,nTamParc)
					aSec1[S1_EMISSAO] := EMISSAO
					aSec1[S1_VENCIMENTO] := VENCTO
					IF !Empty(BAIXA)
						aSec1[S1_BAIXA] := BAIXA
					End
					If DC=="D"
						aSec1[S1_DEBITO] := ABS(cNomeArq->VALOR)
					Else
						aSec1[S1_CREDITO] := ABS(cNomeArq->VALOR)
					EndIf
					aSec1[S1_SALDO_ATU] := Abs(nSaldoAtu)
					aSec1[S1_DIGITO] := Eval(bBlockDC,nSaldoAtu)
					F550Print(oReport,If(Len(Trim(HISTOR))>20,.T.,.F.))
					aFill(aSec1,nil)
				Endif
			Endif
			lFlag := .T.             
			If ! lNoSkip
				dbSkip( )
			End
			lNoSkip := .F.
		End
	Endif
	
	If lImprime .Or. nSaldoAtu != 0
		If mv_par14 == 1		// Analitico
			oReport:SkipLine()
			aSec2[S2_DESCRICAO] := STR0017 + If(mv_par03==1,STR0018,STR0019)  //"T o t a i s  d o  "###"C l i e n t e"###"F o r n e c e d o r"
		Endif
		aSec2[S2_DEB] := nTotDeb
		aSec2[S2_CRED] := nTotCrd
		aSec2[S2_SD_ATUAL] := Abs(nSaldoAtu)
		aSec2[S2_DIG2] := Eval(bBlockDC,nSaldoAtu)
		oSection2:PrintLine()
		aFill(aSec2,nil)
		
		If mv_par21 == 1 .And. !Empty(aSdoContabil) // Impr. Saldo Contabil
			// Verifica se deve imprimir o total da conta contabil do fornecedor
			cLoja := ""
			If FR550TotCta(cCtContAnt, cCodigo, cLoja ) .OR. (mv_par25 == 1 .AND. mv_par21 == 1) // Retorna se o saldo deve ser impresso 
				aSec2[S2_DESCRICAO] := STR0046+If(mv_par03==1,STR0018,STR0019) + If(!Empty(cCtContAnt)," ("+AllTrim(cCtContAnt)+") ","") // //"T o t a i s  d o  c o n t a"###"C l i e n t e"###"F o r n e c e d o r"
				aSec2[S2_DEB] := Abs(aSdoContabil[4])
				aSec2[S2_CRED] := Abs(aSdoContabil[5])
				aSec2[S2_SD_ATUAL] := Abs(aSdoContabil[1])
				aSec2[S2_DIG2] := Eval(bBlockDC,aSdoContabil[1])
				oSection2:PrintLine()
				aFill(aSec2,nil)
			EndIf
		EndIf

		If mv_par14 == 1 // Anal¡tico/Sint‚tico
			oReport:ThinLine()
		Endif
	Endif
	nQuebra:=0
End

If nQuebra # 0 .and.(lImprime .Or. nSaldoAtu != 0)
	If mv_par14 == 1		// Anal¡tico/Sint‚tico
		aSec2[S2_DESCRICAO] := STR0017+If(mv_par03==1,STR0018,STR0019)  //"T o t a i s  d o  "###"C l i e n t e"###"F o r n e c e d o r"
	Endif
	aSec2[S2_DEB] := nTotDeb
	aSec2[S2_CRED] := nTotCrd
	aSec2[S2_SD_ATUAL] := Abs(nSaldoAtu)
	aSec2[S2_DIG2] := Eval(bBlockDC,nSaldoAtu)
	oSection2:PrintLine()
	aFill(aSec2,nil)
EndIf

If lFlag
	oReport:SkipLine()
	oReport:ThinLine()
	nSaldoFinal := (nSalAntG-nTotDebG+nTotCrdG)
	aSec2[S2_DESCRICAO] := STR0020 + If(mv_par03==1,STR0021,STR0022)  //"T o t a l   G e r a l  d o s  "###"C l i e n t e s"###"F o r n e c e d o r e s"
	aSec2[S2_SD_ANTERIOR] := nSalAntG
	aSec2[S2_DIG1] := Eval(bBlockDC,nSalAntG)
	aSec2[S2_DEB] := nTotDebG
	aSec2[S2_CRED] := nTotCrdG
	aSec2[S2_SD_ATUAL] := Abs(nSaldoFinal)
	aSec2[S2_DIG2] := Eval(bBlockDC,nSaldoFinal)
	oSection2:PrintLine()
	aFill(aSec2,nil)

	nSaldoFinal := (nSalAntG-nTotDebG+nTotCrdG)

	oReport:ThinLine()
	aSec2[S2_DESCRICAO] := 	STR0023  //"S a l d o   F i n a l   d o   R e l a t o r i o : "
	aSec2[S2_SD_ATUAL] := Abs(nSaldoFinal)
	aSec2[S2_DIG2] := Eval(bBlockDC,nSaldoFinal)
	oSection2:PrintLine()
	aFill(aSec2,nil)
	oReport:ThinLine()
End

oSection1:Finish()
oSection2:Finish()


dbSelectArea("cNomeArq")
Use
Ferase(cNomeArq+GetDBExtension())	// Elimina arquivos de Trabalho
Ferase(cNomeArq+OrdBagExt())    // Elimina arquivos de Trabalho

dbSelectArea("SA1")
RetIndex("SA1")
dbSetOrder(1)
Set Filter To

dbSelectArea("SA2")
RetIndex("SA2")
dbSetOrder(1)
Set Filter To

#IFDEF TOP
	If TcSrvType() != "AS/400"
		dbSelectArea("SE1")
		dbCloseArea()
		ChKFile("SE1")
		dbSelectArea("SE1")
		dbSetOrder(1)
		
		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSelectArea("SE2")
		dbSetOrder(1)
		
		dbSelectArea("SE5")
		dbCloseArea()
		ChKFile("SE5")
		dbSelectArea("SE5")
		dbSetOrder(1)
	Else
#ENDIF
	dbSelectArea("SE1")
	RetIndex("SE1")
	dbSetOrder(1)
	Set Filter To
	
	dbSelectArea("SE2")
	RetIndex("SE2")
	dbSetOrder(1)
	Set Filter To
	
	dbSelectArea("SE5")
	RetIndex("SE5")
	dbSetOrder(1)
	Set Filter To
#IFDEF TOP
	EndIF
#ENDIF                   

NEWSE5->(dbCloseArea())

For nI := 1 to Len(aInd)
	If Select(aInd[nI]) # 0
		dbSelectArea(aInd[nI])
		dbCloseArea()
		If File(aInd[nI] + OrdBagExt())
			fErase(aInd[nI] + OrdBagExt())
			fErase(aInd[nI] + GetDbExtension())
		Endif
	Endif
Next

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³F550RODAPE³ Autor ³ Daniel Tadashi Batori ³ Data ³ 24.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ rotina de impressao dos totais na quebra da pagina R4      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F551RODAPE                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Localizacoes Paises do ConeSul...                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function F550RODAPE(oReport,nSaldoTra,cDigito,aSec1)

Local oSection1 := oReport:Section(1)

oReport:PrintText(STR0015+Transform(Abs(nSaldoTra),tm(Abs(nSaldoTra),14))+" "+cDigito,,oSection1:Cell("E2_VLCRUZ"):ColPos()+1)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³F550Print ³Autor ³Marcel Borges Ferreira ³ Data ³ 07.11.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao da secao um, respeitando parametro mv_par24     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F550Print(oReport)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function F550Print(oReport,lQuebra)
	
Local oSection1 := oReport:Section(1)
	
If mv_par24 == 2 .And. lQuebra
	oSection1:Cell("E1_HIST"):SetSize(20)
	oSection1:Cell("E1_HIST"):Hide()
   	oSection1:PrintLine()
	oSection1:Cell("E1_HIST"):SetSize(40)
	oSection1:Cell("E1_HIST"):Show()
   	oSection1:Cell("E1_VENCTO"):Hide()
   	oSection1:Cell("TITULO"):Hide()
   	oSection1:Cell("E1_EMISSAO"):Hide()
   	oSection1:Cell("E1_VENCREA"):Hide()
   	oSection1:Cell("E2_DTFATUR"):Hide()
   	oSection1:Cell("E1_VLCRUZ"):Hide()
   	oSection1:Cell("E2_VLCRUZ"):Hide()
   	oSection1:Cell("E1_SALDO"):Hide()
   	oSection1:Cell("DIGITO"):Hide()
   	oSection1:PrintLine()
   	oSection1:Cell("E1_VENCTO"):Show()
   	oSection1:Cell("E1_HIST"):Show()
   	oSection1:Cell("TITULO"):Show()
   	oSection1:Cell("E1_EMISSAO"):Show()
   	oSection1:Cell("E1_VENCREA"):Show()
   	oSection1:Cell("E2_DTFATUR"):Show()
   	oSection1:Cell("E1_VLCRUZ"):Show()
   	oSection1:Cell("E2_VLCRUZ"):Show()
   	oSection1:Cell("E1_SALDO"):Show()
   	oSection1:Cell("DIGITO"):Show()
   	oSection1:Cell("E1_HIST"):SetSize(20)
Else
	oSection1:PrintLine() 
EndIf
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  | F550LinPag   ºAutor ³ Marcio Menon	  º Data ³ 30/04/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Faz a quebra de pagina de acordo com o parametro "Linhas   º±±
±±º          ³ por Pagina?" (mv_par23)                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPL1 - Numero maximo de linhas definido no relatorio      º±±
±±º          ³ EXPL2 - Contador de linhas impressas no relatorio          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ nil                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR550                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F550LinPag(nLinPag,nLinReport,oReport,nSaldoTra)

nLinReport++

If nLinReport > (nLinPag + 9)
	oReport:EndPage()
	nLinReport := 8
Else
	nSaldoTra := nSaldoAtu	
EndIf

Return Nil

/*---------------------------------------------------------- RELEASE 3 -----------------------------------------------------------*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR550R3³ Autor ³ Wagner Xavier         ³ Data ³ 25.02.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Razonete de Cliente/Fornecedores                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR550R3(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FinR550R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1 := STR0001  //"Este relatorio ir  imprimir o razonete de Clientes ou"
LOCAL cDesc2 := STR0002  //"Fornecedores. Poder  ser emitida toda a movimenta‡„o "
LOCAL cDesc3 := STR0003  //"dos mesmos, ou somente os valores originais."
LOCAL wnrel
LOCAL cString:="SE1"
LOCAL Tamanho := "M"

PRIVATE titulo :=OemToAnsi(STR0004)  //"Razonete de Contas Correntes"
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn := { OemToAnsi(STR0005), 1, OemToAnsi(STR0006) , 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:= "FINR550"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := "FIN550"
cTipos           := ""

AjustaSX1()

Pergunte("FIN550",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para Filtrar os tipos sem entrar na tela do ³
//³ FINRTIPOS(), localizacao Argentina.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF cPaisLoc <> "BRA"
	IF EXISTBLOCK("FARGTIP")
		cTipos	:=	EXECBLOCK("FARGTIP")
	ENDIF
ENDIF		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01            // A partir de                          ³
//³ mv_par02            // Ate a data                           ³
//³ mv_par03            // Carteira (Receber ou Pagar)          ³
//³ mv_par04            // Do Codigo                            ³
//³ mv_par05            // Ate o Codigo                         ³
//³ mv_par06            // Imprime Valores Financeiros (Sim/Nao)³
//³ mv_par07            // Impime (Todos,Normais,Adiantamentos) ³
//³ mv_par08            // Do Prefixo                           ³
//³ mv_par09            // Ate o Prefixo                        ³
//³ mv_par10            // Lista Por 1 - Filial     2 -Empresa  ³
//³ mv_par11            // Seleciona Tipos                      ³
//³ mv_par12            // Natureza de  ?                       ³
//³ mv_par13            // Natureza ate ?                       ³
//³ mv_par14            // Anal¡tico/Sint‚tico                  ³
//³ mv_par15            // Filtra Prefixo para Saldo Anterior   ³
//³ mv_par16            // Folha De ?                           ³
//³ mv_par17            // Folha Ate ?                          ³
//³ mv_par18            // Filtra Contas Contabeis              ³
//³ mv_par19            // Conta Inicial                        ³
//³ mv_par20            // Conta Final                          ³
//³ mv_par21            // Impr. Saldo Contabil                 ³
//³ mv_par22            // Impr. Cli/Forn s/ Movim.?            ³
//³ mv_par23  			   // Linhas por Página ?                  ³
//| mv_par24            // Historico                            |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "FINR550"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho,"",.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa550Imp(@lEnd,wnRel,cString)},titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA550Imp ³ Autor ³ Wagner Xavier         ³ Data ³ 25.02.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Razonete de Cliente/Fornecedores                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA550Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA550Imp(lEnd,wnRel,cString)

LOCAL CbCont,CbTxt
LOCAL tamanho:="M"
LOCAL nQuebra:=0,lImprAnt := .F.
LOCAL cNome,nTotDeb:=0,nTotCrd:=0,nSaldoAtu:=0,nTotDebG:=0,nTotCrdG:=0,nSalAtuG:=0,nSalAntG:=0
LOCAL dEmissao:=CTOD(""),dVencto:=CTOD("")
LOCAL nRec,nPrim,cPrefixo,cNumero,cParcela,cTipo,cNaturez,nValliq
LOCAL nAnterior:=0,cAnterior,cFornece,dDtDigit,cRecPag,cSeq
LOCAL cCodigo, cLoja
LOCAL lNoSkip := .T.
LOCAL lFlag := .F.
LOCAL nSaldoFinal:=0
LOCAL aCampos:={},aTam:={}
LOCAL aInd:={}
LOCAL cCondE1:=cCondE2:=cCondE5:=" "
LOCAL cIndE1 :=cIndE2 :=cIndE5 :=cIndA1 :=cIndA2 :=" "
LOCAL nRegAtu,lImprime
Local bBlockDC := {| nNum | if(int(nNum*100)=0," ",if(nNum>0,"C","D")) }
Local nX := 0
Local nTamSalto := 0
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
#IFDEF TOP
	Local aStru 	:= {}
#ELSE
	Local nRec1
#ENDIF	
Local aSdoContabil
Local nTamNro	:= TamSx3("E1_NUM")[1]
Local nTamParc := TamSx3("E1_PARCELA")[1]
Local nTamTitulo := TamSx3("E1_PREFIXO")[1] + nTamNro + nTamParc + 3
Local nI
Local aDados := Array(If(lPccBaixa,17,11))
Local aImp10925:= {}
Local aDadosAbat:= {}

//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default))
Local lPccBxCr			:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)

Local cCtContAnt	:= ""
Local li			:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salto da pagina -> mv_par20=Param.Relatorio / 1=Retrato / 2=Paisagem   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(mv_par23)
	nTamSalto := mv_par23	
ElseIf aReturn[4]==1   
	nTamSalto := 65
Else
	nTamSalto := 58
EndIf		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alimenta vetor com os impostos que devem gerar movimentos de historico ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aImp10925,{"SE2->E2_VRETPIS","Pis"})
aadd(aImp10925,{"SE2->E2_VRETCOF","Cofins"})
aadd(aImp10925,{"SE2->E2_VRETCSL","Csll"})

                                                                
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Referencia para imprimir descricao dos tipos de cliente A1_TIPO ³
//ÀÄLocalizacoesÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc != "BRA"
	SX3->(dbSetOrder(2))
	SX3->(dbSeek("A1_TIPO"))
	If SX3->(Found())
		cTipoCli := AllTrim(SX3->(X3CBox()) )
		cTipoCli := '{"'+StrTran(cTipoCli,';','","')+'"}'
		aTipoCli := &(cTipoCli)
	Else            
		cTipoCli := ""
		aTipoCli := {}
	EndIf
EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag  := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se seleciona tipos                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par11 == 1
	finRTipos()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ For‡a ser por filial quando exista somente 1 filial,indepen- ³
//³ dente da resposta                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mv_par10 := Iif(SM0->(Reccount())==1,1,mv_par10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi(STR0007)+IIF(mv_par03==1,OemToAnsi(STR0008), OemToAnsi(STR0009))  //"RAZONETE DE CONTAS CORRENTES DE "###"CLIENTES"###"FORNECEDORES"
If mv_par14 == 1
	cabec1 := OemToAnsi(STR0010)  //"DATA     HISTORICO             PRF NUMERO       PC  EMISSAO   VENCTO    BAIXA             DEBITO          CREDITO     SALDO ATUAL"
Else
	If mv_par03 == 1	// Sintetico a Receber
		cabec1 := OEMTOANSI(STR0044)  //"CLIENTE                                                           SALDO ANTERIOR              DEBITO        CREDITO    SALDO ATUAL"
	Else					// Sintetico a Pagar
		cabec1 := OEMTOANSI(STR0045)  //"FORNECEDOR                                                        SALDO ANTERIOR              DEBITO        CREDITO    SALDO ATUAL"	
	Endif
Endif
cabec2 :=""
m_pag := Iif(mv_par16==0,1,mv_par16)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("E1_CLIENTE")
AADD(aCampos,{"CODIGO" ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E1_LOJA")
AADD(aCampos,{"LOJA"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E1_EMISSAO")
AADD(aCampos,{"DATAEM"   ,"D",aTam[1],aTam[2]})
AADD(aCampos,{"NUMERO" ,"C",nTamTitulo,0})
aTam:=TamSX3("E1_TIPO")
AADD(aCampos,{"TIPO"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E1_PORTADO")
AADD(aCampos,{"BANCO"  ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("E1_EMISSAO")
AADD(aCampos,{"EMISSAO","D",aTam[1],aTam[2]})
AADD(aCampos,{"BAIXA"  ,"D",aTam[1],aTam[2]})
aTam:=TamSX3("E1_VENCREA")
AADD(aCampos,{"VENCTO" ,"D",aTam[1],aTam[2]})
AADD(aCampos,{"VALOR"  ,"N",18,2})
AADD(aCampos,{"HISTOR" ,"C",40,0})
AADD(aCampos,{"DC"     ,"C", 1,0})
AADD(aCampos,{"MOEDA"  ,"N", TamSX3("E1_MOEDA")[1],0}) // Utilizada para saldo contabil
aAdd(aCampos,{"CONTA"	,"C", TamSX3(IIf(mv_par03 == 1, "A1_CONTA", "A2_CONTA"))[1],0})	//Incluido este campo para a aglutinacao por loja
cNomeArq := CriaTrab(aCampos)
dbUseArea(.T., __cRDDNTTS, cNomeArq, "cNomeArq", if(.F. .Or. .F., !.F., NIL), .F. )

IF mv_par03 == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza e grava titulos a receber dentro dos parametros     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	dbSetOrder(2)
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			aStru:= SE1->(dbStruct())
			cCondE1:=".T."
			cQuery := "SELECT * FROM " + RetSqlName("SE1") + " WHERE"
			cIndE1	:=IndexKey()
			If mv_par10 = 1
				cQuery += " E1_FILIAL = '" + xFilial("SE1") + "' AND "
			else
				cQuery += " E1_FILIAL BETWEEN '  ' AND 'ZZ' AND"	  
				cIndE1 :=Right(cIndE1,Len(cIndE1)-10)
			endif
			cIndE1 := SqlOrder(cIndE1)
			
			dbSelectArea("SE1")
			dbCloseArea()
			dbSelectArea("SA1")
			
			cQuery += " E1_CLIENTE BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'"
			cQuery += " AND E1_EMISSAO <= '" + DTOS(dDataBase) + "'"
			cQuery += " AND E1_EMISSAO <= '" + DTOS(mv_par02) + "'"
			cQuery += " AND E1_TIPO NOT LIKE 'PR%'"
			If mv_par15 == 1
				cQuery += " AND E1_PREFIXO BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
			Endif
			cQuery += " AND E1_NATUREZ BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "'"
			If mv_par11 == 1
				cQuery += " AND E1_TIPO IN " + FORMATIN(cTipos,"/")
			Endif
			cQuery += " AND D_E_L_E_T_ <> '*'"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica quais serao impressos                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
			If mv_par07 == 2 // So'Normais
				cQuery += " And E1_TIPO NOT IN " + FORMATIN(MVRECANT,"/") 
			Endif                                            
					
			If mv_par07 == 3 // So'Adiantamentos
				cQuery += " And E1_TIPO IN " + FORMATIN(MVRECANT,"/")
			End			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Le registros com data anterior a data inicial (para compor   ³
			//³ os saldos anteriores) ate a data final.                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery += " And E1_EMISSAO <= '" + dtos(mv_par02) + "'"																	
			
			If mv_par18 == 1 .And. TcGetDb() $ "MSSQL/MSSQL7/ORACLE"		// Seleciona clientes por conta contabil
				cFilial := xFilial()
				cQuery += " AND E1_CLIENTE IN ("					
				cQuery += "SELECT SA1.A1_COD FROM " + RetSqlName("SA1") + " SA1 "
				cQuery += "WHERE SA1.A1_FILIAL = '" + cFilial + "' AND SA1.A1_COD = E1_CLIENTE AND SA1.A1_LOJA = E1_LOJA AND "
				cQuery += "SA1.A1_CONTA BETWEEN '" + mv_par19 + "' AND '" + mv_par20 + "' AND SA1.D_E_L_E_T_ <> '*')"			
			Endif					
			cQuery += " ORDER BY " + cIndE1
			
			cQuery := ChangeQuery(cQuery)
			
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)
			
			For ni := 1 to Len(aStru)
				If aStru[ni,2] != 'C'
					TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next
		else
	#ENDIF
		If mv_par10 = 1
			dbSeek(xFilial()+mv_par04,.T.)
			cCondE1:="xFilial()==SE1->E1_FILIAL .and. SE1->E1_CLIENTE >= mv_par04 .And. SE1->E1_CLIENTE <= mv_par05"
		Else
			cArqTrab :=CriaTrab(NIL,.F.)
			AADD(aInd,cArqTrab)
			cIndE1   :=IndexKey()
			cIndE1   :=Right(cIndE1,Len(cIndE1)-10)
			IndRegua("SE1",cArqTrab,cIndE1,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
			cCondE1:="SE1->E1_CLIENTE >= mv_par04 .And. SE1->E1_CLIENTE <= mv_par05"
			dbCommit()
			nIndex:=RetIndex("SE1")
			dbSelectArea("SE1")
			#IFNDEF TOP
				dbSetIndex(cArqTrab+OrdBagExt())
			#ENDIF
			dbSetOrder(nIndex+1)
			dbSeek(mv_par04,.T.)
		EndIf
	#IFDEF TOP
		EndIf
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posicionamento do SE5 neste ponto que servira para   ³
	//³pesquisa de descarte de registros geradores de       ³
	//³desdobramento                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE5")
	SE5->(dbSetOrder(7))	//E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
	
	While !SE1->(Eof()) .and. &(cCondE1)
		
		If SE1->E1_NATUREZ < mv_par12 .Or. SE1->E1_NATUREZ > mv_par13
			SE1->(dbSkip())
			Loop
		EndIf
		If mv_par18 == 1 .And. !(TcGetDb() $ "MSSQL/MSSQL7/ORACLE")		// Seleciona clientes por conta contabil
			dbSelectArea("SA1")
			MsSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
			If SA1->A1_CONTA < mv_par19 .or. SA1->A1_CONTA > mv_par20
				dbSelectArea("SE1")
				dbSkip()
				Loop
			Endif
		Endif
		dbSelectArea("SE1")

		IF SE1->E1_TIPO $ MVPROVIS
			SE1->(dbSkip())
			Loop
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quais serao impressos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par07 == 2 .and. E1_TIPO $ MVRECANT  // So'Normais
			dbSkip( )
			Loop
		Endif
		
		If mv_par07 == 3 .and. !E1_TIPO $ MVRECANT // So'Adiantamentos
			dbSkip( )
			Loop
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Le registros com data anterior a data inicial (para compor   ³
		//³ os saldos anteriores) ate a data final.                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SE1->E1_EMISSAO > mv_par02
			SE1->(dbSkip( ) )
			Loop
		End

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa de descarte de registros geradores de       ³
		//³desdobramento                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SE5->(dbSeek(xFilial("SE5") + SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)))
			If AllTrim(SE5->E5_TIPODOC) == "BA" .AND. AllTrim(SE5->E5_MOTBX) == "DSD"
				SE1->(dbSkip())
				Loop
			Endif
		Endif		
		
		IF ! Inside(SE1->E1_TIPO)
			dbSkip()
			Loop
		End
		
		IF SE1->E1_EMISSAO >= mv_par01 .or. mv_par15 == 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica prefixo caso a movimenta‡„o n„o seja interpretada   ³
			//³ para calculo do saldo anterior ou quando solicitado.         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SE1->E1_PREFIXO < mv_par08 .Or. SE1->E1_PREFIXO > mv_par09
				SE1->(dbSkip())
				Loop
			Endif
		Endif
		
		If SE1->E1_TIPO $ MVABATIM
			AAdd( aDadosAbat, {SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_EMISSAO,SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA,;
									 SE1->E1_PORTADO,SE1->E1_EMISSAO,SE1->E1_VENCREA,SE1->E1_VLCRUZ,SE1->E1_BAIXA} )
		EndIf			
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava debito no arquivo de trabalho                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("cNomeArq")
		Reclock("cNomeArq",.t.)
		Replace CODIGO  With SE1->E1_CLIENTE
		Replace LOJA    With SE1->E1_LOJA
		Replace DATAEM  With SE1->E1_EMISSAO
		Replace NUMERO  With SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
		Replace TIPO    With SE1->E1_TIPO
		Replace BANCO   With SE1->E1_PORTADO
		Replace EMISSAO With SE1->E1_EMISSAO
		Replace VENCTO  With SE1->E1_VENCREA
		Replace VALOR   With SE1->E1_VLCRUZ
		Replace MOEDA   With SE1->E1_MOEDA
		If cPaisLoc <> "BRA"
			If SE1->E1_TIPO $ MV_CRNEG
				cHistor := OemToAnsi(STR0030)  //"NOTA DE CREDITO No. "
			ElseIf SE1->E1_TIPO $ MV_CPNEG
				cHistor := OemToAnsi(STR0031)  //"NOTA DE DEBITO No. "
			ElseIf ALLTRIM(SE1->E1_TIPO) $ "NF|FT"
				cHistor := OemToAnsi(STR0032)  //"FACTURA No. "
			ElseIf SE1->E1_TIPO == "RA "
				cHistor := OemToAnsi(STR0033)  //"ANTICIPO"
			ElseIf SE1->E1_TIPO == "NCI"
				cHistor := OemToAnsi(STR0034)  //"NOTA DE CRED. INTERNA"
			ElseIf SE1->E1_TIPO == "NDI"
				cHistor := OemToAnsi(STR0035)  //"NOTA DE DEB. INTERNA"
			Else
			    cHistor := SE1->E1_HIST	
			EndIf
			Replace HISTOR  With cHistor
		ElseIf SE1->E1_FATURA=="NOTFAT".and. cPaisLoc == "BRA"
			Replace HISTOR  With IIF(Empty(SE1->E1_HIST),OemToAnsi(STR0029),SE1->E1_HIST)  //"Pela Emissao da Fatura"
		Else
			Replace HISTOR  With IIF(Empty(SE1->E1_HIST),OemToAnsi(STR0012),SE1->E1_HIST)  //"Pela Emissao do Titulo"
		Endif
		If SE1->E1_TIPO $ MVRECANT+"/"+MVABATIM+"/"+MV_CRNEG+"/PIS#COF#CSL" //PIS/COF/CSL = PCC Baixa CR
			Replace DC   With "C"
		Else
			Replace DC   With "D"
		Endif  
		If mv_par18 == 2
			If mv_par10 == 1
				Replace CONTA With GetAdvfVal("SA1","A1_CONTA",xFilial("SA1") + SE1->(E1_CLIENTE + E1_LOJA),1)
			Else          
				Replace CONTA With FR550RetCF(SE1->E1_CLIENTE, SE1->E1_LOJA, "A1_CONTA")
			Endif
		Endif
		MsUnlock()
	
		dbSelectArea("SE1")
		dbSkip()
	Enddo
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			DBSelectArea("SE1")
			DbCloseArea()
			ChkFile("SE1")
		Endif
	#ENDIF
Endif

IF mv_par03 == 2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza e grava titulos a pagar dentro dos parametros       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	dbSetOrder (6)
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			aStru:= SE2->(dbStruct())
			cCondE2:=".T."
			cQuery := "SELECT * FROM " + RetSqlName("SE2") + " WHERE"
			cIndE2	:=IndexKey()
			If mv_par10 = 1
				cQuery += " E2_FILIAL = '" + xFilial("SE2") + "' AND "
			else
				cQuery += " E2_FILIAL BETWEEN '  ' AND 'ZZ' AND"
				cIndE2 :=Right(cIndE2,Len(cIndE2)-10)
			endif
			cIndE2 := SqlOrder(cIndE2)
			
			dbSelectArea("SE2")
			dbCloseArea()
			dbSelectArea("SA1")
			cQuery += " E2_FORNECE BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'"
			cQuery += " AND E2_EMIS1 <= '" + DTOS(mv_par02)  + "'"
			cQuery += " AND E2_EMIS1 <= '" + DTOS(dDataBase) + "'"
			If mv_par15 == 1
				cQuery += " AND E2_PREFIXO BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
			Endif
			cQuery += " AND E2_TIPO NOT LIKE '"+MVPROVIS+"'"
			cQuery += " AND E2_NATUREZ BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "'"
			If mv_par11 == 1
				cQuery += " AND E2_TIPO IN " + FORMATIN(cTipos,"/")
			Endif
			cQuery += " AND D_E_L_E_T_ <> '*'"  
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica quais serao impressos                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
			If mv_par07 == 2 // So'Normais
				cQuery += " And E2_TIPO NOT IN " + FORMATIN(MVRECANT,"/") 
			Endif                                            
					
			If mv_par07 == 3 // So'Adiantamentos
				cQuery += " And E2_TIPO IN " + FORMATIN(MVRECANT,"/")
			End			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Le registros com data anterior a data inicial (para compor   ³
			//³ os saldos anteriores) ate a data final.                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery += " And E2_EMIS1 <= '" + dtos(mv_par02) + "'"																	
			
			If mv_par18 == 1 .And. TcGetDb() $ "MSSQL/MSSQL7/ORACLE"		// Seleciona clientes por conta contabil
				cFilial := xFilial()
				cQuery += " AND E2_FORNECE IN ("					
				cQuery += "SELECT SA2.A2_COD FROM " + RetSqlName("SA2") + " SA2 "
				cQuery += "WHERE SA2.A2_FILIAL = '" + cFilial + "' AND SA2.A2_COD = E2_FORNECE AND SA2.A2_LOJA = E2_LOJA AND "
				cQuery += "SA2.A2_CONTA BETWEEN '" + mv_par19 + "' AND '" + mv_par20 + "' AND SA2.D_E_L_E_T_ <> '*') "	 
			Endif									
			cQuery += " ORDER BY " + cIndE2
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE2', .F., .T.)
			
			For ni := 1 to Len(aStru)
				If aStru[ni,2] != 'C'
					TCSetField('SE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next
		Else
	#ENDIF
		dbSetOrder (6)
		If mv_par10 = 1
			dbSeek(xFilial()+mv_par04,.T.)
			cCondE2:="SE2->E2_FILIAL==xFilial() .and. SE2->E2_FORNECE >= mv_par04 .And. SE2->E2_FORNECE <= mv_par05"
		Else
			cArqTrab :=CriaTrab(NIL,.F.)
			AADD(aInd,cArqTrab)
			cIndE2   :=IndexKey()
			cIndE2   :=Right(cIndE2,Len(cIndE2)-10)
			IndRegua("SE2",cArqTrab,cIndE2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
			cCondE2:="SE2->E2_FORNECE >= mv_par04 .And. SE2->E2_FORNECE <= mv_par05"
			dbCommit()
			nIndex:=RetIndex("SE2")
			dbSelectArea("SE2")
			#IFNDEF TOP
				dbSetIndex(cArqTrab+OrdBagExt())
			#ENDIF
			dbSetOrder(nIndex+1)
			dbSeek(mv_par04,.T.)
		EndIf
		#IFDEF TOP
		EndIf
		#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posicionamento do SE5 neste ponto que servira para   ³
	//³pesquisa de descarte de registros geradores de       ³
	//³desdobramento                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE5")
	SE5->(dbSetOrder(7))	//E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
	
	While !SE2->(Eof()) .and. &(cCondE2)
		
		If ( SE2->E2_NATUREZ < mv_par12 .Or. SE2->E2_NATUREZ > mv_par13 )
			SE2->(dbSkip())
			Loop
		EndIf
		
		IF SE2->E2_TIPO $ MVPROVIS
			SE2->(dbSkip())
			Loop
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa de descarte de registros geradores de       ³
		//³desdobramento                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SE5->(dbSeek(xFilial("SE5") + SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
			If AllTrim(SE5->E5_TIPODOC) == "BA" .AND. AllTrim(SE5->E5_MOTBX) == "DSD"
				SE2->(dbSkip())
				Loop
			Endif
		Endif		
		
		If mv_par18 == 1 .And. !(TcGetDb() $ "MSSQL/MSSQL7/ORACLE")		// Seleciona fornecedores por conta contabil
			dbSelectArea("SA2")
			MsSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
			If SA2->A2_CONTA < mv_par19 .or. SA2->A2_CONTA > mv_par20
				dbSelectArea("SE2")
				dbSkip()
				Loop
			Endif
		Endif
      	dbSelectArea("SE2")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quais serao impressos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par07 == 2 .and. SE2->E2_TIPO $ MVPAGANT // So'Normais
			dbSkip()
			Loop
		Endif
		
		If mv_par07 == 3 .and. !SE2->E2_TIPO $ MVPAGANT //So'Adiantamentos
			dbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Le registros com data anterior a data inicial (para compor   ³
		//³ os saldos anteriores) ate a data final.                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If IIf(SE2->E2_EMIS1 < SE2->E2_EMISSAO, SE2->E2_EMISSAO, SE2->E2_EMIS1) > mv_par02
			SE2->(dbSkip())
			Loop
		End
		
		if ! Inside(SE2->E2_TIPO)
			dbSkip()
			Loop
		End

		IF IIf(SE2->E2_EMIS1 < SE2->E2_EMISSAO, SE2->E2_EMISSAO, SE2->E2_EMIS1) >= mv_par01 .OR. mv_par15 == 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica prefixo caso a movimenta‡„o n„o seja interpretada   ³
			//³ para calculo do saldo anterior ou quando solicitado.         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SE2->E2_PREFIXO < mv_par08 .Or. SE2->E2_PREFIXO > mv_par09
				SE2->(dbSkip())
				Loop
			EndIf
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava debito no arquivo de trabalho                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Reclock("cNomeArq",.T.)
		Replace CODIGO  	With SE2->E2_FORNECE
		Replace LOJA    	With SE2->E2_LOJA
		Replace DATAEM   	With IIf(SE2->E2_EMIS1 < SE2->E2_EMISSAO, SE2->E2_EMISSAO, SE2->E2_EMIS1)
		Replace NUMERO  	With SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
		Replace TIPO    	With SE2->E2_TIPO
		Replace BANCO   	With SE2->E2_PORTADO
		Replace EMISSAO 	With SE2->E2_EMISSAO
		Replace VENCTO  	With SE2->E2_VENCREA
		Replace VALOR   	With SE2->E2_VLCRUZ
		Replace MOEDA   	With SE2->E2_MOEDA
		If cPaisLoc <> "BRA"
			cHistor := ""
			If SE2->E2_TIPO == "NCP"
				cHistor := OemToAnsi(STR0030)  //"NOTA DE CREDITO No. "
			ElseIf SE2->E2_TIPO == "NDP"
				cHistor := OemToAnsi(STR0031)  //"NOTA DE DEBITO No. "
			ElseIf ALLTRIM(SE2->E2_TIPO) $ "NF|FT"
				cHistor := OemToAnsi(STR0032)  //"FACTURA No. "
			ElseIf SE2->E2_TIPO == "NCE"
				cHistor := OemToAnsi(STR0036)  //"NOTA DE CRED. EXTERNA"
			ElseIf SE2->E2_TIPO == "NDE"
				cHistor := OemToAnsi(STR0037)  //"NOTA DE DEB. EXTERNA"
			EndIf
			Replace HISTOR  With IIF(Empty(SE2->E2_HIST),cHistor,SE2->E2_HIST)
		ElseIf SE2->E2_FATURA=="NOTFAT" .and. cPaisLoc == 'BRA'
			Replace HISTOR  With IIF(Empty(SE2->E2_HIST),OemToAnsi(STR0029),SE2->E2_HIST)  //"Pela Emissao da Fatura"
		Else
			Replace HISTOR  With IIF(Empty(SE2->E2_HIST),OemToAnsi(STR0012),SE2->E2_HIST)  //"Pela Emissao do Titulo"
		Endif
		IF SE2->E2_TIPO$ MVPAGANT+"/"+MVABATIM+"/"+MV_CPNEG
			Replace DC     With "D"
		Else
			Replace DC     With "C"     //Abatimentos
		Endif
		If mv_par18 == 2
			If mv_par10 == 1
				Replace CONTA With GetAdvfVal("SA2","A2_CONTA",xFilial("SA2") + SE2->(E2_FORNECE + E2_LOJA),1)
			Else 
				Replace CONTA With FR550RetCF(SE2->E2_FORNECE, SE2->E2_LOJA, "A2_CONTA")
			Endif
		Endif
		MsUnlock()

		//Abatimentos que fizeram parte da fatura
		IF SE2->E2_TIPO $ MVABATIM .and. !Empty(SE2->E2_FATURA) .and. ;
				SE2->E2_FATURA != "NOTFAT" .and. SE2->E2_DTFATUR <= mv_par02

			Reclock("cNomeArq",.t.)
			Replace CODIGO  With SE2->E2_FORNECE
			Replace LOJA    With SE2->E2_LOJA
			Replace DATAEM  With IIf(SE2->E2_EMIS1 < SE2->E2_EMISSAO, SE2->E2_EMISSAO, SE2->E2_EMIS1)
			Replace NUMERO  With SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
			Replace TIPO    With SE2->E2_TIPO
			Replace BANCO   With SE2->E2_PORTADO
			Replace EMISSAO With SE2->E2_EMISSAO
			Replace VENCTO  With SE2->E2_VENCREA
			Replace VALOR   With SE2->E2_VLCRUZ
			Replace BAIXA   With SE2->E2_DTFATUR
			Replace HISTOR  With OemToAnsi(STR0013)+SE2->E2_FATURA  //"BX EMIS FAT "
			Replace DC      With "C"     //Baixa de Abatimento por emissao de fatura
			If mv_par18 == 2
				If mv_par10 == 1
					Replace CONTA With GetAdvfVal("SA2","A2_CONTA",xFilial("SA2") + SE2->(E2_FORNECE + E2_LOJA),1)
				Else 
					Replace CONTA With FR550RetCF(SE2->E2_FORNECE, SE2->E2_LOJA, "A2_CONTA")
				Endif
			Endif
			MsUnlock()
                                                
		Endif	
		
		//Gera movimentos de histórico em casos de retenção de pis, cofins e csll
		If lPCCBaixa .And. SE2->E2_TIPO $ MVPAGANT  //Verifico se eh PA para exibir tx's na emissao
			For nX:= 1 To Len(aImp10925)
				If &(aImp10925[nX][1]) > 0
					Reclock("cNomeArq",.T.)
					Replace CODIGO 	With SE2->E2_FORNECE
					Replace LOJA		With SE2->E2_LOJA
					Replace DATAEM		With IIf(SE2->E2_EMIS1 < SE2->E2_EMISSAO, SE2->E2_EMISSAO, SE2->E2_EMIS1)
					Replace NUMERO 	With SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
					Replace EMISSAO	With SE2->E2_EMISSAO
					Replace VALOR		With &(aImp10925[nX][1])
					Replace HISTOR 	With STR0047 + " - " + aImp10925[nX][2]  //Desc.Imposto
					Replace VENCTO		With SE2->E2_VENCREA
					Replace DC	  		With "D"
					If mv_par18 == 2
						If mv_par10 == 1
							Replace CONTA With GetAdvfVal("SA2","A2_CONTA",xFilial("SA2") + SE2->(E2_FORNECE + E2_LOJA),1)
						Else 
							Replace CONTA With FR550RetCF(SE2->E2_FORNECE, SE2->E2_LOJA, "A2_CONTA")
						Endif
					Endif
					MsUnlock()
				Endif
			Next
		Endif
			
		dbSelectArea("SE2")
		dbSkip()
	Enddo
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			DBSelectArea("SE2")
			DbCloseArea()
			ChkFile("SE2")
		Endif
	#ENDIF
Endif

//Ordeno Array de abatimentos de C.Receber
If Len(aDadosAbat) > 0
	aSort(aDadosAbat,,,{|x,y| x[1]+x[2]+x[4] > y[1]+y[2]+y[4]})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza na movimentacao bancaria, os titulos do periodo     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE5")               
ChkFile("SE5",.F.,"NEWSE5")
dbSelectArea("SE5")
dbSetOrder(7)
#IFDEF TOP
	If TcSrvType() != "AS/400"
		// Alterado por Alex Sandro Valario  em desenvolvimento 1Inicio
		aStru := SE5->(dbStruct())
		
		cCondE5:=".T."
		cQuery := "SELECT * FROM " + RetSqlName("SE5") + " WHERE"
		cIndE5	:=IndexKey()
		If mv_par10 = 1
			cQuery += " E5_FILIAL = '" + xFilial("SE5") + "' AND "
		else
			cQuery += " E5_FILIAL BETWEEN '  ' AND 'ZZ' AND"
			cIndE5 :=Right(cIndE5,Len(cIndE5)-10)
		endif
		cIndE5 := SqlOrder(cIndE5)
		
		dbSelectArea("SE5")
		dbCloseArea()
		dbSelectArea("SA1")
		
		cQuery += " E5_DTDIGIT <= '" + DTOS(mv_par02) + "'"
		cQuery += " AND E5_NUMERO <> '" +space(6)+"'"
		cQuery += " AND E5_SITUACA    <> 'C'"
		cQuery += " AND E5_SITUACA    <> 'X'"
		cQuery += " AND E5_DTDIGIT    <= '"+DTOS(dDataBase)+ "'"
		If mv_par15 == 1
			cQuery += " AND E5_PREFIXO BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
		Endif
		cQuery += " AND E5_CLIFOR BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'"
		cQuery += " AND E5_NATUREZ BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "'"
		If mv_par11 == 1
			cQuery += " AND E5_TIPO IN " + FORMATIN(cTipos,"/")
		Endif
		cQuery += " AND E5_TIPODOC IN ('VL','VM','BA','CP','LJ','V2','ES')" 
		cQuery += " AND D_E_L_E_T_ <> '*'"
		If mv_par03 == 1
			cQuery += " AND ((E5_RECPAG = 'R' AND E5_TIPODOC <> 'ES')"
			cQuery += " OR (E5_TIPODOC = 'ES' AND E5_RECPAG = 'P')"
			cQuery += " OR (E5_TIPO IN ('"+MV_CRNEG+"','"+MVRECANT+"')))"
		Endif
		If mv_par03 == 2
			cQuery += " AND ((E5_RECPAG = 'P' AND E5_TIPODOC <> 'ES')"
			cQuery += " OR  (E5_TIPODOC = 'ES' AND E5_RECPAG = 'R')"
			cQuery += " OR (E5_TIPO IN ('"+MV_CPNEG+"','"+MVPAGANT+"')))"
		Endif
		
		// Tratamento para restringir os registros da query do SE5 aos que possuam seus respectivos SE1 ou SE2
		If TcGetDb() $ "MSSQL/MSSQL7/ORACLE"
		
			cQuery += "AND EXISTS ("		
			
			cQuery += " SELECT SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_CLIENTE, SE1.E1_LOJA FROM "+RetSqlName("SE1")+" SE1, "+RetSqlName("SE5")+" SE5 WHERE "
			cQuery += " SE1.E1_FILIAL = SE5.E5_FILIAL AND "
			cQuery += " SE1.E1_PREFIXO = SE5.E5_PREFIXO AND "
			cQuery += " SE1.E1_NUM = SE5.E5_NUMERO AND "
			cQuery += " SE1.E1_PARCELA = SE5.E5_PARCELA AND "
			cQuery += " SE1.E1_TIPO	= SE5.E5_TIPO AND "
			cQuery += " SE1.E1_CLIENTE = SE5.E5_CLIFOR AND "
			cQuery += " SE1.E1_LOJA = SE5.E5_LOJA "
			cQuery += " UNION "
			cQuery += " SELECT SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, SE2.E2_FORNECE, SE2.E2_LOJA FROM "+RetSqlName("SE2")+" SE2, "+RetSqlName("SE5")+" SE5 WHERE "
			cQuery += " SE2.E2_FILIAL = SE5.E5_FILIAL AND "
			cQuery += " SE2.E2_PREFIXO = SE5.E5_PREFIXO AND "
			cQuery += " SE2.E2_NUM = SE5.E5_NUMERO AND "
			cQuery += " SE2.E2_PARCELA = SE5.E5_PARCELA AND "
			cQuery += " SE2.E2_TIPO	= SE5.E5_TIPO AND "
			cQuery += " SE2.E2_FORNECE = SE5.E5_CLIFOR AND "
			cQuery += " SE2.E2_LOJA	= SE5.E5_LOJA"
			
			cQuery += ") "
			
		Endif

		cQuery += " ORDER BY " + cIndE5
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5', .F., .T.)
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
	Else
#ENDIF
	If mv_par10 = 1
		dbSeek(xFilial(),.T.) // Com SoftSeek ON
		cCondE5:="xFilial('SE5') == SE5->E5_FILIAL"
	Else
		cArqTrab :=CriaTrab(NIL,.F.)
		AADD(aInd,cArqTrab)
		cIndE5   :=IndexKey()
		cIndE5   :=Right(cIndE5,Len(cIndE5)-10)
		IndRegua("SE5",cArqTrab,cIndE5,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
		cCondE5:=".T."
		dbCommit()
		nIndex:=RetIndex("SE5")
		dbSelectArea("SE5")
		#IFNDEF TOP
			dbSetIndex(cArqTrab+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndex+1)
		dbGoTop()
	EndIf
#IFDEF TOP
	EndIf
#ENDIF
If mv_par03 == 1 //Carteira a Receber
	dbSelectArea("SE1")
	dbSetOrder(1)
	cArqTrab :=CriaTrab(NIL,.F.)
	AADD(aInd,cArqTrab)
	cIndE1   :=IndexKey()
	cIndE1   :=Right(cIndE1,Len(cIndE1)-10)
	IndRegua("SE1",cArqTrab,cIndE1,,,OemToAnsi(STR0011)) //"Selecionando Registros..."
	dbCommit()
	nIndexSE1:=RetIndex("SE1")
	dbSelectArea("SE1")
	#IFNDEF TOP
		dbSetIndex(cArqTrab+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndexSE1+1)
	dbGoTop()
Endif

If mv_par03 == 2 //Carteira a Receber	
	dbSelectArea("SE2")
	dbSetOrder(1)
	cArqTrab :=CriaTrab(NIL,.F.)
	AADD(aInd,cArqTrab)
	cIndE2   :=IndexKey()
	cIndE2   :=Right(cIndE2,Len(cIndE2)-10)
	IndRegua("SE2",cArqTrab,cIndE2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
	dbCommit()
	nIndexSE2:=RetIndex("SE2")
	dbSelectArea("SE2")
	#IFNDEF TOP
		dbSetIndex(cArqTrab+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndexSE2+1)
	dbGotop()
Endif	

dbSelectArea("SE5")

While !SE5->(Eof()) .and. &(cCondE5)

	#IFNDEF TOP
		
		// Tratamento das consistencias dos registros do SE5 quando o mesmo
		// não for tratado por Query
		
		If !ValidSE5()
			SE5->(dbSkip())
			Loop
		Endif
	
	#ELSE
		If TcSrvType() == "AS/400"
	
			If !ValidSE5()
				SE5->(dbSkip())
				Loop
			Endif
	
		Endif
	#ENDIF
	
	dbSelectArea("SE5")

	If SE5->E5_RECPAG == "R" .and. mv_par03 == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quais serao impressos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par07 == 2 .and. E5_TIPO $ MVRECANT   // So'Normais
			dbSkip()
			Loop
		Endif
		
		If mv_par07 == 3 .and. !E5_TIPO $ MVRECANT  // So'Adiantamentos
			dbSkip()
			Loop
		Endif
	ElseIf SE5->E5_RECPAG == "P" .and. mv_par03 == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quais serao impressos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par07 == 2 .and. E5_TIPO $ MVPAGANT  // So'Normais
			dbSkip( )
			Loop
		Endif
		
		If mv_par07 == 3 .and. !E5_TIPO $ MVPAGANT // So'Adiantamentos
			dbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ignora PA's pagos com Junta de Cheque                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If E5_TIPO $ MVPAGANT .and. E5_TIPODOC == "BA" .And. !E5_MOTBX $ "CMP"
			DbSkip()
			Loop
		Endif
	Endif

	IF mv_par03 == 1 .and. SE5->E5_RECPAG != "R"
		If (!(SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG ) .AND. SE5->E5_TIPODOC !="ES") .or. ; //Baixa de RA
			(SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .AND. SE5->E5_TIPODOC =="ES") .or. ; //Estorno da Baixa de PA
			((SE5->E5_TIPO $ MVRECANT) .AND. MV_PAR07 == 2).or. ;
			(!(SE5->E5_TIPO $ MVRECANT) .AND. MV_PAR07 == 3)
			SE5->(dbSkip())
			Loop
		Endif
	EndIF
	IF mv_par03 == 2 .and. SE5->E5_RECPAG != "P"
		If (!( SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG ) .AND. SE5->E5_TIPODOC !="ES") .or.;   //Baixa de PA
			(SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG .AND. SE5->E5_TIPODOC =="ES") .or. ; //Estorno da Baixa de RA
			(( SE5->E5_TIPO $ MVPAGANT) .AND. mv_par07 == 2).or. ;
			(!(SE5->E5_TIPO $ MVPAGANT) .AND. mv_par07 == 3)
			SE5->(dbSkip())
			Loop
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Descartar registros geradores de desdobramento       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
	If AllTrim(SE5->E5_TIPODOC) == "BA" .AND. AllTrim(SE5->E5_MOTBX) == "DSD"
		SE5->(dbSkip())
		Loop
	Endif

	If mv_par03 == 1        // Se for baixa de adiantamentos
		If SE5->E5_RECPAG == "R" .and. E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .AND. SE5->E5_TIPODOC $ "VL/BA/DC/D2/MT/JR/J2/M2/CM/C2/CX"
			dbSkip()
			LOOP
		EndIf
	EndIf
	
	If mv_par03 == 2        // Se for baixa de adiantamentos
		If SE5->E5_RECPAG == "P" .and. E5_TIPO $ MVRECANT+"/"+MV_CRNEG .AND. SE5->E5_TIPODOC $ "VL/BA/DC/D2/MT/JR/J2/M2/CM/C2/CX"
			dbSkip()
			LOOP
		End
	End          

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
	//³ Não considera registro de estorno de compensação de cheques³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
	If SE5->E5_TIPODOC = "ES" .And. SE5->E5_RECPAG = "P"
		aAreaSE5 := SE5->(GetArea())	
		dbSelectArea("NEWSE5")
		dbSetOrder(2)
		If MsSeek(xFilial("SE5")+"CH"+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
			SE5->(dbSkip())
			Loop
		EndIf
		RestArea(aAreaSE5)
	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza o cliente ou fornecedor                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCarteira := SE5->E5_RECPAG
	If SE5->E5_RECPAG == "R"
		If ((SE5->E5_TIPO$MVPAGANT+"/"+MV_CPNEG));
			.OR. ((!SE5->E5_TIPO$MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG) .And. SE5->E5_TIPODOC =="ES")
			cCarteira := "P"        //Baixa de adiantamento (inverte)
		Endif 
	Endif
	
	If SE5->E5_RECPAG == "P"
		If ((SE5->E5_TIPO$MVRECANT+"/"+MV_CRNEG));
			.OR. ((!SE5->E5_TIPO$MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG) .And. SE5->E5_TIPODOC =="ES")
			cCarteira := "R"        //Baixa de adiantamento (inverte)
		Endif 
	Endif

	IF cCarteira == "R"   
		dbSelectArea("SE1")
		If mv_par10 = 1
			dbSetOrder(1)
			dbSeek(xFilial()+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
		Else
			dbSetOrder(nIndexSE1+1)
			dbSeek(SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
		EndIf
		//Caso nÆo ache o registro no SE1, nÆo considero os movimentos
		If !Found()
			dbSelectArea("SE5")
			DbSkip()
			Loop
		Else
			If mv_par18 == 1		// Seleciona clientes por conta contabil
				dbSelectArea("SA1")
				MsSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
				If SA1->A1_CONTA < mv_par19 .or. SA1->A1_CONTA > mv_par20
					dbSelectArea("SE5")
					dbSkip()
					Loop
				Endif
			Endif	
		Endif				
	Else
		dbSelectArea("SE2")
		If mv_par10 = 1
			dbSetOrder(1)
			dbSeek(xFilial()+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)
		Else
			dbSetOrder(nIndexSE2+1)
			dbSeek(SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)
		Endif
		//Caso nÆo ache o registro no SE2, nÆo considero os movimentos
		If !Found()
			dbSelectArea("SE5")
			DbSkip()
			Loop
		Else
			If mv_par18 == 1		// Seleciona fornecedores por conta contabil
				dbSelectArea("SA2")
				MsSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
				If SA2->A2_CONTA < mv_par19 .or. SA2->A2_CONTA > mv_par20
					dbSelectArea("SE5")
					dbSkip()
					Loop
				Endif
			Endif	
		Endif
	Endif		
	dbSelectArea("SE5")
	IF cCarteira == "R"
		dEmissao := SE1->E1_EMISSAO
		dVencto  := SE1->E1_VENCREA
	Else
		dEmissao := SE2->E2_EMISSAO
		dVencto  := SE2->E2_VENCREA
	Endif  

	aDados[1] := E5_CLIFOR
	aDados[2] := E5_LOJA
	aDados[3] := E5_DTDIGIT
	aDados[4] := E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA
	aDados[5] := E5_BANCO
	aDados[6] := E5_DATA
	aDados[7] := E5_HISTOR
	aDados[8] := E5_RECPAG
	aDados[9] := E5_TIPO
	aDados[10]:= E5_TIPODOC
	aDados[11]:= E5_VALOR

	If lPccBaixa .and. mv_par03 == 2 //Carteira a Pagar
		aDados[12]:= E5_PRETPIS
		aDados[13]:= E5_PRETCOF
		aDados[14]:= E5_PRETCSL
		
		aDados[15]:= E5_VRETPIS
		aDados[16]:= E5_VRETCOF
		aDados[17]:= E5_VRETCSL
	Endif	

	nValliq := E5_VALOR
	If mv_par06 == 2  //  Nao Imprime valor Financeiro
		nValliq -=	(E5_VLJUROS + E5_VLMULTA + E5_VLCORRE - E5_VLDESCO)
	Endif
	If E5_TIPODOC == "VM" // Correcao Monetaria

		If E5_VALOR > 0
			cTipo  := "C"
		Else
			If E5_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG
				cTipo  := "D"			
			Else
				cTipo  := "C"			
			Endif			
		Endif

		GravaTrab(cTipo,dEmissao,dVencto,nValliq,aDados,aDadosAbat,,.T.)  // Registro principal
	Else
		GravaTrab("B",dEmissao,dVencto,nValliq,aDados,aDadosAbat,.T.)  // Registro principal
	Endif
	If mv_par06 == 1  // Imprime valor financeiro
		For nX := 1 to 4
			DO CASE
				CASE nX == 1		
					cCampo := "E5_VLJUROS"
					cTipo  := "J"
					aDados[7] := STR0050 //"Juros s/ Baixa"
				CASE nX == 2		
					cCampo := "E5_VLMULTA"
					cTipo  := "M"
					aDados[7] := STR0051 //"Multa s/ Baixa"
				CASE nX == 3		
					cCampo := "E5_VLDESCO"
					cTipo  := "D"
					aDados[7] := STR0052 //"Desconto s/ Baixa"
				CASE nX == 4		
					cCampo := "E5_VLCORRE"
					If &(cCampo) > 0
						cTipo  := "C" //IIF(E5_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVRECANT+"/"+MV_CRNEG,"D","C")
					Else
						cTipo  := "D" //IIF(E5_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVRECANT+"/"+MV_CRNEG,"D","C")
					Endif
					aDados[7] := STR0053 //"C.Monetaria s/ Baixa"
			ENDCASE
			If &(cCampo) > 0 .or. (cCampo == "E5_VLCORRE" .and. &(cCampo) != 0)  //Correcao pode ter valor negativo
				GravaTrab(cTipo,dEmissao,dVencto,&(cCampo),aDados,aDadosAbat,,(cCampo == "E5_VLCORRE"))  // Registro principal	
			Endif
		Next				
	Endif
	dbSelectArea("SE5")
	dbSkip()
End
#IFDEF TOP
	If TcSrvType() != "AS/400"
		DBSelectArea("SE5")
		DbCloseArea()
		ChkFile("SE5")
	Endif
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia rotina de impressao                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("cNomeArq")
If mv_par25 == 2 .OR. mv_par18 == 1	//Se usa filtro por conta ou nao aglutina por loja
	IndRegua("cNomeArq",cNomeArq,"CODIGO+LOJA+Dtos(DATAEM)+Numero",,,OemToAnsi(STR0011))  		//"Selecionando Registros..."
Else 
	If  mv_par21 == 1	//saldo contabil
		//Aglutinado por loja. A conta contabil precede a loja, pois a aglutinacao das lojas somente sera permitida caso as contas sejam iguais
		IndRegua("cNomeArq",cNomeArq,"CODIGO+CONTA+LOJA+DtoS(DATAEM)+Numero",,,OemToAnsi(STR0011))
	Else 
		IndRegua("cNomeArq",cNomeArq,"CODIGO+LOJA+Dtos(DATAEM)+Numero",,,OemToAnsi(STR0011))
	Endif
Endif
dbGoTop()
nTotDebG := 0
nTotCrdG := 0
nSalAtuG := 0

SetRegua(RecCount())

Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
m_pag := 1
li := 8

While !Eof()
	//Se o parametro de filtro por conta contabil estiver marcado como SIM, a opcao de aglutinar por loja sera desconsiderado
	IF lEnd
		@Prow()+1,0 PSAY OemToAnsi(STR0014) //"***** Cancelado pelo Operador *****"
		Exit
	End
	If mv_par25 == 2 .OR. mv_par18 == 1

		cCodigo  := CODIGO
		cLoja    := LOJA
		nSaldoAtu:= 0
		nTotDeb     := 0
		nTotCrd  := 0
		
		If li > nTamSalto
			IF m_pag > mv_par17
				m_pag := 2
			Endif
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
			li := 8
		Endif
    	
		nRegAtu := RecNo()
		lImprime := .F.
		
		While cNomeArq->CODIGO == cCodigo .And. cNomeArq->LOJA == cLoja .And. ! Eof()
			
			If DATAEM >= mv_par01     // Procura titulos no intervalo e
				lImprime := .T.     // se houver, dever  imprimir
				Exit
			Endif
			dbSkip()
		Enddo
		dbGoto(nRegAtu)
		aSdoContabil := {} // Saldo da conta contabil do fornecedor
		cConta := ""
		While cNomeArq->CODIGO == cCodigo .And. cNomeArq->LOJA == cLoja .And. ! Eof()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Loop para calculo do saldo anterior                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While cNomeArq->CODIGO == cCodigo .And. cNomeArq->LOJA == cLoja .And.;
				cNomeArq->DATAEM < mv_par01 .And. ! Eof() .And. (mv_par22 == 1 .or. lImprime)
				If DC == "C"
					nSaldoAtu += ABS(cNomeArq->VALOR)
				Else
					nSaldoAtu -= ABS(cNomeArq->VALOR)
				EndIf
			
				IncRegua()
			
				dbSkip()
				If cNomearq->CODIGO != ccodigo .Or. cNomeArq->LOJA != cLoja
					lNoSkip := .T.
				Endif
			Enddo
			
			If lImprime .Or. nSaldoAtu != 0
				If li > nTamSalto
					IF m_pag > 1
						li++
						@ li,092 PSAY OemToAnsi(STR0015)  //"A TRANSPORTAR : "
						@ li,116 PSAY Abs(nSaldoAtu)    Picture tm(Abs(nSaldoAtu),14)
						@ li,131 PSAY Eval(bBlockDC,nSaldoAtu)
					Endif
					
					IF m_pag > mv_par17
						m_pag := 2
					Endif
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
					li := 8
					
					If nQuebra == 1
						If mv_par03==1
							dbSelectArea("SA1")
							If mv_par10 = 1
								dbSeek(xFilial()+cCodigo+cLoja)
							Else
								If cIndA1 == " "
									cArqTrab :=CriaTrab(NIL,.F.)
									AADD(aInd,cArqTrab)
									cIndA1   :=IndexKey()
									cIndA1   :=Right(cIndA1,Len(cIndA1)-10)
									IndRegua("SA1",cArqTrab,cIndA1,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
									dbCommit()
									nIndex:=RetIndex("SA1")
									dbSelectArea("SA1")
									#IFNDEF TOP
										dbSetIndex(cArqTrab+OrdBagExt())
									#ENDIF
									dbSetOrder(nIndex+1)
								EndIf
								dbSeek(cCodigo+cLoja)
							EndIf
							If mv_par14 == 1  // Analitico
								cNome := SA1->A1_NOME+" "+SA1->A1_CGC+" "+SA1->A1_CONTA
							Else
								cNome := Substr(SA1->A1_NOME,1,33)+" "+IIF(mv_par18 == 1,SA1->A1_CONTA,SA1->A1_CGC)
							Endif
							cConta := SA1->A1_CONTA
							If mv_par21 ==1 .And. Empty(aSdoContabil) .And. !Empty(SA1->A1_CONTA)
								// Obtem o saldo da conta do fornecedor
								aSdoContabil := SdoContabil(SA1->A1_CONTA,MV_PAR02,"01","1")	
							Endif	
						Else
							dbSelectArea("SA2")
							If mv_par10 = 1
								dbSeek(xFilial()+cCodigo+cLoja)
							Else
								If cIndA2 == " "
									cArqTrab :=CriaTrab(NIL,.F.)
									AADD(aInd,cArqTrab)
									cIndA2   :=IndexKey()
									cIndA2   :=Right(cIndA2,Len(cIndA2)-10)
									IndRegua("SA2",cArqTrab,cIndA2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
									dbCommit()
									nIndex:=RetIndex("SA2")
									dbSelectArea("SA2")
									#IFNDEF TOP
										dbSetIndex(cArqTrab+ordBagExt())
									#ENDIF
									dbSetOrder(nIndex+1)
								EndIf
								dbSeek(cCodigo+cLoja)
							EndIf
							If mv_par14 == 1  // Analitico
								cNome := SA2->A2_NOME+" "+SA2->A2_CGC+" "+SA2->A2_CONTA
							Else
								cNome := Substr(SA2->A2_NOME,1,33)+" "+IIF(mv_par18 == 1,SA2->A2_CONTA,SA2->A2_CGC)
							Endif
							cConta := SA2->A2_CONTA
							If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(SA2->A2_CONTA)
								// Obtem o saldo da conta do fornecedor
								aSdoContabil := SdoContabil(SA2->A2_CONTA,MV_PAR02,"01","1")	
							Endif	
						EndIF
						
						If cPaisLoc == 'BRA'
							If mv_par14 == 1   // Analitico
								@li,000 PSAY cCodigo + "-" + cLoja + " " + cNome
								li++
								@li,092 PSAY OemToAnsi(STR0028)  //"DE TRANSPORTE : "
								@li,116 PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),14)
								@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
								li++	
							Endif
						Else  //If cPaisLoc == "ARG"
							If mv_par03 == 1
								SA1->( dbSetOrder(1) )
								SA1->( dbSeek(xFilial("SA1")+cCodigo+cLoja) )
							Else
								SA2->( dbSetOrder(1) )
								SA2->( dbSeek(xFilial("SA2")+cCodigo+cLoja) )
							Endif
							
							@li,000 PSAY If(mv_par03==1,Subs(SA1->A1_NOME,1,40),Subs(SA2->A2_NOME,1,40) )
							@li,050 PSAY cCodigo + "-" + cLoja
							@li,092 PSAY OemToAnsi(STR0028)  //"TRANSPORTAR : "
							@li,116 PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),14)
							@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
							li++
							
							//cTipoCli := TABELA("SF",SA1->A1_TIPO,.T.)                                     
							cPosTp := aScan( aTipoCli, {|x| Subs(x,1,1) == If(mv_par03==1,SA1->A1_TIPO,SA2->A2_TIPO)  } )
							cTipoCli := Iif( cPosTp>0 , aTipoCli[cPosTp] , "" )
							
							SX5->( dbSetOrder(1) )
							SX5->( dbSeek(xFilial("SX5")+"12"+If(mv_par03==1,SA1->A1_EST,SA2->A2_EST)) )
							
							If mv_par03 == 1
								@li,000 PSAY SA1->A1_END
								@li,050 PSAY "Te: "+Subs(Alltrim(SA1->A1_TEL),1,36)
								@li,092 PSAY OemToAnsi(STR0038)+SA1->A1_VEND   //"VENDEDOR: "
								li++
								@li,000 PSAY SA1->A1_CEP+" - " + SA1->A1_MUN
								If SX5->( Found() ) .or. !Empty(X5Descri())
									@li,092 PSAY AllTrim(X5Descri())     // Diego
								EndIf
								li++
								@li,000 PSAY cTipoCli
								@li,050 PSAY Trans(SA1->A1_CGC,PesqPict("SA1","A1_CGC"))
								li+=2
							Else
								@li,000 PSAY SA2->A2_END
								@li,050 PSAY "Te: "+ Subs(Alltrim(SA2->A2_TEL),1,36)
								@li,092 PSAY OemToAnsi(STR0039)  //"COMPRADOR: "
								li++
								@li,000 PSAY SA2->A2_CEP+" - " +SA2->A2_MUN
								If SX5->( Found() ) .or. !Empty(X5Descri())
									@li,092 PSAY AllTrim(X5Descri())    // Diego
								Endif
								li++
								@li,000 PSAY cTipoCli
								@li,050 PSAY Trans(SA2->A2_CGC,PesqPict("SA2","A2_CGC"))
								li+=2
							EndIf
						EndIf
					EndIf
				Endif
			EndIf
		
			If nQuebra == 0 .and. (lImprime .Or. nSaldoAtu != 0 )
				nQuebra  := 1
				lImprAnt := .F.
				IF mv_par03 == 1
					dbSelectArea("SA1")
					If mv_par10 = 1
						dbSeek(xFilial()+cCodigo+cLoja)
					Else
						If cIndA1 == " "
							cArqTrab :=CriaTrab(NIL,.F.)
							AADD(aInd,cArqTrab)
							cIndA1   :=IndexKey()
							cIndA1   :=Right(cIndA1,Len(cIndA1)-10)
							IndRegua("SA1",cArqTrab,cIndA1,,,STR0011 )  //"Selecionando Registros..."
							dbCommit()
							nIndex:=RetIndex("SA1")
							dbSelectArea("SA1")
							#IFNDEF TOP
								dbSetIndex(cArqTrab+OrdBagEXt())
							#ENDIF
							dbSetOrder(nIndex+1)
						EndIf
						dbSeek(cCodigo+cLoja)
					EndIf
					If mv_par14 == 1  // Analitico
						cNome := SA1->A1_NOME+" "+SA1->A1_CGC+" "+SA1->A1_CONTA
					Else
						cNome := Substr(SA1->A1_NOME,1,33)+" "+IIF(mv_par18 == 1,SA1->A1_CONTA,SA1->A1_CGC)
					Endif
					cConta := SA1->A1_CONTA
					If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(SA1->A1_CONTA)
						// Obtem o saldo da conta do fornecedor
						aSdoContabil := SdoContabil(SA1->A1_CONTA,MV_PAR02,"01","1")	
					Endif	
				Else
					dbSelectArea("SA2")
					If mv_par10 = 1
						dbSeek(xFilial()+cCodigo+cLoja)
					Else
						If cIndA2 == " "
							cArqTrab :=CriaTrab(NIL,.F.)
							AADD(aInd,cArqTrab)
							cIndA2   :=IndexKey()
							cIndA2   :=Right(cIndA2,Len(cIndA2)-10)
							IndRegua("SA2",cArqTrab,cIndA2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
							dbCommit()
							nIndex:=RetIndex("SA2")
							dbSelectArea("SA2")
							#IFNDEF TOP
								dbSetIndex(cArqTrab+OrdBagExt())
							#ENDIF
							dbSetOrder(nIndex+1)
						EndIf
						dbSeek(cCodigo+cLoja)
					EndIf
					If mv_par14 == 1  // Analitico
						cNome := SA2->A2_NOME+" "+SA2->A2_CGC+" "+SA2->A2_CONTA
					Else
						cNome := Substr(SA2->A2_NOME,1,33)+" "+IIF(mv_par18 == 1,SA2->A2_CONTA,SA2->A2_CGC)
					Endif
					cConta := SA2->A2_CONTA
					If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(SA2->A2_CONTA)
						// Obtem o saldo da conta do fornecedor
						aSdoContabil := SdoContabil(SA2->A2_CONTA,MV_PAR02,"01","1")	
					Endif	
				EndIF
				
				If cPaisLoc == "BRA"
					If mv_par14 == 1  // Analitico
						@li,000 PSAY cCodigo + "-" + cLoja + " " + cNome
						dbSelectArea("cNomeArq")
						li++
						@li, 92 PSAY OemToAnsi(STR0016)  //"SALDO ANTERIOR : "
						@li,116 PSAY Abs(nSaldoAtu)     Picture tm(Abs(nSaldoAtu),14)
						@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
						nSalAntG += nSaldoAtu
						li++
					Else
						@li,000 PSAY Substr(cCodigo + "-" + cLoja + " " + cNome,1,64)
						@li,066 PSAY Abs(nSaldoAtu)     Picture tm(Abs(nSaldoAtu),14)
						@li,081 PSAY Eval(bBlockDC,nSaldoAtu)
						nSalAntG += nSaldoAtu
					Endif	
				Else  //If cPaisLoc == "ARG" // MariSol Argentina Jose Lucas 17/04/99
					
					If mv_par03 == 1
						SA1->( dbSetOrder(1) )
						SA1->( dbSeek(xFilial("SA1")+cCodigo+cLoja) )
					Else
						SA2->( dbSetOrder(1) )
						SA2->( dbSeek(xFilial("SA2")+cCodigo+cLoja) )
					Endif
						
					@li,000 PSAY If(mv_par03==1,Subs(SA1->A1_NOME,1,40),Subs(SA2->A2_NOME,1,40) )
					@li,050 PSAY cCodigo + "-" + cLoja
					@li,092 PSAY OemToAnsi(STR0016)  //"SALDO ANTERIOR : "
					@li,116 PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),14)
					@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
					nSalAntG += nSaldoAtu
					li+=2
					
					//cTipoCli := TABELA("SF",SA1->A1_TIPO,.T.)
					cPosTp := aScan( aTipoCli, {|x| Subs(x,1,1) == Iif(mv_par03==1,SA1->A1_TIPO,SA2->A2_TIPO)  } )
					cTipoCli := Iif( cPosTp>0 , aTipoCli[cPosTp] , "" )
					
					SX5->( dbSetOrder(1) )
					SX5->( dbSeek(xFilial("SX5")+"12"+If(mv_par03==1,SA1->A1_EST,SA2->A2_EST)) )
				
					If mv_par03 == 1
						@li,000 PSAY SA1->A1_END
						@li,050 PSAY "Te: "+Subs(Alltrim(SA1->A1_TEL),1,36)
						@li,092 PSAY OemToAnsi(STR0038)+SA1->A1_VEND  // "VENDEDOR : "
						li++
						@li,000 PSAY SA1->A1_CEP+" - " +SA1->A1_MUN
						If SX5->( Found() ) .or. !Empty(X5Descri())
							@li,092 PSAY AllTrim(X5Descri())   // Diego
						EndIf
						li++
						@li,000 PSAY cTipoCli
						@li,050 PSAY Trans(SA1->A1_CGC,PesqPict("SA1","A1_CGC"))
						li+=2
					Else
						@li,000 PSAY SA2->A2_END
						@li,050 PSAY "Te: "+Subs(Alltrim(SA2->A2_TEL),1,36)
						@li,092 PSAY OemToAnsi(STR0039) // "COMPRADOR: "
						li++
						@li,000 PSAY SA2->A2_CEP+" - " +SA2->A2_MUN
						If SX5->( Found() ) .or. !Empty(X5Descri())
							@li,092 PSAY AllTrim(X5Descri())  // Diego
						EndIf
						li++
						@li,000 PSAY cTipoCli
						@li,050 PSAY Trans(SA2->A2_CGC,PesqPict("SA2","A2_CGC"))
						li+=2
					EndIf
				EndIf
			End
			dbSelectArea("cNomeArq")
			
			If cNomeArq->DATAEM >= mv_par01 .And. !lNoSkip
				If DC == "D"
					nSaldoAtu -= ABS(cNomeArq->VALOR)
					nTotDeb   += ABS(cNomeArq->VALOR)
					nTotDebG  += ABS(cNomeArq->VALOR)
					nSalAtuG  -= ABS(cNomeArq->VALOR)
				Else
					nSaldoAtu += ABS(cNomeArq->VALOR)
					nTotCrd   += ABS(cNomeArq->VALOR)
					nTotCrdG  += ABS(cNomeArq->VALOR)
					nSalAtuG  += ABS(cNomeArq->VALOR)
				End
				If mv_par14 == 1  // Analitico
					li++
					@li,000 PSAY DATAEM
					If mv_par24 = 1 .Or. Len(Trim(HISTOR)) <= 20
						If OemToAnsi(STR0040)$ HISTOR  //"Recibo"/"Receipt"
							@li,011 PSAY Substr(HISTOR, At(OemToAnsi(STR0040),HISTOR),20)
						Else
							@li,011 PSAY SubStr(HISTOR,1,20)
						EndIf
					EndIf
					@li,033 PSAY SubStr(NUMERO, 1,3)
					@li,037 PSAY SubStr(NUMERO, 4,nTamNro)
					@li,051 PSAY SubStr(NUMERO,nTamNro+4,nTamParc)
					@li,055 PSAY EMISSAO
					@li,066 PSAY VENCTO
					IF !Empty(BAIXA)
						@li,077 PSAY BAIXA
					End
					@li,IIF(DC=="D",88,102) PSAY ABS(cNomeArq->VALOR) PicTure tm(cNomeArq->VALOR,13)
					@li,116 PSAY Abs(nSaldoAtu)      Picture tm(Abs(nSaldoAtu),14)
					@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
					If mv_par24 = 2 .And. Len(Trim(HISTOR)) > 20
						li++
						@li,011 PSAY HISTOR
					EndIf
				Endif
			End
			lFlag := .T.
			If ! lNoSkip
				IncRegua()
				dbSkip( )
			End
			lNoSkip := .F.
		End                        

	Else 

		cCodigo  := CODIGO
		cLoja    := ""
		nSaldoAtu:= 0
		nTotDeb     := 0
		nTotCrd  := 0
		
		If li > nTamSalto
			IF m_pag > mv_par17
				m_pag := 2
			Endif
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
			li := 8
		Endif
		nRegAtu 	:= cNomeArq->(Recno())
		lImprime := .F.
		While !cNomeArq->(Eof()) .AND. cNomeArq->CODIGO == cCodigo 
			If DATAEM >= mv_par01     // Procura titulos no intervalo e
				lImprime := .T.     // se houver, dever  imprimir
				Exit
			Endif
			dbSkip()
		Enddo
		dbGoto(nRegAtu)
		aSdoContabil := {} // Saldo da conta contabil do fornecedor
		cConta := ""
		cCtContAnt := cNomeArq->CONTA
		While !cNomeArq->(Eof()) .AND. cNomeArq->CODIGO == cCodigo 
			If mv_par21 == 1 .AND. (mv_par22 == 1 .OR. lImprime)
				//Pesquisar se o cliente / fornecedor esta utilizando um conta diferente entre as lojas
				If FR550RetCF(cCodigo, cNomeArq->LOJA, IIf(mv_par03 == 1,"A1_CONTA","A2_CONTA")) # cCtContAnt
					//Sair
					Exit
				Endif
			Endif
			cCtContAnt := cNomeArq->CONTA

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Loop para calculo do saldo anterior                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While !cNomeArq->(Eof()) .AND. cNomeArq->CODIGO == cCodigo .And. ;
				cNomeArq->DATAEM < mv_par01 .And. (mv_par22 == 1 .or. lImprime)
				If DC == "C"
					nSaldoAtu += ABS(cNomeArq->VALOR)
				Else
					nSaldoAtu -= ABS(cNomeArq->VALOR)
				EndIf                                
				cCtContAnt := cNomeArq->CONTA
				IncRegua()
				cNomeArq->(dbSkip())
				If cNomearq->CODIGO != cCodigo
					lNoSkip := .T.
				Else
					If mv_par21 == 1
						//Pesquisar se o cliente / fornecedor esta utilizando um conta diferente entre as lojas
						If FR550RetCF(cCodigo, cNomeArq->LOJA, IIf(mv_par03 == 1,"A1_CONTA","A2_CONTA")) # cCtContAnt
							lNoSkip := .T.
						Endif
					Endif
				Endif
			Enddo
			
			If lImprime .Or. nSaldoAtu != 0
				If li > nTamSalto
					IF m_pag > 1
						li++
						@ li,092 PSAY OemToAnsi(STR0015)  //"A TRANSPORTAR : "
						@ li,116 PSAY Abs(nSaldoAtu)    Picture tm(Abs(nSaldoAtu),14)
						@ li,131 PSAY Eval(bBlockDC,nSaldoAtu)
					Endif
					
					IF m_pag > mv_par17
						m_pag := 2
					Endif
					Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
					li := 8
					
					If nQuebra == 1
						If mv_par03==1
							dbSelectArea("SA1")
							If cIndA1 == " "
								cArqTrab :=CriaTrab(NIL,.F.)
								AADD(aInd,cArqTrab)
								cIndA1   :=IndexKey()
								If mv_par21 == 1
									cIndA1   :=Right(cIndA1,Len(cIndA1)-IIf(mv_par10==1,0,10))+"+A1_CONTA"  //Indice de pesquisa sem filial
								Else
									cIndA1   :=Right(cIndA1,Len(cIndA1)-IIf(mv_par10==1,0,10))	//Indice de pesquisa sem filial
								Endif
								IndRegua("SA1",cArqTrab,cIndA1,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
								dbCommit()
								nIndex:=RetIndex("SA1")
								dbSelectArea("SA1")
								#IFNDEF TOP
									dbSetIndex(cArqTrab+OrdBagExt())
								#ENDIF
								dbSetOrder(nIndex+1)
							EndIf
							If mv_par21 == 1
								SA1->(dbSeek(IIf(mv_par10==1,xFilial("SA1"),"") + cCodigo + cNomeArq->LOJA + cCtContAnt))
							Else
								SA1->(dbSeek(IIf(mv_par10==1,xFilial("SA1"),"") + cCodigo))
							Endif
							If mv_par21 == 1
								If mv_par14 == 1  // Analitico
									cNome := SA1->A1_NOME+" "+SA1->A1_CGC+" "+cCtContAnt
								Else
									cNome := Substr(SA1->A1_NOME,1,33)+" "+IIF(mv_par18 == 1,cCtContAnt,SA1->A1_CGC)
								Endif
							Else
								If mv_par14 == 1  // Analitico
									cNome := SA1->A1_NOME+" "+SA1->A1_CGC
								Else
									cNome := Substr(SA1->A1_NOME,1,33)+" "+SA1->A1_CGC
								Endif							
							Endif

							cConta := SA1->A1_CONTA
							If mv_par21 ==1 .And. Empty(aSdoContabil) .And. !Empty(cCtContAnt)
								// Obtem o saldo da conta do fornecedor
								aSdoContabil := SdoContabil(cCtContAnt,MV_PAR02,"01","1")	
							Endif	
						Else
							dbSelectArea("SA2")
							If cIndA2 == " "
								cArqTrab :=CriaTrab(NIL,.F.)
								AADD(aInd,cArqTrab)
								cIndA2   :=IndexKey()
								If mv_par21 == 1
									cIndA2 := Right(cIndA2,Len(cIndA2)-IIf(mv_par10==1,0,10)) + "+A2_CONTA"
								Else
									cIndA2 := Right(cIndA2,Len(cIndA2)-IIf(mv_par10==1,0,10))
								Endif
								IndRegua("SA2",cArqTrab,cIndA2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
								dbCommit()
								nIndex:=RetIndex("SA2")
								dbSelectArea("SA2")
								#IFNDEF TOP
									dbSetIndex(cArqTrab+ordBagExt())
								#ENDIF
								dbSetOrder(nIndex+1)
							EndIf
							If mv_par21 == 1
								dbSeek(IIf(mv_par10==1,xFilial("SA2"),"") + cCodigo + cNomeArq->LOJA + cCtContAnt)
							Else
								dbSeek(IIf(mv_par10==1,xFilial("SA2"),"") + cCodigo)
							Endif
							
							If mv_par21 == 1
								If mv_par14 == 1  // Analitico
									cNome := SA2->A2_NOME+" "+SA2->A2_CGC+" "+cCtContAnt
								Else
									cNome := Substr(SA2->A2_NOME,1,33)+" "+IIF(mv_par18 == 1,cCtContAnt,SA2->A2_CGC)
								Endif
							Else
								If mv_par14 == 1  // Analitico
									cNome := SA2->A2_NOME+" "+SA2->A2_CGC
								Else
									cNome := Substr(SA2->A2_NOME,1,33)+" "+SA2->A2_CGC
								Endif
							Endif

							cConta := SA2->A2_CONTA
							If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(cCtContAnt)
								// Obtem o saldo da conta do fornecedor
								aSdoContabil := SdoContabil(cCtContAnt,MV_PAR02,"01","1")	
							Endif	
						EndIF
						
						If cPaisLoc == 'BRA'
							If mv_par14 == 1   // Analitico
								@li,000 PSAY cCodigo + "-" + cNome
								li++
								@li,092 PSAY OemToAnsi(STR0028)  //"DE TRANSPORTE : "
								@li,116 PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),14)
								@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
								li++	
							Endif
						Else  //If cPaisLoc == "ARG"
							If mv_par03 == 1
								SA1->( dbSetOrder(1) )
								SA1->( dbSeek(xFilial("SA1")+cCodigo+cNomeArq->LOJA) )
							Else
								SA2->( dbSetOrder(1) )
								SA2->( dbSeek(xFilial("SA2")+cCodigo+cNomeArq->LOJA) )
							Endif
							
							@li,000 PSAY If(mv_par03==1,Subs(SA1->A1_NOME,1,40),Subs(SA2->A2_NOME,1,40) )
							@li,050 PSAY cCodigo 
							@li,092 PSAY OemToAnsi(STR0028)  //"TRANSPORTAR : "
							@li,116 PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),14)
							@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
							li++
							
							//cTipoCli := TABELA("SF",SA1->A1_TIPO,.T.)                                     
							cPosTp := aScan( aTipoCli, {|x| Subs(x,1,1) == If(mv_par03==1,SA1->A1_TIPO,SA2->A2_TIPO)  } )
							cTipoCli := Iif( cPosTp>0 , aTipoCli[cPosTp] , "" )
							
							SX5->( dbSetOrder(1) )
							SX5->( dbSeek(xFilial("SX5")+"12"+If(mv_par03==1,SA1->A1_EST,SA2->A2_EST)) )
							
							If mv_par03 == 1
								@li,000 PSAY SA1->A1_END
								@li,050 PSAY "Te: "+Subs(Alltrim(SA1->A1_TEL),1,36)
								@li,092 PSAY OemToAnsi(STR0038)+SA1->A1_VEND   //"VENDEDOR: "
								li++
								@li,000 PSAY SA1->A1_CEP+" - " + SA1->A1_MUN
								If SX5->( Found() ) .or. !Empty(X5Descri())
									@li,092 PSAY AllTrim(X5Descri())     // Diego
								EndIf
								li++
								@li,000 PSAY cTipoCli
								@li,050 PSAY Trans(SA1->A1_CGC,PesqPict("SA1","A1_CGC"))
								li+=2
							Else
								@li,000 PSAY SA2->A2_END
								@li,050 PSAY "Te: "+ Subs(Alltrim(SA2->A2_TEL),1,36)
								@li,092 PSAY OemToAnsi(STR0039)  //"COMPRADOR: "
								li++
								@li,000 PSAY SA2->A2_CEP+" - " +SA2->A2_MUN
								If SX5->( Found() ) .or. !Empty(X5Descri())
									@li,092 PSAY AllTrim(X5Descri())    // Diego
								Endif
								li++
								@li,000 PSAY cTipoCli
								@li,050 PSAY Trans(SA2->A2_CGC,PesqPict("SA2","A2_CGC"))
								li+=2
							EndIf
						EndIf
					EndIf
				Endif
			EndIf
		
			If nQuebra == 0 .and. (lImprime .Or. nSaldoAtu != 0 )
				nQuebra  := 1
				lImprAnt := .F.
				IF mv_par03 == 1
					dbSelectArea("SA1")
					If cIndA1 == " " .OR. cIndA1 # SA1->(IndexKey())
						If cIndA1 == " "
							cArqTrab :=CriaTrab(NIL,.F.)
							aAdd(aInd,cArqTrab)
						Endif
						cIndA1 := IndexKey()
						If mv_par21 == 1
							cIndA1 := Right(cIndA1,Len(cIndA1)-IIf(mv_par10 == 1,0,IIf(At("FILIAL",cIndA1)==0,0,10))) + "+A1_CONTA"
						Else
							cIndA1 := Right(cIndA1,Len(cIndA1)-IIf(mv_par10==1,0,IIf(At("FILIAL",cIndA1)==0,0,10)))
						Endif
						IndRegua("SA1",cArqTrab,cIndA1,,,STR0011 )  //"Selecionando Registros..."
						dbCommit()
						nIndex:=RetIndex("SA1")
						dbSelectArea("SA1")
						#IFNDEF TOP
							dbSetIndex(cArqTrab+OrdBagEXt())
						#ENDIF
						dbSetOrder(nIndex+1)
					EndIf
					If mv_par21 == 1
						dbSeek(IIf(mv_par10 == 1,xFilial("SA1"),"") + cCodigo + cNomeArq->LOJA + cCtContAnt)
					Else
						dbSeek(IIf(mv_par10 == 1,xFilial("SA1"),"") + cCodigo)
					Endif

					If mv_par21 == 1
						If mv_par14 == 1  // Analitico
							cNome := SA1->A1_NOME+" "+SA1->A1_CGC+" "+cCtContAnt
						Else
							cNome := Substr(SA1->A1_NOME,1,33)+" "+IIF(mv_par18 == 1,cCtContAnt,SA1->A1_CGC)
						Endif
					Else 
						If mv_par14 == 1  // Analitico
							cNome := SA1->A1_NOME+" "+SA1->A1_CGC
						Else	
							cNome := Substr(SA1->A1_NOME,1,33)+" "+SA1->A1_CGC
						Endif
					Endif

					cConta := SA1->A1_CONTA
					If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(cCtContAnt)
						// Obtem o saldo da conta do fornecedor
						aSdoContabil := SdoContabil(cCtContAnt,MV_PAR02,"01","1")	
					Endif	
				Else
					dbSelectArea("SA2")
					If cIndA2 == " " .OR. cIndA2 # SA2->(IndexKey())
						If cIndA2 == " "
							cArqTrab :=CriaTrab(NIL,.F.)
							aAdd(aInd,cArqTrab)
						Endif
						cIndA2 := IndexKey()
						If mv_par21 == 1
							cIndA2 := Right(cIndA2,Len(cIndA2)-IIf(mv_par10==1,0,IIf(At("FILIAL",cIndA2)==0,0,10))) + "+A2_CONTA"
						Else
							cIndA2 := Right(cIndA2,Len(cIndA2)-IIf(mv_par10==1,0,IIf(At("FILIAL",cIndA2)==0,0,10)))
						Endif
						IndRegua("SA2",cArqTrab,cIndA2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
						dbCommit()
						nIndex:=RetIndex("SA2")
						dbSelectArea("SA2")
						#IFNDEF TOP
							dbSetIndex(cArqTrab+OrdBagExt())
						#ENDIF
						dbSetOrder(nIndex+1)
					EndIf
					If mv_par21 == 1
						dbSeek(IIf(mv_par10==1,xFilial("SA2"),"")+cCodigo + cNomeArq->LOJA + cCtContAnt)
					Else
						dbSeek(IIf(mv_par10==1,xFilial("SA2"),"")+cCodigo)
					Endif

					If mv_par21 == 1
						If mv_par14 == 1  // Analitico
							cNome := SA2->A2_NOME+" "+SA2->A2_CGC+" "+cCtContAnt
						Else
							cNome := Substr(SA2->A2_NOME,1,33)+" "+IIF(mv_par18 == 1,cCtContAnt,SA2->A2_CGC)
						Endif
					Else 
						If mv_par14 == 1  // Analitico
							cNome := SA2->A2_NOME+" "+SA2->A2_CGC
						Else
							cNome := Substr(SA2->A2_NOME,1,33)+" "+SA2->A2_CGC
						Endif
					Endif
					cConta := SA2->A2_CONTA
					If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(cCtContAnt)
						// Obtem o saldo da conta do fornecedor
						aSdoContabil := SdoContabil(cCtContAnt,MV_PAR02,"01","1")	
					Endif	
				EndIF
				
				If cPaisLoc == "BRA"
					If mv_par14 == 1  // Analitico
						@li,000 PSAY cCodigo + "-" + cNome
						dbSelectArea("cNomeArq")
						li++
						@li, 92 PSAY OemToAnsi(STR0016)  //"SALDO ANTERIOR : "
						@li,116 PSAY Abs(nSaldoAtu)     Picture tm(Abs(nSaldoAtu),14)
						@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
						nSalAntG += nSaldoAtu
						li++
					Else
						@li,000 PSAY Substr(cCodigo + "-" + cLoja + " " + cNome,1,64)
						@li,066 PSAY Abs(nSaldoAtu)     Picture tm(Abs(nSaldoAtu),14)
						@li,081 PSAY Eval(bBlockDC,nSaldoAtu)
						nSalAntG += nSaldoAtu
					Endif	
				Else  //If cPaisLoc == "ARG" // MariSol Argentina Jose Lucas 17/04/99
					
					If mv_par03 == 1
						SA1->( dbSetOrder(1) )
						SA1->( dbSeek(xFilial("SA1")+cCodigo+cNomeArq->LOJA) )
					Else
						SA2->( dbSetOrder(1) )
						SA2->( dbSeek(xFilial("SA2")+cCodigo+cNomeArq->LOJA) )
					Endif
						
					@li,000 PSAY If(mv_par03==1,Subs(SA1->A1_NOME,1,40),Subs(SA2->A2_NOME,1,40) )
					@li,050 PSAY cCodigo + "-" + cLoja
					@li,092 PSAY OemToAnsi(STR0016)  //"SALDO ANTERIOR : "
					@li,116 PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),14)
					@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
					nSalAntG += nSaldoAtu
					li+=2
					
					//cTipoCli := TABELA("SF",SA1->A1_TIPO,.T.)
					cPosTp := aScan( aTipoCli, {|x| Subs(x,1,1) == Iif(mv_par03==1,SA1->A1_TIPO,SA2->A2_TIPO)  } )
					cTipoCli := Iif( cPosTp>0 , aTipoCli[cPosTp] , "" )
					
					SX5->( dbSetOrder(1) )
					SX5->( dbSeek(xFilial("SX5")+"12"+If(mv_par03==1,SA1->A1_EST,SA2->A2_EST)) )
				
					If mv_par03 == 1
						@li,000 PSAY SA1->A1_END
						@li,050 PSAY "Te: "+Subs(Alltrim(SA1->A1_TEL),1,36)
						@li,092 PSAY OemToAnsi(STR0038)+SA1->A1_VEND  // "VENDEDOR : "
						li++
						@li,000 PSAY SA1->A1_CEP+" - " +SA1->A1_MUN
						If SX5->( Found() ) .or. !Empty(X5Descri())
							@li,092 PSAY AllTrim(X5Descri())   // Diego
						EndIf
						li++
						@li,000 PSAY cTipoCli
						@li,050 PSAY Trans(SA1->A1_CGC,PesqPict("SA1","A1_CGC"))
						li+=2
					Else
						@li,000 PSAY SA2->A2_END
						@li,050 PSAY "Te: "+Subs(Alltrim(SA2->A2_TEL),1,36)
						@li,092 PSAY OemToAnsi(STR0039) // "COMPRADOR: "
						li++
						@li,000 PSAY SA2->A2_CEP+" - " +SA2->A2_MUN
						If SX5->( Found() ) .or. !Empty(X5Descri())
							@li,092 PSAY AllTrim(X5Descri())  // Diego
						EndIf
						li++
						@li,000 PSAY cTipoCli
						@li,050 PSAY Trans(SA2->A2_CGC,PesqPict("SA2","A2_CGC"))
						li+=2
					EndIf
				EndIf
			EndIf
			dbSelectArea("cNomeArq")
			If cNomeArq->DATAEM >= mv_par01 .And. !lNoSkip
				If DC == "D"
					nSaldoAtu -= ABS(cNomeArq->VALOR)
					nTotDeb   += ABS(cNomeArq->VALOR)
					nTotDebG  += ABS(cNomeArq->VALOR)
					nSalAtuG  -= ABS(cNomeArq->VALOR)
				Else
					nSaldoAtu += ABS(cNomeArq->VALOR)
					nTotCrd   += ABS(cNomeArq->VALOR)
					nTotCrdG  += ABS(cNomeArq->VALOR)
					nSalAtuG  += ABS(cNomeArq->VALOR)
				End
				If mv_par14 == 1  // Analitico
					li++
					@li,000 PSAY DATAEM
					If mv_par24 = 1 .Or. Len(Trim(HISTOR)) <= 20
						If OemToAnsi(STR0040)$ HISTOR  //"Recibo"/"Receipt"
							@li,011 PSAY Substr(HISTOR, At(OemToAnsi(STR0040),HISTOR),20)
						Else
							@li,011 PSAY SubStr(HISTOR,1,20)
						EndIf
					EndIf
					@li,033 PSAY SubStr(NUMERO, 1,3)
					@li,037 PSAY SubStr(NUMERO, 4,nTamNro)
					@li,051 PSAY SubStr(NUMERO,nTamNro+4,nTamParc)
					@li,055 PSAY EMISSAO
					@li,066 PSAY VENCTO
					IF !Empty(BAIXA)
						@li,077 PSAY BAIXA
					End
					@li,IIF(DC=="D",88,102) PSAY ABS(cNomeArq->VALOR) PicTure tm(cNomeArq->VALOR,13)
					@li,116 PSAY Abs(nSaldoAtu)      Picture tm(Abs(nSaldoAtu),14)
					@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
					If mv_par24 = 2 .And. Len(Trim(HISTOR)) > 20
						li++
						@li,011 PSAY HISTOR
					EndIf
				Endif
			End
			lFlag := .T.
			If ! lNoSkip
				IncRegua()
				dbSkip( )
			End
			lNoSkip := .F.
		End               
	
	Endif	

	If lImprime .Or. nSaldoAtu != 0
		If mv_par14 == 1		// Analitico		
			li+= 2
			@li,  0 PSAY OemToAnsi(STR0017)+IIF(mv_par03==1,OemToAnsi(STR0018),OemToAnsi(STR0019))  //"T o t a i s  d o  "###"C l i e n t e"###"F o r n e c e d o r"
		Endif
		@li, 88 PSAY nTotDeb                Picture tm(nTotDeb,13)
		@li,102 PSAY nTotCrd                Picture tm(nTotCrd,13)
		@li,116 PSAY Abs(nSaldoAtu)     Picture tm(Abs(nSaldoAtu),14)
		@li,131 PSAY Eval(bBlockDC,nSaldoAtu)
		If mv_par21 == 1 .And. !Empty(aSdoContabil)
			li+=2
			// Verifica se deve imprimir o total da conta contabil do fornecedor
			
			cLoja := ""
			If FR550TotCta(cCtContAnt, cCodigo, cLoja ) .OR. (mv_par25 == 1 .AND. mv_par21 == 1) // Retorna se o saldo deve ser impresso 
				@li,0 PSAY STR0046+IIF(mv_par03==1,OemToAnsi(STR0018),OemToAnsi(STR0019)) + If(!Empty(cCtContAnt)," ("+cCtContAnt+")","") // //"T o t a i s  d o  c o n t a"###"C l i e n t e"###"F o r n e c e d o r"
				@li, 88 PSAY Abs(aSdoContabil[4])			Picture tm(aSdoContabil[4],13)
				@li,102 PSAY Abs(aSdoContabil[5])			Picture tm(aSdoContabil[5],13)
				@li,116 PSAY Abs(aSdoContabil[1]) 			Picture tm(aSdoContabil[1],14)
				@li,131 PSAY Eval(bBlockDC,aSdoContabil[1])
			EndIf	
		Endif	
		li++
		If mv_par14 == 1
			@li,  0  PSAY Repl("-",132)
			li++
		Endif
	Endif
	nQuebra:=0
EndDo

If nQuebra # 0 .and.(lImprime .Or. nSaldoAtu != 0)
	If mv_par14 == 1		// Analitico		
		li+= 2
		@li,  0 PSAY OemToAnsi(STR0017)+IIF(mv_par03==1,OemToAnsi(STR0018),OemToAnsi(STR0019))  //"T o t a i s  d o  "###"C l i e n t e"###"F o r n e c e d o r"
	Endif
	@li, 88  PSAY nTotDeb                    Picture tm(nTotDeb,13)
	@li,102  PSAY nTotCrd                    Picture tm(nTotCrd,13)
	@li,116  PSAY Abs(nSaldoAtu)     Picture tm(Abs(nSaldoAtu),14)
	@li,131  PSAY Eval(bBlockDC,nSaldoAtu)
End
If lFlag
	li++
	IF li > nTamSalto
		IF m_pag > mv_par17
			m_pag := 2
		Endif
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
		li:=8
	End
	@li, 000 PSAY Repl("-",132)
	li++
	@li, 000 PSAY OemToAnsi(STR0020)+IIF(mv_par03==1,OemToAnsi(STR0021),OemToAnsi(STR0022))  //"T o t a l   G e r a l  d o s  "###"C l i e n t e s"###"F o r n e c e d o r e s"
	@li, 066 PSAY nSalAntG 	 		Picture tm(nSalAntG,14)
	@li, 081 PSAY Eval(bBlockDC,nSalAntG)
	@li, 088 PSAY nTotDebG			Picture tm(nTotDebG,13)
	@li, 102 PSAY nTotCrdG			Picture tm(nTotCrdG,13)
	nSaldoFinal := (nSalAntG-nTotDebG+nTotCrdG)
	@li, 116 PSAY Abs(nSaldoFinal)  Picture tm(Abs(nSaldoFinal),14)
	@li ,131 PSAY Eval(bBlockDC,nSaldoFinal)

	li+=2
	@li, 000 PSAY Repl("-",132)
	li++
	@li, 000 PSAY OemToAnsi(STR0023)  //"S a l d o   F i n a l   d o   R e l a t o r i o : "
	nSaldoFinal := (nSalAntG-nTotDebG+nTotCrdG)
	@li, 116 PSAY Abs(nSaldoFinal)  Picture tm(Abs(nSaldoFinal),14)
	@li ,131 PSAY Eval(bBlockDC,nSaldoFinal)
	li++
	@li, 000 PSAY Repl("-",132)
End
dbSelectArea("cNomeArq")
Use
Ferase(cNomeArq+GetDBExtension())         // Elimina arquivos de Trabalho
Ferase(cNomeArq+OrdBagExt())    // Elimina arquivos de Trabalho

dbSelectArea("SA1")
RetIndex("SA1")
dbSetOrder(1)
Set Filter To

dbSelectArea("SA2")
RetIndex("SA2")
dbSetOrder(1)
Set Filter To

#IFDEF TOP
	If TcSrvType() != "AS/400"
		dbSelectArea("SE1")
		dbCloseArea()
		ChKFile("SE1")
		dbSelectArea("SE1")
		dbSetOrder(1)
		
		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSelectArea("SE2")
		dbSetOrder(1)
		
		dbSelectArea("SE5")
		dbCloseArea()
		ChKFile("SE5")
		dbSelectArea("SE5")
		dbSetOrder(1)
	Else
#ENDIF
	dbSelectArea("SE1")
	RetIndex("SE1")
	dbSetOrder(1)
	Set Filter To
	
	dbSelectArea("SE2")
	RetIndex("SE2")
	dbSetOrder(1)
	Set Filter To
	
	dbSelectArea("SE5")
	RetIndex("SE5")
	dbSetOrder(1)
	Set Filter To
#IFDEF TOP
	EndIF
#ENDIF                   

NEWSE5->(dbCloseArea())

For nI:=1 to Len(aInd)
	If File(aInd[nI]+OrdBagExt())
		fErase(aInd[nI]+OrdBagExt())
		fErase(aInd[nI]+GetDbExtension())
	Endif
Next
Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	dbCommitall()
	Ourspool(wnrel)
Endif
MS_FLUSH()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GravaTrab ³ Autor ³ Wagner Xavier         ³ Data ³ 25.02.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava um registro no arquivo de trabalho para impressao     ³±±
±±³          ³do Razonete.                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³GravaTrab( ExpC1, ExpD1, ExpD2)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaTrab( cTipo,dEmissao,dVencto,nValor,aDados,aDadosAbat,lPrincipal,lCm)
Local cDCR,cDCP,cAlias:=Alias()
Local nX := 0
Local nY := {}
Local nPos := 0               

//Controla o Pis Cofins e Csll na baixa CP
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default))
Local lPccBxCr			:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
				 
DEFAULT aDadosAbat := {}
DEFAULT lPrincipal := .F.
DEFAULT lCm 		 := .F.

				 
If aDados[3] >= mv_par01 .OR. mv_par15 == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica prefixo caso a movimenta‡„o n„o seja interpretada   ³
	//³ para calculo do saldo anterior ou quando solicitado.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Substr(aDados[4],1,3) < mv_par08 .Or. Substr(aDados[4],1,3) > mv_par09
		Return NIL
	EndIf
Endif

nValor := Iif(nValor = Nil,aDados[11],nValor )

If cTipo $ "B#D" .And.  (lCm .Or. nValor >= 0)
	cDCR="C"
	cDCP="D"
Else
	cDCR="D"
	cDCP="C"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava registro no arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Reclock("cNomeArq",.t.)
Replace CODIGO  With aDados[1]	//CLIFOR
Replace LOJA    With aDados[2]	//LOJA
Replace DATAEM  With aDados[3]	//DTDIGIT
Replace NUMERO  With aDados[4]	//PREFIXO+NUMERO+PARCELA
Replace BANCO   With aDados[5]	//BANCO
Replace BAIXA   With aDados[6]	//DATA
Replace VALOR   With nValor
Replace EMISSAO With dEmissao
Replace VENCTO  With dVencto
Replace HISTOR  With Iif(Empty(aDados[7]) .Or.;
                         Upper(aDados[7]) = Upper(OemToAnsi(STR0047)),;  // "Valor recebido s/ Titulo"
                         OemtoAnsi(STR0048), aDados[7]) // "Baixa de Titulo"
If cPaisLoc == "BRA"
	If aDados[8] == "R"				// SE5->E5_RECPAG
		Replace DC With Iif((!(aDados[9] $ MVRECANT+"/"+MV_CRNEG) .or.;      //TIPO
		aDados[10]=="ES" ) .and. (!(aDados[9] $ MVPAGANT+"/"+MV_CPNEG .and. SE5->E5_MOTBX = "CMP" .and. aDados[10]=="ES")) ;  //Estorno de compensacao do adiantamento
		.and. aDados[11] >= 0 ,cDCR,cDCP)      //TIPODOC  VALOR
	Else
		Replace DC With Iif((!( aDados[9] $ MVPAGANT+"/"+MV_CPNEG) .or. ;
		aDados[10]=="ES" ) .and. (!( aDados[9] $ MVRECANT+"/"+MV_CRNEG .and. SE5->E5_MOTBX = "CMP" .and. aDados[10]=="ES")) ;   //Estorno de compensacao do adiantamento
		.and. aDados[11] >= 0 ,cDCP,cDCR) 
	EndIf
	MsUnlock()
Else  //If cPaisLoc == "ARG" // Microsiga Argentina 20/03/99 JLUCAS
	If aDados[8] == "R"
		Replace DC With Iif( !(aDados[9] $ "RA /"+MV_CRNEG),cDCR,cDCP)
		Replace BAIXA   With SE1->E1_EMISSAO
	Else
		Replace DC With Iif( !(aDados[9] $"PA /"+MV_CPNEG),cDCP,cDCR)
		Replace BAIXA   With aDados[6]     //SE5->E5_DATA
	EndIf
	MsUnlock()
EndIf           

If (SE5->E5_MOTBX == "CMP")
	//Verificar se eh a baixa principal do titulo
	If mv_par03 == 1 .And. lPrincipal .and. !(SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVRECANT+"/"+MV_CRNEG) .And. SE5->E5_TIPODOC == "CP"
		//Verificar se o valor da baixa eh igual ao valor do titulo.
		IF STR(SE5->E5_VALOR,17,2) == STR(SE1->E1_VALOR,17,2)
			nPos := Ascan(aDadosAbat, { |x| x[1] + x[2] + x[4] == SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA })
			If nPos > 0                                         
				For nY:=nPos to Len(aDadosAbat) 
					If aDadosAbat[nY][1]+aDadosAbat[nY][2]+aDadosAbat[nY][4] == SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
						Reclock("cNomeArq",.t.)
						Replace CODIGO  With aDadosAbat[nY][1]
						Replace LOJA    With aDadosAbat[nY][2]
						Replace DATAEM  With aDadosAbat[nY][3]
						Replace NUMERO  With aDadosAbat[nY][4]
						Replace BANCO   With aDadosAbat[nY][5]
						Replace EMISSAO With aDadosAbat[nY][6]
						Replace VENCTO  With aDadosAbat[nY][7]
						Replace VALOR   With aDadosAbat[nY][8]
						Replace BAIXA   With aDadosAbat[nY][9]
						Replace HISTOR  With STR0054  //"Baixa por Compensaca"
						Replace DC      With "D"
						MsUnlock()                      
					Else
						Exit					
					Endif
				Next
			Endif
		Endif
	Endif
Endif

If lPCCBaixa .and. !(cTipo $ 'M|J|D') .and. mv_par03 == 2 //Apenas PCC Carteira a Pagar
	//Gera movimentos de histórico em casos de retenção de pis, cofins e csll
	For nX := 1 To 3
		If Empty(aDados[11+nX]) 
			If aDados[14+nX] > 0
				Reclock("cNomeArq",.t.)
				Replace CODIGO  With aDados[1]
				Replace LOJA    With aDados[2]
				Replace DATAEM  With aDados[3]
				Replace NUMERO  With aDados[4]
				Replace BANCO   With aDados[5]
				Replace EMISSAO With dEmissao
				Replace VENCTO  With dVencto
				Replace VALOR   With aDados[14+nX]
				Replace BAIXA   With aDados[6]
				Replace HISTOR  With STR0047 + " - " + If(nX=1,"Pis",If(nX=2,"Cofins","Csll")) //Desc.Imposto
				Replace DC      With IIf(aDados[8]=="R","C","D") //Verifico se o titulo eh a pagar ou a receber
				MsUnlock()
			Endif
		Endif
	Next
Endif

dbSelectArea(cAlias)
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ SdoContab³ Autor ³ Claudio D. de Souza   ³ Data ³ 25.03.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcular o saldo contabil CTB ou SIGACON              	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ SdoContabil(cConta,dData,cMoeda,cTpSald) 					     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function SdoContabil(cConta,dData,cMoeda,cTpSald)
Local aRet := {0,0,0,0,0,0,0,0}
Local aSavArea := GetArea()

DEFAULT cMoeda  := "01"
DEFAULT cTpSald := "1"

If Val(cMoeda) == 0
	cMoeda := "01"
EndIf
If CtbInUse()
	aRet := SaldoCt7(cConta,dData,cMoeda,cTpSald)
Else
	aRet[1] := Saldo(cConta,Month(dData),Val(cMoeda),Year(dData))
Endif	
RestArea(aSavArea)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno:                                             ³
//³ [1] Saldo Atual (com sinal)                          ³
//³ [2] Debito na Data                                   ³
//³ [3] Credito na Data                                  ³
//³ [4] Saldo Atual Devedor                              ³
//³ [5] Saldo Atual Credor                               ³
//³ [6] Saldo Anterior (com sinal)                       ³
//³ [7] Saldo Anterior Devedor                           ³
//³ [8] Saldo Anterior Credor                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//      [1]       [2]     [3]      [4]     [5]     [6]       [7]     [8]
Return aRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValidSE5 ³ Autor ³ ********************* ³ Data ³ 25.03.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validar o conteudo do SE5 nao tratados pela Query     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ValidSE5() - Retorno .F. / .T.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico FINR550					  					  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidSE5()

Local lRet := .T.

If 	Empty(SE5->E5_NUMERO) .Or. SE5->E5_SITUACA $ "CX"
	Return .F.
EndIf

IF 	SE5->E5_DTDIGIT > mv_par02
	Return .F.
Endif
	
IF 	SE5->E5_CLIFOR < mv_par04 .Or. SE5->E5_CLIFOR > mv_par05
	Return .F.
EndIF

If	!SE5->E5_TIPODOC $ "VLüBAüCPüV2üLJüESüVMüCX"
	Return .F.
EndIf

If	( SE5->E5_NATUREZ < mv_par12 .Or. SE5->E5_NATUREZ > mv_par13 )
	Return .F.
EndIf

If	mv_par03 == 1 .and. SE5->E5_RECPAG == "R" .and. SE5->E5_TIPODOC =="ES" .and. !(SE5->E5_TIPO $ MVRECANT)
	Return .F.
Elseif	mv_par03 == 2 .and. SE5->E5_RECPAG == "P" .and. SE5->E5_TIPODOC =="ES" .and. !(SE5->E5_TIPO $ MVPAGANT)
	Return .F.
Endif

If	!Inside(SE5->E5_TIPO)
	Return .F.
Endif

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FR550TotCta º Autor ³ Gustavo Henrique º Data ³  23/10/09  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Define se deve imprimir o total da conta contabil do       º±±
±±º          ³ cliente/fornecedor.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPC1 - Codigo da conta contabil                           º±±
±±º          ³ EXPC2 - Codigo do cliente/fornecedor                       º±±
±±º          ³ EXPC3 - Codigo da loja                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro - Relatorio de Razonete                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FR550TotCta( cConta, cCliFor, cLoja )
     
Local aArea			:= GetArea()
Local aAreaSA1		:= {}
Local aAreaSA2	 	:= {}   
Local lRet			:= .T.

If mv_par03 == 1
	aAreaSA1 := SA1->( GetArea() )
	SA1->( dbSetOrder( 1 ) )
	SA1->( MsSeek( xFilial("SA1") + cNomeArq->CODIGO + cNomeArq->LOJA ) )
    // Se final de arquivo deve imprimir o total da conta, pois eh o ultimo cliente
	If cNomeArq->( !EoF() ) 
		// Imprime total por conta se mudou o cliente
		lRet := ( cNomeArq->CODIGO != cCliFor )
		If !lRet      
			If mv_par25 == 2
				// Se for o mesmo cliente e mudou a loja diferente e for uma nova conta contabil,
				// imprime o total, caso contrario nao imprime, retorna falso.
				lRet := (	cNomeArq->CODIGO == cCliFor	.And.;
							cNomeArq->LOJA	 != cLoja	.And.;
							cConta			 != SA1->A1_CONTA )
			Else 
				// Se for o mesmo cliente e for uma nova conta contabil,
				// imprime o total, caso contrario nao imprime, retorna falso.
				lRet := (	cNomeArq->CODIGO == cCliFor	.And.;
							cConta			 != SA1->A1_CONTA )			
			Endif
		EndIf
	EndIf				
	RestArea( aAreaSA1 )
Else
	aAreaSA2 := SA2->( GetArea() )
	SA2->( dbSetOrder( 1 ) )
	SA2->( MsSeek( xFilial("SA2") + cNomeArq->CODIGO + cNomeArq->LOJA ) )
    // Se final de arquivo deve imprimir o total por conta, pois eh o ultimo fornecedor
	If cNomeArq->( !EoF() )
		// Imprime total por conta se mudou o fornecedor
		lRet := ( cNomeArq->CODIGO != cCliFor )
		If !lRet
			If mv_par25 == 2
				// Se for o mesmo fornecedor e mudou a loja e for uma nova conta contabil, 
				// imprime o total, caso contrario nao imprime, retorna falso.
				lRet := (	cNomeArq->CODIGO == cCliFor	.And.;
							cNomeArq->LOJA	 != cLoja	.And.;
							cConta 			 != SA2->A2_CONTA )
			Else 
				// Se for o mesmo fornecedor e for uma nova conta contabil, 
				// imprime o total, caso contrario nao imprime, retorna falso.
				lRet := (	cNomeArq->CODIGO == cCliFor	.And.;
							cConta 			 != SA2->A2_CONTA )			
			Endif
		EndIf
	EndIf
	RestArea( aAreaSA2 )
EndIf
RestArea( aArea )

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FR550RetCF  º Autor ³Pablo S.G.Carrerasº Data ³  10/12/09  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorna campos desejados do SA1 e SA2 para consultas sem   º±±
±±º          ³ o emprego da filial                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPC1 - Codigo da conta contabil                           º±±
±±º          ³ EXPC2 - Codigo do cliente/fornecedor                       º±±
±±º          ³ EXPC3 - Codigo da loja                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro - Relatorio de Razonete                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FR550RetCF(cCod, cLoja, cCMP)

Local aArea		:= Array(0)
Local cRet		:= ""
Local cArqTrab	:= ""        
Local cIndice	:= ""
Local nIndex	:= 0

aArea := GetArea()
If mv_par03 == 1	//Cliente
	SA1->(dbSetOrder(1))
	cIndice	:= SA1->(IndexKey())
	cIndice	:= Right(cIndice,Len(cIndice)-10)
	cArqTrab := CriaTrab(Nil,.F.)
	IndRegua("SA1",cArqTrab,cIndice,,,OemToAnsi(STR0011))
	dbSelectArea("SA1")
	nIndex	:= RetIndex("SA1")
	#IFNDEF TOP
		dbSetIndex(cArqTrab + OrdBagExt())
	#ENDIF
	SA1->(dbSetOrder(nIndex + 1))
	If SA1->(dbSeek(cCod + cLoja))
		cRet := SA1->(&cCMP)
	Endif
	RetIndex("SA2")
Else 				//Fornecedor
	SA2->(dbSetOrder(1))
	cIndice	:= SA2->(IndexKey())
	cIndice	:= Right(cIndice,Len(cIndice)-10)
	cArqTrab := CriaTrab(Nil,.F.)
	IndRegua("SA2",cArqTrab,cIndice,,,OemToAnsi(STR0011))
	dbSelectArea("SA2")
	nIndex	:= RetIndex("SA2")
	#IFNDEF TOP
		dbSetIndex(cArqTrab + OrdBagExt())
	#ENDIF
	SA2->(dbSetOrder(nIndex + 1))
	If SA2->(dbSeek(cCod + cLoja))
		cRet := SA2->(&cCMP)
	Endif
	RetIndex("SA2")
Endif
RestArea(aArea)

Return (cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FR550VldAgCFº Autor ³Pablo S.G.Carrerasº Data ³  11/12/09  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida a selecao para aglutinacao de lojas de              º±±
±±º          ³ cliente/fornecedor.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                           								  º±±
±±º          ³                        									  º±±
±±º          ³ 						                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro - Relatorio de Razonete                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function FR550VldAgCF(nOpc)

If mv_par18 == 1 .AND. mv_par25 == 1
	Do Case
		Case nOpc == 1		//mv_par18
			mv_par18 := 2
			MsgAlert(OemToAnsi("A aglutinação de lojas não funciona com o filtro de contas contábeis. Filtro desativado!"))
		Otherwise
			mv_par25 := 2
			MsgAlert(OemToAnsi("A aglutinação de lojas não funciona com o filtro de contas contábeis. Aglutinação desativada!"))
	EndCase
Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AjustaSX1   º Autor ³Pablo S.G.Carrerasº Data ³  11/12/09  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ajusta o arquivo de perguntas                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                           								  º±±
±±º          ³                        									  º±±
±±º          ³ 						                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro - Relatorio de Razonete                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1()

Local aAreaSX1	:= SX1->(GetArea())
Local cPerg		:= "FIN550"
Local nTam		:= 0

//Pesquisando se a pergunta de aglutinacao de lojas de cliente/fornecedores consta no X1 do usuario
dbSelectArea("SX1")
SX1->(dbSetOrder(1))
nTam := SX1->(dbStruct())[1][3] //X1_GRUPO
If !SX1->(dbSeek(PadR(cPerg,nTam) + "25"))
	PutSx1(cPerg,"25","Aglutinar lojas","","","mv_chq","N",1,0,2,"C","FR550VldAgCF(2)","","","S","mv_par25","Sim","Si","Yes","","Nao","No","No",;
		"","","","","","","","","",{{"Determina se as lojas devem ser aglutinadas"}},{{}},{{}},	".FIN55025.")	
Else
	RecLock("SX1",.F.)
	SX1->X1_VALID := "FR550VldAgCF(2)"
	MsUnlock()
Endif
If SX1->(dbSeek(PadR(cPerg,nTam) + "18"))
	RecLock("SX1",.F.)
	SX1->X1_VALID := "FR550VldAgCF(1)"
	MsUnlock()
Endif
RestArea(aAreaSX1)

Return Nil
