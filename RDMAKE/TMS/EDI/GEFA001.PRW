#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GEFA001   ³ Autor ³ Katia Alves Bianchi   ³ Data ³11/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Importação Notfis PSA                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GEFA001 ()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function GEFA001()

Local cNomArq  := "SAP*.TXT"
Local cDirLog  := ""
Local aFiles      := {}
Local aNomArq     := {}
Local cArqInd  := CriaTrab(,.F.)

Private cCadastro   := "EDI - Recebimento PSA"
Private cDirRec     := AllTrim(GetMv("MV_EDIDIRR"))  // \EDI\RECEBE 
Private cDirMov     := AllTrim(GetMv("MV_EDIRMOV"))
Private cLinTxt      := ""
Private __cEDILinTxt := ""
Private aDadosEDI  := {}
Private aDadosCFOP := {}
Private cArqCFOP   := "SAPxCFOP*.TXT"
Private cArqTEMP   := CriaTrab(,.F.)
Private cArqIndNF	 := CriaTrab(,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica/Inclui barra no final do diretorio.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Right(cDirRec,1) # "\"
	cDirRec += "\"
Endif

If Right(cDirMov,1) # "\"
	cDirMov += "\"
Endif

If !File(cDirRec+cNomArq)
	
	aDir(cDirRec+"*.*",aFiles) //-- Retorna todos arquivos do Diretorio.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca nos arquivos a Palavra Chave.                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aFiles) > 0
		For nCnt:= 1 To Len(aFiles)
			If At(cNomArq,aFiles[nCnt]) > 0
				aAdd(aNomArq,aFiles[nCnt])
			EndIf
		Next nCnt
	EndIf
	
Else
	aDir(cDirRec+cNomArq,aNomArq)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Importa todos arquivos encontrados.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCnt:= 1 To Len(aNomArq)
	
	If File(cDirRec+aNomArq[nCnt])
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre arquivo texto e Posiciona no inicio do arquivo. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FT_FUSE(cDirRec+aNomArq[nCnt])
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
					Aadd(aDadosEDI,{Substr(cLinTxt,2,4),; 											// 1-Forma de despacho
					Substr(cLinTxt,6,8),;	   														// 2-Numero da Remessa
					EdiValCgc(Substr(cLinTxt,14,14)),;												// 3-remetente
					EdiValcgc(Substr(cLinTxt,28,14)),;												// 4-destinatário
					Substr(cLinTxt,62,6),;    					 									// 5-numero da nota
					StrTran(Substr(cLinTxt,71,10),"/",""),;		    							// 6-data da nota
					Val(StrTran(Substr(cLinTxt,81,10),",",".")),;									// 7-valor da nota
					1,;						  															// 8-qtde de volume
					Val(StrTran(Substr(cLinTxt,98,7),",",".")),;									// 9-peso do volume
					Substr(cLinTxt,68,3),;                       									// 10-Serie 
					UPPER(StrTran(StrTran(Substr(cLinTxt,108,20),chr(13),""),chr(10),"")),; 	// 11-Zona	
					Substr(cLinTxt,128,44),;                       								// 12-Chave da NF-e	
					Substr(cLinTxt,172,04),;                       								// 13-CFOP					
					 })              		
				Else                                                                                        
					aDadosEDI[nposn,8]+=1
					aDadosEDI[nposn,9]+=Val(StrTran(Substr(cLinTxt,98,7),",","."))
				EndIf

			EndIf
//					UPPER(StrTran(StrTran(Substr(cLinTxt,104,20),chr(13),""),chr(10),"")) })              // 11-Zona			
			FT_FSKIP()
		EndDo
		FT_FUSE()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Copia o arquivo p/ outro diretorio e apaga do atual. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		__CopyFile(cDirRec+aNomArq[nCnt],cDirMov+aNomArq[nCnt])
		If File(cDirMov+aNomArq[nCnt])
			FErase(cDirRec+aNomArq[nCnt])
		Endif
	EndIf
Next nCnt


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aDadosEDI) > 0

/*
 // Comentado por Ricardo Guimarães - Em: 20/06/2016 - Motivo: Passou a vir no arquivo da PSA, inclusive a CHAVE da NF-e
 // Por: Ricardo Guimarães - Em: 19/07/2013 - Em virtude da exigência de SEFAZ(CT-e)
*/

//	Processa({|| fMontaCFOP() }, "Montando lista com CFOPs das NFs... ")
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
Local _aRetInfNFe   := Array(2)

For i=1 to len(aDadosEDI)
		
	DbselectArea("DE5")
	// DbSetOrder(4)
	
	If aDadosEDI[i,4]=="00000000000000" .or. aDadosEDI[i,4]==space(14) //verifica se o CNPJ do destinatário está preenchido
		aAdd(aLogImport, {"CNP Destinatário " + aDadosEDI[i,4] + " inválido. Nota Fiscal " +aDadosEDI[i,5]+"."+ CHR(13)+CHR(10) } )
	ElseIf Empty(Alltrim(aDadosEDI[i,1])) //verifica se a forma de despacho está preenchida
		aAdd(aLogImport, {"Forma de despacho não está preenchida. Nota Fiscal " +aDadosEDI[i,5]+"."+ CHR(13)+CHR(10) } )
	ElseiF Dbseek(xFilial("DE5")+aDadosEDI[i,3]+aDadosEDI[i,5]+aDadosEDI[i,6]) //Verifica se a Nota Fiscal já foi cadastrada
		aAdd(aLogImport, {"Nota Fiscal " +aDadosEDI[i,5]+" ja cadastrada."+ CHR(13)+CHR(10) } )
	ElseiF Empty(Posicione("SA1",3,xFilial("SA1")+aDadosEDI[i,3], "A1_CDRDES")) //Verifica se a região do remetente está preenchida
		aAdd(aLogImport, {"Região do Remetente " +aDadosEDI[i,3]+" não informada no cadastro de cliente."+ CHR(13)+CHR(10) } )
	ElseiF Empty(Posicione("SA1",3,xFilial("SA1")+aDadosEDI[i,4], "A1_CDRDES")) //Verifica se a região do remetente está preenchida
		aAdd(aLogImport, {"Região do Destinatário " +aDadosEDI[i,4]+" não informada no cadastro de cliente."+ CHR(13)+CHR(10) } )
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
		DE5->DE5_DOC		:= StrZero(Val(aDadosEDI[i,5]),9)
		DE5->DE5_SERIE	:= StrZero(Val(aDadosEDI[i,10]),3)
		DE5->DE5_EMINFC	:= Stod(aDadosEDI[i,6])
		DE5->DE5_VALOR	:= aDadosEDI[i,7]
		DE5->DE5_QTDVOL	:= aDadosEDI[i,8]
		DE5->DE5_PESO		:= aDadosEDI[i,9]
		DE5->DE5_CGCREM	:= aDadosEDI[i,3]
		DE5->DE5_CGCDES	:= aDadosEDI[i,4]
		DE5->DE5_CGCDEV	:= aDadosEDI[i,3]
		DE5->DE5_CODPRO	:= IIF(cFilAnt=="03", "EMBALAGEM","PECAS") // GetMV("MV_PROGEN")
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
		
		/*
		** Comentado por Ricardo Guimarães - Em: 20/06/2016 - Motivo: Passou a vir no arquivo da PSA, inclusive a CHAVE da NF-e
		// Por: Ricardo Guimarães - Em: 19/07/2013 - Em virtude da exigência de SEFAZ(CT-e)
		If Empty(_aRetInfNFe[2]) // CFOP
			If CFOP->(dbSeek(Right(aDadosEDI[i,05],6) + AllTrim(aDadosEDI[i,10])))
				DE5->DE5_CFOPNF := CFOP->CFOP
			EndIf
		Else
			DE5->DE5_CFOPNF := _aRetInfNFe[2]
		EndIf
		*/

		DE5->DE5_NFEID  := aDadosEDI[i,12]
		DE5->DE5_CFOPNF := aDadosEDI[i,13] 					

		DE5->DE5_XZONA  := aDadosEDI[i,11]

		// Por: Ricardo Guimaraes - Em: 03/04/2014 - Objetivo: Atender Projeto Full TMS - Tratamento de transferencia
		DE5->DE5_SERTMS := IIF(AllTrim(aDadosEDI[i,11]) $ GETMV("MV_GEF014"),"2","3")
		DE5->DE5_SERVIC := IIF(AllTrim(aDadosEDI[i,11]) $ GETMV("MV_GEF014"),GetMV("MV_GEF013"), GetMV("MV_GEF002"))	
		
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
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga o arquivo temporário de CFOPs da NFs         . ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If Select("CFOP") > 0
	dbSelectArea("CFOP") ; dbCloseArea()
EndIf
*/

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

*-----------------------------------------------------------------*
* Por: Ricardo Guimarães  -  Em: 19/07/2013        					*
*                                                  					*
* Objetivo: Carregar uma tebela temporária com os CFOP´s das NFs  *
*-----------------------------------------------------------------*
Static Function fMontaCFOP() 
*-----------------------------------------------------------------*
Local _aArea	:= GetArea()
Local _aCampos := {}
Local aNomArq  := {}   
Local _cNFE    := ""
Local _cSerie  := ""
Local _cCFOP   := ""
Local aFiles   := {}

aDadosEDICFOP  := {}
cArqCFOP   		:= "CFOP*.TXT"

Aadd(_aCampos,{"NFE" 	,"C",06,0 })
Aadd(_aCampos,{"SERIE"  ,"C",03,0 })
Aadd(_aCampos,{"CFOP"   ,"C",04,0 })

cArqTEMP := CriaTrab(_aCampos)
	
DbUseArea(.T.,,cArqTEMP,"CFOP",.F. )
DbSelectArea("CFOP")
cIndex := CriaTrab(nil,.f.)
cChave := "NFE+SERIE"
nIndex :=IndRegua("CFOP",cIndex,cChave,,,"Selecionando Registros...TRA")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica/Inclui barra no final do diretorio.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Right(cDirRec,1) # "\"
	cDirRec += "\"
Endif

If Right(cDirMov,1) # "\"
	cDirMov += "\"
Endif

If !File(cDirRec+cArqCFOP)
	
	aDir(cDirRec+"*.*",aFiles) //-- Retorna todos arquivos do Diretorio.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca nos arquivos a Palavra Chave.                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aFiles) > 0
		For nCnt:= 1 To Len(aFiles)
			If At(cArqCFOP,aFiles[nCnt]) > 0
				aAdd(aNomArq,aFiles[nCnt])
			EndIf
		Next nCnt
	EndIf
	
Else
	aDir(cDirRec+cArqCFOP,aNomArq)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Importa todos arquivos encontrados.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCnt:= 1 To Len(aNomArq)
	
	If File(cDirRec+aNomArq[nCnt])
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre arquivo texto e Posiciona no inicio do arquivo. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FT_FUSE(cDirRec+aNomArq[nCnt])
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
			
			If Substr(cLinTxt,1,1)<>"1" .AND. IsDigit(Substr(cLinTxt,8,1)) //Verfica se o registro e o de detalhes
				//verifica se a nota ja foi incluida na tabela temporária
				
				_cNFE 	:= Substr(cLinTxt,08,6)
				_cSerie	:= Substr(cLinTxt,63,3)
				_cCFOP	:= Substr(cLinTxt,37,4)
				
				dbSelectArea("CFOP")
				If !dbSeek( _cNFE + _cSerie )
					
					RecLock("CFOP",.T.)
						CFOP->NFE 	:= _cNFE
						CFOP->SERIE := _cSerie
						CFOP->CFOP	:= _cCFOP
					MsUnLock()	
										
				EndIf
			EndIf
			FT_FSKIP()
		EndDo
		FT_FUSE()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Copia o arquivo p/ outro diretorio e apaga do atual. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		__CopyFile(cDirRec+aNomArq[nCnt],cDirMov+aNomArq[nCnt])
		If File(cDirMov+aNomArq[nCnt])
			FErase(cDirRec+aNomArq[nCnt])
		Endif
		
	EndIf
Next nCnt

RestArea(_aArea)
Return

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