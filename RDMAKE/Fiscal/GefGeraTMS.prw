#include "TopConn.ch"
#include "RWMAKE.ch"
#INCLUDE "tbiconn.ch"

/*/
***************************************************************************
*+-----------------------------------------------------------------------+*
*|Funcao    | Gefr200 | Autor | J Ricardo Guimarães    | Data |21.01.2015|*
*+----------+------------------------------------------------------------+*
*|Descricao | Gerar registro no TMS a partir da tabela SF3, para atender |*
*|          | SPED.  No periodo os CTRC´s eram emitido pelo SIPCO        |*
*+----------+------------------------------------------------------------+*
*|Sintaxe   |                  	                                         |*
*+----------|------------------------------------------------------------+*
***************************************************************************
/*/                                                                        

*-------------------------------------------------*
User Function GefGeraTMS(_cDatIni, _cDatFim)
*-------------------------------------------------*
Local _cCTRC    := ""
Local _cSerCTRC := ""
Local _cNumLote := GetMV("MV_XNLOTE")
Local _nReg     := 1           
Local _aCliRem := {}
Local _aCliDes := {}
Local _aCliDev := {}
	
Private cAliasQry := GetNextAlias()

If _cDatIni = Nil .OR. !IsDigit(_cDatIni)
	Alert("Favor informar os parâmetros Ano Ini e Ano Final no formato: 'AAAAMMDD','AAAAMMDD'")
	Return
EndIf

MsgRun("Aguarde... Montando cursor de registros... ",,{|| fMontaCursor(_cDatIni, _cDatFim) })

dbSelectArea(cAliasQry)
dbGoTop()

If Eof()
	Aviso("Não há dados para serem processados.",{"Ok"},,"Atenção:")
	dbSelectArea(cAliasQry) ; dbCloseArea()	
	Return
EndIf

ProcRegua(0) // Numero de registros a processar

While !Eof()
	IncProc()
	_cCTRC 		:= (cAliasQry)->F3_NFISCAL
	_cSerCTRC 	:= (cAliasQry)->F3_SERIE
	_nReg 		:= 1
	
	While !Eof() .AND. (cAliasQry)->F3_NFISCAL = _cCTRC .AND. _cSerCTRC = (cAliasQry)->F3_SERIE

		Begin Transaction 

			// Grava DTC
			dbSelectArea("DTC")
			RecLock("DTC",.T.)
				DTC_FILORI := (cAliasQry)->F3_FILIAL
				DTC_FILDOC := (cAliasQry)->F3_FILIAL
				DTC_LOTNFC := _cNumLote
				DTC_DATENT := STOD((cAliasQry)->DATA_CTRC)
				DTC_NUMNFC := AllTrim(STR((cAliasQry)->NOTA_FISCAL))
				DTC_SERNFC := AllTrim(STR((cAliasQry)->SERIE_NOTA))
				DTC_CODPRO := "VEICULO"
				DTC_DESPRO := "CALCULO IMPOSTO TMS"
				DTC_EMINFC := STOD((cAliasQry)->DATA_NOTA)
				DTC_QTDVOL := 1
				DTC_PESO   := (cAliasQry)->PESO
				DTC_VALOR  := (cAliasQry)->VALOR_MERCADORIA
				DTC_CF	   := Stuff((cAliasQry)->CFOP,2,1,"")
				
				_aCliRem   := fBuscaCli((cAliasQry)->CNPJ_REMET)
				DTC_CLIREM := _aCliRem[1]
				DTC_LOJREM := _aCliRem[2]
				DTC_NOMREM := _aCliRem[3]
				DTC_CDRORI := _aCliRem[4]

				_aCliDes   := fBuscaCli((cAliasQry)->CNPJ_DEST)
				DTC_CLIDES := _aCliDes[1]
				DTC_LOJDES := _aCliDes[2]
				DTC_NOMDES := _aCliDes[3]
				DTC_CDRDES := _aCliDes[4]

				_aCliDev   := fBuscaCli((cAliasQry)->CNPJ_CONSIG)
				DTC_CLIDEV := _aCliDev[1]
				DTC_LOJDEV := _aCliDes[2]
				DTC_NOMDEV := _aCliDes[3]
				 
				DTC_CLICAL := _aCliDev[1]
				DTC_LOJCAL := _aCliDev[2]
				DTC_NOMCAL := _aCliDev[3]
				DTC_CDRCAL := _aCliDev[4]
				
				DTC_DOC    := (cAliasQry)->F3_NFISCAL
				DTC_SERIE  := (cAliasQry)->F3_SERIE
				DTC_OBS    := "VIN: " + (cAliasQry)->VIN

			MsUnLock()
			
            If _nReg = 1
				// Grava DT6
				dbSelectArea("DT6")
				RecLock("DT6",.T.)
					DT6_FILDOC := (cAliasQry)->F3_FILIAL
					DT6_FILORI := (cAliasQry)->F3_FILIAL					
					DT6_DOC    := (cAliasQry)->F3_NFISCAL
					DT6_SERIE  := (cAliasQry)->F3_SERIE
					DT6_DATEMI := STOD((cAliasQry)->DATA_CTRC)
					DT6_HOREMI := "0100"
					DT6_VOLORI := 1
					DT6_QTDVOL := 1
					DT6_PESO   := (cAliasQry)->PESO
					DT6_VALMER := (cAliasQry)->VALOR_MERCADORIA
					DT6_VALFRE := (cAliasQry)->IMPORTE_TOTAL
					DT6_VALIMP := (cAliasQry)->IMPORTE_IMPUESTO
					DT6_VALTOT := (cAliasQry)->IMPORTE_TOTAL
					
					DT6_CLIREM := _aCliRem[1]
					DT6_LOJREM := _aCliRem[2]
					DT6_NOMREM := _aCliRem[3]
					DT6_CDRORI := _aCliRem[4]

					DT6_CLIDES := _aCliDes[1]
					DT6_LOJDES := _aCliDes[2]
					DT6_NOMDES := _aCliDes[3]					
					DT6_CDRDES := _aCliDes[4]
					
					DT6_CLIDEV := _aCliDev[1]
					DT6_LOJDEV := _aCliDev[2]
					DT6_NOMDEV := _aCliDev[3]					
					DT6_CDRDEV := _aCliDev[4]

					DT6_CLICAL := _aCliDev[1]
					DT6_LOJCAL := _aCliDev[2]
					DT6_NOMCAL := _aCliDev[3]					
					DT6_CDRCAL := _aCliDev[4]
					
					DT6_DEVFRE := IIF(_aCliRem[1] = _aCliDev[1], "1", "2")
					DT6_LOTNFC := _cNumLote
					
					DT6_DATENT := STOD((cAliasQry)->DATA_CTRC)
					
				MsUnLock()

				// Grava DT8
				dbSelectArea("DT8")
				
				// Frete
				RecLock("DT8",.T.)
					DT8_CODPAS := "I3" // Frete
					DT8_VALPAS := (cAliasQry)->IMPORTE_TOTAL - ( (cAliasQry)->IMPORTE_SEGURO + (cAliasQry)->PEDAGIO )
					DT8_VALIMP := ( (cAliasQry)->IMPORTE_TOTAL - ( (cAliasQry)->IMPORTE_SEGURO + (cAliasQry)->PEDAGIO ) ) * ( (cAliasQry)->PORCENTAJE_ALICUOTA / 100 )
					DT8_VALTOT := (cAliasQry)->IMPORTE_TOTAL - ( (cAliasQry)->IMPORTE_SEGURO + (cAliasQry)->PEDAGIO )
					DT8_FILDOC := (cAliasQry)->F3_FILIAL
					DT8_DOC    := (cAliasQry)->F3_NFISCAL
					DT8_SERIE  := (cAliasQry)->F3_SERIE
					DT8_CDRORI := _aCliRem[4]
					DT8_CDRDES := _aCliDes[4]
					DT8_CODPRO := "02170002"
					DT8_ITEMD2 := "01"	   
					DT8_CODCIA := _cNumLote									
				MsUnLock()
				
				// Seguro
				RecLock("DT8",.T.)
					DT8_CODPAS := "I1" // Seguro
					DT8_VALPAS := (cAliasQry)->IMPORTE_SEGURO
					DT8_VALIMP := (cAliasQry)->IMPORTE_SEGURO * ( (cAliasQry)->PORCENTAJE_ALICUOTA / 100 )
					DT8_VALTOT := (cAliasQry)->IMPORTE_SEGURO
					DT8_FILDOC := (cAliasQry)->F3_FILIAL
					DT8_DOC    := (cAliasQry)->F3_NFISCAL
					DT8_SERIE  := (cAliasQry)->F3_SERIE
					DT8_CDRORI := _aCliRem[4]
					DT8_CDRDES := _aCliDes[4]
					DT8_CODPRO := "02170002" 
					DT8_ITEMD2 := "02"					
					DT8_CODCIA := _cNumLote
				MsUnLock()
				
				// Pedágio
				RecLock("DT8",.T.)
					DT8_CODPAS := "I2" // Pedágio
					DT8_VALPAS := (cAliasQry)->PEDAGIO
					DT8_VALIMP := 0 // N/INCIDE IMPORTO - (cAliasQry)->SEGURO * ( (cAliasQry)->PORCENTAJE_ALICUOTA / 100 )
					DT8_VALTOT := (cAliasQry)->PEDAGIO
					DT8_FILDOC := (cAliasQry)->F3_FILIAL
					DT8_DOC    := (cAliasQry)->F3_NFISCAL
					DT8_SERIE  := (cAliasQry)->F3_SERIE
					DT8_CDRORI := _aCliRem[4]
					DT8_CDRDES := _aCliDes[4]
					DT8_CODPRO := "02170002"
					DT8_ITEMD2 := "03"     
					DT8_CODCIA := _cNumLote					
				MsUnLock()

				// Total
				RecLock("DT8",.T.)
					DT8_CODPAS := "TF"
					DT8_VALPAS := (cAliasQry)->IMPORTE_TOTAL
					DT8_VALIMP := (cAliasQry)->IMPORTE_IMPUESTO
					DT8_VALTOT := (cAliasQry)->IMPORTE_TOTAL
					DT8_FILDOC := (cAliasQry)->F3_FILIAL
					DT8_DOC    := (cAliasQry)->F3_NFISCAL
					DT8_SERIE  := (cAliasQry)->F3_SERIE
					DT8_CDRORI := _aCliRem[4]
					DT8_CDRDES := _aCliDes[4]
					DT8_CODPRO := "02170002"
					DT8_ITEMD2 := ""	   
					DT8_CODCIA := _cNumLote									
				MsUnLock()												
				_nReg := 99
			EndIf	
	
			_cNumLote :=Soma1(_cNumLote)
		    PutMv("MV_XNLOTE",_cNumLote)
			
		End Transaction 	

		dbSelectArea(cAliasQry) 
		dbSkip()		
	End
End

dbSelectArea(cAliasQry) ; dbCloseArea()

Alert("Término de importação.")

Return

*-------------------------------------------------*
Static Function fMontaCursor(_cDatIni, _cDatFim)
*-------------------------------------------------*
Local _cQry := ""

_cQry := " SELECT F3_FILIAL, F3_NFISCAL, F3_SERIE, F3_ESPECIE, F3_EMISSAO, F3_CLIEFOR, F3_VALCONT, F3_VALICM, F3_BASEICM, F3_ALIQICM, "
_cQry += "        S.VIN "
_cQry += "       ,S.MARCA "
//_cQry += "       ,S.DESCRIPCION "
_cQry += "       ,CONVERT(VARCHAR(08),S.FECHA_EMISION, 112) AS DATA_CTRC "
_cQry += "       ,S.NRO_CTRC "
_cQry += "       ,S.SERIE_CTRC "
_cQry += "       ,S.NOTA_FISCAL "
_cQry += "       ,S.SERIE_NOTA "
_cQry += "       ,CONVERT(VARCHAR(08),S.DATA_NOTA, 112) AS DATA_NOTA "
_cQry += "       ,S.PESO "
_cQry += "       ,S.VALOR_MERCADORIA "
_cQry += "       ,S.CFOP "
_cQry += "       ,S.COD_CONCESIONARIO_RE "
_cQry += "       ,S.CNPJ_REMET "
_cQry += "       ,S.REMETENTE "
//_cQry += "       ,S.UF_REMETENTE "
//_cQry += "       ,S.COD_CIDADE_REMT "
//_cQry += "       ,S.COD_CONCESIONARIO_DEST "
_cQry += "       ,S.CNPJ_DEST "
_cQry += "       ,S.DESTINATARIO "
//_cQry += "       ,S.UF_DESTINATARIO "
//_cQry += "       ,S.COD_CIDADE_DEST "
//_cQry += "       ,S.COD_CONCESIONARIO_CO "
_cQry += "       ,S.CNPJ_CONSIG "
_cQry += "       ,S.CONSIGNATARIO "
_cQry += "       ,S.FLETE_A_CARGO "
_cQry += "       ,S.ESTADO "
_cQry += "       ,S.IMPORTE_SEGURO "
_cQry += "       ,S.PORCENTAJE_ALICUOTA "
_cQry += "       ,S.IMPORTE_IMPUESTO "
_cQry += "       ,S.IMPORTE_BASE_CALCULO "
_cQry += "       ,S.IMPORTE_TOTAL "
_cQry += "       ,ISNULL(S.PEDAGIO,0) AS PEDAGIO "
_cQry += " FROM SF3010 SF3 LEFT JOIN CTRC_CACAPAVA_2011 S "
//_cQry += " FROM SF3010 SF3 LEFT JOIN CTE_SETE_LAGOAS S "
_cQry += "  			ON F3_NFISCAL = RTRIM(S.NRO_CTRC) AND F3_EMISSAO = CONVERT(VARCHAR(08), S.FECHA_EMISION, 112) "
//_cQry += " 	WHERE F3_FILIAL='14' "
_cQry += " 	WHERE F3_FILIAL='17' "
//_cQry += "    AND F3_EMISSAO BETWEEN '20110101' AND '20120320' "
_cQry += "    AND F3_EMISSAO BETWEEN '" + _cDatIni + "' AND '" + _cDatFim + "' "
_cQry += " 	  AND F3_ESPECIE='CTR'  "
_cQry += " 	  AND S.VIN IS NOT NULL "
_cQry += " ORDER BY F3_NFISCAL, F3_SERIE, F3_EMISSAO "
                                                                   
_cQry := ChangeQuery(_cQry)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQry),cAliasQry, .F., .F.) 

Return

*----------------------------------------*
Static Function fBuscaCli(_cCNPJ)
*----------------------------------------*
Local _aCli  := Array(4)
Local _aArea := GetArea()

If LEFT(AllTrim(_cCNPJ),2) = "MS"  // Exportação/Importação, possou codigo/loja no lugar do CNPJ
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek(xFilial("SA1") + SubStr(AllTrim(_cCNPJ),3,8) )
		_aCli[1] := SA1->A1_COD
		_aCli[2] := SA1->A1_LOJA
		_aCli[3] := SA1->A1_NOME
		_aCli[4] := SA1->A1_CDRDES
	EndIf
Else
	
	_cCNPJ := STRTRAN(STRTRAN(STRTRAN(AllTrim(_cCNPJ),".",""),"-",""),"/","")
	
	dbSelectArea("SA1")
	dbSetOrder(3)
	If dbSeek(xFilial("SA1") + AllTrim(_cCNPJ) )
		_aCli[1] := SA1->A1_COD
		_aCli[2] := SA1->A1_LOJA
		_aCli[3] := SA1->A1_NOME
		_aCli[4] := SA1->A1_CDRDES
	EndIf
EndIf

RestArea(_aArea)
Return _aCli