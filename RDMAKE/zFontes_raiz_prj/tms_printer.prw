///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | TMS_Printer.prw      | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - TMS_Printer()                                          |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Este fonte demonstra a utilizacao da funcao TMSPrinter e MsBar()|//
//|           | que eh a impressao de codigo de barra.                          |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"

USER FUNCTION COMGEFCO()
LOCAL oDlg := NIL

PRIVATE cTitulo := "Impressão - Relatorio de compras Gefco"
PRIVATE oPrn    := NIL
PRIVATE oFont1  := NIL
PRIVATE oFont2  := NIL
PRIVATE oFont3  := NIL
PRIVATE oFont4  := NIL
PRIVATE oFont5  := NIL
PRIVATE oFont6  := NIL

DEFINE FONT oFont1 NAME "Arial" SIZE 0,07 OF oPrn
DEFINE FONT oFont2 NAME "Arial" SIZE 0,09 OF oPrn BOLD
DEFINE FONT oFont3 NAME "Arial" SIZE 0,14 OF oPrn BOLD
DEFINE FONT oFont4 NAME "Arial" SIZE 0,08 OF oPrn BOLD
DEFINE FONT oFont5 NAME "Arial" SIZE 0,16 OF oPrn BOLD
DEFINE FONT oFont6 NAME "Courier New" BOLD

oPrn := TMSPrinter():New(cTitulo)
//oPrn:SetLandsCape()
oPrn:SetPortrait() // SetLandscape
oPrn:StartPage()
Imprimir()
oPrn:EndPage()
oPrn:End()

DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 015,017 SAY "Esta rotina tem por objetivo imprimir " OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 030,017 SAY "o movimento de compras no periodo.    " OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 045,017 SAY "    GEFCO LOGISTICA DO BRASIL         " OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE

@  6,167 BUTTON "&Imprime" SIZE 036,012 ACTION oPrn:Print()   OF oDlg PIXEL
@ 28,167 BUTTON "&Setup"   SIZE 036,012 ACTION oPrn:Setup()   OF oDlg PIXEL
@ 49,167 BUTTON "Pre&view" SIZE 036,012 ACTION oPrn:Preview() OF oDlg PIXEL
@ 70,167 BUTTON "Sai&r"    SIZE 036,012 ACTION oDlg:End()     OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

oPrn:End()

Return

STATIC FUNCTION Imprimir()
LayOutSup()
oPrn:EndPage()
Ms_Flush()
Return

STATIC FUNCTION LayOutSup()

/*
// horizontais da folha recibo, parte superior
oPrn:Line(0150,0080,0150,0790)
oPrn:Line(0260,0080,0260,0790)
oPrn:Line(0330,0080,0330,0790)
oPrn:Line(0400,0080,0400,0790)
oPrn:Line(0470,0080,0470,0790)
oPrn:Line(0540,0080,0540,0790)
oPrn:Line(0610,0080,0610,0790)
oPrn:Line(0680,0080,0680,0790)
oPrn:Line(0750,0080,0750,0790)
oPrn:Line(0820,0080,0820,0790)
oPrn:Line(0890,0080,0890,0790)
oPrn:Line(0960,0080,0960,0790)
oPrn:Line(1030,0080,1030,0790)
oPrn:Line(1100,0080,1100,0790)

// Riscos horizontais da folha ficha de compensacao, parte superior
oPrn:Line(0150,1050,0150,3330)
oPrn:Line(0260,1050,0260,3330)
oPrn:Line(0330,1050,0330,3330)
oPrn:Line(0400,1050,0400,3330)
oPrn:Line(0470,1050,0470,3330)
oPrn:Line(0820,1050,0820,3330)
oPrn:Line(0960,1050,0960,3330)

// Riscos horizontais para valores da folha ficha de compensacao, parte superior
oPrn:Line(0540,2570,0540,3330)
oPrn:Line(0610,2570,0610,3330)
oPrn:Line(0680,2570,0680,3330)
oPrn:Line(0750,2570,0750,3330)

// Risco maior na vertical da folha ficha de compensacao, parte superior
oPrn:Line(0150,2570,0821,2570)

// Riscos na vertical pequenos que dividem os campos, parte superior
oPrn:Line(0080,0430,0150,0430)
oPrn:Line(0080,0570,0150,0570)
oPrn:Line(0330,0410,0400,0410)
oPrn:Line(0470,0410,0540,0410)

oPrn:Line(0080,1450,0150,1450)
oPrn:Line(0080,1590,0150,1590)

oPrn:Line(0330,1330,0400,1330)
oPrn:Line(0330,1860,0400,1860)
oPrn:Line(0330,2060,0400,2060)
oPrn:Line(0330,2190,0400,2190)

oPrn:Line(0400,1240,0470,1240)
oPrn:Line(0400,1430,0470,1430)
oPrn:Line(0400,1590,0470,1590)
oPrn:Line(0400,2060,0435,2060)
*/

ini  := 80 //20
nLin := 200
int  := 80

cBitMap:= "msmdilogo.bmp"
//oPrn:SayBitmap(1060,085,cBitMap,650,070)
//oPrn:SayBitmap(600,150,cBitmap,600,150) // original largura 600 altura 150 //100-100

oPrn:Say(nLin,20," ",oFont6,100)
//oPrn:SayBitmap(30,30,cBitmap,600,150) // original largura 600 altura 150 //100-100
oPrn:SayBitmap(10,2800,cBitmap,100,100) //200
//oPrn:SayBitmap(10,2800,cBitmap,274,200) //200


// Texto fixo da parte superior, recibo
oPrn:Say(080,080,"RELATORIO DE COMPRAS GEFCO (FEVEREIRO 2006) " + SZ4->Z4_UO,oFont5)
//oPrn:Say(0080,0080,"RELATORIO DE COMPRAS GEFCO (FEVEREIRO 2006)" + SZ4->Z4_UO,oFont5)

nLin := nLin + int
oPrn:Say(nLin,ini,"U.O. |   Filial   |  Atividade  " ,oFont2)
nLin := nLin + int

// Declaracao de variaveis utilizadas na Impressao
_cCab1   := "GEFCO LOGISTICA DO BRASIL   L T D A"
_cCab2   := "Praça XV de Novembro 20, 4 Andar"
_cCab3   := "CEP: 22020-010 Fone: (21)2103-8110 Faxes: (21)2103-8100 / (21)2103-8100"
_cCab4   := "Site: www.gefco.com.br"

//oPrn:Box(1050,730,1135,731)

dbSelectArea("SZ4")
dbSetOrder(1) // 1
dbGoTop()
//Dbseek(xFilial("SZ4")+Alltrim(MV_PAR05))

While !EOF() //.And. Alltrim(SZ4->Z4_COD) ==  Alltrim(MV_PAR05) //.And. SZ2->Z2_CODPLA == "015"
    
    //oPrn:Box(300,30,350,300)
	oPrn:Say(nLin,ini,SZ4->Z4_COD,oFont2)
	oPrn:Say(nLin,ini+100,SZ4->Z4_CONTA,oFont2)
	oPrn:Say(nLin,ini+200,SZ4->Z4_FILORIG,oFont2)
	oPrn:Say(nLin,ini+300,SZ4->Z4_ATIVIDA,oFont2)
	oPrn:Say(nLin,ini+400,SZ4->Z4_DESCR,oFont2)
	oPrn:Say(nLin,ini+750,Trans(SZ4->Z4_SALDO,"@E@R 999,999,999.99"),oFont2)
	//oPrn:Say(nLin,ini+750,STR(SZ4->Z4_SALDO),oFont2)
    

	nLin := nLin + int
    Dbskip()

Enddo

nLin := nLin + int

nLin := nLin + int 
oPrn:Say(nLin,ini+650,_cCab1,oFont2,100)//400
nLin := nLin + int - 20 
oPrn:Say(nLin,ini+650,_cCab2,oFont2,100)
nLin := nLin + int - 20
oPrn:Say(nLin,ini+650,_cCab3,oFont2,100)
nLin := nLin + int - 20
oPrn:Say(nLin,ini+650,_cCab4,oFont2,100)
nLin := nLin + int 
oPrn:Box(1000,500,1000,500)
	        

/*

oPrn:Say(0545,0090,"Nº do Documento",oFont1)
oPrn:Say(0615,0090,"Nosso Número",oFont1)
oPrn:Say(0685,0090,"(=) Valor do Documento",oFont1)
oPrn:Say(0755,0090,"(-) Desconto/Abatimento",oFont1)
oPrn:Say(0825,0090,"(-) Outras Deduções",oFont1)
oPrn:Say(0895,0090,"(+) Mora/Multa",oFont1)
oPrn:Say(0965,0090,"(+) Outros Acréscimo",oFont1)
oPrn:Say(1035,0090,"(=) Valor Cobrado",oFont1)
oPrn:SayBitmap(0405,0800,"AUTENTIC.BMP",30,310)

// Texto fixo da parte superior, compensacao
oPrn:Say(0080,1050,"Nossa Caixa",oFont5)
oPrn:Say(0080,1460,"Banco",oFont1)
oPrn:Say(0155,1060,"Local de Pagamento",oFont1)
oPrn:Say(0155,2580,"Vencimento",oFont1)
oPrn:Say(0265,1060,"Cedente",oFont1)
oPrn:Say(0265,2580,"Agência/Código Cedente",oFont1)
oPrn:Say(0335,1060,"Data Documento",oFont1)
oPrn:Say(0335,1340,"Nº do Documento",oFont1)
oPrn:Say(0335,1870,"Espécie Doc.",oFont1)
oPrn:Say(0335,2070,"Aceite",oFont1)
oPrn:Say(0335,2200,"Data Processamento",oFont1)
oPrn:Say(0335,2580,"Nosso Número",oFont1)
oPrn:Say(0405,1060,"Uso do Banco",oFont1)
oPrn:Say(0405,1250,"Carteira",oFont1)
oPrn:Say(0405,1440,"Espécie",oFont1)
oPrn:Say(0405,1600,"Quantidade",oFont1)
oPrn:Say(0440,2050,"X",oFont4)
oPrn:Say(0405,2100,"Valor",oFont1)
oPrn:Say(0405,2580,"(=) Valor do Documento",oFont1)
oPrn:Say(0475,1060,"Instruções (Texto de Responsabilidade do Cedente)",oFont1)
oPrn:Say(0475,2580,"(-) Desconto/Abatimento",oFont1)
oPrn:Say(0545,2580,"(-) Outras Deduções",oFont1)
oPrn:Say(0615,2580,"(+) Mora/Multa",oFont1)
oPrn:Say(0685,2580,"(+) Outros Acréscimo",oFont1)
oPrn:Say(0755,2580,"(=) Valor Cobrado",oFont1)
oPrn:Say(0825,1060,"Sacado",oFont1)
oPrn:Say(0930,1060,"Sacador/Avalista",oFont1)
oPrn:Say(0930,2580,"Código de Baixa",oFont1)
oPrn:Say(0965,2400,"Autênticação Mecânica",oFont1)
oPrn:Say(0965,2970,"Ficha de Compensação",oFont2)

// Texto variado do recibo, parte superior
oPrn:Say(0120,0450,"151-1",oFont4)
oPrn:Say(0200,0090,Trim(SM0->M0_NOME),oFont4)
oPrn:Say(0230,0090,Trim(SM0->M0_NOMECOM),oFont4)
oPrn:Say(0300,0090,"JOSE DA SILVA",oFont4)
oPrn:Say(0370,0250,"1/10",oFont4)
oPrn:Say(0370,0550,"29/01/2003",oFont4)
oPrn:Say(0440,0400,"0573-8 13 0000115-7",oFont4)
oPrn:Say(0510,0250,"UFESP",oFont4)
oPrn:Say(0510,0550,"10",oFont4)
oPrn:Say(0580,0400,"001845-02",oFont4)
oPrn:Say(0650,0400,"990184501-8",oFont4)
oPrn:Say(0720,0400,"R$ 105,20",oFont4)

// Texto variado da ficha de compensacao, parte superior
oPrn:Say(0080,1650,"15189.90187 45010.573306 00115.151375 3 10",oFont5)
oPrn:Say(0120,1470,"151-1",oFont4)
oPrn:Say(0200,1060,"TEXTO 1 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0230,1060,"TEXTO 2 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0215,2800,"29/01/2003",oFont4)
oPrn:Say(0300,1060,Trim(SM0->M0_NOME)+" - "+Trim(SM0->M0_NOMECOM),oFont4)
oPrn:Say(0300,2800,"0573-8 13 0000115-7",oFont4)
oPrn:Say(0370,1060,"11/12/2002",oFont4)
oPrn:Say(0370,1350,"001845-02",oFont4)
oPrn:Say(0370,1880,"NP",oFont4)
oPrn:Say(0370,2080,"S",oFont4)
oPrn:Say(0370,2210,"11/12/2002",oFont4)
oPrn:Say(0370,2800,"990184501-8",oFont4)
oPrn:Say(0440,1260,"CIDEN",oFont4)
oPrn:Say(0440,1450,"UFESP",oFont4)
oPrn:Say(0440,1670,"10",oFont4)
oPrn:Say(0440,2110,"R$ 10,52",oFont4)
oPrn:Say(0440,2800,"R$ 105,20",oFont4)
oPrn:Say(0500,1060,"- TEXTO 1 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0535,1060,"- TEXTO 2 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0570,1060,"- TEXTO 3 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0605,1060,"- TEXTO 4 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0640,1060,"- TEXTO 5 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0675,1060,"- TEXTO 6 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0710,1060,"- TEXTO 7 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0745,1060,"- TEXTO 8 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0780,1060,"- TEXTO 9 COM ATE 80 CARACTERES...",oFont4)
oPrn:Say(0825,1170,"JOSE DA SILVA",oFont4)
oPrn:Say(0860,1170,"RUA PLANALTO CENTRAL, 1000 - ASA NORTE",oFont4)
oPrn:Say(0895,1170,"07121-390 - SAO PAULO - SP",oFont4)
oPrn:Say(0930,1270,Trim(SM0->M0_NOME)+" - "+Trim(SM0->M0_NOMECOM),oFont4)
MSBAR("INT25",8.9,9.4,"15189901874501057330600115151375310",oPrn,.F.,,.T.,0.025,1.3,NIL,NIL,NIL,.F.)

*/

Return
