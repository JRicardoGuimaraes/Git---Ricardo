//#INCLUDE "rwmake.ch"
#Include "Protheus.Ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GEFINA002 � Autor � MARCOS FURTADO     � Data �  04/08/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Altera��o do par�metro MV_CONTBAT. Que define se ira       ���
���          � permitir o debito ser diferente do credito no momento      ���
���          � da contabilizacao.                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Contabilidade / Financeiro                                 ���
�������������������������������������������������������������������������ͼ��
���Alteracao �                                                            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GFINA002

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
//  
Local oCombo                        
Private cCombo
Private cPar := Space(01)
Private oDlg
Private aCombo  := {}

aAdd( aCombo, "Sim" )
aAdd( aCombo, "Nao" )
  
cPar := AllTrim(GetMv("MV_CONTBAT"))
               
//A Pergunta est� invertida para facilitar o entendimento do usu�rio
If CPar == "N"
	cCombo := 1
Else
	cCombo := 2
EndIF
// Tela de Informa��o de valores/convert  
DEFINE MSDIALOG oDlg TITLE "Permissao de Inclusao de LC" FROM 0,0 TO 180,360 OF oDlg PIXEL
@ 010,003 To 60,180 OF oDlg PIXEL
@ 015,010 Say "Permitir inclus�o de LC quando o DOC n�o bater:(S/N)" SIZE 150 ,8 PIXEL OF oDlg
//@ 015,150 msGet  cPar Valid (Pertence("SN"))  Size 40,10 PIXEL OF oDlg
@ 015,155 COMBOBOX oCombo VAR cCombo ITEMS aCombo SIZE 25,10 PIXEL OF oDlg
DEFINE SBUTTON FROM   065,110 TYPE  1 ACTION (fConfirma()) ENABLE 
DEFINE SBUTTON FROM   065,150 TYPE  2 ACTION (oDlg:End())  ENABLE 


Activate Dialog oDlg Centered

Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fConfirma � Autor � Marcos Furtado     � Data �  20/07/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Altera o conteudo do parametro MV_CONTBAT                  ���
�������������������������������������������������������������������������͹��
���Uso       � Contabilidade Gerencial / Financeiro                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
/*/

Static Function fConfirma
               
If cCombo == "Nao"
	PutMV("MV_CONTBAT","S")
Else 
	PutMV("MV_CONTBAT","N")
EndIf

oDlg:End()

Return()