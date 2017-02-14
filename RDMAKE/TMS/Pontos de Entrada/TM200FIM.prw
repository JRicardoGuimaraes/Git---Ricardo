#INCLUDE "TOPCONN.CH"
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TM200FIM  º Autor |Katia Alves Bianchi º Data ³  14/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ O PE TM200Fim grava os campos especificos da tabela DTC    º±±
±±º          ³ para tabela DT6                                            º±±
±±º          ³ Eh acionado pela rotina de Calculo do Frete.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gefco                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------------*
User Function TM200FIM()
*-----------------------------------*
Local cFilDoc 	:= PARAMIXB[1]
Local cDocto  	:= PARAMIXB[2]
Local cSerie  	:= PARAMIXB[3]
Local _aAreaDTC := DTC->(GetArea("DTC"))
Local _cTMSMFAT	:= GETMV("MV_TMSMFAT")
Local _aAreaSE1 := SE1->(GetArea()) 
Local _aAreaDTC := DTC->(GetArea())
Local _aAreaDT8 := DT8->(GetArea())
Local _nVrCompra:= 0  // Valor de compra de Frete do TLA
Local _cCNPJTransp := "" // CNPJ da Transportadora
Local _cProd    := ""
Local _cCompCom := ""
Local _cSQL		:= ""
Local _cPrefixo := ""
Local _cTipoCar := ""
Local _cNumCVA  := ""
Local _cColMon  := ""     

// ---	{@2LGI} - 02/Set./2014
// ---	Variaveis utilizadas
Local	_aArea		:=	GetArea()
Local	_aAreaDT5	:=	DT5->(GetArea())                             
Local	_aAreaDF1	:=	DF1->(GetArea()) 

Private	cCcont	:= PADR(GetMV("MV_GEF006"),TamSX3("DTC_CCONT")[1])//If(Empty(GetMV("MV_GEF006")),Space(TamSX3("DTC_CCONT")[1]),PADR(GetMV("MV_GEF006"),TamSX3("DTC_CCONT")[1]))
Private	cConta	:= If(Empty(GetMV("MV_GEF008")),Space(TamSX3("DTC_CONTA")[1]),PADR(GetMV("MV_GEF008"),TamSX3("DTC_CONTA")[1]))
Private	cOi		:= If(Empty(GetMV("MV_GEF007")),Space(TamSX3("DTC_OI")[1]),PADR(GetMV("MV_GEF007"),TamSX3("DTC_OI")[1]))
Private	cTipDes	:= "O" // Space(TamSX3("DTC_TIPDES")[1])
Private	cRefGef	:= Space(TamSX3("DTC_REFGEF")[1])
Private	cCcusto	:= If(Empty(GetMV("MV_GEF005")),Space(TamSX3("DTC_CCUSTO")[1]),PADR(GetMV("MV_GEF005"),TamSX3("DTC_CCUSTO")[1]))
Private cNotas  := ""

cChave := xFilial("DTC") + cFilDoc + cDocto + cSerie
DbSelectArea( "DTC")
DTC->(DbSetOrder(3))
If DTC->(MSseek(cChave))

	// Por: Ricardo Guimaraes - Em: 17/03/2014 - Objetivo: Informacoes MAN 
	_cTipoCar := DTC->DTC_TPCAR
	_cNumCVA  := DTC->DTC_NUMCVA
	_cColMon  := DTC->DTC_COLMON

//	If DTC->DTC_EDI=='1' .and. 
	If DTC->DTC_EDI=='1' .and. Empty(Alltrim(DTC->DTC_CCUSTO)) .and. ( Empty(Alltrim(cCcont))	.or. Empty(Alltrim(cConta))	.or. Empty(Alltrim(cCcusto)) )
		//cNotas+=DTC->DTC_NUMNFC
		//Função tela para digitacao dos campos especificos
		If Empty(Alltrim(DTC->DTC_CCUSTO)) .AND. Empty(Alltrim(DTC->DTC_CCONT)) .AND. Empty(Alltrim(DTC->DTC_CONTA))
			Tela()               
		EndIf	
	
		cNotas+=DTC->DTC_NUMNFC		
		
		DTC->(MSseek(cChave))
		While !DTC->(Eof()) .And. xFilial("DTC")+DTC->(DTC_FILDOC+DTC_DOC+DTC_SERIE) == cChave
				
			RecLock("DTC",.F.)
			DTC->DTC_CCONT := cCcont
			DTC->DTC_CONTA := cConta
			DTC->DTC_OI    := cOi
			DTC->DTC_TIPDES:= cTipDes
			DTC->DTC_REFGEF:= cRefGef
			DTC->DTC_CCUSTO:= cCcusto
			MsUnlock()
				
			DTC->(dbSkip())
		EndDo
		
		DT6->DT6_CCONT 	:= cCcont
		DT6->DT6_CONTA 	:= cConta
		DT6->DT6_OI		:= cOi
		DT6->DT6_TIPDES := cTipDes
		DT6->DT6_REFGEF := cRefGef
		DT6->DT6_CCUSTO := cCcusto		
	Else
		DT6->DT6_CCONT 	:= DTC->DTC_CCONT
		DT6->DT6_CONTA 	:= DTC->DTC_CONTA
		DT6->DT6_OI		:= DTC->DTC_OI
		DT6->DT6_TIPDES 	:= DTC->DTC_TIPDES
		DT6->DT6_REFGEF 	:= DTC->DTC_REFGEF
		DT6->DT6_CCUSTO 	:= DTC->DTC_CCUSTO
	EndIf	

	/*	
	Else
		DT6->DT6_CCONT 	:= DTC->DTC_CCONT
		DT6->DT6_CONTA 	:= DTC->DTC_CONTA
		DT6->DT6_OI		:= DTC->DTC_OI
		DT6->DT6_TIPDES := DTC->DTC_TIPDES
		DT6->DT6_REFGEF := DTC->DTC_REFGEF
		DT6->DT6_CCUSTO := DTC->DTC_CCUSTO
	EndIf
	*/
Else
	If DT6->DT6_DOCTMS == "J"
		DT6->DT6_CCUSTO := DIK->DIK_CCUSTO		
	EndIf
EndIf

// Pego o valor de compra do Frete do CTRC do TLA e gravo no financeiro
If SubStr(DT6->DT6_CCUSTO,1,3) $ GetNewPar("MV_XTLACC","101|102")

	dbSelectArea("DT8") ; dbSetOrder(2) // Fil.Doc+No.Docto+Série Docto+Produto+Componente
	_cProd 		:= PadR(AllTrim(GETMV("MV_XPROTLA")),(TamSX3("DT8_CODPRO")[1]))
	_cCompCom 	:= AllTrim(GETMV("MV_XTLACOM"))  // Componentes de compra de frete (CT, I3, TP, I2)
	_cSQL		:= ""

	// Por: Ricardo Guimarães - Em: 25/04/2012 - Passou a considerar a pedágio no valor de compra de frete
	_cSQL := " SELECT SUM(DT8_VALPAS) AS DT8_VALPAS FROM " + RetSqlName("DT8") + " DT8 "
	_cSQL += "  WHERE DT8_FILIAL = '" + xFilial("DT8")  + "' "
	_cSQL += "    AND DT8_FILDOC = '" + DT6->DT6_FILDOC + "' " 
	_cSQL += "    AND DT8_DOC    = '" + DT6->DT6_DOC    + "' "
	_cSQL += "    AND DT8_SERIE  = '" + DT6->DT6_SERIE  + "' "
	_cSQL += "    AND DT8_CODPAS IN " + _cCompCom
	
	If Select("TDT8") > 0
		dbSelectArea("TDT8")
		dbCloseArea()
	EndIf
	
	cQuery := ChangeQuery(_cSQL)
	DbUseArea(.T.,"TOPCONN",TCGenQry(,,_cSQL),"TDT8",.T.,.T.)

	DbSelectArea("TDT8")
	TDT8->(DbGoTop())
	
	If !TDT8->(Eof())
		_nVrCompra := TDT8->DT8_VALPAS
	EndIf
	
	TDT8->(dbCloseArea())

	// Gravar informações do CTRC(TLA) que acabou de ser gerado na tabela SZ8
	dbSelectArea("SZ8") ; dbSetOrder(2) // Filial+Lote+CTRC+Serie
	If dbSeek(xFilial("SZ8")+DT6->DT6_LOTNFC)

		_cCNPJTransp := SZ8->Z8_CNPJTRA
		
		SZ8->(RecLock("SZ8",.F.))
			SZ8->Z8_NUMCTRC := DT6->DT6_DOC
			SZ8->Z8_SERCTRC := DT6->DT6_SERIE
			SZ8->Z8_DTEMIS  := DT6->DT6_DATEMI
			SZ8->Z8_STATUS  := "01"
			SZ8->Z8_VENDA   := DT6->DT6_VALFRE
			SZ8->Z8_COMPRA  := _nVrCompra
		MSUnLock()
		
		*----------------------------------------------------------------------*
		* Gera provisão de Compra de Frete TLA - Somente CTRC´s Automáticos    *
		*----------------------------------------------------------------------*		
		// U_GEFM079(.F., DT6->DT6_TRANSP, DT6->DT6_LJTRA, _nVrCompra)    
	Else
		// Por: Ricardo Guimarães - Em: 14/11/2013
		// CTRC Manual -   
		// Pego a transportadora		
		dbSelectArea("DA3") ; dbSetOrder(1)
		If dbSeek(xFilial("DA3") + DTP->DTP_CODVEI )
			_cCNPJTransp := POSICIONE("SA2",1,xFilial("SA2")+DA3->DA3_CODFOR + DA3->DA3_LOJFOR,"A2_CGC")
		EndIf
		dbSelectArea("DT6")
	EndIf

		
	//EndIf

	// Por: Ricardo Guimarães - Em: 05/02/2013
	// CTRC Manual/Automática - Passou a tratar todos os CTRC´s do TLA
	*----------------------------------------------------------------*
	* Gera provisão de Compra de Frete TLA                           *
	*----------------------------------------------------------------*		
	U_GEFM079(NIL, DTC->DTC_TRANSP, DTC->DTC_LJTRA, _nVrCompra, DT6->DT6_CCUSTO)

EndIf

If AllTrim(_cTMSMFAT) == "1"
	SE1->(DbSetOrder(2))
//	If SE1->(MsSeek(xFilial("SE1")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV+DT6->DT6_PREFIX+DT6->DT6_DOC))
	If SE1->(MsSeek(xFilial("SE1")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV+SF2->F2_PREFIXO+DT6->DT6_DOC))
		                            
		
		// Por: Ricardo - Em: 17/07/2013
		// Objetivo: Como o parametro MV_1DUPREF não atende adequadamente a regra para pegar o CC, no momento do cálculo,
		//           quando a filial operam em diversos modais ( FVL / OVL / OVS ), então tive que fazer este artifício
		_cPrefixo := SF2->F2_PREFIXO
		If cFilAnt $ FORMULA("MOD") // .AND. SubStr(AllTrim(DT6->DT6_CCUSTO),1,3) $ "101|102"
			_cPrefixo := &(GETMV("MV_1DUPREF"))  //IIF(cFilAnt="03","CTV","CTA")
		EndIf	
		
	    RECLOCK("SE1",.F.)
	    // SE1->E1_NATUREZ := POSICIONE("DC5",1,xFilial("DC5")+DT6->DT6_SERVIC,"DC5_NATURE")
		SE1->E1_CCONT := AllTrim(DT6->DT6_CCUSTO)
		SE1->E1_CCPSA := AllTrim(DT6->DT6_CCONT)
		SE1->E1_OIPSA := AllTrim(DT6->DT6_OI)
		SE1->E1_CTAPSA := AllTrim(DT6->DT6_CONTA)
		SE1->E1_TPDESP := AllTrim(DT6->DT6_TIPDES)
		SE1->E1_REFGEF := AllTrim(DT6->DT6_REFGEF)
		SE1->E1_VRFRETE:= _nVrCompra
		// SE1->E1_TRANSP := _cCNPJTransp
		SE1->E1_TRANSP := POSICIONE("SA2",1,xFilial("SA2")+DTC->DTC_TRANSP+DTC->DTC_LJTRA,"A2_CGC")
		SE1->E1_PREFIXO:= _cPrefixo

		// Por: Ricardo Guimaraes - Em: 17/03/2014 - Objetivo: Informacoes MAN 		
		SE1->E1_TPCAR  := _cTipoCar 
		SE1->E1_NUMCVA := _cNumCVA  
		SE1->E1_COLMON := _cColMon  
			
		SE1->(MsUnlock())
		
		// Na validacao do Protheus 11 o mesmo estava gravando FAT
		DT6->(RECLOCK("DT6",.F.))
			DT6->DT6_PREFIX := _cPrefixo  // SE1->E1_PREFIXO
			DT6->DT6_TIPO	:= SE1->E1_TIPO
		DT6->(MsUnlock())	
		
		SF2->(RecLock("SF2"))
			SF2->F2_PREFIXO := _cPrefixo
		SF2->(MsUnLock())
		
	EndIF
EndIf

DT8->(RestArea(_aAreaDT8))
SE1->(RestArea(_aAreaSE1))

//-------------------------------------------------------------------------------------------------
/* {2LGI} 
@autor		: Luiz Alexandre
@since		: Ago./2014
@using		: Interface CNH
@review		:
*/
//-------------------------------------------------------------------------------------------------
             

// ---	Se foi preenchida solicitacao de coleta
If ! Empty (DTC->DTC_NUMSOL)                   

	// ---	Localiza solicitacao de coleta.	
	DT5->(dbSetOrder(1))
	DT5->(dbSeek(xFilial('DT5')+DTC->DTC_FILORI+DTC->DTC_NUMSOL))  
	
	// ---	Localiza agentamento a partir da solicitacao de coleta	
	DF1->(dbSetOrder(3))
	If DF1->(dbSeek(xFilial('DF1')+DT5->DT5_FILDOC+DT5->DT5_DOC+DT5->DT5_SERIE)) 
	                   
		RecLock('DT6',.f.)
		// ---	Grava codigo do agendamento e item
		DT6->DT6_NUMAGD	:= 	DF1->DF1_NUMAGE
		DT6->DT6_ITEAGD	:=	DF1->DF1_ITEAGE 
		DT6->(msUnLock())
	
    EndIf

EndIf 

// ---	Restaura area de trabalho
RestArea(_aArea)
RestArea(_aAreaDT5)
RestArea(_aAreaDF1) 
DTC->(RestArea(_aAreaDTC))

Return

#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Tela      |Autor  |   Katia Alves Bianchi ³ Data ³ 14.05.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela para informar os campos especificos tabelas dtc e dt6 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .t. ou .f.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gefco                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tela()

Local oDlg, oCbx
Local lRet      := .F.
Local aComboBx1	:= {"1=Importacao","2=Exportacao","3=Outros"}

DEFINE MSDIALOG oDlg TITLE "Geração CTRC" FROM 0,0 TO 200,400 PIXEL
@ 012,010 Say OemToAnsi("Cnt.Despesa: ")
@ 012,045 msGet cConta F3 "SZF" Size 050,008 of oDlg PICTURE "@!"  Pixel VALID existcpo("SZF")
@ 012,098 Say OemToAnsi("C.Custo PSA: ")
@ 012,131 msGet cCCont F3 "SZG" Size 050,008 of oDlg PICTURE "@!"  Pixel VALID Existcpo("SZG")
@ 030,010 Say OemToAnsi("Ord.Interna: ")
@ 030,045 msGet cOi F3 "SZH" Size 050,008 of oDlg PICTURE "@!"  Pixel VALID Existcpo("SZH")
@ 030,098 Say OemToAnsi("C.C. Gefco: ")
@ 030,131 msGet cCCusto F3 "CTT" Size 050,008 of oDlg PICTURE "@!"  Pixel VALID Existcpo("CTT")
@ 048,010 Say OemToAnsi("Tipo Despesa: ")
@ 048,045 ComboBox cTipDes SIZE 050,008 ITEMS aComboBx1 PIXEL
@ 048,098 Say OemToAnsi("Ref. Gefco: ")
@ 048,131 msGet cRefGef Size 050,008 of oDlg PICTURE "@!"  Pixel 
@ 066,010 Say OemToAnsi("Referente Nota: "+cNotas)

DEFINE SBUTTON FROM 084,152 TYPE 1 ENABLE OF oDlg PIXEL ACTION ( lRet := .T., oDlg:End() )
//DEFINE SBUTTON FROM 076,152 TYPE 2 ENABLE OF oDlg PIXEL ACTION ( lRet := .F., oDlg:End() )
ACTIVATE MSDIALOG oDlg VALID Valida() CENTERED

Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidCanc ºAutor  ³Katia Alves Bianchi º Data ³  17/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação dos campos de historico cancelamento              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Valida()

Local _lRetorno:=.T.
Local cCodPsa   := Alltrim(GetMv("MV_GEF003",,""))

If Alltrim(DT6->DT6_CLIDEV) $ cCodPsa
	DbSelectArea("SZI")
	DbSetorder(1)
	If EMPTY(Alltrim(cCONTA))
		_lRetorno := .F.
		Aviso("Atencao","O campo Cnt.Despesa deve ser preenchido quando o cliente devedor for a PSA!",{"Continuar"})
	ElseIf EMPTY(Alltrim(cCCONT))
		_lRetorno := .F.
		Aviso("Atencao","O campo C.Custo PSA deve ser preenchido quando o cliente devedor for a PSA!",{"Continuar"})
	/*	
	ElseIf !Dbseek(xFilial("SZI")+cCCONT+cCONTA+cOI)
		Aviso("Atencao","Os campos C.Custo PSA,Cnt.Despesa e Ord.Interna nãi foram encontrados na tabela SZI!",{"Continuar"})
		_lRetorno := .F.
	*/	
	Endif
EndIf
If _lRetorno
	If EMPTY(Alltrim(cTipDes))
		_lRetorno := .F.
		Aviso("Atencao","O campo tipo Despesa deve ser preenchido!",{"Continuar"})
	ElseIf EMPTY(Alltrim(cCCusto))
		_lRetorno := .F.
		Aviso("Atencao","O campo C.Custo Gefco deve ser preenchido!",{"Continuar"})
	EndIf
EndIf    

If _lRetorno  //Se o retorno for verdadeiro atualizar os parâmetros com o conteudo informado pelo usuário
	PutMv("MV_GEF005",cCCusto) //Atualiza o parametro
	PutMv("MV_GEF006",cCCONT) //Atualiza o parametro
	PutMv("MV_GEF007",cOI) //Atualiza o parametro
	PutMv("MV_GEF008",cCONTA) //Atualiza o parametro
EndIf

Return (_lRetorno)
