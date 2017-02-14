#include "rwmake.ch"    
#include "topconn.ch"   
#INCLUDE "tbiconn.ch"
#INCLUDE "ap5mail.ch" 

/*--------------------------------------------------------------------------*
*  Função    | GEFMSZR | Autor | J Ricardo de O Guimarães | Data | 23.07.08 *
*---------------------------------------------------------------------------*
* Descrição  | Importacao do Documento (Arquivo GEFCCTRC*.TXT) para a tabela*
*            | intermediária                                                *
*            |                                                              *
*            | Titulo a Receber                                             *
*            | Titulo a Pagar - Seguradora                                  *
*            | Titulo a Pagar - Transportadora                              *
*            | Registro Livros Fiscais                                      *
*---------------------------------------------------------------------------*/

User Function GEFMSZR(lAutoR)

SetPrvt("XCLILOJA,POS,CNL,XARQ")
SetPrvt("ARQ01,NHDL,TE1,_ACAMPOS,_CNOME,CINDEX")
SetPrvt("CCHAVE,NINDEX,ERROR,_XCLI,_XNAT,VCF")
Private cXCCPSA
Private cXCntPSA
Private lSRemessa:=.f.

////////////////////////////////////////////////////////////////////////////////////
// Obs. A versão antiga sem VA2 no header possui lay-out de icms diferente da VA2 //
//por isso devem ser dif. no livro.                                               //
////////////////////////////////////////////////////////////////////////////////////

xcliloja :=" "  //VARIAVEL GUARDA O COD DO CLIENTE PARA UTILIZACAO DO SEEK DO SF3
_MesAtu  := " "
_AnoAtu  := " "
xNatur   := "500" // Natureza Defalt
xSerie   := Space(3)
xPerCof  := 0
xPerPis  := 0
arqimp   := SPACE(80)
cFile	 := Space(80)
Ctrc     := Space(1) 

xCustoOld := " "
MSReg     := 0
xCusto    := Space(10)
xCustoNew := Space(10)
lCusReduz := .T.
xEspecie  := ""
xTamSrv   := 0
nAliq     := 0

// Private lAutoRot:=iif(lAutoR = Nil,.f.,lAutoR)
Private lAutoRot:=iif(lAutoR = Nil,.f.,.T.)

If lAutoRot //Se a rotina for automática.
	// Prepara ambiente para inicio de importação de interfaces.
	RPCSetType(3) // Nao consome o numero de licencas
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FIN" TABLES "SZS","SZR","SZE","SZ3","SED","SF3","SZ1","SZF","SZG","SZD","CTT","SE2","SE1","SA1","SA2"

	xRelease  := GetMv("MV_HISTVER")  // Versão do Centro de custo (2005 ou 2006)
	
	// Importa os arquivos do ISYGO para a tabela intermediária( CABEC_PRESTAÇÃO/ITENS_PRESTAÇÃO )
	ConOut("Inicio de importação dos arquivos TXT´s para a tabela intermediária SZR")
	Import()
	ConOut("Final de importação dos arquivos TXT´s para a tabela intermediária SZR")
	
//	ConOut("Inicio de Importaçãos dos títulos da tabela Intermediária para os módulos do Siga.")
//	U_GEFM062()	
//	ConOut("Final de Importaçãos dos títulos da tabela Intermediária para os módulos do Siga.")
	
	RESET ENVIRONMENT
    
	U_GEFM062(.T.)

Else
	xRelease  := GetMv("MV_HISTVER")  // Versão do Centro de custo (2005 ou 2006)
	@ 000,000 To 250,370 Dialog oDlg Title "GEFCO - IMPORTAÇÃO DE NOTAS/CTRC Versão 5.0"
	@ 003,016 To 60,144
	@ 010,021 Say OemToAnsi("OS ARQUIVOS PARA IMPORTAÇÃO DEVEM SER")
	@ 022,021 Say OemToAnsi("USADOS NA PASTA (\IMPORTAR) DO SERVIDOR !!!")
	@ 010,152 BmpButton Type 1 Action Import()
	@ 030,152 BmpButton Type 2 Action Close(oDlg)
	Activate Dialog oDlg Centered
EndIf

Return

Static Function Import()

//
// Tratamento de arquivos com interface antiga e a nova
//
pos  := 0
cNL  := CHR(13)+CHR(10)
xarq := " "
_cTipoImp := ""

PRIVATE _cPathNF  := ""
PRIVATE _cPathNFS := ""
PRIVATE _cPathCTRC:= ""

_aCampos:={}
Aadd(_aCampos,{"INDICE" ,"C",02,0 })
Aadd(_aCampos,{"NF"     ,"C",06,0 })
Aadd(_aCampos,{"XDATA"  ,"C",08,0 })
Aadd(_aCampos,{"CDDEST" ,"C",14,0 })
Aadd(_aCampos,{"CDCLI"  ,"C",14,0 })
Aadd(_aCampos,{"CDFIS"  ,"C",05,0 })    
Aadd(_aCampos,{"ALISS"  ,"C",05,0 })   // Separado ISS e ICMS (Novo lay-out) - 20/04/05 
Aadd(_aCampos,{"VLCONT" ,"C",14,0 })
Aadd(_aCampos,{"ISSTRI" ,"C",14,0 })
Aadd(_aCampos,{"BASIPI" ,"C",14,0 })
Aadd(_aCampos,{"VALIPI" ,"C",14,0 })
Aadd(_aCampos,{"CDTRA"  ,"C",14,0 })
Aadd(_aCampos,{"VLSEG"  ,"C",14,0 })
Aadd(_aCampos,{"VLPTR"  ,"C",14,0 })    // Total de Custo (Frete+Seguro)
Aadd(_aCampos,{"TPDOC"  ,"C",03,0 })
Aadd(_aCampos,{"CC"     ,"C",10,0 })	// Alteração para novo lay-out 22/08/03
Aadd(_aCampos,{"REFGEF" ,"C",20,0 })	
Aadd(_aCampos,{"TPDESP" ,"C",03,0 })	
Aadd(_aCampos,{"GEFIRRF","C",01,0 })	
Aadd(_aCampos,{"CCPSA"  ,"C",20,0 })	
Aadd(_aCampos,{"OIPSA"  ,"C",20,0 })	
Aadd(_aCampos,{"CDRESD" ,"C",14,0 })	// Alteração para novo lay-out 15/01/04  Cnpj - Redespacho
Aadd(_aCampos,{"ALICM"  ,"C",05,0 })    // Campos novos para Icms  - 20/04/05
Aadd(_aCampos,{"ICMTRI" ,"C",14,0 })    // Campos novos para Icms  - 20/04/05
Aadd(_aCampos,{"CTAPSA" ,"C",15,0 })    // Campos novos para PSA   - 14/09/05	
Aadd(_aCampos,{"CODSER" ,"C",06,0 })    // Campos Cod.Ser.ISS      - 09/11/05	    
			
_cNome := CriaTrab(_aCampos)

If Select("TRA") > 0
	DbSelectArea("TRA")
	dbCloseArea()
EndIf	
	
DbUseArea(.T.,,_cNome,"TRA",.F. )
DbSelectArea("TRA")
cIndex := CriaTrab(nil,.f.)
cChave := "TPDOC+NF+CDCLI"
nIndex :=IndRegua("TRA",cIndex,cChave,,,"Selecionando Registros...TRA")


// Pego a Localização dos Arquivos a serem importados
dbSelectArea("SZS") ; dbGoTop()

_xloc := ""

While !SZS->(Eof())
	If SZS->ZS_ATIVO <> "S"
		CONOUT("Filial " + SZS->ZS_FILIAL + " INATIVA ")
		dbSelectArea("SZS")
		dbSkip()
		Loop
	EndIf

	CONOUT("Processando a Filial " + SZS->ZS_FILIAL)

	// Caminho dos arquivos
    _cPath := AllTrim(SZS->ZS_PASTA)
    	
	_cTipoImp := "NOTA"
	// Caminho das NF
    _cPrefNF := AllTrim(SZS->ZS_PREFNF)
    
	_cTipoImp := "CTRC"
	// Caminho dos CTRC
    _cPrefCTRC:= AllTrim(SZS->ZS_PREFCTR)
                       
	_cTipoImp := "NFS"
	_cTipoImp := "NOTA SERV. DE TRANSP."
    _cPrefNFS:= AllTrim(SZS->ZS_PREFNFS)
    
	//  Nova Rotina para contab. novas series   
   	Gefcofil := SZS->ZS_FILIAL
	IF Gefcofil == "02"
	   _xloc := "CJ"
	EndIF     

	If !lAutoRot //Se a rotina for automática.
   		Processa({|| ProcTxt()},"Processando... Arquivos da Filial " + SZS->ZS_FILIAL ) 
   	Else
   		CONOUT("Processando... Arquivos da Filial " + SZS->ZS_FILIAL )
   		ProcTxt()
	EndIf
	
	dbSelectArea("SZS") ; dbSkip()
   
End

Return

*-------------------------------------------*
Static Function ProcTxt()  // Versão VA2/VA3
*-------------------------------------------*
Local _aArqsNF  := {}
Local _aArqsNFS := {}
Local _aArqsCTRC:= {}
Local _nN       := 0

pos  := 0
cNL  := CHR(13)+CHR(10)

dbSelectArea("TRA") ; ZAP

If !Empty(_cPrefNF)
	_aArqsNF  := Directory(_cPath + _cPrefNF  + "*.TXT")
EndIf

If !Empty(_cPrefNFS)	
	_aArqsNFS := Directory(_cPath + _cPrefNFS + "*.TXT")
EndIf

If !Empty(_cPrefCTRC)
	_aArqsCTRC:= Directory(_cPath + _cPrefCTRC+ "*.TXT")
EndIf

// Importo para o temporário as NFs    
If Len(_aArqsNF) > 0
	For _nN := 1 to Len(_aArqsNF)
		_cPathAux   := _cPath + _aArqsNF[_nN,1]
		_cPathAuxBk := SubStr(_cPath,1,RAT("\",SubStr(_cPath,1,Len(_cPath)-1))) + "Backup\" + _aArqsNF[_nN][1]
	
		APPEND FROM &_cPathAux SDF
		
		// Mover o arquivo para a pasta de Backup
		__CopyFile(_cPathAux,_cPathAuxBk)
		
		// Apago o arquivo na origem
		Ferase(_cPathAux)
	Next _nN
EndIf

// Importo para o temporário as NFSs 
If Len(_aArqsNFS) > 0
	For _nN := 1 to Len(_aArqsNFS)
		_cPathAux   := _cPath + _aArqsNFS[_nN,1]
		_cPathAuxBk := SubStr(_cPath,1,RAT("\",SubStr(_cPath,1,Len(_cPath)-1))) + "Backup\" + _aArqsNFS[_nN][1]
	
		APPEND FROM &_cPathAux SDF
		
		// Mover o arquivo para a pasta de Backup
		__CopyFile(_cPathAux,_cPathAuxBk)
		
		// Apago o arquivo na origem
		Ferase(_cPathAux)
	Next _nN
EndIf

// Importo para o temporário os CTRCs
If Len(_aArqsCTRC) > 0
	For _nN := 1 to Len(_aArqsCTRC)
		_cPathAux   := _cPath + _aArqsCTRC[_nN,1]
		_cPathAuxBk := SubStr(_cPath,1,RAT("\",SubStr(_cPath,1,Len(_cPath)-1))) + "Backup\" + _aArqsCTRC[_nN][1]
	
		APPEND FROM &_cPathAux SDF
		
		// Mover o arquivo para a pasta de Backup
		__CopyFile(_cPathAux,_cPathAuxBk)
		
		// Apago o arquivo na origem
		Ferase(_cPathAux)
	Next _nN
EndIf

dbSelectArea("TRA") ; dbGoTop()

If Eof()
	CONOUT("Sem arquivo à processar para a Filial " + SZS->ZS_FILIAL)
//	Alert("Sem arquivo à processar para a Filial " + SZS->ZS_FILIAL)
	Return
EndIf

DbSelectArea("SA1")
DbSetorder(3)
DbGotop()			
DbSelectArea("SA2")
DbSetorder(3)
DbGotop()			
DbSelectArea("SE1")
DbSetOrder(1)
DbSelectArea("CTT")  // Atualizado para CTB
DbSetOrder(1)	
DbGotop()			

DbSelectArea("TRA")
DbGotop()

// ProcRegua(RecCount())	  

While !Eof()

	error := 0        
			           
	//CONTROLE DOS ARQUIVOS POR FILIAL DO CABEC-ARQUIVO
	If TRA->INDICE == '00'
		CONOUT("Arquivo do Mes " + Substr(TRA->NF,5,2)+"/"+Substr(TRA->NF,1,4))
		DbselectArea("TRA")
		Dbskip()
		Loop
	EndIf
		                           
		
	If TRA->INDICE == '99'
		CONOUT("Total de Registros .: " + TRA->NF )
		DbselectArea("TRA")
		Dbskip()
		Loop
	EndIf
 		
//	IncProc()
    //Destino MS

	lAnPSA := .f.
    xDestino := Substr(TRA->CDDEST,3,8)
    xMSCli   := Substr(TRA->CDCLI,3,8)

	// Por: J Ricardo - Em: 26/09/07 - Para tratar a Filial Jaguaré que não tem Filial própria no Microsiga
	_cTpDoc := TRA->TPDOC   

	DbSelectArea("SZR")

	cXCCPSA	 := Alltrim(TRA->CCPSA)
	cXCntPSA := Alltrim(TRA->CTAPSA)  // Solicitado em 14/09/05
/*
	If SZS->ZS_FILIAL == '04' // Caso filial seja 04(Barueri) o Centro de Custo PSA e Conta PSA serão os que estão definidos no parametro carregado abaixo
		cXCCPSA	:=	GetMV("MV_XCCPSA")
		cXCntPSA:=	GetMV("MV_XCNTPSA")
	EndIf
*/
	If !dbSeek(SZS->ZS_FILIAL + TRA->NF + TRA->TPDOC)
		Reclock("SZR",.T.)
			SZR->ZR_FILIAL  := SZS->ZS_FILIAL
			SZR->ZR_NF      := TRA->NF
			SZR->ZR_TPDOC   := TRA->TPDOC
	Else			
		Reclock("SZR",.F.)
	EndIf	              
	If SZR->ZR_IMPORT <> "S"
		SZR->ZR_XDATA   := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
		SZR->ZR_CDDEST  := TRA->CDDEST
		SZR->ZR_CDCLI   := TRA->CDCLI
		SZR->ZR_CDFIS   := TRA->CDFIS
		SZR->ZR_ALISS   := VAL(TRA->ALISS)/100
		SZR->ZR_VLCONT  := VAL(TRA->VLCONT)/100
		SZR->ZR_ISSTRI  := VAL(TRA->ISSTRI)/100
		SZR->ZR_BASIPI  := VAL(TRA->BASIPI)/100
		SZR->ZR_VALIPI  := VAL(TRA->VALIPI)/100  //xCusto //Alltrim(TRA->CC)  // Alterado em 08/09/03
		SZR->ZR_CDTRA   := TRA->CDTRA            // Campo novo para gravar o Cnpj da Transportadora
		SZR->ZR_VLSEG   := VAL(TRA->VLSEG)/100
		SZR->ZR_PTR     := VAL(TRA->VLPTR)/100
		SZR->ZR_CC      := TRA->CC
		SZR->ZR_REFGEF  := AllTrim(TRA->REFGEF)
		SZR->ZR_TPDESP  := Alltrim(TRA->TPDESP)
		SZR->ZR_GEFIRRF := Alltrim(TRA->GEFIRRF)
		SZR->ZR_CCPSA   := Alltrim(cXCCPSA)
		SZR->ZR_CTAPSA  := Alltrim(cXCntPSA)  // Solicitado em 14/09/05
		SZR->ZR_OIPSA   := Alltrim(TRA->OIPSA)			
		SZR->ZR_CDRESD  := AllTrim(TRA->CDRESD)
	   	SZR->ZR_ALICM   := VAL(TRA->ALICM)/100
	   	SZR->ZR_ICMTRI  := VAL(TRA->ICMTRI)/100
	   	SZR->ZR_CDSER   := TRA->CODSER
	   	SZR->ZR_IMPORT  := ""
	   	SZR->ZR_SISORIG := "SIPCO"
	EndIf   	
	Msunlock()
		
	DbselectArea("TRA")
	Dbskip()
End

Return

Static Function isCliPSA(pCliente,lCodSap)
Local lRet:=.t.

dbSelectArea("SZE")
//If Substr(pCliente,1,2) = "MS"  
	dbSetOrder(1)
//	pCliente:=Substr(pCliente,3,8)
//Else
//	dbSetOrder(4)
//EndIf

If !dbSeek(xFilial("SZE")+pCliente)
	lRet:=.f.
ElseIf lCodSap
	If AllTrim(SZE->ZE_CODSAP) == 'BR30'
		lRet:=.f.
	EndIf
EndIf

Return lRet

Static Function Pagar()

DbselectArea("SA2")
DbSetOrder(3)
DbSeek(xFilial("SA2")+tra->CDTRA)

DbselectArea("SE2")
// Alterado em 18/12/03 para contab.apenas o imposto

If Val(Substr(TRA->ISSTRI,1,Len(TRA->ISSTRI)-2)+"."+Substr(TRA->ISSTRI,Len(TRA->ISSTRI)-1,2)) = 0.00 // Não gera imposto zerado
   Return
Endif   

Return
