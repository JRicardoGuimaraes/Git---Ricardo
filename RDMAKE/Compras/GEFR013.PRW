#INCLUDE "MSOLE.CH" 
#INCLUDE "ap5mail.ch" 
#INCLUDE "rwmake.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEFR013   ºAutora ³Viviane Marta       º Data ³  10/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Emissao do Pedido de Compras,integracao com o word.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRAS-MP8                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*-----------------------------------------------------------*
User Function GEFR013(cAlias,nReg,nOpcx)
*-----------------------------------------------------------*


PRIVATE wnrel		 := "MATR110"
PRIVATE cDesc1		 := "Emissao dos pedidos de compras ou autorizacoes de entrega"
PRIVATE cDesc2		 := "cadastradados e que ainda nao foram impressos"
PRIVATE cDesc3		 := " "
PRIVATE cString	 	 := "SC7"
Private cDescri 	 := ""
PRIVATE lAuto		 := (nReg!=Nil)
PRIVATE Tamanho	 	 := "G"
PRIVATE titulo	 	 := "Emissao dos Pedidos de Compras ou Autorizacoes de Entrega"
PRIVATE aReturn 	 := {"Zebrado", 1,"Administracao", 1, 2, 1, "",0 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog	 :="GEFR013"
PRIVATE nLastKey	 := 0
PRIVATE nBegin		 := 0
PRIVATE nDifColCC  	 := 0
PRIVATE aLinha		 := {}
PRIVATE aSenhas	 	 := {}
PRIVATE aUsuarios	 := {}
PRIVATE M_PAG 		 := 1
PRIVATE CPERG 		 := "GEFR13"
PRIVATE c_Mail     	 := space(40)
PRIVATE aVetor       := {}
If Type("lPedido") != "L"
	lPedido := .F.
Endif
PRIVATE lEnd		:= .T.
PRIVATE NITENS 	 	:= 0 
PRIVATE aRadio		:= {"Imprime  ","Salva  ","E-mail"}
//PRIVATE nRadio		 := 2
PRIVATE nRadio		:= 3
SetPrvt("CTYPE,CARQUIVO,nOrdem")
SetPrvt("NVEZ,OWORD,cCaminho,limite")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01               Do Pedido                             ³
//³ mv_par02               Ate o Pedido                          ³
//³ mv_par03               A partir da data de emissao           ³
//³ mv_par04               Ate a data de emissao                 ³
//³ mv_par05               Somente os Novos                      ³
//³ mv_par06               Campo Descricao do Produto    	     ³
//³ mv_par07               Unidade de Medida:Primaria ou Secund. ³
//³ mv_par08               Imprime ? Pedido Compra ou Aut. Entreg³
//³ mv_par09               Numero de vias                        ³
//³ mv_par10               Pedidos ? Liberados Bloqueados Ambos  ³
//³ mv_par11               Impr. SC's Firmes, Previstas ou Ambas ³
//³ mv_par12               Qual a Moeda ?                        ³
//³ mv_par13               Endereco de Entrega                   ³
//³ mv_par14               Local Gravacao Doc  
//³ mv_par15               E-mail do Comprador                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
Pergunte(CPERG,.F.)                                           

dbSelectArea("SC7")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o de Pedido de Compra Word")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo WORD, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario.                              "
@ 30,010 TO 080,190 TITLE " Selecione: "
@ 45,018 RADIO aRadio VAR nRadio

@ 70,100 BMPBUTTON TYPE 01 ACTION OkGeraTxt(cAlias,nReg,nOpcx)
@ 70,128 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autora³Viviane Marta       º Data ³  10/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/            

*--------------------------------------------------*
Static Function OkGeraTxt(cAlias,nReg,nOpcx)
*--------------------------------------------------*

cCaminho  := AllTrim(Mv_par14)
cCompMail := MV_PAR15
cCaminho2 := GetSrvProfString("RootPath", "\undefined")+"\"

//If !File(Alltrim(cCaminho)+"\PEDIDO.dot")
If !File("\MODELO\PEDIDO.dot")
   Alert("Arquivo modelo (pedito.dot) nao Encontrado! Favor comunicar o administrador do Sistema.")
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

//If !File(cCaminho + "PEDIDO.DOT")
If !File("\DOC\PEDIDO.DOT")
	COPY FILE "\MODELO\PEDIDO.dot" TO "\DOC\PEDIDO.dot"
EndIf	

If !File(cCaminho+"PEDIDO.DOT")
	CpyS2T("\MODELO\PEDIDO.dot", cCaminho)
EndIf	

//cArquivo := "\DOC\PEDIDO.dot"  // Caminho da Carta Modelo
cArquivo := Alltrim(cCaminho)+"\PEDIDO.dot"  // Caminho da Carta Modelo
//cArquivo := "\MODELO\PEDIDO.dot"  // Caminho da Carta Modelo
// Inicializa o Ole com o MS-Word 97 ( 8.0 )	
oWord := OLE_CreateLink('TMsOleWord97')		
OLE_SetProperty( oWord, oleWdPrintBack, .T. )
OLE_SetProperty( oWord, oleWdVisible,   .T. )
OLE_NewFile(oWord,cArquivo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par08 == 1
	RptStatus({|lEnd| C110PC(@lEnd,wnRel,cString,nReg)},titulo)
Else
	RptStatus({|lEnd| C110AE(@lEnd,wnRel,cString,nReg)},titulo)
EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C110PC   ³ Autora³ Viviane Marta         ³ Data ³ 10.05.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GEFR100			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*-------------------------------------------------*
Static Function C110PC(lEnd,WnRel,cString,nReg)
*-------------------------------------------------*


Local nReem
Local nOrder
Local cCondBus
Local nSavRec
Local aSavRec := {}
Local nLinObs := 0 

Private cCGCPict, cCepPict
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCepPict	:=PesqPict("SA2","A2_CEP")
cCGCPict	:=PesqPict("SA2","A2_CGC")
li       := 80
nDescProd:= 0
nTotal   := 0
nTotMerc := 0
NumPed   := Space(6)

If lAuto
	dbSelectArea("SC7")
	dbGoto(nReg)
	SetRegua(1)
	mv_par01 := SC7->C7_NUM
	mv_par02 := SC7->C7_NUM
	mv_par03 := SC7->C7_EMISSAO
	mv_par04 := SC7->C7_EMISSAO
	mv_par05 := 2
	mv_par08 := SC7->C7_TIPO
	mv_par09 := 1
	mv_par10 := 3
	mv_par11 := 3
EndIf

If ( cPaisLoc$"ARG|POR|EUA" )
	cCondBus	:=	"1"+strzero(val(mv_par01),6)
	nOrder	:=	10
	nTipo		:= 1 
Else
	cCondBus	:=mv_par01
	nOrder	:=	1
EndIf

dbSelectArea("SC7")
dbSetOrder(nOrder)
SetRegua(RecCount())
dbSeek(xFilial("SC7")+cCondBus,.T.)


While !SC7->(Eof()) .And. SC7->C7_FILIAL = xFilial("SC7") .And. SC7->C7_NUM >= mv_par01 .And. ;
		SC7->C7_NUM <= mv_par02
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as variaveis para armazenar os valores do pedido        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOrdem   := 1
	nReem    := 0
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "
	
	If SC7->C7_EMITIDO == "S" .And. mv_par05 == 1
		dbSkip()
		Loop
	Endif
	If (SC7->C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
	   (SC7->C7_CONAPRO != "B" .And. mv_par10 == 2)
		dbSkip()
		Loop
	Endif
	If (SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)
		dbSkip()
		Loop
	Endif
	If SC7->C7_TIPO == 2
		dbSkip()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !MtrAValOP(mv_par11, 'SC7')
		dbSkip()
		Loop
	EndIf
		
	MaFisEnd()
	MaFisIniPC(SC7->C7_NUM)

	For ncw := 1 To mv_par09		// Imprime o numero de vias informadas
		nOrdem:=1
		LabCabec()
		
		nTotal   := 0
		nTotMerc := 0
		nDescProd:= 0
		nReem    := SC7->C7_QTDREEM + 1
		nSavRec  := SC7->(Recno())
		NumPed   := SC7->C7_NUM
        nLinObs  := 0
        nItens   := 0
        nItensc  := 0
		limite   := 10
		While !SC7->(Eof()) .And. SC7->C7_FILIAL = xFilial("SC7") .And. SC7->C7_NUM == NumPed
		
			If SC7->C7_EMITIDO == "S" .And. mv_par05 == 1
				dbSkip()
				Loop
			Endif
			If (SC7->C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
			   (SC7->C7_CONAPRO != "B" .And. mv_par10 == 2)
				dbSkip()
				Loop
			Endif
			If (SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)
				dbSkip()
				Loop
			Endif
			If SC7->C7_TIPO == 2
				dbSkip()
				Loop
			EndIf
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !MtrAValOP(mv_par11, 'SC7')
				dbSkip()
				Loop
			EndIf
				
			MaFisEnd()
			MaFisIniPC(SC7->C7_NUM)
		
			If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
				AADD(aSavRec,Recno())
			Endif
			If lEnd
				@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
				Goto Bottom
				Exit
			Endif
			
			IncRegua()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializacao da Observacao do Pedido.                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !EMPTY(SC7->C7_OBS) .And. nLinObs < 3
                nLinObs++
				cVar:="cObs"+StrZero(nLinObs,2)  
                DBSELECTAREA("SC8")
                SC8->(DbSetorder(3))
                SC8->(Dbseek(xFilial("SC8")+SC7->C7_NUMCOT+SC7->C7_PRODUTO+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_NUM+SC7->C7_ITEM)				)
				Eval(MemVarBlock(cVar),SC8->C8_OBS)
                DBSELECTAREA("SC7")
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se havera salto de formulario                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            nItensc++
			li++
			If nItensc = limite+1
	  	       FinalPed(nDescProd)		// Imprime os dados complementares do PC
			   limite += 10
               OLE_SetDocumentVar(oWord,"CONTINUA","Continua ...")
   	           //--Atualiza Variaveis
   	           OLE_UpDateFields(oWord)
               //-- Imprime as variaveis	
	   	       If nRadio = 1
		   	      OLE_SetProperty( oWord, '208', .F. ) ; OLE_PrintFile( oWord, "ALL",,, 1 )       
   			   Elseif nRadio = 2 // Salva em arquivo
          	      OLE_SaveAsFile(oWord,Alltrim(cCaminho)+"\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc")
         		Else // Envia por e-mail
         		   OLE_SaveAsFile(oWord,Alltrim(cCaminho)+"\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc")
         		   //OLE_SaveAsFile(oWord,"\DOC\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc")         		   
         		   cDoc := "\DOC\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc"
         		   CpyT2S(cCaminho+cDOC,"\DOC")
         		   //U_fEnviamail(cDoc,NumPed)
         		   aadd(aVetor,{cDoc})
		       Endif             
       		   nOrdem++
//				ImpRodape(1)			// Imprime rodape do formulario e salta para a proxima folha
				LabCabec() 
			Endif
			If nItensc > 10
			   nItens :=Val(Substr(Str(nItensc,2),2))						
               If nItens = 0
                  nItens :=10
               Endif
            Else
			   nItens :=nItensC
            Endif     

            // Variaveis a serem usadas na Montagem do Documento no Word    
		    OLE_SetDocumentVar(oWord,("ITEM"+Strzero(nItens,2)),Transform(SC7->C7_ITEM,PesqPict("SC7","c7_item")))
			
			OLE_SetDocumentVar(oWord,("COD"+Strzero(nItens,2)),Transform(SC7->C7_PRODUTO,PesqPict("SC7","c7_produto")))
			
		    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		    //³ Pesquisa Descricao do Produto                                ³
		    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    cDescri := ImpProd(1) + AllTrim(SC7->C7_OBS)
            n:=0
			If Len(cDescri) > 45//50 
			   For i:=1 to Len(cDescri) Step 45 // 50
                   i:=n+1
                   If i= 1
                      If Substr(cDescri,45,1) = " " .or. Substr(cDescri,46,1) = " " 
                         OLE_SetDocumentVar(oWord,("DESCP"+Strzero(nItens,2)),Substr(cDescri,i,45) )                      
			             n += 45
	                  Else
						   _Descri := Substr(cDescri,i,45) 
		                   _Desc   := Substr(cDescri,i,45) 
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
                   
                   If Substr(cDescri,45+i,1) = " " .or. Substr(cDescri,44+i,1) = " " .or. 45+i >= Len(cDescri)
				          OLE_SetDocumentVar(oWord,("DESCP"+Strzero(nItens,2)),Substr(cDescri,i,45) )
				          n += 45
	                   Else
						   _Descri := Substr(cDescri,i,45) 
		                   _Desc   := Substr(cDescri,i,45) 
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
	               
			       If i = 1
			          ImpCampos(1)
			       Else
			          OLE_SetDocumentVar(oWord,("ITEM"+Strzero(nItens,2))," ")
				      OLE_SetDocumentVar(oWord,("COD"+Strzero(nItens,2))," ")
			          ImpCampos(2)
			       Endif   
			       nItensC++
			       
					If nItensc = limite+1
			  	       FinalPed(nDescProd)		// Imprime os dados complementares do PC
					   limite += 10
		               OLE_SetDocumentVar(oWord,"CONTINUA","Continua ...")
		   	           //--Atualiza Variaveis
		   	           OLE_UpDateFields(oWord)
		               //-- Imprime as variaveis	
			   	       If nRadio = 1
				   	      OLE_SetProperty( oWord, '208', .F. ) ; OLE_PrintFile( oWord, "ALL",,, 1 )       
		   			   ElseIf nRadio = 2 // Salva em arquivo
		          	      OLE_SaveAsFile(oWord,Alltrim(cCaminho)+"\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc")
		         		Else // Envia por e-mail
	         		 	   OLE_SaveAsFile(oWord,Alltrim(cCaminho)+"\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc")
	         		 	   //OLE_SaveAsFile(oWord,"\DOC\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc")	         		 	   
         		   		   CpyT2S(Alltrim(cCaminho)+"\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc", "\DOC")	         		 	   
	         		 	   cDoc := "\DOC\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc" 
	         		 	   //cDoc := cCaminho+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc" 	         		 	   
         		   		   //CpyS2T("\DOC\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc", cCaminho)	         		 	   
 	            		   //U_fEnviamail(cDoc,NumPed)
               		   aadd(aVetor,{cDoc})
				       Endif           
		               nOrdem++
						LabCabec()                                              
						
                        nItens :=Val(Substr(Str(nItensc,2),2))						
                        If nItens = 0
                           nItens :=10
                        Endif
			            OLE_SetDocumentVar(oWord,("ITEM"+Strzero(nItens,2))," ")
				        OLE_SetDocumentVar(oWord,("COD"+Strzero(nItens,2))," ")
			            ImpCampos(2)

					Endif
		
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
			   OLE_SetDocumentVar(oWord,("DESCP"+Strzero(nItens,2)),cDescri)
			   ImpCampos(1)
			Endif
			
			If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
				nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
				nDescProd+=SC7->C7_VLDESC
			Endif

			SC7->(dbSkip())
		EndDo
		
		If nItensc < limite 
		   For nItensc := nItensc+1 to limite            
		      If nItensc > 10
			     nItens :=Val(Substr(Str(nItensc,2),2))						
                 If nItens = 0
                    nItens :=10
                 Endif
			  Else 
			     nItens := nItensc
			  Endif   
	          // Variaveis a serem usadas na Montagem do Documento no Word    
   			  OLE_SetDocumentVar(oWord,("ITEM"+Strzero(nItens,2))," ")
	   		  OLE_SetDocumentVar(oWord,("COD"+Strzero(nItens,2))," ")
		   	  //³ Pesquisa Descricao do Produto                                ³
//			  ImpProd(2)
		      OLE_SetDocumentVar(oWord,("DESCP"+Strzero(nItens,2))," ")
			  ImpCampos(2)
		   Next
		   
		Endif
		
		dbGoto(nSavRec)

		FinalPed(nDescProd)		// Imprime os dados complementares do PC

        OLE_SetDocumentVar(oWord,"CONTINUA"," ")
		
  	    //--Atualiza Variaveis
        OLE_UpDateFields(oWord)

        //-- Imprime as variaveis	
	   If nRadio = 1
	   	OLE_SetProperty( oWord, '208', .F. ) ; OLE_PrintFile( oWord, "ALL",,, 1 )       
       Elseif nRadio = 2 // Salva em arquivo
          OLE_SaveAsFile(oWord,Alltrim(cCaminho)+"\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc")
       Else // Envia por e-mail
          OLE_SaveAsFile(oWord,Alltrim(cCaminho)+"\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc")
          //OLE_SaveAsFile(oWord,"\DOC\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc")          
          // cDoc := "\DOC\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc"
          //cDoc := cCaminho+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc"
   		   CpyT2S(Alltrim(cCaminho)+"\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc", "\DOC")	         		 	                       
          cDoc := "\DOC\"+NumPed+"-"+Str(nOrdem,1)+"-"+Strzero(ncw,2)+".doc"                    
//   		 U_fEnviamail(cDoc,NumPed)
			 aadd(aVetor,{cDoc})

		Endif  
		nOrdem++

	 Next

	 MaFisEnd()
		
	 If Len(aSavRec)>0
		For i:=1 to Len(aSavRec)
			dbGoto(aSavRec[i])
			RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
			Replace SC7->C7_QTDREEM With (SC7->C7_QTDREEM+1)
			Replace SC7->C7_EMITIDO With "S"
			MsUnLock()
		Next
		dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array
	 Endif
	
   aSavRec := {}
	
   dbSkip()
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_CloseFile( oWord ) 			// Fecha o Documento

OLE_CloseLink( oWord ) 			// Fecha o Link Documento

dbSelectArea("SC7")
Set Filter To
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

U_fEnviamail(aVetor,NumPed)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpProd  ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisar e imprimir  dados Cadastrais do Produto.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Labr110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*-------------------------------------------------------------------*
Static Function ImpProd(Tipo)//Define impressao 1 - Imprime os dados ponteirados na tabela 2 - Preenche com brancos somente para complementar docto.
*-------------------------------------------------------------------*


LOCAL cDesc, nLinRef := 1, nBegin := 0, nLinha:=0,;
		nTamDesc := 28, aColuna := Array(8)

If Empty(mv_par06)
	mv_par06 := "B1_DESC"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par06) == "B1_DESC"
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbSeek( xFilial("SB1")+SC7->C7_PRODUTO ))
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao cientifica do Produto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par06) == "B5_CEME"
   _Area:=(GetArea())
	dbSelectArea("SB5")
	SB5->(dbSetOrder(1))
	If SB5->(dbSeek( xFilial("SB5")+SC7->C7_PRODUTO ))
		cDescri := Alltrim(B5_CEME)
	EndIf              
	RestArea(_Area)
	dbSelectArea("SC7")
EndIf

dbSelectArea("SC7")
If AllTrim(mv_par06) == "C7_DESCRI"
	cDescri := Alltrim(SC7->C7_DESCRI)
EndIf

If Empty(cDescri)
	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek( xFilial()+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
EndIf

dbSelectArea("SA5")
dbSetOrder(1)
If dbSeek(xFilial("SA5")+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO).And. !Empty(SA5->A5_CODPRF)
	cDescri := cDescri + " ("+Alltrim(A5_CODPRF)+")"
EndIf
dbSelectArea("SC7")
nLinha:= MLCount(cDescri,nTamDesc)
                                            

Return(cDescri)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCampos³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir dados Complementares do Produto no Pedido.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCampos(Void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Labr110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*----------------------------------------*
Static Function ImpCampos(Tipo)
*----------------------------------------*

LOCAL aColuna[6]
dbSelectArea("SC7")

If MV_PAR07 == 2 .And. !Empty(SC7->C7_SEGUM)

   OLE_SetDocumentVar(oWord,("UM"+Strzero(nItens,2)),If(Tipo=1,Transform(SC7->C7_SEGUM,PesqPict("SC7","C7_SEGUM"))," "))
Else

   OLE_SetDocumentVar(oWord,("UM"+Strzero(nItens,2)),If(Tipo=1,Transform(SC7->C7_UM,PesqPict("SC7","C7_UM"))," "))
EndIf

If MV_PAR07 == 2 .And. !Empty(SC7->C7_QTSEGUM) 

	OLE_SetDocumentVar(oWord,("QTD"+Strzero(nItens,2)),If(Tipo=1,Transform(SC7->C7_QTSEGUM,PesqPictQt("C7_QUANT",13))," "))
Else

	OLE_SetDocumentVar(oWord,("QTD"+Strzero(nItens,2)),If(Tipo=1,Transform(SC7->C7_QUANT,PesqPictQt("C7_QUANT",13))," "))
EndIf

If MV_PAR07 == 2 .And. !Empty(SC7->C7_QTSEGUM)  

	OLE_SetDocumentVar(oWord,("VLUNIT"+Strzero(nItens,2)),If(Tipo=1,Transform(xMoeda((SC7->C7_TOTAL/SC7->C7_QTSEGUM),SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),PesqPict("SC7","C7_PRECO",12, mv_par12))," "))
Else

	OLE_SetDocumentVar(oWord,("VLUNIT"+Strzero(nItens,2)),If(Tipo=1,Transform(xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),PesqPict("SC7","C7_PRECO",12, mv_par12))," "))
EndIf

If mv_par08 == 1
	If cPaisLoc == "BRA"

		OLE_SetDocumentVar(oWord,("IPI"+Strzero(nItens,2)),If(Tipo=1,Transform(SC7->C7_IPI,PesqPictQt("C7_IPI",5))," "))
	EndIf

	OLE_SetDocumentVar(oWord,("VLTOT"+Strzero(nItens,2)),If(Tipo=1,Transform(xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),PesqPict("SC7","C7_TOTAL",16,mv_par12))," "))


	OLE_SetDocumentVar(oWord,("ENTREG"+Strzero(nItens,2)),If(Tipo=1,Transform(SC7->C7_DATPRF,PesqPict("SC7","C7_DATPRF"))," "))

	OLE_SetDocumentVar(oWord,("CC"+Strzero(nItens,2)),If(Tipo=1,Transform(SC7->C7_CC,PesqPict("SC7","C7_CC",20))," "))

	OLE_SetDocumentVar(oWord,("SC"+Strzero(nItens,2)),If(Tipo=1,SC7->C7_NUMSC," "))
	If Tipo=1
       nTotal  :=nTotal+SC7->C7_TOTAL
    Endif   
Else

	OLE_SetDocumentVar(oWord,("VLTOT"+Strzero(nItens,2)),If(Tipo=1,Transform(xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),PesqPict("SC7","C7_TOTAL",16,mv_par12))," "))

	OLE_SetDocumentVar(oWord,("ENTREG"+Strzero(nItens,2)),If(Tipo=1,Transform(SC7->C7_DATPRF,PesqPict("SC7","C7_DATPRF"))," "))

	OLE_SetDocumentVar(oWord,("SC"+Strzero(nItens,2)),If(Tipo=1,SC7->C7_OP," "))
	If Tipo=1
       nTotal  :=nTotal+SC7->C7_TOTAL
    Endif   
EndIf

nTotMerc:=MaFisRet(,"NF_TOTAL")
Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalPed ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares do Pedido de Compra        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalPed(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Labr110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*-----------------------------------------*
Static Function FinalPed(nDescProd)
*-----------------------------------------*
Local nk 		:= 1,nG
Local nQuebra	:= 0
Local nTotDesc	:= nDescProd
Local lNewAlc	:= .F.
Local lLiber 	:= .F.
Local lImpLeg	:= .T.
Local cComprador:=""
LOcal cAlter	:=""
Local cAprov	:=""
Local nTotIpi	:= MaFisRet(,'NF_VALIPI')
Local nTotIcms	:= MaFisRet(,'NF_VALICM')
Local nTotDesp	:= MaFisRet(,'NF_DESPESA')
Local nTotFrete	:= MaFisRet(,'NF_FRETE')
Local nTotalNF	:= MaFisRet(,'NF_TOTAL')
Local nTotSeguro:= MaFisRet(,'NF_SEGURO')
Local aValIVA   := MaFisRet(,"NF_VALIMP")
Local nValIVA   :=0
Local aColuna   := Array(8), nTotLinhas

If cPaisLoc <> "BRA" .And. !Empty(aValIVA)
   For nG:=1 to Len(aValIVA)
       nValIVA+=aValIVA[nG]
   Next
Endif

cMensagem:= Formula(C7_MSG)

If !Empty(cMensagem)
	li++
//	@ li,002 PSAY Padc(cMensagem,129)           
//	OLE_SetDocumentVar(oWord,"OBSERVACAO",Padc(cMensagem,129))
Endif

li++
li++

nTotLinhas :=  39


OLE_SetDocumentVar(oWord,"DESCONTO",Transform(xMoeda(nTotDesc,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),PesqPict("SC7","C7_VLDESC",14, mv_par12)))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o Arquivo de Empresa SM0.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime endereco de entrega do SM0 somente se o MV_PAR13 =" "³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
If Empty(MV_PAR13)

    OLE_SetDocumentVar(oWord,"ENDENTR",SM0->M0_ENDENT)
Else

    OLE_SetDocumentVar(oWord,"ENDENTR",MV_PAR13)
Endif

dbGoto(nRegistro)
dbSelectArea( cAlias )

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_COND)
dbSelectArea("SC7")

OLE_SetDocumentVar(oWord,"CONDPG",SubStr(SE4->E4_DESCRI,1,15))

OLE_SetDocumentVar(oWord,"TOTALMERC",Transform(xMoeda(nTotal,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),PesqPict("SC7","C7_VLDESC",14, mv_par12)))

OLE_SetDocumentVar(oWord,"EMISSAO",SC7->C7_EMISSAO)
li++
li++
dbSelectArea("SM4")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_REAJUST)
dbSelectArea("SC7")

OLE_SetDocumentVar(oWord,"REAJUSTE",Transform(SC7->C7_REAJUST,PesqPict("SC7","c7_reajust",,mv_par12)))


If cPaisLoc == "BRA"

    OLE_SetDocumentVar(oWord,"VLIPI",Transform(xMoeda(nTotIPI,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),PesqPict("SC7","C7_VLDESC",14, mv_par12)))

    OLE_SetDocumentVar(oWord,"VLICMS",Transform(xMoeda(nTotIcms,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),PesqPict("SC7","C7_VLDESC",14, mv_par12)))
Else	

EndIf

li++

OLE_SetDocumentVar(oWord,"VLFRETE",Transform(xMoeda(nTotFrete,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),PesqPict("SC7","C7_VLDESC",14, mv_par12)))

OLE_SetDocumentVar(oWord,"DESPESA",Transform(xMoeda(nTotDesp,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),PesqPict("SC7","C7_VLDESC",14, mv_par12)))


	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
   OLE_SetDocumentVar(oWord,"OBS01",cObs01)
   OLE_SetDocumentVar(oWord,"OBS02",cObs02)
   OLE_SetDocumentVar(oWord,"OBS03",cObs03)


dbSelectArea("SC7")
If !Empty(SC7->C7_APROV)
	lNewAlc := .T.

    //Alterado por LCM para buscar Codigo do Comprador    
    DbSelectArea("SC1")                        
    SC1->(dbSetOrder(1))
    SC1->(DbSeek(xFilial("SC1")+SC7->C7_NUMSC)) // Verifica a SC
    DbSelectArea("SY1")                        
    SY1->(dbSetOrder(1))
    SY1->(DbSeek(xFilial("SY1")+SC1->C1_CODCOMP))// Acha o Codigo do Comprador
    cComprador := SY1->Y1_NOME
    DbSelectArea("SC7")                        
	If SC7->C7_CONAPRO != "B"
		lLiber := .T.
	EndIf
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM)
	While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM)==xFilial("SCR")+SC7->C7_NUM .And. SCR->CR_TIPO == "PC"
	  cAprov += AllTrim(UsrFullName(SCR->CR_USER))+" ["+;
	 	  IF(SCR->CR_STATUS=="03","Ok",IF(SCR->CR_STATUS=="04","BLQ","??"))+"] - "
	  dbSelectArea("SCR")
	  dbSkip()
	Enddo
	If !Empty(SC7->C7_GRUPCOM)
		dbSelectArea("SAJ")
		dbSetOrder(1)
		dbSeek(xFilial()+SC7->C7_GRUPCOM)
		While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
			If SAJ->AJ_USER != SC7->C7_USER
				cAlter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
			EndIf
			dbSelectArea("SAJ")
			dbSkip()
		EndDo
	EndIf
EndIf

li++

OLE_SetDocumentVar(oWord,"SEGURO",Transform(xMoeda(nTotSeguro,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),PesqPict("SC7","C7_VLDESC",14, mv_par12)))

If !lNewAlc

    If nItensc > Limite

       OLE_SetDocumentVar(oWord,"TOTALGER",Transform(xMoeda(nTotal+nTotIPI,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),PesqPict("SC7","C7_VLDESC",14, mv_par12)))
    Else   
       OLE_SetDocumentVar(oWord,"TOTALGER",Transform(xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),PesqPict("SC7","C7_VLDESC",14, mv_par12)))
    Endif
Else
	If lLiber

	    If nItensc > Limite

	       OLE_SetDocumentVar(oWord,"TOTALGER",Transform(xMoeda(nTotal+nTotIPI,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),PesqPict("SC7","C7_VLDESC",14, mv_par12)))
	    Else   
	       OLE_SetDocumentVar(oWord,"TOTALGER",Transform(xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF),PesqPict("SC7","C7_VLDESC",14, mv_par12)))
	    Endif
	Else
        OLE_SetDocumentVar(oWord,"STATUSPC","P E D I D O   B L O Q U E A D O !!!")

	EndIf
EndIf

If !lNewAlc

   OLE_SetDocumentVar(oWord,"TPFRETE",IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " )))
   OLE_SetDocumentVar(oWord,"COMPRADOR"," ")
   OLE_SetDocumentVar(oWord,"APROVADOR"," ")
   OLE_SetDocumentVar(oWord,"STATUSPC"," ")
	cLiberador := ""
	nPosicao := 0
Else

   OLE_SetDocumentVar(oWord,"STATUSPC",IF(lLiber,"P E D I D O   L I B E R A D O","P E D I D O   B L O Q U E A D O !!!"))
   OLE_SetDocumentVar(oWord,"TPFRETE",IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " )))
   OLE_SetDocumentVar(oWord,"COMPRADOR",Substr(cComprador,1,60))
	nAuxLin := Len(cAprov)
	If Len(cAprov) > 1
      OLE_SetDocumentVar(oWord,"APROVADOR",Substr(cAprov,Len(cAprov)-nAuxLin+1,100))
	Else 
      OLE_SetDocumentVar(oWord,"APROVADOR"," ")
	Endif
	lImpLeg := .T.

EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Labr110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------------------------*
Static Function LabCabec()
*-----------------------------------------------*

Local cCGC
LOCAL cMoeda
// Variaveis a serem usadas na Montagem do Documento no Word    

cMoeda := Iif(mv_par12<10,Str(mv_par12,1),Str(mv_par12,2))
OLE_SetDocumentVar(oWord,"nMoeda",GetMV("MV_MOEDA"+cMoeda))


If ( Mv_PAR08==2 )

    OLE_SetDocumentVar(oWord,"NUMPC",SC7->C7_NUMSC+"/"+SC7->C7_NUM)
Else

    OLE_SetDocumentVar(oWord,"NUMPC",Transform(SC7->C7_NUM,PesqPict("SC7","c7_num")))
EndIf

OLE_SetDocumentVar(oWord,"PAGINA",Str(nOrdem,1))
OLE_SetDocumentVar(oWord,"NEMISSAO",IIf(SC7->C7_QTDREEM>0,Alltrim(Str(SC7->C7_QTDREEM+1,2))," "))
OLE_SetDocumentVar(oWord,"NOM_CLI",SM0->M0_NOMECOM)
OLE_SetDocumentVar(oWord,"END_CLI",Upper(Alltrim(SM0->M0_ENDENT)))
OLE_SetDocumentVar(oWord,"BAI_CLI",Upper(Alltrim(SM0->M0_BAIRENT)))
OLE_SetDocumentVar(oWord,"UF_CLI",SM0->M0_ESTENT)
OLE_SetDocumentVar(oWord,"EMAI_CLI","relatorio@gefco.com.ar")
OLE_SetDocumentVar(oWord,"CEP_CLI",Trans(SM0->M0_CEPENT,cCepPict))
OLE_SetDocumentVar(oWord,"MUN_CLI",Upper(AllTrim(SM0->M0_CIDENT)))                                              
OLE_SetDocumentVar(oWord,"TEL_CLI",Alltrim(SM0->M0_TEL))
OLE_SetDocumentVar(oWord,"FAX_CLI",Alltrim(SM0->M0_FAX))
OLE_SetDocumentVar(oWord,"CNPJCLI",Transform(SM0->M0_CGC,cCgcPict))


dbSelectArea("SA2")
SA2->(dbSetOrder(1))
SA2->(dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))


c_Mail    := SA2->A2_EMAIL
c_NomeFor := SA2->A2_NOME

OLE_SetDocumentVar(oWord,"CODFOR",SA2->A2_COD+"/"+SA2->A2_LOJA)
OLE_SetDocumentVar(oWord,"NOMFOR",Substr(SA2->A2_NOME,1,35))
OLE_SetDocumentVar(oWord,"INSEFOR",SA2->A2_INSCR)
OLE_SetDocumentVar(oWord,"ENDFOR",SA2->A2_END)
OLE_SetDocumentVar(oWord,"BAIFOR",AllTrim(SA2->A2_BAIRRO))
OLE_SetDocumentVar(oWord,"MUNFOR",AllTrim(SA2->A2_MUN))
OLE_SetDocumentVar(oWord,"UFFOR",SA2->A2_EST)
OLE_SetDocumentVar(oWord,"CEPFOR",SA2->A2_CEP)
OLE_SetDocumentVar(oWord,"EMAIFOR",SA2->A2_EMAIL)


dbSelectArea("SX3")
nOrden = IndexOrd()
dbSetOrder(2)
dbSeek("A2_CGC")
cCGC := Alltrim(X3TITULO())

dbSetOrder(nOrden)

dbSelectArea("SA2")
OLE_SetDocumentVar(oWord,"CNPJFOR",Transform(SA2->A2_CGC,PesqPict("SA2","A2_CGC")) )
OLE_SetDocumentVar(oWord,"CONTATO",SC7->C7_CONTATO)
OLE_SetDocumentVar(oWord,"TELFOR","("+Substr(Alltrim(SA2->A2_DDD),1,3)+") "+Substr(SA2->A2_TEL,1,15))
OLE_SetDocumentVar(oWord,"FAXFOR","("+Substr(SA2->A2_DDD,1,3)+") "+Substr(Alltrim(SA2->A2_FAX),1,15))

dbSelectArea("SC7")
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R110Center³ Autor ³ Jose Lucas            ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Centralizar o Nome do Liberador do Pedido.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpC1 := R110CenteR(ExpC2)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Nome do Liberador                                 ³±±
±±³Parametros³ ExpC2 := Nome do Liberador Centralizado                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Labr110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------------------------*
Static Function R110Center(cLiberador)
*-------------------------------------------*
Return( Space((30-Len(AllTrim(cLiberador)))/2)+AllTrim(cLiberador) )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Alexandre Lemes     º Data ³ 17/12/2002  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Labr110                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------------*
Static Function AjustaSX1()
*----------------------------------*
 
PutSx1("GEFR13","13","Endereco de Entrega ? ","Local de Entrega              ","Delivery Address              ",;
       "mv_chd","C",40,0,0,"G","","","","","mv_par13","","","","","","","","","","","","","","","","",;
       {"Forneca o endereco ou sera impresso o  ","endereco que consta no arquivo SM0.   "},;
       {"                                       ","                                      "},;
       {"                                       ","                                      "})
PutSx1("GEFR13","14","Local Gravacao DOC ? ","Local Gravacao DOC ? ","Local Gravacao DOC ? ",;
       "mv_che","C",40,0,0,"G","","","","","mv_par14","","","","","","","","","","","","","","","","",;
       {"Forneca o endereco do Modelo Pedido ","de Compras.  "},;
       {"                                       ","                                      "},;
       {"                                       ","                                      "})  
PutSx1("GEFR13","15","E-mail do Comprador ? ","E-mail do Comprador ? ","E-mail do Comprador ? ",;
       "mv_chf","C",40,0,0,"G","","","","","mv_par15","","","","","","","","","","","","","","","","",;
       {"Forneca o e-mail do comprador do Pedido ","de Compras.  "},;
       {"                                       ","                                      "},;
       {"                                       ","                                      "})

Return


*----------------------------------------------*
User Function fEnviamail(aVetor,NumPed)
*----------------------------------------------*
*Fc para envio de e-mail com arquivo anexado
*----------------------------------------------*

Local oDlg     := NIL
Local cMask    := "Todos os arquivos (*.*) |*.*|"
Local oMsg

Private cTitulo  := "Criar e-mail"
Private cServer  := Trim(GetMV("MV_RELSERV")) // smtp.ig.com.br ou 200.181.100.51
Private cEmail   := Trim(GetMV("MV_RELACNT")) // fulano@ig.com.br
Private cPass    := Trim(GetMV("MV_RELPSW"))  // 123abc

Private cDe      := Trim(GetMV("MV_RELFROM")) // ALLTRIM(cCompMail) //"GEFCO - PEDIDO DE COMPRAS"
Private cPara    := c_Mail
Private cCc      := ALLTRIM(cCompMail) // Space(200)
Private cAssunto := "Pedido de Compras "+ " - " + NumPed
Private cAnexo   := "" //cDoc
Private cMsg     := "Segue em anexo Pedido de Compra."

If !empty(MV_PAR16)
	cMsg := alltrim(MV_PAR16) 
Else
	cMsg := "Segue em anexo Pedido de Compra."    

EndIf

If !empty(MV_PAR17)
	cAssunto := alltrim(MV_PAR17) + " - " + NumPed
Else
	cAssunto := "Pedido de Compra" + " - " + NumPed

EndIf

For i:= 1 to Len(aVetor)  
	if i = len(aVetor)
		cAnexo += aVetor[i][1]
	else
	   cAnexo += aVetor[i][1] + ";"
	endif
Next

If Empty(cServer) .And. Empty(cEmail) .And. Empty(cPass)
   MsgAlert("Não foi definido os parâmetros do server do Protheus para envio de e-mail",cTitulo)
   Return
Endif                                                

//cAnexo := "\DOC\000845-1-01.DOC"

Processa ({|| Validar()}) 
Processa ({|| Enviar()}) 

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

//Local lResulConn := .T.
//Local lResulSend := .T.
//Local cError := ""

U_EnvEmail(cDe,cPara,cCc,cAssunto,cMsg,cAnexo)
/*
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
*/
RETURN(.T.)