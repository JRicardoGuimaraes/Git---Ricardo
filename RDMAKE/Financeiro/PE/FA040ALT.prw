#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA040ALT  � Autor � MARCOS FURTADO     � Data �  01/08/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada executado na altera��o do titulo a receber���
���          � com retorno .T. ou .F. . Utilizado para verificar se foi   ���
���          � realizado prorroga��o de t�tulos e grav�-la na tabela SZ6  ���
�������������������������������������������������������������������������͹��
���Uso       � FINANCEIRO                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FA040ALT
Local aArea := GetArea()
Local lRet  := .T.
Local cMsg  := ""
                                    
If AllTrim(FunName()) == 'FINA040'

	cMsg:=u_vldPSA('TODOS')
	If !Empty(cMsg)
	   	APMsgAlert(cMsg)
		return .f.
	EndIf
	
EndIF
	
/*If M->E1_VENCREA <> SE1->E1_VENCREA   
	DbSelectArea("SZ6")
	DbSetOrder(1)
	If !dbSeek(SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+Dtos(dDataBase))
		RecLock("SZ6",.T.)
		SZ6->Z6_FILIAL 	:= SE1->E1_FILIAL
		SZ6->Z6_PREFIXO := SE1->E1_PREFIXO
		SZ6->Z6_NUM		:= SE1->E1_NUM
		SZ6->Z6_PARCELA	:= SE1->E1_PARCELA
		SZ6->Z6_TIPO	:= SE1->E1_TIPO
		SZ6->Z6_CLIENTE	:= SE1->E1_CLIENTE
		SZ6->Z6_LOJA	:= SE1->E1_LOJA
		SZ6->Z6_NOMCLI	:= SE1->E1_NOMCLI
		SZ6->Z6_EMISSAO	:= SE1->E1_EMISSAO
		SZ6->Z6_VENCANT	:= SE1->E1_VENCREA
		SZ6->Z6_VENCREA	:= M->E1_VENCREA
		SZ6->Z6_VALOR	:= SE1->E1_VALOR
		SZ6->Z6_USUARIO	:= cUserName
		SZ6->Z6_DATA	:= dDataBase
		SZ6->Z6_ORIGEM	:= FunName()
		Msunlock()
			
	Else
		RecLock("SZ6",.F.)	
		SZ6->Z6_VENCANT	:= SE1->E1_VENCREA
		SZ6->Z6_VENCREA	:= M->E1_VENCREA
		SZ6->Z6_USUARIO	:= cUserName
		SZ6->Z6_ORIGEM	:= FunName()
		Msunlock()
	EndIf		

EndIf	*/
RestArea(aArea)
Return(lRet)
