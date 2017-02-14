#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

User Function GEFM01()        // incluido pelo assistente de conversao do AP5 IDE em 18/10/00

SetPrvt("XCLILOJA,ARADIO,NRADIO,POS,CNL,XARQ")
SetPrvt("ARQ01,NHDL,TE1,_ACAMPOS,_CNOME,CINDEX")
SetPrvt("CCHAVE,NINDEX,ERROR,_XCLI,_XNAT,VCF")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GEFM01    ³ Autor ³ Saulo Muniz           ³ Data ³ 16.06.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Importacao do Documento (Arquivo GEFCCTRC.TXT) criando :    ³±±
±±³          ³                                                            ³±±
±±³          ³ Registro Livros Fiscais                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
xcliloja:=" "  //VARIAVEL GUARDA O COD DO CLIENTE PARA UTILIZACAO DO SEEK DO SF3
aRadio := {"Conhecimento frete","Notas Fiscais"}
nRadio := 1


@ 000,000 To 250,370 Dialog oDlg Title "GEFCO - IMPORTA€AO DE NOTAS"
@ 003,016 To 60,144
@ 010,021 Say OemToAnsi("Este programa tem o objetivo de importar")
@ 022,021 Say OemToAnsi("os arquivos que foram gerados no padrao TXT")
@ 010,152 BmpButton Type 1 Action OBJ()// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> @ 010,152 BmpButton Type 1 Action Execute(OBJ)
@ 030,152 BmpButton Type 2 Action Close(oDlg)
Activate Dialog oDlg Centered
Return


Static Function OBJ()
@ 0,0 TO 250,450 DIALOG oDlg1 TITLE "IMPORTACAO DE DADOS"
@ 16,80 TO 67,180 TITLE "Importacao de dados"
@ 23,80 RADIO aRadio VAR nRadio
@ 80,100 BUTTON "_Ok" SIZE 35,15 ACTION Import()// Substituido pelo assistente de conversao do AP5 IDE em 18/10/00 ==> @ 80,100 BUTTON "_Ok" SIZE 35,15 ACTION Execute(Import)
@ 100,100 BUTTON "_Cancel" SIZE 35,15 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER

Return

Static Function Import()

Processa({|| ProcTxt()},"Processando...")
Close(oDlg)
Close(oDlg1)
Return

Static Function ProcTxt()

pos  := 0
cNL  := CHR(13)+CHR(10)

If nRadio == 1
	xarq:="GEFCCTRC.TXT"
Else
	xarq:="GEFCNOTA.TXT"
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
	Arq01  := "errata.log"
	nHdl   := fCreate(Arq01)
	te1:="Criacao do arquivo de erros gerados pelo sistema de importacao - Data: "+dtoc(ddatabase)+cNL
	fWrite(nHdl,te1,Len(te1))
	te1:="======================================================================================"+cNL
	fWrite(nHdl,te1,Len(te1))
	
	_aCampos:={}
	Aadd(_aCampos,{"INDICE","N",02,0 })
	Aadd(_aCampos,{"NF"    ,"C",06,0 })
	Aadd(_aCampos,{"XDATA" ,"C",08,0 })
	Aadd(_aCampos,{"CDDEST","C",14,0 })
	Aadd(_aCampos,{"CDCLI" ,"C",14,0 })
	Aadd(_aCampos,{"CDFIS" ,"C",03,0 })
	Aadd(_aCampos,{"ALICM" ,"C",05,0 })
	Aadd(_aCampos,{"VLCONT","C",14,0 })
	Aadd(_aCampos,{"ICMTRI","C",14,0 })
	Aadd(_aCampos,{"BASIPI","C",14,0 })
	Aadd(_aCampos,{"VALIPI","C",14,0 })
	Aadd(_aCampos,{"CDTRA" ,"C",14,0 })
	Aadd(_aCampos,{"VLSEG" ,"C",14,0 })
	Aadd(_aCampos,{"VLPTR" ,"C",14,0 })
	Aadd(_aCampos,{"TPDOC" ,"C",03,0 })
//	Aadd(_aCampos,{"CC"    ,"C",06,0 })	 Alteração para novo lay-out 20/03
	Aadd(_aCampos,{"CC"    ,"C",07,0 })	
	 aParc:= {}
	_cNome := CriaTrab(_aCampos)
	
	DbUseArea( .T.,,_cNome,"TRA",.F. )
	DbSelectArea("TRA")
	cIndex := CriaTrab(nil,.f.)
	cChave := "NF+CDCLI"
	nIndex :=IndRegua("TRA",cIndex,cChave,,,"Selecionando Registros...TRA")
	IF nRadio == 2
		Append from GEFCNOTA.TXT sdf
	Else
		Append from GEFCCTRC.TXT sdf
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
                If !(Dbseek(xFilial("SA1")+TRA->CDDEST,.T.))
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
		
         
         DbSelectArea("SA1")
         DbSetOrder(3)
          IF!(Dbseek(xFilial("SA1")+TRA->CDDEST,.T.)) // Alterado 23/01/02 para buscar dados do destinatario

          Endif 

         xCondcli := Alltrim(SA1->A1_COND)
         aParc := Condicao(Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2)),xCondcli,,Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))) 

         For I:=1 to len(aParc)           
         DbSelectArea("SF3")
         DbSetOrder(4)
If !(DbSeek(xFilial("SF3")+SA1->A1_COD+SA1->A1_LOJA+TRA->NF+TRA->TPDOC))
	Reclock("SF3",.T.)
	SF3->F3_FILIAL	:= xFilial("SF3")
	SF3->F3_REPROC	:= "N"
	SF3->F3_ENTRADA := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
	SF3->F3_NFISCAL := TRA->NF
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
    Else
       SF3->F3_SERIE  := "U"    
    EndIF	
    
	SF3->F3_CLIEFOR := substr(SA1->A1_COD+SA1->A1_LOJA,1,6)
	SF3->F3_LOJA    := substr(SA1->A1_COD+SA1->A1_LOJA,7,2)
	SF3->F3_CFO     := ALLTRIM(TRA->CDFIS)
	SF3->F3_ESTADO	:= SA1->A1_EST
	SF3->F3_EMISSAO := Ctod(Substr(TRA->XDATA,7,2)+"/"+Substr(TRA->XDATA,5,2)+"/"+Substr(TRA->XDATA,1,4))
	SF3->F3_ALIQICM := Val(Substr(tRA->ALICM,1,Len(TRA->ALICM)-2)+"."+Substr(TRA->ALICM,Len(TRA->ALICM)-1,2))
	SF3->F3_BASEICM := Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2))
	SF3->F3_VALCONT := Val(Substr(TRA->VLCONT,1,Len(TRA->VLCONT)-2)+"."+Substr(TRA->VLCONT,Len(TRA->VLCONT)-1,2))
	SF3->F3_VALICM	:= Val(Substr(TRA->ICMTRI,1,Len(TRA->ICMTRI)-2)+"."+Substr(TRA->ICMTRI,Len(TRA->ICMTRI)-1,2))
	SF3->F3_ESPECIE := IIF(TRA->TPDOC=="UNI"," NF","CTR")
	SF3->F3_TIPO    := IIf(TRA->CDFIS == "LIX" .Or. ALLTRIM(TRA->CDFIS) == "CI" .Or. ALLTRIM(TRA->CDFIS) == "58" .Or. ALLTRIM(TRA->CDFIS) == "55", "S" , " ")
	SF3->F3_BASEIPI := Val(Substr(TRA->BASIPI,1,Len(TRA->BASIPI)-2)+"."+Substr(TRA->BASIPI,Len(TRA->BASIPI)-1,2))
	SF3->F3_VALIPI	:= Val(Substr(TRA->VALIPI,1,Len(TRA->VALIPI)-2)+"."+Substr(TRA->VALIPI,Len(TRA->VALIPI)-1,2))
	
	IF TRA->CDFIS == "LIX" .Or. ALLTRIM(TRA->CDFIS) == "CI" .Or. ALLTRIM(TRA->CDFIS) == "58".Or. ALLTRIM(TRA->CDFIS) == "55"
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
        Next I
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


Static Function Errata()

If pos == 2
	te1:="Fornecedor nao existe.: "+tra->CDTRA+" "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 3
	te1:="Cliente Inexistente.: "+tra->CDCLI+" "+" Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 6
	te1:="Registro Fiscal existe - Documento "+tra->NF+cNL
	fWrite(nHdl,te1,Len(te1))
Endif

Return

