/*--------------------------------------------------------------------------------------*
* FMQTRM.PRW - Especifico da FarmoQu�mica           		            em: 05/06/09    *
* Autor       : J Ricardo de O Guimar�es                                              	*
* Objetivo    : Realizar a avalia��o do treimamento pelo funcion�rio e pelo gestor      *
*                                                                                   	*
* Observacoes : Enviar Workflow para o funcion�rio avaliar o treinamento                *
*                 																		*
*                                                                              	        *
*---------------------------------------------------------------------------------------*
* Alteracoes                                                                          	*
*---------------------------------------------------------------------------------------*
* Por 			: 																		*
* Alteracao 	: 																		*
* Objetivo    	: 																		*
* Observacoes	: 																		*
*                																		*
---------------------------------------------------------------------------------------*/

#include "rwmake.ch"
#include "topconn.ch"

USER Function fqmtrm()
Local _cQry := ""

U_EnvWFAvalia()
Return

/* Query para pegar agenda de treinamento com avalia��o avalia��o de funcion�rio pendente
   RAJ_QUEM := 1-Funcion�rio; 2-Outros
*/   

_cQry := " SELECT RAJ_FILIAL, RAJ_CALEND, RAJ_CURSO, RA1_DESC, RA1_AREA, RAJ_TURMA, RAJ_MAT, RAJ_TESTE, RAJ_MODELO, RAJ_DATA, RAJ_HORA, RAJ_QUEM, "
_cQry += "        RAJ_MATAVA, RAJ_OK "
_cQry += "  FROM RAJ010 RAJ, RA1010 RA1 "
_cQry += " WHERE RAJ.D_E_L_E_T_='' "
_cQry += "   AND RAJ_OK = '' "  // Ainda n�o foi realizado a avalia��o
_cQry += "   AND RA1.D_E_L_E_T_='' "
_cQry += "   AND RAJ_CURSO = RA1_CURSO "
_cQry += "   AND RAJ_QUEM = '1'"  // Avaliza��o ser� realizada pelo funcion�rio

If Select("_TRM") > 0
	TRM->(DbCloseArea())
EndIf

// memowrit("c:\FQM.sql",_cQry)
TcQuery _cQry Alias "_TRM" New

dbSelectArea("_TRM") ; dbGotop()

If _TRM->(EOF())
	dbSelectArea("_TRM") ; dbCloseArea()
	// incluir RESET de ambien tequando passar para Scheduler
	Return
EndIf

dbSelectArea("_TRM")

While !Eof()
	
	// Executa a rotina de envio WF de avalia��o
	U_EnvWFAvalia()
	
	dbSelectArea("_TRM")
	dbSkip()
	
End

dbSelectArea("_TRM")
dbCloseArea()

Return

*---------------------------------------*
* Fun��o respons�vel de disparar o WF   *
*---------------------------------------*
USER Function EnvWFAvalia()
/*
DbSelectArea("SC7")
DbSetOrder(1)
DbSeek(cCodFil+cPed)

DbSelectArea("SA2")
DbSetOrder(1)
DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
*/
/*
If SC7->(FieldPos("C7_NATUREZ")) > 0
	DbSelectArea("SED")
	DbSetOrder(1)
	DbSeek(xFilial("SED")+SC7->C7_NATUREZ)
Endif
*/
cSubject := "Avalia��o de Treinamento : " // + Colocar no nome do curso
cTitHtm := "Solicitacao de Avalia��o de Treinamento"

// Op:=Twfprocess():New("AVAL",cTitHtm)
Op:=Twfprocess():New("AVAL","teste")
Op:NewTask("AVAL","\WORKFLOW\WFAVAL_TRM_FUNCIO.HTM")

oP:cSubject := csubject

Op:oHtml:Valbyname("TREINA", "MATEMATICA FINANCEIRA")
Op:oHtml:Valbyname("INSTRUTOR", "JOSE DA SILVA")
//Op:oHtml:Valbyname("INSTRUTOR", "JOSE DA SILVA")

/*
//Op:oHtml:Valbyname("obs", "TEST OBSERVACAO")
Op:oHtml:Valbyname("Qst1_Op1", "OP��O 1")
ALERT(Op:oHtml:RetByName("Qst1_Op1"))
*/
//oP:oHtml:ValByName( "CHAVE", amails[i,4]  )
//Montaemail()


/*
DbSelectArea("SCR")
DbGoto(aMails[i,3])
Reclock("SCR",.F.)
SCR->CR_WF := "S"
msunlock()
*/

oP:bReturn  := "U_WFRetAval()"  // Funcao que ira ser disparada no retorno do e-mail

// oP:cTo      := "flucher@fqm.com.br"
oP:cTo      := "jose.guimaraes@gefco.com.br;flucher@fqm.com.br;wanderley.andrade@akhilleus.com.br"
oP:Start()

Return