#include "rwmake.ch"

User Function fPedido()


PRIVATE lMSErroAuto := .f.

dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SB1")
dbSetOrder(1)
/*
cQry:="SELECT CBP.*,CBP.OBS "
cQry+="  FROM CABEC_PRESTACAO CBP, LOG_PRESTACAO LGP"
cQry+=" WHERE LGP.NUMPEDIDO = ''"
cQry+="   AND CBP.FILIAL = LGP.FILIAL"
cQry+="   AND CBP.IDSEQ = LGP.IDSEQ"
cQry+="   AND CBP.CODSISTEMA = LGP.CODSISTEMA"
*/
/*
cQry:="SELECT CBP.*,CBP.OBS"
cQry+="  FROM CABEC_PRESTACAO CBP"
cQry+=" WHERE NOT EXISTS(SELECT * FROM LOG_PRESTACAO LGP"
cQry+="                   WHERE CBP.FILIAL = LGP.FILIAL"
// cQry+="                     AND CBP.IDSEQ = LGP.IDSEQ"
cQry+="                     AND CBP.IDSEQ = LGP.IDSEQ"
cQry+="                     AND CBP.CODSISTEMA = LGP.CODSISTEMA)"
*/
cQry:="SELECT CBP.*,CBP.OBS"
cQry+="  FROM CABEC_PRESTACAO CBP, ITENS_PRESTACAO ITP"
cQry+=" WHERE NOT EXISTS(SELECT * FROM LOG_PRESTACAO LGP"
cQry+="                   WHERE CBP.FILIAL = LGP.FILIAL"
// cQry+="                     AND CBP.IDSEQ = LGP.IDSEQ"
cQry+="                     AND CBP.IDSEQ = LGP.IDSEQ"
cQry+="                     AND CBP.CODSISTEMA = LGP.CODSISTEMA)"
cQry+="   AND CBP.FILIAL = ITP.FILIAL "
cQry+="   AND CBP.IDSEQ  = ITP.IDSEQ  "

TcQuery cQry Alias "CBP" New
dbSelectArea("CBP")

While !Eof()


	aCab := {}
	cPedido:=GetSXENum("SC5")
	ConfirmSx8()	
	
	aAdd(aCab,{"C5_FILIAL"  ,cPedido			,nil}) // Nro.do Pedido
	aAdd(aCab,{"C5_NUM"		,cPedido			,nil}) // Nro.do Pedido
	aAdd(aCab,{"C5_TIPO"	,"N"				,nil}) //Tipo de Pedido - "N"-Normal
	aAdd(aCab,{"C5_CLIENTE"	,SA1->A1_COD		,nil})
	aAdd(aCab,{"C5_LOJAENT"	,SA1->A1_LOJA		,nil})
	aAdd(aCab,{"C5_LOJACLI"	,SA1->A1_LOJA		,nil})
	aAdd(aCab,{"C5_TIPOCLI"	,SA1->A1_TIPO		,nil})
	aAdd(aCab,{"C5_CONDPAG"	,"004"				,nil})
	aAdd(aCab,{"C5_CCUSTO" 	,CBP->CCUSTO		,nil})
	aAdd(aCab,{"C5_CTAPSA"	,CBP->CONTAPSA		,nil})  
	aAdd(aCab,{"C5_CCUSPSA"	,CBP->CCUSTOPSA		,nil})
	aAdd(aCab,{"C5_OIPSA"	,CBP->OIPSA			,nil})
	aAdd(aCab,{"C5_TPDESP"	,"O"				,nil})	
	aAdd(aCab,{"C5_XOBS"	,CBP->OBS			,nil})
	aAdd(aCab,{"C5_EMISSAO"	,stod(CBP->DATAP)	,nil})
	aAdd(aCab,{"C5_ESPECI4"	,"ISYGO"	        ,nil})	
	aAdd(aCab,{"C5_GEFEMIS"	,DDATABASE          ,nil})	
	aAdd(aCab,{"C5_CLIENT"	,SA1->A1_COD		,nil})                    
    
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

	While !Eof()
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+AllTrim(TITENS->PRODUTO))
                                                          
		aAdd(aReg,{"C6_NUM"		,cPedido			,nil})
		aAdd(aReg,{"C6_ITEM"	,TITENS->ITEM		,nil})
		aAdd(aReg,{"C6_PRODUTO"	,SB1->B1_COD	 	,nil})
		aAdd(aReg,{"C6_UM"     	,SB1->B1_UM			,nil})
		aAdd(aReg,{"C6_LOCAL" 	,SB1->B1_LOCPAD		,nil})
		aAdd(aReg,{"C6_TES" 	,"501"		        ,nil})
		aAdd(aReg,{"C6_QTDVEN" 	,TITENS->QTD		,nil})
		aAdd(aReg,{"C6_PRCVEN" 	,TITENS->VLRUNIT	,nil})
		aAdd(aReg,{"C6_VALOR" 	,TITENS->VLRTOTAL	,nil})
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
		aAdd(aItens,aReg)
		dbSelectArea("TITENS")
		dbSkip()
	EndDo
	dbSelectArea("TITENS")
	dbCloseArea()

	IF lMSErroAuto
		MostraErro()
		RollBackSx8()
	Else
		Alert("Pedido gravado.")		
	EndIf	
End