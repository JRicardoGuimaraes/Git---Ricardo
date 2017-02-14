#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEFCTB04  º Autor ³ VENDAS GEFCO       º Data ³  05/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Vendas Gefco para o Rel.Gerencial                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gefco                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Adicionada vendas por atividade - Saulo Muniz 03/02/06
// Adicionada Log de erro (centro de custo dig.errado) - Saulo Muniz 03/02/06

User Function GEFCTB04

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Relatorio Vendas Gefco"
Local cPict        := ""
Local titulo       := "Relatorio Vendas Gefco"
Local nLin         := 80
Local Cabec1       := "|     RELATORIO DE VENDAS - GEFCO     | REF. " 
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 80 //132
Private tamanho    := "P" //"G"
Private nomeprog   := "GEFCTB04" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GEFCTB04" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "CTS"
Private cPerg      := "GEF040"

If !Pergunte(cPerg,.T.)                           // Pergunta no SX1
   Return
EndIf

Cabec1 := Cabec1 + Dtoc(MV_PAR01) + " - " + Dtoc(MV_PAR02)
wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  14/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

// ESPECIFICICAÇAO DAS VARIAVES :
// nAtv301a (nAtv30101a) = Atividade 301 ; 01 = Filial ; a terminação (a) significa venda fora grupo, (b) vendas grupo gefco, (c) vendas PSA 
//

Store 0 To xCatRdvm1,xCatRdvm2,xCatRdvm3,xCatRdvm4,xCatRma1,xCatRma2,xCatRma3,xCatRma4,xCatIli1,xCatIli2,xCatIli3,xCatIli4
Store 0 To xCatRmlap1,xCatRmlap2,xCatRmlap3,xCatRmlap4,nDifa,nDlpr,nTerc,nDifaRdvm,nDlprRdvm,nTercRdvm,nDifaIli,nDlprIli
Store 0 To nTercIli,nDifaRmlap,nDlprRmlap,nTercRmlap,nDifaRma,nDlprRma,nTercRma,nDifRma,nDifRmlap,nDifRdvm,nDifIli
Store 0 To xCat1,xCat2,xCat3,xCat4,nDesc,nIss,nIcms,nIpi,nValor,nSaldo,nRdvm,nRma,nRmlap,nIli,IRdvm1,IRdvm2,IRdvm3,IRdvm4
Store 0 To Iili1,Iili2,Iili3,Iili4,Irdvm,Iili,Irma,Irmlap,Irmlap1,Irmlap2,Irmlap3,Irmlap4,Irma1,Irma2,Irma3,Irma4,nMarcaAC,nMarcaAP
Store 0 To nAtv001,nAtv002,nAtv003,nAtv004,nAtv005,nAtv006,nAtv007,nAtv008,nAtv009,nAtv010,nAtv011,nAtv012,nAtv013,nAtvout
Store 0 To nAtv101,nAtv102,nAtv201,nAtv202,nAtv203,nAtv204,nAtv205,nAtv206,nAtv207,nAtv208,nAtv209,nAtv210,nAtv401,nAtv402,nAtv403
Store 0 To nAtv404,nAtv405,nAtv406,nAtv407,nAtv408,nAtv501,nAtv502,nAtv503,nAtv504,nAtv505,nAtv506,nAtv507,nAtv508
Store 0 To nAtv301,nAtv302,nAtv303,nAtv304,nAtv305,nAtv306,nAtv307,nTotRdvm,nTotRma,nTotRmlap,nTotIli,nTotaduana,nTotpvn
Store 0 To nGrupIli,nGrupRdvm,nGruprma,nGruprmlap,nTercIli,nTercRma,nTerRmlap,xFilCtb,nAtv20110,nAtv20210,nAtv20310,nAtv20410,nAtv20510,nAtv20610,nAtv20710,nAtv20810,nAtv20910,nAtv21010
Store 0 To nAtv20102,nAtv20202,nAtv20302,nAtv20402,nAtv20502,nAtv20602,nAtv20702,nAtv20802,nAtv20902,nAtv21002,nAtv20103,nAtv20203,nAtv20303,nAtv20403,nAtv20503,nAtv20603,nAtv20703,nAtv20803,nAtv20903,nAtv21003
Store 0 To nAtv20104,nAtv20204,nAtv20304,nAtv20404,nAtv20504,nAtv20604,nAtv20704,nAtv20804,nAtv20904,nAtv21004,nAtv20105,nAtv20205,nAtv20305,nAtv20405,nAtv20505,nAtv20605,nAtv20705,nAtv20805,nAtv20905,nAtv21005
Store 0 To nAtv20106,nAtv20206,nAtv20306,nAtv20406,nAtv20506,nAtv20606,nAtv20706,nAtv20806,nAtv20906,nAtv21006,nAtv20107,nAtv20207,nAtv20307,nAtv20407,nAtv20507,nAtv20607,nAtv20707,nAtv20807,nAtv20907,nAtv21007
Store 0 To nAtv20108,nAtv20208,nAtv20308,nAtv20408,nAtv20508,nAtv20608,nAtv20708,nAtv20808,nAtv20908,nAtv21008,nAtv20109,nAtv20209,nAtv20309,nAtv20409,nAtv20509,nAtv20609,nAtv20709,nAtv20809,nAtv20909,nAtv21009
Store 0 To nAtv20111,nAtv20211,nAtv20311,nAtv20411,nAtv20511,nAtv20611,nAtv20711,nAtv20811,nAtv20911,nAtv21011,nAtv20112,nAtv20212,nAtv20312,nAtv20412,nAtv20512,nAtv20609,nAtv20712,nAtv20812,nAtv20912,nAtv21012
Store 0 To nAtv20113,nAtv20213,nAtv20313,nAtv20413,nAtv20513,nAtv20613,nAtv20713,nAtv20813,nAtv20913,nAtv21013,nAtv20114,nAtv20214,nAtv20314,nAtv20414,nAtv20514,nAtv20614,nAtv20714,nAtv20814,nAtv20914,nAtv21014
Store 0 To nAtv20115,nAtv20215,nAtv20315,nAtv20415,nAtv20515,nAtv20615,nAtv20715,nAtv20815,nAtv20915,nAtv21015                                                                                                    

Store 0 To n01A551,n02A551,n03A551,n04A551,n05A551,n06A551,n07A551,n08A551,n09A551,n10A551,n11A551,n12A551,n13A551,n14A551,n15A551
Store 0 To n01A553,n02A553,n03A553,n04A553,n05A553,n06A553,n07A553,n08A553,n09A553,n10A553,n11A553,n12A553,n13A553,n14A553,n15A553  
Store 0 To n01A501,n02A501,n03A501,n04A501,n05A501,n06A501,n07A501,n08A501,n09A501,n10A501,n11A501,n12A501,n13A501,n14A501,n15A501
Store 0 To n01A507,n02A507,n03A507,n04A507,n05A507,n06A507,n07A507,n08A507,n09A507,n10A507,n11A507,n12A507,n13A507,n14A507,n15A507  
Store 0 To n01A561,n02A561,n03A561,n04A561,n05A561,n06A561,n07A561,n08A561,n09A561,n10A561,n11A561,n12A561,n13A561,n14A561,n15A561   

Store 0 To nAtv201a,nAtv202a,nAtv203a,nAtv204a,nAtv205a,nAtv206a,nAtv207a,nAtv208a,nAtv209a,nAtv210a,nAtv201b,nAtv202b,nAtv203b,nAtv204b,nAtv205b,nAtv206b,nAtv207b,nAtv208b,nAtv209b,nAtv210b,nAtv201c,nAtv202c
Store 0 To nAtv203c,nAtv204c,nAtv205c,nAtv206c,nAtv207c,nAtv208c,nAtv209c,nAtv210c

Store 0 To nAtv20102a,nAtv20202a,nAtv20302a,nAtv20402a,nAtv20502a,nAtv20602a,nAtv20702a,nAtv20802a,nAtv20902a,nAtv21002a,nAtv20103a,nAtv20203a,nAtv20303a,nAtv20403a,nAtv20503a,nAtv20603a,nAtv20703a,nAtv20803a,nAtv20903a,nAtv21003a
Store 0 To nAtv20104a,nAtv20204a,nAtv20304a,nAtv20404a,nAtv20504a,nAtv20604a,nAtv20704a,nAtv20804a,nAtv20904a,nAtv21004a,nAtv20105a,nAtv20205a,nAtv20305a,nAtv20405a,nAtv20505a,nAtv20605a,nAtv20705a,nAtv20805a,nAtv20905a,nAtv21005a
Store 0 To nAtv20106a,nAtv20206a,nAtv20306a,nAtv20406a,nAtv20506a,nAtv20606a,nAtv20706a,nAtv20806a,nAtv20906a,nAtv21006a,nAtv20107a,nAtv20207a,nAtv20307a,nAtv20407a,nAtv20507a,nAtv20607a,nAtv20707a,nAtv20807a,nAtv20907a,nAtv21007a
Store 0 To nAtv20108a,nAtv20208a,nAtv20308a,nAtv20408a,nAtv20508a,nAtv20608a,nAtv20708a,nAtv20808a,nAtv20908a,nAtv21008a,nAtv20109a,nAtv20209a,nAtv20309a,nAtv20409a,nAtv20509a,nAtv20609a,nAtv20709a,nAtv20809a,nAtv20909a,nAtv21009a
Store 0 To nAtv20110a,nAtv20210a,nAtv20310a,nAtv20410a,nAtv20510a,nAtv20610a,nAtv20710a,nAtv20810a,nAtv20910a,nAtv21010a,nAtv20112a,nAtv20212a,nAtv20312a,nAtv20412a,nAtv20512a,nAtv20612a,nAtv20712a,nAtv20812a,nAtv20912a,nAtv21012a
Store 0 To nAtv20113a,nAtv20213a,nAtv20313a,nAtv20413a,nAtv20513a,nAtv20613a,nAtv20713a,nAtv20813a,nAtv20913a,nAtv21013a,nAtv20114a,nAtv20214a,nAtv20314a,nAtv20414a,nAtv20514a,nAtv20614a,nAtv20714a,nAtv20814a,nAtv20914a,nAtv21014a
Store 0 To nAtv20111a,nAtv20211a,nAtv20311a,nAtv20411a,nAtv20511a,nAtv20611a,nAtv20711a,nAtv20811a,nAtv20911a,nAtv21011a,nAtv20115a,nAtv20215a,nAtv20315a,nAtv20415a,nAtv20515a,nAtv20615a,nAtv20715a,nAtv20815a,nAtv20915a,nAtv21015a

Store 0 To nAtv20102b,nAtv20202b,nAtv20302b,nAtv20402b,nAtv20502b,nAtv20602b,nAtv20702b,nAtv20802b,nAtv20902b,nAtv21002b,nAtv20103b,nAtv20203b,nAtv20303b,nAtv20403b,nAtv20503b,nAtv20603b,nAtv20703b,nAtv20803b,nAtv20903b,nAtv21003b
Store 0 To nAtv20104b,nAtv20204b,nAtv20304b,nAtv20404b,nAtv20504b,nAtv20604b,nAtv20704b,nAtv20804b,nAtv20904b,nAtv21004b,nAtv20105b,nAtv20205b,nAtv20305b,nAtv20405b,nAtv20505b,nAtv20605b,nAtv20705b,nAtv20805b,nAtv20905b,nAtv21005b
Store 0 To nAtv20106b,nAtv20206b,nAtv20306b,nAtv20406b,nAtv20506b,nAtv20606b,nAtv20706b,nAtv20806b,nAtv20906b,nAtv21006b,nAtv20107b,nAtv20207b,nAtv20307b,nAtv20407b,nAtv20507b,nAtv20607b,nAtv20707b,nAtv20807b,nAtv20907b,nAtv21007b
Store 0 To nAtv20108b,nAtv20208b,nAtv20308b,nAtv20408b,nAtv20508b,nAtv20608b,nAtv20708b,nAtv20808b,nAtv20908b,nAtv21008b,nAtv20109b,nAtv20209b,nAtv20309b,nAtv20409b,nAtv20509b,nAtv20609b,nAtv20709b,nAtv20809b,nAtv20909b,nAtv21009b
Store 0 To nAtv20111b,nAtv20211b,nAtv20311b,nAtv20411b,nAtv20511b,nAtv20611b,nAtv20711b,nAtv20811b,nAtv20911b,nAtv21011b,nAtv20112b,nAtv20212b,nAtv20312b,nAtv20412b,nAtv20512b,nAtv20612b,nAtv20712b,nAtv20812b,nAtv20912b,nAtv21012b
Store 0 To nAtv20113b,nAtv20213b,nAtv20313b,nAtv20413b,nAtv20513b,nAtv20613b,nAtv20713b,nAtv20813b,nAtv20913b,nAtv21013b,nAtv20114b,nAtv20214b,nAtv20314b,nAtv20414b,nAtv20514b,nAtv20614b,nAtv20714b,nAtv20814b,nAtv20914b,nAtv21014b
Store 0 To nAtv20110b,nAtv20210b,nAtv20310b,nAtv20410b,nAtv20510b,nAtv20610b,nAtv20710b,nAtv20810b,nAtv20910b,nAtv21010b,nAtv20115b,nAtv20215b,nAtv20315b,nAtv20415b,nAtv20515b,nAtv20615b,nAtv20715b,nAtv20815b,nAtv20915b,nAtv21015b

Store 0 To nAtv20102c,nAtv20202c,nAtv20302c,nAtv20402c,nAtv20502c,nAtv20602c,nAtv20702c,nAtv20802c,nAtv20902c,nAtv21002c,nAtv20103c,nAtv20203c,nAtv20303c,nAtv20403c,nAtv20503c,nAtv20603c,nAtv20703c,nAtv20803c,nAtv20903c,nAtv21003c
Store 0 To nAtv20104c,nAtv20204c,nAtv20304c,nAtv20404c,nAtv20504c,nAtv20604c,nAtv20704c,nAtv20804c,nAtv20904c,nAtv21004c,nAtv20105c,nAtv20205c,nAtv20305c,nAtv20405c,nAtv20505c,nAtv20605c,nAtv20705c,nAtv20805c,nAtv20905c,nAtv21005c
Store 0 To nAtv20106c,nAtv20206c,nAtv20306c,nAtv20406c,nAtv20506c,nAtv20606c,nAtv20706c,nAtv20806c,nAtv20906c,nAtv21006c,nAtv20107c,nAtv20207c,nAtv20307c,nAtv20407c,nAtv20507c,nAtv20607c,nAtv20707c,nAtv20807c,nAtv20907c,nAtv21007c
Store 0 To nAtv20108c,nAtv20208c,nAtv20308c,nAtv20408c,nAtv20508c,nAtv20608c,nAtv20708c,nAtv20808c,nAtv20908c,nAtv21008c,nAtv20109c,nAtv20209c,nAtv20309c,nAtv20409c,nAtv20509c,nAtv20609c,nAtv20709c,nAtv20809c,nAtv20909c,nAtv21009c
Store 0 To nAtv20110c,nAtv20210c,nAtv20310c,nAtv20410c,nAtv20510c,nAtv20610c,nAtv20710c,nAtv20810c,nAtv20910c,nAtv21010cn,Atv20111c,nAtv20211c,nAtv20311c,nAtv20411c,nAtv20511c,nAtv20611c,nAtv20711c,nAtv20811c,nAtv20911c,nAtv21011c
Store 0 To nAtv20111c,nAtv20211c,nAtv20311c,nAtv20411c,nAtv20511c,nAtv20611c,nAtv20711c,nAtv20811c,nAtv20911c,nAtv21011c,nAtv20112c,nAtv20212c,nAtv20312c,nAtv20412c,nAtv20512c,nAtv20612c,nAtv20712c,nAtv20812c,nAtv20912c,nAtv21012c
Store 0 To nAtv20113c,nAtv20213c,nAtv20313c,nAtv20413c,nAtv20513c,nAtv20613c,nAtv20713c,nAtv20813c,nAtv20913c,nAtv21013c,nAtv20114c,nAtv20214c,nAtv20314c,nAtv20414c,nAtv20514c,nAtv20614c,nAtv20714c,nAtv20814c,nAtv20914c,nAtv21014c
Store 0 To nAtv20115c,nAtv20215c,nAtv20315c,nAtv20415c,nAtv20515c,nAtv20615c,nAtv20715c,nAtv20815c,nAtv20915c,nAtv21015c


Store 0 To p01A551,p02A551,p03A551,p04A551,p05A551,p06A551,p07A551,p08A551,p09A551,p10A551,p11A551,p12A551,p13A551,p14A551,p15A551
Store 0 To p01A553,p02A553,p03A553,p04A553,p05A553,p06A553,p07A553,p08A553,p09A553,p10A553,p11A553,p12A553,p13A553,p14A553,p15A553
Store 0 To p01A501,p02A501,p03A501,p04A501,p05A501,p06A501,p07A501,p08A501,p09A501,p10A501,p11A501,p12A501,p13A501,p14A501,p15A501
Store 0 To p01A507,p02A507,p03A507,p04A507,p05A507,p06A507,p07A507,p08A507,p09A507,p10A507,p11A507,p12A507,p13A507,p14A507,p15A507  
Store 0 To p01A561,p02A561,p03A561,p04A561,p05A561,p06A561,p07A561,p08A561,p09A561,p10A561,p11A561,p12A561,p13A561,p14A561,p15A561 
Store 0 To g01A551,g02A551,g03A551,g04A551,g05A551,g06A551,g07A551,g08A551,g09A551,g10A551,g11A551,g12A551,g13A551,g14A551,g15A551
Store 0 To g01A553,g02A553,g03A553,g04A553,g05A553,g06A553,g07A553,g08A553,g09A553,g10A553,g11A553,g12A553,g13A553,g14A553,g15A553 
Store 0 To g01A501,g02A501,g03A501,g04A501,g05A501,g06A501,g07A501,g08A501,g09A501,g10A501,g11A501,g12A501,g13A501,g14A501,g15A501
Store 0 To g01A507,g02A507,g03A507,g04A507,g05A507,g06A507,g07A507,g08A507,g09A507,g10A507,g11A507,g12A507,g13A507,g14A507,g15A507  
Store 0 To g01A561,g02A561,g03A561,g04A561,g05A561,g06A561,g07A561,g08A561,g09A561,g10A561,g11A561,g12A561,g13A561,g14A561,g15A561 
Store 0 To f01A551,f02A551,f03A551,f04A551,f05A551,f06A551,f07A551,f08A551,f09A551,f10A551,f11A551,f12A551,f13A551,f14A551,f15A551
Store 0 To f01A553,f02A553,f03A553,f04A553,f05A553,f06A553,f07A553,f08A553,f09A553,f10A553,f11A553,f12A553,f13A553,f14A553,f15A553 
Store 0 To f01A501,f02A501,f03A501,f04A501,f05A501,f06A501,f07A501,f08A501,f09A501,f10A501,f11A501,f12A501,f13A501,f14A501,f15A501
Store 0 To f01A507,f02A507,f03A507,f04A507,f05A507,f06A507,f07A507,f08A507,f09A507,f10A507,f11A507,f12A507,f13A507,f14A507,f15A507  
Store 0 To f01A561,f02A561,f03A561,f04A561,f05A561,f06A561,f07A561,f08A561,f09A561,f10A561,f11A561,f12A561,f13A561,f14A561,f15A561 

// ILI
Store 0 To nAtv30101a,nAtv30101b,nAtv30101c,nAtv30201a,nAtv30201b,nAtv30201c,nAtv30301a,nAtv30301b,nAtv30301c,nAtv30401a,nAtv30401b,nAtv30401c,nAtv30501a,nAtv30501b,nAtv30501c,nAtv30601a,nAtv30601b,nAtv30601c,nAtv30701a,nAtv30701b,nAtv30701c
Store 0 To nAtv30102a,nAtv30102b,nAtv30102c,nAtv30202a,nAtv30202b,nAtv30202c,nAtv30302a,nAtv30302b,nAtv30302c,nAtv30402a,nAtv30402b,nAtv30402c,nAtv30502a,nAtv30502b,nAtv30502c,nAtv30602a,nAtv30602b,nAtv30602c,nAtv30702a,nAtv30702b,nAtv30702c
Store 0 To nAtv30103a,nAtv30103b,nAtv30103c,nAtv30203a,nAtv30203b,nAtv30203c,nAtv30303a,nAtv30303b,nAtv30303c,nAtv30403a,nAtv30403b,nAtv30403c,nAtv30503a,nAtv30503b,nAtv30503c,nAtv30603a,nAtv30603b,nAtv30603c,nAtv30703a,nAtv30703b,nAtv30703c
Store 0 To nAtv30104a,nAtv30104b,nAtv30104c,nAtv30204a,nAtv30204b,nAtv30204c,nAtv30304a,nAtv30304b,nAtv30304c,nAtv30404a,nAtv30404b,nAtv30404c,nAtv30504a,nAtv30504b,nAtv30504c,nAtv30604a,nAtv30604b,nAtv30604c,nAtv30704a,nAtv30704b,nAtv30704c
Store 0 To nAtv30105a,nAtv30105b,nAtv30105c,nAtv30205a,nAtv30205b,nAtv30205c,nAtv30305a,nAtv30305b,nAtv30305c,nAtv30405a,nAtv30405b,nAtv30405c,nAtv30505a,nAtv30505b,nAtv30505c,nAtv30605a,nAtv30605b,nAtv30605c,nAtv30705a,nAtv30705b,nAtv30705c
Store 0 To nAtv30106a,nAtv30106b,nAtv30106c,nAtv30206a,nAtv30206b,nAtv30206c,nAtv30306a,nAtv30306b,nAtv30306c,nAtv30406a,nAtv30406b,nAtv30406c,nAtv30506a,nAtv30506b,nAtv30506c,nAtv30606a,nAtv30606b,nAtv30606c,nAtv30706a,nAtv30706b,nAtv30706c
Store 0 To nAtv30107a,nAtv30107b,nAtv30107c,nAtv30207a,nAtv30207b,nAtv30207c,nAtv30307a,nAtv30307b,nAtv30307c,nAtv30407a,nAtv30407b,nAtv30407c,nAtv30507a,nAtv30507b,nAtv30507c,nAtv30607a,nAtv30607b,nAtv30607c,nAtv30707a,nAtv30707b,nAtv30707c
Store 0 To nAtv30108a,nAtv30108b,nAtv30108c,nAtv30208a,nAtv30208b,nAtv30208c,nAtv30308a,nAtv30308b,nAtv30308c,nAtv30408a,nAtv30408b,nAtv30408c,nAtv30508a,nAtv30508b,nAtv30508c,nAtv30608a,nAtv30608b,nAtv30608c,nAtv30708a,nAtv30708b,nAtv30708c
Store 0 To nAtv30109a,nAtv30109b,nAtv30109c,nAtv30209a,nAtv30209b,nAtv30209c,nAtv30309a,nAtv30309b,nAtv30309c,nAtv30409a,nAtv30409b,nAtv30409c,nAtv30509a,nAtv30509b,nAtv30509c,nAtv30609a,nAtv30609b,nAtv30609c,nAtv30709a,nAtv30709b,nAtv30709c
Store 0 To nAtv30110a,nAtv30110b,nAtv30110c,nAtv30210a,nAtv30210b,nAtv30210c,nAtv30310a,nAtv30310b,nAtv30310c,nAtv30410a,nAtv30410b,nAtv30410c,nAtv30510a,nAtv30510b,nAtv30510c,nAtv30610a,nAtv30610b,nAtv30610c,nAtv30710a,nAtv30710b,nAtv30710c
Store 0 To nAtv30111a,nAtv30111b,nAtv30111c,nAtv30211a,nAtv30211b,nAtv30211c,nAtv30311a,nAtv30311b,nAtv30311c,nAtv30411a,nAtv30411b,nAtv30411c,nAtv30511a,nAtv30511b,nAtv30511c,nAtv30611a,nAtv30611b,nAtv30611c,nAtv30711a,nAtv30711b,nAtv30711c
Store 0 To nAtv30112a,nAtv30112b,nAtv30112c,nAtv30212a,nAtv30212b,nAtv30212c,nAtv30312a,nAtv30312b,nAtv30312c,nAtv30412a,nAtv30412b,nAtv30412c,nAtv30512a,nAtv30512b,nAtv30512c,nAtv30612a,nAtv30612b,nAtv30612c,nAtv30712a,nAtv30712b,nAtv30712c
Store 0 To nAtv30113a,nAtv30113b,nAtv30113c,nAtv30213a,nAtv30213b,nAtv30213c,nAtv30313a,nAtv30313b,nAtv30313c,nAtv30413a,nAtv30413b,nAtv30413c,nAtv30513a,nAtv30513b,nAtv30513c,nAtv30613a,nAtv30613b,nAtv30613c,nAtv30713a,nAtv30713b,nAtv30713c
Store 0 To nAtv30114a,nAtv30114b,nAtv30114c,nAtv30214a,nAtv30214b,nAtv30214c,nAtv30314a,nAtv30314b,nAtv30314c,nAtv30414a,nAtv30414b,nAtv30414c,nAtv30514a,nAtv30514b,nAtv30514c,nAtv30614a,nAtv30614b,nAtv30614c,nAtv30714a,nAtv30714b,nAtv30714c
Store 0 To nAtv30115a,nAtv30115b,nAtv30115c,nAtv30215a,nAtv30215b,nAtv30215c,nAtv30315a,nAtv30315b,nAtv30315c,nAtv30415a,nAtv30415b,nAtv30415c,nAtv30515a,nAtv30515b,nAtv30515c,nAtv30615a,nAtv30615b,nAtv30615c,nAtv30715a,nAtv30715b,nAtv30715c

// RMA
Store 0 To nAtv40101a,nAtv40101b,nAtv40101c,nAtv40201a,nAtv40201b,nAtv40201c,nAtv40401a,nAtv40401b,nAtv40401c,nAtv40401a,nAtv40401b,nAtv40401c,nAtv30501a,nAtv30501b,nAtv30501c,nAtv30601a,nAtv30601b,nAtv30601c,nAtv30701a,nAtv30701b,nAtv30701c
Store 0 To nAtv40102a,nAtv40102b,nAtv40102c,nAtv40202a,nAtv40202b,nAtv40202c,nAtv40402a,nAtv40402b,nAtv40402c,nAtv40402a,nAtv40402b,nAtv40402c,nAtv30502a,nAtv30502b,nAtv30502c,nAtv30602a,nAtv30602b,nAtv30602c,nAtv30702a,nAtv30702b,nAtv30702c
Store 0 To nAtv40103a,nAtv40103b,nAtv40103c,nAtv40203a,nAtv40203b,nAtv40203c,nAtv40303a,nAtv40303b,nAtv40303c,nAtv40403a,nAtv40403b,nAtv40403c,nAtv30503a,nAtv30503b,nAtv30503c,nAtv30603a,nAtv30603b,nAtv30603c,nAtv30703a,nAtv30703b,nAtv30703c
Store 0 To nAtv40104a,nAtv40104b,nAtv40104c,nAtv40204a,nAtv40204b,nAtv40204c,nAtv40404a,nAtv40404b,nAtv40404c,nAtv40404a,nAtv40404b,nAtv40404c,nAtv30504a,nAtv30504b,nAtv30504c,nAtv30604a,nAtv30604b,nAtv30604c,nAtv30704a,nAtv30704b,nAtv30704c
Store 0 To nAtv40105a,nAtv40105b,nAtv40105c,nAtv40205a,nAtv40205b,nAtv40205c,nAtv40305a,nAtv40305b,nAtv40305c,nAtv40405a,nAtv40405b,nAtv40405c,nAtv30505a,nAtv30505b,nAtv30505c,nAtv30605a,nAtv30605b,nAtv30605c,nAtv30705a,nAtv30705b,nAtv30705c
Store 0 To nAtv40106a,nAtv40106b,nAtv40106c,nAtv40206a,nAtv40206b,nAtv40206c,nAtv40306a,nAtv40306b,nAtv40306c,nAtv40406a,nAtv40406b,nAtv40406c,nAtv30506a,nAtv30506b,nAtv30506c,nAtv30606a,nAtv30606b,nAtv30606c,nAtv30706a,nAtv30706b,nAtv30706c
Store 0 To nAtv40107a,nAtv40107b,nAtv40107c,nAtv40207a,nAtv40207b,nAtv40207c,nAtv40307a,nAtv40307b,nAtv40307c,nAtv40407a,nAtv40407b,nAtv40407c,nAtv30507a,nAtv30507b,nAtv30507c,nAtv30607a,nAtv30607b,nAtv30607c,nAtv30707a,nAtv30707b,nAtv30707c
Store 0 To nAtv40108a,nAtv40108b,nAtv40108c,nAtv40208a,nAtv40208b,nAtv40208c,nAtv40308a,nAtv40308b,nAtv40308c,nAtv40408a,nAtv40408b,nAtv40408c,nAtv30508a,nAtv30508b,nAtv30508c,nAtv30608a,nAtv30608b,nAtv30608c,nAtv30708a,nAtv30708b,nAtv30708c
Store 0 To nAtv40109a,nAtv40109b,nAtv40109c,nAtv40209a,nAtv40209b,nAtv40209c,nAtv40309a,nAtv40309b,nAtv40309c,nAtv40409a,nAtv40409b,nAtv40409c,nAtv30509a,nAtv30509b,nAtv30509c,nAtv30609a,nAtv30609b,nAtv30609c,nAtv30709a,nAtv30709b,nAtv30709c
Store 0 To nAtv40110a,nAtv40110b,nAtv40110c,nAtv40210a,nAtv40210b,nAtv40210c,nAtv40310a,nAtv40310b,nAtv40310c,nAtv40410a,nAtv40410b,nAtv40410c,nAtv30510a,nAtv30510b,nAtv30510c,nAtv30610a,nAtv30610b,nAtv30610c,nAtv30710a,nAtv30710b,nAtv30710c
Store 0 To nAtv40111a,nAtv40111b,nAtv40111c,nAtv40211a,nAtv40211b,nAtv40211c,nAtv40311a,nAtv40311b,nAtv40311c,nAtv40411a,nAtv40411b,nAtv40411c,nAtv30511a,nAtv30511b,nAtv30511c,nAtv30611a,nAtv30611b,nAtv30611c,nAtv30711a,nAtv30711b,nAtv30711c
Store 0 To nAtv40112a,nAtv40112b,nAtv40112c,nAtv40212a,nAtv40212b,nAtv40212c,nAtv40312a,nAtv40312b,nAtv40312c,nAtv40412a,nAtv40412b,nAtv40412c,nAtv30512a,nAtv30512b,nAtv30512c,nAtv30612a,nAtv30612b,nAtv30612c,nAtv30712a,nAtv30712b,nAtv30712c
Store 0 To nAtv40113a,nAtv40113b,nAtv40113c,nAtv40213a,nAtv40213b,nAtv40213c,nAtv40313a,nAtv40313b,nAtv40313c,nAtv40413a,nAtv40413b,nAtv40413c,nAtv30513a,nAtv30513b,nAtv30513c,nAtv30613a,nAtv30613b,nAtv30613c,nAtv30713a,nAtv30713b,nAtv30713c
Store 0 To nAtv40114a,nAtv40114b,nAtv40114c,nAtv40214a,nAtv40214b,nAtv40214c,nAtv40314a,nAtv40314b,nAtv40314c,nAtv40414a,nAtv40414b,nAtv40414c,nAtv30514a,nAtv30514b,nAtv30514c,nAtv30614a,nAtv30614b,nAtv30614c,nAtv30714a,nAtv30714b,nAtv30714c
Store 0 To nAtv40115a,nAtv40115b,nAtv40115c,nAtv40215a,nAtv40215b,nAtv40215c,nAtv40315a,nAtv40315b,nAtv40315c,nAtv40415a,nAtv40415b,nAtv40415c,nAtv30515a,nAtv30515b,nAtv30515c,nAtv30615a,nAtv30615b,nAtv30615c,nAtv30715a,nAtv30715b,nAtv30715c

xUO      := ""
xErro    := {} // Array de 6 posições (1-Filial, 2-Prefixo, 3-Numero, 4-Centro de custo, 5-Valor, 6- Tipo de erro)

cQuery := ""
V_Se1  := RETSQLNAME("SE1")
V_Sa1  := RETSQLNAME("SA1")

cQuery = "SELECT A.E1_FILIAL ,A.E1_CLIENTE ,A.E1_LOJA ,A.E1_EMISSAO ,A.E1_VALOR ,A.E1_ISS ,A.E1_IPI ,A.E1_VLRICM ,A.E1_DESCONT ,A.E1_CCONT ,A.E1_NUM ,A.E1_PREFIXO ,B.A1_COD,B.A1_LOJA ,B.A1_GEFCAT1"
cQuery += " FROM "+V_Se1+" AS A,"+V_Sa1+" AS B "
cQuery += " WHERE A.E1_CLIENTE = B.A1_COD AND A.E1_LOJA = B.A1_LOJA AND"
cQuery += " A.E1_EMISSAO >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " A.E1_EMISSAO <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " A.E1_TIPO <> 'FAT' AND SUBSTRING(A.E1_PREFIXO,1,2) <> 'ND ' AND "
cQuery += " A.E1_TIPO <> 'NCC' AND "
cQuery += " A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY A.E1_CCONT "
//cQuery += " ORDER BY B.A1_GEFCAT1 "
//cQuery += " ORDER BY A.E1_FILIAL "
//cQuery := ChangeQuery(cQuery)		                   
//MEMOWRIT("GEFCTB04.SQL",cQuery)

TcQuery cQuery  ALIAS "SMC" NEW

dbSelectArea("SMC")
//dbSetOrder(1)
dbGoTop()

SetRegua(RecCount())

While !EOF() 

   IncRegua()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif         
   
   //While Substr(Alltrim(SMC->E1_CCONT),4,3) == xFilCtb
   
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif   
   
   // DE/PARA FILIAL COM C.CUSTO
   xFilCtb := Substr(Alltrim(SMC->E1_CCONT),4,3)

   Do Case
      Case xFilCtb == "001"
           xFilRet := "01"
      Case xFilCtb == "002"
           xFilRet := "02"
      Case xFilCtb == "004"
           xFilRet := "03"
      Case xFilCtb == "005"
           xFilRet := "04"
      Case xFilCtb == "006"
           xFilRet := "05"
      Case xFilCtb == "007"
           xFilRet := "06"
      Case xFilCtb == "008"
           xFilRet := "07"
      Case xFilCtb == "009"
           xFilRet := "09"
      Case xFilCtb == "010"
           xFilRet := "08"
      Case xFilCtb == "011"
           xFilRet := "10"
      Case xFilCtb == "012"
           xFilRet := "11"
      Case xFilCtb == "013"
           xFilRet := "12"
      Case xFilCtb == "014"
           xFilRet := "13"
      Case xFilCtb == "015" // VITORIA NÃO LIBERADA NO SISTEMA
           xFilRet := "15"                                     
      Case xFilCtb == "016" // Sete Lagoas
           xFilRet := "14"
      OtherWise	                 
		Alert(SMC->E1_FILIAL + " " + SMC->E1_PREFIXO + " " + SMC->E1_NUM + " " + xFilCtb)
        Msginfo("Filial não cadastrada !" + xFilCtb)
        Return
   EndCase
  
   xUO := Substr(Alltrim(SMC->E1_CCONT),2,2)
   nDesc := SMC->E1_DESCONT
   nIss  := SMC->E1_ISS
   nIcms := SMC->E1_VLRICM
   nIpi  := SMC->E1_IPI
   nValor := SMC->E1_VALOR                               
   nSaldo := (SMC->E1_VALOR - (SMC->E1_DESCONT + SMC->E1_ISS + SMC->E1_VLRICM + SMC->E1_IPI ))
     
   // Log de Erros - Tipos no Array
   // 1- Atividade não cadastrada
   // 2- Designação da venda errada
   // 3- Categoria Difere da Atividade ( AGUARDANDO DEFINIÇÕES )
       
   //Vendas Por U.O.
   If xUO == "01" .Or. xUO == "02"    // RDVM
	   // Atividades - Metier
	   // RDVM
	   Do Case
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "001"  // Transporte Rodoviario nacional
	           nAtv001 := nAtv001 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "002"  // Transporte Rodoviario nacional de transferencia
	           nAtv002 := nAtv002 + nSaldo     
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "003"  // Transporte Rodoviario exportação
	           nAtv003 := nAtv003 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "004"  // Transporte Maritimo exportação
	           nAtv004 := nAtv004 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "005"  // Gestão nacional
	           nAtv005 := nAtv005 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "006"  // Gestão exportação
	           nAtv006 := nAtv006 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "007"  // Survey nacional
	           nAtv007 := nAtv007 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "008"  // Survey exportação
	           nAtv008 := nAtv008 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "009"  // Tropicalização
	           nAtv009 := nAtv009 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "010"  // Armazenagem nacional
	           nAtv010 := nAtv010 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "011"  // Armazenagem importação
	           nAtv011 := nAtv011 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "012"  // Armazenagem exportação
	           nAtv012 := nAtv012 + nSaldo     
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "013"  // Outros Serviços Logisticos
	           nAtv013 := nAtv013 + nSaldo
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "101"  // PVN - VN
	           nAtv101 := nAtv101 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "102"  // PVN - VO
	           nAtv102 := nAtv102 + nSaldo      
	      OtherWise	           
	           nAtvout := nAtvout + nSaldo
	           AADD(xErro,{SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_CCONT,SE1->E1_VALOR,"1"})
	   EndCase             
          
      nRdvm := nRdvm + nSaldo     
      Irdvm := Irdvm + nValor
      
      Do Case 
         Case SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
              xCatRdvm1 := xCatRdvm1 + nSaldo     
              IRdvm1 := IRdvm1 + nValor              
         Case SMC->A1_GEFCAT1 == "2"         // Ventes Hors Groupe GEFCO
              xCatRdvm2 := xCatRdvm2 + nSaldo     
              IRdvm2 := IRdvm2 + nValor                            
         Case SMC->A1_GEFCAT1 == "3"         // Ventes Groupe PSA Consolidé         
              xCatRdvm3 := xCatRdvm3 + nSaldo     
              IRdvm3 := IRdvm3 + nValor                            
         Otherwise
              xCatRdvm4 := xCatRdvm4 + nSaldo     
              IRdvm4 := IRdvm4 + nValor                            
      EndCase

      //Separação Difa/Dlpr/Terceiros   
      If Substr(Alltrim(SMC->E1_CCONT),10,1) == "1"    // Tratamento MARCA AP
         nDifaRdvm := nDifaRdvm + nSaldo     
      Endif          
      If Substr(Alltrim(SMC->E1_CCONT),10,1) == "2"    // Tratamento MARCA AC
         nDlprRdvm := nDlprRdvm + nSaldo     
      Endif   
      If Substr(Alltrim(SMC->E1_CCONT),10,1) == "5"    
         nGrupRdvm := nGrupRdvm + nSaldo     
      Endif   
      If Substr(Alltrim(SMC->E1_CCONT),10,1) == "6"    
         nTercRdvm := nTercRdvm + nSaldo     
      Endif         
      If !Substr(Alltrim(SMC->E1_CCONT),10,1) $ ("3|4|7|0")    // Diferença
         nDifRdvm := nDifRdvm + nSaldo     
         AADD(xErro,{SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_CCONT,SE1->E1_VALOR,"2"})
      Endif          
          
   Endif
   //
   If xUO == "21"        // ILI
	   // Atividades - Metier
	   // Supply / ILI
	   Do Case
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "301"  // Carga fechada nacional              
	           nAtv301 := nAtv301 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "302"  // Carga fechada internacional 
	           nAtv302 := nAtv302 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "303"  // Carga fracionada nacional 
	           nAtv303 := nAtv303 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "304"  // Carga fracionada internacional 
	           nAtv304 := nAtv304 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "305"  // Lote nacional
	           nAtv305 := nAtv305 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "306"  // Intercentro nacional
	           nAtv306 := nAtv306 + nSaldo                                                 
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "307"  // Lote internacional
	           nAtv307 := nAtv307 + nSaldo      
	      OtherWise
	           nAtvout := nAtvout + nSaldo
	           AADD(xErro,{SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_CCONT,SE1->E1_VALOR,"1"})
	   EndCase             

	   If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
	      If xFilRet == "01"
	         nAtv30101a := nAtv30101a + nSaldo
	      Elseif xFilRet == "02"
	         nAtv30102a := nAtv30102a + nSaldo
	      Elseif xFilRet == "03"
	         nAtv30103a := nAtv30103a + nSaldo
	      Elseif xFilRet == "04"
	         nAtv30104a := nAtv30104a + nSaldo
	      Elseif xFilRet == "05"                 
	         nAtv30105a := nAtv30105a + nSaldo
	      Elseif xFilRet == "06"
	         nAtv30106a := nAtv30106a + nSaldo
	      Elseif xFilRet == "07"     
	         nAtv30107a := nAtv30107a + nSaldo
	      Elseif xFilRet == "08"
	         nAtv30108a := nAtv30108a + nSaldo
	      Elseif xFilRet == "09"
	         nAtv30109a := nAtv30109a + nSaldo
	      Elseif xFilRet == "10"
	         nAtv30110a := nAtv30110a + nSaldo
	      Elseif xFilRet == "11"                 
	         nAtv30111a := nAtv30111a + nSaldo
	      Elseif xFilRet == "12"
	         nAtv30112a := nAtv30112a + nSaldo
	      Elseif xFilRet == "13"     
	         nAtv30113a := nAtv30113a + nSaldo
	      Elseif xFilRet == "14"     
	         nAtv30114a := nAtv30114a + nSaldo
	      Elseif xFilRet == "15"     
	         nAtv30115a := nAtv30115a + nSaldo
	      Else
	         MsgInfo("Sem Atividade ILI ")
	         Return
		  Endif

	   ElseIf SMC->A1_GEFCAT1 == "2" 

	      If xFilRet == "01"
	         nAtv30101b := nAtv30101b + nSaldo
	      Elseif xFilRet == "02"
	         nAtv30102b := nAtv30102b + nSaldo
	      Elseif xFilRet == "03"
	         nAtv30103b := nAtv30103b + nSaldo
	      Elseif xFilRet == "04"
	         nAtv30104b := nAtv30104b + nSaldo
	      Elseif xFilRet == "05"                 
	         nAtv30105b := nAtv30105b + nSaldo
	      Elseif xFilRet == "06"
	         nAtv30106b := nAtv30106b + nSaldo
	      Elseif xFilRet == "07"     
	         nAtv30107b := nAtv30107b + nSaldo
	      Elseif xFilRet == "08"
	         nAtv30108b := nAtv30108b + nSaldo
	      Elseif xFilRet == "09"
	         nAtv30109b := nAtv30109b + nSaldo
	      Elseif xFilRet == "10"
	         nAtv30110b := nAtv30110b + nSaldo
	      Elseif xFilRet == "11"                 
	         nAtv30111b := nAtv30111b + nSaldo
	      Elseif xFilRet == "12"
	         nAtv30112b := nAtv30112b + nSaldo
	      Elseif xFilRet == "13"     
	         nAtv30113b := nAtv30113b + nSaldo
	      Elseif xFilRet == "14"     
	         nAtv30114b := nAtv30114b + nSaldo
	      Elseif xFilRet == "15"     
	         nAtv30115b := nAtv30115b + nSaldo
	      Else
	         MsgInfo("Sem Atividade ILI ")
	         Return
		  Endif

	   ElseIf SMC->A1_GEFCAT1 == "3" 

	      If xFilRet == "01"
	         nAtv30101c := nAtv30101c + nSaldo
	      Elseif xFilRet == "02"
	         nAtv30102c := nAtv30102c + nSaldo
	      Elseif xFilRet == "03"
	         nAtv30103c := nAtv30103c + nSaldo
	      Elseif xFilRet == "04"
	         nAtv30104c := nAtv30104c + nSaldo
	      Elseif xFilRet == "05"                 
	         nAtv30105c := nAtv30105c + nSaldo
	      Elseif xFilRet == "06"
	         nAtv30106c := nAtv30106c + nSaldo
	      Elseif xFilRet == "07"     
	         nAtv30107c := nAtv30107c + nSaldo
	      Elseif xFilRet == "08"
	         nAtv30108c := nAtv30108c + nSaldo
	      Elseif xFilRet == "09"
	         nAtv30109c := nAtv30109c + nSaldo
	      Elseif xFilRet == "10"
	         nAtv30110c := nAtv30110c + nSaldo
	      Elseif xFilRet == "11"                 
	         nAtv30111c := nAtv30111c + nSaldo
	      Elseif xFilRet == "12"
	         nAtv30112c := nAtv30112c + nSaldo
	      Elseif xFilRet == "13"     
	         nAtv30113c := nAtv30113c + nSaldo
	      Elseif xFilRet == "14"     
	         nAtv30114c := nAtv30114c + nSaldo
	      Elseif xFilRet == "15"     
	         nAtv30115c := nAtv30115c + nSaldo
	      Else
	         MsgInfo("Sem Atividade ILI ")
	         Return
		  Endif
	   Endif
	   	  
      nIli := nIli + nSaldo
      Iili := Iili + nValor
      Do Case 
         Case SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
              xCatIli1 := xCatIli1 + nSaldo     
              Iili1 := Iili1 + nValor                            

         Case SMC->A1_GEFCAT1 == "2"         // Ventes Hors Groupe GEFCO
              xCatIli2 := xCatIli2 + nSaldo     
              Iili2 := Iili2 + nValor                            
         Case SMC->A1_GEFCAT1 == "3"         // Ventes Groupe PSA Consolidé         
              xCatIli3 := xCatIli3 + nSaldo     
              Iili3 := Iili3 + nValor                                          
         Otherwise
              xCatIli4 := xCatIli4 + nSaldo     
              Iili4 := Iili4 + nValor                            
      EndCase

      //Separação Difa/Dlpr/Terceiros   
      If Substr(Alltrim(SMC->E1_CCONT),10,1) == "3"    // Tratamento Difa
         nDifaIli := nDifaIli + nSaldo     
      Endif          
      If Substr(Alltrim(SMC->E1_CCONT),10,1) == "4"    // Tratamento Dlpr
         nDlprIli := nDlprIli + nSaldo     
      Endif   
      If Substr(Alltrim(SMC->E1_CCONT),10,1) ==  "5" 
         nGrupIli := nGrupIli + nSaldo     
      Endif      
      If Substr(Alltrim(SMC->E1_CCONT),10,1) ==  "6" 
         nTercIli := nTercIli + nSaldo     
      Endif
      If !Substr(Alltrim(SMC->E1_CCONT),10,1) $ ("1|2|7|0")    // Diferença
         nDifIli := nDifIli + nSaldo     
         AADD(xErro,{SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_CCONT,SE1->E1_VALOR,"2"})
      Endif              
   
   Endif  
   //

   If xUO == "11" //.And. xFilRet == "01"       //Rmlap
	   // Atividades - Metier
	   // Network / RMLAP
	   // FILIAL 01	   
	   
	   If xFilRet == "01" //Matriz
	      
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "201" // Carga fechada nacional 	      
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
     	        nAtv201a := nAtv201a + nSaldo      	   
			 ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv201b := nAtv201b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv201c := nAtv201c + nSaldo      
    	     Endif
    	  Endif
    	          
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "202" // Carga fechada internacional 	    
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv202a := nAtv202a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv202b := nAtv202b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv202c := nAtv202c + nSaldo      
    	       Endif
	           //nAtv202 := nAtv202 + nSaldo      
          Endif
	      
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "203"  // Carga fracionada nacional 
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv203a := nAtv203a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv203b := nAtv203b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv203c := nAtv203c + nSaldo      
    	       Endif
	      Endif
	           //nAtv203 := nAtv203 + nSaldo      
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "204" // Carga fracionada internacional 
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv204a := nAtv204a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv204b := nAtv204b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv204c := nAtv204c + nSaldo      
    	       Endif
          Endif
          
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "205" // Lote nacional
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv205a := nAtv205a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv205b := nAtv205b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv205c := nAtv205c + nSaldo      
    	       Endif
          Endif
	      
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "206" // Intercentro nacional
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv206a := nAtv206a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv206b := nAtv206b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv206c := nAtv206c + nSaldo      
    	       Endif
          
          Endif
          
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "207" // Lote internacional
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv207a := nAtv207a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv207b := nAtv207b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv207c := nAtv207c + nSaldo      
    	       Endif
          Endif
          
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "208" // Intercentro internacional
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv208a := nAtv208a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv208b := nAtv208b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv208c := nAtv208c + nSaldo      
    	       Endif
          Endif
          
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "209" // Transporte emergencial
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv209a := nAtv209a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv209b := nAtv209b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv209c := nAtv209c + nSaldo      
    	       Endif
          Endif
          
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "210" // Gefco especial
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv210a := nAtv210a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv210b := nAtv210b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv210c := nAtv210c + nSaldo      
    	       Endif

          Endif
       
       Endif

       
       If xFilRet == "02" // Beneditinos

	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "201" // Carga fechada nacional 
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv20102a := nAtv20102a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv20102b := nAtv20102b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv20102c := nAtv20102c + nSaldo      
    	       Endif

	           //nAtv20102 := nAtv20102 + nSaldo      
	      ElseIf Substr(Alltrim(SMC->E1_CCONT),7,3) == "202" // Carga fechada internacional 
	           //nAtv20202 := nAtv202 + nSaldo      
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv20202a := nAtv20202a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv20202b := nAtv20202b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv20202c := nAtv20202c + nSaldo      
    	       Endif
	           
	      ElseIf Substr(Alltrim(SMC->E1_CCONT),7,3) == "203" // Carga fracionada nacional 
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv20302a := nAtv20302a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv20302b := nAtv20302b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv20302c := nAtv20302c + nSaldo      
    	       Endif

	           //nAtv20302 := nAtv20302 + nSaldo      
	      ElseIf Substr(Alltrim(SMC->E1_CCONT),7,3) == "204" // Carga fracionada internacional 
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv20402a := nAtv20402a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv20402b := nAtv20402b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv20402c := nAtv20402c + nSaldo      
    	       Endif

	           //nAtv20402 := nAtv20402 + nSaldo      
	      ElseIf Substr(Alltrim(SMC->E1_CCONT),7,3) == "205" // Lote nacional
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv20502a := nAtv20502a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv20502b := nAtv20502b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv20502c := nAtv20502c + nSaldo      
    	       Endif	          
	           //nAtv20502 := nAtv20502 + nSaldo      
	      
	      ElseIf Substr(Alltrim(SMC->E1_CCONT),7,3) == "206" // Intercentro nacional
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv20602a := nAtv20602a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv20602b := nAtv20602b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv20602c := nAtv20602c + nSaldo      
    	       Endif

	           //nAtv20602 := nAtv20602 + nSaldo                                                 
	      ElseIf Substr(Alltrim(SMC->E1_CCONT),7,3) == "207" // Lote internacional
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv20702a := nAtv20702a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv20702b := nAtv20702b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv20702c := nAtv20702c + nSaldo      
    	       Endif

	           //nAtv20702 := nAtv20702 + nSaldo      
	      ElseIf Substr(Alltrim(SMC->E1_CCONT),7,3) == "208" // Intercentro internacional
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv20802a := nAtv20802a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv20802b := nAtv20802b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv20802c := nAtv20802c + nSaldo      
    	       Endif

	           //nAtv20802 := nAtv20802 + nSaldo      
	      ElseIf Substr(Alltrim(SMC->E1_CCONT),7,3) == "209" // Transporte emergencial
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv20902a := nAtv20902a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv20902b := nAtv20902b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv20902c := nAtv20902c + nSaldo      
    	       Endif

	           //nAtv20902 := nAtv20902 + nSaldo      
	      ElseIf Substr(Alltrim(SMC->E1_CCONT),7,3) == "210" // Gefco especial
	           If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	          nAtv21002a := nAtv21002a + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "2"        
       	          nAtv21002b := nAtv21002b + nSaldo      
    	       ElseIf SMC->A1_GEFCAT1 == "3"        
    	          nAtv21002c := nAtv21002c + nSaldo      
    	       Endif

	           //nAtv21002 := nAtv21002 + nSaldo                
          Endif

       Endif
       
       If  xFilRet == "03" // Beneditinos	      
	      
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "201"  // Carga fechada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20103a := nAtv20103a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20103b := nAtv20103b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20103c := nAtv20103c + nSaldo      
    	     Endif

	           //nAtv20103 := nAtv20103 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "202" // Carga fechada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20203a := nAtv20203a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20203b := nAtv20203b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20203c := nAtv20203c + nSaldo      
    	     Endif

	           //nAtv20203 := nAtv20203 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "203" // Carga fracionada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20303a := nAtv20303a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20303b := nAtv20303b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20303c := nAtv20303c + nSaldo      
    	     Endif

	           //nAtv20303 := nAtv20303 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "204" // Carga fracionada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20403a := nAtv20403a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20403b := nAtv20403b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20403c := nAtv20403c + nSaldo      
    	     Endif

	           //nAtv20403 := nAtv20403 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "205" // Lote nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20503a := nAtv20503a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20503b := nAtv20503b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20503c := nAtv20503c + nSaldo      
    	     Endif

	           //nAtv20503 := nAtv20503 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "206" // Intercentro nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20603a := nAtv20603a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20603b := nAtv20603b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20603c := nAtv20603c + nSaldo      
    	     Endif

	           //nAtv20603 := nAtv20603 + nSaldo                                                 
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "207" // Lote internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20703a := nAtv20703a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20703b := nAtv20703b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20703c := nAtv20703c + nSaldo      
    	     Endif

	           //nAtv20703 := nAtv20703 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "208" // Intercentro internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20803a := nAtv20803a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20803b := nAtv20803b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20803c := nAtv20803c + nSaldo      
    	     Endif

	           //nAtv20803 := nAtv20803 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "209" // Transporte emergencial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20903a := nAtv20903a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20903b := nAtv20903b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20903c := nAtv20903c + nSaldo      
    	     Endif

	           //nAtv20903 := nAtv20903 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "210" // Gefco especial
	           //nAtv21003 := nAtv21003 + nSaldo                
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv21003a := nAtv21003a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv21003b := nAtv21003b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv21003c := nAtv21003c + nSaldo      
    	     Endif
         
          Endif
          
       Endif

       If  xFilRet == "04" // Barueri

	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "201" // Carga fechada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20104a := nAtv20104a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20104b := nAtv20104b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20104c := nAtv20104c + nSaldo      
    	     Endif

	           //nAtv20104 := nAtv20104 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "202" // Carga fechada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20204a := nAtv20204a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20204b := nAtv20204b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20204c := nAtv20204c + nSaldo      
    	     Endif

	           //nAtv20204 := nAtv20204 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "203" // Carga fracionada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20304a := nAtv20304a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20304b := nAtv20304b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20304c := nAtv20304c + nSaldo      
    	     Endif

	           //nAtv20304 := nAtv20304 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "204" // Carga fracionada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20404a := nAtv20404a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20404b := nAtv20404b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20404c := nAtv20404c + nSaldo      
    	     Endif

	           //nAtv20404 := nAtv20404 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "205" // Lote nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20504a := nAtv20504a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20504b := nAtv20504b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20504c := nAtv20504c + nSaldo      
    	     Endif

	           //nAtv20504 := nAtv20504 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "206" // Intercentro nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20604a := nAtv20604a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20604b := nAtv20604b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20604c := nAtv20604c + nSaldo      
    	     Endif

	           //nAtv20604 := nAtv20604 + nSaldo                                                 
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "207" // Lote internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20704a := nAtv20704a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20704b := nAtv20704b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20704c := nAtv20704c + nSaldo      
    	     Endif

	           //nAtv20704 := nAtv20704 + nSaldo      
	      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "208" // Intercentro internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20804a := nAtv20804a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20804b := nAtv20804b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20804c := nAtv20804c + nSaldo      
    	     Endif

	           //nAtv20804 := nAtv20804 + nSaldo      
	      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "209" // Transporte emergencial
	           //nAtv20904 := nAtv20904 + nSaldo      
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20904a := nAtv20904a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20904b := nAtv20904b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20904c := nAtv20904c + nSaldo      
    	     Endif
	      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "210" // Gefco especial
	          // nAtv21004 := nAtv21004 + nSaldo                
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv21004a := nAtv21004a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv21004b := nAtv21004b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv21004c := nAtv21004c + nSaldo      
    	     Endif

          Endif
       Endif
          
       If  xFilRet == "05" // Caxias/Pavuna
       
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "201" // Carga fechada nacional 
	           //nAtv20105 := nAtv20105 + nSaldo      
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20105a := nAtv20105a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20105b := nAtv20105b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20105c := nAtv20105c + nSaldo      
    	     Endif

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "202" // Carga fechada internacional 
	           //nAtv20205 := nAtv20205 + nSaldo      
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20205a := nAtv20205a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20205b := nAtv20205b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20205c := nAtv20205c + nSaldo      
    	     Endif

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "203" // Carga fracionada nacional 
	           //nAtv20305 := nAtv20305 + nSaldo      
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20305a := nAtv20305a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20305b := nAtv20305b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20305c := nAtv20305c + nSaldo      
    	     Endif

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "204" // Carga fracionada internacional 
	           //nAtv20405 := nAtv20405 + nSaldo      
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20405a := nAtv20405a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20405b := nAtv20405b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20405c := nAtv20405c + nSaldo      
    	     Endif

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "205" // Lote nacional
	           //nAtv20505 := nAtv20505 + nSaldo      
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20505a := nAtv20505a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20505b := nAtv20505b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20505c := nAtv20505c + nSaldo      
    	     Endif

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "206" // Intercentro nacional
	           //nAtv20605 := nAtv20605 + nSaldo                                                 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20605a := nAtv20605a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20605b := nAtv20605b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20605c := nAtv20605c + nSaldo      
    	     Endif

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "207" // Lote internacional
	           //nAtv20705 := nAtv20705 + nSaldo      
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20705a := nAtv20705a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20705b := nAtv20705b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20705c := nAtv20705c + nSaldo      
    	     Endif

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "208" // Intercentro internacional
	           //nAtv20805 := nAtv20805 + nSaldo      
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20805a := nAtv20805a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20805b := nAtv20805b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20805c := nAtv20805c + nSaldo      
    	     Endif

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "209" // Transporte emergencial
	           //nAtv20905 := nAtv20905 + nSaldo      
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20905a := nAtv20905a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20905b := nAtv20905b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20905c := nAtv20905c + nSaldo      
    	     Endif

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "210" // Gefco especial
	           //nAtv21005 := nAtv21005 + nSaldo                
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv21005a := nAtv21005a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv21005b := nAtv21005b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv21005c := nAtv21005c + nSaldo      
    	     Endif
          
          Endif
          
       Endif
       
       If  xFilRet == "06" // V.Guilherme
       
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "201" // Carga fechada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20106a := nAtv20106a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20106b := nAtv20106b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20106c := nAtv20106c + nSaldo      
    	     Endif

	          // nAtv20106 := nAtv20106 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "202" // Carga fechada internacional 

	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20206a := nAtv20206a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20206b := nAtv20206b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20206c := nAtv20206c + nSaldo      
    	     Endif
	          // nAtv20206 := nAtv20206 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "203" // Carga fracionada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20306a := nAtv20306a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20306b := nAtv20306b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20306c := nAtv20306c + nSaldo      
    	     Endif

	          // nAtv20306 := nAtv20306 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "204" // Carga fracionada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20406a := nAtv20406a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20406b := nAtv20406b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20406c := nAtv20406c + nSaldo      
    	     Endif

	          // nAtv20406 := nAtv20406 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "205" // Lote nacional

	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20506a := nAtv20506a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20506b := nAtv20506b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20506c := nAtv20506c + nSaldo      
    	     Endif
	          // nAtv20506 := nAtv20506 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "206" // Intercentro nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20606a := nAtv20606a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20606b := nAtv20606b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20606c := nAtv20606c + nSaldo      
    	     Endif

	          // nAtv20606 := nAtv20606 + nSaldo                                                 
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "207" // Lote internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20706a := nAtv20706a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20706b := nAtv20706b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20706c := nAtv20706c + nSaldo      
    	     Endif

	          // nAtv20706 := nAtv20706 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "208" // Intercentro internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20806a := nAtv20806a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20806b := nAtv20806b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20806c := nAtv20806c + nSaldo      
    	     Endif

	          // nAtv20806 := nAtv20806 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "209" // Transporte emergencial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20906a := nAtv20906a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20906b := nAtv20906b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20906c := nAtv20906c + nSaldo      
    	     Endif

	          // nAtv20906 := nAtv20906 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "210" // Gefco especial
	           //nAtv21006 := nAtv21006 + nSaldo                
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv21006a := nAtv21006a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv21006b := nAtv21006b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv21006c := nAtv21006c + nSaldo      
    	     Endif
          Endif
          
       Endif
       
       If  xFilRet == "07" // S.J. Pinhais

	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "201" // Carga fechada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20107a := nAtv20107a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20107b := nAtv20107b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20107c := nAtv20107c + nSaldo      
    	     Endif
	      
	           //nAtv20107 := nAtv20107 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "202" // Carga fechada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20207a := nAtv20207a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20207b := nAtv20207b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20207c := nAtv20207c + nSaldo      
    	     Endif
	      
	           //nAtv20207 := nAtv20207 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "203" // Carga fracionada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20307a := nAtv20307a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20307b := nAtv20307b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20307c := nAtv20307c + nSaldo      
    	     Endif
	      
	           //nAtv20307 := nAtv20307 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "204" // Carga fracionada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20407a := nAtv20407a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20407b := nAtv20407b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20407c := nAtv20407c + nSaldo      
    	     Endif
	      
	           //nAtv20407 := nAtv20407 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "205" // Lote nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20507a := nAtv20507a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20507b := nAtv20507b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20507c := nAtv20507c + nSaldo      
    	     Endif
	      
	           //nAtv20507 := nAtv20507 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "206" // Intercentro nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20607a := nAtv20607a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20607b := nAtv20607b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20607c := nAtv20607c + nSaldo      
    	     Endif
	      
	           //nAtv20607 := nAtv20607 + nSaldo                                                 
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "207" // Lote internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20707a := nAtv20707a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20707b := nAtv20707b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20707c := nAtv20707c + nSaldo      
    	     Endif
	      
	           //nAtv20707 := nAtv20707 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "208" // Intercentro internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20807a := nAtv20807a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20807b := nAtv20807b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20807c := nAtv20807c + nSaldo      
    	     Endif
	      
	           //nAtv20807 := nAtv20807 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "209" // Transporte emergencial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20907a := nAtv20907a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20907b := nAtv20907b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20907c := nAtv20907c + nSaldo      
    	     Endif
	      
	          // nAtv20907 := nAtv20907 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "210" // Gefco especial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv21007a := nAtv21007a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv21007b := nAtv21007b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv21007c := nAtv21007c + nSaldo      
    	     Endif
	      
	      Endif
	      
	           //nAtv21007 := nAtv21007 + nSaldo                
       Endif
       
       If  xFilRet == "08" // Campinas

	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "201" // Carga fechada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20108a := nAtv20108a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20108b := nAtv20108b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20108c := nAtv20108c + nSaldo      
             Endif
	           //nAtv20108 := nAtv20108 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "202" // Carga fechada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20208a := nAtv20208a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20208b := nAtv20208b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20208c := nAtv20208c + nSaldo      
             Endif

	           //nAtv20208 := nAtv20208 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "203" // Carga fracionada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20308a := nAtv20308a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20308b := nAtv20308b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20308c := nAtv20308c + nSaldo      
             Endif

	           //nAtv20308 := nAtv20308 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "204" // Carga fracionada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20408a := nAtv20408a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20408b := nAtv20408b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20408c := nAtv20408c + nSaldo      
             Endif

	           //nAtv20408 := nAtv20408 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "205" // Lote nacional

	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20508a := nAtv20508a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20508b := nAtv20508b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20508c := nAtv20508c + nSaldo      
             Endif
	           //nAtv20508 := nAtv20508 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "206" // Intercentro nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20608a := nAtv20608a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20608b := nAtv20608b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20608c := nAtv20608c + nSaldo      
             Endif

	           //nAtv20608 := nAtv20608 + nSaldo                                                 
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "207" // Lote internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20708a := nAtv20708a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20708b := nAtv20708b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20708c := nAtv20708c + nSaldo      
             Endif

	           //nAtv20708 := nAtv20708 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "208" // Intercentro internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20808a := nAtv20808a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20808b := nAtv20808b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20808c := nAtv20808c + nSaldo      
             Endif

	           //nAtv20808 := nAtv20808 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "209" // Transporte emergencial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20908a := nAtv20908a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20908b := nAtv20908b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20908c := nAtv20908c + nSaldo      
             Endif

	           //nAtv20908 := nAtv20908 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "210" // Gefco especial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv21008a := nAtv21008a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv21008b := nAtv21008b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv21008c := nAtv21008c + nSaldo      
             Endif
          
          Endif
	           //nAtv21008 := nAtv21008 + nSaldo                
       
       Endif
       
       If  xFilRet == "09" // Contagem

	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "201" // Carga fechada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20109a := nAtv20109a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20109b := nAtv20109b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20109c := nAtv20109c + nSaldo      
             Endif

	           //nAtv20109 := nAtv20109 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "202"  // Carga fechada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20209a := nAtv20209a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20209b := nAtv20209b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20209c := nAtv20209c + nSaldo      
             Endif
	      
	           //nAtv20209 := nAtv20209 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "203"  // Carga fracionada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20309a := nAtv20309a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20309b := nAtv20309b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20309c := nAtv20309c + nSaldo      
             Endif

	           //nAtv20309 := nAtv20309 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "204"  // Carga fracionada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20409a := nAtv20409a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20409b := nAtv20409b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20409c := nAtv20409c + nSaldo      
             Endif

	           //nAtv20409 := nAtv20409 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "205"  // Lote nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20509a := nAtv20509a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20509b := nAtv20509b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20509c := nAtv20509c + nSaldo      
             Endif

	           //nAtv20509 := nAtv20509 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "206"  // Intercentro nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20609a := nAtv20609a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20609b := nAtv20609b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20609c := nAtv20609c + nSaldo      
             Endif

	           //nAtv20609 := nAtv20609 + nSaldo                                                 
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "207"  // Lote internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20709a := nAtv20709a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20709b := nAtv20709b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20709c := nAtv20709c + nSaldo      
             Endif

	           //nAtv20709 := nAtv20709 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "208"  // Intercentro internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20809a := nAtv20809a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20809b := nAtv20809b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20809c := nAtv20809c + nSaldo      
             Endif

	           //nAtv20809 := nAtv20809 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "209"  // Transporte emergencial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20909a := nAtv20909a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20909b := nAtv20909b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20909c := nAtv20909c + nSaldo      
             Endif

	           //nAtv20909 := nAtv20909 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "210"  // Gefco especial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv21009a := nAtv21009a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv21009b := nAtv21009b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv21009c := nAtv21009c + nSaldo      
             Endif

	           //nAtv21009 := nAtv21009 + nSaldo                
          Endif
       
       Endif
          
       If  xFilRet == "10" // Sepetiba

	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "201" // Carga fechada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20110a := nAtv20110a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20110b := nAtv20110b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20110c := nAtv20110c + nSaldo      
             Endif

	           //nAtv20110 := nAtv20110 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "202"  // Carga fechada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20210a := nAtv20210a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20210b := nAtv20210b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20210c := nAtv20210c + nSaldo      
             Endif

	           //nAtv20210 := nAtv20210 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "203"  // Carga fracionada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20310a := nAtv20310a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20310b := nAtv20310b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20310c := nAtv20310c + nSaldo      
             Endif

	           //nAtv20310 := nAtv20310 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "204" // Carga fracionada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20410a := nAtv20410a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20410b := nAtv20410b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20410c := nAtv20410c + nSaldo      
             Endif

	           //nAtv20410 := nAtv20410 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "205" // Lote nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20510a := nAtv20510a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20510b := nAtv20510b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20510c := nAtv20510c + nSaldo      
             Endif

	           //nAtv20510 := nAtv20510 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "206" // Intercentro nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20610a := nAtv20610a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20610b := nAtv20610b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20610c := nAtv20610c + nSaldo      
             Endif

	           //nAtv20610 := nAtv20610 + nSaldo                                                 
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "207" // Lote internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20710a := nAtv20710a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20710b := nAtv20710b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20710c := nAtv20710c + nSaldo      
             Endif

	           //nAtv20710 := nAtv20710 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "208" // Intercentro internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20810a := nAtv20810a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20810b := nAtv20810b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20810c := nAtv20810c + nSaldo      
             Endif

	           //nAtv20810 := nAtv20810 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "209" // Transporte emergencial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20910a := nAtv20910a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20910b := nAtv20910b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20910c := nAtv20910c + nSaldo      
             Endif

	           //nAtv20910 := nAtv20910 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "210" // Gefco especial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv21010a := nAtv21010a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv21010b := nAtv21010b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv21010c := nAtv21010c + nSaldo      
             Endif

	           //nAtv21010 := nAtv21010 + nSaldo                
          
          Endif
       
       Endif
          
       If  xFilRet == "11" // V.Olimpia
       
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "201" // Carga fechada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20111a := nAtv20111a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20111b := nAtv20111b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20111c := nAtv20111c + nSaldo      
             Endif

	           //nAtv20111 := nAtv20111 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "202"  // Carga fechada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20211a := nAtv20211a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20211b := nAtv20211b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20211c := nAtv20211c + nSaldo      
             Endif

	           //nAtv20211 := nAtv20211 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "203" // Carga fracionada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20311a := nAtv20311a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20311b := nAtv20311b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20311c := nAtv20311c + nSaldo      
             Endif

	           //nAtv20311 := nAtv20311 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "204" // Carga fracionada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20411a := nAtv20411a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20411b := nAtv20411b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20411c := nAtv20411c + nSaldo      
             Endif

	           //nAtv20411 := nAtv20411 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "205" // Lote nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20511a := nAtv20511a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20511b := nAtv20511b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20511c := nAtv20511c + nSaldo      
             Endif

	           //nAtv20511 := nAtv20511 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "206" // Intercentro nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20611a := nAtv20611a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20611b := nAtv20611b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20611c := nAtv20611c + nSaldo      
             Endif

	           //nAtv20611 := nAtv20611 + nSaldo                                                 
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "207" // Lote internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20711a := nAtv20711a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20711b := nAtv20711b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20711c := nAtv20711c + nSaldo      
             Endif

	           //nAtv20711 := nAtv20711 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "208" // Intercentro internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20811a := nAtv20811a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20811b := nAtv20811b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20811c := nAtv20811c + nSaldo      
             Endif

	           //nAtv20811 := nAtv20811 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "209" // Transporte emergencial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20911a := nAtv20911a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20911b := nAtv20911b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20911c := nAtv20911c + nSaldo      
             Endif

	           //nAtv20911 := nAtv20911 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "210" // Gefco especial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv21011a := nAtv21011a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv21011b := nAtv21011b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv21011c := nAtv21011c + nSaldo      
             Endif

	           //nAtv21011 := nAtv21011 + nSaldo                
          
          Endif
       
       Endif
          
       If  xFilRet == "12" // Santos
       
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "201" // Carga fechada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20112a := nAtv20112a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20112b := nAtv20112b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20112c := nAtv20112c + nSaldo      
             Endif

	           //nAtv20112 := nAtv20112 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "202" // Carga fechada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20212a := nAtv20212a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20212b := nAtv20212b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20212c := nAtv20212c + nSaldo      
             Endif

	           //nAtv20212 := nAtv20212 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "203" // Carga fracionada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20312a := nAtv20312a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20312b := nAtv20312b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20312c := nAtv20312c + nSaldo      
             Endif

	           //nAtv20312 := nAtv20312 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "204" // Carga fracionada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20412a := nAtv20412a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20412b := nAtv20412b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20412c := nAtv20412c + nSaldo      
             Endif

	           //nAtv20412 := nAtv20412 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "205" // Lote nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20512a := nAtv20512a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20512b := nAtv20512b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20512c := nAtv20512c + nSaldo      
             Endif

	           //nAtv20512 := nAtv20512 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "206" // Intercentro nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20612a := nAtv20612a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20612b := nAtv20612b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20612c := nAtv20612c + nSaldo      
             Endif

	           //nAtv20612 := nAtv20612 + nSaldo                                                 
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "207" // Lote internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20712a := nAtv20712a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20712b := nAtv20712b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20712c := nAtv20712c + nSaldo      
             Endif

	           //nAtv20712 := nAtv20712 + nSaldo      

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "208" // Intercentro internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20812a := nAtv20812a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20812b := nAtv20812b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20812c := nAtv20812c + nSaldo      
             Endif

	           //nAtv20812 := nAtv20812 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "209" // Transporte emergencial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20912a := nAtv20912a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20912b := nAtv20912b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20912c := nAtv20912c + nSaldo      
             Endif

	           //nAtv20912 := nAtv20912 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "210" // Gefco especial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv21012a := nAtv21012a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv21012b := nAtv21012b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv21012c := nAtv21012c + nSaldo      
             Endif

	           //nAtv21012 := nAtv21012 + nSaldo                
          
          Endif
       
       Endif
          
       If  xFilRet == "13" // RB 45
       
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "201" // Carga fechada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20113a := nAtv20113a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20113b := nAtv20113b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20113c := nAtv20113c + nSaldo      
             Endif

	           //nAtv20113 := nAtv20113 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "202" // Carga fechada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20213a := nAtv20213a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20213b := nAtv20213b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20213c := nAtv20213c + nSaldo      
             Endif

	           //nAtv20213 := nAtv20213 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "203" // Carga fracionada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20313a := nAtv20313a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20313b := nAtv20313b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20313c := nAtv20313c + nSaldo      
             Endif

	           //nAtv20313 := nAtv20313 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "204" // Carga fracionada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20413a := nAtv20413a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20413b := nAtv20413b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20413c := nAtv20413c + nSaldo      
             Endif

	           //nAtv20413 := nAtv20413 + nSaldo      

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "205" // Lote nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20513a := nAtv20513a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20513b := nAtv20513b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20513c := nAtv20513c + nSaldo      
             Endif

	           //nAtv20513 := nAtv20513 + nSaldo      

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "206" // Intercentro nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20613a := nAtv20613a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20613b := nAtv20613b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20613c := nAtv20613c + nSaldo      
             Endif

	           //nAtv20613 := nAtv20613 + nSaldo                                                 

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "207" // Lote internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20713a := nAtv20713a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20713b := nAtv20713b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20713c := nAtv20713c + nSaldo      
             Endif

	           //nAtv20713 := nAtv20713 + nSaldo      

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "208" // Intercentro internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20813a := nAtv20813a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20813b := nAtv20813b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20813c := nAtv20813c + nSaldo      
             Endif

	           //nAtv20813 := nAtv20813 + nSaldo      

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "209" // Transporte emergencial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20913a := nAtv20913a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20913b := nAtv20913b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20913c := nAtv20913c + nSaldo      
             Endif

	           //nAtv20913 := nAtv20913 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "210" // Gefco especial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv21013a := nAtv21013a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv21013b := nAtv21013b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv21013c := nAtv21013c + nSaldo      
             Endif

	           //nAtv21013 := nAtv21013 + nSaldo                
          //Else
	           //nAtvout := nAtvout + nSaldo
	           //AADD(xErro,{SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_CCONT,SE1->E1_VALOR,"1"})
	      
	      Endif

	   //Else        
	       //Msgstop("Filial não cadastrada !")
	   EndIf             

       If  xFilRet == "14" // Sete Lagoas
       
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "201" // Carga fechada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20114a := nAtv20114a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20114b := nAtv20114b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20114c := nAtv20114c + nSaldo      
             Endif

	           //nAtv20112 := nAtv20112 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "202" // Carga fechada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20214a := nAtv20214a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20214b := nAtv20214b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20214c := nAtv20214c + nSaldo      
             Endif

	           //nAtv20212 := nAtv20212 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "203" // Carga fracionada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20314a := nAtv20314a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20314b := nAtv20314b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20314c := nAtv20314c + nSaldo      
             Endif

	           //nAtv20312 := nAtv20312 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "204" // Carga fracionada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20414a := nAtv20414a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20414b := nAtv20414b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20414c := nAtv20414c + nSaldo      
             Endif

	           //nAtv20412 := nAtv20412 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "205" // Lote nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20514a := nAtv20514a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20514b := nAtv20514b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20514c := nAtv20514c + nSaldo      
             Endif

	           //nAtv20512 := nAtv20512 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "206" // Intercentro nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20614a := nAtv20614a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20614b := nAtv20614b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20614c := nAtv20614c + nSaldo      
             Endif

	           //nAtv20612 := nAtv20612 + nSaldo                                                 
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "207" // Lote internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20714a := nAtv20714a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20714b := nAtv20714b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20714c := nAtv20714c + nSaldo      
             Endif

	           //nAtv20712 := nAtv20712 + nSaldo      

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "208" // Intercentro internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20814a := nAtv20814a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20814b := nAtv20814b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20814c := nAtv20814c + nSaldo      
             Endif

	           //nAtv20812 := nAtv20812 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "209" // Transporte emergencial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20914a := nAtv20914a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20914b := nAtv20914b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20914c := nAtv20914c + nSaldo      
             Endif

	           //nAtv20912 := nAtv20912 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "210" // Gefco especial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv21014a := nAtv21014a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv21014b := nAtv21014b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv21014c := nAtv21014c + nSaldo      
             Endif

	           //nAtv21012 := nAtv21012 + nSaldo                
          
          Endif
       
       Endif

       If  xFilRet == "15" // Vitoria
       
	      If Substr(Alltrim(SMC->E1_CCONT),7,3) == "201" // Carga fechada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20115a := nAtv20115a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20115b := nAtv20115b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20115c := nAtv20115c + nSaldo      
             Endif

	           //nAtv20112 := nAtv20112 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "202" // Carga fechada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20215a := nAtv20215a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20215b := nAtv20215b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20215c := nAtv20215c + nSaldo      
             Endif

	           //nAtv20212 := nAtv20212 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "203" // Carga fracionada nacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20315a := nAtv20315a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20315b := nAtv20315b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20315c := nAtv20315c + nSaldo      
             Endif

	           //nAtv20312 := nAtv20312 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "204" // Carga fracionada internacional 
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20415a := nAtv20415a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20415b := nAtv20415b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20415c := nAtv20415c + nSaldo      
             Endif

	           //nAtv20412 := nAtv20412 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "205" // Lote nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20515a := nAtv20515a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20515b := nAtv20515b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20515c := nAtv20515c + nSaldo      
             Endif

	           //nAtv20512 := nAtv20512 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "206" // Intercentro nacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20615a := nAtv20615a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20615b := nAtv20615b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20615c := nAtv20615c + nSaldo      
             Endif

	           //nAtv20612 := nAtv20612 + nSaldo                                                 
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "207" // Lote internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20715a := nAtv20715a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20715b := nAtv20715b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20715c := nAtv20715c + nSaldo      
             Endif

	           //nAtv20712 := nAtv20712 + nSaldo      

	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "208" // Intercentro internacional
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20815a := nAtv20815a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20815b := nAtv20815b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20815c := nAtv20815c + nSaldo      
             Endif

	           //nAtv20812 := nAtv20812 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "209" // Transporte emergencial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv20915a := nAtv20915a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv20915b := nAtv20915b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv20915c := nAtv20915c + nSaldo      
             Endif

	           //nAtv20912 := nAtv20912 + nSaldo      
	      Elseif Substr(Alltrim(SMC->E1_CCONT),7,3) == "210" // Gefco especial
	         If SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
    	        nAtv21015a := nAtv21015a + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "2"        
       	        nAtv21015b := nAtv21015b + nSaldo      
    	     ElseIf SMC->A1_GEFCAT1 == "3"        
    	        nAtv21015c := nAtv21015c + nSaldo      
             Endif

	           //nAtv21012 := nAtv21012 + nSaldo                
          
          Endif
       
       Endif

      nRmlap := nRmlap + nSaldo
      Irmlap := Irmlap + nValor

      Do Case 
         Case SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
              xCatRmlap1 := xCatRmlap1 + nSaldo     
              Irmlap1 := Irmlap1 + nValor
         Case SMC->A1_GEFCAT1 == "2"         // Ventes Hors Groupe GEFCO
              xCatRmlap2 := xCatRmlap2 + nSaldo     
              Irmlap2 := Irmlap2 + nValor              
         Case SMC->A1_GEFCAT1 == "3"         // Ventes Groupe PSA Consolidé         
              xCatRmlap3 := xCatRmlap3 + nSaldo     
              Irmlap3 := Irmlap3 + nValor              
         Otherwise
              xCatRmlap4 := xCatRmlap4 + nSaldo     
              Irmlap4 := Irmlap4 + nValor              
      EndCase

      //Separação Difa/Dlpr/Terceiros   
      If Substr(Alltrim(SMC->E1_CCONT),10,1) == "3"    // Tratamento Difa
         nDifaRmlap := nDifaRmlap + nSaldo     
      Endif          
      If Substr(Alltrim(SMC->E1_CCONT),10,1) == "4"    // Tratamento Dlpr
         nDlprRmlap := nDlprRmlap + nSaldo     
      Endif   
      If Substr(Alltrim(SMC->E1_CCONT),10,1) == "5"    
         nGrupRmlap := nGrupRmlap + nSaldo     
      Endif
      If Substr(Alltrim(SMC->E1_CCONT),10,1) == "6"    // Tratamento Terceiros
         nTercRmlap := nTercRmlap + nSaldo     
      Endif
      
      If !Substr(Alltrim(SMC->E1_CCONT),10,1) $ ("1|2|7|0")    // Diferença
         nDifRmlap := nDifRmlap + nSaldo     
         AADD(xErro,{SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_CCONT,SE1->E1_VALOR,"2"})
      Endif          
        
   Endif

 
   //
   If xUO == "22" .Or. xUO == "23"  // RMA     
	   // Atividades - Metier
	   // Supply / RMA
	   Do Case
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "401"  // Importação Maritima
	           nAtv401 := nAtv401 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "402"  // Exportação Maritima
	           nAtv402 := nAtv402 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "403"  // Importação Aérea
	           nAtv403 := nAtv403 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "404"  // Exportação Aérea
	           nAtv404 := nAtv404 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "405"  // Gefco immediate importação
	           nAtv405 := nAtv405 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "406"  // Gefco immediate exportação
	           nAtv406 := nAtv406 + nSaldo                                                 
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "407"  // Armazenagem
	           nAtv407 := nAtv407 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "408"  // CKD
	           nAtv408 := nAtv408 + nSaldo      
          Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "501"  // Desembaraço importação Maritima
	           nAtv501 := nAtv501 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "502"  // Desembaraço importação Aérea
	           nAtv502 := nAtv502 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "503"  // Desembaraço Exportação maritima
	           nAtv503 := nAtv503 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "504"  // Desembaraço Exportação Aérea
	           nAtv504 := nAtv504 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "505"  // Desembaraço importação rodoviaria
	           nAtv505 := nAtv505 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "506"  // Desembaraço exportação rodoviaria
	           nAtv506 := nAtv506 + nSaldo                                                 
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "507"  // Outsourcing importação
	           nAtv507 := nAtv507 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "508"  // Outsourcing Exportação
	           nAtv508 := nAtv508 + nSaldo      	  
	      OtherWise
	           nAtvout := nAtvout + nSaldo
	           AADD(xErro,{SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_CCONT,SE1->E1_VALOR,"1"})
	   EndCase             
	  
	   /*
	   // Atividades - Metier
	   // Supply / ADUANA
	   Do Case
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "501"  // Desembaraço importação Maritima
	           nAtv501 := nAtv501 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "502"  // Desembaraço importação Aérea
	           nAtv502 := nAtv502 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "503"  // Desembaraço Exportação maritima
	           nAtv503 := nAtv503 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "504"  // Desembaraço Exportação Aérea
	           nAtv504 := nAtv504 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "505"  // Desembaraço importação rodoviaria
	           nAtv505 := nAtv505 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "506"  // Desembaraço exportação rodoviaria
	           nAtv506 := nAtv506 + nSaldo                                                 
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "507"  // Outsourcing importação
	           nAtv507 := nAtv507 + nSaldo      
	      Case Substr(Alltrim(SMC->E1_CCONT),7,3) == "508"  // Outsourcing Exportação
	           nAtv508 := nAtv508 + nSaldo      
	      OtherWise
	           nAtvout := nAtvout + nSaldo
	   EndCase             
	  */
	  
      nRma := nRma + nSaldo      
      Irma := Irma + nValor
      Do Case 
         Case SMC->A1_GEFCAT1 == "1"         // Ventes Hors Groupe PSA           
              xCatRma1 := xCatRma1 + nSaldo     
              Irma1 := Irma1 + nValor
         Case SMC->A1_GEFCAT1 == "2"         // Ventes Hors Groupe GEFCO
              xCatRma2 := xCatRma2 + nSaldo     
              Irma2 := Irma2 + nValor              
         Case SMC->A1_GEFCAT1 == "3"         // Ventes Groupe PSA Consolidé         
              xCatRma3 := xCatRma3 + nSaldo     
              Irma3 := Irma3 + nValor              
         Otherwise
              xCatRma4 := xCatRma4 + nSaldo     
              Irma4 := Irma4 + nValor
      EndCase

      //Separação Difa/Dlpr/Terceiros   
      If Substr(Alltrim(SMC->E1_CCONT),10,1) == "1"    // Tratamento MARCA AP
         nMarcaAP := nMarcaAP + nSaldo     
      Endif          
      If Substr(Alltrim(SMC->E1_CCONT),10,1) == "2"    // Tratamento MARCA AC
         nMarcaAC := nMarcaAC + nSaldo     
      Endif   
      If Substr(Alltrim(SMC->E1_CCONT),10,1) == "3"    // Tratamento Difa
         nDifaRma := nDifaRma + nSaldo     
      Endif          
      If Substr(Alltrim(SMC->E1_CCONT),10,1) == "4"    // Tratamento Dlpr
         nDlprRma := nDlprRma + nSaldo     
      Endif   
      If Substr(Alltrim(SMC->E1_CCONT),10,1) ==  "5"   // Tratamento Terceiros
         nGrupRma := nGrupRma + nSaldo     
      Endif      
      If Substr(Alltrim(SMC->E1_CCONT),10,1) ==  "6"   // Tratamento Terceiros
         nTercRma := nTercRma + nSaldo     
      Endif

      If !Substr(Alltrim(SMC->E1_CCONT),10,1) $ ("7|0")    // Diferença
         nDifRma := nDifRma + nSaldo     
         AADD(xErro,{SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_CCONT,SE1->E1_VALOR,"2"})
      Endif          
     

   Endif
   
   nSaldo := 0 // Zera Saldo
   	
   dbSelectArea("SMC")
   dbSkip() 
   
EndDo



   // Separdos Por UO/Categoria     
   //
    nLin := nLin + 1   
      
   @nLin,001 PSAY "RDVM"
    nLin := nLin + 1       

   @nLin,003 PSAY "Ventes Hors Groupe PSA"
   @nLin,035 PSAY xCatRdvm1  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IRdvm1  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1       

   @nLin,003 PSAY "Ventes Groupe GEFCO"
   @nLin,035 PSAY xCatRdvm2  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IRdvm2  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1       

   @nLin,003 PSAY "Ventes Groupe PSA Consolidé"         
   @nLin,035 PSAY xCatRdvm3  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IRdvm3  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   

   @nLin,003 PSAY "Total RDVM"
   @nLin,035 PSAY xCatRdvm1+xCatRdvm2+xCatRdvm3+xCatRdvm4  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IRdvm1+IRdvm2+IRdvm3+IRdvm4  Picture "@E 999,999,999,999.99"     

    nLin := nLin + 2       


   @nLin,001 PSAY "ILI"
    nLin := nLin + 1          

   @nLin,003 PSAY "Ventes Hors Groupe PSA"
   @nLin,035 PSAY xCatIli1  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IIli1  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1       

   @nLin,003 PSAY "Ventes Groupe GEFCO"
   @nLin,035 PSAY xCatIli2  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IIli2  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1       

   @nLin,003 PSAY "Ventes Groupe PSA Consolidé"         
   @nLin,035 PSAY xCatIli3  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IIli3  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   

   @nLin,003 PSAY "Total ILI"
   @nLin,035 PSAY xCatIli1+xCatIli2+xCatIli3+xCatIli4  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IIli1+IIli2+IIli3+IIli4  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 2       


   @nLin,001 PSAY "RMLAP"
    nLin := nLin + 1          

   @nLin,003 PSAY "Ventes Hors Groupe PSA"
   @nLin,035 PSAY xCatRmlap1  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IRmlap1  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1       

   @nLin,003 PSAY "Ventes Groupe GEFCO"
   @nLin,035 PSAY xCatRmlap2  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IRmlap2  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1       

   @nLin,003 PSAY "Ventes Groupe PSA Consolidé"         
   @nLin,035 PSAY xCatRmlap3  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IRmlap3  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   

   @nLin,003 PSAY "Total RMLAP"
   @nLin,035 PSAY xCatRmlap1+xCatRmlap2+xCatRmlap3+xCatRmlap4  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IRmlap1+IRmlap2+IRmlap3+IRmlap4  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 2       

    
   @nLin,001 PSAY "RMA"
    nLin := nLin + 1          

   @nLin,003 PSAY "Ventes Hors Groupe PSA"
   @nLin,035 PSAY xCatRma1  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IRma1  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1       

   @nLin,003 PSAY "Ventes Groupe GEFCO"
   @nLin,035 PSAY xCatRma2  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IRma2  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1       

   @nLin,003 PSAY "Ventes Groupe PSA Consolidé"         
   @nLin,035 PSAY xCatRma3  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IRma3  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   

   @nLin,003 PSAY "Total RMA"
   @nLin,035 PSAY xCatRma1+xCatRma2+xCatRma3+xCatRma4  Picture "@E 999,999,999,999.99"     
   @nLin,055 PSAY IRma1+IRma2+IRma3+IRma4  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 2          

   // Tratamento dos erros 
   //
   If xCatRma4 > 0
     @nLin,001 PSAY Replicate("-",80)
      nLin := nLin + 1   
     @nLin,001 PSAY "Sem classificação RMA"         
     @nLin,035 PSAY xCatRdvm4+xCatRma4+xCatRmlap4+xCatIli4  Picture "@E 999,999,999,999.99"                    
     nLin := nLin + 1   
   Endif   
   If xCatRdvm4 > 0
     @nLin,001 PSAY Replicate("-",80)
      nLin := nLin + 1   
     @nLin,001 PSAY "Sem classificação RDVM"         
     @nLin,035 PSAY xCatRdvm4  Picture "@E 999,999,999,999.99"                    
     nLin := nLin + 1   
   Endif   
   If xCatIli4 > 0
     @nLin,001 PSAY Replicate("-",80)
      nLin := nLin + 1   
     @nLin,001 PSAY "Sem classificação ILI"         
     @nLin,035 PSAY xCatIli4  Picture "@E 999,999,999,999.99"                    
     nLin := nLin + 1   
   Endif   
   If xCatRmlap4 > 0
     @nLin,001 PSAY Replicate("-",80)
      nLin := nLin + 1   
     @nLin,001 PSAY "Sem classificação RMLAP"         
     @nLin,035 PSAY xCatRmlap4  Picture "@E 999,999,999,999.99"                    
     nLin := nLin + 1   
   Endif   

   @nLin,001 PSAY Replicate("-",80)
    nLin := nLin + 1   
   
   @nLin,001 PSAY "TOTAL GERAL DAS VENDAS"         
   @nLin,035 PSAY nIli+nRma+nRmlap+nRdvm  Picture "@E 999,999,999,999.99"                    
   @nLin,055 PSAY IIli+IRma+IRmlap+IRdvm  Picture "@E 999,999,999,999.99"                    

    nLin := nLin + 2   
                   

   @nLin,001 PSAY "RESUMO ILI"         
    nLin := nLin + 1   
    
   @nLin,001 PSAY "DIFA"
   @nLin,015 PSAY nDifaIli   Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
    
   @nLin,001 PSAY "GRUPO GEFCO"
   @nLin,035 PSAY nGrupIli  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1    
    
   @nLin,001 PSAY "TERCEIROS"
   @nLin,055 PSAY nTercIli   Picture "@E 999,999,999,999.99"     
    nLin := nLin + 2   

 
   @nLin,001 PSAY "RESUMO RMLAP"         
    nLin := nLin + 1   
    
   @nLin,001 PSAY "DIFA"
   @nLin,015 PSAY nDifaRmlap  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   

   @nLin,001 PSAY "DLPR"
   @nLin,015 PSAY nDlprRmlap Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   

   @nLin,001 PSAY "GRUPO GEFCO"
   @nLin,035 PSAY nGrupRmlap  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
             
   @nLin,001 PSAY "TERCEIROS"
   @nLin,015 PSAY nTercRmlap  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 2   

   //@nLin,001 PSAY "BRANCOS   : "
   //@nLin,015 PSAY nDifRmlap  Picture "@E 999,999,999,999.99"     
   // nLin := nLin + 2   
   
   // -----------------
   
   @nLin,001 PSAY "RESUMO RMA"         
    nLin := nLin + 1   
    
   @nLin,001 PSAY "DIFA"
   @nLin,015 PSAY nDifaRma  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   

   @nLin,001 PSAY "DLPR"
   @nLin,015 PSAY nDlprRma Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   

   @nLin,001 PSAY "GRUPO GEFCO"
   @nLin,035 PSAY nGrupRma  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   
   @nLin,001 PSAY "TERCEIROS"
   @nLin,015 PSAY nTercRma  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   

   @nLin,001 PSAY "MARCA AP"
   @nLin,015 PSAY nMarcaAP  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   

   @nLin,001 PSAY "MARCA AC"
   @nLin,015 PSAY nMarcaAC Picture "@E 999,999,999,999.99"     
    nLin := nLin + 2   

   //@nLin,001 PSAY "BRANCOS   : "
   //@nLin,015 PSAY nDifRma  Picture "@E 999,999,999,999.99"     
   // nLin := nLin + 1   
                    
   @nLin,001 PSAY "RESUMO RDVM"         
    nLin := nLin + 1   
    
   @nLin,001 PSAY "MARCA AP"
   @nLin,015 PSAY nDifaRdvm  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   

   @nLin,001 PSAY "MARCA AC"
   @nLin,015 PSAY nDlprRdvm Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   

   @nLin,001 PSAY "GRUPO GEFCO"
   @nLin,035 PSAY nGrupRdvm  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   
   @nLin,001 PSAY "TERCEIROS"
   @nLin,015 PSAY nTercRdvm  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 2   

   //If nLin > 58 
   //   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   //   nLin := 8
   //Endif      
   
   /////////////////////////////
   //                         //
   // 2nd parte do relatorio  //
   //                         //
   /////////////////////////////
   Cabec1 := "     RELATORIO DE VENDAS POR ATIVIDADE          " 
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 8
   
//   For i := 1 To 13
//      nTotRdvm := nTotRdvm + (nAtv00+Str(i))
//   Next
   
   // Quadro de Atividades - Metier   
   // RDVM   
   nTotRdvm := nAtv001+nAtv002+nAtv003+nAtv004+nAtv005+nAtv006+nAtv007+nAtv008+nAtv009+nAtv010+nAtv011+nAtv012+nAtv013
   
   @nLin,001 PSAY "ATIVIDADES RDVM"         
    nLin := nLin + 1   
    
   @nLin,003 PSAY "Transporte Rodoviario Nacional"
   @nLin,055 PSAY nAtv001  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Transporte Rodoviario Nacional de Transferencia"
   @nLin,055 PSAY nAtv002  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Transporte Rodoviario Exportação"
   @nLin,055 PSAY nAtv003  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Transporte Maritimo Exportação"
   @nLin,055 PSAY nAtv004  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Gestão nacional"
   @nLin,055 PSAY nAtv005  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Gestão Exportação"
   @nLin,055 PSAY nAtv006  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Survey Nacional"
   @nLin,055 PSAY nAtv007  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Survey Exportação"
   @nLin,055 PSAY nAtv008  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Tropicalização"
   @nLin,055 PSAY nAtv009  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Armazenagem Nacional"
   @nLin,055 PSAY nAtv010  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Armazenagem Importação"
   @nLin,055 PSAY nAtv011  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Armazenagem Exportação"
   @nLin,055 PSAY nAtv012  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Outros Serviços Logisticos"
   @nLin,055 PSAY nAtv013  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1                                                          
   @nLin,045 PSAY "Total :"
   @nLin,055 PSAY nTotRdvm  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1                                                           
   @nLin,001 PSAY Replicate("-",80)
    nLin := nLin + 2   
                                                       
   // Atividades - Metier
   // PVN   

   If (nAtv101 + nAtv102) > 0

      nTotPvn := nAtv101 + nAtv102
      
      @nLin,001 PSAY "ATIVIDADES PVN"         
       nLin := nLin + 1      
      @nLin,003 PSAY "PVN - VN"
      @nLin,055 PSAY nAtv101  Picture "@E 999,999,999,999.99"     
       nLin := nLin + 1   
      @nLin,003 PSAY "PVN - VO"
      @nLin,055 PSAY nAtv102  Picture "@E 999,999,999,999.99"     
       nLin := nLin + 1                                                          
      @nLin,045 PSAY "Total :"
      @nLin,055 PSAY nTotPvn  Picture "@E 999,999,999,999.99"     
       nLin := nLin + 1                                                           
      @nLin,001 PSAY Replicate("-",80)
       nLin := nLin + 2   

   Endif
   
   // Atividades - Metier
   // Network - RMLAP   

   nTotRmlap := nAtv201+nAtv202+nAtv203+nAtv204+nAtv205+nAtv206+nAtv207+nAtv208+nAtv209+nAtv210

   @nLin,001 PSAY "ATIVIDADES RMLAP"         
    nLin := nLin + 1   
   @nLin,003 PSAY "Carga Fechada Nacional"
   @nLin,055 PSAY nAtv201  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Carga Fechada Internacional "
   @nLin,055 PSAY nAtv202  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1  
   @nLin,003 PSAY "Carga Fracionada Nacional "
   @nLin,055 PSAY nAtv203  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Carga Fracionada Internacional "
   @nLin,055 PSAY nAtv204  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Lote Nacional"
   @nLin,055 PSAY nAtv205  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Intercentro Nacional"
   @nLin,055 PSAY nAtv206  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Lote Internacional"
   @nLin,055 PSAY nAtv207  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Intercentro Internacional"
   @nLin,055 PSAY nAtv208  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Transporte Emergencial"
   @nLin,055 PSAY nAtv209  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Gefco Especial"
   @nLin,055 PSAY nAtv210  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1                                                          
   @nLin,045 PSAY "Total :"
   @nLin,055 PSAY nTotRmlap  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1                                                           
   @nLin,001 PSAY Replicate("-",80)
    nLin := nLin + 2   


   // Atividades - Metier
   // Supply - ILI   
   nTotIli := nAtv301+nAtv302+nAtv303+nAtv304+nAtv305+nAtv306+nAtv307

   @nLin,001 PSAY "ATIVIDADES ILI"         
    nLin := nLin + 1   
   @nLin,003 PSAY "Abastecimento Sincrono"
   @nLin,055 PSAY nAtv301  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Abastecimento Kanban"
   @nLin,055 PSAY nAtv302  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1  
   @nLin,003 PSAY "Preparação de Kits"
   @nLin,055 PSAY nAtv303  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Armazenagem"
   @nLin,055 PSAY nAtv304  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Outsourcing"
   @nLin,055 PSAY nAtv305  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Preparação de Embalagens"
   @nLin,055 PSAY nAtv306  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Consultoria Logistica"
   @nLin,055 PSAY nAtv307  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1                                                          
   @nLin,045 PSAY "Total :"
   @nLin,055 PSAY nTotIli  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1                                                           
   @nLin,001 PSAY Replicate("-",80)
    nLin := nLin + 2   


   // Atividades - Metier
   // Supply - RMA
   nTotRma := nAtv401+nAtv402+nAtv403+nAtv404+nAtv405+nAtv406+nAtv407+nAtv408
      
   @nLin,001 PSAY "ATIVIDADES RMA"         
    nLin := nLin + 1   
   @nLin,003 PSAY "Importação Maritima"
   @nLin,055 PSAY nAtv401  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Exportação Maritima"
   @nLin,055 PSAY nAtv402  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1  
   @nLin,003 PSAY "Importação Aérea"
   @nLin,055 PSAY nAtv403  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Exportação Aérea"
   @nLin,055 PSAY nAtv404  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Gefco Immediate Importação"
   @nLin,055 PSAY nAtv405  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Gefco Immediate Exportação"
   @nLin,055 PSAY nAtv406  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Armazenagem"
   @nLin,055 PSAY nAtv407  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "CKD"
   @nLin,055 PSAY nAtv408  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1                                                          
   @nLin,045 PSAY "Total :"
   @nLin,055 PSAY nTotRma  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1                                                           
   @nLin,001 PSAY Replicate("-",80)
    nLin := nLin + 2   

	   If nLin > 58 
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	   Endif      

   // Atividades - Metier
   // Supply - ADUANA
   nTotaduana := nAtv501+nAtv502+nAtv503+nAtv504+nAtv505+nAtv506+nAtv507+nAtv508

   @nLin,001 PSAY "ATIVIDADES ADUANA"         
    nLin := nLin + 1   
   @nLin,003 PSAY "Desembaraço Importação Maritima"
   @nLin,055 PSAY nAtv501  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Desembaraço Importação Aérea"
   @nLin,055 PSAY nAtv502  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1  
   @nLin,003 PSAY "Desembaraço Exportação Maritima"
   @nLin,055 PSAY nAtv503  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Desembaraço Exportação Aérea"
   @nLin,055 PSAY nAtv504  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Desembaraço Importação Rodoviaria"
   @nLin,055 PSAY nAtv505  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Desembaraço Exportação Rodoviaria"
   @nLin,055 PSAY nAtv506  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Outsourcing Importação"
   @nLin,055 PSAY nAtv507  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1   
   @nLin,003 PSAY "Outsourcing Exportação"
   @nLin,055 PSAY nAtv508  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1                                                          
   @nLin,045 PSAY "Total :"
   @nLin,055 PSAY nTotaduana  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 1                                                           
   @nLin,001 PSAY Replicate("-",80)
    nLin := nLin + 2   


   // Atividades - Metier
   // Sem Atividade
   If nAtvout > 0
       nLin := nLin + 1                                                          
      @nLin,001 PSAY Replicate("-",80)
       nLin := nLin + 1   
      @nLin,005 PSAY "Sem Atividade : "
      @nLin,055 PSAY nAtvout  Picture "@E 999,999,999,999.99"     
       nLin := nLin + 1   
   Endif

   //If nLin > 58 
   //   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   //   nLin := 8
   //Endif      

   /////////////////////////////
   //                         //
   // 3nd parte do relatorio  //
   //                         //
   /////////////////////////////
   //Cabec1 := "     RELATORIO NÃO CONFORMIDADES          " 
   //Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   //nLin := 8

   // Log de Erros - Tipos no Array
   // 1- Atividade não cadastrada
   // 2- Designação da venda errada
   // 3- Categoria Difere da Atividade ( AGUARDANDO DEFINIÇÕES )
   
   // [xErro] = Matriz de 6 posições (1-Filial, 2-Prefixo, 3-Numero, 4-Centro de custo, 5-Valor, 6- Tipo de erro)   
   /*
   For x := 1 To Len(xErro)
   	   @ nLin,001 Psay "Filial " + xErro[x][1] + " Titulo " + xErro[x][2] + xErro[x][3] + " C. Custo " + xErro[x][4] +" Valor "
   	   @ nLin,055 Psay xErro[x][5]   
   	   @ nLin,075 Psay IIF(xErro[x][6]=="1","Atividade não cadastrada",IIF(xErro[x][6]=="2","Designação da venda errada",IIF(xErro[x][6]=="3","Categoria Difere da Atividade","")))
	   If nLin > 58 
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	   Endif      
	
   Next	   
   */

   //If nLin > 58 
      Cabec1 := "      FILIAL           |   A551   |   A553   |   A501   |   A507   |   A561"
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   //Endif      

   // Atividades - Metier
   // Network - RMLAP   
   // SEPARADO POR FILIAL
   /*
   nTotRmlap   := nAtv201+nAtv202+nAtv203+nAtv204+nAtv205+nAtv206+nAtv207+nAtv208+nAtv209+nAtv210
   nTotRmlap02 := nAtv20102+nAtv20202+nAtv20302+nAtv20402+nAtv20502+nAtv20602+nAtv20702+nAtv20802+nAtv20902+nAtv21002
   nTotRmlap03 := nAtv20103+nAtv20203+nAtv20303+nAtv20403+nAtv20503+nAtv20603+nAtv20703+nAtv20803+nAtv20903+nAtv21003
   nTotRmlap04 := nAtv20104+nAtv20204+nAtv20304+nAtv20404+nAtv20504+nAtv20604+nAtv20704+nAtv20804+nAtv20904+nAtv21004
   nTotRmlap05 := nAtv20105+nAtv20205+nAtv20305+nAtv20405+nAtv20505+nAtv20605+nAtv20705+nAtv20805+nAtv20905+nAtv21005
   nTotRmlap06 := nAtv20106+nAtv20206+nAtv20306+nAtv20406+nAtv20506+nAtv20606+nAtv20706+nAtv20806+nAtv20906+nAtv21006
   nTotRmlap07 := nAtv20107+nAtv20207+nAtv20307+nAtv20407+nAtv20507+nAtv20607+nAtv20707+nAtv20807+nAtv20907+nAtv21007
   nTotRmlap08 := nAtv20108+nAtv20208+nAtv20308+nAtv20408+nAtv20508+nAtv20608+nAtv20708+nAtv20808+nAtv20908+nAtv21008
   nTotRmlap09 := nAtv20109+nAtv20209+nAtv20309+nAtv20409+nAtv20509+nAtv20609+nAtv20709+nAtv20809+nAtv20909+nAtv21009
   nTotRmlap10 := nAtv20110+nAtv20210+nAtv20310+nAtv20410+nAtv20510+nAtv20610+nAtv20710+nAtv20810+nAtv20910+nAtv21010
   nTotRmlap11 := nAtv20111+nAtv20211+nAtv20311+nAtv20411+nAtv20511+nAtv20611+nAtv20711+nAtv20811+nAtv20911+nAtv21011
   nTotRmlap12 := nAtv20112+nAtv20212+nAtv20312+nAtv20412+nAtv20512+nAtv20612+nAtv20712+nAtv20812+nAtv20912+nAtv21012
   nTotRmlap13 := nAtv20113+nAtv20213+nAtv20313+nAtv20413+nAtv20513+nAtv20613+nAtv20713+nAtv20813+nAtv20913+nAtv21013
   nTotRmlap14 := nAtv20114+nAtv20214+nAtv20314+nAtv20414+nAtv20514+nAtv20614+nAtv20714+nAtv20814+nAtv20914+nAtv21014
   */

   //////////////////
   //              //
   // Fora Grupo   //
   //     (1)      //
   //////////////////

   f01A551 := nAtv201a+nAtv203a+nAtv206a // 201+203+206 (Filial 01)
   f02A551 := nAtv20102a+nAtv20302a+nAtv20602a
   f03A551 := nAtv20103a+nAtv20303a+nAtv20603a
   f04A551 := nAtv20104a+nAtv20304a+nAtv20604a
   f05A551 := nAtv20105a+nAtv20305a+nAtv20605a
   f06A551 := nAtv20106a+nAtv20306a+nAtv20606a
   f07A551 := nAtv20107a+nAtv20307a+nAtv20607a
   f08A551 := nAtv20108a+nAtv20308a+nAtv20608a
   f09A551 := nAtv20109a+nAtv20309a+nAtv20609a
   f10A551 := nAtv20110a+nAtv20310a+nAtv20610a
   f11A551 := nAtv20111a+nAtv20311a+nAtv20611a
   f12A551 := nAtv20112a+nAtv20312a+nAtv20612a
   f13A551 := nAtv20113a+nAtv20313a+nAtv20613a
   f14A551 := nAtv20114a+nAtv20314a+nAtv20614a
   f15A551 := nAtv20115a+nAtv20315a+nAtv20615a      
   
   f01A553 := nAtv202a+nAtv204a+nAtv208a // 202+204+208
   f02A553 := nAtv20202a+nAtv20402a+nAtv20802a
   f03A553 := nAtv20203a+nAtv20403a+nAtv20803a
   f04A553 := nAtv20204a+nAtv20404a+nAtv20804a
   f05A553 := nAtv20205a+nAtv20405a+nAtv20805a
   f06A553 := nAtv20206a+nAtv20406a+nAtv20806a
   f07A553 := nAtv20207a+nAtv20407a+nAtv20807a
   f08A553 := nAtv20208a+nAtv20408a+nAtv20808a
   f09A553 := nAtv20209a+nAtv20409a+nAtv20809a
   f10A553 := nAtv20210a+nAtv20410a+nAtv20810a
   f11A553 := nAtv20210a+nAtv20410a+nAtv20810a
   f12A553 := nAtv20212a+nAtv20412a+nAtv20812a
   f13A553 := nAtv20213a+nAtv20413a+nAtv20813a
   f14A553 := nAtv20214a+nAtv20414a+nAtv20814a
   f15A553 := nAtv20215a+nAtv20415a+nAtv20815a      
   
   f01A501 := nAtv205a+nAtv207a  //205+207 
   f02A501 := nAtv20502a+nAtv20702a
   f03A501 := nAtv20503a+nAtv20703a
   f04A501 := nAtv20504a+nAtv20704a
   f05A501 := nAtv20505a+nAtv20705a
   f06A501 := nAtv20506a+nAtv20706a
   f07A501 := nAtv20507a+nAtv20707a
   f08A501 := nAtv20508a+nAtv20708a
   f09A501 := nAtv20509a+nAtv20709a
   f10A501 := nAtv20510a+nAtv20710a
   f11A501 := nAtv20511a+nAtv20711a
   f12A501 := nAtv20512a+nAtv20712a
   f13A501 := nAtv20513a+nAtv20713a
   f14A501 := nAtv20514a+nAtv20714a
   f15A501 := nAtv20515a+nAtv20715a      

   f01A561 := nAtv210a+nAtv209a // 209+210 (Filial 01)
   f02A561 := nAtv21002a+nAtv20902a
   f03A561 := nAtv21003a+nAtv20903a
   f04A561 := nAtv21004a+nAtv20904a
   f05A561 := nAtv21005a+nAtv20905a
   f06A561 := nAtv21006a+nAtv20906a
   f07A561 := nAtv21007a+nAtv20907a
   f08A561 := nAtv21008a+nAtv20908a
   f09A561 := nAtv21009a+nAtv20909a
   f10A561 := nAtv21010a+nAtv20910a
   f11A561 := nAtv21011a+nAtv20911a
   f12A561 := nAtv21012a+nAtv20912a
   f13A561 := nAtv21013a+nAtv20913a
   f14A561 := nAtv21014a+nAtv20914a
   f15A561 := nAtv21015a+nAtv20915a      

   //////////////////
   //              //
   // Grupo GEFCO  //
   //     (2)      //
   //////////////////

   g01A551 := nAtv201b+nAtv203b+nAtv206b // 201+203+206 (Filial 01)
   g02A551 := nAtv20102b+nAtv20302b+nAtv20602b
   g03A551 := nAtv20103b+nAtv20303b+nAtv20603b
   g04A551 := nAtv20104b+nAtv20304b+nAtv20604b
   g05A551 := nAtv20105b+nAtv20305b+nAtv20605b
   g06A551 := nAtv20106b+nAtv20306b+nAtv20606b
   g07A551 := nAtv20107b+nAtv20307b+nAtv20607b
   g08A551 := nAtv20108b+nAtv20308b+nAtv20608b
   g09A551 := nAtv20109b+nAtv20309b+nAtv20609b
   g10A551 := nAtv20110b+nAtv20310b+nAtv20610b
   g11A551 := nAtv20111b+nAtv20311b+nAtv20611b
   g12A551 := nAtv20112b+nAtv20312b+nAtv20612b
   g13A551 := nAtv20113b+nAtv20313b+nAtv20613b
   g14A551 := nAtv20114b+nAtv20314b+nAtv20614b
   g15A551 := nAtv20115b+nAtv20315b+nAtv20615b   
   
   g01A553 := nAtv202b+nAtv204b+nAtv208b // 202+204+208
   g02A553 := nAtv20202b+nAtv20402b+nAtv20802b
   g03A553 := nAtv20203b+nAtv20403b+nAtv20803b
   g04A553 := nAtv20204b+nAtv20404b+nAtv20804b
   g05A553 := nAtv20205b+nAtv20405b+nAtv20805b
   g06A553 := nAtv20206b+nAtv20406b+nAtv20806b
   g07A553 := nAtv20207b+nAtv20407b+nAtv20807b
   g08A553 := nAtv20208b+nAtv20408b+nAtv20808b
   g09A553 := nAtv20209b+nAtv20409b+nAtv20809b
   g10A553 := nAtv20210b+nAtv20410b+nAtv20810b
   g11A553 := nAtv20210b+nAtv20410b+nAtv20810b
   g12A553 := nAtv20212b+nAtv20412b+nAtv20812b
   g13A553 := nAtv20213b+nAtv20413b+nAtv20813b
   g14A553 := nAtv20214b+nAtv20414b+nAtv20814b
   g15A553 := nAtv20215b+nAtv20415b+nAtv20815b      
   
   g01A501 := nAtv205b+nAtv207b  //205+207 
   g02A501 := nAtv20502b+nAtv20702b
   g03A501 := nAtv20503b+nAtv20703b
   g04A501 := nAtv20504b+nAtv20704b
   g05A501 := nAtv20505b+nAtv20705b
   g06A501 := nAtv20506b+nAtv20706b
   g07A501 := nAtv20507b+nAtv20707b
   g08A501 := nAtv20508b+nAtv20708b
   g09A501 := nAtv20509b+nAtv20709b
   g10A501 := nAtv20510b+nAtv20710b
   g11A501 := nAtv20511b+nAtv20711b
   g12A501 := nAtv20512b+nAtv20712b
   g13A501 := nAtv20513b+nAtv20713b
   g14A501 := nAtv20514b+nAtv20714b
   g15A501 := nAtv20515b+nAtv20715b      

   g01A561 := nAtv210b+nAtv209b // 209+210 (Filial 01)
   g02A561 := nAtv21002b+nAtv20902b
   g03A561 := nAtv21003b+nAtv20903b
   g04A561 := nAtv21004b+nAtv20904b
   g05A561 := nAtv21005b+nAtv20905b
   g06A561 := nAtv21006b+nAtv20906b
   g07A561 := nAtv21007b+nAtv20907b
   g08A561 := nAtv21008b+nAtv20908b
   g09A561 := nAtv21009b+nAtv20909b
   g10A561 := nAtv21010b+nAtv20910b
   g11A561 := nAtv21011b+nAtv20911b
   g12A561 := nAtv21012b+nAtv20912b
   g13A561 := nAtv21013b+nAtv20913b
   g14A561 := nAtv21014b+nAtv20914b
   g15A561 := nAtv21015b+nAtv20915b   

   //////////////////
   //              //
   // Grupo PSA    //
   //     (3)      //
   //////////////////

   p01A551 := nAtv201c+nAtv203c+nAtv206c // 201+203+206 (Filial 01)
   p02A551 := nAtv20102c+nAtv20302c+nAtv20602c
   p03A551 := nAtv20103c+nAtv20303c+nAtv20603c
   p04A551 := nAtv20104c+nAtv20304c+nAtv20604c
   p05A551 := nAtv20105c+nAtv20305c+nAtv20605c
   p06A551 := nAtv20106c+nAtv20306c+nAtv20606c
   p07A551 := nAtv20107c+nAtv20307c+nAtv20607c
   p08A551 := nAtv20108c+nAtv20308c+nAtv20608c
   p09A551 := nAtv20109c+nAtv20309c+nAtv20609c
   p10A551 := nAtv20110c+nAtv20310c+nAtv20610c
   p11A551 := nAtv20111c+nAtv20311c+nAtv20611c
   p12A551 := nAtv20112c+nAtv20312c+nAtv20612c
   p13A551 := nAtv20113c+nAtv20313c+nAtv20613c
   p14A551 := nAtv20114c+nAtv20314c+nAtv20614c   
   p15A551 := nAtv20115c+nAtv20315c+nAtv20615c   
   
   p01A553 := nAtv202c+nAtv204c+nAtv208c // 202+204+208
   p02A553 := nAtv20202c+nAtv20402c+nAtv20802c
   p03A553 := nAtv20203c+nAtv20403c+nAtv20803c
   p04A553 := nAtv20204c+nAtv20404c+nAtv20804c
   p05A553 := nAtv20205c+nAtv20405c+nAtv20805c
   p06A553 := nAtv20206c+nAtv20406c+nAtv20806c
   p07A553 := nAtv20207c+nAtv20407c+nAtv20807c
   p08A553 := nAtv20208c+nAtv20408c+nAtv20808c
   p09A553 := nAtv20209c+nAtv20409c+nAtv20809c
   p10A553 := nAtv20210c+nAtv20410c+nAtv20810c
   p11A553 := nAtv20210c+nAtv20410c+nAtv20810c
   p12A553 := nAtv20212c+nAtv20412c+nAtv20812c
   p13A553 := nAtv20213c+nAtv20413c+nAtv20813c
   p14A553 := nAtv20214c+nAtv20414c+nAtv20814c
   p15A553 := nAtv20215c+nAtv20415c+nAtv20815c   
   
   p01A501 := nAtv205c+nAtv207c  //205+207 
   p02A501 := nAtv20502c+nAtv20702c
   p03A501 := nAtv20503c+nAtv20703c
   p04A501 := nAtv20504c+nAtv20704c
   p05A501 := nAtv20505c+nAtv20705c
   p06A501 := nAtv20506c+nAtv20706c
   p07A501 := nAtv20507c+nAtv20707c
   p08A501 := nAtv20508c+nAtv20708c
   p09A501 := nAtv20509c+nAtv20709c
   p10A501 := nAtv20510c+nAtv20710c
   p11A501 := nAtv20511c+nAtv20711c
   p12A501 := nAtv20512c+nAtv20712c
   p13A501 := nAtv20513c+nAtv20713c
   p14A501 := nAtv20514c+nAtv20714c
   p15A501 := nAtv20515c+nAtv20715c      

   p01A561 := nAtv210c+nAtv209c // 209+210 (Filial 01)
   p02A561 := nAtv21002c+nAtv20902c
   p03A561 := nAtv21003c+nAtv20903c
   p04A561 := nAtv21004c+nAtv20904c
   p05A561 := nAtv21005c+nAtv20905c
   p06A561 := nAtv21006c+nAtv20906c
   p07A561 := nAtv21007c+nAtv20907c
   p08A561 := nAtv21008c+nAtv20908c
   p09A561 := nAtv21009c+nAtv20909c
   p10A561 := nAtv21010c+nAtv20910c
   p11A561 := nAtv21011c+nAtv20911c
   p12A561 := nAtv21012c+nAtv20912c
   p13A561 := nAtv21013c+nAtv20913c
   p14A561 := nAtv21014c+nAtv20914c
   p15A561 := nAtv21015c+nAtv20915c   



   //////////////////
   //              //
   // Total Geral  //
   //              //
   //////////////////
   n01A551 := nAtv201a+nAtv201b+nAtv201c+nAtv203a+nAtv203b+nAtv203c+nAtv206a+nAtv206b+nAtv206c // 201+203+206 (Filial 01)
   n02A551 := nAtv20102a+nAtv20102b+nAtv20102c+nAtv20302a+nAtv20302b+nAtv20302c+nAtv20602a+nAtv20602b+nAtv20602c
   n03A551 := nAtv20103a+nAtv20103b+nAtv20103c+nAtv20303a+nAtv20303b+nAtv20303c+nAtv20603a+nAtv20603b+nAtv20603c
   n04A551 := nAtv20104a+nAtv20104b+nAtv20104c+nAtv20304a+nAtv20304b+nAtv20304c+nAtv20604a+nAtv20604b+nAtv20604c
   n05A551 := nAtv20105a+nAtv20105b+nAtv20105c+nAtv20305a+nAtv20305b+nAtv20305c+nAtv20605a+nAtv20605b+nAtv20605c
   n06A551 := nAtv20106a+nAtv20106b+nAtv20106c+nAtv20306a+nAtv20306b+nAtv20306c+nAtv20606a+nAtv20606b+nAtv20606c
   n07A551 := nAtv20107a+nAtv20107b+nAtv20107c+nAtv20307a+nAtv20307b+nAtv20307c+nAtv20607a+nAtv20607b+nAtv20607c
   n08A551 := nAtv20108a+nAtv20108b+nAtv20108c+nAtv20308a+nAtv20308b+nAtv20308c+nAtv20608a+nAtv20608b+nAtv20608c
   n09A551 := nAtv20109a+nAtv20109b+nAtv20109c+nAtv20309a+nAtv20309b+nAtv20309c+nAtv20609a+nAtv20609b+nAtv20609c
   n10A551 := nAtv20110a+nAtv20110b+nAtv20110c+nAtv20310a+nAtv20310b+nAtv20310c+nAtv20610a+nAtv20610b+nAtv20610c
   n11A551 := nAtv20111a+nAtv20111b+nAtv20111c+nAtv20311a+nAtv20311b+nAtv20311c+nAtv20611a+nAtv20611b+nAtv20611c
   n12A551 := nAtv20112a+nAtv20112b+nAtv20112c+nAtv20312a+nAtv20312b+nAtv20312c+nAtv20612a+nAtv20612b+nAtv20612c
   n13A551 := nAtv20113a+nAtv20113b+nAtv20113c+nAtv20313a+nAtv20313b+nAtv20313c+nAtv20613a+nAtv20613b+nAtv20613c
   n14A551 := nAtv20114a+nAtv20114b+nAtv20114c+nAtv20314a+nAtv20314b+nAtv20314c+nAtv20614a+nAtv20614b+nAtv20614c
   n15A551 := nAtv20115a+nAtv20115b+nAtv20115c+nAtv20315a+nAtv20315b+nAtv20315c+nAtv20615a+nAtv20615b+nAtv20615c      
   
   n01A553 := nAtv202a+nAtv202b+nAtv202c+nAtv204a+nAtv204b+nAtv204c+nAtv208a+nAtv208b+nAtv208c // 202+204+208
   n02A553 := nAtv20202a+nAtv20202b+nAtv20202c+nAtv20402a+nAtv20402b+nAtv20402c+nAtv20802a+nAtv20802b+nAtv20802c
   n03A553 := nAtv20203a+nAtv20203b+nAtv20203c+nAtv20403a+nAtv20403b+nAtv20403c+nAtv20803a+nAtv20803b+nAtv20803c
   n04A553 := nAtv20204a+nAtv20204b+nAtv20204c+nAtv20404a+nAtv20404b+nAtv20404c+nAtv20804a+nAtv20804b+nAtv20804c
   n05A553 := nAtv20205a+nAtv20205b+nAtv20205c+nAtv20405a+nAtv20405b+nAtv20405c+nAtv20805a+nAtv20805b+nAtv20805c
   n06A553 := nAtv20206a+nAtv20206b+nAtv20206c+nAtv20406a+nAtv20406b+nAtv20406c+nAtv20806a+nAtv20806b+nAtv20806c
   n07A553 := nAtv20207a+nAtv20207b+nAtv20207c+nAtv20407a+nAtv20407b+nAtv20407c+nAtv20807a+nAtv20807b+nAtv20807c
   n08A553 := nAtv20208a+nAtv20208b+nAtv20208c+nAtv20408a+nAtv20408b+nAtv20408c+nAtv20808a+nAtv20808b+nAtv20808c
   n09A553 := nAtv20209a+nAtv20209b+nAtv20209c+nAtv20409a+nAtv20409b+nAtv20409c+nAtv20809a+nAtv20809b+nAtv20809c
   n10A553 := nAtv20210a+nAtv20210b+nAtv20210c+nAtv20410a+nAtv20410b+nAtv20410c+nAtv20810a+nAtv20810b+nAtv20810c
   n11A553 := nAtv20210a+nAtv20210b+nAtv20210c+nAtv20410a+nAtv20410b+nAtv20410c+nAtv20810a+nAtv20810b+nAtv20810c
   n12A553 := nAtv20212a+nAtv20212b+nAtv20212c+nAtv20412a+nAtv20412b+nAtv20412c+nAtv20812a+nAtv20812b+nAtv20812c
   n13A553 := nAtv20213a+nAtv20213b+nAtv20213c+nAtv20413a+nAtv20413b+nAtv20413c+nAtv20813a+nAtv20813b+nAtv20813c
   n14A553 := nAtv20214a+nAtv20214b+nAtv20214c+nAtv20414a+nAtv20414b+nAtv20414c+nAtv20814a+nAtv20814b+nAtv20814c
   n15A553 := nAtv20215a+nAtv20215b+nAtv20215c+nAtv20415a+nAtv20415b+nAtv20415c+nAtv20815a+nAtv20815b+nAtv20815c   
           
   n01A561 := nAtv210a+nAtv210b+nAtv210c+nAtv209a+nAtv209b+nAtv209c // 209+210 (Filial 01)
   n02A561 := nAtv21002a+nAtv21002b+nAtv21002c+nAtv20902a+nAtv20902b+nAtv20902c
   n03A561 := nAtv21003a+nAtv21003b+nAtv21003c+nAtv20903a+nAtv20903b+nAtv20903c
   n04A561 := nAtv21004a+nAtv21004b+nAtv21004c+nAtv20904a+nAtv20904b+nAtv20904c
   n05A561 := nAtv21005a+nAtv21005b+nAtv21005c+nAtv20905a+nAtv20905b+nAtv20905c
   n06A561 := nAtv21006a+nAtv21006b+nAtv21006c+nAtv20906a+nAtv20906b+nAtv20906c
   n07A561 := nAtv21007a+nAtv21007b+nAtv21007c+nAtv20907a+nAtv20907b+nAtv20907c
   n08A561 := nAtv21008a+nAtv21008b+nAtv21008c+nAtv20908a+nAtv20908b+nAtv20908c
   n09A561 := nAtv21009a+nAtv21009b+nAtv21009c+nAtv20909a+nAtv20909b+nAtv20909c
   n10A561 := nAtv21010a+nAtv21010b+nAtv21010c+nAtv20910a+nAtv20910b+nAtv20910c
   n11A561 := nAtv21011a+nAtv21011b+nAtv21011c+nAtv20911a+nAtv20911b+nAtv20911c
   n12A561 := nAtv21012a+nAtv21012b+nAtv21012c+nAtv20912a+nAtv20912b+nAtv20912c
   n13A561 := nAtv21013a+nAtv21013b+nAtv21013c+nAtv20913a+nAtv20913b+nAtv20913c
   n14A561 := nAtv21014a+nAtv21014b+nAtv21014c+nAtv20914a+nAtv20914b+nAtv20914c
   n15A561 := nAtv21015a+nAtv21015b+nAtv21015c+nAtv20915a+nAtv20915b+nAtv20915c      

   //---------------------------------
   /*
   @nLin,001 PSAY "MATRIZ"         
    nLin := nLin + 1                                       

   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY f01A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY f01A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY f01A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f01A507  Picture "@E 999,999,999.99"     
   @nLin,058 PSAY f01A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY g01A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY g01A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY g01A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY g01A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY g01A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY p01A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY p01A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY p01A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY p01A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY p01A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,001 PSAY "TOTAL MATRIZ"         
    nLin := nLin + 1                                       
   @nLin,013 PSAY n01A551  Picture "@E 9,999,999.99"     
   @nLin,028 PSAY n01A553  Picture "@E 9,999,999.99"     
   @nLin,041 PSAY n01A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY n01A507  Picture "@E 9,999,999.99"     
   @nLin,067 PSAY n01A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 2                                       
  
  //---------------------------------------

   @nLin,001 PSAY "BENEDITINOS"         
    nLin := nLin + 1                                       
   @nLin,001 PSAY "HORS GROUPE"         
   @nLin,013 PSAY f02A551  Picture "@E 9,999,999.99"     
   @nLin,028 PSAY f02A553  Picture "@E 9,999,999.99"     
   @nLin,041 PSAY f02A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f02A507  Picture "@E 9,999,999.99"     
   @nLin,067 PSAY f02A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,001 PSAY "GROUPE GEFCO"         
   @nLin,013 PSAY g02A551  Picture "@E 9,999,999.99"     
   @nLin,028 PSAY g02A553  Picture "@E 9,999,999.99"     
   @nLin,041 PSAY g02A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY g02A507  Picture "@E 9,999,999.99"     
   @nLin,067 PSAY g02A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,001 PSAY "PSA CONSOLIDÉ"                   
   @nLin,013 PSAY p02A551  Picture "@E 9,999,999.99"     
   @nLin,028 PSAY p02A553  Picture "@E 9,999,999.99"     
   @nLin,041 PSAY p02A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY p02A507  Picture "@E 9,999,999.99"     
   @nLin,067 PSAY p02A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
    
   @nLin,001 PSAY "TOTAL BENEDITINOS"
   @nLin,013 PSAY n02A551  Picture "@E 9,999,999.99"     
   @nLin,028 PSAY n02A553  Picture "@E 9,999,999.99"     
   @nLin,041 PSAY n02A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY n02A507  Picture "@E 9,999,999.99"     
   @nLin,067 PSAY n02A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   
   
   */
  //------------------------------------------------
   

   @nLin,001 PSAY "PORTO REAL"         
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY f03A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY f03A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY f03A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f03A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY f03A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY g03A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY g03A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY g03A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY g03A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY g03A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY p03A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY p03A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY p03A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY p03A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY p03A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
    
   @nLin,002 PSAY "TOTAL PORTO REAL"
   @nLin,022 PSAY n03A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY n03A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY n03A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY n03A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY n03A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   
 
   //--------------------------------------
                   
   @nLin,001 PSAY "BARUERI"         
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY f04A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY f04A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY f04A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f04A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY f04A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY g04A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY g04A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY g04A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY g04A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY g04A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY p04A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY p04A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY p04A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY p04A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY p04A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "TOTAL BARUERI"
   @nLin,022 PSAY n04A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY n04A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY n04A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY n04A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY n04A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   

   //-------------------------------------------
   
   @nLin,001 PSAY "PAVUNA"         
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY f05A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY f05A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY f05A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f05A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY f05A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY g05A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY g05A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY g05A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY g05A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY g05A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY p05A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY p05A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY p05A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY p05A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY p05A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "TOTAL PAVUNA"
   @nLin,022 PSAY n05A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY n05A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY n05A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY n05A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY n05A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   

   //--------------------------------
   @nLin,001 PSAY "V.GUILHERME"         
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY f06A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY f06A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY f06A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f06A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY f06A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY g06A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY g06A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY g06A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY g06A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY g06A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY p06A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY p06A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY p06A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY p06A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY p06A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "TOTAL V.GUILHERME"         
   @nLin,022 PSAY n06A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY n06A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY n06A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f06A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY n06A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 2                                       

   //---------------------

   @nLin,001 PSAY "S.J.PINHAIS"         
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY f07A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY f07A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY f07A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f07A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY f07A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY g07A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY g07A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY g07A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY g07A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY g07A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY p07A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY p07A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY p07A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY p07A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY p07A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "TOTAL S.J.PINHAIS"
   @nLin,022 PSAY n07A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY n07A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY n07A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY n07A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY n07A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   
   
   //---------------------

   @nLin,001 PSAY "CAMPINAS"
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY f08A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY f08A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY f08A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f08A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY f08A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY g08A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY g08A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY g08A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY g08A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY g08A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY p08A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY p08A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY p08A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY p08A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY p08A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "TOTAL CAMPINAS"
   @nLin,022 PSAY n08A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY n08A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY n08A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY n08A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY n08A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   
   
   //-----------------------

   @nLin,001 PSAY "CONTAGEM"
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY f09A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY f09A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY f09A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f09A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY f09A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY g09A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY g09A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY g09A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY g09A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY g09A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY p09A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY p09A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY p09A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY p09A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY p09A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   
   @nLin,002 PSAY "TOTAL CONTAGEM"
   @nLin,022 PSAY n09A551    Picture "@E 9,999,999.99"     
   @nLin,034 PSAY n09A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY n09A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY n09A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY n09A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   
                     
  //------------------------

   @nLin,001 PSAY "SEPETIBA"
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY f10A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY f10A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY f10A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f10A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY f10A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY g10A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY g10A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY g10A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY g10A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY g10A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY p10A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY p10A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY p10A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY p10A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY p10A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
  
   @nLin,002 PSAY "TOTAL SEPETIBA"
   @nLin,022 PSAY n10A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY n10A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY n10A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY n10A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY n10A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 2 
    
    //-----------------------  

    Cabec1 := "      FILIAL             |   A551   |   A553   |   A501   |   A507   |   A561"
    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    nLin := 8

   @nLin,001 PSAY "V.OLIMPIA"
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY f11A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY f11A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY f11A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f11A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY f11A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY g11A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY g11A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY g11A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY g11A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY g11A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY p11A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY p11A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY p11A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY p11A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY p11A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
  
   @nLin,002 PSAY "TOTAL V.OLIMPIA"
   @nLin,022 PSAY n11A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY n11A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY n11A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY n11A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY n11A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 2 
    
   //--------------------   

   @nLin,001 PSAY "SANTOS"
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY f12A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY f12A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY f12A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f12A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY f12A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY g12A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY g12A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY g12A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY g12A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY g12A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY p12A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY p12A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY p12A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY p12A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY p12A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
  
   @nLin,002 PSAY "TOTAL SANTOS"
   @nLin,022 PSAY n12A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY n12A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY n12A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY n12A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY n12A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   
                     
   //----------------

   @nLin,001 PSAY "RB 45"
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY f13A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY f13A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY f13A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f12A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY f13A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY g13A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY g13A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY g13A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY g12A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY g13A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY p13A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY p13A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY p13A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY p12A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY p13A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
      
   @nLin,002 PSAY "TOTAL RB 45"
   @nLin,022 PSAY n13A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY n13A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY n13A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY n13A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY n13A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   


   //----------------

   @nLin,001 PSAY "SETE LAGOAS"
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY f14A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY f14A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY f14A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f12A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY f14A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY g14A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY g14A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY g14A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY g12A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY g14A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY p14A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY p14A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY p14A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY p12A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY p14A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
      
   @nLin,002 PSAY "TOTAL SETE LAGOAS"
   @nLin,022 PSAY n14A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY n14A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY n14A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY n13A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY n14A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   


   //----------------

   @nLin,001 PSAY "VIROTIA "
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY f15A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY f15A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY f15A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY f12A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY f15A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY g15A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY g15A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY g15A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY g12A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY g15A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       

   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY p15A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY p15A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY p15A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY p12A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY p15A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
      
   @nLin,002 PSAY "TOTAL VITORIA"
   @nLin,022 PSAY n15A551  Picture "@E 9,999,999.99"     
   @nLin,034 PSAY n15A553  Picture "@E 9,999,999.99"     
   @nLin,046 PSAY n15A501  Picture "@E 9,999,999.99"     
   //@nLin,054 PSAY n13A507  Picture "@E 9,999,999.99"     
   @nLin,058 PSAY n15A561  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   



   //-----------------------
   
   // ILI
   //
    Cabec1 := "      FILIAL             |   A482   "
    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    nLin := 8
  
   @nLin,001 PSAY "MATRIZ"         
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY nAtv30101a  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY nAtv30101b  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY nAtv30101c  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,001 PSAY "TOTAL MATRIZ"         
    nLin := nLin + 1                                       
   @nLin,022 PSAY nAtv30101a+nAtv30101b+nAtv30101c  Picture "@E 9,999,999.99"     
    nLin := nLin + 2                                         

   @nLin,001 PSAY "BENEDITINOS"         
    nLin := nLin + 1                                       
   @nLin,001 PSAY "HORS GROUPE"         
   @nLin,022 PSAY nAtv30102a  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,001 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY nAtv30102b  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,001 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY nAtv30102c  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                           
   @nLin,001 PSAY "TOTAL BENEDITINOS"
   @nLin,022 PSAY nAtv30102a+nAtv30102b+nAtv30102c  Picture "@E 9,999,999.99"     
    nLin := nLin + 2        

   @nLin,001 PSAY "PORTO REAL"         
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY nAtv30103a  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY nAtv30103b  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY nAtv30103c  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                           
   @nLin,002 PSAY "TOTAL PORTO REAL"
   @nLin,022 PSAY nAtv30103a+nAtv30103b+nAtv30103c  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   
                   
   @nLin,001 PSAY "BARUERI"         
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY nAtv30104a  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY nAtv30104b  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY nAtv30104c  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "TOTAL BARUERI"
   @nLin,022 PSAY nAtv30104a+nAtv30104b+nAtv30104c  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   
  
   @nLin,001 PSAY "PAVUNA"         
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY nAtv30105a  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY nAtv30105b  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY nAtv30105c  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "TOTAL PAVUNA"
   @nLin,022 PSAY nAtv30105a+nAtv30105b+nAtv30105c  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   

   @nLin,001 PSAY "V.GUILHERME"         
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY nAtv30106a  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY nAtv30106b  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY nAtv30106c  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "TOTAL V.GUILHERME"         
   @nLin,022 PSAY nAtv30106a+nAtv30106b+nAtv30106c  Picture "@E 9,999,999.99"     
    nLin := nLin + 2                                       

   @nLin,001 PSAY "S.J.PINHAIS"         
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY nAtv30107a  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                          
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY nAtv30107b  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY nAtv30107c  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "TOTAL S.J.PINHAIS"
   @nLin,022 PSAY nAtv30107a+nAtv30107b+nAtv30107c  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   
   
   @nLin,001 PSAY "CAMPINAS"
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY nAtv30108a  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY nAtv30108b  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY nAtv30108c  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "TOTAL CAMPINAS"
   @nLin,022 PSAY nAtv30108a+nAtv30108b+nAtv30108c  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   
   
   @nLin,001 PSAY "CONTAGEM"
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY nAtv30109a  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                          
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY nAtv30109b  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY nAtv30109c  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                          
   @nLin,002 PSAY "TOTAL CONTAGEM"
   @nLin,022 PSAY nAtv30109a+nAtv30109b+nAtv30109c    Picture "@E 9,999,999.99"     
    nLin := nLin + 2   
                     
   @nLin,001 PSAY "SEPETIBA"
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY nAtv30110a  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                          
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY nAtv30110b  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY nAtv30110c  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                         
   @nLin,002 PSAY "TOTAL SEPETIBA"
   @nLin,022 PSAY nAtv30110a+nAtv30110b+nAtv30110c  Picture "@E 9,999,999.99"     
    nLin := nLin + 2 
    
    //-----------------------  

    Cabec1 := "      FILIAL             |   A482   "
    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    nLin := 8

   @nLin,001 PSAY "V.OLIMPIA"
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY nAtv30111a  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                          
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY nAtv30111b  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY nAtv30111c  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                         
   @nLin,002 PSAY "TOTAL V.OLIMPIA"
   @nLin,022 PSAY nAtv30111a+nAtv30111b+nAtv30111c  Picture "@E 9,999,999.99"     
    nLin := nLin + 2 
    
   @nLin,001 PSAY "SANTOS"
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY nAtv30112a  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                          
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY nAtv30112b  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY nAtv30112c  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                         
   @nLin,002 PSAY "TOTAL SANTOS"
   @nLin,022 PSAY nAtv30112a+nAtv30112b+nAtv30112c  Picture "@E 9,999,999.99"     
    nLin := nLin + 2                        

   @nLin,001 PSAY "RB 45"
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY nAtv30113a  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                          
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY nAtv30113b  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY nAtv30113c  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                             
   @nLin,002 PSAY "TOTAL RB 45"
   @nLin,022 PSAY nAtv30113a+nAtv30113b+nAtv30113c  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   


   @nLin,001 PSAY "SETE LAGOAS"
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY nAtv30114a  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                          
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY nAtv30114b  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY nAtv30114c  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                             
   @nLin,002 PSAY "TOTAL SETE LAGOAS"
   @nLin,022 PSAY nAtv30114a+nAtv30114b+nAtv30114c  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   


   @nLin,001 PSAY "VITORIA"
    nLin := nLin + 1                                       
   @nLin,002 PSAY "HORS GROUPE"         
   @nLin,022 PSAY nAtv30115a  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                          
   @nLin,002 PSAY "GROUPE GEFCO"         
   @nLin,022 PSAY nAtv30115b  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                       
   @nLin,002 PSAY "PSA CONSOLIDÉ"                   
   @nLin,022 PSAY nAtv30115c  Picture "@E 9,999,999.99"     
    nLin := nLin + 1                                             
   @nLin,002 PSAY "TOTAL VITORIA"
   @nLin,022 PSAY nAtv30115a+nAtv30115b+nAtv30115c  Picture "@E 9,999,999.99"     
    nLin := nLin + 2   

   //----------------------   

DbCloseArea("SMC")

SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()

Return