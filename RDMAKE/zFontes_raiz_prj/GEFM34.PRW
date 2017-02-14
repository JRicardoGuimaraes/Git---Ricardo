#INCLUDE "rwmake.ch"

User Function GEFM34

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Ranking Clientes"
Local cPict          := ""
Local titulo       := "Ranking Clientes"
Local nLin         := 80
Local Cabec1       := "Cliente            Valor"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "GEFM34" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GEFM35" // Coloque aqui o nome do arquivo usado para impressao em disco

cPerg := "GEFM30"
Pergunte(cPerg,.F.)

Private cString := "SE1"

dbSelectArea("SE1")
dbSetOrder(2)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//Processa({|| FGerRel01() },"Processando Titulos , Aguarde... ")
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  18/10/04   º±±
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

Local nOrdem

/*
cNomArq1    := "RANKING.DBF"                 // Arquivo
cNomInd1    := "RANKING"+OrdBagExt()         // Indice

If File(cNomArq1)  
   V_Erase1 := FErase(cNomArq1)         
   If V_Erase1 != 0       
      Msgbox("Problemas ao tentar excluir o arquivo : " + cNomArq1  + "." + chr(13)+;
             "Portanto a operacao nao sera realizada." ,"Aviso")
      Return .t.
   Endif   
Endif

V_StrTemp1 := {}
V_StrTemp1 := {{"TP_CLIENTE"   ,"C",06,0},; 
               {"TP_NMCLIE"    ,"C",60,0},;
               {"TP_TOTREC"    ,"N",17,2},;
               {"TP_LOJA"      ,"C",02,0}} 
                                                                                                          
V_ArqTemp1  := CriaTrab(V_StrTemp1,.T.)           
V_IndTmp11  := Substr(CriaTrab(NIL,.F.),1,7)+"1"   // Retorna o nome do arquivo de indice temporario (1) 
dbUseArea(.T.,,V_ArqTemp1,V_ArqTemp1,.T.,.F.)     
//V_Chave1 := "TP_CLIENTE"  
V_Chave1 := "TP_TOTREC"  

IndRegua(V_ArqTemp1,V_IndTmp11,V_Chave1,,,"Indice temporario") 
DbClearIndex()                                                         
DbSetIndex(V_IndTmp11+OrdBagExt())                            
DbSelectArea(V_ArqTemp1)                      

*/

dbSelectArea("SE1")
dbSetOrder(2)

SetRegua(RecCount())

dbGoTop()

xCliente := SE1->E1_CLIENTE+SE1->E1_LOJA   
xSub := 0

While !EOF()

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif   
   
   IF SE1->E1_VALOR <= 0                                      
      DbSkip()
      Loop
   ENDIF
   
   IF SE1->E1_CLIENTE < MV_PAR01 .OR. SE1->E1_CLIENTE > MV_PAR02
      DbSkip()
      Loop
   ENDIF
      
      
   IF SE1->E1_CLIENTE+SE1->E1_LOJA == xCliente
      @nLin,001 PSAY SE1->E1_CLIENTE+" "+SE1->E1_LOJA
      @nLin,015 PSAY Alltrim(SE1->E1_NOMCLI)
      @nLin,060 PSAY SE1->E1_VALOR      
      
      xSub := xSub + SE1->E1_VALOR
   Else
      // Grava Resumo cliente
      /*
      DbSelectArea(V_ArqTemp1)                      
      RecLock(V_ArqTemp1,.T.)
      V_ArqTemp1->TP_CLIENTE := SE1->E1_CLIENTE   
      V_ArqTemp1->TP_LOJA    := SE1->E1_LOJA
      V_ArqTemp1->TP_NMCLIE  := SE1->E1_NOMCLI    
      V_ArqTemp1->TP_TOTREC  := SE1->E1_VALOR    
      */         
      xSub := 0
      xSub := xSub + SE1->E1_VALOR      
      
   ENDIF
 
   xCliente := SE1->E1_CLIENTE+SE1->E1_LOJA      
   nLin := nLin + 1

   dbSkip()

EndDo



SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()

Return


Static Function FGerRel01()

dbSelectArea("SE1")
dbSetOrder(2)
dbGoTop()

While !EOF()

      RecLock(V_ArqTemp1,.T.)
       
      Replace   (V_ArqTemp1)->TP_CLIENTE      With   V_Cliente    ,;
                (V_ArqTemp1)->TP_NMCLIE       With   V_NmClie     ,;
                (V_ArqTemp1)->TP_NMDISTR      With   V_NmDistr     
      
EndDo

Return 