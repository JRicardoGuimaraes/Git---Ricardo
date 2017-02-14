#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"    
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  |        GEFM60        | AUTOR | Saulo Muniz  | DATA | 05/09/2006 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Importação do arquivo de baixas da Peugeot.                     |//
//|           |                                                                 |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

USER FUNCTION GEFM60()

Local   cPerg     := "IMPORT"
Private nOpc      := 0
Private cCadastro := "Importação de Faturas Adhoc -> Microsiga."
Private aSay      := {}
Private aButton   := {}

aAdd( aSay, "Esta rotina irá ler um arquivo baixando os titulos e criando as faturas correspondentes " )
aAdd( aSay, "no sistema Microsiga Protheus " )
aAdd( aSay, " " )
aAdd( aSay, " " )
aAdd( aSay, "Versão 1.03 " )

aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSay, aButton )

If nOpc == 1  
   Processa( {|| msBaixar() }, "Processando..." )   
Endif

Return

STATIC FUNCTION msBaixar()

Local cBuffer   := ""
Local aDados    := {}
Local lOk       := .T.
Local aMatA030  := {}
Local aVetor    := {}
Local aLinha    := {}

Private lMsErroAuto := .F.
Private cArqTxt     := "\\geatj1appl1\Protheus8\Protheus_Data\Importar\FaturasAdhoc\Receber\"
Private lMsHelpAuto := .T.

aVetorFat := {}
lDoc := .T. 
Erro := 0
Log  := 0
pos  := 0
cNL  := CHR(13)+CHR(10)
cCnpjFil := ""
CnpjDoc  := ""
lFatura  := .F.
nTotFat  := 0
nDescont := 0    
nAbatime := 0   
nSldDoc  := 0  
Matrix   := {}
aFiliais := {}
Faturas  := 0
_cCnpj   := ""
xi       := 0

cPathori := "\\geatj1appl1\Protheus8\Protheus_Data\Importar\FaturasAdhoc\Enviar\"
cPathdst := "\\geatj1appl1\Protheus8\Protheus_Data\Importar\FaturasAdhoc\Importado\"
ArqOri   := ""
cTipo    := "*.GEF"
aFiles   := Directory(cPathOri + cTipo)
cCmd     := ""
cNomeCli := ""
_cFilial := ""
_cChave  :=	""                                  

Arq01  := "D:\MICROSIGA\FATURAS\LOGFAT.LOG"
nHdl   := fCreate(Arq01)
te1    :="Log de erros da importação de faturas Adhoc -> Microsiga - Data: "+dtoc(ddatabase)+cNL
fWrite(nHdl,te1,Len(te1))
te1    :="Arquivo Importado : "+cPathori+" USUÁRIO...: "+SubStr(cUsuario,7,15)+cNL
fWrite(nHdl,te1,Len(te1))
te1    :="======================================================================================"+cNL
fWrite(nHdl,te1,Len(te1))

For a := 1 To Len(aFiles)

	If !File(Alltrim(cPathori + aFiles[a][1]))
		MsgBox("Arquivo texto nao existente.Programa cancelado","Informa‡ao","INFO")
		Return
	Endif

    nTam := Len(aFiles[a][1]) - 4                                            
    ArqOri  := aFiles[a][1]
    ArqDest := Substr(aFiles[a][1],1,ntam) + ".TXT"
    cCmd := "Decifrador.exe /d " + Alltrim(cPathori + aFiles[a][1]) + " " + Alltrim(cPathori + ArqDest)
    
    WinExec(cCmd)

	If File(cPathori + aFiles[a][1])
		__CopyFile(cPathori + aFiles[a][1],cPathdst + aFiles[a][1])
		//Ferase(cPathori + aFiles2[a][1])
		//Ferase(cPathori + aFiles[a][1])
	Endif

Next

cTipo    := "*.TXT"
aFiles2  := Directory(cPathOri + cTipo)

For a := 1 To Len(aFiles2)

	If !File(Alltrim(cPathori + aFiles2[a][1]))
		MsgBox("Arquivo texto nao existente.Programa cancelado","Informa‡ao","INFO")
		Return
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a regua de processamento                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Processa({|| RunBaixar() },"Processando...")
	
	If File(cPathori + aFiles2[a][1])
		__CopyFile(cPathori + aFiles2[a][1],cPathdst + aFiles2[a][1])
		//Ferase(cPathori + aFiles2[a][1])
		//Ferase(cPathori + aFiles[a][1])
	Endif
	
Next


Return


Static Function RunBaixar()
	
FT_FUSE(Alltrim(cPathori + aFiles2[a][1]))
FT_FGOTOP()

lMsErroAuto := .F.
	
ProcRegua(FT_FLASTREC())
	
While !FT_FEOF()
	   
	   IncProc()
	   
	   cBuffer  := FT_FREADLN()   
	
	   If Empty(cBuffer) 
		  Exit
	   Endif
	           
	   If Substr(cBuffer,1,3) == "AAA" 
	      FT_FSKIP()
	      Loop
	   Endif
	
	   If Substr(cBuffer,1,3) == "9FA" 
		  If Erro == 0
		      MSFATURA()		      				
		  Endif  	  
		      
	      If nValFat <> (nSldDoc + nDescont + nAbatime)         
	         If Erro == 0
		         Erro := 1
		  	     Log  := 5          
				 Gravalog(Log)         
			     FT_FSKIP()
			     Loop				     			     
		     Endif      

	      Endif      
	
		   nTotFat  := 0
		   nDescont := 0    
		   nAbatime := 0   
		   nSldDoc  := 0  
		      
	      FT_FSKIP()
	      Loop 
	      
	   Endif
	
	   If Substr(cBuffer,1,3) == "ZZZ" 
	      FT_FSKIP()
	      Loop
	   Endif
	      
	   If Substr(cBuffer,1,3) == "FAT" 

	      cNumFat   := Substr(cBuffer,8,6) 
	      cFatAdhoc := Substr(cBuffer,4,10) 
		  cCnpjFil  := Alltrim(Substr(cBuffer,26,14)) 
		  cCnpjCli  := Alltrim(Substr(cBuffer,40,14))       	  
		  dEmissao  := Ctod(Substr(cBuffer,20,2) + "/" + Substr(cBuffer,18,2) +"/" + Substr(cBuffer,14,4))
		  dVencto   := DataValida(Ctod(Substr(cBuffer,100,2) + "/" + Substr(cBuffer,098,2) +"/" + Substr(cBuffer,94,4)))
		  nValFat   := Val(Left(Substr(cBuffer,54,20),18)+"."+Right(Substr(cBuffer,54,20),2))          	           
	      nDescont  := Val(Left(Substr(cBuffer,74,20),18)+"."+Right(Substr(cBuffer,74,20),2))          	           
	      nAbatime  := Val(Left(Substr(cBuffer,180,20),18)+"."+Right(Substr(cBuffer,180,20),2))          	           
          nNossoNum := Substr(cBuffer,160,12) 
          msBanco  := Alltrim(Substr(cBuffer,102,10)) 
          msConta  := Alltrim(Substr(cBuffer,112,20)) 
          msAgenc  := Alltrim(Substr(cBuffer,132,20)) 
	      SituaFat := Alltrim(Substr(cBuffer,022,04)) 
                   
	      /*
	      DbselectArea("SA6")
		  DbsetOrder(1)
		  Dbgotop()
		  If !Dbseek(xFilial("SA1") + msBanco + msAgenc + msConta )                   
	      Endif
	      */
	      
		  DbselectArea("SA1")
		  DbsetOrder(3)
		  Dbgotop()
		  If Dbseek(xFilial("SA1")+cCnpjCli)
	         lCliente := .T.
	         cCliente := SA1->A1_COD
	         cLojaCli := SA1->A1_LOJA
	         cNomeCli := SA1->A1_NREDUZ
	      Else
	  	     lCliente := .F.	
			 Log := 1          
			 Gravalog(Log)   
	         Erro := 1         
	         Return
	      Endif

          _cCnpj   :=  cCnpjFil	      
          _cFilial :=  GFilial(cCnpjFil)

          If Empty(_cFilial)
		  	 Erro := 1
		     Log := 7            
  	         Gravalog(Log)
             Return
          Endif
           	
	      DbselectArea("SE1")
		  DbsetOrder(19)
		  Dbgotop()
		  If Dbseek(_cFilial + cNumFat )
	         lFatura := .T.
			 Log := 6          
			 Gravalog(Log)   
	         Erro := 1         
	         FT_FSKIP()
	         Loop	              
	      Endif
	
	      Faturas++
	      
	      aVetorFat  := {	{"E1_FILIAL"   ,_cFilial        ,Nil},;
	                        {"E1_PREFIXO"  ,"FAT"           ,Nil},;		    			
		    				{"E1_NUM"	   ,cNumFat         ,Nil},;
			    			{"E1_PARCELA"  ," "             ,Nil},;
				    		{"E1_TIPO"	   ,"FAT"           ,Nil},;
					    	{"E1_NATUREZ"  ,"500"           ,Nil},;
	    		          	{"E1_CLIENTE"  ,cCliente        ,Nil},;
		                 	{"E1_LOJA"	   ,cLojaCli        ,Nil},;
			             	{"E1_EMISSAO"  ,dEmissao        ,Nil},;
			     	       	{"E1_VENCTO"   ,dVencto         ,Nil},;
				         	{"E1_VENCREA"  ,dVencto         ,Nil},;
				         	{"E1_FATURA"   ,"NOTFAT"        ,Nil},;
				         	{"E1_NOMCLI"   ,cNomeCli        ,Nil},;
				         	{"E1_SALDO"    ,nValFat         ,Nil},;
				        	{"E1_VALOR"	   ,nValFat         ,Nil }}	
	
	
	   	  AADD(Matrix,aVetorFat)
	      	  	       
	   Endif
	     
	   If Substr(cBuffer,1,3) == "DOC"	         

    		 If lFatura
	            FT_FSKIP()
			    Log := 6            
	  	        Gravalog(Log)
	            Loop    		 
    		 Endif
	         
             cPrefixo := Substr(cBuffer,4,3)
             cNumero  := Substr(cBuffer,7,6)
             cParcela := " "
             cTipo    := "NF"
             nValor   := Val(Left(Substr(cBuffer,53,20),18)+"."+Right(Substr(cBuffer,53,20),2))          	
	               
             _cCnpj   :=  Substr(cBuffer,25,14)
             _cFilial :=  GFilial(_cCnpj)
	         
	         If Empty(cBuffer) 
	            MsgAlert("Linha em branco !",cCadastro)
	            Exit
	         Endif
	                    	  
	 		 DbSelectArea("SE1")
			 ProcRegua(RecCount())
			 DbSetOrder(1)
			 DbGoTop()	
		     If DbSeek( _cFilial + cPrefixo + cNumero + cParcela + cTipo )
		     //If DbSeek( _cFilial + cPrefixo + cNumero + cParcela + cTipo )
		        lDoc := .T.	     
		     Else
	   		    MsgStop("O Documento : " + cNumero + " não encontrado.!!")   		    		
		        Erro := 1
		  	    Log  := 2          
				Gravalog(Log)         
	   		    lMsErroAuto := .T.
		        lDoc := .F.
	            FT_FSKIP()
	            Loop	        		     
		     Endif

             If !Empty(SE1->E1_FATURA)
		        Erro := 1
		  	    Log  := 9          
				Gravalog(Log)         
	            FT_FSKIP()
	            Loop	               
             EndIf
		     	     
		     IF SE1->E1_STATUS == "B"  
	            MsgStop("O Documento : " + cNumero + " não pode ser baixado.!!" + " - Titulo já baixado !")
	  		    lMsErroAuto := .T.
	            FT_FSKIP()
			    Log := 3            
	  	        Gravalog(Log)
	            Loop
		     Endif
			 
			 
			 If SE1->E1_SITUACA <> "0"
	            MsgStop("O Documento : " + cNumero + "não pode ser baixado.!!" + " - Titulo em Cobrança !")
	  		    lMsErroAuto := .T.
	            FT_FSKIP()
			    Log := 8            
	  	        Gravalog(Log)
	            Loop			 
			 Endif
			 
			 If SE1->E1_SALDO <> nValor		 			
	            MsgStop("O Valor do Titulo : " + cNumero + " difere do valor informado : " + Substr(nValor,1))
	            FT_FSKIP()
			    Log := 10            
	  	        Gravalog(Log)
	            Loop			 	            			 
			 Endif
			 
			 nSldDoc := nSldDoc + nValor		 			
			 _cChave :=	cFatAdhoc  
			 //_cChave :=	_cFilial+cFatAdhoc  
				
			 aVetor := {    {"E1_FILIAL"   ,_cFilial           ,Nil},;
			                {"E1_PREFIXO"	,cPrefixo          ,Nil},;
			 				{"E1_NUM"	    ,cNumero           ,Nil},;
			 				{"E1_PARCELA"   ,cParcela          ,Nil},;
							{"E1_TIPO"	    ,cTipo             ,Nil},;
							{"E1_FATURA"    ,cNumFat           ,Nil},;
							{"E1_FATPREF"   ,"FAT"             ,Nil},;
							{"E1_TIPOFAT"   ,"FAT"             ,Nil},;
							{"E1_FLAGFAT"   ,"S"               ,Nil},;
				         	{"E1_OBS"       ,_cChave           ,Nil},;						
				         	{"E1_LA"        ,"S"               ,Nil},;						
							{"AUTMOTBX"	    ,"FAT"             ,Nil},;
							{"AUTDTBAIXA"   ,dDataBase         ,Nil},;
							{"AUTDTCREDITO" ,dDataBase         ,Nil},;
							{"AUTHIST"	    ,"Fatura Adhoc"    ,Nil},;
							{"AUTVALREC"	,nValor            ,Nil }}
						
	
				// Outras informacoes que podem ser passadas como parametro
				//           {'AUTDTCREDITO',0     ,Nil},; //Data de credito
				//           {'AUTACRESC'   ,0     ,Nil},; //Valor do acrescimo
				//           {'AUTDECRESC'  ,0     ,Nil},; //Valor do decrescimo
				//           {'AUTVALREC'   ,0     ,Nil},; //Valor recebido - Se nao for passado o sistema calcula automaticamente					                



			    If Erro == 0
               	   
               	   Reclock("SE1",.F.)
                   SE1->E1_FATURA  := cNumFat
                   SE1->E1_FATPREF := "FAT"
                   SE1->E1_TIPOFAT := "FAT"
                   SE1->E1_FLAGFAT := "S"
                   SE1->E1_OBS     := _cChave
                   SE1->E1_LA      := "S" 
                   Msunlock()                   
  	  		       
  	  		       
  	  		       MSExecAuto({|x,y| FINA070(x,y)},aVetor,3) //Inclusao			    
	               
	               //FINA070(aVetor,3)
	               
			    Endif	    
	            
			
			 If lMsErroAuto
			  	MsgStop("Erro na baixa do documento : " + cNumero )
			  	Erro := 1
			    Log := 3            
	  	        Gravalog(Log)
			 Endif
	         
	   EndIf
	   		   
	   FT_FSKIP()   
	
EndDo
	
	FT_FUSE()
	fClose(nHdl)
			
Return


/////////////////////////////
Static Function Gravalog() //
/////////////////////////////
    
If log == 1
   te1:="Cliente Inexistente   .:   " + cCnpjCli + " Fatura Nº "+ cNumFat +cNL
   fWrite(nHdl,te1,Len(te1))
Endif
If log == 2
   te1:="Documento Inexistente .:   "+ cNumero + " Filial : " + _cFilial +cNL
   fWrite(nHdl,te1,Len(te1))
Endif
If log == 3
   te1:="Titulo já Baixado     .:   "+ cNumero + " Filial : " + _cFilial +cNL
   fWrite(nHdl,te1,Len(te1))
Endif
If log == 4
   te1:="Fatura cancelada      .:   "+ cNumFat + " Filial : " + _cFilial +cNL
   fWrite(nHdl,te1,Len(te1))
Endif
If log == 5
   te1:="Valor da Fatura ( " + cNumFat + " ) Difere dos Documentos em R$ " + Alltrim(Str(nValFat - (nSldDoc + nDescont + nAbatime)))+cNL
   fWrite(nHdl,te1,Len(te1))
Endif
If log == 6
   te1:="Fatura já existe      .:   "+ cNumFat + " Filial : " + _cFilial +cNL
   fWrite(nHdl,te1,Len(te1))
Endif
If log == 7
   te1:="Filial não existe     .:   "+ cNumFat + " Filial : " + _cFilial +cNL
   fWrite(nHdl,te1,Len(te1))
Endif
If log == 8
   te1:="Titulo em Cobrança    .:   "+ cNumero + " Filial : " + _cFilial +cNL
   fWrite(nHdl,te1,Len(te1))
Endif
If log == 9
   te1:="Titulo em Fatura      .:   "+ cNumero + " Filial : " + _cFilial +cNL
   fWrite(nHdl,te1,Len(te1))
Endif
If log == 10
   te1:="O Valor do Titulo : " + cNumero + " difere do valor informado : " + Substr(nValor,1) +cNL
   fWrite(nHdl,te1,Len(te1))
Endif


Return

//////////////////////////////////////
 STATIC FUNCTION MSFATURA()  //
//////////////////////////////////////
  
dbSelectArea("SE1")
dbSetOrder(1)
Dbgotop()
If !dbSeek( _cFilial + "FAT" + cNumFat )

	Reclock("SE1",.T.)
	SE1->E1_FILIAL  := _cFilial
    SE1->E1_PARCELA := " "
	SE1->E1_NATUREZ := "500"
	SE1->E1_NOMCLI  := cNomeCli
	SE1->E1_NUM	    := cNumFat
	SE1->E1_PREFIXO := "FAT"
	SE1->E1_TIPO    := "FAT"
	SE1->E1_CLIENTE := cCliente
	SE1->E1_LOJA    := cLojaCli
	SE1->E1_EMISSAO := dEmissao
	SE1->E1_EMIS1   := dEmissao
	SE1->E1_MOVIMEN := dEmissao
    SE1->E1_VENCTO  := dVencto
	SE1->E1_VENCORI := dVencto
    SE1->E1_VENCREA := DataValida(dVencto)
	SE1->E1_VALOR   := nValFat
	SE1->E1_SALDO   := nValFat
	SE1->E1_VLCRUZ  := nValFat
	SE1->E1_FLUXO   := "S"
	SE1->E1_LA      := "S"
	SE1->E1_MOEDA   := 1
	SE1->E1_OCORREN := "01"
	SE1->E1_STATUS  := "A"
	SE1->E1_ORIGEM  := "FINA280" // "FINA040"
	SE1->E1_SITUACA := "1"
	SE1->E1_CCONT   := ""           // c.custo ??
	SE1->E1_OBS     := cFatAdhoc					
	SE1->E1_PORTADO := msBanco
	SE1->E1_AGEDEP  := msAgenc
    SE1->E1_CONTA   := msConta
    SE1->E1_FATURA  := "NOTFAT"
	SE1->E1_FILDEB  := _cFilial
	SE1->E1_FILORIG := _cFilial
    SE1->E1_NUMBCO  := nNossoNum     
	Msunlock()                   
    
    dbSelectArea("SEA")
    RecLock("SEA",.T.)
	SEA->EA_FILIAL  := _cFilial
	SEA->EA_DATABOR := dEmissao
	SEA->EA_PORTADO := msBanco
	SEA->EA_AGEDEP  := msAgenc
	SEA->EA_NUMCON  := msConta
	SEA->EA_SITUACA := "1"
	SEA->EA_NUM 	:= SE1->E1_NUM
	SEA->EA_PARCELA := SE1->E1_PARCELA
	SEA->EA_PREFIXO := SE1->E1_PREFIXO
	SEA->EA_TIPO	:= SE1->E1_TIPO
	SEA->EA_CART	:= "R"
	SEA->EA_SITUANT := "0"
	SEA->EA_FILORIG := SE1->E1_FILIAL
	MsUnlock()
    
    dbSelectArea("SE1")	
	
Else
    MsgInfo("Já Existe Fatura com o mesmo numero ! " + cNumFat)
Endif
		   	    
Return

      
STATIC FUNCTION GravaComErro( cArquivo )

  cNewArq := StrTran( UPPER( cArquivo ), ".TXT", ".ERR" )
  FRename( cArquivo, cNewArq )

Return


STATIC FUNCTION GravaSemErro( cArquivo )

  cNewArq := StrTran( UPPER( cArquivo ), ".TXT", ".OK" )
  FRename( cArquivo, cNewArq )

Return


STATIC FUNCTION GFilial( _cCnpj )

   dbSelectArea("SM0")
   dbSeek("01")         
   While !Eof() .and. ( M0_CODIGO == "01" )
         //if Ascan( aFiliais, M0_CODFIL ) == 0
         If Ascan( aFiliais, M0_CGC ) == 0 // _cCnpj
            AAdd( aFiliais, {M0_CGC, M0_CODFIL })
         End	          	 	
      dbSkip()	  	    
   End				  
   
   For xi := 1 To Len(aFiliais)
       If aFiliais[xi][1] == _cCnpj
          _cFilial := aFiliais[xi][2]
       Endif       
   Next     
   
Return(_cFilial)