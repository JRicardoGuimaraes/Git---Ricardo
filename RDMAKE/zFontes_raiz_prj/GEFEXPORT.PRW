#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "tbiconn.ch"
//#include "FIVEWIN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEFEXPORT  º Autor ³ Saulo Muniz       º Data ³  24/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Arquivo de exportação de dados para Gefco Argentina        º±±
±±º          ³ Geração um único arquivo                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gefco                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                          

// Scheduler parado por Ricardo em 15/10 - Segundo o Strack o projeto não foi a frente.

User Function GEFEXPSH()
 	U_GEFEXPORT(.T.)
Return

User Function GEFEXPORT(lAutoR)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDlg,oGet
Local cFile := Space(200)

Private oGeraTxt,cNomeAtv
Private nTamLin, cLin, cCpo, nReg, xCfop, cPrefixo, xGfilial , xGnota  
Private aData:={}
Private cArqTxt  := ""
Private lAutoRela:=iif(lAutoR = Nil,.f.,lAutoR)

If lAutoRela
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FIN" TABLES "SE1","SZL","SA1","SED","CTT","SF3","CTS"
EndIf

nReg := 0

If lAutoRela
	aData:=fDtExport()
	If len(aData) > 0
		cArqTxt := "\\geatj1appl1\protheus8\Protheus_Data\Exportar\Argentina\"
		cArqTxt += "GEFCOMRC"+strzero(month(aData[1]),2)+alltrim(str(year(aData[1])))+".txt"
	EndIf
EndIf

dbSelectArea("SE1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lAutoRela
	@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o de Arquivo Microsiga -> Gefco Argentina - Versão 1.01")
	@ 002,10 TO 080,190
	@ 10,018 Say " Este programa ira exportar os dados do sistema Microsiga de    "
	@ 18,018 Say " acordo com os parâmetros definidos pelo usuario, retornando as "
	@ 26,018 Say " informações para o sistema Sisges.                             "
	
	@ 055,088 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
	@ 055,119 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
	@ 055,150 BMPBUTTON TYPE 05 ACTION Pergunte("GEFM50",.T.) 
	
	Activate Dialog oGeraTxt Centered
Else
	OkGeraTxt()
EndIf

If lAutoRela
	RESET ENVIRONMENT
EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³ AP7 IDE            º Data ³  06/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkGeraTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Private cArqTxt  := "\\geatj1appl1\Protheus8\Protheus_Data\Exportar\GefcoMrc.txt"
Private nHdl  //   := fCreate(cArqTxt)
Private cEOL     := "CHR(13)+CHR(10)"
Private cSinal   := "+"

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If lAutoRela
	Pergunte("GEFM50",.F.)
	If len(aData) > 0
		MV_PAR01:=aData[1]
		MV_PAR02:=aData[2]
	Else
		return
	EndIf
Else
	Pergunte("GEFM50",.T.)
//	aData:=fDtExport()
//	If len(aData) > 0
		cArqTxt := "\\geatj1appl1\protheus8\Protheus_Data\Exportar\Argentina\"
//		cArqTxt := "D:\temp\ARG\"
//		cArqTxt += "GEFCOMRC"+strzero(month(aData[1]),2)+alltrim(str(year(aData[1])))+".txt"
		cArqTxt += "GEFCOMRC"+strzero(month(MV_PAR01),2)+alltrim(str(year(MV_PAR01)))+".txt"
//	EndIf

EndIf

nHdl    := fCreate(cArqTxt)
If nHdl == -1
	If lAutoRela
		Conout("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.")
	Else
	    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	EndIf
    Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabec. do arquivo          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
xIndice  := "00"
Dttrans  := Gravadata(Ddatabase,.F.,8) 
Hrtrans  := Substr(Time(),1,2) + Substr(Time(),4,2)
DtPar01  := Gravadata(MV_PAR01,.F.,8) 
DtPar02  := Gravadata(MV_PAR02,.F.,8) 
xUser    := Substr(Alltrim(cUsername),1,10) 
System   := "MICROSIGA"
xBrancos := Space(896)

_FHeader := xIndice + DtPar01 + DtPar02 + xBrancos + cEOL

fWrite(nHdl,_FHeader,Len(_FHeader))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| FctVendas()  },"Processando Vendas...") 		 	// tipo - 01
Processa({|| FctCompras() },"Processando Compras..") 			// tipo - 02
Processa({|| FctGastos()  },"Processando Gastos...") 			// tipo - 03
Processa({|| FctImpostos()},"Processando Impostos...") 			// tipo - 04
Processa({|| FctCtbDeb()  },"Processando Ctb Manual Debito...") // tipo - 05
Processa({|| FctCtbCred() },"Processando Ctb Manual Credito...")// tipo - 06



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Rodape do arquivo          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
tIndice  := "ZZZ"
nQtdReg  := Strzero(nReg,10)
tBrancos := Space(901)

_FTrailler := tIndice + nQtdReg + tBrancos + cEOL
fWrite(nHdl,_FTrailler,Len(_FTrailler))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fClose(nHdl)
If !lAutoRela
	Close(oGeraTxt)
EndIf


/*	If File(cPathori)
       Resposta := MSGBOX("Arquivo texto já existe, Deseja atualizar o arquivo !","Informa‡ao","YESNO")
       If Resposta
		  Ferase(cPathori)             
       Else	      
	      //MsgBox("Arquivo texto já existe !","Informa‡ao","INFO")
	      Return
	   Endif	   
	Endif

    //cCmd := "Decifrador.exe /c " + cArqTxt + " " + cArqSai   
    //WinExec(cCmd)*/

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³ FctVendasº Autor ³ GEFCO               º Data ³  06/11/05  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Funcao responsável por processar os dados de vendas.       º±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function FctVendas()


StartVar()

V_Se1     := RETSQLNAME("SE1")
V_Sa1     := RETSQLNAME("SA1")
V_SED     := RETSQLNAME("SED")
V_CTT     := RETSQLNAME("CTT")

_cFilial  := ""
nValorFil := 0
nTotalG   := 0
_cFilAnt  := ""   
cTipoReg  := "01"

// Vendas
cQuery = " SELECT E1.E1_FILIAL,E1.E1_CLIENTE,E1.E1_LOJA,E1.E1_TIPO,A1.A1_CGC,A1.A1_NOME,E1.E1_NOMCLI,E1.E1_CCONT,E1.E1_PREFIXO,E1.E1_FATURA,E1.E1_NUMBCO,E1.E1_NUM,E1.E1_DATABOR,E1.E1_EMISSAO,E1.E1_EMIS1,E1.E1_VALOR,E1.E1_REFGEF,E1.E1_CCPSA,E1.E1_OIPSA,E1.E1_TPDESP,E1.E1_DTFATUR,E1.E1_MOEDA,E1.E1_ISS,E1.E1_VLRICM,E1.E1_VLCRUZ,ED.ED_CONTA,CTT.CTT_DESC01"
cQuery += " FROM "+V_Se1+" AS E1,"+V_Sa1+" AS A1,"+V_SED+" AS ED ,"+V_CTT+" AS CTT "
cQuery += " WHERE E1.E1_CLIENTE = A1.A1_COD AND E1.E1_LOJA = A1.A1_LOJA AND"
cQuery += " E1.E1_EMISSAO >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " E1.E1_EMISSAO <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " E1.E1_PREFIXO <> 'FAT' AND"
cQuery += " E1.E1_NATUREZ = ED.ED_CODIGO AND"
cQuery += " E1.E1_CCONT = CTT.CTT_CUSTO AND"
cQuery += " E1.D_E_L_E_T_ <> '*' AND A1.D_E_L_E_T_ <> '*' AND ED.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*'" 

TcQuery cQuery Alias "VEN" NEW
DbSelectArea("VEN")
ProcRegua(RecCount())
DbGoTop()         

_cFilial := VEN->E1_FILIAL
    
While !Eof() 
    
    IncProc()

    nTamLin  := 150
    cLin     := Space(nTamLin)+cEOL  

    cTipoReg := "01"
    cCliCob  := VEN->E1_CLIENTE + VEN->E1_LOJA
    cCnpjCob := VEN->A1_CGC + Space(14 - Len(VEN->A1_CGC))
    cNomCob  := VEN->A1_NOME + Space(40 - Len(VEN->A1_NOME))

	cSerie := "1" //Default
	
	// Tratamento Porto Real 2 séries
	If VEN->E1_FILIAL == "03" .And. Alltrim(VEN->E1_PREFIXO) == "UN1"
	   cSerie := "1"        
	Endif
	If VEN->E1_FILIAL == "03" .And. Alltrim(VEN->E1_PREFIXO) == "UN2"
	   cSerie := "2"        
	Endif	
    If VEN->E1_FILIAL == "06" .OR. VEN->E1_FILIAL == "11"
       cSerie := IIF(Alltrim(VEN->E1_PREFIXO) == "CTR" .OR. Alltrim(VEN->E1_PREFIXO) == "UNS","U","A") 
    Endif

	DbSelectArea("SF3")
	DbSetOrder(6) // FILIAL + NOTA + SERIE
	Dbgotop()
	If !DbSeek(VEN->E1_FILIAL + VEN->E1_NUM + cSerie)
       cCliDest := Space(8)
       cCfop    := Space(5)
       cNomCfop := Space(55)
 	   cCnpjDest:= Space(14)
       cNomDest := Space(40)
/*       DbSelectArea("VEN")
       dbSkip()          
       Loop*/

	Else    

       If Substr(SF3->F3_CFO,1,1) <> "1" .And. Substr(SF3->F3_CFO,1,1) <> "2"

	      cCliDest := SF3->F3_CLIEFOR+SF3->F3_LOJA 
          cCfop    := SF3->F3_CFO + Space(5 - Len(SF3->F3_CFO))
          cNomCfop := Tabela("13",Alltrim(cCfop)) + Space(55 - Len(Tabela("13",Alltrim(cCfop))))
      	  
      	  DbSelectArea("SA1")
          DbSetOrder(1) 
          Dbgotop()
          If DbSeek(xFilial("SA1") + cCliDest)
    	     cCnpjDest:= SA1->A1_CGC + Space(14 - Len(SA1->A1_CGC))
 	         cNomDest := SA1->A1_NOME + Space(40 - Len(SA1->A1_NOME))
          Endif
       
       Else          
          DbSelectArea("VEN")
          dbSkip()          
          Loop

	   Endif          
	
	Endif
	    
    cFornece := Space(8)
    cNomFor  := Space(40)
    cCnpjFor := Space(14)
    
    cCodCusto := VEN->E1_CCONT + Space(10 - Len(VEN->E1_CCONT))
    cNomCusto := VEN->CTT_DESC01 + Space(40 - Len(VEN->CTT_DESC01))
   
    cCodDiv := Substr(VEN->E1_CCONT,1,1)
    cNomDiv := GEFDIVISAO(cCodDiv) + Space(20 - Len(GEFDIVISAO(cCodDiv)))

    cCodUO  := Substr(VEN->E1_CCONT,2,2)
    cNomUO  := UO(cCodUO) + Space(40 - Len(UO(cCodUO)))

    cCodFil := Substr(VEN->E1_CCONT,4,3)
    cNomFil := GEFFILIAL(cCodFil) + Space(40 - Len(GEFFILIAL(cCodFil)))

    cCodAtv := Substr(VEN->E1_CCONT,7,3)
    cNomAtv := Atividade(cCodAtv,cCodUO) + Space(60 - Len(Atividade(cCodAtv,cCodUO)))

    cCodPolo:= Substr(VEN->E1_CCONT,10,1)
    cNomPolo:= Polo(cCodPolo) + Space(40 - Len(Polo(cCodPolo)))

    cConta  := VEN->ED_CONTA + Space(20 - Len(VEN->ED_CONTA))
	
	dbSelectArea("CT1")
	dbSetOrder(1)
	If MsSeek(xFilial()+cConta)
       cNomConta := CT1->CT1_DESC01 + Space(20 - Len(CT1->CT1_DESC01))
    Else
       cNomConta := Space(40)        
    Endif
    
	_cQry := ""	
	_cQry := "SELECT * FROM " + RetSqlName("CTS") + " CTS "
	_cQry += "	WHERE RTRIM(CTS.CTS_CODPLA) = '001' " 
	_cQry += "	  AND RTRIM(CTS.CTS_CT1INI) = '" + Alltrim(cConta) + "' "
	_cQry += "	  AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	_cQry += "	  AND CTS.D_E_L_E_T_ <> '*' "                  
	_cQry += "	  ORDER BY CTS_CODPLA, CTS_CONTAG , CTS_CT1INI "                  	
	
	If Select("TCTS") > 0
	   dbSelectArea("TCTS")
	   dbCloseArea()
	EndIf
	
	TCQUERY _cQry ALIAS "TCTS" NEW
	dbSelectArea("TCTS") 
	dbGoTop()	    	

    cContaGer := TCTS->CTS_CONTAG + Space(20 - Len(TCTS->CTS_CONTAG)) 
    cNomGeren := TCTS->CTS_DESCCG + Space(20 - Len(TCTS->CTS_DESCCG)) 
 
    DbSelectArea("VEN")

    cTipoDoc   := VEN->E1_TIPO + Space(3 - Len(VEN->E1_TIPO)) 
    cCodFatura := VEN->E1_FATURA + Space(6 - Len(VEN->E1_FATURA)) 
    cNumBoleto := VEN->E1_NUMBCO + Space(12 - Len(VEN->E1_NUMBCO)) 
    cNumDoc    := VEN->E1_PREFIXO + Space(3 - Len(VEN->E1_PREFIXO)) + VEN->E1_NUM + Space(6 - Len(VEN->E1_NUM)) 
    
    cDtFatura  := IIF(EMPTY(VEN->E1_DTFATUR),Space(8),VEN->E1_DTFATUR)   
    cDtBoleto  := IIF(EMPTY(VEN->E1_DATABOR),Space(8),VEN->E1_DATABOR)  
    cDtDoc     := IIF(EMPTY(VEN->E1_EMISSAO),Space(8),VEN->E1_EMISSAO)
    cDtContab  := IIF(EMPTY(VEN->E1_EMIS1),Space(8),VEN->E1_EMIS1) 

    // Alterado conf. Instr. do Sr. Marcos Furtado - Saulo Muniz ( 01/12/06 )
    //
    If VEN->E1_MOEDA == 01
//	    nValor     := STRZERO((VEN->E1_VALOR - VEN->E1_ISS - VEN->E1_VLRICM) * 100,19,0)    
	    nValor     := STRZERO(VEN->E1_VALOR * 100,19,0)    
    Else
	    nValor     := STRZERO(VEN->E1_VLCRUZ * 100,19,0)    
	    //nValor     := STRZERO((VEN->E1_VLCRUZ - VEN->E1_ISS - VEN->E1_VLRICM) * 100,19,0)    
	    //nValor     := STRZERO(VEN->E1_VLCRUZ * 100,19,0)    
    Endif
    
    cImposto   := Space(20)
    
    cRefgefco  := VEN->E1_REFGEF + Space(20 - Len(VEN->E1_REFGEF)) 
    cCustoPSA  := VEN->E1_CCPSA  + Space(20 - Len(VEN->E1_CCPSA)) 
    cOIPSA     := VEN->E1_OIPSA  + Space(20 - Len(VEN->E1_OIPSA)) 
    cTipoDesp  := VEN->E1_TPDESP + Space(3 - Len(VEN->E1_TPDESP))        
    cLote      := Space(18)
    cDescLote  := Space(120)
    
    lManual    := "N"
    FlagProv   := "N"

    TipoCnt    := "V"

	If AllTrim(cConta) $ ("711101,711102,711103,711105,711106,711107,711108,711202,711203,711204") 
		
		/*******Compras    ********
		711101 FRETE RODOVIÁRIO
		711102 FRETE FERROVIÁRIO
		711103 FRETE FLUVIAL
		711105 FRETE MARÍTIMO NVOCC
		711106 FRETE AÉREO
		711107 ARMAZENAGEM
		711108 PEDÁGIO SOBRE FRETES
		711202 DESPACHANTES/ADUANA
		711203 OUTROS CUSTOS NVOCC
		711204 CMV DE EMBALAGENS
		******************************/
	    TipoCnt   := "C" //Compras
		       
	Else	
		_cQry := ""	
		_cQry := "SELECT * FROM " + RetSqlName("CTS") + " CTS "
		_cQry += "	WHERE RTRIM(CTS.CTS_CODPLA) = '001' " 
		_cQry += "	  AND RTRIM(CTS.CTS_CONTAG) = 'A01' " 				
		_cQry += "	  AND RTRIM(CTS.CTS_CT1INI) >= '" + Alltrim(cConta) + "' "
		_cQry += "	  AND RTRIM(CTS.CTS_CT1FIM) <= '" + Alltrim(cConta) + "' "		
		_cQry += "	  AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
		_cQry += "	  AND CTS.D_E_L_E_T_ <> '*' "                  
		_cQry += "	  ORDER BY CTS_CODPLA, CTS_CONTAG , CTS_CT1INI "  
		
		If Select("TCTS1") > 0
		   dbSelectArea("TCTS1")
		   dbCloseArea()
		EndIf
		
		TCQUERY _cQry ALIAS "TCTS1" NEW
		dbSelectArea("TCTS1") 
		dbGoTop()	    	
	
		If !Eof()
		    TipoCnt   := "V" //Vendas		
		Else
		    TipoCnt   := "G" //Gastos			
		EndIF
	EndIf    


    cLin := cTipoReg + cCliCob + cCnpjCob + cNomCob + cCliDest + cCnpjDest + cNomDest + cFornece + cNomFor + cCnpjFor + cCodCusto + cNomCusto + cCodDiv + cNomDiv + cCodUO + cNomUO + cCodFil + cNomFil + cCodAtv + cNomAtv + cCodPolo + cNomPolo + cConta 
    cLin := cLin + cNomConta + cContaGer + cNomGeren + cTipoDoc + cCodFatura + cNumBoleto + cNumDoc + cDtFatura  + cDtBoleto + cDtDoc + cDtContab + nValor + cImposto + cCfop + cNomCfop + cRefgefco + cCustoPSA + cOIPSA + cTipoDesp 
    cLin := cLin + cLote + cDescLote + lManual + FlagProv + TipoCnt + cSinal + cEOL
    nReg++

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
    //³ linha montada.                                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If lAutoRela
			Conout("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.")
		Else
			MsgAlert("Ocorreu um erro na gravacao do arquivo.","Atencao!")
		EndIf
		Exit
    Endif

	DbSelectArea("VEN")
    dbSkip()

EndDo

//If nReg == 0   
//   Ferase(cPathori)                   
//Endif

Return()
        

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³ FctComprasº Autor ³ GEFCO               º Data ³  06/11/05 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Funcao responsável por processar os dados de Compras.      º±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function FctCompras()


StartVar()


V_Se2     := RETSQLNAME("SE2")
V_Sa2     := RETSQLNAME("SA2")
V_SED     := RETSQLNAME("SED")
V_CTT     := RETSQLNAME("CTT")

_cFilial  := ""
nValorFil := 0
nTotalG   := 0         
_cFilAnt  := ""   
cTipoReg  := "02"
cCompras := "('711101', '711102', '711103', '711105', '711106', '711107', '711108', '711202', '711203', '711204')"
cSinal   := "-"  

cQuery = " SELECT E2.E2_FILIAL,E2.E2_FORNECE,E2.E2_LOJA,E2.E2_TIPO,A2.A2_CGC,A2.A2_NOME,E2.E2_CCONT,E2.E2_PREFIXO,E2.E2_NUM,E2.E2_EMISSAO,E2.E2_EMIS1,E2.E2_VALOR,E2.E2_ORIGEM,ED.ED_CONTA,CTT.CTT_DESC01"
cQuery += " FROM "+V_SE2+" AS E2,"+V_SA2+" AS A2,"+V_SED+" AS ED ,"+V_CTT+" AS CTT "
cQuery += " WHERE E2.E2_FORNECE = A2.A2_COD AND E2.E2_LOJA = A2.A2_LOJA AND"
//cQuery += " E2.E2_EMISSAO >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
//cQuery += " E2.E2_EMISSAO <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "    
//Trocado a data para pegar somente os títulos incluídos dentro do mês - Marcos Furtado 08/01/2007.
cQuery += " E2.E2_EMIS1 >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " E2.E2_EMIS1 <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " E2.E2_NATUREZ = ED.ED_CODIGO AND"
cQuery += " E2.E2_CCONT = CTT.CTT_CUSTO AND"
cQuery += " ED.ED_CONTA IN " + cCompras + "  AND "	
cQuery += " E2.D_E_L_E_T_ <> '*' AND A2.D_E_L_E_T_ <> '*' AND ED.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*'" 

TcQuery cQuery Alias "COM" NEW

DbSelectArea("COM")
ProcRegua(RecCount())
DbGoTop()         

_cFilial := COM->E2_FILIAL
    
While !Eof() 
    
    IncProc()

    nTamLin  := 913
    cLin     := Space(nTamLin)+cEOL  

    cTipoReg := "02"                        
    cCliCob  := Space(8)
    cCnpjCob := Space(14)
    cNomCob  := Space(40)
    
    If Alltrim(COM->E2_ORIGEM) == "MATA100"
	
		cSerie := "1" 

		If COM->E2_FILIAL == "03" .And. Alltrim(COM->E2_PREFIXO) == "UN1"
		   cSerie := "1"        
		Endif
		If COM->E2_FILIAL == "03" .And. Alltrim(COM->E2_PREFIXO) == "UN2"
		   cSerie := "2"        
		Endif	
	    If COM->E2_FILIAL == "06" .OR. COM->E2_FILIAL == "11"
	       cSerie := IIF(Alltrim(COM->E2_PREFIXO) == "CTR" .OR. Alltrim(COM->E2_PREFIXO) == "UNS","U","A") 
	    Endif
	
		DbSelectArea("SF3")
		DbSetOrder(6) 
		Dbgotop()
		If !DbSeek(COM->E2_FILIAL + COM->E2_NUM + cSerie)
	       cCliDest := Space(8)
	       cCfop    := Space(5)
	       cNomCfop := Space(55)
	 	   cCnpjDest:= Space(14)
	       cNomDest := Space(40)
	       DbSelectArea("COM")
/*	       dbSkip()          
	       Loop*/
	
		Else    
	
	       If Substr(SF3->F3_CFO,1,1) == "1" .Or. Substr(SF3->F3_CFO,1,1) == "2"	
		      cCliDest := SF3->F3_CLIEFOR+SF3->F3_LOJA 
	          cCfop    := SF3->F3_CFO + Space(5 - Len(SF3->F3_CFO))
	          cNomCfop := Tabela("13",Alltrim(cCfop)) + Space(55 - Len(Tabela("13",Alltrim(cCfop))))	      	  
	      	  DbSelectArea("SA2")
	          DbSetOrder(1) 
	          Dbgotop()
	          If DbSeek(xFilial("SA2") + cCliDest)
	    	     cCnpjDest:= SA2->A2_CGC + Space(14 - Len(SA2->A2_CGC))
	 	         cNomDest := SA2->A2_NOME + Space(40 - Len(SA2->A2_NOME))
	          Endif	       
	       Else          	
	          DbSelectArea("COM")
	          dbSkip()          
	          Loop	
		   Endif          
        
        Endif
        
	Else
	        
        cSerie   := " "	
        cCliDest := Space(8)
        cCfop    := Space(5)
        cNomCfop := Space(55)
        cCnpjDest:= Space(14)
        cNomDest := Space(40)
	
	Endif
	
	    
    cFornece := COM->E2_FORNECE + COM->E2_LOJA
    cNomFor  := COM->A2_NOME + Space(40 - Len(COM->A2_NOME))
    cCnpjFor := COM->A2_CGC + Space(14 - Len(COM->A2_CGC))
    
    cCodCusto := COM->E2_CCONT + Space(10 - Len(COM->E2_CCONT))
    cNomCusto := COM->CTT_DESC01 + Space(40 - Len(COM->CTT_DESC01))
   
    cCodDiv := Substr(COM->E2_CCONT,1,1)
    cNomDiv := GEFDIVISAO(cCodDiv) + Space(20 - Len(GEFDIVISAO(cCodDiv)))

    cCodUO  := Substr(COM->E2_CCONT,2,2)
    cNomUO  := UO(cCodUO) + Space(40 - Len(UO(cCodUO)))

    cCodFil := Substr(COM->E2_CCONT,4,3)
    cNomFil := GEFFILIAL(cCodFil) + Space(40 - Len(GEFFILIAL(cCodFil)))

    cCodAtv := Substr(COM->E2_CCONT,7,3)
    cNomAtv := Atividade(cCodAtv,cCodUO) + Space(60 - Len(Atividade(cCodAtv,cCodUO)))

    cCodPolo:= Substr(COM->E2_CCONT,10,1)
    cNomPolo:= Polo(cCodPolo) + Space(40 - Len(Polo(cCodPolo)))

    cConta  := COM->ED_CONTA + Space(20 - Len(COM->ED_CONTA))
	
	dbSelectArea("CT1")
	dbSetOrder(1)
	If MsSeek(xFilial()+cConta)
       cNomConta := CT1->CT1_DESC01 + Space(20 - Len(CT1->CT1_DESC01))
    Else
       cNomConta := Space(40)        
    Endif
    
	_cQry := ""	
	_cQry := "SELECT * FROM " + RetSqlName("CTS") + " CTS "
	_cQry += "	WHERE RTRIM(CTS.CTS_CODPLA) = '001' " 
	_cQry += "	  AND RTRIM(CTS.CTS_CT1INI) = '" + Alltrim(cConta) + "' "
	_cQry += "	  AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	_cQry += "	  AND CTS.D_E_L_E_T_ <> '*' "                  
	_cQry += "	  ORDER BY CTS_CODPLA, CTS_CONTAG , CTS_CT1INI "                  	
	
	If Select("TCTS") > 0
	   dbSelectArea("TCTS")
	   dbCloseArea()
	EndIf
	
	TCQUERY _cQry ALIAS "TCTS" NEW
	dbSelectArea("TCTS") 
	dbGoTop()	    	

    cContaGer := TCTS->CTS_CONTAG + Space(20 - Len(TCTS->CTS_CONTAG)) 
    cNomGeren := TCTS->CTS_DESCCG + Space(20 - Len(TCTS->CTS_DESCCG)) 
 
    DbSelectArea("COM")

    cTipoDoc   := COM->E2_TIPO + Space(3 - Len(COM->E2_TIPO)) 
    cCodFatura := Space(6) 
    cNumBoleto := Space(12)
    cNumDoc    := COM->E2_PREFIXO + Space(3 - Len(COM->E2_PREFIXO)) + COM->E2_NUM + Space(6 - Len(COM->E2_NUM))     
    cDtFatura  := Space(8)
    cDtBoleto  := Space(8)
    cDtDoc     := IIF(EMPTY(COM->E2_EMISSAO),Space(8),COM->E2_EMISSAO)
    cDtContab  := IIF(EMPTY(COM->E2_EMIS1),Space(8),COM->E2_EMIS1)     
    nValor     := STRZERO(COM->E2_VALOR * 100,19,0)        
    cImposto   := Space(20)    
    cRefgefco  := Space(20)
    cCustoPSA  := Space(20)
    cOIPSA     := Space(20)
    cTipoDesp  := Space(3)
    cLote      := Space(18)
    cDescLote  := Space(120)    
    lManual    := "N"
    FlagProv   := "N"
    TipoCnt    := "C"

    cLin := cTipoReg + cCliCob + cCnpjCob + cNomCob + cCliDest + cCnpjDest + cNomDest + cFornece + cNomFor + cCnpjFor + cCodCusto + cNomCusto + cCodDiv + cNomDiv + cCodUO + cNomUO + cCodFil + cNomFil + cCodAtv + cNomAtv + cCodPolo + cNomPolo + cConta 
    cLin := cLin + cNomConta + cContaGer + cNomGeren + cTipoDoc + cCodFatura + cNumBoleto + cNumDoc + cDtFatura  + cDtBoleto + cDtDoc + cDtContab + nValor + cImposto + cCfop + cNomCfop + cRefgefco + cCustoPSA + cOIPSA + cTipoDesp 
    cLin := cLin + cLote + cDescLote + lManual + FlagProv + TipoCnt + cSinal + cEOL
    nReg++


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
    //³ linha montada.                                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If lAutoRela
			Conout("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.")
		Else
			MsgAlert("Ocorreu um erro na gravacao do arquivo.","ATencao!")
		EndIf
		exit
//        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
//            Exit
//        Endif
    Endif

    dbSkip()

EndDo              

DbSelectArea("COM")
DbCloseArea()

//If nReg == 0   
//   Ferase(cPathori)                   
//Endif

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³ FctGastosº Autor ³ GEFCO                º Data ³  06/11/05 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Funcao responsável por processar os dados de Gastos        º±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/



Static Function FctGastos()

StartVar()

V_Se2     := RETSQLNAME("SE2")
V_Sa2     := RETSQLNAME("SA2")
V_SED     := RETSQLNAME("SED")
V_CTT     := RETSQLNAME("CTT")

_cFilial  := ""
nValorFil := 0
nTotalG   := 0
_cFilAnt  := ""   
cTipoReg  := "03"       
cSinal    := "-"


// Contas referentes a compras
/*
711101 FRETE RODOVIÁRIO
711102 FRETE FERROVIÁRIO
711103 FRETE FLUVIAL
711105 FRETE MARÍTIMO NVOCC
711106 FRETE AÉREO
711107 ARMAZENAGEM
711108 PEDÁGIO SOBRE FRETES
711202 DESPACHANTES/ADUANA
711203 OUTROS CUSTOS NVOCC
711204 CMV DE EMBALAGENS
*/

cCompras := "('711101', '711102', '711103', '711105', '711106', '711107', '711108', '711202', '711203', '711204')"

cQuery = " SELECT E2.E2_FILIAL,E2.E2_FORNECE,E2.E2_LOJA,E2.E2_TIPO,A2.A2_CGC,A2.A2_NOME,E2.E2_CCONT,E2.E2_PREFIXO,E2.E2_NUM,E2.E2_EMISSAO,E2.E2_EMIS1,E2.E2_VALOR,E2.E2_ORIGEM,ED.ED_CONTA,CTT.CTT_DESC01"
cQuery += " FROM "+V_SE2+" AS E2,"+V_SA2+" AS A2,"+V_SED+" AS ED ,"+V_CTT+" AS CTT "
cQuery += " WHERE E2.E2_FORNECE = A2.A2_COD AND E2.E2_LOJA = A2.A2_LOJA AND"
//Trocado a data para pegar somente os títulos incluídos dentro do mês - Marcos Furtado 08/01/2007.
//cQuery += " E2.E2_EMISSAO >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
//cQuery += " E2.E2_EMISSAO <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " E2.E2_EMIS1 >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " E2.E2_EMIS1 <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " E2.E2_NATUREZ = ED.ED_CODIGO AND"

cQuery += " E2.E2_CCONT = CTT.CTT_CUSTO AND"
cQuery += " ED.ED_CONTA NOT IN " + cCompras + "  AND "	
cQuery += " E2.D_E_L_E_T_ <> '*' AND A2.D_E_L_E_T_ <> '*' AND ED.D_E_L_E_T_ <> '*' AND CTT.D_E_L_E_T_ <> '*'" 
MEMOWRIT("COMPRAS.SQL",cQuery)

TcQuery cQuery Alias "COM" NEW

DbSelectArea("COM")
ProcRegua(RecCount())
DbGoTop()         

_cFilial := COM->E2_FILIAL
    
While !Eof() 
    
    IncProc()

    nTamLin  := 913
    cLin     := Space(nTamLin)+cEOL  // Variavel para criacao da linha do registros para gravacao    

    cTipoReg := "03"                        
    cCliCob  := Space(8)
    cCnpjCob := Space(14)
    cNomCob  := Space(40)
    
    If Alltrim(COM->E2_ORIGEM) == "MATA100"
	
		cSerie := "1" 

		If COM->E2_FILIAL == "03" .And. Alltrim(COM->E2_PREFIXO) == "UN1"
		   cSerie := "1"        
		Endif
		If COM->E2_FILIAL == "03" .And. Alltrim(COM->E2_PREFIXO) == "UN2"
		   cSerie := "2"        
		Endif	
	    If COM->E2_FILIAL == "06" .OR. COM->E2_FILIAL == "11"
	       cSerie := IIF(Alltrim(COM->E2_PREFIXO) == "CTR" .OR. Alltrim(COM->E2_PREFIXO) == "UNS","U","A") 
	    Endif
	
		DbSelectArea("SF3")
		DbSetOrder(6) // FILIAL + NOTA + SERIE
		Dbgotop()
		If !DbSeek(COM->E2_FILIAL + COM->E2_NUM + cSerie)
	       cCliDest := Space(8)
	       cCfop    := Space(5)
	       cNomCfop := Space(55)
	 	   cCnpjDest:= Space(14)
	       cNomDest := Space(40)
	       DbSelectArea("COM")
	       dbSkip()          
	       Loop
	
		Else    
	
	       If Substr(SF3->F3_CFO,1,1) == "1" .Or. Substr(SF3->F3_CFO,1,1) == "2"	
		      cCliDest := SF3->F3_CLIEFOR+SF3->F3_LOJA 
	          cCfop    := SF3->F3_CFO + Space(5 - Len(SF3->F3_CFO))
	          cNomCfop := Tabela("13",Alltrim(cCfop)) + Space(55 - Len(Tabela("13",Alltrim(cCfop))))	      	  
	      	  DbSelectArea("SA2")
	          DbSetOrder(1) 
	          Dbgotop()
	          If DbSeek(xFilial("SA2") + cCliDest)
	    	     cCnpjDest:= SA2->A2_CGC + Space(14 - Len(SA2->A2_CGC))
	 	         cNomDest := SA2->A2_NOME + Space(40 - Len(SA2->A2_NOME))
	          Endif	       
	       Else          	
	          DbSelectArea("COM")
	          dbSkip()          
	          Loop	
		   Endif          
        
        Endif
        
	Else
	        
        cSerie   := " "	
        cCliDest := Space(8)
        cCfop    := Space(5)
        cNomCfop := Space(55)
        cCnpjDest:= Space(14)
        cNomDest := Space(40)
	
	Endif
	
	    
    cFornece := COM->E2_FORNECE + COM->E2_LOJA
    cNomFor  := COM->A2_NOME + Space(40 - Len(COM->A2_NOME))
    cCnpjFor := COM->A2_CGC + Space(14 - Len(COM->A2_CGC))
    
    cCodCusto := COM->E2_CCONT + Space(10 - Len(COM->E2_CCONT))
    cNomCusto := COM->CTT_DESC01 + Space(40 - Len(COM->CTT_DESC01))
   
    cCodDiv := Substr(COM->E2_CCONT,1,1)
    cNomDiv := GEFDIVISAO(cCodDiv) + Space(20 - Len(GEFDIVISAO(cCodDiv)))

    cCodUO  := Substr(COM->E2_CCONT,2,2)
    cNomUO  := UO(cCodUO) + Space(40 - Len(UO(cCodUO)))

    cCodFil := Substr(COM->E2_CCONT,4,3)
    cNomFil := GEFFILIAL(cCodFil) + Space(40 - Len(GEFFILIAL(cCodFil)))

    cCodAtv := Substr(COM->E2_CCONT,7,3)
    cNomAtv := Atividade(cCodAtv,cCodUO) + Space(60 - Len(Atividade(cCodAtv,cCodUO)))

    cCodPolo:= Substr(COM->E2_CCONT,10,1)
    cNomPolo:= Polo(cCodPolo) + Space(40 - Len(Polo(cCodPolo)))

    cConta  := COM->ED_CONTA + Space(20 - Len(COM->ED_CONTA))
	
	dbSelectArea("CT1")
	dbSetOrder(1)
	If MsSeek(xFilial()+cConta)
       cNomConta := CT1->CT1_DESC01 + Space(20 - Len(CT1->CT1_DESC01))
    Else
       cNomConta := Space(40)        
    Endif
    
	If SubStr(cConta,1,1) == "7" .or. SubStr(cConta,1,1) == "8"
		//Plano Gerencial do Historique

		_cQry := ""	
		_cQry := "SELECT * FROM " + RetSqlName("CTS") + " CTS "
		_cQry += "	WHERE RTRIM(CTS.CTS_CODPLA) = '001' " 
		_cQry += "	  AND RTRIM(CTS.CTS_CT1INI) = '" + Alltrim(cConta) + "' "
		_cQry += "	  AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
		_cQry += "	  AND CTS.D_E_L_E_T_ <> '*' "                  
		_cQry += "	  ORDER BY CTS_CODPLA, CTS_CONTAG , CTS_CT1INI "                  	
	
	ElseIf SubStr(cConta,1,1) == "1" .or. SubStr(cConta,1,1) == "2"	
		//Plano Gerencial do FINRM 
		//013 1 ou 2
		_cQry := ""	
		_cQry := "SELECT * FROM " + RetSqlName("CTS") + " CTS "
		_cQry += "	WHERE RTRIM(CTS.CTS_CODPLA) = '013' " 
		_cQry += "	  AND '" + Alltrim(cConta) + "' >= RTRIM(CTS.CTS_CT1INI)"
		_cQry += "	  AND '" + Alltrim(cConta) + "' <= RTRIM(CTS.CTS_CT1FIM) "		
		_cQry += "	  AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
		_cQry += "	  AND CTS.D_E_L_E_T_ <> '*' "                  
		_cQry += "	  ORDER BY CTS_CODPLA, CTS_CONTAG , CTS_CT1INI "  
		
	EndIF                	

	If Select("TCTS") > 0
	   dbSelectArea("TCTS")
	   dbCloseArea()
	EndIf
	
	TCQUERY _cQry ALIAS "TCTS" NEW
	dbSelectArea("TCTS") 
	dbGoTop()	    	

    cContaGer := TCTS->CTS_CONTAG + Space(20 - Len(TCTS->CTS_CONTAG)) 
    cNomGeren := TCTS->CTS_DESCCG + Space(20 - Len(TCTS->CTS_DESCCG)) 
 
    DbSelectArea("COM")

    cTipoDoc   := COM->E2_TIPO + Space(3 - Len(COM->E2_TIPO)) 
    cCodFatura := Space(6) 
    cNumBoleto := Space(12)
    cNumDoc    := COM->E2_PREFIXO + Space(3 - Len(COM->E2_PREFIXO)) + COM->E2_NUM + Space(6 - Len(COM->E2_NUM)) 
    
    cDtFatura  := Space(8)
    cDtBoleto  := Space(8)
    cDtDoc     := IIF(EMPTY(COM->E2_EMISSAO),Space(8),COM->E2_EMISSAO)
    cDtContab  := IIF(EMPTY(COM->E2_EMIS1),Space(8),COM->E2_EMIS1) 
    
    nValor     := STRZERO(COM->E2_VALOR * 100,19,0)     // N(17,2)
    
    cImposto   := Space(20)
    
    cRefgefco  := Space(20)
    cCustoPSA  := Space(20)
    cOIPSA     := Space(20)
    cTipoDesp  := Space(3)
    cLote      := Space(18)
    cDescLote  := Space(120)    
    lManual    := "N"
    FlagProv   := "N"
    TipoCnt    := "G"

    cLin := cTipoReg + cCliCob + cCnpjCob + cNomCob + cCliDest + cCnpjDest + cNomDest + cFornece + cNomFor + cCnpjFor + cCodCusto + cNomCusto + cCodDiv + cNomDiv + cCodUO + cNomUO + cCodFil + cNomFil + cCodAtv + cNomAtv + cCodPolo + cNomPolo + cConta 
    cLin := cLin + cNomConta + cContaGer + cNomGeren + cTipoDoc + cCodFatura + cNumBoleto + cNumDoc + cDtFatura  + cDtBoleto + cDtDoc + cDtContab + nValor + cImposto + cCfop + cNomCfop + cRefgefco + cCustoPSA + cOIPSA + cTipoDesp 
    cLin := cLin + cLote + cDescLote + lManual + FlagProv + TipoCnt + cSinal + cEOL
    nReg++


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
    //³ linha montada.                                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If lAutoRela
			Conout("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.")
		Else
			MsgAlert("Ocorreu um erro na gravacao do arquivo.","Atencao!")
		EndIf
		Exit
    Endif

    dbSkip()

EndDo              
DbSelectArea("COM")
DbCloseArea()

//If nReg == 0   
//   Ferase(cPathori)                   
//Endif

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³ FctImpostosº Autor ³ GEFCO              º Data ³  06/11/05 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Funcao responsável por processar os dados de Impostos      º±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function FctImpostos()



Local cCfop := ""


StartVar()

V_SF3     := RETSQLNAME("SF3")
V_Se1     := RETSQLNAME("SE1")
V_Sa1     := RETSQLNAME("SA1")
V_SED     := RETSQLNAME("SED")
V_CTT     := RETSQLNAME("CTT")

_cFilial  := ""
nValorFil := 0
nTotalG   := 0
_cFilAnt  := ""   
cTipoReg  := "04"         
cSinal   := "-"

// Livro Fiscal - NF Entrada e saida

//Lista de Cfops que serão ignorados       
cCfop := "('6921', '5921', '5552','6552', '5553', '6553', '6949','5949','5556','6556','5901','6901'," 
cCfop += "'5902', '6902', '5915','6915', '6903', '5903', '5916','6916','5908','6908','5909','6909'," 
cCfop += "'5913', '6913', '5210','6210', '5910', '6910','5556','6556','6552','5552','5553','6553'," 
cCfop += "'5557', '6557')" 


cQuery =  " SELECT * "
cQuery += " FROM "+V_SF3+" AS F3 "
cQuery += " WHERE F3.F3_EMISSAO >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " F3.F3_EMISSAO <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " F3.F3_DTCANC = '' AND "
cQuery += " F3_ALIQICM <> 0 AND "
cQuery += " F3_CFO NOT IN " + cCfop+ "  AND "	
cQuery += " F3.D_E_L_E_T_ <> '*' " 
cQuery += " ORDER BY F3.F3_CLIEFOR,F3.F3_LOJA" 
MEMOWRIT("XX4.SQL",cQuery)

TcQuery cQuery Alias "IMP" NEW
DbSelectArea("IMP")
ProcRegua(RecCount())
DbGoTop()         

_cFilial := IMP->F3_FILIAL
    
While !Eof() 
    
    IncProc()
 
    If Substr(IMP->F3_CFO,1,1) == "1" .Or. Substr(IMP->F3_CFO,1,1) == "2" // NF.Entradas
    	DbSelectArea("IMP")
	    dbSkip()
	    Loop
	EndIF

    nTamLin  := 913
    cLin     := Space(nTamLin)+cEOL  

    cTipoReg := "04"                         
    cCliCob  := Space(8)   
    cCnpjCob := Space(14)  
    cNomCob  := Space(40)  

    cCliDest := IMP->F3_CLIEFOR + IMP->F3_LOJA 
    cCfop    := IMP->F3_CFO + Space(5 - Len(SF3->F3_CFO))
    cNomCfop := Tabela("13",Alltrim(cCfop)) + Space(55 - Len(Tabela("13",Alltrim(cCfop))))


    cConta  := Space(20)

    lSimples := .F.
    
    If Alltrim(cCfop) $ "5910/5915/5921/5949/6902/6903/6915/6921/6949"
       lSimples := .T.
	EndIf

    If Alltrim(cCfop) $ "5901/5902/5908/5909/5913/6210" 
       lSimples := .T.
	EndIf	       

    If Alltrim(cCfop) == "5552" .Or. Alltrim(cCfop) == "5553" .Or. Alltrim(cCfop) == "5556" .Or. Alltrim(cCfop) == "6553" .Or. Alltrim(cCfop) == "6556" .Or. Alltrim(cCfop) == "6552"
       lSimples := .T.
	EndIf

    If Alltrim(cCfop) $ "6909/6910/6913/6916/5916"
       lSimples := .T.
	EndIf

    If !lSimples
    
	    If Substr(IMP->F3_CFO,1,1) <> "1" .Or. Substr(IMP->F3_CFO,1,1) <> "2" // NF.Entradas
	    
		   DbSelectArea("SA1")
		   DbSetOrder(1) 
		   Dbgotop()
		   If DbSeek(xFilial("SA1") + cCliDest)
		      cCnpjDest:= SA1->A1_CGC + Space(14 - Len(SA1->A1_CGC))
		      cNomDest := SA1->A1_NOME + Space(40 - Len(SA1->A1_NOME))
		   Else
		      cCnpjDest:= Space(14)
		 	  cNomDest := Space(40)
		   Endif
           
           DbSelectArea("IMP")           
           Do Case
              Case Alltrim(IMP->F3_ESPECIE) == "CTR" .And. IMP->F3_FILIAL == "03" .And. Alltrim(IMP->F3_SERIE) == "1"
                   cPrefixo :=	"CTV"	   			
              Case Alltrim(IMP->F3_ESPECIE) == "NF" .And. IMP->F3_FILIAL == "03" .And. Alltrim(IMP->F3_SERIE) == "1"
                   cPrefixo :=	"UN1"	   			
              Case Alltrim(IMP->F3_ESPECIE) == "NF" .And. IMP->F3_FILIAL == "03" .And. Alltrim(IMP->F3_SERIE) == "2"
                   cPrefixo :=	"UN2"	   			
              Case Alltrim(IMP->F3_ESPECIE) == "CTR" .And. IMP->F3_FILIAL == "02" .And. Alltrim(IMP->F3_SERIE) == "1"
                   cPrefixo :=	"CTA"	   			
              Case Alltrim(IMP->F3_ESPECIE) == "RPS" .And. (IMP->F3_FILIAL == "06" .OR. IMP->F3_FILIAL == "11" ) .And. Alltrim(IMP->F3_SERIE) == "1"
                   cPrefixo :=	"1  "	   			
              Case Alltrim(IMP->F3_ESPECIE) == "NF" .And. IMP->F3_FILIAL <> "03" 
                   cPrefixo :=	"UNI"	   			
              Case Alltrim(IMP->F3_ESPECIE) == "NFST"
                   cPrefixo :=	"NFS"	   			
              Case Alltrim(IMP->F3_ESPECIE) == "CTR"
                   cPrefixo :=	"CTR"	   			
              Otherwise
                   cPrefixo :=	Substr(Alltrim(IMP->F3_ESPECIE),1,3)
           EndCase
           
		   xGfilial := IMP->F3_FILIAL     
		   xGnota   := IMP->F3_NFISCAL               
		   xParcela := " "
		   xTipo    := "NF"	   
		   
		   DbSelectArea("SE1")
		   DbSetOrder(1) 
		   Dbgotop()
		   If !DbSeek(xGfilial + cPrefixo + xGnota + xParcela + xTipo ) 
              DbSelectArea("IMP")           
		      DbSkip()
		      Loop		      
  		   Else
	
			   cCodCusto := SE1->E1_CCONT + Space(10 - Len(SE1->E1_CCONT))
	
			   DbSelectArea("CTT")
			   DbSetOrder(1) 
			   Dbgotop()
			   If DbSeek(xFilial("CTT")+SE1->E1_CCONT)
	   		      cNomCusto := CTT->CTT_DESC01 + Space(40 - Len(CTT->CTT_DESC01))   
			   Else
	   		      cNomCusto := CTT->CTT_DESC01 + Space(40 - Len(CTT->CTT_DESC01))   
	              //emporariamente irá ignorar centro de custo não cadastrados.
	              DbSelectArea("IMP")           
			      DbSkip()
			      Loop		      
							   		      
			   Endif
			    
			   DbSelectArea("SE1") 
			
			   cCodDiv := Substr(SE1->E1_CCONT,1,1)
			   cNomDiv := GEFDIVISAO(cCodDiv) + Space(20 - Len(GEFDIVISAO(cCodDiv)))
			
			   cCodUO  := Substr(SE1->E1_CCONT,2,2)
			   cNomUO  := UO(cCodUO) + Space(40 - Len(UO(cCodUO)))
			
			   cCodFil := Substr(SE1->E1_CCONT,4,3)
			   cNomFil := GEFFILIAL(cCodFil) + Space(40 - Len(GEFFILIAL(cCodFil)))
			
			   cCodAtv := Substr(SE1->E1_CCONT,7,3)
			   cNomAtv := Atividade(cCodAtv,cCodUO) + Space(60 - Len(Atividade(cCodAtv,cCodUO)))
			
			   cCodPolo:= Substr(SE1->E1_CCONT,10,1)
			   cNomPolo:= Polo(cCodPolo) + Space(40 - Len(Polo(cCodPolo)))
			
			   cTipoDoc   := SE1->E1_TIPO + Space(3 - Len(SE1->E1_TIPO)) 
			   cCodFatura := SE1->E1_FATURA + Space(6 - Len(SE1->E1_FATURA)) 
			   cNumBoleto := SE1->E1_NUMBCO + Space(12 - Len(SE1->E1_NUMBCO)) 
			   cNumDoc    := SE1->E1_PREFIXO + Space(3 - Len(SE1->E1_PREFIXO)) + SE1->E1_NUM + Space(6 - Len(SE1->E1_NUM)) 
			    
			   cDtFatura  := IIF(EMPTY(SE1->E1_DTFATUR),Space(8),Gravadata(SE1->E1_DTFATUR,.F.,8))   
			   cDtBoleto  := IIF(EMPTY(SE1->E1_DATABOR),Space(8),Gravadata(SE1->E1_DATABOR,.F.,8))  
			   cDtDoc     := IIF(EMPTY(SE1->E1_EMISSAO),Space(8),Gravadata(SE1->E1_EMISSAO,.F.,8))
			   cDtContab  := IIF(EMPTY(SE1->E1_EMIS1),Space(8),Gravadata(SE1->E1_EMIS1,.F.,8)) 	      
				
			   cRefgefco  := Alltrim(SE1->E1_REFGEF) + Space(20 - Len(Alltrim(SE1->E1_REFGEF))) 
			   cCustoPSA  := Alltrim(SE1->E1_CCPSA)  + Space(20 - Len(Alltrim(SE1->E1_CCPSA))) 
			   cOIPSA     := Alltrim(SE1->E1_OIPSA)  + Space(20 - Len(Alltrim(SE1->E1_OIPSA))) 
			   cTipoDesp  := Alltrim(SE1->E1_TPDESP) + Space(3 - Len(Alltrim(SE1->E1_TPDESP))) 
			   
			   DbSelectArea("SED")
			   DbSetOrder(1) 
			   Dbgotop()
			   If DbSeek(xFilial("SED")+SE1->E1_NATUREZ)
			      cConta  := SED->ED_CONTA + Space(20 - Len(SED->ED_CONTA))
			   Else
			      cConta  := Space(20)
			   Endif
						   
				
		       cFornece := Space(8)
		       cNomFor  := Space(40)
		       cCnpjFor := Space(14)		   
	
			   Endif
			   
		Else

           DbSelectArea("IMP")	
 	       cFornece := 	IMP->F3_CLIEFOR + IMP->F3_LOJA 
	 
		   DbSelectArea("SA2")
		   DbSetOrder(1) 
		   Dbgotop()
		   If DbSeek(xFilial("SA2") + cFornece)
    	      cNomFor  := SA2->A2_NOME + Space(40 - Len(SA2->A2_NOME))
		      cCnpjFor := SA2->A2_CGC + Space(14 - Len(SA2->A2_CGC))			  
		   Else
		      cCnpjDest:= Space(14)
		      cNomDest := Space(40)
		   Endif
	     
		   DbSelectArea("CTT")
		   DbSetOrder(1) 
		   Dbgotop()
		   If DbSeek(xFilial("CTT")+SE2->E2_CCONT)
   		      cNomCusto := CTT->CTT_DESC01 + Space(40 - Len(CTT->CTT_DESC01))   
		   Else
   		      cNomCusto := CTT->CTT_DESC01 + Space(40 - Len(CTT->CTT_DESC01))   
		   Endif
		    
		   //Falta ponterar o arquivo de contas a pagar
		   DbSelectArea("SE2") 
	       
		   cCodCusto := IMP->E2_CCONT + Space(10 - Len(IMP->E2_CCONT))
		   cNomCusto := IMP->CTT_DESC01 + Space(40 - Len(IMP->CTT_DESC01))   
		
		   cCodDiv := Substr(IMP->E2_CCONT,1,1)
		   cNomDiv := GEFDIVISAO(cCodDiv) + Space(20 - Len(GEFDIVISAO(cCodDiv)))
		
		   cCodUO  := Substr(IMP->E2_CCONT,2,2)
		   cNomUO  := UO(cCodUO) + Space(40 - Len(UO(cCodUO)))
		
		   cCodFil := Substr(IMP->E2_CCONT,4,3)
		   cNomFil := GEFFILIAL(cCodFil) + Space(40 - Len(GEFFILIAL(cCodFil)))
		
		   cCodAtv := Substr(IMP->E2_CCONT,7,3)
		   cNomAtv := Atividade(cCodAtv,cCodUO) + Space(60 - Len(Atividade(cCodAtv,cCodUO)))
		
		   cCodPolo:= Substr(IMP->E2_CCONT,10,1)
		   cNomPolo:= Polo(cCodPolo) + Space(40 - Len(Polo(cCodPolo)))
		
		   cTipoDoc   := IMP->E2_TIPO + Space(3 - Len(IMP->E2_TIPO)) 
		   cCodFatura := IMP->E2_FATURA + Space(6 - Len(IMP->E2_FATURA)) 
		   cNumBoleto := IMP->E2_NUMBCO + Space(12 - Len(IMP->E2_NUMBCO)) 
		   cNumDoc    := IMP->E2_PREFIXO + Space(3 - Len(IMP->E2_PREFIXO)) + IMP->E2_NUM + Space(6 - Len(IMP->E2_NUM)) 
		    
		   cDtFatura  := IIF(EMPTY(IMP->E2_DTFATUR),Space(8),Gravadata(IMP->E2_DTFATUR,.F.,8))   
		   cDtBoleto  := IIF(EMPTY(IMP->E2_DATABOR),Space(8),Gravadata(IMP->E2_DATABOR,.F.,8))  
		   cDtDoc     := IIF(EMPTY(IMP->E2_EMISSAO),Space(8),Gravadata(IMP->E2_EMISSAO,.F.,8))
		   cDtContab  := IIF(EMPTY(IMP->E2_EMIS1),Space(8),Gravadata(IMP->E2_EMIS1,.F.,8)) 	      

		   DbSelectArea("SED")
		   DbSetOrder(1) 
		   Dbgotop()
		   If DbSeek(xFilial("SED")+SE2->E2_NATUREZ)
		      cConta  := SED->ED_CONTA + Space(20 - Len(SED->ED_CONTA))
		   Else
		      cConta  := Space(20)
		   Endif
		
			
		   cRefgefco  := Space(20)
		   cCustoPSA  := Space(20)
		   cOIPSA     := Space(20)
		   cTipoDesp  := Space(3)	       
           cCliDest   := Space(8)	
	       cCnpjDest  := Space(14)
	       cNomDest   := Space(40)
		
		Endif       
    
    Else
     
     cCodCusto := Space(10)	
     cNomCusto := Space(40)	
     cCodDiv   := Space(1)	
     cNomDiv   := Space(20)	
     cCodUO    := Space(2)	
     cNomUO    := Space(40)	
     cCodFil   := Space(3)	
     cNomFil   := Space(40)	
     cCodAtv   := Space(3)	
     cNomAtv   := Space(60)	
     cCodPolo  := Space(1)	
     cNomPolo  := Space(40)	
     
     cNumDoc    := "   " + IMP->F3_NFISCAL+ Space(6 - Len(IMP->F3_NFISCAL)) 
     
	Endif

    DbSelectArea("IMP")		

	If IMP->F3_ALIQICM > 0 
       nValor := STRZERO(IMP->F3_VALICM * 100,19,0)   
    Else
       nValor := STRZERO(IMP->F3_VALCONT * 100,19,0)  
    Endif
    
    cImposto   := Substr(Alltrim(IMP->F3_OBSERV) + Space(20 - Len(Alltrim(IMP->F3_OBSERV))),1,20)

    If Empty(cImposto) .And. Alltrim(IMP->F3_TIPO) <> "S"
       cImposto := "Incidencia de ICMS  "          
    Endif
    
    If Empty(cImposto) .And. Alltrim(IMP->F3_TIPO) == "S"
       cImposto := "Incidencia de ISS   "              
    Endif
    
/*    DbSelectArea("SED")
    DbSetOrder(1) 
    Dbgotop()
    If DbSeek(xFilial("SED")+SE2->E2_NATUREZ)
       cConta  := SED->ED_CONTA + Space(20 - Len(SED->ED_CONTA))
    Else
       cConta  := Space(20)
    Endif*/
	
	dbSelectArea("CT1")
	dbSetOrder(1)
	If MsSeek(xFilial()+cConta)
       cNomConta := CT1->CT1_DESC01 + Space(20 - Len(CT1->CT1_DESC01))
    Else
       cNomConta := Space(40)        
    Endif
    
	_cQry := ""	
	_cQry := "SELECT * FROM " + RetSqlName("CTS") + " CTS "
	_cQry += "	WHERE RTRIM(CTS.CTS_CODPLA) = '001' " 
	_cQry += "	  AND RTRIM(CTS.CTS_CT1INI) = '" + Alltrim(cConta) + "' "
	_cQry += "	  AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
	_cQry += "	  AND CTS.D_E_L_E_T_ <> '*' "                  
	_cQry += "	  ORDER BY CTS_CODPLA, CTS_CONTAG , CTS_CT1INI "                  	
	
	If Select("TCTS") > 0
	   dbSelectArea("TCTS")
	   dbCloseArea()
	EndIf
	                      
	TCQUERY _cQry ALIAS "TCTS" NEW
	dbSelectArea("TCTS") 
	dbGoTop()	    	

    cContaGer := TCTS->CTS_CONTAG + Space(20 - Len(TCTS->CTS_CONTAG)) 
    cNomGeren := TCTS->CTS_DESCCG + Space(20 - Len(TCTS->CTS_DESCCG)) 
    cLote     := Space(18)
    cDescLote := Space(120)    
    lManual   := "N"
    FlagProv  := "N"

    TipoCnt   := " "

	If AllTrim(cConta) $ ("711101,711102,711103,711105,711106,711107,711108,711202,711203,711204")         
		
		/*******Compras    ********
		711101 FRETE RODOVIÁRIO
		711102 FRETE FERROVIÁRIO
		711103 FRETE FLUVIAL
		711105 FRETE MARÍTIMO NVOCC
		711106 FRETE AÉREO
		711107 ARMAZENAGEM
		711108 PEDÁGIO SOBRE FRETES
		711202 DESPACHANTES/ADUANA
		711203 OUTROS CUSTOS NVOCC
		711204 CMV DE EMBALAGENS
		******************************/
	    TipoCnt   := "C" //Compras
		       
	Else	
		_cQry := ""	
		_cQry := "SELECT * FROM " + RetSqlName("CTS") + " CTS "
		_cQry += "	WHERE RTRIM(CTS.CTS_CODPLA) = '001' " 
		_cQry += "	  AND RTRIM(CTS.CTS_CONTAG) = 'A01' " 				
		_cQry += "	  AND RTRIM(CTS.CTS_CT1INI) >= '" + Alltrim(cConta) + "' "
		_cQry += "	  AND RTRIM(CTS.CTS_CT1FIM) <= '" + Alltrim(cConta) + "' "		
		_cQry += "	  AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
		_cQry += "	  AND CTS.D_E_L_E_T_ <> '*' "                  
		_cQry += "	  ORDER BY CTS_CODPLA, CTS_CONTAG , CTS_CT1INI "  
		
		If Select("TCTS1") > 0
		   dbSelectArea("TCTS1")
		   dbCloseArea()
		EndIf
		
		TCQUERY _cQry ALIAS "TCTS1" NEW
		dbSelectArea("TCTS1") 
		dbGoTop()	    	
	
		If !Eof()
		    TipoCnt   := "V" //Vendas		
		Else
		    TipoCnt   := "G" //Gastos			
		EndIF
	EndIf    
    
    
    cLin := cTipoReg + cCliCob + cCnpjCob + cNomCob + cCliDest + cCnpjDest + cNomDest + cFornece + cNomFor + cCnpjFor + cCodCusto + cNomCusto + cCodDiv + cNomDiv + cCodUO + cNomUO + cCodFil + cNomFil + cCodAtv + cNomAtv + cCodPolo + cNomPolo + cConta 
    cLin := cLin + cNomConta + cContaGer + cNomGeren + cTipoDoc + cCodFatura + cNumBoleto + cNumDoc + cDtFatura  + cDtBoleto + cDtDoc + cDtContab + nValor + cImposto + cCfop + cNomCfop + cRefgefco + cCustoPSA + cOIPSA + cTipoDesp 
    cLin := cLin + cLote + cDescLote + lManual + FlagProv + TipoCnt + cSinal + cEOL
    nReg++

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
    //³ linha montada.                                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If lAutoRela
			Conout("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.")
		Else
			MsgAlert("Ocorreu um erro na gravacao do arquivo.","Atencao!")
		EndIf
		Exit
    Endif


    DbSelectArea("IMP")
    dbSkip()

EndDo                  

DbSelectArea("IMP")
DbCloseArea()    

//If nReg == 0   
//   Ferase(cPathori)                   
//Endif

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³ FctCtbDebº Autor ³ GEFCO                º Data ³  06/11/05 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Funcao responsável por processar os dados da Contabilizaçãoº±±
±±º          ³ manual a DEBITO.											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function FctCtbDeb()

     cTipoReg := Space(2)
     cCliCob  := Space(8)
     cCnpjCob := Space(14)
     cNomCob  := Space(40)
     cCliDest := Space(8)
     cCnpjDest:= Space(14)
     cNomDest := Space(40)
     cFornece := Space(8)
     cNomFor  := Space(40)
     cCnpjFor := Space(14)
     cCodCusto:= Space(10)
     cNomCusto:= Space(40)
     cCodDiv  := Space(1)
     cNomDiv  := Space(20)
     cCodUO   := Space(2)
     cNomUO   := Space(40)
     cCodFil  := Space(3)
     cNomFil  := Space(40)
     cCodAtv  := Space(3)
     cNomAtv  := Space(60)
     cCodPolo := Space(1)
     cNomPolo := Space(40)
     cConta   := Space(20)
     cNomConta:= Space(40)
     cContaGer:= Space(20)
     cNomGeren:= Space(20)
     cTipoDoc := Space(3)
     cCodFatura := Space(6)
     cNumBoleto := Space(12)
     cNumDoc  := Space(9)
     cDtFatura:= Space(8) 
     cDtBoleto:= Space(8)
     cDtDoc   := Space(8)
     cDtContab:= Space(8)
     nValor   := 0
     cImposto := Space(20)
     cCfop    := Space(5)
     cNomCfop := Space(55)
     cRefgefco:= Space(20)
     cCustoPSA:= Space(20)
     cOIPSA   := Space(20)
     cTipoDesp:= Space(3)
     cNomeAtv := Space(60)


V_CT1     := RETSQLNAME("CT1")
V_CT2     := RETSQLNAME("CT2")
V_CTT     := RETSQLNAME("CTT")

_cFilial  := ""
nValorFil := 0
nTotalG   := 0
_cFilAnt  := ""   
cTipoReg  := "05"             
cSinal   := "-"

cQuery =  "SELECT * "
cQuery += "FROM "+V_CT1+" AS CT1 ,"+V_CT2+" AS CT2 ,"+V_CTT+" AS CTT "
cQuery += "WHERE (CT2.CT2_DC = '1' OR CT2.CT2_DC = '3') AND "
cQuery += "CT2.CT2_DATA >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += "CT2.CT2_DATA <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += "CT2.CT2_CCD = CTT.CTT_CUSTO AND "	
cQuery += "CT2.CT2_DEBITO = CT1.CT1_CONTA AND "	
cQuery += "CT2_ROTINA = 'CTBA102' AND "	
cQuery += "CT2.D_E_L_E_T_ <> '*' " 
cQuery += "ORDER BY CT2.CT2_DEBITO "
MEMOWRIT("XX2.SQL",cQuery)

TcQuery cQuery Alias "COMCTB" NEW

DbSelectArea("COMCTB")
DbGoTop()         

ProcRegua(RecCount())

_cFilial := COMCTB->CT2_FILIAL
    
While !Eof() 
    
    IncProc()

    nTamLin  := 913
    cLin     := Space(nTamLin)+cEOL 
    cTipoReg := "05"                        
    cCliCob  := Space(8)
    cCnpjCob := Space(14)
    cNomCob  := Space(40)    
	cSerie   := "1" 
    cFornece := Space(8)
    cNomFor  := Space(40)
    cCnpjFor := Space(14)    
    
    cCodCusto := COMCTB->CT2_CCD + Space(10 - Len(COMCTB->CT2_CCD))
    cNomCusto := COMCTB->CTT_DESC01 + Space(40 - Len(COMCTB->CTT_DESC01))
   
    cCodDiv := Substr(COMCTB->CT2_CCD,1,1)
    cNomDiv := GEFDIVISAO(cCodDiv) + Space(20 - Len(GEFDIVISAO(cCodDiv)))

    cCodUO  := Substr(COMCTB->CT2_CCD,2,2)
    cNomUO  := UO(cCodUO) + Space(40 - Len(UO(cCodUO)))

    cCodFil := Substr(COMCTB->CT2_CCD,4,3)
    cNomFil := GEFFILIAL(cCodFil) + Space(40 - Len(GEFFILIAL(cCodFil)))

    cCodAtv := Substr(COMCTB->CT2_CCD,7,3)
    cNomAtv := Atividade(cCodAtv,cCodUO) + Space(60 - Len(Atividade(cCodAtv,cCodUO)))

    cCodPolo:= Substr(COMCTB->CT2_CCD,10,1)
    cNomPolo:= Polo(cCodPolo) + Space(40 - Len(Polo(cCodPolo)))

    cConta  := COMCTB->CT1_CONTA  + Space(20 - Len(COMCTB->CT1_CONTA ))
	
	dbSelectArea("CT1")
	dbSetOrder(1)
	dbGotop()
	If MsSeek(xFilial()+cConta)
       cNomConta := CT1->CT1_DESC01 + Space(20 - Len(CT1->CT1_DESC01))
    Else
       cNomConta := Space(40)        
    Endif


	If SubStr(cConta,1,1) == "7" .or. SubStr(cConta,1,1) == "8"
		//Plano Gerencial do Historique

		_cQry := ""	
		_cQry := "SELECT * FROM " + RetSqlName("CTS") + " CTS "
		_cQry += "	WHERE RTRIM(CTS.CTS_CODPLA) = '001' " 
		_cQry += "	  AND RTRIM(CTS.CTS_CT1INI) = '" + Alltrim(cConta) + "' "
		_cQry += "	  AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
		_cQry += "	  AND CTS.D_E_L_E_T_ <> '*' "                  
		_cQry += "	  ORDER BY CTS_CODPLA, CTS_CONTAG , CTS_CT1INI "                  	
	
	ElseIf SubStr(cConta,1,1) == "1" .or. SubStr(cConta,1,1) == "2"	
		//Plano Gerencial do FINRM 
		//013 1 ou 2
		_cQry := ""	
		_cQry := "SELECT * FROM " + RetSqlName("CTS") + " CTS "
		_cQry += "	WHERE RTRIM(CTS.CTS_CODPLA) = '013' " 
		_cQry += "	  AND '" + Alltrim(cConta) + "' >= RTRIM(CTS.CTS_CT1INI)"
		_cQry += "	  AND '" + Alltrim(cConta) + "' <= RTRIM(CTS.CTS_CT1FIM) "		
		_cQry += "	  AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
		_cQry += "	  AND CTS.D_E_L_E_T_ <> '*' "                  
		_cQry += "	  ORDER BY CTS_CODPLA, CTS_CONTAG , CTS_CT1INI "  
		
	EndIF                	
    

	If Select("TCTS") > 0
	   dbSelectArea("TCTS")
	   dbCloseArea()
	EndIf
	
	TCQUERY _cQry ALIAS "TCTS" NEW
	dbSelectArea("TCTS") 
	dbGoTop()	    	

    cContaGer := TCTS->CTS_CONTAG + Space(20 - Len(TCTS->CTS_CONTAG)) 
    cNomGeren := TCTS->CTS_DESCCG + Space(20 - Len(TCTS->CTS_DESCCG)) 
 
    DbSelectArea("COMCTB")

    cTipoDoc   := Space(3)
    cCodFatura := Space(6) 
    cNumBoleto := Space(12)
    cNumDoc    := Space(9)
    cDtFatura  := Space(8)
    cDtBoleto  := Space(8)
    cDtDoc     := IIF(EMPTY(COMCTB->CT2_DATA),Space(8),COMCTB->CT2_DATA)
    cDtContab  := IIF(EMPTY(COMCTB->CT2_DATA),Space(8),COMCTB->CT2_DATA)     
    nValor     := STRZERO(COMCTB->CT2_VALOR * 100,19,0)    
    cImposto   := Space(20)    
    cRefgefco  := Space(20)
    cCustoPSA  := Space(20)
    cOIPSA     := Space(20)
    cTipoDesp  := Space(3)
     
    cLote     := COMCTB->CT2_LOTE + COMCTB->CT2_SBLOTE + COMCTB->CT2_DOC + COMCTB->CT2_LINHA
    cDescLote := Alltrim(COMCTB->CT2_HIST) + Space(120 - Len(Alltrim(COMCTB->CT2_HIST))) 
       
    lManual   := "S"
    FlagProv  := "N"

	If AllTrim(cConta) $ ("711101,711102,711103,711105,711106,711107,711108,711202,711203,711204") 
		
		/*******Compras    ********
		711101 FRETE RODOVIÁRIO
		711102 FRETE FERROVIÁRIO
		711103 FRETE FLUVIAL
		711105 FRETE MARÍTIMO NVOCC
		711106 FRETE AÉREO
		711107 ARMAZENAGEM
		711108 PEDÁGIO SOBRE FRETES
		711202 DESPACHANTES/ADUANA
		711203 OUTROS CUSTOS NVOCC
		711204 CMV DE EMBALAGENS
		******************************/
	    TipoCnt   := "C" //Compras
		       
	Else	
		_cQry := ""	
		_cQry := "SELECT * FROM " + RetSqlName("CTS") + " CTS "
		_cQry += "	WHERE RTRIM(CTS.CTS_CODPLA) = '001' " 
		_cQry += "	  AND RTRIM(CTS.CTS_CONTAG) = 'A01' " 		
		_cQry += "	  AND RTRIM(CTS.CTS_CT1INI) >= '" + Alltrim(cConta) + "' "
		_cQry += "	  AND RTRIM(CTS.CTS_CT1FIM) <= '" + Alltrim(cConta) + "' "		
		_cQry += "	  AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
		_cQry += "	  AND CTS.D_E_L_E_T_ <> '*' "                  
		_cQry += "	  ORDER BY CTS_CODPLA, CTS_CONTAG , CTS_CT1INI "  
		
		If Select("TCTS1") > 0
		   dbSelectArea("TCTS1")
		   dbCloseArea()
		EndIf
		
		TCQUERY _cQry ALIAS "TCTS1" NEW
		dbSelectArea("TCTS1") 
		dbGoTop()	    	
	
		If !Eof()
		    TipoCnt   := "V" //Vendas		
		Else
		    TipoCnt   := "G" //Gastos			
		EndIF
	EndIf    


    cLin := cTipoReg + cCliCob + cCnpjCob + cNomCob + cCliDest + cCnpjDest + cNomDest + cFornece + cNomFor + cCnpjFor + cCodCusto + cNomCusto + cCodDiv + cNomDiv + cCodUO + cNomUO + cCodFil + cNomFil + cCodAtv + cNomAtv + cCodPolo + cNomPolo + cConta 
    cLin := cLin + cNomConta + cContaGer + cNomGeren + cTipoDoc + cCodFatura + cNumBoleto + cNumDoc + cDtFatura  + cDtBoleto + cDtDoc + cDtContab + nValor + cImposto + cCfop + cNomCfop + cRefgefco + cCustoPSA + cOIPSA + cTipoDesp 
    cLin := cLin + cLote + cDescLote + lManual + FlagProv + TipoCnt + cSinal + cEOL
    nReg++


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
    //³ linha montada.                                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If lAutoRela
			Conout("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.")
		Else
			MsgAlert("Ocorreu um erro na gravacao do arquivo.","Atencao!")
		EndIf
		Exit
    Endif
	DbSelectArea("COMCTB")
    dbSkip()

EndDo                 

DbSelectArea("COMCTB")
DbCloseArea()

//If nReg == 0   
//   Ferase(cPathori)                   
//Endif


Return()

      
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³ FctCtbCredº Autor ³ GEFCO              º Data ³  06/11/05 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Funcao responsável por processar os dados da Contabilizaçãoº±±
±±º          ³ manual a CREDITO.										  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function FctCtbCred()


     cTipoReg := Space(2)
     cCliCob  := Space(8)
     cCnpjCob := Space(14)
     cNomCob  := Space(40)
     cCliDest := Space(8)
     cCnpjDest:= Space(14)
     cNomDest := Space(40)
     cFornece := Space(8)
     cNomFor  := Space(40)
     cCnpjFor := Space(14)
     cCodCusto:= Space(10)
     cNomCusto:= Space(40)
     cCodDiv  := Space(1)
     cNomDiv  := Space(20)
     cCodUO   := Space(2)
     cNomUO   := Space(40)
     cCodFil  := Space(3)
     cNomFil  := Space(40)
     cCodAtv  := Space(3)
     cNomAtv  := Space(60)
     cCodPolo := Space(1)
     cNomPolo := Space(40)
     cConta   := Space(20)
     cNomConta:= Space(40)
     cContaGer:= Space(20)
     cNomGeren:= Space(20)
     cTipoDoc := Space(3)
     cCodFatura := Space(6)
     cNumBoleto := Space(12)
     cNumDoc  := Space(9)
     cDtFatura:= Space(8) 
     cDtBoleto:= Space(8)
     cDtDoc   := Space(8)
     cDtContab:= Space(8)
     nValor   := 0
     cImposto := Space(20)
     cCfop    := Space(5)
     cNomCfop := Space(55)
     cRefgefco:= Space(20)
     cCustoPSA:= Space(20)
     cOIPSA   := Space(20)
     cTipoDesp:= Space(3)
     cNomeAtv := Space(60)


V_CT1     := RETSQLNAME("CT1")
V_CT2     := RETSQLNAME("CT2")
V_CTT     := RETSQLNAME("CTT")

_cFilial  := ""
nValorFil := 0
nTotalG   := 0
_cFilAnt  := ""   
cTipoReg  := "06"              
cSinal   := "+"

cQuery =  "SELECT * "
cQuery += "FROM "+V_CT1+" AS CT1 ,"+V_CT2+" AS CT2 ,"+V_CTT+" AS CTT "
cQuery += "WHERE (CT2.CT2_DC = '1' OR CT2.CT2_DC = '3') AND "
cQuery += "CT2.CT2_DATA >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += "CT2.CT2_DATA <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += "CT2.CT2_CCC = CTT.CTT_CUSTO AND "	
cQuery += "CT2.CT2_CREDIT = CT1.CT1_CONTA AND "	
cQuery += "CT2_ROTINA = 'CTBA102' AND "	
cQuery += "CT2.D_E_L_E_T_ <> '*' " 
cQuery += "ORDER BY CT2.CT2_CREDIT "

TcQuery cQuery Alias "COMCTB" NEW

DbSelectArea("COMCTB")
DbGoTop()         

ProcRegua(RecCount())

_cFilial := COMCTB->CT2_FILIAL
    
While !Eof() 
    
    IncProc()

    nTamLin  := 913
    cLin     := Space(nTamLin)+cEOL 
    cTipoReg := "06"                        
    cCliCob  := Space(8)
    cCnpjCob := Space(14)
    cNomCob  := Space(40)    
	cSerie   := "1" 
    cFornece := Space(8)
    cNomFor  := Space(40)
    cCnpjFor := Space(14)    
    
    cCodCusto := COMCTB->CT2_CCC + Space(10 - Len(COMCTB->CT2_CCC))
    cNomCusto := COMCTB->CTT_DESC01 + Space(40 - Len(COMCTB->CTT_DESC01))
   
    cCodDiv := Substr(COMCTB->CT2_CCC,1,1)
    cNomDiv := GEFDIVISAO(cCodDiv) + Space(20 - Len(GEFDIVISAO(cCodDiv)))

    cCodUO  := Substr(COMCTB->CT2_CCC,2,2)
    cNomUO  := UO(cCodUO) + Space(40 - Len(UO(cCodUO)))

    cCodFil := Substr(COMCTB->CT2_CCC,4,3)
    cNomFil := GEFFILIAL(cCodFil) + Space(40 - Len(GEFFILIAL(cCodFil)))

    cCodAtv := Substr(COMCTB->CT2_CCC,7,3)
    cNomAtv := Atividade(cCodAtv,cCodUO) + Space(60 - Len(Atividade(cCodAtv,cCodUO)))

    cCodPolo:= Substr(COMCTB->CT2_CCC,10,1)
    cNomPolo:= Polo(cCodPolo) + Space(40 - Len(Polo(cCodPolo)))

    cConta  := COMCTB->CT1_CONTA  + Space(20 - Len(COMCTB->CT1_CONTA ))
	
	dbSelectArea("CT1")
	dbSetOrder(1)
	dbGotop()
	If MsSeek(xFilial()+cConta)
       cNomConta := CT1->CT1_DESC01 + Space(20 - Len(CT1->CT1_DESC01))
    Else
       cNomConta := Space(40)        
    Endif
                                                  
    
	If SubStr(cConta,1,1) == "7" .or. SubStr(cConta,1,1) == "8"
		//Plano Gerencial do Historique

		_cQry := ""	
		_cQry := "SELECT * FROM " + RetSqlName("CTS") + " CTS "
		_cQry += "	WHERE RTRIM(CTS.CTS_CODPLA) = '001' " 
		_cQry += "	  AND RTRIM(CTS.CTS_CT1INI) = '" + Alltrim(cConta) + "' "
		_cQry += "	  AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
		_cQry += "	  AND CTS.D_E_L_E_T_ <> '*' "                  
		_cQry += "	  ORDER BY CTS_CODPLA, CTS_CONTAG , CTS_CT1INI "                  	
	
	ElseIf SubStr(cConta,1,1) == "1" .or. SubStr(cConta,1,1) == "2"	
		//Plano Gerencial do FINRM 
		//013 1 ou 2
		_cQry := ""	
		_cQry := "SELECT * FROM " + RetSqlName("CTS") + " CTS "
		_cQry += "	WHERE RTRIM(CTS.CTS_CODPLA) = '013' " 
		_cQry += "	  AND '" + Alltrim(cConta) + "' >= RTRIM(CTS.CTS_CT1INI)"
		_cQry += "	  AND '" + Alltrim(cConta) + "' <= RTRIM(CTS.CTS_CT1FIM) "		
		_cQry += "	  AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
		_cQry += "	  AND CTS.D_E_L_E_T_ <> '*' "                  
		_cQry += "	  ORDER BY CTS_CODPLA, CTS_CONTAG , CTS_CT1INI "  
		
	EndIF                	

	If Select("TCTS") > 0
	   dbSelectArea("TCTS")
	   dbCloseArea()
	EndIf
	
	TCQUERY _cQry ALIAS "TCTS" NEW
	dbSelectArea("TCTS") 
	dbGoTop()	    	

    cContaGer := TCTS->CTS_CONTAG + Space(20 - Len(TCTS->CTS_CONTAG)) 
    cNomGeren := TCTS->CTS_DESCCG + Space(20 - Len(TCTS->CTS_DESCCG)) 
 
    DbSelectArea("COMCTB")

    cTipoDoc   := Space(3)
    cCodFatura := Space(6) 
    cNumBoleto := Space(12)
    cNumDoc    := Space(9)
    cDtFatura  := Space(8)
    cDtBoleto  := Space(8)
    cDtDoc     := IIF(EMPTY(COMCTB->CT2_DATA),Space(8),COMCTB->CT2_DATA)
    cDtContab  := IIF(EMPTY(COMCTB->CT2_DATA),Space(8),COMCTB->CT2_DATA)     
    nValor     := STRZERO(COMCTB->CT2_VALOR * 100,19,0)    
    cImposto   := Space(20)    
    cRefgefco  := Space(20)
    cCustoPSA  := Space(20)
    cOIPSA     := Space(20)
    cTipoDesp  := Space(3)
     
    cLote     := COMCTB->CT2_LOTE + COMCTB->CT2_SBLOTE + COMCTB->CT2_DOC + COMCTB->CT2_LINHA
    cDescLote := Alltrim(COMCTB->CT2_HIST) + Space(120 - Len(Alltrim(COMCTB->CT2_HIST))) 
       
    lManual   := "S"
    FlagProv  := "N"            

	If AllTrim(cConta) $ ("711101,711102,711103,711105,711106,711107,711108,711202,711203,711204") 
		
		/*******Compras    ********
		711101 FRETE RODOVIÁRIO
		711102 FRETE FERROVIÁRIO
		711103 FRETE FLUVIAL
		711105 FRETE MARÍTIMO NVOCC
		711106 FRETE AÉREO
		711107 ARMAZENAGEM
		711108 PEDÁGIO SOBRE FRETES
		711202 DESPACHANTES/ADUANA
		711203 OUTROS CUSTOS NVOCC
		711204 CMV DE EMBALAGENS
		******************************/
	    TipoCnt   := "C" //Compras
		       
	Else	
		_cQry := ""	
		_cQry := "SELECT * FROM " + RetSqlName("CTS") + " CTS "
		_cQry += "	WHERE RTRIM(CTS.CTS_CODPLA) = '001' "       
		_cQry += "	  AND RTRIM(CTS.CTS_CONTAG) = 'A01' " 				
		_cQry += "	  AND RTRIM(CTS.CTS_CT1INI) >= '" + Alltrim(cConta) + "' "
		_cQry += "	  AND RTRIM(CTS.CTS_CT1FIM) <= '" + Alltrim(cConta) + "' "		
		_cQry += "	  AND CTS.CTS_FILIAL =  '" + xFilial("CTS") + "' "
		_cQry += "	  AND CTS.D_E_L_E_T_ <> '*' "                  
		_cQry += "	  ORDER BY CTS_CODPLA, CTS_CONTAG , CTS_CT1INI "  
		
		If Select("TCTS1") > 0
		   dbSelectArea("TCTS1")
		   dbCloseArea()
		EndIf
		
		TCQUERY _cQry ALIAS "TCTS1" NEW
		dbSelectArea("TCTS1") 
		dbGoTop()	    	
	
		If !Eof()
		    TipoCnt   := "V" //Vendas		
		Else
		    TipoCnt   := "G" //Gastos			
		EndIF
	EndIf    
    
    cLin := cTipoReg + cCliCob + cCnpjCob + cNomCob + cCliDest + cCnpjDest + cNomDest + cFornece + cNomFor + cCnpjFor + cCodCusto + cNomCusto + cCodDiv + cNomDiv + cCodUO + cNomUO + cCodFil + cNomFil + cCodAtv + cNomAtv + cCodPolo + cNomPolo + cConta 
    cLin := cLin + cNomConta + cContaGer + cNomGeren + cTipoDoc + cCodFatura + cNumBoleto + cNumDoc + cDtFatura  + cDtBoleto + cDtDoc + cDtContab + nValor + cImposto + cCfop + cNomCfop + cRefgefco + cCustoPSA + cOIPSA + cTipoDesp 
    cLin := cLin + cLote + cDescLote + lManual + FlagProv + TipoCnt + cSinal + cEOL
    nReg++


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
    //³ linha montada.                                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If lAutoRela
			Conout("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.")
		Else
			MsgAlert("Ocorreu um erro na gravacao do arquivo.","Atencao!")
		EndIf
		Exit
    Endif

	DbSelectArea("COMCTB")
    dbSkip()

EndDo                     
DbSelectArea("COMCTB")
DbCloseArea()

//If nReg == 0   
//   Ferase(cPathori)                   
//Endif


Return()




/*****************************************
Função que retorna a Divisão
******************************************/

STATIC FUNCTION GEFDIVISAO(cCodDiv)

   Do Case
      Case cCodDiv == "1"
           cNomDiv := "Automotive"
      Case cCodDiv == "2"
           cNomDiv := "Network"
      Case cCodDiv == "3"
           cNomDiv := "Supply"
      Case cCodDiv == "4"
           cNomDiv := "Siege"
      Case cCodDiv == "5"
           cNomDiv := "Informatique"
      Case cCodDiv == "6"
           cNomDiv := "Finance"
       Otherwise   
           cNomDiv := Space(20)      
   EndCase

RETURN(cNomDiv)



STATIC FUNCTION GEFFILIAL(cCodDiv)

_xFilCtb := cCodDiv

   Do Case
      Case _xFilCtb == "001"
           xFilRet := "MATRIZ"
      Case _xFilCtb == "002"
           xFilRet := "BENEDITINOS"
      Case _xFilCtb == "004"
           xFilRet :="PORTO REAL"
      Case _xFilCtb == "005"
           xFilRet :="BARUERI"
      Case _xFilCtb == "006"
           xFilRet :="PAVUNA"
      Case _xFilCtb == "007"
           xFilRet :="VILA GUILHERME"
      Case _xFilCtb == "008"
           xFilRet :="SAO JOSE DOS PINHAIS"
      Case _xFilCtb == "009"
           xFilRet :="CONTAGEM"
      Case _xFilCtb == "010"
           xFilRet :="CAMPINAS"
      Case _xFilCtb == "011"
           xFilRet :="SEPETIBA"
      Case _xFilCtb == "012"
           xFilRet :="VILA OLIMPIA"
      Case _xFilCtb == "013"
           xFilRet :="SANTOS"
      Case _xFilCtb == "014"
           xFilRet :="RIO BRANCO"
      Case _xFilCtb == "015"  
           xFilRet :="VITORIA"
      Case _xFilCtb == "016"  
           xFilRet :="SETE LAGOAS"
      Case _xFilCtb == "901"  
           xFilRet :="ANTENA - GUARULHOS"
      Case _xFilCtb == "902"  
           xFilRet :="SETE LAGOAS"
      OtherWise	                       
           xFilRet := Space(40)   
   EndCase


Return(xFilRet)


Static Function UO(cCodUO)

   xUO := cCodUO
   
   Do Case
      Case xUO == "01"
           xDesc := "RDVM"
      Case xUO == "02"
           xDesc := "PVNO"     
      Case xUO == "11"
           xDesc := "RMLAP"     
      Case xUO == "21"
           xDesc := "ILI"     
      Case xUO == "22"
           xDesc := "RMA"
      Case xUO == "23"
           xDesc := "ADUANA"         
      Case xUO == "31"
           xDesc := "DIREÇÃO GERAL"
      Case xUO == "32"
           xDesc := "DFCP"     
      Case xUO == "33"
           xDesc := "DRHCO"     
      Case xUO == "34" 
           xDesc := "DIREÇÃO COMERCIAL"
      Case xUO == "35"
           xDesc := "QUALIDADE"
      Case xUO == "36"
           xDesc := "MARKETING"         
      Case xUO == "37"
           xDesc := "ADMINISTRATIVO"
      Case xUO == "38"
           xDesc := "DIR GERAL LOG PSA"
      Case xUO == "51"
           xDesc := "INFORMATICA"     
      Case xUO == "61"
           xDesc := "FINANCEIRO CORPORATIVO"     
      OtherWise	                 
        xDesc := Space(40)   
   EndCase

Return(xDesc)


Static Function Atividade(cCodAtv,cCodUO)

  xUO := cCodUO
  cNomeAtv := Space(60)   
  
  
   If Empty(xUO) .Or. xUO == ""
      cNomeAtv := Space(60)    
   Endif

   If xUO == "01" .Or. xUO == "02"    // RDVM
	   // Atividades - Metier
	   // RDVM
	   Do Case	    
	      Case cCodAtv == "001"  	      
	           cNomeAtv := "Transporte Rodoviario Nacional"	
	      Case cCodAtv == "002"   
	           cNomeAtv := "Transporte Rodoviario Nacional de Transferência"
	      Case cCodAtv == "003"  
	           cNomeAtv := "Transporte Rodoviario Exportação"
	      Case cCodAtv == "004"   
	           cNomeAtv := "Transporte Maritimo Exportação"
	      Case cCodAtv == "005"   
	           cNomeAtv := "Gestão Nacional"
	      Case cCodAtv == "006"   
	           cNomeAtv := "Gestão Exportação"
	      Case cCodAtv == "007"   
	           cNomeAtv := "Survey Nacional"
	      Case cCodAtv == "008"   
	           cNomeAtv := "Survey Exportação"
	      Case cCodAtv == "009"   
	           cNomeAtv := "Tropicalização"
	      Case cCodAtv == "010"   
	           cNomeAtv := "Armazenagem Nacional"
	      Case cCodAtv == "011"   
	           cNomeAtv := "Armazenagem Importação"
	      Case cCodAtv == "012"   
	           cNomeAtv := "Armazenagem Exportação"
	      Case cCodAtv == "013"  
	           cNomeAtv := "Outros Serviços Logisticos"
	      Case cCodAtv == "014"  
	           cNomeAtv := "Transporte Marítmo Importação"
	      Case cCodAtv == "015"  
	           cNomeAtv := "Transporte Rodoviário Importação"
	      Case cCodAtv == "016"  
	           cNomeAtv := "Desembaraço Exportação Rodoviária"
	      Case cCodAtv == "017"  
	           cNomeAtv := "Desembaraço Importação Rodoviária"
	      Case cCodAtv == "101"  
	           cNomeAtv := "PVN - VN"
	      Case cCodAtv == "102"   
	           cNomeAtv := "PVN - VO"
	      OtherWise	           
	           cNomeAtv := Space(60) 
	   EndCase             

   Endif
     
   If xUO == "21"        // ILI
	   // Atividades - Metier
	   // Supply / ILI
	   Do Case
	      Case cCodAtv == "301"   
	           cNomeAtv := "Abastecimento Sincrono"	           
	      Case cCodAtv == "302"   
	           cNomeAtv := "Abastecimento Kanban"
	      Case cCodAtv == "303"   
	           cNomeAtv := "Preparação de Kits"
	      Case cCodAtv == "304"    
	           cNomeAtv := "Armazenagem"
	      Case cCodAtv == "305"   
	           cNomeAtv := "Outsourcing"
	      Case cCodAtv == "306"   
	           cNomeAtv := "Preparação de Embalagens"
	      Case cCodAtv == "307"   
	           cNomeAtv := "Consultoria Logistica"
	      OtherWise
	           cNomeAtv := Space(60) 
	   EndCase             

   Endif
  

   If xUO == "11" //.And. xFilRet == "01"       //Rmlap
	   // Atividades - Metier
	   // Network / RMLAP
	   Do Case
	      Case cCodAtv == "201"   
	           cNomeAtv := "Carga Fechada Nacional"              	           
	      Case cCodAtv == "202"   
	           cNomeAtv := "Carga Fechada Internacional" 
	      Case cCodAtv == "203"   
	           cNomeAtv := "Carga Fracionada Nacional" 
	      Case cCodAtv == "204"    
	           cNomeAtv := "Carga Fracionada Internacional"
	      Case cCodAtv == "205"   
	           cNomeAtv := "Lote Nacional"
	      Case cCodAtv == "206"   
	           cNomeAtv := "Intercentro Nacional"
	      Case cCodAtv == "207"   
	           cNomeAtv := "Lote Internacional"
	      Case cCodAtv == "208"   
	           cNomeAtv := "Intercentro Internacional"
	      Case cCodAtv == "209"   
	           cNomeAtv := "Transporte Emergencial Nacional"
	      Case cCodAtv == "210"   
	           cNomeAtv := "Gefco Especial"
	      Case cCodAtv == "211"   
	           cNomeAtv := "Carga fechada Nacional Spot"
	      Case cCodAtv == "212"   
	           cNomeAtv := "Transporte Emergencial Internacional"
	      OtherWise
	           cNomeAtv := Space(60) 
	   EndCase             
	             	          
   Endif
   

   If xUO == "22" 
	   // Atividades - Metier
	   // RMA

	   Do Case
	      Case cCodAtv == "401"   
	           cNomeAtv := "Importação Maritima"	           
	      Case cCodAtv == "402"   
	           cNomeAtv := "Exportação Maritima"
	      Case cCodAtv == "403"   
	           cNomeAtv := "Importação Aérea"
	      Case cCodAtv == "404"    
	           cNomeAtv := "Exportação Aérea"
	      Case cCodAtv == "405"   
	           cNomeAtv := "Gefco Immediate Importação"
	      Case cCodAtv == "406"   
	           cNomeAtv := "Gefco Immediate Exportação"
	      Case cCodAtv == "407"   
	           cNomeAtv := "Armazenagem"
	      Case cCodAtv == "408"   
	           cNomeAtv := "CKD"
	      Case cCodAtv == "409"   
	           cNomeAtv := "Outsourcing Importação"
	      Case cCodAtv == "410"   
	           cNomeAtv := "Outsourcing Exportação"
	      OtherWise
	           cNomeAtv := Space(60) 
	   EndCase             

   Endif
   
   If xUO == "23" 
	   // Atividades - Metier
	   // ADUANA

	   Do Case
	      Case cCodAtv == "501"   
	           cNomeAtv := "Desembaraço Importação Maritima"
	      Case cCodAtv == "502"   
	           cNomeAtv := "Desembaraço Importação Aérea"
	      Case cCodAtv == "503"   
	           cNomeAtv := "Desembaraço Exportação Maritima"
	      Case cCodAtv == "504"    
	           cNomeAtv := "Desembaraço Exportação Aérea"
	      Case cCodAtv == "505"   
	           cNomeAtv := "Desembaraço Importação Rodoviaria"
	      Case cCodAtv == "506"   
	           cNomeAtv := "Desembaraço Exportação Rodoviaria"
	      Case cCodAtv == "507"   
	           cNomeAtv := "Outsourcing Importação"
	      Case cCodAtv == "508"   
	           cNomeAtv := "Outsourcing Exportação"
	      OtherWise
	           cNomeAtv := Space(60) 
	   EndCase             

   Endif
     
Return(cNomeAtv)


Static Function Polo(cCodPolo)

	   Do Case
	      Case cCodPolo == "1"   
	           cNomePolo := "Marca AP"
	      Case cCodPolo == "2"   
	           cNomePolo := "Marca AC"
	      Case cCodPolo == "3"   
	           cNomePolo := "DIFA"
	      Case cCodPolo == "4"    
	           cNomePolo := "DLPR"
	      Case cCodPolo == "5"   
	           cNomePolo := "Grupo Gefco"
	      Case cCodPolo == "6"   
	           cNomePolo := "Fora Grupo"
	      Case cCodPolo == "7"   
	           cNomePolo := "Intercentros"
	      OtherWise
	           cNomePolo := Space(40) 
	   EndCase             

Return(cNomePolo)


Static Function StartVar()

     cTipoReg := Space(2)
     cCliCob  := Space(8)
     cCnpjCob := Space(14)
     cNomCob  := Space(40)
     cCliDest := Space(8)
     cCnpjDest:= Space(14)
     cNomDest := Space(40)
     cFornece := Space(8)
     cNomFor  := Space(40)
     cCnpjFor := Space(14)
     cCodCusto:= Space(10)
     cNomCusto:= Space(40)
     cCodDiv  := Space(1)
     cNomDiv  := Space(20)
     cCodUO   := Space(2)
     cNomUO   := Space(40)
     cCodFil  := Space(3)
     cNomFil  := Space(40)
     cCodAtv  := Space(3)
     cNomAtv  := Space(60)
     cCodPolo := Space(1)
     cNomPolo := Space(40)
     cConta   := Space(20)
     cNomConta:= Space(40)
     cContaGer:= Space(20)
     cNomGeren:= Space(20)
     cTipoDoc := Space(3)
     cCodFatura := Space(6)
     cNumBoleto := Space(12)
     cNumDoc  := Space(9)
     cDtFatura:= Space(8) 
     cDtBoleto:= Space(8)
     cDtDoc   := Space(8)
     cDtContab:= Space(8)
     nValor   := 0
     cImposto := Space(20)
     cCfop    := Space(5)
     cNomCfop := Space(55)
     cRefgefco:= Space(20)
     cCustoPSA:= Space(20)
     cOIPSA   := Space(20)
     cTipoDesp:= Space(3)
     cNomeAtv := Space(60)
     
Return()


Static Function fDtExport()
Local aData		:=	{}
Local pData		:=  ""//dDataBase
Local dDia		:=	""//day(pData)
Local dMes		:=  ""//month(pData)
Local dAno		:=  ""//year(pData)
Local dDataDe	:=	""
Local dDataAte	:=	""
Local cMsg		:=  ""

//If lAutoRela
	pData		:=  dDataBase
//Else
//	pData		:= MV_PAR01
//EndIf

dDia		:=	day(pData)
dMes		:=  month(pData)
dAno		:=  year(pData)
dDataDe		:=	""
dDataAte	:=	""
cMsg		:=  ""
If dDia <=6 //Exporta mes passado
	dDataDe	:=ctod("01/"+str(dMes)+"/"+str(dAno))-1
	dDataAte:=dDataDe
	dDataDe:=ctod("01/"+str(month(dDataDe))+str(year(dDataDe)))
ElseIf dDia >=7 //Exporta mes corrente
	dDataDe	:=ctod("01/"+str(dMes+1)+"/"+str(dAno))-1
	dDataAte:=dDataDe
	dDataDe:=ctod("01/"+str(dMes)+"/"+str(dAno))
EndIf
If !Empty(dDataDe) .and. !Empty(dDataAte)
	aAdd(aData,dDataDe)
	aAdd(aData,dDataAte)
EndIf
Return aData

