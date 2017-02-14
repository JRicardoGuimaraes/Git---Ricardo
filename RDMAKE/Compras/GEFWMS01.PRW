#include "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "TOPCONN.CH

/*
*---------------------------------------------------------------------------*
* Função     |GEFWMS01  | Autor | J Ricardo             | Data | 15.03.11   *
*---------------------------------------------------------------------------*
* Descrição  |Rotina para dar carga na interfa de Entrada do WMS            *
*            |                                                              *
*            |                                                              *
*---------------------------------------------------------------------------*
*/

USER Function GEFWMS01(lAutoR)
/*
aCab:= {}
aadd(aCab,{"C1_NUM","00000001",NIL})

aItem := {}
Aadd(aItem, {"C1_ITEM","01",NIL})
Aadd(aItem, {"C1_PRODUTO","BTE000023",NIL})
Aadd(aItem, {"C1_QUANT","58",NIL})

MSExecAuto( { |x,y,z| MATA103(x,y,z)}, aCab, aItem, 3)
*/

Private lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.

Private lAutoRot
Private _aLogImp:= {}
Private cLinha  := ""

lAutoRot:=iif(lAutoR = Nil,.F.,.T.)

ConOut("Inicio do Inicio de importação da interface WMS")

if lAutoRot //Se a rotina for automática.
	// Importa os arquivos do WMS-AR para as tabelas SF1 / SD1
	ConOut("Inicio de importação da interface WMS - Entrada")
	
	// Gera Documento de Entrada no Microsiga dos registros importados do WMS
	RPCSetType(3) // Nao consome o numero de licencas
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "COM" TABLES "SA1","SA2","SB1","SD1","SF1","CTT","SF4","SE2","SED","SE4"
	
	fGeraEntrada()
	
	ConOut("Final de Geração de documento de entrada através de interface WMS-AR.")
	
	RESET ENVIRONMENT

Else

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da tela de processamento.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 200,001 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Processamento de Interface WMS - Entrada - PROTHEUS.")
	@ 002,010 TO 080,190
	@ 10,018 Say " Este programa ira ler as entradas do WMS - AR           "
	@ 18,018 Say " ADT e gerar documentos de entrada no módulo de Compras. "
	@ 60,098 BMPBUTTON TYPE 01 ACTION Processa({|| fGeraEntrada(), Close(oLeTxt) },"Processando....")
	@ 60,128 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
		
	Activate Dialog oLeTxt Centered
	
	Return

EndIf

Return

*---------------------------------*
Static Function fGeraEntrada()
*---------------------------------*
Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX     := 0
Local nY     := 0
Local cDoc   := ""
Local lOk    := .T.
Local _cQry  := ""
Local _cNFAnt:= ""
Local _aAreaSM0 := SM0->(GetArea())
Local cAssunto := ""
Local cCc      := ""
Local cPara    := ""
Local cDe      := ""
Local cMsg     := ""
Local _cFilOld := ""

_cQry := " SELECT C.FILIAL, C.NUMERO_NF_ENTRADA, C.SERIE_NF_ENTRADA, C.CNPJ_ENTRADA, C.DATA_EMISSAO, C.NATUREZA, C.DATA_IMPORTACAO, C.OBSERVACAO, "
_cQry += "        I.QUANTIDADE, I.VALOR_UNITARIO, I.TIPO_ENTRADA, I.CENTRO_CUSTO, I.GRUPO_PRODUTO, I.PRODUTO, I.DESCRICAO_PRODUTO, I.TIPO_PRODUTO,"
_cQry += "        I.UNIDADE, I.CONTA_CONTABIL		 "
_cQry += "  FROM WMS_ENTRADAS C, WMS_ITENS_ENTRADA I "
_cQry += " WHERE C.FILIAL = I.FILIAL "
_cQry += " 	 AND C.NUMERO_NF_ENTRADA = I.NUMERO_NF_ENTRADA "
_cQry += " 	 AND C.SERIE_NF_ENTRADA = I.SERIE_NF_ENTRADA "
_cQry += "     	 AND C.CNPJ_ENTRADA = I.CNPJ_ENTRADA "
_cQry += " 	 AND C.DATA_IMPORTACAO='' "
_cQry += " ORDER BY C.FILIAL, C.NUMERO_NF_ENTRADA, C.SERIE_NF_ENTRADA, C.CNPJ_ENTRADA "

If Select("TWMS") > 0
	dbSelectArea("TWMS") ; dbCloseArea()
EndIf

TCQUERY _cQry ALIAS TWMS NEW 

dbSelectArea("TWMS") ; dbGoTop()

If Eof()
	If lAutoRot
		ConOut("Não dados do WMS de Entrada à importar.")
	Else
		Alert("Não dados do WMS de Entrada à importar.")
	End	
	
	dbSelectArea("TWMS") ; dbCloseArea()
	Return
EndIf

If lAutoRot
	ConOut(OemToAnsi("Inicio da Importação: ")+Time())
EndIf

//_cFilOld := TWMS->FILIAL

While !TWMS->(Eof())
//While !TWMS->(Eof()) .AND. _cFilOld = TWMS->FILIAL

	dbSelectArea("SM0")
	dbSetOrder(1)   // forca o indice na ordem certa
	nRegSM0 := Recno()
	dbSeek(SUBS(cNumEmp,1,2)+TWMS->FILIAL)
	_cFilOld:= cFilAnt
	cFilAnt := TWMS->FILIAL
     
    ****************************
    *  Verifica Fornecedor     *
    ****************************
    /*
    	Por: Ricardo Guimarães - Em: 09/06/2016
    	Solitado por: Sandra(DSI) / Rosa(Fiscal)
    	Objetivo: Passar a dar entrada usando Cliente em vez de Fornecedor 
    */
    // dbSelectArea("SA2") ; dbSetOrder(3)
    // If !dbSeek(xFilial("SA2") + AllTrim(TWMS->CNPJ_ENTRADA))
    dbSelectArea("SA1") ; dbSetOrder(3)
    If !dbSeek(xFilial("SA1") + AllTrim(TWMS->CNPJ_ENTRADA))    
    	AADD(_aLogImp,{TWMS->FILIAL,"Nota: " + AllTrim(TWMS->NUMERO_NF_ENTRADA) + " - Forn.: " + TWMS->CNPJ_ENTRADA + " inexistente no Protheus","E",GETMV("MV_XMAILWM")})
    	CONOUT("Nota: " + AllTrim(TWMS->NUMERO_NF_ENTRADA) + " - Forn.: " + TWMS->CNPJ_ENTRADA + " inexistente no Protheus")
		 
		// Posiciono na próxima NF
		dbSelectArea("TWMS")
		_cNFAnt := TWMS->NUMERO_NF_ENTRADA
		While !TWMS->(Eof()) .AND. _cNFAnt = TWMS->NUMERO_NF_ENTRADA
			dbSelectArea("TWMS")
			dbSkip()
		End
		Loop
    EndIf

	aCabec := {}
	aItens := {}
	
	// Monto cabeçalho da NF
	aadd(aCabec,{"F1_TIPO"   ,"B"}) // Era "N" até o dia 09/06/2016 - Passou a usar cad. Fornecedor
	aadd(aCabec,{"F1_FORMUL" ,"N"})
	aadd(aCabec,{"F1_FILIAL" ,TWMS->FILIAL})
	aadd(aCabec,{"F1_DOC"    ,TWMS->NUMERO_NF_ENTRADA})
	aadd(aCabec,{"F1_SERIE"  ,TWMS->SERIE_NF_ENTRADA})
	aadd(aCabec,{"F1_EMISSAO",STOD(TWMS->DATA_EMISSAO)})
	// aadd(aCabec,{"F1_FORNECE",SA2->A2_COD})
	// aadd(aCabec,{"F1_LOJA"   ,SA2->A2_LOJA})
	aadd(aCabec,{"F1_FORNECE",SA1->A1_COD})
	aadd(aCabec,{"F1_LOJA"   ,SA1->A1_LOJA})	
	aadd(aCabec,{"F1_ESPECIE","NF"})
	aadd(aCabec,{"F1_COND","001"})
	aadd(aCabec,{"F1_STATUS",""})
	aadd(aCabec,{"E2_NATUREZ",""})

	dbSelectArea("TWMS")
	_cNFAnt := TWMS->NUMERO_NF_ENTRADA
	
	While !TWMS->(Eof()) .AND. _cNFAnt = TWMS->NUMERO_NF_ENTRADA
	
	   	****************************
    	*  Verifica Produtos       *
    	****************************    
		fProduto()

		aLinha := {}
		aadd(aLinha,{"D1_COD"  ,TWMS->PRODUTO,Nil})		
		aadd(aLinha,{"D1_QUANT",TWMS->QUANTIDADE,Nil})
		aadd(aLinha,{"D1_VUNIT",TWMS->VALOR_UNITARIO,Nil})
//		aadd(aLinha,{"D1_TOTAL",TWMS->QUANTIDADE * TWMS->VALOR_UNITARIO,Nil})
		aadd(aLinha,{"D1_CC"   ,GETMV("MV_XCCE"),Nil})
		aadd(aLinha,{"D1_TES"  ,GETMV("MV_XTES_E"),Nil})
		aadd(aItens,aLinha)

		dbSelectArea("TWMS")
		dbSkip()	
	End
	
	******************************************************************
	// Teste de Inclusao \\
	******************************************************************
    MSExecAuto({|x,y| mata103(x,y)},aCabec,aItens, 3)
	If !lMsErroAuto
		If lAutoRot
			ConOut(OemToAnsi("Incluido com sucesso! ")+aCabec[4,2])
		Else
			Alert(OemToAnsi("Incluido com sucesso! ")+aCabec[4,2])
		EndIf

    	AADD(_aLogImp,{AllTrim(aCabec[3,2]),"Nota: " + AllTrim(aCabec[4,2]) + " - Forn.: " + AllTrim(SA2->A2_CGC) + " incluído com sucesso","I",GETMV("MV_XMAILWM")})
		
		// Atualizo o Status de Importação para o Registro
		_cQry := " UPDATE WMS_ENTRADAS "
		_cQry += " 	SET DATA_IMPORTACAO = '" + DTOS(dDataBase) + Time() + "' "
		_cQry += " 	WHERE FILIAL            ='" + aCabec[3,2] + "' "
		_cQry += " 	  AND NUMERO_NF_ENTRADA ='" + aCabec[4,2] + "' "
		_cQry += " 	  AND SERIE_NF_ENTRADA  ='" + aCabec[5,2] + "' "
		_cQry += " 	  AND CNPJ_ENTRADA      ='" + AllTrim(SA1->A1_CGC) + "' "  // Alterado em 09/06/2016 - AllTrim(SA2->A2_CGC)
		
		conout("DOC : " + aCabec[3,2])
		
		If TcSqlExec(_cQry) < 0
			If lAutoRot
				ConOut("Erro ao tentar atualizar o status da importação de entrada do WMS" + CHR(13) + TCSQLError())
			Else
				MsgAlert("Erro ao tentar excluir a Fatura, favor comunicar o Adm. do Sistema." + CHR(13) + TCSQLError())
			EndIf
		EndIf
	Else
		If lAutoRot
			ConOut(OemToAnsi("Erro na inclusao!"))
		Else
			// Alert(OemToAnsi("Erro na inclusao!"))
			// Alert(MostraErro())			
			ConOut("WMS - Entrada " + cLinha)
		EndIf	
    	AADD(_aLogImp,{AllTrim(aCabec[3,2]),"Nota: " + AllTrim(aCabec[4,2]) + " - Forn.: " + AllTrim(SA2->A2_CGC) + " - " + StrTran(StrTran(Left(cLinha,55),chr(10),""),chr(13),""),"E",GETMV("MV_XMAILWM")})
	EndIf

	dbSelectArea("SM0")
	dbGoTo(nRegSM0)	
	cFilAnt := _cFilOld
	
	dbSelectArea("TWMS")
End

ConOut(OemToAnsi("Fim Importação WMS : ")+Time())

dbSelectArea("TWMS") ; dbCloseArea()

_cNotas := ""

If Len(_aLogImp) > 0
	cAssunto := "WMS - Entrada - Status de Importação Automática - " + dTOc(dDataBase)
	cCc      := "" // "jose.guimaraes@gefco.com.br"
	cPara    := GETMV("MV_XMAILWM") // SZS->ZS_EMAILS
	cDe      := GETMV("MV_RELFROM") // "relatorio@gefco.com.ar"  // SZS->ZS_EMAIL
//	cMsg     += "Filial: " + ALLTRIM(_aLogImp[1,1])   + CHR(13) + CHR(10)
	cMsg     += "Data  : " + dtoc(dDatabase)          + CHR(13) + CHR(10)
	cMsg     += "Hora  : " + Left(Time(),5)           + CHR(13) + CHR(10) + CHR(13) + CHR(10)
	
	_cFilAnt := _aLogImp[1,1]
	
	For x:=1 To Len(_aLogImp)
		cPara    := _aLogImp[x,4] // e-mail para
		
		If _cFilAnt == _aLogImp[x,1]
			_cNotas += _aLogImp[x,2] + "FILIAL: " + _aLogImp[x,1] + CHR(13) + CHR(10)
		Else
		    cMsg += _cNotas
			*---------------------------------------------------------------------*
			U_EnvEmail(cDe,cPara,cCc,cAssunto + " - Filial: " + _cFilAnt,cMsg,)	
			*---------------------------------------------------------------------*		
			_cNotas   := ''
			_cFilAnt  := _aLogImp[x,1]
			_cNotas   += _aLogImp[x,2] + "FILIAL: " + _aLogImp[x,1] + CHR(13) + CHR(10)
		EndIf
	Next x
	
	// Envio o log da a última filial
	If !Empty(_cNotas)
		cMsg += _cNotas
		U_EnvEmail(cDe,cPara,cCc,cAssunto + " - Filial: " + _cFilAnt,cMsg,)
	EndIf
EndIf

Return(.T.)
/*
Parâmetros:

 Nome   Tipo   Descrição   Default   Obrigatório   Referência  
 PARAMIXB1   Vetor   Array contendo o cabeçalho da Nota Fiscal de Entrada.           
 PARAMIXB2   Vetor   Array contendo os ítens da Nota Fiscal de Entrada.           
 PARAMIXB3   Numérico   Opção desejada: 3-Inclusão; 4-Alteração ; 5-Exclusão   3        
 PARAMIXB4   Lógico   Indica se Apresenta ou não a Dialog da Rotina em Rotina Automatica.   .F.        
 PARAMIXB5   Vetor   Array contendo os impostos a serem alterados.           
..
Conteúdo Colaborativo + Novo Tópico ..
*/  

*************************************
// Função para Cadastrar o Produto \\
Static Function fProduto()
*************************************
Local _aArea := GetArea()

dbSelectArea("SB1") ; dbSetOrder(1)
If !dbSeek(xFilial("SB1") + AllTrim(TWMS->PRODUTO))
	// Inclusão do produto
	If RecLock("SB1",.T.)
		SB1->B1_GRUPO := "0500"
		SB1->B1_COD   := TWMS->PRODUTO
		SB1->B1_DESC  := TWMS->DESCRICAO_PRODUTO
		SB1->B1_TIPO  := "PA"
		SB1->B1_UM    := TWMS->UNIDADE
		SB1->B1_LOCPAD:= "01"
	   MSUnLock()	
	EndIf
EndIf

RestArea(_aArea)
Return