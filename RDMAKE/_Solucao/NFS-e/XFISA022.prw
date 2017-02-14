#include "protheus.ch"
#include "tbiconn.ch"

////////////////////////////////////////////////////////////////////////////////////////////////
// Programa:  XFISA022                                                       Data: 22/08/2012 //
// Descricao: Efetua conexao com outro servico do Protheus para                               //
//            executar a funcao FISA022 de nota fiscal eletronica de servicos                 //
////////////////////////////////////////////////////////////////////////////////////////////////

User Function XFISA022
//WaitRun("E:\Protheus10\bin_nfse\smartclient\TotvsSmartClient.exe -m -e=nfse -p=u_yfisa022 -c=tcp")
//WaitRun("\\10.62.160.153\Protheus10\bin_nfse\smartclient\TotvsSmartClient.exe -m -e=nfse -p=u_yfisa022 -c=tcp")

// abre simamat.mep na outra base
_cArqEmp := "\\10.62.160.153\Protheus10\protheus_data_nfse\system\sigamat.emp"
_cArqInd := "\\10.62.160.153\Protheus10\protheus_data_nfse\system\sigamat.ind"
SET DELETED OFF
DbUseArea(.T.,,_cArqEmp,"TEMP",.T.,.F.)
DbSetIndex(_cArqInd)
DbGoTop()
While !TEMP->(EOF())
   // verifica se esta excluido e volta
   If Deleted()
      If RecLock("TEMP",.F.)
         DbRecall()
         MsUnlock()
      Endif
   Endif
   // exclui se for diferente da empresa/filial atual
   If TEMP->M0_CODIGO+TEMP->M0_CODFIL <> cEmpAnt+cFilAnt
      If RecLock("TEMP",.F.)
         DbDelete()
         MsUnlock()
      Endif
   Endif
   // proximo reigstro
   DbSelectArea("TEMP")
   DbSkip()
End
TEMP->(DbCloseArea())
SET DELETED ON
// efetua chamada do processo
WaitRun("\\10.62.160.153\Protheus10\bin_nfse\smartclient\TotvsSmartClient.exe -m -e=nfse -p=sigafat -c=tcp")
Return

User Function ZFISA022(xEmp,xFil)

// define variaveis
Local _cServer   := "10.62.160.153"
Local _cPorta    := "5671"
Local _cAmbiente := "NFSE"
Local _oServer

// VARIAVEIS DE EMPRESA
DEFAULT xEmp := "01"
DEFAULT xFil := "01" 

// inicia conexao
ConOut("NFSE GEFCO: iniciando conexao [ " + _cServer + " "  + _cPorta + " "  + _cAmbiente + " ]")
CREATE RPCCONN _oServer ON SERVER _cServer PORT Val(_cPorta) ENVIRONMENT _cAmbiente EMPRESA xemp FILIAL xFil CLEAN

// verifica se teve problemas
If _oServer == NIL
	UserException("NFSE GEFCO: Falha de conexao RPC")
	ConOut("NFSE GEFCO: Falha de conexao RPC")
	Return
Endif
PREPARE ENVIRONMENT EMPRESA xEmp FILIAL xFil MODULO "FAT" USER 'nfse' PASSWORD 'nfsegefco' TABLES  "SB1","SF2","SD2","SF3","SFT","SF4","SA1" 

// mensagem de conexao realizada
ConOut("NFSE GEFCO: conexao realizada com sucesso")

// executa funcao do FISA022
_oServer:CallProc("FISA022",xEmp,xFil)
//FISA022()

// encerra conexao
ConOut("NFSE GEFCO: finalizando conexao")
CLOSE RPCCONN _oServer
ConOut("NFSE GEFCO: finalizado")

// retorna
Return

User Function YFISA022(xEmp,xFil)
PUBLIC oMainWnd
Public __cInternet := "" 
Public cPergunta := ""
Public cMVVAR := ""
Public cCapWalkThru := ""
Public aRotina := {}
Public aArray  := {}
Public aSvRotina := {}
Public cCapSair := ""
Public __lMbrwBtn := .T.
Public lProcess := .T.
Public cEmpAnt
Public cFilAnt 
Public cAlias  := {}
Public aEncho := {}
Public cTopFun := ""
Public cBotFun := ""
Public lBack := .F.
Public lTopFilter := .F.
Public lSeeAll := .T.
Public lBrwFilOn := .F.
Public lChgAll := .F.
Public lTcSqlFilter := .F.
Public lRunPopUp := .T.
Public lAxPesqui := .T.



// VARIAVEIS DE EMPRESA
DEFAULT xEmp := "01"
DEFAULT xFil := "01"

cEmpAnt := xEmp
cFilAnt := xFil

//MsgInfo("GEFCO NFSE: Iniciando Thread para rotina FISA022 [" + xEmp+"/"+xFil + "]")
ConOut("GEFCO NFSE: Iniciando Thread para rotina FISA022 [" + xEmp+"/"+xFil + "]")
//PREPARE ENVIRONMENT EMPRESA xEmp FILIAL xFil MODULO "FAT" USER 'nfse' PASSWORD 'nfsegefco' TABLES  "SB1","SF2","SD2","SF3","SFT","SF4","SA1" 
PREPARE ENVIRONMENT EMPRESA xEmp FILIAL xFil MODULO "FAT" USER 'Admin' PASSWORD 'Admnfse' TABLES  "SB1","SF2","SD2","SF3","SFT","SF4","SA1" 
ConOut("GEFCO NFSE: Montando variaveis de ambiente")
SetsDefault()  
ConOut("GEFCO NFSE: Iniciando FISA022")                                                                                                     
//DEFINE WINDOW oMainWnd FROM 1, 1 TO 22, 75 TITLE "Faturamento"
//DEFINE WINDOW oMainWnd FROM 000,000 TO 400,500 TITLE "Faturamento" 
DEFINE WINDOW oMainWnd FROM 000,000 TO 1200,1600 TITLE "Faturamento" 
ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT FISA022()
//ConOut("GEFCO NFSE: Iniciando FISA022")                                                                                                     
//FISA022()
ConOut("GEFCO NFSE: Saindo da rotina FISA022")
RESET ENVIRONMENT
ConOut("GEFCO NFSE: Finalizando Thread para rotina FISA022")
Return


User Function xMBRWBTN
MsgAlert("MBRWBTN")
Return