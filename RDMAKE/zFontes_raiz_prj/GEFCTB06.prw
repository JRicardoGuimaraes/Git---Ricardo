#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEFCTB06  º Autor ³ VENDAS GEFCO       º Data ³  19/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Audit Report Gefco France                                  º±±
±±º          ³ VENDAS                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gefco                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GEFCTB06

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Auditoria Gefco França"
Local cPict        := ""
Local titulo       := "Auditoria Gefco França"
Local nLin         := 80
Local Cabec1       := "|  Num  | Serie | Emissão | Dt Contab. |     Valor     |  Cliente/Loja  |        Nome        |  Conta  | C.Custo |" 
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "G"
Private nomeprog   := "GEFCTB06" 
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GEFCTB06" 
Private cString    := "SE1"
Private cPerg      := "GEF003"

// Gera Dbf
cNomArq1    := "VENDAS.DBF"                 // Arquivo
cNomInd1    := "VENDAS"+OrdBagExt()         // Indice

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

AADD(aCampos, {"Blanc"     , "C",  6, 0})
AADD(aCampos, {"PERIODE"   , "N",  3, 0})
AADD(aCampos, {"STE"       , "C",  3, 0})
AADD(aCampos, {"GEFCOTYPE" , "C",  6, 0})
AADD(aCampos, {"N_PCREFER" , "C",  6, 0})
AADD(aCampos, {"CLIENT"    , "C",  6, 0})
AADD(aCampos, {"Nat_Compt" , "C", 10, 0})
AADD(aCampos, {"DVETR"     , "C",  5, 0})
AADD(aCampos, {"CtrPr"     , "C", 30, 0})
AADD(aCampos, {"Ordre"     , "C", 15, 0})
AADD(aCampos, {"Act"       , "C", 10, 0})
AADD(aCampos, {"CREELE"    , "C",  8, 0})
AADD(aCampos, {"Blanc_2"   , "C",  6, 0})
AADD(aCampos, {"CA_brut"   , "N", 17, 2})
AADD(aCampos, {"Crs_change", "N",  8, 4})
AADD(aCampos, {"Lib_Tiers" , "C", 35, 0})

cNomArq := CriaTrab (aCampos, .T.)
dbUseArea (.T., , cNomArq, "GFC", .T. , .F.)
_cArqInd := Criatrab("",.F.)
IndRegua("GFC",_cArqInd,"CREELE",,,"Selecionando Registros.")
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
V_Se1  := RETSQLNAME("SE1")
V_Sa1  := RETSQLNAME("SA1")
V_Sed  := RETSQLNAME("SED")
xTotal := 0
nValor := 0

xNomeFil := ""
_xFilCtb  := ""
xFilRet  := ""
xDesc    := ""
xUO      := ""
xPeugeot := "PEUGEOT CITROEN DO BRASIL AUT. LTDA"
lPeugeot := .T.

cQuery = "SELECT A.E1_FILIAL ,A.E1_NUM ,A.E1_PREFIXO ,A.E1_CCONT ,A.E1_CLIENTE ,A.E1_LOJA ,A.E1_EMISSAO ,A.E1_VALOR ,B.A1_COD ,B.A1_LOJA ,B.A1_CONTA ,B.A1_NOME,A.E1_BAIXA ,A.E1_NATUREZ ,C.ED_CONTA ,C.ED_CODIGO,A.E1_VLRICM,A.E1_ISS"
cQuery += " FROM "+V_Se1+" AS A,"+V_Sa1+" AS B ,"+V_Sed+" AS C"
cQuery += " WHERE A.E1_CLIENTE = B.A1_COD AND A.E1_LOJA = B.A1_LOJA AND"
cQuery += " A.E1_EMISSAO >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " A.E1_EMISSAO <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " A.E1_NATUREZ = C.ED_CODIGO AND B.A1_GEFCAT1 = '3' AND"
cQuery += " A.E1_TIPO <> 'FAT' AND "
//cQuery += " A.E1_TIPO <> 'FAT' AND SUBSTRING(A.E1_CCONT,4,1) = '5' AND"
cQuery += " A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY A.E1_EMISSAO+A.E1_NUM "      

TcQuery cQuery  ALIAS "GFR" NEW

dbSelectArea("GFR")
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

   If SUBSTR(UPPER(Alltrim(GFR->A1_NOME)),1,7) == "PEUGEOT"
      lPeugeot := .T.
   Endif

   @nLin,001 PSAY GFR->E1_NUM  
   @nLin,011 PSAY Month(dDatabase)
   @nLin,020 PSAY GFR->E1_EMISSAO
   @nLin,030 PSAY "841"
   @nLin,050 PSAY GFR->E1_CLIENTE + " / " + GFR->E1_LOJA
   @nLin,062 PSAY IIF(lPeugeot,xPeugeot,ALLTRIM(GFR->A1_NOME))
   @nLin,097 PSAY ALLTRIM(GFR->A1_CONTA)
   @nLin,106 PSAY ALLTRIM(GFR->ED_CONTA)
   @nLin,115 PSAY ALLTRIM(GFR->E1_FILIAL)
   
    xTotal := xTotal + GFR->E1_VALOR
    nLin := nLin + 1 

    // Filial Gefco
       _xFilCtb := Substr(GFR->E1_CCONT,4,3)	
       GFILIAL(_xFilCtb)

    // Unidade Oper.
       UO(GFR->E1_CCONT)
    
    // Valor Sem impostos    
    nValor := (GFR->E1_VALOR - (GFR->E1_VLRICM + GFR->E1_ISS))
 
    // Gera Dbf 
    DbSelectArea("GFC")
    RecLock ("GFC",.T.)
	Replace Blanc        with Space(6)
	Replace PERIODE      with Month(dDatabase)
	Replace STE          with "841"
	Replace GEFCOTYPE    with Space(6)
	Replace N_PCREFER    with GFR->E1_NUM
	Replace CLIENT       with GFR->E1_CLIENTE 
	Replace Nat_Compt    with ALLTRIM(GFR->ED_CONTA)
	Replace DVETR        with "BRL"
	Replace CtrPr        with xNomeFil //ALLTRIM(GFR->E1_FILIAL)
	Replace Ordre        with xDesc //Substr(ALLTRIM(GFR->E1_CCONT),2,2)
	Replace Act          with ALLTRIM(GFR->E1_CCONT)
	Replace CREELE       with GFR->E1_EMISSAO
	Replace Blanc_2      with Space(6)
	Replace CA_brut      with nValor //with GFR->E1_VALOR
	Replace Crs_change   with MV_PAR03
	Replace Lib_Tiers    with IIF(lPeugeot,xPeugeot,ALLTRIM(GFR->A1_NOME))
    Msunlock()	
             
   dbSelectArea("GFR")
   dbSkip() 
   
EndDo

    nLin := nLin + 1 
   @nLin,001 PSAY Replicate("-",80)
    nLin := nLin + 2 
   @nLin,001 PSAY "TOTAL GERAL : "         
   @nLin,035 PSAY xTotal Picture "@E 999,999,999,999.99"                    

DbCloseArea("GFR")
DbCloseArea("GFC")


SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_Flush()

dbCloseArea("GFC")
DbCloseArea(cNomArq) 

OpenMSExcel()

Return


Static Function GFILIAL()

   Do Case
      Case _xFilCtb == "001"
           xFilRet := "01"
      Case _xFilCtb == "002"
           xFilRet := "02"
      Case _xFilCtb == "004"
           xFilRet :="03"
      Case _xFilCtb == "005"
           xFilRet :="04"
      Case _xFilCtb == "006"
           xFilRet :="05"
      Case _xFilCtb == "007"
           xFilRet :="06"
      Case _xFilCtb == "008"
           xFilRet :="07"
      Case _xFilCtb == "009"
           xFilRet :="09"
      Case _xFilCtb == "010"
           xFilRet :="08"
      Case _xFilCtb == "011"
           xFilRet :="10"
      Case _xFilCtb == "012"
           xFilRet :="11"
      Case _xFilCtb == "013"
           xFilRet :="12"
      Case _xFilCtb == "014"
           xFilRet :="13"
      Case _xFilCtb == "015"  // Sem uso Vitória
           xFilRet :="15"
      Case _xFilCtb == "016"  // Sete Lagoas
           xFilRet :="14"
      OtherWise	                       
           xFilRet :="??"        
        Return
   EndCase


   DbSelectArea("SM0")
   If !DbSeek("01"+xFilRet)
      xNomeFil := "Filial não encontrada !"
   Else
      xNomeFil := SM0->M0_NOME
   Endif

Return(xNomeFil)

Static Function UO()

   xUO := Substr(ALLTRIM(GFR->E1_CCONT),2,2)
   
   Do Case
      Case xUO == "01"
           xDesc := "RDVM"
      Case xUO == "02"
           xDesc := "PVNO"     
      Case xUO == "11"
           xDesc := "RMLAP"     
      Case xUO == "21"
           xDesc := "ILI"     
      Case xUO == "22"
           xDesc := "RMA"
      Case xUO == "23"
           xDesc := "ADUANA"         
      OtherWise	                 
        xDesc := "U.O. não encontrada !"    
        Return
   EndCase

Return(xDesc)


Static Function OpenMSExcel()   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,001 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Integrar com Microsoft Excel")
@ 002,010 TO 080,190
@ 10,018 Say " Este programa ira exportar os dados do Microsiga Protheus 8,"
@ 18,018 Say " conforme os parametros definidos pelo usuario. "
@ 60,098 BMPBUTTON TYPE 01 ACTION Processa({|| ExecExcel() },"Aguarde...")
@ 60,128 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return


Static Function ExecExcel()   

Close(oLeTxt)


cPathori := "S:\Protheus_Data\Importar\Demande\"
cTipo    := "*.DBF"
aFiles   := "Demande.dbf"

cPath   := cPathOri
cArqTRC := cPathori+aFiles

If !File(cPathori+aFiles)
   __CopyFile(cNomArq + ".DBF", cPathori + aFiles)
   Ferase(cNomArq + ".DBF")
Endif

If !ApOleClient("MsExcel")
   MsgStop("MsExcel nao instalado.")
   Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cPathori + aFiles)
oExcelApp:SetVisible(.T.)

Return()