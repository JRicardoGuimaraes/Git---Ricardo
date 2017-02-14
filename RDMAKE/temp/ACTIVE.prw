//#include 'fivewin.ch'
#include 'rwmake.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ACTIVE   บAutor ณ  Saulo Muniz        บ Data ณ  29/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescricao : Relatorio especifico Rmlap   Margem Comercial              ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ACTIVE()

Private _cDescTran := ""
Private lEnd     := .F.
Private cPerg    := 'GEF002'
Public  dEmissao
Public  dDatPrf

//ValidPerg()

If	( ! Pergunte(cPerg,.T.) )
  Return
Else
  Private	cNumPed  	:= mv_par01			// Numero do Pedido de Compras
  Private	lImpPrc		:= 2 //(mv_par02==2)	// Imprime os Precos ?
  Private	nTitulo 	:= mv_par03  			// Titulo do Relatorio ?
  Private	cObserv1	:= mv_par04	   		// 1a Linha de Observacoes
  Private	cObserv2	:= mv_par05		  	   // 1a Linha de Observacoes
  Private	cObserv3	:= mv_par06		    	// 1a Linha de Observacoes
  Private	cObserv4	:= mv_par07			   // 1a Linha de Observacoes
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a rotina de impressao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({ |lEnd| xPrintRel(),OemToAnsi('Gerando o relat๓rio.')}, OemToAnsi('Aguarde...'))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura a area anterior ao processamento. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//RestArea(aAreaSZ2)
DbCloseArea("TRX")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xPrintRelบAutor ณLuis Henrique Robustoบ Data ณ  10/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime a Duplicata...                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xPrintRel()

Private _cTransp     := ""
Private oPrint       := TMSPrinter():New(OemToAnsi('MARGEM COMERCIAL'))
Private oBrush       := TBrush():New(,4)
Private oPen         := TPen():New(0,5,CLR_BLACK)
Private cFileLogo    := GetSrvProfString('Startpath','') + 'msmdilogo' + '.bmp'
Private oFont07      := TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.)
Private oFont08      := TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.)
Private oFont08n     := TFont():New('Courier New',08,08,,.T.,,,,.T.,.F.)
Private oFont09      := TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.)
Private oFont10      := TFont():New('Tahoma',10,10,,.F.,,,,.T.,.F.)
Private oFont10n     := TFont():New('Courier New',10,10,,.T.,,,,.T.,.F.)
Private oFont11      := TFont():New('Tahoma',11,11,,.F.,,,,.T.,.F.)
Private oFont11n     := TFont():New('Tahoma',11,11,,.T.,,,,.T.,.F.)
Private oFont12      := TFont():New('Tahoma',12,12,,.T.,,,,.T.,.F.)
Private oFont12n     := TFont():New('Tahoma',12,12,,.F.,,,,.T.,.F.)
Private oFont13      := TFont():New('Tahoma',13,13,,.T.,,,,.T.,.F.)
Private oFont14      := TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.)
Private oFont15      := TFont():New('Arial',15,15,,.T.,,,,.T.,.F.)
Private oFont18      := TFont():New('Arial',18,18,,.T.,,,,.T.,.T.)
Private oFont16      := TFont():New('Arial',16,16,,.T.,,,,.T.,.F.)
Private oFont20      := TFont():New('Arial',20,20,,.F.,,,,.T.,.F.)
Private oFont22      := TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)
Private nLinha       := 3000 // Controla a linha por extenso
Private nLinFim      := 0    // Linha final para montar a caixa dos itens
Private lPrintDesTab := .F.  // Imprime a Descricao da tabela (a cada nova pagina)
Private cRepres		:= Space(80)
Private _nQtdReg     := 0    // Numero de registros para intruir a regua
Private _nValMerc 	 := 0    // Valor das mercadorias
Private _nValIPI     := 0    // Valor do I.P.I.
Private _nValDesc    := 0    // Valor de Desconto
Private _nRValDesc   := 0    // Valor de Desconto
Private _nTotAcr     := 0    // Valor total de acrescimo
Private _nTotSeg     := 0    // Valor de Seguro
Private _nTotFre     := 0    // Valor de Frete

Private nPreal   := 0
Private nPrInt   := 0 	     
Private nBarueri := 0
Private nCaxias  := 0
Private nVilaGui := 0
Private nSJP     := 0
Private nCampina := 0
Private nVitoria := 0
Private nContage := 0

Private nRPreal   := 0
Private nRBarueri := 0
Private nRCaxias  := 0
Private nRVilaGui := 0
Private nRSJP     := 0
Private nRCampina := 0
Private nRVitoria := 0
Private nRContage := 0

Private nMCPreal    := 0
Private nMCBarueri  := 0
Private nMCCaxias   := 0
Private nMCVilaGui  := 0
Private nMCSJP      := 0
Private nMCCampina  := 0
Private _nMCValDesc := 0
Private nMCVitoria  := 0
Private nMCContage  := 0
Private nRPrInt     := 0
Private nMCPrInt    := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine que a impressao deve ser RETRATOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//oPrint:SetPortrait()
oPrint:SetLandsCape()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta query !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cQry := ""
	cQry := "SELECT * "
	cQry += "FROM " + RetSqlName("SZ2") + " "
	cQry += "WHERE Z2_FILIAL = '" + xFilial("SZ2") + "' "
	cQry += "AND Z2_MES = '" + DTOS(MV_PAR01) + "' "
	cQry += "AND Z2_COD = '" + MV_PAR05 + "' "
	cQry += "AND ( Z2_CONTA = 'A01' OR Z2_CONTA = 'B01' OR Z2_CONTA = 'B04' OR Z2_CONTA = 'B07') "
	cQry += "AND D_E_L_E_T_ <> '*' "
	cQry += "ORDER BY Z2_COD "	

    MEMOWRIT("ACTIVE.SQL",cQry)
    TcQuery cQry Alias "TRX" NEW

If	! USED()
    MsgBox(cQry+'. Query errada','Erro!!!','STOP')
EndIf

DbSelectArea('TRX')
Count to _nQtdReg
ProcRegua(_nQtdReg)
TRX->(DbGoTop())

xCabec()

nCountReg := 1

Do While TRX->(!Eof() )
  
  /*
  oPrint:Line(nLinha,100,nLinha+60,100)
  oPrint:Line(nLinha,240,nLinha+60,240)
  oPrint:Line(nLinha,440,nLinha+60,440)
  oPrint:Line(nLinha,1130,nLinha+70,1130)
  oPrint:Line(nLinha,1380,nLinha+60,1380)
  oPrint:Line(nLinha,1480,nLinha+60,1480)
  oPrint:Line(nLinha,1750,nLinha+60,1750)
  oPrint:Line(nLinha,2040,nLinha+60,2040)
  oPrint:Line(nLinha,2300,nLinha+60,2300)
  */
 
  _nValMerc += TRX->Z2_PREAL + TRX->Z2_BARUERI + TRX->Z2_CAXIAS + TRX->Z2_VILAGUI + TRX->Z2_SJP + TRX->Z2_CAMPINA
  _nTotAcr  += _nValMerc  

  If Alltrim(TRX->Z2_CONTA) <> 'A01' 
    // Despesas
    nPreal   := nPreal + TRX->Z2_PREAL 
    nBarueri := nBarueri + TRX->Z2_BARUERI 
    nCaxias  := nCaxias + TRX->Z2_CAXIAS 
    nVilaGui := nVilaGui + TRX->Z2_VILAGUI
    nSJP     := nSJP + TRX->Z2_SJP 
    nCampina := nCampina + TRX->Z2_CAMPINA
    nContage := nContage + TRX->Z2_CONTAGE
    nVitoria := nVitoria + TRX->Z2_VITORIA
	nPrInt   := nPrInt + TRX->Z2_INTPR 
    _nValDesc:= nPreal + nBarueri + nCaxias + nVilaGui + nSJP + nCampina + nContage + nVitoria
        
  Else

    oPrint:Say(nLinha,0120,Alltrim("VENDAS "),oFont12n)
    oPrint:Say(nLinha,0350,AllTrim(Transform(nPrInt,"@E 999,999,999.99")),oFont12n)
    oPrint:Say(nLinha,0700,AllTrim(Transform(TRX->Z2_BARUERI,"@E 999,999,999.99")),oFont12n)  
    oPrint:Say(nLinha,1050,AllTrim(Transform(TRX->Z2_CAXIAS,"@E 999,999,999.99")),oFont12n)  
    oPrint:Say(nLinha,1400,AllTrim(Transform(TRX->Z2_VILAGUI,"@E 999,999,999.99")),oFont12n) 
    oPrint:Say(nLinha,1750,AllTrim(TransForm(TRX->Z2_SJP,'@E 999,999,999.99')),oFont12n)
    oPrint:Say(nLinha,2100,AllTrim(TransForm(TRX->Z2_CAMPINA,'@E 999,999,999.99')),oFont12n)
    oPrint:Say(nLinha,2450,AllTrim(TransForm(TRX->Z2_VITORIA,'@E 999,999,999.99')),oFont12n)
    oPrint:Say(nLinha,2800,AllTrim(TransForm(TRX->Z2_CONTAGE,'@E 999,999,999.99')),oFont12n)
    oPrint:Say(nLinha,3100,AllTrim(TransForm(_nValMerc,'@E 999,999,999.99')),oFont12n)

    
    // Receita
	nRPrInt    := nRPrInt + TRX->Z2_INTPR 
    nRPreal   := (nRPreal + TRX->Z2_PREAL) - nRPrInt
    nRBarueri := nRBarueri + TRX->Z2_BARUERI 
    nRCaxias  := nRCaxias + TRX->Z2_CAXIAS 
    nRVilaGui := nRVilaGui + TRX->Z2_VILAGUI
    nRSJP     := nRSJP + TRX->Z2_SJP 
    nRCampina := nRCampina + TRX->Z2_CAMPINA
    nRContage := nRContage + TRX->Z2_CONTAGE
    nRVitoria := nRVitoria + TRX->Z2_VITORIA
    _nRValDesc:= nRPreal + nRBarueri + nRCaxias + nRVilaGui + nRSJP + nRCampina + nRContage + nRVitoria + nRPrInt

    nLinha += 60
    oPrint:Line(nLinha,100,nLinha,3350)

    If Alltrim(TRX->Z2_CONTA) <> 'A01' 
       MsgBox("Erro Conta !"+"Query errada","Erro!!!","STOP")  
    Endif

  Endif
  
  IncProc()
  dbSelectArea("TRX")
  DbSkip()

  nCountReg := nCountReg + 1  
  _nValMerc := 0

  If nCountReg = 30
    xVerPag()
  EndIf

  //xPulaPag()

EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime Compras   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//////////////
//  MARGEM  //
//////////////

nMCPreal    := nRPreal + nPreal
nMCPrInt    := nRPrInt + nPrInt // nRPreal + nPreal
nMCBarueri  := nRBarueri + nBarueri
nMCCaxias   := nRCaxias + nCaxias
nMCVilaGui  := nRVilaGui + nVilaGui
nMCSJP      := nRSJP + nSJP
nMCCampina  := nRCampina + nCampina
nMCContage  := nRContage + nContage
nMCVitoria  := nRVitoria + nVitoria

_nMCValDesc := _nRValDesc + _nValDesc


//If Alltrim(TRX->Z2_CONTA) <> 'A01' 

	oPrint:Say(nLinha,0120,Alltrim("COMPRAS "),oFont12n)
	//oPrint:Say(nLinha,0350,AllTrim(Transform(nPreal,"@E 999,999,999.99")),oFont12n)
	oPrint:Say(nLinha,0350,AllTrim(Transform(nPrInt,"@E 999,999,999.99")),oFont12n)
	oPrint:Say(nLinha,0700,AllTrim(Transform(nBarueri,"@E 999,999,999.99")),oFont12n)  
	oPrint:Say(nLinha,1050,AllTrim(Transform(nCaxias,"@E 999,999,999.99")),oFont12n)  
	oPrint:Say(nLinha,1400,AllTrim(Transform(nVilaGui,"@E 999,999,999.99")),oFont12n) 
	oPrint:Say(nLinha,1750,AllTrim(TransForm(nSJP,'@E 999,999,999.99')),oFont12n)
	oPrint:Say(nLinha,2100,AllTrim(TransForm(nCampina,'@E 999,999,999.99')),oFont12n)
	oPrint:Say(nLinha,2450,AllTrim(TransForm(nVitoria,'@E 999,999,999.99')),oFont12n)
	oPrint:Say(nLinha,2800,AllTrim(TransForm(nContage,'@E 999,999,999.99')),oFont12n)
	oPrint:Say(nLinha,3100,AllTrim(TransForm(_nValDesc,'@E 999,999,999.99')),oFont12n)
//Endif

nLinha += 60
oPrint:Line(nLinha,100,nLinha,3350)

//If Alltrim(TRX->Z2_CONTA) <> 'A01' 
	oPrint:Say(nLinha,0120,Alltrim("MARGEM "),oFont12n)
	//oPrint:Say(nLinha,0350,AllTrim(Transform(nMCPreal,"@E 999,999,999.99")),oFont12n)
	oPrint:Say(nLinha,0350,AllTrim(Transform(nMCPrInt,"@E 999,999,999.99")),oFont12n)
	oPrint:Say(nLinha,0700,AllTrim(Transform(nMCBarueri,"@E 999,999,999.99")),oFont12n)  
	oPrint:Say(nLinha,1050,AllTrim(Transform(nMCCaxias,"@E 999,999,999.99")),oFont12n)  
	oPrint:Say(nLinha,1400,AllTrim(Transform(nMCVilaGui,"@E 999,999,999.99")),oFont12n) 
	oPrint:Say(nLinha,1750,AllTrim(TransForm(nMCSJP,'@E 999,999,999.99')),oFont12n)
	oPrint:Say(nLinha,2100,AllTrim(TransForm(nMCCampina,'@E 999,999,999.99')),oFont12n)
	oPrint:Say(nLinha,2450,AllTrim(TransForm(nMCVitoria,'@E 999,999,999.99')),oFont12n)
	oPrint:Say(nLinha,2800,AllTrim(TransForm(nMCContage,'@E 999,999,999.99')),oFont12n)
	oPrint:Say(nLinha,3100,AllTrim(TransForm(_nMCValDesc,'@E 999,999,999.99')),oFont12n)
//Endif

nLinha += 60
oPrint:Line(nLinha,100,nLinha,3350)

//If Alltrim(TRX->Z2_CONTA) <> 'A01' 
	oPrint:Say(nLinha,0120,Alltrim("MC % "),oFont12)
	//oPrint:Say(nLinha,0350,AllTrim(Transform((nRPreal / nPreal) * 100,"@E 99999.99")) + " % ",oFont12)
	oPrint:Say(nLinha,0350,AllTrim(Transform((nRPrInt / nPrInt) * 100,"@E 99999.99")) + " % ",oFont12)
	oPrint:Say(nLinha,0700,AllTrim(Transform((nMCBarueri / nRBarueri) * 100,"@E 99999.99")) + " % ",oFont12)  
	oPrint:Say(nLinha,1050,AllTrim(Transform((nMCCaxias / nRCaxias) * 100,"@E 99999.99")) + " % ",oFont12)  
	oPrint:Say(nLinha,1400,AllTrim(Transform((nMCVilaGui / nRVilaGui) * 100,"@E 99999.99")) + " % ",oFont12) 
	oPrint:Say(nLinha,1750,AllTrim(TransForm((nMCSJP / nRSJP) * 100,'@E 99999.99')) + " % ",oFont12)
	oPrint:Say(nLinha,2100,AllTrim(TransForm((nMCCampina / nRCampina) * 100,'@E 99999.99')) + " % ",oFont12)
	oPrint:Say(nLinha,2450,AllTrim(TransForm((nMCVitoria / nRVitoria) * 100,'@E 99999.99')) + " % ",oFont12)
	oPrint:Say(nLinha,2800,AllTrim(TransForm((nMCContage / nRContage) * 100,'@E 99999.99')) + " % ",oFont12)
	oPrint:Say(nLinha,3100,AllTrim(TransForm((_nMCValDesc / _nRValDesc) * 100,'@E 99999.99')) + " % ",oFont12)
//Endif

nLinha += 60
oPrint:Line(nLinha,100,nLinha,3350)

/*
  oPrint:Line(nLinha,1380,nLinha+80,1380)
  oPrint:Line(nLinha,1840,nLinha+80,1840)
  oPrint:Line(nLinha,2600,nLinha+80,2600)
  oPrint:Say(nLinha+10,1400,'Total Geral ',oFont11n)
  oPrint:Say(nLinha+10,2020,TransForm(_nTotAcr,'@E 999,999,999.99'),oFont13)
  nLinha += 80
  oPrint:Line(nLinha,1380,nLinha,2600)
*/

xPulaPag()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime a Magem Comercial !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*
oPrint:FillRect({nLinha,1380,nLinha+80,2600},oBrush)
oPrint:Line(nLinha,1380,nLinha+80,1380)
oPrint:Line(nLinha,1840,nLinha+80,1840)
oPrint:Line(nLinha,2600,nLinha+80,2600)
oPrint:Say(nLinha+10,1400,'VALOR TOTAL ',oFont12)
oPrint:Say(nLinha+10,1970,TransForm(_nTotAcr,'@E 9,999,999.99'),oFont14)

xPulaPag()
nLinha += 80
//oPrint:Line(nLinha,1380,nLinha,2300)
nLinha += 70
xPulaPag()
*/

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime em Video, e finaliza a impressao. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
oPrint:Preview()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xCabec() บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Cabecalho do relatorio...                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xCabec()

Local xDescZ1

oPrint:StartPage()

// Nome do Departamento no Relat๓rio
DbselectArea("SZ1")
DbSetOrder(1) 
Dbgotop()
Dbseek(xFilial("SZ1")+MV_PAR05)
xDescZ1 := Alltrim(SZ1->Z1_DESCR)

dbSelectArea("TRX")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime o cabecalho da empresa. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:SayBitmap(050,100,cFileLogo,900,270)
oPrint:Say(050,1100,AllTrim(Upper(SM0->M0_NOMECOM)),oFont15)
oPrint:Say(135,1100,AllTrim(SM0->M0_ENDCOB),oFont11)
oPrint:Say(180,1100,Capital(AllTrim(SM0->M0_CIDCOB))+'/'+AllTrim(SM0->M0_ESTCOB)+ '  -  ' + AllTrim(TransForm(SM0->M0_CEPCOB,'@R 99.999-999')) + '  -  ' + AllTrim(SM0->M0_TEL),oFont11)
oPrint:Say(225,1100,AllTrim('www.gefco.com.br'),oFont11)
oPrint:Line(285,1099,285,2270)
oPrint:Say(300,1100,'CNPJ:',oFont12)
oPrint:Say(300,1250,TransForm(SM0->M0_CGC,'@R 99.999.999/9999-99'),oFont12)
oPrint:Say(300,1950,'Insc. Est.',oFont12)
oPrint:Say(300,2150,SM0->M0_INSC,oFont12)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTitulo do Relatorioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Say(0440,1100,OemToAnsi('Margem Comercial'),oFont22)

//ฺฤฤฤฤฤฤฤฤฤฤฟ
//ณFornecedorณ
//ภฤฤฤฤฤฤฤฤฤฤู
oPrint:Say(0530,0100,OemToAnsi('Unid. Oper.   :     ')+xDescZ1,oFont13)
oPrint:Say(0580,0100,OemToAnsi('Refer๊ncia    :     ')+DtoC(dDatabase),oFont13)

nLinha:= 700

oPrint:Line(nLinha,100,nLinha,3350)     // Linha

//oPrint:Line(nLinha,100,nLinha,3250)     // Linha
//oPrint:Line(nLinha,100,nLinha+70,100)
//oPrint:Line(nLinha,3000,nLinha+70,3250)

/*
oPrint:Line(nLinha,100,nLinha,2300)     // Linha
oPrint:Line(nLinha,100,nLinha+70,100)
oPrint:Line(nLinha,240,nLinha+70,240)
oPrint:Line(nLinha,440,nLinha+70,440)
oPrint:Line(nLinha,1130,nLinha+70,1130)
oPrint:Line(nLinha,1380,nLinha+70,1380)
oPrint:Line(nLinha,1480,nLinha+70,1480)
oPrint:Line(nLinha,1750,nLinha+70,1750)
oPrint:Line(nLinha,2040,nLinha+70,2040)
oPrint:Line(nLinha,2300,nLinha+70,2300)
*/

oPrint:Say(nLinha,0120,OemToAnsi(''),oFont12)
oPrint:Say(nLinha,0350,OemToAnsi('INTL'),oFont12)
oPrint:Say(nLinha,0700,OemToAnsi('POR'),oFont12)
oPrint:Say(nLinha,1050,OemToAnsi('RJ'),oFont12)
oPrint:Say(nLinha,1400,OemToAnsi('SAO'),oFont12)
oPrint:Say(nLinha,1750,OemToAnsi('CWB'),oFont12)
oPrint:Say(nLinha,2100,OemToAnsi('CPQ'),oFont12)
oPrint:Say(nLinha,2450,OemToAnsi('VIT'),oFont12)
oPrint:Say(nLinha,2800,OemToAnsi('CON'),oFont12)
oPrint:Say(nLinha,3150,OemToAnsi('TOTAL'),oFont12)

/*
oPrint:Say(nLinha,0120,OemToAnsi('U.O.'),oFont12)
oPrint:Say(nLinha,0600,OemToAnsi('P.Real'),oFont12)
oPrint:Say(nLinha,0900,OemToAnsi('Barueri'),oFont12)
oPrint:Say(nLinha,1300,OemToAnsi('Pavuna'),oFont12)
oPrint:Say(nLinha,1700,OemToAnsi('V.Guilherme'),oFont12)
oPrint:Say(nLinha,2200,OemToAnsi('Curitiba'),oFont12)
oPrint:Say(nLinha,2600,OemToAnsi('Campinas'),oFont12)
oPrint:Say(nLinha,3100,OemToAnsi('Total'),oFont12)
*/

nLinha += 70

oPrint:Line(nLinha,100,nLinha,3300)
//oPrint:Line(nLinha,100,nLinha,3250)
nCountReg := 1

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xVerPag()บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se deve ou nao saltar pagina...                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicia a montagem da impressao.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Line(3200,0100,3200,2600)
oPrint:Say(3230,1000,'CONTINUA NA PROXIMA PAGINA')
oPrint:Line(3300,0100,3300,2600)
oPrint:EndPage()
xCabec()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPulaPag()บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se deve ou nao saltar pagina...                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xPulaPag()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicia a montagem da impressao.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nLinha >= 2700
  oPrint:Line(3200,0100,3200,2600)
  oPrint:Say(3230,1000,'CONTINUA NA PROXIMA PAGINA')
  oPrint:Line(3300,0100,3300,2600)
  oPrint:EndPage()
  xCabec()
EndIf

Return


***************************
Static Function ValidPerg()
***************************

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

DbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))

Aadd(aRegs,{cPerg,"01","Numero do Pedido       :","","","mv_ch1","C",006,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Imprime os Precos      ?","","","mv_ch2","C",001,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Titulo do Relatorio    ?","","","mv_ch3","C",030,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","1a Linha de Observacoes:","","","mv_ch4","C",030,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","2a Linha de Observacoes:","","","mv_ch5","C",030,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","3a Linha de Observacoes:","","","mv_ch6","C",030,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","4a Linha de Observacoes:","","","mv_ch7","C",030,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})


For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next

DbSelectArea(_sAlias)

Return(.T.)