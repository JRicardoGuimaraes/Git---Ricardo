#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEFCTB12  º Autor ³ VENDAS GEFCO       º Data ³  05/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Vendas Gefco para o Rel.Gerencial                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gefco                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GEFCTB12

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Relatorio Vendas Gefco"
Local cPict        := ""
Local titulo       := "Relatorio Vendas Gefco -( RMA )"
Local nLin         := 80
Local Cabec1       := "|     RELATORIO DE VENDAS - GEFCO ( RMA )  | REF. " 
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 80 //132
Private tamanho    := "P" //"G"
Private nomeprog   := "GEFCTB12" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GEFCTB12" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "CTS"
Private cPerg      := "GEF040"
//Private cPerg      := "CTR040"

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

// Regra apontada para uso exclusivo do Rma - Saulo Muniz 04/07/05

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

cQuery := ""
V_Se1  := RETSQLNAME("SE1")
V_Sa1  := RETSQLNAME("SA1")
xCat1 := 0
xCat2 := 0
xCat3 := 0
xCat4 := 0
nDesc := 0
nIss  := 0
nIcms := 0
nIpi  := 0
nValor := 0
nSaldo := 0
nRdvm := 0
nRma  := 0
nRmlap := 0
nIli := 0
xCatRma1 := 0
xCatRma2 := 0
xCatRma3 := 0
xCatRma4 := 0
nDifa := 0
nDlpr := 0
nTerc := 0
nDifaRma := 0
nDlprRma := 0
nTercRma := 0
nDifRma   := 0
xUO   := ''

cQuery = "SELECT A.E1_FILIAL ,A.E1_CLIENTE ,A.E1_LOJA ,A.E1_EMISSAO ,A.E1_VALOR ,A.E1_ISS ,A.E1_IPI ,A.E1_VLRICM ,A.E1_DESCONT ,A.E1_CCONT ,B.A1_COD,B.A1_LOJA ,B.A1_GEFCAT1"
cQuery += " FROM "+V_Se1+" AS A,"+V_Sa1+" AS B "
cQuery += " WHERE A.E1_CLIENTE = B.A1_COD AND A.E1_LOJA = B.A1_LOJA AND"
cQuery += " A.E1_EMISSAO >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " A.E1_EMISSAO <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " A.E1_TIPO <> 'FAT' AND "
cQuery += " A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY B.A1_GEFCAT1 "

TcQuery cQuery  ALIAS "SMC" NEW

dbSelectArea("SMC")
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

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif   
   
   xUO := Substr(Alltrim(SMC->E1_CCONT),4,1)

   nDesc := SMC->E1_DESCONT
   nIss  := SMC->E1_ISS
   nIcms := SMC->E1_VLRICM
   nIpi  := SMC->E1_IPI
   nValor := SMC->E1_VALOR                               
   nSaldo := SMC->E1_VALOR - SMC->E1_VLRICM //- SMC->E1_VLRICM - SMC->E1_IPI 

   //Vendas Por U.O.
   If xUO == "6" .Or. xUO == "7" .Or. xUO == "8" .Or. xUO == "9" // RMA
      If Substr(Alltrim(SMC->E1_CCONT),1,1) == "2" // Não Usar Sede
         dbSelectArea("SMC")
         dbSkip()         
         Loop
      Endif            
      
      nRma := nRma + nSaldo

      // Regra apontada para uso exclusivo do Rma - Saulo Muniz 04/07/05
      Do Case 
         Case Substr(Alltrim(SMC->E1_CCONT),7,1) ==  "1" .Or. Substr(Alltrim(SMC->E1_CCONT),7,1) == "2"  // Ventes Groupe PSA           
              xCatRma1 := xCatRma1 + nSaldo     
         Case Substr(Alltrim(SMC->E1_CCONT),7,1) ==  "5"   // Ventes Groupe GEFCO           
              xCatRma2 := xCatRma2 + nSaldo     
         Case Substr(Alltrim(SMC->E1_CCONT),7,1) ==  "0"   // Ventes Hors Groupe PSA Consolidé         
              xCatRma3 := xCatRma3 + nSaldo     
         Otherwise
              xCatRma4 := xCatRma4 + nSaldo     
      EndCase
      

   Endif

   nSaldo := 0 // Zera Saldo
   	
   dbSelectArea("SMC")
   dbSkip() 
   
EndDo


   // Separdos Por UO/Categoria     
   //
   @nLin,001 PSAY "Ventes Hors Groupe PSA     : "
    nLin := nLin + 1   
   @nLin,005 PSAY "RMA   : "
   @nLin,015 PSAY xCatRma1  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 3    

   @nLin,001 PSAY "Ventes Groupe GEFCO    : "
    nLin := nLin + 1   
   @nLin,005 PSAY "RMA   : "
   @nLin,015 PSAY xCatRma2  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 3      

   @nLin,001 PSAY "Ventes Groupe PSA Consolidé : "         
    nLin := nLin + 1       
   @nLin,005 PSAY "RMA   : "
   @nLin,015 PSAY xCatRma3  Picture "@E 999,999,999,999.99"     
    nLin := nLin + 3   

   If xCatRma4 > 0
     @nLin,001 PSAY Replicate("-",80)
      nLin := nLin + 3   
     @nLin,001 PSAY "Sem classificação : "         
     @nLin,035 PSAY xCatRma4 Picture "@E 999,999,999,999.99"                    
     nLin := nLin + 1   
   Endif   

   @nLin,001 PSAY Replicate("-",80)
    nLin := nLin + 5   
   
   @nLin,001 PSAY "TOTAL GERAL : "         
   @nLin,035 PSAY xCatRma1+xCatRma2+xCatRma3+xCatRma4  Picture "@E 999,999,999,999.99"                    
                

   
DbCloseArea("SMC")

SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()

Return