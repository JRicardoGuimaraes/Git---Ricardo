#include 'Protheus.ch'
#include 'totvs.ch'  

//-------------------------------------------------------------------------------------------------
/* {2LGI} TMTABCAR
@autor		: Luz Alexandre
@descricao	: Funcao principal da rotina
@since		: Fev./2014
@using		: Viagem de coleta/entrega/transferencia 
@using		: Seleciona tabela de frete da viagem de acordo por rota ou por origem destino.
@review     : Cadastro de tipo de rota na tabela M3. Rota 20 Administrada 10 Operacional
*/
//-------------------------------------------------------------------------------------------------  
User Function TMTABCAR()

Local aArea     := GetArea()
Local aAreaDTQ  := DTQ->(GetArea())
Local aAreaDUJ  := DUJ->(GetArea())
Local aAreaDVG  := DVG->(GetArea())
Local aAreaDA8  := DA8->(GetArea())
// --- Variaveis utilizadas
Local _aTabFre	:= {}
Local _cRota	:= DTQ->DTQ_ROTA
Local _cTpRota	:= ''
Local aRet      := {}

_aTabFre	:= ParamIxb
/*	[01] - Codigo da tabela 
	[02] - Tipo da Tabela
	[03] - Tabela carreteiro
	[04] - Fornecedor
	[05] - Loja
	[06] - Servico
	[07] - Tipo de Transporte*/
                                                 
// --- Verifica o tipo da rota
_cTpRota	:= GetAdvFval("DA8","DA8_TIPROT",xFilial("DA8")+_cRota,1,"")
                    
// --- Somente rota administrada
If _cTpRota	== '20'             

	// --- Verifica o contrato do fornecedor e obtem a tabela de frete origem versus destino
	DUJ->(dbSetOrder(2))
	If DUJ->(dbSeek(xFilial('DUJ')+_aTabFre[4]+_aTabFre[5])) 
		
		// --- Localiza os itens do contrato 
		DVG->(dbSetOrder(1))
		If DVG->(dbSeek(xFilial('DVG')+DUJ->DUJ_NCONTR))
			
			// --- Laco na tabela de contrato de fornecedor
			While DVG->( ! Eof() ) .and. DVG->DVG_FILIAL == xFilial('DVG') .and. DVG->DVG_NCONTR == DUJ->DUJ_NCONTR 
	            
				// --- Verifica o tipo de servico e de transporte e veiculo
				If DVG->DVG_SERTMS == _aTabFre[6] .and. DVG->DVG_TIPTRA == _aTabFre[7] 
					aAdd(aRet, DVG->DVG_TABADM)
					aAdd(aRet, DVG->DVG_TIPADM)
					aAdd(aRet, "")
					Exit
		        EndIf                  
		        
		        // --- Proximo registro
				DVG->(dbSkip())
				                
			EndDo                           
			
		EndIf
		
	Else
		MsgInfo(OemToAnsi('Não foi encontrada contrato de fornecedor'),OemToAnsi('Aviso') )
	EndIf

EndIf 

// --- Restaura area
RestArea(aAreaDUJ)
RestArea(aAreaDTQ)
RestArea(aAreaDA8)
RestArea(aAreaDVG)
RestArea(aArea)
                
// --- Retorna a tabela alterada
Return(aRet)
