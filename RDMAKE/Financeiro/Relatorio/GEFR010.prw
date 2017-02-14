#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/************************************************************************
* Programa........: GEFR010                                             *
* Autor...........: Marcelo Aguiar Pimentel                             *
* Data............: 03/04/07                                            *
* Descricao.......: Relatorio do log de erros de importacao PSA         *
*                                                                       *
*************************************************************************
* Modificado por..:                                                     *
* Data............:                                                     *
* Motivo..........:                                                     *
*                                                                       *
************************************************************************/
User Function GEFR010()
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relatório de Vendas Metier"
Local cPict         := ""
Local titulo       	:= "Relatório de Vendas Metier"
Local nLin         	:= 80
//						0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20
//						012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//						Lote     Data         Erros  Tit. Importados      Tentativas
//						99999 01/01/2007 99,999,999       99,999,999      99,999,999
//                     {00   ,06        ,17              ,34             ,50        }
//						0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20
//						012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//						   Prefixo Numero Conta PSA       C.Custo PSA          O.I. PSA             Erro Descricao                                               User ID  Nome do usuario      Erros
//						       XXX XXXXXX 999999999999999 99999999999999999999 99999999999999999999   XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999999  XXXXXXXXXXXXXXX 99,999,999
//                     {       07 ,11    ,18             ,34                  ,55                    ,77,81                                                      ,138    ,146            ,162}               

Local Cabec1       	:= "Lote     Data         Erros  Tit. Importados      Tentativas"
Local Cabec2       	:= "   Prefixo Numero Conta PSA       C.Custo PSA          O.I. PSA             Erro Descricao                                               User ID  Nome do usuario      Erros"
Local imprime      	:= .T.
Local aOrd 			:= {}
//Private aCol		:= {00         ,12     ,20                ,39 ,43                                                      ,100    ,108                  ,130             ,147                   }
Private aCol1		:= {00   ,06        ,17              ,34             ,50}
Private aCol2		:= {       07 ,11    ,18             ,34                  ,55                    ,77,81                                                      ,138    ,146            ,162}               

Private lEnd        := .F.
Private lAbortPrint	:= .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "GEF009" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt		:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "GEF009" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg		:= "GEF009"
Private cString := "SZN"

AjustaSX1()
Pergunte(cPerg,.F.)
dbSelectArea("SZN")
dbSetOrder(1)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

/*************************************************************************
* Funcao....: RUNREPORT()                                                *
* Autor.....: Marcelo Aguiar Pimentel                                    *
* Data......: 03/04/2007                                                 *
* Descricao.: Funcao responsável pela busca de informacoes na tabela SZN *
*             e impressão do resultado.                                  *
*                                                                        *
*************************************************************************/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local cQry:=""
Local cChave:=""
Local lCbcErrado:=.f.

cQry:="SELECT SZP.ZP_LOTE,SZP.ZP_DTLOTE,SZP.ZP_QTDERRO,SZP.ZP_QTDACER,SZP.ZP_QTDTENT,"
cQry+="       SZN.ZN_USERID,SZN.ZN_USERNAM,SZN.ZN_IDMSG,SX5.X5_DESCRI,SZN.ZN_PREFIXO,"
cQry+="       SZN.ZN_NUMNF,SZN.ZN_CTAPSA,SZN.ZN_CCPSA,SZN.ZN_OIPSA,SZN.ZN_COUNTER,"
cQry+="       SZN.ZN_STATUS"
cQry+="  FROM "+RetSqlName("SZP")+" SZP, "+RetSqlName("SZN")+" SZN, "+RetSqlName("SX5")+" SX5"
cQry+=" WHERE ZP_FILIAL = '  '"
cQry+="   AND ZP_LOTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
cQry+="   AND ZP_DTLOTE BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'"
cQry+="   AND ZN_FILIAL = '  '"
cQry+="   AND ZN_LOTE = ZP_LOTE"
cQry+="   AND ZN_DTLOG = ZP_DTLOTE"
cQry+="   AND X5_TABELA = 'Z3'"
cQry+="   AND X5_CHAVE  = ZN_IDMSG"
cQry+="   AND SZN.D_E_L_E_T_ <> '*'"
cQry+="   AND SX5.D_E_L_E_T_ <> '*'"
cQry+="   AND SZP.D_E_L_E_T_ <> '*'"
cQry+="ORDER BY ZP_LOTE,ZP_DTLOTE,ZN_STATUS,ZN_USERID,ZN_NUMNF,ZN_PREFIXO,ZN_IDMSG"
TcQuery cQry Alias "TRB" New
SetRegua(RecCount())

While !EOF()

	IncRegua()
   	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      	Exit
   	Endif

   	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
//      	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      	Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)
      	nLin := 06
   	Endif

	If cChave !=TRB->ZP_LOTE+TRB->ZP_DTLOTE
		If nLin !=06
			nLin++
		EndIf
		@nLin,00 PSAY Cabec1
		nLin++
		@nLin,aCol1[01] PSAY TRB->ZP_LOTE   	Picture "@!"
		@nLin,aCol1[02] PSAY stod(TRB->ZP_DTLOTE)
		@nLin,aCol1[03] PSAY TRB->ZP_QTDERRO	Picture "@E 99,999,999"
		@nLin,aCol1[04] PSAY TRB->ZP_QTDACER	Picture "@E 99,999,999"
		@nLin,aCol1[05] PSAY TRB->ZP_QTDTENT	Picture "@E 99,999,999"
		nLin++
		cChave:=TRB->ZP_LOTE+TRB->ZP_DTLOTE
		nLin++
		If TRB->ZN_STATUS == " "
			@nLin,00 PSAY "Corrigidos"
			nLin++
			@nLin,00 PSAY Cabec2
			nLin++
		EndIf
		lCbcErrado:=.f.
	EndIf
	If TRB->ZN_STATUS == "X" .and. lCbcErrado == .f.
		@nLin,00 PSAY "Erros"
		nLin++
		@nLin,00 PSAY Cabec2
		nLin++
		lCbcErrado:=.t.
	EndIf
	@nLin,aCol2[01] PSAY TRB->ZN_PREFIXO	Picture "@!"
	@nLin,aCol2[02] PSAY TRB->ZN_NUMNF 		Picture "@!"
	@nLin,aCol2[03] PSAY TRB->ZN_CTAPSA 	Picture "@!"
	@nLin,aCol2[04] PSAY TRB->ZN_CCPSA 		Picture "@!"
	@nLin,aCol2[05] PSAY TRB->ZN_OIPSA 		Picture "@!"
	@nLin,aCol2[06] PSAY TRB->ZN_IDMSG 		Picture "99"
	@nLin,aCol2[07] PSAY TRB->X5_DESCRI 	Picture "@!"
	@nLin,aCol2[08] PSAY TRB->ZN_USERID 	Picture "@!"
	@nLin,aCol2[09] PSAY TRB->ZN_USERNAM 	Picture "@!"
	@nLin,aCol2[10] PSAY TRB->ZN_COUNTER 	Picture "@E 99,999,999"
   	nLin++
	dbSelectArea("TRB")
   	dbSkip()
EndDo

dbSelectArea("TRB")
dbCloseArea()

SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function AjustaSX1()
PutSx1( "GEF009", "01","Da importacao:"   ,"Da importacao:"   ,"Da importacao:"   ,"mv_chs","D",8,0,0,"C","","","","","mv_par01","","","","","","","","","","","","","","","","",{},{},{},"Data inicial para ser filtrado no relatório")
PutSx1( "GEF009", "02","Ate a importacao:","Ate a importacao:","Ate a importacao:","mv_chs","D",8,0,0,"C","","","","","mv_par02","","","","","","","","","","","","","","","","",{},{},{},"Data final para ser filtrado no relatório")
PutSx1( "GEF009", "03","Do Lote:","Do Lote:","Do Lote:","mv_chs","C",5,0,0,"C","","","","","mv_par03","","","","","","","","","","","","","","","","",{},{},{},"Lote de erro da importacao")
PutSx1( "GEF009", "04","Ate Lote:","Ate Lote:","Ate Lote:","mv_chs","C",5,0,0,"C","","","","","mv_par04","","","","","","","","","","","","","","","","",{},{},{},"Lote de erro da importacao")
Return

FILIAL	
DESCRICAO	
A135	
A482	
A501	
A551	
A553	
A561	
A600	
A637	
A638	
A647	
A648	
A700	
A743	
A753	
A754	
A765	
A772


dbSelectArea("SZO")
aEst	:=	dbStruct("SZO")
cdbfSZO	:=	criatrab(aEst)
Use &cDbfSZO Alias cDbfSZO New
cInd1	:= CriaTrab("",.F.)
IndRegua("cDbfSZO",cInd1,"ZO_FILIAL+ZO_COD+ZO_CONTA+ZO_UO+ZO_METIER+DTOS(ZO_MES)",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
dbSetIndex( cInd1 +OrdBagExt())
