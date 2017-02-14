#include "rwmake.ch"        

User Function F050BROW()       

//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ F050BROW ³ Autor ³ Saulo Muniz           ³ Data ³ 02/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Tratamento no contas a pagar                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//
/*

////////////////
Usuarios Mestre  ( Podem Ver Tudo )
////////////////

Laert / Aministrador / Alvaro / Aline

xUser := "erA tol o vS Nab "   //ALVARO NETO
xUser := "erA tol o vS Naa "   //ALVARO NETO
xUser := "SaB ara larSe bbs"   //BARBARA SALES
xUser := "SaB ara larSe b`s"   //BARBARA SALES
xUser := " eA   l   iS  nb "   //ALINE
xUser := " dL  re  aaS  nb "   //LEANDRA
xUser := "soN sni i lSsAtb "   //NILTON ASSIS
xUser := "atRocae h nSaMaad"   //RENATA MACHADO
xUser := "SiW iai lmlSv laa"   //WILLIAM SILVA
xUser := " iF  ol   aS  va "   //FLAVIO
xUser := " lR  do  onS  aa "   //RONALDO
xUser := " dL  re  aaS  na "   //LEANDRA
xUser := "PrE idd nouSt aao"   //EDUARDO PINTO
xUser := "SlG ide lorSv a`a"   //GERALDO SILVA
xUser := " aJ  nu  alS  i\ "   //JULIANA
xUser := "RtL oea c eSh r\a"   //LAERTE ROCHA
xUser := "etRarae a nSlPa\t"   //RENATA PERALTA
xUser := "rnA aid dsmSotibr"   //Administrador

*/
//cCampo 	:= If ( Subs(cAlias, 1, 1) == "S", Subs(cAlias,2) + "_USERLGI", cAlias+ "_USERGI" )

Local cFiltro := ""

xUsuario := Alltrim(Substr(cUsuario,7,15))
//xUser := Subs(cUsuario,7,15)+Save4in2(MsDate()-Ctod("01/01/96"))  // Default
xUser := Subs(cUsuario,7,15)+Save4in2(Ddatabase - Ctod("01/01/96"))
cString   := Embaralha(xUser,0)                                                                          

  If xUsuario == "Administrador" .Or. xUsuario == "Alvaro Neto" .Or. xUsuario == "Aline" .Or.  xUsuario == "Laerte  Rocha"  
     
  Else  
     cFiltro := "Substr(E2_USERLGI,1,10) == "+"'"+Substr(cString,1,10)+"'"             
     // cFiltro := "E2_USERLGI == "+"'"+cString+"'"             
     SE2->(dbSetFilter({||&cFiltro},cFiltro))
  Endif

Return