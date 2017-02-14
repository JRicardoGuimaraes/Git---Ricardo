#include "rwmake.ch"  

User Function GEFM04B() 

SetPrvt("VNUMFATURA,OLDAREA,OLDORDER,OLDOREC,RECE1,_cQry,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    : GEFM04B ³ Autor : Saulo Muniz             ³ Data :28/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Exclusao da Juncao de titulos para a geracao de Faturas    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±  Alteração:                                                             ±±
±±                                                                         ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

vNumFatura := "000000"

@ 000,000 To 200,360 Dialog oGefm03a Title "Separacao da Fatura"
@ 015,010 Say "Numero da Fatura"
@ 015,060 Say ":"
@ 015,066 Get  vNumFatura Size 33,10
@ 030,010 Say "Fatura Anterior"
@ 030,066 Say  GETMV("MV_NUMFAT")

@ 080,060 BmpButton Type 1 Action bOk()// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> @ 080,060 BmpButton Type 1 Action Execute(bOk)
@ 080,120 BmpButton Type 2 Action Close(oGefm03a)
Activate Dialog oGefm03a Centered

Return(nil)     

Static Function bOk()

 OldArea  := Alias()
 OldOrder := IndexOrd()
 OldORec  := Recno()

 Processa({|| SeparaFat()},"Processando...")

 DbSelectArea(OldArea)
 DbSetOrder(OldOrder)
 DbGoTo(OldORec)
 Close(oGefm03a)

Return


Static Function SeparaFat()


DbSelectArea("SE1")
ProcRegua(RecCount())
DbSetOrder(1)
DbGoTop()

RecE1 := Recno()

If DbSeek(xFilial("SE1")+"FAT"+vNumFatura)
   RecLock("SE1",.F.)
   DbDelete()
   MsunLock()
Else
   MsgStop("Fatura não encontrada !  "+vNumFatura)
Endif


_cQry := " UPDATE " + RetSqlName("SE1")
_cQry += " SET E1_FATURA = ' ',E1_SALDO = E1_VALOR, E1_BAIXA = ' ',E1_VALLIQ = 0,E1_OK = '',E1_STATUS = 'A',E1_DTFATUR = '',E1_FATPREF = '',E1_FLAGFAT = 'S',E1_TIPOFAT = 'S' "
_cQry += " WHERE E1_FATURA = " + "'" + vNumFatura + "'" + " AND E1_FATPREF = 'FAT' "

MEMOWRIT("GEFM04B.SQL",_cQry)

//cQuery += " WHERE A.E1_CLIENTE = B.A1_COD AND A.E1_LOJA = B.A1_LOJA AND"
//_cQry +=      SET D_E_L_E_T_ = '*' "
//UPDATE SE1010 SET E1_FATURA = ' ',E1_SALDO = E1_VALOR, E1_BAIXA = ' ',E1_VALLIQ = 0,E1_OK = '',E1_STATUS = 'A',E1_DTFATUR = ''

If TCSQLEXEC(_cQry) > 0
   Alert("Erro: Não foi possível Cancelar os registros da Fatura !")
EndIf


/*

DbSelectArea("SE1")
DbSetOrder(19)
DbGoTop()
While DbSeek(xFilial("SE1")+vNumFatura) 


//While !Eof()
// If (SE1->E1_FATURA == vNumFatura)                                                   

      //Reverter a baixa...
      //Alert ("REVERTER A BAIXA: "+SE1->E1_FATURA + " - CTR/CTV/UNI "+SE1->E1_NUM)
      RecLock("SE1",.F.)
        SE1->E1_BAIXA   := ctod("  /  /    ")           // dDataBase
        SE1->E1_MOVIMEN := ctod("  /  /    ")       // dDataBase
        SE1->E1_SALDO   := SE1->E1_VALOR    // 0
        SE1->E1_VALLIQ  := 0                             // SE1->E1_valor
        SE1->E1_FATURA  := ""                          // vNumFat
        SE1->E1_OK      := ""                              // "x"
        SE1->E1_DTFATUR := ctod("  /  /    ")       // dDataBase
        SE1->E1_STATUS  := "A"                        //  "B"
      MsunLock()
//  EndIf
//  DbSkip()
  	
  IncProc()
EndDo
*/

DbSelectArea("SE1")
DbGoTo(RecE1)


Return