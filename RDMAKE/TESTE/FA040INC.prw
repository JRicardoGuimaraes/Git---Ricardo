#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA040INC � Autor � AP6 IDE            � Data �  05/03/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FA040INC

lRet	:= .t.
//
If alltrim(M->E1_TIPO) == "RA"
	//
	If empty(M->E1_HIST)  
		//
		MsgInfo("Para Titulos de Recebimento Antecipado eh obrigatorio preenchimento Historico !", "Aten��o") 
		lRet	:= .f.
	Endif
	//		
	If empty(M->E1_REFGEF)  
		//
		MsgInfo("Para Titulos de Recebimento Antecipado eh obrigatorio preenchimento Ref GEFCO !", "Aten��o") 
		lRet	:= .f.
	Endif
	//
Endif
//

Return(lRet)
