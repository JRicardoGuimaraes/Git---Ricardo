#include "TopConn.ch"
#include "RWMAKE.ch"
#INCLUDE "tbiconn.ch"
#include "tryexception.ch"

User function TestError()
// Salva bloco de c�digo do tratamento de erroLocal 

oError := ErrorBlock({|e| MsgAlert("Mensagem de Erro: " +chr(10)+ e:Description)})               
cExpr := "aaa"

If !Empty(cExpr)  

   Begin Sequence    
	// For�a erro, enviando caracter onde deveria ser num�rico    
	cNum := StrZero(cExpr,5)    
	MsgAlert( cNum )     
	Return .T.  
   End Sequence
EndIf

ErrorBlock(oError)
Return .F.

*-----------------------------*
User Function TstError2()
*-----------------------------*

Local bError := { |oError| MyError( oError ) }
Local oError

TRYEXCEPTION USING bError
//For�ando um erro para avalia-lo.
__EXCEPTION__->ERROR := "__EXCEPTION__"
CATCHEXCEPTION USING oError
//"Se ocorreu erro, ap�s o BREAK, venho para c�"
MsgInfo( oError:Description , "Peguei o Desvio do BREAK" )
ENDEXCEPTION

MsgInfo( "Continuo ap�s o tratamento de erro" )

Return( NIL )

Static Function MyError( oError )
MsgInfo( oError:Description , "Deu Erro" )
BREAK
Return( NIL )

//Read more: http://www.blacktdn.com.br/2009/10/protheus-tratamento-de-erro-simulando.html#ixzz3PTkwZ9Kb

