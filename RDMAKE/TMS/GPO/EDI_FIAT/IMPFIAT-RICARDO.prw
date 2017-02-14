#INCLUDE "Protheus.ch"
#include "TopConn.ch"
#include "TbiConn.ch"

//------------------------------------------------------------------------------  
/*/{Protheus.doc} IMPFIAT()  

Faz o processo de importação da Fiat para o Protheus

@author	 Lucas Cassiano  
@since	 22/02/2016  
@version P11                                                                                    

@comments  
/*/  
//------------------------------------------------------------------------------

User Function IMPFIAT(cFil,cContrato,cCaminho)
Local   _cLinha   	:= "" 
Local   aDados	  	:= {} 
Local   nErro	  	:= 0
Local   cMsg	  	:= ""
Local   lModelo   	:= .T.
Local   lErro     	:= .F.
Local   _cCgcOri  	:= ""
Local   _cCgcDes  	:= ""
Local 	_CgcOrigem	:= ""
Local   _CgcDestino	:= "" 
Local   nTotLine	:= 0

Private _nKm1	  :=0
Private _nKm2	  :=0
Private cTabVen   := ""
Private cVerTab   := ""
Private cIttabv   := ""
Private cTabCom   := ""
Private cVerCom   := ""
Private cIttCom   := ""  
Private _cCepOri  := "" 
Private _cCepDes  := "" 
Private cCodVei	  := ""
Private cDesVei	  := ""
Private nPadv     := 0
Private	nFranqc	  := 0
Private	nFranqu	  := 0 			
Private nSkmVen   := 0
Private nSkmCom   := 0	
Private lMilkRun  := .F.
Private aDados2	  := {}      
Private lFim	  := .F.
Private cArquivo  := ""
Private cperg	  := "IMPFIAT"  
Private	MV_PAR01  := cFil
Private	MV_PAR02  := cContrato
Private	MV_PAR03  := cCaminho 
Private	cFilial   := cFil
Private	cContra   := cContrato
Private	cCamin    := cCaminho 

	// Crio as perguntas
/* 
	CriaSX1(cperg)

if ! Pergunte(cPerg,.T.)
	Return Nil
endif
*/

	If !( xPergunte( cFil,cContrato,cCaminho ) )
		Return(.F.)
	EndIF          

	cArquivo:= MV_PAR03

IF !File(cArquivo)
	MsgAlert("O arquivo não foi encontrado! ","Atencao!")
	Return
Endif  

if ( nHandle := FT_FUSE(cArquivo) ) == -1
	MsgAlert("O arquivo não pode ser aberto! ","Atencao!")
	Return
Endif
          
FT_FUSE(cArquivo)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF() 
         
 		nTotLine++
		_cLinha := FT_FREADLN()
     		
 		AADD(aDados,SUBSTR(_cLinha,1,10))    // Número da Solicitação
 		AADD(aDados,SUBSTR(_cLinha,11,8))   // Data Solicitação
 		AADD(aDados,SUBSTR(_cLinha,19,5))   // Hora Coleta
 		AADD(aDados,SUBSTR(_cLinha,24,5))   // Hora envio
 		AADD(aDados,SUBSTR(_cLinha,29,5))   // Hora Destino
 		AADD(aDados,SUBSTR(_cLinha,34,120))  // Endereço de Coleta
 		AADD(aDados,SUBSTR(_cLinha,154,14)) // Cnpj Origem
 		AADD(aDados,SUBSTR(_cLinha,168,14)) // Cnpj Destino
 		AADD(aDados,SUBSTR(_cLinha,182,14)) // Cnpj Transportador
 		AADD(aDados,SUBSTR(_cLinha,196,2)) // Tipo Veículo
 		AADD(aDados,SUBSTR(_cLinha,198,15)) // Veiculo
 		AADD(aDados,SUBSTR(_cLinha,213,20)) // Part Number
 		AADD(aDados,SUBSTR(_cLinha,233,12)) // OC
 		AADD(aDados,SUBSTR(_cLinha,245,10)) // Quantidade Prevista
 		AADD(aDados,SUBSTR(_cLinha,255,12)) // Nota Fiscal
 		AADD(aDados,SUBSTR(_cLinha,267,10)) // Valor Nota Fiscal
 		AADD(aDados,SUBSTR(_cLinha,277,10)) // Peso Previsto
 		AADD(aDados,SUBSTR(_cLinha,287,5)) // KM Previsto
 		AADD(aDados,SUBSTR(_cLinha,292,10)) // Pedágio Previsto
 		AADD(aDados,SUBSTR(_cLinha,302,9)) // Rota
 		AADD(aDados,SUBSTR(_cLinha,311,14)) // Cnpj Tomador
 		AADD(aDados,SUBSTR(_cLinha,325,1)) // Modelo
 		
 		IF adados[22] $ "M"
 			_CgcOrigem:='03094658001250' 
 			_CgcDestino:='03094658001250' 
 		Else
 			_CgcOrigem:=adados[7]
 			_CgcDestino:=adados[8]
 	
 		EndIf   
 			_CgcColeta :=adados[7]
	     
	     If nTotLine = FT_FLASTREC()
	        lFim := .T.
	     Endif    
 		lErro:= CHECKZT2(_CgcOrigem,_CgcColeta,_CgcDestino,aDados[22],lFim) // Faço a verificação da Tabela Cep X cep
 		
 		IF lErro = .T. 
 			cMsg += "Para o Cep Origem "+_cCepOri+" até o Cep Destino "+_cCepDes+" não tem Km cadastrada" + CRLF  
       		nErro++
       		lErro :=.T.
       		Exit
   		Endif   
   		
   		AADD(aDados,_nKm1) // Km Venda
 		AADD(aDados,_nKm2) // Km Compra
 		
 		AADD(aDados2,aDados)
 		aDados:={}	
 		
		_nKm1:=0
 		_nKm2:=0
	FT_FSKIP()
EndDo   
	
		//Posiciono da DUT para pegar o Codigo do veiculo que é do Protheus 		
		DBSELECTAREA("DUT")
		DBSETORDER(4)
		IF DBSEEK(XFILIAL("DUT")+aDados2[1,10])
			cCodvei:=DUT->DUT_TIPVEI
			cDesVei:=DUT->DUT_DESCRI
		Else
			cMsg += "Não existe DE|PARA o tipo de veiculo,para essa importação" + CRLF
			nErro++
			lErro :=.T.   
		Endif		 
 		
	If lErro = .T.
   		GERAERRO(cMsg)
	Endif 

	If lErro = .T.
		Return 
	Endif     
	
	IF aDados2[1,22] $ "M"
			
// Abro a ZA0 para pegar o cliente e loja que irei usar como busca na SA1//

		DBSELECTAREA("ZA0")
		ZA0->(dbclearFilter())
		ZA0->(DBSETFILter({|| alltrim(ZA0->ZA0_PROJET) == alltrim(MV_PAR02)},"alltrim(ZA0->ZA0_PROJET) == alltrim(MV_PAR02)"))
		ZA0->(dbGotop())
		
		IF !EMPTY(ZA0->ZA0_PROJET)
			
			DBSELECTAREA("SA1")
			SA1->(DBSETORDER(1))
			SA1->(DBSEEK(XFILIAL("SA1")+ZA0->ZA0_CLI+ZA0->ZA0_LOJA))  
				_cCgcOri:=SA1->A1_CGC
				_cCgcDes:=SA1->A1_CGC
		Endif
	
	ElseIf aDados2[1,22] $ "T"
		           
		//Abro a SA1 para pegar os dados da GEFCO
		 	 	cCod   	:="026119"
		 	 	cLoja  	:="00" 
		 	 			 	 	
		 	 	DBSELECTAREA("SA1")
		 	 	SA1->(DBSETORDER(1))
		 	 	SA1->(DBSEEK(XFILIAL("SA1")+cCod+cLoja))
		 	 		_cCgcOri:=SA1->A1_CGC
					
			SA1->(DBSETORDER(3))
			SA1->(DBSEEK(XFILIAL("SA1")+adados2[1,8]))  
			    _cCgcDes:=SA1->A1_CGC			
      Else
       		SA1->(DBSETORDER(3))
			SA1->(DBSEEK(XFILIAL("SA1")+adados2[1,7]))  
			    _cCgcOri:=SA1->A1_CGC			
			SA1->(DBSETORDER(3))
			SA1->(DBSEEK(XFILIAL("SA1")+adados2[1,8]))  
			    _cCgcDes:=SA1->A1_CGC
   endif
        
   IF adados2[1,22] $ "M"
		CtipFluxo:= "C"
   Else
		CtipFluxo:= "I"
   Endif 
    
    // Verifico se a Viagem tem vinculo com a Tabela de Venda se não tiver eu travo a importação    
  lErro:= ATUITEM('N',CtipFluxo,'N',CTOD(adados2[1,2]),cCodVei,_cCgcOri,_cCgcDes,aDados2[1,22]) //ZA6_TPTRAN,ZA6_TIPFLU,ZA6_TIPLKM,ZA6_DTINI,ZA6_TRANSP,A1_CGC Origem,A1_CGC Destino,ZA6_MODELO
   
   IF lErro = .T.
        
   		IF	aDados2[1,22] $ 'M'
	   		_cOrigem:= "GUARULHOS"
	   		_cDestino:= "GUARULHOS"
	   		
   		Else
   		
	   		_cOrigem:=Posicione("SA1",3,XFILIAL("SA1")+_cCgcOri,"A1_MUN")
	   		    	
	   		DBSELECTAREA("SA1")
	    	SA1->(DBSETORDER(3))
	    	SA1->(DBSEEK(XFILIAL("SA1")+_cCgcDes)) 
	    	_cDestino:= SA1->A1_MUN	    	
    	Endif 
    	   		
       	//cMsg += "Não existe tabela de venda para os seguintes parâmetros: Data: "+adados2[1,2]+" | Tipo Transporte: N | Tipo Fluxo: "+cTipFluxo+" | Tipo Veiculo: "+cCodVei+" | Município Origem: "+ALLTRIM(_cOrigem)+" | Município Destino: "+ALLTRIM(_cDestino)+" | Cliente Contrato: " +ALLTRIM(SA1->A1_NOME)+" | Cnpj Contrato: "+SA1->A1_CGC   + CRLF  
       	cMsg += "Não existe tabela de venda para os seguintes parâmetros: Data: "+adados2[1,2]+" | Tipo Transporte: N | Tipo Fluxo: "+cTipFluxo+" | Tipo Veiculo: "+cCodVei+" | Município Origem: "+ALLTRIM(_cOrigem)+" | Município Destino: "+ALLTRIM(_cDestino)+" | Cliente Contrato: " +ALLTRIM(ZA0->ZA0_CLINOM)+" | Cnpj Contrato: "+ZA0->ZA0_CLICGC   + CRLF  
       	nErro++     
       	lErro :=.T.
   Endif  
    
   If lErro = .T.
		GERAERRO(cMsg)
   Endif 

   If lErro = .T.
		Return 
   Endif    	
	
	For L:=1 to Len(aDados2)
 	
 	// Se o modelo for diferente a T,M,6 ele muda o modelo para F com isso impossibilitando a sua importação
 	
 	IF !(aDados2[L][22] $ "T|M|6")  
 	   lModelo := .F.
 	endif
 	    		
 	IF aDados2[L][22] $ "M" // Se for Milk Run gravo a Sequencia de Coleta na ZA7  
 	   lMilkRun := .T.
 	endif
 		
 		DBSELECTAREA("SA1")
    	DBSETORDER(3)    	
    	IF !DBSEEK(XFILIAL("SA1")+adados2[L,7])  
	    	cMsg += "Cnpj: "+ adados2[L,7]+" Inválido" + CRLF
	    	nErro++    
	    	lErro :=.T.
	    else
		    cCliente	:= SA1->A1_COD    // Cliente Origem
		    cLoja		:= SA1->A1_LOJA 
		    cmun		:= SA1->A1_COD_MUN //Usado para posicionar no ZA2 para o tipo de modelo 
			cest    	:= SA1->A1_EST
			cNomeMunori := SA1->A1_MUN
			cnome	    := SA1->A1_NOME			
		ENDIF    	
    		
    		DBSELECTAREA("SA1")
    		DBSETORDER(3)
    		IF !DBSEEK(XFILIAL("SA1")+adados2[L,8])
				cMsg += "Cnpj: "+ adados2[L,8]+" Inválido" + CRLF
				nErro++
				lErro :=.T.
			else   
				cCliente2	:= SA1->A1_COD // Cliente Destino
		    	cLoja2	 	:= SA1->A1_LOJA
		    	cmun2	 	:= SA1->A1_COD_MUN //Usado para posicionar no ZA2 para o tipo de modelo destino  
		    	cest2    	:= SA1->A1_EST
		    	cNomeMundes := SA1->A1_MUN
		    endif	     
		    
				DBSELECTAREA("SA1")
	    		DBSETORDER(3)
	    		IF !DBSEEK(XFILIAL("SA1")+adados2[L,9])
		   		   cMsg += "Cnpj: "+ adados2[L,9]+" Inválido" + CRLF
		   		   nErro++ 
		   		   lErro :=.T.
				endif	
						
					DBSELECTAREA("SA1")
	    			DBSETORDER(3)
	    			IF !DBSEEK(XFILIAL("SA1")+adados2[L,21])
						cMsg += "Cnpj: "+ adados2[L,21]+" Inválido" + CRLF
						nErro++   
						lErro :=.T.
					endif				
	next L 
	
	IF lmodelo == .F. // Só vai importar ser o modelo for M,6 ou T
	   MSGINFO("Importação não foi realizada, pois o tipo de modelo é diferente de MILK RUN,FTL,LINEHAUL. ","Atenção")		 
	   Return
	Endif
	   
	IF  nErro > 0 
	    GERAERRO(cMsg)
	EndIf 
	
If lErro = .F.	
	Processa({||fGERARQ()},"Aguarde o Fim do Processamento")
Endif     
		 
Return( .T. )
	
Static Function GERAERRO(cMsg)
		
		cLog:=Left(cArquivo,At(".txt",cArquivo)-1)+"_LOG.txt" // Crio o caminho para o arquivo de log que será salvo
		nHandle := FCreate(cLog) // Crio o novo Arquivo para o log
		fWrite(nHandle, cMsg, len(cMsg) ) //Efetuo a gravação em txt
		FClose(nHandle) // Fecho o arquivo de Log
		MSGINFO("Importação não foi Realizada olhar o log no caminho: "+cLog,"Atenção")		
	
return  
//------------------------------------------------------------------------------  
/*/{Protheus.doc} fGERARQ()  

Chamada para importar o Arquivo TXT proveniente da FIAT

@author	 Lucas Cassiano  
@since	 22/02/2016  
@version P11  

@comments  
/*/  
//------------------------------------------------------------------------------

STATIC FUNCTION fGERARQ() 

Local   lImporta  := .T.
Local	lZA6	  := .T.
Local   cObsZA7	  := "" 
Local   cSeqCar   := ""
     
// Verifico se existe o Log de inclusão na ZCT caso houver eu pergunto se o usuário deseja atualizar isso sera feito apenas uma vez

DBSELECTAREA("ZCT")
DBSETORDER(1)
IF DBSEEK(MV_PAR01+adados2[1][1]+MV_PAR02)
	IF MSGYESNO("Já foi importado esse contrato anteriormente, deseja atualizar ?")
		
		lImporta:= .F.	
	
Begin Transaction

		// crio a nova sequencia para a obra ZA6 
		    IF Select("TRBMAX") > 0
				TRBMAX->( DbCloseArea() )
			EndIf			
			
			csql:="SELECT MAX(ZA6_OBRA)+1 SEQ FROM "+RETSQLNAME("ZA6")+" ZA6" +CRLF
			csql+=" WHERE ZA6_PROJET= '"+MV_PAR02+"'"
		    csql+=" AND   ZA6_FILIAL= '"+MV_PAR01+"'"			 
			csql+=" AND D_E_L_E_T_ = '' "
			PLSQUERY(csql,"TRBMAX")
			
			IF EMPTY(TRBMAX->SEQ)
				cRet:='001'
			Else   	
				cRet:=StrZero(TRBMAX->SEQ,3)				
			Endif 
			
	ProcRegua(Len(aDados2))
	I:=0
	While I < LEN(aDados2) 
	i++
	
		IncProc("Atualizando Registros")
         
			DBSELECTAREA("SA1")
			DBSETORDER(3)
			DBSEEK(XFILIAL("SA1")+ adados2[i][7])  
			//DBSEEK(XFILIAL("SA1")+ZA0->ZA0_CLI+ZA0->ZA0_LOJA)  
			
			// Posiciono na ZA2 para pegar o devido código de município de origem//
		 	 DBSELECTAREA("ZA2")
		 	 DBSETORDER(4)
		 	 IF DBSEEK(XFILIAL("ZA2")+cmun+cest) .and. adados2[i][22] $ "6" // So fara essa tratativa se o modelo for 6 ou T se for modelo M deve vincular dados como Guarulhos
		 	 	cCodmunori	  :=ZA2->ZA2_CODIGO
		 	 	//cCodnomemunori:=ZA2->ZA2_DESCRI
		 	 	cCodestori:=ZA2->ZA2_ESTADO
		 	 	cCliori:=SA1->A1_COD
		 	 	clojaori:=SA1->A1_LOJA 
		 	 	cNomeori:=SA1->A1_NOME
		 	 	cCepori:=SA1->A1_CEP
		 	 			 	 			 	 			 	
		 	 Elseif adados2[i][22] $ "T|M" 
		 	 	
		 	 	//Abro a SA1 para pegar os dados da GEFCO
		 	 	cCod   	:="026119"
		 	 	cLoja  	:="00" 
		 	 			 	 	
		 	 	DBSELECTAREA("SA1")
		 	 	SA1->(DBSETORDER(1))
		 	 	SA1->(DBSEEK(XFILIAL("SA1")+cCod+cLoja))
		 	 
		 	 	cCodmunori:= "003912" // Fixo de guarulhos 
		 	 	cCodestori:="SP" 
		 	 	cCliori:=SA1->A1_COD
		 	 	clojaori:=SA1->A1_LOJA 
		 	 	cNomeori:=SA1->A1_NOME
		 	 	cCepori:=SA1->A1_CEP		 	 	
		 	 	
		 	 endif 
		 	  
		 	 DBSELECTAREA("SA1")
    		 DBSETORDER(3)
    		 DBSEEK(XFILIAL("SA1")+adados2[i,8])
			
		// Posiciono na ZA2 para pegar o devido código de município de Destino//
		 	 DBSELECTAREA("ZA2")
		 	 DBSETORDER(4)
		 	 IF DBSEEK(XFILIAL("ZA2")+cmun2+cest2) .and. adados2[i][22] $ "6" // So fara essa tratativa se o modelo for 6 ou T se for modelo M deve vincular dados como Guarulhos
		 	 	
		 	 	cCodmunDes		:=ZA2->ZA2_CODIGO         
		 	 	cCodnomemundes	:=ZA2->ZA2_DESCRI
		 	 	cCodestdes		:=ZA2->ZA2_ESTADO
		 	 	cClides   		:=SA1->A1_COD
		 	 	clojades  		:=SA1->A1_LOJA
		 	 	cNomedes  		:=SA1->A1_NOME
		 	 	cCepdes   		:=SA1->A1_CEP
		 	 	cEndDes   		:=SA1->A1_END
				cCgcdes   		:=SA1->A1_CGC
				cIndes    		:=SA1->A1_INSCR
				cBaides	  		:=SA1->A1_BAIRRO
				cEmades	  		:=SA1->A1_EMAIL
				cDDDES	  		:=SA1->A1_DDD
				cTeldes	  		:=SA1->A1_TEL
		 	 	
		 	 Elseif adados2[i][22] $ "T"
		 	 	cCodmunDes		:=ZA2->ZA2_CODIGO         
		 	 	cCodnomemundes	:=ZA2->ZA2_DESCRI
		 	 	cCodestdes		:=ZA2->ZA2_ESTADO
		 	 	cClides   		:=SA1->A1_COD
		 	 	clojades  		:=SA1->A1_LOJA
		 	 	cNomedes  		:=SA1->A1_NOME
		 	 	cCepdes   		:=SA1->A1_CEP
		 	 	cEndDes   		:=SA1->A1_END
				cCgcdes   		:=SA1->A1_CGC
				cIndes    		:=SA1->A1_INSCR
				cBaides	  		:=SA1->A1_BAIRRO
				cEmades	  		:=SA1->A1_EMAIL
				cDDDES	  		:=SA1->A1_DDD
				cTeldes	  		:=SA1->A1_TEL
		 	 	
		 	 else
		 	 	//Abro a SA1 para pegar os dados da GEFCO
		 	 	cCod   	:="026119"
		 	 	cLoja  	:="00" 
		 	 			 	 	
		 	 	DBSELECTAREA("SA1")
		 	 	SA1->(DBSETORDER(1))
		 	 	SA1->(DBSEEK(XFILIAL("SA1")+cCod+cLoja))
		 	 
		 	 	cCodmunDes		:="003912" // Fixo de guarulhos 
		 	 	cCodnomemundes	:="GUARULHOS"
		 	 	cCodestdes		:="SP"
		 	 	cClides   		:=SA1->A1_COD
		 	 	clojades  		:=SA1->A1_LOJA
		 	 	cNomedes  		:=SA1->A1_NOME
		 	 	cCepdes   		:=SA1->A1_CEP
		 	 	cEndDes   		:=SA1->A1_END
				cCgcdes   		:=SA1->A1_CGC
				cIndes    		:=SA1->A1_INSCR
				cBaides	  		:=SA1->A1_BAIRRO
				cEmades	  		:=SA1->A1_EMAIL
				cDDDES	  		:=SA1->A1_DDD
				cTeldes	  		:=SA1->A1_TEL

		 	 endif 
		 	 
		 	  IF cCodmunDes $ "003912" .or. adados2[i][22] $ "M" 
		 	 	cDescro:="GUARULHOS-SP X GUARULHOS-SP"
		 	 
		 	 ElseIf	adados2[i][22] $ "T" 
		 	 	cDescro:="GUARULHOS-SP X " +ALLTRIM(cNomeMundes)+"-"+cest2		 	 
		 	
		 	 ELSE		 	 	
		 	 	cDescro:=ALLTRIM(cNomeMunori)+"-"+cest+" X "+ALLTRIM(cNomeMundes)+"-"+cest2
		 	 endif
        
        
			// Concateno para gravar as observações na ZA7_OBS
		 cObsZA7+= "Endereço de Coleta: "+aDados2[i,6]  + CRLF
		 cObsZA7+= "Part Number: "+aDados2[i,12] + CRLF
		 cObsZA7+= "OC: "+aDados2[i,13] + CRLF
		 cObsZA7+= "Nota Fiscal: "+aDados2[i,15] + CRLF
		 cObsZA7+= "Rota: "+aDados2[i,20] + CRLF
		 
		 nQtdPre	 :=VAL(aDados2[i,14])
		 cQtdPre	 :=cvaltochar(nQtdPre)  
		 cQtdPre	 :=transform(cQtdPre,"@E 999")
		 nQtdPre	 :=VAL(cQtdPre)			
		 		  
		 nVrcarg	 :=Val(aDados2[i,16])
	     cVrcarg	 :=cvaltochar(nVrcarg) 
		 cVrcarg     :=transform(cVrcarg,"@E 999.999.999.99")
		 nVrcarg     :=Val(cVrcarg)
	 
		 nPeso	 	 :=VAL(aDados2[i,17]) 
		 cpeso		 :=cvaltochar(nPeso)
		 
		 IF "00" $ cPeso
		 	cpeso:=transform(cpeso,"@E 9.999")
			npeso:=VAL(cpeso)
		 else	
			cpeso:=transform(cpeso,"@E 999.999")
			npeso:=VAL(cpeso)
		 endif 
			 
		 nKmPrev  :=VAL(aDados2[i,18]) // Necessário Criar esse Campo 
         cKmPrev  :=cvaltochar(nKmPrev)
			 
        IF "00" $ cKmPrev
			 	cKmPrev:=transform(cKmPrev,"@E 999")
			 	nKmPrev:=VAL(cKmPrev)
	    else
			 	cKmPrev:=transform(cKmPrev,"@E 99")
			 	nKmPrev:=VAL(cKmPrev)	
		endif
		    
		//cChave:=ALLTRIM(aDados2[i,12])+ALLTRIM(Substr(aDados2[i,15],8,9))+cQtdPre
        
        DbSelectArea("ZA7")
		//ZA7->(dbSetOrder(5))
		ZA7->(DbSetOrder(6))
		//ZA7->(dbSeek(cChave))// Se achar eu apenas atualizo
		ZA7->(DbSeek(MV_PAR01+SubStr(MV_PAR02,1,22)+cRet+aDados2[i,7]+aDados2[i,8]))
		
		
		DBSELECTAREA("SA1")
    	DBSETORDER(3)    	
    	IF DBSEEK(XFILIAL("SA1")+adados2[i,7])  
	        cCliente    := SA1->A1_COD    // Cliente Origem
		    cLoja		:= SA1->A1_LOJA 
		    cmun		:= SA1->A1_COD_MUN //Usado para posicionar no ZA2 para o tipo de modelo 
			cest    	:= SA1->A1_EST
			cNomeMunori := SA1->A1_MUN
			cnome	    := SA1->A1_NOME			
		ENDIF    	
    		
    		DBSELECTAREA("SA1")
    		DBSETORDER(3)
    		IF DBSEEK(XFILIAL("SA1")+adados2[i,8])
				   
				cCliente2	:= SA1->A1_COD // Cliente Destino
		    	cLoja2	 	:= SA1->A1_LOJA
		    	cmun2	 	:= SA1->A1_COD_MUN //Usado para posicionar no ZA2 para o tipo de modelo destino  
		    	cest2    	:= SA1->A1_EST
		    	cNomeMundes := SA1->A1_MUN
		    endif	     
		    
        IF !EMPTY(ZA7->ZA7_PROJET)
			Reclock("ZA7",.F.)
			ZA7->ZA7_EHTERC  :='S' 
			ZA7->ZA7_RESPC   :='C' 
			ZA7->ZA7_RESPD   :='C' 
			ZA7->ZA7_TPCARD	 :='H'
			ZA7->ZA7_QTD	 :=1
			ZA7->ZA7_DEVEMB	 :='P'
			ZA7->ZA7_DTCAR   :=CTOD(adados2[i,2])
			ZA7->ZA7_DTDES   :=CTOD(adados2[i,2])
			ZA7->ZA7_DESCLI	 :=cNome
			//ZA7->ZA7_DESMUN  :=SA1->A1_MUN
			ZA7->ZA7_FILREG	 :=MV_PAR01
			ZA7->ZA7_ADICIO	 :='N'
			ZA7->ZA7_TIPDES	 :='O'
			ZA7->ZA7_EMERGE  :='N'
			ZA7->ZA7_EMERG2  :='N'
			ZA7->ZA7_NOMDES  :=SA1->A1_NOME
			ZA7->ZA7_PICKIN  :='N'			 
			ZA7->ZA7_HRCAR	 :=STRTRAN(aDados2[i,3],":","")	   
			ZA7->ZA7_HRDES	 :=STRTRAN(aDados2[i,5],":","")
			ZA7->ZA7_OBS	 :=cobsZA7
			ZA7->ZA7_CODCLI	 :=cCliente
			ZA7->ZA7_LOJCLI	 :=cLoja
			ZA7->ZA7_CLIDES	 :=cCliente2
			ZA7->ZA7_LOJDES	 :=cLoja2
			//ZA7->ZA7_QTDPRE	 :=nQtdPre
			//ZA7->ZA7_VRCARG	 :=nVrCarg
			//ZA7->ZA7_PESO	 :=nPeso
			//ZA7->ZA7_KMPREV  :=nKmPrev // Necessário Criar esse Campo 
			ZA7->ZA7_PARTNU  :=ALLTRIM(aDados2[i,12])+ALLTRIM(Substr(aDados2[i,15],8,9))+cQtdPre     // Necessário Criar esse Campo - junto Partnu mais quantidade
			ZA7->ZA7_SKMVEN  :=aDados2[i][23]
			ZA7->ZA7_SKMCOM  :=aDados2[i][24]
			ZA7->ZA7_VALADV  :=nPadv
			ZA7->ZA7_CARENC  :=nFranqc
			ZA7->ZA7_CAREND  :=nFranqu			
			ZA7->ZA7_CGCORI  :=aDados2[i][7]
			ZA7->ZA7_CGCDES  :=aDados2[i][8]
			ZA7->(MSUNLOCK())
			cObsZA7:="" + CRLF
			cObsZA7:="" + CRLF
			cObsZA7:="" + CRLF
			cObsZA7:="" + CRLF
			cObsZA7:="" + CRLF
		else 
			
			// crio a nova sequencia  ZA7
			 IF Select("TRBMAX") > 0
				TRBMAX->( DbCloseArea() )
			EndIf			
			
			csql:="SELECT MAX(ZA7_SEQCAR)+1 SEQCAR FROM "+RETSQLNAME("ZA7")+" ZA7" +CRLF
			csql+=" WHERE ZA7_PROJET= '"+SubStr(MV_PAR02,1,22)+"'"
			csql+=" AND ZA7_FILIAL= '"+MV_PAR01+"'"
			csql+=" AND ZA7_OBRA= '"+cRet+"'"				 
			csql+=" AND D_E_L_E_T_ = '' "
			PLSQUERY(csql,"TRBMAX")
			
			IF EMPTY(TRBMAX->SEQCAR)
				cSeqCar:='001'
				cSeqcol:='01'
			Else   	
				cSeqCar:=StrZero(TRBMAX->SEQCAR,3)
				cseqCol:= StrZero(TRBMAX->SEQCAR,2)	  
			Endif	
			
			nQtdPre	 :=VAL(aDados2[i,14])
			cQtdPre	 :=cvaltochar(nQtdPre)  
			cQtdPre	 :=transform(cQtdPre,"@E 999")
			nQtdPre	 :=VAL(cQtdPre)			
		 	 			
		    nVrcarg	 :=Val(aDados2[i,16])
		 	cVrcarg	 :=cvaltochar(nVrcarg) 
		 	cVrcarg  :=transform(cVrcarg,"@E 999.999.999.99")
		 	nVrcarg  :=Val(cVrcarg)
 
			nPeso	 :=VAL(aDados2[i,17]) 
			cpeso	 :=cvaltochar(nPeso)
			
			IF "00" $ cPeso
				cpeso:=transform(cpeso,"@E 9.999")
			 	npeso:=VAL(cpeso)
			else	
			    cpeso:=transform(cpeso,"@E 999.999")
			    npeso:=VAL(cpeso)
			endif 
			 
			nKmPrev  :=VAL(aDados2[i,18]) // Necessário Criar esse Campo 
			cKmPrev	 :=cvaltochar(nKmPrev)
			 
			IF "00" $ cKmPrev
			 	cKmPrev:=transform(cKmPrev,"@E 999")
			 	nKmPrev:=VAL(cKmPrev)
			else
			 	cKmPrev:=transform(cKmPrev,"@E 99")
			 	nKmPrev:=VAL(cKmPrev)	
		    endif

			// Aglutinação caso ja existe o registro senão existir grava normalmente
        	DbSelectArea("ZA7")
			ZA7->(DbSetOrder(6))
			If  ZA7->(!DbSeek(MV_PAR01+SubStr(MV_PAR02,1,22)+cRet+aDados2[i,7]+aDados2[i,8]))
				    	    			
				Reclock("ZA7",.T.)
				ZA7->ZA7_FILIAL  :=MV_PAR01			
				ZA7->ZA7_PROJET  :=SubStr(MV_PAR02,1,22)
				ZA7->ZA7_OBRA    :=cret
				ZA7->ZA7_SEQTRA  :=cret
				ZA7->ZA7_SEQCAR  :=cSeqcar			
				ZA7->ZA7_DTCAR   :=CTOD(adados2[i,2])
				ZA7->ZA7_DTDES   :=CTOD(adados2[i,2])
				ZA7->ZA7_CARGA   :='P'
				ZA7->ZA7_QUANT   :='1'
				ZA7->ZA7_TIPCAR  :='H'
				ZA7->ZA7_INCADV  :=ZA0->ZA0_FORMAS  
				ZA7->ZA7_FORMAS  :='1'
				If i = 1
					ZA7->ZA7_JUNTO   :=""
				else
					ZA7->ZA7_JUNTO   :="001"
				endif
				ZA7->ZA7_EHTERC  :='S' 
				ZA7->ZA7_RESPC   :='C' 
				ZA7->ZA7_RESPD   :='C' 
				ZA7->ZA7_TPCARD	 :='H'
				ZA7->ZA7_QTD	 :=1
				ZA7->ZA7_DEVEMB	 :='P'
				ZA7->ZA7_DESCLI	 :=cNome			
				ZA7->ZA7_MUNICI  :=Posicione("ZA2",4,XFILIAL("ZA2")+cmun+cEst,"ZA2_CODIGO")//cCodmunori//cmun
				ZA7->ZA7_DESMUN  :=cNomeMunori
				ZA7->ZA7_FILREG	 :=MV_PAR01
				ZA7->ZA7_ADICIO	 :='N'
				ZA7->ZA7_TIPDES	 :='O'
				ZA7->ZA7_EMERGE  :='N'
				ZA7->ZA7_EMERG2  :='N'
				ZA7->ZA7_NOMDES  :=SA1->A1_NOME
				If lMilkRun = .T.
					ZA7->ZA7_SEQCOL	 :=cSeqcol
				Endif
				ZA7->ZA7_PICKIN  :='N'			 
				ZA7->ZA7_HRCAR	 :=STRTRAN(aDados2[i,3],":","")	   
				ZA7->ZA7_HRDES	 :=STRTRAN(aDados2[i,5],":","")
				ZA7->ZA7_OBS	 :=cobsZA7
				ZA7->ZA7_CODCLI	 :=cCliente
				ZA7->ZA7_LOJCLI	 :=cLoja
				ZA7->ZA7_CLIDES	 :=cCliente2
				ZA7->ZA7_LOJDES	 :=cLoja2
				ZA7->ZA7_QTDPRE	 :=nQtdPre
				ZA7->ZA7_VRCARG	 :=nVrCarg
				ZA7->ZA7_PESO	 :=nPeso
				ZA7->ZA7_KMPREV  :=nKmPrev // Necessário Criar esse Campo 
				ZA7->ZA7_PARTNU  :=ALLTRIM(aDados2[i,12])+ALLTRIM(Substr(aDados2[i,15],8,9))+cQtdPre      // Necessário Criar esse Campo      
				ZA7->ZA7_UFCARG  :=cest//cUfcarga
				ZA7->ZA7_SKMVEN  :=aDados2[i][23]
				ZA7->ZA7_SKMCOM  :=aDados2[i][24]
				ZA7->ZA7_VALADV  :=nPadv
				ZA7->ZA7_CARENC  :=nFranqc
				ZA7->ZA7_CAREND  :=nFranqu
				ZA7->ZA7_PEDCLI  :=aDados2[i,1]
				ZA7->ZA7_CGCORI  :=aDados2[i][7]
				ZA7->ZA7_CGCDES  :=aDados2[i][8]
				ZA7->(MSUNLOCK())
				ZA7->(dbclearFilter()) 
				cObsZA7:="" + CRLF
				cObsZA7:="" + CRLF
				cObsZA7:="" + CRLF
				cObsZA7:="" + CRLF
				cObsZA7:="" + CRLF
			Else 
				nQtdPre:=ZA7->ZA7_QTDPRE+nQtdPre
				nVrCarg:=ZA7->ZA7_VRCARG+nVrCarg
				nPeso  :=ZA7->ZA7_PESO+nPeso
				nKmPrev:=ZA7->ZA7_KMPREV+nKmPrev 
				
				Reclock("ZA7",.F.)
				ZA7->ZA7_QTDPRE	 :=nQtdPre
				ZA7->ZA7_VRCARG	 :=nVrCarg
				ZA7->ZA7_PESO	 :=nPeso
				ZA7->ZA7_KMPREV  :=nKmPrev // Necessário Criar esse Campo
				ZA7->(MSUNLOCK()) 
				
				cObsZA7:="" + CRLF
				cObsZA7:="" + CRLF
				cObsZA7:="" + CRLF
				cObsZA7:="" + CRLF
				cObsZA7:="" + CRLF
			EndIF
		EndIf
				
		dbSelectArea("ZA6")
		cNumSolic:=aDados2[i][1] + Space(5)
		ZA6->(Dbsetorder(6))
		ZA6->(Dbseek(MV_PAR01+cNumSolic+MV_PAR02))
				
        IF !EMPTY(ZA6->ZA6_PROJET) .and. lZA6 = .T.// Se eu achar eu apenas atualizo
			
			Reclock("ZA6",.F.)
			ZA6->ZA6_DTINI   :=CTOD(adados2[i,2])
			ZA6->ZA6_DTFIM   :=CTOD(adados2[i,2])
			ZA6->ZA6_HRMAIL  :=adados2[i,4] 	// Necessario criar esse campo
			ZA6->ZA6_CGCT	 :=adados2[i,9]  	//  Necessario criar esse campo
			ZA6->ZA6_TRANSP  :=cCodvei		
			ZA6->ZA6_DESTRA  :=cDesVei
			ZA6->ZA6_CGCTOMA :=adados2[i,21] 	// Necessario criar esse campo
			ZA6->ZA6_CLIDES	 :=cClides
			ZA6->ZA6_LOJDES	 :=cLojaDes
			ZA6->ZA6_MUNDE2	 :=cCodnomemundes//SA1->A1_MUN 
			ZA6->ZA6_NOMDES	 :=cNomedes
			ZA6->ZA6_ENDDES	 :=cEnddes
			ZA6->ZA6_CGCDES	 :=cCgcdes
			ZA6->ZA6_INSDES	 :=cIndes
			ZA6->ZA6_BAIDES	 :=cBaides
			ZA6->ZA6_ESTDE2	 :=cCodestdes//SA1->A1_EST
			ZA6->ZA6_CEPDES	 :=cCepDes
			ZA6->ZA6_EMADES	 :=cEmades
			ZA6->ZA6_DDDDES	 :=cDDDES
			ZA6->ZA6_TELDES	 :=cTeldes
			ZA6->ZA6_CONPAG  :=ZA0->ZA0_CONPAG
			ZA6->ZA6_TIPPAG  :=ZA0->ZA0_TIPPAG 
			ZA6->ZA6_TPTRAC  :='N' //Pedrassi
			ZA6->ZA6_TPTRAN  :='N'
			ZA6->ZA6_TPFRET  :=ZA0->ZA0_TPFRET
			ZA6->ZA6_EMERGE  :='N'
			ZA6->ZA6_EMERG2  :='N'
			If lMilkRun = .T.		
				ZA6->ZA6_TIPFLU  :='C'
			Else
				ZA6->ZA6_TIPFLU  :='I'			
			Endif				 	
			ZA6->ZA6_TIPDES  :='O'
			ZA6->ZA6_FERIAC  :='N'
			ZA6->ZA6_FERIAV  :='N'
			ZA6->ZA6_ORIGEM	 :=cCodmunori
			IF adados2[i][22] $ "T|M"
				ZA6->ZA6_MUNORI	 :="GUARULHOS"
			Else	
				ZA6->ZA6_MUNORI  :=Posicione("ZA2",1,XFILIAL("ZA2")+cCodmunori,"ZA2_DESCRI")
			Endif				
			ZA6->ZA6_ESTORI	 :=cCodestori	
			ZA6->ZA6_DESTIN	 :=cCodmundes 
			ZA6->ZA6_MUNDES	 :=cCodnomemundes
			ZA6->ZA6_ESTDES	 :=cCodestdes	
			ZA6->ZA6_CLIORI  :=cCliori
		 	ZA6->ZA6_LOJORI  :=clojaori
		 	ZA6->ZA6_NOMORI  :=cNomeori
		 	ZA6->ZA6_CEPORI  :=cCepori		 	 			
			ZA6->ZA6_DESCRO  :=cDescro
			ZA6->ZA6_MODELO  :=aDados2[i,22]
			ZA6->ZA6_TABVEN  :=cTabVen	
			ZA6->ZA6_VERVEN  :=cVerTab
			ZA6->ZA6_ITTABV  :=cIttabv
			ZA6->ZA6_TABCOM  :=cTabCom
			ZA6->ZA6_VERCOM  :=cVerCom 
			ZA6->ZA6_ITTABC  :=cIttCom				
			ZA6->(MSUNLOCK())     
			
			// Atualiza os km da viagem no caso de ser um FTL
			FTL()
			
			lZA6:=.F.
			
		else   
					
		IF lZA6 = .T.  
			 
			Reclock("ZA6",.T.)
			ZA6->ZA6_FILIAL  :=MV_PAR01 
			ZA6->ZA6_PROJET  :=SubStr(MV_PAR02,1,22)		
			ZA6->ZA6_OBRA  	 :=cRet
			ZA6->ZA6_SEQTRA	 :=cRet			
			ZA6->ZA6_PEDCLI  :=adados2[i,1]
			ZA6->ZA6_DTINI   :=CTOD(adados2[i,2])
			ZA6->ZA6_DTFIM   :=CTOD(adados2[i,2])
			ZA6->ZA6_HRMAIL  :=adados2[i,4] 	// Necessario criar esse campo
			ZA6->ZA6_CGCT	 :=adados2[i,9]  //  Necessario criar esse campo
			ZA6->ZA6_TRANSP  :=cCodvei		
			ZA6->ZA6_DESTRA  :=cDesVei
			ZA6->ZA6_CGCTOMA :=adados2[i,21] // Necessario criar esse campo
			ZA6->ZA6_CLIDES	 :=cClides
			ZA6->ZA6_LOJDES	 :=cLojaDes
			ZA6->ZA6_MUNDE2	 :=cCodnomemundes//SA1->A1_MUN 
			ZA6->ZA6_NOMDES	 :=cNomedes
			ZA6->ZA6_ENDDES	 :=cEnddes
			ZA6->ZA6_CGCDES	 :=cCgcdes
			ZA6->ZA6_INSDES	 :=cIndes
			ZA6->ZA6_BAIDES	 :=cBaides
			ZA6->ZA6_ESTDE2	 :=cCodestdes//SA1->A1_EST
			ZA6->ZA6_CEPDES	 :=cCepDes
			ZA6->ZA6_EMADES	 :=cEmades
			ZA6->ZA6_DDDDES	 :=cDDDES
			ZA6->ZA6_TELDES	 :=cTeldes
			ZA6->ZA6_CONPAG  :=ZA0->ZA0_CONPAG
			ZA6->ZA6_TIPPAG  :=ZA0->ZA0_TIPPAG 
			ZA6->ZA6_TPTRAC  :='N' //Pedrassi
			ZA6->ZA6_TPTRAN  :='N'
			ZA6->ZA6_TPFRET  :=ZA0->ZA0_TPFRET
			ZA6->ZA6_EMERGE  :='N'
			ZA6->ZA6_EMERG2  :='N'
			If lMilkRun = .T.		
				ZA6->ZA6_TIPFLU  :='C'				
			Else
				ZA6->ZA6_TIPFLU  :='I'				
			Endif
			ZA6->ZA6_TIPDES  :='O'
			ZA6->ZA6_FERIAC  :='N'
			ZA6->ZA6_FERIAV  :='N'
			ZA6->ZA6_ORIGEM	 :=cCodmunori    
			IF adados2[i][22] $ "T|M"
				ZA6->ZA6_MUNORI	 :="GUARULHOS"
			Else	
				ZA6->ZA6_MUNORI  :=Posicione("ZA2",1,XFILIAL("ZA2")+cCodmunori,"ZA2_DESCRI")//cCodnomemunori 
			Endif				
			ZA6->ZA6_ESTORI	 :=cCodestori					 	 	
			ZA6->ZA6_DESTIN	 :=cCodmundes 
			ZA6->ZA6_MUNDES	 :=cCodnomemundes
			ZA6->ZA6_ESTDES	 :=cCodestdes	
			ZA6->ZA6_CLIORI  :=cCliori
		 	ZA6->ZA6_LOJORI  :=clojaori
		 	ZA6->ZA6_NOMORI  :=cNomeori
		 	ZA6->ZA6_CEPORI  :=cCepori		 	 			
			ZA6->ZA6_DESCRO  :=cDescro
			ZA6->ZA6_MODELO  :=aDados2[i,22]					
			ZA6->ZA6_TIPLKM  :='N'
			ZA6->ZA6_TABVEN  :=cTabVen
			ZA6->ZA6_VERVEN  :=cVerTab
			ZA6->ZA6_ITTABV  :=cIttabv
			ZA6->ZA6_TABCOM  :=cTabCom
			ZA6->ZA6_VERCOM  :=cVerCom 
			ZA6->ZA6_ITTABC  :=cIttCom		
			ZA6->(MSUNLOCK())
			
			// Atualiza os km da viagem no caso de ser um FTL
			FTL()

			
			ZA6->(dbclearFilter())	
		    
		    lZA6:=.F.
		
		endif
		
		endif
		
		
	DBSKIP()
	EndDo
End Transaction
	 
	FT_FUSE()
	 
	MsgInfo("A atualização dos dados foi executada!","[IMPFIAT] - SUCESSO")
		 
	 else
	 
	   	Return // Caso eu clico no não ele sai fora do processo
	 
	 endif
	 
endif	     

IF lImporta = .T. // Será sempre verdadeiro quando não houver atualizaçao dos dados

Begin Transaction
	
	// crio a nova sequencia para a obra ZA6
	        IF Select("TRBMAX") > 0
				TRBMAX->( DbCloseArea() )
			EndIf			
			
			csql:="SELECT MAX(ZA6_OBRA)+1 SEQ FROM "+RETSQLNAME("ZA6")+" ZA6" +CRLF
			csql+=" WHERE ZA6_PROJET= '"+SubStr(MV_PAR02,1,22)+"'" 
			csql+=" AND   ZA6_FILIAL= '"+MV_PAR01+"'"
			csql+=" AND D_E_L_E_T_ = '' "
			PLSQUERY(csql,"TRBMAX")
			
			IF EMPTY(TRBMAX->SEQ)
				cRet:='001'
			Else   	
				cRet:=StrZero(TRBMAX->SEQ,3)				
			Endif
	
	ProcRegua(Len(aDados2))
	I:=0		
	while I < LEN(aDados2) 
		
		i++
		IncProc("Gravando registros")
          	 
			//Abro a ZA0 para pegar o cliente e loja que irei usar como busca na SA1//
	
			DBSELECTAREA("ZA0")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("ZA0")+SubStr(MV_PAR02,1,22))  
			
				DBSELECTAREA("SA1")
				DBSETORDER(3)
				DBSEEK(XFILIAL("SA1")+ adados2[i][7])  
			
				//DBSEEK(XFILIAL("SA1")+ZA0->ZA0_CLI+ZA0->ZA0_LOJA)  
			
			// Posiciono na ZA2 para pegar o devido código de município de origem//
		 	 DBSELECTAREA("ZA2")
		 	 DBSETORDER(4)
		 	 IF DBSEEK(XFILIAL("ZA2")+cmun+cest) .and. adados2[i][22] $ "6" // So fara essa tratativa se o modelo for 6 ou T se for modelo M deve vincular dados como Guarulhos
		 	 	cCodmunori	  :=ZA2->ZA2_CODIGO
		 	 	cCodnomemunori:=ZA2->ZA2_DESCRI
		 	 	cCodestori	  :=ZA2->ZA2_ESTADO
		 	 	cCliori:=SA1->A1_COD
		 	 	clojaori:=SA1->A1_LOJA 
		 	 	cNomeori:=SA1->A1_NOME
		 	 	cCepori:=SA1->A1_CEP
		 	 			 	 			 	 			 	
		 	 elseif adados2[i][22] $ "T|M"
		 	    cCodmunori	  := "003912" // Fixo de guarulhos 
		 	 	cCodestori	  :="SP" 
		 	 	//Abro a SA1 para pegar os dados da GEFCO
		 	 	cCod   	:="026119"
		 	 	cLoja  	:="00" 
		 	 			 	 	
		 	 	DBSELECTAREA("SA1")
		 	 	SA1->(DBSETORDER(1))
		 	 	SA1->(DBSEEK(XFILIAL("SA1")+cCod+cLoja))
		 	  	cCliori	      :=SA1->A1_COD
		 	 	clojaori	  :=SA1->A1_LOJA 
		 	 	cNomeori	  :=SA1->A1_NOME
		 	 	cCepori	      :=SA1->A1_CEP

		 	 endif 
		 	 DBSELECTAREA("SA1")
    		 DBSETORDER(3)
    		 DBSEEK(XFILIAL("SA1")+adados2[i,8])
			
		// Posiciono na ZA2 para pegar o devido código de município de Destino//
		 	 DBSELECTAREA("ZA2")
		 	 DBSETORDER(4)
		 	 IF DBSEEK(XFILIAL("ZA2")+cmun2+cest2) .and. adados2[i][22] $ "6" // So fara essa tratativa se o modelo for 6 ou T se for M fixará como Guarulhos
		 	 	cCodmunDes		:=ZA2->ZA2_CODIGO         
		 	 	cCodnomemundes	:=ZA2->ZA2_DESCRI
		 	 	cCodestdes		:=ZA2->ZA2_ESTADO
		 	 	cClides   		:=SA1->A1_COD
		 	 	clojades  		:=SA1->A1_LOJA
		 	 	cNomedes  		:=SA1->A1_NOME
		 	 	cCepdes   		:=SA1->A1_CEP
		 	 	cEndDes   		:=SA1->A1_END
				cCgcdes   		:=SA1->A1_CGC
				cIndes    		:=SA1->A1_INSCR
				cBaides	  		:=SA1->A1_BAIRRO
				cEmades	  		:=SA1->A1_EMAIL
				cDDDES	  		:=SA1->A1_DDD
				cTeldes	  		:=SA1->A1_TEL
		 	 	
		 	 Elseif adados2[i][22] $ "T"
		 	 	cCodmunDes		:=ZA2->ZA2_CODIGO         
		 	 	cCodnomemundes	:=ZA2->ZA2_DESCRI
		 	 	cCodestdes		:=ZA2->ZA2_ESTADO
		 	 	cClides   		:=SA1->A1_COD
		 	 	clojades  		:=SA1->A1_LOJA
		 	 	cNomedes  		:=SA1->A1_NOME
		 	 	cCepdes   		:=SA1->A1_CEP
		 	 	cEndDes   		:=SA1->A1_END
				cCgcdes   		:=SA1->A1_CGC
				cIndes    		:=SA1->A1_INSCR
				cBaides	  		:=SA1->A1_BAIRRO
				cEmades	  		:=SA1->A1_EMAIL
				cDDDES	  		:=SA1->A1_DDD
				cTeldes	  		:=SA1->A1_TEL
		 	 	
		 	 else
		 	 	
		 	 	//Abro a SA1 para pegar os dados da GEFCO
		 	 	cCod   	:="026119"
		 	 	cLoja  	:="00" 
		 	 			 	 	
		 	 	DBSELECTAREA("SA1")
		 	 	SA1->(DBSETORDER(1))
		 	 	SA1->(DBSEEK(XFILIAL("SA1")+cCod+cLoja))
		 	 
		 	 	cCodmunDes		:= "003912" // Fixo de guarulhos 
		 	 	cCodnomemundes	:="GUARULHOS"
		 	 	cCodestdes		:="SP"
		 	 	cClides   		:=SA1->A1_COD
		 	 	clojades  		:=SA1->A1_LOJA
		 	 	cNomedes  		:=SA1->A1_NOME
		 	 	cCepdes   		:=SA1->A1_CEP
		 	 	cEndDes   		:=SA1->A1_END
				cCgcdes   		:=SA1->A1_CGC
				cIndes    		:=SA1->A1_INSCR
				cBaides	  		:=SA1->A1_BAIRRO
				cEmades	  		:=SA1->A1_EMAIL
				cDDDES	  		:=SA1->A1_DDD
				cTeldes	  		:=SA1->A1_TEL
		 	 
		 	 endif 
		 	 
		 	 IF cCodmunDes $ "003912" .or. adados2[i][22] $ "M" 
		 	 	cDescro:="GUARULHOS-SP X GUARULHOS-SP"
		 	 
		 	 ElseIf	adados2[i][22] $ "T" 
		 	 	cDescro:="GUARULHOS-SP X " +ALLTRIM(cNomeMundes)+"-"+cest2		 	 
		 	
		 	 ELSE		 	 	
		 	 	cDescro:=ALLTRIM(cNomeMunori)+"-"+cest+" X "+ALLTRIM(cNomeMundes)+"-"+cest2
		 	 endif
        		 	
		endif        	
          	
			// crio a nova sequencia  ZA7
			 IF Select("TRBMAX") > 0
				TRBMAX->( DbCloseArea() )
			EndIf			
			
			csql:="SELECT MAX(ZA7_SEQCAR)+1 SEQCAR FROM "+RETSQLNAME("ZA7")+" ZA7" +CRLF
			csql+=" WHERE ZA7_PROJET= '"+SubStr(MV_PAR02,1,22)+"'"
			csql+=" AND ZA7_FILIAL= '"+MV_PAR01+"'"
			csql+=" AND ZA7_OBRA= '"+cRet+"'"				 
			csql+=" AND D_E_L_E_T_ = '' "
			PLSQUERY(csql,"TRBMAX")
				                           			
			IF EMPTY(TRBMAX->SEQCAR)
				cSeqCar:='001'
				cSeqCol:='01'
			Else   	
				cSeqCar:=StrZero(TRBMAX->SEQCAR,3)
				cseqCol:= StrZero(TRBMAX->SEQCAR,2)	  
			Endif	
				
			// Concateno para gravar as observações na ZA7_OBS
		 cObsZA7+= "Endereço de Coleta: "+aDados2[i,6]  + CRLF
		 cObsZA7+= "Part Number: "+aDados2[i,12] + CRLF
		 cObsZA7+= "OC: "+aDados2[i,13] + CRLF
		 cObsZA7+= "Nota Fiscal: "+aDados2[i,15] + CRLF
		 cObsZA7+= "Rota: "+aDados2[i,20] + CRLF
		 				
			 nQtdPre	 :=VAL(aDados2[i,14])
			 cQtdPre	 :=cvaltochar(nQtdPre)  
			 cQtdPre	 :=transform(cQtdPre,"@E 999")
			 nQtdPre	 :=VAL(cQtdPre)			
		 	 
		 	 nVrcarg	 :=Val(aDados2[i,16])
		 	 cVrcarg	 :=cvaltochar(nVrcarg) 
		 	 cVrcarg     :=transform(cVrcarg,"@E 999.999.999.99")
		 	 nVrcarg     :=Val(cVrcarg)
		 	  
			 nPeso	 	 :=VAL(aDados2[i,17]) 
			 cpeso		 :=cvaltochar(nPeso)
			
			 IF "00" $ cPeso
			 	cpeso:=transform(cpeso,"@E 9.999")
			 	npeso:=VAL(cpeso)
			 else	
			    cpeso:=transform(cpeso,"@E 999.999")
			    npeso:=VAL(cpeso)
			 endif 

			 nKmPrev     :=VAL(aDados2[i,18]) // Necessário Criar esse Campo 
		     cKmPrev	 :=cvaltochar(nKmPrev)
			 
			 IF "00" $ cKmPrev
			 	cKmPrev:=transform(cKmPrev,"@E 999")
			 	nKmPrev:=VAL(cKmPrev)
			 else
			 	cKmPrev:=transform(cKmPrev,"@E 99")
			 	nKmPrev:=VAL(cKmPrev)	
			 endif
		    
		DBSELECTAREA("SA1")
    	DBSETORDER(3)    	
    	IF DBSEEK(XFILIAL("SA1")+adados2[i,7])  
	        cCliente    := SA1->A1_COD    // Cliente Origem
		    cLoja		:= SA1->A1_LOJA 
		    cmun		:= SA1->A1_COD_MUN //Usado para posicionar no ZA2 para o tipo de modelo 
			cest    	:= SA1->A1_EST
			cNomeMunori := SA1->A1_MUN
			cnome	    := SA1->A1_NOME			
		ENDIF    	
    		
    		DBSELECTAREA("SA1")
    		DBSETORDER(3)
    		IF DBSEEK(XFILIAL("SA1")+adados2[i,8])
				   
				cCliente2	:= SA1->A1_COD // Cliente Destino
		    	cLoja2	 	:= SA1->A1_LOJA
		    	cmun2	 	:= SA1->A1_COD_MUN //Usado para posicionar no ZA2 para o tipo de modelo destino  
		    	cest2    	:= SA1->A1_EST
		    	cNomeMundes := SA1->A1_MUN
		    endif	     
		    			
        	// Aglutinação caso ja existe o registro senão existir grava normalmente
        	DbSelectArea("ZA7")
			ZA7->(DbSetOrder(6))
		IF  ZA7->(!DbSeek(MV_PAR01+SubStr(MV_PAR02,1,22)+cRet+aDados2[i,7]+aDados2[i,8]))
		
			Reclock("ZA7",.T.)
			ZA7->ZA7_FILIAL  :=MV_PAR01			
			ZA7->ZA7_PROJET  :=SubStr(MV_PAR02,1,22)
			ZA7->ZA7_OBRA    :=cret
			ZA7->ZA7_SEQTRA  :=cret
			ZA7->ZA7_SEQCAR  :=cSeqcar			
			ZA7->ZA7_DTCAR   :=CTOD(adados2[i,2])
			ZA7->ZA7_DTDES   :=CTOD(adados2[i,2])
			ZA7->ZA7_CARGA   :='P'
			ZA7->ZA7_QUANT   :='1'
			ZA7->ZA7_TIPCAR  :='H'
			ZA7->ZA7_INCADV  :=ZA0->ZA0_FORMAS  
			ZA7->ZA7_FORMAS  :='1'
		If i = 1
			ZA7->ZA7_JUNTO   :=""
		Else
			ZA7->ZA7_JUNTO   :="001"
		Endif
			ZA7->ZA7_EHTERC  :='S' 
			ZA7->ZA7_RESPC   :='C' 
			ZA7->ZA7_RESPD   :='C' 
			ZA7->ZA7_TPCARD	 :='H'
			ZA7->ZA7_QTD	 :=1
			ZA7->ZA7_DEVEMB	 :='P'
			ZA7->ZA7_DESCLI	 :=cnome
			ZA7->ZA7_MUNICI  :=Posicione("ZA2",4,XFILIAL("ZA2")+cmun+cEst,"ZA2_CODIGO")
			ZA7->ZA7_DESMUN  :=cNomeMunori
			ZA7->ZA7_FILREG	 :=MV_PAR01
			ZA7->ZA7_ADICIO	 :='N'
			ZA7->ZA7_TIPDES	 :='O'
			ZA7->ZA7_EMERGE  :='N'
			ZA7->ZA7_EMERG2  :='N'
			ZA7->ZA7_NOMDES  :=SA1->A1_NOME
		If lMilkRun = .T.
			ZA7->ZA7_SEQCOL	 :=cSeqcol
		Endif
			ZA7->ZA7_PICKIN  :='N'			 
			ZA7->ZA7_HRCAR	 :=STRTRAN(aDados2[i,3],":","")	   
			ZA7->ZA7_HRDES	 :=STRTRAN(aDados2[i,5],":","")
			ZA7->ZA7_OBS	 :=cobsZA7
			ZA7->ZA7_CODCLI	 :=cCliente
			ZA7->ZA7_LOJCLI	 :=cLoja
			ZA7->ZA7_CLIDES	 :=cCliente2
			ZA7->ZA7_LOJDES	 :=cLoja2
			ZA7->ZA7_QTDPRE	 :=nQtdPre
			ZA7->ZA7_VRCARG	 :=nVrCarg
			ZA7->ZA7_PESO	 :=nPeso
			ZA7->ZA7_KMPREV  :=nKmPrev // Necessário Criar esse Campo 
			ZA7->ZA7_PARTNU  :=ALLTRIM(aDados2[i,12])+ALLTRIM(Substr(aDados2[i,15],8,9))+cQtdPre    // Necessário Criar esse Campo   
			ZA7->ZA7_UFCARG  :=cest//cUfcarga   
			ZA7->ZA7_SKMVEN  :=aDados2[i][23]
			ZA7->ZA7_SKMCOM  :=aDados2[i][24]
			ZA7->ZA7_VALADV  :=nPadv
			ZA7->ZA7_CARENC  :=nFranqc
			ZA7->ZA7_CAREND  :=nFranqu
			ZA7->ZA7_PEDCLI  :=aDados2[i,1]				
			ZA7->ZA7_CGCORI  :=aDados2[i][7]
			ZA7->ZA7_CGCDES  :=aDados2[i][8]
			ZA7->(MSUNLOCK())
			cObsZA7:="" + CRLF
			cObsZA7:="" + CRLF
			cObsZA7:="" + CRLF
			cObsZA7:="" + CRLF
			cObsZA7:="" + CRLF
		Else 
			nQtdPre:=ZA7->ZA7_QTDPRE+nQtdPre
			nVrCarg:=ZA7->ZA7_VRCARG+nVrCarg
			nPeso  :=ZA7->ZA7_PESO+nPeso
			nKmPrev:=ZA7->ZA7_KMPREV+nKmPrev 
			
			Reclock("ZA7",.F.)
			ZA7->ZA7_QTDPRE	 :=nQtdPre
			ZA7->ZA7_VRCARG	 :=nVrCarg
			ZA7->ZA7_PESO	 :=nPeso
			ZA7->ZA7_KMPREV  :=nKmPrev // Necessário Criar esse Campo
			ZA7->(MSUNLOCK()) 
			
			cObsZA7:="" + CRLF
			cObsZA7:="" + CRLF
			cObsZA7:="" + CRLF
			cObsZA7:="" + CRLF
			cObsZA7:="" + CRLF
		Endif 	
	   
			IF lZA6 = .T. 
			     			     
				Reclock("ZA6",.T.)
				ZA6->ZA6_FILIAL  :=MV_PAR01 
				ZA6->ZA6_PROJET  :=SubStr(MV_PAR02,1,22)		
				ZA6->ZA6_OBRA  	 :=cRet
				ZA6->ZA6_SEQTRA	 :=cRet			
				ZA6->ZA6_PEDCLI  :=aDados2[i,1]
				ZA6->ZA6_DTINI   :=CTOD(aDados2[i,2])
				ZA6->ZA6_DTFIM   :=CTOD(aDados2[i,2])
				ZA6->ZA6_HRMAIL  :=aDados2[i,4] 	// Necessario criar esse campo
				ZA6->ZA6_CGCT	 :=aDados2[i,9]  //  Necessario criar esse campo
				ZA6->ZA6_TRANSP  :=cCodvei
				ZA6->ZA6_DESTRA  :=cDesVei
				ZA6->ZA6_CGCTOMA :=aDados2[i,21] // Necessario criar esse campo
				ZA6->ZA6_CLIDES	 :=cClides
				ZA6->ZA6_LOJDES	 :=cLojaDes
				ZA6->ZA6_MUNDE2	 :=cCodnomemundes//SA1->A1_MUN 
				ZA6->ZA6_NOMDES	 :=cNomedes
				ZA6->ZA6_ENDDES	 :=cEnddes
				ZA6->ZA6_CGCDES	 :=cCgcdes
				ZA6->ZA6_INSDES	 :=cIndes
				ZA6->ZA6_BAIDES	 :=cBaides
				ZA6->ZA6_ESTDE2	 :=cCodestdes//SA1->A1_EST
				ZA6->ZA6_CEPDES	 :=cCepDes
				ZA6->ZA6_EMADES	 :=cEmades
				ZA6->ZA6_DDDDES	 :=cDDDES
				ZA6->ZA6_TELDES	 :=cTeldes
				ZA6->ZA6_CONPAG  :=ZA0->ZA0_CONPAG
				ZA6->ZA6_TIPPAG  :=ZA0->ZA0_TIPPAG 
				ZA6->ZA6_TPTRAN  :='N'  //Pedrassi
				ZA6->ZA6_TPTRAN  :='N'
				ZA6->ZA6_TPFRET  :=ZA0->ZA0_TPFRET
				ZA6->ZA6_EMERGE  :='N'
				ZA6->ZA6_EMERG2  :='N'
				If lMilkRun = .T.		
					ZA6->ZA6_TIPFLU  :='C' 
				Else
					ZA6->ZA6_TIPFLU  :='I' 
				Endif
				ZA6->ZA6_TIPDES  :='O'
				ZA6->ZA6_FERIAC  :='N'
				ZA6->ZA6_FERIAV  :='N'
				ZA6->ZA6_ORIGEM	 :=cCodmunori  
			IF adados2[i][22] $ "T|M"
				ZA6->ZA6_MUNORI	 :="GUARULHOS"
			Else	               			
				ZA6->ZA6_MUNORI  :=Posicione("ZA2",1,XFILIAL("ZA2")+cCodmunori,"ZA2_DESCRI")
			Endif				
				ZA6->ZA6_ESTORI	 :=cCodestori					 	 	
				ZA6->ZA6_DESTIN	 :=cCodmundes 
				ZA6->ZA6_MUNDES	 :=cCodnomemundes
				ZA6->ZA6_ESTDES	 :=cCodestdes  	
				ZA6->ZA6_CLIORI  :=cCliori
			 	ZA6->ZA6_LOJORI  :=clojaori
			 	ZA6->ZA6_NOMORI  :=cNomeori
			 	ZA6->ZA6_CEPORI  :=cCepori		 	 			
				ZA6->ZA6_DESCRO  :=cDescro
				ZA6->ZA6_MODELO  :=aDados2[i,22]					
				ZA6->ZA6_TIPLKM  :='N'	
				ZA6->ZA6_TABVEN  :=cTabVen 
				ZA6->ZA6_VERVEN  :=cVerTab
				ZA6->ZA6_ITTABV  :=cIttabv
				ZA6->ZA6_TABCOM  :=cTabCom
				ZA6->ZA6_VERCOM  :=cVerCom 
				ZA6->ZA6_ITTABC  :=cIttCom		
				ZA6->(MSUNLOCK())
			    
				// Atualiza os km da viagem no caso de ser um FTL
				FTL()
			    
				lZA6:=.F.
				
			Endif		
			
		u_GRVINCON()// Grava um registro de LOG
			
	DBSKIP()
	ENDDO
End Transaction
 
	FT_FUSE()
	 
	MsgInfo("A Importação dos dados foi executada!","[IMPFIAT] - SUCESSO")
	
endif 

return


//------------------------------------------------------------------------------  
/*/{Protheus.doc} CRIASX1()  

Função usada para criar as perguntas nos parâmetros

@author	 Lucas Cassiano  
@since	 22/02/2016  
@version P11  

@comments  
/*/  
//------------------------------------------------------------------------------

Static Function criaSX1(cPerg)

PutSx1(cPerg,"01" ,"Filial       ?"     ,"Filial       ?"     ,"Filial       ?"     ,"mv_ch1" ,"C" ,TamSX3("ZA0_FILIAL")[1]     ,0      ,0     ,"G",'u_ValCont(MV_PAR01,1)',"SM0","","","mv_par01" ,""            ,""            ,""   ,""   ,""           ,""           ,""           ,""   ,'','','','','','','', ,,)
PutSx1(cPerg,"02" ,"Contrato      ?"     ,"Contrato      ?"     ,"Contrato      ?"     ,"mv_ch2" ,"C" ,22     ,0      ,0     ,"G",'u_ValCont(MV_PAR02,2)' ,"ZA0C","","","mv_par02" ,""            ,""            ,""   ,""   ,""           ,""           ,""           ,""   ,'','','','','','','', ,,)
PutSx1(cPerg,"03" ,"Arquivo     ?"     ,"Arquivo      ?"     ,"Arquivo      ?"     ,"mv_ch3" ,"C" , 60    ,0      ,0     ,"G",'u_ValCont(MV_PAR03,3)' ,"DIR","","","mv_par03" ,""            ,""            ,""   ,""   ,""           ,""           ,""           ,""   ,'','','','','','','', ,,)

Return


//------------------------------------------------------------------------------  
/*/{Protheus.doc} fGERARQ()  

Gravo o log de inclusão no procceso de Importação da FIAT 
Tabela de LOG ZCT

@author	 Lucas Cassiano  
@since	 23/02/2016  
@version P11  

@comments  
/*/  
//------------------------------------------------------------------------------

User Function GRVINCON()

DBSELECTAREA("ZCT")
DBSETORDER(1)
IF !DBSEEK(MV_PAR01+adados2[1][1]+MV_PAR02)
	
	RECLOCK("ZCT",.T.)
	ZCT_FILIAL:= MV_PAR01
	ZCT_CONTRA:= MV_PAR02
	ZCT_SOLICI:= aDados2[i][1]
	ZCT_DATA  := DDATABASE 
	ZCT_ORIGEM:= "EDIFIAT"
	ZCT_NOMARQ:= MV_PAR03
	ZCT->(MSUNLOCK())

Endif
	
Return   

//------------------------------------------------------------------------------  
/*/{Protheus.doc} AtuItem()  

Chama a função para carregar dados de Tabela de Venda e Compra na ZA6

@author	 Lucas Cassiano  
@since	 23/03/2016  
@version P11  

@comments  
/*/  
//------------------------------------------------------------------------------

Static Function AtuItem(_cTpTran,_cTipFlu,_cTiplkm,dDtini,_cTransp,_cCgcOri,_cCgcDes,_ctipo)
Local _aArea	    := GetArea()
Local lRet	        :=.T.
 	
		// Posiciona na SA1 para pegar o código do monucipio e depois localizar na ZA2
		
		DBSELECTAREA("SA1")
		SA1->(DBSETORDER(3))
		IF SA1->(DBSEEK(XFILIAL("SA1")+_cCgcOri))
				
			// Posiciono na ZA2 para pegar o devido código de município de origem//
		 	 DBSELECTAREA("ZA2")
		 	 ZA2->(DBSETORDER(4))
		 	 IF ZA2->(DBSEEK(XFILIAL("ZA2")+SA1->A1_COD_MUN+SA1->A1_EST)) .and. _ctipo $ "6|T" // So fara essa tratativa se o modelo for 6 ou T se for modelo M deve vincular dados como Guarulhos
		 	 	_cOrigOri	:=ZA2->ZA2_CODIGO
			 Else
			 	_cOrigOri	:= "003912"
			 Endif 
			 
		DBSELECTAREA("SA1")
		SA1->(DBSETORDER(3))                
		IF SA1->(DBSEEK(XFILIAL("SA1")+_cCgcDes))
				
			// Posiciono na ZA2 para pegar o devido código de município de origem//
		 	 DBSELECTAREA("ZA2")
		 	 ZA2->(DBSETORDER(4))
		 	 IF ZA2->(DBSEEK(XFILIAL("ZA2")+SA1->A1_COD_MUN+SA1->A1_EST)) .and. _ctipo $ "6|T" // So fara essa tratativa se o modelo for 6 ou T se for modelo M deve vincular dados como Guarulhos
		 	 	_cOrigDes	:=ZA2->ZA2_CODIGO
			 Else
			 	_cOrigDes	:= "003912"
			 Endif
		//Pedrassi Begin
		DBSelectArea("ZA0")
		ZA0->(DBSetOrder(1))
		ZA0->(DBSeek(xFilial("ZA0")+MV_PAR02))
        //Pedrassi End
							                         
	//lret:=	FTABAV(_cTpTran,_cTipFlu,_cTiplkm,dDtini,_cTransp,SA1->A1_COD,SA1->A1_LOJA,_cOrigOri,_cOrigDes)
		lret:=	FTABAV(_cTpTran,_cTipFlu,_cTiplkm,dDtini,_cTransp,ZA0->ZA0_CLI,ZA0->ZA0_LOJA,_cOrigOri,_cOrigDes)
		
	RestArea(_aArea)
	
		Else	    
	    	lRet:=.T.
	    	  	        
        Endif
        
       Else
        	lRet:=.T.
       Endif
       
return lRet    
//------------------------------------------------------------------------------  
/*/{Protheus.doc} AtuItem()  

Alimento os campos de Tabela de Venda e Compra na ZA6
@author	 Lucas Cassiano  
@since	 23/03/2016  
@version P11  

@comments  
/*/  
//------------------------------------------------------------------------------
	
Static Function FTABAV(_cTpTran,_cTipflu,_cTipLkm,dDtini,_ctpTrans,_cCliente,_cLoja,_cOrigOri,_cOrigDes)
		Local   aAreaZA6  :=ZA6->(GetArea())
		Local   mSQL      := ""
		Local   lRet      := .F.
		
		If Select("TZT0") > 0 
			dbSelectArea("TZT0")
			TZT0->(dbCloseArea())                                                                  
		EndIf                                                                                      
				
		mSQL := "SELECT MAX(ZT0_CODTAB)TABELA,MAX(ZT0_VERTAB)VERSAO, MAX(ZT0_ITEMTB)ITEMTAB, MAX(ZT0_PADV) PADV, MAX(ZT0_FRANQC ) FRANQC, MAX(ZT0_FRANQU ) FRANQU  "
		mSQL += " FROM "+RetSQLName("ZT0")+" ZT0 "
		mSQL += " WHERE ZT0_FILIAL='"+xFilial("ZT0")+"' AND ZT0.D_E_L_E_T_=' '  "
		mSQL += " AND ZT0_INIVIG <='"+DtoS(dDtIni)+"' AND (ZT0_FIMVIG >='"+DtoS(dDtIni)+"' OR ZT0_FIMVIG ='' ) "
		mSQL += " AND ZT0_CODCLI='"+_cCliente+"' AND ZT0_LOJCLI='"+_cLoja+"'"  
		mSQL += " AND ZT0_TIPTAB='"+_cTpTran+"' AND ZT0_TIPFLU='"+_cTipflu+"' AND ZT0_MSBLQL='2' " 
		mSQL += " AND ZT0_TIPVEI='"+_ctpTrans+"'" 
		mSQL += " AND ZT0_CODORI='"+_cOrigOri+"'" 
		mSQL += " AND ZT0_CODDES='"+_cOrigDes+"'" 
		
		If(_cTipLkm <> "N", mSQL += " AND ZT0_TIPLKM='"+_cTipLkm+"' ", mSQL += "")

		dbUseArea( .T., "TOPCONN", TCGENQRY(,,mSQL), "TZT0", .F., .T. )
		           
		dbSelectArea("TZT0")
		TZT0->(dbGoTop())
		IF TZT0->(!Eof())
					
			dbSelectArea("ZT0")
			dbSetOrder(1)
			dbSeek(xFilial("ZT0")+TZT0->TABELA+TZT0->VERSAO+_cCliente+_cLoja+_cTpTran+TZT0->ITEMTAB)
			While !eof() .and. ZT0_FILIAL+ZT0_CODTAB+ZT0_VERTAB+ZT0_CODCLI+ZT0_LOJCLI+ZT0_TIPTAB == xFilial("ZT0")+TZT0->TABELA+TZT0->VERSAO+_cCliente+_cLoja+_cTpTran
					 
			If ZT0_MSBLQL='2' .and. ZT0_TIPFLU == _cTipflu .and. ZT0_CODORI == _cOrigOri .and. ZT0_TIPVEI == _cTpTrans
					cTabCom := ZT0->ZT0_TABCOM
					cVerCom := ZT0->ZT0_VERCOM 
		            cIttCom := ZT0->ZT0_ITTABC
		            
					If ZT0->ZT0_TIPREG == "5"                                 
						nSkmVen	:= ZT0->ZT0_QTDKM
					EndIf   

					// Posicionar na ZT1 correspondente
					If !empty(ZT0->ZT0_TABCOM) .and. !empty(ZT0->ZT0_VERCOM) .and. !empty(ZT0->ZT0_ITTABC)
						_aTemp := GetArea()   
						dbSelectArea("ZT1")
						dbSetOrder(1)                                                                                
						dbSeek( xFilial("ZT1") + ZT0->ZT0_TABCOM + ZT0->ZT0_VERCOM)
						_lAchou := .F.
						While !Eof() .and. ZT1_FILIAL+ZT1_CODTAB+ZT1_VERTAB == xFilial("ZT1")+ZT0->ZT0_TABCOM + ZT0->ZT0_VERCOM
							If ZT1_TIPTAB == _cTpTrans .and. ZT1_ITEMTB == ZT0->ZT0_ITTABC .and. ZT1_CODCLI == _cCliente .and. ZT1_LOJCLI == _cLoja
								_lAchou := .T.
								Exit
							EndIF
							dbSkip()
						EndDo
						If _lAchou
							If ZT1->ZT1_TIPREG == "5"
								nSkmCom	:= ZT1->ZT1_QTDKM									
							EndIF
						EndIF
						RestArea(_aTemp)
					EndIf
					Exit
				EndIF   
				dbSkip()
			EndDo
		
			cTabVen := TZT0->TABELA
			cVerTab := TZT0->VERSAO
			cIttabv := TZT0->ITEMTAB
			nPadv   := TZT0->PADV
			nFranqc := TZT0->FRANQC
			nFranqu := TZT0->FRANQU
			
		Endif
		TZT0->(dbCloseArea())
         
	IF EMPTY(cTabVen) .or. EMPTY(cVerTab) .or. EMPTY(cIttabv)
		lret:= .T.
	Endif	
		
		RestArea(aAreaZA6)
	
	Return lRet   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CHECKZT2  ºAutor  ³Lucas Razza Cassianoº Data ³  23/03/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ encontrar o valor em km com base nos ceps da importação    º±±
±±º          ³ Fiat	                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SX7                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    

Static Function CHECKZT2(_cCgcOri,_cColeta,_cCgcDes,cTipo)
Local 	_aAreaCli	:= SA1->(GetArea())
Local 	cQuery      := ''
Local   lRet		:= .F.

If !empty(_cCgcOri) .and. !empty(_cCgcDes) 
	dbSelectArea("SA1")
	dbSetOrder(3)
	dbSeek(xFilial("SA1")+_cCgcOri)
	If !SA1->(eof())
		_cCepOri := SA1->A1_CEP
	EndIF
	
	dbSeek(xFilial("SA1")+_cColeta )
	If !Eof()
		_cCepColeta := SA1->A1_CEP
	EndIF
		
	dbSeek(xFilial("SA1")+_cCgcDes)
	If !Eof()
		_cCepDes := SA1->A1_CEP
	EndIF
	
	If !empty(_cCepOri) .and. !empty(_cCepDes)   
		
	If cTipo $ "M"
		   
		cQuery := "SELECT ZT2_QTDKMU, ZT2_QTDKMA FROM " + RetSqlName("ZT2")
		cQuery += " WHERE ZT2_FILIAL = '" + xFilial("ZT2") + "' AND "
		cQuery += "       ZT2_BLOQUE <> 'S' AND "
		cQuery += "       ZT2_CEPD = '" + _cCepOri + "' AND "
		cQuery += "       ZT2_CEPA = '" + _cCepColeta + "' AND "
		cQuery += "       D_E_L_E_T_<>'*' "

		If Select("TRBX") > 0
			TRBX->(dbCloseArea())	 
		endif
        
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRBX", .F., .T. )
		
		dbSelectArea("TRBX")
		TRBX->(dbGotop())
		If !TRBX->(eof()) //.and. TRBX->ZT2_QTDKMU > 0 .or. TRBX->ZT2_QTDKMA > 0 
		
			_nKm1 := TRBX->ZT2_QTDKMU
			_nKm2 := TRBX->ZT2_QTDKMA				
		
			TRBX->(dbCloseArea())
		
		EndIF
		
		If lFim = .T.		
		
		cQuery := "SELECT ZT2_QTDKMU, ZT2_QTDKMA FROM " + RetSqlName("ZT2")
		cQuery += " WHERE ZT2_FILIAL = '" + xFilial("ZT2") + "' AND "
		cQuery += "       ZT2_BLOQUE <> 'S' AND "
		cQuery += "       ZT2_CEPD = '" + _cCepColeta + "' AND "
		cQuery += "       ZT2_CEPA = '" + _cCepDes + "' AND "
		cQuery += "       D_E_L_E_T_<>'*' "

		If Select("TRBX") > 0
			TRBX->(dbCloseArea())	 
		endif
        
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRBX", .F., .T. )
		
		dbSelectArea("TRBX")
		TRBX->(dbGotop())
			If !TRBX->(eof()) //.and. TRBX->ZT2_QTDKMU > 0 .or. TRBX->ZT2_QTDKMA > 0 
			
				_nKm1 += TRBX->ZT2_QTDKMU
				_nKm2 += TRBX->ZT2_QTDKMA				
			
				TRBX->(dbCloseArea())
			 			 
			EndIF  
		Endif	 
	
	Else
	
		cQuery := "SELECT ZT2_QTDKMU, ZT2_QTDKMA FROM " + RetSqlName("ZT2")
		cQuery += " WHERE ZT2_FILIAL = '" + xFilial("ZT2") + "' AND "
		cQuery += "       ZT2_BLOQUE <> 'S' AND "
		cQuery += "       ZT2_CEPD = '" + _cCepOri + "' AND "
		cQuery += "       ZT2_CEPA = '" + _cCepDes + "' AND "
		cQuery += "       D_E_L_E_T_<>'*' "

		If Select("TRBX") > 0
			TRBX->(dbCloseArea())	 
		endif
        
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRBX", .F., .T. )
		
		dbSelectArea("TRBX")
		TRBX->(dbGotop())
				If !TRBX->(eof()) //.and. TRBX->ZT2_QTDKMU > 0 .or. TRBX->ZT2_QTDKMA > 0 
		
				_nKm1 := TRBX->ZT2_QTDKMU
				_nKm2 := TRBX->ZT2_QTDKMA				
		
				TRBX->(dbCloseArea())		
	     	 	Endif
	    Endif	
	Endif
EndIf	 
	 
	 Restarea(_aAreaCli)	
	 
Return lRet

User Function ValCont(cConteudo,nOpc)

local lRet := .T.
   	
	Do Case
		Case nOpc == 1 .and. cConteudo =''
			  lRet := .F. 
		Case nOpc == 1 .and. cConteudo <> cFilial .Or. Empty(cFilial) 
			  lRet := .F.
		Case nOpc == 3 .and. cConteudo =''
		      lRet := .F.
		Case nOpc == 3 .and. cConteudo <> cCamin .Or. Empty(cCamin)
		      lRet := .F.
	      
	End Case 	
			
Return lRet

/*
Programa    : IMPFIAT
Funcao      : xPergunte
Data        : 07/04/2016
Autor       : André Costa
Descricao   : Função de Parametros
Uso         : Interno
Sintaxe     : xPergunte(p1,p2,p3)
Chamanda    : IMPFIAT
*/


Static Function xPergunte(p1,p2,p3) 
	Local aArea := GetArea()
	Local aPergs		:= {}
	Local aRet			:= {}
	Local cExtensao		:= 'Arquivo *.TXT|*.TXT'
	Local lRetorno		:= .F.
	Local xFilial		:= Space( TamSX3("ZA0_FILIAL")[1] )
	Local xContrato		:= Space( 30 )
	Local xArquivo		:= Padr("",150)
	Local lCanSave		:= .F.
	Local lUserSave		:= .F.
	
	Default p1		:= Space( TamSX3("ZA0_FILIAL")[1] )
	Default p2		:= Space(30)
	Default p3		:= Padr("",150)
	
	xFilial			:= p1
	xContrato		:= p2
	xArquivo		:= p3
	
	aAdd( aPergs , { 1,"Filial"		,xFilial	,"@!" 	,"!Empty(MV_PAR01)" ,"SM0"				,"Empty(MV_PAR01)"	,TamSX3("ZA0_FILIAL")[1] * 2	, .T. })
	aAdd( aPergs , { 1,"Contrato"	,xContrato	,"@!" 	,"!Empty(MV_PAR02)"	,"ZA0C"				,"Empty(MV_PAR02)"	,60 							, .T. })	
	aAdd( aPergs , { 6,"Arquivo"	,xArquivo	,"@!"	,"!Empty(MV_PAR03)"	,"Empty(MV_PAR03)"	,100,.T.,cExtensao,"C:\",GETF_NETWORKDRIVE } )

    If ParamBox( aPergs , "Parametros" , aRet,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPosX*/,/*nPosy*/,/*oDlgWizard*/,/*cLoad*/,lCanSave,lUserSave)
    	MV_PAR01 := aRet[1]
    	MV_PAR02 := aRet[2]
    	MV_PAR03 := aRet[3]
		lRetorno := .T.
    EndIf
    
	RestArea( aArea )
	
Return( lRetorno )




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FTL      ºAutor  ³Frank Zwarg Fuga    º Data ³  08/04/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo dos KM para FIAT - FTL                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³IMPFIAT na gravacao do ZA6                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FTL     
Local _aArea 	:= GetArea()  
Local _cTabV	:= ZA6->ZA6_TABVEN
Local _cTabC    := ZA6->ZA6_TABCOM
Local _cVerV    := ZA6->ZA6_VERVEN
Local _cVerC    := ZA6->ZA6_VERCOM
Local _cIteV    := ZA6->ZA6_ITTABV
Local _cIteC    := ZA6->ZA6_ITTABC
Local _cTpTrans	:= ZA6->ZA6_TPTRAN
Local _cTpTraC	:= ZA6->ZA6_TPTRAC
Local _cCodCli	:= AllTrim(ZA0->ZA0_CLI)
Local _cLojCli	:= AllTrim(ZA0->ZA0_LOJA)
Local _cVenda	:= " "
Local _cCompra  := " "
Local _cRatVen  := " "
Local _cRatCom  := " "
Local _nPerV 	:= 0
Local _nPerC 	:= 0
Local _nRetorno := 0
Local _lErro	:= .F.
Local _nTotal	:= 0
Local _nTemp1   := 0
Local _nTemp2   := 0
Local _nX 
Local _cTipVV   := ""
Local _cTipVC 	:= ""

// Posicionar na tabela de vendas
ZT0->(dbSetOrder(1))
ZT0->( dbSeek( xFilial("ZT0") + _cTabV + _cVerV + _cCodCLi + _cLojCli + _cTpTrans + _cIteV , .T. ) )
If ZT0->(Eof())
	RestArea(_aArea)
	Return .F.
Else
	If ZT0->ZT0_KMPTRE == "S"
		_cVenda := "S" 
		If ZT0->ZT0_RATPES == "S"
			_cRatVen := "S"
		Else               
			_cRatVen := "N"
		EndIF
	Else
		_cVenda := "N"
		If ZT0->ZT0_RATPES == "S"
			_cRatVen := "S"
		Else               
			_cRatVen := "N"
		EndIF
	EndIF              
	_nPerV := ZT0->ZT0_PRTEMB
	_cTipVV := ZT0->ZT0_TIPVEI
EndIF                 

// Posicionar na tabela de compras
dbSelectArea("ZT1")
dbSetOrder(1)                                                                                
dbSeek( xFilial("ZT1") + _cTabC + _cVerC)
_lAchou := .F.
While !Eof() .and. ZT1_FILIAL+ZT1_CODTAB+ZT1_VERTAB == xFilial("ZT1")+_cTabC + _cVerC
	If ZT1_ITEMTB == _cIteC .and. ZT1_CODCLI == _cCodCli .and. ZT1_LOJCLI == _cLojCli
		_lAchou := .T.
		Exit
	EndIF
	dbSkip()
EndDo
If Eof()
	_lErro := .T.
Else
	If ZT1->ZT1_KMPTRE == "S"
		_cCompra := "S"
		If ZT1->ZT1_RATPES == "S"
			_cRatCom := "S"
		Else               
			_cRatCom := "N"
		EndIF
	Else
		_cCompra := "N"
		If ZT1->ZT1_RATPES == "S"
			_cRatCom := "S"
		Else               
			_cRatCom := "N"
		EndIF
	EndIF                    
	_nPerC := _nPerV
	_cTipVC := ZT1->ZT1_TIPVEI
EndIf	

_aRet := {_cVenda,_cCompra,_cRatVen,_cRatCom,_nPerV,_nPerC}

_lFtlv := .F.
_lFtlc := .F.

// Verificar se é um tipo FIAT - FTL
If _cVenda == "N" .and. _cRatVen == "S"  

	dbSelectArea("ZTC")
	DbOrderNickName("ITUPZTC001")
	dbSeek(xFilial("ZTC")+ZT0->ZT0_CODTAB+ZT0->ZT0_VERTAB+ZT0->ZT0_ITEMTB)
	While !Eof() .and. ZTC_FILIAL+ZTC_TABVEN+ZTC_VERVEN+ZTC_ITTABV == xFilial("ZTC")+ZT0->ZT0_CODTAB+ZT0->ZT0_VERTAB+ZT0->ZT0_ITEMTB
		If ZTC_FAIXAA > 0
			_lFtlv := .T.
			Exit
		EndIF
	    dbSkip()                                           
	EndDo            
	                                      
EndIF

If _cCompra == "N" .and. _cRatCom == "S" .and. _lAchou

	dbSelectArea("ZTD")
	DbOrderNickName("ITUPZTD001")
	dbSeek(xFilial("ZTD")+ZT1->ZT1_CODTAB+ZT1->ZT1_VERTAB+ZT1->ZT1_ITEMTB)
	While !Eof() .and. ZTD_FILIAL+ZTD_TABCOM+ZTD_VERCOM+ZTD_ITTABC == xFilial("ZTD")+ZT1->ZT1_CODTAB+ZT1->ZT1_VERTAB+ZT1->ZT1_ITEMTB
		If ZTD_FAIXAA > 0 
			_lFtlc := .T.							
			exit
		EndIF
	    dbSkip()                            
	EndDo                                   

EndIF

If _aRet[1] == "N" .and. _aRet[3] == "S" // Tratamento especial para rateio line haul e FTL - Frank 05/04/16

	_nVRFIXO 	:= 0
	_nVRRETO    := 0
	_nTotPeso   := 0
			
	_cTipo := ""
			
	dbSelectArea("ZTC")
	DbOrderNickName("ITUPZTC001")
	dbSeek(xFilial("ZTC")+ZT0->ZT0_CODTAB+ZT0->ZT0_VERTAB+ZT0->ZT0_ITEMTB)
	_aFaixa := {}      
	While !Eof() .and. ZTC_FILIAL+ZTC_TABVEN+ZTC_VERVEN+ZTC_ITTABV == xFilial("ZTC")+ZT0->ZT0_CODTAB+ZT0->ZT0_VERTAB+ZT0->ZT0_ITEMTB
		If ZTC_FAIXAD == 0 .and. ZTC_FAIXAA == 0 .and. ZTC_VRFIXO > 0
			_cTipo := "LINEHAUL"
			exit
		EndIF                   
				
		If ZTC_FAIXAA > 0
			_cTipo := "FTL"
			Exit
		EndIF
				
	    dbSkip()                                           
	EndDo                                                  

	If _cTipo == "FTL"

		_cOrigem := ZA6->ZA6_CLIORI+ZA6->ZA6_LOJORI
		_cDestin := ZA6->ZA6_CLIDES+ZA6->ZA6_LOJDES
					
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+_cOrigem)				
		_cCepD := SA1->A1_CEP
						                     
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+_cDestin)				
		_cCepA := SA1->A1_CEP
					
		cQuery := "SELECT ZT2_QTDKMU, ZT2_QTDKMA FROM " + RetSqlName("ZT2")
		cQuery += " WHERE ZT2_FILIAL = '" + xFilial("ZT2") + "' AND "
		cQuery += "       ZT2_BLOQUE <> 'S' AND "
		cQuery += "       ZT2_CEPD = '" + _cCepD + "' AND "
		cQuery += "       ZT2_CEPA = '" + _cCepA + "' AND "
		cQuery += "       D_E_L_E_T_<>'*' "
					
		If Select("TRBX") > 0
			TRBX->(dbCloseArea())	 
		endif
		TCQUERY cQuery NEW ALIAS "TRBX"

		Reclock("ZA6",.F.)					

		If !(TRBX->(Eof()))

			DUT->( dbSetOrder(1) )
			If DUT->( dbSeek( xFilial("DUT") + _cTipVV ) ) .and. _lFtlv
				If DUT->DUT_TIPVEI == "05"
					ZA6->ZA6_EKMVEN := TRBX->ZT2_QTDKMU
				Else
					ZA6->ZA6_EKMVEN := TRBX->ZT2_QTDKMA
				EndIF          
			EndIF
			DUT->( dbSetOrder(1) )
			If DUT->( dbSeek( xFilial("DUT") + _cTipVC ) ) .and. _lFtlc
				If DUT->DUT_TIPVEI == "05"
					ZA6->ZA6_EKMCOM := TRBX->ZT2_QTDKMU
				Else
					ZA6->ZA6_EKMCOM := TRBX->ZT2_QTDKMA
				EndIF
			EndIF
		Else
			If _lFtlv
				ZA6->ZA6_EKMVEN := 0
			EndIF
			If _lFtlc
				ZA6->ZA6_EKMCOM := 0
			EndIF
		EndIF

		ZA6->ZA6_SKMVEN := 0
		ZA6->ZA6_SKMCOM := 0			
		
		ZA6->(MsUnlock())
			
	EndIF
			
EndIF
RestArea(_aArea)                  
Return .T.