#include "rwmake.ch"    
#include "topconn.ch"

*---------------------------------*
USER Function TSTSE2()
*---------------------------------*
Local aVetor   := {}
Local cRecSE2
Local _aArea   := GetArea()

DbSelectArea("SE2")

lMsErroAuto := .F.

aVetor := { {"E2_FILIAL"  ,xFilial("SE2")           ,Nil},;
       {"E2_PREFIXO" ,"TST"                    		,Nil},;
       {"E2_NUM"     ,"999999"              		,Nil},;
       {"E2_TIPO"    ,"NF "                    		,Nil},;
       {"E2_NATUREZ" ,"500"                  		,Nil},;
       {"E2_FORNECE" ,"000352"		           		,Nil},;
       {"E2_LOJA"    ,"01"			          		,Nil},;
       {"E2_EMISSAO" ,dDataBase                		,Nil},;
       {"E2_VENCTO"  ,dDataBase + 30           		,Nil},;
       {"E2_VENCREA" ,dDataBase + 30           		,Nil},;
       {"E2_MOEDA"   ,1                        		,Nil},;
       {"E2_VALOR"   ,10000					  		,Nil},; //vALOR + cpmf
       {"E2_VLCRUZ"  ,10000					 		,Nil},; //vALOR + cpmf
       {"E2_LA"      ,"S"                      		,Nil},;       //Já entra contabilizado
       {"E2_CCONT"   ,"1010020006"            		,Nil}}
       
	   MSExecAuto({|x,y| Fina050(x,y)},aVetor,3) //3-Inclusao  /5-Exclusao
	   
	   aVetor    := {}
If lMsErroAuto  
	Alert("Erro ao Incluir o Titulo")
    MostraErro()
	DbSelectArea("SE2")
Else
	Alert("Ok")	
Endif
RestArea(_aArea)
Return


User Function ImpCC()
Local cQry

cQry := " SELECT * FROM CTT_TEMP ORDER BY CTT_CUSTO "
TCQUERY cQry NEW ALIAS "TCC"

dbSelectArea("TCC") ; dbGoTop()
If EOF()
	Alert("Tabela TEMP_CC Vazia.")
Else
	Alert("Inicio de importação.")
EndIf		

While !EOF()

	dbSelectArea("CTT")
	RecLock("CTT",.T.)
		CTT->CTT_FILIAL	:= TCC->CTT_FILIAL
		CTT->CTT_CUSTO	:= TCC->CTT_CUSTO
		CTT->CTT_CLASSE	:= TCC->CTT_CLASSE
		CTT->CTT_DESC01	:= TCC->CTT_DESC01
//		CTT->CTT_DESC02	:= TCC->CTT_DESC02
//		CTT->CTT_DESC03	:= TCC->CTT_DESC03
//		CTT->CTT_DESC04 := TCC->CTT_DESC04
//		CTT->CTT_DESC05	:= TCC->CTT_DESC05
		CTT->CTT_BLOQ	:= TCC->CTT_BLOQ
//		CTT->CTT_DTBLIN	:= TCC->CTT_DTBLIN
//		CTT->CTT_DTBLFI	:= TCC->CTT_DTBLFI
		CTT->CTT_DTEXIS	:= CTOD("01/01/08") // TCC->CTT_DTEXIS
		CTT->CTT_CCLP	:= TCC->CTT_CCLP
//		CTT->CTT_CCPON	:= TCC->CTT_CCPON
//		CTT->CTT_BOOK	:= TCC->CTT_BOOK
//		CTT->CTT_CCSUP	:= TCC->CTT_CCSUP
//		CTT->CTT_RES	:= TCC->CTT_RES
		CTT->CTT_CRGNV1	:= TCC->CTT_CRGNV1
//		CTT->CTT_RGNV2	:= TCC->CTT_RGNV2
//		CTT->CTT_RGNV3	:= TCC->CTT_RGNV3
//		CTT->CTT_NORMAL	:= TCC->CTT_NORMAL
//		CTT->CTT_STATUS	:= TCC->CTT_STATUS
//		CTT->CTT_FILMAT	:= TCC->CTT_FILMAT
//		CTT->CTT_MAT	:= TCC->CTT_MAT
//		CTT->CTT_PERCAC	:= TCC->CTT_PERCAC
//		CTT->CTT_PERFPA	:= TCC->CTT_PERFPA
//		CTT->CTT_NOME	:= TCC->CTT_NOME
//		CTT->CTT_ENDER	:= TCC->CTT_ENDER
//		CTT->CTT_BAIRRO	:= TCC->CTT_BAIRRO
//		CTT->CTT_CEP	:= TCC->CTT_CEP
//		CTT->CTT_MUNIC	:= TCC->CTT_MUNIC
//		CTT->CTT_ESTADO	:= TCC->CTT_ESTADO
//		CTT->CTT_TIPO	:= TCC->CTT_TIPO
//		CTT->CTT_CEI	:= TCC->CTT_CEI
//		CTT->CTT_VALFAT	:= TCC->CTT_VALFAT
//		CTT->CTT_RETIDO	:= TCC->CTT_RETIDO
//		CTT->CTT_LOCAL	:= TCC->CTT_LOCAL
		CTT->CTT_UO		:= TCC->CTT_UO
//		CTT->CTT_USERGI	:= TCC->CTT_USERGI
//		CTT->CTT_USERGA	:= TCC->CTT_USERGA
		CTT->CTT_CONTA	:= TCC->CTT_CONTA
//		CTT->CTT_OCORRE	:= TCC->CTT_OCORRE
//		CTT->CTT_ITOBRG	:= TCC->CTT_ITOBRG
//		CTT->CTT_CLOBRG	:= TCC->CTT_CLOBRG
//		CTT->CTT_ACITEM	:= TCC->CTT_ACITEM
//		CTT->CTT_ACCLVL	:= TCC->CTT_ACCLVL
		CTT->CTT_UONEW	:= TCC->CTT_UONEW
		CTT->CTT_XTPDES	:= TCC->CTT_XTPDES
	MsUnLock()
	
	dbSelectArea("TCC")
	dbSkip()
End

dbSelectArea("TCC")
dbCloseArea()
Alert("Fim de importação.")
Return