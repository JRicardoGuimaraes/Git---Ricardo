#include 'TOTVS.CH'

//-------------------------------------------------------------------------------------------------
/* {2LGI} TM460CPO
@autor		: Luiz Alexandre
@descricao	: Funcao princial da rotina
@since		: Fev./2014
@using		: Atualiza dados do documento de coleta a partir de campos especificos
@review		: Mai./2014 - Inclusao do campo DT6_CCUSTO
*/
//-------------------------------------------------------------------------------------------------
User Function TM460CPO()

// --- Variaveis utilizadas
Local _aAreaDT5	:= DT5->(GetArea())
Local _aAreaDUE	:= DUE->(GetArea())
Local _aAreaDF1	:= DF1->(GetArea())

// --- Localiza a regiao do solicitante
DUE->(dbSetOrder(1))
DUE->(dbSeek(xFilial('DUE')+DT5->DT5_DDD+DT5->DT5_TEL))
RecLock('DT6',.f.)
DT6->DT6_CDRCAL		:=	DUE->DUE_CDRSOL  
DT6->DT6_CCUSTO		:=	DT5->DT5_CCUSTO 

// --- 	{2LGI - 24/08/2014}
// ---	Interface CNH - Gravacao do agendamento no documento de transporte
DF1->(dbSetORder(3))
If DF1->(dbSeek(xFilial('DF1')+DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE))

	// ---	Grava agendamento
	DT6->DT6_NUMAGD	:= DF1->DF1_NUMAGE
	DT6->DT6_ITEAGD	:= DF1->DF1_ITEAGE       
	DT6->DT6_CLIREM	:= DF1->DF1_CLIREM       
	DT6->DT6_LOJREM	:= DF1->DF1_LOJREM       

EndIf  

DT6->(msUnLock())

// --- Restaura area de trabalho
RestArea(_aAreaDT5)                   
RestArea(_aAreaDUE)                   
RestArea(_aAreaDF1)                   

Return
