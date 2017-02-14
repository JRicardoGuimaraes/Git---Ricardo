#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

User Function Gefm12()        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

// IIF(SA1->A1_MUN == SA1->A1_MUNC,SUBS(SA1->A1_MUN,1,15),SUBS(SA1->A1_MUNC,1,15))

//_XMUN1:= Len(Alltrim(SA1->A1_MUN))
//_XMUN2:= Len(Alltrim(SA1->A1_MUNC))
_XMUNCOB:= Alltrim(SA1->A1_MUNC)

//  IF(_XMUN1 == _XMUN2)
//      _XMUNCOB:= Alltrim(SA1->A1_MUN) 
//  Else
//      _XMUNCOB:= Alltrim(SA1->A1_MUNC) 
//  EndIF

Return(_XMUNCOB)        // incluido pelo assistente de conversao do AP5 IDE em 17/12/01

