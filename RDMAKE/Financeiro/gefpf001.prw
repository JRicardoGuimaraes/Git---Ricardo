#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
/***************************************************************************
* Programa.......: gefpf001()                                              *
* Autor..........: Marcelo Aguiar Pimentel                                 *
* Data...........: 01/06/07                                                *
* Descricao......: Importação de Pre fatura de transporte                  *
*                                                                          *
****************************************************************************
* Alt. por.......:                                                         *
* Data...........:                                                         *
* Motivo.........:                                                         *
*                                                                          *
***************************************************************************/
User Function gefpf001
Local 	nOpc	:=	2
private oOk		:= 	LoadBitMap(GetResources(), "LBOK")
private oNo		:= 	LoadBitMap(GetResources(), "LBNO")
private oVerde	:= 	LoadBitMap(GetResources(), "BR_VERDE")
private oVerme	:= 	LoadBitMap(GetResources(), "BR_VERMELHO")
private oAmare	:= 	LoadBitMap(GetResources(), "BR_AMARELO")
Private aReg  	:=	{} // Cabecalho do Intercambio
Private aTit	:=	{}
Private oDlg	:=	Nil
Private cPath	:= "\prefat\"
Private cArqTxt := "prefat.txt"
Private nHdl    := Nil

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)//+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

dbSelectArea("SA1")
dbSetOrder(3)

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Leitura de Arquivo de Pré Fatura de Transporte")
@ 00,00 TO 05,24
@ 02,002 Say " Este programa ira ler o conteudo de um arquivo texto, para liberação"
@ 03,002 Say " de faturamento segundo escolha do usuário"

@ 07,08 BUTTON "Liberar"  SIZE 40,15 ACTION (nOpc:=1,oDlg:End())
@ 07,19 BUTTON "Estornar" SIZE 40,15 ACTION (nOpc:=2,oDlg:End())
@ 07,30 BUTTON "Cancelar" SIZE 40,15 ACTION (nOpc:=3,Close(oDlg))

Activate Dialog oDlg Centered

If nOpc == 1 // Liberar
	nHdl    := fOpen(cPath+cArqTxt,68)
	If nHdl == -1
	    MsgAlert("O arquivo de nome "+cPath+cArqTxt+" nao pode ser aberto!","Atencao!")
	    Return
	Endif
	Processa({|| fImpPreFat() },"Processando...")
	
	If Len(aReg) > 0
		fViewPFat()
	Else
		Alert("Não há registro à importar.")
	EndIf		
ElseIf nOpc == 2 // Estornar Liberacao
	fEstPFat()
EndIf
Return

/**********************************************************************
* Funcao.....:  fImpPreFat()                                          *
* Autor......:  Marcelo Aguiar Pimentel                               *
* Data.......:  04/06/07                                              *
* Descricao..:  Monta vetor com os títulos a serem liberados          *
*                                                                     *
**********************************************************************/
Static Function fImpPreFat()
Local nTamFile, nTamLin, cBuffer, nBtLidos
Local cTipo		:=	""
Local cNomeEmp	:=	""
Local _cPreFat  :=  ""
aReg:={}
nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 199+Len(cEOL) // Verificado que a linha do arquivo esta vindo com 204 caracteres e para vir 200
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

ProcRegua(nTamFile) // Numero de registros a processar

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto
While nBtLidos >= nTamLin
	IncProc()
	cTipo:=substr(cBuffer,01,03)

	Do 	Case
/*
		Case cTipo == "000"	// Cabeçalho de Intercâmbio
			cDt:=substr(cBuffer,74,06)
			cDt:=substr(cDt,1,2)+"/"+substr(cDt,3,2)+"/"+substr(cDt,5,2)
			cNomeEmp:=substr(cBuffer,04,35)
			aAdd(aReg,	{substr(cBuffer,01,03)	,;	//	1-Identificador do registro
						 substr(cBuffer,04,35)	,;	//	2-Identificacao do Remetente
						 substr(cBuffer,39,35)	,;	// 	3-Identificacao do Destinatario
						 cDt					,;	// 	4-Data
						 substr(cBuffer,80,04)	,;	// 	5-Hora
						 substr(cBuffer,84,12)	;	// 	6-Identificacao do Intercambio
						})

		Case cTipo == "390"	// Cabeçalho de Documentos
			aAdd(aReg,	{substr(cBuffer,01,03)	,;	//	1-Identificador do registro
						 substr(cBuffer,04,14)	;	//	2-Identificacao do Documento
						})
		Case cTipo == "391"	// Dados da Empresa Pagadora
			aAdd(aReg,	{substr(cBuffer,01,03)	,;	//	1-Identificador do registro
						 substr(cBuffer,04,15)	,;	//	2-CNPJ/CGC da Empresa Pagadora
						 substr(cBuffer,19,15)	,;	// 	3-Incricao Estadual Embarcadora
						 substr(cBuffer,34,40)	;	// 	4-Nome da Empresa Pagadora(Razao Social)
						})
*/
		Case cTipo == "392"	// Dados da Pré-fatura
			cDtEm:=substr(cBuffer,24,08)
			cDtEm:=substr(cDtEm,1,2)+"/"+substr(cDtEm,3,2)+"/"+substr(cDtEm,5,4)
			cDtPre:=substr(cBuffer,32,08)
			cDtPre:=substr(cDtPre,1,2)+"/"+substr(cDtPre,3,2)+"/"+substr(cDtPre,5,4)
			
			// Por: Ricardo - Em: 28/04/2008 -  Passar a armazenar o número da Pré Fatura
			_cPreFat  := substr(cBuffer,04,20)
						
			aAdd(aReg,	{substr(cBuffer,01,03)				,;	//	1-Identificador do registro
						 substr(cBuffer,04,20)				,;	//	2-Identificacao da Pre-fatura
						 cDtEm								,;	// 	3-Data de Emissao da Pre-fatura
						 cDtPre								,;	// 	4-Data para pagamento da pre-fatura
						 val(substr(cBuffer,40,04))			,;	// 	5-Qtde de Documentos na pré-fatura
						 cnvVal(substr(cBuffer,44,15),15)	,;	// 	6-Valor total da pre-fatura
						 substr(cBuffer,59,01)				;	// 	7-Ação do Documento
						})
		Case cTipo == "393"	// Documentos liberados para pagamento
			cDtEmDoc:=substr(cBuffer,44,08)
			cDtEmDoc:=substr(cDtEmDoc,1,2)+"/"+substr(cDtEmDoc,3,2)+"/"+substr(cDtEmDoc,5,4)
			cDtEmCTp:=substr(cBuffer,69,08)
			cDtEmCTp:=substr(cDtEmCTp,1,2)+"/"+substr(cDtEmCTp,3,2)+"/"+substr(cDtEmCTp,5,4)
			cNumCTRC:=strzero(val(alltrim(substr(cBuffer,057,12))),6)
			aAdd(aReg,	{substr(cBuffer,001,03)				,;	//	1-Identificador do registro
						 substr(cBuffer,004,15)				,;	//	2-CNPJ/CGC da empresa emissora do documento
						 substr(cBuffer,019,05)				,;	// 	3-Serie do documento do embarcador
						 substr(cBuffer,024,20)				,;	// 	4-Identificação do documento do embracador
						 cDtEmDoc			   				,;	// 	5-Data de emissao do documento do embarcador
						 substr(cBuffer,052,05)				,;	// 	6-Serie do conhecimento da transportadora
						 cNumCTRC							,;	// 	7-Numero do conhecimento da transportadora
						 cDtEmCTp			   				,;	// 	8-Data de emissao do conhecimento
						 substr(cBuffer,077,15)				,;	// 	9-CNPJ/CGC do local de origem do transporte
						 substr(cBuffer,092,15)				,;	// 10-CNPJ/CGC/CPF de destino  do transporte
						 substr(cBuffer,107,01)				,;	// 11-Indicacao de CNPJ/CGC/CPF de destino
						 cnvVal(substr(cBuffer,108,15),15)	,;	// 12-Valor total do frete do embarcador
						 cnvVal(substr(cBuffer,123,15),15)	,;	// 13-Valor total do frete do conhecimento
						 substr(cBuffer,138,01)				,;	// 14-Indicador do tipo de diferença no valor
						 cnvVal(substr(cBuffer,139,15),15)	,;	// 15-Valor da diferença dos fretes
						 substr(cBuffer,154,15)				,;	// 16-Identificacao de documento interno da embarcadora referente ao transporte
						 substr(cBuffer,169,15)				;	// 17-CNPJ/CGC da Transportadora
						})
			oBmp:=oVerme
			oMk:=oNo
			cQry:="select E1_XDTLIB "
			cQry+="  FROM "+RetSqlName("SE1")
			cQry+=" WHERE E1_FILIAL = '"+cFilAnt+"'"
			cQry+="   AND E1_PREFIXO  = 'CTR'"//+substr(cBuffer,052,05)+"'"
			cQry+="   AND E1_NUM      = '"+cNumCTRC+"'"
	    	// cQry+="   AND E1_EMISSAO  = '"+DTOS(CTOD(cDtEmCTp))+"'"
			cQry+="   AND EXISTS (SELECT * FROM "+RetSqlName("SA1")
			cQry+="                WHERE A1_FILIAL = '"+xFilial("SA1")+"'"
			cQry+="                  AND A1_CGC = '"+substr(cBuffer,005,14)+"'"
			cQry+="                  AND E1_CLIENTE = A1_COD"
			cQry+="                  AND E1_LOJA    = A1_LOJA"
			cQry+="                  AND D_E_L_E_T_ <> '*')"
			cQry+="   AND D_E_L_E_T_ <> '*'"
			TcQuery cQry Alias "TSE1" New
			If !Eof()
				If Empty(TSE1->E1_XDTLIB)
					oBmp:=oVerde
					oMk:=oOk
				Else
					oBmp:=oAmare
					oMk:=oNo
				EndIf
			EndIf
			dbCloseArea()
		 	cCNPJ:=substr(cBuffer,005,14)//cCNPJ:=substr(cBuffer,004,15)
		 	dbSelectArea("SA1")
		 	dbSeek(xFilial("SA1")+cCNPJ)
			cNomeEmp:=Alltrim(SA1->A1_NREDUZ)
			aAdd(aTit,	{oMk,oBmp,cDtPre,_cPreFat,cNomeEmp  ,;
						 cCNPJ								,;	//	2-CNPJ/CGC da empresa emissora do documento
						 substr(cBuffer,019,05)				,;	// 	3-Serie do documento do embarcador
						 substr(cBuffer,024,20)				,;	// 	4-Identificação do documento do embracador
						 cDtEmDoc			   				,;	// 	5-Data de emissao do documento do embarcador
						 substr(cBuffer,052,05)				,;	// 	6-Serie do conhecimento da transportadora
						 cNumCTRC							,;	// 	7-Numero do conhecimento da transportadora
						 cDtEmCTp			   				,;	// 	8-Data de emissao do conhecimento
						 substr(cBuffer,077,15)				,;	// 	9-CNPJ/CGC do local de origem do transporte
						 substr(cBuffer,092,15)				,;	// 10-CNPJ/CGC/CPF de destino  do transporte
						 substr(cBuffer,107,01)				,;	// 11-Indicacao de CNPJ/CGC/CPF de destino
						 cnvVal(substr(cBuffer,108,15),15)	,;	// 12-Valor total do frete do embarcador
						 cnvVal(substr(cBuffer,123,15),15)	,;	// 13-Valor total do frete do conhecimento
						 substr(cBuffer,138,01)				,;	// 14-Indicador do tipo de diferença no valor
						 cnvVal(substr(cBuffer,139,15),15)	,;	// 15-Valor da diferença dos fretes
						 substr(cBuffer,154,15)				,;	// 16-Identificacao de documento interno da embarcadora referente ao transporte
						 substr(cBuffer,169,15)				;	// 17-CNPJ/CGC da Transportadora
						})
/*
		Case cTipo == "394"	// Documentos liberados para pagamento
			aAdd(aReg,	{substr(cBuffer,001,03)			  ,;	//	1-Identificador do registro
						 cnvVal(substr(cBuffer,004,15),15),;	//	2-Valor do frete por peso/Volume
						 cnvVal(substr(cBuffer,019,15),15),;	// 	3-Valor SEC - CAT
						 cnvVal(substr(cBuffer,034,15),15),;	// 	4-Valor ITR
						 cnvVal(substr(cBuffer,049,15),15),;	// 	5-Valor do pedagio
						 cnvVal(substr(cBuffer,064,15),15),;	// 	6-Valores Diversos/Outros
						 cnvVal(substr(cBuffer,079,15),15),;	// 	7-Valor de desconto
						 cnvVal(substr(cBuffer,094,15),15),;	// 	8-Valor Ademe
						 substr(cBuffer,109,05)			  ,;	// 	9-% de taxa do ISS
						 cnvVal(substr(cBuffer,114,15),15),;	// 10-Valor do ISS
						 substr(cBuffer,129,15)			  ,;	// 11-Base de calculo para apuracao ICMS
						 substr(cBuffer,144,05)			  ,;	// 12-% de taxa do ICMS
						 cnvVal(substr(cBuffer,149,15),15),;	// 13-Valor do ICMS
						 cnvVal(substr(cBuffer,164,15),15),;	// 14-Valor do Frete Ad Valorem
						 cnvVal(substr(cBuffer,179,15),15),;	// 15-Valor do despacho
						 substr(cBuffer,194,07)			  ,;	// 16-Peso a ser transportado
						})
		Case cTipo == "395"	// Documentos liberados para pagamento
			aAdd(aReg,	{substr(cBuffer,01,003)				,;	//	1-Identificador do registro
						 cnvVal(substr(cBuffer,04,015),15)  ,;	//	2-Valor total das pre faturas
						 val(substr(cBuffer,19,015))		;	//	3-Quantidade total de pre faturas
						})
*/
	EndCase
    cBuffer  := Space(nTamLin)
    nBtLidos := fRead(nHdl,@cBuffer,nTamLin)
EndDo

fClose(nHdl)

Return

/**********************************************************************
* Funcao.....:  fViewPFat()                                           *
* Autor......:  Marcelo Aguiar Pimentel                               *
* Data.......:  04/06/07                                              *
* Descricao..:  Monta dialogo para escolha de qual CTR será liberado  *
*                                                                     *
**********************************************************************/
Static Function fViewPFat()
Local nOpca:=1
Private olblist := 	nil
Private cPict	:=	"@E 99,999,999,999.99"
Private aCab	:= 	{ " "," ","Dt.Liberação","Pré Fatura","Cliente",;
					  "CNPJ/CGC"    ,"Serie Emb."  ,"Doc.Embarc."   ,"Dt.Emis. Emb." ,"Serie Transp."  ,;
					  "Num.Transp." ,"Dt.Emissao"  ,"CNPJ Origem"   ,"CNPJ Dest."    ,"Fisica/Juridica",;
					  "Val.Frt.Emb.","Val.Frt.Con.","Tipo Diferenca","Vlr.Dif.Fretes","Id.Doc.Int."    ,;
					  "CNPJ Transp."}
Private aPic 	:= 	{ " "," ","@D","@!","@!",;
					  "@!"          ,"@!"          ,"@!"            ,"@D"            ,"@!"           ,;
					  "@!"          ,"@D"          ,"@!"            ,"@!"            ,"@!"           ,;
					  cPict         ,cPict         ,"@!"            ,cPict           ,"@!"           ,;
					  "@!"}
Private aSizeCol:= 	{ 10,10,15,10,20,;
					  10            ,10            ,20              ,10              ,10             ,;
					  20            ,10            ,10              ,10              ,10             ,;
					  20            ,10            ,10              ,10              ,20             ,;
					  20}

DEFINE MSDIALOG oDlg2 TITLE OemToAnsi("Importação de Pré Faturas") FROM 078,022 TO 115,130 //OF oMainWnd 
olblist  := TWBrowse():New(  1 , 1 , 0400, 240 ,,aCab,aSizeCol,,,,,,,,,,,,, .F.,, .F.,, .F.,,, )
olblist:SetArray(aTit)
olblist:bLDblClick := {||aTit[olblist:nAt][1] := if(aTit[olblist:nAt][1]=ook,ono,iif(aTit[olblist:nAt][2]==oVerde ,ook,oNo)), oDlg2:Refresh()}
olblist:bLine      := {||LinBrw(olblist, aTit)}
olblist:lAutoEdit  := .T.
olblist:BHEADERCLICK:={|| fInverteMk()}

@ 19,10 BITMAP oVrd RESNAME "BR_VERDE" SIZE 16,16 NOBORDER of oDlg2
@ 21,07 SAY "Título encontrado"
@ 19,22 BITMAP oVer RESNAME "BR_VERMELHO" SIZE 16,16 NOBORDER 
@ 21,20 SAY "Título não encontrado"
@ 19,42 BITMAP oVer RESNAME "BR_AMARELO" SIZE 16,16 NOBORDER 
@ 21,40 SAY "Título já liberado"

Activate MSDialog oDlg2 ON INIT ;
EnchoiceBar(oDlg2, {|| nOpca := 2,oDlg2:End()},{|| nOpca := 1,oDlg2:End()},,{});
Centered

If nOpca == 2 // Ok
	ProcRegua(len(aTit))
	For nX:=1 to len(aTit)
		IncProc()
		If aTit[nX,1] == oOk .and. aTit[nX,2] == oVerde
			cQry:="UPDATE "+RetSqlName("SE1")
			cQry+="   SET E1_XDTLIB = '"+dtos(ctod(aTit[nX,3]))+"', E1_XPREFAT = '"+aTit[nX,4]+"'"
			cQry+=" WHERE E1_FILIAL   = '" + xFilial("SE1") + "'" // Incluído Por: Ricardo - Em: 28/04/08
			cQry+="   AND E1_PREFIXO  = 'CTR'"//+substr(cBuffer,052,05)+"'"			
			cQry+="   AND E1_NUM      = '"+aTit[nX,11]+"'"
			cQry+="   AND EXISTS (SELECT * FROM "+RetSqlName("SA1")
			cQry+="                WHERE A1_FILIAL = '"+xFilial("SA1")+"'"
			cQry+="                  AND A1_CGC = '"+aTit[nX,6]+"'"
			cQry+="                  AND E1_CLIENTE = A1_COD"
			cQry+="                  AND E1_LOJA    = A1_LOJA"
			cQry+="                  AND D_E_L_E_T_ <> '*')"
			cQry+="   AND D_E_L_E_T_ <> '*'"
			
//			MEMOWRIT("D:\TEMP\PREFAT.SQL",cQry)
			
			TcSqlExec(cQry)
			TcSqlExec("COMMIT")
			
//	    	cQry+="   AND E1_EMISSAO  = '"+DTOS(ctod(aTit[nX,11]))+"'" // Comentado em: 26/04/08 - Por: Ricardo - Segundo Diógenes, o arquivo TXT da Bosch não vem com a Data de emissão preenchida Corretamente.  			
		EndIf
	Next nX	
	fRename(cPath+cArqTxt,cPath+substr(cArqTxt,1,len(cArqTxt)-3)+"lib")
EndIf

Return

/************************************************************************
* Funcao.....:  fEstPFat()                                              *
* Autor......:  Marcelo Aguiar Pimentel                                 *
* Data.......:  06/06/07                                                *
* Descricao..:  Funcao para estorno da liberacao de pre-faturas         *
*                                                                       *
************************************************************************/
Static Function fEstPFat()
Local dDataDe	:=	ctod("  /  /  ")
Local dDataAte	:=	ctod("  /  /  ")
Local cCliente	:=	CriaVar("SA1->A1_COD")
Local cLoja		:=	CriaVar("SA1->A1_LOJA")
Local nOpc		:=	2

@ 200,1 TO 440,380 DIALOG oDlg TITLE OemToAnsi("Estorno de Pré Fatura de Transporte")
@ 00,00 TO 07,24
@ 01,002 Say " Este programa ira ler estornar a liberação da Pré fatura, segundo"
@ 1.5,002 Say " os parametros definidos pelo usuario."
@ 03,002 SAY "Liberação de:"
@ 03,007 Get dDataDe 	Picture "@D"
@ 04,002 SAY "Liberação até:"
@ 04,007 Get dDataAte 	Picture "@D"
@ 05,002 SAY "Cliente:"
@ 65,056 Get cCliente 	Picture "@!" F3 "SA1"
@ 06,002 SAY "Loja:"
@ 06,007 Get cLoja    	Picture "@!"


@ 10,19 BUTTON "Estornar" SIZE 40,15 ACTION (iif(!Empty(dDataDe) .and. !Empty(dDataAte) .and. ;
												 !Empty(cCliente) .and. !Empty(cLoja),(nOpc:=1,oDlg:End()),;
												 ApMsgAlert("Há parametro(s) em branco","Atenção")))
@ 10,30 BUTTON "Cancelar" SIZE 40,15 ACTION Close(oDlg)

Activate Dialog oDlg Centered
If nOpc == 1 // Estornar
	Processa({|| fEstorno(dDataDe,dDataAte,cCliente,cLoja) },"Aguarde o estorno...")
EndIf

Return

/************************************************************************
* Funcao.....:  fEstorno()                                              *
* Autor......:  Marcelo Aguiar Pimentel                                 *
* Data.......:  06/06/07                                                *
* Descricao..:  Funcao para estorno de liberacao de prefat segundo      *
*               parametros passado pelo usuario                         *
*                                                                       *
************************************************************************/
Static Function fEstorno(dDtDe,dDtAte,cCli,cLoja)
Local cQry:=""
ProcRegua(0)

cQry:="UPDATE "+RetSqlName("SE1")
cQry+="   SET E1_XDTLIB = ' ', E1_XPREFAT = ' '"
cQry+=" WHERE E1_FILIAL BETWEEN '  ' AND 'ZZ'"
cQry+="   AND E1_CLIENTE  = '"+cCli  +"'"
cQry+="   AND E1_LOJA	  = '"+cLoja +"'"
cQry+="   AND E1_XDTLIB BETWEEN '"+dtos(dDtDe)+"' AND '"+dtos(dDtAte)+"'"
cQry+="   AND D_E_L_E_T_ <> '*'"
TcSqlExec(cQry)
IncProc()
TcSqlExec("COMMIT")
IncProc()
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
* Autor......:  Marcelo Aguiar Pimentel                               *
* Data.......:  04/06/07                                              *
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
//		If aTit[nX,1] == oOk
			aTit[nX,1]:=oMk//oNo
//		Else
//			aTit[nX,1]:=oOk
//		EndIf
	Next nX
	oLbList:Refresh()
EndIf

Return