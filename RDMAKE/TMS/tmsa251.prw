#INCLUDE "TMSA251.ch"  
#INCLUDE "PROTHEUS.ch"

Static lTM251Lib := ExistBlock('TM251Lib')
Static lTM251Est := ExistBlock('TM251Est')
Static lTM251Par := ExistBlock('TM251PAR') 
Static lTM251XML := ExistBlock('TM251XML')
Static lTM251Con := ExistBlock('TM251Con')
Static lTM251Can := ExistBlock('TM251Can')
Static lTM251Ope := ExistBlock('TM251Ope')

/*/                                        
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TMSA251  ³ Autor ³ Vitor Raspa           ³ Data ³ 06.jul.06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Liberacao para Pagamento do Contrato de Carreteiro           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMSA251()                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SigaTMS - Gestao de Transporte                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function TMSA251()                                     

Local aSays         := {}
Local aButtons      := {}
Local nOpca         := 0

Private cCadastro   := STR0001 //"Liberacao de Contrato de Carreteiro"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as perguntas selecionadas                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Contrato de      ?                                      ³
//³ mv_par02 - Contrato Ate     ?                                      ³
//³ mv_par03 - Data de          ?                                      ³
//³ mv_par04 - Data Ate         ?                                      ³
//³ mv_par05 - Proprietario de  ?                                      ³
//³ mv_par06 - Loja de          ?                                      ³
//³ mv_par07 - Proprietario Ate ?                                      ³
//³ mv_par08 - Loja Ate         ?                                      ³
//³ mv_par09 - Filial Origem de ?                                      ³
//³ mv_par10 - Viagem de        ?                                      ³
//³ mv_par11 - Filial Origem Ate?                                      ³
//³ mv_par12 - Viagem Ate       ?                                      ³
//³ mv_par13 - Filtra Contratos ? (1=Aguard. Lib, 2=Liberados, 3=Ambos ³
//³ mv_par14 - Contabiliza on Line ?                                   ³
//³ mv_par15 - Mostra lancamentos contabeis    ?                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//--Incluir Help
AjustaHLP()

Pergunte("TMA251",.F.)

Aadd( aSays, STR0002 ) //"Este programa ira filtrar os contratos de Carreteiro que estao com o Status Aguardando"
Aadd( aSays, STR0003 ) //"Lib. Pagamento. Sera apresentada uma janela para que o usuario possa marcar "
Aadd( aSays, STR0004 ) //"os  contratos que deverao ser liberados para pagamento"

Aadd( aButtons, { 1, .T., {|o| nOpca := 1, o:oWnd:End() } } )
Aadd( aButtons, { 2, .T., {|o| o:oWnd:End() } } )
Aadd( aButtons, { 5, .T., {|| Pergunte("TMA251",.T.) } } )
	
FormBatch( cCadastro, aSays, aButtons )
	
If nOpca == 1	    	
	Processa({|lEnd| TMSA251Brw()},"","",.F.) 
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³TMSA251Brw ³ Autor ³ Vitor Raspa         ³ Data ³06.Jul.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Apresenta Browse para selecao dos contratos a serem        ³±±
±±³          ³liberados.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³NIL                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³TMSA251                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function TMSA251Brw()

Local bFiltraBrw := {||}
Local aIndexDTY  := {}
Local cFilDTY    := ''
Local cRetPE     := ''
Local aCores     := {}
Local bIniBrw    := {||}
Local aCampos    := {}

Private aRotina  := MenuDef()
						
Aadd(aCores,{"DTY_STATUS=='1'",'BR_VERDE'    })			//-- Em Aberto
Aadd(aCores,{"DTY_STATUS=='2'",'BR_AMARELO'  })			//-- Aguardando Liberacao p/ Pagamento
Aadd(aCores,{"DTY_STATUS=='3'",'BR_LARANJA'  })			//-- Liberado para Pagamento
Aadd(aCores,{"DTY_STATUS=='4'",'BR_AZUL'     })			//-- Contrato Quitado com Ped. Compra
Aadd(aCores,{"DTY_STATUS=='5'",'BR_VERMELHO' })			//-- Contrato Quitado/Pagamento Realizado
Aadd(aCores,{"DTY_STATUS=='6'",'BR_CINZA'    })			//-- Titulo em fatura
Aadd(aCores,{"DTY_STATUS=='7'",'BR_BRANCO'   })  		//-- Aguardando Confirm. Webserver
Aadd(aCores,{"DTY_STATUS=='8'",'BR_PRETO'    }) 		//-- Aguardando autoriz pagto

cFilDTY += 'DTY_NUMCTC >= "' + MV_PAR01 + '" .And. DTY_NUMCTC <= "' + MV_PAR02 + '"'
cFilDTY += '.And. DtoS(DTY_DATCTC) >= "' + DtoS(MV_PAR03) + '" .And. DtoS(DTY_DATCTC) <= "' + DtoS(MV_PAR04) + '"'
cFilDTY += '.And. DTY_CODFOR+DTY_LOJFOR >= "' + MV_PAR05+MV_PAR06 + '" .And. DTY_CODFOR+DTY_LOJFOR <= "' + MV_PAR07+MV_PAR08 + '"'
cFilDTY += '.And. DTY_FILORI >= "' + MV_PAR09 + '" .And. DTY_FILORI <= "' + MV_PAR11 + '"'
cFilDTY += '.And. DTY_VIAGEM >= "' + MV_PAR10 + '" .And. DTY_VIAGEM <= "' + MV_PAR12 + '"'
If MV_PAR13 == 1
	cFilDTY += '.And. DTY_STATUS == "2"'
ElseIf MV_PAR13 == 2
	cFilDTY += '.And. DTY_STATUS == "3"'
Else
	cFilDTY += '.And. (DTY_STATUS == "2" .Or. DTY_STATUS == "3")'
EndIf

If	ExistBlock("TM251FIL")
	cRetPE := ExecBlock("TM251FIL",.F.,.F.,{cFilDTY})
	cFilDTY   := If(ValType(cRetPE)=="C", cRetPE, cFilDTY)
EndIf

bFiltraBrw := {|| FilBrowse("DTY",@aIndexDTY,@cFilDTY) }
Eval(bFiltraBrw)
DTY->(DbSetOrder(1))
DTY->(MsSeek(xFilial()))
aCampos:={}
SX3->(DbSetOrder(1))
SX3->(DbSeek('DTY'))
While SX3->(!Eof() .And. SX3->X3_ARQUIVO=='DTY')
	//-- Define sempre o primeiro campo como OK
	If Alltrim(SX3->X3_CAMPO)=='DTY_OK'
		If Len(aCampos) > 1
			Ains(aCampos,1)
			aCampos[1]:={SX3->X3_CAMPO,'','',SX3->X3_PICTURE}
		Else
			AAdd(aCampos,{SX3->X3_CAMPO,'','',SX3->X3_PICTURE})
		EndIf
	EndIf
	If	SX3->(X3Uso(SX3->X3_USADO)) .And. cNivel>=SX3->X3_NIVEL .And. SX3->X3_BROWSE=='S'
		If SX3->X3_CONTEXT!='V'
			AAdd(aCampos,{SX3->X3_CAMPO,'',SX3->(X3Titulo()),SX3->X3_PICTURE})
		Else
			bIniBrw := '{|| '+Alltrim(SX3->X3_INIBRW) +'}'
			AAdd(aCampos,{&bIniBrw,'',SX3->(X3Titulo()),SX3->X3_PICTURE})
		EndIf
	EndIf
	SX3->(DbSkip())
EndDo
MarkBrow('DTY', 'DTY_OK',,aCampos,, GetMark(,"DTY","DTY_OK"),,,,,'TMSA251Mrk()',,,, aCores)


dbSelectArea("DTY")
RetIndex("DTY")
dbClearFilter()
aEval(aIndexDTY,{|x| Ferase(x[1]+OrdBagExt())})
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³TMSA250Lib³ Autor ³Vitor Raspa          ³ Data ³ 07.Jul.06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Processa a Liberacao dos Contratos                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³TMSA251                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function TMSA251Lib()
Processa({|| TMSA251Prc('1')},STR0001,STR0012,.F.) //"Liberacao de Contrato de Carreteiro"###"Processando a Opcao Selecionada ..."
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³TMSA250Est³ Autor ³Vitor Raspa          ³ Data ³ 07.Jul.06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Processa o Estorno da Liberacao dos Contratos               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³TMSA251                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function TMSA251Est()
Processa({|| TMSA251Prc('2')},STR0001,STR0012,.F.) //"Liberacao de Contrato de Carreteiro"###"Processando a Opcao Selecionada ..."
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³TMSA251Prc³ Autor ³Vitor Raspa          ³ Data ³ 07.Jul.06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Processa a Opcao Selecionada pelo usuario                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cExpC1: Opcao Selecionada: 1=Liberar                        ³±±
±±³          ³                           2=Estornar Liberac.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³TMSA251                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function TMSA251Prc( cOpcao, lWs, aQuita, lPosto )
Local cQuery     := ''
Local cAliasQry  := GetNextAlias()
Local cMarca     := ThisMark()
Local lInverte   := ThisInv()
Local aDadosCTC  := {}
Local cQuebra    := ''
Local cCodForn   := ''
Local cLojForn   := ''
Local cCodFav    := ''
Local cLojFav    := ''
Local cCondPag   := ''
Local lTM250COND := ExistBlock('TM250COND')
Local cPrefixo   := ''
Local cTipDeb    := ''
Local cGerTitPdg := ''
Local cDedPdg    := ''
Local nBasImp    := 0
Local cPerg      := ""
Local aMsgErr    := {}
Local aVisErr    := {}
Local nOpcx      := 0
Local lRet       := .T.
Local cFilOld    := ''
Local lTMSOPdg   := SuperGetMV('MV_TMSOPDG',,'0') == '2' //-- Integracao com Operadoras de Frota
Local aDadosQuit := {}
Local aContratos := {}   
Local aContrt    := {}
Local lTabDFI    := AliasIndic("DFI") .And. nModulo==39
Local cTipUso    := IIf(AliasIndic("DFI") .And. nModulo==39,"2","1")
Local nStatusDTY := 0
Local aStatusDTY := {}
Local cSeekSDG   := ""
Local bWhileSDG  := {||.T.}    
Local cTMSDTVC   := SuperGetMV("MV_TMSDTVC",,"") //-- Data de Vigencia do Contrato do Fornecedor utilizada na Liberacao do Contrato: 1- Data da Emissao do Contrato, 2- Data Liberacao do Contrato. 
Local cCodOpe 	 := ""
Local cFilOri 	 := ""
Local cViagem    := ""
Local cNumCtc 	 := ""
Local cCodVei 	 := "" 
Local nSaldoOper := 0
Local aImposto	 := {}  
Local cTipPess	 := ''
Local lRepom	 := SuperGetMV('MV_TMSOPDG',,'0') == '2' .And. SuperGetMV('MV_VSREPOM',,'0') == '2'   
Local lFilLib   := DTY->(FieldPos("DTY_FILLIB")) > 0
Local lSeqBx    := AliasIndic('DYI')
Local lParCtc	 := DTY->(FieldPos("DTY_PARCTC")) > 0
Local cSeekDYI	 := ''         
Local aRetorno  := {{}}
Local cPrefTit  := ''

//-- Variaveis utilizadas no TMSA250
Private cFilDeb     := ''
Private cPrefDeb    := ''                                                        
Private cUniao      := GetMV('MV_UNIAO')  	// Cod. para Pagto. do Imposto de Renda
Private cNatuCTC    := '' 					// Natureza Contrato de Carreteiro
Private cNatuPDG    := Padr( GetMV('MV_NATPDG'), Len( SE2->E2_NATUREZ ) ) // Natureza Pedagio
Private cNatuDeb    := Padr( GetMV('MV_NATDEB'), Len( SE2->E2_NATUREZ ) ) // Natureza Utilizada nos Titulos Gerados para a Filial de Debito
Private cTipCTC     := Padr( GetMV('MV_TPTCTC'), Len( SE2->E2_TIPO ) )    // Tipo Contrato de Carreteiro
Private cTipPDG     := Padr( GetMV('MV_TPTPDG'), Len( SE2->E2_TIPO ) )    // Tipo Pedagio                                
Private cTipPre     := Padr( GetMV('MV_TPTPRE'), Len( SE2->E2_TIPO ) )    // Tipo Premio
Private cCodDesCTC  := Padr( GetMV('MV_DESCTC'), Len( DT7->DT7_CODDES ) ) // Codigo de Despesa de contrato de carreteiro 
Private cCodDesPDG  := Padr( GetMV('MV_DESPDG'), Len( DT7->DT7_CODDES ) ) // Codigo de Despesa de Pedagio                
Private cCodDesPRE  := Padr( GetMV('MV_DESPRE'), Len( DT7->DT7_CODDES ) ) // Codigo de Despesa de Premio                
Private nHdlPrv 

Default lWs := .F. 
Default aQuita := {}
Default lPosto := .F.

//-- Se o parametro MV_TPTCTC nao estiver preenchido                 
If Empty(cTipCTC)
	cTipCTC := Padr( "C"+cFilAnt, Len( SE2->E2_TIPO ) ) // Tipo Contrato de Carreteiro
EndIf                                               

cPrefixo := TMA250GerPrf(cFilAnt)

If lTM251Par  
	cNatuPDG := ExecBlock('TM251PAR',.F.,.F.,{2})
	cNatuDeb := ExecBlock('TM251PAR',.F.,.F.,{3})
	If ValType(cNatuPDG) <> 'C'
		cNatuPDG := Padr( GetMV("MV_NATPDG"), Len( SE2->E2_NATUREZ ) ) // Natureza Pedagio
	EndIf
	If ValType(cNatuDeb) <> 'C'
		cNatuDeb := Padr( GetMV("MV_NATDEB"), Len( SE2->E2_NATUREZ ) ) // Natureza Utilizada nos Titulos Gerados para a Filial de Debito
	EndIf
EndIf

//-- Recarrega as Perguntas
Pergunte("TMA251",.F.)

If lWs .And. !Empty(aQuita) // Recebe dados do Ws para usar na query / ignora o pergunte
	cQuery := "SELECT DTY_NUMCTC, DTY_TIPCTC, DTY_VALFRE, DTY_CODFOR, DTY_LOJFOR, DTY_CODFAV, DTY_LOJFAV, DTY_IRRF, DTY_SEST, DTY_INSS, DTY_CSLL, DTY_ISS, DTY_PIS, DTY_COFINS, "
	cQuery += "DTY_FILORI, DTY_VIAGEM, DTY_VALPDG, DTY_ADIFRE, DTY_CODVEI, DTY_DOCSDG, DTY_STATUS, DTY_BASIMP, DTY_CODOPE, DTY_DATCTC, DTY_FILDEB, " + IIf(lFilLib,'DTY_FILLIB,','') + IIf(lParCtc,'DTY_PARCTC,','') + " R_E_C_N_O_ RECDTY "
	cQuery += "FROM " + RetSqlName("DTY") + " WHERE "
	cQuery += "DTY_FILIAL = '" + xFilial('DTY') + "' AND "
	cQuery += "DTY_NUMCTC = '" + aQuita[1] + "' AND " 
	cQuery += "DTY_CODFOR = '" + aQuita[2] + "' AND " 
	cQuery += "DTY_LOJFOR = '" + aQuita[3] + "' AND "
	cQuery += "DTY_FILORI = '" + aQuita[4] + "' AND "
	cQuery += "DTY_VIAGEM = '" + aQuita[5] + "' AND "
	If cOpcao == '1' //-- Liberar 
		If lWs
			cQuery += "DTY_STATUS = '1' AND "  
		Else
			cQuery += "DTY_STATUS = '2' AND "  
		EndIf
	Else
		cQuery += "DTY_STATUS = '3' AND "
	EndIf
	cQuery += "D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY DTY_NUMCTC"
	cQuery := ChangeQuery(cQuery)
	DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)  
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza o filtro no DTY conforme itens selecionados no MarkBrowse ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT DTY_NUMCTC, DTY_TIPCTC, DTY_VALFRE, DTY_CODFOR, DTY_LOJFOR, DTY_CODFAV, DTY_LOJFAV, DTY_IRRF, DTY_SEST, DTY_INSS, DTY_CSLL, DTY_ISS, DTY_PIS, DTY_COFINS, "
	cQuery += "DTY_FILORI, DTY_VIAGEM, DTY_VALPDG, DTY_ADIFRE, DTY_CODVEI, DTY_DOCSDG, DTY_STATUS, DTY_BASIMP, DTY_CODOPE, DTY_DATCTC, DTY_FILDEB, " + IIf(lFilLib,'DTY_FILLIB,','') + IIf(lParCtc,'DTY_PARCTC,','') + " R_E_C_N_O_ RECDTY "
	cQuery += "FROM " + RetSqlName("DTY") + " WHERE "
	cQuery += "DTY_FILIAL = '" + xFilial('DTY') + "' AND "
	cQuery += "DTY_NUMCTC BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND "
	cQuery += "DTY_DATCTC BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' AND "
	cQuery += "DTY_CODFOR BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR07 + "' AND "
	cQuery += "DTY_LOJFOR BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR08 + "' AND "
	cQuery += "DTY_FILORI BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR11 + "' AND "
	cQuery += "DTY_VIAGEM BETWEEN '" + MV_PAR10 + "' AND '" + MV_PAR12 + "' AND " 
	If lInverte <> Nil .and. cMarca <> Nil
		If ( lInverte )
			cQuery    += "DTY_OK <> '" + cMarca + "' AND "
		Else
			cQuery    += "DTY_OK = '" + cMarca + "' AND "
		EndIf 
	EndIf
	If cOpcao == '1' //-- Liberar 
		If lWs
			cQuery += "DTY_STATUS = '1' AND "  
		Else
			cQuery += "DTY_STATUS = '2' AND "  
		EndIf
	Else
		cQuery += "DTY_STATUS = '3' AND "
	EndIf
	cQuery += "D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY DTY_NUMCTC"
	cQuery := ChangeQuery(cQuery)
	DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)  
EndIf 
If !(cAliasQry)->(EoF())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estrutura do Array aDadosCTC:                                        ³
	//³ aDadosCTC[n,01] - Codigo do Fornecedor                               ³
	//³ aDadosCTC[n,02] - Loja do Fornecedor                                 ³
	//³ aDadosCTC[n,03] - Tipo Fornec. (Pessoa Fisica, Juridica, ...)        ³
	//³ aDadosCTC[n,04] - Contato do Fornecedor                              ³
	//³ aDadosCTC[n,05] - Filial de Debito Fornecedor                        ³
	//³ aDadosCTC[n,06] - Condicao de Pagamento do Fornecedor                ³
	//³ aDadosCTC[n,07] - Filial de Origem                                   ³
	//³ aDadosCTC[n,08] - No. da Viagem                                      ³
	//³ aDadosCTC[n,09] - No. do Contrato                                    ³
	//³ aDadosCTC[n,10] - Valor do Frete informado na viagem / Calculado     ³
	//³ aDadosCTC[n,11] - Valor dos Adiantamentos                            ³
	//³ aDadosCTC[n,12] - Credor dos Adiantamentos                           ³
	//³ aDadosCTC[n,13] - Loja do Credor                                     ³
	//³ aDadosCTC[n,14] - Prefixo do Titulo                                  ³
	//³ aDadosCTC[n,15] - Codigo do Veiculo                                  ³
	//³ aDadosCTC[n,16] - Valor do Pedagio                                   ³
	//³ aDadosCTC[n,17] - Tipo do Titulo                                     ³
	//³ aDadosCTC[n,18] - Codigo do Favorecido                               ³
	//³ aDadosCTC[n,19] - Loja do Favorecido                                 ³
	//³ aDadosCTC[n,20] - Valor do ISS                                       ³
	//³ aDadosCTC[n,21] - Natureza do Titulo                                 ³
	//³ aDadosCTC[n,22] - Gera Titulo do Pedagio ? (1=Sim/2=Nao)             ³
	//³ aDadosCTC[n,23] - Deduz Pedagio do Valor do Frete? (1=Sim/2=Nao)     ³
	//³ aDadosCTC[n,24] - Valor Base para Calculo dos Impostos               ³
	//³ aDadosCTC[n,25] - Controla a Liberacao do Contrato de Carreteiro?    ³
	//³ aDadosCTC[n,26] - Contrato vinculado a Operadora de Frotas?          ³
	//³ aDadosCTC[n,27] - Valor do INSS Retido                               ³
	//³ aDadosCTC[n,28] - Tipo de Uso - 1=Viagem;2=Carga - Frete Embarcador  ³
	//³ aDadosCTC[n,29] - Indentificador de Viagem ou Carga - Frt.Embarcador ³
	//³ aDadosCTC[n,30] - Gera Titulo do Contrato ?(1=Sim/2=Nao)             ³
	//³ aDadosCTC[n,31] - Rota Municipal ?(1=Sim/2=Nao)                      ³
	//³ aDadosCTC[n,32] - Gera Pedido de Venda ?(1=Sim/2=Nao)                ³
	//³ aDadosCTC[n,33] - Array de Impostos pela Repom (IRRF,SEST, INSS)     ³
	//³ aDadosCTC[n,34] - Codigo da Operadora de Frete e Pedagio        	 ³
	//³ aDadosCTC[n,35] - Foi executada a liberacao do contrato?        	    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cOpcao == '1'

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³LIBERACAO DOS CONTRATOS³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                          
		
		cQuebra := (cAliasQry)->(DTY_NUMCTC + DTY_TIPCTC)
		While !(cAliasQry)->(EoF()) .And. lRet
			If lTM251Con
				lRetPE := ExecBlock('TM251Con',.F.,.F.,{(cAliasQry)->DTY_NUMCTC,(cAliasQry)->DTY_FILORI,(cAliasQry)->DTY_VIAGEM})
				If ValType(lRetPE)=="L" .And. !lRetPE
					(cAliasQry)->(DbSkip())
					Loop
				EndIf
  			EndIf			
  			
  			Begin Transaction	
				//-- Verifica a Filial de Debito (posiciona no arquivo SA2)
				cCodForn := (cAliasQry)->DTY_CODFOR
				cLojForn := (cAliasQry)->DTY_LOJFOR
				cCodFav  := (cAliasQry)->DTY_CODFAV
				cLojFav  := (cAliasQry)->DTY_LOJFAV		
				cFilDeb 	:= TMSA250FilDeb(cCodForn, cLojForn, @cCodFav, @cLojFav, .F., (cAliasQry)->DTY_FILORI, (cAliasQry)->DTY_VIAGEM,,(cAliasQry)->DTY_CODVEI) //--Nao checa filial de descarga
	
				//-- Condicao de Pagamento do Proprietario do Veiculo
				cCondPag := SA2->A2_COND
				If lTM250COND
					cCondPag := ExecBlock('TM250COND',.F.,.F.)
					If ValType(cCondPag) <> 'C'
						cCondPag := Space(Len(SA2->A2_COND))
					Else
						SE4->(DbSetOrder(1))
						If SE4->(!dbSeek(xFilial('SE4') + cCondPag))
							cCondPag := Space(Len(SA2->A2_COND))
						EndIf
					EndIf
				EndIf
				If Empty(cCondPag)
					AAdd( aMsgErr, { STR0013 + SA2->A2_COD + "/" + SA2->A2_LOJA + ' - ' + AllTrim(SA2->A2_NREDUZ), '03', "MATA020()" } ) // 'Cond. de Pagamento Invalida ou nao informada no Fornecedor: '
					lRet := .F.
				EndIf
				If !lFilLib .And. (cAliasQry)->(DTY_FILORI) <> cFilAnt
					If lRet .And. lRepom .And. (cAliasQry)->DTY_CODOPE == '01' 
						lRet:= .T.
					Else										
						AAdd( aMsgErr, { STR0025 + (cAliasQry)->(DTY_NUMCTC) + " " + STR0026 + (cAliasQry)->(DTY_FILORI) + "!" + STR0027, '06',"TMSA251()"} ) //--"O Contrato "//--"deve ser liberado pela filial: "//--"Para efetuar liberacao por outras filiais execute o Update TMS10R169."
						lRet := .F.		
					EndIf	
				EndIf
				
				cTipDeb := Padr( "C" + cFilDeb, Len( SE2->E2_TIPO ) )
				If !SX5->(MsSeek(xFilial('SX5')+"05"+cTipDeb))
					AAdd( aMsgErr, { STR0015 +  cFilDeb + '. ' + STR0016 + cFilDeb , '02', "" } ) //"Nao foi encontrado o tipo de Titulo na Tabela '05' para a filial de Debito: "### "Tipo do Titulo a ser cadastrado : "
					lRet := .F.
				EndIf		
	
				If !Empty(SA2->A2_NATUREZ)
					cNatuCTC := SA2->A2_NATUREZ
				Else
					cNatuCTC := Padr( GetMV("MV_NATCTC"), Len( SE2->E2_NATUREZ ) ) //-- Natureza Contrato de Carreteiro
				EndIf
				If Empty(cNatuCTC)
					AAdd( aMsgErr, { STR0028 + (cAliasQry)->(DTY_NUMCTC) + " " + STR0029 , '04', "" } ) //""Natureza do Contrato de Carreteiro: " //--"nao encontrada." 
					lRet := .F.
				Else
					SED->(dbSetOrder(1))
					If !SED->(MsSeek(xFilial('SED')+cNatuCTC) )
						AAdd( aMsgErr, { STR0030 , '05', "" } ) //"Conteudo do parametro invalido MV_NATCTC"
						lRet := .F.
					EndIf
				EndIf
				
				If lRet
					DTQ->(DbSetOrder(2))
					DTQ->(MsSeek(xFilial('DTQ') + (cAliasQry)->(DTY_FILORI + DTY_VIAGEM)))
				                                                      
								
					aContrt := TMSContrFor(cCodForn, cLojForn,Iif(cTMSDTVC == "2",dDataBase,STOD((cAliasQry)->DTY_DATCTC)),;
					DTQ->DTQ_SERTMS,DTQ->DTQ_TIPTRA,.F.,Posicione('DA3',1,xFilial('DA3') + (cAliasQry)->DTY_CODVEI,'DA3_TIPVEI'))         
		
					If Empty(aContrt)
						aContrt := TMSContrFor(cCodForn, cLojForn,Iif(cTMSDTVC == "2",dDataBase,STOD((cAliasQry)->DTY_DATCTC)),;
						DTQ->DTQ_SERTMS,DTQ->DTQ_TIPTRA,.T.)         			
					EndIf		  
				    
				    cGerTitPDG := ""
			    	cDedPDG    := ""
					If Len(aContrt) > 0                                                                              
						cGerTitPDG := aContrt[1][5]
						cDedPDG    := aContrt[1][6]
					EndIf		    		
				
					If Empty(cGerTitPDG) .And. !lRepom .And. (cAliasQry)->DTY_CODOPE == '01'
	    				lRet := .F.			            
					EndIf			
	
					//-- Valor da Base dos Impostos
					nBasImp := (cAliasQry)->DTY_BASIMP
				EndIf
				      			
				If lRet  
					//-- Rota Municipal 
					cRotMun:=''
					If cTipUso == "1" //--TMS																                             
						DA8->(DbSetOrder(1))
						If DA8->(MsSeek(xFilial("DA8")+DTQ->DTQ_ROTA)) .And. DA8->(FieldPos("DA8_ROTMUN")) > 0
						   cRotMun:= DA8->DA8_ROTMUN 							
						EndIf
					EndIf	
					
					SA2->(DbSetOrder(1))
					If SA2->(DbSeek(xFilial("SA2")+cCodForn+cLojForn))
						cTipPess := SA2->A2_TIPO
					EndIf
					
					nSaldoOper := (cAliasQry)->DTY_VALFRE    //- valor padrao do frete
					       
					If lRepom .And. (cAliasQry)->DTY_CODOPE == '01'
				   		nSaldoOper :=(cAliasQry)->DTY_VALFRE - (cAliasQry)->DTY_ADIFRE 
					Endif
					
					//-- Impostos informados pela Repom 
					If  lRepom .And.  (cAliasQry)->DTY_CODOPE == '01'    
						AAdd(aImposto, (cAliasQry)->DTY_IRRF)  
						AAdd(aImposto, (cAliasQry)->DTY_SEST)
						AAdd(aImposto, (cAliasQry)->DTY_INSS)
					EndIf
					
					AAdd( aDadosCTC, {	(cAliasQry)->DTY_CODFOR,;
										(cAliasQry)->DTY_LOJFOR,;
										SA2->A2_TIPO,;
										SA2->A2_CONTATO,;
										cFilDeb,;
										cCondPag,;
										(cAliasQry)->DTY_FILORI,;
										(cAliasQry)->DTY_VIAGEM,;
										(cAliasQry)->DTY_NUMCTC,;
									     nSaldoOper,;
										(cAliasQry)->DTY_ADIFRE,;
										(cAliasQry)->DTY_CODFOR,;
										(cAliasQry)->DTY_LOJFOR,;
										cPrefixo,;
										(cAliasQry)->DTY_CODVEI,;
										(cAliasQry)->DTY_VALPDG,;
										cTipDeb,;
										cCodFav,;
										cLojFav,;
										0,;
										cNatuCTC,;
										cGerTitPdg,;
										cDedPdg,;
										nBasImp,;
										.F.,;
										.F.,;
										Posicione("DTR",3,xFilial("DTR")+(cAliasQry)->(DTY_FILORI+DTY_VIAGEM+DTY_CODVEI),"DTR_INSRET"),;
										,;
										,;
										,;
										cRotMun,;
										'2',;
										aImposto,;
										(cAliasQry)->DTY_CODOPE,;
										.T.})
	   				If	cMarca <> NIL			
						aAdd(aStatusDTY , {(cAliasQry)->RECDTY,'3',dDataBase,Iif(IsMark("DTY_OK", cMarca), Space(Len(DTY->DTY_OK)), cMarca)} )
					Else
						aAdd(aStatusDTY , {(cAliasQry)->RECDTY,'3',dDataBase} )
					EndIf	
  	        	EndIf	            
  	            
  	        	cCodOpe := (cAliasQry)->DTY_CODOPE
  	        	cFilOri := (cAliasQry)->DTY_FILORI
  	        	cViagem := (cAliasQry)->DTY_VIAGEM
  	        	cNumCtc := (cAliasQry)->DTY_NUMCTC
  	        	cCodVei := (cAliasQry)->DTY_CODVEI
  	        
				(cAliasQry)->(DbSkip())
					
				If lRet .And. ( cQuebra <> (cAliasQry)->(DTY_NUMCTC + DTY_TIPCTC) .Or. (cAliasQry)->(EoF()) )
					If Right(cQuebra,1) == '1' //-- Por Viagem
						cPerg := "TMA250"
						nOpcx := 3
					ElseIf Right(cQuebra,1) == '2' .Or. Right(cQuebra,1) == '5' //-- Por Periodo ou Complementar
						cPerg := "TM250A"
						nOpcx := 4
					ElseIf Right(cQuebra,1) == '3'
						cPerg := "TMA251"
						nOpcx := 0
					EndIf
				
					lRet := TMSA250Qbr(nOpcx, aDadosCTC, aMsgErr, aVisErr, "J", "2", cPerg)
					//-- Se Pessoa Fisica, faz a Quebra no Vetor aDadosCTC (Por Tipo do Fornecedor + Fornecedor) , gerando
					//-- somente UM titulo a Pagar com valor acumulado de todas as viagens feitas no periodo pelo fornecedor
					If lRet
						lRet := TMSA250Qbr(nOpcx,aDadosCTC,aMsgErr,aVisErr,"F","2",cPerg)
					EndIf
					
					
					If lRet
						For nStatusDTY := 1 To Len(aStatusDTY)
							DTY->(DbGoTo( aStatusDTY[nStatusDTY][1] ))
							RecLock('DTY',.F.)
							If DTY->DTY_CODOPE== '01' .And. DTY->DTY_LOCQUI != '1' // Se quita em filial, aguarda aviso de pagamento
								DTY->DTY_STATUS := '8'
							Else
						 		DTY->DTY_STATUS := aStatusDTY[nStatusDTY][2] //-- Liberado para Pagamento   
						 	EndIf
						 	DTY->DTY_DATLIB := aStatusDTY[nStatusDTY][3] 
						 	If cMarca <> NIL	
						 		DTY->DTY_OK 	:= aStatusDTY[nStatusDTY][4] 
					   	EndIf
						 	If lFilLib
						 		DTY->DTY_FILLIB := cFilAnt
						 	EndIf
						 	DTY->DTY_FILDEB := cFilDeb
						 	MsUnLock()					
						Next nStatusDTY
					EndIf
			
					cQuebra   := (cAliasQry)->(DTY_NUMCTC + DTY_TIPCTC)
					aDadosCTC := {}
					aStatusDTY:= {}
		  		EndIf
		  		
		  		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³REALIZA A INTEGRACAO COM OPERADORAS DE FROTA³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lRet .And. lTMSOPdg .And. !Empty(cCodOpe)
					CursorWait()
					MsgRun( STR0019,; //-- "Autorização do Pagamento do Contrato..."
							STR0018,; //-- 'Aguarde...'
							{|| lRet := TMA251Aut( cCodOpe, cFilOri, cViagem, @aMsgErr, @aDadosQuit, cNumCtc, cCodVei, .F., cCondPag, cCodForn, cLojForn )} )
					CursorArrow()
				EndIf
		  		
	  			If !lRet
					DisarmTransaction()
				EndIf
				
				//-- Array para o Ponto de entrada
				If lTM251Lib .And. lRet
					AAdd( aContratos, { cFilOri, cViagem, cNumCtc } )
				EndIf 

		  		lRet := .T. // Voltando lRet verdadeiro para processar proximos registros    
	  		
	  		End Transaction	    

		EndDo
				
		//-- Ponto de Entrada apos a liberacao do contrato:
		If lTM251Lib .And. Len(aContratos) > 0
			ExecBlock('TM251Lib',.F.,.F.,{ aContratos })
		EndIf
		
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ESTORNO DA LIBERACAO DOS CONTRATOS³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !(cAliasQry)->(EoF()) .And. lRet
		                                                            
			If lTM251Can
				lRet := ExecBlock('TM251Can',.F.,.F., {(cAliasQry)->DTY_FILORI, (cAliasQry)->DTY_VIAGEM, (cAliasQry)->DTY_NUMCTC } ) //--(cAliasQry)->DTY_NUMCTC
				If ValType(lRet) != "L"
					lRet := .T.
				EndIf
			EndIf
		
			If lRet
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se a Filial foi a responsavel pela liberacao  ³ 
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lFilLib .And. !Empty((cAliasQry)->DTY_FILLIB)
					If (cAliasQry)->DTY_FILLIB <> cFilAnt
				  		AAdd( aMsgErr, { STR0031 + (cAliasQry)->(DTY_NUMCTC)  + " " + STR0032 + (cAliasQry)->(DTY_FILLIB), '04', "TMSA251()" } ) //--"O Estorno da liberacao do contrato: "//--"deve ser realizado pela filial: "
						lRet := .F.
					EndIf					
				EndIf
				If lRet					
					lRet     := TMSA250VerBai(	cPrefixo, (cAliasQry)->DTY_NUMCTC, (cAliasQry)->DTY_CODFOR, (cAliasQry)->DTY_LOJFOR)
					If !lRet
						AAdd( aMsgErr, { STR0017 +cPrefixo+"/"+(cAliasQry)->DTY_NUMCTC, '01', "FINA080()" } ) //"Titulo Baixado. No. do  Titulo : "
					ElseIf lSeqBx    
						DYI->(dbSetOrder(1))
						If DYI->(dbSeek(cSeekDYI:= xFilial('DYI')+(cAliasQry)->(DTY_FILORI+DTY_NUMCTC)))
							While DYI->(!Eof()) .And.  DYI->(DYI_FILIAL+DYI_FILORI+DYI_NUMCTC) == cSeekDYI
								Aadd( aRetorno[1], DYI->DYI_SEQBX )
								DYI->(dbSkip())
							EndDo		
						EndIf
						If (cAliasQry)->DTY_FILDEB <> cFilAnt
							cPrefTit := TMA250GerPrf((cAliasQry)->(DTY_FILDEB))
						Else
							cPrefTit := cPrefixo
						EndIf						
						SE2->(dbSetOrder(6)) //--E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
						If SE2->(dbSeek(xFilial('SE2')+(cAliasQry)->(DTY_CODFOR+DTY_LOJFOR)+cPrefTit+(cAliasQry)->(DTY_NUMCTC)))
							MaIntBxCP(2,{SE2->(Recno())},{0,0,0},Nil,Nil,Nil,Nil, aRetorno)
						Else
							Aviso(STR0008,STR0033+ cFilDeb,{STR0022})//--O Estorno da liberacao deve ser efetuado na filial: '
						 	lRet := .F.	
						EndIf						
					EndIf
			   EndIf	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³REALIZA A INTEGRACAO COM OPERADORAS DE FROTA³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lRet .And. lTMSOPdg .And. (cAliasQry)->DTY_CODOPE == '01'
					DTR->(DbSetOrder(1))
					If DTR->(MsSeek(xFilial('DTR') + (cAliasQry)->(DTY_FILORI+DTY_VIAGEM)))
						If (Aviso(STR0020,STR0021 + DTR->DTR_PRCTRA,{STR0022,STR0023}) == 1) //-- "Continuar com o estorno da Liberacao?" ### "Apos a realizacao do estorno da Liberacao, e necessario acessar o site da Operadora de Frotas e estornar a Quitacao do Contrato. Processo de Transporte No.: " ### "Continuar" ### "Cancelar"
							lRet := .T.
						Else
							lRet := .F.
						EndIf
					EndIf
				ElseIf lRet .And. lTMSOPdg .And. (cAliasQry)->DTY_CODOPE == '02'    
					DTR->(DbSetOrder(1))
					DTR->(MsSeek(xFilial('DTR') + (cAliasQry)->(DTY_FILORI+DTY_VIAGEM)))
					aRetCNPJ   := PamCNPJEmp((cAliasQry)->(DTY_CODOPE), (cAliasQry)->(DTY_FILORI)) //Função para obter CNPJ da contrante e filial de origem 
					//Consulta parcela para saber se ja foi efetivada
					nRetParc := PamConParc((cAliasQry)->(DTY_FILORI), (cAliasQry)->(DTY_VIAGEM), aRetCNPJ, AllTrim(Str(Val((cAliasQry)->(DTY_PARCTC)))) ) //Chama a rotina que consulta a parcela de Saldo Final.
					If nRetParc == 5 //Parcela Efetivada 
						Help('',1,'TMSPAM014',,,3,0) //"Parcela ja efetivada no sistema", " Pamcard, estorno da liberação","do contrato não permitida."
						lRet:= .F.
					EndIf	
				EndIf		
				
				Begin Transaction
					If lRet
					   lRet := TMA250DelTit(cPrefixo, (cAliasQry)->DTY_NUMCTC,,(cAliasQry)->DTY_CODFOR, (cAliasQry)->DTY_LOJFOR, (cAliasQry)->DTY_CODFAV, (cAliasQry)->DTY_LOJFAV, '', 2)
		    			If lRet
							//-- Verifica a Filial de Debito
							 cFilDeb := (cAliasQry)->DTY_FILDEB							 		
							//-- Deletar Contas a Pagar da Filial de Debito
							If cFilDeb <> cFilAnt
								cFilOld  := cFilAnt
								cPrefDeb := TMA250GerPrf(cFilDeb)
								cFilAnt  := cFilDeb
								lRet     := TMA250DelTit(cPrefDeb, (cAliasQry)->DTY_NUMCTC, cFilDeb, (cAliasQry)->DTY_CODFOR, (cAliasQry)->DTY_LOJFOR, (cAliasQry)->DTY_CODFAV, (cAliasQry)->DTY_LOJFAV, '', 2)
								cFilAnt  := cFilOld
							EndIf
						EndIf
					EndIf
	
					If lRet
						DTY->(DbGoTo( (cAliasQry)->RECDTY ))
						RecLock('DTY',.F.)
						DTY->DTY_STATUS := '2' //-- Aguardando Liberacao para Pagamento
						DTY->DTY_DATLIB := CtoD(Space(08))
						DTY->DTY_IRRF   := 0
						DTY->DTY_INSS   := 0
						DTY->DTY_OK := Iif(IsMark("DTY_OK", cMarca), Space(Len(DTY->DTY_OK)), cMarca)
						If lFilLib
							DTY->DTY_FILLIB := ""
						EndIf	
						DTY->DTY_FILDEB := ""
						MsUnLock()  

						If lTabDFI .And. cTipUso == "2" //--OMS com Frete Embarcador
							SDG->(dbSetOrder(8))
							cSeekSDG  := xFilial("SDG")+cTipUso+(cAliasQry)->DTY_IDENT+(cAliasQry)->DTY_CODVEI
							bWhileSDG := {|| SDG->(!Eof()) .And. SDG->(DG_FILIAL+DG_TIPUSO+DG_IDENT+DG_CODVEI) == cSeekSDG }
						ElseIf cTipUso == "1" //--TMS
							SDG->(dbSetOrder(5))
							cSeekSDG  := xFilial("SDG")+(cAliasQry)->DTY_FILORI+(cAliasQry)->DTY_VIAGEM+(cAliasQry)->DTY_CODVEI
							bWhileSDG := {|| SDG->(!Eof()) .And. SDG->(DG_FILIAL+DG_FILORI+DG_VIAGEM+DG_CODVEI) == cSeekSDG }
						EndIf
      
						SDG->(dbSeek(cSeekSDG))
						While Eval(bWhileSDG)                                 
							If Empty(SDG->DG_BANCO) .And. SDG->DG_ORIGEM <> 'DTY' 
								If SDG->(FieldPos('DG_NUMCTC')>0 ) .And. SDG->DG_NUMCTC == (cAliasQry)->DTY_NUMCTC
									Reclock("SDG",.F.)
									SDG->DG_NUMCTC := ""
									SDG->( MsUnlock() )
								EndIf
							EndIf
							//Estorna Baixa 
							If SDG->DG_ORIGEM <> 'DTR'
								TMSA070Bx("2",SDG->DG_NUMSEQ)
							EndIf														
							SDG->(dbSkip())
						EndDo
					EndIf
					
					//--Apaga registros da tabela de Acerto Finaceiro do Contrato					
					If lRet  .And. AliasIndic('DYI')
						A250SeqBx(,,(cAliasQry)->DTY_FILORI,(cAliasQry)->DTY_VIAGEM,2)
					EndIf	
					
					If lRet .And. lTMSOPdg .And. (cAliasQry)->DTY_CODOPE == '02'
						lRet := PamEstPaCt((cAliasQry)->DTY_FILORI, (cAliasQry)->DTY_VIAGEM, aRetCNPJ,(cAliasQry)->DTY_NUMCTC) //Modifica o status da parcela de liberada para Excluída
						If !lRet
							DisarmTransaction()
						EndIf
					EndIf
												
				End Transaction 				         
            
				If lTM251Est .And. lRet
					AAdd( aContratos, { (cAliasQry)->DTY_FILORI, (cAliasQry)->DTY_VIAGEM, (cAliasQry)->DTY_NUMCTC } )
				EndIf						

			EndIf
			(cAliasQry)->(DbSkip())
		EndDo                       
		
		//-- Ponto de Entrada apos o Estorno da liberacao do contrato:
		If lTM251Est .And. lRet
			ExecBlock('TM251Est',.F.,.F.,{ aContratos })     
		EndIf 		
	EndIf
Else
	Help('',1,'TMSA25101') // 'Nenhum item foi Selecionado.'
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³TRATAMENTO DOS ERROS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(aMsgErr) .And. !lWs
	AaddMsgErr( aMsgErr, @aVisErr)
	TmsMsgErr( aVisErr )
EndIf

(cAliasQry)->(DbCloseArea())
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcoes   ³TMSA251Mrk ³ Autor ³Vitor Raspa          ³ Data ³ 07.Jul.06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Processa a Marcacao dos Contratos                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³TMSA251                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function TMSA251Mrk()
Processa({|| TMSA251Mark()},STR0001,STR0014,.F.) //"Liberacao de Contrato de Carreteiro"###"Processando a marcacao dos Contratos..."
Return    

Static Function TMSA251Mark()
Local aAreaDTY := DTY->(GetArea())
Local cNumCTC  := ''
Local cMarca   := ThisMark()

cNumCTC := DTY->DTY_NUMCTC
DTY->(DbSetOrder(1))
DTY->(MsSeek(xFilial('DTY') + cNumCTC))
While DTY->(DTY_FILIAL+DTY_NUMCTC) == xFilial('DTY') + cNumCTC
	RecLock('DTY',.F.)
	DTY->DTY_OK := Iif(IsMark("DTY_OK", cMarca), Space(Len(DTY->DTY_OK)), cMarca)
	MsUnLock()
	DTY->(DbSkip())
EndDo

RestArea(aAreaDTY)
MarkBRefresh()
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³TMA251Oper³ Autor ³ Vitor Raspa           ³ Data ³ 15.Nov.06³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Realiza a Quitacao do Contrato junto a Operadora de Frota   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³lRet := TMA310Oper(cExpC1, cExpC2, cExpC3, @aExpA1 )        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cExpC1 - Codigo da Operadora de Frotas                      ³±±
±±³          ³cExpC2 - Filial de Origem                                   ³±±
±±³          ³cExpC3 - Numero da Viagem                                   ³±±
±±³          ³aExpA1 - Array com as Mensagens de Erro (Por Referencia)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico - .T. indica sucesso no processamento do metodo      ³±±    
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function TMA251Oper( cCodOpe, cFilOri, cViagem, aMsgErr, aDadosQuit, cContrat, cCodVei, lQuitacao )
Local lRet     := .F.
Local cXML     := ''    
Local cXmlNew  := ''
Local oObj     := NIL
Local cError   := ''
Local cWarning := ''
Local cObs     := ''
Local nValSaq  := 0
Local nValCon  := 0
Local nSalPag  := 0
Local nFrePag  := 0
Local cDesAdf  := SuperGetMV('MV_DESADF',,'') //-- Despesa para lancamento de Adto. de Frete
Local aArea    := GetArea()
Local aAreaDTR := DTR->(GetArea())
Local lTMSXML  := GetMV( 'MV_TMSXML',, .F. )    
Local oXML     := NIL               
Local cVsRepom := SuperGetMV( 'MV_VSREPOM',, '1' )  //-- Versao 2- Contempla nova Legislacao (Encerramento viagem no Posto)
Local cValFret := 0            
Local cPeso	 := ''
Local cData	 := ''   
Local cDia	   	 := ''
Local cMes	   := ''
Local cAno	   := ''
Local cCodFor  := ''
Local cLojFor  := '' 
Local cCond	   := ''
Local aData	   := {} 
Local aMov	   
Local cLocQui   := ''
Local lRepom    := SuperGetMV( 'MV_VSREPOM',, '1' ) == '2'
Local cDesAbast	:= SuperGetMV( 'MV_ABAST',, '' )  
Local cDesSaq	:= SuperGetMV( 'MV_DESSAQ',, '' ) 
Local cFilDTY	:= Iif ( DTQ->DTQ_SERTMS == '2', cFilOri, xFilial('DTY') )  

//-- Configura o tamanho do nome das Variaveis
SetVarNameLen( 255 )

Default lQuitacao := .T.  
Default cCodVei   := ''
                      
If DTY->(FieldPos("DTY_LOCQUI")) > 0
	DTY->(DbSetOrder(2))
	If DTY->(DbSeek(cFilDTY + cFilOri + cViagem)) 
		cPeso    := DTY->DTY_PESO
		cValFret := DTY->DTY_VALFRE 
		cCodFor  := DTY->DTY_CODFOR
		cLojFor  := DTY->DTY_LOJFOR 
   		cLocQui  := DTY->DTY_LOCQUI
   		If  Empty(cCodVei)
   			cCodVei := DTY->DTY_CODVEI
   		Endif
	EndIf
EndIf  

If !Empty(cCodFor) .And.!Empty(cLojFor)      //-- Conseguir a condicao de pagto do Fornecedor
	SA2->(DbSetOrder(1))
	If SA2->(MsSeek(xFilial('SA2')+cCodFor+cLojFor))  
	     cCond	:= SA2->A2_COND
	EndIf
EndIf

DEG->(DbSetOrder(1))
If DEG->(MsSeek(xFilial('DEG')+cCodOpe))
	If cCodOpe == '01' //-- REPOM Tecnologia 
		If lQuitacao 
		
		aData := Condicao(cValFret,cCond,0,dDatabase)   //-- Conseguir a data Prevista
		cData := DTOC(aData[1][1])  
		If  cData == DTOC(dDatabase) .Or. Empty(cData)   //-- Repom nao aceita data prevista para o mesmo dia (a vista)
			cData := DTOC(dDatabase+1)
		EndIf
		If !Empty(cData)
			cDia := Substring(cData,1,2)  
			cMes := Substring(cData,4,2)
			cAno := '20' +Substring(cData,7,2)    //-- necessario informar ano com 4 chars
			cData := ''
			cData := cDia+'/'+cMes+'/'+cAno
		EndIf   
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³XML para processamento da Quitacao do Contrato³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cXML += '<processo_transporte>'
			cXML += 	'<cliente_codigo>' + AllTrim(DEG->DEG_IDOPE) + '</cliente_codigo>'
			cXML += 	'<processo_cliente_codigo>' + cFilOri + cViagem + '</processo_cliente_codigo>'
			cXML += 	'<processo_cliente_filial_codigo_cliente/>'
			cXML += 	'<processo_transporte_codigo>' + AllTrim(Posicione('DTR',1,xFilial('DTR') + cFilOri + cViagem, 'DTR_PRCTRA')) + '</processo_transporte_codigo>'
			cXML += 	'<filial_codigo_cliente>' + cFilOri + '</filial_codigo_cliente>'
			if cVsRepom == '2' 
				cXML +=		'<peso_entrega>'+ Alltrim(Str(cPeso)) +'</peso_entrega>'
			else
				cXML +=		'<peso_entrega/>'
			endif
			cXML +=		'<avarias/>'
			cXML +=		'<ocorrencias/>'   
			cXML +=		'<quitacao_tipo>'+ '0' +'</quitacao_tipo>'                    //novo                
			If cVsRepom == '2'   
		   		cXML +=		'<data_prevista_pagamento>'+cData+'</data_prevista_pagamento>'               //novo   
			Else 
		   		cXML +=		'<data_prevista_pagamento></data_prevista_pagamento>'			 
			EndIf	
			cXML +=		'<novo_processo_cliente_codigo></novo_processo_cliente_codigo>'     //novo
			cXML +=		'<novo_processo_cliente_filial_codigo_cliente></novo_processo_cliente_filial_codigo_cliente>'   //novo
			cXML += '</processo_transporte>'

			//-- Gera XML em Disco
			If lTMSXML
				TMSLogXML( cXML, 'QuitaContrato.XML' )
			EndIf
		EndIf
                            
		If lTM251XML   	
			cXmlNew := Execblock("TM251XML",.F.,.F.,{cXML})
			If ValType( cXmlNew ) == 'C'
				cXML := cXmlNew
			EndIf			 	           
		EndIf 
		
		//-- Remove acentos e caracteres especiais
		cXML := TMSNoAcento( cXML )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ACIONA O WEBSERVICE ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oObj := WSIntegracao():New()
		oObj:cStrCliente           := AllTrim(DEG->DEG_IDOPE)
		oObj:cStrAssinaturaDigital := AllTrim(DEG->DEG_CODACE)
		oObj:cStrXMLIn             := cXML
		oObj:_URL                  := DEG->DEG_URLWS //-- Seta a URL conforme cadastro da Operadora

		If lQuitacao
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³REALIZACAO DA QUITACAO DO CONTRATO³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If oObj:QuitaContrato()
				If oObj:lQuitaContratoResult
					lRet := .T.
					//-- Remove os acentos do XML de Retorno
					oObj:cStrXMLOut := TMSNoAcento( oObj:cStrXMLOut )
		
					//-- Gera XML em Disco
					If lTMSXML
						TMSLogXML( oObj:cStrXMLOut, 'QuitaContratoResult.XML' )
					EndIf

					//-- Coverte em Objeto o XML de retorno enviado pela Operadora
					oXML := XMLParser( oObj:cStrXMLOut, '_', @cError, @cWarning )
				
					//-- Grava os dados da quitacao
					nValSaq := StrTran( oXML:_Recibo_Quitacao:_Processo_Transporte:_Movimentacao_Financeira:_Total_Saque:Text, ',', '' )
					nValCon := StrTran( oXML:_Recibo_Quitacao:_Processo_Transporte:_Movimentacao_Financeira:_Total_Consumo:Text, ',', '' )
					nSalPag := StrTran( oXML:_Recibo_Quitacao:_Processo_Transporte:_Valor_Final:Text, ',', '')
					nFrePag := StrTran( oXML:_Recibo_Quitacao:_Processo_Transporte:_Movimentacao_Financeira:_Valor_Frete:Text, ',', '' )
				
					nValSaq := Val( nValSaq )
					nValCon := Val( nValCon )
					nSalPag := Val( nSalPag )
					nFrePag := Val( nFrePag )
					
					DTY->(DbSetOrder(2))
					If DTY->(MsSeek(xFilial('DTY') + cFilOri + cViagem))
							RecLock('DTY',.F.)
							If DTY->DTY_LOCQUI == '1'
								DTY->DTY_STATUS := '1'
							EndIf
							MsUnLock()
					EndIf

					DES->(DbSetOrder(1))
					If DES->(MsSeek(xFilial('DES') + cFilOri + cViagem))  .AND. DES->DES_STATUS <> '2'
						RecLock('DES',.F.)
						DES->DES_DATQTC := dDataBase
						DES->DES_HORQTC := StrTran(Left(Time(),5),':','')
						DES->DES_VALSAQ := nValSaq
						DES->DES_VALCON := nValCon
						DES->DES_SALPAG := nSalPag
						DES->DES_STATUS := '2' //-- Quitacao Realizada
						MsUnLock()   
						
						//-- Gera Movto. de Custo de transporte referente aos valores de Saques e Consumos	   
						If !Empty(cDesAdf) .And. lRepom
							cQuery :=  ""
							cQuery += "SELECT DG_FILIAL, DG_FILORI, DG_VIAGEM, DG_CODVEI, DG_CODDES, DG_IDENT, DG_NUMSEQ, DG_SALDO  " 
							cQuery += " FROM " + RetSqlName("SDG") 
							cQuery += " WHERE DG_FILIAL = '" + xFilial('SDG') + "'"
							cQuery += " AND DG_FILORI = '"   + cFilOri  + "'"
							cQuery += " AND DG_VIAGEM = '"   + cViagem + "'" 
							cQuery += " AND DG_CODVEI = '"   + cCodVei + "'" 
							cQuery += " AND DG_CODDES = '"   + cDesAdf + "'" 
							cQuery += " AND D_E_L_E_T_ = ' '  "
							cAliasQry := GetNextAlias()
							cQuery := ChangeQuery(cQuery)
							dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)
							While !(cAliasQry)->(EoF())         
								If !Empty(cDesAbast) .And. nValCon > 0 
							   		TMSA070Bx("1",(cAliasQry)->DG_NUMSEQ,cFilOri,cViagem,cCodVei,,,nValCon,,(cAliasQry)->DG_IDENT,cDesAbast)   
								EndIf      
								If !Empty(cDesSaq) .And. nValSaq > 0 
							   		TMSA070Bx("1",(cAliasQry)->DG_NUMSEQ,cFilOri,cViagem,cCodVei,,,nValSaq,,(cAliasQry)->DG_IDENT,cDesSaq)   
								EndIf  
								(cAliasQry)->(DbSkip())
							EndDo  
							(cAliasQry)->(DbCloseArea()) 
										                //-- baixando SDG de Adiantamento
							cAliasQry := GetNextAlias()
							cQuery := ChangeQuery(cQuery)
							dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .T.)  
							While !(cAliasQry)->(EoF()) .And. (cAliasQry)->DG_SALDO > 0
								TMSA070Bx("1",(cAliasQry)->DG_NUMSEQ,cFilOri,cViagem,cCodVei,,,(cAliasQry)->DG_SALDO,,(cAliasQry)->DG_IDENT)
								(cAliasQry)->(DbSkip()) 
							EndDo     
							(cAliasQry)->(DbCloseArea()) 
						EndIf
						
						//-- Se pessoa fisica, aguarda consultacontrato para conseguir os valores do impostos e jogar na dty
						//-- se pessoa jurica, nao calcula impostos, deixa para libera o contrato direto 
						//--------------
						//** aMov[1] =  codigo Repom do Imposto
						//** aMov[2] =  valor do desconto  
						//** aMov[3] =  data e hora do mov     
					 	cTipPess :=	TmsXPess(cFilOri, cViagem, cCodVei)  	

						If Alltrim(cTipPess) == 'F'                      
						  	aMov := oXML:_Recibo_Quitacao:_Processo_Transporte:_Movimentacao_Financeira:_Movimentacoes:_Movimentacao							
							//-- Funcao com o result dos impostos <movimentacao>
							TmsxInImp(cFilOri, cViagem, aMov)
					   	EndIf 

						//-- Grava as observacoes
						cObs := oXML:_Recibo_Quitacao:_Mensagem:Text
				 //		MSMM(DES->DES_CODOBS,,,cObs,1,,,"DES","DES_CODOBS")
					EndIf

					//-- Gera Movto. de Custo de transporte referente aos valores de Saques e Consumos (Adtos.)
					If nValSaq > 0 .Or. nValCon > 0
						//-- Ajusta o Valor do Adto. no Contrato
						DTY->(DbSetOrder(2))
						If DTY->(MsSeek(xFilial('DTY') + cFilOri + cViagem))
							RecLock('DTY',.F.)
							DTY->DTY_ADIFRE := nValSaq + nValCon
							MsUnLock()
						EndIf
					EndIf
					//-- Atualiza Log de Transacoes
					TMSGerLog( cCodOpe, 'QT', 'E', xFilial('DES') + cFilOri + cViagem, 'DES', '0' )
    	   		Else
					aMsgErr := TMSErrOper(cCodOpe, oObj:cStrXMLErr, '1')
					lRet := .F.
				EndIf
			Else
				aMsgErr := TMSErrOper(cCodOpe,, '2')
				lRet := .F.
			EndIf
		EndIf
	EndIf    
	
	If lRet .And. lTM251Ope
		ExecBlock('TM251Ope',.F.,.F.,{cCodOpe, cFilOri, cViagem, cContrat, cCodVei, oXML, lQuitacao})  
	EndIf
	
EndIf

//-- Configura o tamanho do nome das Variaveis
SetVarNameLen( 10 )
RestArea(aArea)
RestArea(aAreaDTR)
Return( lRet ) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³TMA251Aut ³ Autor ³ Guilherme Gaiofatto   ³ Data ³ 16.01.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Realiza a Autorizacao do pagamento na a Operadora de Frota  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cExpC1 - Codigo da Operadora de Frotas                      ³±±
±±³          ³cExpC2 - Filial de Origem                                   ³±±
±±³          ³cExpC3 - Numero da Viagem                                   ³±±
±±³          ³aExpA1 - Array com as Mensagens de Erro (Por Referencia)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico - .T. indica sucesso no processamento do metodo      ³±±    
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function TMA251Aut( cCodOpe, cFilOri, cViagem, aMsgErr, aDadosQuit, cContrat, cCodVei, lQuitacao, cCond, cCodFor, cLojFor )
Local lRet     := .F.
Local cXML     := ''    
Local cXmlNew  := ''
Local oObj     := NIL
Local cError   := ''
Local cWarning := ''
Local aArea    := GetArea()
Local aAreaDTR := DTR->(GetArea())
Local aAreaDTY := {}
Local lTMSXML  := GetMV( 'MV_TMSXML',, .F. )    
Local oXML     := NIL               
Local cValFret := ''            
Local cLocQui  := ''  
Local cBanco   := ''  
Local cAgencia := ''  
Local cNumCon  := ''  
Local cDesSald  := SuperGetMV( 'MV_DESSALD',, '')
Local nDias	   := 0
Local aData	   := {}
Local lGravaDg := .T.
Local aAreaDg  := SDG->( GetArea() )     

//-- Configura o tamanho do nome das Variaveis
SetVarNameLen( 255 )

Default lQuitacao := .T. 
Default cCond    := ''
Default cCodFor  := ''
Default cLojFor  := '' 
Default cCodVei  := ''

// tento localizar na DTY se nao passar os dados via parametro
IF Empty( cCond )
	IF ( Empty( cCodFor ) .And. Empty( cLojFor ) )
		aAreaDTY := DTY->( getArea() )
		If DTY->(FieldPos("DTY_LOCQUI")) > 0
			DTY->(DbSetOrder(2))
			If DTY->(DbSeek(xFilial('DTY') + cFilOri + cViagem))
				cPeso    := DTY->DTY_PESO
				cValFret := DTY->DTY_VALFRE
				cCodFor  := DTY->DTY_CODFOR
				cLojFor  := DTY->DTY_LOJFOR
				cLocQui  := DTY->DTY_LOCQUI 
				If  Empty(cCodVei)
   		   			cCodVei := DTY->DTY_CODVEI
   	  			Endif
			EndIf
		EndIf
		RestArea( aAreaDTY )
	Endif
	
	// Localiza a a condicao de pagto do Fornecedor
	If !Empty(cCodFor) .And.!Empty(cLojFor)      
		SA2->(DbSetOrder(1))
		If SA2->(MsSeek(xFilial('SA2')+cCodFor+cLojFor))
			cCond	:= SA2->A2_COND
		EndIf
	EndIf
EndIf  

If !Empty(cCodFor) .And.!Empty(cLojFor)      
	SA2->(DbSetOrder(1))
	If SA2->(MsSeek(xFilial('SA2')+cCodFor+cLojFor))  
	     cCond	:= SA2->A2_COND
	EndIf
EndIf

DEG->(DbSetOrder(1))
If DEG->(MsSeek(xFilial('DEG')+cCodOpe))
	If cCodOpe == '01' //-- REPOM Tecnologia 
                                              
	    cBanco    := DEG->DEG_BANCO
		cAgencia  := DEG->DEG_AGENCI
		cNumCon   := DEG->DEG_NUMCON
		aData := Condicao(1,cCond,0,dDatabase)   //-- Conseguir a data Prevista para o pagamento, nao é necessario passar o valor exato.
		nDias := Abs( aData[1][1] - dDatabase )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³XML para processamento da Autorizacao de Pagamento³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cXML += '<autoriza_contratos>'
		cXML += 	'<autoriza_contrato>'
		cXML += 		'<dias>' + StrZero( nDias , 4) + '</dias>'
		cXML += 		'<usuario/>'
		cXML += 		'<contrato_codigo>' + AllTrim(Posicione('DTR',1,xFilial('DTR') + cFilOri + cViagem, 'DTR_PRCTRA')) + '</contrato_codigo>'
		cXML += 		'<processo_transporte_codigo_cliente>' + cFilOri + cViagem + '</processo_transporte_codigo_cliente>'
		cXML += 		'<processo_cliente_filial_codigo_cliente>' + cFilOri + '</processo_cliente_filial_codigo_cliente>'
		cXML += 	'</autoriza_contrato>'
		cXML += '</autoriza_contratos>'

		//-- Gera XML em Disco
		If lTMSXML
			TMSLogXML( cXML, 'AutorizaPagamento.XML' )
		EndIf
                            
		If lTM251XML   	
			cXmlNew := Execblock("TM251XML",.F.,.F.,{cXML})
			If ValType( cXmlNew ) == 'C'
				cXML := cXmlNew
			EndIf			 	           
		EndIf 
		
		//-- Remove acentos e caracteres especiais
		cXML := TMSNoAcento( cXML )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ACIONA O WEBSERVICE ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oObj := WSIntegracao():New()
		oObj:cStrCliente           := AllTrim(DEG->DEG_IDOPE)
		oObj:cStrAssinaturaDigital := AllTrim(DEG->DEG_CODACE)
		oObj:cStrXMLIn             := cXML
		oObj:_URL                  := DEG->DEG_URLWS //-- Seta a URL conforme cadastro da Operadora

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REALIZACAO DA AUTORIZACAO DE PAGAMENTO³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If oObj:AutorizaPagamento()
			If oObj:lAutorizaPagamentoResult
				If !Empty( oObj:cStrXMLOut )
					//-- Remove os acentos do XML de Retorno
					oObj:cStrXMLOut := TMSNoAcento( oObj:cStrXMLOut )
					//-- Gera XML em Disco
					If lTMSXML
						TMSLogXML( oObj:cStrXMLOut, 'AutorizaPagamentoResult.XML' )
					EndIf
					//-- Coverte em Objeto o XML de retorno enviado pela Operadora
					oXML := XMLParser( oObj:cStrXMLOut, '_', @cError, @cWarning )	   
									
					//-- Se houverem 7 tags de retorno no XMLOUT da Repom, significa que houveram ocorrencias
					//-- que impediram a autorizacao do pagamento do contrato
					If XMLChildCount( oXML:_Autoriza_Contratos:_Autoriza_Contrato ) == 7
						lRet := .F.
						AAdd( aMsgErr, { oXML:_Autoriza_Contratos:_Autoriza_Contrato:_Ocorrencia_Codigo:Text + ' -  ' + oXML:_Autoriza_Contratos:_Autoriza_Contrato:_Ocorrencia_Descricao:Text} )
					Else
						lRet := .T.
						
						//Grava Saldo do Pagamento.
						nSalPag := StrTran( oXML:_Autoriza_Contratos:_Autoriza_Contrato:_Valor_Final:Text, ',', '')					
						nSalPag := Val( nSalPag )
						
						DES->(DbSetOrder(1))
						If DES->(DbSeek(xFilial('DES') + cFilOri + cViagem))					
							RecLock('DES',.F.)
							DES->DES_SALPAG := nSalPag
							MsUnLock()						
						EndIf  
						
						// baixa SDG do saldo  
						// Verifica se será gravado a despesa da SDG
						If SuperGetMV( 'MV_VSREPOM',, '1' ) == '2' .And. !Empty(cDesSald) .And. nSalPag > 0				

							// Seta a gravacao do saldos do pagamento como verdadeiro. Ira verificar na validacao
							lGravaDg := .T.

							aAreaDg := SDG->( GetArea() )
							
							// Verifica se existe ja o DG salvo na base. Se existir nao efetuo a gravacao
							SDG->( DbSetOrder( 5 ) )
							SDG->( DbSeek( xFilial('SDG') + cFilOri + cViagem + cCodVei) )  
							While SDG->(!Eof()) .And. SDG->DG_FILIAL == xFilial('SDG') .And. SDG->DG_FILORI == cFilOri .And. SDG->DG_VIAGEM == cViagem .And.  SDG->DG_CODVEI == cCodVei
								If AllTrim(SDG->DG_CODDES) == AllTrim(cDesSald) 
									lGravaDg := .F.
									EXIT
					   			EndIF  
					 			SDG->(dbSkip()) 	
							Enddo 		
							
							SDG->( RestArea( aAreaDG ) )
							
							If lGravaDg
					  			TMA250GrvSDG('SDG', cFilOri, cViagem, cDesSald,  nSalPag,,cCodVei,,,,,,,,.T.,cBanco, cAgencia, cNumCon)
					  		Endif

						EndIf 							
					EndIf
				Else
					lRet := .T.
				EndIf
			Else
				aMsgErr := TMSErrOper(cCodOpe, oObj:cStrXMLErr, '1')
				lRet := .F.
			EndIf
		Else
			aMsgErr := TMSErrOper(cCodOpe,, '2')
			lRet := .F.
		EndIf
	ElseIf cCodOpe == '02'   
		aRetCNPJ   := PamCNPJEmp(cCodOpe, cFilOri) //Função para obter CNPJ da contrante e filial de origem 
		//--Gera Parcela Liberada na PAMCARD!
		lRet:= PamLibPaCt(cFilOri, cViagem, aRetCNPJ, cContrat) 		
	EndIf    
	
	If lRet .And. lTM251Ope
		ExecBlock('TM251Ope',.F.,.F.,{cCodOpe, cFilOri, cViagem, cContrat, cCodVei, oXML, lQuitacao})  
	EndIf
	
EndIf
//-- Configura o tamanho do nome das Variaveis
SetVarNameLen( 10 )

RestArea(aArea)
RestArea(aAreaDTR)
Return( lRet )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Rodolfo K. Rosseto    ³ Data ³04/04/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³	  1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef()
     
Private aRotina  := {	{ STR0005 ,"AxPesqui"     , 0 , 1,0,.F.},;	//"Pesquisar"
						{ STR0006 ,"TMSA250Vis()" , 0 , 2,0,.T.},;	//"Visualizar"
						{ STR0007 ,"TMSA251Lib()" , 0 , 3,0,.T.},;	//"Liberar"
						{ STR0008 ,"TMSA251Est()" , 0 , 4,0,.T.},;	//"Estornar Lib."
						{ STR0009 ,"TMSA250Leg()" , 0 , 5,0,.F.}}	//"Legenda"

If ExistBlock("TMA251MNU")
	ExecBlock("TMA251MNU",.F.,.F.)
EndIf

Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaHLP  ³ Autor ³Rodolfo K. Rosseto  ³ Data ³ 17/04/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Inclui os Helps                                     		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³TMSA251                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaHLP()
Local aHlpPor := {}
Local aHlpEsp := {}
Local aHlpIng := {}

AAdd(aHlpPor, "O Estorno da liberacao nao pode ser "	)
AAdd(aHlpPor, "realizado pela filial atual! "			)
AAdd(aHlpEsp, "La reversión de la liberación no se "	)
AAdd(aHlpEsp, "puede lograr por rama actual! "			)
AAdd(aHlpIng, "The Reversal of liberation can not be ")
AAdd(aHlpIng, "achieved by current branch!"				)
PutHelp("PTMSA25102",aHlpPor,aHlpIng,aHlpEsp,.F.		)

aHlpPor := {}
aHlpEsp := {}
aHlpIng := {}

AAdd(aHlpPor, "A Liberacao so pode ser realizada pela ")
AAdd(aHlpPor, "filial que incluiu o contrato! "			 )
AAdd(aHlpEsp, "Las versiones sólo puede ser ocupado "	 )
AAdd(aHlpEsp, "puede lograr por rama actual!"			 )
AAdd(aHlpIng, "The Releases can only be held by a "	 )
AAdd(aHlpIng, "subsidiary that included the contract!" )
PutHelp("PTMSA25103",aHlpPor,aHlpIng,aHlpEsp,.F.)

aHlpPor := {}
aHlpEsp := {}
aHlpIng := {}

AAdd(aHlpPor,"Para efetuar liberacao por outras "		 )
AAdd(aHlpPor,"filiais execute o Update TMS11R114, "	 )
AAdd(aHlpPor,"assim sera criado o campo DTY_FILLIB, "	 )
AAdd(aHlpPor,"que fara o controle da filial de "		 )
AAdd(aHlpPor,"liberacao do contrato!"						 )
AAdd(aHlpIng,"To make release by other branches "		 )
AAdd(aHlpIng,"TMS11R114 run the Update to the "			 )
AAdd(aHlpIng,"creation of the field DTY_FILLIB "		 )
AAdd(aHlpIng,"which will make the affiliate control "  )
AAdd(aHlpIng,"release of the contract!"			 	    )
AAdd(aHlpEsp,"Para que la liberación de otros poderes ")
AAdd(aHlpEsp,"TMS11R114, ejecutar la actualización a " )
AAdd(aHlpEsp,"la creación de la DTY_FILLIB campo, lo " )
AAdd(aHlpEsp,"que hará que la liberación de control"   )
AAdd(aHlpEsp,"de afiliados del contrato!"   				 )
PutHelp("STMSA25103" ,aHlpPor,aHlpIng,aHlpEsp,.F.)

PutSx1Help("P.TMA25101.",{'Informe o Contrato Inicial.'},{},{})
PutSx1Help("P.TMA25102.",{'Informe o Contrato Final.'},{},{})
PutSx1Help("P.TMA25103.",{'Informe a Data Inicial (Emissão do','Contrato) para processamento.'},{},{})
PutSx1Help("P.TMA25104.",{'Informe a Data Final (Emissão do','Contrato) para processamento.'},{},{})
PutSx1Help("P.TMA25105.",{'Informe o Proprietário Inicial para','processamento.'},{},{})
PutSx1Help("P.TMA25106.",{'Informe a Loja do Proprietário Inicial','para processamento.'},{},{})
PutSx1Help("P.TMA25107.",{'Informe o Proprietário Final para','processamento.'},{},{})
PutSx1Help("P.TMA25108.",{'Informe a Loja do Proprietário Final','para processamento.'},{},{})
PutSx1Help("P.TMA25109.",{'Informe o N.o da Filial de Origem','inicial para processamento.'},{},{})
PutSx1Help("P.TMA25110.",{'Informe o N.o da Viagem Inicial','para processamento.'},{},{})
PutSx1Help("P.TMA25111.",{'Informe o N.o da Filial de Origem','final para processamento.'},{},{})
PutSx1Help("P.TMA25112.",{'Informe o N.o da Viagem Final','para processamento.'},{},{})
PutSx1Help("P.TMA25113.",{'Informe quais contratos deverão ser','apresentados para processamento.'},{},{})

Return .T.
