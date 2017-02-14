#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GEFA006   ³ Autor ³ J Ricardo Guimarães   ³ Data ³22/09/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Importação Notfis PSA para geração de CONEMB automaticamente³±±
±±³          ³Geração de CONEMB AEREO                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GEFA006 ()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function GEFA006()

Local cNomArq  := "SAP*.TXT"
Local cDirLog  := ""
Local aFiles      := {}
Local aNomArq     := {}
Local cArqInd  := CriaTrab(,.F.)

Private cCadastro   := "EDI - Recebimento PSA para geração de CONEMB"
Private cDirRec     := AllTrim(GetMv("MV_EDIDIRR"))
Private cDirMov     := AllTrim(GetMv("MV_EDIRMOV"))
Private cLinTxt      := ""
Private __cEDILinTxt := ""
Private aDadosEDI  := {}

Private _cDirEnv := GetMv("MV_EDIDIRE")
Private cArqTxt	 := ""

If Right(_cDirEnv,1) # "\"
	_cDirEnv += "\"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica/Inclui barra no final do diretorio.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Right(cDirRec,1) # "\"
	cDirRec += "\"
Endif

cDirRec := cDirRec + "NOTFIS_AEREO\"

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
			
			If Substr(cLinTxt,1,1)=="D" .AND. Substr(cLinTxt,2,4) == "LE04"  //Verfica se o registro e o de detalhes
				//verifica se a nota ja foi incluida no array, se sim somar o peso e acrescentar mais um volume
//				If (nposn:=AScan(aDadosEDI,{|x| alltrim(x[5]+x[6]) ==Substr(cLinTxt,62,6)+StrTran(Substr(cLinTxt,68,10),"/","")}))=0
					Aadd(aDadosEDI,{Substr(cLinTxt,2,4),; 			// 1-Forma de despacho
					Substr(cLinTxt,6,8),;	   						// 2-Numero da Remessa
					EdiValCgc(Substr(cLinTxt,14,14)),;				// 3-remetente
					EdiValcgc(Substr(cLinTxt,28,14)),;				// 4-destinatário
					Substr(cLinTxt,62,06),;						 	// 5-numero da nota
					StrTran(Substr(cLinTxt,71,10),"/",""),;			// 6-data da nota
					StrTran(Substr(cLinTxt,81,10),",",""),;			// 7-valor da nota
					1,;						  						// 8-qtde de volume
					StrTran(Substr(cLinTxt,97,7),",","") ,;			// 9-peso do volume
					Substr(cLinTxt,68,3) })                         // 10-Serie 					
//				Else
//					aDadosEDI[nposn,8]+=1
//					aDadosEDI[nposn,9]+=Val(StrTran(Substr(cLinTxt,94,7),",","."))
//				EndIf
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| RunCont() },"Lendo NotFis ...")

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

Local cArq 			:= Substr(Dtos(dDataBase),5,2) + Substr(Dtos(dDataBase),7,2) + Substr(Time(),1,2) + Substr(Time(),4,2) + "CONEMB_BARUERI.LOG" // arquivo de log
Local cDirLogs  	:= GetMv("MV_GEF004") // Diretorio que se encontra os arquivos logs
Local aLogImport 	:= {}
Local nHdl2 
Local cBloqueio		:= '1'

For i=1 to len(aDadosEDI)

	// Não é registro de AEREO
	If aDadosEDI[i,1]<>"LE04"
		Loop
	EndIf
	
	// DbselectArea("DE5")
	// DbSetOrder(4)
	
	If aDadosEDI[i,4]=="00000000000000" .or. aDadosEDI[i,4]==space(14) //verifica se o CNPJ do destinatário está preenchido
		aAdd(aLogImport, {"CNP Destinatário " + aDadosEDI[i,4] + " inválido. Nota Fiscal " +aDadosEDI[i,5]+"."+ CHR(13)+CHR(10) } )
	ElseIf Empty(Alltrim(aDadosEDI[i,1])) //verifica se a forma de despacho está preenchida
		aAdd(aLogImport, {"Forma de despacho não está preenchida. Nota Fiscal " +aDadosEDI[i,5]+"."+ CHR(13)+CHR(10) } )
	Else
   		DbselectArea("SA1")
		DbSetOrder(3)//FILIAL+CNPJ
		//Verifica se o destinatário existe no cadastro de clientes
		If !Dbseek(xFilial("SA1")+Padr(aDadosEDI[i,4],14)) .and. aDadosEDI[i,1]=="LE04"
			aAdd(aLogImport, {"CNPJ Destinatário " + aDadosEDI[i,4] + " não encontrado no cadastro de cliente. Nota Fiscal " +aDadosEDI[i,5]+"."+ CHR(13)+CHR(10) } )
//			cBloqueio:='1'
		Else
//			cBloqueio:='2'
		EndIf
	EndIf
/*	
	lRetDE5:=.T.
	RecLock("DE5",.T.)
	DE5->DE5_FILIAL := xFilial("DE5")
	DE5->DE5_DTAEMB	:= Stod(aDadosEDI[i,6])
	DE5->DE5_DOC	:= aDadosEDI[i,5]
	DE5->DE5_EMINFC	:= Stod(aDadosEDI[i,6])
	DE5->DE5_VALOR	:= aDadosEDI[i,7]
	DE5->DE5_QTDVOL	:= aDadosEDI[i,8]
	DE5->DE5_PESO	:= aDadosEDI[i,9]
	DE5->DE5_CGCREM	:= aDadosEDI[i,3]
	DE5->DE5_CGCDES	:= aDadosEDI[i,4]
	DE5->DE5_CGCDEV	:= aDadosEDI[i,3]
	DE5->DE5_CODPRO	:= IIF(cFilAnt=="03", "EMBALAGEM","PECAS") // GetMV("MV_PROGEN")
	DE5->DE5_TIPFRE	:= "1"
	DE5->DE5_TIPTRA := If(aDadosEDI[i,1]=="LE04","2", "1")
	DE5->DE5_CODEMB	:= GetMV("MV_GEF001")
	DE5->DE5_STATUS	:= If(aDadosEDI[i,1]=="LE04","2", "1")
	DE5->DE5_MSBLQL	:= cBloqueio	
	DE5->(MsUnlock())
*/	
Next i

If Len(aDadosEDI) > 0
	*----------------------------------------------------*
	Processa({|| RunGerCONEMB() },"Gerando CONEMB ...")   
	*----------------------------------------------------*
Else
	Alert("Não há registro de AEREO no arquivo processado.")	
EndIf	

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

*----------------------------------------------------*
// Gerar CONEMB através de NotFis
*----------------------------------------------------*
Static Function RunGerCONEMB()

Local lSeqEnd	:=.F.
Local cChaveEnd	:=""
Local cEOL		:= CHR(13)+CHR(10)
Local l324	 	:=.T.
Local lGrvDt6:=.T.
Private cArqTxt :=""
Private nHdl	:=""

cArqTxt  :="DOCS"+ Substr(Dtos(Date()),7,2)+SubStr(Dtos(Date()),5,2)+SubStr(Dtos(Date()),1,4)+Left(StrTran(Time(),":",""),6)+"_AEREO.txt"
cNomArq:= Alltrim(_cDirEnv)+cArqTxt
conout(cNomArq)
nHdl := fCreate(cNomArq,1)
conout(nHdl)
//Registro 000
cLin	:= "000"
cLin	+= Substr(Dtos(Date()),7,2)+SubStr(Dtos(Date()),5,2)+SubStr(Dtos(Date()),3,2)
cLin	+= LEFT(STRTRAN(TIME(),":",""),4)
cLin	+= "CON"+Strzero(DAY(DATE()),2)+Strzero(MONTH(DATE()),2)+LEFT(STRTRAN(TIME(),":",""),4)+"1"
cLin	+= Space(655)
cLin	+= cEOL
fWrite(nHdl,cLin,Len(cLin))

//Registro 320
cLin	:= "320"
cLin	+= "CONHE"+Strzero(DAY(DATE()),2)+Strzero(MONTH(DATE()),2)+LEFT(STRTRAN(TIME(),":",""),4)+"1"
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
/*
	lRetDE5:=.T.
	RecLock("DE5",.T.)
	DE5->DE5_FILIAL := xFilial("DE5")
	DE5->DE5_DTAEMB	:= Stod(aDadosEDI[i,6])
	DE5->DE5_DOC	:= aDadosEDI[i,5]
	DE5->DE5_EMINFC	:= Stod(aDadosEDI[i,6])
	DE5->DE5_VALOR	:= aDadosEDI[i,7]
	DE5->DE5_QTDVOL	:= aDadosEDI[i,8]
	DE5->DE5_PESO	:= aDadosEDI[i,9]
	DE5->DE5_CGCREM	:= aDadosEDI[i,3]
	DE5->DE5_CGCDES	:= aDadosEDI[i,4]
	DE5->DE5_CGCDEV	:= aDadosEDI[i,3]
	DE5->DE5_CODPRO	:= IIF(cFilAnt=="03", "EMBALAGEM","PECAS") // GetMV("MV_PROGEN")
	DE5->DE5_TIPFRE	:= "1"
	DE5->DE5_TIPTRA := If(aDadosEDI[i,1]=="LE04","2", "1")
	DE5->DE5_CODEMB	:= GetMV("MV_GEF001")
	DE5->DE5_STATUS	:= If(aDadosEDI[i,1]=="LE04","2", "1")
	DE5->DE5_MSBLQL	:= cBloqueio	
	DE5->(MsUnlock())
*/         

nQtdCTc := 0
nVlrCTC := 0
_nPeso  := 0
_nValor := 0

_cNF_Ant := ""

For i := 1 TO Len(aDadosEDI)

	If _cNF_Ant <> aDadosEDI[i,5]
		//Registro 322
		cLin	:= "322"
		cLin	+= cFilAnt
			
		// _aAreaSM0 := SM0->(GetArea("SM0"))
		// SM0->(MsSeek(cEmpAnt+cFilAnt(cString)->FILDOC, .T.))
		cLin	+= Substr(SM0->M0_FILIAL,1,15)
		// SM0->(RestArea(_aAreaSM0))
		
		// Aglutino as NFs
		_nPeso  := 0
		_nValor := 0
		_nVolume:= 0
		// _cNF_Ant := PadL(AllTrim(aDadosEDI[i,5]),12,"0")
		_cNF_Ant := aDadosEDI[i,5]
		For x := i TO Len(aDadosEDI)
			If _cNF_Ant == adadosEDI[x,5]
				_nPeso  +=Val(aDadosEDI[x,9])/1000 
				_nValor +=Val(aDadosEDI[x,9])/100
				_nVolume++
			Else
				Exit
			EndIf
		Next x
			
		cLin	+= PADR("AEREO",5)  // SERIE
		cLin	+= PadL(AllTrim(aDadosEDI[i,5]),12,"0")   // Strzero(VAL(aDadosEDI[i,5]),12)  // Documento/NF
		cLin    += Substr(aDadosEDI[i,6],7,2)+Substr(aDadosEDI[i,6],5,2)+Substr(aDadosEDI[i,6],1,4)  // Dt.Doc
		cLin    += "C" // CIF/FOB
		cLin    +=  PadL(StrTran(AllTrim(Str(_nPeso))   ,".",""),07,"0")  // StrZero(Val(aDadosEDI[i,9])*100,07)	// Peso
		cLin    +=  PadL(StrTran(AllTrim(aDadosEDI[i,7]),".",""),15,"0") // StrZero(Val(aDadosEDI[i,7])*100,15)	// Valor 
		cLin    +=  "000000000000000" 	// aDadosEDI[i,7] // Strzero((cString)->BRICMS*100,15)
		cLin    +=  "0000" 				// Strzero(cAliq*100,4)
		cLin    +=  "000000000000000"	// Strzero((cString)->ICMSRET*100,15)
			
		nFretePeso:=0
		nPedagio  :=0
		nFreteVlr :=0
		nSecCat	  :=0
		nItr	  :=0
		nDespacho :=0
		nGris     :=0
		nOutros   :=0
	
		cLin    +=  "000000000000000" // Strzero(nFretePeso*100,15)
		cLin    +=  "000000000000000" // Strzero(nFreteVlr*100,15)
		cLin    +=  "000000000000000" // Strzero(nSecCat*100,15)
		cLin    +=  "000000000000000" // Strzero(nItr,15)
		cLin    +=  "000000000000000" // Strzero(nDespacho,15)
		cLin    +=  "000000000000000" // Strzero(nPedagio*100,15)
		cLin    +=  "000000000000000" // Strzero(nGris*100,15)
		cLin    +=  "000000000000000" // Strzero(nOutros*100,15)
			
		//Verifica se e substituicao tributaria
		cLin    +=  "2"
	
		//Verifica o Tipo de cliente remetente
		cLin    +=  "J"
		cLin    +=  aDadosEDI[i,3] // Strzero(Val((cString)->CGCREM),14)
			
		//Verifica o Tipo de cliente destinatario
		cLin    +=  "J"
		cLin    +=  aDadosEDI[i,4] // Strzero(Val((cString)->CGCDES),14)
			
		//Verifica o Tipo de cliente consignatario
		cLin    +=  "J"
		cLin    +=  aDadosEDI[i,3] // Strzero(Val((cString)->CGCCON),14)
			
		//Verifica o Tipo de cliente devedor
		cLin    +=  "J"
		cLin    +=  aDadosEDI[i,3] // Strzero(Val((cString)->CGCDEV),14)
			
		//Verifica o Tipo de cliente redespachadora
		cLin    +=  "J"
		cLin    +=  aDadosEDI[i,3] // Strzero(Val((cString)->CGCDPC),14)
			
		cLin    +=  "1" // Space(1)
		cLin    += "0000000000" // Padr((cString)->TABFRE,10)
		/*
		cLin    += PadR(AllTrim(GETMV("GEF005")),20) // Padr((cString)->CCUSTO,20)
		cLin    += PadR(AllTrim(GETMV("GEF006")),20) // Padr((cString)->CCONT,20)
		cLin    += PadR(AllTrim(GETMV("GEF007")),20) // Padr((cString)->ORDINT,20)
		cLin    += PadR(AllTrim(GETMV("GEF008")),15) // Padr((cString)->CONTA,15)
		*/
		cLin    += PadR(GETMV("MV_GEF005"),20) // Padr((cString)->CCUSTO,20)
		cLin    += PadR("",20) // Padr((cString)->CCONT,20)
		cLin    += PadR("",20) // Padr((cString)->ORDINT,20)
		cLin    += PadR("",15) // Padr((cString)->CONTA,15)
		
		cLin    += "O" // (cString)->TIPDESPESA
			
		cLin    += "00000000000000000000" // Padr((cString)->REFGEF,20)
		cLin    += "000000"    // Padr((cString)->SERVIC,6)
		cLin    += "000000000" // Padr((cString)->LOTNFC,9)
		cLin    += "I"
		cLin    += "N" // cTipDoc
		cLin    += "9999" // Padr(cCfop,4)
		cLin    += PadR("AEREO",25) // Padr(SubStr(embaralha((cString)->USERLGI,1),1,15),25)
		dbSelectArea("SA1") ; dbSetOrder(3)
		dbSeek(xFilial("SA1")+aDadosEDI[i,3])		
		cLin    += Padr(SA1->A1_COD+SA1->A1_LOJA,8) // Padr((cString)->(CLIREM+LOJREM),8)
		dbSelectArea("SA1") ; dbSetOrder(3)
		dbSeek(xFilial("SA1")+aDadosEDI[i,4])		
		cLin    += Padr(SA1->A1_COD+SA1->A1_LOJA,8) // Padr((cString)->(CLIDES+LOJDES),8)
		dbSelectArea("SA1") ; dbSetOrder(3)
		dbSeek(xFilial("SA1")+aDadosEDI[i,3])				
		cLin    += Padr(SA1->A1_COD+SA1->A1_LOJA,8) // Padr((cString)->(CLICON+LOJCON),8)
		cLin    += Padr(SA1->A1_COD+SA1->A1_LOJA,8) // Padr((cString)->(CLIDPC+LOJDPC),8)
		cLin	+= Space(197)
		cLin	+= cEOL
		fWrite(nHdl,cLin,Len(cLin))
			
		// gravacao do registro 324 - Notas Fiscais
		cLin	:= "324"
		cLin	+= "3" // Padr(DTC->DTC_TIPNFC,1)
		cLin	+= aDadosEDI[i,10]	//"   " // Padr(DTC->DTC_SERNFC,3)
		cLin	+= Strzero(Val(aDadosEDI[i,5]),10) // Strzero(Val(DTC->DTC_NUMNFC),10)
		cLin	+= Substr(aDadosEDI[i,6],7,2)+Substr(aDadosEDI[i,6],5,2)+Substr(aDadosEDI[i,6],1,4) // Substr(Dtos(DTC->DTC_EMINFC),7,2)+Substr(Dtos(DTC->DTC_EMINFC),5,2)+Substr(Dtos(DTC->DTC_EMINFC),1,4)
		cLin	+= StrZero(_nVolume,5) // "00001" // Strzero(DTC->DTC_QTDVOL,5)
		cLin    +=  PadL(AllTrim(StrTran(aDadosEDI[i,7],".","")),15,"0") // StrZero(Val(aDadosEDI[i,7])*100,15)	// Valor 		
		cLin    +=  PadL(AllTrim(StrTran(Str(_nPeso) ,".","")),07,"0")  // StrZero(Val(aDadosEDI[i,9])*100,07)	// Peso		
		cLin	+= StrZero(_nVolume,5) // "00001" 		  // Strzero(DTC->DTC_PESOM3*100,5)
		cLin	+= Space(623)
		cLin	+= cEOL
		fWrite(nHdl,cLin,Len(cLin))
	
		// gravacao do registro 325 - Dados do Remetente
		dbSelectArea("SA1") ; dbSetOrder(3)
		dbSeek(xFilial("SA1")+aDadosEDI[i,3])
		cLin 	:= "325"
		cLin	+= Padr(SA1->A1_NOME,40)   // Padr((cString)->NOMEREM,40)
		cLin    += aDadosEDI[i,3]          // Strzero(Val((cString)->CGCREM),14)
		cLin	+= Padr(SA1->A1_INSCR,15)  // Padr((cString)->INSCREM,15)
		cLin	+= Padr(SA1->A1_END,40)    // Padr((cString)->ENDREM,40)
		cLin	+= Padr(SA1->A1_BAIRRO,20) // Padr((cString)->BAIREM,20)
		cLin	+= Padr(SA1->A1_MUN,35)    // Padr((cString)->MUNREM,35)
		cLin	+= Padr(SA1->A1_CEP,9)     // Padr((cString)->CEPREM,9)
		cLin	+= Padr(SA1->A1_EST,9)     // Padr((cString)->ESTREM,9)
		cLin	+= Padr(SA1->A1_TEL,35)    // Padr((cString)->TELREM,35)
		//Verifica o Tipo de cliente remetente
		cLin    += Space(1)
	
		cLin    += Padr(SA1->A1_COD+SA1->A1_LOJA,8) // Padr((cString)->(CLIREM+LOJREM),8)
		cLin    += Space(451)
		cLin	+= cEOL
		fWrite(nHdl,cLin,Len(cLin))
		
		// gravacao do registro 326 - Dados do Destinatário
		dbSelectArea("SA1") ; dbSetOrder(3)
		dbSeek(xFilial("SA1")+aDadosEDI[i,4])
		
		cLin 	:= "326"
		cLin	+= Padr(SA1->A1_NOME,40)
		cLin    += aDadosEDI[i,4] // Strzero(Val((cString)->CGCDES),14)
		cLin	+= Padr(SA1->A1_INSCR,15)
	
		cLin	+= Padr(SA1->A1_END,40)
		cLin	+= Padr(SA1->A1_BAIRRO,20)
		cLin	+= Padr(SA1->A1_MUN,35)
		cLin	+= Padr(SA1->A1_CEP,9)
		cLin	+= Padr(SA1->A1_EST,9)
	
		cLin	+= Padr(SA1->A1_TEL,35)
		//Verifica o Tipo de cliente remetente
		If SA1->A1_TIPO=='X'
			cLin    +=  "3"
		ElseIf  SA1->A1_PESSOA=='F'
			cLin    +=  "2"
		ElseIf  SA1->A1_PESSOA=='J'
			cLin    +=  "1"
		Else
			cLin    += Space(1)
		EndIf
		cLin    += "1" // If(lSeqEnd,'2','1')
		cLin    += Padr(SA1->A1_COD+SA1->A1_LOJA,8)
		cLin    += Space(450)
		cLin	+= cEOL
		fWrite(nHdl,cLin,Len(cLin))
			
		// gravacao do registro 327 - Dados do Consignatario
		dbSelectArea("SA1") ; dbSetOrder(3)
		dbSeek(xFilial("SA1")+aDadosEDI[i,3])		
		cLin 	:= "327"
		cLin	+= Padr(SA1->A1_NOME,40) // Padr((cString)->NOMECON,40)
		cLin    += aDadosEDI[i,3] 		 // Strzero(Val((cString)->CGCCON),14)
		cLin	+= Padr(SA1->A1_INSCR,15)// Padr((cString)->INSCCON,15)
		cLin	+= Padr(SA1->A1_END,40)  // Padr((cString)->ENDCON,40)
		cLin	+= Padr(SA1->A1_BAIRRO,20) // Padr((cString)->BAICON,20)
		cLin	+= Padr(SA1->A1_MUN,35) // Padr((cString)->MUNCON,35)
		cLin	+= Padr(SA1->A1_CEP,9)  // Padr((cString)->CEPCON,9)
		cLin	+= Padr(SA1->A1_EST,9)  // Padr((cString)->ESTCON,9)
		cLin	+= Padr(SA1->A1_TEL,35) // Padr((cString)->TELCON,35)
		//Verifica o Tipo de cliente remetente
		cLin    +=  "J"  // Space(1)
	
		cLin    += Padr(SA1->A1_COD+SA1->A1_LOJA,8)// Padr((cString)->(CLICON+LOJCON),8)
		cLin    += Space(451)
		cLin	+= cEOL
		fWrite(nHdl,cLin,Len(cLin))
			
		// gravacao do registro 328 - Dados do Redespachante
		cLin 	:= "328"
		cLin	+= Padr(SA1->A1_NOME,40) // Padr((cString)->NOMEDPC,40)
		cLin    += aDadosEDI[i,3] // Strzero(Val((cString)->CGCDPC),14)
		cLin	+= Padr(SA1->A1_INSCR,15) // Padr((cString)->INSCDPC,15)
		cLin	+= Padr(SA1->A1_END,40) // Padr((cString)->ENDDPC,40)
		cLin	+= Padr(SA1->A1_BAIRRO,20) // Padr((cString)->BAIDPC,20)
		cLin	+= Padr(SA1->A1_MUN,35) // Padr((cString)->MUNDPC,35)
		cLin	+= Padr(SA1->A1_CEP,9) // Padr((cString)->CEPDPC,9)
		cLin	+= Padr(SA1->A1_EST,9) // Padr((cString)->ESTDPC,9)
		cLin	+= Padr(SA1->A1_TEL,35) // Padr((cString)->TELDPC,35)
		//Verifica o Tipo de cliente remetente
		cLin    += "J" // Space(1)
	
		cLin    += Padr(SA1->A1_COD+SA1->A1_LOJA,8) // Space(08) // Padr((cString)->(CLIDPC+LOJDPC),8)
		cLin    += Space(451)
		cLin	+= cEOL
		fWrite(nHdl,cLin,Len(cLin))
	EndIF
		
	nQtdCTc++
	nVlrCTC+=Val(aDadosEDI[i,7])*100 // (cString)->VALTOT
	
Next i

// Registro 323
cLin := "323"
cLin += Strzero(nQtdCTC,4)
cLin += Strzero(nVlrCTC*100,15)
cLin += Space(658)
cLin += cEOL

fWrite(nHdl,cLin,Len(cLin))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fClose(nHdl)
Return