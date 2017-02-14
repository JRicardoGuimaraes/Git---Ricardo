#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "TopConn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT150ROT  ºAutora ³Viviane Marta       º Data ³  03/05/07    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para inclusão de novos itens no menu aRotinaº±±
±±º          ³O programa tem como objetivo enviar email para os fornecs.   º±±
±±º          ³com os itens a serem cotados.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³COMPRAS - ATUALIZA COTACOES. MATA160                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


*------------------------------------------*
User Function MT150ROT
*------------------------------------------*


aADD(aRotina,{"Enviar E-mail"  ,"U_fMontaEmail()",0,2})
aADD(aRotina,{"Enviar Mapa"  ,"U_GEFR014()",0,2})


Return (aRotina)

*---------------------------------------------------*
User Function fMontaEmail()             
*Funcao responsavel por montar os dados do corpo do e-mail
*---------------------------------------------------*

Private cFornece := ""
Private cLoja    := ""
Private cNumCot  := ""
Private cItem	  := ""
Private cUnidade := ""
Private nQuant   := 0 
Private cAreaFor := ""
Private cTel	  := ""
Private a_Area   := GetArea()
Private lGrava   := .F.
Private cAssina  := space(60)
Private cEnd	  := ""
Private cBairro  := ""
Private cMun     := ""
Private cValida  := ""


@ 1,1 to 100,300 Dialog oDlg Title "Assinatura"
@ 05,05 Say "Assinatura:" COLOR 255
@ 05,40 Get cAssina  size 110,10 
@ 30,05 BMPBUTTON TYPE 1 ACTION Eval({|| lGrava := .T., Close(oDlg)})
@ 30,50 BMPBUTTON TYPE 2 ACTION Eval({|| lGrava := .F., Close(oDlg)})
	
	Activate Dialog oDlg Centered
	
If lGrava                      
   
   If empty(cAssina)
  		   Aviso("AVISO!","O e-mail será enviado sem assinatura.",{"OK"}) 
   EndIf
  
Else
   Aviso("AVISO!","O e-mail será enviado sem assinatura.",{"OK"}) 

Endif



cNumCot:= SC8->C8_NUM

While !SC8->(Eof()) .and. SC8->C8_NUM = cNumCot
	cFornece := SC8->C8_FORNECE
	cLoja    := SC8->C8_LOJA
	
	

   cItens := "<table border='3' width='100%' bgcolor='#FFFFFF'  bordercolor='#DFEFFF' >"
	cItens += "<Tr><Th bgcolor=#f7f7f7 ALIGN='LEFT'> Item</Th><Th bgcolor=#f7f7f7 ALIGN='LEFT'>Produto</Th><Th bgcolor=#f7f7f7 ALIGN='LEFT'> Descrição</Th><Th bgcolor=#f7f7f7 ALIGN='LEFT'> Unidade</Th><Th bgcolor=#f7f7f7 ALIGN='RIGHT'>Quantidade </Th></Tr>" 
	
    
	nPos:= 1
	
	While !SC8->(Eof()) .AND. cFornece = SC8->C8_FORNECE .AND. cLoja = SC8->C8_LOJA
		cValida := SC8->C8_VALIDA
		dbSelectArea("SA2")//Busca Informacoes cadastrais no Cad.de Fornecedores
		dbSetOrder(1)
		If dbSeek(xFilial("SA2") + cFornece + cLoja)
			cEmail      := alltrim(SA2->A2_EMAIL)
			cAreaFor    := ALLTRIM(SA2->A2_DEPTO )
			cTel        := ALLTRIM(SA2->A2_TEL)
			cDescFor    := ALLTRIM(SA2->A2_NOME)
			cFornecedor := ALLTRIM(SA2->A2_COD)
			cNomeCont   := ALLTRIM(SA2->A2_CONTATO)
			cEnd			:= ALLTRIM(SA2->A2_END)
			cBairro		:= ALLTRIM(SA2->A2_BAIRRO)
			cMun			:= ALLTRIM(SA2->A2_MUN)
		EndIf
		
		dbSelectArea("SC8")
		
		cItem      := SC8->C8_ITEM
		cProduto   := SC8->C8_PRODUTO
		
		DbSelectArea("SB1")//Busca a Descricao do Produto
		DbSetOrder(1)
		If dbSeek(xFilial("SB1") + cProduto)
			cDescricao := SB1->B1_DESC + " - " + AllTrim(SC8->C8_OBS)
		EndIf
		
		dbSelectArea("SC8")				
		nQuant	  := Transform(SC8->C8_QUANT,"@E 999999999.99")                              
		cUnidade   := SC8->C8_UM
		
		cItens += "<Tr><Td ALIGN='LEFT'font face='Times New Roman' size=3 >"+cItem+"</Td><Td ALIGN='LEFT' font face='Times New Roman' size=3 >"+cProduto+"</Td><Td ALIGN='LEFT' font face='Times New Roman' size=3 >"+cDescricao+"</Td><Td ALIGN='LEFT' font face='Times New Roman' size=3>"+cUnidade+"</Td><Td ALIGN='RIGHT' font face='Times New Roman' size=3 >"+nQuant+"</Td></Tr><br> "

		dbSelectArea("SC8")
		SC8->(dbSkip())
		nPos++
	EndDo
	
	cItens+="</TABLE>
	
	U_fxEnviamail(cEmail)
	
EndDo

Aviso("AVISO!","E-mail enviado com sucesso!",{"OK"})

RestArea(a_Area)

Return

*-----------------------------------------------------------------------------------------------*
User Function fxEnviamail(cEmail)
*Funcao Responsavel por enviar os e-mails aos fornecedores3
* O campo A2_EMAIL devera estar devidamente preenchido, assim como os parametros utilizados pelo programa
*-----------------------------------------------------------------------------------------------*


Local cBody       := ""

Local _cServer    := GETMV("MV_RELSERV")       // servidor smtp
Local _cUser      := GETMV("MV_RELACNT")      // usuário para autenticação
Local _cPass      := GETMV("MV_RELAPSW")      // senha para autenticação
Local _cFrom      := "Solicitacao de Cotação GEFCO" // remetente do e-mail
Local _cTo        := cEmail                   //Destinatario do e-mail
Local _cCC        := ""                       // destinatário com cópia
Local _cBCC       := ""                       // destinatário com cópia oculta
Local _cSubject   := "Solicitacao de Cotação GEFCO" // titulo (assunto) do e-mail
Local _lResult    := .F.                      // resultado de uma conexão ou envio
Local _cError     := ""
Local cArqTxt     := "\HTML\Cotacao.Htm"      // Local do Modelo HTML (Protheus_Data\...)
Local nHdl        := fOpen(cArqTxt,68)
Local _cDe        := Trim(GetMV("MV_RELFROM")) // alltrim(MV_PAR13)//"GEFCO - PEDIDO DE COMPRAS"
Local _cAnexo	  := ""

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
	Return
Endif

nBtLidos := fRead(nHdl,@cBody,99999)

fClose(nHdl)
//cBody := StrTran(cBody,"*Caminho*","\\mpxserverrj01\Protheus8\Protheus_Data\HTML\Logo1.jpg")         //caminho do LogoTipo
//cBody := StrTran(cBody,"*Caminho2*","\\mpxserverrj01\Protheus8\Protheus_Data\HTML\Logo.jpg")

cBody := StrTran(cBody,"*CodFor*",cFornecedor)  //Codigo do Fornecedor
cBody := StrTran(cBody,"*Nome*",cDescFor)      //Descricao do Fornecedor 
cBody := StrTran(cBody,"*End*",cEnd)           //Endereco do Fornecedor 
cBody := StrTran(cBody,"*Bairro*",cBairro)     //Endereco do Fornecedor 
cBody := StrTran(cBody,"*Mun*",cMun)           //Endereco do Fornecedor 

cBody := StrTran(cBody,"*NomeCont*",cNomeCont)    //Nome do Contato
cBody := StrTran(cBody,"*Telefone*",ctel)         //No de Telefone
cBody := StrTran(cBody,"*AreaFor*",cAreaFor)      //Area de Contato do Fornecedor
cBody := StrTran(cBody,"*NumCot*",cNumCot)        //Numero da Cotacao
cBody := StrTran(cBody,"*Valida*",dtoc(cValida))        //Data de Validade da Cotacao 
cBody := StrTran(cBody,"*ITENS*",cItens)            //O(s) iten(s) e a(s) Ocorrencia(s)
cBody := StrTran(cBody,"*cAssina*",cAssina)         //O(s) iten(s) e a(s) Ocorrencia(s)

U_EnvEmail(_cDe,_cTo,_cCc,_cSubject,cBody,_cAnexo)		

/*
******************************
// conecta no servidor
CONNECT SMTP SERVER _cServer ACCOUNT _cUser PASSWORD _cPass RESULT _lResult


If !_lResult
	GET MAIL ERROR _cError
	MsgAlert("Erro ao conectar no servidor: " + _cError)
	Return
Endif



// envia e-mail

//aFiles := {"\HTML\Logo1.jpg","\HTML\Logo.jpg"}
SEND MAIL FROM _cFrom TO _cTo SUBJECT _cSubject BODY cBody  RESULT _lResult //   ATTACHMENT aFiles[1],aFiles[2]

If !_lResult
	GET MAIL ERROR _cError
	MsgAlert("Erro ao enviar e-mail: " + _cError)
	Return
Endif
*/
// *** *** *** *** *** *** Fim do envio de E-mail *** *** *** *** ***

Return

 
