#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

User Function GEFM04()        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("VDATADE,VDATAATE,VNUMFAT,VVENCTO,VFORNECE,VLOJA")
SetPrvt("VNATUREZ,VNOMEFOR,VVALOR,RECE2,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    : GEFM04  ³ Autor : Ronaldo Pena            ³ Data :31/08/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Juncao de titulos para a geracao de Faturas                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

If Day(dDataBase) > 15
   vDataDe := Ctod("01/"+StrZero(Month(dDataBase),2)+"/"+Str(Year(dDataBase)))
   vDataAte:= Ctod("15/"+StrZero(Month(dDataBase),2)+"/"+Str(Year(dDataBase)))
Else
   vDataDe := Ctod("16/"+StrZero(Month(dDataBase)-1,2)  +"/"+Str(Year(dDataBase)))
   vDataAte:= Ctod("01/"+StrZero(Month(dDataBase),2)+"/"+Str(Year(dDataBase))) -1
Endif

vNumFat := Soma1(GetMv("MV_NUMFAT"),6)
vVencto := vDataAte + 30

@ 000,000 To 200,360 Dialog oGefm03 Title "Gera‡Æo de Fatura"
@ 015,010 Say "Data Inicial"
@ 015,040 Say ":"
@ 015,046 Get  vDataDe

@ 015,100 Say "Data Final"
@ 015,133 Say ":"
@ 015,139 Get  vDataAte

@ 035,010 Say "Vencimento"
@ 035,040 Say ":"
@ 035,046 Get  vVencto

@ 035,100 Say "Fatura Inicial"
@ 035,133 Say ":"
@ 035,139 Get  vNumFat Size 33,10

@ 080,060 BmpButton Type 1 Action bOk()// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> @ 080,060 BmpButton Type 1 Action Execute(bOk)
@ 080,120 BmpButton Type 2 Action Close(oGefm04)
Activate Dialog oGefm03 Centered
Close(oGefm03)

************

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> Function bOk
Static Function bOk()
************
 Processa({|| JuntaFat()},"Processando...")// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==>  Processa({|| Execute(JuntaFat)},"Processando...")
 Close(oGefm04)
Return

*****************
// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> Function JuntaFat
Static Function JuntaFat()
*****************

DbSelectArea("SE2")
ProcRegua(RecCount())
DbSetOrder(6)
DbGoTop()

While !Eof()
       
      If SE2->E2_PREFIXO == "FAT" // .And. SE2->E2_BAIXA <> CTOD("  /  /  ")
           DbSkip()
         Loop
      Endif
      vFORNECE := SE2->E2_FORNECE
      vLoja    := SE2->E2_LOJA
      vNaturez := SE2->E2_NATUREZ
      vNomeFor := SE2->E2_NOMFOR
      vValor   := 0

      While !Eof() .Or. SE2->E2_FORNECE+SE2->E2_LOJA == vFORNECE+vLoja

         IncProc()
         If SE2->E2_EMISSAO >= vDataDe .And. SE2->E2_EMISSAO <= vDataAte .And. SE2->E2_BAIXA == CTOD("  /  /  ")
            RecLock("SE2",.F.)
            SE2->E2_MOVIMEN := dDataBase
            SE2->E2_SALDO   := 0
            SE2->E2_VALLIQ  := SE2->E2_VALOR
            SE2->E2_FATURA  := vNumFat
            SE2->E2_OK      := " "
            SE2->E2_DTFATUR := dDataBase
            SE2->E2_BAIXA   := dDataBase
            MsunLock()
            vValor := vValor + SE2->E2_VALOR
         EndIf
         DbSkip()
      EndDo

      RecE2 := Recno()

      If vValor > 0
         RecLock("SE2",.T.)
         SE2->E2_FILIAL  := xFilial("SE2")
         SE2->E2_NUM     := vNumFat
         SE2->E2_PREFIXO := "FAT"
         SE2->E2_TIPO    := "NF"
         SE2->E2_NATUREZ := vNaturez
         SE2->E2_FORNECE := vFORNECE
         SE2->E2_LOJA    := vLoja
         SE2->E2_NOMFOR  := vNomeFor
         SE2->E2_EMISSAO := dDataBase
         SE2->E2_VENCTO  := vVencto
         SE2->E2_VENCREA := DataValida(vVencto)
         SE2->E2_VALOR   := vValor
         SE2->E2_EMIS1   := dDataBase
         SE2->E2_SALDO   := vValor
         SE2->E2_VENCORI := vVencto
         SE2->E2_MOEDA   := 1
         SE2->E2_FATURA  := "NOTFAT"
         SE2->E2_FATPREF := "FAT"
         SE2->E2_OCORREN := "01"
         SE2->E2_VALLIQ  := 0
         SE2->E2_VLCRUZ  := vValor
         SE2->E2_ORIGEM  := "FINA280"
         MsunLock()
      Endif

      // Incrementa o numero da fatura...
      GetMv("MV_NUMFAT")
      DbSelectArea("SX6")
      RecLock("SX6",.F.)
       SX6->X6_CONTEUD := vNumFat
      MsunLock()
      vNumFat := Soma1(GetMv("MV_NUMFAT"),6)

      DbSelectArea("SE2")
      DbGoTo(RecE2)
End



Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

