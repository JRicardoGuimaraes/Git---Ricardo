#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"    
#INCLUDE "TOPCONN.CH"
/************************************************************************
* Programa........: GEFR015                                             *
* Autor...........: J Ricardo de O Guimarães                            *
* Data............: 02/05/2008                                          *
* Descricao.......: Relatório de Faturamento em Excel                   *
*                                                                       *
*************************************************************************
* Modificado por..:                                                     *
* Data............:                                                     *
* Motivo..........:                                                     *
*                                                                       *
************************************************************************/
User Function GEFR015()
Local 	nOpcao	:=	0
Private aEst	:=	{}
Private aFilCC	:=	{}
Private oDlgVnd	:= 	nil
Private cPath	:=	space(255)
Private cArquivo:=	space(255)
Private dDataDe	:=	dDataBase
Private dDataAte:=	dDataBase
Private cPedidoDe := Space(06)
Private cPedidoAte:= "ZZZZZZ"

SetKey (VK_F3,{|a,b| cPath:=cGetFile( "DBF(*.dbf) | *.dbf ",OemToAnsi("Salvar em..."),,"d:",.f.,GETF_LOCALHARD+GETF_RETDIRECTORY)})
@ 200,1 TO 422,420 DIALOG oDlgVnd TITLE OemToAnsi("Relatorio de Faturamento.")
@ 02,10 TO 120,190
@ 10,018 Say " Este programa ira gerar arquivo de Faturamento p/ ser lido em Excel. "
@ 18,018 Say " Defina abaixo os parâmetros do relatório"
@ 26,018 Say "                                                            "
@ 34,018 Say "Diretorio:"
@ 32,050 Get cPath Picture "@!" Size 60,20
@ 32,110 BUTTON "..." SIZE 10,10 ACTION (cPath:=cGetFile( "DBF(*.dbf) | *.dbf ",OemToAnsi("Salvar em..."),,"d:",.f.,GETF_LOCALHARD+GETF_RETDIRECTORY))
@ 50,018 Say "Arquivo:"
@ 48,050 Get cArquivo Picture "@!" Size 60,20
@ 66,018 Say "Data de: "
@ 64,050 Get dDataDe
@ 82,018 Say "Data Ate: "
@ 80,050 Get dDataAte
@ 96,018 Say "Pedido de: "
@ 94,050 Get cPedidoDe Picture "999999"
@ 110,018 Say "Pedido Ate: "
@ 112,050 Get cPedidoAte Picture "999999"

@ 116,128 BMPBUTTON TYPE 01 ACTION (nOpcao:=1,iif(fvldOk(),Close(oDlgVnd),))
@ 116,158 BMPBUTTON TYPE 02 ACTION (nOpcao:=2,Close(oDlgVnd))

Activate Dialog oDlgVnd Centered
SetKey (VK_F3,{||})

If nOpcao == 1
	Processa({|| RunExport() },"Processando...")
EndIf

Return

/*************************************************************************
* Funcao....: RUNReport()                                                *
* Autor.....: Marcelo Aguiar Pimentel                                    *
* Data......: 13/04/2007                                                 *
* Descricao.: Funcao responsável pela busca de informacoes na tabela SZO *
*             e geracao de arquivo dbf.                                  *
*                                                                        *
*************************************************************************/
Static Function RunExport(Cabec1,Cabec2,Titulo,nLin)
Local cQry		:=	""
Local aPrint	:=	{}
Local nPos		:=	0
Local cTipo		:=	""

Private cdbfFAT	:=	criatrab()
Private cInd1	:=	""

//Buscando informacoes processadas
cQry := "SELECT C5_FILIAL AS Filial, C5_NUM As Pedido, C5_CLIENTE As 'Cod.Cliente', A1_NOME As Cliente, C5_LOJACLI As Loja, "
cQry += "	E4_DESCRI As 'Cond.Pagto.', C5_EMISSAO As 'Dt.Emissao', C5_NOTA As Nota, C5_SERIE As Serie, C5_CCUSTO As 'C.Custo', "
cQry += "	C5_CCUSPSA As 'C.Custo PSA',C5_REFGEFC As 'Ref.Gefco', C5_TPDESP As 'Tipo Desp', C5_OIPSA As 'OI PSA', "
cQry += "	C5_CTAPSA As 'Conta PSA', CONVERT(VARCHAR(500),CONVERT(BINARY, C5_XOBS)) AS OBS, C5_MENNOTA, "
cQry += "	C5_NATUREZ As Natureza, C6_PRODUTO As 'Cod.Produto', C6_DESCRI As 'Descricao do Prod.', C6_VALOR AS Total, "
cQry += "	C6_TES As 'Tipo Saida', C6_CF As 'Cod.Fiscal', C6_CODISS As 'Cod.Iss' "
cQry += "	FROM " + RetSqlName("SC5010") + " SC5, " + RetSqlName("SC6") + " SC6, " + RetSqlName("SA1") + " SA1, " + RetSqlName("SE4") + " SE4 "
cQry += "	WHERE C5_FILIAL = '" + xFilial("SC5")   + "' "
cQry += "	  AND C5_EMISSAO >= '" + DTOS(dDataDe)  + "' "
cQry += "	  AND C5_EMISSAO <= '" + DTOS(dDataAte) + "' "
cQry += "	  AND C5_NUM     >= '" + cPedidoDe      + "' "
cQry += "	  AND C5_NUM     <= '" + cPedidoAte     + "' "
cQry += "	  AND C5_NOTA    <> '' "
cQry += "	  AND SC5.D_E_L_E_T_ = '' "
cQry += "	  AND SC6.D_E_L_E_T_ = '' "
cQry += "	  AND SA1.D_E_L_E_T_ = '' "
cQry += "	  AND SE4.D_E_L_E_T_ = '' "
cQry += "	  AND C5_FILIAL = C6_FILIAL "
cQry += "	  AND C5_NUM     = C6_NUM   "
cQry += "	  AND C5_CLIENTE = A1_COD   "
cQry += "	  AND C5_LOJACLI = A1_LOJA  "
cQry += "	  AND C5_CONDPAG = E4_CODIGO"

TcQuery cQry Alias "TFAT" New

// MEMOWRIT("D:\TEMP\QRYVENDAS.TXT",cQry)

dbSelectArea("TFAT")
ProcRegua(RecCount())

//Formatando DBF para exportar para o excel
fExpExcel()

Return

/****************************************************************************
* Funcao....: C()                                                           *
* Autor.....: GAIA 1.0                                                      *
* Data......: 13/04/2007                                                    *
* Descricao.: Configura o tamanho da tela de acordo com o tamanho e tema    *
*                                                                           *
****************************************************************************/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³Tratamento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)


/****************************************************************************
* Funcao....: fExpExcel()                                                   *
* Autor.....: Marcelo Aguiar Pimentel                                       *
* Data......: 13/04/2007                                                    *
* Descricao.: Faz as ultimas atualizacoes e abre o DBF no excel             *
*                                                                           *
****************************************************************************/
Static Function fExpExcel()

//Use &cDbfSZO Alias cDbfSZO New

dbSelectArea("TFAT")
dbGoTop()

ProcRegua(0)
//Copiando arquivo para abrir no excel
cPath:=alltrim(cPath)
cArquivo:=alltrim(cArquivo)
If CpyS2T(cdbfFAT, cPath,.f.)
	If File(cPath+cArquivo+".dbf")
		fErase(cPath+cArquivo+".dbf")
	EndIf
	
	If FRENAME(cPath+cDbfSZO+".dbf", cPath+cArquivo+".dbf") == -1
		MsgAlert("Não foi possível gerar arquivo como o nome solicitado: "+cPath+cArquivo+".dbf","Atenção!")
		cArquivo:=cDbfSZO		
	EndIf
	
	//Abrindo arquivo no Excel
	If ! ApOleClient( 'MsExcel' ) 
		MsgStop( "MsExcel não encontrado!" ) //'MsExcel nao instalado'
    Else
		oXls:= MsExcel():New()
		oXls:WorkBooks:Open(cPath+cArquivo+".dbf")
		oXls:SetVisible(.T.)
		oXls:Destroy()
	EndIf

Else
	MsgAlert("Nao foi possível gerar arquivo com o nome solicitado!","Erro!")
EndIf

dbSelectArea("cDbfFAT")
If FILE(cDbfSZO+".DBF")     //Elimina o arquivo de trabalho
    dbCloseArea()
    Ferase(cDbfSZO+".DBF")
    Ferase("cInd1"+OrdBagExt())
EndIf

Return

/****************************************************************************
* Funcao....: fvldOk()                                                      *
* Autor.....: Marcelo Aguiar Pimentel                                       *
* Data......: 13/04/2007                                                    *
* Descricao.: Verifica se o arquivo dbf existe.                             *
*                                                                           *
****************************************************************************/
Static Function fvldOk()
Local lRet:=.f.
Local cArq:=alltrim(cPath)+alltrim(carquivo)+".dbf"

If !lIsDir(alltrim(cPath))
	ApMsgAlert("Diretório inválido!","Atenção")
EndIf

For nX:=1 to len(alltrim(carquivo))
	If substr(cArquivo,nX,1) $ ("\/:*?<>"+char(34)) // char(34) = "
		ApMsgAlert("Nome de arquivo inválido!"+char(10)+"Não pode conter:"+char(10)+"  \ / : * ? < > "+char(34),"Atenção")
		return .f.
	EndIf
Next nX

If File(cArq)
	lRet:=ApMsgYesNo("Deseja sobreescrever o arquivo?")
Else
	lRet:=.t.
EndIf

If Empty(alltrim(cPath)) .or. Empty(alltrim(cArquivo))
	ApMsgAlert("Diretório/Arquivo em branco!","Atenção")
	lRet:=.f.
EndIf
Return lRet
