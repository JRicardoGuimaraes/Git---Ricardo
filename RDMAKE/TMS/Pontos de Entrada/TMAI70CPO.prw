#Include 'Protheus.ch'

/*/{Protheus.doc} TMAI70CPO
(Ponto de Entrada executado na rotina TMSAI70, usado para habilitar campos)
@type function Ponto de Entrada
@author u297686 - Ricardo Guimaraes
@since 03/01/2017
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function TMAI70CPO()
Local aCampos	:= {}

aAdd(aCampos,'DIK_CCUSTO')

Return aCampos
