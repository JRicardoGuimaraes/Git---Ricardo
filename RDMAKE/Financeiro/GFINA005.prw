#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGFINA005  บ Autor ณ AP6 IDE            บ Data ณ  04/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa que cria os titulos a pagar do tipo TX - ISS, das บฑฑ
ฑฑบ          ณ notas e CTRCs que foram importados, mas nใo geraram o tit. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiscal, financeiro                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GFINA005


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private oGeraSE2

Private cString := "SE2"

dbSelectArea("SE2")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
                             
Pergunte("MTR180",.F.)
@ 200,1 TO 380,380 DIALOG oGeraSE2  TITLE OemToAnsi("Geracao de Tํtulos - (TX - ISS)")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar os tํutlos do tipo TX - ISS no contas "
@ 18,018 Say " a pagar para as notas e CTRCs que nใo geraram automaticamente "
@ 26,018 Say " no momento da importacao.                                     "

@ 70,098 BMPBUTTON TYPE 01 ACTION Processa({|| OkGeraSE2() },"Processando...")
@ 70,128 BMPBUTTON TYPE 02 ACTION Close(oGeraSE2)
@ 70,158 BMPBUTTON TYPE 05 ACTION Pergunte("MTR180",.T.)

Activate Dialog oGeraSE2 Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERATXTบ Autor ณ AP5 IDE            บ Data ณ  04/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkGeraSE2()
Local cQuery := ""

cQuery := "SELECT E1_PREFIXO,E1_NUM,E1_EMISSAO, F3_NFISCAL, F3_VALICM, E1_CCONT"
cQuery += " FROM " + RetSqlName("SE1") + " SE2,  " + RetSqlName("SF3") + " SF3 "
cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "'  AND E1_NUM = F3_NFISCAL AND SE2.D_E_L_E_T_ <> '*' AND "
cQuery += " F3_FILIAL = E1_FILIAL AND SF3.D_E_L_E_T_ <> '*' AND F3_TIPO = 'S' AND F3_DTCANC = '' AND "
cQuery += " E1_EMISSAO >= '" + DTOS(MV_PAR01) + "'  AND E1_EMISSAO <= '" + DTOS(MV_PAR02) + "' AND "
cQuery += " F3_ENTRADA >= '" + DTOS(MV_PAR01) + "'  AND F3_ENTRADA <= '" + DTOS(MV_PAR02) + "' AND "
cQuery += " E1_PREFIXO IN ('CTR','CTV','UNI','CTA','UN2','UN1')  "
cQuery += " ORDER BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_TIPO"

TcQuery cQuery Alias "TRA" New 

ProcRegua(RecCount())

DbSelectArea("TRA")
dbGoTop()
While !Eof()
    IncProc()
	DbselectArea("SE2")
	If !(Dbseek(xFilial("SE2")+TRA->E1_PREFIXO+TRA->E1_NUM+" "+"TX "+"MUNIC"))
		Reclock("SE2",.T.)
		SE2->E2_FILIAL  := xFilial("SE2")
		SE2->E2_PREFIXO := Alltrim(TRA->E1_PREFIXO)
		SE2->E2_NUM     := TRA->E1_NUM
		SE2->E2_TIPO    := "TX"
		SE2->E2_FORNECE := "MUNIC"
		SE2->E2_LOJA    := "00"
		SE2->E2_NATUREZ := "ISS"
		SE2->E2_NOMFOR  := "MUNICIPIO"
		SE2->E2_EMISSAO := Ctod(Substr(TRA->E1_EMISSAO,7,2)+"/"+Substr(TRA->E1_EMISSAO,5,2)+"/"+Substr(TRA->E1_EMISSAO,1,4))
		SE2->E2_EMIS1   := Ctod(Substr(TRA->E1_EMISSAO,7,2)+"/"+Substr(TRA->E1_EMISSAO,5,2)+"/"+Substr(TRA->E1_EMISSAO,1,4))
	        
	        // Tratamento do Imposto p/ cada filial (vencto) - Saulo 13/07/05 informado pelo setor fiscal
		
		_MesAtu := IIF(Strzero((Val(Substr(TRA->E1_EMISSAO,5,2))+1),2) == "13","01",Strzero((Val(Substr(TRA->E1_EMISSAO,5,2))+1),2)) // Prox.M๊s
		_AnoAtu := IIF(Substr(TRA->E1_EMISSAO,1,4) == "13","01",Substr(TRA->E1_EMISSAO,1,4)) // Prox.Ano
				
		Do Case
		   Case xFilial() == "01"  
	       		    SE2->E2_VENCTO  := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
	        		SE2->E2_VENCORI := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
			        SE2->E2_VENCREA := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "02"  
	       		    SE2->E2_VENCTO  := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
	        		SE2->E2_VENCORI := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		        	SE2->E2_VENCREA := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "03"
	       		    SE2->E2_VENCTO  := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
	        		SE2->E2_VENCORI := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		        	SE2->E2_VENCREA := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "04"
	       		    SE2->E2_VENCTO  := DataValida(Ctod("09/"+_MesAtu+"/"+_AnoAtu)) 
	        		SE2->E2_VENCORI := DataValida(Ctod("09/"+_MesAtu+"/"+_AnoAtu)) 
			        SE2->E2_VENCREA := DataValida(Ctod("09/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "05"
	       		    SE2->E2_VENCTO  := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		       		SE2->E2_VENCORI := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
			        SE2->E2_VENCREA := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "06"
	       		    SE2->E2_VENCTO  := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
	        		SE2->E2_VENCORI := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
			        SE2->E2_VENCREA := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "07"
	       		    SE2->E2_VENCTO  := DataValida(Ctod("20/"+_MesAtu+"/"+_AnoAtu)) 
	        		SE2->E2_VENCORI := DataValida(Ctod("20/"+_MesAtu+"/"+_AnoAtu)) 
			        SE2->E2_VENCREA := DataValida(Ctod("20/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "08"
	       		    SE2->E2_VENCTO  := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
	        		SE2->E2_VENCORI := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
			        SE2->E2_VENCREA := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "09"
	       		    SE2->E2_VENCTO  := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
	        		SE2->E2_VENCORI := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
			        SE2->E2_VENCREA := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "10"
	       		    SE2->E2_VENCTO  := DataValida(Ctod("05/"+_MesAtu+"/"+_AnoAtu)) 
	        		SE2->E2_VENCORI := DataValida(Ctod("05/"+_MesAtu+"/"+_AnoAtu)) 
			        SE2->E2_VENCREA := DataValida(Ctod("05/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "11"
	       		    SE2->E2_VENCTO  := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
	        		SE2->E2_VENCORI := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
			        SE2->E2_VENCREA := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "12"
	       		    SE2->E2_VENCTO  := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
	        		SE2->E2_VENCORI := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
			        SE2->E2_VENCREA := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "13"
	       		    SE2->E2_VENCTO  := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
	        		SE2->E2_VENCORI := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		        	SE2->E2_VENCREA := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		        
	           /*
	           OtherWise
	
	       		    SE2->E2_VENCTO  := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
	        		SE2->E2_VENCORI := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		        SE2->E2_VENCREA := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
	           */           
	        EndCase
	
	
		//SE2->E2_VENCTO  := Ctod("05/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
		//SE2->E2_VENCORI := Ctod("05/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
		//SE2->E2_VENCREA := DataValida(Ctod("05/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4)))		
	                                  
/*			SE2->E2_VALOR   := TRA->E1_ISS
		SE2->E2_SALDO   := TRA->E1_ISS
		SE2->E2_VLCRUZ  := TRA->E1_ISS*/

		SE2->E2_VALOR   := TRA->F3_VALICM
		SE2->E2_SALDO   := TRA->F3_VALICM
		SE2->E2_VLCRUZ  := TRA->F3_VALICM
		SE2->E2_HIST    := "Titulo a Pagar ISS"
		SE2->E2_FLUXO   := "S"
		SE2->E2_RATEIO  := "N"
		SE2->E2_MOEDA   := 1
		SE2->E2_OCORREN := "01"
		SE2->E2_ORIGEM  := "GFINA005"
		SE2->E2_DESDOBR := "N"
		SE2->E2_CCONT   := TRA->E1_CCONT
		Msunlock()
	Endif
	DbSelectArea("TRA")
	DbSkip()
End                                                                   
MsgInfo("Fim do Processamento!")
Close(oGeraSE2)
Return

