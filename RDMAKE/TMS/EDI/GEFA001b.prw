#include 'protheus.ch'
#include 'parmtype.ch'
#include 'Fileio.ch'

/*/{Protheus.doc} GEFA001
//TODO Importação NotFis Psa - SAPX. - Implementada melhorias devido mudança de Barueri para Porto Real
@author u297686 - Ricardo Guimarães
@since 22/02/2017
@version 2.00

@type function - Chamada via menu to TMS
/*/User Function GEFA001b()

Local cNomArq  		:= "SAP*.TXT"
Local cDirLog  		:= ""
Local aFiles      	:= {}
Local aNomArq     	:= {}
Local cArqInd  		:= CriaTrab(,.F.)
Local nTotNFe		:= 0

Private cCadastro   := "EDI - Recebimento PSA"
Private cDirRec     := AllTrim(GetMv("MV_EDIDIRR"))  // \EDI\RECEBE 
Private cDirMov     := AllTrim(GetMv("MV_EDIRMOV"))
Private cLinTxt     := ""
Private __cEDILinTxt:= ""
Private aDadosEDI  	:= {}
Private cArqTEMP   	:= CriaTrab(,.F.)
Private cArqIndNF		:= CriaTrab(,.F.)
Private cCorte		:= ''
Private cSeqArq		:= '00'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica/Inclui barra no final do diretorio.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Right(cDirRec,1) # "\"
	cDirRec += "\"
Endif

If Right(cDirMov,1) # "\"
	cDirMov += "\"
Endif

aNomArq := Directory(cDirRec+cNomArq,"D",,.T.,1) //-- Retorna todos arquivos do Diretorio.

If Len(aNomArq) == 0
	Aviso("Aviso", "Não há arquivo a serem processados.", {"Ok"})
	Return Nil
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Importa todos arquivos encontrados.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCnt:= 1 To Len(aNomArq)
	
	If File(cDirRec+aNomArq[nCnt, 1])
		
		If !Empty(GetAdvFVal('PA9','PA9_ARQ',AllTrim(aNomArq[nCnt, 1]),3,''))
			Aviso("Alerta","Arquivo " + cDirRec+aNomArq[nCnt, 1] + " já processado(PA9).")
			Loop
		EndIf	
		
		// cSeqArq	:= StrZero(nCnt,(TamSX3('PA9_SEQARQ')[1]),2)
		
		If nCnt == 1
			fProcArq(aNomArq[nCnt, 1], aNomArq[nCnt, 3], aNomArq[nCnt, 4],'P')
		Else
			fProcArq(aNomArq[nCnt, 1], aNomArq[nCnt, 3], aNomArq[nCnt, 4],'' )
		EndIf	
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre arquivo texto e Posiciona no inicio do arquivo. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FT_FUSE(cDirRec+aNomArq[nCnt, 1])
		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		
		While !FT_FEOF()
			
			IncProc()
			
			//-- Verifica se o arquivo esta vazio
			If Empty(AllTrim(FT_FREADLN()))
				FT_FSKIP()
				Loop
			EndIf
			
			__cEDILinTxt := FT_FREADLN()
			cLinTxt      := __cEDILinTxt
			
			If Substr(cLinTxt,1,1)=="D"   //Verfica se o registro e o de detalhes
				//verifica se a nota ja foi incluida no array, se sim somar o peso e acrescentar mais um volume
				If (nposn:=AScan(aDadosEDI,{|x| alltrim(x[5]+x[10]+x[6]) = Substr(cLinTxt,62,6)+Substr(cLinTxt,68,3)+StrTran(Substr(cLinTxt,71,10),"/","")}))=0				
					Aadd(aDadosEDI,{Substr(cLinTxt,2,4),; 										// 1-Forma de despacho
					Substr(cLinTxt,6,8),;	   													// 2-Numero da Remessa
					EdiValCgc(Substr(cLinTxt,14,14)),;											// 3-remetente
					EdiValcgc(Substr(cLinTxt,28,14)),;											// 4-destinatário
					Substr(cLinTxt,62,6),;    					 								// 5-numero da nota
					StrTran(Substr(cLinTxt,71,10),"/",""),;		    							// 6-data da nota
					Val(StrTran(Substr(cLinTxt,81,10),",",".")),;								// 7-valor da nota
					1,;						  													// 8-qtde de volume
					Val(StrTran(Substr(cLinTxt,98,7),",",".")),;								// 9-peso do volume
					Substr(cLinTxt,68,3),;                       								// 10-Serie 
					UPPER(StrTran(StrTran(Substr(cLinTxt,108,20),chr(13),""),chr(10),"")),; 	// 11-Zona	
					Substr(cLinTxt,128,44),;                       								// 12-Chave da NF-e	
					Substr(cLinTxt,172,04),;                       								// 13-CFOP			
					Substr(cLinTxt,42,6)  ,;													// 14-Armazém
					PA9->PA9_SEQARQ       })  					 								// 15-Seq.Arq.
             		
				Else                                                                                        
					aDadosEDI[nposn,8]+=1
					aDadosEDI[nposn,9]+=Val(StrTran(Substr(cLinTxt,98,7),",","."))
				EndIf

				nTotNFe++

			EndIf
//					UPPER(StrTran(StrTran(Substr(cLinTxt,104,20),chr(13),""),chr(10),"")) })              // 11-Zona			
			FT_FSKIP()
		EndDo
		FT_FUSE()

		PA9->(RecLock('PA9',.F.))
			PA9->PA9_TOTNFE := nTotNFe
		PA9->(MsUnLock())	  		
		nTotNFe		:= 0
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Copia o arquivo p/ outro diretorio e apaga do atual. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		__CopyFile(cDirRec+aNomArq[nCnt,1],cDirMov+aNomArq[nCnt,1])
		If File(cDirMov+aNomArq[nCnt,1])
			FErase(cDirRec+aNomArq[nCnt,1])
		Endif
	EndIf
Next nCnt


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aDadosEDI) > 0
	Processa({|| RunCont() },"Gravando DE5...")
Else
	MsgInfo("Nenhum arquivo " + cNomArq + " localizado","Informação")
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ Katia Alves Bianchiº Data ³  12/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao para garvar o DE5 e o arquivo de log                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont()

Local cArq 			:= Substr(Dtos(dDataBase),5,2) + Substr(Dtos(dDataBase),7,2) + Substr(Time(),1,2) + Substr(Time(),4,2) + ".LOG" // arquivo de log
Local cDirLogs  		:= GetMv("MV_GEF004") // Diretorio que se encontra os arquivos logs
Local aLogImport 		:= {}
Local nHdl2 
Local cBloqueio		:= '1'
Local _aRetInfNFe   	:= Array(2)
Local _cDoc			:= ''
Local _cSerie			:= ''

For i=1 to len(aDadosEDI)
		
	DbselectArea("DE5")
	DbSetOrder(1)

	_cDoc 		:= StrZero(Val(aDadosEDI[i,5]),9)
	_cSerie 	:= StrZero(Val(aDadosEDI[i,10]),3)
	
	If aDadosEDI[i,4]=="00000000000000" .or. aDadosEDI[i,4]==space(14) //verifica se o CNPJ do destinatário está preenchido
		aAdd(aLogImport, {"CNP Destinatário " + aDadosEDI[i,4] + " inválido. Nota Fiscal " +aDadosEDI[i,5]+"."+ CHR(13)+CHR(10) } )
	ElseIf Empty(Alltrim(aDadosEDI[i,1])) //verifica se a forma de despacho está preenchida
		aAdd(aLogImport, {"Forma de despacho não está preenchida. Nota Fiscal " +aDadosEDI[i,5]+"."+ CHR(13)+CHR(10) } )
	ElseiF Dbseek(xFilial("DE5")+aDadosEDI[i,3]+_cDoc+_cSerie) //Verifica se a Nota Fiscal já foi cadastrada
		aAdd(aLogImport, {"Nota Fiscal " +aDadosEDI[i,5]+" ja cadastrada."+ CHR(13)+CHR(10) } )
	ElseiF Empty(Posicione("SA1",3,xFilial("SA1")+aDadosEDI[i,3], "A1_CDRDES")) //Verifica se a região do remetente está preenchida
		aAdd(aLogImport, {"Região do Remetente " +aDadosEDI[i,3]+" não informada no cadastro de cliente."+ CHR(13)+CHR(10) } )
	ElseiF Empty(Posicione("SA1",3,xFilial("SA1")+aDadosEDI[i,4], "A1_CDRDES")) //Verifica se a região do remetente está preenchida
		aAdd(aLogImport, {"Região do Destinatário " +aDadosEDI[i,4]+" não informada no cadastro de cliente."+ CHR(13)+CHR(10) } )
	ElseIf Empty(Alltrim(aDadosEDI[i,11])) .OR. Alltrim(aDadosEDI[i,11]) == '000'//verifica se a Zona está preenchida
		aAdd(aLogImport, {"Zona não informado no arquivo. Nota Fiscal " +aDadosEDI[i,5]+"."+ CHR(13)+CHR(10) } )		
	ElseIf Empty(Alltrim(aDadosEDI[i,14])) .OR. Alltrim(aDadosEDI[i,14]) = '000'  //verifica se o Armazem está preenchida
		aAdd(aLogImport, {"Armazem não informado no arquivo. Nota Fiscal " +aDadosEDI[i,5]+"."+ CHR(13)+CHR(10) } )		
	Else
   		DbselectArea("SA1")
		DbSetOrder(3)//FILIAL+CNPJ
		//Verifica se o destinatário existe no cadastro de clientes
		If !Dbseek(xFilial("SA1")+Padr(aDadosEDI[i,4],14)) .and. aDadosEDI[i,1]<>"LE04"
			aAdd(aLogImport, {"CNP Destinatário " + aDadosEDI[i,4] + " não encontrado no cadastro de cliente. Nota Fiscal " +aDadosEDI[i,5]+"."+ CHR(13)+CHR(10) } )
			cBloqueio:='1'
		Else
			cBloqueio:='2'
		EndIf

		/*-----------------------------------------------------
  		  Pego informações da NF-e na tabela SZ6
		-----------------------------------------------------*/
		_aRetInfNFe[1] 	:= _aRetInfNFe[2] := ""  // 1 = ID NF-e ; 2 = CFOP
		_aRetInfNFe 	:= fBuscaNFEID(aDadosEDI[i,5],aDadosEDI[i,10],aDadosEDI[i,3])
	
		lRetDE5:=.T.
		RecLock("DE5",.T.)
		DE5->DE5_FILIAL 	:= xFilial("DE5")
		DE5->DE5_DTAEMB	:= Stod(aDadosEDI[i,6])
		DE5->DE5_NFEID  	:= _aRetInfNFe[1]
		DE5->DE5_DOC		:= _cDoc
		DE5->DE5_SERIE	:= _cSerie
		DE5->DE5_EMINFC	:= Stod(aDadosEDI[i,6])
		DE5->DE5_VALOR	:= aDadosEDI[i,7]
		DE5->DE5_QTDVOL	:= aDadosEDI[i,8]
		DE5->DE5_PESO		:= aDadosEDI[i,9]
		DE5->DE5_CGCREM	:= aDadosEDI[i,3]
		DE5->DE5_CGCDES	:= aDadosEDI[i,4]
		DE5->DE5_CGCDEV	:= aDadosEDI[i,3]
		DE5->DE5_CODPRO	:= "PECAS" // IIF(cFilAnt=="03", "EMBALAGEM","PECAS") // GetMV("MV_PROGEN")
		DE5->DE5_TIPFRE	:= "1"
		DE5->DE5_TIPTRA 	:= If(aDadosEDI[i,1]=="LE04","2", "1")
		DE5->DE5_CODEMB	:= GetMV("MV_GEF001")
		DE5->DE5_STATUS	:= If(aDadosEDI[i,1]=="LE04","2", "1")
		DE5->DE5_MSBLQL	:= cBloqueio	     
		
		// Para atender EDI de Barueri - Por: Ricardo - Em: 29/09/10
		DE5->DE5_CCUSTO	:= GetMV("MV_GEF005")
		DE5->DE5_TIPDES	:= "0"
		If cBloqueio == "2"
			DE5->DE5_MUN	:= SA1->A1_MUN
			DE5->DE5_ESTADO	:= SA1->A1_EST
		EndIf	
		
		DE5->DE5_NFEID  := aDadosEDI[i,12]
		DE5->DE5_CFOPNF := aDadosEDI[i,13] 					

		DE5->DE5_XZONA  := aDadosEDI[i,11]

		// Por: Ricardo Guimaraes - Em: 03/04/2014 - Objetivo: Atender Projeto Full TMS - Tratamento de transferencia
		DE5->DE5_SERTMS := IIF(AllTrim(aDadosEDI[i,11]) $ GETMV("MV_GEF014"),"2","3")
		DE5->DE5_SERVIC := IIF(AllTrim(aDadosEDI[i,11]) $ GETMV("MV_GEF014"),GetMV("MV_GEF013"), GetMV("MV_GEF002"))
		
		DE5->DE5_XARMAZ := Left(AllTrim(aDadosEDI[i,14]),3)
		DE5->DE5_XDTPRO := dDATABASE
		DE5->DE5_XCORTE := cCorte 
		DE5->DE5_XARQ   := aDadosEDI[i,15]
			
		DE5->(MsUnlock())
	EndIf
Next i

//Gravacao do arquivo de log
If Len(aLogImport) > 0
	nhdl2  := fcreate(cArq)
	If nhdl2 <> -1
		For nX := 1 to Len(aLogImport)
			fwrite(nhdl2,aLogImport[nx,1] )
		Next nX
	EndIf
	
	fclose(nhdl2) // fecha arquivo texto
	_CopyFile(cArq,cDirLogs + cArq)
	Ferase(cArq)

	Alert("Foi gerado errata.  Favor consultar arquivo " + cArq + " na pasta " + cDirLogs)
	
	fEnvMail((cDirLogs + cArq))	
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga o arquivo temporário de CFOPs da NFs         . ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If File(cDirMov+(cArqTEMP))
	FErase(cDirRec+cArqTEMP+GetDBExtension())
	FErase(cIndex+OrdBagExt())	
Endif		

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±                         ROTINAS DO EDI 					                ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ EdiValCgc³ Autor ³Katia Alves Bianchi    ³ Data ³15.05.2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cCgcCpf                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ EDI                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function EdiValCgc(cCGC,nTpRet,nMsg)

Local nCnt,i,j,cDVC,nSum,nDIG,cDIG:=cCGC1:=''

cCGC := EDICgc(cCgc)   // Elimina caracteres nao numericos do CGC

If cCgc == '00000000000000'
	Return(cCgc)
Endif

If Substr(cCGC,1,3) == "000" .and. Substr(cCGC,9,3) <> "000"
	cCGC := Substr(cCGC,4,11)          	//  Utiliza para calculo do DV do CPF
EndIf

Return(cCGC)  


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³EDICgc    ³ Autor ³                       ³ Data ³ 15/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Elimina caracteres do CGC                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ EDI                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function EDICgc( cCgc )

Local cRet := StrTran( cCgc, "", "." )
//cRet := StrTran( cCgc, " ", ".")
cRet := StrTran( cCgc, ".", "" )
cRet := StrTran( cRet, "/", "" )
cRet := StrTran( cRet, "-", "" )

Return( cRet )

**********************************************************
* Por: Ricardo Guimarães - Em: 05/11/2013                *
* Objetivo: Buscar o informações da NF-e na tabela SZ6   *
**********************************************************
Static Function fBuscaNFEID(_cNumNFE, _cSerNFE, _cCNPJRem)
Local _aArea  := GetArea()
Local _aInfNFE:= Array(2)

_aInfNFE[1] := "" // IDNFE
_aInfNFE[2] := "" // CFOP

dbSelectArea("SZ6") ; dbSetOrder(1)
If dbSeek(xFilial("SZ6") + StrZero(Val(_cNumNFE),9) + StrZero(Val(_cSerNFE),3) + _cCNPJRem)
	_aInfNFE[1] := SZ6->Z6_IDNFE
	_aInfNFE[2] := SZ6->Z6_CFOPPRI
EndIf

Return _aInfNFE
	
return

// Função para gravar dados do arquivo na tabela PA9
Static Function fProcArq(_cArq, _dDatArq, _cHorArq, _cTipoProc)
Local _aArea 		:= GetArea()
Local _lRet		:= .T.
Local _dDatCorte 	:= dDATABASE
Local _cCorteAux	:= ''

dbSelectArea('PA9') ; dbSetOrder(1)
If !dbSeek(xFilial() + DTOS(_dDatCorte))
	cCorte 	:= '01'
	cSeqArq := '01'
Else
	While !PA9->(Eof()) .AND. _dDatCorte == PA9->PA9_DTCORT
		_cCorteAux := PA9->PA9_CORTE
		PA9->(dbSkip())
	End
	If _cTipoProc == "P"		
		cCorte := Soma1(_cCorteAux)
	EndIf
	cSeqArq	:= Soma1(cSeqArq)		
EndIf

RecLock('PA9',.T.)
	PA9->PA9_FILIAL := xFilial('PA9')
	PA9->PA9_DTCORT := _dDatCorte
	PA9->PA9_CORTE  := cCorte
	PA9->PA9_ARQ	  := _cArq
	PA9->PA9_SEQARQ := cSeqArq
	PA9->PA9_STATUS := 'C'
	PA9->PA9_DTARQ  := _dDatArq
	PA9->PA9_HORARQ := StrTran(_cHorArq,':','')
PA9->(MsUnLock())	  

RestArea(_aArea)
Return _lRet

*-------------------------------------------------*
Static Function fEnvMail(_cArqAnexo)
*-------------------------------------------------*
Local aUser    	:= {}
Local _cMail   	:= ""
Local cAssunto 	:= ""
Local cCc		:= ""
Local cPara		:= ""
Local cDe		:= ""
Local cMsg		:= ""
Local cAnexo	:= IIF(Empty(_cArqAnexo),'',_cArqAnexo)

aUser   := PswRet(1)
_cEMail := aUser[1,14] // Busca o e-mail do usuário 

cCc      := "" 
cPara    := _cEMail 
cDe      := GETMV("MV_RELFROM")

If Empty(_cEMail)
	MsgInfo("Favor informar e-mail no cadastro de usuário, para receber Log de Processamento","Informação")
EndIf

cAssunto := "Errata - Carga de arquivo da DE5 - Interface NOTFIS PSA - " + dTOc(dDataBase) + " - " + ALLTRIM(cFilAnt)
	
cMsg := "<b>Segue em anexo Lista de Errata na carga das NF-e´s no TMS: <BR>"
cMsg += "Filial: " + ALLTRIM(cFilAnt)         + "<BR>"
cMsg += "Data  : " + dtoc(dDatabase)          + "<BR>"
cMsg += "Hora  : " + Left(Time(),5)           + "</b><BR>"
cMsg += "<BR>"
cMsg += "<BR>"

cMsg += "<BR><BR><BR><BR>e-mail automático, favor não respondê-lo"
   
*---------------------------------------------*
U_EnvEmail(cDe,cPara,cCc,cAssunto,cMsg,cAnexo)
*---------------------------------------------*	
	              
Return()                                                                                                 
