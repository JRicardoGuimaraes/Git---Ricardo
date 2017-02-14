#include "rwmake.ch"

User Function vldCNPJ( pCnpj )
Local mult		:=	"543298765432"
Local soma1		:=	0
Local soma2		:=	0
Local digito	:=	""
Local lRet		:=	.f.

If len(pCnpj) <> 14
	return .f.
EndIf	


For nX:=1 to 13
	If nX<=12
		soma1+=val(substr(pCnpj,nX,1))*val(substr(mult,nX,1))
		soma2+=val(substr(pCnpj,nX,1))*val(substr("6"+mult,nX,1))
	Else
		soma2+=val(substr(pCnpj,nX,1))*val(substr("6"+mult,nX,1))
	EndIf
Next nX

digito := alltrim(str(iif(soma1 % 11 < 2,0,11-((soma1)%11))))
digito += alltrim(str(iif(soma2 % 11 < 2,0,11-((soma2)%11))))

If substr(pCnpj,13,2) == digito
	lRet:=.t.
EndIf
return lRet


User Function vldCPF(pCPF)
Local lRet:=.f.
Local aMulti1	:=	{10,9,8,7,6,5,4,3,2}
Local aMulti2	:=	{11,10,9,8,7,6,5,4,3,2}
Local soma1		:=	0
Local soma2		:=	0
Local digito	:=	""
Local lRet		:=	.f.

If len(pCPF) <> 11
	return .f.
EndIf	

For nX:=1 to 10
	If nX<=9
		soma1+=val(substr(pCPF,nX,1))*aMulti1[nX]
		soma2+=val(substr(pCPF,nX,1))*aMulti2[nX]
	Else
		soma2+=val(substr(pCPF,nX,1))*aMulti2[nX]
	EndIf
Next nX

digito := alltrim(str(iif(soma1 % 11 < 2,0,11-((soma1)%11))))
digito += alltrim(str(iif(soma2 % 11 < 2,0,11-((soma2)%11))))

If substr(pCPF,10,2) == digito
	lRet:=.t.
EndIf
Return lRet