#include "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "AVPRINT.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GEFA005  บ Autor ณ Katia Alves Bianchiบ Data ณ  28/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de arquivo EDI DOCCOB padrใo Proceda               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gefco                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function GEFA005()
Private cPerg := Padr("GEFA005",Len(SX1->X1_GRUPO))

_CriaSx1()
If !Pergunte(cPerg,.T.)
	Return
EndIf
OkGeraTxt()

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERATXTบ Autor ณ Katia Alves Bianchiบ Data ณ  24/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao que executa a geracao do arquivo de texto.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function OkGeraTxt()
Private _cDirEnv := GetMv("MV_EDIDIRE")
Private cArqTxt	 := ""

If Right(_cDirEnv,1) # "\"
	_cDirEnv += "\"
Endif

ConOut("Gerando os dados para exportacao")
GerArq()

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ GERARQ   บ Autor ณKatia Alves Bianchi บ Data ณ  28/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para montagem do arquivo cArqTxt                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ gefco                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GerArq

Local cQuery	:= ""
Local QDT8  	:= GetNextAlias()
Local cQuery2	:= ""
Private cString	:= GetNextAlias()
Private cCgcRem := ""
Private cFilDoc := ""
Private cFilDTC	:= xFilial("DTC")
Private nQtdCtc	:= 0
Private nVlrCtc	:= 0
Private cLin		:= ""
Private lPrimeiro := .T.
Private cNomArq   := ""
Private cCgcDes   := ""
Private cTipDoc   := ""
Private cAliq		:= ""
Private cSubst	:= ""
Private cCfop		:= ""
Private _aAreaSM0 := SM0->(GetArea("SM0"))
Private cEOL		:= CHR(13)+CHR(10)
/*/ Parametros
MV_PAR01	Filial Origem de     ?
MV_PAR02	Filial Origem Ate    ?
MV_PAR03	Data de              ?
MV_PAR04	Data Ate             ?
MV_PAR05	Cliente  De          ?
MV_PAR06	Loja de              ?
MV_PAR07	Cliente ate          ?
MV_PAR08	Loja Ate             ?
/*/
cString := GetNextAlias()
cQuery	:= " SELECT DT6_FILDOC         FILDOC, "
cQuery	+= "       DT6.DT6_DOC        DOC, "
cQuery	+= "       DT6.DT6_SERIE      SERIE, "
cQuery	+= " 	   DT6.DT6_FILDCO     FILDCO, "
cQuery	+= "       DT6.DT6_DOCDCO     DOCDCO, "
cQuery	+= "       DT6.DT6_SERDCO     SERDCO, "
cQuery	+= "       DT6.DT6_CLIREM     CLIREM, "
cQuery	+= "       DT6.DT6_LOJREM     LOJREM, "
cQuery	+= "       DT6.DT6_CLIDES     CLIDES, "
cQuery	+= "       DT6.DT6_LOJDES     LOJDES, "
cQuery	+= "       DT6.DT6_TIPFRE     TIPFRE, "
cQuery	+= "       DT6.DT6_DOCTMS     DOCTMS, "
cQuery	+= "       DT6.DT6_VALTOT     VALTOT, "
cQuery	+= "       DT6.DT6_DATEMI     DATEMI, "
cQuery	+= "       DT6.DT6_HOREMI     HOREMI, "
cQuery	+= "       DT6.DT6_DECRES     DECRES, "
cQuery	+= "       DT6.DT6_PESO       PESO, "
cQuery	+= "       SF2.F2_BASEICM     BASEICM, "
cQuery	+= "       SF2.F2_VALICM      VALICM, "
cQuery	+= "       SF2.F2_ICMSRET     ICMRET, "
cQuery	+= "       SF2.F2_BRICMS      BRICMS, "
cQuery	+= "       SA1A.A1_CGC        CGCREM, "
cQuery	+= "       SA1A.A1_NOME       NOMEREM, "
cQuery	+= "       SA1B.A1_CGC        CGCDES, "
cQuery	+= "       SA1B.A1_NOME       NOMEDES, "
cQuery	+= "       SA1C.A1_CGC        CGCDEV, "
cQuery	+= "       SA1C.A1_NOME       NOMEDEV, "
cQuery	+= "       SE1.E1_FILDEB      FILDEB, "
cQuery	+= "       SE1.E1_FILIAL      FILFAT, "
cQuery	+= "       SE1.E1_TIPO        TIPO, "
cQuery	+= "       SE1.E1_NUM  		  NUMFAT, "
cQuery	+= "       SE1.E1_PREFIXO     PREFIXO, "
cQuery	+= "       SE1.E1_EMISSAO     EMISFAT, "
cQuery	+= "       SE1.E1_VENCTO      VECTO, "
cQuery	+= "       SE1.E1_VALOR       VALFAT, "
cQuery	+= "       SE1.E1_JUROS       JUROS, "
cQuery	+= "       SE1.E1_DIADESC     DIADESC, "
cQuery	+= "       SE1.E1_DECRESC     DECRESC, "
cQuery	+= "       SE1.E1_AGECHQ      AGECHQ, "
cQuery	+= "       SE1.E1_CTACHQ      CTACHQ, "
cQuery	+= "       SA6.A6_NOME        NOMBCO "

cQuery	+= " FROM "+retsqlname("SE1")+ " SE1 "

cQuery	+= " JOIN "+retsqlname("SE1")+ " SE12 ON SE1.E1_PREFIXO = SE12.E1_FATPREF "
cQuery	+= " AND SE1.E1_NUM = SE12.E1_FATURA "
cQuery	+= " AND SE1.E1_TIPO = SE12.E1_TIPOFAT "
cQuery	+= " AND SE12.E1_FILIAL = '"+xFilial("SE1")+ "' "
cQuery	+= " AND SE12.D_E_L_E_T_ = ' ' "

cQuery	+= " JOIN "+retsqlname("DT6")+ " DT6 ON SE12.E1_PREFIXO = DT6.DT6_PREFIX "
cQuery	+= "  AND SE12.E1_NUM  = DT6.DT6_DOC "
cQuery	+= "  AND SE12.E1_TIPO = DT6.DT6_TIPO "
cQuery	+= "  AND DT6_FILIAL = '"+xFilial("DT6")+ "' "
cQuery	+= "  AND DT6.D_E_L_E_T_ = ' ' "

cQuery	+= " JOIN "+retsqlname("SF2")+ " SF2 ON F2_FILIAL = DT6_FILDOC "
cQuery	+= "  AND F2_DOC = DT6_DOC "
cQuery	+= "  AND F2_SERIE = DT6_SERIE "
cQuery	+= "  AND SF2.D_E_L_E_T_ = ' ' "

cQuery	+= " JOIN "+retsqlname("SA1")+ " SA1A ON SA1A.A1_COD = DT6_CLIREM "
cQuery	+= " AND SA1A.A1_LOJA = DT6_LOJREM "
cQuery	+= " AND SA1A.A1_FILIAL = '"+xFilial("SA1")+ "' "
cQuery	+= " AND SA1A.D_E_L_E_T_ = ' ' "

cQuery	+= " JOIN "+retsqlname("SA1")+ " SA1B ON SA1B.A1_COD = DT6_CLIDES "
cQuery	+= " AND SA1B.A1_LOJA = DT6_LOJDES "
cQuery	+= " AND SA1B.A1_FILIAL = '"+xFilial("SA1")+ "' "
cQuery	+= " AND SA1B.D_E_L_E_T_ = ' ' "

cQuery	+= " JOIN "+retsqlname("SA1")+ " SA1C ON SA1C.A1_COD = DT6_CLIDEV "
cQuery	+= " AND SA1C.A1_LOJA = DT6_LOJDEV "
cQuery	+= " AND SA1C.A1_FILIAL = '"+xFilial("SA1")+ "' "
cQuery	+= " AND SA1C.D_E_L_E_T_ = ' ' "

cQuery	+= " LEFT JOIN "+retsqlname("SA6")+ " SA6 ON SE1.E1_AGECHQ = A6_AGENCIA "
cQuery	+= " AND SE1.E1_CTACHQ = A6_NUMCON "
cQuery	+= " AND SE1.E1_BCOCHQ = A6_COD "
cQuery	+= " AND SA6.A6_FILIAL = '"+xFilial("SA6")+ "' "
cQuery	+= " AND SA6.D_E_L_E_T_ = ' ' "

cQuery	+= " WHERE SE1.E1_CLIENTE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR07+"' "
cQuery	+= "  AND SE1.E1_LOJA BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR08+"' "
cQuery	+= "  AND SE1.E1_FILORIG BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery	+= "  AND SE1.E1_NUM    BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
cQuery	+= "  AND SE1.E1_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' "
cQuery	+= "  AND SE1.E1_PREFIXO <> 'CTR' "
cQuery	+= "  AND SE1.E1_SITFAT <> '3' "
cQuery	+= "  AND SE1.E1_FILIAL = '"+xFilial("SE1")+ "' "
cQuery	+= "  AND SE1.D_E_L_E_T_ = ' ' "

cQuery	+= "ORDER BY DT6_FILDOC, DT6.DT6_DOC, DT6_SERIE"
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cString,.T.,.T.)

dbselectarea("DTC")
dbsetorder(3)	// DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE+DTC_SERVIC+DTC_CODPRO

dbSelectArea(cString)
DbGoTop()

If Eof()
	ConOut("Nใo foram encontrados dados para a gera็ใo do arquivo com os parโmetros informados.")
	dbClosearea()
	Return
Endif

Processa({||Doccob()},"Gerando arquivo...")


dbSelectArea(cString)
dbclosearea()

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ_CriaSX1  ณ Autor ณKatia Alves Bianchi    ณ Data ณ06/10/2008ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Ajuste de Perguntas (SX1)                 			      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function _CriaSX1()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
aRegs :={}

//(sx1) Grupo/Ordem/Pergunta/X1_PERSPA/X1_PERENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSpa1/DefEng1/Cnt01/Var02/Def02/DefSpa2/DefEng2/Cnt02/Var03/Def03/DefSpa3/DefEng3/Cnt03/Var04/Def04/DefSpa4/DefEng4/Cnt04/Var05/Def05/DefSpa5/DefEng5/Cnt05/F3
aAdd(aRegs,{cPerg,"01","Filial De            ?","               ?","               ?","mv_ch1","C",2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","DLB","","","",""})
aAdd(aRegs,{cPerg,"02","Filial Ate           ?","               ?","               ?","mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","DLB","","","",""})
aAdd(aRegs,{cPerg,"03","Data De              ?","ฟDe Fecha      ?","From date      ?","mv_ch3","D",8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data Ate             ?","ฟA  Fecha      ?","To   date      ?","mv_ch4","D",8,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Cliente De           ?","ฟDe Cliente    ?","From Customer  ?","mv_ch5","C",6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
aAdd(aRegs,{cPerg,"06","Loja De              ?","ฟDe Tienda     ?","From unit      ?","mv_ch6","C",2,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Cliente Ate          ?","ฟA Cliente     ?","To Customer    ?","mv_ch7","C",6,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
aAdd(aRegs,{cPerg,"08","Loja Ate             ?","ฟA Tienda      ?","To Unit        ?","mv_ch8","C",2,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Fatura De            ?","               ?","               ?","mv_ch9","C",9,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Fatura Ate           ?","               ?","               ?","mv_cha","C",9,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)

Return()
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณDoccob    ณ Autor ณKatia Alves Bianchi    ณ Data ณ24/04/2009ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ                                          			      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function DocCob()

dbSelectArea(cString)
Dbgotop()

//Criacao do arquivo
// cArqTxt  :="GEFCO_DOCCOB_EXP_"+ U_EDICONVDAT(DATE(),2)+"_"+StrTran(time(),":","")+".TXT"
cArqTxt  :="DOCCOB_"+ U_EDICONVDAT(DATE(),2)+"_"+StrTran(time(),":","")+".TXT"
cNomArq:= Alltrim(_cDirEnv)+cArqTxt
nHdl := fCreate(cNomArq)

//Registro 000
cLin	:= "000"
cLin	+= Substr(SM0->M0_NOMECOM,1,35)
cLin	+= Substr((cString)->NOMEDEV,1,35)
cLin	+= U_EDICONVDAT(DATE(),2)
cLin	+= LEFT(STRTRAN(TIME(),":",""),4)
cLin	+= "COB"+STRZERO(DAY(DATE()),2)+STRZERO(MONTH(DATE()),2)+LEFT(STRTRAN(TIME(),":",""),4)+"1"
cLin	+= SPACE(75)
cLin	+= cEOL
fWrite(nHdl,cLin,Len(cLin))

//Registro 350
cLin	:= "350"
cLin	+= "COBRA"+STRZERO(DAY(DATE()),2)+STRZERO(MONTH(DATE()),2)+LEFT(STRTRAN(TIME(),":",""),4)+"1"
cLin	+= SPACE(153)
cLin	+= cEOL
fWrite(nHdl,cLin,Len(cLin))

//Registro 351
cLin	:= "351"
cLin	+= SM0->M0_CGC
cLin	+= Substr(SM0->M0_NOMECOM,1,40)
cLin	+= SPACE(113)
cLin	+= cEOL
fWrite(nHdl,cLin,Len(cLin))

nVlrCTC := 0
nQtdCTC := 0

While !Eof()
	cFatura:=(cString)->NUMFAT       
	
	//Registro 352
	cLin	:= "352"
	_aAreaSM0 := SM0->(GetArea("SM0"))
	SM0->(MsSeek(cEmpAnt+(cString)->FILDEB, .T.))
	cLin	+= SUBSTR(SM0->M0_FILIAL,1,10)
	SM0->(RestArea(_aAreaSM0))
	
	cLin	+= "0"
	cLin	+= "   "
	cLin	+= STRZERO(VAL((cString)->NUMFAT),10)
	cLin	+= U_EDICONVDAT(Stod((cString)->EMISFAT),4)
	cLin	+= U_EDICONVDAT(Stod((cString)->VECTO),4)
	cLin	+= STRZERO((cString)->VALFAT*100,15)
	cLin	+= "BCO"
	
	DbSelectArea("SF1")
	DbSetorder(1)
	If DbSeek((cString)->(FILFAT+NUMFAT+PREFIXO))
		cLin	+= STRZERO(SF1->F1_VALICM*100,15)
	Else
		cLin	+= STRZERO(0,15)
	EndIf
	cLin	+= STRZERO((cString)->JUROS*100,15)
	//cLin	+= STRZERO((cString)->VALFAT*100,15)
	cLin	+= U_EDICONVDAT(Stod((cString)->VECTO)-(cString)->DIADESC,4)
	cLin	+= STRZERO((cString)->DECRESC*100,15)
	cLin	+= Padr("ITAU",35)//Padr((cString)->NOMBCO,35) // A INFORMACAO DO BANCO FICOU FIXA DEVIDO O USUARIO NAO INFORMAR O BANCO NO MOMENTO DO FATURAMENTO
	cLin	+= STRZERO(VAL(SUBSTR((cString)->AGECHQ,1,4)),4)
	cLin	+= SUBSTR((cString)->AGECHQ,5,1)
	cLin	+= STRZERO(VAL((cString)->CTACHQ),10)
	cLin	+= Space(2)
	cLin	+= "I"
	cLin	+= SPACE(3)
	cLin	+= cEOL
	fWrite(nHdl,cLin,Len(cLin))
	
	dbSelectArea(cString)
	nVlrCTC += (cString)->VALFAT	
	
	While !Eof() .and. (cString)->NUMFAT == cFatura
		
		//Registro 353
		cLin	:= "353"
		
		_aAreaSM0 := SM0->(GetArea("SM0"))
		SM0->(MsSeek(cEmpAnt+(cString)->FILDOC, .T.))
		cLin	+= SUBSTR(SM0->M0_FILIAL,1,10)
		SM0->(RestArea(_aAreaSM0))
		
		cLin	+= PADR((cString)->SERIE,5)
		cLin	+= STRZERO(VAL((cString)->DOC),12)
		cLin    += STRZERO((cString)->VALTOT*100,15)
		cLin    += U_EDICONVDAT(Stod((cString)->DATEMI),4)
		cLin    +=  STRZERO(Val((cString)->CGCREM),14)
		cLin    +=  STRZERO(Val((cString)->CGCDES),14)
		cLin	+= SPACE(89)
		cLin	+= cEOL
		fWrite(nHdl,cLin,Len(cLin))
		
		cFatura:=(cString)->NUMFAT
		// nVlrCTC+=(cString)->VALFAT
		// nQtdCTC+=1
		
		//Registro 354 - Notas Fiscais
		nCount:=0
		dbselectarea("DTC")
		dbsetorder(3)
		If DbSeek(xFilial("DTC")+(cString)->(FILDOC+DOC+SERIE))
			While !Eof() .and. DTC->(DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE) == cFilDTC+(cString)->(FILDOC+DOC+SERIE) .and. nCount<=40
				cLin	:= "354"
				cLin	+= Padr(DTC->DTC_SERNFC,3)
				cLin	+= StrZero(Val(Substr(DTC->DTC_NUMNFC,2,8)),8)// numero documento
				cLin    += U_EDICONVDAT(DTC->DTC_EMINFC,4)
				cLin    += STRZERO(DTC->DTC_PESO*100,7)
				cLin    += STRZERO(DTC->DTC_VALOR*100,15)
				cLin    +=  STRZERO(Val((cString)->CGCREM),14)
				cLin	+= SPACE(112)
				cLin	+= cEOL
				fWrite(nHdl,cLin,Len(cLin))
				nCount++
				dbselectarea("DTC")
				dbSkip()
			EndDo
		ElseIf DbSeek(xFilial("DTC")+(cString)->(FILDCO+DOCDCO+SERDCO))
			While !Eof() .and. DTC->(DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE) == cFilDTC+(cString)->(FILDCO+DOCDCO+SERDCO) .and. nCount<=40
				cLin	:= "354"
				cLin	+= Padr(DTC->DTC_SERNFC,3)
				cLin	+= StrZero(Val(Substr(DTC->DTC_NUMNFC,2,8)),8)// numero documento
				cLin    += U_EDICONVDAT(DTC->DTC_EMINFC,4)
				cLin    += STRZERO(DTC->DTC_PESO*100,7)
				cLin    += STRZERO(DTC->DTC_VALOR*100,15)
				cLin    += STRZERO(Val((cString)->CGCREM),14)
				cLin	+= SPACE(112)
				cLin	+= cEOL
				fWrite(nHdl,cLin,Len(cLin))
				nCount++
				dbselectarea("DTC")
				dbSkip()
			EndDo
		EndIf
		
		dbSelectArea(cString)
		dbSkip()
	EndDo
	nQtdCTC+=1
	dbSelectArea(cString)
EndDo

// Registro 355
cLin := "355"
cLin += STRZERO(nQtdCTC,4)
cLin += STRZERO(nVlrCTC*100,15)
cLin += Space(148)
cLin += cEOL

fWrite(nHdl,cLin,Len(cLin))


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fClose(nHdl)

Return
