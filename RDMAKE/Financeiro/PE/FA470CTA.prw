#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA470CTA � Autor � Vitor Sbano        � Data �  09/07/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada - FINA470.                                ���
���          � - Destinado a converter o Codigo Conta Bco Itau            ���
���          � suprimindo espaco entre Conta e DV                         ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 8.11 - Financeiro - Reconc Automatica (FINA470)   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FA470CTA
//  
//		cBanco   :=Substr(xBuffer,Int(Val(Substr(cPosBco, 1,3))),nLenBco )
//		cAgencia :=Substr(xBuffer,Int(Val(Substr(cPosAge, 1,3))),nLenAge )
//		cConta   :=Substr(xBuffer,Int(Val(Substr(cPosCta, 1,3))),nLenCta )
//		If lFa470Cta
//			aConta   := ExecBlock("FA470CTA", .F., .F., {cBanco, cAgencia, cConta} )
//			cBanco   := aConta[1]
//			cAgencia := aConta[2]
//			cConta   := aConta[3]
//		Endif
//         
//
cBco   := ParamIxb[1]
cAge   := ParamIxb[2]
cCta   := ParamIxb[3]
aCta	:= {}
//
If cBco = '341'
	//
	cCta   := substr(cCta,1,5)+substr(cCta,7,1)
	//
Endif 
//
aCta	:= {cBco,cAge,cCta}
//
alert("Banco : "+aCta[1]+" Agencia : "+aCta[2]+"  Conta : "+aCta[3])
//
Return(aCta)
