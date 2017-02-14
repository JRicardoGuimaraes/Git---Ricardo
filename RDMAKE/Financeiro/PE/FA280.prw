#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA280     บ Autor ณ Saulo Muniz        บ Data ณ  18/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Destinado a gravacao de dados complementares (especifico   บฑฑ
ฑฑบ          ณ Gefco) na rotina de substituicao Fatura Receber            บฑฑ
ฑฑบ          ณ ( FINA280 )                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7 - Financeiro / Ctas Receber / Faturas Receber (FINA280)บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบAlteracao ณ 19/07/2006 - Marcos Furtado                                ผฑฑ
ฑฑบ          ณ Altera็ใo para contemplar o centro de custo                บฑฑ
ฑฑบ          ณ e verificar se o usuแrio pode executar a rotina.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบAlteracao ณ 28/09/2006 - Marcos Furtado                                ผฑฑ
ฑฑบ          ณ Altera็ใo para informar a referencia Gefco.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบAlteracao ณ 20/05/2008 - J Ricardo de Guimaraes                        ผฑฑ
ฑฑบ          ณ Inclusใo da moeda 5 (GBP - Libra Esterlina).               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบAlteracao ณ 11/08/2008 - J Ricardo de Guimaraes                        ผฑฑ
ฑฑบ          ณ Tratamento por prefixo(FAT/INV) diferencia os tipos de     บฑฑ
ฑฑบ          ณ moeda e os usuแrios que possue acesso a rotina             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

// Verifivar qual c.custo deve ser informado na fatura ?
//Ja resolvido, serแ digitado. - Marcos Furtado - 19/07/2006

User Function FA280

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//  
Local aArea := GetArea()
Private dDataInv := dDataBase
Private cCusto   := Space(TamSX3("CTT_CUSTO")[1])
Private nDolar   := 0.00
Private nMoeda	 := "Dolar"
Private cInv     := Space(15) //Invoice
Private cRefGef  := Space(20) //Referencia Gefco
Private nVlrM2   := 0.00
Private oDlg            
// Private aMoeda   := {"Dolar","Euro"}     
Private aMoeda   := {"Dolar","Euro","GBP-Libra Esterlina"}
Private _aTipoCar:= {"EME-Emergencial","CD - Coleta Direta","MR - Milkrun"}
Private _cTipoCar:= Space(TamSX3("E1_TPCAR")[1])
Private _cNumCVA := Space(TamSX3("E1_NUMCVA")[1])
Private _cCOLMON := Space(TamSX3("E1_COLMON")[1])

Private  _cCliMAN  := AllTrim(GETNewPar("MV_XCLIMAN","04858701|"))

If cCli + cLoja $ _cCliMAN
	// _cNumCVA := cGetNumCVA
	_cNumCVA := GETMV("MV_XNUMCVA")
EndIf	

// Por: Ricardo - Em: 21/05/2008
// Private cCustoFat := GetMv("MV_XCCFAT") //Centro de Custo para faturas


/*_mOldArea	:=	Alias()
_mOldInde	:=	IndexOrd()
_mOldRecn	:=	Recno()*/

// Parโmetro retirado devido os usuแrios ter passado a ter direitos a fazer invoice, conforme dito pela Adriana Rodrigues
// Por: Ricardo - 17/07/2009
// If __CUSERID $ GetMv("MV_XUSERM2") .AND. AllTrim(CPREFIX) $ GETMV("MV_XPREFM2")
If AllTrim(CPREFIX) $ GETMV("MV_XPREFM2")
	dDataInv := SE1->E1_EMISSAO
	// Tela de Informa็ใo de valores/convert
	@ 000,000 To 290,360 Dialog oDlg Title "Faturas Gefco"// - Dolar"
//	@ 010,003 To 042,350 Title OemToAnsi("Pesquisa")	
	@ 010,003 To 140,180 
	@ 015,010 Say "Data de Emissao"
	@ 015,070 Say ":"
	@ 015,080 Get  dDataInv  Valid(NaoVazio()) Size 35,10 
	@ 030,010 Say "Centro de Custo"
	@ 030,070 Say ":"
	@ 030,080 Get  cCusto Valid (existcpo("CTT") .And. CTT->CTT_BLOQ <> "1" .And. NaoVazio()) F3 "CTT"  Size 66,10 

	@ 045,010 Say "Moeda"
	@ 045,070 Say ":"
//	@ 045,080 Get  nMoeda Picture "@E 99.99999" Valid(U_CalcVlrM2())Size 33,10 
	@ 045,080 ComboBox nMoeda Items aMoeda Size 072,010

	@ 060,010 Say "Taxa da Moeda"
	@ 060,070 Say ":"
	@ 060,080 Get  nDolar Picture "@E 99.99999" Valid(U_CalcVlrM2())Size 33,10 
	
	@ 075,010 Say "Valor (ME)"
	@ 075,070 Say ":"
	@ 075,080 Get  nVlrM2 Picture "@E 999,999,999.99" When .F.  Size 66,30 Object OvlrM2

	@ 090,010 Say "Invoice"
	@ 090,070 Say ":"
	@ 090,080 Get  cInv Valid NaoVazio() Picture "@!" Size 66,30 

	@ 105,010 Say "Referencia"
	@ 105,070 Say ":"
	@ 105,080 Get  cRefGef Valid NaoVazio() Picture "@!" Size 66,30 

/*	@ 060,080 BmpButton Type 1 Action (FConfirma())
	@ 060,080 BmpButton Type 2 Action Close(oDlg)	*/
	@ 130,110 BmpButton Type 01 Action (fConfirma())
	@ 130,150 BmpButton Type 02 Action (oDlg:End())
	
	Activate Dialog oDlg Centered

Else
	// Por: Ricardo - Em: 21/05/2008

	// Tela de Informa็ใo de valores/convert
	@ 000,000 To 290,360 Dialog oDlg Title "Faturas Gefco"// - Dolar"
	@ 010,003 To 140,180 
	@ 030,010 Say "Centro de Custo"
	@ 030,070 Say ":"
	@ 030,080 Get  cCusto Valid (existcpo("CTT") .And. CTT->CTT_BLOQ <> "1" .And. NaoVazio()) F3 "CTT"  Size 66,10 
	
	@ 045,010 Say "Referencia"
	@ 045,070 Say ":"
//	@ 045,080 Get  cRefGef Valid NaoVazio() Picture "@!" Size 66,30 	
	@ 045,080 Get  cRefGef Picture "@!" Size 66,30 
/*
	If cCli + cLoja $ _cCliMAN
			@ 060,010 Say "Numero do CVA(MAN)"
			@ 060,070 Say ":"
			@ 060,080 Get _cNumCVA Picture "@!" WHEN .F. Size 072,010

			@ 075,010 Say "Tipo Carregamento(MAN)"
			@ 075,070 Say ":"
			@ 075,080 ComboBox _cTipoCar Items _aTipoCar Size 072,010
		
			@ 095,010 Say "N๚m.Coleta Moniloc(MAN)"
			@ 095,070 Say ":"
			@ 095,080 Get _cColMon Picture "@!" Size 072,010
	EndIf
*/		
	@ 120,110 BmpButton Type 01 Action (fConfirma2())
	@ 120,150 BmpButton Type 02 Action (oDlg:End())
				
	Activate Dialog oDlg Centered
	
EndIf

// Verifica se existe portador - Saulo Muniz ( 18/07/06 )

/*
If !EMPTY(SE1->E1_PORTADOR)
   MsgStop("Portador Vazio")
   Return
Else
   MsgInfo("Portador nใo Vazio")   
Endif
*/

RestArea(aArea)
/*DbSelectArea(_mOldArea)
DbSetOrder(_mOldInde)
DbGoto(_mOldRecn)*/

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfConfirma บ Autor ณ Marcos Furtado     บ Data ณ  20/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Destinado a gravacao de dados complementares (especifico   บฑฑ
ฑฑบ          ณ Gefco) na rotina de substituicao Fatura Receber            บฑฑ
ฑฑบ          ณ ( FINA280 )                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7 - Financeiro / Ctas Receber / Faturas Receber (FINA280)บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fConfirma
Local _dVenc, _cCondPgto

//Local nPrazoPag := GetMv("MV_XPRZINV")

if nDolar <= 0
   MsgInfo("Valor em Dolar nใo Informado !")
   Return
Endif

DbSelectArea("SE1")

_mPRFFAT	:=	SE1->E1_PREFIXO
_mNUMFAT	:=	SE1->E1_NUM
_mTIPFAT	:=	SE1->E1_TIPO
_mCLIFAT	:=	SE1->E1_CLIENTE
_mLOJFAT	:=	SE1->E1_LOJA 

/*** 
* Por: Ricardo - Em: 02/12/2009
* Objetivo: Passar a gerar o vencimento de acordo com a condi็ใo de pagamento informada no cad. de clientes
****/
_cCondPgto := POSICIONE("SA1",1,xFilial("SA1")+_mCLIFAT + _mLOJFAT,"A1_COND")

If Empty(_cCondPgto)
   MsgInfo("Nใo estแ informado a condi็ใo de pagamento no cadastro de cliente (" + _mCLIFAT+_mLOJFAT + ")")
   Return .F.
EndIf

_dVenc := CONDICAO(SE1->E1_SALDO,_cCondPgto,,DDATABASE)[1,1]

//Dados a Replicar
_mM2		:=	SE1->E1_MOEDA
_ValorM1    :=  SE1->E1_SALDO //REAIS
_ValorM2    :=  (SE1->E1_SALDO / nDolar) //DOLAR
//_mCCUSTO	:=	SE1->E1_CCUSTO
_mHIST		:=	Alltrim(SE1->E1_HIST)   

RecLock("SE1",.F.)
SE1->E1_MOEDA	:=	iif(nMoeda == "Dolar" ,2,IIF(nMoeda == "Euro",4,5)) //2 - Dolar   4 - Euro   5 - GBP(Libra Esterlina)
SE1->E1_HIST	:=	_mHIST
SE1->E1_VALOR	:=	_ValorM2
SE1->E1_SALDO	:=	_ValorM2
SE1->E1_VLCRUZ	:=	_ValorM1  
SE1->E1_CCONT 	:=  cCusto
SE1->E1_TXMOEDA	:=	nDolar            
SE1->E1_INVOICE	:=	Alltrim(cInv)
SE1->E1_REFGEF	:=	Alltrim(cRefGef)
SE1->E1_EMISSAO :=  dDataInv
// SE1->E1_VENCTO  :=  dDataInv + 120 // Comentado por: Ricardo - Em: 02/12/09
SE1->E1_VENCTO  := _dVenc
SE1->E1_VENCREA :=  DataValida(_dVenc)     

MsUnlock()

oDlg:End()                                     

Return()

User Function CalcVlrM2()

nVlrM2 := (SE1->E1_SALDO / nDolar)
OvlrM2:Refresh()

Return(.T.)

*-----------------------------*
Static Function fConfirma2      
*-----------------------------*
//Atualiza o campo centro de custo da fatura para o centro de custo que esta no parametro
If SE1->E1_PREFIXO == 'FAT'
	If Empty(cCusto)
		Alert("Favor informar o CC.")
		Return .F.
	EndIf
/*	
	If SE1->E1_CLIENTE + SE1->E1_LOJA $ _cCliMAN .AND. Left(cCusto,3) $ AllTrim(GETMV("MV_XOVLCC"))
		If Empty(_cTipoCar)
			Alert("Para cliente MAN, favor informar o Tipo de Carregamento.")
			Return .F.
		EndIf
		
		If Empty(_cNumCVA)
			Alert("Para cliente MAN, favor informar o N๚mero do CVA.")
			Return .F.
		EndIf		  
		
		If Empty(_cColMon)
			Alert("Para cliente MAN, favor informar o N๚mero da Coleta do Moniloc.")
			Return .F.
		EndIf		
	EndIf
*/	
	RecLock("SE1",.F.)
	SE1->E1_CCONT 	:=  cCusto
	SE1->E1_REFGEF	:=	Alltrim(cRefGef)
	
	// Dados do cliente MAN - 05/02/2014 - Ricardo
	SE1->E1_TPCAR   := _cTipoCar
	SE1->E1_NUMCVA  := _cNumCVA
	SE1->E1_COLMON  := _cColMon	
	MsUnlock()
EndIF
oDlg:End()
Return