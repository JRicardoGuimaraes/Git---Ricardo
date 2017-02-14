#Include 'Protheus.ch'



/*/{Protheus.doc} TMF05ALC
(long_description) - Ponto de Entrada para inclusão de campos na tela de agendaento - TMSAF05
@author u297686 - Ricardo Guimarães
@since 12/11/2015
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
USER Function TMF05ALC() 
Local aRet := { }

aAdd(aRet,"DF0_KMPLAN")
aAdd(aRet,"DF0_DDD")
aAdd(aRet,"DF0_TEL")
aAdd(aRet,"DF0_DESOPE")
aAdd(aRet,"DF0_TIPO")
aAdd(aRet,"DF0_CNHID")
aAdd(aRet,"DF0_DATCAD")

// MsgInfo("Ponto de entrada TMF05ALC")

Return aRet
 

