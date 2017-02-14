#include "tbiconn.ch"
#include "MSOLE.CH" 
#include "ap5mail.ch" 
#include "rwmake.CH"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// funcao para gerar planilha excel comparativa e enviar por email
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

User Function FXCTBFIN
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
fGeraArquivo()
RESET ENVIRONMENT
Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fGeraArquivo()
Local cArquivo, cPara

// verifica arquivo gerado
cArquivo := "\system\sigafin.xnu"
cPara    := "marcelo@maisolucoes.com.br"

// envia email
fEnviaEmail(cArquivo,cPara)
Return


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fEnviaEmail(cAnexo,cPara)

// declaracao de variaveis
Local cServer    := ""
Local cEmail     := ""
Local cPass      := ""
Local cDe        := ""
Local lResulConn := .T.
Local lResulSend := .T.
Local cError     := ""
Local cAssunto   := "Planilha Comparativa Financeiro x Contabil"
Local cMsg       := "..."  

// configuracao do email
MsgAlert(cServer+Chr(13)+cEmail+Chr(13)+cPass+Chr(13)+cDe+Chr(13)+cPara+Chr(13)+cAnexo)

// conecta no servidor SMTP
CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn
If !lResulConn
   GET MAIL ERROR cError
   MsgAlert("Falha na conexão "+cError)
   Return(.F.)
Endif

// envia email
SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend   
If !lResulSend
   GET MAIL ERROR cError
   MsgAlert("Falha no Envio do e-mail " + cError)
Endif

// desconecta
DISCONNECT SMTP SERVER

// retorna
return