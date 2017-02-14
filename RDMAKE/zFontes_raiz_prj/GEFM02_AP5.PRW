#INCLUDE "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 04/04/01
#INCLUDE "TopConn.ch"        // incluido pelo assistente de conversao do AP5 IDE em 04/04/01


User Function Gefm02()        // incluido pelo assistente de conversao do AP5 IDE em 04/04/01

SetPrvt("CTITULO,CDESC1,CDESC2,CDESC3,CSTRING,AORD")
SetPrvt("WNREL,ARETURN,TAMANHO,CRODATXT,CBCONT,LI")
SetPrvt("NLASTKEY,M_PAG,CPERG,CABEC1,CABEC2,ADRIVER")
SetPrvt("CCOMPAC,_OBS,_AREC,_ACOD,_DATA,_CTRC")
SetPrvt("_ITEM,_LINHA,XSUBVAL,_PAG,XDESC,J1")
SetPrvt("ENTROU,I,XVALORT,XEXTENSO,ASX1,X1")
SetPrvt("Z,XSUBTOT,_TEMP,")

Private _cInfMAN := ""
Private  _cCliMAN  := AllTrim(GETNewPar("MV_XCLIMAN","04858701|15882200"))

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠здддддддддддддддддддддбдддддддддддддддддддддддддддддддбддддддддддддддддд©╠╠
╠╠ Funcao    : GEFM02     Autor : Alexandre               Data : 02/09/99  ╠╠
╠╠цдддддддддддддддддддддадддддддддддддддддддддддддддддддаддддддддддддддддд╢╠╠
╠╠  Descricao: Impressao de Relatorio Demonstracao Nota Fatura             ╠╠
╠╠                                                                         ╠╠
╠╠  Arquivo  : SE1                                                         ╠╠
╠╠юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠  AlteraГЦo:                                                             ╠╠
╠╠ 10/07/2006 - Marcos Furtado - AlteraГЦo na forma de processamento,      ╠╠
╠╠                               melhorando a performance                  ╠╠
╠╠ 15/09/2006 - Marcos Furtado - InclusЦo de parБmetro para tratar a       ╠╠
╠╠                               impressao da 2a. via.                     ╠╠
╠╠                                                                         ╠╠
╠╠юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

cTitulo  := "Demonstracao da Nota Fatura"
cDesc1   := "Este programa tem por objetivo gerar demonstracao de          "
cDesc2   := "Nota Fatura."
cDesc3   := ""
cString  := "SE1"
aOrd     := {"Data"}
wnrel    := "GEFM04"     
aReturn  := {"90 Colunas", 1,"GEFCO", 2, 2, 1, "",1}
Tamanho  := "G"
cRodaTxt := ""
CbCont   := 1
Li       := 80
nLastKey := 0
m_pag    := 1
cPerg    := "GEFM04"
cabec1   := ""
cabec2   := ""
_folha   := 0  // 0= Imprime 1= Nao imprime

Pergunte(cPerg,.F.)
//wnrel:=SetPrint(cString,wnrel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.)
wnrel:=SetPrint(cString,wnrel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
//wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If LastKey() == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	 Set Filter To
	 Return
Endif

RptStatus({|| Imprime()})

Return

Static Function Imprime()
Local nQtdVias := 1
aDriver := ReadDriver()
cCompac := aDriver[2]
aDriver := ReadDriver()
@ 0,0 Psay &cCompac

DbSelectArea("SE1")
DbSetOrder(1)
If (DbSeek(xFilial("SE1")+MV_PAR08+MV_PAR03,.T.)) 
//AlteraГЦo - Maros Furtado - 10/07/2006
//	Do While !eof()  
	Do While !eof()  .And. (SE1->E1_PREFIXO ==MV_PAR08) .And. (SE1->E1_NUM >=MV_PAR03) .And. (SE1->E1_NUM <= MV_PAR04) ;
		.And. xFilial("SE1") == SE1->E1_FILIAL
		
		If (SE1->E1_EMISSAO >= MV_PAR01) .and. (SE1->E1_EMISSAO <= MV_PAR02)
//		If (SE1->E1_PREFIXO =="FAT") .and. (SE1->E1_NUM >=MV_PAR03) .and. (SE1->E1_NUM <= MV_PAR04) .and. (SE1->E1_EMISSAO >= MV_PAR01) .and. (SE1->E1_EMISSAO <= MV_PAR02)		
			_obs:=SE1->E1_OBS
			_arec:=Recno()
			_acod:=SE1->E1_NUM
			_data:=SE1->E1_VENCREA
			DbselectArea("SA1")
			DbSetOrder(1)
			If (DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
				_Ctrc  :={}
				_item  := 0
				_linha :=29 
				xSubval:=0
				_pag   :=0
				xDesc  :=0     
                _xsubtot  := 0
                _xsubtot2 := 0
                _xsubtot3 := 0
                _xsubtot4 := 0
                _xsubtot5 := 0
                xsubtot   := 0
                _temp := 0    

				// Por: Ricardo GuimarЦes - Em: 06/02/2014 - Para atende Projeto MAN
				_cInfMAN := ""
				If SE1->E1_CLIENTE + SE1->E1_LOJA $ _cCliMAN .AND. SE1->E1_TIPO = MV_PAR08
					_cInfMAN := "Inf. MAN => Tipo Carreg.: " + AllTrim(SE1->E1_TPCAR) + " - " + "No.CVA: " + AllTrim(SE1->E1_NUMCVA) + " - " + "No.Moniloc: " + AllTrim(SE1->E1_COLMON)
				EndIf                
                
				DbSelectArea("SE1")
				//DbSetOrder(22) // NOVA ORDEM  = Filial+E1_FATURA+DTOS(E1_EMISSAO)  
                               // DbSetOrder(14) Ordem Antiga
                               // Nova ordem no sistema MP8 (22) - Antiga (18)            
                               
				If SE1->E1_CLIENTE + SE1->E1_LOJA $ _cCliMAN //.AND. SE1->E1_TIPO = MV_PAR08
					SET FILTER TO E1_FATURA = _aCod .AND. SE1->E1_FATPREF = MV_PAR08 .AND. SE1->E1_CLIENTE + SE1->E1_LOJA $ _cCliMAN
					dbGoTop()
						Do While !eof() //.and. SE1->E1_FATURA >=_Acod .and. SE1->E1_FATURA <=_Acod			    
						    AADD(_Ctrc,{SE1->E1_EMISSAO,SE1->E1_NUM,SE1->E1_VALOR})
						    xSubval:=xSubval+SE1->E1_VALOR
						    _item:=_item+1                        					                        
							Dbskip()
						EndDo
					dbClearFilter()					
				Else
	    			// Por: J Ricardo - Em: 11/07/2009 - MigraГЦo para versЦo 10 - mudou ordem
					If !dbOrderNickName("FAT_EMIS")
						Alert("Indice por fatura nЦo encontrado.")
						Return
					EndIf	  
									
					If (DbSeek(xFilial("SE1")+SE1->E1_NUM))				
						Do While !eof() .and. SE1->E1_FATURA >=_Acod .and. SE1->E1_FATURA <=_Acod			    
							If SE1->E1_NATUREZ <> "ISS"
						    	AADD(_Ctrc,{SE1->E1_EMISSAO,SE1->E1_NUM,SE1->E1_VALLIQ})
						    	xSubval:=xSubval+SE1->E1_VALLIQ
						    	_item:=_item+1                        					                        
						    EndIf	
							Dbskip()
						EndDo
					EndIf	
				Endif
								
				DbSelectArea("SE1")
				DbSetOrder(1)
				If (DbSeek(xFilial("SE1")+MV_PAR08+MV_PAR03+" "+"AB-"))
					xDesc:=SE1->E1_VALOR				
				Endif
			Endif
            
            _Fatura := SE1->E1_NUM
            _Kernel := 0
                        
			//AlteraГЦo Marcos Furtado - 13/09/2006 - InclusЦo de ParБmetro se imprime a 2╙ Via
			If MV_PAR07 = 1  
				nQtdVias := 2
			Else              
				nQtdVias := 1
			EndIF

//			For J1:=1 TO 2
			For J1:=1 TO nQtdVias			
			       
			    IF _folha == 0
			  	   Cabecalho()  // Somente 1 folha			
            	      
            	    // Carimbo na 1 folha

                     @ 24,68 Psay "здддддддддддддддддддддддд©"
                     @ 25,68 Psay "ЁReservado a Instituicao Ё"
                     @ 26,68 Psay "Ё       Financeira       Ё"
                     @ 27,68 Psay "Ё                        Ё"
                     @ 28,68 Psay "Ё                        Ё"
	                 @ 30,68 Psay "юдддддддддддддддддддддддды"   		             
   		             
	                 @ 31,68 Psay "здддддддддддддддддддддддд©"   
            		 @ 32,68 Psay "|                        |"
          		     @ 33,68 Psay "|                        |"
                     @ 34,68 Psay "|                        |"
          		     @ 35,68 Psay "|                        |"
          		     @ 36,68 Psay "|                        |"
                     @ 37,68 Psay "юдддддддддддддддддддддддды"                     

  			       FRodape()    // Somente 1 folha 			    
                   Eject
  			       Setprc(0,0)
  			       
					If MV_PAR07 = 1  				
				  	   Cabecalho()  // Somente 1 folha			  			         			       
	                                                       
	                     @ 24,68 Psay "здддддддддддддддддддддддд©"
	                     @ 25,68 Psay "ЁReservado a Instituicao Ё"
	                     @ 26,68 Psay "Ё       Financeira       Ё"
	                     @ 27,68 Psay "Ё                        Ё"
	                     @ 28,68 Psay "Ё                        Ё"
		                 @ 30,02 Psay "2╖ Via"
		                 @ 30,68 Psay "юдддддддддддддддддддддддды"   		             
	    		         
	                   	 @ 31,02 Psay "======"
		                 @ 31,68 Psay "здддддддддддддддддддддддд©"   
	            		 @ 32,68 Psay "|                        |"
	          		     @ 33,68 Psay "|                        |"
	                     @ 34,68 Psay "|                        |"
	          		     @ 35,68 Psay "|                        |"
	          		     @ 36,68 Psay "|                        |"
	                     @ 37,68 Psay "юдддддддддддддддддддддддды"
		                
	  			       FRodape()    // Somente 1 folha
	  			    EndIf
	  			    
  			       _folha := 1  // Flag de controle  			       			       
  			       
			    EndIf						
                IF _folha == 1	
				    _linha:= 9 			                  		
				    Detalhe()       	   // Apartir da 2 folha	             
                    Itens()     	       // Apartir da 2 folha	   			                  
                    _Kernel := _Kernel + 1
                  
                  IF _Kernel > 1 .Or. MV_PAR07 = 2
                    _folha := 0            // Troca de fatura (imprime folha principal)
                    _Kernel := 0           // Controla Folhas - RepetiГЦo
                  EndIF  
                  
			    EndIf					
								
			Next
			
			DbSelectArea("SE1")
			DbSetOrder(1)
			Goto _aRec
		EndIf
		Dbskip()
	EndDo
Endif

Set Device To Screen

If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

Return

Static Function Itens()

entrou:=.t.
entrou2v:=.t.

For I:=1 to len(_ctrc)
    @ _linha,15 Psay "|" 		            				     									
	@ _linha,16 Psay "  "+alltrim(str(i))+replicate(" ",4-len(alltrim(str(i))))+"|"
	@ _linha,26 Psay substr(dtos(_Ctrc[i][1]),7,2)+"/"+substr(dtos(_Ctrc[i][1]),5,2)+"/"+substr(dtos(_Ctrc[i][1]),3,2)+"     |"
	@ _linha,41 Psay _Ctrc[i][2]+" |"
	@ _linha,52 Psay _Ctrc[i][3] Picture "@E 99,999,999.99"+"  " 
	@ _linha,70 Psay "  |" 		            				     									

// Retirado o carimbo nas demais folhas
//
/* 	
 	    If (_linha ==30) .Or. (_linha ==37) 
		    @ _linha,68 Psay "юдддддддддддддддддддддддды"
	    Endif

        If (_linha ==31)
		    @ _linha,68 Psay "здддддддддддддддддддддддд©"
	    Endif
    
        If (_linha >=32 .and. _linha <=36 )
		    @ _linha,68 Psay "|                        |"
	    Endif
*/

    _linha:=_linha+1      
    _temp := _temp+_Ctrc[i][3]

    // Testa 2 via
    If entrou2v                   // Alterado em 07/08/03 - Saulo
       _temp:= 0                  // Zera o Sub-total
       _temp:= _temp+_Ctrc[i][3]  // Acumula o prox. ctrc	      
       entrou2v:=.f.
    Endif

 
//    If (I == 12) .Or.(I ==23) .Or. (I ==34) .Or. (I ==45) .Or. (I ==56) .Or. (I ==67) .Or. (I ==78) .Or. (I ==89) .Or. (I ==100) .Or. (I ==111) .Or. (I ==122) .Or. (I ==133) .Or. (I ==144) .Or. (I ==155) .Or. (I ==166) .Or. (I ==177) .Or. (I ==188) .Or. (I ==199) .Or. (I ==210) .Or. (I ==221) .Or. (I ==232) .Or. (I ==243) .Or. (I ==254) .Or. (I ==265) .Or. (I ==276) .Or. (I ==287) .Or. (I ==298) .Or. (I ==309) .Or. (I ==320) .Or. (I ==331) .Or. (I ==342) .Or. (I ==353) .Or. (I ==364) .Or. (I ==375) .Or. (I ==386) .Or. (I ==397) 
//         _temp:= 0                  // Zera o Sub-total
//         _temp:= _temp+_Ctrc[i][3]  // Acumula o prox. ctrc
//    EndIf      


	If (_linha ==61) 
//          _linha:=_linha+1      
		@ _linha,015 Psay  "| Sub-Total  -----------------------> "      
        @ _linha,050 Psay   _temp Picture "@E 99,999,999.99"  
        @ _linha+1,015 Psay "юддддддддддддддддддддддддддддддддддддддддддддддддддддддды"
         _temp:= 0                  // Zera o Sub-total	    
		entrou:=.f.	       
		If I < len(_ctrc)
//			FRodape()
//			Cabecalho()
			Detalhe()
			_linha:= 9 
			entrou:=.t.
			entrou2v:=.t. 
		EndIf          
	Endif	

    If (I == 52) .Or.(I ==104) .Or. (I ==156) .Or. (I ==208) .Or. (I ==260) .Or. (I ==312) .Or. (I ==364) .Or. (I ==416) .Or. (I ==468) .Or. (I ==520) 
         _temp:= 0                  // Zera o Sub-total
         _temp:= _temp+_Ctrc[i][3]  // Acumula o prox. ctrc
    Endif       
    
    If I == len(_ctrc)    
          _linha:=_linha+1      
		@ _linha,015 Psay  "| Sub-Total  -----------------------> "      
        @ _linha,50 Psay   _temp Picture "@E 99,999,999.99"  
          _linha:=_linha+1      
        @ _linha,15 Psay "юддддддддддддддддддддддддддддддддддддддддддддддддддддддды"
    Endif    

	
Next

/*
for i:=_linha to 40
	If entrou
		entrou:=.f.
		@ _linha,015 Psay "юддддддддддддддддддддддддддддддддддддддддддддддддддддддды"
//		@ _linha,02 Psay If(_linha ==29 .or. _linha ==37,"юддддддддддддддддддддддддддддддддддддддддддддддддддддддды"+"         юдддддддддддддддддддддддды",If(_linha==31,"юддддддддддддддддддддддддддддддддддддддддддддддддддддддды"+"         здддддддддддддддддддддддд©",If((_linha >=32 .and. _linha <=36 ).or.(_linha <=31),"юддддддддддддддддддддддддддддддддддддддддддддддддддддддды"+"                                   ","юддддддддддддддддддддддддддддддддддддддддддддддддддддддды")))
	Endif


	If (_linha ==30 ).or.(_linha ==37)
		@ _linha,68 Psay "юдддддддддддддддддддддддды"
	Endif
	If (_linha ==31) 
		@ _linha,68 Psay "здддддддддддддддддддддддд©"
	Endif
	If (_linha >=32 .and. _linha <=36 )
		@ _linha,68 Psay "|                        |"
	Endif

	_linha:=_linha+1

Next
*/

Return
  
Static Function Cabecalho()

xValort  :=xSubval-xDesc
xExtenso :=Extenso(xValort,.F.,1)
xExtenso :=Alltrim(xExtenso)

// Layout do Sacado
//================
//Modificado em 11/04/03

nLin := 1

@ nLin,49   Psay  "здддддддддддддддддддддддддддддддддддддддд©"
@ ++nLin,49 Psay  "|Codigo   :" + SA1->A1_COD
@ nLin  ,00 Psay  Replicate (" ",90) + "|"
@ ++nLin,49 Psay  "|Sacado   :" + substr(SA1->A1_NOME,1,30)
@ nLin  ,00 Psay  Replicate (" ",90) + "|"
@ ++nLin,49 Psay  "|Endereco :" + substr(SA1->A1_ENDCOB,1,30)
@ nLin  ,00 Psay  Replicate (" ",90) + "|"
If AllTrim(SubStr(SA1->A1_ENDCOB,30,10)) == "|"
	@ ++nLin,49 Psay  "|Bairro   :" + AllTrim(SA1->A1_BAIRROC)
Else
	@ ++nLin,49 Psay  "|" + substr(SA1->A1_ENDCOB,30,10)
	@ nLin  ,00 Psay  Replicate (" ",90) + "|"
	@ ++nLin,49 Psay  "|" + AllTrim(SA1->A1_BAIRROC)
EndIf
@ nLin  ,00   Psay Replicate (" ",90) + "|"
@ ++nLin,49 Psay "|Municipio:" + AllTrim(SA1->A1_MUNC)
@ nLin  ,00   Psay Replicate (" ",90) + "|"
@ ++nLin,49 Psay "|Estado   :" + AllTrim(SA1->A1_ESTC) + " - CEP:"+substr(SA1->A1_CEPC,1,5) + "-" + substr(SA1->A1_CEP,6,3)
@ nLin  ,00   Psay Replicate (" ",90) + "|"
@ ++nLin,49 Psay "|CNPJ     :" + substr(SA1->A1_CGC,1,2) + "."+substr(SA1->A1_CGC,3,3) + "." + substr(SA1->A1_CGC,6,3) + "/" + substr(SA1->A1_CGC,9,4) + "-" + substr(SA1->A1_CGC,13,3)
@ nLin  ,00   Psay Replicate (" ",90) + "|"
@ ++nLin,49 Psay "|Insc.Est.:" + AllTrim(SA1->A1_INSCR)
@ nLin  ,00   Psay Replicate (" ",90) + "|"
@ ++nLin,49 Psay "юдддддддддддддддддддддддддддддддддддддддды"

// layout do Local
//================

//If J1 == 2
//	@ 11,02 Psay "2╖ Via"
//	@ 12,02 Psay "======"
//Endif

@ 13,02 Psay "з"+Replicate("д",88)+"©"
@ 14,02 Psay "|" + "Local :"+ AllTrim(MV_PAR05) +Replicate(" ",20)+ " "+ "Data de Emissao: "+DTOC(Ddatabase)
@ 14,91 Psay "|"
@ 15,02 Psay "ю"+Replicate("д",88)+"ы"

//Layout do estabelecimento
@ 16,02 Psay "з"+Replicate("д",88)+"©"
@ 17,02 Psay "| Deve(mos) ┘ GEFCO DO BRASIL LTDA.,estabelecida ┘ "+Alltrim(MV_PAR05)
@ 17,91 Psay "|"
@ 18,02 Psay "|Rio de Janeiro,Estado do Rio de Janeiro, a importancia demonstrada abaixo:  "+Replicate(" ",12)+"|"
@ 19,02 Psay "ю"+Replicate("д",88)+"ы"

// layout da fatura
//================
@ 20,02 Psay "з"+Replicate("д",88)+"©"
@ 21,02 Psay "|Fatura Numero :          Valor R$                        Data de Vencimento :           |"
@ 22,02 Psay "|" + _acod + Replicate(" ",16)+"|"
@ 22,42 Psay xValort Picture "@E 99,999,999.99"
@ 22,56 Psay "|"
@ 22,62 Psay substr(dtos(_DATA),7,2)+"/"+substr(dtos(_DATA),5,2)+"/"+substr(dtos(_DATA),3,2)+"                  "
@ 22,91 Psay "|"
@ 23,02 Psay "ю"+Replicate("д",88)+"ы"

Return


Static Function FRodape()
   
// Layout do Sacado
//@ 41,02 Psay  "зддддддддддддддддддддддддддддддддддддддддддддддддддддддд©"
//@ 42,02 Psay  "|Sub-Total                        "
//@ 42,43 Psay   _temp Picture "@E 99,999,999.99"  
//@ 42,56 Psay  "  |"
//@ 43,02 Psay  "юддддддддддддддддддддддддддддддддддддддддддддддддддддддды"

@ 44,02 Psay  "зддддддддддддддддддддддддддддддддддддддддддддддддддддддд©"
@ 45,02 Psay  "|Desconto Oferecido                "
@ 45,43 Psay  xdesc Picture "@E 99,999,999.99"
@ 45,56 Psay  "  |"
@ 46,02 Psay  "юддддддддддддддддддддддддддддддддддддддддддддддддддддддды"

@ 47,02 Psay "зддддддддддддддддддддддддддддддддддддддддддддддддддддддд©"
@ 48,02 Psay "|Total desta Fatura                "
@ 48,43 Psay xValort Picture "@E 99,999,999.99"
@ 48,56 Psay "  |"
@ 49,02 Psay "юддддддддддддддддддддддддддддддддддддддддддддддддддддддды"

@ 50,01 Psay "з"+Replicate("д",88)+"©"
@ 51,01 Psay "|Observacoes :"
@ 51,01 Psay Replicate(" ",15) + AllTrim(MV_PAR06)
@ 51,01 Psay Replicate(" ",90) + "|"
// Por: Ricardo GuimarЦes - Em: 06/02/2014 - Para atender o projeto MAN
@ 52,01 Psay "|" + _cInfMAN
@ 52,01 Psay Replicate(" ",90) + "|"
@ 53,01 Psay "ю"+Replicate("д",88)+"ы"

@ 54,01 Psay "з"+Replicate("д",88)+"©"
@ 55,01 Psay  "|Valor  por |"+ substr(xExtenso,1,75) + Replicate("x",75-Len(substr(xExtenso,1,75))) +" |"
@ 56,01 Psay  "|Extenso    |"+ substr(xExtenso,76,150) + Replicate("x",75-Len(substr(xExtenso,76,150))) +" |"
@ 57,01 Psay "ю"+Replicate("д",88)+"ы"

Return                                                                               

Static Function Detalhe()


 @ 4,15 Psay "зддддддддддддддддддддддддддддддддддддддддддддддддддддддд©         
 @ 5,15 Psay "Ё                      CTRC                             Ё         
 @ 6,15 Psay "ЁдддддддддддддддддддддддддддддддддддддддддддддддддддддддЁ         
 @ 7,15 Psay "Ё Seq Ё  Data de Emissao  Ё Numero  Ё  Valor R$         Ё         
 @ 8,15 Psay "ЁдддддддддддддддддддддддддддддддддддддддддддддддддддддддЁ         

// @ 1,02 Psay "зддддддддддддддддддддддддддддддддддддддддддддддддддддддд©         здддддддддддддддддддддддд©"
// @ 2,02 Psay "Ё                      CTRC                             Ё         ЁReservado a Instituicao Ё"
// @ 3,02 Psay "ЁдддддддддддддддддддддддддддддддддддддддддддддддддддддддЁ         Ё       Financeira       Ё"
// @ 4,02 Psay "Ё Seq Ё  Data de Emissao  Ё Numero  Ё  Valor R$         Ё         Ё                        Ё"
// @ 5,02 Psay "ЁдддддддддддддддддддддддддддддддддддддддддддддддддддддддЁ         Ё                        Ё"


Return


/*         1         2         3         4         5         6         7         8         9         0         1
12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
зддддддддддддддддддддддддддддддддддддддддд©
1                                                       Sacado   :123456789012345678901234567890  
2                                                       Endereco :123456789012345678901234567890  
3                                                       12345678901234567890123456789012345678901 
4                                                       Municipio:123456789012345                 
5                                                       Estado   :12  Cep:12345-678               
6                                                        CNPJ    :12.111.111/1111-11              
7                                                      юддддддддддддддддддддддддддддддддддддддддды
8
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Local :                                                Data de Emissao:                      
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
3                                                53
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
 Deve(mos) ┘ GEFCO DO BRASIL LTDA.,estabelecida ┘ 12345678901234567890123456789012345678901234 
 , Rio de Janeiro,Estado do Rio de Janeiro , a importancia demostrada Abaixo:                  
 Noventa e Quatro Reais....................................................................... 
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
29  Fatura Numero :          Valor R$                       Data de Vencimento : 12/12/12         
30                                                                                                
31 юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
32 зддддддддддддддддддддддддддддддддддддддддддддддддддддддд©            здддддддддддддддддддддддд©
33                        CTRC                                                                    
34  ддддддддддддддддддддддддддддддддддддддддддддддддддддддд                                       
35   Seq    Data de Emissao    Numero     Valor R$                                                
36  ддддддддддддддддддддддддддддддддддддддддддддддддддддддд                                       
37   01                                                                                           
38   02                                                                 юдддддддддддддддддддддддды
39   03                                                                 здддддддддддддддддддддддд©
40   04                                                                                           
41   05                                                                                           
42   06                                                                                           
43   07                                                                                           
44   08                                                                                           
45   09                                                                 юдддддддддддддддддддддддды
46   10                                                     
47   11                                                     
48 юддддддддддддддддддддддддддддддддддддддддддддддддддддддды
49 зддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
50  Sub-Total                               999.999.999,99  
51 юддддддддддддддддддддддддддддддддддддддддддддддддддддддды
52 зддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
53  Desconto Oferecido                      999.999.999,99  
54 юддддддддддддддддддддддддддддддддддддддддддддддддддддддды
55 зддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
56  Total desta Fatura                      999.999.999,99  
57 юддддддддддддддддддддддддддддддддддддддддддддддддддддддды
58 зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
59  Observacoes :                                                                                 
60                                                                                                
61                                                                                                
62                                                                                                
63 юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

*/