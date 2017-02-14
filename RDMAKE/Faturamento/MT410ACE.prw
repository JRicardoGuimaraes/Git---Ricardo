#include "rwmake.ch"    
 
/*
*---------------------------------------------------------------------------*
* Função     |TM410ACE  | Autor | J Ricardo             | Data | 25.01.11   *
*---------------------------------------------------------------------------*
* Descrição  |Ponto de entreda disparada na rotina de pedido de venda       *
*            |MATA410, utilizado para validar acesso a opção de menu.       *
*            |                                                              *
*---------------------------------------------------------------------------*
*/

User Function MT410ACE()
LOCAL _nOpc := ParamIxb[1]
/*
If _nOpc = 3
	Alert("Opção desabitada pelo DSF.")
EndIf

Return(IIF(_nOpc=3,.F.,.T.))
*/
Return .t.