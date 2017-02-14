#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
#include "ap5mail.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  GEFINR010    º Autor ³ Marcos Furtado   º Data ³  26/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ STATEMENT OF ACCOUNT                                       º±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GEFINR010()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de Statement, conforme parâmetros.                 "
Local cDesc3         := "."
Local cPict          := ""
Local titulo         := "STATEMENT OF ACCOUNT"
Local nLin           := 80

//          1         2         3         4         5         6
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789                                
//                                                        AMOUNT 
// OUR REF              INVOICE         ISSUE DATE	 FOREIGN EXCHANGE "
Local Cabec1       := "                                                        AMOUNT "
Local Cabec2       := " OUR REF              INVOICE         ISSUE DATE   FOREIGN EXCHANGE "

Local imprime      := .T.
Local aOrd := {}

/*Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
*/

Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "GEFINR010" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 15
Private aReturn    := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "GEFN10__"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GEFINR010" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cEmail     := ""
Private lEnd       := .F.
Private lAbortPrint:= .F.

Private cString := "SE1"

dbSelectArea("SE1")
dbSetOrder(1)

ValidPerg()
pergunte(cPerg,.f.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  13/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local   nOrdem
Local   cQuery  := "" 
Local   nQtd    := 0
Local   cValor  := 0      
Local   lSoma   := .T.
Local   aDados[1][6]

Private cGrupo  := ""                    
Private cDescM  := ""
Private nValor  := 0      
Private nValorR := 0      
Private nValorV := 0      
Private nQtdV   := 0      //Qtd de Vencidos 
Private nQtdAV  := 0      //Qtd a Vencer 
Private nVlrV   := 0      //Qtd de Vencidos a 4 meses
Private nVlrAV  := 0      //Qtd de Vencidos a mais 4 meses 
Private nMes    := 0      //Controla o mês de referência
Private nAno    := 0      //Controla o ano de referência
Private nQtdMes := 0      //Qtd emitidos no mes 
Private nSaldo	:= 0
Private dDataRef := dDataBase

aDados[1][1]  := 0 //1   a 30
aDados[1][2]  := 0 //31  a 60   
aDados[1][3]  := 0 //61  a 90
aDados[1][4]  := 0 //91  a 180
aDados[1][5]  := 0 //180 a 365
aDados[1][6]  := 0 // > 365  

cQuery  = "SELECT DISTINCT A1_XGRPCLI,E1_MOEDA,A1_COD, A1_LOJA, A1_NOME, A1_EMAIL, A1_NREDUZ, E1_NUM, E1_PREFIXO,E1_TIPO, E1_EMIS1, "
cQuery += "  E1_REFGEF, E1_INVOICE, E1_VALOR, E1_SALDO, E1_TXMOEDA, E1_VLCRUZ, E1_EMISSAO, E1_VENCREA, E1_CLIENTE, E1_LOJA , E1_DTVARIA"
cQuery += " FROM " + RetSqlName("SA1") + " SA1, "
cQuery += " " + RetSqlName("SE1") + " SE1  "
cQuery += " WHERE SA1.D_E_L_E_T_ <> '*' AND  "
cQuery += " SE1.D_E_L_E_T_ <> '*' AND  "                    
cQuery += " E1_CLIENTE = A1_COD  AND  "
cQuery += " E1_LOJA = A1_LOJA AND  "                  

/*cQuery += " ((E1_CLIENTE = A1_COD  AND E1_LOJA = A1_LOJA) OR "
cQuery += "  (E1_CLIENTE+E1_LOJA = A1_XGRPCLI)) AND  "*/
                                                        
cQuery += " E1_MOEDA = " + AllTrim(STR(MV_PAR07)) + " AND  "
cQuery += " E1_INVOICE <> ' ' AND  "
cQuery += " E1_SALDO <> 0 AND  "
cQuery += " E1_FILIAL >= '" + MV_PAR03 + "' AND E1_FILIAL <= '" + MV_PAR04 + "' AND "
cQuery += " E1_EMISSAO >= '" + DTOS(MV_PAR01) + "' AND E1_EMISSAO <= '" + DTOS(MV_PAR02) +"' AND "

If MV_PAR16 = 2 //Sintetico                                                                       
	cQuery += " E1_VENCREA < '" + DTOS(dDataBase) + "' AND "
EndIF

/*cQuery += " ((E1_CLIENTE >= '" + MV_PAR08 + "' AND E1_CLIENTE <= '" + MV_PAR10 + "' AND "
  cQuery += "   E1_LOJA >= '" + MV_PAR09 + "' AND E1_LOJA <= '" + MV_PAR11 + "' ) OR "
  cQuery += "  (A1_XGRPCLI >= '" + MV_PAR08 + MV_PAR09 + "' AND A1_XGRPCLI <= '" + MV_PAR10 + MV_PAR11 + "' )) "*/

cQuery += "  A1_XGRPCLI >= '" + MV_PAR08 + MV_PAR09 + "' AND A1_XGRPCLI <= '" + MV_PAR10 + MV_PAR11 + "' "
cQuery += " ORDER BY A1_XGRPCLI, E1_MOEDA, E1_EMISSAO, E1_INVOICE, E1_CLIENTE, E1_LOJA " 
/*iF MV_PAR16 = 2  .And. MV_PAR12 = 1 //Sintetico 
	cQuery += " ORDER BY A1_NREDUZ, A1_XGRPCLI, E1_MOEDA, E1_EMISSAO, E1_INVOICE, E1_CLIENTE, E1_LOJA " 
Else 
	cQuery += " ORDER BY A1_XGRPCLI, E1_MOEDA, E1_EMISSAO, E1_INVOICE, E1_CLIENTE, E1_LOJA " 
EndIF*/
TCQuery cQuery ALIAS "TRB" New     

dbSelectArea("TRB")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())
If MV_PAR07 = 1
	cDescM := "BRL"
ElseIf MV_PAR07 = 2
	cDescM := "USD"
ElseIf MV_PAR07 = 3
	cDescM := "UFIR"
ElseIf MV_PAR07 = 4
	cDescM := "EUR"
ElseIf MV_PAR07 = 5
	cDescM := "" //FRANCO
EndIf    

If MV_PAR12 = 1 //Microsiga
//	nLin := 1
	nLin := 80
	dbGoTop()  
	If MV_PAR16 = 1 //Analitico 
		While !EOF()
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Verifica o cancelamento pelo usuario...                             ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If lAbortPrint
		      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		      Exit
		   Endif
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Impressao do cabecalho do relatorio. . .                            ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		   If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)		      
		      nLin := 8
		   Endif
		   
		   //012345678901234567890123456789012345678901234567890123456789
		   //Codigo Loja     Tipo CNPJ/CPF         Nome do Cliente"
	//		If cGrupo <> TRB->E1_CLIENTE+TRB->E1_LOJA 
			If cGrupo <> AllTrim(A1_XGRPCLI) 		
			   If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			      Cabec(Titulo,cabec1,cabec2,NomeProg,Tamanho,nTipo)
			      nLin := 8
			   Endif			
				If nValor <> 0
					nLin ++ 
					@nLin,35 PSAY "Total: " 
					If nValor >= 0
						@nLin,51 PSAY nValor Picture "@E 9,999,999,999.99"
					Else
					    cValor := Transform(Abs(nValor),"@E 9,999,999,999.99")	   
				   	    @nLin,51 PSAY  Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
					EndIF			
					
					nLin ++ 
					nLin ++ 		
					@nLin,35 PSAY "Total (R$): " 
					If nValor >= 0
						@nLin,51 PSAY nValorR Picture "@E 9,999,999,999.99"
					Else
					    cValor := Transform(Abs(nValorR),"@E 9,999,999,999.99")	   
				   	    @nLin,51 PSAY  Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
					EndIF			
			
					nLin ++ 
					nLin ++ 					
							
					@nLin,35 PSAY "OVERDUE: " 
					If nValor >= 0
						@nLin,51 PSAY nValorV Picture "@E 9,999,999,999.99"
					Else
					    cValor := Transform(Abs(nValorV),"@E 9,999,999,999.99")	   
				   	    @nLin,51 PSAY  Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
					EndIF			
					nLin ++ 							
				EndIF	
/*				
		        Cabec(Titulo,Cabec1,".",NomeProg,Tamanho,nTipo)
//		        Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)		        
		        nLin := 6
*/		        
			   If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			      Cabec(Titulo,cabec1,cabec2,NomeProg,Tamanho,nTipo)
			      nLin := 8
			   Endif		        
			
	//			cGrupo := TRB->E1_CLIENTE+TRB->E1_LOJA
				cGrupo := AllTrim(A1_XGRPCLI)
				DbSelectArea("SA1")
				dbSetOrder(1)
				If !DbSeek(xFilial("SA1")+cGrupo)
					MsgInfo("O cadastro de Grupo do Cliente : "+ TRB->E1_CLIENTE+"-"+TRB->E1_LOJA + " ,deve ser informado do cadastro!")			
				    @nLin,00 PSAY "AGENT:     " + TRB->A1_NREDUZ
				Else 
				    @nLin,00 PSAY "AGENT:     " + SA1->A1_NREDUZ			
				EndIF
				DbSelectArea("TRB")
			    @nLin,60 PSAY "CORRENCY:  " + cDescM
			    nLin ++	   	    
			    @nLin,00 PSAY "REFERENCE: " + DTOC(dDataBase)
			    nLin ++	            
			    nLin ++	            	            
			   /* 
			    @nLin,00 PSAY Replicate("_",limite)	    
			    nLin ++	            	    	    
			    @nLin,00 PSAY Cabec1
			    nLin ++	            	    	    
			    @nLin,00 PSAY Cabec2
			    nLin ++	      
			    @nLin,00 PSAY Replicate("_",limite)	
			  */      
			    nLin ++	            	    	    
				nValor  := 0
				nValorR := 0			
				nValorV := 0			
		    EndIF	
		
		//          1         2         3         4         5         6
		//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789                                
		//                                                        AMOUNT 
		// OUR REF              INVOICE         ISSUE DATE	 FOREIGN EXCHANGE "
		   
		   @nLin,01 PSAY TRB->E1_REFGEF
		   @nLin,22 PSAY TRB->E1_INVOICE
		   @nLin,38 PSAY DTOC(STOD(TRB->E1_EMISSAO))

		   If TRB->E1_TIPO <> "NCC"
	//	   	   @nLin,51 PSAY IIF(TRB->E1_TIPO == "NCC", TRB->E1_VALOR * (-1),TRB->E1_VALOR) Picture "@E 9,999,999,999.99"
	//	   	   @nLin,51 PSAY TRB->E1_VALOR Picture "@E 9,999,999,999.99"	   	   
		   	   @nLin,51 PSAY TRB->E1_SALDO Picture "@E 9,999,999,999.99"	   	   	   	   
		   Else 
	//	       cValor := Transform(TRB->E1_VALOR,"@E 9,999,999,999.99")	   
		       cValor := Transform(TRB->E1_SALDO,"@E 9,999,999,999.99")	   	       
		   	   @nLin,51 PSAY  Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
		   	 	   
		   EndIf
				   
		   If TRB->E1_TIPO == "NCC"
	//	   	   nValor := nValor - TRB->E1_VALOR	   
		   	   nValor := nValor - TRB->E1_SALDO	   	   	   
	
		   	   If Empty(TRB->E1_DTVARIA)
		   	   	   nValorR := nValorR - (TRB->E1_SALDO * TRB->E1_TXMOEDA)
		   	   ELSE 
		   	   	   DbSelectArea("SM2")	
		   	   	   DbSetOrder(1)
		   	   	   If DbSeek(Stod(TRB->E1_DTVARIA))
		   	   	   	   If TRB->E1_MOEDA = 2	
			   	   	   	   nValorR := nValorR - (TRB->E1_SALDO * SM2->M2_MOEDA2)   	   
			   	   	   ElseIf TRB->E1_MOEDA = 4	
			   	   	   	   nValorR := nValorR - (TRB->E1_SALDO * SM2->M2_MOEDA4)   	   			   	   	   
			   	   	   EndIF
		   	   	   EndIf
		   	   EndIf
		   	   If STOD(TRB->E1_VENCREA) < dDataBase
			   	   nValorV  := nValorV  - TRB->E1_SALDO	      	   
			   EndIF
		
		   	   
		   Else
	//		   nValor := nValor + TRB->E1_VALOR
			   nValor := nValor + TRB->E1_SALDO		   
	
		   	   If Empty(TRB->E1_DTVARIA)
		   	   	   nValorR := nValorR + (TRB->E1_SALDO * TRB->E1_TXMOEDA)
		   	   ELSE 
		   	   	   DbSelectArea("SM2")	
		   	   	   DbSetOrder(1)
		   	   	   If DbSeek(Stod(TRB->E1_DTVARIA))
			   	   	   If TRB->E1_MOEDA = 2
			   	   	   	   nValorR := nValorR + (TRB->E1_SALDO * SM2->M2_MOEDA2)   	   
			   	   	   ElseIf TRB->E1_MOEDA = 4	
			   	   	   	   nValorR := nValorR + (TRB->E1_SALDO * SM2->M2_MOEDA4)   	   			   	   	   
			   	   	   EndIF
		   	   	   	   
		   	   	   EndIf
		   	   EndIf
		   	   If STOD(TRB->E1_VENCREA) < dDataBase
			   	   nValorV  := nValorV  + TRB->E1_SALDO	      	   
                   nQtdV++ //Qtd de Vencidos 
               Else
				   nQtdAV++ //Qtd a Vencer 
			   EndIF
                                                   
		   	   If Month(STOD(TRB->E1_EMIS1)) = Month(dDataBase)
				   nQtdMes++		//Qtd emitidos no mes 				   	   
		   	   EndIf
			   
		   EndIF
		   
		   nQtd ++
		   nLin ++ 
		   dbSelectArea("TRB")
		   dbSkip() // Avanca o ponteiro do registro no arquivo
		   IncRegua()
		EndDo      
		
		If nValor <> 0
		          
			nLin ++ 
			@nLin,35 PSAY "Total: " 
			If nValor >= 0
				@nLin,51 PSAY nValor Picture "@E 9,999,999,999.99"
			Else
			    cValor := Transform(Abs(nValor),"@E 9,999,999,999.99")	   
		   	    @nLin,51 PSAY  Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			
			
			nLin ++ 
			nLin ++ 		
			@nLin,35 PSAY "Total (R$): " 
			If nValor >= 0
				@nLin,51 PSAY nValorR Picture "@E 9,999,999,999.99"
			Else
			    cValor := Transform(Abs(nValorR),"@E 9,999,999,999.99")	   
		   	    @nLin,51 PSAY  Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			
	
			nLin ++ 
			nLin ++ 
					
			@nLin,35 PSAY "OVERDUE: " 
			If nValor >= 0
				@nLin,51 PSAY nValorV Picture "@E 9,999,999,999.99"
			Else
			    cValor := Transform(Abs(nValorV),"@E 9,999,999,999.99")	   
		   	    @nLin,51 PSAY  Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			
		EndIF	
		//Impressão no modo Analítico
	ElseIf MV_PAR16 = 2 //Sintetico
		//Início da Impressão no modo Sintético	
		cGrupo := AllTrim(TRB->A1_XGRPCLI)		
//		                           1         2         3         4         5         6         7         8         9        10        11        12
//                       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789 		
		Cabec1x     := "Grupo     Nome Fantasia         Moeda  Overdue         Overdue (R$)   N>4 mois  Vlr > 4 mois   N<4 mois    Vlr < 4 mois "
		Cabec2x     := ""
		nLin 		:= 80              
		nTipo 	  	:= If(aReturn[4]==1,15,18)	
		nomeprog1 	:= "GEFINR010" // Coloque aqui o nome do programa para impressao no cabecalho		
		
		//Cálculo da quantidade de meses a considerar no relatório:
		nMes := Month(dDataBase) - 3
		nAno := Year(dDataBase)
		If nMes <= 0	 
			nMes += 12	
			nAno -= 1
		EndIF         
		
		dDataRef := STOD(STRZERO(nAno,4)+STRZERO(nMes,2)+"01") 
		// Fim do Cálculo
		
		While !EOF()
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Verifica o cancelamento pelo usuario...                             ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If lAbortPrint
		      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		      Exit
		   Endif
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Impressao do cabecalho do relatorio. . .                            ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		   
		   If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1x,Cabec2x,"","M",nTipo)
//		      Cabec(Titulo,"..","..",NomeProg,Tamanho,nTipo)
		      nLin := 8
		   Endif
		   //012345678901234567890123456789012345678901234567890123456789
		   //Codigo Loja     Tipo CNPJ/CPF         Nome do Cliente"
	//		If cGrupo <> TRB->E1_CLIENTE+TRB->E1_LOJA 
           If cGrupo <> AllTrim(A1_XGRPCLI) 		
		        If nLin > 60 
  		        	Cabec(Titulo,Cabec1x,Cabec2x,NomeProg,Tamanho,nTipo)
			        nLin := 6
				EndIF
							
	//			cGrupo := TRB->E1_CLIENTE+TRB->E1_LOJA

			    @nLin,00 PSAY AllTrim(cGrupo)
			    
				DbSelectArea("SA1")
				dbSetOrder(1)
				If !DbSeek(xFilial("SA1")+cGrupo)
					MsgInfo("O cadastro de Grupo do Cliente : "+ TRB->E1_CLIENTE+"-"+TRB->E1_LOJA + " ,deve ser informado do cadastro!")			
				    @nLin,10 PSAY TRB->A1_NREDUZ
				Else 
				    @nLin,10 PSAY SA1->A1_NREDUZ			
				EndIF
				DbSelectArea("TRB")
			    @nLin,35 PSAY cDescM
		   
				If nValor >= 0
					@nLin,40 PSAY nValor Picture "@E 99,999,999.99"
				Else
				    cValor := Transform(Abs(nValor),"@E 99,999,999.99")	   
			   	    @nLin,40 PSAY  Space(13 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
				EndIF			
					
				If nValorR >= 0
					@nLin,55 PSAY nValorR Picture "@E 99,999,999.99"
				Else
				    cValor := Transform(Abs(nValorR),"@E 99,999,999.99")	   
			   	    @nLin,55 PSAY  Space(13 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
				EndIF			
			
				@nLin,70  PSAY nQtdV   Picture "@E 999,999"
				
				If nVlrV >= 0
					@nLin,80 PSAY nVlrV Picture "@E 99,999,999.99"
				Else
				    cValor := Transform(Abs(nVlrV),"@E 99,999,999.99")	   
			   	    @nLin,80 PSAY  Space(13 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
				EndIF			

				@nLin,95 PSAY nQtdAV  Picture "@E 999,999"
				
				If nVlrAV >= 0
					@nLin,105 PSAY nVlrAV Picture "@E 99,999,999.99"
				Else
				    cValor := Transform(Abs(nVlrAV),"@E 99,999,999.99")	   
			   	    @nLin,105 PSAY  Space(13 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
				EndIF			
				
/*				If nValorV >= 0
					@nLin,70 PSAY nValorV Picture "@E 99,999,999.99"
				Else
				    cValor := Transform(Abs(nValorV),"@E 99,999,999.99")	   
			   	    @nLin,70 PSAY  Space(13 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
				EndIF			*/


//				@nLin,120 PSAY nQtdMes Picture "@E 999,999"							
				
			    nLin ++	            	    	    
				nValor  := 0
				nValorR := 0			
				nValorV := 0			
				
				nQtdV   := 0		
				nQtdAV  := 0		
				nVlrV   := 0			
				nVlrAV  := 0			
			
				nQtdMes := 0		
				
				cGrupo := AllTrim(A1_XGRPCLI)				
		    EndIF	
		
		//          1         2         3         4         5         6
		//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789                                
		//                                                        AMOUNT 
		// OUR REF              INVOICE         ISSUE DATE	 FOREIGN EXCHANGE "
		   
/*		   @nLin,01 PSAY TRB->E1_REFGEF
		   @nLin,22 PSAY TRB->E1_INVOICE
		   @nLin,38 PSAY DTOC(STOD(TRB->E1_EMISSAO))
		   If TRB->E1_TIPO <> "NCC"
	//	   	   @nLin,51 PSAY IIF(TRB->E1_TIPO == "NCC", TRB->E1_VALOR * (-1),TRB->E1_VALOR) Picture "@E 9,999,999,999.99"
	//	   	   @nLin,51 PSAY TRB->E1_VALOR Picture "@E 9,999,999,999.99"	   	   
		   	   @nLin,51 PSAY TRB->E1_SALDO Picture "@E 9,999,999,999.99"	   	   	   	   
		   Else 
	//	       cValor := Transform(TRB->E1_VALOR,"@E 9,999,999,999.99")	   
		       cValor := Transform(TRB->E1_SALDO,"@E 9,999,999,999.99")	   	       
		   	   @nLin,51 PSAY  Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
		   	 	   
		   EndIf
				   */

			
		   If TRB->E1_TIPO == "NCC"
	//	   	   nValor := nValor - TRB->E1_VALOR	   
		   	   nValor := nValor - TRB->E1_SALDO	   	   	   
	
		   	   If Empty(TRB->E1_DTVARIA)
		   	   	   nValorR := nValorR - (TRB->E1_SALDO * TRB->E1_TXMOEDA)
		   	   ELSE 
		   	   	   DbSelectArea("SM2")	
		   	   	   DbSetOrder(1)
		   	   	   If DbSeek(Stod(TRB->E1_DTVARIA))
		   	   	   	   If TRB->E1_MOEDA = 2	
			   	   	   	   nValorR := nValorR - (TRB->E1_SALDO * SM2->M2_MOEDA2)   	   
			   	   	   ElseIf TRB->E1_MOEDA = 4	
			   	   	   	   nValorR := nValorR - (TRB->E1_SALDO * SM2->M2_MOEDA4)   	   			   	   	   
			   	   	   EndIF
		   	   	   EndIf
		   	   EndIf

/*		   	   If STOD(TRB->E1_VENCREA) < dDataBase
			   	   nValorV  := nValorV  - TRB->E1_SALDO	      	   
                   nQtdV++ //Qtd de vencidos ATÉ 4 MESES.
               Else
				   nQtdAV++ //Qtd de vencidos há mais de 4 meses. 
			   EndIF*/

		   	   If STOD(TRB->E1_VENCREA) >= dDataRef .And. STOD(TRB->E1_VENCREA) < dDataBase

			   	   nValorV  := nValorV  - TRB->E1_SALDO	      	   
				   nVlrV   -=   TRB->E1_SALDO	      	   
                   nQtdV++ //Qtd de vencidos ATÉ 4 MESES.
               Else                                        
				   nVlrAV   -=   TRB->E1_SALDO	      	                  
				   nQtdAV++ //Qtd de vencidos há mais de 4 meses. 
			   EndIF

                                                   
		   	   If Month(STOD(TRB->E1_EMIS1)) = Month(dDataBase)
				   nQtdMes++		//Qtd emitidos no mes 				   	   
		   	   EndIf
		
		   	   
		   Else
	//		   nValor := nValor + TRB->E1_VALOR
			   nValor := nValor + TRB->E1_SALDO		   
	
		   	   If Empty(TRB->E1_DTVARIA)
		   	   	   nValorR := nValorR + (TRB->E1_SALDO * TRB->E1_TXMOEDA)
		   	   ELSE 
		   	   	   DbSelectArea("SM2")	
		   	   	   DbSetOrder(1)
		   	   	   If DbSeek(Stod(TRB->E1_DTVARIA))
			   	   	   If TRB->E1_MOEDA = 2
			   	   	   	   nValorR := nValorR + (TRB->E1_SALDO * SM2->M2_MOEDA2)   	   
			   	   	   ElseIf TRB->E1_MOEDA = 4	
			   	   	   	   nValorR := nValorR + (TRB->E1_SALDO * SM2->M2_MOEDA4)   	   			   	   	   
			   	   	   EndIF
		   	   	   EndIf
		   	   EndIf

/*		   	   If STOD(TRB->E1_VENCREA) < dDataBase
			   	   nValorV  := nValorV  + TRB->E1_SALDO	      	   
                   nQtdV++ //Qtd de Vencidos 
               Else
				   nQtdAV++ //Qtd a Vencer 
			   EndIF*/
			   
		   	   If STOD(TRB->E1_VENCREA) >= dDataRef .And. STOD(TRB->E1_VENCREA) < dDataBase
			   	   nValorV  := nValorV  + TRB->E1_SALDO	      	   
				   nVlrV   +=   TRB->E1_SALDO	      	   
                   nQtdV++ //Qtd de vencidos ATÉ 4 MESES.
               Else                                        
				   nVlrAV   +=   TRB->E1_SALDO	      	                  
				   nQtdAV++ //Qtd de vencidos há mais de 4 meses. 
			   EndIF
			   
                                                   
		   	   If Month(STOD(TRB->E1_EMIS1)) = Month(dDataBase)
				   nQtdMes++		//Qtd emitidos no mes 				   	   
		   	   EndIf
		
			   
		   EndIF
		   
		   nQtd ++
		   dbSelectArea("TRB")
		   dbSkip() // Avanca o ponteiro do registro no arquivo
		   IncRegua()
		EndDo      
		
		If nValor <> 0
		          
	      If nLin > 60 
	        	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		        nLin := 6
			EndIF
						
//			cGrupo := TRB->E1_CLIENTE+TRB->E1_LOJA
		    @nLin,00 PSAY AllTrim(cGrupo)
		    
			DbSelectArea("SA1")
			dbSetOrder(1)
			If !DbSeek(xFilial("SA1")+cGrupo)
				MsgInfo("O cadastro de Grupo do Cliente : "+ TRB->E1_CLIENTE+"-"+TRB->E1_LOJA + " ,deve ser informado do cadastro!")			
			    @nLin,10 PSAY TRB->A1_NREDUZ
			Else 
			    @nLin,10 PSAY SA1->A1_NREDUZ			
			EndIF
			DbSelectArea("TRB")
		    @nLin,35 PSAY cDescM
			If nValor >= 0
				@nLin,40 PSAY nValor Picture "@E 99,999,999.99"
			Else
			    cValor := Transform(Abs(nValor),"@E 99,999,999.99")	   
		   	    @nLin,40 PSAY  Space(13 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			
				
			If nValorR >= 0
				@nLin,55 PSAY nValorR Picture "@E 99,999,999.99"
			Else
			    cValor := Transform(Abs(nValorR),"@E 99,999,999.99")	   
		   	    @nLin,55 PSAY  Space(13 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			
		
			@nLin,70  PSAY nQtdV   Picture "@E 999,999"
				
			If nVlrV >= 0
				@nLin,80 PSAY nVlrV Picture "@E 99,999,999.99"
			Else
			    cValor := Transform(Abs(nVlrV),"@E 99,999,999.99")	   
		   	    @nLin,80 PSAY  Space(13 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			

			@nLin,95 PSAY nQtdAV  Picture "@E 999,999"
			
			If nVlrAV >= 0
				@nLin,105 PSAY nVlrAV Picture "@E 99,999,999.99"
			Else
			    cValor := Transform(Abs(nVlrAV),"@E 99,999,999.99")	   
		   	    @nLin,105 PSAY  Space(13 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			
				
/*				If nValorV >= 0
					@nLin,70 PSAY nValorV Picture "@E 99,999,999.99"
				Else
				    cValor := Transform(Abs(nValorV),"@E 99,999,999.99")	   
			   	    @nLin,70 PSAY  Space(13 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
				EndIF			*/
//			@nLin,120 PSAY nQtdMes Picture "@E 999,999"							
					
		EndIF	
    
		//Fim da Impressão do modo Sintético
	ElseIf MV_PAR16 = 3 //Sintético por age
		//Início da Impressão no modo Sintético	por age
		limite           := 220		
		tamanho          := "G"		
//	    SetDefault(aReturn,cString)		
		
		cGrupo := AllTrim(TRB->A1_XGRPCLI)		
		
		Cabec1  := "Grupo     Nome Fantasia         Moeda  Total           Total (R$)           Overdue             1 a 30         31 a 60        61 a 90       91 a 180      181 a 365          > 365"
		Cabec2  := ""
		nLin := 80
		While !EOF()
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Verifica o cancelamento pelo usuario...                             ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If lAbortPrint
		      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		      Exit
		   Endif
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Impressao do cabecalho do relatorio. . .                            ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
		   Endif
		   //012345678901234567890123456789012345678901234567890123456789
		   //Codigo Loja     Tipo CNPJ/CPF         Nome do Cliente"
	//		If cGrupo <> TRB->E1_CLIENTE+TRB->E1_LOJA 
           If cGrupo <> AllTrim(A1_XGRPCLI) 		
		        If nLin > 60 
	   	        	 Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			        nLin := 6
				EndIF
							
	//			cGrupo := TRB->E1_CLIENTE+TRB->E1_LOJA

			    @nLin,00 PSAY AllTrim(cGrupo)
			    
				DbSelectArea("SA1")
				dbSetOrder(1)
				If !DbSeek(xFilial("SA1")+cGrupo)
					MsgInfo("O cadastro de Grupo do Cliente : "+ TRB->E1_CLIENTE+"-"+TRB->E1_LOJA + " ,deve ser informado do cadastro!")			
				    @nLin,10 PSAY TRB->A1_NREDUZ
				Else 
				    @nLin,10 PSAY SA1->A1_NREDUZ			
				EndIF
				DbSelectArea("TRB")
			    @nLin,35 PSAY cDescM
		   
				If nValor >= 0
					@nLin,40 PSAY nValor Picture "@E 99,999,999.99"
				Else
				    cValor := Transform(Abs(nValor),"@E 99,999,999.99")	   
			   	    @nLin,40 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
				EndIF			
					
				If nValorR >= 0
					@nLin,55 PSAY nValorR Picture "@E 99,999,999.99"
				Else
				    cValor := Transform(Abs(nValorR),"@E 99,999,999.99")	   
			   	    @nLin,55 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
				EndIF			
			
				If nValorV >= 0
					@nLin,70 PSAY nValorV Picture "@E 99,999,999.99"
				Else
				    cValor := Transform(Abs(nValorV),"@E 99,999,999.99")	   
			   	    @nLin,70 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
				EndIF			


				If 	aDados[1][1] >= 0
					@nLin,90 PSAY 	aDados[1][1] Picture "@E 99,999,999.99"
				Else
				    cValor := Transform(Abs(aDados[1][1]),"@E 99,999,999.99")	   
			   	    @nLin,90 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
				EndIF			

				If 	aDados[1][2] >= 0
					@nLin,105 PSAY 	aDados[1][2] Picture "@E 99,999,999.99"
				Else
				    cValor := Transform(Abs(aDados[1][2]),"@E 99,999,999.99")	   
			   	    @nLin,105 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
				EndIF			

				If 	aDados[1][3] >= 0
					@nLin,120 PSAY 	aDados[1][3] Picture "@E 99,999,999.99"
				Else
				    cValor := Transform(Abs(aDados[1][3]),"@E 99,999,999.99")	   
			   	    @nLin,120 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
				EndIF			

				If 	aDados[1][4] >= 0
					@nLin,135 PSAY 	aDados[1][4] Picture "@E 99,999,999.99"
				Else
				    cValor := Transform(Abs(aDados[1][4]),"@E 99,999,999.99")	   
			   	    @nLin,135 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
				EndIF			

				If 	aDados[1][5] >= 0
					@nLin,150 PSAY 	aDados[1][5] Picture "@E 99,999,999.99"
				Else
				    cValor := Transform(Abs(aDados[1][5]),"@E 99,999,999.99")	   
			   	    @nLin,150 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
				EndIF			

				If 	aDados[1][6] >= 0
					@nLin,165 PSAY 	aDados[1][6] Picture "@E 99,999,999.99"
				Else
				    cValor := Transform(Abs(aDados[1][6]),"@E 99,999,999.99")	   
			   	    @nLin,165 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
				EndIF			

				aDados[1][1]  := 0 //1   a 30
				aDados[1][2]  := 0 //31  a 60   
				aDados[1][3]  := 0 //61  a 90
				aDados[1][4]  := 0 //91  a 180
				aDados[1][5]  := 0 //180 a 365
				aDados[1][6]  := 0 // > 365  
				

/*				@nLin,90  PSAY nQtdV   Picture "@E 999,999"
				@nLin,105 PSAY nQtdAV  Picture "@E 999,999"
				@nLin,120 PSAY nQtdMes Picture "@E 999,999"							*/
				
			    nLin ++	            	    	    
				nValor  := 0
				nValorR := 0			
				nValorV := 0			
				
				nQtdV   := 0		
				nQtdAV  := 0		
				nQtdMes := 0		
				
				cGrupo := AllTrim(A1_XGRPCLI)				
		    EndIF	
		
		//          1         2         3         4         5         6
		//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789                                
		//                                                        AMOUNT 
		// OUR REF              INVOICE         ISSUE DATE	 FOREIGN EXCHANGE "
		   
/*		   @nLin,01 PSAY TRB->E1_REFGEF
		   @nLin,22 PSAY TRB->E1_INVOICE
		   @nLin,38 PSAY DTOC(STOD(TRB->E1_EMISSAO))
		   If TRB->E1_TIPO <> "NCC"
	//	   	   @nLin,51 PSAY IIF(TRB->E1_TIPO == "NCC", TRB->E1_VALOR * (-1),TRB->E1_VALOR) Picture "@E 9,999,999,999.99"
	//	   	   @nLin,51 PSAY TRB->E1_VALOR Picture "@E 9,999,999,999.99"	   	   
		   	   @nLin,51 PSAY TRB->E1_SALDO Picture "@E 9,999,999,999.99"	   	   	   	   
		   Else 
	//	       cValor := Transform(TRB->E1_VALOR,"@E 9,999,999,999.99")	   
		       cValor := Transform(TRB->E1_SALDO,"@E 9,999,999,999.99")	   	       
		   	   @nLin,51 PSAY  Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
		   	 	   
		   EndIf
				   */
		   If TRB->E1_TIPO == "NCC"
			   lSoma := .F.
	//	   	   nValor := nValor - TRB->E1_VALOR	   
		   	   nValor := nValor - TRB->E1_SALDO	   	   	   
	
		   	   If Empty(TRB->E1_DTVARIA)
		   	   	   nValorR := nValorR - (TRB->E1_SALDO * TRB->E1_TXMOEDA)
		   	   	   nSaldo := (TRB->E1_SALDO * TRB->E1_TXMOEDA)		   	   	   
					// Incluido por Marcelo Aguiar Pimentel 07/02/07
					// Para atender a necessidade da Rosana de Trazer o Overdue em Reais
			   	   If STOD(TRB->E1_VENCREA) < dDataBase
				   	   nValorV  := nValorV  - (TRB->E1_SALDO * TRB->E1_TXMOEDA)
	                   nQtdV++ //Qtd de Vencidos 
	               Else
					   nQtdAV++ //Qtd a Vencer 
				   EndIF
		   	   ELSE 
		   	   	   DbSelectArea("SM2")	
		   	   	   DbSetOrder(1)
		   	   	   If DbSeek(Stod(TRB->E1_DTVARIA))
		   	   	   	   If TRB->E1_MOEDA = 2	
			   	   	   	   nValorR := nValorR - (TRB->E1_SALDO * SM2->M2_MOEDA2)   	   
				   	   	   nSaldo := (TRB->E1_SALDO * SM2->M2_MOEDA2)		   	   	   
							// Incluido por Marcelo Aguiar Pimentel 07/02/07
							// Para atender a necessidade da Rosana de Trazer o Overdue em Reais
					   	   If STOD(TRB->E1_VENCREA) < dDataBase
						   	   nValorV  := nValorV  - (TRB->E1_SALDO * SM2->M2_MOEDA2)
			                   nQtdV++ //Qtd de Vencidos 
			               Else
							   nQtdAV++ //Qtd a Vencer 
						   EndIF
			   	   	   ElseIf TRB->E1_MOEDA = 4	
			   	   	   	   nValorR := nValorR - (TRB->E1_SALDO * SM2->M2_MOEDA4)   	   			   	   	   
				   	   	   nSaldo := (TRB->E1_SALDO * SM2->M2_MOEDA4)		   	   	   
							// Incluido por Marcelo Aguiar Pimentel 07/02/07
							// Para atender a necessidade da Rosana de Trazer o Overdue em Reais
					   	   If STOD(TRB->E1_VENCREA) < dDataBase
						   	   nValorV  := nValorV  - (TRB->E1_SALDO * SM2->M2_MOEDA4)
			                   nQtdV++ //Qtd de Vencidos 
			               Else
							   nQtdAV++ //Qtd a Vencer 
						   EndIF
			   	   	   EndIF
		   	   	   EndIf
		   	   EndIf
			// Comentado por Marcelo Aguiar Pimentel 07/02/07 e inserido no bloco de If acima
			// Para atender a necessidade da Rosana de Trazer o Overdue em Reais
/*
		   	   If STOD(TRB->E1_VENCREA) < dDataBase
			   	   nValorV  := nValorV  - TRB->E1_SALDO	      	   
                   nQtdV++ //Qtd de Vencidos 
               Else
				   nQtdAV++ //Qtd a Vencer 
			   EndIF
*/                                                   
		   	   If Month(STOD(TRB->E1_EMIS1)) = Month(dDataBase)
				   nQtdMes++		//Qtd emitidos no mes 				   	   
		   	   EndIf
		
		   	   
		   Else
			   lSoma := .T.		   
	//		   nValor := nValor + TRB->E1_VALOR
			   nValor := nValor + TRB->E1_SALDO		   
	
		   	   If Empty(TRB->E1_DTVARIA)
		   	   	   nValorR := nValorR + (TRB->E1_SALDO * TRB->E1_TXMOEDA)
		   	   	   nSaldo := (TRB->E1_SALDO * TRB->E1_TXMOEDA)		   	   	   
					// Incluido por Marcelo Aguiar Pimentel 07/02/07
					// Para atender a necessidade da Rosana de Trazer o Overdue em Reais
			   	   If STOD(TRB->E1_VENCREA) < dDataBase
				   	   nValorV  := nValorV  + (TRB->E1_SALDO * TRB->E1_TXMOEDA)
	                   nQtdV++ //Qtd de Vencidos 
	               Else
					   nQtdAV++ //Qtd a Vencer 
				   EndIF
		   	   ELSE 
		   	   	   DbSelectArea("SM2")	
		   	   	   DbSetOrder(1)
		   	   	   If DbSeek(Stod(TRB->E1_DTVARIA))
			   	   	   If TRB->E1_MOEDA = 2
			   	   	   	   nValorR := nValorR + (TRB->E1_SALDO * SM2->M2_MOEDA2)   	   
			   	   	   	   nSaldo := (TRB->E1_SALDO * SM2->M2_MOEDA2)		   	   	   
							// Incluido por Marcelo Aguiar Pimentel 07/02/07
							// Para atender a necessidade da Rosana de Trazer o Overdue em Reais
					   	   If STOD(TRB->E1_VENCREA) < dDataBase
						   	   nValorV  := nValorV  + (TRB->E1_SALDO * SM2->M2_MOEDA2)
			                   nQtdV++ //Qtd de Vencidos 
			               Else
							   nQtdAV++ //Qtd a Vencer 
						   EndIF
			   	   	   ElseIf TRB->E1_MOEDA = 4	
			   	   	   	   nValorR := nValorR + (TRB->E1_SALDO * SM2->M2_MOEDA4)   	   			   	   	   
			   	   	   	   nSaldo := (TRB->E1_SALDO * SM2->M2_MOEDA4)		   	   	   
							// Incluido por Marcelo Aguiar Pimentel 07/02/07
							// Para atender a necessidade da Rosana de Trazer o Overdue em Reais
					   	   If STOD(TRB->E1_VENCREA) < dDataBase
						   	   nValorV  := nValorV  + (TRB->E1_SALDO * SM2->M2_MOEDA4)
			                   nQtdV++ //Qtd de Vencidos 
			               Else
							   nQtdAV++ //Qtd a Vencer 
						   EndIF
			   	   	   EndIF
		   	   	   EndIf
		   	   EndIf

			// Comentado por Marcelo Aguiar Pimentel 07/02/07 e inserido no bloco de If acima
			// Para atender a necessidade da Rosana de Trazer o Overdue em Reais
/*
		   	   If STOD(TRB->E1_VENCREA) < dDataBase
			   	   nValorV  := nValorV  + TRB->E1_SALDO	      	   
                   nQtdV++ //Qtd de Vencidos 
               Else
				   nQtdAV++ //Qtd a Vencer 
			   EndIF
*/                                                   
		   	   If Month(STOD(TRB->E1_EMIS1)) = Month(dDataBase)
				   nQtdMes++		//Qtd emitidos no mes 				   	   
		   	   EndIf
		
			   
		   EndIF
		   
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula a Quantidade de Dias em Atraso.                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nDiasAtraso := dDataBase - STOD(TRB->E1_VENCREA)
//			nDiasAtraso := dDataBase - dVencRea
  		
			if nDiasAtraso > 0 .And. nDiasAtraso <= 30
				_nCol := 1
			ElseIf nDiasAtraso >= 31 .And. nDiasAtraso <= 60
				_nCol := 2
			ElseIf nDiasAtraso >= 61 .And. nDiasAtraso <= 90
				_nCol := 3
			ElseIf nDiasAtraso >= 91 .And. nDiasAtraso <= 180
				_nCol := 4
			ElseIf nDiasAtraso >= 181 .And. nDiasAtraso <= 365
				_nCol := 5
			ElseIf nDiasAtraso > 365
				_nCol := 6			
			EndIF
		  			
			If lSoma .And. nDiasAtraso > 0
//				aDados[1][_nCol] += TRB->E1_SALDO      	   
				aDados[1][_nCol] += nSaldo				

			ElseIf !lSoma .And. nDiasAtraso > 0
//				aDados[1][_nCol] -= TRB->E1_SALDO
				aDados[1][_nCol] -= nSaldo				
			EndIf
	   
		   nQtd ++
		   dbSelectArea("TRB")
		   dbSkip() // Avanca o ponteiro do registro no arquivo
		   IncRegua()
		EndDo      
		
		If nValor <> 0
		          
	      If nLin > 60 
	        	Cabec(Titulo,Cabec1,Cabec1,NomeProg,Tamanho,nTipo)
		        nLin := 6
			EndIF
						
//			cGrupo := TRB->E1_CLIENTE+TRB->E1_LOJA
		    @nLin,00 PSAY AllTrim(cGrupo)
		    
			DbSelectArea("SA1")
			dbSetOrder(1)
			If !DbSeek(xFilial("SA1")+cGrupo)
				MsgInfo("O cadastro de Grupo do Cliente : "+ TRB->E1_CLIENTE+"-"+TRB->E1_LOJA + " ,deve ser informado do cadastro!")			
			    @nLin,10 PSAY TRB->A1_NREDUZ
			Else 
			    @nLin,10 PSAY SA1->A1_NREDUZ			
			EndIF
			DbSelectArea("TRB")
		    @nLin,35 PSAY cDescM
			If nValor >= 0
				@nLin,40 PSAY nValor Picture "@E 99,999,999.99"
			Else
			    cValor := Transform(Abs(nValor),"@E 99,999,999.99")	   
		   	    @nLin,40 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			
				
			If nValorR >= 0
				@nLin,55 PSAY nValorR Picture "@E 99,999,999.99"
			Else
			    cValor := Transform(Abs(nValorR),"@E 99,999,999.99")	   
		   	    @nLin,55 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			
		
			If nValorV >= 0
				@nLin,70 PSAY nValorV Picture "@E 99,999,999.99"
			Else
			    cValor := Transform(Abs(nValorV),"@E 99,999,999.99")	   
		   	    @nLin,70 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			

			If 	aDados[1][1] >= 0
				@nLin,90 PSAY 	aDados[1][1] Picture "@E 99,999,999.99"
			Else
			    cValor := Transform(Abs(aDados[1][1]),"@E 99,999,999.99")	   
		   	    @nLin,90 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			

			If 	aDados[1][2] >= 0
				@nLin,105 PSAY 	aDados[1][2] Picture "@E 99,999,999.99"
			Else
			    cValor := Transform(Abs(aDados[1][2]),"@E 99,999,999.99")	   
		   	    @nLin,105 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			

			If 	aDados[1][3] >= 0
				@nLin,120 PSAY 	aDados[1][3] Picture "@E 99,999,999.99"
			Else
			    cValor := Transform(Abs(aDados[1][3]),"@E 99,999,999.99")	   
		   	    @nLin,120 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			

			If 	aDados[1][4] >= 0
				@nLin,135 PSAY 	aDados[1][4] Picture "@E 99,999,999.99"
			Else
			    cValor := Transform(Abs(aDados[1][4]),"@E 99,999,999.99")	   
		   	    @nLin,135 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			

			If 	aDados[1][5] >= 0
				@nLin,150 PSAY 	aDados[1][5] Picture "@E 99,999,999.99"
			Else
			    cValor := Transform(Abs(aDados[1][5]),"@E 99,999,999.99")	   
		   	    @nLin,150 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			

			If 	aDados[1][6] >= 0
				@nLin,165 PSAY 	aDados[1][6] Picture "@E 99,999,999.99"
			Else
			    cValor := Transform(Abs(aDados[1][6]),"@E 99,999,999.99")	   
		   	    @nLin,165 PSAY  Space(11 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
			EndIF			
				
		EndIF	
    
		//Fim da Impressão do modo Sintético por age

	EndIF
	dbSelectArea("TRB")
	DbCloseArea()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SET DEVICE TO SCREEN
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Else
	RptWord() // Impressao no Word	
EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção      RptWord    º Autor ³ Marcos Furtado   º Data ³  26/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ STATEMENT OF ACCOUNT                                       º±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RptWord()

Local cTitulo1  := "Selecione o arquivo"
Local cExtens   := "Modelo Word | *.dot"
Local cFileOpen := ""
Local cFileSave := ""
Local cDetalhe  := ""
Local oWord
local cValor   := "" 

/***
 * _________________________________________________________
 * cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)
 * ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
 * <ExpC1> - Expressao de filtro
 * <ExpC2> - Titulo da janela
 * <ExpN1> - Numero de mascara default 1 para *.Exe
 * <ExpC3> - Diretório inicial se necessário
 * <ExpL1> - .F. botão salvar - .T. botão abrir
 * <ExpN2> - Mascara de bits para escolher as opções de visualização do objeto (prconst.ch)
 */
 
// cFileOpen := cGetFile(cExtens,cTitulo1,,,.T.)
// cFileOpen := "D:\relato\Modelo\statement.dot"            

// cFileOpen := cGetFile(cType, (STR0003+Subs(cType,1,7) ),,,,GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_LOCALFLOPPY ) // "Selecione arquivo "                 
cFileOpen := cGetFile(cExtens, cTitulo1,,,,GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_LOCALFLOPPY ) // "Selecione arquivo "                 

OLE_CloseLink( )   
oWord := OLE_CreateLink('TMsOleWord97')		
//oWord := OLE_CreateLink()
OLE_NewFile( oWord, cFileOpen )

dbSelectArea("TRB")
dbGoTop()
If Eof()
   RETURN
End

dbGoTop()
While !EOF()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
   If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
*/   
   //012345678901234567890123456789012345678901234567890123456789
   //Codigo Loja     Tipo CNPJ/CPF         Nome do Cliente"
//	If cGrupo <> TRB->E1_CLIENTE+TRB->E1_LOJA 
	If cGrupo <> AllTrim(A1_XGRPCLI) 			
		If nValor <> 0
		
/*			nLin ++ 
			@nLin,40 PSAY "Total: " 
			@nLin,51 PSAY nValor Picture "@E 9,999,999,999.99"*/    
		    OLE_SetDocumentVar( oWord, 'DETALHE', cDetalhe )               			
			If nValor >= 0
				OLE_SetDocumentVar( oWord, 'TOTAL', Transform(nValor,"@E 9,999,999,999.99") )
			Else
			    cValor := Transform(Abs(nValor),"@E 9,999,999,999.99")	   
		   	    cValor := Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
      			OLE_SetDocumentVar( oWord, 'TOTAL', cValor )		   	    
			EndIF			

			If nValorR >= 0
				OLE_SetDocumentVar( oWord, 'TOTALR', Transform(nValorR,"@E 9,999,999,999.99") )
			Else
			    cValor := Transform(Abs(nValorR),"@E 9,999,999,999.99")	   
		   	    cValor := Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
		      			OLE_SetDocumentVar( oWord, 'TOTALR', cValor )		   	    
			EndIF			
		
			If nValorV >= 0
				OLE_SetDocumentVar( oWord, 'TOTALV', Transform(nValorV,"@E 9,999,999,999.99") )
			Else
			    cValor := Transform(Abs(nValorV),"@E 9,999,999,999.99")	   
		   	    cValor := Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
		      			OLE_SetDocumentVar( oWord, 'TOTALV', cValor )		   	    
			EndIF			
		
	

			OLE_UpDateFields( oWord )			

                                           
			If mv_par13<>3
			   If mv_par13==1
				   OLE_SetProperty( oWord, '208', .F. )
				   OLE_PrintFile( oWord )
				   OLE_CloseLink( oWord )	   
			   Elseif mv_par13 == 2
			      cFileSave := SubStr(cFileOpen,1,At(".",Trim(cFileOpen))-1)
			//      OLE_SaveAsFile( oWord, cFileSave+allTRim(cNreduz)+".doc" )
//			      OLE_SaveAsFile( oWord, "\\geatj1appl1\PROTHEUS8\Protheus_Data\Modelo\Statement" +allTRim(cNreduz)+".doc" )      
			      //OLE_SaveAsFile( oWord, "D:\Relato\Modelo\Statement" +allTRim(cNreduz)+".doc" )      			      
			      OLE_SaveAsFile( oWord, cFileSave +"-"+allTRim(cNreduz)+".doc" )      			      			      
			      OLE_CloseLink( oWord )            
				  If mv_par14==1      			      
				      EnvEmail("\modelo\Statement"+allTRim(cNreduz)+".doc")
			//      EnvEmail(cFileSave+allTRim(cNreduz)+".doc")      
				  EndIF			
			
			   Endif
			
			Endif
//			OLE_CloseLink( )                
			oWord := OLE_CreateLink('TMsOleWord97')		
//			oWord := OLE_CreateLink()
			OLE_NewFile( oWord, cFileOpen )
						
		EndIF	
/*        Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)
        nLin := 6*/
	
//		cGrupo := TRB->E1_CLIENTE+TRB->E1_LOJA
		cGrupo := AllTrim(A1_XGRPCLI)
		DbSelectArea("SA1")
		dbSetOrder(1)
		If !DbSeek(xFilial("SA1")+cGrupo)
			MsgInfo("O cadastro de Grupo do Cliente : "+ TRB->E1_CLIENTE+"-"+TRB->E1_LOJA + " ,deve ser informado do cadastro!")			
			OLE_SetDocumentVar( oWord, 'NOME' , TRB->A1_NREDUZ)			
			cNreduz := TRB->A1_NREDUZ			
		Else 
			OLE_SetDocumentVar( oWord, 'NOME' , SA1->A1_NREDUZ)		
			cNreduz := SA1->A1_NREDUZ			
		EndIF
		DbSelectArea("TRB")
		OLE_SetDocumentVar( oWord, 'MOEDA', cDescM )
		OLE_SetDocumentVar( oWord, 'DATABASE', dDatabase )
		nValor := 0
		nValorR := 0			
		nValorV := 0			
	
		cDetalhe := "" 		
    EndIF	

//          1         2         3         4         5         6
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789                                
//                                                        AMOUNT 
// OUR REF              INVOICE         ISSUE DATE	 FOREIGN EXCHANGE "

//    cValor := Transform(TRB->E1_VALOR,"@E 9,999,999,999.99")	   
    cValor := Transform(TRB->E1_SALDO,"@E 9,999,999,999.99")	       
	If TRB->E1_TIPO == "NCC"
	    cValor := Space(14 - Len(AllTrim(cValor))) + "("+ AllTrim(cValor) + ")"
//   	    @nLin,51 PSAY  Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
	EndIF			
                     
   cDetalhe := cDetalhe + TRB->E1_REFGEF + "      " + TRB->E1_INVOICE + Space(07) + DTOC(STOD(TRB->E1_EMISSAO)) + Space(04) + ;
               cValor + Chr(13)
               
               
//               Transform(IIF(TRB->E1_TIPO == "NCC", TRB->E1_VALOR * (-1),TRB->E1_VALOR),"@E 9,999,999,999.99") + Chr(13)              
              
	cEmail  := TRB->A1_EMAIL
//   OLE_SetDocumentVar( oWord, 'DETALHE', cDetalhe )               

/*   @nLin,01 PSAY TRB->E1_REFGEF
   @nLin,22 PSAY TRB->E1_INVOICE
   @nLin,38 PSAY DTOC(STOD(TRB->E1_EMISSAO))
   @nLin,51 PSAY IIF(TRB->E1_PREFIXO == "NCC", TRB->E1_VALOR * (-1),TRB->E1_VALOR) Picture "@E 9,999,999,999.99"*/

   If TRB->E1_TIPO == "NCC"
// 	   nValor  := nValor  - TRB->E1_VALOR	   
   	   nValor  := nValor  - TRB->E1_SALDO	      	   
   	   If Empty(TRB->E1_DTVARIA)
   	   	   nValorR := nValorR - (TRB->E1_SALDO * TRB->E1_TXMOEDA)
   	   ELSE 
   	   	   DbSelectArea("SM2")	
   	   	   DbSetOrder(1)
   	   	   If DbSeek(Stod(TRB->E1_DTVARIA))
   	   	   
   	   	   	   If TRB->E1_MOEDA = 2	
	   	   	   	   nValorR := nValorR - (TRB->E1_SALDO * SM2->M2_MOEDA2)   	   
	   	   	   ElseIf TRB->E1_MOEDA = 4	
	   	   	   	   nValorR := nValorR - (TRB->E1_SALDO * SM2->M2_MOEDA4)   	   			   	   	   
	   	   	   EndIF
   	   	   
//   	   	   	   nValorR := nValorR - (TRB->E1_SALDO * SM2->M2_MOEDA2)   	   
   	   	   EndIf
   	   EndIf
   	   If STOD(TRB->E1_VENCREA) < dDataBase
	   	   nValorV  := nValorV  - TRB->E1_SALDO	      	   
	   EndIF
	   	   
   Else
//	   nValor  := nValor  + TRB->E1_VALOR
	   nValor  := nValor  + TRB->E1_SALDO	                       
   	   If Empty(TRB->E1_DTVARIA)
   	   	   nValorR := nValorR + (TRB->E1_SALDO * TRB->E1_TXMOEDA)
   	   ELSE                                             
		/*	nValor1  :=  xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,1,;
							if(Empty(E1_DTVARIA),E1_EMISSAO,E1_DTVARIA))*/
   	   	   DbSelectArea("SM2")	
   	   	   DbSetOrder(1)
   	   	   If DbSeek(Stod(TRB->E1_DTVARIA))
//   	   	   	   nValorR := nValorR + (TRB->E1_SALDO * SM2->M2_MOEDA2)   	   
   	   	   	   If TRB->E1_MOEDA = 2	
   		   	   	   nValorR := nValorR + (TRB->E1_SALDO * SM2->M2_MOEDA2)   	   
	   	   	   ElseIf TRB->E1_MOEDA = 4	
	   	   	   	   nValorR := nValorR + (TRB->E1_SALDO * SM2->M2_MOEDA4)   	   			   	   	   
	   	   	   EndIF
   	   	   	   
   	   	   EndIf
   	   EndIf

   	   If STOD(TRB->E1_VENCREA) < dDataBase
	   	   nValorV  := nValorV  + TRB->E1_SALDO	      	   
	   EndIF
 	   
   EndIF
   
   dbSelectArea("TRB")
   dbSkip() // Avanca o ponteiro do registro no arquivo
   IncRegua()
EndDo      

If nValor <> 0
          
/*	nLin ++ 
	@nLin,40 PSAY "Total: " 
	@nLin,51 PSAY nValor Picture "@E 9,999,999,999.99"  */
    OLE_SetDocumentVar( oWord, 'DETALHE', cDetalhe )               	

	If nValor >= 0
		OLE_SetDocumentVar( oWord, 'TOTAL', Transform(nValor,"@E 9,999,999,999.99") )
	Else
	    cValor := Transform(Abs(nValor),"@E 9,999,999,999.99")	   
   	    cValor := Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
      			OLE_SetDocumentVar( oWord, 'TOTAL', cValor )		   	    
	EndIF			
	
	If nValorR >= 0
		OLE_SetDocumentVar( oWord, 'TOTALR', Transform(nValorR,"@E 9,999,999,999.99") )
	Else
	    cValor := Transform(Abs(nValorR),"@E 9,999,999,999.99")	   
   	    cValor := Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
      			OLE_SetDocumentVar( oWord, 'TOTALR', cValor )		   	    
	EndIF			

	If nValorV >= 0
		OLE_SetDocumentVar( oWord, 'TOTALV', Transform(nValorV,"@E 9,999,999,999.99") )
	Else
	    cValor := Transform(Abs(nValorV),"@E 9,999,999,999.99")	   
   	    cValor := Space(15 - Len(AllTrim(cValor))) + "(" + allTrim(cValor) + ")"
      			OLE_SetDocumentVar( oWord, 'TOTALV', cValor )		   	    
	EndIF			
	
    
//	OLE_SetDocumentVar( oWord, 'TOTAL', Transform(nValor,"@E 9,999,999,999.99") )	

EndIF	
	
OLE_UpDateFields( oWord )
                                           
If mv_par13<>3
   If mv_par13==1
	   OLE_SetProperty( oWord, '208', .F. )
	   OLE_PrintFile( oWord )
	   OLE_CloseLink( oWord )	   
   Elseif mv_par13 == 2
      cFileSave := SubStr(cFileOpen,1,At(".",Trim(cFileOpen))-1)
      OLE_SaveAsFile( oWord, cFileSave+allTRim(cNreduz)+".doc" )
//      OLE_SaveAsFile( oWord, "\\geatj1appl1\PROTHEUS8\Protheus_Data\Modelo\Statement" +allTRim(cNreduz)+".doc" )      
//      OLE_SaveAsFile( oWord, "D:\Relato\Modelo\Statement" +allTRim(cNreduz)+".doc" )      			            
      OLE_CloseLink( oWord )            
	  If mv_par14==1      
	      EnvEmail("\modelo\Statement"+allTRim(cNreduz)+".doc")
	  EndIf
//      EnvEmail(cFileSave+allTRim(cNreduz)+".doc")      

   Endif

Endif

//OLE_CloseLink( oWord )
dbSelectArea("TRB")
DbCloseArea()

Return

Static Function EnvEmail(cArquivo)

//Local cMailServer := GetMv("MV_WFSMTP") 
Local cMailServer :=GetMV("MV_RELSERV")
Local cSubject    := "Account Statement" 
Local cBody       := ""                      
Local aFiles      := {} 
Local cToCC       := AllTrim(Mv_Par15)
//carq := "\Statement123.doc"
carq := cArquivo
//carq := "D:\Protheus8\Protheus_Data\modelo\Statement123.doc"

aFiles    := { carq,"C:\temp\statementGEFCO BENELUX.doc" } 
/*cPass     := GetMv("MV_WFPASSW")
cAccount  := GetMv("MV_WFACC")*/

cEmail := Mv_Par15

cEmailOri := "marcos.furtado@gefco.com.br" 
cAccount  := GetMV("MV_RELACNT")
cPass     := GetMV("MV_RELPSW")

cTo       := AllTrim(cEmail) 
alert(cTo)
cSubject  := "Statement Account "  
cBody     := "Seque em anexo!"

/*If Empty(cEmail)
	Alert("Não há email cadastrado para este cliente.")
	Return
EndIf*/     

cErrorMsg := ""

connect smtp server cMailServer account cAccount password cPass RESULT _lOk


If _lOk
//	send mail from "marcos.furtado@gefco.com.br" to cTo BCC cToCC  subject cSubject body cBody attachment aFiles[1]
	send mail from "relato@gefco.com.ar" to cTo subject cSubject body cBody attachment aFiles[1]	
//	send mail from GetMV("MV_RELACNT") to cTo subject cSubject body cBody 
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR _cError
   	Aviso( "Erro no envio do E-Mail", _cError, { "Fechar" }, 2 )   
EndIf

//GET MAIL ERROR cErrorMsg  

DISCONNECT SMTP SERVER  

   
WFSENDMAIL({cEmpAnt,cFilAnt})

Return      

Return


***************************
Static Function ValidPerg()
***************************

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

DbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))

Aadd(aRegs,{cPerg,"01","Data de Emissao de  :","","","mv_ch1","D",008,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data de Emissao Ate :","","","mv_ch2","D",008,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Filial de           :","","","mv_ch3","C",002,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Filial ate          :","","","mv_ch4","C",002,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Invoice de          :","","","mv_ch5","C",015,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Invoice ate         :","","","mv_ch6","C",015,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Moeda:              :","","","mv_ch7","C",001,0,0,"C","","mv_par07","Moeda 1","Moneda 1","Currency 1","","","Moeda 2","Moneda 2","Currency 2","","","Moeda 3","Moneda 3","Currency 3","","","Moeda 4","Moneda 4","Currency 4","","","Moeda 5","Moneda 5","Currency 5","","",""})
Aadd(aRegs,{cPerg,"08","Cliente de          :","","","mv_ch8","C",006,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
Aadd(aRegs,{cPerg,"09","Loja de             :","","","mv_ch9","C",002,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"10","Cliente ate         :","","","mv_cha","C",006,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
Aadd(aRegs,{cPerg,"11","Loja ate            :","","","mv_chb","C",002,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"12","Imprimir            :","","","mv_chc","C",001,0,0,"C","","mv_par12","Microsiga","Microsiga","","","","Word","Word","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"13","Word                :","","","mv_chd","N",001,0,0,"C","","mv_par13","Impressora","Impressora","","","","Salvar","Salvar","","","","Abrir","Abrir","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"14","Envia E-amil - Word?:","","","mv_che","N",001,0,0,"C","","mv_par14","Sim","Si","Yes","","","Nao","Nao","No","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"15","Envia C/C:           ","","","mv_chf","C",040,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"16","Modo de Impressão?  :","","","mv_chg","N",001,0,0,"C","","mv_par16","Analitico","Si","Yes","","","Sintetico","Nao","No","","","Sintetico / Age","Nao","No","","","","","","","","","","","","",""})
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

DbSelectArea(_sAlias)

Return(.T.)
