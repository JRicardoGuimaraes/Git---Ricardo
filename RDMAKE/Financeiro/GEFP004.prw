#include "rwmake.ch"
#include "topconn.ch"
/************************************************************************
* Programa.....: GEFP004()                                              *
* Autor........: Marcelo Aguiar Pimentel                                *
* Data.........: 27/03/2007                                             *
* Descricao....: Carrega dados iniciais para o relatório Recapitulatif  *
*                par client consolide groupe na tabels SZK              *
*                                                                       *
************************************************************************/

User Function GEFP004()

Processa({|| ProcG004() },"Processando...")
Return

/*************************************************************
* Funcao......: ProcG004()                                   *
* Autor.......: Marcelo Aguiar Pimentel                      *
* Data........: 27/03/2007                                   *
* Descricao...: Faz o processamento da rotina                *
*************************************************************/
Static Function ProcG004()
Local cQry		:=	""
Local lInclui	:=	.f.
Local nQuant	:=	0
Local cCahve	:= ""

dbSelectArea("SZK")
dbSetOrder(1) //ZK_FILIAL+ZK_XGRPCLI+ZK_MOEDA+ZK_ANO+ZK_Mes
dbSelectArea("SE1")
cQry := "SELECT DISTINCT A1_XGRPCLI,E1_MOEDA,A1_COD, A1_LOJA, A1_NOME, A1_EMAIL, A1_NREDUZ, E1_NUM, E1_PREFIXO,E1_TIPO, E1_EMIS1, "
cQry += "                E1_REFGEF, E1_INVOICE, E1_VALOR, E1_SALDO, E1_MOEDA, E1_TXMOEDA, E1_VLCRUZ, E1_EMISSAO, E1_VENCREA, "
cQry += "                E1_CLIENTE, E1_LOJA , E1_DTVARIA, E1_EMIS1,E1_FILIAL"
cQry += "  FROM " + RetSqlName("SA1") + " SA1, " + RetSqlName("SE1") + " SE1  "
cQry += " WHERE SA1.D_E_L_E_T_ <> '*'"
cQry += "   AND SE1.D_E_L_E_T_ <> '*'"
cQry += "   AND E1_CLIENTE = A1_COD"
cQry += "   AND E1_LOJA = A1_LOJA"
//cQry += "   AND E1_MOEDA = '"+allTrim(str(MV_PAR07))+"'"
cQry += "   AND E1_INVOICE <> ' '"
cQry += "   AND E1_FILIAL >= '  ' AND E1_FILIAL <= 'ZZ'"
cQry += "   AND E1_EMIS1 >= '20060801' AND E1_EMIS1 <= '20070228'"
//cQry += "   AND A1_XGRPCLI >= '" + MV_PAR08 +"' AND A1_XGRPCLI <= '" +  MV_PAR09 + "' "
cQry += "  AND EXISTS (SELECT ZJ_XGRPCLI FROM "+RetSqlName("SZJ")+" SZJ WHERE ZJ_XGRPCLI = A1_XGRPCLI AND SZJ.D_E_L_E_T_ <> '*')"
cQry += " ORDER BY A1_XGRPCLI, E1_MOEDA, E1_EMIS1, E1_INVOICE, E1_CLIENTE, E1_LOJA " 
TcQuery cQry Alias "TSE1" New
ProcRegua(1200)
While !Eof()
	IncProc()
	lInclui:=.f.
	nValor:=TSE1->E1_VALOR
   	If TSE1->E1_TIPO == "NCC"
		nValor*=(-1)
   	EndIF

	dbSelectArea("SZK")
	cChave:=xFilial("SZK")+TSE1->A1_XGRPCLI+ALLTRIM(STR(TSE1->E1_MOEDA))+;
			alltrim(str(year(stod(TSE1->E1_EMIS1))))+strzero(month(stod(TSE1->E1_EMIS1)),2)

	cQry:="SELECT * FROM "+RetSqlName("SZK")
	cQry+=" WHERE ZK_FILIAL = '"+xFilial("SZK")+"'"
	cQry+="   AND ZK_XGRPCLI = '"+TSE1->A1_XGRPCLI+"'"
	cQry+="   AND ZK_MOEDA = '"+ALLTRIM(STR(TSE1->E1_MOEDA))+"'"
	cQry+="   AND ZK_ANO = '"+alltrim(str(year(stod(TSE1->E1_EMIS1))))+"'"
	cQry+="   AND ZK_MES = '"+strzero(month(stod(TSE1->E1_EMIS1)),2)+"'"
	cQry+="   AND D_E_L_E_T_ <> '*'	"
	TcQuery cQry Alias "TSZK" New
	nMont:=0
	lInclui:=.t.
	If !Eof()
		lInclui:=.f.
		nMont:=TSZK->ZK_MONT+nValor
	EndIf
	dbCloseArea()
	If lInclui
		RecLock("SZK",lInclui)
			SZK->ZK_FILIAL	:=	xFilial("SZK")//TSE1->E1_FILIAL
			SZK->ZK_XGRPCLI	:=	TSE1->A1_XGRPCLI
			SZK->ZK_MOEDA	:=	TSE1->E1_MOEDA
			SZK->ZK_ANO		:=	alltrim(str(year(stod(TSE1->E1_EMIS1))))
			SZK->ZK_MES		:=	strzero(month(stod(TSE1->E1_EMIS1)),2)
			SZK->ZK_SOLDE	:=	0
			SZK->ZK_MONT		+=	nValor
		MsUnLock()
	Else
		cQry:="UPDATE "+RetSqlName("SZK")
		cQry+="   SET ZK_MONT   = '"+ALLTRIM(STR(nMont))+"'"
		cQry+=" WHERE ZK_FILIAL = '"+xFilial("SZK")+"'"
		cQry+="   AND ZK_XGRPCLI = '"+TSE1->A1_XGRPCLI+"'"
		cQry+="   AND ZK_MOEDA = '"+ALLTRIM(STR(TSE1->E1_MOEDA))+"'"
		cQry+="   AND ZK_ANO = '"+alltrim(str(year(stod(TSE1->E1_EMIS1))))+"'"
		cQry+="   AND ZK_MES = '"+strzero(month(stod(TSE1->E1_EMIS1)),2)+"'"
		cQry+="   AND D_E_L_E_T_ <> '*'	"
		TcSQLExec(cQry)
		TcSQLExec("COMMIT")
	EndIf
	dbSelectArea("TSE1")
	dbSkip()
EndDo
dbSelectArea("TSE1")
dbCloseArea()
Return