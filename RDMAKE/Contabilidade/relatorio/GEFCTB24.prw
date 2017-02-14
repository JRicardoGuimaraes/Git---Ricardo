#include "rwmake.ch"
/***************************************************************************
* Programa.....: GEFCTB24                                                  *
* Autor........: Marcelo Aguiar Pimentel                                   *
* Data.........: 07/05/2007                                                *
* Descricao....: Rotina para limpar Relatório de Vendas                    *
*                Contabilidade Gerencial                                   *
*                                                                          *
****************************************************************************
* Alterado por.:                                                           *
* Data.........:                                                           *
* Motivo.......:                                                           *
*                                                                          *
***************************************************************************/

User Function GEFCTB24()

cMensagem  := "Deseja limpar o Processamento de Vendas?"
cTitJanela := "Atenção"

Resposta := MSGBOX(cMensagem,cTitJanela,"YESNO")

If Resposta
   
   Processa({|| ZeraHist()},"Processando...")   
        
EndIf
 

Return

//////////////////////////////
Static Function ZeraHist() //
//////////////////////////////      

dbSelectArea("SZO")
dbSetOrder(1)
dbGotop()
 
While !Eof()

    IncProc()

    DbSelectArea("SZO")
    RecLock("SZO",.F.)
	    dbDelete()
    MsUnlock()             
    DbSkip()

Enddo

Return