#INCLUDE "rwmake.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#INCLUDE "AVPRINT.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GEFA004  บ Autor ณ Francisco Rosembergบ Data ณ  11/05/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de arquivo EDI CONEMB - DOCTOS CANCELADOS          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Gefco Logistica.                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function GEFA004(cEmpTrb,cFilTrb)
Private cPerg 	:= "GEFA04    "

If cEmpTrb <> NIL
	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT EMPRESA cEmpTrb[1] FILIAL cEmpTrb[2] MODULO "TMS" TABLES "SF3","SA1","SM0"
	Pergunte(cPerg,.F.)
	
	MV_PAR01:=cEmpTrb[2]
	MV_PAR02:=cEmpTrb[2]
	MV_PAR03:=dDatabase-3
	MV_PAR04:=dDatabase
	MV_PAR05:=2
	OkGeraTxt()
	RpcClearEnv()   // Libera o Environment
Else
	_CriaSx1()
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	OkGeraTxt()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERATXTบ Autor ณ Francisco Rosemberg Data  ณ  11/05/09   บฑฑ
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
ฑฑบFuncao    ณ GERARQ   บ Autor ณFrancisco Rosemberg บ Data ณ  11/05/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para montagem do arquivo cArqTxt                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Gefco Logistica                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GerArq

Local cQuery		:= ""
Private cString2		:= GetNextAlias()
Private cLin		:= ""
Private cNomArq   	:= ""
Private _aAreaSM0 	:= SM0->(GetArea("SM0"))
Private cEOL		:= CHR(13)+CHR(10)

/*/ Parametros
MV_PAR01	Filial Origem de     			?
MV_PAR02	Filial Origem Ate    			?
MV_PAR03	Data de              			?
MV_PAR04	Data Ate             			?
MV_PAR05	Retransmissao do Arquivo(S/N)	?
/*/

cString2 := GetNextAlias()

cQuery	:= " SELECT F3_SERIE SERIE, "
cQuery	+= " 		F3_NFISCAL NFISCAL, "
cQuery  += "		F3_ENTRADA ENTRADA, "
cQuery  += "		F3_VALCONT VALCONT, "
cQuery  += "		F3_DTCANC DTCANC, "
cQuery  += "		F3_USERLGA USERLGA, "
cQuery  += "		F3_CLIEFOR CLIEFOR, "
cQuery  += "		F3_LOJA LOJA, "
cQuery  += "		F3_ESPECIE ESPECIE, "
cQuery  += "		A1_PESSOA PESSOA, "
cQuery  += "		A1_TIPO TIPO, "
cQuery  += "		A1_CGC CGC, "
cQuery  += "		A1_COD COD, "
cQuery  += "		A1_LOJA LOJA"

cQuery  += " FROM "+retsqlname("SF3") + " SF3"

cQuery  += " JOIN "+retsqlname("SA1")+ " A1 ON A1_COD = F3_CLIEFOR "
cQuery  += " AND A1_LOJA = F3_LOJA "
cQuery	+= " AND A1_FILIAL = '"+xFilial("SA1")+ "' "
cQuery  += " AND A1.D_E_L_E_T_ = ' ' "

// Por: Ricardo EM: 08/03/2013 - Em virtude da entrada do CTRC do TLA pelo m๓dulo TMS e nใo deve ir para o sistema ADT
cQuery  += " JOIN SE1010 E1 ON E1_NUM = F3_NFISCAL "
cQuery  += " AND E1_CLIENTE = F3_CLIEFOR "
cQuery  += " AND E1_LOJA = F3_LOJA "
cQuery  += " AND E1_FILIAL = F3_FILIAL "

cQuery	+= " WHERE F3_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
//cQuery	+= "  AND  F3_ESPECIE = 'CTR  ' AND SF3.D_E_L_E_T_='' " //Alterado por Francisco Rosemberg em 14/10/09 para filtrar esp้cie do documento.
cQuery	+= "  AND  SF3.D_E_L_E_T_='' " 
cQuery	+= "  AND  F3_DTCANC BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
cQuery	+= "  AND  SUBSTRING(E1_CCONT,1,3)='211' "  // Filtra o OVL - OVS e TLA nใo precisa ir para o ADT - Ricardo - 08/03/2013

If MV_PAR05=1
	cQuery	+= "  AND  F3_DATEDI <> ''"
EndIf
If MV_PAR05=2
	cQuery	+= "  AND  F3_DATEDI = ''"
EndIf

//cQuery := ChangeQuery(cQuery)
//MemoWrite( "GEFA004", cQuery )
DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cString2,.T.,.T.)
dbSelectArea(cString2)
DbGoTop()

If Eof()
	ConOut("Nใo foram encontrados dados para a gera็ใo do arquivo com os parโmetros informados - CANCELADOS.")
	dbClosearea()
	Return
Endif

Conemb()

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณConemb    ณ Autor ณFrancisco Rosemberg    ณ Data ณ11/05/2009ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณGeracao do arquivo txt                    			      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณGEFA004                                                     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function Conemb()
Local   cSeek
Private nDocTot	:= 0
Private nVrlTot	:= 0

dbSelectArea(cString2)
DbgoTop()


cArqTxt  :="DOCSC"+ Substr(Dtos(Date()),7,2)+SubStr(Dtos(Date()),5,2)+SubStr(Dtos(Date()),1,4)+Left(StrTran(Time(),":",""),6)+".txt"
cNomArq:= Alltrim(_cDirEnv)+cArqTxt
nHdl := fCreate(cNomArq)

//Registro 000
cLin	:= "000"
cLin	+= Substr(Dtos(Date()),7,2)+SubStr(Dtos(Date()),5,2)+SubStr(Dtos(Date()),3,2)
cLin	+= SubStr(Time(),1,2)+SubStr(Time(),4,2)
cLin	+= "CON"+StrZero(Day(Date()),2)+StrZero(Month(Date()),2)+Left(StrTran(Time(),":",""),4)+"1"
cLin	+= Space(685)
cLin	+= cEOL
fWrite(nHdl,cLin,Len(cLin))

//Registro 320
cLin	:= "320"
cLin	+= "CONHE"+StrZero(Day(Date()),2)+StrZero(Month(Date()),2)+Left(StrTran(Time(),":",""),4)+"1"
cLin	+= Space(663)
cLin	+= cEOL
fWrite(nHdl,cLin,Len(cLin))

//Registro 321
cLin	:= "321"
cLin	+= SM0->M0_CGC
cLin	+= Substr(SM0->M0_NOMECOM,1,40)
cLin	+= Space(623)
cLin	+= cEOL
fWrite(nHdl,cLin,Len(cLin))

While !Eof()
	//Registro 322
	cLin	:= "322"
	cLin	+= SM0->M0_CODFIL
	cLin	+= SubStr(SM0->M0_FILIAL,1,15)
	cLin	+= Padr((cString2)->SERIE,5)
	cLin	+= StrZero(Val((cString2)->NFISCAL),12)
	cLin    += (cString2)->ENTRADA
	cLin    += StrZero((cString2)->VALCONT*100,15)
	nVrlTot += nVrlTot + (cString2)->VALCONT
	nDocTot ++
	cLin    += (cString2)->DTCANC
	cLin	+= Padr(SubStr(embaralha((cString2)->USERLGA,1),1,15),25)
	
	If (cString2)->PESSOA = "F"
		cLin	+= "F"
		cLin	+= "CANCELADO     "//(cString2)->CGC
	ElseIf (cString2)->PESSOA = "J"
		cLin	+= "J"
		cLin	+= "CANCELADO     "//(cString2)->CGC
	Else
		cLin	+= "E"
		cLin	+= "CANCELADO     "//(cString2)->CGC
	EndIf
	/*
	If (cString2)->PESSOA = "E" .Or. (cString2)->PESSOA = "X"
	cLin	+= "E"
	cLin	+= (cString2)->COD
	cLin	+= "CANCELADO     " //(cString2)->LOJA
	EndIf
	*/
	cLin	+= "X"
	cLin	+= (cString2)->CLIEFOR
	cLin	+= (cString2)->LOJA
	cLin += Space(563)
	cLin	+= cEOL
	fWrite(nHdl,cLin,Len(cLin))
	
	//Gravar F3_DATEDI no SF3
	cSeek := xFilial("SF3")+(cString2)->CLIEFOR + (cString2)->LOJA + (cString2)->NFISCAL + (cString2)->SERIE
	DbSelectArea("SF3")
	SF3->(DbSetOrder(4))//F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
	If SF3->(DbSeek(cSeek))
		While SF3->F3_FILIAL+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE==cSeek
			RecLock("SF3",.F.)
			SF3->F3_DATEDI := Date()
			SF3->(MsUnLock())
			SF3->(Dbskip())
		Enddo
	EndIf
	DbSelectArea(cString2)
	(cString2)->(DbSkip())
EndDo

// Registro 323
cLin := "323"
cLin += StrZero(nDocTot,4)
cLin += StrZero(nVrlTot*100,15)
cLin += Space(658)
cLin += cEOL
fWrite(nHdl,cLin,Len(cLin))

nDocTot	:= 0
nVrlTot	:= 0
fClose(nHdl)

dbCloseArea(cString2)

Return

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

cPerg := PadR(cPerg,Len(X1_GRUPO))

//(sx1) Grupo/Ordem/Pergunta/X1_PERSPA/X1_PERENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSpa1/DefEng1/Cnt01/Var02/Def02/DefSpa2/DefEng2/Cnt02/Var03/Def03/DefSpa3/DefEng3/Cnt03/Var04/Def04/DefSpa4/DefEng4/Cnt04/Var05/Def05/DefSpa5/DefEng5/Cnt05/F3
aAdd(aRegs,{cPerg,"01","Filial De            ?","","","mv_ch1","C",2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","DLB","","","",""})
aAdd(aRegs,{cPerg,"02","Filial Ate           ?","","","mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","DLB","","","",""})
aAdd(aRegs,{cPerg,"03","Data De              ?","","","mv_ch3","D",8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data Ate             ?","","","mv_ch4","D",8,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Retransmissao Arquivo?","","","mv_ch5","N",1,0,0,"C","","mv_par05","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})


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
