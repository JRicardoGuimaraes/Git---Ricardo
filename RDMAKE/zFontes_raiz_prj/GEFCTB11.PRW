#include "rwmake.ch"
#include "tbiconn.ch"
#include 'Ap5Mail.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEFCTB11  º Autor ³  Saulo             º Data ³  06/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ HISTORIQUE AUTOMATICO                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER FUNCTION GEFCTB11()

Local cDir,cTes,cCond,cProd
Local cCta,cCC,cItemCta,cClas,cNat,cRecebe
Local aFiles, nFiles, nI
Local cBuffer  := ""
Local nOpc := 3
Local cUM, cChave, cDocto, cSerie, cFornec, cLoja, dEmissao, lOk, cNewArq
Local nValorTotal, nPercentualICMS, nBaseICMS, nValorICMS
Local cNatFor, cArq
Local aLinha:={}, aItens:={}

Private cServer,cAccount,cPassword
Private lMsErroAuto := .F.
Private CRLF := Chr(13) + Chr(10)
Private lFirstLog := .T.
Private lTemLog := .F.


PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "CTB" TABLES ;
"SB1","SE4","SF4","CT1","CT2","CTT","CT3","CTD","SID","CTH","SED","SA2","SF1"

ConOut("")
ConOut("Inicio da Geração dos Arquivos Historique " + Dtoc( MsDate() ) + " - " + Time() )
ConOut("")

cDir      := AllTrim(GETMV("MV_CTRDIR"))
cRecebe   := "helena.nascimento@gefco.com.br"  // "sergio.losada@gefco.com.br" AllTrim(GETMV("MV_CTRMAIL")) // email do destinatario da mensagem
cServer   := Trim(GetMV("MV_RELSERV")) // smtp.ig.com.br ou 200.181.100.51
cAccount  := Trim(GetMV("MV_RELACNT")) // fulano@ig.com.br
cPassword := Trim(GetMV("MV_RELPSW"))  // 123abc
xAuto     := .T.

// PROCESSO AUTOMATICO
   U_GEFCTB08(xAuto)


RESET ENVIRONMENT

ConOut("")
ConOut("Gerando email : Aguarde ... ")
ConOut("")

//If lTemLog
	Email(cRecebe)
//Endif

ConOut("")
ConOut("Fim da Geração dos Arquivos Historique " + Dtoc( MsDate() ) + " - " + Time() )
ConOut("")

//StopFreight()

Return .t.


STATIC FUNCTION WLog(cMensagem)

LOCAL cFileLog := ""
LOCAL cPath := ""

If lFirstLog
	
	AutoGrLog(" ")
	AutoGrLog("LOG DE IMPORTACAO DE Conhecimento de frete")
	AutoGrLog("------------------------------------------")
	AutoGrLog("ARQUIVO DE LOG.....: "+NomeAutoLog())
	AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
	AutoGrLog("DATA...............: "+Dtoc(MsDate()))
	AutoGrLog("HORA...............: "+Time())
	AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
	AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath",""))
	AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath",""))
	AutoGrLog("VERSÃO.............: "+GetVersao())
	AutoGrLog("MÓDULO.............: "+"SIGA"+cModulo)
	AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
	AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
	AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
	AutoGrLog("USUÁRIO............: "+SubStr(cUsuario,7,15))
	AutoGrLog(" ")
	
	lFirstLog := .F.
	
Endif

AutoGrLog(cMensagem)
ConOut(cMensagem)
lTemLog := .T.

RETURN


STATIC FUNCTION Email(cRecebe)

Local lConectou, lEnviado
//Local cAnexo := GetSrvProfString("Startpath","")+NomeAutoLog()
//@ 49,269 BUTTON "..." SIZE 13,11 PIXEL OF oDlg ACTION cAnexo:=AllTrim(cGetFile(cMask,"Inserir anexo"))
//ATTACHMENT "\ENVIAR\ARQUIVO.TXT", "\ENVIAR\ARQ02.TXT"
//cAnexo := AllTrim(cGetFile("HistLog.txt"))
cMensagem := 'Favor verificar arquivo de log de importacao de ' + CRLF +;
'Geração do Historique '+" "+Dtoc(MsDate())

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

If !lConectou
//	WLog("Nao consegui conectar com o server para envio de e-mail")
    ConOut("")
    ConOut("Nao consegui conectar com o server para envio de e-mail" + Dtoc( MsDate() ) + " - " + Time() )
    ConOut("")

	Return
Endif

/*
SEND MAIL FROM cAccount;
TO cRecebe;
SUBJECT 'Workflow - Geração do Historique ' ;
BODY cMensagem ;
RESULT lEnviado
*/

/*
_cBody := "<img border='0' src='http://www.gefco.com.br/lgrl.bmp'><p>"
_cBody += "<FONT face=Arial size=2><b> Historique Pocessado em : " + Dtoc( MsDate() ) + " - " + Time() ) + "</B></font><BR><BR>"
_cBody += "<FONT face=Arial size=2><b><i>Representante:</i></B></font><BR>"  
_cBody += "<FONT face=Arial size=2><b>" + _cVendCod +" - "+  _cVendNome +"</B></font><BR>"  
_cBody += "<FONT face=Arial size=2><B>" +_cVendTelFax + "Cel:" +  _cCPICEL +"</B></font><BR>"
_cBody += "<FONT face=Arial size=2><B>e-mail:" + _cVendEmail +"</B></font><BR><BR>"
_cBody += "<FONT face=Arial size=2><b><i>Cliente:</i></B></font><BR>"
_cBody += "<FONT face=Arial size=2><b>" + SA1->A1_COD + " - " +SA1->A1_NOME + "</B></font><BR><BR>"
_cBody += "<table border='1' align='center' cellpadding='1' cellspacing='0' bordercolor='#111111' width='100%'> "
_cBody += " <tr>"
_cBody += "   <td align='center' width='06%' bgcolor='#CCCCCC'> "
_cBody += "   <font size='2' face='Arial'><b>Item</b></font></td>"
_cBody += "   <td align='center' width='14%' bgcolor='#CCCCCC'>"
_cBody += "   <font size='2' face='Arial'><b>Código</b></font></td>"
_cBody += "   <td align='center' width='32%' bgcolor='#CCCCCC'>"
_cBody += "   <font size='2' face='Arial'><b>Descrição </b></font></td>"
_cBody += "   <td align='center' width='04%' bgcolor='#CCCCCC'>"
_cBody += "   <font size='2' face='Arial'><b>UM</b></font></td>"
_cBody += "   <td align='center' width='10%' bgcolor='#CCCCCC'>"
_cBody += "   <font size='2' face='Arial'><b>Quantidade</b></font></td>"
_cBody += "   <td align='center' width='10%' bgcolor='#CCCCCC'>"
_cBody += "   <font size='2' face='Arial'><b>Valor Unit.</b></font></td>"
_cBody += "   <td align='center' width='10%' bgcolor='#CCCCCC'>"
_cBody += "   <font size='2' face='Arial'><b>Valor Total</b></font></td>"
_cBody += "   <td align='center' width='14%' bgcolor='#CCCCCC'>"         
_cBody += "   <font size='2' face='Arial'><b>Data Faturamento</b></font></td>"
_cBody += "</tr>"
_cBody += cItens
_cBody += "</table> <br>"
_cBody += "<FONT face=Arial size=2><b>Valor total do pedido: R$" + Transform(_ntotal,"@E 99,999,999.99") + "</b> </font><BR>"
_cBody += "<BR> <FONT face=Arial size=2><b> Condições Comerciais:</b></font><BR> "
_cBody += "<FONT face=Arial size=2><b>Pagamento :</b> " + SE4->E4_DESCRI + "</font><BR>"
_cBody += "<FONT face=Arial size=2><b>Transportadora :</b> " + _cTransp + "</font><BR>"
_cBody += "<FONT face=Arial size=2><b>Cadastrado por :</b> " + cLiberado + "</font><BR>" // Liberado por quem.
_cBody += "<FONT face=Arial size=3><b>Observação:</b> " + _cMsgNF + "</font><BR>"
*/


SEND MAIL FROM cAccount;
TO cRecebe;
SUBJECT 'Workflow - Geração do Historique ' ;
BODY _cBody ;
ATTACHMENT "\ENVIAR\HISTLOG.TXT" ;  //cAnexo;  // REMOVIDO
RESULT lEnviado

If !lEnviado
	GET MAIL ERROR cMensagem
	WLog("Nao consegui enviar o e-mail do log de Geração do Historique"+ CRLF + cMensagem)
Endif
DISCONNECT SMTP SERVER Result lDisConectou

If !lDisConectou
	WLog("Nao consegui desconectar com o servidor de e-mail "+cServer)
Endif

Return

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³StartFreight ³ Autor ³ Marinaldo de Jesus ³ Data ³21/11/2001³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Start do Processo de WorkFlow                               ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³u_StartFreight 		        			³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³															³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Importacao conhecimento de frete                          	³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Observacao³Essa Funcao devera ser Incluida no .INI do Server          	³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
User Function StartFreight()

Local aEmpFil := Array( 02 )

aEmpFil[ 01 ] := "01"	//Codigo da Empresa confome SIGAMAT
aEmpFil[ 02 ] := "01"	//Codigo da Filial  confome SIGAMAT

Return( wfStart( aEmpFil ) )

User Function StopFreight()

Local aEmpFil := Array( 02 )

aEmpFil[ 01 ] := "01"	//Codigo da Empresa confome SIGAMAT
aEmpFil[ 02 ] := "01"	//Codigo da Filial  confome SIGAMAT

Return( wfstop( aEmpFil ) )
