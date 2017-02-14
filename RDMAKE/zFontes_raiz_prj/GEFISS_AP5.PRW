#include "rwmake.ch"        
User Function GEFISS()       
  
SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,_PAG,NTAMNF,CSTRING,ADRIVER")
SetPrvt("_XFILIAL,MSOMA,MIMPOSTO,MTOT_FLAG,NOPC,CCOR")
SetPrvt("ASX1,X1,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GEFM01   ³ Autor ³   Marcelo D`Acri      ³ Data ³ 08/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Apuracao de Iss (Modulo Fiscal)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Gefco do Brasil S/A.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Manutenc. ³ Alteracao para uso em base sql e campo data de 6 casas p/  ³±±
±±³          ³ 8 casas type data (Saulo Muniz)                            ³±±
±±³          ³ Adaptacao para lay-out Windows (impressao) 13/03/200       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // A partir da data                     ³
//³ mv_par02             // Ate a data                           ³
//³ mv_par03             // Pagina inicial                       ³
//³ mv_par04             // Numero do livro                      ³
//³ mv_par05             // Imprime: (s¢ livro,livro e termos,te)³
//³ mv_par06             // Livro selecionado                    ³
//³ mv_par07             // N§ do CCM                            ³
//³ mv_par08             // Totaliza por dia(sim/nao)            ³
//³ mv_par09             // Valor das deducoes                   ³
//³ mv_par10             // Obs. a ser impresso na primeira linha³
//³ mv_par11             // Obs. a ser impresso na segunda linha ³
//³ mv_par12             // Obs. a ser impresso na terceira linha³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="P"
limite    := 220
titulo    := PADC("Apuracao de I.S.S.",74)
cDesc1    := PADC("Este programa ira emitir a Apuracao de I.S.S.",74)
cDesc2    := PADC("Exclusivo GEFCO",74)
cDesc3    := "  "
cNatureza := ""
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "GEFISS"
cPerg     := "GEFM01"
nLastKey  := 0
lContinua := .T.
nLin      := 0
wnrel     := "GEFISS"
_PAG      := 0
nTamNf:=72     // Apenas Informativo 
cString:="SF3"
xTotaliza := 1 // 1 = Sim ; 2= Não
xfile := 0
xcont := 0
dDtIni := MV_PAR01
dDtFim := MV_PAR02

Pergunte(cPerg,.F.)               // Pergunta no SX1
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³          
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

//VerImp()       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³ Inicio do Processamento da Apuracao                          ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> 	RptStatus({|| Execute(RptDetail)})
	Return
Static Function RptDetail()
#ENDIF

aDriver	:=	ReadDRIVER()

If aReturn[4] == 1
    @ 0,0 PSAY &(aDriver[3])
Else
    @ 0,0 PSAY &(aDriver[4])
Endif

_xFilial := xFilial()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  regua de impressao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nlin      := 0
MSOMA     := 0
nVal      := 0
MIMPOSTO  := 0
MTOT_FLAG := 1
_PAG      := VAL(MV_PAR03)
lCabec	  := .T.


dbSelectArea("SF3")
// Ordem 1
// Filial + Entrada + Nota + Serie + Cli/For + Loja + CFO + Str(Aliqicm,5,2)
SetRegua(LastRec())

dbSelectArea("SF3")
dbSetOrder(1)
dbGotop()
DbSeek(xFilial()+DTOS(MV_PAR01),.T.)                                                   
xDataC := SF3->F3_EMISSAO
cabec()

While !EOF() .And. xFilial() == F3_FILIAL .AND. F3_ENTRADA >= MV_PAR01 .AND. F3_ENTRADA <= MV_PAR02      //.And. SF3->F3_ENTRADA >= mv_par01 .And. SF3->F3_ENTRADA <= mv_par02    // Adicionado novo filtro                     
  
	IncRegua()

	If Interrupcao(@lAbortPrint)
		Exit
	Endif

    IF nlin >= 55
       _PAG:=_PAG+1
       cabec()
       nlin   := 13
    Endif

    IF lAbortPrint
        @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
        lContinua := .F.
        Exit
    Endif

//    IF SF3->F3_TIPO == "S" //.and. Substr(SF3->F3_CFO,1,1) >= "5"
    IF EMPTY(SF3->F3_CODISS)   //.and. Substr(SF3->F3_CFO,1,1) >= "5"
       Dbskip()           
       Loop
    ENDIF
 
    IF Substr(SF3->F3_CFO,1,1) < "5"
       Dbskip()           
       Loop
    ENDIF
   

    xDataC := SF3->F3_EMISSAO
    xfile := 0                     
    nVal := 0                        
            
    While SF3->F3_EMISSAO == xDataC          
          
          IF EMPTY(SF3->F3_CODISS)   
             Dbskip()           
             Loop
          ENDIF          
          
             nVal := NOROUND(nVal + F3_VALCONT) 
             //nVal := nVal + F3_VALCONT                         //Retirado o arredondamento
           @ nlin, 000 PSAY Substr(DTOC(F3_EMISSAO),1,2)
           @ nlin, 006 PSAY F3_ESPECIE
           @ nlin, 013 PSAY F3_SERIE
           @ nlin, 019 PSAY F3_NFISCAL
           @ nlin, 026 PSAY F3_VALCONT PICTURE "@E 999,999.99"
           @ nlin, 045 PSAY F3_CODISS
           @ nlin, 055 PSAY F3_ALIQICM                         //"5,00 %"  // Removido Aliq. Fixada no prg
           @ nlin, 124 PSAY Alltrim(F3_OBSERV)
             nlin := nlin + 1       
           
           // Adicionado novo controle conforme solicitado - 03/06/04
           // Saulo Muniz - Inclusão da aliq. no relatorio
           //
           IF SF3->F3_ALIQICM > 0                 // Calculo da bse e o imposto devido apenas quando > 0
              MSOMA     := (MSOMA + F3_VALCONT)
              MIMPOSTO  := (MIMPOSTO + F3_VALICM )           
           ENDIF
           //
           xfile := 1                     
           If nlin > 55
              _PAG:=_PAG+1
              cabec()
              nlin   := 13
           EndIf
           Dbskip()           
           //Loop
    End 
         
           IF xfile = 0                     
              //
              nVal := NOROUND(nVal + F3_VALCONT)       
              @ nlin, 000 PSAY Substr(DTOC(F3_EMISSAO),1,2)
              @ nlin, 006 PSAY F3_ESPECIE
              @ nlin, 013 PSAY F3_SERIE
              @ nlin, 019 PSAY F3_NFISCAL
              @ nlin, 026 PSAY F3_VALCONT PICTURE "@E 999,999.99"
              @ nlin, 045 PSAY F3_CODISS
              @ nlin, 055 PSAY F3_ALIQICM                 //"5,00 %"  // Removido Aliq. Fixada no prg
              @ nlin, 124 PSAY Alltrim(F3_OBSERV)
                nlin := nlin + 1       
              //
              // Adicionado novo controle conforme solicitado - 03/06/04
              // Saulo Muniz - Inclusão da aliq. no relatorio
              //
              IF SF3->F3_ALIQICM > 0                 // Calculo da bse e o imposto devido apenas quando > 0
                 MSOMA     := (MSOMA + F3_VALCONT)
                 MIMPOSTO  := (MIMPOSTO + F3_VALICM )           
                 xfile := 1                              
              ENDIF
              //
           EndIf
              //
              @ nlin, 000 PSAY "SubTotal :  "
              @ nlin, 028 PSAY nVal PICTURE "@E 999,999,999,999.99"
              nlin := nlin + 1                        
              //
              IncRegua()                   
              //
              If nlin > 55
                 _PAG:=_PAG+1
                 cabec()
                 nlin   := 13
              EndIf

EndDo



xBase := (msoma - mv_par09)          // deduções        
//_cBase := MIMPOSTO                 // base do imposto - Pedido para calcular sobre cada nf o imposto val. icms
//_cBase := ((xBase *  5)/100)       // base do imposto  
//

// Adicionado deduções - Saulo Muniz 03/08/04
// Trata o imposto se houver deduções - Regra de calculo :
// 1- Se houver deduçõs o imposto será calculado pela base das notas 
// 2- Senao o imposto será calculado nota a nota para compor a base
//

  IF mv_par09 > 0
     _cBase := ((xBase *  5)/100)   //Condição 1
  Else
     _cBase := MIMPOSTO             //Condição 2
  ENDIF


@ nlin, 022 PSAY REPLICATE("_",60)
  nlin := nlin + 1

@ nlin, 022 PSAY "|"
@ nlin, 024 PSAY "SOMA                                  |"
@ nlin, 063 PSAY MSOMA PICTURE "@E 999,999,999,999.99"
@ nlin, 081 PSAY "|"
@ nlin, 022 PSAY "|"
  nlin := nlin + 1

@ nlin, 022 PSAY "|"
@ nlin, 024 PSAY "DEDUCOES                              |"
@ nlin, 063 PSAY mv_par09 PICTURE "@E 999,999,999,999.99"
@ nlin, 081 PSAY "|"
  nlin := nlin + 1

@ nlin, 022 PSAY "|"
@ nlin, 024 PSAY "BASE DE CALCULO                       |"
@ nlin, 063 PSAY xBase PICTURE "@E 999,999,999,999.99"
@ nlin, 081 PSAY "|"
  nlin := nlin + 1

@ nlin, 022 PSAY "|"
@ nlin, 024 PSAY "IMPOSTO INCIDENTE                     |"
@ nlin, 063 PSAY  _cBase PICTURE "@E 999,999,999,999.99"
@ nlin, 081 PSAY "|"
  nlin := nlin + 1

@ nlin, 022 PSAY "|"
@ nlin, 024 PSAY "TOTAL ECONOMICO TRIBUTAVEL            |"
@ nlin, 063 PSAY MSOMA PICTURE "@E 999,999,999,999.99"
@ nlin, 081 PSAY "|"
  nlin := nlin + 1

@ nlin, 022 PSAY "|"
@ nlin, 024 PSAY "TOTAL IMPOSTO A RECOLHER              |"
@ nlin, 063 PSAY   _cBase PICTURE "@E 999,999,999,999.99"
@ nlin, 081 PSAY "|"
  nlin := nlin + 1

@ nlin, 022 PSAY REPLICATE("_",60)

dbSelectArea("SF3")
Retindex("SF3")

Set Device To Screen

If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim do Programa                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³                   FUNCOES ESPECIFICAS                        ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VERIMP   ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica posicionamento de papel na Impressora             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function VerImp()

nLin:= 0                // Contador de Linhas
If aReturn[5]==2

   nOpc       := 1

   While .T.

      SetPrc(0,0)
      dbCommitAll()

			IF MsgYesNo("Fomulario esta posicionado ? ")
				nOpc := 1
			ElseIF MsgYesNo("Tenta Novamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif

      Do Case
         Case nOpc==1
            lContinua:=.T.
            Exit
         Case nOpc==2
            Loop
         Case nOpc==3
            lContinua:=.F.
            Return
      EndCase
   End
Endif

Return

****************
Static Function CriaSX1()
****************

 * 01  X1_GRUPO    C  06          14  X1_VAR02  C  15
 * 02  X1_ORDEM    C  02          15  X1_DEF02  C  15
 * 03  X1_PERGUNT  C  20          16  X1_CNT02  C  30
 * 04  X1_VARIAVL  C  06          17  X1_VAR03  C  15
 * 05  X1_TIPO     C  01          18  X1_DEF03  C  15
 * 06  X1_TAMANHO  N  02          19  X1_CNT03  C  30
 * 07  X1_DECIMAL  N  01          20  X1_VAR04  C  15
 * 08  X1_PRESEL   N  01          21  X1_DEF04  C  15
 * 09  X1_GSC      C  01          22  X1_CNT04  C  30
 * 10  X1_VALID    C  60          23  X1_VAR05  C  15
 * 11  X1_VAR01    C  15          24  X1_DEF05  C  15
 * 12  X1_DEF01    C  15          25  X1_CNT05  C  30
 * 13  X1_CNT01    C  30          26  X1_F3     C  03


 DbSelectArea("SX1")
 DbSetOrder(1)

 If !DbSeek("GEFM0112")

    aSx1 := {}

    *           1          2      3                        4          5    6    7   8    9    10    11          12          13   14   15          16   17   18        19   20   21   22   23   24   25    26

    AADD(aSx1,{"GEFM01" , "01" , "A partir da data...?" , "mv_ch1" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par01" , "         " , "" , "" , "       " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" })
    AADD(aSx1,{"GEFM01" , "02" , "At‚ a data.........?" , "mv_ch2" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par02" , "         " , "" , "" , "       " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" })
    AADD(aSx1,{"GEFM01" , "03" , "P gina inicial.....?" , "mv_ch3" , "C" , 03 , 0 , 0 , "G" , "" , "mv_par03" , "         " , "" , "" , "       " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" })
    AADD(aSx1,{"GEFM01" , "04" , "N£mero do livro....?" , "mv_ch4" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par04" , "         " , "" , "" , "       " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" })
    AADD(aSx1,{"GEFM01" , "05" , "Imprime............?" , "mv_ch5" , "N" , 01 , 0 , 0 , "C" , "" , "mv_par05" , "S¢ Livro " , "" , "" , "Livro e Termos" , "" , "" , "Termos" , "" , "" , "" , "" , "" , "" , "" , "" })
    AADD(aSx1,{"GEFM01" , "06" , "Livro selecionado..?" , "mv_ch6" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par06" , "         " , "" , "" , "       " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" })
    AADD(aSx1,{"GEFM01" , "07" , "N§ do CCM..........?" , "mv_ch7" , "N" , 09 , 0 , 0 , "G" , "" , "mv_par07" , "         " , "" , "" , "       " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" })
    AADD(aSx1,{"GEFM01" , "08" , "Totaliza por Dia...?" , "mv_ch8" , "N" , 01 , 0 , 2 , "C" , "" , "mv_par08" , "Sim      " , "" , "" , "N„o    " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" })
    AADD(aSx1,{"GEFM01" , "09" , "Valor das dedu‡äes.?" , "mv_ch9" , "N" , 09 , 2 , 0 , "G" , "" , "mv_par09" , "         " , "" , "" , "       " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" })
    AADD(aSx1,{"GEFM01" , "10" , "Observa‡äes.(1)....?" , "mv_ch10" , "C" , 50 , 0 , 0 , "G" , "" , "mv_par10" , "         " , "" , "" , "       " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" })
    AADD(aSx1,{"GEFM01" , "11" , "Observa‡äes.(2)....?" , "mv_ch11" , "C" , 50 , 0 , 0 , "G" , "" , "mv_par11" , "         " , "" , "" , "       " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" })
    AADD(aSx1,{"GEFM01" , "12" , "Observa‡äes.(3)....?" , "mv_ch12" , "C" , 50 , 0 , 0 , "G" , "" , "mv_par12" , "         " , "" , "" , "       " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" })
*   AADD(aSx1,{"AULA01" , "03" , "Tipo Risco.........?" , "mv_ch3" , "N" , 01 , 0 , 0 , "C" , "" , "mv_par03" , "Risco A" , "" , "" , "Risco E" , "" , "" , "Todos" , "" , "" , "" , "" , "" , "" , "" , "   " })

    DbSeek("GEFM01")
* OU DBSEEK(CPERG)

    While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "GEFM01"
          Reclock("SX1",.F.,.F.)
          DbDelete()
          MsunLock()
          DbSkip()
	End

	For X1:=1 to Len(aSX1)
		RecLock("SX1",.T.)
        For Z:=1 To FCount()
            FieldPut(Z,aSx1[X1,Z])
		Next
		MsunLock()
	Next

 Endif

Return

Static FUNCTION CABEC()

NLIN := 01
//@ nlin, 000 PSAY Chr(18)                // Impressao Normal
//@ nlin, 000 PSAY Chr(15)                // Compressao de Impressao
@ nlin, 000 PSAY "EMPRESA: " + SM0->M0_NOMECOM
@ nlin, 055 PSAY "*** REGISTRO DE APURACAO DO I.S.S ***"
  nlin := nlin + 1
@ nlin,000 PSAY "CNPJ: " + LEFT(SM0->M0_CGC,2) +"." + SUBSTR(SM0->M0_CGC,3,3) + "." + SUBSTR(SM0->M0_CGC,6,3) + "/" + SUBSTR(SM0->M0_CGC,9,4) + "-" + RIGHT(SM0->M0_CGC,2)
  nlin := nlin + 1
@ nlin,000 PSAY "I.M. " + mv_par07
  nlin := nlin + 1
@ nlin, 000 PSAY "MES/ANO DE INCIDENCIA: " + MESEXTENSO(MONTH(mv_par01)) + " de " + RIGHT(DTOC(mv_par01),2)
  nlin := nlin + 1
@ nlin,000 PSAY "PAGINA : " + STR(_PAG)
  nlin := nlin + 2
@ nlin, 00 PSAY REPLICATE("_",150)
  nlin := nlin + 1
@ nlin, 000 PSAY "DOCUMENTO FISCAL"
@ nlin, 030 PSAY "|"
@ nlin, 031 PSAY "MOVIMENTO ECONOMICO TRIBUTAVEL"
@ nlin, 065 PSAY "|"
@ nlin, 066 PSAY "MOVIMENTO ECONOMICO ISENTO"
@ nlin, 093 PSAY "|"
@ nlin, 094 PSAY "SERVICOS EXEC.POR TERCEIROS"
@ nlin, 123 PSAY "|"
  nlin := nlin + 1
@ nlin, 030 PSAY "|"
@ nlin, 065 PSAY "|"
@ nlin, 068 PSAY "OU NAO TRIBUTAVEL"
@ nlin, 093 PSAY "|"
@ nlin, 095 PSAY "COM RETENCAO DE IMPOSTO"
@ nlin, 123 PSAY "|"
  nlin := nlin + 1
@ nlin, 000 PSAY REPLICATE("-",123)
@ nlin, 123 PSAY "|"
@ nlin, 124 PSAY "O B S E R V A C O E S"
  nlin := nlin + 1
@ nlin, 000 PSAY "DIA"
@ nlin, 004 PSAY "|"
@ nlin, 005 PSAY "ESPECIE"
@ nlin, 012 PSAY "|"
@ nlin, 013 PSAY "SERIE"
@ nlin, 018 PSAY "|"
@ nlin, 020 PSAY "NUMERO"
@ nlin, 030 PSAY "|"
@ nlin, 031 PSAY "VALOR DOCTO"
@ nlin, 043 PSAY "|"
@ nlin, 044 PSAY "COD.FISCAL"
@ nlin, 055 PSAY "|"
@ nlin, 056 PSAY "ALIQUOTA"
@ nlin, 065 PSAY "|"
@ nlin, 066 PSAY "VALOR DOCTO FISCAL"
@ nlin, 093 PSAY "|"
@ nlin, 123 PSAY "|"
  nlin := nlin + 1
@ nlin, 000 PSAY REPLICATE("_",150)
  nlin := nlin + 1

RETURN
