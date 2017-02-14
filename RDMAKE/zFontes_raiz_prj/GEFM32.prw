#include "rwmake.ch"     

User Function GEFM32()   

SetPrvt("XCLILOJA,ARADIO,NRADIO,POS,CNL,XARQ")
SetPrvt("ARQ01,NHDL,TE1,_ACAMPOS,_CNOME,CINDEX")
SetPrvt("CCHAVE,NINDEX,ERROR,_XCLI,_XNAT,VCF")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GEFM32    ³ Autor ³ Saulo Muniz           ³ Data ³ 03.08.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Importacao do Documento Gefco Novo Lay-out                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Tratar o Redespacho 
// Tratar o campo na importação Cliente Bysoft ??
// Cif ou Fob no arquivo ? 

xcliloja:=" "  //VARIAVEL GUARDA O COD DO CLIENTE PARA UTILIZACAO DO SEEK DO SF3
//aRadio := {"Conhecimento frete","Notas Fiscais","NF Serviço"}
aRadio := {"Conhecimento frete - GEFCCTRC.TXT","Notas Fiscais - GEFCNOTA.TXT","NF Serviço de Transporte - GEFCONFS.TXT"}
nRadio := 1

@ 000,000 To 250,370 Dialog oDlg Title "GEFCO - IMPORTA€AO DE NOTAS"
@ 003,016 To 60,144
@ 010,021 Say OemToAnsi("Este programa tem o objetivo de importar")
@ 022,021 Say OemToAnsi("os arquivos que foram gerados no padrao TXT")
@ 010,152 BmpButton Type 1 Action OBJ()// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> @ 010,152 BmpButton Type 1 Action Execute(OBJ)
@ 030,152 BmpButton Type 2 Action Close(oDlg)
Activate Dialog oDlg Centered
MATA440() // LIBERAÇÃO DOS PEDIDOS

Return

//Static Function OBJ()
//@ 0,0 TO 250,450 DIALOG oDlg1 TITLE "IMPORTACAO DE DADOS"
//@ 16,80 TO 67,180 TITLE "Importacao de dados"
//@ 23,81 RADIO aRadio VAR nRadio
//@ 80,100 BUTTON "_Ok" SIZE 35,15 ACTION Import()// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> @ 80,100 BUTTON "_Ok" SIZE 35,15 ACTION Execute(Import)
//@ 100,100 BUTTON "_Cancel" SIZE 35,15 ACTION Close(oDlg1)
//ACTIVATE DIALOG oDlg1 CENTER
//Processa({|lEnd| a440Proces(cAlias,nReg,nOpc)})

Static Function OBJ()
@ 000,000 TO 250,450 DIALOG oDlg1 TITLE "IMPORTACAO DE DADOS"
@ 016,010 TO 67,180 TITLE "Importacao de dados"
@ 023,011 RADIO aRadio VAR nRadio
@ 080,010 BUTTON "_Ok" SIZE 35,15 ACTION Import() 
@ 080,050 BUTTON "_Cancel" SIZE 35,15 ACTION Close(oDlg1)
//@ 080,090 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
ACTIVATE DIALOG oDlg1 CENTER


Return


//--------------------------------------------------------------------------------//
//  Importação dos dados
//--------------------------------------------------------------------------------// 		
Static Function Import()

Processa({|| ProcTxt()},"Importando Arquivo ...")// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==>  Processa({|| Execute(ProcTxt)},"Processando...")
   Close(oDlg)
   Close(oDlg1)
Return


Static Function ProcTxt()

pos  := 0
cNL  := CHR(13)+CHR(10)
xRenomeia := .T.
xValida := .T.
nOpc := 3 // Inclusao
PRIVATE lMsErroAuto := .F.

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
	xRenomeia := .F.
Else
	
	********************************************
	* Abre o Arquivo para receber a localizacao     *
	********************************************
	_xloc:=""       
	Arq02  := xarq
	nHd2   := NIL
	ntam   := 600 
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
    //  
	_aCampos:={}	
	AADD(_aCampos,{"PEDGEF" ,"C",600,0})
	aParc  := {}
	_cNome := CriaTrab(_aCampos)	
	DbUseArea( .T.,,_cNome,"TRA",.F.)
	DbSelectArea("TRA")
	
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
	DbSelectArea("SA1")  // A1_FILIAL+A1_CGC
	DbSetorder(3)
	DbSelectArea("SA4")  // A4_FILIAL+A4_COD
	DbSetorder(3)
	DbSelectArea("SC5")  // C5_FILIAL+C5_NUM
	DbSetOrder(1)	
	DbSelectArea("TRA")
	DbGotop()
	
	ProcRegua(RecCount())

	While !Eof()
		
		IncProc()

		//LINHA EM BRANCO
		If Substr(TRA->PEDGEF,1,3) == "   "
			DbselectArea("TRA")
			Dbskip()
			Loop
		EndIf        
	
		//CABEC. DO ARQUIVO
		If Substr(TRA->PEDGEF,1,3) == "AAA"
			DbselectArea("TRA")
			Dbskip()
			Loop
		EndIf        

        //DADOS CLIENTES
        If Substr(TRA->PEDGEF,1,3) == "0CC"
        //If TRA->INDICE == "0CC"			
			MontaCliente()
            //Cliente()			
			DbselectArea("TRA")
			Dbskip()
		EndIf

		//RODAPE DE CLIENTES
		If Substr(TRA->PEDGEF,1,3) == "9CC"
			DbselectArea("TRA")
			Dbskip()
			Loop
		EndIf 		 		

 		//DADOS TRANSPORTADORA
 		If Substr(TRA->PEDGEF,1,3) == "0CT"
			MontaTransp()    		
			DbselectArea("TRA")
			Dbskip()					
		EndIf        

        //RODAPE TRANSPORTADORA
		If Substr(TRA->PEDGEF,1,3) == "9CT"
			DbselectArea("TRA")
			Dbskip()
			Loop
		EndIf 		

 		//DOCUMENTO
		If Substr(TRA->PEDGEF,1,3) == "0CD"	                
                    
            _Filial  := Alltrim(Substr(TRA->PEDGEF,007,03)) // Filial   (TAMANHO 5 ADHOC)                      
            CnpjSC5  := Alltrim(Substr(TRA->PEDGEF,029,14))  //Remetente        
            DestCnpj := Alltrim(Substr(TRA->PEDGEF,044,14))  //Destinatario       
            ConsCnpj := Alltrim(Substr(TRA->PEDGEF,059,14))  //Consignatario             
            Redesp   := Alltrim(Substr(TRA->PEDGEF,076,14))  //Redespacho
            xCliente := DestCnpj  //Default Destinatário
 
            ValidaFil(xValida) //VERIFICA FILIAL A SER IMPORTADA                  
            //MsgInfo("Filial Arquivo : "+_Filial+"  Filial Gefco : "+SM0->M0_CODFIL)
            
            If !xValida
               //MsgStop("Filial errada !")
               Return
            Endif

            // Documento Cancelado
               xCancel := Upper(Alltrim(Substr(TRA->PEDGEF,026,1)))  
            
            If xCancel <> "F"
		       DbselectArea("TRA")  
               DbSkip()
               Loop
            Endif
            
            // Cliente que pagara o documento
               xClipag := Alltrim(Substr(TRA->PEDGEF,073,2))  
            
            IF Alltrim(xClipag) == "R"
               xCliente := CnpjSC5 
               ValRem()         // Valida Remetente
            ENDIF

            IF Alltrim(xClipag) == "D"
               xCliente := DestCnpj
               ValDes()         // Valida Destinatário            
            ENDIF

            IF Alltrim(xClipag) == "C"               
               xCliente := ConsCnpj                               
               ValCon()         // Valida Consignatário
            ENDIF                        
            
            // Testa de a variavel esta vazia do cliente pagador
            If Empty(xCliente) 
               pos   := 10
        	   errata()       
               DbSelectArea("TRA")
               DbSkip()
               Loop
            EndIf
   
            // Tipo de Documento
               xTpDoc := Alltrim(Substr(TRA->PEDGEF,219,3))  //  CTRC/UNI/UNS
                        
            //If xTpDoc == "UNI"  // Apenas Nota Fiscal e Nf Serviço
               //ValDes()         // Valida Destinatário            
            //Else                // Apenas Ctrc´s
               //ValDes()         // Valida Destinatário            
               //ValCon()         // Valida Consignatário
               //ValRem()         // Valida Remetente
               //ValRed()         // Valida Redespacho
            //Endif            
            // Documento existente

            DbSelectArea("SC5")
            DbSetOrder(6) // Nova Ordem Filial+Serie+Documento      
            DbGotop()
            IF DbSeek(xFilial("SC5")+Substr(TRA->PEDGEF,004,3)+Substr(TRA->PEDGEF,012,6))  //SERIE+DOCUMENTO
               pos := 1
               errata()                           
   			   DbselectArea("TRA")  
               DbSkip()
               Loop
            Endif
            
            DbSelectArea("SA1")
            DbSetOrder(3)       
            DbGotop()
            If DbSeek(xFilial("SA1")+xCliente)                
            
               Item     := 1            
               cPedido  := GetSx8Num("SC5")               
            
               DbSelectArea("SC5")
               RecLock("SC5",.T.)
               SC5->C5_FILIAL  := xFilial("SC5")
               SC5->C5_NUM     := cPedido            
               SC5->C5_TIPO    := "N"
               SC5->C5_CLIENTE := SA1->A1_COD
               SC5->C5_LOJAENT := SA1->A1_LOJA 
               SC5->C5_LOJACLI := SA1->A1_LOJA 
               SC5->C5_TIPOCLI := SA1->A1_TIPO
               SC5->C5_CONDPAG := SA1->A1_COND
               SC5->C5_EMISSAO := Ctod(Substr(TRA->PEDGEF,018,2)+"/"+Substr(TRA->PEDGEF,020,2)+"/"+Substr(TRA->PEDGEF,022,4)) //Ddatabase
               SC5->C5_MENNOTA := " " 
               SC5->C5_MOEDA   := 1  
               SC5->C5_TIPLIB  := "1"  //"2"        
               SC5->C5_TPCARGA := "2"       
               SC5->C5_TXMOEDA := 1.00 //DEFAULT
               //SC5->C5_LIBEROK := "S"  //PEDIDO LIBERADO
               //
               //CAMPOS DE CONTROLE DO ARQUIVO IMPORTADO
               //
               SC5->C5_GEFSER  := Alltrim(Substr(TRA->PEDGEF,004,03)) 
               SC5->C5_GEFDOC  := Alltrim(Substr(TRA->PEDGEF,012,06)) 
               SC5->C5_GEFEMIS := Ctod(Substr(TRA->PEDGEF,018,2)+"/"+Substr(TRA->PEDGEF,020,2)+"/"+Substr(TRA->PEDGEF,022,4)) 
               SC5->C5_GSTATUS := Alltrim(Substr(TRA->PEDGEF,026,02)) 
               SC5->C5_PAGADOR := Alltrim(Substr(TRA->PEDGEF,073,02)) 
               SC5->C5_GEFFIL  := Alltrim(Substr(TRA->PEDGEF,007,05)) 
               SC5->C5_CCUSTO  := Alltrim(Substr(TRA->PEDGEF,222,10))  // C.CUSTO               
               SC5->C5_CCUSPSA := Alltrim(Substr(TRA->PEDGEF,304,20))  // C.CUSTO PSA               
               SC5->C5_REFGEFC := Alltrim(Substr(TRA->PEDGEF,232,20))  // REF. GEFCO
               SC5->C5_TPDESP  := Alltrim(Substr(TRA->PEDGEF,252,03))  // TIPO DE DESPESA
               SC5->C5_OIPSA   := Alltrim(Substr(TRA->PEDGEF,324,20))  // ORDEM INTERNA PSA                                
               //IF Val(Redesp) > 1
               //   SC5->C5_REDESP  := Redesp   // Cliente de redespacho
               //ENDIF
               MsUnlock()

               //
               //VERIFICAR          
               //SC5->C5_CLIENT  := ""   // Cliente de entrega (final)
               //SC5->C5_TPFRETE := "C"
               //SC5->C5_TABELA  := SA1->A1_TABELA                
               //
               // Itens do pedido           
               // REGRA DE BUSCA PELO ARQUIVO TEXTO - NOVA IMPORTAÇÃO
               // CFOP --> TES --> PRODUTO
               // xProd := Alltrim(GETMV("MV_PRODPAD")) //+ Space(15-Len(GETMV("MV_PRODPAD"))) // CODIGO PRODUTO PADRÃO
               // MVTes := GETMV("MV_TESSAI")            // CODIGO TES PADRÃO
               //
               // Implementada nova regra que define pelo cfop qual o produto a ser usado
               // Saulo - 15/12/2004
               
               xProd := Space(15)  
               xCfop := Alltrim(Substr(TRA->PEDGEF,090,10))
               Item  := 1                                         
               xUm   := " "
               xtes  := " "  
               xCF   := " "              
               xContinua := .T.               
                  
               DbSelectArea("SF4")
               DbSetOrder(3)
               IF DbSeek(xFilial("SF4")+xCfop)         // PESQ. POR CFOP    
                  xtes := Alltrim(SF4->F4_CODIGO)   
                  xCF  := Alltrim(SF4->F4_CF)                         
               Else
                  MsgInfo("TES não cadastrada para o CFOP : "+xCfop)
                  xContinua := .F.
            	  pos   := 10
                  errata()               
               EndIf
               
               
               DbSelectArea("SB1")
               DbSetOrder(8)
               DbGotop()
               If DbSeek(xFilial("SB1")+xtes)          // PESQ. POR TIPO DE SAIDA (B1_TS)    
                  xProd := SB1->B1_COD
                  xUm   := SB1->B1_UM   
               Else
                  MsgInfo("Produto não cadastrado com o CFOP : "+xCfop)
                  xContinua := .F.
            	  pos   := 4
                  errata()
               Endif               
 
               xValor := (Val(Substr(TRA->PEDGEF,121,14))/100)
               
               IF xContinua 

                  DbSelectArea("SC6")
                  RecLock("SC6",.T.)
                  SC6->C6_FILIAL  := xFilial("SC6")
                  SC6->C6_ITEM    := STRZERO(Item,2)
                  SC6->C6_PRODUTO := xProd
                  SC6->C6_UM      := IIF(EMPTY(xUm),"UN",xUm)
                  SC6->C6_QTDVEN  := 1 
                  SC6->C6_PRCVEN  := xValor
                  SC6->C6_VALOR   := (SC6->C6_QTDVEN * SC6->C6_PRCVEN) 
                  SC6->C6_TES     := xtes 
                  SC6->C6_CF      := xCfop //AvalCfo("SC6",xtes)
                  SC6->C6_LOCAL   := SB1->B1_LOCPAD      //"01" // Verificar de qual o almoxarifado ira sair o produto
                  SC6->C6_CLI     := SA1->A1_COD
                  SC6->C6_ENTREG  := DDATABASE //CTOD("  /  /  ")    // Data para entrega
                  SC6->C6_LOJA    := SA1->A1_LOJA        // Loja do cliente
                  SC6->C6_NUM     := cPedido             // SC5->C5_NUM
                  SC6->C6_DESCRI  := SB1->B1_DESC        //"DESCRICAO DO PRODUTO" // Pegar do cadastro de produtos
                  SC6->C6_TPOP    := "F"
                  SC6->C6_QTDLIB  := 1  // EM LIBERAÇÃO
                  SC6->C6_QTDENT  := 0
                  SC6->C6_QTDEMP  := 0  // LIBERADO                                
                  //SC6->C6_QTDLIB  := 0  // EM LIBERAÇÃO
                  //SC6->C6_QTDENT  := 0
                  //SC6->C6_QTDEMP  := 1  // LIBERADO              
                  MsUnlock()
                  
                  //Liberação do Pedido
                  /*               
                  DbSelectArea("SC9")
                  RecLock("SC9",.T.)
                  SC9->C9_FILIAL  := xFilial("SC9")
                  SC9->C9_ITEM    := STRZERO(Item,2)
                  SC9->C9_PRODUTO := xProd
                  SC9->C9_PEDIDO  := cPedido
                  SC9->C9_CLIENTE := SA1->A1_COD
                  SC9->C9_LOJA    := SA1->A1_LOJA
                  SC9->C9_QTDLIB  := 1    //LIBERADO              
                  SC9->C9_DATALIB := Ctod(Substr(TRA->PEDGEF,018,2)+"/"+Substr(TRA->PEDGEF,020,2)+"/"+Substr(TRA->PEDGEF,022,4)) //Ddatabase
                  SC9->C9_PRCVEN  := xValor
                  SC9->C9_LOCAL   := SB1->B1_LOCPAD
                  SC9->C9_SEQUEN  := "01"
                  SC9->C9_TPCARGA := "2"
                  MsUnlock()
                  ConfirmSX8() // CONFIRMA NUMERO DO PEDIDO SELECIONADO
                  */

               Else  
                  DbSelectArea("SC5")
                  RecLock("SC5",.F.)
                  DBdelete()
                  MsUnlock()
               Endif
               
               DbSelectArea("TRA")    
               DbSkip()
            
            Else
          	   
          	   DbSelectArea("TRA")
               DbSkip()
               Loop
               
            EndIf
    
 		EndIf
 		//
 		//RODAPE DOCUMENTO		
		If Substr(TRA->PEDGEF,1,3) == "9CD"
			DbselectArea("TRA")
			Dbskip()
			Loop
		EndIf 		
 		//
 		//OBSERVAÇÃO DOS DOCUMENTOS
		If Substr(TRA->PEDGEF,1,3) == "0CO"
			DbselectArea("TRA")
			Dbskip()
			Loop
		EndIf 		 		
 		//
 		//RODAPE DA OBSERVAÇÃO DOS DOCUMENTOS
		If Substr(TRA->PEDGEF,1,3) == "9CO"
			DbselectArea("TRA")
			Dbskip()
			Loop
		EndIf 		
 		//
 		//RODAPE DO ARQUIVO
		If Substr(TRA->PEDGEF,1,3) == "ZZZ"
			DbselectArea("TRA")
			Dbskip()
			Loop
			//Return
		EndIf
               
    Enddo                            
    
Endif

    fClose(nHdl)
    If pos == 0
	   MsgInfo("Importacao Concluida com Sucesso !!")
       DBCLOSEAREA("TRA")
       If xRenomeia 
          GravaSemErro( Arq02 )	       
       Endif   
    Else
   	   Alert("Importacao Concluida com OBS. !!")
	   Alert("Verificar ERRATA.LOG !!")
	   DBCLOSEAREA("TRA")
       If xRenomeia 
          GravaComErro( Arq02 )
       Endif   
  	   
    EndIf
    
    dbSelectArea("SA1")
	MSRUnlock()
	dbSelectArea("SA4")
	MSRUnlock()	                  
	dbSelectArea("SC5")
	MSRUnlock()
	dbSelectArea("SC6")
	MSRUnlock()
	dbSelectArea("SC9")
	MSRUnlock()

Return
           
//--------------------------------------------------------------------------------//
//  Cadastra Cliente
//--------------------------------------------------------------------------------// 		
Static Function MontaCliente()
    
    CnpjCli  := Alltrim(Substr(TRA->PEDGEF,352,14))         
    xTipo    := "F"
    xNomeCli := UPPER(Alltrim(Substr(TRA->PEDGEF,039,50)))

    DbSelectArea("SA1")
    DbSetOrder(3)       
    DbGotop()
    If .not. DbSeek(xFilial("SA1")+CnpjCli)
       pos   := 3
   	   errata()       
 
       //Converte o tipo do cliente
       If Alltrim(Substr(TRA->PEDGEF,525,2)) == "EX"  // EXPORTAÇÃO
          xTipo :="X"
       EndIf
       //
       If Alltrim(Substr(TRA->PEDGEF,525,2)) == "CF"  // CONS. FINAL
          xTipo :="F"
       EndIf       
       //
       If Alltrim(Substr(TRA->PEDGEF,525,2)) == "RE"  // REVENDEDOR
          xTipo :="R"              
       EndIf
    
       // GRAVA CLIENTES
       DbSelectArea("SA1")
       RecLock("SA1",.T.)
       SA1->A1_FILIAL := xFilial("SA1")
       SA1->A1_COD    := GetSx8Num("SA1")  // GETSXENUM("SA1","A1_COD") 
       SA1->A1_LOJA   := "01"
       SA1->A1_NATUREZ:= "500"
       SA1->A1_TIPO   := xTipo
       SA1->A1_CONTA  := "112101"  // VERIFICAR CONTA CONTABABIL. 
       SA1->A1_GRUPO  := "4"
       SA1->A1_GSECON := "121"
       SA1->A1_COND   := "004"
       SA1->A1_CCONT  := "315501"
       SA1->A1_CGC    := CnpjCli
       SA1->A1_INSCR  := Alltrim(Substr(TRA->PEDGEF,322,15))
       SA1->A1_INSCRM := Alltrim(Substr(TRA->PEDGEF,337,15))
       SA1->A1_NOME   := UPPER(Alltrim(Substr(TRA->PEDGEF,039,50)))
       SA1->A1_NREDUZ := UPPER(Alltrim(Substr(TRA->PEDGEF,039,50)))
       SA1->A1_END    := UPPER(Alltrim(Substr(TRA->PEDGEF,089,50)))
       SA1->A1_CEP    := Alltrim(Substr(TRA->PEDGEF,189,10))
       SA1->A1_MUN    := UPPER(Alltrim(Substr(TRA->PEDGEF,139,30)))
       SA1->A1_EST    := UPPER(Alltrim(Substr(TRA->PEDGEF,199,04)))
       SA1->A1_TEL    := Alltrim(Substr(TRA->PEDGEF,429,15))
       SA1->A1_FAX    := Alltrim(Substr(TRA->PEDGEF,444,15))
       SA1->A1_EMAIL  := Alltrim(Substr(TRA->PEDGEF,459,50))
       SA1->A1_BAIRRO := UPPER(Alltrim(Substr(TRA->PEDGEF,288,20)))       
    
       // FORMA DE FATURAMENTO
       // B= BOLETO , F=FATURA , A=AMBOS , N= NENHUM                 
       IF Alltrim(Substr(TRA->PEDGEF,527,1)) == "F"
          SA1->A1_FATURA := "S"
          SA1->A1_BOLETO := "N"
       EndIf
       //
       IF Alltrim(Substr(TRA->PEDGEF,527,1)) == "B"
          SA1->A1_FATURA := "N"
          SA1->A1_BOLETO := "S"
       EndIf
       //
       IF Alltrim(Substr(TRA->PEDGEF,527,1)) == "A"
          SA1->A1_FATURA := "S"
          SA1->A1_BOLETO := "S"
       EndIf
    
       //DADOS DE COBRANÇA
       SA1->A1_ENDCOB := UPPER(Alltrim(Substr(TRA->PEDGEF,208,50)))
       SA1->A1_BAIRROC:= UPPER(Alltrim(Substr(TRA->PEDGEF,288,20)))
       SA1->A1_MUNC   := UPPER(Alltrim(Substr(TRA->PEDGEF,258,30)))
       SA1->A1_ESTC   := UPPER(Alltrim(Substr(TRA->PEDGEF,318,04)))
       SA1->A1_CEPC   := Alltrim(Substr(TRA->PEDGEF,308,10))
       xPessoa        := IIF(LEN(SA1->A1_CGC) ==14,"J","R")                                                   
       SA1->A1_PESSOA := xPessoa
       //cCliente       := SA1->A1_COD     
       //cLoja          := SA1->A1_LOJA
       
       MSUnLock()
       ConfirmSx8() 
       
    Endif

Return

//--------------------------------------------------------------------------------//
//  Cadastra Transportadora
//--------------------------------------------------------------------------------// 		
Static Function MontaTransp()
    
    xVia  := " "
    CnpjTr :=  Alltrim(Substr(TRA->PEDGEF,239,14))
    
    DbSelectArea("SA4")
    DbSetOrder(3)       
    DbGotop()
    If .not. DbSeek(xFilial("SA4")+CnpjTr)  	   
  	   pos   := 2
       errata()             
       xTemp := Alltrim(Substr(TRA->PEDGEF,253,1))                         

        Do Case   	                          
		  Case Alltrim(xTemp) == "A"
			   xVia  := "AEREO"
          Case Alltrim(xTemp) == "M"
			   xVia  := "MARITIMO"
          Case Alltrim(xTemp) == "F"
			   xVia  := "FERROVIARIO"
          Case Alltrim(xTemp) == "R"
			   xVia  := "RODOVIARIO"
          Case Alltrim(xTemp) == "O"
			   xVia  := "OPER. LOGISTICO"
          Case Alltrim(xTemp) == "C"
			   xVia  := "COURRIER"				 
          Otherwise
			   xVia  := " "				 			   
	   EndCase                
   
       RecLock("SA4",.T.)
       SA4->A4_FILIAL := xFilial("SA4")
       SA4->A4_COD    := GETSXENUM("SA4","A4_COD") 
       SA4->A4_CGC    := Alltrim(Substr(TRA->PEDGEF,239,14))
       SA4->A4_NOME   := UPPER(Alltrim(Substr(TRA->PEDGEF,039,50)))
       SA4->A4_NREDUZ := UPPER(Alltrim(Substr(TRA->PEDGEF,039,50)))
       SA4->A4_END    := UPPER(Alltrim(Substr(TRA->PEDGEF,089,50)))
       SA4->A4_MUN    := UPPER(Alltrim(Substr(TRA->PEDGEF,139,30)))
       SA4->A4_EST    := UPPER(Alltrim(Substr(TRA->PEDGEF,199,04)))       
       SA4->A4_TEL    := Alltrim(Substr(TRA->PEDGEF,254,15))       
       SA4->A4_TELEX  := Alltrim(Substr(TRA->PEDGEF,269,15))       
       SA4->A4_EMAIL  := Alltrim(Substr(TRA->PEDGEF,284,50))              
       ConfirmSx8()                  
    Endif

Return

//--------------------------------------------------------------------------------//
//  Log de Erros da Importação
//--------------------------------------------------------------------------------// 		
Static Function Errata()

If pos == 1
	te1:="Serie/Documento ja existente..: "+Substr(TRA->PEDGEF,004,3)+"/"+Substr(TRA->PEDGEF,012,6)+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 2
	te1:="Transportadora Cadastrada : "+CnpjTr+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 3
	te1:="Cliente Cadastrado : "+xNomeCli+" - CNPJ :"+CnpjCli+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 4
	te1:="Produto não cadastrado para o CFOP : "+xCfop+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 5
	te1:="Cnpj Remetente nao Existe "+CnpjSC5+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 6
	te1:="Cnpj Destinatario nao Existe "+DestCnpj+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 7
	te1:="Cnpj Consignatario nao Existe "+ConsCnpj+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 8
	te1:="Cnpj Redespacho nao Existe "+Redesp+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 9
	te1:="FILIAL NÃO CONFERE COM O ARQUIVO A SER IMPORTADO ! "+_Filial+" (GEFCO) - "+SM0->M0_CODFIL+" (SIGA)"+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 10
	te1:="Pedido Não Importado para o Cnpj : "+xCliente+cNL
	fWrite(nHdl,te1,Len(te1))
Endif

Return

//--------------------------------------------------------------------------------//
// Valida Filial a ser Importada 
//--------------------------------------------------------------------------------// 		
Static Function ValidaFil()
   
   _Filial := Alltrim(Substr(TRA->PEDGEF,007,03)) // Filial 
   _FilGef := ""
   xValida := .T.
   
   Do case
      case _Filial == "TJ1"
           _FilGef := "01"
     
      case _Filial == "RA1"      
           _FilGef := "02"
           
      case _Filial == "PL1"
           _FilGef := "03"
           
      case _Filial == "BI1"      
           _FilGef := "04"
           
      case _Filial == "DQ1"
           _FilGef := "05"
                 
      case _Filial == "VV1"      
           _FilGef := "06"
           
      case _Filial == "JP1"
           _FilGef := "07"
           
      case _Filial == "PS1"      
           _FilGef := "08"
                 
     // case _Filial == "---"  // SEM CODIGO DEFINIDO 26/10/04
     //      _FilGef := "09"
                 
      case _Filial == "SEP"      
           _FilGef := "10"
                 
      case _Filial == "GC1"
           _FilGef := "11"
              
   EndCase

   //Msginfo(xFilial())
   
   IF _FilGef == SM0->M0_CODFIL
      xValida := .T.
   Else
      pos   := 9
      errata()                    
      xValida := .F.   
      //MSGINFO("FILIAL NÃO CONFERE COM O ARQUIVO A SER IMPORTADO !")   
   ENDIF
   
Return(xValida)

//--------------------------------------------------------------------------------//
// Valida Cliente Remetente
//--------------------------------------------------------------------------------// 		
Static Function ValRem()
      
  DbSelectArea("SA1")
  DbSetOrder(3)       
  DbGotop() 
  If !DbSeek(xFilial("SA1")+CnpjSC5)                
     pos := 5
     errata()
     DbselectArea("TRA")
     Dbskip()
	 //Loop     
  Endif
            

Return

//--------------------------------------------------------------------------------//
// Valida Cliente Consignatário
//--------------------------------------------------------------------------------// 		
Static Function ValCon()
      
  DbSelectArea("SA1")
  DbSetOrder(3)       
  DbGotop()
  If !DbSeek(xFilial("SA1")+ConsCnpj)                
     pos := 7
     errata()            
     DbselectArea("TRA")
     Dbskip()
     //Loop               
  Endif
            
Return

//--------------------------------------------------------------------------------//
// Valida Cliente Destinatário
//--------------------------------------------------------------------------------// 		
Static Function ValDes()
      
  DbSelectArea("SA1")
  DbSetOrder(3)       
  DbGotop()
  If !DbSeek(xFilial("SA1")+DestCnpj)                
     pos := 6
     errata()            
     DbselectArea("TRA")
     Dbskip()
     //Loop               
  Endif            

Return

//--------------------------------------------------------------------------------//
// Valida Cliente Redespacho
//--------------------------------------------------------------------------------// 		
Static Function ValRed()
      
  DbSelectArea("SA1")
  DbSetOrder(3)       
  DbGotop()
  If !DbSeek(xFilial("SA1")+Redesp)                
     pos := 8
     errata()            
     DbselectArea("TRA")
     Dbskip()
     //Loop               
  Endif            


Return

//--------------------------------------------------------------------------------//
// Função para renomear os arquivos com problemas na importação
//--------------------------------------------------------------------------------// 		
STATIC FUNCTION GravaComErro( Arq02 )
  cNewArq := StrTran( UPPER( Arq02 ),".TXT", ".ERR" )
  FRename( Arq02, cNewArq )
Return

STATIC FUNCTION GravaSemErro( Arq02 )
  cNewArq := StrTran( UPPER( Arq02 ), ".TXT", ".OK" )
  FRename( Arq02, cNewArq )
Return

//--------------------------------------------------------------------------------//
// Cadastra Cliente via ExecAuto
//--------------------------------------------------------------------------------// 		
Static Function Cliente(nOpc)
Local aMATA030 := {}

xPessoa := IIF(LEN(SA1->A1_CGC) ==14,"J","R")                                                   
xModelo := Alltrim(Substr(TRA->PEDGEF,527,1))         // Boleto/Fatura/Ambos
xTipo   := "F"

//Converte o tipo do cliente
  If Alltrim(Substr(TRA->PEDGEF,525,2)) == "EX"  // EXPORTAÇÃO
     xTipo :="X"
  EndIf
  If Alltrim(Substr(TRA->PEDGEF,525,2)) == "CF"  // CONS. FINAL
     xTipo :="F"
  EndIf       
  If Alltrim(Substr(TRA->PEDGEF,525,2)) == "RE"  // REVENDEDOR
     xTipo :="R"              
  EndIf
      
aMATA030:={ {"A1_COD"       ,GetSx8Num("SA1")                            ,Nil},; // Codigo       C 06
  	  	    {"A1_LOJA"      ,"01"                                        ,Nil},; // Loja         C 02
 		    {"A1_PESSOA"    ,xPessoa                                     ,Nil},; // Pessoa       C 02
		    {"A1_NOME"      ,UPPER(Alltrim(Substr(TRA->PEDGEF,039,50)))  ,Nil},; // Nome         C 40
		    {"A1_NREDUZ"    ,UPPER(Alltrim(Substr(TRA->PEDGEF,039,50)))  ,Nil},; // Nome reduz.  C 20
		    {"A1_TIPO"      ,xTipo     	                                 ,Nil},; // Tipo         C 01 //R Revendedor
		    {"A1_END"       ,UPPER(Alltrim(Substr(TRA->PEDGEF,089,50)))  ,Nil},; // Endereco     C 40
		    {"A1_MUN"       ,UPPER(Alltrim(Substr(TRA->PEDGEF,139,30)))  ,Nil},; // Cidade       C 15				 
			{"A1_NATUREZ"   ,"500"                                       ,Nil},; 
			{"A1_CONTA"     ,"112101"                                    ,Nil},; 
			{"A1_GRUPO"     ,"4"                                         ,Nil},; 
			{"A1_GSECON"    ,"121"                                       ,Nil},; 
			{"A1_COND"      ,"004"                                       ,Nil},; 
			{"A1_CCONT"     ,"315501"                                    ,Nil},;
			{"A1_CGC"       ,Alltrim(Substr(TRA->PEDGEF,353,14))         ,Nil},; 
			{"A1_INSCR"     ,Alltrim(Substr(TRA->PEDGEF,322,15))         ,Nil},; 
			{"A1_INSCRM"    ,Alltrim(Substr(TRA->PEDGEF,337,15))         ,Nil},; 
			{"A1_CEP"       ,Alltrim(Substr(TRA->PEDGEF,189,10))         ,Nil},;
			{"A1_TEL"       ,Alltrim(Substr(TRA->PEDGEF,429,15))         ,Nil},;
			{"A1_FAX"       ,Alltrim(Substr(TRA->PEDGEF,444,15))         ,Nil},;
			{"A1_EMAIL"     ,UPPER(Alltrim(Substr(TRA->PEDGEF,459,50)))  ,Nil},;				 				 
			{"A1_BAIRRO"    ,UPPER(Alltrim(Substr(TRA->PEDGEF,288,20)))  ,Nil},;
			{"A1_ENDCOB"    ,UPPER(Alltrim(Substr(TRA->PEDGEF,208,50)))  ,Nil},;
			{"A1_BAIRROC"   ,UPPER(Alltrim(Substr(TRA->PEDGEF,288,20)))  ,Nil},;
			{"A1_MUNC"      ,UPPER(Alltrim(Substr(TRA->PEDGEF,258,30)))  ,Nil},;				 				 				 				 
			{"A1_ESTC"      ,UPPER(Alltrim(Substr(TRA->PEDGEF,318,04)))  ,Nil},;
			{"A1_CEPC"      ,Alltrim(Substr(TRA->PEDGEF,308,10))         ,Nil},;
			{"A1_FATURA"    ,IIF(xModelo=="F" .Or. xModelo=="A","S","N") ,Nil},;
			{"A1_BOLETO"    ,IIF(xModelo=="B" .Or. xModelo=="A","S","N") ,Nil},;				 				 
			{"A1_EST"       ,UPPER(Alltrim(Substr(TRA->PEDGEF,199,04)))  ,Nil}} 

MSExecAuto({|x,y| mata030(x,y)},aMATA030,nOpc) 
If lMsErroAuto
   DisarmTransaction()
   break
EndIf

Return 

// Nova Função Pedido
Static Function PedVend(nOpc)
Local aCabPV := {}
Local aItemPV:= {}
//Cabecalho
aCabPV:={{"C5_NUM"    ,cNumPed    ,Nil},; // Numero do pedido
			 {"C5_CLIENTE","999999"    ,Nil},; // Codigo do cliente
			 {"C5_LOJAENT","00"        ,Nil},; // Loja para entrada
			 {"C5_LOJACLI","00"        ,Nil},; // Loja do cliente
			 {"C5_EMISSAO",dDatabase   ,Nil},; // Data de emissao
			 {"C5_TIPO"   ,"N"         ,Nil},; // Tipo de pedido
			 {"C5_TABELA" ,"7"        ,Nil},; // Codigo da Tabela de Preco
			 {"C5_CONDPAG","001"       ,Nil},; // Codigo da condicao de pagamanto*
			 {"C5_DESC1"  ,0           ,Nil},; // Percentual de Desconto
			 {"C5_INCISS" ,"N"         ,Nil},; // ISS Incluso
			 {"C5_TIPLIB" ,"1"         ,Nil},; // Tipo de Liberacao
			 {"C5_MOEDA"  ,1           ,Nil},; // Moeda
			 {"C5_LIBEROK","S"         ,Nil}} // Liberacao Total
//Items
aItemPV:={{"C6_NUM"    ,cNumped           ,Nil},; // Numero do Pedido
  			 {"C6_ITEM"   ,"01"              ,Nil},; // Numero do Item no Pedido
			 {"C6_PRODUTO","999999999999999" ,Nil},; // Codigo do Produto
			 {"C6_QTDVEN" ,1                 ,Nil},; // Quantidade Vendida
			 {"C6_PRUNIT"  ,0                ,Nil},; // PRECO DE LISTA
			 {"C6_PRCVEN" ,100               ,Nil},; // Preco Unitario Liquido
			 {"C6_VALOR"  ,100               ,Nil},; // Valor Total do Item
			 {"C6_ENTREG" ,dDataBase         ,Nil},; // Data da Entrega
			 {"C6_UM"     ,"UN"              ,Nil},; // Unidade de Medida Primar.
			 {"C6_TES"    ,"510"             ,Nil},; // Tipo de Entrada/Saida do Item
			 {"C6_LOCAL"  ,"01"              ,Nil},; // Almoxarifado
			 {"C6_DESCONT",1                 ,Nil},; // Percentual de Desconto
			 {"C6_COMIS1" ,0                 ,Nil},; // Comissao Vendedor
			 {"C6_CLI"    ,"000001"          ,Nil},; // Cliente
			 {"C6_LOJA"   ,"00"              ,Nil},; // Loja do Cliente
			 {"C6_QTDEMP" ,1                 ,Nil},; // Quantidade Empenhada
			 {"C6_QTDLIB" ,1                 ,Nil}}  // Quantidade Liberada

//Mata410(aCabPv,{aItemPV},3)

MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,{aItemPV},nOpc)

If lMsErroAuto
   DisarmTransaction()
   break
EndIf

Return

//--------------------------------------------------------------------------------//
// Valida Filial a ser Importada 
//--------------------------------------------------------------------------------// 		
/*
** MICROSIGA       ** GEFCO
01 - MATRIZ           TJ1
02 - CAJU             RA1
03 - P.REAL           PL1
04 - BARUERI          BI1
05 - D. CAXIAS        DQ1
06 - SAO PAULO        VV1
07 - S.J PINHAIS      JP1
08 - CAMPINAS         PS1
09 - CONTAGEM         ---
10 - SEPETIBA         SEP
11 - GAZETA           GC1
/*