#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGEATFA001 บAutor  ณMarcos Furtado      บ Data ณ  29/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de Altera็ใo da Chapa do Ativo Fixo de acordo com o  บฑฑ
ฑฑบ          ณarquivo DBF                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GEATFA001()
Local nOpca 	:= 0 
Local aRegs  	:= {}
Local cPerg		:= "GEA110"
Local cMarca 	:= GetMark() 
Private aRel    := {}

/*Private lMShelpAuto := .T.   // Uso no SIGAAUTO
Private lMSerroAuto := .F.   // Uso no SIGAAUTO-*/

ValidPerg(cPerg)

IF !Pergunte("GEA110")
   Return NIL
EndIF                                            

If MsgYesNo("Confirma a importa็ใo do arquivo "+MV_PAR01,"Atencao !")
	If MV_PAR02 == 1 // Dbf
		PROCESSA({|lEnd| GA01ImpDbf(@lEnd)},"Importando os registros.")
	Else
		//PROCESSA({|lEnd| S110ImpTxt(@lEnd)},"Importando os registros.")
	Endif		
EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGA01ImpDbf  บAutor  ณMarcos Furtado    บ Data ณ  29/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de Altera็ใo da Chapa do Ativo Fixo de acordo com o  บฑฑ
ฑฑบ          ณarquivo DBF                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GA01ImpDbf(lEnd)
Local cLinha	:= ""
Local nLinha	:= 0
Local cCodigo  	:= ""
Local nComis	:= 0
LOCAL nItem     := 0

Private nHandle                
Private nCol	:= 64

// Testa se o arquivo existe
If !File(MV_PAR01)
   MsgStop("O arquivo informado nao existe.",OemToAnsi("Atencao !"))
   Return
EndIF

dbUseArea(.T.,,MV_PAR01,"TRB",.T.,.F.)
dbSelectArea("TRB")
/*IF Alias() <= 0
   MsgStop(OemToAnsi("Impossivel abrir o arquivo."),OemToAnsi("Atencao !"))
   Return
EndIF*/

dbGoTop()                                                                            	
ProcRegua(LastRec())                                               

While !EOF()
                                    
	DbSelectArea("SN1")
	DbSetOrder(1) //FILIAL+CBASE+ITEM
	If DBSeek(TRB->FILIAL+TRB->BEM+StrZero(val(TRB->ITEM),4))

		If Len(AllTrim(TRB->CHAPA)) = 7                               
		    If Empty(SN1->N1_CHAPA) .or. AllTrim(SN1->N1_CHAPA) == '0'		
				RecLock("SN1",.F.)		
				SN1->N1_CHAPA := SubStr(AllTrim(TRB->CHAPA),2,6)		
				MsUnLock()			
			EndIF
		Else
		    If Empty(SN1->N1_CHAPA) .or. AllTrim(SN1->N1_CHAPA) == '0'
				RecLock("SN1",.F.)		    
				SN1->N1_CHAPA := AllTrim(TRB->CHAPA)
				MsUnLock()							
			EndIF
		EndIf

	Else
		aAdd(aRel,{TRB->FILIAL,TRB->BEM,StrZero(val(TRB->ITEM),4),TRB->CHAPA})			
	EndIf
	
	dbSelectArea("TRB")
  	IncProc()
	dbSkip()

EndDo
dbSelectArea("TRB")
dbCloseArea()          

If Len(aRel) > 0
	ImpRel()
EndIf
MsgInfo("Processo Finalizado!","Chapa - ATF")

Return(.T.) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSA110Imp  บAutor  ณAirton nakamura     บ Data ณ  17/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa a rotina de importacao de registros para a tabela บฑฑ
ฑฑบ          ณ de precos                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function S110ImpTxt(lEnd)
Local cLinha	:= ""
Local nLinha	:= 0
Local cGrpCli   := ""
Local cCodPag   := ""
Local cCodTab	:= ""
Local dDtVig	:= dDataBase
Local dDtFVig	:= dDataBase
Local cCodProd	:= ""
Local nPrcUnit	:= 0
Local nQtd      := 0
Local dDtVigI   := dDataBase //dt de vigencia do item
Local nItem		:= 0

Private nHandle                
Private nCol	:= 77
         



// Testa se o arquivo existe
If !File(MV_PAR01)
   MsgStop("O arquivo informado nao existe.",OemToAnsi("Atencao !"))
   Return
EndIF

// Abrir o arquivo especificado
nHandle := FOPEN(MV_PAR01)
IF FERROR() != 0
   MsgStop(OemToAnsi("Impossivel abrir o arquivo."),OemToAnsi("Atencao !"))
   Return
EndIF

FT_FUSE(MV_PAR01)         
FT_FGotop()
                                                                            	
ProcRegua(FT_FLASTREC())                                               

If FT_FLASTREC() = 0
	Return .T.
Endif

While !FT_FEOF()
   
	nLinha	+= 1   
   	cLinha := FT_FREADLN()//leitura de linha do arq texto
   
/*   	If AllTrim(substr(cLinha,1,14)) == "" //Caso encontrar espaco de 14 posicoes no arquivo considera como final do arquivo
      	Exit
   	EndIF                        */

/*'Nome Campo                       tipo         tamanho  posi็ใo Obs
'Grupo de Clientes                Caracter     6        1-6     Campo obrigat๓rio. Deve ser informado sem caracteres especiais de formata็ใo.
'C๓digo da Condi็ใo de Pagamento  Caracter     3        7-9
'C๓digo da Tabela                 Caracter     3        10-12   Campo obrigat๓rio.
'Data de Inํcio de Vig๊ncia       Data         8        13-20   Campo obrigat๓rio.Formato DDMMAAAA, sem formata็ใo
'Data de T้rmino de Vig๊ncia      Data         8        21-28   Campo obrigat๓rio.Formato DDMMAAAA, sem formata็ใo
'C๓digo do Produto                Caracter     15       29-43   Campo obrigat๓rio.
'Pre็o Unitแrio                   Numerico     16       44-59   Pre็o Unitแrio * 100
'Quantidade                       Numerico     10       60-69   Quantidade
'Inํcio de Vig๊ncia do Item       Data         8        70-77   Inํcio de Vig๊ncia do Item*/

	cGrpCli	:= AllTrim(substr(cLinha, 001, 006))

	// Dados contidos na linha
	cCodPag := substr(cLinha, 007, 003)							//condi็ใo de pagamento
   	cCodTab	:= substr(cLinha, 010, 003)							//tabela de precos
   	dDtVig	:= SToD(AllTrim(substr(cLinha, 017, 004))+AllTrim(substr(cLinha, 015, 002))+AllTrim(substr(cLinha, 013, 002)))	//data de vigencia de
   	dDtFVig	:= SToD(AllTrim(substr(cLinha, 025, 004))+AllTrim(substr(cLinha, 023, 002))+AllTrim(substr(cLinha, 021, 002)))	//data de vigencia ate
   	//Dados do Produto
   	cCodProd:= AllTrim(substr(cLinha, 029, 015))							//codigo do produto
   	/*DbSelectArea("SB1")
   	DbSetOrder(1) //FILIAL+CODIGO
   	If !MsSeek(xFilial()+cCodProd)
		AutoGRLog("Arquivo texto: "+ MV_PAR01)
		AutoGRLog("Produto: " + cCodProd + " invalido" + " - linha:"+Str(nLinha))
		AutoGRLog(Replicate("-",80))          
		lMsErroAuto := .F.
	   	IncProc()
	   	FT_FSKIP()
	   	Loop   	
   	EndIf*/

   	nPrcUnit := Val(AllTrim(substr(cLinha, 044, 016))) / 100 //multiplico por 100 pois no arquivo vem sem a virgula
   	nQtd     := Val(AllTrim(substr(cLinha, 060, 010))) / 100 //multiplico por 100 pois no arquivo vem sem a virgula   	
	dDtVigI  :=  SToD(AllTrim(substr(cLinha, 074, 004))+AllTrim(substr(cLinha, 072, 002))+AllTrim(substr(cLinha, 070, 002)))	//data de vigencia item 
	
	//TIPO INCLUSAO

		//Cabecalho
		
        IF nItem = 0
		   	RecLock("DA0",.T.)
	//DA0_CODTAB	DA0_DESCRI	DA0_DATDE	DA0_HORADE	DA0_DATATE	DA0_HORATE	DA0_CONDPG	DA0_TPHORA	DA0_ATIVO	DA0_FILIAL	DA0_GRPCLI	DA0_PERDES	DA0_USERGI	DA0_USERGA
	
		   	DA0_CODTAB	:= cCodTab                                                                               
		   	DA0_CONDPG  := cCodPag
		   	DA0_GRPCLI	:= cGrpCli
		   	DA0_ATIVO   := "2"
		   	DA0_TPHORA  := "1"                          
		   	DA0_DESCRI	:= "TABELA IMPORTADA"
		   	DA0_DATDE	:= dDtVig                     
		   	DA0_HORADE  := "00:00"                                                    
		   	DA0_HORATE  := "29:59"
		   	DA0_DATATE	:= dDtFVig
		   	MsUnLock()
		ENDIF

//Itens
//DA1_FILIAL	DA1_ITEM	DA1_CODTAB	DA1_CODPRO	DA1_PRCBAS	DA1_PRCVEN	DA1_VLRDES	DA1_PERDES	DA1_ATIVO	DA1_FRETE	DA1_ESTADO	DA1_TPOPER	DA1_QTDLOT	DA1_INDLOT	DA1_MOEDA	DA1_DATVIG	DA1_MSEXP	DA1_ULTAFV	DA1_USERGI	DA1_USERGA

	   	nItem += 1
	   	RecLock("DA1",.T.)                          
		DA1_ITEM	:= StrZero(nItem+1,4)		
		DA1_CODTAB	:= cCodTab               
		DA1_CODPRO	:= cCodProd
		DA1_PRCVEN  := nPrcUnit  
		DA1_QTDLOT   := nQtd
		DA1_DATVIG  := dDtVigI
		DA1_INDLOT	:= STRZERO(nQtd,20)
		DA1_MOEDA	:= 1 
		DA1_TPOPER	:= "4"
		DA1_ATIVO   := "1"
		
		MsUnLock()
                   
/*
   	//tipo de operacao
   	DbSelectArea("DA0")
   	DbSetOrder(1) //FILIAL+FORNECEDOR+LOJA+TABELA
	If MsSeek(xFilial()+cCodFor+cCodLoj+cCodTab)
		//Altera cabecalho
		If AIA->AIA_DATDE <> dDtVig
			RecLock("AIA",.F.)
			AIA->AIA_DATDE := dDtVig
			MsUnLock()
		EndIf
		If AIA->AIA_DATATE <> dDtFVig
			RecLock("AIA",.F.)
			AIA->AIA_DATATE	:= dDtFVig
			MsUnLock()
		EndIf
		DbSelectArea("AIB")
		DbSetOrder(2)	//FILIAL+FORNECEDOR+LOJA+TABELA+PRODUTO
		//Altera Item
		If MsSeek(xFilial()+cCodFor+cCodLoj+cCodTab+cCodProd)
			If AIB->AIB_CODPRO <> cCodProd
				RecLock("AIB",.F.)
				AIB->AIB_CODPRO 	:= cCodProd
				MsUnLock()
			EndIf
			If AIB->AIB_PRCCOM <> nPrcUnit
				RecLock("AIB",.F.)
				AIB->AIB_PRCCOM	:= nPrcUnit
				MsUnLock()
			EndIf
			If AIB->AIB_DATVIG <> dDtVig
				RecLock("AIB",.F.)
				AIB->AIB_DATVIG	:= dDtVig
				MsUnLock()
			EndIf
		Else //Incluo Item
			//Calculo de quantos itens existem cadastrados
			If MsSeek(xFilial()+cCodFor+cCodLoj+cCodTab)
				nItem := 0
				While !Eof() .And. AIB->AIB_CODFOR == cCodFor .And. AIB->AIB_LOJFOR == cCodLoj .And. AIB->AIB_CODTAB == cCodTab
					nItem += 1
					DbSkip()
				EndDo
			EndIf
		   	RecLock("AIB",.T.)
		   	AIB->AIB_FILIAL := xFilial()		   	
			AIB->AIB_CODFOR	:= cCodFor
			AIB->AIB_LOJFOR	:= cCodLoj
			AIB->AIB_CODTAB	:= cCodTab
			AIB->AIB_ITEM	:= StrZero(nItem+1,4)
			AIB->AIB_CODPRO := cCodProd
			AIB->AIB_PRCCOM	:= nPrcUnit
			AIB->AIB_DATVIG	:= dDtVig
//			AIB->AIB_CODPRF	:= Posicione("SA5",1,xFilial("SA5")+cCodFor+cCodLoj+cCodProd,"A5_CODPRF")			
			MsUnLock()
		EndIf
	Else
		//Cabecalho
	   	RecLock("AIA",.T.)
	   	AIA->AIA_FILIAL	:= xFilial()
		AIA->AIA_CODFOR	:= cCodFor
	   	AIA->AIA_LOJFOR	:= cCodLoj
	   	AIA->AIA_CODTAB	:= cCodTab
	   	AIA->AIA_DESCRI	:= "TABELA IMPORTADA"
	   	AIA->AIA_DATDE	:= dDtVig
	   	AIA->AIA_DATATE	:= dDtFVig
	   	MsUnLock()
		//Itens
	   	RecLock("AIB",.T.)
	   	AIB->AIB_FILIAL := xFilial()
		AIB->AIB_CODFOR	:= cCodFor
		AIB->AIB_LOJFOR	:= cCodLoj
		AIB->AIB_CODTAB	:= cCodTab
		AIB->AIB_ITEM 	:= "0001"
		AIB->AIB_CODPRO	:= cCodProd
		AIB->AIB_PRCCOM	:= nPrcUnit
		AIB->AIB_DATVIG	:= dDtVig
//		AIB->AIB_CODPRF	:= Posicione("SA5",1,xFilial("SA5")+cCodFor+cCodLoj+cCodProd,"A5_CODPRF")
		MsUnLock()
	EndIf*/
 
   	IncProc()
   	FT_FSKIP()

EndDo

FCLOSE(nHandle)

//retorna indices
DbSelectArea("DA0")
DbSetOrder(1)
DbSelectArea("DA1")
DbSetOrder(1)
DbSelectArea("SB1")
DbSetOrder(1)

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o	 ณVALIDPERG ณ Autor ณ                       ณ Data ณ          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica as perguntas incluindo-as caso nao existam		  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg(cPerg)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Definicoes de variaveis ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cLAlias := Alias()
Local aRegs   := {}

cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))

aAdd(aRegs,{cPerg,"01","Importar o arquivo  ?", "", "", "mv_ch1", "C", 30, 00, 0, "G", "NAOVAZIO()", "MV_PAR01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "", "", "","", "", "", ""})
AADD(aRegs,{cPerg,"02","Formato do Arq.     ?", "", "", "mv_ch2", "N",  1  ,0 ,1,"C" ,""           ,"mv_par02","DBF","Si","Yes","","","TXT","No","No","","","","","","","","","","","","","","","","","","","",""})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualizacao do SX1 com os parametros criadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX1")
dbSetorder(1)
For nLoop1 := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[nLoop1,2])
		RecLock("SX1",.T.)
		For nLoop2 := 1 to FCount()
			FieldPut(nLoop2,aRegs[nLoop1,nLoop2])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRetorna ambiente originalณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea(cLAlias)

Return


#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บ Autor ณ AP6 IDE            บ Data ณ  29/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ImpRel


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Bens nao encotradados"
Local cPict          := ""
Local titulo       := "Relatorio de Bens nao cadastrados"
Local nLin         := 80
//                     01234567890123456789012345678901234567890123456789
Local Cabec1       := "FILIAL BEM         ITEM CHAPA"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SA1"

dbSelectArea("SA1")
dbSetOrder(1)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  29/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem


SetRegua(Len(aRel))



For I:= 1 to Len(aRel)

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   @nLin,00 PSAY Alltrim(aRel[I,1]) 
   @nLin,07 PSAY Alltrim(aRel[I,2]) 
   @nLin,19 PSAY Alltrim(aRel[I,3]) 
   @nLin,24 PSAY Alltrim(aRel[I,4])          

   nLin ++

Next 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
