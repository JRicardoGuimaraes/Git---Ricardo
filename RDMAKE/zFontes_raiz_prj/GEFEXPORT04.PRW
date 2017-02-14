#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
//#include "FIVEWIN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEFEXPORT  º Autor ³ Saulo Muniz       º Data ³  24/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Arquivo de exportação de dados para Gefco Argentina        º±±
±±º          ³ Versão 1.01  - Impostos.txt                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gefco                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function EXPORTIMP()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDlg,oGet
Local cFile := Space(200)

Private oGeraTxt,cNomeAtv

arqimp  := SPACE( 35 )
arquivo := "D:\MICROSIGA\SIGAADV\ARQUIVO.MZP"

dbSelectArea("SE1")
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
@ 055,150 BMPBUTTON TYPE 05 ACTION Pergunte("GEFM50",.T.) //pergunte("MTR730",.F.)

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

Private cArqTxt  := "\\geatj1appl1\Protheus8\Protheus_Data\Exportar\Impostos.txt"
Private cArqSai  := "\\geatj1appl1\Protheus8\Protheus_Data\Importar\FaturasAdhoc\Receber\Faturas.gef"
Private nHdl     := fCreate(cArqTxt)
Private cEOL     := "CHR(13)+CHR(10)"
Private cPathori := "\\geatj1appl1\Protheus8\Protheus_Data\Importar\FaturasAdhoc\Receber\"
Private cSinal   := "-"

Private cFornece := Space(8)
Private cNomFor  := Space(40)
Private cCnpjFor := Space(14)		   
Private cCodCusto,cNomCusto

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
Dttrans  := Gravadata(Ddatabase,.F.,8) 
Hrtrans  := Substr(Time(),1,2) + Substr(Time(),4,2)
DtPar01  := Gravadata(MV_PAR01,.F.,8) 
DtPar02  := Gravadata(MV_PAR02,.F.,8) 
xUser    := Substr(Alltrim(cUsername),1,10) 
System   := "MICROSIGA"
xBrancos := Space(97)
_FHeader := xIndice + DtPar01 + DtPar02 + Space(896) + cEOL

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

Local nTamLin, cLin, cCpo, nReg, xCfop, cPrefixo, xGfilial , xGnota  

Local cCfop := ""


StartVar()

nReg := 0

V_SF3     := RETSQLNAME("SF3")
V_Se1     := RETSQLNAME("SE1")
V_Sa1     := RETSQLNAME("SA1")
V_SED     := RETSQLNAME("SED")
V_CTT     := RETSQLNAME("CTT")

_cFilial  := ""
nValorFil := 0
nTotalG   := 0
_cFilAnt  := ""   
cTipoReg  := "02"

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

    cTipoReg := "02"                         
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


    DbSelectArea("IMP")
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
xFilRet := Space(40)   
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
xDesc := Space(40)   
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
      Case xUO == "51"
           xDesc := "INFORMATICA"     
      Case xUO == "61"
           xDesc := "FINANCEIRO CORPORATIVO"     
      OtherWise	                 
        xDesc := Space(40)   
   EndCase

Return(xDesc)


Static Function Atividade(cCodAtv,cCodUO)

cNomeAtv := Space(60) 
  xUO := cCodUO
  
   If Empty(xUO) .Or. xUO == ""
      cNomeAtv := Space(60)    
   Endif

   If xUO == "01" .Or. xUO == "02"   
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
     
   If xUO == "21"  
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
  

   If xUO == "11" 
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

Private     cTipoReg := Space(2)
Private     cCliCob  := Space(8)
Private     cCnpjCob := Space(14)
Private     cNomCob  := Space(40)
Private     cCliDest := Space(8)
Private     cCnpjDest:= Space(14)
Private     cNomDest := Space(40)
Private     cFornece := Space(8)
Private     cNomFor  := Space(40)
Private     cCnpjFor := Space(14)
Private     cCodCusto:= Space(10)
Private     cNomCusto:= Space(40)
Private     cCodDiv  := Space(1)
Private     cNomDiv  := Space(20)
Private     cCodUO   := Space(2)
Private     cNomUO   := Space(40)
Private     cCodFil  := Space(3)
Private     cNomFil  := Space(40)
Private     cCodAtv  := Space(3)
Private     cNomAtv  := Space(60)
Private     cCodPolo := Space(1)
Private     cNomPolo := Space(40)
Private     cConta   := Space(20)
Private     cNomConta:= Space(40)
Private     cContaGer:= Space(20)
Private     cNomGeren:= Space(20)
Private     cTipoDoc := Space(3)
Private     cCodFatura := Space(6)
Private     cNumBoleto := Space(12)
Private     cNumDoc  := Space(9)
Private     cDtFatura:= Space(8) 
Private     cDtBoleto:= Space(8)
Private     cDtDoc   := Space(8)
Private     cDtContab:= Space(8)
Private     nValor   := 0
Private     cImposto := Space(20)
Private     cCfop    := Space(5)
Private     cNomCfop := Space(55)
Private     cRefgefco:= Space(20)
Private     cCustoPSA:= Space(20)
Private     cOIPSA   := Space(20)
Private     cTipoDesp:= Space(3)
Private     cNomeAtv := Space(60)
     
Return