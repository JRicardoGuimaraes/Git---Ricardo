#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEFCTB07  º Autor ³ COMPRAS GEFCO      º Data ³  19/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Audit Report Gefco France                                  º±±
±±º          ³ COMPRAS                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gefco                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GEFCTB07

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Auditoria Gefco França"
Local cPict        := ""
Local titulo       := "Audit Report Gefco France"
Local nLin         := 80
Local Cabec1       := "|  Num  | Serie | Emissão | Dt Contab. |     Valor     |  Cliente/Loja  |        Nome        |  Conta  | C.Custo |" 
                     //123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                     //         10        20        30        40        50        60        70        80        90        100       110       120
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "G"
Private nomeprog   := "GEFCTB07" 
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GEFCTB07" 
Private cString    := "CTS"
Private cPerg      := "GEF003"
//Private cPerg      := "CTR040"

// Gera Dbf
cNomArq1    := "COMPRAS.DBF"                 // Arquivo
cNomInd1    := "COMPRAS"+OrdBagExt()         // Indice

If File(cNomArq1)  
   V_Erase1 := FErase(cNomArq1)        
   If V_Erase1 != 0      
      Msgbox("Problemas ao tentar excluir o arquivo : " + cNomArq1  + "." + chr(13)+;
             "Portanto a operacao nao sera realizada." ,"Aviso")
      Return .t.
   Endif   
Endif

//Preparando os Arquivos
//************************
aCampos  := { }
AADD(aCampos, {"E2_NUM"    , "C",  6, 0})
AADD(aCampos, {"E2_PREFIXO", "C",  3, 0})
AADD(aCampos, {"E2_EMISSAO", "C",  8, 0})
AADD(aCampos, {"E2_VALOR"  , "N", 17, 2})
AADD(aCampos, {"E2_FORNECE", "C",  6, 0})
AADD(aCampos, {"E2_LOJA"   , "C",  2, 0})
AADD(aCampos, {"E2_CCONTA" , "C",  9, 0})
AADD(aCampos, {"E2_FILIAL" , "C",  2, 0})
AADD(aCampos, {"E2_BAIXA"  , "C",  8, 0})
AADD(aCampos, {"A2_NOME"   , "C", 35, 0})
AADD(aCampos, {"ED_CONTA"  , "C",  9, 0})

cNomArq := CriaTrab (aCampos, .T.)
dbUseArea (.T., , cNomArq, "MSC", .T. , .F.)
_cArqInd := Criatrab("",.F.)
IndRegua("MSC",_cArqInd,"E2_EMISSAO",,,"Selecionando Registros.")
dbGoTop ()


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

cQuery := ""
V_Se2  := RETSQLNAME("SE2")
V_Sa2  := RETSQLNAME("SA2")
V_Sed  := RETSQLNAME("SED")
xTotal := 0

cQuery = "SELECT A.E2_FILIAL ,A.E2_NUM ,A.E2_PREFIXO ,A.E2_CCONT ,A.E2_NATUREZ ,A.E2_FORNECE ,A.E2_LOJA ,A.E2_EMISSAO ,A.E2_BAIXA ,A.E2_VALOR ,B.A2_COD,B.A2_LOJA ,B.A2_CONTA,B.A2_NOME,C.ED_CONTA , C.ED_CODIGO "
cQuery += " FROM "+V_Se2+" AS A,"+V_Sa2+" AS B, "+V_Sed+" AS C"
cQuery += " WHERE A.E2_FORNECE = B.A2_COD AND A.E2_LOJA = B.A2_LOJA AND"
cQuery += " A.E2_EMISSAO >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " A.E2_EMISSAO <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " A.E2_NATUREZ = C.ED_CODIGO AND"
cQuery += " A.E2_TIPO <> 'FAT' AND SUBSTRING(A.E2_CCONT,4,1) = '5' AND"
cQuery += " A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY A.E2_EMISSAO+E2_NUM "

MEMOWRIT("GEFCTB07.SQL",cQuery)

TcQuery cQuery  ALIAS "GFP" NEW

dbSelectArea("GFP")
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

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif   
     
   @nLin,001 PSAY GFP->E2_NUM + " " + GFP->E2_PREFIXO
   @nLin,011 PSAY GFP->E2_EMISSAO
   @nLin,020 PSAY GFP->E2_EMISSAO
   @nLin,030 PSAY GFP->E2_VALOR
   @nLin,050 PSAY GFP->E2_FORNECE + " / " + GFP->E2_LOJA
   @nLin,062 PSAY ALLTRIM(GFP->A2_NOME)
   @nLin,097 PSAY ALLTRIM(GFP->ED_CONTA)
   @nLin,106 PSAY ALLTRIM(GFP->E2_CCONT)
   @nLin,115 PSAY ALLTRIM(GFP->E2_FILIAL)
   
    xTotal := xTotal + GFP->E2_VALOR
    nLin := nLin + 1 
   
    // Gera Dbf
    DbSelectArea("MSC")
    RecLock ("MSC",.T.)
    Replace E2_NUM       with GFP->E2_NUM
    Replace E2_PREFIXO   with GFP->E2_PREFIXO
    Replace E2_EMISSAO   with GFP->E2_EMISSAO
    Replace E2_VALOR     with GFP->E2_VALOR
    Replace E2_FORNECE   with GFP->E2_FORNECE 
    Replace E2_LOJA      with GFP->E2_LOJA
    Replace E2_CCONTA    with ALLTRIM(GFP->E2_CCONT)
    Replace E2_FILIAL    with ALLTRIM(GFP->E2_FILIAL)
    Replace E2_BAIXA     with ALLTRIM(GFP->E2_BAIXA)
    Replace A2_NOME      with ALLTRIM(GFP->A2_NOME)
    Replace ED_CONTA     with ALLTRIM(GFP->ED_CONTA)        
    Msunlock()
             
   dbSelectArea("GFP")
   dbSkip() 

Enddo 

    nLin := nLin + 1 
   @nLin,001 PSAY Replicate("-",80)
    nLin := nLin + 2 
   @nLin,001 PSAY "TOTAL GERAL : "         
   @nLin,035 PSAY xTotal Picture "@E 999,999,999,999.99"                    


DbCloseArea("GFP")
DbCloseArea("MSC")

SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()

DbCloseArea(cNomArq) 
FRename(cNomArq+".DBF", cNomArq1)   
FRename(_cArqInd+OrdBagExt(), cNomInd1)  

Ferase(cNomArq+".DBF")                                      
Ferase(_cArqInd+OrdBagExt())

Return