#INCLUDE "MSOLE.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "rwmake.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEFR014   ºAutora ³Viviane Marta       º Data ³  10/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Emissao das Cotacoes,integracao com o word.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±   
±±ºPrograma  ³GEFR014   ºAutora ³Rosilene Pontes     º Data ³  01/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³ Limpado a sequencia de itens na segunda folha e acertado   º±±
±±º          ³ erro na observacao, local de entrega e cobranca.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8-COMPRAS                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*------------------------------------------------------*
User Function GEFR014(cNumCota)
*------------------------------------------------------*


STATIC aTamSXG, aTamSXG2
PRIVATE wnrel
PRIVATE cDesc1		:="Emissao das cotacoes de compras"
PRIVATE cDesc2		:=""
PRIVATE cDesc3		:=" "
PRIVATE Tamanho		:="M"
PRIVATE cTel   		:=""
PRIVATE cEndEnt		:=""
PRIVATE cEmail 		:=""
PRIVATE titulo		:="Relacao de Cotacoes"
PRIVATE aReturn 	:= { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog	:="GEFR014",nLastKey := 0
PRIVATE cString 	:="SC8"
PRIVATE cObs01	:= ""

PRIVATE cNumero  	:= ""
PRIVATE cFornece 	:= ""
PRIVATE cLoja    	:= ""
PRIVATE cDescri  	:= ""
PRIVATE cDescG   	:= ""
PRIVATE cabec1   	:= ""
PRIVATE cabec2   	:= ""
PRIVATE cabec3   	:= ""
PRIVATE cContato 	:= ""
PRIVATE cObs01   	:= ""
PRIVATE cObs02   	:= ""
PRIVATE cObs03   	:= ""
PRIVATE cObs04   	:= ""
PRIVATE cVar     	:= ""
PRIVATE cbCont   	:= 0
PRIVATE nItem    	:= 0
PRIVATE nLinObs  	:= 0
PRIVATE dEmissao
PRIVATE cCaminho
PRIVATE nVias    	:= 1
PRIVATE aRadio		:= {"Imprime  ","Salva  "}
//PRIVATE nRadio		:= 2
PRIVATE nRadio		:= 3
PRIVATE aVetor    	:= {}
Private lFlaItem := .F. //Rosilene

cPerg  :="GEFR14"
wnrel  := "MATR150"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01	     	  Do Numero                                 ³
//³ mv_par02	     	  Ate o Numero 		                       ³
//³ mv_par03	     	  Do Fornecedor                             ³
//³ mv_par04              Ate o Fornecedor            	        ³
//³ mv_par05              Ate a data de validade      	   	  ³
//³ mv_par06              Campo Descricao do Produto             ³
//³ mv_par07              Endrre‡o Fiscal                        ³
//³ mv_par08              Cidade - Estado                        ³
//³ mv_par09              Fax                                    ³
//³ mv_par10              Qual Unidade de Medida ?               ³
//³ mv_par11              Telefone                               ³
//³ mv_par12              Endereco de Entrega ?                  ³
//³ mv_par13              Endereco de e-mail  ?                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cNumCota == Nil
	AjustaSx1("GEFR14")
	pergunte("GEFR14",.F.)
Else
	AjustaSx1("MR150A")
	cPerg := "MR150A"
	Pergunte("MR150A",.F.)
EndIf

// Verifica conteudo da variavel static p/ Grupo Fornec. (001) e Loja (002)
aTamSXG  := If(aTamSXG  == NIL, TamSXG("001"), aTamSXG)
aTamSXG2 := If(aTamSXG2 == NIL, TamSXG("002"), aTamSXG2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRadio:= {"Imprime  ","Salva  ","Envia E-mail"}
nRadio:= 3

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o do Mapa de Cotacao")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo WORD, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario.                              "
@ 30,010 TO 080,190 TITLE " Selecione: "
@ 45,018 RADIO aRadio VAR nRadio

@ 70,100 BMPBUTTON TYPE 01 ACTION OkGeraTxt(cNumCota)
@ 70,128 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autora³ Viviane Marta      º Data ³  10/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*----------------------------------------------*
Static Function OkGeraTxt(cNumCota)
*----------------------------------------------*

cCaminho := AllTrim(Mv_par14)

// Seleciona Arquivo Modelo
// Inicia o Word

If !File("\MODELO\COTACAO.dot")
   Alert("Arquivo modelo (cotacao.dot) nao Encontrado! Favor comunicar o administrador do Sistema.")
   Return
Endif

If !File("\DOC")
   Alert("Nao Existe a pasta DOC no servidor! Favor comunicar o administrador do Sistema.")
   Return
Endif

If !File(IIF(Right(cCaminho,1)=="\", SubStr(cCaminho,1,Len(cCaminho)-1), cCaminho))
   Alert("Diretório nao Encontrado! Favor digitar o Diretorio correto.")
   Return
Endif

If Right(cCaminho,1)<>"\"
	cCaminho += "\"
EndIf	

If !File("\DOC\COTACAO.DOT")
	COPY FILE "\MODELO\COTACAO.dot" TO "\DOC\COTACAO.dot"
EndIf	

If !File(cCaminho+"COTACAO.DOT")
	CpyS2T("\MODELO\COTACAO.dot", cCaminho)
EndIf	

/*
If !File(Alltrim(cCaminho)+"\COTACAO.dot")
	Alert("Arquivo nao Encontrado! Favor digitar Diretorio correto.")
	Return
Endif
*/

cArquivo := Alltrim(cCaminho)+"COTACAO.dot"  // Caminho
// Inicializa o Ole com o MS-Word 97 ( 8.0 )
oWord := OLE_CreateLink('TMsOleWord97')
OLE_SetProperty( oWord, oleWdPrintBack, .T. )
OLE_SetProperty( oWord, oleWdVisible,   .T. )
OLE_NewFile(oWord,cArquivo)

If !Empty(cNumCota)
	cEmail       := mv_par09
	cEndEnt      := mv_par08
	cTel         := mv_par07
	nSegundaUnid := mv_par06		// Grupo MR150A
	mv_par09     := mv_par05
	mv_par08     := mv_par04
	mv_par07     := mv_par03
	mv_par06     := mv_par02
	mv_par05     := mv_par01
	nomeprog     := "MATA130"
	mv_par01     := cNumCota
	mv_par02     := cNumCota
	mv_par03     := "      "
	mv_par04     := "ZZZZZZ"
Else
	nSegundaUnid := mv_par10
	cTel         := mv_par11		// Grupo MR150A
	cEndEnt      := mv_par12
	cEmail       := mv_par13
	
EndIf
cObs01 := ""
RptStatus({|lEnd| R150Imp(@lEnd,wnrel,cString,@cTel,cEndEnt,cEmail,cObs01)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R150IMP  ³ Autora³Viviane Marta          ³ Data ³ 10.05.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GEFCO                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------------------------------*
Static Function R150Imp(lEnd,wnrel,cString,cTel,cEndEnt,cEmail,cObs01)
*------------------------------------------------------------*

cNumero  := ""
cFornece := ""
cLoja    := ""
cDescri  := ""
cabec1   := ""
cabec2   := ""
cabec3   := ""
cContato := ""
cObs01   := ""
cObs02   := ""
cObs03   := ""
cObs04   := ""
cVar     := ""
cbCont   := 0
nItem    := 0
nLinObs  := 0
limite   := 132
li       := 80
m_pag    := 1
nPag     := 0
c_Mail   := space(40)
cItemAnt  := ""  //Rosilene
cItemProx := ""  //Rosilene
nItemAnt := 0 //Rosilene


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa Numero da Cotacao                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC8")
dbSetOrder(1)
Set SoftSeek On
dbSeek(xFilial()+mv_par01)
Set SoftSeek Off

SetRegua(RecCount())

While xFilial() = SC8->C8_FILIAL .And. SC8->C8_NUM >= mv_par01 .And. SC8->C8_NUM <= mv_par02 .And. !Eof()
	
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Fornecedor                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF SC8->C8_FORNECE < mv_par03 .OR. SC8->C8_FORNECE > mv_par04
		dbSkip()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Data de Validade ou se ja tem pedido feito          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF SC8->C8_VALIDA > mv_par05 .OR. !Empty(SC8->C8_NUMPED)
		dbSkip()
		Loop
	Endif
	
	cContato := SC8->C8_CONTATO
	dEmissao := SC8->C8_EMISSAO
	
	
	ImpCabec() // Cabecalho
	
	dbSelectArea("SA2")
	dbSeek(xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA)
	c_Mail := SA2->A2_EMAIL
	
	dbSelectArea("SC8")
	
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "
	nLinObs  := 0
	nItens   := 0
	nItensc  := 0
	limite := 10
	nVias    := 1
	
	
	While !Eof() .And. SC8->C8_NUM == cNumero .And. cFornece == SC8->C8_FORNECE .And. SC8->C8_LOJA == cLoja
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicializacao da Observacao da Cotacao                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !EMPTY(SC8->C8_OBS) .And. nLinObs < 5
			nLinObs++
			cVar:="cObs"+StrZero(nLinObs,2)
			Eval(MemVarBlock(cVar),SC8->C8_OBS)   
			OLE_SetDocumentVar(oWord,"COBS01",cObs01)       
			
			
		Else
			OLE_SetDocumentVar(oWord,"COBS01"," ")
			
		Endif
		
		nItensc++
		
		If nItensc = limite+1
			
			
			limite += 10
			OLE_SetDocumentVar(oWord,"CONTINUA"," Continua ...")
			If nLinObs > 0
				OLE_SetDocumentVar(oWord,"COBS01",cObs01)
			Else
				OLE_SetDocumentVar(oWord,"COBS01"," ")
				
			Endif
			//--Atualiza Variaveis
			OLE_UpDateFields(oWord)
			//-- Imprime as variaveis
			If nRadio = 1
				OLE_SetProperty( oWord, '208', .F. ) ; OLE_PrintFile( oWord, "ALL",,, 1 )
				//       OLE_SaveAsFile(oWord,Alltrim(cCaminho)+"\"+cNumero+cFornece+Str(nVias,1)+".doc")
			ElseIf nRadio = 2 // Salva em arquivo
				OLE_SaveAsFile(oWord,Alltrim(cCaminho)+"\"+cNumero+"-"+cFornece+"-"+Str(nVias,1)+".doc")
			Else         // Envia E-mail
				OLE_SaveAsFile(oWord,Alltrim(cCaminho)+"\"+cNumero+"-"+cFornece+"-"+Str(nVias,1)+".doc")
				// cDoc := "\DOC\" + cNumero+"-"+cFornece+"-"+Str(nVias,1)+".doc"
				cDoc := cCaminho + cNumero+"-"+cFornece+"-"+Str(nVias,1)+".doc"				
				aadd(aVetor,{cDoc,c_Mail})
				//				U_fmail(cDoc,cNumero)
				// U_fmail(aVetor,cNumero,c_Mail)
				
			Endif
			
			*----------------------------------------------------------------------------*
			*Rosilene-01/08/07-Acrescentado para zerar as variaveis para a segunda folha em diante *
			*----------------------------------------------------------------------------*
			For b:=1 to 10
				OLE_SetDocumentVar(oWord,("ITEM"+Strzero(b,2)) ," ") 
				OLE_SetDocumentVar(oWord,("CC"+Strzero(b,2))   ," ")
				OLE_SetDocumentVar(oWord,("DESCP"+Strzero(b,2))," ")
				OLE_SetDocumentVar(oWord,("QTD"+Strzero(b,2))  ," ")
				OLE_SetDocumentVar(oWord,("UM"+Strzero(b,2))   ," ")
				OLE_SetDocumentVar(oWord,("PENT"+Strzero(b,2)) ," ")
			Next b
			*----------------------------------------------------------------------------*
			
			nVias++         //Numero de Vias
			ImpCabec() // Cabecalho
		Endif
		
		
		
		IncRegua()
		
		If nItensc > 10
			nItens :=Val(Substr(Str(nItensc,2),2))  //retorna a 1
			If nItens = 0
				nItens :=10
			Endif
			
			
		Else
			nItens :=nItensC
		Endif                
		
		
		OLE_SetDocumentVar(oWord,("ITEM"+Strzero(nItens,2)),Transform(SC8->C8_ITEM,PesqPict("SC8","c8_item")))
		OLE_SetDocumentVar(oWord,("CC"+Strzero(nItens,2)),POSICIONE("SC1",1,xFilial("SC1")+SC8->C8_NUMSC+SC8->C8_ITEMSC,"C1_CC"))
		cDescg := Alltrim(SC8->C8_PRODUTO)+"-"+ImpDescr(1)
		
		
		n:=0
		If Len(cDescG) > 60
			For i:=1 to Len(cDescG) Step 60
				***************************
				i:=n+1
				If i= 1
					If Substr(cDescG,60,1) = " " .or. Substr(cDescG,46,1) = " "
						
						OLE_SetDocumentVar(oWord,("DESCP"+Strzero(nItens,2)),Substr(cDescG,i,60) )
						n += 60
						
					Else
						_Descri := Substr(cDescG,i,60)
						_Desc   := Substr(cDescG,i,60)
						y:=0
						For j:=1 to Len(_Descri)
							nSpace := AT(" ",_Desc)
							If nSpace < Len(_Descri) .and. nSpace != 0
								y+=nSpace
							Elseif nSpace = 0
								j := Len(_Descri)+1
							Endif
							_Desc:= Substr(_Desc,nSpace+1)
							j+=(nSpace-1)
						Next
						
						OLE_SetDocumentVar(oWord,("DESCP"+Strzero(nItens,2)),Substr(_Descri,1,y))
						n += Len(Substr(_Descri,1,y))
					Endif
					
				Else
					
					If Substr(cDescG,60+i,1) = " " .or. Substr(cDescG,44+i,1) = " " .or. 60+i >= Len(cDescG)
						
						OLE_SetDocumentVar(oWord,("DESCP"+Strzero(nItens,2)),Substr(cDescG,i,60) )
						n += 60
						
					Else
						_Descri := Substr(cDescG,i,60)
						_Desc   := Substr(cDescG,i,60)
						y:=0
						For j:=1 to Len(_Descri)
							nSpace := AT(" ",_Desc)
							If nSpace < Len(_Descri) .and. nSpace != 0
								y+=nSpace
							Elseif nSpace = 0
								j := Len(_Descri)+1
							Endif
							_Desc:= Substr(_Desc,nSpace+1)
							j+=(nSpace-1)
						Next
						
						OLE_SetDocumentVar(oWord,("DESCP"+Strzero(nItens,2)),Substr(_Descri,1,y))
						n += Len(Substr(_Descri,1,y))
						
					Endif
				Endif
				***************************
				
				If i = 1
					ImpValores(1)    // Chamada da Rotina de Valores
					
				Else
					OLE_SetDocumentVar(oWord,("ITEM"+Strzero(nItens,2))," ")
					OLE_SetDocumentVar(oWord,("CC"+Strzero(nItens,2))   ," ") //					
					ImpValores(2)    // Chamada da Rotina de Valores
					
				Endif
				nItensC++
				If nItensc > 10
					nItens :=Val(Substr(Str(nItensc,2),2))
					If nItens = 0
						nItens :=10
					Endif
					
				Else
					nItens :=nItensC
				Endif
			Next
			nItensC--
		Else
			
			OLE_SetDocumentVar(oWord,("DESCP"+Strzero(nItens,2)),cDescG)
			ImpValores(1)    // Chamada da Rotina de Valores
			
		Endif
		
		cFilEnt := SC8->C8_FILENT
		
		If !EMPTY(SC8->C8_OBS) .And. nLinObs < 5
			nLinObs++
			cVar:="cObs"+StrZero(nLinObs,2)
			Eval(MemVarBlock(cVar),SC8->C8_OBS)  
			OLE_SetDocumentVar(oWord,"COBS01",cObs01)
			
		Else
			OLE_SetDocumentVar(oWord,"COBS01"," ")
		Endif
		*-------------------------------------------------------------------------------------*
		*Rosilene Pontes-01/08/07-Incluso para gerar informacao nas variaveis do rodape na primeira folha*
		*-------------------------------------------------------------------------------------*
		OLE_SetDocumentVar(oWord,"COBS01",cObs01)
		
		If Empty(cEndEnt)
			OLE_SetDocumentVar(oWord,"ENDENT",IIf( Empty(SM0->M0_ENDENT), " O mesmo ", SM0->M0_ENDENT ))
		Else
			OLE_SetDocumentVar(oWord,"ENDENT",cEndEnt)
			
		EndIf
		
		OLE_SetDocumentVar(oWord,"ENDCOB",Iif(Empty(SM0->M0_ENDCOB),Iif(Empty(SM0->M0_ENDENT),"O mesmo",SM0->M0_ENDENT),SM0->M0_ENDCOB))
		
		OLE_SetDocumentVar(oWord,"DTEMISSR",dEmissao)
		
		*-------------------------------------------------------------------------------------*
		
		dbSelectArea("SC8")
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lC8FilEnt := .F.
	If SC8->(Eof()) .Or. (cFilEnt != SC8->C8_FILENT .and. !Empty(SC8->C8_FILENT))
		dbSkip(-1)        // Para ter Certeza que nao e Eof() ou trocou a filial
		lC8FilEnt := .T.  // de Entrega
	Endif
	
	dbSelectArea("SM0")
	dbSetOrder(1)   && forca o indice na ordem certa
	nRegistro := Recno()
	dbSeek(SUBS(cNumEmp,1,2)+SC8->C8_FILENT)
	
	If lC8FilEnt .and. !SC8->(Eof())
		SC8->(dbSkip())
	Endif
	
	
	If nLinObs > 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicializar campos de Observacoes.                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		
		If Empty(cObs02)
			If Len(cObs01) > 50
				cObs 	:= cObs01
				cObs01:= Substr(cObs,1,50)
				For nX := 2 To 4
					cVar  := "cObs"+StrZero(nX,2)
					&cVar := Substr(cObs,(50*(nX-1))+1,50)
				Next
			EndIf
			OLE_SetDocumentVar(oWord,("COBS01"," "))
			
		Else
			cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
			cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
			cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
			cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
			OLE_SetDocumentVar(oWord,"COBS01",cObs01)
		EndIf
	Else
		
		
		OLE_SetDocumentVar(oWord,"COBS01",cObs01) //GERA NA SEGUNDA FOLHA
		OLE_SetDocumentVar(oWord,"OBS02",cObs02)
		
	Endif
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializacao da Observacao da Cotacao                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	If !EMPTY(SC8->C8_OBS) .And. nLinObs < 5
		nLinObs++
		cVar:="cObs"+StrZero(nLinObs,2)
		Eval(MemVarBlock(cVar),SC8->C8_OBS)
		OLE_SetDocumentVar(oWord,"COBS01",cObs01)
	Else
		OLE_SetDocumentVar(oWord,("COBS01"," "))
		
	Endif
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o End de Entrega do SM0 somente quando cEndEnt  == " "     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Go nRegistro  // Mudado por Ricardo - Em:20/02/08 - Pois a filial de entrega não estava sendo preenchido e o usuário Marco informou que seria a Filial Solicitante
	If Empty(cEndEnt)
		OLE_SetDocumentVar(oWord,"ENDENT",IIf( Empty(SM0->M0_ENDENT), " O mesmo ", SM0->M0_ENDENT ))
	Else
		OLE_SetDocumentVar(oWord,"ENDENT",cEndEnt)
	EndIf
	
//	Go nRegistro
	dbSelectArea("SC8")
	OLE_SetDocumentVar(oWord,"ENDCOB",Iif(Empty(SM0->M0_ENDCOB),Iif(Empty(SM0->M0_ENDENT),"O mesmo",SM0->M0_ENDENT),SM0->M0_ENDCOB))
	
	OLE_SetDocumentVar(oWord,"DTEMISSR",dEmissao)
	
	If nItensc < limite
		
		For nItensc := nItensc+1 to limite
			If nItensc < 10
				nItens :=Val(Substr(Str(nItensc,2),2))
				If nItens = 0
					nItens :=10
				Endif
			Else
				nItens := nItensc
			Endif
			
			// Variaveis a serem usadas na Montagem do Documento no Word
			OLE_SetDocumentVar(oWord,("ITEM"+Strzero(nItens,2))," ")
			OLE_SetDocumentVar(oWord,("CC"+Strzero(nItens,2))   ," ")			//
			OLE_SetDocumentVar(oWord,("DESCP"+Strzero(nItens,2)),ImpDescr(2))
			ImpValores(2)    // Chamada da Rotina de Valores
			
			
		Next
	Endif
	
	*Final do while*
	
	OLE_SetDocumentVar(oWord,"CONTINUA"," ")
	
	If nLinObs > 0
		OLE_SetDocumentVar(oWord,"COBS01",cObs01)
	Else
		OLE_SetDocumentVar(oWord,"COBS01"," ")
		
	Endif
	
	//--Atualiza Variaveis
	OLE_UpDateFields(oWord)
	
	If nRadio = 1//-- Imprime as variaveis
		OLE_SetProperty( oWord, '208', .F. ) ; OLE_PrintFile( oWord, "ALL",,, 1 )
		
	ElseIf nRadio = 2 // Salva em arquivo
		OLE_SaveAsFile(oWord,Alltrim(cCaminho)+"\"+cNumero+"-"+cFornece+"-"+Str(nVias,1)+".doc")
	Else // Envia por e-mail
		OLE_SaveAsFile(oWord,Alltrim(cCaminho)+"\"+cNumero+"-"+cFornece+"-"+Str(nVias,1)+".doc")
		//OLE_SaveAsFile(oWord,"\DOC\"+cNumero+"-"+cFornece+"-"+Str(nVias,1)+".doc")
		cDoc := "\DOC\" + cNumero+"-"+cFornece+"-"+Str(nVias,1)+".doc"
		//cDoc := cCaminho + cNumero+"-"+cFornece+"-"+Str(nVias,1)+".doc"		
	   //CpyS2T("\DOC\" + cNumero+"-"+cFornece+"-"+Str(nVias,1)+".doc", cCaminho)
	   CpyT2S(cCaminho+ cNumero+"-"+cFornece+"-"+Str(nVias,1)+".doc", "\DOC")
		aadd(aVetor,{cDoc,c_Mail})

		//		U_fmail(cDoc,cNumero)
		// U_fmail(aVetor,cNumero,c_Mail)
		//	   aadd(aVetor,{cDoc})
	Endif
	nVias++   //Numero de Vias
	dbSelectArea("SC8")
	li := 80
	nPag := 0
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_CloseFile( oWord ) 			// Fecha o Documento

OLE_CloseLink( oWord ) 			// Fecha o Link Documento

dbSelectArea("SC8")
Set Filter To
dbSetOrder(1)

dbSelectArea("SA5")
dbSetOrder(1)

//U_fmail(aVetor,cNumero,c_Mail) 
If nRadio == 3 .and. nVias > 1
	U_fmail(aVetor,cNumero)
Endif

If nVias > 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se em disco, desvia para Spool                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aReturn[5] = 1    // Se Saida para disco, ativa SPOOL
		Set Printer To
		Commit
		OurSpool(wnrel)
	Endif
Else
	Alert("Nenhum documento gerado.")	
EndIf	
MS_FLUSH()

Return

*-----------------------------------------------------------------
Static Function ImpCabec()
*-----------------------------------------------------------------*
Local _cAlias := Alias()
Private c_Mail := space(40)
nPag ++

OLE_SetDocumentVar(oWord,"COTACAO",SC8->C8_NUM +"/"+SC8->C8_ITEM)
OLE_SetDocumentVar(oWord,"VENCTO" ,DTOC(SC8->C8_VALIDA))
OLE_SetDocumentVar(oWord,"NUM_PAG",STRZERO(nPag,4))
dbSelectArea("SA2")
dbSeek(xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA)
c_Mail := SA2->A2_EMAIL
If aTamSXG[1] != aTamSXG[3]
	
	OLE_SetDocumentVar(oWord,"CODFOR",SA2->A2_COD+"/"+SA2->A2_LOJA)
	OLE_SetDocumentVar(oWord,"NOMFOR",Alltrim(SubStr(SA2->A2_NOME,1,25)))
Else
	
	OLE_SetDocumentVar(oWord,"CODFOR",SA2->A2_COD+"/"+SA2->A2_LOJA)
	OLE_SetDocumentVar(oWord,"NOMFOR",Alltrim(SubStr(SA2->A2_NOME,1,25)))
Endif
OLE_SetDocumentVar(oWord,"END_FOR",Alltrim(SA2->A2_END))
OLE_SetDocumentVar(oWord,"MUN_FOR",Alltrim(SA2->A2_BAIRRO))
OLE_SetDocumentVar(oWord,"TEL_FOR","("+A2_DDD+")"+Substr(SA2->A2_TEL,1,15))
OLE_SetDocumentVar(oWord,"FAX_FOR","("+A2_DDD+")"+Substr(SA2->A2_FAX,1,15))
OLE_SetDocumentVar(oWord,"NOM_CLI",Alltrim(SM0->M0_NOMECOM))
If Empty(Alltrim(SA2->A2_EMAIL))
	OLE_SetDocumentVar(oWord,"EMAIFOR"," ")
Else
	OLE_SetDocumentVar(oWord,"EMAIFOR",Alltrim(SA2->A2_EMAIL))
Endif
If Empty(Alltrim(SA2->A2_CONTATO))
	OLE_SetDocumentVar(oWord,"CONTATO"," ")
Else
	OLE_SetDocumentVar(oWord,"CONTATO",Alltrim(SA2->A2_CONTATO))
Endif
OLE_SetDocumentVar(oWord,"UFFOR",SA2->A2_EST)
OLE_SetDocumentVar(oWord,"CEPFOR",SA2->A2_CEP)
OLE_SetDocumentVar(oWord,"BAIFOR",AllTrim(SA2->A2_BAIRRO))

cCepPict:=PesqPict("SA2","A2_CEP")
cEndere	:= Iif(Empty(MV_PAR07), Iif(Empty(SM0->M0_ENDENT),SM0->M0_ENDCOB,SM0->M0_ENDENT), MV_PAR07)
cCidEst	:= Iif(Empty(MV_PAR08), Iif(Empty(SM0->M0_CIDENT+SM0->M0_ESTENT), SM0->M0_CIDCOB + " " + SM0->M0_ESTCOB,  SM0->M0_CIDENT + " " + SM0->M0_ESTENT),MV_PAR08)
cFax	:= Iif(Empty(MV_PAR09), SM0->M0_FAX, MV_PAR09)
cTel    := Iif(Empty(cTel), SM0->M0_TEL, cTel)

OLE_SetDocumentVar(oWord,"END_CLI",cEndere)
OLE_SetDocumentVar(oWord,"MUN_CLI",cCidEst)
OLE_SetDocumentVar(oWord,"BAI_CLI",SM0->M0_BAIRENT)
OLE_SetDocumentVar(oWord,"TEL_CLI",cTel)
OLE_SetDocumentVar(oWord,"FAX_CLI",cFax)
OLE_SetDocumentVar(oWord,"EMAI_CLI",cEmail)
OLE_SetDocumentVar(oWord,"CEP_CLI",Trans(SM0->M0_CEPENT,cCepPict))


li:=12
dbSelectArea("SC8")
cNumero := SC8->C8_NUM
cFornece:= SC8->C8_FORNECE
cLoja   := SC8->C8_LOJA

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpValores³ Autora³ Viviane Marta         ³ Data ³ 10.05.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir Valores da Cotacao.	  							        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpValores(Void) 		                        		        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 					                    					           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Labr150                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*--------------------------------------------*
Static Function ImpValores(Tipo)
*--------------------------------------------*

dbSelectArea("SC8")
If nSegundaUnid == 2 .And. !Empty(SC8->C8_QTSEGUM)
	OLE_SetDocumentVar(oWord,("QTD"+Strzero(nItens,2)),If(Tipo=1,Transform(SC8->C8_QTSEGUM,"@E 999999999.999")," "))
	OLE_SetDocumentVar(oWord,("UM"+Strzero(nItens,2)),If(Tipo=1,SC8->C8_SEGUM," "))
Else
	
	OLE_SetDocumentVar(oWord,("QTD"+Strzero(nItens,2)),If(Tipo=1,Transform(SC8->C8_QUANT,"@E 999999999.999")," "))
	OLE_SetDocumentVar(oWord,("UM"+Strzero(nItens,2)),If(Tipo=1,SC8->C8_UM," "))
Endif


OLE_SetDocumentVar(oWord,("PENT"+Strzero(nItens,2)),If(Tipo=1,SC8->C8_DATPRF," ") )
dbSelectArea("SA5")
dbSetOrder(2)


If dbSeek(xFilial()+SC8->C8_PRODUTO+SC8->C8_FORNECE+SC8->C8_LOJA)
	If !Empty(SA5->A5_CODPRF)
		//		@li,3 PSAY Alltrim(SA5->A5_CODPRF)
	EndIf
Endif
dbSelectArea("SC8")
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpDescr ³ Autora³ Viviane Marta         ³ Data ³ 10.05.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir descricao do Produto.	  						        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)  			                      			     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GEFCO                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*-------------------------------------*
Static Function ImpDescr(Tipo)
*-------------------------------------*


Local cDescri := " "
Local nBegin  := 0
Local nLinha  := 0

If Empty(mv_par06)
	mv_par06 := "B1_DESC"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao cientifica do Produto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par06) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek(xFilial("SB5")+SC8->C8_PRODUTO)
		cDescri := Alltrim(SB5->B5_CEME)
	EndIf
ElseIf AllTrim(mv_par06) == "A5_NOMPROD"
	dbSelectArea("SA5")
	dbSetOrder(1)
	If dbSeek(xFilial("SA5")+SC8->C8_FORNECE+SC8->C8_LOJA+SC8->C8_PRODUTO)
		cDescri := Alltrim(SA5->A5_NOMPROD)
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao do produto do arquivo de Cotacoes.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par06) == "C1_DESCRI"
	dbSelectArea("SC1")
	dbSetOrder(1)
	If dbSeek(xFilial("SC1")+SC8->C8_NUMSC+SC8->C8_ITEMSC)
		cDescri := Alltrim(SC1->C1_DESCRI)
	Endif
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao do Produto SB1.		         		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cDescri)
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+SC8->C8_PRODUTO)
	cDescri := Alltrim(SB1->B1_DESC)
EndIf

dbSelectArea("SC8")
                               
// Por: Ricardo - EM: 24/11/2011
cDescri += " - " + AllTrim(SC8->C8_OBS)

nLinha:= MLCount(cDescri,30)


If Tipo = 2
	cDescri := " "
Else
	cDescri := AllTrim(cDescri)
endif

Return(cDescri)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autora³ Viviane Marta        ³Data³ 28/05/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*-----------------------------------------*
Static Function AjustaSX1(cGrupo)
*-----------------------------------------*

Local cAlias := Alias();aRegistros:={};j:=0;i:=0

If cGrupo == "GEFR14"
	PutSx1("GEFR14","12","Endereco de Entrega?","Local de Entrega    ","Delivery Address    ","mv_chc","C",40,0,0,"G","","","","","mv_par12","","","","","","","","","","","","","","","","",;
	{"Forneca o endereco ou sera impresso o  ","endereco que consta no arquivo SM0.   "},;
	{"                                       ","                                      "},;
	{"                                       ","                                      "})
	PutSx1("GEFR14","13","e-mail              ","e-mail              ","e-mail              ","mv_chd","C",40,0,0,"G","","","","","mv_par13","","","","","","","","","","","","","","","","",;
	{"Forneca o e-mail da empresa para       ","impressao no relatorio.               "},;
	{"                                       ","                                      "},;
	{"                                       ","                                      "})
	PutSx1("GEFR14","14","Local Gravacao DOC ? ","Local Gravacao DOC ? ","Local Gravacao DOC ? ",;
	"mv_che","C",40,0,0,"G","","","","","mv_par14","","","","","","","","","","","","","","","","",;
	{"Forneca o endereco do Modelo Mapa de   ","Cotacao.  "},;
	{"                                       ","                                      "},;
	{"                                       ","                                      "})
	
Else
	PutSx1("MR150A","08","Endereco de Entrega?","Local de Entrega    ","Delivery Address    ","mv_ch8","C",40,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",;
	{"Forneca o endereco ou sera impresso o  ","endereco que consta no arquivo SM0.   "},;
	{"                                       ","                                      "},;
	{"                                       ","                                      "})
	PutSx1("MR150A","09","e-mail              ","e-mail              ","e-mail              ","mv_ch9","C",40,0,0,"G","","","","","mv_par09","","","","","","","","","","","","","","","","",;
	{"Forneca o e-mail da empresa para       ","impressao no relatorio.               "},;
	{"                                       ","                                      "},;
	{"                                       ","                                      "})
Endif
dbSelectArea(cAlias)
Return NIL



*----------------------------------------------*
User Function fmail(aVetor,cNumero)
*----------------------------------------------*
*Fc para envio de e-mail com arquivo anexado
*----------------------------------------------*

Local oDlg     := NIL
Local cMask    := "Todos os arquivos (*.*) |*.*|"
Local oMsg

Private cTitulo  := "Criar e-mail"
/*
Private cServer  := Trim(GetMV("MV_RELSERV")) // smtp.ig.com.br ou 200.181.100.51
Private cEmail   := Trim(GetMV("MV_RELACNT")) // fulano@ig.com.br
Private cPass    := Trim(GetMV("MV_RELPSW"))  // 123abc
*/
Private cDe      := Trim(GetMV("MV_RELFROM")) // alltrim(MV_PAR13)//"GEFCO - PEDIDO DE COMPRAS"
Private cPara    := space(30)//c_Mail
Private cCc      := Space(200)
Private cAssunto := space(40)
Private cAnexo   := " " //cDoc
Private cMsg     := space(99)
Private lRet     := .F.

If !empty(MV_PAR16)
	cAssunto:= alltrim(MV_PAR16) + " - " +cNumero
Else
	cAssunto := "Cotacao de Precos "+ " - " + cNumero
	
EndIf

If !empty(MV_PAR15)
	cMsg := alltrim(MV_PAR15)
Else
	cMsg := "Segue em anexo Cotação de Preços."
	
EndIf

c_Mail := aVetor[1][2]
For i:= 1 to Len(aVetor)
	If c_Mail <> aVetor[i][2]
		cPara := aVetor[i-1][2]
		Processa ({|| Validar()})
		//Processa ({|| Enviar()})
		
		Processa ({|| U_EnvEmail(cDe,cPara,cCc,cAssunto,cMsg,cAnexo)})		
		c_Mail := aVetor[i][2]
		//if para saber se eh lenavetor
		canexo := " "
	EndIf
	if i = len(aVetor)
		canexo += aVetor[i][1]
	else
		canexo += aVetor[i][1] + ";"
	endif
	lRet:= .t.
Next

If lRet
	cPara := aVetor[len(aVetor)][2]
	Processa ({|| Validar()})

	//Processa ({|| Enviar()})
	Processa ({|| U_EnvEmail(cDe,cPara,cCc,cAssunto,cMsg,cAnexo)})
EndIf

/*
If Empty(cServer) .And. Empty(cEmail) .And. Empty(cPass)
	MsgAlert("Não foi definido os parâmetros do server do Protheus para envio de e-mail",cTitulo)
	Return
Endif
*/

//Processa ({|| Validar()})
//Processa ({|| Enviar()})


RETURN

*--------------------------------------------------------*
STATIC FUNCTION Validar()
*--------------------------------------------------------*
*Funcao para criticar os campos obrigatórios para preenchimento
*--------------------------------------------------------*


Local lRet := .T.
If Empty(cDe)
	MsgInfo("Campo 'De' preenchimento obrigatório",cTitulo)
	lRet:=.F.
Endif
If Empty(cPara) .And. lRet
	MsgInfo("Campo 'Para' preenchimento obrigatório",cTitulo)
	lRet:=.F.
Endif
If Empty(cAssunto) .And. lRet
	MsgInfo("Campo 'Assunto' preenchimento obrigatório",cTitulo)
	lRet:=.F.
Endif

If lRet
	cDe      := AllTrim(cDe)
	cPara    := AllTrim(cPara)
	cCC      := AllTrim(cCC)
	cAssunto := AllTrim(cAssunto)
	cAnexo   := AllTrim(cAnexo)
Endif

RETURN(lRet)


*------------------------------------------*
STATIC FUNCTION Enviar()
*------------------------------------------*
*Funcao que critica e envia o e-mail
*------------------------------------------*


Local lResulConn := .T.
Local lResulSend := .T.
Local cError := ""

CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn

If !lResulConn
	GET MAIL ERROR cError
	MsgAlert("Falha na conexão "+cError)
	Return(.F.)
Endif


// Todos os e-mail terão: De, Para, Assunto e Mensagem, porém precisa analisar se tem: Com Cópia e/ou Anexo
If Empty(cCc) .And. Empty(cAnexo)
	SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg RESULT lResulSend
Else
	If Empty(cCc) .And. !Empty(cAnexo)
		SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
	Else
		SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg RESULT lResulSend
	Endif
Endif

If !lResulSend
	GET MAIL ERROR cError
	MsgAlert("Falha no Envio do e-mail " + cError)
Endif

DISCONNECT SMTP SERVER

RETURN(.T.)
