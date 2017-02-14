#INCLUDE "Matr914.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MATR914   ³ Autor ³ Thiago Galvao Silveira   ³ Data ³ 25.07.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Registro de Apuracao do ISS 									 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³MATR914                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function Matr914X()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aNfCancel := {}
titulo	:=	STR0001 //"Registro de Apuracao do ISS"
cDesc1	:=	STR0002 //"Este relatório ira imprimir os Registro de Apuraçãao referentes a Imposto Sobre "
cDesc2	:=	STR0003 //"Servicos de Qualquer Natureza, conforme o periodo informado."
cDesc3	:=	""
aReturn  :=	{ STR0004, 1,STR0005, 2, 2, 1, "",1 } //"Zebrado"###"Administracao"
nomeprog :=	"MATR914"
cPerg    :=	"MTR914"
nLastKey :=	0
Limite   := 132
Tamanho  :=	"M"      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cString  :=	"SF3"
Titulo   :=	STR0006 //"REGISTRO DE APURAÇÃO DO ISS - IMPOSTO SOBRE SERVICOS DE QUALQUER NATUREZA"
cabec1   :=	""
cabec2   :=	""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Ano                                  ³
//³ mv_par02             // Mes                                  ³
//³ mv_par03             // Livro Selecionado                    ³
//³ mv_par04             // Apuracao                             ³
//³ mv_par05             // Quebra por CFOP ou Aliquota          ³
//³ mv_par06             // Num Guia Rec Imp Propr.              ³
//³ mv_par07             // Data da Guia Rec                     ³
//³ mv_par08             // Banco                                ³
//³ mv_par09             // Num Guia Rec Imp Ret                 ³
//³ mv_par10             // Quebra por CFOP ou Aliquota          ³
//³ mv_par11             // Banco                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel	:=	"MATR914"   // nome default do relatorio em disco
wnrel	:=	SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho)

nPagina	:=	0

If nLastKey == 27
	dbClearFilter()
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	dbClearFilter()
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao de Termo / Livro                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case mv_par14==1 ; lImpLivro:=.T. ; lImpTermos:=.F.
	Case mv_par14==2 ; lImpLivro:=.T. ; lImpTermos:=.T.
	Case mv_par14==3 ; lImpLivro:=.F. ; lImpTermos:=.T.
EndCase     

//³ Recebe filtro definido pelo usuario                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPagina	:=	MV_PAR12
cFilterUser	:=	aReturn[7]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa relatorio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lImpLivro
   RptStatus({|lEnd| ImpRel(@lEnd,wnRel,cString,Tamanho, nPagina)},titulo)
Else
   If lImpTermos
	  R914ImpTerm(cPerg)
   EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura Ambiente                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF3")
dbSetOrder(1)
If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRel()    ³ Autor ³ Thiago Galvao      ³ Data ³25/07/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Registro de Apuracao de ISS                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR914()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpRel(lEnd,wnRel,cString,Tamanho, nPagina)       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Variaveis                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cAliasSF3 := "SF3"
Local cAliasR01 := "R01"
Local cAlias    := ""
Local lQuery    := .F.
Local aLay      := Array(35)
Local nLin      := 0
Local cMes      := ""                                                    
Local cImp      := "IS"                                                  
Local nMes	    := mv_par01
Local nAno	    := mv_par02
Local cNrLivro  := mv_par03
Local nApuracao := mv_par04
Local lQuebra	:= If(mv_par05 == 1,.T.,.F.)
Local nNumGPr   := mv_par06
Local nDataPr   := mv_par07
Local cBancoPr  := mv_par08
Local nNumGRet	:= mv_par09
Local nDataRet  := mv_par10
Local cBancoRet	:= mv_par11
Local cArqApur	:= NmArqApur(cImp,nAno,nMes,nApuracao,1,cNrLivro)
local nValDoc	:= 0.00
local nValDocA	:= 0.00
local nValDocC	:= 0.00
Local nBaseCalc := 0.00
local nImpIncid := 0.00
Local cDia		:= ""
local nNumNota  := 0
local nSerie    := 0
local nValIsen  := 0.00
Local nAliquota := 0
Local cIssApur  := ""
Local cObslin1  := ""
Local cObslin2  := ""
Local cObslin3  := ""
Local cObslin4  := ""
Local nLinObs   := 1
Local cCond	    := ""
Local lRodape	:= .F.
Local lFim   	:= .F.
Local nContr	:= 1
Local lDecendial:= .F. 
Local lQuinzenal:= .F.
Local lMensal   := .F.
Local cDiaApur  := ""
Local nFeixe	:= 0
Local nX 		:= 0    
Local lHouveMov	:= .F.  
Local cDiaTot   := ""  //Variavel para controlar a quebra diaria.
Local nTotDTrb  := 0
Local nTotDIsen := 0

Private aDatas	:= DetDatas(nMes,nAno,nApuracao,1)
Private dDtIni	:= aDatas[1]
Private dDtFim	:= aDatas[2]


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Condicional                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF3")
#IFDEF TOP
   lQuery := .T.   
	cAliasSF3 := GetNextAlias() 
	aStru  := SF3->(dbStruct())
	cQuery := "SELECT F3_ALIQICM,F3_CFO,F3_BASEICM,F3_ISENICM,F3_OUTRICM,F3_VALCONT,F3_VALICM,F3_NFISCAL,F3_SERIE,F3_ENTRADA,F3_DTCANC"
	cQuery += "FROM "+RetSqlName("SF3")+" "
	cQuery += "WHERE F3_FILIAL='"+xFilial("SF3")+"' AND "    
	cQuery += "F3_TIPO ='S'  AND "
	cQuery += "F3_CFO >'5"+SPACE(LEN(F3_CFO)-1)+"'AND "
	cQuery += "F3_ENTRADA>='"+Dtos(dDtIni)+"' AND "
	cQuery += "F3_ENTRADA<='"+Dtos(dDtFim)+"' AND "
	cQuery += "F3_CODISS<>'    ' AND "
//	cQuery += "F3_DTCANC='' AND "
    cQuery += "D_E_L_E_T_ = ' ' "
    If lQuebra
	   cQuery += "ORDER BY F3_ALIQICM,F3_ENTRADA, F3_SERIE,F3_NFISCAL"
	Else
	   cQuery += "ORDER BY F3_ENTRADA,F3_SERIE,F3_NFISCAL"
	Endif   
    cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF3,.T.,.T.)
	For nX := 1 To len(aStru)
		If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1])<>0
		   TcSetField(cAliasSF3,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
		EndIf
	Next nX
	dbSelectArea(cAliasSF3)	
#Else
	nIndex	:=	RetIndex("SF3")
	cArqInd	:=	CriaTrab(NIL,.F.)
    If lQuebra
     	cChave	:=	"STR(F3_ALIQICM)+F3_SERIE+F3_NFISCAL+DTOS(F3_ENTRADA)"
    Else
     	cChave	:=	"F3_SERIE+F3_NFISCAL+DTOS(F3_ENTRADA)"
    Endif 	
	cFiltro :=  "F3_FILIAL=='"+xFilial()+"'.AND.F3_TIPO=='S'.AND. F3_CFO >'5"+SPACE(LEN(F3_CFO)-1)+"'"
	cFiltro	+=	" .AND. dtos(F3_ENTRADA) >='"+dtos(dDtIni)+"' .and. dtos(F3_ENTRADA)<='"+dtos(dDtFim)+"'"
	cFiltro	+=	" .AND. Empty(F3_DTCANC) "
	
	If !(cNrLivro=="*")
	   cFiltro	+=	".AND.F3_NRLIVRO=='"+cNrLivro+"'"
	Endif
	
	IndRegua("SF3",cArqInd,cChave,,cFiltro,STR0007) //"Selecionando Registros..."
	dbGotop()
	SetRegua(LastRec())
#ENDIF


Do Case
	Case nApuracao==1 ; cDiaApur := "10" // Decendial
	Case nApuracao==2 ; cDiaApur := "15" // Quinzenal      
	Case nApuracao==3 ; cDiaApur := "31" // Mensal
EndCase

cMes := MesExtenso(Month(dDtIni))

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o campo memo Observacao da Apuracao do ISS           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIssApur := FisApur("IS",nAno,nMes,2,0,"*",.F.,{},1,.T.,"R01","")
	If !Empty((cAliasR01))
		(cAliasR01)->(DbGoTop())
		(cAliasR01)->(DBSEEK("OBS"))
		While !Empty(cAliasR01) .AND. nLinObs <= 4
			cObslin1:=	Iif(nLinObs==1,Substr((cAliasR01)->DESCR,1,45),cObslin1)		
			cObslin2:= 	Iif(nLinObs==2,Substr((cAliasR01)->DESCR,1,45),cObslin2)		
			cObslin3:= 	Iif(nLinObs==3,Substr((cAliasR01)->DESCR,1,45),cObslin3)		
			cObslin4:= 	Iif(nLinObs==4,Substr((cAliasR01)->DESCR,1,45),cObslin4)		
        	nLinObs   += 1
			dbSkip()
        EndDo	
	EndIf                                 '

If File(cIssApur)    
   Fclose(cIssApur)
   Ferase(cIssApur)
EndIf 
*/

R914LayOut(@aLay)
if !(cAliasSF3)->(Eof())
	cDiaTot :=  Substr(DTOS((cAliasSF3)->F3_ENTRADA),7,2)
EndIF

While !(cAliasSF3)->(Eof())
 
      nAliquota := (cAliasSF3)->F3_ALIQICM
  	
      cCond:= IIF(lQuebra,nAliquota==(cAliasSF3)->F3_ALIQICM,.T.)
  
      While cCond .AND. !(cAliasSF3)->(Eof()) .AND. cDia <= cDiaApur
      
      		lHouveMov := .T.
      		
            If nLin>=69
               FmtLin(,aLay[13],,,@nLin)
               nLin:= 0
            EndIf
	        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	        //³ Imprime o Cabecalho                                          ³
	        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	        If ( nLin > 70 .Or. nLin == 0 )
	        	nFeixe++
	           Cab(cAliasSF3,@nLin,aLay,cMes,nMes,nAno,lQuebra,nAliquota, @nPagina, @nFeixe)
	        EndIf

	        If !lQuery
		       IncRegua()
	        Endif
	  
	        If Interrupcao(@lEnd)
		       Exit
 	        Endif
	  
	        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	        //³ Considera filtro do usuario                                  ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         	If !Empty(cFilterUser).and.!(&cFilterUser)
		       dbSkip()
		       Loop
	        Endif                               
	        
		   IF !Empty((cAliasSF3)->F3_DTCANC)
			   aAdd(aNfCancel,{(cAliasSF3)->F3_NFISCAL})
//		       dbSkip()
//		       Loop
		   Else
		   
			
				//Alteração Marcos Furtado - 16/06/2006
	            If cDiaTot <>  Substr(DTOS((cAliasSF3)->F3_ENTRADA),7,2)
				    FmtLin(,aLay[13],,,@nLin)           
			        FmtLin({,,,IIf(nTotDTrb <> 0,nTotDTrb,""),,,IIf(nTotDIsen <> 0 ,nTotDIsen,"")},aLay[14],,,@nLin)		           
				    FmtLin(,aLay[13],,,@nLin)
				    FmtLin({,,,,,,,,,,},aLay[14],,,@nLin)
					nTotDTrb  := 0
					nTotDIsen := 0                           
					cDiaTot :=  Substr(DTOS((cAliasSF3)->F3_ENTRADA),7,2)				
	            EndIF
	            //Fim
	
	/*	        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		        //³ Campos de Valores Tributados                                 ³
	            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		        nValDoc := Iif((cAliasSF3)->F3_BASEICM+(cAliasSF3)->F3_ISENICM+(cAliasSF3)->F3_OUTRICM == 0,;
	    				(cAliasSF3)->F3_VALCONT,;  
						(cAliasSF3)->F3_BASEICM+(cAliasSF3)->F3_ISENICM+(cAliasSF3)->F3_OUTRICM)
	            nValDocA += nValDoc
	    
	            nBaseCalc += (cAliasSF3)->F3_BASEICM
	
	            nImpIncid += (cAliasSF3)->F3_VALICM
	
	
			    nTotDTrb  += nValDoc  //total do dia */
	
	   
		        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		        //³ Campos de Valores Nao Tributados                             ³
	            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	            IF (cAliasSF3)->F3_ISENICM+(cAliasSF3)->F3_OUTRICM > 0    	
	               nNumNota  := (cAliasSF3)->F3_NFISCAL
	 	           nSerie    := (cAliasSF3)->F3_SERIE
	               nValIsen  := (cAliasSF3)->F3_ISENICM+(cAliasSF3)->F3_OUTRICM
	               nValDocC  += nValIsen               
	               
				   nTotDIsen += nValIsen    // total do dia
		        Else
			        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			        //³ Campos de Valores Tributados                                 ³
		            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			        nValDoc := Iif((cAliasSF3)->F3_BASEICM+(cAliasSF3)->F3_ISENICM+(cAliasSF3)->F3_OUTRICM == 0,;
		    				(cAliasSF3)->F3_VALCONT,;  
							(cAliasSF3)->F3_BASEICM+(cAliasSF3)->F3_ISENICM+(cAliasSF3)->F3_OUTRICM)
		            nValDocA += nValDoc
		    
		            nBaseCalc += (cAliasSF3)->F3_BASEICM
		
		            nImpIncid += (cAliasSF3)->F3_VALICM
		
				    nTotDTrb  += nValDoc  //total do dia 
			        
	   	           nNumNota := ""
		           nSerie   := ""
	               nValIsen := 0	       
	            EndIf
	
		        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		        //³ Imprime os Valores                                           ³
	            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	            cDia := Substr(DTOS((cAliasSF3)->F3_ENTRADA),7,2)
	            
	            FmtLin(,aLay[13],,,@nLin)
	            If nValIsen = 0
		        	FmtLin({cDia,(cAliasSF3)->F3_NFISCAL,(cAliasSF3)->F3_SERIE,nValDoc,nNumNota,Transform(nSerie,"@e 99"),if(nValIsen <> 0,nValIsen,"")},aLay[14],,,@nLin)		
		        Else 
		        	FmtLin({cDia,,,,nNumNota,Transform(nSerie,"@e 99"),nValIsen},aLay[14],,,@nLin)			        
		        EndIF
		        
			EndIf	           
            (cAliasSF3)->(DbSkip())
       	               
 	        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	        //³Imprime o Rodape                                              ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If (lQuebra .AND. nAliquota <> (cAliasSF3)->F3_ALIQICM) .OR. (!lQuebra .AND. (cAliasSF3)->(Eof()))
      	        While .T.                                                     
					//Impressao do total do dia - marcos Furtado - 16/06/2006
				    FmtLin(,aLay[13],,,@nLin)           
			        FmtLin({,,,IIf(nTotDTrb <> 0,nTotDTrb,""),,,IIf(nTotDIsen <> 0 ,nTotDIsen,"")},aLay[14],,,@nLin)		           				    
	//			    FmtLin({,,,nTotDTrb,,,nTotDIsen},aLay[14],,,@nLin)		           
				    FmtLin(,aLay[13],,,@nLin)
				    FmtLin({,,,,,,,,,,},aLay[14],,,@nLin)
					nTotDTrb  := 0
					nTotDIsen := 0                           
				    //Fim
					      	        
	 		         While nLin <= 39
				           FmtLin(,aLay[13],,,@nLin)
				           FmtLin({,,,,,,,,,,},aLay[14],,,@nLin)
				     EndDo
					 If Empty(cObslin1) 
						cObslin1 := "NF Canceladas: "
					 EndIF
 					 If Len(aNfCAncel) > 0 
						For I := 1 to len(aNfCancel)
							If Len(cObslin1) < 60
								cObslin1 := cObslin1 + AllTrim(aNfCancel[I,1]) +  ", " 
							ElseIf Len(cObslin2) < 60
								cObslin2 := cObslin2 + AllTrim(aNfCancel[I,1]) +  ", " 		
							ElseIf Len(cObslin3) < 60		
								cObslin3 := cObslin3 + AllTrim(aNfCancel[I,1]) +  ", " 		
							ElseIf Len(cObslin4) < 60		
								cObslin4 := cObslin4 + AllTrim(aNfCancel[I,1]) +  ", " 		
							EndIF
						Next
						
					 EndIF                 

    		         If nLin==41
    		           	FmtLin(,aLay[15],,,@nLin)
			            FmtLin({TransForm(nValDocA,"@e 999,999,999.99"),TransForm(nValDocC,"@e 999,999,999.99")},aLay[16],,,@nLin)
			            FmtLin(,aLay[17],,,@nLin)
			            FmtLin({0},aLay[18],,,@nLin)
			            FmtLin(,aLay[19],,,@nLin)
			            FmtLin({TransForm(nBaseCalc,"@e 999,999,999.99")},aLay[20],,,@nLin)										
			            FmtLin(,aLay[21],,,@nLin)
			            FmtLin({nImpIncid,""},aLay[22],,,@nLin)
			            FmtLin(,aLay[23],,,@nLin)
			            FmtLin({nValDocA,nNumGPr,nDataPr},aLay[24],,,@nLin)		
			            FmtLin(,aLay[25],,,@nLin)
			            FmtLin({nImpIncid,cBancoPr},aLay[26],,,@nLin)	
			            FmtLin(,aLay[27],,,@nLin)
			            FmtLin(,aLay[28],,,@nLin)
		 	      		FmtLin({cObslin1},aLay[29],,,@nLin)
			      		FmtLin({cObslin2,nNumGRet,nDataRet},aLay[30],,,@nLin)
			      		FmtLin({cObslin3},aLay[31],,,@nLin)
			      		FmtLin({cObslin4,cBancoRet},aLay[32],,,@nLin)
			      		FmtLin(,aLay[33],,,@nLin)			
			      		nAliquota := (cAliasSF3)->F3_ALIQICM
			      	 	Exit
			   		 Else
	 		      		While nLin <= 68	 		
				        	  FmtLin(,aLay[13],,,@nLin)
				              FmtLin({,,,,,,,,,,},aLay[14],,,@nLin)		   
			            EndDo                                               				        
   	                    FmtLin(,aLay[13],,,@nLin)
                        nLin := 0
                        @ nLin,000 Psay aValImp(Limite)
                        nFeixe++
						Cab(cAliasSF3,@nLin,aLay,cMes,nMes,nAno,lQuebra,nAliquota, @nPagina, @nFeixe)                  
					 Endif
			   Enddo
			   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			   //³ Reinicialização das Variaveis                         ³
			   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
		  	   nLin      := 0
               lRodape   := .F.
               lFim	     := .F.           
               nValdocA  := 0
    		   nValdocC  := 0
    		   nBaseCalc := 0
    	 	   nImpIncid := 0
            EndIF
      EndDo
EndDo

// Sem movimentacao no periodo

if !lHouveMov

	Cab(cAliasSF3,@nLin,aLay,cMes,nMes,nAno,lQuebra,nAliquota,@npagina, @nFeixe)
    FmtLin(,aLay[13],,,@nLin)
	FmtLin(,aLay[34],,,@nLin)			

    While nLin <= 49
	    FmtLin(,aLay[13],,,@nLin)
	    FmtLin({,,,,,,,,,,},aLay[14],,,@nLin)
	EndDo

    FmtLin(,aLay[15],,,@nLin)
	FmtLin({TransForm(nValDocA,"@e 999,999,999.99"),TransForm(nValDocC,"@e 999,999,999.99")},aLay[16],,,@nLin)
	FmtLin(,aLay[17],,,@nLin)
	FmtLin({0},aLay[18],,,@nLin)
	FmtLin(,aLay[19],,,@nLin)
	FmtLin({TransForm(nBaseCalc,"@e 999,999,999.99")},aLay[20],,,@nLin)										
	FmtLin(,aLay[21],,,@nLin)
	FmtLin({nImpIncid,""},aLay[22],,,@nLin)
	FmtLin(,aLay[23],,,@nLin)
	FmtLin({nValDocA,nNumGPr,nDataPr},aLay[24],,,@nLin)		
	FmtLin(,aLay[25],,,@nLin)
	FmtLin({nImpIncid,cBancoPr},aLay[26],,,@nLin)	
	FmtLin(,aLay[27],,,@nLin)
	FmtLin(,aLay[28],,,@nLin)
	FmtLin({cObslin1},aLay[29],,,@nLin)
	FmtLin({cObslin2,nNumGRet,nDataRet},aLay[30],,,@nLin)
	FmtLin({cObslin3},aLay[31],,,@nLin)
	FmtLin({cObslin4,cBancoRet},aLay[32],,,@nLin)
	FmtLin(,aLay[33],,,@nLin)			
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exclui as areas de trabalho                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF TOP 
	( cAliasSF3 )->( dbCloseArea() ) 
	dbSelectArea( "SF3" ) 
#ELSE 	
	FErase( cArqInd + OrdBagExt() ) 		
	RetIndex( "SF3" ) 
#ENDIF 	
                 
If lImpTermos .AND. !lEnd
	R914ImpTerm(cPerg)
EndIf
Return( .T. ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R914LayOut  ³ Autor ³ Thiago Galvao      ³ Data ³25/07/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ LayOut do Registro de Apuracao de ISS                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR914()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function R914LayOut(aLay)

	aLay[01] := STR0008 //" REGISTRO DE APURACAO DO ISS  RAZAO SOCIAL : ############################################### CNPJ : ################## Pagina : ####"
	aLay[02] := STR0009 //"   IMPOSTO SOBRE SERVICOS     ENDERECO     : ############################################### Mes  : ##########            Ano : ####"
	aLay[03] := "+------+-------------------------------------------------------------------+---------------------------------+---------------------+"
	aLay[04] := STR0010 //"| Ano  |                     MOVIMENTO ECONOMICO TRIBUTAVEL                |    MOVIMENTO ECONOMICO ISENTO   | SERVICOS EXECUTADOS |"
	aLay[05] := "+------+                                                                   |                                 |                     |"
	aLay[06] := STR0011 //"| #### |                                                                   |         OU NAO TRIBUTAVEL       |  POR TERCEIROS COM  |"
	aLay[07] := "+------+----------------+----------------+----------------+----------------+----------------+----------------+                     |"
	aLay[08] := STR0012 //"| Mes  |  Notas Fiscais | Aliquota ##### | Notas Fiscais  | Aliquota       | Notas Fiscais  |                | RETENCAO DO IMPOSTO |"
	aLay[09] := "+------+                +----------------+                +----------------+                +----------------+                     |"
	aLay[10] := STR0013 //"| ##   |    Emitidas    | Codigo Fiscal  |   Emitidas     | Codigo Fiscal  |   Emitidas     | Codigo Fiscal  |                     |"
	aLay[11] := "+------+--------+-------+----------------+--------+-------+----------------+--------+-------+----------------+---------------------+"
	aLay[12] := STR0014 //"|      | Numero | Serie | R$             | Numero | Serie | R$             | Numero | Serie | R$             | R$                  |"
	aLay[13] := "+------+--------+-------+----------------+--------+-------+----------------+--------+-------+----------------+---------------------+"
	aLay[14] := "| ##   | ###### | ###   | ############## |        |       |                | ###### | ###   | ############## |                     |"
	aLay[15] := "+------+--------+-------+----------------+--------+-------+----------------+--------+-------+----------------+---+-----------------+"
	aLay[16] := STR0015 //"|      |  SOMA  |  (A)  | ############## |  SOMA  |  (B)  |                |  SOMA  |  (C)  | ############## |(D)|                 |"               
	aLay[17] := "+------+--------+-------+----------------+--------+-------+----------------+--------+-------+----------------+---+-----------------+"
	aLay[18] := STR0016 //"|       DEDUCOES        |                |          IMPOSTO RETIDO POR TERCEIROS - ALIQUOTA                  |(G)|                 |"
	aLay[19] := "+-----------------------+----------------+---------------------------------+---------------------------------+---+-----------------+"
	aLay[20] := STR0017 //"|    BASE DE CALCULO    | ############## |                                 |                  RECOLHIMENTOS                        |"                         
	aLay[21] := "+-------------------+---+----------------+------------+---+----------------+-------------------------------------------------------+"
	aLay[22] := STR0018 //"| IMPOSTO INCIDENTE |(E)| ############## |            |(F)|                | IMPOSTO PROPRIO ( E + F )                             |"
	aLay[23] := "+------+------------+---+----------------+--------+---+---+----------------+-------------------------------------------------------+"
	aLay[24] := STR0019 //"|TOTAIS| Movimento Economico Tributavel  |(A + B) |       | ############## | GUIA N : ##########               DE: ##/##/##        |"
	aLay[25] := "|------+---------------------------------+--------+-------+----------------+-------------------------------------------------------+"
	aLay[26] := STR0020 //"|      | Imposto a Recolher              |(E + F) |       | ############## | BANCO  : #####################################        |"
	aLay[27] := "|------+---------------------------------+--------+-------+----------------+-------------------------------------------------------+"
	aLay[28] := STR0021 //"|Observacoes:                                                              | IMPOSTO RETIDO POR TERCEIROS                          |"
	aLay[29] := STR0022 //"| ######################################################################## +-------------------------------------------------------+"
	aLay[30] := STR0023 //"| ######################################################################## | GUIA N: ##########                DE: ##/##/##        |"
	aLay[31] := STR0024 //"| ######################################################################## +-------------------------------------------------------+"
	aLay[32] := STR0025 //"| ######################################################################## | BANCO : ######################################        |"
	aLay[33] := "+--------------------------------------------------------------------------+-------------------------------------------------------+"
	aLay[34] := STR0026 //"|       *** NAO HOUVE MOVIMENTO ***      |        |       |                |        |       |                |                     |"
	
Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Cab         ³ Autor ³ Thiago Galvao      ³ Data ³25/07/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Impressão do Cabecaçho do Reg de Apur de ISS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR914()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Cab(cAliasSF3,nLin,aLay,cMes,nMes,nAno,lQuebra,nAliquota, nPagina, nFeixe)
		       If ( nLin == 60 )
			      FmtLin(,aLay[11],,,@nLin)
		       EndIf
		       nLin := 0
		       @ nLin,000 Psay aValImp(Limite)
		       nLin++
		       FmtLin({SM0->M0_NOMECOM,Transf(SM0->M0_CGC,"@R 99.999.999/9999-99"),StrZero(nPagina,4)},aLay[01],,,@nLin)
		       FmtLin({SM0->M0_ENDENT,cMes,Alltrim(STRZERO(nAno,4))},aLay[02],,,@nLin)                      
		       FmtLin(,aLay[03],,,@nLin)
		       FmtLin(,aLay[04],,,@nLin)
		       FmtLin(,aLay[05],,,@nLin)
		       FmtLin({Alltrim(STRZERO(nAno,4))},aLay[06],,,@nLin)
		       FmtLin(,aLay[07],,,@nLin)
		       FmtLin({Iif(!lQuebra,"XXXXX",Transf(nAliquota,"@R 99.99"))},aLay[08],,,@nLin)
		       FmtLin(,aLay[09],,,@nLin)
		       FmtLin({Alltrim(STRZERO(nMes,2))},aLay[10],,,@nLin)   	
		       FmtLin(,aLay[11],,,@nLin)
		       FmtLin(,aLay[12],,,@nLin)
			    //
				If (nFeixe==MV_PAR13)
					nPagina	:=	MV_PAR12
					nFeixe  :=	0
				Else
					nPagina++
				Endif
Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R914ImpTerm() ³ Autor ³ Juan Jose Pereira  ³ Data ³20/10/95³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime termos de Abertura e Encerramento                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR990, MATRISS                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R914ImpTerm(cPerg)

Local cArqAbert	:=	GetMv("MV_LISSAB")
Local cArqEncer	:=	GetMv("MV_LISSEN"), aDriver := ReadDriver()

XFIS_IMPTERM(cArqAbert,cArqEncer,cPerg,aDriver[4])

Return

