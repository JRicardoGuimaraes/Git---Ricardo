#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
/*
*---------------------------------------------------------------------------*
* Fun��o     |TM200OK   | Autor | J Ricardo             | Data | 10.02.12   *
*---------------------------------------------------------------------------*
* Descri��o  |Ponto de Entreda disparado na rotina de Cancelamento de CTRC. *
*            |PE desenvolvido para n�o permitir cancelar um CTRC do TLA     *
*            |que tenha gerado compra de frete e o mesmo esteja em Fatura   *
*            |                                                              *
*---------------------------------------------------------------------------*
*/            
*--------------------------*    

User Function TM200OK()    
Local _aArea   := GetArea()
Local _lReturn := .T.

If PARAMIXB[1] = 3 // 3-Op��o de Menu Estorno de CTRC
	
	dbSelectArea("DT6") ; dbSetOrder(2)
	If dbSeek(xFilial("DT6")+DTP->DTP_FILORI+DTP->DTP_LOTNFC)
		// Alert("Achou passo 1")
		If Left(DT6->DT6_CCUSTO,3) $ "101|102" // TLA
			Return .T.
		Else   
			// Posiciono na tabela de interface de CTRC - SZ8
			dbSelectArea("SZ8") ; dbSetOrder(1)
			If dbSeek(xFilial("SZ8") + DT6->DT6_DOC + DT6->DT6_SERIE)  
				//Alert("Achou passo 2")
				// Posiciono na Transportadora
				dbSelectArea("SA2") ; dbSetOrder(3)
				If dbSeek(xFilial("SA2") + SZ8->Z8_CNPJTRA)
					// Alert("Achou passo 3")
	   				// Posiciono no t�tulo a pagar ref. compra de frete TLA
					dbSelectArea("SE2") ; dbSetOrder(6)  // Filial + Fornecedor + Loja + Prefixo + Titulo 
					If dbSeek(xFilial("SE2") + SA2->A2_COD + SA2->A2_LOJA + DT6->DT6_PREFIX + DT6->DT6_DOC)
						//Alert("Achou passo 4")
						// Verifico se o t�tulo j� foi baixao e/ou aglutinado em fatura
						If !Empty(SE2->E2_FATURA) .OR. !Empty(SE2->E2_BAIXA)
							MsgInfo("O t�tulo " + DT6->DT6_DOC + " do lote " + DT6->DT6_LOTNFC + " ref. compra de frete TLA " +CHR(13)+;
							    "encontra-se aglutinado na Fatura " + SE2->E2_FATURA)
							Return .F.
						EndIf
					EndIf
				EndIf	
			EndIf
		EndIf
	EndIf
Else 
	_lReturn := fMotVeic("", "")  // Fun��o de verifica��o de Motorista e Ve�culos

EndIf

RestArea(_aArea)

Return _lReturn
*----------------------------------------------------------------------------*

*----------------------------------------------------------------------------*
* Usada para ser chamada em outroas rotinas                                  *
*----------------------------------------------------------------------------*
USER FUNCTION DadosViagem(_cMsg, _cMsg2)
Local _lReturn := .T.

_lReturn := fMotVeic(_cMsg, _cMsg2)
	
Return _lReturn
*----------------------------------------------------------------------------*
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �TM200OK   � Autor � Katia Alves Bianchi   � Data �14.06.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �verifica se o veiculo e motorista foram informados          ���
���          �quando o lote possuir um devedor                            ���
�������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/   
Static Function fMotVeic(_cMsg, _cMsg2) 
Local _aAreaAtu	:= GetArea()
Local _cAliasTrb	:= GetNextAlias()
Local _cQuery		:= ""
Local _lRetorno	:= .F.
Local _nCount		:= 0

Private _cCodMot := Space(TamSx3("DUP_CODMOT")[1])
Private _cCodVei := Space(TamSx3("DTR_CODVEI")[1])
Private _cCodRB1 := Space(TamSx3("DTR_CODRB1")[1])
Private _cCodRB2 := Space(TamSx3("DTR_CODRB2")[1])
Private _cNomMot := Space(TamSx3("DA4_NOME")[1])
Private _cPlacaVei := Space(TamSx3("DA3_PLACA")[1])
Private _cPlacaRB1 := Space(TamSx3("DA3_PLACA")[1])
Private _cPlacaRB2 := Space(TamSx3("DA3_PLACA")[1])

If !('TMSA500'$FunName())
	If Empty(DTP->DTP_CODMOT) .OR. Empty(DTP->DTP_CODVEI) 
		_cQuery := " SELECT DTC_CLIDEV, DTC_LOJDEV "
		_cQuery += " FROM " + RetSqlName("DTC")  + " DTC"
		_cQuery += " WHERE DTC_FILIAL     = '" +xFilial("DTC") + "'"
		_cQuery += "   AND DTC.D_E_L_E_T_ = ' '"
		_cQuery += "   AND DTC_FILORI     = '" +DTP->DTP_FILORI+ "'"
		_cQuery += "   AND DTC_LOTNFC     = '" +DTP->DTP_LOTNFC+ "'"
		_cQuery += " GROUP BY DTC_CLIDEV, DTC_LOJDEV "
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliasTRB,.T.,.T.)
		
		While (_cAliasTRB)->(!Eof())
			_nCount++
			If _nCount>1
				(_cAliasTRB)->(DbCloseArea())
				RestArea(_aAreaAtu)
				Return .T.
			EndIf
			(_cAliasTRB)->(DbSkip())
		EndDo
		//Chamada da tela para o informe dos dados do ve�culo e motorista
		_lRetorno := InfDados(_cMSG, _cMSG2)
		(_cAliasTRB)->(DbCloseArea())
	Else
		_lRetorno := .T.
	EndIf		    
Else
	_lRetorno := .T.  
EndIf

RestArea(_aAreaAtu)
Return _lRetorno
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �InfDados  � Autor � Katia Alves Bianchi   � Data �14.06.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �verifica se o veiculo e motorista foram informados          ���
���          �quando o lote possuir um devedor                            ���
�������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function InfDados(_cMsg, _cMsg2)
Local lRet     := .F.              
Local aArea		:= GetArea()

@ 000,000 TO 220,320 DIALOG _oDlg1 TITLE "Informe os dados da viagem" + IIF(Empty(_cMsg),"", " - " + _cMsg )
// @ 005, 005 to 095, 158

@ 003,011 Get _cMsg2 Size 140, 15 WHEN .F. 
	
@ 009,011 Say OemToAnsi("Motorista: ")
@ 019,011 Get _cCodMot      F3 "DA4" PICTURE "@!"  VALID ExistCpo("DA4")  Size 020, 15 
@ 019,051 Get _cNomMot:=Posicione("DA4",1,xFilial("DA4")+_cCodMot,"DA4_NOME") Size 100,15  PICTURE "@!"  WHEN .F.  
	
@ 042,011 Say OemToAnsi("Veiculo: ")
@ 052,011 Get _cCodVei F3 "DA3" PICTURE "@!"  VALID ExistCpo("DA3")  Size 020, 15 
@ 065,011 Get _cPlacaVei := GetAdvFVal("DA3", "DA3_PLACA", xFilial("DA3")+_cCodVei,1,"" ) Size 020,15  PICTURE "@R XXX-9999"  WHEN .F.  

@ 042,059 Say OemToAnsi("1o. Reboque: ") 
@ 052,059 Get _cCodRB1 F3 "DA3" PICTURE "@!"  VALID ValReboq(_cCodRB1) Size 020, 15
@ 065,059 Get _cPlacaRB1 := GetAdvFVal("DA3", "DA3_PLACA", xFilial("DA3")+_cCodRB1,1,"" ) Size 020,15  PICTURE "@R XXX-9999"  WHEN .F.  

@ 042,106 Say OemToAnsi("2o. Reboque: ") 
@ 052,106 Get _cCodRB2 F3 "DA3" PICTURE "@!"  VALID ValReboq(_cCodRB2)  Size 020, 15
@ 065,106 Get _cPlacaRB2 := GetAdvFVal("DA3", "DA3_PLACA", xFilial("DA3")+_cCodRB2,1,"" ) Size 020,15  PICTURE "@R XXX-9999"  WHEN .F.  


DEFINE SBUTTON FROM 080,125 TYPE 1 ENABLE OF _oDlg1 PIXEL ACTION (If(ValCampo(@lRet),(nOpca:=1,_oDlg1:End()),))
DEFINE SBUTTON FROM 080,095 TYPE 2 ENABLE OF _oDlg1 PIXEL ACTION ( lRet := .F., _oDlg1:End() )
	
ACTIVATE DIALOG _oDlg1 CENTERED
	
If lRet
	RecLock("DTP", .F.)
	DTP->DTP_CODMOT := _cCodMot
	DTP->DTP_CODVEI := _cCodVei
	DTP->DTP_CODRB1 := _cCodRB1
	DTP->DTP_CODRB2 := _cCodRB2
	MsUnlock()
EndIf

RestArea(aArea)
Return  lRet
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ValCampo  � Autor � Katia Alves Bianchi   � Data �14.06.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �verifica se o veiculo e motorista foram informados          ���
���          �quando o lote possuir um devedor                            ���
�������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValCampo(lRet)
Local aArea		:= GetArea()

lRet := .T.

If Empty(_cCodMot)
	lRet:=.F.
	MsgAlert("O c�digo do motorista deve ser preenchido.","Aten�ao!")
ElseIf Empty(_cCodVei) 
	lRet:=.F.
	MsgAlert("O c�digo do ve�culo deve ser preenchido.","Aten�ao!")
Else
	DbSelectArea('DA3')
	DbSetOrder(1)
	If DbSeek(xFilial('DA3')+_cCodVei)
		DbSelectArea('DUT')
		DbSetOrder(1)
		If DbSeek(xFilial('DA3')+DA3->DA3_TIPVEI)
			If DUT->DUT_CATVEI ='2' .AND. Empty(_cCodRB1) 
				lRet:=.F.
				MsgAlert("O c�digo do reboque deve ser preenchido.","Aten�ao!")
			EndIf
		EndIf
	EndIf
EndIf

RestArea(aArea)
Return (lRet)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TM200OK   �Autor  �Microsiga           � Data �  06/30/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValReboq(cReboq)
   
DA3->(dbSetOrder(1))
If DA3->(dbSeek(xFilial("DA3")+cReboq)) .or. Vazio(cReboq)
	Return .t.
Else
	Return .f.
EndIf


