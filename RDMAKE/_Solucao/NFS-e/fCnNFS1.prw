#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch" 
#INCLUDE "tbiconn.ch"
#INCLUDE "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณfCnNFS1   บAutor ณLeandro PASSOS (+Solucoes) Data ณ21/08/12  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณChama a tela de NFSe FISA022 no ambiente com build atualizadaบฑฑ
ฑฑบ          ณde forma transparente ao usuario.                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณFATURAMENTO - NFS-e Municipal                                บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fCnNFS1()  
 
 // Conferir AllTrim(aEmpresas[_iFim][2]) e  AllTrim(aEmpresas[_iFim][8])              
Local _iFim 	:= 21 
Local cCodEmp 	:= cEmpAnt
Local cCodFil	:= cFilAnt   
// Conferir _aTabInt 	***     
// Conferir aRegGeral   ***  
// Conferir _aOriEmp    ***
Local xUsuario	:= cUserName
// Conferir _aTabVld 	***
// Conferir aRestricao	***
Local xIdUser 	:= "000001"	//codigo do usuario nfse no ambiente NFSE ou __cUserid ???
Local xUsuario 	:= "nfse"  	//nome do usuario nfse no ambiente NFSE 
// Conferir _cLotePA3	***


//ConOut("fCnNFS1: Chamada JOB empresa: " + cEmpAnt + " Filial: " + cFilAnt + " - Ambiente: " + AllTrim(aEmpresas[_iFim][2]) )
//StartJob("U_fCnNFS2",AllTrim(aEmpresas[_iFim][2]),.F.,cEmpAnt,cFilAnt,_aTabInt,AllTrim(aEmpresas[_iFim][8]),aRegGeral,_aOriEmp,cUserName,_aTabVld,aRestricao,__cUserid,_cLotePA3)
//ConOut("fCnNFS1: Final JOB empresa: " + cEmpAnt + " Filial: " + cFilAnt + " - Ambiente: " + AllTrim(aEmpresas[_iFim][2]) )
  
fCnNFS2(cCodEmp,cCodFil,aTabela,cEsquema,aGeralReg,aEmpOri,xUsuario,_xTabVld,xaRestricao,xIdUser,_cLotePA3)

Return 
 
Static Function fCnNFS2(cCodEmp,cCodFil,aTabela,cEsquema,aGeralReg,aEmpOri,xUsuario,_xTabVld,xaRestricao,xIdUser,_cLotePA3)
 
// declaracao de variaveis
Local nA := 1
Local cRestricao := ""
Local cChvAux    := ""
Public cEmpresa    := cCodEmp
Public __cInternet := NIL
Public cFOpenED    := ""
Public cEmpAnt     := cCodEmp
Public cFilAnt     := cCodFil
Public nModulo     := 5
Public cArqTab     := aTabela[1]
Public aEmpresas   := {}
Public __LPYME     := .F.
Public cAcesso     := Replicate("S",300)
Public __cUserID   := xIdUser
Public dDataBas    := Date()
Public cModulo     := "FAT"
 
// inicia processamento
//ConOut("fCnNFS2: Iniciando JOB de integra็ao - Ambiente: " + GetEnvServer() )
RpcSetType(3)
//ConOut("fCnNFS2: Abrindo empresa: " + cCodEmp + " Filial: " + cCodFil + " - Ambiente: " + GetEnvServer() )
OpenSM0(cCodEmp)
 
// abre os arquivos SXดs
//ConOut("fCnNFS2: Abrindo SXS do ambiente: " + GetEnvServer() + " Startpath: "  + GetSrvProfString("Startpath","") )
 
//PREPARE ENVIRONMENT EMPRESA cCodEmp FILIAL cCodFil  
         
PREPARE ENVIRONMENT ;
EMPRESA cCodEmp ;
FILIAL cCodFil ;
USER 'nfse' ;
PASSWORD 'nfsegefco' ;
TABLES  "SB1","SF2","SD2","SF3","SFT","SF4","SA1"  ;
MODULO "FAT" 
//MSExecAuto({|x| mata216(x)},PARAMIXB) RESET ENVIRONMENT

//ConOut("fCnNFS2: Ambiente: " + GetEnvServer() + " Startpath: "  + GetSrvProfString("Startpath","") )
FISA022()
 
// abre topconnect
//ConOut("fCnNFS2: Abrindo TopConnect")
Connect()
 
// abre SX5
ChkFile("SX5",.F.)
//ConOut("fCnNFS2: Abriu ChkFile(SX5) : " )
 
// encerra conexao
//ConOut("fCnNFS2: Fechando empresa: " + cEmpAnt + " Filial: " + cFilAnt )
RpcClearEnv()
 
Return