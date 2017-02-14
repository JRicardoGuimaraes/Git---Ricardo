#include "RWMAKE.CH"
#include "AP5MAIL.CH"
#include "TBICONN.CH"

////////////////////////////////////////////////////////////////
// Serve para enviar um email para a contabilidade de todos   //
// os produtos cadastrados para ser efetuado uma revisao.     //
////////////////////////////////////////////////////////////////

User Function CT030GRI()

local cServer    := GetMV('MV_RELSERV')
local cAccount   := GetMV('MV_RELACNT')
local cPassword  := GetMV('MV_RELPSW')
local cMensagem  := ''  

  cmensagem := cmensagem + "Foi incluido no sistema o seguinte Centro de Custo : " + Chr(13)+Chr(10)
  cmensagem := cmensagem + CTT->CTT_CUSTO + " " + CTT->CTT_DESC01 + Chr(13)+Chr(10)
  cmensagem := cmensagem + "Favor analisar os dados. " +Chr(13)+Chr(10)
  cmensagem := cmensagem + "Dados informados pelo(a) usuario(a):"+cUserName+Chr(13)+Chr(10)

  CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConectou
  SEND MAIL FROM cAccount;
  TO "helena.nascimento@gefco.com.br";
  SUBJECT "Cadastramento de Centro de Custos";
  BODY cmensagem ;
  RESULT lEnviado
  DISCONNECT SMTP SERVER Result lDisConectou

Return(nil)
