#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EXPORTCTB º Autor ³ Saulo Muniz        º Data ³  14/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Arquivo de exportação de dados para Gefco Argentina        º±±
±±º          ³ Versão 1.01  - Gastos.txt                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gefco                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function EXPORTGST()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDlg,oGet
Local cFile := Space(200)

Private oGeraTxt

dbSelectArea("SE2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o de Arquivo Microsiga -> Gefco Argentina - Versão 1.01")
@ 002,10 TO 080,190
@ 10,018 Say " Este programa ira exportar os dados do sistema Microsiga de    "
@ 18,018 Say " acordo com os parâmetros definidos pelo usuario, retornando as "
@ 26,018 Say " informações para o sistema Sisges.                             "

@ 055,088 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 055,119 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 055,150 BMPBUTTON TYPE 05 ACTION Pergunte("GEFM50",.T.) 

Activate Dialog oGeraTxt Centered

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

Private cArqTxt  := "\\geatj1appl1\Protheus8\Protheus_Data\Exportar\Gastos.txt"
Private nHdl     := fCreate(cArqTxt)
Private cEOL     := "CHR(13)+CHR(10)"
Private cPathori := "\\geatj1appl1\Protheus8\Protheus_Data\Importar\FaturasAdhoc\Receber\"
Private cSinal   := "-"

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

Pergunte("GEFM50",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabec. do arquivo          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
xIndice  := "00"
DtPar01  := Gravadata(MV_PAR01,.F.,8) 
DtPar02  := Gravadata(MV_PAR02,.F.,8) 

_FHeader := xIndice + DtPar01 + DtPar02 + Space(896)+ cEOL

fWrite(nHdl,_FHeader,Len(_FHeader))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| RunCont() },"Processando...")

	If File(cPathori)
       Resposta := MSGBOX("Arquivo texto já existe, Deseja atualizar o arquivo !","Informa‡ao","YESNO")
       If Resposta
		  Ferase(cPathori)             
       Else	      
	      Return
	   Endif	   
	Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  06/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont()

Local nTamLin, cLin, cCpo, nReg
Private cNomeAtv

StartVar()

nReg := 0

V_Se2     := RETSQLNAME("SE2")
V_Sa2     := RETSQLNAME("SA2")
V_SED     := RETSQLNAME("SED")
V_CTT     := RETSQLNAME("CTT")

_cFilial  := ""
nValorFil := 0
nTotalG   := 0
_cFilAnt  := ""   
cTipoReg  := "01"



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

    cTipoReg := "01"                        
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
        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            Exit
        Endif
    Endif

    dbSkip()

EndDo

If nReg == 0   
   Ferase(cPathori)                   
Endif


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
Close(oGeraTxt)

Return()


STATIC FUNCTION GEFDIVISAO(cCodDiv)

cNomDiv := Space(20)      

// TABELA 

/*
1= DIVISAO 
2= UO
3= FILIAL
4= ATIVIDADE
5= POLO
*/

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
xFilRet := Space(40)   
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
   xDesc := Space(40)      
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
	           cNomeAtv := "Transporte Emergencial"
	      Case cCodAtv == "210"   
	           cNomeAtv := "Gefco Especial"
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
cNomePolo := Space(40) 
	           
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
     
Return