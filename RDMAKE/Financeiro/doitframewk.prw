#INCLUDE "DoItframewk.ch"
#INCLUDE "PRINT.CH"
#INCLUDE "PROTHEUS.CH"
Static aPapel		:= {}
Static PrtFontes := 1
Static cNameSave	:= ""

Static cPrtPerg 	:= ""
Static oPrint
Static aPaperSize	:= {}
Static aSave		:= {}
Static nTpPaper	:= 1
Static aFontes		:= {}
Static aCondFil	:= {}
Static DItPrtTit	:= ""
Static aSetCols		:= {}
Static nPagAtu		:= 0
Static lRodape		:= .T.
Static nDItPrtFor	:= 1
Static lDItPrtPrev	:= .T.
Static nDItPrtCop	:= 1
Static nClassic	:= 1
Static nOldPosY	:= 0
Static nTipo		:= 0
Static Tamanho
Static Li			:= 1
Static aSavRet							//Compatibilizacao relatorio classico
Static nSavPag		:= 1
Static aImprime	:= {}
Static aPosY := {}
Static SavwnRel
/*/
_F_U_N_C_ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³DItPrtIni³ AUTOR ³ Edson Maricate         ³ DATA ³ 07-01-2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ Funcao generia de inicializacao para impressao grafica.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ USO      ³ Generico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³_DOCUMEN_ ³ DItPrtIni                                                    ³±±
±±³_DESCRI_  ³ Funcao generia de inicializacao para impressao grafica.      ³±±
±±³_DESCRI_  ³ utilizando as funcoes TmsPrinter do Protheus.                ³±±
±±³_FUNC_    ³ Esta funcao podera ser utilizada em impressoes de relatorios ³±±
±±³_FUNC_    ³ graficos utilizando o conceito de celulas/cores e fontes.    ³±±
±±³_FUNC_    ³ Sempre devera ser executada no inicio da montagem do relat.  ³±±
±±³_FUNC_    ³ para criacao do objeto grafico oPrint.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³_PARAMETR_³ ExpC1 : Titulo do Relatorio                                  ³±±
±±³_PARAMETR_³ ExpL2 : Indica se o relatorio devera ser impresso no formato ³±±
±±³_PARAMETR_³         LandScape ( Paisagem )                               ³±±
±±³_PARAMETR_³ ExpN3 : Fonte utilizada no relatorio ( 1=Courier New,        ³±±
±±³_PARAMETR_³         2=Arial )                                            ³±±
±±³_PARAMETR_³ ExpL4 : Indica se imprime o rodape na quebra de paginas.     ³±±
±±³_PARAMETR_³ ExpL5 : Variavel de confirmacao para geracao do relatorio.   ³±±
±±³_PARAMETR_³ ExpC6 : Grupo de perguntas utilizado no relatorio.           ³±±
±±³_PARAMETR_³ ExpC7 : Texto informativo contendo os detalhes do relatorio. ³±±
±±³_PARAMETR_³ ExpL8 : Flag para utilização do formato padrao (SetPrint).   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DItPrtIni(cTitulo,lForceLand,nFontes,lImpRodape,lOk,cPerg,cDetail,lClassic,nOrient,aFiltros)

Local aRet	:= {}
Local cUserName	:= ""

PRIVATE aReturn							//Compatibilizacao relatorio classico
PRIVATE nLastKey	:= 0					//Compatibilizacao relatorio classico
PRIVATE Titulo		:= cTitulo			//Compatibilizacao relatorio classico
DEFAULT lForceLand := .F.
DEFAULT nOrient	 := 1	// 1=Portrait ## 2=Landscape
DEFAULT lImpRodape := .T.
DEFAULT cPerg	:= ""
DEFAULT cDetail	:= STR0001+cTitulo+STR0002 //"Este relatorio ira imprimir a "###" de acordo com os parametros solicitados pelo usuário. Para mais informações sobre este relatorio consulte o Help do Programa ( F1 )."
DEFAULT lClassic	:= .F.
DEFAULT aFiltros 	:= {}

nClassic		:= If(lClassic,2,1)
nDItPrtFor	:= If(lForceLand,2,nOrient)
lRodape		:= lImpRodape
DItPrtTit	:= cTitulo+SPACE(30)
nPagAtu		:= 0
lDItPrtPrev	:= .T.
nDItPrtCop	:= 1
aCondFil		:= aFiltros
aSave			:= {}
cPrtPerg 	:= cPerg
PrtFontes	:= nFontes
// Tamanhos dos papeis em PIXEL
aPapel := {STR0020,STR0021,STR0022,STR0023,STR0024,STR0025} // Carta, A4, A3 , Oficio 1, Oficio 2, Oficio 9
aPaperSize:= {	{3150,2400},; // Carta
					{3350,2330},; // A4
					{4745,3300},; // A3
					{4010,2400},; // Oficio 1
					{3730,2400},; // Oficio 2
					{3560,2390} } // Oficio 9

psworder(1)
PswSeek(__cUSerID)
aRet      := PswRet(1)
cUserName := aRet[1][2]

aAdd(aSave,{"PGREPORT1.1",PrtFontes, Nil })
cNameSave := ""


If lClassic
	lOk := .F.
	aReturn := { STR0003, 1,STR0004, 2, 2, 1, "",1 } //"Zebrado"###"Administracao"

	Tamanho := If(nDItPrtFor==2,"G","M")

	LI := 350

	wnrel:=SetPrint("",ProcName(1),cPerg,@Titulo,cDetail,"","",.F.,{},!lForceLand,Tamanho)

	If nLastKey == 27
		Set Filter To
		Return
	Endif

	lOk := .T.
	SetDefault(aReturn,"")

	If lOk
		If !Empty(cPerg)
			Pergunte(cPerg,.F.)
		EndIf
	EndIf
	nTipo := IIF(aReturn[4]==1,15,18)
	aImprime	:= {}
	aPosY := {}
	SavwnRel := wnrel

	aSavRet := aClone(aReturn)
	Return

Else
	//Carrega profile do usuario (expansao da arvore do projeto)
	If FindProfDef( cUserName, "DItXIMP", "PAPER_TYPE", "DItXIMP" )
		nTpPaper := Val(RetProfDef(cUserName,"DItXIMP","PAPER_TYPE", "DItXIMP"))
	Endif

	oPrint := PrintNew( cTitulo )

	lOk := U_DItPrtDlg(@oPrint,@nDItPrtFor,lForceLand,cPerg,cDetail,@lDItPrtPrev,@nDItPrtCop,@nFontes)

	If lOk

		If nFontes == 1
			aAdd(aFontes,{TFont():New("Courier New",03,06,,.T.,,,,.T.,.F.),16})
			aAdd(aFontes,{TFont():New("Courier New",06,08,,.T.,,,,.T.,.F.),18})
			aAdd(aFontes,{TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.),22})
			aAdd(aFontes,{TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.),22})
			aAdd(aFontes,{TFont():New("Courier New",15,15,,.T.,,,,.T.,.F.),25})
			aAdd(aFontes,{TFont():New("Courier New",20,20,,.T.,,,,.T.,.F.),28})

			aAdd(aFontes,{TFont():New("Courier New",03,06,,.F.,,,,.T.,.F.),16})
			aAdd(aFontes,{TFont():New("Courier New",06,08,,.F.,,,,.T.,.F.),18})

		Else
			aAdd(aFontes,{TFont():New("Arial",03,06,,.T.,,,,.T.,.F.),16})
			aAdd(aFontes,{TFont():New("Arial",06,08,,.T.,,,,.T.,.F.),18})
			aAdd(aFontes,{TFont():New("Arial",10,10,,.F.,,,,.T.,.F.),22})
			aAdd(aFontes,{TFont():New("Arial",10,10,,.T.,,,,.T.,.F.),22})
			aAdd(aFontes,{TFont():New("Arial",15,15,,.T.,,,,.T.,.F.),25})
			aAdd(aFontes,{TFont():New("Arial",20,20,,.T.,,,,.T.,.F.),28})

			aAdd(aFontes,{TFont():New("Arial",03,06,,.F.,,,,.T.,.F.),16})
			aAdd(aFontes,{TFont():New("Arial",06,08,,.F.,,,,.T.,.F.),18})

		EndIf


		If !Empty(cPerg)
			Pergunte(cPerg,.F.)
		EndIf
		If lForceLand .Or. nDItPrtFor == 2
			PrintLandScape()
			nDItPrtFor := 2
			nOrient	:=2
		Else
			PrintPortrait()
			nOrient	:=1
		EndIf
		// Grava a configuração da impressora do usuario
		If FindProfDef( cUserName, "DItXIMP", "PAPER_TYPE", "DItXIMP" )
			WriteProfDef(cUserName, "DItXIMP", "PAPER_TYPE", "DItXIMP", cUserName, "DItXIMP", "PAPER_TYPE", "DItXIMP", Str(nTpPaper) )
		Else
			WriteNewProf( cUserName, "DItXIMP", "PAPER_TYPE", "DItXIMP", Str(nTpPaper) )
		Endif
	EndIf
EndIf

Return oPrint

/*/
_F_U_N_C_ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³DItCell³ AUTOR ³ Edson Maricate        ³ DATA ³ 07-01-2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³Funcao de impressao das celulas do relatorio.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ USO      ³ Generico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³_DOCUMEN_ ³ DItCell                                                   ³±±
±±³_DESCRI_  ³ Funcao de impressao das celulas do relatorio.                ³±±
±±³_DESCRI_  ³ Deve ser utilizado junto com a funcao U_DItPrtIni.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³_PARAMETR_³ ExpN1 : Posição X de impressão da celula                     ³±±
±±³_PARAMETR_³ ExpN2 : Posição Y de impressão da celula                     ³±±
±±³_PARAMETR_³ ExpN3 : Tamanho da celula                                    ³±±
±±³_PARAMETR_³ ExpN4 : Altura da celula                                     ³±±
±±³_PARAMETR_³ ExpC5 : Texto a ser exibido                                  ³±±
±±³_PARAMETR_³ ExpO6 : Objeto oPrint criado pela U_DItPrtIni                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DItCell(nPosX,nPosY,nTamanho,nAltura,cSay,oPrint,nStilo,nFonte,nColor,cToolTip, lAlinDir,cCampo,cPicture, lCentral)
Local cBmp
Local nScan
Local lImpText := .F.
Local nAltAtu := 1

DEFAULT nFonte := 1
DEFAULT lAlinDir := .F.
DEFAULT cToolTip := ""
DEFAULT nTamanho := U_DItPrtTam(1)
DEFAULT lCentral := .F.

lAlinDir := If(lCentral, .F., lAlinDir)

If cCampo <> Nil
	dbSelectArea("SX3")
	dbSetOrder(2)
	If dbSeek(cCampo)
		If cToolTip <> Nil
			cToolTip := AllTrim(X3TITULO())
		EndIf
		cSay := Transform(cSay, X3_PICTURE)
	EndIf
EndIf

If cPicture <> Nil
	cSay := Transform(cSay, cPicture)
EndIf

If nClassic == 2
	nScan := aScan(aPosY,{|x| x[1] == nPosY })
	If nScan > 0   // Recupera a posicao do nPosY ( retorno da linha na impressao )
		LI := aPosY[nScan,2]
		nOldPosY := aPosY[nScan,1]
	Else
		If nPosY<>nOldPosY
			aAdd(aPosY,{nOldPosY,LI})
			LI ++
			If nStilo == 4
				LI++
			EndIf
			nOldPosY := nPosY
		EndIf
	EndIf
	If nStilo == 4
		aAdd(aImprime,{LI-1,If(Tamanho=="G",220*(nPosX+3)/3400,132*(nPosX+3)/2400),cToolTip})
	EndIf
	If lAlinDir
		aAdd(aImprime,{LI,If(Tamanho=="G",NoRound((220*(nPosX+4)/3400)+(220*nTamanho/3400)-Len(AllTrim(cSay)),0) ,NoRound((132*(nPosX+7)/2400)+(132*nTamanho/2400)-Len(Alltrim(cSay)),0) ),AllTrim(cSay)})
	Else
		aAdd(aImprime,{LI,If(Tamanho=="G",220*(nPosX+7)/3400,132*(nPosX+7)/2400),cSay})
	EndIf
Else
	Do Case
		Case nStilo == 2
			PrintBox(nPosY,nPosX,nPosY+nAltura,nPosX+nTamanho)
			If nColor != Nil
				PrintBmpBox(nPosY+2 ,nPosX+2 ,nColor,nTamanho-5,nAltura-5)
			EndIf
			lImpText := .T.
		Case nStilo == 3
			If nColor != Nil
				PrintBmpBox(nPosY ,nPosX ,nColor,nTamanho,nAltura)
			EndIf
			lImpText := .T.
		Case nStilo == 4
			PrintBox(nPosY,nPosX,nPosY+nAltura,nPosX+nTamanho)
			If nColor != Nil
				PrintBmpBox(nPosY+2 ,nPosX+2 ,nColor,nTamanho-5,nAltura-5)
			EndIf
			PrintSay(nPosY+1,nPosX+3,cToolTip,{1,1})
			nAltAtu := 16
			nPosY += 6
			lImpText := .T.
		Case nStilo == 5 .Or. nStilo == 1 // Estilo 1 fora de uso - Compatibilizacao com relatorios antigos.
			lImpText := .T.
		Case nStilo == 6 // Para impressão do cabeçalho referente ao campo ( Utiliza o tooltip como texto interno ) igual ao 2, porem utiliza o tooltip
			PrintBox(nPosY,nPosX,nPosY+nAltura,nPosX+nTamanho)
			If nColor != Nil
				PrintBmpBox( nPosY+2 ,nPosX+2 ,nColor,nTamanho-5,nAltura-5)
			EndIf
			cSay := cToolTip
			cToolTip := ""
			lImpText := .T.
		Case nStilo == 7
			PrintBox(nPosY+nAltura-1,nPosX,nPosY+nAltura,nPosX+nTamanho)
			If nColor != Nil
				PrintBmpBox( nPosY+2 ,nPosX+2 ,nColor,nTamanho-5,nAltura-5)
			EndIf
			lImpText := .T.
		Case nStilo == 8
			PrintImage( nPosY+2 ,nPosX+2 ,cSay,nTamanho-5,nAltura-5)
		Case nStilo == 9
			PrintCBar( nPosY+2 ,nPosX+2 ,cSay,nTamanho-5,nAltura-5)
	EndCase

	If lImpText
		If lAlinDir
			PrintSay(nPosY+(nAltura/2)-aFontes[nFonte][2],nPosX+4+nTamanho-U_DItPrtSize(Alltrim(cSay),nFonte),Alltrim(cSay),{nFonte,1})
		ElseIf lCentral
			PrintSay(nPosY+(nAltura/2)-aFontes[nFonte][2],nPosX+4+((nTamanho-U_DItPrtSize(Alltrim(cSay),nFonte))/2),Alltrim(cSay),{nFonte,1})
		Else
			If ( U_DItPrtSize(Alltrim(cSay),nFonte)>nTamanho .Or. CRLF $ cSay ).And. nAltura > (aFontes[nFonte][2])*4
				If U_DItPrtSize(Alltrim("Z"),nFonte)<nTamanho
					cSay := AllTrim(cSay)
					While Len(cSay) > 0 .And. !Empty(cSay)
						cLiSay := Substr(cSay,1,1)
						nLargAtu := U_DItPrtSize(cLiSay,nFonte)
						While nLargAtu<=nTamanho .And. Len(cLiSay)+1 <= Len(cSay)
							nLargAtu += U_DItPrtSize(Substr(cSay,Len(cLiSay)+1,1),nFonte)
							If Substr(cSay,Len(cLiSay),2) == CRLF
								cLiSay := Substr(cSay,1,Len(cLiSay)-1)+"  "
								Exit
							Else
								cLiSay := Substr(cSay,1,Len(cLiSay)+1)
							EndIf
						End
						If (nAltAtu+(aFontes[nFonte][2])*2) < nAltura
							PrintSay(nPosY+nAltAtu,nPosX+7,cLiSay,{nFonte,1})
							cSay := Substr(cSay,Len(cLiSay)+1)
							nAltAtu += (aFontes[nFonte][2])*2
						Else
							Exit
						EndIf
					End
				EndIf
			Else
				PrintSay(nPosY+(nAltura/2)-aFontes[nFonte][2],nPosX+7,cSay,{nFonte,1})
			EndIf
		EndIf
	EndIf
EndIf

Return

User Function DItPrtSize(cSay,nFonte)
Local nSize := 0
Local nx
Local aSize := 	{ {14.793,6.25,13.793,11.25,14.5},{19.2,2.692,15.241,13.692,17.55},{20,11.112,18,16,19.5},{21.05,10.028,19.05,17,20.75},{31.500,15.384,29.500,27,31},{41.66,20.20,38.66,36,41.2},{14.793,6.25,13.793,11.25,14.493},{17.241,2.692,15.241,13.692,16.82}}
Local aCorrec := 	{ {.075,0,.04,.03,.045},{.070,0,.04,.03,.045},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}


For nx := 1 to Len(cSay)
	If Substr(cSay,nx,1)=="." .Or. Substr(cSay,nx,1)=="," .or.  Substr(UPPER(cSay),nx,1)=="I"
		nSize += aSize[nFonte,2]-(aCorrec[nFonte,2]*Len(cSay))
	ElseIf Substr(cSay,nx,1)$"abcdefghijklmnopqrstuvxyzw"
		nSize += aSize[nFonte,4]-(aCorrec[nFonte,4]*Len(cSay))
	ElseIf Substr(UPPER(cSay),nx,1)$"ABCDEFGHIJKLMNOPQRSTUVXWYZ"
		nSize += aSize[nFonte,3]-(aCorrec[nFonte,3]*Len(cSay))
	ElseIf Substr(UPPER(cSay),nx,1)$"1"
		nSize += aSize[nFonte,5]-(aCorrec[nFonte,5]*Len(cSay))
	Else
		nSize += aSize[nFonte,1]-(aCorrec[nFonte,1]*Len(cSay))
	EndIf
Next
Return nSize
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³DItPrtCab³ Autor ³ Edson Maricate         ³ Data ³07-01-2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de impressao do cabecalho no objeto TmsPrint         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³DItPrtCab                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function DItPrtCab(oPrint,nStilo)

Local cFileLogo  := "LGRL"+SM0->M0_CODIGO+cFilAnt+".BMP"
Local nx

DEFAULT nStilo := 1
PRIVATE aReturn  // Compatibilizacao com a versao classica
If nClassic == 2
	aReturn := aSavRet
	aImprime := aSort( aImprime,,, { | x , y | Str(x[1],5)+Str(x[2],5) < Str(y[1],5)+Str(y[2],5) } )
	For nx := 1 to Len(aImprime)
		@ aImprime[nx,1],aImprime[nx,2] PSAY aImprime[nx,3]
		LI := aImprime[nx,1]
	Next
	M_PAG	:= nSavPag
	aImprime := {}
	aPosY    := {}
	wnrel := SavwnRel
	cabec(DItPrtTit,"","",wnrel,Tamanho,nTipo)
	aSavRet:=aReturn
	nSavPag := M_PAG
	SavwnRel := wnrel
Else

	If !File( cFileLogo )
		cFileLogo := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
	Endif
	If nPagAtu	== 0 .And. !Empty(cPrtPerg)
		If ImpSX1()
			nPagAtu++
		Endif
	Endif

	Do Case
		Case nStilo == 1
			If nPagAtu > 0 .And. lRodape
				If nDItPrtFor == 2
					PrintLine(aPaperSize[nTpPaper][2]-40, 20, aPaperSize[nTpPaper][2]-40, aPaperSize[nTpPaper][1] )
					PrintLine(aPaperSize[nTpPaper][2]-39, 20, aPaperSize[nTpPaper][2]-39, aPaperSize[nTpPaper][1] )
					PrintSay(aPaperSize[nTpPaper][2]-40,30,DTOC(MsDate())+" "+Time(),{3,1} )
					PrintSay(aPaperSize[nTpPaper][2]-40,aPaperSize[nTpPaper][1]-200,STR0006+Transform(nPagAtu,"@e 99999"),{3,1} )
				Else
					PrintLine(aPaperSize[nTpPaper][1]-40, 20, aPaperSize[nTpPaper][1]-40, aPaperSize[nTpPaper][2] )
					PrintLine(aPaperSize[nTpPaper][1]-39, 20, aPaperSize[nTpPaper][1]-39, aPaperSize[nTpPaper][2] )
					PrintSay(aPaperSize[nTpPaper][1]-40,30,DTOC(MsDate())+" "+Time(),{3,1} )
					PrintSay(aPaperSize[nTpPaper][1]-40,aPaperSize[nTpPaper][2]-200,STR0006+Transform(nPagAtu,"@e 99999"),{3,1} )
				Endif
			EndIf
			PrintEndPage()
			PrintStartPage()
			PrintImage(30,30, cFileLogo,474,117)
			If nDItPrtFor == 2
				PrintSay(100,(aPaperSize[nTpPaper][1]/2)-(U_DItPrtSize(Alltrim(DItPrtTit),5)/2),AllTrim(DItPrtTit),{5,1})
			Else
				PrintSay(100,(aPaperSize[nTpPaper][2]/2)-(U_DItPrtSize(Alltrim(DItPrtTit),5)/2),AllTrim(DItPrtTit),{5,1})
			EndIf
			PrintSay(146,30,QA_CHKFIL(cFilAnt,,.T.),{3,1} )
			If nDItPrtFor == 2
				PrintSay(146,aPaperSize[nTpPaper][1]-425,STR0007+DTOC(dDataBase),{3,1}) //"Data Base : "
				PrintLine(190, 20, 190, aPaperSize[nTpPaper][1] )
				PrintLine(191, 20, 191, aPaperSize[nTpPaper][1] )
			Else
				PrintSay(146,aPaperSize[nTpPaper][2]-425,STR0007+DTOC(dDataBase),{3,1}) //"Data Base : "
				PrintLine(190, 20, 190, aPaperSize[nTpPaper][2] )
				PrintLine(191, 20, 191, aPaperSize[nTpPaper][2] )
			Endif
		Case nStilo == 2
			PrintEndPage()
			PrintStartPage()
			PrintSay(50,30,AllTrim(SM0->M0_NOMECOM),{6,1})
//			PrintSay(146,30,AllTrim(SM0->M0_ENDCOB)+"-"+AllTrim(SM0->M0_BAIRCOB)+"-"+AllTrim(SM0->M0_CIDCOB)+"-"+AllTrim(SM0->M0_ESTCOB)+"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)+" C.N.P.J : "+Transform(AllTrim(SM0->M0_CGC),"@R 99.999.999/9999-99"),{3,1})
			PrintSay(146,30,AllTrim(SM0->M0_ENDENT)+" " + AllTrim(SM0->M0_COMPENT)+ "-"+AllTrim(SM0->M0_BAIRENT)+"-"+AllTrim(SM0->M0_CIDENT)+"-"+AllTrim(SM0->M0_ESTENT)+"CEP: "+Subs(SM0->M0_CEPENT,1,5)+"-"+Subs(SM0->M0_CEPENT,6,3)+" C.N.P.J : "+Transform(AllTrim(SM0->M0_CGC),"@R 99.999.999/9999-99"),{3,1})
			If nDItPrtFor == 2
				PrintLine(190, 20, 190, aPaperSize[nTpPaper][1] )
				PrintLine(191, 20, 191, aPaperSize[nTpPaper][1] )
			Else
				PrintLine(190, 20, 190, aPaperSize[nTpPaper][2] )
				PrintLine(191, 20, 191, aPaperSize[nTpPaper][2] )
			Endif
	EndCase
EndIf

nPagAtu++

Return 200

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³DItPrtCol³ Autor ³ Edson Maricate         ³ Data ³07-01-2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de configuracao das colunas do relatorio             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³DItPrtCol                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function DItPrtCol(aColunas,lAlignAuto,nChange)

Local nMaxCalc
Local nMaxAtu
Local nDiff
Local nx

Default lAlignAuto := .F.

// Quando utilizado o Alinhamento automatico, o final da coluna devera vir preenchido na ultima posicao do array aColunas

If   lAlignAuto
	aSetCols := aClone(aColunas)
	If nDItPrtFor == 2
		nMaxCalc :=  aPaperSize[nTpPaper][1]
	Else
		nMaxCalc :=  aPaperSize[nTpPaper][2]
	Endif
	nMinAtu := aColunas[1]
	nMaxAtu	:= aColunas[Len(aColunas)]
	nDiff 	:= (nMaxCalc-(nMaxAtu-nMinAtu))/(nMaxAtu-nMinAtu)
	aSetCols[1]:= 20
	For nx := 1 to len(aColunas)-1
		If nChange<>Nil .And. nChange > 0
			If nx > nChange
				aSetCols[nx] := aColunas[nx]+(nMaxCalc-(nMaxAtu-nMinAtu))
			EndIf
		Else
			aSetCols[nx] := aColunas[nx]+(nDiff*(aColunas[nx+1]-aColunas[nx]))+20
		EndIf
	Next
	aSetCols[Len(aColunas)] := nMaxCalc
Else
	aSetCols	:= aClone(aColunas)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³DItPrtPos³ Autor ³ Edson Maricate         ³ Data ³07-01-2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna a posicao da coluna no relatorio                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³DItPrtPos                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function DItPrtPos(nCol)

Return aSetCols[nCol]

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³DItPrtTam³ Autor ³ Edson Maricate         ³ Data ³07-01-2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna o tamanho da coluna no relatorio                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³DItPrtTam                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function DItPrtTam(nCol)
Local nRet

	If nCol == Len(aSetCols)
		If nDItPrtFor == 2
			nRet := aPaperSize[nTpPaper][1]-aSetCols[nCol]
		Else
			nRet := aPaperSize[nTpPaper][2]-aSetCols[nCol]
		Endif
	Else
		nRet := aSetCols[nCol+1]-aSetCols[nCol]+1
	EndIf
Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³DItPrtEnd³ Autor ³ Edson Maricate         ³ Data ³08-01-2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de finalizacao da impressao grafica.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function DItPrtEnd(oPrint)
Local nX := 0
Local aSaveParam := {}
PRIVATE aReturn
If nClassic == 2
	M_PAG	:= nSavPag
	aReturn := aSavRet
	aImprime := aSort( aImprime,,, { | x , y | Str(x[1],5)+Str(x[2],5) < Str(y[1],5)+Str(y[2],5) } )
	For nx := 1 to Len(aImprime)
		LI := aImprime[nx,1]
		@ LI,aImprime[nx,2] PSAY aImprime[nx,3]
	Next
	M_PAG := nSavPag
	aImprime := {}
	wnrel := SavwnRel
	LI++
	IF li != 80
		roda(LI,"",Tamanho)
	EndIF

	If aReturn[5] = 1
		Set Printer TO
		dbCommitAll()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

Else
	If nPagAtu > 0 .And. lRodape
		If nDItPrtFor == 2
			PrintLine(aPaperSize[nTpPaper][2]-40, 20, aPaperSize[nTpPaper][2]-40, aPaperSize[nTpPaper][1] )
			PrintLine(aPaperSize[nTpPaper][2]-39, 20, aPaperSize[nTpPaper][2]-39, aPaperSize[nTpPaper][1] )
			PrintSay(aPaperSize[nTpPaper][2]-40,30,DTOC(MsDate())+" "+Time(),{3,1} )	// "Hora :" //"Hora : "
			PrintSay(aPaperSize[nTpPaper][2]-40,aPaperSize[nTpPaper][1]-200,STR0006+Transform(nPagAtu,"@e 99999"),{3,1} )	// "Pag." //"Pag. "
		Else
			PrintLine(aPaperSize[nTpPaper][1]-40, 20, aPaperSize[nTpPaper][1]-40, aPaperSize[nTpPaper][2] )
			PrintLine(aPaperSize[nTpPaper][1]-39, 20, aPaperSize[nTpPaper][1]-39, aPaperSize[nTpPaper][2] )
			PrintSay(aPaperSize[nTpPaper][1]-40,30,DTOC(MsDate())+" "+Time(),{3,1} )	// "Hora :" //"Hora : "
			PrintSay(aPaperSize[nTpPaper][1]-40,aPaperSize[nTpPaper][2]-200,STR0006+Transform(nPagAtu,"@e 99999"),{3,1} )	// "Pag." //"Pag. "
		Endif
	EndIf
	PrintEndPage()
	MakeDir(SuperGetMV('MV_RELT'))

	If Len(aSave)>2 .And. !Empty(cNameSave)
		aSaveParam := {}
		If !Empty(cPrtPerg)
			dbSelecTArea("SX1")
			dbSetOrder(1)
			dbSeek(cPrtPerg)
			nx := 1
			While !Eof() .And. X1_GRUPO == cPrtPerg
				If Type('mv_par'+StrZero(nx,2)) <> "U"
					aAdd(aSaveParam,{X1PERGUNT(),ToXlsFormat(&('mv_par'+StrZero(nx,2)))})
				EndIf
				nx++
				dbSkip()
			End
		EndIf
		aSave[1,3] := {aPapel[nTpPaper],If(nDItPrtFor==2,STR0015,STR0014),DTOC(MsDate())+" "+Time(),cUserName,AllTrim(SM0->M0_NOME)+" / "+AllTrim(SM0->M0_FILIAL),aSaveParam,FunName() }
		If !(".PGS"$cNameSave)
			cNameSave := AllTrim(cNameSave)+".PGS"
		EndIf
		If !("\"$cNameSave)
			cNameSave := GetMV("MV_RELT")+AllTrim(cNameSave)
		EndIf
		__VSave(aSave,cNameSave)
	EndIf

	If lDItPrtPrev
		oPrint:Preview()
	Else
		For nX := 1 to nDItPrtCop
			oPrint:Print()
		Next
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³DItPrtLim³ Autor ³ Edson Maricate         ³ Data ³08-01-2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de finalizacao da impressao grafica.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function DItPrtLim(nLimite)
Local lRet := .F.

If nClassic == 2
	If Tamanho == "G"
		If LI==350 .Or.(LI > 58)
			lRet := .T.
		EndIf
	Else
		If LI==350 .Or.(LI > 58)
			lRet := .T.
		EndIf
	EndIf
Else
	If nDItPrtFor == 2
		If nLimite > aPaperSize[nTpPaper][2]-190-38 //2200
			lRet := .T.
		EndIf
	Else
		If nLimite > aPaperSize[nTpPaper][1]-190-38 //3000
			lRet := .T.
		EndIf
	Endif
EndIf
Return lRet
/*
User Function DItPrtLine(nPosY, nPosXIni, nPosXFim)
DEFAULT nPosXIni := 190
DEFAULT nPosXFim := If(nDItPrtFor == 2, aPaperSize[nTpPaper][1], aPaperSize[nTpPaper][2])

If nClassic == 2
	If Tamanho == "G"
		aAdd(aImprime,{LI,01,__PrtThinLine()})
	Else
		aAdd(aImprime,{LI,01,__PrtThinLine()})
	EndIf
	LI++
Else
	If nDItPrtFor == 2
		PrintLine(nPosXIni, nPosY, nPosXIni, nPosXFim )
	Else
		PrintLine(nPosXIni, nPosY, nPosXIni, nPosXFim )
	EndIf
EndIf

Return
*/
Static Function PrtFilter()
Local nx
Local aRet	:= {}

If ParamBox( aCondFil ,STR0008,@aRet)   //"Configurar Filtros"
	For nx := 1 to Len(aRet)
		aCondFil[nx][4] := aRet[nx]
	Next
EndIf

Return

User Function PrtGetFilter(nFilter)

Return aCondFil[nFilter][4]


User Function DItPrtDlg(oPrint,nOption,lLandScape,cPerg,cDescri,lPreview,nCopias,nFontes)
Local lRet := .F.
Local cPapel
Local oDlg,Formato,Titulo,oSayTit,oFormato,oBmpPor,oSBtn7,oSBtn8,oSBtn9,oGrp10,oBmpLan,oBmp14,oChk15,oGrp15,oGet16,oBmp16,oDetail,oConfig,oSBtn19,oSBtn20
oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := STR0009 //"Gerenciador de Impressao"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 491
oDlg:nHeight := 380
oDlg:lShowHint := .F.
oDlg:lCentered := .T.
oDlg:bInit := {|| (If(nOption==1,(oBmpPor:Show(),oBmpLan:Hide()),(oBmpPor:Hide(),oBmpLan:Show()))),(oDetail:cCaption := cDescri),(oConfig:cTooltip:= STR0010)  } //"Configuracao da  Impressora"



Formato := TGROUP():Create(oDlg)
Formato:cName := "Formato"
Formato:cCaption := STR0011 //"Formato"
Formato:nLeft := 209
Formato:nTop := 12
Formato:nWidth := 185
Formato:nHeight := 224
Formato:lShowHint := .F.
Formato:lReadOnly := .F.
Formato:Align := 0
Formato:lVisibleControl := .T.

Titulo := TGROUP():Create(oDlg)
Titulo:cName := "Titulo"
Titulo:cCaption := STR0012 //"Titulo"
Titulo:nLeft := 22
Titulo:nTop := 88
Titulo:nWidth := 180
Titulo:nHeight := 62
Titulo:lShowHint := .F.
Titulo:lReadOnly := .F.
Titulo:Align := 0
Titulo:lVisibleControl := .T.

@ 20,17 COMBOBOX oPapel VAR cPapel ITEMS aPapel SIZE 52,120 VALID U_SetPapel(oPapel:nAt) OF oDlg PIXEL
oPapel:nAt := nTpPaper

oSayTit := TGET():Create(oDlg)
oSayTit:cName := "oSayTit"
oSayTit:nLeft := 35
oSayTit:nTop := 109
oSayTit:nWidth := 155
oSayTit:nHeight := 26
oSayTit:lShowHint := .F.
oSayTit:lReadOnly := .F.
oSayTit:Align := 0
oSayTit:cVariable := "DItPrtTit "
oSayTit:bSetGet := {|u| If(Pcount()>0,DItPrtTit :=u,DItPrtTit ) }
oSayTit:lVisibleControl := .T.
oSayTit:lPassword := .F.
oSayTit:lHasButton := .F.
oSayTit:bWhen := {|| !PgrInUse() }

oFormato := TRADMENU():Create(oDlg)
oFormato:cName := "oFormato"
oFormato:cCaption := STR0013 //"Teste"
oFormato:nLeft := 221
oFormato:nTop := 34
oFormato:nWidth := 161
oFormato:nHeight := 43
oFormato:lShowHint := .F.
oFormato:lReadOnly := .F.
oFormato:Align := 0
oFormato:cVariable := "nOption"
oFormato:bSetGet := {|u| If(PCount()>0,nOption:=u,nOption) }
oFormato:lVisibleControl := .T.
oFormato:aItems := { STR0014,STR0015} //"Retrato"###"Paisagem"
oFormato:nOption := nOption
oFormato:bWhen := {|| !lLandScape }
oFormato:bChange := {|| If(oFormato:nOption==1,(oBmpPor:Show(),oBmpLan:Hide(),oPrint:SetPortrait()), (oBmpPor:Hide(),oBmpLan:Show(),oPrint:SetLandscape())) }

oBmpPor := TBITMAP():Create(oDlg)
oBmpPor:cName := "oBmpPor"
oBmpPor:nLeft := 254
oBmpPor:nTop := 88
oBmpPor:nWidth := 113
oBmpPor:nHeight := 131
oBmpPor:lShowHint := .F.
oBmpPor:lReadOnly := .F.
oBmpPor:Align := 0
oBmpPor:lVisibleControl := .T.
oBmpPor:cResName := "PcoPrtPor"
oBmpPor:lStretch := .F.
oBmpPor:lAutoSize := .F.

oSBtn7 := SBUTTON():Create(oDlg)
oSBtn7:cName := "oSBtn7"
oSBtn7:cToolTip := STR0016 //"Confirma Impressao"
oSBtn7:nLeft := 411
oSBtn7:nTop := 17
oSBtn7:nWidth := 59
oSBtn7:nHeight := 22
oSBtn7:lShowHint := .F.
oSBtn7:lReadOnly := .F.
oSBtn7:Align := 0
oSBtn7:lVisibleControl := .T.
oSBtn7:nType := 1
oSBtn7:bLClicked := {|| lRet:=.T.,oDlg:End() }

oSBtn8 := SBUTTON():Create(oDlg)
oSBtn8:cName := "oSBtn8"
oSBtn8:cToolTip := STR0017 //"Cancelar Impressao"
oSBtn8:nLeft := 411
oSBtn8:nTop := 48
oSBtn8:nWidth := 59
oSBtn8:nHeight := 22
oSBtn8:lShowHint := .F.
oSBtn8:lReadOnly := .F.
oSBtn8:Align := 0
oSBtn8:lVisibleControl := .T.
oSBtn8:nType := 2
oSBtn8:bLClicked := {|| oDlg:End() }

oSBtn9 := SBUTTON():Create(oDlg)
oSBtn9:cName := "oSBtn9"
oSBtn9:cToolTip := STR0018 //"Parametros do Relatorio"
oSBtn9:nLeft := 411
oSBtn9:nTop := 78
oSBtn9:nWidth := 59
oSBtn9:nHeight := 22
oSBtn9:lShowHint := .F.
oSBtn9:lReadOnly := .F.
oSBtn9:Align := 0
oSBtn9:lVisibleControl := .T.
oSBtn9:nType := 5
oSBtn9:bWhen := {|| !Empty(cPerg) }
oSBtn9:bLClicked := {|| Pergunte(cPerg) }

oGrp10 := TGROUP():Create(oDlg)
oGrp10:cName := "oGrp10"
oGrp10:cCaption := STR0019 //"Descricao"
oGrp10:nLeft := 16
oGrp10:nTop := 242
oGrp10:nWidth := 381
oGrp10:nHeight := 84
oGrp10:lShowHint := .F.
oGrp10:lReadOnly := .F.
oGrp10:Align := 0
oGrp10:lVisibleControl := .T.

oBmpLan := TBITMAP():Create(oDlg)
oBmpLan:cName := "oBmpLan"
oBmpLan:nLeft := 246
oBmpLan:nTop := 87
oBmpLan:nWidth := 116
oBmpLan:nHeight := 113
oBmpLan:lShowHint := .F.
oBmpLan:lReadOnly := .F.
oBmpLan:Align := 0
oBmpLan:lVisibleControl := .F.
oBmpLan:cResName := "PcoPrtLan"
oBmpLan:lStretch := .F.
oBmpLan:lAutoSize := .F.

oBmp14 := TBITMAP():Create(oDlg)
oBmp14:cName := "oBmp14"
oBmp14:cCaption := "oBmp14"
oBmp14:nLeft := 22
oBmp14:nTop := 17
oBmp14:nWidth := 179
oBmp14:nHeight := 66
oBmp14:lShowHint := .F.
oBmp14:lReadOnly := .F.
oBmp14:Align := 0
oBmp14:lVisibleControl := .T.
oBmp14:cResName := "PcoIMPRES"
oBmp14:lStretch := .F.
oBmp14:lAutoSize := .F.

oChk15 := TCHECKBOX():Create(oDlg)
oChk15:cName := "oChk15"
oChk15:cCaption := "Preview"
oChk15:nLeft := 22
oChk15:nTop := 217
oChk15:nWidth := 176
oChk15:nHeight := 20
oChk15:lShowHint := .F.
oChk15:lReadOnly := .F.
oChk15:Align := 0
oChk15:cVariable := "lPreview"
oChk15:bSetGet := {|u| If(PCount()>0,lPreview:=u,lPreview) }
oChk15:lVisibleControl := .T.

oGrp15 := TGROUP():Create(oDlg)
oGrp15:cName := "oGrp15"
oGrp15:cCaption := "Copias "
oGrp15:nLeft := 22
oGrp15:nTop := 154
oGrp15:nWidth := 179
oGrp15:nHeight := 59
oGrp15:lShowHint := .F.
oGrp15:lReadOnly := .F.
oGrp15:Align := 0
oGrp15:lVisibleControl := .T.

oGet16 := TGET():Create(oDlg)
oGet16:cName := "oGet16"
oGet16:nLeft := 36
oGet16:nTop := 176
oGet16:nWidth := 154
oGet16:nHeight := 25
oGet16:lShowHint := .F.
oGet16:lReadOnly := .F.
oGet16:Align := 0
oGet16:cVariable := "nCopias"
oGet16:bSetGet := {|u| If(PCount()>0,nCopias:=u,nCopias) }
oGet16:lVisibleControl := .T.
oGet16:lPassword := .F.
oGet16:Picture := "999"
oGet16:lHasButton := .F.
oGet16:bValid := {|| nCopias > 0 }

oBmp16 := TBITMAP():Create(oDlg)
oBmp16:cName := "oBmp16"
oBmp16:cCaption := "oBmp16"
oBmp16:nLeft := 16
oBmp16:nTop := 325
oBmp16:nWidth := 380
oBmp16:nHeight := 22
oBmp16:lShowHint := .F.
oBmp16:lReadOnly := .F.
oBmp16:Align := 0
oBmp16:lVisibleControl := .T.
oBmp16:cResName := "PcoIMPR2"
oBmp16:lStretch := .F.
oBmp16:lAutoSize := .F.

oDetail := TSAY():Create(oDlg)
oDetail:cName := "oDetail"
oDetail:nLeft := 25
oDetail:nTop := 258
oDetail:nWidth := 365
oDetail:nHeight := 62
oDetail:lShowHint := .F.
oDetail:lReadOnly := .F.
oDetail:Align := 0
oDetail:cVariable := "cDescri"
oDetail:bSetGet := {|u| If(PCount()>0,cDescri:=u,cDescri) }
oDetail:lVisibleControl := .T.
oDetail:lWordWrap := .F.
oDetail:lTransparent := .F.

oConfig := SBUTTON():Create(oDlg)
oConfig:cName := "oConfig"
oConfig:nLeft := 411
oConfig:nTop := 108
oConfig:nWidth := 59
oConfig:nHeight := 22
oConfig:lShowHint := .F.
oConfig:lReadOnly := .F.
oConfig:Align := 0
oConfig:lVisibleControl := .T.
oConfig:nType := 6
oConfig:bLClicked := {|| oPrint:Setup() }

oSBtn19 := SBUTTON():Create(oDlg)
oSBtn19:cName := "oSBtn19"
oSBtn19:cCaption := "oSBtn19"
oSBtn19:nLeft := 411
oSBtn19:nTop := 138
oSBtn19:nWidth := 59
oSBtn19:nHeight := 22
oSBtn19:lShowHint := .F.
oSBtn19:lReadOnly := .F.
oSBtn19:Align := 0
oSBtn19:lVisibleControl := .T.
oSBtn19:nType := 17
oSBtn19:bWhen := {|| !Empty(aCondFil) }
oSBtn19:bLClicked := {|| PrtFilter() }

oSBtn20 := SBUTTON():Create(oDlg)
oSBtn20:cName := "oSBtn20"
oSBtn20:cCaption := "oSBtn20"
oSBtn20:nLeft := 411
oSBtn20:nTop := 170
oSBtn20:nWidth := 59
oSBtn20:nHeight := 22
oSBtn20:lShowHint := .F.
oSBtn20:lReadOnly := .F.
oSBtn20:Align := 0
oSBtn20:lVisibleControl := .T.
oSBtn20:nType := 11
oSBtn20:bWhen := {|| PgrInUse() }
oSBtn20:bLClicked := {|| (PgrEdit(@DItPrtTit,oFormato:nOption,@nFontes),oFormato:Refresh(),oSayTit:Refresh()) }


oSBtn20 := SBUTTON():Create(oDlg)
oSBtn20:cName := "oSBtn20"
oSBtn20:cCaption := "oSBtn20"
oSBtn20:nLeft := 411
oSBtn20:nTop := 205
oSBtn20:nWidth := 59
oSBtn20:nHeight := 22
oSBtn20:lShowHint := .F.
oSBtn20:lReadOnly := .F.
oSBtn20:Align := 0
oSBtn20:lVisibleControl := .T.
oSBtn20:nType := 14
oSBtn20:bWhen := {|| PgrInUse() }
oSBtn20:bLClicked := {|| (PgrLoad(@DItPrtTit,@oSayTit,@oFormato,oDLg),PgrLoadRfs(@DItPrtTit,@oSayTit,@oFormato)) }


oSBtn20 := SBUTTON():Create(oDlg)
oSBtn20:cName := "oSBtn20"
oSBtn20:cCaption := "oSBtn20"
oSBtn20:nLeft := 411
oSBtn20:nTop := 240
oSBtn20:nWidth := 59
oSBtn20:nHeight := 22
oSBtn20:lShowHint := .F.
oSBtn20:lReadOnly := .F.
oSBtn20:Align := 0
oSBtn20:lVisibleControl := .T.
oSBtn20:nType := 13
oSBtn20:bLClicked := {|| SaveRel() }



oDlg:Activate()

Return lRet





Static Function Dlg(oPrint,nOption,lLandScape,cPerg,cDescri,lPreview,nCopias)
Local lRet := .F.
/*
A tag abaixo define a criação e ativação do novo diálogo. Você pode colocar esta tag
onde quer que deseje em seu código fonte. A linha exata onde esta tag se encontra, definirá
quando o diálogo será exibido ao usuário.
Nota: Todos os objetos definidos no diálogo serão declarados como Local no escopo da
função onde a tag se encontra no código fonte.
*/

//$BEGINDIALOGDEF_oDlg_1
//$ENDDIALOGDEF_oDlg_1
Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DItXIMP   ºAutor  ³Carlos A. Gomes Jr. º Data ³  16/02/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de atualização do Titulo do Relatorio               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SetPrtTit(cNewTitulo)

Default cNewTitulo := DItPrtTit

DItPrtTit := cNewTitulo

Return


User Function SetPapel(nPapel)

nTpPaper	:= nPapel

Return


Static Function PrintNew(cTitulo)

aAdd(aSave,{"NEW",cTitulo})

Return TMSPrinter():New( cTitulo )


Static Function PrintLandScape()

aAdd(aSave,{"SETLAND"})

Return oPrint:SetLandscape()


Static Function PrintPortrait()

aAdd(aSave,{"SETPORT"})

Return oPrint:SetPortrait()

Static Function PrintBox(nPosY,nPosX,nAltura,nTamanho)

aAdd(aSave,{"PRINTBOX",nPosY,nPosX,nAltura,nTamanho})

Return oPrint:Box(nPosY,nPosX,nAltura,nTamanho)


Static Function PrintBmpBox(nPosY ,nPosX ,nColor,nTamanho,nAltura)
Local cBmp

cBmp := OnePixBmp(ConvRGB(nColor),,"PMSBMP")

aAdd(aSave,{"PRINTBMPBOX",nPosY ,nPosX ,nColor,nTamanho,nAltura})

Return oPrint:SayBitmap( nPosY ,nPosX ,cBmp,nTamanho,nAltura)

Static Function PrintSay(nPosY,nPosX,cSay,aPrintFonte)

aAdd(aSave,{"PRINTSAY",nPosY,nPosX,cSay,aPrintFonte})

Return oPrint:Say(nPosY,nPosX,cSay,aFontes[aPrintFonte[1],aPrintFonte[2]] )


Static Function PrintCBar( nPosY ,nPosX ,cBar,nTamanho,nAltura)

aAdd(aSave,{"PRINTCBAR25",oPrint:Pix2Cmtr(nPosY) ,nPosX ,cBar,nTamanho,nAltura})

//MSBAR(cTypeBar,nRow,nCol,cCode,oPrint,lCheck,Color,lHorz,nWidth,nHeigth,lBanner,cFont,cMode,lPrint,nPFWidth,nPFHeigth)
//MSBAR("INT25",23.5,1,cBar,oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
MSBAR("INT25",oPrint:Pix2Cmtr(nPosY) ,nPosX/100,cBar,@oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)

Return



Static Function PrintImage( nPosY ,nPosX ,cImage,nTamanho,nAltura)

aAdd(aSave,{"PRINTIMAGE",nPosY ,nPosX ,LoadBmp(cImage),nTamanho,nAltura,cImage})

Return oPrint:SayBitmap( nPosY ,nPosX ,cImage,nTamanho,nAltura)

Static Function PrintLine(nPosY,nPosX,nAltura,nTamanho)

aAdd(aSave,{"PRINTLINE",nPosY,nPosX,nAltura,nTamanho})

Return oPrint:Line(nPosY,nPosX,nAltura,nTamanho)


Static Function PrintEndPage()

aAdd(aSave,{"ENDPAGE"})

Return oPrint:EndPage()

Static Function PrintStartPage()

aAdd(aSave,{"STARTPAGE"})

Return oPrint:StartPage()


User Function DItSpool()

Local aLoad	:= {}
Local cFile := SPACE(250)
Local oDlg
Local aRet	:= {}
Private cCadastro := STR0026 //"Spool de Relatórios Gráficos"

MakeDir(SuperGetMV('MV_RELT'))
cDirIni := "SERVIDOR"+SuperGetMV('MV_RELT')



DEFINE MSDIALOG oDlg FROM 51 ,40  TO 465,443 TITLE 'spool' Of oMainWnd PIXEL

	oPanel := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,1245,23,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	@ 4, 12 BITMAP RESNAME "PcoSPOOL" oF oPanel SIZE 300,300  WHEN .F. PIXEL NOBORDER

   @ 41 ,9   SAY STR0027 Of oPanel PIXEL SIZE 40 ,9   //'Arquivo'

   @ 40 ,38  MSGET cFile Valid AtuFile(@oPanel2,cFile,aLoad) OF oPanel PIXEL HASBUTTON SIZE 115,9

   @ 40 ,153 BUTTON STR0028 SIZE 35 ,11  FONT oPanel:oFont ACTION (cFile := cGetFile(STR0029, STR0030,0,"SERVIDOR"+GetMv("MV_RELT"),.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY),AtuFile(@oPanel2,cFile,aLoad)  ) OF oPanel PIXEL  //'Procurar' #"Arquivos .PGS |*.PGS"#"Selecionar Arquivo"

	oPanel2 := TPanel():New(62,12,'',oDlg, oDlg:oFont, .T., .T.,, ,180,125,.T.,.T. )


   DEFINE SBUTTON FROM 193,128 TYPE 6   ACTION (If(File(cFile),RptStatus( {|| AuxLoad(aLoad) }),Nil)) ENABLE OF oPanel
   DEFINE SBUTTON FROM 193,160 TYPE 2   ACTION oDLg:End() ENABLE OF oPanel

	oDlg:lMaximized := .F.
ACTIVATE MSDIALOG oDlg


Return

Static Function AtuFile(oPanel,cFile,aLoad)

Local aInfo
Local nx

aLoad := {}

MsFreeObj(oPanel,.T.)

If !(".PGS"$UPPER(cFile)) .And. !Empty(cFile)
		cFile := AllTrim(cFile)+".PGS"
	EndIf
	If !("\"$cFile)
		cFile := SuperGetMV('MV_RELT')+cFile
	EndIf
	If File(cFile)
		aLoad		:= __VRestore(cFile)
		If aLoad[1,1] == "PGREPORT1.1"
			aInfo := {{STR0027,AllTrim(cFile)},{STR0031,aLoad[1,3,1]},{STR0032,aLoad[1,3,2]},{STR0033,aLoad[1,3,3]},{STR0034,aLoad[1,3,4]},{STR0035,aLoad[1,3,5]},{STR0036,aLoad[1,3,7]},{STR0037,""}}
			For nx := 1 to Len(aLoad[1,3,6])
				aAdd(aInfo,{aLoad[1,3,6,nx,1],aLoad[1,3,6,nx,2]})
			Next nx
			PmsDispBox(aInfo,2,"",{65,100},,1,RGB(230,230,255),RGB(240,240,240),oPanel,1,1,.T.,"")
		Else
			AViso(STR0038,STR0039,{STR0040},2) // "Arquivo incompativel!"#"O arquivo selecionado não é compativel com este visualizador. Verifique o arquivo selecionado e a sua integridade."
		EndIf
	EndIf


Return


Static Function SaveRel()
Local aRet := {}
Private cCadastro := STR0041 // "Salvar relatorio em disco"

If Empty(cNameSave)
	Do Case
		Case SuperGetMv("MV_PGRSAVE",.F.,"1") == "1"
			cNameSave := AllTrim(DItPrtTit)
		Case SuperGetMv("MV_PGRSAVE",.F.,"1") == "2"
			cNameSave := AllTrim(DItPrtTit)+" "+Str(Day(MsDate()),2)+"_"+Str(Month(MsDate()),2)+"_"+Str(Year(MsDate()),4)+" "+Substr(Time(),1,2)+"h"+Substr(Time(),4,2)+"m "+AllTrim(cPrtPerg)
		Case SuperGetMv("MV_PGRSAVE",.F.,"1") == "3"
			cNameSave := RetUsrName()+" "+AllTrim(DItPrtTit)+" "+Str(Day(MsDate()),2)+"_"+Str(Month(MsDate()),2)+"_"+Str(Year(MsDate()),4)+" "+Substr(Time(),1,2)+"h"+Substr(Time(),4,2)+"m "+AllTrim(cPrtPerg)
	EndCase
EndIf

If ParamBox({	{6,STR0042,Padr(cNameSave,220),"","","", 95 ,.T.,STR0029,""} },STR0030,@aRet,,,,,,,,.F.) //"Salvar Como"
	cNameSave := aRet[1]
EndIf

Return


Static Function LoadBmp(cBmp,lArray)

Local nRead	:= 0
Local cRet	:= ''
Local cLoad	:= ''
DEFAULT lArray := .F.

nBmp := FOpen(cBmp)
If nBmp != -1
	If lArray // Quebra em blocos ( array )
		cRet := {}
		nMax := fSeek(nBmp,0,2)
		While nRead < nMax
			fSeek(nBmp,0,nRead)
			fRead(nBmp,@cLoad,1024)
			aAdd(cRet,cLoad)
			nRead+= 1024
		End
	Else
		nMax := fSeek(nBmp,0,2)
		fSeek(nBmp,0,0)
		FRead(nBmp,@cRet,nMax)
	EndIf

	fClose(nBmp)
EndIf
Return cRet


Static Function AuxLoad(aLoad)
Local cBmp
Local nx
Local aFilesErase	:= {}


SetRegua(Len(aLoad))
If !Empty(aLoad) .And. aLoad[1,1] == "PGREPORT1.1"
	If aLoad[1,2] == 1
		aAdd(aFontes,{TFont():New("Courier New",03,06,,.T.,,,,.T.,.F.),16})
		aAdd(aFontes,{TFont():New("Courier New",06,08,,.T.,,,,.T.,.F.),18})
		aAdd(aFontes,{TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.),22})
		aAdd(aFontes,{TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.),22})
		aAdd(aFontes,{TFont():New("Courier New",15,15,,.T.,,,,.T.,.F.),25})
		aAdd(aFontes,{TFont():New("Courier New",20,20,,.T.,,,,.T.,.F.),28})

		aAdd(aFontes,{TFont():New("Courier New",03,06,,.F.,,,,.T.,.F.),16})
		aAdd(aFontes,{TFont():New("Courier New",06,08,,.F.,,,,.T.,.F.),18})

	Else
		aAdd(aFontes,{TFont():New("Arial",03,06,,.T.,,,,.T.,.F.),16})
		aAdd(aFontes,{TFont():New("Arial",06,08,,.T.,,,,.T.,.F.),18})
		aAdd(aFontes,{TFont():New("Arial",10,10,,.F.,,,,.T.,.F.),22})
		aAdd(aFontes,{TFont():New("Arial",10,10,,.T.,,,,.T.,.F.),22})
		aAdd(aFontes,{TFont():New("Arial",15,15,,.T.,,,,.T.,.F.),25})
		aAdd(aFontes,{TFont():New("Arial",20,20,,.T.,,,,.T.,.F.),28})

		aAdd(aFontes,{TFont():New("Arial",03,06,,.F.,,,,.T.,.F.),16})
		aAdd(aFontes,{TFont():New("Arial",06,08,,.F.,,,,.T.,.F.),18})

	EndIf
	IncRegua()

	For nx := 2 to Len(aLoad)
		IncRegua()
		Do Case
			Case aLoad[nx,1] == "NEW"
				oPrint := TMSPrinter():New( aLoad[nx,2] )
			Case aLoad[nx,1] == "SETLAND"
				oPrint:SetLandscape()
			Case aLoad[nx,1] == "SETPORT"
				oPrint:SetPortrait()
			Case aLoad[nx,1] == "PRINTBOX"
				oPrint:Box(aLoad[nx,2],aLoad[nx,3],aLoad[nx,4],aLoad[nx,5])
			Case aLoad[nx,1] == 	"PRINTBMPBOX"
				cBmp := OnePixBmp(ConvRGB(aLoad[nx,4]),,"PMSBMP")
				oPrint:SayBitmap( aLoad[nx,2] ,aLoad[nx,3] ,cBmp,aLoad[nx,5],aLoad[nx,6])
			Case aLoad[nx,1] == 	"PRINTSAY"
				oPrint:Say(aLoad[nx,2],aLoad[nx,3],aLoad[nx,4],aFontes[aLoad[nx,5,1],aLoad[nx,5,2]] )
			Case aLoad[nx,1] == 	"PRINTCBAR"
				MSBAR("INT25",aLoad[nx,2],aLoad[nx,3],aLoad[nx,4],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
			Case aLoad[nx,1] == 	"PRINTIMAGE"
				cBmp := aLoad[nx,4]
				cFileBmp := CriaTrab(,.F.) // aLoad[nx,7]
				nHandBmp := MSfCreate(cFileBmp)
				fWrite(nHandBmp,cBmp,Len(cBmp))
				fClose(nHandBmp)
				oPrint:SayBitmap( aLoad[nx,2] ,aLoad[nx,3] ,cFileBmp,aLoad[nx,5],aLoad[nx,6])
				aAdd(aFilesErase,cFileBmp)
			Case aLoad[nx,1] == 	"PRINTLINE"
				oPrint:Line(aLoad[nx,2],aLoad[nx,3],aLoad[nx,4],aLoad[nx,5])
			Case aLoad[nx,1] == 	"ENDPAGE"
				oPrint:EndPage()
			Case aLoad[nx,1] == 	"STARTPAGE"
				oPrint:StartPage()
		EndCase
	Next nx
	oPrint:Preview()

	For nx := 1 to Len(aFilesErase)
		fErase(aFilesErase[nx])
	Next
EndIf

Return


Static Function ImpSX1()
Local	lImp	:=	.F.
Local cAlias	:=	''
Local aBkDItls	:=	aClone(aSetCols)
Local nLin		:=	150
Local cPicture
Local nMaxCalc
Local cFileLogo  := "LGRL"+SM0->M0_CODIGO+cFilAnt+".BMP"

If !File( cFileLogo )
	cFileLogo := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
Endif

If GetMv("MV_IMPSX1") == "S" .and. Substr(cAcesso,101,1) == "S"
	cAlias := Alias()
	DbSelectArea("SX1")
	DbSeek(cPrtPerg)
	If nDItPrtFor == 2
		nMaxCalc :=  aPaperSize[nTpPaper][1]
	Else
		nMaxCalc :=  aPaperSize[nTpPaper][2]
	Endif
	// Inicio cabecalho
	PrintStartPage()
	PrintImage(30,30, cFileLogo,474,117)
	If nDItPrtFor == 2
		PrintSay(100,(aPaperSize[nTpPaper][1]/2)-(U_DItPrtSize(Alltrim(DItPrtTit),5)/2),AllTrim('Parametros - '+DItPrtTit),{5,1})
	Else
		PrintSay(100,(aPaperSize[nTpPaper][2]/2)-(U_DItPrtSize(Alltrim(DItPrtTit),5)/2),AllTrim('Parametros - '+DItPrtTit),{5,1})
	EndIf
	PrintSay(146,30,QA_CHKFIL(cFilAnt,,.T.),{3,1} )
	If nDItPrtFor == 2
		PrintSay(146,aPaperSize[nTpPaper][1]-425,STR0007+DTOC(dDataBase),{3,1}) //"Data Base : "
		PrintLine(190, 20, 190, aPaperSize[nTpPaper][1] )
		PrintLine(191, 20, 191, aPaperSize[nTpPaper][1] )
	Else
		PrintSay(146,aPaperSize[nTpPaper][2]-425,STR0007+DTOC(dDataBase),{3,1}) //"Data Base : "
		PrintLine(190, 20, 190, aPaperSize[nTpPaper][2] )
		PrintLine(191, 20, 191, aPaperSize[nTpPaper][2] )
	Endif
	// Fim cabecalho

	U_DItPrtCol({10,700,nMaxCalc-40},.F.,2)
	While !EOF() .AND. X1_GRUPO = cPrtPerg
		cVar := "MV_PAR"+StrZero(Val(X1_ORDEM),2,0)
		U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),600, "Pergunta "+ X1_ORDEM + " : "+ AllTrim(X1Pergunt()) ,oPrint,1,4,/*RgbColor*/)
		If X1_GSC == "C"
			xStr:=StrZero(&cVar,2)
			//@ nLin,DItl()+3 PSAY Iif(&(cVar)>0,X1_DEF&xStr,"")
			If ( &(cVar)==1 )
				U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),600, X1Def01() ,oPrint,1,4,/*RgbColor*/)
			ElseIf ( &(cVar)==2 )
				U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),600, X1Def02() ,oPrint,1,4,/*RgbColor*/)
			ElseIf ( &(cVar)==3 )
				U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),600, X1Def03() ,oPrint,1,4,/*RgbColor*/)
			ElseIf ( &(cVar)==4 )
				U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),600, X1Def04() ,oPrint,1,4,/*RgbColor*/)
			ElseIf ( &(cVar)==5 )
				U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),600, X1Def05() ,oPrint,1,4,/*RgbColor*/)
			EndIf
		Else
			uVar := &(cVar)
			If ValType(uVar) == "N"
				cPicture:= "@E "+Replicate("9",X1_TAMANHO-X1_DECIMAL-1)
				If( X1_DECIMAL>0 )
					cPicture+="."+Replicate("9",X1_DECIMAL)
				Else
					cPicture+="9"
				EndIf
				U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),600, TransForm(&(cVar),cPicture) ,oPrint,1,4,/*RgbColor*/)
			ElseIf ValType(uVar) == "D"
				U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),600, Dtoc(&(cVar)) ,oPrint,1,4,/*RgbColor*/)
			ElseIf ValType(uVar) == "L"
				U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),600, Iif(&(cVar),'.T.','.F.') ,oPrint,1,4,/*RgbColor*/)
			Else
				U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),600, &(cVar) ,oPrint,1,4,/*RgbColor*/)
			EndIf
		EndIf
		DbSkip()
		nLin+=70
	End
	DbSelectArea(cAlias)
	lImp	:=	.T.
EndIf
aSetCols 	:=	aClone(aBkDItls)
Return lImp


User Function DItPaperSize()

If nDItPrtFor == 2
	Return {aPaperSize[nTpPaper][1],aPaperSize[nTpPaper][2]}
Else
	Return {aPaperSize[nTpPaper][2],aPaperSize[nTpPaper][1]}
Endif


#include "protheus.ch"
#include "msgraphi.ch"



User Function ToolsMP8()

Local aConfig 	:= {}
Local aTools 	:= { 	"TableExcel 1.0 - Editor de Tabelas via Excel",;
						 	"TableCopy  1.0 - Copia tabelas para o remote",;
							"ArqCopy  1.0 - Copia arquivos para o remote",;
							"Dbf2Array 1.0 - Converte um dbf em arrays",;
							"DialogIde 1.1 - Editor de Telas Protheus",;
							"GerDocPrj 1.0 - Gerador de Documentacao de funcoes",;
							"LoadAtusx 1.2 - Atualizador de dicionarios por pacote" ,;
							"BenchMark 1.0 - Medidor de performance Protheus" 			}

Private cCadastro := "Ferramentas/Utilitarios"

If ParamBox({	{3,"Executar ",0,aTools,150,,.F.},;
					{1,"Linha de Comando",SPACE(30),"","","","",140 ,.F. } },"Tools MP8",aConfig,,,,,, , , .F.)

	If !Empty(aConfig[2])
		&(aConfig[2])
	Else
		cExecute := "U_"+AllTrim(Substr(aTools[aConfig[1]],1,10))+"()"
		&cExecute
	EndIf
EndIf

Return .T.

User Function TableExcel()
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : Permite a exportacao/edicao de tabelas protheus diretamente no Microsoft Excel
<Autor> : AVT
<Data> : 20/06/2006
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Utilitarios do sistema
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Obs> :
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local aRet	:= {}
Local aFilter  := {}
Local cDirDocs  := MsDocPath()
Local aStru2	:= {}
Local cPath		  := AllTrim(GetTempPath())
Local nX        := 0
Local nz
Local xValue    := ""
Local aRead		:= {}
Local cBuffer   := ""
Local oExcelApp := Nil
Local nHandle   := 0
Local cArquivo  := CriaTrab(,.F.)
Local aAuxRet   := {}
Local cTitle    := ""



If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")
	Return
EndIf

If ParamBox( {	{1,"Tabela ","   ","@!","","SX21","",25,.T.} },"Edição de Tabelas via Ms-Excel",@aRet)
	SX2->(dbSetOrder(1))
	SX2->(dbSeek(aRet[1]))
	If ParamBox( {	{7,"Filtro ",aRet[1],""},;
			{1,"Ordem",1,"@E 9","Positivo(mv_par02)","","",15,.T.}  },"Selecione o Filtro",@aFilter)
		dbSelectArea(aRet[1])
		dbSetOrder(aFilter[2])
		If !Empty(aFilter[1])
			dbSetFilter({||&(aFilter[1])},aFilter[1])
		EndIf

		aStru2		:= dbStruct()

		// gera o arquivo em formato .CSV
		cArquivo += "I.CSV"

		nHandle := FCreate(cDirDocs + "\" +cArquivo)

		If nHandle == -1
			MsgStop("A planilha não pode ser exportada.")
			Return
		EndIf

		For nx := 1 To Len(aStru2)
			xValue := FieldName(FieldPos(aStru2[nx][1]))

			cBuffer += XlsFormat(xValue) + ";"
		Next

		cBuffer += XlsFormat("Delete ?")+ ";"
		cBuffer += XlsFormat("ID_RecNo")

		FWrite(nHandle, cBuffer)
		FWrite(nHandle, CRLF)

		dbGotop()
		ProcRegua(LastRec())
		While !Eof()
			IncProc()
			cBuffer := ""

			For nx := 1 To Len(aStru2)
				xValue := FieldGet(FieldPos(aStru2[nx][1]))

				cBuffer += XlsFormat(xValue) + ";"
			Next

			cBuffer += "N" + ";"
			cBuffer += XlsFormat(RecNo())

			FWrite(nHandle, cBuffer)
			FWrite(nHandle, CRLF)

			dbSkip()
		End

		FClose(nHandle)

		// copia o arquivo do servidor para o remote
		CpyS2T(cDirDocs + "\" +cArquivo, cPath, .T.)
		FErase(cDirDocs + "\" +cArquivo)

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cPath + cArquivo)
		oExcelApp:SetVisible(.T.)

		dbSelectArea(aRet[1])
		dbSetOrder(aFilter[2])
		dbClearFilter()

		While Aviso("Assistente de Importação Microsoft Excel","Para realizar a importação da tabela para o sistema utilize a opção Salvar no Microsoft Excel e realize a importação.",{"Importar","Sair"},2) == 1
			If (nHandle := FT_FUse(cPath + cArquivo) )== -1
				Help(" ",1,"NOFILEIMPOR")
			EndIf
			FT_FGOTOP()
			FT_FSKIP()
			cSep := ";"
			While !FT_FEOF()
				PmsIncProc(.T.)
				cLinha := FT_FREADLN()
				AADD(aRead,{})
				nCampo := 1
				While (At(cSep,cLinha) > 0)
					aAdd(aRead[Len(aRead)],StrTran(SubStr(cLinha,1,At(cSep,cLinha)-1),'"',''))
					nCampo ++

					cLinha := StrTran(Substr(cLinha,At(cSep,cLinha)+1,Len(cLinha)-At(cSep,cLinha)),'"','')
				End

				If Len(cLinha) > 0
					aAdd(aRead[Len(aRead)],StrTran(Substr(cLinha,1,Len(cLinha)),'"',''))
				EndIf


				FT_FSKIP()
			End
			FT_FUSE()
			dbSelectArea(aRet[1])
			ProcRegua(len(aRead))
			For nz := 1 To Len(aRead)
				IncProc("Atualizando tabela.Aguarde...")
				If Len(aRead[nz])>=Len(aStru2)+1 .And. UPPER(AllTrim(aRead[nz,Len(aStru2)+1]))=="S"
					dbGoto(Val(aRead[nz,Len(aStru2)+2]))
					RecLock(aRet[1],.F.)
					dbDelete()
					MsUnlock()
				Else
					If Len(aRead[nz])<Len(aStru2)+2 .Or. Empty(aRead[nz,Len(aStru2)+2])
						RecLock(aRet[1],.T.)
						For nx := 1 To Len(aStru2)
							If nx <= Len(aRead[nz])
								xValue := XlsImport(aRead[nz,nx],aStru2[nx,2])

								FieldPut(nx,xValue)
							EndIf

						Next nx
						MsUnlock()
					Else
						dbGoto(Val(aRead[nz,Len(aStru2)+2]))
						RecLock(aRet[1],.F.)
						For nx := 1 To Len(aStru2)
							If nx <= Len(aRead[nz])
								xValue := XlsImport(aRead[nz,nx],aStru2[nx,2])

								FieldPut(nx,xValue)
							EndIf
						Next nx
						MsUnlock()
					EndIf
				EndIf
			Next
		End
	EndIf
EndIf

Return

Static Function XlsImport(xValue,cType)
	Do Case
		Case cType == "C"
			If Empty(xValue)
				xValue := ""
			Else
				If Substr(xValue,1,1) == "&"
					xValue := Substr(xValue,2)
				Else
					xValue := AllTrim(xValue)
				EndIf
			EndIf
		Case cType == "N"
			If Empty(xValue)
				xValue := 0
			Else
				xValue := Val(xValue)
			EndIf
		Case cType == "D"
			If Empty(xValue)
				xValue := CTOD("  /  /  ")
			Else
				xValue := CTOD(xValue)
			EndIf
		Case cType == "U"
			xValue := ""
	EndCase
Return xValue

Static Function XlsFormat(xValue)
	Do Case
		Case ValType(xValue) == "C"
			xValue := "&"+StrTran(xValue, Chr(34), Chr(34) + Chr(34))
			xValue := Chr(34) + AllTrim(xValue) + Chr(34)
		Case ValType(xValue) == "N"
			xValue := Strtran(AllTrim(Str(xValue)),".",",")
		Case ValType(xValue) == "D"
			xValue := DToC(xValue)
		Case ValType(xValue) == "U"
			xValue := ""
	EndCase
Return xValue



User Function TableCopy()
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : Copia tabelas dbf para o remote
<Autor> : AVT
<Data> : 20/06/2006
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Utilitarios do sistema
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Obs> : Copia apenas tabelas DBF ( ADS/Codebase )
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/

Local aRet	:= {}

While .T.
	If ParamBox( {	{1,"Tabela ","   ","@!","","SX21","",25,.T.},;
						{6,"Arquivo",SPACE(50),,,"", 55 ,.T.,"Arquivo .dbf |*.dbf"} },"Copia de tabelas",@aRet)

		SX2->(dbSetOrder(1))
		If SX2->(dbSeek(aRet[1]))
			CPYS2T(AllTrim(SX2->X2_PATH)+AllTrim(SX2->X2_ARQUIVO)+".fpt",aRet[2])
			CPYS2T(AllTrim(SX2->X2_PATH)+AllTrim(SX2->X2_ARQUIVO)+".dbf",aRet[2])
		Endif
	Else
		Exit
	EndIf
End

Return .T.

User Function ArqCopy()
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : Permite efetuar a copia de arquivos do Servidor para o Remote
<Autor> : AVT
<Data> : 20/06/2006
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Utilitarios do sistema
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Obs> :
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local aRet	:= {}


While .T.
	If ParamBox( {	{6,"Arquivo Origem",SPACE(50),,,"", 55 ,.T.,"Todos Arquivos *.* |*.*"},;
						{6,"Diretorio Destino",SPACE(50),,,"", 55 ,.T.,"Todos Arquivos *.* |*.*"} },"Copia de arquivos",@aRet)

		CPYS2T(aRet[1],aRet[2])
	Else
		Exit
	EndIf
End

Return .T.

User Function Dbf2Array()
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : Funcao que permite a geracao de um array com estrutura e dados para gravacao de dados via programa
<Autor> : AVT
<Data> : 20/06/2006
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Utilitarios do sistema
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Obs> :
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local aRet	:= {}
Local cWrite:= ''
Local ny
Local nx

If ParamBox({	    {6,"Arquivo",SPACE(254),,"FILE(mv_par01)","", 55 ,.T.,"Arquivo .DBF |*.DBF"}},"Selecione o arquivo",@aRet)
	dbUseArea(.T.,,aRet[1],"TRB",.F.,.F.)
	cAlias := "TRB"
	dbSelectArea(cAlias)
	dbGotop()
	aStruct := (cAlias)->(dbStruct())
	cWrite += 'aStru := {'
	For nx := 1 to Len(aStruct)
		cWrite += '"'+Alltrim(aStruct[nx,1])+'"'+If(nx<Len(aStruct),',','')
	Next
	cWrite += "}"+CHR(13)+CHR(10)
	cWrite += 'aAdd(aWrite,{'
	While !Eof()
		cWrite += 'aAdd(aWrite,{'
		For ny := 1 to Len(aStruct)
			Do Case
				Case aStruct[ny,2]=="D"
					cInfo := DTOC((cAlias)->(FieldGet(ny)))
					cWrite += '"'+AllTrim(cInfo)+'"'+If(ny<Len(aStruct),',','')
				Case aStruct[ny,2]=="C"
					cInfo := (cAlias)->(FieldGet(ny))
					cWrite += '"'+AllTrim(cInfo)+'"'+If(ny<Len(aStruct),',','')
				Case aStruct[ny,2]=="N"
					cInfo := STR((cAlias)->(FieldGet(ny)))
					cWrite += ''+AllTrim(cInfo)+''+If(ny<Len(aStruct),',','')
			EndCase
		Next
		dbSkip()
		If Eof()
			cWrite += '})'
		Else
			cWrite += '})'+CHR(13)+CHR(10)
		EndIf
	End
EndIf

dbCloseArea()

MemoWrite("\Array.PRW",cWrite)

cTexto := cWrite
DEFINE FONT oFont NAME "Courier New" SIZE 5,12   //6,15
DEFINE MSDIALOG oDlg TITLE "Código ADVPL" From 3,0 to 540,617 PIXEL
@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 300,245 OF oDlg PIXEL
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 253,275 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
DEFINE SBUTTON  FROM 253,245 TYPE 13 ACTION (cFile:=cGetFile("Arquivos .PRT (*.PRT) |*.PRT|",""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."


ACTIVATE MSDIALOG oDlg CENTER



Return


User Function DialogIDE()
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : Ferramenta de edição de janelas em ADVPL - Protheus
<Autor> : AVT
<Data> : 20/06/2006
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Utilitarios do sistema
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Obs> :
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
DIDE(oMainWnd)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ MsMaker()³ Autor ³                   	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Construtor de Janelas Windows.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DIDE(oMainWnd)

Local oDlgW
Local oFontB := TFont():New( "MS Sans Serif", 6, 15 )
Local nUsado 		:= 0
Local bHotArea
Local nCols 		:= 0
Private	aCombo	:= {"Combo 1","Combo 2","Combo 3"},oCombo,cCombo:=""
Private  cGet		:= SPACE(100)
PRIVATE aRotina := {{"PES","AxPesqui", 0 , 2},{"PES","AxPesqui", 0 , 2},{"PES","AxPesqui", 0 , 4},{"PES","AxPesqui", 0 , 4},{"PES","AxPesqui", 0 , 4}}
PRIVATE aHeader	:= {}
PRIVATE aCols 		:= {}
PRIVATE oGetDados,n	:= 1
PRIVATE lOk				:= .F.
PRIVATE cCombo1 := "Normal"
PRIVATE cAliasG	:= "SA3"
PRIVATE cAliasE	:= "SC5"


bHotArea := {||HotAreas(if(lIntegracao,11,10),4,if(lIntegracao,18,17),75,nUsado)}

IniaCols()


DEFINE MSDIALOG oDlgW FROM 100,2   TO 400,110  TITLE "DialogIDE ADVPL 1.1" Of oMainWnd PIXEL
oDlgW:lMaximized := .T.

    @ 2 ,1   TO 40 ,52  LABEL 'Arquivo' OF oDlgW PIXEL
	 @ 43,1   TO 120,52  LABEL 'Objetos' OF oDlgW PIXEL
    @ 10,6   BUTTON 'Novo' SIZE 20,11  FONT oDlgW:oFont ACTION (NewWnd())  OF oDlgW PIXEL
    @ 10,28  BUTTON 'Abrir' SIZE 20,11  FONT oDlgW:oFont ACTION (MkOpe())  OF oDlgW PIXEL
    @ 24,6   BUTTON "Gerar ADVPL" SIZE 42,11  FONT oDlgW:oFont ACTION (Script()) When lOk OF oDlgW PIXEL
    @ 51,5   BUTTON 'Label' SIZE 21,8  FONT oDlgW:oFont ACTION (Label()) When lOk OF oDlgW PIXEL
    @ 51,27  BUTTON 'Say' SIZE 21 ,8   FONT oDlgW:oFont ACTION (MkSay()) When lOk OF oDlgW PIXEL
    @ 61,5   BUTTON 'MsGet' SIZE 21 ,8   FONT oDlgW:oFont ACTION (Mkget())  When lOk OF oDlgW PIXEL
	 @ 61,27  BUTTON 'MsButt' SIZE 21 ,8   FONT oDlgW:oFont ACTION (MkBut()) When lOk OF oDlgW PIXEL
    @ 71,5   BUTTON 'Button' SIZE 21 ,8   FONT oDlgW:oFont ACTION (MkBut1()) When lOk OF oDlgW PIXEL
    @ 71,27  BUTTON 'Combo' SIZE 21 ,8   FONT oDlgW:oFont ACTION (MkCom()) When lOk OF oDlgW PIXEL
    @ 81,5   BUTTON 'GetDad' SIZE 21 ,8   FONT oDlgW:oFont ACTION (MkGetDados()) When lOk OF oDlgW PIXEL
    @ 81,27  BUTTON 'MsMGet' SIZE 21 ,8   FONT oDlgW:oFont ACTION (MkEnch()) When lOk OF oDlgW PIXEL
//    @ 91,5   BUTTON 'Time' SIZE 21 ,8   FONT oDlgW:oFont ACTION (MsgAlert('Aguarde novas versoes'))  When lOk OF oDlgW PIXEL
//    @ 91,27  BUTTON 'BttBar' SIZE 21 ,8   FONT oDlgW:oFont ACTION (MsgAlert('Aguarde novas versoes'))  When lOk OF oDlgW PIXEL
//    @ 101,5  BUTTON 'LstBox' SIZE 21 ,8   FONT oDlgW:oFont ACTION (MsgAlert('Aguarde novas versoes'))  When lOk OF oDlgW PIXEL
    @ 91,5 BUTTON 'Sobre' SIZE 21 ,8   FONT oDlgW:oFont ACTION (Info())  When lOk OF oDlgW PIXEL
    @ 121,1  TO 148,52  LABEL '' OF oDlgW PIXEL
    @ 131,5  BUTTON 'Editar' SIZE 21 ,11  FONT oDlgW:oFont ACTION (EditObjs())   When lOk OF oDlgW PIXEL
    @ 131,27   BUTTON 'Preview' SIZE 21 ,11  FONT oDlgW:oFont ACTION (Preview())  When lOk OF oDlgW PIXEL


ACTIVATE MSDIALOG oDlgW //ON INIT  oMainWnd:CoorsUpdate()


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ NewWnd() ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inicializa a nova area de trabalho.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function NewWnd()
Local nRow1
Local nRow2
Local nCol1
Local nCol2
Local aTmp
Local cDriver := __cRDD

Local cArqWnd
Local lConfirma := .F.
Local aCampos	:= {}
Local cFile	:= "NomeArq"
Local	cIndex := CriaTrab(nil,.f.)
Local cText	 := "Titulo da Dialog                    "
Local aCombo := {"Normal","Advanced","Maximizada","MDI"}

DEFINE MSDIALOG oDlgPrw FROM 80 ,145 TO 245,350 TITLE 'Nova Dialog' Of oMainWnd PIXEL


   @ 5  ,4   TO 58 ,101 LABEL '' OF oDlgPrw PIXEL
   @ 40 ,11  MSCOMBOBOX oCombo VAR cCombo1 ITEMS aCombo SIZE 82 ,50 OF oDlgPrw PIXEL
	@ 13,11 MSGET cFile VALID !Empty(cFile)  SIZE 82,9 Of oDlgPrw PIXEL
	@ 27,11 MSGET cText VALID .T.  SIZE 82,9 Of oDlgPrw PIXEL

   DEFINE SBUTTON FROM 65 ,38  TYPE 1   ACTION {|| lConfirma := .T.,oDlgPrw:End()}  ENABLE OF oDlgPrw
   DEFINE SBUTTON FROM 65 ,71  TYPE 2   ACTION {|| oDlgPrw:End() }  ENABLE OF oDlgPrw



ACTIVATE MSDIALOG oDlgPrw

If lConfirma
	AADD(aCampos,{ "SEQ","C",3,0 } )
	AADD(aCampos,{ "OBJECT","C",15,0 } )
	AADD(aCampos,{ "PARAM1","C",60,0 } ) // Nome do objeto
	AADD(aCampos,{ "PARAM2","C",03,0 } )
	AADD(aCampos,{ "PARAM3","C",03,0 } )
	AADD(aCampos,{ "PARAM4","C",03,0 } )
	AADD(aCampos,{ "PARAM5","C",03,0 } )
	AADD(aCampos,{ "PARAM6","C",03,0 } )
	AADD(aCampos,{ "PARAM7","C",03,0 } )
	AADD(aCampos,{ "PARAM8","C",03,0 } )


	If Select("WND") > 0
		dbSelectArea("WND")
		dbClearFilter()
		dbCloseArea()
	EndIf

	MaKeDIR("\TELASMKM\")

	cFile	:= "\TELASMKM\"+AllTrim(cFile) + ".MKM"

	If File(cFile)
		MsgAlert("O Arquivo selecionado ja existe no diretorio. Verifique o nome do arquivo !")
		Return
	EndIf

	dbCreate(cFile,aCampos,cDriver)
	dbUseArea( .T.,, cFile,"WND",.T.,.F.)
	IndRegua("WND",cIndex,"SEQ")

	lOk	:= .T.

	aTmp := EnterNew()
	nCol1:= aTmp[1]
	nRow1:= aTmp[2]

	aTmp := EnterNew()
	nCol2:= aTmp[1]
	nRow2:= aTmp[2]

	NewObject("MsDialog",cText,STR(nRow1),STR(nCol1),STR(nRow2),STR(nCol2),cCombo1,"SC5","SA3")

	Preview()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Preview() ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta um preview do projeto atual.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Preview()
Local oDlgPrw
Local cType
dbSelectArea("WND")
dbGotop()
cType	:= WND->PARAM6
cAliasG := AllTrim(WND->PARAM7)
cAliasE := AllTrim(WND->PARAM8)


IniaCols(.T.)
DEFINE MSDIALOG oDlgPrw FROM VAL(WND->PARAM2),VAL(WND->PARAM3) TO VAL(WND->PARAM4),VAL(WND->PARAM5) TITLE AllTrim(WND->PARAM1) Of oMainWnd PIXEL

	oPanel := TPanel():New(0,0,'',oDlgPrw, oDlgPrw:oFont, .T., .T.,, ,1245,23,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT


While !Eof()
	LoadObj(@oPanel,.F.)
	dbSelectArea("WND")
	dbSkip()
End

Do Case
	Case cType == "Nor"
		oDlgPrw:lMaximized := .F.
		ACTIVATE MSDIALOG oDlgPrw
	Case cType == "Adv"
		oDlgPrw:lMaximized := .F.
		ACTIVATE MSDIALOG oDlgPrw ON INIT EnchoiceBar(oDlgPrw,{||oDlgPrw:End()},{||oDlgPrw:End()})
	Case cType == "Max"
		oDlgPrw:lMaximized := .T.
		ACTIVATE MSDIALOG oDlgPrw
	Case cType == "Mdi"
		oDlgPrw:lMaximized := .T.
		ACTIVATE MSDIALOG oDlgPrw ON INIT EnchoiceBar(oDlgPrw,{||oDlgPrw:End()},{||oDlgPrw:End()})
EndCase

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Label()  ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta um label no projeto atual.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Label()
Local oDlgPrw
Local nRow1
Local nRow2
Local nCol1
Local nCol2
Local aTmp
Local cText	:= SPACE(30)


DEFINE MSDIALOG oDlgPrw FROM 112,145 TO 178,271 TITLE "Titulo do Label" Of oMainWnd PIXEL

	@ 1.5,2 to 29,61 Label "" OF oDlgPrw PIXEL
	@ 12,6 MSGET cText VALID oDlgPrw:End() SIZE 50,10 Of oDlgPrw PIXEL

ACTIVATE MSDIALOG oDlgPrw

aTmp := EnterPoint()
nCol1:= Int(aTmp[1]/2)
nRow1:= Int(aTmp[2]/2)

aTmp := EnterPoint()
nCol2:= Int(aTmp[1]/2)
nRow2:= Int(aTmp[2]/2)

NewObject("Label",cText,STR(nRow1),STR(nCol1),STR(nRow2),STR(nCol2))

Preview()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³EnterPoint³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa a leitura de um ponto no projeto atual.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EnterPoint()

Local nRetRow	:= 0
Local nRetCol	:= 0
Local oDlgP
Local oPanel
Local cType



dbSelectArea("WND")
dbGotop()
cType := WND->PARAM6

DEFINE MSDIALOG oDlgP FROM VAL(WND->PARAM2),VAL(WND->PARAM3) TO VAL(WND->PARAM4),VAL(WND->PARAM5) TITLE AllTrim(WND->PARAM1) Of oMainWnd PIXEL

	oPanel := TPanel():New(0,0,'',oDlgP, oDlgP:oFont, .T., .T.,, ,1245,23,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	oPanel:bRClicked	:= {|o,x,y| (nRetCol:=x,nRetRow:=y,oDlgP:End()) }

While !Eof()
	LoadObj(@oPanel,.F.)
	dbSelectArea("WND")
	dbSkip()
End


Do Case
	Case cType == "Nor"
		oDlgP:lMaximized := .F.
		ACTIVATE MSDIALOG oDlgP
	Case cType == "Adv"
		oDlgP:lMaximized := .F.
		ACTIVATE MSDIALOG oDlgP ON INIT EnchoiceBar(oDlgP,{||oDlgP:End()},{||oDlgP:End()})
	Case cType == "Max"
		oDlgP:lMaximized := .T.
		ACTIVATE MSDIALOG oDlgP
	Case cType == "Mdi"
		oDlgP:lMaximized := .T.
		ACTIVATE MSDIALOG oDlgP ON INIT EnchoiceBar(oDlgP,{||oDlgP:End()},{||oDlgP:End()})
EndCase

If Empty(nRetCol)  .OR. Empty(nRetRow)
	Return EnterPoint()
EndIf

Return	{nRetCol,nRetRow}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ EnterNew ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa a leitura de um ponto na Tela principal.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EnterNew()
Local nRetRow	:= 0
Local nRetCol	:= 0
Local oDlg

DEFINE DIALOG oDlg FROM 0,0 TO 600,800 TITLE "oMainWnd - 800 x 600 - Marque o 1o e 2o ponto." of oMainWnd PIXEL

//DEFINE MSDIALOG oDlgPrw FROM 1, 1 TO 22, 75  TITLE OemToAnsi( "Siga Advanced ")  OF oMainWnd

oPanel := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,1245,23,.T.,.T. )
oPanel:Align := CONTROL_ALIGN_ALLCLIENT

oPanel:bRClicked	:= {|o,x,y| (nRetCol:=x,nRetRow:=y,oDlg:End()) }



ACTIVATE MSDIALOG oDlg CENTERED


Return	{nRetCol,nRetRow}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ MkSay()  ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclui um objeto Say no projeto atual.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MkSay()
Local oDlgPrw
Local nRow1
Local nCol1
Local nRow2
Local nCol2
Local aTmp
Local cText	:= SPACE(60)
aRotina[1][4] := 4

DEFINE MSDIALOG oDlgPrw FROM 112,145 TO 178,271 TITLE "Objeto Say" Of oMainWnd PIXEL

	@ 1.5,2 to 29,61 Label "" OF oDlgPrw PIXEL
	@ 12,6 MSGET cText VALID .T.  SIZE 50,10 Of oDlgPrw PIXEL

ACTIVATE MSDIALOG oDlgPrw


aTmp := EnterPoint()
nCol1:= Int(aTmp[1]/2)
nRow1:= Int(aTmp[2]/2)

aTmp := EnterPoint()
nCol2:=Int( aTmp[1]/2)
nRow2:=Int( aTmp[2]/2)

NewObject("Say",cText,STR(nRow1),STR(nCol1),STR(nCol2-nCol1),"9")

Preview()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ MkGet()  ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclui um objeto MsGet no projeto atual.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MkGet()

Local oDlgPrw
Local nRow1
Local nCol1
Local nRow2
Local nCol2
Local aTmp
Local cText	:= "cVariavel"
Local lOk := .T.
aRotina[1][4] := 4

DEFINE MSDIALOG oDlgPrw FROM 112,145 TO 178,271 TITLE "Objeto Get" Of oMainWnd PIXEL

	@ 1.5,2 to 29,61 Label "Variavel" OF oDlgPrw PIXEL
	@ 12,6 MSGET cText VALID .T.  SIZE 50,10 Of oDlgPrw PIXEL

ACTIVATE MSDIALOG oDlgPrw

If lOk
	GrvGet(cText)
EndIf

Return

Static Function GrvGet(cText)

aTmp := EnterPoint()
nCol1:= Int(aTmp[1]/2)
nRow1:= Int(aTmp[2]/2)
aTmp := EnterPoint()
nCol2:= Int(aTmp[1]/2)
nRow2:= Int(aTmp[2]/2)


NewObject("MsGet",AllTrim(cText),STR(nRow1),STR(nCol1),STR(nCol2-nCol1),"SA1")

MsUnlock()
Preview()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³NewObject³ Autor ³ Edson Maricate        ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa a gravacao do objeto no projeto atual.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    														    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function NewObject(cObject,cParam1,cParam2,cParam3,cParam4,cParam5,cParam6,cParam7,cParam8)
Local cSeqAtu

dbSelectArea("WND")
dbSeek("ZZZ")
dbSkip(-1)
cSeqAtu	:= WND->SEQ

If Empty(cSeqAtu)
	cSeqAtu	:= "000"
EndIf
RecLock("WND",.T.)
	WND->SEQ	:= SomaIt(cSeqAtu)
	WND->OBJECT	 := AllTrim(cObject)
	WND->PARAM1	 := Alltrim(cParam1)
	WND->PARAM2	 := Alltrim(cParam2)
	WND->PARAM3	 := Alltrim(cParam3)
	WND->PARAM4	 := Alltrim(cParam4)
	WND->PARAM5	 := Alltrim(cParam5)
	WND->PARAM6	 := Alltrim(cParam6)
	WND->PARAM7	 := Alltrim(cParam7)
	WND->PARAM8	 := Alltrim(cParam8)
MsUnlock()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ LoadObj ³ Autor ³ Edson Maricate        ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa a leitura do objeto no arquivo posicionado.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    														    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LoadObj(oDlg,lScript)
cRet	:= ""

Do Case
	Case WND->OBJECT = "Label"
		If lScript
			cRet := '   @ '+WND->PARAM2+","+WND->PARAM3+" TO "+WND->PARAM4+","+WND->PARAM5+" LABEL '"+Alltrim(WND->PARAM1)+"' OF oPanel PIXEL"
		Else
			@ VAL(WND->PARAM2),VAL(WND->PARAM3) TO VAL(WND->PARAM4),VAL(WND->PARAM5) Label Alltrim(WND->PARAM1) Of oDlg PIXEL
		EndIf
	Case WND->OBJECT = "Say"
		If lScript
			cRet	:= "   @ "+WND->PARAM2+","+WND->PARAM3+" SAY '"+AllTrim(WND->PARAM1)+"' Of oPanel PIXEL SIZE "+WND->PARAM4+","+WND->PARAM5
		Else
         cTextSay:= "{||' "+AllTrim(WND->PARAM1)+" '}"
			oSay := TSay():New( VAL(WND->PARAM2),VAL(WND->PARAM3), MontaBlock(cTextSay) , oDlg , ,,,,,.T.,,,VAL(WND->PARAM4),VAL(WND->PARAM5))
		EndIf
	Case WND->OBJECT = "MsGet"
		If lScript
			If !Empty(WND->PARAM5)
				cRet	:= "   @ "+WND->PARAM2+","+WND->PARAM3+" MSGET "+Alltrim(WND->PARAM1)+"  Picture PesqPicture('SA1','A1_CAMPO') F3 CpoRetF3('CAMPO');"+CHR(13)+CHR(10)+"               When VisualSX3('CAMPO') Valid CheckSX3('A1_CAMPO') ;"+chr(13)+chr(10)+"             .And. MontaF3('') OF oPanel PIXEL HASBUTTON SIZE "+ WND->PARAM4+ ",9"+CHR(13)+CHR(10)
			Else
				cRet	:= "   @ "+WND->PARAM2+","+WND->PARAM3+" MSGET "+Alltrim(WND->PARAM1)+"  Picture PesqPicture('SA1','A1_CAMPO') ;"+CHR(13)+CHR(10)+"                  When VisualSX3('CAMPO') Valid CheckSX3('A1_CAMPO') ;"+chr(13)+chr(10)+"             .And. MontaF3('') OF oPanel PIXEL SIZE "+ WND->PARAM4+ ",9"+CHR(13)+CHR(10)
			EndIf
		Else
			If !Empty(WND->PARAM5)
				@ VAL(WND->PARAM2),VAL(WND->PARAM3) MSGET cGet Picture "@"  Of oDlg PIXEL SIZE VAL(WND->PARAM4),9  F3 WND->PARAM5 HASBUTTON
			Else
				@ VAL(WND->PARAM2),VAL(WND->PARAM3) MSGET cGet Picture "@"  Of oDlg PIXEL SIZE VAL(WND->PARAM4),9
			EndIf
		EndIf
	Case WND->OBJECT = "MsButton"
		If lScript
			cRet	:= "   DEFINE SBUTTON FROM "+WND->PARAM2+","+WND->PARAM3+" TYPE "+WND->PARAM4+" ACTION  ENABLE OF oPanel"
		Else
			DEFINE SBUTTON FROM VAL(WND->PARAM2),VAL(WND->PARAM3) TYPE VAL(WND->PARAM4) ACTION (MsgAlert("")) ENABLE OF oDlg
		EndIf
	Case WND->OBJECT = "Button"
		If lScript
			cRet	:= "    @"+WND->PARAM2+","+WND->PARAM3+" BUTTON '"+Alltrim(WND->PARAM1)+"' SIZE "+WND->PARAM4+","+WND->PARAM5+" FONT oPanel:oFont ACTION (MsgAlert(''))  OF oPanel PIXEL "
		Else
			@ VAL(WND->PARAM2),VAL(WND->PARAM3) BUTTON Alltrim(WND->PARAM1) SIZE VAL(WND->PARAM4),VAL(WND->PARAM5) FONT oDlg:oFont ACTION (MsgAlert(""))  OF oDlg PIXEL
		EndIf
	Case WND->OBJECT = "MsComboBox"
		If lScript
			cRet	:= "    @"+	WND->PARAM2+","+WND->PARAM3+" MSCOMBOBOX oCombo VAR cCombo ITEMS aCombo SIZE "+ WND->PARAM4+",50 OF oPanel PIXEL "
		Else
			@	VAL(WND->PARAM2),VAL(WND->PARAM3) MSCOMBOBOX oCombo VAR cCombo ITEMS aCombo SIZE VAL(WND->PARAM4),50 OF oDlg PIXEL
		EndIf
	Case WND->OBJECT = "Ms-Getdados"
		If lScript
			cRet		:= "    oGetDados := MSGetDados():New("+AllTrim(WND->PARAM2)+","+AllTrim(WND->PARAM3)+","+AllTrim(WND->PARAM4)+","+AllTrim(WND->PARAM5)+",nOpc,'funcLinOk','funcTudok','+ITEM',.T.,,,,nMaxItens)"
		Else
			oGetDados := MSGetDados():New(VAL(WND->PARAM2),VAL(WND->PARAM3),VAL(WND->PARAM4),VAL(WND->PARAM5),2,".T.",".T.","",.F.)
		EndIf
	Case WND->OBJECT = "Enchoice"
		If lScript
			cRet := '   oEnch := MsMGet():New("'+cAliasE+'",(RecNo()),1,,,,,{'+Alltrim(WND->PARAM2)+','+Alltrim(WND->PARAM3)+','+AllTrim(WND->PARAM4)+','+AllTrim(WND->PARAM5)+'},,3,,,,oPanel,,,,,,.T.)'
		Else
   		dbSelectArea(cAliasE)
			RegToMemory(cAliasE,.F.,,.F.)
			oEnch := MsMGet():New(cAliasE,(cAliasE)->(RecNo()),1,,,,,{VAL(WND->PARAM2),VAL(WND->PARAM3),VAL(WND->PARAM4),VAL(WND->PARAM5)},,3,,,,oDlg,,,,,,.T.)
		EndIf
EndCase


Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ MkBut()  ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclui um objeto Button no projeto.  .                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MkBut()

Local nRow1
Local nCol1
Local aTmp

Local nType

nType := SeleBut()


If nType > 0

	aTmp := EnterPoint()
	nCol1:= Int(aTmp[1]/2)
	nRow1:= Int(aTmp[2]/2)

	NewObject("MsButton","Type "+STR(nType),STR(nRow1),STR(nCol1),STR(nType))

	Preview()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Script() ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria um script com os comandos da tela.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Script()
Local nHandle	:= 1
Local cWrite
Local cFile	:= "NomeArq "



dbSelectArea("WND")
dbGoTop()

cWrite := "Local oDlg"+Chr(13)+Chr(10)
cWrite += ""+Chr(13)+Chr(10)
cType	:= WND->PARAM6
cWrite += "DEFINE MSDIALOG oDlg FROM "+ WND->PARAM2 +","+WND->PARAM3+" TO "+WND->PARAM4+","+WND->PARAM5+" TITLE '"+AllTrim(WND->PARAM1)+"' Of oMainWnd PIXEL"+Chr(13)+Chr(10)
cWrite += Chr(13)+Chr(10)
cWrite += "oPanel := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,1245,23,.T.,.T. )"+Chr(13)+Chr(10)
cWrite += "oPanel:Align := CONTROL_ALIGN_ALLCLIENT"+Chr(13)+Chr(10)
cWrite += Chr(13)+Chr(10)


While !Eof()
	cWrite	+= LoadObj(,.T.)+Chr(13)+Chr(10)
	dbSelectArea("WND")
	dbSkip()
End

Do Case
	Case cType == "Nor"
		cWrite	+= CHR(13)+CHR(10) +"oDlg:lMaximized := .F."
		cWrite	+= CHR(13)+CHR(10) +"ACTIVATE MSDIALOG oDlg"
	Case cType == "Adv"
		cWrite	+= CHR(13)+CHR(10) +"oDlg:lMaximized := .F."
		cWrite	+= CHR(13)+CHR(10) +"ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})	"

	Case cType == "Max"
		cWrite	+= CHR(13)+CHR(10) +"oDlg:lMaximized := .T."
		cWrite	+= CHR(13)+CHR(10) +"ACTIVATE MSDIALOG oDlg"
	Case cType == "Mdi"
		cWrite	+= CHR(13)+CHR(10) +"oDlg:lMaximized := .T."
		cWrite	+= CHR(13)+CHR(10) +"ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})	"
EndCase


cTexto := cWrite
DEFINE FONT oFont NAME "Courier New" SIZE 5,12   //6,15
DEFINE MSDIALOG oDlg TITLE "DialogIDE - Código ADVPL" From 3,0 to 540,617 PIXEL
@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 300,245 OF oDlg PIXEL
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 253,275 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
DEFINE SBUTTON  FROM 253,245 TYPE 13 ACTION (cFile:=cGetFile("Arquivos .PRT (*.PRT) |*.PRT|",""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."


ACTIVATE MSDIALOG oDlg CENTER


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ MkBut1() ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclui um objeto Button no projeto.  .                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MkBut1()
Local oDlg
Local nRow1
Local nCol1
Local cText	:= SPACE(60)
Local aSize := {" 5 x  5","15 x 10","20 x 10","25 x 11","35 x 11","50 x 11","70 x 11","90 x 15"}
Local cSize	:= aSize[5]
Local oSize
Local nSize,nSize1,nSize2

DEFINE MSDIALOG oDlg FROM 98 ,95  TO 207,262 TITLE "Button" Of oMainWnd PIXEL

   @ 6.5,3.5 TO 49,79 LABEL "Button" OF oDlg PIXEL
	@ 18,7.5 MSGET cText  Picture "@" OF oDlg PIXEL SIZE 68,9
   @ 33,7.0 MSCOMBOBOX oSize VAR cSize ITEMS aSize SIZE 68,50 OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg

nSize1 := Val(Substr(cSize,1,2))
nSize2 := Val(Substr(cSize,6,2))

aTmp := EnterPoint()
nCol1:= Int(aTmp[1]/2)
nRow1:= Int(aTmp[2]/2)

NewObject("Button",cText,STR(nRow1),STR(nCol1),STR(nSize1),STR(nSize2))

Preview()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³  MkOpe()  ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Abre uma janela do disco.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MkOpe()
Local cFile
Local	cIndex := CriaTrab(nil,.f.)

cFile := cGetFile("Arquivos de Telas .MKM | *.MKM", "Selecione o arquivo",0,"SERVIDOR\TELASMKM\",.T.)


If !Empty(cFile)
	If Select("WND") > 0
		dbSelectArea("WND")
	dbClearFilter()
		dbCloseArea()
	EndIf
	dbUseArea( .T.,, cFile,"WND",.T.,.F.)
	IndRegua("WND",cIndex,"SEQ")
	lOk	:= .T.
	EditObjs()
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ MkCom()  ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclui um objeto MsComboBox no projeto atual.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MkCom()


Local nRow1
Local nCol1
Local nRow2
Local nCol2
Local aTmp

aTmp := EnterPoint()
nCol1:= Int(aTmp[1]/2)
nRow1:= Int(aTmp[2]/2)
aTmp := EnterPoint()
nCol2:= Int(aTmp[1]/2)
nRow2:= Int(aTmp[2]/2)


NewObject("MsComboBox",,STR(nRow1),STR(nCol1),STR(nCol2-nCol1))

MsUnlock()
Preview()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³GetDados()³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta uma getdados no projeto atual.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MkGetDados()

Local nRow1
Local nRow2
Local nCol1
Local nCol2
Local aTmp


aTmp := EnterPoint()
nCol1:= Int(aTmp[1]/2)
nRow1:= Int(aTmp[2]/2)

aTmp := EnterPoint()
nCol2:= Int(aTmp[1]/2)
nRow2:= Int(aTmp[2]/2)

IniaCols()

NewObject("Ms-Getdados",,STR(nRow1),STR(nCol1),STR(nRow2),STR(nCol2))

Preview()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³GetDados()³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta uma getdados no projeto atual.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MkEnch()

Local nRow1
Local nRow2
Local nCol1
Local nCol2
Local aTmp


aTmp := EnterPoint()
nCol1:= Int(aTmp[1]/2)
nRow1:= Int(aTmp[2]/2)

aTmp := EnterPoint()
nCol2:= Int(aTmp[1]/2)
nRow2:= Int(aTmp[2]/2)

IniaCols()

NewObject("Enchoice",,STR(nRow1),STR(nCol1),STR(nRow2),STR(nCol2))

Preview()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³IniaCols()³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inicializa o aCols utilizado na getdados.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IniaCols(lForce)
Local ny
Local ncols

Local nUsado	:= 0
DEFAULT lForce := .F.

If Empty(aCols) .Or. lForce
	cAliasE := If(Empty(cAliasE),"SA3",cAliasE)
	cAliasG := If(Empty(cAliasG),"SC5",cAliasG)
	dbSelectArea(cAliasE)
	RegToMemory(cAliasE,.F.,,.F.)

	aCols := {}
	aHeader := {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	If dbSeek(cAliasG)
		cAlias	:= cAliasG
	Else
		cAlias := "SA1"
		cAliasG := "SA1"
	EndIf
	While !EOF() .And. (x3_arquivo == cAliasG)
		IF X3USO(x3_usado) .And. cNivel >= x3_nivel
		   nUsado++
	 	   AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
				       x3_tamanho, x3_decimal, x3_valid,;
				       x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Endif
		dbSkip()
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a montagem de uma linha em branco no aCols.              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For ncols	:= 1 to 40
		aadd(aCols,Array(nUsado+1))
		For ny := 1 to Len(aHeader)
			If ( aHeader[ny][10] != "V")
				aCols[Len(aCols)][ny] := CriaVar(aHeader[ny][2],.F.)
			EndIf
			aCols[Len(aCols)][nUsado+1] := .F.
		Next ny
	Next
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³EditObjs()³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Permite a edicao dos objetos da tela.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EditObjs()

Local oDlg
Local oGet

Local aHeadTMP	:= {}
Local nAux
Local aBack
Local nx

PRIVATE nOpcAnt := aRotina[1][4]
PRIVATE nSavN		:= n
PRIVATE aSavHeader	:= aHeader
PRIVATE aSavCols 		:= aCols

PRIVATE aHeader 	:= {}
PRIVATE aCols 	:= {}
aRotina[1][4] := 4

aHeadTMP := { {"","SEQ","No.",.F.,".T.","@!",3,0,"C"},;
				  {"","OBJECT","Objeto",.F.,".T.","@",10,0,"C"},;
				  {"","NAME","Nome",.F.,".T.","@",20,0,"C"},;
				  {"","AXX"  ,"Param  1",.F.,".T.","@",3,0,"C"},;
				  {"","BXX","Param  2",.T.,".T.","@",3,0,"C"} ,;
				  {"","CXX","Param  3",.T.,".T.","@",3,0,"C"} ,;
				  {"","DXX","Param  4",.T.,".T.","@",3,0,"C"} ,;
				  {"","EXX","Param  5",.T.,".T.","@",3,0,"C"} ,;
				  {"","FXX","Param  6",.T.,".T.","@",3,0,"C"} ,;
				  {"","GXX","Param  7",.T.,".T.","@",3,0,"C"} }

SX3->(dbSetOrder(2))
SX3->(dbSeek("A1_COD"))
For nx := 1 to Len(aHeadTmp)
 	   AADD(aHeader,{ TRIM(aHeadTmp[nx][3]),aHeadTmp[nx][2], aHeadTmp[nx][6],;
			       aHeadTmp[nx][7], aHeadTmp[nx][8], aHeadTmp[nx][5],;
			       SX3->X3_USADO, aHeadTmp[nx][9], "", "" } )
	dbSkip()
Next


dbSelectArea("WND")
dbGotop()
While !Eof()
	aadd(aCols,{WND->SEQ,WND->OBJECT,WND->PARAM1,WND->PARAM2,WND->PARAM3,WND->PARAM4,WND->PARAM5,WND->PARAM6,WND->PARAM7,WND->PARAM8,.F.})
	dbSkip()
End
aBack	:= aClone(aCols)

DEFINE MSDIALOG oDlg FROM 67 ,71  TO 320,589 TITLE 'Edição de Objetos' Of oMainWnd PIXEL

   @ 6  ,4   TO 103,255 LABEL 'Objetos' OF oDlg PIXEL
   oGet := 	MsGetDados():New(16,10,97,249,1,,,,.T.,,,,300,,,,,oDlg)
   DEFINE SBUTTON FROM 112,209 TYPE 1   ACTION (EditGrv(),oDlg:End()) ENABLE OF oDlg
   DEFINE SBUTTON FROM 112,174 TYPE 2   ACTION (Cancela(aBack),oDlg:End()) ENABLE OF oDlg
   DEFINE SBUTTON FROM 112,140 TYPE 15   ACTION (ObjPrev()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg


aCols := aClone(aSavCols)
aHeader := aClone(aSavHeader)
aRotina[1][4] := nOpcAnt

n := nsavN

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³EditGrv() ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Permite a edicao dos objetos da tela.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EditGrv()
Local ny

dbSelectArea("WND")
For ny	:= 1 to Len(aCols)
If dbSeek(aCols[ny][1])
	If !aCols[ny][11]
		Reclock("WND",.F.)
		WND->PARAM1	:= aCols[ny][3]
		WND->PARAM2	:= aCols[ny][4]
		WND->PARAM3	:= aCols[ny][5]
		WND->PARAM4	:= aCols[ny][6]
		WND->PARAM5	:= aCols[ny][7]
		WND->PARAM6	:= aCols[ny][8]
		WND->PARAM7	:= aCols[ny][9]
		WND->PARAM8	:= aCols[ny][10]
		MsUnlock()
	Else
		RecLock("WND",.F.,.T.)
		dbDelete()
		MsUnlock()
	EndIf
Else
	If !aCols[ny][11]
		Reclock("WND",.T.)
		WND->SEQ		:= aCols[ny][1]
		WND->OBJECT	:= aCols[ny][2]
		WND->PARAM1	:= aCols[ny][3]
		WND->PARAM2	:= aCols[ny][4]
		WND->PARAM3	:= aCols[ny][5]
		WND->PARAM4	:= aCols[ny][6]
		WND->PARAM5	:= aCols[ny][7]
		WND->PARAM6	:= aCols[ny][8]
		WND->PARAM7	:= aCols[ny][9]
		WND->PARAM8	:= aCols[ny][10]
		MsUnlock()
	EndIf
EndIf
Next


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ ObjPre() ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Permite a edicao dos objetos da tela.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ObjPrev()
Local aPreCols	:= aClone(aCols)
Local aPreHead	:= aClone(aHeader)
Local nSav		:= n
Local nSavRot	:=aRotina[1][4]



EditGrv()


aCols := aClone(aSavCols)
aHeader := aClone(aSavHeader)
n		:= nSavN
aRotina[1][4] := nOpcAnt

Preview()

n			:= nSav
aCols		:= aClone(aPreCols)
aHeader	:= aClone(aPreHead)
aRotina[1][4] := nSavRot

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Cancela()³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Permite a edicao dos objetos da tela.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Cancela(aBack)

aCols	:= aClone(aBack)

EditGrv()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ SeleBut()³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Seleciona um botao Ms Button .                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SeleBut()
Local nType	:= 0
Local oDlg

DEFINE MSDIALOG oDlg FROM 84 ,44  TO 240,480 TITLE 'Selecione o tipo do Ms-Button' Of oMainWnd PIXEL

   @ 2  ,2   TO 73,215 LABEL ' Tipos do Ms-Button ' OF oDlg PIXEL
   DEFINE SBUTTON FROM 14 ,8   TYPE 1    ACTION (nType:=1,oDlg:End()) ENABLE OF oDlg
   DEFINE SBUTTON FROM 14 ,43  TYPE 2    ACTION  (nType:=2,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 14 ,76  TYPE 3    ACTION  (nType:=3,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 14 ,111 TYPE 4    ACTION  (nType:=4,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 14 ,144 TYPE 5    ACTION  (nType:=5,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 14 ,178 TYPE 6    ACTION  (nType:=6,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 32 ,8   TYPE 7    ACTION  (nType:=7,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 32 ,43  TYPE 8    ACTION  (nType:=8,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 32 ,76  TYPE 9    ACTION  (nType:=9,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 32 ,111 TYPE 10   ACTION  (nType:=10,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 32 ,144 TYPE 11   ACTION  (nType:=11,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 32 ,178 TYPE 12   ACTION  (nType:=12,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 50 ,8   TYPE 13   ACTION  (nType:=13,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 50 ,43  TYPE 14   ACTION  (nType:=14,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 50 ,76  TYPE 15   ACTION  (nType:=15,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 50 ,111 TYPE 16   ACTION  (nType:=16,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 50 ,144 TYPE 17   ACTION  (nType:=17,oDlg:End())  ENABLE OF oDlg
   DEFINE SBUTTON FROM 50 ,178 TYPE 18   ACTION  (nType:=18,oDlg:End())  ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg


Return nType


Static Function Info()

Local oDlg

DEFINE MSDIALOG oDlg FROM 139,170 TO 242,435 TITLE "DialogIDE ADVPL 1.1" Of oMainWnd PIXEL

   @ 3  ,6   TO 46 ,127 LABEL '' OF oDlg PIXEL
   @ 11 ,12  SAY "DialogIDE ADVPL 1.1" Of oDlg PIXEL SIZE 39 ,9
   @ 25 ,12  SAY 'Editor de Dialog ADVPL Protheus' Of oDlg PIXEL SIZE 85 ,9
   @ 33 ,12  SAY 'www..com.br' Of oDlg PIXEL SIZE 110,9

ACTIVATE MSDIALOG oDlg


Return


User Function GerDocPrj()
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : Geracao da documentacao de funcoes utilizando como base o arquivo .PRJ do IDE( Projeto )
<Autor> : AVT
<Data> : 20/06/2006
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Utilitarios do sistema
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Obs> :
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Return Processa( {|| u_AuxDP_R() })

User Function AuxDP_R()
Local nx,ny
Local lOk := .F.
Local cLinhaAnt1 := ""
Local cLinhaAnt2 := ""
Local cLinhaAnt3 := ""
Local cLinhaAnt4 := ""
Local cLinhaAnt := ""
Local cDrive := ""
Local aFiles := {}
Local aFuncs	:= {}
Local aRet	:= {}
Private nLin	:= 10000

If ParamBox({    {6,"Arquivo de Projeto",SPACE(254),,"FILE(mv_par01)","", 95 ,.T.,"Arquivo .PRJ |*.PRJ",,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE}},"Selecione o arquivo",@aRet)
	If (nHandle := FT_FUse(mv_par01) )== -1
		Help(" ",1,"NOFILEIMPOR")
		Return
	Else
		FT_FGOTOP()
		FT_FSKIP()
		While !FT_FEOF()
			cLinha := FT_FREADLN()
			If (At("File \",cLinha) > 0) .or. (At("File  \",cLinha) > 0)
				aAdd(aFiles,Substr(cLinha,At("\",cLinha)))
			EndIf
			FT_FSKIP()
		End
		FT_FUSE()
	EndIf
EndIf

SplitPath( mv_par01, @cDrive)

ProcRegua(len(aFiles)*2)

For nx := 1 to Len(aFiles)
	IncProc(cDrive+aFiles[nx])
	If (nHandle := FT_FUse(cDrive+aFiles[nx]) )== -1
		AViso("Falha na abertura","Nao foi possivel abrir o arquivo :"+AllTrim(cDrive+aFiles[nx])+". Verifique a integridade e o compartilhamento do mesmo.",{"Fechar"},2)
	Else
		FT_FGOTOP()
		cLinhaAnt := ""
		While !FT_FEOF()
			cLinha := FT_FREADLN()
			nPosArray := 0
			nPosPAnt	:= 1
			If "FUNCTION"$UPPER(cLinha) .And. !("FINDFUNCTION"$UPPER(cLinha))
				aAdd(aFuncs,{AllTrim(cLinha),"","","","","","","E","","",""})
				If At("FUNCTION",UPPER(aFuncs[Len(aFuncs)][1])) > 0
					aFuncs[Len(aFuncs)][10] := Substr(aFuncs[Len(aFuncs)][1],At("FUNCTION",UPPER(aFuncs[Len(aFuncs)][1]))+9)
				EndIf
				aFuncs[Len(aFuncs)][9] := "Fonte :"+AllTrim(cDrive+aFiles[nx])+" - "
				nPos1:= At("FUNCTION",UPPER(cLinha))+9
				nPos2:=  At("(",UPPER(cLinha))
				If nPos1 > 0 .And. nPos2 > 0
					cFunc := Substr(cLinha,nPos1,nPos2-nPos1)
				Else
					cFunc := ""
				EndIf
				aFuncs[Len(aFuncs)][11] := cFunc

			EndIf
			If "/*/f/" $ cLinha .Or. "/*/F/" $ cLinha
				FT_FSKIP()
				cLinha := FT_FREADLN()
				While !FT_FEOF() .And. !("*/"$cLinha)
					cLinha := FT_FREADLN()
					Do Case
						Case "<Descr"$cLinha
							nPosArray := 2
						Case "<Aut"$cLinha
							nPosArray := 3
						Case "<Dat"$cLinha
							nPosArray := 4
						Case "<Param"$cLinha
							nPosArray := 5
						Case "<Ret"$cLinha
							nPosArray := 6
						Case "<Proces" $cLinha
							nPosArray := 7
						Case "<Tip" $cLinha
							nPosArray := 8
						Case "<Obs" $cLinha
							nPosArray := 9
					EndCase
					If nPosArray > 0
						If !("ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ"$cLinha .Or. "*/"$cLinha)
							If !Empty(aFuncs[Len(aFuncs)][nPosArray])
								aFuncs[Len(aFuncs)][nPosArray] += CRLF+Substr(cLinha,nPosPAnt+1)
							Else
								aFuncs[Len(aFuncs)][nPosArray] += Substr(cLinha,At(":",cLinha)+1)
								nPosPAnt:= At(":",cLinha)
							EndIf
						EndIf
					EndIf
					FT_FSKIP()
				End
				cLinhaAnt4 := ""
				cLinhaAnt3 := ""
				cLinhaAnt2 := ""
				cLinhaAnt1 := ""
				cLinhaAnt := ""
			EndIf
			cLinhaAnt4 := cLinhaAnt3
			cLinhaAnt3 := cLinhaAnt2
			cLinhaAnt2 := cLinhaAnt1
			cLinhaAnt1 := cLinhaAnt
			cLinhaAnt := cLinha
			FT_FSKIP()
		End
	EndIf

Next

For nx := 1 to Len(aFiles)
	IncProc(cDrive+aFiles[nx])
	lComent := .F.
	nPosFunc := 0
	If (nHandle := FT_FUse(cDrive+aFiles[nx]) )== -1
		AViso("Falha na abertura","Nao foi possivel abrir o arquivo :"+AllTrim(cDrive+aFiles[nx])+". Verifique a integridade e o compartilhamento do mesmo.",{"Fechar"},2)
	Else
		FT_FGOTOP()
		cLinhaAnt := ""
		While !FT_FEOF()
			cLinha := FT_FREADLN()
			If "/*" $ cLinha .And. !lComent
				lComent := .T.
				FT_FSKIP()
				Loop
			EndIf
			If "*/" $ cLinha .And. lComent
				lComent := .F.
				FT_FSKIP()
				Loop
			EndIf
			If !lComent
				If "FUNCTION"$UPPER(cLinha) .And. !("FINDFUNCTION"$UPPER(cLinha))
					If At("FUNCTION",UPPER(cLinha)) > 0
						nPosFunc := aScan(aFuncs,{|x| x[10] == Substr(cLinha,At("FUNCTION",UPPER(cLinha))+9) } )
					EndIf
				Else
					If nPosFunc > 0
						For ny := 1 to Len(aFuncs)
							If UPPER(aFuncs[ny][11])$UPPER(cLinha)
								aFuncs[ny][9] += " Usado em : "+aFuncs[nPosFunc,11]+ "  "
							EndIf
						Next ny
					EndIf
				EndIf
			EndIf
			FT_FSKIP()
		End
	EndIf

Next


IncProc("Executando impressao")

oPrint := PcoPrtIni("Detalhamento de Funcoes",,2,,@lOk)


If lOK
	nLin := 200
	PcoPrtCab(oPrint)
	nLin+=20
	PcoPrtCol({10,450,1700},.T.,2)
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,"Arquivo",oPrint,1,2,RGB(230,230,230))
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,Upper(mv_par01),oPrint,1,2,RGB(230,230,230))
	nLin+=45

	PcoPrtCol({10,450,1700},.T.,2)
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,"Funcoes de Menu",oPrint,1,5,RGB(230,230,230))
	nLin+=100
	For nx := 1 to Len(aFuncs)
		IncProc("Imprimindo Funcoes de Menu : "+Str(nx))
		If Substr(AllTrim(aFuncs[nx,8]),1,1) == "M"
			If PcoPrtLim(nLin)
				nLin := 200
				PcoPrtCab(oPrint)
				nLin+=20
				PcoPrtCol({10,450,1700},.T.,2)
			EndIf
			ImpF(aFuncs,nx)
		EndIf
	Next
	nLin := 200
	PcoPrtCab(oPrint)
	nLin+=20
	PcoPrtCol({10,450,1700},.T.,2)
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,"Arquivo",oPrint,1,2,RGB(230,230,230))
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,Upper(mv_par01),oPrint,1,2,RGB(230,230,230))
	nLin+=45
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,"Funcoes de Gatilhos",oPrint,1,5,RGB(230,230,230))
	nLin+=100
	For nx := 1 to Len(aFuncs)
		IncProc("Imprimindo Funcoes de Gatilhos : "+Str(nx))
		If Substr(AllTrim(aFuncs[nx,8]),1,1) == "T"
			If PcoPrtLim(nLin)
				nLin := 200
				PcoPrtCab(oPrint)
				nLin+=20
				PcoPrtCol({10,450,1700},.T.,2)
			EndIf
			ImpF(aFuncs,nx)
		EndIf
	Next
	nLin := 200
	PcoPrtCab(oPrint)
	nLin+=20
	PcoPrtCol({10,450,1700},.T.,2)
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,"Arquivo",oPrint,1,2,RGB(230,230,230))
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,Upper(mv_par01),oPrint,1,2,RGB(230,230,230))
	nLin+=45
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,"Funcoes de Validacao",oPrint,1,5,RGB(230,230,230))
	nLin+=100
	For nx := 1 to Len(aFuncs)
		IncProc("Imprimindo Funcoes de Validacoes : "+Str(nx))
		If Substr(AllTrim(aFuncs[nx,8]),1,1) == "V"
			If PcoPrtLim(nLin)
				nLin := 200
				PcoPrtCab(oPrint)
				nLin+=20
				PcoPrtCol({10,450,1700},.T.,2)
			EndIf
			ImpF(aFuncs,nx)
		EndIf
	Next
	nLin := 200
	PcoPrtCab(oPrint)
	nLin+=20
	PcoPrtCol({10,450,1700},.T.,2)
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,"Arquivo",oPrint,1,2,RGB(230,230,230))
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,Upper(mv_par01),oPrint,1,2,RGB(230,230,230))
	nLin+=45
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,"Funcoes de Pontos de Entrada",oPrint,1,5,RGB(230,230,230))
	nLin+=100
	For nx := 1 to Len(aFuncs)
		IncProc("Imprimindo Funcoes P : "+Str(nx))
		If Substr(AllTrim(aFuncs[nx,8]),1,1) == "P"
			If PcoPrtLim(nLin)
				nLin := 200
				PcoPrtCab(oPrint)
				nLin+=20
				PcoPrtCol({10,450,1700},.T.,2)
			EndIf
			ImpF(aFuncs,nx)
		EndIf
	Next
	nLin := 200
	PcoPrtCab(oPrint)
	nLin+=20
	PcoPrtCol({10,450,1700},.T.,2)
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,"Arquivo",oPrint,1,2,RGB(230,230,230))
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,Upper(mv_par01),oPrint,1,2,RGB(230,230,230))
	nLin+=45
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,"Funcoes Especificas",oPrint,1,5,RGB(230,230,230))
	nLin+=100
	For nx := 1 to Len(aFuncs)
		IncProc("Imprimindo Funcoes Especificas : "+Str(nx)+"de"+Str(Len(aFuncs)))
		If Substr(AllTrim(aFuncs[nx,8]),1,1) == "E"
			If PcoPrtLim(nLin)
				nLin := 200
				PcoPrtCab(oPrint)
				nLin+=20
				PcoPrtCol({10,450,1700},.T.,2)
			EndIf
			ImpF(aFuncs,nx)
		EndIf
	Next
	nLin := 200
	PcoPrtCab(oPrint)
	nLin+=20
	PcoPrtCol({10,450,1700},.T.,2)
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,"Arquivo",oPrint,1,2,RGB(230,230,230))
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,Upper(mv_par01),oPrint,1,2,RGB(230,230,230))
	nLin+=45
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,"Funcoes Genericas",oPrint,1,5,RGB(230,230,230))
	nLin+=100
	For nx := 1 to Len(aFuncs)
		IncProc("Imprimindo Funcoes G : "+Str(nx))
		If Substr(AllTrim(aFuncs[nx,8]),1,1) == "G"
			If PcoPrtLim(nLin)
				nLin := 200
				PcoPrtCab(oPrint)
				nLin+=20
				PcoPrtCol({10,450,1700},.T.,2)
			EndIf
			ImpF(aFuncs,nx)
		EndIf
	Next



EndIf

PcoPrtEnd(oPrint)
Return


Static Function Impf(aFuncs,nx)

			PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,"Funcao",oPrint,1,2,RGB(20,20,240))
			PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,aFuncs[nx,1],oPrint,3,2,RGB(230,230,254))
			nLin+=62
			PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),120,"Descricao",oPrint,1,2,RGB(240,240,240))
			PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),120,aFuncs[nx,2],oPrint,3,2,RGB(240,240,240))
			nLin+=122
			PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,"Autor",oPrint,1,2,RGB(240,240,240))
			PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,aFuncs[nx,3],oPrint,3,2,RGB(240,240,240))
			nLin+=62
			PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,"Data",oPrint,1,2,RGB(240,240,240))
			PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,aFuncs[nx,4],oPrint,3,2,RGB(240,240,240))
			nLin+=62
			PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),320,"Parametros",oPrint,1,2,RGB(240,240,240))
			PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),320,aFuncs[nx,5],oPrint,3,2,RGB(240,240,240))
			nLin+=322
			PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),320,"Retorno",oPrint,1,2,RGB(240,240,240))
			PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),320,aFuncs[nx,6],oPrint,3,2,RGB(240,240,240))
			nLin+=322
			PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),120,"Processo",oPrint,1,2,RGB(240,240,240))
			PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),120,aFuncs[nx,7],oPrint,3,2,RGB(240,240,240))
			nLin+=122
			PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),320,"Observacoes",oPrint,1,2,RGB(240,240,240))
			PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),320,aFuncs[nx,9],oPrint,3,2,RGB(240,240,240))
			nLin+=322

Return


User Function LoadAtuSX()
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : Atualizador de dicionarios/base de dados a partir de arquivos SX
<Autor> : AVT
<Data> : 20/06/2006
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> : Utilitarios do sistema
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Obs> :
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Local aSX1
Local aRet	:= {""}
Local aSX2
Local aSX3
Local aSIX
Local aSX5
Local aSX6
Local aSX7
Local aSXA
Local aSXB
Local ny
Local cNameProc := "Atualização de dicionarios"
Local  cUpdVers 	:= "1.0"
PRIVATE oMainWnd

aRet[1] := cGetFile( "Diretorios *. |*.*","Diretorio SX",0,"C:\",.F.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_RETDIRECTORY)

If !Empty(aRet[1])
	If File(Alltrim(aRet[1])+"SIGAADV.HLP")
		CpyT2S(Alltrim(aRet[1])+"SIGAADV.HLP", "\", .F. )
	EndIf
	If File(Alltrim(aRet[1])+"SIGAADV.HLS")
		CpyT2S(Alltrim(aRet[1])+"SIGAADV.HLS", "\", .F. )
	EndIf
	If File(Alltrim(aRet[1])+"SX1990.dbf")
		CpyT2S(Alltrim(aRet[1])+"SX1990.dbf", "\", .F. )
		dbUseArea(.T.,,"\SX1990.dbf","TRB",.F.,.F.)
		cAlias := "TRB"
		dbSelectArea(cAlias)
		dbGotop()
		aStruct := (cAlias)->(dbStruct())
		aSX1 := {{},{}}
		For ny := 1 to Len(aStruct)
			aAdd(aSX1[1],aStruct[ny][1])
		Next
		While !Eof()
			aAdd(aSX1[2],Array(Len(aStruct)))
			For ny := 1 to Len(aStruct)
				aSX1[2][Len(aSX1[2])][ny] := (cAlias)->(FieldGet(ny))
			Next
			dbSkip()
		End
		dbCloseArea()
		fErase("\SX1990.dbf")
	EndIf
	If File(Alltrim(aRet[1])+"SX2990.dbf")
		CpyT2S(Alltrim(aRet[1])+"SX2990.dbf", "\", .F. )
		dbUseArea(.T.,,"\SX2990.dbf","TRB",.F.,.F.)
		cAlias := "TRB"
		dbSelectArea(cAlias)
		dbGotop()
		aStruct := (cAlias)->(dbStruct())
		aSX2 := {{},{}}
		For ny := 1 to Len(aStruct)
			aAdd(aSX2[1],aStruct[ny][1])
		Next
		While !Eof()
			aAdd(aSX2[2],Array(Len(aStruct)))
			For ny := 1 to Len(aStruct)
				aSX2[2][Len(aSX2[2])][ny] := (cAlias)->(FieldGet(ny))
			Next
			dbSkip()
		End
		dbCloseArea()
		fErase("\SX2990.dbf")
	EndIf

	If File(Alltrim(aRet[1])+"SX3990.dbf")
		CpyT2S(Alltrim(aRet[1])+"SX3990.dbf", "\", .F. )
		dbUseArea(.T.,,"\SX3990.dbf","TRB",.F.,.F.)
		cAlias := "TRB"
		dbSelectArea(cAlias)
		dbGotop()
		aStruct := (cAlias)->(dbStruct())
		aSX3 := {{},{}}
		For ny := 1 to Len(aStruct)
			aAdd(aSX3[1],aStruct[ny][1])
		Next
		While !Eof()
			aAdd(aSX3[2],Array(Len(aStruct)))
			For ny := 1 to Len(aStruct)
				aSX3[2][Len(aSX3[2])][ny] := (cAlias)->(FieldGet(ny))
			Next
			dbSkip()
		End
		dbCloseArea()
		fErase("\SX3990.dbf")
	EndIf

	If File(Alltrim(aRet[1])+"SINDEX.dbf")
		CpyT2S(Alltrim(aRet[1])+"SINDEX.dbf", "\", .F. )
		dbUseArea(.T.,,"\SINDEX.dbf","TRB",.F.,.F.)
		cAlias := "TRB"
		dbSelectArea(cAlias)
		dbGotop()
		aStruct := (cAlias)->(dbStruct())
		aSIX := {{},{}}
		For ny := 1 to Len(aStruct)
			aAdd(aSIX[1],aStruct[ny][1])
		Next
		While !Eof()
			aAdd(aSIX[2],Array(Len(aStruct)))
			For ny := 1 to Len(aStruct)
				aSIX[2][Len(aSIX[2])][ny] := (cAlias)->(FieldGet(ny))
			Next
			dbSkip()
		End
		dbCloseArea()
		fErase("\SIX990.dbf")
	EndIf

	If File(Alltrim(aRet[1])+"SX5990.dbf")
		CpyT2S(Alltrim(aRet[1])+"SX5990.dbf", "\", .F. )
		dbUseArea(.T.,,"\SX5990.dbf","TRB",.F.,.F.)
		cAlias := "TRB"
		dbSelectArea(cAlias)
		dbGotop()
		aStruct := (cAlias)->(dbStruct())
		aSX5 := {{},{}}
		For ny := 1 to Len(aStruct)
			aAdd(aSX5[1],aStruct[ny][1])
		Next
		While !Eof()
			aAdd(aSX5[2],Array(Len(aStruct)))
			For ny := 1 to Len(aStruct)
				aSX5[2][Len(aSX5[2])][ny] := (cAlias)->(FieldGet(ny))
			Next
			dbSkip()
		End
		dbCloseArea()
		fErase("\SX5990.dbf")
	EndIf
	If File(Alltrim(aRet[1])+"SX6990.dbf")
		CpyT2S(Alltrim(aRet[1])+"SX6990.dbf", "\", .F. )
		dbUseArea(.T.,,"\SX6990.dbf","TRB",.F.,.F.)
		cAlias := "TRB"
		dbSelectArea(cAlias)
		dbGotop()
		aStruct := (cAlias)->(dbStruct())
		aSX6 := {{},{}}
		For ny := 1 to Len(aStruct)
			aAdd(aSX6[1],aStruct[ny][1])
		Next
		While !Eof()
			aAdd(aSX6[2],Array(Len(aStruct)))
			For ny := 1 to Len(aStruct)
				aSX6[2][Len(aSX6[2])][ny] := (cAlias)->(FieldGet(ny))
			Next
			dbSkip()
		End
		dbCloseArea()
		fErase("\SX6990.dbf")
	EndIf

	If File(Alltrim(aRet[1])+"SX7990.dbf")
		CpyT2S(Alltrim(aRet[1])+"SX7990.dbf", "\", .F. )
		dbUseArea(.T.,,"\SX7990.dbf","TRB",.F.,.F.)
		cAlias := "TRB"
		dbSelectArea(cAlias)
		dbGotop()
		aStruct := (cAlias)->(dbStruct())
		aSX7 := {{},{}}
		For ny := 1 to Len(aStruct)
			aAdd(aSX7[1],aStruct[ny][1])
		Next
		While !Eof()
			aAdd(aSX7[2],Array(Len(aStruct)))
			For ny := 1 to Len(aStruct)
				aSX7[2][Len(aSX7[2])][ny] := (cAlias)->(FieldGet(ny))
			Next
			dbSkip()
		End
		dbCloseArea()
		fErase("\SX7990.dbf")
	EndIf

	If File(Alltrim(aRet[1])+"SXA990.dbf")
		CpyT2S(Alltrim(aRet[1])+"SXA990.dbf", "\", .F. )
		dbUseArea(.T.,,"\SXA990.dbf","TRB",.F.,.F.)
		cAlias := "TRB"
		dbSelectArea(cAlias)
		dbGotop()
		aStruct := (cAlias)->(dbStruct())
		aSXA := {{},{}}
		For ny := 1 to Len(aStruct)
			aAdd(aSXA[1],aStruct[ny][1])
		Next
		While !Eof()
			aAdd(aSXA[2],Array(Len(aStruct)))
			For ny := 1 to Len(aStruct)
				aSXA[2][Len(aSXA[2])][ny] := (cAlias)->(FieldGet(ny))
			Next
			dbSkip()
		End
		dbCloseArea()
		fErase("\SXA990.dbf")
	EndIf

	If File(Alltrim(aRet[1])+"SXB990.dbf")
		CpyT2S(Alltrim(aRet[1])+"SXB990.dbf", "\", .F. )
		dbUseArea(.T.,,"\SXB990.dbf","TRB",.F.,.F.)
		cAlias := "TRB"
		dbSelectArea(cAlias)
		dbGotop()
		aStruct := (cAlias)->(dbStruct())
		aSXB := {{},{}}
		For ny := 1 to Len(aStruct)
			aAdd(aSXB[1],aStruct[ny][1])
		Next
		While !Eof()
			aAdd(aSXB[2],Array(Len(aStruct)))
			For ny := 1 to Len(aStruct)
				aSXB[2][Len(aSXB[2])][ny] := (cAlias)->(FieldGet(ny))
			Next
			dbSkip()
		End
		dbCloseArea()
		fErase("\SXB990.dbf")
	EndIf

//	DEFINE WINDOW oMainWnd FROM 0,0 TO 01,30 TITLE cNameProc

//	ACTIVATE WINDOW oMainWnd ICONIZED ON INIT
	ProcGpe({|| AtuSX(cNameProc,cUpdVers,aSX1,aSX2,aSX3,aSIX,aSX5,aSX6,aSX7,aSXA,aSXB) },,,.T.)  // Chamada do Processamento
//	Processa({|| AtuSX(cNameProc,cUpdVers,aSX1,aSX2,aSX3,aSIX,aSX5,aSX6,aSX7,aSXA,aSXB)})
	fErase("\SIGAADV.HLP")
	fErase("\SIGAADV.HLS")
EndIf

Return


Static Function AtuSX(cNameProc,cUpdVers,aSX1,aSX2,aSX3,aSIX,aSX5,aSX6,aSX7,aSXA,aSXB)

cArqEmp := "SigaMat.Emp"
nModulo		:= 44
PRIVATE aAtuSX1	:= aSX1
PRIVATE aAtuSX2	:= aSX2
PRIVATE aAtuSX3	:= aSX3
PRIVATE aAtuSIX	:= aSIX
PRIVATE aAtuSX5	:= aSX5
PRIVATE aAtuSX6	:= aSX6
PRIVATE aAtuSX7	:= aSX7
PRIVATE aAtuSXA	:= aSXA
PRIVATE aAtuSXB	:= aSXB

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
Private __lPyme  := .F.

DEFAULT cNameProc := "Atualização de dicionarios"
DEFAULT cUpdVers 	:= "1.0"

Set Dele On

OpenSm0()
DbGoTop()

If Aviso("Atualiacao de dicionarios por pacote","Deseja efetuar a atualizacao do pacote de dicionarios selecionado ? Esta rotina deve ser utilizada em modo exclusivo ! Efetue um backup dos DICIONARIOS e da BASE DE DADOS antes da atualizacao para eventuais falhas de atualizacao ! "+CRLF+CRLF+"Proceder com a atualização ?", {"Nao","Sim"},3) == 2
	UpdProc()
EndIf


Return

Static Function UpdProc(lEnd)
Local cTexto   := ''
Local cFile    :=""
Local cMask    := "Arquivos Texto (*.TXT) |*.txt|"
Local cCodigo  := "DM"
Local nRecno   := 0
Local nX       :=0
Local nProc 	:= 0
Local cSaveEmp := SM0->M0_CODIGO
Local cSaveFil	:= SM0->M0_CODFIL

GPProcRegua(1)
//ProcRegua(8)
GPIncProc("Verificando integridade dos dicionarios existentes...")

RpcClearEnv()

OpenSm0Excl()
dbSelectArea("SM0")
dbGotop()
While !Eof()
	RpcSetType(3)
	RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
	SM0->(dbSkip())
	nRecno := SM0->(Recno())
	SM0->(dbSkip(-1))
	RpcClearEnv()
	OpenSm0Excl()
	SM0->(DbGoTo(nRecno))
	nProc++
EndDo

GPProcRegua(nProc*9)
dbSelectArea("SM0")
dbGotop()
While !Eof()
		RpcSetType(3)
		RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
		cTexto += Replicate("-",128)+ CRLF
		cTexto += "Empresa : "+AllTrim(SM0->M0_CODIGO)+" Filial : "+AllTrim(SM0->M0_CODFIL)+"-"+AllTrim(SM0->M0_NOME)+ CRLF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza as perguntes de relatorios.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GPIncProc("Verificando perguntas ..."+"Empresa : "+AllTrim(SM0->M0_CODIGO)+" Filial : "+AllTrim(SM0->M0_CODFIL))
		cTexto += AtuSX1()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o dicionario de arquivos.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GPIncProc("Verificando Tabelas... "+"Empresa : "+AllTrim(SM0->M0_CODIGO)+" Filial : "+AllTrim(SM0->M0_CODFIL)) //
		cTexto += AtuSX2()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o dicionario de dados.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GPIncProc("Verificando Estruturas... "+"Empresa : "+AllTrim(SM0->M0_CODIGO)+" Filial : "+AllTrim(SM0->M0_CODFIL)) //
		cTexto += AtuSX3()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza os parametros.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GPIncProc("Verificando Tabelas Padroes..."+"Empresa : "+AllTrim(SM0->M0_CODIGO)+" Filial : "+AllTrim(SM0->M0_CODFIL)) // //
		AtuSX5()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza os parametros.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GPIncProc("Verificando Parametros..."+"Empresa : "+AllTrim(SM0->M0_CODIGO)+" Filial : "+AllTrim(SM0->M0_CODFIL)) //
		cTexto += AtuSX6()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza os gatilhos.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GPIncProc("Verificando Gatilhos..."+"Empresa : "+AllTrim(SM0->M0_CODIGO)+" Filial : "+AllTrim(SM0->M0_CODFIL)) //
		cTexto += AtuSX7()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza os folder's de cadastro.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GPIncProc("Verificando Folder de Cadastro..."+"Empresa : "+AllTrim(SM0->M0_CODIGO)+" Filial : "+AllTrim(SM0->M0_CODFIL))
		AtuSXA()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza as consultas padroes.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GPIncProc("Verificando Consultas Padroes..."+"Empresa : "+AllTrim(SM0->M0_CODIGO)+" Filial : "+AllTrim(SM0->M0_CODFIL)) //
		AtuSXB()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza os indices.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GPIncProc("Verificando Indices..."+"Empresa : "+AllTrim(SM0->M0_CODIGO)+" Filial : "+AllTrim(SM0->M0_CODFIL)) //
		cTexto += AtuSIX()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza os helps   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GPIncProc("Atualizando Helps.."+"Empresa : "+AllTrim(SM0->M0_CODIGO)+" Filial : "+AllTrim(SM0->M0_CODFIL)) //
		cTexto += AtuHelp()


		GPIncProc("Atualizando estruturas. Aguarde... "+"Empresa : "+AllTrim(SM0->M0_CODIGO)+" Filial : "+AllTrim(SM0->M0_CODFIL))
		__SetX31Mode(.F.)
		For nX := 1 To Len(aArqUpd)

			If Select(aArqUpd[nx])>0
				dbSelecTArea(aArqUpd[nx])
				dbCloseArea()
			EndIf
			X31UpdTable(aArqUpd[nx])
			If __GetX31Error()
				Alert(__GetX31Trace())
				Aviso("Atencao!","Ocorreu um erro durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
				cTexto += "Atenção! Ocorreu um erro durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] + CRLF
			EndIf
		Next nX

		SM0->(dbSkip())
		nRecno := SM0->(Recno())
		SM0->(dbSkip(-1))
		RpcClearEnv()
		OpenSm0Excl()
		SM0->(DbGoTo(nRecno))
EndDo


cTexto := "Log da atualizacao "+ CRLF +cTexto
__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
DEFINE MSDIALOG oDlg TITLE "Atualizacao concluida" From 3,0 to 340,417 PIXEL
@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."


ACTIVATE MSDIALOG oDlg CENTER

__cInterNet := Nil
Final("Atualizacao finalizada.")


Return(.T.)


Static Function AtuSIX()
//INDICE ORDEM CHAVE DESCRICAO DESCSPA DESCENG PROPRI F3 NICKNAME
Local cTexto := ''
Local lSIX   := .F.
Local lNew   := .F.
Local aSIX   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cAlias := ''
Local nPosOrdem
Local nPosIndice
Local nPosNick
Local cLastIdx	:= "2"

If !Empty(aAtuSIX)
aEstrut		:= aAtuSIX[1]
aSIX			:= aAtuSIX[2]
nPosIndice 	:= aScan(aEstrut,"INDICE")
nPosNick 	:= aScan(aEstrut,"NICKNAME")
nPosOrdem	:= aScan(aEstrut,"ORDEM")


dbSelectArea("SIX")
dbSetOrder(1)

For i:= 1 To Len(aSIX)
	If !Empty(aSIX[i,nPosIndice])
		If Empty(aSIX[i,nPosOrdem]) .And. !Empty(aSIX[i,nPosNick])
			While dbSeek(aSIX[i,nPosIndice]+cLastIdx)
				If aSIX[i,nPosNick]== SIX->(NICKNAME)
					Exit
				Else
					cLastIdx := Soma1(cLastIdx,1)
				EndIf
			End
			aSIX[i,nPosOrdem] := cLastIdx
		EndIf
		If !dbSeek(aSIX[i,nPosIndice]+aSIX[i,nPosOrdem])
			lNew:= .T.
		Else
			lNew:= .F.
		EndIf

		aAdd(aArqUpd,aSIX[i,1])
		lSIX := .T.
		If !(aSIX[i,1]$cAlias)
			cAlias += aSIX[i,1]+"/"
		EndIf

		RecLock("SIX",lNew)
		For j:=1 To Len(aSIX[i])
			If FieldPos(aEstrut[j])>0
				FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
			EndIf
		Next j
		dbCommit()
		MsUnLock()
	EndIf
Next i


If lSIX
	cTexto += "Indices atualizados  : "+cAlias+ CRLF
EndIf

EndIf

Return cTexto


Static Function AtuHelp()
//INDICE ORDEM CHAVE DESCRICAO DESCSPA DESCENG PROPRI F3 NICKNAME
Local cTexto 	:= ''

Local aHelp := {}
Private cHelps	:= ''

TplReadHlp("\SIGAADV.HLP",aHelp,"P",2)
TplReadHlp("\SIGAADV.HLS",aHelp,"S",2)

//----------------------------------------------------------------
//atualiza arquivos de help do protheus
//----------------------------------------------------------------
For ni := 1 To Len(aHelp)
	PutHelp(aHelp[ni][1],aHelp[ni][2],aHelp[ni][3],aHelp[ni][4],.T.,"TEMPLATE")
	cHelps += Substr(aHelp[ni][1],2)+"/"
Next


cTexto += "Helps atualizados  : "+cHelps+ CRLF


Return cTexto


Static Function AtuSX1()

Local aSX1   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX1	 := .F.
Local cTexto := ''
Local nPosGrupo
Local nPosOrdem

If !Empty(aAtuSX1)
aEstrut		:= aAtuSX1[1]
aSX1			:= aAtuSX1[2]
nPosGrupo	:= aScan(aEstrut,"X1_GRUPO")
nPosOrdem	:= aScan(aEstrut,"X1_ORDEM")


dbSelectArea("SX1")
dbSetOrder(1)
For i:= 1 To Len(aSX1)
	If !Empty(aSX1[i][1])
		If !dbSeek(aSX1[i,nPosGrupo]+aSX1[i,nPosOrdem])
			RecLock("SX1",.T.)
		Else
			RecLock("SX1",.F.)
		EndIf
		lSX1 := .T.

		For j:=1 To Len(aSX1[i])
			If !Empty(FieldName(FieldPos(aEstrut[j])))
				FieldPut(FieldPos(aEstrut[j]),aSX1[i,j])
			EndIf
		Next j

		dbCommit()
		MsUnLock()
	EndIf
Next i

If lSX1
	cTexto += "Incluidas novas perguntas no SX1."+ CRLF
EndIf

EndIf

Return cTexto



Static Function AtuSX2()
//X2_CHAVE X2_PATH X2_ARQUIVOC,X2_NOME,X2_NOMESPAC X2_NOMEENGC X2_DELET X2_MODO X2_TTS X2_ROTINA
Local aSX2   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local lSX2	 := .F.
Local cAlias := ''
Local cPath
Local cNome
Local nPosChave

If !Empty(aAtuSX2)
aEstrut		:= aAtuSX2[1]
aSX2			:= aAtuSX2[2]
nPosChave	:= aScan(aEstrut,"X2_CHAVE")


dbSelectArea("SX2")
dbSetOrder(1)
dbSeek("SA1")
cPath := SX2->X2_PATH
cNome := Substr(SX2->X2_ARQUIVO,4,5)

For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])
		If !dbSeek(aSX2[i,nPosChave])
			RecLock("SX2",.T.)
		Else
			RecLock("SX2",.F.)
		EndIf
		lSX2	:= .T.
		If !(aSX2[i,1]$cAlias)
			cAlias += aSX2[i,nPosChave]+"/"
		EndIf
		For j:=1 To Len(aSX2[i])
			If FieldPos(aEstrut[j]) > 0
				FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
			EndIf
		Next j
		SX2->X2_PATH    := cPath
		SX2->X2_ARQUIVO := aSX2[i,nPosChave]+cNome
		dbCommit()
		MsUnLock()
	EndIf
Next i
EndIf

Return cTexto



Static Function AtuSX3()
//	X3_ARQUIVO X3_ORDEM   X3_CAMPO   X3_TIPO    X3_TAMANHO X3_DECIMAL X3_TITULO  X3_TITSPA  X3_TITENG
//  X3_DESCRIC X3_DESCSPA X3_DESCENG X3_PICTURE X3_VALID   X3_USADO   X3_RELACAO X3_F3      X3_NIVEL
//  X3_RESERV  X3_CHECK   X3_TRIGGER X3_PROPRI  X3_BROWSE  X3_VISUAL  X3_CONTEXT X3_OBRIGAT X3_VLDUSER
//  X3_CBOX    X3_CBOXSPA X3_CBOXENG X3_PICTVAR X3_WHEN    X3_INIBRW  X3_GRPSXG  X3_FOLDER

Local aSX3   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX3	 := .F.
Local cTexto := ''
Local cAlias := ''

If !Empty(aAtuSX3)
aEstrut		:= aAtuSX3[1]
aSX3			:= aAtuSX3[2]
nPosArquivo	:= aScan(aEstrut,"X3_ARQUIVO")
nPosCampo	:= aScan(aEstrut,"X3_CAMPO")



dbSelectArea("SX3")
dbSetOrder(2)

For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][nPosArquivo])
		If !dbSeek(aSX3[i,nPosCampo])
			RecLock("SX3",.T.)
		Else
			RecLock("SX3",.F.)
		EndIf
		lSX3	:= .T.
		If !(aSX3[i,nPosArquivo]$cAlias)
			cAlias += aSX3[i,nPosArquivo]+"/"
			aAdd(aArqUpd,aSX3[i,nPosArquivo])
		EndIf
		For j:=1 To Len(aSX3[i])
			If FieldPos(aEstrut[j])>0
				FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
			EndIf
		Next j
		dbCommit()
		MsUnLock()
	EndIf
Next i

If lSX3
	cTexto := 'Tabelas atualizadas : '+cAlias+ CRLF
EndIf

EndIf
Return cTexto



Static Function AtuSX5()
//  "X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"

Local aSX5   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX5	 := .F.

If !Empty(aAtuSX5)
aEstrut		:= aAtuSX5[1]
aSX5			:= aAtuSX5[2]



dbSelectArea("SX5")
dbSetOrder(1)
For i:= 1 To Len(aSX5)
	If !Empty(aSX5[i][2])
		If !dbSeek(aSX5[i,1]+aSX5[i,2]+aSX5[i,3])
			lSX5	:= .T.
			RecLock("SX5",.T.)

			For j:=1 To Len(aSX5[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX5[i,j])
				EndIf
			Next j

			dbCommit()
			MsUnLock()
		EndIf
	EndIf
Next i

EndIf

Return(.T.)



Static Function AtuSX6()
//  X6_FIL   X6_VAR     X6_TIPO    X6_DESCRIC X6_DSCSPA  X6_DSCENG  X6_DESC1 X6_DSCSPA1 X6_DSCENG1
//  X6_DESC2 X6_DSCSPA2 X6_DSCENG2 X6_CONTEUD X6_CONTSPA X6_CONTENG X6_PROPRI

Local aSX6   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX6	 := .F.
Local cTexto := ''
Local cAlias := ''

If !Empty(aAtuSX6)
aEstrut		:= aAtuSX6[1]
aSX6			:= aAtuSX6[2]



dbSelectArea("SX6")
dbSetOrder(1)
For i:= 1 To Len(aSX6)
	If !Empty(aSX6[i][2])
		If !dbSeek(aSX6[i,1]+aSX6[i,2])
			lSX6	:= .T.
			If !(aSX6[i,2]$cAlias)
				cAlias += aSX6[i,2]+"/"
			EndIf
			RecLock("SX6",.T.)
			For j:=1 To Len(aSX6[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX6[i,j])
				EndIf
			Next j

			dbCommit()
			MsUnLock()
		EndIf
	EndIf
Next i

If lSX6
	cTexto := 'Incluidos novos parametros. Verifique as suas configuracoes e funcionalidades : '+cAlias+ CRLF
EndIf

EndIf

Return cTexto



Static Function AtuSX7()
//  X7_CAMPO X7_SEQUENC X7_REGRA X7_CDOMIN X7_TIPO X7_SEEK X7_ALIAS X7_ORDEM X7_CHAVE X7_PROPRI X7_CONDIC

Local aSX7    := {}
Local cTexto := ""
Local cGatilhos := ""
Local aEstrut := {}
Local i       := 0
Local j       := 0

If !Empty(aAtuSX7)
	aEstrut		:= aAtuSX7[1]
	aSX7			:= aAtuSX7[2]



	dbSelectArea("SX7")
	dbSetOrder(1)
	For i:= 1 To Len(aSX7)
		If !Empty(aSX7[i][1])
			If !dbSeek(PadR(aSX7[i,1],Len(SX7->X7_CAMPO))+PadR(aSX7[i,2],Len(SX7->X7_SEQUENC)))
				RecLock("SX7",.T.)
			Else
				RecLock("SX7",.F.)
			EndIf

			For j:=1 To Len(aSX7[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX7[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			dbSelectArea("SX3")
			dbSetOrder(2)
			cGatilhos += SX7->X7_CAMPO+"/"
			If dbSeek(SX7->X7_CAMPO)
				RecLock("SX3",.F.)
				SX3->X3_TRIGGER := "S"
				MsUnlock()
			EndIf
		EndIf
	Next i

	If !Empty(cGatilhos)
		cTexto := "Gatilhos atualizados : "+cGatilhos
	EndIf

EndIf
Return cTexto


Static Function AtuSXA()
//"XA_ALIAS","XA_ORDEM","XA_DESCRIC","XA_DESCSPA","XA_DESCENG","XA_PROPRI"

Local aSXA   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0

If !Empty(aAtuSXA)

aEstrut		:= aAtuSXA[1]
aSXA			:= aAtuSXA[2]


dbSelectArea("SXA")
dbSetOrder(1)
For i:= 1 To Len(aSXA)
	If !Empty(aSXA[i][1])
		If !dbSeek(aSXA[i,1]+aSXA[i,2])
			RecLock("SXA",.T.)
			For j:=1 To Len(aSXA[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXA[i,j])
				EndIf
			Next j

			dbCommit()
			MsUnLock()
		EndIf
	EndIf
Next i

EndIf

Return(.T.)


Static Function AtuSXB()
//  XB_ALIAS XB_TIPO XB_SEQ XB_COLUNA XB_DESCRI XB_DESCSPA XB_DESCENG XB_CONTEM

Local aSXB   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0

If !Empty(aAtuSXB)
aEstrut		:= aAtuSXB[1]
aSXB			:= aAtuSXB[2]


dbSelectArea("SXB")
dbSetOrder(1) // XB_ALIAS + XB_TIPO + XB_SEQ + XB_COLUNA
For i:= 1 To Len(aSXB)
	If !Empty(Padr(aSXB[i][1],Len(SXB->XB_ALIAS)))
		If !dbSeek(Padr(aSXB[i,1],Len(SXB->XB_ALIAS))+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])
			RecLock("SXB",.T.)

			For j:=1 To Len(aSXB[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
				EndIf
			Next j

			dbCommit()
			MsUnLock()
		EndIf
	EndIf
Next i

EndIf

Return(.T.)


User Function SIGACFG()

SetKey( VK_F9 , { || __Execute("U_ToolsMP8()","xxxxxxx","ToolsMP8",) } )

Return


Static Function TplReadHlp(cTplFile,aHelps,cKey,nHlp)
Local nHdl
Local ni
Local nj
Local xNumEnt
Local cAux
Local cLook
Local nPos
Local nDiff := 0

nHdl := Fopen(cTplFile,0)
If nHdl < 0
	Return .F.
EndIf

xNumEnt := Space(2)
FSEEK(nHdl,-2,2)
FREAD(nHdl,@xNumEnt,2)
//If Asc(Subs(xNumEnt,2,1)) == 0
//	nDiff := 1
//	FSEEK(nHdl,-3,2)
//	FREAD(nHdl,@xNumEnt,2)
//EndIf
xNumEnt := Bin2I(xNumEnt)
FSEEK(nHdl,(-10*xNumEnt)-2-nDiff,2)
cAux := Space(10*xNumEnt)
Fread(nHdl,@cAux,Len(cAux))
For ni:= 1 to xNumEnt
	cLook := Subs(cAux,((ni-1)*10) + 1,10)
	cBuffer := Space(200)
	FSeek(nHdl,(ni-1)*200,0)
	FRead(nHdl,@cBuffer,200)

	nPos := Ascan(aHelps,{|x| x[1] == cKey+cLook})
	If nPos == 0
		AADD(aHelps,{cKey+cLook,{},{},{}})
		nPos := Len(aHelps)
	EndIf

	cBuffer := Strtran(cBuffer,CHR(198),"„") // Troca Æ por "„"
	aHelps[nPos][nHlp] := {}
	For nj := 0 To 4
		AADD(aHelps[nPos][nHlp],OemToAnsi(Subs(cBuffer,(40*nj)+1,40)))
	Next
Next
FClose(nHdl)
Return .T.




User Function BenchMark()


Local oDlg
Local oGraphic
Local aArea		:= GetArea()
Local cAlias
Local nRecView
Local nStep
Local dx
Local nSerie
Local cTexto
Local aSize     := {}
Local aPosObj   := {}
Local aObjects  := {}
Local aInfo     := {}
Local aView		:= {}
Local aView2    := {}
Local aConfig := {}
Local aTpGrafico:= { {"1" , 1}; //"1=Linha"
					,{"2" , 2}; //"2=Area"
					,{"3" , 3}; //"3=Pontos"
					,{"4" , 4}; //"4=Barra"
					,{"5" ,12}} //"5=Linha Rapida"
Local nPosTpGraf := 0
Local nTipoGraf  := 0
Local aAlltasks	:=	{}
Local aAllEDT	:=	{}
Local nY

nTipoGraf := 1

If ParamBox({	{1,"Tempo de Refresh",30,"@E 999s","","","",20 ,.T. } },"Parametros",aConfig,,,,,, , , .F.)

	aSize := MsAdvSize(,.F.,400)
	aObjects := {}

	AAdd( aObjects, { 100, 100 , .T., .T. } )

	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 2, 2 }
	aPosObj := MsObjSize( aInfo, aObjects, .T. )

	DEFINE MSDIALOG oDlg TITLE "Protheus performance BenchMark 1.0" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL


	oFolder := TFolder():New(aPosObj[1,1],aPosObj[1,2],{"Grafico"},{},oDlg,,,, .T., .F.,aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1]) //### //"Planilha de Valores"###"Representacao Grafica"

	@ 2,2 MSGRAPHIC oGraphic SIZE aPosObj[1,4]-10,aPosObj[1,3]-aPosObj[1,1]-30 OF oFolder:aDialogs[1]

	oGraphic:SetMargins( 15, 15, 15,15 )
	oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )
	oGraphic:SetTitle( "", "" , CLR_BLACK , A_LEFTJUST , GRP_TITLE )
	oGraphic:SetLegenProp( GRP_SCRRIGHT, CLR_WHITE, GRP_SERIES, .T. )
	nSerie	:= oGraphic:CreateSerie( nTipoGraf ,"Abertura de tabelas")
	nSerie2	:= oGraphic:CreateSerie( nTipoGraf ,"Processamento Lógico")
	nSerie3	:= oGraphic:CreateSerie( nTipoGraf ,"Leitura de Dados")
	oGraphic:Add(nSerie,0,Substr(Time(),1,5),CLR_HGREEN)
	oGraphic:Add(nSerie2,0,"Processamento Lógico",CLR_HBLUE)
	oGraphic:Add(nSerie3,0,"Leitura de Dados",CLR_BLACK)
	tTimer := TTimer():New(aConfig[1]*1000, {|| U_bhkOpen(nSerie,nSerie2,nSerie3,@oGraphic),U_bhkOpen(nSerie,nSerie2,nSerie3,@oGraphic),U_bhkOpen(nSerie,nSerie2,nSerie3,@oGraphic),U_bhkOpen(nSerie,nSerie2,nSerie3,@oGraphic) },oDlg)
//	U_ChkOpen(nSerie,nSerie2,nSerie3,@oGraphic)

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT (tTimer:Activate(),U_bhkOpen(nSerie,nSerie2,nSerie3,@oGraphic))
EndIf

RestArea(aArea)
Return


User Function bhkOpen(nSerie,nSerie2,nSerie3,oGraphic)

Local nTime
Local nx
Local ny := 0


Time := Seconds()
dbSelectArea("SE2")
dbCloseArea()
dbSelectArea("SE2")
dbSetOrder(1)
dbSeek(xFilial()+"ss")

nTime := Seconds()
dbSelectArea("SA1")
dbCloseArea()
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial()+"ss")

nTime := Seconds()
dbSelectArea("SB1")
dbCloseArea()
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial()+"ss")


If SE2->E2_TIPO <> "20292"
	nTime := Seconds()-nTime
EndIf


oGraphic:Add(nSerie,NoRound(nTime*100,0),Substr(Time(),1,5),CLR_HGREEN)

nTime := Seconds()
dbSelectArea("SE2")
dbGotop()
dbSetOrder(1)
dbSeek(xFilial())
For nx := 1 to 50
	SE2->(dbSkip())
	dbGotop()
	dbSeek("29399")
	If !Eof()
		nY++
	EndIf
Next nx

nTime := Seconds()-nTime
oGraphic:Add(nSerie3,NoRound(nTime*100,0),"Leitura de Dados",CLR_BLACK)

nTime := Seconds()
g := 20
For nx := 1 to 14000
	g++
	Do Case
		Case nx == 2
			g--
		Case nx == 3
			g++
	EndCase
	ny := 1
	aRRayC := {}
	While ny < 3
		aAdd(aRRayC,{"",299,200,{"1.1",1,.T.}})
		ny++
	End
Next nx
nTime := Seconds()-nTime

oGraphic:Add(nSerie2,NoRound(nTime*100,0),"Processamento Lógico",CLR_HBLUE)

Return


