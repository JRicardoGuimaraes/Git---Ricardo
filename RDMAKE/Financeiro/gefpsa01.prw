#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"    
#INCLUDE "TOPCONN.CH"

/************************************************************************************
* Programa.......: GEFPSA01()                                                       *
* Autor..........: Marcelo Aguiar Pimentel                                          *
* Data...........: 05/03/2007                                                       *
* Descricao......: Retorno de faturas PSA para baixa                                *
*                                                                                   *
*************************************************************************************
* Modificado por.: J Ricardo                                                        *
* Data...........: 04/09/07                                                         *
* Motivo.........: Incluir totalizadores no relatório e na tela                     *
*                                                                                   *
*************************************************************************************
* Modificado por..: J Ricardo                                                       *
* Data............: 29-10-2007                                                      *
* Motivo..........: Passar pagar o NF no faturamento através do No. NF-e            *
*                                                                                   *
*************************************************************************************/

USER FUNCTION GEFPSA01()
Local 	nOpcao	:=	0
Private oDlgPSA
Private cPath	:=	space(255)
Private aFiles	:= {}

SetKey (VK_F3,{|a,b| cPath:=cGetFile( "Arqvuivo de Interface (.txt) | *.txt ",OemToAnsi("Selecione O Arquivo"),,"d:",.f.,GETF_LOCALHARD+GETF_RETDIRECTORY)})
@ 200,1 TO 380,380 DIALOG oDlgPSA TITLE OemToAnsi("Importação de Faturas PSA")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um ou mais arquivo(s), contido"
@ 18,018 Say " no diretório informado abaixo com extencao .txt"
@ 26,018 Say "                                                            "
@ 34,018 Say "Diretório: "
@ 32,050 Get cPath Picture "@!" Size 60,20
@ 32,110 BUTTON "..." SIZE 10,10 ACTION (cPath:=cGetFile( "Arqvuivo de Interface (.txt) | *.txt ",OemToAnsi("Selecione O Arquivo"),,"d:",.f.,GETF_LOCALHARD+GETF_RETDIRECTORY))
@ 60,128 BMPBUTTON TYPE 01 ACTION (nOpcao:=1,fProcessa(),Close(oDlgPSA))
@ 60,158 BMPBUTTON TYPE 02 ACTION (nOpcao:=2,Close(oDlgPSA))

Activate Dialog oDlgPSA Centered

SetKey (VK_F3,{||})
Return

STATIC FUNCTION fProcessa()
Private cEOL    := 	"CHR(13)+CHR(10)"
cPath:=alltrim(cPath)
If substr(cPath,len(cPath),1) != "\"
	cPath+="\"
EndIf
aFiles := Directory(cPath + "*.txt")

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If len(aFiles) > 0
	Processa({|| RunImport() },"Processando...")
Else
	APMsgAlert("Não foi possível encontrar arquivo na pasta informada!")
EndIf
Return

Static Function RunImport()
Private nTamFile, nTamLin, cBuffer, nBtLidos
Private aHdl		:=	{}
Private nSizeTot	:=	0
Private cBanco	 := CRIAVAR("A6_COD")
Private cAgencia := CRIAVAR("A6_AGENCIA")
Private cConta	 := CRIAVAR("A6_NUMCON")

private oOk		:= 	LoadBitMap(GetResources(), "LBOK")
private oNo		:= 	LoadBitMap(GetResources(), "LBNO")
Private olblist := 	nil
Private cPict	:=	"@E 99,999,999,999.99"
Private aCab	:= 	{ " ","Filial","Prefixo","Numero","Tipo","Natureza","Cliente","Loja","Banco","Agencia","Conta","Nome","Emissao","Vencimento","Venc.Real","Baixar","Saldo","Dieferença","Moeda"}
Private aPic 	:= 	{ " ","@!"    ,"@!"     ,"@!"    ,"@!"  ,"@!"      ,"@!"     ,"@!"  ,"@!"   ,"@!"     ,"@!"   ,"@!"  ,"@D"     ,"@D"        ,"@D"       ,cPict   ,cPict  ,cPict       ,"@!"   }
Private aSizeCol:= 	{ 10 ,10      , 10      ,20      ,10    ,10        ,20       ,10    ,10     ,10       ,10     ,20    ,10       ,10          ,10         ,20      ,20     ,20          , 5     }
Private aTit	:= 	{}

Private nTotal  := 0.00
Private oTotal

/*
For nX:=1 to len(aFiles)
	aAdd(aHdl,fOpen(cPath+aFiles[nX,1],68))
	nSizeTot+=aFiles[nX,2]
Next nX
*/

// Por: Ricardo - Em: 10/06/2009 - F12 da rotina FINA070 - Baixa
Pergunte("FIN070",.T.)

For nX:=1 to len(aFiles)
	aAdd(aHdl,fOpen(cPath+aFiles[nX,1],68))
	nSzImp:=aFiles[nX,2]
	cBuffer  := Space(nSzImp)

 	fRead(aHdl[nX],@cBuffer,3)
	// Por: Ricardo - Em: 17/10/2007
 	// O IF abaixo foi colocado devido o arquivo ora vir com 3 caracter estranha no inicio e ora não
 	If Left(cBuffer,1)=="-"
		fSeek(aHdl[nX],0,0)
 	EndIf
	nBtLidos := fRead(aHdl[nX],@cBuffer,nSzImp) // Leitura da primeira linha do arquivo texto]
	cBuffer:=FTira_Ace(cBuffer)
//	cBuffer:=ConvCarEsp(cBuffer,.f.)
	fClose(aHdl[nX])
	aFiles[nX,1]:=substr(aFiles[nX,1],1,len(aFiles[nX,1])-3)+"imp"
	nHdl:=fCreate(cPath+aFiles[nX,1])
	fWrite(nHdl,cBuffer)
	fClose(nHdl)
	aHdl[nX]:=fOpen(cPath+aFiles[nX,1],68)
	nSizeTot+=aFiles[nX,2]
Next nX

nPerc:=0
fSeek(aHdl[1],0,0)
nTamLin  := 140 +Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

ProcRegua((nSizeTot-((nTamLin*12)*Len(aFiles)))/nTamLin) // Numero de registros a processar

lMsErroAuto := .F.
nRead:=0
aTit:={}
aTitVlr:={}
cFilNaoP:="" //Filial Nao Processada
For nX:=1 to len(aFiles)
	nBtLidos := fRead(aHdl[nX],@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto]
	nBtLidos := fRead(aHdl[nX],@cBuffer,nTamLin) // Leitura da próxima linha
	cFil		:=substr(cBuffer,25,6)   
	// Precisa incluir filial Gefco e excluir os deletados na consulta abaixo.
	cQry:="SELECT ZC_FILIAL FROM "+RetSqlName("SZC")
	cQry+=" WHERE ZC_FILSAP = '"+cFil+"'"
	TcQuery cQry Alias "TSZC" New
	cFilSAP		:=cFil
	cFil		:=TSZC->ZC_FILIAL
	dbCloseArea("TSZC")
	If cFil = cFilAnt	
		nMais:=0
		nBtLidos 	:= fRead(aHdl[nX],@cBuffer,(nTamLin*7)+nMais) // Posicione na linha de detalhes
		While nBtLidos >= nTamLin
			nBtLidos 	:= fRead(aHdl[nX],@cBuffer,nTamLin) // Leitura da linha de detalhes
			IncProc()
			cVencto		:=ctod(substr(cBuffer,10,8))
			nValor		:=substr(cBuffer,45,12)
			nValor		:=val(Left(nValor,At(",",nValor)-1)+"."+Right(nValor,2))
			cTitulo		:=substr(cBuffer,59,6)
			cPrefixo	:=substr(cBuffer,136,3)

			// Por: J Ricardo - Em: 09/09/2009
			If .NOT. (AllTrim(cPrefixo) $ "CTR|CTV|CTA|UNI|UNI|UNS")
				cTitulo := StrZero(Val(cTitulo),TamSX3("E1_NUM")[1])
			EndIf
			
			// Por: J Ricardo - Em: 19/11/2009
			ALERT(cPrefixo)
			alert(cfil)
			If AllTrim(cPrefixo) == "CTR" .AND. ( cFil $ "03|06|08|07")
				If cVencto >= ctod('01/07/10')  // Inicio da Operação de Porto Real - 3a. Filial a implantar o TMS
					cTitulo := StrZero(Val(cTitulo),TamSX3("E1_NUM")[1])
				EndIf	
			EndIf
			
			// Por: J Ricardo - Em: 29/10/2007
			// If AllTrim(cPrefixo) == "1" .AND. cFil $ "11|06|"
			If AllTrim(cPrefixo) == "1" .AND. cFil == "11"
				dbSelectArea("SF2") ; dbSetOrder(8)  // NF Eletronica.
				// If dbSeek(xFilial("SF2")+"00"+cTitulo)
				If dbSeek(xFilial("SF2")+Right(cTitulo,TamSX3("F2_NFELETR")[1]))
					cTitulo := SF2->F2_DOC
				EndIf
			ElseIf AllTrim(cPrefixo) == "RPS"
				dbSelectArea("SF2") ; dbSetOrder(8)  // NF Eletronica.
				If dbSeek(xFilial("SF2")+Right(cTitulo,TamSX3("F2_NFELETR")[1]))
					cTitulo := SF2->F2_DOC
				Else
					cTitulo := StrZero(Val(cTitulo),TamSX3("E1_NUM")[1])
				EndIf
			EndIf
			
			If !Empty(cVencto)
				cQry:="SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_TIPO,E1_NATUREZ,E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_EMISSAO,"
				cQry+="       E1_VENCTO,E1_VENCREA,E1_BAIXA,E1_SALDO,E1_MOEDA,E1_SITUACA"
				cQry+="  FROM "+RetSqlName("SE1")
				cQry+=" WHERE E1_FILIAL = '"+cFil+"'"
				cQry+=" AND E1_NUM 		= '"+cTitulo+"'"
				cQry+=" AND E1_PREFIXO 	= '"+cPrefixo+"'"
				cQry+=" AND D_E_L_E_T_ <> '*'"
				TcQuery cQry Alias "TSE1" New
				If !Eof()
					aAdd(aTit,{oOk,TSE1->E1_FILIAL,TSE1->E1_PREFIXO,TSE1->E1_NUM,TSE1->E1_TIPO,TSE1->E1_NATUREZ,;
					               TSE1->E1_CLIENTE,TSE1->E1_LOJA,cBanco,cAgencia,cConta,TSE1->E1_NOMCLI        ,stod(TSE1->E1_EMISSAO),stod(TSE1->E1_VENCTO),;
					               stod(TSE1->E1_VENCREA),Transform(nValor,cPict),Transform(TSE1->E1_SALDO,cPict),;
					               Transform(TSE1->E1_SALDO-nValor,cPict),TSE1->E1_MOEDA,TSE1->E1_SITUACA,;
					               nValor,TSE1->E1_SALDO,TSE1->E1_SALDO-nValor,.t.})//Valores sem mascara
	
					aAdd(aTitVlr,{oOk,TSE1->E1_FILIAL,TSE1->E1_PREFIXO,TSE1->E1_NUM,TSE1->E1_TIPO,TSE1->E1_NATUREZ,;
					               TSE1->E1_CLIENTE,TSE1->E1_LOJA,cBanco,cAgencia,cConta,TSE1->E1_NOMCLI        ,stod(TSE1->E1_EMISSAO),stod(TSE1->E1_VENCTO),;
					               stod(TSE1->E1_VENCREA),nValor,TSE1->E1_SALDO,;
					               TSE1->E1_SALDO-nValor,TSE1->E1_MOEDA,TSE1->E1_SITUACA,;
					               nValor,TSE1->E1_SALDO,TSE1->E1_SALDO-nValor,.t.})//Valores sem mascara
					nTotal += nValor					               
				Else
					aAdd(aTit,{oNo,cFil           ,cPrefixo        ,cTitulo     ,"   "           ,"   "              ,;
					               "      "       ,"  "            ,cBanco,cAgencia,cConta,"TIT. NAO ENCONTRADO","        "        ,"        "    ,;
					               cVencto     ,Transform(nValor,cPict) ,0             ," ","",.f.})
					aAdd(aTitVlr,{oNo,cFil           ,cPrefixo        ,cTitulo     ,"   "           ,"   "              ,;
					               "      "       ,"  "            ,cBanco,cAgencia,cConta,"TIT. NAO ENCONTRADO","        "        ,"        "    ,;
					               cVencto     ,Transform(nValor,cPict) ,0             ," ","",.f.})
				EndIf
				dbCloseArea()
			EndIf
		EndDo
	Else
		cFilNaoP+="Filial: ("+cFil+")-"+cFilSAP+" nao importado."+chr(10)
	EndIf	
	fClose(aHdl[nX])
	fErase(cPath+aFiles[nX,1])
Next nX	
If !Empty(cFilNaoP)
	APMsgAlert("Relação de filiais não importadas por não pertencerem a filial("+cFilAnt+"):"+chr(10)+cFilNaoP)
	If len(aTit) = 0
		return
	EndIf
EndIf
aButtons:={}
Aadd(aButtons,{'BUDGETY', {|| fBancoF3()}, "Banco - F3"})
SetKey (VK_F3,{|a,b| fBancoF3()})
DEFINE MSDIALOG oDlg2 TITLE OemToAnsi("Retorno de Faturas a Receber - PSA") FROM 078,022 TO 115,115 //OF oMainWnd 
olblist  := TWBrowse():New(  1 , 1 , 0355, 240 ,,aCab,aSizeCol,,,,,,,,,,,,, .F.,, .F.,, .F.,,, )
olblist:SetArray(aTit)
// olblist:bLDblClick := {||aTit[olblist:nAt][1] := if(aTit[olblist:nAt][1]=ook,ono,iif(aTit[olblist:nAt][9]!="TIT. NAO ENCONTRADO",ook,oNo)), oDlg2:Refresh()}
olblist:bLDblClick := {||aTit[olblist:nAt][1] := fMark(), oDlg2:Refresh()}
olblist:bLine      := {||LinBrw(olblist, aTit)}
olblist:lAutoEdit  := .T.

@ 260,030 SAY "Total : " 
@ 260,050 GET nTotal When .F. Picture "@E 999,999,999.99" SIZE 100,20 Object oTotal

Activate MSDialog oDlg2 ON INIT ;
EnchoiceBar(oDlg2, {|| nOpca := 2,iIf(fVldBanco(),(fBaixar(),oDlg2:End(),fRela()),)},{|| nOpca := 1,oDlg2:End()},,aButtons);
Centered

SetKey (VK_F3,{||})
Return

Static Function fVldBanco()
Local lRet:=.t.
For nX:=1 to len(aTit)
	If aTit[nX,01] = oOk
		If aTit[nX,01] = oOk .and. Empty(aTit[nX,09]) .or. Empty(aTit[nX,10]) .or. Empty(aTit[nX,10])
			lRet:=.f.
		EndIf
	EndIf
Next nX
If !lRet
	ApMsgAlert("Há dados de Banco não preenchido!")
EndIf
Return lRet


Static Function fBancoF3()
Local oDlgBnc
Local oBanco
Local oAgencia
Local oConta
Local lRet:=.f.
PRIVATE cBanco	 := CRIAVAR("A6_COD")
PRIVATE cAgencia := CRIAVAR("A6_AGENCIA")
PRIVATE cConta	 := CRIAVAR("A6_NUMCON")
PRIVATE lcbReplic:=.T.

// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.                         
Private INCLUI := .F.                        
Private ALTERA := .F.                        
Private DELETA := .F.                        

cBanco	:=aTit[olblist:nAt,09]
cAgencia:=aTit[olblist:nAt,10]
cConta	:=aTit[olblist:nAt,11]

SetKey (VK_F3,{||})

DEFINE MSDIALOG oDlgBnc TITLE "Banco" FROM C(198),C(181) TO C(293),C(567) PIXEL

	// Cria as Groups do Sistema
	@ C(000),C(002) TO C(047),C(158) LABEL "" PIXEL OF oDlgBnc

	// Cria Componentes Padroes do Sistema
	@ C(008),C(005) Say "Banco:" Size C(019),C(008) COLOR CLR_BLACK PIXEL OF oDlgBnc
	@ C(008),C(050) Say "Agência:" Size C(023),C(008) COLOR CLR_BLACK PIXEL OF oDlgBnc
	@ C(008),C(092) Say "Conta:" Size C(017),C(008) COLOR CLR_BLACK PIXEL OF oDlgBnc
	@ C(017),C(005) MsGet oBanco Var cBanco F3 "SA6"  VALID CarregaSa6(@cBanco,,,.T.) Size C(032),C(009) COLOR CLR_BLACK PIXEL OF oDlgBnc
	@ C(017),C(050) MsGet oAgencia Var cAgencia  VALID CarregaSa6(@cBanco,@cAgencia,,.T.) Size C(034),C(009) COLOR CLR_BLACK PIXEL OF oDlgBnc
	@ C(017),C(092) MsGet oConta Var cConta  VALID CarregaSa6(@cBanco,@cAgencia,@cConta,.T.) Size C(060),C(009) COLOR CLR_BLACK PIXEL OF oDlgBnc
    @ C(032),C(005) CheckBox ocbReplic Var lcbReplic Prompt "Replicar para todos." Size C(069),C(008) PIXEL OF oDlgBnc
	DEFINE SBUTTON FROM C(006),C(162) TYPE 1 ENABLE OF oDlgBnc ACTION (lRet:=.t.,oDlgBnc:End())
	DEFINE SBUTTON FROM C(020),C(162) TYPE 2 ENABLE OF oDlgBnc ACTION (lRet:=.f.,oDlgBnc:End())

ACTIVATE MSDIALOG oDlgBnc CENTERED 

If lRet
	If lcbReplic
		For nX:=1 to len(aTit)
			aTit[nX,09]:=cBanco
			aTit[nX,10]:=cAgencia
			aTit[nX,11]:=cConta
		Next nX
	Else
		aTit[olblist:nAt,09]:=cBanco
		aTit[olblist:nAt,10]:=cAgencia
		aTit[olblist:nAt,11]:=cConta
	EndIf
EndIf
SetKey (VK_F3,{|a,b| fBancoF3()})
Return lRet

Static Function LinBrw(olblista,A_NF)
Local V_I:=0, a_Line:={}
For V_I := 1 To len(olblista:aheaders)
	AAdd( a_Line,A_NF[olblista:nAt,V_I] )
Next
Return( a_Line )

Static Function fBaixar()
Local _nValor       := 0
Local _lPrim		:= .T.

Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.
Private Valor       := 0
/*
For nX:=1 to Len(aTit) 
	If aTit[nX,1] = oOk
		Valor += aTitVlr[nX,16] // Usado pelo LP 520-003 durante a contabilização
	EndIf
Next nX
*/
For nX:=1 to len(aTit)
	If aTit[nX,1] = oOk
		cHist:="Baixa CR-"+aTit[nX,02]+"-"+aTit[nX,03]+"-"+aTit[nX,04]
		olblist:nAt:=nX
		olblist:Refresh()

		 aVetor := {    {"E1_FILIAL"    ,aTit[nX,02] ,Nil},;
		                {"E1_PREFIXO"	,aTit[nX,03] ,Nil},;
		 				{"E1_NUM"	    ,aTit[nX,04] ,Nil},;
		 				{"E1_PARCELA"   ," "          ,Nil},;
						{"E1_TIPO"	    ,aTit[nX,05] ,Nil},;
						{"E1_CLIENTE"   ,aTit[nX,07] ,Nil},;
						{"E1_LOJA"      ,aTit[nX,08] ,Nil},;
						{"AUTMOTBX"	    ,"NOR"       ,Nil},;
						{"AUTDTBAIXA"   ,dDataBase   ,Nil},;
						{"AUTDTCREDITO" ,dDataBase   ,Nil},;
						{"AUTBANCO"     ,aTit[nX,09] ,Nil},;
						{"AUTAGENCIA"   ,aTit[nX,10] ,Nil},;
						{"AUTCONTA"     ,aTit[nX,11] ,Nil},;
						{"AUTHIST"	    ,cHist,Nil},;
						{"AUTVALREC"	,aTitVlr[nX,16] ,Nil }}

   		MSExecAuto({|x,y| FINA070(x,y)},aVetor,3) //Inclusao
 	   	If lMsErroAuto
 	   		aTit[nX,len(aTit[nX])] := .f.
	    	MostraErro()
	    	lMsErroAuto := .f.
    	
	   	Else 
	   	    // Força a gravação do filorig no se5 para contabilização 
	   	    Reclock("SE5" , .F. ) 
	   	    	SE5->E5_FILORIG   := SE5->E5_FILIAL 
	   	    Msunlock()
	   	    
			// Por: Ricardo - Em: 14/01/2010 - Objetivo: A contabilização passou a lançar o Total dos títulos a Débito
			If _lPrim
				Valor  := 0
				_lPrim := .F.
			EndIf			   	    
	   	EndIf
	Else
   		aTit[nX,len(aTit[nX])]:=.f.
	EndIf
	
Next nX

Return

Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³Tratamento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)


Static Function fRela()
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "Relatorio de titulos baixados/nao baixados"
Local nLin           := 80

//                     0        1         2         3         4         5         6         7         8         9         10        11
//                     12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                      99  999999   99 999999999999999999999     999 999999  999 99/99/99  99,999,999,999.99  N.BAIXADO 
//                      2   6        15 18                        44  48      56  60        70                 89
Local Cabec1       := "Fil Cliente Loja Nome                  Prefixo Numero Tipo    Vnc.R     Saldo a baixar  Status"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey         := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GEFRET" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nOrdem

Local nTotBai        := 0
Local nTotNaoBai     := 0
Local nTotG          := 0     
Local _cValor 		 := ""

SetRegua(len(aTit))

For i:= 1 to len(aTit)
	IncRegua()
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

	// Retiro os pontos e substitui a Vírgula pelo ponto
	_cValor := StrTran(aTit[i,16],".","")
	_cValor := StrTran(_cValor,",",".")

	If aTit[i,1] = oOk .OR. (aTit[i,1] = oNo .and. aTit[i,12]!="TIT. NAO ENCONTRADO")
//                      2   6        15 18                        44  48      56  60        70                 99
//Local Cabec1      := "Fil Cliente Loja Nome                  Prefixo Numero Tipo    Vnc.R     Saldo a baixar  Status"
  		@nLin,02 PSAY aTit[i,2] Picture "@!"
  		@nLin,06 PSAY aTit[i,7] Picture "@!"
  		@nLin,15 PSAY aTit[i,8] Picture "@!"
  		@nLin,18 PSAY aTit[i,12] Picture "@!"
  		@nLin,44 PSAY aTit[i,3] Picture "@!"
  		@nLin,48 PSAY aTit[i,4] Picture "@!"
  		@nLin,56 PSAY aTit[i,5] Picture "@!"
  		@nLin,60 PSAY aTit[i,15]
  		@nLin,70 PSAY aTit[i,16]
	    @nLin,89 PSAY iif(aTit[i,len(aTit[i])],"Baixa efetuada","Nao baixado")
        // Totalização - Por: J Ricardo - Em: 04/09/07		
		nTotBai += Val(_cValor)	    
	Else
  		@nLin,02 PSAY aTit[i,2] Picture "@!"
//  		@nLin,06 PSAY aTit[i,7] Picture "@!"
//  		@nLin,15 PSAY aTit[i,8] Picture "@!"
  		@nLin,18 PSAY "TITULO NAO ENCONTRADO" Picture "@!"
  		@nLin,44 PSAY aTit[i,3] Picture "@!"
  		@nLin,48 PSAY aTit[i,4] Picture "@!"
//  		@nLin,56 PSAY aTit[i,5] Picture "@!"
  		@nLin,60 PSAY aTit[i,15]
  		@nLin,70 PSAY aTit[i,16]
	    @nLin,89 PSAY iif(aTit[i,len(aTit[i])],"Baixa efetuada","Nao baixado")
        // Totalização - Por: J Ricardo - Em: 04/09/07	    
	    nTotNaoBai += Val(_cValor)
	EndIf

   nLin  := nLin + 1 // Avanca a linha de impressao
   
   // Totalização - Por: J Ricardo - Em: 04/09/07
   nTotG += Val(_cValor)
   
Next i

@++nLin,02 PSAY REPLICATE("-",Limite)
@++nLin,02 PSAY "Total Não Baixado : " + Transform(nTotNaoBai, "@E 999,999,999.99")
@++nLin,02 PSAY "Total Baixado     : " + Transform(nTotBai   , "@E 999,999,999.99")
@++nLin,02 PSAY "Total Geral       : " + Transform(nTotG     , "@E 999,999,999.99")

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


//
// Funcao para Retirar os Acentos dos Campos do Banco de Dados de Atletas
//
Static Function FTira_Ace(cParam)
//parameters cParam
    do while .t.   
       nPos1 := AT(CHR(131),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"a")
       else
          exit
       endif   
    enddo          
    do while .t.   
       nPos1 := AT(CHR(160),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"a")
       else
          exit
       endif   
    enddo          
    do while .t.   
       nPos1 := AT(CHR(198),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"a")
       else
          exit
       endif   
    enddo          
    do while .t.   
       nPos1 := AT(chr(195),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"")
       else
          exit
       endif   
    enddo          
    do while .t.   
       nPos1 := AT("Ã",cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"")
       else
          exit
       endif   
    enddo          

    do while .t.   
       nPos1 := AT("º",cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"u")
       else
          exit
       endif   
    enddo          

    do while .t.   
       nPos1 := AT(CHR(156),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"a")
       else
          exit
       endif   
    enddo              

    do while .t.   
       nPos1 := AT(CHR(130),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"e")
       else
          exit
       endif   
    enddo              
    do while .t.   
       nPos1 := AT(CHR(136),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"e")
       else
          exit
       endif   
    enddo              
    do while .t.   
       nPos1 := AT(CHR(161),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"i")
       else
          exit
       endif   
    enddo              
    do while .t.   
       nPos1 := AT(CHR(147),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"o")
       else
          exit
       endif   
    enddo              
    do while .t.   
       nPos1 := AT(CHR(148),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"o")
       else
          exit
       endif   
    enddo              
    do while .t.   
       nPos1 := AT(CHR(162),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"o")
       else
          exit
       endif   
    enddo
    do while .t.   
       nPos1 := AT(CHR(228),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"o")
       else
          exit
       endif   
    enddo                                
    do while .t.   
       nPos1 := AT(CHR(229),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"o")
       else
          exit
       endif   
    enddo                                
    do while .t.   
       nPos1 := AT(CHR(163),cParam)
       if nPos1 > 0
//          cParam := stuff(cParam,nPos1,1,"u")
          cParam := stuff(cParam,nPos1,1,"a")
       else
          exit
       endif   
    enddo              

    do while .t.   
       nPos1 := AT(CHR(167),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"c")
       else
          exit
       endif   
    enddo              

    do while .t.   
       nPos1 := AT(CHR(129),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"u")
       else
          exit
       endif   
    enddo              
    do while .t.   
       nPos1 := AT(CHR(233),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"u")
       else
          exit
       endif   
    enddo              
    do while .t.   
       nPos1 := AT(CHR(135),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"c")
       else
          exit
       endif   
    enddo          
    do while .t.   
       nPos1 := AT(CHR(144),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"E")
       else
          exit
       endif   
    enddo              
    do while .t.   
       nPos1 := AT(CHR(212),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"E")
       else              
          exit
       endif   
    enddo              
    do while .t.   
       nPos1 := AT(CHR(181),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"A")
       else
          exit
       endif   
    enddo              
    do while .t.   
       nPos1 := AT(CHR(182),cParam)
       if nPos1 > 0
          cParam := stuff(cParam,nPos1,1,"A")
       else
          exit
       endif   
    enddo              
Return(cParam)



/*
	nBtLidos 	:= fRead(aHdl[nX],@cBuffer,aFiles[nX,2]) // Leitura da linha de detalhes
	np1:=1
	While np1 <> 0
		IncProc()
		np1:=at("Pagto",cBuffer,np1)
		np2:=at("Pagto",cBuffer,np1+1)
		If np2 = 0
			np2:=at("Total",cBuffer,np1+1)
			np3:=np2-np1 
			nP2:=0
		Else
			np3:=np2-np1 
		EndIf
			
		cDet:=substr(cBuffer,np1,np3)
		alert(cDet)
		alert(FTira_Ace(cDet))
		return
		nPa1:=1
		nPa2:=1
		nPa3:=1
		npa1:=at("|",cDet,npa1)+1
		npa2:=at("|",cDet,npa1)
		npa3:=npa2-npa1

		nPa1:=1
		npa2:=1
		npa3:=1
		For nP:=1 to 8
			npa1:=at("|",cDet,npa1)+1
			npa2:=at("|",cDet,npa1)
			npa3:=npa2-npa1
			cTmp:=alltrim(substr(cDet,npa1,npa3))
			NPA1:=NPA2		
			If nP = 1
				cVencto:=ctod(cTmp)
			ElseIf nP = 4
				nValor:=cTmp
				nValor:=val(Left(nValor,At(",",nValor)-1)+"."+Right(nValor,2))
			ElseIf nP = 5
				cTitulo:=substr(cTmp,1,6)
			ElseIf nP = 8
				cPrefixo	:=cTmp
			EndIf
		Next nP

//		cVencto:=ctod(alltrim(substr(cDet,npa1,npa3)))
				
//		cVencto:=ctod(substr(cDet,8,8))
//		nValor:=substr(cDet,43,12)
//		nValor		:=val(Left(nValor,At(",",nValor)-1)+"."+Right(nValor,2))
//		cTitulo:=substr(cDet,57,6)
//		cPrefixo	:=substr(cDet,134,3)
		np1:=np2

		If !Empty(cVencto)
			cQry:="SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_TIPO,E1_NATUREZ,E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_EMISSAO,"
			cQry+="       E1_VENCTO,E1_VENCREA,E1_BAIXA,E1_SALDO,E1_MOEDA,E1_SITUACA"
			cQry+="  FROM "+RetSqlName("SE1")
			cQry+=" WHERE E1_FILIAL = '"+cFil+"'"
			cQry+=" AND E1_NUM 		= '"+cTitulo+"'"
			cQry+=" AND E1_PREFIXO 	= '"+cPrefixo+"'"
			cQry+=" AND D_E_L_E_T_ <> '*'"
			TcQuery cQry Alias "TSE1" New
			If !Eof()
				aAdd(aTit,{oOk,TSE1->E1_FILIAL,TSE1->E1_PREFIXO,TSE1->E1_NUM,TSE1->E1_TIPO,TSE1->E1_NATUREZ,;
				               TSE1->E1_CLIENTE,TSE1->E1_LOJA,cBanco,cAgencia,cConta,TSE1->E1_NOMCLI        ,stod(TSE1->E1_EMISSAO),stod(TSE1->E1_VENCTO),;
				               TSE1->E1_VENCREA,Transform(nValor,cPict),Transform(TSE1->E1_SALDO,cPict),;
				               Transform(TSE1->E1_SALDO-nValor,cPict),TSE1->E1_MOEDA,TSE1->E1_SITUACA,;
				               nValor,TSE1->E1_SALDO,TSE1->E1_SALDO-nValor,.t.})//Valores sem mascara

				aAdd(aTitVlr,{oOk,TSE1->E1_FILIAL,TSE1->E1_PREFIXO,TSE1->E1_NUM,TSE1->E1_TIPO,TSE1->E1_NATUREZ,;
				               TSE1->E1_CLIENTE,TSE1->E1_LOJA,cBanco,cAgencia,cConta,TSE1->E1_NOMCLI        ,TSE1->E1_EMISSAO,TSE1->E1_VENCTO,;
				               TSE1->E1_VENCREA,nValor,TSE1->E1_SALDO,;
				               TSE1->E1_SALDO-nValor,TSE1->E1_MOEDA,TSE1->E1_SITUACA,;
				               nValor,TSE1->E1_SALDO,TSE1->E1_SALDO-nValor,.t.})//Valores sem mascara
			Else
				aAdd(aTit,{oNo,cFil           ,cPrefixo        ,cTitulo     ,""           ,""              ,;
				               ""             ,""            ,cBanco,cAgencia,cConta,"TIT. NAO ENCONTRADO",""              ,cVencto        ,;
				               ""             ,Transform(nValor,cPict) ,0             ,"","",.f.})
				aAdd(aTitVlr,{oNo,cFil           ,cPrefixo        ,cTitulo     ,""           ,""              ,;
				               ""             ,""            ,cBanco,cAgencia,cConta,"TIT. NAO ENCONTRADO",""              ,cVencto        ,;
				               ""             ,nValor ,0             ,"","",.f.})
			EndIf
			dbCloseArea()
		EndIf
	EndDo
*/	

*-------------------------------*
Static Function fMark()       
*-------------------------------*
* Por: J Ricardo - Em: 04/09/05 *
*-------------------------------*
Local _cValor := aTit[olblist:nAt][16]

// Retiro os pontos e substitui a Vírgula pelo ponto
_cValor := StrTran(_cValor,".","")
_cValor := StrTran(_cValor,",",".")

If aTit[olblist:nAt][1]=ook
	nTotal -= val(_cValor)
ElseIf aTit[olblist:nAt][1]=ono
	nTotal += val(_cValor)
EndIf

oTotal:Refresh()

Return if(aTit[olblist:nAt][1]=ook,ono,iif(aTit[olblist:nAt][9]!="TIT. NAO ENCONTRADO",ook,oNo))