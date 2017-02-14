#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOGCTB    º Autor ³ AP6 IDE            º Data ³  04/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³                                                           º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//
// Tabela SZP  - Registro de Log de Integracao Contabil  ("gravar em Tabela a chamada de lancto Ctb - independente
//                                                         do usuario aceitar ou não (deletar) lancto contabil)
//
// ZP_FILIAL  - Caracter 2  - Filial
// zp_DATE	  - Data	 8  - Data Sistema Operacional
// ZP_DTBASE  - Data     8  - Data Base
// ZP_LANDPAD - Caracter 6  - Codigo e Sequencia Lancamento Padronizado
// ZP_DOCUM	  - Caracter 20 - Dados da tabela a ser contabilizada (Exemplo: 500: SE1, 510: SE2, 610: SD2, 650: SD1)
// ZP_DOCCTB  - Caracter 20 - Lote, sub-lote, documento de Integracao CTB (tela lancto contabil)
// ZP_USERLGI - Log de Inclusao
// 
// Problemas:
//
// 1)Esta rotina deverá receber, de parametros na chamada do Lancamento Padrao 
//
//     Exemplo: U_LOGCTB(PARAMETRO_1,PARAMETRO_2)
//
//      onde       PARAMETRO_1  : "51001"        (identificacao do Lançamento Padrao
//                 PARAMETRO_2  : SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
// 
//      u_logctb("510001",SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE_SE2->E2_LOJA)
//
//                                                                                                             
// 2) Desejavel que se gravado o Lote/Sublote/Doumento apresentado -> quais variaveis (publica/privada)
//    tem a informacao em tempo execucao ????
//  
// U_LOGCTB("500001",SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE) 
//
User Function LOGCTB(param1,param2)
//
_mOldArea	:=	alias()
_mOldRecn	:=	recno()
_mOldInde	:=	Indexord()  
cRet	:=	""
//
DbSelectArea("SZP")
RecLock("SZP",.T.)
SZP->ZP_FILIAL 	:= xFilial("SZP")
SZP->ZP_DATE	:= date()			&& Gravar sempre a data do Sistema Operacional (data real)
SZP->ZP_DTBASE 	:= dDataBase 		&& Gravar sempre a database do sistema
SZP->ZP_LANDPAD := param1			&& Obtem de parametro passado pelo rotina ( ???? Padrao ???? )
SZP->ZP_DOCUM	:= param2           && Obtem de parametros passados pela rotina ( ????? )
//SZP->ZP_DOCCTB	:= CLOTE+" "+CPARCELA	&& Devera obter da rotina de contabilizacao (Lote, SubLote, Doc - em tempo processamento)
MsUnlock()
//
DbSelectArea(_mOldArea)
DbSetOrder(_mOldInde)
DbGoto(_mOldRecn)
//
Return(cRet)
