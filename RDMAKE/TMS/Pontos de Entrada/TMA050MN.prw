#include "Protheus.ch"

/***
* Por: Ricardo Guimarães  Em: 12/05/2015
* PE para incluir menu da rotina TMSA144A
* na tela de entrada de doc. TMSA050
*****/
*--------------------------------------------*
User Function TMA050MN()
*--------------------------------------------*
Local _aArea     := GetArea()
Local aRotViagem := {}
Local aRotAereo  := {}
Local aRotRodov  := {}
Local aRodColeta := {}
Local aRodTransp := {}
Local aRodEntrega:= {}

/*
AADD( aRotAereo, { "Coleta"         , 'TMSA141B', 0, 6}) //Coleta
AADD( aRotAereo, { "Viagem (mod.2)" , 'TMSA144E', 0, 6}) //"Viagem (mod.2)
AADD( aRotAereo, { "Confirmação"    , 'TMSA142B', 0, 6}) //"Viagem (mod.2)
AADD( aRotAereo, { "Fechamento"     , 'TMSA310E', 0, 6}) //"Viagem (mod.2)
AADD( aRotAereo, { "Operações"      , 'TMSA350E', 0, 6}) //"Viagem (mod.2)
AADD( aRotAereo, { "Encerramento"   , 'TMSA340E', 0, 6}) //"Viagem (mod.2)
*/

                
*-----------------------------------------------------------------------*
AADD( aRodColeta , { "Viagem"         , 'TMSA141A', 0, 6}) //Coleta
AADD( aRodColeta , { "Viagem (mod.2)" , 'TMSA144A', 0, 6}) //Coleta
AADD( aRodColeta , { "Confirmacao"    , 'TMSA142A', 0, 6}) //Coleta
AADD( aRodColeta , { "Fechamento"     , 'TMSA310A', 0, 6}) //Coleta
AADD( aRodColeta , { "Operacoes"      , 'TMSA350A', 0, 6}) //Coleta
AADD( aRodColeta , { "Encerramento"   , 'TMSA340A', 0, 6}) //Coleta

AADD( aRodTransp , { "Viagem"         , 'TMSA140A', 0, 6}) //Coleta
AADD( aRodTransp , { "Viagem (mod.2)" , 'TMSA144B', 0, 6}) //Coleta
AADD( aRodTransp , { "Confirmacao"    , 'TMSA142E', 0, 6}) //Coleta
AADD( aRodTransp , { "Corregamento"   , 'TMSA210A', 0, 6}) //Coleta
AADD( aRodTransp , { "Operacoes"      , 'TMSA350B', 0, 6}) //Coleta
AADD( aRodTransp , { "Fechamento"     , 'TMSA310B', 0, 6}) //Coleta
AADD( aRodTransp , { "Encerramento"   , 'TMSA340B', 0, 6}) //Coleta

AADD( aRodEntrega, { "Viagem"         , 'TMSA141C', 0, 6}) //Coleta
AADD( aRodEntrega, { "Viagem (mod.2)" , 'TMSA144D', 0, 6}) //Coleta
AADD( aRodEntrega, { "Confirmacao"    , 'TMSA142C', 0, 6}) //Coleta
AADD( aRodEntrega, { "Corregamento"   , 'TMSA210C', 0, 6}) //Coleta
AADD( aRodEntrega, { "Operacoes"      , 'TMSA350D', 0, 6}) //Coleta
AADD( aRodEntrega, { "Fechamento"     , 'TMSA310D', 0, 6}) //Coleta
AADD( aRodEntrega, { "Encerramento"   , 'TMSA340D', 0, 6}) //Coleta
*-----------------------------------------------------------------------*

AADD( aRotRodov, { "Coleta"         , aRodColeta , 0, 7}) //Coleta
AADD( aRotRodov, { "Transporte"     , aRodTransp , 0, 7}) //"Viagem (mod.2)
AADD( aRotRodov, { "Entrega"        , aRodEntrega, 0, 7}) //"Viagem (mod.2)

//AADD( aRotViagem, { "Rodoviario" , aRotRodov, 0, 7}) //"Viagem (mod.2)
//AADD( aRotViagem, { "Aereo"      , aRotAereo, 0, 7}) //"Viagem (mod.2)

AADD( aRotina, { "Viagem (Rodoviario)" , aRotRodov, 0, 7}) //"Viagem (mod.2)

RestArea(_aArea)
Return
