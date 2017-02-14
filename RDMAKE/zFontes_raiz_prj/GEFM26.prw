#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

User Function GEFM26()        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

SetPrvt("XCLILOJA,ARADIO,NRADIO,POS,CNL,XARQ")
SetPrvt("ARQ01,NHDL,TE1,_ACAMPOS,_CNOME,CINDEX")
SetPrvt("CCHAVE,NINDEX,ERROR,_XCLI,_XNAT,VCF")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GEFM01    ³ Autor ³ Alexandre de Almeida  ³ Data ³ 05.01.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Importacao do Documento (Arquivo GEFCCTRC.TXT) criando :    ³±±
±±³          ³                                                            ³±±
±±³          ³ Titulo a Receber                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
xcliloja:=" "  //VARIAVEL GUARDA O COD DO CLIENTE PARA UTILIZACAO DO SEEK DO SF3
aRadio := {"Conhecimento frete","Notas Fiscais","NF Serviço"}
nRadio := 1


@ 000,000 To 250,370 Dialog oDlg Title "GEFCO - IMPORTA€AO FINANCEIRA !!!"
@ 003,016 To 60,144
@ 010,021 Say OemToAnsi("Este programa tem o objetivo de importar")
@ 022,021 Say OemToAnsi("os arquivos que foram gerados no padrao TXT")
@ 010,152 BmpButton Type 1 Action OBJ()// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> @ 010,152 BmpButton Type 1 Action Execute(OBJ)
@ 030,152 BmpButton Type 2 Action Close(oDlg)
Activate Dialog oDlg Centered
Return


Static Function OBJ()
@ 0,0 TO 250,450 DIALOG oDlg1 TITLE "IMPORTACAO DE DADOS - SIGAFIN"
@ 16,80 TO 67,180 TITLE "Importacao de dados"
@ 23,81 RADIO aRadio VAR nRadio
@ 80,100 BUTTON "_Ok" SIZE 35,15 ACTION Import()// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> @ 80,100 BUTTON "_Ok" SIZE 35,15 ACTION Execute(Import)
@ 100,100 BUTTON "_Cancel" SIZE 35,15 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER

Return

Static Function Import()

Processa({|| ProcTxt()},"Processando...")// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==>  Processa({|| Execute(ProcTxt)},"Processando...")
Close(oDlg)
Close(oDlg1)
//DbSelectArea("SA2")
//DbSetOrder(1)
//Fina370(.T.)
Return

Static Function ProcTxt()

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
	* Abre o Arquivo para receber a localizacao     *
	********************************************
	_xloc:=""                                        //Local de Origem
	Arq02  := xarq
	nHd2   := NIL
	ntam   := 159                                  // 454 em 16/04/01
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
//	Aadd(_aCampos,{"CC"     ,"C",07,0 })	
	Aadd(_aCampos,{"CC"     ,"C",10,0 })	// Alteração para novo lay-out 22/08/03
	Aadd(_aCampos,{"REFGEF" ,"C",20,0 })	
	Aadd(_aCampos,{"TPDESP" ,"C",03,0 })	
	Aadd(_aCampos,{"GEFIRRF","C",01,0 })	
	Aadd(_aCampos,{"CCPSA"  ,"C",20,0 })	
	Aadd(_aCampos,{"OIPSA"  ,"C",20,0 })	
	Aadd(_aCampos,{"CDRESD" ,"C",14,0 })	// Alteração para novo lay-out 15/01/04  Cnpj - Redespacho

	 aParc:= {}
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
	DbSelectArea("TRA")
	DbGotop()
	ProcRegua(RecCount())
	  
	
	While !Eof()
		
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
		
		DbselectArea("SA1")
		If !(Dbseek(xFilial("SA1")+TRA->CDDEST))  // Retirado Softseek
			pos  := 8
			errata()
			error := 1
            DbGotop()			
			DbselectArea("TRA")
			Dbskip()
		Else                       
     		DbselectArea("SA1")
            DbGotop()					
		Endif

		DbselectArea("SA1")
		If !(Dbseek(xFilial("SA1")+TRA->CDCLI))  // Retirado Softseek
			pos   := 3
			errata()
			error := 1
			DbselectArea("TRA")
			Dbskip()
		Endif

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
		
		DbSelectArea("SE1")
		If (DbSeek(xFilial("SE1")+TRA->TPDOC+TRA->NF,.T.))  //PARA NOTAS FISCAIS
			pos   := 1
			errata()
    		error := 1
		Endif
		
		DbSelectArea("SE1")		
		If error == 0        
         
         DbSelectArea("SA1")
         xCondcli := Alltrim(SA1->A1_COND)        
         aParc := Condicao(Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2)),xCondcli,,Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))) 

		DbSelectArea("SE1")		

        For I:=1 to len(aParc)			
			xcliloja:=SA1->A1_COD+SA1->A1_LOJA
			Reclock("SE1",.T.)
			SE1->E1_FILIAL  := xFilial("SE1")
            SE1->E1_PARCELA := IIF(len(aParc)==1," ",Alltrim(str(i)))
			SE1->E1_NATUREZ := SA1->A1_NATUREZ
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
			
			SE1->E1_IPI          := Val(Substr(TRA->VALIPI,1,Len(TRA->VALIPI)-2)+"."+Substr(TRA->VALIPI,Len(TRA->VALIPI)-1,2))
			IF AllTrim(TRA->CDFIS) == "LIX" .Or. AllTrim(TRA->CDFIS) == "58" .Or. AllTrim(TRA->CDFIS) == "55" .Or. AllTrim(TRA->CDFIS) == "CI"
				SE1->E1_ISS   := Val(Substr(TRA->ICMTRI,1,Len(TRA->ICMTRI)-2)+"."+Substr(TRA->ICMTRI,Len(TRA->ICMTRI)-1,2))
			Else
				SE1->E1_VLRICM:= Val(Substr(TRA->ICMTRI,1,Len(TRA->ICMTRI)-2)+"."+Substr(TRA->ICMTRI,Len(TRA->ICMTRI)-1,2))
			Endif
			Msunlock()
        Next I
//			pagar()
//			fiscal()
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

If TRA->CDFIS == "LIX" .Or. ALLTRIM(TRA->CDFIS) == "CI"
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
		SE2->E2_VENCTO  := Ctod("05/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
		SE2->E2_VENCORI := Ctod("05/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
		SE2->E2_VENCREA := DataValida(Ctod("05/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4)))
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
		Msunlock()
	Else
		pos:= 7
		errata()
	Endif
Endif
Return

Static Function Fiscal()

DbselectArea("SA1")
DbSetOrder(3)
DbGotop()					

//IF!(Dbseek(xFilial("SA1")+TRA->CDDEST,.T.)) // Alterado 23/01/02 para buscar dados do destinatario
// Novo Tratamento de Cliente como Redespacho para informações no Livro Fiscal 19/01/04

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
   Dbseek(xFilial("SA1")+TRA->CDDEST) 

Endif 

DbSelectArea("SF3")
DbSetOrder(4)
If !(DbSeek(xFilial("SF3")+SA1->A1_COD+SA1->A1_LOJA+TRA->NF+TRA->TPDOC))
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
//    ElseIF Alltrim(TRA->TPDOC) == "NFS"
//       SF3->F3_SERIE  := Alltrim(TRA->TPDOC)               
    Else
       SF3->F3_SERIE  := "U"    
    EndIF	
    
	SF3->F3_CLIEFOR := substr(SA1->A1_COD+SA1->A1_LOJA,1,6)
	SF3->F3_LOJA    := substr(SA1->A1_COD+SA1->A1_LOJA,7,2)
	SF3->F3_CFO     := ALLTRIM(TRA->CDFIS)
	SF3->F3_ESTADO	:= ALLTRIM(SA1->A1_EST)
	SF3->F3_EMISSAO := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
	SF3->F3_ALIQICM := Val(Substr(tRA->ALICM,1,Len(TRA->ALICM)-2)+"."+Substr(TRA->ALICM,Len(TRA->ALICM)-1,2))
	SF3->F3_BASEICM := Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2))
	SF3->F3_VALCONT := Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2))
	SF3->F3_VALICM	:= Val(Substr(TRA->ICMTRI,1,Len(TRA->ICMTRI)-2)+"."+Substr(TRA->ICMTRI,Len(TRA->ICMTRI)-1,2))
	SF3->F3_ESPECIE := IIF(TRA->TPDOC=="UNI"," NF","CTR")
	SF3->F3_BASEIPI := Val(Substr(TRA->BASIPI,1,Len(TRA->BASIPI)-2)+"."+Substr(TRA->BASIPI,Len(TRA->BASIPI)-1,2))
	SF3->F3_VALIPI	:= Val(Substr(TRA->VALIPI,1,Len(TRA->VALIPI)-2)+"."+Substr(TRA->VALIPI,Len(TRA->VALIPI)-1,2))

//	Reforçado a condição para filtro de incidencia de iss para ctrc
//  Saulo - 05/02/03

/*

// Codigos para Gerar Informações de ISS

F3_CODISS     F3_TIPO
 
  LIX                    S
  CI                     S
  58                     S
  55                     S

*/

	SF3->F3_TIPO    := IIF((ALLTRIM(TRA->CDFIS) == "LIX") .Or. (ALLTRIM(TRA->CDFIS) == "CI") .Or. (ALLTRIM(TRA->CDFIS) == "58") .Or. (ALLTRIM(TRA->CDFIS) == "55"), "S" , " ")
	IF (ALLTRIM(TRA->CDFIS) == "LIX") .Or. (ALLTRIM(TRA->CDFIS) == "CI") .Or. (ALLTRIM(TRA->CDFIS) == "58") .Or. (ALLTRIM(TRA->CDFIS) == "55")
		SF3->F3_OBSERV := "Incidencia de ISS"
		SF3->F3_CODISS  := ALLTRIM(TRA->CDFIS)
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
	te1:="Titulo ja existente..: "+tra->NF+" "+tra->CDCLI+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 2
	te1:="Fornecedor nao existe.: "+tra->CDTRA+" "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 3
	te1:="Cliente Inexistente.: "+tra->CDCLI+" "+" Documento "+tra->NF+cNL
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
	te1:="Registro Fiscal existe - Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 7
	te1:="Titulo de Iss ja Existe "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 8
	te1:="Cnpj Cedente nao Existe "+tra->CDRESD+" "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 9
	te1:="Cliente Redespacho nao Existe "+tra->CDDEST+" "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif

Return

