#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "msmgadd.CH"
#Command @ <nRow>, <nCol> BMPBUTTON TYPE <nType> ACTION <cAction> [OBJECT <oBmt>] [<lEnable:ENABLE>] ;
=> [ <oBmt> := ] SButton():New(<nRow>, <nCol>, <nType>, [{|| <cAction>}],,<lEnable>)

/*/                                                                                           
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณRdmake    		    |Autor  ณCarlos Cleuber         ณData  ณ16/04/2008ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao |Tela Gerenciamento Manuten็ใo de C.T.R.C. - OPERACIONAL     ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ                                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ           Atualizaoes sofridas desde a construao inicial            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณData      ณMotivo da Alteraao                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ			   ณ          ณ 											  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function LOCT004  //Manuten็ใo de Viagens


Local aRotCTRC := { { "Manutencao"			, "eval(bManutRC)"	, 0 , 4},;
					{ "Gera CT-e"			, "eval(bGeraC)"	, 0 , 4},;
					{ "Gera Ped.Serv."		, "eval(bGeraPS)"	, 0 , 4},;	// { "Ger. XML Clientes"	, "u_XMLENT()"		, 0 , 4},;
					{ "Imprime"				, "eval(bImprimeC)"	, 0 , 4},;
					{ "Estorno CT-e"		, "eval(bestornoC)"	, 0 , 4},;
					{ "Estorno Ped.Serv."	, "eval(bestornoPS)", 0 , 4},;
					{ "Transmissใo CT-e"	, "eval(bSPEDNFE)", 0 , 4},;
					{ "CT-e Complementar"	, "eval(bComplemC)"	, 0 , 4}}

Local aLegenda  := { { "Legenda"     , "eval(bLegenda)"  , 0 , 6}}

Local aCores    :=  {}
Local bIniBlock := {|| }
Local aCpos     := {}

Aadd(aCores,{ "!Empty(DTQ_NUMCTR) .AND. DTQ_NUMCTR <> '-'" , 'BR_VERMELHO'		  }) // CTRC GERADO
Aadd(aCores,{ "(Empty(DTQ_NUMCTR).OR.DTQ_NUMCTR = '-') .and. !Empty(Posicione('DTC',11,DTQ->(DTQ_FILIAL+DTQ_VIAGEM),'DTC_FILORI'))" , 'BR_AMARELO' 	      }) // Viagem com NF-e vinculada
Aadd(aCores,{ " Empty(DTQ_NUMCTR) .OR.  DTQ_NUMCTR = '-' " , 'BR_VERDE'	 	      }) // NADA GERADO

private lCTRCTela:=.t.
Private cCadastro := "Selecione a Viagem..."
Private cPrjObra  :=""
Private bManutRC  :={|| lCTRCTela:=.t. , Locf004a("A") 	} //Manutencao CTRC e CTRB
Private bGeraC    := {||U_Locf008(1)}   //Gerar CTRC
Private bGeraPS   := {||U_Locf008(2)}   //Gerar Pedido servi็o
Private bImprimeC := {||U_Loci012()}   //Imprimir CTRC
Private bestornoC := {||U_Locf015()}   //Estornar CTRC
Private bestornoPS:= {||EstornaPS()}   //Estornar Pedido servi็o 
Private bSPEDNFE  := {||SPEDNFE()()} 
Private bComplemC := {||DTQComp()}		//Complemento CTRC
Private bLegenda  := {||LocfLeg()}
Private bFiltraBrw := {|| Nil}
Private aIndice    := {}
Private cCondFil   := ""

Private cCadastro := "Viagens"
Private aRotina := {{"Pesquisar" ,"AxPesqui"    ,0,1} ,;
					{"Visualizar","AxVisual"    ,0,2} ,;
					{"CT-e"     ,aRotCTRC    ,0,4},;
					{"Legenda(F5)" ,aLegenda    ,0,6}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "DTQ"

Private cCadastro := "Manuten็ใo CT-e"
Public lCopia 	  := .F.

cCondFil := "DTQ_FILIAL == '"+xFilial("DTQ")+"' .And. "
cCondFil += "(DTQ_TPAS == 'T' .OR. DTQ_TPAS == 'M') "
cCondFil += ".And. DTQ_STATUS <> '9' "	// Nใo exibir AS canceladas
cCondFil += ".And. !(Empty(DTQ->DTQ_DATFEC) .and.  Empty(DTQ->DTQ_DATENC) .and. DTQ->DTQ_STATUS == '1') "
//cCondFil += ".And. Empty(DTQ->DTQ_JUNTO)  "

//------------------------------ posiciona no DTQ oriundo da tela de Gerenciamento de XML de Entrada
if Type("nRecDTQ") == "N"
	cCondFil += ".And. RECNO() == "+Alltrim(Str(nRecDTQ))
endif
//------------------------------ Cristiam Rossi em 27/07/2015


bFiltraBrw := {|| FilBrowse("DTQ",@aIndice,@cCondFil) }
LjMsgRun("Por Favor Aguarde, filtrando informa็๕es...",, {|| Eval(bFiltraBrw) }) 


aadd(aCpos, {"Filial Ori.","DTQ_FILORI"} )
aadd(aCpos, {"Viagem"     ,"DTQ_VIAGEM"} )
aadd(aCpos, {"Num. AS"    ,"DTQ_AS"    } )	// Campos a serem exibidos no mBrowse
aadd(aCpos, {"Projeto"    ,"DTQ_SOT"   } )
aadd(aCpos, {"Dt. Coleta","DTQ_DATGER"} )
aadd(aCpos, {"Tp. Veiculo","DTQ_EQUIP" } )
aadd(aCpos, {"Descr. Veic","DTQ_EQUIPD"} )	//	DUT
aadd(aCpos, {"Pag. Frete" ,"DTQ_NOMCLI"} )
aadd(aCpos, {"Cli. Coleta","DTQ_CLICOL"} )	//	pela Viagem		// ZA7
aadd(aCpos, {"Descr. Rota","DTQ_ROTAD" } )	//  pela AS na ZA6 


dbSelectArea(cString)
dbSetOrder(1)

Set Key VK_F5 to LocfLeg()

mBrowse(6, 1, 22, 75,cString, aCpos ,,,,,aCores)

Set Key VK_F5  to

DbSelectArea("DTQ")
dbClearFilter()

Return .T.


//----------------------------------------------------------
Static Function xVincula( oDlg, oFolder )
Local nFolderAtu := oFolder:nOption

	u_VincXML() // "Vincula Chaves DANFE", "Vinc.ChvNFe"

	oFolder:SetOption( nFolderAtu )

	fCalcTotal(nvlinf,1)

Return nil


//+----------------------------------------------------------------------------------
Static Function LOCF004a(pOpc)
Local aArea:=GetArea()
Local cTitJan:="Manutencao CT-e"
Local nStyle:=GD_INSERT + GD_UPDATE + GD_DELETE
Local nPos,lRet:=.f.
Local aButtons
Local cStatsProg	:= "4"         
Local aOpcCmb		:= MontaCombo('DTQ_TPCTRC'  )

Private lGerado:= .t.
Private lInclui :=if(pOpc == "I" ,.T.,.F.)
Private lAltera :=if(pOpc == "A" ,.T.,.F.)
Private lIncCTRB:=if(pOpc == "B" ,.T.,.F.)


Private nOpc := pOpc
Private aHeader:={}
Private aCols:={}
Private aTitles:={}
Private aPages:={}

Private aCalc	  := {}
Private aObjects  := {}
Private aInfo     := {}
Private aPosGet   := {}
Private aPosObj   := {}
Private cOrigem := Space(40)
Private cDestino:= ""
Private oDlg
Private oArial12N1:=TFont():New("Arial",12,16,,.T.,,,,.T.,.F.)
Private oArial12N2:=TFont():New("Arial",12,16,,.T.,,,,.T.,.F.)

Private nFolderVei:=0,nFolderMot:=0,nFolderNot:=0,nFolderFre:=0
Private nFolderPer:=0,nFolderEqu:=0,nFolderCar:=0
Private oDlg,oDlgVei,oDlgMot,oDlgNot,oDlgFre,oDlgPer,oDlgEqu,oDlgCar
Private oFreteP,oFreteV ,oBaseICM ,oAliqICM , oValICM  ,oBaseADV ,oAliqADV , oValADV  , oFreteT                                                     
Private oCli,oLoj,oNom,oOri,oOriUf,oDes,oDesUf,oVlrInf,oCondPag,oDCon,oContra,oTContra,oStatus,oTes,oTes2,oPlacCav,oPlacCar,oNomMot,oCFOP,oCFOP2,oDevFre,oCCusto,oUFCole,oUFEntr,oCarreg,oDescar,oObsContr,oObsSeg,oPago,oDescPag
Private cCli,cLoj,cNom,cOri,cOriUf,cDes,cDesUf,nVlrInf,cCondPag,cDCon,cContra,cTContra,cStatus,cTes,cTes2,cPlacCav,cPlacCar,cNomMot,cCFOP,cCFOP2,cDevFre,cCCusto,cUFCole,cUFEntr,cCarreg,cDescar,cObsContr,cObsSeg,cPago,cDescPag
Private cDescPag,oCodOri,oCodFim,cCodOri,cCodFim,oCodDes,cCodDes,oTpTra,oCodIri,cCodIri,oAFRMM,NAFRMM,aNaveg,cNaveg,oNaveg,aDirNav,cDirNav,oDirNav
Private nFreteP:=nFreteV:=nBaseICM:=nAliqICM:=nValICM:=nBaseADV:=nAliqADV:=nValADV:=nFreteT:=nVlrInf:=nAliqADV:=nBaseADV:=nValADV:=nFreteP:=nAliqICM:= 0
Private nBLin1:= nBCol1:= nBLin2:= nBCol2:= 0

Private cProjeto := cObra := cViagem := ""
Private oFilOri,cFilOri:="01"

Private oProjeto,cProjeto:=DTQ->DTQ_SOT
Private oObra,cObra:=DTQ->DTQ_OBRA         
Private oCtrc,cCtrc:=DTQ->DTQ_NUMCTR         
Private oTpCtrc,cTpCtrc:=Iif(Empty(DTQ->DTQ_TPCTRC),"Normal","Compl."+aOpcCmb[aScan(aOpcCmb, {|x| x[3]==DTQ->DTQ_TPCTRC}), 4])

Private oTipo,oChk
Private cCodCli	:= CriaVar("ZA0_CLI")
Private cLoja	:= CriaVar("ZA0_LOJA")
Private cNoAs   := CriaVar("DTQ_AS")
Private cCodRem := CriaVar("DTC_CLIREM")
Private cCodDes := CriaVar("DTC_CLIDES")
Private cCodCon := CriaVar("DTC_CLICON")
Private cCodRec := CriaVar("DTC_CLIREC")
Private cCodExp := CriaVar("DTC_CLIEXP")
Private cLojRem := CriaVar("DTC_LOJREM")
Private cLojDes := CriaVar("DTC_LOJDES")
Private cLojCon := CriaVar("DTC_LOJCON")
Private cLojRec := CriaVar("DTC_LOJREC")
Private cLojExp := CriaVar("DTC_LOJEXP")
Private cTipNfc := CriaVar("DTC_TIPNFC")

Private cTipo   	:= Space(1)
Private cTipTra   	:= Space(1)
Private aTipo   	:= {'1=CIF','2=FOB'}
Private aTpTra   	:= {'1=Rodoviario','3=Aquaviario'}
Private aNaveg      := {'0=Interior','1=Cabotagem'}
Private aDirNav		:= {'N=Norte','L=Leste','S=Sul','O=Oeste'}
Private cDesRem 	:= CriaVar("A1_NOME")
Private cDesDes 	:= CriaVar("A1_NOME")
Private cDesCon 	:= CriaVar("A1_NOME")
Private cDesRec 	:= CriaVar("A1_NOME")
Private cDesExp 	:= CriaVar("A1_NOME")
Private oDesCon,oDesDes,oDesRem,oDesExp,oDesRec
Private cCondPg 	:=space(03)
Private cCifFob
Private lVer 		:= .T.    
Private lDestICM	:= .T.  
Private cAliasTmp	:=	GetNextAlias() // Incluido Conforme Item do Projeto AVATAR (TRANSP04)

Private nValEstad:=nCarDes:=nValEscol:=nValPedag:=nValAjud:=nValDesl:=nAcumul:=nFretePAux:=nDescComiss:=nValLice:=nValBalsa:=nValOutr := 0 //nDesComV=Visual
Private oValEstad,oCarDes,oValEscol,oValPedag,oValAjud,oValDesl,oFretePAux,oValLice,oValBalsa,oValOutr
Private nImpFrete, oImpFrete, nImpADV, oImpADV, nImpPeda, oImpPeda, nFreteVal, oFreteVal, nImpOutr, oImpOutr
Private nADVal, oADVal

nImpFrete := nImpADV := nImpPeda := nFreteVal := nImpOutr := nADVal := 0

aButtons:={}
AAdd(aButtons,{"ANALITIC",{||fCargaPro()   },OemToAnsi("Carrega Prog Diแria da AS"),OemToAnsi("Carga")})

//----------- Integracao com XMLENT.PRW - Cristiam Rossi em 20/07/2015
AAdd(aButtons,{"ANALITIC",{|| xVincula( @oDlg, @oFolder )   }, "Vincula Chaves DANFE", "Vinc.ChvNFe"})
u_TratXML("RESET")	// Limpa controle de Recnos da ZUC (chaves XML)
//-----------

DbSelectArea("ZA0")
DbSetOrder(1)
MsSeek(xFilial("ZA0") + cProjeto )
                                  
//DESABILITAR AAM                                   
//DbSelectArea("AAM")
//DbSetOrder(1)
//MsSeek(xFilial("AAM") + DTQ->DTQ_CONTRA )

cCodCli	:= ZA0->ZA0_CLI   //AAM->AAM_CODCLI
cLoja	:= +ZA0->ZA0_LOJA //AAM->AAM_LOJA
cNom	:=Posicione("SA1",1,xFilial("SA1")+cCodCli+cLoja ,"A1_NOME")

DbSelectArea("SA1")
DbSetOrder(1)
MsSeek(xFilial("SA1") + ZA0->ZA0_CLI+ZA0->ZA0_LOJA )
cCodCli	:=SA1->A1_COD
cLoja	:=SA1->A1_LOJA
cNom	:=Posicione("SA1",1,xFilial("SA1")+cCodCli+cLoja ,"A1_NOME")


DbSelectArea("ZA6")
DbSetOrder(1)
ZA6->(DbSeek(xFilial("ZA6") + cProjeto +cObra))

oFont1:=oArial12N1  //Say
oFont2:=oArial12N2  //Get

DbSelectArea("DTQ")

If	cFilAnt != DTQ->DTQ_FILORI
	MsgStop("A T E N ว ร O: Para altera ou visualizar o CT-e da Viagem:"+DTQ->DTQ_VIAGEM+" logar na Filial "+DTQ->DTQ_FILORI)
	Return .F.
EndIf

IF !Empty(DTQ->DTQ_NUMCTR) .AND. DTQ->DTQ_NUMCTR <> "-"
	Alert("CT-e  para esta viagem jแ se encontra gerado." + Chr(13) + ;
		  "O mesmo serแ aberto apenas para sua consulta.")
    lGerado:= .t.
Else
    lGerado:= .f.    
EndIf

/*BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด[ฟ
//ณQuery Incluida para Atender a Nesscidade ณ
//ณdo Item TRANSP04 do Projeto Avatar       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด[ู
ENDDOC*/
BeginSql Alias cAliasTmp   
	%NoParser%
	
	SELECT ZLE_FROTA, ZLE_FROTA1 
		FROM %Table:ZLE% ZLE, %Table:DTQ% DTQ, %Table:DA4% DA4
	WHERE 	ZLE_VIAGEM 			=	DTQ.DTQ_VIAGEM
			AND ZLE_AS     		=	DTQ.DTQ_AS
			AND DTQ_OBRA   		=	ZLE.ZLE_OBRA
			AND	DA4.DA4_COD		=	ZLE.ZLE_CODMOT
			AND ZLE_STATUS 		=	%Exp:cStatsProg%
			AND ZLE_FILIAL 		=	%xFilial:ZA0%
			AND ZLE_AS     		=	%Exp:DTQ->DTQ_AS%				
			AND ZLE.%NotDel%
			AND DTQ.%NotDel%
			AND DA4.%NotDel%
	Order By 1,2			

EndSql

cCodOri :=space(06)
cOri    :=space(30)
cOriUf  :=space(02)
cCodFim :=space(06)
cDes	:=space(30)
cDesUf  :=space(02)
cCarreg :=space(30)
cUFCole :=space(02)
cDescar :=space(30)
cUFEntr :=space(02)
cCCusto	:=space(20)
cCondPag:=space(03)
cDCon	:=space(30)
cTes    :=space(03)
cCFOP	:=space(05)
cDevFre :=space(01)
cPago	:=space(01)
cObsSeg	:=space(100)
cTpTra	:=space(01)
cCodIri :=space(10)
cNaveg  :=space(1) 
//cPlacCav:=Iif(nOpc == "A", PesqZLE("CAVALO") ,space(08)) // Alterado Conforme Item do Projeto AVATAR (TRANSP04)
//cPlacCar:=Iif(nOpc == "A", PesqZLE("CARRETA"),space(08)) // Alterado Conforme Item do Projeto AVATAR (TRANSP04)
//cNomMot :=space(30)
cDescPag:=Space(15)
cDescPag
nAliqICM:= 0
cNoAs    :=Space(len(DTQ->DTQ_AS))
RegToMemory("DTC")

if lAltera

	cProjeto  := DTQ->DTQ_SOT
	cObra     := DTQ->DTQ_OBRA
	cViagem   := DTQ->DTQ_VIAGEM
	cFilOri	  := DTQ->DTQ_FILORI
	cNoAs     := DTQ->DTQ_AS
	lDestICM  := DTQ->DTQ_DESICM
	
	nLocBar := At("/",DTQ->DTQ_ORIGEM)
	cAuxOri := Substr(DTQ->DTQ_ORIGEM,1,nLocBar-1)
	aTamSX3 := TamSX3("DTQ_ORIGEM")
	cOri	:= Alltrim(cAuxOri)+Space(aTamSX3[1]-Len(cAuxOri))
	cOriUf	:= SUBSTR(DTQ->DTQ_ORIGEM,LEN(TRIM(DTQ->DTQ_ORIGEM))-1,2)
	
	nLocBar := At("/",DTQ->DTQ_DESTIN)
	cAuxDes := Substr(DTQ->DTQ_DESTIN,1,nLocBar-1)
	aTamSX3 := TamSX3("DTQ_DESTIN")
	cDes	:= Alltrim(cAuxDes)+Space(aTamSX3[1]-Len(cAuxDes))
	cDesUf	:= PadR(SUBSTR(DTQ->DTQ_DESTIN,LEN(TRIM(DTQ->DTQ_DESTIN))-1,2),2)
	
	nFreteT	:= DTQ->DTQ_VLRINF
	nFreteP	:= DTQ->DTQ_TOTFRE
	nvlinf 	:= DTQ->DTQ_VLRINF
  	nValICM	:= DTQ->DTQ_VALICM
	nValADV	:= DTQ->DTQ_VALADV
	nBaseICM:= DTQ->DTQ_BASICM
	nBaseADV:= DTQ->DTQ_BASADV
	nAliqICM:= DTQ->DTQ_PERICM
	nAliqADV:= DTQ->DTQ_PERADV
	cTES	:= DTQ->DTQ_TES
	cCFOP	:= DTQ->DTQ_CFOP
	cTES2	:= DTQ->DTQ_TES2
	cCFOP2	:= DTQ->DTQ_CFOP2
	cCondpag:= DTQ->DTQ_CONDPG
	cDCon	:= DTQ->DTQ_DCOND
	cCCusto	:= DTQ->DTQ_CCC
	cPago	:= DTQ->DTQ_PAGO  
	cObsContr:= DTQ->DTQ_OBSCTR
	cCodOri := Iif(Empty(DTQ->DTQ_CODORI),GetCodIbge("1"),DTQ->DTQ_CODORI)
	cCodFim := Iif(Empty(DTQ->DTQ_CODDES),GetCodIbge("2"),DTQ->DTQ_CODDES)
	cTpTra	:= DTQ->DTQ_TIPTRA
	cCodIri := DTQ->DTQ_IRIN
	nAFRMM  := DTQ->DTQ_AFRMM
	cNaveg	:= DTQ->DTQ_NAVEG
	cDirNav := DTQ->DTQ_DIRNAV
	//cPlacCav:= DTQ->DTQ_PLACAV
//	cPlacCar:= DTQ->DTQ_PLACAR                                                    
//	cNomMot	:= DTQ->DTQ_MOTORI
	nValEstad  := DTQ->DTQ_VRESTA
	nCarDes	   := DTQ->DTQ_CARDES
	nValEscol  := DTQ->DTQ_VRESCO
	nValPedag  := DTQ->DTQ_VRPEDA
	nValAjud   := DTQ->DTQ_VRAJUD
	nValDesl   := DTQ->DTQ_VRDESL
	nFretePAux := Iif(DTQ->DTQ_XFRETE <= 0,DTQ->DTQ_TOTFRE,DTQ->DTQ_XFRETE)
	nValLice	  := DTQ->DTQ_VRLICE	                                                                              
	nValBalsa  := DTQ->DTQ_VRBALS 
	nValOutr	  := DTQ->DTQ_VROUTR

	If lGerado .or. DTQ->DTQ_NUMCTR = '-'
		nFreteP	:= DTQ->DTQ_TOTFRE
		nFreteT	:= DTQ->DTQ_VLRINF
	Endif                          
	If nvlinf  == 0
		nvlinf:=DTQ->DTQ_TOTFRE
	Endif
	IF LEN(ALLTRIM(cObsContr)) == 0
       cObsContr:=VEROBS(cTES)
    eNDIF   
	cObsSeg	:= DTQ->DTQ_OBSERV
	cNoAs    :=DTQ->DTQ_AS
	
	DbSelectArea("DTC")
	DbOrderNickName("DTCIND10")
	If MsSeek(xFilial("DTC") + DTQ->DTQ_SOT + DTQ->DTQ_OBRA + DTQ->DTQ_VIAGEM )

		cTipNfc := DTC->DTC_TIPNFC

		ZA7->( dbSetOrder(3) )	// ZA7_VIAGEM
		if ! ZA7->( dbSeek( DTQ->DTQ_VIAGEM ) )
			Aviso("Viagem nใo encontrada","A Viagem ["+DTQ->DTQ_VIAGEM+"] nใo foi encontrada na tabela ZA7", {"Ok"})
			Return nil
		endif

		ZA6->( dbSetOrder(1) )
		if ! ZA6->( dbSeek( ZA7->( ZA7_FILIAL + ZA7_PROJET + ZA7_OBRA + ZA7_SEQTRA ) ) )
			Aviso("Viagem nใo encontrado","Filial+Projeto+Obra+SeqTra ["+ZA7->( ZA7_FILIAL +"-"+ ZA7_PROJET +"-"+ ZA7_OBRA +"-"+ ZA7_SEQTRA )+"] nใo foi encontrada na tabela ZA6", {"Ok"})
			Return nil
		endif

		if ZA7->ZA7_DEVEMB == "R"	// inverte
			
			cCodRem := ZA6->ZA6_CLIDES
			cLojRem := ZA6->ZA6_LOJDES
			
			cCodDes := ZA7->ZA7_CODCLI
			cLojDes := ZA7->ZA7_LOJCLI
			/*
			cCodRem := iif( !Empty(DTC->DTC_CLIDES), DTC->DTC_CLIDES, ZA6->ZA6_CLIDES )
			cLojRem := iif( !Empty(DTC->DTC_LOJDES), DTC->DTC_LOJDES, ZA6->ZA6_LOJDES )
			
			cCodDes := iif( !Empty(DTC->DTC_CLIREM), DTC->DTC_CLIREM, ZA7->ZA7_CODCLI )
			cLojDes := iif( !Empty(DTC->DTC_LOJREM), DTC->DTC_LOJREM, ZA7->ZA7_LOJCLI )
			*/
		else
			cCodRem := ZA7->ZA7_CODCLI
			cLojRem := ZA7->ZA7_LOJCLI

			cCodDes := ZA6->ZA6_CLIDES
			cLojDes := ZA6->ZA6_LOJDES
			
			/*
			cCodRem := iif( !Empty(DTC->DTC_CLIREM), DTC->DTC_CLIREM, ZA7->ZA7_CODCLI )
			cLojRem := iif( !Empty(DTC->DTC_LOJREM), DTC->DTC_LOJREM, ZA7->ZA7_LOJCLI )

			cCodDes := iif( !Empty(DTC->DTC_CLIDES), DTC->DTC_CLIDES, ZA6->ZA6_CLIDES )
			cLojDes := iif( !Empty(DTC->DTC_LOJDES), DTC->DTC_LOJDES, ZA6->ZA6_LOJDES )
			*/
		endif

		If !Empty(cCodRem)
			cDesRem := Posicione("SA1",1,xFilial("SA1") + cCodRem + cLojRem ,"A1_NOME")
		Endif
		
		If !Empty(cCodDes)
			cDesDes := Posicione("SA1",1,xFilial("SA1") + cCodDes + cLojDes ,"A1_NOME")
		Endif

		if ZA6->ZA6_TPFRETE == "F"	// FOB
			
			cCodCon := iif( !Empty(DTC->DTC_CLICON), DTC->DTC_CLICON, cCodDes )
			cLojCon := iif( !Empty(DTC->DTC_LOJCON), DTC->DTC_LOJCON, cLojDes )
			cDesCon := Posicione("SA1",1,xFilial("SA1") + cCodCon + cLojCon ,"A1_NOME")   
			
		else						// CIF

			cCodCon := iif( !Empty(DTC->DTC_CLICON), DTC->DTC_CLICON, cCodRem )
			cLojCon := iif( !Empty(DTC->DTC_LOJCON), DTC->DTC_LOJCON, cLojRem )
			cDesCon := Posicione("SA1",1,xFilial("SA1") + cCodCon + cLojCon ,"A1_NOME")  

		endif

		cCodRec := DTC->DTC_CLIREC
		cLojRec := DTC->DTC_LOJREC
		If !Empty(cCodRec)
			cDesRec :=  Posicione("SA1",1,xFilial("SA1") + cCodRec + cLojRec,"A1_NOME" )
		Endif    
				
		cCodExp := DTC->DTC_CLIEXP
		cLojExp := DTC->DTC_LOJEXP
		If !Empty(cCodExp)
			cDesExp :=  Posicione("SA1",1,xFilial("SA1") + cCodExp + cLojExp,"A1_NOME" )
		Endif    
		
		If Len(cCondpag) == 0 
		   If Len(ZA6->ZA6_CONDPAG) == 0   
		      cCprojeto:= ZA6->ZA6_PROJET
		      DBSELECTAREA("ZA6")
		      ZA6->(DbSkip())
		      IF SUBSTR(ZA6->ZA6_PROJET,1,11)<>cCprojeto      
		         ZA6->(DbSkip(-1))
		      Endif
		   Endif  
		   cCondpag := ZA6->ZA6_CONDPAG                               
		   cDcon    := posicione("SE4",1,xFilial("SE4"+alltrim(cCondPag),"E4_DESCRI"))
		   DbSelectArea("DTQ")
		Endif
	Else
	
		ZA7->( dbSetOrder(3) )	// ZA7_VIAGEM
		if ! ZA7->( dbSeek( DTQ->DTQ_VIAGEM ) )
			Aviso("Viagem nใo encontrada","A Viagem ["+DTQ->DTQ_VIAGEM+"] nใo foi encontrada na tabela ZA7", {"Ok"})
			Return nil
		endif

		ZA6->( dbSetOrder(1) )
		if ! ZA6->( dbSeek( ZA7->( ZA7_FILIAL + ZA7_PROJET + ZA7_OBRA + ZA7_SEQTRA ) ) )
			Aviso("Viagem nใo encontrado","Filial+Projeto+Obra+SeqTra ["+ZA7->( ZA7_FILIAL +"-"+ ZA7_PROJET +"-"+ ZA7_OBRA +"-"+ ZA7_SEQTRA )+"] nใo foi encontrada na tabela ZA6", {"Ok"})
			Return nil
		endif

		if ZA7->ZA7_DEVEMB == "R"	// inverte
			
			cCodRem := ZA6->ZA6_CLIDES
			cLojRem := ZA6->ZA6_LOJDES
			
			cCodDes := ZA7->ZA7_CODCLI
			cLojDes := ZA7->ZA7_LOJCLI
			/*
			cCodRem := iif( !Empty(DTC->DTC_CLIDES), DTC->DTC_CLIDES, ZA6->ZA6_CLIDES )
			cLojRem := iif( !Empty(DTC->DTC_LOJDES), DTC->DTC_LOJDES, ZA6->ZA6_LOJDES )
			
			cCodDes := iif( !Empty(DTC->DTC_CLIREM), DTC->DTC_CLIREM, ZA7->ZA7_CODCLI )
			cLojDes := iif( !Empty(DTC->DTC_LOJREM), DTC->DTC_LOJREM, ZA7->ZA7_LOJCLI )
			*/
		else
			cCodRem := ZA7->ZA7_CODCLI
			cLojRem := ZA7->ZA7_LOJCLI

			cCodDes := ZA6->ZA6_CLIDES
			cLojDes := ZA6->ZA6_LOJDES
			
			/*
			cCodRem := iif( !Empty(DTC->DTC_CLIREM), DTC->DTC_CLIREM, ZA7->ZA7_CODCLI )
			cLojRem := iif( !Empty(DTC->DTC_LOJREM), DTC->DTC_LOJREM, ZA7->ZA7_LOJCLI )

			cCodDes := iif( !Empty(DTC->DTC_CLIDES), DTC->DTC_CLIDES, ZA6->ZA6_CLIDES )
			cLojDes := iif( !Empty(DTC->DTC_LOJDES), DTC->DTC_LOJDES, ZA6->ZA6_LOJDES )
			*/
		endif

		If !Empty(cCodRem)
			cDesRem := Posicione("SA1",1,xFilial("SA1") + cCodRem + cLojRem ,"A1_NOME")
		Endif
		
		If !Empty(cCodDes)
			cDesDes := Posicione("SA1",1,xFilial("SA1") + cCodDes + cLojDes ,"A1_NOME")
		Endif

		if ZA6->ZA6_TPFRETE == "F"	// FOB
	
			cCodCon := iif( !Empty(DTC->DTC_CLICON), DTC->DTC_CLICON, cCodDes )
			cLojCon := iif( !Empty(DTC->DTC_LOJCON), DTC->DTC_LOJCON, cLojDes )
			cDesCon := Posicione("SA1",1,xFilial("SA1") + cCodCon + cLojCon ,"A1_NOME")  
		
		else						// CIF
			
			cCodCon := iif( !Empty(DTC->DTC_CLICON), DTC->DTC_CLICON, cCodRem )
			cLojCon := iif( !Empty(DTC->DTC_LOJCON), DTC->DTC_LOJCON, cLojRem )
			cDesCon := Posicione("SA1",1,xFilial("SA1") + cCodCon + cLojCon ,"A1_NOME") 
			
		endif

		cCodRec := DTC->DTC_CLIREC
		cLojRec := DTC->DTC_LOJREC
		If !Empty(cCodRec)
			cDesRec :=  Posicione("SA1",1,xFilial("SA1") + cCodRec + cLojRec,"A1_NOME" )
		Endif    
				
		cCodExp := DTC->DTC_CLIEXP
		cLojExp := DTC->DTC_LOJEXP
		If !Empty(cCodExp)
			cDesExp :=  Posicione("SA1",1,xFilial("SA1") + cCodExp + cLojExp,"A1_NOME" )
		Endif	
	Endif
	DbSelectArea('DTR')
	DbSetOrder(7)
  	
  	If MsSeek(xFilial("DTR") + DTQ->DTQ_SOT + DTQ->DTQ_OBRA + DTQ->DTQ_VIAGEM )
	   lVeic :=.t.
	Else
	   lVeic :=.f.
	Endif   
	
	DbSelectArea("DTQ")
	
	//TIPO FRETE
	cTipo := Iif(ZA6->ZA6_TPFRETE == "F","2","1") 
	
Endif

aSizeAut 	 := MsAdvSize()

If oMainWnd:nClientWidth > 800
	AAdd( aObjects, {  100, 008, .T., .T. } )  //Enchoice
	AAdd( aObjects, {  100, 092, .T., .T. } )  //MsGetDados
Else
	AAdd( aObjects, {  100, 030, .T., .T. } )  //Enchoice
	AAdd( aObjects, {  100, 070, .T., .T. } )  //MsGetDados
EndIf

aInfo 	:= {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aPosObj := MsObjSize( aInfo, aObjects, .T. , .F. )
aPosGet := MsObjGetPos((aSizeAut[3]-aSizeAut[1]),315,{{004,024,240,270}} )

nBLin1:=002
nBCol1:=003
nBLin2:=aPosObj[2,3]-aPosObj[2,1]-15  //Altura
nBCol2:=aPosObj[2,4]-07


//ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
//บMontagem da tela que sehra apresentada para usuario (lay-out)            บ
//ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
DEFINE MSDIALOG oDlg FROM 0,0 TO aSizeAut[6],aSizeAut[5] TITLE OemToAnsi(cTitJan) Of oMainWnd PIXEL

nFolderFre:= 0	//Dados do Frete
nFolderVei:= 0	//Veiculo
nFolderNot:= 0	//Nota do Cliente

AAdd(aTitles,"Dados do Frete"      ) ; nFolderFre:=Len(aTitles)
AAdd(aTitles,"Veํculo/Motorista"   ) ; nFolderVei:=Len(aTitles)
AAdd(aTitles,"NF's do Cliente"     ) ; nFolderNot:=Len(aTitles)

nLin1:=aPosObj[2,1]
nCol1:=aPosObj[2,2]
nLin2:=aPosObj[2,4]-aPosObj[2,2]  //Largura
nCol2:=aPosObj[2,3]-aPosObj[2,1]  //Altura

@ nLin1+15,nCol1 to nLin2+15,nCol2 Of oDlg PIXEL

oFolder:=TFolder():New(0     ,0     ,aTitles  ,aPages     ,oDlg   ,         ,          ,          ,.T.       , .F. )
oFolder:Align:=CONTROL_ALIGN_ALLCLIENT

For nPos:=1 to Len(aTitles)
	oFolder:aDialogs[nPos]:oFont:=oDlg:oFont
Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Consistencia a cada mudanca de pasta do Objeto Folder                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oFolder:bSetOption:={|nIndo|U_MR004MUDA(nIndo,oFolder:nOption,@oDlg,@oFolder)}

nLin1:=aPosObj[1,1]
nCol1:=aPosObj[1,2]
nLin2:=aPosObj[1,3]
nCol2:=aPosObj[1,4]

If nFolderFre>0  //Frete
	nLin1:=002
	nCol1:=003
	nLin2:=aPosObj[2,3]-aPosObj[2,1]-15  //Altura
	nCol2:=aPosObj[2,4]-07
	fFolderFre(nFolderFre, nLin1, nCol1, nLin2, nCol2)
EndIf                                                

/*   dANIEL EM 29/08/08
*/
If nFolderVei>0  //Veiculo
	cAlias   :="DTR"
	cChave   :=xFILIAL(cAlias)+cProjeto+cObra+trim(cViagem)
	cCondicao:='DTR_FILIAL+DTR_SOT+DTR_OBRA+DTR_VIAGEM=="'+cChave+'"'
	nIndice  :=7  //DTR_FILIAL+DTR_FILORI+DTR_VIAGEM+DTR_ITEM
	cFiltro  :=cCondicao
	fFolderVei(nFolderVei,cChave,cCondicao,nIndice,cAlias,cFiltro)
EndIf

If nFolderNot>0  //Nota Fiscal
	//Nota do Cliente
	cAlias   :="DTC"
	cChave   :=xFilial(cAlias)+cProjeto+cObra+trim(cViagem)
	cCondicao:='DTC_FILIAL+DTC_SOT+DTC_OBRA+DTC_VIAGEM=="'+cChave+'"'
	nIndice  :=10  //DTC_FILIAL+DTC_SOT+DTC_VIAGEM
	cFiltro  :=cCondicao
	fFolderNot(nFolderNot,cChave,cCondicao,nIndice,cAlias,cFiltro)
EndIf

@ nLin1,nCol1-05 to nLin1+35,nCol1+545 Of oFolder:aDialogs[1] PIXEL

@ nLin1+6,nCol1+005 Say OemToAnsi("No.As:") Size 100,8     Of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE FONT oFont1
@ nLin1+5,nCol1+090 MsGet oNoAs  Var cNoAs  Size 160,8 When .f. Of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE FONT oFont2

@ nLin1+6,nCol1+260 Say OemToAnsi("Viagem:") Size 100,8     Of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE FONT oFont1
@ nLin1+5,nCol1+306 MsGet oProjeto  Var cViagem  Size 70,8 When lInclui Of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE FONT oFont2

@ nLin1+21,nCol1+005 Say OemToAnsi("Agendamento:") Size 100,8     Of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE FONT oFont1
@ nLin1+20,nCol1+090 MsGet oProjeto  Var cProjeto  Size 160,8 When .f. Of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE FONT oFont2

@ nLin1+21,nCol1+260 Say OemToAnsi("Obra:") Size 100,8     Of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE FONT oFont1
@ nLin1+20,nCol1+306 MsGet oObra  Var cObra Size 35,8 When .F. Of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE FONT oFont2
If lGerado

@ nLin1+06,nCol1+390 Say OemToAnsi("No.CT-e:") Size 100,8     Of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE FONT oFont1
@ nLin1+05,nCol1+455 MsGet oCtrc  Var cCtrc Size 35,8 When .F. Of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE FONT oFont2

Endif

@ nLin1+21,nCol1+390 Say OemToAnsi("Tipo.CT-e:") Size 100,8     Of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE FONT oFont1
@ nLin1+20,nCol1+455 MsGet oTpCtrc  Var cTpCtrc Size 70,8 When .F. Of oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE FONT oFont2

Activate MsDialog oDlg CENTERED On Init EnchoiceBar(oDlg,{||fSalvar(oDlg)},{||fSair(oDlg)},,aButtons)
RestArea(aArea)

Return

********************************************************************************
Static Function fCargaPro
// Carrega os dados da programa็ใo diแria
********************************************************************************
Local cCampo,cCampoGet

If !oFolder:nOption==nFolderVei
	MsgStop("ATENวรO: Favor selecionar a aba Veํculo/Motorista !!")
	Return
EndIf

If MsgYesNo("Confirma a importa็ใo das frotas programadas para esta AS ?")
	// query pegando todos os dados da ZLE com o mesmo n๚mero da AS
	If Select("QRY") > 0
		dbSelectArea("QRY")
		dbCloseArea()
	EndIf   

	cQUery := "SELECT ZLE.ZLE_AS   , ZLE.ZLE_FROTA, ZLE.ZLE_DTPROG, ZLE.ZLE_HORA, ZLE.ZLE_CODMOT, ZLE.ZLE_NOMMOT, ZLE.ZLE_PROJET, ZLE.ZLE_OBRA, "
	cQuery += "       ST9.T9_CODBEM, ST9.T9_NOME   "
	cQuery += "FROM " + RetSqlName("ZLE") + " ZLE LEFT OUTER JOIN "
	cQuery +=           RetSqlName("ST9") + " ST9 ON ZLE.ZLE_FROTA = ST9.T9_CODBEM "
	cQUery += "WHERE ZLE_FILIAL = '" + xFilial("ZLE") + "' AND "
	cQUery += "      ZLE_AS     = '" + cNoAs          + "' AND "
	cQuery += "      ZLE.D_E_L_E_T_ = ' ' "
	cQUery += "ORDER BY ZLE_FROTA, ZLE_DTPROG" 
	
	//	MemoWrit("D:\mp8\Protheus_Data\SYSTEM\004.TXT",_cQuery)

	cQuery := ChangeQuery(cQuery)
	TCQuery cQuery New Alias "QRY"

	dbSelectArea("QRY")
	dbGoTop()

	_cItem := Len(oDlgVei:aCols)
	If (_cItem==1 .and. !Empty(oDlgVei:aCols[1][2])) .or. _cItem > 1
		_cItem++
	EndIf
	
	While QRY->(!Eof())
		// Duplico a ๚ltima linha
		If _cItem > 1// .or. _lNewReg
			AAdd(oDlgVei:aCols,Aclone(oDlgVei:aCols[Len(oDlgVei:aCols)]))
			oDlgVei:aCols[Len(oDlgVei:aCols)][Len(oDlgVei:aHeader)+1] := .F.
		EndIf
		
		For _f:=1 to Len (oDlgVei:aHeader)
			Do Case
			Case AllTrim(oDlgVei:aHeader[_f][2]) == "DTR_ITEM"
				oDlgVei:aCols[Len(oDlgVei:aCols)][_f] := StrZero(_cItem,2)
			Case AllTrim(oDlgVei:aHeader[_f][2]) == "DTR_CODVEI"
				oDlgVei:aCols[Len(oDlgVei:aCols)][_f] := QRY->ZLE_FROTA
			Case AllTrim(oDlgVei:aHeader[_f][2]) == "DTR_MODVEI"
				oDlgVei:aCols[Len(oDlgVei:aCols)][_f] := QRY->T9_NOME
			Case AllTrim(oDlgVei:aHeader[_f][2]) == "DTR_CODMOT"
				oDlgVei:aCols[Len(oDlgVei:aCols)][_f] := QRY->ZLE_CODMOT
			Case AllTrim(oDlgVei:aHeader[_f][2]) == "DTR_NOMMOT"
				oDlgVei:aCols[Len(oDlgVei:aCols)][_f] := QRY->ZLE_NOMMOT
			Case AllTrim(oDlgVei:aHeader[_f][2]) == "DTR_FRECAL"
				oDlgVei:aCols[Len(oDlgVei:aCols)][_f] := "2"	// Inicializados Padrใo
			Case AllTrim(oDlgVei:aHeader[_f][2]) == "DTR_REBTRF"
				oDlgVei:aCols[Len(oDlgVei:aCols)][_f] := "2"	// Inicializados Padrใo
			Case AllTrim(oDlgVei:aHeader[_f][2]) == "DTR_SOT"
				oDlgVei:aCols[Len(oDlgVei:aCols)][_f] := QRY->ZLE_PROJET
			Case AllTrim(oDlgVei:aHeader[_f][2]) == "DTR_OBRA"
				oDlgVei:aCols[Len(oDlgVei:aCols)][_f] := QRY->ZLE_OBRA
			Case AllTrim(oDlgVei:aHeader[_f][2]) == "DTR_DATINI" .or. AllTrim(oDlgVei:aHeader[_f][2]) == "DTR_DATA"
				oDlgVei:aCols[Len(oDlgVei:aCols)][_f] := CtoD(SubStr(QRY->ZLE_DTPROG,7,2)+"/"+SubStr(QRY->ZLE_DTPROG,5,2)+"/"+SubStr(QRY->ZLE_DTPROG,1,4))
			Case AllTrim(oDlgVei:aHeader[_f][2]) == "DTR_HORINI"
				oDlgVei:aCols[Len(oDlgVei:aCols)][_f] := QRY->ZLE_HORA
			Case ValType(oDlgVei:aCols[Len(oDlgVei:aCols)][_f]) == "C"
				oDlgVei:aCols[Len(oDlgVei:aCols)][_f] := ""
			Case ValType(oDlgVei:aCols[Len(oDlgVei:aCols)][_f]) == "N"
				oDlgVei:aCols[Len(oDlgVei:aCols)][_f] := 0
			Case ValType(oDlgVei:aCols[Len(oDlgVei:aCols)][_f]) == "D"
				oDlgVei:aCols[Len(oDlgVei:aCols)][_f] := CtoD("//")
			Case ValType(oDlgVei:aCols[Len(oDlgVei:aCols)][_f]) == "L"
				oDlgVei:aCols[Len(oDlgVei:aCols)][_f] := .T.
			EndCase
		Next _f

//		AAdd(oDlgVei:aCols, {_cItem  , ZLE_FROTA , T9_NOME   , ZLE_CODMOT, ZLE_NOMMOT, ""        , ""        , ""        , 0         , ""        , ""        , 0         , 0         , 0         , ""        , ""        , ""        , 0         , ""        , ""        , ""        , "2"       , "2"       , CtoD("//"), ""        , CtoD("//"), ""        , ""        , ""     , ""        , 0         , 0         , "2"       , "2"       , ""        , 0         , ZLE_PROJET, ZLE_OBRA, 0       , 0       , CtoD("//"), .F.})
//		  		            {ITEM    , ZLE_FROTA , T9_NOME   , ZLE_CODMOT, ZLE_NOMMOT, VAZIO     , DTR_CODRB1, VAZIO     , DTR_QTDEIX, DTR_CODRB2, VAZIO     , DTR_INSRET, DTR_VALFRE, DTR_VALPDG, DTR_CREADI, DTR_LOJCRE, DTR_NOMCRE, DTR_ADIFRE, DTR_TABCAR, DTR_TABFRE, DTR_TIPTAB, DTR_FRECAL, DTR_REBTRF, DTR_DATINI, DTR_HORINI, DTR_DATFIM, VAZIO     , DTR_HORFIM, VAZIO  , DTR_CODFOR,	DTR_VALRB1, DTR_VALRB2, DTR_CALRB1, DTR_CALRB2, DTR_LOJFOR, DTR_QTEIXV, DTR_SOT   , DTR_OBRA, DTR_IRPF, DTR_INSS, DTR_DATA  , .F.})
//		  		            {DTR_ITEM, DTR_CODVEI, DTR_MODVEI, DTR_CODMOT, DTR_NOMMOT, DTR_PROVEI, DTR_CODRB1, DTR_MODRB1, DTR_QTDEIX, DTR_CODRB2, DTR_MODRB2, DTR_INSRET, DTR_VALFRE, DTR_VALPDG, DTR_CREADI, DTR_LOJCRE, DTR_NOMCRE, DTR_ADIFRE, DTR_TABCAR, DTR_TABFRE, DTR_TIPTAB, DTR_FRECAL, DTR_REBTRF, DTR_DATINI, DTR_HORINI, DTR_DATFIM, DTR_TMPVGE, DTR_HORFIM, DTR_OBS, DTR_CODFOR,	DTR_VALRB1, DTR_VALRB2, DTR_CALRB1, DTR_CALRB2, DTR_LOJFOR, DTR_QTEIXV, DTR_SOT   , DTR_OBRA, DTR_IRPF, DTR_INSS, DTR_DATA  , .F.})

		_cFrota   := QRY->ZLE_FROTA
		_cItem	  ++

		// Feito o la็o pois preciso pegar a data da ๚ltima programa็ใo
		While QRY->(!Eof()) .and. QRY->ZLE_FROTA==_cFrota
			// Guardo a ๚ltima data apontada para a frota
			_dDataFim := CtoD(SubStr(QRY->ZLE_DTPROG,7,2)+"/"+SubStr(QRY->ZLE_DTPROG,5,2)+"/"+SubStr(QRY->ZLE_DTPROG,1,4))
		    dbSkip()
		EndDo

		cCampo   :="DTR_DATFIM"		// Atualizo a ๚ltima data apontada para a frota
		cCampoGet:=oDlgVei:aCols[Len(oDlgVei:aCols)][Ascan(oDlgVei:aHeader,{|x|AllTrim(x[2])==cCampo})]
		oDlgVei:aCols[Len(oDlgVei:aCols)][Ascan(oDlgVei:aHeader,{|x|AllTrim(x[2])==cCampo})]:=_dDataFim
	EndDo

	oDlgVei:oBrowse:Refresh()

EndIf

Return

//-----------------------------------------------------------------------------
STATIC FUNCTION fSalvar(oDlg)
//Local aArea:=GetArea()
Local nPos
Local lRet := .T.
if !lGerado
  If ValidNot()  .and. ValidCdpg() .and. VldFrota()
	If MsgYesNo("Confirma a atualiza็ใo do Documento ?")
		If ATU_DTQ()
			if u_TratXML("GRV")	// valida e salva as chaves XMLs -- fonte XMLENT.PRW - Cristiam Rossi em 21/07/2015
				fSalvarVei()  // Veํculo
				fSalvarNot()  //Grava NFE
				If .t.//MsgYesNo("Tabelas atualizadas com sucesso. Deseja sair ??")
					ConfirmSX8()
					oDlg:end()
				EndIf
			EndIf
		EndIf
	EndIf
  Else
    lRet := .f.
  Endif   
  
Else
	Alert("CT-e para esta viagem jแ se encontra gerado.Verifique !")
	oDlg:end()
Endif                                                                           
//RestArea(aArea)
Return lRet

//-----------------------------------------------------------------------------
STATIC FUNCTION fSair(oDlg)
If .t.//MsgYesNo("SAIR SEM GRAVAR. Confirma ??")
	oDlg:end()
ENDIF
RollBackSX8()
Return

//-----------------------------------------------------------------------------
STATIC FUNCTION ATU_DTQ()

Local aTabAux,cChave
Local lTemViagem:= .F.
Local nSaveSX8  := GetSX8Len()
Local cChave:=""  

Private cAutoriz := ""
//Private cTipoVia := "1"  	//1=Normal   
Private cTipoVia := "1"  	//1=Normal -- No dia 02/12/2014 descomentamos esta linha.
Private cRota    := "PADRAO" //Rota
Private cSerTms  := "2"  	//2=Transporte
Private cTipTra  := "1"  	//DLC -> 1=Rodoviแrio
Private aTabAux  :={}

DbSelectArea("DTQ")

cChave:= xFilial("DTQ")+cProjeto+cObra+cViagem
cChave2:=xFilial("DTQ")+cProjeto+cObra

cOrigem	:= trim(cOri) +"/"+ trim(cOriUF)
cDestino:= trim(cDes) +"/"+ trim(cDesUF)
DTQ->(DbSetOrder(RETORDEM("DTQ","DTQ_FILIAL+DTQ_SOT+DTQ_OBRA+DTQ_VIAGEM")))
_Oper   := .T.
If DTQ->(DbSeek(cChave))
	RECLOCK("DTQ", .F. )
Else
	_Oper   := .T.
	If lInclui .Or. lIncCTRB   //pOpc = "I" .Or. pOpc = "B"
		_Status := Iif(lInclui,"V/Z","A/L")
		DTQ->(DbSeek(cChave2))
		While DTQ->(!Eof()) .And. cProjeto  = DTQ->DTQ_SOT .And.  DTQ->DTQ_OBRA = cObra
			If DTQ->DTQ_SITUAC $ _Status
				_Oper   := .F.
			EndIf
			If !_Oper
				exit
			EndIf
			DTQ->(DbSkip())
		End-While
	EndIf
	If _Oper
		RECLOCK("DTQ", .T. )
		AAdd(aTabAux,{"DTQ_FILIAL",'xFILIAL("DTQ")' })
		AADD(aTabAux,{"DTQ_SOT",'cProjeto'			})
		AADD(aTabAux,{"DTQ_OBRA",'cObra'			})
		AAdd(aTabAux,{"DTQ_FILORI",'"01"'           })
		AAdd(aTabAux,{"DTQ_TIPVIA",'cTipoVia'       })
		AAdd(aTabAux,{"DTQ_DATGER",'dDataBase'      })
		AAdd(aTabAux,{"DTQ_HORGER",'Subs(Time(),1,2)+Subs(Time(),4,2)'})
		AAdd(aTabAux,{"DTQ_VIAGEM",'cViagem'		})
		AAdd(aTabAux,{"DTQ_CODCLI",'cCodCli'		})
		AAdd(aTabAux,{"DTQ_LOJA"  ,'cLoja'			})
		AAdd(aTabAux,{"DTQ_NOMCLI",'cNom'	   		})
		AAdd(aTabAux,{"DTQ_SERTMS",'cSerTms'        })
		AAdd(aTabAux,{"DTQ_TIPTRA",'cTpTra'         })
		AAdd(aTabAux,{"DTQ_STATUS",'"1"'            })
		AAdd(aTabAux,{"DTQ_QTDPER",'0'              })
		AAdd(aTabAux,{"DTQ_DIRNAV",'cDirNav'        })
		AAdd(aTabAux,{"DTQ_NAVEG" ,'cNaveg'         })
	Else
	    RECLOCK("DTQ", .F. )
	EndIf                    
	
EndIf

If Empty(DTQ_NUMCTR)
	_cNumCtr := "-"
	AAdd(aTabAux,{'DTQ_NUMCTR'  ,'_cNumCtr' })
EndIf	

AAdd(aTabAux,{'DTQ_ORIGEM','cOrigem'	})  //Cidade+'/'+Estado
AAdd(aTabAux,{'DTQ_DESTIN','cDestino'	})  //Cidade+'/'+Estado
AAdd(aTabAux,{'DTQ_CARREG','cCarreg'	})
AAdd(aTabAux,{'DTQ_UFCOLE','cUFCole'	})
AAdd(aTabAux,{'DTQ_DESCAR','cDescar'	})
AAdd(aTabAux,{'DTQ_UFENTR','cUFEntr'	})
AAdd(aTabAux,{'DTQ_TOTFRE','nFreteP'	})
AAdd(aTabAux,{'DTQ_VLRINF','nFreteT'	})
AAdd(aTabAux,{'DTQ_VALICM','nValICM'	})
AAdd(aTabAux,{'DTQ_VALADV','nValADV'	})
AAdd(aTabAux,{'DTQ_BASICM','nBaseICM'	})
AAdd(aTabAux,{'DTQ_BASADV','nBaseADV'	})
AAdd(aTabAux,{'DTQ_PERICM','nAliqICM'	})
AAdd(aTabAux,{'DTQ_PERADV','nAliqADV'	})
AAdd(aTabAux,{'DTQ_TES'   ,'cTES'		})
AAdd(aTabAux,{'DTQ_CONDPG','cCondpag'	})
AAdd(aTabAux,{'DTQ_DCOND' ,'cDCon'		})
AAdd(aTabAux,{'DTQ_CCC'   ,'cCCusto'	})
AAdd(aTabAux,{'DTQ_PAGO'  ,'cPago'		})
AAdd(aTabAux,{'DTQ_OBSCTR','cObsContr'	})
AAdd(aTabAux,{'DTQ_OBSERV','cObsSeg'	})
AAdd(aTabAux,{'DTQ_DESICM','lDestICM'	})
AAdd(aTabAux,{'DTQ_CFOP'  ,'cCFOP'  	})
AAdd(aTabAux,{"DTQ_TIPTRA",'cTpTra'     }) 
AAdd(aTabAux,{'DTQ_CODORI','cCodOri'	})
AAdd(aTabAux,{'DTQ_CODDES','cCodFim'	})
AAdd(aTabAux,{'DTQ_AFRMM','nAFRMM'		})
AAdd(aTabAux,{'DTQ_IRIN','cCodIri'		})
AAdd(aTabAux,{"DTQ_DIRNAV",'cDirNav'    })
AAdd(aTabAux,{"DTQ_NAVEG" ,'cNaveg'     })
//AAdd(aTabAux,{'DTQ_PLACAV','cPlacCav'	})
//AAdd(aTabAux,{'DTQ_PLACAR','cPlacCar'	})
//AAdd(aTabAux,{'DTQ_MOTORI','cNomMot'	}) 
AAdd(aTabAux,{'DTQ_TES2'   ,'cTES2'		})
AAdd(aTabAux,{'DTQ_CFOP2'  ,'cCFOP2'  	})

//nDescComiss := (nValEstad+nCarDes+nValCcom+nValEscol+nFretePAux) - (nFreteT)
nDescComiss := (nValEscol+nValPedag+nValAjud+nValAdv+nValIcm)
nDescComiss := Abs(nDescComiss)
AAdd(aTabAux,{'DTQ_VRESTA'  ,'nValEstad'  	})
AAdd(aTabAux,{'DTQ_CARDES'  ,'nCarDes'  	})
AAdd(aTabAux,{'DTQ_VRESCO'  ,'nValEscol'  	})
AAdd(aTabAux,{'DTQ_VRPEDA'  ,'nValPedag'  	})
AAdd(aTabAux,{'DTQ_VRAJUD'  ,'nValAjud' 	})
AAdd(aTabAux,{'DTQ_VRDESL'  ,'nValDesl'  	})
AAdd(aTabAux,{'DTQ_DESCOM'  ,'nDescComiss' 	})
AAdd(aTabAux,{'DTQ_XFRETE'  ,'nFretePAux' 	})
AAdd(aTabAux,{'DTQ_VRLICE'  ,'nValLice' 	})
AAdd(aTabAux,{'DTQ_VRBALS'  ,'nValBalsa' 	})
AAdd(aTabAux,{'DTQ_VROUTR'  ,'nValOutr' 	})

DTQ->(fGravaPPP(aTabAux,"DTQ","DTQ"))

DTQ->(MSUNLOCK())

If lInclui
	ConfirmSX8()
EndIf
                                                                                         
Return(.t.)

//-----------------------------------------------------------------------------

Static Function fSalvarVei  //Grava Veํculo
Local aGravados:={}  //Gravados
lOCAL nPos := 0
Local cMotori
Private aHeader,aCols,cItem
// Inicializa o aHeader
aHeader:=oDlgVei:aHeader
Acols  :=oDlgVei:aCols

// Acumula o aCols corrente no aCols com todos os registros
//aCols:=fAcu_aCols(oDlgVei:aCols,oDlgVei_aCols,oDlgVei:aHeader,"DTR_ITEM")

DBSELECTAREA("DTR")  //Veํculos
DBSETORDER(1)  //DTR_FILIAL+DTR_FILORI+DTR_VIAGEM+DTR_ITEM
For nPos:=1 to Len(aCols)
	//cItem:=aCols[nPos][aScan(aHeader,{|x|Alltrim(x[2])=="DTR_ITEM"})]
	cItem:= IF( GDFieldPos("DTR_ITEM")<>0, GDFieldGet("DTR_ITEM",nPos),CITEM) // alterado por fernando nakahara dia 17/06/2011
	
	
	If !aCols[nPos,Len(aHeader)+1] .and. !Empty(cItem)  //Deleted
		DbSeek(xFilial("DTR")+cFilOri+cViagem+cItem)
		If Eof()
			RECLOCK("DTR", .T. )
		Else
			RECLOCK("DTR", .F. )
		EndIf
		
		DTR->(fGravaTudo(nPos,aCols,aHeader))  //Grava todos os campos do aCols
		
		DTR->DTR_FILIAL  :=xFILIAL("DTR")
		DTR->DTR_FILORI  :=cFilOri
		DTR->DTR_VIAGEM  :=cViagem
		DTR->DTR_SOT     :=cProjeto
		DTR->DTR_OBRA    :=cObra
		AAdd(aGravados,Recno())  //Gravados
		MSUNLOCK()
	
	// RETIRADO POR TIAGO OBARA DE OLIVEIRA (BIALE) - 11/07/2011	
	Else
		If DbSeek(xFilial("DTR")+cFilOri+cViagem+cItem)
			RECLOCK("DTR", .F. )
			DBDELETE()
			MSUNLOCK()
		EndIf
	// RETIRADO POR TIAGO OBARA DE OLIVEIRA (BIALE) - 11/07/2011
	ENDIF
Next

//Altera็ใo para atender CT-e por Fernando Willian de Souza Furtado
DbSelectArea("DUP")
DbSetOrder(3)
If MsSeek(xFilial("DUP") + DTQ->DTQ_SOT + DTQ->DTQ_OBRA + DTQ->DTQ_VIAGEM + 'CT')
	Reclock("DUP",.F.)
Else
	Reclock("DUP",.T.)
Endif 
DUP->DUP_FILIAL := xFilial("DUP")
DUP->DUP_FILORI := DTQ->DTQ_FILORI
DUP->DUP_VIAGEM := DTQ->DTQ_VIAGEM
DUP->DUP_ITEDTR := "CT"		//Gravando esse codigo para nใo gerar problemas no CTRB
DUP->DUP_CODMOT := Iif(Len(aCols)>0,GDFieldGet("DTR_CODMOT",1),"")
DUP->DUP_SOT    := DTQ->DTQ_SOT
DUP->DUP_OBRA   := DTQ->DTQ_OBRA
MsUnlock()



// Exclui os registros alterados
/* PRO RODRIGO MORAES 05/01/2012
DbSeek(xFilial("DTR")+cFilOri+cViagem)
While !Eof() .and. DTR_FILIAL+DTR_FILORI+DTR_VIAGEM==xFilial("DTR")+cFilOri+cViagem
	If aScan(aGravados,{|x|x==Recno()})==0
		RECLOCK("DTR", .F. )
		DBDELETE()
		MSUNLOCK()
	EndIf
	DbSkip()
End
*/

Return
//------------------------------------------------------------------
Static Function fSalvarNot  //Grava NFE

Local aHeader,aCols
Local nPos,aGravados:={}  //Gravados
Local aViagem:={}  // JBS 05/02/2007
Local nDtc_Reno:=0 // JBS 05/02/2007
Local nPos_Delete:=0 // JBS 05/02/2007
Local nRecno_Grav:=0 // JBS 05/02/2007

cNumNfc:="      "
cSerNfc:="   "
cCliRem:="      "
cLojRem:="  "


DBSELECTAREA("DTP")
DBSETORDER(3)  // FILIAL + FILORI + VIAGEM

DBSEEK(XFILIAL("DTP")+DTQ->DTQ_FILORI+DTQ->DTQ_VIAGEM , .T. )

DBSELECTAREA("DTC")
DBORDERNICKNAME("DTCIND09")

cViagem:=DTQ->DTQ_VIAGEM

aHeader:=oDlgNot:aHeader
aCols  := oDlgNot:aCols

If DTC->( DbSeek(xFilial("DTC")+cViagem) )
	nDtc_Reno := DTC->( Recno() )
	Do While DTC->(!EOF()) .and. DTC->DTC_FILIAL == xFilial("DTC") .and. DTC->DTC_VIAGEM == cViagem
		aadd(aViagem,DTC->( RECNO() ) )
		DTC->( DbSkip() )
	EndDo
	DTC->( dbGoto(nDtc_Reno) )
EndIf

For nPos:=1 to Len(aCols)
	cNumNfc:=GdFieldGet("DTC_NUMNFC" , nPos, .F., aHeader, aCols)
	cSerNfc:=GdFieldGet("DTC_SERNFC" , nPos, .F., aHeader, aCols)
	cCliRem:=GdFieldGet("DTC_CLIREM" , nPos, .F., aHeader, aCols)
	cLojRem:=GdFieldGet("DTC_LOJREM" , nPos, .F., aHeader, aCols)
	
	If !aCols[nPos,Len(aHeader)+1] .and. !Empty(cNumNfc)  //Deleted
		//
		If nPos <= len(aViagem)  // Se jแ existe registro com este numero de viagem, altera.
			DTC->(dbGoto(aViagem[nPos]))
			RECLOCK("DTC", .f. )
		Else
			RECLOCK("DTC", .t. )
		EndIf
		//
		DTC->DTC_FILIAL:=xFILIAL("DTC")
		DTC->DTC_LOTNFC:=M->DTC_LOTNFC
		DTC->DTC_FILORI:=cFilori
		DTC->DTC_NUMNFC:=GdFieldGet("DTC_NUMNFC" , nPos, .F., aHeader, aCols)
	  /*DTC->DTC_CLIREM:=cCodRem//GdFieldGet("DTC_CLIREM" , nPos, .F., aHeader, aCols)
		DTC->DTC_LOJREM:=cLojRem//GdFieldGet("DTC_LOJREM" , nPos, .F., aHeader, aCols)
		DTC->DTC_CLIDES:=cCodDes//GdFieldGet("DTC_CLIDES" , nPos, .F., aHeader, aCols)
		DTC->DTC_LOJDES:=cLojDes//GdFieldGet("DTC_LOJDES" , nPos, .F., aHeader, aCols)
		DTC->DTC_CLIDEV:=cCodCon//GdFieldGet("DTC_CLIDEV" , nPos, .F., aHeader, aCols)//GdFieldGet("DTC_CLIDEV" , nPos, .F., aHeader, aCols)
		DTC->DTC_LOJDEV:=cLojCon//GdFieldGet("DTC_LOJDEV" , nPos, .F., aHeader, aCols)//GdFieldGet("DTC_LOJDEV" , nPos, .F., aHeader, aCols)*/
		DTC->DTC_DATENT:=GdFieldGet("DTC_DATENT" , nPos, .F., aHeader, aCols)
		DTC->DTC_ORIGEM:=cOrigem
		DTC->DTC_DESTIN:=cDestino
		DTC->DTC_DEVFRE:=GdFieldGet("DTC_DEVFRE" , nPos, .F., aHeader, aCols)
		DTC->DTC_SERTMS:=M->DTC_SERTMS
		DTC->DTC_TIPTRA:=M->DTC_TIPTRA
		DTC->DTC_SERVIC:=M->DTC_SERVIC
		DTC->DTC_SELORI:=M->DTC_SELORI
		DTC->DTC_CDRORI:=M->DTC_CDRORI
		DTC->DTC_CDRDES:=M->DTC_CDRDES
		DTC->DTC_VLRINF:=M->DTC_VLRINF
	  //DTC->DTC_TIPFRE:=M->DTC_TIPFRE
		DTC->DTC_VLRINF:=nVlrInf
		//Begin GEFCO
		DTC->DTC_TIPDES	:=	Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_TIPDES')//Tipo de Despesa
		DTC->DTC_CCUSTO	:= 	Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_CCGEFC')
		DTC->DTC_CCONT	:=	Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_CONTA')
		DTC->DTC_OI		:=	Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_OI') 
		DTC->DTC_CONTA	:=	Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_CCCLIE')
		DTC->DTC_REFGEF	:=	Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_REFGEF')
		//End GEFCO

		DTC->DTC_TIPFRE:=cTipo
		
		DTC->(fGravaTudo(nPos,aCols,aHeader))  //Grava todos os campos do aCols 
		
		DTC->DTC_CLIREM:=cCodRem//GdFieldGet("DTC_CLIREM" , nPos, .F., aHeader, aCols)
		DTC->DTC_LOJREM:=cLojRem//GdFieldGet("DTC_LOJREM" , nPos, .F., aHeader, aCols)
		DTC->DTC_CLIDES:=cCodDes//GdFieldGet("DTC_CLIDES" , nPos, .F., aHeader, aCols)
		DTC->DTC_LOJDES:=cLojDes//GdFieldGet("DTC_LOJDES" , nPos, .F., aHeader, aCols)
		DTC->DTC_CLIDEV:=cCodCon//GdFieldGet("DTC_CLIDEV" , nPos, .F., aHeader, aCols)//GdFieldGet("DTC_CLIDEV" , nPos, .F., aHeader, aCols)
		DTC->DTC_LOJDEV:=cLojCon//GdFieldGet("DTC_LOJDEV" , nPos, .F., aHeader, aCols)//GdFieldGet("DTC_LOJDEV" , nPos, .F., aHeader, aCols)
		DTC->DTC_CLICON:=cCodCon//GdFieldGet("DTC_CLIDEV" , nPos, .F., aHeader, aCols)//GdFieldGet("DTC_CLIDEV" , nPos, .F., aHeader, aCols)
		DTC->DTC_LOJCON:=cLojCon//GdFieldGet("DTC_LOJDEV" , nPos, .F., aHeader, aCols)//GdFieldGet("DTC_LOJDEV" , nPos, .F., aHeader, aCols)
		
		DTC->DTC_CLIREC:=cCodRec
		DTC->DTC_LOJREC:=cLojRec
		DTC->DTC_CLIEXP:=cCodExp
		DTC->DTC_LOJEXP:=cLojExp  		
		
		DTC->DTC_FILIAL  :=xFILIAL("DTC")
		//DTC->DTC_TIPNFC:=M->DTC_TIPNFC  //0=Normal/1=Devolu็ใo Parcial
		//DTC->DTC_CODPRO:="999900011"
		DTC->DTC_CODPRO:="PECAS"
		DTC->DTC_FILORI:=cFilAnt
		//DTC->DTC_LOTNFC:=DTP->DTP_LOTNFC
		DTC->DTC_CDRCAL:=M->DTC_CDRDES
		DTC->DTC_CLICAL:=M->DTC_CLIDES
		DTC->DTC_LOJCAL:=M->DTC_LOJDES
		DTC->DTC_VIAGEM:=DTQ->DTQ_VIAGEM
		DTC->DTC_CONTRA:=DTQ->DTQ_CONTRA
		DTC->DTC_EQUIP :=DTQ->DTQ_EQUIP
		DTC->DTC_SOT   := cProjeto
		DTC->DTC_OBRA  := cObra
		//DTC->DTC_TIPNFC:='0'
		DTC->DTC_SELORI:=StrZero(2,Len(DTC->DTC_SELORI))  
		
				
		nRecno_Grav++
		MSUNLOCK()
		
		//MSMM(DTC->DTC_CODOBS,,,cObsContr,1,,,"DTC","DTC_CODOBS")
	EndIf
Next
// Exlui os que sobraram na grava็ใo do aCols (Os Deletados no aCols e estใo na TABELA DTC)
If Len(aViagem) > nRecno_Grav
	For nPos_Delete := nRecno_Grav+1 to Len(aViagem)
		DTC->( DbGoto(aViagem[nPos_Delete]) )
		DTC->( RECLOCK("DTC", .F. ) )
		DTC->( DbDelete() )
		DTC->( MsUnlock() )
	Next nPos_Delete
EndIf

Return
//-----------------------------------------------------------------------------
Static Function fGravaPPP(aTabAux,cAliPut,cAliGet)
Local nPos,cCampoPut,cCampoGet
For nPos:=1 to Len(aTabAux)
	cCampoPut:=aTabAux[nPos,1]
	cCampoGet:=aTabAux[nPos,2]
	(cAliPut)->(&cCampoPut):=(cAliGet)->(&cCampoGet)
Next
Return(.t.)

//-----------------------------------------------------------------------------
User Function MR004MUDA(nIndo,nEstou,oDlg,oFolder)

Local nPos,aDir,aCols,aCols0,lRet:=.T.
Local nPosRem  := 0
Local nPosDes  := 0
Local nPosCon  := 0
Local nPosCod  := 0, nPosNome := 0
Local nPosTpnf := 0

nPosTpnf	:= aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_TIPNFC"})

nPosCod     := aScan(oDlgVei:aHeader,{|x| AllTrim(x[2]) == "DTR_CODMOT"})
nPosNome    := aScan(oDlgVei:aHeader,{|x| AllTrim(x[2]) == "DTR_NOMMOT"})

nPosCodR    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_CLIREM"})
nPosLojR    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_LOJREM"})
nPosRem     := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_NOMREM"})

nPosCodM    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_CLIDES"})
nPosLojM    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_LOJDES"})
nPosDes     := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_NOMDES"})

nPosCodC    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_CLICON"})
nPosLojC    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_LOJCON"})
nPosCon     := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_NOMCON"})

nPosCodD    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_CLIDEV"})
nPosLojD    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_LOJDEV"})
nPosDev     := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_NOMDEV"})

nPosTipF    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_TIPFRE"})

For nX	:=	1 To Len(oDlgNot:aCols)

		oDlgNot:aCols[nX][nPosCodR] :=  cCodRem
		oDlgNot:aCols[nX][nPosLojR] :=  cLojRem
		oDlgNot:aCols[nX][nPosRem]  :=  Posicione("SA1",1,xFilial("DTC") + cCodRem + cLojRem , "A1_NOME")
		
		oDlgNot:aCols[nX][nPosCodM] :=  cCodDes
		oDlgNot:aCols[nX][nPosLojM] :=  cLojDes
		oDlgNot:aCols[nX][nPosDes]  :=  Posicione("SA1",1,xFilial("DTC") + cCodDes + cLojDes , "A1_NOME")
		
		oDlgNot:aCols[nX][nPosTipF] :=  cTipo
		
		oDlgNot:aCols[nX][nPosCodD] := cCodCon
		oDlgNot:aCols[nX][nPosLojD] := cLojCon
		oDlgNot:aCols[nX][nPosDev]  := Posicione("SA1",1,xFilial("DTC") + cCodCon + cLojCon , "A1_NOME")
		
		oDlgNot:aCols[nX][nPosCodC] := cCodCon
		oDlgNot:aCols[nX][nPosLojC] := cLojCon
		oDlgNot:aCols[nX][nPosCon]  := Posicione("SA1",1,xFilial("DTC") + cCodCon + cLojCon , "A1_NOME")
		
		//oDlgNot:aCols[nX][nPosTpnf] := cTipNfc
						
Next nX

If Len(oDlgVei:aCols) > 1 
	For nX := 1 To Len(oDlgVei:aCols)
		oDlgVei:aCols[nX][nPosCod] 		:= oDlgVei:aCols[1][nPosCod]
		oDlgVei:aCols[nX][nPosNome] 	:= oDlgVei:aCols[1][nPosNome]
	Next nX
EndIf

/*
Do Case
	Case nIndo==nFolderVei
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodR] :=  cCodRem
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojR] :=  cLojRem
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosRem]  :=  Posicione("SA1",1,xFilial("DTC") + cCodRem + cLojRem , "A1_NOME")
		
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodM] :=  cCodDes
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojM] :=  cLojDes
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosDes]  :=  Posicione("SA1",1,xFilial("DTC") + cCodDes + cLojDes , "A1_NOME")
		
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosTipF] :=  cTipo
		
		if !empty(cCodCon)
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodC] := cCodCon
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojC] := cLojCon
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCon]  :=  Posicione("SA1",1,xFilial("DTC") + cCodCon + cLojCon , "A1_NOME")
			
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodD] := cCodRem //cCodCon
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojD] := cLojRem //cLojCon
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosDev]  := Posicione("SA1",1,xFilial("DTC") + cCodRem + cLojRem , "A1_NOME") //Posicione("SA1",1,xFilial("DTC") + cCodCon + cLojCon , "A1_NOME")
		endif
		
		oDlgNot:oBrowse:Refresh()
		
		oDlgVei:oBrowse:Refresh()
	Case nIndo==nFolderNot
		
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodR] :=  cCodRem
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojR] :=  cLojRem
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosRem]  :=  Posicione("SA1",1,xFilial("DTC") + cCodRem + cLojRem , "A1_NOME")
		
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodM] :=  cCodDes
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojM] :=  cLojDes
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosDes]  :=  Posicione("SA1",1,xFilial("DTC") + cCodDes + cLojDes , "A1_NOME")
		
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosTipF] :=  cTipo
		
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodD] := cCodRem //cCodCon
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojD] := cLojRem //cLojCon
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosDev]  := Posicione("SA1",1,xFilial("DTC") + cCodRem + cLojRem , "A1_NOME") //Posicione("SA1",1,xFilial("DTC") + cCodCon + cLojCon , "A1_NOME")
		
		if !empty(cCodCon)
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodC] := cCodCon
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojC] := cLojCon
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCon]  :=  Posicione("SA1",1,xFilial("DTC") + cCodCon + cLojCon , "A1_NOME")
			
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodD] := cCodRem
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojD] := cLojRem
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosDev]  := Posicione("SA1",1,xFilial("DTC") + cCodRem + cLojRem , "A1_NOME")
			
		endif
		
		oDlgNot:oBrowse:Refresh()
		oDlgVei:oBrowse:Refresh()
EndCase


Do Case
	Case nEstou==nFolderVei
		
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodR] :=  cCodRem
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojR] :=  cLojRem
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosRem]  :=  Posicione("SA1",1,xFilial("DTC") + cCodRem + cLojRem , "A1_NOME")
		
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodM] :=  cCodDes
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojM] :=  cLojDes
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosDes]  :=  Posicione("SA1",1,xFilial("DTC") + cCodDes + cLojDes , "A1_NOME")
		
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosTipF] :=  cTipo
		
		if !empty(cCodCon)
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodC] := cCodCon
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojC] := cLojCon
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCon]  :=  Posicione("SA1",1,xFilial("DTC") + cCodCon + cLojCon , "A1_NOME")
			
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodD] := cCodDes
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojD] := cLojDes
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosDev]  := Posicione("SA1",1,xFilial("DTC") + cCodDes + cLojDes , "A1_NOME")
		endif
		
		oDlgNot:oBrowse:Refresh()
		
		oDlgVei:oBrowse:Refresh()
	Case nEstou==nFolderNot
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodR] :=  cCodRem
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojR] :=  cLojRem
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosRem]  :=  Posicione("SA1",1,xFilial("DTC") + cCodRem + cLojRem , "A1_NOME")
		
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodM] :=  cCodDes
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojM] :=  cLojDes
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosDes]  :=  Posicione("SA1",1,xFilial("DTC") + cCodDes + cLojDes , "A1_NOME")
		
		oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosTipF] :=  cTipo
		
		if !empty(cCodCon)
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodC] := cCodCon
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojC] := cLojCon
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCon]  :=  Posicione("SA1",1,xFilial("DTC") + cCodCon + cLojCon , "A1_NOME")
			
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodD] := cCodDes
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojD] := cLojDes
			oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosDev]  := Posicione("SA1",1,xFilial("DTC") + cCodDes + cLojDes , "A1_NOME")
		endif
		
		oDlgNot:oBrowse:Refresh()
		
		oDlgVei:oBrowse:Refresh()
EndCase
*/


If VALTYPE(oDlgNot:aCols[oDlgNot:oBrowse:nAt][10]) <> "U"
	nBaseADV    := 0
	For i:= 1 To Len(oDlgNot:aCols)
		If !oDlgNot:aCols[i][Len(oDlgNot:aHeader)+1]
			nBaseADV    := nBaseADV + GdFieldGet("DTC_VALOR"   , i , .F., oDlgNot:aHeader, oDlgNot:aCols)
		EndIf
	Next
Endif

oDlgVei:oBrowse:Refresh()
oDlgNot:oBrowse:Refresh()
oFolder:Refresh()
oDlg:Refresh()

Return(lRet)


//-----------------------------------------------------------------------------
STATIC FUNCTION fFolderVei(nFolder,cChave,cCondicao,nIndice,cAlias,cFiltro)

Local nStyle:=GD_INSERT + GD_UPDATE + GD_DELETE
Local nOpc := 3
Local aCposnao :=  {"DTR_FILORI","DTR_VIAGEM","DTR_FILVGE","DTR_NUMVGE","DTR_SOT","DTR_OBRA","DTR_TIPO",;
					"DTR_MODRB1","DTR_QTDEIX","DTR_MODRB2","DTR_REBTRF","DTR_VALRB1","DTR_VALRB2","DTR_SLDREC",;
					"DTR_DTVENC","DTR_TPTIAD","DTR_TPTSLD","DTR_PERMUL","DTR_CAREN","DTR_DTPROG","DTR_CODLCR","DTR_IRPF",;
					"DTR_INSS","DTR_DATA","DTR_EXPFOL","DTR_USERGI","DTR_USERGA","DTR_PAGICM","DTR_DIARIA","DTR_DTCREL","DTR_DTDREL","DTR_XSEST"}
Private aCpoGet := {"DTR_ITEM","DTR_TCIOT","DTR_CODVEI","DTR_MODVEI","DTR_CODMOT","DTR_NOMMOT","R_E_C_N_O_"}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontando aHeader para Getdadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aVTemp   :=  U_AHEAD_LOCF("DTR", aCposnao, .F., .F., .F.)
aVHeader := aClone( aVTemp[1] )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontando aCols  para Getdadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAreaDTQ := DTQ->( GetArea() )
aVTemp := U_ACOLS_LOCF("DTR",aVHeader,4,nIndice,xFilial("DTR")+cProjeto+cObra+cViagem, {|| xFilial("DTR")+DTR->DTR_SOT+DTR->DTR_OBRA+DTR->DTR_VIAGEM == xFilial("DTR") + cProjeto + cObra+cViagem } )
DTQ->( RestArea( aAreaDTQ ) )		// des gato --- kkkk

//aVCols     := Iif(DTQ->DTQ_XFRETE > 0, aClone(aVTemp[1]), GetDTR())
aVCols := aClone(aVTemp[1])

if Empty(aVCols[1][1])
	gdFieldPut("DTR_ITEM","01",1, aVHeader, aVCols, .F.)
endif

aSort(aVCols,,,{|x,y| x[1] < y[1]}) //Ordena por item

nStyle:=If(lGerado,0,nStyle)  //2=Visualizar


//oDlgVei:= MsNewGetDados():New(nBLin1,nBCol1,nBLin2,nBCol2,nStyle,"AllwaysTrue","AllwaysTrue","+DTR_ITEM",,,110,,,.t.,oFolder:aDialogs[nFolder],aVHeader,aCpoGet)
oDlgVei:= MsNewGetDados():New(nBLin1,nBCol1,nBLin2,nBCol2,nStyle,"AllwaysTrue","AllwaysTrue","+DTR_ITEM",,,110,,,.t.,oFolder:aDialogs[nFolder],aVHeader,aVCols)


oDlgVei:bChange	:=	{|| ChgLinVei() }
oDlgVei:bFieldOk:=	{|| AtuVeiInf() }





Return

Static Function FHdDTR()

	static aHeader	:= {}
	static aCols	:= {}
	static aEdit	:= {}
	lOCAL aCpoHeader := {}
	
	aCpoHeader   := {"DTR_ITEM","DTR_TCIOT","DTR_CODVEI","DTR_MODVEI","DTR_CODMOT","DTR_NOMMOT","R_E_C_N_O_"}
	
	For _nElemHead := 1 To Len(aCpoHeader)
		_cCpoHead := aCpoHeader[_nElemHead]
		dbSelectArea("SX3")
		dbSetOrder(2)
		If DbSeek(_cCpoHead)
			AAdd(aHeader, {Trim(SX3->X3_Titulo),;
							SX3->X3_Campo       ,;
							SX3->X3_Picture     ,;
							SX3->X3_Tamanho     ,;
							SX3->X3_Decimal     ,;
							SX3->X3_Valid       ,;
							SX3->X3_Usado       ,;
							SX3->X3_Tipo        ,;
							SX3->X3_F3    	 	,;
							SX3->X3_Context		,;
							SX3->X3_Cbox		,;
							SX3->X3_RELACAO		,;
							SX3->X3_WHEN		,;
							SX3->X3_VISUAL})

		Endif
	Next _nElemHead	

//	AADD( aHeader, { "Recno", "R_E_C_N_O_", "", 09, 0,,, "N", "DTR", "V"} )

                       
Return (aHeader)

/*
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION fFolderNot(nFolder,cChave,cCondicao,nIndice,cAlias,cFiltro)

Local nStyle   :=GD_INSERT + GD_UPDATE + GD_DELETE
Local aCposnao := {"DTC_VIAGEM","DTC_SERTMS","DTC_TIPTRA","DTC_DESTPT","DTC_DESSVT","DTC_FILIAL","DTC_LOTNFC","DTC_FILCFS","DTC_NUMSOL",;
					"DTC_FILDPC","DTC_ESTORN","DTC_QTDUNI","DTC_ENDTMS","DTC_INSREM","DTC_SQIREM",;
					"DTC_INSDES","DTC_SQEDES","DTC_SQIDES","DTC_NUMCOT","DTC_SQICON","DTC_ALIANC","DTC_DESALI","DTC_DPCLOC","DTC_VALDPC",;
					"DTC_CLICAL","DTC_LOJCAL","DTC_NOMCAL","DTC_SEQVIA","DTC_EQUIP","DTC_PERC","DTC_CONTRA","DTC_ORIGEM","DTC_DESTIN","DTC_DEVFRE",;
					"DTC_KM","DTC_RECEBE","DTC_HORENT","DTC_DTENTR","DTC_HORCOL","DTC_DATCOL","DTC_OBS","DTC_EDI","DTC_CODOBS","DTC_VLRINF",;
					"DTC_DESSER","DTC_SELORI","DTC_CDRORI","DTC_REGORI","DTC_CDRDES","DTC_REGDES","DTC_CDRCAL","DTC_REGCAL","DTC_DOC",;
					"DTC_SERIE","DTC_CDRPER","DTC_DOCPER","DTC_REGPER","DTC_BASSEG",;
					"DTC_INSDPC","DTC_SQIDPC","DTC_INSCON","DTC_FILORI","DTC_USERGA","DTC_USERGI","DTC_FILDOC","DTC_SERVIC",;
					"DTC_DISTIV","DTC_MODELO","DTC_ICMRET","DTC_MOEDA","DTC_CLINOT","DTC_LOJNOT","DTC_ROTA",;
					"DTC_VALSEG","DTC_MOENFC","DTC_RECISS","DTC_PESLIQ","DTC_INCOTE","DTC_EXCTDA",;
					"DTC_SOT","DTC_OBRA","DTC_NOMNOT","DTC_DOCANE","DTC_CODDCA","DTC_DESROT",;
					"DTC_NFELET","DTC_EMINFE","DTC_CODNFE","DTC_PRVENT","DTC_NFENTR","DTC_FILOCO","DTC_NUMOCO",;
					"DTC_CLIREC","DTC_LOJREC","DTC_NOMREC","DTC_CLIEXP","DTC_LOJEXP","DTC_NOMEXP","DTC_DESTWA"	},nPos


nStyle:=If(lGerado,0,nStyle)  //2=Visualizar

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontando aHeader para Getdadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aTemp   :=  U_AHEAD_LOCF("DTC",aCposnao,.f.,.f.)
aHeader := aClone(aTemp[1])
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontando aCols  para Getdadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
aTemp     :=  U_ACOLS_LOCF("DTC",aHeader,4,nIndice,xFilial("DTC")+DTC->DTC_SOT+DTC->DTC_OBRA+DTC->DTC_VIAGEM, {|| xFilial("DTC")+DTC->DTC_SOT+DTC->DTC_OBRA+DTC->DTC_VIAGEM == xFilial("DTC") + cProjeto + cObra +cViagem} )
aCols     := aClone(aTemp[1])
//ROBERTO MARQUES - 27/05/2015
//oDlgNot:=MsNewGetDados():New(nBLin1,nBCol1,nBLin2,nBCol2,nStyle,"U_VldLinNot()","Allwaystrue","+DTC_FILDOC",,,110,,,.t.,oFolder:aDialogs[nFolder],aHeader,aCols)
oDlgNot:=MsNewGetDados():New(nBLin1,nBCol1,nBLin2,nBCol2,nStyle,"Allwaystrue","Allwaystrue","+DTC_FILDOC",,,110,,,.t.,oFolder:aDialogs[nFolder],aHeader,aCols)
oDlgNot:bChange	:=	{|| ChgLinNot() }
oDlgNot:bFieldOk:=	{|| AtuNfInfo() }

Return
//-----------------------------------------------------------------------------


STATIC FUNCTION fFolderFre(nFolder, nLin1, nLin1, nLin2, nCol2)
Local aSize      := MsAdvSize(.T.,.F.,430,0)
Local nLin := 10
Local oNom2,oNom3
Local oScr

//oScr:= TScrollBox():New(oFolder:aDialogs[nFolder],040,000,210,550,.T.,.T.,.T.) // cria controles
oScr:= TScrollBox():New(oFolder:aDialogs[nFolder],040,nLin1,nLin2-10,nCol2,.T.,.T.,.T.) // cria controles

@ 013+nLin,005 Say OemToAnsi("Cliente"      ) Size 25,8 PIXEL OF oScr
@ 013+nLin,050 Say OemToAnsi("Loja"         ) Size 25,8 PIXEL OF oScr
@ 013+nLin,095 Say OemToAnsi("Nome"         ) Size 25,8 PIXEL OF oScr

@ 021+nLin,005 msGet oCli     VAR cCodCli	Picture "@!" Size 030,8 WHEN .F. PIXEL OF oScr
@ 021+nLin,050 msGet oLoj     VAR cLoja		Picture "@!" Size 015,8 WHEN .F. PIXEL OF oScr
@ 021+nLin,095 msGet oNom     VAR cNom		Picture "@!" Size 176,8 WHEN .F. PIXEL OF oScr


@ 013+nLin,282 Say OemToAnsi("Tipo Frete"      ) Size 50,8 PIXEL OF oScr
@ 021+nLin,282 MSCOMBOBOX oTipo Var cTipo ITEMS aTipo When /*!lGerado*/ .F. SIZE 080, 05 OF oScr PIXEL 

@ 033+nLin,005 Say OemToAnsi("Tp. Transporte"      ) Size 50,8 PIXEL OF oScr
@ 041+nLin,005 MSCOMBOBOX oTpTra Var cTpTra ITEMS aTpTra When /*!lGerado*/ .F. SIZE 080, 05 OF oScr PIXEL

//@ 033+nLin,095 Say OemToAnsi("Tp. Navegacao"      ) Size 50,8 PIXEL OF oScr
//@ 041+nLin,095 MSCOMBOBOX oNaveg Var cNaveg ITEMS aNaveg When !lGerado SIZE 080, 05 OF oScr PIXEL

//@ 033+nLin,282 Say OemToAnsi("Dir. Navega็ใo"      ) Size 50,8 PIXEL OF oScr
//@ 041+nLin,282 MSCOMBOBOX oDirNav Var cDirNav ITEMS aDirNav When !lGerado SIZE 080, 05 OF oScr PIXEL

@ 013+nLin,382 Say OemToAnsi("Cond.Pagto"      ) Size 40,8 PIXEL OF oScr
@ 021+nLin,382 msGet oCondPag Var cCondPag  F3 "SE4" When /*!lGerado*/ .F. Valid ExistCpo("SE4",cCondPag) .AND. !EMPTY(cCondPag) .and. (cDcon:=posicione("SE4",1,xFilial("SE4")+alltrim(cCondPag),"E4_DESCRI"))  Size 030,8 PIXEL OF oScr 

@ 033+nLin,382 Say OemToAnsi("Desc.Cond.Pagto" ) Size 50,8 PIXEL OF oScr
@ 041+nLin,382 msGet oDcon  Var cDCon    Picture "@!" Size 100,8 WHEN .F. PIXEL OF oScr


@ 052+nLin,005 Say OemToAnsi("Remetente"   ) Size 50,8 PIXEL OF oScr
@ 060+nLin,005 msGet oCodRem  VAR cCodRem	 When !lGerado Valid Fnome("1",cCodRem,cLojRem) Picture "@!" f3 'SA1' Size 50,8 PIXEL OF oScr //Valid GrvoDlgNo1(cCodRem)
@ 060+nLin,055 msGet oLojRem  VAR cLojRem	 When !lGerado Valid Fnome("1",cCodRem,cLojRem) Picture "@!" Size 030,8 PIXEL OF oScr
@ 060+nLin,100 msGet oDesRem  VAR cDesRem	 Picture "@!" Size 176,8 WHEN .F. PIXEL OF oScr  
                                                                    

//@ 052+nLin,282 Say OemToAnsi("Placa Cavalo"   ) Size 50,8 PIXEL OF oFolder:aDialogs[nFolder]
//@ 060+nLin,282 msGet oPlacCav  VAR cPlacCav	 When !lGerado Picture "@R !!!-9999" Size 30,8 PIXEL OF oFolder:aDialogs[nFolder]

//@ 071+nLin,282 Say OemToAnsi("Placa Carreta"   ) Size 50,8 PIXEL OF oFolder:aDialogs[nFolder]
//@ 079+nLin,282 msGet oPlacCar  VAR cPlacCar	 When !lGerado Picture "@R !!!-9999" Size 30,8 PIXEL OF oFolder:aDialogs[nFolder]

//@ 088+nLin,282 Say OemToAnsi("Nome Motorista"   ) Size 50,8 PIXEL OF oFolder:aDialogs[nFolder]
//@ 097+nLin,282 msGet oNomMot  VAR cNomMot	 When !lGerado Picture "@!" Size 100,8 PIXEL OF oFolder:aDialogs[nFolder]


@ 071+nLin,005 Say OemToAnsi("Detinatario"   ) Size 50,8 PIXEL OF oScr
@ 079+nLin,005 msGet oCodDes  VAR cCodDes	 When !lGerado Valid Fnome("2",cCodDes,cLojDes) .And. Regra() Picture "@!" f3 'SA1' Size 50,8 PIXEL OF oScr //Valid GrvoDlgNo2(cCodDes)
@ 079+nLin,055 msGet oLojDes  VAR cLojDes	 When !lGerado Valid Fnome("2",cCodDes,cLojDes) Picture "@!" Size 030,8 PIXEL OF oScr
@ 079+nLin,100 msGet oDesDes  VAR cDesDes	 Picture "@!" Size 176,8 WHEN .F. PIXEL OF oScr

@ 088+nLin,005 Say OemToAnsi("Consignatario"   ) Size 50,8 PIXEL OF oScr
@ 097+nLin,005 msGet oCodCon  VAR cCodCon	 When !lGerado Valid Fnome("3",cCodCon,cLojCon) Picture "@!"  f3 'SA1' Size 50,8 PIXEL OF oScr //valid GrvoDlgNo3(cCodCon)
@ 097+nLin,055 msGet oLojCon  VAR cLojCon	 When !lGerado Valid Fnome("3",cCodCon,cLojCon) Picture "@!" Size 030,8 PIXEL OF oScr
@ 097+nLin,100 msGet oDesCon  VAR cDesCon	 Picture "@!" Size 176,8 WHEN .F. PIXEL OF oScr

@ 052+nLin,285 Say OemToAnsi("Expedidor"   ) Size 50,8 PIXEL OF oScr
@ 060+nLin,285 msGet oCodExp  VAR cCodExp	 When !lGerado Valid Fnome("4",cCodExp,cLojExp) Picture "@!" f3 'SA1' Size 50,8 PIXEL OF oScr //Valid GrvoDlgNo1(cCodRem)
@ 060+nLin,335 msGet oLojExp  VAR cLojExp	 When !lGerado Valid Fnome("4",cCodExp,cLojExp) Picture "@!" Size 030,8 PIXEL OF oScr
@ 060+nLin,380 msGet oDesExp  VAR cDesExp	 Picture "@!" Size 176,8 WHEN .F. PIXEL OF oScr

@ 071+nLin,285 Say OemToAnsi("Recebedor"   ) Size 50,8 PIXEL OF oScr
@ 079+nLin,285 msGet oCodRec  VAR cCodRec	 When !lGerado Valid Fnome("5",cCodRec,cLojRec) Picture "@!" f3 'SA1' Size 50,8 PIXEL OF oScr //Valid GrvoDlgNo2(cCodDes)
@ 079+nLin,335 msGet oLojRec  VAR cLojRec	 When !lGerado Valid Fnome("5",cCodRec,cLojRec) Picture "@!" Size 030,8 PIXEL OF oScr
@ 079+nLin,380 msGet oDesRec  VAR cDesRec	 Picture "@!" Size 176,8 WHEN .F. PIXEL OF oScr  

@ 110+nLin,005 Say OemToAnsi("Cidade Origem"       ) Size 50,8 PIXEL OF oScr
@ 110+nLin,109 Say OemToAnsi("UF"                  ) Size 16,8 PIXEL OF oScr
@ 110+nLin,175 Say OemToAnsi("Cidade Destino"      ) Size 50,8 PIXEL OF oScr
@ 110+nLin,282 Say OemToAnsi("UF"                  ) Size 16,8 PIXEL OF oScr
@ 110+nLin,320 Say OemToAnsi("TES"                 ) Size 16,8 PIXEL OF oScr COLOR CLR_HBLUE    
@ 110+nLin,360 Say OemToAnsi("CFOP"                 ) Size 16,8 PIXEL OF oScr COLOR CLR_HBLUE

@ 118+nLin,005 msGet oOri     VAR cOri     	When /*!lGerado*/ .F. Picture "@!" Size 100,8 PIXEL OF oScr Valid !Empty(cOri)
@ 118+nLin,109 msGet oOriUf   VAR cOriUf   	When /*!lGerado*/ .F.  Picture "@!" Size 014,8 PIXEL OF oScr F3 "12" Valid ExistCpo("SX5","12"+cOriUf) .And. !Empty(cOriUf)
@ 118+nLin,175 msGet oDes     VAR cDes     	When /*!lGerado*/ .F.  Picture "@!" Size 100,8 PIXEL OF oScr Valid !Empty(cDes)
@ 118+nLin,282 msGet oDesUf   VAR cDesUf   	When /*!lGerado*/ .F.  Picture "@!" Size 014,8 PIXEL OF oScr F3 "12" Valid !Empty(cDesUf) .And. ExistCpo("SX5","12"+cDesUf) 
@ 118+nLin,320 msGet oTES     VAR cTES     	F3 "SF4" When /*!lGerado*/ .F.  Valid VldTes(cTes) Size 014,8 PIXEL OF oScr
VldTes( cTes )

@ 118+nLin,360 msGet oCFOP    VAR cCFOP   	When /*!lGerado*/ .F.  VALID !Empty(cCFOP) Size 014,8 PIXEL OF oScr


//ROBERTO MARQUES - 27/05/2015
//@ 130+nLin,005 Say OemToAnsi("Cod.Munic.Origem"       ) Size 50,8 PIXEL OF oScr
//@ 130+nLin,175 Say OemToAnsi("Cod.Munic.Destino"      ) Size 50,8 PIXEL OF oScr
//@ 138+nLin,005 msGet oCodOri  VAR cCodOri  	F3 "CC2ORG" When !lGerado Picture "@!" Size 100,8 PIXEL OF oScr Valid !Empty(cCodOri) .And. fNomCid("1",cOriUf,cCodOri)
//@ 138+nLin,175 msGet oCodFim  VAR cCodFim 	F3 "CC2DES" When !lGerado Picture "@!" Size 100,8 PIXEL OF oScr Valid !Empty(cCodFim) .And. fNomCid("2",cDesUf,cCodFim)

//@ 130+nLin,320 Say OemToAnsi("TES AFRMM"       ) Size 50,8 PIXEL OF oScr
//@ 130+nLin,360 Say OemToAnsi("CFOP AFRMM"      ) Size 50,8 PIXEL OF oScr
//@ 138+nLin,320 msGet oTES2  VAR cTES2  	F3 "SF4" When !lGerado Valid VldTes(cTes2) Picture "@!" Size 014,8 PIXEL OF oScr 
//@ 138+nLin,360 msGet oCFOP2 VAR cCFOP2 	When !lGerado VALID !Empty(cCFOP2) .OR. cTpTra == '1'  Picture "@!" Size 014,8 PIXEL OF oScr 

aPL := { 140+nLin, 155+nLin, 170+nLin, 185+nLin, 200+nLin, 215+nLin, 230+nLin, 245+nLin }
aPC := { 005,045,150,195,300,350,440,490,  }

// linha 1

@ aPL[1], aPC[1] Say "Frete" of oScr Pixel
If Empty(DTQ->DTQ_TPCTRC)
	@ aPL[1], aPC[2] msGet oFretePAux VAR nFretePAux    PICTURE "@E 999,999,999.99" When .F. Size 046,8 PIXEL OF oScr
Else
	@ aPL[1], aPC[2] msGet oFretePAux VAR nFretePAux    PICTURE "@E 999,999,999.99" VALID Iif(DTQ->DTQ_TPCTRC $ "1",(fCalcTotal(nvlinf,1) ) ,.T.) Size 046,8 PIXEL OF oScr
EndIf

@ aPL[1], aPC[3] Say "Imposto Frete" of oScr Pixel
@ aPL[1], aPC[4] msGet oImpFrete VAR nImpFrete  PICTURE "@E 999,999,999.99"  When .F. Size 046,8 PIXEL OF oScr

@ aPL[1], aPC[5] Say "Frete Peso" PIXEL OF oScr
@ aPL[1], aPC[6] msGet oFreteP  VAR nFreteP     PICTURE "@E 999,999,999.99"  When !Empty(DTQ->DTQ_TPCTRC) VALID Iif(Empty(DTQ->DTQ_TPCTRC) .Or. DTQ->DTQ_TPCTRC $ "1",(fCalcTotal(nvlinf,1) ) .And. !Empty(nFreteP),.T.) Size 046,8 PIXEL OF oScr

// linha 2

@ aPL[2], aPC[1] Say "Base Ad-Val"  PIXEL OF oScr
@ aPL[2], aPC[2] msGet oBaseADV  VAR nBaseADV    PICTURE "@E 999,999,999.99"  When !Empty(DTQ->DTQ_TPCTRC) VALID fCalcTotal(nvlinf,2) Size 046,8 PIXEL OF oScr

@ aPL[2], aPC[3] Say "% Ad-valorem" PIXEL OF oScr
@ aPL[2], aPC[4] msGet oAliqADV  VAR nAliqAdv    PICTURE "@E 999,999,999.999" When !Empty(DTQ->DTQ_TPCTRC) VALID fCalcTotal(nvlinf,2) Size 046,8 PIXEL OF oScr

@ aPL[2], aPC[5] Say "Ad-valorem"  PIXEL OF oScr
@ aPL[2], aPC[6] msGet oADVal   VAR nADVal     PICTURE "@E 999,999,999.99"  When .F. Size 046,8 PIXEL OF oScr

@ aPL[2], aPC[7] Say "Imposto Ad-valorem"  PIXEL OF oScr
@ aPL[2], aPC[8] msGet oImpADV   VAR nImpADV     PICTURE "@E 999,999,999.99"  When .F. Size 046,8 PIXEL OF oScr

// linha 3

@ aPL[3], aPC[7] Say "Frete Valor"  PIXEL OF oScr
@ aPL[3], aPC[8] msGet oFreteVal VAR nFreteVal   PICTURE "@E 999,999,999.99"  When !Empty(DTQ->DTQ_TPCTRC) VALID fSumTot() Size 046,8 PIXEL OF oScr

// linha 4

@ aPL[4], aPC[1] Say "Valor Pedแgio"   PIXEL OF oScr
@ aPL[4], aPC[2] msGet oValPedag VAR nValPedag  PICTURE "@E 999,999,999.99"  WHEN .F. Size 046,8 PIXEL OF oScr

@ aPL[4], aPC[3] Say "Imposto Pedแgio" PIXEL OF oScr
@ aPL[4], aPC[4] msGet oImpPeda  VAR nImpPeda   PICTURE "@E 999,999,999.99"  WHEN .F. Size 046,8 PIXEL OF oScr

@ aPL[4], aPC[5] Say "Valor Outros"    PIXEL OF oScr
@ aPL[4], aPC[6] msGet oValOutr  VAR nValOutr   PICTURE "@E 999,999,999.99"  When !lGerado Valid ( fCalcTotal(nvlinf,1),  ) Size 046,8 PIXEL OF oScr

@ aPL[4], aPC[7] Say "Imposto Outros"  PIXEL OF oScr
@ aPL[4], aPC[8] msGet oImpOutr  VAR nImpOutr   PICTURE "@E 999,999,999.99"  WHEN .F. Size 046,8 PIXEL OF oScr

// linha 5

@ aPL[5], aPC[1] Say "Valor Estadia" PIXEL OF oScr 
@ aPL[5], aPC[2] msGet oValEstad VAR nValEstad  PICTURE "@E 999,999,999.99"  When .F. Size 046,8 PIXEL OF oScr

@ aPL[5], aPC[3] Say "Valor Balsa"   PIXEL OF oScr
@ aPL[5], aPC[4] msGet oValBalsa VAR nValBalsa  PICTURE "@E 999,999,999.99"  When .F. Size 046,8 PIXEL OF oScr

@ aPL[5], aPC[5] Say "Carga/Descarga" PIXEL OF oScr
@ aPL[5], aPC[6] msGet oCarDes   VAR nCarDes    PICTURE "@E 999,999,999.99"  When .F. Size 046,8 PIXEL OF oScr

@ aPL[5], aPC[7] Say "Val. Ajudante"  PIXEL OF oScr
@ aPL[5], aPC[8] msGet oValAjud  VAR nValAjud   PICTURE "@E 999,999,999.99"  When .F. Size 046,8 PIXEL OF oScr

// linha 6

@ aPL[6], aPC[1] Say "Valor Licenca" PIXEL OF oScr
@ aPL[6], aPC[2] msGet oValLice  VAR nValLice   PICTURE "@E 999,999,999.99"  When .F. Size 046,8 PIXEL OF oScr

@ aPL[6], aPC[3] Say "Valor Escolta" PIXEL OF oScr
@ aPL[6], aPC[4] msGet oValEscol VAR nValEscol  PICTURE "@E 999,999,999.99"  WHEN .F. Size 046,8 PIXEL OF oScr

@ aPL[6], aPC[5] Say "Val. Deslocamento" PIXEL OF oScr
@ aPL[6], aPC[6] msGet oValDesl VAR nValDesl    PICTURE "@E 999,999,999.99"  When .F. Size 046,8 PIXEL OF oScr  

// linha 7

@ aPL[7], aPC[1] Say "Base ICMS"  PIXEL OF oScr
@ aPL[7], aPC[2] msGet oBaseICM VAR nBaseICM    When lVer .and. !Empty(DTQ->DTQ_TPCTRC) PICTURE "@E 9,999,999.99"  VALID fCalcTotal(nvlinf,2) Size 046,8 PIXEL OF oScr

@ aPL[7], aPC[3] Say "Aliq ICMS"  PIXEL OF oScr
@ aPL[7], aPC[4] msGet oAliqICM VAR nAliqICM    When lVer .and. !Empty(DTQ->DTQ_TPCTRC) PICTURE "@E 999,999,999.99"  VALID fCalcTotal(nvlinf,3) Size 046,8 PIXEL OF oScr

@ aPL[7], aPC[5] Say "Valor ICMS" PIXEL OF oScr
@ aPL[7], aPC[6] msGet oValICM  VAR nValICM     When lVer .and. !Empty(DTQ->DTQ_TPCTRC) PICTURE "@E 999,999,999.99"  VALID fCalcTotal(nvlinf,2) Size 046,8 PIXEL OF oScr

@ aPL[7], aPC[7] CHECKBOX oChk VAR lDestICM PROMPT "Destaca ICMS" SIZE 70, 10 OF oScr

// linha 8

@ aPL[8], aPC[1] Say "Total Frete" PIXEL OF oScr
@ aPL[8], aPC[2] msGet oFreteT  VAR nFreteT     PICTURE "@E 9999,999,999.99"  WHEN .F. Size 046,8 PIXEL OF oScr



//nValEstad:=nCarDes:=nValEscol:=nValPedag:=nValSCom:=nValCcom
// ########## 1 Coluna ###########
//@ 155+nLin,005 Say OemToAnsi("Valor Estadia"   ) Size 50,8 PIXEL OF oScr 
//@ 155+nLin,045 msGet oValEstad  VAR nValEstad  PICTURE "@E 999,999,999.99"   When /*!lGerado*/ .F.  Size 046,8 PIXEL OF oScr

//@ 170+nLin,005 Say OemToAnsi("Carga/Descarga"  ) Size 50,8 PIXEL OF oScr
//@ 170+nLin,045 msGet oCarDes  VAR nCarDes     PICTURE "@E 999,999,999.99"  When /*!lGerado*/ .F.  Size 046,8 PIXEL OF oScr

//@ 185+nLin,005 Say OemToAnsi("Valor Escolta"  ) Size 50,8 PIXEL OF oScr
//@ 185+nLin,045 msGet oValEscol  VAR nValEscol     PICTURE "@E 999,999,999.99"  WHEN /*!lGerado*/ .F.  Size 046,8 PIXEL OF oScr

// ########## 2 Coluna ###########
//@ 155+nLin,150 Say OemToAnsi("Valor Pedแgio"    ) Size 50,8 PIXEL OF oScr
//@ 155+nLin,195 msGet oValPedag VAR nValPedag    PICTURE "@E 999,999,999.99"  WHEN /*!lGerado*/ .F.  Size 046,8 PIXEL OF oScr

//@ 170+nLin,150 Say OemToAnsi("Val. Ajudante" ) Size 50,8 PIXEL OF oScr
//@ 170+nLin,195 msGet oValAjud VAR nValAjud    PICTURE "@E 999,999,999.99" When /*!lGerado*/ .F.  Size 046,8 PIXEL OF oScr

//@ 155+nLin,300 Say OemToAnsi("Valor Balsa" ) Size 50,8 PIXEL OF oScr
//@ 155+nLin,350 msGet oValBalsa VAR nValBalsa PICTURE "@E 999,999,999.99" When /*!lGerado*/ .F.  Size 046,8 PIXEL OF oScr

//@ 170+nLin,300 Say OemToAnsi("Valor Licenca" ) Size 50,8 PIXEL OF oScr
//@ 170+nLin,350 msGet oValLice VAR nValLice    PICTURE "@E 999,999,999.99" When /*!lGerado*/ .F.  Size 046,8 PIXEL OF oScr

//@ 185+nLin,150 Say OemToAnsi("Val. Deslocamento" ) Size 50,8 PIXEL OF oScr
//@ 185+nLin,195 msGet oValDesl VAR nValDesl    PICTURE "@E 999,999,999.99" When /*!lGerado*/ .F.  Size 046,8 PIXEL OF oScr  

  
//@ 185+nLin,300 Say OemToAnsi("Valor Outros" ) Size 50,8 PIXEL OF oScr
//@ 185+nLin,350 msGet oValOutr VAR nValOutr PICTURE "@E 999,999,999.99" When !lGerado Valid ( fCalcTotal(nvlinf,1),  ) Size 046,8 PIXEL OF oScr




//@ 155+nLin,440 Say OemToAnsi("Frete " ) Size 50,8 PIXEL OF oScr
//If Empty(DTQ->DTQ_TPCTRC)
//	@ 155+nLin,470 msGet oFretePAux VAR nFretePAux    PICTURE "@E 999,999,999.99" When /*!lGerado*/ .F.  VALID Iif(Empty(DTQ->DTQ_TPCTRC),(fCalcTotal(nvlinf,1) ) .And. !Empty(nFretePAux),.T.) Size 046,8 PIXEL OF oScr
//Else
//	@ 155+nLin,470 msGet oFretePAux VAR nFretePAux    PICTURE "@E 999,999,999.99" When /*!lGerado*/ .T. VALID Iif(DTQ->DTQ_TPCTRC $ "1",(fCalcTotal(nvlinf,1) ) ,.T.) Size 046,8 PIXEL OF oScr
//EndIf

//===========================================

// ########## 1 Coluna ###########
//@ 200+nLin,005 Say OemToAnsi("Frete Peso"   ) Size 50,8 PIXEL OF oScr COLOR CLR_BLUE
//@ 155+nLin,045 msGet oFreteP  VAR nFreteP  PICTURE "@E 9,999,999.99"  when nFreteP == 0 VALID (fCalcTotal(nvlinf,1)) .And. !Empty(nFreteP) Size 046,8 PIXEL OF oFolder:aDialogs[nFolder]
//@ 155+nLin,045 msGet oFreteP  VAR nFreteP  PICTURE "@E 9,999,999.99"   When !lGerado VALID (!Empty(nFreteP) .or. !Empty(DTQ->DTQ_CTRORI)) .OR. (fCalcTotal(nvlinf,1)) Size 046,8 PIXEL OF oFolder:aDialogs[nFolder]
//@ 200+nLin,045 msGet oFreteP  VAR nFreteP  PICTURE "@E 999,999,999.99"   When !Empty(DTQ->DTQ_TPCTRC) VALID Iif(Empty(DTQ->DTQ_TPCTRC) .Or. DTQ->DTQ_TPCTRC $ "1",(fCalcTotal(nvlinf,1) ) .And. !Empty(nFreteP),.T.) Size 046,8 PIXEL OF oScr

//@ 215+nLin,005 Say OemToAnsi("Frete Valor"  ) Size 50,8 PIXEL OF oScr
//@ 215+nLin,045 msGet oValADV  VAR nValADV     PICTURE "@E 999,999,999.99"  When !lGerado VALID fCalcTotal(nvlinf,2) Size 046,8 PIXEL OF oScr
//@ 215+nLin,045 msGet oValADV  VAR nValADV     PICTURE "@E 999,999,999.99"  When /*!lGerado*/ !Empty(DTQ->DTQ_TPCTRC) VALID fSumTot() Size 046,8 PIXEL OF oScr

//@ 230+nLin,005 Say OemToAnsi("Total Frete"  ) Size 50,8 PIXEL OF oScr
//@ 230+nLin,045 msGet oFreteT  VAR nFreteT     PICTURE "@E 9999,999,999.99"  WHEN .F. VALID fCalcTotal(nvlinf,2) Size 046,8 PIXEL OF oScr

// ########## 2 Coluna ###########
//@ 200+nLin,150 Say OemToAnsi("Aliq ICMS"    ) Size 50,8 PIXEL OF oScr
//@ 200+nLin,195 msGet oAliqICM VAR nAliqICM    When lVer .and. /*!lGerado*/ !Empty(DTQ->DTQ_TPCTRC) PICTURE "@E 999,999,999.99"  VALID fCalcTotal(nvlinf,3) Size 046,8 PIXEL OF oScr

//@ 215+nLin,150 Say OemToAnsi("% Ad-valorem" ) Size 50,8 PIXEL OF oScr
//@ 215+nLin,195 msGet oAliqADV VAR nAliqAdv    PICTURE "@E 999,999,999.999" When /*!lGerado*/ !Empty(DTQ->DTQ_TPCTRC) VALID fCalcTotal(nvlinf,2) Size 046,8 PIXEL OF oScr

//@ 230+nLin,150	CHECKBOX oChk VAR lDestICM When /*!lGerado*/ .F. PROMPT "Destaca ICMS na N.F." SIZE 70, 10 OF oScr
               
// ########## 3 Coluna ###########
//@ 200+nLin,300 Say OemToAnsi("Valor ICMS"   ) Size 50,8 PIXEL OF oScr
//@ 200+nLin,350 msGet oValICM  VAR nValICM     When lVer .and. /*!lGerado*/ !Empty(DTQ->DTQ_TPCTRC) PICTURE "@E 999,999,999.99"  VALID fCalcTotal(nvlinf,2) Size 046,8 PIXEL OF oScr

//@ 215+nLin,300 Say OemToAnsi("Base ICMS"    ) Size 50,8 PIXEL OF oScr
//@ 215+nLin,350 msGet oBaseICM VAR nBaseICM    When lVer .and. /*!lGerado*/ !Empty(DTQ->DTQ_TPCTRC) PICTURE "@E 9,999,999.99"  VALID fCalcTotal(nvlinf,2) Size 046,8 PIXEL OF oScr

//@ 230+nLin,300 Say OemToAnsi("Base Ad-Val"  ) Size 50,8 PIXEL OF oScr
//@ 230+nLin,350 msGet oBaseADV VAR nBaseADV    PICTURE "@E 999,999,999.99"  When /*!lGerado*/ !Empty(DTQ->DTQ_TPCTRC) VALID fCalcTotal(nvlinf,2) Size 046,8 PIXEL OF oScr

	fCalcTotal(nvlinf,1)
	fSumTot()
	fCalcTotal(nvlinf,2)
	fCalcTotal(nvlinf,3)

//@ 200+nLin,300 Say OemToAnsi("Val. AFRMM"  ) Size 50,8 PIXEL OF oScr
//@ 200+nLin,350 msGet oAFRMM  VAR nAFRMM     PICTURE "@E 9999,999,999.99"  WHEN !lGerado Size 046,8 PIXEL OF oScr

//@ 215+nLin,300 Say OemToAnsi("Cod. Irin"  ) Size 50,8 PIXEL OF oScr
//@ 215+nLin,350 msGet oCodIri     VAR cCodIri     	When !lGerado Picture "@!" Size 70,8 PIXEL OF oScr

//	@ 245+nLin,005 Say  OemToAnsi("Obs.CTR"      ) Size 50,8 PIXEL OF oScr
//	@ 255+nLin,005 Get oObsContr VAR cObsContr    When !lGerado MEMO Size 230,170 PIXEL OF oScr

	@ 265+nLin,005 Say  OemToAnsi("Obs.CTR"      ) Size 50,8 PIXEL OF oScr
	@ 275+nLin,005 Get oObsContr VAR cObsContr    When !lGerado MEMO Size 230,170 PIXEL OF oScr

	oCli:SetFocus()

Return nil


//-----------------------------------------------------------------------------
Static Function fCalcTotal(lTotal,Nx)  //Calcula o Frete
Local nAliqAnt := 0
Local aRetorno

If Empty(DTQ->DTQ_CTRORI) .Or. DTQ->DTQ_TPCTRC $ "1"
	DbSelectArea("SF4")
	DbSetOrder(1)                       
	if !Empty(cTes)
	   MsSeek(xFilial("SF4") + cTes )
	   If nx==1 	   	   			   

		AddValor()

	   	 If Len(aCalc) == 2
	   	 	If nFreteP == aCalc[2]
	   	 		lTotal := aCalc[1]
	   	 	Else
	   	 		lTotal = nFreteP
	   	 		aCalc	:=	{}
	   	 		aAdd(aCalc,nFreteP)
	   	 	EndIf
	   	 Else
		   	aAdd(aCalc,nFreteP)
	   	 	lTotal = nFreteP
	   	 EndIf
	   		     
	   	
	      //lTotal:=DTQ->DTQ_VLRINF
	      //iF lTotal == 0 .or. lTotal > nFreteP
	      
	      //Endif
	//      nFreteP := 0
	//      nValADV := 0 
	//      nBaseIcm:= 0 
	//      nValICM := 0 
	//      nPerICM := 0 
	   Endif     



/*
	   If SF4->F4_LFICM == "T" .or. SF4->F4_LFICM == "O"   
	      if nX==1
	         nFreteP	:= lTotal / (1-(nAliqICM / 100))
	      Endif
	      if nX<>3//chamado na aliq.icms
	      	nValADV := (nBaseADV * (nAliqADV/100)) // / (1-(nAliqICM / 100)) Nใo soma icms no advalorem
	      EndIf

	      nBaseIcm:= Round((nFreteP + Round((nValAdv / (1-(nAliqICM / 100))),2)),2)

			if cOriUF == "PR"	// nao incidir Valor do Pedagio na Base do ICMS no estado do Parana - Cristiam Rossi em 18/08/2015
	      		nBaseIcm -= nValPedag
			endif

	      nValICM := nBaseICM * (nAliqICM/100)
	      IF SF4->F4_LFICM == "T"
	         lDestICM:= .T.
	      Endif    
	   Else
	      nValADV := (nBaseADV * (nAliqADV/100)) 
	      nBaseIcm:= 0
	      nValICM := 0
	      nPerICM := 0
	      nAliqICM := 0
	   Endif
*/
		if nX<>3//chamado na aliq.icms
			nValADV := (nBaseADV * (nAliqADV/100)) // / (1-(nAliqICM / 100)) Nใo soma icms no advalorem
		EndIf

		aRetorno := fCalcImposto( { { 1, nFretePAux + nValPedag + nValOutr}, { 1, nVALADV} } )

		nBaseIcm := aRetorno[3]
		nValIcm  := aRetorno[2]
		nFreteT  := aRetorno[1]
		
//		nValADV  += aRetorno[2]

		if cOriUF == "PR"	// nao incidir Valor do Pedagio na Base do ICMS no estado do Parana - Cristiam Rossi em 18/08/2015
			nBaseIcm -= nValPedag
		endif

//		lDestICM := ( SF4->F4_LFICM == "T" )

	    nPerADV := nValADV / nBaseADV * 100
		If cTpTra == "3" .AND. cNaveg = "0"
			nAFRMM :=  nFreteP * 0.4
		ElseIf cTpTra == "3" .AND. cNaveg = "1"
			nAFRMM :=  nFreteP * 0.1
		EndIf
//		nFreteT:=nFreteP//nFreteT:=nFreteP+nAFRMM + Round((nValAdv/ (1-(nAliqICM / 100))),2)
		oFreteP:refresh()
		oFreteT:refresh()  
		IF LEN(ALLTRIM(cObsContr)) == 0
			VEROBS(cTES,nValICM,nFreteT-nValICM)
		EndIf
	Else
	   Alert("Aten็ใo... TES nใo foi digitada")   
	   If nFreteP==0
	      nFRetep:=1
	   Endif   
	   oTES:SetFocus()
	Endif        
	
	nValIcm := Round(nValIcm,2)
	
	oBaseICM:refresh()
	oAliqICM:refresh()
	oValICM:refresh()
	oBaseADV:refresh()
	oAliqADV:refresh()
//	oValADV:refresh()
	oFreteVal:refresh()
	oFreteP:refresh()
	oFreteT:refresh()
	if Type("oObsContr") != "U"
		oObsContr:refresh()
	endif
	oFolder:refresh()
EndIf

If	Len(aCalc) == 1 
	aAdd(aCalc,nFreteP)
EndIf

Return(.t.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ004  บAutor  ณMicrosiga           บ Data ณ  04/23/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGravaTudo(nPosCols,aCols,aHeader)

Local nPos,cCampo

For nPos:=1 to Len(aHeader)
	If !aHeader[nPos,8]=="xxM"  //8=Tipo
		cCampo:=aHeader[nPos,2]
		(Alias())->(&cCampo):=aCols[nPosCols,nPos]
	EndIf
Next

Return(.t.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegบAutor    ณSergio Celestino    บ Data ณ  26/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLegenda C.T.R.C                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LocfLeg

BrwLegenda(cCadastro,'Legenda',{{'BR_VERDE'   ,'Viagem sem CT-e'            },;
								{'BR_AMARELO' ,'Viagem com NF-e vinculada'  },;
								{'BR_VERMELHO','CT-e - Gerado'              } } )




Return(.T.)

//-------------------------------------------------------------------------
Static Function ValidNot()
Local nX := 0
Local lRet := .T.

For nX := 1 To Len(oDlgNot:aCols)
	If !oDlgNot:aCols[nX][Len(oDlgNot:aHeader)+1]
	
		If Empty(GdFieldGet("DTC_CLIDEV", nX , .F., oDlgNot:aHeader, oDlgNot:aCols))
			MsgAlert("Obrigatoriamente deve ser informado o c๓digo do devedor.Verifique!")
			lRet := .F.
			Exit
		EndIf
		
		If Empty(GdFieldGet("DTC_TIPNFC", nX , .F., oDlgNot:aHeader, oDlgNot:aCols))
			MsgAlert("Obrigatoriamente deve ser informado o Tipo de Nota Fiscal!")
			lRet := .F.
			Exit
		EndIf
		
		If Empty(GdFieldGet("DTC_NUMNFC", nX , .F., oDlgNot:aHeader, oDlgNot:aCols))
			MsgAlert("Obrigatoriamente deve ser informado a Nf Cliente!")
			lRet := .F.
			Exit
		EndIf 
		
		If Empty(GdFieldGet("DTC_DPROD", nX , .F., oDlgNot:aHeader, oDlgNot:aCols)) .And. Empty(DTQ->DTQ_TPCTRC)//S๓ quando for CTRC normal, e nใo complementar.
			MsgAlert("Obrigatoriamente deve ser informado a descri็ใo do Produto!")
			lRet := .F.
			Exit
		EndIf                                       
	EndIf
Next nX

Return lRet
//--------------------------------------------------------------------------------------
Static Function ValidCdpg()
Local nX := 0
Local lRet := .T.
If len(cCondPg) == 0
   MsgAlert("Obrigatoriamente deve ser informado a Condi็ใo de Pagamento. Verifique!")
   lRet := .F.
Endif                            
Return lRet
//--------------------------------------------------------------------------------------

Static Function Fnome(cOpc,cVar1,cVar2)
Local cEst		
Local lEstrang	

If cOpc == "1"
	cDesRem := Posicione("SA1",1,xFilial("SA1") + cVar1 + cVar2 , "A1_NOME" )
ElseIf  cOpc == "2"
	cDesDes := Posicione("SA1",1,xFilial("SA1") + cVar1 + cVar2 , "A1_NOME" )
ElseIf cOpc == "3"
	cDesCon := Posicione("SA1",1,xFilial("SA1") + cVar1 + cVar2 , "A1_NOME" )		
	
	If !Empty(cCFOP)	
		cEst		:=	Posicione('SA1',1,xFilial('SA1')+cCodCon+cLojCon,"A1_EST")
		lEstrang	:=	Posicione('SA1',1,xFilial('SA1')+cCodCon+cLojCon,"A1_TIPO") == 'X'

		Do Case		      
			Case cEst == GetMV("mv_estado") .And. !lEstrang
				cCFOP	:=	'5'+SubStr(cCFOP,2,3)
			Case lEstrang
				cCFOP	:=	'7'+SubStr(cCFOP,2,3)
			OtherWise
				cCFOP	:=	'6'+SubStr(cCFOP,2,3)
		EndCase
		
		oCFOP:Refresh()
	EndIf             
ElseIf cOpc == "4"
	cDesExp := Posicione("SA1",1,xFilial("SA1") + cVar1 + cVar2 , "A1_NOME" )	
ElseIf cOpc == "5"
	cDesRec := Posicione("SA1",1,xFilial("SA1") + cVar1 + cVar2 , "A1_NOME" )		
Endif

oDesRem:Refresh()
oDesDes:Refresh()
oDesCon:Refresh()
oDesRec:Refresh()
oDesExp:Refresh()
Return .T.
//-----------------------------------------------------------------------------
Static Function VerImp(cTes)

DbSelectArea("SF4")
DbSetOrder(1)
MsSeek(xFilial("SF4") + cTes )
If SF4->F4_LFICM == "T"  .or. SF4->F4_LFICM == "O" 
	lVer:=.T.
Else
	lVer:=.F.
	nBaseIcm:= 0
   nValICM := 0
   nPerICM := 0
   nAliqICM := 0
Endif  
oDlg:Refresh()
Return .T.
//-----------------------------------------------------------------------------
Static Function Regra()

nPosCodD    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_CLIDEV"})
nPosLojD    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_LOJDEV"})
nPosDev     := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_NOMDEV"})

//If      cTipo == "2" .And. cCodRem+cLojRem <> cCodCli+cLoja .And. cCodDes+cLojDes <> cCodCli+cLoja
	cCodCon := cCodCli
	cLojCon := cLoja
	cDesCon := Posicione("SA1",1,xFilial("SA1") + cCodCli + cLoja , "A1_NOME")
//ElseIf cTipo == "1" .And. cCodRem+cLojRem == cCodCli+cLoja
	//oDlgNot:aCols[oDlgNot:oBrowse:nAt][1] := cCodCli
	//oDlgNot:aCols[oDlgNot:oBrowse:nAt][2] := cLoja
	//oDlgNot:aCols[oDlgNot:oBrowse:nAt][3]  := Posicione("SA1",1,xFilial("SA1") + cCodCli + cLoja , "A1_NOME")
	
//ElseIf  cTipo == "2" .And. cCodRem+cLojRem <> cCodCli+cLoja .And. cCodDes+cLojDes == cCodCli+cLoja
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodD] := cCodCli
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojD] := cLoja
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosDev]  := Posicione("SA1",1,xFilial("SA1") + cCodCli + cLoja , "A1_NOME")
//Endif

oDlg:Refresh()

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSF4GEN  บAutor  ณSergio celestino      บ Data ณ  05/16/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta Especifica para Filtrar TES de Acordo com CFOP     บฑฑ
ฑฑบ          ณcadastrado no parametro MV_CFOTRAN                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SF4GEN()

Local cAlias := ALIAS()
Local aArea := GetArea()
Local cChave
Local nOrd := 1, cOrd:="1",lOk := .F.
Local nPosList := 0
Local oListBox, oConf, oCanc, oVisu
Local cCFOP := GetMv("MV_CFOTRAN",,"'504','505'")
Local oDlg
Local oCbx, aOrd := {"Cod TES","CFOP"}
Local oBigGet, cCampo := CriaVar("F4_CODIGO") + CriaVar("F4_CF")

Local aTes 	:= {}

Static cRetTes

cQuery := "SELECT F4_CODIGO,F4_CF,F4_TEXTO,F4_DUPLIC,F4_ESTOQUE,F4_LFICM,F4_LFIPI,F4_LFISS "
cQuery += "FROM "+RetSqlName("SF4")+" "
cQuery += "WHERE F4_CODIGO IN ("+cCFOP+") AND D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY F4_CODIGO "


Query := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

DBSelectArea("TRB")
DBGoTop()

If TRB->(Eof())
	MsgStop("Nใo existem TES.")
	TRB->(DbCloseArea())
	Return .F.
Endif

TRB->(DbGoTop())
While ! TRB->(Eof())
	
	aadd(aTES, {	TRB->F4_CODIGO           ,;
	Alltrim(TRB->F4_CF)      ,;
	Alltrim(TRB->F4_TEXTO)   ,;
	TRB->F4_DUPLIC  ,;
	TRB->F4_ESTOQUE ,;
	TRB->F4_LFICM   ,;
	TRB->F4_LFIPI   ,;
	TRB->F4_LFISS   } )
	TRB->(DbSkip())
end

TRB->(DbCloseArea())

DEFINE MSDIALOG oDlg FROM 00,00 TO 400,490 PIXEL TITLE OemToAnsi("Pesquisar")

@05,05 COMBOBOX oCBX VAR cOrd ITEMS aOrd SIZE 206,36 PIXEL OF oDlg FONT oDlg:oFont


@ 22,005 MSGET oBigGet VAR cCampo SIZE 206,10 PIXEL
@ 05,215 BUTTON oConf Prompt "Pesquisar" SIZE 30,10  FONT oDlg:oFont ACTION (oListBox:nAT := PesqTES(aTES,Alltrim(cCampo),oListBox,oCbx),; //'Pesquisar'
oListBox:bLine:={||{aTES[oListBox:nAT][1],aTES[oListBox:nAT][2],;
aTES[oListBox:nAT][3],aTES[oListBox:nAT][4],;
aTES[oListBox:nAT][5],aTES[oListBox:nAT][6],;
aTES[oListBox:nAT][7],aTES[oListBox:nAT][8]}},;
oConf:SetFocus());
OF oDlg PIXEL

oCbx:bChange := {|| nOrd := oCbx:nAt}

@ 0,0 BITMAP oBmp RESNAME "PROJETOAP" Of oDlg SIZE 100,300 NOBORDER When .F. PIXEL
oListBox := TWBrowse():New( 40,05,204,140,,{"Cod Tes","CFOP","Descri็ใo","Duplicata","Estoque","ICMS","IPI","ISS"},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox:SetArray(aTES)
oListBox:bLine := { ||{aTES[oListBox:nAT][1],aTES[oListBox:nAT][2],aTES[oListBox:nAT][3],aTES[oListBox:nAT][4],aTES[oListBox:nAT][5],;
aTES[oListBox:nAT][6],aTES[oListBox:nAT][7],aTES[oListBox:nAT][8]}}
oListBox:bLDblClick := { ||Eval(oConf:bAction), oDlg:End()}

@ 185,05 	BUTTON oConf Prompt "Confirma" 		SIZE 45 ,10   FONT oDlg:oFont ACTION (lOk:=.T.,cChave:=aTES[oListBox:nAT][1],oDlg:End())  OF oDlg PIXEL
@ 185,55 	BUTTON oCanc Prompt "Cancela"  		SIZE 45 ,10   FONT oDlg:oFont ACTION (lOk:=.F.,oDlg:End())  OF oDlg PIXEL

If nPosList > 0
	oListBox:nAT := nPosList
	oListBox:bLine := { ||{aTES[oListBox:nAT][1],aTES[oListBox:nAT][2],aTES[oListBox:nAT][3],aTES[oListBox:nAT][4],aTES[oListBox:nAT][5],;
	aTES[oListBox:nAT][6],aTES[oListBox:nAT][7],aTES[oListBox:nAT][8]}}
	oConf:SetFocus()
EndIf

ACTIVATE MSDIALOG oDlg CENTERED

//variavel utilizada no retorno sxb
cRetTES := cChave

Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRETZLG()  บAutor  ณSergio Celestino    บ Data ณ  05/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Retorno da Consulta Especifica                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RETTES()
Return(cRetTES)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPesqZLG   บAutor  ณSergio Celestino    บ Data ณ  05/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pesquisa da Consulta Especifica                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PesqTES(aTES,cCampo,oListBox,oCbx)

nPos := ASCAN(aTES, {|x| x[oCbx:nAt] == Alltrim(Upper(cCampo)) })

If nPos == 0
	Alert("Nใo encontrado")
	nPos:=1
Endif
                                              
Return nPos

Static Function VEROBS(cTES,nval1,nval2)
Local aAreaANT:= GetArea()
Local cRet:=""   
cObsContr:=""
DbSelectArea("SF4")
DbSetOrder(1)  //

If DbSeek(xFilial("SF4")+cTes)
  IF !EMPTY(F4_FORMULA)  
     cObsContr:=Formula(F4_FORMULA)
     //+"* Valor do Icms "+Transform(nval1,"@e 999,999.99")+"* Valor a pagar "+Transform(nval2,"@e 999,999.99")  
   Endif
ENDIF
//oObsContr:refresh()
RestArea(aAreaANT)
RETURN cRet                   

********************************************************************************
Static Function DTQComp()  
// Gero uma viagem complementar para emitir um CTRC complementar
********************************************************************************
Local nPos,aTabAux
Local nAreaDTQ := DTQ->(GetArea())
Local nRecDTQ  := DTQ->(Recno())
Local cCTRC1   := DTQ->DTQ_NUMCTR
Local cViagem1 := DTQ->DTQ_VIAGEM
Local cSot     := DTQ->DTQ_SOT
Local cObra    := DTQ->DTQ_OBRA
Local cTipCTRC := ""	


IF Empty(DTQ->DTQ_NUMCTR) .or. DTQ->DTQ_NUMCTR = "-"
	Alert("S๓ ้ permitido a gera็ใo de CT-e complementar" + Chr(13) + ;
		  "para documentos (CT-e) jแ gerados no sistema.")
	RestArea(nAreaDTQ)
	Return(.F.)
ElseIf !Empty(DTQ->DTQ_CTRDES)
	/*Alert("CTRC jแ possui complemento gerado na viagem " + DTQ->DTQ_CTRDES + "." + Chr(13) + ;
	      "Voc๊ s๓ pode gerar CTRC Complementar para a mesma.")
	RestArea(nAreaDTQ)
	Return(.F.)*/
EndIf 

If !Empty(DTQ->DTQ_TPCTRC) //Se diferente, ้ CTRC complementar,e nใo pode gerar complemento do complemento.
	Alert("S๓ ้ permitido a gera็ใo de CT-e complementar" + Chr(13) + ;
		  "para documentos (CT-e) ORIGEM.")
	RestArea(nAreaDTQ)
	Return(.F.)
EndIf

cTipCTRC := CriaComboBox()

If !MsgYesNo("Confirma a gera็ใo de um CT-e complementar para a viagem " + cViagem1 + " ?")
	RestArea(nAreaDTQ)
	Return(.F.)
EndIf


Begin Transaction

cViagem := GetSX8Num("DTQ", "DTQ_VIAGEM" )

If  U_DupliReg("DTQ",1,"DTQ_FILIAL+DTQ_VIAGEM",xFilial("DTQ")+cViagem1,{{"DTQ_VIAGEM",cViagem},;
                                                                        {"DTQ_PERADV",0},;
                                                                        {"DTQ_VLRINF",0},;
                                                                        {"DTQ_VALADV",0},;
                                                                        {"DTQ_DATGER",dDataBase},;
                                                                        {"DTQ_HORGER",SubStr(TIME(),1,2)+SubStr(TIME(),4,2)},;
                                                                        {"DTQ_NUMCTR",""},;
                                                                        {"DTQ_SERCTR",""},;
                                                                        {"DTQ_ENCERR","1"},;
                                                                        {"DTQ_OBSCTR","" /*Complementar ao CT-e numero " + cCTRC1 + ", viagem " + cViagem1*/ /*+ CRLF + "Uso exclusivo do emissor do CT-e."*/},;
                                                                        {"DTQ_NUMPV" ,""},;
                                                                        {"DTQ_NUMCTC",""},;
                                                                        {"DTQ_FORCTC",""},;
                                                                        {"DTQ_LOJCTC",""},;
                                                                        {"DTQ_NOMCTC",""},;
                                                                        {"DTQ_NTCLI" ,""},;
                                                                        {"DTQ_VALCAR",0},;
                                                                        {"DTQ_CONHEC",""},;
                                                                        {"DTQ_OBSCTB",""},;
                                                                        {"DTQ_OBSCOM",""},;
                                                                        {"DTQ_NUMSLD",""},;
                                                                        {"DTQ_TPCTRC",cTipCTRC},;
                                                                        {"DTQ_CTRDES",""},;
                                                                        {"DTQ_CTRORI",cViagem1}})	// Duplica o registro da tabela informada
    /*U_DupliReg("DTC",9,"DTC_FILIAL+DTC_VIAGEM",xFilial("DTC")+cViagem1,{{aDuplDTC},;            //Nao estava funcionando por causa do indice
    																	{"DTC_DOC"   ,""},;
    																	{"DTC_SERIE" ,""},;
    																	{"DTC_VIAGEM",cViagem}})*/	//Duplica o registro da tabela informada  
    				 
    GetDTCdupl(cSot,cObra,cViagem1,cViagem) //Duplica DTC

	_cChave := "DTR_FILIAL+DTR_SOT+DTR_OBRA+DTR_VIAGEM"
    U_DupliReg("DTR",7,_cChave,xFilial("DTR")+cSot+cObra+cViagem1,     {{"DTR_VIAGEM",cViagem},;
                                                                        {"DTR_INSRET",0},;
                                                                        {"DTR_VALFRE",0},;
                                                                        {"DTR_VALPDG",0},;
                                                                        {"DTR_ADIFRE",0},;
                                                                        {"DTR_SLDREC",0},;
                                                                        {"DTR_DTVENC",CtoD("//")},;
                                                                        {"DTR_IRPF",0},;
                                                                        {"DTR_INSS",0},;
                                                                        {"DTR_DATA",CtoD("//")}})	//Duplica o registro da tabela informada
	ConfirmSX8()
	RestArea(nAreaDTQ)
	DTQ->(dbGoTo(nRecDTQ))
	RecLock("DTQ", .F. )
	DTQ_CTRDES := cViagem
	MsUnLock()
	MsgInfo("CT-e complementar gerado com sucesso ! Viagem " + cViagem + " gerada.")
Else
	RollBackSX8()
	RestArea(nAreaDTQ)
	DTQ->(dbGoTo(nRecDTQ))
	MsgInfo("CT-e complementar nใo foi gerado ! ")
EndIf

RestArea(nAreaDTQ)
DTQ->(dbGoTo(nRecDTQ))

End Transaction

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPesqZLG   บAutor  ณFernando W S Furtadoบ Data ณ  02/15/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEfetua a Atualiza็ใo dos dados conforme programa็ใo diaria  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Operacional (TRANSP04-Avatar)                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function PesqZLE(cPar)
Local cRet	:=	cPar

dbSelectArea(cAliasTmp)
dbGotop()

Do Case 
	Case ValType(cPar) == "CARRETA"
	   	cRet := Posicione("ST9",1,xFilial("ST9")+(cAliasTmp)->ZLE_FROTA,"T9_PLACA")
	Case Valtype(cPar) == "CAVALO" .And. PCount() <> 2
		cRet := Posicione("ST9",1,xFilial("ST9")+(cAliasTmp)->ZLE_FROTA1,"T9_PLACA")
	OtherWise
		cRet := Space(08)
EndCase



Return cRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ004  บAutor  ณMicrosiga           บ Data ณ  12/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function ChgLinNot()


Local nPosRem  := 0, nPosCodR := 0, nPosLojR := 0 
Local nPosDes  := 0, nPosCodM := 0, nPosLojM := 0 
Local nPosCon  := 0, nPosCodC := 0, nPosLojC := 0 
Local nPosDev  := 0, nPosCodD := 0, nPosLojD := 0 
Local nPosTipF := 0, nPosCFOP := 0,	nPosValor:=	0
Local nPosCteA := 0, nPosDpcE := 0, nPosTipA := 0
Local nPosSerD := 0, nPosCtrD := 0, nPosCliD := 0
Local nPosLojD := 0, nPosNomD := 0

nPosCodR    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_CLIREM"})
nPosLojR    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_LOJREM"})
nPosRem     := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_NOMREM"})

nPosCodM    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_CLIDES"})
nPosLojM    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_LOJDES"})
nPosDes     := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_NOMDES"})

nPosCodC    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_CLICON"})
nPosLojC    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_LOJCON"})
nPosCon     := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_NOMCON"})

nPosCodD    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_CLIDEV"})
nPosLojD    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_LOJDEV"})
nPosDev     := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_NOMDEV"})

nPosTipF    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_TIPFRE"})
nPosCFOP    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_CF"})

nPosValor   := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_VALOR"}) 

nPosCteA    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_CTEANT"})
nPosDpcE    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_DPCEMI"})
nPosTipA    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_TIPANT"})
nPosSerD    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_SERDPC"})
nPosCtrD    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_CTRDPC"})

nPosCliD    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_CLIDPC"})
nPosLojD    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_LOJDPC"})
nPosNomD    := aScan(oDlgNot:aHeader,{|x| AllTrim(x[2]) == "DTC_NOMDPC"})



If Len(oDlgNot:aCols) > 1 .And. oDlgNot:oBrowse:nAt > 1

	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodR] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosCodR]
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojR] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosLojR]
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosRem]  := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosRem]

	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodM] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosCodM]
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojM] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosLojM]
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosDes]  := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosDes]

	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosTipF] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosTipF]

	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodD] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosCodD]
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojD] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosLojD]
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosDev]  := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosDev]

	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCodC] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosCodC]
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojC] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosLojC]
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCon]  := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosCon]
	
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCFOP]  := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosCFOP]
	
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCteA] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosCteA]
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosDpcE] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosDpcE]
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosTipA] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosTipA]
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosSerD] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosSerD]
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCtrD] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosCtrD]
	
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosCliD] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosCliD]
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosLojD] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosLojD]
	oDlgNot:aCols[oDlgNot:oBrowse:nAt][nPosNomD] := oDlgNot:aCols[(oDlgNot:oBrowse:nAt-1)][nPosNomD]
						
EndIf

oDlgNot:oBrowse:Refresh()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ004  บAutor  ณMicrosiga           บ Data ณ  12/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChgLinVei()
Local nPosCod  := 0, nPosNome := 0

nPosCod     := aScan(oDlgVei:aHeader,{|x| AllTrim(x[2]) == "DTR_CODMOT"})
nPosNome    := aScan(oDlgVei:aHeader,{|x| AllTrim(x[2]) == "DTR_NOMMOT"})

if oDlgVei:oBrowse:nAt > Len(oDlgVei:aCols)		// gato 3
	oDlgVei:oBrowse:nAt := Len(oDlgVei:aCols)
endif											// des gato

If Len(oDlgVei:aCols) > 1 .And. oDlgVei:oBrowse:nAt > 1
	oDlgVei:aCols[oDlgVei:oBrowse:nAt][nPosCod] 	:= oDlgVei:aCols[(oDlgVei:oBrowse:nAt-1)][nPosCod]
	oDlgVei:aCols[oDlgVei:oBrowse:nAt][nPosNome] 	:= oDlgVei:aCols[(oDlgVei:oBrowse:nAt-1)][nPosNome]
EndIf

oDlgVei:oBrowse:Refresh()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ004  บAutor  ณMicrosiga           บ Data ณ  12/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VldLinNot()
Local lRet
Local cNFeId	:=	GDFieldGet("DTC_NFEID" ,oDlgNot:oBrowse:nAt,.F.,oDlgNot:aHeader,oDlgNot:aCols)
Local cSerie	:=	GDFieldGet("DTC_SERNFC",oDlgNot:oBrowse:nAt,.F.,oDlgNot:aHeader,oDlgNot:aCols)
Local cNumDoc	:=	GDFieldGet("DTC_NUMNFC",oDlgNot:oBrowse:nAt,.F.,oDlgNot:aHeader,oDlgNot:aCols)
Local dEmissao	:=	GDFieldGet("DTC_EMINFC",oDlgNot:oBrowse:nAt,.F.,oDlgNot:aHeader,oDlgNot:aCols)
Local nBasIcm	:=	GDFieldGet("DTC_BASICM",oDlgNot:oBrowse:nAt,.F.,oDlgNot:aHeader,oDlgNot:aCols)
Local nValIcm	:=	GDFieldGet("DTC_VALICM",oDlgNot:oBrowse:nAt,.F.,oDlgNot:aHeader,oDlgNot:aCols)
Local nBasSt	:=	GDFieldGet("DTC_BASESU",oDlgNot:oBrowse:nAt,.F.,oDlgNot:aHeader,oDlgNot:aCols)
Local nValSt	:=	GDFieldGet("DTC_VALIST",oDlgNot:oBrowse:nAt,.F.,oDlgNot:aHeader,oDlgNot:aCols)
Local nValor	:=	GDFieldGet("DTC_VALOR" ,oDlgNot:oBrowse:nAt,.F.,oDlgNot:aHeader,oDlgNot:aCols)






If !Empty(cNFeId)
	lRet := .T.
Else
	If	!Empty(cSerie) .And. !Empty(cNumDoc) .And. !Empty(dEmissao) .And. !Empty(nBasIcm) .And. !Empty(nValIcm) .And. !Empty(nValor)
		lRet	:=	.T.
	Else
		Aviso("Alerta","Campos referente a Nota fiscal do cliente nใo preenchidos, Favor preencher!",{"OK"})
		lRet := .F.
	EndIf
	
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ004  บAutor  ณMicrosiga           บ Data ณ  01/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtuNfInfo()
Local cCampo	:=	Replace(Replace(ReadVar(),'M->',''),'DTC->','')
Local nAt		:=	oDlgNot:oBrowse:nAt

	If cCampo == 'DTC_VALOR'

	// ---- Atualiza BaseAdv ---- //
	
		nBaseADV	:=	&(ReadVar()) // Retorna o Valor Informado no Campo
	                                                                  
		//Recupera a Informa็ใo das outras Linhas e incrementa o valor da BaseAdv
		aEval(oDlgNot:aCols,{|x,nLin| If( nAt == nLin,,nBaseADV += GDFieldGet("DTC_VALOR" ,nLin,.F.,oDlgNot:aHeader,oDlgNot:aCols) ) })
		
		//Atualiza objeto na Tela
		oBaseADV:Refresh()
		
	// ---- Fim ---- //

	EndIf
	
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ004  บAutor  ณMicrosiga           บ Data ณ  01/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuVeiInf()
Local cCampo	:=	Replace(Replace(ReadVar(),'M->',''),'DTR->','')
Local cCodigo	
Local cNome		
	
	If cCampo	==	"DTR_CODMOT"
		
		cCodigo	:=	&(ReadVar())
		cNome	:=	Posicione("DA4",1,xFilial("DA4")+cCodigo,"DA4_NOME")
		
		aEval(oDlgVei:aCols,{|x,nLin| GDFieldPut("DTR_CODMOT" ,cCodigo ,nLin,oDlgVei:aHeader,oDlgVei:aCols,.F.), GDFieldPut("DTR_NOMMOT" ,cNome ,nLin,oDlgVei:aHeader,oDlgVei:aCols,.F.)})
		oDlgVei:oBrowse:Refresh()  
		
	EndIf
	
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑบPrograma  ณ004  บAutor  ณMicrosiga           บ Data ณ  01/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldTes()
Local lRet 		:=  (ExistCpo("SF4",cTES) .And. !Empty(cTES) .And. Val(cTES) >= 500 .And. VerImp(cTES))
Local cEst		
Local lEstrang	

	If lRet
		cCFOP		:=	Posicione('SF4',1,xFilial('SF4')+cTES,'F4_CF')		
		//cEst		:=	Posicione('SA1',1,xFilial('SA1')+cCodCon+cLojCon,"A1_EST")
		//lEstrang	:=	Posicione('SA1',1,xFilial('SA1')+cCodCon+cLojCon,"A1_TIPO") == 'X'
		cEst		:=	Posicione('SA1',1,xFilial('SA1')+cCodDes+cLojDes,"A1_EST")
		lEstrang	:=	Posicione('SA1',1,xFilial('SA1')+cCodDes+cLojDes,"A1_TIPO") == 'X'
		
		If cTpTra == "3"
			cCFOP2		:=	Posicione('SF4',1,xFilial('SF4')+cTES2,'F4_CF')
		
			Do Case		      
				Case cEst == GetMV("MV_ESTADO") .And. !lEstrang
					cCFOP2	:=	'5'+SubStr(cCFOP2,2,3)
				Case lEstrang
					cCFOP2	:=	'7'+SubStr(cCFOP2,2,3)
				OtherWise
					cCFOP2	:=	'6'+SubStr(cCFOP2,2,3)
			EndCase
		
			oCFOP2:Refresh()
			
		End

		Do Case		      
			Case cEst == GetMV("MV_ESTADO") .And. !lEstrang
				cCFOP	:=	'5'+SubStr(cCFOP,2,3)
			Case lEstrang
				cCFOP	:=	'7'+SubStr(cCFOP,2,3)
			OtherWise
				cCFOP	:=	'6'+SubStr(cCFOP,2,3)
		EndCase

		if Type("oCFOP") != "U"
			oCFOP:Refresh()
		endif

	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ004  บAutor  ณRenato Ruy Bernardo บ Data ณ  25/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldFrota()
Local cRetorno := .T.
Local cVeiculo := ""
Local cMotoris := ""
Local nSoma := 0
Local nCont := 0		
    //Verifica cadastro da frota/veiculo.
	For _nPos := 1 To Len(oDlgVei:aCols) 	
		If !oDlgVei:aCols[_nPos][Len(oDlgVei:aHeader)+1]
			cVeiculo:= oDlgVei:aCols[_nPos][Ascan(oDlgVei:aHeader,{|x|AllTrim(x[2])=="DTR_CODVEI"})]
			cMotoris:= oDlgVei:aCols[_nPos][Ascan(oDlgVei:aHeader,{|x|AllTrim(x[2])=="DTR_CODMOT"})]  
			DbSelectArea("DA3")
			DbSetOrder(1)
			If DbSeek( xFilial("DA3") + cVeiculo )
			
				If !Empty(DA3->DA3_RENAVA)
					If Len(DA3->DA3_RENAVA) < 9
				   		Alert("C๓digo do Renavam Invแlido da Frota: " + cVeiculo)
				   		cRetorno := .F.
					EndIf
				Else
					MsgInfo("Cadastre o Renavam do Veiculo: " + cVeiculo)
					cRetorno := .F.
				EndIf
				
				If Empty(DA3->DA3_TIPTRA)
					MsgInfo("Cadastre o tipo de transporte do Veiculo: " + cVeiculo)
					cRetorno := .F.
				End
			Else
			MsgInfo("Verifique a Frota digitada: " + cVeiculo)
			cRetorno := .F.
			
			EndIf
			
			//Verifica cadastro do motorista, se o tipo nใo for maritimo
			If DTQ->DTQ_TPAS != "M"
			DbSelectArea("DA4")
			DbSetOrder(1)
			If DbSeek( xFilial("DA4") + cMotoris ) 
			
				If Empty(DA4->DA4_FORNEC)
					Alert("Codigo do fornecedor nใo amarrado no cadastro do motorista")
			   		cRetorno := .F.
				EndIf
			
				If DA4->DA4_TIPMOT == "2" .And. cRetorno//Valida se o motorista e terceiro .and. existe cadastro
				
					DbSelectArea("SA2")
					DbSetOrder(1)
					If DbSeek( xFilial("SA2") + DA4->DA4_FORNEC )
					
						If SA2->A2_MSBLQL == "1"
							Alert("C๓digo do fornecedor estแ bloqueado, por favor verifique: " + DA4->DA4_FORNEC)
							cRetorno := .F.	
						ElseIf Empty(SA2->A2_RNTRC)
							Alert("O Fornecedor ้ terceiro e nใo tem cadastro Registro Nacional de Transportadores Rodoviแrios de Cargas Preenchido: " + DA4->DA4_FORNEC)
							cRetorno := .F.	
						EndIf	
					
					Else
						Alert("Verifique o Fornecedor Cadastrado no Motorista, Codigo Nใo Existe")
						cRetorno := .F.
					EndIf
				
				EndIf
			
			Else
			MsgInfo("Motorista nใo tem cadastro na filial: " + cMotoris)
			EndIf
			EndIf 
		EndIf
	Next
Return cRetorno

//Criar pergunta com o Tipo de complemento(Valor ou ICMS)
Static Function CriaComboBox()
	Local aCombo 	:= {} 
	Local cCombo	:= ""
	Local nResult  	:= Space(01)
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	If DbSeek("DTQ_TPCTRC")
		cCombo := X3CBOX()	
	EndIf 
	
	aCombo := StrTokArr(cCombo,";")
    
	DEFINE MSDIALOG oDlgUser TITLE "Complementar" FROM 000,000 TO 150,300 PIXEL OF oMainWnd
	                    
	@ 025,020 SAY "Selecione a Op็ใo:" OF oDlgUser PIXEL
	//@ 025,025 SAY "Selecione a Op็ใo:" SIZE 200,15 OF oDlgUser		
	@ 035,020 COMBOBOX oCombo1 VAR nResult ITEMS aCombo SIZE 80,010 OF oDlgUser PIXEL 
	@ 035,105 BUTTON "Confirmar" SIZE 35,14 PIXEL OF oDlgUser Action (oDlgUser:end())
		
	//@ C(041),C(071) Button "Cancelar" Size C(037),C(012) PIXEL OF _oDlg Action (_oDlg:end())	 
	//oCombo1:bChange := {|| SelectCombo(cResult) }
			
	ACTIVATE MSDIALOG oDlgUser CENTERED
	 
Return(nResult)

//Alison 07/11/13
Static Function GetDTCdupl(cSot,cObra,cViagem1,cViagem)
    Local aArea		:= GetArea()
    Local aAreaDTC
    Local aDTC		:= {}
      
	DbSelectArea("DTC")
	DbOrderNickName("DTCIND10")
	DbSeek(xFilial("DTC") + cSot + cObra + cViagem1 )
	While !DTC->(Eof()) .And. DTC->(DTC_FILIAL+DTC_SOT+DTC_OBRA+DTC_VIAGEM) == xFilial("DTC")+ cSot + cObra + cViagem1
	
		For nX := 1 To DTC->(FCount())		// Armazeno os dados para duplicar o registro
			Aadd(aDTC, DTC->(FieldGet(nX)))
		Next nX  
		
		aAreaDTC	:= DTC->(GetArea())																		
		RecLock("DTC",.T.)
		For nX := 1 To DTC->(FCount())
			DTC->(FieldPut(nX, aDTC[nX]))
		Next nX
		DTC->DTC_DOC 	:= ""
		DTC->DTC_SERIE	:= ""
		DTC->DTC_VIAGEM := cViagem
		MsUnlock()
		RestArea(aAreaDTC)
			
		DTC->(DbSkip())
	EndDo
	
	
	RestArea(aArea)
Return


//------------------------------------ Parte do Calculo dos Impostos do Frete
Static Function AddValor()
Local aRetorno

	aRetorno  := fCalcImposto( { { 1, nFretePAux } } )
	nImpFrete := aRetorno[1] - nFretePAux//aRetorno[2]
	nFreteP   := nFretePAux + nImpFrete//aRetorno[2]			// Frete Peso

	aRetorno  := fCalcImposto( { { 1, (nBaseADV * nAliqAdv / 100) } } )
	nImpADV   := aRetorno[1] - (nBaseADV * nAliqAdv / 100)
	nFreteVal := aRetorno[1]//nImpADV + aRetorno[2]				// Frete Valor

	aRetorno  := fCalcImposto( { { 1, nValPedag } } )
	nImpPeda  := aRetorno[1] - nValPedag //aRetorno[2]						// Imposto Pedagio

	aRetorno  := fCalcImposto( { { 1, nValOutr } } )
	nImpOutr  := aRetorno[1] - nValOutr//aRetorno[2]						// Imposto Outros

	nADVal    := nBaseADV * nAliqADV / 100

Return nil


//-------------------------------
Static Function EstornaPS()

Local aArea		:= GetArea()
Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSC6	:= SC6->(GetArea())
Local aAreaSC9	:= SC9->(GetArea())
      
Private	lLiber  := .F.
Private	lTransf := .F.
Private	lLiberOk:= .F.
Private	lResidOk:= .F.
Private	lFaturOk:= .F.
Private	nVlrCred:= 0
Private	nMoedaOri:=1 
Private lMsErroAuto := .F.    

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Estorna pedidos de venda.                                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectArea("SC5")
	DbSetOrder(1)
	DbSeek(xFilial("SC5")+DTQ->DTQ_NUMPV)
	While !Eof() .And. SC5->C5_FILIAL == xFilial("SC5") .And. SC5->C5_NUM == DTQ->DTQ_NUMPV
	
		aCabPv  := {}
		aItemPV := {}
		aItemSC6:= {}
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Carrega informacoes do cabecalho do pedido de venda.		  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		SX3->( DbSetOrder(1) )
		SX3->( DbSeek("SC5") )
		While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == "SC5"
			IF X3USO(SX3->X3_USADO) .And. cNivel>=SX3->X3_NIVEL .And. SX3->X3_CONTEXT != "V"
				Aadd(aCabPv,{SX3->X3_CAMPO,&(SX3->X3_CAMPO),NIL})
			EndIF
			SX3->(DbSkip())
		EndDo
	
		DbSelectArea("SC6")
		DbSetOrder(1)
		MsSeek(xFilial("SC6")+DTQ->DTQ_NUMPV)
		While !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == DTQ->DTQ_NUMPV
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Carrega informacoes dos itens do pedido.    				  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			SX3->( DbSetOrder(1) )
			SX3->( DbSeek("SC6") )
			While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == "SC6"
				IF X3USO(SX3->X3_USADO) .And. cNivel>=SX3->X3_NIVEL .And. SX3->X3_CONTEXT != "V"
					Aadd(aItemSC6,{SX3->X3_CAMPO,&(SX3->X3_CAMPO),NIL})
				EndIF
				SX3->(DbSkip())
			EndDo
		
			IF Len(aItemSC6) > 0
				Aadd(aItemPV,aClone(aItemSC6))
			EndIF
			aItemSC6 := {}
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Estorna item do pedido de venda.                     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			dbSelectArea("SC9")
			dbSetOrder(1)
			If MsSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
				MaAvalSC6("SC6",2,"SC5",lLiber,lTransf,@lLiberOk,@lResidOk,@lFaturOk,Nil,@nVlrCred,Nil,Nil,nMoedaOri)
			Endif
		
			DbSelectArea("SC6")
			DbSkip()
		
	    EndDo
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Exclui pedido de venda.                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF Len(aCabPv) > 0 .And. Len(aItemPV) > 0
			MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,{aItemPV},5)
		EndIF
	
		If lMsErroAuto
			// Cria o diretorio erros, caso ele nao exista
			MakeDir("\Erros\")
	
			// Grava o erro gerado na pasta erros
			MostraErro("\Erros\", "015.LOG")
	   	
			RollBackSX8()
		Else
	   		ConfirmSX8()
	   		MsgInfo("Pedido excluido com sucesso","Exclusใo!")
            DbSelectArea("DTQ")
      		Reclock("DTQ",.F.)
		     	DTQ->DTQ_NUMCTR := ""
		     	DTQ->DTQ_NUMPV  := ""  
		     
		    	MsUnlock()      

	    Endif
	
	DbSelectArea("SC5")
	DbSkip()
	
EndDo
              
	RestArea(aAreaSC9)
	RestArea(aAreaSC6)
	RestArea(aAreaSC5)
	RestArea(aArea)
Return

Static Function GetDTR()
	Local aArea		:= GetArea()
	Local aAreaZAE	:= ZAE->(GetArea())            
	Local aAreaDTR	:= DTR->(GetArea())           
	         
	Local cFrota  := ""
	Local cPlaca  := ""
	Local cCodMot := Posicione("ZLE",6,xFilial("ZLE")+DTQ->(DTQ_SOT+DTQ_OBRA+DTQ_VIAGEM),"ZLE_CODMOT")
	Local cNomMot := Posicione("DA4",1,xFilial("DA4")+cCodMot,"DA4_NOME")
	Local nSeq	  := 1
	Local aRet	  := {}		
	
	DbSelectArea("DTR")
	DbSetOrder(1)
	If DbSeek(xFilial("DTR")+DTQ->(DTQ_FILORI+DTQ_VIAGEM))
		While !DTR->(Eof()) .And. DTR->(DTR_FILIAL+DTR_FILORI+DTR_VIAGEM) == xFilial("DTR")+DTQ->(DTQ_FILORI+DTQ_VIAGEM)
	      If nSeq >= 3
	      
	      EndIf
	   	cNomFro := Posicione("DA3",1,xFilial("DA3")+DTR->DTR_CODVEI,"DA3_DESC")
	   	cNomMot := Posicione("DA4",1,xFilial("DA4")+DTR->DTR_CODMOT,"DA4_NOME")
		
			aAdd(aRet, {StrZero(nSeq,2), DTR->DTR_TCIOT ,DTR->DTR_CODVEI, cNomFro, DTR->DTR_CODMOT, cNomMot, .F.})    
		
			If !Empty(DTR->DTR_CODRB1)
				nSeq++                                                              
				cNomFro := Posicione("DA3",1,xFilial("DA3")+DTR->DTR_CODRB1,"DA3_DESC")
				aAdd(aRet, {StrZero(nSeq,2), DTR->DTR_TCIOT ,DTR->DTR_CODRB1, cNomFro, DTR->DTR_CODMOT, cNomMot, ,.F.}) 
			EndIf
		   
		   nSeq++  
			DTR->(DbSkip())
		EndDo
	Else                    
		DbSelectArea("ZAE")
		DbSetOrder(1)
		DbSeek(xFilial("ZAE")+DTQ->(DTQ_SOT+DTQ_OBRA))
		While !ZAE->(Eof()) .And. ZAE->(ZAE_FILIAL+ZAE_PROJET+ZAE_OBRA) == xFilial("ZAE")+DTQ->(DTQ_SOT+DTQ_OBRA)
		   
		   cFrota  := ZAE->ZAE_TRANSP
		cNomFro := Posicione("DUT",1,xFilial("DUT")+cFrota,"DUT_DESCRI")			
		 	
		   aAdd(aRet, {StrZero(nSeq,2),"",cFrota, cNomFro, cCodMot, cNomMot, .F.})  
		   
		   nSeq++
			ZAE->(DbSkip())
		EndDo              
	
	EndIf
	
	RestArea(aAreaDTR)
	RestArea(aAreaZAE)        
	RestArea(aArea)
Return(aRet)

Static Function fNomCid(cOpc,cUf,cCod)
   
	If cOpc == "1" //Origem
		cOri		:= Posicione("CC2",1,xFilial("CC2")+cUf+cCod,"CC2_MUN")
		//cOriUf	:= Iif(Empty(cUf), Posicione("CC2",3,xFilial("CC2")+cCod,"CC2_EST"), Posicione("CC2",1,xFilial("CC2")+cUf+cCod,"CC2_EST"))
	ElseIf cOpc == "2" //Destino
		cDes		:= Posicione("CC2",1,xFilial("CC2")+cUf+cCod,"CC2_MUN")     
		//cDesUf	:= Iif(Empty(cUf), Posicione("CC2",3,xFilial("CC2")+cCod,"CC2_EST"), Posicione("CC2",1,xFilial("CC2")+cUf+cCod,"CC2_EST"))   
	EndIf
	
	
	oOri:Refresh()   
	oOriUf:Refresh() 
	oDes:Refresh()              
	oDesUf:Refresh()
Return(.T.)

Static Function GetCodIbge(cOpc)
	Local cCodigo := ""
	Local cRet := ""           

	If cOpc == "1"
		cCodigo := Posicione("ZA6",2,xFilial("ZA6")+DTQ->(DTQ_AS+DTQ_VIAGEM),"ZA6_ORIGEM")
	ElseIf cOpc == "2"
		cCodigo := Posicione("ZA6",2,xFilial("ZA6")+DTQ->(DTQ_AS+DTQ_VIAGEM),"ZA6_DESTIN")
	EndIf
	
	cRet := Posicione("ZA2",1,xFilial("ZA2")+cCodigo,"ZA2_CODMUN")
	
Return(cRet)

Static Function fSumTot()
	
	nFreteT:= nFreteP//nFreteP + Round((nValAdv/ (1-(nAliqICM / 100))),2)
	nBaseIcm:= nFreteP//nBaseIcm:= Round((nFreteP + Round((nValAdv / (1-(nAliqICM / 100))),2)),2)

	if cOriUF == "PR"	// nao incidir Valor do Pedagio na Base do ICMS no estado do Parana - Cristiam Rossi em 18/08/2015
 		nBaseIcm -= nValPedag
	endif

	nValICM := nBaseICM * (nAliqICM/100)
	oFreteP:refresh()
	oFreteT:refresh() 
	oBaseIcm:Refresh()          
	oValIcm:Refresh()          

Return(.T.)


//-------------------------- retorna o cliente da tabela ZA7
User Function LCT004BRW()
Local cRet
	cRet := POSICIONE("ZA7",2,XFILIAL("ZA7")+DTQ->(DTQ_SOT+DTQ_OBRA+DTQ_VIAGEM),"ZA7_DESCLI")
	
	if Empty( cRet )
		cRet := Posicione("SA1",1,xFilial("SA1")+ZA7->ZA7_CODCLI+ZA7->ZA7_LOJCLI, "A1_NOME")
	endif

Return cRet


//-------------------------------------
Static Function fCalcImposto( aItens )		// { qtde, valor }
Local nI
Local aArea     := getArea()
Local aAreaDTC  := DTC->( getArea() )
Local aRet      := { 0, 0, 0}
Local _CTRCProd := getMV("MV_CTRCPRO")

Local lRndSOB   := getMV("MV_RNDSOBR")
Local lRndICM   := getMV("MV_RNDICM")

	PutMV("MV_RNDSOBR", .F.)
	PutMV("MV_RNDICM", .F.)


	DTC->( dbSetOrder(11) )
	DTC->( dbSeek( xFilial("DTC") + DTQ->DTQ_VIAGEM ) )

	MaFisSave()

	MaFisEnd()
	MaFisIni( DTC->DTC_CLIDEV, DTC->DTC_LOJDEV, "C", "N" /*tipo da NF*/, Posicione("SA1",1,xFilial("SA1")+DTC->DTC_CLIDEV+DTC->DTC_LOJDEV,"A1_TIPO"),nil,nil,nil,nil,"MATA461")

	for nI := 1 to len( aItens )
		MaFisAdd( _CTRCProd, cTes, aItens[nI][1] /*quantidade*/, aItens[nI][2], 0, "", "", 0, 0, 0, 0, 0, aItens[nI][2] * aItens[nI][1], 0 )
	next

	aRet[1] := MaFisRet(, "NF_TOTAL"   )
	aRet[2] := MaFisRet(, "NF_VALICM"  )
	aRet[3] := MaFisRet(, "NF_BASEICM" )

	MaFisEnd()
	MaFisRestore()

	PutMV("MV_RNDSOBR", lRndSOB)
	PutMV("MV_RNDICM", lRndICM)

	DTC->( restArea( aAreaDTC ) )
	restArea( aArea )

Return aClone( aRet )
