#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 09/08/02

User Function gefbol()        // incluido pelo assistente de conversao do AP5 IDE em 09/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,AORD,NLASTKEY,LI,CPERG")
SetPrvt("TITULO,CCANCEL,WNREL,_CDATA,CCOD,CEND1")
SetPrvt("CEND2,CCEP,CCGC,CFORM,CCONDPG,")



cString:="SE1"
cDesc1:= OemToAnsi("Este programa tem como objetivo, ")
cDesc2:= OemToAnsi("imprimir os boletos emitidos com os parametros .") 
cDesc3:= ""
tamanho:="P"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="GEFBOL"
aLinha  := aOrd := { }
nLastKey := 0
li := 1
cPerg:="GEFBOL"

Pergunte(cPerg,.f.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametro    ³
//³ mv_par01              Do Prefixo            ³
//³ mv_par02              Ate Prefixo           ³
//³ mv_par03              Do Titulo              ³
//³ mv_par04              Ao Titulo              ³
//³ mv_par05              Do Vencimento    ³
//³ mv_par06              Ao Vencimento    ³
//³ mv_par07              NossoNum          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo  :="Impressao de Boletos"
cCancel := "***** CANCELADO PELO OPERADOR *****"
wnrel   :="GEFBOL"
SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,tamanho)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

DbSelectArea("SA1")
DBSETORDER(1)
DbGoTop()

DbSelectArea("SE1")
DBSETORDER(1)       
DbGoTop()

RptStatus({|| _BolPrint() })// Substituido pelo assistente de conversao do AP5 IDE em 09/08/02 ==> RptStatus({|| Execute(_BolPrint) })

If ( aReturn[5]==0 )
	Set Print to
    SetPrc(0,0)
	dbCommitall()
	ourspool(wnrel)
EndIf

MS_Flush()
Return NIL

*----------------------------------------------------------------------*
// Substituido pelo assistente de conversao do AP5 IDE em 09/08/02 ==> Function _BolPrint
Static Function _BolPrint()
*----------------------------------------------------------------------*
//_cDATA := dtoS(MV_PAR01)
xNumBco  := 0
xNumBco  :=Val(MV_PAR07)

SetRegua(LastRec())
DbSelectArea("SE1")
DBSEEK(xFilial("SE1")+MV_PAR01+MV_PAR03,.T.)

While SE1->E1_VENCTO >= MV_PAR05 .AND. SE1->E1_VENCTO <= MV_PAR06 .AND. !EOF()

		IncRegua()
		 
		IF SE1->E1_PREFIXO < MV_PAR01 .OR. SE1->E1_PREFIXO > MV_PAR02
		   DBSKIP()
//		   LOOP
		ENDIF
		
		DbSelectArea("SA1")
		dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
		
		cCOD  := SA1->A1_COD
		cEnd1 := SA1->A1_END
		cEnd2 := SA1->A1_BAIRRO+" - "+A1_MUN+" - "+SA1->A1_EST
		cCep  := SA1->A1_CEP
		cCGC  := SA1->A1_CGC
//		cForm := SA1->A1_FORMAPG
		cCONDPG := SA1->A1_COND
				
          dbSelectArea( "SE1" )	
		  IF SE1->E1_PORTADO == "356"

                @ LI, 55 PSAY Chr(18) + DtoC( SE1->E1_VENCTO )
                @ LI+3, 001 PSAY DtoC( SE1->E1_EMISSAO )
                @ LI+3, 011 PSAY SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA
                @ LI+3, 040 PSAY SE1->E1_EMISSAO
                @ LI+4, 051 PSAY SE1->E1_VALOR PICTURE "@E 999,999,999.99"				
//              @ LI+6, 051 PSAY xValInd PICTURE "@E 999,999,999.99"
//              @ LI+6, 002 PSAY chr(15)+iif(xValInd>0,"Desconto Referente a Indenizacao","")+chr(18)		
				@ LI+8, 002 PSAY chr(15)+"Apos 30 dias do Vencimento o Titulo sera Baixado "
				@ LI+9, 003 PSAY "Juros por dia de Atraso de R$ "+Transform(SE1->E1_VALOR*0.02/30,"@EB 999,999.99")
				@ LI+10,003 PSAY "Titulo Sujeito a Protesto apos 20 dias do Vencimento"
				@ LI+12,000 PSAY chr(18)
				@ LI+13,002 PSAY chr(15)+AllTrim(SA1->A1_COD)+"/"+SA1->A1_LOJA+"-"+SA1->A1_NOME+"                CGC : "+TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99")
				@ LI+14,002 PSAY cEnd1 + " CEP : "+SubStr(cCep,1,5)+"-"+SubStr(cCep,6,3)
				@ LI+15,002 PSAY cEnd2+chr(18)
	                RecLock("SE1",.F.)
	                  SE1->E1_NUMBCO := Strzero(xNumBco,12) 
	                  xNumBco := xNumBco +1
	                Msunlock()	      
	      EndIF		
        
     LI:=LI+24
	dbSelectArea("SE1")
	DBSKIP()
EndDO
	                
	                DbSelectArea("SX1")
                    DBSEEK("GEFBOL"+"07",.T.)
	                RecLock("SX1",.F.)	                   
	                  SX1->X1_CNT01 := Strzero(xNumBco,12)	                
	                Msunlock()	      
	                
SetPrc(0,0) 
Eject
RETURN(.T.)
