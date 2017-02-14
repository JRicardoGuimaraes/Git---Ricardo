#include "rwmake.ch"    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GEFM48 ºAutor  ³ Saulo Muniz         º Data ³  31/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza Dados (Icms)                                      º±±
±±º          ³ Problema Adhoc importação                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GEFM48()   

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
nupdate:= 0
ninsert:= 0

@ 000,000 To 250,370 Dialog oDlg Title "GEFCO - Acerto Fiscal"
@ 003,016 To 60,144
@ 010,021 Say OemToAnsi("Este programa tem o objetivo atualizar")
@ 022,021 Say OemToAnsi("os arquivos do livro fiscal com o icms do Txt")
@ 010,152 BmpButton Type 1 Action OBJ()
@ 030,152 BmpButton Type 2 Action Close(oDlg)
Activate Dialog oDlg Centered

Return

Static Function OBJ()
@ 000,000 TO 250,450 DIALOG oDlg1 TITLE "Acerto Livro de Icms"
@ 016,010 TO 67,180 TITLE "Atualizar Livro Fiscal"
@ 023,011 RADIO aRadio VAR nRadio
@ 080,010 BUTTON "_Ok" SIZE 35,15 ACTION Import() 
@ 080,050 BUTTON "_Cancel" SIZE 35,15 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER

Return

Static Function Import(lEnd,oObj)

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
ntamxx  := 272     
nHdxx   := fopen(Arqxx)
cbufferx:= space(ntamxx)
nbytesx := 0
nbytesx := fRead(nHdxx,@cbufferx,ntamxx)
_xVer   := Substr(cbufferx,033,5)
Fclose(nHdxx)

Private oProcess := NIL
oProcess := MsNewProcess():New({|lEnd| ProcTxt2(lEnd,oProcess)},"Processando","Aguarde...",.T.)
oProcess:Activate()

//Processa({|| ProcTxt2()},"Processando....")

  Close(oDlg)
  Close(oDlg1)

Return


Static Function ProcTxt2(lEnd,oObj)

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
	nRegs  := 0
	
	// criacao do arquivo Log
	//=======================
	Arq01  := "D:\MICROSIGA\SIGAADV\errata.log"
	nHdl   := fCreate(Arq01)
	te1:="Criacao do arquivo de erros gerados pelo sistema de importacao - Data: "+dtoc(ddatabase)+cNL
	fWrite(nHdl,te1,Len(te1))
	te1:="======================================================================================"+cNL
	fWrite(nHdl,te1,Len(te1))

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
	DbSelectArea("TRA")
	DbGotop()
	
	//ProcRegua(RecCount())
    oObj:SetRegua1(RecCount())	  
    oObj:SetRegua2(RecCount())	        //segunda regua

	While !Eof()
		
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
		//
		DbselectArea("SA1")
        DbGotop()			
		If !(Dbseek(xFilial("SA1")+TRA->CDDEST))  // Retirado Softseek
			pos  := 8
			errata()
			error := 1
			DbselectArea("TRA")
			Dbskip()
		    Loop
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
        
        /*
 		xCodFis := Alltrim(MV_PAR01) 		
 		If Alltrim(TRA->CDFIS) $ "5910/5915/5921/5949/6902/6903/6915/6921/6949" // Adicionado cod.5910 em 25/10/04
		   fiscal()
		   error := 1		
		   DbselectArea("TRA")
		   Dbskip()
		   Loop
        EndIf
		*/
			
		If error == 0                 		
           nRegs++
           oObj:IncRegua1("Documento Fiscal : " + TRA->NF)   
           oObj:IncRegua2("Quantidade  : " + Str(nRegs))   
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

MSGINFO("Foram Atualizados : " + STR( nupdate , 5 ) + " |  Foram Inseridas :  " + STR( ninsert , 5 ) + " Nfs")

Return


Static Function VALSER()

Local xTpServ

  Gefcofil :=xFilial()
  IF Gefcofil == "02"
     _xloc := "CJ"
  EndIF   
  xTpServ  := IIF(ALLTRIM(TRA->TPDOC) == "UNS","NFST",IIF(ALLTRIM(TRA->TPDOC) == "UNI","NFS","CTR"))  
    
Return(xTpServ)


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

xSerie := VALSER()
 
DbSelectArea("SF3")
DbSetOrder(8) 
Dbgotop()
If !DbSeek(xFilial("SF3")+SA1->A1_COD+SA1->A1_LOJA+TRA->NF+xSerie)
	ninsert++
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
    Else
       SF3->F3_SERIE  := "U"    
    EndIF	

    If Gefcofil == "06" .OR. Gefcofil == "11"
       SF3->F3_SERIE   := IIF(ALLTRIM(TRA->TPDOC) == "CTR" .OR. ALLTRIM(TRA->TPDOC) == "UNS","U","A") // Alterado em 10/10/05 -Solic. Eraldo                      
       SF3->F3_ESPECIE := IIF(ALLTRIM(TRA->TPDOC) == "UNS","NFST",IIF(ALLTRIM(TRA->TPDOC) == "UNI","NFS","CTR"))  

    Else  // Demais Casos
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
       	
	SF3->F3_TIPO    := IIF((ALLTRIM(TRA->CDFIS) == "LIX") .Or. (ALLTRIM(TRA->CDFIS) == "CI") .Or. (ALLTRIM(TRA->CDFIS) == "58") .Or. (ALLTRIM(TRA->CDFIS) == "55"), "S" , " ")
	IF (ALLTRIM(TRA->CDFIS) == "LIX") .Or. (ALLTRIM(TRA->CDFIS) == "CI") .Or. (ALLTRIM(TRA->CDFIS) == "58") .Or. (ALLTRIM(TRA->CDFIS) == "55")
		SF3->F3_OBSERV  := "Incidencia de ISS"
		SF3->F3_CODISS  := ALLTRIM(TRA->CDFIS)
  	    SF3->F3_VALICM	:= Val(Substr(TRA->ISSTRI,1,Len(TRA->ISSTRI)-2)+"."+Substr(TRA->ISSTRI,Len(TRA->ISSTRI)-1,2))
    	SF3->F3_ALIQICM := Val(Substr(TRA->ALISS,1,Len(TRA->ALISS)-2)+"."+Substr(TRA->ALISS,Len(TRA->ALISS)-1,2))
	    SF3->F3_BASEICM := Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2))
	Else
		SF3->F3_OBSERV :=  "Incidencia de ICMS"
	EndIf
	SF3->F3_CONTA :=  "INSERT"
	Msunlock()

Else
	nupdate++
    // Atualiza Dados (Icms)
	Reclock("SF3",.F.)
	SF3->F3_FILIAL	:= xFilial("SF3")
    SF3->F3_OBSERV  := "Incidencia de ICMS"
	SF3->F3_ALIQICM := Val(Substr(TRA->ALICM,1,Len(TRA->ALICM)-2)+"."+Substr(TRA->ALICM,Len(TRA->ALICM)-1,2))
    SF3->F3_VALCONT := Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2))
	SF3->F3_VALICM	:= Val(Substr(TRA->ICMTRI,1,Len(TRA->ICMTRI)-2)+"."+Substr(TRA->ICMTRI,Len(TRA->ICMTRI)-1,2))	    

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
	SF3->F3_CONTA :=  "UPDATE"       	  
	Msunlock()
	
Endif       

Return