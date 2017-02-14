#Include "Protheus.Ch"
#Include "TopConn.Ch"
#Include "Ap5Mail.Ch"
#Include "TbiConn.Ch"
/*__________________________________________________________________________________
|¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦|
|¦¦+----------------------------------------------------------------------------+¦¦|
|¦¦| Cliente   | Gefico                                   | Data   | 15/10/2013 |¦¦|
|¦¦|-----------+----------------------------------------------------------------|¦¦|
|¦¦| Programa  | GEFA008   | Tipo |Rotina de Envio E-mail   | Módulo | SIGAFAT  |¦¦|
|¦¦|-----------+----------------------------------------------------------------|¦¦|
|¦¦| Autor     | Rafael Rezende        | Empresa | Idéias Tecnologia            |¦¦|
|¦¦|-----------+----------------------------------------------------------------|¦¦|
|¦¦| Descrição |   Rotina com o objetivo de enviar o arquivo XML de uma nota de |¦¦|
|¦¦|           |serviços para o Cliente.                                        |¦¦|
|¦¦|-----------+----------------------------------------------------------------|¦¦|
|¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦|
|¦¦|----------------------------------------------------------------------------|¦¦|
|¦¦| Alteração da Rotina                                  | Data   | 14/11/2013 |¦¦|
|¦¦|----------------------------------------------------------------------------|¦¦|
|¦¦| Autor     |  André Costa          | Empresa | Idéias Tecnologia            |¦¦|
|¦¦|----------------------------------------------------------------------------|¦¦|
|¦¦| Motivo    | Colocação do filtro de Filial, acerto no envio do XML das      |¦¦|
|¦¦|           | empresas 07,20 e 21 pois não saia correto e colocação do Check |¦¦|
|¦¦|           | Box de Inversão de Seleção												  |¦¦|
|¦¦+----------------------------------------------------------------------------+¦¦|
|¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦|
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
                      
*---------------------*
User Function GEFA008
*---------------------*
	Local _nOpc       := 0
	Local _oBtnOk		:= Nil
	Local _oBtnParam	:= Nil
	Local _oBtnSair	:= Nil
	Local _oGroupMsg	:= Nil
	Local _oSayMsg		:= Nil
	Local _oFontMsg	:= TFont():New( "Arial",, 018,, .F.,,,,, .F., .F. )
	Local _oFontBtn 	:= TFont():New( "Arial",, 017,, .T.,,,,, .F., .F. )
	Local _cMensagem	:= "Selecione os Parâmetros desejados através do Botão Parâmetros e então confirme o Processamento."
	
	Private _cPerg 	:= "GEFA008X"
	Private _oDlgTela	:= Nil

Return