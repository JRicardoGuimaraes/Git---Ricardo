#include "rwmake.ch"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GEFM59    ³ Autor ³ Marcos Furtado        ³ Data ³ 28.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Importacao de notas fiscais  : Sintegra reg.71              ³±±
±±³          ³Sistema ADHOC                                               ³±±
±±³          ³                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GEFM59()   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,001 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo  - AdHoc - Sintegra 71")
@ 002,010 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say " de Notas Fiscais referetes ao CTRC - Sistema AdHoc."
//@ 40,018 Say "Informe o Layout"
//@ 40,070 COMBOBOX cTipoarq ITEMS aChoice size 20,10
@ 60,098 BMPBUTTON TYPE 01 ACTION Processa({|| Sint71() },"Processando....")
@ 60,128 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return



Static Function Sint71()  // Versão VA2/VA3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cPathori := "\Importar\Sintegra\AdHoc\"
cTipo    := "*.TXT"
aFiles   := Directory(cPathOri + cTipo)
Close(oLeTxt)

For a := 1 To Len(aFiles)
	
	aCampos:={}
	AADD(aCampos,{ "LINHA" ,"C",400,0 })
	cNomArq := CriaTrab(aCampos)
	
	If (Select("TRB") <> 0)
		dbSelectArea("TRB")
		dbCloseArea("TRB")
	Endif
	dbUseArea(.T.,,cNomArq,"TRB",nil,.F.)
	
	If !File(Alltrim("\Importar\Sintegra\AdHoc\" + aFiles[a][1]))
		MsgBox("Arquivo texto nao existente.Programa cancelado","Informa‡ao","INFO")
		Return
	Endif
	
	dbSelectArea("TRB")
	Append From (Alltrim("\Importar\Sintegra\AdHoc\" + aFiles[a][1])) SDF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a regua de processamento                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Processa({|| RunCont() },"Processando...")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Copia o arquivo de trabalho e depois apaga                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If File("\Importar\Sintegra\AdHoc\" + aFiles[a][1])
		__CopyFile("\Importar\Sintegra\AdHoc\" + aFiles[a][1],"\Importar\Sintegra\AdHoc\Antigos\" + aFiles[a][1])
		Ferase("\Importar\Sintegra\AdHoc\" + aFiles[a][1])
	Endif
	
Next

//MsgBox("Importacao concluida!!","Informacao","INFO")

Return


Static Function RunCont()


dbSelectArea("TRB")
//dbSetOrder(1)
ProcRegua(RecCount()) // Numero de registros a processar
dbGoTop()

While !Eof()

		//Ignora registro diferentes do tipo 71.    	                    
    	If 	Substr(TRB->LINHA,01,02) <> "71" 
			DbselectArea("TRB")
			Dbskip()
			Loop	    		
    	EndIf
    	
	   	IncProc("Filial : " + cFilAnt  + "  Nota : "+Substr(TRB->LINHA,46,06))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava os campos obtendo os valores da linha lida do arquivo texto.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
	//If cDoc+cSerie <> Substr(TRB->LINHA,20,06)+Substr(TRB->LINHA,26,03) .And. !Empty(cDoc)
	//Endif
        cAborta := .F.        
        xDoc     := PadR(Alltrim(Substr(TRB->LINHA,46,06)),09) 
		cDoc     := IIf(Len(xDoc) < 6,"0"+xDoc,xDoc)  //Substr(TRB->LINHA,54,06)	    
		cSerie   := Space(3) //Substr(TRB->LINHA,26,03)	    
        xTipoCgc := ""
        cSerNf   := Substr(TRB->LINHA,92,03) 
        cNumNf   :=	Substr(TRB->LINHA,95,06)      
        dDataNf  := Ctod(Substr(TRB->LINHA,88,02) + "/" + Substr(TRB->LINHA,86,02) + "/" + Substr(TRB->LINHA,82,04)) 
        //dDataNf  := Ctod(Substr(TRB->LINHA,57,08)) 
        nValnf   := Val(Alltrim(Substr(TRB->LINHA,101,15))) 
//        cCgcRem  := Alltrim(Substr(TRB->LINHA,21,15)) 
        cCgcRem  := Alltrim(Substr(TRB->LINHA,54,14))         //Alteração - Marcos Furtado - 10/08/2006  
//      cCgcDest := Alltrim(Substr(TRB->LINHA,54,15))                                              
//        cCgcDest := Alltrim(Substr(TRB->LINHA,36,15))   //Alteração - Marcos Furtado - 09/08/2006  
        cCgcDest := Alltrim(Substr(TRB->LINHA,54,14))   //Alteração - Marcos Furtado - 10/08/2006  
        cEst     := Substr(TRB->LINHA,52,02)       //Estado
        cInscr   := Substr(TRB->LINHA,68,14)       //Incrição Estadual        
        _cFilial  := cFilAnt
        //cCgcFim  := Alltrim(Substr(TRB->LINHA,,06))         
        cTomador := "R"
        // R/D/C
         
        Do Case 
           Case Alltrim(cTomador) == "R" 
                xTipoCgc  := cCgcDest
	       Case Alltrim(cTomador) == "D" 
                xTipoCgc  := cCgcRem	    
	       Case Alltrim(cTomador) == "C" 
                //xTipoCgc  := ""	       // ???
                xTipoCgc  := cCgcDest	       	
	       OtherWise
                xTipoCgc  := ""

        EndCase
        
		dbSelectArea("SZ5")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek(_cFilial + cDoc + cNumNf )
			//MsgBox("Nota Fiscal ja importada: " + cDoc + " Operação Cancelada ! ","Informacao","INFO")
    		dbSelectArea("TRB")
			cAborta := .T.
		    DbSkip()
		    Loop
		Endif
		
		If !cAborta	.And. !Empty(cDoc)
    		dbSelectArea("SZ5")
    		Reclock("SZ5",.T.)
     		SZ5->Z5_FILIAL  := _cFilial
//          SZ5->Z5_CGCREM  := xTipoCgc
	        SZ5->Z5_CGCREM  := cCgcRem            
        	SZ5->Z5_SERIE   := cSerNf
	    	SZ5->Z5_NUM     := cNumNf
    		SZ5->Z5_VALOR   := nValnf /100
	    	SZ5->Z5_DTNOTA  := dDataNf
    		SZ5->Z5_CTRC    := cDoc               
    		SZ5->Z5_SERCTR  := cSerie	
			SZ5->Z5_EST		:= cEst
			SZ5->Z5_INSCR	:= cInscr
    		
	    	Msunlock()        
        
        Endif
        
		DbselectArea("TRB")
		Dbskip()

End

//fClose(nHdl)

//MsgInfo("Importacao Concluida com Sucesso !!")
DBCLOSEAREA("TRB")

Return