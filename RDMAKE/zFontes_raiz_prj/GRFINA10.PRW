#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GRFT10    º Autor ³ Andriani           º Data ³  05/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao de arquivo Movimento Deposito Identificado      º±±
±±º          ³ BRADESCO                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Granero                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GRFINA10

Private oLeTxt
Private cFile		:= Space(80)
Private cString	:= "PJ7"
Private vRadio		:= {}
Private nOpc 		:= 1
Private oBtnOk

dbSelectArea("PJ7")
dbSetOrder(1)

@ 200,001 TO 480,480 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 010,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme   "
@ 018,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 026,018 Say " PJ7                                                           	 "

AADD(vRadio,"BANCO DO BRASIL")
AADD(vRadio,"BRADESCO")
@ 050, 018 RADIO vRadio VAR nOpc 
@ 080, 018 SAY "Arquivo selecionado: " 
@ 080, 080 GET cFile	Picture "@!" WHEN .F.

@ 120,123 BMPBUTTON TYPE 14 ACTION Roda() 
@ 120,168 BMPBUTTON TYPE 01 ACTION OkLeTxt() OBJECT oBtnOk
@ 120,198 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered on init ( oBtnOk:DISABLE() )

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKLETXT  º Autor ³ AP6 IDE            º Data ³  05/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a leitura do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkLeTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nHdl    := fOpen(alltrim(cFile),68)
Private cEOL    := "CHR(13)+CHR(10)"

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+Alltrim(cFile)+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|| iif( nOpc==1,ExBcoBrasil(),ExBradesco())},"Processando...")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ExBradescoº Autor ³ AP5 IDE            º Data ³  05/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function ExBradesco

Local nTamFile, nTamLin, cBuffer, nBtLidos, nLinha:=0, xIdent, xBanco, ;
		xAgencia, xCC, xNrSeq, xTotDin:=0, xTotCh:=0, xTotal:=0, lDetalhes:=.t.,;
		lHeader:=.t., lTrailler:=.t.

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 240+Len(cEOL)
cBuffer  := Space(nTamLin)
nLinha	:=0
nQtdInc 	:=0
nBtLidos	:= fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto
/*
Consistir Header
*/
xNrSeq := 0
While nBtLidos >= nTamLin
	
	xNrSeq++
	if Subs(cBuffer,1,1) == "0"
		xBanco 	:= Alltrim(StrZero( Val(Substr( cBuffer, 109, 3 )),3))
		xAgencia	:= Alltrim(StrZero( Val(Substr( cBuffer, 124, 5 )),3)) 
		xCC		:=	Alltrim(Str(Val(Substr ( cBuffer, 133, 11 ))))
		lHeader  := u_amBusca("SA6", xFilial("SA6") + xBanco + xAgencia + xCC ,1)
	elseif Subs(cBuffer,1,1) == "1"
		xIdent	:= Alltrim(Str(Val(Substr(cBuffer, 43, 17)))) 
		xTotDin	+= Val(Substr(cBuffer, 61, 13)+"."+Substr(cBuffer, 74, 02))
		xTotCh	+= Val(Substr(cBuffer, 76, 13)+"."+Substr(cBuffer, 89, 02))
		xTotal	+= Val(Substr(cBuffer, 91, 13)+"."+Substr(cBuffer,104, 02))
		lDetalhes := u_amBusca("PJ6",xFilial("PJ6") + xIdent,1)
	elseif Subs(cBuffer,1,1) == "9"
		if xTotDin	<> Val(Substr(cBuffer, 09, 13)+"."+Substr(cBuffer, 22, 02))
			lTrailler	:= .f.		
		endif
		if xTotCh	<> Val(Substr(cBuffer, 75, 13)+"."+Substr(cBuffer, 88, 02))
			lTrailler	:= .f.				
		endif
		if xTotal	<> Val(Substr(cBuffer, 97, 13)+"."+Substr(cBuffer,110, 02))
			lTrailler	:= .f.				
		endif
	endif
	
	if strZero(xNrSeq,7) <> Substr( cBuffer, 234, 7 )
		lDetalhes := .f.
	endif
	if lHeader .and. lDetalhes .and. lTrailler
		nBtLidos := fRead(nHdl,@cBuffer,nTamLin) 
   	dbSkip()
   else
		fClose(nHdl)
		Close(oLeTxt)
	   Aviso("Cuidado!","Arquivo Invalido! Favor verificar...",{"Ok"})
		return   
   endif	
EndDo

//------------------------------------------------------------------------------------
nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 240+Len(cEOL)
cBuffer  := Space(nTamLin) 
nLinha	:=0
nQtdInc 	:=0
nBtLidos	:= fRead(nHdl,@cBuffer,nTamLin) 
While nBtLidos >= nTamLin

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Incrementa a regua                                                  ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLinha++
   IncProc(nLinha)

	if Subs(cBuffer,1,1) == "1"	
		xIdent := Alltrim(Str(Val(Substr(cBuffer, 43, 17))))
	   If !DBSeek(xFilial("PJ7")+xIdent)
			DBSelectArea("PJ6")
			DBSetOrder(1)
			If DBseek(xFilial("PJ6")+xIdent)
				xTpDep := PJ6->PJ6_TPDEP
			   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			   //³ Grava os campos obtendo os valores da linha lida do arquivo texto.  ³
			   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DBSelectArea("PJ7")
				DBSetOrder(1)			
				nQtdInc++
				RecLock(cString,.T.)
				PJ7->PJ7_FILIAL	:= xFilial("PJ7")
				PJ7->PJ7_TPDEP		:= xTpDep
				PJ7->PJ7_IDENT		:= xIdent
				PJ7->PJ7_DIGITO	:= Substr(cBuffer, 60, 01)
				PJ7->PJ7_BANCO		:= xBanco
				PJ7->PJ7_AG			:= xAgencia
				PJ7->PJ7_CC			:= xCC
				PJ7->PJ7_DTDEP		:= Ctod(Substr(cBuffer, 02, 02)+"/"+Substr(cBuffer, 04, 02)+"/"+Substr(cBuffer, 06, 04))
				PJ7->PJ7_HORA		:= Substr(cBuffer, 15, 06)
				PJ7->PJ7_VALDIN	:= Val(Substr(cBuffer, 61, 13)+"."+Substr(cBuffer, 74, 02))
				PJ7->PJ7_VALCHE	:= Val(Substr(cBuffer, 76, 13)+"."+Substr(cBuffer, 89, 02))
				PJ7->PJ7_VALTOT	:= Val(Substr(cBuffer, 91, 13)+"."+Substr(cBuffer,104, 02))
				PJ7->PJ7_STATUS	:= "1"
				PJ7->PJ7_NRDOC		:= Substr(cBuffer,106, 07) 
				PJ7->PJ7_CANAL		:= Substr(cBuffer,113, 02)
				MSUnLock()
			endif
	   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Leitura da proxima linha do arquivo texto.                          ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   endif
	endif
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fClose(nHdl)
Close(oLeTxt)

if nQtdInc > 0 
	MsgAlert("Operação realizada com sucesso!")
else
	MsgAlert("Atenção! Nenhum registro foi incluido!")
endif

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ExBcoBrasilº Autor ³ AP5 IDE            º Data ³  05/09/03  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function ExBcoBrasil

Local nTamFile, nTamLin, cBuffer, nBtLidos, nLinha:=0, xIdent, xBanco, ;
		xAgencia, xCC, xNrSeq, xTotDin:=0, xTotCh:=0, lDetalhes:=.t.,;
		lHeader:=.t., lTrailler:=.t.

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 200+Len(cEOL)
cBuffer  := Space(nTamLin)
nLinha	:=0
nQtdInc 	:=0
nBtLidos	:= fRead(nHdl,@cBuffer,nTamLin)
/*
Consistir Header
*/
xNrSeq := 0
While nBtLidos >= nTamLin
	
	xNrSeq++
	if Subs(cBuffer,1,1) == "0"
		xBanco 	:= Alltrim(StrZero( Val(Substr( cBuffer, 010, 003 )),3))
		xAgencia	:= Alltrim(StrZero( Val(Substr( cBuffer, 019, 004 )),4))
		xAgencia	:= xAgencia + Modulo11( xAgencia )
		xCC		:=	Alltrim(Str(Val(Substr ( cBuffer, 023, 010 ))))
		lHeader  := u_amBusca("SA6", xFilial("SA6") + xBanco + xAgencia + xCC ,1)
	elseif Subs(cBuffer,1,1) == "1"
		xIdent	:= Alltrim(Str(Val(Substr(cBuffer, 118, 16))))
		xTotDin	+= Val(Substr(cBuffer, 80, 15)+"."+Substr(cBuffer, 95, 02))
		xTotCh	+= Val(Substr(cBuffer, 97, 15)+"."+Substr(cBuffer,112, 02))
		lDetalhes := u_amBusca("PJ6",xFilial("PJ6") + xIdent,1)
	elseif Subs(cBuffer,1,1) == "9"
		if xTotDin	<> Val(Substr(cBuffer, 10, 15)+"."+Substr(cBuffer, 25, 02))
			lTrailler	:= .f.
		endif
		if xTotCh	<> Val(Substr(cBuffer, 27, 15)+"."+Substr(cBuffer, 42, 02))
			lTrailler	:= .f.
		endif
	endif
	
	if lHeader .and. lDetalhes .and. lTrailler
		nBtLidos := fRead(nHdl,@cBuffer,nTamLin) 
   	dbSkip()
   else
		fClose(nHdl)
		Close(oLeTxt)
	   Aviso("Cuidado!","Arquivo Invalido! Favor verificar...",{"Ok"})
		return   
   endif	
   
EndDo

//------------------------------------------------------------------------------------
nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 200+Len(cEOL)
cBuffer  := Space(nTamLin) 
nLinha	:= 0
nQtdInc 	:= 0
nBtLidos	:= fRead(nHdl,@cBuffer,nTamLin) 
While nBtLidos >= nTamLin

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Incrementa a regua                                                  ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLinha++
   IncProc(nLinha)

	if Subs(cBuffer,1,1) == "1"	
		xIdent := Alltrim(Str(Val(Substr(cBuffer,118, 16))))
	   If !DBSeek(xFilial("PJ7")+xIdent)
			DBSelectArea("PJ6")
			DBSetOrder(1)
			If DBseek(xFilial("PJ6")+xIdent)
				xTpDep := PJ6->PJ6_TPDEP
			   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			   //³ Grava os campos obtendo os valores da linha lida do arquivo texto.  ³
			   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DBSelectArea("PJ7")
				DBSetOrder(1)			
				nQtdInc++
				RecLock(cString,.T.)
				PJ7->PJ7_FILIAL	:= xFilial("PJ7")
				PJ7->PJ7_TPDEP		:= xTpDep
				PJ7->PJ7_IDENT		:= xIdent
				PJ7->PJ7_DIGITO	:= Substr(cBuffer,134, 01)
				PJ7->PJ7_BANCO		:= xBanco
				PJ7->PJ7_AG			:= xAgencia
				PJ7->PJ7_CC			:= xCC
				PJ7->PJ7_DTDEP		:= Ctod(Substr(cBuffer, 08, 02)+"/"+Substr(cBuffer, 06, 02)+"/"+Substr(cBuffer, 04, 02))
				PJ7->PJ7_HORA		:= "" // Valor nao informado no TXT do Banco do Brasil
				PJ7->PJ7_VALDIN	:= Val(Substr(cBuffer, 80, 15)+"."+Substr(cBuffer, 95, 02))
				PJ7->PJ7_VALCHE	:= Val(Substr(cBuffer, 97, 15)+"."+Substr(cBuffer,112, 02))
				PJ7->PJ7_VALTOT	:= Val(Substr(cBuffer, 80, 15)+"."+Substr(cBuffer, 95, 02)) + Val(Substr(cBuffer, 97, 15)+"."+Substr(cBuffer,112, 02))
				PJ7->PJ7_STATUS	:= "1"
				PJ7->PJ7_NRDOC		:= "" // Valor nao informado no TXT do Banco do Brasil
				PJ7->PJ7_CANAL		:= "" // Valor nao informado no TXT do Banco do Brasil
				MSUnLock()
			endif
	   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Leitura da proxima linha do arquivo texto.                          ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   endif
	endif
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fClose(nHdl)
Close(oLeTxt)

if nQtdInc > 0 
	MsgAlert("Operação realizada com sucesso!")
else
	MsgAlert("Atenção! Nenhum registro foi incluido!")
endif

Return


/*	
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º RODA - Permite ao usuario selecionar o arquivo a ser importado        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Roda
Local cTipo
cTipo := "Todos os Arquivos  (*.*)   | *.*     "
cFile := cGetFile(cTipo,"Selecao de Arquivo")
If !Empty(cFile)
	oBtnOk:ENABLE()   
Else
	oBtnOK:DISABLE()   
Endif
Return

