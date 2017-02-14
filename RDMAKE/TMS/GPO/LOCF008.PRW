#INCLUDE "Totvs.CH"
#INCLUDE "RWMake.CH" 
#INCLUDE "TopConn.ch" 

#IfNDef	METODO_PASCOA_GAUSS		
	#Define METODO_PASCOA_MEEUS
#EndIf


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³008  ºAutor  ³Sergio Celestino    º Data ³  04/25/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera Pedido de Venda,Libera Pedido e Gera Nota C.T.R.C      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Locf008(nTipo)
      
Local aAreaDTQ :=DTQ->(GetArea())
Local cAlias   := ALIAS()

Private cViagem	:= DTQ->DTQ_VIAGEM   
Private cCC		:= DTQ->DTQ_CCC   
Private cProjet := DTQ->DTQ_SOT
Private nRegDTQ := 0
Private aDTC    := {} 
Private cValor	:= 0
Private cTpCTRC	:= DTQ->DTQ_TPCTRC

Private nTipoPed	:= nTipo // 1= Pedido de venda; 2=Pedido de serviço. 

If	cFilAnt != DTQ->DTQ_FILORI
	MsgStop("A T E N Ç Ã O: Para emitir CT-e para a Viagem:"+cViagem+" logar na Filial "+DTQ->DTQ_FILORI)
	Return .F.
EndIf

DTQ->(DBSETORDER(1))  // FILIAL + VIAGEM

if DTQ->(!DbSeek(xFilial("DTQ")+cViagem)) 
 MsgStop("A T E N Ç Ã O: Viagem não foi cadastrada !! "+cViagem)
 Return(.f.)
Else
  while !eof() .and. cViagem == DTQ->DTQ_VIAGEM
     If cProjet == DTQ->DTQ_SOT
        EXIT
     Endif 
     dbskip()  
  Enddo
endif

If !Empty(DTQ->DTQ_NUMCTR) .AND. DTQ->DTQ_NUMCTR <> '-'
	MsgAlert("Já foi gerada a Nota Fiscal CT-e de número " + AllTrim(DTQ->DTQ_NUMCTR) + ", série " + AllTrim(DTQ->DTQ_SERCTR) + ", pedido de venda número " + AllTrim(DTQ->DTQ_NUMPV) + ". Impossível gerar novo CT-e para esta viagem." )
	Return .F.
EndIf

IF !MSGYESNO(Iif(nTipoPed == 2,"Confirma a geração do pedido de serviço","Confirma a geração do CT-e")+" para a viagem "+cViagem+" ?" )
    DBSELECTAREA( cAlias )
    DTQ->(RestArea(aAreaDTQ))
    RETURN .F.
ENDIF


nRegDTQ := DTQ->(RECNO() )

DBSELECTAREA("DTP")
DBSETORDER(3)  // FILIAL + FILORI + VIAGEM 

DBSEEK(XFILIAL("DTP")+DTQ->DTQ_FILORI+DTQ->DTQ_VIAGEM , .T. )
   
DBSELECTAREA("DTC")
DBORDERNICKNAME("DTCIND09")  // FILIAL + VIAGEM + NUMNFC + SERNFC + CLIREM + LOJREM 
/*
DTC->(DBSEEK(XFILIAL("DTC")+ cViagem)) // JBS 31/01/2007

While DTC->(!EOF()) .AND. DTC_VIAGEM = cViagem
   AADD( aDTC , RECNO() )                 // JBS 31/01/2007
   DTC->(DbSkip())
Enddo  

If Len(aDTC) = 0
	MsgStop("Não Foi Possivél Encontrar as NF's do Cliente!","Atenção")
	Return .F.
EndIF                                     // JBS 31/01/2007

GRV_PV ( aDTC )
GRV_DT6( aDTC[1],nRegDTQ )
*/        

If DTC->(DBSEEK(XFILIAL("DTC")+ cViagem)) // JBS 31/01/2007
   AADD( aDTC , RECNO() )                 // JBS 31/01/2007
   GRV_PV( aDTC )     
   GRV_DT6( aDTC[1], nRegDTQ )
Else
	MsgStop("Não foi Possivél encontrar as NF's do Cliente!","Atenção")
	Return .F.
EndIF  

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³008       ºAutor  ³Sergio Celestino    º Data ³  04/25/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Pedido de Venda para C.T.R.C                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GRV_PV( aDTC )
Local i
Local cALIAS        := alias()
Local cProduto      := GetMv("MV_CTRCPRO",,"999912")
Local cProFreP      := GetMv("LC_CTRCFPE")   //FRETE PESO                                        
Local cProFreV      := GetMv("LC_CTRCFVA")   //FRETE VALOR                                       
Local cProSegC      := GetMv("LC_CTRCICM")   //SEGURO CTRC                                       
Local cProIcmct     := GetMv("LC_CTRCSEG")   //ICMS SOBRE CTRC 

Local cProdNfs		:= GetMv("LC_PROSERV") // Produto Serviço

Local cNaturez      := GetMv("MV_CTRCNAT",,"E010201")
Local aCamposSC5    := {}
Local aCamposSC6    := {}            
Local aItens        := {}                                  
Local cNumSC5       := CriaVar("C5_NUM")
Local nPeso         := 0
Local nQtdVol       := 0
Local cItem         := "00"  
Local aNotas        := {}
Local aPvlNfs 	    := {}
Local nPrcVen 	    := 0
Local lCredito		:= .T.
Local lEstoque		:= .T.
Local lAvCred		:= .F.
Local lAvEst		:= .F.
Local lLiber		:= .T.
Local lTransf    	:= .F.
Local lRetEnv		:= .F.
Local cTipo			:= ""  
Local cVendedor		:= ""
Local cCCG			:= ""
Local nComissao		:= 0 
Local aAreaZA0		:= ZA0->(GetArea())
Local aAreaSA3		:= SA3->(GetArea())

Local lRndSOB   := getMV("MV_RNDSOBR")
Local lRndICM   := getMV("MV_RNDICM")

Private cnumero       := "" 
Private lMsErroAuto := .F.
Private lMsHelpAuto := .F.     
Private cSerie      := GetMv("MV_SERIECT" ,, "U  ")

//PutMV("MV_RNDSOBR", .F.)
//PutMV("MV_RNDICM", .F.)

DTC->(DBGOTO( aDTC[1] ) )  // posiciona no DTC ( PRIMEIRO REGISTRO ) PARA PEGAR O TES E A CONDICAO DE PAGAMENTO

cCondPag := DTQ->DTQ_CONDPG
cTES     := DTQ->DTQ_TES     
cCCG	 := DTQ->DTQ_CCC

If nTipoPed <> 2
	cNumnota:=sx5numNota(cSerie)
EndIf

aAreaSC5 := SC5->(GetArea()) 

Dbselectarea("SC5")
DbSetorder(1)

cNumSC5 := GetSxeNum("SC5","C5_NUM")
cMay := "SC5"+Alltrim(xFilial("SC5"))+cNumSC5

While (MsSeek(xFilial("SC5")+cNumSC5)) //.OR. !MayIUseCode(cMay))
	cNumSC5 := Soma1(cNumSC5,Len(cNumSC5))
EndDo                                                             

RestArea(aAreaSC5)

For i := 1 To Len(aDTC)

	nQtdVol += DTC->DTC_QTDVOL
	nPeso   += DTC->DTC_PESO                 
	
Next

//nValTot := DTQ->DTQ_XFRETE  // DTQ->DTQ_TOTFRE  
nValTot := DTQ->DTQ_XFRETE+DTQ->DTQ_VRPEDA+DTQ->DTQ_VROUTR
nValPre := DTQ->DTQ_VALADV  /* / (1-(DTQ->DTQ_PERICM / 100)) //Embuti icms no advalorem */
nValInf := DTQ->DTQ_VLRINF 
//nVal
cTipoF := DTC->DTC_TIPFRE
cCTROri:= DTQ->DTQ_CTRORI
cTipoF := IIF(cTipoF=="1","C","F")
cCfop  := DTQ->DTQ_CFOP
//cTipo  := Iif(Empty(DTQ->DTQ_CTRORI),"N","I")	// Complemento de ICMS

//Alison 22/10/13
If Empty(DTQ->DTQ_TPCTRC)
	cTipo := "N"//Normal
ElseIf DTQ->DTQ_TPCTRC == "1"
	cTipo := "C"//Compl.Preco
ElseIf DTQ->DTQ_TPCTRC == "2"
    cTipo := "I"//Compl.ICMS
EndIf   
dbSelectArea("SC7")
dbSetOrder(1)


//=================
DbSelectArea("ZA0")
DbSetOrder(1)
DbSeek(xFilial("ZA0")+DTQ->DTQ_SOT)

DbSelectArea("SA3")
DbSetOrder(1)
DbSeek(xFilial("SA3")+ZA0->ZA0_VENDED)

cVendedor := SA3->A3_COD
nComissao := SA3->A3_COMIS

RestArea(aAreaSA3)
RestArea(aAreaZA0)
//=================

//cTesV  := U_pegates(DTQ->DTQ_ORIGEM,DTQ->DTQ_DESTIN,)

For f:= 1 To Len( aDTC )                                                          
	DTC->(DBGOTO( aDTC[f] ) )  // posiciona no DTC
                         //{"C5_FILIAL"	, xFilial("SC5")	, Nil },;
//                         {"C5_TPDESP"	, ""				, Nil },;
	If Empty( aCamposSC5 )
		aCamposSC5 :=  {{"C5_FILIAL"	, xFilial("SC5")	, Nil },;//Pedido Venda Base GEFCO N:100246
						{"C5_NUM"		, cNumSC5			, Nil },;
						{"C5_TIPO" 		, "N"				, Nil },;//Tipo de Pedido Normal
						{"C5_CLIENTE"	, DTC->DTC_CLIDEV	, Nil },;//Cod Cliente
						{"C5_LOJACLI"	, DTC->DTC_LOJDEV	, Nil },;//Loja Cliente 
						{"C5_CLIENT"	, DTC->DTC_CLIDES	, Nil },;//Cod Cliente Entrega
						{"C5_LOJAENT"	, DTC->DTC_LOJDES   , Nil },;//Loja Cliente Entrega
						{"C5_XTIPONF"	, Iif(nTipoPed <> 2,"CTE","NFS"), Nil },;//Tipo de Documento						
						{"C5_TIPOCLI"	, Posicione('SA1',1,xFilial('SA1') + DTC->DTC_CLIDEV + DTC->DTC_LOJDEV,'A1_TIPO'), Nil },;//Tipo de Cliente
						{"C5_CONDPAG"	, cCondPag			, Nil },;//Condição de Pagamento //
						{"C5_CCUSTO"	, Posicione('ZA7',3,DTQ->DTQ_VIAGEM,'ZA7_CCGEFC')	, Nil },;//Centro de Custo GEFCO 
		   				{"C5_REFGEFC"	, Iif(ZA7->ZA7_TIPDES == "O","",ZA7->ZA7_REFGEF)	, Nil },;//Referencia GEFCO       
						{"C5_CTAPSA"    , ZA7->ZA7_CONTA									, Nil },;//Conta Contabil Cliente												
						{"C5_CCUSPSA"	, ZA7->ZA7_CCCLIE									, Nil },;//Cetro de Custo Cliente
						{"C5_TPDESP"	, ZA7->ZA7_TIPDES									, Nil },;//Tipo de Despesa
						{"C5_OIPSA"   	, ZA7->ZA7_OI										, Nil },;//Ordem Interna
						{"C5_DESC1"		, 0					, Nil },;
						{"C5_DESC2"		, 0					, Nil },;
						{"C5_DESC3"		, 0					, Nil },;
						{"C5_DESC4"		, 0					, Nil },;
						{"C5_TPFRETE"	, cTipoF			, Nil },;
						{"C5_VOLUME1"	, nQtdVol			, Nil },;
						{"C5_PESOL"		, nPeso				, Nil },;
						{"C5_PBRUTO"	, nPeso				, Nil },;
						{"C5_VEND1"     , cVendedor			, Nil },;
						{"C5_VIAGEM"    , DTQ->DTQ_VIAGEM	, Nil },;
						{"C5_COMIS1"    , nComissao        	, Nil }} 
						//{"C5_NATUREZ"   , cNaturez     		, Nil },;//Natureza
					   							
	EndIf

	_aItens := {}
	aadd( _aItens, DTQ->DTQ_XFRETE )

	If nTipoPed == 2 //Ped Servico
		_aItens[1] += DTQ->(DTQ_VRPEDA + DTQ_VROUTR + DTQ_VALADV)

	Else
		If DTQ->DTQ_VRPEDA > 0 
			aadd( _aItens, DTQ->DTQ_VRPEDA )
		Endif
		If DTQ->DTQ_VROUTR > 0 
			aadd( _aItens, DTQ->DTQ_VROUTR )
		Endif
		If DTQ->DTQ_VALADV > 0 
			aadd( _aItens, DTQ->DTQ_VALADV )
		Endif
	EndIf

	if ! cTipo $ "N|C"
		_aItens := { DTQ->DTQ_VALICM }
	endif

	For i := 1 to len( _aItens )

		nValTot := Round( _aItens[ i ], 2 )

        aItens := {}
	    AADD(aItens,{"C6_ITEM"		, StrZero(I,2)   		, Nil}) // Itens 
	   	AADD(aItens,{"C6_FILIAL"	, xFilial("SC6") 		, Nil}) // Filial 
		AADD(aItens,{"C6_NUM"		, cNumSC5		 		, Nil}) // Numero do Pedido
		AADD(aItens,{"C6_PRODUTO"	, cProduto		 		, Nil}) // Material
		AADD(aItens,{"C6_DESCRI"	, Posicione('SB1',1,xFilial('SB1')+cProduto,'B1_DESC'), Nil}) // Descrição do Material
		AADD(aItens,{"C6_UM"		, Posicione('SB1',1,xFilial('SB1')+cProduto,'B1_UM'), Nil}) // Unidade de medida  
		AADD(aItens,{"C6_QTDVEN"	, 1				 		, Nil}) // Quantidade
		AADD(aItens,{"C6_PRCVEN"	, nValTot 				, Nil}) // Preco de Venda / Valor Frete
		AADD(aItens,{"C6_VALOR"	    , nValTot			    , Nil}) // Valor total do item
		AADD(aItens,{"C6_TES"		, cTes					, Nil})//TES   
		AADD(aItens,{"C6_LOCAL"		, Posicione('SB1',1,xFilial('SB1')+cProduto,'B1_LOCPAD'), Nil}) // Armazem padrao        
		AADD(aItens,{"C6_QTDLIB"	, 0						, Nil}) // Quantidade liberada
		AADD(aItens,{"C6_DESCONT"	, 0              		, Nil}) // Percentual de Desconto	   
		AADD(aItens,{"C6_ENTREG"	, dDataBase		 		, Nil}) // Data da entrega
		AADD(aItens,{"C6_COMIS1"	, 0              		, Nil}) // Comissao Vendedor
		AADD(aItens,{"C6_PRUNIT"	, nValTot 				, Nil}) // Preco Unitário / Valor Frete
		AADD(aItens,{"C6_CLI"		, DTC->DTC_CLIDEV		, Nil}) // Cliente
		AADD(aItens,{"C6_LOJA"		, DTC->DTC_LOJDEV		, Nil}) // Loja do Cliente

		Aadd(aCamposSC6,aItens)
		
		If DTQ->DTQ_TIPTRA == "3"
			aItens := {}
			AADD(aItens,{"C6_FILIAL"	, xFilial("SC6") 			, Nil}) // Filial 
			AADD(aItens,{"C6_NUM"		, cNumSC5		 	   		, Nil}) // Numero do Pedido
			AADD(aItens,{"C6_ITEM"		, StrZero(I+1,2)   	   		, Nil}) // Itens 
			AADD(aItens,{"C6_PRODUTO"	, ''		 	   			, Nil}) // Material
			AADD(aItens,{"C6_QTDVEN"	, 1				 			, Nil}) // Quantidade
			AADD(aItens,{"C6_PRCVEN"	, Round(DTQ->DTQ_AFRMM,2)	, Nil}) // Preco de Venda / Valor Frete
			AADD(aItens,{"C6_VALOR"	    , Round(DTQ->DTQ_AFRMM,2)	, Nil}) // Valor total do item
			AADD(aItens,{"C6_TES"		, DTQ->DTQ_TES2	 			, Nil}) // TES   
			AADD(aItens,{"C6_QTDEMP"	, Iif(cTipo="N",1,0)		, Nil}) // Quantidade liberada
			AADD(aItens,{"C6_LOCAL"		, "01"	         	   		, Nil}) // Armazem padrao
			AADD(aItens,{"C6_CLI"		, DTC->DTC_CLIDEV			, Nil}) // Cliente
			AADD(aItens,{"C6_ENTREG"	, dDataBase		 			, Nil}) // Data da entrega
			AADD(aItens,{"C6_DESCONT"	, 0              			, Nil}) // Percentual de Desconto
			AADD(aItens,{"C6_COMIS1"	, 0              			, Nil}) // Comissao Vendedor
			AADD(aItens,{"C6_LOJA"		, DTC->DTC_LOJDEV			, Nil})  // Loja do Cliente
			AADD(aItens,{"C6_QTDLIB"	, Iif(cTipo="N",1,0)		, Nil}) // Quantidade liberada
			AADD(aItens,{"C6_PRUNIT"	, Round(DTQ->DTQ_AFRMM,2)	, Nil}) // Preco Unitário / Valor Frete
			AADD(aItens,{"C6_MUNOBRA"	, DTC->DTC_DESTIN			, Nil}) // Municipio da Obra 
			AADD(aItens,{"C6_XCLVL"		, DTQ->DTQ_AS		   		, Nil})  // Classe valor

			Aadd(aCamposSC6,aItens)
		EndIf                                      

		If cTipo $ "I|C"					// Complemento de ICMS ou Preço
			nRecDTQ  := DTQ->(Recno())
			cNfOri   := Posicione("DTQ",1,xFilial("DTQ") + cCTROri,"DTQ_NUMCTR")
			cSeriOri := Posicione("DTQ",1,xFilial("DTQ") + cCTROri,"DTQ_SERCTR")
			DTQ->(dbGoTo(nRecDTQ))
			Aadd(aCamposSC6[i],{"C6_VALOR"		, nValTot	, Nil})	 // Valor Total
			Aadd(aCamposSC6[i],{"C6_NFORI"		, cNfOri	, Nil})	 // Valor Total
			Aadd(aCamposSC6[i],{"C6_SERIORI"	, cSeriOri	, Nil})	 // Valor Total 
		EndIf

	Next

Next

Begin Transaction

IF Len(aCamposSC5) > 0 .And. Len(aCamposSC6) > 0
	
	cOldReadVar := ReadVar()
	SetFunName("MATA410")

	MSExecAuto({|x,y,z| Mata410(x,y,z)},aCamposSC5,aCamposSC6,3)
	
	RecLock("SC5",.F.)
		SC5->C5_CLIENTE	:=	DTC->DTC_CLIDEV
		SC5->C5_LOJACLI	:=  DTC->DTC_LOJDEV
		SC5->C5_CLIENT	:=	DTC->DTC_CLIDES
		SC5->C5_LOJAENT	:=  DTC->DTC_LOJDES
	SC5->(MsUnLock())
	
	SC6->(DBGoTop())
	SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
	While !Eof() .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM    
		RecLock("SC6",.F.)
			SC6->C6_QTDEMP	:=	0
		SC6->(MsUnLock())
		DbSkip()
	EndDo
	
	SetFunName( cOldReadVar )
	
	If lMsErroAuto
		MostraErro()
			   	
		RollBackSX8()
	Else
	   ConfirmSX8()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa a liberacao do pedido sem avaliacao de credito e estoque. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SC6")
		DbSetOrder(1)
		DbSeek(xFilial("SC6")+cNumSC5)
		While !Eof() .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+cNumSC5    
			MaLibDoFat(SC6->(Recno()),SC6->C6_QTDVEN,@lCredito,@lEstoque,lAvCred,lAvEst,lLiber,lTransf)
			DbSelectArea("SC6")
			DbSkip()
		EndDo
    
 	If nTipoPed <> 2 // Se não for pedido de seviço.
			 LjMsgRun("Aguarde...Gerando Nota Fiscal CT-e...",,{|| IncNota(cNumSC5,cSerie,"",@aNotas)})
		
			IF Len(aNotas) > 0

			   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			   //³Gera os arquivos com as notas fiscais            ³
			   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			   cSerie 	:= aNotas[1][1]
			   cNota 	:= aNotas[1][2]

			   //----------------------- Ajustes solicitados pelo Anderson - Cristiam Rossi em 09/09/2015

			   aAreaSE1 := SE1->( getArea() )
			   SE1->( dbSetOrder(1) )	// E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

			   aAreaSC5 := SC5->( getArea() )
			   SC5->( dbSetOrder(1) )	// F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
			   SC5->( dbSeek( xFilial("SC5") + cNumSC5, .T.) )

			   aAreaSF2 := SF2->( getArea() )
			   SF2->( dbSetOrder(1) )	// F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
			   if SF2->( dbSeek( xFilial("SF2") + cNota + cSerie, .T.) )
			       RecLock("SF2", .F.)
			       SF2->F2_VOLUME1 := SC5->C5_VOLUME1
			       SF2->F2_PLIQUI  := SC5->C5_PESOL
			       SF2->F2_PBRUTO  := SC5->C5_PBRUTO
			       MsUnlock()
			   endif
			   
			   SE1->( dbSeek( xFilial("SE1") + SF2->(F2_PREFIXO + F2_DUPL), .T. ) )
			   while ! SE1->( EOF() ) .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM)==xFilial("SE1")+SF2->(F2_PREFIXO + F2_DUPL)
			       if SE1->E1_TIPO == "NF "
			          RecLock("SE1", .F.)
			          SE1->E1_FILDEB := cFilAnt
			          MsUnlock()
			       endif
			       SE1->( dbSkip() )
			   end
			
			   SF2->( restArea( aAreaSF2 ) )
			   SC5->( restArea( aAreaSC5 ) )
			   SE1->( restArea( aAreaSE1 ) ) 
			   //-----------------------

		       aAreaDTC:=DTC->(GetArea())
		       Dbselectarea("DTC")
			   
			   //Incluido Condicao para que seja gravado em todos os itens da NF da tabela DTC.
		       DbOrderNickname('DTCIND09')
		       DbSeek(xFilial("DTC")+cViagem)
			   //DbGoto(aDTC[1])
			        
			   While DTC->(!Eof()) .and. DTC->DTC_VIAGEM == cViagem
				Reclock("DTC",.F.)         
					DTC->DTC_FILDOC := cFilant
				    DTC->DTC_DOC    := cNota
				    DTC->DTC_SERIE  := cSerie
			  	MsUnlock()          
			    DTC->(DBSKIP())
			   Enddo     
			    
			   dbGoto(aDTC[1]) 
			   RestArea(aAreaDTC)
			   aAreaDTQ := DTQ->(GetArea())
			   
			   DbSelectArea("DTQ")
		       DbSetOrder(1)
			   DbGoto(nRegDTQ)
			   
			   Reclock("DTQ",.F.)         
			     DTQ->DTQ_NUMPV     := cNumSC5
			     DTQ->DTQ_NUMCTR    := cNota
			     DTQ->DTQ_SERCTR	:= cSerie
			   MsUnlock()

		       RestArea(aAreaDTQ)

		       AcertoICMS(cNota,cSerie,cTipo)	

		       MsgAlert("Foi gerada a Nota Fiscal CT-e de numero "+ cNota)

		    Endif                                                         
		Else                                                          
		   
			DbSelectArea("DTQ")
			Reclock("DTQ",.F.)         
			DTQ->DTQ_NUMPV  := cNumSC5 
			DTQ->DTQ_NUMCTR := "X"
			MsUnlock()
			MsgAlert("Foi gerado Pedido de Serviço numero "+ cNumSC5)
	  	EndIf
 
	EndIF
 
Endif

End Transaction 
	//Panda - 19/11/2012 - Ajuste para desbloqueio de numero sequencial da nota
	If (GetMv("MV_NUMITEN",.T.))
   		SX6->(MSUNLOCK())
	EndIf

	//PutMV("MV_RNDSOBR", lRndSOB)
	//PutMV("MV_RNDICM", lRndICM)

Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³008  ºAutor  ³Microsiga           º Data ³  04/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GRV_DT6( nRecDTC, nRecDTQ)
Local cDtqOri := ""
Local aDtqOri := {}	
Local nLinhas := 0	 
Local cObs    := ""
Local cCodMsg := ""

dbSelectArea("DTQ")
dbGoto(nRecDTQ)

dbSelectArea("DTC")
dbGoto(nRecDTC)

dbSelectArea("SF2")
dbSetOrder(1)
dbSeek(xFilial("SF2")+DTQ->DTQ_NUMCTR+DTQ->DTQ_SERCTR)

dbSelectArea("DT6")
dbSetOrder(1)     

nLinhas := MlCount(DTQ->DTQ_OBSCTR)

For nX := 1 To nLinhas
	cObs += MemoLine(DTQ->DTQ_OBSCTR,,nX)
Next nX                    

If Posicione("SA1",1,xFilial("SA1")+DTC->(DTC_CLIDES+DTC_LOJDES),"A1_EST" ) == 'EX' //SUBSTR(DTQ->DTQ_ORIGEM,LEN(TRIM(DTQ->DTQ_ORIGEM))-1,2) == "EX"
	cCodMsg := "010986" //Icms isento exportação
Else
	cCodMsg := GetCodMsg()
EndIf

// ------- Acumular Valor, Peso e Volumes da DTC p/ gravar na DT6 - Cristiam Rossi em 21/09/2015
	_aAcmDTC := {0,0,0}		// Valor, Peso e Volumes
	aAreaDTC := DTC->( getArea() )
	DTC->( dbSetOrder(10) )
	DTC->( dbSeek( xFilial("DTC") + DTQ->(DTQ_SOT + DTQ_OBRA + DTQ_VIAGEM) ) )
	while ! DTC->( EOF() ) .and. DTC->( DTC_FILIAL+DTC_SOT+DTC_OBRA+DTC_VIAGEM ) == xFilial()+DTQ->(DTQ_SOT+DTQ_OBRA+DTQ_VIAGEM)
		_aAcmDTC[1] += DTC->DTC_VALOR
		_aAcmDTC[2] += DTC->DTC_PESO
		_aAcmDTC[3] += DTC->DTC_QTDVOL
		DTC->( dbSkip() )
	end
	DTC->( restArea( aAreaDTC ) )
//--------------------------------------------------

	RecLock("DT6", !dbSeek(xFilial("DT6")+SF2->F2_DOC+SF2->F2_SERIE))
	DT6_FILDOC	:=	SF2->F2_FILIAL
	DT6_DOC		:=	SF2->F2_DOC
	DT6_SERIE	:=	SF2->F2_SERIE
	DT6_DATEMI	:=	SF2->F2_EMISSAO	
	DT6_VALFRE	:=	SF2->F2_VALMERC//_aAcmDTC[1]		// DTC->DTC_VALOR
	DT6_VALIMP	:=	SF2->F2_VALBRUT - SF2->F2_VALMERC//SF2->F2_VALICM
	DT6_VALTOT	:=	SF2->F2_VALBRUT
	DT6_VALFAT	:=	SF2->F2_VALBRUT
	DT6_VALMER	:=	DTQ->DTQ_BASADV
	DT6_SERTMS	:=	DTQ->DTQ_SERTMS
	DT6_TIPTRA	:=	DTQ->DTQ_TIPTRA
	//IF COMPL.ICMS OU COMPL.VALOR 8 || SENAO 2
	DT6_DOCTMS	:=	StrZero( Iif(cTpCTRC $ "1|2",8,2), Len(DT6->DT6_DOCTMS))	// Documento de Transporte Cadastrado
	DT6_CDRORI	:=	'' // Cod. Região de Origem
	DT6_CDRDES	:=	'' // Cod. Região de Destino
	DT6_CDRCAL	:=	'' // Cod. Região do Calculo
	DT6_TIPFRE	:=	DTC->DTC_TIPFRE
	DT6_PRZENT	:=	SF2->F2_EMISSAO
	DT6_FILORI	:=	DTQ->DTQ_FILORI//DTC->DTC_FILORI
	DT6_FILDES	:=	DTQ->DTQ_FILORI//DTC->DTC_FILORI
	DT6_BLQDOC	:=	'2'	//	Bloqueado 1=Sim 2=Não 3=Descarregando
	DT6_PRIPER	:=	'1' // Primeiro Percurso 1=Sim 2=Não
	DT6_CLIREM	:=	DTC->DTC_CLIREM
	DT6_LOJREM	:=	DTC->DTC_LOJREM
	DT6_CLIDES	:=	DTC->DTC_CLIDES
	DT6_LOJDES	:=	DTC->DTC_LOJDES
	DT6_CLIDEV	:=	DTC->DTC_CLIDEV
	DT6_LOJDEV	:=	DTC->DTC_LOJDEV
	DT6_CLICAL	:=	DTC->DTC_CLICAL
	DT6_LOJCAL	:=	DTC->DTC_LOJCAL
	DT6_CLICON	:=	DTC->DTC_CLICON
	DT6_LOJCON	:=	DTC->DTC_LOJCON
	DT6_CCUSTO  := 	DTQ->DTQ_CCC
	DT6_CCONT	:=	DTC->DTC_CCONT
	DT6_OI      :=  DTC->DTC_OI 
	DT6_CONTA   :=	DTC->DTC_CONTA
	DT6_TIPDES  :=	DTC->DTC_TIPDES
    DT6_REFGEF  :=	DTC->DTC_REFGEF
                          
	//Tomador do serviço
	If DTC->(DTC_CLICON+DTC_LOJCON) == DTC->(DTC_CLIREM+DTC_LOJREM)//remetente
		DT6_DEVFRE := "1"
	ElseIf DTC->(DTC_CLICON+DTC_LOJCON) == DTC->(DTC_CLIDES+DTC_LOJDES)//destinatario
		DT6_DEVFRE := "2"
	Else//Outros
		DT6_DEVFRE := "3"
	EndIf
	//DT6_DEVFRE	:=	Iif(DTC->DTC_CLIDEV+DTC->DTC_LOJDEV = DTC->DTC_CLIDES+DTC->DTC_LOJDES,'1','2')
	DT6_SERVIC	:=	'010'	//
	DT6_CODMSG	:=	cCodMsg
	DT6_STATUS	:=	'7'		//
	DT6_PESO	:=	_aAcmDTC[2]		//DTC->DTC_PESO
	DT6_VOLORI	:=	_aAcmDTC[3]		//DTC->DTC_QTDVOL
	DT6_QTDVOL	:=	_aAcmDTC[3]
	DT6_HOREMI	:=	RetHora(SF2->F2_HORA) 
	DT6_CLIDPC	:=  DTC->DTC_CLIDPC
	DT6_LOJDPC	:=  DTC->DTC_LOJDPC
	//DT6_HOREMI	:=	StrTransF(SF2->F2_HORA,":","")
	If !Empty(cTpCTRC)//Gravar doc e serie para o CTRC complementar do CTRC original
		cDtqOri := GetDTQOri(DTQ->DTQ_SOT,DTQ->DTQ_AS,DTQ->DTQ_CTRORI)
		aDtqOri := StrTokArr(cDtqOri,";")
		DT6_FILDCO := SF2->F2_FILIAL
		DT6_DOCDCO := aDtqOri[1]
		DT6_SERDCO := aDtqOri[2]
	EndIf
	DT6->(MsUnLock())

	DbSelectArea("DT8")

	RecLock("DT8", .T.)
	DT8_FILIAL	:=	xFilial("DT8")
	DT8_CODPAS	:=	'TF'
	DT8_VALTOT	:=	DTQ->DTQ_TOTFRE
	DT8_VALPAS	:=	DTQ->DTQ_TOTFRE	-	DTQ->DTQ_VALICM
	DT8_VALIMP	:=	DTQ->DTQ_VALICM
	DT8_FILDOC	:=	DT6->DT6_FILDOC
	DT8_DOC		:=	DT6->DT6_DOC
	DT8_SERIE	:=	DT6->DT6_SERIE
	DT8_FILORI	:=	DT6->DT6_FILORI
	DT8_CDRORI	:=	DT6->DT6_CDRORI
	DT8_CDRDES	:=	DT6->DT6_CDRDES
	DT8_CODPRO	:=	DTC->DTC_CODPRO
MsUnLock()

RecLock("DT8", .T.)
	DT8_FILIAL	:=	xFilial("DT8")
	DT8_CODPAS	:=	'FR'
	DT8_VALTOT	:=	DTQ->DTQ_VALADV
	DT8_VALPAS	:=	DTQ->DTQ_TOTFRE	-	DTQ->DTQ_VALICM
	DT8_VALIMP	:=	DTQ->DTQ_VALICM
	DT8_FILDOC	:=	DT6->DT6_FILDOC
	DT8_DOC		:=	DT6->DT6_DOC
	DT8_SERIE	:=	DT6->DT6_SERIE
	DT8_FILORI	:=	DT6->DT6_FILORI
	DT8_CDRORI	:=	DT6->DT6_CDRORI
	DT8_CDRDES	:=	DT6->DT6_CDRDES
	DT8_CODPRO	:=	DTC->DTC_CODPRO
MsUnLock()




Return .T.




Static Function RetHora(cHora)
Local cEst		:=	SM0->M0_ESTCOB
Local cNHVEst	:=	GetMv('LC_ESTFORA',,'BA')
Local cHoraNew	:=  cHora

//Valida se o estada deve ter redução de uma hora 
If cEst $ cNHVEst

	//Valida se o mes esta dentro do periodo do horario de verão 
	If Month(dDataBase) >= 10 .Or. Month(dDataBase) <= 2         

		//Valida se esta dentro do horario de verão desse ano (Mes > 1 e menor ou igual à 2)  ou do ano passado (Mes > 10 e menor ou igual à 12)	
		If (dDataBase >= HorVerao(dDataBase)[1]  .And. dDataBase <= HorVerao(dDataBase)[2]) .Or. (dDataBase >= HorVerao(dDataBase-365)[1]  .And. dDataBase <= HorVerao(dDataBase-365)[2])
		
		//Subtrai uma hora do horario atual
			cHoraNew := __TimeSub(cHora, '01:00')
		EndIf
		
	EndIf		
	
EndIf

Return(Replace(cHoraNew,':',''))

Static Function Pascoa(dDate)
Local nVarLen		:=	SetVarNameLen(100)
Local cAno			:=	Left(DToS(dDate),4)
Local cDia			:=	Space(2)
Local cMes			:=	Space(2)
Local dRet
Local A
Local B
Local C
Local D
Local E


#IFDEF METODO_PASCOA_GAUSS
	Local X					
	Local Y
	Local nFaixa		:=	aScan(aFaixasAnos, {|Ano|  cAno >= Ano[1] .And. cAno <= Ano[2]} )

	Static aFaixasAnos	:=	{	{'1600','1699',22	,2},;
								{'1700','1799',23	,3},;
								{'1800','1899',23	,4},;
								{'1900','1999',24	,5},;
								{'2000','2099',24	,5},;
								{'2100','2199',24	,6},;
								{'2200','2299',25	,7}}	
								
									
	
	If nFaixa == 0 
		Return 
	EndIf  
	
	
	//Algoritimo de Gauss para Calculo da Pascoa
	X := aFaixasAnos[nFaixa][3]
	Y := aFaixasAnos[nFaixa][4]
	
	
	A	:=	Mod(Val(cAno),19)
	B	:=	Mod(Val(cAno),04)
	C	:=	Mod(Val(cAno),07)
	D	:=	Mod((19*A)+X,30)
	E	:=	Mod(((2*B)+(4*C)+(6*D)+Y),7)
	
	//o domingo de pascoa sempre vai ser entre 22 de março a 25 de abril
	If	(D+E) < 10	
		cDia	:=	StrZero(D+E+22,2)
		cMes	:=	'03'
	Else
		cDia	:=	StrZero(D+E-9,2)
		//Exceções a Regra
		Do Case
			Case cDia == '26' 
				cDia	:=	'19'
			Case cDia == '25' .And. D == 28 .And. A > 10
				cDia	:=	'18'
		EndCase
		
		cMes	:=	'04'
	EndIf
		


#Else
	#IfDef METODO_PASCOA_MEEUS
		
		Local F
		Local G
		Local H
		Local I
		Local J
		Local K
		Local L
		
		
		A	:=	Mod(Val(cAno), 19)
		B	:=	Int(Val(cAno)/100)
		C	:=	Mod(Val(cAno),100)
		D	:=	Int(B/4)
		E	:=	Mod(B,4)
		F	:=	Int( (B + 8) / 25 )
		G	:=	Int( (B - F + 1) / 3)
		H	:=	Mod(19 * A + B - D - G + 15, 30)
		I	:=	Int(C/4)
		J	:=	MOD(C,4)
		K	:=	MOD( (32 + 2 * E + 2 * I - H - J), 7 )
		L	:=	Int( (A + 11 * H + 22 * K) / 451 )
		
		cMes	:=	cValToChar( Int( ( H +  K - 7 * L + 114 ) / 31 ) )
		cDia	:=	cValToChar( Mod( (H + K - 7 * L + 114), 31 ) + 1 )
		
		
	#Else	
		cAno	:=	Space(2)
	#EndIf
#EndIf


Set(4,"dd/mm/"+If(__SetCentury(),"yyyy","yy"))

dRet := CToD(cDia+'/'+cMes+'/'+cAno)

SetVarNameLen(nVarLen)		

Return( dRet )



Static Function Carnaval(dDate)
Local dPascoa	:=	Pascoa(dDate)

If ValType(dPascoa) == 'U'
	Return
EndIf

Return(dPascoa-47)


Static Function HorVerao(dDate)
Local nCount	:=	0
Local cAno		:=	Left(DtoS(dDate),4)
Local lBissexto	:=	Mod(Val(Soma1(cAno)),4) == 0 .And. (Mod(Val(Soma1(cAno)),400) == 0 .And. Mod(Val(Soma1(cAno)),100) <> 0)  // Calcula se o ano é bissexto
Local dIni		
Local dFim	

//Calcula o 3º domingo do mes de outubro sendo esse o dia inicial do horario de verão
For nX :=	SToD(cAno+'1001') To SToD(cAno+'1031')
	If Dow(nX) == 1
		nCount++
		If nCount == 3		// 3º Domingo
			dIni	:=	nX
			Exit
		EndIf		
	EndIf
Next nX

//Zera o Contador
nCount	:=	0
//Incrementa 1 ao ano para calculo de termino do horario de verão
cAno	:=	Soma1(cAno)

//Calcula o 3º domingo de fevereiro do proximo ano caso o mesmo seja o carnaval pegar o proximo domingo
For nX :=	SToD(cAno+'0201') To SToD(cAno+'02'+Iif(lBissexto,'29','28'))
	If Dow(nX) == 1
		nCount++
		If nCount == 3 .And. Empty(dFim) // 3º Domingo
			dFim	:=	nX
			If !dFim == Carnaval(dFim)	//Se não for carnaval finaliza
				Exit
			EndIf
		Else
			If !Empty(dFim)	//Somente quando é carnaval
				dFim	:=	nX	
				Exit
			EndIf
		EndIf		
	EndIf
Next nX

Return({dIni,dFim})

Static Function GetDTQOri(cSot,cAs,cCtrOri)
	Local aArea	 := GetArea()
	Local cQuery := ""  
	Local cRet   := ""             
	
	cQuery := "SELECT DTQ.DTQ_NUMCTR, DTQ.DTQ_SERCTR "
	cQuery += " FROM " + RetSqlName('DTQ') + " DTQ "
	cQuery += " WHERE DTQ.DTQ_FILIAL = '"+xFilial("DTQ")+"' "
	cQuery += " AND DTQ.D_E_L_E_T_ <> '*' "
	cQuery += " AND DTQ.DTQ_SOT = '"+cSot+"' "
	cQuery += " AND DTQ.DTQ_AS = '"+cAs+"' "
	cQuery += " AND DTQ.DTQ_VIAGEM = '"+cCtrOri+"' "
	
	cQuery := ChangeQuery(cQuery)

	If Select("TRB01") > 0
		TRB01->(DbCloseArea())
	EndIf  
	                                                                  
	TcQuery cQuery New Alias "TRB01"    
	
	DbSelectArea("TRB01") 
	cRet := TRB01->DTQ_NUMCTR+";"+TRB01->DTQ_SERCTR              
	
	RestArea(aArea)
Return(cRet)

Static Function AcertoICMS(cNota,cSerie,cOpc) 
	Local aArea	 	:= GetArea()
	Local aAreaSD2	:= SD2->(GetArea())
	Local aAreaSFT	:= SFT->(GetArea())	
	Local aAreaSF3	:= SF3->(GetArea())	
	Local aAreaSF2	:= SF2->(GetArea())	
	Local nValICM   := 0
	Local aRecSFT	:= {}
	Local aRecSD2	:= {}             
	Local aRecSF3	:= {}
	Local aRecSF2	:= {}
    
    DbSelectArea("DTQ")
    DbSetOrder(1)
    DbGoto(nRegDTQ)
    
    nAliqIcm := DTQ->DTQ_PERICM
    
    If !DTQ->DTQ_DESICM //Se não destaca icms, não faz o acerto.
    	Return
    EndIf
    
	If cOpc == "I"	
		DbSelectArea("SD2")
		DbSetOrder(3) //Doc+Serie
		DbSeek(xFilial("SD2")+cNota+cSerie)
		
		While !SD2->(Eof()) .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE) == xFilial("SD2")+cNota+cSerie 
			nValICM := (SD2->D2_TOTAL * SD2->D2_ALIQSOL)/100
			aAdd(aRecSD2,{SD2->(Recno()),nValICM,SD2->D2_TOTAL})		
			DbSelectArea("SFT")
		   	DbSetOrder(1)//Tipo mov+serie+nota+cliEfor+loja+item+produto
		   	If DbSeek(xFilial("SFT")+"S"+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM)
		   		aAdd(aRecSFT,{SFT->(Recno()),SD2->D2_ALIQSOL,SD2->D2_TOTAL,nValICM})
		   	EndIf
			
			SD2->(DbSkip())
		EndDo
	    
	    //==================================
	    //Atualiza as tabelas SD2  e SFT   
	 	For nX := 1 To Len(aRecSD2)
	 		DbSelectArea("SD2")
	 		DbGoTo(aRecSD2[nX,1])
	 		RecLock("SD2", .F.)
	   		SD2->D2_VALICM  := aRecSD2[nX,2]
	   		SD2->D2_BASEICM := aRecSD2[nX,3]
	   		MsUnlock()	
	 	Next nX
	 	
	 	For nX := 1 To Len(aRecSFT)
	 		DbSelectArea("SFT")
	 		DbGoTo(aRecSFT[nX,1])
	 		RecLock("SFT", .F.)
	   		SFT->FT_ALIQICM := aRecSFT[nX,2]
	   		SFT->FT_BASEICM := aRecSFT[nX,3]
	   		SFT->FT_VALICM	:= aRecSFT[nX,4]
	   		MsUnlock()	
	 	Next nX
   		//==================================
   	Else
   		DbSelectArea("SD2")
		DbSetOrder(3) //Doc+Serie
		DbSeek(xFilial("SD2")+cNota+cSerie)
		
		While !SD2->(Eof()) .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE) == xFilial("SD2")+cNota+cSerie 
			nValICM := (SD2->D2_TOTAL * nAliqIcm)/100
			aAdd(aRecSD2,{SD2->(Recno()),nValICM})		
			DbSelectArea("SFT")
		   	DbSetOrder(1)//Tipo mov+serie+nota+cliEfor+loja+item+produto
		   	If DbSeek(xFilial("SFT")+"S"+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM)
		   		aAdd(aRecSFT,{SFT->(Recno()),nValICM})
		   	EndIf
			
			SD2->(DbSkip())
		EndDo    
		
		DbSelectArea("SF2")
		DbSetOrder(1)
		DbSeek(xFilial("SF2")+cNota+cSerie)
		While !SF2->(Eof()) .And. SF2->(F2_FILIAL+F2_DOC+F2_SERIE) == xFilial("SF3")+cNota+cSerie
		    nValICM := (SF2->F2_BASEICM * nAliqIcm)/100 
		    aAdd(aRecSF2,{SF2->(Recno()),nValICM})
			SF2->(DbSkip())
		EndDo
		
		DbSelectArea("SF3")
		DbSetOrder(6)
		DbSeek(xFilial("SF3")+cNota+cSerie)
		While !SF3->(Eof()) .And. SF3->(F3_FILIAL+F3_NFISCAL+F3_SERIE) == xFilial("SF3")+cNota+cSerie
		    nValICM := (SF3->F3_BASEICM * nAliqIcm)/100 
		    aAdd(aRecSF3,{SF3->(Recno()),nValICM})
			SF3->(DbSkip())
		EndDo
		
		//==================================
	    //Atualiza as tabelas SD2, SFT e SF3  
	 	For nX := 1 To Len(aRecSD2)
	 		DbSelectArea("SD2")
	 		DbGoTo(aRecSD2[nX,1])
	 		RecLock("SD2", .F.)
	   		SD2->D2_VALICM  := aRecSD2[nX,2]
	   		SD2->D2_PICM	:= nAliqIcm
	   		MsUnlock()	
	 	Next nX
	 	
	 	For nX := 1 To Len(aRecSFT)
	 		DbSelectArea("SFT")
	 		DbGoTo(aRecSFT[nX,1])
	 		RecLock("SFT", .F.)
	   		SFT->FT_VALICM	:= aRecSFT[nX,2]
	   		SFT->FT_ALIQICM := nAliqIcm
	   		MsUnlock()	
	 	Next nX      
	 	
	 	For nX := 1 To Len(aRecSF2)
	 		DbSelectArea("SF2")
	 		DbGoTo(aRecSF2[nX,1])
	 		RecLock("SF2", .F.)
	   		SF2->F2_VALICM	:= aRecSF2[nX,2]
	   		MsUnlock()	
	 	Next nX
	 	
	 	For nX := 1 To Len(aRecSF3)
	 		DbSelectArea("SF3")
	 		DbGoTo(aRecSF3[nX,1])
	 		RecLock("SF3", .F.)
	   		SF3->F3_VALICM	:= aRecSF3[nX,2]
	   		SF3->F3_ALIQICM := nAliqIcm
	   		MsUnlock()	
	 	Next nX      
	 	//===========================
   	EndIf
   	                  
   	RestArea(aAreaSF2)
	RestArea(aAreaSF3)
	RestArea(aAreaSFT)
	RestArea(aAreaSD2)
	RestArea(aArea)
Return

Static Function GetCodMsg()
	Local aArea	:= GetArea()	
	Local cRet	:= ""
	Local cQuery:= ""
	
	cQuery := "SELECT DUG_CODMSG AS CODMSG "
	cQuery += "FROM "+RetSqlName("DUG")+" "
	cQuery += "WHERE DUG_FILIAL = '"+xFilial("DUG")+"' "
	cQuery += "AND D_E_L_E_T_ <> '*' "
	cQuery += "AND DUG_TES = '"+DTQ->DTQ_TES+"' "
	cQuery += "AND DUG_ESTORI = '"+SUBSTR(DTQ->DTQ_ORIGEM,LEN(TRIM(DTQ->DTQ_ORIGEM))-1,2)+"' "     
	
	TcQuery cQuery New Alias "TRB"

	dbSelectArea("TRB")
	TRB->(dbGoTop())     
	
	Do While !TRB->(Eof())
	   
	   cRet := TRB->CODMSG
	   Exit
	EndDo
	
	TRB->(dbCloseArea())
	
	RestArea(aArea)
	
Return(cRet)