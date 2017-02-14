#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "tbiconn.ch"
/*****************************************************************************
* Programa.......: GEFSH001()                                                *
* Autor..........: Marcelo Aguiar Pimentel                                   *
* Data...........: 17/04/2007                                                *
* Descricao......:                                                           *
*                                                                            *
******************************************************************************
* Modificado por.: J Ricardo                                                 *
* Data...........: 17/03/2008                                                *
* Motivo.........: Enviar a lista de pedidos gerados por e-mail              *
*                                                                            *
*****************************************************************************/
/*****************************************************************************
* Modificado por.: J Ricardo                                                 *
* Data...........: 22/12/2010                                                *
* Motivo.........: Gerar pedido da interface SIPCO, gerado nas tabelas       *
*                  CABEC_PRESTACAO e ITENS_PRESTACAO                         *
*                                                                            *
*****************************************************************************/

User Function GEFSH001(lAutoR)
Private nOpc 		:= 	3 // Inclusao   4 // Alteracao  5 // Exclusao
// Variaveis para o Cabecalho
Private cPedido 	:= 	""
Private cFil		:=	""
Private cIdSeq	:=	""
Private cCodSis	:=	""
 
// Variaveis utilizadas pelo MATA410
Private lMSErroAuto := 	.F.
Private lMSHelpAuto := 	.F. // para mostrar os erros na tela
Private lAmostra    := 	.F.				
Private aCab   		:=	{}
Private	aReg		:=	{}
Private	aItens		:=	{}
// Private lAutoRot:=iif(lAutoR = Nil,.f.,lAutoR)
Private lAutoRot:=iif(lAutoR = Nil,.f.,.T.)

ConOut("Inicio do Inicio de importação da interface ISYGO/SIPCO/WMS")

if lAutoRot //Se a rotina for automática.
	// Importa os arquivos do ISYGO para a tabela intermediária( CABEC_PRESTAÇÃO/ITENS_PRESTAÇÃO )
	ConOut("Inicio de importação da interface ISYGO/SIPCO/WMS")
	U_GEFM61x(lAutoR)
	
	// Gera pedidos no Microsiga dos registros importados do ISYGO
	RPCSetType(3) // Nao consome o numero de licencas
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT" TABLES "SA1","SB1","SC5","SC6","CTT","SF4","SE2","SED"
	ConOut("Final de importação da interface ISYGO")
	
	ConOut("Inicio de Geração de pedidos através de interface ISYGO/SIPCO FAT/WMS.")
	PROCPED()	
	ConOut("Final de Geração de pedidos através de interface ISYGO/SIPCO FAT/WMS.")
	
	RESET ENVIRONMENT

Else


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da tela de processamento.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 200,001 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Processamento de Prestações - ISYGO/SIPCO FAT.")
	@ 002,010 TO 080,190
	@ 10,018 Say " Este programa ira ler as prestações geradas pelos sistemas "
	@ 18,018 Say " SIPCO / ISYGO e gerar pedidos de vendas para faturamento.
	@ 60,098 BMPBUTTON TYPE 01 ACTION Processa({|| PROCPED() },"Processando....")
	@ 60,128 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
		
	Activate Dialog oLeTxt Centered
	
	Return
	

EndIf

                       
Return
/*****************************************************************************
* Programa.......: PROCPED                                                   *
* Autor..........: Marcelo Aguiar Pimentel                                   *
* Data...........: 17/04/2007                                                *
* Descricao......:                                                           *
*                                                                            *
******************************************************************************
* Modificado por.:                                                           *
* Data...........:                                                           *
* Motivo.........:                                                           *
*                                                                            *
*****************************************************************************/
Static Function PROCPED
Local _cTipoDesp := ""
Local _cObs      := ""
Local _cTES		 := ""
Local _aPedidos  := {}
Local _cPedidos   := ""
Local cNL         := CHR(13)+CHR(10)

PRIVATE _cEmpOld  := SM0->M0_CODIGO
PRIVATE _cFilOld  := SM0->M0_CODFIL

dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SB1")
dbSetOrder(1)

cQry:="SELECT CBP.*,CBP.OBS"
cQry+="  FROM CABEC_PRESTACAO CBP, ITENS_PRESTACAO ITP"
cQry+=" WHERE NOT EXISTS(SELECT * FROM LOG_PRESTACAO LGP"
cQry+="                   WHERE CBP.FILIAL = LGP.FILIAL"
// cQry+="                     AND CBP.IDSEQ = LGP.IDSEQ"
cQry+="                     AND CBP.IDSEQ = LGP.IDSEQ"
cQry+="                     AND CBP.CODSISTEMA = LGP.CODSISTEMA)"
cQry+="   AND CBP.FILIAL = ITP.FILIAL "
cQry+="   AND CBP.IDSEQ  = ITP.IDSEQ  "
//cQry+="   AND CBP.TIPOREG= 'VEN' "

/*

 Codigo de Sistema - CODSISTEMA
 01 - ISYGO
 02 - SIPCO
 03 - WMS
 
*/

TcQuery cQry Alias "CBP" New
While !Eof()
	aCab := {}
	
	cFil	:=	CBP->FILIAL
	cIdSeq	:=	CBP->IDSEQ
	cCodSis	:=	CBP->CODSISTEMA
                                      
	cFilAnt := cFil
	SM0->( dbSeek( _cEmpOld + cFil ) )
                                              
	*-----------------------------------------------*
    * Gerar Provisão de Compra no Financeiro        *
    * Por: Ricardo Guimarães - Em: 28/11/2008       *
	*-----------------------------------------------*
/*	
    If CBP->TIPOREG == 'COM'
    	*-----------------------------*
		IncProvCom()
    	*-----------------------------*
    	
    	dbSelectArea("CBP")
    	Loop
    EndIf
*/	
	cPedido:=GetSXENum("SC5")
	ConfirmSx8()	
//	cPedido:=GetSX8Num("SC5")

//	aAdd(aCab,{"C5_NUM"		,cPedido			,nil}) // Nro.do Pedido
//	aAdd(aCab,{"C5_TIPO"	,"N"				,nil}) //Tipo de Pedido - "N"-Normal
	
	dbSelectArea("SA1")
	dbSeek(xFilial("SA1")+CBP->CODCLIENTE)
/*	
	aAdd(aCab,{"C5_CLIENTE"	,SA1->A1_COD		,nil})
	//aAdd(aCab,{"C5_LOJAENT"	,SA1->A1_LOJA		,nil})
	aAdd(aCab,{"C5_LOJACLI"	,SA1->A1_LOJA		,nil})
	//Verificar o tipo padrao de cliente
	aAdd(aCab,{"C5_TIPOCLI"	,SA1->A1_TIPO		,nil})
	aAdd(aCab,{"C5_CONDPAG"	,IIF(Empty(SA1->A1_COND),"004",SA1->A1_COND),nil})
	aAdd(aCab,{"C5_CCUSTO" 	,CBP->CCUSTO		,nil})
	aAdd(aCab,{"C5_CTAPSA"	,CBP->CONTAPSA		,nil})  
	aAdd(aCab,{"C5_CCUSPSA"	,CBP->CCUSTOPSA		,nil})
	aAdd(aCab,{"C5_OIPSA"	,CBP->OIPSA			,nil})
//	aAdd(aCab,{"C5_TPDESP"	,CBP->TIPO			,nil})
	aAdd(aCab,{"C5_TPDESP"	,"O"				,nil})	
	aAdd(aCab,{"C5_XOBS"	,CBP->OBS			,nil})
	aAdd(aCab,{"C5_EMISSAO"	,stod(CBP->DATAP)	,nil})
//	aAdd(aCab,{"C5_ESPECI4"	,"ISYGO"	        ,nil})	
//	aAdd(aCab,{"C5_GEFEMIS"	,DDATABASE          ,nil})	
//	aAdd(aCab,{"C5_CLIENT"	,SA1->A1_COD		,nil})                    
*/                           
/*                      
	_cTipoDesp := Iif( SubStr(CBP->CCUSTO,7,3) == "401" .OR. SubStr(CBP->CCUSTO,7,3) == "403", "I",;
				  Iif( SubStr(CBP->CCUSTO,7,3) == "402" .OR. SubStr(CBP->CCUSTO,7,3) == "404", "E","O" ) )
*/				  
	_cTipoDesp 	:= Iif( SubStr(CBP->CCUSTO,7,3) $ "401|403|011|014|015|017|405|501|502|505"            , "I",;
				   Iif( SubStr(CBP->CCUSTO,7,3) $ "402|404|003|004|006|008|012|016|406|410|503|504|506", "E","O" ) )				  

	// Tratamento para o SIPCO	
	_cObs 		:= IIF(cCodSis="02",;
					   "DESPESA COM " + AllTrim(CBP->PROCESSO) + " REF. AO PERIODO " + DTOC(STOD(CBP->DATAP)) +; 
					   " ("+ STRZERO(VAL(CBP->OBS),7) + " VEICULOS)",CBP->OBS)
	
	BEGIN TRANSACTION
    RecLock("SC5",.T.)
		SC5->C5_FILIAL  := CBP->FILIAL
		SC5->C5_NUM		:= cPedido
		SC5->C5_TIPO	:= "N"
		SC5->C5_XTIPONF	:= IIF(cCodSis=="01","NFS",CBP->TIPODOC)
		SC5->C5_CLIENTE	:= SA1->A1_COD
		SC5->C5_LOJACLI	:= SA1->A1_LOJA
		SC5->C5_TIPOCLI	:= SA1->A1_TIPO
		SC5->C5_CONDPAG	:= IIF(Empty(SA1->A1_COND),"004",SA1->A1_COND)
		SC5->C5_CCUSTO	:= IIF(cCodSis=="03",GETMV("MV_XCCS"),CBP->CCUSTO)
		SC5->C5_NATUREZ	:= IIF(cCodSis=="01","603",IIF(cCodSis=="03","606","602"))
		SC5->C5_CTAPSA	:= CBP->CONTAPSA
		SC5->C5_CCUSPSA	:= CBP->CCUSTOPSA
		SC5->C5_OIPSA	:= CBP->OIPSA
		SC5->C5_REFGEFC	:= CBP->PROCESSO
		SC5->C5_TPDESP	:= _cTipoDesp
		SC5->C5_XOBS	:= _cObs
		SC5->C5_EMISSAO	:= DDATABASE
		SC5->C5_ESPECI4 := IIF(cCodSis=="01","SIPCO",IIF(cCodSis=="02","ISYGO","WMS"))
		SC5->C5_GEFEMIS	:= stod(CBP->DATAP)
		SC5->C5_CLIENT	:= SA1->A1_COD
		SC5->C5_LOJAENT := SA1->A1_LOJA
		SC5->C5_MOEDA	:= 1
		SC5->C5_TIPLIB	:= "1"
    MsUnLock()
    
    // Guardo os pedidos gerados para enviar lista por e-mail.
    AADD(_aPedidos, {CBP->FILIAL, cPedido, cCodSis} )
    
	// Itens do Pedido de Venda
	aReg := {}
	aItens:={}
	cQry:="SELECT ITENS.*"
	cQry+="  FROM ITENS_PRESTACAO ITENS"
	cQry+=" WHERE ITENS.FILIAL     = '"+ CBP->FILIAL		+"'"
	cQry+="   AND ITENS.IDSEQ      = '"+ CBP->IDSEQ			+"'"
	cQry+="   AND ITENS.CODSISTEMA = '"+ CBP->CODSISTEMA	+"'"
	cQry+="   AND ITENS.CODCLIENTE = '"+ CBP->CODCLIENTE	+"'"
	TcQuery cQry Alias "TITENS" New
    
	_cTES := IIF(cCodSis="01","502",IIF(cCodSis="03","501","501"))

	While !Eof()
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+AllTrim(TITENS->PRODUTO))
                                                          
		RecLock("SC6",.T.)
			SC6->C6_FILIAL  := CBP->FILIAL
			SC6->C6_NUM		:= cPedido
			SC6->C6_ITEM	:= TITENS->ITEM
			SC6->C6_PRODUTO	:= SB1->B1_COD
			SC6->C6_DESCRI	:= SB1->B1_DESC
			SC6->C6_UM		:= SB1->B1_UM
			SC6->C6_LOCAL	:= SB1->B1_LOCPAD
			SC6->C6_TES		:= _cTES
			SC6->C6_CF		:= POSICIONE("SF4",1,xFilial("SF4")+_cTES,"F4_CF")
			SC6->C6_CODISS	:= SB1->B1_CODISS
			SC6->C6_QTDVEN	:= TITENS->QTD
			SC6->C6_PRCVEN	:= TITENS->VLRUNIT
			SC6->C6_VALOR	:= TITENS->VLRTOTAL
			SC6->C6_CLI		:= SA1->A1_COD
			SC6->C6_LOJA	:= SA1->A1_LOJA
			SC6->C6_TPOP	:= "F"
			SC6->C6_ENTREG  := DDATABASE
			SC6->C6_SUGENTR := DDATABASE
		MsUnLock()
		      
		aItens:={}
		
		// Gravo Log
		cQry:="INSERT INTO LOG_PRESTACAO"
		cQry+="            (ISY_CHAVE,FILIAL,IDSEQ,CODSISTEMA)"
		cQry+="     VALUES ('"+TITENS->ISY_CHAVE+"','"+cFil+"','"+cIdSeq+"','"+cCodSis+"')"
		
		TcSQLExec(cQry)
		TcSQLExec("COMMIT")		
		
		// Atualizo o número do Pedido
		cQry:="UPDATE ITENS_PRESTACAO"
		cQry+="   SET PEDIDO = '"+cPedido+"'"
		cQry+=" WHERE FILIAL     = '"+cFil+"'"
		cQry+="   AND IDSEQ      = '"+cIdSeq+"'"
		cQry+="   AND CODSISTEMA = '"+cCodSis+"'"

		TcSQLExec(cQry)
		TcSQLExec("COMMIT")		
		
/*		
		aAdd(aReg,{"C6_NUM"		,cPedido			,nil})
//		aAdd(aReg,{"C6_ITEM"	,TITENS->ITEM		,nil})
		aAdd(aReg,{"C6_PRODUTO"	,SB1->B1_COD	 	,nil})
//		aAdd(aReg,{"C6_UM"     	,SB1->B1_UM			,nil})
//		aAdd(aReg,{"C6_LOCAL" 	,SB1->B1_LOCPAD		,nil})
		aAdd(aReg,{"C6_TES" 	,"501"		        ,nil})
		aAdd(aReg,{"C6_QTDVEN" 	,TITENS->QTD		,nil})
		aAdd(aReg,{"C6_PRCVEN" 	,TITENS->VLRUNIT	,nil})
//		aAdd(aReg,{"C6_VALOR" 	,TITENS->VLRTOTAL	,nil})
*/
/*
		aadd(aItens,{{"C6_NUM"		,cPedido			,nil},;
					{"C6_FILIAL"	,CBP->FILIAL		,nil},;
					{"C6_ITEM"		,TITENS->ITEM	 	,nil},;
					{"C6_PRODUTO"	,SB1->B1_COD	 	,nil},;
					{"C6_TES" 		,"501"	        	,nil},;
					{"C6_QTDVEN" 	,TITENS->QTD		,nil},;
					{"C6_PRCVEN" 	,TITENS->VLRUNIT	,nil}})
					
*/
//		aAdd(aItens,aReg)
		dbSelectArea("TITENS")
		dbSkip()
	EndDo
	dbSelectArea("TITENS")
	dbCloseArea()

//	Begin Transaction
//		MsExecAuto({|x,y,z| mata410(x,y,z)},aCab,aItens,nOpc)
//	End Transaction
	END TRANSACTION // Fim transação do RecLock()
/*	
	IF lMSErroAuto
		MostraErro()
		RollBackSx8()
	Else
		ConfirmSx8()
*/		
		cQry:="INSERT INTO LOG_PRESTACAO"
		cQry+="            (ISY_CHAVE,FILIAL,IDSEQ,CODSISTEMA)"
		cQry+="     VALUES ('"+cPedido+"','"+cFil+"','"+cIdSeq+"','"+cCodSis+"')"
//		cQry:="UPDATE LOG_PRESTACAO"
//		cQry+="   SET NUMPEDIDO = '"+cPedido+"'"
//		cQry+=" WHERE FILIAL     = '"+cFil+"'"
//		cQry+="   AND IDSEQ      = '"+cIdSeq+"'"
//		cQry+="   AND CODSISTEMA = '"+cCodSis+"'"
		TcSQLExec(cQry)
		TcSQLExec("COMMIT")
//	EndIf
	dbSelectArea("CBP")
	dbSkip()
EndDo

dbSelectArea("CBP")
dbCloseArea()

// Restauro a empresa e filial
cFilAnt   := _cFilOld
_cSisAnt  := ""

SM0->( dbSeek( _cEmpOld + _cFilOld ) )

// Envio e-mail com lista de pedidos gerados
// Ordeno o Array por Filial
_aPedidos := aSort( _aPedidos,,, { | x , y | x[1] < y[1] } )


If Len(_aPedidos) > 0 
	// Envio e-mail com os logs de erro para a Filial
	_cFilAnt := _aPedidos[1,1]
	_cSisAnt := _aPedidos[1,3]
	
	For x:=1 To Len(_aPedidos)
	
		If _cFilAnt == _aPedidos[x,1]
			_cPedidos += _aPedidos[x,2] + cNL
		Else 
			*-----------------------------*
			fEnviaEMail(_cFilAnt,_cPedidos)
			*-----------------------------*		
			_cPedidos := ''
			_cFilAnt  := _aPedidos[x,1]
			_cSisAnt  := _aPedidos[1,3]
			_cPedidos += _aPedidos[x,2] + cNL		
		EndIf
	Next x
	
	// Envio o log da a última filial
	If !Empty(_cPedidos)
		fEnviaEMail(_cFilAnt,_cPedidos, _cSisAnt)
	EndIf
Else
	If lAutoRot
		ConOut("Não há interface pendente para gerar pedidos.")
	EndIf	
EndIf		

Return


*----------------------------------------------------*
Static Function fEnviaEmail(_cFilial,_cPeds, _cSisAnt)
*----------------------------------------------------*

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

// cEmail := GETMV('"'+('MV_ISYGO'+_cFilial)+'"')  // "jose.guimaraes@gefco.com.br" 
If 	_cSisAnt == "01" // ISYGO
	If _cFilial = '02'
		cEmail := GETMV("MV_ISYGO02")
	ElseIf _cFilial = '07'
		cEmail := GETMV("MV_ISYGO07")
	ElseIf _cFilial = '08'
		cEmail := GETMV("MV_ISYGO08")
	ElseIf _cFilial = '11' .OR. _cFilial = '21'
		cEmail := GETMV("MV_ISYGO11")
	EndIf
ElseIf _cSisAnt == "02" // SIPCO
	cEmail := POSICIONE("SX6",1,_cFilial + "MV_XSIPCO","X6_CONTEUD")
ElseIf _cSisAnt == "03" // WMS
	cEmail := POSICIONE("SX6",1,_cFilial + "MV_XMAILWM","X6_CONTEUD")
EndIf
	
If Empty(cEmail)
	cEmail := "jose.guimaraes@gefco.com.br"
	cBody  := _cFilial + " - Sem parametrização de e-mails no configurador para os usuários que irão receber a errada do Isygo."
EndIf

cEmailOri := GetMV("MV_RELFROM") // "interfaces-fat@gefco.com.br" 
cAccount  := GetMV("MV_RELACNT")
cPass     := GetMV("MV_RELPSW")

cTo       := AllTrim(cEmail)

cSubject  := "ISYGO/SIPCO/WMS - Pedidos Gerados no Microsiga Protheus" 

_cMsg     += "Segue Lista de pedidos gerados no sistema Protheus através da interface ISYGO/SIPCO/WMS! - Filial = "    + _cFilial + Chr(13) + Chr(10)
_cMsg     += "===================================================================================================" + Chr(13) + Chr(10)

cBody     := _cMsg + _cPeds

cErrorMsg := ""


//EnvEmail(cDe,cPara,cCc,cAssunto,cMsg,cAnexo)
U_EnvEmail(cEmailOri,cTo,,cSubject,cBody)

/*
connect smtp server cMailServer account cAccount password cPass RESULT _lOk

If _lOk
	send mail from cEmailOri to cTo subject cSubject body cBody // attachment &(_cArquivos)
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR _cError
   	CONOUT("Erro no envio do E-Mail - " + _cError)
EndIf

//GET MAIL ERROR cErrorMsg  

DISCONNECT SMTP SERVER  

WFSENDMAIL({cEmpAnt,cFilAnt})
*/

Return

*---------------------------------*
Static Function IncProvCom()
*---------------------------------*
Local aVetor   := {}
Local cRecSE2
Local _aArea   := GetArea()

DbSelectArea("SE2")

Private lMsErroAuto := .F.
Private cLinha      := ""

aVetor := { {"E1_FILIAL"  ,xFilial("SE2")           ,Nil},;
       {"E2_PREFIXO" ,"ND "                    		,Nil},;
       {"E2_NUM"     ,SE2->E2_XNUMND           		,Nil},;
       {"E2_TIPO"    ,"NF "                    		,Nil},;
       {"E2_NATUREZ" ,cNatTit                  		,Nil},;
       {"E2_FORNECE" ,SE2->E2_XCLIND           		,Nil},;
       {"E2_LOJA"    ,SE2->E2_XLOJAND          		,Nil},;
       {"E2_EMISSAO" ,dDataBase                		,Nil},;
       {"E2_VENCTO"  ,dDataBase + 30           		,Nil},;
       {"E2_VENCREA" ,dDataBase + 30           		,Nil},;
       {"E2_MOEDA"   ,1                        		,Nil},;
       {"E2_VALOR"   ,(SE2->E2_XVLRND*1.0038)  		,Nil},; //vALOR + cpmf
       {"E2_VLCRUZ"  ,(SE2->E2_XVLRND*1.0038)  		,Nil},; //vALOR + cpmf
       {"E2_LA"      ,"S"                      		,Nil},;       //Já entra contabilizado
       {"E2_CCONT"   ,SE2->E2_CCONT            		,Nil}}
       
	   MSExecAuto({|x,y| Fina050(x,y)},aVetor,3) //3-Inclusao  /5-Exclusao
	   
	   aVetor    := {}
	   
If lMsErroAuto
	If lAutoRot
		ConOut("Erro ao Incluir o Titulo a pagar do ISYGO.")
		ConOut(cLinha)
	Else
		Alert("Erro ao Incluir o Titulo a pagar do ISYGO.")
	    MostraErro()
	EndIf
	DbSelectArea("SE2")
Endif
RestArea(_aArea)
Return
