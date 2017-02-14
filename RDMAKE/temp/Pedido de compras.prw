#include 'fivewin.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ACTIVE   บAutor ณ  Saulo Muniz        บ Data ณ  29/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PEDIDO DE COMPRAS (Emissao em formato Grafico)             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ACTIVE()

Private _cDescTran := ""
Private lEnd     := .F.
Private aAreaSC7 := SC7->(GetArea())
Private aAreaSA2 := SA2->(GetArea())
Private aAreaSA5 := SA5->(GetArea())
//Private aAreaSZF := SZF->(GetArea())
Private aAreaSF4 := SF4->(GetArea())
Private cPerg    := 'LC13R '
Public  dEmissao
Public  dDatPrf

ValidPerg()

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

DbSelectArea('SC7')
SC7->(DbSetOrder(1))
If	( ! SC7->(DbSeek(xFilial('SC7') + cNumPed)) )
  Help('',1,'LC13R',,OemToAnsi('Pedido nใo encontrado.'),1)
  Return .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a rotina de impressao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({ |lEnd| xPrintRel(),OemToAnsi('Gerando o relat๓rio.')}, OemToAnsi('Aguarde...'))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura a area anterior ao processamento. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea(aAreaSC7)
RestArea(aAreaSA2)
RestArea(aAreaSA5)
//RestArea(aAreaSZF)
RestArea(aAreaSF4)
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
//Private _cNumNota    := ""
Private oPrint       := TMSPrinter():New(OemToAnsi('Pedido de Compras'))
Private oBrush       := TBrush():New(,4)
Private oPen         := TPen():New(0,5,CLR_BLACK)
Private cFileLogo    := GetSrvProfString('Startpath','') + 'logo01' + '.BMP'
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
Private _nValMerc 	:= 0    // Valor das mercadorias
Private _nValIPI     := 0    // Valor do I.P.I.
Private _nValDesc    := 0    // Valor de Desconto
Private _nTotAcr     := 0    // Valor total de acrescimo
Private _nTotSeg     := 0    // Valor de Seguro
Private _nTotFre     := 0    // Valor de Frete

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine que a impressao deve ser RETRATOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:SetPortrait()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta query !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู


cSELECT := 'SC7.C7_FILIAL, SC7.C7_NUM, SC7.C7_EMISSAO, SC7.C7_FORNECE, SC7.C7_LOJA,SC7.C7_MOEDA, SC7.C7_CONTATO,'+;
           'SC7.C7_ITEM, SC7.C7_PRODUTO, SC7.C7_DESCRI, SC7.C7_QUANT, SC7.C7_MSG, SC7.C7_USER, SC7.C7_SEGUM, '+;
           'SC7.C7_PRECO, SC7.C7_IPI, SC7.C7_TOTAL, SC7.C7_VLDESC, SC7.C7_DESPESA, '+;
           'SC7.C7_SEGURO, SC7.C7_VALFRE, SC7.C7_TES, SC7.C7_UM, SC7.C7_DATPRF,SC7.C7_COND, SC7.C7_QTSEGUM '
cFROM   := RetSqlName('SC7') + ' SC7 '
cWHERE  := 'SC7.D_E_L_E_T_ <>   '+CHR(39) + '*'            +CHR(39) + ' AND '+;
           'SC7.C7_FILIAL  =    '+CHR(39) + xFilial('SC7') +CHR(39) + ' AND '+;
           'SC7.C7_NUM     =    '+CHR(39) + cNumPed        +CHR(39) 
cORDER  := 'SC7.C7_FILIAL, SC7.C7_ITEM '
cQuery  := ' SELECT '   + cSELECT + ; 
           ' FROM '     + cFROM   + ;
           ' WHERE '    + cWHERE  + ;
           ' ORDER BY ' + cORDER

MEMOWRIT("ACTIVE.SQL",cQuery)
//TCQUERY cQuery NEW ALIAS 'TRA'                    
TcQuery cQuery Alias "TRA" NEW

If	! USED()
  MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
EndIf
DbSelectArea('TRA')
Count to _nQtdReg
ProcRegua(_nQtdReg)
TRA->(DbGoTop())
xCabec()
nCountReg := 1
Do While TRA->(!Eof() )
  SB1->(dbSetOrder(1))
  SB1->(dbSeek(xFilial("SB1")+TRA->C7_PRODUTO))
  oPrint:Line(nLinha,100,nLinha+60,100)
  oPrint:Line(nLinha,240,nLinha+60,240)
  oPrint:Line(nLinha,440,nLinha+60,440)
  oPrint:Line(nLinha,1130,nLinha+70,1130)
  oPrint:Line(nLinha,1380,nLinha+60,1380)
  oPrint:Line(nLinha,1480,nLinha+60,1480)
  oPrint:Line(nLinha,1750,nLinha+60,1750)
  oPrint:Line(nLinha,2040,nLinha+60,2040)
  oPrint:Line(nLinha,2300,nLinha+60,2300)
  oPrint:Say(nLinha,0120,TRA->C7_ITEM,oFont12n)
  oPrint:Say(nLinha,0260,SubStr(TRA->C7_PRODUTO,1,25),oFont12n)
  oPrint:Say(nLinha,0460,SubStr(SB1->B1_DESC,1,25),oFont12n)
  If !Empty(SubStr(SB1->B1_DESC,26,15))
    nLinha += 60
    oPrint:Line(nLinha,100,nLinha+60,100)
    oPrint:Line(nLinha,240,nLinha+60,240)
    oPrint:Line(nLinha,440,nLinha+60,440)
    oPrint:Line(nLinha,1130,nLinha+70,1130)
    oPrint:Line(nLinha,1380,nLinha+60,1380)
    oPrint:Line(nLinha,1480,nLinha+60,1480)
    oPrint:Line(nLinha,1750,nLinha+60,1750)
    oPrint:Line(nLinha,2040,nLinha+60,2040)
    oPrint:Line(nLinha,2300,nLinha+60,2300)
    oPrint:Say(nLinha,0460,SubStr(SB1->B1_DESC,26,15),oFont12n)
  EndIf
  dDatPrf  := CtoD(SubStr(TRA->C7_DATPRF,7,2)  + "/" + SubStr(TRA->C7_DATPRF,5,2)  + "/" + SubStr(TRA->C7_DATPRF,3,2))
  oPrint:Say(nLinha,1200,DtoC(dDatPrf),oFont12n)
  
  oPrint:Say(nLinha,1400,TRA->C7_UM,oFont12n)
  oPrint:Say(nLinha,1750,AllTrim(TransForm(TRA->C7_QUANT,'@E 999,999,999.99')),oFont12n,,,,1)
  oPrint:Say(nLinha,2000,AllTrim(TransForm(TRA->C7_PRECO,'@E 999,999.9999')),oFont12n,,,,1)
  oPrint:Say(nLinha,2260,AllTrim(TransForm(TRA->C7_TOTAL,'@E 999,999.99')),oFont12n,,,,1)

  nLinha += 60
  oPrint:Line(nLinha,100,nLinha,2300)
  _nValMerc += TRA->C7_TOTAL
  _nValIPI  += (TRA->C7_TOTAL * TRA->C7_IPI) / 100
  _nValDesc += TRA->C7_VLDESC
  _nTotAcr  += TRA->C7_DESPESA
  _nTotSeg  += TRA->C7_SEGURO
  _nTotFre  += TRA->C7_VALFRE
  _cMsg     := TRA->C7_MSG
  _cCond    := TRA->C7_COND
  _cUser    := TRA->C7_USER
  /*
  If Empty(_cTransp)
    _cTransp  := TRA->C7_TRANSP
    dbSelectArea("SA2")
    dbSetOrder(1)
    dbSeek(xFilial("SA2")+TRA->C7_TRANSP)
    _cDescTran := SA2->A2_NOME
  EndIf
  */
  
  /*
  If Empty(_cNumNota)
    _cNumNota := TRA->C7_NUMNOTA
  EndIf
  */
  
  SE4->(dbSetOrder(1))
  SE4->(DbSeek(xFilial("SE4")+_cCond))
  _cDesCond := SE4->E4_DESCRI
  IncProc()
  dbSelectArea("TRA")
  DbSkip()
  nCountReg := nCountReg + 1
  If nCountReg = 25
    xVerPag()
  EndIf
  xPulaPag()
EndDo
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE MERCADORIASณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

  oPrint:Line(nLinha,1380,nLinha+80,1380)
  oPrint:Line(nLinha,1840,nLinha+80,1840)
  oPrint:Line(nLinha,2300,nLinha+80,2300)
  oPrint:Say(nLinha+10,1400,'Valor de Mercadorias ',oFont11n)
  oPrint:Say(nLinha+10,2020,TransForm(_nValMerc,'@E 9,999,999.99'),oFont13)
  nLinha += 80
  oPrint:Line(nLinha,1380,nLinha,2300)

xPulaPag()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE I.P.I. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

  oPrint:Line(nLinha,1380,nLinha+80,1380)
  oPrint:Line(nLinha,1840,nLinha+80,1840)
  oPrint:Line(nLinha,2300,nLinha+80,2300)
  oPrint:Say(nLinha+10,1400,'Valor de I. P. I. (+)',oFont12)
  oPrint:Say(nLinha+10,2020,TransForm(_nValIpi,'@E 9,999,999.99'),oFont13)
  nLinha += 80
  oPrint:Line(nLinha,1380,nLinha,2300)

xPulaPag()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE DESCONTOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

  oPrint:Line(nLinha,1380,nLinha+80,1380)
  oPrint:Line(nLinha,1840,nLinha+80,1840)
  oPrint:Line(nLinha,2300,nLinha+80,2300)
  oPrint:Say(nLinha+10,1400,'Valor de Desconto (-)',oFont12)
  oPrint:Say(nLinha+10,2020,TransForm(_nValDesc,'@E 9,999,999.99'),oFont13)
  nLinha += 80
  oPrint:Line(nLinha,1380,nLinha,2300)

xPulaPag()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE ACRESCIMO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

  oPrint:Line(nLinha,1380,nLinha+80,1380)
  oPrint:Line(nLinha,1840,nLinha+80,1840)
  oPrint:Line(nLinha,2300,nLinha+80,2300)
  oPrint:Say(nLinha+10,1400,'Valor de Acresc. (+)',oFont12)
  oPrint:Say(nLinha+10,2020,TransForm(_nTotAcr,'@E 9,999,999.99'),oFont13)
  nLinha += 80
  oPrint:Line(nLinha,1380,nLinha,2300)

xPulaPag()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE SEGURO ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

  oPrint:Line(nLinha,1380,nLinha+80,1380)
  oPrint:Line(nLinha,1840,nLinha+80,1840)
  oPrint:Line(nLinha,2300,nLinha+80,2300)
  oPrint:Say(nLinha+10,1400,'Valor de Seguro (+)',oFont12)
  oPrint:Say(nLinha+10,2020,TransForm(_nTotSeg,'@E 9,999,999.99'),oFont13)
  nLinha += 80
  oPrint:Line(nLinha,1380,nLinha,2300)

xPulaPag()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime TOTAL DE FRETE ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

  oPrint:Line(nLinha,1380,nLinha+80,1380)
  oPrint:Line(nLinha,1840,nLinha+80,1840)
  oPrint:Line(nLinha,2300,nLinha+80,2300)
  oPrint:Say(nLinha+10,1400,'Valor de Frete (+)',oFont12)
  oPrint:Say(nLinha+10,2020,TransForm(_nTotFre,'@E 9,999,999.99'),oFont13)
  nLinha += 80
  oPrint:Line(nLinha,1380,nLinha,2300)

xPulaPag()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime o VALOR TOTAL !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:FillRect({nLinha,1380,nLinha+80,2300},oBrush)
oPrint:Line(nLinha,1380,nLinha+80,1380)
oPrint:Line(nLinha,1840,nLinha+80,1840)
oPrint:Line(nLinha,2300,nLinha+80,2300)
oPrint:Say(nLinha+10,1400,'VALOR TOTAL ',oFont12)
oPrint:Say(nLinha+10,1970,TransForm(( _nValMerc - _nValDesc ) + _nTotAcr	+ _nTotSeg + _nTotFre + _nValIpi,'@E 9,999,999.99'),oFont14)

xPulaPag()
nLinha += 80
//oPrint:Line(nLinha,1380,nLinha,2300)
nLinha += 70
xPulaPag()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime as observacoes dos parametros. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Say(nLinha,0100,OemToAnsi('Observa็๕es:'),oFont12)
oPrint:Say(nLinha,0500,cObserv1,oFont12n)
nLinha += 60
xPulaPag()
If ( ! Empty(cObserv2) )
  oPrint:Say(nLinha,0500,cObserv2,oFont12n)
  nLinha += 60
EndIf	
xPulaPag()
If ( ! Empty(cObserv3) )
  oPrint:Say(nLinha,0500,cObserv3,oFont12n)
  nLinha += 60
EndIf
xPulaPag()
If ( ! Empty(cObserv4) )
  oPrint:Say(nLinha,0500,cObserv4,oFont12n)
  nLinha += 60
EndIf
xPulaPag()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime MENSAGEM NO PEDIDOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If	_cMsg == "011"
  oPrint:Say(nLinha+20,0100,'SOMENTE SERAO CONSIDERADAS ENTREGAS NO PRAZO, RECEBIDAS ATE AS 12:00 DA DATA: '+DTOC(dDatPrf),oFont11n)
  nLinha += 80
  oPrint:Line(nLinha,0100,nLinha,2190)
EndIf
xPulaPag()
nLinha += 20
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime o Representante comercial do fornecedorณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
xPulaPag()
/*
DbSelectArea('SZF')
SZF->(DbSetOrder(1))
If SZF->(DbSeek(xFilial('SZF') + SA2->A2_COD + SA2->A2_LOJA))
  If ( ! Empty(SZF->ZF_REPRES) )
    oPrint:Say(nLinha,0100,OemToAnsi('Representante:'),oFont12)
    oPrint:Say(nLinha,0500,AllTrim(SZF->ZF_REPRES) + Space(5) + AllTrim(SZF->ZF_TELREPR) + Space(5) + AllTrim(SZF->ZF_FAXREPR),oFont12n)
    nLinha += 60
  EndIf
EndIf
xPulaPag()
*/
nLinha += 20
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime a linha de prazo pagamento/entrega!ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
xPulaPag()
oPrint:Say(nLinha,0100,OemToAnsi('Prazo Pagamento:'),oFont12)
oPrint:Say(nLinha,0500,_cDesCond,oFont14)
nLinha += 80
xPulaPag()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime a linha de transportadora !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Say(nLinha,0100,OemToAnsi('Transportadora:'),oFont12)
If !Empty(_cTransp)
  oPrint:Say(nLinha,0500,SubStr(_cDescTran,1,30),oFont14)
Else
  oPrint:Say(nLinha,0500,'___________________________________________________',oFont12n)
EndIf
/*
If !Empty(_cNumNota)
  oPrint:Say(nLinha,1700,OemToAnsi('Nota Fiscal:'),oFont12)
  oPrint:Say(nLinha,2000,_cNumNota,oFont14)
EndIf
*/

xRodape()
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
oPrint:StartPage()
DbSelectArea('SA2')
SA2->(DbSetOrder(1))
If	! SA2->(DbSeek(xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA)))
  Help('',1,'REGNOIS')
  Return .F.
EndIf
dbSelectArea("TRA")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime o cabecalho da empresa. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:SayBitmap(050,100,cFileLogo,900,270)
oPrint:Say(050,1000,AllTrim(Upper(SM0->M0_NOMECOM)),oFont15)
oPrint:Say(135,1000,AllTrim(SM0->M0_ENDCOB),oFont11)
oPrint:Say(180,1000,Capital(AllTrim(SM0->M0_CIDCOB))+'/'+AllTrim(SM0->M0_ESTCOB)+ '  -  ' + AllTrim(TransForm(SM0->M0_CEPCOB,'@R 99.999-999')) + '  -  ' + AllTrim(SM0->M0_TEL),oFont11)
oPrint:Say(225,1000,AllTrim('www.greenpharma.com.br'),oFont11)
oPrint:Line(285,999,285,2270)
oPrint:Say(300,1000,'CNPJ:',oFont12)
oPrint:Say(300,1150,TransForm(SM0->M0_CGC,'@R 99.999.999/9999-99'),oFont12)
oPrint:Say(300,1850,'Insc. Est.',oFont12)
oPrint:Say(300,2050,SM0->M0_INSC,oFont12)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTitulo do Relatorioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ( nTitulo == "1" ) // Cotacao
  oPrint:Say(0400,0800,OemToAnsi('Cota็ใo de Mercadorias'),oFont22)
Else
  oPrint:Say(0400,1000,OemToAnsi('Pedido de Compras'),oFont22)
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฟ
//ณFornecedorณ
//ภฤฤฤฤฤฤฤฤฤฤู
oPrint:Say(0530,0100,OemToAnsi('Fornecedor:'),oFont10)
oPrint:Say(0520,0430,AllTrim(SA2->A2_NOME) + '  ('+AllTrim(SA2->A2_COD)+'/'+AllTrim(SA2->A2_LOJA)+')',oFont13)
oPrint:Say(0580,0100,OemToAnsi('Endere็o:'),oFont10)
oPrint:Say(0580,0430,SA2->A2_END,oFont11)
oPrint:Say(0630,0100,OemToAnsi('Municํpio/U.F.:'),oFont10)
oPrint:Say(0630,0430,AllTrim(SA2->A2_MUN)+'/'+AllTrim(SA2->A2_EST),oFont11)
oPrint:Say(0630,1200,OemToAnsi('Cep:'),oFont10)
oPrint:Say(0630,1370,TransForm(SA2->A2_CEP,'@R 99.999-999'),oFont11)
oPrint:Say(0680,0100,OemToAnsi('Telefone:'),oFont10)
oPrint:Say(0680,0430,SA2->A2_DDD+" "+SA2->A2_TEL,oFont11)
oPrint:Say(0680,1200,OemToAnsi('Fax:'),oFont10)
oPrint:Say(0680,1370,SA2->A2_DDD+" "+SA2->A2_FAX,oFont11)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณNumero/Emissaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Box(0530,1900,0730,2300)
oPrint:FillRect({0530,1900,0730,2300},oBrush)
oPrint:Say(0535,1925,OemToAnsi('Numero documento'),oFont11)
oPrint:Say(0570,2000,TRA->C7_NUM,oFont18)
dEmissao := CtoD(SubStr(TRA->C7_EMISSAO,7,2)  + "/" + SubStr(TRA->C7_EMISSAO,5,2)  + "/" + SubStr(TRA->C7_EMISSAO,3,2))
oPrint:Say(0650,1990,DtoC(dEmissao),oFont12)
If ( ! Empty(SA2->A2_CONTATO) )
  oPrint:Say(0730,0100,OemToAnsi('Contato: '),oFont10)
  oPrint:Say(0730,0430,TRA->C7_CONTATO,oFont11)
  nLinha += 60
EndIf

If TRA->C7_MOEDA == 1
  oPrint:Say(0730,1200,OemToAnsi('Moeda: EM REAIS'),oFont11)
ElseIf TRA->C7_MOEDA == 2
  oPrint:Say(0730,1200,OemToAnsi('Moeda: EM DOLARES'),oFont11)
ElseIf TRA->C7_MOEDA == 3
  oPrint:Say(0730,1200,OemToAnsi('Moeda: EM UFIR'),oFont11)
ElseIf TRA->C7_MOEDA == 4
  oPrint:Say(0730,1200,OemToAnsi('Moeda: EM EUROS'),oFont11)
Else
  oPrint:Say(0730,1200,OemToAnsi('Moeda: NAO DEFINIDO'),oFont11)
EndIf

oPrint:Say(0780,0100,OemToAnsi('C.G.C.'),oFont10)
oPrint:Say(0780,0430,TransForm(SA2->A2_CGC,'@R 99.999.999/9999-99'),oFont11)
oPrint:Say(0780,1200,OemToAnsi('Insc.Estadual'),oFont10)
oPrint:Say(0780,1450,SA2->A2_INSCR,oFont11)
nLinha:= 850
oPrint:Line(nLinha,100,nLinha,2300)
oPrint:Line(nLinha,100,nLinha+70,100)
oPrint:Line(nLinha,240,nLinha+70,240)
oPrint:Line(nLinha,440,nLinha+70,440)
oPrint:Line(nLinha,1130,nLinha+70,1130)
oPrint:Line(nLinha,1380,nLinha+70,1380)
oPrint:Line(nLinha,1480,nLinha+70,1480)
oPrint:Line(nLinha,1750,nLinha+70,1750)
oPrint:Line(nLinha,2040,nLinha+70,2040)
oPrint:Line(nLinha,2300,nLinha+70,2300)
oPrint:Say(nLinha,0120,OemToAnsi('Item'),oFont12)
oPrint:Say(nLinha,0260,OemToAnsi('C๓digo'),oFont12)
oPrint:Say(nLinha,0460,OemToAnsi('Descri็ใo'),oFont12)
oPrint:Say(nLinha,1140,OemToAnsi('Dt.Entrega'),oFont12)
oPrint:Say(nLinha,1400,OemToAnsi('UM'),oFont12)
oPrint:Say(nLinha,1500,OemToAnsi('Quantidade'),oFont12)
oPrint:Say(nLinha,1850,OemToAnsi('Vlr.Unit.'),oFont12)
oPrint:Say(nLinha,2050,OemToAnsi('Valor Total'),oFont12)
nLinha += 70
oPrint:Line(nLinha,100,nLinha,2300)
nCountReg := 1
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xRodape()บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Rodape do Relatorio....                          บฑฑ
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
Static Function xRodape()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime o Contato da Greenpharma.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SY1->(dbSetOrder(3))
SY1->(dbSeek(xFilial("SY1")+_cUser))
If ( ! Empty(_cUser) )
  oPrint:Say(2800,0500,'_____________________________________________________________',oFont12n)
  oPrint:Say(2850,0800,SY1->Y1_NOME,oFont12n)
  oPrint:Say(2900,0800,SY1->Y1_TEL,oFont12n)
  If _cUser == "000085"
    oPrint:Say(2950,0800,SY1->Y1_EMAIL+".br",oFont12n)
  Else
    oPrint:Say(2950,0800,SY1->Y1_EMAIL,oFont12n)
  EndIf
EndIf
oPrint:Line(3200,0100,3200,2300)
oPrint:Say(3230,0100,AllTrim("Nota: So Aceitaremos a mercadoria se na sua nota fiscal constar o numero do nosso Pedido de Compras."))
oPrint:Line(3300,0100,3300,2300)
oPrint:EndPage()
dbSelectArea("TRA")
dbCloseArea("TRA")
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
oPrint:Line(3200,0100,3200,2300)
oPrint:Say(3230,1000,'CONTINUA NA PROXIMA PAGINA')
oPrint:Line(3300,0100,3300,2300)
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
  oPrint:Line(3200,0100,3200,2300)
  oPrint:Say(3230,1000,'CONTINUA NA PROXIMA PAGINA')
  oPrint:Line(3300,0100,3300,2300)
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
cPerg := PADR(cPerg,6)

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

  Private	cNumPed  	:= mv_par01			// Numero do Pedido de Compras
  Private	lImpPrc		:= (mv_par02==2)	// Imprime os Precos ?
  Private	nTitulo 	:= mv_par03  			// Titulo do Relatorio ?
  Private	cObserv1	:= mv_par04	   		// 1a Linha de Observacoes
  Private	cObserv2	:= mv_par05		  	   // 1a Linha de Observacoes
  Private	cObserv3	:= mv_par06		    	// 1a Linha de Observacoes
  Private	cObserv4	:= mv_par07			   // 1a Linha de Observacoes
