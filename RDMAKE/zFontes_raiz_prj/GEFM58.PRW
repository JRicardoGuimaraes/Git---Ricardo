#include "rwmake.ch"    


User Function GEFM58()   

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
arqimp  := SPACE(80)
cFile	:= Space(80)
Ctrc    := Space(1) 

xRelease  := GetMv("MV_HISTVER")  // Versão do Centro de custo (2005 ou 2006)
xTamcc    := IIF(xRelease == "2005",7,10)   // Tamanho do centro de custo para faturamento
xCustoOld :=" "
MSReg     := 0
xCusto    := Space(10)
xCustoNew := Space(10)
lCusReduz := .T.
xEspecie  := ""
xTamSrv   := 0
nAliq     := 0

@ 000,000 To 250,370 Dialog oDlg Title "GEFCO - IMPORTA€AO DE NOTAS Versão 3.5"
@ 003,016 To 60,144
@ 010,021 Say OemToAnsi("OS ARQUIVOS PARA IMPORTAÇÃO DEVEM SER")
@ 022,021 Say OemToAnsi("USADOS NA PASTA (IMPORTAR) DO SERVIDOR !!!")
@ 010,152 BmpButton Type 1 Action OBJ()
@ 030,152 BmpButton Type 2 Action Close(oDlg)
Activate Dialog oDlg Centered

Return

Static Function OBJ()
cDir    := Space(250)
cPath   := "Selecione diretório"

@ 000,000 TO 250,450 DIALOG oDlg1 TITLE "IMPORTACAO DE DADOS - Versão 3.5"
@ 016,010 TO 67,180 TITLE "Importacao de dados"
@ 023,011 RADIO aRadio VAR nRadio
@ 080,010 BUTTON "_Ok" SIZE 35,15 ACTION Import() 
@ 080,050 BUTTON "_Cancel" SIZE 35,15 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER

Return

Static Function Import()

pos  := 0
cNL  := CHR(13)+CHR(10)
xarq := " "

IF nRadio == 2
   Do Case
      Case cFilAnt == "01"
           xarq:= "\Importar\Matriz\GEFCNOTA.TXT  "
      Case cFilAnt == "02"
           xarq:= "\Importar\Beneditinos\GEFCNOTA.TXT  "
      Case cFilAnt == "03"
           xarq:=  "\Importar\PortoReal\GEFCNOTA.TXT  "
      Case cFilAnt == "04"
           xarq:=  "\Importar\Barueri\GEFCNOTA.TXT  "
      Case cFilAnt == "05"
           xarq:=  "\Importar\DquedeCaxias\GEFCNOTA.TXT  
      Case cFilAnt == "06"
           xarq:=  "\Importar\VilaGuilherme\GEFCNOTA.TXT   "
      Case cFilAnt == "07"
           xarq:=  "\Importar\Curitiba\GEFCNOTA.TXT   "
      Case cFilAnt == "08"
           xarq:=  "\Importar\Campinas\GEFCNOTA.TXT   "
      Case cFilAnt == "09"
           xarq:=  "\Importar\Contagem\GEFCNOTA.TXT   "
      Case cFilAnt == "10"
           xarq:=  "\Importar\Sepetiba\GEFCNOTA.TXT   "
      Case cFilAnt == "11"
           xarq:=  "\Importar\VilaOlimpia\GEFCNOTA.TXT   "
      Case cFilAnt == "12"
           xarq:= "\Importar\Santos\GEFCNOTA.TXT   "
      Case cFilAnt == "13"
           xarq:=  "\Importar\RioBranco45\GEFCNOTA.TXT   "
      OtherWise
           MsgStop("Copiar Arquivo para a pasta da Filial : " +cFilAnt + " !!")
           pos  := 1
           Return
   EndCase
Endif                                                                                    

IF nRadio == 1             	      
   Do Case
      Case cFilAnt == "01"
           xarq:= "\Importar\Matriz\GEFCCTRC.TXT   " 
      Case cFilAnt == "02"
           xarq:= "\Importar\Beneditinos\GEFCCTRC.TXT   " 
      Case cFilAnt == "03"
           xarq:= "\Importar\PortoReal\GEFCCTRC.TXT   " 
      Case cFilAnt == "04"
           xarq:= "\Importar\Barueri\GEFCCTRC.TXT   " 
      Case cFilAnt == "05"
           xarq:= "\Importar\DquedeCaxias\GEFCCTRC.TXT   " 
      Case cFilAnt == "06"
           xarq:= "\Importar\VilaGuilherme\GEFCCTRC.TXT   " 
      Case cFilAnt == "07"
           xarq:= "\Importar\Curitiba\GEFCCTRC.TXT   " 
      Case cFilAnt == "08"
           xarq:= "\Importar\Campinas\GEFCCTRC.TXT   " 
      Case cFilAnt == "09"
           xarq:= "\Importar\Contagem\GEFCCTRC.TXT   " 
      Case cFilAnt == "10"
           xarq:= "\Importar\Sepetiba\GEFCCTRC.TXT   " 
      Case cFilAnt == "11"
           xarq:= "\Importar\VilaOlimpia\GEFCCTRC.TXT   " 
      Case cFilAnt == "12"
           xarq:= "\Importar\Santos\GEFCCTRC.TXT   " 
      Case cFilAnt == "13"
           xarq:= "\Importar\RioBranco45\GEFCCTRC.TXT   " 	      
      
      OtherWise
           MsgStop("Copiar Arquivo para a pasta da Filial : " +cFilAnt + " !!")
   	           pos  := 1
           Return
   EndCase

Endif                                                                                    

IF nRadio == 3
   Do Case
      Case cFilAnt == "01"
           xarq:= "\Importar\Matriz\GEFCONFS.TXT   "
      Case cFilAnt == "02"
            xarq:= "\Importar\Beneditinos\GEFCONFS.TXT   "
      Case cFilAnt == "03"
           xarq:= "\Importar\PortoReal\GEFCONFS.TXT   "
      Case cFilAnt == "04"
           xarq:= "\Importar\Barueri\GEFCONFS.TXT   "
      Case cFilAnt == "05"
           xarq:= "\Importar\DquedeCaxias\GEFCONFS.TXT   "
      Case cFilAnt == "06"
           xarq:= "\Importar\VilaGuilherme\GEFCONFS.TXT   "
      Case cFilAnt == "07"
           xarq:= "\Importar\Curitiba\GEFCONFS.TXT   "
      Case cFilAnt == "08"
           xarq:= "\Importar\Campinas\GEFCONFS.TXT   "
      Case cFilAnt == "09"
           xarq:= "\Importar\Contagem\GEFCONFS.TXT   "
      Case cFilAnt == "10"
           xarq:= "\Importar\Sepetiba\GEFCONFS.TXT   "
      Case cFilAnt == "11"
           xarq:= "\Importar\VilaOlimpia\GEFCONFS.TXT   "
      Case cFilAnt == "12"
           xarq:= "\Importar\Santos\GEFCONFS.TXT   "
      Case cFilAnt == "13"
           xarq:= "\Importar\RioBranco45\GEFCONFS.TXT   "	      
      OtherWise
           MsgStop("Copiar Arquivo para a pasta da Filial : " +cFilAnt + " !!")
           pos  := 1
           Return
   EndCase
   
Endif                                                                                    

_xVer   := ""     
Arqxx   := xarq
nHdxx   := NIL
ntamxx  := 300     
nHdxx   := fopen(Arqxx)
cbufferx:= space(ntamxx)
nbytesx := 0
nbytesx := fRead(nHdxx,@cbufferx,ntamxx)
_xVer   := Substr(cbufferx,033,5)
Fclose(nHdxx)

//  Nova Rotina para contab. novas series   
   Gefcofil := xFilial()
IF Gefcofil == "02"
   _xloc := "CJ"
EndIF 

If Substr(Alltrim(_xVer),1,3) == "VA3"              // VERSÃO 3 11/2005
   Processa({|| ProcTxt()},"Processando...VA3") 
   Close(oDlg)
   Close(oDlg1)
Endif

Return


Static Function ProcTxt()  // Versão VA2/VA3

pos  := 0
cNL  := CHR(13)+CHR(10)


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
	te1:="Criacao do arquivo de erros gerados pelo sistema de importacao - Data: "+dtoc(ddatabase)+" Hora : "+Time()+cNL
	fWrite(nHdl,te1,Len(te1))
	te1:="Arquivo Importado : "+xarq+" Filial : "+SM0->M0_FILIAL+cNL
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
	
	DbUseArea(.T.,,_cNome,"TRA",.F. )
	DbSelectArea("TRA")
	cIndex := CriaTrab(nil,.f.)
	cChave := "NF+CDCLI"
	nIndex :=IndRegua("TRA",cIndex,cChave,,,"Selecionando Registros...TRA")
	
	IF nRadio == 2
	   Do Case
	      Case cFilAnt == "01"
               Append from \Importar\Matriz\GEFCNOTA.TXT sdf
	      Case cFilAnt == "02"
               Append from \Importar\Beneditinos\GEFCNOTA.TXT sdf
	      Case cFilAnt == "03"
               Append from \Importar\PortoReal\GEFCNOTA.TXT sdf
	      Case cFilAnt == "04"
               Append from \Importar\Barueri\GEFCNOTA.TXT sdf
	      Case cFilAnt == "05"
               Append from \Importar\DquedeCaxias\GEFCNOTA.TXT sdf
	      Case cFilAnt == "06"
               Append from \Importar\VilaGuilherme\GEFCNOTA.TXT sdf
	      Case cFilAnt == "07"
               Append from \Importar\Curitiba\GEFCNOTA.TXT sdf
	      Case cFilAnt == "08"
               Append from \Importar\Campinas\GEFCNOTA.TXT sdf
	      Case cFilAnt == "09"
               Append from \Importar\Contagem\GEFCNOTA.TXT sdf
	      Case cFilAnt == "10"
               Append from \Importar\Sepetiba\GEFCNOTA.TXT sdf
	      Case cFilAnt == "11"
               Append from \Importar\VilaOlimpia\GEFCNOTA.TXT sdf
	      Case cFilAnt == "12"
               Append from \Importar\Santos\GEFCNOTA.TXT sdf
	      Case cFilAnt == "13"
               Append from \Importar\RioBranco45\GEFCNOTA.TXT sdf
	      OtherWise
	           MsgStop("Arquivo/Filial não encontrado !!")
	           pos  := 1
	           Return
	   EndCase

	Endif                                                                                    

	IF nRadio == 1             	   
	   Do Case
	      Case cFilAnt == "01"
               Append from \Importar\Matriz\GEFCCTRC.TXT SDF 
	      Case cFilAnt == "02"
               Append from \Importar\Beneditinos\GEFCCTRC.TXT SDF 
	      Case cFilAnt == "03"
               Append from \Importar\PortoReal\GEFCCTRC.TXT SDF 
	      Case cFilAnt == "04"
               Append from \Importar\Barueri\GEFCCTRC.TXT SDF 
	      Case cFilAnt == "05"
               Append from \Importar\DquedeCaxias\GEFCCTRC.TXT SDF 
	      Case cFilAnt == "06"
               Append from \Importar\VilaGuilherme\GEFCCTRC.TXT SDF 
	      Case cFilAnt == "07"
               Append from \Importar\Curitiba\GEFCCTRC.TXT SDF 
	      Case cFilAnt == "08"
               Append from \Importar\Campinas\GEFCCTRC.TXT SDF 
	      Case cFilAnt == "09"
               Append from \Importar\Contagem\GEFCCTRC.TXT SDF 
	      Case cFilAnt == "10"
               Append from \Importar\Sepetiba\GEFCCTRC.TXT SDF 
	      Case cFilAnt == "11"
               Append from \Importar\VilaOlimpia\GEFCCTRC.TXT SDF 
	      Case cFilAnt == "12"
               Append from \Importar\Santos\GEFCCTRC.TXT SDF 
	      Case cFilAnt == "13"
               Append from \Importar\RioBranco45\GEFCCTRC.TXT SDF 	      
	      
	      OtherWise
	           MsgStop("Arquivo/Filial não encontrado !!")
   	           pos  := 1
	           Return
	   EndCase

	Endif                                                                                    

	IF nRadio == 3
	   Do Case
	      Case cFilAnt == "01"
               Append from \Importar\Matriz\GEFCONFS.TXT sdf
	      Case cFilAnt == "02"
               Append from \Importar\Beneditinos\GEFCONFS.TXT sdf
	      Case cFilAnt == "03"
               Append from \Importar\PortoReal\GEFCONFS.TXT sdf
	      Case cFilAnt == "04"
               Append from \Importar\Barueri\GEFCONFS.TXT sdf
	      Case cFilAnt == "05"
               Append from \Importar\DquedeCaxias\GEFCONFS.TXT sdf
	      Case cFilAnt == "06"
               Append from \Importar\VilaGuilherme\GEFCONFS.TXT sdf
	      Case cFilAnt == "07"
               Append from \Importar\Curitiba\GEFCONFS.TXT sdf
	      Case cFilAnt == "08"
               Append from \Importar\Campinas\GEFCONFS.TXT sdf
	      Case cFilAnt == "09"
               Append from \Importar\Contagem\GEFCONFS.TXT sdf
	      Case cFilAnt == "10"
               Append from \Importar\Sepetiba\GEFCONFS.TXT sdf
	      Case cFilAnt == "11"
               Append from \Importar\VilaOlimpia\GEFCONFS.TXT sdf
	      Case cFilAnt == "12"
               Append from \Importar\Santos\GEFCONFS.TXT sdf
	      Case cFilAnt == "13"
               Append from \Importar\RioBranco45\GEFCONFS.TXT sdf	      
	      OtherWise
	           MsgStop("Arquivo/Filial não encontrado !!")
	           pos  := 1
	           Return
	   EndCase
	   
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
			DbselectArea("TRA")
			Dbskip()
			Loop
		EndIf	
		
		If TRA->INDICE == 99
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
		/*
		DbSelectArea("SE1")
		If (DbSeek(xFilial("SE1")+TRA->TPDOC+TRA->NF))  //PARA NOTAS FISCAIS
			pos   := 1
			errata()
    		error := 1
			DbselectArea("TRA")
			Dbskip()
			Loop
		Endif
		*/
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

        nAliq := Val(Substr(TRA->ALICM,1,Len(TRA->ALICM)-2)+"."+Substr(TRA->ALICM,Len(TRA->ALICM)-1,2))
        
        If nAliq < 1
           pos   := 20
	       errata()
    	   error := 1			
		   DbselectArea("TRA")
		   Dbskip()
		   Loop		        
        Endif
        
        //
        // Tratamento de Notas Simples Rem. (apenas livro fiscal) - 11/10/04
 		//
 		//IF nRadio == 1             	      	 	
	 		xCodFis := Alltrim(MV_PAR01)
	 		If Alltrim(TRA->CDFIS) $ "5910/5915/5921/5949/6902/6903/6915/6921/6949" // Adicionado cod.5910 em 25/10/04 		
	 		//If Alltrim(TRA->CDFIS) $ "5910/5915/5921/5949/6902/6903/6915/6921/6949/5552/5553/5556/5901/5902/5908/5909/5913/6210/6553/6556/6909/6910/6913/6916/5916" // Adicionado cod.5910 em 25/10/04 ; mais cfop(19/05/06) 
			   fiscal()
			   error := 1		
			   DbselectArea("TRA")
			   Dbskip()
			   Loop
	        EndIf
	        
	        //If Alltrim(TRA->CDFIS) $ "5552/5553/5556/5901/5902/5908/5909/5913/6210" 
	        If Alltrim(TRA->CDFIS) $ "5901/5902/5908/5909/5913/6210" 
			   fiscal()
			   error := 1		
			   DbselectArea("TRA")
			   Dbskip()
			   Loop
	        EndIf

	        If Alltrim(TRA->CDFIS) == "5552" .Or. Alltrim(TRA->CDFIS) == "5553" .Or. Alltrim(TRA->CDFIS) == "5556" .Or. Alltrim(TRA->CDFIS) == "6553" .Or. Alltrim(TRA->CDFIS) == "6556"
			   fiscal()
			   error := 1		
			   DbselectArea("TRA")
			   Dbskip()
			   Loop
	        EndIf
	        
	        //If Alltrim(TRA->CDFIS) $ "6553/6556/6909/6910/6913/6916/5916"
	        If Alltrim(TRA->CDFIS) $ "6909/6910/6913/6916/5916"
			   fiscal()
			   error := 1		
			   DbselectArea("TRA")
			   Dbskip()
			   Loop
	        EndIf
	    //EndIf

        /////////////////////////
        // Venda de Ativo Fixo //
        /////////////////////////
        If Alltrim(TRA->CDFIS) == "5551" .Or. Alltrim(TRA->CDFIS) == "6551"
           xNatur := "505" 
           lPisCof   := .F.            	            
           lCusReduz := .F.
        Endif
        
        If lCusReduz
          If Len(xCusto) < xTamcc //.And. !lCusReduz //!(Alltrim(TRA->CDFIS) $ "5551/6551")	       	       
	        DbSelectArea("SZ3")  // Atualizado para CTB
	    	DbSetOrder(1)	
	        DbGotop()			
    		If DbSeek(xFilial("SZ3")+xCusto)			        
	           xCustoOld := xCusto
	           xCusto := SZ3->Z3_CUSTO
	           MSReg++
	        Else	        
	           pos   := 16
			   errata()
	    	   error := 1			
			   DbselectArea("TRA")
			   Dbskip()
			   Loop		        		        
	        Endif	        
          Endif                        
        Endif                        
                
        // c.custo bloqueados - Saulo 13/07/05
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
      	//
        If CTT->CTT_BLOQ == "1"
            pos   := 18
			errata()
    		error := 1			
			DbselectArea("TRA")
			Dbskip()
			Loop		        
        Endif        

        If Substr(xCusto,10,1) == "7" 
            pos   := 19
			errata()
    		error := 1			
			DbselectArea("TRA")
			Dbskip()
			Loop		        
        Endif        


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
            xUo      := IIF(xRelease == "2005",Substr(Alltrim(TRA->CC),4,1),Substr(Alltrim(TRA->CC),2,2)) 
            xAtvFim  := IIF(xRelease == "2005",Substr(Alltrim(TRA->CC),4,3),Substr(Alltrim(TRA->CC),7,3))             
            lPisCof  := .F.            
            ///////////////////////////////
            // Operações Fretes Normais  //
            ///////////////////////////////
            If xNatur <> "505"
            If xRelease == "2005            
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

	        Else    

	            Do Case            
	               Case xUo $("01|02")      // Rdvm               
	                    xNatur := "500" 
	                    lPisCof  := .T.            	
	               Case xUo $("22|23")    // Rma
	                    xNatur := "501"     
	                    lPisCof  := .T.            	                                        
	               Case xUo == "11"       // Rmlap               
	                    xNatur := "504"               
	                    lPisCof  := .T.            	                                        
	            EndCase
	        
	        Endif
	        Endif

	            
            ////////////////////////
            // Operações Isentas  //
            ////////////////////////////////////////////////////
            // Tratamento de Frete Rma , Rdvm e Rmlap isento  //          
            ////////////////////////////////////////////////////            
            If xRelease == "2005
	            // Atividades Rma  Isentas
	            xAtvRma   := "612|613|614|619|623|624|625|629|633|634|635|640|717|729|731"            
	            // Atividades Rdvm Isentas
	            xAtvRdvm  := "102|104|106|109"
	            //
	        Else
	            // Atividades Rma  Isentas
	            xAtvRma   := "402|404|406|503|504|506|508"            
	            // Atividades Rdvm Isentas
	            //xAtvRdvm  := "003|004|006|008|012"
	            xAtvRdvm  := "003|004|006|008|012|016"
	            //
	        Endif
	            
            // Atividades Rmlap Isentas
            //xAtvRmlap := "DEFINIR ??"
            If xRelease == "2005            
	            If xUo $("6789") .And. xAtvFim $(xAtvRma)   //Rma                
	               xNatur := "502"                 
	               lPisCof  := .F.                           
				Endif
	            If xUo $("12") .And. xAtvFim $(xAtvRdvm)    //Rdvm
	               xNatur := "503"           
	               lPisCof  := .F.                           
				Endif	        
	        Else
	            If xUo $("22|23") .And. xAtvFim $(xAtvRma)   //Rma                
	               xNatur := "502"                 
	               lPisCof  := .F.                           
				Endif
	            If xUo $("01|02") .And. xAtvFim $(xAtvRdvm)    //Rdvm
	               xNatur := "503"           
	               lPisCof  := .F.                           
				Endif	        
	        
	        Endif
	            
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

            /*			
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
			SE1->E1_CCONT   := xCusto //Alltrim(TRA->CC)  // Alterado em 08/09/03
			SE1->E1_TRANSP  := TRA->CDTRA   // Campo novo para gravar o Cnpj da Transportadora

			// Novos campos Lay-out 27/08/03
			SE1->E1_REFGEF  := Alltrim(TRA->REFGEF)
			SE1->E1_TPDESP  := Alltrim(TRA->TPDESP)
			SE1->E1_GEFIRRF := Alltrim(TRA->GEFIRRF)
			SE1->E1_CCPSA   := Alltrim(TRA->CCPSA)
			SE1->E1_OIPSA   := Alltrim(TRA->OIPSA)			
			SE1->E1_CTAPSA  := Alltrim(TRA->CTAPSA)  // Solicitado em 14/09/05
			
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
            */
            
        Next I

        If Val(Substr(TRA->ISSTRI,1,Len(TRA->ISSTRI)-2)+"."+Substr(TRA->ISSTRI,Len(TRA->ISSTRI)-1,2)) > 0 // Não gera imposto zerado
           //Pagar()	 // Função		
        Endif   		

    	  fiscal() // Função		
		
		Endif
		
		DbselectArea("TRA")
		Dbskip()
	End

Endif

fClose(nHdl)

If MSReg > 1
   MsgInfo("Total de centro de custo convertidos : " + Str(MSReg) )
Endif

If pos == 0
	MsgInfo("Importacao Concluida com Sucesso !!")
	DBCLOSEAREA("TRA")
Else
	Alert("Importacao Concluida com OBS. !!")
	Alert("Verificar ERRATA.LOG !!")
	DBCLOSEAREA("TRA")
EndIf

Return


Static Function Fiscal()

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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Função para verificar documento existente e suas series ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

xSerie := VALSER()

xEspecie := "1" //Default

// Tratamento Porto Real 2 séries
If xFilial("SE1") == "03" .And. Alltrim(TRA->TPDOC) == "UN1"
   xEspecie := "1"        
Endif
If xFilial("SE1") == "03" .And. Alltrim(TRA->TPDOC) == "UN2"
   xEspecie := "2"        
Endif


DbSelectArea("SF3")
DbSetOrder(8) //DbSetOrder(4)
Dbgotop()
If !DbSeek(xFilial("SF3")+SA1->A1_COD+SA1->A1_LOJA+TRA->NF+xSerie+xEspecie)
	
	Reclock("SF3",.T.)
	SF3->F3_FILIAL	:= xFilial("SF3")
	SF3->F3_REPROC	:= "N"
	SF3->F3_ENTRADA := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
	SF3->F3_NFISCAL := TRA->NF

    //  Nova Rotina para contab. novas series   
       Gefcofil := xFilial("SF3")
    IF Gefcofil == "02"
       _xloc := "CJ"
    EndIF 

    SF3->F3_SERIE  := xEspecie

    If Gefcofil == "06" .OR. Gefcofil == "11"
       SF3->F3_SERIE   := IIF(ALLTRIM(TRA->TPDOC) == "CTR" .OR. ALLTRIM(TRA->TPDOC) == "UNS","U","A") // Alterado em 10/10/05 -Solic. Eraldo                      
       SF3->F3_CODISS  := ALLTRIM(TRA->CODSER) // ALLTRIM(TRA->CDFIS) - Alterado item 15
    Else  // Demais Casos
   	   SF3->F3_CODISS  := ALLTRIM(TRA->CDFIS)       
    Endif

	Do Case
	   Case ALLTRIM(TRA->TPDOC) == "UNS"
            SF3->F3_ESPECIE :=	"NFST"   
	   Case Substr(ALLTRIM(TRA->TPDOC),1,2) == "CT"
            SF3->F3_ESPECIE :=	"CTR"   
	   Case Substr(ALLTRIM(TRA->TPDOC),1,2) == "UN"
            SF3->F3_ESPECIE :=	"NF"   
	   OtherWise
            SF3->F3_ESPECIE :=	"CTR"   	   

	EndCase
	
	SF3->F3_CLIEFOR := substr(SA1->A1_COD+SA1->A1_LOJA,1,6)
	SF3->F3_LOJA    := substr(SA1->A1_COD+SA1->A1_LOJA,7,2)		
	SF3->F3_CFO     := ALLTRIM(TRA->CDFIS)
	SF3->F3_ESTADO	:= ALLTRIM(SA1->A1_EST)
	SF3->F3_EMISSAO := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
	SF3->F3_ALIQICM := Val(Substr(TRA->ALICM,1,Len(TRA->ALICM)-2)+"."+Substr(TRA->ALICM,Len(TRA->ALICM)-1,2))
    SF3->F3_VALCONT := Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2))
	SF3->F3_VALICM	:= Val(Substr(TRA->ICMTRI,1,Len(TRA->ICMTRI)-2)+"."+Substr(TRA->ICMTRI,Len(TRA->ICMTRI)-1,2))	
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

       IF xFilial("SF3") == "03" 
          IF Alltrim(SF3->F3_CFO) $ ("6921/6949/5949/5921/5915/6915/6902/5902/6903/5903")
             SF3->F3_OUTRICM := SF3->F3_VALCONT // FILIAIS COM OPERAÇÃO OUTRAS
          ENDIF 
        ENDIF
	ENDIF   
       	
	SF3->F3_TIPO    := IIF((ALLTRIM(TRA->CDFIS) == "LIX") .Or. (ALLTRIM(TRA->CDFIS) == "CI") .Or. (ALLTRIM(TRA->CDFIS) == "58") .Or. (ALLTRIM(TRA->CDFIS) == "55"), "S" , " ")
	
	IF (ALLTRIM(TRA->CDFIS) == "LIX") .Or. (ALLTRIM(TRA->CDFIS) == "CI") .Or. (ALLTRIM(TRA->CDFIS) == "58") .Or. (ALLTRIM(TRA->CDFIS) == "55")
		SF3->F3_OBSERV  := "Incidencia de ISS"
  	    SF3->F3_VALICM	:= Val(Substr(TRA->ISSTRI,1,Len(TRA->ISSTRI)-2)+"."+Substr(TRA->ISSTRI,Len(TRA->ISSTRI)-1,2))
    	SF3->F3_ALIQICM := Val(Substr(TRA->ALISS,1,Len(TRA->ALISS)-2)+"."+Substr(TRA->ALISS,Len(TRA->ALISS)-1,2))
	    SF3->F3_BASEICM := Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2))
	    If Gefcofil == "06" .OR. Gefcofil == "11"
           SF3->F3_CODISS  := ALLTRIM(TRA->CODSER) // ALLTRIM(TRA->CDFIS) - Alterado item 15
	    Endif
	    
	Else
		SF3->F3_OBSERV := "Incidencia de ICMS"
    	SF3->F3_CODISS := ""
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
If pos == 18
	te1:="Centro de custo Bloqueado  :  "+tra->CC+"    "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 19
	te1:="Centro de custo Bloqueado (Intercentro) :  "+tra->CC+"    "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
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
     Gefcofil := xFilial("SF3")
  IF Gefcofil == "02"
     _xloc := "CJ"
  EndIF 


     //xTpServ  := IIF(ALLTRIM(TRA->TPDOC) == "UNS","NFST",IIF(ALLTRIM(TRA->TPDOC) == "UNI","NFS","CTR"))  
     xTpServ  := IIF(ALLTRIM(TRA->TPDOC) == "UNS","NFST",IIF(ALLTRIM(TRA->TPDOC) == "CTR","CTR","NF")) 
     xTamSrv := Len(xTpServ)  
     xTpServ  := xTpServ + Space( 5 - xTamSrv )
       
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

STATIC FUNCTION VARQIMP()

cTipo :="Arquivo texto *.TXT)        | *.TXT | "
cFile := cGetFile(cTipo,"Selecione o arquivo a importar")

If !Empty(cFile)
   Aviso("Arquivo Selecionado",cFile,{"Ok"})
Else
   //oBtnOK:DISABLE()      
Endif     
arqimp := PADR(ALLTRIM(cFile),80)
oarqimp:Refresh()

RETURN(.T.)

Static Function fGetPath() 

cRet  := Alltrim(ReadVar())
cPath := cDir

oWnd := GetWndDefault()

While .T.
	If Empty(cPath)
		cPath := cGetFile( "Arquivos de Exportacao ",OemToAnsi("Selecione Diretorio"),,"",.F.,GETF_RETDIRECTORY)
	EndIf
	
	If Empty(cPath)
		Return .F.
	EndIf    
	
	&cRet := cPath
	Exit
EndDo

If oWnd != Nil
	GetdRefresh()
EndIf

Return .T.