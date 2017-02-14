#include "PROTHEUS.ch"    
#include "rwmake.ch"    
#include "Topconn.ch"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GEFCTB21  ³ Autor ³ Marcos Furtado        ³ Data ³ 25.09.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Exporta dados do Historique conforme parâmetro.             ³±±
±±³          ³                                                            ³±±
±±³          ³ Titulo a Receber                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GEFCTB21()   
Private cPerg      := "GEF002"   

Pergunte(cPerg,.F.)                           // Pergunta no SX1


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,001 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Exportação de Historique")
@ 002,010 TO 080,190
@ 10,018 Say " Este programa ira exportar o conteudo do arquivo historique."
//@ 40,018 Say "Informe o Layout"
//@ 40,070 COMBOBOX cTipoarq ITEMS aChoice size 20,10
@ 60,068 BMPBUTTON TYPE 01 ACTION Processa({|| ExpHistorique() },"Processando....")
@ 60,098 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 60,128 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeTxt Centered

Return



Static Function ExpHistorique()  // Versão VA2/VA3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                    

Local cQry                         


	cQry := ""
	cQry := "SELECT DISTINCT Z2_COD "
	cQry += "FROM " + RetSqlName("SZ2") + " "
	cQry += "WHERE Z2_FILIAL = '" + xFilial("SZ2") + "' "
	cQry += "AND Z2_MES = '" + DTOS(MV_PAR01) + "' "
	cQry += "AND D_E_L_E_T_ <> '*' "
	cQry += "ORDER BY Z2_COD "	
	
	TcQuery cQry Alias "TRB" NEW
	DbSelectArea("TRB")
	DbGoTop()
	
	If Eof()
		Alert("Não há dados a exportar.")
		DbSelectArea("TRB") ; dbCloseArea()
		Return
	EndIf
	cQry := ""	
    While !Eof()

		cQry += "SELECT DISTINCT '" + TRB->Z2_COD + "' AS CODIGO , Z2_FILIAL,	Z2_COD,	Z2_CONTA,CTS_CONTAG, CTS_DESCCG, Z2_SALDO,	Z2_UO,	Z2_SEDEADM,	Z2_SEDEOPE,	"
		cQry += " Z2_PORTORJ, Z2_RIO, Z2_PREAL, Z2_BARUERI, Z2_CAXIAS, Z2_VILAGUI, Z2_SJP, Z2_CAMPINA, Z2_SEPETIB, "
		cQry += " Z2_STAMARO, Z2_SANTOS, Z2_CONTAGE, Z2_VITORIA , Z2_FORA, Z2_SLAGOAS, Z2_CACAPAV "
		cQry += "FROM " + RetSqlName("CTS") + " CTS LEFT JOIN  "
		cQry += " " + RetSqlName("SZ2") + " SZ2 ON "	 
		cQry += " Z2_FILIAL = '" + xFilial("SZ2") + "' "    
		cQry += " AND Z2_MES = '" + DTOS(MV_PAR01) + "' "
		cQry += " AND Z2_COD = '" + TRB->Z2_COD + "' "	
		cQry += " AND SZ2.D_E_L_E_T_ <> '*' AND Z2_CONTA = CTS_CONTAG  "	
		cQry += "WHERE CTS_FILIAL = '" + xFilial("CTS") + "' "    
		cQry += "  AND CTS.D_E_L_E_T_ <> '*' AND CTS_CODPLA = '001' "			

		DbSelectArea("TRB")    
		DbSkip()
		If !Eof()
			cQry += " UNION "							
		EndIF
	End                        
	DbSelectArea("TRB")    	
	DbCloseArea()
//alert(MV_PAR01)

	cQry += "ORDER BY CODIGO, CTS_CONTAG  "	
	                                           
/*SELEC DISTINCT Z2_COD,	Z2_CONTA,CTS_CONTAG, CTS_DESCCG, Z2_SALDO,	Z2_UO,	Z2_SEDEADM,	Z2_SEDEOPE 
FROM CTS010 CTS   LEFT JOIN  SZ2010 SZ2 ON 
SZ2.D_E_L_E_T_ <> '*' AND Z2_MES = '20060801' AND Z2_CONTA = CTS_CONTAG AND Z2_COD = '001'
WHERE  CTS.D_E_L_E_T_ <> '*' AND CTS_CODPLA = '001' 
ORDER BY Z2_COD, Z2_CONTA, CTS_CONTAG */

//MEMOWRIT("D:\TEMP\GEFCTB21.SQL",cQry)
	
	TcQuery cQry Alias "TSZ2" NEW                                                                             
	TcSetField("TSZ2" ,"Z2_SALDO","N",15,2)	
	TcSetField("TSZ2" ,"Z2_SEDEADM","N",15,2)	
	TcSetField("TSZ2" ,"Z2_SEDEOPE","N",15,2)	
	TcSetField("TSZ2" ,"Z2_PORTORJ","N",15,2)	
	TcSetField("TSZ2" ,"Z2_RIO","N",15,2)	
	TcSetField("TSZ2" ,"Z2_PREAL","N",15,2)	
	TcSetField("TSZ2" ,"Z2_BARUERI","N",15,2)
	TcSetField("TSZ2" ,"Z2_CAXIAS","N",15,2)
	TcSetField("TSZ2" ,"Z2_VILAGUI","N",15,2)
	TcSetField("TSZ2" ,"Z2_SJP","N",15,2)
	TcSetField("TSZ2" ,"Z2_CAMPINA","N",15,2)
	TcSetField("TSZ2" ,"Z2_SEPETIB","N",15,2)
	TcSetField("TSZ2" ,"Z2_STAMARO","N",15,2)
	TcSetField("TSZ2" ,"Z2_SANTOS","N",15,2)
	TcSetField("TSZ2" ,"Z2_CONTAGE","N",15,2)
	TcSetField("TSZ2" ,"Z2_VITORIA","N",15,2)
	TcSetField("TSZ2" ,"Z2_FORA","N",15,2)
	TcSetField("TSZ2" ,"Z2_SLAGOAS","N",15,2)
	TcSetField("TSZ2" ,"Z2_CACAPAV","N",15,2)
	
	DbSelectArea("TSZ2")
	DbGoTop()
/*	While !Eof()        
		ImpHistorique(TSZ2->Z2_COD)		
		DbSelectArea("TSZ2")
		DbSkip()                      
		IncRegua()
	End*/

DbSelectArea("TSZ2")
//DbSetOrder(1)

/*DbSelectArea("SZ2")
DbSetOrder(1)*/

cPathori := "\Importar\Historique\"
cNome    := "Historiq.DBF"
Copy To &(cPathOri + cNome) VIA "DBFCDXADS"
//Copy To &(cPathOri + cNome) FOR Z2_MES == MV_PAR01
DbClosearea("TSZ2")
/*For a := 1 To Len(aFiles)
	
	aCampos:={}
	AADD(aCampos,{ "LINHA" ,"C",400,0 })
	cNomArq := CriaTrab(aCampos)
	
	If (Select("TRB") <> 0)
		dbSelectArea("TRB")
		dbCloseArea("TRB")
	Endif
	dbUseArea(.T.,,cNomArq,"TRB",nil,.F.)
	
	If !File(Alltrim("\Importar\Sintegra\" + aFiles[a][1]))
		MsgBox("Arquivo texto nao existente.Programa cancelado","Informa‡ao","INFO")
		Return
	Endif
	
	dbSelectArea("TRB")
	
//	Append From (Alltrim("\Importar\Sintegra\" + aFiles[a][1])) SDF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a regua de processamento                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Processa({|| RunCont() },"Processando...")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Copia o arquivo de trabalho e depois apaga                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If File("\Importar\Sintegra\" + aFiles[a][1])
		__CopyFile("\Importar\Sintegra\" + aFiles[a][1],"\Importar\Sintegra\Antigos\" + aFiles[a][1])
		Ferase("\Importar\Sintegra\" + aFiles[a][1])
	Endif
	
Next*/

MsgBox("Exportação Concluida!!","Informacao","INFO")

Return
