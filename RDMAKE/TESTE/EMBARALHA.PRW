#include "rwmake.ch"

User Function fEmbaralha()

//chkfile("SA2")

dbSelectArea("SA2")
dbGoTop()
x:=0
While !eof()

	If !Empty(SA2->A2_USERLGI)
		cUserLG := EMBARALHA(A2_USERLGI,1)
		cUsuarioI := If (!Empty(cUserLg),Subs(cUserLg,1,15),"")
		cDataI := IIF(!Empty(cUserLg),CTOD("01/01/96","DDMMYY") + Load2in4(Substr(cUserLg,16)),"")
		Alert(cUsuarioI + " " + dtoc(cDataI))
		x++	
	EndIf
	dbSkip()
	
	If x>10
		exit
	EndIf	
end
Return                                   

/*
Function LeLog (cStatus,cUsuarioI,cUsuarioA,cDataI,cDataA,cTipo)
Local cAlias := Alias(),cUserLg := "",cCampo

cStatus := IIF(Deleted(),"Deletado","Ativo") 
If cTipo $ "13"
	cCampo 	:= If ( Subs(cAlias, 1, 1) == "S", Subs(cAlias,2) + "_USERLGI", cAlias+ "_USERGI" )
	cUserLG := Embaralha(&cCampo,1)
	cUsuarioI := If (!Empty(cUserLg),Subs(cUserLg,1,15),"")
	cDataI := IIF(!Empty(cUserLg),CTOD("01/01/96","DDMMYY") + Load2in4(Substr(cUserLg,16)),"")
Else
	cUsuarioI := OemtoAnsi(STR0021) //"Log N„o Ativo" 
Endif
If cTipo $ "23"
	cCampo 	:= If ( Subs(cAlias, 1, 1) == "S", Subs(cAlias,2) + "_USERLGA", cAlias+ "_USERGA" )
	cUserLG := Embaralha(&cCampo,1)
	cUsuarioA := If (!Empty(cUserLg),Subs(cUserLg,1,15),"")
	cDataA := IIF(!Empty(cUserLg),CTOD("01/01/96","DDMMYY") + Load2In4(Substr(cUserLg,16)),"")
Else
	cUsuarioA := OemtoAnsi(STR0021) // "Log N„o Ativo"
Endif
Return 
*/