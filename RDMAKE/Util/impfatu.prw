#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

User function ExpFatu()
Local cQry:=""
Local aStru:={}
Local cDbf
dbSelectArea("SE1")
aStru:=SE1->(dbStruct())

cDbf	:= criatrab(aStru)
Use &cDbf Alias cDbf New
cInd1	:= CriaTrab("",.F.)
IndRegua("cDbf",cInd1,"E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
dbSetIndex( cInd1 +OrdBagExt())

cQry:="SELECT SE1.* "
cQry+="  FROM "+RetSqlName("SE1")+" SE1," +RetSqlName("SA1")+" SA1"
cQry+=" WHERE SE1.E1_FILIAL IN ('03','08')"
cQry+="   AND SA1.A1_FILIAL = '  '"
cQry+="   AND SE1.E1_EMISSAO BETWEEN '20070301' AND '20070331'"
cQry+="   AND SE1.E1_CLIENTE = SA1.A1_COD"
cQry+="   AND SE1.E1_LOJA    = SA1.A1_LOJA"
cQry+="   AND SA1.A1_GRUPO IN (2,4,6,9)"
cQry+="   AND SE1.D_E_L_E_T_ <> '*'"
cQry+="   AND SA1.D_E_L_E_T_ <> '*'"
TcQuery cQry Alias "TSE1" New

For ni := 1 to Len(aStru)
	If aStru[ni,2] != 'C'
		TCSetField('TSE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
	Endif
Next

While !Eof()
	RecLock("cDbf",.t.)
		For nX:=1 to len(aStru)
			cCampo:=aStru[nX,1]
			cDbf->&(cCampo) := TSE1->&(cCampo)
		Next nX
	MsUnLock()	
	dbSelectArea("TSE1")
    dbSkip()
EndDo
dbSelectArea("TSE1")
dbCloseArea()

CpyS2T(cDbf+".dbf", "d:\Microsiga\", .f.)
FRename("D:\Microsiga\"+cDbf+".dbf","d:\Microsiga\SE1IMP.DBF")

If FILE(cDbf+".DBF")     //Elimina o arquivo de trabalho
	dbSelectArea("cDbf")
    dbCloseArea()
    Ferase(cDbf+".DBF")
    Ferase("cInd1"+OrdBagExt())
EndIf
Return


User function ImpFatu()
//alert("ÁREA TEMP")
//return

Local cQry:=""
Local aStru:={}
Local cDbf
dbSelectArea("SE1")
dbSetOrder(2)
aStru:=SE1->(dbStruct())

cDbf	:= criatrab(aStru)
dbUseArea( .T.,cDbf, "\systemtst\se1imp.dbf","cDbf", .T., .F. )
cInd1	:= CriaTrab("",.F.)
IndRegua("cDbf",cInd1,"E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
dbSetIndex( cInd1 +OrdBagExt())
nErro:=0
While !Eof()
	dbSelectArea("SE1")
	If !dbSeek(cDbf->E1_FILIAL+cDbf->E1_CLIENTE+cDbf->E1_LOJA+cDbf->E1_PREFIXO+cDbf->E1_NUM+cDbf->E1_PARCELA+cDbf->E1_TIPO)
		RecLock("SE1",.T.)
			For nX:=1 to len(aStru)
				cCampo:=aStru[nX,1]
				SE1->&(cCampo)	:=	cDbf->&(cCampo)
			Next nX
		MsUnLock()
	Else
		nErro++
	EndIf
	dbSelectArea("cDbf")
	dbSkip()
EndDo
alert(nErro)
dbSelectArea("cDbf")
dbCloseArea()
Return
