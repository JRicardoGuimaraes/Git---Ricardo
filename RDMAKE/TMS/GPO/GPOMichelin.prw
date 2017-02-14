#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"
#include 'Tbiconn.ch'
#include 'Fileio.ch'

#DEFINE FILELOG		"Michelin-IDI.LOG"

#Define _cInterfacePEDEMB  	'Michelin - Interface Pedido a Embarcar - WSH241' // Carga de planos
#Define _cInterfacePLANEMB 	'Michelin - Interface Plano de Embarque - WSH242' // Shipment Plan
#Define _cInterfaceCONEMB  	'Michelin - Interface CONEMB'  	// Envio de Interface de Faturamento
#Define _cInterfaceOCORREN 	'Michelin - Interface OCORREN' 	// Envio de Interface de Ocorrência
#Define _cInterfaceNFE		'Michelin - Interface NF-e' 	// Recebe Interface de Ocorrência

// Pedidos a Embarcar
// Cabeçalho
#Define Cab_IdInfo		1
#Define Cab_TpReg			2
#Define Cab_CodIdMsg 	3
#Define Cab_CNPJTransp	4
#Define Cab_IdParcCom   	5
#Define Cab_CNPJEmisPed	6
#Define Cab_CodRelSubs	7
#Define Cab_DtEmisArq	8
#Define Cab_HrEmisArq	9

// Detalhes
#Define Det_IdInfo			1
#Define Det_TpReg				2
#Define Det_CodIdMsg			3
#Define Det_NumLinha			4
#Define Det_CodCia			5
#Define Det_CodCliente		6
#Define Det_DescCliente		7
#Define Det_Cidade			8
#Define Det_UF				9
#Define Det_DataFatur		10
#Define Det_NumCarga			11
#Define Det_StatusCarga 		12
#Define Det_DescStatusCarga	13
#Define Det_Pedido			14
#Define Det_LPItem			15
#Define Det_Item 				16
#Define Det_Desc1Item		17
#Define Det_QtdAtendida		18
#Define Det_PesoTotal		19
#Define Det_Filial			20
#Define Det_EmbarqueInstr	22
#Define Det_TipoEmbarque		23
#Define Det_DtEmbarque		24
#Define Det_DtEmbChegada		25

// Rodape
#Define Rod_IdInfo			1
#Define Rod_TpReg				2
#Define Rod_CodIdMsg			3
#Define Rod_QtdLinhas		4

*---------------------------------------*
// Recebe NF-e´s
// Cabeçalho
#Define NFe_Cab_IdInfo		1
#Define NFe_Cab_TpReg		2
#Define NFe_Cab_CodIdMsg 	3
#Define NFe_Cab_NumCarreg	4
#Define NFe_Cab_CNPJTransp	5
#Define NFe_Cab_IdParcCom   6
#Define NFe_Cab_NomeTransp	7
#Define NFe_Cab_PlacaVeic	8
#Define NFe_Cab_CNPJMich		9
#Define NFe_Cab_NFCanc		9
#Define NFe_Cab_DTEmisArq	10

// Detalhes
#Define NFe_Det_IdInfo			1
#Define NFe_Det_TpReg			2
#Define NFe_Det_CodIdMsg			3
#Define NFe_Det_NumCarreg		4
#Define NFe_Det_CNPJMich			5
#Define NFe_Det_NFCanc			6
#Define NFe_Det_DtEmisNF			7
#Define NFe_Det_NumNFe			8
#Define NFe_Det_SerieNFe			9
#Define NFe_Det_InscEst			10
#Define NFe_Det_ClienteNFe		11
#Define NFe_Det_CFOPNFe		 	12
#Define NFe_Det_DtEntPrev		13
#Define NFe_Det_HrEntPrev		14
#Define NFe_Det_VrIcmsNFe		15
#Define NFe_Det_VrTotNFe			16
#Define NFe_Det_VrTotProd		17
#Define NFe_Det_PesoBruto		18
#Define NFe_Det_UnMedPeso		19
#Define NFe_Det_QtdTotVol		20
#Define NFe_Det_RazaoSoc			21
#Define NFe_Det_EndNFe			22
#Define NFe_Det_BairroNFe		23
#Define NFe_Det_CEPNFe			24
#Define NFe_Det_CidadeNFe		25
#Define NFe_Det_EstadoNFe		26
#Define NFe_Det_CNPJCPFNFe		27
#Define NFe_Det_InscEstNFe		28
#Define NFe_Det_TelefoneNFe		29
#Define NFe_Det_FretePorConta	30
#Define NFe_Det_EspecieNFe		31
#Define NFe_Det_MarcaNFe			32
#Define NFe_Det_NumNota			33
#Define NFe_Det_AN8TranspRedes	34
#Define NFe_Det_CNPJTranspRedes	35
#Define NFe_Det_InscEstTrpRedes	36
#Define NFe_Det_RazaoTransRedes	37
#Define NFe_Det_EndTranspRedes	38
#Define NFe_Det_BaiTranspRedes	39
#Define NFe_Det_CidTranspRedes	40
#Define NFe_Det_CEPTranspRedes	41
#Define NFe_Det_UFTranspRedes	42
#Define NFe_Det_TelTranspRedes	43
#Define NFe_Det_OBSREDES			44
#Define NFe_Det_LPItem			45

// Rodape
#Define NFe_Rod_IdInfo			1
#Define NFe_Rod_TpReg			2
#Define NFe_Rod_CodIdMsg			3
#Define NFe_Rod_NumCarreg		4
#Define NFe_Rod_QtdLinhas		5

*---------------------------------------*
// CONEMB - Arquivo dos CT-e´s
// Cabeçalho
#Define CON_Cab_IdInfo		1
#Define CON_Cab_TpReg		2
#Define CON_Cab_CNPJTransp	3
#Define CON_Cab_IdParcCom   4
#Define CON_Cab_Reservado1	5
#Define CON_Cab_Reservado2	6
#Define CON_Cab_Reservado3	7

// Detalhes
#Define CON_Det_IdInfo			1
#Define CON_Det_TpReg			2
#Define CON_Det_CodIdMichelin	3
#Define CON_Det_NumNota			4
#Define CON_Det_SerieNota		5
#Define CON_Det_NumCTe			6
#Define CON_Det_ValorCTe			7
#Define CON_Det_SerieCTe			8
#Define CON_Det_DataCTe			9
#Define CON_Det_CFOP				10
#Define CON_Det_AliqICMS			11
#Define CON_Det_ValorICMS	 	12
#Define CON_Det_AliqISS			13
#Define CON_Det_ValorISS			14
#Define CON_Det_NatCarga			15
#Define CON_Det_NatDest 			16
#Define CON_Det_CNPJCliente		17
#Define CON_Det_IDCTeComplem	18
#Define CON_Det_Reservado1		19
#Define CON_Det_Reservado2		20
#Define CON_Det_Reservado3		21
#Define CON_Det_BaseICMS			22
#Define CON_Det_BaseISS			23
#Define CON_Det_IdentDoc			24
#Define CON_Det_ChaveVld			25
#Define CON_Det_VrPedagio		26
#Define CON_Det_VrADV			27
#Define CON_Det_SubstTrib		28

// Rodape
#Define CON_Rod_IdInfo			1
#Define CON_Rod_TpReg			2
#Define CON_Rod_QtdLinhas		3

/*-------------------------------------*/

// PLANEMB - Arquivo de Plano de Embarque - Shipment Plan ( WSH242 )
// Cabeçalho
#Define 242_Cab_IdInfo		1
#Define 242_Cab_TpReg		2
#Define 242_Cab_CNPJTransp	3
#Define 242_Cab_IdParcCom   4
#Define 242_Cab_NumCarro		5
#Define 242_Cab_CodTransp	6
#Define 242_Cab_ModTransp	7
#Define 242_Cab_SeqChegada	8
#Define 242_Cab_TipoEquip	9
#Define 242_Cab_NivelServ	10
#Define 242_Cab_CodTransRed	11
#Define 242_Cab_LocalEmb		12
#Define 242_Cab_SiteEmb		13
#Define 242_Cab_PaisEmb		14
#Define 242_Cab_CodTpEquip	15
#Define 242_Cab_ModCarreg	16

// Detalhes
#Define 242_Det_IdInfo			1
#Define 242_Det_TpReg			2
#Define 242_Det_CNPJMichelin	3
#Define 242_Det_NumCarga			4
#Define 242_Det_CodItem			5
#Define 242_Det_OrdemCarreg		6
#Define 242_Det_CodDest			7
#Define 242_Det_Dest				8
#Define 242_Det_DatPrevPartida	9
#Define 242_Det_DatPrevEntrega	10
#Define 242_Det_Quantidade		11

// Rodape
#Define 242_Rod_IdInfo			1
#Define 242_Rod_TpReg			2
#Define 242_Rod_QtdLinhas		3

/*-------------------------------------*/

// 253_OCORREN - Arquivo de Ocorrência ( WSH253 )
// Cabeçalho
#Define 253_Cab_IdInfo		1
#Define 253_Cab_TpReg		2
#Define 253_Cab_CNPJTransp	3
#Define 253_Cab_IdParcCom   4
#Define 253_Cab_NumCarro		5
#Define 253_Cab_CodTransp	6
#Define 253_Cab_ModTransp	7
#Define 253_Cab_SeqChegada	8
#Define 253_Cab_TipoEquip	9
#Define 253_Cab_NivelServ	10
#Define 253_Cab_CodTransRed	11
#Define 253_Cab_LocalEmb		12
#Define 253_Cab_SiteEmb		13
#Define 253_Cab_PaisEmb		14
#Define 253_Cab_CodTpEquip	15
#Define 253_Cab_ModCarreg	16

// Detalhes
/*
#Define 253_Det_IdInfo			1
#Define 253_Det_TpReg			2
#Define 253_Det_CNPJMichelin	3
#Define 253_Det_NumCarga			4
#Define 253_Det_CodItem			5
#Define 253_Det_OrdemCarreg		6
#Define 253_Det_CodDest			7
#Define 253_Det_Dest				8
#Define 253_Det_DatPrevPartida	9
#Define 253_Det_DatPrevEntrega	10
#Define 253_Det_Quantidade		11
*/

#Define 253_Det_IdInfo			1
#Define 253_Det_TpReg			2
#Define 253_Det_CNPJMichelin	3
#Define 253_Det_NumNFC			4
#Define 253_Det_SerieNFC			5
#Define 253_Det_Ocorrencia		6
#Define 253_Det_ObsOco			7
#Define 253_Det_CodObsOco		8
#Define 253_Det_DataEntregReal	9
#Define 253_Det_HoraEntregReal	10
#Define 253_Det_DataOco			11
#Define 253_Det_HoraOco			12
#Define 253_Det_ProdNaoEntreg	13
#Define 253_Det_QtdNaoEntreg	14

// Rodape
#Define 253_Rod_IdInfo			1
#Define 253_Rod_TpReg			2
#Define 253_Rod_QtdLinhas		3

STATIC cPATHPED 		:= GETNEWPAR("ES_PATHPED","\Interfaces\MICHELIN\IN\PEDEMB\")
STATIC cPATHCONEMB	:= GETNEWPAR("ES_PATHCON","\Interfaces\MICHELIN\OUT\CONEMB\")
STATIC cPATHPLANEMB	:= GETNEWPAR("ES_PATHEMB","\Interfaces\MICHELIN\OUT\PLANEMB\")
STATIC cPATHOCORREN	:= GETNEWPAR("ES_PATHOCO","\Interfaces\MICHELIN\OUT\OCORREN\")
STATIC cPATHNFE		:= GETNEWPAR("ES_PATHNFE","\Interfaces\MICHELIN\IN\NFE\")

STATIC	_aLog			:= {}
STATIC _cError		:= ''
STATIC	_cWarning		:= ''

/*/{Protheus.doc} Michelin
//TODO Descrição auto-gerada.
@author u297686 - Ricardo Guimarães
@since 13/04/2016
@version 1.0

@type function
/*/

/*********************************************/
/* Processa interface Michelin               */
/*********************************************/
/*/{Protheus.doc} GPOMichelin
//TODO Descrição auto-gerada.
@author u297686 - Ricardo Guimarães
@since 18/04/2016
@version 1.0
@param _cInterface, , descricao
@param _lAuto, , descricao
@type function
/*/
user function GPOMichelin(_cInterface, _lAuto)
Local _cStatus 		:= ""
Local _nOpc 			:= 0

DEFAULT _lAuto 		:= .F.
DEFAULT _cInterface 	:= "PEDEMB"

PRIVATE xMensagem 	:= ""
PRIVATE xTRAB			:= ""

// Carga dos Pedidos a Embarcar
If _cInterface == "PEDEMB"
	Processa( {|| U_GPOPedEmb(_lAuto) }, "Processando...", "Carregando interfaces de Pedidos a Embarcar (WSH241)...",.F.)

// Geração do CONEMB
ElseIf _cInterface == "CONEMB"

	Processa( {|| U_GPOCONMICH(_lAuto) }, "Processando...", "Gerando interface CONEMB ( Michelin )...",.F.)

// Geração do Plano de Embarque
ElseIf _cInterface == "PLANEMB"
	Processa( {|| U_GPOPLANEMB(_lAuto) }, "Processando...", "Gerando interface de Planejamento de Embarque (WSH242) ...",.F.)

// Geração da interface de Ocorrência
ElseIf _cInterface == "OCORREN"
	Processa( {|| U_GPOOCOMICH(_lAuto) }, "Processando...", "Gerando interface de Ocorrência (WSH253) ...",.F.)

// Geração da interface de Ocorrência
ElseIf _cInterface == "NFE"
	Processa( {|| U_GPONFeMICH(_lAuto) }, "Processando...", "Carregando interface de NF-e´s (RIXXX) ...",.F.)

EndIf

return Nil 

/*/{Protheus.doc} PedEmb
//TODO Descrição auto-gerada.
@author u297686 - Ricardo Guimarães
@since 18/04/2016
@version 1.0
@param _cInterface, , descricao
@param _lAuto, , descricao
@type function
/*/

User Function GPOPedEmb(_lAuto)
Local _aArea 	 := GetArea()
Local _aArqs 	 := {}
Local _cPathDest := ""
Local _nX		 := 0
Local _cArqTXT := ""
Local _aPedEmb := {}
Local _cArqORIG := ""

Local cDe		:= GetMv("MV_RELFROM")
Local cPara	:= UsrRetMail( RetCodUsr() )
Local cCc		:= ''
Local cAssunto:= 'Log de erro da Importação do EDI - Michelin'
Local cMsg		:= 'Segue em anexo o arquivo com as informações de erro ocorridos na Importação.'
Local cAnexo	:= '\SYSTEM\'+FILELOG
Local lLog		:= .F.

// Carregas os XML´s da pasta, recebido da CNH
MONTADIR(cPathPED)
_aArqs := fCarregaArqs("PEDEMB")

If Len(_aArqs) = 0
	MsgStop("Não há arquvios a serem processados","Aviso")
	Return Nil
EndIf

ProcRegua(Len(_aArqs))

_cPathDEST := cPATHPED + "BACKUP"
MONTADIR(_cPathDEST)
_cPathDEST := _cPathDEST+"\"

xMensagem := ""

For _nX:=1 to Len(_aArqs)
	IncProc(0)

	_cArqORIG := cPATHPED + _aArqs[_nX,1]
	_cArqTXT  := _aArqs[_nX,1]
	
	// TXT com error, não processa e move para a pasta backup
	_cArqDEST := _cPathDest + _aArqs[_nX,1]

	_aPedEmb	:= fLerArq(_cArqORIG)

	If _aPedEmb[1,Cab_IdInfo]  <> "111"
		__CopyFile(_cArqORIG,_cArqDEST+"_ERROR")

		// Apaga o arquivo
		fErase(_cArqORIG)
		
		xMensagem += _cArqTXT + " - Arquivo fora do padrão definidio" + CRLF
		Loop
	EndIf

	/* Grava Pedido a Embarcar */
	If fGravaPedEmb(_aPedEmb)

		/* Move arquivo para a pasta backup */
		__CopyFile(_cArqORIG,_cArqDEST)
		// Apaga o arquivo
		fErase(_cArqORIG)
	EndIf	

	xArquivo	:= _aArqs[_nX]
	xOperacao	:= ''
	lLog		:= .T.
	StaticCall( GEFCNHAST , LogThis , CRLF + "Inicio do Arquivo " + xArquivo + "." + CRLF + xMensagem + CRLF + "Fim do Arquivo "+ xArquivo + CRLF , FILELOG )

Next _nX

If !Empty(xMensagem)
	u_EnvEmail( cDe , cPara , cCc , cAssunto , cMsg , cAnexo )
	FErase( cAnexo )	
EndIf 

RestArea(_aArea)
Return Nil


/*************************************************************/
/* Carrega em um array os arquivos de interfaces da Michelin */
/*************************************************************/
Static Function fCarregaArqs(_cInterface)
Local _aArqs
Local _cPrefPed := GETNEWPAR("ES_PEDEMB" ,"MICH_PE_")
Local _cPrefNFe := GETNEWPAR("ES_PREFNFE","MICH_NF_")

If _cInterface == "PEDEMB"
	// Cria Direotrio
	MontaDir(cPATHPED)

	_aArqs := Directory(cPATHPED + _cPrefPed + "*.TXT",,NIl,.T.,2) 
ElseIf _cInterface == "NFE"
	// Cria Direotrio
	MontaDir(cPATHPED)

	_aArqs := Directory(cPATHNFE + _cPrefNFe + "*.TXT",,NIl,.T.,2)

	
EndIf

Return _aArqs 

/*---------------------------------*/
Static Function fLerArq(_cArqORIG)
/*---------------------------------*/
Local _aCab 		:= Array(Cab_HrEmisArq   )
Local _aDetAux 	:= Array(Det_DtEmbChegada)
Local _aDet		:= {}
Local _aRod 		:= Array(Rod_QtdLinhas)
Local _aDados		:= {}
Local _nHandle	:= 0
Local _nTotLin	:= 0
Local _cLinha		:= ""
Local _nRecno		:= 0
Local _nHandle	:= 0 

// Abre o arquivo
_nHandle := FT_FUse(_cArqORIG)

// Se houver erro de abertura abandona processamento
If _nHandle = -1  
	xMensagem += _cArqORIG + " - Erro na abertura do arquivo " + CRLF
	Return( _aDados )
endif

// Posiciona na primeria linha
FT_FGoTop()

// Retorna o número de linhas do arquivo
_nTotLin := FT_FLastRec()

_cLinha  := FT_FReadLn()

If SubStr(_cLinha,1,3) <> '111'
	xMensagem += _cArqORIG + " - Arquivo fora do padrão - não carregado. " + CRLF
	Return _aCab
EndIF
	
While !FT_FEOF()   
	
	// Retorna o recno da Linha  
	//MsgAlert( "Linha: " + cLine + " - Recno: " + StrZero(nRecno,3) )    
	
	// Pego Cabeçalho
	If SubStr(_cLinha,4,3) == 'PEC'
		_aCab[Cab_IdInfo			] := SubStr(_cLinha,01,03) 
		_aCab[Cab_TpReg			] := SubStr(_cLinha,04,03)
		_aCab[Cab_CodIdMsg 		] := SubStr(_cLinha,07,07)
		_aCab[Cab_CNPJTransp		] := SubStr(_cLinha,14,14)
		_aCab[Cab_IdParcCom   	] := SubStr(_cLinha,28,08)
		_aCab[Cab_CNPJEmisPed	] := SubStr(_cLinha,36,14)
		_aCab[Cab_CodRelSubs		] := SubStr(_cLinha,50,07)
		_aCab[Cab_DtEmisArq		] := SubStr(_cLinha,57,08)
		_aCab[Cab_HrEmisArq		] := SubStr(_cLinha,65,06)	
	EndIf	

	// Pego Detalhes
	If SubStr(_cLinha,4,3) == 'PED'
		_aDetAux[Det_IdInfo			] := SubStr(_cLinha,01,03)
		_aDetAux[Det_TpReg			] := SubStr(_cLinha,04,03)
		_aDetAux[Det_CodIdMsg		] := SubStr(_cLinha,07,07)
		_aDetAux[Det_NumLinha		] := SubStr(_cLinha,14,05)
		_aDetAux[Det_CodCia			] := SubStr(_cLinha,19,05)
		_aDetAux[Det_CodCliente		] := SubStr(_cLinha,24,08)
		_aDetAux[Det_DescCliente		] := SubStr(_cLinha,32,60)
		_aDetAux[Det_Cidade			] := SubStr(_cLinha,92,25)
		_aDetAux[Det_UF				] := SubStr(_cLinha,117,03)
		_aDetAux[Det_DataFatur		] := SubStr(_cLinha,120,08)
		_aDetAux[Det_NumCarga		] := SubStr(_cLinha,128,32)
		_aDetAux[Det_StatusCarga 	] := SubStr(_cLinha,160,02)
		_aDetAux[Det_DescStatusCarga] := SubStr(_cLinha,162,30)
		_aDetAux[Det_Pedido			] := SubStr(_cLinha,192,32)
		_aDetAux[Det_LPItem			] := SubStr(_cLinha,224,03)
		_aDetAux[Det_Item 			] := SubStr(_cLinha,227,25)
		_aDetAux[Det_Desc1Item		] := SubStr(_cLinha,252,60)
		_aDetAux[Det_QtdAtendida		] := SubStr(_cLinha,312,11)
		_aDetAux[Det_PesoTotal		] := SubStr(_cLinha,323,12)
		_aDetAux[Det_Filial			] := SubStr(_cLinha,335,32)
		_aDetAux[Det_EmbarqueInstr	] := SubStr(_cLinha,367,80)
		_aDetAux[Det_TipoEmbarque	] := SubStr(_cLinha,447,80)
		_aDetAux[Det_DtEmbarque		] := SubStr(_cLinha,527,20)
		_aDetAux[Det_DtEmbChegada	] := SubStr(_cLinha,547,20)
		
		AADD(_aDet, _aDetAux) 
		
	EndIf
	// Pego rodapé
	If SubStr(_cLinha,4,3) == 'PER'
		_aRod[Rod_IdInfo		] := SubStr(_cLinha,01,03)
		_aRod[Rod_TpReg			] := SubStr(_cLinha,04,03)
		_aRod[Rod_CodIdMsg		] := SubStr(_cLinha,07,07)
		_aRod[Rod_QtdLinhas		] := SubStr(_cLinha,14,05)	
	EndIf

	// Retorna a linha correnteU  
	_nRecno := FT_FRecno()  
		
	// Pula para próxima linha  
	FT_FSKIP()
	_cLinha  := FT_FReadLn()	
End

// Fecha o Arquivo
FT_FUSE()

_aDados := {_aCab, _aDet, _aRod}

Return _aDados
/***********************************************/
* Grava pedido a Embarcar						 *
/***********************************************/
Static Function fGravaPedEmb(_aPedEmb)
Local _aArea := GetArea()

/*
_aPedEmb[1,1] 			:= "CABECALHO"
_aPedEmb[2,Lin,Coluna]	:= "DETALHE"
_aPedEmb[3,1] 			:= "RODAPE"
*/
Alert("Em Desenvolvimento")

RestArea(_aArea)
Return .T.

/*/{Protheus.doc} GPOCONMich
//TODO Gera interface CONEMB da Michelin.
@author u297686 - Ricardo Guimarães
@since 25/04/2016
@version 1.0
@param _cInterface, , descricao
@param _lAuto, , descricao
@type function
/*/

User Function GPOCONMich(_lAuto)
Local _aArea 	 	:= GetArea()
Local _aArqs 	 	:= {}
Local _cPathDest 	:= ""
Local _nX		 	:= 0
Local _cArqTXT 	:= ""
Local _aCONEMB 	:= {}
Local _cArqORIG 	:= ""

Local cDe			:= GetMv("MV_RELFROM")
Local cPara		:= UsrRetMail( RetCodUsr() )
Local cCc			:= ''
Local cAssunto	:= 'Log de erro da Importação do EDI - Michelin'
Local cMsg			:= 'Segue em anexo o arquivo com as informações de erro ocorridos na Importação.'
Local cAnexo		:= '\SYSTEM\'+FILELOG
Local lLog			:= .F.
Local _nHandle	:= 0
Local _cDocAnt	:= ""
Local _cSerAnt	:= ""
Local _aReg   	:= {}
Local _nSeqArq	:= 0
Local _aCab   	:= Array(CON_Cab_Reservado3)
Local _aRod   	:= Array(CON_Rod_QtdLinhas)
Local _nCntLin	:= 1
Local _nTamLin	:= 160
Local _cPrefArq := GETNEWPAR("ES_CONEMB","CON_09520598_")
Local _nRecTot	:= 0
Local _nTipoDoc := 0
Local _cFilial	:= ""  

// Perguntas
If !AjustaParam()
	Return .F.
EndIf	
 
_cFilial  := MV_PAR01
_nTipoDoc := IIF(VALTYPE(MV_PAR04)=="N",1,2)  
 
 // Cabeçalho
_aCab[CON_Cab_IdInfo] 		:= "333" 
_aCab[CON_Cab_TpReg] 		:= "1"
_aCab[CON_Cab_CNPJTransp]	:= PadR(GetAdvFVal('SM0','M0_CGC',cEmpAnt+MV_PAR01,1,''),14)
_aCab[CON_Cab_IdParcCom] 	:= "09520598"
_aCab[CON_Cab_Reservado1] 	:= Space(11) // Reservado 8,2
_aCab[CON_Cab_Reservado2] 	:= Space(10) // Reservado
_aCab[CON_Cab_Reservado3] 	:= Space(20) // Reservado
 
// Pega os dados à serem enviadas no CONEMB
Processa( {|| fQryCONEMB() },"Processando...", "Carragendo dados para geração do interface CONEMB ...",.F.)
//fQryCONEMB()

(xTRAB)->( DbGoTop() )
If (xTRAB)->(Eof())
	Aviso("Aviso - Interface CONEMB",'Não há faturamento da Michelin para geração da interface CONEMB',{"Ok"},1)
	If Select( (xTRAB) ) # 0
		( xTRAB )->( DbCloseArea() )
	EndIf	
	Return .F.
EndIf

( xTRAB )->( DbEval( { || _nRecTot += 1 } ) )
(xTRAB)->( DbGoTop() )

ProcRegua(_nRecTot)

xMensagem := ""

_cArqTXT  := _cPrefArq + DTOS(dDATABASE) + "_" + StrTran(Time(),":","") +"_"+ IIF(_nTipoDoc==1,"CT-e","NFS-e")+".TXT"
MONTADIR(cPATHCONEMB)
_cArqORIG := cPATHCONEMB + _cArqTXT

_nHandle := FCREATE(_cArqOrig, FC_NORMAL)
		
If _nHandle == -1
	xMensagem += "Não foi possível a criação do Arquivo " + _cArqTXT + ":" + STR(FERROR())"
    MsgAlert("Não foi possível a criação do Arquivo :" + _cArqTXT + ":" + STR(FERROR()))
	Return NIl
EndIf

_aCONEMB := {}

While !(xTRAB)->(Eof())
	IncProc()
	
	//_cDOCAnt := (xTRAB)->DT6_DOC
	//_cSerAnt := (xTRAB)->DT6_SERIE
	
//	While !xTRAB->(Eof()) .AND. _cDOCAnt == (xTRAB)->DT6_DOC .AND. _cSerAnt == (xTRAB)->DT6_SERIE 

		Processa( {|| _aReg := fArrayCONEMB((xTRAB)->DT6_DOC) }, "Processando...","Carragendo matriz com os dados para geração do interface CONEMB ...",.F.)
		
		If Len(_aReg) == 0
			Loop
		EndIf
	
		AADD(_aCONEMB, _aReg)
		_nCntLin++
		
		(xTRAB)->(dbSkip())
//	End

	_nSeqArq++
	
End

// Rodapé
_aRod[CON_Rod_IdInfo] 		:= "333"
_aRod[CON_Rod_TpReg]			:= "3"
_aRod[CON_Rod_QtdLinhas]		:= StrZero((_nCntLin+1),5)

If Len(_aCONEMB) > 0
	fGravaCONEMB(_aCab, _aCONEMB,_aRod, _nHandle, _nTamLin)
	fClose(_nHandle)
	
	xMensagem += "Arquivo CONEMB criado " + _cArqTXT + CRLF
	xMensagem += "Total de linhas geradas " + StrZero((_nCntLin+1),4) + CRLF
	
	MsgInfo("Arquivo CONEMB gerado: " + _cArqTXT )
Else	
	xMensagem += "Arquivo CONEMB NÃO criado " + _cArqTXT + ":" + STR(FERROR())		
EndIf
			
xArquivo	:= _cArqTXT
xOperacao	:= ''
lLog		:= .T.
StaticCall( GEFCNHAST , LogThis , CRLF + "Inicio do Arquivo " + xArquivo + "." + CRLF + xMensagem + CRLF + "Fim do Arquivo "+ xArquivo + CRLF , FILELOG )

If Select( (xTRAB) ) # 0
	( xTRAB )->( DbCloseArea() )
EndIf

If !Empty(xMensagem)
	U_EnvEmail( cDe , cPara , cCc , cAssunto , cMsg , cAnexo )
	FErase( cAnexo )	
EndIf 

RestArea(_aArea)
Return Nil

/***************************************************************/
/* Carrega dados em array para montar a interface CONEMB					*/
/***************************************************************/
Static Function fArrayCONEMB()
Local _aDetAux 	:= Array(CON_Det_SubstTrib)
Local _nVrPedag	:= GetAdvFVal('DT8','DT8_VALTOT',xFilial("DT8")+(xTRAB)->DTC_VIAGEM + 'G2',6,0) // DT3_CODPAS = "G2" 
Local _nVrADV  	:= GetAdvFVal('DT8','DT8_VALTOT',xFilial("DT8")+(xTRAB)->DTC_VIAGEM + 'G1',6,0) // DT3_CODPAS = "G1"
Local _lNFS		:= AllTrim((xTRAB)->F2_SERIE) == "9"
Local _lCTe		:= AllTrim((xTRAB)->F2_SERIE) == "5"

// Monta Detalhes
_aDetAux[CON_Det_IdInfo			] 	:= "333"
_aDetAux[CON_Det_TpReg			] 	:= "2"
_aDetAux[CON_Det_CodIdMichelin	]	:= PadL(Val(IIF(_lCTe,(xTRAB)->CNPJ_REM,(xTRAB)->CNPJ_FAT)),14,"0")
_aDetAux[CON_Det_NumNota			] 	:= PadL(IIF(_lNFS,AllTrim((xTRAB)->F2_NFELETR)  ,AllTrim((xTRAB)->DTC_NUMNFC)),12,"0")
_aDetAux[CON_Det_SerieNota		] 	:= PadL(IIF(_lNFS,"000",AllTrim((xTRAB)->DTC_SERNFC)),03,"0")
_aDetAux[CON_Det_NumCTe			] 	:= PadL(AllTrim((xTRAB)->F2_DOC),15,"0")
_aDetAux[CON_Det_ValorCTe		] 	:= STRTRAN(STRZERO((xTRAB)->F2_VALBRUT,11,2),".","")
_aDetAux[CON_Det_SerieCTe		] 	:= PadL(AllTrim((xTRAB)->F2_SERIE),3,"0")
_aDetAux[CON_Det_DataCTe			] 	:= PadR((xTRAB)->F2_EMISSAO,8)
_aDetAux[CON_Det_CFOP			] 	:= PadR(AllTrim((xTRAB)->D2_CF),10)
_aDetAux[CON_Det_AliqICMS		] 	:= STRTRAN(STRZERO(IIF(_lCTe,(xTRAB)->D2_PICM,0),11,2),".","")
_aDetAux[CON_Det_ValorICMS 		] 	:= STRTRAN(STRZERO((xTRAB)->F2_VALICM ,11,2),".","")
_aDetAux[CON_Det_AliqISS			] 	:= STRTRAN(STRZERO((xTRAB)->F2_VALISS ,11,2),".","")
_aDetAux[CON_Det_ValorISS		] 	:= STRTRAN(STRZERO(IIF(_lNFS,(xTRAB)->D2_ALIQISS,0),11,2),".","")
_aDetAux[CON_Det_NatCarga		] 	:= Space(20)
_aDetAux[CON_Det_NatDest			] 	:= Space(20)
_aDetAux[CON_Det_CNPJCliente	] 	:= PadR(PadL(Val((xTRAB)->CNPJ_FAT),14,"0"),20)
_aDetAux[CON_Det_IDCTeComplem	] 	:= Space(20)
_aDetAux[CON_Det_Reservado1		] 	:= Space(10)
_aDetAux[CON_Det_Reservado2		] 	:= Space(10)
_aDetAux[CON_Det_Reservado3		] 	:= Space(20)
_aDetAux[CON_Det_BaseICMS		] 	:= STRTRAN(STRZERO((xTRAB)->F2_BASEICM,11,2),".","")
_aDetAux[CON_Det_BaseISS			] 	:= STRTRAN(STRZERO((xTRAB)->F2_BASEISS,11,2),".","")
_aDetAux[CON_Det_IdentDoc		] 	:= PADR((xTRAB)->TIPO_DOC,4)
_aDetAux[CON_Det_ChaveVld		] 	:= PADR(IIF(_lCTe,(xTRAB)->F2_CHVNFE, AllTrim((xTRAB)->F2_CODNFE)),44)
_aDetAux[CON_Det_VrPedagio		] 	:= STRTRAN(STRZERO(_nVrPedag,11,2),".","")
_aDetAux[CON_Det_VrADV			] 	:= STRTRAN(STRZERO(_nVrADV,  11,2),".","")
_aDetAux[CON_Det_SubstTrib		] 	:= IIF((xTRAB)->F2_BASETST > 0, "1", "2")
		
Return( _aDetAux )

/***************************************************************/
/* Carrega dados para montar a interface CONEMB					*/
/***************************************************************/
Static Function fQryCONEMB()
Local _lRet  	:= .T.
Local _aRet  	:= {}
Local _cDtIni	:= ""
Local _cDtFin	:= ""
Local _cFilial	:= ""
// Local _cFilFin	:= ""
Local _cPar  	:= ""
Local _cCliDev	:= GetMV("ES_DEVMICH")
Local _aArea 	:= GetArea()
Local _nReproc	:= 0
Local _nTipoDoc	:= 0

_cFilial	:= MV_PAR01
_cDtIni		:= DTOS(MV_PAR02)
_cDtFin		:= DTOS(MV_PAR03)

If ValType( MV_PAR04 ) == 'N'
	_nTipoDoc	:= 1
Else
	_nTipoDoc	:= 2	
EndIf

If ValType( MV_PAR05 ) == 'N'
	_nReproc	:= 1
Else
	_nReproc	:= 2	
EndIf

xTRAB := GetNextAlias()

_cPar := " AND SA1_FAT.A1_CGC IN" + FORMATIN(_cCliDev,"|")

If _nReproc <> 1
	_cPar += " AND F2_XMICCON = '' "
EndIf

If _nTipoDoc == 1
	_cPar += " AND F2_SERIE = '5' "
Else	
	_cPar += " AND F2_SERIE = '9' "
EndIf

_cPar := "%"+_cPar+"%"

BeginSql Alias xTRAB

	// column ZA6_DTINI as Date, ZA7_VALOR  as Numeric(18,2), DATA_INI as Date

	%noparser%
	
	SELECT DISTINCT ISNULL(DT6_FILDOC,'') AS DT6_FILDOC, ISNULL(DT6_DOC,'') AS DT6_DOC, ISNULL(DT6_VALTOT,0) AS DT6_VALTOT, ISNULL(DT6_SERIE,'') AS DT6_SERIE, 
			ISNULL(DT6_DATEMI,'') AS DT6_DATEMI, ISNULL(DTC_NUMNFC,'') AS DTC_NUMNFC, ISNULL(DTC_SERNFC,'') AS DTC_SERNFC, ISNULL(DTC_VIAGEM,'') AS DTC_VIAGEM, 
			F2_VALICM, D2_CF, D2_PICM, F2_EMISSAO, F2_DOC, F2_SERIE, F2_VALBRUT, F2_VALMERC, SA1_FAT.A1_CGC AS CNPJ_FAT, F2_VALISS, D2_ALIQISS,
			F2_BASEICM, F2_BASEISS, TIPO_DOC = CASE WHEN F2_SERIE='5' THEN '57' ELSE '56' END, F2_CHVNFE, F2_BASETST, F2_NFELETR, F2_EMINFE, F2_CODNFE,
			ISNULL(SA1_REM.A1_CGC,'') AS CNPJ_REM, ISNULL(SA1_REM.A1_NOME,'') AS CLI_REM, ISNULL(SA1_DEV.A1_CGC,'') AS CNPJ_DEV, ISNULL(SA1_DEV.A1_NOME,'') AS CLI_DEV
		  FROM %Table:SF2% SF2
		  LEFT JOIN %Table:SD2% SD2
		    ON F2_FILIAL = D2_FILIAL
		   AND F2_DOC    = D2_DOC
		   AND F2_SERIE  = D2_SERIE
		   AND SD2.%NotDel%		  		   			
		  LEFT JOIN %Table:DT6% DT6 
		    ON F2_FILIAL = DT6_FILDOC 
		   AND F2_DOC    = DT6_DOC    
		   AND F2_SERIE  = DT6_SERIE
		   AND DT6.%NotDel% 	
		  LEFT JOIN %Table:DTC% DTC 
		    ON DT6_FILDOC = DTC_FILORI
		   AND DT6_LOTNFC = DTC_LOTNFC
		   AND DTC.%NotDel%		    	
		  LEFT JOIN %Table:SA1% SA1_REM
		    ON DT6_CLIREM = SA1_REM.A1_COD
		   AND DT6_LOJREM = SA1_REM.A1_LOJA
		   AND SA1_REM.%NotDel%		    
		  LEFT JOIN %Table:SA1% SA1_DEV
		    ON DT6_CLIDEV = SA1_DEV.A1_COD
		   AND DT6_LOJDEV = SA1_DEV.A1_LOJA
		   AND SA1_DEV.%NotDel%,		    
		   %Table:SA1% SA1_FAT		   
		 WHERE F2_EMISSAO BETWEEN %Exp:_cDtIni%  AND %Exp:_cDtFin%
		   AND F2_FILIAL  = %Exp:_cFilial% 
		   AND F2_CLIENTE = SA1_FAT.A1_COD
		   AND F2_LOJA    = SA1_FAT.A1_LOJA
		   AND SF2.%NotDel%
		   AND SA1_FAT.%NotDel%		   
    
	    %Exp:_cPar%
    
	ORDER BY DT6_FILDOC, DT6_DOC, DT6_SERIE, DTC_NUMNFC, DTC_SERNFC   

EndSql

_aQuery := GetLastQuery()

MEMOWRIT("C:\TEMP\GPOMichelin.SQL",_aQuery[2])

//AND A1_CGC IN ('04683697000101','65967226000101','50567288000582','50567288000663','50567288000400','50567288000744','39624465000159','04688196000100','50567288000159')

RestArea(_aArea)
Return _lRet

/**********************************************************************/
/* Grava dados no arquivo TXT da interface CONEMB						*/
/**********************************************************************/
Static Function fGravaCONEMB(_aCab, _aCONEMB,_aRod, _nHandle, _nTamLin)
Local _cLinha := ""
Local _nX		:= 0
_nTamArq 		:= 0

For _nX := 1 TO Len(_aCab) 
	_cLinha += _aCab[_nX]  
Next _nX
_cLinha += CRLF
nTamArq := FSeek( _nHandle , 0 , 2 )
FWrite(_nHandle, _cLinha)

_cLinha:=""
For _nX := 1 TO Len(_aCONEMB)
	_cLinha := ""
	For Y := 1 To Len(_aCONEMB[_nX])
		_cLinha += _aCONEMB[_nX,Y]
	Next Y		
	_cLinha += CRLF
	nTamArq := FSeek( _nHandle , 0 , 2 )	 
	FWrite(_nHandle, _cLinha)
Next _nX

_cLinha:=""
For _nX := 1 TO Len(_aRod)
	_cLinha += _aRod[_nX] 
Next _nX
_cLinha += CRLF
_nTamArq := FSeek( _nHandle , 0 , 2 )
FWrite(_nHandle, _cLinha)
	
Return Nil

/*
Programa	: GEFR022
Funcao		: Função Estatica - AjustaParam
Data		: 26/04/2016
Autor		: U297686 - Ricardo Guimarães
Descricao	: Função de Apoio
Uso			: Ajusta os Parametros do Relatorio
Sintaxe	: AjustaParam()
Chamenda	: Interna
Retorno	: Logico
*/
Static Function AjustaParam()

	Local aParamBox	:= {}
	Local aRet			:= {}

	Local lRetorno	:= .F.
	Local lCanSave	:= .T.
	Local lUserSave	:= .T.
	
	Local aCombo		:= {"Sim","Nao"}
	Local aTipo		:= {"CT-e","NFS-e"}	

	Local cLoad		:= "GPOMichelin"

	aAdd(aParamBox,{1,"Filial "	       ,Space(GetSx3Cache("DT6_FILDOC","X3_TAMANHO")),"@!","",""		,"",05 ,.F.})
//	aAdd(aParamBox,{1,"Filial Final"	,Space(GetSx3Cache("DT6_FILDOC","X3_TAMANHO")),"@!","",""		,"",05	,.F.})

	aAdd(aParamBox,{1,"Data Inicial"	,Ctod(Space(8))	,""		,""	,"","",50,.F.})
	aAdd(aParamBox,{1,"Data Final"		,Ctod(Space(8))	,""		,""	,"","",50,.F.})
	aAdd(aParamBox,{2,"Tipo de Doc."   ,1,aTipo,50,"",.F.})
	aAdd(aParamBox,{2,"Reprocessa"     ,1,aCombo,50,"",.F.})

	If	ParamBox(aParamBox,"Parâmetros...",@aRet,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPosX*/,/*nPosy*/,/*oDlgWizard*/,cLoad,lCanSave,lUserSave)
		lRetorno	:= .T.
	Endif

Return( lRetorno )

//--------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} GPOPLANEMB
//TODO Gera interface Plano de Embarque da Michelin.
@author u297686 - Ricardo Guimarães
@since 10/05/2016
@version 1.0
@param _cInterface
@param _lAuto
@type function
/*/

User Function GPOPLANEMB(_lAuto)
Local _aArea 	 	:= GetArea()
Local _aArqs 	 	:= {}
Local _cPathDest 	:= ""
Local _nX		 	:= 0
Local _cArqTXT 	:= ""
Local _aPLANEMB 	:= {}
Local _cArqORIG 	:= ""

Local cDe			:= GetMv("MV_RELFROM")
Local cPara		:= UsrRetMail( RetCodUsr() )
Local cCc			:= ''
Local cAssunto	:= 'Log de erro da Importação do EDI - Michelan'
Local cMsg			:= 'Segue em anexo o arquivo com as informações de erro ocorridos na Importação.'
Local cAnexo		:= '\SYSTEM\'+FILELOG
Local lLog			:= .F.
Local _nHandle	:= 0
Local _cDocAnt	:= ""
Local _cSerAnt	:= ""
Local _aReg   	:= {}
Local _nSeqArq	:= 0
Local _aCab   	:= Array()
Local _aRod   	:= Array()
Local _nCntLin	:= 1
Local _nTamLin	:= 160
Local _cPrefArq 	:= GETNEWPAR("ES_PLANEMB","SHI_09520598_")
Local _nRecTot	:= 0

// Perguntas
If !AjuParPlanEmb()
	Return .F.
EndIf	
 
 // Cabeçalho
_aCab[242_Cab_IdInfo] 		:= "777" 
_aCab[242_Cab_TpReg] 		:= "1"
_aCab[242_Cab_CNPJTransp]	:= PadR(SM0->M0_CGC,14)
_aCab[242_Cab_IdParcCom] 	:= "09520598"
_aCab[242_Cab_NumCarro] 		:= Space(11) // Reservado 8,2
_aCab[242_Cab_CodTransp] 	:= Space(10) // Reservado
_aCab[242_Cab_ModTransp] 	:= Space(20) // Reservado
_aCab[242_Cab_SeqChegada] 	:= Space(20) // Reservado
_aCab[242_Cab_TipoEquip] 	:= Space(20) // Reservado 
_aCab[242_Cab_NivelServ]		:= Space(20) // Reservado
_aCab[242_Cab_CodTransRed]	:= Space(20) // Reservado
_aCab[242_Cab_LocalEmb] 		:= Space(20) // Reservado
_aCab[242_Cab_SiteEmb] 		:= Space(20) // Reservado
_aCab[242_Cab_PaisEmb] 		:= Space(20) // Reservado 
_aCab[242_Cab_CodTpEquip] 	:= Space(20) // Reservado
_aCab[242_Cab_ModCarreg] 	:= Space(20) // Reservado
 
// Pega os dados à serem enviadas no CONEMB
Processa( {|| fQryPLANEMB() },"Processando...", "Carragendo dados para geração do interface Plano de Embarque ...",.F.)
//fQryCONEMB()

(xTRAB)->( DbGoTop() )
If (xTRAB)->(Eof())
	Aviso("Aviso - Interface PLANEMB",'Não há dados da Michelin para geração da interface de Plano de Embarque.',{"Ok"},1)
	If Select( (xTRAB) ) # 0
		( xTRAB )->( DbCloseArea() )
	EndIf	
	Return .F.
EndIf

( xTRAB )->( DbEval( { || _nRecTot += 1 } ) )
(xTRAB)->( DbGoTop() )

ProcRegua(_nRecTot)

xMensagem := ""

_cArqTXT  := _cPrefArq + DTOS(dDATABASE) + "_" + StrTran(Time(),":","") + ".TXT"
MONTADIR(cPATHCONEMB)
_cArqORIG := cPATHCONEMB + _cArqTXT

_nHandle := FCREATE(_cArqOrig, FC_NORMAL)
		
If _nHandle == -1
	xMensagem += "Não foi possível a criação do Arquivo " + _cArqTXT + ":" + STR(FERROR())"
    MsgAlert("Não foi possível a criação do Arquivo :" + _cArqTXT + ":" + STR(FERROR()))
	Return NIl
EndIf

_aCONEMB := {}

While !(xTRAB)->(Eof())
	IncProc()
	
	//_cDOCAnt := (xTRAB)->DT6_DOC
	//_cSerAnt := (xTRAB)->DT6_SERIE
	
//	While !xTRAB->(Eof()) .AND. _cDOCAnt == (xTRAB)->DT6_DOC .AND. _cSerAnt == (xTRAB)->DT6_SERIE 

		Processa( {|| _aReg := fArrayPLANEMB() }, "Processando...","Carragendo matriz com os dados para geração da interface de Plano de Embarque ...",.F.)
		
		If Len(_aReg) == 0
			Loop
		EndIf
	
		AADD(_aPLANEMB, _aReg)
		_nCntLin++
		
		(xTRAB)->(dbSkip())
//	End

	_nSeqArq++
	
End

// Rodapé
_aRod[242_Rod_IdInfo] 		:= "777"
_aRod[242_Rod_TpReg]			:= "3"
_aRod[242_Rod_QtdLinhas]		:= StrZero((_nCntLin+1),5)

If Len(_aPLANEMB) > 0
	fGravaPLANEMB(_aCab, _aPLANEMB,_aRod, _nHandle, _nTamLin)
	fClose(_nHandle)
	
	xMensagem += "Arquivo Plano de Embarque criado " + _cArqTXT + CRLF
	xMensagem += "Total de linhas geradas " + StrZero((_nCntLin+1),4) + CRLF
	
	MsgInfo("Arquivo de Plano de Embarque gerado: " + _cArqTXT )
Else	
	xMensagem += "Arquivo de Plano de Embarque NÃO criado " + _cArqTXT + ":" + STR(FERROR())		
EndIf
			
xArquivo	:= _cArqTXT
xOperacao	:= ''
lLog		:= .T.
StaticCall( GEFCNHAST , LogThis , CRLF + "Inicio do Arquivo " + xArquivo + "." + CRLF + xMensagem + CRLF + "Fim do Arquivo "+ xArquivo + CRLF , FILELOG )

If Select( (xTRAB) ) # 0
	( xTRAB )->( DbCloseArea() )
EndIf

If !Empty(xMensagem)
	U_EnvEmail( cDe , cPara , cCc , cAssunto , cMsg , cAnexo )
	FErase( cAnexo )	
EndIf 

RestArea(_aArea)
Return Nil

/***************************************************************/
/* Carrega dados em array para montar a interface Shipment Plan*/
/***************************************************************/
Static Function fArrayPLANEMB()
Local _aDetAux := Array(242_Det_Quantidade)

// Monta Detalhes
_aDetAux[242_Det_IdInfo			] 	:= "777"
_aDetAux[242_Det_TpReg			] 	:= "2"
_aDetAux[242_Det_CNPJMichelin	]	:= ""
_aDetAux[242_Det_NumCarga		] 	:= ""
_aDetAux[242_Det_CodItem			] 	:= ""
_aDetAux[242_Det_OrdemCarreg	] 	:= ""
_aDetAux[242_Det_CodDest			] 	:= ""
_aDetAux[242_Det_Dest			] 	:= ""
_aDetAux[242_Det_DatPrevPartida	] 	:= ""
_aDetAux[242_Det_DatPrevEntrega	] 	:= ""
_aDetAux[242_Det_Quantidade		] 	:= ""
		
Return( _aDetAux )

/***************************************************************/
/* Carrega dados para montar a interface CONEMB					*/
/***************************************************************/
Static Function fQryPLANEMB()
Local _lRet  	:= .T.
Local _aRet  	:= {}
Local _dDtIni	:= CTOD("//")
Local _dDtFin	:= CTOD("//")
Local _cFilIni:= ""
Local _cFilFin:= ""
Local _cPar  	:= ""
Local _cCliDev:= GetMV("ES_DEVMICH")
Local _aArea 	:= GetArea()
Local _cReproc:= ""

_cFilIni	:= MV_PAR01
_cFilFin	:= MV_PAR02
_dDtIni	:= MV_PAR03
_dDtFin	:= MV_PAR04
_cReproc	:= MV_PAR05

xTRAB := GetNextAlias()

_cPar := " AND SA1_DEV.A1_CGC IN" + FORMATIN(_cCliDev,"|")

If _cReproc <> "S"
	_cPar += " AND F2_XMICCON = '' "
EndIf

_cPar := "%"+_cPar+"%"

BeginSql Alias xTRAB

	// column ZA6_DTINI as Date, ZA7_VALOR  as Numeric(18,2), DATA_INI as Date

	%noparser%
	
	SELECT DISTINCT DT6_FILDOC, DT6_DOC, DT6_VALTOT, DT6_SERIE, DT6_DATEMI, DTC_NUMNFC, DTC_SERNFC, F2_VALICM, D2_CF, D2_PICM,
			F2_VALISS, D2_ALIQISS, SA1_REM.A1_CGC AS CNPJ_REM, SA1_REM.A1_NOME AS CLI_REM, SA1_DEV.A1_CGC AS CNPJ_DEV, SA1_DEV.A1_NOME AS CLI_DEV
		  FROM %Table:DT6% DT6, %Table:SF2% SF2, %Table:DTC% DTC, %Table:SD2% SD2, %Table:SA1% SA1_REM, %Table:SA1% SA1_DEV
		 WHERE DT6_DATEMI BETWEEN %Exp:_dDtIni%  AND %Exp:_dDtFin%
		   AND DT6_FILDOC BETWEEN %Exp:_cFilIni% AND %Exp:_cFilFin%
		   AND DT6_FILDOC = DTC_FILORI
		   AND DT6_LOTNFC = DTC_LOTNFC
		   AND DT6_FILDOC = F2_FILIAL
		   AND DT6_DOC    = F2_DOC
		   AND DT6_SERIE  = F2_SERIE
		   AND DT6_CLIREM = SA1_REM.A1_COD
		   AND DT6_LOJREM = SA1_REM.A1_LOJA	   
		   AND DT6_CLIDEV = SA1_DEV.A1_COD
		   AND DT6_LOJDEV = SA1_DEV.A1_LOJA
		   AND DT6_FILDOC = D2_FILIAL
		   AND DT6_DOC    = D2_DOC
		   AND DT6_SERIE  = D2_SERIE
		   AND DT6.%NotDel%
		   AND DTC.%NotDel%
		   AND SF2.%NotDel%
		   AND SD2.%NotDel%
		   AND SA1_REM.%NotDel%
		   AND SA1_DEV.%NotDel%
    
	    %Exp:_cPar%
    
	ORDER BY DT6_FILDOC, DT6_DOC, DT6_SERIE, DTC_NUMNFC, DTC_SERNFC   

EndSql

_aQuery := GetLastQuery()

//MEMOWRIT("D:\TEMP\GPOMichelin.SQL",_aQuery[2])

//AND A1_CGC IN ('04683697000101','65967226000101','50567288000582','50567288000663','50567288000400','50567288000744','39624465000159','04688196000100','50567288000159')

RestArea(_aArea)
Return _lRet

/**********************************************************************/
/* Grava dados no arquivo TXT da interface CONEMB						*/
/**********************************************************************/
Static Function fGravaPLANEMB(_aCab, _aCONEMB,_aRod, _nHandle, _nTamLin)
Local _cLinha := ""
Local _nX		:= 0
_nTamArq 		:= 0

For _nX := 1 TO Len(_aCab) 
	_cLinha += _aCab[_nX]  
Next _nX
_cLinha += CRLF
nTamArq := FSeek( _nHandle , 0 , 2 )
FWrite(_nHandle, _cLinha)

_cLinha:=""
For _nX := 1 TO Len(_aCONEMB)
	_cLinha := ""
	For Y := 1 To Len(_aCONEMB[_nX])
		_cLinha += _aCONEMB[_nX,Y]
	Next Y		
	_cLinha += CRLF
	nTamArq := FSeek( _nHandle , 0 , 2 )	 
	FWrite(_nHandle, _cLinha)
Next _nX

_cLinha:=""
For _nX := 1 TO Len(_aRod)
	_cLinha += _aRod[_nX] 
Next _nX
_cLinha += CRLF
_nTamArq := FSeek( _nHandle , 0 , 2 )
FWrite(_nHandle, _cLinha)
	
Return Nil

/*
Programa	: GPOMichelin
Funcao		: Função Estatica - AjuParPlanEmb
Data		: 10/05/2016
Autor		: U297686 - Ricardo Guimarães
Descricao	: Função de Apoio
Uso			: Ajusta os Parametros da rotina
Sintaxe	: AjuParPlanEmb()
Chamenda	: Interna
Retorno	: Logico
*/
Static Function AjuParPlanEmb()

	Local aParamBox	:= {}
	Local aRet			:= {}

	Local lRetorno	:= .F.
	Local lCanSave	:= .T.
	Local lUserSave	:= .T.
	
	Local aCombo		:= {"Sim","Nao"}

	Local cLoad		:= "GPOMichelin"

	aAdd(aParamBox,{1,"Filial "	,Space(GetSx3Cache("DT6_FILDOC","X3_TAMANHO")),"@!","",""		,"",05 ,.F.})
//	aAdd(aParamBox,{1,"Filial Final"	,Space(GetSx3Cache("DT6_FILDOC","X3_TAMANHO")),"@!","",""		,"",05	,.F.})

	aAdd(aParamBox,{1,"Data Inicial"	,Ctod(Space(8))	,""		,""	,"","",50,.F.})
	aAdd(aParamBox,{1,"Data Final"		,Ctod(Space(8))	,""		,""	,"","",50,.F.})

	aAdd(aParamBox,{2,"Reprocessa",1,aCombo,50,"",.F.})

	If	ParamBox(aParamBox,"Parâmetros...",@aRet,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPosX*/,/*nPosy*/,/*oDlgWizard*/,cLoad,lCanSave,lUserSave)
		lRetorno	:= .T.
	Endif

Return( lRetorno )

// OCORRENCIA - WSH253
//--------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} GPOOCOMICH
//TODO Gera interface de OCORRENCIA da Michelin.
@author u297686 - Ricardo Guimarães
@since 31/05/2016
@version 1.0
@param _cInterface
@param _lAuto
@type function
/*/

User Function GPOOCOMICH(_lAuto)
Local _aArea 	 	:= GetArea()
Local _aArqs 	 	:= {}
Local _cPathDest 	:= ""
Local _nX		 	:= 0
Local _cArqTXT 	:= ""
Local _aOCORREN 	:= {}
Local _cArqORIG 	:= ""
Local _cIdParCom	:= GetNewPar("ES_GEFMICH","09520598" )
Local cDe			:= GetMv("MV_RELFROM")
Local cPara		:= UsrRetMail( RetCodUsr() )
Local cCc			:= ''
Local cAssunto	:= 'Log de erro da Exportação do EDI - Michelan'
Local cMsg			:= 'Segue em anexo o arquivo com as informações de erro ocorridos na Importação.'
Local cAnexo		:= '\SYSTEM\'+FILELOG
Local lLog			:= .F.
Local _nHandle	:= 0
Local _cDocAnt	:= ""
Local _cSerAnt	:= ""
Local _aReg   	:= {}
Local _nSeqArq	:= 1
Local _aCab   	:= Array(253_Cab_ModCarreg)
Local _aRod   	:= Array(253_Rod_QtdLinhas)
Local _nCntLin	:= 1
Local _nTamLin	:= 160
Local _cPrefArq 	:= GetNewPar("ES_OCOMICH","PRO_09520598_")
Local _cFilial	:= GetNewPar("ES_FILMICH","19")
Local _nRecTot	:= 0
Local xMensagem	:= ''
Local xOperacao	:= ''

Private _cOco		:= ""

// Perguntas
If !AjuParOCO()
	Return .F.
EndIf	
 
 // Cabeçalho
_aCab[253_Cab_IdInfo] 		:= "444" 
_aCab[253_Cab_TpReg] 		:= "1"
_aCab[253_Cab_CNPJTransp]	:= PadR(GetAdvFVal('SM0','M0_CGC',cEmpAnt+_cFilial,1,''),14)
_aCab[253_Cab_IdParcCom] 	:= _cIdParCom
_aCab[253_Cab_NumCarro] 		:= Space(11) // Reservado 8,2
_aCab[253_Cab_CodTransp] 	:= Space(10) // Reservado
_aCab[253_Cab_ModTransp] 	:= Space(20) // Reservado
_aCab[253_Cab_SeqChegada] 	:= Space(20) // Reservado
_aCab[253_Cab_TipoEquip] 	:= Space(20) // Reservado 
_aCab[253_Cab_NivelServ]		:= Space(20) // Reservado
_aCab[253_Cab_CodTransRed]	:= Space(20) // Reservado
_aCab[253_Cab_LocalEmb] 		:= Space(20) // Reservado
_aCab[253_Cab_SiteEmb] 		:= Space(20) // Reservado
_aCab[253_Cab_PaisEmb] 		:= Space(20) // Reservado 
_aCab[253_Cab_CodTpEquip] 	:= Space(20) // Reservado
_aCab[253_Cab_ModCarreg] 	:= Space(20) // Reservado
 
// Pega os dados à serem enviadas no OCORREN
Processa( {|| fQryOCORREN(_cFilial) },"Processando...", "Carragendo dados para geração da interface de Ocorrência ...",.F.)

(xTRAB)->( DbGoTop() )
If (xTRAB)->(Eof())
	Aviso("Aviso - Interface OCORREN",'Não há dados da Michelin para geração da interface de Ocorrência.',{"Ok"},1)
	If Select( (xTRAB) ) # 0
		( xTRAB )->( DbCloseArea() )
	EndIf	
	Return .F.
EndIf

(xTRAB)->( DbEval( { || _nRecTot += 1 } ) )
(xTRAB)->( DbGoTop() )

ProcRegua(_nRecTot)

xMensagem := ""

While !(xTRAB)->(Eof())
	IncProc()

	_nCntLin	:= 1

	_cArqTXT  	:= _cPrefArq + DTOS(dDATABASE) + "_" + StrTran(Time(),":","") + "_" + StrZero(_nSeqArq,3) + ".TXT"
	MONTADIR(cPATHOCORREN)
	_cArqORIG 	:= cPATHOCORREN + _cArqTXT
	
	_nHandle 	:= FCREATE(_cArqOrig, FC_NORMAL)
			
	If _nHandle == -1
		xMensagem += "Não foi possível a criação do Arquivo " + _cArqTXT + ":" + STR(FERROR())"
	    MsgAlert("Não foi possível a criação do Arquivo :" + _cArqTXT + ":" + STR(FERROR()))
		Return NIl
	EndIf

	_aOCORREN 	:= {}	
	_cDOCAnt 	:= (xTRAB)->DTC_DOC
	_cSerAnt 	:= (xTRAB)->DTC_SERIE
	
	While !(xTRAB)->(Eof()) .AND. _cDOCAnt == (xTRAB)->DTC_DOC .AND. _cSerAnt == (xTRAB)->DTC_SERIE 

		Processa( {|| _aReg := fArrayOCO() }, "Processando...","Carragendo matriz com os dados para geração da interface de Ocorrência ...",.F.)
		
		If Len(_aReg) == 0
			Loop
		EndIf
	
		AADD(_aOCORREN, _aReg)
		_nCntLin++
		
		(xTRAB)->(dbSkip())
	End

	_nSeqArq++
	
	// Rodapé
	_aRod[253_Rod_IdInfo] 		:= "444"
	_aRod[253_Rod_TpReg]			:= "3"
	_aRod[253_Rod_QtdLinhas]		:= StrZero((_nCntLin+1),5)
	
	If Len(_aOCORREN) > 0
		fGravaOCORREN(_aCab, _aOCORREN,_aRod, _nHandle, _nTamLin)
		fClose(_nHandle)
		
		xMensagem += "Arquivo de Ocorrência criado " + _cArqTXT + CRLF
		xMensagem += "Total de linhas geradas " + StrZero((_nCntLin+1),4) + CRLF
		
		//MsgInfo("Arquivo de Ocorrência gerado: " + _cArqTXT )
	Else	
		xMensagem += "Arquivo de Ocorrência NÃO criado " + _cArqTXT + ":" + STR(FERROR())		
	EndIf
	
End

xArquivo	:= _cArqTXT
xOperacao	:= ''
lLog		:= .T.
StaticCall( GEFCNHAST , LogThis , CRLF + "Inicio do Arquivo " + xArquivo + "." + CRLF + xMensagem + CRLF + "Fim do Arquivo "+ xArquivo + CRLF , FILELOG )

If Select( (xTRAB) ) # 0
	( xTRAB )->( DbCloseArea() )
EndIf

If !Empty(xMensagem)
	U_EnvEmail( cDe , cPara , cCc , cAssunto , cMsg , cAnexo )
	FErase( cAnexo )	
EndIf 

RestArea(_aArea)
Return Nil

/***************************************************************/
/* Carrega dados em array para montar a interface Shipment Plan*/
/***************************************************************/
Static Function fArrayOCO()
Local _aDetAux 		:= Array(253_Det_QtdNaoEntreg)
LoCAL _cDtEntregReal := DtoS(MV_PAR08)
LoCAL _cDtOcorrencia := DtoS(MV_PAR06)

_cDtEntregReal := Right(_cDtEntregReal,2)+'/'+SubStr(_cDtEntregReal,5,2)+'/'+Left(_cDtEntregReal,4)
_cDtOcorrencia := Right(_cDtOcorrencia,2)+'/'+SubStr(_cDtOcorrencia,5,2)+'/'+Left(_cDtOcorrencia,4)

// Monta Detalhes
_aDetAux[253_Det_IdInfo			] 	:= "444"
_aDetAux[253_Det_TpReg			] 	:= "2"
_aDetAux[253_Det_CNPJMichelin	]	:= PadR((xTRAB)->(CNPJ_REM),14)
_aDetAux[253_Det_NumNFC			] 	:= StrZero(Val(AllTrim((xTRAB)->(DTC_NUMNFC))),12) 
_aDetAux[253_Det_SerieNFC		] 	:= PadR((xTRAB)->(DTC_SERNFC),3)
_aDetAux[253_Det_Ocorrencia		] 	:= Left(_cOco,2)
_aDetAux[253_Det_ObsOco			] 	:= Space(60)  // Como a Gefco não envia o Shipment Plan, este campo não deve ser preenchido 
_aDetAux[253_Det_CodObsOco		] 	:= "03"
_aDetAux[253_Det_DataOco			] 	:= _cDtOcorrencia 
_aDetAux[253_Det_HoraOco			] 	:= MV_PAR07
_aDetAux[253_Det_DataEntregReal	] 	:= _cDtEntregReal 
_aDetAux[253_Det_HoraEntregReal	] 	:= MV_PAR09
_aDetAux[253_Det_ProdNaoEntreg	] 	:= Space(30)
_aDetAux[253_Det_QtdNaoEntreg	] 	:= "00000"

Return( _aDetAux )

/***************************************************************/
/* Carrega dados para montar a interface CONEMB					*/
/***************************************************************/
Static Function fQryOCORREN(_cFilMich)
Local _lRet  		:= .T.
Local _aRet  		:= {}
Local _dDtIni		:= CTOD("//")
Local _dDtFin		:= CTOD("//")
Local _cFilial	:= _cFilMich  // GetNewPar("ES_FILMICH","19")
Local _cPar  		:= ""
Local _cCliDev	:= GetMV("ES_DEVMICH")
Local _aArea 		:= GetArea()
Local _cReproc	:= ""
Local _cDocIni	:= ""
Local _cDocFin	:= ""

_dDtIni	:= MV_PAR01
_dDtFin	:= MV_PAR02
_cDocIni	:= MV_PAR03
_cDocFin	:= MV_PAR04

//_cReproc	:= MV_PAR05

xTRAB := GetNextAlias()

_cPar := " AND SA1_DEV.A1_CGC IN" + FORMATIN(_cCliDev,"|")

/*
If _cReproc <> "S"
	_cPar += " AND F2_XMICCON = '' "
EndIf
*/

_cPar := "%"+_cPar+"%"

BeginSql Alias xTRAB

	// column ZA6_DTINI as Date, ZA7_VALOR  as Numeric(18,2), DATA_INI as Date

	%noparser%
	
	SELECT DTC_FILORI, DTC_DOC, DTC_SERIE, DTC_DATENT, DTC_NUMNFC, DTC_SERNFC, SA1_REM.A1_CGC AS CNPJ_REM, 
		   SA1_REM.A1_NOME AS CLI_REM, SA1_DEV.A1_CGC AS CNPJ_DEV, SA1_DEV.A1_NOME AS CLI_DEV
		  FROM %Table:DTC% DTC, %Table:SA1% SA1_REM, %Table:SA1% SA1_DEV
		 WHERE DTC_DATENT BETWEEN %Exp:_dDtIni%   AND %Exp:_dDtFin%
		   AND DTC_DOC    BETWEEN %Exp:_cDocIni%  AND %Exp:_cDocFin%
		   AND DTC_FILORI = %Exp:_cFilial% 
		   AND DTC_CLIREM = SA1_REM.A1_COD
		   AND DTC_LOJREM = SA1_REM.A1_LOJA	   
		   AND DTC_CLIDEV = SA1_DEV.A1_COD
		   AND DTC_LOJDEV = SA1_DEV.A1_LOJA
		   AND DTC.%NotDel%
		   AND SA1_REM.%NotDel%
		   AND SA1_DEV.%NotDel%
    
	    %Exp:_cPar%
    
	ORDER BY DTC_FILORI, DTC_DOC, DTC_SERIE, DTC_NUMNFC, DTC_SERNFC   

EndSql

_aQuery := GetLastQuery()

// MEMOWRIT("D:\TEMP\GPOMichelin.SQL",_aQuery[2])

//AND A1_CGC IN ('04683697000101','65967226000101','50567288000582','50567288000663','50567288000400','50567288000744','39624465000159','04688196000100','50567288000159')

RestArea(_aArea)
Return _lRet

/**********************************************************************/
/* Grava dados no arquivo TXT da interface CONEMB						*/
/**********************************************************************/
Static Function fGravaOCORREN(_aCab, _aOCORREN,_aRod, _nHandle, _nTamLin)
Local _cLinha := ""
Local _nX		:= 0
_nTamArq 		:= 0

For _nX := 1 TO Len(_aCab) 
	_cLinha += _aCab[_nX]  
Next _nX
_cLinha += CRLF
nTamArq := FSeek( _nHandle , 0 , 2 )
FWrite(_nHandle, _cLinha)

_cLinha:=""
For _nX := 1 TO Len(_aOCORREN)
	_cLinha := ""
	For Y := 1 To Len(_aOCORREN[_nX])
		_cLinha += _aOCORREN[_nX,Y]
	Next Y		
	_cLinha += CRLF
	nTamArq := FSeek( _nHandle , 0 , 2 )	 
	FWrite(_nHandle, _cLinha)
Next _nX

_cLinha:=""
For _nX := 1 TO Len(_aRod)
	_cLinha += _aRod[_nX] 
Next _nX
_cLinha += CRLF
_nTamArq := FSeek( _nHandle , 0 , 2 )
FWrite(_nHandle, _cLinha)
	
Return Nil

/*
Programa	: GPOMichelin
Funcao		: Função Estatica - AjuParPlanEmb
Data		: 10/05/2016
Autor		: U297686 - Ricardo Guimarães
Descricao	: Função de Apoio
Uso			: Ajusta os Parametros da rotina
Sintaxe	: AjuParPlanEmb()
Chamenda	: Interna
Retorno	: Logico
*/
Static Function AjuParOCO()

	Local aParamBox	:= {}
	Local aRet			:= {}

	Local lRetorno	:= .F.
	Local lCanSave	:= .T.
	Local lUserSave	:= .T.
	
	Local aCombo		:= {"Sim","Nao"}
	Local aComboOco	:= {}

	Local cLoad		:= "GPOMichelin"

	aAdd(aComboOco, "30 - Apreensão fiscal da mercadoria")
	aAdd(aComboOco, "25 - Avaria parcial")
	aAdd(aComboOco, "24 - Avaria total")
	aAdd(aComboOco, "10 - Embalagem sinistrada")
	aAdd(aComboOco, "04 - Endereço do cliente destino não localizado")
	aAdd(aComboOco, "32 - Entrega programada")
	aAdd(aComboOco, "14 - Estabelecimento fechado")
	aAdd(aComboOco, "23 - Estrada/entrada de acesso interditada")
	aAdd(aComboOco, "31 - Excesso de carga/peso")
	aAdd(aComboOco, "27 - Extravio parcial")
	aAdd(aComboOco, "26 - Extravio total")
	aAdd(aComboOco, "19 - Falta com solicitação de reposição")
	aAdd(aComboOco, "03 - Falta de espaço físico no depósito do cliente destino")
	aAdd(aComboOco, "20 - Feriado local/nacional")
	aAdd(aComboOco, "21 - Greve")
	aAdd(aComboOco, "15 - Mercadoria devolvida ao cliente origem")
	aAdd(aComboOco, "06 - Mercadoria em desacordo com pedido de compra")
	aAdd(aComboOco, "29 - Mercadoria em poder da SUFRAMA para internação")
	aAdd(aComboOco, "22 - Mercadoria embarcada para rota indevida")
	aAdd(aComboOco, "09 - Mercadoria sinistrada")
	aAdd(aComboOco, "12 - Mercadorias trocadas")
	aAdd(aComboOco, "16 - Nota Fiscal retida pela fiscalização")
	aAdd(aComboOco, "33 - Outros tipos de ocorrências não especificadas acima")
	aAdd(aComboOco, "11 - Pedido de compras em duplicidade")
	aAdd(aComboOco, "05 - Preço mercadoria em desacordo com pedido de compra")
	aAdd(aComboOco, "18 - Problema com a documentação (Nota Fiscal / CTRC)")
	aAdd(aComboOco, "01 - Recusa por falta de pedido de compra")
	aAdd(aComboOco, "02 - Recusa por pedido de compra cancelado")
	aAdd(aComboOco, "07 - Redespacho não indicado")
	aAdd(aComboOco, "13 - Reentrega solicitada pelo cliente")
	aAdd(aComboOco, "17 - Roubo de carga")
	aAdd(aComboOco, "28 - Sobra de mercadoria sem Nota Fiscal")
	aAdd(aComboOco, "08 - Transportadora não atende a cidade do cliente destino")

//	aAdd(aParamBox,{1,"Filial "			,Space(GetSx3Cache("DT6_FILDOC","X3_TAMANHO")),"@!","",""		,"",05 ,.F.})
//	aAdd(aParamBox,{1,"Filial Final"	,Space(GetSx3Cache("DT6_FILDOC","X3_TAMANHO")),"@!","",""		,"",05	,.F.})

	aAdd(aParamBox,{1,"Data Inicial"		,Ctod(Space(8))									,""				,""	,"","",50,.F.})
	aAdd(aParamBox,{1,"Data Final"			,Ctod(Space(8))									,""				,""	,"","",50,.F.})
	aAdd(aParamBox,{1,"CT-e Inicial"		,Space(GetSx3Cache("DT6_DOC","X3_TAMANHO"))	,"@!"			,""	,"","",50,.F.})
	aAdd(aParamBox,{1,"CT-e Final"			,Space(GetSx3Cache("DT6_DOC","X3_TAMANHO"))	,"@!"			,""	,"","",50,.F.})

	aAdd(aParamBox,{2,"Ocorrência"     	,1,aComboOco,150,"",.F.})

	aAdd(aParamBox,{1,"Data Ocorrência"	,Ctod(Space(8))									,""				,""	,"","",50,.F.})
	aAdd(aParamBox,{1,"Hora Ocorrencia"	,Space(6)											,"@R 99:99:99",""	,"","",50,.F.})

	aAdd(aParamBox,{1,"Data Entrega Real"	,Ctod(Space(8))									,""				,""	,"","",50,.F.})
	aAdd(aParamBox,{1,"Hora Entrega Real"	,Space(6)											,"@R 99:99:99",""	,"","",50,.F.})

	
//	aAdd(aParamBox,{2,"Reprocessa"		,1,aCombo,50,"",.F.})

	 If	ParamBox(aParamBox,"Parâmetros...",@aRet,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPosX*/,/*nPosy*/,/*oDlgWizard*/,cLoad,lCanSave,lUserSave)
	
		If ValType(MV_PAR05) == 'N'
			_cOco := aComboOco[MV_PAR05]
		Else
			_cOco := MV_PAR05	
		EndIf	
		
		lRetorno	:= .T.
	Endif

Return( lRetorno )

*------------------------------------------------------------------------*
// Carga das NF-e´s
*------------------------------------------------------------------------*
/*/{Protheus.doc} GPONFeMich
//TODO Descrição auto-gerada.
@author u297686 - Ricardo Guimarães
@since 18/04/2016
@version 1.0
@param _cInterface, , descricao
@param _lAuto, , descricao
@type function
/*/

User Function GPONFeMich(_lAuto)
Local _aArea 	 := GetArea()
Local _aArqs 	 := {}
Local _cPathDest := ""
Local _nX		 := 0
Local _cArqTXT := ""
Local _aNFe	 := {}
Local _cArqORIG:= ""

Local cDe		:= GetMv("MV_RELFROM")
Local cPara	:= UsrRetMail( RetCodUsr() )
Local cCc		:= ''
Local cAssunto:= 'Log de erro da Importação do EDI(NFe) - Michelin'
Local cMsg		:= 'Segue em anexo o arquivo com as informações de erro ocorridos na Importação.'
Local cAnexo	:= '\SYSTEM\'+FILELOG
Local lLog		:= .F.

// Carregas os XML´s da pasta, recebido da CNH
MONTADIR(cPathNFE)
_aArqs := fCarregaArqs("NFE")

If Len(_aArqs) = 0
	MsgStop("Não há arquvios a serem processados","Aviso")
	Return Nil
EndIf

ProcRegua(Len(_aArqs))

_cPathDEST := cPATHNFE + "BACKUP"
MONTADIR(_cPathDEST)
_cPathDEST := _cPathDEST+"\"

xMensagem := ""

For _nX:=1 to Len(_aArqs)
	IncProc(0)

	_cArqORIG := cPATHNFE + _aArqs[_nX,1]
	_cArqTXT  := _aArqs[_nX,1]
	
	// TXT com error, não processa e move para a pasta backup
	_cArqDEST 	:= _cPathDest + _aArqs[_nX,1]

	_aNFe		:= fLerArqNFe(_cArqORIG)

	If _aNFe[1,NFe_Cab_IdInfo]  <> "222"
		__CopyFile(_cArqORIG,_cArqDEST+"_ERROR")

		// Apaga o arquivo
		fErase(_cArqORIG)
		
		xMensagem += _cArqTXT + " - Arquivo fora do padrão definidio" + CRLF
		Loop
	EndIf

	/* Grava Pedido a Embarcar */
	If fGravaNFe(_aNFe)

		/* Move arquivo para a pasta backup */
		__CopyFile(_cArqORIG,_cArqDEST)
		// Apaga o arquivo
		fErase(_cArqORIG)
	EndIf	

	xArquivo	:= _aArqs[_nX,1]
	xOperacao	:= ''
	// xMensagem	:= 'TESTE'
	lLog		:= .T.
	StaticCall( GEFCNHAST , LogThis , CRLF + "Inicio do Arquivo " + xArquivo + "." + CRLF + xMensagem + CRLF + "Fim do Arquivo "+ xArquivo + CRLF , FILELOG )

Next _nX

If !Empty(xMensagem)
	u_EnvEmail( cDe , cPara , cCc , cAssunto , cMsg , cAnexo )
	FErase( cAnexo )	
EndIf 

RestArea(_aArea)
Return Nil


/*************************************************************/
/* Carrega em um array os arquivos de interfaces da Michelin */
/*************************************************************/
/*
Static Function fCarregaArqs(_cInterface)
Local _aArqs
Local _cPrefArq := GETNEWPAR("ES_PEDEMB","MICH_PE_")

If _cInterface == "PEDEMB"
	// Cria Direotrio
	MontaDir(cPATHPED)

	_aArqs := Directory(cPATHPED + _cPrefArq + "*.TXT",,NIl,.T.,2)
EndIf

Return _aArqs 
*/

/*---------------------------------*/
Static Function fLerArqNFe(_cArqORIG)
/*---------------------------------*/
Local _aCab 		:= Array(NFe_Cab_DTEmisArq)
Local _aDetAux 	:= Array(NFe_Det_LPItem)
Local _aDet		:= {}
Local _aRod 		:= Array(NFe_Rod_QtdLinhas)
Local _aDados		:= {}
Local _nHandle	:= 0
Local _nTotLin	:= 0
Local _cLinha		:= ""
Local _nRecno		:= 0
Local _nHandle	:= 0 

// Abre o arquivo
_nHandle := FT_FUse(_cArqORIG)

// Se houver erro de abertura abandona processamento
If _nHandle = -1  
	xMensagem += _cArqORIG + " - Erro na abertura do arquivo " + CRLF
	Return( _aDados )
endif

// Posiciona na primeria linha
FT_FGoTop()

// Retorna o número de linhas do arquivo
_nTotLin := FT_FLastRec()

_cLinha  := FT_FReadLn()

If SubStr(_cLinha,1,3) <> '222'
	xMensagem += _cArqORIG + " - Arquivo fora do padrão - não carregado. " + CRLF
	Return _aCab
EndIF
	
While !FT_FEOF()   
	
	// Retorna o recno da Linha  
	//MsgAlert( "Linha: " + cLine + " - Recno: " + StrZero(nRecno,3) )    
	
	// Pego Cabeçalho
	If SubStr(_cLinha,4,3) == 'NCC'
		_aCab[NFe_Cab_IdInfo		] := SubStr(_cLinha,001,03) 
		_aCab[NFe_Cab_TpReg		] := SubStr(_cLinha,004,03)
		_aCab[NFe_Cab_CodIdMsg 	] := SubStr(_cLinha,007,15)
		_aCab[NFe_Cab_NumCarreg	] := SubStr(_cLinha,022,30)
		_aCab[NFe_Cab_CNPJTransp	] := SubStr(_cLinha,052,14)
		_aCab[NFe_Cab_IdParcCom 	] := SubStr(_cLinha,066,08)
		_aCab[NFe_Cab_NomeTransp	] := SubStr(_cLinha,074,40)
		_aCab[NFe_Cab_PlacaVeic	] := SubStr(_cLinha,114,10)
		_aCab[NFe_Cab_CNPJMich	] := SubStr(_cLinha,124,14)
		_aCab[NFe_Cab_NFCanc		] := SubStr(_cLinha,138,01)
		_aCab[NFe_Cab_DTEmisArq	] := SubStr(_cLinha,139,08)
	EndIf	

	// Pego Detalhes
	If SubStr(_cLinha,4,3) == 'NC1'
		_aDetAux[NFe_Det_IdInfo				] := SubStr(_cLinha,001,03)
		_aDetAux[NFe_Det_TpReg				] := SubStr(_cLinha,004,03)
		_aDetAux[NFe_Det_CodIdMsg			] := SubStr(_cLinha,007,15)
		_aDetAux[NFe_Det_NumCarreg			] := SubStr(_cLinha,022,30)
		_aDetAux[NFe_Det_CNPJMich			] := SubStr(_cLinha,052,14)
		_aDetAux[NFe_Det_NFCanc				] := SubStr(_cLinha,066,01)
		_aDetAux[NFe_Det_DtEmisNF			] := SubStr(_cLinha,067,08)
		_aDetAux[NFe_Det_NumNFe				] := SubStr(_cLinha,075,12)
		_aDetAux[NFe_Det_SerieNFe			] := SubStr(_cLinha,087,03)
		_aDetAux[NFe_Det_InscEst				] := SubStr(_cLinha,090,20)
		_aDetAux[NFe_Det_ClienteNFe			] := SubStr(_cLinha,110,20)
		_aDetAux[NFe_Det_CFOPNFe				] := SubStr(_cLinha,130,05)
		_aDetAux[NFe_Det_DtEntPrev			] := SubStr(_cLinha,135,08)
		_aDetAux[NFe_Det_HrEntPrev			] := SubStr(_cLinha,143,06)
		_aDetAux[NFe_Det_VrIcmsNFe			] := SubStr(_cLinha,149,10)
		_aDetAux[NFe_Det_VrTotNFe			] := SubStr(_cLinha,159,10)
		_aDetAux[NFe_Det_VrTotProd			] := SubStr(_cLinha,169,10)
		_aDetAux[NFe_Det_PesoBruto			] := SubStr(_cLinha,179,12)
		_aDetAux[NFe_Det_UnMedPeso			] := SubStr(_cLinha,191,02)
		_aDetAux[NFe_Det_QtdTotVol			] := SubStr(_cLinha,193,11)
		_aDetAux[NFe_Det_RazaoSoc			] := SubStr(_cLinha,204,80)
		_aDetAux[NFe_Det_EndNFe				] := SubStr(_cLinha,284,80)
		_aDetAux[NFe_Det_BairroNFe			] := SubStr(_cLinha,364,40)
		_aDetAux[NFe_Det_CEPNFe				] := SubStr(_cLinha,404,12)
		_aDetAux[NFe_Det_CidadeNFe			] := SubStr(_cLinha,416,25)
		_aDetAux[NFe_Det_EstadoNFe			] := SubStr(_cLinha,441,03)
		_aDetAux[NFe_Det_CNPJCPFNFe			] := SubStr(_cLinha,444,20)
		_aDetAux[NFe_Det_InscEstNFe			] := SubStr(_cLinha,464,20)
		_aDetAux[NFe_Det_TelefoneNFe		] := SubStr(_cLinha,484,20)
		_aDetAux[NFe_Det_FretePorConta		] := SubStr(_cLinha,504,01)
		_aDetAux[NFe_Det_EspecieNFe			] := SubStr(_cLinha,505,15)
		_aDetAux[NFe_Det_MarcaNFe			] := SubStr(_cLinha,520,08)
		_aDetAux[NFe_Det_NumNota				] := SubStr(_cLinha,528,15)
		_aDetAux[NFe_Det_AN8TranspRedes		] := SubStr(_cLinha,543,08)
		_aDetAux[NFe_Det_CNPJTranspRedes	] := SubStr(_cLinha,551,20)
		_aDetAux[NFe_Det_InscEstTrpRedes	] := SubStr(_cLinha,571,20)
		_aDetAux[NFe_Det_RazaoTransRedes	] := SubStr(_cLinha,591,40)
		_aDetAux[NFe_Det_EndTranspRedes		] := SubStr(_cLinha,631,40)
		_aDetAux[NFe_Det_BaiTranspRedes		] := SubStr(_cLinha,671,40)
		_aDetAux[NFe_Det_CidTranspRedes		] := SubStr(_cLinha,711,25)
		_aDetAux[NFe_Det_CEPTranspRedes		] := SubStr(_cLinha,736,12)
		_aDetAux[NFe_Det_UFTranspRedes		] := SubStr(_cLinha,748,03)
		_aDetAux[NFe_Det_TelTranspRedes		] := SubStr(_cLinha,751,50)
		_aDetAux[NFe_Det_OBSREDES			] := SubStr(_cLinha,801,30)
		_aDetAux[NFe_Det_LPItem				] := SubStr(_cLinha,831,03)
		
		AADD(_aDet, _aDetAux) 
		
	EndIf
	// Pego rodapé
	If SubStr(_cLinha,4,3) == 'NCR'
		_aRod[NFe_Rod_IdInfo		] := SubStr(_cLinha,01,03)
		_aRod[NFe_Rod_TpReg		] := SubStr(_cLinha,04,03)
		_aRod[NFe_Rod_CodIdMsg	] := SubStr(_cLinha,07,15)
		_aRod[NFe_Rod_NumCarreg	] := SubStr(_cLinha,22,30)		
		_aRod[NFe_Rod_QtdLinhas	] := SubStr(_cLinha,52,05)	
	EndIf

	// Retorna a linha correnteU  
	_nRecno := FT_FRecno()  
		
	// Pula para próxima linha  
	FT_FSKIP()
	_cLinha  := FT_FReadLn()	
End

// Fecha o Arquivo
FT_FUSE()

_aDados := {_aCab, _aDet, _aRod}

Return _aDados
/***********************************************/
* Grava NF-e a Embarcar						 	 *
/***********************************************/
Static Function fGravaNFe(_aNFe)
Local _aArea 	:= GetArea()
Local _lRet	:= .F. 

/*
_aNFe[1,1] 			:= "CABECALHO"
_aNFe[2,Lin,Coluna]	:= "DETALHE"
_aNFe[3,1] 			:= "RODAPE"
_lRet 					:= .T.
*/
Alert("Em Desenvolvimento")

RestArea(_aArea)
Return _lRet
