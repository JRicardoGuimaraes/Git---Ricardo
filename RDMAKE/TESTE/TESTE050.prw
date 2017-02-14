USER FUNCTION FINA040()

//If nVez = 1
	ALERT("TESTE - ACESSO TELA CTA.RECEBER.")
//	nVez = 2
//EndIf	

RETURN .F.


User Function TESTE050()
Local aVetor := {}

lMsErroAuto := .F.

dbSelectArea("SA1")

U_PedVend()

return

/*
dbSelectArea("SE2") //; dbGoTop()

aVetor :={	    {"E2_FILIAL"	,xFilial("SE2"),Nil},;
				{"E2_PREFIXO"	,'TST'     ,Nil},;
				{"E2_NUM"		,'244582'  ,Nil},;
				{"E2_PARCELA"	,' '       ,Nil},;
				{"E2_TIPO"		,'PR '     ,Nil},;
				{"E2_NATUREZ"	,'500'     ,Nil},;
				{"E2_FORNECE"	,'000295'  ,Nil},;
				{"E2_LOJA"		,'01'      ,Nil},;
				{"E2_LA"		,''        ,Nil},;
				{"E2_GEFCOCT"   ,'S'       ,Nil},;
				{"E2_EMISSAO"	,dDataBase ,NIL},;
				{"E2_VENCTO"	,dDataBase ,NIL},;
				{"E2_VENCREA"	,dDataBase ,NIL},;
				{"E2_HIST"      ,"COMPRA DE FRETE",NIL},;
				{"E2_CCONT"     ,"1010040012",NIL},;
				{"E2_VALOR"		,623        ,Nil} }

// 				{"E2_ORIGEM"    ,"FINA040" ,NIL},;
MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetor,,3) //Inclusao

If lMsErroAuto
	Alert("Erro")
	MostraErro()
Else
	Alert("Ok")
Endif

/*
aVetor :={	{"E2_PREFIXO"	,'PRV',Nil},;
				{"E2_NUM"		,'999999',Nil},;
				{"E2_PARCELA"	,'',Nil},;
				{"E2_TIPO"		,'PR ',Nil},;
				{"E2_NATUREZ"	,'711101',Nil},;
				{"E2_VENCTO"	,dDataBase,NIL},;
				{"E2_VENCREA"	,dDataBase+5,NIL},;
				{"E2_VALOR"		,2200,Nil}}

MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetor,,4) //Alteracao
*/

/*
aVetor :={	{"E2_PREFIXO"	,'999',Nil},;
				{"E2_NUM"		,'999999',Nil},;
				{"E2_PARCELA"	,'1',Nil},;
				{"E2_TIPO"		,'NDF',Nil},;
				{"E2_NATUREZ"	,'001',Nil}}


MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetor,,5) //Exclusao
*/


// PEDIDO

ChkFile("SC5")
ChkFile("SC6")
dbSelectArea("SC5") ; dbGoTop()

	cPedido:=GetSXENum("SC5")
	ConfirmSx8()	
	
	aCab := {}
	aCab := {	 {"C5_FILIAL"	,"11"		,nil},;	
				 {"C5_NUM"		,cPedido	,nil},;				 
				 {"C5_TIPO"		,"N"		,nil},;				 
				 {"C5_CLIENTE"	,"029323"	,nil},;
				 {"C5_LOJAENT"	,"00"		,nil},;				 
				 {"C5_LOJACLI"	,"00"		,nil},;
				 {"C5_TIPOCLI"	,"F"		,nil},;
				 {"C5_CONDPAG"	,"004"		,nil},;
				 {"C5_CCUSTO" 	,"3220124016",nil},;
				 {"C5_TIPLIB"   ,"1"        ,Nil},; // Tipo de Liberacao
				 {"C5_MOEDA"    ,1          ,Nil},; // Moeda
				 {"C5_NATUREZ" 	,"602"		,nil},;
				 {"C5_CTAPSA"	,""			,nil},;
				 {"C5_CCUSPSA"	,""			,nil},;
				 {"C5_OIPSA"	,""			,nil},;
				 {"C5_TPDESP"	,"O"		,nil},;
				 {"C5_XOBS"		,"TESTE"	,nil},;
				 {"C5_EMISSAO"	,DDATABASE	,nil},;
				 {"C5_ESPECI4"	,"ISYGO"	,nil},;
				 {"C5_GEFEMIS"	,DDATABASE  ,nil},;
				 {"C5_CLIENT"	,"029323"	,nil} }
                          
	// Itens do Pedido de Venda
	aReg := {}
	aItens:={}  
/*
				{"C6_FILIAL"	,"11"	,nil},;
				{"C6_PRODUTO"	,"06637",nil},;
				{"C6_TES" 		,"501"	,nil},;
				{"C6_QTDVEN" 	,1		,nil},;
				{"C6_PRCVEN" 	,1		,nil} }
*/		      
	aItens:={}
	aItens:= {  {"C6_NUM"		,cPedido,nil},;
				{"C6_ITEM"   ,"01"              ,Nil},; // Numero do Item no Pedido
				{"C6_PRODUTO","06637" 			,Nil},; // Codigo do Produto
				{"C6_QTDVEN" ,1                 ,Nil},; // Quantidade Vendida
				{"C6_PRUNIT"  ,0                ,Nil},; // PRECO DE LISTA
				{"C6_PRCVEN" ,100               ,Nil},; // Preco Unitario Liquido
				{"C6_VALOR"  ,100               ,Nil},; // Valor Total do Item
				{"C6_ENTREG" ,dDataBase         ,Nil},; // Data da Entrega
				{"C6_UM"     ,"UN"              ,Nil},; // Unidade de Medida Primar.
				{"C6_TES"    ,"501"             ,Nil},; // Tipo de Entrada/Saida do Item
				{"C6_DESCONT",1                 ,Nil},; // Percentual de Desconto
				{"C6_COMIS1" ,0                 ,Nil},; // Comissao Vendedor
				{"C6_LOCAL"  ,"1"               ,Nil},; // Almoxarifado				
				{"C6_CLI"    ,"029323"          ,Nil},; // Cliente
				{"C6_LOJA"   ,"00"              ,Nil},; // Loja do Cliente
				{"C6_QTDEMP" ,1                 ,Nil},; // Quantidade Empenhada
				{"C6_QTDLIB" ,1                 ,Nil}}  // Quantidade Liberada				
					

//				{"C6_ITEM"		,"001"	,nil},;

//		aAdd(aItens,aReg)

	Begin Transaction
		MsExecAuto({|x,y,z| mata410(x,y,z)},aCab,{aItens},3)
	End Transaction

alert(cPedido)
	
	IF lMSErroAuto
		MostraErro()
	Else
		Alert("Ok")	
	EndIf

Return

User Function PedVend()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMATA410  ºAutor  ³    Suporte Rdmake  º Data ³  04/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exemplo Utilizacao rotina automatica- Pedido de Venda      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Devem ser passados no array(s) todos os campos obrigatorios

Local aCabPV := {}
Local aItemPV:= {}
Local aItem  := {}
Local nopc:=3  //3- inclusao  5- exclusao

cNumPed:=GetSXENum("SC5")
ConfirmSx8()	

//Cabecalho

// {"C5_TABELA" ,""          ,Nil},; // Codigo da Tabela de Preco

// {"C5_LOJAENT","00"        ,Nil},; // Loja para entrada

dbSelectArea("SA1") ; dbSetOrder(1)
If !dbSeek(xFilial("SA1")+"00022700")
	Alert("Cliente inexistente.")
EndIf

AADD( aCabPV, {"C5_FILIAL",xFilial("SC5"),Nil}) // Codigo do cliente
AADD( aCabPV, {"C5_NUM"    ,cNumPed     ,Nil}) // Numero do pedido
AADD( aCabPV, {"C5_TIPO"   ,"N"         ,Nil}) // Tipo de pedido
AADD( aCabPV, {"C5_CLIENTE",SA1->A1_COD ,Nil}) // Codigo do cliente
AADD( aCabPV, {"C5_LOJACLI",SA1->A1_LOJA,Nil}) // Loja do cliente
AADD( aCabPV, {"C5_TIPOCLI","F"         ,Nil}) // Tipo de Cliente
AADD( aCabPV, {"C5_CLIENT" ,"000227"    ,Nil}) // Codigo do cliente
AADD( aCabPV, {"C5_LOJAENT","00"        ,Nil}) // Loja do cliente
AADD( aCabPV, {"C5_EMISSAO",dDatabase   ,Nil}) // Data de emissao11
AADD( aCabPV, {"C5_TPDESP","0"          ,Nil}) // Tipo de despesa
AADD( aCabPV, {"C5_CCUSTO","1010020011" ,Nil}) // Tipo de pedido
AADD( aCabPV, {"C5_NATUREZ","600"       ,Nil}) // Tipo de pedido
AADD( aCabPV, {"C5_CONDPAG","004"       ,Nil}) // Codigo da condicao de pagamanto*
//AADD( aCabPV, {"C5_DESC1"  ,0           ,Nil}) // Percentual de Desconto
//AADD( aCabPV, {"C5_INCISS" ,"N"         ,Nil}) // ISS Incluso
AADD( aCabPV, {"C5_TIPLIB" ,"1"         ,Nil}) // Tipo de Liberacao
AADD( aCabPV, {"C5_MOEDA"  ,1           ,Nil}) // Moeda
AADD( aCabPV, {"C5_LIBEROK","S"         ,Nil}) // Liberacao Total

//Items
AADD(aItem, {"C6_FILIAL" ,xFilial("SC6")    ,Nil}) // Numero do Pedido
//AADD(aItem, {"C6_ITEM"   ,"001"              ,Nil}) // Numero do Item no Pedido
AADD(aItem, {"C6_NUM"    ,cNumped           ,Nil}) // Numero do Pedido
AADD(aItem, {"C6_PRODUTO","06637" 			,Nil}) // Codigo do Produto
AADD(aItem, {"C6_QTDVEN" ,1                 ,Nil}) // Quantidade Vendida
//AADD(aItem, {"C6_PRUNIT"  ,0                ,Nil}) // PRECO DE LISTA 1
AADD(aItem, {"C6_PRCVEN" ,100               ,Nil}) // Preco Unitario Liquido
//AADD(aItem, {"C6_VALOR"  ,100               ,Nil}) // Valor Total do Item
//AADD(aItem, {"C6_UM"     ,"UN"              ,Nil}) // Unidade de Medida Primar.
//AADD(aItem, {"C6_TES"    ,"501"             ,Nil}) // Tipo de Entrada/Saida do Item
//AADD(aItem, {"C6_LOCAL"  ,"01"              ,Nil}) // Almoxarifado
//AADD(aItem, {"C6_ENTREG" ,dDataBase         ,Nil}) // Data da Entrega
//AADD(aItem, {"C6_DESCONT",1                 ,Nil}) // Percentual de Desconto
//AADD(aItem, {"C6_COMIS1" ,0                 ,Nil}) // Comissao Vendedor
//AADD(aItem, {"C6_CLI"    ,"000227"          ,Nil}) // Cliente
//AADD(aItem, {"C6_LOJA"   ,"00"              ,Nil}) // Loja do Cliente
//AADD(aItem, {"C6_QTDEMP" ,1                 ,Nil}) // Quantidade Empenhada
//AADD(aItem, {"C6_QTDLIB" ,1                 ,Nil})  // Quantidade Liberada

//Mata410(aCabPv,{aItemPV},3)

aAdd(aItemPV, aClone( aItem ) )

MSExecAuto({|x,y,z|Mata410(x,y,z)},AClone(aCabPv),AClone(aItemPV),nOpc)   //Se houver mais de um item, passar no aItemPv entre virgulas; ex: {aItemPV,aItemPV1...}

If lMsErroAuto
	MostraErro()
	DisarmTransaction()
	break
else
	alert("ok")	
EndIf
Return

/*
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSelectArea("SC6")
	dbSetOrder(1)
	//Cabecalho
	aCabPV :={  {"C5_FILIAL" , xFilial("SC5")           					,Nil},; // Numero do pedido
	{"C5_NUM"    , cNumero           							,Nil},; // Numero do pedido
	{"C5_CLIENTE", cCliente  										,Nil},; // Codigo do cliente
	{"C5_LOJACLI", cLoja												,Nil},; // Loja do cliente
	{"C5_TIPO"   , "N"           									,Nil},; // Tipo do Pedido
	{"C5_EMISSAO", dData   									      ,Nil},; // Data de emissao
	{"C5_CONDPAG", cCondPagto       								,Nil},; // Codigo da condicao de pagamanto*
	{"C5_TIPOCLI", "R"           									,Nil},; // Tipo do Cliente
	{"C5_DESC1"  , 0           									,Nil},; // Percentual de Desconto
	{"C5_INCISS" , "N"         									,Nil},; // ISS Incluso
	{"C5_TIPLIB" , "1"         									,Nil},; // Tipo de Liberacao
	{"C5_MOEDA"  , 1           									,Nil},; // Moeda
	{"C5_LIBEROK", "S"         									,Nil}} // Liberacao Total
	
	//Items
	aItemPV:={  {"C6_NUM"    , cNumero           			,Nil},; // Numero do Pedido
	{"C6_ITEM"   , "01"              							,Nil},; // Numero do Item no Pedido
	{"C6_PRODUTO", AllTrim(cProduto)          				,Nil},; // Codigo do Produto
	{"C6_QTDVEN" , 1                 							,Nil},; // Quantidade Vendida
	{"C6_PRUNIT" , nValorFin   				         		,Nil},; // PRECO DE LISTA
	{"C6_PRCVEN" , nValorFin              						,Nil},; // Preco Unitario Liquido
	{"C6_VALOR"  , 1 * nValorFin        						,Nil},; // Valor Total do Item
	{"C6_ENTREG" , dData             							,Nil},; // Data da Entrega
	{"C6_UM"     , "UN"              							,Nil},; // Unidade de Medida Primar.
	{"C6_TES"    , cTES             							   ,Nil},; // Tipo de Entrada/Saida do Item
	{"C6_LOCAL"  , "01"              							,Nil},; // Almoxarifado
	{"C6_DESCONT", 0                 							,Nil},; // Percentual de Desconto
	{"C6_COMIS1" , 0                 							,Nil},; // Comissao Vendedor
	{"C6_CLI"    , cCliente  										,Nil},; // Cliente
	{"C6_LOJA"   , cLoja                                  ,Nil},; // Loja do Cliente
	{"C6_QTDLIB" , 0                 							,Nil}}  // Quantidade Liberada
	
	MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,{aItemPV},nOpc)   //Se houver mais de um item, passar no aItemPv entre virgulas; ex: {aItemPV,aItemPV1...}
