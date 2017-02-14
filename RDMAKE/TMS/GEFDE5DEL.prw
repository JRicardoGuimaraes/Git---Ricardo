#include "rwmake.ch"    
#include "topconn.ch"
#INCLUDE "tbiconn.ch"

/**********************************************************************
* Programa.......: GEFDE5()                                           *
* Autor..........: Ricardo Guimarães                                  *
* Data...........: 01/06/12                                           *
* Descricao......: Limpeza da tabela DE5 - EDI                        *
*                                                                     *
***********************************************************************
* Modificado por.:                                                    *
* Data...........:                                                    *
* Motivo.........:                                                    *
*                                                                     *
**********************************************************************/

User Function GEFDE5DEL(lAutoI)
Private lAutoImp:=iif(lAutoI = Nil,.f.,lAutoI)

If !lAutoImp
	If MsgYesNo("Esta rotina irá fazer a Limpeza da tabela DE5"+chr(10)+"Deseja continuar?","Atenção!")
		Processa({|| fRunDE5DEL() },"Limpando a tabela DE5 ...")      
	EndIf
Else
	RPCSetType(3) // Nao consome o numero de licencas
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "TMS" TABLES "DE5","DTC","DT6","DTP"
	
	fRunDE5DEL()
		
	RESET ENVIRONMENT
EndIf
Return

//*****************************************************************************
Static Function fRunDE5DEL()
Local cQry := ""

CONOUT("Início de exclusão de registros da tabela DE5.")

cQry := " DELETE FROM " + RetSqlName("DE5") + " WHERE CONVERT(SmallDateTime,DE5_DTAEMB) <= (GETDATE() - 10) "

If TcSQLExec(cQry) < 0                                
	If !lAutoImp
		Alert(TcSqlError())
	EndIf	
		
	CONOUT("Error ao excluir registro da tabela DE5.")
EndIf		
TcSQLExec("COMMIT")
	
CONOUT("Término de exclusão de registros da tabela DE5.")
Return

