#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
/***************************************************************************
* Programa.......: GEFM064()                                               *
* Autor..........: J Ricardo de Oliveira Guimarães                         *
* Data...........: 09/09/08                                                *
* Descricao......: Importação de fatura enviada pelas transportadoras para *
*                  geração de fat. microsiga e baixa de provisão de compra,*
*                  dos títulos de compra de frete gerado no sist. SIPCO    *
****************************************************************************
* Alt. por.......:                                                         *
* Data...........:                                                         *
* Motivo.........:                                                         *
*                                                                          *
***************************************************************************/

*------------------------*
User Function GEFM064
*------------------------*
Local 	nOpc	:=	2
Private _cArquivo:=	space(255)
private oOk		:= 	LoadBitMap(GetResources(), "LBOK")
private oNo		:= 	LoadBitMap(GetResources(), "LBNO")
private oVerde	:= 	LoadBitMap(GetResources(), "BR_VERDE")
private oVerme	:= 	LoadBitMap(GetResources(), "BR_VERMELHO")
private oAmare	:= 	LoadBitMap(GetResources(), "BR_AMARELO")
Private aReg  	:=	{} // Cabecalho do Intercambio
Private aTit	:=	{}
Private oDlg	:=	Nil
Private nHdl    :=  Nil

Private _nTotCTRC     := 0
Private _nTotCTRCSiga := 0
Private _nValor       := 0
Private _cFatTransp   := ""
Private _cPrefixo     := If(cFilAnt=="03","CTV","CTA")
Private _cPrefFatura  := "RDV"
Private _cTipoFat	  := "FT"

While .T.
	
	dbSelectArea("SA2")
	dbSetOrder(3)
	
	@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Leitura de Arquivo de Pré Fatura de Transporte")
	@ 00,00 TO 05,24
	@ 02,002 Say " Este programa ira ler o conteudo de um arquivo texto, para liberação"
	@ 03,002 Say " de faturamento segundo escolha do usuário"
	
	@ 07,08 BUTTON "Faturar"  SIZE 40,15 ACTION (nOpc:=1,oDlg:End())
	@ 07,19 BUTTON "Estornar" SIZE 40,15 ACTION (nOpc:=2,oDlg:End())
	@ 07,30 BUTTON "Cancelar" SIZE 40,15 ACTION (nOpc:=3,Close(oDlg))
	
	Activate Dialog oDlg Centered
	
	If nOpc == 1 // Importar arquivo de faturas da transportadora
		While .T.
		
			_cArquivo:=cGetFile( "TXT | *.txt ",OemToAnsi("Abrir o arquivo em..."),,"d:",.f.)
			
			If Empty(AllTrim(_cArquivo))
				MsgAlert("Nenhum arquivo selecionado.","Informação")
				Exit
			EndIf
	
			If Upper(Right(AllTrim(_cArquivo),3)) <> "TXT"
				MsgAlert("O Arquivo selecionado não é um arquivo com extensão TXT.  Favor selecionar um arquivo.","Informação")
				_cArquivo := ""
				Loop
			EndIf
			
			Processa({|| fLerFatura() },"Processando...Lendo arquivo TXT")
			Processa({|| fViewFat() }  ,"Processando...")
			
			If !MsgYesNo("Deseja processar outro arquivo?","Atenção")
				Exit
			EndIf	
			/*	
				If Len(aReg) > 0
					fViewPFat()
				Else
					Alert("Não há registro à importar.")
				EndIf		
			*/	
			
		End	
	ElseIf nOpc == 2 // Estornar Liberacao
		fEstFat()
	EndIf
	
	If nOpc <> 1 .AND. nOpc <> 2
		Exit
	EndIf	
	
End	
Return

/**********************************************************************
* Funcao.....:  fLerFatura()                                          *
* Autor......:  J Ricardo de Oliveira Guimarães                       *
* Data.......:  09/09/08                                              *
* Descricao..:  Monta vetor com os títulos a serem faturados          *
*                                                                     *
**********************************************************************/
Static Function fLerFatura()
Local cTipo		:=	""
Local _aCampos
Local _cNome 
Local _cIndice    := ""
Local _cLinha     := ""
Local _nQtdCTRC   := 0 

_nTotCTRC     := 0
_nTotCTRCSiga := 0

// Local _nTotCTRC   := 0
// Local _nValor     := 0
_cArqTrab   := ""


aReg := {}
aTit := {}

_aCampos:={}
Aadd(_aCampos,{"LINHA","C",79,0 })
			
_cArqTrab := CriaTrab(_aCampos)

If Select("TRA") > 0
	DbSelectArea("TRA")
	dbCloseArea()
EndIf
	
DbUseArea(.T.,,_cArqTrab,"TRA",.F. )
DbSelectArea("TRA")

APPEND FROM &_cArquivo SDF

dbSelectArea("TRA") ; dbGoTop()
If EOF()
	Alert("Não há dados no arquivo " + _cArquivo + " a ser importado.")
	DbSelectArea("TRA")
	dbCloseArea()
	Return
EndIf

ProcRegua(RecCount()) // Numero de registros a processar

While !TRA->(Eof())
	IncProc()
	
	_cLinha := TRA->LINHA
	
	_cIndice:=SubStr(_cLinha,01,02)
	
	If _cIndice == "00" // Cabeçalho
		_cFatTransp := SubStr(_cLinha,15,08)
		_cFatTransp := StrZero(Val(_cFatTransp),6)
		dbSelectArea("TRA")
		dbSkip()
		Loop
	EndIf
	
	If _cIndice == "99" // Rodape
		dbSelectArea("TRA")
		dbSkip()
		Loop
	EndIf	

	// Processa as linhas detalhes
	_nQtdCTRC++
	_nValor   := Val(SubStr(_cLinha,51,14))/100	
	_nTotCTRC += _nValor

	_cNumCTRC	:= strzero(val(alltrim(SubStr(_cLinha,003,06))),6)
	_dData		:= StoD(SubStr(_cLinha,009,008))
	_cCNPJ		:= SubStr(_cLinha,017,014)
	_cCNPJForm  := TransForm(SubStr(_cLinha,017,014),"@R 99.999.999/9999-99")	
	_cNome		:= POSICIONE("SA2",3,xFilial("SA2")+SubStr(_cLinha,017,014),"A2_NOME")
	_cCTRCTransp:= StrZero(val(alltrim(SubStr(_cLinha,031,06))),6)
	_nValSeguro := PadL(TransForm(Val(AllTrim(SubStr(_cLinha,037,14)))/100,"@E 99,999,999.99"),15)
	_nCusto		:= PadL(TransForm(Val(AllTrim(SubStr(_cLinha,051,14)))/100,"@E 99,999,999.99"),15)
	_nDesconto	:= PadL(TransForm(Val(AllTrim(SubStr(_cLinha,065,14)))/100,"@E 99,999,999.99"),15)
	
	aAdd(aReg,	{_cNumCTRC				,;	//	1-Número CTRC
				 _dData					,;	//	2-Data de Emissão
				 _cCNPJForm				,;	// 	3-CNPJ da Transportadora
				 _cNome				    ,;	// 	4-Nome da Transportadora
				 _cCTRCTransp			,;	// 	5-Número da CTRC da Transportadora
				 _nValSeguro			,;	// 	6-Valor do Seguro
				 _nCusto				,;	// 	7-Valor do Custo
				 _nDesconto				,;	// 	8-Valor do Desconto
				})
	oBmp:=oVerme
	oMk:=oNo
	cQry:="SELECT E2_PREFIXO, E2_NUM, E2_FATURA, E2_FORNECE, E2_EMISSAO, E2_VENCREA, E2_VALOR "
	cQry+="  FROM "+RetSqlName("SE2")
	cQry+=" WHERE E2_FILIAL = '"+cFilAnt+"'"
	cQry+="   AND E2_PREFIXO  = '" + _cPrefixo + "' " // CTV(Porto Real) - CTA(Beneditinos, Nova Pavuna e Sete Lagoas)
	cQry+="   AND E2_NUM      = '"+_cNumCTRC+"'"
	cQry+="   AND EXISTS (SELECT * FROM "+RetSqlName("SA2")
	cQry+="                WHERE A2_FILIAL = '"+xFilial("SA2")+"'"
	cQry+="                  AND A2_CGC = '"+_cCNPJ+"'"
	cQry+="                  AND E2_FORNECE = A2_COD"
	cQry+="                  AND E2_LOJA    = A2_LOJA"
	cQry+="                  AND D_E_L_E_T_ <> '*')"
	cQry+="   AND D_E_L_E_T_ <> '*'"

//	MEMOWRIT("D:\TEMP\TITREC.SQL",cQry)	
	
	TcQuery cQry Alias "TSE2" New
	
	If !Eof()
		_nTotCTRCSiga += TSE2->E2_VALOR
		
		If Empty(TSE2->E2_FATURA)
			oBmp:=oVerde
			oMk:=oOk
		Else
			oBmp:=oAmare
			oMk:=oNo
		EndIf
	EndIf

	aAdd(aTit,	{oMk,oBmp               ,;
				 _cNumCTRC				,;	//	1-Número CTRC				 
				 _dData					,;	//	2-Data de Emissão
				 STOD(TSE2->E2_EMISSAO)	,;	//	3-Data de Emissão no Microsiga
				 STOD(TSE2->E2_VENCREA)	,;	//	4-Data de Emissão no Microsiga				 
				 TransForm(TSE2->E2_VALOR,"@R 99,999,999.99")   ,;	//	5-Data de Emissão no Microsiga				 				 
				 _cCNPJ					,;	// 	6-CNPJ da Transportadora
				 _cNome				    ,;	// 	7-Nome da Transportadora
				 _cCTRCTransp			,;	// 	8-Número da CTRC da Transportadora
				 _nValSeguro			,;	// 	9-Valor do Seguro
				 _nCusto				,;	// 	10-Valor do Custo
				 _nDesconto				,;	// 	11-Valor do Desconto
				})

	dbSelectArea("TSE2") ; dbCloseArea()

	dbSelectArea("TRA") ; dbSkip()
End
    
dbSelectArea("TRA")
dbCloseArea()
FErase(_cArqTrab+".dbf")

Return

/**********************************************************************
* Funcao.....:  fViewPFat()                                           *
* Autor......:  J Ricardo de O Guimarães                              *
* Data.......:  10/09/08                                              *
* Descricao..:  Monta diálogo para conferencia dos CTRC´s com a Fatura*
*                                                                     *
**********************************************************************/
Static Function fViewFat()
Local nOpca:=1
Local _lFatura := .F.
Local nValDup  := _nTotCTRCSiga
Local nMoeda   := 1
Local _cNat    := ""

Local cArquivo
Local nTotal		:=0
Local nHdlPrv		:=0
Local lPadrao
Local cPadrao		:="065"

Private cLote

Private olblist := 	nil
Private cPict	:=	"@E 99,999,999,999.99"
Private aCab	:= 	{ " "," ","Num.CTRC    ", "Data"      , "Emissão no Siga", "Venc.no Siga", "Valor no Siga", "CNPJ"        , "Transportadora" ,;
					          "CTRC Transp.", "Val.Seguro", "Valor Custo"    , "Desconto"    , "CNPJ Transp." }
Private aPic 	:= 	{ " "," ","@!"          , "@D"        , "@D"             , "@D"          , "@!"           , "@!"           , "@!"             ,;
					          "@!"          , cPict       , "@E 99,999,999,999.99", cPict    , "@!"      }
Private aSizeCol:= 	{ 10 ,10 ,15            , 10          , 30               , 30            ,30              , 30             , 50               ,;
					          15            , 30          , 40               , 30            , 30        }

DEFINE MSDIALOG oDlg2 TITLE OemToAnsi("Importação da Fatura da Transportadora") FROM 078,022 TO 115,130 //OF oMainWnd 
//olblist  := TWBrowse():New(  1 , 1 , 0400, 240 ,,aCab,aSizeCol,,,,,,,,,,,,, .F.,, .F.,, .F.,,, )
olblist  := TWBrowse():New(  1 , 1 , 0400, 200 ,,aCab,aSizeCol,,,,,,,,,,,,, .F.,, .F.,, .F.,,, )
olblist:SetArray(aTit)
olblist:bLDblClick := {||aTit[olblist:nAt][1] := if(aTit[olblist:nAt][1]=ook,ono,iif(aTit[olblist:nAt][2]==oVerde ,ook,oNo)), oDlg2:Refresh()}
olblist:bLine      := {||LinBrw(olblist, aTit)}
olblist:lAutoEdit  := .T.
olblist:BHEADERCLICK:={|| fInverteMk()}

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

@ 17,01 SAY "Total Importado da Fatura da Transportadora    :" + TransForm(_nTotCTRC, "@E 999,999,999.99" ) SIZE 40,20 COLOR CLR_BLUE FONT oBold
@ 18,01 SAY "Valor Total de CTRC´s encontrado no Microsiga : " + TransForm(_nTotCTRCSiga, "@E 999,999,999.99" ) SIZE 40,20 COLOR CLR_RED  FONT oBold

@ 18.5,00 TO 18.5,75

@ 19,10 BITMAP oVrd RESNAME "BR_VERDE" SIZE 16,16 NOBORDER of oDlg2
@ 21,07 SAY "Título encontrado"
@ 19,22 BITMAP oVer RESNAME "BR_VERMELHO" SIZE 16,16 NOBORDER 
@ 21,20 SAY "Título não encontrado"
@ 19,42 BITMAP oVer RESNAME "BR_AMARELO" SIZE 16,16 NOBORDER 
@ 21,40 SAY "Título já Faturado"

Activate MSDialog oDlg2 ON INIT ;
EnchoiceBar(oDlg2, {|| nOpca := 2,oDlg2:End()},{|| nOpca := 1,oDlg2:End()},,{});
Centered   

// EnchoiceBar(oDlg2, {|| nOpca := 2},{|| nOpca := 1,oDlg2:End()},,{});
// Centered

If nOpca == 2 // Ok

	If _nTotCTRC <> _nTotCTRCSiga
		MSGBOX("O Total dos CTRC´s da fatura da transportadora não confere com os CTRC´s provisionado do Microsiga." +CHR(13)+CHR(13)+;
		       "Total dos CTRC´s da Fatura : " + TransForm(_nTotCTRC    ,'@E 999,999,999.99')+CHR(13)+;
		       "Total dos CTRC´s Provisionado no Sistema Microsiga : " + TransForm(_nTotCTRCSiga,'@E 999,999,999.99'),"Informação","INFO")
		Return		       
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cNat := Space(TamSX3("ED_CODIGO")[1])
	_cDesNat := Space(TamSX3("ED_DESCRIC")[1])
	_dVenc := CTOD("")
	_cBanco := Space(TamSX3("A6_COD")[1])
	_cConta := Space(TamSX3("A6_NUMCON")[1])
	_cAG    := Space(TamSX3("A6_AGENCIA")[1])
	_cCC    := Space(TamSX3("CTT_CUSTO")[1])
	_cCCDesc:= Space(TamSX3("CTT_DESC01")[1])
	
	// _cNat := "D100101"
	
	_nOpc := 0

	While .T.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Criacao da Interface                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ 185,101 To 427,567 Dialog _odlg Title OemToAnsi("Fatura")
		@ 3,4 To 87,224 Title OemToAnsi("Informações para a Fatura")
		@ 13,13 Say OemToAnsi("Natureza:") Size 25,10 Object oNat
		@ 37,13 Say OemToAnsi("Vencimento:") Size 32,10 Object _oVenc
//		@ 60,13 Say OemToAnsi("Bco/Cta/Ag:") Size 30,10 Object _oBanco
		@ 60,13 Say OemToAnsi("Centro Custo:") Size 60,10 Object _oCC
		@ 13,41 Get _cNat Picture "@!" F3 "SED" VALID !EMPTY(_cNat) .AND. _cNat == POSICIONE("SED",1,xFilial("SED")+_cNat,"ED_CODIGO") .AND. fDesNat(_cNat) Size 50,11 Object _ObjNat
		@ 13,90 Get _cDesNat Picture "@!" WHEN .F. Size 125,10 Object _ObjDesNat
		@ 37,49 Get _dVenc Picture "@D" VALID !Empty(_dVenc) .AND. _dVenc >= dDataBase Size 50,10 Object _ObjVenc
//		@ 60,49 Get _cBanco Picture "@!" F3 "SA6" VALID !EMPTY(_cBanco) .AND. _cBanco == POSICIONE("SA6",1,xFilial("SA6")+_cBanco,"A6_COD") Size 25,10 Object _ObjBanco
//		@ 60,78 Get _cConta WHEN .F. Size 40,10 Object _ObjConta
//		@ 60,118 Get _cAg   WHEN .F. Size 40,10 Object _ObjAG

		@ 60,49 Get _cCC     Picture "@!" F3 "CTT" VALID !EMPTY(_cCC) .AND. _cCC == POSICIONE("CTT",1,xFilial("CTT")+_cCC,"CTT_CUSTO") .AND. fDescCC(_cCC) Size 40,10 Object _ObjCC
		@ 60,90 Get _cCCDesc WHEN .F. Size 125,10 Object _ObjCCDesc

		@ 95,188 BmpButton Type 1 Action (_nOpc := 1, _odlg:END())

		Activate Dialog _odlg
		
		EXIT
		
	End	
                
	// So segue em frente se a tela anterior for validada pelo Ok.
	If _nOpc <> 1
		MsgAlert("Geração de Fatura Cancelada.")
//	    _oDlg:End()
		RETURN
	EndIf

	dbSelectArea( "SE2" ) ; dbSetOrder(1)
	If dbSeek(xFilial("SE2")+_cPrefFatura+_cFatTransp)
		MsgAlert("A fatura " + _cPrefFatura + " de prefixo " + _cPrefFatura + " já existe.")
		Return
	EndIf
	
	ProcRegua(len(aTit))
	For nX:=1 to len(aTit)
		IncProc()
		If aTit[nX,1] == oOk .and. aTit[nX,2] == oVerde
			*---------------------------*
			// Gerar Fatura
			*---------------------------*
		
			dbSelectArea( "SE2" ) ; dbSetOrder(1)
			If dbSeek(xFilial("SE2")+_cPrefixo+aTit[nX,3])
				_lFatura := .T.			
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza a Baixa do Titulo	  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !(E2_TIPO $ MVABATIM) .and. E2_SALDO > 0
					nJur290		:= SE2->E2_SDACRES
					nDesc290	:= SE2->E2_SDDECRE
					_cNat       := SE2->E2_NATUREZ
							
					RecLock("SE2",.F.)
					SE2->E2_BAIXA	 := dDataBase
					SE2->E2_VALLIQ	 := SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE
					SE2->E2_JUROS	 := nJur290
					SE2->E2_DESCONT 	:= nDesc290
					SE2->E2_SALDO	 := 0
					SE2->E2_MOVIMEN := dDataBase
					SE2->E2_FATURA  := _cFatTransp
					SE2->E2_FATPREF := _cPrefFatura
					SE2->E2_TIPOFAT := _cTipoFat
					SE2->E2_DTFATUR := dDataBase
					SE2->E2_FLAGFAT := "S"
					SE2->E2_SDACRES := 0
					SE2->E2_SDDECRE := 0
					MsUnlock()

					dbSelectArea("SE2")
				Endif
			EndIf
		EndIf		
	Next nX	
               
 	// Gerar Fatura
	If _lFatura
		dbSelectArea("SA2") ; dbSetOrder(3)
		dbSeek(xFilial("SA2")+aTit[01,8]) // CNPJ

		// cCondicao := Fa290PedCd()				// Monta tela para pedir condicao de pgto
		// aVenc := Condicao(nValor,cCondicao,0)
		
		nValTotal := 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Implantacao da Fatura		  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("SE2",.T.)
			Replace E2_FILIAL 	With  xFilial("SE2")
			Replace E2_NUM 		With  _cFatTransp
			// Replace E2_PARCELA	With  cParcela
			Replace E2_PREFIXO	With  _cPrefFatura
			Replace E2_NATUREZ	With  _cNat
			Replace E2_VENCTO 	With  _dVenc
			Replace E2_VENCREA	With  DataValida(E2_VENCTO,.T.)
			Replace E2_EMISSAO	With  dDatabase
			Replace E2_EMIS1	With  dDatabase
			Replace E2_TIPO		With  _cTipoFat
			Replace E2_FORNECE	With  SA2->A2_COD
			Replace E2_LOJA		With  SA2->A2_LOJA
			Replace E2_VALOR	With  nValDup
			Replace E2_SALDO	With  nValDup
			Replace E2_MOEDA	With  nMoeda
//			Replace E2_PORTADO	With  _cBanco
			Replace E2_FATURA 	With  "NOTFAT"
			Replace E2_HIST 	With  "APROP.COMPRA DE FRETE"
			Replace E2_NOMFOR 	With  SA2->A2_NREDUZ
			Replace E2_VLCRUZ	With  xMoeda(nValDup,nMoeda,1)  // nValCruz
			Replace E2_CCONT 	With  _cCC
			Replace E2_ORIGEM 	With  "GEFM064"
			lPadrao:=VerPadrao(cPadrao)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza Flag de Lancamento contabil		  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF lPadrao
				Replace E2_LA 	With  "S"
			End

		MsUnlock()

       	nValTotal += xMoeda(nValDup,nMoeda,1)  // nValCruz
		IF lPadrao
			If nHdlPrv <= 0
				nHdlPrv:=HeadProva(cLote,"GEFM064",Substr(cUsuario,7,6),@cArquivo)
			Endif
			VALOR := 0
			nTotal+=DetProva(nHdlPrv,cPadrao,"GEFM064",cLote)
		Endif
	
		If nTotal > 0
			dbSelectArea("SE2")
			nRecSe2 := Recno()
			SE2->(DBGoBottom())
			SE2->(dbSkip())
			VALOR := nValTotal
			nTotal+=DetProva(nHdlPrv,cPadrao,"GEFM064",cLote)
			RodaProva(nHdlPrv,nTotal)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lancamento Contabil					   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// lDigita:=IIF(mv_par02==1,.T.,.F.)
			lDigita:=.T.
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.)
			VALOR := 0        
			dbSelectArea("SE2")
			SE2->(DBGoTo(nRecSe2))			
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava no SX6 o numero da ultima fatura gerada. 						  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		GetMv("MV_NUMFATP")
//		RecLock( "SX6",.F. )
//		SX6->X6_CONTEUD := _cFatTransp
//		MsUnlock()
		
		MsgAlert("Fatura " + _cFatTransp + " gerada.")
		fRename(_cArquivo,substr(_cArquivo,1,len(_cArquivo)-3)+"Faturado")
	EndIf	
EndIf

Return

/************************************************************************
* Funcao.....:  fEstFat()                                               *
* Autor......:  J Ricardo de O Guimarães                                *
* Data.......:  17/09/08                                                *
* Descricao..:  Funcao para estorno da liberacao de pre-faturas         *
*                                                                       *
************************************************************************/
Static Function fEstFat()
// Variaveis Locais da Funcao
Local c_cCNPJFor := Space(14)
Local c_cFat	 := Space(06)
Local c_cNomeFor := Space(30)
Local c_cPref	 := _cPrefFatura
Local o_cCNPJFor
Local o_cFat
Local o_cNomeFor
Local o_cPref
Local _nOpc 	 := 0

// Variaveis Private da Funcao
Private oDlg				// Dialog Principal

While .T.

	c_cCNPJFor 	:= Space(14)
	c_cFat	 	:= Space(06)
	c_cNomeFor 	:= Space(30)
	
	DEFINE MSDIALOG oDlg TITLE "Informe a Fatura de compra de frete a ser Excluída" FROM C(195),C(226) TO C(307),C(762) PIXEL
	
		// Cria as Groups do Sistema
		@ C(000),C(002) TO C(043),C(269) LABEL "" PIXEL OF oDlg
	
		// Cria Componentes Padroes do Sistema
		@ C(010),C(007) Say "Prefixo" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
		@ C(010),C(038) Say "Fatura" Size C(022),C(008) COLOR CLR_BLACK PIXEL OF oDlg
		@ C(010),C(077) Say "CNPJ do Fornecedor" Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg
		@ C(010),C(144) Say "Fornecedor" Size C(031),C(008) COLOR CLR_BLACK PIXEL OF oDlg
		@ C(019),C(007) MsGet o_cPref Var c_cPref Size C(021),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
		@ C(019),C(038) MsGet o_cFat Var c_cFat Size C(032),C(009) COLOR CLR_BLACK Picture "!!!!!!" PIXEL OF oDlg
		@ C(019),C(077) MsGet o_cCNPJFor Var c_cCNPJFor F3 "SAX" VALID fVldFor(c_cCNPJFor, @c_cNomeFor, o_cNomeFor) Size C(060),C(009) COLOR CLR_BLACK Picture "@R 99.999.999/9999-99" PIXEL OF oDlg
		@ C(019),C(145) MsGet o_cNomeFor Var c_cNomeFor Size C(119),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	
		// Cria ExecBlocks dos Componentes Padroes do Sistema
		o_cPref:bWhen     := {|| .F. }
		o_cNomeFor:bWhen  := {|| .F. }
	
		DEFINE SBUTTON FROM C(044),C(198) TYPE 2 ACTION (_nOpc:=0,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM C(044),C(242) TYPE 1 ACTION (_nOpc:=1,oDlg:End()) ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED 
	
	If _nOpc == 1 // Estornar
		Processa({|| fEstorno(c_cPref,c_cFat,SA2->A2_COD,SA2->A2_LOJA) },"Aguarde o estorno da Fatura...")
	EndIf
	
	If _nOpc <> 1
		Exit
	EndIf	
	
End

Return

/************************************************************************
* Funcao.....:  fEstorno()                                              *
* Autor......:  J Ricardo de Oliveira Guimarães                         *
* Data.......:  19/09/08                                                *
* Descricao..:  Funcao para estorno da fatura de compra de frete segundo*
*               parametros passado pelo usuário                         *
*                                                                       *
************************************************************************/
Static Function fEstorno(_cPref,_cNumFat,_cCodFor,_cLoja)
Local _aArea  := GetArea()
Local _cQry   := ""
Local _nRet   := 0
Local _nRecNo := 0
Local _nTotFat:= 0 
Local nMoeda  := 1

Local cArquivo	    := ""
Local nTotal		:= 0
Local nHdlPrv		:= 0
Local lPadrao
Local cPadrao		:="066" // Contabilização de Cancelamento de Fatura

Private cLote       // := "8850"
Private nValTotal   := 0

ProcRegua(0)

// Busco a Fatura de Compra de Frete
_cQry := " SELECT E2_NUM, E2_PREFIXO, E2_TIPO, R_E_C_N_O_ AS RECNO,E2_BAIXA,E2_VALLIQ,E2_SALDO, E2_MOVIMEN, E2_FATURA, "
_cQry += " 		  E2_FATPREF, E2_TIPOFAT, E2_DTFATUR, E2_FLAGFAT, E2_SDACRES,E2_SDDECRE, E2_ORIGEM, E2_VLCRUZ, E2_VALOR "
_cQry += " FROM " + RetSqlName("SE2") + " SE2 " 
_cQry += " WHERE E2_FILIAL ='" + xFilial("SE2") + "' "
_cQry += " 	 AND E2_NUM    ='" + _cNumFat       + "' "
_cQry += "   AND E2_PREFIXO='" + _cPrefFatura   + "' "
_cQry += "   AND E2_TIPO   ='" + _cTipoFat      + "' "
_cQry += "   AND E2_FORNECE='" + _cCodFor       + "' "
_cQry += "   AND E2_LOJA   ='" + _cLoja         + "' "
_cQry += "   AND D_E_L_E_T_='' "

TCQUERY _cQry ALIAS "TFAT" NEW

dbSelectArea("TFAT") ; dbGoTop()

If EOF()
	MsgAlert("Fatura inexistente para os parâmetros informados.")
	dbSelectArea("TFAT") ; dbCloseArea()
	Return
EndIf

If TFAT->E2_ORIGEM <> "GEFM064"
	MsgAlert("Fatura existe porém não foi gerada por esta rotina, favor excluir na rotina de origem.")
	dbSelectArea("TFAT") ; dbCloseArea()	
	Return
EndIf

_nRecNo := TFAT->RECNO
_nTotFat:= TFAT->E2_VALOR

// Visualizo a Fatura na tela para confirmação da Exclusão.
cCadastro := "EXCLUIR Fatura a pagar de Compra de Frete"
dbSelectArea("TFAT") ; dbCloseArea()

dbSelectArea("SE2") ; dbGoto(_nRecNo)

 _nRet := AxVisual("SE2",_nRecNo,2)  // _nRet = 1(Confirma-Ok); _nRet = 2(Cancela);

// Não foi confirmado a exclusão
If _nRet <> 1
	Return
EndIf	

lPadrao   := VerPadrao(cPadrao)

dbSelectArea("SA2") ; dbSetOrder(1)
dbSeek(xFilial("SA2")+_cCodFor+_cLoja)

dbSelectArea("SE2") ; dbSetOrder(1)
dbGoto(_nRecNo)

nValTotal := xMoeda(_nTotFat,nMoeda,1)

If lPadrao
	If nHdlPrv <= 0
		nHdlPrv:=HeadProva(cLote,"GEFM064",Substr(cUsuario,7,6),@cArquivo)
	Endif
	VALOR  := 0
	nTotal +=DetProva(nHdlPrv,cPadrao,"GEFM064",cLote)
EndIf

// Desvincular os títulos que compoe a fatura
_cQry := " UPDATE " + RetSqlName("SE2") 
_cQry += " 	SET E2_BAIXA    ='', E2_VALLIQ=0  , E2_SALDO=E2_VALOR, E2_MOVIMEN='', E2_FATURA='', E2_FATPREF='', "
_cQry += " 		E2_TIPOFAT  ='', E2_DTFATUR='', E2_FLAGFAT=''    , E2_SDACRES=0 ,E2_SDDECRE=0 "
_cQry += " 	WHERE E2_FILIAL ='" + xFilial("SE2") + "' "
_cQry += " 	  AND E2_FATURA ='" + _cNumFat  + "' "
_cQry += " 	  AND E2_FATPREF='" + _cPref    + "' "
_cQry += " 	  AND E2_TIPOFAT='" + _cTipoFat + "' "
_cQry += " 	  AND E2_FORNECE='" + _cCodFor  + "' "
_cQry += " 	  AND E2_LOJA   ='" + _cLoja    + "' "
_cQry += "    AND D_E_L_E_T_=''"

IncProc()
If TcSqlExec(_cQry) < 0
	IncProc()
	MsgAlert("Erro ao tentar excluir a Fatura, favor comunicar o Adm. do Sistema." + CHR(13) + TCSQLError())
	Return
EndIf

// TcSqlExec("COMMIT")
IncProc()

nValTotal += xMoeda(_nTotFat,nMoeda,1)  // Total da Fatura

// Excluir Fatura
dbSelectArea("SE2") 
dbGoto(_nRecNo)

RecLock("SE2",.F.)
	dbDelete()
MsUnLock()	

IncProc()

nTotal := nValTotal

If nTotal > 0
	dbSelectArea("SE2")
	nRecSe2 := Recno()
	SE2->(DBGoBottom())
	SE2->(dbSkip())
	VALOR := nValTotal
	nTotal+=DetProva(nHdlPrv,cPadrao,"GEFM064",cLote)
	RodaProva(nHdlPrv,nTotal)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia para Lancamento Contabil					   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// lDigita:=IIF(mv_par02==1,.T.,.F.)
	lDigita:=.T.
	cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.)
	VALOR := 0        
	dbSelectArea("SE2")
	SE2->(DBGoTo(nRecSe2))
Endif

MsgAlert("Exclusão da Fatura " + _cNumFat + " com sucesso.")

RestArea(_aArea)
Return

/************************************************************************
* Funcao.....:  cnvVal()                                                *
* Autor......:  Marcelo Aguiar Pimentel                                 *
* Data.......:  04/06/07                                                *
* Descricao..:  Funcao para conversao de string para numerico colocando *
*               as casa decimais                                        *
*                                                                       *
************************************************************************/
Static Function cnvVal(cVal,nTam)
Local nVal:=0
If substr(cVal,nTam,1) == "-"
	nVal:=val(substr(cVal,1,nTam-3)+"."+substr(cVal,nTam-2,2))*(-1)
Else
	nVal:=val(substr(cVal,1,nTam-2)+"."+substr(cVal,nTam-1,2))
EndIf
Return nVal

/**********************************************************************
* Funcao.....:  LinBrw()                                              *
* Autor......:  J Ricardo de Oliveira Guimarães                       *
* Data.......:  11/09/08                                              *
* Descricao..:  Funcao chamada na propriedade bLine do listbox        *
*                                                                     *
**********************************************************************/
Static Function LinBrw(olblista,A_NF)
Local V_I:=0, a_Line:={}
For V_I := 1 To len(olblista:aheaders)
	AAdd( a_Line,A_NF[olblista:nAt,V_I] )
Next
Return( a_Line )


Static Function fInverteMk()
Local oMk:= oNo

If len(aTit) > 0
	oMk:=iif(aTit[1,1] == oNo,oOk,oNo)
	For nX:=1 to len(aTit)
		If aTit[nX,1] == oOk
			aTit[nX,1]:=oMk//oNo
		Else
			aTit[nX,1]:=oOk
		EndIf
	Next nX
	oLbList:Refresh()
EndIf

Return

*-----------------------------*
Static Function fDesNat(_cNat)
*-----------------------------*
_cDesNat := POSICIONE("SED",1,xFilial("SED")+_cNat,"ED_DESCRIC")
_ObjDesNat:Refresh()
Return .T.


*-----------------------------*
Static Function fDescCC(_cCC)
*-----------------------------*
_cCCDesc := POSICIONE("CTT",1,xFilial("CTT")+_cCC,"CTT_DESC01")
_ObjCCDesc:Refresh()
Return .T.


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
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

*------------------------------------------------------------*
Static Function fVldFor(_cCNPJ, _cNomeFor, _oNomeFor)
*------------------------------------------------------------*
Local _aArea := GetArea()

If Empty(_cCNPJ)
   Return .T.
EndIf

dbSelectArea("SA2") ; dbSetOrder(3)

If !dbSeek(xFilial("SA2")+_cCNPJ)
   MsgAlert("Fornecedor não encontrado.") 
   Return .F.
EndIf

_cNomeFor := SA2->A2_NOME
_oNomeFor:Refresh()

Return .T.