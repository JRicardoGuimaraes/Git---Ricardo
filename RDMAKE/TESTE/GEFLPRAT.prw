#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GEFLPRAT  � Autor � AP6 IDE            � Data �  06/03/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
           
User Function GEFLPRAT

If alltrim(FunName()) = "FINA050"   && Contabilizacao On-Line
	// 
	DbSelectArea("SE2")
	_mRecSE2	:=	Recno()
	_mIndSe2	:=	IndexOrd()
	DbSetOrder(1)
	DbSeek(xFilial("SE2")+M->E2_PREFIXO+M->E2_NUM+M->E2_PARCELA+M->E2_TIPO+M->E2_FORNECE+M->E2_LOJA)
	If found()
		nVlrBas := (SE2->E2_VALOR+SE2->E2_IRRF+SE2->E2_INSS+SE2->E2_ISS+SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSLL);
	           - (SE2->E2_XVLRND + SE2->E2_XVLRFRT)
		nVlrTit := (SE2->E2_VALOR+SE2->E2_IRRF+SE2->E2_INSS+SE2->E2_ISS+SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSLL)
	Else 
		nVlrBas := 0	
	    nVlrTit := 0
	Endif	        
	DbSetOrder(_mIndSE2)
	DbGoto(_mRecSE2)
	//   
    nVlrBas2	:=  (VALOR / nVlrTit) * nVlrBas      
    //
    //ALERT("nVlrBas."+transform(nVlrBas,"@E 999,999.99")+" VALOR "+transform(VALOR,"@E 999,999,999.99")+" nVlrTit "+transform(nVlrTit,"@E 999,999,999.99")+" Vlr RETORNO "+transform(nVlrBas2,"@E 999,999,999.99"))
	//
Else
	nVlrBas := (SE2->E2_VALOR+SE2->E2_IRRF+SE2->E2_INSS+SE2->E2_ISS+SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSLL);
           - (SE2->E2_XVLRND + SE2->E2_XVLRFRT)

	nVlrTit := (SE2->E2_VALOR+SE2->E2_IRRF+SE2->E2_INSS+SE2->E2_ISS+SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSLL)

    nVlrBas2	:=  (VALOR / nVlrTit) * nVlrBas      
	//
Endif
//
Return(nVlrBas2)