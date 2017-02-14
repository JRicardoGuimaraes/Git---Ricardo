#include "rwmake.ch"
#include "protheus.ch"
#define DMPAPER_A4 9
User Function REST003()
	local oReport
	local cPerg := PadR('REST003',10)
 
	oReport := reportDef()
	oReport:printDialog()
Return
 
static function reportDef()
	local oReport
	Local oSection1
	Local oSection2
	local cTitulo := '[REST003] - Impressão de Produtos'
 
	oReport := TReport():New('REST003', cTitulo, , {|oReport| PrintReport(oReport)},"Este relatorio ira imprimir a relacao de produtos.")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()
 
	oSection1 := TRSection():New(oReport,"Filial",{"QRY"})
	oSection1:SetTotalInLine(.F.)
 
	TRCell():New(oSection1, "B1_FILIAL"	, "QRY", 'FILIAL'	,PesqPict('SB1',"B1_FILIAL"),TamSX3("B1_FILIAL")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "B1_CODMES"	, "QRY", 'COD.MES'	,PesqPict('SB1',"B1_CODMES"),TamSX3("B1_CODMES")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "B1_SUFIXO"	, "QRY", 'SUFIXO'	,PesqPict('SB1',"B1_SUFIXO"),TamSX3("B1_SUFIXO")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "B1_COD"	, "QRY", 'COD.INT'	,PesqPict('SB1',"B1_COD")	,TamSX3("B1_COD")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "B1_REFFAB"	, "QRY", 'REF.FAB'	,PesqPict('SB1',"B1_REFFAB"),TamSX3("B1_REFFAB")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "B1_DESC"	, "QRY", 'DESCRIÇÃO',PesqPict('SB1',"B1_DESC")	,TamSX3("B1_DESC")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "Z5_ABREV"	, "QRY", 'ABREVI'	,PesqPict('SZ5',"Z5_ABREV")	,TamSX3("Z5_ABREV")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "B1_TIPO"	, "QRY", 'TIPO'  	,PesqPict('SB1',"B1_TIPO")	,TamSX3("B1_TIPO")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "BM_DESC"	, "QRY", 'GRUPO'	,PesqPict('SBM',"BM_DESC")	,TamSX3("BM_DESC")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "VE1_DESMAR", "QRY", 'MARCA'	,PesqPict('VE1',"VE1_DESMAR"),TamSX3("VE1_DESMAR")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
 
	oBreak := TRBreak():New(oSection1,oSection1:Cell("B1_FILIAL"),,.F.)
 
	TRFunction():New(oSection1:Cell("B1_FILIAL"),"TOTAL FILIAL","COUNT",oBreak,,"@E 999999",,.F.,.F.)
 
	TRFunction():New(oSection1:Cell("B1_FILIAL"),"TOTAL GERAL" ,"COUNT",,,"@E 999999",,.F.,.T.)	
 
return (oReport)
 
Static Function PrintReport(oReport)
	Local oSection1 := oReport:Section(1)
	oSection1:Init()
	oSection1:SetHeaderSection(.T.)
 
	DbSelectArea('QRY')
	dbGoTop()
	oReport:SetMeter(QRY->(RecCount()))
	While QRY->(!Eof())
		If oReport:Cancel()
			Exit
		EndIf
 
		oReport:IncMeter()
 
		oSection1:Cell("B1_FILIAL"):SetValue(QRY->B1_FILIAL)
		oSection1:Cell("B1_FILIAL"):SetAlign("CENTER")
 
		oSection1:Cell("B1_CODMES"):SetValue(QRY->B1_CODMES)
		oSection1:Cell("B1_CODMES"):SetAlign("CENTER")
 
		oSection1:Cell("B1_SUFIXO"):SetValue(QRY->B1_SUFIXO)
		oSection1:Cell("B1_SUFIXO"):SetAlign("CENTER")
 
		oSection1:Cell("B1_COD"):SetValue(QRY->B1_COD)
		oSection1:Cell("B1_COD"):SetAlign("CENTER")
 
		oSection1:Cell("B1_REFFAB"):SetValue(QRY->B1_REFFAB)
		oSection1:Cell("B1_REFFAB"):SetAlign("LEFT")
 
		oSection1:Cell("B1_DESC"):SetValue(QRY->B1_DESC)
		oSection1:Cell("B1_DESC"):SetAlign("LEFT")
 
		oSection1:Cell("Z5_ABREV"):SetValue(Posicione("SZ5",1,xFilial("SZ5")+QRY->B1_GRUFAM,"Z5_ABREV"))
		oSection1:Cell("Z5_ABREV"):SetAlign("LEFT")
 
		oSection1:Cell("B1_TIPO"):SetValue(QRY->B1_TIPO)
		oSection1:Cell("B1_TIPO"):SetAlign("LEFT")
 
		oSection1:Cell("BM_DESC"):SetValue(Posicione("SBM",1,xFilial("SBM")+QRY->B1_GRUPO,"BM_DESC"))
		oSection1:Cell("BM_DESC"):SetAlign("LEFT")
 
		oSection1:Cell("VE1_DESMAR"):SetValue(Posicione("VE1",2,xFilial("VE1")+QRY->B1_ABREVI,"VE1_DESMAR"))
		oSection1:Cell("VE1_DESMAR"):SetAlign("LEFT")
 
		oSection1:PrintLine()
 
		dbSelectArea("QRY")
		QRY->(dbSkip())
	EndDo
	oSection1:Finish()
Return