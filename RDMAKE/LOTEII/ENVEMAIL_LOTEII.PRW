#include "rwmake.ch"
#INCLUDE "AP5MAIL.CH"


User Function EnvEmail(cDe,cPara,cCc,cAssunto,cMsg,cAnexo)
Local lResulConn := .T.
Local lResulSend := .T.
Local cError := ""
Local cServer   := Trim(GetMV("MV_RELSERV")) // smtp.ig.com.br ou 200.181.100.51
Local cAccount  := Trim(GetMV("MV_RELACNT")) // fulano@ig.com.br
Local cPass := Trim(GetMV("MV_RELPSW"))  // 123abc

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass RESULT lResulConn

If !lResulConn
   GET MAIL ERROR cError
   MsgAlert("Falha na conexão "+cError)
   Return(.F.)
Endif

// Sintaxe: SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
// Todos os e-mail terão: De, Para, Assunto e Mensagem, porém precisa analisar se tem: Com Cópia e/ou Anexo

If Empty(cCc) .And. Empty(cAnexo)
   SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg RESULT lResulSend
Else
   If Empty(cCc) .And. !Empty(cAnexo)
      SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend   
   Else                              
	   If !Empty(cCc) .And. !Empty(cAnexo)   
    	  SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend 
       Else	  
      	  SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg RESULT lResulSend   
       EndIf	  
   Endif
Endif

If !lResulSend
   GET MAIL ERROR cError
   MsgAlert("Falha no Envio do e-mail " + cError)
Endif

DISCONNECT SMTP SERVER

RETURN(.T.)