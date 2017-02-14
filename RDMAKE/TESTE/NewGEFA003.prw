#Include 'Protheus.ch'


User Function NewGEFA003()					// u_NewGEFA003
	Local aArea := GetArea()

	Private nQtdeReg := 0


	xBuildQuery()


	RestArea( aArea )

Return


Static Function xBuildQuery
	Local aArea	:= GetArea()
	Local xSelect := ''
	Local xWhere	:= ''

	Begin Sequence

		xSelect := " Count(*) AS CNTREG "

		If MV_PAR05 = 1
			xWhere := " And DT6.DT6_DATEDI <> ' ' "
		Else
			xWhere := " And DT6.DT6_DATEDI = ' ' "
		EndIf

		xWhere := "%" + xWhere + "%"

		For X := 1 To 2

			StaticCall( GEFRGPO2 , ChkAbort )

			If !lEnd
				Exit
			EndIf

			If Select( "DbTrab" ) # 0
				( DbTrab )->( DbCloseArea() )
			EndIf

			DbTrab := GetNextAlias()

			If X == 2
				xSelect := "DT6_FILDOC FILDOC,DT6.DT6_DOC DOC,DT6.DT6_SERIE SERIE,DT6.DT6_FILDCO FILDCO,DT6.DT6_DOCDCO DOCDCO,"
				xSelect += "DT6.DT6_SERDCO SERDCO,DT6.DT6_CLIREM CLIREM,DT6.DT6_LOJREM LOJREM,DT6.DT6_CLIDES CLIDES,DT6.DT6_LOJDES LOJDES,"
				xSelect += "DT6.DT6_CLICON CLICON,DT6.DT6_LOJCON LOJCON,DT6.DT6_CLIDPC CLIDPC,DT6.DT6_LOJDPC LOJDPC,DT6.DT6_CLIDEV CLIDEV,"
				xSelect += "DT6.DT6_LOJDEV LOJDEV,DT6.DT6_TIPFRE TIPFRE,DT6.DT6_DOCTMS DOCTMS,DT6.DT6_VALTOT VALTOT,DT6.DT6_DATEMI DATEMI,"
				xSelect += "DT6.DT6_HOREMI HOREMI,DT6.DT6_PESO PESO,DT6.DT6_TABFRE TABFRE,DT6.DT6_CCUSTO CCUSTO,DT6.DT6_CCONTCCONT,DT6.DT6_OI ORDINT,"
				xSelect += "DT6.DT6_CONTA CONTA,DT6.DT6_TIPDES TIPDESPESA,DT6.DT6_REFGEF REFGEF,DT6.DT6_SERVIC SERVIC,DT6.DT6_LOTNFC LOTNFC,"
				xSelect += "DT6.DT6_DOCTMS DOCTMS,DT6.DT6_USERGI USERLGI, DT6.R_E_C_N_O_ ,"

				xSelect += "SF2.F2_BASEICM BASEICM,SF2.F2_VALICM VALICM,SF2.F2_ICMSRET ICMRET,SF2.F2_BRICMS BRICMS, "

				xSelect += "SA1A.A1_CGC CGCREM,SA1A.A1_NOME NOMEREM,SA1A.A1_INSCR INSCREM,SA1A.A1_END ENDREM,SA1A.A1_BAIRRO BAIREM,SA1A.A1_MUN MUNREM,"
				xSelect += "SA1A.A1_CEP CEPREM,SA1A.A1_EST ESTREM,SA1A.A1_TEL TELREM,SA1A.A1_PESSOA PESREM,SA1A.A1_TIPO TIPREM,"

				xSelect += "SA1B.A1_CGC CGCDES,SA1B.A1_NOME NOMEDES,SA1B.A1_INSCR INSCDES,SA1B.A1_END ENDDES,SA1B.A1_BAIRRO BAIDES,SA1B.A1_MUN MUNDES,"
				xSelect += "SA1B.A1_CEP CEPDES,SA1B.A1_EST ESTDES,SA1B.A1_TEL TELDES,SA1B.A1_PESSOA PESDES,SA1B.A1_TIPO TIPDES,"

				xSelect += "SA1C.A1_CGC CGCCON,SA1C.A1_NOME NOMECON,SA1C.A1_INSCR INSCCON,SA1C.A1_END ENDCON,SA1C.A1_BAIRRO BAICON,SA1C.A1_MUN MUNCON,"
				xSelect += "SA1C.A1_CEP CEPCON,SA1C.A1_EST ESTCON,SA1C.A1_TEL TELCON,SA1C.A1_PESSOA PESCON,SA1C.A1_TIPO TIPCON,"

				xSelect += "SA1D.A1_CGC CGCDPC,SA1D.A1_NOME NOMEDPC,SA1D.A1_INSCR INSCDPC,SA1D.A1_END ENDDPC,SA1D.A1_BAIRRO BAIDPC,SA1D.A1_MUN MUNDPC,"
				xSelect += "SA1D.A1_CEP CEPDPC,SA1D.A1_EST ESTDPC,SA1D.A1_TEL TELDPC,SA1D.A1_PESSOA PESDPC,SA1D.A1_TIPO TIPDPC,"

				xSelect += "SA1E.A1_CGC CGCDEV,SA1E.A1_NOME NOMEDEV,SA1E.A1_INSCR INSCDEV,SA1E.A1_END ENDDEV,SA1E.A1_BAIRRO BAIDEV,SA1E.A1_MUN MUNDEV,"
				xSelect += "SA1E.A1_CEP CEPDEV,SA1E.A1_EST ESTDEV,SA1E.A1_TEL TELDEV,SA1E.A1_PESSOA PESDEV,SA1E.A1_TIPO TIPDEV "
			EndIf

			xSelect := "%" + xSelect + "%"

			BeginSql Alias DbTrab

				Select	%Exp:cSelect%

				From	%Table:DT6% DT6	Join %Table:SF2% SF2	On	(		SF2.F2_FILIAL = DT6.DT6_FILDOC
																			And	SF2.F2_DOC 	= DT6.DT6_DOC
																			And	SF2.F2_SERIE	= DT6.DT6_SERIE
																			And	SF2.%NotDel%
																		)

											Join %Table:SA1% SA1A On	(		SA1A.A1_COD	 = DT6.DT6_CLIREM
																			And	SA1A.A1_LOJA	 = DT6.DT6_LOJREM
																			And	SA1A.A1_FILIAL = %xFilial:SA1%
																			And SA1A.%NotDel%
																		)

											Join %Table:SA1% SA1B On	( 		SA1B.A1_COD	 = DT6.DT6_CLIDES
																			And	SA1B.A1_LOJA	 = DT6.DT6_LOJDES
																			And	SA1B.A1_FILIAL = %xFilial:SA1%
																			And	SA1B.%NotDel%
																		)


									Left	Join %Table:SA1% SA1C On (		SA1C.A1_COD	 = DT6.DT6_CLICON
																			And	SA1C.A1_LOJA	 = DT6.DT6_LOJCON
																			And	SA1C.A1_FILIAL = %xFilial:SA1%
																			And	SA1C.%NotDel%
																		)


									Left	Join %Table:SA1% SA1D On (		SA1D.A1_COD	 = DT6.DT6_CLIDPC
																			And	SA1D.A1_LOJA	 = DT6.DT6_LOJDPC
																			And	SA1D.A1_FILIAL = %xFilial:SA1%
																			And	SA1D.%NotDel%
																		)

											Join %Table:SA1% SA1E On (		SA1E.A1_COD 	 = DT6.DT6_CLIDEV
																			And SA1E.A1_LOJA	 = DT6.DT6_LOJDEV
																			And SA1E.A1_FILIAL = %xFilial:SA1%
																			And SA1E.%NotDel%
																		)

				Where	(		DT6.%NotDel%
							And	DT6_FILDOC BetWeen %Exp:DtoS( MV_PAR01 )% And %Exp:DtoS( MV_PAR02 )%
							And	DT6_DATEMI BetWeen %Exp:DtoS( MV_PAR03 )% And %Exp:DtoS( MV_PAR04 )%
							And	DT6_SERIE <> 'PED'
							And	DT6_DOCTMS In ('2','5','7','9','A','D')
							And	DT6_FILIAL = %xFilial:DT6%
							And SubString(DT6_CCUSTO,1,3)  = '211'  // Somento CTRC do OVL
						)

				%Exp:xWhere%

			EndSql

			If X == 1
				nQtdeReg := ( DbTrab )->( CNTREG )
			EndIf

		Next X

		If !lEnd
			Break
		EndIf

		aQuery := GetLastQuery()

		( DbTrab )->( DbGoTop() )

		If ( DbTrab )->( Eof() )
			lEnd := .F.
		EndIf

	End Sequence

	RestArea( aArea )

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ GERARQ   º Autor ³Katia Alves Bianchi º Data ³  19/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para montagem do arquivo cArqTxt                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Gefco                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
MV_PAR05	Retransmissao        ?
/*/


Conemb()

dbSelectArea(cString)
dbclosearea()

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³_CriaSX1  ³ Autor ³Katia Alves Bianchi    ³ Data ³19/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ajuste de Perguntas (SX1)                 			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function _CriaSX1()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
aRegs :={}
cPerg := Padr("GEFA03",Len(SX1->X1_GRUPO))

//(sx1) Grupo/Ordem/Pergunta/X1_PERSPA/X1_PERENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSpa1/DefEng1/Cnt01/Var02/Def02/DefSpa2/DefEng2/Cnt02/Var03/Def03/DefSpa3/DefEng3/Cnt03/Var04/Def04/DefSpa4/DefEng4/Cnt04/Var05/Def05/DefSpa5/DefEng5/Cnt05/F3
aAdd(aRegs,{cPerg,"01","Filial De            ?","               ?","               ?","mv_ch1","C",2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","DLB","","","",""})
aAdd(aRegs,{cPerg,"02","Filial Ate           ?","               ?","               ?","mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","DLB","","","",""})
aAdd(aRegs,{cPerg,"03","Data De              ?","¿De Fecha      ?","From date      ?","mv_ch3","D",8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data Ate             ?","¿A  Fecha      ?","To   date      ?","mv_ch4","D",8,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Retransmissao        ?","¿Retransmissao ?","Retransmissao  ?","mv_ch5","N",1,0,0,"C","","mv_par05","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})


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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Conemb    ³ Autor ³Katia Alves Bianchi    ³ Data ³24/04/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                                          			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Conemb()



Local lSeqEnd	:=.F.
Local cChaveEnd	:=""
Local cEOL		:= CHR(13)+CHR(10)
Local l324	 	:=.T.
Local lGrvDt6:=.T.
Private cArqTxt :=""
Private nHdl	:=""

dbSelectArea(cString)
DbgoTop()

cArqTxt  :="DOCS"+ Substr(Dtos(Date()),7,2)+SubStr(Dtos(Date()),5,2)+SubStr(Dtos(Date()),1,4)+Left(StrTran(Time(),":",""),6)+".txt"
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

dbSelectArea(cString)
While !Eof()


	// Verifica se a tabela DTC já foi atualizada caso não tenha sido pula o documento
	dbselectarea("DTC")
	dbsetorder(3)
	If DbSeek(xFilial("DTC")+(cString)->(FILDOC+DOC+SERIE)) .and. !Empty((cString)->CCUSTO) .and.  !Empty((cString)->TIPDESPESA)
		l324:=.T.
	ElseiF !Empty((cString)->(FILDCO+DOCDCO+SERDCO)) .and. DbSeek(xFilial("DTC")+(cString)->(FILDCO+DOCDCO+SERDCO)).and. !Empty((cString)->CCUSTO) .and.  !Empty((cString)->TIPDESPESA)
		l324:=.T.
	Else
		l324:=.F.
	EndIf

	If l324
		lSeqEnd:=.F.
		cChaveEnd:=""
		If (cString)->DOCTMS $ "2|5|6|7|9|A|D|E|F"
			cTipDoc :="N"
		ElseIf (cString)->DOCTMS $ "8|G"
			cTipDoc :="C"
		EndIf

		dbselectarea("SD2")
		dbsetorder(3)	// D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		DbSeek((cString)->(FILDOC+DOC+SERIE))
		cCfop:=SD2->D2_CF
		cAliq:=SD2->D2_PICM

		dbselectarea("SF4")
		dbsetorder(1)	// D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		DbSeek(xFilial("SF4")+SD2->D2_TES)
		csubst:=SF4->F4_ICMSST

		dbSelectArea(cString)

		//Registro 322
		cLin	:= "322"
		cLin	+= (cString)->FILDOC

		_aAreaSM0 := SM0->(GetArea("SM0"))
		SM0->(MsSeek(cEmpAnt+(cString)->FILDOC, .T.))
		cLin	+= Substr(SM0->M0_FILIAL,1,15)
		SM0->(RestArea(_aAreaSM0))

		cLin	+= PADR((cString)->SERIE,5)
		cLin	+= Strzero(VAL((cString)->DOC),12)
		cLin    += Substr((cString)->DATEMI,7,2)+Substr((cString)->DATEMI,5,2)+Substr((cString)->DATEMI,1,4)
		cLin    +=  If((cString)->TIPFRE=='1',"C","F")
		cLin    +=  Strzero((cString)->PESO*100,7)
		cLin    +=  Strzero((cString)->VALTOT*100,15)
		If cSubst="1"
			cLin    +=  Strzero((cString)->BRICMS*100,15)
			cLin    +=  Strzero(cAliq*100,4)
			cLin    +=  Strzero((cString)->ICMSRET*100,15)
		Else
			cLin    +=  Strzero((cString)->BASEICM*100,15)
			cLin    +=  Strzero(cAliq*100,4)
			cLin    +=  Strzero((cString)->VALICM*100,15)
		EndIf
		cQuery2:= "	SELECT 	DT8.DT8_FILDOC   FILDOC, "
		cQuery2+= "			DT8.DT8_DOC      DOC, "
		cQuery2+= "			DT8.DT8_SERIE    SERIE, "
		cQuery2+= "	   		DT8.DT8_VALTOT   VALTOT, "
		cQuery2+= "	  		DT3.DT3_COLIMP   COLIMP "

		cQuery2+= "FROM "+retsqlname("DT8") + " DT8 "

		cQuery2+= "JOIN "+retsqlname("DT3") + " DT3 ON DT3_CODPAS = DT8_CODPAS "
		cQuery2+= " AND DT3_FILIAL = '"+xFilial("DT3")+"'"
		cQuery2+= " AND DT3.D_E_L_E_T_ = ' ' "

		cQuery2+= "WHERE DT8_FILDOC = '"+(cString)->FILDOC+"'"
		cQuery2+= "  AND DT8_DOC = '"+(cString)->DOC+"'"
		cQuery2+= "  AND DT8_SERIE  = '"+(cString)->SERIE+"'"
		cQuery2+= "	 AND DT8_CODPAS <>'TF' "
		cQuery2+= "  AND DT8_FILIAL = '"+xFilial("DT8")+"'"
		cQuery2+= "  AND DT8.D_E_L_E_T_ = ' ' "
		cQuery2 := ChangeQuery(cQuery2)
		TCQUERY cQuery2 New Alias "QDT8"

		nFretePeso:=0
		nPedagio  :=0
		nFreteVlr :=0
		nSecCat	  :=0
		nItr	  :=0
		nDespacho :=0
		nGris     :=0
		nOutros   :=0

		While  !QDT8->(EOF())
			If   QDT8->COLIMP=='1'
				nFretePeso+=QDT8->VALTOT

			ElseIf   QDT8->COLIMP=='2'
				nFreteVlr+=QDT8->VALTOT

			ElseIf   QDT8->COLIMP=='3'
				nSecCat+=QDT8->VALTOT

			ElseIf   QDT8->COLIMP=='4'
				nPedagio+=QDT8->VALTOT

			ElseIf   QDT8->COLIMP=='5'
				nGris+=QDT8->VALTOT

			ElseIf   QDT8->COLIMP=='6'
				nItr+=QDT8->VALTOT

			ElseIf   QDT8->COLIMP=='8'
				nDespacho+=QDT8->VALTOT

			ElseIf   QDT8->COLIMP=='9'
				nOutros+=QDT8->VALTOT

			EndIf
			QDT8->(Dbskip())
		Enddo
		QDT8->(DBCLOSEAREA())
		dbSelectArea(cString)

		cLin    +=  Strzero(nFretePeso*100,15)
		cLin    +=  Strzero(nFreteVlr*100,15)
		cLin    +=  Strzero(nSecCat*100,15)
		cLin    +=  Strzero(nItr,15)
		cLin    +=  Strzero(nDespacho,15)
		cLin    +=  Strzero(nPedagio*100,15)
		cLin    +=  Strzero(nGris*100,15)
		cLin    +=  Strzero(nOutros*100,15)
		//Verifica se e substituicao tributaria
		If cSubst="1"
			cLin    +=  "1"
		Else
			cLin    +=  "2"
		EndIf
		//Verifica o Tipo de cliente remetente
		If (cString)->TIPREM=='X'
			cLin    +=  "E"
			cLin    +=  Padr(((cString)->CLIREM+(cString)->LOJREM),14)
		ElseIf  (cString)->PESREM=='F'
			cLin    +=  "F"
			cLin    +=  Strzero(Val((cString)->CGCREM),14)
		ElseIf  (cString)->PESREM=='J'
			cLin    +=  "J"
			cLin    +=  Strzero(Val((cString)->CGCREM),14)
		Else
			cLin    += Space(15)
		EndIf

		//Verifica o Tipo de cliente destinatario
		If (cString)->TIPDES=='X'
			cLin    +=  "E"
			cLin    +=  Padr(((cString)->CLIDES+(cString)->LOJDES),14)
		ElseIf  (cString)->PESDES=='F'
			cLin    +=  "F"
			cLin    +=  Strzero(Val((cString)->CGCDES),14)
		ElseIf  (cString)->PESDES=='J'
			cLin    +=  "J"
			cLin    +=  Strzero(Val((cString)->CGCDES),14)
		Else
			cLin    += Space(15)
		EndIf

		//Verifica o Tipo de cliente consignatario
		If (cString)->TIPCON=='X'
			cLin    +=  "E"
			cLin    +=  Padr(((cString)->CLICON+(cString)->LOJCON),14)
		ElseIf  (cString)->PESCON=='F'
			cLin    +=  "F"
			cLin    +=  Strzero(Val((cString)->CGCCON),14)
		ElseIf  (cString)->PESCON=='J'
			cLin    +=  "J"
			cLin    +=  Strzero(Val((cString)->CGCCON),14)
		Else
			cLin    += Space(15)
		EndIf

		//Verifica o Tipo de cliente devedor
		If (cString)->TIPDEV=='X'
			cLin    +=  "E"
			cLin    +=  Padr(((cString)->CLIDEV+(cString)->LOJDEV),14)
		ElseIf  (cString)->PESDEV=='F'
			cLin    +=  "F"
			cLin    +=  Strzero(Val((cString)->CGCDEV),14)
		ElseIf  (cString)->PESDEV=='J'
			cLin    +=  "J"
			cLin    +=  Strzero(Val((cString)->CGCDEV),14)
		Else
			cLin    += Space(15)
		EndIf

		//Verifica o Tipo de cliente redespachadora
		If (cString)->TIPDPC=='X'
			cLin    +=  "E"
			cLin    +=  Padr(((cString)->CLIDPC+(cString)->LOJDPC),14)
		ElseIf  (cString)->PESDPC=='F'
			cLin    +=  "F"
			cLin    +=  Strzero(Val((cString)->CGCDPC),14)
		ElseIf  (cString)->PESDPC=='J'
			cLin    +=  "J"
			cLin    +=  Strzero(Val((cString)->CGCDPC),14)
		Else
			cLin    += Space(15)
		EndIf

		cLin    +=  Space(1)
		cLin    += Padr((cString)->TABFRE,10)
		cLin    += Padr((cString)->CCUSTO,20)
		cLin    += Padr((cString)->CCONT,20)
		cLin    += Padr((cString)->ORDINT,20)
		cLin    += Padr((cString)->CONTA,15)
		cLin    += (cString)->TIPDESPESA

		cLin    += Padr((cString)->REFGEF,20)
		cLin    += Padr((cString)->SERVIC,6)
		cLin    += Padr((cString)->LOTNFC,9)
		cLin    += "I"
		cLin    += cTipDoc
		cLin    += Padr(cCfop,4)
		cLin    += Padr(SubStr(embaralha((cString)->USERLGI,1),1,15),25)
		cLin    += Padr((cString)->(CLIREM+LOJREM),8)
		cLin    += Padr((cString)->(CLIDES+LOJDES),8)
		cLin    += Padr((cString)->(CLICON+LOJCON),8)
		cLin    += Padr((cString)->(CLIDPC+LOJDPC),8)
		cLin	+= Space(197)
		cLin	+= cEOL
		fWrite(nHdl,cLin,Len(cLin))

		// gravacao do registro 324 - Notas Fiscais
		dbselectarea("DTC")
		dbsetorder(3)
		If DbSeek(xFilial("DTC")+(cString)->(FILDOC+DOC+SERIE))
			lSeqEnd:=If(Empty(Alltrim(DTC->DTC_SQEDES)),.F.,.T.)
			cChaveEnd:=xFilial("DUL")+DTC->DTC_CLIDES+DTC->DTC_LOJDES+DTC->DTC_SQEDES
			While !Eof() .and. xFilial("DTC")+DTC->(DTC_FILDOC+DTC_DOC+DTC_SERIE) == xFilial("DTC")+(cString)->(FILDOC+DOC+SERIE)
				cLin	:= "324"
				cLin	+= Padr(DTC->DTC_TIPNFC,1)
				cLin	+= Padr(DTC->DTC_SERNFC,3)
				cLin	+= Strzero(Val(DTC->DTC_NUMNFC),10)
				cLin	+= Substr(Dtos(DTC->DTC_EMINFC),7,2)+Substr(Dtos(DTC->DTC_EMINFC),5,2)+Substr(Dtos(DTC->DTC_EMINFC),1,4)
				cLin	+= Strzero(DTC->DTC_QTDVOL,5)
				cLin	+= Strzero(DTC->DTC_VALOR*100,15)
				cLin	+= Strzero(DTC->DTC_PESO*100,7)
				cLin	+= Strzero(DTC->DTC_PESOM3*100,5)
				cLin	+= Space(623)
				cLin	+= cEOL
				fWrite(nHdl,cLin,Len(cLin))
				dbselectarea("DTC")
				dbSkip()
			EndDo
		ElseiF !Empty((cString)->(FILDCO+DOCDCO+SERDCO))
			If DbSeek(xFilial("DTC")+(cString)->(FILDCO+DOCDCO+SERDCO))
				lSeqEnd:=If(Empty(Alltrim(DTC->DTC_SQEDES)),.F.,.T.)
				cChaveEnd:=xFilial("DUL")+DTC->DTC_CLIDES+DTC->DTC_LOJDES+DTC->DTC_SQEDES
				While !Eof() .and. xFilial("DTC")+DTC->(DTC_FILDOC+DTC_DOC+DTC_SERIE) == xFilial("DTC")+(cString)->(FILDCO+DOCDCO+SERDCO)
					cLin	:= "324"
					cLin	+= Padr(DTC->DTC_TIPNFC,1)
					cLin	+= Padr(DTC->DTC_SERNFC,3)
					cLin	+= Strzero(Val(DTC->DTC_NUMNFC),10)
					cLin	+= Substr(Dtos(DTC->DTC_EMINFC),7,2)+Substr(Dtos(DTC->DTC_EMINFC),5,2)+Substr(Dtos(DTC->DTC_EMINFC),1,4)
					cLin	+= Strzero(DTC->DTC_QTDVOL,5)
					cLin	+= Strzero(DTC->DTC_VALOR*100,15)
					cLin	+= Strzero(DTC->DTC_PESO*100,7)
					cLin	+= Strzero(DTC->DTC_PESOM3*100,5)
					cLin	+= Space(623)
					cLin	+= cEOL
					fWrite(nHdl,cLin,Len(cLin))
					dbselectarea("DTC")
					dbSkip()
				EndDo
			EndIf
		EndIf

		// gravacao do registro 325 - Dados do Remetente
		cLin 	:= "325"
		cLin	+= Padr((cString)->NOMEREM,40)
		cLin    += Strzero(Val((cString)->CGCREM),14)
		cLin	+= Padr((cString)->INSCREM,15)
		cLin	+= Padr((cString)->ENDREM,40)
		cLin	+= Padr((cString)->BAIREM,20)
		cLin	+= Padr((cString)->MUNREM,35)
		cLin	+= Padr((cString)->CEPREM,9)
		cLin	+= Padr((cString)->ESTREM,9)
		cLin	+= Padr((cString)->TELREM,35)
		//Verifica o Tipo de cliente remetente
		If (cString)->TIPREM=='X'
			cLin    +=  "3"
		ElseIf  (cString)->PESREM=='F'
			cLin    +=  "2"
		ElseIf  (cString)->PESREM=='J'
			cLin    +=  "1"
		Else
			cLin    += Space(1)
		EndIf
		cLin    += Padr((cString)->(CLIREM+LOJREM),8)
		cLin    += Space(451)
		cLin	+= cEOL
		fWrite(nHdl,cLin,Len(cLin))

		// gravacao do registro 326 - Dados do Destinatário
		cLin 	:= "326"
		cLin	+= Padr((cString)->NOMEDES,40)
		cLin    += Strzero(Val((cString)->CGCDES),14)
		cLin	+= Padr((cString)->INSCDES,15)
		If !lSeqEnd
			cLin	+= Padr((cString)->ENDDES,40)
			cLin	+= Padr((cString)->BAIDES,20)
			cLin	+= Padr((cString)->MUNDES,35)
			cLin	+= Padr((cString)->CEPDES,9)
			cLin	+= Padr((cString)->ESTDES,9)
		Else
			DbSelectArea("DUL")
			DbSetorder(2)
			DbSeek(cChaveEnd)
			cLin	+= Padr(DUL->DUL_END,40)
			cLin	+= Padr(DUL->DUL_BAIRRO,20)
			cLin	+= Padr(DUL->DUL_MUN,35)
			cLin	+= Padr(DUL->DUL_CEP,9)
			cLin	+= Padr(DUL->DUL_EST,9)
		EndIf
		cLin	+= Padr((cString)->TELDES,35)
		//Verifica o Tipo de cliente remetente
		If (cString)->TIPDES=='X'
			cLin    +=  "3"
		ElseIf  (cString)->PESDES=='F'
			cLin    +=  "2"
		ElseIf  (cString)->PESDES=='J'
			cLin    +=  "1"
		Else
			cLin    += Space(1)
		EndIf
		cLin    += If(lSeqEnd,'2','1')
		cLin    += Padr((cString)->(CLIDES+LOJDES),8)
		cLin    += Space(450)
		cLin	+= cEOL
		fWrite(nHdl,cLin,Len(cLin))

		// gravacao do registro 327 - Dados do Consignatario
		cLin 	:= "327"
		cLin	+= Padr((cString)->NOMECON,40)
		cLin    += Strzero(Val((cString)->CGCCON),14)
		cLin	+= Padr((cString)->INSCCON,15)
		cLin	+= Padr((cString)->ENDCON,40)
		cLin	+= Padr((cString)->BAICON,20)
		cLin	+= Padr((cString)->MUNCON,35)
		cLin	+= Padr((cString)->CEPCON,9)
		cLin	+= Padr((cString)->ESTCON,9)
		cLin	+= Padr((cString)->TELCON,35)
		//Verifica o Tipo de cliente remetente
		If (cString)->TIPCON=='X'
			cLin    +=  "3"
		ElseIf  (cString)->PESCON=='F'
			cLin    +=  "2"
		ElseIf  (cString)->PESCON=='J'
			cLin    +=  "1"
		Else
			cLin    += Space(1)
		EndIf
		cLin    += Padr((cString)->(CLICON+LOJCON),8)
		cLin    += Space(451)
		cLin	+= cEOL
		fWrite(nHdl,cLin,Len(cLin))

		// gravacao do registro 328 - Dados do Redespachante
		cLin 	:= "328"
		cLin	+= Padr((cString)->NOMEDPC,40)
		cLin    += Strzero(Val((cString)->CGCDPC),14)
		cLin	+= Padr((cString)->INSCDPC,15)
		cLin	+= Padr((cString)->ENDDPC,40)
		cLin	+= Padr((cString)->BAIDPC,20)
		cLin	+= Padr((cString)->MUNDPC,35)
		cLin	+= Padr((cString)->CEPDPC,9)
		cLin	+= Padr((cString)->ESTDPC,9)
		cLin	+= Padr((cString)->TELDPC,35)
		//Verifica o Tipo de cliente remetente
		If (cString)->TIPDPC=='X'
			cLin    +=  "3"
		ElseIf  (cString)->PESDPC=='F'
			cLin    +=  "2"
		ElseIf  (cString)->PESDPC=='J'
			cLin    +=  "1"
		Else
			cLin    += Space(1)
		EndIf
		cLin    += Padr((cString)->(CLIDPC+LOJDPC),8)
		cLin    += Space(451)
		cLin	+= cEOL
		fWrite(nHdl,cLin,Len(cLin))

		nQtdCTc++
		nVlrCTC+=(cString)->VALTOT

		//Gravar DT6_DATEDI no DT6
		DbSelectArea("DT6")
		DT6->(DbSetOrder(1))//DT6_FILDOC+DT6_DOC+DT6_SERIE
		If DT6->(DbSeek(xfilial("DT6")+(cString)->FILDOC + (cString)->DOC + (cString)->SERIE))
			RecLock("DT6",.F.)
			DT6->DT6_DATEDI := Date()
			MsUnLock()
		EndIf
	EndIf

	dbSelectArea(cString)
	dbSkip()
EndDo

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

