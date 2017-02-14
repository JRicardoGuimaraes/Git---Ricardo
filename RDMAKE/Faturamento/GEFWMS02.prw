#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "tbiconn.ch"
/*****************************************************************************
* Programa.......: GEFWMS02()                                                *
* Autor..........: Ricardo Guimarães                                         *
* Data...........: 17/03/2011                                                *
* Descricao......:                                                           *
*                                                                            *
*****************************************************************************/

User Function GEFWMS02(lAutoR)
Private nOpc 		:= 	3 // Inclusao   4 // Alteracao  5 // Exclusao
// Variaveis para o Cabecalho
Private cPedido 	:= 	""
Private cFil		:=	""
 
// Variaveis utilizadas pelo MATA410
Private lMSErroAuto := 	.F.
Private lMSHelpAuto := 	.F. // para mostrar os erros na tela
Private lAmostra    := 	.F.				
Private aCab   		:=	{}
Private	aReg		:=	{}
Private	aItens		:=	{}
// Private lAutoRot:=iif(lAutoR = Nil,.f.,lAutoR)
Private lAutoRot:=iif(lAutoR = Nil,.f.,.T.)

ConOut("Inicio do Inicio de importação da interface WMS - Saída")

if lAutoRot //Se a rotina for automática.
	// Gera pedidos no Microsiga dos registros importados do WMS - Saída
	RPCSetType(3) // Nao consome o numero de licencas
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT" TABLES "SA1","SB1","SC5","SC6","CTT","SF4","SE2","SED"
	ConOut("Final de importação da interface WMS - Saída")
	
	ConOut("Inicio de Geração de pedidos através de interface WMS - Saída.")
	fGeraPED()
	ConOut("Final de Geração de pedidos através de interface WMS - Saída.")
	
	RESET ENVIRONMENT

Else


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da tela de processamento.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 200,001 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Processamento de Importação de Interface - WMS - Saida.")
	@ 002,010 TO 080,190
	@ 10,018 Say " Este programa ira ler a interface gerada pelo sistema WMS "
	@ 18,018 Say " ADT e gerar pedidos de vendas para faturamento.
	@ 60,098 BMPBUTTON TYPE 01 ACTION Processa({|| fGeraPED(), Close(oLeTxt) },"Processando....")
	@ 60,128 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
		
	Activate Dialog oLeTxt Centered
	
EndIf

                       
Return
/*****************************************************************************
* Programa.......: fGeraPED                                                  *
* Autor..........: Ricardo Guimaraes                                         *
* Data...........: 17/03/2011                                                *
* Descricao......:                                                           *
*                                                                            *
******************************************************************************
* Modificado por.:                                                           *
* Data...........:                                                           *
* Motivo.........:                                                           *
*                                                                            *
*****************************************************************************/
Static Function fGeraPED
Local _cTipoDesp := ""
Local _cObs      := ""
Local _cTES		 := ""
Local _aPedidos  := {}
Local _cPedidos   := ""
Local cNL         := CHR(13)+CHR(10)

PRIVATE _cEmpOld  := SM0->M0_CODIGO
PRIVATE _cFilOld  := SM0->M0_CODFIL

dbSelectArea("SA1")
dbSetOrder(3)

dbSelectArea("SB1")
dbSetOrder(1)

/*
cQry := " SELECT C.FILIAL, C.NUMERO_NF_SAIDA, C.SERIE_NF_SAIDA, C.CNPJ_CLIENTE, C.NATUREZA, C.DATA_IMPORTACAO, C.OBSERVACAO, "
cQry += " 	I.QUANTIDADE, I.VALOR_UNITARIO, I.TIPO_SAIDA, C.CENTRO_CUSTO, I.GRUPO_PRODUTO, I.PRODUTO, I.DESCRICAO_PRODUTO, I.TIPO_PRODUTO, "
cQry += " 	I.UNIDADE, I.CONTA_CONTABIL "
cQry += "  FROM WMS_SAIDAS C, WMS_ITENS_SAIDAS I "
cQry += " WHERE C.FILIAL = I.FILIAL "
cQry += "   AND C.NUMERO_NF_SAIDA = I.NUMERO_NF_SAIDA "
cQry += " 	AND C.SERIE_NF_SAIDA = I.SERIE_NF_SAIDA "
cQry += " 	AND C.CNPJ_CLIENTE = I.CNPJ_CLIENTE "
cQry += " 	AND C.DATA_IMPORTACAO='' "
cQry += " ORDER BY C.FILIAL, C.NUMERO_NF_SAIDA, C.SERIE_NF_SAIDA, C.CNPJ_CLIENTE "
*/

cQry := " SELECT C.FILIAL, C.NUMERO_NF_SAIDA, C.SERIE_NF_SAIDA, C.CNPJ_CLIENTE, C.NATUREZA, C.DATA_IMPORTACAO, C.OBSERVACAO, C.CENTRO_CUSTO "
cQry += "  FROM WMS_SAIDAS C "
cQry += " WHERE C.DATA_IMPORTACAO='' "
cQry += " ORDER BY C.FILIAL, C.NUMERO_NF_SAIDA, C.SERIE_NF_SAIDA, C.CNPJ_CLIENTE "

TcQuery cQry Alias "CBP" New

While !Eof()
	aCab := {}
	
	cFil	:=	CBP->FILIAL
                                      
	cFilAnt := cFil
	SM0->( dbSeek( _cEmpOld + cFil ) )
                                              
	cPedido:=GetSXENum("SC5")
	ConfirmSx8()	
	
	dbSelectArea("SA1") ; dbSetOrder(3)
	If !dbSeek(xFilial("SA1")+CBP->CNPJ_CLIENTE)
		// Gera Log
	EndIf	
	
	_cCC		:= GETMV("MV_XCCS")
	_cTipoDesp 	:= Iif( SubStr(_cCC,7,3) $ "401|403|011|014|015|017|405|501|502|505"            , "I",;
				   Iif( SubStr(_cCC,7,3) $ "402|404|003|004|006|008|012|016|406|410|503|504|506", "E","O" ) )				  
	
	BEGIN TRANSACTION
    RecLock("SC5",.T.)
		SC5->C5_FILIAL  := CBP->FILIAL
		SC5->C5_NUM		:= cPedido
		SC5->C5_TIPO	:= "N"
		SC5->C5_XTIPONF	:= "NFS"
		SC5->C5_CLIENTE	:= SA1->A1_COD
		SC5->C5_LOJACLI	:= SA1->A1_LOJA
		SC5->C5_TIPOCLI	:= SA1->A1_TIPO
		SC5->C5_CONDPAG	:= IIF(Empty(SA1->A1_COND),"004",SA1->A1_COND)
		SC5->C5_CCUSTO	:= _cCC
		SC5->C5_NATUREZ	:= GETMV("MV_XNATSAI")  // "606"
		SC5->C5_CTAPSA	:= ""
		SC5->C5_CCUSPSA	:= ""
		SC5->C5_OIPSA	:= ""
		SC5->C5_REFGEFC	:= ""
		SC5->C5_TPDESP	:= "O"  // _cTipoDesp
		SC5->C5_XOBS	:= "" // _cObs
		SC5->C5_EMISSAO	:= DDATABASE
		SC5->C5_ESPECI4 := "WMS-ADT" // IIF(cCodSis=="01","SIPCO","ISYGO")
		SC5->C5_GEFEMIS	:= dDataBase
		SC5->C5_CLIENT	:= SA1->A1_COD
		SC5->C5_LOJAENT := SA1->A1_LOJA
		SC5->C5_MOEDA	:= 1
		SC5->C5_TIPLIB	:= "1"
    MsUnLock()
    
    // Guardo os pedidos gerados para enviar lista por e-mail.
    AADD(_aPedidos, {CBP->FILIAL, cPedido} )
    
	// Itens do Pedido de Venda
	aReg := {}
	aItens:={}
	cQry:="SELECT S.*"
	cQry+="  FROM WMS_ITENS_SAIDAS S"
	cQry+=" WHERE S.FILIAL          = '"+ CBP->FILIAL		   +"'"
	cQry+="   AND S.NUMERO_NF_SAIDA = '"+ CBP->NUMERO_NF_SAIDA +"'"
	cQry+="   AND S.SERIE_NF_SAIDA  = '"+ CBP->SERIE_NF_SAIDA  +"'"
	cQry+="   AND S.CNPJ_CLIENTE    = '"+ CBP->CNPJ_CLIENTE	   +"'"

	TcQuery cQry Alias "TITENS" New
    
	_cTES  := GETMV("MV_XTES_S")
	_cItem := "00"

	dbSelectArea("TITENS") ; dbGoTop()

	While !Eof()

		// Valida Produto
		fProduto()
  
  		_cItem := SOMA1(_cItem)
  		
		RecLock("SC6",.T.)
			SC6->C6_FILIAL  := CBP->FILIAL
			SC6->C6_NUM		:= cPedido
			SC6->C6_ITEM	:= _cItem
			SC6->C6_PRODUTO	:= SB1->B1_COD
			SC6->C6_DESCRI	:= SB1->B1_DESC
			SC6->C6_UM		:= SB1->B1_UM
			SC6->C6_LOCAL	:= SB1->B1_LOCPAD
			SC6->C6_TES		:= _cTES
			SC6->C6_CF		:= POSICIONE("SF4",1,xFilial("SF4")+_cTES,"F4_CF")
			SC6->C6_CODISS	:= SB1->B1_CODISS
			SC6->C6_QTDVEN	:= TITENS->QUANTIDADE
			SC6->C6_PRCVEN	:= TITENS->VALOR_UNITARIO
			SC6->C6_VALOR	:= TITENS->QUANTIDADE * TITENS->VALOR_UNITARIO
			SC6->C6_CLI		:= SA1->A1_COD
			SC6->C6_LOJA	:= SA1->A1_LOJA
			SC6->C6_TPOP	:= "F"
			SC6->C6_ENTREG  := DDATABASE
			SC6->C6_SUGENTR := DDATABASE
		MsUnLock()
		      
		aItens:={}
		
		// Atualizo o número do Pedido
		cQry:="UPDATE WMS_SAIDAS "
		cQry+="   SET NUMERO_PEDIDO_PROTHEUS = '"+cPedido+"', DATA_IMPORTACAO = '" + DTOS(dDataBase) + "' "
		cQry+=" WHERE FILIAL          = '"+ CBP->FILIAL		     +"'"
		cQry+="   AND NUMERO_NF_SAIDA = '"+ CBP->NUMERO_NF_SAIDA +"'"
		cQry+="   AND SERIE_NF_SAIDA  = '"+ CBP->SERIE_NF_SAIDA  +"'"
		cQry+="   AND CNPJ_CLIENTE    = '"+ CBP->CNPJ_CLIENTE    +"'"

		If TcSqlExec(cQry) < 0
			If lAutoRot
				ConOut("Erro ao tentar atualizar o status da importação de saida do WMS" + CHR(13) + TCSQLError())
			Else
				MsgAlert("Erro ao tentar atualizar o status da importação de saída do WMS, favor comunicar o Adm. do Sistema." + CHR(13) + TCSQLError())
			EndIf
		EndIf		
		
		TcSQLExec("COMMIT")		
		
		dbSelectArea("TITENS")
		dbSkip()
	EndDo
	dbSelectArea("TITENS")
	dbCloseArea()

	END TRANSACTION // Fim transação do RecLock()

	dbSelectArea("CBP")
	dbSkip()
EndDo

dbSelectArea("CBP")
dbCloseArea()

// Restauro a empresa e filial
cFilAnt   := _cFilOld
SM0->( dbSeek( _cEmpOld + _cFilOld ) )

// Envio e-mail com lista de pedidos gerados
// Ordeno o Array por Filial
_aPedidos := aSort( _aPedidos,,, { | x , y | x[1] < y[1] } )


If Len(_aPedidos) > 0 
	// Envio e-mail com os logs de erro para a Filial
	_cFilAnt := _aPedidos[1,1]
	For x:=1 To Len(_aPedidos)
	
		If _cFilAnt == _aPedidos[x,1]
			_cPedidos += _aPedidos[x,2] + cNL
		Else 
			*-----------------------------*
			fEnviaEMail(_cFilAnt,_cPedidos)
			*-----------------------------*		
			_cPedidos := ''
			_cFilAnt  := _aPedidos[x,1]
			_cPedidos += _aPedidos[x,2] + cNL		
		EndIf
	Next x
	
	// Envio o log da a última filial
	If !Empty(_cPedidos)
		fEnviaEMail(_cFilAnt,_cPedidos)
	EndIf
Else
	If lAutoRot
		ConOut("Não há interface pendente para gerar pedidos.")
	EndIf	
EndIf		

Return


*--------------------------------------------*
Static Function fEnviaEmail(_cFilial,_cPeds)
*--------------------------------------------*

//Local cMailServer := GetMv("MV_WFSMTP") 
Local cMailServer :=GetMV("MV_RELSERV")
Local cSubject    := ""
Local cBody       := ""
Local aFiles      := {}
Local cToCC       := AllTrim("")
Local _cMsg       := ""          
Local cEmail      := ""

/*cPass     := GetMv("MV_WFPASSW")
cAccount  := GetMv("MV_WFACC")*/

cEmail := AllTrim(POSICIONE("SX6",1,_cFilial + "MV_XMAILWM","X6_CONTEUD"))
	
If Empty(cEmail)
	cEmail := "jose.guimaraes@gefco.com.br"
	cBody  := _cFilial + " - Sem parametrização de e-mails no configurador para os usuários que irão receber a errada do Isygo."
EndIf

cEmailOri := GETMV("MV_RELFROM") // "interfaces-fat@gefco.com.br" 
cAccount  := GetMV("MV_RELACNT")
cPass     := GetMV("MV_RELPSW")

cTo       := AllTrim(cEmail)

cSubject  := "WMS - Pedidos Gerados no Microsiga Protheus" 

_cMsg     += "Segue Lista de pedidos gerados no sistema Protheus através da interface WMS/ADT! - Filial = "    + _cFilial + Chr(13) + Chr(10)
_cMsg     += "===================================================================================================" + Chr(13) + Chr(10)

cBody     := _cMsg + _cPeds

U_EnvEmail(cEmailOri,cTo,cTOCc,cSubJect,cBody,)	

Return

*************************************
// Função para Cadastrar o Produto \\
Static Function fProduto()
*************************************
Local _aArea := GetArea()

dbSelectArea("SB1") ; dbSetOrder(1)
If !dbSeek(xFilial("SB1") + AllTrim(TITENS->PRODUTO))
	// Inclusão do produto
	If RecLock("SB1",.T.)
		SB1->B1_GRUPO := "0500"
		SB1->B1_COD   := TITENS->PRODUTO
		SB1->B1_DESC  := TITENS->DESCRICAO_PRODUTO
		SB1->B1_TIPO  := "PA"
		SB1->B1_UM    := TITENS->UNIDADE
		SB1->B1_LOCPAD:= "01"
	   MSUnLock()	
	EndIf
EndIf

RestArea(_aArea)
Return