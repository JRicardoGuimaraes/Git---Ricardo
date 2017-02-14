#include "PROTHEUS.ch"
#include "FILEIO.CH"
#include "FINA110.CH"

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes
// Alert( MTXMOEDA(113813.41,1,1,,,0) )
STATIC lFuncIrPj 	:= FindFunction("FIrPjBxCr")
STATIC lAtuSldNat
STATIC lFA110BUT	:= ExistBlock("FA110BUT")
STATIC lF110Rec		:= (ExistBlock("F110REC") )
STATIC lFa110Se5 	:= (ExistBlock("FA110SE5"))
STATIC lFa110Desc	:= (ExistBlock("FA110DES"))
STATIC lFa110Juros	:= (ExistBlock("FA110JUR"))
STATIC lFa110Mult	:= (ExistBlock("FA110MUL"))
STATIC lFina110  	:= (ExistBlock("FINA110" ))
STATIC lTFina110  	:= (ExistTemplate("FINA110"))
STATIC lCNI  		:= FindFunction("ValidaCNI")
Static lPcoInte
Static lBxCnab
Static cSldBxCr
Static cTpComiss
Static lFinImp  := FindFunction("FRaRtImp")       //Define se ha retencao de impostos PCC/IRPJ no R.A
Static lQuery
Static lFWCodFil := FindFunction("FWCodFil")	//Gestao
Static lTravaSa1 := ExistBlock("F110TRAVA")
Static lF110POSTIT := ExistBlock("F110POSTIT")
Static lFuncEC02 := FindFunction("LJ861EC02")
Static lFuncEC01 := FindFunction("LJ861EC01")
Static lFuncGetRt:= FindFunction( "GETROTINTEG" )
Static lFuncHasEAI:= FindFunction("FwHasEAI")
Static lFuncMltSld := FindFunction( "FXMultSld" )
Static lFuncDefTop :=  FindFunction("IfDefTopCTB")
Static lFuncIsPan := FindFunction("IsPanelFin")
Static lFuncPccBx := FindFunction("FPccBxCr")
Static lFuncSldNat := FindFunction("AtuSldNat")
Static lF110Fil := ExistBlock("F110FIL")
Static lFCalDesc	:= (ExistBlock("FCalDesc"))



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FINA110  � Autor � Mauricio Pequim Jr    � Data � 06/01/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Baixa Autom�tica de Titulos a Receber                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FINA110()                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Gen�rico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xFINA110(nOpcAuto,aTitulos)

Local nSavRec		:= Recno()

Private aAreaSM0		:= {}
Private cFil110
Private aRotina := MenuDef()
Private lOracle	:= "ORACLE"$Upper(TCGetDB())

//��������������������������������������������������������������Ŀ
//� Define o cabe�alho da tela de baixas                         �
//����������������������������������������������������������������
Private cCadastro	:= OemToAnsi( STR0003 ) // "Baixa de Titulos"

//��������������������������������������������������������������Ŀ
//� Verifica o n�mero do Lote                                    �
//����������������������������������������������������������������
Private cLote
Private cFilPos := SM0->M0_CODFIL

//Gestao
If lQuery == NIL
	lQuery := IF( lFuncDefTop, IfDefTopCTB(), .F.) // verificar se pode executar query (TOPCONN)
Endif
If !lQuery
	cBotFun := cTopFun := "xFilial('SE1')"
EndIf
LoteCont( "FIN" )

AjustaSx1()

//��������������������������������������������������������������Ŀ
//� Carrega fun��o Pergunte                                      �
//����������������������������������������������������������������
SetKey (VK_F12,{|a,b| AcessaPerg("FIN110",.T.)})
pergunte("FIN110",.F.)

//�����������������������������������������������Ŀ
//� Variaveis utilizadas para par�metros          �
//� mv_par01	Mostra Lan� Contabil               �
//� mv_par02   Aglutina Lancamentos               �
//� mv_par03   Contabiliza On-Line                �
//�������������������������������������������������
lDigita	:= IIF(mv_par01==1,.T.,.F.)
lAglut	:= IIF(mv_par02==1,.T.,.F.)

DEFAULT nOpcAuto := 0
DEFAULT aTitulos := {}

dbSelectArea("SE1")
SE1->(dbSetOrder(1))
SE1->(MSSeek(cFilial))

IF ExistBlock("F110BROW")
	ExecBlock("F110BROW",.f.,.f.)
Endif

aAreaSM0 := SM0->(GetArea())

If ( nOpcAuto > 0 )
		bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nOpcAuto,2 ] + "(a,b,c,d,e) }" )
		Eval( bBlock, Alias(), (Alias())->(Recno()),nOpcAuto,,aTitulos)
Else
	//��������������������������������������������������������������Ŀ
	//� Endereca a Fun��o de BROWSE                                  �
	//����������������������������������������������������������������
	mBrowse( 6, 1,22,75,"SE1",,,,,, Fa040Legenda("SE1"))

Endif
//��������������������������������������������������������������Ŀ
//� Recupera a Integridade dos dados                             �
//����������������������������������������������������������������
SE1->(DbClearFilter())
dbSelectArea("SE1")
dbSetOrder(1)
dbGoTo( nSavRec )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fA110Aut � Autor � Mauricio Pequim Jr    � Data � 06/01/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Baixa Autom�tica                                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Fa110Aut()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Gen�rico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FA110Aut(cAlias,cCampo,nOpcE,aM,aTitulos)
//��������������������������������������������������������������Ŀ
//� Define Vari�veis                                             �
//����������������������������������������������������������������
Local lPrjCni       := lCNI .And. ValidaCNI()
Local cIndex		:= ""
Local cChave		:= ""
Local cDescrMo		:= " "
Local cArquivo		:= ""
Local cNumero		:= ""
Local cPrefixo		:= ""
Local cParcela		:= ""
Local cCliente		:= ""
Local nTamSeq		:= TamSX3("E5_SEQ")[1]
Local cSequencia 	:= Replicate("0",nTamSeq)

Local nValAbat  	:= 0
Local nValorTotal	:= 0
Local nProxReg		:= 0
Local nRec			:= 0
Local nRegPrinc 	:= 0
Local nRegAtu		:= 0
Local nRecnoSe1	:= 0
Local nIndex		:= 0
Local nI				:= 0
Local nC				:= 0
Local nX 			:= 0
Local nOpca			:= 0
Local nTotal		:= 0
Local nHdlPrv		:= 0
Local nSaldoCru	:= 0
Local nSavOrd1		:= SE1->(IndexOrd())
Local nSaldo		:= 0
Local nSE1Rec 		:= 0

Local aTipoSeq		:= {}
Local aMotBx 		:= ReadMotBx()
Local aBaixas 		:= {}
Local aBxSE5	     := {}
Local x
Local aDescMotbx	:= {}
Local aArea			:= GetArea()
Local aButtons		:= {}
Local aFlagCTB		:= {}
Local aRecFlag		:= {}

Local lGravaAglut	:= .T.
Local lAcreDecre 	:= .F.
Local lInverte		:= .F.
Local lEof			:= .F.
Local lPadrao 		:= .F.
Local lGerTotal 	:= .F.
Local lDigita		:= IIF(mv_par01==1,.T.,.F.)
Local lAglut		:= IIF(mv_par02==1,.T.,.F.)
Local lDesconto 	:= IIF(mv_par04 == 1, .T., .F. )
Local lJuros  		:= IIF(mv_par05 == 1, .T., .F. )
Local lUsaFlag		:= SuperGetMV( "MV_CTBFLAG", .T./*lHelp*/, .F./*cPadrao*/ )
Local lBxCnab		:= GetMv("MV_BXCNAB") == "S"
Local lSpbInUse 	:= SpbInUse()
Local lPanelFin	:= If (lFuncIsPan,IsPanelFin(),.F.)

Local oDlg
Local oDlg1
Local oQtda
Local oCbx
Local oValor		:= 0
Local oBanco110	:= ""
//Controle de timer para que o usuario nao fique travando os registros
Local oTimer
Local nTimeOut  	:= SuperGetMv("MV_FATOUT",,900)*1000 	// Estabelece 15 minutos para que o usuarios selecione os titulos a faturar
Local nTimeMsg  	:= SuperGetMv("MV_MSGTIME",,120)*1000 	// Estabelece 02 minutos para exibir a mensagem para o usu�rio
                                                      		// informando que a tela fechar� automaticamente em XX minutos

//Controla o Pis Cofins e Csll na baixa  (1-Retem PCC na Baixa ou 2-Retem PCC na Emiss�o(default) )
Local lPccBxCr	:= If (lFuncPccBx,FPccBxCr(),.F.)
//Controla IRPJ na baixa
Local lIrPjBxCr		:= If (lFuncIrPj,FIrPjBxCr(),.F.)
Local nBaseIr 	:= 0

Local nLoop		:= 0
Local cModRetPIS:= SA1->A1_ABATIMP
LOCAL nSalvRec	:= SE1->(Recno())
Local lAplVlMin := .T.
Local nVlMinImp := GetNewPar("MV_VL10925",5000)
//Variavel para armazenar o tipo original do titulo originador
Local cTipoOr	:= ""
//Controle de Rotina Automatizada
Local lF110Auto := .F.
Local nY := 0
Local lSetAuto := .F.
Local lSetHelp := .F.
Local lAtuSalDup:= .T.
Local cFilOld := ""
Local nSomaCheq	:= 0
Local lTitPai	:= SE1->(FieldPos("E1_TITPAI")) # 0
Local lFilDes	:= !Empty( SFQ->( FieldPos( "FQ_FILDES" ) ) )
Local lGemSE1Grv := ExistTemplate("GEMSE1Grv")
Local lGemSE5Grv := ExistTemplate("GEMSE5Grv")
Local lRmClass	:= GetNewPar("MV_RMCLASS", .F.)
Local lRmBibli := GetNewPar("MV_RMBIBLI",.F.)
Local lExistSFQ := AliasIndic("SFQ")
Local lLjAtuSa	 := SuperGetMv("MV_LJATUSA",,.F.)
Local lMovBcoBx := .T.
Local lFa110Tot:= ExistBlock("FA110TOT")
//Controle de abatimento
Local lTitpaiSE1 := (SE1->(FieldPos("E1_TITPAI")) > 0)
Local nOrdTitPai:=0
Local cTipo
Local bWhile := {|| !Eof() .And. E1_FILIAL  == xFilial("SE1") .And. E1_CLIENTE == cCliente .And. E1_LOJA == cLoja .And. E1_PREFIXO == cPrefixo	.And. E1_NUM== cNumero .And. E1_PARCELA == cParcela }
Local nValImp := 0
Local lRaRtImp  := lFinImp .And.FRaRtImp()        //Define se ha retencao de impostos PCC/IRPJ no R.A
Local nTotAdto   := 0       //PAM
Local lBaixaAbat := .F.
Local nVlrBaixa  := 0
Local lBxCec     := .F.
//Gestao
Local aSelFil	:= {}
Local aTmpFil	:= {}
Local cAliasSe1 := "SE1"
Local lF110QRCP	:= ExistBlock("F110QRCP")
Local aCampos	:= {}
Local cFilAtu	:= cFilAnt
Local cFilOrig	:= cFilAnt
Local cFilCTB	:= ""
Local nLenFil	:= 1
Local lBxLiq	:= .F.
Local cQuery		:= ""
Local aRecNoAbat	:= {}			// RecNo's SE1 para registros de abatimento para atualiza��o em lote.
Local i				:= 0 			// Auxiliar para contadores
Local dBKPDTBase	:= dDataBase	// Copia para restaurar no final
Local lRetISS 		:= GetMV("MV_MRETISS") == "1"

Local nRecSM0	:= SM0->( RecNo() )
Local nTamCli	:= TamSX3("E1_CLIENTE")[1]
Local lGestao   := Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
Local cSA6Emp	:= FWModeAccess("SA6",1)
Local cSA6UNe	:= FWModeAccess("SA6",2)
Local cSA6Fil	:= FWModeAccess("SA6",3)
Local lSA6Access := Iif( lGestao, cSA6UNe == "E", cSA6Fil == "E" )
Local lSE1Access := Iif( lGestao, FWModeAccess("SE1",1) == "C", FWModeAccess("SE1",3) == "C")
/*Gest�o Corporativa*/
Local cTopFun := "xFilial('SE1',Space(FWSizeFilial()) )"
Local cBotFun := "xFilial('SE1',Replicate('Z',FWSizeFilial()) )"
Local lF110SE5  := Existblock("F110SE5")
Local aRecSe5 := {}
Local lF110CPOS := ExistBlock("F110CPOS")
Local lSitef	  := Funname() == "FINA910"

PRIVATE cLoteFin 	:= Space(TamSX3("E5_LOTE")[1])
PRIVATE cBco110 	:= CRIAVAR("A6_COD")
PRIVATE cAge110 	:= CRIAVAR("A6_AGENCIA")
PRIVATE cCta110 	:= CRIAVAR("A6_NUMCON")
PRIVATE cCliDe  	:= CRIAVAR("E1_CLIENTE")
PRIVATE cCliAte 	:= CRIAVAR("E1_CLIENTE")
PRIVATE cMotBx		:= CriaVar("E5_MOTBX")
PRIVATE nMulta		:= 0
PRIVATE nDescont	:= 0
PRIVATE nCorrec		:= 0
PRIVATE nJuros		:= 0
PRIVATE cPadrao		:= "520"
PRIVATE cBord110	:= CriaVar("E1_NUMBOR")
PRIVATE cBcoDe		:= CriaVar("E1_PORTADO")
PRIVATE cBcoAte		:= CriaVar("E1_PORTADO")
PRIVATE cPortado	:= CriaVar("E1_PORTADO")
PRIVATE dVencIni	:= dDataBase
PRIVATE dVencFim	:= dDataBase
PRIVATE cMarca		:= GetMark()
PRIVATE nTotAbat	:= 0				// Utilizada por Fa070Data
PRIVATE dBaixa 		:= dDataBase	// Utilizada por Fa070Data
PRIVATE dDtCredito 	:= dBaixa		// Utilizada por Fa070Data
PRIVATE cBanco		:= cBco110
PRIVATE cAgencia	:= cAge110
PRIVATE cConta		:= cCta110
PRIVATE nCM1 		:= 0
PRIVATE nProRata	:= 0
PRIVATE nDescGeral  := 0
PRIVATE aBaixaSE5 := {}
//PCC Baixa CR
PRIVATE nPis 		:= 0
PRIVATE nCofins   := 0
PRIVATE nCsll		:= 0
PRIVATE aDadosRef := Array(7)
PRIVATE aDadosRet := Array(7)
PRIVATE nVlRetPis	:= 0
PRIVATE nVlRetCof	:= 0
PRIVATE nVlRetCsl	:= 0
PRIVATE nDiferImp	:= 0
PRIVATE nValRec		:= 0
PRIVATE nOldValRec	:= 0
PRIVATE lRetParc  	:= .T.
PRIVATE nAcresc   	:= 0
PRIVATE nDecresc  	:= 0
PRIVATE nMoedaBco	:= 1
PRIVATE lBloqSa1   := .T.
//IR Baixa CR
PRIVATE nIrrf 		:= 0
PRIVATE nQtdeByt	:= 0 			// Limite de bytes para que o len(cFiltro) n�o d� erro
PRIVATE lGrtFil	:= .F.
PRIVATE nSFilPos	:= 0
PRIVATE lResp		:= .F.

//Baixa Automatizada
DEFAULT aTitulos	:= {}
Default lPcoInte	:= GetMV("MV_PCOINTE") == "1"
Default lBxCnab		:= GetMv("MV_BXCNAB") == "S"
Default cSldBxCr 	:= GetMv("MV_SLDBXCR")
Default cTpComiss 	:= GetMv("MV_TPCOMIS")
DEFAULT lAtuSldNat 	:= lFuncSldNat .AND. AliasInDic("FIV") .AND. AliasInDic("FIW")

If Len(aTitulos) >=9 .and. ValType(aTitulos[09]) == "L" .AND. aTitulos[09]
	// vindo da conciliacao SITEF para considerar a data de credito como a data de baixa
	dBaixa := aTitulos[08]
EndIf

cFilOld := cFilAnt
cFilAnt := cFilPos

aFill(aDadosRef,0)
aFill(aDadosRet,0)

// Zerar variaveis para contabilizar os impostos da lei 10925.
VALOR5 := 0
VALOR6 := 0
VALOR7 := 0

PIS			:= 0
COFINS		:= 0
CSLL		:= 0

// o browse posiciona a SM0 baseado no titulo posicionado, o que n�o se deve usar na rotina automatica
If TYPE("aAreaSM0") <> "U"
	RestArea(aAreaSM0)
Endif

//��������������������������������������������������������������Ŀ
//� Verifica se data do movimento � menor que data limite de     �
//� movimentacao no financeiro                                   �
//����������������������������������������������������������������
If SuperGetMv("MV_BXDTFIN",,"1") == "2" .and.!DtMovFin()
	dDataBase:= dBKPDTBase
	Return
Endif
//verifica se existem os campos de valores de acrescimo e decrescimo no SE5
If SE5->(FieldPos("E5_VLACRES")) > 0 .and. SE5->(FieldPos("E5_VLDECRE")) > 0
	lAcreDecre := .T.
Endif

//Verificar ou nao o limite de 5000 para Pis cofins Csll
// 1 = Verifica o valor minimo de retencao
// 2 = Nao verifica o valor minimo de retencao
If !Empty( SE1->( FieldPos( "E1_APLVLMN" ) ) ) .and. SE1->E1_APLVLMN == "2"
	lAplVlMin := .F.
Endif

//Gestao
If lQuery == NIL
	lQuery := IF( lFuncDefTop, IfDefTopCTB(), .F.) // verificar se pode executar query (TOPCONN)
Endif
If !lQuery
	cBotFun := cTopFun := "xFilial('SE1')"
EndIf
//������������������������������������������������������������������Ŀ
//� A fun��o SomaAbat reabre o SE1 com outro nome pela ChkFile para  �
//� efeito de performance. Se o alias auxiliar para a SumAbat() n�o  �
//� estiver aberto antes da IndRegua, ocorre Erro de & na ChkFile,   �
//� pois o Filtro do SE1 uptrapassa 255 Caracteres.                  �
//��������������������������������������������������������������������
SomaAbat("","","","R")

//Verifico se houve chamada Automatizada
If !Empty(aTitulos)

	//Composi��o de aTitulos
	//aTitulos [1]:= aRecnos	(array contendo os Recnos dos registros a serem baixados)
	//aTitulos [2]:= cBanco 	(Banco da baixa)
	//aTitulos [3]:= cAgencia	(Agencia da baixa)
	//aTitulos [4]:= cConta		(Conta da baixa)
	//aTitulos [5]:= cCheque	(Cheque da Baixa - apenas Contas a Pagar)
	//aTitulos [6]:= cLoteFin	(Lote Financeiro da baixa)
	//aTitulos [7]:= cNatureza	(Natureza do movimento bancario - apenas Contas a Pagar)
	//aTitulos [8]:= dBaixa		(Data da baixa)

	lF110Auto := .T.

	//Caso a contabilizacao seja online
	//E a tela de contabilizacao possa ser mostrada em caso de erro no lancamento
	//(falta de conta, debito/credito nao batem, etc)
	//A baixa automatica em lote nao podera ser utilizada.
	//Somente sera processada se:
	//MV_PRELAN = S
	//MV_CT105MS = N
	//MV_ALTLCTO = N
	If mv_par03 == 1 .and. FindFunction("CTBINTRAN") .and. !CTBINTRAN(1,.F.)
		dDataBase:= dBKPDTBase
		Return
	Endif
Endif

While .T.

	nRec := SE1->( RecNo() )

	nOpca		:= 0
	nDescGeral  := 0

	cMotBx	:= "NORMAL"
	If Empty(cCliAte)
		cCliAte := Replicate("Z",Len(SE1->E1_CLIENTE))
	Endif
	//�������������������������������������������������������������Ŀ
	//� Retorna o Array aDescMotBx contendo apenas a descricao do   �
	//� motivo das Baixas.									 					 �
	//���������������������������������������������������������������
	For nI := 1 to len( aMotBx )
		If Substr(aMotBx[nI],34,01) == "A" .or. Substr(aMotBx[nI],34,01) =="R"
			AADD( aDescMotbx,Substr(aMotBx[nI],07,10))
		EndIf
	Next

	UltiLote()

	//Se for rotina normal (nao automatizada)
	If !lF110Auto

		If lPanelFin .And. !lResp
			oPanelDados := FinWindow:GetVisPanel()
			oPanelDados:FreeChildren()
			aDim := DLGinPANEL(oPanelDados)
			DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0, 0 TO 0, 0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
			oDlg:lMaximized := .F.
			//����������������������������������������������������������������Ŀ
			//� Observacao Importante quanto as coordenadas calculadas abaixo: �
			//� -------------------------------------------------------------- �
			//� a funcao DlgWidthPanel() retorna o dobro do valor da area do	 �
			//� painel, sendo assim este deve ser dividido por 2 antes da sub- �
			//� tracao e redivisao por 2 para a centralizacao. 					 �
			//������������������������������������������������������������������
			nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 150) /2
			nEspLin  := 0
		ElseIf !lResp
			DEFINE MSDIALOG oDlg FROM 30,16 To 280, 300  TITLE OemToAnsi(STR0010) PIXEL //"Baixa Autom�tica"
			nEspLarg := 0
			nEspLin  := 0

		Endif

		If !lResp
			oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,40,40,.T.,.T. )
			oPanel:Align := CONTROL_ALIGN_ALLCLIENT

			@ 002,002+nEspLarg TO 107, 142+nEspLarg PIXEL OF oPanel

			@ 004,005+nEspLarg SAY OemToAnsi(STR0007) SIZE 40,08 PIXEL OF oPanel // "Vencimento"
			@ 013,005+nEspLarg MSGET dVencIni SIZE 45,08  PIXEL OF oPanel HASBUTTON
			@ 013,060+nEspLarg SAY	OemToAnsi(STR0006) SIZE 10,08  PIXEL OF oPanel // "at� "
			@ 013,080+nEspLarg MSGET dVencFim Valid dVencFim >= dVencIni SIZE 50,08  PIXEL OF oPanel HASBUTTON

			@ 023,005+nEspLarg SAY OemToAnsi(STR0005) SIZE 40,08 PIXEL OF oPanel // "Cliente "
			@ 032,005+nEspLarg MSGET cCliDe	F3 "CLI"  SIZE 45,08  PIXEL OF oPanel HASBUTTON
			@ 032,060+nEspLarg SAY	OemToAnsi(STR0006) SIZE 10,08  PIXEL OF oPanel // "at� "
			@ 032,080+nEspLarg MSGET cCliAte	F3 "CLI" VALID cCliAte >= cCliDe SIZE 45,08  PIXEL OF oPanel HASBUTTON

			@ 042,005+nEspLarg SAY	OemToAnsi(STR0008) SIZE 40,08  PIXEL OF oPanel // "Mot.Baixa"
			@ 051,005+nEspLarg COMBOBOX oCbx VAR cMotBx ;
							ITEMS aDescMotBx SIZE 65, 47  PIXEL OF oPanel ;
							Valid (ShowMotBx("R",.T.), cBco110:= CRIAVAR("A6_COD"),;
														cAge110:= CRIAVAR("A6_AGENCIA"),;
														cCta110:= CRIAVAR("A6_NUMCON"))

			@ 063,005+nEspLarg Say OemToAnsi(STR0019) SIZE 30,08  PIXEL OF oPanel  // "Banco : "
		  	@ 072,005+nEspLarg MSGET oBanco110 VAR cBco110 F3 "SA6" When MovBcoBx(cMotBx, .T.) Valid CarregaSa6(@cBco110,,,.T.) SIZE 30,08  PIXEL OF oPanel HASBUTTON
			@ 063,040+nEspLarg Say OemToAnsi(STR0020) SIZE 30,08  PIXEL OF oPanel // "Ag�ncia : "
		  	@ 072,040+nEspLarg MSGET cAge110 When MovBcoBx(cMotBx, .T.) Valid CarregaSa6(@cBco110,@cAge110,,.T.) SIZE 30,08 PIXEL OF oPanel HASBUTTON
			@ 063,080+nEspLarg Say OemToAnsi(STR0021) SIZE 30,08  PIXEL OF oPanel // "Conta : "
		  	@ 072,080+nEspLarg MSGET cCta110 When MovBcoBx(cMotBx, .T.) Valid If(CarregaSa6(@cBco110,@cAge110,@cCta110,.T.,,.T.),.T.,oBanco110:SetFocus()) PIXEL OF oPanel SIZE 60,08 HASBUTTON


			@ 082,005+nEspLarg SAY	OemToAnsi(STR0009) SIZE 40,08  PIXEL OF oPanel	// "Border�"
			@ 091,005+nEspLarg MSGET cBord110 Picture "@S6" SIZE 65,08 PIXEL OF oPanel ;
									Valid F110BXBORD() .and. IIF(!MovBcoBx(cMotBx, .T.),Empty(cBord110),.T.)	HASBUTTON

			@ 082,080+nEspLarg SAY STR0023  PIXEL OF oPanel SIZE 40,08 //"Lote"
			@ 091,080+nEspLarg MSGET cLoteFin Picture "@!" When !Empty(cBord110) .And. lBxCnab  Valid CheckLote("R")  SIZE 60,08 PIXEL OF oPanel HASBUTTON


			If lPanelFin
				// posiciona dialogo sobre a celula
				oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])
				ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,	{|| nOpca := 1,If(Fa110TudOk(lBxCnab),oDlg:End(),nOpca:=0)},;
																	{|| oDlg:End()},,,.F.)
				FinVisual(cAlias,FinWindow,(cAlias)->(Recno()),.T.)

			Else
				DEFINE SBUTTON FROM 110,083 TYPE 1 ACTION (nOpca := 1,If(Fa110TudOk(lBxCnab),oDlg:End(),nOpca:=0)) ENABLE OF oDlg
				DEFINE SBUTTON FROM 110,113 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
				ACTIVATE MSDIALOG oDlg CENTER

			Endif
		EndIf

		If nOpca == 0 .And. !lResp
			Exit
		EndIf

	   nRec := SE1->( RecNo() )
	   lGerTotal := (!Empty(cBord110) .And. lBxCnab)

		//Gestao
		//Selecao de filiais
		If lQuery .And. !lResp
			If mv_par10 == 1
				//SA6 exclusivo nao permite a selecao de filiais
				If lSA6Access
					Help( ,, 'SA6_COMPART',,;
							STR0033+CRLF+;		//"O compartilhamento do cadastro de Bancos (tabela SA6) n�o permite a sele��o de filiais."
							STR0034+CRLF+;		//"O processo ser� feito considerando apenas titulos da filial corrente."
						   	" "+CRLF+;
						   	STR0035+CRLF+;  	//"Compartilhamento da tabela SA6:"
							STR0036+If(cSA6Emp == "C",STR0039,STR0040)+CRLF+;		//"Empresa    : "###"Compartilhado"###"Exclusivo"
							STR0037+If(cSA6UNe == "C",STR0039,STR0040)+CRLF+;		//"Un. Neg�cio: "###"Compartilhado"###"Exclusivo"
							STR0038+If(cSA6Fil == "C",STR0039,STR0040)+CRLF+;  		//"Filial     : "###"Compartilhado"###"Exclusivo"
						   	" "+CRLF+;
							STR0041+CRLF+;		//"(Para que esta mensagem deixe de ser apresentada, altere a pergunta (F12) "
							STR0042,1,0)		//"<Seleciona Filiais?> para N�o.)"

					aSelFil := { cFilAnt }

				//SE1 totalmente compartilhado nao habilita tela de selecao de filiais
				ElseIf lSE1Access
					aSelFil := { cFilAnt }

			    ElseIf Len( aSelFil ) <= 0
					aSelFil := AdmGetFil(.F.,.T.,"SE1")
					nLenFil := Len( aSelFil )
					If nLenFil <= 0
						Exit
					EndIf
				Endif
			Else
				aSelFil := { cFilAnt }
			EndIf
		Endif
		If !Empty(cBord110)
			// Considerar todos os vencimentos para baixar todos do bordero
			dVencIni := CtoD("01/01/1980","ddmmyy")
			dVencFim := CtoD("31/12/2049","ddmmyy")
			cCliDe  := Space(nTamCli)
			cCliAte := Replicate("Z",nTamCli)
			//���������������������������������������������������������������Ŀ
			//� Verifica se bordero pode baixado ou n�o. 							�
			//�����������������������������������������������������������������
			lBxBord := f110BxBord()
			If !lBxBord
				Exit
			Endif
		Endif

		//���������������������������������������������������������������Ŀ
		//� PONTO DE ENTRADA F110FIL                                      �
		//� ExecBlock que retornara chave complementar do filtro da sele- �
		//� ��o de contas a receber a serem baixadas.                     �
		//�����������������������������������������������������������������
		IF lF110Fil
			cFil110 := ExecBlock("F110FIL",.f.,.f.)
		Else
			cFIl110 := ""
		Endif

		dbSelectArea( cAlias )

		//��������������������������������������������������������������Ŀ
		//� Monta express�o do Filtro para sele��o                       �
		//����������������������������������������������������������������
		cAliasSe1	:= "SE1"
		cIndex		:= CriaTrab(nil,.f.)
		cChave		:= IndexKey()
		nOldIndex	:= IndexOrd()
		lGrtFil	:= .F.
		nQtdeByt	:= 0
		nQtdeByt 	+= 2000 - (len(cIndex) + len(cChave) + 320) // 320 = 27 (STR0011) + 10 ("SE1" + 5) + 283 (len(cFiltro) - len(cFiliais))
		IndRegua("SE1",cIndex,cChave,,FA110ChecF(aSelFil),OemToAnsi( STR0011 ) ) // "Selecionando Registros..."
		nIndex := RetIndex("SE1")

		lResp := .F.

		If lGrtFil
			lResp := MsgYESNO("STR0048" + aSelFil[nSFilPos] + chr(10) + chr(13) + "STR0049", "QTDE_FILIAIS" )
		EndIf

		dbSelectArea("SE1")
		#IFNDEF TOP
			SE1->(dbSetIndex(cIndex+OrdBagExt()))
		#ENDIF
		SE1->(dbSetOrder(nIndex+1))
		#IFNDEF TOP
			SE1->(dbGoTop())
		#ENDIF

		If (cAliasSE1)->(Bof()) .And. (cAliasSE1)->(Eof())
			Help(" ",1,"RECNO")
			RetIndex("SE1")
			Set Filter to
			Exit
		EndIf
		nValor	:= 0    // valor total dos titulos,mostrado no rodap� do browse
		nQtdTit	:= 0    // quantidade de titulos,mostrado no rodap� do browse
		nOpcA		:= 0
		nValorTotal := 0

		nMoedaBco	:= Max(SA6->A6_MOEDA,1)
		//Gestao
		AADD(aCampos,{"E1_OK","","  ",""})
		dbSelectArea("SX3")
		SX3->(dbSetOrder(1))
		SX3->(MsSeek("SE1"))
		While SX3->(!EOF()) .And. (SX3->X3_ARQUIVO == "SE1")
			IF ( X3USO(SX3->X3_USADO) .or. ;
				 Alltrim(SX3->X3_CAMPO) $ "E1_SALDO|E1_PORTADO|E1_NUMBOR" .OR. ;
				 ( Alltrim(SX3->X3_CAMPO) == "E1_FILIAL" .and. Len(aSelFil) > 0 )) ;
				.AND. cNivel >= SX3->X3_NIVEL .AND. SX3->X3_CONTEXT != "V"
				AADD(aCampos,{SX3->X3_CAMPO,"",X3Titulo(),SX3->X3_PICTURE})
			Endif
			SX3->(dbSkip())
		Enddo

		//Ponto de entrada para tratamento dos campos a serem demonstrados na tela de selecao dos titulos
		If lF110CPOS
			aCampos := EXECBLOCK("F110CPOS",.F.,.F.,aCampos)
		Endif

		//Traz titulos pre-marcados
		//Utilizado apenas na rotina manual. Nao utilizar na rotina automatica
		If mv_par09 == 1
			Fa110Marca("SE1",cMarca,aTitulos)
		Endif

		nDescont := nDescGeral

		//������������������������������������������������������Ŀ
		//� Faz o calculo automatico de dimensoes de objetos     �
		//��������������������������������������������������������
		aSize := MSADVSIZE()

		DEFINE MSDIALOG oDlg1 TITLE STR0004 From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL	// "      Baixas Autom�ticas      "
		oDlg1:lMaximized := .T.
		oTimer:= TTimer():New((nTimeOut-nTimeMsg),{|| MsgTimer(nTimeMsg,oDlg1) },oDlg1) // Ativa timer
		oTimer:Activate()

		oPanel := TPanel():New(0,0,'',oDlg1,, .T., .T.,, ,15,15,.T.,.T. )
		oPanel:Align := CONTROL_ALIGN_TOP

		@003,005	Say STR0012  SIZE 50,10 PIXEL Of oPanel 	// "Valor Total:"
		@003,060	Say oValor	 VAR nValor		Picture "@E 999,999,999.99" SIZE 50,10  PIXEL Of oPanel
		@003,150	Say STR0013  SIZE 50,10 PIXEL Of oPanel 	// "Quantidade:"
		@003,200	Say oQtda	 VAR nQtdTit	Picture "@E 99999" SIZE 50,10  PIXEL Of oPanel

		oMark		:= MsSelect():New(cAliasSE1,"E1_OK","!E1_SALDO",aCampos,@lInverte,@cMarca,{18,oDlg1:nLeft,oDlg1:nBottom,oDlg1:nRight},cTopFun,cBotFun)

		if lPrjCni
			oMark:bMark	:= {||finadisplay("  " ,lInverte,oValor,oQtda,"R")}
        Else
			oMark:bMark	:= {||finadisplay(cMarca,lInverte,oValor,oQtda,"R")}
		EndIf

		oMark:bAval	:= {||Fa110bAval(cAliasSE1,cMarca,oValor,oQtda,oMark,@nValor)}
		oMark:oBrowse:lhasMark		:= .t.
		oMark:oBrowse:lCanAllmark	:= .t.
		oMark:oBrowse:bAllMark		:= { || Fa110Inverte(cAliasSE1,cMarca,oValor,oQtda,.T.,oMark,@nValor)}
		oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

		// Ponto de entrada para inclusao de botao
		If lFA110BUT
			aButtons := Execblock("FA110BUT",.F.,.F.,)
		Endif

		If lF110POSTIT
		   ExecBlock("F110POSTIT", .F., .F.)
		Endif

		If lFuncIsPan .and. IsPanelFin()
			ACTIVATE MSDIALOG oDlg1 ON INIT FaMyBar( oDlg1,{|| Iif( FA110BtOk(), (nOpca := 1,oDlg1:End()), nOpca := 0) },{|| nOpca := 0,ODlg1:End()},aButtons )
		Else
			ACTIVATE MSDIALOG oDlg1 ;
			ON INIT EnchoiceBar( oDlg1,{|| Iif( FA110BtOk(), (nOpca := 1,oDlg1:End()), nOpca := 0) },{|| nOpca := 0,ODlg1:End()},,aButtons ) CENTER
		Endif
		If nOpca <> 1
			If __lSX8
				RollBackSX8()
			Endif
			// Destrava os registros.
			dbSelectArea("SE1")
			dbGoTop()
			While !EOF()
				If E1_OK == cMarca
					fa110Blank()
				Endif
				IF !lQuery .and. SE1->E1_FILIAL != xFilial("SE1")
					dbSkip()
					Loop
				Endif
				If lFCalDesc
					ExecBlock("FCalDesc",.F.,.F.,{"",0},)
				Endif
				SE1->(MsUnlock())
				dbSkip()
			Enddo

			dbSelectArea("SE1")
			RetIndex("SE1")
			Set Filter to
			dbSetOrder(nSavOrd1)
			lResp := .F.
			nSFilPos := 0
			If lF110CPOS
				aCampos := {}
			Endif
			Loop
		Endif

		dbSelectArea( "SE1" )

		IF nValor == 0
			Exit
		EndIF

		If __lSX8
			ConfirmSX8()
		Endif

	Else

		//Rotina Automatizada
		nValor		:= 0    // valor total dos titulos,mostrado no rodap� do browse
		nQtdTit		:= 0    // quantidade de titulos,mostrado no rodap� do browse
		nOpcA		:= 0
		nValorTotal := 0
	   nRec			:= SE1->( RecNo() )
	   lGerTotal 	:= lBxCnab

		cBco110 	:= aTitulos[2]
		cAge110 	:= aTitulos[3]
		cCta110 	:= aTitulos[4]
		cLoteFin 	:= aTitulos[6]

		nMoedaBco 	:= Max( MoedaBco(cBco110,cAge110,cCta110), 1)

		Fa110Marca("SE1",cMarca,aTitulos[1])
		nDescont := nDescGeral

		nY			:= 1
		nLast 		:= Len(aTitulos[1])

	Endif

	nI :=  Ascan(aMotBx, {|x| Substr(x,1,3) == TrazCodMot(cMotBx) })
	cDescrMo := if( nI > 0,Substr(aMotBx[nI],07,10),"" )

	dbSelectArea("SE1")
	MsUnlockall()
	ChkFile("SE1",.f.,"ABAT")

	//Rotina Padrao (nao automatizada)
	If !lF110Auto
		dbSelectArea(cAliasSe1)
		dbGoTop()

		If !Empty(cBord110)
			//�������������������������������������������Ŀ
			//� Procura o primeiro registro com carteira  �
			//� igual a "R"                               �
			//���������������������������������������������
			dbSelectArea( "SEA" )
			dbSetOrder(2)		//EA_FILIAL+EA_NUMBOR+EA_CART
			If MSSeek( xFilial("SEA")+cBord110+"R" )

				//�������������������������������������������Ŀ
				//� Posiciona no banco para a contabilizacao  �
				//���������������������������������������������
				dbSelectArea("SA6")
				dbSetOrder(1)
				MSSeek(xFilial("SA6") + SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON)
				dbSelectArea("SEA")
				cBco110 := SA6->A6_COD
				cAge110 := SA6->A6_AGENCIA
				cCta110 := SA6->A6_NUMCON
				nMoedaBco := Max(SA6->A6_MOEDA, 1)
			Else
				cBord110 := Space(6)				// portanto limpa a variavel
			Endif
		EndIf
   Endif

	//���������������������������������������������Ŀ
	//� Inicia processo de integracao com o SIGAPCO �
	//�����������������������������������������������
	PCOIniLan("000012")

	dbSelectArea(cAliasSE1)
	lEof := Eof()

	// Ponto de Entrada para travar ou destravar os registros da SA1
	If lTravaSa1
	     lBloqSa1 := ExecBlock("F110TRAVA",.f.,.f.)
	Endif

	//Em situacoes que contabilizar com o LP521, zero a variavel VALOR que pode,
	//neste caso, conter um carga realizada pelo LP520 em uma baixa anterior.
	Valor := 0

	lMovBcoBx := MovBcoBx(cMotBx, .T.)

	//Gestao
	cFilAtu := cFilAnt
	//Controle de documentos contabeis
	lDigita			:=IIF(mv_par01==1 .and. !lF110Auto ,.T.,.F.)
	lAglut			:=IIF(mv_par02==1,.T.,.F.)
	lContabiliza 	:=IIF(mv_par03==1,.T.,.F.)
	nHdlPrv 		:= 0

	While !lEof

		//Rotina Automatizada
		If lF110Auto
			SE1->(dbGoto(aTitulos[1,nY]))
			aBaixas := {}

			//Somente poderao ser baixados titulos da filial de execucao
			If E1_FILIAL != xFilial("SE1")

				If nY == nLast
					lEof := .T.
				Endif

				nY++
				Loop

			Endif

		Else
			nRegAtu := Recno()
			aBaixas := {}

			If !lQuery
				dbSkip()
				lEof := Eof()
				nProxReg := Recno()

				While (cAliasSE1)->E1_TIPO $ MVABATIM+"/"+MVIRABT+"/"+MVINABT .and. !Eof()
					dbSkip()
					lEof := Eof()
					nProxReg := Recno()
				Enddo
				dbGoto(nRegAtu)
				If (cAliasSE1)->E1_FILIAL != cFilial
					dbSkip()
					Loop
				Endif
			Endif
		Endif
		If (cAliasSE1)->E1_OK == cMarca .and. !((cAliasSE1)->E1_TIPO $ MVABATIM+"/"+MVIRABT+"/"+MVINABT)

			//Gestao
			//Controle de documentos contabeis
			nC++
			cPadrao  := fA070Pad()
			lPadrao  := VerPadrao( cPadrao )

			IF lPadrao .and. lContabiliza

				//Caso tenha selecionado mais de uma filial
				//fecho o documento contabil por filial
				If lQuery .and. !lF110Auto .and. nLenFil > 1

				  	If nC > 1 .and. nValorTotal > 0  .And. nHdlPrv > 0 .and. cFilAnt != (cAliasSE1)->E1_FILORIG

						//���������������������������������������������Ŀ
						//� Finaliza processo de integracao com SIGAPCO �
						//�����������������������������������������������
						PCOFinLan("000012")

						// vai para EOF() para contabilizar apenas o total
						dbSelectArea( "SE1" )
						dbGoBottom()
						dbSkip()

						// Desposiciona tambem SE5 para nao contabilizar o ultimo titulo em duplicidade
						dbSelectArea( "SE5" )
						dbGoBottom()
						dbSkip()

						// Zera as variaveis de PCC para que n�o contabilize duas vezes os impostos do ultimo titulo
						PIS:=0
						COFINS:=0
						CSLL:= 0

						VALOR := nValorTotal

                    	nValorTota := 0

						nTotal += DetProva( nHdlPrv,;
						                    cPadrao,;
						                    "FINA110",;
						                    cLote,;
						                    /*nLinha*/,;
						                    /*lExecuta*/,;
						                    /*cCriterio*/,;
						                    /*lRateio*/,;
						                    /*cChaveBusca*/,;
						                    /*aCT5*/,;
						                    /*lPosiciona*/,;
						                    @aFlagCTB,;
						                    /*aTabRecOri*/,;
						                    /*aDadosProva*/ )


						RodaProva(  nHdlPrv,nTotal )

						//-- Se for rotina automatica for�a exibir mensagens na tela, pois mesmo quando n�o exibe os lan�ametnos, a tela
						//-- sera exibida caso ocorram erros nos lan�amentos padronizados
						If lF110Auto
							lSetAuto := _SetAutoMode(.F.)
							lSetHelp := HelpInDark(.F.)
						EndIf

						cA100Incl( cArquivo,;
						           nHdlPrv,;
						           3,;
			 			           cLote,;
						           lDigita,;
						           lAglut,;
					    	       /*cOnLine*/,;
					        	   /*dData*/,;
						           /*dReproc*/,;
						           @aFlagCTB,;
						           /*aDadosProva*/,;
						           /*aDiario*/ )
						aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento

						If lF110Auto
							HelpInDark(lSetHelp)
							_SetAutoMode(lSetAuto)
						EndIf

						nTotal := 0
						nHdlPrv := 0
						VALOR := 0

					Endif
				Endif

				//Gestao
				//Se for TOP e nao automatico, posiciono o SE1 e sigo o fluxo normal da rotina
				IF !Funname() == "FINA910"
					SE1->(dbGoTo( nRegAtu ))
					If lQuery .and. !lF110Auto
						cFilAnt := (cAliasSE1)->E1_FILORIG
						If !SM0->( DbSeek( SM0->M0_CODIGO + (cAliasSE1)->E1_FILORIG ) )
							(cAliasSE1)->(dbSkip())
							Loop
						Endif
						//SE1->(dbGoTo((cAliasSE1)->RECNO))
						SE1->(dbGoTo((cAliasSE1)->(RECNO())))
					Endif
	          Endif
				//������������������������������������������������������������������Ŀ
				//� Inicializa Lancamento Contabil                                   �
				//��������������������������������������������������������������������
				If nHdlPrv == 0
					nHdlPrv := HeadProva( cLote,"FINA110",Substr( cUsuario, 7, 6 ),@cArquivo )
				Endif
			Else

				//Gestao
				//Se for TOP e nao automatico, posiciono o SE1 e sigo o fluxo normal da rotina
				If lQuery .and. !lF110Auto
					cFilAnt := (cAliasSE1)->E1_FILORIG
					If !SM0->( DbSeek( SM0->M0_CODIGO + (cAliasSE1)->E1_FILORIG ) )
						(cAliasSE1)->(dbSkip())
						Loop
					Endif
					SE1->(dbGoTo((cAliasSE1)->(RECNO())))
				Endif
			Endif
			BEGIN TRANSACTION
			//������������������������������������Ŀ
			//� Posiciona no Cadastro de Naturezas �
			//��������������������������������������
			dbSelectArea("SED")
			dbSetOrder(1)
			MSSeek(xFilial("SED")+SE1->E1_NATUREZ)
			dbSelectArea("SE1")
			nRegAtu     := RecNo()
			nSaldo		:= E1_SALDO
			nSaldoCru	:= Round(NoRound(xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,nMoedaBco,,3,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),3),2)
			cNumero		:= E1_NUM
			cPrefixo	:= E1_PREFIXO
			cParcela	:= E1_PARCELA
			cCliente	:= E1_CLIENTE
			cLoja   	:= E1_LOJA
			cTipoOr		:= E1_TIPO
			nBaseIr		:= E1_SALDO   //utilizado para definir a base do IR quando calculado na baixa
			nTotAbat	:= 0
			nValImp     := 0
			nValAbat	:= 0
			nMoeda		:= 2
			nJuros		:= 0
			nMulta		:= 0
			nDescont	:= 0
			nCorrec		:= 0
			nCM1 		:= 0
			nProRata 	:= 0
			If mv_par06 == 1 .and. !lF110Auto
				cBco110 	:= IIF(!Empty(E1_PORTADO), E1_PORTADO, cBco110)
				cAge110 	:= IIF(!Empty(E1_AGEDEP) , E1_AGEDEP , cAge110)
				cCta110 	:= IIF(!Empty(E1_CONTA)  , E1_CONTA  , cCta110)
			Endif
			nAcresc	:= Round(NoRound(xMoeda(SE1->E1_SDACRES,SE1->E1_MOEDA,nMoedaBco,,3,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),3),2)
			nDecresc	:= Round(NoRound(xMoeda(SE1->E1_SDDECRE,SE1->E1_MOEDA,nMoedaBco,,3,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),3),2)
			dBaixa 	:= dDataBase // Utilizada por Fa070Data
			If lF110Auto .and. Len(aTitulos) >= 9 .And. ValType(aTitulos[09]) == "L" .And. aTitulos[09]
				dBaixa := aTitulos[8]
			Endif
			nCorrec	:= fa110Correc()

			//as variaveis abaixo sao utilizadas em algumas funcoes chamadas a partir
			//da funcao Fa070Data. A retirada destas causara problemas a rotina.
			cBanco   	:= cBco110
			cAgencia 	:= cAge110
			cConta		:= cCta110
			//Pcc Baixa CR
			nPis			:= 0
			nCofins 		:= 0
			nCsll			:= 0
			nValRec		:= 0
			//Pcc Baixa CR
			nIrrf			:= 0

			fA070Data() // Calcula o desconto e o juros (se houver) e valida a data
			F110Ret()

		If lBloqSa1
			dbSelectArea("SA1")
			dbSetOrder(1)
			if MSSeek(xFilial("SA1")+cCliente+cLoja+cPrefixo+cNumero+cParcela) .AND. SuperGetMv("MV_NOTSA1",,.T.)
				RecLock("SA1",.F.)
    	    	Replace A1_NROPAG With A1_NROPAG + 1
				SA1->(MsUnlock())
			endif
		Endif

			If nCM1 > 0
				nJuros += nCM1
			Else
				nDescont -= nCM1
			EndIf

			If nProRata > 0
				nJuros += nProRata
			Else
				nDescont -= nProRata
			EndIf

			//���������������������������������������������������������������Ŀ
			//� PONTO DE ENTRADA FA110DES                                     �
			//� ExecBlock para calculo de descontos                           �
			//�����������������������������������������������������������������
			If lFa110Desc
				nDescont := Execblock("FA110DES",.F.,.F.)
			Endif

			//���������������������������������������������������������������Ŀ
			//� PONTO DE ENTRADA FA110JUR                                     �
			//� ExecBlock para calculo de Juros                               �
			//�����������������������������������������������������������������
			If lFa110Juros
				nJuros := Execblock("FA110JUR",.F.,.F.)
			Endif

			//���������������������������������������������������������������Ŀ
			//� PONTO DE ENTRADA FA110MUL                                     �
			//� ExecBlock para calculo de Multas                              �
			//�����������������������������������������������������������������
			If lFa110Mult
				nMulta := Execblock("FA110MUL",.F.,.F.)
			Endif
			cTipo:= SE1->E1_TIPO
			//�������������������������������������������������Ŀ
			//�Soma Titulos Abatimentos                         �
			//���������������������������������������������������
			dbSelectArea( "ABAT" )
			dbSetOrder( 2 )
			MSSeek( xFilial("SE1")+cCliente+cLoja+cPrefixo+cNumero+cParcela )
			If lTitpaiSE1
		 		If FindFunction("OrdTitpai") .and. (nOrdTitPai:= OrdTitpai()) > 0
   					DbSetOrder(nOrdTitPai)
					If	MsSeek(xFilial("SE1")+cPrefixo+cNumero+cParcela+cTipo+cCliente+cLoja)
						bWhile := {|| !Eof() .And. Alltrim(xFilial("SE1")+E1_TITPAI) == Alltrim(xFilial("SE1")+cPrefixo+cNumero+cParcela+cTipo+cCliente+cLoja) }
					Else
						dbSetOrder( 2 )
		   				MsSeek( xFilial("SE1")+cCliente+cLoja+cPrefixo+cNumero+cParcela )
			   		EndIf
				Endif
			Endif
			nRecnoSe1 := SE1->(Recno())

			While Eval(bWhile)

				IF E1_TIPO $ MVABATIM+"/"+MVIRABT+"/"+MVINABT .And.;
					E1_SALDO   >  0            .And.;
					E1_CLIENTE == cCLIENTE

					If lTitpaiSE1
						If  !Empty(E1_TITPAI).and.(Alltrim(E1_TITPAI)!=Alltrim(cPrefixo+cNumero+cParcela+cTipo+cCliente+cLoja))
							DbSkip()
							Loop
						EndIf
					EndIf

					//Abatimento baixado pela rotina de compensacao, desconsiderar
					If IIf(SE1->(FieldPos("E1_TITPAI"))#0,!Empty(SE1->E1_TITPAI),.F.) .AND. (MVRECANT $ SE1->E1_TITPAI .OR. MV_CRNEG $ SE1->E1_TITPAI)
						SE1->(dbSkip())
						Loop
					Endif

					nTotAbat += Round(NoRound(xMoeda(E1_SALDO,E1_MOEDA,nMoedaBco,,3,If(cPaisLoc=="BRA",E1_TXMOEDA,0)),3),2)
					nValAbat += E1_SALDO
					nValImp  += If( E1_TIPO $ MVIRABT+"/"+MVINABT, E1_SALDO, 0)
					ABATIMENTO := nTotAbat
					//����������������������������������������������Ŀ
					//� Carrega variavies para contabilizacao dos    �
					//� abatimentos (impostos da lei 10925).         �
					//������������������������������������������������
					If E1_TIPO == MVPIABT
						VALOR5 := E1_VALOR
					ElseIf E1_TIPO == MVCFABT
						VALOR6 := E1_VALOR
					ElseIf E1_TIPO == MVCSABT
						VALOR7 := E1_VALOR
					Endif
					AADD( aRecNoAbat, ABAT->(Recno()) )
					#IFDEF TOP
						If Len( aRecNoAbat ) > 0
							cQuery := "UPDATE "+ RetSQLName( "SE1" ) + " "
							cQuery += "SET E1_SALDO = 0"
							cQuery += ", E1_BAIXA = '" + DTOS(dDataBase) + "'"
							cQuery += ", E1_MOVIMEN = '" + DTOS(dDataBase) + "'"
							cQuery += ", E1_STATUS = 'B' "
							If SE1->(FieldPos("E1_TITPAI")) # 0
								cQuery += ", E1_TITPAI = '" + cPrefixo + cNumero + cParcela + cTipoOr + cCliente + cLoja + "' "
							Endif
							cQuery += "WHERE "
							cQuery += "R_E_C_N_O_ IN ("
							For i := 1 To Len( aRecNoAbat )
								cQuery += If( i > 1, ", ", " " ) + AllTrim( Str(aRecNoAbat[i]) )
								If i == Len( aRecNoAbat )
									cQuery += ")"
								EndIf
							Next i

							TCSQLExec( cQuery )
							aRecNoAbat := {}
						EndIf
					#ELSE
						//��������������������������������Ŀ
						//� Atualiza a Baixa do Titulo     �
						//����������������������������������
						SE1->(Msgoto(ABAT->(Recno())))
						RecLock("SE1",.F.)
						Replace E1_SALDO	With 0
						Replace E1_BAIXA	With dDataBase
						Replace E1_MOVIMEN  With dDataBase
						Replace E1_STATUS   With "B"

						//���������������������������������������������������������Ŀ
						//�Gravar o titulo que baixou o AB- para evitar estornos de �
						//�abatimentos baixados por outras rotinas. Evita que um AB-�
						//�baixado pelo FINA070 / 110 seja estornado indevidamente  �
						//�pelo FINA330, que gera erro na composicao do saldo do    �
						//�titulo principal com abatimento.                         �
						//�Gravar SEMPRE NCC/RA para identificar a baixa do AB-     �
						//�pela rotina FINA330					    �
						//�����������������������������������������������������������
						If lTitPai
							Replace E1_TITPAI	With (cPrefixo + cNumero + cParcela + cTipoOr + cCliente + cLoja)
						Endif
						SE1->(MsUnlock( ))
						DbSelectArea("ABAT")
					#ENDIF
				EndIF
				dbSkip()
			Enddo
			DbSetOrder(1)
			dbSelectArea( "SE1" )
			MsGoto(nRecnoSe1)
			nValRec    := (cAliasSE1)->E1_VALOR
			nOldValRec := nValRec

			nVlRetPis := 0
			nVlRetCof := 0
			nVlRetCsl := 0

			If lPccBxCr
				f070TotMes(dBaixa,.T.,,.F.)
				PIS:=nPis
				COFINS:=nCofins
				CSLL:= nCsll
			Endif
			lIrPjBxCr		:= If (lFuncIrPj,FIrPjBxCr(),.F.)

			//Controle de impostos Pis Cofins Csll na baixa
			nValRec	  := nSaldoCru-nTotAbat+nJuros+nMulta-nDescont+nAcresc-nDecresc


			If SED->ED_CALCIRF <> "S"
				lIrPjBxCr:=.F.
			Endif

			If lIrPjBxCr
		     	 nIrrf:=FCaIrBxCR(nBaseIr)
		      	 nValrec -= nIrrf
		 	EndIf

			If lPccBxCR
				nValRec -= (nPis+nCofins+nCsll)
			Endif
			//��������������������������������������������Ŀ
			//� Atualiza a Baixa do Titulo                 �
			//����������������������������������������������
			// Os titulos de abatimentos ja foram baixados no processo acima.
			If ! SE1->E1_TIPO $ MVABATIM+"/"+MVIRABT+"/"+MVINABT .And.;
				SE1->E1_SALDO > 0
				RecLock("SE1")
				SE1->E1_SALDO	:= 0
				SE1->E1_BAIXA	:= dDataBase
				SE1->E1_MOVIMEN := dDataBase
				SE1->E1_JUROS	:= nJuros + nAcresc
				SE1->E1_CORREC	:= nCorrec
				SE1->E1_DESCONT	:= nDescont + nDecresc
				SE1->E1_MULTA  	:= nMulta
				SE1->E1_VALLIQ	:= nValRec
				SE1->E1_STATUS  := Iif(E1_SALDO>0.01,"A","B")
				SE1->E1_SDACRES := 0
				SE1->E1_SDDECRE := 0
				//����������������������������������������������������������������Ŀ
				//� Salva os campos na tabela SE1 especifico do Template GEM       �
				//������������������������������������������������������������������
				If lGemSE1Grv
					ExecTemplate("GEMSE1Grv",.F.,.F.)
				EndIf
				SE1->(MsUnlock( ))
				If lAtuSldNat
					// Atualiza o saldo da natureza. O valor jah esth liquido dos abatimentos, desta forma nao precisa atualizar na baixa dos abatimentos
					AtuSldNat(SE1->E1_NATUREZ, SE1->E1_BAIXA, SE1->E1_MOEDA, "3", "R", nValrec, xMoeda(nValrec,SE1->E1_MOEDA,nMoedaBco,SE1->E1_BAIXA,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)), If(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG,"-","+"),,FunName(),"SE1", SE1->(Recno()),0)
				Endif
				//�����������������������������������������������������Ŀ
				//� Trecho incluido para integra��o e-commerce          �
				//�������������������������������������������������������
		        If  lFuncEC02 .And. lFuncEC01
				    If LJ861EC01(SE1->E1_NUM, SE1->E1_PREFIXO, .T./*PrecisaTerPedido*/)
				       LJ861EC02(SE1->E1_NUM, SE1->E1_PREFIXO)
				    EndIf
		        Endif
			Endif

			nValorTotal += SE1->E1_VALLIQ

			//��������������������������������������������������Ŀ
			//�Integracao Protheus X RM Classis Net (RM Sistemas)�
			//����������������������������������������������������
			if (lRmClass .or. lRmBibli) .and. SE1->E1_SALDO == 0
				if alltrim(upper(SE1->E1_ORIGEM)) == 'L' .or. alltrim(upper(SE1->E1_ORIGEM)) == 'S' .or. SE1->E1_IDLAN > 0
				   	//Executa funcao que replica a baixa para as tabelas do CorporeRM
					ClsProcBx(SE1->(Recno()),'1',"FIN110")
				endif
			endif

			//������������������������������������������������������������Ŀ
			//� Para numerar as sequencias o sistema precisa procurar os	�
			//� registros com  tipodoc igual a VL, BA ou CP.					�
			//��������������������������������������������������������������
			aTipoSeq := {"CP","BA","VL","V2","LJ"}
			cSequencia := Replicate("0",nTamSeq)
			dbSelectArea("SE5")
			SE5->(dbSetOrder(2))
			For nX := 1 to len(aTipoSeq)
				SE5->(MSSeek(xFilial("SE5") + aTipoSeq[nX] + SE1->E1_PREFIXO + SE1->E1_NUM + ;
													  SE1->E1_PARCELA + SE1->E1_TIPO) )

				While !SE5->(Eof()) .And. ;
						SE5->E5_FILIAL  == xFilial("SE5")  .And. ;
						SE5->E5_TIPODOC == aTipoSeq[nX]    .And. ;
						SE5->E5_PREFIXO == SE1->E1_PREFIXO .And. ;
						SE5->E5_NUMERO  == SE1->E1_NUM     .And. ;
						SE5->E5_PARCELA == SE1->E1_PARCELA .And. ;
						SE5->E5_TIPO    == SE1->E1_TIPO

					If PadL(AllTrim(cSequencia),nTamSeq,"0") < PadL(AllTrim(SE5->E5_SEQ),nTamSeq,"0")
						cSequencia := SE5->E5_SEQ
					Endif

					SE5->( dbSkip() )
				Enddo
			Next nX
			If Len(AllTrim(cSequencia)) < nTamSeq
				cSequencia := PadL(cSequencia,nTamSeq,"0")
			Endif
			cSequencia := Soma1(cSequencia,nTamSeq)
			MsUnlock()
			//����������������������������������������������������Ŀ
			//� Joga em variaveis o valor do Acrescimo e Decrescimo�
			//������������������������������������������������������

			nJuros   := nJuros   + nAcresc
			nDescont := nDescont + nDecresc
			cPadrao  := fA070Pad()
			lPadrao  := VerPadrao( cPadrao )

			lGravaAglut := ! SE1->E1_SITUACA $ "27"

			//��������������������������������������������������Ŀ
			//� Grava registro referente � movimenta��o bancaria �
			//����������������������������������������������������
			For nX := 1 To 5
				//��������������������������������������������������������������Ŀ
				//� Atualiza a Movimenta��o Banc�ria									  �
				//����������������������������������������������������������������
				If nX==1
					cCpoTp := "SE1->E1_VALLIQ"
					cTpDoc := Iif(SE1->E1_SITUACA$"27","V2",Iif(!lGerTotal .And. MovBcoBx(cMotBx, .T.),"VL","BA"))
					cHistMov := IIF(MovBcoBx(cMotBx, .T.),OemToAnsi( STR0014 ),; // "Valor recebido s /Titulo"
					cDescrMo )
					If SuperGetMv("MV_SLDBXCR") == "C" .AND. lGerTotal
						cTpDoc:= "BA"
					EndIf
					nValRec := SE1->E1_VALLIQ
					nSE1Rec := SE1->(Recno())
				Elseif nX==2
					cCpoTp  := "nJuros"
					cTpDoc  :=IIF(SE1->E1_SITUACA$"27","J2","JR")
					cHistMov:=OemToAnsi( STR0015 ) //"Juros s/Receb.Titulo"
				Elseif nX==3
					cCpoTp  :="nDescont"
					cTpDoc  :=IIF(SE1->E1_SITUACA$"27","D2","DC")
					cHistMov:=OemToAnsi( STR0017 ) //"Desconto s/Receb.Titulo"
				Elseif nX==4
					cCpoTp  := "nCorrec"
					cTpDoc  :=IIF(SE1->E1_SITUACA$"27","C2","CM")
					cHistMov:=OemToAnsi( STR0016 )//"Correcao Monet s/Receb.Titulo"
				Elseif nX==5
					cCpoTp  := "nMulta"
					cTpDoc  :=IIF(SE1->E1_SITUACA$"27","M2","MT")
					cHistMov:=OemToAnsi( STR0018 ) //"Multa s/Receb.Titulo"
				Endif

				If &cCpoTp != 0 .OR. nX == 1
					Reclock("SE5",.T.)
					SE5->E5_FILIAL		:= xFilial()
					SE5->E5_PREFIXO		:= SE1->E1_PREFIXO
					SE5->E5_NUMERO		:= SE1->E1_NUM
					SE5->E5_PARCELA		:= SE1->E1_PARCELA
					SE5->E5_CLIFOR		:= SE1->E1_CLIENTE
					SE5->E5_CLIENTE		:= SE1->E1_CLIENTE
					SE5->E5_LOJA		:= SE1->E1_LOJA
					SE5->E5_BENEF		:= SE1->E1_NOMCLI
					SE5->E5_VALOR		:= &cCpoTp
					SE5->E5_SEQ			:= cSequencia
					SE5->E5_DATA		:= SE1->E1_BAIXA
					SE5->E5_HISTOR		:= cHistMov
					SE5->E5_NATUREZ		:= SE1->E1_NATUREZ
					SE5->E5_RECPAG		:= If(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG, "P","R")
					SE5->E5_TIPO		:= SE1->E1_TIPO
					SE5->E5_DOCUMEN		:= SE1->E1_NUMBOR
					SE5->E5_DTDIGIT		:= dDataBase
					SE5->E5_TIPODOC		:= cTpDoc
					SE5->E5_MOTBX		:= Iif(Empty(cMotBx),"NOR",TrazCodMot( cMotBx ))
					SE5->E5_VLMOED2		:= xMoeda(&cCpoTp.,nMoedaBco,SE1->E1_MOEDA,SE1->E1_BAIXA,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					SE5->E5_DTDISPO 	:= dDtCredito
					SE5->E5_SITCOB 		:= SE1->E1_SITUACA
					SE5->E5_FILORIG		:= cFilAtu

					If lMovBcoBx
						SE5->E5_BANCO	:= cBco110
						SE5->E5_AGENCIA	:= cAge110
						SE5->E5_CONTA	:= cCta110
						//Moeda Banco
						nMoedaBco := Max( MoedaBco(cBco110,cAge110,cCta110), 1)

						If lF110SE5
							Aadd(aRecSe5, SE5->(Recno()))
						Endif

						SE5->E5_MOEDA := StrZero(nMoedaBco,2)

						//Caso seja execucao automatizada
						If lF110Auto
							SE5->E5_DATA	:= dBaixa
							SE5->E5_DTDISPO	:= dBaixa
							SE5->E5_DTDIGIT	:= dBaixa
						Endif
					Endif

					If lSitef
					   SE5->E5_LOTE := cLoteFin
					Endif

					If lGerTotal
						SE5->E5_ARQCNAB := "FINA110"
						SE5->E5_LOTE   	:= cLoteFin
						//Caso n�o seja execucao automatizada
						If !lF110Auto
							SE5->E5_BANCO		:= SEA->EA_PORTADO
							SE5->E5_AGENCIA		:= SEA->EA_AGEDEP
							SE5->E5_CONTA		:= SEA->EA_NUMCON
							cBco110				:= SEA->EA_PORTADO
							cAge110				:= SEA->EA_AGEDEP
							cCta110				:= SEA->EA_NUMCON
						Endif
					Endif

					If nx == 1	// registro totalizador
						Replace E5_VLJUROS With nJuros
						Replace E5_VLMULTA With nMulta
						Replace E5_VLCORRE With nCorrec
						Replace E5_VLDESCO With nDescont
						If lAcreDecre
							Replace SE5->E5_VLACRES With nAcresc
							Replace SE5->E5_VLDECRE With nDecresc
						Endif

						//Pcc Baixa CR
						//Gravar SFQ
						If lPccBxCR
							Reclock( "SE5" )
							SE5->E5_VRETPIS := nPis
							SE5->E5_VRETCOF := nCofins
							SE5->E5_VRETCSL := nCsll
							SE5->(MsUnlock())
							nBaseRet := nValRec+nPis+nCofins+nCsll+nDescont+nTotAbat-nJuros-nMulta

							Do Case
							Case cModRetPIS == "1"
								If aDadosRet[ 1 ] + nBaseRet > nVlMinImp .or. !lAplVlMin
									nSalvRec := SE5->( Recno() )
									lRetParc := .T.

									//������������������������������������������������������������������Ŀ
									//� Exclui a Marca de "pendente recolhimento" dos demais registros   �
									//��������������������������������������������������������������������
									If aDadosRet[1] > 0
										aRecnos := aClone( aDadosRet[ 6 ] )

										cPrefOri  := SE5->E5_PREFIXO
										cNumOri   := SE5->E5_NUMERO
										cParcOri  := SE5->E5_PARCELA
										cTipoOri  := SE5->E5_TIPO
										cCfOri    := SE5->E5_CLIFOR
										cLojaOri  := SE5->E5_LOJA

										For nLoop := 1 to Len( aRecnos )

											SE5->( dbGoto( aRecnos[ nLoop ] ) )

											RecLock( "SE5", .F. )

											If !Empty(SE5->E5_PRETPIS) .And. !Empty(SE5->E5_PRETCOF) .And. !Empty(SE5->E5_PRETCSL)
												SE5->E5_PRETPIS := "2"
												SE5->E5_PRETCOF := "2"
												SE5->E5_PRETCSL := "2"
											EndIf

											SE5->(MsUnlock())

											If lExistSFQ
													If nSalvRec <> aRecnos[ nLoop ]
														dbSelectArea("SFQ")
														RecLock("SFQ",.T.)
														SFQ->FQ_FILIAL  := xFilial("SFQ")
														SFQ->FQ_ENTORI  := "E1B"
														SFQ->FQ_PREFORI := cPrefOri
														SFQ->FQ_NUMORI  := cNumOri
														SFQ->FQ_PARCORI := cParcOri
														SFQ->FQ_TIPOORI := cTipoOri
														SFQ->FQ_CFORI   := cCfOri
														SFQ->FQ_LOJAORI := cLojaOri
														SFQ->FQ_SEQORI  := cSequencia

														SFQ->FQ_ENTDES  := "E1B"
														SFQ->FQ_PREFDES := SE5->E5_PREFIXO
														SFQ->FQ_NUMDES  := SE5->E5_NUMERO
														SFQ->FQ_PARCDES := SE5->E5_PARCELA
														SFQ->FQ_TIPODES := SE5->E5_TIPO
														SFQ->FQ_CFDES   := SE5->E5_CLIFOR
														SFQ->FQ_LOJADES := SE5->E5_LOJA
														SFQ->FQ_SEQDES  := SE5->E5_SEQ

														//Grava a filial de destino caso o campo exista
													If lFilDes
															SFQ->FQ_FILDES := SE5->E5_FILIAL
														EndIf

														SFQ->(MsUnlock())
												Endif
											Endif
										Next nLoop
									EndIf

									//���������������������������������������������������Ŀ
									//� Retorna do ponteiro do SE1 para a parcela         �
									//�����������������������������������������������������
									SE5->( MsGoto( nSalvRec ) )
									Reclock( "SE5", .F. )
								Else
									If nVlRetPis + nVlRetCof + nVlRetCsl > 0
										Reclock( "SE5", .F. )
										SE5->E5_VRETPIS := nVlRetPis
										SE5->E5_VRETCOF := nVlRetCof
										SE5->E5_VRETCSL := nVlRetCsl
										SE5->E5_PRETPIS := "1"
										SE5->E5_PRETCOF := "1"
										SE5->E5_PRETCSL := "1"

										SE5->( MsUnlock() )
									EndIf
									lRetParc := .F.

								EndIf

							Case cModRetPIS == "2"
								//�������������������������������������������������������������������Ŀ
								//� Efetua a retencao                                                 �
								//���������������������������������������������������������������������
								nSalvRec := SE5->( Recno() )

								//������������������������������������������������������������������Ŀ
								//� Exclui a Marca de "pendente recolhimento" dos demais registros   �
								//��������������������������������������������������������������������
								If aDadosRet[1] > 0
									aRecnos := aClone( aDadosRet [ 6 ] )

									cPrefOri  := SE5->E5_PREFIXO
									cNumOri   := SE5->E5_NUMERO
									cParcOri  := SE5->E5_PARCELA
									cTipoOri  := SE5->E5_TIPO
									cCfOri    := SE5->E5_CLIFOR
									cLojaOri  := SE5->E5_LOJA

								  	For nLoop := 1 to Len( aRecnos )

										SE5->( dbGoto( aRecnos[ nLoop ] ) )

										RecLock( "SE5", .F. )

										If !Empty(SE5->E5_PRETPIS) .And. !Empty(SE5->E5_PRETCOF) .And. !Empty(SE5->E5_PRETCSL)
											SE5->E5_PRETPIS := "2"
											SE5->E5_PRETCOF := "2"
											SE5->E5_PRETCSL := "2"
										EndIf
										SE5->( MsUnlock() )

										If lExistSFQ
												If nSalvRec <> aRecnos[ nLoop ]
													dbSelectArea("SFQ")
													RecLock("SFQ",.T.)
													SFQ->FQ_FILIAL  := xFilial("SFQ")
													SFQ->FQ_ENTORI  := "E1B"
													SFQ->FQ_PREFORI := cPrefOri
													SFQ->FQ_NUMORI  := cNumOri
													SFQ->FQ_PARCORI := cParcOri
													SFQ->FQ_TIPOORI := cTipoOri
													SFQ->FQ_CFORI   := cCfOri
													SFQ->FQ_LOJAORI := cLojaOri
													SFQ->FQ_SEQORI  := cSequencia

													SFQ->FQ_ENTDES  := "E1B"
													SFQ->FQ_PREFDES := SE5->E5_PREFIXO
													SFQ->FQ_NUMDES  := SE5->E5_NUMERO
													SFQ->FQ_PARCDES := SE5->E5_PARCELA
													SFQ->FQ_TIPODES := SE5->E5_TIPO
													SFQ->FQ_CFDES   := SE5->E5_CLIFOR
													SFQ->FQ_LOJADES := SE5->E5_LOJA
													SFQ->FQ_SEQDES  := SE5->E5_SEQ

													//Grava a filial de destino caso o campo exista
												If lFilDes
													SFQ->FQ_FILDES := SE5->E5_FILIAL
												EndIf

													SFQ->(MsUnlock())
											Endif
										Endif
									Next nLoop

								Endif
								//���������������������������������������������������Ŀ
								//� Retorna do ponteiro do SE1 para a parcela         �
								//�����������������������������������������������������
								SE5->( MsGoto( nSalvRec ) )
								Reclock( "SE1", .F. )
								lRetParc := .T.

							Case cModRetPIS == "3"
								//������������������������������������������������������������������Ŀ
								//� Grava a Marca de "pendente recolhimento" dos demais registros    �
								//��������������������������������������������������������������������
								If nVlRetPis + nVlRetCof + nVlRetCsl > 0
									Reclock( "SE5", .F. )
									SE5->E5_VRETPIS := nVlRetPis
									SE5->E5_VRETCOF := nVlRetCof
									SE5->E5_VRETCSL := nVlRetCsl
									SE5->E5_PRETPIS := "1"
									SE5->E5_PRETCOF := "1"
									SE5->E5_PRETCSL := "1"

									SE5->( MsUnlock() )
								EndIf
								lRetParc := .F.
							EndCase
							//Gravo os titulos de impostos Pis Cofins Csll quando controlados pela baixa
							If lPCCBxCR .and. lRetParc
								FGrvPccRec(@nPis,@nCofins,@nCsll,nRegAtu,.F.,lRetParc,cSequencia,"FINA070",SE1->E1_MOEDA)
							Endif

						EndIf
					    If lIrPjBxCr
							FGSFQIRCR(nIrrf,nValrec-nIrrf,cSequencia)
						EndIf
						If lIrPjBxCr .and. lRetParc
					   		FGrvIrRec(@nIrrf,nRegAtu,.F.,cSequencia,"FINA070",SE1->E1_MOEDA)
						Endif

						//����������������������������������������������������������������Ŀ
						//� Salva os campos na tabela SE5 especifico do Template GEM       �
						//������������������������������������������������������������������
						If lGemSE5Grv
							ExecTemplate("GEMSE5Grv",.F.,.F.)
						EndIf

						nRegPrinc := SE5->(Recno())
						//������������������������������������������������Ŀ
						//� Grava o lan�amento de integra��o com o SIGAPCO �
						//��������������������������������������������������
						If lPcoInte
							PcoDetLan("000012","01","FINA110")
						EndIf
						If lFuncGetRt .and. lFuncHasEAI .and. FWHasEAI("FINA070",.T.,,.T.)
							FwIntegDef( 'FINA070' )
						Endif
					Endif
					If lSpbInUse
						SE5->E5_MODSPB := "1"
					Endif
					If lPadrao .and. mv_par03 == 1 .and. nX != 1
						If !lUsaFlag
							SE5->E5_LA := "S"
						Else
							aADD(aRecFlag,SE5->(Recno()))
						EndIf
					Endif
					SE5->(MsUnlock())

					//���������������������������������������������������������������Ŀ
					//� PONTO DE ENTRADA FA110SE5                                     �
					//� ExecBlock para gravar dados complementares a baixa do titulo  �
					//�����������������������������������������������������������������
					If lFa110Se5
						Execblock("FA110SE5",.F.,.F.)
					Endif
					aadd(aBaixas,{SE5->E5_MOTBX,SE5->E5_SEQ,SE5->(Recno())})

					nSomaCheq :=	0
					If GetMv("MV_SLDBXCR") == "C" //Soma o total recebido em cheque.
						nSomaCheq := SomaCheqCr(.F.,SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO, SE1->E1_CLIENTE)
					Endif

					If !lGerTotal .And. lMovBcoBx .and. !(SE1->E1_SITUACA $ "27") .and. nX == 1
					AtuSalBco(cBco110,cAge110,cCta110,SE5->E5_DATA,(SE5->E5_VALOR-nSomaCheq),If(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG,"-","+"))
					Endif



				EndIf
			Next
			cfilant:=cfilatu
			//�������������������������������������Ŀ
			//� Atualiza o Cadastro de CLIENTES     �
			//���������������������������������������
			dbSelectArea("SA1")
			If SuperGetMv("MV_NOTSA1",,.T.) .and. MSSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)
				//���������������������������������������������������������Ŀ
				//�No Conciliador quando for cliente ADM Finan e o parametro�
				//�estiver habilitado nao trava o registro do cliente 		�
				//�����������������������������������������������������������
				lAtuSalDup 	:= .T.
				DbSelectArea("SAE")
				DbSetOrder(2)
				If MSSeek(xFilial("SAE")+SA1->A1_COD)
					If lLjAtuSa
						lAtuSalDup 	:= .F.
				    EndIf
				EndIf

				IF SE1->E1_MOEDA > 1
					nSaldoCru := Round(NoRound(xMoeda(nSaldo-nValAbat,SE1->E1_MOEDA,nMoedaBco,SE1->E1_EMISSAO,3,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),3),2)
				Else
					nSaldoCru -= nTotAbat
				Endif
				If lAtuSalDup
					AtuSalDup("-",nSaldoCru,1,SE1->E1_TIPO,,SE1->E1_EMISSAO,,lBloqSa1)
				EndIf
			Endif
			//�����������������������������������������������������Ŀ
			//� Verifica qual o Lanc Padrao que sera utilizado      �
			//�������������������������������������������������������
			dbSelectArea("SE1")
			nC++
			IF nC == 1 .And. lPadrao
				//������������������������������������������������������������������Ŀ
				//� Inicializa Lancamento Contabil                                   �
				//��������������������������������������������������������������������
				nHdlPrv := HeadProva( cLote,;
				                      "FINA110",;
				                      Substr( cUsuario, 7, 6 ),;
				                      @cArquivo )
			Endif

			IF lPadrao .and. mv_par03 == 1 .And. nHdlPrv > 0

				dbSelectArea("SE5")
				dbGoto(nRegPrinc)

				If lUsaFlag
					aAdd( aFlagCTB, { "E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0 } )
					For nX := 1 to Len(aRecFlag)
						SE5->(DbGoTo(aRecFlag[nX]))
						If aScan( aFlagCTB , { |x| x[4] == SE5->(Recno()) }) == 0
							aAdd( aFlagCTB, { "E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0 } )
						EndIf
					Next nX
					SE5->(dbGoto(nRegPrinc))
				Endif

				//������������������������������������������������������������������Ŀ
				//� Prepara Lancamento Contabil                                      �
				//��������������������������������������������������������������������
				nTotal += DetProva( nHdlPrv,;
				                    cPadrao,;
				                    "FINA110",;
				                    cLote,;
				                    /*nLinha*/,;
				                    /*lExecuta*/,;
				                    /*cCriterio*/,;
				                    /*lRateio*/,;
				                    /*cChaveBusca*/,;
				                    /*aCT5*/,;
				                    /*lPosiciona*/,;
				                    @aFlagCTB,;
				                    /*aTabRecOri*/,;
				                    /*aDadosProva*/ )

				If nTotal > 0 .And. ! lUsaFlag
					RecLock("SE5",.F.)
					SE5->E5_LA := "S"
					SE5->( MsUnLock() )
				EndIf

			Endif

			dbSelectArea("SE1")
			//���������������������������������������������������������������Ŀ
			//� PONTO DE ENTRADA DE TEMPLATES FA110DES                        �
			//� ExecBlock generico anterior a contabiliza��o                  �
			//�����������������������������������������������������������������
			If lTFINA110
				ExecTemplate("FINA110",.f.,.f.)
			Endif
			//���������������������������������������������������������������Ŀ
			//� PONTO DE ENTRADA FA110DES                                     �
			//� ExecBlock generico anterior a contabiliza��o                  �
			//�����������������������������������������������������������������
			If lFINA110
				Execblock("FINA110",.f.,.f.)
			Endif


			If cTpComiss == "O"  .and. ComisBx( TrazCodMot(cMotBx) )
				Fa440CalcB(aBaixas,lJuros,lDesconto,"FINA110",,,,.T.,nSE1Rec)
			Endif
			//transa��o titulo a titulo pois estava estava ocorrendo problema de locacao da tabela SA1 enquanto roda a baixa
			END TRANSACTION

		EndIf

		dbSelectArea("SE1")

		//Rotina Automatizada
		If lF110Auto
			If nY == nLast
				lEof := .T.
			Endif
			nY++
		//Rotina Padrao (Nao Automatizada)
		Else
			//Gestao
			If lQuery
				(cAliasSE1)->(dbSkip())
				If (cAliasSE1)->(Eof())
					lEof := .T.
				Endif
			Else
				If !lEof
					dbGoTo(nProxReg)
				EndIf
			Endif
		Endif

	Enddo

	// ponto de entrada para manipula��o dos t�tulos marcados e processados na SE5.
	If lF110SE5
		ExecBlock("F110SE5",.F.,.F.,{aRecSe5})
	Endif

	//���������������������������������������������Ŀ
	//� Finaliza processo de integracao com SIGAPCO �
	//�����������������������������������������������
	PCOFinLan("000012")

	//Ponto de entrada para geracao de recibo com todos os titulos baixados
	If lF110Rec
		ExecBlock("F110REC",.F.,.F.)
	Endif

	// vai para EOF() para contabilizar apenas o total
	dbSelectArea( "SE1" )
	dbGoBottom()
	dbSkip()

	// Desposiciona tambem SE5 para nao contabilizar o ultimo titulo em duplicidade
	dbSelectArea( "SE5" )
	dbGoBottom()
	dbSkip()
	// Zera as variaveis de PCC para que n�o contabilize duas vezes os impostos do ultimo titulo
	PIS:=0
	COFINS:=0
	CSLL:= 0


	// Credito do Banco = Variavel VALOR
	VALOR := nValorTotal

  	If lPadrao .and. mv_par03 == 1 .and. nC > 0 .and. nValorTotal > 0  .And. nHdlPrv > 0

			nTotal += DetProva( nHdlPrv,;
		                    cPadrao,;
		                    "FINA110",;
		                    cLote,;
		                    /*nLinha*/,;
		                    /*lExecuta*/,;
		                    /*cCriterio*/,;
		                    /*lRateio*/,;
		                    /*cChaveBusca*/,;
		                    /*aCT5*/,;
		                    /*lPosiciona*/,;
		                    @aFlagCTB,;
		                    /*aTabRecOri*/,;
		                    /*aDadosProva*/ )
	EndIF

	//������������������������������������������������������������������Ŀ
	//� Efetiva Lan�amento Contabil                                      �
	//��������������������������������������������������������������������
	IF nC > 0 .And. lPadrao .and. mv_par03 == 1 .And. nHdlPrv > 0 .and. nTotal > 0

		RodaProva(  nHdlPrv,;
						nTotal )
		lDigita:=IIF(mv_par01==1 .and. !lF110Auto ,.T.,.F.)
		lAglut :=IIF(mv_par02==1,.T.,.F.)

		//-- Se for rotina automatica for�a exibir mensagens na tela, pois mesmo quando n�o exibe os lan�ametnos, a tela
		//-- sera exibida caso ocorram erros nos lan�amentos padronizados
		If lF110Auto
			lSetAuto := _SetAutoMode(.F.)
			lSetHelp := HelpInDark(.F.)
		EndIf

		cA100Incl( cArquivo,;
		           nHdlPrv,;
		           3,;
		           cLote,;
		           lDigita,;
		           lAglut,;
		           /*cOnLine*/,;
		           /*dData*/,;
		           /*dReproc*/,;
		           @aFlagCTB,;
		           /*aDadosProva*/,;
		           /*aDiario*/ )
		aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento

		If lF110Auto
			HelpInDark(lSetHelp)
			_SetAutoMode(lSetAuto)
		EndIf

	//Gestao
	cFilAnt := cFilAtu
	SM0->(dbGoto(nRecSM0))
	Endif

	VALOR := 0
	dbSelectArea( "ABAT" )
	dbCloseArea()
	dbSelectArea( "SE1" )
	RetIndex("SE1")
	Set Filter to
	If lResp
		Loop
	Else
		nSFilPos := 0
	EndIf
	Exit
Enddo

If __lSX8
	RollBackSX8()
Endif
//������������������������������������������������������Ŀ
//� Gera registro totalizador no SE5, caso baixa seja    �
//� aglutinada (BX_CNAB=S)   									   �
//��������������������������������������������������������
If nValorTotal > 0 .And.(lGerTotal .Or. lSitef) .And. lGravaAglut
	Reclock( "SE5" , .T. )
	SE5->E5_FILIAL := xFilial()
	SE5->E5_DATA   := dDataBase
	SE5->E5_TIPODOC:= "VL"
	SE5->E5_VALOR  := nValorTotal
	SE5->E5_RECPAG := "R"
	SE5->E5_DTDIGIT:= dDataBase
	SE5->E5_BANCO  := cBco110
	SE5->E5_AGENCIA:= cAge110
	SE5->E5_CONTA  := cCta110
	SE5->E5_DTDISPO:= dDataBase
	SE5->E5_LOTE   := cLoteFin
	SE5->E5_HISTOR := STR0010 + " / " + STR0023 + " " + cLoteFin // "Baixa Automatica / Lote : "
	SE5->E5_LA     := "S"//Esse movimento n�o deve ser contabilizado
	If lSpbInUse
		SE5->E5_MODSPB := "1"
	Endif
	If lF110Auto .and. lMovBcoBx
		SE5->E5_DATA	:= dBaixa
		SE5->E5_DTDISPO := dBaixa
		SE5->E5_DTDIGIT := dBaixa
	Endif
	//��������������������������������������������������������������������Ŀ
	//� PONTO DE ENTRADA FA110TOT                                          �
	//� ExecBlock para gravar dados complementares ao registro totalizador �
	//����������������������������������������������������������������������
	If lFa110Tot
		Execblock("FA110TOT",.F.,.F.)
	Endif
	SE5->(MsUnlock( ))
	//�������������������������������Ŀ
	//� Atualiza saldo bancario.      �
	//���������������������������������
	AtuSalBco(cBco110,cAge110,cCta110,SE5->E5_DATA,SE5->E5_VALOR,"+")
EndIf



//��������������������������������������������������������������Ŀ
//� Restaura os �ndices                                          �
//����������������������������������������������������������������
If lQuery .and. !lF110Auto
	If Select(cAliasSe1) > 0
		DbSelectArea(cAliasSe1)
		DbCloseArea()
		FErase( cAliasSe1 + GetDBExtension() )
	Endif
Else
	dbSelectArea("SE1")
	RetIndex("SE1")
	dbSetOrder(nSavOrd1)
	dbSeek(xFilial())
	FErase (cIndex+OrdBagExt())
Endif

cFilAnt := cFilOld
SM0->(dbGoto(nRecSM0))

RestArea(aArea)
//volta database
dDataBase:= dBKPDTBase
Return (.T.)

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �fa110blank� Autor � Mauricio Pequim Jr 	  � Data � 06/01/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Limpa o campo E1_OK para efetuar marca��o. 					  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 �fa110blank() 															  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 �FINA110																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fa110Blank()

Reclock("SE1")
Replace E1_OK with "  "
SE1->(MsUnlock())


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �fa110ChecF� Autor � Mauricio Pequim Jr.   � Data � 06/01/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna Condi��o para Indice Condicional					  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 �fa110ChecF() 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
��������������������������������������������������������������������������
*/
Static Function Fa110ChecF(aSelFil,aTmpFil)

Local cFiltro := ""
Local nK := 0
Local cFiliais := ""
Local nTamSM0		:= Len(FWAllFilial())
Local nTamFil		:= FWSizeFilial()

cFiltro := 'E1_SALDO > 0 .and.'
//Gestao
If lQuery
	If nTamSM0 != Len(aSelFil)
		For nK := Iif(!lResp, 1, nSFilPos) to Len(aSelFil)
			If len(cFiliais) > nQtdeByt - ( nTamFil + 1 )
				lGrtFil	:= .T.
				nSFilPos	:= nK - 1
				nK 			:= Len(aSelFil)
			Else
				cFiliais += xFilial("SE1", aSelFil[nK])+"|"
			EndIf
		Next nK
		cFiltro += 'E1_FILIAL $ "' + cFiliais + '".and. '
	EndIf
Else
	cFiltro += 'E1_FILIAL=="' + xFilial("SE1") + '".and.'
EndIf
cFiltro += 'DTOS(E1_VENCREA)>="' + DTOS(dVencIni) + '".and.'
cFiltro += 'DTOS(E1_VENCREA)<="' + DTOS(dVencFim) + '".and.'
//���������������������������������������������������������������������������Ŀ
//�Caso o parametro MV_ANTCRED esteja desligado, os titulos com data de       �
//�emissao inferior a DataBase nao farao parte do filtro, pois nao tem sentido�
//�aparecerem titulos que "ainda nao foram emitidos".                         �
//�����������������������������������������������������������������������������
If !GetMv("MV_ANTCRED")
	cFiltro += 'DTOS(E1_EMISSAO)<="'+DTOS(dDataBase)+'".and.'
EndIf
cFiltro += 'E1_CLIENTE >="'+cCliDe        +'".and.'
cFiltro += 'E1_CLIENTE <="'+cCliAte       +'".and.'
If !Empty(cBord110)
	cFiltro += 'E1_NUMBOR=="'+cBord110      +'".and.'
Else
	If mv_par06 == 1 // Filtra pelo banco informado
		cFiltro += 'E1_PORTADO=="'+cBco110 +'".and.'
		cFiltro += 'E1_AGEDEP=="' +cAge110 +'".and.'
		cFiltro += 'E1_CONTA=="'  +cCta110 +'".and.'
	Endif
	If !MovBcoBx(cMotBx,.T.)
		cFiltro += 'E1_NUMBOR=="'+ Space(TamSX3("E1_NUMBOR")[1]) +'".and.'
	EndIf
Endif
If mv_par08 == 1
	cFiltro += '!(E1_TIPO$"'+MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM+'")'
Else
	cFiltro += '(E1_TIPO$"'+MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM+'")'
Endif
// Verifica integracao com PMS e nao permite baixar titulos que tenham solicitacoes
// de transferencias em aberto.
cFiltro += ' .And. Empty(E1_NUMSOL)'

// Para o Brasil, apresenta somente os titulos cuja moeda e' a mesma do banco
// selecionado para baixa.
// Caso a moeda do banco estiver vazia ou caso o motivo de baixa nao movimente banco, considero apenas a moeda forte
If lFuncMltSld .AND. FXMultSld()
	If SA6->A6_MOEDA > 1 .And. MovBcoBx(cMotBx,.T.)
		cFiltro += ".AND. E1_MOEDA == " + StrZero( SA6->A6_MOEDA, 2 ) + " "
		If cPaisLoc=="BRA" .AND. FindFunction( "FXVldBxBco" )
			cFiltro+=" .and. Eval({||FXVldBxBco('"+cBco110+"','"+cAge110+"','"+cCta110+"',SE1->E1_NATUREZ, SE1->E1_MOEDA,.F.)}) "
		Endif
	Endif
EndIf

If !Empty(cFil110)
	cFiltro := '(' +cFiltro+ ').and.(' +cFil110+ ')'
Endif

Return cFiltro

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �fa110Corre� Autor � Mauricio Pequim Jr 	  � Data � 06/01/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Calcula a corre��o monet�ria.								    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 �fa110Corr()																  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 �Gen�rico																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fa110Correc( )

Local nCorrecao := 0
Local nValAtual := 0
Local nValEmiss := 0

IF SE1->E1_MOEDA > 1
	IF Int(SE1->E1_VLCRUZ) = Int(xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,1,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)))
		nValEmiss := SE1->E1_VLCRUZ
	Else
		If(SE1->(FieldPos("E1_TXMDCOR")>0 ) .And. !Empty(SE1->E1_TXMDCOR))
			nValEmiss := xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,1,Iif(Empty(SE1->E1_DTVARIA),SE1->E1_EMISSAO,SE1->E1_DTVARIA),8,SE1->E1_TXMDCOR)
		Else
			nValEmiss := xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,1,Iif(Empty(SE1->E1_DTVARIA),SE1->E1_EMISSAO,SE1->E1_DTVARIA),8,Iif(Empty(SE1->E1_DTVARIA),SE1->E1_TXMOEDA,0))
		EndIf
	EndIF
	nValAtual := xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,1,dDataBase)
	//�����������������������������������������������������������������Ŀ
	//� Verifica atraves do parametro MV_CALCCM se sera calculada a cor-�
	//� recao monetaria.                                           	  �
	//� Caso o parametro nao exista, sera assumido "S"						  �
	//�������������������������������������������������������������������
	If GetMv("MV_CALCCM") == "S"
		nCorrecao := nValAtual - nValEmiss
	Else
		nCorrecao := 0
	Endif
Endif
Return (nCorrecao)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �fA110Par	� Autor � Mauricio Pequim Jr 	  � Data � 06/01/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Ativa Par�metros do Programa										  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � 																			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Gen�rico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fA110Par()
pergunte("FIN110",.T.)
Return .T.

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Fa110Marca� Autor � Mauricio Pequim Jr    � Data � 06/01/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Trata o valor	para marcar e desmarcar item					  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � Fa110Marca(ExpN1,ExpD1,ExpD2) 									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � FINA110																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fa110Marca(cAlias,cMarca,aTitulos)
Local lBxTit := .T.
Local lPrjCni       := FindFunction("ValidaCNI") .And. ValidaCNI()
Local lF110TIT		:= ExistBlock("F110TIT")
Local nAbat  		:= 0
Local nRec      	:= 0
Local cAliasAnt 	:= Alias()
Local dBaixa		:= CTOD("//")
Local nX				:= 0
Local lRet := .T.
Local cMarcaSE1 := ""
Private nValorMarca	:= 0 // Permitir alterar valor do titulo marcado no PE F110TIT

DEFAULT aTitulos := {}

dbSelectArea(cAlias)
nRec	:= Recno()

//Rotina Padrao (nao automatizada)
If Empty(aTitulos)

	DbGoTop()
	While !Eof()
		//Gestao
		If lQuery
			dbSelectArea("SE1")
			SE1->(dbGoto((cAlias)->(RECNO() )))
		Endif

		nJuros   := 0
		nMulta	 := 0
		nCM1 	 := 0
		nProRata := 0
		//��������������������������������������������������������������������Ŀ
		//� Somente deve marcar o titulo se passar na validacao da data limite �
		//� para operacoes financeiras (MV_DATAFIN) e de permissao de baixa do �
		//� titulo com data de credito menor que a emissao (MV_ANTCRED)        �
		//����������������������������������������������������������������������
		If fA070Data() // Calcula o desconto e o juros (se houver) e valida a data
			dBaixa := CriaVar("E1_BAIXA")
			//���������������������������������������������������������������Ŀ
			//� PONTO DE ENTRADA F110TIT                                      �
			//� Verifica se titulo pode ser marcado para baixa ou n�o. Caso	�
			//� tenha sido alterada a marca��o do titulo, ExecBlock dever�    �
			//� retornar .F., para n�o haver altera��o dos acumuladores de    �
			//� valores e numero de titulos.                                  �
			//�����������������������������������������������������������������
			lBxTit := .T.
			nAbat := SomaAbat(E1_PREFIXO,E1_NUM,E1_PARCELA,"R",E1_MOEDA,dDataBase,E1_CLIENTE,E1_LOJA)
			If FindFunction("FA070Integ")
				lRet:=Fa070Integ(.F.,.F.)
			Endif
			If lRet
				If SE1->(MsRLock()) // Se conseguir travar o registro
					cMarcaSE1 := SE1->E1_OK

					if lPrjCni
						If MovBcoBx(cMotBx, .T. ) .And. Posicione("SED",1,xfilial("SED") + SE1->(E1_NATUREZ),"ED_MOVBCO") != "2"
							SE1->E1_OK := cMarca
							nValorMarca	:= xMoeda(E1_SALDO+E1_SDACRES-E1_SDDECRE+nJuros+(nCM1+nProRata)+nMulta-nAbat-FaDescFin("SE1",dBaixa,SE1->E1_SALDO,1),SE1->E1_MOEDA,nMoedaBco,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						Endif
					Else
						SE1->E1_OK := cMarca
						nValorMarca	:= xMoeda(E1_SALDO+E1_SDACRES-E1_SDDECRE+nJuros+(nCM1+nProRata)+nMulta-nAbat-FaDescFin("SE1",dBaixa,SE1->E1_SALDO,1),SE1->E1_MOEDA,nMoedaBco,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					EndIf

					If lF110TIT
						lBxTit := ExecBlock("F110TIT",.F.,.F.,{nValorMarca})
					Endif
					If lBxTit
						nValor += nValorMarca
						nQtdTit++
					Else
						SE1->E1_OK := cMarcaSE1
					Endif
					If lFCalDesc
						 ExecBlock("FCalDesc",.F.,.F.,{cMarca,1},)
					Endif
					SE1->(MsUnlock())
				Endif
			Endif
			nDescGeral += nDescont
		EndIf
		dbSkip()
	EndDo
Else

	//Rotina Automatizada
	For nX := 1 to Len(aTitulos)

		nJuros		:= 0
		nMulta		:= 0
		nCM1		:= 0
		nProRata	:= 0

		(cAlias)->(dbGoto(aTitulos[nX]))

		//��������������������������������������������������������������������Ŀ
		//� Somente deve marcar o titulo se passar na validacao da data limite �
		//� para operacoes financeiras (MV_DATAFIN) e de permissao de baixa do �
		//� titulo com data de credito menor que a emissao (MV_ANTCRED)        �
		//����������������������������������������������������������������������
		If fA070Data() // Calcula o desconto e o juros (se houver) e valida a data
			dBaixa := CriaVar("E1_BAIXA")
			//���������������������������������������������������������������Ŀ
			//� PONTO DE ENTRADA F110TIT                                      �
			//� Verifica se titulo pode ser marcado para baixa ou n�o. Caso	�
			//� tenha sido alterada a marca��o do titulo, ExecBlock dever�    �
			//� retornar .F., para n�o haver altera��o dos acumuladores de    �
			//� valores e numero de titulos.                                  �
			//�����������������������������������������������������������������
			lBxTit := .T.
			nAbat := SomaAbat(E1_PREFIXO,E1_NUM,E1_PARCELA,"R",E1_MOEDA,dDataBase,E1_CLIENTE,E1_LOJA)
			If FindFunction("FA070Integ")
				lRet:=Fa070Integ(.F.,.F.)
			Endif
			If lRet
				If SE1->(MsRLock()) // Se conseguir travar o registro
					cMarcaSE1 := SE1->E1_OK

					if lPrjCni
						If MovBcoBx(cMotBx, .T. ) .And. Posicione("SED",1,xfilial("SED") + SE1->(E1_NATUREZ),"ED_MOVBCO") != "2"
					   		SE1->E1_OK := cMarca
					   		nValorMarca	:= xMoeda(E1_SALDO+E1_SDACRES-E1_SDDECRE+nJuros+(nCM1+nProRata)+nMulta-nAbat-FaDescFin("SE1",dBaixa,SE1->E1_SALDO,1),SE1->E1_MOEDA,nMoedaBco,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					 	Endif
					Else
						SE1->E1_OK := cMarca
						nValorMarca	:= xMoeda(E1_SALDO+E1_SDACRES-E1_SDDECRE+nJuros+(nCM1+nProRata)+nMulta-nAbat-FaDescFin("SE1",dBaixa,SE1->E1_SALDO,1),SE1->E1_MOEDA,nMoedaBco,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					EndIf

					If lF110TIT
						lBxTit := ExecBlock("F110TIT",.F.,.F.,{nValorMarca})
					Endif
					If lBxTit
						nValor += nValorMarca
						nQtdTit++
					Else
						SE1->E1_OK := cMarcaSE1
					Endif
					SE1->(MsUnlock())
				Endif
				nDescGeral += nDescont
	  		Endif
		EndIf
   Next nX

Endif

dbGoto(nRec)
dbSelectArea(cAliasAnt)

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Fa110bAval � Autor � Mauricio Pequim Jr.  � Data � 02/04/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Bloco de marcacoo       			          						  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � Fa110bAval()		  													  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � FINA110																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Fa110bAval(cAliasSe1,cMarca,oValor,oQtdTit,oMark,nValor)
Local lRet 		:= .T.
Local lFA070:=FindFunction("FA070Integ")//validacao da integdef de baixa de titulo
// Verifica se o registro nao esta sendo utilizado em outro terminal
If lFA070
	lREt:=IIF(SE1->E1_OK==cMarca,.T.,Fa070Integ(.F.,.T.))
Endif
If lRet
	If SE1->(MsRLock())
		Fa110Inverte(cAliasSe1,cMarca,oValor,oQtdTit,.F.,oMark,@nValor) // Marca o registro e trava
		lRet := .T.
	Else
		IW_MsgBox(STR0024,STR0025,"STOP") //"Este titulo est� sendo utilizado em outro terminal"###"Aten��o"
		lRet := .F.
	Endif
Endif

If lF110POSTIT
	ExecBlock("F110POSTIT", .F., .F.)
Endif

oMark:oBrowse:Refresh(.t.)
Return lRet



/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �FA110Inver� Autor � Mauricio Pequim Jr 	  � Data � 06/01/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Marca / Desmarca todos os titulos								  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � FINA110																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fa110Inverte(cAliasSe1,cMarca,oValor,oQtda,lTodos,oMark,nValor)
Local lPrjCni       := FindFunction("ValidaCNI") .And. ValidaCNI()
Local nReg			:= SE1->(Recno())
Local lBxTit 		:= .T.
Local lF110TIT		:= ExistBlock("F110TIT")
Local nAbat 		:= 0
Local dBaixa

Private nValorMarca	:= 0 // Permitir alterar valor do titulo marcado no PE F110TIT

DEFAULT lTodos  := .T.

dbSelectArea("SE1")
If lTodos
	If lQuery
		dbGoTop()
	Else
		dbSeek(cFilial)
	Endif
Endif

While !lTodos .or. (!Eof() .and. If(lQuery,.T.,cFilial == E1_FILIAL))
	dBaixa := CriaVar("E1_BAIXA")
	If (lTodos .And. SE1->(MsRLock())) .Or. !lTodos
		nJuros   := 0
		nCM1     := 0
		nProRata := 0
		nMulta   := 0
		//��������������������������������������������������������������������Ŀ
		//� Somente deve marcar o titulo se passar na validacao da data limite �
		//� para operacoes financeiras (MV_DATAFIN) e de permissao de baixa do �
		//� titulo com data de credito menor que a emissao (MV_ANTCRED)        �
		//����������������������������������������������������������������������
		if lPrjCni
		    If FA070VlNat(cMotBx) // VALIDA NATUREZA
				If fA070Data() // Calcula o desconto e o juros (se houver) e valida a data
					dbSelectArea("SE1")
					nAbat := SomaAbat(E1_PREFIXO,E1_NUM,E1_PARCELA,"R",E1_MOEDA,dDataBase,E1_CLIENTE,E1_LOJA)
					IF SE1->E1_OK == cMarca
						SE1->E1_OK	:= "  "
						SE1->(MsUnlock())
						nValor -= xMoeda(E1_SALDO+E1_SDACRES-E1_SDDECRE+nJuros+(nCM1+nProRata)+nMulta-nAbat-FaDescFin("SE1",dBaixa,SE1->E1_SALDO,1),SE1->E1_MOEDA,nMoedaBco,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						nQtdTit--
					Else
						lBxTit := .T.
						SE1->E1_OK	:= cMarca
						nValorMarca	:= xMoeda(E1_SALDO+E1_SDACRES-E1_SDDECRE+nJuros+(nCM1+nProRata)+nMulta-nAbat-FaDescFin("SE1",dBaixa,SE1->E1_SALDO,1),SE1->E1_MOEDA,nMoedaBco,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						//���������������������������������������������������������������Ŀ
						//� PONTO DE ENTRADA F110TIT                                      �
						//� Verifica se titulo pode ser marcado para baixa ou n�o. Caso	�
						//� tenha sido alterada a marca��o do titulo, ExecBlock dever�    �
						//� retornar .F., para n�o haver altera��o dos acumuladores de    �
						//� valores e numero de titulos.                                  �
						//�����������������������������������������������������������������
						IF lF110Tit .and. !Empty(E1_OK)
							lBxTit := ExecBlock("F110TIT",.F.,.F.,{nValorMarca})
						Endif
						If lBxTit
							nValor += nValorMarca
							nQtdTit++
						Else
							Fa110bAval(cAliasSe1,cMarca,oValor,oQtda,oMark,nValor)
						EndIf
						SE1->(MsUnlock())
					Endif
				EndIf
            EndIf
		Else
			If fA070Data() // Calcula o desconto e o juros (se houver) e valida a data
				dbSelectArea("SE1")
				nAbat := SomaAbat(E1_PREFIXO,E1_NUM,E1_PARCELA,"R",E1_MOEDA,dDataBase,E1_CLIENTE,E1_LOJA)
				IF SE1->E1_OK == cMarca
					SE1->E1_OK	:= "  "
					SE1->(MsUnlock())
					nValor -= xMoeda(E1_SALDO+E1_SDACRES-E1_SDDECRE+nJuros+(nCM1+nProRata)+nMulta-nAbat-FaDescFin("SE1",dBaixa,SE1->E1_SALDO,1),SE1->E1_MOEDA,nMoedaBco,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nQtdTit--
				Else
					lBxTit := .T.
					SE1->E1_OK	:= cMarca
					nValorMarca	:= xMoeda(E1_SALDO+E1_SDACRES-E1_SDDECRE+nJuros+(nCM1+nProRata)+nMulta-nAbat-FaDescFin("SE1",dBaixa,SE1->E1_SALDO,1),SE1->E1_MOEDA,nMoedaBco,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					//���������������������������������������������������������������Ŀ
					//� PONTO DE ENTRADA F110TIT                                      �
					//� Verifica se titulo pode ser marcado para baixa ou n�o. Caso	�
					//� tenha sido alterada a marca��o do titulo, ExecBlock dever�    �
					//� retornar .F., para n�o haver altera��o dos acumuladores de    �
					//� valores e numero de titulos.                                  �
					//�����������������������������������������������������������������
					IF lF110Tit .and. !Empty(E1_OK)
						lBxTit := ExecBlock("F110TIT",.F.,.F.,{nValorMarca})
					Endif
					If lBxTit
						nValor += nValorMarca
						nQtdTit++
					Else
						Fa110bAval(cAliasSe1,cMarca,oValor,oQtda,oMark,nValor)
					EndIf
					SE1->(MsUnlock())
				Endif
			EndIf
		EndIf

	Endif
	If lFCalDesc
		ExecBlock("FCalDesc",.F.,.F.,{cMarca,1},)
	Endif
	If lTodos
		dbSkip()
	Else
		Exit
	Endif
Enddo
nQtdTit:= Iif(nQtdTit<0,0,nQtdTit)
SE1->(dbGoto(nReg))
oValor:Refresh()
oQtda:Refresh()
oMark:oBrowse:Refresh(.t.)
Return Nil

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �F110BxBord� Autor � Mauricio Pequim Jr    � Data � 06/01/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Controla permissao de baixa automatica de bordero   		  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � FINA110													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function F110BxBord()
Local lBxBord := .T.
//���������������������������������������������������������������Ŀ
//� PONTO DE ENTRADA F110BOR                                      �
//� Verifica se bordero pode baixado ou n�o. 							�
//� ExecBlock dever� retornar .F., para n�o baixar o bordero em   �
//� questao                                                       �
//�����������������������������������������������������������������
IF ExistBlock("F110BOR")
	lBxBord := ExecBlock("F110BOR",.F.,.F.)
Endif
Return lBxBord

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �VerCliFor � Autor � Mauricio Pequim Jr    � Data � 06/01/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Carrega  as variaveis Cliente/Fornecedor e Loja             ���
���			 �Carrega os proximos campos quando valor digitado for encon- ���
���			 �trado. 																	  ���
���			 �As variaveis cClifor e cLoja dever�o ser passadas por refe- ���
���			 �rencia.         														  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 �VerCliFor(ExpC1,ExpC2,ExpL1,ExpC3)								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Cliente/Fornecedor,Loja,Flag para Help no ato (default= .T.)���
���			 �Carteira                                						  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VerCliForn(cCliFor,cLoja,lHelp,cCarteira)
Local cAlias:=Alias()
Local cChave:=cCliFor+Iif(Empty(cLoja),"",cLoja)
Local lRet:=.T.
Local cArea := IIF(cCarteira == "R", "A1","A2")
Local cOpenArq := "S" + cArea

If (cCliFor = NIL) .or. (cCarteira = NIL)
	lRet := .F.
Endif

If lRet
	lHelp := Iif( lHelp=Nil,.T.,lHelp)
	DbSelectArea(cOpenArq)
	DbSetOrder(1)
	If !DbSeek(xFilial()+cChave)
		If lHelp
			Help(" ",1,IIF(cCarteira == "R","NOCLIENTE","NOFORNEC"))
		EndIf
		lRet := .F.
	Else
		cLoja := Iif(cLoja==NIl.or.Empty(cLoja),&cArea._LOJA,cLoja)
	Endif
Endif
DbSelectArea( cAlias )
Return lRet

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Fa110TudOk� Autor � Claudio D. de Souza   � Data � 22/05/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Valida os gets da tela inicial da baixa automatica          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 �Fa110TudOk(.T./.F.)        								           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�lBxCnab - Se a baixa se aglutinada                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � FINA110  																  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fa110TudOk(lBxCnab)
Local lRet := .T.
Local nMoeda := 0

// Valida todos os gets
Do Case
Case !(dVencFim >= dVencIni)
	lRet := .F.
Case !(cCliAte >= cCliDe)
	lRet := .F.
Case MovBcoBx(cMotBx, .T.) .and. !(CarregaSa6(@cBco110,,,.T.))
	lRet := .F.
Case MovBcoBx(cMotBx, .T.) .and. !(CarregaSa6(@cBco110,@cAge110,,.T.))
	lRet := .F.
Case MovBcoBx(cMotBx, .T.) .and. !(CarregaSa6(@cBco110,@cAge110,@cCta110,.T.,,.T.))
	lRet := .F.
Case !(ShowMotBx("R",.T.))
	lRet := .F.
Case !(F110BXBORD() .and. IIF(!MovBcoBx(cMotBx, .T.),Empty(cBord110),.T.))
	lRet := .F.
Case (!Empty(cBord110) .And. lBxCnab)  .And. !(CheckLote("R"))
	lRet := .F.
EndCase

If lFuncMltSld .AND. FXMultSld() .AND. !Empty( cBord110 )
	//Valida se banco da tela e banco do portador possuem mesma moeda
	//Evitando que se baixe o bordero de portador US$ em conta EURO, por exemplo.
	//
	//Exemplos:
	//Moeda Portador (SEA) - Moeda Banco Tela - Pode Baixar
	//--------------------------------------------------------
	//		R$							R$						OK
	//		US$						R$						OK
	//		US$						US$					OK
	//		US$						EURO					NAO
	//		R$							US$					NAO
	//--------------------------------------------------------
	If !Empty(cBord110)
		SEA->(DBSETORDER(2))
		If SEA->(MsSeek(xFilial("SEA")+cBord110+"R"))
			//Obtenho a moeda do Portador
			nMoeda := Max( MoedaBco(SEA->EA_PORTADO,SEA->EA_AGEDEP,SEA->EA_NUMCON), 1)
		Endif
		//Valido se o banco da tela pode receber baixa do bordero
		lRet := FXVldBco( cBco110, cAge110, cCta110, nMoeda, .T.)
	Endif
EndIf

If lRet .and. ExistBlock("F110TOK")
	lRet := ExecBlock("F110TOK",.F.,.F.,{cBco110,cAge110,cCta110})
Endif

Return lRet


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �F110Ret   � Autor � Mauricio Pequim Jr    � Data � 25/11/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Tratamento de retencao na data de credito					 	  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � FINA110				 													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function F110Ret()

Local nJ := 0

dDtCredito := dBaixa
If mv_par07 == 1 // Considera retencao bancaria
	SA6->(MsSeek(xFilial("SA6")+cBanco+cAgencia+cConta))

	If !(SA6->(Eof())) .AND. SA6->A6_RETENCA > 0 .AND. SE1->E1_SITUACA $ "12347"
		//����������������������������������������������Ŀ
		//� Atualiza data vencto real c/reten��o Banc�ria�
		//������������������������������������������������
		For nj:=1 To SA6->A6_RETENCA
			dDtCredito = DataValida(dDtCredito+1,.T.)
		Next nj
	Else
		dDtCredito := dDataBase
	Endif
Endif
Return .T.

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Ana Paula N. Silva     � Data �22/11/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �		1 - Pesquisa e Posiciona em um Banco de Dados     ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()
Local aRotina	:= {	{ STR0026, "AxPesqui" , 0 , 1,,.F. },; // "Pesquisa"
						{ STR0001, "fA110Par", 0 , 1},; // "Par�metros"
						{ STR0002, "fA110Aut", 0 , 2},; // "Autom�tica"
						{ OemToAnsi(STR0022)	,"FA040Legenda", 0 , 6, ,.F.} } //"Legenda"
Return(aRotina)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FA110BtOK � Autor � Gustavo Henrique     � Data � 11/06/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao no botao OK da tela de baixa					  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � FA110BtOK()			 									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � FINA110													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FA110BtOK()

Local lFa110BtOk	:= ExistBlock("F110BtOK")
Local lRet := .T.

If lFa110BtOk
	lRet := ExecBlock("F110BtOK",.F.,.F.)
Endif

Return lRet


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FinA110T   � Autor � Marcelo Celi Marques � Data � 27.03.08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada semi-automatica utilizado pelo gestor financeiro   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINA110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FinA110T(aParam)

	cRotinaExec := "FINA110"
	ReCreateBrow("SE1",FinWindow)
	FinA110(aParam[1])
	ReCreateBrow("SE1",FinWindow)

	dbSelectArea("SE1")

	INCLUI := .F.
	ALTERA := .F.

Return .T.

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �AjustaSx1  � Autor � Pedro Pereira Lima   � Data � 04/12/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Ajusta SX1            			          				  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaSx1()

Local aArea 	:= GetArea()
Local aHelpPor  := {}
Local aHelpEng  := {}
Local aHelpSpa  := {}
Local cPerg		:= "FIN110"

// Inclus�o de pergunta "Modelo de Cadastro"
SX1->( dbSetOrder( 1 ) )

If !SX1->( dbSeek( PadR( cPerg, Len( X1_GRUPO ) )+"09" ) )

	// Portugues
	aHelpPor := {STR0029,STR0030,STR0031}
	// Ingles
	aHelpEng := {STR0029,STR0030,STR0031}
	// Espanhol
	aHelpSpa := {STR0029,STR0030,STR0031}

	PutSX1(cPerg,"09",STR0032,STR0032,STR0032,"mv_ch9","N",1,0,2,"C","","","","","mv_par09","Sim","Si","Yes","","N�o","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")
	PutSX1Help("P."+cPerg+"09.",aHelpPor,aHelpEng,aHelpSpa,.T.)
Endif

//Gestao
If !SX1->((MsSeek(PadR(cPerg,Len(SX1->X1_GRUPO))+"10")))

	// Par�metro 10 - Seleciona Filial
	aHelpPor := {"Escolha Sim se deseja selecionar ","as filiais. ","Esta pergunta somente ter� efeito em","ambiente TOPCONNECT / TOTVSDBACCESS."}
	aHelpEng := {"Enter Yes if you want to select ","the branches.","This question affects TOPCONNECT / ","TOTVSDBACCESS environment only."}
	aHelpSpa := {"La opci�n S�, permite seleccionar ","las sucursales","Esta pregunta solo tendra efecto en el ","entorno TOPCONNECT / TOTVSDBACCESS."}

	PutSx1( cPerg, "10", "Seleciona Filiais?" ,"�Selecciona sucursales?" ,"Select Branches?","mv_chA","N",1,0,2,"C","","","","S","mv_par10","Sim","Si ","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

	PutSX1Help("P."+cPerg+"10.",aHelpPor,aHelpEng,aHelpSpa,.T.)

Endif

// Altera��o de pergunta "Abate Desc. Comiss. ?"
SX1->( dbSetOrder( 1 ) )
If SX1->( dbSeek( PadR( cPerg, Len( X1_GRUPO ) )+"04" ) )
	SX1->(Reclock("SX1",.F.))
		//Portugu�s
		SX1->X1_PERGUNT := STR0043 // 'Abate Desc/Decres Comiss.?'
		//Espanhol
		SX1->X1_PERSPA  := STR0043
		//Ingles
		SX1->X1_PERENG  := STR0043
	SX1->(MsUnlock())

	//Ajusta Help
	aHelpPor := {STR0045,STR0047}
	aHelpSpa := {STR0045,STR0047}
	aHelpEng := {STR0045,STR0047}

	PutSX1Help("P."+cPerg+"04.",aHelpPor,aHelpEng,aHelpSpa)
EndIf

// Altera��o de pergunta "Cons.Juros Comissao ?"
If SX1->( dbSeek( PadR( cPerg, Len( X1_GRUPO ) )+"05" ) )
	SX1->(Reclock("SX1",.F.))
		//Portugu�s
		SX1->X1_PERGUNT := STR0044 // 'Cons.Juros/Acres Comissao?'
		//Espanhol
		SX1->X1_PERSPA  := STR0044
		//Ingles
		SX1->X1_PERENG  := STR0044
	SX1->(MsUnlock())

	//Ajusta Help
	aHelpPor := {STR0046,STR0047}
	aHelpSpa := {STR0046,STR0047}
	aHelpEng := {STR0046,STR0047}

	PutSX1Help("P."+cPerg+"05.",aHelpPor,aHelpEng,aHelpSpa)
EndIf

RestArea(aArea)

Return
