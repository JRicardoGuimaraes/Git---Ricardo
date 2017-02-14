#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "folder.ch"
#include "colors.ch"
#include "Font.ch"
#include "tbiconn.ch"
#INCLUDE "Vkey.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GXMLNFSE  º Autor ³ Leandro Passos     º Data ³  09/10/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Captura o XML retornado pela prefeitura na tabela do TSS   º±±
±±º          ³ e cria o devido arquivo de XML na rede				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEFCO                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GXMLNFSE()
Private _aRegs	:= {}
Private _cPerg  := "GXMLNFSE01"

//Pergunta a série das RPS e a data de inicio para a busca
AADD(_aRegs,{_cPerg,"01","NFSE Inicial     ","","","MV_CHA","C",009,0,0,"G","","MV_PAR01",""     ,"","","","",""          ,"","","","","","","","","","","","","","","","","","","   ","",""})
AADD(_aRegs,{_cPerg,"02","NFSE Final       ","","","MV_CHB","C",009,0,0,"G","","MV_PAR02",""     ,"","","","",""          ,"","","","","","","","","","","","","","","","","","","   ","",""})
AADD(_aRegs,{_cPerg,"03","Data de          ","","","MV_CHA","D",008,0,0,"G","","MV_PAR03",""     ,"","","","",""          ,"","","","","","","","","","","","","","","","","","","   ","",""})
AADD(_aRegs,{_cPerg,"04","Data ate         ","","","MV_CHB","D",008,0,0,"G","","MV_PAR04",""     ,"","","","",""          ,"","","","","","","","","","","","","","","","","","","   ","",""})
ValidPerg(_aRegs,_cPerg)

If !Pergunte(_cPerg,.T.)
	Return
Endif

// efetua processa
Processa({|| fGeraArq()},"Gerando arquivos XML das NFSe...")

// retorna
Return

Static Function fGeraArq()

Local _cCNPJ 	:= AllTrim(SM0->M0_CGC)

// Primeiro pega a ID_ENT pelo CNPJ
_cQry := " SELECT "
_cQry += "	    ID_ENT  "
_cQry += "	FROM  "
_cQry += "		DADOSADV_TSS.dbo.SPED001 "
_cQry += "  WHERE "
_cQry += "      CNPJ = '" + _cCNPJ + "' "
TCQUERY _cQry NEW ALIAS "TIDENT"
_cIdent := TIDENT->ID_ENT
TIDENT->(DbCloseArea())

// Busca dados no Banco do TSS
_cQry := " SELECT "
_cQry += "	    CONVERT(VARCHAR(8000),CONVERT(BINARY(8000), XML_ERP)) AS XML_ERP  " // Campo memo
_cQry += "	    ,NFSE, NFSE_PROT, STATUS, STATUSCANC, DATE_NFSE "
_cQry += "	FROM  "
_cQry += "		DADOSADV_TSS.dbo.SPED051 "
_cQry += "  WHERE "
_cQry += "      STATUS = 6 AND STATUSCANC = 0 "
_cQry += "      AND NFSE BETWEEN '" + AllTrim(MV_PAR01) + "' AND '" + AllTrim(MV_PAR02) + "'"
_cQry += "      AND DATE_NFSE BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "'"
_cQry += "      AND ID_ENT = '" + _cIdent+ "' "
_cQry += " ORDER BY DATE_NFSE, NFSE "
TCQUERY _cQry NEW ALIAS "TXML"
ProcRegua(rfRecCount("TXML"))
DbSelectArea("TXML")
While !TXML->(EOF())
	IncProc("Data: " + DTOC(STOD(TXML->DATE_NFSE)) + " Nota Fiscal: " + AllTrim(TXML->NFSE) )
	_cXML_ERP := TXML->XML_ERP
	If AllTrim(_cXML_ERP) <> "" .AND. !Empty(_cXML_ERP)
		fCriaXML(_cXML_ERP,AllTrim(TXML->NFSE),AllTrim(TXML->NFSE_PROT),TXML->DATE_NFSE)
	Endif
	TXML->(DbSkip())
END
TXML->(DbCloseAre())
Alert("Arquivos XML gerados na pasta do servidor Protheus \xml-nfse-export\")

Return

Static Function fCriaXML(_cXML_ERP,_cNFSE,_cNFSE_PROT,_cDataNFSE)

Local _cPath := "\xml-nfse-export\"
// cria o arquivo
MontaDir(_cPath)
_cArqXml := _cPath + "nfe_empresa_"+cEmpAnt+"_filial_"+cFilAnt+"_nfse_"+Alltrim(_cNFSE)+"_protocolo_"+Alltrim(_cNFSE_PROT)+"_data_"+_cDataNFSE+".xml"
If File(_cArqXML)
	fErase(_cArqXML)
Endif
_nHandle := FCreate(_cArqXml,0)
fWrite(_nHandle,_cXML_ERP,Len(_cXML_ERP))
fClose(_nHandle)
Return

Static Function rfRecCount(_cAlias)
Local _nRet := 0
DbSelectArea(_cAlias)
DbGoTop()
While !EOF()
	_nRet++
	DbSkip()
End
DbGoTop()
Return(_nRet)
