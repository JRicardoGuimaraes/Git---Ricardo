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
*************************************************************************************
* Modificado por..: L Passos                                                       *
* Data............: 15-02-2016                                                      *
* Motivo..........: Passar pagar o NF no faturamento através do No. NF-e            *
*                                                                                   *
*************************************************************************************/

USER FUNCTION GEFPSA03() //GEFPSA02()
Local 	nOpcao	:=	0
Private oDlgPSA
Private cPath	:=	space(255)
Private aFiles	:= {}
Private cLote

SetKey (VK_F3,{|a,b| cPath:=cGetFile( "Arqvuivo de Interface (.txt) | *.txt ",OemToAnsi("Selecione O Arquivo"),,"U:",.f.,GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY)})
@ 200,1 TO 380,380 DIALOG oDlgPSA TITLE OemToAnsi("Importação de Faturas PSA")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um ou mais arquivo(s), contido"
@ 18,018 Say " no diretório informado abaixo com extencao .txt"
@ 26,018 Say "                                                            "
@ 34,018 Say "Diretório: "
@ 32,050 Get cPath Picture "@!" Size 60,20
@ 32,110 BUTTON "..." SIZE 10,10 ACTION (cPath:=cGetFile( "Arqvuivo de Interface (.txt) | *.txt ",OemToAnsi("Selecione O Arquivo"),,"U",.f.,GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY))
@ 60,128 BMPBUTTON TYPE 01 ACTION (nOpcao:=1,fProcessa(),Close(oDlgPSA))
@ 60,158 BMPBUTTON TYPE 02 ACTION (nOpcao:=2,Close(oDlgPSA))

Activate Dialog oDlgPSA Centered
  
// Por: Ricardo - Anterior - para atender migracao p/ Argentina
//(cPath:=cGetFile( "Arqvuivo de Interface (.txt) | *.txt ",OemToAnsi("Selecione O Arquivo"),,"d:",.f.,GETF_LOCALHARD+GETF_RETDIRECTORY))

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

//Pergunte("FIN070",.T.)
Pergunte("FIN110",.T.)

// Altero a parâmetro de contabilização on line para contabilização off line
//mv_par04 := 2 // Contabiliza On Line ? (1=Sim ; 2=Nao)
/*
If mv_par04 == 1
	Aviso("A T E N Ç Ã O","Esta rotina só gerará lançamento acumulado a Débito somente se o parâmetro Contabiliza On Line estiver = Nao",{"Ok"})
	Pergunte("FIN070",.T.)	
End
*/
// 20160215 LPassos. Solicitado remover este hardcode
//mv_par04 := 2  // conferir: por isso não está contabilizando. Ele muda o valor do parâmetro [Contabiliza On Line] para 2-Nao
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
//nTamLin  := 140 +Len(cEOL)
nTamLin  := 160 +Len(cEOL)
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
			cTitulo		:=AllTrim(substr(cBuffer,59,9)) // Para 106740-ND ou 042781- remover o traço (e o que estiver após ele) e formatar com zeros à esquerda
			cTitulo		:=PADL(AllTrim(Left(cTitulo, IIF(AT("-", cTitulo )>0,AT("-", cTitulo )-1,LEN(cTitulo)) )),9,"0") //PADL(AllTrim(StrTran( cTitulo, "-", "" )),9,"0")
			// cPrefixo	:=substr(cBuffer,136,3)
			cPrefixo	:=substr(cBuffer,156,3)			
			       
			/***************************************************************************************************************************
			* Por: Ricardo - Em: 25/08/11                                                                                              *
			* Objetivo: A interface Lote I para a tratar prefixo EMB, DTA, RET e PRE, com isso o retorno também houve esta necessidade *
			****************************************************************************************************************************/
			/*If cPrefixo	$ "DTA|RET" .AND. cFil == '03' // TLA
				cPrefixo := "CTV"
			ElseIf cPrefixo	$ "DTA|RET" .AND. cFil <> '03' // TLA
				cPrefixo := "CTA"
			ElseIf cPrefixo	$ "EMB|PRE"  // OVL/OVS
				cPrefixo := "CTR"
			EndIf  *** DESCONTINUAR POIS A REGRA MUDROU ***/	
	 
			// Por: J Ricardo - Em: 27/10/2013
			If cVencto >= ctod('01/11/13') .AND. cPrefixo <> "RPS"
				cPrefixo := "5"
			EndIf
			
			// Tratamento de NFS-e
			If AllTrim(cPrefixo) == "RPS" .OR. AllTrim(cPrefixo) = "9"
				dbSelectArea("SF2") 
				dbSetOrder(8)  // NF Eletronica.     
				If AllTrim(cPrefixo) = "9"
					If dbSeek(xFilial("SF2")+AllTrim(Str(Val(cTitulo))))
						cTitulo := SF2->F2_DOC
						cPrefixo:= SF2->F2_PREFIXO // Atualiza o prefixo com o que foi utilizado no cadastro da nota
					EndIf
				Else
					If dbSeek(xFilial("SF2")+Right(cTitulo,TamSX3("F2_NFELETR")[1]))
						cTitulo := SF2->F2_DOC 
						cPrefixo:= SF2->F2_PREFIXO // Atualiza o prefixo com o que foi utilizado no cadastro da nota
					EndIf
				EndIf				
			EndIf   
			
			If !Empty(cVencto)
				cQry:="SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_TIPO,E1_NATUREZ,E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_EMISSAO,"
				cQry+="       E1_VENCTO,E1_VENCREA,E1_BAIXA,E1_SALDO,E1_MOEDA,E1_SITUACA,R_E_C_N_O_"  // 20160215 LPassos incluindo R_E_C_N_O_
				cQry+="  FROM "+RetSqlName("SE1")
				cQry+=" WHERE E1_FILIAL = '"+cFil+"'"
				cQry+=" AND E1_NUM 		= '"+cTitulo+"'"
				cQry+=" AND E1_SALDO 	= " +Str(nValor) 
				//" AND E1_PREFIXO 	= '"+cPrefixo+"'" //comparar pelo saldo. *** Se já tiver sido baixado não localizará
				cQry+=" AND D_E_L_E_T_ <> '*'"                 
				cQry+=" ORDER BY E1_VENCREA DESC"
				
				TcQuery cQry Alias "TSE1" New
				dbSelectArea("TSE1") ; dbGoTop()
				
				If !Eof()
				   //	While !TSE1->(Eof()) .AND. TSE1->E1_NUM==cTitulo    
						aAdd(aTit,{oOk;
							,TSE1->E1_FILIAL;
							,TSE1->E1_PREFIXO;
							,TSE1->E1_NUM;
							,TSE1->E1_TIPO;
							,TSE1->E1_NATUREZ;
							,TSE1->E1_CLIENTE;
							,TSE1->E1_LOJA;
							,cBanco;   // 09
							,cAgencia;
							,cConta;
							,TSE1->E1_NOMCLI;
							,stod(TSE1->E1_EMISSAO);
							,stod(TSE1->E1_VENCTO);
							,stod(TSE1->E1_VENCREA);
							,Transform(nValor,cPict);
							,Transform(TSE1->E1_SALDO,cPict);
							,Transform(TSE1->E1_SALDO-nValor,cPict);
							,TSE1->E1_MOEDA;
							,TSE1->E1_SITUACA;
							,nValor;
							,TSE1->E1_SALDO;
							,TSE1->E1_SALDO-nValor;
							,TSE1->R_E_C_N_O_; // 24 nova posição para R_E_C_N_O_ para ExecAuto da FINA110
							,.t.;              // fixa porque se refere a ela como len(array)
							})//Valores sem mascara
		
						aAdd(aTitVlr,{oOk,TSE1->E1_FILIAL,TSE1->E1_PREFIXO,TSE1->E1_NUM,TSE1->E1_TIPO,TSE1->E1_NATUREZ,;
						               TSE1->E1_CLIENTE,TSE1->E1_LOJA,cBanco,cAgencia,cConta,TSE1->E1_NOMCLI        ,stod(TSE1->E1_EMISSAO),stod(TSE1->E1_VENCTO),;
						               stod(TSE1->E1_VENCREA),nValor,TSE1->E1_SALDO,;
						               TSE1->E1_SALDO-nValor,TSE1->E1_MOEDA,TSE1->E1_SITUACA,;
						               nValor,TSE1->E1_SALDO,TSE1->E1_SALDO-nValor,.t.})//Valores sem mascara
						nTotal += nValor					               
	
						//TSE1->(dbSkip())
					//End
										
				Else
					aAdd(aTit,{oNo,cFil           ,cPrefixo        ,cTitulo     ,"   "           ,"   "              ,;
					               "      "       ,"  "            ,cBanco,cAgencia,cConta,"TIT. NAO ENCONTRADO","        "        ,"        "    ,;
					               cVencto     ,Transform(nValor,cPict) ,0             ," ","",0,.f.})
					aAdd(aTitVlr,{oNo,cFil           ,cPrefixo        ,cTitulo     ,"   "           ,"   "              ,;
					               "      "       ,"  "            ,cBanco,cAgencia,cConta,"TIT. NAO ENCONTRADO","        "        ,"        "    ,;
					               cVencto     ,Transform(nValor,cPict) ,0             ," ","",.f.})
				EndIf
				TSE1->(dbCloseArea())
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
	If aTit[nX,01] == oOk
		If aTit[nX,01] == oOk .and. Empty(aTit[nX,09]) .or. Empty(aTit[nX,10]) .or. Empty(aTit[nX,10])
			lRet:=.f.
		EndIf
	EndIf
Next nX
If !lRet
	ApMsgAlert("Há dados de Banco não preenchidos!")
EndIf
Return lRet


Static Function fBancoF3()
Local oDlgBnc
Local oBanco
Local oAgencia
Local oConta
Local lRet:=.f.
//PRIVATE cBanco	 := CRIAVAR("A6_COD")
//PRIVATE cAgencia := CRIAVAR("A6_AGENCIA")
//PRIVATE cConta	 := CRIAVAR("A6_NUMCON")
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
Local _cMV_par04	:= mv_par04  // Guarda o valor do Parâmetro que indica como será a contabilização
Local _aArea		:= GetArea()
Local aTitulos 		:= Array(8)
Local aRecnos		:= {}
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.
Private cArquivo    := ""
Private lDigita     := .T.

nHdlPrv := 0
nTotal  := 0
nValDeb := 0
nValCred:= 0
cLote   := "008850"

ProcRegua(0)

nHdlPrv := HeadProva(cLote,"FINA070",Substr(cUsuario,7,6),@cArquivo) //Abre o lançamento contábil
			
lUltima := .F.

For nX:=1 to len(aTit)    
	
	If aTit[nX,1] == oOk

		olblist:nAt:=nX
		olblist:Refresh()	
	 					
		aAdd(aRecnos,aTit[nX,24]) // R_E_C_N_O_

		IncProc()
		
	Endif
	
Next nX
/*      

====================================================================
EXECAUTO PARA BAIXA AUTOMATICA
====================================================================

Composição de aTitulos
aTitulos [1]:= aRecnos	(array contendo os Recnos dos registros a serem baixados)
aTitulos [2]:= cBanco   (Banco da baixa)
aTitulos [3]:= cAgencia (Agência da baixa)
aTitulos [4]:= cConta   (Conta da baixa)
aTitulos [5]:= cCheque  (Cheque da Baixa)
aTitulos [6]:= cLoteFin (Lote Financeiro da baixa)
aTitulos [7]:= cNatureza(Natureza do movimento bancário)
aTitulos [8]:= dBaixa   (Data da baixa)      

Caso a contabilização seja online e a tela de contabilização possa ser mostrada em caso de erro no lançamento (falta de conta, débito/crédito não batem, etc) a baixa automática em lote não poderá ser utilizada.
http://tdn.totvs.com/pages/releaseview.action?pageId=6070735 
Somente será processada se: 
MV_PRELAN = S, depois mudamos para D  -> estava como N
MV_CT105MS = N -> estava como S testar como S por conta de exibir a contabilização
MV_ALTLCTO = N -> já estava ok

*/ 

aTitulos[1]:= aRecnos
aTitulos[2]:= cBanco
aTitulos[3]:= cAgencia
aTitulos[4]:= cConta
aTitulos[5]:= " " 	// Conferir Cheque
aTitulos[6]:= cLote // Conferir como será a sequencia de lotes
aTitulos[7]:= "002" // Conferir Natureza
aTitulos[8]:= dDataBase

Begin Transaction 

	// ExecAuto baixa Automatica
	MSExecAuto({|x,y| Fina110(x,y)},3,aTitulos)

 	If lMsErroAuto  
 	
		For nX:=1 to len(aTit)    
			aTit[nX,1] := oNo
	 	 	aTit[nX,len(aTit[nX])] := .f.
		Next nX

    	MostraErro()
    	lMsErroAuto := .f.  
    	  	
   	EndIf


End Transaction 
Return
            
*-------------------------------------------*
Static Function fUltimaBx(_nLinha,_nTotLin)    
*-------------------------------------------*
Local _lRet := .T.

For _x := (_nLinha + 1) To _nTotLin
	If aTit[_x,1] == oOk
		_lRet := .F.
	EndIf
Next _x
	
Return _lRet

*-------------------------------------------*
Static Function C(nTam)                      
*-------------------------------------------*                                   
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

	If aTit[i,1] == oOk .OR. (aTit[i,1] == oNo .and. aTit[i,12]!="TIT. NAO ENCONTRADO")
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