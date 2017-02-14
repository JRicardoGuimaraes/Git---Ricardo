#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

USER Function TMI70DTC()
Local _aCAB		:= PARAMIXB[1] 
Local _aItem	:= PARAMIXB[2]
Local _aRet 	:= {}

Aadd(_aCAB,{"DTC_CCUSTO" ,M->DIK_CCUSTO, Nil})
//Aadd(_aItem,{})

Aadd(_aRet, _aCAB)
Aadd(_aRet, _aItem)

Return _aRet