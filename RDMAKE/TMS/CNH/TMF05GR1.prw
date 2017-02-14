#include 'TOTVS.CH'

User Function TMF05GR1
//-------------------------------------------------------------------------------------------------
/* {2LGI} TMF05GR1
@autor		: Luiz Alexandre
@descricao	: Ponto de entrada para gravar o numero do agendamento e item na solicitacao de coleta.
@since		: Ago./2014
@using		: Interface CNH - Confirmacao do agendamento
@review		:
*/
//-------------------------------------------------------------------------------------------------
// ---	Variaveis utilizadas
Local	_aArea		:=	GetArea()
Local	_aAreaDT6	:= 	DT6->(GetArea())
Local	_nOpcao		:= 	ParamIxb                     

// ---	Tratamento para cancelamento do agendamento
If _nOpcao	== 5

	If MsgYesNo(OemToAnsi('Deseja transmitir o Declinio do plano de transporte'),OemToAnsi('Cancela Agendamento'))     
		// ---	Transmite a interface301 - Declinio do plano de transporte
		U_GEFINTCNH('301',.f.)
    EndIf
     
// ---	Tratamento para confirmacao do plano
ElseIf _nOpcao	== 6     
    
	// ---	Atualiza a gravação do campo filial de origem
	RecLock('DF1',.f.)
	DF1->DF1_FILORI	:= GDFieldGet('DF1_FILORI')
	DF1->(MsUnLock()) 

	// ---	Localiza documento de transporte gerado.
	DT6->(dbSetOrder(1))
	If DT6->(dbSeek(xFilial('DT6')+DF1->DF1_FILDOC+DF1->DF1_DOC+DF1->DF1_SERIE))
		
		// ---	Grava agendamento
		RecLock('DT6',.f.)
		DT6->DT6_NUMAGD	:= DF1->DF1_NUMAGE
		DT6->DT6_ITEAGD	:= DF1->DF1_ITEAGE
		DT6->DT6_CLIREM	:= DF1->DF1_CLIREM
		DT6->DT6_LOJREM	:= DF1->DF1_LOJREM
		
	EndIf
	
EndIf

// ---	Restaura area
RestArea(_aArea)
RestArea(_aAreaDT6)

Return 
