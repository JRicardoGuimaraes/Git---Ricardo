#INCLUDE "RWMAKE.CH"

*****************************************************************************
*****************************************************************************
*  Empresa  : GEFCO
*****************************************************************************
** Funcao   : GEFM33  Autor  : Saulo Muniz                   Data : 29/06/04                                                              *
*****************************************************************************
** Descricao: Relatório de Ageing dos Clientes.
*****************************************************************************
* Alteracao  : 
* Motivo     : 
*****************************************************************************
*****************************************************************************
// Alterado em 15/07/04 - Saulo Muniz
// Reformuldo intervalo de datas e regra de negócio
//
// Alterado em 11/08/04 - Saulo Muniz
// Definição de Separação por C.Custo +  Log de erro
//
// Alterado em 19/08/04 - Saulo Muniz
// Nova Definição Ordenação por Nome
//
// Alterado em 19/08/04 - Saulo Muniz
// Nova Definição Ordenação por Total a Receber
//
// Alterado em 12/11/04 - Saulo Muniz
// Nova Definição Agrupamento por filial
//
// Tabela de centro de custo (4o Digito)
// 1 - RDVM
// 2 - RDVM
// 4 - ILI     //  3 - ILI   TROCADO DO PARA COD. 4 FRANCISCO 12/01/05
// 5 - RMLAP
// 6 - RMA
// 7 - RMA
// 8 - RMA
//   

User Function GEFM33()
 
Local cDesc1 :=OemToAnsi("Imprime a posi‡„o dos titulos a receber relativo a data ba-")
Local cDesc2 :=OemToAnsi("se do sistema.")
Local cDesc3 :=" GEFCO - JAN/05"
Local wnrel
Local cString:="SE1"
Local nRegEmp:=SM0->(RecNo())
Local dOldDtBase := dDataBase
//
Public MV_PAR40
Public MV_PAR41
Public MV_PAR42
Public MV_PAR43
Public MV_PAR44
Public MV_PAR45
Public MV_PAR46
Public MV_PAR39
//
Private titulo  :=""
Private cabec1  :=""
Private cabec2  :=""
Private _mOrdTit	:=	""
Private aLinha  :={}
Private aReturn :={ OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private cPerg	 :="GEFM33"
Private nJuros  :=0
Private nLastKey:=0
Private nomeprog:="GEFM33"
Private tamanho :="G"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi("Ageing dos Clientes")  //"Posicao dos Titulos a Receber"
cabec1   := "      Nome do Cliente                         ( Até 90 Dias )   ( >90 DIAS <180 )   ( >180 DIAS <365)     +365 DIAS (A VENCER) ||  Até 90 Dias   ( >90 DIAS <180 )   ( >180 DIAS < 365 ) +365 DIAS(VENCIDOS) TOTAL RECEBER"
PutDtBase()
pergunte("FIN130",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros		            				³
//³ mv_par01		 // Do Cliente 										   ³
//³ mv_par02		 // Ate o Cliente									   ³
//³ mv_par03		 // Do Prefixo										   ³
//³ mv_par04		 // Ate o prefixo 									   ³
//³ mv_par05		 // Do Titulo									      ³
//³ mv_par06		 // Ate o Titulo									   ³
//³ mv_par07		 // Do Banco										   ³
//³ mv_par08		 // Ate o Banco										   ³
//³ mv_par09		 // Do Vencimento 									   ³
//³ mv_par10		 // Ate o Vencimento								   ³
//³ mv_par11		 // Da Natureza							        		³
//³ mv_par12		 // Ate a Natureza										³
//³ mv_par13		 // Da Emissao											³
//³ mv_par14		 // Ate a Emissao										³
//³ mv_par15		 // Qual Moeda											³
//³ mv_par16		 // Imprime provisorios							    	³
//³ mv_par17		 // Reajuste pelo vecto									³
//³ mv_par18		 // Impr Tit em Descont									³
//³ mv_par19		 // Relatorio Anal/Sint									³
//³ mv_par20		 // Consid Data Base?  								    ³
//³ mv_par21		 // Consid Filiais  ?  									³
//³ mv_par22		 // da filial										    ³
//³ mv_par23		 // a flial 										    ³
//³ mv_par24		 // Da loja  											³
//³ mv_par25		 // Ate a loja											³
//³ mv_par26		 // Consid Adiantam.?									³
//³ mv_par27		 // Da data contab. ?									³
//³ mv_par28		 // Ate data contab.?									³
//³ mv_par29		 // Imprime Nome    ?									³
//³ mv_par30		 // Outras Moedas   ?									³
//³ mv_par31         // Imprimir os Tipos									³
//³ mv_par32         // Nao Imprimir Tipos									³
//³ mv_par33         // Abatimentos  - Lista/Nao Lista/Despreza			    ³
//³ mv_par34         // Consid. Fluxo Caixa									³
//³ mv_par35         // Salta pagina Cliente								³
//³ mv_par36         // Data Base											³
//³ mv_par37         // Compoe Saldo por: Data da Baixa ou Data de Credito	³
//³ mv_par38		 // Unidade Operacional  					   ³
//³ mv_par39		 // Consolida Filiais 1=Sim 2=Nao
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF TOP
	IF TcSrvType() == "AS/400" .and. Select("__SE1") == 0
		ChkFile("SE1",.f.,"__SE1")
	Endif
#ENDIF

wnrel:="GEFM33"                    
aOrd :={OemToAnsi("Por Cliente")}     

//aOrd :={OemToAnsi("Por Cliente"),;	         
//        OemToAnsi("Por Ranking")}

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| FA130Imp(@lEnd,wnRel,cString)},titulo)  // Chamada do Relatorio

SM0->(dbGoTo(nRegEmp))
cFilAnt := SM0->M0_CODFIL

//Acerta a database de acordo com a database real do sistema
If mv_par20 == 1    // Considera Data Base
	dDataBase := dOldDtBase
Endif	

MV_PAR19 := 1  // FIXADO SINTETICO

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA130Imp ³ Autor ³ Paulo Boschetti		 ³ Data ³ 02/12/03³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime relat¢rio dos T¡tulos a Receber					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA130Imp(lEnd,WnRel,cString)								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd	  - A‡Æo do Codeblock				    			  ³±±
±±³			 ³ wnRel   - T¡tulo do relat¢rio 							  ³±±
±±³			 ³ cString - Mensagem										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA130Imp(lEnd,WnRel,cString)
Local CbCont
Local CbTxt
Local limite := 220
Local nOrdem
Local lContinua := .T.
Local cCond1,cCond2,cCond3,cCarAnt
Local nTit0:=0
Local nTit1:=0
Local nTit2:=0
Local nTit3:=0
Local nTit4:=0
Local nTit5:=0
Local nTotJ:=0
Local nTot0:=0
Local nTot1:=0
Local nTot2:=0
Local nTot3:=0
Local nTot4:=0
Local nTotTit:=0
Local nTotJur:=0
Local nTotFil0:=0
Local nTotFil1:=0
Local nTotFil2:=0
Local nTotFil3:=0
Local nTotFil4:=0
Local nTotFilTit:=0
Local nTotFilJ:=0
Local aCampos:={}
Local aTam:={}
Local nAtraso:=0
Local nTotAbat:=0
Local nSaldo:=0
Local dDataReaj
Local dDataAnt := dDataBase
Local lQuebra
Local nMesTit0 := 0
Local nMesTit1 := 0
Local nMesTit2 := 0
Local nMesTit3 := 0
Local nMesTit4 := 0
Local nMesTTit := 0
Local nMesTitj := 0
Local cIndexSe1
Local cChaveSe1
Local nIndexSE1
Local dDtContab
Local cTipos  := ""
Local aStru := SE1->(dbStruct()), ni
Local nTotsRec := SE1->(RecCount())
Local aTamCli := TAMSX3("E1_CLIENTE")
// variavel  abaixo criada p/pegar o nr de casas decimais da moeda
Local ndecs := Msdecimais(mv_par15)
Local nAbatim := 0
Private nRegSM0 := SM0->(Recno())
Private nAtuSM0 := SM0->(Recno())
PRIVATE dBaixa := dDataBase
PRIVATE cFilDe,cFilAte              

// Variaveis - Totalizadores
        TAVen30 := 0
        TAVen60 := 0
        TAVen90 := 0
        TAVen91 := 0
        TVenc30 := 0
        TVenc60 := 0
        TVenc90 := 0
        TVenc91 := 0    
        TTotRec := 0                

DbSelectArea("SE1")                      

nOrdem:=aReturn[8]
cMoeda:=Str(mv_par15,1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= "* Indica titulo provisorio, P Indica Saldo Parcial"
cbcont	:= 1
li 		:= 80
m_pag 	:= 1
SomaAbat("","","","R")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par21 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par22	// Todas as filiais
	cFilAte:= mv_par23
Endif

//Acerta a database de acordo com o parametro
If mv_par20 == 1    // Considera Data Base
	dDataBase := mv_par36
Endif	

	dbSelectArea("SE1")
	cFilAnt := SM0->M0_CODFIL
	Set Softseek On
	
	#IFDEF TOP
		if TcSrvType() != "AS/400"
			cQuery := "SELECT * "
			cQuery += "  FROM "+	RetSqlName("SE1")
			cQuery += " WHERE E1_FILIAL between '" + mv_par22        + "' AND '" + mv_par23 + "'"
			cQuery += "   AND D_E_L_E_T_ <> '*' "
		endif
	#ENDIF

	cCHCAB	:= ""
		//                  &&
	IF nOrdem = 1 			&& Por Nome Cliente
			_mOrdTit	:= " (Vencto)"
			cCHCAB    := "E1_NOMCLI+E1_CLIENTE+dtos(E1_VENCREA)"			
            cChaveSe1 := "E1_NOMCLI+E1_CLIENTE+dtos(E1_VENCREA)"			
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				cIndexSe1 := CriaTrab(nil,.f.)
				IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),OemToAnsi("Selecionando Registros..."))
				nIndexSE1 := RetIndex("SE1")
				dbSetOrder(nIndexSe1+1)
				dbSeek(xFilial("SE1"))
			else
				cOrder := SqlOrder(cChaveSe1)				
			endif
		#ELSE
			cIndexSe1 := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),OemToAnsi("Selecionando Registros..."))
			nIndexSE1 := RetIndex("SE1")
			dbSetIndex(cIndexSe1+OrdBagExt())
			dbSetOrder(nIndexSe1+1)
			dbSeek(xFilial("SE1"))
		#ENDIF
		cCond1 := "E1_CLIENTE <= mv_par02"
		cCond2 := "E1_CLIENTE + E1_LOJA"		
		titulo := titulo + OemToAnsi(" - Por Cliente")  //" - Por Cliente"
	
	Elseif nOrdem = 2		&& Por Ranking		

  	    cCHCAB    :="E1_FILIAL+STR(E1_VALOR,17,2)"
		cCond1 := "E1_CLIENTE <= mv_par02"
		cCond2 := "E1_CLIENTE + E1_LOJA"		
		titulo := titulo + OemToAnsi(" - Por Ranking")  //" - Por Numero"
		cChaveSe1 := "E1_FILIAL+STR(E1_VALOR,17,2)"

		#IFDEF TOP
			if TcSrvType() == "AS/400"
				cIndexSe1 := CriaTrab(nil,.f.)
				IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),OemToAnsi("Selecionando Registros..."))
				nIndexSE1 := RetIndex("SE1")
				dbSetOrder(nIndexSe1+1)
				dbSeek(xFilial("SE1"))
			else
				cOrder := SqlOrder(cChaveSe1)
			endif
		#ELSE
			cIndexSe1 := CriaTrab(nil,.f.)
			IndRegua("SE1",cIndexSe1,cChaveSe1,,Fr130IndR(),OemToAnsi("Selecionando Registros..."))
			nIndexSE1 := RetIndex("SE1")
			dbSetIndex(cIndexSe1+OrdBagExt())
			dbSetOrder(nIndexSe1+1)
			dbSeek(xFilial("SE1"))
		#ENDIF		
	Endif
    
	cFilterUser:=aReturn[7]
	Set Softseek Off
	
	#IFDEF TOP
		if TcSrvType() != "AS/400"
			cQuery += " AND E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02 + "'"
			cQuery += " AND E1_PREFIXO between '" + mv_par03        + "' AND '" + mv_par04 + "'"
			cQuery += " AND E1_NUM     between '" + mv_par05        + "' AND '" + mv_par06 + "'"
			cQuery += " AND E1_PORTADO between '" + mv_par07        + "' AND '" + mv_par08 + "'"
			cQuery += " AND E1_VENCREA between '" + DTOS(mv_par09)  + "' AND '" + DTOS(mv_par10) + "'"
			cQuery += " AND (E1_MULTNAT = '1' OR (E1_NATUREZ BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'))"
			cQuery += " AND E1_EMISSAO between '" + DTOS(mv_par13)  + "' AND '" + DTOS(mv_par14) + "'"
			cQuery += " AND E1_LOJA    between '" + mv_par24        + "' AND '" + mv_par25 + "'"
			cQuery += " AND E1_EMISSAO <=      '" + DTOS(dDataBase) + "'"
			cQuery += " AND ((E1_EMIS1  Between '"+ DTOS(mv_par27)+"' AND '"+DTOS(mv_par28)+"') OR E1_EMISSAO Between '"+DTOS(mv_par27)+"' AND '"+DTOS(mv_par28)+"')"
			If !Empty(mv_par31) // Deseja imprimir apenas os tipos do parametro 31
				cQuery += " AND E1_TIPO IN "+FormatIn(mv_par31,";") 
			ElseIf !Empty(Mv_par32) // Deseja excluir os tipos do parametro 32
				cQuery += " AND E1_TIPO NOT IN "+FormatIn(mv_par32,";")
			EndIf
			If mv_par18 == 2
				cQuery += " AND E1_SITUACA NOT IN ('2','7')"
			Endif
			If mv_par20 == 2
				cQuery += ' AND E1_SALDO <> 0'
			Endif
			If mv_par34 == 1
				cQuery += " AND E1_FLUXO <> 'N'"
			Endif

			cQuery += " ORDER BY "+ cOrder
			cQuery := ChangeQuery(cQuery)		                   
			//MEMOWRIT("Gefm33.SQL",CQUERY)
			
			dbSelectArea("SE1")
			dbCloseArea()
			dbSelectArea("SA1")			
			
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)
			
			For ni := 1 to Len(aStru)
				If aStru[ni,2] != 'C'
					TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next
		endif
	#ENDIF
	SetRegua(nTotsRec)
    //Msginfo(nTotsRec)
    _mIMP	:= 0

        // Variaveis para Ageing
		// A Vencer
        V_AVen30  := 0      // ATE 90
        V_AVen60  := 0      // >091 - <180    
        V_AVen90  := 0      // >181 - <365
        V_AVen91  := 0      // ACIMA DOS 365 
   
        // Vencidos
        V_Venc30  := 0      // ATE 90
        V_Venc60  := 0      // >091 - <180    
        V_Venc90  := 0      // >181 - <365
        V_Venc91  := 0      // ACIMA DOS 365 
   
        // Variaveis - Totalizadores
        xAVen30 := 0
        xAVen60 := 0
        xAVen90 := 0
        xAVen91 := 0
        xVenc30 := 0
        xVenc60 := 0
        xVenc90 := 0
        xVenc91 := 0

      	V_TotARec  := 0      // Total a receber
        V_TotVenc  := 0      // Pode receber total vencidos ou a vencer
        xTotRec := 0     

        ALog    := {}        // Array de Log de registros

	While !Eof() .and. &cCond1 .and. lContinua //.and. E1_FILIAL == xFilial("SE1")
     
		IF	lEnd
			@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")  //"CANCELADO PELO OPERADOR"
			Exit
		Endif

		IncRegua()

		Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5
   	    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega data do registro para permitir ³
		//³ posterior analise de quebra por mes.   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dDataAnt := Iif(nOrdem == 6 , SE1->E1_EMISSAO,  SE1->E1_VENCREA)
		
		cCarAnt := &cCond2
		_mCABEC	:=	space(5)
        xMS     := 0		
                
		If _mCABEC <> space(5) .and. _mIMP <> 0
			//
			@li,	0 PSAY _mCABEC
			Li++			
			//		
		Endif
            
            dbSelectArea("SA1")
			MSSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)
	        xCliPos:= SUBSTR(Alltrim(SA1->A1_CGC),1,11) 
	        cCond3 := SUBSTR(Alltrim(SA1->A1_CGC),1,11)

            dbSelectArea("SE1")				        
			While !Eof() .And. lContinua .And. cCond3 == xCliPos //SUBSTR(SA1->A1_CGC,1,11)
			//While &cCond2==cCarAnt .and. !Eof() .and. lContinua 	//.and. E1_FILIAL == xFilial("SE1")			
            xMS := 1
            
			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")  //"CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			EndIF
			
			IncRegua()
			
			dbSelectArea("SE1") 
			//
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Filtrar com base no Pto de entrada do Usuario...             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄJose Lucas, Localiza‡”es ArgentinaÄÙ
			//
			If !Empty(cTipos)
				If !(SE1->E1_TIPO $ cTipos)
					dbSkip()
					Loop
				Endif
			Endif
			//
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSkip()
				Loop
			Endif
			//
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Filtro da Unidade Operacional Gefco                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//MV_PAR - DESCR - = DG C.C   
            //
            //1    -   RDVM    = 1
            //2    -   ILI     = 4
            //3    -   RMLAP   = 5
            //4    -   RMA     = 6|7|8
            //5    -   Todos   = *                      
            // FILTRO DO 4 DG DO CENTRO DE CUSTO
            V_4DG     := Substr(Alltrim(SE1->E1_CCONT),4,1)  //Digito de controle do c.custo Gefco 
            
            Do Case
               Case Mv_Par38 == 1
                    XDG := "1"                  
               Case Mv_Par38 == 2
                    XDG := "4"                 
               Case Mv_Par38 == 3
                    XDG := "5"                 
               Case Mv_Par38 == 4
                    XDG := "6|7|8"                 
               Case Mv_Par38 == 5
                    XDG := " 1|2|3|4|5|6|7|8|9"  // Todos
               Otherwise
                    XDG := "*"
            EndCase
            
			// Grava Erros nos C.Custo
            If V_4DG $  "1|2|4|5|6|7|8"  // Digitos Possiveis do C. Custo
            
            Else      
               //xLog  := "Titulo sem U.O. = "+V_4DG+" Filial/Pref./Num. "+SE1->E1_FILIAL+" "+SE1->E1_PREFIXO+" "+SE1->E1_NUM+" Valor : "+Substr(SE1->E1_SALDO,1)
               AADD(ALog,{V_4DG,SE1->E1_FILIAL,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_VALOR}) 
            Endif   
            
            // Filtra por C.Custo       
            If V_4DG $ XDG            

            Else
               DbSkip()
               Loop      
            Endif               
            
            //
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se titulo, apesar do E1_SALDO = 0, deve aparecer ou ³
			//³ nÆo no relat¢rio quando se considera database (mv_par20 = 1) ³
			//³ ou caso nÆo se considere a database, se o titulo foi totalmen³
 			//³ te baixado.																  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//
			dbSelectArea("SE1")
			IF !Empty(SE1->E1_BAIXA) .and. Iif(mv_par20 == 2 ,SE1->E1_SALDO == 0 ,;
					IIF(mv_par37 == 1,(SE1->E1_SALDO == 0 .and. SE1->E1_BAIXA <= dDataBase),.F.))
				dbSkip()
				Loop
			EndIF
			//
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se trata-se de abatimento ou somente titulos³
			//³ at‚ a data base. 									 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//
			IF (SE1->E1_TIPO $ MVABATIM .And. mv_par33 != 1) .Or.;
				SE1->E1_EMISSAO>dDataBase
				dbSkip()
				Loop
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ser  impresso titulos provis¢rios		 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF E1_TIPO $ MVPROVIS .and. mv_par16 == 2
				dbSkip()
				Loop
			Endif		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ser  impresso titulos de Adiantamento	 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .and. mv_par26 == 2
				dbSkip()
				Loop
			Endif			
			// dDtContab para casos em que o campo E1_EMIS1 esteja vazio
			dDtContab := Iif(Empty(SE1->E1_EMIS1),SE1->E1_EMISSAO,SE1->E1_EMIS1)			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se esta dentro dos parametros ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SE1")
			IF SE1->E1_CLIENTE < mv_par01 .OR. SE1->E1_CLIENTE > mv_par02 .OR. ;
				SE1->E1_PREFIXO < mv_par03 .OR. SE1->E1_PREFIXO > mv_par04 .OR. ;
				SE1->E1_NUM	 	 < mv_par05 .OR. SE1->E1_NUM 		> mv_par06 .OR. ;
				SE1->E1_PORTADO < mv_par07 .OR. SE1->E1_PORTADO > mv_par08 .OR. ;
				SE1->E1_VENCREA < mv_par09 .OR. SE1->E1_VENCREA > mv_par10 .OR. ;
				SE1->E1_NATUREZ < mv_par11 .OR. SE1->E1_NATUREZ > mv_par12 .OR. ;
				SE1->E1_EMISSAO < mv_par13 .OR. SE1->E1_EMISSAO > mv_par14 .OR. ;
				SE1->E1_LOJA    < mv_par24 .OR. SE1->E1_LOJA    > mv_par25 .OR. ;
				dDtContab       < mv_par27 .OR. dDtContab       > mv_par28 .OR. ;
				SE1->E1_EMISSAO > dDataBase .Or. !&(fr130IndR())
				dbSkip()
				Loop
			Endif
			
			If mv_par18 == 2 .and. E1_SITUACA $ "27"
				dbSkip()
				Loop
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se deve imprimir outras moedas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par30 == 2 // nao imprime
				if SE1->E1_MOEDA != mv_par15 //verifica moeda do campo=moeda parametro
					dbSkip()
					Loop
				endif
			Endif
			
			dDataReaj := IIF(SE1->E1_VENCREA < dDataBase ,;
				IIF(mv_par17=1,dDataBase,E1_VENCREA),;
				dDataBase)
			
			If mv_par20 == 1	// Considera Data Base
				nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,mv_par15,dDataReaj,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0),IIF(mv_par37 == 1,.F.,.T.))
			Else
				nSaldo := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,mv_par15,dDataReaj,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
			Endif
			
			If ! SE1->E1_TIPO $ MVABATIM
				If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
						!( MV_PAR20 == 2 .And. nSaldo == 0 )  	// deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
					nAbatim := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",mv_par15,dDataReaj,SE1->E1_CLIENTE,SE1->E1_LOJA)
					If STR(nSaldo,17,2) == STR(nAbatim,17,2)
						nSaldo := 0
					ElseIf mv_par33 != 3
						nSaldo-= nAbatim
					Endif
				EndIf
			Endif	
			nSaldo:=Round(NoRound(nSaldo,3),2)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Desconsidera caso saldo seja menor ou igual a zero   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nSaldo <= 0
				dbSkip()
				Loop
			Endif
			
			dbSelectArea("SA1")
			MSSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)
	        cCond3 := SUBSTR(SA1->A1_CGC,1,11)
			
			dbSelectArea("SA6")
			MSSeek(cFilial+SE1->E1_PORTADO)
			
			dbSelectArea("SE1")
			
			IF li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
				If _mCABEC <> space(5)
					@li,	0 PSAY _mCABEC
					Li++			
				Endif
                _mIMP++			
			EndIF

			
            //IF cCond3 == SUBSTR(SA1->A1_CGC,1,11)  // RAIZ DO CNPJ
			
			//  CRIAR O TRATAMENTO DE TITULOS VENCIDOS E A VENCER
            //  NO SISTEMA. Ageing Novo              			
			V_TotARec := V_TotARec + nSaldo
			
			If dDataBase > E1_VENCREA	//vencidos				
			
			   V_DifDias := dDataBase - SE1->E1_VENCTO
               
               //Regra da Gefco especifica             
               Do Case
                  Case V_DifDias <= 90 
                       V_Venc30 := V_Venc30 + nSaldo 
                  Case V_DifDias >= 91  .And. V_DifDias <= 180
                       V_Venc60 := V_Venc60 + nSaldo 
                  Case V_DifDias >= 181  .And. V_DifDias <= 365
                       V_Venc90 := V_Venc90 + nSaldo 
                  Otherwise
                       V_Venc91 := V_Venc91 + nSaldo 
               EndCase
   		
			   If mv_par19 == 1
			   	  If ! SE1->E1_TIPO $ MVABATIM
				       @li, 116 PSAY nSaldo  Picture PesqPict("SE1","E1_SALDO",14,MV_PAR15)
				  EndIf
			   EndIf				

			   nJuros:=0
			   fa070Juros(mv_par15)
			   
			    dbSelectArea("SE1")
				If mv_par19 == 1
					@li,133 PSAY nSaldo+nJuros Picture PesqPict("SE1","E1_SALDO",14,MV_PAR15)
				EndIf
				If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG
					nTit0 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nTit1 -= (nSaldo)
					nTit2 -= (nSaldo+nJuros)
					nMesTit0 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nMesTit1 -= (nSaldo)
					nMesTit2 -= (nSaldo+nJuros)
					nTotJur  -= nJuros
					nMesTitj -= nJuros
					nTotFilJ -= nJuros
				Else
					If !SE1->E1_TIPO $ MVABATIM
						nTit0 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						nTit1 += (nSaldo)
						nTit2 += (nSaldo+nJuros)
						nMesTit0 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						nMesTit1 += (nSaldo)
						nMesTit2 += (nSaldo+nJuros)
						nTotJur  += nJuros
						nMesTitj += nJuros
						nTotFilJ += nJuros
					Endif	
				Endif
			Else			
			
			//a vencer
			
	   		    V_DifDias := SE1->E1_VENCTO - dDataBase             
                Do Case
                   Case V_DifDias <= 90  
                        V_AVen30 := V_AVen30 + nSaldo 
                   Case V_DifDias >= 91  .And. V_DifDias <= 180
                        V_AVen60 := V_AVen60 + nSaldo 
                   Case V_DifDias >= 181  .And. V_DifDias <= 365
                        V_AVen90 := V_AVen90 + nSaldo 
                   Otherwise
                        V_AVen91 := V_AVen30 + nSaldo 
                EndCase
      		
				If ! ( SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
					If !SE1->E1_TIPO $ MVABATIM
						nTit0 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						nTit3 += (nSaldo-nTotAbat)
						nTit4 += (nSaldo-nTotAbat)
						nMesTit0 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
						nMesTit3 += (nSaldo-nTotAbat)
						nMesTit4 += (nSaldo-nTotAbat)
					Endif
				Else
					nTit0 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nTit3 -= (nSaldo-nTotAbat)
					nTit4 -= (nSaldo-nTotAbat)
					nMesTit0 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par15,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
					nMesTit3 -= (nSaldo-nTotAbat)
					nMesTit4 -= (nSaldo-nTotAbat)
				Endif
				
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega data do registro para permitir ³
			//³ posterior an lise de quebra por mes.   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    		IncRegua()
			dDataAnt := Iif(nOrdem == 6, SE1->E1_EMISSAO, SE1->E1_VENCREA)		        
		    //xCliAnt  := Substr(Alltrim(Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_CGC")),1,11)			
		    xCliAnt  := IIF(mv_par29 == 1,Alltrim(SA1->A1_NREDUZ),Alltrim(SA1->A1_NOME))
			dbSkip()            
            //cCond3   := Substr(Alltrim(Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_CGC")),1,11)                                    
            xCliPos  := Substr(Alltrim(Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_CGC")),1,11)            
                       
	                
            IF xCliPos <> cCond3       
	      	   //dbSelectArea("SA1")
     		   //MSSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)
               
               If Empty(xCliPos)
                  cCond3 := xCliPos               
               Endif

               //If Empty(cCond3)
               //   xCliPos := cCond3               
               //Endif
               
               /*
               // A Vencer  
               @ li,000 PSAY xCliAnt
               @ li,046 Psay V_AVen30 Picture "@E 999,999,999.99"  //PesqPict("SE1","E1_VALOR",12,MV_PAR10)		            				     									
               @ li,064 Psay V_AVen60 Picture "@E 999,999,999.99"		            				     									
               @ li,082 Psay V_Aven90 Picture "@E 999,999,999.99"		            				     	  
               @ li,102 Psay V_Aven91 Picture "@E 999,999,999.99"								            
               // Vencidos   
               @ li,130 Psay V_Venc30  Picture "@E 999,999,999.99"
               @ li,148 Psay V_Venc60  Picture "@E 999,999,999.99"		            				     									
               @ li,163 Psay V_Venc90  Picture "@E 999,999,999.99"		            				     	  
               @ li,178 Psay V_Venc91  Picture "@E 999,999,999.99"								       
               @ li,198 Psay V_TotARec Picture "@E 999,999,999.99"        // Total a receber		            				     									                  
               li++     
    		   dbSelectArea("SE1")	                         
    		   */
        	ENDIF                
             
             
	   		   nTotTit ++
    		   nMesTTit ++
    		   nTotFiltit++
			   nTit5 ++			   
        	
		Enddo
        
        //dbSelectArea("SE1")
    	//dbSelectArea("SA1")
		//MSSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)
   	    //cCond3  := SUBSTR(SA1->A1_CGC,1,11) // RAIZ DO CNPJ
        //IF V_TotARec > 0 //.And. cCond3 == SUBSTR(SA1->A1_CGC,1,11)                      
        //IF V_TotARec > 0                    
        
        //IF xMS = 0 .And. V_TotARec > 0                    
     	   //dbSelectArea("SA1")
   		   //MSSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)

          // A Vencer  
          @ li,000 PSAY xCliAnt
          @ li,046 Psay V_AVen30 Picture "@E 999,999,999.99"  //PesqPict("SE1","E1_VALOR",12,MV_PAR10)		            				     									
          @ li,064 Psay V_AVen60 Picture "@E 999,999,999.99"		            				     									
          @ li,082 Psay V_Aven90 Picture "@E 999,999,999.99"		            				     	  
          @ li,102 Psay V_Aven91 Picture "@E 999,999,999.99"								     
       
          // Vencidos   
          @ li,130 Psay V_Venc30  Picture "@E 999,999,999.99"
          @ li,148 Psay V_Venc60  Picture "@E 999,999,999.99"		            				     									
          @ li,163 Psay V_Venc90  Picture "@E 999,999,999.99"		            				     	  
          @ li,178 Psay V_Venc91  Picture "@E 999,999,999.99"								       
          @ li,198 Psay V_TotARec Picture "@E 999,999,999.99"        // Total a receber		            				     									                  
   		    dbSelectArea("SE1")	                         
            li++  
            xMS := 1                
        //ENDIF
        
                
        // Totalizadores (Filial) do relatorio
        xAVen30 := xAVen30 + V_AVen30
        xAVen60 := xAVen60 + V_AVen60
        xAVen90 := xAVen90 + V_AVen90
        xAVen91 := xAVen91 + V_AVen91
        xVenc30 := xVenc30 + V_Venc30
        xVenc60 := xVenc60 + V_Venc60
        xVenc90 := xVenc90 + V_Venc90
        xVenc91 := xVenc91 + V_Venc91
        xTotRec := xTotRec + V_TotARec
       
		// Variaveis para Ageing
		// A Vencer
        V_AVen30  := 0      // ATE 90
        V_AVen60  := 0      // >091 - <180    
        V_AVen90  := 0      // >181 - <365
        V_AVen91  := 0      // ACIMA DOS 365    
        // Vencidos
        V_Venc30  := 0      // ATE 90
        V_Venc60  := 0      // >091 - <180    
        V_Venc90  := 0      // >181 - <365
        V_Venc91  := 0      // ACIMA DOS 365 
      	V_TotARec  := 0     // Total a receber
      	   
		Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur,nTotAbat
	Enddo
	
	dbSelectArea("SE1")		// voltar para alias existente, se nao, nao funciona		
	
	Store 0 To nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ

	#IFDEF TOP
		if TcSrvType() != "AS/400"
			dbSelectArea("SE1")
			dbCloseArea()
			ChKFile("SE1")
			dbSelectArea("SE1")
			dbSetOrder(1)
		endif
	#ENDIF
	    

        // Totalizadores (Geral) do relatorio
        // Saulo Muniz
          TAVen30 := TAVen30 + xAVen30
          TAVen60 := TAVen60 + xAVen60
          TAVen90 := TAVen90 + xAVen90
          TAVen91 := TAVen91 + xAVen91
          TVenc30 := TVenc30 + xVenc30
          TVenc60 := TVenc60 + xVenc60
          TVenc90 := TVenc90 + xVenc90
          TVenc91 := TVenc91 + xVenc91
          TTotRec := TTotRec + xTotRec
	
    	  TotGer130(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,TAVen30,TAVen60,TAVen90,TAVen91,TVenc30,TVenc60,TVenc90,TVenc91)
          
          If Len(ALog) > 0 
            //MsgInfo(ALog)
            li++  
            For I:=1 to len(ALog)
              @ li,002 Psay "| U.O. Não Encontrada : " 		            				     									
              @ li,028 Psay ALog[i][1]+" |"
              @ li,044 Psay "| Filial : "+ALog[i][2]
              @ li,060 Psay "| Pref/Numero : "+ALog[i][3]+" / "+ALog[i][4] +" |"
              @ li,090 Psay " Valor : "
              @ li,100 Psay ALog[i][5] Picture "@E 99,999,999.99"
              //@ _linha,105 Psay "|" 		            				     									
              li++  
            Next
          EndIf  
          
Set Device To Screen
#IFNDEF TOP
	dbSelectArea("SE1")
	dbClearFil(NIL)
	RetIndex( "SE1" )
	If !Empty(cIndexSE1)
		FErase (cIndexSE1+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	if TcSrvType() != "AS/400"
		dbSelectArea("SE1")
		dbCloseArea()
		ChKFile("SE1")
		dbSelectArea("SE1")
		dbSetOrder(1)
	else
		dbSelectArea("SE1")
		dbClearFil(NIL)
		RetIndex( "SE1" )
		If !Empty(cIndexSE1)
			FErase (cIndexSE1+OrdBagExt())
		Endif
		dbSetOrder(1)
	endif
#ENDIF         

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
Endif
MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SubTot130 ³ Autor ³ Paulo Boschetti 		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprimir SubTotal do Relatorio										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ SubTot130()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³																				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso 	    ³ Generico																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// SEM USO !

Static Function SubTot130(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,_mCABEC)
LOCAL aSituaca := {OemToAnsi("Carteira"),OemToAnsi("Simples"),;  			//"Carteira"###"Simples"
	OemToAnsi("Descontada"),OemToAnsi("Caucionada"),OemToAnsi("Vinculada"),;  //"Descontada"###"Caucionada"###"Vinculada"
	OemToAnsi("Advogado"),OemToAnsi("Judicial"),OemToAnsi("Cauc Desc")}  //"Advogado"###"Judicial"###"Cauc Desc"

IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
EndIF
    
    IF V_TotARec > 0
    // A Vencer  
    @ li,000 PSAY IIF(mv_par29 == 1,SA1->A1_NREDUZ,SA1->A1_NOME)//+" "+SA1->A1_DDD+"-"+SA1->A1_TEL+ " "+ "Loja - " + Right(cCarAnt,2)+Iif(mv_par21==1," Filial - "+cFilAnt,"") //"Loja - "###" Filial - "
    @ li,046 Psay V_AVen30 Picture "@E 999,999,999.99"  //PesqPict("SE1","E1_VALOR",12,MV_PAR10)		            				     									
    @ li,064 Psay V_AVen60 Picture "@E 999,999,999.99"		            				     									
    @ li,082 Psay V_Aven90 Picture "@E 999,999,999.99"		            				     	  
    @ li,102 Psay V_Aven91 Picture "@E 999,999,999.99"								     
       
    // Vencidos   
    @ li,130 Psay V_Venc30  Picture "@E 999,999,999.99"
    @ li,148 Psay V_Venc60  Picture "@E 999,999,999.99"		            				     									
    @ li,163 Psay V_Venc90  Picture "@E 999,999,999.99"		            				     	  
    @ li,178 Psay V_Venc91  Picture "@E 999,999,999.99"								       
    @ li,198 Psay V_TotARec Picture "@E 999,999,999.99"        // Total a receber		            				     									                  

    li++
    
    ENDIF
    
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ TotGer130³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ TotGer130()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³																				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function TotGer130(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ)

li++
IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
EndIF

// Lay-out do Ageing - TOTAL GERAL
@ li,000 PSAY OemToAnsi("T O T A L   G E R A L ----> ") //"T O T A L   G E R A L ----> " + " " + Iif(mv_par21==1,cFilAnt,"")
@ li,046 Psay TAVen30 Picture "@E 999,999,999.99"		            				     									
@ li,064 Psay TAVen60 Picture "@E 999,999,999.99"		            				     									
@ li,082 Psay TAVen90 Picture "@E 999,999,999.99"		            				     									
@ li,102 Psay TAVen91 Picture "@E 999,999,999.99"		            				     									
@ li,130 Psay TVenc30 Picture "@E 999,999,999.99"		            				     									
@ li,148 Psay TVenc60 Picture "@E 999,999,999.99"		            				     	  
@ li,163 Psay TVenc90 Picture "@E 999,999,999.99"								     
@ li,178 Psay TVenc91 Picture "@E 999,999,999.99"		            				     									
@ li,198 Psay TTotRec Picture "@E 999,999,999.99"		            				     	  
li++
li++

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ImpFil130³ Autor ³ Paulo Boschetti  	  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpFil130()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³																				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso 	    ³ Generico																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpFil130(nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ)

IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fr130Indr ³ Autor ³ Wagner           	  ³ Data ³ 12.12.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Indregua para impressao do relat¢rio						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fr130IndR()
Local cString

cString := 'E1_FILIAL>="'+mv_par22+'".and.E1_FILIAL<="'+mv_par23+'".And.'
cString += 'E1_CLIENTE>="'+mv_par01+'".and.E1_CLIENTE<="'+mv_par02+'".And.'
cString += 'E1_PREFIXO>="'+mv_par03+'".and.E1_PREFIXO<="'+mv_par04+'".And.'
cString += 'E1_NUM>="'+mv_par05+'".and.E1_NUM<="'+mv_par06+'".And.'
cString += 'DTOS(E1_VENCREA)>="'+DTOS(mv_par09)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par10)+'".And.'
cString += '(E1_MULTNAT == "1" .OR. (E1_NATUREZ>="'+mv_par11+'".and.E1_NATUREZ<="'+mv_par12+'")).And.'
cString += 'DTOS(E1_EMISSAO)>="'+DTOS(mv_par13)+'".and.DTOS(E1_EMISSAO)<="'+DTOS(mv_par14)+'"'
If !Empty(mv_par31) // Deseja imprimir apenas os tipos do parametro 31
	cString += '.And.E1_TIPO$"'+mv_par31+'"'
ElseIf !Empty(Mv_par32) // Deseja excluir os tipos do parametro 32
	cString += '.And.!(E1_TIPO$'+'"'+mv_par32+'")'
EndIf
IF mv_par34 == 1  // Apenas titulos que estarao no fluxo de caixa
	cString += '.And.(E1_FLUXO!="N")'	
Endif
Return cString

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PutDtBase³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 18/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Acerta parametro database do relatorio                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Finr130.prx                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PutDtBase()
Local _sAlias	:= Alias()

dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek("FIN13036")
	//Acerto o parametro com a database
	RecLock("SX1",.F.)
	Replace x1_cnt01		With "'"+DTOC(dDataBase)+"'"
	MsUnlock()	
Endif

dbSelectArea(_sAlias)

Return

Static Function IMPLOG()

 xLog  := "Titulo sem U.O. = "+V_4DG+" Filial/Pref./Num. "+SE1->E1_FILIAL+" "+SE1->E1_PREFIXO+" "+SE1->E1_NUM+" Valor : "+Substr(SE1->E1_SALDO,1)

 @ li,064 Psay xLog

li++
li++

Return
