#include "rwmake.ch"
#include "tbicode.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#include "ap5mail.ch" 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFW120P	ºAutora ³Viviane Marta       º Data ³  18/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada que dispara o WorkFlow do Pedido de Compra.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³COMPRAS-GEFCO                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


*--------------------------------------------*
User Function WFW120P
*--------------------------------------------*

Private cCodFil := xFilial("SC7")

// GeraWF()

Return

*--------------------------------------------*
Static Function GeraWF()
*--------------------------------------------*

Local i,j
Private cPed := SC7->C7_NUM
Private cCodFil := xFilial("SC7")


aMails := u_AprovSC7(SC7->C7_NUM)

If len(aMails) = 0
	Return
Endif

For i:=1 to len(aMails)
	
	DbSelectArea("SC7")
	DbSetOrder(1)
	DbSeek(cCodFil+cPed)
	
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
	
	If SC7->(FieldPos("C7_NATUREZ")) > 0
		DbSelectArea("SED")
		DbSetOrder(1)
		DbSeek(xFilial("SED")+SC7->C7_NATUREZ)
	Endif
	
	cSubject := "Autorizacao do Pedido de Compra : " + Alltrim(SC7->C7_NUM)
	cTitHtm := "Solicitacao de Aprovacao de Pedido de Compra"
	
	Op:=Twfprocess():New("PEDCOM","Aprovacao de Pedido de Compra")
	
	Op:NewTask("PEDCOM","\HTML\WFPEDCOM.HTM")
	
	Op:oHtml:Valbyname("aprovador"  , amails[i,1])
	oP:oHtml:ValByName( "CHAVE", amails[i,4]  )
	Montaemail()
	
	DbSelectArea("SCR")
	DbGoto(aMails[i,3])
	Reclock("SCR",.F.)
	SCR->CR_WF := "S"
	msunlock()
	
	oP:bReturn  := "U_SC7Return()"  // Funcao que ira ser disparada no retorno do e-mail
	
	oP:cTo      := aMails[i,2]
//	oP:cTo      := "RICARDO"
	oP:Start()
//	cMailId     := oP:Start()
/*	
	Op:NewTask("Link","\HTML\wfLink.HTM")
	Op:oHtml:Valbyname("usuario"   , "RICARDO")
                                                                                                            
	// Defino o Link onde foi gravado o HTML pelo Workflow, abaixo do diretório do usuário definido em cTO do processo acima.
	Op:oHtml:Valbyname("proc_link" , 'http://10.62.160.153:81/Protheus_Data_Prod/messenger/emp' + cEmpAnt + '/RICARDO/' + cMailId + '.htm')
	Op:oHtml:Valbyname("titulo"    , 'Aprovação de Pedido de Compras - Protheus')
	Op:oHtml:Valbyname("referencia", 'Aprovação de Pedido de Compras - Protheus')
	Op:csubject := 'Aprovação de Pedido de Compras - Protheus'

	oP:cTo      := "jose.guimaraes@gefco.com.br"
	oP:Start()
*/	
Next

Return

//**********************************************************************************
//**********************************************************************************
User Function AprovSC7(cPed)
// Posiciona nos registros dos Aprovadores Corrente e retorna os e-mails dos mesmos
//**********************************************************************************
//**********************************************************************************

Local aMails := {}
Private cCodFil := xFilial("SC7")

DbSelectArea("SCR")
DbSetOrder(1)
DbSeek(cCodFil+"PC"+cPed)
While CR_FILIAL+CR_TIPO+CR_NUM = cCodFil+"PC"+cPed .and. .not. Eof()
	If SCR->CR_STATUS="02" .and. SCR->CR_WF = " "
		PswOrder(1)
		PswSeek(SCR->CR_USER,.t.)
		aUser := PswRet(1)
		If aUser[1,14] <> ""
			AADD(amails,{SCR->CR_USER,aUser[1,14],SCR->(Recno()),SCR->CR_APROV})
		Endif
	Endif
	
	DbSelectArea("SCR")
	DbSkip()
End

Return(aMails)



//*******************************************************************************
User Function GradeSCR(cPed)
// Retorna string com tags HTML contendo a lista de aprovadores e seus status
//*******************************************************************************

cnomeaprovs := ""   
Private cCodFil := xFilial("SC7")

DbSelectArea("SCR")
DbSetOrder(1)
DbSeek(xFilial("SCR")+"PC"+cPed)
While CR_FILIAL+CR_TIPO+CR_NUM = cCodFil+"PC"+cPed .and. .not. Eof()
	
	If SCR->CR_STATUS = "01"
		cStatus := "Nivel Bloqueado"
	Elseif SCR->CR_STATUS = "02"
		cStatus := "Aguardando Liberação"
	Elseif SCR->CR_STATUS = "03"
		cStatus := "Aprovado"
	Elseif SCR->CR_STATUS = "04"
		cStatus := "Pedido Bloqueado"
	Elseif SCR->CR_STATUS = "05"
		cStatus := "Nivel Aprovado"
	Endif
	
	/*
	DbSelectArea("SAK")
	DbSetOrder(1)
	DbSeek(xFilial("SAK")+SCR->CR_APROV)
	  */
	  
	c_nome := UsrFullName(SCR->CR_USER)
	  
	//cnomeaprovs += "<tr> <td>" + SAK->AK_NOME + "</td>"

	cnomeaprovs += "<tr> <td>" + c_nome + "</td>"
	cnomeaprovs += "<td>" + cStatus + "</td> </tr>"
	
	DbSelectArea("SCR")
	DbSkip()
End

Return cnomeaprovs



//**********************************************************************************
//**********************************************************************************
// Retorno do Workflow de Compras
User Function SC7Return(oP)
//**********************************************************************************
//**********************************************************************************

Local aArea     := GetArea()
Local cCodApr   := AllTrim(oP:oHtml:RetByName('CHAVE'))
Local cNumSC7   := AllTrim(oP:oHtml:RetByName('pedido'))
Local cCodFil   := AllTrim(oP:oHtml:RetByName('codfil'))  
Local cGrupo    := Posicione("SC7",1,ccodfil+cNumSC7,"C7_APROV")
Local cObs      := oP:oHtml:RetByName('OBS')
Local lMta097   := ExistBlock("MTA097")
Local lLiberou  := .F.
Local cResp     := If(Upper(oP:oHtml:RetByName('rbaprova'))="SIM","S","N")
Local nTotal    := 0
Local lContinua := .F.
Local aTo 		 := {}
Local cNomeUsuario  := oP:oHtml:RetByName('usuario')     
Private cCodFil := xFilial("SC7")

ConOut('Executando Retorno')
ConOut('Pedido: ' + cNumSC7)
ConOut('Aprovador: ' + cCodApr)

cCodUsr := Posicione("SAK",1,cCodFil+cCodApr,"AK_USER")
ConOut('Usuario: ' + cCodUsr)
ConOut('Resp.: ' + cResp)

dbSelectArea("SC7") ; dbSetOrder(1)
dbSeek(cCodfil+cNumSC7)
ConOut('Pedido Posicionado: ' + SC7->C7_NUM)

aTam := TamSX3("CR_NUM")
DbSelectArea("SCR")
DbSetOrder(2)
If DbSeek(cCodfil+'PC'+cNumSC7+Space(aTam[1]-Len(cNumSC7))+cCodUsr)
	
	nTotal := SCR->CR_TOTAL
	
	If lMta097 .And. cResp = 'S'
		If ExecBlock("MTA097",.F.,.F.)
			lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodApr,,cGrupo,,,,,cObs},dDataBase,If(cResp=='S',4,6))
		EndIf
	Else
		lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodApr,,cGrupo,,,,,cObs},dDataBase,If(cResp=='S',4,6))
	EndIf
	
	If lLiberou
		DbSelectArea("SC7")
		While !Eof() .And. (SC7->C7_FILIAL+SC7->C7_NUM == cCodfil+cNumSC7)
			Reclock("SC7",.F.)
			SC7->C7_CONAPRO := "L"
			MsUnlock()
			DbSelectArea("SC7")
			DbSkip()
		EndDo
		ConOut("Pedido Aprovado")

      dbSelectArea("SC7") ; dbSetOrder(1)
      dbSeek(cCodFil+cNumSC7)
		
		Aviso("S",cNomeUsuario)
		
	Elseif !lLiberou .and. cResp = "S"
		DbSelectArea("SCR")
		DbSetOrder(1)
		DbSeek(cCodFil+'PC'+cNumSC7)
		While !Eof() .And. (cCodFil+'PC'+cNumSC7 = AllTrim(SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM))
			If Empty(SCR->CR_DATALIB)
				// Envio novamente para aprovação
				SC7->(dbSeek(cCodFil+cNumSC7))
				GERAWF()
				lContinua := .T.
				Exit
			EndIf
			DbSelectArea("SCR")
			DbSkip()
		End
		ConOut("NAO Aprovado o Pedido")

      dbSelectArea("SC7") ; dbSetOrder(1)
      dbSeek(cCodFil+cNumSC7)
		
		//Aviso("N",cNomeUsuario)
	EndIf
	
Else
	Conout("Aprovadores do pedido " + cNumSC7 + " nao encontrada")
EndIf

ConOut('Termino da Execucao do Retorno')

RestArea(aArea)
Return



                                                   
//**********************************************************************************
//**********************************************************************************
// Envia o aviso de liberacao ou rejeicao do pedido
Static Function Aviso(cAprov,cNomeUsuario)
//**********************************************************************************
//**********************************************************************************
Local c_User := " "
Private cCodFil := xFilial("SC7")
Private cPed := SC7->C7_NUM

cSubject := "Pedido de Compra : " + Alltrim(SC7->C7_NUM) + If(cAprov="S"," Liberado"," Bloqueado")
cTitHtm := "Pedido de Compra : " + Alltrim(SC7->C7_NUM) + If(cAprov="S"," Liberado"," Bloqueado")

CONOUT('PEDIDO DE COMPRA' + Alltrim(SC7->C7_NUM) + If(cAprov="S"," Liberado"," Bloqueado"))

Op:=Twfprocess():New("PEDCOM","Aviso de Pedido de Compra")

Op:NewTask("PEDCOM","\HTML\WFPEDCOM2.HTM")

cNomeUsuario := oP:oHtml:RetByName('usuario')

DbSelectArea("SA2")
DbSetOrder(1)
DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)

Montaemail()

oP:bReturn  := ""  // Funcao que ira ser disparada no retorno do e-mail
 
  
  
DbSelectArea("SC7")// Posiciona no pedido
DbSetOrder(1)
DbSeek(cCodFil+cPed)  

c_User := Substr(Embaralha(SC7->C7_USERLGI,1),1,15) // Busca o nome do Comprador que inseriu o Pedido

PswOrder(2)
PswSeek(c_User,.t.)
aUser := PswRet(1)   
oP:cTo:= aUser[1,14] // Busca o e-mail do comprador que inseriu o pedido para enviar o Html de Retorno



oP:Start()
op:Finish()

Return





//**********************************************************************************
//**********************************************************************************
// Monta o corpo do html.
Static Function Montaemail()
//**********************************************************************************
//**********************************************************************************


//Op:oHtml:Valbyname("usuario"   , Substr(cusuario,7,15))

Op:oHtml:Valbyname("usuario"   , Substr(Embaralha(SC7->C7_USERLGI,1),1,15))


Op:oHtml:Valbyname("TitHtm"    , cTitHtm)

Op:oHtml:Valbyname("pedido"    , SC7->C7_NUM)

Op:oHtml:Valbyname("empresa"   , SM0->M0_NOME)
Op:oHtml:Valbyname("filial"    , SM0->M0_FILIAL)
Op:oHtml:Valbyname("codfil"    , xFilial("SC7"))

Op:oHtml:Valbyname("codforn"   , SC7->C7_FORNECE)
Op:oHtml:Valbyname("lojaforn"  , SC7->C7_LOJA)
Op:oHtml:Valbyname("fornecedor", SA2->A2_NREDUZ)
Op:oHtml:Valbyname("contato"   , SC7->C7_CONTATO)


DbSelectArea("SE4")
DbSetOrder(1)
DbSeek(xFilial("SE4")+SC7->C7_COND)

Op:oHtml:Valbyname("emissao"   , SC7->C7_EMISSAO)
Op:oHtml:Valbyname("condpag"   , SC7->C7_COND + " - " + SE4->E4_DESCRI)
If SC7->(FieldPos("C7_NATUREZ")) > 0
	Op:oHtml:Valbyname("natureza"  , SC7->C7_NATUREZ + " - " + SED->ED_DESCRIC)
Endif

nTotProd := 0
nTotIpi  := 0
nDespesa := 0
nSeguro  := 0
nFrete   := 0

cPed := SC7->C7_NUM

DbSelectArea("SC7")
While SC7->C7_NUM = cPed .and. !SC7->(EOF())//.not. Eof()
	
	AAdd( Op:oHtml:ValByName( "it.cod"   ) , SC7->C7_PRODUTO)
	AAdd( op:oHtml:ValByName( "it.desc"  ) , SC7->C7_DESCRI)
	AAdd( op:oHtml:ValByName( "it.quant" ) , Transform(SC7->C7_QUANT, "@E 999,999.99"))
	AAdd( op:oHtml:ValByName( "it.preco" ) , Transform(SC7->C7_PRECO, "@E 999,999.99"))
	AAdd( op:oHtml:ValByName( "it.ipi"   ) , Alltrim(Str(SC7->C7_IPI)) + "%" )
	AAdd( op:oHtml:ValByName( "it.total" ) , Transform(SC7->C7_TOTAL, "@E 99,999,999.99"))
	
	nTotProd += SC7->C7_TOTAL
	nTotIPI  += SC7->C7_VALIPI
	nDespesa += SC7->C7_DESPESA
	nSeguro  += SC7->C7_SEGURO
	nFrete   += SC7->C7_VALFRE
	
	dbSelectArea("SC7")
	SC7->(DbSkip())
End

op:oHtml:ValByName( "totprod", Transform(ntotprod, "@E 999,999.99"))
op:oHtml:ValByName( "totipi" , Transform(ntotipi , "@E 999,999.99"))

op:oHtml:ValByName( "vlfrete", Transform(nFrete  , "@E 999,999.99"))
op:oHtml:ValByName( "seguro" , Transform(nSeguro , "@E 999,999.99"))
op:oHtml:ValByName( "despesa", Transform(nDespesa, "@E 999,999.99"))

op:oHtml:ValByName( "totger" , Transform(ntotprod+ntotipi+nFrete+nSeguro+nDespesa, "@E 999,999.99"))

cNomeAprovs := U_GradeSCR(cPed)

Op:oHtml:ValByName( "nomeaprovs"   , cnomeaprovs  )

oP:cSubject := csubject

oP:bTimeOut := {}

Return
