#include "rwmake.ch"    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GEFM51    ³ Autor ³ Saulo Muniz ³           Data ³ 21.11.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Importacao do Documento (Faturas)                           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GEFM51()   

SetPrvt("XCLILOJA,ARADIO,NRADIO,POS,CNL,XARQ")
SetPrvt("ARQ01,NHDL,TE1,_ACAMPOS,_CNOME,CINDEX")
SetPrvt("CCHAVE,NINDEX,ERROR,_XCLI,_XNAT,VCF")


xcliloja:=" "  //VARIAVEL GUARDA O COD DO CLIENTE PARA UTILIZACAO DO SEEK DO SF3
aRadio := {"Conhecimento frete - GEFCCTRC.TXT","Notas Fiscais - GEFCNOTA.TXT","NF Serviço de Transporte - GEFCONFS.TXT"}
nRadio := 1
_MesAtu:= " "
_AnoAtu:= " "
xNatur := "500" // Natureza Defalt
xSerie := Space(3)
xPerCof := 0
xPerPis := 0


@ 000,000 To 250,370 Dialog oDlg Title "GEFCO - IMPORTA€AO DE NOTAS Versão 3.2"
@ 003,016 To 60,144
@ 010,021 Say OemToAnsi("Este programa tem o objetivo de importar")
@ 022,021 Say OemToAnsi("os arquivos que foram gerados no padrao TXT")
@ 010,152 BmpButton Type 1 Action OBJ()
@ 030,152 BmpButton Type 2 Action Close(oDlg)
Activate Dialog oDlg Centered

Return

Static Function OBJ()
@ 000,000 TO 250,450 DIALOG oDlg1 TITLE "IMPORTACAO DE DADOS - Versão 3.2"
@ 016,010 TO 67,180 TITLE "Importacao de dados"
@ 023,011 RADIO aRadio VAR nRadio
@ 080,010 BUTTON "_Ok" SIZE 35,15 ACTION Import() 
@ 080,050 BUTTON "_Cancel" SIZE 35,15 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER

Return

Static Function Import()
//
// Tratamento de arquivos com interface antiga e a nova
//

pos  := 0
cNL  := CHR(13)+CHR(10)

If nRadio == 1
	xarq:="D:\MICROSIGA\SIGAADV\GEFCCTRC.TXT"
Endif

If nRadio == 2
	xarq:="D:\MICROSIGA\SIGAADV\GEFCNOTA.TXT"
Endif

If nRadio == 3
	xarq:="D:\MICROSIGA\SIGAADV\GEFCONFS.TXT"
Endif


_xVer:=""     
Arqxx   := xarq
nHdxx   := NIL
ntamxx  := 300     
nHdxx   := fopen(Arqxx)
cbufferx:= space(ntamxx)
nbytesx := 0
nbytesx := fRead(nHdxx,@cbufferx,ntamxx)
_xVer   := Substr(cbufferx,033,5)
Fclose(nHdxx)

If Empty(Substr(Alltrim(_xVer),1,3))                // Versão 1 - Sem alterações = Antiga
   Processa({|| ProcTxt2()},"Processando....")
   Close(oDlg)
   Close(oDlg1)
   Fina370(.T.)
Endif
If Substr(Alltrim(_xVer),1,3) == "VA2"              // VERSÃO 2 DO ARQUIVO DE INTERFACE  Ex:. VA2 -Novo lay-out 04/2005
   Processa({|| ProcTxt()},"Processando...VA2") 
   Close(oDlg)
   Close(oDlg1)
   DbSelectArea("SA2")
   DbSetOrder(1)
   Fina370(.T.)
Endif
If Substr(Alltrim(_xVer),1,3) == "VA3"              // VERSÃO 3 11/2005
   Processa({|| ProcTxt()},"Processando...VA3") 
   Close(oDlg)
   Close(oDlg1)
   DbSelectArea("SA2")
   DbSetOrder(1)
   Fina370(.T.)
Endif

Return

Static Function ProcTxt()  // Versão VA2/VA3

pos  := 0
cNL  := CHR(13)+CHR(10)

If nRadio == 1
	xarq:="D:\MICROSIGA\SIGAADV\GEFCCTRC.TXT"
Endif

If nRadio == 2
	xarq:="D:\MICROSIGA\SIGAADV\GEFCNOTA.TXT"
Endif

If nRadio == 3
	xarq:="D:\MICROSIGA\SIGAADV\GEFCONFS.TXT"
Endif

If !File(xarq)
	Msgbox("Arquivo nao existe , verifique seus dados","Mensagem!!!","STOP")
Else


	********************************************
	* Abre o Arquivo para receber a localizacao*
	********************************************
	_xloc:=""                                        //Local de Origem
	_xVer:=""     
	Arq02  := xarq
	nHd2   := NIL
	ntam   := 300                                  // 454 em 16/04/01
	nHd2   := fopen(Arq02)
	cbuffer:= space(ntam)
	nbytes := 0
	nbytes := fRead(nHd2,@cbuffer,ntam)
	_xloc  := substr(cbuffer,15,2)
	_xVer  := substr(cbuffer,033,5)
	Fclose(nHd2)

	// criacao do arquivo Log
	//=======================
	Arq01  := "D:\MICROSIGA\SIGAADV\errata.log"
	nHdl   := fCreate(Arq01)
	te1:="Criacao do arquivo de erros gerados pelo sistema de importacao - Data: "+dtoc(ddatabase)+cNL
	fWrite(nHdl,te1,Len(te1))
	te1:="Arquivo Importado : "+xarq+cNL
	fWrite(nHdl,te1,Len(te1))
	te1:="======================================================================================"+cNL
	fWrite(nHdl,te1,Len(te1))

    // Alteração do modelo para 5 digitos no CFOP
    // de acordo com lei federal
    //
	_aCampos:={}
	Aadd(_aCampos,{"INDICE" ,"N",02,0 })
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
	Aadd(_aCampos,{"VLPTR"  ,"C",14,0 })
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
			
	aParc  := {}
	_cNome := CriaTrab(_aCampos)
	
	DbUseArea( .T.,,_cNome,"TRA",.F. )
	DbSelectArea("TRA")
	cIndex := CriaTrab(nil,.f.)
	cChave := "NF+CDCLI"
	nIndex :=IndRegua("TRA",cIndex,cChave,,,"Selecionando Registros...TRA")
	
	IF nRadio == 2
	   Append from D:\MICROSIGA\SIGAADV\GEFCNOTA.TXT sdf
	Endif                                                                                    

	IF nRadio == 1
       Append from D:\MICROSIGA\SIGAADV\GEFCCTRC.TXT sdf 
	Endif                                                                                    

	IF nRadio == 3
	   Append from D:\MICROSIGA\SIGAADV\GEFCONFS.TXT sdf
	Endif                                                                                    

	DbGotop()
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

	ProcRegua(RecCount())	  

	
	While !Eof()
		
		//CONTROLE DOS ARQUIVOS POR FILIAL DO CABEC-ARQUIVO
		//
		If TRA->INDICE == 00
			MSGINFO("Arquivo do Mes " + Substr(TRA->NF,5,2)+"/"+Substr(TRA->NF,1,4))		
			DbselectArea("TRA")
			Dbskip()
			Loop
		EndIf	
		
		If TRA->INDICE == 99
			MSGINFO("Total de Registros .: " + TRA->NF )
			DbselectArea("TRA")
			Dbskip()
			Loop
		EndIf
 		
 		error := 0
		
		IncProc()
        //Destino MS
        If Substr(TRA->CDDEST,1,2) == "MS"  // Tratamento para Clientes "EX" (MS+A1_COD+A1_LOJA) - Saulo 12/04/05
           //
           xDestino := Substr(TRA->CDDEST,3,8)
           xMSCli   := Substr(TRA->CDCLI,3,8)
           //
           DbselectArea("SA1")
           DbSetorder(1)       // Ordena Por Cliente+loja
           DbGotop()			
    	   If !(Dbseek(xFilial("SA1")+xDestino))  // Retirado Softseek
	    	    pos  := 12
     			errata()
	    		error := 1
                //DbGotop()			
    			DbselectArea("TRA")
    			Dbskip()
    			Loop
    	   Endif
           //    	       	
    	Endif        
        //Destino Cnpj
        If Substr(TRA->CDDEST,1,2) <> "MS"  
           DbselectArea("SA1")
           DbSetorder(3)       // Ordena Por Cliente+loja
           DbGotop()			
           //
    	   If !(Dbseek(xFilial("SA1")+TRA->CDDEST))  // Retirado Softseek
	    		pos  := 8
     			errata()
	    		error := 1
                //DbGotop()			
    			DbselectArea("TRA")
    			Dbskip()
    			Loop
    	   Endif
        Endif        
        //Cliente MS
        If Substr(TRA->CDCLI,1,2) == "MS"  // Tratamento para Clientes "EX" (MS+A1_COD+A1_LOJA) - Saulo 12/04/05
           //
           xDestino := Substr(TRA->CDDEST,3,8)
           xMSCli   := Substr(TRA->CDCLI,3,8)
           // 	
    	   DbselectArea("SA1")
           DbSetorder(1)       // Ordena Por Cliente+loja           
           DbGotop()							
    	   If !(Dbseek(xFilial("SA1")+xMSCli))  // Retirado Softseek
	            pos   := 14
		    	errata()
    			error := 1
	    		DbselectArea("TRA")
    			Dbskip()
    			Loop
	       Endif                  
           //
        Endif        
        //Cliente Cnpj
        If Substr(TRA->CDCLI,1,2) <> "MS"  
    	   DbselectArea("SA1")
           DbSetorder(3)       // Ordena Por Cliente+loja
           DbGotop()							
    	   If !(Dbseek(xFilial("SA1")+TRA->CDCLI))  // Retirado Softseek
	    		pos   := 3
		    	errata()
    			error := 1
	    		DbselectArea("TRA")
    			Dbskip()
    			Loop
	       Endif
           //
        Endif
        //
        // Adicionado controle de Inscr. Estadual / Municipal no Log do arquivo
        // Saulo Muniz - 22/06/04
        // Solicitado pelo setor fiscal
        //
        If Empty(SA1->A1_INSCR) .And. Empty(SA1->A1_INSCR)           
           pos   := 10
		   errata()					
    	   DbselectArea("TRA")
    	   Dbskip()
    	   Loop
        Endif
        //
		If nRadio == 1			
			DbSelectArea("SA2")
			If !(DbSeek(xFilial("SA2")+TRA->CDTRA,.T.))
				pos   := 2
				errata()
				error := 1
            	DbselectArea("TRA")
		    	Dbskip()
			EndIf
		EndIf
		//
		DbSelectArea("SE1")
		If (DbSeek(xFilial("SE1")+TRA->TPDOC+TRA->NF))  //PARA NOTAS FISCAIS
			pos   := 1
			errata()
    		error := 1
			DbselectArea("TRA")
			Dbskip()
			Loop
		Endif
		//
		xCusto := Alltrim(TRA->CC)
      	DbSelectArea("CTT")  // Atualizado para CTB
    	DbSetOrder(1)	
        DbGotop()			
		If !(DbSeek(xFilial("CTT")+xCusto))
            pos   := 11
			errata()
    		error := 1			
			DbselectArea("TRA")
			Dbskip()
			Loop		
		EndIf
        // Testa c.custo menor que 7 digitos - Saulo 13/07/05
        If Len(xCusto) < 7
            pos   := 16
			errata()
    		error := 1			
			DbselectArea("TRA")
			Dbskip()
			Loop		        
        Endif        
        // c.custo bloqueados - Saulo 13/07/05
        If CTT->CTT_BLOQ == "1"
            pos   := 16
			errata()
    		error := 1			
			DbselectArea("TRA")
			Dbskip()
			Loop		        
        Endif        

        //
        // Tratamento de Notas Simples Rem. (apenas livro fiscal) - 11/10/04
 		//
 		xCodFis := Alltrim(MV_PAR01)
 		
 		If Alltrim(TRA->CDFIS) $ "5910/5915/5921/5949/6902/6903/6915/6921/6949" // Adicionado cod.5910 em 25/10/04
		   fiscal()
		   error := 1		
		   DbselectArea("TRA")
		   Dbskip()
		   Loop
        EndIf
		
		DbSelectArea("SE1")		
	
		If error == 0        
         
        DbSelectArea("SA1")
        If Empty(SA1->A1_COND)
    	   pos  := 15
   		   errata()
    	   error := 1
           //DbGotop()			
   		   DbselectArea("TRA")
  		   Dbskip()         
  		   Loop
        End
 
        xCondcli := Alltrim(SA1->A1_COND)        
        aParc := Condicao(Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2)),xCondcli,,Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))) 

		DbSelectArea("SE1")		
               
        For I:=1 to len(aParc)			
			
			xcliloja := SA1->A1_COD + SA1->A1_LOJA           
            xUo      := Substr(Alltrim(TRA->CC),4,1) 
            xAtvFim  := Substr(Alltrim(TRA->CC),4,3)             
            lPisCof  := .F.            
            ///////////////////////////////
            // Operações Fretes Normais  //
            ///////////////////////////////
            Do Case            
               Case xUo $("12")      // Rdvm               
                    xNatur := "500" 
                    lPisCof  := .T.            

               Case xUo $("6789")    // Rma
                    xNatur := "501"     
                    lPisCof  := .T.            
                                        
               Case xUo == "5"       // Rmlap               
                    xNatur := "504"               
                    lPisCof  := .T.            
                                        
               Otherwise
                    xNatur := "500"               
                    lPisCof  := .T.                           
            EndCase
            
            ////////////////////////
            // Operações Isentas  //
            ////////////////////////////////////////////////////
            // Tratamento de Frete Rma , Rdvm e Rmlap isento  //          
            ////////////////////////////////////////////////////            

            // Atividades Rma  Isentas
            xAtvRma   := "612|613|614|619|623|624|625|629|633|634|635|640|717|729|731"            
            // Atividades Rdvm Isentas
            xAtvRdvm  := "102|104|106|109"
            
            // Atividades Rmlap Isentas
            //xAtvRmlap := "DEFINIR ??"
            
            If xUo $("6789") .And. xAtvFim $(xAtvRma)   //Rma                
               xNatur := "502"                 
               lPisCof  := .F.                           
			Endif
            If xUo $("12") .And. xAtvFim $(xAtvRdvm)    //Rdvm
               xNatur := "503"           
               lPisCof  := .F.                           
			Endif
            
            //If xUo == "5" .And. xAtvFim $(xAtvRma)      //Rmlap                
            //   xNatur := "505"
            //   lPisCof  := .F.                           
			//Endif

            // Verifica de exite Pis/Cofins nos titulos de receita
            // Saulo Muniz - 16/11/05
            //
            If lPisCof  
               DbSelectArea("SED")
    	       DbSetorder(1)
               DbGotop()			
               If DbSeek(xFilial("SED")+xNatur)
                  xPerCof := SED->ED_PERCCOF
                  xPerPis := SED->ED_PERCPIS                                 
               Else
                  MsgInfo("Natureza não cadastrada ! "+xNatur)
		    	  pos  := 17
		   		  errata()
		    	  error := 1
		   		  DbselectArea("TRA")
		  		  Dbskip()         
		  		  Loop		
               Endif
               
            Endif
            			
			Reclock("SE1",.T.)
			SE1->E1_FILIAL  := xFilial("SE1")
            SE1->E1_PARCELA := IIF(len(aParc)==1," ",Alltrim(str(i)))
			SE1->E1_NATUREZ := xNatur       // SA1->A1_NATUREZ
			SE1->E1_NOMCLI  := SA1->A1_NOME
			SE1->E1_NUM	    := TRA->NF
			SE1->E1_PREFIXO := TRA->TPDOC   //Prefixo do titulo (CTL, CTR, CTV, etc.)
			SE1->E1_TIPO    := "NF"
			SE1->E1_CLIENTE := SA1->A1_COD
			SE1->E1_LOJA    := SA1->A1_LOJA
			SE1->E1_EMISSAO := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
			SE1->E1_EMIS1   := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
            SE1->E1_VENCTO  := aParc[I][1]
			SE1->E1_VENCORI := aParc[I][1]
            SE1->E1_VENCREA := DataValida(aParc[I][1])
			SE1->E1_VALOR   := aParc[I][2]       
			SE1->E1_SALDO   := aParc[I][2]       
			SE1->E1_VLCRUZ  := aParc[I][2]       
			SE1->E1_FLUXO   := "S"
			SE1->E1_MOEDA   := 1
			SE1->E1_OCORREN := "01"
			SE1->E1_STATUS  := "A"
			SE1->E1_ORIGEM  := "FINA040"
			SE1->E1_SITUACA := "0"
			SE1->E1_CCONT   := Alltrim(TRA->CC)  // Alterado em 08/09/03
			SE1->E1_TRANSP  := TRA->CDTRA   // Campo novo para gravar o Cnpj da Transportadora

			// Novos campos Lay-out 27/08/03
			SE1->E1_REFGEF  := TRA->REFGEF
			SE1->E1_TPDESP  := TRA->TPDESP
			SE1->E1_GEFIRRF := TRA->GEFIRRF
			SE1->E1_CCPSA   := TRA->CCPSA
			SE1->E1_OIPSA   := TRA->OIPSA			
			SE1->E1_CTAPSA  := TRA->CTAPSA  // Solicitado em 14/09/05
			
			// Calculo de Pis/Cofins
            If lPisCof  
          	   SE1->E1_PIS		:= ((aParc[I][2] * xPerPis )/100)  // % Valor Pis
          	   SE1->E1_COFINS	:= ((aParc[I][2] * xPerCof )/100)  // % Valor Cofins
          	Endif
          	
			SE1->E1_IPI     := Val(Substr(TRA->VALIPI,1,Len(TRA->VALIPI)-2)+"."+Substr(TRA->VALIPI,Len(TRA->VALIPI)-1,2))
			
			IF AllTrim(TRA->CDFIS) == "LIX" .Or. AllTrim(TRA->CDFIS) == "58" .Or. AllTrim(TRA->CDFIS) == "55" .Or. AllTrim(TRA->CDFIS) == "CI"
		 	   SE1->E1_ISS   := Val(Substr(TRA->ISSTRI,1,Len(TRA->ISSTRI)-2)+"."+Substr(TRA->ISSTRI,Len(TRA->ISSTRI)-1,2))
			Else
			   SE1->E1_VLRICM:= Val(Substr(TRA->ICMTRI,1,Len(TRA->ICMTRI)-2)+"."+Substr(TRA->ICMTRI,Len(TRA->ICMTRI)-1,2))
			Endif
		
			Msunlock()
        
        Next I

        If Val(Substr(TRA->ISSTRI,1,Len(TRA->ISSTRI)-2)+"."+Substr(TRA->ISSTRI,Len(TRA->ISSTRI)-1,2)) > 0 // Não gera imposto zerado
           Pagar()	 // Função		
        Endif   		

	 	//pagar()	 // Função				
		fiscal() // Função		
		
		Endif
		
		DbselectArea("TRA")
		Dbskip()
	End

Endif

fClose(nHdl)

If pos == 0
	MsgInfo("Importacao Concluida com Sucesso !!")
	DBCLOSEAREA("TRA")
Else
	Alert("Importacao Concluida com OBS. !!")
	Alert("Verificar ERRATA.LOG !!")
	DBCLOSEAREA("TRA")
EndIf

Return

Static Function Pagar()

DbselectArea("SA2")
DbSetOrder(3)
DbSeek(xFilial("SA2")+tra->CDTRA)

DbselectArea("SE2")
// Alterado em 18/12/03 para contab.apenas o imposto

/*
If !(Dbseek(xFilial("SE2")+TRA->TPDOC+TRA->NF+"2"+"NF "+SA2->A2_COD+SA2->A2_LOJA))

	If TRA->TPDOC == "CTR" .or.  TRA->TPDOC == "CTV" .or. TRA->TPDOC == "CTA"   // Modificado Pelo Analista LUIZ FERNANDO // Adicionado CTA Saulo 07/02/02
		DbselectArea("SA2")
		DbSetOrder(3)
		DbSeek(xFilial("SA2")+tra->CDTRA)		
		Reclock("SE2",.T.)
		SE2->E2_FILIAL  := xFilial("SE2")
		SE2->E2_PREFIXO := TRA->TPDOC
		SE2->E2_NUM	 := TRA->NF
		SE2->E2_PARCELA := "2"
		SE2->E2_TIPO	 := "NF"
		SE2->E2_FORNECE := SA2->A2_COD
		SE2->E2_LOJA    := SA2->A2_LOJA
		SE2->E2_NATUREZ := SA2->A2_NATUREZ
		SE2->E2_NOMFOR  := SA2->A2_NOME
		SE2->E2_EMISSAO := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
		SE2->E2_EMIS1   := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
		SE2->E2_VENCTO  := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
		SE2->E2_VENCORI := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
		SE2->E2_VENCREA := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
		SE2->E2_VALOR	 := Val(Substr(TRA->VLPTR,1,Len(TRA->VLPTR)-2)+"."+Substr(TRA->VLPTR,Len(TRA->VLPTR)-1,2))
		SE2->E2_SALDO	 := Val(Substr(TRA->VLPTR,1,Len(TRA->VLPTR)-2)+"."+Substr(TRA->VLPTR,Len(TRA->VLPTR)-1,2))
		SE2->E2_VLCRUZ  := Val(Substr(TRA->VLPTR,1,Len(TRA->VLPTR)-2)+"."+Substr(TRA->VLPTR,Len(TRA->VLPTR)-1,2))
		SE2->E2_HIST    := "Titulo a Pagar Transportadora"
		SE2->E2_FLUXO	 := "S"
		SE2->E2_RATEIO  := "N"
		SE2->E2_MOEDA	 := 1
		SE2->E2_OCORREN := "01"
		SE2->E2_ORIGEM  := "FINA050"
		SE2->E2_CCONT := TRA->CC
		SE2->E2_DESDOBR := "N"
	Endif

	Msunlock()
Else
Endif

*/

If Val(Substr(TRA->ISSTRI,1,Len(TRA->ISSTRI)-2)+"."+Substr(TRA->ISSTRI,Len(TRA->ISSTRI)-1,2)) = 0.00 // Não gera imposto zerado
   Return
Endif   

If ALLTRIM(TRA->CDFIS) == "LIX" .Or. ALLTRIM(TRA->CDFIS) == "CI"
	DbselectArea("SE2")
	If !(Dbseek(xFilial("SE2")+TRA->TPDOC+TRA->NF+" "+"TX "+"MUNIC"))
		Reclock("SE2",.T.)
		SE2->E2_FILIAL  := xFilial("SE2")
		SE2->E2_PREFIXO := Alltrim(TRA->TPDOC)
		SE2->E2_NUM     := TRA->NF
		SE2->E2_TIPO    := "TX"
		SE2->E2_FORNECE := "MUNIC"
		SE2->E2_LOJA    := "00"
		SE2->E2_NATUREZ := "ISS"
		SE2->E2_NOMFOR  := "MUNICIPIO"
		SE2->E2_EMISSAO := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
		SE2->E2_EMIS1   := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
        
        // Tratamento do Imposto p/ cada filial (vencto) - Saulo 13/07/05 informado pelo setor fiscal
		
		_MesAtu := IIF(Strzero((Val(Substr(TRA->XDATA,5,2))+1),2) == "13","01",Strzero((Val(Substr(TRA->XDATA,5,2))+1),2)) // Prox.Mês
		_AnoAtu := IIF(Substr(TRA->XDATA,1,4) == "13","01",Substr(TRA->XDATA,1,4)) // Prox.Ano
				
		Do Case
		   Case xFilial() == "01"  
       		    SE2->E2_VENCTO  := DIAUTIL(_MesAtu,_AnoAtu) //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
        		SE2->E2_VENCORI := DIAUTIL(_MesAtu,_AnoAtu) //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		        SE2->E2_VENCREA := DIAUTIL(_MesAtu,_AnoAtu) //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "02"  
       		    SE2->E2_VENCTO  := DIAUTIL() //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
        		SE2->E2_VENCORI := DIAUTIL() //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		        SE2->E2_VENCREA := DIAUTIL() //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "03"
       		    SE2->E2_VENCTO  := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
        		SE2->E2_VENCORI := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		        SE2->E2_VENCREA := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "04"
       		    SE2->E2_VENCTO  := DataValida(Ctod("09/"+_MesAtu+"/"+_AnoAtu)) 
        		SE2->E2_VENCORI := DataValida(Ctod("09/"+_MesAtu+"/"+_AnoAtu)) 
		        SE2->E2_VENCREA := DataValida(Ctod("09/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "05"
       		    SE2->E2_VENCTO  := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
        		SE2->E2_VENCORI := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
		        SE2->E2_VENCREA := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
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
       		    SE2->E2_VENCTO  := DIAUTIL() //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
        		SE2->E2_VENCORI := DIAUTIL() //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		        SE2->E2_VENCREA := DIAUTIL() //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		        
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

		SE2->E2_VALOR   := Val(Substr(TRA->ISSTRI,1,Len(TRA->ISSTRI)-2)+"."+Substr(TRA->ISSTRI,Len(TRA->ISSTRI)-1,2))
		SE2->E2_SALDO   := Val(Substr(TRA->ISSTRI,1,Len(TRA->ISSTRI)-2)+"."+Substr(TRA->ISSTRI,Len(TRA->ISSTRI)-1,2))
		SE2->E2_VLCRUZ  := Val(Substr(TRA->ISSTRI,1,Len(TRA->ISSTRI)-2)+"."+Substr(TRA->ISSTRI,Len(TRA->ISSTRI)-1,2))
		SE2->E2_HIST    := "Titulo a Pagar ISS"
		SE2->E2_FLUXO   := "S"
		SE2->E2_RATEIO  := "N"
		SE2->E2_MOEDA   := 1
		SE2->E2_OCORREN := "01"
		SE2->E2_ORIGEM  := "FINA040"
		SE2->E2_DESDOBR := "N"
		SE2->E2_CCONT   := TRA->CC
		Msunlock()
	Else
		pos:= 7
		errata()
	Endif
Endif
Return

Static Function Fiscal()

//IF!(Dbseek(xFilial("SA1")+TRA->CDDEST,.T.)) // Alterado 23/01/02 para buscar dados do destinatario
// Novo Tratamento de Cliente como Redespacho para informações no Livro Fiscal 19/01/04
// Definição implementada pelo setor fiscal - Destinatario sempre no livro

If Substr(TRA->CDDEST,1,2) == "MS" // Tratamento para Clientes "EX" (MS+A1_COD+A1_LOJA) - Saulo 12/04/05

   xDestino := Substr(TRA->CDDEST,3,8)
   xMSCli   := Substr(TRA->CDCLI,3,8)
   
   // Cliente Destinatário  
   DbselectArea("SA1")
   DbSetorder(1)       // Ordena Por Cliente+loja           
   DbGotop()							    	   
   If !Dbseek(xFilial("SA1")+xDestino) 
      pos   := 12
      errata()
      error := 1
      DbselectArea("TRA")
      Dbskip()
      Return   
   Endif
   
Else

   xDestino := Substr(TRA->CDDEST,3,8)
   xMSCli   := Substr(TRA->CDCLI,3,8)

   // Cliente Destinatário  
   DbselectArea("SA1")
   DbSetorder(3)       // Ordena Por Cnpj           
   DbGotop()							    	   
   If !Dbseek(xFilial("SA1")+TRA->CDDEST) 
      pos   := 8
      errata()
      error := 1
      DbselectArea("TRA")
      Dbskip()
      Return
   Endif 
   //        
Endif

/*

If Substr(TRA->CDDEST,1,2) == "MS" // Tratamento para Clientes "EX" (MS+A1_COD+A1_LOJA) - Saulo 12/04/05

   xDestino := Substr(TRA->CDDEST,3,8)
   xMSCli   := Substr(TRA->CDCLI,3,8)
   xRedsp   := Substr(TRA->CDRESD,3,8)

   DbselectArea("SA1")
   DbSetorder(1)       // Ordena Por Cliente+loja
   DbGotop()			        
   IF !Empty(TRA->CDRESD) .And. nRadio == 1  // Alterado 14/04/05 - Saulo Redespacho em branco para opção Ctrc
      // Cliente Redespacho           
      If Substr(TRA->CDRESD,1,2) <> "MS"           
         DbselectArea("SA1")
         DbSetorder(3)     
         DbGotop()			      
         If !(Dbseek(xFilial("SA1")+TRA->CDRESD))  // Retirado Softseek
    	      pos  := 13
	    	  errata()
  		      error := 1
              //DbGotop()			
	    	  DbselectArea("TRA")
    	   	  Dbskip()   
	     	  Return
         Endif      
      
      Else  // Ordem de Cod.Cliente      
      
         If !(Dbseek(xFilial("SA1")+xRedsp))  // Retirado Softseek
    	      pos  := 13
	    	  errata()
  		      error := 1
              //DbGotop()			
	    	  DbselectArea("TRA")
    	   	  Dbskip()   
	     	  Return
         Endif      
      Endif
      
   Else
      // Cliente Destinatário  
      If !Dbseek(xFilial("SA1")+xDestino) 
          pos   := 12
          errata()
          error := 1
          DbselectArea("TRA")
          Dbskip()
          Return
      Endif    

   Endif
   
Else
   //

   xDestino := Substr(TRA->CDDEST,3,8)
   xMSCli   := Substr(TRA->CDCLI,3,8)
   xRedsp   := Substr(TRA->CDRESD,3,8)

   DbselectArea("SA1")
   DbSetOrder(3)
   DbGotop()					
   IF !Empty(TRA->CDRESD) .And. nRadio == 1  // Alterado 14/04/05 - Saulo Redespacho em branco para opção Ctrc
      // Cliente Redespacho  
      If Substr(TRA->CDRESD,1,2) == "MS"           
         DbselectArea("SA1")
         DbSetorder(1)     
         DbGotop()			      
         IF!(Dbseek(xFilial("SA1")+xRedsp)) 
            pos   := 9
            errata()
            error := 1
            DbselectArea("TRA")
            Dbskip()
            Return
         Endif    

      Else

         IF!(Dbseek(xFilial("SA1")+TRA->CDRESD)) 
            pos   := 9
            errata()
            error := 1
            DbselectArea("TRA")
            Dbskip()
            Return
         Endif    
            
      Endif
      
   Else
      // Cliente Destinatário  
      If !Dbseek(xFilial("SA1")+TRA->CDDEST) 
          pos   := 8
          errata()
          error := 1
          DbselectArea("TRA")
          Dbskip()
          Return
      Endif    
      //
   Endif 
   //        
Endif
*/


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Função para verificar documento existente e suas series ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

 xSerie := VALSER()
 
DbSelectArea("SF3")
DbSetOrder(8) //DbSetOrder(4)
Dbgotop()
If !DbSeek(xFilial("SF3")+SA1->A1_COD+SA1->A1_LOJA+TRA->NF+xSerie)
//If !DbSeek(xFilial("SF3")+SA1->A1_COD+SA1->A1_LOJA+TRA->NF)
	
	Reclock("SF3",.T.)
	SF3->F3_FILIAL	:= xFilial("SF3")
	SF3->F3_REPROC	:= "N"
	SF3->F3_ENTRADA := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
	SF3->F3_NFISCAL := TRA->NF

    //  Nova Rotina para contab. novas series   
       Gefcofil :=xFilial()
    IF Gefcofil == "02"
       _xloc := "CJ"
    EndIF 

	IF (_xloc =="MV") .OR. (_xloc =="R1") 
	   SF3->F3_SERIE  := "2"   
    ElseIF (_xloc == "CJ") .And. Alltrim(TRA->TPDOC) == "CTM"
       SF3->F3_SERIE  := "2"    
    ElseIF (_xloc == "CJ") .And. Alltrim(TRA->TPDOC) == "CTA"
       SF3->F3_SERIE  := "1"           
    //       ElseIF Alltrim(TRA->TPDOC) == "NFS"
    //       SF3->F3_SERIE  := Alltrim(TRA->TPDOC)               
    Else
       SF3->F3_SERIE  := "U"    
    EndIF	

    //Tratamento Exclusivo para as filiais 06 e 11 (SP) - Saulo 04/07/05
    //   UNS = "NFS"
    //   UNI = "NFST"
    //   "CTR"

    //TRATAMENTO EXCLUSIVO PARA AS FILIAIS 06 E 11 (SP) - SAULO 31/08/05  ( CORREçãO )
    //   UNS = "NFST"
    //   UNI = "NFS"
    //   "CTR"


    If Gefcofil == "06" .OR. Gefcofil == "11"
       //SF3->F3_SERIE   := "A"               
       //SF3->F3_ESPECIE := IIF(ALLTRIM(TRA->TPDOC) == "UNS","NFS",IIF(ALLTRIM(TRA->TPDOC) == "UNI","NFST","CTR"))  
       //SF3->F3_SERIE   := IIF(ALLTRIM(TRA->TPDOC) == "CTR","U","A" ) // Alterado em 13/09/05 -Solic. Eraldo               
       SF3->F3_SERIE   := IIF(ALLTRIM(TRA->TPDOC) == "CTR" .OR. ALLTRIM(TRA->TPDOC) == "UNS","U","A") // Alterado em 10/10/05 -Solic. Eraldo                      
       SF3->F3_ESPECIE := IIF(ALLTRIM(TRA->TPDOC) == "UNS","NFST",IIF(ALLTRIM(TRA->TPDOC) == "UNI","NF","CTR"))  // Solicitado Eraldo 07/11/05 (NFS PARA NF)

    Else  // Demais Casos
       //SF3->F3_ESPECIE := IIF(TRA->TPDOC=="UNI","NFS","CTR")    
       SF3->F3_ESPECIE := IIF(ALLTRIM(TRA->TPDOC) == "UNS","NFST",IIF(ALLTRIM(TRA->TPDOC) == "UNI","NF","CTR"))         
    Endif
        
	SF3->F3_CLIEFOR := substr(SA1->A1_COD+SA1->A1_LOJA,1,6)
	SF3->F3_LOJA    := substr(SA1->A1_COD+SA1->A1_LOJA,7,2)		
	SF3->F3_CFO     := ALLTRIM(TRA->CDFIS)
	SF3->F3_ESTADO	:= ALLTRIM(SA1->A1_EST)
	SF3->F3_EMISSAO := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
	SF3->F3_ALIQICM := Val(Substr(TRA->ALICM,1,Len(TRA->ALICM)-2)+"."+Substr(TRA->ALICM,Len(TRA->ALICM)-1,2))
    SF3->F3_VALCONT := Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2))
	
	SF3->F3_VALICM	:= Val(Substr(TRA->ICMTRI,1,Len(TRA->ICMTRI)-2)+"."+Substr(TRA->ICMTRI,Len(TRA->ICMTRI)-1,2))
	
	//SF3->F3_ESPECIE := ALLTRIM(TRA->TPDOC)//IIF(TRA->TPDOC=="UNI","NF","CTR")
	SF3->F3_BASEIPI := Val(Substr(TRA->BASIPI,1,Len(TRA->BASIPI)-2)+"."+Substr(TRA->BASIPI,Len(TRA->BASIPI)-1,2))
	SF3->F3_VALIPI	:= Val(Substr(TRA->VALIPI,1,Len(TRA->VALIPI)-2)+"."+Substr(TRA->VALIPI,Len(TRA->VALIPI)-1,2))
    //
	// TRATAMENTO DE ICMS SUBST. TRIBUTARIA 
	// IMPOSTO TRIB. = 0 , BASE ICMS = 0 - SOLICITADO EM  29/06/04 
	// SAULO MUNIZ
	//
	IF SF3->F3_VALICM > 0
	   SF3->F3_BASEICM := Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2))
	ELSE
       SF3->F3_BASEICM := 0.00   // ZERA BASE DE ICMS       
       //
       // Tratamento de filiais com imposto zerado - Livro Fiscal 02/12/04 
       // Nova regra com Cfop - 05/01/05
       //        
       IF xFilial("SF3") $ ("01/02/03/05/10") 
          IF Alltrim(SF3->F3_CFO) $ ("5351/5352/5353/5354/5355/5356") 
             SF3->F3_ISENICM := SF3->F3_VALCONT  // FILIAIS COM OPERAÇÃO ISENTO              
          ENDIF
       ENDIF       
       //
       IF xFilial("SF3") == "03" 
          IF Alltrim(SF3->F3_CFO) $ ("6921/6949/5949/5921/5915/6915/6902/5902/6903/5903")
             SF3->F3_OUTRICM := SF3->F3_VALCONT // FILIAIS COM OPERAÇÃO OUTRAS
          ENDIF 
       ENDIF
       //
       /*
       IF (xFilial() $("01/02/03/05/10")) .And. (SF3->F3_CFO $("5351/5352/5353/5354/5355/5356")) 
          SF3->F3_ISENICM := SF3->F3_VALCONT  // FILIAIS COM OPERAÇÃO ISENTO              
       ENDIF       
       //
       IF (xFilial() == "03") .And. (SF3->F3_CFO $("6921/6949/5949/5921/5915/6915/6902/5902/6903/5903"))
           SF3->F3_OUTRICM := SF3->F3_VALCONT // FILIAIS COM OPERAÇÃO OUTRAS
       ENDIF
       //
       */
	ENDIF   
       	
    //	Reforçado a condição para filtro de incidencia de iss para ctrc
    //  Saulo - 05/02/03
    /*
    // Codigos para Gerar Informações de ISS
    //
    F3_CODISS     F3_TIPO 
    LIX             S
    CI              S
    58              S
    55              S    
    */

	SF3->F3_TIPO    := IIF((ALLTRIM(TRA->CDFIS) == "LIX") .Or. (ALLTRIM(TRA->CDFIS) == "CI") .Or. (ALLTRIM(TRA->CDFIS) == "58") .Or. (ALLTRIM(TRA->CDFIS) == "55"), "S" , " ")
	SF3->F3_CODISS  := ALLTRIM(TRA->CODSER) // ALLTRIM(TRA->CDFIS) - Alterado item 15
	
	IF (ALLTRIM(TRA->CDFIS) == "LIX") .Or. (ALLTRIM(TRA->CDFIS) == "CI") .Or. (ALLTRIM(TRA->CDFIS) == "58") .Or. (ALLTRIM(TRA->CDFIS) == "55")
		SF3->F3_OBSERV  := "Incidencia de ISS"
  	    SF3->F3_VALICM	:= Val(Substr(TRA->ISSTRI,1,Len(TRA->ISSTRI)-2)+"."+Substr(TRA->ISSTRI,Len(TRA->ISSTRI)-1,2))
    	SF3->F3_ALIQICM := Val(Substr(TRA->ALISS,1,Len(TRA->ALISS)-2)+"."+Substr(TRA->ALISS,Len(TRA->ALISS)-1,2))
	    SF3->F3_BASEICM := Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2))
	Else
		SF3->F3_OBSERV := "Incidencia de ICMS"
	EndIf

	Msunlock()
Else
	pos:=6
	errata()

Endif       


Return

Static Function Errata()

If pos == 1
	te1:="Titulo ja existente..:        "+tra->NF+" "+tra->CDCLI+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 2
	te1:="Fornecedor nao existe.:       "+tra->CDTRA+" "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 3
	te1:="Cliente Inexistente.:         "+tra->CDCLI+" "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 4
	te1:="Titulo da Seguradora ja existe -S00001 - 01"+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 5
	te1:="Titulo da Trasportadora existe "+tra->cdtra+"-"+"Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 6
	te1:="Registro Fiscal existente -   "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 7
	te1:="Titulo de Iss ja Existe       "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 8
	te1:="Cnpj Destinatário nao Existe  : "+tra->CDDEST+" "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 9
	te1:="Cliente Redespacho nao Existe : "+tra->CDRESD+" "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 10
	te1:="Inscricao Estadual nao Existe : "+tra->CDCLI+" "+" Documento  "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 11
	te1:="Centro de custo não existe :   "+tra->CC+"    "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 12
	te1:="Destinatário MS não Existe : "+tra->CDDEST+" "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 13
	te1:="Redespacho MS não Existe   : "+tra->CDRESD+" "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 14
	te1:="Cliente MS Inexistente     : "+tra->CDCLI+" "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 15
	te1:="Condição de Pagamento Inexistente:  "+tra->CDCLI+" "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 16
	te1:="Centro de custo Invalido   :  "+tra->CC+"    "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 17
	te1:="Natureza não cadastrada / Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif


Return

/////////////////////////////
Static Function ProcTxt2() //
/////////////////////////////

//Local nHdl

pos  := 0
cNL  := CHR(13)+CHR(10)

If nRadio == 1
	xarq:="D:\MICROSIGA\SIGAADV\GEFCCTRC.TXT"
Endif

If nRadio == 2
	xarq:="D:\MICROSIGA\SIGAADV\GEFCNOTA.TXT"
Endif

If nRadio == 3
	xarq:="D:\MICROSIGA\SIGAADV\GEFCONFS.TXT"
Endif


If !File(xarq)
	Msgbox("Arquivo nao existe , verifique seus dados","Mensagem!!!","STOP")
Else
	
	********************************************
	* Abre o Arquivo para receber a localizacao*
	********************************************
	_xloc:=""          
	Arq02  := xarq
	nHd2   := NIL
	ntam   := 287      
	nHd2   := fopen(Arq02)
	cbuffer:= space(ntam)
	nbytes := 0
	nbytes := fRead(nHd2,@cbuffer,ntam)
	_xloc  := substr(cbuffer,15,2)
	Fclose(nHd2)
	
	// criacao do arquivo Log
	//=======================
	Arq01  := "D:\MICROSIGA\SIGAADV\errata.log"
	nHdl   := fCreate(Arq01)
	te1:="Criacao do arquivo de erros gerados pelo sistema de importacao - Data: "+dtoc(ddatabase)+cNL
	fWrite(nHdl,te1,Len(te1))
	te1:="======================================================================================"+cNL
	fWrite(nHdl,te1,Len(te1))

    // Alteração do modelo para 5 digitos no CFOP
    // de acordo com lei federal
    //

	
	_aCampos:={}
	Aadd(_aCampos,{"INDICE" ,"N",02,0 })
	Aadd(_aCampos,{"NF"     ,"C",06,0 })
	Aadd(_aCampos,{"XDATA"  ,"C",08,0 })
	Aadd(_aCampos,{"CDDEST" ,"C",14,0 })
	Aadd(_aCampos,{"CDCLI"  ,"C",14,0 })
	Aadd(_aCampos,{"CDFIS"  ,"C",05,0 })    
	Aadd(_aCampos,{"ALICM"  ,"C",05,0 })
	Aadd(_aCampos,{"VLCONT" ,"C",14,0 })
	Aadd(_aCampos,{"ICMTRI" ,"C",14,0 })
	Aadd(_aCampos,{"BASIPI" ,"C",14,0 })
	Aadd(_aCampos,{"VALIPI" ,"C",14,0 })
	Aadd(_aCampos,{"CDTRA"  ,"C",14,0 })
	Aadd(_aCampos,{"VLSEG"  ,"C",14,0 })
	Aadd(_aCampos,{"VLPTR"  ,"C",14,0 })
	Aadd(_aCampos,{"TPDOC"  ,"C",03,0 })
	Aadd(_aCampos,{"CC"     ,"C",10,0 })	// Alteração para novo lay-out 22/08/03
	Aadd(_aCampos,{"REFGEF" ,"C",20,0 })	
	Aadd(_aCampos,{"TPDESP" ,"C",03,0 })	
	Aadd(_aCampos,{"GEFIRRF","C",01,0 })	
	Aadd(_aCampos,{"CCPSA"  ,"C",20,0 })	
	Aadd(_aCampos,{"OIPSA"  ,"C",20,0 })	
	Aadd(_aCampos,{"CDRESD" ,"C",14,0 })	// Alteração para novo lay-out 15/01/04  Cnpj - Redespacho
	Aadd(_aCampos,{"CTAPSA" ,"C",15,0 })    // Campos novos para PSA   - 14/09/05	
	Aadd(_aCampos,{"CODSER" ,"C",06,0 })    // Campos Cod.Ser.ISS      - 09/11/05	    

	aParc  := {}
	_cNome := CriaTrab(_aCampos)
	
	DbUseArea( .T.,,_cNome,"TRA",.F. )
	DbSelectArea("TRA")
	cIndex := CriaTrab(nil,.f.)
	cChave := "NF+CDCLI"
	nIndex :=IndRegua("TRA",cIndex,cChave,,,"Selecionando Registros...TRA")
	
	IF nRadio == 2
	   Append from D:\MICROSIGA\SIGAADV\GEFCNOTA.TXT sdf
	Endif                                                                                    

	IF nRadio == 1
       Append from D:\MICROSIGA\SIGAADV\GEFCCTRC.TXT sdf 
	Endif                                                                                    

	IF nRadio == 3
	   Append from D:\MICROSIGA\SIGAADV\GEFCONFS.TXT sdf
	Endif                                                                                    

	DbGotop()
	DbSelectArea("SA1")
	DbSetorder(3)
	DbSelectArea("SA2")
	DbSetorder(3)
	DbSelectArea("SE1")
	DbSetOrder(1)
	DbSelectArea("CTT")
	DbSetOrder(1)	
	DbSelectArea("TRA")
	DbGotop()
	ProcRegua(RecCount())
	  
	
	While !Eof()
		
		//CONTROLE DOS ARQUIVOS POR FILIAL DO CABEC-ARQUIVO
		//
		If TRA->INDICE == 00
			MSGINFO("Arquivo do Mes " + Substr(TRA->NF,5,2)+"/"+Substr(TRA->NF,1,4))		
			DbselectArea("TRA")
			Dbskip()
			Loop
		EndIf	
		
		If TRA->INDICE == 99
			MSGINFO("Total de Registros .: " + TRA->NF )
			DbselectArea("TRA")
			Dbskip()
			Loop
		EndIf
 		
 		error := 0
		
		IncProc()
		//
		DbselectArea("SA1")
        DbGotop()			
		If !(Dbseek(xFilial("SA1")+TRA->CDDEST))  // Retirado Softseek
			pos  := 8
			errata()
			error := 1
			DbselectArea("TRA")
			Dbskip()
		Else                       
     		DbselectArea("SA1")
            DbGotop()					
		Endif
        //
		DbselectArea("SA1")
        DbGotop()					
		If !(Dbseek(xFilial("SA1")+TRA->CDCLI))  // Retirado Softseek
			pos   := 3
			errata()
			error := 1
			DbselectArea("TRA")
			Dbskip()
		    Loop
		Endif
        //
        // Adicionado controle de Inscr. Estadual / Municipal no Log do arquivo
        // Saulo Muniz - 22/06/04
        // Solicitado pelo setor fiscal
        If Empty(SA1->A1_INSCR) .And. Empty(SA1->A1_INSCR)           
           pos   := 10
		   errata()					
        Endif
        //
		If nRadio == 1			
			DbSelectArea("SA2")
			If !(DbSeek(xFilial("SA2")+TRA->CDTRA,.T.))
				pos   := 2
				errata()
				error := 1
            	DbselectArea("TRA")
		    	Dbskip()
		    	Loop
			EndIf
		EndIf
		//
		DbSelectArea("SE1")
		If (DbSeek(xFilial("SE1")+TRA->TPDOC+TRA->NF))  //PARA NOTAS FISCAIS
			pos   := 1
			errata()
    		error := 1
			DbselectArea("TRA")
			Dbskip()
		    Loop    		
		Endif
		//
		xCusto := Alltrim(TRA->CC)
		DbSelectArea("CTT")		
		If !(DbSeek(xFilial("CTT")+xCusto,.T.))
            pos   := 11
			errata()
    		error := 1			
			DbselectArea("TRA")
			Dbskip()
			Loop
		EndIf
        //
        // Tratamento de Notas Simples Rem. (apenas livro fiscal) - 11/10/04
 		//
 		xCodFis := Alltrim(MV_PAR01) 		
 		If Alltrim(TRA->CDFIS) $ "5910/5915/5921/5949/6902/6903/6915/6921/6949" // Adicionado cod.5910 em 25/10/04
		   fiscal()
		   error := 1		
		   DbselectArea("TRA")
		   Dbskip()
		   Loop
        EndIf
		
		DbSelectArea("SE1")		
	
		If error == 0        
         
        DbSelectArea("SA1")
        If Empty(SA1->A1_COND)
    	   pos  := 15
   		   errata()
    	   error := 1
   		   DbselectArea("TRA")
  		   Dbskip()         
  		   Loop
        End

        xCondcli := Alltrim(SA1->A1_COND)        
        aParc := Condicao(Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2)),xCondcli,,Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))) 

		DbSelectArea("SE1")		
               
        For I:=1 to len(aParc)			
			
        	xcliloja := SA1->A1_COD + SA1->A1_LOJA           
            xUo      := Substr(Alltrim(TRA->CC),4,1) 
            xAtvFim  := Substr(Alltrim(TRA->CC),4,3)             
                        
            ///////////////////////////////
            // Operações Fretes Normais  //
            ///////////////////////////////
            Do Case            
               Case xUo $("12")      // Rdvm               
                    xNatur := "500" 

               Case xUo $("6789")    // Rma
                    xNatur := "501"     
                    
               Case xUo == "5"       // Rmlap               
                    xNatur := "504"               
                    
               Otherwise
                    xNatur := "500"               
               
            EndCase
            
            ////////////////////////
            // Operações Isentas  //
            ////////////////////////////////////////////////////
            // Tratamento de Frete Rma , Rdvm e Rmlap isento  //          
            ////////////////////////////////////////////////////            

            // Atividades Rma  Isentas
            xAtvRma   := "612|613|614|619|623|624|625|629|633|634|635|640|717|729|731"            
            // Atividades Rdvm Isentas
            xAtvRdvm  := "102|104|106|109"
            
            // Atividades Rmlap Isentas
            //xAtvRmlap := "DEFINIR ??"
            
            If xUo $("6789") .And. xAtvFim $(xAtvRma)   //Rma                
               xNatur := "502"
			Endif
            If xUo $("12") .And. xAtvFim $(xAtvRdvm)    //Rdvm
               xNatur := "503"           
			Endif
            
            //If xUo == "5" .And. xAtvFim $(xAtvRma)      //Rmlap                
            //   xNatur := "505"
			//Endif
        			
			Reclock("SE1",.T.)
			SE1->E1_FILIAL  := xFilial("SE1")
            SE1->E1_PARCELA := IIF(len(aParc)==1," ",Alltrim(str(i)))
			SE1->E1_NATUREZ := xNatur // SA1->A1_NATUREZ
			SE1->E1_NOMCLI  := SA1->A1_NOME
			SE1->E1_NUM	    := TRA->NF
			SE1->E1_PREFIXO := TRA->TPDOC //Prefixo do titulo (CTL, CTR, CTV, etc.)
			SE1->E1_TIPO    := "NF"
			SE1->E1_CLIENTE := SA1->A1_COD
			SE1->E1_LOJA    := SA1->A1_LOJA
			SE1->E1_EMISSAO := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
			SE1->E1_EMIS1   := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
            SE1->E1_VENCTO  := aParc[I][1]
			SE1->E1_VENCORI := aParc[I][1]
            SE1->E1_VENCREA := DataValida(aParc[I][1])
			SE1->E1_VALOR   := aParc[I][2]       
			SE1->E1_SALDO   := aParc[I][2]       
			SE1->E1_VLCRUZ  := aParc[I][2]       
			SE1->E1_FLUXO   := "S"
			SE1->E1_MOEDA   := 1
			SE1->E1_OCORREN := "01"
			SE1->E1_STATUS  := "A"
			SE1->E1_ORIGEM  := "FINA040"
			SE1->E1_SITUACA := "0"
			SE1->E1_CCONT   := Alltrim(TRA->CC)  // Alterado em 08/09/03
			SE1->E1_TRANSP  := TRA->CDTRA   // Campo novo para gravar o Cnpj da Transportadora

			// Novos campos Lay-out 27/08/03
			SE1->E1_REFGEF  := TRA->REFGEF
			SE1->E1_TPDESP  := TRA->TPDESP
			SE1->E1_GEFIRRF := TRA->GEFIRRF
			SE1->E1_CCPSA   := TRA->CCPSA
			SE1->E1_OIPSA   := TRA->OIPSA			
			SE1->E1_CTAPSA  := TRA->CTAPSA  // Solicitado em 14/09/05
			
			SE1->E1_IPI     := Val(Substr(TRA->VALIPI,1,Len(TRA->VALIPI)-2)+"."+Substr(TRA->VALIPI,Len(TRA->VALIPI)-1,2))
			
			IF AllTrim(TRA->CDFIS) == "LIX" .Or. AllTrim(TRA->CDFIS) == "58" .Or. AllTrim(TRA->CDFIS) == "55" .Or. AllTrim(TRA->CDFIS) == "CI"
		 	   SE1->E1_ISS   := Val(Substr(TRA->ICMTRI,1,Len(TRA->ICMTRI)-2)+"."+Substr(TRA->ICMTRI,Len(TRA->ICMTRI)-1,2))
			Else
			   SE1->E1_VLRICM:= Val(Substr(TRA->ICMTRI,1,Len(TRA->ICMTRI)-2)+"."+Substr(TRA->ICMTRI,Len(TRA->ICMTRI)-1,2))
			Endif
		
			Msunlock()
        
        Next I
		
	 	pagar2()	 // Função
		//fiscal() // Função		
		fiscal2() // Função						
		Endif
		
		DbselectArea("TRA")
		Dbskip()
	End

Endif

fClose(nHdl)

If pos == 0
	MsgInfo("Importacao Concluida com Sucesso !!")
	DBCLOSEAREA("TRA")
Else
	Alert("Importacao Concluida com OBS. !!")
	Alert("Verificar ERRATA.LOG !!")
	DBCLOSEAREA("TRA")
EndIf

Return

Static Function Pagar2()

DbselectArea("SA2")
DbSetOrder(3)
DbGotop()
DbSeek(xFilial("SA2")+tra->CDTRA)

If ALLTRIM(TRA->CDFIS) == "LIX" .Or. ALLTRIM(TRA->CDFIS) == "CI"
	DbselectArea("SE2")
	Dbgotop()
	If !(Dbseek(xFilial("SE2")+TRA->TPDOC+TRA->NF+" "+"TX "+"MUNIC"))
		Reclock("SE2",.T.)
		SE2->E2_FILIAL  := xFilial("SE2")
		SE2->E2_PREFIXO := Alltrim(TRA->TPDOC)
		SE2->E2_NUM     := TRA->NF
		SE2->E2_TIPO    := "TX"
		SE2->E2_FORNECE := "MUNIC"
		SE2->E2_LOJA    := "00"
		SE2->E2_NATUREZ := "ISS"
		SE2->E2_NOMFOR  := "MUNICIPIO"
		SE2->E2_EMISSAO := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
		SE2->E2_EMIS1   := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
		//SE2->E2_VENCTO  := Ctod("05/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
		//SE2->E2_VENCORI := Ctod("05/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
		//SE2->E2_VENCREA := DataValida(Ctod("05/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4)))
		SE2->E2_VALOR   := Val(Substr(TRA->ICMTRI,1,Len(TRA->ICMTRI)-2)+"."+Substr(TRA->ICMTRI,Len(TRA->ICMTRI)-1,2))
		SE2->E2_SALDO   := Val(Substr(TRA->ICMTRI,1,Len(TRA->ICMTRI)-2)+"."+Substr(TRA->ICMTRI,Len(TRA->ICMTRI)-1,2))
		SE2->E2_VLCRUZ  := Val(Substr(TRA->ICMTRI,1,Len(TRA->ICMTRI)-2)+"."+Substr(TRA->ICMTRI,Len(TRA->ICMTRI)-1,2))
		SE2->E2_HIST    := "Titulo a Pagar ISS"
		SE2->E2_FLUXO   := "S"
		SE2->E2_RATEIO  := "N"
		SE2->E2_MOEDA   := 1
		SE2->E2_OCORREN := "01"
		SE2->E2_ORIGEM  := "FINA040"
		SE2->E2_DESDOBR := "N"
		SE2->E2_CCONT   := TRA->CC

        // Tratamento do Imposto p/ cada filial (vencto) - Saulo 13/07/05 informado pelo setor fiscal
		
		_MesAtu := IIF(Strzero((Val(Substr(TRA->XDATA,5,2))+1),2) == "13","01",Strzero((Val(Substr(TRA->XDATA,5,2))+1),2)) // Prox.Mês
		_AnoAtu := IIF(Substr(TRA->XDATA,1,4) == "13","01",Substr(TRA->XDATA,1,4)) // Prox.Ano
				
		Do Case
		   Case xFilial() == "01"  
       		    SE2->E2_VENCTO  := DIAUTIL(_MesAtu,_AnoAtu) //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
        		SE2->E2_VENCORI := DIAUTIL(_MesAtu,_AnoAtu) //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		        SE2->E2_VENCREA := DIAUTIL(_MesAtu,_AnoAtu) //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "02"  
       		    SE2->E2_VENCTO  := DIAUTIL() //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
        		SE2->E2_VENCORI := DIAUTIL() //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		        SE2->E2_VENCREA := DIAUTIL() //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "03"
       		    SE2->E2_VENCTO  := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
        		SE2->E2_VENCORI := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		        SE2->E2_VENCREA := DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "04"
       		    SE2->E2_VENCTO  := DataValida(Ctod("09/"+_MesAtu+"/"+_AnoAtu)) 
        		SE2->E2_VENCORI := DataValida(Ctod("09/"+_MesAtu+"/"+_AnoAtu)) 
		        SE2->E2_VENCREA := DataValida(Ctod("09/"+_MesAtu+"/"+_AnoAtu)) 
		   Case xFilial() == "05"
       		    SE2->E2_VENCTO  := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
        		SE2->E2_VENCORI := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
		        SE2->E2_VENCREA := DataValida(Ctod("10/"+_MesAtu+"/"+_AnoAtu)) 
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
       		    SE2->E2_VENCTO  := DIAUTIL() //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
        		SE2->E2_VENCORI := DIAUTIL() //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
		        SE2->E2_VENCREA := DIAUTIL() //DataValida(Ctod("03/"+_MesAtu+"/"+_AnoAtu)) 
        EndCase

		Msunlock()


	Else
		pos:= 7
		errata()
	Endif
Endif

Return

Static Function Fiscal2() //Antigo
DbselectArea("SA1")
DbSetOrder(3)
DbGotop()					

IF !Empty(TRA->CDRESD)
   // Cliente Redespacho  
   IF!(Dbseek(xFilial("SA1")+TRA->CDRESD))
       pos   := 9
	   errata()
       error := 1
	   DbselectArea("TRA")
       Dbskip()
   Endif    
Else
   // Cliente Destinatário  
   If !Dbseek(xFilial("SA1")+TRA->CDDEST) 
       pos   := 9
	   errata()
       error := 1
	   DbselectArea("TRA")
       Dbskip()
   Endif
   
Endif 

 //
 xSerie := VALSER()
 //

DbSelectArea("SF3")
DbSetOrder(8)
DbGotop()
If !DbSeek(xFilial("SF3")+SA1->A1_COD+SA1->A1_LOJA+TRA->NF+xSerie)	

	Reclock("SF3",.T.)
	SF3->F3_FILIAL	:= xFilial("SF3")
	SF3->F3_REPROC	:= "N"
	SF3->F3_ENTRADA := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
	SF3->F3_NFISCAL := TRA->NF

    //  Nova Rotina para contab. novas series   
       Gefcofil :=xFilial()
    IF Gefcofil =="02"
       _xloc := "CJ"
    EndIF 

	IF (_xloc =="MV") .OR. (_xloc =="R1") 
	   SF3->F3_SERIE  := "2"   
    ElseIF (_xloc == "CJ") .And. Alltrim(TRA->TPDOC) == "CTM"
       SF3->F3_SERIE  := "2"    
    ElseIF (_xloc == "CJ") .And. Alltrim(TRA->TPDOC) == "CTA"
       SF3->F3_SERIE  := "1"           
    //       ElseIF Alltrim(TRA->TPDOC) == "NFS"
    //       SF3->F3_SERIE  := Alltrim(TRA->TPDOC)               
    Else
       SF3->F3_SERIE  := "U"    
    EndIF	

    //Tratamento Exclusivo para as filiais 06 e 11 (SP) - Saulo 04/07/05
    //   UNS = "NFS"
    //   UNI = "NFST"
    //   "CTR"

    //Tratamento Exclusivo para as filiais 06 e 11 (SP) - Saulo 31/08/05  ( Correção )
    //   UNS = "NFST"
    //   UNI = "NFS"
    //   "CTR"


    If Gefcofil == "06" .OR. Gefcofil == "11"
       //SF3->F3_SERIE   := "A"               
       //SF3->F3_ESPECIE := IIF(ALLTRIM(TRA->TPDOC) == "UNS","NFS",IIF(ALLTRIM(TRA->TPDOC) == "UNI","NFST","CTR"))  
       SF3->F3_SERIE   := IIF(ALLTRIM(TRA->TPDOC) == "CTR" .OR. ALLTRIM(TRA->TPDOC) == "UNS","U","A") // Alterado em 10/10/05 -Solic. Eraldo                      
       SF3->F3_ESPECIE := IIF(ALLTRIM(TRA->TPDOC) == "UNS","NFST",IIF(ALLTRIM(TRA->TPDOC) == "UNI","NFS","CTR"))  

    Else  // Demais Casos
       //SF3->F3_ESPECIE := IIF(TRA->TPDOC=="UNI","NFS","CTR")    
       SF3->F3_ESPECIE := IIF(ALLTRIM(TRA->TPDOC) == "UNS","NFST",IIF(ALLTRIM(TRA->TPDOC) == "UNI","NFS","CTR"))  
    Endif
   
	SF3->F3_CLIEFOR := substr(SA1->A1_COD+SA1->A1_LOJA,1,6)
	SF3->F3_LOJA    := substr(SA1->A1_COD+SA1->A1_LOJA,7,2)
	SF3->F3_CFO     := ALLTRIM(TRA->CDFIS)
	SF3->F3_ESTADO	:= ALLTRIM(SA1->A1_EST)
	SF3->F3_EMISSAO := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
	SF3->F3_ALIQICM := Val(Substr(TRA->ALICM,1,Len(TRA->ALICM)-2)+"."+Substr(TRA->ALICM,Len(TRA->ALICM)-1,2))
    SF3->F3_VALCONT := Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2))
	SF3->F3_VALICM	:= Val(Substr(TRA->ICMTRI,1,Len(TRA->ICMTRI)-2)+"."+Substr(TRA->ICMTRI,Len(TRA->ICMTRI)-1,2))
	//SF3->F3_ESPECIE := IIF(TRA->TPDOC=="UNI"," NF","CTR")
	SF3->F3_BASEIPI := Val(Substr(TRA->BASIPI,1,Len(TRA->BASIPI)-2)+"."+Substr(TRA->BASIPI,Len(TRA->BASIPI)-1,2))
	SF3->F3_VALIPI	:= Val(Substr(TRA->VALIPI,1,Len(TRA->VALIPI)-2)+"."+Substr(TRA->VALIPI,Len(TRA->VALIPI)-1,2))

	IF SF3->F3_VALICM > 0
	   SF3->F3_BASEICM := Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2))
	ELSE
       SF3->F3_BASEICM := 0.00   // ZERA BASE DE ICMS       
       IF xFilial("SF3") $ ("01/02/03/05/10") 
          IF Alltrim(SF3->F3_CFO) $ ("5351/5352/5353/5354/5355/5356") 
             SF3->F3_ISENICM := SF3->F3_VALCONT  // FILIAIS COM OPERAÇÃO ISENTO              
          ENDIF
       ENDIF       
       //
       IF xFilial("SF3") == "03" 
          IF Alltrim(SF3->F3_CFO) $ ("6921/6949/5949/5921/5915/6915/6902/5902/6903/5903")
             SF3->F3_OUTRICM := SF3->F3_VALCONT // FILIAIS COM OPERAÇÃO OUTRAS
          ENDIF 
       ENDIF
	ENDIF          	
    //	Reforçado a condição para filtro de incidencia de iss para ctrc
    //  Saulo - 05/02/03
    /*
    // Codigos para Gerar Informações de ISS

    F3_CODISS     F3_TIPO 
    LIX             S
    CI              S
    58              S
    55              S
    
    */
	SF3->F3_TIPO    := IIF((ALLTRIM(TRA->CDFIS) == "LIX") .Or. (ALLTRIM(TRA->CDFIS) == "CI") .Or. (ALLTRIM(TRA->CDFIS) == "58") .Or. (ALLTRIM(TRA->CDFIS) == "55"), "S" , " ")
	IF (ALLTRIM(TRA->CDFIS) == "LIX") .Or. (ALLTRIM(TRA->CDFIS) == "CI") .Or. (ALLTRIM(TRA->CDFIS) == "58") .Or. (ALLTRIM(TRA->CDFIS) == "55")
		SF3->F3_OBSERV := "Incidencia de ISS"
		SF3->F3_CODISS  := ALLTRIM(TRA->CODSER) // ALLTRIM(TRA->CDFIS) - Alterado item 15
	Else
		SF3->F3_OBSERV := "Incidencia de ICMS"
	EndIf

	Msunlock()
Else
	pos:=6
	errata()
    error := 1
Endif       

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VALSERºAutor  ³ Saulo Muniz           º Data ³  26/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VALSER()

Local xTpServ

  //  Nova Rotina para contab. novas series   
     Gefcofil :=xFilial()
  IF Gefcofil == "02"
     _xloc := "CJ"
  EndIF 
  
  // Refeito a regra de especies
  // UNS = NFST
  // UNI = NFS
  // CTR = CTR
  
  //If Gefcofil == "06" .OR. Gefcofil == "11"
     xTpServ  := IIF(ALLTRIM(TRA->TPDOC) == "UNS","NFST",IIF(ALLTRIM(TRA->TPDOC) == "UNI","NFS","CTR"))  
  //Else  
  //   xTpServ  := IIF(TRA->TPDOC=="UNI","NFS","CTR")    
  //Endif
    
Return(xTpServ)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DIAUTIL ºAutor  ³ Saulo Muniz         º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
         
////////////////////////////
// Tabela de Venctos  ISS //
////////////////////////////
/*
 __________________________________
| MATRIZ   - 01 -  3° Dia Util     |
| CAJU     - 02 -  3° Dia Util     |
| BARUERI  - 04 -  Dia 09          |
| CAXIAS   - 05 -  Dia 10          |
| V.GUILHE - 06 -  Dia 10          |
| CAMPINAS - 08 -  Dia 10          |
| V.OLIMPIA- 11 -  Dia 10          |
| CURITIBA - 07 -  Dia 20          |
| RB45     - 13 -  3° Dia Util     |
|__________________________________|                                  

*/

Static Function DIAUTIL(_MesAtu,_AnoAtu)  // 3° Dia Util     

dEmis := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))

nMes  := IIF(Month(dEmis) == 12, Month(dEmis), Month(dEmis) + 1)
nAno  := IIF(Month(dEmis) == 12, Year(dEmis) + 1, Year(dEmis))

dIni  := CtoD("01/"+ StrZero(nMes,2) + "/" + StrZero(nAno,4) )        // FirstDay(dDatabase)
dMov  := dIni
dUtil := 0
xDia  := dIni

dSem  := Dow(dIni)


Do Case
   Case dSem == 1
        xDia := CtoD("04/"+ StrZero(nMes,2) + "/" + StrZero(nAno,4) )  

   Case dSem >= 2 .And. dSem <= 4
        xDia := CtoD("03/"+ StrZero(nMes,2) + "/" + StrZero(nAno,4) )  

   Case dSem >= 5 .And. dSem <= 7
        xDia := CtoD("05/"+ StrZero(nMes,2) + "/" + StrZero(nAno,4) )  
   
EndCase
   
Return(xDia)