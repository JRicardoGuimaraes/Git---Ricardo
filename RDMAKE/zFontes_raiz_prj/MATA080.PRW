#include "rwmake.ch"        

User Function MATA080()     

SetPrvt("XTABDE,XTABPA,MSG,XCHV,XPRCDE,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATA080  ³ Autor ³ Saulo Muniz           ³ Data ³ 18.01.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Clonagem de Tabela de TES                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Utilizacao³ Especifico para Gefco                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Adicionar seleção de filiais a serem clonadas !


IF !INCLUI
    RETURN
ENDIF
  
_mOldArea	:=	Alias()
_mOldInde	:=	IndexOrd()
_mOldRecn	:=	Recno()

xTabDe := xFilial()
XTabPa := "  "

@ 200,001 TO 390,410 DIALOG oDlg TITLE "Clonagem de TES para Filiais "
@ 010,010 Say "Da Filial (Origem) :  "
@ 010,060 Say xTabDe Picture "@!"
@ 025,010 Say "Para Filial (Destino) : "
@ 025,060 Get xTabPa Picture "@!" //Valid xTabPa#xTabDe

@ 075,135 BMPBUTTON TYPE 01 ACTION Roda()
@ 075,170 BMPBUTTON TYPE 02 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED

DbSelectArea(_mOldArea)
DbSetOrder(_mOldInde)
DbGoto(_mOldRecn)

Return

//=============//
Static Function Roda()
//=============//  
//dbselectarea("SF4")
//dbsetorder(1)
//dbgotop()
xCount  := 0
cFilDe  := "  "
cFilAte := xTabPa
cFilAtu := xFilial()

Msg:='Confirma Clonagem das TES '
Msg:=Msg+Substr(xTabDe,1)+' Ate a Filial '+Substr(xTabPa,1)+' ?'
If MsgBox(Msg,"","YESNO")

dbSelectArea("SM0")
DbGotop()
dbSeek("01"+cFilDe,.T.)

While !Eof() .and. M0_CODFIL <= cFilAte
	           
      If M0_CODFIL == cFilAtu  // Não replica para a filial atual
         DbSkip()      
         Loop
      EndIf
      
   	        DbSelectArea("SF4")         
            RecLock("SF4",.T.)      
    		F4_FILIAL   := SM0->M0_CODFIL
    		F4_CODIGO   := M->F4_CODIGO          
            F4_TIPO     := M->F4_TIPO
            F4_ICM      := M->F4_ICM
            F4_IPI      := M->F4_IPI
            F4_CREDICM  := M->F4_CREDICM 
            F4_CREDIPI  := M->F4_CREDIPI
            F4_DUPLIC   := M->F4_DUPLIC
            F4_ESTOQUE  := M->F4_ESTOQUE
            F4_CF       := M->F4_CF
            F4_CFNOVO   := M->F4_CFNOVO
            F4_TEXTO    := M->F4_TEXTO
            F4_PODER3   := M->F4_PODER3
            F4_LFICM    := M->F4_LFICM
            F4_LFIPI    := M->F4_LFIPI
            F4_DESTACA  := M->F4_DESTACA
            F4_INCIDE   := M->F4_INCIDE
            F4_COMPL    := M->F4_COMPL
            F4_ISS      := M->F4_ISS
            F4_LFISS    := M->F4_LFISS
            F4_IPIFRET  := M->F4_IPIFRET
            F4_CONSUMO  := M->F4_CONSUMO 
            F4_UPRC     := M->F4_UPRC 
            F4_AGREG    := M->F4_AGREG 
            F4_INCSOL   := M->F4_INCSOL
            F4_CIAP	    := M->F4_CIAP
            F4_DESPIPI	:= M->F4_DESPIPI
            F4_ATUTEC	:= M->F4_ATUTEC
            F4_ATUATF	:= M->F4_ATUATF
            F4_TPIPI    := M->F4_TPIPI
            F4_BASEISS  := M->F4_BASEISS
            F4_BSICMST	:= M->F4_BSICMST
            F4_CREDST	:= M->F4_CREDST
            F4_STDESC	:= M->F4_STDESC
            F4_DESPICM	:= M->F4_DESPICM
            F4_SITTRIB	:= M->F4_SITTRIB
            F4_PISCOF	:= M->F4_PISCOF
            F4_PISCRED  := M->F4_PISCRED
            F4_TESDV    := M->F4_TESDV
           	F4_TPMOV    := M->F4_TPMOV
       		F4_MOVPRJ   := M->F4_MOVPRJ
       		F4_IPILICM	:= M->F4_IPILICM
       		F4_ICMSDIF	:= M->F4_ICMSDIF
       		F4_TESP3	:= M->F4_TESP3
       		F4_QTDZERO	:= M->F4_QTDZERO
       		F4_SLDNPT	:= M->F4_SLDNPT
       		F4_DEVZERO	:= M->F4_DEVZERO
       		F4_TIPOPER	:= M->F4_TIPOPER
       		F4_TESENV	:= M->F4_TESENV
       		F4_OBSICM	:= M->F4_OBSICM
       		F4_REGDSTA	:= M->F4_REGDSTA
       		F4_OBSSOL	:= M->F4_OBSSOL
       		F4_TRFICM	:= M->F4_TRFICM
       		F4_PICMDIF	:= M->F4_PICMDIF
       		F4_BASEPIS  := M->F4_BASEPIS      
    		MsUnLock()		
    
	dbSelectArea("SM0")
	dbSkip()

Enddo


Else
	Help(" ",1,"SEMPED",,"Clonagem Cancelada !!",3,1)

Endif

Close(oDlg)

Return