#INCLUDE "RWMAKE.CH"
#include 'fivewin.ch'
#include 'topconn.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    : GEFMC ³ Autor :  Saulo Muniz              ³ Data :20/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Relatorio especifico Rmlap   Margem Comercial              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±  Alteração:                                                             ±±
±±                                                                         ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GEFMC()

lEnd     := .F.
cPerg   := "GEF002"   


If ( ! Pergunte(cPerg,.T.) )
   Return
Else
   RptStatus({ |lend| MontaRel() })
endif   

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  RBOL001 ³ Autor ³ Agamenon Caldas       ³ Data ³ 08/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DOS RECIBOS DE VENDA MERCANTIL                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontaRel()

LOCAL oPrint

xMes := MesExtenso(Substr(Dtoc(MV_PAR01),4,2))

oPrint:= TMSPrinter():New( "Margem Comercial - RMLAP" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página
oPrint:SetpaperSize(9) // <==== AJUSTE PARA PAPEL a4

//If AllTRim(MV_PAR05) == '999'
    /*
	cQry := ""
	cQry := "SELECT DISTINCT Z2_COD "
	cQry += "FROM " + RetSqlName("SZ2") + " "
	cQry += "WHERE Z2_FILIAL = '" + xFilial("SZ2") + "' "
	cQry += "AND Z2_MES = '" + DTOS(MV_PAR01) + "' "
	cQry += "AND D_E_L_E_T_ <> '*' "
	cQry += "ORDER BY Z2_COD "	
	*/

	cQry := ""
	cQry := "SELECT * "
	cQry += "FROM " + RetSqlName("SZ2") + " "
	cQry += "WHERE Z2_FILIAL = '" + xFilial("SZ2") + "' "
	cQry += "AND Z2_MES = '" + DTOS(MV_PAR01) + "' "
	cQry += "AND Z2_COD = '" + MV_PAR05 + "' "
	cQry += "AND D_E_L_E_T_ <> '*' "
	cQry += "ORDER BY Z2_COD "	
	
	TcQuery cQry Alias "TSZ2" NEW
	DbSelectArea("TSZ2")
	DbGoTop()
	While !Eof()        
		ImpHistorique2(oPrint)		
		//ImpHistorique2(TSZ2->Z2_COD)		
		DbSelectArea("TSZ2")
		DbSkip()                      
		//IncRegua()
	End

//Else 
	//ImpHistorique2(MV_PAR05)
	//ImpHistorique2(oPrint)
//EndIf	


//oPrint:EndPage() // Finaliza a página
oPrint:Preview()   // Visualiza antes de imprimir

/*   
IF MV_PAR07 == 1
   oPrint:Preview()   // Visualiza antes de imprimir
ELSE
   oPrint:setup()     // Escolher a impressora
   oPrint:Print()     // Imprime direto na impressora default do APx
ENDIF
*/

oPrint:End()     // Finaliza Objeto
ms_flush()       // desativar impressora

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  IMPRESS ³ Autor ³ Agamenon Caldas       ³ Data ³ 08/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO RECIBO                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDatSacado)
Static Function ImpHistorique2(oPrint)
LOCAL i := 0

LOCAL n := 0

LOCAL cCGC := IIF(SA1->A1_PESSOA == "J",substr(SA1->A1_CGC,1,2) +"."+substr(SA1->A1_CGC,3,3) +"."+ substr(SA1->A1_CGC,6,3) +"/"+ substr(SA1->A1_CGC,9,4) +"-"+substr(SA1->A1_CGC,13,2),substr(SA1->A1_CGC,1,3) +"."+substr(SA1->A1_CGC,4,3) +"."+ substr(SA1->A1_CGC,7,3) +"-"+ substr(SA1->A1_CGC,10,2))

//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)

//Private  oBrush      := TBrush():New(,CLR_LIGHTGRAY),;
Private  oBrush      := TBrush():New(,CLR_BLACK),;
      oPen     := TPen():New(0,5,CLR_BLACK),;
      cFileLogo   := GetSrvProfString('Startpath','') + 'msmdilogo' + '.bmp',;
      oFont5      := TFont():New( "Arial",,5,,.F.,,,,,.F. ),;
      oFont07     := TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.),;
      oFont08     := TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.),;
      oFont08n    := TFont():New('Courier New',08,08,,.T.,,,,.T.,.F.),;
      oFont09     := TFont():New('Tahoma',09,09,,.T.,,,,.T.,.F.),;
      oFont10     := TFont():New('Tahoma',10,10,,.F.,,,,.T.,.F.),;
      oFont10n    := TFont():New('Courier New',10,10,,.T.,,,,.T.,.F.),;
      oFont10a    := TFont():New( "Arial",,10,,.t.,,,,,.f. ),;
      oFont11     := TFont():New('Tahoma',11,11,,.F.,,,,.T.,.F.),;
      oFont11n    := TFont():New('Tahoma',11,11,,.T.,,,,.T.,.F.),;
      oFont12     := TFont():New('Tahoma',12,12,,.T.,,,,.T.,.F.),;
      oFont12n    := TFont():New('Tahoma',12,12,,.F.,,,,.T.,.F.),;
      oFont13     := TFont():New('Tahoma',13,13,,.T.,,,,.T.,.F.),;
      oFont14     := TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.),;
      oFont15     := TFont():New('Courier New',15,15,,.T.,,,,.T.,.F.),;
      oFont18     := TFont():New('Arial',18,18,,.T.,,,,.T.,.T.),;
      oFont16     := TFont():New('Arial',16,16,,.T.,,,,.T.,.F.),;
      oFont20     := TFont():New('Arial',20,20,,.F.,,,,.T.,.F.),;
      oFont22     := TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)

nLinha      := 3000       // Controla a linha por extenso
lPrintDesTab:= .f.        // Imprime a Descricao da tabela (a cada nova pagina)
Private  _nQtdReg := 0    // Numero de registros para intruir a regua
Private _cNomecomp := ""

_nomeuser := substr(cUsuario,7,15)
PswOrder(2)
If PswSeek(_nomeuser,.T.)
   aRetUser := PswRet(1)
   _cNomecomp := aRetUser[1,04]
Endif

nLinha      := 50   // Controla a linha por extenso

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime o cabecalho da empresa. !³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   oPrint:Box(nLinha,100,nLinha+220,1200)
   oPrint:Box(nLinha,1210,nLinha+220,1900)
   oPrint:Box(nLinha,1910,nLinha+220,2300)
   oPrint:SayBitmap(nLinha+5,110,cFileLogo,530,130)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Titulo do Relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   oPrint:Say(nLinha+70,1400,OemToAnsi('Margem Comercial'),oFont12)
   oPrint:Say(nLinha+10,1960,OemToAnsi('Mês :'),oFont12)
   oPrint:Say(nLinha+10,2100,STRZERO(Month(dDatabase),2),oFont12)
   //oPrint:Say(nLinha+125,2000,STRZERO(Month(dDatabase),4),oFont12)

//ÚÄÄÄÄÄÄÄÄÄÄ¿
//³Cliente   ³
//ÀÄÄÄÄÄÄÄÄÄÄÙ
                              
   //AllTrim(Transform(,"@E 99,999.99"))
   
   //DbSelectArea("TSZ2")

   nLinha += 220 // 270
   oPrint:Box(nLinha+45,100,nLinha+215,2300)
   oPrint:Say(nLinha+60,0120,OemToAnsi('Descrição  :'),oFont12)
   oPrint:Say(nLinha+60,0500,Alltrim(TSZ2->Z2_DESCR),oFont13)
   oPrint:Say(nLinha+110,0120,OemToAnsi('Porto RJ'),oFont12)
   oPrint:Say(nLinha+110,0500,AllTrim(Transform(TSZ2->Z2_PORTORJ,"@E 999,999,999.99")),oFont11)
   oPrint:Say(nLinha+160,0120,OemToAnsi('Porto Real'),oFont12)
   oPrint:Say(nLinha+160,0500,AllTrim(Transform(TSZ2->Z2_PORTORJ,"@E 999,999,999.99")),oFont11)
   oPrint:Say(nLinha+160,1200,OemToAnsi('Barueri'),oFont12)
   oPrint:Say(nLinha+160,1370,AllTrim(Transform(TSZ2->Z2_PORTORJ,"@E 999,999,999.99")),oFont11)
   oPrint:Say(nLinha+160,1700,OemToAnsi('Caxias'),oFont12)
   oPrint:Say(nLinha+160,1870,AllTrim(Transform(TSZ2->Z2_PORTORJ,"@E 999,999,999.99")),oFont11)
   nLinha += 250
   
   
   /*
   @nLin,001 PSAY Alltrim(SZ2->Z2_DESCR)
   @nLin,024 PSAY nVlForaSede     Picture "@E 99,999,999.99"                     
   @nLin,038 PSAY SZ2->Z2_SEDEADM Picture "@E 99,999,999.99"                     
   //@nLin,046 PSAY SZ2->Z2_SEDEOPE Picture "@E 9,999,999.99"                     
   @nLin,052 PSAY SZ2->Z2_PORTORJ Picture "@E 99,999,999.99"     //58                    
   @nLin,065 PSAY SZ2->Z2_RIO     Picture "@E 9,999,999.99"                         
   @nLin,080 PSAY SZ2->Z2_PREAL   Picture "@E 99,999,999.99"                         
   @nLin,095 PSAY SZ2->Z2_BARUERI Picture "@E 9,999,999.99"                             
   @nLin,109 PSAY SZ2->Z2_CAXIAS  Picture "@E 9,999,999.99"                     
   @nLin,124 PSAY SZ2->Z2_VILAGUI Picture "@E 9,999,999.99"                     
   @nLin,139 PSAY SZ2->Z2_SJP     Picture "@E 9,999,999.99"                     
   @nLin,154 PSAY SZ2->Z2_CAMPINA Picture "@E 9,999,999.99"                         
   @nLin,167 PSAY SZ2->Z2_SEPETIB Picture "@E 9,999,999.99"                         
   @nLin,181 PSAY SZ2->Z2_STAMARO Picture "@E 9,999,999.99"                         
   @nLin,195 PSAY SZ2->Z2_SANTOS  Picture "@E 9,999,999.99"                             
   @nLin,210 PSAY SZ2->Z2_CONTAGE Picture "@E 9,999,999.99"                  
   */

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³RECIBO        ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   oPrint:Say(nLinha+60,1500,"V A L O R",oFont18)

   oPrint:Box(nLinha+50,1900,nLinha+170,2300)
   oPrint:FillRect({nLinha+50,1900,nLinha+170,2300},oBrush)
   //oPrint:Say(nLinha+100,2000,"R$ "+TRANSFORM(aDadosTit[5],"@E 999,999.99"),oFont12)
   nLinha += 170
   nLinha += 45
   //oPrint:Say(nLinha,0100,OemToAnsi("Recebi de   "+aDatSacado[1] + '  ('+aDatSacado[2]+')'),oFont12)
   nLinha += 45
   //oPrint:Say(nLinha,0100,OemToAnsi("Referente a fatura número "+aDadosTit[1]+", a importância supra de R$ "+TRANSFORM(aDadosTit[5],"@E 999,999,999.99")),oFont12)

   oPrint:Box(nLinha+45,100,nLinha+130,2300)
   oPrint:FillRect({nLinha+45,100,nLinha+130,2300},oBrush)
   nLinha += 45
   //oPrint:Say(nLinha,0100,OemToAnsi(ALLTRIM(SUBS(EXTENSO(aDadosTit[5]),1,083))+REPLICATE('*',083-LEN(ALLTRIM(SUBS(EXTENSO(aDadosTit[5]),1,083))))),oFont12)
   nLinha += 45
   //oPrint:Say(nLinha,0100,OemToAnsi(ALLTRIM(SUBS(EXTENSO(aDadosTit[5]),084,083))+REPLICATE('*',081-LEN(ALLTRIM(SUBS(EXTENSO(aDadosTit[5]),084,083))))),oFont12)
   nLinha += 45
   oPrint:Say(nLinha,0100,OemToAnsi("Pelo que passo o presente recibo dando plena e geral quitação."),oFont12)
   nLinha += 45
   //oPrint:Say(nLinha,1450,OemToAnsi("Vencimento: "+TRANSFORM(dVencto,"@D")),oFont12)
   nLinha += 45
   oPrint:Say(nLinha,0100,OemToAnsi(Capital(AllTrim(SM0->M0_CIDENT))+", "+Str(Day(dDatabase),2)+" de "+Strzero(Month(dDatabase),2)+" de "+ Str(Year(dDatabase),4)+"."),oFont12)
   //oPrint:Say(nLinha,1450,OemToAnsi("Vendedor    : "+" EU ... " + "  "+LEFT(cNomVen,15)),oFont12)
   nLinha += 45

   nLinha += 45
   nLinha += 90
   nLinha += 90
   nLinha += 90

   oPrint:Say(nLinha,0100,OemToAnsi('ASS. Cliente:'),oFont12)
   oPrint:Say(nLinha,0400,'__________________________________',oFont12n)
   oPrint:Say(nLinha,1200,OemToAnsi('ASS. Responsável:'),oFont12)
   oPrint:Say(nLinha,1600,'_______________________________',oFont12n)
   nLinha += 45
   //oPrint:Say(nLinha,1600,AllTrim(aDadosEmp[1]),oFont08n)
   nLinha += 140


   oPrint:Line(nLinha,0100,nLinha,2300)
   nLinha += 15
   oPrint:Say(nLinha,120,AllTrim(SM0->M0_ENDENT)+" - "+Capital(AllTrim(SM0->M0_CIDENT))+'/'+AllTrim(SM0->M0_ESTENT)+ ' CEP.: ' + AllTrim(TransForm(SM0->M0_CEPENT,'@R 99.999-999')) + '  -  FONE: ' + AllTrim(SM0->M0_TEL),oFont11)

   oPrint:Say(nLinha,2050,"VIA CLIENTE",oFont11n)
   nLinha += 60
   oPrint:Say(nLinha,070,Repli('-',2000),oFont10a,100)
   oPrint:Say(nLinha+30,080,"CORTE AQUI",oFont5,100)  
   nLinha += 60
   nLinha += 60

oPrint:EndPage() // Finaliza a página

Return Nil