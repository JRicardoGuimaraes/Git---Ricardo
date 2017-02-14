#INCLUDE "RWMAKE.CH"
#Include "Protheus.CH"
#Include "TbiConn.CH"
#Include "Colors.CH"
#Include "RptDef.CH"
#Include "FWPrintSetup.ch"
#Include "TopConn.ch"

User Function ANDRETESTE				// u_ANDRETESTE()

	Local	nOpc 			:= 0
	Local	aDesc			:= "Este programa imprime os boletos de"+chr(13)+"cobranca bancaria de acordo com"+chr(13)+"os parametros informados"
	Local	lEnd			:= .F.

	Private Exec			:= .F.
	Private cIndexName	:= ''
	Private cIndexKey		:= ''
	Private cFilter		:= ''
	Private cPerg			:= "GEFR100"

	Private cBanco		:= CriaVar("A6_COD")
	Private cAgencia		:= CriaVar("A6_AGENCIA")
	Private cConta		:= CriaVar("A6_NUMCON")

	Private _lBcoCorrespondente := .f.

	AjustaSX1()

	If !( Pergunte(cPerg,.T.) )
		Return
	EndIf

	cIndexName := Criatrab(Nil,.F.)

	cIndexKey  := "E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA+DTOS(E1_EMISSAO)"

	cFilter	+= "E1_FILIAL			==	'" +	xFilial("SE1")	+	"'	.And.	E1_SALDO			> 0 .And. "
	cFilter	+= "E1_TIPO			==	'FAT'	.And. "
	cFilter	+= "E1_MOEDA			==	1		.And. "
	cFilter	+= "E1_PREFIXO		>=	'" +	MV_PAR01 			+	"'	.And.	E1_PREFIXO			<=	'"	+	MV_PAR02			+	"'	.And.	"
	cFilter	+= "E1_NUM				>=	'" +	MV_PAR03			+	"'	.And.	E1_NUM				<=	'"	+	MV_PAR04			+	"'	.And.	"
	cFilter	+= "E1_PARCELA		>=	'" +	MV_PAR05			+	"'	.And.	E1_PARCELA			<=	'"	+	MV_PAR06			+	"'	.And.	"
	cFilter	+= "E1_PORTADO		>=	'" +	MV_PAR07			+	"'	.And.	E1_PORTADO			<=	'"	+	MV_PAR08			+	"'	.And.	"
	cFilter	+= "E1_CLIENTE		>=	'" +	MV_PAR09			+	"'	.And.	E1_CLIENTE			<=	'"	+	MV_PAR10			+	"'	.And.	"
	cFilter	+= "E1_LOJA			>=	'" +	MV_PAR11			+	"'	.And.	E1_LOJA			<=	'"	+	MV_PAR12			+	"'	.And.	"
	cFilter	+= "DTOS(E1_EMISSAO)	>=	'"	+	DtoS(MV_PAR13)	+	"'	.And.	DtoS(E1_EMISSAO)	<=	'"	+	DtoS(MV_PAR14)	+	"'	.And.	"
	cFilter	+= 'DTOS(E1_VENCREA)	>=	"'	+	DtoS(MV_PAR15)	+	'"	.And.	DtoS(E1_VENCREA)	<=	"'	+	DtoS(MV_PAR16)	+	'"	.And.	'
	cFilter	+= "E1_NUMBOR			>=	'"	+	MV_PAR17			+	"'	.And.	E1_NUMBOR			<=	'"	+	MV_PAR18			+	"'	.And.	"
	cFilter	+= "!(E1_TIPO			$	'"	+	MVABATIM			+	"')	.And.	E1_SITUACA			==	'0'	"  // Imprime somente títulos que não estão em carteira / Bordero

	SM0->( dbSeek( cEmpAnt+cFilAnt ) )

	IndRegua("SE1" , cIndexName , cIndexKey ,, cFilter , "Aguarde, selecionando registros....")

	DbSelectArea("SE1")
	DbSeek(xFilial())

	@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Titulos"
	@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"

	@ 180,310 BmpButton Type 01 Action ( Exec := .T. , Close(oDlg) )
	@ 180,280 BmpButton Type 02 Action ( Exec := .F. , Close(oDlg) )

	Activate DIALOG oDlg Centered

	If Exec

		If fBanco()

			Processa( { |lEnd| MontaRel( @lEnd ) } )

		EndIf

	EndIf

	DbSelectArea("SE1")
	RetIndex("SE1")
	FErase( cIndexName+OrdBagExt() )

Return Nil

//------------------------------------------------------------------------------------
Static Function MontaRel( lEnd )

	Local oPrint
	Local n			:= 0
	Local aBitmap		:= {"","\Bitmaps\Logo_Siga.bmp"}

	Local aDadosEmp	:= {	SM0->M0_NOMECOM                                                           ,; //Nome da Empresa
								SM0->M0_ENDCOB                                                            ,; //Endere?
								AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //Complemento
								"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //CEP
								"PABX/FAX: "+SM0->M0_TEL                                                  ,; //Telefones
								"C.G.C.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+            ;
								Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ;
								Subs(SM0->M0_CGC,13,2)                                                    ,; //CGC
								"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ;
								Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //I.E

	Local aDadosTit
	Local aDadosBanco
	Local aDatSacado
	Local aBolText			:= { "mv_par12"+"mv_par13","mv_par14"+"mv_par15","mv_par16"+"mv_par17"}
	Local _nVlrDesc			:= 0
	Local _nVlrJuro			:= 0
	Local aBMP					:= aBitMap
	Local i					:= 1
	Local aCB_RN_NN			:= {}
	Local nRec					:= 0
	Local _nVlrAbat			:= 0
	Local cArquivo			:= "BOLETO"
	Local lAdjustToLegacy	:= .T.
	Local lDisableSetup		:= .T.
	Local lViewPDF			:= .T.
	Local cPathInServer		:= GetTempPath(.T.)

	oPrint := FWMSPrinter():New( cArquivo , IMP_PDF ,lAdjustToLegacy,/*[cPathInServer]*/,lDisableSetup,/*[lTReport]*/,@oPrint,/*/cPrinter]*/,/*[lServer]*/,/*[lPDFAsPNG]*/,/*[lRaw]*/,lViewPDF,/*[nQtdCopy]*/ )

	oPrint:SetPortrait()

	dbSelectArea("SE1")
	dbSeek(xFilial())

//	SetRegua( LastRec() )

	While ! Eof()

		Begin Sequence

			If ! Marked("E1_OK")
				Break
			EndIf

			DbSelectArea("SA1")			//	Posiciona o SA1 (Cliente)
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)

			If DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)

		        If SA1->A1_BOLETO == "N"
		        	Break
		        EndIf

			EndIf

			DbSelectArea("SE1")			//	Posiciona o SE1 (Contas a Receber)

			aDadosBanco  :=	{	SA6->A6_COD              ,;		//	1	-	Numero do Banco
									""							,;		//	2	-	Nome do Banco
									SubStr(cAgencia, 1, 4)	,;		//	3	-	Agencia
									StrTran(cConta,"-","")	,;		//	4	-	Conta Corrente
									""							,;		//	5	-	Digito da conta corrente
									" "	}							    //	6	-	Carteira


			If Empty(Alltrim(SA1->A1_ENDCOB))  // Busca o endereco de cobranca
				aDatSacado   := {	AllTrim(SA1->A1_NOME)								,;		//	1	-	Raz? Social
									AllTrim(SA1->A1_COD )                            ,;		//	2	-	C?igo
									AllTrim(SA1->A1_END)+"-"+SA1->A1_BAIRRO			,;		//	3	-	Endere?
									AllTrim(SA1->A1_MUN )								,;		//	4	-	Cidade
									SA1->A1_EST                                      ,;		//	5	-	Estado
									SA1->A1_CEP                                      ,;		//	6	-	CEP
									SA1->A1_CGC	}												//	7	-	CGC/CPF
			Else
				aDatSacado   := {	AllTrim(SA1->A1_NOME)								,;		//	1	-	Raz? Social
									AllTrim(SA1->A1_COD )								,;		//	2	-	C?igo
									AllTrim(SA1->A1_ENDCOB)+"-"+SA1->A1_BAIRROC		,;		//	3	-	Endere?
									AllTrim(SA1->A1_MUNC )								,;		//	4	-	Cidade
									SA1->A1_ESTC											,;		//	5	-	Estado
									SA1->A1_CEPC											,;		//	6	-	CEP
									SA1->A1_CGC	}												//	7	-	CGC/CPF
			Endif

			//	VALOR DOS TITULOS TIPO "AB-"

			_nVlrAbat	:=  SomaAbat( SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA )

			cNroDoc	:= StrZero( Val( Alltrim( SE1->E1_NUM ) + Alltrim( SE1->E1_PARCELA ) ) , 8 )

			cNumBco	:= GetMv("MV_XNUMBCO") // Nosso número da Filial

			If Empty(SE1->E1_NUMBCO)
				cNumBco := SE1->E1_NUMBCO
				PutMv( "MV_XNUMBCO" , SOMA1(cNumBco) )
			EndIf

			aCB_RN_NN	:=  Ret_cBarra( SubStr(aDadosBanco[1],1,3)+"9",SubStr(aDadosBanco[3],1,4),aDadosBanco[4],aDadosBanco[5],AllTrim(E1_NUM)+AllTrim(E1_PARCELA),NoRound(E1_SALDO-_nVlrAbat,2),SE1->E1_VENCREA,Val(cNumBco),aDadosBanco)

			aDadosTit	:=  {	AllTrim(E1_NUM)+AllTrim(E1_PARCELA)		,;	//	1	-	N?ero do t?ulo
								E1_EMISSAO										,;	//	2	-	Data da emiss? do t?ulo
								dDataBase										,;	//	3	-	Data da emiss? do boleto
								E1_VENCREA										,;	//	4	-	Data do vencimento
								(E1_SALDO - _nVlrAbat)						,;	//	5	-	Valor do t?ulo
								AllTrim(aCB_RN_NN[3])						,;	//	6	-	Nosso n?ero (Ver f?mula para calculo)
								SE1->E1_DECRESC								,;	//	7	-	VAlor do Desconto do titulo
								SE1->E1_VALJUR }									//	8	-	Valor dos juros do titulo

			Impress(oPrint,aBMP,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)		//	MONTAGEM DO BOLETO

			DbSelectArea("SE1")
			RecLock("SE1",.f.)
				SE1->E1_NUMBCO := Right(aCB_RN_NN[3],7)   // Nosso número (Ver fórmula para calculo)
			DbUnlock()

		End Sequence

		DbSelectArea("SE1")
		DbSkip()

	EndDo

	oPrint:Preview()     // Visualiza antes de imprimir

Return nil

Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)

	Local oFont8
	Local oFont10
	Local oFont16
	Local oFont16n
	Local oFont20
	Local oFont24
	Local i := 0
	Local aCoords1 := {150,1900,250,2300}  // FICHA DO SACADO
	Local aCoords2 := {420,1900,490,2300}  // FICHA DO SACADO
	Local aCoords3 := {1270,1900,1370,2300} // FICHA DO CAIXA
	Local aCoords4 := {1540,1900,1610,2300} // FICHA DO CAIXA
	Local aCoords5 := {2390,1900,2490,2300} // FICHA DE COMPENSACAO
	Local aCoords6 := {2660,1900,2730,2300} // FICHA DE COMPENSACAO
	Local oBrush

	oFont8 	:= TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10	:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14	:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14n	:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont16	:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n	:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont20	:= TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont24 	:= TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

	oBrush := TBrush():New( , CLR_YELLOW )

	oPrint:StartPage()   // Inicia uma nova pagina

	oPrint:Line (150,100,150,2300)

	If aDadosBanco[1] == "389"
		oPrint:Say  (84,100,aDadosBanco[2],oFont10 )
	Else
		oPrint:Say  (84,100,aDadosBanco[2],oFont16 )
	Endif
/*
	oPrint:Say  (84,1850,"Comprovante de Entrega"                              ,oFont10)

	oPrint:Line (250,100,250,1300 )
	oPrint:Line (350,100,350,1300 )
	oPrint:Line (420,100,420,2300 )
	oPrint:Line (490,100,490,2300 )

	oPrint:Line (350,400,420,400)
	oPrint:Line (420,500,490,500)
	oPrint:Line (350,625,420,625)
	oPrint:Line (350,750,420,750)

	oPrint:Line (150,1300,490,1300 )
	oPrint:Line (150,2300,490,2300 )

	oPrint:Say  (180,1310 ,"MOTIVOS DE NÃO ENTREGA (para uso do entregador)"     ,oFont8)
	oPrint:Say  (230,1310 ,"|   | Mudou-se"                             			,oFont8)
	oPrint:Say  (300,1310 ,"|   | Recusado"                             			,oFont8)
	oPrint:Say  (370,1310 ,"|   | Desconhecido"                            		,oFont8)

	oPrint:Say  (230,1580 ,"|   | Ausente"                             			,oFont8)
	oPrint:Say  (300,1580 ,"|   | Não Procurado"                             		,oFont8)
	oPrint:Say  (370,1580 ,"|   | Endere? insuficiente"								,oFont8)

	oPrint:Say  (230,1930 ,"|   | Não existe o Número"                             ,oFont8)
	oPrint:Say  (300,1930 ,"|   | Falecido"                             ,oFont8)
	oPrint:Say  (370,1930 ,"|   | Outros(anotar no verso)"                             ,oFont8)

	oPrint:Say  (450,1310 ,"Recebi(emos) o bloqueto"                             ,oFont8)
	oPrint:Say  (480,1310 ,"com os dados ao lado."                             ,oFont8)
	oPrint:Line (430,1700,490,1700)
	oPrint:Say  (430,1705 ,"Data"                             ,oFont8)
	oPrint:Line (430,1900,490,1900)
	oPrint:Say  (430,1905 ,"Assinatura"                             ,oFont8)

	oPrint:Say  (160,100 ,"Cedente"                             ,oFont8)
	oPrint:Say  (190,100 ,aDadosEmp[1]							   ,oFont10)

	oPrint:Say  (260,100 ,"Sacado"                              ,oFont8)
	oPrint:Say  (290,100 ,aDatSacado[1]+" ("+aDatSacado[2]+")"  ,oFont10)

	oPrint:Say  (360,100 ,"Data do Vencimento"                              ,oFont8)

	If aDadosBanco[1] == "237"  //SE BRADESCO
		oPrint:Say  (390,100 ,Substring(DTOS(aDadosTit[4]),7,2)+"/"+Substring(DTOS(aDadosTit[4]),5,2)+"/"+Substring(DTOS(aDadosTit[4]),1,4)  ,oFont10)
	Else
		oPrint:Say  (390,100 ,DTOC(aDadosTit[4])                               ,oFont10)
	Endif

	oPrint:Say  (360,405 ,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (390,450 ,aDadosTit[1]                                     ,oFont10)

	oPrint:Say  (360,630,"Moeda"                                  			 ,oFont8)
	oPrint:Say  (390,655,"R$"     				                            ,oFont10)

	oPrint:Say  (360,755,"Valor/Quantidade"                               ,oFont8)
	oPrint:Say  (390,765,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

	oPrint:Say  (430,100 ,"Agencia/Cod. Cetente"                           ,oFont8)
	oPrint:Say  (460,100,aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)

	oPrint:Say  (430,505,"Nosso N?ero"                                   ,oFont8)
	oPrint:Say  (460,520,aDadosTit[6]                                     ,oFont10)

	For i := 100 to 2300 step 50
		oPrint:Line( 520, i, 520, i+30)
	Next i

	For i := 100 to 2300 step 50
		oPrint:Line( 1080, i, 1080, i+30)
	Next i
*/
	If aDadosBanco[1] # "341"
		oPrint:FillRect(aCoords3,oBrush)
		oPrint:FillRect(aCoords4,oBrush)
	Endif

	oPrint:Line (1270,100,1270,2300)
	oPrint:Line (1270,650,1170,650 )
	oPrint:Line (1270,900,1170,900 )

	If aDadosBanco[1] == "389"
		oPrint:Say  (1204,100,aDadosBanco[2],oFont10 )
	Else
		oPrint:Say  (1204,100,aDadosBanco[2],oFont16 )
	Endif

	oPrint:Say  (1182,680,aDadosBanco[1]+"-"+Modulo11(aDadosBanco[1],aDadosBanco[1]),oFont20 )

	oPrint:Line (1370,100,1370,2300 )
	oPrint:Line (1470,100,1470,2300 )
	oPrint:Line (1540,100,1540,2300 )
	oPrint:Line (1610,100,1610,2300 )

	oPrint:Line (1470,500,1610,500)
	oPrint:Line (1540,750,1610,750)
	oPrint:Line (1470,1000,1610,1000)
	oPrint:Line (1470,1350,1540,1350)
	oPrint:Line (1470,1550,1610,1550)

	oPrint:Say  (1280,100 ,"Local de Pagamento"                             															,oFont8)

	If aDadosBanco[1] == "237"
		oPrint:Say  (1310,100 ,"Pagável preferencialmente em qualquer Agência Bradesco" 												,oFont10)
	ElseIf aDadosBanco[1] == "341"
		oPrint:Say  (1310,100 ,"Até o vencimento, preferencialmente no Itau ou Banerje e Após o vencimento, somente no Itau"	,oFont10)
	Else
		oPrint:Say  (1310,100 ,"Pagável em qualquer agência bancária até o vencimento" 												,oFont10)
	Endif

	oPrint:Say  (1280,1910,"Vencimento"                                   															,oFont8)

	If aDadosBanco[1] == "237"  //SE BRADESCO
		oPrint:Say  (1350,2005,PadL(AllTrim(Substring(DTOS(aDadosTit[4]),7,2)+"/"+Substring(DTOS(aDadosTit[4]),5,2)+"/"+Substring(DTOS(aDadosTit[4]),1,4)),16," ")	,oFont10)
	Else
		oPrint:Say  (1350,2005,PadL(AllTrim(DTOC(aDadosTit[4])),16)                               																				,oFont10)
	Endif


	oPrint:Say  (1380,100 ,"Cedente"                                        ,oFont8)
	oPrint:Say  (1420,100 ,aDadosEmp[1]          ,oFont10)

	oPrint:Say  (1380,1910,"Agência/Código Cedente"                         ,oFont8)
	oPrint:Say  (1420,2005,PadL(AllTrim(aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")),16," "),oFont10)

	oPrint:Say  (1480,100 ,"Data do Documento"                              ,oFont8)

	If aDadosBanco[1] == "237"  //SE BRADESCO
		oPrint:Say  (1510,100 ,Substring(DTOS(aDadosTit[3]),7,2)+"/"+Substring(DTOS(aDadosTit[3]),5,2)+"/"+Substring(DTOS(aDadosTit[3]),1,4)  ,oFont10)
	Else
		oPrint:Say  (1510,100 ,DTOC(aDadosTit[3])                               ,oFont10)
	Endif

	oPrint:Say  (1480,505 ,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (1510,595 ,aDadosTit[1]                                     ,oFont10)

	oPrint:Say  (1480,1005,"Espécie Doc."                                   ,oFont8)
	oPrint:Say  (1510,1105,"DM"                                             ,oFont10)

	oPrint:Say  (1480,1355,"Aceite"                                         ,oFont8)
	oPrint:Say  (1510,1455,"N"                                             ,oFont10)

	oPrint:Say  (1480,1555,"Data do Processamento"                          ,oFont8)

	If aDadosBanco[1] == "237"   //SE BRADESCO
		oPrint:Say  (1510,1655,Substring(DTOS(aDadosTit[2]),7,2)+"/"+Substring(DTOS(aDadosTit[2]),5,2)+"/"+Substring(DTOS(aDadosTit[2]),1,4)  ,oFont10)
	Else
		oPrint:Say  (1510,1655,DTOC(aDadosTit[2])                              ,oFont10)
	Endif

	oPrint:Say  (1480,1910,"Nosso Número"                                   ,oFont8)
	oPrint:Say  (1510,2005,PadL(AllTrim(aDadosTit[6]),17," ")                  ,oFont10)

	oPrint:Say  (1550,100 ,"Uso do Banco"                                   ,oFont8)
	If aDadosBanco[1] == "409"
		oPrint:Say  (1580,100,"cvt 5539-5",oFont10)
	Endif

	oPrint:Say  (1550,505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (1580,555 ,aDadosBanco[6]					                    ,oFont10)

	oPrint:Say  (1550,755 ,"Espécie"                                        ,oFont8)
	oPrint:Say  (1580,805 ,"R$"                                             ,oFont10)

	oPrint:Say  (1550,1005,"Quantidade"                                     ,oFont8)
	oPrint:Say  (1550,1555,"Valor"                                          ,oFont8)

	oPrint:Say  (1550,1910,"(=)Valor do Documento"                          ,oFont8)
	oPrint:Say  (1580,2005,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)

	If aDadosBanco[1] == "341"
		oPrint:Say  (1620,100 ,"Instruções/Todos as informações deste bloqueto são de exclusiva responsabilidade do cedente",oFont8)
	Else
		oPrint:Say  (1620,100 ,"Instruções/Texto de responsabilidade do cedente",oFont8)
	Endif
	oPrint:Say  (1670,100 ,Iif(aDadosTit[7]>0,"Conceder desconto de R$ "+AllTrim(Transform(aDadosTit[7],"@E 999,999.99"))+" ate o vencimento","") ,oFont10)
	oPrint:Say  (1720,100 ,Iif(aDadosTit[8]>0,"Cobrar juros/mora dia de R$ "+AllTrim(Transform(aDadosTit[8],"@E 999,999.99")),"") ,oFont10)
	oPrint:Say  (1770,100 ,aBolText[1]                                      ,oFont10)
	oPrint:Say  (1820,100 ,aBolText[2]                                      ,oFont10)
	oPrint:Say  (1870,100 ,aBolText[3]                                      ,oFont10)

	oPrint:Say  (1620,1910,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (1690,1910,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (1760,1910,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (1810,1910,"(+)Outros Acr?cimos"                           ,oFont8)
	oPrint:Say  (1900,1910,"(=)Valor Cobrado"                               ,oFont8)

	oPrint:Say  (1970 ,100 ,"Sacado:"                                         ,oFont8)
	oPrint:Say  (1998 ,210 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont8)
	oPrint:Say  (2040 ,210 ,aDatSacado[3]                                    ,oFont8)
	oPrint:Say  (2080 ,210 ,aDatSacado[6]+"  "+aDatSacado[4]+" - "+aDatSacado[5]+"         CGC/CPF: "+Iif(Len(AllTrim(aDatSacado[7]))==14,Transform(aDatSacado[7],"@R 99.999.999/9999-99"),Transform(aDatSacado[7],"@R 999.999.999-99")) ,oFont8)

	//	oPrint:Say  (1925,100 ,"Sacador/Avalista"+Iif(_lBcoCorrespondente,aDadosEmp[1],"")                               ,oFont8)
	oPrint:Say  (1935,100 ,"Sacador/Avalista"                               ,oFont8)
	oPrint:Say  (2120,1500,"Autenticação Mecánica "                        ,oFont8)
	oPrint:Say  (1214,1850,"Recibo do Sacado"                              ,oFont10)

	oPrint:Line (1270,1900,1960,1900 )
	oPrint:Line (1680,1900,1680,2300 )
	oPrint:Line (1750,1900,1750,2300 )
	oPrint:Line (1820,1900,1820,2300 )
	oPrint:Line (1890,1900,1890,2300 )
	oPrint:Line (1960,100 ,1960,2300 )

	oPrint:Line (2105,100,2105,2300  )

	For i := 100 to 2300 step 50
		oPrint:Line( 2270, i, 2270, i+30)
	Next i

	If aDadosBanco[1] <> "341"
		oPrint:FillRect(aCoords5,oBrush)
		oPrint:FillRect(aCoords6,oBrush)
	Endif

	oPrint:Line (2390,100,2390,2300)
	oPrint:Line (2390,650,2290,650 )
	oPrint:Line (2390,900,2290,900 )


	If aDadosBanco[1] == "389"
		oPrint:Say  (2334,100,aDadosBanco[2],oFont10 )
	Else
		oPrint:Say  (2334,100,aDadosBanco[2],oFont16 )
	Endif

	oPrint:Say  (2312,680,aDadosBanco[1]+"-"+Modulo11(aDadosBanco[1],aDadosBanco[1]),oFont20 )
	oPrint:Say  (2334,920,CB_RN_NN[2],oFont14n) //linha digitavel

	oPrint:Line (2490,100,2490,2300 )
	oPrint:Line (2590,100,2590,2300 )
	oPrint:Line (2660,100,2660,2300 )
	oPrint:Line (2730,100,2730,2300 )

	oPrint:Line (2590,500,2730,500)
	oPrint:Line (2660,750,2730,750)
	oPrint:Line (2590,1000,2730,1000)
	oPrint:Line (2590,1350,2660,1350)
	oPrint:Line (2590,1550,2730,1550)

	oPrint:Say  (2390,100 ,"Local de Pagamento"                             ,oFont8)

	If aDadosBanco[1] == "237"  //SE BRADESCO
		oPrint:Say  (2440,100 ,"Pagável preferencialmente em qualquer Agência Bradesco"       ,oFont10)
	ElseIf aDadosBanco[1] == "341"
		oPrint:Say  (2440,100 ,"Até o vencimento, preferencialmente no Itau e Após o vencimento, somente no Itau" ,oFont10)
	Else
		oPrint:Say  (2440,100 ,"Pagável em qualquer agência bancária até o vencimento"       ,oFont10)
	Endif

	oPrint:Say  (2400,1910,"Vencimento"                                     ,oFont8)

	If aDadosBanco[1] == "237"   //SE BRADESCO
		oPrint:Say  (2440,2005,PadL(AllTrim(Substring(DTOS(aDadosTit[4]),7,2)+"/"+Substring(DTOS(aDadosTit[4]),5,2)+"/"+Substring(DTOS(aDadosTit[4]),1,4)),16," ")  ,oFont10)
	Else
		oPrint:Say  (2440,2005,PadL(AllTrim(DTOC(aDadosTit[4])),16," ")                               ,oFont10)
	Endif


	oPrint:Say  (2500,100 ,"Cedente"                                        ,oFont8)
	oPrint:Say  (2540,100 ,aDadosEmp[1]                                     ,oFont10)

	oPrint:Say  (2500,1910,"Agência/Código Cedente"                         ,oFont8)
	oPrint:Say  (2520,2010,PadL(AllTrim(aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")),16," "),oFont10)

	oPrint:Say  (2600,100 ,"Data do Documento"                              ,oFont8)

	If aDadosBanco[1] == "237"   //SE BRADESCO
		oPrint:Say  (2610,100 ,Substring(DTOS(aDadosTit[3]),7,2)+"/"+Substring(DTOS(aDadosTit[3]),5,2)+"/"+Substring(DTOS(aDadosTit[3]),1,4)  ,oFont10)
	Else
		oPrint:Say  (2610,100 ,DTOC(aDadosTit[3])                               ,oFont10)
	Endif

	oPrint:Say  (2600,505 ,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (2630,605 ,aDadosTit[1]                                     ,oFont10)

	oPrint:Say  (2600,1005,"Espécie Doc."                                   ,oFont8)
	oPrint:Say  (2630,1105,"DM"                                             ,oFont10)

	oPrint:Say  (2600,1355,"Aceite"                                         ,oFont8)
	oPrint:Say  (2630,1455,"N"                                             ,oFont10)

	oPrint:Say  (2600,1555,"Data do Processamento"                          ,oFont8)

	If aDadosBanco[1] == "237"   //SE BRADESCO
		oPrint:Say  (2630,1655,Substring(DTOS(aDadosTit[2]),7,2)+"/"+Substring(DTOS(aDadosTit[2]),5,2)+"/"+Substring(DTOS(aDadosTit[2]),1,4)  ,oFont10)
	Else
		oPrint:Say  (2630,1655,DTOC(aDadosTit[2])                               ,oFont10)
	Endif

	oPrint:Say  (2600,1910,"Nosso N?ero"                                   ,oFont8)
	oPrint:Say  (2630,2010,PadL(AllTrim(aDadosTit[6]),17," ")                                     ,oFont10)

	oPrint:Say  (2670,100 ,"Uso do Banco"                                   ,oFont8)
	If aDadosBanco[1] == "409"
		oPrint:Say  (2700,100 ,"cvt 5539-5"  ,oFont10)
	Endif

	oPrint:Say  (2670,505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (2700,555 ,aDadosBanco[6]                    ,oFont10)

	oPrint:Say  (2670,755 ,"Espécie"                                        ,oFont8)
	oPrint:Say  (2700,805 ,"R$"                                             ,oFont10)

	oPrint:Say  (2670,1005,"Quantidade"                                     ,oFont8)
	oPrint:Say  (2670,1555,"Valor"                                          ,oFont8)

	oPrint:Say  (2670,1910,"(=)Valor do Documento"                          ,oFont8)
	oPrint:Say  (2700,2010,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)

	If aDadosBanco[1] == "341"
		oPrint:Say  (2740,100 ,"Instruções/Todos as informações deste bloqueto são de exclusiva responsabilidade do cedente",oFont8)
	Else
		oPrint:Say  (2740,100 ,"Instruções/Texto de responsabilidade do cedente",oFont8)
	Endif
	oPrint:Say  (2790,100 ,Iif(aDadosTit[7]>0,"Conceder desconto de R$ "+AllTrim(Transform(aDadosTit[7],"@E 999,999.99"))+" ate o vencimento","") ,oFont10)
	oPrint:Say  (2840,100 ,Iif(aDadosTit[8]>0,"Cobrar juros/mora dia de R$ "+AllTrim(Transform(aDadosTit[8],"@E 999,999.99")),"") ,oFont10)
	oPrint:Say  (2890,100 ,aBolText[1]                                      ,oFont10)
	oPrint:Say  (2940,100 ,aBolText[2]                                      ,oFont10)
	oPrint:Say  (2990,100 ,aBolText[3]                                      ,oFont10)

	oPrint:Say  (2740,1910,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (2810,1910,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (2880,1910,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (2950,1910,"(+)Outros Acr?cimos"                           ,oFont8)
	oPrint:Say  (3020,1910,"(=)Valor Cobrado"                               ,oFont8)

	oPrint:Say  (3090,100 ,"Sacado"                                         ,oFont8)
	oPrint:Say  (3118,210 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont8)
	oPrint:Say  (3158,210 ,aDatSacado[3]                                    ,oFont8)
	oPrint:Say  (3198,210 ,aDatSacado[6]+"  "+aDatSacado[4]+" - "+aDatSacado[5]+"         CGC/CPF: "+Iif(Len(AllTrim(aDatSacado[7]))==14,Transform(aDatSacado[7],"@R 99.999.999/9999-99"),Transform(aDatSacado[7],"@R 999.999.999-99")) ,oFont8)

	//	oPrint:Say  (3045,100 ,"Sacador/Avalista"+Iif(_lBcoCorrespondente,aDadosEmp[1],"")                               ,oFont8)
	oPrint:Say  (3055,100 ,"Sacador/Avalista"                               ,oFont8)
	oPrint:Say  (3240,1500,"Autenticação Mecánica -"                        ,oFont8)
	If aDadosBanco[1] == "341"
		oPrint:Say  (3240,1850,"Ficha de Compensação"                           ,oFont8)
	Else
		oPrint:Say  (3240,1850,"Ficha de Compensação"                           ,oFont10)
	Endif
	oPrint:Line (2390,1900,3080,1900 )
	oPrint:Line (2800,1900,2800,2300 )
	oPrint:Line (2870,1900,2870,2300 )
	oPrint:Line (2940,1900,2940,2300 )
	oPrint:Line (3010,1900,3010,2300 )
	oPrint:Line (3080,100 ,3080,2300 )

	oPrint:Line (3225,100,3225,2300  )
	//	MSBAR("INT25"  ,27.9,1.5,CB_RN_NN[1],oPrint,.F., , ,0.0253,1.6,,,,.F.)

//	oPrint:FwMsBar("INT25",27.9,1.5, CB_RN_NN[1],oPrint,.F.,/*Color*/,.T.,0.0253,1.6,.F.,NIL,NIL,.T.,/*nPFWidth*/,/*nPFHeigth*/,.F.)

	oPrint:EndPage() // Finaliza a p?ina

Return Nil

Static Function Modulo10(cData,cIni)
	Local nx
	Local cPesos := If(cIni<>Nil,cIni,"")+"1212121212121212121212121212121212121212121212121212121212121212"
	Local d	:= 0
	For nx := 1 to Len(cData)
	   p := (Val(Substr(cData,nx,1))*Val(Substr(cPesos,nx,1)))
		If p > 9
			p := p - 9
		End
		d += p
	Next

	D := 10 - (Mod(D,10))
	If D = 10
		D := 0
	End
Return(D)

Static Function Modulo11(cData)
	Local nx
	Local cPesos := "432987654329876543298765432987654329876543298765"
	Local d	:= 0
	For nx := 1 to Len(cData)
		d += (Val(Substr(cData,nx,1))*Val(Substr(cPesos,nx,1)))
	Next

	D := 11 - (Mod(D,11))
	If (D == 10 .Or. D == 11)
	    D := 1
	End
Return(AllTrim(Str(D)))


/*
//Retorna os strings para inpress? do Boleto
//CB = String para o c?.barras, RN = String com o n?ero digit?el
//Cobran? n? identificada, n?ero do boleto = T?ulo + Parcela

Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor,dvencimento,cConvenio,cSequencial,_lTemDesc,_cParcela,_cAgCompleta)

	Local cCodEmp := StrZero(Val(SubStr(cConvenio,1,6)),6)
	Local cNumSeq := strzero(val(cSequencial),5)
	Local bldocnufinal := strzero(val(cNroDoc),9)
	Local blvalorfinal := strzero(int(nValor*100),10)
	Local cNNumSDig := cCpoLivre := cCBSemDig := cCodBarra := cNNum := cFatVenc := ''
	Local cNossoNum
	Local _cDigito := ""
	Local _cSuperDig := ""

	_cParcela := NumParcela(_cParcela)

	//Fator Vencimento - POSICAO DE 06 A 09
	cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)


	//Campo Livre (Definir campo livre com cada banco)

	If Substr(cBanco,1,3) == "001"  // Banco do brasil
		If Len(AllTrim(cConvenio)) == 7
			//Nosso Numero sem digito
			cNNumSDig := AllTrim(cConvenio)+strzero(val(cSequencial),10)
			//Nosso Numero com digito
			cNNum := cNNumSDig

			//Nosso Numero para impressao
			cNossoNum := cNNumSDig

			//		cCpoLivre := "000000"+cNNumSDig+AllTrim(cConvenio)+strzero(val(cSequencial),10)+ cCarteira
			cCpoLivre := "000000"+cNNumSDig+cCarteira
		Else
			//Nosso Numero sem digito
			cNNumSDig := cCodEmp+cNumSeq
			//Nosso Numero com digito
			cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))

			//Nosso Numero para impressao
			cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

			cCpoLivre := cNNumSDig+cAgencia + StrZero(Val(cConta),8) + cCarteira
		Endif
	Elseif Substr(cBanco,1,3) == "389" // Banco mercantil
		//Nosso Numero sem digito
		cNNumSDig := "09"+cCarteira+ strzero(val(cSequencial),6)
		//Nosso Numero
		cNNum := "09"+cCarteira+ strzero(val(cSequencial),6) + modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))
		//Nosso Numero para impressao
		cNossoNum := "09"+cCarteira+ strzero(val(cSequencial),6) +"-"+ modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := cAgencia + cNNum + StrZero(Val(SubStr(cConvenio,1,9)),9)+Iif(_lTemDesc,"0","2")

	Elseif Substr(cBanco,1,3) == "237" // Banco bradesco
		//Nosso Numero sem digito
		cNNumSDig := cCarteira + bldocnufinal
		//Nosso Numero
		cNNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
		//Nosso Numero para impressao
		cNossoNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )

		cCpoLivre := cAgencia + cCarteira + cNNumSDig + StrZero(Val(cConta),7) + "0"

	Elseif Substr(cBanco,1,3) == "453"  // Banco rural
		//Nosso Numero sem digito
		cNNumSDig := strzero(val(cSequencial),7)
		//Nosso Numero
		cNNum := cNNumSDig + AllTrim( Str( modulo10( cNNumSDig ) ) )
		//Nosso Numero para impressao
		cNossoNum := cNNumSDig +"-"+ AllTrim( Str( modulo10( cNNumSDig ) ) )

		cCpoLivre := "0"+StrZero(Val(cAgencia),3) + StrZero(Val(cConta),10)+cNNum+"000"

	Elseif Substr(cBanco,1,3) == "341"  // Banco Itau

		if _lBcoCorrespondente
			//Nosso Numero sem digito
			cNNumSDig := cCarteira+strzero(val(cSequencial),8)
			//Nosso Numero
			cNNum := cCarteira+strzero(val(cSequencial),8) + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )
			//Nosso Numero para impressao
			cNossoNum := cCarteira+"/"+strzero(val(cSequencial),8) +'-' + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cNNumSDig ) ) )
		Else

			//Nosso Numero sem digito
			cNNumSDig := cCarteira+strzero(val(cNroDoc),6)+ _cParcela
			//Nosso Numero
			cNNum := cCarteira+strzero(val(cNroDoc),6) + _cParcela + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )
			//Nosso Numero para impressao
			cNossoNum := cCarteira+"/"+strzero(val(cNroDoc),6)+ _cParcela +'-' + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cNNumSDig ) ) )
			//		Endif
			cCpoLivre := cNNumSDig+AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) ) ) )+"000"

		Elseif Substr(cBanco,1,3) == "399"  // Banco HSBC
			//Nosso Numero sem digito
			cNNumSDig := StrZero(Val(SubStr(cConvenio,1,5)),5)+strzero(val(cSequencial),5)
			//Nosso Numero
			cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))
			//Nosso Numero para impressao
			cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

			cCpoLivre := cNNum+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7)+"001"

		Elseif Substr(cBanco,1,3) == "422"  // Banco Safra
			//Nosso Numero sem digito
			cNNumSDig := strzero(val(cSequencial),8)
			//Nosso Numero
			cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))
			//Nosso Numero para impressao
			cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

			cCpoLivre := "7"+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),10)+cNNum+"2"

		Elseif Substr(cBanco,1,3) == "479" // Banco Boston
			cNumSeq := strzero(val(cSequencial),8)
			cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),9)
			//Nosso Numero sem digito
			cNNumSDig := strzero(val(cSequencial),8)
			//Nosso Numero
			cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))
			//Nosso Numero para impressao
			cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

			cCpoLivre := cCodEmp+"000000"+cNNum+"8"
		Elseif Substr(cBanco,1,3) == "409" // Banco UNIBANCO
			cNumSeq := strzero(val(cSequencial),10)
			cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),9)
			//Nosso Numero sem digito
			cNNumSDig := strzero(val(cSequencial),10)
			//Nosso Numero
			_cDigito := modulo11(cNNumSDig,SubStr(cBanco,1,3))
			//Calculo do super digito
			_cSuperDig := modulo11("1"+cNNumSDig + _cDigito,SubStr(cBanco,1,3))
			cNNum := "1"+cNNumSDig + _cDigito + _cSuperDig
			//Nosso Numero para impressao
			cNossoNum := "1/" + cNNumSDig + "-" + _cDigito + "/" + _cSuperDig
			// O codigo fixo "04" e para a combranco som registro
			cCpoLivre := "04" + SubStr(DtoS(dvencimento),3,6) + StrZero(Val(StrTran(_cAgCompleta,"-","")),5) + cNNumSDig + _cDigito + _cSuperDig
		Elseif Substr(cBanco,1,3) == "356" // Banco REAL
			cNumSeq := strzero(val(cNumSeq),13)
			//Nosso Numero sem digito
			cNNumSDig := cNumSeq
			//Nosso Numero
			cNNum := cNumSeq
			//Nosso Numero para impressao
			cNossoNum := cNNum
			cCpoLivre := StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7) + AllTrim(Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7)+cNNumSDig ) ) ) + cNNumSDig
		Endif


		//Dados para Calcular o Dig Verificador Geral
		cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
		//Codigo de Barras Completo
		cCodBarra := cBanco + Modulo11(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre

		//Digito Verificador do Primeiro Campo
		cPrCpo := cBanco + SubStr(cCodBarra,20,5)
		cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))

		//Digito Verificador do Segundo Campo
		cSgCpo := SubStr(cCodBarra,25,10)
		cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))

		//Digito Verificador do Terceiro Campo
		cTrCpo := SubStr(cCodBarra,35,10)
		cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))

		//Digito Verificador Geral
		cDvGeral := SubStr(cCodBarra,5,1)

		//Linha Digitavel
		cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
		cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
		cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
		cLinDig += " " + cDvGeral              //dig verificador geral
		cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
		//cLinDig += "  " + cFatVenc +blvalorfinal  // fator de vencimento e valor nominal do titulo

		Return({cCodBarra,cLinDig,cNossoNum})
		*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cCarteira,cNroDoc,nValor,dvencimento,nSequencial,aDadosBanco)

	Local cNumSeq
	Local cNossoNum
	Local bldocnufinal	:= StrZero( Val( cNroDoc ) , 9 )
	Local blvalorfinal	:= StrZero( ( nValor * 100 ) , 10 , 0 )
	Local cNNumSDig		:= ''
	Local cCpoLivre		:= ''
	Local cCBSemDig		:= ''
	Local cCodBarra		:= ''
	Local cNNum			:= ''
	Local cFatVenc 		:= ''
	Local _cDigito		:= ''
	Local _cSuperDig		:= ''

	cFatVenc := StrZero( dVencimento - CtoD("07/10/1997") , 4 )				//	Fator Vencimento - POSICAO DE 06 A 09

	If Substr(cBanco,1,3) == "033"
		cNumSeq	:= StrZero(nSequencial,13)										//	Nosso Numero sem digito
		cNNumSDig	:= cNumSeq															//	Nosso Numero
		cNNum		:= cNumSeq
		cNossoNum	:= cNNum															//	Nosso Numero para impressao
		cCpoLivre	:= StrZero( Val( cAgencia ) , 4 ) + StrZero( Val( cConta ) , 7 ) + AllTrim( Str( Modulo10( cNNumSDig + StrZero( Val( cAgencia ) , 4 ) + StrZero( Val( cConta ) , 7 ) ) ) ) + cNNumSDig
	Else
	EndIf

	aDadosBanco[5] := AllTrim( Str( Modulo10( cNNumSDig + StrZero( Val( cAgencia ) , 4 ) + StrZero( Val( cConta ) , 7 ) ) ) )

	cCBSemDig	:= cBanco + cFatVenc + blvalorfinal + cCpoLivre								//	Dados para Calcular o Dig Verificador Geral

	cCodBarra	:= cBanco + Modulo11(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre		// Codigo de Barras Completo

	cPrCpo		:= cBanco + SubStr(cCodBarra,20,5)												//	Digito Verificador do Primeiro Campo
	cDvPrCpo	:= AllTrim( Str( Modulo10( cPrCpo , "2" ) ) )

	cSgCpo		:= SubStr( cCodBarra , 25 , 10 )												//	Digito Verificador do Segundo Campo
	cDvSgCpo	:= AllTrim( Str(Modulo10( cSgCpo ) ) )

	cTrCpo		:= SubStr( cCodBarra , 35 , 10 )												//	Digito Verificador do Terceiro Campo
	cDvTrCpo	:= AllTrim( Str( Modulo10( cTrCpo ) ) )

	cDvGeral := SubStr(cCodBarra,5,1)															// Digito Verificador Geral

	//Linha Digitavel

	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "				//	Primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "				//	Segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " " 			//	Terceiro campo

	cLinDig += " " + cDvGeral																	//	Dig verificador geral

	cLinDig += "  " + SubStr( cCodBarra , 6 , 4 ) + SubStr( cCodBarra , 10 , 10 )		//	Fator de vencimento e valor nominal do titulo

Return({cCodBarra,cLinDig,cNossoNum})


/*
Programa    :
Data        : 07/04/2016
Autor       : André Costa
Funcao      : Static Function - Control
Descricao   : Atribui Banco, Agencia e Conta
Sintaxe     : fBanco()
Chamanda    :
Uso         : Interno
*/


Static Function fBanco
	Local aArea		:= GetArea()
	Local aPergs		:= {}
	Local aRet			:= {}
	Local lCanSave	:= .F.
	Local lUserSave	:= .F.
	Local lRetorno

	cBanco		:= ''
	cAgencia	:= ''
	cConta		:= ''

	aAdd( aPergs , { 1 , "Banco	: "		,cBanco	,"@!",'CarregaSA6(@MV_PAR01,,,.T.)'						,"SA6"	,'.T.',40,.F.})
	aAdd( aPergs , { 1 , "Agencia : "	,cAgencia	,"@!",'CarregaSA6(@MV_PAR01,@MV_PAR02,,.T.)'				,		,'.T.',40,.F.})
	aAdd( aPergs , { 1 , "Conta : "		,cConta	,"@!",'CarregaSA6(@MV_PAR01,@MV_PAR02,@MV_PAR03,.T.)'	,		,'.T.',40,.F.})

	lRetorno := ParamBox( aPergs , "Bancos Boleto Fatura" , aRet,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPosX*/,/*nPosy*/,/*oDlgWizard*/,/*cLoad*/,lCanSave,lUserSave)

	If lRetorno

		cBanco		:= aRet[1]
		cAgencia	:= aRet[2]
		cConta		:= aRet[3]

	EndIf

	RestArea( aArea )

Return( lRetorno )




Static Function AjustaSX1()
	Local _sAlias		:= Alias()
	Local aCposSX1	:= {}
	Local aPergs		:= {}
	Local X,J 			:= 0
	Local lAltera		:= .F.
	Local cKey			:= ""
	Local cPerg		:= "GEFR100"
	Local nCondicao

	cPerg := Padr( cPerg , Len(SX1->X1_GRUPO) )

	Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Numero","","","mv_ch3","C",9,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",9,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Parcela","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Portador","","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	Aadd(aPergs,{"Ate Portador","","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	Aadd(aPergs,{"De Cliente","","","mv_ch9","C",6,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
	Aadd(aPergs,{"Ate Cliente","","","mv_cha","C",6,0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
	Aadd(aPergs,{"De Loja","","","mv_chb","C",2,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Loja","","","mv_chc","C",2,0,0,"G","","MV_PAR12","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Emissao","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Emissao","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Vencimento","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Vencimento","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Do Bordero","","","mv_chh","C",6,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Bordero","","","mv_chi","C",6,0,0,"G","","MV_PAR18","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Do Bordero","","","mv_chh","C",6,0,0,"G","","MV_PAR19","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Bordero","","","mv_chi","C",6,0,0,"G","","MV_PAR20","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})



	aCposSX1	:=	{		"X1_PERGUNT"	,"X1_PERSPA"	,"X1_PERENG"	,"X1_VARIAVL"	,"X1_TIPO"		,	;
							"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"		,"X1_VALID"	,	;
							"X1_VAR01"		,"X1_DEF01"	,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"	,	;
							"X1_VAR02"		,"X1_DEF02"	,"X1_DEFSPA2"	,"X1_DEFENG2"	,"X1_CNT02"	,	;
							"X1_VAR03"		,"X1_DEF03"	,"X1_DEFSPA3"	,"X1_DEFENG3"	,"X1_CNT03"	,	;
							"X1_VAR04"		,"X1_DEF04"	,"X1_DEFSPA4"	,"X1_DEFENG4"	,"X1_CNT04"	,	;
							"X1_VAR05"		,"X1_DEF05"	,"X1_DEFSPA5"	,"X1_DEFENG5"	,"X1_CNT05"	,	;
							"X1_F3"		, "X1_GRPSXG"	,"X1_PYME"		,"X1_HELP" 						;
							}

	dbSelectArea("SX1")
	dbSetOrder(1)

	For X := 1 To Len(aPergs)

		lAltera := .F.

		If MsSeek(cPerg+Right(aPergs[X][11], 2))
			If (ValType(aPergs[X][Len(aPergs[x])]) = "B" .And. Eval(aPergs[X][Len(aPergs[x])], aPergs[X] ))
				aPergs[X] := aSize(aPergs[X], Len(aPergs[X]) - 1)
				lAltera := .T.
			EndIf
		EndIf

		If ! lAltera .And. Found() .And. X1_TIPO # aPergs[X][5]
			lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
		Endif

		If ! Found() .Or. lAltera
			RecLock("SX1",If(lAltera, .F., .T.))
			SX1->X1_GRUPO := cPerg
			SX1->X1_ORDEM := Right(aPergs[X][11], 2)

			For J := 1 To Len(aCposSX1)

				If 	Len(aPergs[X]) >= J .And. aPergs[X][J] # Nil .And. FieldPos( AllTrim(aCposSX1[J]) ) > 0
					SX1->&(AllTrim(aCposSX1[J])) := aPergs[X][J]
				Endif
			Next J

			MsUnlock()

			cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

			If ValType(aPergs[X][Len(aPergs[X])]) = "A"
				aHelpSpa := aPergs[X][Len(aPergs[X])]
			Else
				aHelpSpa := {}
			Endif

			If ValType(aPergs[X][Len(aPergs[X])-1]) = "A"
				aHelpEng := aPergs[X][Len(aPergs[X])-1]
			Else
				aHelpEng := {}
			Endif

			If ValType(aPergs[X][Len(aPergs[X])-2]) = "A"
				aHelpPor := aPergs[X][Len(aPergs[X])-2]
			Else
				aHelpPor := {}
			Endif

			PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		Endif

	Next

Return
