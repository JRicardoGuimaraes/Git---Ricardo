#include 'Protheus.ch'
#include 'Totvs.ch'

//-------------------------------------------------------------------------------------------------
/* {2LGI} CECEML
@autor		: Luz Alexandre
@descricao	: Funcao principal da rotina
@since		: Jun./2014
@using		: Preenchimento de layout de EDI CECEML
@review     :
*/
//-------------------------------------------------------------------------------------------------
User Function CECEML(cReg,cPos)

// --- Variaveis utilizadas
Local _cPos		:= cPos
Local _cReg		:= cReg
Local _cRet		:= ''
Local _aArea	:= GetArea()
Local _aAreaDTP	:= DTP->(GetArea())
Local _aDePara	:= {}
Local _nPos		:= 0

// --- Retorna vazio se nao enviado parametro
If Empty(_cPos) .or. Empty(_cReg)
	Return _cRet
EndIf

// --- Adiciona codigos de/para na array conforme manual do layout.

_aDePara	:= {	{'01|15|16'	,'C3'		},;
					{'02'			,'BR12'	},;
					{'03'			,'BR04'	},;
					{'04|'			,'LEVE'	},;
					{'05'			,'BR01'	},;
					{'06'			,'BR02'	},;
					{'07|'			,'C2'		} }

// --- Registro 329 --- Layout CECEML
// --- Posicao inicial 004 - Tipo de Transporte

If _cReg	==	'329' .And. _cPos	== '004'

	// --- Localiza o tipo de veiculo informado a partir do lote DTP
//	_cRet	:= GetAdvFVal('DA3','DA3_TIPVEI',xFilial('DA3')+DTP->DTP_CODVEI,1,'')

	_cRet	:= GetAdvFVal('DVU','DVU_TIPVEI',xFilial('DVU')+DT6->(DT6_FILORI+DT6_LOTNFC),2,'')

    _nPos	:= Ascan( _aDePara, { |X| _cRet $ X[1]  } )

    // --- Troca o codigo do meio de transporte
    If _nPos > 0
    	_cRet	:= _aDePara[_nPos][2]
    EndIf

EndIf

Return _cRet

