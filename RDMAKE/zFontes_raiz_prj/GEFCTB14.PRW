#include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTA005   ºAutor  ³Saulo Muniz         º Data ³  29/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela de imput de lançamentos                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EXCLUSIVO PARA GEFCO LOGISTICA DO BRASIL LTDA              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GEFCTB14() 
///////////////////////
//Quadro 1
_cCod := space(12)
_cDesc := space(40)
_nLacre := 00000000
_cTit1  := space(12)
_cCont1 := space(30)
_cTit2  := space(12)
_cCont2 := space(30)
_cTit3  := space(12)
_cCont3 := space(30)
_cTit4  := space(12)
_cCont4 := space(30)
_cTit5  := space(12)
_cCont5 := space(30)
_cTit6  := space(12)
_cCont6 := space(30)
_cTit7  := space(12)
_cCont7 := space(30)
_cTit8  := space(12)
_cCont8 := space(30)
_cTit9  := space(12)
_cCont9 := space(20)
_cCont9b := space(1)

//Quadro 2
_nOp := 1
_nCopia := 0

dbSelectArea("SZ9")
dbSetOrder(1)
dbgotop()

fColeta()

Return   

Static Function fValCod(oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9)
/////////////////////////
SZ9->(dbgotop())

oCont1:enable(); oCont2:enable(); oCont3:enable(); oCont4:enable()
oCont5:enable(); oCont6:enable(); oCont7:enable(); oCont8:enable(); oCont9:enable()

If SZ9->(dbseek(xfilial("SZ9")+_cCod))
	fVarVal()	
	_tem := .F.
	For t:= 1 to 9
		var := "_cTit"+str(t,1)
		if Trim(&var) $ "A.F. AF AFT"
			_tem := .T.
		Endif
	Next t
	If _tem .or. ("DELPHI"$ UPPER(_cDesc) .and. "EXP"$UPPER(_cDesc))
		xpesq := "ITEM PEDIDO COD.SELCO COD.CLIENTE"
		If "DELPHI"$ UPPER(_cDesc) .and. "EXP"$UPPER(_cDesc)
			xpesq := " CUSTOMER PART NR REF.SELCO"
		endif
		For t:= 1 to 9  
			var := "_cTit"+str(t,1)
			var1 := "_cCont"+str(t,1)
			If AllTrim(&var) $ xpesq .or. "ECL"$ (&var) //"ITEM PEDIDO COD.SELCO COD.CLIENTE"
				If t = 1;     oCont1:disable()
				ElseIf t = 2; oCont2:disable()						
				ElseIf t = 3; oCont3:disable()						
				ElseIf t = 4; oCont4:disable()						
				ElseIf t = 5; oCont5:disable()						
				ElseIf t = 6; oCont6:disable()						
				ElseIf t = 7; oCont7:disable()						
				ElseIf t = 8; oCont8:disable()						
				ElseIf t = 9; oCont9:disable()						
				Endif
			Endif
		Next t
	Endif
Else
	fIniVar()
Endif
Return

Static Function fInclui()
/////////////////////////
SZ9->(dbgotop())
If SZ9->(dbseek(xfilial("SZ9")+_cCod))
	MsgBox("Etiqueta já gravada!","Atenção","INFO")
	Return
Endif

RecLock("SZ9",.T.)      
fGrava()
MsunLock()

MsgBox("Etiqueta gravada com sucesso!","Atencao","INFO")
Return

Static Function fExclui()
/////////////////////////
SZ9->(dbgotop())
If !SZ9->(dbseek(xfilial("SZ9")+_cCod))
	MsgBox("Etiqueta não gravada!","Atenção","INFO")
	Return
Else
	If MsgBox("Deseja excluir etiqueta "+_cCod+" ?","Atencao","YESNO")
		RecLock("SZ9",.F.)
		SZ9->(dbdelete())
		MsunLock()
		dbgotop()
		fIniVar()
		MsgBox("Etiqueta excluída com sucesso!","Atencao","INFO")
	Endif		
Endif
Return

Static Function fEdita()
////////////////////////
SZ9->(dbgotop())
If !SZ9->(dbseek(xfilial("SZ9")+_cCod))
	MsgBox("Etiqueta não gravada!","Atenção","INFO")
	Return
Else
	If MsgBox("Deseja gravar alterações da etiqueta "+_cCod+" ?","Atencao","YESNO")
		RecLock("SZ9",.F.)
		fGrava()
		MsunLock()
		dbgotop()
		MsgBox("Etiqueta gravada com sucesso!","Atencao","INFO")
	Endif		
Endif
Return

Static Function fImprimi()
//////////////////////////
      
fImpOK()

Return

Static Function fImprEti(oQuadro2)
//////////////////////////
//Chamada da função para imptérmica
If _nOp = 2
	fEtiqTer(_cCod,_nCopia)
	Return nil
Endif
//variaveis de impressao
titulo := " "
cString:= " "
wnrel  := "ESTA005"
cDesc  := "Impressao de Etiquetas - Especifico Selco"
aOrd   := {}
tamanho:= "P"
aReturn  := {"Zebrado",1,"Administracao", 2, 2, 1, "",1 }
cPerg    :=""
nLastKey := 0
// Funcao setprint
wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc,"","",.F.,,.F.,"P",.F.,,.F.)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

If _nOp = 3
	RptStatus({||fEtiqGra()})
ElseIf _nOp = 1
	RptStatus({||fEtiqNor()})
Endif

Close(oQuadro2)
Return

Static Function fEtiqNor()
///////////////////////
li := 0

Set device to Print
setprc(0,0)

SetRegua( _nCopia)

For nn:= 1 to _nCopia
	_lac := .F.
	Incregua()
	@ li,00 PSAY chr(18)
	@ li,00 PSAY chr(27)+chr(48)
	@ li,00 PSAY chr(27)+chr(107)+"1"
	@ li,00 PSAY chr(27)+chr(120)+"0"
	@ li,00 PSAY chr(27)+chr(77)
	for t:= 1 to 9
		var1 := "_cTit"+str(t,1)  //"SZ9->Z9_TIT"+Str(t,1)
		var2 := "_cCont"+str(t,1)//"SZ9->Z9_CONT"+Str(t,1)
		If !empty(&var1) .or. !empty(&var2)
			xcont := &var2
			If Alltrim(&var1)="LACRE"
				_lac := .T.								
			Endif         
			@ li,00 PSAY &var1+":"+AllTrim(xcont)
		Endif
		If t = 9 .and. !_lac .and. _cCont9b = "S" .and. _nLacre > 0
			xlac := " LACRE: "+AllTrim(str(_nLacre+(nn-1)))
			If Empty(_cTit9) .and. empty(_cCont9)
				@ li,00 PSAY xlac
			ElseIf !empty(_cTit9) .or. !empty(_cCont9)
				If len(_cTit9+Alltrim(_cCont9)+xlac) > 42   //qtde de caracteres possiveis na linha da etiqueta
					If !MsgBox("Ultima Linha excede tamanho máximo.Continuar?","Atencao","YESNO")
			          Exit
			  		Endif
			  	Endif
			  	@ li,len(_cTit9+Alltrim(_cCont9))+1 PSAY xlac
			Endif						
		Endif
		li++
	next t
	li := li+3
Next nn

@ li,00 PSay chr(18)
@ li,00 PSay " "

Set Device to Screen
SetPgEject(.F.)

If aReturn[5] == 1
   dbCommitall()
   Set Printer to
   ourspool(wnrel)
Endif
MS_FLUSH()

Return
Static Function fEtiqGra()
///////////////////////
Private oFont, cCode
nHeight:=15
lBold:= .F.
lUnderLine:= .F.
lPixel:= .T.
lPrint:=.F.
nSedex := 1
ini  := 20
nLin := 120
iniLin := nLin
int  := 22
lim  := 10 
limfol := 2200  

oFont12n:= TFont():New( "Times New Roman",,10,,.t.,,,,,.f. )
oFont10 := TFont():New( "Times New Roman",,8,,.t.,,,,,.f. )
oFont12 := TFont():New( "Times New Roman",,10,,.f.,,,,,.f. )
/*
oFont12n:= TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont10 := TFont():New( "Arial",,8,,.t.,,,,,.f. )
oFont12 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
*/
oPrn:=TMSPrinter():New()

SetRegua( _nCopia)

For nn:= 1 to _nCopia
	_lac := .F.
	Incregua()

	If mod(nn,2) > 0
		ini := 50
		iniLin := nLin
	Else
		ini := 1330
		nLin := iniLin
	Endif
		
	cBitMap := "logospr.bmp" 
//	oPrn:Say(nLin,ini," ",oFont10,100)
	oPrn:SayBitmap(nlin,ini,cBitmap,500,090)
	nLin := nLin + (6*int )
	for t:= 1 to 9
		var1 := "_cTit"+str(t,1)  
		var2 := "_cCont"+str(t,1)
		If !empty(&var1) .or. !empty(&var2)
			xcont := &var2
			If Alltrim(&var1)="LACRE"
				_lac := .T.								
			Endif         
			oPrn:Say(nLin,ini,&var1,ofont10,100)
			if t = 1
				oPrn:Say(nLin,ini+280,AllTrim(xcont),oFont12n,100) 
			Else
				oPrn:Say(nLin,ini+280,AllTrim(xcont),oFont12,100) 
			Endif
			nLin := nLin + int
		Endif
		If t = 9 .and. !_lac .and. _cCont9b = "S" .and. _nLacre > 0
			xlac := " L: "+AllTrim(str(_nLacre+(nn-1)))
			If Empty(_cTit9) .and. empty(_cCont9)
				oPrn:Say(nLin,ini,xlac,oFont12,100) 
			ElseIf !empty(_cTit9) .or. !empty(_cCont9)
				If len(_cTit9+Alltrim(_cCont9)+xlac) > 42   //qtde de caracteres possiveis na linha da etiqueta
					If !MsgBox("Ultima Linha excede tamanho máximo.Continuar?","Atencao","YESNO")
			          Exit
			  		Endif
			  	Endif
				oPrn:Say(nLin,ini+400,xlac,oFont12,100) //2000
			Endif						
		Endif
		nLin := nLin + int
	next t
	nLin := nLin + (4*int)
Next nn
//oPrn:EndPage()
If aReturn[5] == 1  //1-Disco, 2-Impressora
	oPrn:Preview()
Else
	oPrn:Setup()
	oPrn:Print()
Endif

MS_FLUSH()
Return

Static Function fEtiqTer(_cCod,_nCopia)
///////////////////////////////////////
ini := 15
aEtiq := aCopia := aImpr := {}
_codbar := " "

if "WABCO" $ Upper(_cDesc)
	fImpFixa()
	eWabco()
	Return
Endif


if "DELPHI" $ Upper(_cDesc) .and. "EXP" $Upper(_cDesc)
	fImpFixa()
	eDelphi()
	Return
Endif

//fRealoca()
fImpFixa()
cPorta := "LPT1"
MSCBPRINTER("ALLEGRO",cPorta,,,.f.,,,,) 
MSCBCHKStatus(.f.)
MSCBLOADGRF("logovert.bmp") //("logospr.bmp")
For nx:=1 to _nCopia
	ini := 15
	nlin := 32//29
	int := 4
   MSCBBEGIN(1,6)                            
	MSCBGRAFIC(04,02,"logovert")       //"logospr")60
	For t:= 1 to len(aImpr)
		aImpr[t,3] := iif(aImpr[t,1] = "LACRE",str(_nLacre+nx-1,8),aImpr[t,3])
		aImpr[t,6] := iif(aImpr[t,5] = "LACRE",str(_nLacre+nx-1,8),aImpr[t,6])
		MSCBSAY(ini,nLin,aImpr[t,1],"N","2","1,0")
		MSCBSAY(ini+aImpr[t,2],nLin,aImpr[t,3], "N", "2", "1,0") 
		if aImpr[t,4] > 0
			MSCBSAY(ini+aImpr[t,4],nLin,aImpr[t,5]+aImpr[t,6], "N", "2", "1,0")
		endif
		nLin := nLin - int
	next t
	if !empty(_codbar)
		MSCBSAYBAR(ini,1,_codbar,"N","A",7)
	Endif		
	MSCBEND()
Next nx	
MSCBCLOSEPRINTER()
Return 

Static Function fImpFixa()
//////////////////////////
aImpr  := {}
_inter := 8
for i:= 1 to 9
	var1 := "_cTit"+str(i,1)  
	var2 := "_cCont"+str(i,1)
	_Tit := &(var1)    
	_Con := &(var2)
	_tit := AllTrim(_tit)
	_con := AllTrim(_con)
	tTit := len(_tit)
	tCon := len(_con)
	xfix := iif(i <= 2,"S","N")
	tSim := ttit+_inter
	If i=9 .and. empty(_tit) .and. empty(_con)
		loop
	Endif
	aadd(aImpr,{_tit,tSim,_con,0," "," "})
next i
If _cCont9b = "S" .and. _nLacre > 0
	lc := str(_nLacre,8)
	aadd(aImpr,{"LACRE",5+_inter,lc,0," "," "})
Endif
xmai := aImpr[1,2]
for i:= 2 to len(aImpr)
	if xmai < aImpr[i,2]
		xmai := aImpr[i,2]
	endif
next i
for i:= 1 to len(aImpr)
	aImpr[i,2] := xmai
next i
Return

Static Function fRealoca()
//////////////////////////
aImpr := {}
aEtiq := {}
aCopia := {}
_limit := 55   //nro de caracteres da linha na etiqueta
_inter := 8
_codbar := ""
//Alimentando matriz com etiqueta
for i:= 1 to 9
	var1 := "_cTit"+str(i,1)  
	var2 := "_cCont"+str(i,1)
	_Tit := &(var1)    
	_Con := &(var2)
	_tit := AllTrim(_tit)
	_con := AllTrim(_con)
	If _tit $ "COD.SELCO COD. SELCO COD SELCO"
		_codbar := _Con
	Endif
	If empty(_tit) .and. empty(_con)
		loop
	Endif
	tTit := len(_tit)
	tCon := len(_con)
	xfix := iif(i <= 2,"S","N")
	tSim := tcon+ttit+_inter
	aadd(aEtiq,{_tit,_con,xfix,tTit,tCon,tSim,0,0," "})
next i
//Inclusao do Lacre
If _cCont9b = "S" .and. _nLacre > 0
	tSim := 5+8+_inter //lacre+99999999+_inter
	lc := str(_nLacre,8)
	aadd(aEtiq,{"LACRE",lc,"N",5,8,tSim,0,0," "})
Endif
//Buscando maior titulo para determinar inicio de impressao de cont
xmai := aEtiq[1,4]
for i:= 2 to len(aEtiq)
	if xmai < aEtiq[i,4]
		xmai := aEtiq[i,4]
	endif
next i
for i:= 1 to len(aEtiq)
	tcpos := xmai + _inter+ aEtiq[i,5]
	aEtiq[i,7] := tcpos
	aEtiq[i,8] := _limit - tcpos
next i
aCopia := aclone(aEtiq)
xcolini := xmai + _inter
//Ajustando tamanho e gravando matriz de impressao
for i:= 1 to len(aEtiq)
	If aEtiq[i,9] = "S" //já coletado
		loop
	Endif
	if aEtiq[i,3] = "S" //fixo
		aadd(aImpr,{aEtiq[i,1],xcolini,aEtiq[i,2],0," "," "})
		aEtiq[i,9] := "S"
		aCopia[i,9] := "S"
		loop
	endif           
	xdif := aEtiq[i,8]
	aadd(aImpr,{aEtiq[i,1],xcolini,aEtiq[i,2],0," "," "})
	aEtiq[i,9]:= "S"
	aCopia[i,9]:= "S"
	for t := 1 to len(aCopia)
		if aCopia[t,9] = "S"
			loop
		endif
		if xdif >= aCopia[t,6] .and. t <> i
			aImpr[len(aImpr),4] := xcolini+aEtiq[i,5]+_inter
			aImpr[len(aImpr),5] := aCopia[t,1]+": "
			aImpr[len(aImpr),6] := aCopia[t,2]
			aEtiq[t,9]:= "S"
			aCopia[t,9] := "S"
			t:= len(aCopia)
			loop
		endif
	next t
next i
Return nil

Static Function eWabco()
////////////////////////
cPorta := "LPT1"
MSCBPRINTER("ALLEGRO",cPorta,,,.f.,,,,) 
MSCBCHKStatus(.f.)
MSCBLOADGRF("wabco1.bmp")
For nx:=1 to _nCopia
	ini := 2
	meio := 55
	nlin := 24 //32
	int := 5
   MSCBBEGIN(1,6)                            
	MSCBGRAFIC(ini,29,"wabco1")
	For t:= 1 to len(aImpr)
		aImpr[t,3] := iif(aImpr[t,1] = "LACRE",str(_nLacre+nx,8),aImpr[t,3])
		MSCBSAY(ini,nLin,aImpr[t,1],"N","2","1,0")
		MSCBSAY(ini+aImpr[t,2],nLin,aImpr[t,3], "N", "3", "1,0")
		If t>1 .and. t < len(aImpr)
			t:= t+1
			aImpr[t,3] := iif(aImpr[t,1] = "LACRE",str(_nLacre+nx,8),aImpr[t,3])
			MSCBSAY(meio,nLin,aImpr[t,1],"N","2","1,0")
			If "MES"$UPPER(aImpr[t,1])
				MSCBBox(meio+aImpr[t,2]-1,nLin-1,meio+aImpr[t,2]+20,nLin+int,3)
			Endif
			MSCBSAY(meio+aImpr[t,2],nLin,aImpr[t,3], "N", "3", "1,0")
		Endif			
		 
		nLin := nLin - int
	next t
	if !empty(_codbar)
		MSCBSAYBAR(ini,1,_codbar,"N","A",7)
	Endif		
	MSCBEND()
Next nx	
MSCBCLOSEPRINTER()
Return 

Static Function eDelphi()
////////////////////////
cPorta := "LPT1"
MSCBPRINTER("ALLEGRO",cPorta,,,.f.,,,,) 
MSCBCHKStatus(.f.)
MSCBLOADGRF("logovert.bmp")
For nx:=1 to _nCopia
	ini := 15
	meio := 55
	nlin := 30
	int := 5
   MSCBBEGIN(1,6)                            
	MSCBGRAFIC(04,02,"logovert")
	For t:= 1 to len(aImpr)
		aImpr[t,3] := iif(aImpr[t,1] = "LACRE",str(_nLacre+nx,8),aImpr[t,3])
		If empty(aImpr[t,1]) .and. empty(aImpr[t,3])
			loop
		Endif
		MSCBSAY(ini,nLin,aImpr[t,1],"N","2","1,0")
		MSCBSAY(ini+aImpr[t,2],nLin,aImpr[t,3], "N", "3", "1,0")
/*
		If t>1
			t:= t+1
			aImpr[t,3] := iif(aImpr[t,1] = "LACRE",str(_nLacre+nx,8),aImpr[t,3])
			MSCBSAY(meio,nLin,aImpr[t,1],"N","2","1,0")
			If "MES"$UPPER(aImpr[t,1])
				MSCBLineH(meio+aImpr[t,2],nLin,40,8,"B")
				MSCBLineH(meio+aImpr[t,2],nLin+2,40,8,"B")
			Endif
			MSCBSAY(meio+aImpr[t,2],nLin,aImpr[t,3], "N", "3", "1,0")
		Endif			
*/		 
		nLin := nLin - int
	next t
	MSCBEND()
Next nx	
MSCBCLOSEPRINTER()
Return 

Static Function fFacil(cNum,oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9)
//////////////////////////////
var1:= "_cTit"+cNum
var2:= "oCont"+cNum
var3:= "_cCont"+cNum 
xF3 := ""
var1:= strtran(&var1," ","")
var1:= strtran(var1,".","")

If Alltrim(var1) $ "CLIENTE CUSTOMER"
	xF3:= "Z11"
ElseIf Alltrim(var1) = "FORNECEDOR"
	xF3 := "Z12"
ElseIf Alltrim(var1) = "PECA"
	xF3 := "Z13"           
ElseIf Alltrim(var1) $ "PRODUTO CODSELCO"
	xF3 := "SB1"           
ElseIf Alltrim(var1) $ "AF AFT A.F."
	xF3 := "Z14"           
ElseIf Alltrim(var1) = "DATA"
	&var3:= DtoC(dDataBase)
ElseIf Alltrim(var1) = "EMPRESA"
	&var3 := "SELCO VEDAÇÕES DINAMICAS LTDA"
ElseIf Alltrim(var1) = "LACRE"
	&var3:= AllTrim(Str(_nLacre))
ElseIf "LOT" $Alltrim(var1)
	xddt := dDataBase
	If !empty(&var3) .and. substr(&var3,3,1)="/" .and. substr(&var3,6,1)="/"
		xddt := ctod(substr(&var3,1,8))
	Endif
	&var3:= Alltrim(Str(xddt-ctod("01/01/"+str(year(dDataBase)))+1))
	&var3 := &var3 +space(30-len(&var3))
Endif
If !empty(xF3)
	If cNum = "1"
		oCont1:cF3:= xF3
	ElseIf cNum = "2"
		oCont2:cF3:= xF3
	ElseIf cNum = "3"
		oCont3:cF3:= xF3
	ElseIf cNum = "4"
		oCont4:cF3:= xF3
	ElseIf cNum = "5"
		oCont5:cF3:= xF3
	ElseIf cNum = "6"
		oCont6:cF3:= xF3
	ElseIf cNum = "7"
		oCont7:cF3:= xF3
	ElseIf cNum = "8"
		oCont8:cF3:= xF3
	ElseIf cNum = "9"
		oCont9:cF3:= xF3
	Endif
Endif	
If !AllTrim(var1) $ "ITEM PEDIDO COD.SELCO COD.CLIENTE CODSELCO CODCLIENTE"
	If cnum = "1";     oCont1:enable()
	ElseIf cnum = "2"; oCont2:enable()						
	ElseIf cnum = "3"; oCont3:enable()						
	ElseIf cnum = "4"; oCont4:enable()						
	ElseIf cnum = "5"; oCont5:enable()						
	ElseIf cnum = "6"; oCont6:enable()						
	ElseIf cnum = "7"; oCont7:enable()						
	ElseIf cnum = "8"; oCont8:enable()						
	ElseIf cnum = "9"; oCont9:enable()						
	Endif
Endif
Return .T.

Static Function fTrataAF(cNum,oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9)
//////////////////////////////

_var := "_cCont"+cnum
_cpo := "_cTit"+cnum
_cpo:= strtran(&_cpo," ","")
_cpo:= strtran(_cpo,".","")

If Alltrim(_cpo) $ "AF AFT A.F." .and. SC6->C6_NUM = AllTrim(&_var)
	For t := 1 to 9
		var1 := "_cTit"+str(t,1)
		var2 := "_cCont"+str(t,1)
		var1:= strtran(&var1," ","")
		var1:= strtran(var1,".","")
		If AllTrim(var1) = "CLIENTE"
			&var2 := POSICIONE("SA1",1,xfilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NOME")
		ElseIf AllTrim(var1) = "PECA"
			&var2 := substr(SC6->C6_DESCRI,1,30)
		ElseIf AllTrim(var1) = "PEDIDO"                                                    
			&var2 := POSICIONE("SC5",1,xfilial("SC5")+SC6->C6_NUM,"C5_PEDCLI")
		ElseIf AllTrim(var1) $ "QUANTIDADE QUANT. QTDE."                  
			&var2 := aLLtRIM(STR(SC6->C6_QTDVEN))+" "+SC6->C6_UM
		ElseIf AllTrim(var1) $ "COD.SELCO CODSELCO"
			&var2 := SC6->C6_PRODUTO
		ElseIf AllTrim(var1) $ "COD.CLIENTE CODCLIENTE"
			&var2 := SC6->C6_CODPRO
		ElseIf AllTrim(var1) $ "ITEM"
			&var2 := SC6->C6_ITEM+SC6->C6_PACTIPO
		ElseIf AllTrim(var1) $ "PRAZO PRZ"
			&var2 := SC6->C6_ENTREG
		ElseIf AllTrim(var1) $ "QTITE QTDITE"
			_rec := SC6->(recno())
			_af  := SC6->C6_NUM
			_nroit := 0
			dbSelectArea("SC6")
			dbgotop()
			if dbseek(xfilial("SC6")+_af)
				do while !SC6->(eof()) .and. _af = SC6->C6_NUM
					_nroit += 1
					dbskip()
				Enddo
			Endif
			dbgoto(_rec)		 	
			&var2 := str(_nroit,6)+" IT/AF"
		Endif
		If AllTrim(var1) $ "ITEM PEDIDO COD.SELCO COD.CLIENTE CODSELCO CODCLIENTE"
			If t = 1;     oCont1:disable()
			ElseIf t = 2; oCont2:disable()						
			ElseIf t = 3; oCont3:disable()						
			ElseIf t = 4; oCont4:disable()						
			ElseIf t = 5; oCont5:disable()						
			ElseIf t = 6; oCont6:disable()						
			ElseIf t = 7; oCont7:disable()						
			ElseIf t = 8; oCont8:disable()						
			ElseIf t = 9; oCont9:disable()						
			Endif
		Endif
	Next t
ElseIf Alltrim(_cpo) $ "CODSELCO COD.SELCO" .and. Alltrim(SB1->B1_COD) = AllTrim(&_var)
	For t := 1 to 9
		var1 := "_cTit"+str(t,1)
		var2 := "_cCont"+str(t,1)
		var1:= strtran(&var1," ","")
		var1:= strtran(var1,".","")
		If AllTrim(var1) $ "COD.CLIENTE CODCLIENTE"
			&var2 := SB1->B1_CODPRO
		ElseIf AllTrim(var1) $ "PECA"
			&var2 := SB1->B1_DESC
		Endif
		
	Next t
Endif		
 
Return .T.

Static Function fIniVar()
////////////////////////
//_cCod := space(12)
_cDesc := space(40)
_nLacre := 0
_cTit1  := space(12)
_cCont1 := space(30)
_cTit2  := space(12)
_cCont2 := space(30)
_cTit3 := space(12)
_cCont3 := space(30)
_cTit4  := space(12)
_cCont4 := space(30)
_cTit5  := space(12)
_cCont5 := space(30)
_cTit6  := space(12)
_cCont6 := space(30)
_cTit7  := space(12)
_cCont7 := space(30)
_cTit8  := space(12)
_cCont8 := space(30)
_cTit9  := space(12)
_cCont9 := space(20)
_cCont9b := space(1)
Return

Static Function fGrava()
////////////////////////
SZ9->Z9_FILIAL := xfilial("SZ9")
SZ9->Z9_COD    := _cCod
SZ9->Z9_DESC   := _cDesc
SZ9->Z9_LACRE  := _nLacre
SZ9->Z9_TIT1   := _cTit1
SZ9->Z9_CONT1  := _cCont1
SZ9->Z9_TIT2   := _cTit2
SZ9->Z9_CONT2  := _cCont2
SZ9->Z9_TIT3   := _cTit3
SZ9->Z9_CONT3  := _cCont3
SZ9->Z9_TIT4   := _cTit4
SZ9->Z9_CONT4  := _cCont4
SZ9->Z9_TIT5   := _cTit5
SZ9->Z9_CONT5  := _cCont5
SZ9->Z9_TIT6   := _cTit6
SZ9->Z9_CONT6  := _cCont6
SZ9->Z9_TIT7   := _cTit7
SZ9->Z9_CONT7  := _cCont7
SZ9->Z9_TIT8   := _cTit8
SZ9->Z9_CONT8  := _cCont8
SZ9->Z9_TIT9   := _cTit9
SZ9->Z9_CONT9  := _cCont9
//SZ9->Z9_TEMLAC := _cCont9b

Return 

Static Function fVarVal()
////////////////////////
_cCod   := SZ9->Z9_COD    
_cDesc  := SZ9->Z9_DESC
_nLacre := SZ9->Z9_LACRE
_cTit1  := SZ9->Z9_TIT1
_cCont1 := SZ9->Z9_CONT1
_cTit2  := SZ9->Z9_TIT2
_cCont2 := SZ9->Z9_CONT2
_cTit3  := SZ9->Z9_TIT3
_cCont3 := SZ9->Z9_CONT3
_cTit4  := SZ9->Z9_TIT4
_cCont4 := SZ9->Z9_CONT4
_cTit5  := SZ9->Z9_TIT5
_cCont5 := SZ9->Z9_CONT5
_cTit6  := SZ9->Z9_TIT6
_cCont6 := SZ9->Z9_CONT6
_cTit7  := SZ9->Z9_TIT7
_cCont7 := SZ9->Z9_CONT7
_cTit8  := SZ9->Z9_TIT8
_cCont8 := SZ9->Z9_CONT8
_cTit9  := SZ9->Z9_TIT9
_cCont9 := SZ9->Z9_CONT9
_cCont9b:= " "
//_cCont9b:= SZ9->Z9_TEMLAC 
Return

*
*** Quadro 01
*
*

Static Function fColeta()

Local oQuadro1,oTxt1,oTxt2,oCod,oLacre,oCaixa1,oTxt3,oTxt4,oTxt5,oTxt6,oTxt7,oTxt8,oTxt9,oTxt10,oTxt11,oDesc,oTit1,oCont1,oTit2,oCont2,oTit3,oCont3,oTit4,oCont4,oTit5,oCont5,oTit6,oCont6,oTit7,oCont7,oTit8,oCont8,oTit9,oTxt13,oCont9,oTxt12,oCont9b,oBotao1,oBotao2,oBotao3,oBotao4,oBotao5
oQuadro1 := MSDIALOG():Create()
oQuadro1:cName := "oQuadro1"
oQuadro1:cCaption := "Cadastro de Etiquetas"
oQuadro1:nLeft := 0
oQuadro1:nTop := 0
oQuadro1:nWidth := 539
oQuadro1:nHeight := 334
oQuadro1:lShowHint := .T.
oQuadro1:lCentered := .T.

oTxt1 := TSAY():Create(oQuadro1)
oTxt1:cName := "oTxt1"
oTxt1:cCaption := "Nome da Etiqueta"
oTxt1:nLeft := 14
oTxt1:nTop := 14
oTxt1:nWidth := 95
oTxt1:nHeight := 17
oTxt1:lShowHint := .F.
oTxt1:lReadOnly := .F.
oTxt1:Align := 0
oTxt1:lVisibleControl := .T.
oTxt1:lWordWrap := .F.
oTxt1:lTransparent := .F.

oTxt2 := TSAY():Create(oQuadro1)
oTxt2:cName := "oTxt2"
oTxt2:cCaption := "Lacre"
oTxt2:nLeft := 303
oTxt2:nTop := 13
oTxt2:nWidth := 33
oTxt2:nHeight := 17
oTxt2:lShowHint := .F.
oTxt2:lReadOnly := .F.
oTxt2:Align := 0
oTxt2:lVisibleControl := .T.
oTxt2:lWordWrap := .F.
oTxt2:lTransparent := .F.

oCod := TGET():Create(oQuadro1)
oCod:cF3 := "SZ9"
oCod:cName := "oCod"
oCod:nLeft := 115
oCod:nTop := 13
oCod:nWidth := 147
oCod:nHeight := 21
oCod:lShowHint := .F.
oCod:lReadOnly := .F.
oCod:Align := 0
oCod:cVariable := "_cCod"
oCod:bSetGet := {|u| If(PCount()>0,_cCod:=u,_cCod) }
oCod:lVisibleControl := .T.
oCod:lPassword := .F.
oCod:Picture := "@!"
oCod:lHasButton := .F.
oCod:bValid := {|| fValCod(oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oLacre := TGET():Create(oQuadro1)
oLacre:cName := "oLacre"
oLacre:nLeft := 339
oLacre:nTop := 12
oLacre:nWidth := 140
oLacre:nHeight := 21
oLacre:lShowHint := .F.
oLacre:lReadOnly := .F.
oLacre:Align := 0
oLacre:cVariable := "_nLacre"
oLacre:bSetGet := {|u| If(PCount()>0,_nLacre:=u,_nLacre) }
oLacre:lVisibleControl := .T.
oLacre:lPassword := .F.
oLacre:Picture := "99999999"
oLacre:lHasButton := .F.

oCaixa1 := TGROUP():Create(oQuadro1)
oCaixa1:cName := "oCaixa1"
oCaixa1:cCaption := "Etiqueta"
oCaixa1:nLeft := 10
oCaixa1:nTop := 61
oCaixa1:nWidth := 444
oCaixa1:nHeight := 227
oCaixa1:lShowHint := .F.
oCaixa1:lReadOnly := .F.
oCaixa1:Align := 0
oCaixa1:lVisibleControl := .T.

oTxt3 := TSAY():Create(oQuadro1)
oTxt3:cName := "oTxt3"
oTxt3:cCaption := "Linha 1"
oTxt3:nLeft := 20
oTxt3:nTop := 82
oTxt3:nWidth := 40
oTxt3:nHeight := 17
oTxt3:lShowHint := .F.
oTxt3:lReadOnly := .F.
oTxt3:Align := 0
oTxt3:lVisibleControl := .T.
oTxt3:lWordWrap := .F.
oTxt3:lTransparent := .F.

oTxt4 := TSAY():Create(oQuadro1)
oTxt4:cName := "oTxt4"
oTxt4:cCaption := "Linha2"
oTxt4:nLeft := 20
oTxt4:nTop := 104
oTxt4:nWidth := 40
oTxt4:nHeight := 17
oTxt4:lShowHint := .F.
oTxt4:lReadOnly := .F.
oTxt4:Align := 0
oTxt4:lVisibleControl := .T.
oTxt4:lWordWrap := .F.
oTxt4:lTransparent := .F.

oTxt5 := TSAY():Create(oQuadro1)
oTxt5:cName := "oTxt5"
oTxt5:cCaption := "Linha 3"
oTxt5:nLeft := 20
oTxt5:nTop := 126
oTxt5:nWidth := 40
oTxt5:nHeight := 17
oTxt5:lShowHint := .F.
oTxt5:lReadOnly := .F.
oTxt5:Align := 0
oTxt5:lVisibleControl := .T.
oTxt5:lWordWrap := .F.
oTxt5:lTransparent := .F.

oTxt6 := TSAY():Create(oQuadro1)
oTxt6:cName := "oTxt6"
oTxt6:cCaption := "Linha 4"
oTxt6:nLeft := 20
oTxt6:nTop := 148
oTxt6:nWidth := 40
oTxt6:nHeight := 17
oTxt6:lShowHint := .F.
oTxt6:lReadOnly := .F.
oTxt6:Align := 0
oTxt6:lVisibleControl := .T.
oTxt6:lWordWrap := .F.
oTxt6:lTransparent := .F.

oTxt7 := TSAY():Create(oQuadro1)
oTxt7:cName := "oTxt7"
oTxt7:cCaption := "Linha 5"
oTxt7:nLeft := 20
oTxt7:nTop := 170
oTxt7:nWidth := 40
oTxt7:nHeight := 17
oTxt7:lShowHint := .F.
oTxt7:lReadOnly := .F.
oTxt7:Align := 0
oTxt7:lVisibleControl := .T.
oTxt7:lWordWrap := .F.
oTxt7:lTransparent := .F.

oTxt8 := TSAY():Create(oQuadro1)
oTxt8:cName := "oTxt8"
oTxt8:cCaption := "Linha 6"
oTxt8:nLeft := 20
oTxt8:nTop := 192
oTxt8:nWidth := 40
oTxt8:nHeight := 17
oTxt8:lShowHint := .F.
oTxt8:lReadOnly := .F.
oTxt8:Align := 0
oTxt8:lVisibleControl := .T.
oTxt8:lWordWrap := .F.
oTxt8:lTransparent := .F.

oTxt9 := TSAY():Create(oQuadro1)
oTxt9:cName := "oTxt9"
oTxt9:cCaption := "Linha 7"
oTxt9:nLeft := 20
oTxt9:nTop := 214
oTxt9:nWidth := 40
oTxt9:nHeight := 17
oTxt9:lShowHint := .F.
oTxt9:lReadOnly := .F.
oTxt9:Align := 0
oTxt9:lVisibleControl := .T.
oTxt9:lWordWrap := .F.
oTxt9:lTransparent := .F.

oTxt10 := TSAY():Create(oQuadro1)
oTxt10:cName := "oTxt10"
oTxt10:cCaption := "Linha 8"
oTxt10:nLeft := 20
oTxt10:nTop := 236
oTxt10:nWidth := 40
oTxt10:nHeight := 17
oTxt10:lShowHint := .F.
oTxt10:lReadOnly := .F.
oTxt10:Align := 0
oTxt10:lVisibleControl := .T.
oTxt10:lWordWrap := .F.
oTxt10:lTransparent := .F.

oTxt11 := TSAY():Create(oQuadro1)
oTxt11:cName := "oTxt11"
oTxt11:cCaption := "Linha 9"
oTxt11:nLeft := 20
oTxt11:nTop := 258
oTxt11:nWidth := 44
oTxt11:nHeight := 17
oTxt11:lShowHint := .F.
oTxt11:lReadOnly := .F.
oTxt11:Align := 0
oTxt11:lVisibleControl := .T.
oTxt11:lWordWrap := .F.
oTxt11:lTransparent := .F.

oDesc := TGET():Create(oQuadro1)
oDesc:cName := "oDesc"
oDesc:nLeft := 115
oDesc:nTop := 36
oDesc:nWidth := 364
oDesc:nHeight := 21
oDesc:lShowHint := .F.
oDesc:lReadOnly := .F.
oDesc:Align := 0
oDesc:cVariable := "_cDesc"
oDesc:bSetGet := {|u| If(PCount()>0,_cDesc:=u,_cDesc) }
oDesc:lVisibleControl := .T.
oDesc:lPassword := .F.
oDesc:Picture := "@!"
oDesc:lHasButton := .F.

oTit1 := TGET():Create(oQuadro1)
oTit1:cName := "oTit1"
oTit1:nLeft := 65
oTit1:nTop := 82
oTit1:nWidth := 95
oTit1:nHeight := 21
oTit1:lShowHint := .F.
oTit1:lReadOnly := .F.
oTit1:Align := 0
oTit1:cVariable := "_cTit1"
oTit1:bSetGet := {|u| If(PCount()>0,_cTit1:=u,_cTit1) }
oTit1:lVisibleControl := .T.
oTit1:lPassword := .F.
oTit1:Picture := "@!"
oTit1:lHasButton := .F.
oTit1:bValid := {|| fFacil("1",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oCont1 := TGET():Create(oQuadro1)
oCont1:cName := "oCont1"
oCont1:nLeft := 180
oCont1:nTop := 81
oCont1:nWidth := 255
oCont1:nHeight := 21
oCont1:lShowHint := .F.
oCont1:lReadOnly := .F.
oCont1:Align := 0
oCont1:cVariable := "_cCont1"
oCont1:bSetGet := {|u| If(PCount()>0,_cCont1:=u,_cCont1) }
oCont1:lVisibleControl := .T.
oCont1:lPassword := .F.
oCont1:Picture := "@!"
oCont1:lHasButton := .F.
oCont1:bValid := {|| fTrataAF("1",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oTit2 := TGET():Create(oQuadro1)
oTit2:cName := "oTit2"
oTit2:nLeft := 65
oTit2:nTop := 103
oTit2:nWidth := 95
oTit2:nHeight := 21
oTit2:lShowHint := .F.
oTit2:lReadOnly := .F.
oTit2:Align := 0
oTit2:cVariable := "_cTit2"
oTit2:bSetGet := {|u| If(PCount()>0,_cTit2:=u,_cTit2) }
oTit2:lVisibleControl := .T.
oTit2:lPassword := .F.
oTit2:Picture := "@!"
oTit2:lHasButton := .F.
oTit2:bValid := {|| fFacil("2",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oCont2 := TGET():Create(oQuadro1)
oCont2:cName := "oCont2"
oCont2:nLeft := 180
oCont2:nTop := 103
oCont2:nWidth := 255
oCont2:nHeight := 21
oCont2:lShowHint := .F.
oCont2:lReadOnly := .F.
oCont2:Align := 0
oCont2:cVariable := "_cCont2"
oCont2:bSetGet := {|u| If(PCount()>0,_cCont2:=u,_cCont2) }
oCont2:lVisibleControl := .T.
oCont2:lPassword := .F.
oCont2:Picture := "@!"
oCont2:lHasButton := .F.
oCont2:bValid := {|| fTrataAF("2",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oTit3 := TGET():Create(oQuadro1)
oTit3:cName := "oTit3"
oTit3:nLeft := 65
oTit3:nTop := 125
oTit3:nWidth := 95
oTit3:nHeight := 21
oTit3:lShowHint := .F.
oTit3:lReadOnly := .F.
oTit3:Align := 0
oTit3:cVariable := "_cTit3"
oTit3:bSetGet := {|u| If(PCount()>0,_cTit3:=u,_cTit3) }
oTit3:lVisibleControl := .T.
oTit3:lPassword := .F.
oTit3:Picture := "@!"
oTit3:lHasButton := .F.
oTit3:bValid := {|| fFacil("3",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oCont3 := TGET():Create(oQuadro1)
oCont3:cName := "oCont3"
oCont3:nLeft := 180
oCont3:nTop := 125
oCont3:nWidth := 255
oCont3:nHeight := 21
oCont3:lShowHint := .F.
oCont3:lReadOnly := .F.
oCont3:Align := 0
oCont3:cVariable := "_cCont3"
oCont3:bSetGet := {|u| If(PCount()>0,_cCont3:=u,_cCont3) }
oCont3:lVisibleControl := .T.
oCont3:lPassword := .F.
oCont3:Picture := "@!"
oCont3:lHasButton := .F.
oCont3:bValid := {|| fTrataAF("3",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oTit4 := TGET():Create(oQuadro1)
oTit4:cName := "oTit4"
oTit4:nLeft := 65
oTit4:nTop := 147
oTit4:nWidth := 95
oTit4:nHeight := 21
oTit4:lShowHint := .F.
oTit4:lReadOnly := .F.
oTit4:Align := 0
oTit4:cVariable := "_cTit4"
oTit4:bSetGet := {|u| If(PCount()>0,_cTit4:=u,_cTit4) }
oTit4:lVisibleControl := .T.
oTit4:lPassword := .F.
oTit4:Picture := "@!"
oTit4:lHasButton := .F.
oTit4:bValid := {|| fFacil("4",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oCont4 := TGET():Create(oQuadro1)
oCont4:cName := "oCont4"
oCont4:nLeft := 180
oCont4:nTop := 147
oCont4:nWidth := 255
oCont4:nHeight := 21
oCont4:lShowHint := .F.
oCont4:lReadOnly := .F.
oCont4:Align := 0
oCont4:cVariable := "_cCont4"
oCont4:bSetGet := {|u| If(PCount()>0,_cCont4:=u,_cCont4) }
oCont4:lVisibleControl := .T.
oCont4:lPassword := .F.
oCont4:Picture := "@!"
oCont4:lHasButton := .F.
oCont4:bValid := {|| fTrataAF("4",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oTit5 := TGET():Create(oQuadro1)
oTit5:cName := "oTit5"
oTit5:nLeft := 65
oTit5:nTop := 169
oTit5:nWidth := 95
oTit5:nHeight := 21
oTit5:lShowHint := .F.
oTit5:lReadOnly := .F.
oTit5:Align := 0
oTit5:cVariable := "_cTit5"
oTit5:bSetGet := {|u| If(PCount()>0,_cTit5:=u,_cTit5) }
oTit5:lVisibleControl := .T.
oTit5:lPassword := .F.
oTit5:Picture := "@!"
oTit5:lHasButton := .F.
oTit5:bValid := {|| fFacil("5",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oCont5 := TGET():Create(oQuadro1)
oCont5:cName := "oCont5"
oCont5:nLeft := 180
oCont5:nTop := 169
oCont5:nWidth := 255
oCont5:nHeight := 21
oCont5:lShowHint := .F.
oCont5:lReadOnly := .F.
oCont5:Align := 0
oCont5:cVariable := "_cCont5"
oCont5:bSetGet := {|u| If(PCount()>0,_cCont5:=u,_cCont5) }
oCont5:lVisibleControl := .T.
oCont5:lPassword := .F.
oCont5:Picture := "@!"
oCont5:lHasButton := .F.
oCont5:bValid := {|| fTrataAF("5",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oTit6 := TGET():Create(oQuadro1)
oTit6:cName := "oTit6"
oTit6:nLeft := 65
oTit6:nTop := 191
oTit6:nWidth := 95
oTit6:nHeight := 21
oTit6:lShowHint := .F.
oTit6:lReadOnly := .F.
oTit6:Align := 0
oTit6:cVariable := "_cTit6"
oTit6:bSetGet := {|u| If(PCount()>0,_cTit6:=u,_cTit6) }
oTit6:lVisibleControl := .T.
oTit6:lPassword := .F.
oTit6:Picture := "@!"
oTit6:lHasButton := .F.
oTit6:bValid := {|| fFacil("6",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oCont6 := TGET():Create(oQuadro1)
oCont6:cName := "oCont6"
oCont6:nLeft := 180
oCont6:nTop := 191
oCont6:nWidth := 255
oCont6:nHeight := 21
oCont6:lShowHint := .F.
oCont6:lReadOnly := .F.
oCont6:Align := 0
oCont6:cVariable := "_cCont6"
oCont6:bSetGet := {|u| If(PCount()>0,_cCont6:=u,_cCont6) }
oCont6:lVisibleControl := .T.
oCont6:lPassword := .F.
oCont6:Picture := "@!"
oCont6:lHasButton := .F.
oCont6:bValid := {|| fTrataAF("6",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oTit7 := TGET():Create(oQuadro1)
oTit7:cName := "oTit7"
oTit7:nLeft := 65
oTit7:nTop := 213
oTit7:nWidth := 95
oTit7:nHeight := 21
oTit7:lShowHint := .F.
oTit7:lReadOnly := .F.
oTit7:Align := 0
oTit7:cVariable := "_cTit7"
oTit7:bSetGet := {|u| If(PCount()>0,_cTit7:=u,_cTit7) }
oTit7:lVisibleControl := .T.
oTit7:lPassword := .F.
oTit7:Picture := "@!"
oTit7:lHasButton := .F.
oTit7:bValid := {|| fFacil("7",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oCont7 := TGET():Create(oQuadro1)
oCont7:cName := "oCont7"
oCont7:nLeft := 180
oCont7:nTop := 213
oCont7:nWidth := 255
oCont7:nHeight := 21
oCont7:lShowHint := .F.
oCont7:lReadOnly := .F.
oCont7:Align := 0
oCont7:cVariable := "_cCont7"
oCont7:bSetGet := {|u| If(PCount()>0,_cCont7:=u,_cCont7) }
oCont7:lVisibleControl := .T.
oCont7:lPassword := .F.
oCont7:Picture := "@!"
oCont7:lHasButton := .F.
oCont7:bValid := {|| fTrataAF("7",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oTit8 := TGET():Create(oQuadro1)
oTit8:cName := "oTit8"
oTit8:nLeft := 65
oTit8:nTop := 235
oTit8:nWidth := 95
oTit8:nHeight := 21
oTit8:lShowHint := .F.
oTit8:lReadOnly := .F.
oTit8:Align := 0
oTit8:cVariable := "_cTit8"
oTit8:bSetGet := {|u| If(PCount()>0,_cTit8:=u,_cTit8) }
oTit8:lVisibleControl := .T.
oTit8:lPassword := .F.
oTit8:Picture := "@!"
oTit8:lHasButton := .F.
oTit8:bValid := {|| fFacil("8",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oCont8 := TGET():Create(oQuadro1)
oCont8:cName := "oCont8"
oCont8:nLeft := 180
oCont8:nTop := 235
oCont8:nWidth := 255
oCont8:nHeight := 21
oCont8:lShowHint := .F.
oCont8:lReadOnly := .F.
oCont8:Align := 0
oCont8:cVariable := "_cCont8"
oCont8:bSetGet := {|u| If(PCount()>0,_cCont8:=u,_cCont8) }
oCont8:lVisibleControl := .T.
oCont8:lPassword := .F.
oCont8:Picture := "@!"
oCont8:lHasButton := .F.
oCont8:bValid := {|| fTrataAF("8",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oTit9 := TGET():Create(oQuadro1)
oTit9:cName := "oTit9"
oTit9:nLeft := 65
oTit9:nTop := 257
oTit9:nWidth := 95
oTit9:nHeight := 21
oTit9:lShowHint := .F.
oTit9:lReadOnly := .F.
oTit9:Align := 0
oTit9:cVariable := "_cTit9"
oTit9:bSetGet := {|u| If(PCount()>0,_cTit9:=u,_cTit9) }
oTit9:lVisibleControl := .T.
oTit9:lPassword := .F.
oTit9:Picture := "@!"
oTit9:lHasButton := .F.
oTit9:bValid := {|| fFacil("9",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oTxt13 := TSAY():Create(oQuadro1)
oTxt13:cName := "oTxt13"
oTxt13:cCaption := "Descricao"
oTxt13:nLeft := 17
oTxt13:nTop := 34
oTxt13:nWidth := 65
oTxt13:nHeight := 17
oTxt13:lShowHint := .F.
oTxt13:lReadOnly := .F.
oTxt13:Align := 0
oTxt13:lVisibleControl := .T.
oTxt13:lWordWrap := .F.
oTxt13:lTransparent := .F.

oCont9 := TGET():Create(oQuadro1)
oCont9:cName := "oCont9"
oCont9:nLeft := 180
oCont9:nTop := 257
oCont9:nWidth := 189
oCont9:nHeight := 21
oCont9:lShowHint := .F.
oCont9:lReadOnly := .F.
oCont9:Align := 0
oCont9:cVariable := "_cCont9"
oCont9:bSetGet := {|u| If(PCount()>0,_cCont9:=u,_cCont9) }
oCont9:lVisibleControl := .T.
oCont9:lPassword := .F.
oCont9:Picture := "@!"
oCont9:lHasButton := .F.
oCont9:bValid := {|| fTrataAF("9",oCont1,oCont2,oCont3,oCont4,oCont5,oCont6,oCont7,oCont8,oCont9) }

oTxt12 := TSAY():Create(oQuadro1)
oTxt12:cName := "oTxt12"
oTxt12:cCaption := "Lacre"
oTxt12:nLeft := 374
oTxt12:nTop := 260
oTxt12:nWidth := 37
oTxt12:nHeight := 17
oTxt12:lShowHint := .F.
oTxt12:lReadOnly := .F.
oTxt12:Align := 0
oTxt12:lVisibleControl := .T.
oTxt12:lWordWrap := .F.
oTxt12:lTransparent := .F.

oCont9b := TGET():Create(oQuadro1)
oCont9b:cName := "oCont9b"
oCont9b:nLeft := 412
oCont9b:nTop := 257
oCont9b:nWidth := 22
oCont9b:nHeight := 21
oCont9b:lShowHint := .F.
oCont9b:lReadOnly := .F.
oCont9b:Align := 0
oCont9b:cVariable := "_cCont9b"
oCont9b:bSetGet := {|u| If(PCount()>0,_cCont9b:=u,_cCont9b) }
oCont9b:lVisibleControl := .T.
oCont9b:lPassword := .F.
oCont9b:Picture := "@!"
oCont9b:lHasButton := .F.
oCont9b:bValid := {|| PERTENCE("SN") }

oBotao1 := SBUTTON():Create(oQuadro1)
oBotao1:cName := "oBotao1"
oBotao1:cCaption := "Incluir"
oBotao1:cToolTip := "Incluir Etiquetas"
oBotao1:nLeft := 466
oBotao1:nTop := 90
oBotao1:nWidth := 52
oBotao1:nHeight := 22
oBotao1:lShowHint := .T.
oBotao1:lReadOnly := .F.
oBotao1:Align := 0
oBotao1:lVisibleControl := .T.
oBotao1:nType := 4
oBotao1:bLClicked := {|| fInclui() }

oBotao2 := SBUTTON():Create(oQuadro1)
oBotao2:cName := "oBotao2"
oBotao2:cCaption := "Editar"
oBotao2:cToolTip := "Editar Etiqueta"
oBotao2:nLeft := 466
oBotao2:nTop := 120
oBotao2:nWidth := 52
oBotao2:nHeight := 22
oBotao2:lShowHint := .T.
oBotao2:lReadOnly := .F.
oBotao2:Align := 0
oBotao2:lVisibleControl := .T.
oBotao2:nType := 11
oBotao2:bLClicked := {|| fEdita() }

oBotao3 := SBUTTON():Create(oQuadro1)
oBotao3:cName := "oBotao3"
oBotao3:cCaption := "Exclui"
oBotao3:cToolTip := "Excluir Etiqueta"
oBotao3:nLeft := 466
oBotao3:nTop := 150
oBotao3:nWidth := 52
oBotao3:nHeight := 22
oBotao3:lShowHint := .T.
oBotao3:lReadOnly := .F.
oBotao3:Align := 0
oBotao3:lVisibleControl := .T.
oBotao3:nType := 3
oBotao3:bLClicked := {|| fExclui() }

oBotao4 := SBUTTON():Create(oQuadro1)
oBotao4:cName := "oBotao4"
oBotao4:cCaption := "Imprimir"
oBotao4:nLeft := 466
oBotao4:nTop := 180
oBotao4:nWidth := 52
oBotao4:nHeight := 22
oBotao4:lShowHint := .T.
oBotao4:lReadOnly := .F.
oBotao4:Align := 0
oBotao4:lVisibleControl := .T.
oBotao4:nType := 9
oBotao4:bLClicked := {|| fImprimi() }

oBotao5 := SBUTTON():Create(oQuadro1)
oBotao5:cName := "oBotao5"
oBotao5:cCaption := "Cancelar"
oBotao5:cToolTip := "Cancela Operação"
oBotao5:nLeft := 466
oBotao5:nTop := 210
oBotao5:nWidth := 52
oBotao5:nHeight := 22
oBotao5:lShowHint := .T.
oBotao5:lReadOnly := .F.
oBotao5:Align := 0
oBotao5:lVisibleControl := .T.
oBotao5:nType := 2
oBotao5:bLClicked := {|| Close(oQuadro1) }

oQuadro1:Activate()

Return

*
*** Quadro 02
*
*

Static Function fImpOK()

Local oQuadro2,oTxt1,oCopia,oBtOK,oBtCan,oTxt2,oOp
oQuadro2 := MSDIALOG():Create()
oQuadro2:cName := "oQuadro2"
oQuadro2:cCaption := "Impressão"
oQuadro2:nLeft := 0
oQuadro2:nTop := 0
oQuadro2:nWidth := 294
oQuadro2:nHeight := 211
oQuadro2:lShowHint := .T.
oQuadro2:lCentered := .T.

oTxt1 := TSAY():Create(oQuadro2)
oTxt1:cName := "oTxt1"
oTxt1:cCaption := "Número de Cópias"
oTxt1:nLeft := 20
oTxt1:nTop := 99
oTxt1:nWidth := 96
oTxt1:nHeight := 17
oTxt1:lShowHint := .F.
oTxt1:lReadOnly := .F.
oTxt1:Align := 0
oTxt1:lVisibleControl := .T.
oTxt1:lWordWrap := .F.
oTxt1:lTransparent := .T.

oCopia := TGET():Create(oQuadro2)
oCopia:cName := "oCopia"
oCopia:nLeft := 127
oCopia:nTop := 94
oCopia:nWidth := 121
oCopia:nHeight := 21
oCopia:lShowHint := .F.
oCopia:lReadOnly := .F.
oCopia:Align := 0
oCopia:cVariable := "_nCopia"
oCopia:bSetGet := {|u| If(PCount()>0,_nCopia:=u,_nCopia) }
oCopia:lVisibleControl := .T.
oCopia:lPassword := .F.
oCopia:Picture := "999999"
oCopia:lHasButton := .F.

oBtOK := SBUTTON():Create(oQuadro2)
oBtOK:cName := "oBtOK"
oBtOK:cCaption := "oSBtn3"
oBtOK:nLeft := 116
oBtOK:nTop := 140
oBtOK:nWidth := 52
oBtOK:nHeight := 22
oBtOK:lShowHint := .F.
oBtOK:lReadOnly := .F.
oBtOK:Align := 0
oBtOK:lVisibleControl := .T.
oBtOK:nType := 1
oBtOK:bLClicked := {|| fImpreti(oQuadro2) }

oBtCan := SBUTTON():Create(oQuadro2)
oBtCan:cName := "oBtCan"
oBtCan:nLeft := 212
oBtCan:nTop := 140
oBtCan:nWidth := 52
oBtCan:nHeight := 22
oBtCan:lShowHint := .F.
oBtCan:lReadOnly := .F.
oBtCan:Align := 0
oBtCan:lVisibleControl := .T.
oBtCan:nType := 2
oBtCan:bLClicked := {|| Close(oQuadro2) }

oTxt2 := TSAY():Create(oQuadro2)
oTxt2:cName := "oTxt2"
oTxt2:cCaption := "Tipo de Impressão"
oTxt2:nLeft := 20
oTxt2:nTop := 34
oTxt2:nWidth := 94
oTxt2:nHeight := 17
oTxt2:lShowHint := .F.
oTxt2:lReadOnly := .F.
oTxt2:Align := 0
oTxt2:lVisibleControl := .T.
oTxt2:lWordWrap := .F.
oTxt2:lTransparent := .T.

oOp := TRADMENU():Create(oQuadro2)
oOp:cName := "oOp"
oOp:nLeft := 126
oOp:nTop := 9
oOp:nWidth := 71
oOp:nHeight := 76
oOp:lShowHint := .F.
oOp:lReadOnly := .F.
oOp:Align := 0
oOp:cVariable := "_nOp"
oOp:bSetGet := {|u| If(PCount()>0,_nOp:=u,_nOp) }
oOp:lVisibleControl := .T.
oOp:nOption := 0
oOp:aItems := { "Normal","Térmica","Gráfica"}

oQuadro2:Activate()

Return