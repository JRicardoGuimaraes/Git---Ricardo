#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"
//�����������������������������������������������������������������������������Ŀ
//�Indica posi��o dos campos da tela de viagens.                                �
//�������������������������������������������������������������������������������
#Define nVSTATUS 01
#Define nVFILIAL 02
#Define nVVIAGEM 03
#Define nVROTA 04
#Define nVPLACA 05
#Define nVQTDEDOCS 06
#Define nVCOMOCO 07
#Define nVSEMOCO 08
#Define nVDATOCO 09
#Define nVHOROCO 10
#Define nVDATVIA 11
#Define nVHORVIA 12
#Define nVESPACO 13
#Define nVTIPVIA 14
#Define nVRECDTQ 15
#Define nVNOMMOT 16
#Define nVRECDA3 17
#Define nVRECDA4 18
#Define nVULTPOS 19
#Define nVULTEVE 20
#Define nVULTRMA 21
#Define nVCODOCO 22
#Define nVDESOCO 23
#Define nVNUMSM 24
#Define nVPLANID 25
#Define nVSERTMS 26
#Define nVNOMTRA 27
#Define nVCONMOT 28
#Define nVPLAREB 29
#Define nVTIPVEI 30
#Define nVCODAGE 31
#Define nVMARCA 32

//�����������������������������������������������������������������������������Ŀ
//�Indica c�digos de status da viagem.                                          �
//�������������������������������������������������������������������������������
#Define nLVIANINI 01
#Define nLVIATRAN 02
#Define nLVIAFORA 03
#Define nLVIAEMCD 04
#Define nLVIATMEX 05
#Define nLVIASTOP 06
#Define nLVIAFIMV 07
#Define nLVIAPENT 08
#Define nLVIAAENT 09
//�����������������������������������������������������������������������������Ŀ
//�Indica c�digos de status dos documentos.                                     �
//�������������������������������������������������������������������������������
#Define nLDOCSOCO 05
#Define nLDOCCOCO 01
#Define nLDOCFORA 03
//�����������������������������������������������������������������������������Ŀ
//�Indica c�digos de status dos alvos.                                          �
//�������������������������������������������������������������������������������
#Define nLALVOK   02
#Define nLALVFORA 03
//�����������������������������������������������������������������������������Ŀ
//�Indica cores disponiveis para legendas.                                      �
//�������������������������������������������������������������������������������
Static aLegendas := {{"BR_PRETO"	, LoadBitmap(GetResources(), "BR_PRETO")		, "Viagem n�o iniciada"},;
						{"BR_VERDE"	, LoadBitmap(GetResources(), "BR_VERDE")		, "Em tr�nsito"},;
						{"BR_AMARELO"	, LoadBitmap(GetResources(), "BR_AMARELO")	, "Atrasado"},;
						{"BR_AZUL"		, LoadBitmap(GetResources(), "BR_AZUL")		, "Em processo de carga/descarga"},;
						{"BR_VERMELHO", LoadBitmap(GetResources(), "BR_VERMELHO")	, "Tempo de espera/Perman�ncia excedido"},;
						{"BR_LARANJA"	, LoadBitmap(GetResources(), "BR_LARANJA")	, "Viagem interrompida"},;
						{"BR_VIOLETA"	, LoadBitmap(GetResources(), "BR_VIOLETA")	, "Fim de viagem"},;
						{"BR_BRANCO"	, LoadBitmap(GetResources(), "BR_BRANCO")		, "Em processo de entrega"},;
						{"BR_MARROM"	, LoadBitmap(GetResources(), "BR_MARROM")		, "Atraso na Entrega"}}
						
Static oLegOk    := LoadBitmap( GetResources(), "LBOK")
Static oLegNo    := LoadBitmap( GetResources(), "LBNO")
//�����������������������������������������������������������������������������Ŀ
//�Indica posi��o dos itens do vetor de legendas.                               �
//�������������������������������������������������������������������������������
#Define nLEGCOR 01
#Define nLEGOBJ 02
#Define nLEGDESC 03
//�����������������������������������������������������������������������������Ŀ
//�Indica posi��o dos campos da lista de documentos.                            �
//�������������������������������������������������������������������������������
#Define nDFILDOC 01
#Define nDNUMDOC 02
#Define nDSERDOC 03
#Define nDREMNOM 04
#Define nDREMMUN 05
#Define nDREMEST 06
#Define nDXDTPSC 07
#Define nDXHRPSC 08
#Define nDDESTINO 09
#Define nDDESNOM 10
#Define nDDESMUN 11
#Define nDDESEST 12
#Define nDDATPRC 13
#Define nDHORPRC 14
#Define nDDATPRE 15
#Define nDHORPRE 16
#Define nDXDTPEN 17
#Define nDXHRPEN 18
#Define nDESPACO 19

//�����������������������������������������������������������������������������Ŀ
//�Indica posi��o dos campos da lista de ocorr�ncias.                           �
//�������������������������������������������������������������������������������
#Define nOFILDOC  01
#Define nONUMDOC  02
#Define nOSERDOC  03
#Define nOCODOCO  04
#Define nODATOCO  05
#Define nOHOROCO  06
#Define nODESOCO  07
//�����������������������������������������������������������������������������Ŀ
//�Indica posi��o dos campos da tela de alvos.                                  �
//�������������������������������������������������������������������������������
#Define nAMARCA 01
#Define nADOCFIL 02
#Define nADOCNUM 03
#Define nADOCSER 04
#Define nARECDT6 05
#Define nACLINOM 06
#Define nACLIEND 07
#Define nACLIBAI 08
#Define nACLIMUN 09
#Define nACLIEST 10
#Define nAULTOCO 11
#Define nAULTEVE 12
#Define nAULTRMA 13
#Define nAHORINI 14
#Define nAHORFIM 15
#Define nALEGEND 16
//�����������������������������������������������������������������������������Ŀ
//�Indica posi��o dos campos do vetor aOcorr retornado pela fun��o fGetUltOco.  �
//�������������������������������������������������������������������������������
#Define nUCODOCO 01
#Define nUDESOCO 02
#Define nUDATOCO 03
#Define nUHOROCO 04
#Define nUDOCFIL 05
#Define nUDOCNUM 06
#Define nUDOCSER 07
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RGEFM02   �Autor  � Vin�cius Moreira   � Data � 21/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Painel de monitoramento Gefco.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GEFEXPSXS()
Local _cNomeArq := ""

// Private cPerg      := PadR("RGEFM02",Len(SX1->X1_GRUPO)," ")
Private cPerg      := PadR("RGEFM02A",Len(SX1->X1_GRUPO)," ")
Private nRefresh   := SuperGetMv("ES_GEFM02F",,10)
Private lSincAuto  := .F.
Private cOrdem     := ""
Private nOrdem     := 6
Private nTamCodOco := TamSx3("DT2_CODOCO")[1]
Private nRecDTQ    := 0

Private cFiliais   := ""
Private cPlaDe     := ""
Private cPlaAte    := "ZZZZZZZ"
Private nTipVia    := 1
Private dGerDe     := cToD("15\10\16")
Private dGerAte    := cToD("01\11\16")
Private cDevDe     := ""
Private cLojDe     := ""
Private cDevAte    := ""
Private cLojAte    := ""
Private _cListaCli := ""

Private cDirHist   := GetMv("ES_GEFM04A",,"\2LGI\TDC\Historicos\")

//���������������������������������������������������������������������������������������������Ŀ
//�Checa exist�ncia do diretorio de historicos.                                                 �
//�����������������������������������������������������������������������������������������������
fCriaDir(cDirHist)


// Por: Ricardo Guimar�es - Em: 19/03/2015
PutSx1(cPerg, "01", "Filiais? "			, "", "", "mv_ch1", "C", 99							,0,, "G", "U_RGEFM02A()"	,""		,"" ,"" ,"mv_par01" )
PutSx1(cPerg, "02", "Placa De ?"		, "", "", "mv_ch2", "C", TamSx3("DA3_PLACA")[1]	,0,, "G", ""				,"DA3"	,"" ,"" ,"mv_par02" )
PutSx1(cPerg, "03", "Placa Ate?"		, "", "", "mv_ch3", "C", TamSx3("DA3_PLACA")[1]	,0,, "G", ""				,"DA3"	,"" ,"" ,"mv_par03" )
PutSx1(cPerg, "04", "Tipo Viagem ?"		, "", "", "mv_ch4", "N", 1                      	,0,, "C", ""				,""		,"" ,"" ,"mv_par04" ,"Coleta"		,"" ,"" ,"" ,"Entrega"			,"" ,"" ,"Todas"		,"" ,"" ,""			,"" ,"" ,"" )
PutSx1(cPerg, "05", "Geracao De?"		, "", "", "mv_ch5", "D", TamSx3("DTQ_DATGER")[1]	,0,, "G", ""				,""		,"" ,"" ,"mv_par05" )
PutSx1(cPerg, "06", "Geracao Ate?"		, "", "", "mv_ch6", "D", TamSx3("DTQ_DATGER")[1]	,0,, "G", ""				,""		,"" ,"" ,"mv_par06" )
// PutSx1(cPerg, "07", "Cli. Devedores ?"		, "", "", "mv_ch7", "C", 99,0,, "G", "U_fExibeCli()"				,	,"" ,"" ,"mv_par07" )

	
// Exibe Painel de Monitoramento
While fExibeVigs()
EndDo

Return 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fExibeVigs�Autor  � Vin�cius Moreira   � Data � 21/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega a tela principal com as viagens filtradas.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fExibeVigs()

Local lRet      := .F.
Local oDlg
Local aButtons  := {}
Local aSize     := MsAdvSize(.T.)
Local aInfo     := {}
Local aPosObj   := {}
Local aObjects  := {}
Local cTitulo   := "Exporta tabala SX do formato DTC para Excel - " + dToC(Date()) + " - " + Time()

Local bLineDocs := {|| }
Local aHeadDocs := {}

Local bLineOcos := {|| }
Local aHeadOcos := {}

Local bLine     := {|| }
Local aHeadVia  := {}
Local nPosVia   := 0
Local cFilVia   := ""
Local cNumVia   := ""
Local nOpc      := 0
Local aSizes    := {}

Local oOrdem
Local oTabs
Local aOrdens   := {"", "Fil.Viagem+Viagem", "Placa+Fil.Viagem+Viagem", "Motorista+Fil.Viagem+Viagem", ;
					"Ult.Ocorr�ncia", "Status+Viagem", "Num.Plano", "Numero SM", "Prv.Ini.Viagem"}
Local oRefresh
Local oBtnIni
Local oBtnPar

Local oTimer

Local _aTabSXS	:= {}

Local cOrdPes   := ""
Local aPesqui   := {"Viagem", "Num.Plano", "Placa", "Motorista"}
Local oPesqui
Local cPesqui   := Space(100)
Local _nPlanId  := 0

Local _aHeader 	:= {}

Private oListVia
Private aViagens   := {}

Private aDocs      := {}
Private oListDocs

Private aOcos      := {}
Private oListOcos

Private oTFolder
Private bOldF2     := SetKey(VK_F2)
Private bOldF4     := SetKey(VK_F4)
Private bOldF4     := SetKey(VK_F5)
Private bVisVei    := {|| fVisVei (aViagens[oListVia:nAt,nVRECDA3])	}
Private bVisMot    := {|| fVisMot (aViagens[oListVia:nAt,nVRECDA4])	}
Private bVisOco    := {|| fVisOco (aViagens[oListVia:nAt,nVFILIAL], aViagens[oListVia:nAt,nVVIAGEM])	}

Private cOcoOutros := Replicate("X", Len(DUA->DUA_CODOCO))
Private cOcoSel    := ""

Private _aDados	:= {}

fTeclas(1)
						
//MsgRun("Aguarde... Selecionando registros... ",,{|| aViagens  := fGetVia () })

MsgRun("Aguarde... Carregando lista de tabelas... ",,{|| _aTabSXS	:= fGetTabSXS() })

MsgRun("Aguarde... Carregando lista com cabe�alho... ",,{|| _aHeader	:= fGetHeader() })

MsgRun("Aguarde... Carregando dados... ",,{|| _aDados	:= fGetDados() })

//If Len(aViagens) == 0
	//Aviso("Inconsist�ncia","N�o h� dados para exibir.",{"Ok"},,"Aten��o:")
//Else
	aAdd( aObjects, { 0, 013, .T., .T., .F. } )
	aAdd( aObjects, { 0, 047, .T., .T., .F. } )
	aAdd( aObjects, { 0, 040, .T., .T., .F. } )
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 1, 1 }
	aPosObj := MsObjSize( aInfo, aObjects, .T. )
	
	aAdd(aButtons,{"S4WB013N", bVisVei						 , "F2 - Cadastro Ve�culo"		, "F2-Ve�culo"	})
	aAdd(aButtons,{"S4WB013N", bVisMot						 , "F4 - Cadastro Motorista"	, "F4-Motorista"})
	aAdd(aButtons,{"S4WB013N", bVisOco						 , "F5 - Historico Obs."	, "F5-Hist. Obs."})
	aAdd(aButtons,{"S4WB001N",{|| lRet := .T., oDlg:End() 	}, "Atualizar"					, "Atualizar"	})
	aAdd(aButtons,{"S4WB013N",{|| fExibeLeg(1)				}, "Legenda"					, "Legenda"		})	
	
	DEFINE MSDIALOG oDlg FROM aSize[7],00 TO aSize[6],aSize[5] TITLE cTitulo PIXEL
	
	DEFINE TIMER oTimer INTERVAL (nRefresh*60*1000) ACTION lRet := fSincAuto(@oDlg) OF oDlg
	//�����������������������������������������������������������������������������������Ŀ
	//�Caso o timer tenha sido acionado anteriormente, for�a o uso a ativa��o.            �
	//�������������������������������������������������������������������������������������		
	//If lSincAuto
		//oTimer:Activate()
	//EndIf
	
	//TSay():New(aPosObj[1][1]+2,aPosObj[1][2],{|| "Ordem" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,100,80)
	//oOrdem := TComboBox():Create(oDlg,{|u|If(PCount()>0,cOrdem:=u,cOrdem)},aPosObj[1][1],aPosObj[1][2]+25,aOrdens,100,20,,{|| nOrdem := oOrdem:nAt, fChgOrdem (@oListVia, aViagens, bLine, aHeadVia, aOrdens, nOrdem)},,,,.T.,,,,,,,,,'cOrdem')

	TSay():New(aPosObj[1][1]+2,aPosObj[1][2],{|| "Tabelas SXs" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,100,80)
	oTabs := TComboBox():Create(oDlg,,aPosObj[1][1],aPosObj[1][2]+35,_aTabSXS,100,20,,,,,,.T.,,,,,,,,,'cTabs')

		
	//TSay():New(aPosObj[1][1]+2,aPosObj[1][2]+200,{|| "Auto Refresh" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,100,80)
	//oRefresh := TGet():New(aPosObj[1][1], aPosObj[1][2]+235,{|u| If(PCount()>0,nRefresh:=u,nRefresh)}, oDlg, 10,10, "",{|| },,,,,,.T.,,,{|| !lSincAuto },,,,,,,'nRefresh')
	
	TSay():New(aPosObj[1][1]+15,aPosObj[1][2],{|| "Pesquisar" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,100,80)
	oOrdPes := TComboBox():Create(oDlg,{|u|if(PCount()>0,cOrdPes:=u,cOrdPes)},aPosObj[1][1]+15,aPosObj[1][2]+025,aPesqui,100,20,,{|| },,,,.T.,,,,,,,,,'cOrdPes')
	oPesqui := TGet():New(aPosObj[1][1]+15, aPosObj[1][2]+140,{|u| if(PCount()>0,cPesqui:=u,cPesqui)}, oDlg, aPosObj[1][4]-(aPosObj[1][2]+340+10),10, "",{|| If(fPesqui(@oListVia, aViagens, oOrdPes:nAt, cPesqui),Eval(oListVia:bChange),) },,,,,,.T.,,,,,,,,,,'cPesqui')
	
	oBtnIni := TButton():New(aPosObj[1][1], aPosObj[1][2]+158,"Atualiza Grid", oDlg, {|| lSincAuto := .T., oTimer:Activate(), oDlg:End(), lRet := .T.	},0040,0012,,,,.T.,,,,{|| !lSincAuto },,)
	//oBtnPar := TButton():New(aPosObj[1][1], aPosObj[1][2]+308,"Parar"  , oDlg, {|| lSincAuto := .F., oTimer:DeActivate()							},0040,0012,,,,.T.,,,,{||  lSincAuto },,)
	//�����������������������������������������������������������������������������������Ŀ
	//�Lista de viagens.                                                                  �
	//�������������������������������������������������������������������������������������	
	aHeadVia  := {	"",;
					"Status",;
					"Fil.Viagem",;
					"Viagem",;
					"Numero SM",;
					"Num.Plano",;
					"Cod.Age.",;
					"Tip.Via.",;
					"Transportadora",;
					"Prv.Ini.Viagem",;
					"Rota",;
					"Placa",;
					"Tip.Veiculo",;
					"Motorista",;
					"Contato Motorista",;
					"Pla.Reboque",;
					"Ult.Ocorr�ncia",;
					"Ult.Posicao",;
					"Ult.Evento",;
					"Ult.RMA",;
					""}
/*					
	oListVia := TWBrowse():New( aPosObj[2][1],aPosObj[2][2],aPosObj[2][4],aPosObj[2][3]-aPosObj[1][3],,_aHeader,, oDlg, ,,,,;
	{|nRow,nCol,nFlags|,oListVia:Refresh()},,,,,,,.F.,,.T.,,.F.,,, )
	oListVia:SetArray(aViagens)
	bLine := {|| {			If(aViagens[oListVia:nAt,nVMARCA],oLegOk,oLegNo),;		//Marca
							aLegendas[aViagens[oListVia:nAt,nVSTATUS], nLEGOBJ],;	//Legenda
							aViagens[oListVia:nAt,nVFILIAL],;			   			//Filial
							aViagens[oListVia:nAt,nVVIAGEM],;						//Viagem
							aViagens[oListVia:nAt,nVNUMSM],;						//Numero SM
							aViagens[oListVia:nAt,nVPLANID],;						//Num.Plano
							aViagens[oListVia:nAt,nVCODAGE],;						//Cod.Agendamento
							aViagens[oListVia:nAt,nVTIPVIA],;						//Tip.Via.
							aViagens[oListVia:nAt,nVNOMTRA],;			   			//Nome Transportadora
							If(Empty(aViagens[oListVia:nAt,nVDATVIA]), Space(18), dToC(aViagens[oListVia:nAt,nVDATVIA]) + " - " + Transform(aViagens[oListVia:nAt,nVHORVIA],"@R 99:99")),;//Previs�o Inicio Viagem
							aViagens[oListVia:nAt,nVROTA],;							//Rota
							Transform(aViagens[oListVia:nAt,nVPLACA],"@R XXX-9999"),;//Placa
							aViagens[oListVia:nAt,nVTIPVEI],;						//Tipo de Ve�culo
							aViagens[oListVia:nAt,nVNOMMOT],;						//Motorista
							aViagens[oListVia:nAt,nVCONMOT],;						//Contato Motorista
							aViagens[oListVia:nAt,nVPLAREB],;						//Placa Reboque
							If(Empty(aViagens[oListVia:nAt,nVDATOCO]), Space(18), dToC(aViagens[oListVia:nAt,nVDATOCO]) + " - " + Transform(aViagens[oListVia:nAt,nVHOROCO],"@R 99:99") + " - " + aViagens[oListVia:nAt,nVDESOCO]),;//Ult.Ocorr�ncia
							aViagens[oListVia:nAt,nVULTPOS],;						//Ult.Posicao
							aViagens[oListVia:nAt,nVULTEVE],;						//Ult.Evento
							aViagens[oListVia:nAt,nVULTRMA],;						//Ult.RMA
							aViagens[oListVia:nAt,nVESPACO]}}						//Espa�o
	oListVia:bLine := bLine
*/

	oListVia := TWBrowse():New( aPosObj[2][1],aPosObj[2][2],aPosObj[2][4],aPosObj[2][3]-aPosObj[1][3],,_aHeader,, oDlg, ,,,,;
	{|nRow,nCol,nFlags|,oListVia:Refresh()},,,,,,,.F.,,.T.,,.F.,,, )
	oListVia:SetArray(_aDados)
	/*
	bLine := {|| {			If(aViagens[oListVia:nAt,nVMARCA],oLegOk,oLegNo),;		//Marca
							aLegendas[aViagens[oListVia:nAt,nVSTATUS], nLEGOBJ],;	//Legenda
							aViagens[oListVia:nAt,nVFILIAL],;			   			//Filial
							aViagens[oListVia:nAt,nVVIAGEM],;						//Viagem
							aViagens[oListVia:nAt,nVNUMSM],;						//Numero SM
							aViagens[oListVia:nAt,nVPLANID],;						//Num.Plano
							aViagens[oListVia:nAt,nVCODAGE],;						//Cod.Agendamento
							aViagens[oListVia:nAt,nVTIPVIA],;						//Tip.Via.
							aViagens[oListVia:nAt,nVNOMTRA],;			   			//Nome Transportadora
							If(Empty(aViagens[oListVia:nAt,nVDATVIA]), Space(18), dToC(aViagens[oListVia:nAt,nVDATVIA]) + " - " + Transform(aViagens[oListVia:nAt,nVHORVIA],"@R 99:99")),;//Previs�o Inicio Viagem
							aViagens[oListVia:nAt,nVROTA],;							//Rota
							Transform(aViagens[oListVia:nAt,nVPLACA],"@R XXX-9999"),;//Placa
							aViagens[oListVia:nAt,nVTIPVEI],;						//Tipo de Ve�culo
							aViagens[oListVia:nAt,nVNOMMOT],;						//Motorista
							aViagens[oListVia:nAt,nVCONMOT],;						//Contato Motorista
							aViagens[oListVia:nAt,nVPLAREB],;						//Placa Reboque
							If(Empty(aViagens[oListVia:nAt,nVDATOCO]), Space(18), dToC(aViagens[oListVia:nAt,nVDATOCO]) + " - " + Transform(aViagens[oListVia:nAt,nVHOROCO],"@R 99:99") + " - " + aViagens[oListVia:nAt,nVDESOCO]),;//Ult.Ocorr�ncia
							aViagens[oListVia:nAt,nVULTPOS],;						//Ult.Posicao
							aViagens[oListVia:nAt,nVULTEVE],;						//Ult.Evento
							aViagens[oListVia:nAt,nVULTRMA],;						//Ult.RMA
							aViagens[oListVia:nAt,nVESPACO]}}						//Espa�o
	*/
	oListVia:bLine := bLine


	//�����������������������������������������������������������������������������������Ŀ
	//�For�a posicionamento na viagem que estava selecionada.                             �
	//�������������������������������������������������������������������������������������			
	If nRecDTQ > 0 .And. (nPosVia := aScan(aViagens, {|x,y| x[nVRECDTQ] == nRecDTQ })) > 0
		oListVia:nAt := nPosVia
	EndIf
	
	//�����������������������������������������������������������������������������������Ŀ
	//�Caso a ordem tenha sido alterada anteriormente, for�a o uso da mesma ordem.        �
	//�������������������������������������������������������������������������������������		
	If nOrdem > 1
		fChgOrdem (@oListVia, aViagens, bLine, aHeadVia, aOrdens, nOrdem)
	EndIf
	//�����������������������������������������������������������������������������������Ŀ
	//�Fun��o acionada ao clicar na viagem.                                               �
	//�������������������������������������������������������������������������������������	
	
	// oListVia:bChange := {|| MsgRun("Aguarde... Selecionando registros... ",,{|| fChgVia(bLine, bLineDocs, bLineOcos, aViagens[oListVia:nAt,nVVIAGEM], aViagens[oListVia:nAt, nVSERTMS]),;
	oListVia:bChange := {||}
	//_nPlanId  := aViagens[oListVia:nAt,nVPLANID] }) } // Ricardo
	
	// oTFolder := TFolder():New( aPosObj[3][1], aPosObj[3][2],{"Documentos", "Ocorr�ncias"},,oDlg,,,,.T.,,aPosObj[3][4], aPosObj[3][3]-aPosObj[2][3] ) 
	
	ACTIVATE MSDIALOG oDlg on Init ENCHOICEBAR(oDlg, {|| nOpc := 1, lRet := .T., nRecDTQ := _aDados[oListVia:nAt,2], oDlg:End() } , {|| nOpc := 0, lRet := .F., oDlg:End() },,aButtons)
	
	If nOpc == 1
		//DTQ->(dbGoTo(nRecDTQ))
		fTeclas(2)
		//While fExibeDocs()
		//EndDo
		While fIncEvento(nRecDTQ, _nPlanId)
		EndDo
		fTeclas(1)
	EndIf
	
//EndIf

fTeclas(2)

Return lRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fGetVia  �Autor  � Vin�cius Moreira   � Data � 07/06/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega as viagens que ser�o exibidas.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetVia ()

Local aArea     := GetArea()
Local cQuery    := ""
Local cAliasQry := GetNextAlias()    
Local aRet      := {}
Local aStruc    := {}
Local nStatus   := nLVIANINI
Local aForaPrz  := {}
Local nDifHor   := 0        
Local nX        := 0
Local nTmpExce  := 0
Local nPosOco   := 0
Local cCodOco   := ""
Local cDesOco   := ""
Local dDatOco   := cToD("//")
Local cHorOco   := ""
Local aSerTms   := {"Coleta", "Transferencia", "Entrega"}
Local nTamCodOco:= TamSx3("DT2_CODOCO")[1]
Local cIniVCOL  := SuperGetMv("ES_GEFM02H",,"GC01")
Local cChegCOL  := SuperGetMv("ES_GEFM02I",,"GC02") // CNH1
Local cIniDCOL  := SuperGetMv("ES_GEFM02J",,"GC03")
Local cFimDCOL  := SuperGetMv("ES_GEFM02K",,"GC04") // CNH4
Local cSaidCOL  := SuperGetMv("ES_GEFM02L",,"GC05") // CNH2
Local cParaCOL  := SuperGetMv("ES_GEFM02M",,"GC06") 
Local cContCOL  := SuperGetMv("ES_GEFM02N",,"GC07")
Local cFimVCOL  := SuperGetMv("ES_GEFM02O",,"GC08") // CNH3
Local cEntVCOL  := SuperGetMv("ES_GEFM02Z",,"GC11")
/*
Local aOcoVCOL  := {	cIniVCOL,;
						cChegCOL,;
						cIniDCOL,;
						cFimDCOL,;
						cSaidCOL,;
						cParaCOL,;
						cContCOL,;
						cFimVCOL,;
						cEntVCOL}
*/						
Local aOcoVCOL  := {	cIniVCOL,;
						cChegCOL,;
						cIniDCOL,;
						cFimDCOL,;
						cSaidCOL,;
						cParaCOL,;
						cContCOL,;
						cFimVCOL,;
						cEntVCOL}
												
Local cIniVENT  := SuperGetMv("ES_GEFM02P",,"GE01")
Local cChegENT  := SuperGetMv("ES_GEFM02Q",,"GE02") // CNH1
Local cIniDENT  := SuperGetMv("ES_GEFM02R",,"GE03")
Local cFimDENT  := SuperGetMv("ES_GEFM02S",,"GE04") // CNH4
Local cSaidENT  := SuperGetMv("ES_GEFM02T",,"GE05") // CNH2
Local cParaENT  := SuperGetMv("ES_GEFM02U",,"GE06")
Local cContENT  := SuperGetMv("ES_GEFM02V",,"GE07")
Local cFimVENT  := SuperGetMv("ES_GEFM02X",,"GE08") // CNH3
/*
Local aOcoVENT  := {	cIniVENT,;
						cChegENT,;
						cIniDENT,;
						cFimDENT,;
						cSaidENT,;
						cParaENT,;
						cContENT,;
						cFimVENT}
*/

Local aOcoVENT  := {	cIniVENT,;
						cChegENT,;
						cIniDENT,;
						cFimDENT,;
						cSaidENT,;
						cParaENT,;
						cContENT,;
						cFimVENT}
	
						
Local nPlanId   := 0
Local cCodAge   := ""
						
dbSelectArea("DUD")//Movimento de viagem
DUD->(dbSetOrder(5))//DUD_FILIAL+DUD_FILORI+DUD_VIAGEM+DUD_FILMAN+DUD_MANIFE

dbSelectArea("DF0")//Cabe�aho do Agendamento
DF0->(dbSetOrder(1))//DF0_FILIAL+DF0_NUMAGE

dbSelectArea("DF1")//Itens do Agendamento
DF1->(dbSetOrder(3))//DF1_FILIAL+DF1_FILDOC+DF1_DOC+DF1_SERIE

cQuery += "  SELECT " + CRLF
cQuery += "    DTQ.DTQ_FILORI FILORI " + CRLF
cQuery += "   ,DTQ.DTQ_VIAGEM VIAGEM " + CRLF
cQuery += "   ,DTQ.DTQ_SERTMS TIPVIA " + CRLF
cQuery += "   ,DTQ.R_E_C_N_O_ RECDTQ " + CRLF
cQuery += "   ,DA8.DA8_DESC   ROTA " + CRLF
cQuery += "   ,SA2.A2_NOME    NOMTRA " + CRLF
cQuery += "   ,DA3.DA3_PLACA  PLACA " + CRLF
cQuery += "   ,DA3.R_E_C_N_O_ RECDA3 " + CRLF
cQuery += "   ,DUT.DUT_DESCRI TIPVEI " + CRLF
cQuery += "   ,DA3SREB.DA3_PLACA PLAREB " + CRLF
cQuery += "   ,DA4.DA4_NOME   NOMMOT " + CRLF
cQuery += "   ,DA4.DA4_TEL    CONMOT " + CRLF
cQuery += "   ,DA4.R_E_C_N_O_ RECDA4 " + CRLF
cQuery += "   ,COUNT(DISTINCT DUD.DUD_DOC) QTDEDOCS " + CRLF
cQuery += "   ,COUNT(DISTINCT DUA.DUA_DOC) QTDEOCO " + CRLF
cQuery += "   ,DTR.DTR_DATINI DATINI " + CRLF
cQuery += "   ,DTR.DTR_HORINI HORINI " + CRLF
cQuery += "   ,DTQ.DTQ_XSMBNY NUMSM " + CRLF

cQuery += "  FROM " + RetSqlName("DTQ") + " DTQ " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Veiculos da Viagem                                                              �
//����������������������������������������������������������������������������������
cQuery += " INNER JOIN " + RetSqlName("DTR") + " DTR ON " + CRLF
cQuery += "       DTR.DTR_FILIAL = '" + xFilial("DTR") + "' " + CRLF
cQuery += "   AND DTR.DTR_FILORI = DTQ.DTQ_FILORI " + CRLF
cQuery += "   AND DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM " + CRLF
cQuery += "   AND DTR.DTR_ITEM   = '" + StrZero(1,TamSx3("DTR_ITEM")[1]) + "' " + CRLF
cQuery += "   AND DTR.D_E_L_E_T_ = ' ' " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Ve�culos - Reboque                                                              �
//����������������������������������������������������������������������������������
cQuery += " INNER JOIN " + RetSqlName("DA3") + " DA3 ON " + CRLF
cQuery += "       DA3.DA3_FILIAL = '" + xFilial("DA3") + "' " + CRLF
cQuery += "   AND DA3.DA3_COD    = DTR.DTR_CODVEI " + CRLF
cQuery += "   AND DA3.DA3_PLACA  BETWEEN '" + cPlaDe + "' AND '" + cPlaAte + "' " + CRLF
cQuery += "   AND DA3.D_E_L_E_T_ = ' ' " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Tipo do Ve�culo - Reboque                                                       �
//����������������������������������������������������������������������������������
cQuery += " INNER JOIN " + RetSqlName("DUT") + " DUT ON " + CRLF
cQuery += "       DUT.DUT_FILIAL = '" + xFilial("DUT") + "' " + CRLF
cQuery += "   AND DUT.DUT_TIPVEI = DA3.DA3_TIPVEI " + CRLF
cQuery += "   AND DUT.D_E_L_E_T_ = ' ' " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Transportadora - Reboque                                                        �
//����������������������������������������������������������������������������������
cQuery += " LEFT OUTER JOIN " + RetSqlName("SA2") + " SA2 ON " + CRLF
cQuery += "       SA2.A2_FILIAL  = '" + xFilial("SA2") + "' " + CRLF
cQuery += "   AND SA2.A2_COD     = DA3.DA3_CODFOR " + CRLF
cQuery += "   AND SA2.A2_LOJA    = DA3.DA3_LOJFOR " + CRLF
cQuery += "   AND SA2.D_E_L_E_T_ = ' ' " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Ve�culos - Semi-Reboque                                                         �
//����������������������������������������������������������������������������������
cQuery += " LEFT OUTER JOIN " + RetSqlName("DA3") + " DA3SREB ON " + CRLF
cQuery += "       DA3SREB.DA3_FILIAL = '" + xFilial("DA3") + "' " + CRLF
cQuery += "   AND DA3SREB.DA3_COD    = DTR.DTR_CODRB1 " + CRLF
cQuery += "   AND DA3SREB.D_E_L_E_T_ = ' ' " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Motoristas da Viagem                                                            �
//����������������������������������������������������������������������������������
cQuery += " INNER JOIN " + RetSqlName("DUP") + " DUP ON " + CRLF
cQuery += "       DUP.DUP_FILIAL = DTR.DTR_FILIAL " + CRLF
cQuery += "   AND DUP.DUP_FILORI = DTR.DTR_FILORI " + CRLF
cQuery += "   AND DUP.DUP_VIAGEM = DTR.DTR_VIAGEM " + CRLF
cQuery += "   AND DUP.DUP_ITEDTR = DTR.DTR_ITEM   " + CRLF
cQuery += "   AND DUP.D_E_L_E_T_ = ' ' " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Motoristas                                                                      �
//����������������������������������������������������������������������������������
cQuery += " INNER JOIN " + RetSqlName("DA4") + " DA4 ON " + CRLF
cQuery += "       DA4.DA4_FILIAL = '" + xFilial("DA4") + "' " + CRLF
cQuery += "   AND DA4.DA4_COD    = DUP.DUP_CODMOT " + CRLF
cQuery += "   AND DA4.D_E_L_E_T_ = ' ' " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Rotas                                                                           �
//����������������������������������������������������������������������������������
cQuery += " INNER JOIN " + RetSqlName("DA8") + " DA8 ON " + CRLF
cQuery += "       DA8.DA8_FILIAL = '" + xFilial("DA8") + "' " + CRLF
cQuery += "   AND DA8.DA8_COD    = DTQ.DTQ_ROTA " + CRLF
cQuery += "   AND DA8.D_E_L_E_T_ = ' ' " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Movimento de Viagem                                                             �
//����������������������������������������������������������������������������������
cQuery += " INNER JOIN " + RetSqlName("DUD") + " DUD ON " + CRLF
cQuery += "       DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF
cQuery += "   AND DUD.DUD_FILORI = DTQ.DTQ_FILORI " + CRLF
cQuery += "   AND DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM " + CRLF
cQuery += "   AND DUD.DUD_SERTMS = DTQ.DTQ_SERTMS " + CRLF
cQuery += "   AND DUD.DUD_TIPTRA = DTQ.DTQ_TIPTRA " + CRLF
cQuery += "   AND DUD.D_E_L_E_T_ = ' ' " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Documentos de transporte                                                        �
//����������������������������������������������������������������������������������
cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 ON " + CRLF
cQuery += "       DT6.DT6_FILIAL = '" + xFilial("DT6") + "' " + CRLF
cQuery += "   AND DT6.DT6_FILDOC = DUD.DUD_FILDOC " + CRLF
cQuery += "   AND DT6.DT6_DOC    = DUD.DUD_DOC " + CRLF
cQuery += "   AND DT6.DT6_SERIE  = DUD.DUD_SERIE " + CRLF

// Por: Ricardo - Em: 19/03/2015 
// cQuery += "   AND DT6.DT6_CLIDEV BETWEEN '" + cDevDe + "' AND '" + cDevAte + "'" + CRLF
// cQuery += "   AND DT6.DT6_LOJDEV BETWEEN '" + cLojDe + "' AND '" + cLojAte + "'" + CRLF

// Por: Ricardo - Em: 19/03/2015 
//cQuery += "   AND DT6.DT6_CLIDEV + DT6.DT6_LOJDEV IN (" + _cListaCli + ") " + CRLF

cQuery += "   AND DT6.D_E_L_E_T_ = ' ' " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Registro de Ocorr�ncias                                                         �
//����������������������������������������������������������������������������������
cQuery += " LEFT OUTER JOIN " + RetSqlName("DUA") + " DUA ON " + CRLF
cQuery += "       DUA.DUA_FILIAL = '" + xFilial("DUA") + "' " + CRLF
cQuery += "   AND DUA.DUA_FILDOC = DUD.DUD_FILDOC " + CRLF
cQuery += "   AND DUA.DUA_DOC    = DUD.DUD_DOC " + CRLF
cQuery += "   AND DUA.DUA_SERIE  = DUD.DUD_SERIE " + CRLF
cQuery += "   AND DUA.DUA_FILORI = DUD.DUD_FILORI " + CRLF
cQuery += "   AND DUA.DUA_VIAGEM = DUD.DUD_VIAGEM " + CRLF
cQuery += "   AND DUA.D_E_L_E_T_ = ' ' " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Viagem                                                                          �
//����������������������������������������������������������������������������������
cQuery += " WHERE DTQ.DTQ_FILIAL = '" + xFilial("DTW") + "' " + CRLF
cQuery += "   AND DTQ.DTQ_FILORI IN ('07','08','20','22') " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Status:                                                                         �
//�1=Em Aberto;2=Em Transito;3=Encerrada;4=Chegada em Filial;5=Fechada;9=Cancelada �
//����������������������������������������������������������������������������������
cQuery += "   AND DTQ.DTQ_STATUS NOT IN ('3','9')" + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Filtro servi�o da viagem.                                                       �
//����������������������������������������������������������������������������������
If nTipVia == 1
	cQuery += "   AND DTQ.DTQ_SERTMS = '1'" + CRLF
ElseIf nTipVia == 2
	cQuery += "   AND DTQ.DTQ_SERTMS = '3'" + CRLF
Else
	cQuery += "   AND DTQ.DTQ_SERTMS IN ('1','3')" + CRLF
EndIf
cQuery += "   AND DTQ.DTQ_DATGER BETWEEN '" + dToS(dGerDe) + "' AND '" + dToS(dGerAte) + "' " + CRLF
cQuery += "   AND DTQ.D_E_L_E_T_ = ' ' " + CRLF

cQuery += "  GROUP BY " + CRLF
cQuery += "    DTQ.DTQ_FILORI " + CRLF
cQuery += "   ,DTQ.DTQ_VIAGEM " + CRLF
cQuery += "   ,DTQ.DTQ_SERTMS " + CRLF
cQuery += "   ,DTQ.R_E_C_N_O_ " + CRLF
cQuery += "   ,DA8.DA8_DESC   " + CRLF
cQuery += "   ,DA3.DA3_PLACA  " + CRLF
cQuery += "   ,DA3.R_E_C_N_O_ " + CRLF
cQuery += "   ,DUT.DUT_DESCRI " + CRLF
cQuery += "   ,DA3SREB.DA3_PLACA " + CRLF
cQuery += "   ,SA2.A2_NOME    " + CRLF
cQuery += "   ,DA4.DA4_NOME   " + CRLF
cQuery += "   ,DA4.DA4_TEL    " + CRLF
cQuery += "   ,DA4.R_E_C_N_O_ " + CRLF
cQuery += "   ,DTR.DTR_DATINI " + CRLF
cQuery += "   ,DTR.DTR_HORINI " + CRLF
cQuery += "   ,DTQ.DTQ_XSMBNY " + CRLF
cQuery += "  ORDER BY " + CRLF

// Por: Ricardo - Em: 18/05/2015 - Altera��o da ordena��o
// cQuery += "    DTQ.DTQ_VIAGEM " + CRLF
//cQuery += "    DTQ.DTQ_FILORI, " + CRLF
cQuery += "    DTR.DTR_DATINI, " + CRLF
cQuery += "    DTR.DTR_HORINI  " + CRLF

MemoWrite("D:\TEMP\RGEFM02_VIA.TXT",cQuery)

cQuery := ChangeQuery(cQuery)

If fDoQuery(cQuery, @cAliasQry)
	TcSetField(cAliasQry,"DATINI",TamSx3("DTR_DATINI")[3],TamSx3("DTR_DATINI")[1],TamSx3("DTR_DATINI")[2])
	While (cAliasQry)->(!Eof())
	
		//�����������������������������������������������������������������������������������Ŀ
		//�Busca texto da ultima ocorr�ncia dos documentos na viagem.                         �
		//�������������������������������������������������������������������������������������		
		aOcorr := fGetUltOco((cAliasQry)->FILORI, (cAliasQry)->VIAGEM, , , , .T.)
		If Len(aOcorr) > 0
			cCodOco := aOcorr[01, nUCODOCO]
			cDesOco := aOcorr[01, nUDESOCO]
			dDatOco := aOcorr[01, nUDATOCO]
			cHorOco := aOcorr[01, nUHOROCO]
			//�����������������������������������������������������������������������������������Ŀ
			//�Tratativas para legenda das viagens de coletas.                                    �
			//�������������������������������������������������������������������������������������					
			If (cAliasQry)->TIPVIA == "1"
				For nX := 1 to Len(aOcorr)
					If aScan(aOcoVCOL, {|x,y| x == aOcorr[nX, nUCODOCO]}) > 0
						nPosOco := nX
						Exit
					EndIf
				Next nX
				                                   
				If nPosOco == 0
					nStatus := nLVIANINI
				ElseIf aOcorr[nPosOco, nUCODOCO] == cEntVCOL
					nStatus := nLVIAPENT
					If fForaEnt((cAliasQry)->VIAGEM, (cAliasQry)->TIPVIA,(cAliasQry)->FILORI)
						nStatus := nLVIAAENT
					EndIf
				ElseIf aOcorr[nPosOco, nUCODOCO] == cIniVCOL .Or. aOcorr[nPosOco, nUCODOCO] == cSaidCOL .Or. aOcorr[nPosOco, nUCODOCO] == cContCOL
					nStatus := nLVIATRAN
				ElseIf aOcorr[nPosOco, nUCODOCO] == cChegCOL
					nStatus := nLVIAEMCD
					nTmpExce := fGetExceDoc(1, aOcorr[nPosOco, nUDOCFIL], aOcorr[nPosOco, nUDOCNUM], aOcorr[nPosOco, nUDOCSER], (cAliasQry)->TIPVIA)
					If fForaPrz(aOcorr[nPosOco, nUHOROCO], nTmpExce)
						nStatus := nLVIATMEX
					EndIf
				ElseIf aOcorr[nPosOco, nUCODOCO] == cIniDCOL .Or. aOcorr[nPosOco, nUCODOCO] == cFimDCOL
					nStatus := nLVIAEMCD
				ElseIf aOcorr[nPosOco, nUCODOCO] == cParaCOL
					nStatus := nLVIASTOP
				ElseIf aOcorr[nPosOco, nUCODOCO] == cFimVCOL
					nStatus := nLVIAFIMV
				EndIf 
			//�����������������������������������������������������������������������������������Ŀ
			//�Tratativas para legenda das viagens de entrega\transferencia.                      �
			//�������������������������������������������������������������������������������������					
			Else
				For nX := 1 to Len(aOcorr)
					If aScan(aOcoVENT, {|x,y| x == aOcorr[nX, nUCODOCO]}) > 0
						nPosOco := nX
						Exit
					EndIf
				Next nX
				
				If nPosOco == 0
					nStatus := nLVIANINI
				ElseIf aOcorr[nPosOco, nUCODOCO] == cIniVENT .Or. aOcorr[nPosOco, nUCODOCO] == cSaidENT .Or. aOcorr[nPosOco, nUCODOCO] == cContENT
					nStatus := nLVIATRAN
				ElseIf aOcorr[nPosOco, nUCODOCO] == cChegENT
					nStatus := nLVIAEMCD
					nTmpExce := fGetExceDoc(1, aOcorr[nPosOco, nUDOCFIL], aOcorr[nPosOco, nUDOCNUM], aOcorr[nPosOco, nUDOCSER], (cAliasQry)->TIPVIA)
					If fForaPrz(aOcorr[nPosOco, nUHOROCO], nTmpExce)
						nStatus := nLVIATMEX
					EndIf
				ElseIf aOcorr[nPosOco, nUCODOCO] == cIniDENT .Or. aOcorr[nPosOco, nUCODOCO] == cFimDENT
					nStatus := nLVIAEMCD
				ElseIf aOcorr[nPosOco, nUCODOCO] == cParaENT
					nStatus := nLVIASTOP
				ElseIf aOcorr[nPosOco, nUCODOCO] == cFimVENT
					nStatus := nLVIAFIMV
				EndIf 
			EndIf
			
			//�����������������������������������������������������������������������������������Ŀ
			//�Checa se existem documentos sem chegada no cliente dentro do per�odo correto.      �
			//�������������������������������������������������������������������������������������
			If nStatus == nLVIATRAN
				aForaPrz := fChkJanelas(1, (cAliasQry)->TIPVIA, (cAliasQry)->FILORI, (cAliasQry)->VIAGEM)
				If aForaPrz[1]
					nStatus := nLVIAFORA
				EndIf
			EndIf
		EndIf
		//���������������������������������������������������������������������������Ŀ
		//�Se viagem de coleta, busco o primeiro documento no DUD.                    �
		//�����������������������������������������������������������������������������
		If (cAliasQry)->TIPVIA == "1" .And. DUD->(dbSeek(xFilial("DUD")+(cAliasQry)->(FILORI+VIAGEM)))
			//���������������������������������������������������������������������������Ŀ
			//�Posiciono nos itens com o n�mero do documento de coleta.                   �
			//�����������������������������������������������������������������������������
			If DF1->(dbSeek(xFilial("DF1")+DUD->(DUD_FILDOC+DUD_DOC+DUD_SERIE)))
				//���������������������������������������������������������������������������Ŀ
				//�Busca o informa��o no DF0.                                                 �
				//�����������������������������������������������������������������������������
				If DF0->(dbSeek(DF1->(DF1_FILIAL+DF1_NUMAGE))) 
					nPlanId := DF0->DF0_PLANID 
					// cCodAge := DF0->DF0_XCA // Por: Ricardo - Em: 26/03/2015
					cCodAge := IIF(Empty(AllTrim(DF0->DF0_XCA)),"",AllTrim(DF0->DF0_XCA) + " - " + DTOC(DF0->DF0_XDTAGE) + " - " + TransForm(AllTrim(DF0->DF0_XHRAGE), "@R 99:99"))
				EndIf
			EndIf
		EndIf 

		//���������������������������������������������������������������������������Ŀ
		//�Alterado - Vin�cius Moreira - 13/11/2014                                   �
		//�Adicionado campo n�mero de plano, conforme solicita��o do Luiz Alexandre.  �
		//�����������������������������������������������������������������������������	
		aAdd(aRet,{	nStatus,;															//01 - Status
					(cAliasQry)->FILORI,;												//02 - Filial da Viagem
					(cAliasQry)->VIAGEM,;												//03 - N�mero da Viagem
					(cAliasQry)->ROTA,;													//04 - Rota
					(cAliasQry)->PLACA,;												//05 - Placa
					(cAliasQry)->QTDEDOCS,;												//06 - Quantidade de documentos na viagem
					(cAliasQry)->QTDEOCO,;												//07 - Quantidade de documentos com ocorr�ncia
					(cAliasQry)->(QTDEDOCS - QTDEOCO),;								//08 - Quantidade de documentos com ocorr�ncia
					dDatOco,;															//09 - Data ocorr�ncia
					cHorOco,;															//10 - Hora ocorr�ncia
					(cAliasQry)->DATINI,;												//11 - Data Previsao de Inicio da Viagem
					(cAliasQry)->HORINI,;												//12 - Hora Previsao de Inicio da Viagem
					"",;																//13 - Espa�o
					aSerTms[Val((cAliasQry)->TIPVIA)],;								//14 - Tipo da viagem
					(cAliasQry)->RECDTQ,;												//15 - Recno DTQ
					(cAliasQry)->NOMMOT,;												//16 - Motorista
					(cAliasQry)->RECDA3,;												//17 - Recno DA3
					(cAliasQry)->RECDA4,;												//18 - Recno DA4
					fGetUltPos((cAliasQry)->FILORI, (cAliasQry)->VIAGEM),;				//19 - Ult.Posi��o
					fGetUltEve((cAliasQry)->FILORI, (cAliasQry)->VIAGEM),;				//20 - Ult.Evento
					fGetUltRMA((cAliasQry)->FILORI, (cAliasQry)->VIAGEM),;				//21 - Ult.RMA
					cCodOco,;															//22 - Codigo da Ultima Ocorr�ncia
					cDesOco,;															//23 - Descri��o da Ultima Ocorr�ncia
					(cAliasQry)->NUMSM,;												//24 - N�mero da Solicita��o de Monitoramento
					nPlanId,;															//25 - N�mero do plano de transporte
					(cAliasQry)->TIPVIA,;												//26 - Servi�o de Transporte
					(cAliasQry)->NOMTRA,;												//27 - Nome Transportadora
					(cAliasQry)->CONMOT,;												//28 - Contato Motorista
					(cAliasQry)->PLAREB,;												//29 - Placa Reboque
					(cAliasQry)->TIPVEI,;												//30 - Tipo de Ve�culo
					cCodAge,;															//31 - Codigo Agendamento
					.F.;																//32 - Marca
		})
		
		nStatus   := nLVIANINI
		nDifHor   := 0
		nPosOco   := 0
		cCodOco   := ""
		cDesOco   := ""
		dDatOco   := cToD("//")
		cHorOco   := ""
		nPlanId   := 0
		
		(cAliasQry)->(dbSkip())
	EndDo
EndIf

(cAliasQry)->(dbCloseArea())

RestArea(aArea)

Return aRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fDoQuery �Autor  � Vin�cius Moreira   � Data � 21/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Executa query.                                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fDoQuery (cQuery, cAliasQry)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .F.) 
Return (cAliasQry)->(!Eof())
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fExibeLeg �Autor  � Vin�cius Moreira   � Data � 21/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Exibe legendas.                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fExibeLeg(nOpcao)

Local aLegenda := {}
Local nX       := 1
//�����������������������������������������������������������������������������������Ŀ
//�Carrega legendas da tela de viagens.                                               �
//�������������������������������������������������������������������������������������		
If nOpcao == 1
	For nX := 1 to Len(aLegendas)
		aAdd(aLegenda, {aLegendas[nX, nLEGCOR], aLegendas[nX, nLEGDESC]})
	Next nX
//�����������������������������������������������������������������������������������Ŀ
//�Carrega legendas da tela de documentos.                                            �
//�������������������������������������������������������������������������������������		
Else
	aAdd(aLegenda, {"BR_VERDE"   , "Dentro do prazo"})
	aAdd(aLegenda, {"BR_AMARELO" , "Fora do Prazo"})
EndIf

BrwLegenda("Legenda", "Legenda", aLegenda)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fVisDoc  �Autor  � Vin�cius Moreira   � Data � 21/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Visualiza��o do documento.                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fVisDoc (nRecno)

Local aArea    := GetArea()
Local aAreaDT6 := DT6->(GetArea())

SaveInter()

Private aRotina := {	{"STR0002", "AxPesqui"  ,0,1,0,.F.},;	//"Pesquisar"
						{"STR0003", "TmsA500Mnt",0,2,0,NIL}}	//"Visualizar"
Private aSetKey   := {}
Private INCLUI	  := .F.
Private cCadastro := "Visualiza Documento"
Private cLoteAut  := ""
Private lTmsCFec  := .F.										//-- Desabilita nas funcoes do tmsa200 o tratamento de carga fechada
Private nDiaArm   := 0
Private lPenArm   := .F.
Private cLoteCte  := ""
Private aRatPesM3 := {}  // aCols Peso Cubado
Private aEndProd  := {}  // aCols de Enderecamento

dbSelectArea("DT6")												//Documentos de Transporte
DT6->(dbSetOrder(1))											//DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
DT6->(dbGoTo(nRecno))

If	DT6->DT6_DOCTMS == StrZero( 1, Len( DT6->DT6_DOCTMS ) )	//-- Coleta
	//-- Posiciona na solicitacao de coleta.
	DT5->( DbSetOrder( 4 ) )									//DT5_FILIAL+DT5_FILDOC+DT5_DOC+DT5_SERIE
	If	DT5->( MsSeek( xFilial('DT5') + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE, .F. ) )
		TmsA460Mnt( 'DT5', DT5->( Recno() ), 2 )
	EndIf
Else
	DT6->(TMSA500Mnt("DT6", nRecno, 2))
EndIf

RestInter()

RestArea(aAreaDT6)
RestArea(aArea)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RGEFM02A �Autor  � Vin�cius Moreira   � Data � 21/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Sele��o de filiais.                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xRGEFM02A (l1Elem,lTipoRet)

Local MvPar
Local cTitulo  := "Filiais"
Local MvParDef := ""
Private aFiliais := {}

l1Elem := If (l1Elem = Nil , .F. , .T.)
lTipoRet := .T.
cAlias := Alias()																					// Salva Alias Anterior

If Empty(mv_par01)	
	IF lTipoRet
		MvPar := &(Alltrim(ReadVar()))																	// Carrega Nome da Variavel do Get em Questao
		mvRet := Alltrim(ReadVar())																		// Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIF
	
	SM0->(dbGoTop())
	While SM0->(!Eof()) .And. cEmpAnt == SM0->M0_CODIGO
		MvParDef += SM0->M0_CODFIL
		aAdd(aFiliais, SM0->(M0_CODFIL + "-" + M0_FILIAL))
		SM0->(dbSkip())
	EndDo
	
	IF lTipoRet
		IF f_Opcoes(@MvPar,cTitulo,aFiliais,MvParDef,24,49,l1Elem,Len(SM0->M0_CODFIL), Len(aFiliais))	// Chama funcao f_Opcoes
			&MvRet := mvpar																				// Devolve Resultado
		EndIF
	EndIF
	
	dbSelectArea(cAlias)																				// Retorna Alias
EndIf

Return( IF( lTipoRet , .T. , MvParDef ) )
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fChkJanelas�Autor � Vin�cius Moreira   � Data � 21/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Checa se existem documentos sem chegada no cliente dentro  ���
���          � do per�odo correto.                                        ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fChkJanelas(nOpcao, cSerTms, cFilVia, cNumVia, cFilDoc, cNumDoc, cSerDoc)

Local lForaPrz  := .F.
Local nHorPrz   := 0
Local cQuery    := ""
Local cCodOco   := ""
Local cColChg   := SuperGetMv("ES_GEFM02I",,"GC02")
Local cColSai   := SuperGetMv("ES_GEFM02L",,"GC05")
Local cEntChg   := SuperGetMv("ES_GEFM02Q",,"GE02")
Local cEntSai   := SuperGetMv("ES_GEFM02T",,"GE05")
Local cAliasQry := GetNextAlias()
Local cDocAnt   := ""
Local cHorIni   := ""
Local cHorFim   := ""
Local cHorChg   := ""
Local cHorSai   := ""
Local nTmpChg   := 0
Local nTmpSai   := SuperGetMv("ES_GEFM02G",,01.00)
Default cSerTms := ""
Default cFilVia := ""
Default cNumVia := ""
Default cFilDoc := ""
Default cNumDoc := ""
Default cSerDoc := ""
//������������������������������������������������������������������Ŀ
//�Coletas                                                           �
//��������������������������������������������������������������������		
If cSerTms == "1"
	cCodOco := FormatIn(cColChg + "," + cColSai, ",")
	cQuery += " SELECT " + CRLF 
	cQuery += "    DUD.DUD_FILDOC FILDOC " + CRLF 
	cQuery += "   ,DUD.DUD_DOC    DOC " + CRLF 
	cQuery += "   ,DUD.DUD_SERIE  SERIE " + CRLF 
	cQuery += "   ,DUA.DUA_CODOCO CODOCO " + CRLF 
	cQuery += "   ,DUA.DUA_HOROCO HOROCO " + CRLF 
	cQuery += "   ,DT5.DT5_HORPRV HORINI " + CRLF 
	cQuery += "   ,DT5.DT5_HORPRV HORFIM " + CRLF 
	//��������������������������������������������������������������������������������Ŀ
	//�Movimento de viagens                                                            �
	//����������������������������������������������������������������������������������
	cQuery += "  FROM " + RetSqlName("DUD") + " DUD " + CRLF 
	//��������������������������������������������������������������������������������Ŀ
	//�Solicita��es de coleta                                                          �
	//����������������������������������������������������������������������������������
	cQuery += " INNER JOIN " + RetSqlName("DT5") + " DT5 ON " + CRLF 
	cQuery += "       DT5.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += "   AND DT5.DT5_FILIAL = DUD.DUD_FILDOC " + CRLF 
	cQuery += "   AND DT5.DT5_FILDOC = DUD.DUD_FILDOC " + CRLF 
	cQuery += "   AND DT5.DT5_DOC    = DUD.DUD_DOC " + CRLF 
	cQuery += "   AND DT5.DT5_SERIE  = DUD.DUD_SERIE " + CRLF 
	//��������������������������������������������������������������������������������Ŀ
	//�Solicitantes                                                                    �
	//����������������������������������������������������������������������������������
	cQuery += " INNER JOIN " + RetSqlName("DUE") + " DUE ON " + CRLF
	cQuery += "       DUE.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "   AND DUE.DUE_FILIAL = '" + xFilial("DUE") + "' " + CRLF
	cQuery += "   AND DUE.DUE_DDD    = DT5.DT5_DDD " + CRLF
	cQuery += "   AND DUE.DUE_TEL    = DT5.DT5_TEL " + CRLF
	//��������������������������������������������������������������������������������Ŀ
	//�Ocorr�ncias                                                                     �
	//����������������������������������������������������������������������������������
	cQuery += " LEFT OUTER JOIN " + RetSqlName("DUA") + " DUA ON " + CRLF 
	cQuery += "       DUA.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += "   AND DUA.DUA_FILIAL = '" + xFilial("DUA") + "' " + CRLF 
	cQuery += "   AND DUA.DUA_FILDOC = DUD.DUD_FILDOC " + CRLF 
	cQuery += "   AND DUA.DUA_DOC    = DUD.DUD_DOC " + CRLF 
	cQuery += "   AND DUA.DUA_SERIE  = DUD.DUD_SERIE " + CRLF 
	cQuery += "   AND DUA.DUA_FILORI = DUD.DUD_FILORI " + CRLF 
	cQuery += "   AND DUA.DUA_VIAGEM = DUD.DUD_VIAGEM " + CRLF 
	cQuery += "   AND DUA.DUA_CODOCO IN " + cCodOco + CRLF 
	cQuery += " WHERE DUD.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += "   AND DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF 
	//������������������������������������������������������������������Ŀ
	//�Buscando dados por viagem.                                        �
	//��������������������������������������������������������������������		
	If nOpcao == 1
		cQuery += "   AND DUD.DUD_FILORI = '" + cFilVia + "' " + CRLF 
		cQuery += "   AND DUD.DUD_VIAGEM = '" + cNumVia + "' " + CRLF 
	//������������������������������������������������������������������Ŀ
	//�Buscando dados por documento.                                     �
	//��������������������������������������������������������������������		
	Else
		cQuery += "   AND DUD.DUD_FILDOC = '" + cFilDoc + "' " + CRLF 
		cQuery += "   AND DUD.DUD_DOC    = '" + cNumDoc + "' " + CRLF 
		cQuery += "   AND DUD.DUD_SERIE  = '" + cSerDoc + "' " + CRLF 
	EndIf
	cQuery += " ORDER BY " + CRLF 
	cQuery += "    DUD.DUD_FILDOC " + CRLF 
	cQuery += "   ,DUD.DUD_DOC    " + CRLF 
	cQuery += "   ,DUD.DUD_SERIE  " + CRLF 
	cQuery += "   ,DUA.DUA_DATOCO " + CRLF 
	cQuery += "   ,DUA.DUA_HOROCO " + CRLF 
	cQuery += "   ,DT5.DT5_HORPRV " + CRLF 
	cQuery := ChangeQuery (cQuery)
	If fDoQuery(cQuery, @cAliasQry)
		While (cAliasQry)->(!Eof())
			If cDocAnt != (cAliasQry)->(FILDOC+DOC+SERIE)
				cDocAnt := (cAliasQry)->(FILDOC+DOC+SERIE)
				cFilDoc := (cAliasQry)->FILDOC
				cDoc    := (cAliasQry)->DOC
				cSerie  := (cAliasQry)->SERIE
				//������������������������������������������������������������������Ŀ
				//�Guarda hora de inicio e fim ideal da coleta.                      �
				//��������������������������������������������������������������������		
				cHorIni := (cAliasQry)->HORINI
				cHorFim := (cAliasQry)->HORFIM
				//������������������������������������������������������������������Ŀ
				//�Busca hora e fim real de coleta.                                  �
				//��������������������������������������������������������������������		
				While cDocAnt == (cAliasQry)->(FILDOC+DOC+SERIE)
					If (cAliasQry)->CODOCO $ cColChg
						cHorChg := (cAliasQry)->HOROCO
					EndIf
					If (cAliasQry)->CODOCO $ cColSai
						cHorSai := (cAliasQry)->HOROCO
					EndIf
					(cAliasQry)->(dbSkip())
				EndDo
				
				If Empty(cHorChg)
					nTmpChg := fGetExceDoc(2, cFilDoc, cDoc, cSerie, cSerTms)
					If fForaPrz(cHorIni, nTmpChg, @nHorPrz)
						lForaPrz := .T.
						Exit
					EndIf
				ElseIf Empty(cHorSai)
					If fForaPrz(cHorFim, nTmpSai, @nHorPrz)
						lForaPrz := .T.
						Exit
					EndIf
				EndIf
			EndIf
			cHorChg := ""
			cHorSai := ""
			cHorIni := ""
			cHorFim := ""
//			(cAliasQry)->(dbSkip())
		EndDo
	EndIf
	(cAliasQry)->(dbCloseArea())
//������������������������������������������������������������������Ŀ
//�Entregas\Transfer�ncias                                           �
//��������������������������������������������������������������������		
Else
	cCodOco := FormatIn(cEntChg + "," + cEntSai, ",")
	cQuery += " SELECT " + CRLF 
	cQuery += "    DUD.DUD_FILDOC FILDOC " + CRLF 
	cQuery += "   ,DUD.DUD_DOC    DOC " + CRLF 
	cQuery += "   ,DUD.DUD_SERIE  SERIE " + CRLF 
	cQuery += "   ,DUA.DUA_CODOCO CODOCO " + CRLF 
	cQuery += "   ,DUA.DUA_HOROCO HOROCO " + CRLF 
	cQuery += "   ,DTR.DTR_HORINI HORINI " + CRLF 
	cQuery += "   ,DTR.DTR_HORFIM HORFIM " + CRLF 
	//��������������������������������������������������������������������������������Ŀ
	//�Movimento de viagens.                                                           �
	//����������������������������������������������������������������������������������
	cQuery += "  FROM " + RetSqlName("DUD") + " DUD " + CRLF 
	//��������������������������������������������������������������������������������Ŀ
	//�Viagens                                                                         �
	//����������������������������������������������������������������������������������
	cQuery += " INNER JOIN " + RetSqlName("DTQ") + " DTQ ON " + CRLF
	cQuery += "       DTQ.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "   AND DTQ.DTQ_FILIAL = '" + xFilial("DTQ") + "' " + CRLF
	cQuery += "   AND DTQ.DTQ_VIAGEM = DUD.DUD_VIAGEM " + CRLF
	//��������������������������������������������������������������������������������Ŀ
	//�Complemento de viagens                                                          �
	//����������������������������������������������������������������������������������
	cQuery += " INNER JOIN " + RetSqlName("DTR") + " DTR ON " + CRLF
	cQuery += "       DTR.DTR_FILIAL = '" + xFilial("DTR") + "' " + CRLF
	cQuery += "   AND DTR.DTR_FILORI = DTQ.DTQ_FILORI " + CRLF
	cQuery += "   AND DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM " + CRLF
	cQuery += "   AND DTR.DTR_ITEM   = '" + StrZero(1,TamSx3("DTR_ITEM")[1]) + "' " + CRLF
	cQuery += "   AND DTR.D_E_L_E_T_ = ' ' " + CRLF
	//��������������������������������������������������������������������������������Ŀ
	//�Ocorr�ncias                                                                     �
	//����������������������������������������������������������������������������������
	cQuery += " LEFT OUTER JOIN " + RetSqlName("DUA") + " DUA ON " + CRLF 
	cQuery += "       DUA.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += "   AND DUA.DUA_FILIAL = '" + xFilial("DUA") + "' " + CRLF 
	cQuery += "   AND DUA.DUA_FILDOC = DUD.DUD_FILDOC " + CRLF 
	cQuery += "   AND DUA.DUA_DOC    = DUD.DUD_DOC " + CRLF 
	cQuery += "   AND DUA.DUA_SERIE  = DUD.DUD_SERIE " + CRLF 
	cQuery += "   AND DUA.DUA_FILORI = DUD.DUD_FILORI " + CRLF 
	cQuery += "   AND DUA.DUA_VIAGEM = DUD.DUD_VIAGEM " + CRLF 
	cQuery += "   AND DUA.DUA_CODOCO IN " + cCodOco + CRLF 
	cQuery += " WHERE DUD.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += "   AND DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF 
	//������������������������������������������������������������������Ŀ
	//�Buscando dados por viagem.                                        �
	//��������������������������������������������������������������������		
	If nOpcao == 1
		cQuery += "   AND DUD.DUD_FILORI = '" + cFilVia + "' " + CRLF 
		cQuery += "   AND DUD.DUD_VIAGEM = '" + cNumVia + "' " + CRLF 
	//������������������������������������������������������������������Ŀ
	//�Buscando dados por documento.                                     �
	//��������������������������������������������������������������������		
	Else
		cQuery += "   AND DUD.DUD_FILDOC = '" + cFilDoc + "' " + CRLF 
		cQuery += "   AND DUD.DUD_DOC    = '" + cNumDoc + "' " + CRLF 
		cQuery += "   AND DUD.DUD_SERIE  = '" + cSerDoc + "' " + CRLF 
	EndIf
	cQuery += " ORDER BY " + CRLF 
	cQuery += "    DUD.DUD_FILDOC " + CRLF 
	cQuery += "   ,DUD.DUD_DOC    " + CRLF 
	cQuery += "   ,DUD.DUD_SERIE  " + CRLF 
	cQuery += "   ,DUA.DUA_DATOCO " + CRLF 
	cQuery += "   ,DUA.DUA_HOROCO " + CRLF 
	cQuery += "   ,DTR.DTR_HORINI " + CRLF 
	cQuery += "   ,DTR.DTR_HORFIM " + CRLF 
	cQuery := ChangeQuery (cQuery)
	If fDoQuery(cQuery, @cAliasQry)
		While (cAliasQry)->(!Eof())
			If cDocAnt != (cAliasQry)->(FILDOC+DOC+SERIE)
				cDocAnt := (cAliasQry)->(FILDOC+DOC+SERIE)
				cFilDoc := (cAliasQry)->FILDOC
				cDoc    := (cAliasQry)->DOC
				cSerie  := (cAliasQry)->SERIE
				//������������������������������������������������������������������Ŀ
				//�Guarda hora de inicio e fim ideal da entrega                      �
				//��������������������������������������������������������������������		
				cHorIni := (cAliasQry)->HORINI
				cHorFim := (cAliasQry)->HORFIM
				//������������������������������������������������������������������Ŀ
				//�Busca hora e fim real de entrega                                  �
				//��������������������������������������������������������������������		
				While cDocAnt == (cAliasQry)->(FILDOC+DOC+SERIE)
					If (cAliasQry)->CODOCO $ cEntChg
						cHorChg := (cAliasQry)->HOROCO
					EndIf
					If (cAliasQry)->CODOCO $ cEntSai
						cHorSai := (cAliasQry)->HOROCO
					EndIf
					(cAliasQry)->(dbSkip())
				EndDo
				
				If Empty(cHorChg)
					nTmpChg := fGetExceDoc(2, cFilDoc, cDoc, cSerie, cSerTms)
					If fForaPrz(cHorIni, nTmpChg, @nHorPrz)
						lForaPrz := .T.
						Exit
					EndIf
				ElseIf Empty(cHorSai)
					If fForaPrz(cHorFim, nTmpSai, @nHorPrz)
						lForaPrz := .T.
						Exit
					EndIf
				EndIf
			EndIf
			cHorChg := ""
			cHorSai := ""
			cHorIni := ""
			cHorFim := ""
			(cAliasQry)->(dbSkip())
		EndDo
	EndIf
	(cAliasQry)->(dbCloseArea())
EndIf 

Return {lForaPrz, StrZero(nHorPrz*100, 6)}
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fForaPrz �Autor  � Vin�cius Moreira   � Data � 21/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Checa se horario esta fora do prazo.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fForaPrz(cHorIni, nTmpLim, nDifHoras)

Local lRet        := .F.
Local nHorAtu     := Val(Left(StrTran(Time(),":", "."), 5))
Local nHorTmp     := 0
Local nHorIni     := Val(cHorIni)/100
Default nDifHoras := 0

nHorTmp   := SubHoras(nHorIni, nTmpLim)
lRet      := SubHoras (nHorAtu, nHorTmp) > 0
nDifHoras := SubHoras (nHorAtu, nHorIni)
If nDifHoras < 0
	nDifHoras := 0
EndIf

Return lRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fChgOrdem�Autor  � Vin�cius Moreira   � Data � 21/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Muda ordem dos registros na tela.                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fChgOrdem (oListBox, aDados, bLine, aTitulos, aOrdens, nOrdem)

Local aCpoOrd  := Separa(aOrdens[nOrdem], "+")
Local cBlkOrdX := ""
Local cBlkOrdY := ""
Local bBlkOrd  := {|| }
Local nX       := 0
/*
If Len(aCpoOrd) > 0 .And. !Empty(aCpoOrd[1])
	For nX := 1 to Len(aCpoOrd)
		nPosCpo := aScan(aTitulos, {|x| Upper(x) == Upper(aCpoOrd[nX]) })
		If ValType(aDados[1,nPosCpo]) == "N"
			cBlkOrdX += If(!Empty(cBlkOrdX), "+", "") + " Str(x[ " + cValToChar(nPosCpo) + " ])"
			cBlkOrdY += If(!Empty(cBlkOrdY), "+", "") + " Str(y[ " + cValToChar(nPosCpo) + " ])"
		ElseIf ValType(aDados[1,nPosCpo]) == "D"
			cBlkOrdX += If(!Empty(cBlkOrdX), "+", "") + " dToS(x[ " + cValToChar(nPosCpo) + " ])"
			cBlkOrdY += If(!Empty(cBlkOrdY), "+", "") + " dToS(y[ " + cValToChar(nPosCpo) + " ])"
		Else
			cBlkOrdX += If(!Empty(cBlkOrdX), "+", "") + " x[ " + cValToChar(nPosCpo) + " ]"
			cBlkOrdY += If(!Empty(cBlkOrdY), "+", "") + " y[ " + cValToChar(nPosCpo) + " ]"
		EndIf
	Next nX 
	
	bBlkOrd := &("{|| aSort (aDados,,, { |x, y| ( " + cBlkOrdX + " ) < ( " + cBlkOrdY + " ) })}")
	MsgRun("Aguarde... Ordenando registros... ",, bBlkOrd)
	oListBox:SetArray(aDados)
	oListBox:bLine := bLine
	oListBox:Refresh(.T.)
EndIf
*/
//����������������������������������������������������������������������Ŀ
//�Op��es de ordem.                                                      �
//�1 - ""                                                                �
//�2 - Fil.Viagem+Viagem                                                 �
//�3 - Placa+Fil.Viagem+Viagem                                           �
//�4 - Motorista+Fil.Viagem+Viagem                                       �
//�5 - Ult.Ocorr�ncia                                                    �
//�6 - Status+Viagem                                                     �
//�7 - Num.Plano                                                         �
//�8 - Numero SM                                                         �
//�9 - Prv.Ini.Viagem                                                    �
//������������������������������������������������������������������������
If nOrdem == 2
	bBlkOrd := {|| aSort (aDados,,, { |x, y| ( x[nVFILIAL] + x[nVVIAGEM] ) < ( y[nVFILIAL] + y[nVVIAGEM] ) })}
ElseIf nOrdem == 3
	bBlkOrd := {|| aSort (aDados,,, { |x, y| ( x[nVPLACA] + x[nVFILIAL] + x[nVVIAGEM] ) < ( y[nVPLACA] + y[nVFILIAL] + y[nVVIAGEM] ) })}
ElseIf nOrdem == 4
	bBlkOrd := {|| aSort (aDados,,, { |x, y| ( x[nVNOMMOT] + x[nVFILIAL] + x[nVVIAGEM] ) < ( y[nVNOMMOT] + y[nVFILIAL] + y[nVVIAGEM] ) })}
ElseIf nOrdem == 5
	bBlkOrd := {|| aSort (aDados,,, { |x, y| ( dToS(x[nVDATOCO])+x[nVHOROCO] ) < ( dToS(y[nVDATOCO])+y[nVHOROCO] ) })}
ElseIf nOrdem == 6
	bBlkOrd := {|| aSort (aDados,,, { |x, y| ( cValToChar(x[nVSTATUS]) + x[nVVIAGEM] ) < ( cValToChar(y[nVSTATUS]) + y[nVVIAGEM] ) })}
ElseIf nOrdem == 7
	bBlkOrd := {|| aSort (aDados,,, { |x, y| ( x[nVPLANID] ) < ( y[nVPLANID] ) })}
ElseIf nOrdem == 8
	bBlkOrd := {|| aSort (aDados,,, { |x, y| ( x[nVNUMSM ] ) < ( y[nVNUMSM ] ) })}
ElseIf nOrdem == 1 .Or. nOrdem == 9
	bBlkOrd := {|| aSort (aDados,,, { |x, y| ( dToS(x[nVDATVIA ]) + x[nVHORVIA] ) < (dToS(y[nVDATVIA ]) + y[nVHORVIA]) })}
EndIf

MsgRun("Aguarde... Ordenando registros... ",, bBlkOrd)
oListBox:SetArray(aDados)
oListBox:bLine := bLine
oListBox:Refresh(.T.)

Return 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fMntOco  �Autor  � Vin�cius Moreira   � Data � 21/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para chamada das fun��es do padr�o para inclus�o e  ���
���          � estorno de ocorr�ncias.                                    ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fMntOco (nRecDTQ)

Local aArea      := GetArea()
Local aAreaDTQ   := DTQ->(GetArea())
Local cOldFName  := FunName() //-- Utilizado para restaurar o FunName original, pois na chamada das rotinas atraves do submenu sera alterado.
Local cFiltraSub := ""
Local aCampos	 := {}
Local aCores
Local cBkpFiltro := If(Type("cFiltro")!="U",cFiltro, "")
Local lRet		 := .F.
Local cRetPE     := ""
Local oModel215  := Nil
Local nOpcView   := 0
Local cVeiCar	 := ''
Local cCodVei	 := ''
Local aCodVei	 := {}
Local aIndex     := {}
Local cFilBkp    := cFilAnt
Default nRecDTQ  := 0

SaveInter()

If nRecDTQ > 0
	DTQ->(dbGoTo(nRecDTQ))
EndIf

//�������������������������������������������������������Ŀ
//� Salva as variaveis utilizadas do MBrowse Anterior.    �
//���������������������������������������������������������
SaveInter()
EndFilBrw("DTQ",aIndex)
cFilAnt := DTQ->DTQ_FILORI

Private aIndexSub  := {}
Private bFiltraSub := {}
Private cCadastro  := "Registro de Ocorrencia"
Private INLCUI      := .F.
Private ALTERA      := .F.

SetFunName("TMSA360")
//TMA360Ini() //-- Inicializa F12 os Ajustes SX, help
DbSelectArea("DUA")
DbSetOrder(1)
aRotina := {}

aAdd( aRotina, { "Pesquisar" 	, 'TMSXPesqui', 0, 1}) //"&Pesquisar"
aAdd( aRotina, { "Visualizar" 	, 'U_RGEFM02B', 0, 2}) //"&Visualizar"
aAdd( aRotina, { "Apontar" 		, 'U_RGEFM02B', 0, 3}) //"&Apontar"	
aAdd( aRotina, { "Estornar" 	, 'U_RGEFM02B', 0, 6}) //"&Estornar"

aIndexSub  := {}
cFiltraSub := "DUA_FILIAL=='"+xFilial("DUA")+"'.And.DUA_FILORI=='"+DTQ->DTQ_FILORI+"'.And.DUA_VIAGEM=='"+DTQ->DTQ_VIAGEM+"'"
bFiltraSub := {|| FilBrowse("DUA",@aIndexSub,@cFiltraSub) }
Eval(bFiltraSub)

MaWndBrowse(0,0,300,600,cCadastro,"DUA",aCampos,aRotina,,,,.T.,,,,,,,,.F.) //"Reg.Ocorrencia"

//������������������������������������������������������������������������Ŀ
//� Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       �
//��������������������������������������������������������������������������
EndFilBrw("DUA",aIndexSub)
//�������������������������������������������������������������Ŀ
//� Restaura as Variaveis do MBrowse Anterior                   �
//���������������������������������������������������������������
SetFunName(cOldFName)
RestInter()
RestArea( aAreaDTQ )
RestArea( aArea )

cFilAnt := cFilBkp
cFiltro:= cBkpFiltro
CursorWait()
If Type('bFiltraBrw') <> 'U'
	Eval(bFiltraBrw)
EndIf
CursorArrow()

RestInter()

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fMntOper �Autor  � Vin�cius Moreira   � Data � 21/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para chamada das fun��es do padr�o para apontamento ���
���          � das opera��es da viagem.                                   ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fMntOper()

Local aArea    := GetArea()
Local aAreaDTW := DTW->(GetArea())
Private cCadastro := ""
Private Inclui     := .F.

Private cFiltro    := ""
Private bFiltraBrw
Private cSerTms    := "3"
Private cTipTra    := "1"
Private lLocaliz   := GetMv("MV_LOCALIZ") == "S"
Private aIndex     := {}  
Private cCadastro  := "Opera��es da Viagem"
Private Altera     := .F.
Private aRotina	   := {	{"","",0,1,0,.F.},;
						{"","",0,2,0,NIL},;
						{"","",0,3,0,NIL},;
						{"","",0,6,0,NIL}}

SaveInter()
TMSA144Sub(4,2)
RestInter()

RestArea(aAreaDTW)
RestArea(aArea)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fSincAuto�Autor  � Vin�cius Moreira   � Data � 21/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa op��o de refresh automatico.                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fSincAuto(oDlg)

Local lRet := .T.
oDlg:End()

Return lRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fVisMot  �Autor  � Vin�cius Moreira   � Data � 21/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Visualiza cadastro de motorista.                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fVisMot (nRecDA4)

Local aArea    := GetArea()
Local aAreaDA4 := DA4->(GetArea())
fTeclas(2)

SaveInter()
cCadastro := "Cadastro de Motorista"
DA4->(DbSetOrder(1))
DA4->(dbGoTo(nRecDA4))
AxVisual('DA4',nRecDA4,2)
RestInter()

fTeclas(1)
RestArea(aAreaDA4)
RestArea(aArea)

Return 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fVisVei  �Autor  � Vin�cius Moreira   � Data � 21/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Visualiza cadastro de ve�culo.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fVisVei (nRecDA3)

Local aArea    := GetArea()
Local aAreaDA3 := DA3->(GetArea())
fTeclas(2)

SaveInter()
cCadastro := "Cadastro de Ve�culo"
DA3->(DbSetOrder(1))
DA3->(dbGoTo(nRecDA3))
AxVisual('DA3',nRecDA3,2)
RestInter()

fTeclas(1)
RestArea(aAreaDA3)
RestArea(aArea)

Return 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fTeclas  �Autor  � Vin�cius Moreira   � Data � 28/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Liga e desliga teclas de atalho.                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fTeclas (nOpcao)

If nOpcao == 1
	SetKey (VK_F2, bVisVei)
	SetKey (VK_F4, bVisMot)
	SetKey (VK_F5, bVisOco)	
ElseIf nOpcao == 2
	SetKey(VK_F2,bOldF2)
	SetKey(VK_F4,bOldF4)    
	SetKey (VK_F5,bVisOco)		
EndIf

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGetUltOco�Autor  � Vin�cius Moreira   � Data � 28/08/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca ultima ocorr�ncia da viagem.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetUltOco (cFilVia, cNumVia, cFilDoc, cDoc, cSerDoc, lTodas)

Local aRet      := {}
Local cQuery    := ""
Local cAliasQry := GetNextAlias()
Local cCodOco   := ""
Local cDesOco   := ""
Local dDatOco   := cToD("//")
Local cHorOco   := ""

Default cFilVia := ""
Default cNumVia := ""
Default cFilDoc := ""
Default cDoc    := ""
Default cSerDoc := ""
Default lTodas  := .F.

If lTodas
	cQuery += "  SELECT " + CRLF
	cQuery += "     DUA.DUA_DATOCO DATOCO " + CRLF
	cQuery += "    ,DUA.DUA_HOROCO HOROCO " + CRLF
	cQuery += "    ,DUA.DUA_CODOCO CODOCO " + CRLF
	cQuery += "    ,DT2.DT2_DESCRI DESOCO " + CRLF
	cQuery += "    ,DUA.DUA_FILDOC DOCFIL " + CRLF
	cQuery += "    ,DUA.DUA_DOC    DOCNUM " + CRLF
	cQuery += "    ,DUA.DUA_SERIE  DOCSER " + CRLF
	cQuery += "   FROM " + RetSqlName("DUA") + " DUA " + CRLF
	cQuery += " INNER JOIN " + RetSqlName("DT2") + " DT2 ON " + CRLF
	cQuery += "        DT2.D_E_L_E_T_ = ' '  " + CRLF
	cQuery += "    AND DT2.DT2_FILIAL = '" + xFilial("DT2") + "'  " + CRLF
	cQuery += "    AND DT2.DT2_CODOCO = DUA.DUA_CODOCO " + CRLF
	cQuery += "  WHERE DUA.DUA_FILIAL = '" + xFilial("DUA") + "' " + CRLF
	If !Empty(cFilVia) .And. !Empty(cNumVia)
		cQuery += "    AND DUA.DUA_FILORI = '" + cFilVia + "' " + CRLF
		cQuery += "    AND DUA.DUA_VIAGEM = '" + cNumVia + "' " + CRLF
	EndIf
	If !Empty(cFilDoc) .And. !Empty(cDoc) .And. !Empty(cSerDoc)
		cQuery += "    AND DUA.DUA_FILDOC = '" + cFilDoc + "' " + CRLF
		cQuery += "    AND DUA.DUA_DOC    = '" + cDoc + "' " + CRLF	
		cQuery += "    AND DUA.DUA_SERIE  = '" + cSerDoc + "' " + CRLF	
	EndIf
	cQuery += "    AND DUA.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "  ORDER BY " + CRLF
	cQuery += "     DUA.DUA_DATOCO DESC " + CRLF
	cQuery += "    ,DUA.DUA_HOROCO DESC " + CRLF
	cQuery += "    ,DUA.DUA_CODOCO " + CRLF
	
	cQuery := ChangeQuery (cQuery)
	fDoQuery (cQuery, cAliasQry)
	
	TcSetField(cAliasQry,"DATOCO",TamSx3("DUA_DATOCO")[3],TamSx3("DUA_DATOCO")[1],TamSx3("DUA_DATOCO")[2])
	While (cAliasQry)->(!Eof())
		aAdd(aRet, {	(cAliasQry)->CODOCO,;
						(cAliasQry)->DESOCO,;
						(cAliasQry)->DATOCO,;
						(cAliasQry)->HOROCO,;
						(cAliasQry)->DOCFIL,;
						(cAliasQry)->DOCNUM,;
						(cAliasQry)->DOCSER})
		(cAliasQry)->(dbSkip())
	EndDo
Else
	cQuery += "  SELECT " + CRLF
	cQuery += "     MAX(DUA.DUA_DATOCO || DUA.DUA_HOROCO || DUA.DUA_CODOCO) CODOCO " + CRLF
	cQuery += "   FROM " + RetSqlName("DUA") + " DUA " + CRLF
	cQuery += "  WHERE DUA.DUA_FILIAL = '" + xFilial("DUA") + "' " + CRLF
	If !Empty(cFilVia) .And. !Empty(cNumVia)
		cQuery += "    AND DUA.DUA_FILORI = '" + cFilVia + "' " + CRLF
		cQuery += "    AND DUA.DUA_VIAGEM = '" + cNumVia + "' " + CRLF
	EndIf
	If !Empty(cFilDoc) .And. !Empty(cDoc) .And. !Empty(cSerDoc)
		cQuery += "    AND DUA.DUA_FILDOC = '" + cFilDoc + "' " + CRLF
		cQuery += "    AND DUA.DUA_DOC    = '" + cDoc + "' " + CRLF	
		cQuery += "    AND DUA.DUA_SERIE  = '" + cSerDoc + "' " + CRLF	
	EndIf
	cQuery += "    AND DUA.D_E_L_E_T_ = ' ' " + CRLF
	
	cQuery := ChangeQuery (cQuery)
	fDoQuery (cQuery, cAliasQry)
	While (cAliasQry)->(!Eof())
		cCodOco := AllTrim((cAliasQry)->CODOCO)
		If !Empty(cCodOco)		
			dDatOco := sToD(SubStr(cCodOco, 01, 08))
			cHorOco := SubStr(cCodOco, 09, 04)
			cCodOco := SubStr(cCodOco, 13, nTamCodOco)
			cDesOco := AllTrim(Posicione("DT2", 1, xFilial("DT2")+cCodOco, "DT2_DESCRI"))
			
			aAdd(aRet, {	cCodOco,;
							cDesOco,;
							dDatOco,;
							cHorOco,;
							"",;
							"",;
							""})
		EndIf
		(cAliasQry)->(dbSkip())
	EndDo
EndIf
(cAliasQry)->(dbCloseArea())

Return aRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGetUltPos�Autor  � Vin�cius Moreira   � Data � 07/09/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca ultima posi��o da viagem.                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetUltPos (cFilVia, cNumVia, cFilDoc, cDoc, cSerDoc, lTodas)

Local cRet      := ""
Local cQuery    := ""
Local cAliasQry := GetNextAlias()

Default cFilVia := ""
Default cNumVia := ""
Default cFilDoc := ""
Default cDoc    := ""
Default cSerDoc := ""
Default lTodas  := .F.

cQuery += "  SELECT " + CRLF
cQuery += "     MAX(DUA.DUA_DATOCO + DUA.DUA_HOROCO + DUA.DUA_CODOCO) CODOCO " + CRLF
cQuery += "   FROM " + RetSqlName("DUA") + " DUA " + CRLF
cQuery += "  WHERE DUA.DUA_FILIAL = '" + xFilial("DUA") + "' " + CRLF
cQuery += "    AND DUA.DUA_FILORI = '" + cFilVia + "' " + CRLF
cQuery += "    AND DUA.DUA_VIAGEM = '" + cNumVia + "' " + CRLF
cQuery += "    AND DUA.D_E_L_E_T_ = ' ' " + CRLF
cQuery := ChangeQuery (cQuery)
fDoQuery (cQuery, cAliasQry)
If (cAliasQry)->(!Eof())
	cRet := AllTrim((cAliasQry)->CODOCO)
	cRet := Iif(Empty(cRet),"Sem Ocorr�ncia",DTOC(STOD(SubStr(cRet,1,8))) + " - " + TransForm(SubStr(cRet,9,4), "@R 99:99") + " - " + SubStr(cRet,13,4))
EndIf
(cAliasQry)->(dbCloseArea())

Return cRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGetUltEve�Autor  � Vin�cius Moreira   � Data � 28/08/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca ultimo evento da viagem.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetUltEve (cFilVia, cNumVia, cFilDoc, cDoc, cSerDoc, lTodas)

Local cRet      := ""
Local cQuery    := ""

Default cFilVia := ""
Default cNumVia := ""
Default cFilDoc := ""
Default cDoc    := ""
Default cSerDoc := ""
Default lTodas  := .F.
/*
Local cAliasQry := GetNextAlias()

cQuery += "  SELECT " + CRLF
cQuery += "     MAX(DUA.DUA_DATOCO || DUA.DUA_HOROCO || DUA.DUA_CODOCO) CODOCO " + CRLF
cQuery += "   FROM " + RetSqlName("DUA") + " DUA " + CRLF
cQuery += "  WHERE DUA.DUA_FILIAL = '" + xFilial("DUA") + "' " + CRLF
cQuery += "    AND DUA.DUA_FILORI = '" + cFilVia + "' " + CRLF
cQuery += "    AND DUA.DUA_VIAGEM = '" + cNumVia + "' " + CRLF
cQuery += "    AND DUA.D_E_L_E_T_ = ' ' " + CRLF
cQuery := ChangeQuery (cQuery)
fDoQuery (cQuery, cAliasQry)
If (cAliasQry)->(!Eof())
	cRet := AllTrim((cAliasQry)->CODOCO)
EndIf
(cAliasQry)->(dbCloseArea())
*/
Return cRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGetUltRMA�Autor  � Vin�cius Moreira   � Data � 28/08/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca ultimo RMA da viagem.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetUltRMA (cFilVia, cNumVia, cFilDoc, cDoc, cSerDoc, lTodas)

Local cRet      := ""
Local cQuery    := ""

Default cFilVia := ""
Default cNumVia := ""
Default cFilDoc := ""
Default cDoc    := ""
Default cSerDoc := ""
Default lTodas  := .F.
/*
Local cAliasQry := GetNextAlias()

cQuery += "  SELECT " + CRLF
cQuery += "     MAX(DUA.DUA_DATOCO || DUA.DUA_HOROCO || DUA.DUA_CODOCO) CODOCO " + CRLF
cQuery += "   FROM " + RetSqlName("DUA") + " DUA " + CRLF
cQuery += "  WHERE DUA.DUA_FILIAL = '" + xFilial("DUA") + "' " + CRLF
cQuery += "    AND DUA.DUA_FILORI = '" + cFilVia + "' " + CRLF
cQuery += "    AND DUA.DUA_VIAGEM = '" + cNumVia + "' " + CRLF
cQuery += "    AND DUA.D_E_L_E_T_ = ' ' " + CRLF
cQuery := ChangeQuery (cQuery)
fDoQuery (cQuery, cAliasQry)
If (cAliasQry)->(!Eof())
	cRet := AllTrim((cAliasQry)->CODOCO)
EndIf
(cAliasQry)->(dbCloseArea())
*/

Return cRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fIncEvento�Autor  � Vin�cius Moreira   � Data � 01/09/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Inclus�o de eventos nos alvos.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fIncEvento (nRecDTQ, _nPlanoId)

Local aArea        := GetArea()
Local aAreaDTQ     := DTQ->(GetArea())
Local lRet         := .F.
Local oDlg
Local aButtons     := {}
Local aSize        := MsAdvSize(.T.)
Local aInfo        := {}
Local aPosObj      := {}
Local aObjects     := {}
Local cTitulo      := "Inclus�o de Eventos - "
Local oListAlvos
Local bLine        := {|| }
Local aHeadAlvos   := {"", "", "Filial", "Documento", "Serie", "Hor.Ini.", "Hor.Fim.", "Nome", "Ult.Oco", "Endereco", "Bairro", "Municipio", "Estado", "Ult.Evento", "Ult.RMA", ""}
Local aAlvos       := {}
Local oStatus, oDatAlvo, oHorAlvo, oUltPos
Local dDatAlvo     := Date()
Local cHorAlvo     := Left(Time(), 05)
Local cUltPos      := ""
Local aStatus      := {}
Local nOpcA        := 0
Local cIniVCOL  := SuperGetMv("ES_GEFM02H",,"GC01")
Local cChegCOL  := SuperGetMv("ES_GEFM02I",,"GC02")
Local cIniDCOL  := SuperGetMv("ES_GEFM02J",,"GC03")
Local cFimDCOL  := SuperGetMv("ES_GEFM02K",,"GC04")
Local cSaidCOL  := SuperGetMv("ES_GEFM02L",,"GC05")
Local cParaCOL  := SuperGetMv("ES_GEFM02M",,"GC06")
Local cContCOL  := SuperGetMv("ES_GEFM02N",,"GC07")
Local cFimVCOL  := SuperGetMv("ES_GEFM02O",,"GC08")
Local cEntVCOL  := SuperGetMv("ES_GEFM02Z",,"GC11")
Local cOutVCOL  := cOcoOutros
Local cIniVENT  := SuperGetMv("ES_GEFM02P",,"GE01")
Local cChegENT  := SuperGetMv("ES_GEFM02Q",,"GE02")
Local cIniDENT  := SuperGetMv("ES_GEFM02R",,"GE03")
Local cFimDENT  := SuperGetMv("ES_GEFM02S",,"GE04")
Local cSaidENT  := SuperGetMv("ES_GEFM02T",,"GE05")
Local cParaENT  := SuperGetMv("ES_GEFM02U",,"GE06")
Local cContENT  := SuperGetMv("ES_GEFM02V",,"GE07")
Local cFimVENT  := SuperGetMv("ES_GEFM02X",,"GE08")
Local cOutVENT  := cOcoOutros

Private aOcoVCOL:= {	cIniVCOL,;
						cChegCOL,;
						cIniDCOL,;
						cFimDCOL,;
						cSaidCOL,;
						cParaCOL,;
						cContCOL,;
						cFimVCOL,;
						cEntVCOL,;
						cOutVCOL}
Private aOcoVENT:= {	cIniVENT,;
						cChegENT,;
						cIniDENT,;
						cFimDENT,;
						cSaidENT,;
						cParaENT,;
						cContENT,;
						cFimVENT,;
						cOutVENT}
Private nEvento    := 0
Private oHistorico 
Private cHistorico := ""
Private oNovoTexto 
Private cNovoTexto := ""

// Verifico se tem Motorista informado - Ricardo - Em: 03/05/2016
dbSelectArea("DF0") ; dbSetOrder(3)
If dbSeek(xFilial("DF0") + AllTrim(Str(_nPlanoId)))
	If Empty(DF0->DF0_CODVEI)
		Help (" ", 1, "CNH214A",,'N�o h� ve�culo informado no Plano de transporte '+AllTrim(Str(_nPlanoId)), 3, 0)
		dbSelectArea("DTQ")
		Return lRet
	EndIf	
EndIf

dbSelectArea("DTQ")

DTQ->(dbGoTo(nRecDTQ))
cTitulo += DTQ->DTQ_FILORI + "/" + DTQ->DTQ_VIAGEM

MsgRun("Aguarde... Selecionando registros... ",,{|| aAlvos := fGetAlvos(DTQ->DTQ_FILORI, DTQ->DTQ_VIAGEM, DTQ->DTQ_SERTMS) })

If Len(aAlvos) == 0
	Help (" ", 1, "RGEFM0202",,"N�o h� documentos nesta viagem.", 3, 0)
Else
	If DTQ->DTQ_SERTMS == "1"
		aStatus := {	"Inicio de viagem",;
						"Chegada no alvo",;
						"Inicio de carga/descarga",;
						"Fim de carga/descarga",;
						"Saida do alvo",;
						"Interromper viagem",;
						"Continuar viagem",;
						"Fim de viagem",;
						"Proc.Entrega",;
						"Outros"}
	Else
		aStatus := {	"Inicio de viagem",;
						"Chegada no alvo",;
						"Inicio de carga/descarga",;
						"Fim de carga/descarga",;
						"Saida do alvo",;
						"Interromper viagem",;
						"Continuar viagem",;
						"Fim de viagem",;
						"Outros"}
	EndIf

	//������������������������������������������������������������������Ŀ
	//�Busca informa��o da ultima posicao da viagem.                     �
	//��������������������������������������������������������������������
	cUltPos := "" // fGetUltPos(DTQ->DTQ_FILORI, DTQ->DTQ_VIAGEM)

	aAdd(aButtons,{"S4WB001N",{|| fVisDoc (aAlvos[oListAlvos:nAt,nARECDT6])}, "Documento"		, "Documento"	})
	aAdd(aButtons,{"SELECT"  ,{|| lRet := .T., fMntOco (), oDlg:End() 	}, "Ocorr�ncias"	, "Ocorr�ncias"	})
	aAdd(aButtons,{"S4WB001N",{|| lRet := .T., oDlg:End() 					}, "Atualizar"		, "Atualizar"	})
	aAdd(aButtons,{"S4WB013N",{|| fExibeLeg(2)								}, "Legenda"		, "Legenda"		})	

	aAdd( aObjects, { 100, 040, .T., .T., .F. } )
	aAdd( aObjects, { 100, 060, .T., .T., .F. } )
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 1, 1 }
	aPosObj := MsObjSize( aInfo, aObjects, .T. )
	
	DEFINE MSDIALOG oDlg FROM aSize[7],00 TO aSize[6],aSize[5] TITLE cTitulo PIXEL
	
	//������������������������������������������������������������������Ŀ
	//�A��es dos alvos - INICIO                                          �
	//��������������������������������������������������������������������	
	TSay():New(aPosObj[1][1]+2,aPosObj[1][2],{|| "Data" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,100,80)
	oDatAlvo := TGet():New(aPosObj[1][1], aPosObj[1][2]+20,{|u| if(PCount()>0,dDatAlvo:=u,dDatAlvo)}, oDlg, 50,10, "",{||  },,,,,,.T.,,,,,,,,,,'dDatAlvo')

	TSay():New(aPosObj[1][1]+2,aPosObj[1][2]+100,{|| "Hora" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,100,80)
	oHorAlvo := TGet():New(aPosObj[1][1], aPosObj[1][2]+120,{|u| if(PCount()>0,cHorAlvo:=u,cHorAlvo)}, oDlg, 20,10, "@R 99:99",{|| cHorAlvo := StrZero(Val(cHorAlvo), 4) },,,,,,.T.,,,,,,,,,,'cHorAlvo')
	
	TSay():New(aPosObj[1][1]+2,aPosObj[1][2]+190,{|| "Ult.Posicao" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,120,80)
	oUltPos := TGet():New(aPosObj[1][1], aPosObj[1][2]+225,{|u| if(PCount()>0,cUltPos:=u,cUltPos)}, oDlg, 80,10, "@!",{||  },,,,,,.T.,,,,,,,,,,'cUltPos')
	oUltPos:bWhen := {|| .F.} 
	
	TSay():New(aPosObj[1][1]+15,aPosObj[1][2],{|| "Evento" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,100,80)
	oStatus := TRadMenu():Create (oDlg,,aPosObj[1][1]+15,aPosObj[1][2]+20,aStatus,,,,,,,,100,12,,,,.T.)
	oStatus:bSetGet := {|u|Iif (PCount()==0,nEvento,nEvento:=u)}
	//������������������������������������������������������������������Ŀ
	//�A��es dos alvos - FIM                                             �
	//��������������������������������������������������������������������	
	//������������������������������������������������������������������Ŀ
	//�Campos de historico.                                              �
	//��������������������������������������������������������������������	
	TSay():New(aPosObj[1][1]+15,aPosObj[1][2]+100,{|| "Nova Mensagem" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,100,80)
	oNovoTexto := TMultiget():Create(oDlg,{|u|if(Pcount()>0,cNovoTexto:=u,cNovoTexto)},aPosObj[1][1]+025,aPosObj[1][2]+100,250,070,,,,,,.T.,,,,,,.F.,,,,,.T.,)
	TSay():New(aPosObj[1][1]+15,aPosObj[1][2]+351,{|| "Historico" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,100,80)
	oHistorico := TMultiget():Create(oDlg,{|u|if(Pcount()>0,cHistorico:=u,cHistorico)},aPosObj[1][1]+025,aPosObj[1][2]+351,250,070,,,,,,.T.,,,,,,.T.,,,,,.T.,)
	
	//������������������������������������������������������������������Ŀ
	//�Carrega informa��es de historico.                                 �
	//��������������������������������������������������������������������
	fMntHist(2, DTQ->DTQ_VIAGEM)
	//������������������������������������������������������������������Ŀ
	//�Bot�es para salvar historico.                                     �
	//��������������������������������������������������������������������
	TButton():Create( oDlg, aPosObj[1][1]+095, aPosObj[1][2]+100,"&Salvar Obs"	,{|| fMntHist(3, DTQ->DTQ_VIAGEM) },45,10,,,,.T.,,,,,,) 
	TButton():Create( oDlg, aPosObj[1][1]+095, aPosObj[1][2]+190,"&Limpar Obs"	,{|| fMntHist(5) },45,10,,,,.T.,,,,,,) 
	//������������������������������������������������������������������Ŀ
	//�Lista de alvos - INICIO                                           �
	//��������������������������������������������������������������������	
	oListAlvos := TWBrowse():New( aPosObj[2][1],aPosObj[2][2],aPosObj[2][4],aPosObj[2][3]-aPosObj[1][3],,aHeadAlvos,, oDlg, ,,,,;
	{|nRow,nCol,nFlags|,oListAlvos:Refresh()},,,,,,,.F.,,.T.,,.F.,,, )
	
	oListAlvos:SetArray(aAlvos)
	oListAlvos:bLine := {|| {	If(aAlvos[oListAlvos:nAt,nAMARCA],oLegOk, oLegNo),;	//Marca
							aLegendas[aAlvos[oListAlvos:nAt,nALEGEND],nLEGOBJ],;		//Legenda
							aAlvos[oListAlvos:nAt,nADOCFIL],;							//Filial do documento
							aAlvos[oListAlvos:nAt,nADOCNUM],;							//Numero do documento
							aAlvos[oListAlvos:nAt,nADOCSER],;							//Serie do documento
							Transform(aAlvos[oListAlvos:nAt,nAHORINI],"@R 99:99"),;	//Hora inicio
							Transform(aAlvos[oListAlvos:nAt,nAHORFIM],"@R 99:99"),;	//Hora fim
							aAlvos[oListAlvos:nAt,nACLINOM],;							//Nome
							aAlvos[oListAlvos:nAt,nAULTOCO],;							//Ultima Ocorr�ncia
							aAlvos[oListAlvos:nAt,nACLIEND],;							//Endere�o
							aAlvos[oListAlvos:nAt,nACLIBAI],;							//Bairro
							aAlvos[oListAlvos:nAt,nACLIMUN],;							//Municipio
							aAlvos[oListAlvos:nAt,nACLIEST],;							//Estado
							aAlvos[oListAlvos:nAt,nAULTEVE],;							//Ultimo Evento
							aAlvos[oListAlvos:nAt,nAULTRMA],;							//Ultimo RMA
							""}}														//Espa�o para que a tela fique mais bonita.
							
	oListAlvos:bLDblClick := {|| aAlvos[oListAlvos:nAt, nAMARCA] := !aAlvos[oListAlvos:nAt, nAMARCA] }
	//������������������������������������������������������������������Ŀ
	//�Lista de alvos - FIM                                              �
	//��������������������������������������������������������������������	
	ACTIVATE MSDIALOG oDlg on Init ENCHOICEBAR(oDlg, {|| If (fAlvosVld(nEvento, aAlvos),(oDlg:End(), nOpcA := 1, lRet := .T.),) } , {|| lRet := .F., oDlg:End() },,aButtons) 
	If lRet .And. nOpcA == 1
		fGrvEventos(nRecDTQ, aAlvos, nEvento, dDatAlvo, StrTran(cHorAlvo, ":", ""))
	EndIf
EndIf

RestArea(aAreaDTQ)
RestArea(aArea)

Return lRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGetAlvos �Autor  � Vin�cius Moreira   � Data � 02/09/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega documentos que ser�o exibidos na tela de inclus�o  ���
���          � de eventos.                                                ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetAlvos(cFilVia, cNumVia, cSerTms)

Local cQuery    := ""
Local cAliasQry := GetNextAlias()
Local aRet      := {}
Local cUltOco   := ""
Local aAux      := {}
Local nStatus   := 0
Local aForaPrz  := {}

cQuery += "  SELECT " + CRLF
cQuery += "    DUD.DUD_FILDOC DOCFIL " + CRLF
cQuery += "   ,DUD.DUD_DOC DOCNUM " + CRLF
cQuery += "   ,DUD.DUD_SERIE DOCSER " + CRLF
cQuery += "   ,DT6.R_E_C_N_O_ RECDT6 " + CRLF
//������������������������������������������������������������������Ŀ
//�Coleta                                                            �
//��������������������������������������������������������������������
If cSerTms == "1"
	cQuery += "   ,DUE.DUE_NOME CLINOM " + CRLF
	cQuery += "   ,DUE.DUE_END CLIEND " + CRLF
	cQuery += "   ,DUE.DUE_BAIRRO CLIBAI " + CRLF
	cQuery += "   ,DUE.DUE_MUN CLIMUN " + CRLF
	cQuery += "   ,DUE.DUE_EST CLIEST " + CRLF
	cQuery += "   ,DT5.DT5_HORPRV HORINI " + CRLF
	cQuery += "   ,DT5.DT5_HORPRV HORFIM " + CRLF
//������������������������������������������������������������������Ŀ
//�Entrega/Transfer�ncia                                             �
//��������������������������������������������������������������������
Else
	cQuery += "   ,SA1.A1_NOME CLINOM " + CRLF
	cQuery += "   ,SA1.A1_END CLIEND " + CRLF
	cQuery += "   ,SA1.A1_BAIRRO CLIBAI " + CRLF
	cQuery += "   ,SA1.A1_MUN CLIMUN " + CRLF
	cQuery += "   ,SA1.A1_EST CLIEST " + CRLF	
	cQuery += "   ,DTR.DTR_HORINI HORINI " + CRLF
	cQuery += "   ,DTR.DTR_HORFIM HORFIM " + CRLF	
EndIf
//��������������������������������������������������������������������������������Ŀ
//�Viagem                                                                          �
//����������������������������������������������������������������������������������	
cQuery += " FROM " + RetSqlName("DTQ") + " DTQ " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Veiculos da Viagem                                                              �
//����������������������������������������������������������������������������������
cQuery += " INNER JOIN " + RetSqlName("DTR") + " DTR ON " + CRLF
cQuery += "       DTR.DTR_FILIAL = '" + xFilial("DTR") + "' " + CRLF
cQuery += "   AND DTR.DTR_FILORI = DTQ.DTQ_FILORI " + CRLF
cQuery += "   AND DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM " + CRLF
cQuery += "   AND DTR.DTR_ITEM   = '" + StrZero(1,TamSx3("DTR_ITEM")[1]) + "' " + CRLF
cQuery += "   AND DTR.D_E_L_E_T_ = ' ' " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Movimento de Viagem                                                             �
//����������������������������������������������������������������������������������
cQuery += " INNER JOIN " + RetSqlName("DUD") + " DUD ON " + CRLF
cQuery += "       DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF
cQuery += "   AND DUD.DUD_FILORI = DTQ.DTQ_FILORI " + CRLF
cQuery += "   AND DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM " + CRLF
cQuery += "   AND DUD.DUD_SERTMS = DTQ.DTQ_SERTMS " + CRLF
cQuery += "   AND DUD.DUD_TIPTRA = DTQ.DTQ_TIPTRA " + CRLF
cQuery += "   AND DUD.D_E_L_E_T_ = ' ' " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Documentos de Transporte                                                        �
//����������������������������������������������������������������������������������
cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 ON " + CRLF
cQuery += "       DT6.DT6_FILIAL = '" + xFilial("DT6") + "' " + CRLF
cQuery += "   AND DT6.DT6_FILDOC = DUD.DUD_FILDOC " + CRLF
cQuery += "   AND DT6.DT6_DOC    = DUD.DUD_DOC " + CRLF
cQuery += "   AND DT6.DT6_SERIE  = DUD.DUD_SERIE " + CRLF
cQuery += "   AND DT6.D_E_L_E_T_ = ' ' " + CRLF
//��������������������������������������������������������������������������������Ŀ
//�Registro de Ocorr�ncias                                                         �
//����������������������������������������������������������������������������������
cQuery += " LEFT OUTER JOIN " + RetSqlName("DUA") + " DUA ON " + CRLF
cQuery += "       DUA.DUA_FILIAL = '" + xFilial("DUA") + "' " + CRLF
cQuery += "   AND DUA.DUA_FILDOC = DUD.DUD_FILDOC " + CRLF
cQuery += "   AND DUA.DUA_DOC    = DUD.DUD_DOC " + CRLF
cQuery += "   AND DUA.DUA_SERIE  = DUD.DUD_SERIE " + CRLF
cQuery += "   AND DUA.DUA_FILORI = DUD.DUD_FILORI " + CRLF
cQuery += "   AND DUA.DUA_VIAGEM = DUD.DUD_VIAGEM " + CRLF
cQuery += "   AND DUA.D_E_L_E_T_ = ' ' " + CRLF
//������������������������������������������������������������������Ŀ
//�Coleta                                                            �
//��������������������������������������������������������������������
If cSerTms == "1"
	//��������������������������������������������������������������������������������Ŀ
	//�Solicitacao de Coleta                                                           �
	//����������������������������������������������������������������������������������	
	cQuery += " INNER JOIN " + RetSqlName("DT5") + " DT5 ON " + CRLF
	cQuery += "       DT5.DT5_FILIAL = DT6.DT6_FILDOC " + CRLF
	cQuery += "   AND DT5.DT5_FILDOC = DT6.DT6_FILDOC " + CRLF
	cQuery += "   AND DT5.DT5_DOC    = DT6.DT6_DOC " + CRLF
	cQuery += "   AND DT5.DT5_SERIE  = DT6.DT6_SERIE " + CRLF
	cQuery += "   AND DT5.D_E_L_E_T_ = ' ' " + CRLF
	//��������������������������������������������������������������������������������Ŀ
	//�Cadastro de Solicitantes                                                        �
	//����������������������������������������������������������������������������������
	cQuery += " INNER JOIN " + RetSqlName("DUE") + " DUE ON " + CRLF
	cQuery += "       DUE.DUE_FILIAL = '" + xFilial("DUE") + "' " + CRLF
	cQuery += "   AND DUE.DUE_DDD    = DT5.DT5_DDD " + CRLF
	cQuery += "   AND DUE.DUE_TEL    = DT5.DT5_TEL " + CRLF
	cQuery += "   AND DUE.D_E_L_E_T_ = ' ' " + CRLF
//������������������������������������������������������������������Ŀ
//�Entrega/Transfer�ncia                                             �
//��������������������������������������������������������������������
Else
	//��������������������������������������������������������������������������������Ŀ
	//�Cadastro de clientes                                                            �
	//����������������������������������������������������������������������������������
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON " + CRLF
	cQuery += "       SA1.A1_FILIAL  = '" + xFilial("SA1") + "' " + CRLF
	cQuery += "   AND SA1.A1_COD     = DT6.DT6_CLIDES " + CRLF
	cQuery += "   AND SA1.A1_LOJA    = DT6.DT6_LOJDES " + CRLF
	cQuery += "   AND SA1.D_E_L_E_T_ = ' ' " + CRLF
EndIf
//��������������������������������������������������������������������������������Ŀ
//�Viagem                                                                          �
//����������������������������������������������������������������������������������
cQuery += " WHERE DTQ.DTQ_FILIAL = '" + xFilial("DUD") + "' " + CRLF
cQuery += "   AND DTQ.DTQ_FILORI = '" + cFilVia + "' " + CRLF
cQuery += "   AND DTQ.DTQ_VIAGEM = '" + cNumVia + "' " + CRLF
cQuery += "   AND DTQ.D_E_L_E_T_ = ' ' " + CRLF

cQuery += "  GROUP BY " + CRLF
cQuery += "    DUD.DUD_FILDOC " + CRLF
cQuery += "   ,DUD.DUD_DOC " + CRLF
cQuery += "   ,DUD.DUD_SERIE " + CRLF
cQuery += "   ,DT6.R_E_C_N_O_ " + CRLF
//������������������������������������������������������������������Ŀ
//�Coleta                                                            �
//��������������������������������������������������������������������
If cSerTms == "1"
	cQuery += "   ,DUE.DUE_NOME " + CRLF
	cQuery += "   ,DUE.DUE_END " + CRLF
	cQuery += "   ,DUE.DUE_BAIRRO " + CRLF
	cQuery += "   ,DUE.DUE_MUN " + CRLF
	cQuery += "   ,DUE.DUE_EST " + CRLF
	cQuery += "   ,DT5.DT5_HORPRV " + CRLF
	cQuery += "  ORDER BY " + CRLF
	cQuery += "    DUE.DUE_END " + CRLF
	cQuery += "   ,DUE.DUE_BAIRRO " + CRLF
	cQuery += "   ,DUE.DUE_MUN " + CRLF
	cQuery += "   ,DUE.DUE_EST " + CRLF
//������������������������������������������������������������������Ŀ
//�Entrega/Transfer�ncia                                             �
//��������������������������������������������������������������������
Else
	cQuery += "   ,SA1.A1_NOME " + CRLF
	cQuery += "   ,SA1.A1_END " + CRLF
	cQuery += "   ,SA1.A1_BAIRRO " + CRLF
	cQuery += "   ,SA1.A1_MUN " + CRLF
	cQuery += "   ,SA1.A1_EST " + CRLF	
	cQuery += "   ,DTR.DTR_HORINI " + CRLF
	cQuery += "   ,DTR.DTR_HORFIM " + CRLF	
	cQuery += "  ORDER BY " + CRLF
	cQuery += "    SA1.A1_END " + CRLF
	cQuery += "   ,SA1.A1_BAIRRO " + CRLF
	cQuery += "   ,SA1.A1_MUN " + CRLF
	cQuery += "   ,SA1.A1_EST " + CRLF	
EndIf

cQuery += "   ,DUD.DUD_FILDOC " + CRLF
cQuery += "   ,DUD.DUD_DOC " + CRLF
cQuery += "   ,DUD.DUD_SERIE " + CRLF

MemoWrite("\RGEFM02_ALVOS.TXT",cQuery)

cQuery := ChangeQuery(cQuery)

If fDoQuery(cQuery, @cAliasQry)
	While (cAliasQry)->(!Eof())	
		//������������������������������������������������������������������Ŀ
		//�Busca informa��o da ultima ocorr�ncia                             �
		//��������������������������������������������������������������������
		aAux := fGetUltOco (cFilVia, cNumVia, (cAliasQry)->DOCFIL, (cAliasQry)->DOCNUM, (cAliasQry)->DOCSER)
		If Len(aAux) > 0
			cUltOco := dToC(aAux[1,nUDATOCO]) + " - " + Transform(aAux[1,nUHOROCO], "@R 99:99") + " / " + aAux[1,nUCODOCO] + " - " + aAux[1,nUDESOCO]
		EndIf
		
		aForaPrz := fChkJanelas (	2,; 
									cSerTms,;
									"",;
									"",;
									(cAliasQry)->DOCFIL,;
									(cAliasQry)->DOCNUM,;
									(cAliasQry)->DOCSER)
									
		If aForaPrz[1]
			nStatus := nLALVFORA
		Else
			nStatus := nLALVOK
		EndIf
			
		aAdd(aRet,{	.F.,;							//01 - Marca
					(cAliasQry)->DOCFIL,;			//02 - Filial do documento
					(cAliasQry)->DOCNUM,;			//03 - N�mero do documento
					(cAliasQry)->DOCSER,;			//04 - Serie do documento
					(cAliasQry)->RECDT6,;			//05 - Recno DT6 
					(cAliasQry)->CLINOM,;			//06 - Nome
					(cAliasQry)->CLIEND,;			//07 - Endereco
					(cAliasQry)->CLIBAI,;			//08 - Bairro
					(cAliasQry)->CLIMUN,;			//09 - Municipio
					(cAliasQry)->CLIEST,;			//10 - Estado
					cUltOco,;						//11 - Ultima Ocorr�ncia
					fGetUltEve (cFilVia, cNumVia,(cAliasQry)->DOCFIL, (cAliasQry)->DOCNUM, (cAliasQry)->DOCSER),;			//12 - Ultimo Evento
					fGetUltRMA (cFilVia, cNumVia,(cAliasQry)->DOCFIL, (cAliasQry)->DOCNUM, (cAliasQry)->DOCSER),;			//13 - Ultimo RMA
					(cAliasQry)->HORINI,;			//14 - Hora inicio
					(cAliasQry)->HORFIM,;			//15 - Hora fim
					nStatus,;						//16 - Status					
		})
		
		cUltOco := ""
		(cAliasQry)->(dbSkip())
	EndDo
EndIf
(cAliasQry)->(dbCloseArea())

Return aRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RGEFM02B  �Autor  � Vin�cius Moreira   � Data � 07/09/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza chamada da fun��o do padr�o para apontamento e     ���
���          � estorno das ocorr�ncias da viagem.                         ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xRGEFM02B(cAlias, nTmsRec, nOpc)

Local lRet := .F.

If nOpc == 3
	lRet := TMSA360Mnt(cAlias, 0, nOpc, DTQ->DTQ_FILORI, DTQ->DTQ_VIAGEM)
Else
	Inclui := .F.
	lRet := TMSA360Mnt(cAlias, DUA->(Recno()), nOpc )
EndIf

Return( lRet )
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fAlvosVld�Autor  � Vin�cius Moreira   � Data � 07/09/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida sele��o de documentos para lan�amento de eventos.   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fAlvosVld(nEvento, aAlvos)

Local lRet    := .T.
Local nX      := 0
Local nMarks  := 0
Local cCodOco := ""

If nEvento == 0
	lRet := .F.
	Help (" ", 1, "RGEFM0204",,"Nenhum evento selecionado.", 3, 0)
Else
	For nX := 1 to Len(aAlvos)
		If aAlvos[nX, nAMARCA]
			nMarks++
		EndIf
	Next nX
	
	If nMarks == 0
		lRet := .F.
		Help (" ", 1, "RGEFM0203",,"Nenhum documento foi marcado.", 3, 0)
	EndIf
EndIf

If lRet
	If DTQ->DTQ_SERTMS == "1"
		cCodOco := aOcoVCOL[nEvento]
	Else
		cCodOco := aOcoVENT[nEvento]
	EndIf
	//�������������������������������������������������������������������Ŀ
	//�Se ocorr�ncia Outros, abre tela para escolha da ocorr�ncia correta.�
	//���������������������������������������������������������������������
	If cCodOco == cOcoOutros
		cOcoSel := ""
		If !fOcoOutros()
			Help (" ", 1, "RGEFM0207",,"Nenhuma ocorr�ncia selecionada.", 3, 0)
			lRet := .F.
		EndIf
		/*
		While ConPad1(,,,"DT2")
			If DT2->DT2_SERTMS == DTQ->DTQ_SERTMS
				cOcoSel := DT2->DT2_CODOCO
				Exit
			Else
				Help (" ", 1, "RGEFM0206",,"Selecione ocorr�ncia de servi�o de transporte igual ao da viagem.", 3, 0)
				lRet := .F.
			EndIf
		EndDo
		If Empty(cOcoSel)
			Help (" ", 1, "RGEFM0207",,"Nenhuma ocorr�ncia selecionada.", 3, 0)
			lRet := .F.
		EndIf
		*/
	EndIf
EndIf

Return lRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGrvEventos�Autor � Vin�cius Moreira   � Data � 07/09/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza a grava��o dos eventos na viagem.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGrvEventos(nRecDTQ, aAlvos, nEvento, dDatOco, cHorOco)

Local aArea    := GetArea()
Local aAreaDTQ := DTQ->(GetArea())
Local aAreaDUA := DUA->(GetArea())
Local aAreaDT6 := DT6->(GetArea())
Local aAreaDT2 := DT2->(GetArea())
Local aCabDUA  := {}
Local aIteDUA  := {}      
Local aItensDUA:= {}
Local nX       := 0
Local cCodOco  := ""
Local lPorVia  := .F.
Local cFilBkp  := cFilAnt

Private INCLUI      := .T.
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

DT6->(dbSetOrder(1))//DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
//������������������������������������������������������������������Ŀ
//�Posicionando viagem.                                              �
//��������������������������������������������������������������������
DTQ->(dbGoTo(nRecDTQ))
cFilAnt := DTQ->DTQ_FILDES

If DTQ->DTQ_SERTMS == "1"
	cCodOco := aOcoVCOL[nEvento]
Else
	cCodOco := aOcoVENT[nEvento]
EndIf

If cCodOco == cOcoOutros
	cCodOco := cOcoSel
EndIf
//������������������������������������������������������������������Ŀ
//�Checa se ocorr�ncia � lan�ada por viagem.                         �
//��������������������������������������������������������������������
lPorVia := Posicione("DT2", 1, xFilial("DT2")+cCodOco, "DT2_CATOCO") == "2"
//������������������������������������������������������������������Ŀ
//�Monta vetor do cabe�alho das ocorr�ncias.                         �
//��������������������������������������������������������������������
aAdd(aCabDUA, {"DUA_FILORI", DTQ->DTQ_FILORI, Nil})
aAdd(aCabDUA, {"DUA_VIAGEM", DTQ->DTQ_VIAGEM, Nil})
//������������������������������������������������������������������Ŀ
//�Caloca vetor em ordem de numero de documentos.                    �
//��������������������������������������������������������������������
aSort (aAlvos,,, { |x, y| ( x[nADOCFIL]+x[nADOCNUM]+x[nADOCSER] ) < ( y[nADOCFIL]+y[nADOCNUM]+y[nADOCSER] ) })
For nX := 1 to Len(aAlvos)
	//������������������������������������������������������������������Ŀ
	//�Se documento esta marcado ou ocorr�ncia por viagem.               �
	//��������������������������������������������������������������������
	If aAlvos[nX, nAMARCA] .Or. lPorVia
		//������������������������������������������������������������������Ŀ
		//�Posicionando documento.                                           �
		//��������������������������������������������������������������������
		DT6->(dbSeek(xFilial("DT6")+aAlvos[nX, nADOCFIL]+aAlvos[nX, nADOCNUM]+aAlvos[nX, nADOCSER]))
		//������������������������������������������������������������������Ŀ
		//�Monta vetor com o itens da ocorr�ncia.                            �
		//��������������������������������������������������������������������
		aIteDUA := {	{"DUA_DATOCO"	, dDatOco			, Nil},;
						{"DUA_HOROCO"	, cHorOco			, Nil},;
						{"DUA_CODOCO"	, cCodOco			, Nil}}
		/*
		If lPorVia
			aAdd(aIteDUA, {"DUA_FILDOC"	, "", Nil})
			aAdd(aIteDUA, {"DUA_DOC"	, "", Nil})
			aAdd(aIteDUA, {"DUA_SERIE"	, "", Nil})
			aAdd(aIteDUA, {"DUA_QTDVOL"	, 0	, Nil})
			aAdd(aIteDUA, {"DUA_PESO"	, 0	, Nil})
			//������������������������������������������������������������������Ŀ
			//�Quando coleta preenche o peso e quantidade de ocorr�ncia.         �
			//��������������������������������������������������������������������
			If DTQ->DTQ_SERTMS == "1"
				aAdd(aIteDUA, {"DUA_QTDOCO", 1,NIL})
				aAdd(aIteDUA, {"DUA_PESOCO", 1,NIL})
			EndIf
		Else
		*/
			aAdd(aIteDUA, {"DUA_FILDOC"	, DT6->DT6_FILDOC	, Nil})
			aAdd(aIteDUA, {"DUA_DOC"	, DT6->DT6_DOC		, Nil})
			aAdd(aIteDUA, {"DUA_SERIE"	, DT6->DT6_SERIE	, Nil})
			aAdd(aIteDUA, {"DUA_QTDVOL"	, DT6->DT6_QTDVOL	, Nil})
			aAdd(aIteDUA, {"DUA_PESO"	, DT6->DT6_PESO		, Nil})
			If DTQ->DTQ_SERTMS == "1"
				aAdd(aIteDUA, {"DUA_QTDOCO", If(DT6->DT6_QTDVOL == 0	,1,DT6->DT6_QTDVOL),NIL})
				aAdd(aIteDUA, {"DUA_PESOCO", If(DT6->DT6_PESO == 0		,1,DT6->DT6_PESO)	,NIL})
			EndIf
		//EndIf
		
		aAdd(aItensDUA, aClone(aIteDUA))
		//������������������������������������������������������������������Ŀ
		//�Se ocorr�ncia lan�ada por viagem, basta lan�ar ocorr�ncia para um �
		//�documento.                                                        �
		//��������������������������������������������������������������������
		If lPorVia
			Exit
		EndIf
	EndIf
Next nX

//-- Inclusao da Ocorrencia
SetFunName("TMSA360")
MsExecAuto({|x,y,z,w| TMSA360(x,y,z,w)}, aCabDUA, aItensDUA, , 3)
If lMsErroAuto
	MostraErro()
EndIf
SetFunName("RGEFM02")
lMsErroAuto := .F.

cFilAnt := cFilBkp

RestArea(aAreaDT2)
RestArea(aAreaDT6)
RestArea(aAreaDUA)
RestArea(aAreaDTQ)
RestArea(aArea)

Return 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGetExceDoc�Autor � Vin�cius Moreira   � Data � 08/08/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca tempo limite para exceder inicio de descarga.        ���
���          �  1 - Retorna tempo para descarga no cliente.               ���
���          �  2 - Retorna tempo para chegada no cliente.                ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetExceDoc(nOpcao, cDocFil, cDocNum, cDocSer, cSerTms)

Local aArea    := GetArea()
Local aAreaDT6 := DT6->(GetArea())
Local aAreaDT5 := DT5->(GetArea())
Local nRet     := 0

If cSerTms == "1"
	DT5->(dbSetOrder(4))//DT5_FILIAL+DT5_FILDOC+DT5_DOC+DT5_SERIE
	If DT5->(dbSeek(cDocFil+cDocFil+cDocNum+cDocSer))
		DUE->(dbSetOrder(1))//DUE_FILIAL+DUE_DDD+DUE_TEL
		If DUE->(dbSeek(xFilial("DUE")+DT5->(DT5_DDD+DT5_TEL)))
			SA1->(dbSetOrder(1))//A1_FILIAL+A1_COD+A1_LOJA
			If !Empty(DUE->DUE_CODCLI) .And. !Empty(DUE->DUE_LOJCLI) .And. SA1->(dbSeek(xFilial("SA1")+DUE->(DUE_CODCLI+DUE_LOJCLI)))
				If nOpcao == 1
					nRet := Val(SA1->A1_XLONG)/100*-1
				Else
					nRet := Val(SA1->A1_XLATIT)/100
				EndIf
			EndIf
		EndIf
	EndIf
Else
	DT6->(dbSetOrder(1))//DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
	If DT6->(dbSeek(xFilial("DT6")+cDocFil+cDocNum+cDocSer))
		SA1->(dbSetOrder(1))//A1_FILIAL+A1_COD+A1_LOJA
		If SA1->(dbSeek(xFilial("SA1")+DT6->(DT6_CLIDES+DT6_LOJDES)))
			If nOpcao == 1
				nRet := Val(SA1->A1_XLONG)/100*-1
			Else
				nRet := Val(SA1->A1_XLATIT)/100
			EndIf
		EndIf
	EndIf
EndIf

If nRet == 0 
	If nOpcao == 1
		nRet := SuperGetMv("ES_GEFM02D",,01.00)*-1
	Else
		nRet := SuperGetMv("ES_GEFM02E",,01.00)
	EndIf
EndIf

RestArea(aAreaDT5)
RestArea(aAreaDT6)
RestArea(aArea)

Return nRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fGetDocs �Autor  � Vin�cius Moreira   � Data � 09/12/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca documentos da viagem para exibi��o.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetDocs (cNumVia, cSerTms, _cFilial)

Local aRet      := {}
Local cQuery    := ""
Local cAliasQry := GetNextAlias()

cQuery += " SELECT " + CRLF 
cQuery += "   DUD.DUD_FILDOC " + CRLF 
cQuery += "  ,DUD.DUD_DOC " + CRLF 
cQuery += "  ,DUD.DUD_SERIE " + CRLF 
cQuery += "  ,SA1REM.A1_NOME REMNOM " + CRLF 
cQuery += "  ,SA1REM.A1_MUN  REMMUN " + CRLF 
cQuery += "  ,SA1REM.A1_EST  REMEST " + CRLF 
cQuery += "  ,DF1.DF1_DATPRC DATPRC " + CRLF 
cQuery += "  ,DF1.DF1_HORPRC HORPRC " + CRLF 
cQuery += "  ,DF1.DF1_XDTPSC XDTPSC " + CRLF 
cQuery += "  ,DF1.DF1_XHRPSC XHRPSC" + CRLF 
cQuery += "  ,DF1.DF1_DATPRE DATPRE" + CRLF 
cQuery += "  ,DF1.DF1_HORPRE HORPRE" + CRLF 
cQuery += "  ,DF1.DF1_XDTPEN XDTPEN " + CRLF 
cQuery += "  ,DF1.DF1_XHRPEN XHRPEN" + CRLF 
cQuery += "  ,DF1.DF1_DEST DESTINO" + CRLF 
cQuery += "  ,SA1DES.A1_NOME DESNOM " + CRLF 
cQuery += "  ,SA1DES.A1_MUN  DESMUN " + CRLF 
cQuery += "  ,SA1DES.A1_EST  DESEST " + CRLF 
cQuery += "  ,DF0.DF0_XDTAGE XDTAGE " + CRLF 
cQuery += "  ,DF0.DF0_XHRAGE XHRAGE " + CRLF 
cQuery += "  FROM " + RetSqlName("DUD") + " DUD " + CRLF 
//����������������������������������������������������������������������Ŀ
//�Coleta                                                                �
//������������������������������������������������������������������������
// aViagens[oListVia:nAt,nVFILIAL]
If cSerTms == "1"
	cQuery += " INNER JOIN " + RetSqlName("DT5") + " DT5 ON " + CRLF 
//	cQuery += "       DT5.DT5_FILIAL = '" + xFilial("DT5") + "' " + CRLF 		
	cQuery += "       DT5.DT5_FILIAL = '" + IIF(_cFilial == Nil, aViagens[oListVia:nAt,nVFILIAL], _cFilial) +"' " + CRLF
	cQuery += "   AND DT5.DT5_FILDOC = '" + IIF(_cFilial == Nil, aViagens[oListVia:nAt,nVFILIAL], _cFilial) +"' " + CRLF 	 // DUD.DUD_FILDOC " + CRLF 	
	cQuery += "   AND DT5.DT5_FILDOC = DUD.DUD_FILDOC " + CRLF 
	cQuery += "   AND DT5.DT5_DOC    = DUD.DUD_DOC " + CRLF 
	cQuery += "   AND DT5.DT5_SERIE  = DUD.DUD_SERIE " + CRLF 
	cQuery += "   AND DT5.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " INNER JOIN " + RetSqlName("DUE") + " DUE ON " + CRLF
	cQuery += "       DUE.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "   AND DUE.DUE_FILIAL = '" + xFilial("DUE") + "' " + CRLF
	cQuery += "   AND DUE.DUE_DDD    = DT5.DT5_DDD " + CRLF
	cQuery += "   AND DUE.DUE_TEL    = DT5.DT5_TEL " + CRLF
/* Por: Ricardo Guimar�es - Em: 24/02/2016 - Passar a pegar o cliente a partir do DF1 
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1REM ON " + CRLF 
	cQuery += "       SA1REM.A1_FILIAL  = '" + xFilial("SA1") + "' " + CRLF 
	cQuery += "   AND SA1REM.A1_COD     = DUE.DUE_CODCLI " + CRLF 
	cQuery += "   AND SA1REM.A1_LOJA    = DUE.DUE_LOJCLI " + CRLF 
	cQuery += "   AND SA1REM.D_E_L_E_T_ = ' ' " + CRLF 
*/
	cQuery += " LEFT OUTER JOIN " + RetSqlName("SA1") + " SA1DES ON " + CRLF 
	cQuery += "       SA1DES.A1_FILIAL  = '" + xFilial("SA1") + "' " + CRLF 
	cQuery += "   AND SA1DES.A1_COD     = DT5.DT5_CLIDES " + CRLF 
	cQuery += "   AND SA1DES.A1_LOJA    = DT5.DT5_LOJDES " + CRLF 
	cQuery += "   AND SA1DES.D_E_L_E_T_ = ' ' " + CRLF 
//����������������������������������������������������������������������Ŀ
//�Entrega\Transfer�ncia                                                 �
//������������������������������������������������������������������������
Else
	cQuery += " INNER JOIN " + RetSqlName("DT6") + " DT6 ON " + CRLF 
//	cQuery += "       DT6.DT6_FILIAL = '" + xFilial("DT6") + "' " + CRLF 
	cQuery += "       DT6.DT6_FILIAL = '" + IIF(_cFilial == Nil, aViagens[oListVia:nAt,nVFILIAL], _cFilial) +"' " + CRLF	
//	cQuery += "   AND DT6.DT6_FILDOC =  '" + aViagens[oListVia:nAt,nVFILIAL] +"' " + CRLF 	 // DUD.DUD_FILDOC " + CRLF 
	cQuery += "   AND DT6.DT6_FILDOC =  '" + IIF(_cFilial == Nil, aViagens[oListVia:nAt,nVFILIAL], _cFilial) + "' " + CRLF 	 // DUD.DUD_FILDOC " + CRLF 
	cQuery += "   AND DT6.DT6_FILDOC = DUD.DUD_FILDOC " + CRLF 	
	cQuery += "   AND DT6.DT6_DOC    = DUD.DUD_DOC " + CRLF 
	cQuery += "   AND DT6.DT6_SERIE  = DUD.DUD_SERIE " + CRLF 
	cQuery += "   AND DT6.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1REM ON " + CRLF 
	cQuery += "       SA1REM.A1_FILIAL  = '" + xFilial("SA1") + "' " + CRLF 
	cQuery += "   AND SA1REM.A1_COD     = DT6.DT6_CLIREM " + CRLF 
	cQuery += "   AND SA1REM.A1_LOJA    = DT6.DT6_LOJREM " + CRLF 
	cQuery += "   AND SA1REM.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " LEFT OUTER JOIN " + RetSqlName("SA1") + " SA1DES ON " + CRLF 
	cQuery += "       SA1DES.A1_FILIAL  = '" + xFilial("SA1") + "' " + CRLF 
	cQuery += "   AND SA1DES.A1_COD     = DT6.DT6_CLIDES " + CRLF 
	cQuery += "   AND SA1DES.A1_LOJA    = DT6.DT6_LOJDES " + CRLF 
	cQuery += "   AND SA1DES.D_E_L_E_T_ = ' ' " + CRLF 
EndIf
cQuery += " LEFT OUTER JOIN " + RetSqlName("DF1") + " DF1 ON " + CRLF 
cQuery += "       DF1.DF1_FILIAL = '" + xFilial("DF1") + "' " + CRLF 
cQuery += "   AND DF1.DF1_FILDOC =  '" + IIF(_cFilial == Nil, aViagens[oListVia:nAt,nVFILIAL], _cFilial) +"' " + CRLF 	 // DUD.DUD_FILDOC " + CRLF 
cQuery += "   AND DF1.DF1_DOC    = DUD.DUD_DOC " + CRLF 
cQuery += "   AND DF1.DF1_SERIE  = DUD.DUD_SERIE " + CRLF 
cQuery += "   AND DF1.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += " LEFT OUTER JOIN " + RetSqlName("DF0") + " DF0 ON " + CRLF 
cQuery += "       DF0.DF0_FILIAL = DF1.DF1_FILIAL " + CRLF 
cQuery += "   AND DF0.DF0_NUMAGE = DF1.DF1_NUMAGE " + CRLF 
cQuery += "   AND DF0.D_E_L_E_T_ = ' ' " + CRLF

// Por: Ricardo Guimar�es - Passar cliente na tabela DF1 
If cSerTms == "1"
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1REM ON " + CRLF 
	cQuery += "       SA1REM.A1_FILIAL  = '" + xFilial("SA1") + "' " + CRLF 
	cQuery += "   AND SA1REM.A1_COD     = DF1.DF1_CLIREM " + CRLF 
	cQuery += "   AND SA1REM.A1_LOJA    = DF1.DF1_LOJREM " + CRLF 
	cQuery += "   AND SA1REM.D_E_L_E_T_ = ' ' " + CRLF
 EndIf
 
cQuery += " WHERE DUD.DUD_FILIAL = '" + xFilial("DUD") + "' " + CRLF 
cQuery += "   AND DUD.DUD_VIAGEM = '" + cNumVia + "' " + CRLF 
cQuery += "   AND DUD.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += " GROUP BY " + CRLF 
cQuery += "   DUD.DUD_FILDOC " + CRLF 
cQuery += "  ,DUD.DUD_DOC " + CRLF 
cQuery += "  ,DUD.DUD_SERIE " + CRLF 
cQuery += "  ,SA1REM.A1_NOME " + CRLF 
cQuery += "  ,SA1REM.A1_MUN  " + CRLF 
cQuery += "  ,SA1REM.A1_EST  " + CRLF 
cQuery += "  ,DF1.DF1_DATPRC " + CRLF 
cQuery += "  ,DF1.DF1_HORPRC " + CRLF 
cQuery += "  ,DF1.DF1_XDTPSC " + CRLF 
cQuery += "  ,DF1.DF1_XHRPSC " + CRLF 
cQuery += "  ,DF1.DF1_DATPRE " + CRLF 
cQuery += "  ,DF1.DF1_HORPRE " + CRLF 
cQuery += "  ,DF1.DF1_XDTPEN " + CRLF 
cQuery += "  ,DF1.DF1_XHRPEN " + CRLF 
cQuery += "  ,SA1DES.A1_NOME " + CRLF 
cQuery += "  ,SA1DES.A1_MUN  " + CRLF 
cQuery += "  ,SA1DES.A1_EST  " + CRLF 
cQuery += "  ,DF1.DF1_DEST   " + CRLF 
cQuery += "  ,DF0.DF0_XDTAGE " + CRLF 
cQuery += "  ,DF0.DF0_XHRAGE " + CRLF 
cQuery += " ORDER BY " + CRLF 
cQuery += "   DUD.DUD_FILDOC " + CRLF 
cQuery += "  ,DUD.DUD_DOC " + CRLF 
cQuery += "  ,DUD.DUD_SERIE " + CRLF 
cQuery := ChangeQuery(cQuery)

MemoWrite("D:\TEMP\RGEFM02_DOCS.TXT",cQuery)

fDoQuery(cQuery, @cAliasQry)

TcSetField(cAliasQry,"XDTPSC",TamSx3("DF1_XDTPSC")[3],TamSx3("DF1_XDTPSC")[1],TamSx3("DF1_XDTPSC")[2])
TcSetField(cAliasQry,"DATPRE",TamSx3("DF1_DATPRE")[3],TamSx3("DF1_DATPRE")[1],TamSx3("DF1_DATPRE")[2])
TcSetField(cAliasQry,"XDTPEN",TamSx3("DF1_XDTPEN")[3],TamSx3("DF1_XDTPEN")[1],TamSx3("DF1_XDTPEN")[2])
TcSetField(cAliasQry,"DATPRC",TamSx3("DF1_DATPRC")[3],TamSx3("DF1_DATPRC")[1],TamSx3("DF1_DATPRC")[2])
TcSetField(cAliasQry,"XDTAGE",TamSx3("DF0_XDTAGE")[3],TamSx3("DF0_XDTAGE")[1],TamSx3("DF0_XDTAGE")[2])

If (cAliasQry)->(Eof())
	aAdd(aRet, {	(cAliasQry)->DUD_FILDOC,;															//01 - Filial Documento
					(cAliasQry)->DUD_DOC,;																//02 - N�mero Documento
					(cAliasQry)->DUD_SERIE,;															//03 - Serie Documento
					(cAliasQry)->REMNOM,;																//04 - Nome Rementente
					(cAliasQry)->REMMUN,;																//05 - Municipio Rementente
					(cAliasQry)->REMEST,;																//06 - Estado Rementente
					(cAliasQry)->XDTPSC,;																//07 - Data Previs�o de Saida pra Coleta
					(cAliasQry)->XHRPSC,;																//08 - Hora Previs�o de Saida pra Coleta
					(cAliasQry)->DESTINO,;																//09 - Destino					
					(cAliasQry)->DESNOM,;																//10 - Nome Destinat�rio
					(cAliasQry)->DESMUN,;																//11 - Municipio Destanat�rio
					(cAliasQry)->DESEST,;																//12 - Estado Destinat�rio 
					(cAliasQry)->DATPRC,;																//13 - Data Previs�o de Coleta
					(cAliasQry)->HORPRC,;																//14 - Hora Previs�o de Coleta
					(cAliasQry)->DATPRE,;																//15 - Data Previs�o de Entrega
					(cAliasQry)->HORPRE,;																//16 - Hora Previs�o de Entrega
					If(!Empty((cAliasQry)->XDTAGE), (cAliasQry)->XDTAGE, (cAliasQry)->XDTPEN),;		//17 - Data Previs�o de Entrega Real
					If(!Empty((cAliasQry)->XHRAGE), (cAliasQry)->XHRAGE, (cAliasQry)->XHRPEN),;		//18 - Hora Previs�o de Entrega Real
					"",;																				//19 - Espa�o
					})	
Else		
	While (cAliasQry)->(!Eof())
		aAdd(aRet, {	(cAliasQry)->DUD_FILDOC,;															//01 - Filial Documento
						(cAliasQry)->DUD_DOC,;																//02 - N�mero Documento
						(cAliasQry)->DUD_SERIE,;															//03 - Serie Documento
						(cAliasQry)->REMNOM,;																//04 - Nome Rementente
						(cAliasQry)->REMMUN,;																//05 - Municipio Rementente
						(cAliasQry)->REMEST,;																//06 - Estado Rementente
						(cAliasQry)->XDTPSC,;																//07 - Data Previs�o de Saida pra Coleta
						(cAliasQry)->XHRPSC,;																//08 - Hora Previs�o de Saida pra Coleta
						(cAliasQry)->DESTINO,;																//08 - Destino
						(cAliasQry)->DESNOM,;																//10 - Nome Destinat�rio
						(cAliasQry)->DESMUN,;																//11 - Municipio Destanat�rio
						(cAliasQry)->DESEST,;																//12 - Estado Destinat�rio 
						(cAliasQry)->DATPRC,;																//13 - Data Previs�o de Coleta
						(cAliasQry)->HORPRC,;																//14 - Hora Previs�o de Coleta
						(cAliasQry)->DATPRE,;																//15 - Data Previs�o de Entrega
						(cAliasQry)->HORPRE,;																//16 - Hora Previs�o de Entrega
						If(!Empty((cAliasQry)->XDTAGE), (cAliasQry)->XDTAGE, (cAliasQry)->XDTPEN),;		//17 - Data Previs�o de Entrega Real
						If(!Empty((cAliasQry)->XHRAGE), (cAliasQry)->XHRAGE, (cAliasQry)->XHRPEN),;		//18 - Hora Previs�o de Entrega Real
						"",;																				//19 - Espa�o
						})
		(cAliasQry)->(dbSkip())
	EndDo
EndIf

(cAliasQry)->(dbCloseArea())

Return aRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fGetOcos �Autor  � Vin�cius Moreira   � Data � 09/12/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca ocorr�ncias da viagem para exibi��o.                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetOcos (cNumVia)

Local aRet      := {}
Local cQuery    := ""
Local cAliasQry := GetNextAlias()

cQuery += " SELECT " + CRLF 
cQuery += "   DUA.DUA_FILDOC " + CRLF 
cQuery += "  ,DUA.DUA_DOC " + CRLF 
cQuery += "  ,DUA.DUA_SERIE " + CRLF 
cQuery += "  ,DUA.DUA_CODOCO " + CRLF 
cQuery += "  ,DUA.DUA_DATOCO " + CRLF 
cQuery += "  ,DUA.DUA_HOROCO " + CRLF 
cQuery += "  ,DT2.DT2_DESCRI " + CRLF 
cQuery += "  FROM " + RetSqlName("DUA") + " DUA " + CRLF 
cQuery += " INNER JOIN " + RetSqlName("DT2") + " DT2 ON " + CRLF 
cQuery += "       DT2.DT2_FILIAL = '" + xFilial("DT2") + "' " + CRLF 
cQuery += "   AND DT2.DT2_CODOCO = DUA.DUA_CODOCO " + CRLF 
cQuery += "   AND DT2.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += " WHERE DUA.DUA_FILIAL = '" + xFilial("DUA") + "' " + CRLF 
cQuery += "   AND DUA.DUA_VIAGEM = '" + cNumVia + "' " + CRLF 
cQuery += "   AND DUA.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += " ORDER BY " + CRLF 
cQuery += "   DUA.DUA_FILDOC " + CRLF 
cQuery += "  ,DUA.DUA_DOC " + CRLF 
cQuery += "  ,DUA.DUA_SERIE " + CRLF 
cQuery += "  ,DUA.DUA_DATOCO " + CRLF 
cQuery += "  ,DUA.DUA_HOROCO " + CRLF 

cQuery := ChangeQuery(cQuery)
fDoQuery(cQuery, @cAliasQry)
TcSetField(cAliasQry,"DUA_DATOCO",TamSx3("DUA_DATOCO")[3],TamSx3("DUA_DATOCO")[1],TamSx3("DUA_DATOCO")[2])

If (cAliasQry)->(Eof())
	aAdd(aRet, {	(cAliasQry)->DUA_FILDOC,;
					(cAliasQry)->DUA_DOC,;
					(cAliasQry)->DUA_SERIE,;
					(cAliasQry)->DUA_CODOCO,;
					(cAliasQry)->DUA_DATOCO,;
					(cAliasQry)->DUA_HOROCO,;
					(cAliasQry)->DT2_DESCRI})
Else
	While (cAliasQry)->(!Eof())
		aAdd(aRet, {	(cAliasQry)->DUA_FILDOC,;
						(cAliasQry)->DUA_DOC,;
						(cAliasQry)->DUA_SERIE,;
						(cAliasQry)->DUA_CODOCO,;
						(cAliasQry)->DUA_DATOCO,;
						(cAliasQry)->DUA_HOROCO,;
						(cAliasQry)->DT2_DESCRI})
		(cAliasQry)->(dbSkip())
	EndDo
EndIf

(cAliasQry)->(dbCloseArea())

Return aRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fChgVia  �Autor  � VIn�cius Moreira   � Data � 09/12/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega documentos da viagem selecionada.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fChgVia (bLineVia, bLineDocs, bLineOcos, cViagem, cSerTms)

aEval(aViagens, {|x,y| x[nVMARCA] := .F.})
aViagens[oListVia:nAt, nVMARCA] := .T.
oListVia:Refresh(.T.)

aDocs := fGetDocs(cViagem, cSerTms)
oListDocs:SetArray(aDocs)
oListDocs:bLine := bLineDocs
oListDocs:Refresh(.T.)

aOcos := fGetOcos(cViagem)
oListOcos:SetArray(aOcos)
oListOcos:bLine := bLineOcos
oListOcos:Refresh(.T.)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fMntHist  �Autor  � Vin�cius Moreira   � Data � 09/12/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza manuten��es no arquivo de historicos.              ���
���          � Obs: Como n�o foi criado campo no DTQ, esta op��o de arqui-���
���          �      vos serve como paliativo.                             ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fMntHist(nOpcX, cArquivo)

Default cArquivo := ""

//�������������������������������������������������������������
//�Leitura de historico                                       �
//�������������������������������������������������������������
If nOpcX == 2
	cHistorico := MemoRead(cDirHist+cArquivo)
	oHistorico:Refresh(.T.)
//�������������������������������������������������������������
//�Grava��o de historico                                      �
//�������������������������������������������������������������
ElseIf nOpcX == 3
	If !Empty(cNovoTexto)
		MemoWrite(cDirHist+cArquivo, cUserName + " - " + dToC(Date()) + " - " + Time() + CRLF + cNovoTexto + CRLF + "//-------------FIM MSG-------------//" + CRLF + CRLF + cHistorico)
		cHistorico := MemoRead(cDirHist+cArquivo)
		oHistorico:Refresh(.T.)
		
		cNovoTexto := ""
		oNovoTexto:Refresh(.T.)
	EndIf
ElseIf  nOpcX == 4  // Por: Ricardo 
	//�������������������������������������������������������������
	//�Leitura de historico                                       �
	//�������������������������������������������������������������
	cHistorico := MemoRead(cDirHist+cArquivo)
	Return cHistorico
		
//�������������������������������������������������������������
//�Cancelando novo registro                                   �
//�������������������������������������������������������������
Else
	cNovoTexto := ""
	oNovoTexto:Refresh(.T.)
EndIf

Return 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fCriaDir �Autor  � Vin�cius Moreira   � Data � 24/07/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria diretorios utilizados pelo programa.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCriaDir (cPatch)

Local lRet   := .T.
Local aDirs  := {}
Local nPasta := 1
Local cPasta := ""
Local cBarra   := If(IsSrvUnix(), "/", "\")
//�����������������������������������������������Ŀ
//�Criando diret�rio de configura��es de usu�rios.�
//�������������������������������������������������
aDirs := Separa(cPatch, cBarra)
For nPasta := 1 to Len(aDirs)
	If !Empty (aDirs[nPasta])
		cPasta += cBarra + aDirs[nPasta]
		If !ExistDir (cPasta) .And. MakeDir(cPasta) != 0
			lRet := .F.
			Exit
		EndIf
	EndIf
Next nPasta

Return lRet 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fPesqui  �Autor  � Vin�cius Moreira   � Data � 02/06/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Pesquisa dados no ListBox.                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fPesqui(oListBox, aDados, nOrdPes, cPesqui)

Local xPesqui := Nil
Local nPosPes := 0
Local cPesAtu := Upper(AllTrim(cPesqui))
Local lRet    := .F.

If !Empty(cPesAtu) .And. nOrdPes > 0
	If nOrdPes == 1
		xPesqui := cPesAtu
		nPosPes := aScan(aDados, {|x| AllTrim(x[nVVIAGEM]) == xPesqui})	
	ElseIf nOrdPes == 2
		xPesqui := Val(cPesAtu)
		nPosPes := aScan(aDados, {|x| x[nVPLANID] == xPesqui})
	ElseIf nOrdPes == 3
		xPesqui := StrTran(StrTran(StrTran(cPesAtu,"-"),"/"),"\")
		nPosPes := aScan(aDados, {|x| AllTrim(x[nVPLACA]) == xPesqui})
	ElseIf nOrdPes == 4
		xPesqui := cPesAtu
		nPosPes := aScan(aDados, {|x| Left(x[nVNOMMOT], Len(xPesqui)) == xPesqui})
	EndIf
	
	If nPosPes == 0
		Help (" ", 1, "RGEFM0205",,"Nenhum registro encontrado.", 3, 0)
	Else
		oListBox:nAt := nPosPes
		oListBox:Refresh(.T.)
		lRet := .T.
	EndIf
EndIf

Return lRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fForaEnt �Autor  � Vin�cius Moreira   � Data � 18/12/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Checa se existem documentos com o prazo de entrega real    ���
���          � estourado.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fForaEnt(cNumVia, cSerTms, _cFilial)

Local lRet    := .F.
Local aEnts   := fGetDocs (cNumVia, cSerTms, _cFilial)
Local nEnt    := 1
Local nTmpEnt := SuperGetMv("ES_GEFM02G",,01.00)

For nEnt := 1 to Len(aEnts)
	If aEnts[nEnt, nDXDTPEN] >= Date() .And. fForaPrz(aEnts[nEnt, nDXHRPEN], nTmpEnt)
		lRet := .T.
		Exit
	EndIf 
Next nEnt

Return lRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fOcoOutros�Autor  � Vin�cius Moreira   � Data � 12/02/2015  ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela de sela��o de ocorr�ncia do evento "Outros".          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fOcoOutros()

Local lRet    := .T.
Local aOutros := fGetOcoOutros(DTQ->DTQ_SERTMS)
Local oDlg
Local aButtons  := {}
Local aSize     := MsAdvSize(.T.)
Local aInfo     := {}
Local aPosObj   := {}
Local aObjects  := {}
Local cTitulo   := "Outras ocorr�ncias"

Local oListOut
Local bDblClk   := {|| aEval(aOutros, {|x,y| aOutros[y,1] := .F. }), aOutros[oListOut:nAt,1] := .T., oListOut:Refresh(.T.) }

If Len(aOutros) == 0
	Help (" ", 1, "RGEFM0206",,"Ocorr�ncias n�o encontradas.", 3, 0)
	lRet := .F.
Else
	DEFINE MsDialog oDlg Title cTitulo From 0, 0 To 400, 380 Of oMainWnd Pixel
	@ 05, 04 ListBox oListOut Fields HEADER "", "Codigo", "Descri��o" Size 184, 180  Of oDlg Pixel ON DBLCLICK Eval(bDblClk)
	oListOut:SetArray( aOutros )
	oListOut:bLine := { || {	If(aOutros[oListOut:nAt,1], oLegOk, oLegNo),;
								aOutros[oListOut:nAt,2],;
								aOutros[oListOut:nAt,3]} }
	Activate MsDialog oDlg ON INIT EnchoiceBar( oDlg, {|| lRet := .T., cOcoSel := aOutros[oListOut:nAt,2], oDlg:End() }, { || lRet := .F., oDlg:End() } ) Centered
EndIf

Return lRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGetOcoOutros     � Vin�cius Moreira   � Data � 12/02/2015  ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca ocorr�ncias para escolha no evento "Outros".         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetOcoOutros(cSerTms)

Local aRet      := {}
Local cQuery    := ""
Local cAliasQry := GetNextAlias()

cQuery += "  SELECT " + CRLF 
cQuery += "    DT2.DT2_CODOCO CODOCO " + CRLF 
cQuery += "   ,DT2.DT2_DESCRI DESCRI " + CRLF 
cQuery += "   FROM " + RetSqlName("DT2") + " DT2 " + CRLF 
cQuery += "  WHERE DT2.DT2_FILIAL = '" + xFilial("DT2") + "' " + CRLF 
cQuery += "    AND DT2.DT2_SERTMS = '" + cSerTms + "' " + CRLF 
cQuery += "    AND DT2.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += "  ORDER BY " + CRLF 
cQuery += "    DT2.DT2_CODOCO " + CRLF 
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .F.) 
While (cAliasQry)->(!Eof())
	aAdd(aRet,{	.F.,;
				(cAliasQry)->CODOCO,;
				(cAliasQry)->DESCRI})
	(cAliasQry)->(dbSkip())
EndDo
(cAliasQry)->(dbCloseArea())

Return aRet                                                                                        
                        
/************************************************************************************************************************
 *  Por: Ricardo Guimr�es - Em: 18/03/2015                                                                                       *
 * Motivo: Customiza��o para o Painel passar a filtrar multi clientes alternados em vez de intervalo         *
 *************************************************************************************************************************/
 /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fExibeCli    �Autor  � J Ricardo Guimar�es   � Data �  18/03/2015  ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega tela de cliente com markbrowse.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Static Function fExibeCli()
User Function fxExibeCli()

Local lRet      := .F.
Local oDlg
Local aButtons  := {}
Local aSize     := MsAdvSize(.T.)
Local aInfo     := {}
Local aPosObj   := {}
Local aObjects  := {}
Local cTitulo   := "Cadastro de Clientes" 

Local bLineDocs := {|| }
Local aHeadDocs := {}

Local bLineOcos := {|| }
Local aHeadOcos := {}

Local bLine     := {|| }
Local aHeadCli  := {}
Local nPosCli   := 0
Local nOpc      := 0
Local aSizes    := {}

Local oOrdem
Local aOrdens   := {"CNPJ", "Raz�o Social","C�digo + Loja"}
Local oRefresh
Local oBtnIni
Local oBtnPar

Local oTimer

Local cOrdPes   := ""
Local aPesqui   := {"CNPJ", "Raz�o Social","C�digo + Loja"}
Local oPesqui
Local cPesqui   := Space(100)
Local cCliSel    := ""

Local MvPar
Local MvParDef := ""

Private oListCli
Private aClientes := {}  

Private cOrdemCli     := ""
Private nOrdemCli     := 2

MvPar := &(Alltrim(ReadVar()))																	// Carrega Nome da Variavel do Get em Questao
mvRet := Alltrim(ReadVar())																		// Iguala Nome da Variavel ao Nome variavel de Retorno

// Somente exibe a tela de clientes se o Get estiver em branco
/*
If !Empty(&MvPar)
	Return .T.
EndIf
*/
						
MsgRun("Aguarde... Carregando clientes... ",,{|| aClientes  := fGetCli() })

If Len(aClientes) == 0
  	Aviso("Inconsist�ncia","N�o h� dados para exibir.",{"Ok"},,"Aten��o:")
Else
	aAdd( aObjects, { 0, 013, .T., .T., .F. } )
	aAdd( aObjects, { 0, 047, .T., .T., .F. } )
	aAdd( aObjects, { 0, 040, .T., .T., .F. } )
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 1, 1 }
	aPosObj := MsObjSize( aInfo, aObjects, .T. )

	DEFINE MSDIALOG oDlg FROM aSize[7],00 TO aSize[6],aSize[5] TITLE cTitulo PIXEL
	
	TSay():New(aPosObj[1][1]+2,aPosObj[1][2],{|| "Ordem" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,100,80)
	oOrdem := TComboBox():Create(oDlg,{|u|If(PCount()>0,cOrdemCli:=u,cOrdemCli)},aPosObj[1][1],aPosObj[1][2]+25,aOrdens,100,20,,{|| nOrdemCli := oOrdem:nAt, fChgOrdemCli (@oListCli, aClientes, bLine, aHeadCli, aOrdens, nOrdemCli)},,,,.T.,,,,,,,,,'cOrdem')

	TSay():New(aPosObj[1][1]+15,aPosObj[1][2],{|| "Buscar" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,100,80)
	oOrdPes := TComboBox():Create(oDlg,{|u|if(PCount()>0,cOrdPes:=u,cOrdPes)},aPosObj[1][1]+15,aPosObj[1][2]+025,aPesqui,100,20,,{|| },,,,.T.,,,,,,,,,'cOrdPes')
	oPesqui := TGet():New(aPosObj[1][1]+15, aPosObj[1][2]+140,{|u| if(PCount()>0,cPesqui:=u,cPesqui)}, oDlg, aPosObj[1][4]-(aPosObj[1][2]+340+10),10, "",{|| If(fPesqCli(@oListCli, aClientes, oOrdPes:nAt, cPesqui),Eval(oListCli:bChange),) },,,,,,.T.,,,,,,,,,,'cPesqui')

	//�����������������������������������������������������������������������������������Ŀ
	//�Lista de cliente.                                                                  �
	//�������������������������������������������������������������������������������������	
	aHeadCli  := {	"",;
					"CNPJ",;
					"C�digo",;
					"Loja",;
					"Raz�o Social",;
					""}
					
	oListCli := TWBrowse():New( aPosObj[1][1]+30,aPosObj[2][2],aPosObj[2][4],(aPosObj[2][3]+aPosObj[1][3])+50,,aHeadCli,, oDlg, ,,,,;	
	{|nRow,nCol,nFlags|,oListCli:Refresh()},,,,,,,.F.,,.T.,,.F.,,, )
	oListCli:SetArray(aClientes)                                                                

	bLine := {|| { 		If(aClientes[oListCli:nAt,01],oLegOk,oLegNo),;		//Marca
							aClientes[oListCli:nAt,02],;			   		//CNPJ
							aClientes[oListCli:nAt,03],;						//C�digo
							aClientes[oListCli:nAt,04],;						//Loja
							aClientes[oListCli:nAt,05],;						//Raz�o Social
							aClientes[oListCli:nAt,06]}}					//Espa�o
	oListCli:bLine := bLine

	oListCli:bLDblClick := {|| aClientes[oListCli:nAt, 01] := !aClientes[oListCli:nAt, 01] }
		
	ACTIVATE MSDIALOG oDlg on Init ENCHOICEBAR(oDlg, {|| nOpc := 1, lRet := .T., cCliSel := fCliMarcados(aClientes), oDlg:End() } , {|| nOpc := 0, lRet := .F.,cCliSel := fCliMarcados(aClientes), oDlg:End() },,aButtons)	
/*	
	If nOpc == 1
		While fIncEvento(nRecDTQ)
		EndDo
		fTeclas(1)
	EndIf
*/	                      

// Atualiza o campo onde foi disparado a fun��o de consulta de cliente
&MvRet := cCliSel // mvpar																				// Devolve Resultado

EndIf

//fTeclas(2)

Return cCliSel // .T. // lRet
//Return cCliSel

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGetCli     �  Ricardo Guimar�es   � Data � 18/03/2015  ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca clientes".         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetCli()

Local aRet      := {}
Local cQuery    := ""
Local cAliasQry := GetNextAlias()

cQuery += "  SELECT A1_CGC, A1_NOME, A1_COD, A1_LOJA " + CRLF 
cQuery += "   FROM  " + RetSqlName("SA1") + " SA1 " + CRLF 
cQuery += "  WHERE A1_MSBLQL<>'1' " + CRLF 
cQuery += "       AND D_E_L_E_T_='' " + CRLF 
cQuery += "       AND EXISTS  " + CRLF 
cQuery += "       ( SELECT DT6_CLIDEV, DT6_LOJDEV FROM DT6010 WHERE DT6_CLIDEV = SA1.A1_COD AND DT6_LOJDEV = SA1.A1_LOJA )  " + CRLF 
cQuery += "  ORDER BY " + CRLF 
cQuery += "    SA1.A1_CGC " + CRLF 

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .F.) 

While (cAliasQry)->(!Eof())
	aAdd(aRet,{	.F.,;
				(cAliasQry)->A1_CGC,;
				(cAliasQry)->A1_COD,;
				(cAliasQry)->A1_LOJA,;				
				(cAliasQry)->A1_NOME,;
				""})				
				
	(cAliasQry)->(dbSkip())
EndDo
(cAliasQry)->(dbCloseArea())

Return aRet                                                                                        

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fChgOrdemCli �Autor  � Ricardo Guimar�es   � Data � 19/03/2015  ���
�������������������������������������������������������������������������͹��
���Desc.     � Muda ordem dos registros na tela.                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fChgOrdemCli(oListBox, aDados, bLine, aTitulos, aOrdens, nOrdem)

Local aCpoOrd  := Separa(aOrdens[nOrdem], "+")
Local cBlkOrdX := ""
Local cBlkOrdY := ""
Local bBlkOrd  := {|| }
Local nX       := 0

//����������������������������������������������������������������������Ŀ
//�Op��es de ordem.                                                      �
//�1 - "CNPJ"                                                                �
//�2 - Raz�o Social                                                 �
//������������������������������������������������������������������������
If nOrdem == 1
	bBlkOrd := {|| aSort (aDados,,, { |x, y| ( x[02] ) < ( y[02] ) })}
ElseIf nOrdem == 2
	bBlkOrd := {|| aSort (aDados,,, { |x, y| ( x[05] ) < ( y[05] ) })}
ElseIf nOrdem == 3
	bBlkOrd := {|| aSort (aDados,,, { |x, y| ( x[03] + x[04] ) < ( y[03] + y[04]) })}	
//ElseIf nOrdem == 4
//	bBlkOrd := {|| aSort (aDados,,, { |x, y| ( x[nVNOMMOT] + x[nVFILIAL] + x[nVVIAGEM] ) < ( y[nVNOMMOT] + y[nVFILIAL] + y[nVVIAGEM] ) })}
EndIf

MsgRun("Aguarde... Ordenando registros... ",, bBlkOrd)
oListBox:SetArray(aDados)
oListBox:bLine := bLine
oListBox:Refresh(.T.)

Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fPesqui  �Autor  � J Ricardo Guimar�es   � Data � 19/03/2015  ���
�������������������������������������������������������������������������͹��
���Desc.     � Pesquisa dados no ListBox.                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fPesqCli(oListBox, aDados, nOrdPes, cPesqui)

Local xPesqui := Nil
Local nPosPes := 0
Local cPesAtu := Upper(AllTrim(cPesqui))
Local lRet    := .F.

If !Empty(cPesAtu) .And. nOrdPes > 0
	If nOrdPes == 1
		xPesqui := cPesAtu
		nPosPes := aScan(aDados, {|x| SubStr(AllTrim(x[02]),1,Len(xPesqui)) = xPesqui})	
	ElseIf nOrdPes == 2
		xPesqui := cPesAtu
		nPosPes := aScan(aDados, {|x| SubStr(AllTrim(x[05]),1,Len(xPesqui)) = xPesqui})
	ElseIf nOrdPes == 3
		xPesqui := cPesAtu    // StrTran(StrTran(StrTran(cPesAtu,"-"),"/"),"\")
		nPosPes := aScan(aDados, {|x| AllTrim(x[03]) +  AllTrim(x[04]) == xPesqui})
/*				
	ElseIf nOrdPes == 4
		xPesqui := cPesAtu
		nPosPes := aScan(aDados, {|x| Left(x[nVNOMMOT], Len(xPesqui)) == xPesqui})
*/		
	EndIf
	
	If nPosPes == 0
		Help (" ", 1, "RGEFM0206",,"Nenhum registro encontrado.", 3, 0)
	Else
		oListBox:nAt := nPosPes
		oListBox:Refresh(.T.)
		lRet := .T.
	EndIf
EndIf

Return lRet

************************************************************
// Monta lista de clientes que foram marcados
************************************************************
Static Function fCliMarcados(_aLista)
Local _cListaCli := ""
Local _nItem	   := 0

For _nItem := 1 To Len(_aLista)
	If _aLista[_nItem,01]
		_cListaCli += "'"+_aLista[_nItem,03] + _aLista[_nItem,04] + "',"
	EndIf
EndFor

If !Empty(_cListaCli)
	_cListaCli := SubStr(_cListaCli,1,Len(_cListaCli)-1)
EndIf	

Return(_cListaCli)                                                 

************************************************************
// Visualiza a ocorr�ncia 
************************************************************
Static Function fVisOco(_cFilVia,_cNumVia)
Local oGetVisOco
Local cGetVisOco := ""
Local oGroup1
Local oMultiGetVisOco
Local cMultiGetVisOco := ""
Local oSay1
Local oSButton1
Static oDlg

cGetVisOco := fGetUltPos(_cFilVia, _cNumVia)
cMultiGetVisOco := fMntHist(4, _cNumVia)

  DEFINE MSDIALOG oDlg TITLE "Hist�rico de Observa��es" FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL

    @ 002, 003 GROUP oGroup1 TO 135, 244 OF oDlg COLOR 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 137, 217 TYPE 01 OF oDlg ENABLE ACTION oDlg:End()
    @ 030, 007 GET oMultiGetVisOco VAR cMultiGetVisOco OF oDlg MULTILINE SIZE 232, 098 COLORS 0, 16777215 HSCROLL PIXEL
    @ 014, 014 SAY oSay1 PROMPT "�ltima Posi��o :" SIZE 042, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 013, 054 MSGET oGetVisOco VAR cGetVisOco SIZE 186, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return

/*-----------------------------------------------------------*/
Static Function fGetTabSXS()
/*-----------------------------------------------------------*/
Local _aRet 	:= {}
Local _nN		:= 0
Local _aArqs	:= {}

_aArqs := Directory("SX*.DTC",,NIl,.T.,2)

For _nN := 1 to Len(_aArqs)
	AADD(_aRet, _aArqs[_nN][1])
EndFor
Return _aRet

/*-----------------------------------------------------------*/
Static Function fGetHeader()
/*-----------------------------------------------------------*/
Local _aHeader := {}
Local _nx := 0

AADD(_aHeader, "")

For _nx := 1 to FCount()
	AADD(_aHeader, FieldName(_nx))
EndFor

Return _aHeader

/*-----------------------------------------------------------*/
Static Function fGetDados()
/*-----------------------------------------------------------*/
Local _aDados := {}
Local _nx := 0

AADD(_aDados, "")

While .NOT. EOF()
	For _nx := 1 to FCount()
		AADD(_aDados, FieldGet(_nx) )
	EndFor
	
	dbSkip()
End
Return _aDados
