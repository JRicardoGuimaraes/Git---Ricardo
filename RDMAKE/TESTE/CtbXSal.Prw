#INCLUDE "PROTHEUS.CH"
#INCLUDE "CTBXSAL.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³SldAntCTU ³ Autor ³ Simone Mie Sato       ³ Data ³ 01.11.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Recupera saldo anterior a data inicial                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³SLDANTCTU(cIdent,cCodigo,dData,cMoeda,cTpSald,cFilX)  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Identificador				                      ³±±
±±³          ³ ExpC2 = Codigo da Entidade                                 ³±±
±±³          ³ ExpD1 = Data do Lancamento Contabil                        ³±±
±±³          ³ ExpC3 = Moeda do Lancamento Contabil                       ³±±
±±³          ³ ExpC4 = Tipo do Saldo                                  	  ³±±
±±³          ³ ExpC5 = Filial                                         	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function SLDANTCTU(cIdent,cCodigo,dData,cMoeda,cTpSald,cFilx)
                                                                           
Local aSaveArea		:= GetArea()
Local nAntDeb		:= 0	//Saldo anterior Debito  por Entidade
Local nAntCrd		:= 0	//Saldo anterior Credito por Entidade
Local nRecnoAnt		:= 0
Local bCond			:= {||.F.}

#IFDEF TOP
	Local cAliasCTU 	:= ""   		
	Local cOrderCTU 	:= ""
	Local cQuery		:= ""	
#ENDIF

If cFilX == Nil
	cFilX := xFilial("CTU")
EndIf

#IFDEF TOP                             
	If TcSrvType() != "AS/400"                     		
		cOrderCTU := SqlOrder(indexKey())
		cAliasCTU := "cAliasCTU"   		

		cQuery := "SELECT CTU_DATA, CTU_ATUDEB, CTU_ATUCRD "
		cQuery += "FROM "+RetSqlName("CTU")+" CTU "
		cQuery += "WHERE CTU.CTU_FILIAL ='"+cFilX+"' AND "
		cQuery += "CTU.CTU_MOEDA ='"+cMoeda+"' AND "
		cQuery += "CTU.CTU_TPSALD ='"+cTpSald+"' AND "
		cQuery += "CTU.CTU_CODIGO='"+cCodigo+"' AND "
		cQuery += "CTU.CTU_IDENT='"+cIdent+"' AND "			
		cQuery += "CTU.D_E_L_E_T_ <> '*' AND "				
		cQuery += "CTU.CTU_DATA = (SELECT MAX(CTU_DATA) "
		cQuery += "FROM "+RetSqlName("CTU")+" CTU2 "
		cQuery += "WHERE CTU2.CTU_FILIAL ='"+cFilX+"' AND "			
		cQuery += "CTU2.CTU_MOEDA = '"+cMoeda+"' AND "	 
		cQuery += "CTU2.CTU_TPSALD = '"+cTpSald+"' AND "					
		cQuery += "CTU2.CTU_CODIGO='"+cCodigo+"' AND "			 
		cQuery += "CTU2.CTU_IDENT='"+cIdent+"' AND "
		cQuery += "CTU2.CTU_DATA < '"+DTOS(dData)+"' AND "		 
		cQuery += "CTU2.D_E_L_E_T_ <> '*')"
		cQuery := ChangeQuery(cQuery)		   
	
		If ( Select ( "cAliasCTU" ) <> 0 )
			dbSelectArea ( "cAliasCTU" )
			dbCloseArea ()
		Endif

  		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCTU,.T.,.F.)
		nAntDeb 	:= (cAliasCTU)->CTU_ATUDEB
		nAntCrd 	:= (cAliasCTU)->CTU_ATUCRD			
		
		dbCloseArea()
		dbSelectArea("CTU")	                     
			
		If ( Select ( "AliasCTU" ) <> 0 )
			dbSelectArea ( "AliasCTU" )
			dbCloseArea ()
		Endif			                          
	Else
#ENDIF  //Se nao for TOP CONNECT	
	// Procura saldo anterior -> Para recalculo
	bCond	:= {||(cFilX+cIdent+cMoeda+cTpSald+cCodigo) == (CTU->CTU_FILIAL+CTU->CTU_IDENT+CTU->CTU_MOEDA+CTU->CTU_TPSALD+ CTU->CTU_CODIGO) .And. ;
				(!Bof() .And. !Eof())}
					
	dbSkip(-1)	
	If  Eval(bCond)		
		If CTU->CTU_ATUDEB <> 0 .Or. CTU->CTU_ATUCRD <> 0 
			nAntDeb 	:= CTU->CTU_ATUDEB
			nAntCrd 	:= CTU->CTU_ATUCRD		
		Else		        
			nRecnoAnt	:= Recno()		
			While Eval(bCond) .And. CTU->CTU_ATUDEB == 0 .And. CTU->CTU_ATUCRD == 0                    
					dbSkip(-1)
			End		
			If Eval(bCond)
				nAntDeb 	:= CTU->CTU_ATUDEB
				nAntCrd 	:= CTU->CTU_ATUCRD								
			EndIf                                                        
			dbGoto(nRecnoAnt)
		EndIf		
	Else
		nAntDeb	:= 0
		nAntCrd	:= 0
	EndIf
	If (!Bof())
		dbSkip()
	EndIf

#IFDEF TOP
Endif
#ENDIF

RestArea(aSaveArea)

Return{nAntDeb,nAntCrd}    
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³SldAntCTV ³ Autor ³ Simone Mie Sato       ³ Data ³ 01.11.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Recupera saldo anterior a data inicial                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³SLDANTCTV(cCusto,cItem,dData,cMoeda,cTpSald,cFilX)  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Centro de Custo                                    ³±±
±±³          ³ ExpC2 = Item Contabil                                      ³±±
±±³          ³ ExpD1 = Data do Lancamento Contabil                        ³±±
±±³          ³ ExpC3 = Moeda do Lancamento Contabil                       ³±±
±±³          ³ ExpC4 = Tipo do Saldo                                  	  ³±±
±±³          ³ ExpC5 = Filial                                         	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function SLDANTCTV(cCusto,cItem,dData,cMoeda,cTpSald,cFilx)
                                                                           
Local aSaveArea		:= GetArea()
Local nAntDeb		:= 0	//Saldo anterior Debito  C.Custo/Item
Local nAntCrd		:= 0	//Saldo anterior Credito C.Custo/Item
Local nRecnoAnt		:= 0
Local bCond			:= {||.F.}

#IFDEF TOP
	Local cAliasCTV 	:= ""   		
	Local cOrderCTV 	:= ""
	Local cQuery		:= ""	
#ENDIF
If cFilX == Nil
	cFilX := xFilial("CTV")
EndIf

#IFDEF TOP                             
	If TcSrvType() != "AS/400"                     		
		cOrderCTV := SqlOrder(indexKey())
		cAliasCTV := "cAliasCTV"   		

		cQuery := "SELECT CTV_DATA, CTV_ATUDEB, CTV_ATUCRD "
		cQuery += "FROM "+RetSqlName("CTV")+" CTV "
		cQuery += "WHERE CTV.CTV_FILIAL ='"+cFilX+"' AND "
		cQuery += "CTV.CTV_MOEDA ='"+cMoeda+"' AND "
		cQuery += "CTV.CTV_TPSALD ='"+cTpSald+"' AND "
		cQuery += "CTV.CTV_CUSTO='"+cCusto+"' AND "			
		cQuery += "CTV.CTV_ITEM='"+cItem+"' AND "
		cQuery += "CTV.D_E_L_E_T_ <> '*' AND "				
		cQuery += "CTV.CTV_DATA = (SELECT MAX(CTV_DATA) "
		cQuery += "FROM "+RetSqlName("CTV")+" CTV2 "
		cQuery += "WHERE CTV2.CTV_FILIAL ='"+cFilX+"' AND "			
		cQuery += "CTV2.CTV_MOEDA = '"+cMoeda+"' AND "	 
		cQuery += "CTV2.CTV_TPSALD = '"+cTpSald+"' AND "					
		cQuery += "CTV2.CTV_CUSTO='"+cCusto+"' AND "			 
		cQuery += "CTV2.CTV_ITEM='"+cItem+"' AND "
		cQuery += "CTV2.CTV_DATA < '"+DTOS(dData)+"' AND "		 
		cQuery += "CTV2.D_E_L_E_T_ <> '*')"
		cQuery := ChangeQuery(cQuery)		   
		
		If ( Select ( "cAliasCTV" ) <> 0 )
			dbSelectArea ( "cAliasCTV" )
			dbCloseArea ()
		Endif

	  	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCTV,.T.,.F.)
		nAntDeb 	:= (cAliasCTV)->CTV_ATUDEB
		nAntCrd 	:= (cAliasCTV)->CTV_ATUCRD			
		
		dbCloseArea()
		dbSelectArea("CTV")	                     
			
		If ( Select ( "AliasCTV" ) <> 0 )
			dbSelectArea ( "AliasCTV" )
			dbCloseArea ()
		Endif			
	Else
#ENDIF	//Se nao for TopConnect
   	
	// Procura saldo anterior -> Para recalculo
	bCond	:= {||(xFilial()+cMoeda+cTpSald+cItem+cCusto) == 	(CTV->CTV_FILIAL+CTV->CTV_MOEDA+CTV->CTV_TPSALD+ CTV->CTV_ITEM+CTV->CTV_CUSTO) .And.;
				(!Bof() .And. !Eof())}
	
	dbSkip(-1)
	If Eval(bCond)                                         
		If CTV->CTV_ATUDEB <> 0 .Or. CTV->CTV_ATUCRD <> 0 	
			nAntDeb 	:= CTV->CTV_ATUDEB
			nAntCrd 	:= CTV->CTV_ATUCRD			
		Else                              
			nRecnoAnt	:= Recno()		
			While Eval(bCond) .And. CTV->CTV_ATUDEB == 0 .And. CTV->CTV_ATUCRD == 0                    
					dbSkip(-1)
			End		
			If Eval(bCond)
				nAntDeb 	:= CTV->CTV_ATUDEB
				nAntCrd 	:= CTV->CTV_ATUCRD								
			EndIf                                                        
			dbGoto(nRecnoAnt)
		EndIf				
	Else
		nAntDeb	:= 0
		nAntCrd	:= 0
	EndIf
	If (!Bof())
		dbSkip()
	EndIf	
	
#IFDEF TOP
	EndIf
#ENDIF

RestArea(aSaveArea)

Return{nAntDeb,nAntCrd}                                    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³SldAntCTW ³ Autor ³ Simone Mie Sato       ³ Data ³ 01.11.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Recupera saldo anterior a data inicial                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³SLDANTCTW(cClVl,cCusto,dData,cMoeda,cTpSald,cFilX)  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Classe de valor                                    ³±±
±±³          ³ ExpC2 = Centro de Custo                                    ³±±
±±³          ³ ExpD1 = Data do Lancamento Contabil                        ³±±
±±³          ³ ExpC3 = Moeda do Lancamento Contabil                       ³±±
±±³          ³ ExpC4 = Tipo do Saldo                                  	  ³±±
±±³          ³ ExpC5 = Filial                                         	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function SLDANTCTW(cClVl,cCusto,dData,cMoeda,cTpSald,cFilx)
                                                                           
Local aSaveArea		:= GetArea()
Local nAntDeb		:= 0	//Saldo anterior Debito  Cl.Valor/ C.Custo
Local nAntCrd		:= 0	//Saldo anterior Credito Cl.Valor/ C.Custo
Local nRecnoAnt		:= 0
Local bCond			:= {||.F.}

#IFDEF TOP
	Local cAliasCTW 	:= ""   		
	Local cOrderCTW 	:= ""	
	Local cQuery		:= ""	
#ENDIF
If cFilX == Nil
	cFilX := xFilial("CTW")
EndIf

#IFDEF TOP                             
	If TcSrvType() != "AS/400"                     		
		cOrderCTW := SqlOrder(indexKey())
		cAliasCTW := "cAliasCTW"   		

		cQuery := "SELECT CTW_DATA, CTW_ATUDEB, CTW_ATUCRD "
		cQuery += "FROM "+RetSqlName("CTW")+" CTW "
		cQuery += "WHERE CTW.CTW_FILIAL ='"+cFilX+"' AND "
		cQuery += "CTW.CTW_MOEDA ='"+cMoeda+"' AND "
		cQuery += "CTW.CTW_TPSALD ='"+cTpSald+"' AND "
		cQuery += "CTW.CTW_CLVL='"+cClVl+"' AND "
		cQuery += "CTW.CTW_CUSTO='"+cCusto+"' AND "			
		cQuery += "CTW.D_E_L_E_T_ <> '*' AND "				
		cQuery += "CTW.CTW_DATA = (SELECT MAX(CTW_DATA) "
		cQuery += "FROM "+RetSqlName("CTW")+" CTW2 "
		cQuery += "WHERE CTW2.CTW_FILIAL ='"+cFilX+"' AND "			
		cQuery += "CTW2.CTW_MOEDA = '"+cMoeda+"' AND "	 
		cQuery += "CTW2.CTW_TPSALD = '"+cTpSald+"' AND "					
		cQuery += "CTW2.CTW_CUSTO='"+cCusto+"' AND "			 
		cQuery += "CTW2.CTW_CLVL='"+cClVl+"' AND "
		cQuery += "CTW2.CTW_DATA < '"+DTOS(dData)+"' AND "		 
		cQuery += "CTW2.D_E_L_E_T_ <> '*')"
		cQuery := ChangeQuery(cQuery)		   

		If ( Select ( "cAliasCTW" ) <> 0 )
			dbSelectArea ( "cAliasCTW" )
			dbCloseArea ()
		Endif

  		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCTW,.T.,.F.)
		nAntDeb 	:= (cAliasCTW)->CTW_ATUDEB
		nAntCrd 	:= (cAliasCTW)->CTW_ATUCRD			
	
		dbCloseArea()
		dbSelectArea("CTW")	                     
		
		If ( Select ( "AliasCTW" ) <> 0 )
			dbSelectArea ( "AliasCTW" )
			dbCloseArea ()
		Endif			
	Else	
#ENDIF	//Se nao for TopConnect   	
	// Procura saldo anterior -> Para recalculo
	bCond	:= {||(xFilial()+cMoeda+cTpSald+cClVl+cCusto) == (CTW->CTW_FILIAL+CTW->CTW_MOEDA+CTW->CTW_TPSALD+;
				 CTW->CTW_CLVL+CTW->CTW_CUSTO) .And.;
				(!Bof() .And. !Eof())}
				
	dbSkip(-1)
	If 	Eval(bCond)                                        
		If CTW->CTW_ATUDEB <> 0 .Or. CTW->CTW_ATUCRD <> 0 	
			nAntDeb 	:= CTW->CTW_ATUDEB
			nAntCrd 	:= CTW->CTW_ATUCRD
		Else
			nRecnoAnt	:= Recno()		
			While Eval(bCond) .And. CTW->CTW_ATUDEB == 0 .And. CTW->CTW_ATUCRD == 0                    
					dbSkip(-1)
			End		
			If Eval(bCond)
				nAntDeb 	:= CTW->CTW_ATUDEB
				nAntCrd 	:= CTW->CTW_ATUCRD								
			EndIf                                                        
			dbGoto(nRecnoAnt)
		EndIf				
	Else
		nAntDeb	:= 0
		nAntCrd	:= 0
	EndIf
	If (!Bof())
		dbSkip()
	EndIf                      
	
#IFDEF TOP	
	EndIf
#ENDIF

RestArea(aSaveArea)

Return{nAntDeb,nAntCrd}                                    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³SldAntCTX ³ Autor ³ Simone Mie Sato       ³ Data ³ 01.11.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Recupera saldo anterior a data inicial                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³SLDANTCTX(cClVl,cItem,dData,cMoeda,cTpSald,cFilX)  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Classe de valor                                    ³±±
±±³          ³ ExpC2 = Item                                               ³±±
±±³          ³ ExpD1 = Data do Lancamento Contabil                        ³±±
±±³          ³ ExpC3 = Moeda do Lancamento Contabil                       ³±±
±±³          ³ ExpC4 = Tipo do Saldo                                  	  ³±±
±±³          ³ ExpC5 = Filial                                         	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function SLDANTCTX(cClVl,cItem,dData,cMoeda,cTpSald,cFilx)
                                                                           
Local aSaveArea		:= GetArea()
Local nAntDeb		:= 0	//Saldo anterior Debito  Cl.Valor/ Item
Local nAntCrd		:= 0	//Saldo anterior Credito Cl.Valor/ Item
Local nRecnoAnt		:= 0
Local bCond			:= {||.F.}         

#IFDEF TOP                             
	Local cQuery		:= ""
	Local cOrderCTX 	:= ""
	Local cAliasCTX 	:= ""   		
#ENDIF

If cFilX == Nil
	cFilX := xFilial("CTX")
EndIf

#IFDEF TOP                             
	If TcSrvType() != "AS/400"                     		
		cOrderCTX := SqlOrder(indexKey())
		cAliasCTX := "cAliasCTX"   		

		cQuery := "SELECT CTX_DATA, CTX_ATUDEB, CTX_ATUCRD "
		cQuery += "FROM "+RetSqlName("CTX")+" CTX "
		cQuery += "WHERE CTX.CTX_FILIAL ='"+cFilX+"' AND "
		cQuery += "CTX.CTX_MOEDA ='"+cMoeda+"' AND "
		cQuery += "CTX.CTX_TPSALD ='"+cTpSald+"' AND "
		cQuery += "CTX.CTX_CLVL='"+cClVl+"' AND "
		cQuery += "CTX.CTX_ITEM='"+cItem+"' AND "			
		cQuery += "CTX.D_E_L_E_T_ <> '*' AND "				
		cQuery += "CTX.CTX_DATA = (SELECT MAX(CTX_DATA) "
		cQuery += "FROM "+RetSqlName("CTX")+" CTX2 "
		cQuery += "WHERE CTX2.CTX_FILIAL ='"+cFilX+"' AND "			
		cQuery += "CTX2.CTX_MOEDA = '"+cMoeda+"' AND "	 
		cQuery += "CTX2.CTX_TPSALD = '"+cTpSald+"' AND "					
		cQuery += "CTX2.CTX_CLVL='"+cClVl+"' AND "			 
		cQuery += "CTX2.CTX_ITEM='"+cItem+"' AND "
		cQuery += "CTX2.CTX_DATA < '"+DTOS(dData)+"' AND "		 
		cQuery += "CTX2.D_E_L_E_T_ <> '*')"
		cQuery := ChangeQuery(cQuery)		   

		If ( Select ( "cAliasCTX" ) <> 0 )
			dbSelectArea ( "cAliasCTX" )
			dbCloseArea ()
		Endif

  		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCTX,.T.,.F.)
		nAntDeb 	:= (cAliasCTX)->CTX_ATUDEB
		nAntCrd 	:= (cAliasCTX)->CTX_ATUCRD			
	
		dbCloseArea()
		dbSelectArea("CTX")	                     
			
		If ( Select ( "AliasCTX" ) <> 0 )
			dbSelectArea ( "AliasCTX" )
			dbCloseArea ()
		Endif			
	Else	//Se for AS/400
#ENDIF//Se nao for TopConnect

	bCond	:= {||(xFilial()+cMoeda+cTpSald+cItem+cClVl) == (CTX->CTX_FILIAL+CTX->CTX_MOEDA+CTX->CTX_TPSALD+CTX->CTX_ITEM+CTX->CTX_CLVL) .And.;
				(!Bof() .And. !Eof())}
				
	dbSkip(-1)
	If 	Eval(bCond)                                        
		If CTX->CTX_ATUDEB <> 0 .Or. CTX->CTX_ATUCRD <> 0 	
			nAntDeb 	:= CTX->CTX_ATUDEB
			nAntCrd 	:= CTX->CTX_ATUCRD
		Else
			nRecnoAnt	:= Recno()		
			While Eval(bCond) .And. CTX->CTX_ATUDEB == 0 .And. CTX->CTX_ATUCRD == 0                    
					dbSkip(-1)
			End		
			If Eval(bCond)
				nAntDeb 	:= CTX->CTX_ATUDEB
				nAntCrd 	:= CTX->CTX_ATUCRD								
			EndIf                                                        
			dbGoto(nRecnoAnt)
		EndIf				
	Else
		nAntDeb	:= 0
		nAntCrd	:= 0
	EndIf
	If (!Bof())
		dbSkip()
	EndIf                        	
	
#IFDEF TOP
	EndIf	
#ENDIF

RestArea(aSaveArea)

Return{nAntDeb,nAntCrd}

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³SldAntCTY ³ Autor ³ Simone Mie Sato       ³ Data ³ 08.05.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Recupera saldo anterior a data inicial                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³SLDANTCTY(cClVl,cItem,cCusto,dData,cMoeda,cTpSald,cFilX)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cClVl 	= Classe de valor                                 ³±±
±±³          ³ cItem	= Item                                            ³±±
±±³          ³ cCusto	= Centro de Custo                                 ³±±
±±³          ³ dData	= Data do Lancamento Contabil                     ³±±
±±³          ³ cMoeda	= Moeda do Lancamento Contabil                    ³±±
±±³          ³ cTpSald	= Tipo do Saldo                               	  ³±±
±±³          ³ cFilX	= Filial                                       	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function SLDANTCTY(cClVl,cItem,cCusto,dData,cMoeda,cTpSald,cFilx)
                                                                           
Local aSaveArea		:= GetArea()
Local nAntDeb		:= 0	//Saldo anterior Debito  Cl.Valor/ Item
Local nAntCrd		:= 0	//Saldo anterior Credito Cl.Valor/ Item
Local nRecnoAnt		:= 0
Local bCond			:= {||.F.}         

#IFDEF TOP                             
	Local cQuery		:= ""
	Local cOrderCTY 	:= ""
	Local cAliasCTY 	:= ""   		
#ENDIF

If cFilX == Nil
	cFilX := xFilial("CTY")
EndIf

#IFDEF TOP                             
	If TcSrvType() != "AS/400"                     		
		cOrderCTY := SqlOrder(indexKey())
		cAliasCTY := "cAliasCTY"   		

		cQuery := "SELECT CTY_DATA, CTY_ATUDEB, CTY_ATUCRD "
		cQuery += "FROM "+RetSqlName("CTY")+" CTY "
		cQuery += "WHERE CTY.CTY_FILIAL ='"+cFilX+"' AND "
		cQuery += "CTY.CTY_MOEDA ='"+cMoeda+"' AND "
		cQuery += "CTY.CTY_TPSALD ='"+cTpSald+"' AND "
		cQuery += "CTY.CTY_CLVL='"+cClVl+"' AND "
		cQuery += "CTY.CTY_ITEM='"+cItem+"' AND "			
		cQuery += "CTY.CTY_CUSTO='"+cCusto+"' AND "					
		cQuery += "CTY.D_E_L_E_T_ <> '*' AND "				
		cQuery += "CTY.CTY_DATA = (SELECT MAX(CTY_DATA) "
		cQuery += "FROM "+RetSqlName("CTY")+" CTY2 "
		cQuery += "WHERE CTY2.CTY_FILIAL ='"+cFilX+"' AND "			
		cQuery += "CTY2.CTY_MOEDA = '"+cMoeda+"' AND "	 
		cQuery += "CTY2.CTY_TPSALD = '"+cTpSald+"' AND "					
		cQuery += "CTY2.CTY_CLVL='"+cClVl+"' AND "			 
		cQuery += "CTY2.CTY_ITEM='"+cItem+"' AND "
		cQuery += "CTY2.CTY_CUSTO='"+cCusto+"' AND "		
		cQuery += "CTY2.CTY_DATA < '"+DTOS(dData)+"' AND "		 
		cQuery += "CTY2.D_E_L_E_T_ <> '*')"
		cQuery := ChangeQuery(cQuery)		   

		If ( Select ( "cAliasCTY" ) <> 0 )
			dbSelectArea ( "cAliasCTY" )
			dbCloseArea ()
		Endif

  		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCTY,.T.,.F.)
		nAntDeb 	:= (cAliasCTY)->CTY_ATUDEB
		nAntCrd 	:= (cAliasCTY)->CTY_ATUCRD			
	
		dbCloseArea()
		dbSelectArea("CTY")	                     
			
		If ( Select ( "AliasCTY" ) <> 0 )
			dbSelectArea ( "AliasCTY" )
			dbCloseArea ()
		Endif			
	Else//Se nao for TopConnect		
#ENDIF
                                               
	bCond	:= {||(xFilial()+cMoeda+cTpSald+cCusto+cItem+cClVl) == ;
					(CTY->CTY_FILIAL+CTY->CTY_MOEDA+CTY->CTY_TPSALD+;
					 CTY->CTY_CUSTO+CTY->CTY_ITEM+CTY->CTY_CLVL) .And.;
					(!Bof() .And. !Eof())}
	
	// Procura saldo anterior -> Para recalculo	
	dbSkip(-1)
	If 	Eval(bCond)
		If CTY->CTY_ATUDEB <> 0 .Or. CTY->CTY_ATUCRD <> 0
			nAntDeb 	:= CTY->CTY_ATUDEB
			nAntCrd 	:= CTY->CTY_ATUCRD
		Else
			nRecnoAnt	:= Recno()		
			While Eval(bCond) .And. CTY->CTY_ATUDEB == 0 .And. CTY->CTY_ATUCRD == 0                    
					dbSkip(-1)
			End		
			If Eval(bCond)
				nAntDeb 	:= CTY->CTY_ATUDEB
				nAntCrd 	:= CTY->CTY_ATUCRD								
			EndIf                                                        
			dbGoto(nRecnoAnt)
		EndIf						
	Else
		nAntDeb	:= 0
		nAntCrd	:= 0
	EndIf
	If (!Bof())
		dbSkip()
	EndIf
	
#IFDEF TOP
	EndIf
#ENDIF

RestArea(aSaveArea)

Return{nAntDeb,nAntCrd}    
    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³GRVSLDCTU ³ Autor ³ Simone Mie Sato       ³ Data ³ 06.11.01  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava Saldo Anterior e Saldo Atual do CTU				   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GRVSLDCTU(cIdent,cCodigo,cMoeda,cTpSald,nAntDeb,nAntCrd,	   ³±±                                                     
±±³          ³lReproc,lAtSldBase,cFilX)                               	   ³±±                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Identificador                                       ³±±
±±³          ³ ExpC2 = Codigo do Identificador                             ³±±
±±³          ³ ExpC3 = Moeda do Lancamento Contabil                        ³±±
±±³          ³ ExpC4 = Tipo do Saldo                                       ³±±
±±³          ³ ExpN1 = Valor anterior debito                         	   ³±±
±±³          ³ ExpN2 = Valor anterioro credito                       	   ³±±
±±³          ³ ExpL1 = Indica se deve atual.os saldos dos dias posteriores ³±±
±±³          ³ ExpC5 = Filial                                         	   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function GRVSLDCTU(cIdent,cCodigo,cMoeda,cTpSald,nAntDeb,nAntCrd,lReproc,cFilX)

Local aSaveArea		:= GetArea()
lReproc 	 		:= Iif(lReproc==Nil,.F.,lReproc)
cFilX				:= Iif(cFilX==Nil,xFilial("CTU"),cFilX)

If lReproc //Se for Reprocessamento, so deve atualizar o registro atual
	If !Eof() .And. CTU->CTU_FILIAL == cFilX .And. ;  	
			CTU->CTU_TPSALD == cTpSald .And. CTU->CTU_IDENT == cIdent .And. ;
			CTU->CTU_CODIGO == cCodigo .And. CTU->CTU_MOEDA == cMoeda				
			RecLock("CTU")
			CTU->CTU_ANTDEB	:= nAntDeb 
			CTU->CTU_ANTCRD	:= nAntCrd
			CTU->CTU_ATUDEB	:= nAntDeb + CTU->CTU_DEBITO
			CTU->CTU_ATUCRD	:= nAntCrd + CTU->CTU_CREDIT
			CTU->CTU_SLCOMP	:= "S"
			MsUnlock()	
	Endif
Else	
	While !Eof() .And. CTU->CTU_FILIAL == cFilX .And. ;
			CTU->CTU_TPSALD == cTpSald .And. CTU->CTU_IDENT == cIdent .And. ;
			CTU->CTU_CODIGO == cCodigo .And. CTU->CTU_MOEDA == cMoeda
			RecLock("CTU")
			CTU->CTU_ANTDEB	:= nAntDeb 
			CTU->CTU_ANTCRD	:= nAntCrd
			CTU->CTU_ATUDEB	:= nAntDeb + CTU->CTU_DEBITO
			CTU->CTU_ATUCRD	:= nAntCrd + CTU->CTU_CREDIT
			CTU->CTU_SLCOMP	:= "S"	//Flag de Atualizacao de saldo
			
			If 	CTU_ANTDEB = 0 .AND. CTU_ANTCRD = 0 .AND.;
				CTU_ATUDEB = 0 .AND. CTU_ATUCRD = 0 .AND.;
				CTU_DEBITO = 0 .AND. CTU_CREDIT = 0
				DbDelete()
			Endif
			
			MsUnlock()
			nAntDeb 	:= CTU->CTU_ATUDEB
			nAntCrd		:= CTU->CTU_ATUCRD
			dbSkip()
	EndDo
Endif

RestArea(aSaveArea)

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³GRVSLDCTV ³ Autor ³ Simone Mie Sato       ³ Data ³ 07.11.01  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava Saldo Anterior e Saldo Atual do CTV				   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GRVSLDCTV(cItem,cCusto,cMoeda,cTpSald,nAntDeb,nAntCrd,       ³±±                                                     
±±³          ³lReproc,cFilX)                                          	   ³±±                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Item                                                ³±±
±±³          ³ ExpC2 = Centro de Custo                                     ³±±
±±³          ³ ExpC3 = Moeda                                               ³±±
±±³          ³ ExpC4 = Tipo do Saldo                                       ³±±
±±³          ³ ExpN1 = Valor anterior debito                         	   ³±±
±±³          ³ ExpN2 = Valor anterioro credito                       	   ³±±
±±³          ³ ExpL1 = Indica se deve atual.os saldos dos dias posteriores ³±±
±±³          ³ ExpC5 = Filial                                         	   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function GRVSLDCTV(cItem,cCusto,cMoeda,cTpSald,nAntDeb,nAntCrd,lReproc,cFilX)

Local aSaveArea		:= GetArea()
lReproc 	 		:= Iif(lReproc==Nil,.F.,lReproc)
cFilX				:= Iif(cFilX==Nil,xFilial("CTV"),cFilX)

If lReproc //Se for Reprocessamento, so deve atualizar o registro atual
	If !Eof() .And. CTV->CTV_FILIAL == cFilX .And. ;  	
			CTV->CTV_TPSALD == cTpSald .And. CTV->CTV_ITEM == cItem .And. ;
			CTV->CTV_CUSTO == cCusto .And. CTV->CTV_MOEDA == cMoeda				
			RecLock("CTV")
			CTV->CTV_ANTDEB	:= nAntDeb 
			CTV->CTV_ANTCRD	:= nAntCrd
			CTV->CTV_ATUDEB	:= nAntDeb + CTV->CTV_DEBITO
			CTV->CTV_ATUCRD	:= nAntCrd + CTV->CTV_CREDIT
			CTV->CTV_SLCOMP	:= "S"
			MsUnlock()	
	Endif
Else	
	While !Eof() .And. CTV->CTV_FILIAL == cFilX .And. ;
			CTV->CTV_TPSALD == cTpSald .And. CTV->CTV_ITEM == cItem .And. ;
			CTV->CTV_CUSTO == cCusto .And. CTV->CTV_MOEDA == cMoeda
			RecLock("CTV")
			CTV->CTV_ANTDEB	:= nAntDeb 
			CTV->CTV_ANTCRD	:= nAntCrd
			CTV->CTV_ATUDEB	:= nAntDeb + CTV->CTV_DEBITO
			CTV->CTV_ATUCRD	:= nAntCrd + CTV->CTV_CREDIT
			CTV->CTV_SLCOMP	:= "S"	//Flag de Atualizacao de saldo

			If 	CTV_ANTDEB = 0 .AND. CTV_ANTCRD = 0 .AND.;
				CTV_ATUDEB = 0 .AND. CTV_ATUCRD = 0 .AND.;
				CTV_DEBITO = 0 .AND. CTV_CREDIT = 0
				DbDelete()
			Endif
			
			MsUnlock()
			nAntDeb 	:= CTV->CTV_ATUDEB
			nAntCrd		:= CTV->CTV_ATUCRD
			dbSkip()
	EndDo
Endif

RestArea(aSaveArea)

Return                               


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³GRVSLDCTW ³ Autor ³ Simone Mie Sato       ³ Data ³ 07.11.01  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava Saldo Anterior e Saldo Atual do CTW				   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GRVSLDCTW(cClVl,cCusto,cMoeda,cTpSald,nAntDeb,nAntCrd,       ³±±                                                     
±±³          ³lReproc,cFilX)                                          	   ³±±                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Classe de Valor                                     ³±±
±±³          ³ ExpC2 = Centro de Custo                                     ³±±
±±³          ³ ExpC3 = Moeda                                               ³±±
±±³          ³ ExpC4 = Tipo do Saldo                                       ³±±
±±³          ³ ExpN1 = Valor anterior debito                         	   ³±±
±±³          ³ ExpN2 = Valor anterioro credito                       	   ³±±
±±³          ³ ExpL1 = Indica se deve atual.os saldos dos dias posteriores ³±±
±±³          ³ ExpC5 = Filial                                         	   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function GRVSLDCTW(cClVl,cCusto,cMoeda,cTpSald,nAntDeb,nAntCrd,lReproc,cFilX)

Local aSaveArea		:= GetArea()
lReproc 	 		:= Iif(lReproc==Nil,.F.,lReproc)
cFilX				:= Iif(cFilX==Nil,xFilial("CTW"),cFilX)

If lReproc //Se for Reprocessamento, so deve atualizar o registro atual
	If !Eof() .And. CTW->CTW_FILIAL == cFilX .And. ;  	
			CTW->CTW_TPSALD == cTpSald .And. CTW->CTW_CLVL == cClVl .And. ;
			CTW->CTW_CUSTO == cCusto .And. CTW->CTW_MOEDA == cMoeda				
			RecLock("CTW")
			CTW->CTW_ANTDEB	:= nAntDeb 
			CTW->CTW_ANTCRD	:= nAntCrd
			CTW->CTW_ATUDEB	:= nAntDeb + CTW->CTW_DEBITO
			CTW->CTW_ATUCRD	:= nAntCrd + CTW->CTW_CREDIT
			CTW->CTW_SLCOMP	:= "S"
			MsUnlock()	
	Endif
Else	
	While !Eof() .And. CTW->CTW_FILIAL == cFilX .And. ;
			CTW->CTW_TPSALD == cTpSald .And. CTW->CTW_CLVL == cClVl .And. ;
			CTW->CTW_CUSTO == cCusto .And. CTW->CTW_MOEDA == cMoeda
			RecLock("CTW")
			CTW->CTW_ANTDEB	:= nAntDeb 
			CTW->CTW_ANTCRD	:= nAntCrd
			CTW->CTW_ATUDEB	:= nAntDeb + CTW->CTW_DEBITO
			CTW->CTW_ATUCRD	:= nAntCrd + CTW->CTW_CREDIT
			CTW->CTW_SLCOMP	:= "S"	//Flag de Atualizacao de saldo

			If 	CTW_ANTDEB = 0 .AND. CTW_ANTCRD = 0 .AND.;
				CTW_ATUDEB = 0 .AND. CTW_ATUCRD = 0 .AND.;
				CTW_DEBITO = 0 .AND. CTW_CREDIT = 0
				DbDelete()
			Endif
			
			MsUnlock()
			nAntDeb 	:= CTW->CTW_ATUDEB
			nAntCrd		:= CTW->CTW_ATUCRD
			dbSkip()
	EndDo
Endif

RestArea(aSaveArea)

Return                               

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³GRVSLDCTX ³ Autor ³ Simone Mie Sato       ³ Data ³ 07.11.01  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava Saldo Anterior e Saldo Atual do CTX				   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GRVSLDCTX(cClVl,cItem,cMoeda,cTpSald,nAntDeb,nAntCrd,        ³±±                                                     
±±³          ³lReproc,cFilX)                                          	   ³±±                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Classe de Valor                                     ³±±
±±³          ³ ExpC2 = Item                                                ³±±
±±³          ³ ExpC3 = Moeda                                               ³±±
±±³          ³ ExpC4 = Tipo do Saldo                                       ³±±
±±³          ³ ExpN1 = Valor anterior debito                         	   ³±±
±±³          ³ ExpN2 = Valor anterioro credito                       	   ³±±
±±³          ³ ExpL1 = Indica se deve atual.os saldos dos dias posteriores ³±±
±±³          ³ ExpC5 = Filial                                         	   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function GRVSLDCTX(cClVl,cItem,cMoeda,cTpSald,nAntDeb,nAntCrd,lReproc,cFilX)

Local aSaveArea		:= GetArea()
lReproc 	 		:= Iif(lReproc==Nil,.F.,lReproc)
cFilX				:= Iif(cFilX==Nil,xFilial("CTX"),cFilX)

If lReproc //Se for Reprocessamento, so deve atualizar o registro atual
	If !Eof() .And. CTX->CTX_FILIAL == cFilX .And. ;  	
			CTX->CTX_TPSALD == cTpSald .And. CTX->CTX_CLVL == cClVl .And. ;
			CTX->CTX_ITEM == cItem .And. CTX->CTX_MOEDA == cMoeda				
			RecLock("CTX")
			CTX->CTX_ANTDEB	:= nAntDeb 
			CTX->CTX_ANTCRD	:= nAntCrd
			CTX->CTX_ATUDEB	:= nAntDeb + CTX->CTX_DEBITO
			CTX->CTX_ATUCRD	:= nAntCrd + CTX->CTX_CREDIT
			CTX->CTX_SLCOMP	:= "S"
			MsUnlock()	
	Endif
Else	
	While !Eof() .And. CTX->CTX_FILIAL == cFilX .And. ;
			CTX->CTX_TPSALD == cTpSald .And. CTX->CTX_CLVL == cClVl .And. ;
			CTX->CTX_ITEM == cItem .And. CTX->CTX_MOEDA == cMoeda
			RecLock("CTX")
			CTX->CTX_ANTDEB	:= nAntDeb 
			CTX->CTX_ANTCRD	:= nAntCrd
			CTX->CTX_ATUDEB	:= nAntDeb + CTX->CTX_DEBITO
			CTX->CTX_ATUCRD	:= nAntCrd + CTX->CTX_CREDIT
			CTX->CTX_SLCOMP	:= "S"	//Flag de Atualizacao de saldo

			If 	CTX_ANTDEB = 0 .AND. CTX_ANTCRD = 0 .AND.;
				CTX_ATUDEB = 0 .AND. CTX_ATUCRD = 0 .AND.;
				CTX_DEBITO = 0 .AND. CTX_CREDIT = 0
				DbDelete()
			Endif
			
			MsUnlock()
			nAntDeb 	:= CTX->CTX_ATUDEB
			nAntCrd		:= CTX->CTX_ATUCRD
			dbSkip()
	EndDo
Endif

RestArea(aSaveArea)

Return                 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³GRVSLDCTY ³ Autor ³ Simone Mie Sato       ³ Data ³ 08.05.02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava Saldo Anterior e Saldo Atual do CTY				   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GRVSLDCTY(cClVl,cItem,cCusto,cMoeda,cTpSald,nAntDeb,nAntCrd, ³±±                                                     
±±³          ³lReproc,cFilX)                                          	   ³±±                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cClVl 	= Classe de Valor                                  ³±±
±±³          ³ cItem 	= Item                                             ³±±
±±³          ³ cCusto	= c.Custo              		                       ³±±
±±³          ³ cMoeda	= Moeda                     	                   ³±±
±±³          ³ cTpsald 	= Tipo do Saldo                   		       	   ³±±
±±³          ³ nAntDeb	= Valor anterior debito							   ³±±
±±³          ³ nAntCrd	= Valor anterior credito                       	   ³±±
±±³          ³ lReproc  = Indica se deve atual.saldos dos dias posteriores ³±±
±±³          ³ cFilX	= Filial                                      	   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function GRVSLDCTY(cClVl,cItem,cCusto,cMoeda,cTpSald,nAntDeb,nAntCrd,lReproc,cFilX)

Local aSaveArea		:= GetArea()
lReproc 	 		:= Iif(lReproc==Nil,.F.,lReproc)
cFilX				:= Iif(cFilX==Nil,xFilial("CTY"),cFilX)

If lReproc //Se for Reprocessamento, so deve atualizar o registro atual
	If !Eof() .And. CTY->CTY_FILIAL == cFilX .And. ;  	
			CTY->CTY_TPSALD == cTpSald .And. CTY->CTY_CLVL == cClVl .And. ;
			CTY->CTY_ITEM == cItem .And. CTY->CTY_CUSTO == cCusto .And. ;
			CTY->CTY_MOEDA == cMoeda				
			RecLock("CTY")
			CTY->CTY_ANTDEB	:= nAntDeb 
			CTY->CTY_ANTCRD	:= nAntCrd
			CTY->CTY_ATUDEB	:= nAntDeb + CTY->CTY_DEBITO
			CTY->CTY_ATUCRD	:= nAntCrd + CTY->CTY_CREDIT
			CTY->CTY_SLCOMP	:= "S"
			MsUnlock()	
	Endif
Else	
	While !Eof() .And. CTY->CTY_FILIAL == cFilX .And. ;
			CTY->CTY_TPSALD == cTpSald .And. CTY->CTY_CUSTO == cCusto .And. ;
			CTY->CTY_ITEM == cItem .And. CTY->CTY_CLVL == cClVl .And. ;
			CTY->CTY_MOEDA == cMoeda
			RecLock("CTY")
			CTY->CTY_ANTDEB	:= nAntDeb 
			CTY->CTY_ANTCRD	:= nAntCrd
			CTY->CTY_ATUDEB	:= nAntDeb + CTY->CTY_DEBITO
			CTY->CTY_ATUCRD	:= nAntCrd + CTY->CTY_CREDIT
			CTY->CTY_SLCOMP	:= "S"	//Flag de Atualizacao de saldo
			MsUnlock()
			nAntDeb 	:= CTY->CTY_ATUDEB
			nAntCrd		:= CTY->CTY_ATUCRD
			dbSkip()
	EndDo
Endif

RestArea(aSaveArea)

Return                               
              

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³FlgSldComp³ Autor ³ Simone Mie Sato       ³ Data ³ 07.11.01  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Atualiza flags das tabelas de saldos compostos.			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³FlgSldComp(cEntid,cChave)								       ³±±                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Entidade                                            ³±±
±±³          ³ ExpC2 = Chave                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function FlgSldComp(cEntid,cChave)

Local aSaveArea	:= GetArea()

dbSelectArea(cEntid)
dbSetOrder(1)
If MsSeek(xFilial()+cChave,.F.)
	Reclock(cEntid,.F.)
		&(cEntid+"->"+cEntid+"_SLCOMP")		:= "N"				
	MsUnlock()
EndIf

RestArea(aSaveArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³AtuFlgCT2 ³ Autor ³ Simone Mie Sato       ³ Data ³ 07.11.01  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Atualiza flags do CT2,da data para frente.     			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³AtuFlgCT2(cFilX,dData,cConta,cCusto,cItem,cClvl,cTpSald)     ³±±                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Identifica se esta atualizando saldo basico.        ³±±
±±³          ³ ExpD1 = Data                                                ³±±
±±³          ³ ExpC2 = Conta                                               ³±±
±±³          ³ ExpC3 = C.Custo                                             ³±±
±±³          ³ ExpC4 = Item                                                ³±±
±±³          ³ ExpC5 = Cl.Valor                                            ³±±
±±³          ³ ExpC6 = Tipo de Saldo                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function AtuFlgCT2(cFilX,dData,cConta,cCusto,cItem,cClVl,cTpSald)

Local aSaveArea		:= GetArea()
Local cQuery		:= ""              
Local cIndice		:= ""         
Local cArqTrb		:= ""    
Local nIndex		:= 0

#IFDEF TOP
	Local cChave		:= ""
	Local cRegs			:= ""
	Local nCountReg		:= 0	
	Local nMin			:= 0
	Local nMax			:= 0	
	Local nRecCt2		:= CT2->(Recno())	
#ENDIF

cConta := FormatIn(cConta, "/")
cCusto := FormatIn(cCusto, "/")
cItem  := FormatIn(cItem, "/")
cClVl  := FormatIn(cClVl, "/")

#IFDEF TOP
	If TcSrvType() != "AS/400"		
		
		cRegs 	:= "cRegs"		
		cQuery	:= "SELECT R_E_C_N_O_ RECNO "
		cQuery  += " FROM "+RetSqlName("CT2")+" CT2 "
		cQuery  += "WHERE CT2.CT2_FILIAL = '"+cFilX+"' AND "
		cQuery  += "(CT2.CT2_DC = '1' OR CT2.CT2_DC = '2' OR CT2.CT2_DC = '3') AND "
		cQuery 	+= " CT2.CT2_DATA >= '"+ DTOS(dData)+ "' AND "
		cQuery	+= " CT2.CT2_TPSALD ='"+cTpSald+"' AND "
		cQuery	+= "("		// Abro parenteses para checagem das entidades
		If ! Empty(cConta)
			cQuery	+= "(CT2.CT2_DEBITO IN " + cConta+" OR CT2.CT2_CREDIT IN "+cConta+") "
		Endif
		If ! Empty(cCusto)					// Incluo OR caso anterior ja nao for OR
			cQuery 	+= If(Right(cQuery, 4) # " OR ", " OR ", "")	// Sempre Espaco + "OR" + Espaco
			cQuery	+= "(CT2.CT2_CCD IN "+cCusto+" OR CT2.CT2_CCC IN "+cCusto+") "
		Endif
		If ! Empty(cItem)					// Incluo OR caso anterior ja nao for OR
			cQuery 	+= If(Right(cQuery, 4) # " OR ", " OR ", "")
			cQuery	+= "(CT2.CT2_ITEMD IN "+cItem+" OR CT2.CT2_ITEMC IN "+cItem+") "
		Endif
		If ! Empty(cClVl)					// Incluo OR caso anterior ja nao for OR
			cQuery 	+= If(Right(cQuery, 4) # " OR ", " OR ", "")
			cQuery	+= "(CT2.CT2_CLVLDB IN "+cClVl+" OR CT2.CT2_CLVLCR IN "+cClVl+")"
		Endif
		cQuery	+= ")"		// Fecho parenteses para checagem das entidades
		cQuery	+= "AND D_E_L_E_T_<>'*'"    
		cQuery	+= " ORDER BY RECNO "
		cQuery	:= ChangeQuery(cQuery)   

		If ( Select ( "cRegs" ) <> 0 )
			dbSelectArea ( "cRegs" )
			dbCloseArea ()
		Endif
			
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cRegs,.T.,.F.)
		
		dbSelectArea("CT2")

		cQuery 	:= "UPDATE "
		cQuery 	+= RetSqlName("CT2")+" "	
		cQuery 	+= "SET "
		cQuery 	+= " CT2_SLBASE = 'N' "
		cQuery  += "WHERE CT2_FILIAL = '"+cFilX+"' AND "
		cQuery  += "(CT2_DC = '1' OR CT2_DC = '2' OR CT2_DC = '3') AND "
		cQuery 	+= " CT2_DATA >= '"+ DTOS(dData)+ "' AND "		
		cQuery	+= "CT2_TPSALD='"+cTpSald+"' AND "
		cQuery	+= "("		// Abro parenteses para checagem das entidades
		If ! Empty(cConta)
			cQuery	+= "(CT2_DEBITO IN " + cConta+" OR CT2_CREDIT IN "+cConta+") "
		Endif
		If ! Empty(cCusto)					// Incluo OR caso anterior ja nao for OR
			cQuery 	+= If(Right(cQuery, 4) # " OR ", " OR ", "")	// Sempre Espaco + "OR" + Espaco
			cQuery	+= "(CT2_CCD IN "+cCusto+" OR CT2_CCC IN "+cCusto+") "
		Endif
		If ! Empty(cItem)					// Incluo OR caso anterior ja nao for OR
			cQuery 	+= If(Right(cQuery, 4) # " OR ", " OR ", "")
			cQuery	+= "(CT2_ITEMD IN "+cItem+" OR CT2_ITEMC IN "+cItem+") "
		Endif
		If ! Empty(cClVl)					// Incluo OR caso anterior ja nao for OR
			cQuery 	+= If(Right(cQuery, 4) # " OR ", " OR ", "")
			cQuery	+= "(CT2_CLVLDB IN "+cClVl+" OR CT2_CLVLCR IN "+cClVl+")"
		Endif
		cQuery	+= ")"		// Fecho parenteses para checagem das entidades
		cQuery	+= "AND D_E_L_E_T_<>'*' AND "

		While cRegs->(!EOF())
	
			nMin := (cRegs)->RECNO
			
			nCountReg := 0
				
			While cRegs->(!EOF()) .and. nCountReg <= 4096
				
				nMax := (cRegs)->RECNO
				nCountReg++
				cRegs->(DbSkip())

			End
				
			cChave := "R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
			
			TcSqlExec(cQuery+cChave)
			
		End		

		dbSelectArea("CT2")
		dbCommit()		// Faco comitt para enxergar o UPDATE executado
		
		CT2->(DbGoto(nRecCt2))
		
	Else	//Se for AS/400
#ENDIF	//Se nao for TopConnect

	//Criar indice temporario para atualizar os flags.	 	                                     
	cIndice 	:= "CT2_FILIAL+CT2_TPSALD+DTOS(CT2_DATA)"
	cQuery 	:= " CT2_FILIAL == cFilX .And. CT2_DC $'1/2/3' .And. 	CT2_DATA >= dData .And. "
	cQuery 	+= " CT2_TPSALD == cTpSald .And. "
	cQuery  	+= "("		// Abro parenteses para checagem das entidades
	If ! Empty(cConta)
		cQuery += "(CT2_DEBITO $ '" + cConta + "' .Or. CT2_CREDIT $ '" + cConta + "')"
	Endif
	If ! Empty(cCusto)					// Incluo .Or caso anterior ja nao for .Or.
		cQuery += If(Right(cQuery, 4) # ".Or.", ".Or.", "")	// Sempre ".Or."
		cQuery += "(CT2_CCD $ '" + cCusto + "' .Or. CT2_CCC $ '" + cCusto + "')" 
	Endif
	If ! Empty(cItem)					// Incluo .Or. caso anterior ja nao for .Or.
		cQuery += If(Right(cQuery, 4) # ".Or.", ".Or.", "")	// Sempre ".Or."
		cQuery +=	"(CT2_ITEMD $ '" + cItem + "' .Or. CT2_ITEMC $ '" + cItem + "')"
	Endif
	If ! Empty(cClVl)					// Incluo .Or. caso anterior ja nao for .Or.
		cQuery += If(Right(cQuery, 4) # ".Or.", ".Or.", "")	// Sempre ".Or."
		cQuery += "(CT2_CLVLDB $ '" + cClVl + "' .Or. CT2_CLVLCR $ '" + cClVl + "')"
	Endif
	cQuery += ")"		// Fecho parenteses para checagem das entidades

	cArqTrb := CriaTrab(NIL,.F.)
	IndRegua("CT2",cArqTrb,cIndice,cQuery,,OemToAnsi(STR0001)) //"Selecionando Registros..."
	nIndex:=RetIndex("CT2")	
	
	dbSelectArea("CT2")
	dbSetIndex(cArqTrb+OrdBagExt())	
	dbSetOrder(nIndex+1)	     	
	MsSeek(xFilial()+cTpSald+Dtos(dData),.T.)		

	dbSelectArea("CT2")
	While !Eof()	 
	   Reclock("CT2",.F.)
		CT2->CT2_SLBASE := "N"	   	
	  	MsunLock()
		dbSkip()
	End
	
	//Apaga indice temporario
  	Ferase(cArqTrb + OrdBagExt()) 	


#IFDEF TOP
	Endif	
#ENDIF

RestArea(aSaveArea)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³AtuFlgCMP ³ Autor ³ Simone Mie Sato       ³ Data ³ 07.11.01  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Atualiza flags ref. saldos compostos.           			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³AtuFlgCMP(cFilX,dData,cConta,cCusto,cItem,cClvl,cTpSald)     ³±±                                                     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data                                                ³±±
±±³          ³ ExpC1 = Identificador                                       ³±±
±±³          ³ ExpC2 = Codigo                                              ³±±
±±³          ³ ExpC3 = Moeda                                               ³±±
±±³          ³ ExpC4 = Tipo de Saldo                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function AtuFlgCmp(dData,cIdent,cCodigo,cMoeda,cTpsald)

Local aSaveArea		:= GetArea()
Local nArqs			:= 0
Local cAlias		:= ""
Local nOrder		:= 0
Local cChave		:= ""
Local bCond			:= {||.F.}
Local aArqs			:= {{"","",""},{"","",""},{"","",""},{"","",""},{"","",""}}	
#IFDEF TOP 
	Local cCond			:= ""
	Local cQuery		:= ""              	
	Local cRegs			:= ""
	Local nCountReg		:= 0	
	Local nMin			:= ""
	Local nMax			:= ""
#ENDIF
Do Case
Case cIdent == 'CTT' 
	aArqs[1][1] := "CT3"
	aArqs[1][2] := "3"
	aArqs[1][3] := (DTOS(dData)+cCodigo+cMoeda+cTpSald)
	aArqs[2][1] := "CTU"
	aArqs[2][2] := "3"
	aArqs[2][3] := ("CTT"+cTpSald+cMoeda+DTOS(dData)+cCodigo)
	aArqs[3][1] := "CTV"
	aArqs[3][2] := "4"
	aArqs[3][3] := ("S"+cTpSald+cMoeda+DTOS(dData)+cCodigo)
	aArqs[4][1] := "CTW"
	aArqs[4][2] := "4"
	aArqs[4][3] := ("S"+cTpSald+cMoeda+DTOS(dData)+cCodigo)                    
	aArqs[5][1] := "CTY"
	aArqs[5][2] := "4"
	aArqs[5][3] := ("S"+cTpSald+cMoeda+DTOS(dData)+cCodigo)		
Case cIdent == 'CTD'
	aArqs[1][1] := "CT4"
	aArqs[1][2] := "3"
	aArqs[1][3] := (DTOS(dData)+cCodigo+cMoeda+cTpSald)
	aArqs[2][1] := "CTU"
	aArqs[2][2] := "3"
	aArqs[2][3] := ("CTD"+cTpSald+cMoeda+DTOS(dData)+cCodigo)
	aArqs[3][1] := "CTV"
	aArqs[3][2] := "3"
	aArqs[3][3] := ("S"+cTpSald+cMoeda+DTOS(dData)+cCodigo)
	aArqs[4][1] := "CTX"
	aArqs[4][2] := "3"
	aArqs[4][3] := ("S"+cTpSald+cMoeda+DTOS(dData)+cCodigo)   
	aArqs[5][1] := "CTY"
	aArqs[5][2] := "3"
	aArqs[5][3] := ("S"+cTpSald+cMoeda+DTOS(dData)+cCodigo)		
Case cIdent == 'CTH'                                          
	aArqs[1][1] := "CTI"
	aArqs[1][2] := "3"
	aArqs[1][3] := (DTOS(dData)+cCodigo+cMoeda+cTpSald)
	aArqs[2][1] := "CTU"
	aArqs[2][2] := "3"
	aArqs[2][3] := ("CTH"+cTpSald+cMoeda+DTOS(dData)+cCodigo)
	aArqs[3][1] := "CTW"
	aArqs[3][2] := "3"
	aArqs[3][3] := ("S"+cTpSald+cMoeda+DTOS(dData)+cCodigo)
	aArqs[4][1] := "CTX"
	aArqs[4][2] := "4"
	aArqs[4][3] := ("S"+cTpSald+cMoeda+DTOS(dData)+cCodigo)   
	aArqs[5][1] := "CTY"
	aArqs[5][2] := "2"
	aArqs[5][3] := ("S"+cTpSald+cMoeda+DTOS(dData)+cCodigo)	
EndCase

#IFDEF TOP

	If TcSrvType() != "AS/400"		
	   
		For nArqs	:= 1 to Len(aArqs)
		
			cAlias		:=	aArqs[nArqs][1]   
			cCond		:=	cAlias+"_FILIAL = '"+xFilial()+"' AND "
			cCond		+=	cAlias+"_DATA >= '"+DTOS(dData)+"' AND "			
			cCond		+=	cAlias+"_TPSALD = '"+cTpSald+"' AND "
			cCond		+=	cAlias+"_MOEDA = '"+cMoeda+"' AND "							
		
			Do Case
			Case cIdent	== "CTT"
				If cAlias $ "CT3/CTV/CTY" 
					cCond	+=	cAlias+"_CUSTO = '"+cCodigo+"' AND "				
				ElseIf cAlias == "CTU"
					cCond	+=	cAlias+"_CODIGO = '"+cCodigo+"' AND "
					cCond	+=	cAlias+"_IDENT = 'CTT' AND "				
				EndIf
			Case cIdent	== "CTD"			
				If cAlias	$ "CT4/CTV/CTX/CTY"
					cCond	+=	cAlias+"_ITEM = '"+cCodigo+"' AND "						
				ElseIf cAlias == "CTU"
					cCond	+=	cAlias+"_CODIGO = '"+cCodigo+"' AND "
					cCond	+=	cAlias+"_IDENT = 'CTD' AND "				
				EndIf				
			Case cIdent	== "CTH"                        
				If 	cAlias $ "CTI/CTW/CTX/CTY"
					cCond	+=	cAlias+"_CLVL = '"+cCodigo+"' AND "										
				ElseIf cAlias == "CTU"
					cCond	+=	cAlias+"_CODIGO = '"+cCodigo+"' AND "
					cCond	+=	cAlias+"_IDENT = 'CTH' AND "											
				Endif
			EndCase

			cRegs 		:= "cRegs"				                       		
			cQuery		:= "SELECT R_E_C_N_O_ RECNO "
			cQuery 		+= " FROM "+ RetSqlName(cAlias) + " "
			cQuery 		+= " WHERE "
			cQuery		+= cCond		
			cQuery		+= " D_E_L_E_T_ <> '*'"
			cQuery		+= " ORDER BY RECNO "
			cQuery		:= ChangeQuery(cQuery)   		
			
			If ( Select ( "cRegs" ) <> 0 )
				dbSelectArea( "cRegs" )
				dbCloseArea()
			Endif
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cRegs,.T.,.F.)
			
			dbSelectArea(cAlias)
		
			cQuery 	:= "UPDATE "
			cQuery 	+= RetSqlName(cAlias)
			cQuery 	+= " SET "
			cQuery 	+= cAlias + "_SLCOMP = 'N' "
			cQuery  += "WHERE "
			cQuery	+= cCond
			cQuery	+= "D_E_L_E_T_<>'*' AND "         

			While cRegs->(!Eof())
	
				nMin := (cRegs)->RECNO
			
				nCountReg := 0
				
				While cRegs->(!Eof()) .and. nCountReg <= 4096
				
					nMax := (cRegs)->RECNO
					nCountReg++
					cRegs->(DbSkip())
        	
				End
				
				cChave := "R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""
				TcSqlExec(cQuery+cChave)

			End			
    	Next
	Else	
#ENDIF	
	For nArqs := 1 to len(aArqs)
		cAlias		:=	aArqs[nArqs][1]   	
		nOrder		:=	Val(aArqs[nArqs][2])                   
		cChave		:= aArqs[nArqs][3]
		
		Do Case
		Case cIdent	== "CTT"
			If cAlias $ "CT3/CTV/CTY" 
				bCond		:= {||(&(cAlias+"->"+cAlias+"_CUSTO") == cCodigo )}
			ElseIf cAlias == "CTU"	
				bCond		:= {||(CTU->CTU_CODIGO == cCodigo .And. CTU->CTU_IDENT == 'CTT')}
			EndIf
		Case cIdent	== "CTD"			
			If cAlias	$ "CT4/CTV/CTX/CTY"
				bCond	:= {||(&(cAlias+"->"+cAlias+"_ITEM") == cCodigo )}
			ElseIf cAlias == "CTU"
				bCond	:= {||(CTU->CTU_CODIGO == cCodigo .And. CTU->CTU_IDENT == 'CTD')}
			EndIf				
		Case cIdent	== "CTH"                        
			If 	cAlias $ "CTI/CTW/CTX/CTY"
				bCond	:= {||(&(cAlias+"->"+cAlias+"_CLVL") == cCodigo )}
			ElseIf cAlias == "CTU"
				bCond	:=	 {||(CTU->CTU_CODIGO == cCodigo .And. CTU->CTU_IDENT == 'CTH')}
			Endif
		EndCase
		
		dbSelectArea(cAlias)
		dbSetOrder(nOrder)
		MsSeek(xFilial()+cChave)
		While !Eof() .And.  &(cAlias+"->"+cAlias+"_FILIAL")== xFilial() .And. ;
			&(cAlias+"->"+cAlias+"_DATA") >= dData .And. ;
			&(cAlias+"->"+cAlias+"_MOEDA") == cMoeda .And. ;
			&(cAlias+"->"+cAlias+"_TPSALD") == cTpSald .And. Eval(bCond)
			Reclock(cAlias,.F.)
			&(cAlias+"->"+cAlias+"_SLCOMP") := "N"
		    MsUnlock()
			dbSkip()
		End
    Next
#IfDef TOP
	Endif	
#ENDIF

RestArea(aSaveArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtGerPlan ³ Autor ³ Simone Mie Sato       ³ Data ³ 25.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Balancetes.                   |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oMeter                                      ³±±
±±³          ³ ExpO2 = Objeto oText                                       ³±±
±±³          ³ ExpO3 = Objeto oDlg                                        ³±±
±±³          ³ ExpL1 = lEnd                                               ³±±
±±³          ³ ExpD1 = Data Inicial                                       ³±±
±±³          ³ ExpD2 = Data Final                                         ³±±
±±³          ³ ExpC1 = Alias do Arquivo                                   ³±±
±±³          ³ ExpC2 = Conta Inicial                                      ³±±
±±³          ³ ExpC3 = Conta Final                                        ³±±
±±³          ³ ExpC4 = Centro de Custo Inicial                            ³±±
±±³          ³ ExpC5 = Centro de Custo Final                              ³±±
±±³          ³ ExpC6 = Centro de Custo Inicial                            ³±±
±±³          ³ ExpC7 = Centro de Custo Final                              ³±±
±±³          ³ ExpC8 = Item Inicial                                       ³±±
±±³          ³ ExpC9 = Item Final                                         ³±±
±±³          ³ ExpC10= Classe de Valor Inicial                            ³±±
±±³          ³ ExpC11= Classe de Valor Final                              ³±±
±±³          ³ ExpC12= Moeda		                                      ³±±
±±³          ³ ExpC13= Saldo	                                          ³±±
±±³          ³ ExpA1 = Set Of Book	                                      ³±±
±±³          ³ ExpC13= Ate qual segmento sera impresso (nivel)			  ³±±
±±³          ³ ExpC8 = Filtra por Segmento		                          ³±±
±±³          ³ ExpC9 = Segmento Inicial		                              ³±±
±±³          ³ ExpC10= Segmento Final  		                              ³±±
±±³          ³ ExpC11= Segmento Contido em  	                          ³±±
±±³          ³ ExpL2 = Se Imprime Entidade sem movimento                  ³±±
±±³          ³ ExpL3 = Se Imprime Conta                                   ³±±
±±³          ³ ExpN1 = Grupo                                              ³±±
±±³          ³ cSegmentoG = Filtra por Segmento	(CC/Item ou ClVl)         ³±±
±±³          ³ cSegIniG = Segmento Inicial		                          ³±±
±±³          ³ cSegFimG = Segmento Final  		                          ³±±
±±³          ³ cFiltSegmG = Segmento Contido em  	                      ³±±
±±³          ³ aGeren = Matriz que armazena os compositores do Pl. Ger.   ³±±
±±³          ³ 			para efetuar o filtro de relatorio.               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTGerPlan(oMeter,oText,oDlg,lEnd,cArqtmp,dDataIni,dDataFim,cAlias,cIdent,cContaIni,;
						cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,;
						cClVlFim,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,;
						cSegFim,cFiltSegm,lNImpMov,lImpConta,nGrupo,cHeader,lImpAntLP,dDataLP,;
						nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt,;
						cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,lUsGaap,cMoedConv,;
						cConsCrit,dDataConv,nTaxaConv,aGeren,lImpMov,lImpSint,cFilUSU,lRecDesp0,;
						cRecDesp,dDtZeraRD,lImp3Ent,lImp4Ent)
						
Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamCtaRes	:= TAMSX3("CT1_RES")
Local aTamCC        := TAMSX3("CTT_CUSTO")
Local aTamCCRes 	:= TAMSX3("CTT_RES")
Local aTamItem  	:= TAMSX3("CTD_ITEM")
Local aTamItRes 	:= TAMSX3("CTD_RES")    
Local aTamClVl  	:= TAMSX3("CTH_CLVL")
Local aTamCvRes 	:= TAMSX3("CTH_RES")
Local aCtbMoeda		:= {}
Local aSaveArea 	:= GetArea()
Local aCampos
Local cChave
Local nTamCta 		:= Len(CriaVar("CT1->CT1_DESC"+cMoeda))
Local nTamItem		:= Len(CriaVar("CTD->CTD_DESC"+cMoeda))
Local nTamCC  		:= Len(CriaVar("CTT->CTT_DESC"+cMoeda))
Local nTamClVl		:= Len(CriaVar("CTH->CTH_DESC"+cMoeda))
Local nTamGrupo		:= Len(CriaVar("CT1->CT1_GRUPO"))
Local nDecimais		:= 0
Local cCodigo		:= ""
Local cCodGer		:= ""
Local cEntidIni		:= ""
Local cEntidFim		:= ""           
Local cEntidIni1	:= ""
Local cEntidFim1	:= ""
Local cEntidIni2	:= ""
Local cEntidFim2	:= ""
Local cArqTmp1		:= ""
Local cMascaraG 	:= ""
Local lCusto		:= CtbMovSaldo("CTT")//Define se utiliza C.Custo
Local lItem 		:= CtbMovSaldo("CTD")//Define se utiliza Item
Local lClVl			:= CtbMovSaldo("CTH")//Define se utiliza Cl.Valor 
Local lAtSldBase	:= Iif(GetMV("MV_ATUSAL")== "S",.T.,.F.) 
Local lAtSldCmp		:= Iif(GetMV("MV_SLDCOMP")== "S",.T.,.F.)
Local nInicio		:= Val(cMoeda)
Local nFinal		:= Val(cMoeda)
Local nCampoLP		:= 0
Local cFilDe		:= xFilial(cAlias)
Local cFilAte		:= xFilial(cAlias), nOrdem := 1
Local cCodMasc		:= ""
Local cMensagem		:= OemToAnsi(STR0002)// O plano gerencial ainda nao esta disponivel nesse relatorio. 
Local nPos			:= 0

#IFDEF TOP
	Local aStruTmp		:= {}
	Local lTemQry		:= .F.
	Local nTrb			:= 0	                              
#ENDIF
Local nDigitos		:= 0
Local nMeter		:= 0
Local nPosG			:= 0
Local nDigitosG		:= 0 
DEFAULT cSegmentoG 	:= ""
DEFAULT lUsGaap		:=.F.
DEFAULT cMoedConv	:= ""
DEFAULT	cConsCrit	:= ""
DEFAULT dDataConv	:= CTOD("  /  /  ")
DEFAULT nTaxaConv	:= 0
DEFAULT lImpSint	:= .T.                                              
DEFAULT lImpMov		:= .T.
DEFAULT cSegmento	:= ""
DEFAULT cFilUsu		:= ".T."
DEFAULT lRecDesp0	:= .F.
DEFAULT cRecDesp 	:= ""                
DEFAULT dDtZeraRD	:= CTOD("  /  /  ")
DEFAULT lImp3Ent	:= .F.
DEFAULT lImp4Ent	:= .F.

cIdent		:=	Iif(cIdent == Nil,'',cIdent)
nGrupo		:=	Iif(nGrupo == Nil,2,nGrupo)                                                 
cHeader		:= Iif(cHeader == Nil,'',cHeader)
cFiltroEnt	:= Iif(cFiltroEnt == Nil,"",cFiltroEnt)
cCodFilEnt	:= Iif(cCodFilEnt == Nil,"",cCodFilEnt)
Private nMin			:= 0
Private nMax			:= 0 

// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := aCtbMoeda[5]
dMinData := CTOD("")

If cAlias == 'CTY'	//Se for Balancete de 2 Entidades filtrando pela 3a Entidade.
	aCampos := {{ "ENTID1"		, "C", aTamConta[1], 0 },;  			// Codigo da Conta
				 { "ENTRES1"	, "C", aTamCtaRes[1],0 },;  			// Codigo Reduzido da Conta
				 { "DESCENT1"	, "C", nTamCta		, 0 },;  			// Descricao da Conta
	 			 { "TIPOENT1"  	, "C", 01			, 0 },;				// Centro de Custo Analitico / Sintetico				 
 				 { "ENTSUP1"	, "C", aTamCC[1]	, 0 },;				// Codigo do Centro de Custo Superior
	   	         { "ENTID2"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
				 { "ENTRES2"	, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
				 { "DESCENT2"	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
				 { "TIPOENT2"	, "C", 01			, 0 },;				// Item Analitica / Sintetica			 
				 { "ENTSUP2"	, "C", aTamItem[1]	, 0 },; 			// Codigo do Item Superior
		 		 { "NORMAL"		, "C", 01			, 0 },;				// Situacao
				 { "SALDOANT"	, "N", 17			, nDecimais},; 		// Saldo Anterior
	 		 	 { "SALDOANTDB"	, "N", 17			, nDecimais},; 		// Saldo Anterior Debito
			 	 { "SALDOANTCR"	, "N", 17			, nDecimais},; 		// Saldo Anterior Credito
			 	 { "SALDODEB"	, "N", 17			, nDecimais },;  	// Debito
				 { "SALDOCRD"	, "N", 17			, nDecimais },;  	// Credito
				 { "SALDOATU"	, "N", 17			, nDecimais },;  	// Saldo Atual               
				 { "SALDOATUDB"	, "N", 17			, nDecimais },;  	// Saldo Atual Debito
			     { "SALDOATUCR"	, "N", 17			, nDecimais },;  	// Saldo Atual Credito
				 { "MOVIMENTO"	, "N", 17			, nDecimais },;  	// Movimento do Periodo
				 { "ORDEM"		, "C", 10			, 0 },;				// Ordem
				 { "GRUPO"		, "C", nTamGrupo	, 0 },;				// Grupo Contabil
		    	 { "IDENTIFI"	, "C", 01			, 0 },;			 
			  	 { "NIVEL1"		, "L", 01			, 0 }}				// Logico para identificar se 
														 				// eh de nivel 1 -> usado como
																		// totalizador do relatorio
Else
	aCampos := { { "CONTA"		, "C", aTamConta[1], 0 },;  			// Codigo da Conta
				 { "SUPERIOR"	, "C", aTamConta[1], 0 },;				// Conta Superior
		 		 { "NORMAL"		, "C", 01			, 0 },;				// Situacao
				 { "CTARES"		, "C", aTamCtaRes[1], 0 },;  			// Codigo Reduzido da Conta
				 { "DESCCTA"	, "C", nTamCta		, 0 },;  			// Descricao da Conta
				 { "CUSTO"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
				 { "CCRES"		, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
				 { "DESCCC" 	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
		         { "ITEM"		, "C", aTamItem[1]	, 0 },; 	 		// Codigo do Item          
				 { "ITEMRES" 	, "C", aTamItRes[1], 0 },;  			// Codigo Reduzido do Item
				 { "DESCITEM" 	, "C", nTamItem		, 0 },;  			// Descricao do Item
	             { "CLVL"		, "C", aTamClVl[1]	, 0 },; 	 		// Codigo da Classe de Valor
    	         { "CLVLRES"	, "C", aTamCVRes[1], 0 },; 		 	// Cod. Red. Classe de Valor
				 { "DESCCLVL"   , "C", nTamClVl		, 0 },;  			// Descricao da Classe de Valor
				 { "SALDOANT"	, "N", 17			, nDecimais},; 		// Saldo Anterior
	   		 	 { "SALDOANTDB"	, "N", 17			, nDecimais},; 		// Saldo Anterior Debito
 				 { "SALDOANTCR"	, "N", 17			, nDecimais},; 		// Saldo Anterior Credito
				 { "SALDODEB"	, "N", 17			, nDecimais },;  	// Debito
				 { "SALDOCRD"	, "N", 17			, nDecimais },;  	// Credito
				 { "SALDOATU"	, "N", 17			, nDecimais },;  	// Saldo Atual               
				 { "SALDOATUDB"	, "N", 17			, nDecimais },;  	// Saldo Atual Debito
				 { "SALDOATUCR"	, "N", 17			, nDecimais },;  	// Saldo Atual Credito
				 { "MOVIMENTO"	, "N", 17			, nDecimais },;  	// Movimento do Periodo
				 { "TIPOCONTA"	, "C", 01			, 0 },;				// Conta Analitica / Sintetica           
 				 { "TIPOCC"  	, "C", 01			, 0 },;				// Centro de Custo Analitico / Sintetico
	 			 { "TIPOITEM"	, "C", 01			, 0 },;				// Item Analitica / Sintetica			 
 				 { "TIPOCLVL"	, "C", 01			, 0 },;				// Classe de Valor Analitica / Sintetica			 
	 			 { "CCSUP"		, "C", aTamCC[1]	, 0 },;				// Codigo do Centro de Custo Superior
				 { "ITSUP"		, "C", aTamItem[1]	, 0 },;				// Codigo do Item Superior
	 			 { "CLSUP"	    , "C", aTamClVl[1] , 0 },;				// Codigo da Classe de Valor Superior
				 { "ORDEM"		, "C", 10			, 0 },;				// Ordem
				 { "GRUPO"		, "C", nTamGrupo	, 0 },;				// Grupo Contabil
			     { "IDENTIFI"	, "C", 01			, 0 },;			 
   			     { "ESTOUR" 	, "C", 01			, 0 },;			 	//Define se a conta esta estourada ou nao
				 { "NIVEL1"		, "L", 01			, 0 }}				// Logico para identificar se 
																		// eh de nivel 1 -> usado como
																		// totalizador do relatorio]

// Usado no mutacoes de patrimonio liquido inclui campo que alem da descricao da entidade
// Que esta no DESCCTA tem tambem a descricao da conta inicial CTS_CT1INI
																			
	If 	Type("lTRegCts") # "U" .And. ValType(lTRegCts) = "L" .And. lTRegCts
		Aadd(aCampos, { "DESCORIG"	, "C", nTamCta		, 0 } )	// Descricao da Origem do Valor
	Endif
EndIf

If CTS->(FieldPos("CTS_COLUNA")) > 0
	Aadd(aCampos, { "COLUNA"   	, "N", 01			, 0 })
Endif
If 	Type("dSemestre") # "U" .And. ValType(dSemestre) = "D"
	Aadd(aCampos, { "SALDOSEM"	, "N", 17		, nDecimais }) 	// Saldo semestre
Endif

If Type("dPeriodo0") # "U" .And. ValType(dPeriodo0) = "D"
	Aadd(aCampos, { "SALDOPER"	, "N", 17		, nDecimais }) 	// Saldo Periodo determinado
	Aadd(aCampos, { "MOVIMPER"	, "N", 17		, nDecimais }) 	// Saldo Periodo determinado
Endif

If Type("lComNivel") # "U" .And. ValType(lComNivel) = "L"
	Aadd(aCampos, { "NIVEL"   	, "N", 01			, 0 })		// Nivel hieraquirco - Quanto maior mais analitico
Endif	

If cAlias = "CT7" .And. SuperGetMv("MV_CTASUP") = "S"
	Aadd(aCampos, { "ORDEMPRN" 	, "N", 06			, 0 })		// Ordem para impressao
Endif

///// TRATAMENTO PARA ATUALIZAÇÃO DE SALDO BASE
//Se os saldos basicos nao foram atualizados na dig. lancamentos
If !lAtSldBase
  	#IFDEF TOP
		If TcSrvType() != "AS/400"                     		  	
			//Chama Rotina de Atualizacao de Saldos Basicos.
			oProcess := MsNewProcess():New({|lEnd|	Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cSaldos,.T.,cFilDe,cFilAte,,,.T.,oProcess,nMin,nMax)},"","",.F.)
			oProcess:Activate()						
		Else
	#ENDIF
		oProcess := MsNewProcess():New({|lEnd|	Ct360RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cSaldos,oProcess,lAtSldBase)},"","",.F.)		
		oProcess:Activate()						
	#IFDEF TOP
		EndIf
	#ENDIF
Endif	

//// TRATAMENTO PARA ATUALIZAÇÃO DE SALDOS COMPOSTOS ANTES DE EXECUTAR A QUERY DE FILTRAGEM
Do Case
Case cAlias == 'CTU'
	//Verificar se tem algum saldo a ser atualizado por entidade
	If cIdent == "CTT"
		cOrigem := 	'CT3'
	ElseIf cIdent == "CTD"
		cOrigem := 	'CT4'
	ElseIf cIdent == "CTH"
		cOrigem := 	'CTI'		
	Else
		cOrigem := 	'CTI'		
	Endif
Case cAlias == 'CTV'
	cOrigem := "CT4"
	//Verificar se tem algum saldo a ser atualizado
Case cAlias == 'CTW'			
	cOrigem		:= 'CTI'	/// HEADER POR CLASSE DE VALORES
	//Verificar se tem algum saldo a ser atualizado
Case cAlias == 'CTX'			
	cOrigem		:= 'CTI'		
EndCase	
              
IF cAlias$("CTU/CTV/CTW/CTX")
	Ct360Data(cOrigem,cAlias,@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
	If lAtSldCmp .And. !Empty(dMinData)	//Se atualiza saldos compostos
		oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cSaldos,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt)},"","",.F.)
		oProcess:Activate()	
	Else		//Se nao atualiza os saldos compostos, somente da mensagem
		If !Empty(dMinData)
			cMensagem	:= STR0016
			cMensagem	+= STR0017		
			MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
			Return							//atraves da rotina de saldos compostos	
		EndIf    
	EndIf	
Endif

Do Case
Case cAlias  == "CT7"            
	cEntidIni	:= cContaIni
	cEntidFim	:= cContaFim
	cCodMasc		:= aSetOfBook[2]
	If nGrupo == 2
		cChave := "CONTA"
	Else									// Indice por Grupo -> Totaliza por grupo
		cChave := "CONTA+GRUPO"
	EndIf
	#IFDEF TOP   
		If TcSrvType() != "AS/400"                     			
			//Se nao tiver plano gerencial. 
			If Empty(aSetOfBook[5])
				/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
				CT7BlnQry(dDataIni,dDataFim,cAlias,cEntidIni,cEntidFim,cMoeda,;
							cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUsu)						
				If Empty(cFilUSU)
					cFILUSU := ".T."
				Endif						
			Endif
		EndIf
	#ENDIF
Case cAlias == 'CT3'    
	cEntidIni	:= cCCIni
	cEntidFim	:= cCCFim
	If cHeader == "CT1"
		cChave		:= "CONTA+CUSTO"
		cCodMasc	:= aSetOfBook[2]				
	Else
		If nGrupo == 2
			cChave   := "CUSTO+CONTA"                      
		Else									// Indice por Grupo -> Totaliza por grupo
			cChave := "CUSTO+CONTA+GRUPO"
		EndIf	
		cCodMasc		:= aSetOfBook[2]					
		cMascaraG	:= aSetOfBook[6]			
	Endif
	#IFDEF TOP
		If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
			/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
			CT3BlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cMoeda,;
						cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP)						
		EndIf
	#ENDIF		
Case cAlias =='CT4' 
	If lImp3Ent	//Balancete CC / Conta / Item
		If cHeader == "CTT"
			#IFDEF TOP
				If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CT4Bln3Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cMoeda,;
								cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP)						
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif															
				EndIf
			#ENDIF		
			cEntidIni	:= cCCIni
			cEntidFim	:= cCCFim
			cChave		:= "CUSTO+CONTA+ITEM"
			cCodMasc	:= aSetOfBook[2]
		EndIf	
	Else
		cEntidIni	:= cItemIni
		cEntidFim	:= cItemFim
		If cHeader == "CT1"	//Se for for Balancete Conta x Item
			cChave	:= "CONTA+ITEM"
			cCodMasc		:= aSetOfBook[4]			
		Else
			cChave   := "ITEM+CONTA"	
			cCodMasc		:= aSetOfBook[2]					
		EndIf	
		#IFDEF TOP
			If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
				/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
				CT4BlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cItemIni,cItemFim,cMoeda,;
							cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP)						
			EndIf
		#ENDIF	
	EndIf
Case cAlias == 'CTI'     
	If lImp4Ent	//Balancete CC x Cta x Item x Cl.Valor
		If cHeader == "CTT"             
			#IFDEF TOP
				If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CTIBln4Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,;
								cClVlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP)						
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif															
				EndIf
			#ENDIF				
			cChave		:= "CUSTO+CONTA+ITEM+CLVL"
			cEntidIni	:= cCCIni
			cEntidFim	:= cCCFim
			cCodMasc	:= aSetOfBook[2]			
		EndIf	
	Else
		cEntidIni	:= cClVlIni
		cEntidFim	:= cClvlFim
		cChave   := "CLVL+CONTA"
	EndIf
Case cAlias == 'CTU'
	If cIdent == 'CTT'
		cEntidIni	:= cCCIni
		cEntidFim	:= cCCFim	
		cChave		:= "CUSTO"
		cCodMasc		:= aSetOfBook[6]		
	ElseIf cIdent == 'CTD'
		cEntidIni	:= cItemIni
		cEntidFim	:= cItemFim		
		cChave   := "ITEM"
		cCodMasc		:= aSetOfBook[7]		
	ElseIf cIdent == 'CTH'
		cEntidIni	:= cClVlIni
		cEntidFim	:= cClvlFim		
		cChave   := "CLVL"
		cCodMasc		:= aSetOfBook[8]		
	Endif
	#IFDEF TOP  
		If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
			/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
			CTUBlnQry(dDataIni,dDataFim,cAlias,cIdent,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu)						
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif								
		EndIf
	#ENDIF	
Case cAlias == 'CTV'           
	If cHeader == 'CTT'
		cChave   := "CUSTO+ITEM"	
		cEntidIni1	:= cCCIni
		cEntidFim1	:= cCCFim
		cEntidIni2	:= cItemIni
		cEntidFim2	:= cItemFim
	ElseIf cHeader == 'CTD'
		cChave   := "ITEM+CUSTO"	
		cEntidIni1	:= cItemIni
		cEntidFim1	:= cItemFim	
		cEntidIni2	:= cCCIni
		cEntidFim2	:= cCCFim
	EndIf
Case cAlias == 'CTW'
	If cHeader	== 'CTT'
		cChave   := "CUSTO+CLVL"			
		cEntidIni1	:=	cCCIni
		cEntidFim1	:=	cCCFim 	            		
		cEntidIni2	:=	cClVlIni
		cEntidFim2	:=	cClVlFim		
	ElseIf cHeader == 'CTH'                
		cChave   := "CLVL+CUSTO"			
		cEntidIni1	:=	cClVlIni
		cEntidFim1	:=	cClVlFim
		cEntidIni2	:=	cCCIni
		cEntidFim2	:=	cCCFim 	
	EndIf	
Case cAlias == 'CTX'
	If cHeader == 'CTD'
		cChave  	 := "ITEM+CLVL"			
		cEntidIni1	:= 	cItemIni
		cEntidFim1	:= 	cItemFim
		cEntidIni2	:= 	cClVlIni
		cEntidFim2	:= 	cClVlFim		
	ElseIf cHeader == 'CTH'
		cChave  	 := "CLVL+ITEM"			
		cEntidIni1	:= 	cClVlIni
		cEntidFim1	:= 	cClVlFim			
		cEntidIni2	:= 	cItemIni 	
		cEntidFim2	:= 	cItemFim 	
	EndIf                                
Case cAlias	== 'CTY'
	cChave			:="ENTID1+ENTID2"
	If cHeader == 'CTT' .And. cFiltroEnt == 'CTD'	
		cEntidIni1	:= cCCIni
		cEntidFim1	:= cCCFim
		cEntidIni2	:= cClVlIni
		cEntidFim2	:= cClvlFim
	ElseIf cHeader == 'CTT' .And. cFiltroEnt == 'CTH'
		cEntidIni1	:= cCCIni
		cEntidFim1	:= cCCFim
		cEntidIni2	:= cItemIni
		cEntidFim2	:= cItemFim
	ElseIf cHeader == 'CTD' .And. cFiltroEnt == 'CTT'
		cEntidIni1	:= cItemIni
		cEntidFim1	:= cItemFim	
		cEntidIni2	:= cClVlIni
		cEntidFim2	:= cClVlFim	
	ElseIf cHeader == 'CTD' .And. cFiltroEnt == 'CTH'
		cEntidIni1	:= cItemIni
		cEntidFim1	:= cItemFim	
		cEntidIni2	:= cCCIni
		cEntidFim2	:= cCCFim		
	ElseIf cHeader == 'CTH' .And. cFiltroEnt == 'CTT'
		cEntidIni1	:= cClVlIni
		cEntidFim1	:= cClVlFim	
		cEntidIni2	:= cItemIni
		cEntidFim2	:= cItemFim		
	ElseIf cHeader == 'CTH' .And. cFiltroEnt == 'CTD'
		cEntidIni1	:= cClVlIni
		cEntidFim1	:= cClVlFim	
		cEntidIni2	:= cCCIni
		cEntidFim2	:= cCCFim					
	EndIf		
EndCase

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
	If cAlias = 'CTU'
		Do Case
		Case cIdent = 'CTT'
			cChave	:= "CUSTO"		
		Case cIdent = 'CTD'
			cChave	:= "ITEM"		
		Case cIdent = 'CTH'
			cChave	:= "CLVL"		
		EndCase	
	Else
	   cChave	:= "CONTA"
	EndIf	   
Endif

cArqTmp := CriaTrab(aCampos, .T.)

dbUseArea( .T.,, cArqTmp, "cArqTmp", .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqInd	:= CriaTrab(Nil, .F.)

IndRegua("cArqTmp",cArqInd,cChave,,,OemToAnsi(STR0001))  //"Selecionando Registros..."

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
	cArqTmp1 := CriaTrab(, .F.)
	IndRegua("cArqTmp",cArqTmp1,"ORDEM",,,OemToAnsi(STR0001))  //"Selecionando Registros..."
Endif	

dbSelectArea("cArqTmp")
DbClearIndex()
dbSetIndex(cArqInd+OrdBagExt())

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
	dbSetIndex(cArqTmp1+OrdBagExt())
Endif
                  
#IFDEF TOP
	If TcSrvType() != "AS/400"                     		
		//// SE FOR DEFINIÇÃO TOP 
		If cAlias $ "CT3/CT4"  .Or. cAlias $ "CT7/CTU"	 .Or. (cAlias == "CTI" .And. lImp4Ent)							
			If Select("TRBTMP") > 0		/// E O ALIAS TRBTMP ESTIVER ABERTO (INDICANDO QUE A QUERY FOI EXECUTADA)			
				
				If !Empty(cSegmento)
					If Len(aSetOfBook) == 0 .or. Empty(aSetOfBook[1])
						Help("CTN_CODIGO")
						Return(cArqTmp)
					Endif
					dbSelectArea("CTM")
					dbSetOrder(1)
					If MsSeek(xFilial()+cCodMasc)
						While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cCodMasc
							nPos += Val(CTM->CTM_DIGITO)
							If CTM->CTM_SEGMEN == strzero(val(cSegmento),2)
								nPos -= Val(CTM->CTM_DIGITO)
								nPos ++
								nDigitos := Val(CTM->CTM_DIGITO)      
								Exit
							EndIf	
							dbSkip()
						EndDo	
					Else
						Help("CTM_CODIGO")
						Return(cArqTmp)
					EndIf	
				EndIf	
				
				If cAlias == "CT3" .And. cHeader == "CTT" .And. !Empty(cMascaraG)
					If !Empty(cSegmentoG)
						dbSelectArea("CTM")
						dbSetOrder(1)
						If MsSeek(xFilial()+cMascaraG)
							While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascaraG
								nPosG += Val(CTM->CTM_DIGITO)
								If CTM->CTM_SEGMEN == cSegmentoG
									nPosG -= Val(CTM->CTM_DIGITO)
									nPosG ++
									nDigitosG := Val(CTM->CTM_DIGITO)      
									Exit
								EndIf	
								dbSkip()
							EndDo	
						EndIf	
					EndIf		
				EndIf	
				
  				dbSelectArea("TRBTMP")
				aStruTMP := dbStruct()			/// OBTEM A ESTRUTURA DO TMP
	
				nCampoLP	 := Ascan(aStruTMP,{|x| x[1]=="SLDLPANTDB"})
				dbSelectArea("TRBTMP")
				If ValType(oMeter) == "O"				
					oMeter:SetTotal(TRBTMP->(RecCount()))
					oMeter:Set(0)
				EndIf
				dbGoTop()						/// POSICIONA NO 1º REGISTRO DO TMP
	
				While TRBTMP->(!Eof())			/// REPLICA OS DADOS DA QUERY (TRBTMP) PARA P/ O TEMPORARIO EM DISCO
			
					//Se nao considera apuracao de L/P sera verificado na propria query
					dbSelectArea("TRBTMP")								
					If !lVlrZerado .And. lImpAntLP
						If (SALDOANTDB - SLDLPANTDB) == 0 .And. (SALDOANTCR - SLDLPANTCR) == 0 .And. ;
							(SALDODEB-MOVLPDEB) == 0 .And. (SALDOCRD-MOVLPCRD) == 0					
							dbSkip()
							Loop				
						EndIf				
					EndIf					

					//Verificacao da  Data Final de Existencia da Entidade somente se imprime saldo zerado 
					// e se realemten nao tiver saldo e movimento para a entidade. Caso tenha algum movimento
					//ou saldo devera imprimir.  												
					If lVlrZerado 
						If lImpAntLP 					
							If  cAlias $ "CT7/CT3/CT4/CTI" 
								If CtbExDtFim("CT1") 						
									If ((SALDOANTDB - SLDLPANTDB) == 0 .And. (SALDOANTCR - SLDLPANTCR) == 0 .And. ;
										(SALDODEB-MOVLPDEB) == 0 .And. (SALDOCRD-MOVLPCRD) == 0) 
										//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
										//relatorio for maior, nao ira imprimir a entidade. 
							 			If !Empty(TRBTMP->CT1DTEXSF) .And. (dtos(dDataIni) > DTOS(TRBTMP->CT1DTEXSF))  
											dbSelectArea("TRBTMP")
											dbSkip()
											Loop													
										EndIf
									EndIf	 
								EndIf
							EndIf
							If cAlias == "CT3" .Or. ( cAlias == "CTU" .And. cIdent == "CTT")  .Or. ( cAlias == "CTI" .And. lImp4Ent)
								If CtbExDtFim("CTT") 
									If ((SALDOANTDB - SLDLPANTDB) == 0 .And. (SALDOANTCR - SLDLPANTCR) == 0 .And. ;
										(SALDODEB-MOVLPDEB) == 0 .And. (SALDOCRD-MOVLPCRD) == 0) 
										//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
										//relatorio for maior, nao ira imprimir a entidade. 
							 			If !Empty(TRBTMP->CTTDTEXSF) .And. (dtos(dDataIni) > DTOS(TRBTMP->CTTDTEXSF))  
											dbSelectArea("TRBTMP")
											dbSkip()
											Loop													
										EndIf
									EndIf	 
								EndIf							
							EndIf                               
						
							If cAlias == "CT4" .Or. ( cAlias == "CTU" .And. cIdent == "CTD") .Or. ( cAlias == "CTI" .And. lImp4Ent)
								If CtbExDtFim("CTD") 
									If ((SALDOANTDB - SLDLPANTDB) == 0 .And. (SALDOANTCR - SLDLPANTCR) == 0 .And. ;
											(SALDODEB-MOVLPDEB) == 0 .And. (SALDOCRD-MOVLPCRD) == 0) 
																			//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
										//relatorio for maior, nao ira imprimir a entidade. 
							 			If !Empty(TRBTMP->CTDDTEXSF) .And. (dtos(dDataIni) > DTOS(TRBTMP->CTDDTEXSF))  
											dbSelectArea("TRBTMP")
											dbSkip()
											Loop													
										EndIf
									EndIf	  													
								EndIf
		                    EndIf                           
	
							If cAlias == "CTI"	.Or. ( cAlias == "CTU" .And. cIdent == "CTH")
								If CtbExDtFim("CTH") 								
									If ((SALDOANTDB - SLDLPANTDB) == 0 .And. (SALDOANTCR - SLDLPANTCR) == 0 .And. ;
											(SALDODEB-MOVLPDEB) == 0 .And. (SALDOCRD-MOVLPCRD) == 0) 										
										//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
										//relatorio for maior, nao ira imprimir a entidade. 
							 			If !Empty(TRBTMP->CTHDTEXSF) .And. (dtos(dDataIni) > DTOS(TRBTMP->CTHDTEXSF))  
											dbSelectArea("TRBTMP")
											dbSkip()
											Loop													
										EndIf
									EndIf	 
								EndIf 										
							EndIf
						Else
							If  cAlias $ "CT7/CT3/CT4/CTI" 
								If CtbExDtFim("CT1") 															
									If (SALDOANTDB  == 0 .And. SALDOANTCR  == 0 .And. SALDODEB == 0 .And. SALDOCRD == 0) 
										//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
										//relatorio for maior, nao ira imprimir a entidade. 
							 			If !Empty(TRBTMP->CT1DTEXSF) .And. (dtos(dDataIni) > DTOS(TRBTMP->CT1DTEXSF))  
											dbSelectArea("TRBTMP")
												dbSkip()
												Loop													
											EndIf
										EndIf	 
									EndIf																								
								EndIf                                                               																
							EndIf                                                                   
							
							If cAlias == "CT3" .Or. ( cAlias == "CTU" .And. cIdent == "CTT") .Or. ( cAlias == "CTI" .And. lImp4Ent)
								If CtbExDtFim("CTT") 
									If (SALDOANTDB == 0 .And. SALDOANTCR == 0 .And. SALDODEB == 0 .And. SALDOCRD == 0) 
										//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
										//relatorio for maior, nao ira imprimir a entidade. 
							 			If !Empty(TRBTMP->CTTDTEXSF) .And. (dtos(dDataIni) > DTOS(TRBTMP->CTTDTEXSF))  
											dbSelectArea("TRBTMP")
											dbSkip()
											Loop													
										EndIf
									EndIf	 
								EndIf							
							EndIf														
						
							If cAlias == "CT4" .Or. ( cAlias == "CTU" .And. cIdent == "CTD")  .Or. ( cAlias == "CTI" .And. lImp4Ent)
								If CtbExDtFim("CTD") 
									If (SALDOANTDB == 0 .And. SALDOANTCR == 0 .And. SALDODEB == 0 .And. SALDOCRD == 0) 								
										//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
										//relatorio for maior, nao ira imprimir a entidade. 
							 			If !Empty(TRBTMP->CTDDTEXSF) .And. (dtos(dDataIni) > DTOS(TRBTMP->CTDDTEXSF))  
											dbSelectArea("TRBTMP")
											dbSkip()
											Loop													
										EndIf
									EndIf	  					
								EndIf
		                    EndIf                           

							If cAlias == "CTI"	.Or. ( cAlias == "CTU" .And. cIdent == "CTH")
								If CtbExDtFim("CTH") 
									If (SALDOANTDB == 0 .And. SALDOANTCR == 0 .And. SALDODEB == 0 .And. SALDOCRD == 0) 								
										//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
										//relatorio for maior, nao ira imprimir a entidade. 
							 			If !Empty(TRBTMP->CTHDTEXSF) .And. (dtos(dDataIni) > DTOS(TRBTMP->CTHDTEXSF))  
											dbSelectArea("TRBTMP")
											dbSkip()
											Loop													
										EndIf
									EndIf	 
								EndIf 										
							EndIf	                    								
						EndIf
				
					If cAlias == "CTU"              
						Do Case
						Case cIdent	== "CTT"
							cCodigo	:= TRBTMP->CUSTO
						Case cIdent	== "CTD"
							cCodigo	:= TRBTMP->ITEM
						Case cIdent	== "CTH"
							cCodigo	:= TRBTMP->CLVL					
						EndCase                   
					Else
						cCodigo	:= TRBTMP->CONTA
						If cAlias == "CT3" .And. cHeader == "CTT"
							cCodGer	:= TRBTMP->CUSTO						
						EndIf
					EndIf
				
					If !Empty(cSegmento)
						If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
							If  !(Substr(cCodigo,nPos,nDigitos) $ (cFiltSegm) ) 
								dbSkip()
								Loop
							EndIf	
						Else
							If Substr(cCodigo,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
								Substr(cCodigo,nPos,nDigitos) > Alltrim(cSegFim)
								dbSkip()
								Loop
							EndIf	
						Endif
					EndIf		

					//Caso faca filtragem por segmento gerencial,verifico se esta dentro 
					//da solicitacao feita pelo usuario. 
					If cAlias == "CT3" .And. cHeader == "CTT"
						If !Empty(cSegmentoG)
							If Empty(cSegIniG) .And. Empty(cSegFimG) .And. !Empty(cFiltSegmG)
								If  !(Substr(cCodGer,nPosG,nDigitosG) $ (cFiltSegmG) ) 
									dbSkip()
									Loop
								EndIf	
							Else
			 					If Substr(cCodGer,nPosG,nDigitosG) < Alltrim(cSegIniG) .Or. ;
									Substr(cCodGer,nPosG,nDigitosG) > Alltrim(cSegFimG)
									dbSkip()
									Loop
								EndIf	
							Endif
						EndIf						
					EndIf
										
					If &("TRBTMP->("+cFILUSU+")")				
						RecLock("cArqTMP",.T.)
						For nTRB := 1 to Len(aStruTMP)
							Field->&(aStruTMP[nTRB,1]) := TRBTMP->&(aStruTMP[nTRB,1])			
							If Subs(aStruTmp[nTRB][1],1,6) $ "SALDODEB/SALDOCRD/SALDOANTDB/SALDOANTCR/SLDLPANTCR/SLDLPANTDB/MOVLPDEB/MOVLPCRD" .And. nDivide > 0 
								Field->&(aStruTMP[nTRB,1])	:=((TRBTMP->&(aStruTMP[nTRB,1])))/ndivide                   
							EndIf										
						Next                    
			
						If cAlias	== "CTU"            
							Do Case
							Case cIdent	== "CTT"
							    If Empty(TRBTMP->DESCCC)
									cArqTmp->DESCCC		:= TRBTMP->DESCCC01													    
							    EndIf						    
							Case cIdent == "CTD"
								If Empty(TRBTMP->DESCITEM)
									cArqTmp->DESCITEM	:= TRBTMP->DESCIT01							
								EndIf						
							Case cIdent == "CTH"
								If Empty(TRBTMP->DESCCLVL)							
									cArqTmp->DESCCLVL	:= TRBTMP->DESCCV01							
								EndIf						
							EndCase					
						Else
							If Empty(TRBTMP->DESCCTA)
								cArqTmp->DESCCTA	:= TRBTMP->DESCCTA01
							EndIf
				             
							If cAlias == "CT4"            
								If !lImp3Ent 
									If Empty(TRBTMP->DESCITEM)
										cArqTmp->DESCITEM	:= TRBTMP->DESCIT01
									EndIf    
								EndIf    
									
								If lImp3Ent	//Balancete CC / Conta / Item								             
									If Empty(TRBTMP->DESCCC)
										cArqTmp->DESCCC	:= TRBTMP->DESCCC01
									EndIf        								
									
									If TRBTMP->ALIAS == 'CT4'
										If Empty(TRBTMP->DESCITEM)
											cArqTmp->DESCITEM	:= TRBTMP->DESCIT01																			
									    EndIf
									EndIf
								EndIf
							EndIf
							
							If cAlias == "CTI" .And. lImp4Ent
								If !Empty(CLVL)
									If Empty(TRBTMP->DESCCLVL)							
										cArqTmp->DESCCLVL	:= TRBTMP->DESCCV01							
									EndIf						
								EndiF
								
							    If !Empty(ITEM)
									If Empty(TRBTMP->DESCITEM)
										cArqTmp->DESCITEM	:= TRBTMP->DESCIT01
									EndIf
								Endif
								                           
								If !Empty(CUSTO)
								    If Empty(TRBTMP->DESCCC)
										cArqTmp->DESCCC		:= TRBTMP->DESCCC01													    
								    EndIf						    
								EndIf					
							EndIf
						EndIf
				
						If nCampoLP > 0 
							cArqTmp->SALDOANTDB	:= SALDOANTDB - SLDLPANTDB
							cArqTmp->SALDOANTCR	:= SALDOANTCR - SLDLPANTCR
							cArqTmp->SALDODEB	:= SALDODEB - MOVLPDEB
							cArqTmp->SALDOCRD	:= SALDOCRD - MOVLPCRD
						EndIf					
				 		cArqTmp->SALDOANT	:= SALDOANTCR-SALDOANTDB
						cArqTmp->SALDOATUDB	:= SALDOANTDB+SALDODEB
						cArqTmp->SALDOATUCR	:= SALDOANTCR+SALDOCRD 				 	
						cArqTmp->SALDOATU	:= SALDOATUCR-SALDOATUDB			
						cArqTmp->MOVIMENTO	:= SALDOCRD-SALDODEB			
						
					    //Se imprime saldo anterior do periodo anterior zerado, verificar o saldo atual da data de zeramento.                
						If lRecDesp0 .And. Subs(TRBTMP->CONTA,1,1) $ cRecDesp		
							aSldRecDes	:= SaldoCT7(TRBTMP->CONTA,dDtZeraRD,cMoeda,cSaldos,'CTBXFUN',.F.)		
							nSldRDAtuD	:=	aSldRecDes[4] 
							nSldRDAtuC	:=	aSldRecDes[5]
							nSldAtuRD	:= nSldRDAtuC - nSldRDAtuD			
                                                
							cArqTmp->SALDOANT 	-= nSldAtuRD
							cArqTmp->SALDOANTDB	-=	nSldRDAtuD
							cArqTmp->SALDOANTCR -=	nSldRDAtuC 	
							cArqTmp->SALDOATU   -= nSldAtuRD
							cArqTmp->SALDOATUDB -=	nSldRDAtuD
							cArqTmp->SALDOATUCR -=	nSldRdAtuC			
						EndIf                        
						
						cArqTMP->(MsUnlock())				
					EndIf					
					TRBTMP->(dbSkip())     
					If ValType(oMeter) == "O"					
						nMeter++
				    	oMeter:Set(nMeter)				
				  	EndIf
				Enddo

				dbSelectArea("TRBTMP")
				dbCloseArea()					/// FECHA O TRBTMP (RETORNADO DA QUERY)
				lTemQry := .T.
			Endif
		Endif
	EndIf
#ENDIF


dbSelectArea("cArqTmp")
dbSetOrder(1)

If cAlias $ 'CT3/CT4/CTI' //Se imprime CONTA+ ENTIDADE
	If !Empty(aSetOfBook[5])
		MsgAlert(cMensagem)	
		Return
	Else
		If cHeader == "CT1"	//Se for Balancete Conta/Entidade
			#IFNDEF TOP	//Se for top connect, atualiza sinteticas
				// Monta Arquivo Lendo Plano Padrao - especifico para conta/ENTIDADE
				CtEntConta(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
							cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,;
							cAlias,lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,lImpAntLP,dDataLP,;
							nDivide,lVlrZerado,lNImpMov)	                       
			#ELSE
				If TcSrvType() == "AS/400"                     					
					// Monta Arquivo Lendo Plano Padrao - especifico para conta/ENTIDADE
					CtEntConta(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
							cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,;
							cAlias,lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,lImpAntLP,dDataLP,;
							nDivide,lVlrZerado,lNImpMov)	                       
				
				EndIf
			#ENDIF
			//Atualizacao de sinteticas para codebase e topconnect			
			If lImpSint	//Se atualiza sinteticas
		 		CtCtEntSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda)							
		    EndIf			
		Else
			If !lImp3Ent	.And. !lImp4Ent //Se não for Balancete CC / Conta / Item
				// Monta Arquivo Lendo Plano Padrao - especifico para conta/ENTIDADE
				CtContaEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
							cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
							cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
							lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
							nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG)
			Else	//Se for Balancete CC / Conta / Item				
				If lImp3Ent
					#IFNDEF TOP
						CtbCta2Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
									cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
									lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado)				
					#ELSE
						If TcSrvType() == "AS/400"                     									
							CtbCta2Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
										cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
										cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
										lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
										nDivide,lVlrZerado)
					    EndIf
					#ENDIF
					If lImpSint
				 		Ctb3CtaSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,cHeader)							
				    Endif			
				 ElseIf cAlias == "CTI" .And. lImp4Ent .And. cHeader == "CTT"
					#IFNDEF TOP
						CtbCta3Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
									cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
									lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado)				
					#ELSE
						If TcSrvType() == "AS/400"                     									
							CtbCta3Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
										cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
										cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
										lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
										nDivide,lVlrZerado)
					    EndIf
					#ENDIF	
					If lImpSint
				 		Ctb4CtaSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,cHeader)							
				    Endif						
				 EndIf				 
			EndIf
		EndIf
	EndIf
Else	
	If cAlias $ 'CTU/CT7' .Or. (!Empty(aSetOfBook[5]) .And. Empty(cAlias))		//So Imprime Entidade ou demonstrativos
		If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
			// Monta Arquivo Lendo Plano Gerencial                                   
			// Neste caso a filtragem de entidades contabeis é desprezada!
			CtbPlGeren(	oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,cAlias,;
						cIdent,lImpAntLP,dDataLP,lVlrZerado,cEntidIni,cEntidFim,aGeren)
			dbSetOrder(2)
		Else
			//Se nao for for Top Connect
			#IFNDEF TOP 			
				CtSoEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,cMoeda,;
					cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cIdent,;
					lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,;
					dDataLP,nDivide,lVlrZerado,lUsGaap,cMoedConv,cConsCrit,dDataConv,nTaxaConv,lRecDesp0,;
					cRecDesp,dDtZeraRD)
			#ELSE
				If TcSrvType() == "AS/400"                     								
					CtSoEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,cMoeda,;
						cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cIdent,;
						lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,;
						dDataLP,nDivide,lVlrZerado,lUsGaap,cMoedConv,cConsCrit,dDataConv,nTaxaConv)						
				EndIf				
			#ENDIF			  
			     
			If lImpSint	//Se atualiza sinteticas			
				Do Case
				Case cAlias =="CT7"
					//Atualizacao de sinteticas para codebase e topconnect			        	
			 		CtContaSup(oMeter,oText,oDlg,lNImpMov,cMoeda)									 									
				Case cAlias == "CTU"			    		
					CtbCTUSup(oMeter,oText,oDlg,lNImpMov,cMoeda,cIdent)
				EndCase
			EndIf

			dbSelectArea("cArqTmp")
			
			If FieldPos("ORDEMPRN") > 0
				dbSelectArea("cArqTmp")
				IndRegua("cArqTmp",Left(cArqInd, 7) + "A","ORDEMPRN",,,OemToAnsi(STR0001))  //"Selecionando Registros..."
				IndRegua("cArqTmp",Left(cArqInd, 7) + "B","SUPERIOR+CONTA",,,OemToAnsi(STR0001))  //"Selecionando Registros..."
				DbClearIndex()
				dbSetIndex(cArqInd+OrdBagExt())
				dbSetIndex(Left(cArqInd,7)+"A"+OrdBagExt())
				dbSetIndex(Left(cArqInd,7)+"B"+OrdBagExt())
				
				DbSetOrder(1)
				DbGoTop()
				While ! Eof()
					If Empty(SUPERIOR)
						CtGerSup(CONTA, @nOrdem)
					Endif
					DbSkip()
				Enddo
				DbSetOrder(2)
			Endif
		EndIf
	Else    	//Imprime Relatorios com 2 Entidades 
		If !Empty(aSetOfBook[5])
			MsgAlert(cMensagem)			
			Return
		Else
			If cAlias == 'CTY'		//Se for Relatorio de 2 Entidades filtrado pela 3a Entidade
				Ct2EntFil(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
					cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
					cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt)			
        	Else
				CtEntComp(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
					cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
					cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt)
			EndIf
		EndIf
	Endif
EndIf

RestArea(aSaveArea)

Return cArqTmp

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CtGerSup    ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 01.11.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Varre os niveis superiores a partir da entidade passada       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CtbXSal                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function CtGerSup(cConta, nOrdem)

Local aAreaEnt	:= GetArea(), lNivel := .F.

DbSetOrder(3)
DbSeek(cConta)

While SUPERIOR = cConta

	aAuxArea := GetArea()
	RestArea(aAreaENT)	

    If ! lNivel
		Replace ORDEMPRN With nOrdem ++
		lNivel := .T.
	Endif
	RestArea(aAuxArea)
	CtGerSup(CONTA, @nOrdem)
	DbSkip()

EndDo

RestArea(aAreaENT)

If ! lNivel
	Replace ORDEMPRN With nOrdem ++
Endif                                              

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtSoEntid ³ Autor ³Simone Mie Sato        ³ Data ³ 29.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Balancetes                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oMeter	  = Controle da regua                             ³±±
±±³          ³ oText 	  = Controle da regua                             ³±±
±±³          ³ oDlg  	  = Janela                                        ³±±
±±³          ³ lEnd  	  = Controle da regua -> finalizar                ³±±
±±³          ³ dDataIni   = Data Inicial de processamento                 ³±±
±±³          ³ dDataFinal = Data Final de processamento                   ³±±
±±³          ³ cEntidIni  = Codigo Entidade Inicial                       ³±±
±±³          ³ cEndtidFim = Codigo Entidade Final                         ³±±
±±³          ³ cMoeda     = Moeda		                                  ³±±
±±³          ³ cSaldos    = Tipos de Saldo a serem processados            ³±±
±±³          ³ aSetOfBook = Matriz de configuracao de livros              ³±±
±±³          ³ cSegmento  = Indica qual o segmento será filtrado          ³±±
±±³          ³ cSegIni    = Conteudo inicial do segmento                  ³±±
±±³          ³ cSegFim    = Conteudo Final do segmento                    ³±±
±±³          ³ cFiltSegm  = Indica se filtrara ou nao segmento            ³±±
±±³          ³ lNImpMov   = Indica se imprime ou nao a coluna movimento   ³±±
±±³          ³ cAlias     = Alias para regua       	                      ³±±
±±³          ³ cIdent     = Identificador do arquivo a ser processado     ³±±
±±³          ³ lCusto     = Considera Centro de Custo?                    ³±±
±±³          ³ lItem      = Considera Item Contabil?                      ³±±
±±³          ³ lCLVL      = Considera Classe de Valor?                    ³±±
±±³          ³ lAtSldBase = Indica se deve chamar rot atual. saldo basico ³±±
±±³          ³ lAtSldCmp  = Indica se deve chamar rot atua. saldo composto³±±
±±³          ³ nInicio    = Moeda Inicial (p/ atualizar saldo)            ³±±
±±³          ³ nFinal     = Moeda Final (p/ atualizar saldo)              ³±±
±±³          ³ cFilde     = Filial inicial (p/ atualizar saldo)           ³±±
±±³          ³ cFilAte    = Filial final (p/atualizar saldo)              ³±±
±±³          ³ lImpAntLP  = Imprime lancamentos Lucros e Perdas?          ³±±
±±³          ³ dDataLP    = Data ultimo Lucros e Perdas                   ³±±
±±³          ³ nDivide    = Divide valores (100,1000,1000000)             ³±±
±±³          ³ lVlrZerado = Grava ou nao valores zerados no arq temporario³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtSoEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidfim,;
					cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					lNImpMov,cAlias,cIdent,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,;
					nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,lVlrZerado,;
					lUsGaap,cMoedConv,cConsCrit,dDataConv,nTaxaConv,lRecDesp0,cRecDesp,;
					dDtZeraRD)

Local aSaveArea 	:= GetArea()
Local aSldRecDes	:= {}

Local nPos			:= 0
Local nDigitos		:= 0
local nSaldoAnt 	:= 0
Local nSaldoDeb 	:= 0
Local nSaldoCrd 	:= 0
Local nSaldoAtu 	:= 0
Local nSaldoAntD	:= 0
Local nSaldoAntC	:= 0
Local nSaldoAtuD	:= 0
Local nSaldoAtuC	:= 0
Local nMovimento	:= 0
Local nSldAnt		:= 0
Local nSldAtu		:= 0
Local nRegTmp   	:= 0
Local nTamDesc		:= ""
Local nCont			:= 0
Local nTotal		:= 0 
Local nMeter		:= 0
Local nSldRDAtuD	:= 0
Local nSldRDAtuC	:= 0
Local nSldAtuRD		:= 0

Local cMascara 		:= ""
Local cEntidSup			//Codigo da Entidade Superior(Conta,C.Custo,Item ou Classe de valor)
Local cDesc
Local cCodEnt		:= ""	//Codigo da entidade (conta, c.custo, item ou classe de valor)
Local cOrigem                                         
Local cMensagem	:= OemToAnsi(STR0016)+ OemToAnsi(STR0017)
Local cCodigo

Local lSemestre 	:= FieldPos("SALDOSEM") > 0		// Saldo por semestre
Local lPeriodo0		:= FieldPos("SALDOPER") > 0		// Saldo dois periodos anteriores

Local oProcess

Local dMinData	                                      

#IFDEF TOP
	Local nMin			:= 0
	Local nMax			:= 0 
#ENDIF

cIdent	  	:= Iif(cIdent	== Nil,'',cIdent)                       
lVlrZerado	:= Iif(lVlrZerado == Nil,.T.,lVlrZerado)
nDivide 	:= Iif(nDivide == Nil,1,nDivide)
DEFAULT lRecDesp0	:= .F.
DEFAULT cRecDesp	:= ""   
DEFAULT dDtZeraRD	:= CTOD("  /  /  ")

If ValType(oMeter) == "O"
	oMeter:SetTotal((cAlias)->(RecCount()))
	oMeter:Set(0)
EndIf

If cAlias == 'CT7'
	If !Empty(aSetOfBook[2])
		cMascara	:= aSetOfBook[2]
	EndIf
ElseIf cAlias	== 'CTU'
	Do Case
	Case cIdent == 'CTT'
		cMascara	:= aSetOfBook[6]			
		cOrigem		:= 'CT3'		
	Case cIdent	== 'CTD'
		cMascara	:= aSetOfBook[7]			            		
		cOrigem		:= 'CT4'		
	Case cIdent == 'CTH'			
		cMascara	:= aSetOfBook[8]	   
		cOrigem		:= 'CTI'		
	EndCase	
EndIf	

// Verifica Filtragem por Segmento da Entidade
If !Empty(cSegmento)
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cMascara)
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascara 
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == cSegmento
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	EndIf	
EndIf		

If cAlias == 'CTU'
	If !lAtSldBase	//Se os saldos nao foram atualizados na dig. lancamentos 
					//Chama rotina de atualizacao de saldos basicos					
		#IFDEF TOP	
			If TcSrvType() != "AS/400"                     					
				oProcess := MsNewProcess():New({|lEnd|	Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cSaldos,.T.,cFilDe,cFilAte,,,.T.,oProcess,nMin,nMax)},"","",.F.)
			Else
		#ENDIF
    		//Chama rotina de atualizacao de saldos basicos					
			oProcess := MsNewProcess():New({|lEnd|	Ct360RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cSaldos,oProcess,lAtSldBase)},"","",.F.)
		#IFDEF TOP	
			EndIf			
		#ENDIF
		oProcess:Activate()							
	EndIf	

	//Verificar se tem algum saldo a ser atualizado
	If cOrigem = 'CT3'                                                                      
		Ct360Data('CT3','CTU',@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
	Else
		Ct360Data(cOrigem,,@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
	EndIf

	//Se o parametro MV_SLDCOMP estiver com "S",isto e, se devera atualizar os saldos compost.
	//na emissao dos relatorios, verifica se tem algum registro desatualizado e atualiza as
	//tabelas de saldos compostos.
	If lAtSldCmp .And. !Empty(dMinData)	//Se atualiza saldos compostos no relatorio
		oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cSaldos,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt)},"","",.F.)
		oProcess:Activate()		
	Else
		If !Empty(dMinData)
			MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
											//atraves da rotina de saldos compostos	
			Return
		EndIf    
	EndIf

	Do Case
	Case cIdent == 'CTT'   
		cCodEnt		:= 'CUSTO'
		cCodEntSup	:= 'CCSUP'
		nTamDesc	:= Len(CriaVar("CTT->CTT_DESC"+cMoeda))
	Case cIdent=='CTD'     
		cCodEnt		:= 'ITEM'
		cCodEntSup  := 'ITSUP'
		nTamDesc	:= Len(CriaVar("CTD->CTD_DESC"+cMoeda))	
	Case cIdent =='CTH'    
		cCodEnt		:= 'CLVL'
		cCodEntSup  := 'CLSUP'     
		nTamDesc	:= Len(CriaVar("CTH->CTH_DESC"+cMoeda))
	EndCase

	dbSelectArea(cIdent)
	dbSetOrder(1)
	MsSeek(xFilial()+cEntidIni,.T.)

	While 	!Eof() .And. &(cIdent + "_FILIAL") == xFilial() .And.;	
			&(cIdent + "_" + cCodEnt) >= cEntidIni .And.;
			&(cIdent + "_" + cCodEnt) <= cEntidFim

        cCodigo :=  &(cIdent + "_" + cCodEnt)		// Codigo Atual
		If !Empty(aSetOfBook[1]) .And. !(aSetOfBook[1] $ &(cIdent+"_BOOK"))
			dbSkip()
			Loop
		Endif                  

		//Caso faca filtragem por segmento de item,verifico se esta dentro 
		//da solicitacao feita pelo usuario. 
		If !Empty(cSegmento)
			If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
				If  !(Substr(cCodigo,nPos,nDigitos) $ (cFiltSegm) ) 
					dbSkip()
					Loop
				EndIf	
			Else
				If 	Substr(cCodigo,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
					Substr(cCodigo,nPos,nDigitos) > Alltrim(cSegFim)
					dbSkip()
					Loop
				EndIf	
			Endif
		EndIf		
                                       
		aSaldoAnt := SaldoCTU(cIdent,cCodigo,dDataIni,cMoeda,cSaldos,,lImpAntLP,dDataLP)
		aSaldoAtu := SaldoCTU(cIdent,cCodigo,dDataFim,cMoeda,cSaldos,,lImpAntLP,dDataLP)

		nSaldoAntD 	:= aSaldoAnt[7]
		nSaldoAntC 	:= aSaldoAnt[8]
		nSldAnt		:= nSaldoAntC - nSaldoAntD			
	
		nSaldoAtuD 	:= aSaldoAtu[4]
		nSaldoAtuC 	:= aSaldoAtu[5] 
		nSldAtu		:= nSaldoAtuC - nSaldoAtuD			
	
		nSaldoDeb  	:= nSaldoAtuD - nSaldoAntD
		nSaldoCrd  	:= nSaldoAtuC - nSaldoAntC

	    If nDivide > 1
			nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)		
			nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
		EndIf
		nMovimento	:= nSaldoCrd-nSaldoDeb

		If !lVlrZerado .And. (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0)  .And. ;
			(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
    		dbSkip()
    		Loop
	    EndIf	
	    
		If lVlrZerado .And. (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0 ) .And. ;
			(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
			If CtbExDtFim(cIdent) 			
				//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
				//relatorio for maior, nao ira imprimir a entidade. 
  				If !CtbVlDtFim(cIdent,dDataIni) 				                                 					
// 				If !Empty(CT1->CT1_DTEXSF) .And. (dtos(dDataIni) > DTOS(CT1->CT1_DTEXSF))  
					dbSelectArea(cIdent)
					dbSkip()
					Loop																
				EndIf                                                       
			EndIf
		EndIf
	    
	    

		cDesc := &(cIdent+"->"+cIdent+"_DESC"+cMoeda)
		If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
			cDesc := &(cIdent+"->"+cIdent+"_DESC01")
		Endif

		dbSelectArea("cArqTmp")
		dbSetOrder(1)	
		If !MsSeek(cCodigo)
			dbAppend()   
			If cIdent == 'CTT'
				Replace CUSTO   	With cCodigo
				Replace DESCCC		With cDesc
				Replace TIPOCC 		With CTT->CTT_CLASSE			
				Replace CCSUP 		With CTT->CTT_CCSUP	
				Replace CCRES		With CTT->CTT_RES	
			ElseIf cIdent == 'CTD'
				Replace ITEM 		With cCodigo
				Replace DESCITEM	With cDesc
				Replace TIPOITEM 	With CTD->CTD_CLASSE
				Replace ITSUP  		With CTD->CTD_ITSUP		
				Replace ITEMRES		With CTD->CTD_RES
			ElseIf cIdent == 'CTH'
				Replace CLVL    	 With cCodigo
				Replace DESCCLVL	 With cDesc
				Replace TIPOCLVL 	 With CTH->CTH_CLASSE
				Replace CLSUP    	 With CTH->CTH_CLSUP
				Replace CLVLRES		 With CTH->CTH_RES
			EndIf
		EndIf           

		If nDivide > 1		
			For nCont := 1 To Len(aSaldoAnt)
				aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
			Next nCont
			For nCont := 1 To Len(aSaldoAtu)
				aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
			Next nCont
		EndIf	
		
		dbSelectArea("cArqTmp")
		dbSetOrder(1)
		Replace SALDOANT 	With aSaldoAnt[6]		// Saldo anterior
		Replace SALDOANTDB	With aSaldoAnt[7]		// Saldo anterior debito
		Replace SALDOANTCR	With aSaldoAnt[8]		// Saldo anterior credito	
		Replace SALDOATU 	With aSaldoAtu[1]		// Saldo Atual           
		Replace SALDOATUDB	With aSaldoatu[4]		// Saldo Atual debito
		Replace SALDOATUCR	With aSaldoAtu[5]		// saldo atual credito
	
		Replace  SALDODEB	With nSaldoDeb				// Saldo Debito
		Replace  SALDOCRD	With nSaldoCrd				// Saldo Credito
	
		If !lNImpMov
			Replace MOVIMENTO With nMovimento
		Endif
		dbSelectArea(cIdent)
		dbSkip()
		If ValType(oMeter) == "O"		
			nMeter++
    		oMeter:Set(nMeter)				
   		EndIf
	Enddo   
ElseIf cAlias == 'CT7'//SE FOR BALANCETE POR CONTA
	//Se os saldos basicos nao foram atualizados na dig. lancamentos
	
    If !lAtSldBase
    	#IFDEF TOP			
    		If TcSrvType() != "AS/400"                     					
				//Chama Rotina de Atualizacao de Saldos Basicos.
				oProcess := MsNewProcess():New({|lEnd|	Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cSaldos,.T.,cFilDe,cFilAte,,,.T.,oProcess,nMin,nMax)},"","",.F.)
				oProcess:Activate()				
			Else
		#ENDIF
			oProcess := MsNewProcess():New({|lEnd|	Ct360RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cSaldos,oProcess,lAtSldBase)},"","",.F.)		
			oProcess:Activate()									
    	#IFDEF TOP			
    		EndIf			
		#ENDIF
	Endif	
	
	dbSelectArea("CT1")
	dbSetOrder(3)

	// Posiciona na primeira conta analitica
	MsSeek(xFilial()+"2"+cEntidIni,.T.)

	While !Eof() .And. 	CT1->CT1_FILIAL == xFilial() .And.;
				CT1->CT1_CONTA <= cEntidFim .And. CT1_CLASSE != "1"

		// Grava conta analitica
		cConta 	:= CT1->CT1_CONTA

		// Conta nao pertencera ao arquivo pois sera filtrado pelo Set Of Book 
		// Escolhido 
		If !Empty(aSetOfBook[1])
			If !(aSetOfBook[1] $ CT1->CT1_BOOK)
				CT1->(dbSkip())
				Loop
			EndIf
		EndIf		

	
		If !Empty(cSegmento)
			If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
				If  !(Substr(CT1->CT1_CONTA,nPos,nDigitos) $ (cFiltSegm) ) 
					dbSkip()
					Loop
				EndIf	
			Else
				If Substr(CT1->CT1_CONTA,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
					Substr(CT1->CT1_CONTA,nPos,nDigitos) > Alltrim(cSegFim)
					CT1->(dbSkip())
					Loop
				EndIf	
			Endif
		EndIf	
	
		aSaldoAnt := SaldoCT7(cConta,dDataIni,cMoeda,cSaldos,'CTBXFUN',lImpAntLP,dDataLP)
		aSaldoAtu := SaldoCT7(cConta,dDataFim,cMoeda,cSaldos,'CTBXFUN',lImpAntLP,dDataLP)
		
	    //Se imprime saldo anterior do periodo anterior zerado, verificar o saldo atual da data de zeramento.                
		If lRecDesp0 .And. Subs(cConta,1,1) $ cRecDesp		
			aSldRecDes	:= SaldoCT7(cConta,dDtZeraRD,cMoeda,cSaldos,'CTBXFUN',.F.)		
			nSldRDAtuD	:=	aSldRecDes[4] 
			nSldRDAtuC	:=	aSldRecDes[5]
			nSldAtuRD	:= nSldRDAtuC - nSldRDAtuD			
                                                
			aSaldoAtu[1] -= nSldAtuRD
			aSaldoAtu[4] -=	nSldRDAtuD
			aSaldoAtu[5] -=	nSldRDAtuC 	
			aSaldoAnt[6] -= nSldAtuRD
			aSaldoAnt[7] -=	nSldRDAtuD
			aSaldoAnt[8] -=	nSldRdAtuC			
		EndIf                        

		nSaldoAntD 	:= aSaldoAnt[7]
		nSaldoAntC 	:= aSaldoAnt[8]
	
		nSldAnt		:= nSaldoAntC - nSaldoAntD		
	
		nSaldoAtuD 	:= aSaldoAtu[4]
		nSaldoAtuC 	:= aSaldoAtu[5] 
		nSldAtu		:= nSaldoAtuC - nSaldoAtuD
	
		nSaldoDeb  := nSaldoAtuD - nSaldoAntD
		nSaldoCrd  := nSaldoAtuC - nSaldoAntC
		       
	    If nDivide > 1
			nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)		
			nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
		EndIf
		
		nMovimento	:= nSaldoCrd-nSaldoDeb

		If !lVlrZerado .And. (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0 ) .And. ;
			(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
			dbSkip()
    		Loop
	    EndIf	
	    
		If lVlrZerado .And. (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0 ) .And. ;
			(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
			If CtbExDtFim("CT1") 			
				//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
				//relatorio for maior, nao ira imprimir a entidade. 
 				If !Empty(CT1->CT1_DTEXSF) .And. (dtos(dDataIni) > DTOS(CT1->CT1_DTEXSF))  
					dbSelectArea("CT1")
					dbSkip()
					Loop																
				EndIf                                                       
			EndIf
		EndIf
	    

		cDesc 		:= &("CT1->CT1_DESC"+cMoeda)
		If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
			cDesc 	:= CT1->CT1_DESC01
		Endif
		nTamDesc    := Len(CriaVar("CT1->CT1_DESC"+cMoeda))
		dbSelectArea("cArqTmp")
		dbSetOrder(1)	
		If !MsSeek(xFilial()+cConta)
			dbAppend()
			Replace CONTA 		With cConta
			Replace SUPERIOR	With CT1->CT1_CTASUP
			Replace DESCCTA		With cDesc
			Replace TIPOCONTA 	With CT1->CT1_CLASSE
			Replace CTARES    	With CT1->CT1_RES
			Replace NORMAL    	With CT1->CT1_NORMAL
			Replace GRUPO		With CT1->CT1_GRUPO
			Replace ESTOUR 		With CT1->CT1_ESTOUR
		EndIf
		
        If nDivide > 1
			For nCont := 1 To Len(aSaldoAnt)
				aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
			Next nCont
			For nCont := 1 To Len(aSaldoAtu)
				aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
			Next nCont
		EndIf

		//Se for Relatorio US Gaap
		If lUsGaap
			nSlAntGap	:= aSaldoAnt[6]		// Saldo Anterior
			nSlAntGapD	:= aSaldoAnt[7]		// Saldo anterior debito
			nSlAntGapC	:= aSaldoAnt[8]		// Saldo anterior credito	
			nSlAtuGap	:= aSaldoAtu[1]		// Saldo Atual           
			nSlAtuGapD	:= aSaldoatu[4]		// Saldo Atual debito
			nSlAtuGapC	:= aSaldoatu[5]		// Saldo Atual credito
            nSlDebGap	:= nSaldoDeb		// Saldo Debito
            nSlCrdGap	:= nSaldoCrd		// Saldo Credito
		
			If cConsCrit == "5"	//Se for Criterio do Plano de Contas
				cCritPlCta	:= Ctr045Med(cMoedConv)
			EndIf

			If cConsCrit $ "123" .Or. (cConsCrit == "5" .And. cCritPlCta $ "123")
				If cConsCrit == "5"					
					aSaldoAnt[6]	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGap)					
					aSaldoAnt[7]	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGapD)										
					aSaldoAnt[8]	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGapC)					
					aSaldoAtu[1]	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAtuGap)					
					aSaldoAtu[4]	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAtuGapD)					
					aSaldoAtu[5]	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGapC)									
					nSaldoDeb		:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlDebGap)									
					nSaldoCrd		:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlCrdGap)														
				Else
					aSaldoAnt[6]	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGap)					
					aSaldoAnt[7]	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGapD)										
					aSaldoAnt[8]	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGapC)					
					aSaldoAtu[1]	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAtuGap)					
					aSaldoAtu[4]	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAtuGapD)					
					aSaldoAtu[5]	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGapC)									
					nSaldoDeb		:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlDebGap)									
					nSaldoCrd		:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlCrdGap)													
				EndIf        
			ElseIf cConsCrit == "4" .Or. (cConsCrit == "5" .And. cCritPlCta == "4")	
				aSaldoAnt[6]	:= nSlAntGap/nTaxaConv
				aSaldoAnt[7]	:= nSlAntGapD/nTaxaConv 
				aSaldoAnt[8]	:= nSlAntGapC/nTaxaConv 
				aSaldoAtu[1]	:= nSlAtuGap/nTaxaConv 
				aSaldoAtu[4]	:= nSlAtuGapD/nTaxaConv 
				aSaldoAtu[5]	:= nSlAtuGapC/nTaxaConv  
				nSaldoDeb		:= nSlDebGap/nTaxaConv
				nSaldoCrd		:= nSlCrdGap/nTaxaConv			
			EndIf			
		EndIf		        		
		dbSelectArea("cArqTmp")
		dbSetOrder(1)
		Replace SALDOANT 	With aSaldoAnt[6]		// Saldo anterior
		Replace SALDOANTDB	With aSaldoAnt[7]		// Saldo anterior debito
		Replace SALDOANTCR	With aSaldoAnt[8]		// Saldo anterior credito
		Replace SALDOATU 	With aSaldoAtu[1]		// Saldo Atual
		Replace SALDOATUDB	With aSaldoatu[4]		// Saldo Atual debito
		Replace SALDOATUCR	With aSaldoAtu[5]		// saldo atual credito
	
		If lSemestre		// Saldo por semestre
			nSaldoSem	:= SaldoCT7(cConta,dSemestre,cMoeda,cSaldos,,lImpAntLP,dDataLP)
			nSaldoSem 	:= Round(NoRound((nSaldoSem/nDivide),3),2)
			Replace SALDOSEM With nSaldoSem
		Endif

		If lPeriodo0		// Saldo Periodo determinado
			nSaldoPer	:= SaldoCT7(cConta,dPeriodo0,cMoeda,cSaldos,,lImpAntLP,dDataLP)
			nSaldoPer	:= Round(NoRound((nSaldoPer/nDivide),3),2)
			Replace SALDOPER With nSaldoPer			
		Endif
	
		Replace  SALDODEB	With nSaldoDeb				// Saldo Debito
		Replace  SALDOCRD	With nSaldoCrd				// Saldo Credito	                                              
		
		If !lNImpMov
			Replace MOVIMENTO With SALDOCRD-SALDODEB
		Endif
    	
		dbSelectArea("CT1")
		dbSetOrder(3)
		dbSkip()
		If ValType(oMeter) == "O"		
			nMeter++
    		oMeter:Set(nMeter)
   		EndIf
	EndDo	
	
EndIf
RestArea(aSaveArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtAtSldCmp³ Autor ³ Simone Mie Sato       ³ Data ³ 07.12.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Atualiza saldos compostos a partir dos relatorios.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oMeter                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtAtSldCmp(oObj,cAlias,cSaldos,cMoeda,dDataIni,cOrigem,dMinData,;
					cFilDe,cFilate,lCusto,lItem,lClVl,lAtSldBase,dDataFim,aAtSldCmp,;
					cFilX)
		
Local aSaveArea	:= GetArea()
#IFNDEF TOP  
Local nInicio	:= Val(cMoeda)	
Local nFinal	:= Val(cMoeda)
#ENDIF

cOrigem	:= Iif(cOrigem == Nil,"",cOrigem)
cFilX	:= Iif(cFilX == Nil,cFilAnt,cFilX)

#IFDEF TOP
	//If cOrigem == 'CT3'
	//	Ct360Query('CT3','CTU',cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,lCusto,lItem,lClVl,dMinData,oObj,@nMin,@nMax,, .T.,, dDataFim,aAtSldCmp)
	//Else 
		Ct360Query(cOrigem,cAlias,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,lCusto,lItem,lClVl,dMinData,oObj,/*FunName()*/,,)
	//EndIf
	//If nMin > 0 .Or. nMax > 0
		Ct360GrSld(Val(cMoeda),Val(cMoeda),cSaldos,cMoeda,cMoeda,cFilDe,cFilAte,oObj,,,,,cFilX)			
		Ct360Flag(cOrigem,cAlias,dMinData,cMoeda,cMoeda,cSaldos,.T.,cFilDe,cFilAte,oObj)      
	//EndIf

#ELSE
	
	Do Case
	Case cOrigem == 'CT3'
		Ct360Del("CTU","CTT",cFilde,cFilAte,cMoeda,cMoeda,cSaldos,dMinData,oObj,3,,,,cFilX)					
		Ct360GrSld(nInicio,nFinal,cSaldos,cMoeda,cMoeda,cFilDe,cFilAte,oObj,"CT3","CTU",dMinData,,cFilX)
		Ct360Fim("CTU","CTT",cFilde,cFilAte,cMoeda,cMoeda,cSaldos,dMinData,oObj,2,cFilX)
	Case cOrigem == 'CT4'
		Ct360Del("CTU","CTD",cFilde,cFilAte,cMoeda,cMoeda,cSaldos,dMinData,oObj,3,,,,cFilX)								
		Ct360GrSld(nInicio,nFinal,cSaldos,cMoeda,cMoeda,cFilDe,cFilAte,oObj,"CT4","CTU",dMinData,,cFilX)
		Ct360Fim("CTU","CTD",cFilde,cFilAte,cMoeda,cMoeda,cSaldos,dMinData,oObj,2,cFilX)			
		Ct360Del("CTV",,cFilde,cFilAte,cMoeda,cMoeda,cSaldos,dMinData,oObj,5,,,,cFilX)								
		Ct360GrSld(nInicio,nFinal,cSaldos,cMoeda,cMoeda,cFilDe,cFilAte,oObj,"CT4","CTV",dMinData,,cFilX)
		Ct360Fim("CTV",,cFilde,cFilAte,cMoeda,cMoeda,cSaldos,dMinData,oObj,2,cFilX)			
	Case cOrigem == 'CTI'
		Ct360Del("CTU","CTH",cFilde,cFilAte,cMoeda,cMoeda,cSaldos,dMinData,oObj,3,,,,cFilX)								
		Ct360GrSld(nInicio,nFinal,cSaldos,cMoeda,cMoeda,cFilDe,cFilAte,oObj,"CTI","CTU",dMinData,,cFilX)
		Ct360Fim("CTU","CTH",cFilde,cFilAte,cMoeda,cMoeda,cSaldos,dMinData,oObj,2,cFilX)			
		Ct360Del("CTW",,cFilde,cFilAte,cMoeda,cMoeda,cSaldos,dMinData,oObj,5,,,,cFilX)								
		Ct360GrSld(nInicio,nFinal,cSaldos,cMoeda,cMoeda,cFilDe,cFilAte,oObj,"CTI","CTW",dMinData,,cFilX)
		Ct360Fim("CTW",,cFilde,cFilAte,cMoeda,cMoeda,cSaldos,dMinData,oObj,2,cFilX)						
		Ct360Del("CTX",,cFilde,cFilAte,cMoeda,cMoeda,cSaldos,dMinData,oObj,5,,,,cFilX)													
		Ct360GrSld(nInicio,nFinal,cSaldos,cMoeda,cMoeda,cFilDe,cFilAte,oObj,"CTI","CTX",dMinData,,cFilX)
		Ct360Fim("CTX",,cFilde,cFilAte,cMoeda,cMoeda,cSaldos,dMinData,oObj,2,cFilX)			
		Ct360Del("CTY",,cFilde,cFilAte,cMoeda,cMoeda,cSaldos,dMinData,oObj,5,,,,cFilX)													
		Ct360GrSld(nInicio,nFinal,cSaldos,cMoeda,cMoeda,cFilDe,cFilAte,oObj,"CTI","CTY",dMinData,,cFilX)											
		Ct360Fim("CTY",,cFilde,cFilAte,cMoeda,cMoeda,cSaldos,dMinData,oObj,2,cFilX)							
	EndCase
#ENDIF

RestArea(aSaveArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtContaEnt³ Autor ³ Simone Mie Sato       ³ Data ³ 28.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Balancetes Entidade / Conta   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oMeter	  = Controle da regua                             ³±±
±±³          ³ oText 	  = Controle da regua                             ³±±
±±³          ³ oDlg  	  = Janela                                        ³±±
±±³          ³ lEnd  	  = Controle da regua -> finalizar                ³±±
±±³          ³ dDataIni   = Data Inicial de processamento                 ³±±
±±³          ³ dDataFinal = Data Final de processamento                   ³±±
±±³          ³ cEntidIni  = Codigo Entidade Inicial                       ³±±
±±³          ³ cEndtidFim = Codigo Entidade Final                         ³±±
±±³          ³ cMoeda     = Moeda		                                  ³±±
±±³          ³ cSaldos    = Tipos de Saldo a serem processados            ³±±
±±³          ³ aSetOfBook = Matriz de configuracao de livros              ³±±
±±³          ³ cSegmento  = Indica qual o segmento será filtrado          ³±±
±±³          ³ cSegIni    = Conteudo inicial do segmento                  ³±±
±±³          ³ cSegFim    = Conteudo Final do segmento                    ³±±
±±³          ³ cFiltSegm  = Indica se filtrara ou nao segmento            ³±±
±±³          ³ lNImpMov   = Indica se imprime ou nao a coluna movimento   ³±±
±±³          ³ cAlias     = Alias para regua       	                      ³±±
±±³          ³ cIdent     = Identificador do arquivo a ser processado     ³±±
±±³          ³ lCusto     = Considera Centro de Custo?                    ³±±
±±³          ³ lItem      = Considera Item Contabil?                      ³±±
±±³          ³ lCLVL      = Considera Classe de Valor?                    ³±±
±±³          ³ lAtSldBase = Indica se deve chamar rot atual. saldo basico ³±±
±±³          ³ lAtSldCmp  = Indica se deve chamar rot atua. saldo composto³±±
±±³          ³ nInicio    = Moeda Inicial (p/ atualizar saldo)            ³±±
±±³          ³ nFinal     = Moeda Final (p/ atualizar saldo)              ³±±
±±³          ³ cFilde     = Filial inicial (p/ atualizar saldo)           ³±±
±±³          ³ cFilAte    = Filial final (p/atualizar saldo)              ³±±
±±³          ³ lImpAntLP  = Imprime lancamentos Lucros e Perdas?          ³±±
±±³          ³ dDataLP    = Data ultimo Lucros e Perdas                   ³±±
±±³          ³ nDivide    = Divide valores (100,1000,1000000)             ³±±
±±³          ³ lVlrZerado = Grava ou nao valores zerados no arq temporario³±±
±±³          ³ cSegmentoG = Filtra por Segmento	(CC/Item ou ClVl)         ³±±
±±³          ³ cSegIniG = Segmento Inicial		                          ³±±
±±³          ³ cSegFimG = Segmento Final  		                          ³±±
±±³          ³ cFiltSegmG = Segmento Contido em  	                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtContaEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
					cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,;
					nTamDesc,cSegmento,	cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,;
					lCusto,lItem,lClVl,lAtSldBase,nInicio,nFinal,cFilDe,cFilate,;
					lImpAntLP,dDataLP,nDivide,lVlrZerado,cSegmentoG,;
					cSegIniG,cSegFimG,cFiltSegmG)

Local cEntid
Local cContaSup
Local cDesc
Local aSaveArea := GetArea()
Local cMascara  := aSetOfBook[2] //VERIFICAR
local nSaldoAnt := 0
Local nSaldoDeb := 0
Local nSaldoCrd := 0
Local nSaldoAtu := 0
Local nSaldoAntD:= 0
Local nSaldoAntC:= 0
Local nSaldoAtuD:= 0
Local nSaldoAtuC:= 0
Local nSldAnt	:= 0
Local nSldAtu	:= 0
Local nPos		:= 0
Local nDigitos	:= 0
Local nRegTmp   := 0
Local nMovimento:= 0 
Local nOrder1	:= 0                                  
Local nOrder2	:= 0
Local bCond1	:= {||.F.}
Local bCond2	:= {||.F.}
Local cCodEnt	:= ""
Local cCusIni	:= ""
Local cCusFim	:= ""
Local cItemIni	:= ""
Local cItemFim	:= ""
Local cCodRes	:= ""
Local cCodEntRes:= ""              
Local cTipoEnt	:= ""                  
Local cCodTpEnt := ""
Local nTamCC	:= Len(CriaVar("CTT_CUSTO"))
Local nTamItem	:= Len(CriaVar("CTD_ITEM")) 
Local nTamCta	:= Len(CriaVar("CT1_CONTA"))
Local cDescEnt	:= ""
Local cCadAlias	:= ""
Local nCont		:= 0 
Local nTotal	:= 0 
Local cMascaraG := aSetOfBook[If(cAlias = 'CT3', 6, If(cAlias = 'CT4', 7, 8))]
Local nPosG		:= 0
Local nDigitosG	:= 0, cSuperior := "", cIndice := "", cCpoSup := "", cCadastro := ""
Local cEntidG	:= ""
Local cDtExsf	:= ""

#IFDEF TOP
	Local cCondCT1	:= ""     
	Local cCondFil	:= ""
	Local cCondEnt	:= ""     
	Local cContaEnt	:= ""                           	
	Local cEstour	:= ""        	
	Local cFilCT1	:= ""	
	Local cOrderBy	:= ""	
	Local cQuery 	:= ""	
	Local cSelect	:= ""          	
	Local nMin		:= 0	
	Local nMax		:= 0			
	Local oProcess	
#ENDIF
Local nMeter	:= 0

lVlrZerado	:= Iif(lVlrZerado == Nil,.T.,lVlrZerado)
nDivide 	:= Iif(nDivide == Nil,1,nDivide)

// Verifica Filtragem por Segmento da  Conta
If !Empty(cSegmento)
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cMascara)
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascara 
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == cSegmento
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	EndIf	
EndIf		

// Verifica Filtragem por Segmento da  Conta
If !Empty(cSegmentoG)
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cMascaraG)
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascaraG
			nPosG += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == cSegmentoG
				nPosG -= Val(CTM->CTM_DIGITO)
				nPosG ++
				nDigitosG := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	EndIf	
EndIf		

#IFDEF TOP                                              
	//So ira executar as querys se o balancete for ITEM/CONTA ou CLVL/CONTA
	If TcSrvType() != "AS/400" .And. cAlias $ 'CT3/CT4/CTI'
		//Se os saldos basicos nao foram atualizados na dig. lancamentos contab. 
		If !lAtSldBase
			//Chama Rotina de Atualizacao de Saldos Basicos.
			oProcess := MsNewProcess():New({|lEnd|	Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cSaldos,.T.,cFilDe,cFilAte,,,.T.,oProcess,nMin,nMax)},"","",.F.)
			oProcess:Activate()	
		EndIf                       
	
		If cAlias == "CT3"
			cFilEnt 	:=	Iif(Empty(xFilial("CTT")),"C","E")		
			cCadAlias   := "CTT"
			cSelect		:= "ARQ.CT3_CUSTO CODENT, CAD.CTT_RES ENTRES, CAD.CTT_BOOK ENTBOOK, "
			cSelect		+= "CAD.CTT_CCSUP ENTSUP, CAD.CTT_CLASSE ENTCLASSE, "
			If CtbExDtFim("CTT") 
				cSelect += "CAD.CTT_DTEXSF CTTDTEXSF, "			
			EndIf
			cSelect		+= "CAD.CTT_DESC" + cMoeda+ " DESCENT "   
			cCondEnt	:= " ARQ.CT3_CUSTO BETWEEN '" + cEntidIni + "' AND '" + cEntidFim + "' AND " 
			cCondEnt   	+= " ( ARQ.CT3_CUSTO = CAD.CTT_CUSTO " 
			cOrderBy	:= " ARQ.CT3_CUSTO, ARQ.CT3_CONTA"    
		ElseIf cAlias == "CT4"
			cFilEnt 	:=	Iif(Empty(xFilial("CTD")),"C","E")		
			cCadAlias   := "CTD"                                       
			cSelect		:= "ARQ.CT4_ITEM CODENT, CAD.CTD_RES ENTRES, CAD.CTD_BOOK ENTBOOK, "
			cSelect		+= "CAD.CTD_ITSUP ENTSUP, CAD.CTD_CLASSE ENTCLASSE, "
			If CtbExDtFim("CTD") 
				cSelect += "CAD.CTD_DTEXSF CTDDTEXSF, "			
			EndIf			
			cSelect		+= "CAD.CTD_DESC" + cMoeda+ " DESCENT "   
			cCondEnt	:= " ARQ.CT4_ITEM BETWEEN '" + cEntidIni + "' AND '" + cEntidFim + "' AND " 
			If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
				cCondEnt += " 	CAD.CTD_BOOK LIKE '%"+aSetOfBook[1]+"%' AND  "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
			Endif			
			cCondEnt   	+= " ( ARQ.CT4_ITEM = CAD.CTD_ITEM " 
			cOrderBy	:= " ARQ.CT4_ITEM, ARQ.CT4_CONTA"    
		ElseIf cAlias == "CTI"			
			cFilEnt		:=	Iif(Empty(xFilial("CTH")),"C","E")
			cCadAlias	:= "CTH"
			cSelect		:= "ARQ.CTI_CLVL CODENT, CAD.CTH_RES ENTRES, CAD.CTH_BOOK ENTBOOK, "
			cSelect		+= "CAD.CTH_CLSUP ENTSUP, CAD.CTH_CLASSE ENTCLASSE, "
			If CtbExDtFim("CTH") 
				cSelect += "CAD.CTH_DTEXSF CTHDTEXSF, "			
			EndIf			
			cSelect		+= "CAD.CTH_DESC" + cMoeda+ " DESCENT "   			
			cCondEnt	:= " ARQ.CTI_CLVL BETWEEN '" + cEntidIni + "' AND '" + cEntidFim + "' AND " 			
			cCondEnt   	+= " ( ARQ.CTI_CLVL = CAD.CTH_CLVL " 
			cOrderBy	:= " ARQ.CTI_CLVL, ARQ.CTI_CONTA"
		EndIf

		cFilCT1 :=	Iif(Empty(xFilial("CT1")),"C","E")
		
		If cFilEnt == "E"		//Se for Exclusivo
			cCondFil := " AND ARQ."+cAlias+"_FILIAL = '" + xFilial(cCadAlias) +"' ) AND "
		Else                                                  
			cCondFil := " ) AND " 
		EndIf			

		If cFilCT1 == "E"		//Se for Exclusivo
			cCondCT1 := " AND ARQ."+cAlias+"_FILIAL = '" + xFilial("CT1") +"' ) AND "
		Else                                                  
			cCondCT1 := " ) AND " 
		EndIf			
		
		cEstour	:= " CT1.CT1_ESTOUR ESTOUR, "             
		
		If CtbExDtFim("CT1") 
			cDtExsf+= "     CT1_DTEXSF CT1DTEXSF, " 
		EndIf

		
		cOrder := SqlOrder(indexKey())
		cContaEnt := "cContaEnt"   		
	
		cQuery := "SELECT DISTINCT ARQ."+cAlias+"_FILIAL FILIAL, ARQ."+cAlias+"_CONTA CONTA, "
		cQuery += "CT1.CT1_RES CTARES, CT1.CT1_BOOK CTBOOK, CT1.CT1_CTASUP CTASUP, CT1.CT1_CLASSE CTACLASSE, CT1.CT1_NORMAL CTANORMAL, CT1.CT1_GRUPO CTAGRUPO, "		  
		cQuery += "CT1.CT1_DESC" + cMoeda+ " DESCCTA, "   		
		cQuery += cDtExsf		
		cQuery += cEstour
		cQuery += cSelect
		cQuery += "FROM " + RetSqlName(cAlias)+" ARQ ,"
		cQuery += " " + RetSqlName(cCadAlias)+" CAD ,"
		cQuery += " " + RetSqlName("CT1")+" CT1 "
		cQuery += "WHERE CT1_CLASSE = '2' AND ARQ."+cAlias+"_FILIAL = '" + xFilial(cAlias) + "'" 
		cQuery += " AND ARQ."+cAlias+"_MOEDA ='"+cMoeda+"' " 
		cQuery += " AND (ARQ."+cAlias+"_CONTA = CT1.CT1_CONTA " 		
		cQuery += cCondCT1                                      
		cQuery += cCondEnt
		cQuery += cCondFil 				
		If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
			cQuery += " CT1.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' AND  "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
		Endif					
		cQuery += "ARQ."+cAlias+"_CONTA BETWEEN '" + cContaIni + "' AND '" + cContaFim + "' AND " 				
		cQuery += "ARQ."+cAlias+"_TPSALD ='"+cSaldos+"' AND "
		cQuery += "ARQ.D_E_L_E_T_ <> '*' "				
		cQuery += "ORDER BY "
		cQuery += cOrderBy		
		cQuery := ChangeQuery(cQuery)		   

		If ( Select ( "cContaEnt" ) <> 0 )
			dbSelectArea ( "cContaEnt" )
			dbCloseArea ()
		Endif            
		
	  	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cContaEnt,.T.,.F.)
		aStru := (cAlias)->(dbStruct())		
		
		If CtbExDtFim("CT1") 
			TCSetField(cContaEnt,"CT1DTEXSF","D",8,0)	
		EndIf         
		
		If cAlias == "CT3"
			If CtbExDtFim("CTT") 
				TCSetField(cContaEnt,"CTTDTEXSF","D",8,0)	
			EndIf
		ElseIf cAlias == "CT4"		
			If CtbExDtFim("CTD") 
				TCSetField(cContaEnt,"CTDDTEXSF","D",8,0)	
			EndIf
		ElseIf cAlias == "CTI"
			If CtbExDtFim("CTH") 
				TCSetField(cContaEnt,"CTHDTEXSF","D",8,0)	
			EndIf
		EndIf 
		
		dbSelectArea(cContaEnt)
		If ValType(oMeter) == "O"		
			oMeter:SetTotal((cCadAlias)->(RecCount())+CT1->(RecCount()))
			oMeter:Set(0)
		EndIf
		While !Eof()						
	
			If !Empty(aSetOfBook[1])	
				If !(aSetOfBook[1] $ cContaEnt->CTBOOK)
				 	dbSelectArea(cContaEnt)
					dbSkip()
					Loop
				EndIf
			Endif                 			
			
			//Caso faca filtragem por segmento de item,verifico se esta dentro 
			//da solicitacao feita pelo usuario. 
			If !Empty(cSegmento)
				If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
					If  !(Substr(cContaEnt->CONTA,nPos,nDigitos) $ (cFiltSegm) ) 
						dbSelectArea(cContaEnt)
						dbSkip()
						Loop
					EndIf	
				Else
 					If Substr(cContaEnt->CONTA,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
						Substr(cContaEnt->CONTA,nPos,nDigitos) > Alltrim(cSegFim)
						dbSelectArea(cContaEnt)						
						dbSkip()
						Loop
					EndIf	
				Endif
			EndIf	

			//Caso faca filtragem por segmento gerencial,verifico se esta dentro 
			//da solicitacao feita pelo usuario. 
			If !Empty(cSegmentoG)
				If Empty(cSegIniG) .And. Empty(cSegFimG) .And. !Empty(cFiltSegmG)
					If  !(Substr(cContaEnt->CODENT,nPosG,nDigitosG) $ (cFiltSegmG) ) 
						dbSelectArea(cContaEnt)
						dbSkip()
						Loop
					EndIf	
				Else
 					If Substr(cContaEnt->CODENT,nPosG,nDigitosG) < Alltrim(cSegIniG) .Or. ;
						Substr(cContaEnt->CODENT,nPosG,nDigitosG) > Alltrim(cSegFimG)
						dbSelectArea(cContaEnt)						
						dbSkip()
						Loop
					EndIf	
				Endif
			EndIf	

			//Para calculo do saldo anterior em TopConnect, foi criada uma nova funcao
			//devido a criacao das querys.				        
			aSaldo	 := SldTopEnt(cAlias,cContaEnt->CODENT,cContaEnt->CONTA,;
						dDataIni,dDataFim,Val(cMoeda),cSaldos,lImpAntLp,dDataLp) 						            						

			nSaldoAntD 	:= aSaldo[7]
			nSaldoAntC 	:= aSaldo[8]
			nSldAnt		:= nSaldoAntC - nSaldoAntD
	
			nSaldoAtuD 	:= aSaldo[4]
			nSaldoAtuC 	:= aSaldo[5]             
			nSldAtu		:= nSaldoAtuC - nSaldoAtuD
	
			nSaldoDeb  	:= nSaldoAtuD - nSaldoAntD
			nSaldoCrd  	:= nSaldoAtuC - nSaldoAntC
			
		    If nDivide > 1
				nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)		
				nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
			EndIf
			
			nMovimento	:= nSaldoCrd-nSaldoDeb
			
			If !lVlrZerado .And. (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0) .And. ;
				(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
				dbSkip()
				Loop
			EndIf		
			
			If lVlrZerado .And. (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0 ) .And. ;
				(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
				
				If CtbExDtFim("CT1") 
					//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
					//relatorio for maior, nao ira imprimir a entidade. 
		 			If !Empty(cContaEnt->CT1DTEXSF) .And. (dtos(dDataIni) > DTOS(cContaEnt->CT1DTEXSF))  
						dbSelectArea(cContaEnt)
						dbSkip()
						Loop													
					EndIf
				EndIf				
	
				If CtbExDtFim(cCadAlias) 
		 			If !Empty(cContaEnt->&((cCadAlias)+"DTEXSF")) .And. (dtos(dDataIni) > DTOS(cContaEnt->&((cCadAlias)+"DTEXSF")))
						dbSelectArea(cContaEnt)
						dbSkip()
						Loop													
					EndIf			
				EndIf               
			EndIf   		
			
			
			dbSelectArea("cArqTmp")
			dbSetOrder(1)	
			If !MsSeek(cContaEnt->CODENT+cContaEnt->CONTA)
				dbAppend()
				Replace CONTA 		With cContaEnt->CONTA
				If Empty(DESCCTA)
					CT1->(MsSeek(xFilial("CT1") + cContaEnt->CONTA))
					Replace DESCCTA With CT1->CT1_DESC01
				Else
					Replace DESCCTA With cContaEnt->DESCCTA
				Endif				
 				Replace NORMAL    	With cContaEnt->CTANORMAL
 				Replace TIPOCONTA 	With cContaEnt->CTACLASSE
				Replace GRUPO		With cContaEnt->CTAGRUPO
				Replace CTARES		With cContaEnt->CTARES
				Replace SUPERIOR	With cContaEnt->CTASUP
				Replace ESTOUR 		With cContaEnt->ESTOUR
				If cAlias == 'CT3'
					Replace CUSTO		With cContaEnt->CODENT
					Replace CCRES		With cContaEnt->ENTRES
					Replace TIPOCC  	With cContaEnt->ENTCLASSE
					If Empty(DESCCC)
						CTT->(MsSeek(xFilial("CTT") + cContaEnt->CODENT))
						Replace DESCCC 	With CTT->CTT_DESC01
					Else
						Replace DESCCC  With cContaEnt->DESCENT
					Endif				
				ElseIf cAlias == 'CT4'
					Replace ITEM 		With cContaEnt->CODENT
					Replace ITEMRES		With cContaEnt->ENTRES
					Replace TIPOITEM	With cContaEnt->ENTCLASSE
					Replace DESCITEM	With cContaEnt->DESCENT
					If Empty(DESCITEM)
						CTD->(MsSeek(xFilial("CTD") + cContaEnt->CODENT))
						Replace DESCITEM With CTD->CTD_DESC01
					Else
						Replace DESCITEM With cContaEnt->DESCENT
					Endif				
				ElseIf cAlias == 'CTI'
					Replace CLVL 		With cContaEnt->CODENT
					Replace CLVLRES		With cContaEnt->ENTRES
					Replace TIPOCLVL	With cContaEnt->ENTCLASSE

					If Empty(DESCCLVL)
						CTH->(MsSeek(xFilial("CTH") + cContaEnt->CODENT))
						Replace DESCCLVL With CTH->CTH_DESC01
					Else
						Replace DESCCLVL With cContaEnt->DESCENT
					Endif				
				EndIf
			EndIf       
		    
			If nDivide > 1
				For nCont := 1 To Len(aSaldo)
					aSaldo[nCont] := Round(NoRound((aSaldo[nCont]/nDivide),3),2)
				Next nCont		
			EndIf	
						
			dbSelectArea("cArqTmp")
			dbSetOrder(1)
			Replace SALDOANT With aSaldo[6]
			Replace SALDOATU With aSaldo[1]			
			Replace  SALDODEB	With nSaldoDeb				// Saldo Debito
			Replace  SALDOCRD With nSaldoCrd				// Saldo Credito
			If !lNImpMov
				Replace MOVIMENTO With nSaldoCrd-nSaldoDeb
			Endif
           
			dbSelectArea(cContaEnt)
			dbSkip()
			If ValType(oMeter) == "O"			
				nMeter++
	    		oMeter:Set(nMeter)
	   		EndIf
		EndDo	
		
		If ( Select ( "cContaEnt" ) <> 0 )
			dbSelectArea ( "cContaEnt" )
			dbCloseArea ()
		Endif		
	Else
#ENDIF

	 //Se for As/400 ou se nao for Balancete Conta/Item e Balancete Conta/Cl.Valor
	 
	//Chama rotina para refazer os saldos basicos.Foi criado outra rotina porque 
	//nao tenho data inicial nem data final para passar como parametro.
	If !lAtSldBase
		Ct360RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cSaldos,,lAtSldBase)
	EndIf	
	  
	If cAlias == 'CT3'
		nOrder1 	:= 2
    	nOrder2		:= 4
		bCond1		:= {||(CTT->CTT_FILIAL == xFilial() .And.	CTT->CTT_CUSTO >= cEntidIni .And.CTT->CTT_CUSTO <= cEntidFim .And. CTT_CLASSE != '1')}
		bCond2		:= {||(CT3->CT3_CUSTO <= cEntidFim)}
		cCadAlias	:= "CTT"                             
		cCodEnt		:= "CUSTO"                                                        
		cCodEntRes	:= "CCRES"
		cCodTpEnt	:= "TIPOCC"
		cDescEntid	:= "DESCCC"
	Elseif cAlias == 'CT4'                                                                
		nOrder1 	:= 2
	    nOrder2		:= 4                                                             
   		bCond1		:= {||(CTD->CTD_FILIAL == xFilial() .And.	CTD->CTD_ITEM >= cEntidIni .And.CTD->CTD_ITEM <= cEntidFim .And. CTD_CLASSE != '1')}
		bCond2		:= {||(CT4->CT4_ITEM <= cEntidFim )}
		cCadAlias	:= "CTD"                             
		cCodEnt		:= "ITEM" 
		cCodEntRes	:= "ITEMRES"
		cCodTpEnt	:= "TIPOITEM"
		cCusIni		:= ""
		cCusFim		:= Replicate("Z",nTamCC)   
		cDescEntid	:= "DESCITEM"	
	ElseIf cAlias == 'CTI'
		nOrder1 	:= 2      
		nOrder2		:= 4
		bCond1		:= {||(CTH->CTH_FILIAL == xFilial() .And.	CTH->CTH_CLVL >= cEntidIni .And.CTH->CTH_CLVL <= cEntidFim .And. CTH_CLASSE != '1')}
		bCond2		:= {||(CTI->CTI_CLVL <= cEntidFim)}	
		cCadAlias	:= "CTH"                             
		cCodEnt		:= "CLVL"   
		cCodEntRes	:= "CLVLRES"
		cCodTpEnt	:= "TIPOCLVL"
		cDescEntid	:= "DESCCLVL"	
		cCusIni		:= ""
		cCusFim		:= Replicate("Z",nTamCC)   
		cItemIni	:= ""
		cItemFim	:= Replicate("Z",nTamItem)   
	Endif

	dbSelectArea(cCadAlias)
	dbSetOrder(nOrder1)

	// Posiciona no primeiro item analitico 
	MsSeek(xFilial()+"2"+cEntidIni,.T.)
	If ValType(oMeter) == "O"
		nMeter	:= 0
		oMeter:SetTotal((cCadAlias)->(RecCount())+CT1->(RecCount()))
		oMeter:Set(0)
	EndIf
	
	While !Eof() .And. Eval(bCond1)
		                                                            
		// Grava entidade analitica
		cEntid 	 := &(cCadAlias+"->"+cCadAlias+"_"+cCodEnt)
		cCodRes  := &(cCadAlias+"->"+cCadAlias+"_RES")	
		cTipoEnt := &(cCadAlias+"->"+cCadAlias+"_CLASSE")	                              
		cDescEnt := &(cCadAlias+"->"+cCadAlias+"_DESC"+cMoeda)	                      
		If Empty(cDescEnt)		// Caso nao preencher descricao da moeda selecionada
			cDescEnt := &(cCadAlias+"->"+cCadAlias+"_DESC01")
		Endif
	        
		// Caso tenha escolhido algum Set Of Book, verifico se a classe de valor pertence a esse set.
		If !Empty(aSetOfBook[1])
			If !(aSetOfBook[1] $ &(cCadAlias+"->"+cCadAlias+"_BOOK"))
				dbSkip()
				Loop
			EndIf
		EndIf		           

		//Caso faca filtragem por segmento da entidade gerencial,verifico se esta dentro 
		//da solicitacao feita pelo usuario. 
		If !Empty(cSegmentoG)
			If Empty(cSegIniG) .And. Empty(cSegFimG) .And. !Empty(cFiltSegmG)
				If  !(Substr(cEntid,nPosG,nDigitosG) $ (cFiltSegmG) ) 
					dbSkip()
					Loop	
				EndIf	
			Else
				If 	Substr(cEntid,nPosG,nDigitosG) < Alltrim(cSegIniG) .Or. ;
					Substr(cEntid,nPosG,nDigitosG) > Alltrim(cSegFimG)
					dbSkip()
					Loop
				EndIf	
			Endif
		EndIf

		dbSelectArea("CT1")
		dbSetOrder(1)
		MsSeek(xFilial() + cContaIni,.T.)
	
		While !Eof() .And. CT1_CONTA <= cContaFim
	
			//Caso faca filtragem por segmento de conta,verifico se esta dentro 
			//da solicitacao feita pelo usuario. 
			If !Empty(cSegmento)
				If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
					If  !(Substr(CT1_CONTA,nPos,nDigitos) $ (cFiltSegm) ) 
						dbSkip()
						Loop	
					EndIf	
				Else
					If 	Substr(CT1_CONTA,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
						Substr(CT1_CONTA,nPos,nDigitos) > Alltrim(cSegFim)
						dbSkip()
						Loop
					EndIf	
				Endif
			EndIf

			If CT1_CLASSE = "1"		// Conta sinteticas nao armazenam saldos
				DbSkip()
				Loop
			Endif
		
			// Caso tenha escolhido algum Set Of Book, verifico se a conta pertence a esse set.				
			If !Empty(aSetOfBook[1])
				If !(aSetOfBook[1] $ CT1->CT1_BOOK)
					dbSkip()
					Loop
				EndIf
			EndIf		           	
	
			cDesc := &("CT1->CT1_DESC"+cMoeda)
			If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
				cDesc := CT1->CT1_DESC01
			Endif			

			//Calculo dos saldos
			If cAlias == 'CT3'
				aSaldoAnt := SaldoCT3(	CT1->CT1_CONTA,cEntid,dDataIni,cMoeda,cSaldos,,;
										lImpAntLP,dDataLP)
				aSaldoAtu := SaldoCT3(	CT1->CT1_CONTA,cEntid,dDataFim,cMoeda,cSaldos,,;
										lImpAntLP,dDataLP)
			ElseIf cAlias == 'CT4'	   
				aSaldoAnt	 := SaldTotCT4(cEntid,cEntid,cCusIni,cCusFim,;
								CT1->CT1_CONTA,CT1->CT1_CONTA,dDataIni,cMoeda,cSaldos)
				aSaldoAtu	 := SaldtotCT4(cEntid,cEntid,cCusIni,cCusFim,;
								CT1->CT1_CONTA,CT1->CT1_CONTA,dDataFim,cMoeda,cSaldos)
			ElseIf cAlias == 'CTI'		
				aSaldoAnt := SaldTotCTI(cEntid,cEntid,cItemIni,cItemFim,cCusIni,cCusFim,;
								CT1->CT1_CONTA,CT1->CT1_CONTA,dDataIni,cMoeda,cSaldos)
				aSaldoAtu := SaldTotCTI(cEntid,cEntid,cItemIni,cItemFim,cCusIni,cCusFim,;
								CT1->CT1_CONTA,CT1->CT1_CONTA,dDataFim,cMoeda,cSaldos)
			Endif

			nSaldoAntD 	:= aSaldoAnt[7]
			nSaldoAntC 	:= aSaldoAnt[8]
			nSldAnt		:= nSaldoAntC - nSaldoAntD
	
			nSaldoAtuD 	:= aSaldoAtu[4]
			nSaldoAtuC 	:= aSaldoAtu[5]          
			nSldAtu		:= nSaldoAtuC - nSaldoAtuD
	
			nSaldoDeb  	:= nSaldoAtuD - nSaldoAntD
			nSaldoCrd  	:= nSaldoAtuC - nSaldoAntC     
		    If nDivide > 1
				nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)		
				nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
			EndIf
			
			nMovimento	:= nSaldoCrd-nSaldoDeb

			If !lVlrZerado .And. (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0) .And. ;
				(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
				dbSkip()
				Loop
			EndIf	

			If lVlrZerado .And. (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0 ) .And. ;
				(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
				
				If CtbExDtFim("CT1") 
					//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
					//relatorio for maior, nao ira imprimir a entidade. 
					If !CtbVlDtFim("CT1",dDataIni) 
						dbSelectArea("CT1")
						dbSkip()
						Loop													
					EndIf
				EndIf				
	
				If CtbExDtFim(cCadAlias) 
					If !CtbVlDtFim(cCadAlias,dDataIni) 
						dbSelectArea("CT1")
						dbSkip()
						Loop													
					EndIf			
				EndIf               
			EndIf   		
			
		
			dbSelectArea("cArqTmp")
			dbSetOrder(1)	
			If !MsSeek(cEntid+CT1->CT1_CONTA)
				dbAppend()
				Replace CONTA 		With CT1->CT1_CONTA
				Replace DESCCTA		With cDesc
 				Replace NORMAL    	With CT1->CT1_NORMAL
 				Replace TIPOCONTA 	With CT1->CT1_CLASSE
				Replace GRUPO		With CT1->CT1_GRUPO
				Replace CTARES      With CT1->CT1_RES
				Replace SUPERIOR    With CT1->CT1_CTASUP
				Replace ESTOUR 		With CT1->CT1_ESTOUR

				If cAlias == 'CT3'
					Replace CUSTO	With cEntid			
					Replace CCRES	With cCodRes
					Replace TIPOCC  With cTipoEnt
					Replace DESCCC	With cDescEnt
				ElseIf cAlias == 'CT4'
					Replace ITEM 	 With cEntid
					Replace ITEMRES  With cCodRes 
					Replace TIPOITEM With cTipoEnt
					Replace DESCITEM With cDescEnt
				ElseIf cAlias == 'CTI'
					Replace CLVL 	 With cEntid			
					Replace CLVLRES  With cCodRes
					Replace TIPOCLVL With cTipoEnt
					Replace DESCCLVL With cDescEnt
				Endif   
			Endif               
		
			If nDivide > 1
				For nCont := 1 To Len(aSaldoAnt)
					aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
				Next nCont
				For nCont := 1 To Len(aSaldoAtu)
					aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
				Next nCont	
			EndIf	
				
			dbSelectArea("cArqTmp")
			dbSetOrder(1)
			Replace SALDOANT With aSaldoAnt[6]
			Replace SALDOATU With aSaldoAtu[1]			// Saldo Atual
	
			Replace  SALDODEB With nSaldoDeb				// Saldo Debito
			Replace  SALDOCRD With nSaldoCrd				// Saldo Credito
			If !lNImpMov
				Replace MOVIMENTO With nSaldoCrd-nSaldoDeb
			Endif
			dbSelectArea("CT1")
			dbSkip()
			If ValType(oMeter) == "O"			
				nMeter++
			   	oMeter:Set(nMeter)					
			EndIf
		Enddo
	
	    dbSelectArea(cCadAlias)
    	dbSkip()
		If ValType(oMeter) == "O"    	
			nMeter++
   			oMeter:Set(nMeter)					    	
   		EndIf
	EndDo
	
#IFDEF TOP
	Endif
#ENDIF

// Grava contas sinteticas

Do Case
	Case cAlias == 'CT3'
		cCadastro 	:= "CTT"
		cSuperior	:= 'CTT_FILIAL + CTT_CCSUP'
		cCpoSup		:= 'CTT_CCSUP'
	Case cAlias == 'CT4'                        
		cCadastro 	:= "CTD"
		cSuperior	:= 'CTD_FILIAL + CTD_ITSUP'
		cCpoSup		:= 'CTD_ITSUP'
	Case cAlias == 'CTI'
		cCadastro 	:= "CTH"
		cSuperior	:= 'CTH_FILIAL + CTH_CLSUP'
		cCpoSup		:= 'CTH_CLSUP'
EndCase	

DbSelectArea(cCadastro)

If !Empty(cSuperior) .And. Empty(IndexKey(5))
	IndRegua(cCadastro, cIndice := (CriaTrab(, .F. )), cSuperior,,, STR0001)
	nIndex:=RetIndex(cCadastro)+1
	dbSelectArea(cCadastro)
	#IFNDEF TOP
		dbSetIndex(cIndice+OrdBagExt())	
	#ENDIF
Else
	nIndex := 5
Endif

dbSelectArea("cArqTmp")	
dbGoTop()  
If ValType(oMeter) == "O"
	nMeter	:= 0
	oMeter:SetTotal(cArqTmp->(RecCount()))
	oMeter:Set(0)	
EndIf
While!Eof()                                 
                                            
	nSaldoAnt:= SALDOANT
	nSaldoAtu:= SALDOATU
	nSaldoDeb:= SALDODEB
	nSaldoCrd:= SALDOCRD   
	nMovimento:= MOVIMENTO

	nRegTmp := Recno()      
	If cAlias == 'CT3' 
		cEntid 	 := cArqTmp->CUSTO
		cCodRes	 := cArqTmp->CCRES
		cTipoEnt := cArqTmp->TIPOCC
		cDescEnt := cArqTmp->DESCCC
	ElseIf cAlias == 'CT4'      	
		cEntid 	 := cArqTmp->ITEM
		cCodRes	 := cArqTmp->ITEMRES
		cTipoEnt := cArqTmp->TIPOITEM
		cDescEnt := cArqTmp->DESCITEM
	ElseIf cAlias == 'CTI'
		cEntid 	 := cArqTmp->CLVL
		cCodRes	 := cArqTmp->CLVLRES
		cTipoEnt := cArqTmp->TIPOCLVL
		cDescEnt := cArqTmp->DESCCLVL
	EndIf

	DbSelectArea(cCadastro)
	cEntidG := cEntid
	dbSetOrder(1)
	MsSeek(xFilial(cCadastro)+cEntidG)
		
	While !Eof() .And. &(cCadastro + "->" + cCadastro + "_FILIAL") == xFilial()
	
        nReg := cArqTmp->(Recno())
		dbSelectArea("CT1")	
		dbSetOrder(1)      
		cContaSup := cArqTmp->CONTA
		MsSeek(xFilial("CT1")+ cContaSup)
		
		If cEntid = cEntidG
			cContaSup := CT1->CT1_CTASUP
			MsSeek(xFilial("CT1")+ cContaSup)
		Endif
		
		While !Eof() .And. CT1->CT1_FILIAL == xFilial()
	
			cDesc := &("CT1->CT1_DESC"+cMoeda)
			If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
				cDesc := CT1->CT1_DESC01
			Endif
	
			cDescEnt := &(cCadastro + "->" + cCadastro + "_DESC"+cMoeda)
			If Empty(cDescEnt)		// Caso nao preencher descricao da moeda selecionada
				cDescEnt := &(cCadastro + "->" + cCadastro + "_DESC01")
			Endif
			cCodRes  := &(cCadastro + "->" + cCadastro + "_RES")
			cTipoEnt := &(cCadastro + "->" + cCadastro + "_CLASSE")
	
			dbSelectArea("cArqTmp")
			dbSetOrder(1)      
			If ! MsSeek(cEntidG+cContaSup)
				dbAppend()
				Replace CONTA		With cContaSup	
				Replace DESCCTA 	With cDesc
				Replace NORMAL   	With CT1->CT1_NORMAL
				Replace TIPOCONTA	With CT1->CT1_CLASSE
				Replace GRUPO		With CT1->CT1_GRUPO
				Replace CTARES		With CT1->CT1_RES
				Replace SUPERIOR	With CT1->CT1_CTASUP
				Replace ESTOUR 		With CT1->CT1_ESTOUR

				If cAlias == 'CT3'
					Replace CUSTO With cEntidG		 
					Replace CCRES With cCodRes
					Replace TIPOCC With cTipoEnt
					Replace DESCCC With cDescEnt
				ElseIf cAlias == 'CT4'
				    Replace ITEM With cEntidG
				    Replace ITEMRES With cCodRes
				    Replace TIPOITEM With cTipoEnt
				    Replace DESCITEM With cDescEnt
				ElseIf cAlias == 'CTI'
					Replace CLVL With cEntidG
					Replace CLVLRES With cCodRes  
					Replace TIPOCLVL With cTipoEnt
					Replace DESCCLVL WITH cDescEnt
				EndIf
			EndIf    
			
			Replace	 SALDOANT With SALDOANT + nSaldoAnt
			Replace  SALDOATU With SALDOATU + nSaldoAtu
			Replace  SALDODEB With SALDODEB + nSaldoDeb
			Replace  SALDOCRD With SALDOCRD + nSaldoCrd
			If !lNImpMov
				Replace MOVIMENTO With MOVIMENTO + nMovimento
			Endif
	   		
			dbSelectArea("CT1")
			cContaSup := CT1->CT1_CTASUP
			If Empty(CT1->CT1_CTASUP) .And. Empty(&(cCadastro + "->" + cCpoSup))
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea("CT1")
				Exit
			EndIf
	
			dbSelectArea("cArqTmp")
			dbGoto(nRegTmp)
			dbSelectArea("CT1")
			cContaSup := CT1->CT1_CTASUP
			If Empty(cContaSup) .And. Empty(&(cCadastro + "->" + cCpoSup))
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea("CT1")
			EndIf		
			MsSeek(xFilial("CT1")+ cContaSup)
		EndDo
		dbSelectArea("cArqTmp")
		dbGoto(nReg)
		DbSelectArea(cCadastro)
		cEntidG := &cCpoSup
		If Empty(cEntidG)		// Ultimo Nivel gerencial
			Exit
		EndIf
		MsSeek(xFilial(cCadastro)+cEntidG)
	EndDo
	dbSelectArea("cArqTmp")
	dbGoto(nRegTmp)
	dbSkip()
	If ValType(oMeter) == "O"	
		nMeter++	
   		oMeter:Set(nMeter)					
  	EndIf
EndDo

If ! Empty(cIndice)
	dbSelectArea(cCadastro)
	dbClearFil()
	RetIndex(cCadastro)
	dbSetOrder(1)
   	Ferase(cIndice + OrdBagExt()) 
Endif

RestArea(aSaveArea)

Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SldTopEnt ³ Autor ³ Simone Mie Sato       ³ Data ³ 28/11/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Query para retornar o movimento numa determinada data.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ SldTopEnt - Entidade/Conta								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Array         											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function SldTopEnt(cAlias,cEntid,cConta,dDataIni,dDataFim,nMoeda,cTpsald,lImpAntLp,dDataLP)

Local aSaveArea		:= (cAlias)->(GetArea())
Local aSaveAnt		:= GetArea()
Local nDebito		:= 0					// Valor Debito na Data
Local nCredito 		:= 0					// Valor Credito na Data
Local nAtuDeb  		:= 0					// Saldo Atual Devedor
Local nAtuCrd		:= 0					// Saldo Atual Credor
Local nAntDeb		:= 0					// Saldo Anterior Devedor
Local nAntCrd		:= 0					// Saldo Anterior Credor
Local nSaldoAnt		:= 0					// Saldo Anterior (com sinal)
Local nSaldoAtu		:= 0					// Saldo Atual (com sinal)


#IFDEF TOP 
	Local cCond			:= ""
	Local cCondLP		:= ""
	Local cGroup		:= ""  
	Local cTopAnt   	:= ""
	Local cTopMov   	:= ""
	Local cQueryAnt		:= ""                                   
	Local cQueryMov		:= ""
	Local cSelect		:= ""	
	Local ni			:= 0 	
#ENDIF

cTpSald := Iif(Empty(cTpSald),"1",cTpSald)
cMoeda := StrZero(nMoeda,2)

DEFAULT lImpAntLp	:= .F.
DEFAULT dDataLP		:= CTOD("  /  /  ")

#IFDEF TOP 
	If TcSrvType() != "AS/400" 
	
		If cAlias == 'CT3'
			cSelect	:= " ARQ.CT3_CUSTO CUSTO, "		
			cCond	:= " ARQ.CT3_CUSTO = '"+cEntid+"' AND "
			cGroup	:= " CT3_FILIAL,CT3_CUSTO, CT3_CONTA, CT3_MOEDA, CT3_TPSALD"
		ElseIf cAlias == 'CT4'
			cSelect	:= " ARQ.CT4_ITEM ITEM, "		
			cCond	:= " ARQ.CT4_ITEM = '"+cEntid+"' AND "
			cGroup	:= " CT4_FILIAL,CT4_ITEM, CT4_CONTA, CT4_MOEDA, CT4_TPSALD"
		ElseIf cAlias == 'CTI'
			cSelect	:= " ARQ.CTI_CLVL CLVL, "				
			cCond	:= " ARQ.CTI_CLVL = '"+cEntid+"' AND "
			cGroup 	:= " CTI_FILIAL, CTI_CLVL, CTI_CONTA, CTI_MOEDA, CTI_TPSALD"
		EndIf       
		
		If lImpAntLP
			  cCondLP	:= " (ARQ."+cAlias+"_LP <> 'Z'  OR  "
			  cCondLP	+= " (ARQ."+cAlias+"_LP = 'Z' AND ARQ."+cAlias+"_DATA < '"+dtos(dDataLP)+ "')) AND "
		EndIf		
	
//Query para Saldo anterior		
		cTopAnt	  := "cTopAnt"		
		cQueryAnt := "SELECT ARQ."+cAlias+"_FILIAL FILIAL, ARQ."+cAlias+"_CONTA CONTA, ARQ."+cAlias+"_MOEDA MOEDA, ARQ."+cAlias+"_TPSALD TPSALD, "
		cQueryAnt += cSelect
		cQueryAnt += "	SUM("+cAlias+"_DEBITO) DEBITO, SUM("+cAlias+"_CREDIT) CREDITO "
		cQueryAnt += "FROM "+RetSqlName(cAlias) +" ARQ "
		cQueryAnt += "WHERE ARQ."+cAlias+"_FILIAL = '"+ xFilial(cAlias)+" ' AND "
		cQueryAnt += cCond
		cQueryAnt += cCondLP		
		cQueryAnt += "ARQ."+cAlias+"_CONTA = '"+cConta+"' "  
		cQueryAnt += " AND ARQ."+cAlias+"_DATA < '" + DTOS(dDataIni) + "' "
		cQueryAnt += " AND ARQ."+cAlias+"_MOEDA = '" + cMoeda +"' "
		cQueryAnt += " AND ARQ."+cAlias+"_TPSALD = '" + cTpSald +"' "
		cQueryAnt += " AND D_E_L_E_T_ <> '*' " 
		cQueryAnt += " GROUP BY "
		cQueryAnt += cGroup  
		cQueryAnt := ChangeQuery(cQueryAnt)		   
		
		If ( Select ( "cTopAnt" ) <> 0 )
			dbSelectArea ( "cTopAnt" )
			dbCloseArea ()
		Endif

	  	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryAnt),cTopAnt,.T.,.F.)
 		aStru := (cAlias)->(dbStruct())
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				If Subs(aStru[ni,1],5,6) == "DEBITO"								
					TCSetField(cTopAnt,"DEBITO", aStru[ni,2],aStru[ni,3],aStru[ni,4])				
				ElseIf Subs(aStru[ni,1],5,6) == "CREDIT"								
					TCSetField(cTopAnt,"CREDITO", aStru[ni,2],aStru[ni,3],aStru[ni,4])				
				EndIf
			Endif
		Next ni	  		  	
		
		While !Eof()
			nAntDeb    += (cTopAnt)->DEBITO
			nAntCrd	   += (cTopAnt)->CREDITO
			dbSkip()
		End
		
		If ( Select ( "cTopAnt" ) <> 0 )
			dbSelectArea ( "cTopAnt" )
			dbCloseArea ()
		Endif			

		//Query para Movimento do Periodo solicitado		
		cTopMov:= "cTopMov"		
		cQueryMov := "SELECT ARQ."+cAlias+"_FILIAL FILIAL, ARQ."+cAlias+"_CONTA CONTA, ARQ."+cAlias+"_MOEDA MOEDA, ARQ."+cAlias+"_TPSALD TPSALD, "
		cQueryMov += cSelect
		cQueryMov += "	SUM("+cAlias+"_DEBITO) DEBITO, SUM("+cAlias+"_CREDIT) CREDITO "
		cQueryMov += "FROM "+RetSqlName(cAlias) +" ARQ "
		cQueryMov += "WHERE ARQ."+cAlias+"_FILIAL = '"+ xFilial(cAlias)+" ' AND "
		cQueryMov += cCond
		cQueryMov += cCondLP
		cQueryMov += " ARQ."+cAlias+"_CONTA = '"+cConta+"' "  
		cQueryMov += " AND ARQ."+cAlias+"_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
		cQueryMov += " AND ARQ."+cAlias+"_MOEDA = '" + cMoeda +"' "
		cQueryMov += " AND ARQ."+cAlias+"_TPSALD = '" + cTpSald +"' "
		cQueryMov += " AND D_E_L_E_T_ <> '*' " 
		cQueryMov += " GROUP BY "
		cQueryMov += cGroup  
		cQueryMov := ChangeQuery(cQueryMov)		   
		
		If ( Select ( "cTopMov" ) <> 0 )
			dbSelectArea ( "cTopMov" )
			dbCloseArea ()
		Endif

	  	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryMov),cTopMov,.T.,.F.)
 		aStru := (cAlias)->(dbStruct())
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				If Subs(aStru[ni,1],5,6) == "DEBITO"								
					TCSetField(cTopMov,"DEBITO", aStru[ni,2],aStru[ni,3],aStru[ni,4])				
				ElseIf Subs(aStru[ni,1],5,6) == "CREDIT"								
					TCSetField(cTopMov,"CREDITO", aStru[ni,2],aStru[ni,3],aStru[ni,4])				
				Endif				
			Endif
		Next ni	  		  	
		
		While !Eof()
			nDebito    += (cTopMov)->DEBITO
			nCredito   += (cTopMov)->CREDITO
			dbSkip()
		End
		
		If ( Select ( "cTopMov" ) <> 0 )
			dbSelectArea ( "cTopMov" )
			dbCloseArea ()
		Endif				
   
		nSaldoAnt	:= (nAntCrd - nAntDeb)
		nAtuDeb		:= (nAntDeb + nDebito)
		nAtuCrd	 	:= (nAntCrd + nCredito)
		nSaldoAtu 	:= (nAtuCrd - nAtuDeb)	
 
	EndIf   
#ENDIF 

(cAlias)->(RestArea(aSaveArea))
RestArea(aSaveAnt)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno:                                             ³
//³ [1] Saldo Atual (com sinal)                          ³
//³ [2] Debito na Data                                   ³
//³ [3] Credito na Data                                  ³
//³ [4] Saldo Atual Devedor                              ³
//³ [5] Saldo Atual Credor                               ³
//³ [6] Saldo Anterior (com sinal)                       ³
//³ [7] Saldo Anterior Devedor                           ³
//³ [8] Saldo Anterior Credor                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//      [1]       [2]     [3]      [4]     [5]     [6]       [7]     [8]
Return {nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt,nAntDeb,nAntCrd}

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SldTop2Ent³ Autor ³ Simone Mie Sato       ³ Data ³ 27/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Query para retornar o movimento numa determinada data.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ SldTop2Ent - 2 Entidades   				 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Array         											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function SldTop2Ent(cAlias,cHeader,cEntid1,cEntid2,dDataIni,dDataFim,nMoeda,cTpsald,lImpAntLP,dDataLP)

Local aSaveArea		:= (cAlias)->(GetArea())
Local aSaveAnt		:= GetArea()
Local nDebito		:= 0					// Valor Debito na Data
Local nCredito 		:= 0					// Valor Credito na Data
Local nAtuDeb  		:= 0					// Saldo Atual Devedor
Local nAtuCrd		:= 0					// Saldo Atual Credor
Local nAntDeb		:= 0					// Saldo Anterior Devedor
Local nAntCrd		:= 0					// Saldo Anterior Credor
Local nSaldoAnt		:= 0					// Saldo Anterior (com sinal)
Local nSaldoAtu		:= 0					// Saldo Atual (com sinal)

#IFDEF TOP 
	Local cCond			:= ""
	Local cCondLP		:= ""
	Local cGroup		:= ""  	
	Local cQueryAnt		:= ""                                   
	Local cQueryMov		:= ""	
	Local cSelect		:= ""	
	Local cTopAnt   	:= ""
	Local cTopMov   	:= ""	
	Local nI			:= 0 	
#ENDIF

DEFAULT lImpAntLP	:= .F.
DEFAULT dDataLP		:= CTOD("  /  /  ")


cTpSald := Iif(Empty(cTpSald),"1",cTpSald)
cMoeda := StrZero(nMoeda,2)

#IFDEF TOP 
	If TcSrvType() != "AS/400" 
	
		If cAlias == 'CTV'
			cSelect	:= " ARQ.CTV_CUSTO CUSTO, CTV_ITEM ITEM, "		
			If cHeader == 'CTT'
				cCond	:= " AND ARQ.CTV_CUSTO = '"+ cEntid1 +"' AND ARQ.CTV_ITEM = '"+cEntid2 +"' "						
			ElseIf cHeader == 'CTD'
				cCond	:= " AND ARQ.CTV_ITEM = '"+ cEntid1 +"' AND  ARQ.CTV_CUSTO = '"+cEntid2 +"' "			
			EndIf
			cGroup	:= " CTV_FILIAL,CTV_CUSTO, CTV_ITEM, CTV_MOEDA, CTV_TPSALD "
		ElseIf cAlias == 'CTW'
			cSelect	:= " ARQ.CTW_CUSTO CUSTO, CTW_CLVL CLVL, "		
			If cHeader == 'CTT'
				cCond	:= " AND ARQ.CTW_CUSTO = '"+ cEntid1 + "' AND ARQ.CTW_CLVL = '"+cEntid2+"' "			
			ElseIf cHeader == 'CTH'
				cCond	:= " AND ARQ.CTW_CLVL = '"+ cEntid1 + "' AND ARQ.CTW_CUSTO = '"+cEntid2+"' "						
			EndIf
			cGroup	:= " CTW_FILIAL,CTW_CUSTO, CTW_CLVL, CTW_MOEDA, CTW_TPSALD"
		ElseIf cAlias == 'CTX'
			cSelect	:= " ARQ.CTX_ITEM ITEM, CTX_CLVL CLVL, "				
			If cHeader == 'CTD'
				cCond	:= " AND ARQ.CTX_ITEM = '"+cEntid1+"' AND ARQ.CTX_CLVL = '"+cEntid2+"' "						
			ElseIf cHeader == 'CTH'
				cCond	:= " AND ARQ.CTX_CLVL = '"+cEntid1+"' AND ARQ.CTX_ITEM = '"+cEntid2+"' "									
			EndIf
			cGroup 	:= " CTX_FILIAL, CTX_ITEM, CTX_CLVL, CTX_MOEDA, CTX_TPSALD"
		EndIf
		
		If lImpAntLP
			  cCondLP	:= " AND (ARQ."+cAlias+"_LP <> 'Z'  OR  "
			  cCondLP	+= " (ARQ."+cAlias+"_LP = 'Z' AND ARQ."+cAlias+"_DATA < '"+dtos(dDataLP)+ "')) "
		EndIf		
		
	
//Query para Saldo anterior		
		cTopAnt	  := "cTopAnt"		
		cQueryAnt := "SELECT ARQ."+cAlias+"_FILIAL FILIAL,  ARQ."+cAlias+"_MOEDA MOEDA, ARQ."+cAlias+"_TPSALD TPSALD, "
		cQueryAnt += cSelect
		cQueryAnt += "	SUM("+cAlias+"_DEBITO) DEBITO, SUM("+cAlias+"_CREDIT) CREDITO "
		cQueryAnt += "FROM "+RetSqlName(cAlias) +" ARQ "
		cQueryAnt += "WHERE ARQ."+cAlias+"_FILIAL = '"+ xFilial(cAlias)+"' "
		cQueryAnt += cCondLP						
		cQueryAnt += cCond
		cQueryAnt += " AND ARQ."+cAlias+"_DATA < '" + DTOS(dDataIni) + "' "
		cQueryAnt += " AND ARQ."+cAlias+"_MOEDA = '" + cMoeda +"' "
		cQueryAnt += " AND ARQ."+cAlias+"_TPSALD = '" + cTpSald +"' "
		cQueryAnt += " AND D_E_L_E_T_ <> '*' " 
		cQueryAnt += " GROUP BY "
		cQueryAnt += cGroup  
		cQueryAnt := ChangeQuery(cQueryAnt)		   
		
		If ( Select ( "cTopAnt" ) <> 0 )
			dbSelectArea ( "cTopAnt" )
			dbCloseArea ()
		Endif

	  	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryAnt),cTopAnt,.T.,.F.)
 		aStru := (cAlias)->(dbStruct())
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				If Subs(aStru[ni,1],5,6) == "DEBITO"								
					TCSetField(cTopAnt,"DEBITO", aStru[ni,2],aStru[ni,3],aStru[ni,4])				
				ElseIf Subs(aStru[ni,1],5,6) == "CREDIT"								
					TCSetField(cTopAnt,"CREDITO", aStru[ni,2],aStru[ni,3],aStru[ni,4])				
				EndIf
			Endif
		Next ni	  		  	
		
		While !Eof()
			nAntDeb    += (cTopAnt)->DEBITO
			nAntCrd	   += (cTopAnt)->CREDITO
			dbSkip()
		End
		
		If ( Select ( "cTopAnt" ) <> 0 )
			dbSelectArea ( "cTopAnt" )
			dbCloseArea ()
		Endif			

		//Query para Movimento do Periodo solicitado		
		cTopMov:= "cTopMov"		
		cQueryMov := "SELECT ARQ."+cAlias+"_FILIAL FILIAL, ARQ."+cAlias+"_MOEDA MOEDA, ARQ."+cAlias+"_TPSALD TPSALD, "
		cQueryMov += cSelect
		cQueryMov += "	SUM("+cAlias+"_DEBITO) DEBITO, SUM("+cAlias+"_CREDIT) CREDITO "
		cQueryMov += "FROM "+RetSqlName(cAlias) +" ARQ "
		cQueryMov += "WHERE ARQ."+cAlias+"_FILIAL = '"+ xFilial(cAlias)+" '"
		cQueryMov += cCondLP				
		cQueryMov += cCond         
		cQueryMov += " AND ARQ."+cAlias+"_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
		cQueryMov += " AND ARQ."+cAlias+"_MOEDA = '" + cMoeda +"' "
		cQueryMov += " AND ARQ."+cAlias+"_TPSALD = '" + cTpSald +"' "
		cQueryMov += " AND D_E_L_E_T_ <> '*' " 
		cQueryMov += " GROUP BY "
		cQueryMov += cGroup  
		cQueryMov := ChangeQuery(cQueryMov)		   
		
		If ( Select ( "cTopMov" ) <> 0 )
			dbSelectArea ( "cTopMov" )
			dbCloseArea ()
		Endif

	  	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryMov),cTopMov,.T.,.F.)
 		aStru := (cAlias)->(dbStruct())
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				If Subs(aStru[ni,1],5,6) == "DEBITO"								
					TCSetField(cTopMov,"DEBITO", aStru[ni,2],aStru[ni,3],aStru[ni,4])				
				ElseIf Subs(aStru[ni,1],5,6) == "CREDIT"								
					TCSetField(cTopMov,"CREDITO", aStru[ni,2],aStru[ni,3],aStru[ni,4])				
				Endif				
			Endif
		Next ni	  		  	
		
		While !Eof()
			nDebito    += (cTopMov)->DEBITO
			nCredito   += (cTopMov)->CREDITO
			dbSkip()
		End
		
		If ( Select ( "cTopMov" ) <> 0 )
			dbSelectArea ( "cTopMov" )
			dbCloseArea ()
		Endif				
   
		nSaldoAnt	:= (nAntCrd - nAntDeb)
		nAtuDeb		:= (nAntDeb + nDebito)
		nAtuCrd	 	:= (nAntCrd + nCredito)
		nSaldoAtu 	:= (nAtuCrd - nAtuDeb)	
 
	EndIf   
#ENDIF 

(cAlias)->(RestArea(aSaveArea))
RestArea(aSaveAnt)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno:                                             ³
//³ [1] Saldo Atual (com sinal)                          ³
//³ [2] Debito na Data                                   ³
//³ [3] Credito na Data                                  ³
//³ [4] Saldo Atual Devedor                              ³
//³ [5] Saldo Atual Credor                               ³
//³ [6] Saldo Anterior (com sinal)                       ³
//³ [7] Saldo Anterior Devedor                           ³
//³ [8] Saldo Anterior Credor                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//      [1]       [2]     [3]      [4]     [5]     [6]       [7]     [8]
Return {nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt,nAntDeb,nAntCrd}


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SaldoCTU  ³ Autor ³ Simone Mie Sato       ³ Data ³ 03.12.01 			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Saldo Totalizador por Entidade.                             			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ SaldoCTU(cIdent,cCodigo,dData,cMoeda,cTpSald)                     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³{nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt,nAntDeb,nAntCrd}³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Identificador                                     		    ³±±
±±³          ³ ExpC2 = Codigo da Entidade totalizadora                   		    ³±±
±±³          ³ ExpD1 = Data                                              		    ³±±
±±³          ³ ExpC3 = Moeda                                             		    ³±±
±±³          ³ ExpC4 = Tipo de Saldo                                     		    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function SaldoCTU(cIdent,cCodigo,dData,cMoeda,cTpSald,cRotina,lImpAntLP,dDataLP,cFilEsp)

Local aSaveArea	:= CTU->(GetArea())
Local aSaveAnt	:= GetArea()
Local lNaoAchei	:= .F.
Local nDebito	:= 0					// Valor Debito na Data
Local nCredito 	:= 0					// Valor Credito na Data
Local nAtuDeb  	:= 0					// Saldo Atual Devedor
Local nAtuCrd	:= 0					// Saldo Atual Credor
Local nAntDeb	:= 0					// Saldo Anterior Devedor
Local nAntCrd	:= 0					// Saldo Anterior Credor
Local nSaldoAnt	:= 0					// Saldo Anterior (com sinal)
Local nSaldoAtu	:= 0					// Saldo Atual (com sinal)
Local bCondicao	:= {||.F.}
Local cChaveLP	:= ""
Local bCondLP	:= {||.F.}

cTpSald		:= Iif(Empty(cTpSald),"1",cTpSald)                   
dDataLp		:= Iif(dDataLP==Nil,CTOD("  /  /  "),dDataLP)              
cRotina		:= Iif(cRotina==Nil,"",cRotina)
lImpAntLP	:= Iif(lImpAntLP==Nil,.F.,lImpAntLP)

dbSelectArea("CTU")
dbSetOrder(1)
If cFilEsp == Nil
	MsSeek(xFilial()+cIdent+cMoeda+cTpSald+cCodigo+Dtos(dData),.T.)
	bCondicao := { || (	CTU->CTU_FILIAL == xFilial("CTU") .And.;
								CTU->CTU_IDENT == cIdent .And.;
								CTU->CTU_CODIGO == cCodigo .And.;
								CTU->CTU_MOEDA == cMoeda .And.;
								CTU->CTU_TPSALD == cTpSald .And.CTU->CTU_DATA <= dData) }	
	cChaveLP	:=  (xFilial("CTU")+"Z"+cIdent+cMoeda+cTpsald+cCodigo)														
	bCondLP	:= 	{ || (	CTU->CTU_FILIAL == xFilial("CTU") .And.;
								CTU->CTU_IDENT == cIdent .And.;
								CTU->CTU_CODIGO == cCodigo .And.;
								CTU->CTU_MOEDA == cMoeda .And.;
								CTU->CTU_TPSALD == cTpSald .And.;
								CTU->CTU_LP == "Z" .And.;
								dDataLp <= dData) }	
Else                                                                
	MsSeek(cFilEsp+cIdent+cMoeda+cTpSald+cCodigo+Dtos(dData),.T.)
	bCondicao := { || (	CTU->CTU_FILIAL == cFilEsp .And.;
								CTU->CTU_IDENT == cIdent .And.;
								CTU->CTU_CODIGO == cCodigo .And.;
								CTU->CTU_MOEDA == cMoeda .And.;
								CTU->CTU_TPSALD == cTpSald .And.CTU->CTU_DATA <= dData) }	
	cChaveLP	:=  (cFilEsp+"Z"+cIdent+cMoeda+cTpsald+cCodigo)														
	bCondLP	:= 	{ || (	CTU->CTU_FILIAL == cFilEsp .And.;
								CTU->CTU_IDENT == cIdent .And.;
								CTU->CTU_CODIGO == cCodigo .And.;
								CTU->CTU_MOEDA == cMoeda .And.;
								CTU->CTU_TPSALD == cTpSald .And.;
								CTU->CTU_LP == "Z" .And.;
								dDataLp <= dData) }	
Endif

If ! Eval(bCondicao)
	dbSkip(-1)
	lNaoAchei := .T.
Else	//Verificar se existe algum registro de zeramento na mesma data 
	dbSkip()
	If !Eval(bCondicao) //Se nao existir registro na mesma data, volto para o registro anterior. 
		dbSkip(-1)
	EndIf	
EndIf

If Eval(bCondicao)
	// Movimentacoes na data
	If CTU->CTU_DATA == dData
		nDebito		:= CTU->CTU_DEBITO
		nCredito	:= CTU->CTU_CREDITO
	Endif	
	nAtuDeb		:= CTU->CTU_ATUDEB
	nAtuCrd  	:= CTU->CTU_ATUCRD
	If lNaoAchei
		// Neste caso, como a data nao foi encontrada, considera-se como saldo anterior
		// o saldo atual do registro anterior! -> dbskip(-1)
		nAntDeb  := CTU->CTU_ATUDEB
		nAntCrd  := CTU->CTU_ATUCRD
	Else		
		nAntDeb  := CTU->CTU_ANTDEB
		nAntCrd  := CTU->CTU_ANTCRD
	Endif
	nSaldoAtu:= nAtuCrd - nAtuDeb
	nSaldoAnt:= nAntCrd - nAntDeb
EndIf

//Se considera saldo anterior a apurcao de lucros/perdas
If lImpAntLP
	dbSelectArea("CTU")
	dbSetOrder(4)
	If MsSeek(cChaveLP)				
		aSldLP	:= CtbSldLP("CTU",dDataLP,bCondLP,dData)		
		nAtuDeb	-= aSldLP[1]
		nAtuCrd	-= aSldLP[2]		
		nSaldoAtu := nAtuCrd - nAtuDeb
//		If lNaoAchei
			nAntDeb	-= aSldLP[1]
			nAntCrd -= aSldLP[2]    
			nSaldoAnt	:= nAntCrd - nAntDeb
//		EndIf
	EndIf
EndIf

CTU->(RestArea(aSaveArea))
RestArea(aSaveAnt)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno:                                             ³
//³ [1] Saldo Atual (com sinal)                          ³
//³ [2] Debito na Data                                   ³
//³ [3] Credito na Data                                  ³
//³ [4] Saldo Atual Devedor                              ³
//³ [5] Saldo Atual Credor                               ³
//³ [6] Saldo Anterior (com sinal)                       ³
//³ [7] Saldo Anterior Devedor                           ³
//³ [8] Saldo Anterior Credor                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//      [1]       [2]     [3]      [4]     [5]     [6]       [7]     [8]
Return {nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt,nAntDeb,nAntCrd}

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtEntComp ³ Autor ³ Simone Mie Sato       ³ Data ³ 03.12.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Balancetes Entidade1/Entidade2³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oMeter	  = Controle da regua                             ³±±
±±³          ³ oText 	  = Controle da regua                             ³±±
±±³          ³ oDlg  	  = Janela                                        ³±±
±±³          ³ lEnd  	  = Controle da regua -> finalizar                ³±±
±±³          ³ dDataIni   = Data Inicial de processamento                 ³±±
±±³          ³ dDataFinal = Data Final de processamento                   ³±±
±±³          ³ cEntidIni  = Codigo Entidade Inicial                       ³±±
±±³          ³ cEndtidFim = Codigo Entidade Final                         ³±±
±±³          ³ cMoeda     = Moeda		                                  ³±±
±±³          ³ cSaldos    = Tipos de Saldo a serem processados            ³±±
±±³          ³ aSetOfBook = Matriz de configuracao de livros              ³±±
±±³          ³ cSegmento  = Indica qual o segmento será filtrado          ³±±
±±³          ³ cSegIni    = Conteudo inicial do segmento                  ³±±
±±³          ³ cSegFim    = Conteudo Final do segmento                    ³±±
±±³          ³ cFiltSegm  = Indica se filtrara ou nao segmento            ³±±
±±³          ³ lNImpMov   = Indica se imprime ou nao a coluna movimento   ³±±
±±³          ³ cAlias     = Alias para regua       	                      ³±±
±±³          ³ cIdent     = Identificador do arquivo a ser processado     ³±±
±±³          ³ lCusto     = Considera Centro de Custo?                    ³±±
±±³          ³ lItem      = Considera Item Contabil?                      ³±±
±±³          ³ lCLVL      = Considera Classe de Valor?                    ³±±
±±³          ³ lAtSldBase = Indica se deve chamar rot atual. saldo basico ³±±
±±³          ³ lAtSldCmp  = Indica se deve chamar rot atua. saldo composto³±±
±±³          ³ nInicio    = Moeda Inicial (p/ atualizar saldo)            ³±±
±±³          ³ nFinal     = Moeda Final (p/ atualizar saldo)              ³±±
±±³          ³ cFilde     = Filial inicial (p/ atualizar saldo)           ³±±
±±³          ³ cFilAte    = Filial final (p/atualizar saldo)              ³±±
±±³          ³ lImpAntLP  = Imprime lancamentos Lucros e Perdas?          ³±±
±±³          ³ dDataLP    = Data ultimo Lucros e Perdas                   ³±±
±±³          ³ nDivide    = Divide valores (100,1000,1000000)             ³±±
±±³          ³ lVlrZerado = Grava ou nao valores zerados no arq temporario³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                       
Function CtEntComp(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cAlias,lCusto,lItem,lClvl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,;
				cFilAte,lImpAntLP,dDataLP,nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt)
				         
Local aSaveArea 	:= GetArea()
Local cMascara1 	:= ""
Local cMascara2		:= ""
Local nPos			:= 0
Local nDigitos		:= 0
Local cEntid1		:= ""	//Codigo da Entidade Principal
Local cEntid2   	:= "" 	//Codigo da Entidade do Corpo do Relatorio              
local nSaldoAnt 	:= 0
Local nSaldoDeb 	:= 0
Local nSaldoCrd 	:= 0
Local nSaldoAtu 	:= 0
Local nSaldoAntD	:= 0
Local nSaldoAntC	:= 0
Local nSaldoAtuD	:= 0
Local nSaldoAtuC	:= 0
Local nSldAnt		:= 0
Local nSldAtu		:= 0
Local nRegTmp   	:= 0
Local nMovimento	:= 0 
Local nOrder		:= 0
Local cChave		:= ""
Local bCond1		:= {||.F.}
Local bCond2		:= {||.F.}
Local cCadAlias1	:= ""	//Alias do Cadastro da Entidade Principal
Local cCadAlias2	:= ""	//Alias do Cadastro da Entidade que sera impressa no corpo.
Local cCodEnt1		:= ""	//Codigo da Entidade Principal
Local cCodEnt2		:= ""	//Codigo da Entidade que sera impressa no corpo do relat.
Local cDesc1		:= ""
Local cDesc2		:= ""
Local cDescEnt		:= ""
Local cDescEnt1		:= ""	//Descricao da Entidade Principal                           
Local cDescEnt2		:= ""	//Descricao da Entidade que sera impressa no corpo.                          
Local cCodSup1		:= ""	//Cod.Superior da Entidade Principal
Local cCodSup2		:= ""	//Cod.Superior da Entidade que sera impressa no corpo.
Local nRecno1		:= 0
Local nRecno2		:= 0
Local nCont			:= 0 
Local nTamDesc1		:= ""
Local nTamDesc2		:= ""
Local nTotal		:= 0 
Local cOrigem		:= ""
Local cMensagem		:= OemToAnsi(STR0016)+ OemToAnsi(STR0017)
Local dMinData		:= Ctod("")
Local aAtSldCmp		:= Array(6)		// Array com range para atualizacao de saldos compostos
Local nMeter		:= 0
#IFDEF TOP
	Local nMin			:= 0	
	Local nMax			:= 0
#ENDIF

lVlrZerado	:= Iif(lVlrZerado == Nil,.T.,lVlrZerado)
nDivide 	:= Iif(nDivide == Nil,1,nDivide)

If !lAtSldBase	//Se os saldos nao foram atualizados na dig. lancamentos 
					//Chama rotina de atualizacao de saldos basicos					
	#IFDEF TOP	
   		If TcSrvType() != "AS/400"                     						
			oProcess := MsNewProcess():New({|lEnd|	Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cSaldos,.T.,cFilDe,cFilAte,,,.T.,oProcess,nMin,nMax)},"","",.F.)
		Else
	#ENDIF
   		//Chama rotina de atualizacao de saldos basicos					
		oProcess := MsNewProcess():New({|lEnd|	Ct360RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cSaldos,oProcess,lAtSldBase)},"","",.F.)
	#IFDEF TOP	
		EndIf		
	#ENDIF
	oProcess:Activate()							
EndIf	


Do Case
Case cAlias == 'CTV'     
	cOrigem		:= 'CT4'	
	If cHeader == 'CTT'		//Se for C.Custo/Item
		nOrder 		:= 2
		cCadAlias1	:= 'CTT'
		cCadAlias2	:= 'CTD'
		cCodEnt1	:= 'CUSTO' 
		cCodEnt2	:=	'ITEM'
		cCodSup1	:= 'CCSUP'
		cCodSup2	:= 'ITSUP'		
		cMascara1	:= aSetOfBook[6]	//Mascara do Centro de Custo
		cMascara2	:= aSetOfBook[7]	//Mascara do Item
		nTamDesc1	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))		
		cDescEnt	:= "DESCCC"
		cFilEnt1 	:=	Iif(Empty(xFilial("CTT")),"C","E")		
		cFilEnt2 	:=	Iif(Empty(xFilial("CTD")),"C","E")				
	ElseIf cHeader == 'CTD' 	//Se for Item/C.Custo                              	
		nOrder 		:= 1	
		cCadAlias1	:= 'CTD'
		cCadAlias2	:= 'CTT'
		cCodEnt1	:= 'ITEM' 
		cCodEnt2	:= 'CUSTO'
		cCodSup1	:= 'ITSUP'
		cCodSup2	:= 'CCSUP'
		cMascara1	:= aSetOfBook[7]	//Mascara do Item	
		cMascara2	:= aSetOfBook[6]	//Mascara do Centro de Custo
		nTamDesc1	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))	
		cDescEnt	:= "DESCITEM"
		cFilEnt1 	:=	Iif(Empty(xFilial("CTD")),"C","E")				
		cFilEnt2 	:=	Iif(Empty(xFilial("CTT")),"C","E")		
	EndIf	

	//Verificar se tem algum saldo a ser atualizado do periodo das entidades
	Ct360Data(	cOrigem,,@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,;
				cMoeda,,, dDataFim, cEntidIni1, cEntidFim1, cEntidIni2, cEntidFim2,,,cFilAnt)
				
	aAtSldCmp[1] := cEntidIni1
	aAtSldCmp[2] := cEntidFim1
	aAtSldCmp[3] := cEntidIni2
	aAtSldCmp[4] := cEntidFim2

Case cAlias == 'CTW'	
	cOrigem		:= 'CTI'	
	If cHeader == 'CTH'//Se for Cl.Valor/C.Custo
		nOrder 		:= 1      
		cCadAlias1	:= 'CTH'	
		cCadAlias2	:= 'CTT'
		cCodEnt1	:= 'CLVL'  
		cCodEnt2	:= 'CUSTO'
		cCodSup1	:= 'CLSUP'
		cCodSup2	:= 'CCSUP'
		cMascara1	:= aSetOfBook[8]	//Mascara da Classe de Valor
		cMascara2	:= aSetOfBook[6]	//Mascara do Centro de Custo
		nTamDesc1	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))				
		cDescEnt	:= "DESCCLVL"		
		cFilEnt1 	:=	Iif(Empty(xFilial("CTH")),"C","E")				
		cFilEnt2 	:=	Iif(Empty(xFilial("CTT")),"C","E")				
	ElseIf cHeader == 'CTT'//Se for C.Custo/Cl.Valor
		nOrder 		:= 2      
		cCadAlias1	:= 'CTT'
		cCadAlias2	:= 'CTH'			
		cCodEnt1	:= 'CUSTO'  
		cCodEnt2	:= 'CLVL'
		cCodSup1  	:= 'CCSUP'
		cCodSup2	:= 'CLSUP'
		cMascara1	:= aSetOfBook[6]	//Mascara do Centro de Custo
		cMascara2	:= aSetOfBook[8]	//Mascara da Classe de Valor	
		nTamDesc1	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))		
		cDescEnt	:= "DESCCC"		
		cFilEnt1 	:=	Iif(Empty(xFilial("CTT")),"C","E")				
		cFilEnt2 	:=	Iif(Empty(xFilial("CTH")),"C","E")				
	EndIf

	//Verificar se tem algum saldo a ser atualizado do periodo das entidades
	Ct360Data(	cOrigem,,@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,;
				cMoeda,,, dDataFim, cEntidIni1, cEntidFim1,,, cEntidIni2, cEntidFim2,cFilAnt)

	aAtSldCmp[1] := cEntidIni1
	aAtSldCmp[2] := cEntidFim1
	aAtSldCmp[5] := cEntidIni2
	aAtSldCmp[6] := cEntidFim2
Case cAlias == 'CTX'   
	cOrigem		:= 'CTI'	 
	If cHeader == 'CTH'//Se for Cl.Valor/Item
		nOrder 		:= 2      
		cCadAlias1	:= 'CTH'
		cCadAlias2	:= 'CTD'
		cCodEnt1	:= 'CLVL'
		cCodEnt2	:= 'ITEM'
		cCodSup1	:= 'CLSUP'      
		cCodSup2	:= 'ITSUP'
		cMascara1	:= aSetOfBook[8]	//Mascara da Cl.Valor
		cMascara2	:= aSetOfBook[7]	//Mascara do Item Contab.
		nTamDesc1	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))				
		cDescEnt	:= "DESCCLVL"		
		cFilEnt1 	:=	Iif(Empty(xFilial("CTH")),"C","E")				
		cFilEnt2 	:=	Iif(Empty(xFilial("CTD")),"C","E")		
	ElseIf cHeader == 'CTD'//Se for Item/Cl.Valor
		nOrder		:= 1
		cCadAlias1	:= 'CTD'
		cCadAlias2	:= 'CTH'
		cCodEnt1	:=	'ITEM'
		cCodEnt2	:=	'CLVL'
		cCodSup1  	:=	'ITSUP'
		cCodSup2	:=	'CLSUP'
		cMascara1	:= aSetOfBook[7]	//Mascara do Item Contab.
		cMascara2	:= aSetOfBook[8]	//Mascara da Cl.Valor
		nTamDesc1	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))				
		cDescEnt	:= "DESCITEM"		
		cFilEnt1 	:=	Iif(Empty(xFilial("CTD")),"C","E")				
		cFilEnt2 	:=	Iif(Empty(xFilial("CTH")),"C","E")				
	EndIf

	//Verificar se tem algum saldo a ser atualizado do periodo das entidades
	Ct360Data(	cOrigem,,@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,;
				cMoeda,,, dDataFim,,, cEntidIni1, cEntidFim1, cEntidIni2, cEntidFim2,;
				cFilAnt)

	aAtSldCmp[3] := cEntidIni1
	aAtSldCmp[4] := cEntidFim1
	aAtSldCmp[5] := cEntidIni2
	aAtSldCmp[6] := cEntidFim2
EndCase

cChave 		:= xFilial(cAlias)+cMoeda+cSaldos+cEntidIni1+cEntidIni2+dtos(dDataIni)
bCond1		:= {||&(cCadAlias1+"->"+cCadAlias1+"_FILIAL") == xFilial(cCadAlias1) .And. &(cCadAlias1+"->"+cCadAlias1+"_"+cCodEnt1) >= cEntidIni1 .And. &(cCadAlias1+"->"+cCadAlias1+"_"+cCodEnt1) <= cEntidFim1 }
bCond2		:= {||&(cCadAlias2+"->"+cCadAlias2+"_FILIAL") == xFilial(cCadAlias2) .And. &(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2) >= cEntidIni2 .And. &(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2) <= cEntidFim2 }
If ValType(oMeter) == "O"
	oMeter:SetTotal((cAlias)->(RecCount()))
	oMeter:Set(0)
EndIf

//Se o parametro MV_SLDCOMP estiver com "S",isto e, se devera atualizar os saldos compost.
//na emissao dos relatorios, verifica se tem algum registro desatualizado e atualiza as
//tabelas de saldos compostos.

If lAtSldCmp .And. !Empty(dMinData)	//Se atualiza saldos compostos
	oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cSaldos,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,dDataFim,aAtSldCmp,cFilAnt)},"","",.F.)
	oProcess:Activate()	
Else		//Se nao atualiza os saldos compostos, somente da mensagem
	If !Empty(dMinData)
		MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
										//atraves da rotina de saldos compostos	
		Return
	EndIf    
EndIf

// Verifica Filtragem por Segmento da Entidade
If !Empty(cSegmento)
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cMascara2)
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascara2 
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == cSegmento
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	EndIf	
EndIf		

#IFDEF TOP                                              
	If TcSrvType() != "AS/400" .And. cAlias $ 'CTV/CTW/CTX'
		Do Case	
		Case cAlias == "CTV"   			//C.Custo x Item
			If cHeader == "CTT"
				cSelect		:= "ARQ.CTV_CUSTO ENTID1, ARQ.CTV_ITEM ENTID2, "
				cSelect		+= "CAD1.CTT_RES ENTRES1, CAD1.CTT_BOOK ENTBOOK1, "
				cSelect		+= "CAD1.CTT_CCSUP ENTSUP1, CAD1.CTT_CLASSE ENTCLASSE1, "
				If CtbExDtFim("CTT") 
					cSelect	+= "CAD1.CTT_DTEXSF CTTDTEXSF, "				
				EndIf
				cSelect		+= "CAD1.CTT_DESC" + cMoeda+ " DESCENT1, "   
				cSelect		+= "CAD2.CTD_RES ENTRES2, CAD2.CTD_BOOK ENTBOOK2, CAD2.CTD_ITSUP ENTSUP2, "
				If CtbExDtFim("CTD") 
					cSelect	+= "CAD2.CTD_DTEXSF CTDDTEXSF, "				
				EndIf
				cSelect		+= "CAD2.CTD_CLASSE ENTCLASSE2, CAD2.CTD_DESC"+cMoeda+" DESCENT2 "		  				
				cCondEnt1	:= " AND ARQ.CTV_CUSTO BETWEEN '" + cEntidIni1+ "' AND '" + cEntidFim1+ "' AND " 
				cCondEnt1	+= " (ARQ.CTV_CUSTO = CAD1.CTT_CUSTO  "
                cCondEnt2	:= " ARQ.CTV_ITEM BETWEEN '" + cEntidIni2+ "' AND '" + cEntidFim2+ "' AND " 
                cCondEnt2	+= " CAD2.CTD_CLASSE = '2' AND "
				cCondEnt2	+= " (ARQ.CTV_ITEM = CAD2.CTD_ITEM "
				cOrderBy	:= " ARQ.CTV_CUSTO, ARQ.CTV_ITEM"    			
			ElseIf cHeader == "CTD"
				cSelect		:= "ARQ.CTV_ITEM ENTID1, ARQ.CTV_CUSTO ENTID2, "
				cSelect		+= "CAD1.CTD_RES ENTRES1, CAD1.CTD_BOOK ENTBOOK1, CAD1.CTD_ITSUP ENTSUP1, "
				If CtbExDtFim("CTD") 
					cSelect	+= "CAD1.CTD_DTEXSF CTDDTEXSF, "				
				EndIf				
				cSelect		+= "CAD1.CTD_CLASSE ENTCLASSE1, CAD1.CTD_DESC"+cMoeda+" DESCENT1, "		   
				cSelect		+= "CAD2.CTT_RES ENTRES2, CAD2.CTT_BOOK ENTBOOK2, "				
				cSelect		+= "CAD2.CTT_CCSUP ENTSUP2, CAD2.CTT_CLASSE ENTCLASSE2, "
				If CtbExDtFim("CTT") 
					cSelect	+= "CAD2.CTT_DTEXSF CTTDTEXSF, "				
				EndIf				
				cSelect		+= "CAD2.CTT_DESC" + cMoeda+ " DESCENT2 "   								
                cCondEnt1	:= " AND ARQ.CTV_ITEM BETWEEN '" + cEntidIni1+ "' AND '" + cEntidFim1+ "' AND " 
				cCondEnt1	+= " (ARQ.CTV_ITEM = CAD1.CTD_ITEM "
				cCondEnt2	:= " ARQ.CTV_CUSTO BETWEEN '" + cEntidIni2+ "' AND '" + cEntidFim2+ "' AND " 
                cCondEnt2	+= " CAD2.CTT_CLASSE = '2' AND "								
				cCondEnt2	+= " (ARQ.CTV_CUSTO = CAD2.CTT_CUSTO  "			
				cOrderBy	:= " ARQ.CTV_ITEM, ARQ.CTV_CUSTO"    						
			EndIf
		Case cAlias == "CTW"	//Cl.Valor x C.custo
			If cHeader == "CTT"
				cSelect		:= "ARQ.CTW_CUSTO ENTID1, ARQ.CTW_CLVL ENTID2, "
				cSelect		+= "CAD1.CTT_RES ENTRES1, CAD1.CTT_BOOK ENTBOOK1, "
				cSelect		+= "CAD1.CTT_CCSUP ENTSUP1, CAD1.CTT_CLASSE ENTCLASSE1, "
				If CtbExDtFim("CTT") 
					cSelect	+= "CAD1.CTT_DTEXSF CTTDTEXSF, "				
				EndIf				
				cSelect		+= "CAD1.CTT_DESC" + cMoeda+ " DESCENT1, "   
				cSelect		+= "CAD2.CTH_RES ENTRES2, CAD2.CTH_BOOK ENTBOOK2, CAD2.CTH_CLSUP ENTSUP2, "
				If CtbExDtFim("CTH") 
					cSelect	+= "CAD2.CTH_DTEXSF CTHDTEXSF, "				
				EndIf
				cSelect		+= "CAD2.CTH_CLASSE ENTCLASSE2, CAD2.CTH_DESC"+cMoeda+" DESCENT2 "		  				
				cCondEnt1	:= " AND ARQ.CTW_CUSTO BETWEEN '" + cEntidIni1+ "' AND '" + cEntidFim1+ "' AND " 
				cCondEnt1	+= " (ARQ.CTW_CUSTO = CAD1.CTT_CUSTO  "
                cCondEnt2	:= " ARQ.CTW_CLVL BETWEEN '" + cEntidIni2+ "' AND '" + cEntidFim2+ "' AND " 
                cCondEnt2	+= " CAD2.CTH_CLASSE = '2' AND "
				cCondEnt2	+= " (ARQ.CTW_CLVL = CAD2.CTH_CLVL "
				cOrderBy	:= " ARQ.CTW_CUSTO, ARQ.CTW_CLVL"    			
			ElseIf cHeader == "CTH"
				cSelect		:= "ARQ.CTW_CLVL ENTID1, ARQ.CTW_CUSTO ENTID2, "
				cSelect		+= "CAD1.CTH_RES ENTRES1, CAD1.CTH_BOOK ENTBOOK1, CAD1.CTH_CLSUP ENTSUP1, "
				If CtbExDtFim("CTH") 
					cSelect	+= "CAD1.CTH_DTEXSF CTHDTEXSF, "				
				EndIf				
				cSelect		+= "CAD1.CTH_CLASSE ENTCLASSE1, CAD1.CTH_DESC"+cMoeda+" DESCENT1, "		  				
				cSelect		+= "CAD2.CTT_RES ENTRES2, CAD2.CTT_BOOK ENTBOOK2, "
				cSelect		+= "CAD2.CTT_CCSUP ENTSUP2, CAD2.CTT_CLASSE ENTCLASSE2, "
				If CtbExDtFim("CTT") 
					cSelect	+= "CAD2.CTT_DTEXSF CTTDTEXSF, "				
				EndIf				
				cSelect		+= "CAD2.CTT_DESC" + cMoeda+ " DESCENT2 "   
				cCondEnt1	:= " AND ARQ.CTW_CLVL BETWEEN '" + cEntidIni1+ "' AND '" + cEntidFim1+ "' AND " 
				cCondEnt1	+= " (ARQ.CTW_CLVL = CAD1.CTH_CLVL  "
                cCondEnt2	:= " ARQ.CTW_CUSTO BETWEEN '" + cEntidIni2+ "' AND '" + cEntidFim2+ "' AND " 
                cCondEnt2	+= " CAD2.CTT_CLASSE = '2' AND "
				cCondEnt2	+= " (ARQ.CTW_CUSTO = CAD2.CTT_CUSTO "
				cOrderBy	:= " ARQ.CTW_CLVL, ARQ.CTW_CUSTO"			
			EndIf
		Case cAlias == "CTX"	//Cl.Valor x Item		
			If cHeader == "CTD"
				cSelect		:= "ARQ.CTX_ITEM ENTID1, ARQ.CTX_CLVL ENTID2, "
				cSelect		+= "CAD1.CTD_RES ENTRES1, CAD1.CTD_BOOK ENTBOOK1, "
				cSelect		+= "CAD1.CTD_ITSUP ENTSUP1, CAD1.CTD_CLASSE ENTCLASSE1, "
				If CtbExDtFim("CTD") 
					cSelect	+= "CAD1.CTD_DTEXSF CTDDTEXSF, "				
				EndIf				
				cSelect		+= "CAD1.CTD_DESC" + cMoeda+ " DESCENT1, "   
				cSelect		+= "CAD2.CTH_RES ENTRES2, CAD2.CTH_BOOK ENTBOOK2, CAD2.CTH_CLSUP ENTSUP2, "
				If CtbExDtFim("CTH") 
					cSelect	+= "CAD2.CTH_DTEXSF CTHDTEXSF, "				
				EndIf				
				cSelect		+= "CAD2.CTH_CLASSE ENTCLASSE2, CAD2.CTH_DESC"+cMoeda+" DESCENT2 "		  				
				cCondEnt1	:= " AND ARQ.CTX_ITEM BETWEEN '" + cEntidIni1+ "' AND '" + cEntidFim1+ "' AND " 
				cCondEnt1	+= " (ARQ.CTX_ITEM = CAD1.CTD_ITEM "
                cCondEnt2	:= " ARQ.CTX_CLVL BETWEEN '" + cEntidIni2+ "' AND '" + cEntidFim2+ "' AND " 
                cCondEnt2	+= " CAD2.CTH_CLASSE = '2' AND "
				cCondEnt2	+= " (ARQ.CTX_CLVL = CAD2.CTH_CLVL "
				cOrderBy	:= " ARQ.CTX_ITEM, ARQ.CTX_CLVL"    			
			ElseIf cHeader == "CTH"
				cSelect		:= "ARQ.CTX_CLVL ENTID1, ARQ.CTX_ITEM ENTID2, "
				cSelect		+= "CAD1.CTH_RES ENTRES1, CAD1.CTH_BOOK ENTBOOK1, CAD1.CTH_CLSUP ENTSUP1, "
				If CtbExDtFim("CTH") 
					cSelect	+= "CAD1.CTH_DTEXSF CTHDTEXSF, "				
				EndIf				
				cSelect		+= "CAD1.CTH_CLASSE ENTCLASSE1, CAD1.CTH_DESC"+cMoeda+" DESCENT1, "		  				
				cSelect		+= "CAD2.CTD_RES ENTRES2, CAD2.CTD_BOOK ENTBOOK2, "
				cSelect		+= "CAD2.CTD_ITSUP ENTSUP2, CAD2.CTD_CLASSE ENTCLASSE2, "
				If CtbExDtFim("CTD") 
					cSelect	+= "CAD2.CTD_DTEXSF CTDDTEXSF, "				
				EndIf				
				cSelect		+= "CAD2.CTD_DESC" + cMoeda+ " DESCENT2 "   
				cCondEnt1	:= " AND ARQ.CTX_CLVL BETWEEN '" + cEntidIni1+ "' AND '" + cEntidFim1+ "' AND " 
				cCondEnt1	+= " (ARQ.CTX_CLVL = CAD1.CTH_CLVL  "
                cCondEnt2	:= " ARQ.CTX_ITEM BETWEEN '" + cEntidIni2+ "' AND '" + cEntidFim2+ "' AND " 
                cCondEnt2	+= " CAD2.CTD_CLASSE = '2' AND "
				cCondEnt2	+= " (ARQ.CTX_ITEM = CAD2.CTD_ITEM "
				cOrderBy	:= " ARQ.CTX_CLVL, ARQ.CTX_ITEM"			
			EndIf
		EndCase


		If cFilEnt1 == "E"		//Se for Exclusivo
			cCondFil1 := " AND CAD1."+cCadAlias1+"_FILIAL = '" + xFilial(cCadAlias1) +"' ) AND "
		Else                                                  
			cCondFil1 := " ) AND " 
		EndIf			
		
		If cFilEnt2 == "E"		//Se for Exclusivo
			cCondFil2 := " AND CAD2."+cCadAlias2+"_FILIAL = '" + xFilial(cCadAlias2) +"' ) AND "
		Else                                                  
			cCondFil2 := " ) AND " 
		EndIf			

		cCtEntComp	:= "cCtEntComp"   		
	
		cQuery := "SELECT DISTINCT ARQ."+cAlias+"_FILIAL FILIAL, "
		cQuery += cSelect
		cQuery += "FROM " + RetSqlName(cAlias)+" ARQ ,"
		cQuery += " " + RetSqlName(cCadAlias1)+" CAD1 ,"
		cQuery += " " + RetSqlName(cCadAlias2)+" CAD2 "
		cQuery += "WHERE ARQ."+cAlias+"_FILIAL = '" + xFilial(cAlias)+"' "
		cQuery += " AND ARQ."+cAlias+"_MOEDA ='"+cMoeda+"' " 
		cQuery += " AND ARQ."+cAlias+"_TPSALD = '"+cSaldos+"' "
		cQuery += cCondEnt1		
		cQuery += cCondFil1
		cQuery += cCondEnt2		
		cQuery += cCondFil2
		cQuery += "ARQ.D_E_L_E_T_ <> '*' "				
		cQuery += "ORDER BY "
		cQuery += cOrderBy		
		cQuery := ChangeQuery(cQuery)		   

		If ( Select ( "cCtEntComp" ) <> 0 )
			dbSelectArea ( "cCtEntComp" )
			dbCloseArea ()
		Endif                                                               
		
	  	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCtEntComp,.T.,.F.)
	  	
	  	
		If cAlias $ "CTV/CTW"
			If CtbExDtFim("CTT") 
				TCSetField(cCtEntComp,"CTTDTEXSF","D",8,0)	
			EndIf
		EndIf
		If cAlias $ "CTV/CTX"		
			If CtbExDtFim("CTD") 
				TCSetField(cCtEntComp,"CTDDTEXSF","D",8,0)	
			EndIf
		EndIf
		If cAlias $ "CTW/CTX"
			If CtbExDtFim("CTH") 
				TCSetField(cCtEntComp,"CTHDTEXSF","D",8,0)	
			EndIf
		EndIf 
	  	
		aStru := (cAlias)->(dbStruct())		
		
		dbSelectArea(cCtEntComp)
		While !Eof()						
	
			If !Empty(aSetOfBook[1])	
				If !(aSetOfBook[1] $ cCtEntComp->ENTBOOK2)
				 	dbSelectArea(cCtEntComp)
					dbSkip()
					Loop
				EndIf
			Endif                 
			
			//Caso faca filtragem por segmento de item,verifico se esta dentro 
			//da solicitacao feita pelo usuario. 
			If !Empty(cSegmento)
				If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
					If  !(Substr(cCtEntComp->ENTID2,nPos,nDigitos) $ (cFiltSegm) ) 
						dbSelectArea(cCtEntComp)
						dbSkip()
						Loop
					EndIf	
				Else
 					If Substr(cCtEntComp->ENTID2,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
						Substr(cCtEntComp->ENTID2,nPos,nDigitos) > Alltrim(cSegFim)
						dbSelectArea(cCtEntComp)						
						dbSkip()
						Loop
					EndIf	
				Endif
			EndIf	

			//Para calculo do saldo anterior em TopConnect, foi criada uma nova funcao
			//devido a criacao das querys.				        
			aSaldo	:= 	SldTop2Ent(cAlias,cHeader,cCtEntComp->ENTID1,cCtEntComp->ENTID2,;
						dDataIni,dDataFim,Val(cMoeda),cSaldos,lImpAntLP,dDataLP)
						
			nSaldoAntD 	:= aSaldo[7]
			nSaldoAntC 	:= aSaldo[8]               
			nSldAnt		:= nSaldoAntC - nSaldoAntD
	
			nSaldoAtuD 	:= aSaldo[4]
			nSaldoAtuC 	:= aSaldo[5]             
			nSldAtu		:= nSaldoAtuC - nSaldoAtuD
	
			nSaldoDeb  	:= nSaldoAtuD - nSaldoAntD
			nSaldoCrd  	:= nSaldoAtuC - nSaldoAntC
		    If nDivide > 1
				nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)		
				nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
			EndIf
			
			nMovimento	:= nSaldoCrd-nSaldoDeb
			
			If !lVlrZerado .And. (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0)  .And. ;
				(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
				dbSkip()
				Loop
			EndIf		          
			
			If lVlrZerado .And. (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0)  .And. ;
				(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
				
				If CtbExDtFim(cCadAlias1) 
		 			If !Empty(cCtEntComp->&((cCadAlias1)+"DTEXSF")) .And. (dtos(dDataIni) > DTOS(cCtEntComp->&((cCadAlias1)+"DTEXSF")))
						dbSelectArea(cCtEntComp)
						dbSkip()
						Loop													
					EndIf			
				EndIf               
				
				If CtbExDtFim(cCadAlias2) 
		 			If !Empty(cCtEntComp->&((cCadAlias2)+"DTEXSF")) .And. (dtos(dDataIni) > DTOS(cCtEntComp->&((cCadAlias2)+"DTEXSF")))
						dbSelectArea(cCtEntComp)
						dbSkip()
						Loop													
					EndIf			
				EndIf               
			EndIf			
			
			dbSelectArea("cArqTmp")
			dbSetOrder(1)	
			If !MsSeek(cCtEntComp->ENTID1+cCtEntComp->ENTID2)
				dbAppend()
				Do Case
				Case cAlias == 'CTV'      
					If cHeader	== 'CTT'	//Se for Centro de Custo/Item
						Replace CUSTO   	With cCtEntComp->ENTID1
						Replace DESCCC		With cCtEntComp->DESCENT1
						Replace TIPOCC 		With cCtEntComp->ENTCLASSE1
						Replace CCSUP 		With cCtEntComp->ENTSUP1 
						Replace CCRES		With cCtEntComp->ENTRES1 
						Replace ITEM 		With cCtEntComp->ENTID2
						Replace DESCITEM	With cCtEntComp->DESCENT2
						Replace TIPOITEM 	With cCtEntComp->ENTCLASSE2
						Replace ITSUP  		With cCtEntComp->ENTSUP2 
						Replace ITEMRES		With cCtEntComp->ENTRES2 
					ElseIf cHeader == 'CTD'	//Se for Item/C.Custo
						Replace ITEM 		With cCtEntComp->ENTID1
						Replace DESCITEM	With cCtEntComp->DESCENT1
						Replace TIPOITEM 	With cCtEntComp->ENTCLASSE1
						Replace ITSUP  		With cCtEntComp->ENTSUP1 
						Replace ITEMRES		With cCtEntComp->ENTRES1 
						Replace CUSTO   	With cCtEntComp->ENTID2
						Replace DESCCC		With cCtEntComp->DESCENT2
						Replace TIPOCC 		With cCtEntComp->ENTCLASSE2
						Replace CCSUP 		With cCtEntComp->ENTSUP2 
						Replace CCRES		With cCtEntComp->ENTRES2
					EndIf			
				Case cAlias == 'CTW'
					If cHeader	== 'CTH'		//Se for Cl.Valor/C.Custo
						Replace CLVL    	With cCtEntComp->ENTID1
						Replace DESCCLVL	With cCtEntComp->DESCENT1
						Replace TIPOCLVL 	With cCtEntComp->ENTCLASSE1
						Replace CLSUP    	With cCtEntComp->ENTSUP1 
						Replace CLVLRES		With cCtEntComp->ENTRES1 
						Replace CUSTO   	With cCtEntComp->ENTID2
						Replace DESCCC		With cCtEntComp->DESCENT2
						Replace TIPOCC 		With cCtEntComp->ENTCLASSE2
						Replace CCSUP 		With cCtEntComp->ENTSUP2 
						Replace CCRES		With cCtEntComp->ENTRES2
					ElseIf cHeader	== 'CTT'	//Se for C.Custo/Cl.Valor
						Replace CUSTO   	With cCtEntComp->ENTID1
						Replace DESCCC		With cCtEntComp->DESCENT1
						Replace TIPOCC 		With cCtEntComp->ENTCLASSE1
						Replace CCSUP 		With cCtEntComp->ENTSUP1 
						Replace CCRES		With cCtEntComp->ENTRES1 
						Replace CLVL    	With cCtEntComp->ENTID2
						Replace DESCCLVL	With cCtEntComp->DESCENT2
						Replace TIPOCLVL 	With cCtEntComp->ENTCLASSE2
						Replace CLSUP    	With cCtEntComp->ENTSUP2 
						Replace CLVLRES		With cCtEntComp->ENTRES2
					EndIf
				Case cAlias == 'CTX'                   
					If cHeader == 'CTH'	//Se for Cl.Valor/Item
						Replace CLVL    	With cCtEntComp->ENTID1
						Replace DESCCLVL	With cCtEntComp->DESCENT1
						Replace TIPOCLVL 	With cCtEntComp->ENTCLASSE1
						Replace CLSUP    	With cCtEntComp->ENTSUP1 
						Replace CLVLRES		With cCtEntComp->ENTRES1 
						Replace ITEM		With cCtEntComp->ENTID2
						Replace DESCITEM	With cCtEntComp->DESCENT2
						Replace TIPOITEM 	With cCtEntComp->ENTCLASSE2
						Replace ITSUP  		With cCtEntComp->ENTSUP2 
						Replace ITEMRES		With cCtEntComp->ENTRES2
					ElseIf cHeader	== 'CTD'	//Se for Item/Cl.Valor
						Replace ITEM		With cCtEntComp->ENTID1
						Replace DESCITEM	With cCtEntComp->DESCENT1
						Replace TIPOITEM 	With cCtEntComp->ENTCLASSE1
						Replace ITSUP  		With cCtEntComp->ENTSUP1 
						Replace ITEMRES		With cCtEntComp->ENTRES1 
						Replace CLVL    	With cCtEntComp->ENTID2
						Replace DESCCLVL	With cCtEntComp->DESCENT2
						Replace TIPOCLVL 	With cCtEntComp->ENTCLASSE2
						Replace CLSUP    	With cCtEntComp->ENTSUP2 
						Replace CLVLRES		With cCtEntComp->ENTRES2
					Endif
				EndCase
			EndIf           
		
			If nDivide > 1
				For nCont := 1 To Len(aSaldo)
					aSaldo[nCont] := Round(NoRound((aSaldo[nCont]/nDivide),3),2)
				Next nCont		
			EndIf	
						
			dbSelectArea("cArqTmp")
			dbSetOrder(1)
			Replace SALDOANT With aSaldo[6]
			Replace SALDOATU With aSaldo[1]			
			Replace  SALDODEB	With nSaldoDeb				// Saldo Debito
			Replace  SALDOCRD With nSaldoCrd				// Saldo Credito
			If !lNImpMov
				Replace MOVIMENTO With nSaldoCrd-nSaldoDeb
			Endif
           
			dbSelectArea(cCtEntComp)
			dbSkip()
			If ValType(oMeter) == "O"			
				nMeter++
    			oMeter:Set(nMeter)
    		EndIf
		EndDo	
		
		If ( Select ( "cCtEntComp" ) <> 0 )
			dbSelectArea ( "cCtEntComp" )
			dbCloseArea ()
		Endif		
	Else
#ENDIF

	dbSelectarea(cCadAlias1)
	dbSetOrder(1)
	MsSeek(xFilial()+cEntidIni1,.T.)
                                                       
	While !Eof() .And. Eval(bCond1)	
		
		If &(cCadAlias1+"->"+cCadAlias1+"_CLASSE") <> '2'	//Se for sintetico
			dbSkip()
			Loop
		Endif
	
		//Verifico Set of Book da Entidade Principal	
		If !Empty(aSetOfBook[1])	
			If !(aSetOfBook[1] $ &(cCadAlias1+"->"+cCadAlias1+"_BOOK"))
				dbSkip()
				Loop
			EndIf
   		 EndIf
   	 
	    cDescEnt1	:= (cCadAlias1+"->"+cCadAlias1+"_DESC")
		cDesc1 		:= &(cDescEnt1+cMoeda)		
		If Empty(cDesc1)	// Caso nao preencher descricao da moeda selecionada
			cDesc1 	:= &(cDescEnt1+"01")
		Endif
		
		cEntid1		:= &(cCadAlias1+"->"+cCadAlias1+"_"+cCodent1)		
		nRecno1		:= Recno()	
		
		dbSelectArea(cCadAlias2)
		dbSetOrder(1)
	    MsSeek(xFilial()+cEntidIni2,.T.)
	
		While !Eof() .And. Eval(bCond2) 
	
			If &(cCadAlias2+"->"+cCadAlias2+"_CLASSE") <> '2'	//Se for sintetico
				dbSkip()
				Loop
			Endif
		                                
			//Verifico Set of Book da Entidade do Corpo do Relatorio	
			If !Empty(aSetOfBook[1])			
				If !(aSetOfBook[1] $ &(cCadAlias2+"->"+cCadAlias2+"_BOOK"))
					dbSkip()
					Loop
				EndIf
			EndIf

	   		//Caso faca filtragem por segmento de item,verifico se esta dentro 
			//da solicitacao feita pelo usuario. 
			If !Empty(cSegmento)
				If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
					If  !(Substr(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2),nPos,nDigitos) $ (cFiltSegm) ) 
						dbSkip()
						Loop
					EndIf	
				Else
					If Substr(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2),nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
						Substr(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2),nPos,nDigitos) > Alltrim(cSegFim)
						dbSkip()
						Loop
					EndIf	
				Endif
			EndIf	                                        
			
			cEntid2		:= &(cCadAlias2+"->"+cCadAlias2+"_"+cCodent2)	                               
			cDescEnt2	:= (cCadAlias2+"->"+cCadAlias2+"_DESC")
			cDesc2 		:= &(cDescEnt2+cMoeda)	                 		
			If Empty(cDesc2)	// Caso nao preencher descricao da moeda selecionada
				cDesc2 	:= &(cDescEnt2+"01")
			Endif
			
			nRecno2		:= Recno()    
	
			// Calculo dos saldos
			aSaldoAnt := SldCmpEnt(cEntid1,cEntid2,dDataIni,cMoeda,cSaldos,nOrder,cHeader,cAlias,cFiltroEnt,,lImpAntLP,dDataLP)
			aSaldoAtu := SldCmpEnt(cEntid1,cEntid2,dDataFim,cMoeda,cSaldos,nOrder,cHeader,cAlias,cFiltroEnt,,lImpAntLP,dDataLP)

		
			nSaldoAntD 	:= aSaldoAnt[7]
			nSaldoAntC 	:= aSaldoAnt[8]
			nSldAnt		:= nSaldoAntC - nSaldoAntD
		
			nSaldoAtuD 	:= aSaldoAtu[4]
			nSaldoAtuC 	:= aSaldoAtu[5]          
			nSldAtu		:= nSaldoAtuC- nSaldoAtuD
		
			nSaldoDeb  	:= nSaldoAtuD - nSaldoAntD
			nSaldoCrd  	:= nSaldoAtuC - nSaldoAntC
			
		    If nDivide > 1
				nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)		
				nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
			EndIf

			nMovimento	:= nSaldoCrd-nSaldoDeb

			If !lVlrZerado .And. (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0)  .And. ;
				(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
				dbSelectArea(cCadAlias2)
				dbSkip()
				Loop
			EndIf	
			
			If lVlrZerado .And. (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0)  .And. ;
				(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
				
				If CtbExDtFim(cCadAlias1) 
		 			If !Empty((cCadAlias1)->&(cCadAlias1+"_DTEXSF")) .And. (dtos(dDataIni) > DTOS((cCadAlias1)->&(cCadAlias1+"_DTEXSF")))
						dbSelectArea(cCadAlias2)
						dbSkip()
						Loop													
					EndIf			
				EndIf               
				
				If CtbExDtFim(cCadAlias2) 
//		 			If !Empty(cCadAlias2->&((cCadAlias2)+"_DTEXSF")) .And. (dtos(dDataIni) > DTOS(cCadAlias2->&((cCadAlias2)+"_DTEXSF")))
		 			If !Empty((cCadAlias2)->&(cCadAlias2+"_DTEXSF")) .And. (dtos(dDataIni) > DTOS((cCadAlias2)->&(cCadAlias2+"_DTEXSF")))
						dbSelectArea(cCadAlias2)
						dbSkip()
						Loop													
					EndIf			
				EndIf               
			EndIf			
					
			cSeek	:= cEntid1+cEntid2
			
			dbSelectArea("cArqTmp")
			dbSetOrder(1)	
			If !MsSeek(cSeek)
				dbAppend()   
				Do Case
				Case cAlias == 'CTV'      
					If cHeader	== 'CTT'	//Se for Centro de Custo/Item
						Replace CUSTO   	With cEntid1
						Replace DESCCC		With cDesc1
						Replace TIPOCC 		With CTT->CTT_CLASSE			
						Replace CCSUP 		With CTT->CTT_CCSUP	
						Replace CCRES		With CTT->CTT_RES	
						Replace ITEM 		With cEntid2
						Replace DESCITEM	With cDesc2
						Replace TIPOITEM 	With CTD->CTD_CLASSE
						Replace ITSUP  		With CTD->CTD_ITSUP		
						Replace ITEMRES		With CTD->CTD_RES			
					ElseIf cHeader == 'CTD'	//Se for Item/C.Custo
						Replace ITEM 		With cEntid1
						Replace DESCITEM	With cDesc1
						Replace TIPOITEM 	With CTD->CTD_CLASSE
						Replace ITSUP  		With CTD->CTD_ITSUP		
						Replace ITEMRES		With CTD->CTD_RES					
						Replace CUSTO   	With cEntid2
						Replace DESCCC		With cDesc2
						Replace TIPOCC 		With CTT->CTT_CLASSE			
						Replace CCSUP 		With CTT->CTT_CCSUP	
						Replace CCRES		With CTT->CTT_RES	
					EndIf			
				Case cAlias == 'CTW'
					If cHeader	== 'CTH'		//Se for Cl.Valor/C.Custo
						Replace CLVL    	With cEntid1
						Replace DESCCLVL	With cDesc1
						Replace TIPOCLVL 	With CTH->CTH_CLASSE
						Replace CLSUP    	With CTH->CTH_CLSUP
						Replace CLVLRES		With CTH->CTH_RES
						Replace CUSTO   	With cEntid2
						Replace DESCCC		With cDesc2
						Replace TIPOCC 		With CTT->CTT_CLASSE			
						Replace CCSUP 		With CTT->CTT_CCSUP	
						Replace CCRES		With CTT->CTT_RES				                        	
					ElseIf cHeader	== 'CTT'	//Se for C.Custo/Cl.Valor
						Replace CUSTO   	With cEntid1
						Replace DESCCC		With cDesc1
						Replace TIPOCC 		With CTT->CTT_CLASSE			
						Replace CCSUP 		With CTT->CTT_CCSUP	
						Replace CCRES		With CTT->CTT_RES				                        	
						Replace CLVL    	With cEntid2
						Replace DESCCLVL	With cDesc2
						Replace TIPOCLVL 	With CTH->CTH_CLASSE
						Replace CLSUP    	With CTH->CTH_CLSUP
						Replace CLVLRES		With CTH->CTH_RES			
					EndIf
				Case cAlias == 'CTX'                   
					If cHeader == 'CTH'	//Se for Cl.Valor/Item
						Replace CLVL    	With cEntid1
						Replace DESCCLVL	With cDesc1
						Replace TIPOCLVL 	With CTH->CTH_CLASSE
						Replace CLSUP    	With CTH->CTH_CLSUP
						Replace CLVLRES		With CTH->CTH_RES
						Replace ITEM		With cEntid2
						Replace DESCITEM	With cDesc2
						Replace TIPOITEM 	With CTD->CTD_CLASSE
						Replace ITSUP  		With CTD->CTD_ITSUP		
						Replace ITEMRES		With CTD->CTD_RES					
					ElseIf cHeader	== 'CTD'	//Se for Item/Cl.Valor
						Replace ITEM		With cEntid1
						Replace DESCITEM	With cDesc1
						Replace TIPOITEM 	With CTD->CTD_CLASSE
						Replace ITSUP  		With CTD->CTD_ITSUP		
						Replace ITEMRES		With CTD->CTD_RES					
						Replace CLVL    	With cEntid2
						Replace DESCCLVL	With cDesc2
						Replace TIPOCLVL 	With CTH->CTH_CLASSE
						Replace CLSUP    	With CTH->CTH_CLSUP
						Replace CLVLRES		With CTH->CTH_RES			
					Endif
				EndCase
			EndIf           
		
		    If nDivide > 1
				For nCont := 1 To Len(aSaldoAnt)
					aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
				Next nCont
				
				For nCont := 1 To Len(aSaldoAtu)
					aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
				Next nCont	
			EndIf	
			
			dbSelectArea("cArqTmp")
			dbSetOrder(1)
			Replace SALDOANT 	With aSaldoAnt[6]		// Saldo anterior
			Replace SALDOANTDB	With aSaldoAnt[7]		// Saldo anterior debito	
			Replace SALDOANTCR	With aSaldoAnt[8]		// Saldo anterior credito	
			Replace SALDOATU 	With aSaldoAtu[1]		// Saldo Atual           
			Replace SALDOATUDB	With aSaldoatu[4]		// Saldo Atual debito
			Replace SALDOATUCR	With aSaldoAtu[5]		// saldo atual credito
			Replace SALDODEB	With nSaldoDeb				// Saldo Debito
			Replace SALDOCRD	With nSaldoCrd				// Saldo Credito
	    	
			If !lNImpMov
				Replace MOVIMENTO With SALDOCRD-SALDODEB
			Endif
			
			dbSelectArea(cCadAlias2)
			dbGoto(nRecno2)
			dbSkip()
		Enddo 
		dbSelectArea(cCadAlias1)
		dbGoto(nRecno1)
		dbSkip()
		If ValType(oMeter) == "O"		
			nMeter++
    		oMeter:Set(nMeter)		
   		EndIf
	EndDo
#IfDef TOP
	Endif
#ENDIF
	
// Grava sinteticas
dbSelectArea("cArqTmp")	
dbGoTop()  
If ValType(oMeter) == "O"
	oMeter:SetTotal(("cArqTmp")->(RecCount()))
	oMeter:Set(0)
EndIf

While!Eof()                                 
                                            
	nSaldoAnt	:= SALDOANT
	nSaldoAtu	:= SALDOATU
	nSaldoDeb	:= SALDODEB
	nSaldoCrd	:= SALDOCRD   
	nMovimento	:= MOVIMENTO
	nSaldoAntD	:= SALDOANTDB
	nSaldoAntC	:= SALDOANTCR	
	nSaldoAtuD	:= SALDOATUDB
	nsaldoAtuC	:= SALDOATUCR

	nRegTmp := Recno()  
	
	dbSelectArea(cCadAlias2)
	dbSetOrder(1)      
	If Empty(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodSup2))
		dbSelectArea("cArqTmp")
		Replace NIVEL1 With .T.
		dbSelectArea(cCadAlias2)
	EndIf		
	MsSeek(xFilial(cCadAlias2)+ &("cArqTmp->"+cCodSup2))
		
	While !Eof() .And. &(cCadAlias2+"->"+cCadAlias2+"_FILIAL") == xFilial()

		cEntid1	 := &("cArqTmp->"+cCodEnt1)
		cDesc1	 := &("cArqTmp->"+cDescEnt)
		cEntSup2 := &(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2)
								
		cDescEnt2	:= (cCadAlias2+"->"+cCadAlias2+"_DESC")
		cDesc2		:= &(cDescEnt2+cMoeda)			        
		If Empty(cDesc2)	// Caso nao preencher descricao da moeda selecionada
			cDesc2	:= &(cDescEnt2+"01")
		Endif		

		cSeek 		:= cEntid1+cEntSup2   
		
		dbSelectArea(cCadAlias1)
		dbSetOrder(1)
		MsSeek(xFilial(cCadAlias1)+cEntid1,.F.)
		
		dbSelectArea("cArqTmp")
		dbSetOrder(1)      
		If !MsSeek(cSeek)
			dbAppend()
			Do Case
			Case cAlias == 'CTV'      
				If cHeader	== 'CTT'	//Se for Centro de Custo/Item
					Replace CUSTO   	With cEntid1
					Replace DESCCC		With cDesc1
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES	
					Replace ITEM 		With cEntSup2
					Replace DESCITEM	With cDesc2
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES			
				ElseIf cHeader == 'CTD'	//Se for Item/C.Custo
					Replace ITEM 		With cEntid1
					Replace DESCITEM	With cDesc1
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES					
					Replace CUSTO   	With cEntSup2
					Replace DESCCC		With cDesc2
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES	
				EndIf			
			Case cAlias == 'CTW'
				If cHeader	== 'CTH'		//Se for Cl.Valor/C.Custo
					Replace CLVL    	With cEntid1
					Replace DESCCLVL	With cDesc1
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES
					Replace CUSTO   	With cEntSup2
					Replace DESCCC		With cDesc2
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES				                        	
				ElseIf cHeader	== 'CTT'	//Se for C.Custo/Cl.Valor
					Replace CUSTO   	With cEntid1
					Replace DESCCC		With cDesc1
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES				                        	
					Replace CLVL    	With cEntSup2
					Replace DESCCLVL	With cDesc2
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES			
				EndIf
			Case cAlias == 'CTX'                   
				If cHeader == 'CTH'	//Se for Cl.Valor/Item
					Replace CLVL    	With cEntid1 
					Replace DESCCLVL	With cDesc1
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES
					Replace ITEM		With cEntSup2
					Replace DESCITEM	With cDesc2
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES					
				ElseIf cHeader	== 'CTD'	//Se for Item/Cl.Valor
					Replace ITEM		With cEntid1
					Replace DESCITEM	With cDesc1
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES					
					Replace CLVL    	With cEntSup2
					Replace DESCCLVL	With cDesc2
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES			
				Endif
			EndCase
			
		EndIf    
		
		Replace	 SALDOANT With SALDOANT + nSaldoAnt
		Replace  SALDOANTDB With SALDOANTDB + nSaldoAntD
		Replace  SALDOANTCR	With SALDOANTCR + nSaldoAntC		
		Replace  SALDOATU With SALDOATU + nSaldoAtu
		Replace  SALDOATUDB	With SALDOATUDB	+ nSaldoAtuD
		Replace  SALDOATUCR	With SALDOATUCR + nsaldoAtuC		
		Replace  SALDODEB With SALDODEB + nSaldoDeb
		Replace  SALDOCRD With SALDOCRD + nSaldoCrd
		If !lNImpMov
			Replace MOVIMENTO With MOVIMENTO + nMovimento
		Endif
   		
		dbSelectArea(cCadAlias2)
		If Empty(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodSup2))
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea(cCadAlias2)
			Exit                     						
		EndIf		

		dbSelectArea(cCadAlias2)
		MsSeek(xFilial(cCadAlias2)+ &("cArqTmp->"+cCodSup2))
	EndDo
	dbSelectArea("cArqTmp")
	dbGoto(nRegTmp)
	dbSkip()
	If ValType(oMeter) == "O"	
		nMeter++
   		oMeter:Set(nMeter)
  	EndIF
EndDo
RestArea(aSaveArea)

Return				

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SldCmpEnt ³ Autor ³ Simone Mie Sato       ³ Data ³ 03.12.01 			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Saldo Totalizador de Duas Entidades.                         			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ SldCmpEnt(Entid1,cEntid2,dData,cMoeda,cTpsald)                     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³{nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt,nAntDeb,nAntCrd}³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo da Entidade Principal                      		    ³±±
±±³          ³ ExpC2 = Codigo da Entidade que sera impressa no corpo do relatorio   ³±±
±±³          ³ ExpD1 = Data                                              		    ³±±
±±³          ³ ExpC3 = Moeda                                             		    ³±±
±±³          ³ ExpC4 = Tipo de Saldo                                     		    ³±±
±±³          ³ ExpN1 = Ordem                                             		    ³±±
±±³          ³ ExpC4 = Identifica qual sera a Entidade Principal         		    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function SldCmpEnt(cEntid1,cEntid2,dData,cMoeda,cTpSald,nOrder,cHeader,cAlias,cFiltroEnt,cCodFilEnt,lImpAntLP,dDataLP,cRotina)

Local aSaveArea	:= (cAlias)->(GetArea())
Local aSaveAnt	:= GetArea()
Local lNaoAchei	:= .F.
Local nDebito	:= 0					// Valor Debito na Data
Local nCredito	:= 0					// Valor Credito na Data
Local nAtuDeb 	:= 0					// Saldo Atual Devedor
Local nAtuCrd	:= 0					// Saldo Atual Credor
Local nAntDeb	:= 0					// Saldo Anterior Devedor
Local nAntCrd	:= 0					// Saldo Anterior Credor
Local nSaldoAnt	:= 0					// Saldo Anterior (com sinal)
Local nSaldoAtu	:= 0					// Saldo Atual (com sinal)
Local nOrdemLP	:= 0
Local cCond		:= ""
Local bCondLP	:= {||.F.}
Local cChaveLP	:= ""
Local bCondicao := { ||.F.}

cTpSald 		:= Iif(Empty(cTpSald),"1",cTpSald)
cFiltroEnt		:= Iif(cFiltroEnt == Nil,"",cFiltroEnt)
cCodFilEnt		:= Iif(cCodFilEnt == Nil,"",cCodFilEnt)
DEFAULT cRotina	:= ""
Do Case
Case cAlias == 'CTV' 
	If cHeader == 'CTD'
		bCondicao	:= { || (	CTV->CTV_FILIAL == xFilial("CTV") .And.;
								CTV->CTV_ITEM == cEntid1 .And. CTV->CTV_CUSTO == cEntid2 .And.;
								CTV->CTV_MOEDA == cMoeda .And. ;
								CTV->CTV_TPSALD == cTpSald .And. CTV->CTV_DATA <= dData) }		
	ElseIf cHeader == 'CTT'
		bCondicao	:= { || (	CTV->CTV_FILIAL == xFilial("CTV") .And.;
		 						CTV->CTV_CUSTO == cEntid1 .And. CTV->CTV_ITEM == cEntid2 .And.;
								CTV->CTV_MOEDA == cMoeda .And. ;
								CTV->CTV_TPSALD == cTpSald .And. CTV->CTV_DATA <= dData) }		
	EndIf           
Case cAlias == 'CTW'
	If cHeader == 'CTH'
		bCondicao	:= { || (	CTW->CTW_FILIAL == xFilial("CTW") .And.;
		 						CTW->CTW_CLVL == cEntid1 .And. CTW->CTW_CUSTO == cEntid2 .And.;
								CTW->CTW_MOEDA == cMoeda .And. ;
								CTW->CTW_TPSALD == cTpSald .And. CTW->CTW_DATA <= dData) }		
	ElseIf cHeader == 'CTT'
		bCondicao  	:= { || (	CTW->CTW_FILIAL == xFilial("CTW") .And.;
		 						CTW->CTW_CUSTO == cEntid1 .And. CTW->CTW_CLVL == cEntid2 .And.;
								CTW->CTW_MOEDA == cMoeda .And. ;
								CTW->CTW_TPSALD == cTpSald .And. CTW->CTW_DATA <= dData) }		
	EndIf           
Case cAlias == 'CTX'
	If cHeader == 'CTH'
		bCondicao	:= { || (	CTX->CTX_FILIAL == xFilial("CTX") .And.;
		 						CTX->CTX_CLVL == cEntid1 .And. CTX->CTX_ITEM == cEntid2 .And.;
								CTX->CTX_MOEDA == cMoeda .And. ;
								CTX->CTX_TPSALD == cTpSald .And. CTX->CTX_DATA <= dData) }
		
	ElseIf cHeader == 'CTD'
		bCondicao  	:= { || (	CTX->CTX_FILIAL == xFilial("CTX") .And.;
		 						CTX->CTX_ITEM == cEntid1 .And. CTX->CTX_CLVL == cEntid2 .And.;
								CTX->CTX_MOEDA == cMoeda .And. ;
								CTX->CTX_TPSALD == cTpSald .And. CTX->CTX_DATA <= dData) }
		
	EndIf              
Case cAlias == 'CTY'
	If  cHeader == 'CTT' .And. cFiltroEnt == 'CTD'	  
		bCondicao	:= { || (	CTY->CTY_FILIAL == xFilial("CTY") .And.;
		 						CTY->CTY_CUSTO == cEntid1 .And. CTY->CTY_CLVL == cEntid2 .And.;
		 						CTY->CTY_ITEM == cCodFilEnt .And. ;
								CTY->CTY_MOEDA == cMoeda .And. ;
								CTY->CTY_TPSALD == cTpSald .And. CTY->CTY_DATA <= dData) }		
		cChave		:= cMoeda+cTpSald+cEntid2+cCodFilEnt+cEntid1+Dtos(dData)		
	ElseIf cHeader == 'CTT' .And. cFiltroEnt == 'CTH'
		bCondicao	:= { || (	CTY->CTY_FILIAL == xFilial("CTY") .And.;
		 						CTY->CTY_CUSTO == cEntid1 .And. CTY->CTY_ITEM == cEntid2 .And.;
		 						CTY->CTY_CLVL == cCodFilEnt .And. ;
								CTY->CTY_MOEDA == cMoeda .And. ;
								CTY->CTY_TPSALD == cTpSald .And. CTY->CTY_DATA <= dData) }		
		cChave		:= cMoeda+cTpSald+cCodFilEnt+cEntid2+cEntid1+Dtos(dData)										
	ElseIf cHeader == 'CTD' .And. cFiltroEnt == 'CTT'
		bCondicao	:= { || (	CTY->CTY_FILIAL == xFilial("CTY") .And.;
		 						CTY->CTY_ITEM == cEntid1 .And. CTY->CTY_CLVL == cEntid2 .And.;
		 						CTY->CTY_CUSTO == cCodFilEnt .And. ;
								CTY->CTY_MOEDA == cMoeda .And. ;
								CTY->CTY_TPSALD == cTpSald .And. CTY->CTY_DATA <= dData) }		
		cChave		:= cMoeda+cTpSald+cEntid2+cEntid1+cEntid2+Dtos(dData)																		
	ElseIf cHeader == 'CTD' .And. cFiltroEnt == 'CTH'
		bCondicao	:= { || (	CTY->CTY_FILIAL == xFilial("CTY") .And.;
		 						CTY->CTY_ITEM == cEntid1 .And. CTY->CTY_CUSTO == cEntid2 .And.;
		 						CTY->CTY_CLVL == cCodFilEnt .And. ;
								CTY->CTY_MOEDA == cMoeda .And. ;
								CTY->CTY_TPSALD == cTpSald .And. CTY->CTY_DATA <= dData) }		
		cChave		:= cMoeda+cTpSald+cCodFilEnt+cEntid1+cEntid2+Dtos(dData)																		
	ElseIf cHeader == 'CTH' .And. cFiltroEnt == 'CTT'
			bCondicao	:= { || (	CTY->CTY_FILIAL == xFilial("CTY") .And.;
		 						CTY->CTY_CLVL == cEntid1 .And. CTY->CTY_ITEM == cEntid2 .And.;
		 						CTY->CTY_CUSTO == cCodFilEnt .And. ;
								CTY->CTY_MOEDA == cMoeda .And. ;
								CTY->CTY_TPSALD == cTpSald .And. CTY->CTY_DATA <= dData) }		
		cChave		:= cMoeda+cTpSald+cEntid1+cEntid2+cCodFilEnt+Dtos(dData)																		
	ElseIf cHeader == 'CTH' .And. cFiltroEnt == 'CTD'
		bCondicao	:= { || (	CTY->CTY_FILIAL == xFilial("CTY") .And.;
		 						CTY->CTY_CLVL == cEntid1 .And. CTY->CTY_CUSTO == cEntid2 .And.;
		 						CTY->CTY_ITEM == cCodFilEnt .And. ;
								CTY->CTY_MOEDA == cMoeda .And. ;
								CTY->CTY_TPSALD == cTpSald .And. CTY->CTY_DATA <= dData) }		
		cChave		:= cMoeda+cTpSald+cEntid1+cCodFilEnt+cEntid2+Dtos(dData)																		
	EndIf               			
EndCase	

dbSelectArea(cAlias)
dbSetOrder(nOrder)
If cAlias == "CTY"
	MsSeek(xFilial()+cChave,.T.)
Else
	MsSeek(xFilial()+cMoeda+cTpSald+cEntid1+cEntid2+Dtos(dData),.T.)
EndIf

If !(FOUND())
	dbSkip(-1)
	lNaoAchei := .T.
Else	//Verificar se existe algum registro de zeramento na mesma data 
	dbSkip()
    If !Eval(bCondicao) //Se nao existir registro na mesma data, volto para o registro anterior. 
          dbSkip(-1)
    EndIf 
EndIf

Do Case
Case cAlias == 'CTV' 
	If cHeader == 'CTD'
		cCond := cEntid1 == CTV->CTV_ITEM .And. cEntid2 == CTV->CTV_CUSTO
		nOrdemLP	:= 6                                                  
		bCondLP  	:= { || (	CTV->CTV_FILIAL == xFilial("CTV") .And.;
								CTV->CTV_ITEM == cEntid1 .And. CTV->CTV_CUSTO == cEntid2 .And.;
								CTV->CTV_TPSALD == cTpSald .And. CTV->CTV_LP == "Z" .And.;
								dDataLp <= dData) }		
	ElseIf cHeader == 'CTT'
		cCond := cEntid1 == CTV->CTV_CUSTO .And. cEntid2 == CTV->CTV_ITEM
		nOrdemLP	:= 7
		bCondLP  	:= { || (	CTV->CTV_FILIAL == xFilial("CTV") .And.;
		 						CTV->CTV_CUSTO == cEntid1 .And. CTV->CTV_ITEM == cEntid2 .And.;
								CTV->CTV_TPSALD == cTpSald .And. CTV->CTV_LP == "Z" .And.;
								dDataLp <= dData) }		
	EndIf           
Case cAlias == 'CTW'
	If cHeader == 'CTH'
		cCond := cEntid1 == CTW->CTW_CLVL .And. cEntid2 == CTW->CTW_CUSTO
		nOrdemLP	:= 6		
		bCondLP  	:= { || (	CTW->CTW_FILIAL == xFilial("CTW") .And.;
		 						CTW->CTW_CLVL == cEntid1 .And. CTW->CTW_CUSTO == cEntid2 .And.;
								CTW->CTW_TPSALD == cTpSald .And. CTW->CTW_LP == "Z" .And.;
								dDataLp <= dData) }		
	ElseIf cHeader == 'CTT'
		cCond := cEntid1 == CTW->CTW_CUSTO .And. cEntid2 == CTW->CTW_CLVL
		nOrdemLP	:= 7
		bCondLP  	:= { || (	CTW->CTW_FILIAL == xFilial("CTW") .And.;
		 						CTW->CTW_CUSTO == cEntid1 .And. CTW->CTW_CLVL == cEntid2 .And.;
								CTW->CTW_TPSALD == cTpSald .And. CTW->CTW_LP == "Z" .And.;
								dDataLp <= dData) }		
	EndIf           
Case cAlias == 'CTX'
	If cHeader == 'CTH'
		cCond := cEntid1 == CTX->CTX_CLVL .And. cEntid2 == CTX->CTX_ITEM
		nOrdemLP	:= 7		
		bCondLP  	:= { || (	CTX->CTX_FILIAL == xFilial("CTX") .And.;
		 						CTX->CTX_CLVL == cEntid1 .And. CTX->CTX_ITEM == cEntid2 .And.;
								CTX->CTX_TPSALD == cTpSald .And. CTX->CTX_LP == "Z" .And.;
								dDataLp <= dData) }
		
	ElseIf cHeader == 'CTD'
		cCond := cEntid1 == CTX->CTX_ITEM .And. cEntid2 == CTX->CTX_CLVL
		nOrdemLP	:= 6		
		bCondLP  	:= { || (	CTX->CTX_FILIAL == xFilial("CTX") .And.;
		 						CTX->CTX_ITEM == cEntid1 .And. CTX->CTX_CLVL == cEntid2 .And.;
								CTX->CTX_TPSALD == cTpSald .And. CTX->CTX_LP == "Z" .And.;
								dDataLp <= dData) }
		
	EndIf              
Case cAlias == 'CTY'
	If  cHeader == 'CTT' .And. cFiltroEnt == 'CTD'	  
		cCond	:= cEntid1 == CTY->CTY_CUSTO .And. cEntid2 == CTY->CTY_CLVL .And. cCodFilEnt == CTY->CTY_ITEM		
	ElseIf cHeader == 'CTT' .And. cFiltroEnt == 'CTH'
		cCond	:= cEntid1 == CTY->CTY_CUSTO .And. cEntid2 == CTY->CTY_ITEM .And. cCodFilEnt == CTY->CTY_CLVL
	ElseIf cHeader == 'CTD' .And. cFiltroEnt == 'CTT'
		cCond	:= cEntid1 == CTY->CTY_ITEM .And. cEntid2 == CTY->CTY_CLVL .And. cCodFilEnt == CTY->CTY_CUSTO
	ElseIf cHeader == 'CTD' .And. cFiltroEnt == 'CTH'
		cCond	:= cEntid1 == CTY->CTY_ITEM .And. cEntid2 == CTY->CTY_CUSTO .And. cCodFilEnt == CTY->CTY_CLVL
	ElseIf cHeader == 'CTH' .And. cFiltroEnt == 'CTT'
		cCond	:= cEntid1 == CTY->CTY_CLVL .And. cEntid2 == CTY->CTY_ITEM .And. cCodFilEnt == CTY->CTY_CUSTO
	ElseIf cHeader == 'CTH' .And. cFiltroEnt == 'CTD'
		cCond	:= cEntid1 == CTY->CTY_CLVL .And. cEntid2 == CTY->CTY_CUSTO .And. cCodFilEnt == CTY->CTY_ITEM				
	EndIf               
EndCase
	

If (&(cAlias+"->"+cAlias+"_FILIAL") == xFilial() .And. &(cAlias+"->"+cAlias+"_MOEDA") == cMoeda .And.;
	&(cAlias+"->"+cAlias+"_TPSALD") == cTpSald .And.&(cAlias+"->"+cAlias+"_DATA")  <= dData .And. cCond)
	// Movimentacoes na data
	If &(cAlias+"->"+cAlias+"_DATA") == dData
		nDebito		:= &(cAlias+"->"+cAlias+"_DEBITO")
		nCredito	:= &(cAlias+"->"+cAlias+"_CREDIT")
	Endif	
	nAtuDeb		:= &(cAlias+"->"+cAlias+"_ATUDEB")
	nAtuCrd 	:= &(cAlias+"->"+cAlias+"_ATUCRD")
	If lNaoAchei
		// Neste caso, como a data nao foi encontrada, considera-se como saldo anterior
		// o saldo atual do registro anterior! -> dbskip(-1)
		nAntDeb  := &(cAlias+"->"+cAlias+"_ATUDEB")
		nAntCrd  := &(cAlias+"->"+cAlias+"_ATUCRD")
	Else		
		nAntDeb  := &(cAlias+"->"+cAlias+"_ANTDEB")
		nAntCrd  := &(cAlias+"->"+cAlias+"_ANTCRD")
	Endif
	If cRotina = "CTBA210" 
		//Se foi chamado pela rotina de apuracao de lucros/perdas,existe um registro
		//na data solcitada e o saldo nao eh o do proprio zeramento, considero como 
		//saldo anterior, o saldo atual antes do zeramento. 
		If &(cAlias+"->"+cAlias+"_LP")	<> 'Z'
			nAntDeb  := &(cAlias+"->"+cAlias+"_ATUDEB")
			nAntCrd  := &(cAlias+"->"+cAlias+"_ATUCRD")
		Endif
	Endif		
	nSaldoAtu:= nAtuCrd - nAtuDeb
	nSaldoAnt:= nAntCrd - nAntDeb
EndIf                                                   

If lImpAntLP	.And. cAlias <> 'CTY'
	dbSelectArea(cAlias)
	dbSetOrder(nOrdemLP)	
	If MsSeek(xFilial()+"Z"+cMoeda+cTpSald+cEntid1+cEntid2)
		aSldLP	:= CtbSldLP(cAlias,dDataLP,bCondLP,dData)		
		nAtuDeb	-= aSldLP[1]
		nAtuCrd	-= aSldLP[2]		
		nSaldoAtu := nAtuCrd - nAtuDeb
//		If lNaoAchei
			nAntDeb	-= aSldLP[1]
			nAntCrd -= aSldLP[2]    
			nSaldoAnt	:= nAntCrd - nAntDeb
//		EndIf
	EndIf
EndIf

(cAlias)->(RestArea(aSaveArea))
RestArea(aSaveAnt)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno:                                             ³
//³ [1] Saldo Atual (com sinal)                          ³
//³ [2] Debito na Data                                   ³
//³ [3] Credito na Data                                  ³
//³ [4] Saldo Atual Devedor                              ³
//³ [5] Saldo Atual Credor                               ³
//³ [6] Saldo Anterior (com sinal)                       ³
//³ [7] Saldo Anterior Devedor                           ³
//³ [8] Saldo Anterior Credor                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//      [1]       [2]     [3]      [4]     [5]     [6]       [7]     [8]
Return {nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt,nAntDeb,nAntCrd}



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtGerComp ³ Autor ³ Simone Mie Sato       ³ Data ³ 14.03.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Comparativos (6 colunas)      |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oMeter                                      ³±±
±±³          ³ ExpO2 = Objeto oText                                       ³±±
±±³          ³ ExpO3 = Objeto oDlg                                        ³±±
±±³          ³ ExpL1 = lEnd                                               ³±±
±±³          ³ ExpD1 = Data Inicial                                       ³±±
±±³          ³ ExpD2 = Data Final                                         ³±±
±±³          ³ ExpC1 = Alias do Arquivo                                   ³±±
±±³          ³ ExpC2 = Conta Inicial                                      ³±±
±±³          ³ ExpC3 = Conta Final                                        ³±±
±±³          ³ ExpC4 = Centro de Custo Inicial                            ³±±
±±³          ³ ExpC5 = Centro de Custo Final                              ³±±
±±³          ³ ExpC6 = Centro de Custo Inicial                            ³±±
±±³          ³ ExpC7 = Centro de Custo Final                              ³±±
±±³          ³ ExpC8 = Item Inicial                                       ³±±
±±³          ³ ExpC9 = Item Final                                         ³±±
±±³          ³ ExpC10= Classe de Valor Inicial                            ³±±
±±³          ³ ExpC11= Classe de Valor Final                              ³±±
±±³          ³ ExpC12= Moeda		                                      ³±±
±±³          ³ ExpC13= Saldo	                                          ³±±
±±³          ³ ExpA1 = Set Of Book	                                      ³±±
±±³          ³ ExpC13= Ate qual segmento sera impresso (nivel)			  ³±±
±±³          ³ ExpC8 = Filtra por Segmento		                          ³±±
±±³          ³ ExpC9 = Segmento Inicial		                              ³±±
±±³          ³ ExpC10= Segmento Final  		                              ³±±
±±³          ³ ExpC11= Segmento Contido em  	                          ³±±
±±³          ³ ExpL2 = Se Imprime Entidade sem movimento                  ³±±
±±³          ³ ExpL3 = Se Imprime Conta                                   ³±±
±±³          ³ ExpN1 = Grupo                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTGerComp(oMeter,oText,oDlg,lEnd,cArqtmp,;
						dDataIni,dDataFim,cAlias,cIdent,cContaIni,;
				  		cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,	cClVlFim,cMoeda,;
				  		cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				  		lNImpMov,lImpConta,nGrupo,cHeader,lImpAntLP,dDataLP,nDivide,cTpVlr,;
				  		lFiliais,aFiliais,lMeses,aMeses,lVlrZerado,lEntid,aEntid,lImpSint,cString,;
				  		cFilUSU,lImpTotS)
						
Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamCtaRes	:= TAMSX3("CT1_RES")
Local aTamCC        := TAMSX3("CTT_CUSTO")
Local aTamCCRes 	:= TAMSX3("CTT_RES")
Local aTamItem  	:= TAMSX3("CTD_ITEM")
Local aTamItRes 	:= TAMSX3("CTD_RES")    
Local aTamClVl  	:= TAMSX3("CTH_CLVL")
Local aTamCvRes 	:= TAMSX3("CTH_RES")
Local aCtbMoeda		:= {}
Local aSaveArea 	:= GetArea()
Local aCampos
Local aStruTMP		:= {}
Local cChave
Local nTamCta 		:= Len(CriaVar("CT1->CT1_DESC"+cMoeda))
Local nTamItem		:= Len(CriaVar("CTD->CTD_DESC"+cMoeda))
Local nTamCC  		:= Len(CriaVar("CTT->CTT_DESC"+cMoeda))
Local nTamClVl		:= Len(CriaVar("CTH->CTH_DESC"+cMoeda))
Local nTamGrupo		:= Len(CriaVar("CT1->CT1_GRUPO"))
Local nDecimais		:= 0
Local cEntidIni		:= ""
Local cEntidFim		:= ""           
Local cEntidIni1	:= ""
Local cEntidFim1	:= ""
Local cEntidIni2	:= ""
Local cEntidFim2	:= ""
Local cArqTmp1		:= ""
Local lCusto		:= CtbMovSaldo("CTT")//Define se utiliza C.Custo
Local lItem 		:= CtbMovSaldo("CTD")//Define se utiliza Item
Local lClVl			:= CtbMovSaldo("CTH")//Define se utiliza Cl.Valor 
Local lAtSldBase	:= Iif(GetMV("MV_ATUSAL")== "S",.T.,.F.) 
Local lAtSldCmp		:= Iif(GetMV("MV_SLDCOMP")== "S",.T.,.F.)
Local nInicio		:= Val(cMoeda)
Local nFinal		:= Val(cMoeda)
Local cFilDe		:= xFilial(cAlias)
Local cFilate		:= xFilial(cAlias)
Local cMensagem		:= ""
Local nMeter		:= 0
Local lTemQry		:= .F.							/// SE UTILIZOU AS QUERYS PARA OBTER O SALDO DAS ANALITICAS
Local nTRB			:= 1
Local nCont			:= 0 
Local dDataAnt		:= CTOD("  /  /  ")
Local cFilXAnt		:= ""

#IFDEF TOP
	Local nMin	:= 0 
	Local nMax	:= 0 
#ENDIF

cIdent		:=	Iif(cIdent == Nil,'',cIdent)
nGrupo		:=	Iif(nGrupo == Nil,2,nGrupo)                                                 
cHeader		:= Iif(cHeader == Nil,'',cHeader)

DEFAULT lImpSint	:= .F.                                              
DEFAULT cMoeda		:= "01"		//// SE NAO FOR INFORMADA A MOEDA ASSUME O PADRAO 01
DEFAULT lEntid		:= .F.
DEFAULT lMeses		:= .F.
DEFAULT lImpTotS	:= .F.
dMinData := CTOD("")

// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := aCtbMoeda[5]

aCampos := {{ "CONTA"		, "C", aTamConta[1], 0 },;  			// Codigo da Conta
	 		 { "NORMAL"		, "C", 01			, 0 },;			// Situacao
			 { "CTARES"		, "C", aTamCtaRes[1], 0 },;  			// Codigo Reduzido da Conta
			 { "DESCCTA"	, "C", nTamCta		, 0 },;  			// Descricao da Conta
             { "CUSTO"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
			 { "CCRES"		, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
			 { "DESCCC" 	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
	         { "ITEM"		, "C", aTamItem[1]	, 0 },; 	 		// Codigo do Item          
			 { "ITEMRES" 	, "C", aTamItRes[1], 0 },;  			// Codigo Reduzido do Item
			 { "DESCITEM" 	, "C", nTamItem		, 0 },;  			// Descricao do Item
             { "CLVL"		, "C", aTamClVl[1]	, 0 },; 	 		// Codigo da Classe de Valor
             { "CLVLRES"	, "C", aTamCVRes[1], 0 },; 		 	// Cod. Red. Classe de Valor
			 { "DESCCLVL"   , "C", nTamClVl		, 0 },;  			// Descricao da Classe de Valor
			 { "COLUNA1"	, "N", 17			, nDecimais},; 	// Saldo Anterior
   		 	 { "COLUNA2"   	, "N", 17			, nDecimais},; 	// Saldo Anterior Debito
 			 { "COLUNA3"   	, "N", 17			, nDecimais},; 	// Saldo Anterior Credito
			 { "COLUNA4" 	, "N", 17			, nDecimais},;  	// Debito
			 { "COLUNA5" 	, "N", 17			, nDecimais},;  	// Credito
			 { "COLUNA6"  	, "N", 17			, nDecimais},;  	// Saldo Atual             
			 { "COLUNA7"	, "N", 17			, nDecimais},; 	// Saldo Anterior
   		 	 { "COLUNA8"   	, "N", 17			, nDecimais},; 	// Saldo Anterior Debito
 			 { "COLUNA9"   	, "N", 17			, nDecimais},; 	// Saldo Anterior Credito
			 { "COLUNA10" 	, "N", 17			, nDecimais},;  	// Debito
			 { "COLUNA11" 	, "N", 17			, nDecimais},;  	// Credito
			 { "COLUNA12"  	, "N", 17			, nDecimais},;  	// Saldo Atual               			   
			 { "TIPOCONTA"	, "C", 01			, 0 },;			// Conta Analitica / Sintetica           
 			 { "TIPOCC"  	, "C", 01			, 0 },;			// Centro de Custo Analitico / Sintetico
 			 { "TIPOITEM"	, "C", 01			, 0 },;			// Item Analitica / Sintetica			 
 			 { "TIPOCLVL"	, "C", 01			, 0 },;			// Classe de Valor Analitica / Sintetica			 
  			 { "CTASUP"		, "C", aTamConta[1], 0 },;			// Codigo do Centro de Custo Superior
 			 { "CCSUP"		, "C", aTamCC[1]	, 0 },;			// Codigo do Centro de Custo Superior
			 { "ITSUP"		, "C", aTamItem[1]	, 0 },;			// Codigo do Item Superior
 			 { "CLSUP"	    , "C", aTamClVl[1] , 0 },;			// Codigo da Classe de Valor Superior
			 { "ORDEM"		, "C", 10			, 0 },;			// Ordem
			 { "GRUPO"		, "C", nTamGrupo	, 0 },;			// Grupo Contabil
		     { "IDENTIFI"	, "C", 01			, 0 },;			 			 
		     { "ESTOUR"  	, "C", 01			, 0 },;			//Define se eh conta estourada
			 { "NIVEL1"		, "L", 01			, 0 }}				// Logico para identificar se 
																	// eh de nivel 1 -> usado como
																	// totalizador do relatorio  																

///// TRATAMENTO PARA ATUALIZAÇÃO DE SALDO BASE
//Se os saldos basicos nao foram atualizados na dig. lancamentos
If !lAtSldBase
  	#IFDEF TOP
		If TcSrvType() != "AS/400"                     		  	
			//Chama Rotina de Atualizacao de Saldos Basicos.
			oProcess := MsNewProcess():New({|lEnd|	Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cSaldos,.T.,cFilDe,cFilAte,,,.T.,oProcess,nMin,nMax)},"","",.F.)
			oProcess:Activate()						
		Else
	#ENDIF
		oProcess := MsNewProcess():New({|lEnd|	Ct360RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cSaldos,oProcess,lAtSldBase)},"","",.F.)		
		oProcess:Activate()						
	#IFDEF TOP
		EndIf
	#ENDIF
Endif

//// TRATAMENTO PARA ATUALIZAÇÃO DE SALDOS COMPOSTOS ANTES DE EXECUTAR A QUERY DE FILTRAGEM
Do Case
Case cAlias == 'CTU'
	//Verificar se tem algum saldo a ser atualizado
		//Verificar se tem algum saldo a ser atualizado por entidade
	If cIdent == "CTT"
		cOrigem := 	'CT3'
	ElseIf cIdent == "CTD"      
		cOrigem := 	'CT4'
	ElseIf cIdent == "CTH"
		cOrigem := 	'CTI'		
	Else
		cOrigem := 	'CTI'		
	Endif
	If lFiliais                         	
		For nCont := 1 to Len(aFiliais)
			Ct360Data(cOrigem,'CTU',@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,aFiliais[nCont])		
			If !Empty(dMinData) 
				If nCont	== 1 
					dDataAnt	:= dMinData
				Else 
					If dMinData	< dDataAnt			
						dDataAnt	:= dMinData				
					EndIf
				EndIf
			EndIf		
		Next	
		//Menor data de todas as filiais		
		dMinData	:= dDataAnt
	Else	
		Ct360Data(cOrigem,'CTU',@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
	Endif
Case cAlias == 'CTV'
	cOrigem := "CT4"
	//Verificar se tem algum saldo a ser atualizado
	Ct360Data(cOrigem,"CTV",@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
Case cAlias == 'CTW'			
	cOrigem		:= 'CTI'	/// HEADER POR CLASSE DE VALORES
	//Verificar se tem algum saldo a ser atualizado
	Ct360Data(cOrigem,"CTW",@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
Case cAlias == 'CTX'			
	cOrigem		:= 'CTI'		
	//Verificar se tem algum saldo a ser atualizado
	Ct360Data(cOrigem,"CTX",@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
EndCase	

DO CASE
CASE cAlias$("CTU/CTV/CTW/CTX/CTY")
	//Se o parametro MV_SLDCOMP estiver com "S",isto e, se devera atualizar os saldos compost.
	//na emissao dos relatorios, verifica se tem algum registro desatualizado e atualiza as
	//tabelas de saldos compostos.
	If !Empty(dMinData)
		If lAtSldCmp	//Se atualiza saldos compostos
			If lFiliais
				cFilXAnt	:= cFilAnt
				
				For nCont := 1 to Len(aFiliais)
					cFilAnt	:= aFiliais[nCont] 
					cFilDe	:= cFilAnt
					cFilAte	:= cFilAnt
					oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cSaldos,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,)},"","",.F.)
					oProcess:Activate()	
				Next			      
				cFilAnt		:= cFilXAnt
				cFilDe		:= cFilAnt
				cFilAte		:= cFilAnt
			Else
				oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cSaldos,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt)},"","",.F.)
				oProcess:Activate()	
			EndIf
		Else		//Se nao atualiza os saldos compostos, somente da mensagem
			cMensagem	:= STR0016
			cMensagem	+= STR0017				
			MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
			Return							//atraves da rotina de saldos compostos	
		EndIf    
	EndIf
ENDCASE

/// TRATAMENTO PARA OBTENÇÃO DO SALDO DAS CONTAS ANALITICAS
Do Case
Case cAlias  == "CT7"            
	//Se for Comparativo de Conta por 6 meses/12 meses
	cEntidIni	:= cContaIni
	cEntidFim	:= cContaFim
	If nGrupo == 2
		cChave := "CONTA"
	Else									// Indice por Grupo -> Totaliza por grupo
		cChave := "CONTA+GRUPO"
	EndIf
	#IFDEF TOP		
		If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])				/// SÓ HÁ QUERY SEM O PLANO GERENCIAL
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif
			If lMeses				
				If cHeader == "SLD"			/// COMPARATIVO DE SALDO ACUMULADO
					CT7CompQry(dDataIni,dDataFim,cSaldos,cMoeda,cContaIni,cContaFim,aSetOfBook,lVlrZerado,lMeses,aMeses,cString,cFILUSU,lImpAntLP,dDataLP,.T.)                                                           							
				Else						/// COMPARATIVO DE MOVIMENTO DO PERIODO
					CT7CompQry(dDataIni,dDataFim,cSaldos,cMoeda,cContaIni,cContaFim,aSetOfBook,lVlrZerado,lMeses,aMeses,cString,cFILUSU,lImpAntLP,dDataLP,.F.)                                                           			
				Endif
			EndIf	
		EndIf
	#ENDIF
Case cAlias == "CTU" 
	If cIdent == "CTT"
		cEntidIni	:= cCCIni
		cEntidFim	:= cCCFim
		cChave		:= "CUSTO"
	EndIf
Case cAlias == "CT3"            

	If !Empty(aSetOfBook[5])
		cMensagem	:= OemToAnsi(STR0002)// O plano gerencial ainda nao esta disponivel nesse relatorio. 
		MsgInfo(cMensagem)
		RestArea(aSaveArea)
		Return
	Endif

	If cHeader == "CTT"
		cChave		:= "CUSTO+CONTA"
		cEntidIni1	:= cCCIni
		cEntidFim1	:= cCCFim
		cEntidIni2	:= cContaIni
		cEntidFim2	:= cContaFim
	ElseIf cHeader == "CT1"
		cChave		:= "CONTA+CUSTO"
		cEntidIni1	:= cContaIni
		cEntidFim1	:= cContaFim		
		cEntidIni2	:= cCCIni
		cEntidFim2	:= cCCFim	
	EndIf
	
	#IFDEF TOP	//// MONTA A QUERY E O ARQUIVO TEMPORÁRIO TRBTMP JÁ COM OS SALDOS
		If TcSrvType() != "AS/400"                     			
			CT3CompQry(dDataIni,dDataFim,cCCIni,cCCFim,cContaIni,cContaFim,cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,lMeses,aMeses,lVlrZerado,lEntid,aEntid,cHeader,cString,cFILUSU)
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif
		EndIf
	#ENDIF
	
Case cAlias == "CTV"	
	
	If !Empty(aSetOfBook[5])
		cMensagem	:= OemToAnsi(STR0002)// O plano gerencial ainda nao esta disponivel nesse relatorio. 
		MsgInfo(cMensagem)
		RestArea(aSaveArea)
		Return
	Endif
              
	If cHeader == "CTT"
		cChave	:=	"CUSTO+ITEM"	
		cEntidIni1	:=	cCCIni
		cEntidFim1	:=	cCCFim
		cEntidIni2	:=	cItemIni
		cEntidFim2	:=	cItemFim	         	
	ElseIf cHeader == "CTD"        
		cChave	:=	"ITEM+CUSTO"	
		cEntidIni1	:=	cItemIni
		cEntidFim1	:=	cItemFim
		cEntidIni2	:=	cCCIni 
		cEntidFim2	:=	cCCFim		         	
	EndIf
	#IFDEF TOP	//// MONTA A QUERY E O ARQUIVO TEMPORÁRIO TRBTMP JÁ COM OS SALDOS
		If TcSrvType() != "AS/400"                     			
			CTVCompQry(dDataIni,dDataFim,cCCIni,cCCFim,cItemIni,cItemFim,cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,lMeses,aMeses,lVlrZerado,lEntid,aEntid,cHeader,cString,cFILUSU)
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif
		EndIf
	#ENDIF
Case cAlias == "CTX"
	If cHeader == "CTH"    
		cChave		:= "CLVL+ITEM"
		cEntidIni1	:=	cClVlIni
		cEntidFim1	:=	cClVlFim
		cEntidIni2	:=	cItemIni
		cEntidFim2	:= cItemFim	
	ElseIf cHeader == "CTD"
		cChave		:= "ITEM+CLVL"
		cEntidIni1	:=	cItemIni
		cEntidFim1	:=	cItemFim	
		cEntidIni2	:=	cClVlIni
		cEntidFim2	:= 	cClVlFim	
	EndIf	
	#IFDEF TOP	//// MONTA A QUERY E O ARQUIVO TEMPORÁRIO TRBTMP JÁ COM OS SALDOS
		If TcSrvType() != "AS/400"                     			
			CTXCompQry(dDataIni,dDataFim,cItemIni,cItemFim,cClVlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,lMeses,aMeses,lVlrZerado,lEntid,aEntid,cHeader,cString,cFILUSU,lImpAntLP,dDataLP)
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif
		EndIf
	#ENDIF
EndCase

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
   cChave	:= "CONTA"
Endif

cArqTmp := CriaTrab(aCampos, .T.)

	If ( Select ( "cArqTmp" ) <> 0 )
		dbSelectArea ( "cArqTmp" )
		dbCloseArea ()
	Endif
dbUseArea( .T.,, cArqTmp, "cArqTmp", .F., .F. )
	dbSelectArea("cArqTmp")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqInd	:= CriaTrab(Nil, .F.)

IndRegua("cArqTmp",cArqInd,cChave,,,OemToAnsi(STR0001))  //"Selecionando Registros..."

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
	cArqTmp1 := CriaTrab(, .F.)
	IndRegua("cArqTmp",cArqTmp1,"ORDEM",,,OemToAnsi(STR0001))  //"Selecionando Registros..."
Endif	

dbSelectArea("cArqTmp")
DbClearIndex()
dbSetIndex(cArqInd+OrdBagExt())

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
	dbSetIndex(cArqTmp1+OrdBagExt())
Endif

#IFDEF TOP  
	If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])				/// SÓ HÁ QUERY SEM O PLANO GERENCIAL
		//// SE FOR DEFINIÇÃO TOP 
		If Select("TRBTMP") > 0		/// E O ALIAS TRBTMP ESTIVER ABERTO (INDICANDO QUE A QUERY FOI EXECUTADA)
  			dbSelectArea("TRBTMP")
			aStruTMP := dbStruct()			/// OBTEM A ESTRUTURA DO TMP
	
			dbSelectArea("TRBTMP")
			If ValType(oMeter) == "O"			
				oMeter:SetTotal((cAlias)->(RecCount()))
				oMeter:Set(0)
			EndIf
			dbGoTop()						/// POSICIONA NO 1º REGISTRO DO TMP
	
			While TRBTMP->(!Eof())			/// REPLICA OS DADOS DA QUERY (TRBTMP) PARA P/ O TEMPORARIO EM DISCO
				If ValType(oMeter) == "O"
					nMeter++
		    		oMeter:Set(nMeter)				
		   		EndIf	    		

				If &("TRBTMP->("+cFILUSU+")")
					RecLock("cArqTMP",.T.)
					For nTRB := 1 to Len(aStruTMP)
						If Subs(aStruTmp[nTRB][1],1,6) == "COLUNA" .And. nDivide > 1 
							Field->&(aStruTMP[nTRB,1])	:=((TRBTMP->&(aStruTMP[nTRB,1])))/ndivide
						Else
							Field->&(aStruTMP[nTRB,1]) := TRBTMP->&(aStruTMP[nTRB,1])
						EndIf					
					Next 
					cArqTMP->(MsUnlock())
				Endif

				TRBTMP->(dbSkip())
			Enddo

			dbSelectArea("TRBTMP")
			dbCloseArea()					/// FECHA O TRBTMP (RETORNADO DA QUERY)
			lTemQry := .T.
		Endif
	EndIf		
#ENDIF

dbSelectArea("cArqTmp")
dbSetOrder(1)

If !Empty(aSetOfBook[5])				// Se houve Indicacao de Plano Gerencial Anexado
	// Monta Arquivo Lendo Plano Gerencial                                   
	// Neste caso a filtragem de entidades contabeis é desprezada!
	// Por enquanto a opcao de emitir o relatorio com Plano Gerencial ainda 
	// nao esta disponivel para esse relatorio. 
	If cAlias $ "CT7"					// Se for Entidade x Conta
		CtbPlGerCm(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,;
					cAlias,cIdent,lImpAntLP,dDataLP,lVlrZerado,lFiliais,aFiliais,lMeses,aMeses,lImpSint)
		dbSetOrder(2)
	Else
		cMensagem	:= OemToAnsi(STR0002)// O plano gerencial ainda nao esta disponivel nesse relatorio. 
		MsgInfo(cMensagem)	
	EndIf	
Else
	If cAlias $ 'CT7/CTU'		//So Imprime Entidade                                
		#IFDEF TOP
			If lMeses 
				//So ira gravar as contas sinteticas se mandar imprimir as contas sinteticas ou ambas.
				If lImpSint
					//Gravacao das contas superiores.
					SupCompCt7(oMeter,lMeses,aMeses,cMoeda,cTpVlr)
				Endif
			Else		
		#ENDIF
		CtCmpSoEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,cMoeda,;
		cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cIdent,;
		lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,lImpAntLP,dDataLP,nDivide,;
		cTpVlr,lFiliais,aFiliais,lMeses,aMeses)
		#IFDEF TOP
			Endif
		#ENDIF		        
		
	ElseIf cAlias == "CT3"			
	
		If lMeses
			#IFNDEF TOP			
				/// SE FOR CODEBASE OU TOP SEM TER PASSADO PELAS QUERYS
				CtCmpComp(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
				cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado)					
			#ELSE
				If TcSrvType() == "AS/400"                     		  					
					CtCmpComp(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
					cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
					cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado)					
				EndIf	
			#ENDIF        
			
			If lImpSint .Or. lImpTotS
				SupCompMes(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
				cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado)
			EndIf			
			
		EndIf	
				
	ElseIf cAlias $ "CTV/CTX"				//// SE FOR ENTIDADE x ITEM CONTABIL
		If lEntid	//Relatorio Comparativo de 1 Entidade por 6 Entidades
		
			#IFNDEF TOP
				CtCmpEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,;
				cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
				cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lVlrZerado,aEntid)							
			#ELSE
				If TcSrvType() == "AS/400"                     		  								
					CtCmpEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,;
					cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
					cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lVlrZerado,aEntid)				
				EndIf
			#ENDIF  
			
			If lImpSint  // SE DEVE IMPRIMIR AS SINTETICAS
				/// Usa cHeader x cAlias invertidas para compor as entidades sintéticas (neste caso sintetica do CTD ao invés do CTT)
				SupCompEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cAlias,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cHeader,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
				cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado,lEntid,aEntid)
			Endif			
		Else
		
			/// Relatórios Comparativo 2 Entidades s/ Conta
			#IFNDEF TOP 
				CtCmpComp(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
				cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado)		
			#ELSE
				If TcSrvType() == "AS/400"                     		  					
					CtCmpComp(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
					cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
					cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado)						
				EndIf
			#ENDIF		
			
			If lImpSint  // SE DEVE IMPRIMIR AS SINTETICAS
				SupCompEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
				cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado)
			Endif

		EndIf
	Endif
EndIf

RestArea(aSaveArea)

Return cArqTmp

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtCmpSoEnt³ Autor ³Simone Mie Sato        ³ Data ³ 14.03.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Comparativos                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oMeter                                      ³±±
±±³          ³ ExpO2 = Objeto oText                                       ³±±
±±³          ³ ExpO3 = Objeto oDlg                                        ³±±
±±³          ³ ExpL1 = lEnd                                               ³±±
±±³          ³ ExpD1 = Data Inicial                                       ³±±
±±³          ³ ExpD2 = Data Final                                         ³±±
±±³          ³ ExpC3 = Da Entidade		                                  ³±±
±±³          ³ ExpC4 = Ate a Entidade                                     ³±±
±±³          ³ ExpC5 = Moeda		                                      ³±±
±±³          ³ ExpC6 = Saldo	                                          ³±±
±±³          ³ ExpA1 = Set Of Book	                                      ³±±
±±³          ³ ExpN1 = Tamanho da descricao             	              ³±±
±±³          ³ ExpC7 = Ate qual segmento sera impresso 	(nivel)		  	  ³±±
±±³          ³ ExpC8 = Filtra por Segmento		                          ³±±
±±³          ³ ExpC9 = Segmento Inicial		                              ³±±
±±³          ³ ExpC10= Segmento Final  		                              ³±±
±±³          ³ ExpC11= Segmento Contido em  	                          ³±±
±±³          ³ ExpL2 = Se imprime sem movimento  	                      ³±±
±±³          ³ ExpC12= Alias do Arquivo          	                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtCmpSoEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidfim,;
					cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					lNImpMov,cAlias,cIdent,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,;
					nInicio,nFinal,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,;
					lMeses,aMeses)

Local aSaveArea 	:= GetArea()
Local cMascara 		:= ""
Local nPos			:= 0
Local nDigitos		:= 0
Local cEntid			//Codigo da Entidade(Conta,C.Custo,Item ou Classe de valor)
Local cEntidSup			//Codigo da Entidade Superior(Conta,C.Custo,Item ou Classe de valor)
Local cDesc
Local nSaldoDeb 	:= 0
Local nSaldoCrd 	:= 0
Local nSaldoAntD	:= 0
Local nSaldoAntC	:= 0
Local nSaldoAtuD	:= 0
Local nSaldoAtuC	:= 0
Local nCont			:= 0 
Local nVezes		:= 0 
Local aMovimento	:= {}
Local cCodEnt		:= ""	//Codigo da entidade (conta, c.custo, item ou classe de valor)
Local nTamDesc		:= ""
Local oProcess
Local cDescEnt		:= ""
Local cEntSup		:= ""
Local nTotVezes		:= 0
Local nMeter		:= 0
Local nTotal		:= 0
Local nOrdem		:= 0 

lFiliais			:= Iif(lFiliais == Nil,.F.,lFiliais)
aFiliais			:= Iif(aFiliais==Nil,{},aFiliais)	
lMeses				:= Iif(lMeses == NIl, .F.,lMeses)
aMeses				:= Iif(aMeses==Nil,{},aMeses)
cIdent	  			:= Iif(cIdent	== Nil,'',cIdent)                       
nDivide 			:= Iif(nDivide == Nil,1,nDivide)

If cAlias == "CT7"
	cMascara	:= aSetOfBook[2]
ElseIf cAlias == "CTU"
	If cIdent == "CTT"
		cMascara	:= aSetOfBook[6]	
	EndIf
EndIf


If !Empty(cSegmento)

	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cMascara)
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascara 
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == cSegmento
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	EndIf	
EndIf	


If cAlias == 'CT7'//SE FOR BALANCETE POR CONTA
	
	dbSelectArea("CT1")
	If ValType(oMeter) == "O"	
		oMeter:SetTotal(CT1->(RecCount()))
		oMeter:Set(0)
	EndIf
	dbSetOrder(3)

	// Posiciona na primeira conta analitica
	MsSeek(xFilial()+"2"+cEntidIni,.T.)

	While !Eof() .And. CT1->CT1_FILIAL == xFilial() .And.;
			CT1->CT1_CONTA <= cEntidFim .And. CT1_CLASSE != "1"
			
		If ValType(oMeter) == "O"			
			nMeter++
    		oMeter:Set(nMeter)				
   		EndIf

		// Grava conta analitica
		cConta 	:= CT1->CT1_CONTA

		// Conta nao pertencera ao arquivo pois sera filtrado pelo Set Of Book 
		// Escolhido 
		If !Empty(aSetOfBook[1])
			If !(aSetOfBook[1] $ CT1->CT1_BOOK)
				dbSkip()
				Loop
			EndIf
		EndIf				
	
		If !Empty(cSegmento)
			If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
				If  !(Substr(CT1->CT1_CONTA,nPos,nDigitos) $ (cFiltSegm) ) 
					dbSkip()
					Loop
				EndIf	
			Else
				If Substr(CT1->CT1_CONTA,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
					Substr(CT1->CT1_CONTA,nPos,nDigitos) > Alltrim(cSegFim)
					dbSkip()
					Loop
				EndIf	
			Endif
		EndIf	
	
		cDesc 		:= &("CT1->CT1_DESC"+cMoeda)
		If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
			cDesc 	:= CT1->CT1_DESC01
		Endif
		nTamDesc    := Len(CriaVar("CT1->CT1_DESC"+cMoeda))
		dbSelectArea("cArqTmp")
		dbSetOrder(1)	
		If !MsSeek(xFilial()+cConta)
			dbAppend()
			Replace CONTA 		With cConta
			Replace DESCCTA		With cDesc
			Replace TIPOCONTA 	With CT1->CT1_CLASSE
			Replace CTARES    	With CT1->CT1_RES
			Replace NORMAL    	With CT1->CT1_NORMAL
			Replace GRUPO		With CT1->CT1_GRUPO
			Replace ESTOUR 		With CT1->CT1_ESTOUR
		EndIf

		If lFiliais	//Se for Comparativo por Filiais
			nTotVezes := Len(aFiliais)		
		EndIf
		
		If lMeses	//Se for Comparativo por Mes
			nTotVezes := Len(aMeses)
		EndIf
		
		For nVezes := 1 to nTotVezes
			If lFiliais
				aSaldoAnt := SaldoCT7(cConta,dDataIni,cMoeda,cSaldos,'CTBXFUN',lImpAntLP,dDataLP,aFiliais[nVezes])
				aSaldoAtu := SaldoCT7(cConta,dDataFim,cMoeda,cSaldos,'CTBXFUN',lImpAntLP,dDataLP,aFiliais[nVezes])
			EndIf
			
			If lMeses
				aSaldoAnt := SaldoCT7(cConta,aMeses[nVezes][2],cMoeda,cSaldos,'CTBXFUN',lImpAntLP,dDataLP)
				aSaldoAtu := SaldoCT7(cConta,aMeses[nVezes][3],cMoeda,cSaldos,'CTBXFUN',lImpAntLP,dDataLP)			
			EndIf
		
			For nCont := 1 To Len(aSaldoAnt)
				aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
			Next nCont
				
			For nCont := 1 To Len(aSaldoAtu)
				aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
			Next nCont
			
			nSaldoAntD 	:= aSaldoAnt[7]
			nSaldoAntC 	:= aSaldoAnt[8]
	
   			nSaldoAtuD 	:= aSaldoAtu[4]
			nSaldoAtuC 	:= aSaldoAtu[5] 

			nSaldoDeb  := nSaldoAtuD - nSaldoAntD
			nSaldoCrd  := nSaldoAtuC - nSaldoAntC			

			dbSelectArea("cArqTmp")
			dbSetOrder(1)
			If cTpVlr == 'M'
				&("COLUNA"+Alltrim(Str(nVezes,2))) := (nSaldoCrd-nSaldoDeb)
				AADD(aMovimento,(nSaldoCrd-nSaldoDeb))				
			ElseIf cTpVlr == 'S'
				&("COLUNA"+Alltrim(Str(nVezes,2))) := (nSaldoAtuC-nSaldoAtuD)			
				AADD(aMovimento,(nSaldoAtuC-nSaldoAtuD))								
			EndIf
			aSaldoAnt	:= {}
			aSaldoAtu	:= {}		
		Next			
		
		// Grava contas sinteticas		
		dbSelectArea("CT1")
		If ValType(oMeter) == "O"		
			oMeter:SetTotal(CT1->(RecCount()))
			oMeter:Set(0)
		EndIf
		dbSetOrder(1)
		
		nReg := Recno()
		cContaSup := CT1->CT1_CTASUP
		If Empty(cContaSup)
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea("CT1")
		EndIf		
		MsSeek(xFilial()+cContaSup)
		
		While !Eof() .And. CT1->CT1_FILIAL == xFilial()
			If ValType(oMeter) == "O"
				nMeter++
		    	oMeter:Set(nMeter)				
		  	EndIf
			cDesc := &("CT1->CT1_DESC"+cMoeda)
			If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
				cDesc := CT1->CT1_DESC01
			Endif

			dbSelectArea("cArqTmp")
			dbSetOrder(1)
			If !MsSeek(cContaSup)
				dbAppend()
				Replace CONTA		With cContaSup
				Replace DESCCTA		With cDesc
				Replace TIPOCONTA	With CT1->CT1_CLASSE
				Replace CTARES    	With CT1->CT1_RES
				Replace NORMAL   	With CT1->CT1_NORMAL
				Replace GRUPO		With CT1->CT1_GRUPO
				Replace ESTOUR 		With CT1->CT1_ESTOUR
			EndIf      
			                         
			For nVezes := 1 to nTotVezes
				If cTpVlr == 'M'
					Replace &("COLUNA"+	Alltrim(Str(nVezes,2))) With (&("COLUNA"+Alltrim(Str(nVezes,2)))+aMovimento[nVezes])
				ElseIf cTpVlr == 'S'					
					Replace &("COLUNA"+	Alltrim(Str(nVezes,2))) With (&("COLUNA"+Alltrim(Str(nVezes,2)))+aMovimento[nVezes])
				EndIf
   	    	Next
			
			dbSelectArea("CT1")
			cContaSup := CT1->CT1_CTASUP
			If Empty(CT1->CT1_CTASUP)
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea("CT1")
				Exit
			EndIf		
			MsSeek(xFilial()+cContaSup)
		EndDo  		
		aMovimento	:= {}    	
		dbSelectArea("CT1")
		dbSetOrder(3)
		dbGoTo(nReg)
		dbSkip()
	EndDo	
	               
ElseIf cAlias == "CTU"      
	If cIdent	== "CTT"
		nOrdem	:= 2 
		cCodigo	:= "CUSTO"
		cEntSup	:= "CCSUP"
	EndIf

	dbSelectArea(cIdent)
	If ValType(oMeter) == "O"    		
		oMeter:SetTotal((cIdent)->(RecCount()))
		oMeter:Set(0)
	EndIf
	dbSetOrder(nOrdem)

	// Posiciona na primeira conta analitica
	MsSeek(xFilial()+"2"+cEntidIni,.T.)

	While !Eof() .And. CTT->CTT_FILIAL == xFilial() .And.;
		&(cIdent + "_" + cCodigo) <= cEntidFim .And. &(cIdent + "_CLASSE" ) <> "1"

		If ValType(oMeter) == "O"    				
			nMeter++
    		oMeter:Set(nMeter)				
   		EndIf

		// Grava conta analitica
		cCodEnt 	:= &(cIdent + "_" + cCodigo)

		// Conta nao pertencera ao arquivo pois sera filtrado pelo Set Of Book 
		// Escolhido 
		If !Empty(aSetOfBook[1])
			If !(aSetOfBook[1] $ (cIdent)->&(cIdent + "_BOOK"))
				dbSkip()
				Loop
			EndIf
		EndIf		
	
		If !Empty(cSegmento)
			If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
				If  !(Substr(cCodEnt,nPos,nDigitos) $ (cFiltSegm) ) 
					dbSkip()
					Loop
				EndIf	
			Else
				If Substr(cCodEnt,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
					Substr(cCodEnt,nPos,nDigitos) > Alltrim(cSegFim)
					dbSkip()
					Loop
				EndIf	
			Endif
		EndIf	
	
		cDescEnt	:= (cIdent)->&(cIdent+"_DESC"+cMoeda)
		
		If Empty(cDescEnt)	// Caso nao preencher descricao da moeda selecionada
			cDescEnt	:= (cIdent)->&(cIdent+"_DESC01")		
		Endif
		
		nTamDesc    := Len(CriaVar(cIdent+"_DESC"+cMoeda))
		
		dbSelectArea("cArqTmp")
		dbSetOrder(1)	
		If !MsSeek(xFilial()+cCodEnt)
			dbAppend()              
			If cIdent	== "CTT"
				Replace CUSTO 		With cCodent
				Replace DESCCC		With cDescEnt
				Replace TIPOCC	 	With CTT->CTT_CLASSE
				Replace CCRES     	With CTT->CTT_RES
			EndIf
		EndIf

		If lFiliais	//Se for Comparativo por Filiais
			nTotVezes := Len(aFiliais)		
		EndIf
		
		If lMeses	//Se for Comparativo por Mes
			nTotVezes := Len(aMeses)
		EndIf
		
		For nVezes := 1 to nTotVezes
			If lFiliais
				aSaldoAnt := SaldoCTU(cIdent,cCodEnt,dDataIni,cMoeda,cSaldos,,lImpAntLP,dDataLP,aFiliais[nVezes])
				aSaldoAtu := SaldoCTU(cIdent,cCodEnt,dDataFim,cMoeda,cSaldos,,lImpAntLP,dDataLP,aFiliais[nVezes])
			EndIf
			
			If lMeses
				aSaldoAnt := SaldoCTU(cIdent,cCodEnt,dDataIni,cMoeda,cSaldos,,lImpAntLP,dDataLP)
				aSaldoAtu := SaldoCTU(cIdent,cCodEnt,dDataFim,cMoeda,cSaldos,,lImpAntLP,dDataLP)			
			EndIf
		
			For nCont := 1 To Len(aSaldoAnt)
				aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
			Next nCont
				
			For nCont := 1 To Len(aSaldoAtu)
				aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
			Next nCont
			
			nSaldoAntD 	:= aSaldoAnt[7]
			nSaldoAntC 	:= aSaldoAnt[8]
	
   			nSaldoAtuD 	:= aSaldoAtu[4]
			nSaldoAtuC 	:= aSaldoAtu[5] 

			nSaldoDeb  := nSaldoAtuD - nSaldoAntD
			nSaldoCrd  := nSaldoAtuC - nSaldoAntC			

			dbSelectArea("cArqTmp")
			dbSetOrder(1)
			If cTpVlr == 'M'
				&("COLUNA"+Alltrim(Str(nVezes,2))) := (nSaldoCrd-nSaldoDeb)
				AADD(aMovimento,(nSaldoCrd-nSaldoDeb))				
			ElseIf cTpVlr == 'S'
				&("COLUNA"+Alltrim(Str(nVezes,2))) := (nSaldoAtuC-nSaldoAtuD)			
				AADD(aMovimento,(nSaldoAtuC-nSaldoAtuD))								
			EndIf
			aSaldoAnt	:= {}
			aSaldoAtu	:= {}		
		Next			
		
		// Grava contas sinteticas		
		dbSelectArea(cIdent)
		If ValType(oMeter) == "O"    			
			oMeter:SetTotal((cIdent)->(RecCount()))
			oMeter:Set(0)
		EndIf
		dbSetOrder(1)
		
		nReg := Recno()
		
		cCodEntSup	:= (cIdent)->&(cIdent+"_"+cEntSup)			

		If Empty(cCodEntSup)
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea(cIdent)
		EndIf		
		MsSeek(xFilial()+cCodEntSup)
		
		While !Eof() .And. (cIdent)->&(cIdent+"_FILIAL")== xFilial()
		
			If ValType(oMeter) == "O"    	
				nMeter++
	    		oMeter:Set(nMeter)				
	   		EndIf
			cDescEnt	:= (cIdent)->&(cIdent+"_DESC"+cMoeda)
			
			If Empty(cDescEnt)	// Caso nao preencher descricao da moeda selecionada
				cDescEnt	:= (cIdent)->&(cIdent+"_DESC01")		
			Endif	   		

			dbSelectArea("cArqTmp")
			dbSetOrder(1)
			If !MsSeek(cCodEntSup)			
				dbAppend()
				If cIdent	== "CTT"
					Replace CUSTO 		With cCodentSup
					Replace DESCCC		With cDescEnt
					Replace TIPOCC	 	With CTT->CTT_CLASSE
					Replace CCRES     	With CTT->CTT_RES
				EndIf				
			EndIf      
			                         
			For nVezes := 1 to nTotVezes
				If cTpVlr == 'M'
					Replace &("COLUNA"+	Alltrim(Str(nVezes,2))) With (&("COLUNA"+Alltrim(Str(nVezes,2)))+aMovimento[nVezes])
				ElseIf cTpVlr == 'S'					
					Replace &("COLUNA"+	Alltrim(Str(nVezes,2))) With (&("COLUNA"+Alltrim(Str(nVezes,2)))+aMovimento[nVezes])
				EndIf
   	    	Next
			
			dbSelectArea(cIdent)
			cCodEntSup	:= (cIdent)->&(cIdent+"_"+cEntSup)			

			If Empty((cIdent)->(cIdent+"_"+cCodEntSup))
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea(cIdent)
				Exit
			EndIf		
			MsSeek(xFilial()+cCodEntSup)
		EndDo  		
		aMovimento	:= {}    	
		dbSelectArea(cIdent)
		dbSetOrder(nOrdem)
		dbGoTo(nReg)
		dbSkip()
	EndDo	

EndIf
RestArea(aSaveArea)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtCmpComp ³ Autor ³ Simone Mie Sato       ³ Data ³ 09.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Balancetes Entidade1/Entidade2³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oMeter                                      ³±±
±±³          ³ ExpO2 = Objeto oText                                       ³±±
±±³          ³ ExpO3 = Objeto oDlg                                        ³±±
±±³          ³ ExpL1 = lEnd                                               ³±±
±±³          ³ ExpD1 = Data Inicial                                       ³±±
±±³          ³ ExpD2 = Data Final                                         ³±±
±±³          ³ ExpC1 = Conta Inicial                                      ³±±
±±³          ³ ExpC2 = Conta Final                                        ³±±
±±³          ³ ExpC3 = Classe de Valor Inicial                            ³±±
±±³          ³ ExpC4 = Classe de Valor Final                              ³±±
±±³          ³ ExpC5 = Moeda		                                      ³±±
±±³          ³ ExpC6 = Saldo	                                          ³±±
±±³          ³ ExpA1 = Set Of Book	                                      ³±±
±±³          ³ ExpN1 = Tamanho da descricao da conta	                  ³±±
±±³          ³ ExpC7 = Ate qual segmento sera impresso (nivel)			  ³±±
±±³          ³ ExpC8 = Filtra por Segmento		                          ³±±
±±³          ³ ExpC9 = Segmento Inicial		                              ³±±
±±³          ³ ExpC10= Segmento Final  		                              ³±±
±±³          ³ ExpC11= Segmento Contido em  	                          ³±±
±±³          ³ ExpL12= Se imprime total acumulado	                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                       
Function CtCmpComp(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cAlias,lCusto,lItem,lClvl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,;
				cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado)
				         
Local aSaveArea 	:= GetArea()
Local cMascara1 	:= ""
Local cMascara2		:= ""
Local nPos			:= 0
Local nDigitos		:= 0
Local cEntid1		:= ""	//Codigo da Entidade Principal
Local cEntid2   	:= "" 	//Codigo da Entidade do Corpo do Relatorio              
Local nSaldoDeb 	:= 0
Local nSaldoCrd 	:= 0
Local nSaldoAntD	:= 0
Local nSaldoAntC	:= 0
Local nSaldoAtuD	:= 0
Local nSaldoAtuC	:= 0
Local nRegTmp   	:= 0
Local nOrder		:= 0
Local cChave		:= ""
Local bCond1		:= {||.F.}
Local bCond2		:= {||.F.}
Local cCadAlias1	:= ""	//Alias do Cadastro da Entidade Principal
Local cCadAlias2	:= ""	//Alias do Cadastro da Entidade que sera impressa no corpo.
Local cCodEnt1		:= ""	//Codigo da Entidade Principal
Local cCodEnt2		:= ""	//Codigo da Entidade que sera impressa no corpo do relat.
Local cDesc1		:= ""
Local cDesc2		:= ""
Local cDescEnt		:= ""
Local cDescEnt1		:= ""	//Descricao da Entidade Principal                           
Local cDescEnt2		:= ""	//Descricao da Entidade que sera impressa no corpo.                          
Local cCodSup1		:= ""	//Cod.Superior da Entidade Principal
Local cCodSup2		:= ""	//Cod.Superior da Entidade que sera impressa no corpo.
Local nRecno1		:= ""
Local nRecno2		:= ""
Local nTamDesc1		:= ""
Local nTamDesc2		:= ""
Local cOrigem		:= ""
Local cMensagem		:= OemToAnsi(STR0016)+ OemToAnsi(STR0017)
Local dMinData	                                      
Local nTotVezes		:= 0
Local nCont			:= 0 
Local nVezes		:= 0 
Local nTotal		:= 0
Local aMovimento	:= {0,0,0,0,0,0}
Local nMeter		:= 0

lFiliais			:= Iif(lFiliais == Nil,.F.,lFiliais)
aFiliais			:= Iif(aFiliais==Nil,{},aFiliais)	
lMeses				:= Iif(lMeses == NIl, .F.,lMeses)
aMeses				:= Iif(aMeses==Nil,{},aMeses)
nDivide 			:= Iif(nDivide == Nil,1,nDivide)
lVlrZerado			:= Iif(lVlrZerado == Nil,.T.,lVlrZerado)

Do Case
Case cAlias == 'CT3'    
	If cHeader == 'CTT'
		cCadAlias1	:= 'CTT'
		cCadAlias2	:= 'CT1'
		cCodEnt1	:= 'CUSTO' 
		cCodEnt2	:=	'CONTA'
		cCodSup1	:= 'CCSUP'
		cCodSup2	:= 'CTASUP'		
		cMascara1	:= aSetOfBook[6]	//Mascara do Centro de Custo
		cMascara2	:= aSetOfBook[2]	//Mascara da Conta
		nTamDesc1	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CT1->CT1_DESC"+cMoeda))		
		cDescEnt	:= "DESCCC"	
	EndIf
Case cAlias == 'CTV'     
	cOrigem		:= 'CT4'	
	If cHeader == 'CTT'		//Se for C.Custo/Item
		nOrder 		:= 2
		cCadAlias1	:= 'CTT'
		cCadAlias2	:= 'CTD'
		cCodEnt1	:= 'CUSTO' 
		cCodEnt2	:=	'ITEM'
		cCodSup1	:= 'CCSUP'
		cCodSup2	:= 'ITSUP'		
		cMascara1	:= aSetOfBook[6]	//Mascara do Centro de Custo
		cMascara2	:= aSetOfBook[7]	//Mascara do Item
		nTamDesc1	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))		
		cDescEnt	:= "DESCCC"
		
	ElseIf cHeader == 'CTD' 	//Se for Item/C.Custo                              	
		nOrder 		:= 1	
		cCadAlias1	:= 'CTD'
		cCadAlias2	:= 'CTT'
		cCodEnt1	:= 'ITEM' 
		cCodEnt2	:= 'CUSTO'
		cCodSup1	:= 'ITSUP'
		cCodSup2	:= 'CCSUP'
		cMascara1	:= aSetOfBook[7]	//Mascara do Item	
		cMascara2	:= aSetOfBook[6]	//Mascara do Centro de Custo
		nTamDesc1	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))	
		cDescEnt	:= "DESCITEM"
	EndIf	
Case cAlias == 'CTW'	
	cOrigem		:= 'CTI'	
	If cHeader == 'CTH'//Se for Cl.Valor/C.Custo
		nOrder 		:= 1      
		cCadAlias1	:= 'CTH'	
		cCadAlias2	:= 'CTT'
		cCodEnt1	:= 'CLVL'  
		cCodEnt2	:= 'CUSTO'
		cCodSup1	:= 'CLSUP'
		cCodSup2	:= 'CCSUP'
		cMascara1	:= aSetOfBook[8]	//Mascara da Classe de Valor
		cMascara2	:= aSetOfBook[6]	//Mascara do Centro de Custo
		nTamDesc1	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))				
		cDescEnt	:= "DESCCLVL"		
	ElseIf cHeader == 'CTT'//Se for C.Custo/Cl.Valor
		nOrder 		:= 2      
		cCadAlias1	:= 'CTT'
		cCadAlias2	:= 'CTH'			
		cCodEnt1	:= 'CUSTO'  
		cCodEnt2	:= 'CLVL'
		cCodSup1  	:= 'CCSUP'
		cCodSup2	:= 'CLSUP'
		cMascara1	:= aSetOfBook[6]	//Mascara do Centro de Custo
		cMascara2	:= aSetOfBook[8]	//Mascara da Classe de Valor	
		nTamDesc1	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))		
		cDescEnt	:= "DESCCC"		
	EndIf
Case cAlias == 'CTX'   
	cOrigem		:= 'CTI'	 
	If cHeader == 'CTH'//Se for Cl.Valor/Item
		nOrder 		:= 2      
		cCadAlias1	:= 'CTH'
		cCadAlias2	:= 'CTD'
		cCodEnt1	:= 'CLVL'
		cCodEnt2	:= 'ITEM'
		cCodSup1	:= 'CLSUP'      
		cCodSup2	:= 'ITSUP'
		cMascara1	:= aSetOfBook[8]	//Mascara da Cl.Valor
		cMascara2	:= aSetOfBook[7]	//Mascara do Item Contab.
		nTamDesc1	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))				
		cDescEnt	:= "DESCCLVL"		
	ElseIf cHeader == 'CTD'//Se for Item/Cl.Valor
		nOrder		:= 1
		cCadAlias1	:= 'CTD'
		cCadAlias2	:= 'CTH'
		cCodEnt1	:=	'ITEM'
		cCodEnt2	:=	'CLVL'
		cCodSup1  	:=	'ITSUP'
		cCodSup2	:=	'CLSUP'
		cMascara1	:= aSetOfBook[7]	//Mascara do Item Contab.
		cMascara2	:= aSetOfBook[8]	//Mascara da Cl.Valor
		nTamDesc1	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))				
		cDescEnt	:= "DESCITEM"		
	EndIf
EndCase

cChave 		:= xFilial(cAlias)+cMoeda+cSaldos+cEntidIni1+cEntidIni2+dtos(dDataIni)
//bCond		:= {||&(cAlias+"->"+cAlias+"_FILIAL") == xFilial(cAlias) .And.	&(cAlias+"->"+cAlias+"_"+cCodEnt1) >= cEntidIni1 .And. &(cAlias+"->"+cAlias+"_"+cCodEnt1) <= cEntidFim1 }
bCond1		:= {||&(cCadAlias1+"->"+cCadAlias1+"_FILIAL") == xFilial(cCadAlias1) .And. &(cCadAlias1+"->"+cCadAlias1+"_"+cCodEnt1) >= cEntidIni1 .And. &(cCadAlias1+"->"+cCadAlias1+"_"+cCodEnt1) <= cEntidFim1 }
bCond2		:= {||&(cCadAlias2+"->"+cCadAlias2+"_FILIAL") == xFilial(cCadAlias2) .And. &(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2) >= cEntidIni2 .And. &(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2) <= cEntidFim2 }


If cAlias <> "CT3"
	//Verificar se tem algum saldo a ser atualizado
	Ct360Data(cOrigem,,@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt)

	//Se o parametro MV_SLDCOMP estiver com "S",isto e, se devera atualizar os saldos compost.
	//na emissao dos relatorios, verifica se tem algum registro desatualizado e atualiza as
	//tabelas de saldos compostos.

	If lAtSldCmp .And. !Empty(dMinData)	//Se atualiza saldos compostos
		oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cSaldos,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt)},"","",.F.)
		oProcess:Activate()	
	Else		//Se nao atualiza os saldos compostos, somente da mensagem
		If !Empty(dMinData)
			MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
											//atraves da rotina de saldos compostos	
			Return
		EndIf    
	EndIf
EndIf

// Verifica Filtragem por Segmento da Entidade
If !Empty(cSegmento)
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cMascara2)
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascara2
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == cSegmento
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	EndIf	
EndIf		

dbSelectarea(cCadAlias1)
If ValType(oMeter) == "O"
	oMeter:SetTotal((cCadAlias1)->(RecCount()))
	oMeter:Set(0)
EndIf
dbSetOrder(1)
MsSeek(xFilial()+cEntidIni1,.T.)
                                                       
While !Eof() .And. Eval(bCond1)	
	If ValType(oMeter) == "O"
		nMeter++
   		oMeter:Set(nMeter)				
  	EndIf
		
	If &(cCadAlias1+"->"+cCadAlias1+"_CLASSE") <> '2'	//Se for sintetico
		dbSkip()
		Loop
	Endif
	
	//Verifico Set of Book da Entidade Principal	
	If !Empty(aSetOfBook[1])	
		If !(aSetOfBook[1] $ &(cCadAlias1+"->"+cCadAlias1+"_BOOK"))
			dbSkip()
			Loop
		EndIf
    EndIf
    
    cDescEnt1	:= (cCadAlias1+"->"+cCadAlias1+"_DESC")
	cDesc1 		:= &(cDescEnt1+cMoeda)	                     
	If Empty(cDesc1)	// Caso nao preencher descricao da moeda selecionada
		cDesc1 	:= &(cDescEnt1+"01")
	Endif
	cEntid1		:= &(cCadAlias1+"->"+cCadAlias1+"_"+cCodent1)		
	nRecno1		:= Recno()	
	
    dbSelectArea(cCadAlias2)
    dbSetOrder(1)
    MsSeek(xFilial()+cEntidIni2,.T.)
	
	While !Eof() .And. Eval(bCond2) 
	
		If &(cCadAlias2+"->"+cCadAlias2+"_CLASSE") <> '2'	//Se for sintetico
			dbSkip()
			Loop
		Endif
		                                
		//Verifico Set of Book da Entidade do Corpo do Relatorio	
		If !Empty(aSetOfBook[1])			
			If !(aSetOfBook[1] $ &(cCadAlias2+"->"+cCadAlias2+"_BOOK"))
				dbSkip()
				Loop
			EndIf
		EndIf

		//Caso faca filtragem por segmento de item,verifico se esta dentro 
		//da solicitacao feita pelo usuario. 
		If !Empty(cSegmento)
			If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
				If  !(Substr(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2),nPos,nDigitos) $ (cFiltSegm) ) 
					dbSkip()
					Loop
				EndIf	
			Else
				If Substr(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2),nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
					Substr(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2),nPos,nDigitos) > Alltrim(cSegFim)
					dbSkip()
					Loop
				EndIf	
			Endif
		EndIf	                                        
		
		cEntid2		:= &(cCadAlias2+"->"+cCadAlias2+"_"+cCodent2)	                               
		cDescEnt2	:= (cCadAlias2+"->"+cCadAlias2+"_DESC")
		cDesc2 		:= &(cDescEnt2+cMoeda)	                 		
		If Empty(cDesc2)	// Caso nao preencher descricao da moeda selecionada		
			cDesc2 	:= &(cDescEnt2+"01")
		Endif
		nRecno2		:= Recno()    
	
		If lFiliais	//Se for Comparativo por Filiais
			nTotVezes := Len(aFiliais)		
		EndIf
		
		If lMeses	//Se for Comparativo por Mes
			nTotVezes := Len(aMeses)
		EndIf

		nRecno := &(cAlias)->(Recno())    
	
		For nVezes := 1 to nTotVezes
			If lFiliais                                                                                              				
				aSaldoAnt := SldCmpEnt(cEntid1,cEntid2,dDataIni,cMoeda,cSaldos,nOrder,cHeader,cAlias,,,lImpAntLP,dDataLP,aFiliais[nVezes])
				aSaldoAtu := SldCmpEnt(cEntid1,cEntid2,dDataFim,cMoeda,cSaldos,nOrder,cHeader,cAlias,,,lImpAntLP,dDataLP,aFiliais[nVezes])
			EndIf
		
			If lMeses			
				If cAlias == "CT3"
					aSaldoAnt := SaldoCT3(cEntid2,cEntid1,aMeses[nVezes][2],cMoeda,cSaldos,,lImpAntLP,dDataLP)
					aSaldoAtu := SaldoCT3(cEntid2,cEntid1,aMeses[nVezes][3],cMoeda,cSaldos,,lImpAntLP,dDataLP)
				Else
					aSaldoAnt := SldCmpEnt(cEntid1,cEntid2,aMeses[nVezes][2],cMoeda,cSaldos,nOrder,cHeader,cAlias,,,lImpAntLP,dDataLP)
					aSaldoAtu := SldCmpEnt(cEntid1,cEntid2,aMeses[nVezes][3],cMoeda,cSaldos,nOrder,cHeader,cAlias,,,lImpAntLP,dDataLP)
				EndIf
			EndIf
		
			If nDivide > 1	
				For nCont := 1 To Len(aSaldoAnt)
					aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
				Next nCont
				
				For nCont := 1 To Len(aSaldoAtu)
					aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
				Next nCont
	    	EndIf
    	
			nSaldoAntD 	:= aSaldoAnt[7]
			nSaldoAntC 	:= aSaldoAnt[8]

   			nSaldoAtuD 	:= aSaldoAtu[4]
			nSaldoAtuC 	:= aSaldoAtu[5] 
   	
  			nSaldoDeb  := nSaldoAtuD - nSaldoAntD
			nSaldoCrd  := nSaldoAtuC - nSaldoAntC
			
			If !lVlrZerado
		    	If (nSaldoCrd - nSaldoDeb) == 0	//Se o movimento do periodo for zero.
					Loop	
		    	EndIf	
		    EndIf	      
		    
			cSeek	:= cEntid1+cEntid2		
			
			dbSelectArea("cArqTmp")
			dbSetOrder(1)	
			If !MsSeek(cSeek)
				dbAppend()   
				Do Case
				Case cAlias == 'CT3'		//Se for Centro de Custo/Conta
					If cHeader == 'CTT'
						Replace CUSTO   	With cEntid1
						Replace DESCCC		With cDesc1
						Replace TIPOCC 		With CTT->CTT_CLASSE			
						Replace CCSUP 		With CTT->CTT_CCSUP	
						Replace CCRES		With CTT->CTT_RES	
						Replace CONTA		With cEntid2
						Replace DESCCTA 	With cDesc2
						Replace TIPOCONTA	With CT1->CT1_CLASSE
						Replace CTASUP 		With CT1->CT1_CTASUP	
						Replace CTARES 		With CT1->CT1_RES								
				    EndIF
				Case cAlias == 'CTV'      
					If cHeader	== 'CTT'	//Se for Centro de Custo/Item
						Replace CUSTO   	With cEntid1
						Replace DESCCC		With cDesc1
						Replace TIPOCC 		With CTT->CTT_CLASSE			
						Replace CCSUP 		With CTT->CTT_CCSUP	
						Replace CCRES		With CTT->CTT_RES	
						Replace ITEM 		With cEntid2
						Replace DESCITEM	With cDesc2
						Replace TIPOITEM 	With CTD->CTD_CLASSE
						Replace ITSUP  		With CTD->CTD_ITSUP		
						Replace ITEMRES		With CTD->CTD_RES			
					ElseIf cHeader == 'CTD'	//Se for Item/C.Custo
						Replace ITEM 		With cEntid1
						Replace DESCITEM	With cDesc1
						Replace TIPOITEM 	With CTD->CTD_CLASSE
						Replace ITSUP  		With CTD->CTD_ITSUP		
						Replace ITEMRES		With CTD->CTD_RES					
						Replace CUSTO   	With cEntid2
						Replace DESCCC		With cDesc2
						Replace TIPOCC 		With CTT->CTT_CLASSE			
						Replace CCSUP 		With CTT->CTT_CCSUP	
						Replace CCRES		With CTT->CTT_RES	
					EndIf			
				Case cAlias == 'CTW'
					If cHeader	== 'CTH'		//Se for Cl.Valor/C.Custo
						Replace CLVL    	With cEntid1
						Replace DESCCLVL	With cDesc1
						Replace TIPOCLVL 	With CTH->CTH_CLASSE
						Replace CLSUP    	With CTH->CTH_CLSUP
						Replace CLVLRES		With CTH->CTH_RES
						Replace CUSTO   	With cEntid2
						Replace DESCCC		With cDesc2
						Replace TIPOCC 		With CTT->CTT_CLASSE			
						Replace CCSUP 		With CTT->CTT_CCSUP	
						Replace CCRES		With CTT->CTT_RES				                        	
					ElseIf cHeader	== 'CTT'	//Se for C.Custo/Cl.Valor
						Replace CUSTO   	With cEntid1
						Replace DESCCC		With cDesc1
						Replace TIPOCC 		With CTT->CTT_CLASSE			
						Replace CCSUP 		With CTT->CTT_CCSUP	
						Replace CCRES		With CTT->CTT_RES				                        	
						Replace CLVL    	With cEntid2
						Replace DESCCLVL	With cDesc2
						Replace TIPOCLVL 	With CTH->CTH_CLASSE
						Replace CLSUP    	With CTH->CTH_CLSUP
						Replace CLVLRES		With CTH->CTH_RES			
					EndIf
				Case cAlias == 'CTX'                   
					If cHeader == 'CTH'	//Se for Cl.Valor/Item
						Replace CLVL    	With cEntid1
						Replace DESCCLVL	With cDesc1
						Replace TIPOCLVL 	With CTH->CTH_CLASSE
						Replace CLSUP    	With CTH->CTH_CLSUP
						Replace CLVLRES		With CTH->CTH_RES
						Replace ITEM		With cEntid2
						Replace DESCITEM	With cDesc2
						Replace TIPOITEM 	With CTD->CTD_CLASSE
						Replace ITSUP  		With CTD->CTD_ITSUP		
						Replace ITEMRES		With CTD->CTD_RES					
					ElseIf cHeader	== 'CTD'	//Se for Item/Cl.Valor
						Replace ITEM		With cEntid1
						Replace DESCITEM	With cDesc1
						Replace TIPOITEM 	With CTD->CTD_CLASSE
						Replace ITSUP  		With CTD->CTD_ITSUP		
						Replace ITEMRES		With CTD->CTD_RES					
						Replace CLVL    	With cEntid2
						Replace DESCCLVL	With cDesc2
						Replace TIPOCLVL 	With CTH->CTH_CLASSE
						Replace CLSUP    	With CTH->CTH_CLSUP
						Replace CLVLRES		With CTH->CTH_RES			
					Endif
				EndCase
			EndIf           
			   	
			If cTpVlr == 'M'
				&("COLUNA"+Alltrim(Str(nVezes,2))) := (nSaldoCrd-nSaldoDeb)
			EndIf
			aSaldoAnt	:= {}
			aSaldoAtu	:= {}		
		Next		
		
		dbSelectArea(cCadAlias2)
		dbSetOrder(1)
		dbGoto(nRecno2)
		dbSkip()       		
	Enddo              
	dbSelectarea(cCadAlias1)
	dbSetOrder(1)
	dbGoto(nRecno1)
	dbSkip()
EndDo
/*	
// Grava sinteticas
dbSelectArea("cArqTmp")	
oMeter:SetTotal(cArqTmp->(RecCount()))
oMeter:Set(0)
dbGoTop()  

While!Eof()                                                                         
	nMeter++
   	oMeter:Set(nMeter)				

	nRegTmp := Recno()             	
	aMovimento	:= {}
	For nVezes	:= 1 to nTotVezes
		Aadd(aMovimento, 0)               				
	Next
	
	For nVezes := 1 to nTotVezes
		aMovimento[nVezes] := &("COLUNA"+Alltrim(Str(nVezes,2)))
	Next
	
	dbSelectArea(cCadAlias2)
	dbSetOrder(1)      
	If Empty(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodSup2))
		dbSelectArea("cArqTmp")
		Replace NIVEL1 With .T.
		dbSelectArea(cCadAlias2)
	EndIf		
	MsSeek(xFilial(cCadAlias2)+ &("cArqTmp->"+cCodSup2))
		
	While !Eof() .And. &(cCadAlias2+"->"+cCadAlias2+"_FILIAL") == xFilial()

		cEntid1	 := &("cArqTmp->"+cCodEnt1)
		cDesc1	 := &("cArqTmp->"+cDescEnt)
		cEntSup2 := &(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2)
								
		cDescEnt2	:= (cCadAlias2+"->"+cCadAlias2+"_DESC")
		cDesc2		:= &(cDescEnt2+cMoeda)			        
		If Empty(cDesc2)	// Caso nao preencher descricao da moeda selecionada		
			cDesc2	:= &(cDescEnt2+"01")
		Endif

		cSeek 		:= cEntid1+cEntSup2
		
		dbSelectArea(cCadAlias1)
		dbSetOrder(1)
		MsSeek(xFilial(cCadAlias1)+cEntid1)
		
		dbSelectArea("cArqTmp")
		dbSetOrder(1)      
		If !MsSeek(cSeek)
			dbAppend()
			Do Case
			Case cAlias == 'CT3'
				If cHeader == 'CTT'
					Replace CUSTO   	With cEntid1
					Replace DESCCC		With cDesc1
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES	
					Replace CONTA		With cEntSup2
					Replace DESCCTA  	With cDesc2
					Replace TIPOCONTA	With CT1->CT1_CLASSE
					Replace CTASUP 		With CT1->CT1_CTASUP	
					Replace CTARES 		With CT1->CT1_RES							
			    EndIf
			Case cAlias == 'CTV'      
				If cHeader	== 'CTT'	//Se for Centro de Custo/Item
					Replace CUSTO   	With cEntid1
					Replace DESCCC		With cDesc1
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES	
					Replace ITEM 		With cEntSup2
					Replace DESCITEM	With cDesc2
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES			
				ElseIf cHeader == 'CTD'	//Se for Item/C.Custo
					Replace ITEM 		With cEntid1
					Replace DESCITEM	With cDesc1
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES					
					Replace CUSTO   	With cEntSup2
					Replace DESCCC		With cDesc2
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES	
				EndIf			
			Case cAlias == 'CTW'
				If cHeader	== 'CTH'		//Se for Cl.Valor/C.Custo
					Replace CLVL    	With cEntid1
					Replace DESCCLVL	With cDesc1
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES
					Replace CUSTO   	With cEntSup2
					Replace DESCCC		With cDesc2
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES				                        	
				ElseIf cHeader	== 'CTT'	//Se for C.Custo/Cl.Valor
					Replace CUSTO   	With cEntid1
					Replace DESCCC		With cDesc1
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES				                        	
					Replace CLVL    	With cEntSup2
					Replace DESCCLVL	With cDesc2
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES			
				EndIf
			Case cAlias == 'CTX'                   
				If cHeader == 'CTH'	//Se for Cl.Valor/Item
					Replace CLVL    	With cEntid1 
					Replace DESCCLVL	With cDesc1
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES
					Replace ITEM		With cEntSup2
					Replace DESCITEM	With cDesc2
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES					
				ElseIf cHeader	== 'CTD'	//Se for Item/Cl.Valor
					Replace ITEM		With cEntid1
					Replace DESCITEM	With cDesc1
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES					
					Replace CLVL    	With cEntSup2
					Replace DESCCLVL	With cDesc2
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES			
				Endif
			EndCase
			
		EndIf    
		
		For nVezes := 1 to nTotVezes
			If cTpVlr == 'M'
				Replace &("COLUNA"+Alltrim(Str(nVezes,2))) With (&("COLUNA"+Alltrim(Str(nVezes,2)))+aMovimento[nVezes])
			EndIf
    	Next
		
		dbSelectArea(cCadAlias2)
		If Empty(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodSup2))
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea(cCadAlias2)
			Exit                     						
		EndIf		

		dbSelectArea(cCadAlias2)
		MsSeek(xFilial(cCadAlias2)+ &("cArqTmp->"+cCodSup2))
	EndDo
	dbSelectArea("cArqTmp")
	dbGoto(nRegTmp)
	dbSkip()
EndDo
*/
RestArea(aSaveArea)

Return				

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTBGerCmp ³ Autor ³ Simone Mie Sato       ³ Data ³ 23.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Comparativo entre 2 Tipos de Saldos                         |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oMeter	= Objeto oMeter                                   ³±±
±±³          ³ oText	= Objeto oText                                    ³±±
±±³          ³ oDlg		= Objeto oDlg                                     ³±±
±±³          ³ lEnd 	= lEnd                                            ³±±
±±³          ³ cArqTmp	= Data Inicial                                    ³±±
±±³          ³ dDataIni = Data Final                                      ³±±
±±³          ³ dDataFim = Alias do Arquivo                                ³±±
±±³          ³ cArq1	= Arquivo Cadastro 1 (Principal)                  ³±±
±±³          ³ cArq2    = Arquivo Cadastro 2 (Auxiliar)                   ³±±
±±³          ³ cContaIni= Conta Inicial                                   ³±±
±±³          ³ cContaFim= Conta Final                                     ³±±
±±³          ³ cCCIni	= Centro de Custo Inicial                         ³±±
±±³          ³ cCCFim	= Centro de Custo Final                           ³±±
±±³          ³ cItemIni = Item Inicial                                    ³±±
±±³          ³ cItemFim = Item Final                                      ³±±
±±³          ³ cClVlIni = Classe de Valor Inicial                         ³±±
±±³          ³ cClvlFim = Classe de Valor Final                           ³±±
±±³          ³ cMoeda	= Moeda		                                      ³±±
±±³          ³ cTpSld1	= Tipo de Saldo 1                                 ³±±
±±³          ³ cTpSld2	= Tipo de Saldo 2                                 ³±±
±±³          ³ aSetOfBook= Set Of Book	                                  ³±±
±±³          ³ cSegmento = Filtra por Segmento		                      ³±±
±±³          ³ cSegIni	= Segmento Inicial		                          ³±±
±±³          ³ cSegFim	= Segmento Final  		                          ³±±
±±³          ³ cFiltSegm = Segmento Contido em  	                      ³±±
±±³          ³ lVariacao0 = Se Considera Variacao 0                       ³±±
±±³          ³ nDivide 	= Fator de Divisao   	                          ³±±
±±³          ³ bVariacao = Bloco de codigo para tratamentos especificos   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTBGerCmp(oMeter,oText,oDlg,lEnd,cArqtmp,;
					dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,;
					cMoeda,cTpSld1,cTpSld2,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					cSegAte,lVariacao0,nDivide,nGrupo,bVariacao,cIdent,lCt1Sint,cString,cFilUSU)
						
Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamCtaRes	:= TAMSX3("CT1_RES")
Local aTamCC        := TAMSX3("CTT_CUSTO")
Local aTamCCRes 	:= TAMSX3("CTT_RES")
Local aTamItem  	:= TAMSX3("CTD_ITEM")
Local aTamItRes 	:= TAMSX3("CTD_RES")    
Local aTamClVl  	:= TAMSX3("CTH_CLVL")
Local aTamCvRes 	:= TAMSX3("CTH_RES")
Local aCtbMoeda		:= {}
Local aSaveArea 	:= GetArea()
Local aCampos

Local cChave
Local cArqTmp1		:= ""
Local cEntidIni		:= ""
Local cEntidFim		:= ""                                         
Local cFilDe		:=  xFilial(cAlias)
Local cFilAte		:=  xFilial(cAlias)
Local cMensagem		:= ""
Local nMeter		:= 0
Local nTamCta 		:= Len(CriaVar("CT1_DESC"+cMoeda))
Local nTamItem		:= Len(CriaVar("CTD_DESC"+cMoeda))
Local nTamCC  		:= Len(CriaVar("CTT_DESC"+cMoeda))
Local nTamClVl		:= Len(CriaVar("CTH_DESC"+cMoeda))
Local nTamGrupo		:= Len(CriaVar("CT1_GRUPO"))
Local nDecimais		:= 0
Local nInicio		:= Val(cMoeda)
Local nFinal		:= Val(cMoeda)

Local lCusto		:= CtbMovSaldo("CTT")//Define se utiliza C.Custo
Local lItem 		:= CtbMovSaldo("CTD")//Define se utiliza Item
Local lClVl			:= CtbMovSaldo("CTH")//Define se utiliza Cl.Valor 
Local lAtSldBase	:= Iif(GetMV("MV_ATUSAL")== "S",.T.,.F.)   
Local lAtSldCmp		:= Iif(GetMV("MV_SLDCOMP")== "S",.T.,.F.)
Local lExistX2	:= .T.
Local aAreaX2	:= {}
Local lTemQry	:= .F.
Local nTRB		:= 1

#IFDEF TOP
	Local nMin			:= 0
	Local nMax			:= 0 
#ENDIF

lVariacao0	:= Iif(lVariacao0 == Nil,.F.,lVariacao0)

dMinData := CTOD("")

Default cIdent		:= ""
Default lCt1Sint 	:= .F.
Default cMoeda		:= "01"					//// SE NAO FOR INFORMADA A MOEDA ASSUME O PADRAO 01

nGrupo		:=	Iif(nGrupo == Nil,2,nGrupo)                                                 
// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := aCtbMoeda[5]

aCampos := {{ "CONTA"		, "C", aTamConta[1], 0 },;  			// Codigo da Conta
	 		 { "NORMAL"		, "C", 01			, 0 },;			// Situacao
			 { "CTARES"		, "C", aTamCtaRes[1], 0 },;  			// Codigo Reduzido da Conta
			 { "DESCCTA"	, "C", nTamCta		, 0 },;  			// Descricao da Conta
             { "CUSTO"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
			 { "CCRES"		, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
			 { "DESCCC" 	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
	         { "ITEM"		, "C", aTamItem[1]	, 0 },; 	 		// Codigo do Item          
			 { "ITEMRES" 	, "C", aTamItRes[1], 0 },;  			// Codigo Reduzido do Item
			 { "DESCITEM" 	, "C", nTamItem		, 0 },;  			// Descricao do Item
             { "CLVL"		, "C", aTamClVl[1]	, 0 },; 	 		// Codigo da Classe de Valor
             { "CLVLRES"	, "C", aTamCVRes[1], 0 },; 		 	// Cod. Red. Classe de Valor
			 { "DESCCLVL"   , "C", nTamClVl		, 0 },;  			// Descricao da Classe de Valor
			 { "MOVIMENTO1"	, "N", 17			, nDecimais},; 	// Movimento Tipo de Saldo 01
   		 	 { "MOVIMENTO2"	, "N", 17			, nDecimais},; 	// Movimento Tipo de Saldo 02
 			 { "VARIACAO" 	, "N", 17			, nDecimais},; 	// Variacao
			 { "TIPOCONTA"	, "C", 01			, 0 },;			// Conta Analitica / Sintetica           
 			 { "TIPOCC"  	, "C", 01			, 0 },;			// Centro de Custo Analitico / Sintetico
 			 { "TIPOITEM"	, "C", 01			, 0 },;			// Item Analitica / Sintetica			 
 			 { "TIPOCLVL"	, "C", 01			, 0 },;			// Classe de Valor Analitica / Sintetica			 
 			 { "CCSUP"		, "C", aTamCC[1]	, 0 },;			// Codigo do Centro de Custo Superior
			 { "ITSUP"		, "C", aTamItem[1]	, 0 },;			// Codigo do Item Superior
 			 { "CLSUP"	    , "C", aTamClVl[1] , 0 },;			// Codigo da Classe de Valor Superior
			 { "ORDEM"		, "C", 10			, 0 },;			// Ordem 	 
			 { "GRUPO"		, "C", nTamGrupo	, 0 },;			// Grupo Contabil
		     { "IDENTIFI"	, "C", 01			, 0 },;			 			 
			 { "NIVEL1"		, "L", 01			, 0 }}				// Logico para identificar se 
																	// eh de nivel 1 -> usado como

If bVariacao <> Nil
	Aadd(aCampos, { "COLUNA_1"	, "N", 17, nDecimais})
   	Aadd(aCampos, { "COLUNA_2"	, "N", 17, nDecimais})
Endif

///// TRATAMENTO PARA ATUALIZAÇÃO DE SALDO BASE
//Se os saldos basicos nao foram atualizados na dig. lancamentos
If !lAtSldBase
  	#IFDEF TOP
		If TcSrvType() != "AS/400"                     		  	
			//Chama Rotina de Atualizacao de Saldos Basicos.
			oProcess := MsNewProcess():New({|lEnd|	Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cTpSld1,.T.,cFilDe,cFilAte,,,.T.,oProcess,nMin,nMax)},"","",.F.)
			oProcess:Activate()						
			oProcess := MsNewProcess():New({|lEnd|	Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cTpSld2,.T.,cFilDe,cFilAte,,,.T.,oProcess,nMin,nMax)},"","",.F.)
			oProcess:Activate()				
		Else
	#ENDIF
		oProcess := MsNewProcess():New({|lEnd|	Ct360RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cTpSld1,oProcess,lAtSldBase)},"","",.F.)		
		oProcess:Activate()						
		oProcess := MsNewProcess():New({|lEnd|	Ct360RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cTpSld2,oProcess,lAtSldBase)},"","",.F.)				
		oProcess:Activate()									
	#IFDEF TOP
		EndIf
	#ENDIF
Endif	

//// TRATAMENTO PARA ATUALIZAÇÃO DE SALDOS COMPOSTOS ANTES DE EXECUTAR A QUERY DE FILTRAGEM
Do Case
Case cAlias == 'CTU'
	//Verificar se tem algum saldo a ser atualizado por entidade
	If cIdent == "CTT"
		cOrigem := 	'CT3'
	ElseIf cIdent == "CTD"
		cOrigem := 	'CT4'
	ElseIf cIdent == "CTH"
		cOrigem := 	'CTI'		
	Else
		cOrigem := 	'CTI'		
	Endif
Case cAlias == 'CTV'
	cOrigem := "CT4"
	//Verificar se tem algum saldo a ser atualizado
Case cAlias == 'CTW'			
	cOrigem		:= 'CTI'	/// HEADER POR CLASSE DE VALORES
	//Verificar se tem algum saldo a ser atualizado
Case cAlias == 'CTX'			
	cOrigem		:= 'CTI'		
EndCase	

IF cAlias$("CTU/CTV/CTW/CTX")
	Ct360Data(cOrigem,cAlias,@dMinData,lCusto,lItem,cFilDe,cFilAte,cTpSld1,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
	If lAtSldCmp .And. !Empty(dMinData)	//Se atualiza saldos compostos
		oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cTpSld1,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt)},"","",.F.)
		oProcess:Activate()	
	Else		//Se nao atualiza os saldos compostos, somente da mensagem
		If !Empty(dMinData)
			cMensagem	:= STR0016
			cMensagem	+= STR0017		
			MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
			Return							//atraves da rotina de saldos compostos	
		EndIf    
	EndIf
	
	Ct360Data(cOrigem,cAlias,@dMinData,lCusto,lItem,cFilDe,cFilAte,cTpSld2,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
	If lAtSldCmp .And. !Empty(dMinData)	//Se atualiza saldos compostos
		oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cTpSld2,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt)},"","",.F.)
		oProcess:Activate()	
	Else		//Se nao atualiza os saldos compostos, somente da mensagem
		If !Empty(dMinData)
			cMensagem	:= STR0016
			cMensagem	+= STR0017				
			MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
			Return							//atraves da rotina de saldos compostos	
		EndIf    
	EndIf
Endif
/// TRATAMENTO PARA OBTENÇÃO DO SALDO DAS CONTAS ANALITICAS
Do Case
Case cAlias  == "CT7"            
	cEntidIni	:= cContaIni
	cEntidFim	:= cContaFim
	If nGrupo == 2
		cChave := "CONTA"
	Else									// Indice por Grupo -> Totaliza por grupo
		cChave := "CONTA+GRUPO"
	EndIf	
	#IFDEF TOP
		/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
		If FunName() <> "CTBR380" .And. TcSrvType() != "AS/400"                     		
			Ct7CmpQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,;
							cMoeda,cTpSld1,cTpSld2,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
							cSegAte,lVariacao0,nDivide,nGrupo,bVariacao,cIdent,lCt1Sint,cString,cFILUSU)		   
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif
		Endif
	#ENDIF
Case cAlias == 'CT3'    
	cEntidIni	:= cCCIni
	cEntidFim	:= cCCFim
	cChave   := "CUSTO+CONTA"
	#IFDEF TOP                          
		If TcSrvType() != "AS/400"                     		
			/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
			CT3CmpQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,;
						cMoeda,cTpSld1,cTpSld2,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
						cSegAte,lVariacao0,nDivide,nGrupo,bVariacao,cIdent,lCt1Sint,cString,cFILUSU)
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif
		EndIf
	#ENDIF
Case cAlias =='CT4' 
	cEntidIni	:= cItemIni
	cEntidFim	:= cItemFim
	cChave   := "ITEM+CONTA"
Case cAlias == 'CTI'     
	cEntidIni	:= cClVlIni
	cEntidFim	:= cClvlFim
	cChave   := "CLVL+CONTA"
Case cAlias == 'CTU'
	If cIdent == 'CTT'
		cEntidIni	:= cCCIni
		cEntidFim	:= cCCFim	
		cChave		:= "CUSTO"
	ElseIf cIdent == 'CTD'
		cEntidIni	:= cItemIni
		cEntidFim	:= cItemFim		
		cChave   := "ITEM"
	ElseIf cIdent == 'CTH'
		cEntidIni	:= cClVlIni
		cEntidFim	:= cClvlFim		
		cChave   := "CLVL"
	Endif
	#IFDEF TOP
		If TcSrvType() != "AS/400"                     			
			CTUCmpQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,;
						cMoeda,cTpSld1,cTpSld2,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
						cSegAte,lVariacao0,nDivide,nGrupo,bVariacao,cIdent,lCt1Sint,cString,cFILUSU)
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif
		EndIf					
	#ENDIF
Case cAlias == 'CTV'           
	If cHeader == 'CTT'
		cChave   := "CUSTO+ITEM"	
		cEntidIni1	:= cCCIni
		cEntidFim1	:= cCCFim
		cEntidIni2	:= cItemIni
		cEntidFim2	:= cItemFim
	ElseIf cHeader == 'CTD'
		cChave   := "ITEM+CUSTO"	
		cEntidIni1	:= cItemIni
		cEntidFim1	:= cItemFim	
		cEntidIni2	:= cCCIni
		cEntidFim2	:= cCCFim
	EndIf
Case cAlias == 'CTW'
	If cHeader	== 'CTT'
		cChave   := "CUSTO+CLVL"			
		cEntidIni1	:=	cCCIni
		cEntidFim1	:=	cCCFim 	            		
		cEntidIni2	:=	cClVlIni
		cEntidFim2	:=	cClVlFim		
	ElseIf cHeader == 'CTH'                
		cChave   := "CLVL+CUSTO"			
		cEntidIni1	:=	cClVlIni
		cEntidFim1	:=	cClVlFim
		cEntidIni2	:=	cCCIni
		cEntidFim2	:=	cCCFim 	
	EndIf	
Case cAlias == 'CTX'
	If cHeader == 'CTD'
		cChave  	 := "ITEM+CLVL"			
		cEntidIni1	:= 	cItemIni
		cEntidFim1	:= 	cItemFim
		cEntidIni2	:= 	cClVlIni
		cEntidFim2	:= 	cClVlFim		
	ElseIf cHeader == 'CTH'
		cChave  	 := "CLVL+ITEM"			
		cEntidIni1	:= 	cClVlIni
		cEntidFim1	:= 	cClVlFim			
		cEntidIni2	:= 	cItemIni 	
		cEntidFim2	:= 	cItemFim 	
	EndIf
EndCase

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
   cChave	:= "CONTA"
Endif

cArqTmp := CriaTrab(aCampos, .T.)

dbUseArea( .T.,, cArqTmp, "cArqTmp", .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqInd	:= CriaTrab(Nil, .F.)

IndRegua("cArqTmp",cArqInd,cChave,,,OemToAnsi(STR0001))  //"Selecionando Registros..."

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
	cArqTmp1 := CriaTrab(, .F.)
	IndRegua("cArqTmp",cArqTmp1,"ORDEM",,,OemToAnsi(STR0001))  //"Selecionando Registros..."
Endif	

dbSelectArea("cArqTmp")
DbClearIndex()
dbSetIndex(cArqInd+OrdBagExt())

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
	dbSetIndex(cArqTmp1+OrdBagExt())
Endif

#IFDEF TOP	/// SE FOR DEFINIÇÃO TOP E TIVER
	If TcSrvType() != "AS/400" .And. 	FunName() <> "CTBR380"				/// E NÃO FOR O RELATÓRIO CTBR380 (VARIACAO MONETARIA)
		If Select("TRBTMP") > 0
		  	dbSelectArea("TRBTMP")
		  	aStruTMP := dbStruct()

			dbSelectArea("TRBTMP")
			If ValType(oMeter) == "O"			
				oMeter:SetTotal((cAlias)->(RecCount()))
				oMeter:Set(0)
			EndIF
			dbGoTop()
	
			While TRBTMP->(!Eof())

				If &("TRBTMP->("+cFILUSU+")")
					RecLock("cArqTMP",.T.)
					For nTRB := 1 to Len(aStruTMP)
						If Subs(aStruTmp[nTRB][1],1,9) == "MOVIMENTO" .And. nDivide > 1 
							Field->&(aStruTMP[nTRB,1])	:=((TRBTMP->&(aStruTMP[nTRB,1])))/ndivide
						Else
				 			Field->&(aStruTMP[nTRB,1]) := TRBTMP->&(aStruTMP[nTRB,1])
						EndIf					
					Next
					cArqTMP->(MsUnlock())
				Endif
				If ValType(oMeter) == "O"				
					nMeter++
			    	oMeter:Set(nMeter)				
			  	EndIF
				TRBTMP->(dbSkip())
			Enddo
  	
			dbSelectArea("TRBTMP")
			dbCloseArea()
			lTemQry := .T.
		Endif	
	Endif
#ENDIF
dbSelectArea("cArqTmp")
dbSetOrder(1)

If !Empty(aSetOfBook[5]) // Indica qual o Plano Gerencial Anexado
	// Monta Arquivo Lendo Plano Gerencial                                   
	// Neste caso a filtragem de entidades contabeis é desprezada!
	//CtbPlGeren(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,cAlias)
	If cAlias = 'CT7'
		CtPlGerSld(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,cAlias,,,,cTpSld1,cTpSld2,,,1)
		dbSetOrder(2)
	Else
		cMensagem	:= OemToAnsi(STR0002)// O plano gerencial ainda nao esta disponivel nesse relatorio. 
		MsgAlert(cMensagem)	
	EndIf
Else                                                    
	Do Case
	Case cAlias $ 'CT3'	//Comparativo de 2 Tipos de Saldos (Entidade/Conta)
		 #IFDEF TOP 
			 If TcSrvType() != "AS/400" .And. lTemQry //// JÁ PASSOU PELA QUERY ENTÃO SÓ GERA O SALDO DAS CONTAS SUPERIORES
				 If lCt1Sint
					 SupCmpCt7(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,cContaFim,cEntidIni,cEntidFim,cMoeda,cTpSld1,cTpSld2,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,cAlias,lCusto,lItem,lClVl,lAtSldBase,nInicio,nFinal,cFilDe,cFilate,nDivide,lVariacao0,lCt1Sint)			
				 Endif
			 Else
		 #ENDIF
			 CTSldCtEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,cContaFim,cEntidIni,cEntidFim,cMoeda,cTpSld1,cTpSld2,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,cAlias,lCusto,lItem,lClVl,lAtSldBase,nInicio,nFinal,cFilDe,cFilate,nDivide,lVariacao0)			
		 #IFDEF TOP 		 
		 	Endif
		 #ENDIF
	Case cAlias $ 'CT7/CTU'	//Comparativo de 2 Tipos de Saldos(Somente 1 Entidade)
		 #IFDEF TOP 
			If TcSrvType() != "AS/400" .And. lTemQry .and. FunName() <> "CTBR380" //// ATUALIZA O SALDO DAS CONTAS SUPERIORES
				If lCt1Sint
					SupCmpEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,cMoeda,cTpSld1,cTpSld2,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,cAlias,lCusto,lItem,lClVl,lAtSldBase,nInicio,nFinal,cFilDe,cFilate,nDivide,lVariacao0,nGrupo,bVariacao,cIdent,lCt1Sint)
				Endif
			Else
		 #ENDIF
			CtSldSoEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,cMoeda,cTpSld1,cTpSld2,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,cAlias,lCusto,lItem,lClVl,lAtSldBase,nInicio,nFinal,cFilDe,cFilate,nDivide,lVariacao0,nGrupo,bVariacao,cIdent)
		 #IFDEF TOP 
		 	Endif
		 #ENDIF
	EndCase	
EndIf

RestArea(aSaveArea)

Return cArqTmp

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtSldCtEnt³ Autor ³ Simone Mie Sato       ³ Data ³ 24.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Comparativo entre 2 Tipos de Saldos -Entidade / Conta       |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oMeter	= Objeto oMeter                                   ³±±
±±³          ³ oText	= Objeto oText                                    ³±±
±±³          ³ oDlg		= Objeto oDlg                                     ³±±
±±³          ³ lEnd 	= lEnd                                            ³±±
±±³          ³ cArqTmp	= Data Inicial                                    ³±±
±±³          ³ dDataIni = Data Final                                      ³±±
±±³          ³ dDataFim = Alias do Arquivo                                ³±±
±±³          ³ cArq1	= Arquivo Cadastro 1 (Principal)                  ³±±
±±³          ³ cArq2    = Arquivo Cadastro 2 (Auxiliar)                   ³±±
±±³          ³ cContaIni= Conta Inicial                                   ³±±
±±³          ³ cContaFim= Conta Final                                     ³±±
±±³          ³ cCCIni	= Centro de Custo Inicial                         ³±±
±±³          ³ cCCFim	= Centro de Custo Final                           ³±±
±±³          ³ cItemIni = Item Inicial                                    ³±±
±±³          ³ cItemFim = Item Final                                      ³±±
±±³          ³ cClVlIni = Classe de Valor Inicial                         ³±±
±±³          ³ cClvlFim = Classe de Valor Final                           ³±±
±±³          ³ cMoeda	= Moeda		                                      ³±±
±±³          ³ cTpSld1	= Tipo de Saldo 1                                 ³±±
±±³          ³ cTpSld2	= Tipo de Saldo 2                                 ³±±
±±³          ³ aSetOfBook = Set Of Book	                                  ³±±
±±³          ³ cSegmento = Filtra por Segmento		                      ³±±
±±³          ³ cSegIni	= Segmento Inicial		                          ³±±
±±³          ³ cSegFim	= Segmento Final  		                          ³±±
±±³          ³ cFiltSegm = Segmento Contido em  	                      ³±±
±±³          ³ lVariacao0 = Se Considera Variacao 0                       ³±±
±±³          ³ nDivide 	= Fator de Divisao   	                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTSldCtEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
					cContaFim,cEntidIni,cEntidFim,cMoeda,cTpSld1,cTpSld2,aSetOfBook,;
					cSegmento,cSegIni,cSegFim,cFiltSegm,cAlias,;
					lCusto,lItem,lClVl,lAtSldBase,nInicio,nFinal,cFilDe,cFilate,;
					nDivide,lVariacao0)

Local aSaveArea := GetArea()
					
Local cEntid
Local cContaSup
Local cDesc
Local cMascara  := aSetOfBook[2] //VERIFICAR
Local cCodEnt	:= ""
Local cCusIni	:= ""
Local cCusFim	:= ""
Local cItemIni	:= ""
Local cItemFim	:= ""
Local cCodRes	:= ""
Local cCodEntRes:= ""              
Local cTipoEnt	:= ""                  
Local cCodTpEnt := ""
Local cDescEnt	:= ""
Local cCadAlias	:= ""
Local nMeter	:= 0

Local nPos		:= 0
Local nDigitos	:= 0
Local nRegTmp   := 0
Local nOrder1	:= 0                                  
Local nOrder2	:= 0
Local nTamCC	:= Len(CriaVar("CTT_CUSTO"))
Local nTamItem	:= Len(CriaVar("CTD_ITEM")) 
Local nMovSld1	:= 0
Local nMovSld2	:= 0
Local nTotal	:= 0

Local bCond1	:= {||.F.}
Local bCond2	:= {||.F.}

Local oProcess              

#IFDEF TOP
	Local cCondCT1	:= ""     
	Local cCondEnt	:= ""                        	
	Local cCondFil	:= ""		
	Local cContaEnt	:= ""                           	
	Local cFilCT1	:= ""	
	Local cFilEnt	:= ""	
	Local cOrderBy	:= ""	
	Local cQuery 	:= ""	
	Local cSelect	:= ""          	
	Local nMin		:= 0	
	Local nMax		:= 0      	
#ENDIF

lVariacao0	:= Iif(lVariacao0 == Nil,.T.,lVariacao0)
nDivide 	:= Iif(nDivide == Nil,1,nDivide)


// Verifica Filtragem por Segmento da  Conta
If !Empty(cSegmento)
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cMascara)
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascara 
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == cSegmento
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	EndIf	
EndIf		

#IFDEF TOP                                              
	//So ira executar as querys se o balancete for ITEM/CONTA ou CLVL/CONTA
	If TcSrvType() != "AS/400" .And. cAlias $ 'CT3/CT4/CTI'
		//Se os saldos basicos nao foram atualizados na dig. lancamentos contab. 
		If !lAtSldBase
			//Chama Rotina de Atualizacao de Saldos Basicos.
			oProcess := MsNewProcess():New({|lEnd|	Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cTpSld1,.T.,cFilDe,cFilAte,,,.T.,oProcess,nMin,nMax)},"","",.F.)
			oProcess:Activate()									
			oProcess := MsNewProcess():New({|lEnd|	Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cTpSld2,.T.,cFilDe,cFilAte,,,.T.,oProcess,nMin,nMax)},"","",.F.)	
			oProcess:Activate()										
		EndIf                       
	
		If cAlias == "CT3"
			cFilEnt 	:=	Iif(Empty(xFilial("CTT")),"C","E")		
			cCadAlias   := "CTT"
			cSelect		:= "ARQ.CT3_CUSTO CODENT, CAD.CTT_RES ENTRES, CAD.CTT_BOOK ENTBOOK, "
			cSelect		+= "CAD.CTT_CCSUP ENTSUP, CAD.CTT_CLASSE ENTCLASSE, "
			cSelect		+= "CAD.CTT_DESC" + cMoeda+ " DESCENT "   
			cCondEnt	:= " ARQ.CT3_CUSTO BETWEEN '" + cEntidIni + "' AND '" + cEntidFim + "' AND " 
			cCondEnt   	+= " ( ARQ.CT3_CUSTO = CAD.CTT_CUSTO " 
			cOrderBy	:= " ARQ.CT3_CUSTO, ARQ.CT3_CONTA"    
		ElseIf cAlias == "CT4"
			cFilEnt 	:=	Iif(Empty(xFilial("CTD")),"C","E")		
			cCadAlias   := "CTD"                                       
			cSelect		:= "ARQ.CT4_ITEM CODENT, CAD.CTD_RES ENTRES, CAD.CTD_BOOK ENTBOOK, "
			cSelect		+= "CAD.CTD_ITSUP ENTSUP, CAD.CTD_CLASSE ENTCLASSE, "
			cSelect		+= "CAD.CTD_DESC" + cMoeda+ " DESCENT "   
			cCondEnt	:= " ARQ.CT4_ITEM BETWEEN '" + cEntidIni + "' AND '" + cEntidFim + "' AND " 
			cCondEnt   	+= " ( ARQ.CT4_ITEM = CAD.CTD_ITEM " 
			cOrderBy	:= " ARQ.CT4_ITEM, ARQ.CT4_CONTA"    
		ElseIf cAlias == "CTI"			
			cFilEnt		:=	Iif(Empty(xFilial("CTH")),"C","E")
			cCadAlias	:= "CTH"
			cSelect		:= "ARQ.CTI_CLVL CODENT, CAD.CTH_RES ENTRES, CAD.CTH_BOOK ENTBOOK, "
			cSelect		+= "CAD.CTH_CLSUP ENTSUP, CAD.CTH_CLASSE ENTCLASSE, "
			cSelect		+= "CAD.CTH_DESC" + cMoeda+ " DESCENT "   			
			cCondEnt	:= " ARQ.CTI_CLVL BETWEEN '" + cEntidIni + "' AND '" + cEntidFim + "' AND " 			
			cCondEnt   	+= " ( ARQ.CTI_CLVL = CAD.CTH_CLVL " 
			cOrderBy	:= " ARQ.CTI_CLVL, ARQ.CTI_CONTA"
		EndIf

		cFilCT1 :=	Iif(Empty(xFilial("CT1")),"C","E")
		
		If cFilEnt == "E"		//Se for Exclusivo
			cCondFil := " AND ARQ."+cAlias+"_FILIAL = '" + xFilial(cCadAlias) +"' ) AND "
		Else                                                  
			cCondFil := " ) AND " 
		EndIf			

		If cFilCT1 == "E"		//Se for Exclusivo
			cCondCT1 := " AND ARQ."+cAlias+"_FILIAL = '" + xFilial("CT1") +"' ) AND "
		Else                                                  
			cCondCT1 := " ) AND " 
		EndIf			
		
		cOrder := SqlOrder(indexKey())
		cContaEnt := "cContaEnt"   		
	
		cQuery := "SELECT DISTINCT ARQ."+cAlias+"_FILIAL FILIAL, ARQ."+cAlias+"_CONTA CONTA, "
		cQuery += "CT1.CT1_RES CTARES, CT1.CT1_BOOK CTBOOK, CT1.CT1_CTASUP CTASUP, CT1.CT1_CLASSE CTACLASSE, CT1.CT1_NORMAL CTANORMAL, CT1.CT1_GRUPO CTAGRUPO, "		  
		cQuery += "CT1.CT1_DESC" + cMoeda+ " DESCCTA, "   
		cQuery += cSelect
		cQuery += "FROM " + RetSqlName(cAlias)+" ARQ ,"
		cQuery += " " + RetSqlName(cCadAlias)+" CAD ,"
		cQuery += " " + RetSqlName("CT1")+" CT1 "
		cQuery += "WHERE CT1_CLASSE = '2' AND ARQ."+cAlias+"_FILIAL = '" + xFilial(cAlias) + "'" 
		cQuery += " AND ARQ."+cAlias+"_MOEDA ='"+cMoeda+"' " 
		cQuery += " AND (ARQ."+cAlias+"_CONTA = CT1.CT1_CONTA " 		
		cQuery += cCondCT1                                      
		cQuery += cCondEnt
		cQuery += cCondFil 				
		cQuery += "ARQ."+cAlias+"_CONTA BETWEEN '" + cContaIni + "' AND '" + cContaFim + "' AND " 				
		cQuery += "(ARQ."+cAlias+"_TPSALD ='"+cTpSld1+"' OR ARQ."+cAlias+"_TPSALD ='"+cTpSld2 + "') AND "
		cQuery += "ARQ.D_E_L_E_T_ <> '*' "				
		cQuery += "ORDER BY "
		cQuery += cOrderBy		
		cQuery := ChangeQuery(cQuery)		   

		If ( Select ( "cContaEnt" ) <> 0 )
			dbSelectArea ( "cContaEnt" )
			dbCloseArea ()
		Endif                                                               
		
	  	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cContaEnt,.T.,.F.)
		aStru := (cAlias)->(dbStruct())		
		
		dbSelectArea(cContaEnt)
		While !Eof()						
	
			If !Empty(aSetOfBook[1])	
				If !(aSetOfBook[1] $ cContaEnt->CTBOOK)
				 	dbSelectArea(cContaEnt)
					dbSkip()
					Loop
				EndIf
			Endif                 
			
			//Caso faca filtragem por segmento de item,verifico se esta dentro 
			//da solicitacao feita pelo usuario. 
			If !Empty(cSegmento)
				If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
					If  !(Substr(cContaEnt->CONTA,nPos,nDigitos) $ (cFiltSegm) ) 
						dbSelectArea(cContaEnt)
						dbSkip()
						Loop
					EndIf	
				Else
 					If Substr(cContaEnt->CONTA,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
						Substr(cContaEnt->CONTA,nPos,nDigitos) > Alltrim(cSegFim)
						dbSelectArea(cContaEnt)						
						dbSkip()
						Loop
					EndIf	
				Endif
			EndIf	
			
	  		//Calculo dos saldos
			If cAlias == 'CT3'
				nMovSld1	:= MovCusto(cContaEnt->CONTA,cContaEnt->CODENT,dDataIni,dDataFim,cMoeda,cTpSld1,3)				
				nMovSld2	:= MovCusto(cContaEnt->CONTA,cContaEnt->CODENT,dDataIni,dDataFim,cMoeda,cTpSld2,3)						
			Endif

	  		If !lVariacao0
				If 	nMovSld1 = 0 .And. nMovSld2 = 0
					dbSkip()
					Loop
				EndIf	
			EndIf	
		
			dbSelectArea("cArqTmp")
			dbSetOrder(1)	
			If !MsSeek(cContaEnt->CODENT+cContaEnt->CONTA)
				dbAppend()
				Replace CONTA 		With cContaEnt->CONTA
				Replace DESCCTA		With cContaEnt->DESCCTA
				Replace TIPOCONTA 	With cContaEnt->CTACLASSE
				Replace CTARES      With cContaEnt->CTARES
				If cAlias == 'CT3'
					Replace CUSTO	With cContaEnt->CODENT
					Replace CCRES	With cContaEnt->ENTRES
					Replace TIPOCC  With cContaEnt->ENTCLASSE
					Replace DESCCC	With cContaEnt->DESCENT
				ElseIf cAlias == 'CT4'
					Replace ITEM 	 With cContaEnt->CODENT
					Replace ITEMRES  With cContaEnt->ENTRES
					Replace TIPOITEM With cContaEnt->ENTCLASSE
					Replace DESCITEM With cContaEnt->DESCENT
				ElseIf cAlias == 'CTI'
					Replace CLVL 	 With cContaEnt->CODENT
					Replace CLVLRES  With cContaEnt->ENTRES
					Replace TIPOCLVL With cContaEnt->ENTCLASSE
					Replace DESCCLVL With cContaEnt->DESCENT
				Endif   
			Endif               
		
			If nDivide > 1
				nMovSld1 := Round(NoRound((nMovSld1/nDivide),3),2)
				nMovSld2 := Round(NoRound((nMovSld2/nDivide),3),2)
			EndIf	
				
			dbSelectArea("cArqTmp")
			dbSetOrder(1)
			Replace MOVIMENTO1 With nMovSld1	//Movimento Tipo de Saldo 1
			Replace MOVIMENTO2 With nMovSld2	//Movimento Tipo de Saldo 2
			
			If nMovSld1 = 0 .Or. nMovSld2 = 0						
				Replace VARIACAO   With 0
			Else
				Replace VARIACAO   With (nMovSld1/nMovSld2) *100
			EndIf
           
			dbSelectArea(cContaEnt)
			dbSkip()
		EndDo	
		
		If ( Select ( "cContaEnt" ) <> 0 )
			dbSelectArea ( "cContaEnt" )
			dbCloseArea ()
		Endif		
	Else
#ENDIF

	 //Se for As/400 ou se nao for Balancete Conta/Item e Balancete Conta/Cl.Valor
	 
	//Chama rotina para refazer os saldos basicos.Foi criado outra rotina porque 
	//nao tenho data inicial nem data final para passar como parametro.
	If !lAtSldBase
		oProcess := MsNewProcess():New({|lEnd|	Ct360RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cTpSld1,oProcess,lAtSldBase)},"","",.F.)
		oProcess:Activate()								
		oProcess := MsNewProcess():New({|lEnd|	Ct360RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cTpSld2,oProcess,lAtSldBase)},"","",.F.)
		oProcess:Activate()									
	EndIf	

	  
	If cAlias == 'CT3'
		nOrder1 	:= 2
	   	nOrder2		:= 4
		bCond1		:= {||(CTT->CTT_FILIAL == xFilial() .And.	CTT->CTT_CUSTO >= cEntidIni .And.CTT->CTT_CUSTO <= cEntidFim .And. CTT_CLASSE != '1')}
		bCond2		:= {||(CT3->CT3_CUSTO <= cEntidFim)}
		cCadAlias	:= "CTT"                             
		cCodEnt		:= "CUSTO"                                                        
		cCodEntRes	:= "CCRES"
		cCodTpEnt	:= "TIPOCC"
		cDescEntid	:= "DESCCC"
	Elseif cAlias == 'CT4'                                                                
		nOrder1 	:= 2
	    nOrder2		:= 4                                                             
		bCond1		:= {||(CTD->CTD_FILIAL == xFilial() .And.	CTD->CTD_ITEM >= cEntidIni .And.CTD->CTD_ITEM <= cEntidFim .And. CTD_CLASSE != '1')}
		bCond2		:= {||(CT4->CT4_ITEM <= cEntidFim )}
		cCadAlias	:= "CTD"                             
		cCodEnt		:= "ITEM" 
		cCodEntRes	:= "ITEMRES"
		cCodTpEnt	:= "TIPOITEM"
		cCusIni		:= ""
		cCusFim		:= Replicate("Z",nTamCC)   
		cDescEntid	:= "DESCITEM"	
	ElseIf cAlias == 'CTI'
		nOrder1 	:= 2      
		nOrder2		:= 4
		bCond1		:= {||(CTH->CTH_FILIAL == xFilial() .And.	CTH->CTH_CLVL >= cEntidIni .And.CTH->CTH_CLVL <= cEntidFim .And. CTH_CLASSE != '1')}
		bCond2		:= {||(CTI->CTI_CLVL <= cEntidFim)}	
		cCadAlias	:= "CTH"                             
		cCodEnt		:= "CLVL"   
		cCodEntRes	:= "CLVLRES"
		cCodTpEnt	:= "TIPOCLVL"
		cDescEntid	:= "DESCCLVL"	
		cCusIni		:= ""
		cCusFim		:= Replicate("Z",nTamCC)   
		cItemIni	:= ""
		cItemFim	:= Replicate("Z",nTamItem)   	
	Endif

	dbSelectArea(cCadAlias)
	dbSetOrder(nOrder1)

	// Posiciona no primeiro item analitico 
	MsSeek(xFilial()+"2"+cEntidIni,.T.)

	While !Eof() .And. Eval(bCond1)
		                                                            
		// Grava entidade analitica
		cEntid 	 := &(cCadAlias+"->"+cCadAlias+"_"+cCodEnt)	
		cCodRes  := &(cCadAlias+"->"+cCadAlias+"_RES")	
		cTipoEnt := &(cCadAlias+"->"+cCadAlias+"_CLASSE")	                              
		cDescEnt := &(cCadAlias+"->"+cCadAlias+"_DESC"+cMoeda)	                      
		If Empty(cDescEnt)		// Caso nao preencher descricao da moeda selecionada
			cDescEnt := &(cCadAlias+"->"+cCadAlias+"_DESC01")
		Endif

		// Caso tenha escolhido algum Set Of Book, verifico se a classe de valor pertence a esse set.
		If !Empty(aSetOfBook[1])
			If !(aSetOfBook[1] $ &(cCadAlias+"->"+cCadAlias+"_BOOK"))
				dbSkip()
				Loop
			EndIf
		EndIf		           	
	
		dbSelectArea("CT1")
		dbSetOrder(1)
		If ValType(oMeter) == "O"		
			oMeter:SetTotal(CT1->(RecCount()))
			oMeter:Set(0)
		EndIF
		MsSeek(xFilial() + cContaIni,.T.)

		While !Eof() .And. CT1_CONTA <= cContaFim
			If ValType(oMeter) == "O"
				nMeter++
		    	oMeter:Set(nMeter)				
		  	EndIf
    	
			//Caso faca filtragem por segmento de conta,verifico se esta dentro 
			//da solicitacao feita pelo usuario. 
			If !Empty(cSegmento)
				If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
					If  !(Substr(CT1_CONTA,nPos,nDigitos) $ (cFiltSegm) ) 
						dbSkip()
					Loop	
					EndIf	
				Else
					If 	Substr(CT1_CONTA,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
						Substr(CT1_CONTA,nPos,nDigitos) > Alltrim(cSegFim)
						dbSkip()
						Loop
					EndIf	
				Endif
			EndIf

			If CT1_CLASSE = "1"		// Conta sinteticas nao armazenam saldos
				DbSkip()
				Loop
			Endif
		
			// Caso tenha escolhido algum Set Of Book, verifico se a conta pertence a esse set.				
			If !Empty(aSetOfBook[1])
				If !(aSetOfBook[1] $ CT1->CT1_BOOK)
					dbSkip()
					Loop
				EndIf
			EndIf		           	

			cDesc 	:= &("CT1->CT1_DESC"+cMoeda)    
			If Empty(cDesc)                  
				cDesc := CT1->CT1_DESC01
			EndIf

	  		//Calculo dos saldos
			If cAlias == 'CT3'
				nMovSld1	:= MovCusto(CT1->CT1_CONTA,cEntid,dDataIni,dDataFim,cMoeda,cTpSld1,3)				
				nMovSld2	:= MovCusto(CT1->CT1_CONTA,cEntid,dDataIni,dDataFim,cMoeda,cTpSld2,3)						
			Endif

	  		If !lVariacao0
				If 	nMovSld1 = 0 .And. nMovSld2 = 0
					dbSkip()
					Loop
				EndIf	
			EndIf	
		
			dbSelectArea("cArqTmp")
			dbSetOrder(1)	
			If !MsSeek(cEntid+CT1->CT1_CONTA)
				dbAppend()
				Replace CONTA 		With CT1->CT1_CONTA
				Replace DESCCTA		With cDesc
				Replace TIPOCONTA 	With CT1->CT1_CLASSE
				Replace CTARES      With CT1->CT1_RES
				If cAlias == 'CT3'
					Replace CUSTO	With cEntid			
					Replace CCRES	With cCodRes
					Replace TIPOCC  With cTipoEnt
					Replace DESCCC	With cDescEnt
				ElseIf cAlias == 'CT4'
					Replace ITEM 	 With cEntid
					Replace ITEMRES  With cCodRes 
					Replace TIPOITEM With cTipoEnt
					Replace DESCITEM With cDescEnt
				ElseIf cAlias == 'CTI'
					Replace CLVL 	 With cEntid			
					Replace CLVLRES  With cCodRes
					Replace TIPOCLVL With cTipoEnt
					Replace DESCCLVL With cDescEnt
				Endif   
			Endif               
		
			If nDivide > 1
				nMovSld1 := Round(NoRound((nMovSld1/nDivide),3),2)
				nMovSld2 := Round(NoRound((nMovSld2/nDivide),3),2)
			EndIf	
				
			dbSelectArea("cArqTmp")
			dbSetOrder(1)
			Replace MOVIMENTO1 With nMovSld1	//Movimento Tipo de Saldo 1
			Replace MOVIMENTO2 With nMovSld2	//Movimento Tipo de Saldo 2
			
			If nMovSld1 = 0 .Or. nMovSld2 = 0						
				Replace VARIACAO   With 0
			Else
				Replace VARIACAO   With (nMovSld1/nMovSld2) *100
			EndIf
	
	   		dbSelectArea("CT1")
			dbSkip()
		Enddo
	
	    dbSelectArea(cCadAlias)
   		dbSkip()
	EndDo	
#IfDef TOP
	Endif
#ENDIF
	

// Grava contas sinteticas

dbSelectArea("cArqTmp")	
If ValType(oMeter) == "O"
	oMeter:SetTotal(cArqTmp->(RecCount()))
	oMeter:Set(0)
EndIF
dbGoTop()  

While!Eof()                                 
	If ValType(oMeter) == "O"
		nMeter++
   		oMeter:Set(nMeter)				
  	EndIf
                                            
	nMovim01	:= MOVIMENTO1
	nMovim02	:= MOVIMENTO2
	nRegTmp 	:= Recno()   
	   
	If cAlias == 'CT3' 
		cEntid 	 := cArqTmp->CUSTO
		cCodRes	 := cArqTmp->CCRES
		cTipoEnt := cArqTmp->TIPOCC
		cDescEnt := cArqTmp->DESCCC
	ElseIf cAlias == 'CT4'      	
		cEntid 	 := cArqTmp->ITEM
		cCodRes	 := cArqTmp->ITEMRES
		cTipoEnt := cArqTmp->TIPOITEM
		cDescEnt := cArqTmp->DESCITEM
	ElseIf cAlias == 'CTI'
		cEntid 	 := cArqTmp->CLVL
		cCodRes	 := cArqTmp->CLVLRES
		cTipoEnt := cArqTmp->TIPOCLVL
		cDescEnt := cArqTmp->DESCCLVL
	EndIf
	
	dbSelectArea("CT1")	
	dbSetOrder(1)      
	cContaSup := cArqTmp->CONTA
	MsSeek(xFilial("CT1")+ cContaSup)
	If Empty(CT1->CT1_CTASUP)
		dbSelectArea("cArqTmp")
		Replace NIVEL1 With .T.
		dbSelectArea("CT1")
	EndIf		

	cContaSup := CT1->CT1_CTASUP
	MsSeek(xFilial("CT1")+ cContaSup)
		
	While !Eof() .And. CT1->CT1_FILIAL == xFilial()

		cDesc := &("CT1->CT1_DESC"+cMoeda)
		If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
			cDesc := CT1->CT1_DESC01
		Endif
		
		dbSelectArea("cArqTmp")
		dbSetOrder(1)      
		If ! MsSeek(cEntid+cContaSup)
			dbAppend()
			Replace CONTA		With cContaSup	
			Replace DESCCTA 	With cDesc
			Replace TIPOCONTA	With CT1->CT1_CLASSE
			Replace CTARES		With CT1->CT1_RES
			If cAlias == 'CT3'
				Replace CUSTO With cEntid		 
				Replace CCRES With cCodRes
				Replace TIPOCC With cTipoEnt
				Replace DESCCC With cDescEnt
			ElseIf cAlias == 'CT4'
			    Replace ITEM With cEntid
			    Replace ITEMRES With cCodRes
			    Replace TIPOITEM With cTipoEnt
			    Replace DESCITEM With cDescEnt
			ElseIf cAlias == 'CTI'
				Replace CLVL With cEntid
				Replace CLVLRES With cCodRes  
				Replace TIPOCLVL With cTipoEnt
				Replace DESCCLVL WITH cDescEnt
			EndIf
		EndIf    
		
		Replace	 MOVIMENTO1 With MOVIMENTO1 + nMovim01
		Replace  MOVIMENTO2 With MOVIMENTO2 + nMovim02
		
		If MOVIMENTO1 = 0 .Or. MOVIMENTO2 = 0						
			Replace VARIACAO   With 0
		Else
			Replace VARIACAO   With (MOVIMENTO1/MOVIMENTO2)*100
		EndIf
		
		dbSelectArea("CT1")
		cContaSup := CT1->CT1_CTASUP
		If Empty(CT1->CT1_CTASUP)
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea("CT1")
			Exit
		EndIf		
		MsSeek(xFilial()+cContaSup)

		dbSelectArea("cArqTmp")
		dbGoto(nRegTmp)
		dbSelectArea("CT1")
	EndDo
	dbSelectArea("cArqTmp")
	dbGoto(nRegTmp)
	dbSkip()
EndDo
RestArea(aSaveArea)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtSldSoEnt³ Autor ³ Simone Mie Sato       ³ Data ³ 24.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Comparativo entre 2 Tipos de Saldos -So Entidade            |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oMeter	= Objeto oMeter                                   ³±±
±±³          ³ oText	= Objeto oText                                    ³±±
±±³          ³ oDlg		= Objeto oDlg                                     ³±±
±±³          ³ lEnd 	= lEnd                                            ³±±
±±³          ³ cArqTmp	= Data Inicial                                    ³±±
±±³          ³ dDataIni = Data Final                                      ³±±
±±³          ³ dDataFim = Alias do Arquivo                                ³±±
±±³          ³ cArq1	= Arquivo Cadastro 1 (Principal)                  ³±±
±±³          ³ cArq2    = Arquivo Cadastro 2 (Auxiliar)                   ³±±
±±³          ³ cContaIni= Conta Inicial                                   ³±±
±±³          ³ cContaFim= Conta Final                                     ³±±
±±³          ³ cCCIni	= Centro de Custo Inicial                         ³±±
±±³          ³ cCCFim	= Centro de Custo Final                           ³±±
±±³          ³ cItemIni = Item Inicial                                    ³±±
±±³          ³ cItemFim = Item Final                                      ³±±
±±³          ³ cClVlIni = Classe de Valor Inicial                         ³±±
±±³          ³ cClvlFim = Classe de Valor Final                           ³±±
±±³          ³ cMoeda	= Moeda		                                      ³±±
±±³          ³ cTpSld1	= Tipo de Saldo 1                                 ³±±
±±³          ³ cTpSld2	= Tipo de Saldo 2                                 ³±±
±±³          ³ aSetOfBook= Set Of Book	                                  ³±±
±±³          ³ cSegmento = Filtra por Segmento		                      ³±±
±±³          ³ cSegIni	= Segmento Inicial		                          ³±±
±±³          ³ cSegFim	= Segmento Final  		                          ³±±
±±³          ³ cFiltSegm= Segmento Contido em  	                          ³±±
±±³          ³ lVariacao0 = Se Considera Variacao 0                       ³±±
±±³          ³ nDivide 	= Fator de Divisao   	                          ³±±
±±³          ³ bVariacao = Bloco de codigo para tratamentos especificos   ³±± 
±±³          ³ cIdent = Identificador do arquivo que será tratado         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CTSldSoEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,;
					cMoeda,cTpSld1,cTpSld2,aSetOfBook,;
					cSegmento,cSegIni,cSegFim,cFiltSegm,cAlias,;
					lCusto,lItem,lClVl,lAtSldBase,nInicio,nFinal,cFilDe,cFilate,;
					nDivide,lVariacao0,nGrupo,bVariacao,cIdent)
					
Local aSaveArea 	:= GetArea()

Local cDesc
Local cMascara		:= ""

Local nPos			:= 0
Local nDigitos		:= 0
Local nRegTmp   	:= 0
Local nTamDesc		:= ""
Local nMovSld1		:= 0
Local nMovSld2		:= 0
Local nColuna1		:= 0
Local nColuna2		:= 0
Local nTotal		:= 0 
Local nMeter		:= 0

Local oProcess
Local dMinSld1 := cTod("")
Local dMinSld2 := cTod("")

Local lAtSldCmp := Iif(GetMV("MV_SLDCOMP")== "S",.T.,.F.) 
Local cMensagem := OemToAnsi(STR0002)// O plano gerencial ainda nao esta disponivel nesse relatorio. 			

#IFDEF TOP
	Local nMin			:= 0
	Local nMax			:= 0
#ENDIF

lVariacao0	:= Iif(lVariacao0 == Nil,.T.,lVariacao0)
nDivide 	:= Iif(nDivide == Nil,1,nDivide)

If cAlias	== 'CT7'
	If !Empty(aSetOfBook[2])
		cMascara	:= aSetOfBook[2]
	EndIf
ElseIf cAlias	== 'CTU'
  		Do Case
  		Case cIdent == 'CTT'
	 		cMascara	:= aSetOfBook[6]			
	 		cOrigem		:= 'CT3'		
 		Case cIdent	== 'CTD'
	 		cMascara	:= aSetOfBook[7]			            		
	 		cOrigem		:= 'CT4'		
		Case cIdent == 'CTH'			
	 		cMascara	:= aSetOfBook[8]	   
	 		cOrigem		:= 'CTI'		
 		EndCase	
EndIf


// Verifica Filtragem por Segmento da Entidade
If !Empty(cSegmento)
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cMascara)
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascara 
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == cSegmento
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	EndIf	
EndIf		
					
//Se os saldos basicos nao foram atualizados na dig. lancamentos
If !lAtSldBase
  	#IFDEF TOP 
		If TcSrvType() != "AS/400" 
			//Chama Rotina de Atualizacao de Saldos Basicos.
			oProcess := MsNewProcess():New({|lEnd|	Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cTpSld1,.T.,cFilDe,cFilAte,,,.T.,oProcess,nMin,nMax)},"","",.F.)
			oProcess:Activate()						
			oProcess := MsNewProcess():New({|lEnd|	Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cTpSld2,.T.,cFilDe,cFilAte,,,.T.,oProcess,nMin,nMax)},"","",.F.)
			oProcess:Activate()				
		Else
	#ENDIF
		oProcess := MsNewProcess():New({|lEnd|	Ct360RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cTpSld1,oProcess,lAtSldBase)},"","",.F.)		
		oProcess:Activate()						
		oProcess := MsNewProcess():New({|lEnd|	Ct360RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cTpSld2,oProcess,lAtSldBase)},"","",.F.)				
		oProcess:Activate()									
  	#IFDEF TOP 
  		Endif		
	#ENDIF
Endif	

If cAlias == 'CT7'
		
	dbSelectArea("CT1")
	If ValType(oMeter) == "O"	
		oMeter:SetTotal(CT1->(RecCount()))
		oMeter:Set(0)	
	EndIf
	dbSetOrder(3)

	// Posiciona na primeira conta analitica
	MsSeek(xFilial()+"2"+cEntidIni,.T.)

	While !Eof() .And. 	CT1->CT1_FILIAL == xFilial() .And.;
			CT1->CT1_CONTA <= cEntidFim .And. CT1_CLASSE != "1"
		If ValType(oMeter) == "O"			
			nMeter++
    		oMeter:Set(nMeter)				
   		EndIf

		// Grava conta analitica
		cConta 	:= CT1->CT1_CONTA

		// Conta nao pertencera ao arquivo pois sera filtrado pelo Set Of Book 
		// Escolhido 
		If !Empty(aSetOfBook[1])
			If !(aSetOfBook[1] $ CT1->CT1_BOOK)
				CT1->(dbSkip())
				Loop
			EndIf
		EndIf		
	
		If !Empty(cSegmento)
			If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
				If  !(Substr(CT1->CT1_CONTA,nPos,nDigitos) $ (cFiltSegm) ) 
					dbSkip()
					Loop
				EndIf	
			Else
				If Substr(CT1->CT1_CONTA,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
					Substr(CT1->CT1_CONTA,nPos,nDigitos) > Alltrim(cSegFim)
					CT1->(dbSkip())
					Loop
				EndIf	
			Endif
		EndIf	
	
		//Calculo dos saldos
		If cAlias == 'CT7'
			If cTpSld1 = cTpSld2		// Comparacao de moeda
				nMovSld1 := SaldoCt7(CT1->CT1_CONTA,dDataFim,"01",cTpSld1)[1]
				nMovSld2 := SaldoCt7(CT1->CT1_CONTA,dDataFim,cMoeda,cTpSld2)[1]
			Else
				nMovSld1 := MovConta(CT1->CT1_CONTA,dDataIni,dDataFim,cMoeda,cTpSld1,3)
				nMovSld2 := MovConta(CT1->CT1_CONTA,dDataIni,dDataFim,cMoeda,cTpSld2,3)
			Endif
		Endif

		If !lVariacao0
			If 	nMovSld1 = 0 .And. nMovSld2 = 0
				dbSelectArea("CT1")
				dbSkip()
				Loop
			EndIf	
		EndIf	
		
		If lVariacao0 .And. nMovSld1 = 0 .And. nMovSld2 = 0
			If CtbExDtFim("CT1") 
				If !CtbVlDtFim("CT1",dDataIni) 		
					dbSelectArea("CT1")
					dbSkip()
					Loop				
				EndIf		
			EndIf		
		EndIf

   		cDesc 		:= &("CT1->CT1_DESC"+cMoeda)
		If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
			cDesc := CT1->CT1_DESC01
		Endif
		nTamDesc    := Len(CriaVar("CT1->CT1_DESC"+cMoeda))
		dbSelectArea("cArqTmp")
		dbSetOrder(1)	
		If !MsSeek(xFilial()+cConta)
			dbAppend()
			Replace CONTA 		With cConta
			Replace DESCCTA		With cDesc
			Replace TIPOCONTA 	With CT1->CT1_CLASSE
			Replace CTARES    	With CT1->CT1_RES
			Replace NORMAL    	With CT1->CT1_NORMAL
			Replace GRUPO		With CT1->CT1_GRUPO
		EndIf
	
		If nDivide > 1
			nMovSld1 := Round(NoRound((nMovSld1/nDivide),3),2)
			nMovSld2 := Round(NoRound((nMovSld2/nDivide),3),2)
		EndIf	
				
		dbSelectArea("cArqTmp")
		dbSetOrder(1)
		Replace MOVIMENTO1 With nMovSld1	//Movimento Tipo de Saldo 1
		Replace MOVIMENTO2 With nMovSld2	//Movimento Tipo de Saldo 2
		
		If nMovSld1 = 0 .Or. nMovSld2 = 0						
			Replace VARIACAO   With 0
		Else
			Replace VARIACAO   With (nMovSld1/nMovSld2) *100
		EndIf		 		
		
		If bVariacao <> Nil
			Eval(bVariacao)
		Endif		
		
		dbSelectArea("CT1")
		dbSkip()
	End
		

	// Grava contas sinteticas

	dbSelectArea("cArqTmp")	
	If ValType(oMeter) == "O"	
		oMeter:SetTotal(cArqTmp->(RecCount()))
		oMeter:Set(0)
	EndIF
	dbGoTop()  

	While!Eof()                                 
		If ValType(oMeter) == "O"	
			nMeter++
		   	oMeter:Set(nMeter)				
		 EndIF
                                            
		nMovim01	:= MOVIMENTO1
		nMovim02	:= MOVIMENTO2
		If FieldPos("COLUNA_1") > 0
			nColuna1 := COLUNA_1
			nColuna2 := COLUNA_2
		Else
			nColuna1 := nColuna2 := 0.00
		Endif
		nRegTmp 	:= Recno()   
	
		dbSelectArea("CT1")
		dbSetOrder(1)
		MsSeek(xFilial()+cArqTmp->CONTA)	

		If Empty(CT1->CT1_CTASUP)
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea("CT1")
		EndIf
		
		cContaSup := CT1->CT1_CTASUP
		MsSeek(xFilial()+cContaSup)
	
		While !Eof() .And. CT1->CT1_FILIAL == xFilial()
			cDesc := &("CT1->CT1_DESC"+cMoeda)
			If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
				cDesc := CT1->CT1_DESC01
			Endif
			dbSelectArea("cArqTmp")
			dbSetOrder(1)
			If !MsSeek(cContaSup)
				dbAppend()
				Replace CONTA		With cContaSup
				Replace DESCCTA		With cDesc
				Replace TIPOCONTA	With CT1->CT1_CLASSE
				Replace CTARES    	With CT1->CT1_RES
				Replace NORMAL   	With CT1->CT1_NORMAL
				Replace GRUPO		With CT1->CT1_GRUPO
			EndIf    

			Replace	 MOVIMENTO1 With MOVIMENTO1 + nMovim01
			Replace  MOVIMENTO2 With MOVIMENTO2 + nMovim02
		
			If MOVIMENTO1 = 0 .Or. MOVIMENTO2 = 0						
				Replace VARIACAO   With 0
			Else
				Replace VARIACAO   With (MOVIMENTO1/MOVIMENTO2)*100
			EndIf		 		
		   		
			If nColuna1 # 0
				Replace COLUNA_1 With COLUNA_1 + nColuna1
			Endif
		   		
			If nColuna2 # 0
				Replace COLUNA_2 With COLUNA_2 + nColuna2
			Endif
		   		
			If bVariacao <> Nil
				Eval(bVariacao)
			Endif		
		
			dbSelectArea("CT1")
			cContaSup := CT1->CT1_CTASUP
			If Empty(CT1->CT1_CTASUP)
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea("CT1")
				Exit
			EndIf		
			MsSeek(xFilial()+cContaSup)      		
		EndDo
    	
		dbSelectArea("cArqTmp")
		dbSetOrder(1)
		dbGoTo(nRegTmp)
		dbSkip()
	EndDo	
		
ElseIf cAlias == 'CTU'
		//Verificar se tem algum saldo a ser atualizado
		If cIdent = 'CTT'                                                                      
			Ct360Data('CT3','CTU',@dMinSld1,lCusto,lItem,cFilDe,cFilAte,cTpSld1,cMoeda,cMoeda,,,,,,,,,,cFilAnt)  
			Ct360Data('CT3','CTU',@dMinSld2,lCusto,lItem,cFilDe,cFilAte,cTpSld2,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
		ElseIf cIdent = 'CTD'
			Ct360Data('CT4','CTU',@dMinSld1,lCusto,lItem,cFilDe,cFilAte,cTpSld1,cMoeda,cMoeda,,,,,,,,,,cFilAnt)  
			Ct360Data('CT4','CTU',@dMinSld2,lCusto,lItem,cFilDe,cFilAte,cTpSld2,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
		Else                                                                                                     
			Ct360Data('CTI','CTU',@dMinSld1,lCusto,lItem,cFilDe,cFilAte,cTpSld1,cMoeda,cMoeda,,,,,,,,,,cFilAnt) 
			Ct360Data('CTI','CTU',@dMinSld2,lCusto,lItem,cFilDe,cFilAte,cTpSld2,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
		EndIf

		//Se o parametro MV_SLDCOMP estiver com "S",isto e, se devera atualizar os saldos compost.
		//na emissao dos relatorios, verifica se tem algum registro desatualizado e atualiza as
		//tabelas de saldos compostos.
		If lAtSldCmp 	//Se atualiza saldos compostos no relatorio
			If !Empty(dMinSld1)                            				
				oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cTpSld1,cMoeda,dDataIni,cOrigem,dMinSld1,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt)},"","",.F.)
				oProcess:Activate()                                 	
			EndIf
			If !Empty(dMinSld2)
				oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cTpSld2,cMoeda,dDataIni,cOrigem,dMinSld2,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt)},"","",.F.)
				oProcess:Activate()				
			EndIf
		Else
			If !Empty(dMinSld1) .Or. !Empty(dMinSld2)
				cMensagem	:= STR0016
				cMensagem	+= STR0017
				MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
										  					//atraves da rotina de saldos compostos	
				Return
			EndIf    
		EndIf

		Do Case
		Case cIdent == 'CTT'   
			cCodEnt		:= 'CUSTO'
			cCodEntSup	:= 'CCSUP'
			nTamDesc	:= Len(CriaVar("CTT->CTT_DESC"+cMoeda))
		Case cIdent=='CTD'     
			cCodEnt		:= 'ITEM'
			cCodEntSup  := 'ITSUP'
			nTamDesc	:= Len(CriaVar("CTD->CTD_DESC"+cMoeda))	
		Case cIdent =='CTH'    
			cCodEnt		:= 'CLVL'
			cCodEntSup  := 'CLSUP'     
			nTamDesc	:= Len(CriaVar("CTH->CTH_DESC"+cMoeda))
		EndCase

		dbSelectArea(cIdent)
		dbSetOrder(1)
		MsSeek(xFilial()+cEntidIni,.T.)

		While 	!Eof() .And. &(cIdent + "_FILIAL") == xFilial() .And.;	
				&(cIdent + "_" + cCodEnt) >= cEntidIni .And.;
				&(cIdent + "_" + cCodEnt) <= cEntidFim

      	  cCodigo :=  &(cIdent + "_" + cCodEnt)		// Codigo Atual
			If !Empty(aSetOfBook[1]) .And. !(aSetOfBook[1] $ &(cIdent+"_BOOK"))
				dbSkip()
				Loop
			Endif                  

			//Caso faca filtragem por segmento de item,verifico se esta dentro 
			//da solicitacao feita pelo usuario. 
			If !Empty(cSegmento)
				If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
					If  !(Substr(cCodigo,nPos,nDigitos) $ (cFiltSegm) ) 
						dbSkip()
						Loop
					EndIf	
				Else
					If 	Substr(cCodigo,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
						Substr(cCodigo,nPos,nDigitos) > Alltrim(cSegFim)
						dbSkip()
						Loop
					EndIf	
				Endif
			EndIf	
                                       
			Do Case
			 Case cIdent == 'CTT'   
	            nMovSld1 :=	MovCusto("",cCodigo,dDataIni,dDataFim,cMoeda,cTpSld1,3) 
	            nMovSld2 :=	MovCusto("",cCodigo,dDataIni,dDataFim,cMoeda,cTpSld2,3)
			 
			 Case cIdent=='CTD'     
	 			   nMovSld1 :=	MovItem("","",cCodigo,dDataIni,dDataFim,cMoeda,cTpSld1,3) 
	 			   nMovSld2 :=	MovItem("","",cCodigo,dDataIni,dDataFim,cMoeda,cTpSld2,3)
			 
			 Case cIdent =='CTH'    
					nMovSld1 :=	MovClass("","","",cCodigo,dDataIni,dDataFim,cMoeda,cTpSld1,3) 
					nMovSld2 :=	MovClass("","","",cCodigo,dDataIni,dDataFim,cMoeda,cTpSld2,3)
			EndCase

			
	  		If !lVariacao0
				If 	nMovSld1 = 0 .And. nMovSld2 = 0
					dbSkip()
					Loop
				EndIf	
			EndIf	
			
			If lVariacao0 .And. nMovSld1 = 0 .And. nMovSld2 = 0
				If CtbExDtFim(cIdent) 
					If !CtbVlDtFim(cIdent,dDataIni) 		
						dbSelectArea(cIdent)
						dbSkip()
						Loop				
					EndIf		
				EndIf		
			EndIf
	  		
			cDesc := &(cIdent+"->"+cIdent+"_DESC"+cMoeda)
			If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
				cDesc := &(cIdent+"->"+cIdent+"_DESC01")
			Endif

			dbSelectArea("cArqTmp")
			dbSetOrder(1)	
			If !MsSeek(cCodigo)
				dbAppend()   
				If cIdent == 'CTT'
					Replace CUSTO   	With cCodigo
					Replace DESCCC		With cDesc
					Replace TIPOCC 	With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES	
				ElseIf cIdent == 'CTD'
					Replace ITEM 		With cCodigo
					Replace DESCITEM	With cDesc
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES
				ElseIf cIdent == 'CTH'
					Replace CLVL    	 With cCodigo
					Replace DESCCLVL	 With cDesc
					Replace TIPOCLVL 	 With CTH->CTH_CLASSE
					Replace CLSUP    	 With CTH->CTH_CLSUP
					Replace CLVLRES		 With CTH->CTH_RES
				EndIf
			EndIf           

			If nDivide > 1
				nMovSld1 := Round(NoRound((nMovSld1/nDivide),3),2)
				nMovSld2 := Round(NoRound((nMovSld2/nDivide),3),2)
			EndIf	
				
			dbSelectArea("cArqTmp")
			dbSetOrder(1)
			
			Replace MOVIMENTO1 With nMovSld1	//Movimento Tipo de Saldo 1
			Replace MOVIMENTO2 With nMovSld2	//Movimento Tipo de Saldo 2
		
			If nMovSld1 = 0 .Or. nMovSld2 = 0						
				Replace VARIACAO   With 0
			Else
				Replace VARIACAO   With (nMovSld1/nMovSld2) *100
			EndIf		 		
		
			If bVariacao <> Nil
				Eval(bVariacao)
			Endif		
		
		
		dbSelectArea(cIdent)
		dbSkip()
		Enddo   
		
		// Grava sinteticas
		dbSelectArea("cArqTmp")	
		dbGoTop()  

		While!Eof()                                 
                                            
			nMovim01	:= MOVIMENTO1
			nMovim02	:= MOVIMENTO2
			If FieldPos("COLUNA_1") > 0
				nColuna1 := COLUNA_1
				nColuna2 := COLUNA_2
			Else
				nColuna1 := nColuna2 := 0.00
			Endif
			
			nRegTmp := Recno()  
	
			dbSelectArea(cIdent)
			dbSetOrder(1)      
			cEntidSup := &("cArqTmp->"+cCodEntSup)
			If Empty(cEntidSup)
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea(cIdent)
			EndIf		
			MsSeek(xFilial()+ &("cArqTmp->"+cCodEntSup))
		
			While !Eof() .And. &(cIdent+"_FILIAL") == xFilial()
							
				cDesc := &(cIdent+"_DESC"+cMoeda)
				If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
					cDesc := &(cIdent+"_DESC01")
				Endif			
		
				dbSelectArea("cArqTmp")
				dbSetOrder(1)      
				If ! MsSeek(cEntidSup)
					dbAppend()
					If cIdent == 'CTT'
						Replace CUSTO   	With cEntidSup
						Replace DESCCC		With cDesc
						Replace TIPOCC 		With CTT->CTT_CLASSE
						Replace CCSUP 		With CTT->CTT_CCSUP					
						Replace CCRES		With CTT->CTT_RES				
					ElseIf cIdent == 'CTD'
						Replace ITEM 		With cEntidSup
						Replace DESCITEM	With cDesc
						Replace TIPOITEM 	With CTD->CTD_CLASSE
						Replace ITSUP  		With CTD->CTD_ITSUP					
						Replace ITEMRES		With CTD->CTD_RES				
					ElseIf cIdent == 'CTH'
						Replace CLVL 	 With cEntidSup
						Replace DESCCLVL With cDesc
						Replace TIPOCLVL With CTH->CTH_CLASSE
						Replace CLSUP	 With CTH->CTH_CLSUP 
						Replace CLVLRES	 With CTH->CTH_RES				
					EndIf						
				EndIf				

				Replace	 MOVIMENTO1 With MOVIMENTO1 + nMovim01
				Replace  MOVIMENTO2 With MOVIMENTO2 + nMovim02
			
				If MOVIMENTO1 = 0 .Or. MOVIMENTO2 = 0						
					Replace VARIACAO   With 0
				Else
					Replace VARIACAO   With (MOVIMENTO1/MOVIMENTO2)*100
				EndIf		 		
		   		
				If nColuna1 # 0
					Replace COLUNA_1 With COLUNA_1 + nColuna1
				Endif
		   		
				If nColuna2 # 0
					Replace COLUNA_2 With COLUNA_2 + nColuna2
				Endif
		   		
				If bVariacao <> Nil
					Eval(bVariacao)
				Endif
   		
				cEntidSup := &("cArqTmp->"+cCodEntSup)
				If Empty(cEntidSup)
					dbSelectArea("cArqTmp")
					Replace NIVEL1 With .T.
					dbSelectArea(cIdent)
					Exit                     						
				EndIf		
				dbSelectArea("cArqTmp")
				dbGoto(nRegTmp)
				dbSelectArea(cIdent)
				MsSeek(xFilial()+ cEntidSup)
			EndDo
			dbSelectArea("cArqTmp")
			dbGoto(nRegTmp)
			dbSkip()
		EndDo
EndIf
RestArea(aSaveArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtCmpEntid³ Autor ³ Simone Mie Sato       ³ Data ³ 29.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Balancetes Entidade1/Entidade2³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oMeter      = Objeto oMete                                 ³±±
±±³          ³ oText       = Objeto oText                                 ³±±
±±³          ³ ODlg        = Objeto oDlg                                  ³±±
±±³          ³ lEnd     = lEnd                                            ³±±
±±³          ³ dDataIni    = Data Inicial                                 ³±±
±±³          ³ dDataFim    = Data Final                                   ³±±
±±³          ³ cEntidIni1  = Cod. Inicial Entidade Principal              ³±±
±±³          ³ cEntidFim1  = Cod. Final Entidade Principal                ³±±
±±³          ³ cHeader     = Identifica qual a Entidade Principal         ³±±
±±³          ³ cMoeda      = Moeda                                        ³±±
±±³          ³ cSaldos     = Tipo de Saldo                                ³±±
±±³          ³ aSetOfBook  = Set Of Book                                  ³±±
±±³          ³ cSegmento   = Segmento a ser filtrado                      ³±±
±±³          ³ cSegIni     = Segmento Inicial                             ³±±
±±³          ³ cSegFim     = Segmento Final                               ³±±
±±³          ³ cFiltSegm   = Segmento Contido em                          ³±±
±±³          ³ cAlias      =                                              ³±±
±±³          ³ lCusto      =                                              ³±±
±±³          ³ lItem       =                                              ³±±
±±³          ³ lClVl       =                                              ³±±
±±³          ³ lAtSldBase  =                                              ³±±
±±³          ³ lAtSldCmp   =                                              ³±±
±±³          ³ nInicio     = Moeda inicial                                ³±±
±±³          ³ nFinal      = Moeda Final                                  ³±±
±±³          ³ cFilDe		= Da Filial									  ³±±
±±³          ³ cFilAte		= Ate a Filial								  ³±±
±±³          ³ lImpAntLp	= Define se considera Lucros/Perdas			  ³±±
±±³          ³ dDataLP		= Data de Apuracao de Lucros				  ³±±
±±³          ³ nDivide		= Fator de divisao p/ impressao dos valores	  ³±±
±±³          ³ cTpVlr		= Se eh Saldo ou Movimento					  ³±±
±±³          ³ lVlrZerado	= Se imprime com valor zerado				  ³±±
±±³          ³ aEntid		= Matriz contenndo as entid. a serem impressas³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                       
Function CtCmpEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,;
			cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
			cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
			cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lVlrZerado,aEntid)				
		         
Local aSaveArea 	:= GetArea()
Local aMovimento	:= {0,0,0,0,0,0}

Local cMascara	 	:= ""
Local cEntid		:= ""	//Codigo da Entidade Principal
Local cCodigo		:= ""
Local cCadAlias		:= ""	//Alias do Cadastro da Entidade Principal
Local cDesc			:= ""
Local cDescEnt		:= ""
Local cCodSup 		:= ""	//Cod.Superior da Entidade Principal
Local cOrigem		:= ""
Local cMensagem		:= OemToAnsi(STR0016)+ OemToAnsi(STR0017)
Local nMeter		:= 0

Local nPos			:= 0
Local nDigitos		:= 0
Local nSaldoDeb 	:= 0
Local nSaldoCrd 	:= 0
Local nSaldoAntD	:= 0
Local nSaldoAntC	:= 0
Local nSaldoAtuD	:= 0
Local nSaldoAtuC	:= 0
Local nRegTmp   	:= 0
Local nOrder		:= 0
Local nRecno 		:= ""
Local nTamDesc		:= ""
Local nTotVezes		:= 0
Local nCont			:= 0 
Local nVezes		:= 0 
Local nTotal		:= 0

Local dMinData	                                      

aEntid  			:= Iif(aEntid ==Nil,{},aEntid)	
nDivide 			:= Iif(nDivide == Nil,1,nDivide)
lVlrZerado			:= Iif(lVlrZerado == Nil,.T.,lVlrZerado)

Do Case
Case cAlias == 'CTV'     
	cOrigem		:= 'CT4'	
	If cHeader == 'CTT'		//Se for C.Custo/Item
		nOrder 		:= 2
		cCadAlias	:= 'CTT'
		cCodEnt 	:= 'CUSTO' 
		cCodSup		:= 'CCSUP'
		cMascara	:= aSetOfBook[6]	//Mascara do Centro de Custo
		nTamDesc	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))
		cDescEnt	:= "DESCCC"
		
	ElseIf cHeader == 'CTD' 	//Se for Item/C.Custo                              	
		nOrder 		:= 1	
		cCadAlias	:= 'CTD'
		cCodEnt		:= 'ITEM' 
		cCodSup		:= 'ITSUP'
		cMascara	:= aSetOfBook[7]	//Mascara do Item	
		nTamDesc	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))
		cDescEnt	:= "DESCITEM"
	EndIf	
Case cAlias == 'CTW'	
	cOrigem		:= 'CTI'	
	If cHeader == 'CTH'//Se for Cl.Valor/C.Custo
		nOrder 		:= 1      
		cCadAlias	:= 'CTH'	
		cCodEnt		:= 'CLVL'  
		cCodSup		:= 'CLSUP'
		cMascara	:= aSetOfBook[8]	//Mascara da Classe de Valor
		nTamDesc	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))
		cDescEnt	:= "DESCCLVL"		
	ElseIf cHeader == 'CTT'//Se for C.Custo/Cl.Valor
		nOrder 		:= 2      
		cCadAlias	:= 'CTT'
		cCodEnt		:= 'CUSTO'  
		cCodSup	  	:= 'CCSUP'
		cMascara	:= aSetOfBook[6]	//Mascara do Centro de Custo
		nTamDesc	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))
		cDescEnt	:= "DESCCC"		
	EndIf
Case cAlias == 'CTX'   
	cOrigem		:= 'CTI'	 
	If cHeader == 'CTH'//Se for Cl.Valor/Item
		nOrder 		:= 2      
		cCadAlias	:= 'CTH'
		cCodEnt		:= 'CLVL'
		cCodSup		:= 'CLSUP'      
		cMascara	:= aSetOfBook[8]	//Mascara da Cl.Valor
		nTamDesc	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))
		cDescEnt	:= "DESCCLVL"		
	ElseIf cHeader == 'CTD'//Se for Item/Cl.Valor
		nOrder		:= 1
		cCadAlias	:= 'CTD'
		cCodEnt		:=	'ITEM'
		cCodSup  	:=	'ITSUP'
		cMascara	:= aSetOfBook[7]	//Mascara do Item Contab.
		nTamDesc	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))
		cDescEnt	:= "DESCITEM"		
	EndIf
EndCase

//cChave 		:= xFilial(cAlias)+cMoeda+cSaldos+cEntidIni1+cEntidIni2+dtos(dDataIni)
bCond		:= {||&(cCadAlias+"->"+cCadAlias+"_FILIAL") == xFilial(cCadAlias) .And. &(cCadAlias+"->"+cCadAlias+"_"+cCodEnt) >= cEntidIni .And. &(cCadAlias+"->"+cCadAlias+"_"+cCodEnt) <= cEntidFim }


//Verificar se tem algum saldo a ser atualizado
Ct360Data(cOrigem,,@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt)

//Se o parametro MV_SLDCOMP estiver com "S",isto e, se devera atualizar os saldos compost.
//na emissao dos relatorios, verifica se tem algum registro desatualizado e atualiza as
//tabelas de saldos compostos.

If lAtSldCmp .And. !Empty(dMinData)	//Se atualiza saldos compostos
	oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cSaldos,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt)},"","",.F.)
	oProcess:Activate()	
Else		//Se nao atualiza os saldos compostos, somente da mensagem
	If !Empty(dMinData)
		MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
										//atraves da rotina de saldos compostos	
		Return
	EndIf    
EndIf

// Verifica Filtragem por Segmento da Entidade
If !Empty(cSegmento)
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cMascara)
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascara
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == cSegmento
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	EndIf	
EndIf		

dbSelectarea(cCadAlias)
If ValType(oMeter) == "O"
	oMeter:SetTotal((cCadAlias)->(RecCount()))
	oMeter:Set(0)
EndIF
dbSetOrder(1)
MsSeek(xFilial()+cEntidIni,.T.)
                                                       
While !Eof() .And. Eval(bCond)	
	If ValType(oMeter) == "O"
		nMeter++
   		oMeter:Set(nMeter)				
  	EndIF
		
	If &(cCadAlias+"->"+cCadAlias+"_CLASSE") <> '2'	//Se for sintetico
		dbSkip()
		Loop
	Endif
	
	//Verifico Set of Book da Entidade Principal	
	If !Empty(aSetOfBook[1])	
		If !(aSetOfBook[1] $ &(cCadAlias+"->"+cCadAlias+"_BOOK"))
			dbSkip()
			Loop
		EndIf

    EndIf
    cCodigo 	:= &(cCadAlias+"->"+cCadAlias+"_"+cCodEnt)	//Codigo Atual 
    cDescEnt	:= (cCadAlias+"->"+cCadAlias+"_DESC")
	cDesc 		:= &(cDescEnt+cMoeda)	                     
	If Empty(cDesc)	// Caso nao preencher descricao da moeda selecionada
		cDesc 	:= &(cDescEnt+"01")
	Endif
	cEntid		:= &(cCadAlias+"->"+cCadAlias+"_"+cCodent)		
	nRecno		:= Recno()		
	
	nTotVezes := Len(aEntid)		
	
	//Caso faca filtragem por segmento de item,verifico se esta dentro 
	//da solicitacao feita pelo usuario. 
	If !Empty(cSegmento)
		If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
			If  !(Substr(cCodigo,nPos,nDigitos) $ (cFiltSegm) ) 
				dbSkip()
				Loop
			EndIf	
		Else
			If 	Substr(cCodigo,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
				Substr(cCodigo,nPos,nDigitos) > Alltrim(cSegFim)
				dbSkip()
				Loop
			EndIf	
		Endif
	EndIf	
                                       
	For nVezes := 1 to nTotVezes

		aSaldoAnt := SldCmpEnt(cEntid,aEntid[nVezes],dDataIni,cMoeda,cSaldos,nOrder,cHeader,cAlias,,,lImpAntLP,dDataLP)
		aSaldoAtu := SldCmpEnt(cEntid,aEntid[nVezes],dDataFim,cMoeda,cSaldos,nOrder,cHeader,cAlias,,,lImpAntLP,dDataLP)

		If nDivide > 1	
			For nCont := 1 To Len(aSaldoAnt)
				aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
			Next nCont
				
			For nCont := 1 To Len(aSaldoAtu)
				aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
			Next nCont
    	EndIf
    	
		nSaldoAntD 	:= aSaldoAnt[7]
		nSaldoAntC 	:= aSaldoAnt[8]

		nSaldoAtuD 	:= aSaldoAtu[4]
		nSaldoAtuC 	:= aSaldoAtu[5] 
   	
		nSaldoDeb  := nSaldoAtuD - nSaldoAntD
		nSaldoCrd  := nSaldoAtuC - nSaldoAntC
			
		If !lVlrZerado
	    	If (nSaldoCrd - nSaldoDeb) == 0	//Se o movimento do periodo for zero.
				Loop	
	    	EndIf	
	    EndIf	
	    
		cSeek	:= cEntid
			
		dbSelectArea("cArqTmp")
		dbSetOrder(1)	
		If !MsSeek(cSeek)
			dbAppend()   
			Do Case
			Case cAlias == 'CTV'      
				If cHeader	== 'CTT'	//Se for Centro de Custo/Item
					Replace CUSTO   	With cEntid
					Replace DESCCC		With cDesc
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES	
				ElseIf cHeader == 'CTD'	//Se for Item/C.Custo
					Replace ITEM 		With cEntid
					Replace DESCITEM	With cDesc
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES					
				EndIf			
			Case cAlias == 'CTW'
				If cHeader	== 'CTH'		//Se for Cl.Valor/C.Custo
					Replace CLVL    	With cEntid
					Replace DESCCLVL	With cDesc
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES
				ElseIf cHeader	== 'CTT'	//Se for C.Custo/Cl.Valor
					Replace CUSTO   	With cEntid
					Replace DESCCC		With cDesc
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES				                        	
				EndIf
			Case cAlias == 'CTX'                   
				If cHeader == 'CTH'	//Se for Cl.Valor/Item
					Replace CLVL    	With cEntid
					Replace DESCCLVL	With cDesc
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES
				ElseIf cHeader	== 'CTD'	//Se for Item/Cl.Valor
					Replace ITEM		With cEntid
					Replace DESCITEM	With cDesc
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES					
				Endif
			EndCase
		EndIf           
			   	
		If cTpVlr == 'M'
			&("COLUNA"+Str(nVezes,1)) := (nSaldoCrd-nSaldoDeb)
		EndIf                
		
		aSaldoAnt	:= {}
		aSaldoAtu	:= {}		
	Next		
		
	dbSelectArea(cCadAlias)
	dbSetOrder(nOrder)
	dbGoto(nRecno)
	dbSkip()       		
Enddo              
/*	
// Grava sinteticas
dbSelectArea("cArqTmp")	
oMeter:SetTotal(cArqTmp->(RecCount()))
oMeter:Set(0)
dbGoTop()  

While!Eof()                                                                         
	nMeter++
   	oMeter:Set(nMeter)				

	nRegTmp := Recno()  
	aMovimento	:= {0,0,0,0,0,0}    	   		    
	
	For nVezes := 1 to nTotVezes
		aMovimento[nVezes] := &("COLUNA"+Str(nVezes,1))	
	Next
	
	dbSelectArea(cCadAlias)
	dbSetOrder(1)      
	If Empty(&(cCadAlias+"->"+cCadAlias+"_"+cCodSup))
		dbSelectArea("cArqTmp")
		Replace NIVEL1 With .T.
		dbSelectArea(cCadAlias)
	EndIf		
	MsSeek(xFilial(cCadAlias)+ &("cArqTmp->"+cCodSup))
		
	While !Eof() .And. &(cCadAlias+"->"+cCadAlias+"_FILIAL") == xFilial()

		cEntid	 := &("cArqTmp->"+cCodEnt)
		cDescEnt := (cCadAlias+"->"+cCadAlias+"_DESC")
		cEntSup  := &(cCadAlias+"->"+cCadAlias+"_"+cCodEnt)										
		cSeek 	 := cEntSup
		cDesc 	 := &(cDescEnt+cMoeda)			        
		If Empty(cDesc)	// Caso nao preencher descricao da moeda selecionada
			cDesc := &(cDescEnt+"01")
		Endif
		
		dbSelectArea("cArqTmp")
		dbSetOrder(1)      
		If !MsSeek(cSeek)
			dbAppend()
			Do Case
			Case cAlias == 'CTV'      
				If cHeader	== 'CTT'	//Se for Centro de Custo/Item
					Replace CUSTO   	With cEntSup
					Replace DESCCC		With cDesc
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES	
				ElseIf cHeader == 'CTD'	//Se for Item/C.Custo
					Replace ITEM 		With cEntSup
					Replace DESCITEM	With cDesc
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES					
				EndIf			
			Case cAlias == 'CTW'
				If cHeader	== 'CTH'		//Se for Cl.Valor/C.Custo
					Replace CLVL    	With cEntSup
					Replace DESCCLVL	With cDesc
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES
				ElseIf cHeader	== 'CTT'	//Se for C.Custo/Cl.Valor
					Replace CUSTO   	With cEntSup
					Replace DESCCC		With cDesc
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES				                        	
				EndIf
			Case cAlias == 'CTX'                   
				If cHeader == 'CTH'	//Se for Cl.Valor/Item
					Replace CLVL    	With cEntSup
					Replace DESCCLVL	With cDesc
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES
				ElseIf cHeader	== 'CTD'	//Se for Item/Cl.Valor
					Replace ITEM		With cEntSup
					Replace DESCITEM	With cDesc
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES					
				Endif
			EndCase
		
		EndIf    
		
		For nVezes := 1 to nTotVezes
			If cTpVlr == 'M'
				Replace &("COLUNA"+	Str(nVezes,1)) With (&("COLUNA"+Str(nVezes,1))+aMovimento[nVezes])
			EndIf
	  	Next
		
		dbSelectArea(cCadAlias)
		If Empty(&(cCadAlias+"->"+cCadAlias+"_"+cCodSup))
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea(cCadAlias)
			Exit                     						
		EndIf		
		dbSelectArea(cCadAlias)
		MsSeek(xFilial(cCadAlias)+ &("cArqTmp->"+cCodSup))
	EndDo
	dbSelectArea("cArqTmp")
	dbGoto(nRegTmp)
	dbSkip()
EndDo
*/
RestArea(aSaveArea)

Return				
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ct2EntFil ³ Autor ³ Simone Mie Sato       ³ Data ³ 09.05.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arq. Temp. p/ Balancete c/ 2 Entidades filt. pela 3a. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oMeter	  = Controle da regua                             ³±±
±±³          ³ oText 	  = Controle da regua                             ³±±
±±³          ³ oDlg  	  = Janela                                        ³±±
±±³          ³ lEnd  	  = Controle da regua -> finalizar                ³±±
±±³          ³ dDataIni   = Data Inicial de processamento                 ³±±
±±³          ³ dDataFinal = Data Final de processamento                   ³±±
±±³          ³ cEntidIni  = Codigo Entidade Inicial                       ³±±
±±³          ³ cEndtidFim = Codigo Entidade Final                         ³±±
±±³          ³ cMoeda     = Moeda		                                  ³±±
±±³          ³ cSaldos    = Tipos de Saldo a serem processados            ³±±
±±³          ³ aSetOfBook = Matriz de configuracao de livros              ³±±
±±³          ³ cSegmento  = Indica qual o segmento será filtrado          ³±±
±±³          ³ cSegIni    = Conteudo inicial do segmento                  ³±±
±±³          ³ cSegFim    = Conteudo Final do segmento                    ³±±
±±³          ³ cFiltSegm  = Indica se filtrara ou nao segmento            ³±±
±±³          ³ lNImpMov   = Indica se imprime ou nao a coluna movimento   ³±±
±±³          ³ cAlias     = Alias para regua       	                      ³±±
±±³          ³ cIdent     = Identificador do arquivo a ser processado     ³±±
±±³          ³ lCusto     = Considera Centro de Custo?                    ³±±
±±³          ³ lItem      = Considera Item Contabil?                      ³±±
±±³          ³ lCLVL      = Considera Classe de Valor?                    ³±±
±±³          ³ lAtSldBase = Indica se deve chamar rot atual. saldo basico ³±±
±±³          ³ lAtSldCmp  = Indica se deve chamar rot atua. saldo composto³±±
±±³          ³ nInicio    = Moeda Inicial (p/ atualizar saldo)            ³±±
±±³          ³ nFinal     = Moeda Final (p/ atualizar saldo)              ³±±
±±³          ³ cFilde     = Filial inicial (p/ atualizar saldo)           ³±±
±±³          ³ cFilAte    = Filial final (p/atualizar saldo)              ³±±
±±³          ³ lImpAntLP  = Imprime lancamentos Lucros e Perdas?          ³±±
±±³          ³ dDataLP    = Data ultimo Lucros e Perdas                   ³±±
±±³          ³ nDivide    = Divide valores (100,1000,1000000)             ³±±
±±³          ³ lVlrZerado = Grava ou nao valores zerados no arq temporario³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                       
Function Ct2EntFil(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cAlias,lCusto,lItem,lClvl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,;
				cFilAte,lImpAntLP,dDataLP,nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt)				         
				         
Local aSaveArea 	:= GetArea()                                                   

Local nPos			:= 0
Local nDigitos		:= 0
local nSaldoAnt 	:= 0
Local nSaldoDeb 	:= 0
Local nSaldoCrd 	:= 0
Local nSaldoAtu 	:= 0
Local nSaldoAntD	:= 0
Local nSaldoAntC	:= 0
Local nSaldoAtuD	:= 0
Local nSaldoAtuC	:= 0
Local nSldAnt		:= 0
Local nSldAtu		:= 0
Local nRegTmp   	:= 0
Local nMovimento	:= 0 
Local nOrder		:= 0
Local nRecno1		:= 0
Local nRecno2		:= 0
Local nTamDesc1		:= ""
Local nTamDesc2		:= ""
Local nIndex		:= 0
Local nMeter		:= 0
Local nCont			:= 0 
Local nTotal		:= 0

Local cEntid1		:= ""	//Codigo da Entidade Principal
Local cEntid2   	:= "" 	//Codigo da Entidade do Corpo do Relatorio              
Local cCadAlias1	:= ""	//Alias do Cadastro da Entidade Principal
Local cCadAlias2	:= ""	//Alias do Cadastro da Entidade que sera impressa no corpo.
Local cCodEnt1		:= ""	//Codigo da Entidade Principal
Local cCodEnt2		:= ""	//Codigo da Entidade que sera impressa no corpo do relat.
Local cDesc1		:= ""
Local cDesc2		:= ""
Local cDescEnt1		:= ""	//Descricao da Entidade Principal                           
Local cDescEnt2		:= ""	//Descricao da Entidade que sera impressa no corpo.                          
Local cCodSup1		:= ""	//Cod.Superior da Entidade Principal
Local cCodSup2		:= ""	//Cod.Superior da Entidade que sera impressa no corpo.
Local cMensagem		:= OemToAnsi(STR0016)+ OemToAnsi(STR0017)
Local cKey			:= ""
Local cFiltro		:= ""
Local cEntRes1		:= ""
Local cEntRes2		:= ""
Local cClasse1		:= ""
Local cClasse2		:= ""
Local cEntSup1		:= ""
Local cEntSup2		:= ""

Local bCond1		:= {||.F.}
Local bCond2		:= {||.F.}

Local dMinData	                                      

lVlrZerado	:= Iif(lVlrZerado == Nil,.T.,lVlrZerado)
nDivide 	:= Iif(nDivide == Nil,1,nDivide)

Do Case
Case cHeader == 'CTT' .And. cFiltroEnt	== 'CTD'
	cCadAlias1	:= 'CTT'
	cCadAlias2	:= 'CTH'
	cCodEnt1	:= 'CUSTO' 
	cCodEnt2	:=	'CLVL'
	cCodSup1	:= 'CCSUP'
	cCodSup2	:= 'CLSUP'		
	nTamDesc1	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))
	nTamDesc2	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))		
	cDescEnt1	:= "DESCENT1"                     
	cDescEnt2	:= "DESCENT2"
	cFiltro		:= 'CTY_ITEM = "'+cCodFilEnt+'"'
	cKey 		:= "CTY_FILIAL+CTY_MOEDA+CTY_TPSALD+CTY_CUSTO+CTY_CLVL+DTOS(CTY_DATA)" 		
Case cHeader == 'CTT' .And. cFiltroEnt	== 'CTH'	
	cCadAlias1	:= 'CTT'
	cCadAlias2	:= 'CTD'
	cCodEnt1	:= 'CUSTO' 
	cCodEnt2	:=	'ITEM'
	cCodSup1	:= 'CCSUP'
	cCodSup2	:= 'ITSUP'		
	nTamDesc1	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))
	nTamDesc2	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))		
	cDescEnt1	:= "DESCENT1"                     
	cDescEnt2	:= "DESCENT2"
	cFiltro		:= 'CTY_CLVL = "'+cCodFilEnt+'"'
	cKey		:= "CTY_FILIAL+CTY_MOEDA+CTY_TPSALD+CTY_CUSTO+CTY_ITEM+DTOS(CTY_DATA)" 			    
Case cHeader == 'CTD' .And. cFiltroEnt == 'CTT'
	cCadAlias1	:= 'CTD'
	cCadAlias2	:= 'CTH'
	cCodEnt1	:= 'ITEM' 
	cCodEnt2	:=	'CLVL'
	cCodSup1	:= 'ITSUP'
	cCodSup2	:= 'CLSUP'		
	nTamDesc1	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))
	nTamDesc2	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))		
	cDescEnt1	:= "DESCENT1"                     
	cDescEnt2	:= "DESCENT2"
	cFiltro		:= 'CTY_CUSTO = "'+cCodFilEnt+'"'
	cKey		:= "CTY_FILIAL+CTY_MOEDA+CTY_TPSALD+CTY_ITEM+CTY_CLVL+DTOS(CTY_DATA)" 			
Case cHeader == 'CTD' .And. cFiltroEnt == 'CTH'
	cCadAlias1	:= 'CTD'
	cCadAlias2	:= 'CTT'
	cCodEnt1	:= 'ITEM' 
	cCodEnt2	:=	'CUSTO'
	cCodSup1	:= 'ITSUP'
	cCodSup2	:= 'CCSUP'		
	nTamDesc1	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))
	nTamDesc2	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))		
	cDescEnt1	:= "DESCENT1"                     
	cDescEnt2	:= "DESCENT2"
	cFiltro		:= 'CTY_CLVL = "'+cCodFilEnt+'"'
	cKey		:= "CTY_FILIAL+CTY_MOEDA+CTY_TPSALD+CTY_ITEM+CTY_CUSTO+DTOS(CTY_DATA)" 			
Case cHeader == 'CTH' .And. cFiltroEnt == 'CTT'
	cCadAlias1	:= 'CTH'
	cCadAlias2	:= 'CTD'
	cCodEnt1	:= 'CLVL' 
	cCodEnt2	:=	'ITEM'
	cCodSup1	:= 'CLSUP'
	cCodSup2	:= 'ITSUP'		
	nTamDesc1	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))
	nTamDesc2	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))		
	cDescEnt1	:= "DESCENT1"                     
	cDescEnt2	:= "DESCENT2"
	cFiltro		:= 'CTY_CUSTO = "'+cCodFilEnt+'"'
	cKey		:= "CTY_FILIAL+CTY_MOEDA+CTY_TPSALD+CTY_CLVL+CTY_ITEM+DTOS(CTY_DATA)" 			
Case cHeader == 'CTH' .And. cFiltroEnt == 'CTD'
	cCadAlias1	:= 'CTH'
	cCadAlias2	:= 'CTT'
	cCodEnt1	:= 'CLVL' 
	cCodEnt2	:=	'CUSTO'
	cCodSup1	:= 'CLSUP'
	cCodSup2	:= 'CCSUP'		
	nTamDesc1	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))
	nTamDesc2	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))		
	cDescEnt1	:= "DESCENT1"                     
	cDescEnt2	:= "DESCENT2"
	cFiltro		:= 'CTY_ITEM = "'+cCodFilEnt+'"'
	cKey		:= "CTY_FILIAL+CTY_MOEDA+CTY_TPSALD+CTY_CLVL+CTY_CUSTO+DTOS(CTY_DATA)" 			
EndCase                      

//Cria indice temporario para o arquivo CTY
cIndex	:= CriaTrab(nil,.f.)
IndRegua("CTY",cIndex,cKey,, cFiltro,OemToAnsi(STR0001)) //"Selecionando Registros..."
nIndex	:= RetIndex("CTY")
#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF             
nOrder	:= (nIndex+1)
dbSetOrder(nOrder)

bCond1		:= {||&(cCadAlias1+"->"+cCadAlias1+"_FILIAL") == xFilial(cCadAlias1) .And. &(cCadAlias1+"->"+cCadAlias1+"_"+cCodEnt1) >= cEntidIni1 .And. &(cCadAlias1+"->"+cCadAlias1+"_"+cCodEnt1) <= cEntidFim1 }
bCond2		:= {||&(cCadAlias2+"->"+cCadAlias2+"_FILIAL") == xFilial(cCadAlias2) .And. &(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2) >= cEntidIni2 .And. &(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2) <= cEntidFim2 }


//Verificar se tem algum saldo a ser atualizado
Ct360Data('CTI',,@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt)

//Se o parametro MV_SLDCOMP estiver com "S",isto e, se devera atualizar os saldos compost.
//na emissao dos relatorios, verifica se tem algum registro desatualizado e atualiza as
//tabelas de saldos compostos.

If lAtSldCmp .And. !Empty(dMinData)	//Se atualiza saldos compostos
	oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cSaldos,cMoeda,dDataIni,'CTI',dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt)},"","",.F.)
	oProcess:Activate()	
Else		//Se nao atualiza os saldos compostos, somente da mensagem
	If !Empty(dMinData)
		MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
										//atraves da rotina de saldos compostos	
		Return
	EndIf    
EndIf

// Verifica Filtragem por Segmento da Entidade
If !Empty(cSegmento)
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cMascara2)
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascara2 
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == cSegmento
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	EndIf	
EndIf		

dbSelectarea(cCadAlias1)
If ValType(oMeter) == "O"
	oMeter:SetTotal((cCadAlias1)->(RecCount()))
	oMeter:Set(0)
EndIf
dbSetOrder(1)
MsSeek(xFilial()+cEntidIni1,.T.)
                                                       
While !Eof() .And. Eval(bCond1)	
	If ValType(oMeter) == "O"
		nMeter++
   		oMeter:Set(nMeter)
	EndIF
	If &(cCadAlias1+"->"+cCadAlias1+"_CLASSE") <> '2'	//Se for sintetico
		dbSkip()
		Loop
	Endif
	
	//Verifico Set of Book da Entidade Principal	
	If !Empty(aSetOfBook[1])	
		If !(aSetOfBook[1] $ &(cCadAlias1+"->"+cCadAlias1+"_BOOK"))
			dbSkip()
			Loop
		EndIf
    EndIf                                                           
	cEntSup1	:= &(cCadAlias1+"->"+cCadAlias1+"_"+cCodSup1)		    
    cDescEnt1	:= (cCadAlias1+"->"+cCadAlias1+"_DESC")
	cDesc1 		:= &(cDescEnt1+cMoeda)		            
	cEntRes1	:= &(cCadAlias1+"->"+cCadAlias1+"_RES")
	cClasse1	:= (cCadAlias1+"->"+cCadAlias1+"_CLASSE")		    
	
	If Empty(cDesc1)	// Caso nao preencher descricao da moeda selecionada
		cDesc1 	:= &(cDescEnt1+"01")
	Endif
	
	cEntid1		:= &(cCadAlias1+"->"+cCadAlias1+"_"+cCodent1)		
	nRecno1		:= Recno()	
	
    dbSelectArea(cCadAlias2)
    dbSetOrder(1)
    MsSeek(xFilial()+cEntidIni2,.T.)
	
	While !Eof() .And. Eval(bCond2) 
	
		If &(cCadAlias2+"->"+cCadAlias2+"_CLASSE") <> '2'	//Se for sintetico
			dbSkip()
			Loop
		Endif
		                                
		//Verifico Set of Book da Entidade do Corpo do Relatorio	
		If !Empty(aSetOfBook[1])			
			If !(aSetOfBook[1] $ &(cCadAlias2+"->"+cCadAlias2+"_BOOK"))
				dbSkip()
				Loop
			EndIf
		EndIf           
			

		//Caso faca filtragem por segmento de item,verifico se esta dentro 
		//da solicitacao feita pelo usuario. 
		If !Empty(cSegmento)
			If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
				If  !(Substr(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2),nPos,nDigitos) $ (cFiltSegm) ) 
					dbSkip()
					Loop
				EndIf	
			Else
				If Substr(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2),nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
					Substr(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2),nPos,nDigitos) > Alltrim(cSegFim)
					dbSkip()
					Loop
				EndIf	
			Endif
		EndIf	                                        
		
		cEntid2		:= &(cCadAlias2+"->"+cCadAlias2+"_"+cCodent2)	                               
		cDescEnt2	:= (cCadAlias2+"->"+cCadAlias2+"_DESC")
		cEntRes2	:= &(cCadAlias2+"->"+cCadAlias2+"_RES")		     				
		cClasse2	:= &(cCadAlias2+"->"+cCadAlias2+"_CLASSE")		    
		cEntSup2	:= &(cCadAlias2+"->"+cCadAlias2+"_"+cCodSup2)		     						
		cDesc2 		:= &(cDescEnt2+cMoeda)	            
		If Empty(cDesc2)	// Caso nao preencher descricao da moeda selecionada
			cDesc2 	:= &(cDescEnt2+"01")
		Endif
		
		nRecno2		:= Recno()    
	
		// Calculo dos saldos
		aSaldoAnt 	:= SldCmpEnt(cEntid1,cEntid2,dDataIni,cMoeda,cSaldos,nOrder,cHeader,cAlias,cFiltroEnt,cCodFilEnt,lImpAntLP,dDataLP)
		aSaldoAtu 	:= SldCmpEnt(cEntid1,cEntid2,dDataFim,cMoeda,cSaldos,nOrder,cHeader,cAlias,cFiltroEnt,cCodFilEnt,lImpAntLP,dDataLP)
        		
		nSaldoAntD 	:= aSaldoAnt[7]
		nSaldoAntC 	:= aSaldoAnt[8]
		nSldAnt		:= nSaldoAntC - nSaldoAntD
	
		nSaldoAtuD 	:= aSaldoAtu[4]
		nSaldoAtuC 	:= aSaldoAtu[5]         
		nSldAtu		:= nSaldoAtuC - nSaldoAtuD
	
		nSaldoDeb  	:= nSaldoAtuD - nSaldoAntD
		nSaldoCrd  	:= nSaldoAtuC - nSaldoAntC
	    If nDivide > 1
			nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)		
			nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
		EndIf
		
		nMovimento	:= nSaldoCrd-nSaldoDeb
		
		If !lVlrZerado .And. (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0)  .And. ;
			(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
			dbSelectArea(cCadAlias2)
			dbSkip()
			Loop
		EndIf		
		
		
		If lVlrZerado .And.  (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0)  .And. ;
			(nSaldoDeb = 0 .And. nSaldoCrd = 0) 

			If CtbExDtFim(cCadAlias1) 
				If !Empty(&((cCadAlias1)+"->"+(cCadAlias1)+"_DTEXSF")) .And. (dtos(dDataIni) > DTOS(&((cCadAlias1)+"->"+(cCadAlias1)+"_DTEXSF")))					
					dbSelectArea(cCadAlias1)
					dbSkip()
					Loop													
				EndIf			
			EndIf               			
				
				
			If CtbExDtFim(cCadAlias2) 
				If !Empty(&((cCadAlias2)+"->"+(cCadAlias2)+"_DTEXSF")) .And. (dtos(dDataIni) > DTOS(&((cCadAlias2)+"->"+(cCadAlias2)+"_DTEXSF")))					
					dbSelectArea(cCadAlias2)
					dbSkip()
					Loop													
				EndIf			
			EndIf               				
		EndIf    

		cSeek	:= cEntid1+cEntid2
			
		dbSelectArea("cArqTmp")
		dbSetOrder(1)	
		If !MsSeek(cSeek)
			dbAppend()   
			Replace ENTID1   	With cEntid1
			Replace DESCENT1	With cDesc1
			Replace TIPOENT1	With cClasse1
			Replace ENTSUP1		With cEntSup1
			Replace ENTRES1		With cEntRes1
			Replace ENTID2		With cEntid2
			Replace DESCENT2	With cDesc2
			Replace TIPOENT2 	With cClasse2
			Replace ENTSUP2		With cEntsup2
			Replace ENTRES2		With cEntRes2			
		EndIf           
		
	    If nDivide > 1
			For nCont := 1 To Len(aSaldoAnt)
				aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
			Next nCont
			
			For nCont := 1 To Len(aSaldoAtu)
				aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
			Next nCont	
		EndIf	
		
		dbSelectArea("cArqTmp")
		dbSetOrder(1)
		Replace SALDOANT 	With aSaldoAnt[6]		// Saldo anterior
		Replace SALDOANTDB	With aSaldoAnt[7]		// Saldo anterior debito	
		Replace SALDOANTCR	With aSaldoAnt[8]		// Saldo anterior credito	
		Replace SALDOATU 	With aSaldoAtu[1]		// Saldo Atual           
		Replace SALDOATUDB	With aSaldoatu[4]		// Saldo Atual debito
		Replace SALDOATUCR	With aSaldoAtu[5]		// saldo atual credito
	
		Replace  SALDODEB	With nSaldoDeb				// Saldo Debito
		Replace  SALDOCRD	With nSaldoCrd				// Saldo Credito
	
		If !lNImpMov
			Replace MOVIMENTO With SALDOCRD-SALDODEB
		Endif
		
		dbSelectArea(cCadAlias2)
		dbGoto(nRecno2)
		dbSkip()
	Enddo 
	dbSelectArea(cCadAlias1)
	dbGoto(nRecno1)
	dbSkip()
EndDo
	
// Grava sinteticas
dbSelectArea("cArqTmp")	
If ValType(oMeter) == "O"
	oMeter:SetTotal(cArqTmp->(RecCount()))
	oMeter:Set(0)
EndIf
dbGoTop()  

While!Eof()                                 
	If ValType(oMeter) == "O"
		nMeter++
   		oMeter:Set(nMeter)
  	EndIf
                                            
	nSaldoAnt	:= SALDOANT
	nSaldoAtu	:= SALDOATU
	nSaldoDeb	:= SALDODEB
	nSaldoCrd	:= SALDOCRD   
	nMovimento	:= MOVIMENTO
	nSaldoAntD	:= SALDOANTDB
	nSaldoAntC	:= SALDOANTCR	
	nSaldoAtuD	:= SALDOATUDB
	nsaldoAtuC	:= SALDOATUCR

	nRegTmp := Recno()  
	
	dbSelectArea(cCadAlias2)
	dbSetOrder(1)      
	If Empty(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodSup2))
		dbSelectArea("cArqTmp")
		Replace NIVEL1 With .T.
		dbSelectArea(cCadAlias2)
	EndIf		
	MsSeek(xFilial(cCadAlias2)+ cArqTmp->ENTSUP2)
		
	While !Eof() .And. &(cCadAlias2+"->"+cCadAlias2+"_FILIAL") == xFilial()

		cEntid1	 	:= cArqTmp->ENTID1
		cDesc1	 	:= cArqTmp->DESCENT1
		cTipoEnt1   := cArqtmp->TIPOENT1    
		cEntSup1	:= cArqtmp->ENTSUP1
		cEntRes1	:= cArqTmp->ENTRES1
		cEntSup2 	:= &(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2)								
		cTipoEnt2	:= &(cCadAlias2+"->"+cCadAlias2+"_CLASSE")										
		cDescEnt2	:= (cCadAlias2+"->"+cCadAlias2+"_DESC")
		cDesc2		:= &(cDescEnt2+cMoeda)			        
		cEntRes2	:= &(cCadAlias2+"->"+cCadAlias2+"_RES")										
		If Empty(cDesc2)	// Caso nao preencher descricao da moeda selecionada
			cDesc2	:= &(cDescEnt2+"01")
		Endif		

		cSeek 		:= cEntid1+cEntSup2   
		
		
		dbSelectArea("cArqTmp")
		dbSetOrder(1)      
		If !MsSeek(cSeek)
			dbAppend()
			Replace ENTID1  	With cEntid1
			Replace DESCENT1	With cDesc1
			Replace TIPOENT1	With cTipoEnt1
			Replace ENTSUP1 	With cEntSup1
			Replace ENTRES1		With cEntRes1
			Replace ENTID2 		With cEntSup2
			Replace DESCENT2	With cDesc2
			Replace TIPOENT2 	With cTipoEnt2
			Replace ENTSUP2		With cEntSup2
			Replace ENTRES2		With cEntRes2
		EndIf    
		
		Replace	 SALDOANT 	With SALDOANT + nSaldoAnt
		Replace  SALDOANTDB With SALDOANTDB + nSaldoAntD
		Replace  SALDOANTCR	With SALDOANTCR + nSaldoAntC		
		Replace  SALDOATU 	With SALDOATU + nSaldoAtu
		Replace  SALDOATUDB	With SALDOATUDB	+ nSaldoAtuD
		Replace  SALDOATUCR	With SALDOATUCR + nsaldoAtuC		
		Replace  SALDODEB	With SALDODEB + nSaldoDeb
		Replace  SALDOCRD 	With SALDOCRD + nSaldoCrd
		If !lNImpMov
			Replace MOVIMENTO With MOVIMENTO + nMovimento
		Endif
   		
		dbSelectArea(cCadAlias2)
		If Empty(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodSup2))
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea(cCadAlias2)
			Exit                     						
		EndIf		

		dbSelectArea(cCadAlias2)
		MsSeek(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodSup2))
	EndDo
	dbSelectArea("cArqTmp")
	dbGoto(nRegTmp)
	dbSkip()
EndDo
RestArea(aSaveArea)

Return				

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CtbPlGerCm ³Autor  ³ Simone Mie Sato       ³ Data ³ 06.11.02 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Plano Gerencial para Comparativos                           			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTBPlGerCm(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oMeter	= Objeto oMeter                     	               		 ³±±
±±³          ³ oText 	= Objeto oText                      	                	 ³±±
±±³          ³ oDlg  	= Objeto oDlg                       	                	 ³±±
±±³          ³ lEnd 	 = Acao do CodeBlock                 	                	 ³±±
±±³          ³ dDataIni  = Data Inicial                      	                	 ³±±
±±³          ³ dDataFim = Data Final                     	                 		 ³±±
±±³          ³ cMoeda	= Moeda                              	              		 ³±±
±±³          ³ aSetOfBook	= Array aSetOfBook             	                 		 ³±±
±±³          ³ cAlias    	= Alias a ser utilizado        	                 		 ³±±
±±³          ³ cIdent    	= Identficador                 	                 		 ³±±
±±³          ³ lImpAntLP	= Define se ira considerar apuracao de lucros/perdas	 ³±±
±±³          ³ dDataLP  	= Data de apuracao de lucros/perdas a ser considerado 	 ³±±
±±³          ³ lVlrZerado	= Define se ira imprimir os valores zerados.           	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtbPlGerCm(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,;
					cAlias,cIdent,lImpAntLP,dDataLP,lVlrZerado,lFiliais,aFiliais,;
					lMeses,aMeses,lImpSint)

Local aSaveArea := GetArea()
Local aSaldoAnt	
Local aSaldoAtu
Local nMeter	:= 0

Local cConta
Local cCodNor
Local cNormal
Local cContaSup
Local cDesc
Local cPlanGer := aSetOfBook[5]
Local cContaZZZ	:= Repl("Z",Len(Criavar("CT1_CONTA")))
Local cCustoZZZ := Repl("Z",Len(Criavar("CTT_CUSTO")))
Local cItemZZZ	:= Repl("Z",Len(Criavar("CTD_ITEM")))
Local cClVlZZZ	:= Repl("Z",Len(Criavar("CTH_CLVL")))
Local cContaIni	:= Space(Len(Criavar("CT1_CONTA")))
Local cContaFim	:= cContaZZZ
Local cCustoIni	:= Space(Len(Criavar("CTT_CUSTO")))
Local cCustoFim	:= cCustoZZZ
Local cItemIni	:= Space(Len(Criavar("CTD_ITEM")))
Local cItemFim	:= cItemZZZ
Local cClvlIni	:= Space(Len(Criavar("CTH_CLVL")))
Local cClVlFim	:= cClVlZZZ

Local lConta 	:= .F.
Local lCusto	:= .F.
Local lItem		:= .F.
Local lClasse	:= .F.

Local nReg
Local nFator	 := 1
Local nVezes	:= 0	
Local nSaldoAnt := 0
Local nSaldoDeb := 0
Local nSaldoCrd := 0
Local nSaldoAtu := 0		// Saldo ate a data final
Local nSaldoAntD:= 0
Local nSaldoAntC:= 0
Local nSaldoAtuD:= 0
Local nSaldoAtuC:= 0
Local nPos		:= 0 
Local nTotal	:= 0 

Local aColunas	:= {}
Local nSomaCols := 0

cAlias		:= Iif(cAlias == Nil,"",cAlias)
cIdent		:= Iif(cIdent == Nil,"",cIdent)
lVlrZerado	:= Iif(lVlrZerado == Nil,.T.,lVlrZerado)

DEFAULT lImpSint := .T.

If lMeses	//Se for Comparativo por Mes
	nTotVezes := Len(aMeses)
EndIf
		
If lFiliais
	nTotVezes	:= Len(aFiliais)
Endif

//Alimentar a matriz aColunas		
For nVezes	:= 1 to nTotVezes
	Aadd(aColunas, 0)               				
Next

dbSelectArea("CTS")
If ValType(oMeter) == "O"
	oMeter:SetTotal(CTS->(RecCount()))
	oMeter:Set(0)
EndIf
dbSetOrder(1)

MsSeek(xFilial()+cPlanGer,.T.)

While !Eof() .And. 	CTS->CTS_FILIAL == xFilial() .And.;
					CTS->CTS_CODPLA == cPlanGer
	If ValType(oMeter) == "O"					
		nMeter++
   		oMeter:Set(nMeter)				
	EndIf
	If CTS->CTS_CLASSE == "1" .And. (! CTS->CTS_IDENT $ "3456")
		dbSkip()
		Loop
	EndIf

	// Recarrega variáveis
	lConta 	:= .F.
	lCusto	:= .F.
	lItem	:= .F.
	lClasse	:= .F.

	// Grava conta analitica
	cConta 	:= CTS->CTS_CONTAG
	cDesc	:= CTS->CTS_DESCCG
	cOrdem	:= CTS->CTS_ORDEM

	nSaldoAnt 	:= 0	// Zero as variaveis para acumular
	nSaldoDeb 	:= 0
	nSaldoCrd 	:= 0

	nSaldoAtu 	:= 0
	nSaldoAntD	:= 0
	nSaldoAntC	:= 0
	nSaldoAtuD	:= 0
	nSaldoAtuC	:= 0

	dbSelectArea("CTS")
	dbSetOrder(1)

	nSomaCols := 0
	While !Eof() .And. CTS->CTS_FILIAL == xFilial() .And.;
						CTS->CTS_CODPLA == cPlanGer  .And. CTS->CTS_ORDEM	== cOrdem

		aSaldoAnt	:= { 0, 0, 0, 0, 0, 0, 0, 0 }
		aSaldoAtu	:= { 0, 0, 0, 0, 0, 0, 0, 0 }

		// Recarrega variáveis
		lConta 	:= .F.
		lCusto	:= .F.
		lItem	:= .F.
		lClasse	:= .F.
		If !Empty(CTS->CTS_CTHINI)	.Or. !Empty(CTS->CTS_CTHFIM)		// Saldo a partir da classe
			lClasse := .T.
			cClVlIni	:= CTS->CTS_CTHINI
			cClVlFim	:= CTS->CTS_CTHFIM
		Else
			cClVlIni	:= ""
			cClVlFim	:= cClVlZZZ
		EndIf
		If !Empty(CTS->CTS_CTDINI) .Or. !Empty(CTS->CTS_CTDFIM)	// Saldo a partir do Item
			lItem := .T.
			cItemIni	:= CTS->CTS_CTDINI
			cItemFim	:= CTS->CTS_CTDFIM			
		Else
			cItemIni	:= ""
			cItemFim	:= cItemZZZ
		EndIf
		If !Empty(CTS->CTS_CTTINI) .Or. !Empty(CTS->CTS_CTTFIM)	// Saldo a partir do C.Custo
			lCusto := .T.
			cCustoIni	:= CTS->CTS_CTTINI
			cCustoFim	:= CTS->CTS_CTTFIM
		Else
			cCustoIni	:= ""
			cCustoFim	:= cCustoZZZ
		EndIf
		If !Empty(CTS->CTS_CT1INI) .Or. !Empty(CTS->CTS_CT1FIM)	// Saldo a partir da Conta
			lConta := .T.
			cContaIni	:= CTS->CTS_CT1INI
			cContaFim	:= CTS->CTS_CT1FIM
		Else
			cContaIni	:= ""
			cContaFim	:= cContaZZZ
		EndIf		

		For nVezes := 1 to nTotVezes
			aSaldoAnt	:= { 0, 0, 0, 0, 0, 0, 0, 0 }
			aSaldoAtu	:= { 0, 0, 0, 0, 0, 0, 0, 0 }
		
			If lClasse          
				If lMeses
					aSaldoAnt := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,;
											cItemFim,cCustoIni,cCustoFim,cContaIni,;
											cContaFim,aMeses[nVezes][2],cMoeda,CTS->CTS_TPSALD)
									
					aSaldoAtu := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,;
											cItemFim,cCustoIni,cCustoFim,cContaIni,;
											cContaFim,aMeses[nVezes][3],cMoeda,CTS->CTS_TPSALD)
				EndIf
				If lFiliais
					aSaldoAnt := SaldTotCT4(cItemIni,cItemFim,cCustoIni,;
											cCustoFim,cContaIni,cContaFim,;
											aMeses[nVezes][2],cMoeda,CTS->CTS_TPSALD,aFiliais[nVezes])
									
					aSaldoAtu := SaldTotCT4(cItemIni,cItemFim,cCustoIni,;
											cCustoFim,cContaIni,cContaFim,;
											aMeses[nVezes][3],cMoeda,CTS->CTS_TPSALD,aFiliais[nVezes])				
				EndIf
			ElseIf lItem
				If lMeses		
					aSaldoAnt := SaldTotCT4(cItemIni,cItemFim,cCustoIni,;
											cCustoFim,cContaIni,cContaFim,;
											aMeses[nVezes][2],cMoeda,CTS->CTS_TPSALD)
									
					aSaldoAtu := SaldTotCT4(cItemIni,cItemFim,cCustoIni,;
											cCustoFim,cContaIni,cContaFim,;
											aMeses[nVezes][3],cMoeda,CTS->CTS_TPSALD)
				Endif
				
				If lFiliais
					aSaldoAnt := SaldTotCT4(cItemIni,cItemFim,cCustoIni,;
											cCustoFim,cContaIni,cContaFim,;
											aMeses[nVezes][2],cMoeda,CTS->CTS_TPSALD,aFiliais[nVezes])
									
					aSaldoAtu := SaldTotCT4(cItemIni,cItemFim,cCustoIni,;
											cCustoFim,cContaIni,cContaFim,;
											aMeses[nVezes][3],cMoeda,CTS->CTS_TPSALD,aFiliais[nVezes])
				
				EndIf
			ElseIf lCusto    
				If lMeses			
					aSaldoAnt := SaldTotCT3(cCustoIni,cCustoFim,cContaIni,;
											cContaFim,aMeses[nVezes][2],cMoeda,CTS->CTS_TPSALD)
					aSaldoAtu := SaldTotCT3(cCustoIni,cCustoFim,cContaIni,;
											cContaFim,aMeses[nVezes][3],cMoeda,CTS->CTS_TPSALD)
				EndIf
				
				If lFiliais
					aSaldoAnt := SaldTotCT3(cCustoIni,cCustoFim,cContaIni,;
											cContaFim,aMeses[nVezes][2],cMoeda,CTS->CTS_TPSALD,aFiliais[nVezes])
					aSaldoAtu := SaldTotCT3(cCustoIni,cCustoFim,cContaIni,;
											cContaFim,aMeses[nVezes][3],cMoeda,CTS->CTS_TPSALD,aFiliais[nVezes])
				
				EndIf
			ElseIf lConta
				If lMeses
					aSaldoAnt := SaldTotCT7(cContaIni,cContaFim,aMeses[nVezes][2],cMoeda,CTS->CTS_TPSALD,lImpAntLP,dDataLP)
					aSaldoAtu := SaldTotCT7(cContaIni,cContaFim,aMeses[nVezes][3],cMoeda,CTS->CTS_TPSALD,lImpAntLP,dDataLP)
				Endif
				
				If lFiliais
					aSaldoAnt := SaldTotCT7(cContaIni,cContaFim,dDataIni,cMoeda,CTS->CTS_TPSALD,lImpAntLP,dDataLP,aFiliais[nVezes])
					aSaldoAtu := SaldTotCT7(cContaIni,cContaFim,dDataFim,cMoeda,CTS->CTS_TPSALD,lImpAntLP,dDataLP,aFiliais[nVezes])				
				EndIf
			EndIf	

			If aSetOfBook[9] > 1	// Divisao por fator
				For nPos := 1 To Len(aSaldoAnt)
					aSaldoAnt[nPos] := Round(NoRound((aSaldoAnt[nPos]/aSetOfBook[9]),3),2)
				Next
				For nPos := 1 To Len(aSaldoAtu)
					aSaldoAtu[nPos] := Round(NoRound((aSaldoAtu[nPos]/aSetOfBook[9]),3),2)
				Next
			Endif
			If ! Empty(CTS->CTS_FORMUL) .And. Left(CTS->CTS_FORMUL, 7) = "ROTINA="
				nFator := &(Subs(CTS->CTS_FORMUL, 8))
				For nPos := 1 To Len(aSaldoAnt)
					aSaldoAnt[nPos] *= nFator
				Next
				For nPos := 1 To Len(aSaldoAtu)
					aSaldoAtu[nPos] *= nFator
				Next
			Endif
			
			// Calculos com os Fatores
			If (CTS->CTS_IDENT = "1" .Or. CTS->CTS_IDENT = "2")	// Soma / Subtrai
				If CTS->CTS_IDENT = "1"				// Somo os saldos
					nSaldoAnt 	+= aSaldoAnt[6]		// Saldo Anterior
					nSaldoAtu 	+= aSaldoAtu[1]		// Saldo Atual
				
					nSaldoAntD 	+= aSaldoAnt[7]
					nSaldoAntC 	+= aSaldoAnt[8]
		
					nSaldoAtuD 	+= aSaldoAtu[4]
					nSaldoAtuC 	+= aSaldoAtu[5] 
		
					nSaldoDeb  	:= (nSaldoAtuD - nSaldoAntD)
					nSaldoCrd  	:= (nSaldoAtuC - nSaldoAntC)
				
				ElseIf CTS->CTS_IDENT = "2"			// Subtraio os saldos
					nSaldoAnt 	-= aSaldoAnt[6]		// Saldo Anterior
					nSaldoAtu 	-= aSaldoAtu[1]		// Saldo Atual
				
					nSaldoAntD 	-= aSaldoAnt[7]
					nSaldoAntC 	-= aSaldoAnt[8]
		
					nSaldoAtuD 	-= aSaldoAtu[4]
					nSaldoAtuC 	-= aSaldoAtu[5] 
		
					nSaldoDeb  	:= (nSaldoAtuD - nSaldoAntD)
					nSaldoCrd  	:= (nSaldoAtuC - nSaldoAntC)
							
				EndIf
			EndIf  
			aColunas[nVezes] += (nSaldoCrd-nSaldoDeb)
			nSaldoAtuD	:= 0
			nSaldoAntD	:= 0
			nSaldoAtuC	:= 0
			nSaldoAntC	:= 0
			nSaldoAnt	:= 0
			nSaldoAtu	:= 0
			nSaldoCrd	:= 0
			nSaldoDeb	:= 0
        Next
		dbSelectArea("CTS")
		dbSetOrder(1)  
		nReg := Recno()
		dbSkip()
	Enddo
	
	dbSelectArea("CTS")
	dbSetOrder(2)
	dbGoTo(nReg)
	cCodNor := CTS->CTS_NORMAL

	If !lVlrZerado
		For nVezes	:= 1 to  nTotVezes
			nSomaCols += aColunas[nVezes]			/// SOMA OS PERIODOS PARA VER SE O TOTAL É ZERO
		Next
		If nSomaCols == 0			
			dbSelectArea("CTS")						/// RETIRADO DELETE POIS SO GRAVA NO TMP SE TIVER VALOR
			dbSetOrder(1)
			dbGoTo(nReg)
			dbSkip()
   			Loop
   		EndIf
    EndIf	

	dbSelectArea("cArqTmp")
	dbSetOrder(1)	
	If !MsSeek(cConta)
		dbAppend()                    
		Replace CONTA 		With cConta
		Replace DESCCTA    	With cDesc
		Replace CTASUP    	With CTS->CTS_CTASUP
		Replace TIPOCONTA 	With CTS->CTS_CLASSE
		Replace NORMAL    	With CTS->CTS_NORMAL
		Replace ORDEM		With CTS->CTS_ORDEM
		Replace IDENTIFI	With CTS->CTS_IDENT
	EndIf

	dbSelectArea("cArqTmp")
	For nVezes	:= 1 to  nTotVezes
		Replace &("COLUNA"+Alltrim(Str(nVezes,2))) With aColunas[nVezes]
	Next

	// Tratamentos utilizando formula
	If Left(CTS->CTS_FORMUL, 6) = "TEXTO="		// Adiciona texto a descricao
		Replace ("cArqTmp")->DESCCTA With 	AllTrim(("cArqTmp")->DESCCTA) + Space(1) +;
											&(Subs(CTS->CTS_FORMUL, 7))
	Endif

	If Left(CTS->CTS_FORMUL, 7) = "ROTINA="
		nFator := &(Subs(CTS->CTS_FORMUL, 8))
	Endif
	    
	dbSelectArea("CTS")               
	If ValType(oMeter) == "O"
		oMeter:SetTotal(CTS->(RecCount()))
		oMeter:Set(0)
	EndIf
	dbSetOrder(2)         
	
	If lImpSint
		// Grava contas sinteticas
		If !Empty(CTS->CTS_CTASUP)
			While !Eof() .And. 	CTS->CTS_FILIAL == xFilial() .And. ;
									CTS->CTS_CODPLAN == cPlanGer
				If ValType(oMeter) == "O"	
					nMeter++
			    	oMeter:Set(nMeter)				
   	    		EndIf
				cContaSup 	:= CTS->CTS_CTASUP
				
				dbSelectArea("CTS")
				dbSetOrder(2)
				If MsSeek(xFilial()+cPlanGer+cContaSup)
					cDesc 	:= CTS->CTS_DESCCG
					cNormal := CTS->CTS_NORMAL
				Else
					cNormal	:= cCodNor	
				EndIf
            
				dbSelectArea("cArqTmp")
				dbSetOrder(1)
				If !MsSeek(cContaSup)
					dbAppend() 
					Replace CONTA	With cContaSup
					Replace DESCCTA With cDesc		
					Replace CTASUP    	With CTS->CTS_CTASUP
					Replace TIPOCONTA	With CTS->CTS_CLASSE
					Replace NORMAL   	With CTS->CTS_NORMAL
					Replace ORDEM		With CTS->CTS_ORDEM
					Replace IDENTIFI	With CTS->CTS_IDENT
				EndIf                                             
			                                               
				For nVezes	:= 1 to nTotVezes
					&("COLUNA"+Alltrim(Str(nVezes,2))) += aColunas[nVezes]
				Next

				dbSelectArea("CTS")
				If !Eof() .And. Empty(CTS->CTS_CTASUP)
					dbSelectArea("cArqTmp")
					Replace NIVEL1 With .T.
					dbSelectArea("CTS")
					Exit
				EndIf
			EndDo
		EndIf
	EndIf

	aColunas	:= {}
	
	//Alimentar a matriz aColunas		
	For nVezes	:= 1 to nTotVezes
		Aadd(aColunas, 0)               				
	Next
	
	dbSelectArea("CTS")
	dbSetOrder(1)
	dbGoTo(nReg)
	dbSkip()

EndDo

RestArea(aSaveArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT3BlnQry ºAutor  ³Simone Mie Sato     º Data ³  26/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna alias TRBTMP com a composição dos saldos Conta x    º±±
±±º          ³Centro de Custo                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CT3BlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,	cMoeda,;
					cTpSald,aSetOfBook,lImpMov,lVlrZerado)

Local cQuery		:= ""
Local aAreaQry		:= GetArea()		/// array com a posição no arquivo original
Local aTamVlr		:= TAMSX3("CT3_DEBITO")

cQuery := " SELECT CTT_CUSTO CUSTO,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, CT1_DESC01 DESCCTA,  	"
cQuery += " 	CT1_CTASUP SUPERIOR, CTT_RES CCRES, CT1_GRUPO GRUPO, CTT_DESC01 DESCCC, CT1_CLASSE TIPOCONTA,CTT_CLASSE TIPOCC,  	"
If CtbExDtFim("CT1") 
	cQuery += "     CT1_DTEXSF CT1DTEXSF, " 
EndIf
If CtbExDtFim("CTT") 
	cQuery += "     CTT_DTEXSF CTTDTEXSF, "
EndIf
cQuery += " 	CTT_CCSUP CCSUP,  "
cQuery += " 	(SELECT SUM(CT3_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDOANTDB, "
cQuery += " 		(SELECT SUM(CT3_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDOANTCR, "
cQuery += " 		(SELECT SUM(CT3_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA      = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD     = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA  = CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDODEB, "
cQuery += " 		(SELECT SUM(CT3_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDOCRD "
cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ, "+RetSqlName("CTT")+" ARQ2 "
cQuery += " 	WHERE ARQ.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += " 	AND ARQ.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 	AND ARQ.CT1_CLASSE = '2' "    

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif

cQuery += " 	AND  ARQ2.CTT_FILIAL = '"+xFilial("CTT")+"' "
cQuery += " 	AND ARQ2.CTT_CUSTO BETWEEN '"+cCCIni+"' AND '"+cCCFim+"' "
cQuery += " 	AND ARQ2.CTT_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ2.CTT_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CENTRO DE CUSTO DO MESMO SETOFBOOKS
Endif

cQuery += " 	AND ARQ.D_E_L_E_T_ = '' "
cQuery += " 	AND ARQ2.D_E_L_E_T_ = '' "
    
If !lVlrZerado
	cQuery += " 	AND ((SELECT SUM(CT3_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') <> 0 "
	cQuery += " 	OR "
	cQuery += " 		(SELECT SUM(CT3_CREDIT) "
	cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
	cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') <> 0 "
	cQuery += " 	OR "	
	cQuery += " 		(SELECT SUM(CT3_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND CT3.D_E_L_E_T_ = '')<> 0 "
	cQuery += " 	OR "		
	cQuery += " 		(SELECT SUM(CT3_CREDIT) "
	cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND CT3.D_E_L_E_T_ = '')<>0) "		
Endif
	
cQuery := ChangeQuery(cQuery)		   

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)

TcSetField("TRBTMP","SALDOANTDB","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDOANTCR","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDODEB","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDOCRD","N",aTamVlr[1],aTamVlr[2])	

If CtbExDtFim("CT1") 
	TCSetField("TRBTMP","CT1DTEXSF","D",8,0)	
EndIf

If CtbExDtFim("CTT") 
	TCSetField("TRBTMP","CTTDTEXSF","D",8,0)	
EndIf

RestArea(aAreaQry)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT4BlnQry ºAutor  ³Simone Mie Sato     º Data ³  26/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna alias TRBTMP com a composição dos saldos Conta x    º±±
±±º          ³Item Cotnabil                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CT4BlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cItemIni,cItemFim,cMoeda,;
					cTpSald,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP)						

Local cQuery		:= ""
Local aAreaQry		:= GetArea()		/// array com a posição no arquivo original
Local aTamVlr		:= TAMSX3("CT4_DEBITO")

cQuery := " SELECT CTD_ITEM ITEM,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, CT1_GRUPO GRUPO,  "
cQuery += " 	CT1_CTASUP SUPERIOR, CTD_RES ITRES, CTD_ITSUP ITSUP, CT1_CLASSE TIPOCONTA, CTD_CLASSE TIPOITEM,  	"
If CtbExDtFim("CT1") 
	cQuery += " CT1_DTEXSF CT1DTEXSF, "
EndIf
If CtbExDtFim("CTD") 
	cQuery += " CTD_DTEXSF CTDDTEXSF, "
EndIf
If cMoeda == '01'
	cQuery += "		CT1_DESC01 DESCCTA, CTD_DESC01 DESCITEM, "                                                   	
Else
	cQuery += "		CT1_DESC"+cMoeda+" DESCCTA, CTD_DESC"+cMoeda+" DESCITEM, CT1_DESC01 DESCCTA01, CTD_DESC01 DESCIT01, "                                                   	
EndIf
cQuery += " 	(SELECT SUM(CT4_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ2.CTD_ITEM	= CT4_ITEM  "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') SALDOANTDB, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT4_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
	cQuery += " 			AND ARQ2.CTD_ITEM	= CT4_ITEM  "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
	cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT4_LP = 'Z' AND ((CT4_DTLP <> ' ' AND CT4_DTLP >= '"+DTOS(dDataLP)+"') OR (CT4_DTLP = '' AND CT4_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT4.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTDB, "  
EndIf

cQuery += " 		(SELECT SUM(CT4_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL	= '"+xFilial("CT4")+"' "
cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ2.CTD_ITEM	= CT4_ITEM "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') SALDOANTCR, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT4_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
	cQuery += " 			AND ARQ2.CTD_ITEM	= CT4_ITEM  "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
	cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT4_LP = 'Z' AND ((CT4_DTLP <> ' ' AND CT4_DTLP >= '"+DTOS(dDataLP)+"') OR (CT4_DTLP = '' AND CT4_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT4.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTCR, "  
EndIf

cQuery += " 		(SELECT SUM(CT4_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ2.CTD_ITEM	= CT4_ITEM "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') SALDODEB, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT4_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
	cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ2.CTD_ITEM	= CT4_ITEM "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "	
	cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CT4_LP = 'Z' AND ((CT4_DTLP <> ' ' AND CT4_DTLP >= '"+DTOS(dDataLP)+"') OR (CT4_DTLP = '' AND CT4_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CT4.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPDEB, "
EndIf

cQuery += " 		(SELECT SUM(CT4_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL	= '"+xFilial("CT4")+"' "
cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ2.CTD_ITEM	= CT4_ITEM "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') SALDOCRD "

If lImpAntLP
	cQuery += ", 		(SELECT SUM(CT4_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
	cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ2.CTD_ITEM	= CT4_ITEM "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "	
	cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CT4_LP = 'Z' AND ((CT4_DTLP <> ' ' AND CT4_DTLP >= '"+DTOS(dDataLP)+"') OR (CT4_DTLP = '' AND CT4_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CT4.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPCRD "
EndIf

cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ, "+RetSqlName("CTD")+" ARQ2 "
cQuery += " 	WHERE ARQ.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += " 	AND ARQ.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 	AND ARQ.CT1_CLASSE = '2' "    

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif

cQuery += " 	AND  ARQ2.CTD_FILIAL = '"+xFilial("CTD")+"' "
cQuery += " 	AND ARQ2.CTD_ITEM BETWEEN '"+cItemIni+"' AND '"+cItemFim+"' "
cQuery += " 	AND ARQ2.CTD_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ2.CTD_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE ITEM DO MESMO SETOFBOOKS
Endif

cQuery += " 	AND ARQ.D_E_L_E_T_ = '' "
cQuery += " 	AND ARQ2.D_E_L_E_T_ = '' "
    
If !lVlrZerado
	cQuery += " 	AND ((SELECT SUM(CT4_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
	cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += " 			AND ARQ2.CTD_ITEM	= CT4_ITEM "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
	cQuery += " 			AND CT4.D_E_L_E_T_ = '') <> 0 "
	cQuery += " 	OR "
	cQuery += " 		(SELECT SUM(CT4_CREDIT) "
	cQuery += " 			FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL	= '"+xFilial("CT4")+"' "
	cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += " 			AND ARQ2.CTD_ITEM	= CT4_ITEM "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
	cQuery += " 			AND CT4.D_E_L_E_T_ = '') <> 0 "
	cQuery += " 	OR "	
	cQuery += " 		(SELECT SUM(CT4_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
	cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ2.CTD_ITEM	= CT4_ITEM "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
	cQuery += " 			AND CT4.D_E_L_E_T_ = '')<> 0 "
	cQuery += " 	OR "		
	cQuery += " 		(SELECT SUM(CT4_CREDIT) "
	cQuery += " 			FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL	= '"+xFilial("CT4")+"' "
	cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ2.CTD_ITEM	= CT4_ITEM "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
	cQuery += " 			AND CT4.D_E_L_E_T_ = '') <> 0 )"		
Endif
	
cQuery := ChangeQuery(cQuery)		   

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)

TcSetField("TRBTMP","SALDOANTDB","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDOANTCR","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDODEB","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDOCRD","N",aTamVlr[1],aTamVlr[2])	
If CtbExDtFim("CT1") 
	TcSetField("TRBTMP","CT1DTEXSF","D",8,0)	
EndIf

If CtbExDtFim("CTD") 
	TcSetField("TRBTMP","CTDDTEXSF","D",8,0)	
EndIf

RestArea(aAreaQry)

Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CtCtEntSup ³Autor  ³ Simone Mie Sato       ³ Data ³ 06.11.02 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualizacao de sinteticas de entidade/conta                 			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtCtEntSup(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias	= Alias a ser utilizado             	               		 ³±±
±±³          ³ lNImpMov = Se imprime entidades sem movimento		               	 ³±±
±±³          ³ cMoeda	= Moeda                              	              		 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtCtEntSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda)
		
Local aSaveArea	:= GetArea()				
Local cCadAlias	:= ""
Local cCodSup	:= ""     
Local cCodEnt	:= ""
Local cConta	:= ""
Local cDescCta	:= ""
Local cEntSup	:= ""
Local cDescEnt	:= ""
Local cSeek		:= ""
Local nSaldoAnt	:= 0
Local nSaldoAtu	:= 0
Local nSaldoDeb	:= 0
Local nSaldoCrd	:= 0
Local nMovimento:= 0
Local nSaldoAntD:= 0
Local nSaldoAntC:= 0
Local nSaldoAtuD:= 0
Local nsaldoAtuC:= 0
Local nRegTmp	:= 0
Local nMeter	:= 0

Do Case
Case cAlias == "CT3" 
	cCadAlias 	:= 'CTT'
	cCodSup		:= "CCSUP" 	
	cCodEnt		:= "CUSTO"
Case cAlias == "CT4"
	cCadAlias 	:= 'CTD'
	cCodSup		:=	"ITSUP"
	cCodEnt		:= "ITEM"
Case cAlias == "CTI"
	cCadAlias 	:= 'CTH'
	cCodSup		:=	"CLSUP"
	cCodEnt		:= "CLVL"
EndCase
				         
// Grava sinteticas
dbSelectArea("cArqTmp")	
dbGoTop()  
If ValType(oMeter) == "O"
	oMeter:SetTotal(cArqTmp->(RecCount()))
	oMeter:Set(0)
EndIf
While!Eof()                                 
                                            
	nSaldoAnt	:= SALDOANT
	nSaldoAtu	:= SALDOATU
	nSaldoDeb	:= SALDODEB
	nSaldoCrd	:= SALDOCRD   
	nMovimento	:= MOVIMENTO
	nSaldoAntD	:= SALDOANTDB
	nSaldoAntC	:= SALDOANTCR	
	nSaldoAtuD	:= SALDOATUDB
	nsaldoAtuC	:= SALDOATUCR

	nRegTmp := Recno()  
	
	dbSelectArea(cCadAlias)
	dbSetOrder(1)        
	MsSeek(xFilial(cCadAlias)+&("cArqTmp->"+cCodEnt))
	
	If Empty(&(cCadAlias+"->"+cCadAlias+"_"+cCodSup))
		dbSelectArea("cArqTmp")
		Replace NIVEL1 With .T.
		dbSelectArea(cCadAlias)
	EndIf		
	MsSeek(xFilial(cCadAlias)+ &("cArqTmp->"+cCodSup))
		
	While !Eof() .And. &(cCadAlias+"->"+cCadAlias+"_FILIAL") == xFilial(cCadAlias)

		cConta 	 := cArqTmp->CONTA		
		cDescCta := cArqTmp->DESCCTA
		
		cEntSup 	:= &(cCadAlias+"->"+cCadAlias+"_"+cCodEnt)
		cDescEnt	:= &(cCadAlias+"->"+cCadAlias+"_DESC"+cMoeda)

		If Empty(cDescEnt)	// Caso nao preencher descricao da moeda selecionada
			cDescEnt	:=&(cCadAlias+"->"+cCadAlias+"_DESC01")
		Endif		

		cSeek 		:= cConta+cEntSup
		
		dbSelectArea("CT1")
		dbSetOrder(1)
		MsSeek(xFilial("CT1")+cConta,.F.)
		
		dbSelectArea("cArqTmp")
		dbSetOrder(1)      
		If !MsSeek(cSeek)
			dbAppend()
			Do Case
			Case cAlias == 'CT3'      
				Replace CUSTO   	With cEntSup
				Replace DESCCC		With cDescEnt
				Replace TIPOCC 		With CTT->CTT_CLASSE			
				Replace CCSUP 		With CTT->CTT_CCSUP	
				Replace CCRES		With CTT->CTT_RES	
			Case cAlias == 'CT4'
				Replace ITEM		With cEntSup
				Replace DESCITEM	With cDescEnt
				Replace TIPOITEM 	With CTD->CTD_CLASSE
				Replace ITSUP  		With CTD->CTD_ITSUP		
				Replace ITEMRES		With CTD->CTD_RES									
			Case cAlias == 'CTI'                   
				Replace CLVL    	With cEntSup
				Replace DESCCLVL	With cDesc
				Replace TIPOCLVL 	With CTH->CTH_CLASSE
				Replace CLSUP    	With CTH->CTH_CLSUP
				Replace CLVLRES		With CTH->CTH_RES			
			EndCase			
			Replace CONTA		With cConta
			Replace DESCCTA 	With cDescCta
			Replace TIPOCONTA	With CT1->CT1_CLASSE
			Replace SUPERIOR	With CT1->CT1_CTASUP	
			Replace CTARES 		With CT1->CT1_RES						
		EndIf    
		
		Replace	 SALDOANT 	With SALDOANT + nSaldoAnt
		Replace  SALDOANTDB With SALDOANTDB + nSaldoAntD
		Replace  SALDOANTCR	With SALDOANTCR + nSaldoAntC		
		Replace  SALDOATU 	With SALDOATU + nSaldoAtu
		Replace  SALDOATUDB	With SALDOATUDB	+ nSaldoAtuD
		Replace  SALDOATUCR	With SALDOATUCR + nsaldoAtuC		
		Replace  SALDODEB 	With SALDODEB + nSaldoDeb
		Replace  SALDOCRD 	With SALDOCRD + nSaldoCrd
		If !lNImpMov
			Replace MOVIMENTO With MOVIMENTO + nMovimento
		Endif
   		
		dbSelectArea(cCadAlias)
		If Empty(&(cCadAlias+"->"+cCadAlias+"_"+cCodSup))
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea(cCadAlias)
			Exit                     						
		EndIf		

		dbSelectArea(cCadAlias)
		MsSeek(xFilial(cCadAlias)+ &("cArqTmp->"+cCodSup))
	EndDo
	dbSelectArea("cArqTmp")
	dbGoto(nRegTmp)
	dbSkip()
	If ValType(oMeter) == "O"
		nMeter++
   		oMeter:Set(nMeter)					
  	EndIf
EndDo

RestArea(aSaveArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtEntConta³ Autor ³ Simone Mie Sato       ³ Data ³ 24.06.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Balancetes Conta / Entidade   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oMeter	  = Controle da regua                             ³±±
±±³          ³ oText 	  = Controle da regua                             ³±±
±±³          ³ oDlg  	  = Janela                                        ³±±
±±³          ³ lEnd  	  = Controle da regua -> finalizar                ³±±
±±³          ³ dDataIni   = Data Inicial de processamento                 ³±±
±±³          ³ dDataFinal = Data Final de processamento                   ³±±
±±³          ³ cEntidIni  = Codigo Entidade Inicial                       ³±±
±±³          ³ cEndtidFim = Codigo Entidade Final                         ³±±
±±³          ³ cMoeda     = Moeda		                                  ³±±
±±³          ³ cSaldos    = Tipos de Saldo a serem processados            ³±±
±±³          ³ aSetOfBook = Matriz de configuracao de livros              ³±±
±±³          ³ lNImpMov   = Indica se imprime ou nao a coluna movimento   ³±±
±±³          ³ cAlias     = Alias para regua       	                      ³±±
±±³          ³ lCusto     = Considera Centro de Custo?                    ³±±
±±³          ³ lItem      = Considera Item Contabil?                      ³±±
±±³          ³ lCLVL      = Considera Classe de Valor?                    ³±±
±±³          ³ lAtSldBase = Indica se deve chamar rot atual. saldo basico ³±±
±±³          ³ nInicio    = Moeda Inicial (p/ atualizar saldo)            ³±±
±±³          ³ nFinal     = Moeda Final (p/ atualizar saldo)              ³±±
±±³          ³ lImpAntLP  = Imprime lancamentos Lucros e Perdas?          ³±±
±±³          ³ dDataLP    = Data ultimo Lucros e Perdas                   ³±±
±±³          ³ nDivide    = Divide valores (100,1000,1000000)             ³±±
±±³          ³ lVlrZerado = Grava ou nao valores zerados no arq temporario³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtEntConta(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
						cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,;
						cAlias,lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,lImpAntLP,dDataLP,;
						nDivide,lVlrZerado,lNImpMov)	           

Local aSaveArea := GetArea()

Local cConta	:= "" 
Local cCtaRes	:= ""  
Local cCodSup	:= ""
Local cTipoCta	:= ""
Local cDescCta	:= ""
Local cEntid	:= ""
Local cDescEnt	:= ""
Local cEntSup	:= ""
Local cCodRes	:= ""
Local cTipoEnt	:= ""
Local cCodEnt	:= ""   
Local cCCIni	:= ""
Local cCCFim	:= ""
Local cItemIni	:= ""
Local cItemFim	:= ""
Local cCadAlias	:= ""   

Local nSaldoDeb := 0
Local nSaldoCrd := 0
Local nSaldoAntD:= 0
Local nSaldoAntC:= 0
Local nSaldoAtuD:= 0
Local nSaldoAtuC:= 0
Local nSldAnt	:= 0
Local nSldAtu	:= 0
Local nMovimento:= 0 
Local nTamCC	:= Len(CriaVar("CTT_CUSTO"))
Local nTamItem	:= Len(CriaVar("CTD_ITEM")) 
Local nTotal	:= 0
Local nMeter	:= 0
Local nCont		:= 0 

lVlrZerado	:= Iif(lVlrZerado == Nil,.T.,lVlrZerado)
nDivide 	:= Iif(nDivide == Nil,1,nDivide)


//Chama rotina para refazer os saldos basicos.Foi criado outra rotina porque 
//nao tenho data inicial nem data final para passar como parametro.
If !lAtSldBase
	Ct360RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cSaldos,,lAtSldBase)
EndIf	

If cAlias == 'CT3'
	cCadAlias	:= "CTT"                             
	cCodEnt		:= "CUSTO"                                                        
	cCodSup		:= "CCSUP"	
Elseif cAlias == 'CT4'                                                                
	cCadAlias	:= "CTD"                             
	cCodEnt		:= "ITEM" 
	cCodSup		:= "ITSUP"	
	cCCIni		:= ""
	cCCFim		:= Replicate("Z",nTamCC)   
ElseIf cAlias == 'CTI'
	cCadAlias	:= "CTH"                             
	cCodEnt		:= "CLVL"   
	cCodSup		:= "CVSUP"	               
	cCCIni		:= ""
	cCCFim		:= Replicate("Z",nTamCC)   
	cItemIni	:= ""
	cItemFim	:= Replicate("Z",nTamItem) 	
Endif

dbSelectArea("CT1")
dbSetOrder(3)

// Posiciona no primeiro item analitico 
MsSeek(xFilial()+"2"+cContaIni,.T.)
If ValType(oMeter) == "O"
	oMeter:SetTotal((cAlias)->(RecCount()))
	oMeter:Set(0)
EndIf
While !Eof() .And. CT1->CT1_FILIAL == xFilial("CT1").And. CT1->CT1_CONTA >= cContaIni .And. CT1->CT1_CONTA <= cContaFim .And. ;
		CT1->CT1_CLASSE <> '1'
		                                                            
	// Grava entidade analitica
	cConta		:= CT1->CT1_CONTA		
	cCtaRes  	:= CT1->CT1_RES
	cTipoCta	:= CT1->CT1_CLASSE
	cDescCta	:= &("CT1->CT1_DESC"+cMoeda)
	If Empty(cDescCta)		// Caso nao preencher descricao da moeda selecionada
		cDescCta := CT1->CT1_DESC01
	Endif
        
	// Caso tenha escolhido algum Set Of Book, verificar se a conta pertence a esse set of book.
	If !Empty(aSetOfBook[1])
		If !(aSetOfBook[1] $ CT1->CT1_BOOK)
			dbSkip()
			Loop
		EndIf
	EndIf		           

	dbSelectArea(cCadAlias)
	dbSetOrder(1)
	MsSeek(xFilial() + cEntidIni,.T.)

	While !Eof() .And. &(cCadAlias+"->"+cCadAlias+"_"+cCodEnt) <= cEntidFim

		If &(cCadAlias+"->"+cCadAlias+"_CLASSE") = "1"		// Entidades sinteticas nao armazenam saldos
			DbSkip()
			Loop
		Endif
		
		// Caso tenha escolhido algum Set Of Book, verifico se a conta pertence a esse set.				
		If !Empty(aSetOfBook[1])
			If !(aSetOfBook[1] $ &(cCadAlias+"->"+cCadAlias+"_BOOK"))
				dbSkip()
				Loop
			EndIf
		EndIf		           	
	
		cDescEnt := &(cCadAlias+"->"+cCadAlias+"_DESC"+cMoeda)	                      
		If Empty(cDescEnt)		// Caso nao preencher descricao da moeda selecionada
			cDescEnt := &(cCadAlias+"->"+cCadAlias+"_DESC01")
		Endif                                            

		cEntid 	 	:= &(cCadAlias+"->"+cCadAlias+"_"+cCodEnt)		
		cEntSup		:= &(cCadAlias+"->"+cCadAlias+"_"+cCodSup)		
		cTipoEnt	:= &(cCadAlias+"->"+cCadAlias+"_CLASSE")
		cCodRes		:= &(cCadAlias+"->"+cCadAlias+"_RES")

		//Calculo dos saldos
		If cAlias == 'CT3'
			aSaldoAnt := SaldoCT3(	CT1->CT1_CONTA,cEntid,dDataIni,cMoeda,cSaldos,,;
									lImpAntLP,dDataLP)
			aSaldoAtu := SaldoCT3(	CT1->CT1_CONTA,cEntid,dDataFim,cMoeda,cSaldos,,;
									lImpAntLP,dDataLP)
		ElseIf cAlias == 'CT4'	   
			aSaldoAnt	 := SaldTotCT4(cEntid,cEntid,cCCIni,cCCFim,;
							CT1->CT1_CONTA,CT1->CT1_CONTA,dDataIni,cMoeda,cSaldos)
			aSaldoAtu	 := SaldtotCT4(cEntid,cEntid,cCCIni,cCCFim,;
							CT1->CT1_CONTA,CT1->CT1_CONTA,dDataFim,cMoeda,cSaldos)
		ElseIf cAlias == 'CTI'		
			aSaldoAnt := SaldTotCTI(cEntid,cEntid,cItemIni,cItemFim,cCCIni,cCCFim,;
							CT1->CT1_CONTA,CT1->CT1_CONTA,dDataIni,cMoeda,cSaldos)
			aSaldoAtu := SaldTotCTI(cEntid,cEntid,cItemIni,cItemFim,cCCIni,cCCFim,;
							CT1->CT1_CONTA,CT1->CT1_CONTA,dDataFim,cMoeda,cSaldos)
		Endif
		
		nSaldoAntD 	:= aSaldoAnt[7]
		nSaldoAntC 	:= aSaldoAnt[8]
		nSldAnt		:= nSaldoAntC - nSaldoAntD
	
		nSaldoAtuD 	:= aSaldoAtu[4]
		nSaldoAtuC 	:= aSaldoAtu[5]          
		nSldAtu		:= nSaldoAtuC - nSaldoAtuD
	
		nSaldoDeb  	:= nSaldoAtuD - nSaldoAntD
		nSaldoCrd  	:= nSaldoAtuC - nSaldoAntC     
		  If nDivide > 1
			nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)		
			nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
		EndIf
			
		nMovimento	:= nSaldoCrd-nSaldoDeb

		If !lVlrZerado .And. (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0) .And. ;
			(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
			dbSkip()
			Loop
		EndIf	
		
		If lVlrZerado .And. (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0 ) .And. ;
			(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
			If CtbExDtFim("CT1") 			
				//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
				//relatorio for maior, nao ira imprimir a entidade. 
  				If !CtbVlDtFim("CT1",dDataIni) 				                                 					
					dbSelectArea("CT1")
					dbSkip()
					Loop																
				EndIf                                                       
			EndIf
			
			If CtbExDtFim(cCadAlias) 			
				//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
				//relatorio for maior, nao ira imprimir a entidade. 
  				If !CtbVlDtFim(cCadAlias,dDataIni) 				                                 					
					dbSelectArea(cCadAlias)
					dbSkip()
					Loop																
				EndIf                                                       
			EndIf			
		EndIf   		
		
		dbSelectArea("cArqTmp")
		dbSetOrder(1)			
		If !MsSeek(CT1->CT1_CONTA+cEntid)
			dbAppend()
			Replace CONTA 		With CT1->CT1_CONTA
			Replace DESCCTA		With cDescCta
 			Replace NORMAL    	With CT1->CT1_NORMAL
 			Replace TIPOCONTA 	With CT1->CT1_CLASSE
			Replace GRUPO		With CT1->CT1_GRUPO
			Replace CTARES      With CT1->CT1_RES
			Replace SUPERIOR    With CT1->CT1_CTASUP
			If cAlias == 'CT3'
				Replace CUSTO	With cEntid			
				Replace CCRES	With cCodRes
				Replace TIPOCC  With cTipoEnt
				Replace DESCCC	With cDescEnt
				Replace CCSUP	With cEntSup
			ElseIf cAlias == 'CT4'
				Replace ITEM 	 With cEntid
				Replace ITEMRES  With cCodRes 
				Replace TIPOITEM With cTipoEnt
				Replace DESCITEM With cDescEnt
				Replace ITSUP	 With cEntSup
			ElseIf cAlias == 'CTI'
				Replace CLVL 	 With cEntid			
				Replace CLVLRES  With cCodRes
				Replace TIPOCLVL With cTipoEnt
				Replace DESCCLVL With cDescEnt
				Replace CVSUP	 With cEntSup
			Endif   
		Endif               
		
		If nDivide > 1
			For nCont := 1 To Len(aSaldoAnt)
				aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
			Next nCont
			For nCont := 1 To Len(aSaldoAtu)
				aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
			Next nCont	
		EndIf	
				
		dbSelectArea("cArqTmp")
		dbSetOrder(1)
		Replace SALDOANT With aSaldoAnt[6]
		Replace SALDOATU With aSaldoAtu[1]			// Saldo Atual
		
		Replace  SALDODEB With nSaldoDeb				// Saldo Debito
		Replace  SALDOCRD With nSaldoCrd				// Saldo Credito
		If !lNImpMov
			Replace MOVIMENTO With nSaldoCrd-nSaldoDeb
		Endif
		dbSelectArea(cCadAlias)
		dbSkip()
		If ValType(oMeter) == "O"		
			nMeter++
    		oMeter:Set(nMeter)						
   		EndIf
	Enddo
	dbSelectArea("CT1")
    dbSkip()
	If ValType(oMeter) == "O"    
		nMeter++
   		oMeter:Set(nMeter)						    
  	EndIf
EndDo	

RestArea(aSaveArea)

Return				

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT7BlnQry ºAutor  ³Simone Mie Sato     º Data ³  26/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna alias TRBTMP com a composição dos saldos Conta x    º±±
±±º          ³Item Cotnabil                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CT7BlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cMoeda,cTpSald,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu)

Local cQuery		:= ""
Local aAreaQry		:= GetArea()		/// array com a posição no arquivo original
Local aTamVlr		:= TAMSX3("CT4_DEBITO")
Local cCampUSU		:= ""
Local aStrSTRU		:= {}
Local nStruLen		:= 0
Local nStr			:= 1


cQuery := " SELECT CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, "
cQuery += " 	CT1_CTASUP SUPERIOR, CT1_CLASSE TIPOCONTA, CT1_GRUPO GRUPO, "
If CtbExDtFim("CT1") 
	cQuery += "     CT1_DTEXSF CT1DTEXSF, "
EndIf
////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cFILUSU)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := CT1->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////

If cMoeda == '01'
	cQuery += "		CT1_DESC01 DESCCTA, "                                                   	
Else
	cQuery += "		CT1_DESC"+cMoeda+" DESCCTA, CT1_DESC01 DESCCTA01,  "                                                   	
EndIf
cQuery += " 		(SELECT SUM(CT7_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
cQuery += " 			WHERE CT7_FILIAL = '"+xFilial("CT7")+"'  "
cQuery += " 			AND CT1_CONTA	= CT7_CONTA "
cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CT7_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
cQuery += "  SALDOANTDB, "  
If lImpAntLP
	cQuery += " 		(SELECT SUM(CT7_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
	cQuery += " 			WHERE CT7_FILIAL = '"+xFilial("CT7")+"'  "
	cQuery += " 			AND CT1_CONTA	= CT7_CONTA "
	cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT7_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT7_LP = 'Z' AND ((CT7_DTLP <> ' ' AND CT7_DTLP >= '"+DTOS(dDataLP)+"') OR (CT7_DTLP = '' AND CT7_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTDB, "  
EndIf
cQuery += " 	  	(SELECT SUM(CT7_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT7")+" CT7 "
cQuery += " 			WHERE CT7_FILIAL	= '"+xFilial("CT7")+"' "
cQuery += " 			AND CT1_CONTA	= CT7_CONTA "
cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CT7_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
cQuery += "  SALDOANTCR, "          
If lImpAntLP
	cQuery += " 	(SELECT SUM(CT7_CREDIT) "
	cQuery += " 			FROM "+RetSqlName("CT7")+" CT7 "
	cQuery += " 			WHERE CT7_FILIAL	= '"+xFilial("CT7")+"' "
	cQuery += " 			AND CT1_CONTA	= CT7_CONTA "
	cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT7_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT7_LP = 'Z' AND ((CT7_DTLP <> ' ' AND CT7_DTLP >= '"+DTOS(dDataLP)+"') OR (CT7_DTLP = '' AND CT7_DATA >= '"+DTOS(dDataLP)+"'))"	
	cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTCR, "          
EndIf
cQuery += " 		(SELECT SUM(CT7_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
cQuery += " 			WHERE CT7_FILIAL = '"+xFilial("CT7")+"'  "
cQuery += " 			AND CT1_CONTA	= CT7_CONTA "
cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CT7_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
cQuery += "  SALDODEB, " 
If lImpAntLP
	cQuery += " 		(SELECT SUM(CT7_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
	cQuery += " 			WHERE CT7_FILIAL = '"+xFilial("CT7")+"'  "
	cQuery += " 			AND CT1_CONTA	= CT7_CONTA "
	cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT7_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CT7_LP = 'Z' AND ((CT7_DTLP <> ' ' AND CT7_DTLP >= '"+DTOS(dDataLP)+"') OR (CT7_DTLP = '' AND CT7_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPDEB, " 
EndIf
cQuery += " 		(SELECT SUM(CT7_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT7")+" CT7 "
cQuery += " 			WHERE CT7_FILIAL	= '"+xFilial("CT7")+"' "
cQuery += " 			AND CT1_CONTA	= CT7_CONTA "
cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CT7_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
cQuery += "  SALDOCRD "
If lImpAntLP
	cQuery += ", 		(SELECT SUM(CT7_CREDIT) "
	cQuery += " 			FROM "+RetSqlName("CT7")+" CT7 "
	cQuery += " 			WHERE CT7_FILIAL	= '"+xFilial("CT7")+"' "
	cQuery += " 			AND CT1_CONTA	= CT7_CONTA "
	cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT7_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CT7_LP = 'Z' AND ((CT7_DTLP <> ' ' AND CT7_DTLP >= '"+DTOS(dDataLP)+"') OR (CT7_DTLP = '' AND CT7_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPCRD "
EndIf
cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ "
cQuery += " 	WHERE CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += " 	AND CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 	AND CT1_CLASSE = '2' "    

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif
cQuery += " 	AND D_E_L_E_T_ = ' ' "

    
If !lVlrZerado .And. !lImpAntLP	//Se considerar posicao anterior LP sera verificado na gravacao do arquivo de trabalho
	cQuery += " 	AND	((SELECT ROUND(SUM(CT7_DEBITO),2)- ROUND(SUM(CT7_CREDIT),2) "		
	cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
	cQuery += " 			WHERE CT7_FILIAL = '"+xFilial("CT7")+"'  "
	cQuery += " 			AND CT1_CONTA	= CT7_CONTA "
	cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT7_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += " 			AND CT7.D_E_L_E_T_ = '') <> 0 "
	cQuery += " 	OR "	
	cQuery += " 			(SELECT SUM(CT7_DEBITO)  "
	cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
	cQuery += " 			WHERE CT7_FILIAL = '"+xFilial("CT7")+"'  "
	cQuery += " 			AND CT1_CONTA	= CT7_CONTA "
	cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT7_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND CT7.D_E_L_E_T_ = '')<> 0 "
	cQuery += " 	OR "	
	cQuery += " 			(SELECT SUM(CT7_CREDIT)  "
	cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
	cQuery += " 			WHERE CT7_FILIAL = '"+xFilial("CT7")+"'  "
	cQuery += " 			AND CT1_CONTA	= CT7_CONTA "
	cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT7_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND CT7.D_E_L_E_T_ = '')<> 0) "	
Endif
	
cQuery := ChangeQuery(cQuery)		   

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)

TcSetField("TRBTMP","SALDOANTDB","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDOANTCR","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDODEB","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDOCRD","N",aTamVlr[1],aTamVlr[2])	
If CtbExDtFim("CT1") 
	TCSetField("TRBTMP","CT1DTEXSF","D",8,0)	
EndIf 

If lImpAntLP
	TcSetField("TRBTMP","SLDLPANTDB","N",aTamVlr[1],aTamVlr[2])	
	TcSetField("TRBTMP","SLDLPANTCR","N",aTamVlr[1],aTamVlr[2])	
	TcSetField("TRBTMP","MOVLPDEB","N",aTamVlr[1],aTamVlr[2])	
	TcSetField("TRBTMP","MOVLPCRD","N",aTamVlr[1],aTamVlr[2])	    
EndIf

RestArea(aAreaQry)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CtContaSup ³Autor  ³ Simone Mie Sato       ³ Data ³ 22.08.03 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualizacao de sinteticas de conta =>relatorios             			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtContaSup()															 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lNImpMov = Se imprime entidades sem movimento		               	 ³±±
±±³          ³ cMoeda	= Moeda                              	              		 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtContaSup(oMeter,oText,oDlg,lNImpMov,cMoeda)							
		
Local aSaveArea	:= GetArea()				
Local cContaSup	:= ""
Local cDesc		:= ""
Local nSaldoAnt	:= 0
Local nSaldoAtu	:= 0
Local nSaldoDeb	:= 0
Local nSaldoCrd	:= 0
Local nMovimento:= 0
Local nSaldoAntD:= 0
Local nSaldoAntC:= 0
Local nSaldoAtuD:= 0
Local nsaldoAtuC:= 0
Local nReg   	:= 0
Local nRegTmp	:= 0
Local nMeter	:= 0
Local lSemestre 	:= FieldPos("SALDOSEM") > 0		// Saldo por semestre
Local lPeriodo0		:= FieldPos("SALDOPER") > 0		// Saldo dois periodos anteriores

nSaldoAnt	:= SALDOANT
nSaldoAtu	:= SALDOATU
nSaldoDeb	:= SALDODEB
nSaldoCrd	:= SALDOCRD
nMovimento	:= MOVIMENTO			
		
nSaldoAtuD	:= SALDOATUDB
nSaldoAtuC	:= SALDOATUCR


// Grava sinteticas
dbSelectArea("cArqTmp")	
dbGoTop()  
If ValType(oMeter) == "O"
	oMeter:SetTotal(cArqTmp->(RecCount()))
	oMeter:Set(0)
EndIf

While !Eof()
	nRegTmp	:= Recno()
	nSaldoAnt	:= SALDOANT
	nSaldoAtu	:= SALDOATU
	nSaldoDeb	:= SALDODEB
	nSaldoCrd	:= SALDOCRD
	nMovimento	:= MOVIMENTO					
	nSaldoAtuD	:= SALDOATUDB
	nSaldoAtuC	:= SALDOATUCR

	dbSelectArea("CT1")
	dbSetOrder(1)
		
	cContaSup := cArqTmp->SUPERIOR
	If Empty(cContaSup)
		dbSelectArea("cArqTmp")
		Replace NIVEL1 With .T.
		dbSelectArea("CT1")
	EndIf		
	MsSeek(xFilial()+cContaSup)
		
	While !Eof() .And. CT1->CT1_FILIAL == xFilial()

		cDesc := &("CT1->CT1_DESC"+cMoeda)
		If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
			cDesc := CT1->CT1_DESC01
		Endif

   		dbSelectArea("cArqTmp")
		dbSetOrder(1)
		If !MsSeek(cContaSup)
			dbAppend()
			Replace CONTA		With cContaSup
			Replace SUPERIOR	With CT1->CT1_CTASUP
			Replace DESCCTA		With cDesc
			Replace TIPOCONTA	With CT1->CT1_CLASSE
			Replace CTARES    	With CT1->CT1_RES
			Replace NORMAL   	With CT1->CT1_NORMAL
			Replace GRUPO		With CT1->CT1_GRUPO
		EndIf    

		Replace	SALDOANT 	With SALDOANT 	+ nSaldoAnt
		Replace SALDOANTDB  With SALDOANTDB + nSaldoAntD
		Replace SALDOANTCR	With SALDOANTCR + nSaldoAntC
		Replace SALDOATU 	With SALDOATU 	+ nSaldoAtu
		Replace SALDOATUDB	With SALDOATUDB	+ nSaldoAtuD
		Replace SALDOATUCR	With SALDOATUCR + nsaldoAtuC
		Replace SALDODEB 	With SALDODEB 	+ nSaldoDeb
		Replace SALDOCRD 	With SALDOCRD 	+ nSaldoCrd

		If !lNImpMov
			Replace MOVIMENTO With MOVIMENTO + nMovimento
		Endif

		If lSemestre		// Saldo por semestre
			Replace SALDOSEM With SALDOSEM 	+ nSaldoSEM
		Endif

   		If lPeriodo0		// Saldo dois periodos anteriores
			Replace SALDOPER With SALDOPER 	+ nSaldoSEM
		Endif
		
		dbSelectArea("CT1")
		cContaSup := CT1->CT1_CTASUP
		If Empty(CT1->CT1_CTASUP)
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea("CT1")
			Exit
		EndIf		
		MsSeek(xFilial()+cContaSup)
	EndDo
	dbSelectArea("cArqTmp")
	dbGoto(nRegTmp)
	dbSkip()
	If ValType(oMeter) == "O"	
		nMeter++
   		oMeter:Set(nMeter)						
  	EndIF
EndDo
	
    	
RestArea(aSaveArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTUBlnQry ºAutor  ³Simone Mie Sato     º Data ³  12/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Query do CTU => Balancetes								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CTUBlnQry(dDataIni,dDataFim,cAlias,cIdent,cEntidIni,cEntidFim,cMoeda,cTpSald,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu)

Local cQuery		:= ""
Local cCampUSU		:= ""
Local cFieldQry		:= ""
Local cOrdQry		:= ""
Local aAreaQry		:= GetArea()		/// array com a posição no arquivo original
Local aTamVlr		:= TAMSX3("CTU_DEBITO")
Local aStrSTRU		:= {}
Local nStruLen		:= 0   
Local nStr			:= 1

DO CASE
CASE cIdent == "CTD"
	cFieldQry	:= " CTD_ITEM ITEM	,CTD_RES ITEMRES, CTD_DESC"+cMoeda+" DESCITEM	, CTD_DESC01 DESCIT01, CTD_CLASSE TIPOITEM	, CTD_ITSUP ITSUP, "
	If CtbExDtFim("CTD") 
		cFieldQry += " CTD_DTEXSF CTDDTEXSF, "	
	EndIf
	cOrdQry		:= "CTD_ITEM"
CASE cIdent == "CTT"
	cFieldQry	:= " CTT_CUSTO CUSTO	,CTT_RES CCRES	, CTT_DESC"+cMoeda+" DESCCC		, CTT_DESC01 DESCCC01, CTT_CLASSE TIPOCC	, CTT_CCSUP CCSUP, "
	If CtbExDtFim("CTT") 
		cFieldQry += " CTT_DTEXSF CTTDTEXSF, "	
	EndIf	
	cOrdQry		:= "CTT_CUSTO"
CASE cIdent == "CTH"
	cFieldQry	:= " CTH_CLVL CLVL	,CTH_RES CLVLRES, CTH_DESC"+cMoeda+" DESCCLVL	, CTH_DESC01 DESCCV01	, CTH_CLASSE TIPOCLVL	, CTH_CLSUP CLSUP, "
	If CtbExDtFim("CTH") 
		cFieldQry += " CTH_DTEXSF CTHDTEXSF, "	
	EndIf	
	cOrdQry		:= "CTH_CLVL"
ENDCASE


aAreaQry := GetArea()            

cQuery := " SELECT "+cFieldQry
///////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cFILUSU)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := (cIdent)->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////
	
cQuery += " 		(SELECT SUM(CTU_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CTU")+" CTU "
cQuery += " 			WHERE CTU_FILIAL = '"+xFilial("CTU")+"'  "
cQuery += "				AND CTU_IDENT	= '"+cIdent+"' "
cQuery += " 			AND CTU_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTU_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CTU_CODIGO	= "+cOrdQry+" "
cQuery += " 			AND CTU_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND CTU.D_E_L_E_T_ = '') "
cQuery += "  SALDOANTDB, "  
If lImpAntLP
	cQuery += " 		(SELECT SUM(CTU_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CTU")+" CTU "
	cQuery += " 			WHERE CTU_FILIAL = '"+xFilial("CTU")+"'  "
	cQuery += "				AND CTU_IDENT	= '"+cIdent+"' "
	cQuery += " 			AND CTU_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CTU_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CTU_CODIGO	= "+cOrdQry+" "
	cQuery += " 			AND CTU_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CTU_LP = 'Z' AND ((CTU_DTLP <> ' ' AND CTU_DTLP >= '"+DTOS(dDataLP)+"') OR (CTU_DTLP = '' AND CTU_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CTU.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTDB, "  
EndIf
cQuery += " 		(SELECT SUM(CTU_CREDIT) "
cQuery += "			 	FROM "+RetSqlName("CTU")+" CTU "
cQuery += " 			WHERE CTU_FILIAL = '"+xFilial("CTU")+"'  "
cQuery += "				AND CTU_IDENT	= '"+cIdent+"' "
cQuery += " 			AND CTU_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTU_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CTU_CODIGO	= "+cOrdQry+" "
cQuery += " 			AND CTU_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND CTU.D_E_L_E_T_ = '') "
cQuery += "  SALDOANTCR, "          
If lImpAntLP
	cQuery += " 	   (SELECT SUM(CTU_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CTU")+" CTU "
	cQuery += " 			WHERE CTU_FILIAL = '"+xFilial("CTU")+"'  "
	cQuery += "				AND CTU_IDENT	= '"+cIdent+"' "
	cQuery += " 			AND CTU_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CTU_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CTU_CODIGO	= "+cOrdQry+" "
	cQuery += " 			AND CTU_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CTU_LP = 'Z' AND ((CTU_DTLP <> ' ' AND CTU_DTLP >= '"+DTOS(dDataLP)+"') OR (CTU_DTLP = '' AND CTU_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CTU.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTCR, "  
EndIf
cQuery += " 		(SELECT SUM(CTU_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CTU")+" CTU "
cQuery += " 			WHERE CTU_FILIAL = '"+xFilial("CTU")+"'  "
cQuery += "				AND CTU_IDENT	= '"+cIdent+"' "
cQuery += " 			AND CTU_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTU_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CTU_CODIGO	= "+cOrdQry+" "
cQuery += " 			AND CTU_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND CTU.D_E_L_E_T_ = '') "
cQuery += "  SALDODEB, " 
If lImpAntLP
	cQuery += " 		(SELECT SUM(CTU_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CTU")+" CTU "
	cQuery += " 			WHERE CTU_FILIAL = '"+xFilial("CTU")+"'  "
	cQuery += "				AND CTU_IDENT	= '"+cIdent+"' "
	cQuery += " 			AND CTU_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CTU_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CTU_CODIGO	= "+cOrdQry+" "
	cQuery += " 			AND CTU_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CTU_LP = 'Z' AND ((CTU_DTLP <> ' ' AND CTU_DTLP >= '"+DTOS(dDataLP)+"') OR (CTU_DTLP = '' AND CTU_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CTU.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPDEB, " 
EndIf
cQuery += " 		(SELECT SUM(CTU_CREDIT) "
cQuery += "			 	FROM "+RetSqlName("CTU")+" CTU "
cQuery += " 			WHERE CTU_FILIAL = '"+xFilial("CTU")+"'  "
cQuery += "				AND CTU_IDENT	= '"+cIdent+"' "
cQuery += " 			AND CTU_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTU_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CTU_CODIGO	= "+cOrdQry+" "
cQuery += " 			AND CTU_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND CTU.D_E_L_E_T_ = '') "
cQuery += "  SALDOCRD "
If lImpAntLP
	cQuery += ", 		(SELECT SUM(CTU_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CTU")+" CTU "
	cQuery += " 			WHERE CTU_FILIAL = '"+xFilial("CTU")+"'  "
	cQuery += "				AND CTU_IDENT	= '"+cIdent+"' "
	cQuery += " 			AND CTU_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CTU_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CTU_CODIGO	= "+cOrdQry+" "
	cQuery += " 			AND CTU_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CTU_LP = 'Z' AND ((CTU_DTLP <> ' ' AND CTU_DTLP >= '"+DTOS(dDataLP)+"') OR (CTU_DTLP = '' AND CTU_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CTU.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPCRD "
EndIf
cQuery += " 	FROM "+RetSqlName(cIdent)+" ARQ	" 
cQuery += " 	WHERE ARQ."+cIdent+"_FILIAL = '"+xFilial(cIdent)+"' "
cQuery += " 	AND ARQ."+cOrdQry+" BETWEEN '"+cEntidIni+"' AND '"+cEntidFim+"' "
cQuery += " 	AND ARQ."+cIdent+"_CLASSE = '2' "


If !Empty(aSetOfBook[1])										//// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ."+cIdent+"_BOOK LIKE '%"+aSetOfBook[1]+"%' "    //// FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif
cQuery += " 	AND ARQ.D_E_L_E_T_ = '' "

If !lVlrZerado .And. !lImpAntLP	//Se considerar posicao anterior LP sera verificado na gravacao do arquivo de trabalho
	cQuery += "  AND ((SELECT ROUND(SUM(CTU_DEBITO),2)-ROUND(SUM(CTU_CREDIT),2) "
	cQuery += "			 	FROM "+RetSqlName("CTU")+" CTU "
	cQuery += " 			WHERE CTU_FILIAL = '"+xFilial("CTU")+"'  "
	cQuery += "				AND '"+cIdent+"' = CTU_IDENT "
	cQuery += " 			AND CTU_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CTU_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ."+cOrdQry+"	= CTU_CODIGO "
	cQuery += " 			AND CTU_DATA < '"+DTOS(dDataIni)+"' "
	cQuery += " 			AND CTU.D_E_L_E_T_ = '') <> 0 "
	cQuery += " 	OR "	
	cQuery += " 		(SELECT SUM(CTU_DEBITO) "
	cQuery += " 			FROM "+RetSqlName("CTU")+" CTU "
	cQuery += " 			WHERE CTU_FILIAL = '"+xFilial("CTU")+"'  "
	cQuery += "				AND '"+cIdent+"' = CTU_IDENT "
	cQuery += " 			AND CTU_MOEDA = '"+cMoeda+"' "            
	cQuery += " 			AND CTU_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ."+cOrdQry+"	= CTU_CODIGO "
	cQuery += " 			AND CTU_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND CTU.D_E_L_E_T_ = '')<> 0 "
	cQuery += " 	OR "	
	cQuery += " 		(SELECT SUM(CTU_CREDIT) "
	cQuery += " 			FROM "+RetSqlName("CTU")+" CTU "
	cQuery += " 			WHERE CTU_FILIAL = '"+xFilial("CTU")+"'  "
	cQuery += "				AND '"+cIdent+"' = CTU_IDENT "
	cQuery += " 			AND CTU_MOEDA = '"+cMoeda+"' "            
	cQuery += " 			AND CTU_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ."+cOrdQry+"	= CTU_CODIGO "
	cQuery += " 			AND CTU_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND CTU.D_E_L_E_T_ = '')<> 0 )"	
Endif
	
cQuery := ChangeQuery(cQuery)		   

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)

TcSetField("TRBTMP","SALDOANTDB","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDOANTCR","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDODEB","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDOCRD","N",aTamVlr[1],aTamVlr[2])	    

If cIdent == "CTT" .And. CtbExDtFim("CTT") 
	TcSetField("TRBTMP","CTTDTEXSF","D",8,0)	    
ElseIf cIdent == "CTD" .And. CtbExDtFim("CTD") 
	TcSetField("TRBTMP","CTDDTEXSF","D",8,0)	    
ElseIf cIdent == "CTH".And. CtbExDtFim("CTH") 
	TcSetField("TRBTMP","CTHDTEXSF","D",8,0)	    
EndIf

If lImpAntLP
	TcSetField("TRBTMP","SLDLPANTDB","N",aTamVlr[1],aTamVlr[2])	
	TcSetField("TRBTMP","SLDLPANTCR","N",aTamVlr[1],aTamVlr[2])	
	TcSetField("TRBTMP","MOVLPDEB","N",aTamVlr[1],aTamVlr[2])	
	TcSetField("TRBTMP","MOVLPCRD","N",aTamVlr[1],aTamVlr[2])	    
EndIf

RestArea(aAreaQry)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CtbCTUSup  ³Autor  ³ Simone Mie Sato       ³ Data ³ 12.09.03 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualizacao de sinteticas                                   			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtbCTUSup() 															 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lNImpMov = Se imprime entidades sem movimento		               	 ³±±
±±³          ³ cMoeda	= Moeda                              	              		 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtbCTUSup(oMeter,oText,oDlg,lNImpMov,cMoeda,cIdent)							
		
Local aSaveArea	:= GetArea()				
Local cDesc		:= ""
Local cCodEnt	:= ""
Local cCodEntSup:= ""
Local cEntidSup	:= ""
Local nSaldoAnt	:= 0
Local nSaldoAtu	:= 0
Local nSaldoDeb	:= 0
Local nSaldoCrd	:= 0
Local nMovimento:= 0
Local nSaldoAntD:= 0
Local nSaldoAntC:= 0
Local nSaldoAtuD:= 0
Local nsaldoAtuC:= 0
Local nReg   	:= 0
Local nRegTmp	:= 0
Local nTamDesc	:= 0
Local nMeter	:= 0

Do Case
Case cIdent == 'CTT'   
	cCodEnt		:= 'CUSTO'
	cCodEntSup	:= 'CCSUP'
	nTamDesc	:= Len(CriaVar("CTT->CTT_DESC"+cMoeda))
Case cIdent=='CTD'     
	cCodEnt		:= 'ITEM'
	cCodEntSup  := 'ITSUP'
	nTamDesc	:= Len(CriaVar("CTD->CTD_DESC"+cMoeda))	
Case cIdent =='CTH'    
	cCodEnt		:= 'CLVL'
	cCodEntSup  := 'CLSUP'     
	nTamDesc	:= Len(CriaVar("CTH->CTH_DESC"+cMoeda))
EndCase

// Grava sinteticas
dbSelectArea("cArqTmp")	
dbGoTop()  
If ValType(oMeter) == "O"
	oMeter:SetTotal(("cArqTmp")->(RecCount()))
	oMeter:Set(0)
EndIf

While!Eof()                                 
                                            
	nSaldoAnt:= SALDOANT
	nSaldoAtu:= SALDOATU
	nSaldoDeb:= SALDODEB
	nSaldoCrd:= SALDOCRD   
	nMovimento:= MOVIMENTO
	nSaldoAntD := SALDOANTDB
	nSaldoAntC := SALDOANTCR	
	nSaldoAtuD := SALDOATUDB
	nsaldoAtuC := SALDOATUCR

	nRegTmp := Recno()  
	
	dbSelectArea(cIdent)
	dbSetOrder(1)      
	cEntidSup := &("cArqTmp->"+cCodEntSup)
	If Empty(cEntidSup)
		dbSelectArea("cArqTmp")
		Replace NIVEL1 With .T.
		dbSelectArea(cIdent)
	EndIf		
	MsSeek(xFilial()+ &("cArqTmp->"+cCodEntSup))
		
	While !Eof() .And. &(cIdent+"_FILIAL") == xFilial(cIdent)
						
		cDesc := &(cIdent+"_DESC"+cMoeda)
		If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
			cDesc := &(cIdent+"_DESC01")
		Endif			
	
		dbSelectArea("cArqTmp")
		dbSetOrder(1)      
		If ! MsSeek(cEntidSup)
			dbAppend()
			If cIdent == 'CTT'
				Replace CUSTO   	With cEntidSup
				Replace DESCCC		With cDesc
				Replace TIPOCC 		With CTT->CTT_CLASSE
				Replace CCSUP 		With CTT->CTT_CCSUP					
				Replace CCRES		With CTT->CTT_RES				
			ElseIf cIdent == 'CTD'
				Replace ITEM 		With cEntidSup
				Replace DESCITEM	With cDesc
				Replace TIPOITEM 	With CTD->CTD_CLASSE
				Replace ITSUP  		With CTD->CTD_ITSUP					
				Replace ITEMRES		With CTD->CTD_RES				
			ElseIf cIdent == 'CTH'
				Replace CLVL 	 With cEntidSup
				Replace DESCCLVL With cDesc
				Replace TIPOCLVL With CTH->CTH_CLASSE
				Replace CLSUP	 With CTH->CTH_CLSUP 
				Replace CLVLRES	 With CTH->CTH_RES				
			EndIf						
		EndIf				

		Replace	 SALDOANT With SALDOANT + nSaldoAnt
		Replace  SALDOANTDB With SALDOANTDB + nSaldoAntD
		Replace  SALDOANTCR	With SALDOANTCR + nSaldoAntC		
		Replace  SALDOATU With SALDOATU + nSaldoAtu
		Replace  SALDOATUDB	With SALDOATUDB	+ nSaldoAtuD
		Replace  SALDOATUCR	With SALDOATUCR + nsaldoAtuC		
		Replace  SALDODEB With SALDODEB + nSaldoDeb
		Replace  SALDOCRD With SALDOCRD + nSaldoCrd
		If !lNImpMov
			Replace MOVIMENTO With MOVIMENTO + nMovimento
		Endif
   		
		cEntidSup := &("cArqTmp->"+cCodEntSup)
		If Empty(cEntidSup)
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea(cIdent)
			Exit                     						
		EndIf		
		dbSelectArea("cArqTmp")
		dbGoto(nRegTmp)
		dbSelectArea(cIdent)
		MsSeek(xFilial()+ cEntidSup)
	EndDo
	dbSelectArea("cArqTmp")
	dbGoto(nRegTmp)
	dbSkip()
	If ValType(oMeter) == "O"	
		nMeter++
   		oMeter:Set(nMeter)		
  	EndIf
EndDo

RestArea(aSaveArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBXSAL   ºAutor  ³Microsiga           º Data ³  06/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function SupCmpCt7(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,cContaFim,cEntidIni,cEntidFim,cMoeda,cTpSld1,cTpSld2,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,cAlias,lCusto,lItem,lClVl,lAtSldBase,nInicio,nFinal,cFilDe,cFilate,nDivide,lVariacao0,lCt1Sint)
                                             
Local aSaveArea := GetArea()
					
Local cEntid
Local cContaSup
Local cDesc
Local cMascara  := aSetOfBook[2] //VERIFICAR
Local cCodEnt	:= ""
Local cCusIni	:= ""
Local cCusFim	:= ""
Local cItemIni	:= ""
Local cItemFim	:= ""
Local cCodRes	:= ""
Local cCodEntRes:= ""              
Local cTipoEnt	:= ""                  
Local cCodTpEnt := ""
Local cDescEnt	:= ""
Local cQuery 	:= ""
Local cFilCT1	:= ""
Local cFilEntd	:= ""
Local cFilEnt	:= ""
Local cCondCT1	:= ""     
Local cCondFil	:= ""
Local cCondEnt	:= ""                        
Local cCadAlias	:= ""                        
Local cOrderBy	:= ""
Local cSelect	:= ""          
Local cContaEnt	:= ""                           
Local cChave	:= ""
Local nMeter	:= 0

Local nPos		:= 0
Local nDigitos	:= 0
Local nRegTmp   := 0
Local nMovimen01:= 0 
Local nMovimen02:= 0	
Local nOrder1	:= 0                                  
Local nOrder2	:= 0
Local nTamCC	:= Len(CriaVar("CTT_CUSTO"))
Local nTamItem	:= Len(CriaVar("CTD_ITEM")) 
Local nTamCta	:= Len(CriaVar("CT1_CONTA"))
Local nMin		:= 0	
Local nMax		:= 0      
Local nVariacao	:= 0      
Local nMovSld1	:= 0
Local nMovSld2	:= 0

Local bCond1	:= {||.F.}
Local bCond2	:= {||.F.}
                 
Local oProcess

DEFAULT lCt1Sint := .T.			//// SE DEVE CALCULAR AS SINTÉTICAS SIM/NAO


lVariacao0	:= Iif(lVariacao0 == Nil,.T.,lVariacao0)
nDivide 	:= Iif(nDivide == Nil,1,nDivide)

//oMeter:nTotal := &(cAlias)->(RecCount())

// Verifica Filtragem por Segmento da  Conta

If !lCt1Sint
	RestArea(aSaveArea)	/// SE NÃO DEVE CALCULAR AS SINTETICAS ABORTA
	Return
Endif

// Grava contas sinteticas
dbSelectArea("cArqTmp")	
If ValType(oMeter) == "O"
	oMeter:SetTotal(cArqTmp->(RecCount()))
	oMeter:Set(0)
EndIf
dbGoTop()  

While!Eof()                                 
	If ValType(oMeter) == "O"
		nMeter++
  		oMeter:Set(nMeter)				
  	EndIf
                                            
	nMovim01	:= MOVIMENTO1
	nMovim02	:= MOVIMENTO2
	nRegTmp 	:= Recno()   
	   
	If cAlias == 'CT3' 
		cEntid 	 := cArqTmp->CUSTO
		cCodRes	 := cArqTmp->CCRES
		cTipoEnt := cArqTmp->TIPOCC
		cDescEnt := cArqTmp->DESCCC
	ElseIf cAlias == 'CT4'      	
		cEntid 	 := cArqTmp->ITEM
		cCodRes	 := cArqTmp->ITEMRES
		cTipoEnt := cArqTmp->TIPOITEM
		cDescEnt := cArqTmp->DESCITEM
	ElseIf cAlias == 'CTI'
		cEntid 	 := cArqTmp->CLVL
		cCodRes	 := cArqTmp->CLVLRES
		cTipoEnt := cArqTmp->TIPOCLVL
		cDescEnt := cArqTmp->DESCCLVL
	EndIf
	
	dbSelectArea("CT1")	
	dbSetOrder(1)      
	cContaSup := cArqTmp->CONTA
	MsSeek(xFilial("CT1")+ cContaSup)
	If Empty(CT1->CT1_CTASUP)
		dbSelectArea("cArqTmp")
		Replace NIVEL1 With .T.
		dbSelectArea("CT1")
	EndIf		

	cContaSup := CT1->CT1_CTASUP
	MsSeek(xFilial("CT1")+ cContaSup)
		
	While !Eof() .And. CT1->CT1_FILIAL == xFilial()

		cDesc := &("CT1->CT1_DESC"+cMoeda)
		If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
			cDesc := CT1->CT1_DESC01
		Endif
		
		dbSelectArea("cArqTmp")
		dbSetOrder(1)      

		If !MsSeek(cEntid+cContaSup)
			RecLock("cArqTMP",.T.)
			Replace CONTA		With cContaSup	
			Replace DESCCTA 	With cDesc
			Replace TIPOCONTA	With CT1->CT1_CLASSE
			Replace CTARES		With CT1->CT1_RES
			If cAlias == 'CT3'
				Replace CUSTO With cEntid		 
				Replace CCRES With cCodRes
				Replace TIPOCC With cTipoEnt
				Replace DESCCC With cDescEnt
			ElseIf cAlias == 'CT4'
			    Replace ITEM With cEntid
			    Replace ITEMRES With cCodRes
			    Replace TIPOITEM With cTipoEnt
			    Replace DESCITEM With cDescEnt
			ElseIf cAlias == 'CTI'
				Replace CLVL With cEntid
				Replace CLVLRES With cCodRes  
				Replace TIPOCLVL With cTipoEnt
				Replace DESCCLVL WITH cDescEnt
			EndIf
			Replace	 MOVIMENTO1 With MOVIMENTO1 + nMovim01
			Replace  MOVIMENTO2 With MOVIMENTO2 + nMovim02
		Else
			RecLock("cArqTMP",.F.)		
			Replace	 MOVIMENTO1 With MOVIMENTO1 + nMovim01
			Replace  MOVIMENTO2 With MOVIMENTO2 + nMovim02
		Endif
		
		dbSelectArea("CT1")
		cContaSup := CT1->CT1_CTASUP
		If Empty(CT1->CT1_CTASUP)
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea("CT1")
			Exit
		EndIf		
		
		cArqTMP->(MsUnlock())
		
		MsSeek(xFilial()+cContaSup)

		dbSelectArea("cArqTmp")
		dbGoto(nRegTmp)
		dbSelectArea("CT1")
	EndDo
	dbSelectArea("cArqTmp")
	dbGoto(nRegTmp)
	dbSkip()
EndDo

RestArea(aSaveArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBXSAL   ºAutor  ³Microsiga           º Data ³  06/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±           
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function SupCmpEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,;
					cMoeda,cTpSld1,cTpSld2,aSetOfBook,;
					cSegmento,cSegIni,cSegFim,cFiltSegm,cAlias,;
					lCusto,lItem,lClVl,lAtSldBase,nInicio,nFinal,cFilDe,cFilate,;
					nDivide,lVariacao0,nGrupo,bVariacao,cIdent,lCt1Sint)
					
Local aSaveArea 	:= GetArea()

Local cDesc
Local cMascara		:= ""
Local cSepara		:= ""

Local nPos			:= 0
Local nDigitos		:= 0
Local nRegTmp   	:= 0
Local nTamDesc		:= ""
Local nMovSld1		:= 0
Local nMovSld2		:= 0
Local nColuna1		:= 0
Local nColuna2		:= 0
Local nMeter		:= 0

Local oProcess
Local dMinSld1 := cTod("")
Local dMinSld2 := cTod("")

Local aSldAnt1 := {}
Local	aSldAnt2 := {}       

Local lAtSldCmp := Iif(GetMV("MV_SLDCOMP")== "S",.T.,.F.) 
Local cMensagem := OemToAnsi(STR0002)// O plano gerencial ainda nao esta disponivel nesse relatorio. 			

#IFDEF TOP
	Local nMin			:= 0
	Local nMax			:= 0 
#ENDIF


DEFAULT lCt1Sint := .T.

lVariacao0	:= Iif(lVariacao0 == Nil,.T.,lVariacao0)
nDivide 	:= Iif(nDivide == Nil,1,nDivide)

If cAlias	== 'CT7'
	If !Empty(aSetOfBook[2])
		cMascara	:= aSetOfBook[2]
	EndIf
ElseIf cAlias	== 'CTU'
  		Do Case
  		Case cIdent == 'CTT'
	 		cMascara	:= aSetOfBook[6]			
	 		cOrigem		:= 'CT3'		
 		Case cIdent	== 'CTD'
	 		cMascara	:= aSetOfBook[7]			            		
	 		cOrigem		:= 'CT4'		
		Case cIdent == 'CTH'			
	 		cMascara	:= aSetOfBook[8]	   
	 		cOrigem		:= 'CTI'		
 		EndCase	
EndIf

	
//Se os saldos basicos nao foram atualizados na dig. lancamentos
If !lAtSldBase
  	#IFDEF TOP
		If TcSrvType() != "AS/400"                     		  	
			//Chama Rotina de Atualizacao de Saldos Basicos.
			oProcess := MsNewProcess():New({|lEnd|	Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cTpSld1,.T.,cFilDe,cFilAte,,,.T.,oProcess,nMin,nMax)},"","",.F.)
			oProcess:Activate()						
			oProcess := MsNewProcess():New({|lEnd|	Ct190SlBse(nInicio,nFinal,lClvl,lItem,lCusto,cTpSld2,.T.,cFilDe,cFilAte,,,.T.,oProcess,nMin,nMax)},"","",.F.)
			oProcess:Activate()				
		Else
	#ENDIF
		oProcess := MsNewProcess():New({|lEnd|	Ct360RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cTpSld1,oProcess,lAtSldBase)},"","",.F.)		
		oProcess:Activate()						
		oProcess := MsNewProcess():New({|lEnd|	Ct360RDbf(nInicio,nFinal,lClVl,lItem,lCusto,cTpSld2,oProcess,lAtSldBase)},"","",.F.)				
		oProcess:Activate()									
	#IFDEF TOP
		EndIf
	#ENDIF
Endif	

If cAlias == 'CT7'
	
	If !lCt1Sint
		RestArea(aSaveArea)	/// SE NÃO DEVE CALCULAR AS SINTETICAS ABORTA
		Return
	Endif
		
	// Grava contas sinteticas

	dbSelectArea("cArqTmp")	
	If ValType(oMeter) == "O"	
		oMeter:SetTotal(cArqTmp->(RecCount()))
		oMeter:Set(0)
	EndIf
	dbGoTop()  

	While!Eof()                                 
		If ValType(oMeter) == "O"    
			nMeter++
		  	oMeter:Set(nMeter)				    
		EndIf
                                            
		nMovim01	:= MOVIMENTO1
		nMovim02	:= MOVIMENTO2
		If FieldPos("COLUNA_1") > 0
			nColuna1 := COLUNA_1
			nColuna2 := COLUNA_2
		Else
			nColuna1 := nColuna2 := 0.00
		Endif
		nRegTmp 	:= Recno()   
	
		dbSelectArea("CT1")
		dbSetOrder(1)
		MsSeek(xFilial()+cArqTmp->CONTA)	

		If Empty(CT1->CT1_CTASUP)
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea("CT1")
		EndIf
		
		cContaSup := CT1->CT1_CTASUP
		MsSeek(xFilial()+cContaSup)
	
		While !Eof() .And. CT1->CT1_FILIAL == xFilial()
			cDesc := &("CT1->CT1_DESC"+cMoeda)
			If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
				cDesc := CT1->CT1_DESC01
			Endif
			dbSelectArea("cArqTmp")
			dbSetOrder(1)
			If !MsSeek(cContaSup)
				RecLock("cArqTMP",.T.)
				Replace CONTA		With cContaSup
				Replace DESCCTA		With cDesc
				Replace TIPOCONTA	With CT1->CT1_CLASSE
				Replace CTARES    	With CT1->CT1_RES
				Replace NORMAL   	With CT1->CT1_NORMAL
				Replace GRUPO		With CT1->CT1_GRUPO
			Else
				RecLock("cArqTMP",.F.)
			EndIf    

			Replace	 MOVIMENTO1 With MOVIMENTO1 + nMovim01
			Replace  MOVIMENTO2 With MOVIMENTO2 + nMovim02
		
			If nColuna1 # 0
				Replace COLUNA_1 With COLUNA_1 + nColuna1
			Endif
		   		
			If nColuna2 # 0
				Replace COLUNA_2 With COLUNA_2 + nColuna2
			Endif
		   		
			If bVariacao <> Nil
				Eval(bVariacao)
			Endif		
		
			dbSelectArea("CT1")
			cContaSup := CT1->CT1_CTASUP
			If Empty(CT1->CT1_CTASUP)
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea("CT1")
				Exit
			EndIf		
			cArqTMP->(MsUnlock())
			MsSeek(xFilial()+cContaSup)      		
		EndDo
    	
		dbSelectArea("cArqTmp")
		dbSetOrder(1)
		dbGoTo(nRegTmp)
		dbSkip()
	EndDo	
		
ElseIf cAlias == 'CTU'
	//Verificar se tem algum saldo a ser atualizado
	If cIdent = 'CTT'                                                                      
		Ct360Data('CT3','CTU',@dMinSld1,lCusto,lItem,cFilDe,cFilAte,cTpSld1,cMoeda,cMoeda,,,,,,,,,,cFilAnt)  
		Ct360Data('CT3','CTU',@dMinSld2,lCusto,lItem,cFilDe,cFilAte,cTpSld2,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
	ElseIf cIdent = 'CTD'
		Ct360Data('CT4','CTU',@dMinSld1,lCusto,lItem,cFilDe,cFilAte,cTpSld1,cMoeda,cMoeda,,,,,,,,,,cFilAnt)  
		Ct360Data('CT4','CTU',@dMinSld2,lCusto,lItem,cFilDe,cFilAte,cTpSld2,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
	Else                                                                                                     
		Ct360Data('CTI','CTU',@dMinSld1,lCusto,lItem,cFilDe,cFilAte,cTpSld1,cMoeda,cMoeda,,,,,,,,,,cFilAnt) 
		Ct360Data('CTI','CTU',@dMinSld2,lCusto,lItem,cFilDe,cFilAte,cTpSld2,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
	EndIf

	//Se o parametro MV_SLDCOMP estiver com "S",isto e, se devera atualizar os saldos compost.
	//na emissao dos relatorios, verifica se tem algum registro desatualizado e atualiza as
	//tabelas de saldos compostos.
	If lAtSldCmp 	//Se atualiza saldos compostos no relatorio
		If !Empty(dMinSld1)                            				
			oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cTpSld1,cMoeda,dDataIni,cOrigem,dMinSld1,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt)},"","",.F.)
			oProcess:Activate()                                 	
		EndIf
		If !Empty(dMinSld2)
			oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cTpSld2,cMoeda,dDataIni,cOrigem,dMinSld2,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt)},"","",.F.)
			oProcess:Activate()				
		EndIf
	Else
		If !Empty(dMinSld1) .Or. !Empty(dMinSld2)
			cMensagem	:= STR0016
			cMensagem	+= STR0017
			MsgInfo(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
										  					//atraves da rotina de saldos compostos	
			Return
		EndIf    
	EndIf

	Do Case
	Case cIdent == 'CTT'   
		cCodEnt		:= 'CUSTO'
		cCodEntSup	:= 'CCSUP'
		nTamDesc	:= Len(CriaVar("CTT->CTT_DESC"+cMoeda))
	Case cIdent=='CTD'     
		cCodEnt		:= 'ITEM'
		cCodEntSup  := 'ITSUP'
		nTamDesc	:= Len(CriaVar("CTD->CTD_DESC"+cMoeda))	
	Case cIdent =='CTH'    
		cCodEnt		:= 'CLVL'
		cCodEntSup  := 'CLSUP'     
		nTamDesc	:= Len(CriaVar("CTH->CTH_DESC"+cMoeda))
	EndCase

	dbSelectArea(cIdent)
	dbSetOrder(1)
	MsSeek(xFilial()+cEntidIni,.T.)
	// Grava sinteticas
	dbSelectArea("cArqTmp")	
	If ValType(oMeter) == "O"	
		oMeter:SetTotal(cArqTmp->(RecCount()))
		oMeter:Set(0)
	EndIf
	dbGoTop()  

	While!Eof()                                 
		If ValType(oMeter) == "O"	
			nMeter++
    		oMeter:Set(nMeter)				
   		EndIf
                                           
		nMovim01	:= MOVIMENTO1
		nMovim02	:= MOVIMENTO2
		If FieldPos("COLUNA_1") > 0
			nColuna1 := COLUNA_1
			nColuna2 := COLUNA_2
		Else
			nColuna1 := nColuna2 := 0.00
		Endif
		
		nRegTmp := Recno()  

		dbSelectArea(cIdent)
		dbSetOrder(1)      
		cEntidSup := &("cArqTmp->"+cCodEntSup)
		If Empty(cEntidSup)
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea(cIdent)
		EndIf		
		MsSeek(xFilial()+ &("cArqTmp->"+cCodEntSup))
	
		While !Eof() .And. &(cIdent+"_FILIAL") == xFilial()
						
			cDesc := &(cIdent+"_DESC"+cMoeda)
			If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
				cDesc := &(cIdent+"_DESC01")
			Endif			
	
			dbSelectArea("cArqTmp")
			dbSetOrder(1)      
			If ! MsSeek(cEntidSup)
				RecLock("cArqTMP",.T.)
				If cIdent == 'CTT'
					Replace CUSTO   	With cEntidSup
					Replace DESCCC		With cDesc
					Replace TIPOCC 		With CTT->CTT_CLASSE
					Replace CCSUP 		With CTT->CTT_CCSUP					
					Replace CCRES		With CTT->CTT_RES				
				ElseIf cIdent == 'CTD'
					Replace ITEM 		With cEntidSup
					Replace DESCITEM	With cDesc
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP					
					Replace ITEMRES		With CTD->CTD_RES				
				ElseIf cIdent == 'CTH'
					Replace CLVL 	 With cEntidSup
					Replace DESCCLVL With cDesc
					Replace TIPOCLVL With CTH->CTH_CLASSE
					Replace CLSUP	 With CTH->CTH_CLSUP 
					Replace CLVLRES	 With CTH->CTH_RES				
				EndIf						
			Else
				RecLock("cArqTMP",.F.)
			EndIf				
			Replace	 MOVIMENTO1 With MOVIMENTO1 + nMovim01
			Replace  MOVIMENTO2 With MOVIMENTO2 + nMovim02
		
			If nColuna1 # 0
				Replace COLUNA_1 With COLUNA_1 + nColuna1
			Endif
	   		
			If nColuna2 # 0
				Replace COLUNA_2 With COLUNA_2 + nColuna2
			Endif
	   		
	   		If bVariacao <> Nil
				Eval(bVariacao)
			Endif
   	
			cEntidSup := &("cArqTmp->"+cCodEntSup)
			If Empty(cEntidSup)
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea(cIdent)
				Exit                     						
			EndIf		
			cArqTMP->(MsUnlock())
			
			dbSelectArea("cArqTmp")
			dbGoto(nRegTmp)
			dbSelectArea(cIdent)
			MsSeek(xFilial()+ cEntidSup)
		EndDo
		dbSelectArea("cArqTmp")
		dbGoto(nRegTmp)
		dbSkip()
	EndDo
EndIf
RestArea(aSaveArea)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CT7CompQry ³Autor  ³ Simone Mie Sato       ³ Data ³ 11.06.03 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Query para comparativo de conta x 6/12 meses                			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CT7CompQry()                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oMeter	= Objeto oMeter                     	               		 ³±±
±±³          ³ oText 	= Objeto oText                      	                	 ³±±
±±³          ³ oDlg  	= Objeto oDlg                       	                	 ³±±
±±³          ³ lEnd 	 = Acao do CodeBlock                 	                	 ³±±
±±³          ³ dDataIni  = Data Inicial                      	                	 ³±±
±±³          ³ dDataFim = Data Final                     	                 		 ³±±
±±³          ³ cMoeda	= Moeda                              	              		 ³±±
±±³          ³ aSetOfBook	= Array aSetOfBook             	                 		 ³±±
±±³          ³ cAlias    	= Alias a ser utilizado        	                 		 ³±±
±±³          ³ cIdent    	= Identficador                 	                 		 ³±±
±±³          ³ lImpAntLP	= Define se ira considerar apuracao de lucros/perdas	 ³±±
±±³          ³ dDataLP  	= Data de apuracao de lucros/perdas a ser considerado 	 ³±±
±±³          ³ lVlrZerado	= Define se ira imprimir os valores zerados.           	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CT7CompQry(dDataIni,dDataFim,cTpSaldo,cMoeda,cContaIni,cContaFim,aSetOfBook,lVlrZerado,lMeses,aMeses,cString,cFILUSU,lImpAntLP,dDataLP,lAcum)                                                           

Local aSaveArea	:= GetArea()
Local cQuery	:= ""
Local nColunas	:= 0
Local aTamVlr	:= TAMSX3("CT7_DEBITO")
Local nStr		:= 1

DEFAULT lVlrZerado	:= .F.
DEFAULT lAcum		:= .F.

cQuery := " SELECT CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, CT1_DESC"+cMoeda+" DESCCTA,  	"
If CtbExDtFim("CT1") 
	cQuery += " CT1_DTEXSF CT1DTEXSF, "
EndIf
cQuery += " 	CT1_CLASSE TIPOCONTA, CT1_GRUPO GRUPO, CT1_CTASUP CTASUP, "

////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cFILUSU)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := (cString)->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////

If lMeses
	For nColunas := 1 to Len(aMeses)
		cQuery += " 	(SELECT SUM(CT7_CREDIT) - SUM(CT7_DEBITO) "
		cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
		cQuery += " 			WHERE CT7.CT7_FILIAL = '"+xFilial("CT7")+"' "
		cQuery += " 			AND ARQ.CT1_CONTA	= CT7_CONTA "
		cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
		cQuery += " 			AND CT7_TPSALD = '"+cTpSaldo+"' "
		If lAcum .and. nColunas == 1/// SE FOR ACUMULADO, A PRIMEIRA COLUNA TERA O SALDO ATE O FINAL DO PERIODO
			cQuery += " 			AND CT7_DATA <= '"+DTOS(aMeses[nColunas][3])+"' "
		Else						/// AS DEMAIS COLUNAS SEMPRE SOMAM O MOVIMENTO NO PERIODO. (CALCULO NO RELATORIO)
			cQuery += " 			AND CT7_DATA BETWEEN '"+DTOS(aMeses[nColunas][2])+"' AND '"+DTOS(aMeses[nColunas][3])+"' "
		Endif
		If lImpAntLP .and. dDataLP >= aMeses[nColunas][2]
			cQuery += " AND CT7_LP <> 'Z' "
		Endif
		cQuery += " 			AND CT7.D_E_L_E_T_ <> '*') COLUNA"+Str(nColunas,Iif(nColunas>9,2,1))+" "
		
		If nColunas <> Len(aMeses)
			cQuery += ", "
		EndIf		
	Next	
EndIf
	
cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ "
cQuery += " 	WHERE ARQ.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += " 	AND ARQ.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 	AND ARQ.CT1_CLASSE = '2' "
	
If !Empty(aSetOfBook[1])										//// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif	
cQuery += " 	AND ARQ.D_E_L_E_T_ <> '*' "
  
If !lVlrZerado
	If lMeses
		cQuery += " 	AND ( "
		For nColunas := 1 to Len(aMeses)
			cQuery += "	(SELECT ROUND(SUM(CT7_CREDIT),2) - ROUND(SUM(CT7_DEBITO),2) "
			cQuery += " FROM "+RetSqlName("CT7")+" CT7 "
			cQuery += " WHERE CT7.CT7_FILIAL	= '"+xFilial("CT7")+"' "
			cQuery += " AND ARQ.CT1_CONTA	= CT7_CONTA "
			cQuery += " AND CT7_MOEDA = '"+cMoeda+"' "
			cQuery += " AND CT7_TPSALD = '"+cTpSaldo+"' "
			cQuery += " AND CT7_DATA BETWEEN '"+DTOS(aMeses[nColunas][2])+"' AND '"+DTOS(aMeses[nColunas][3])+"' "
			If lImpAntLP .and. dDataLP >= aMeses[nColunas][2]
				cQuery += " AND CT7_LP <> 'Z' "
			Endif
			cQuery += " 	AND CT7.D_E_L_E_T_ <> '*') <> 0 "
			If nColunas <> Len(aMeses)
				cQuery += " 	OR "
			EndIf
		Next
		cQuery += " ) "
	EndIf
Endif
cQuery := ChangeQuery(cQuery)		   

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif	

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)
If lMeses
	For nColunas := 1 to Len(aMeses)
		TcSetField("TRBTMP","COLUNA"+Str(nColunas,Iif(nColunas>9,2,1)),"N",aTamVlr[1],aTamVlr[2])
	Next                                                                                           
	If CtbExDtFim("CT1") 
		TcSetField("TRBTMP","CT1DTEXSF","D",8,0)	
	EndIf
EndIf


RestArea(aSaveArea)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SupCompCt7 ³Autor  ³ Simone Mie Sato       ³ Data ³ 12.06.03 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gravacao das contas superiores nos comparativos.(TOP CONNECT)			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³SupCompCT7()                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oMeter	= Objeto oMeter                     	               		 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function SupCompCt7(oMeter,lMeses,aMeses,cMoeda,cTpVlr)

Local nTotVezes		:= 0                     
Local nVezes		:= 0
Local nReg			:= 0
Local cContaSup		:= ""               
Local cDesc			:= ""
Local aMovimento	:= {}
Local nMeter		:= 0
Local aTamVlr	:= TAMSX3("CT7_DEBITO")

If lMeses	//Se for Comparativo por Mes
	nTotVezes := Len(aMeses)
EndIf

// Grava contas sinteticas
dbSelectArea("cArqTmp")	
If ValType(oMeter) == "O"
	oMeter:SetTotal(cArqTmp->(RecCount()))
	oMeter:Set(0)
EndIf
dbGoTop()  

While!Eof()          
	If ValType(oMeter) == "O"
		nMeter++
   		oMeter:Set(nMeter)
  	EndIf

	nReg	:= Recno()   
	cContaSup := cArqTmp->CTASUP
	// Grava contas sinteticas		
	If Empty(cArqTmp->CTASUP)
		dbSelectArea("cArqTmp")
		Replace NIVEL1 With .T.
	EndIf		       

	For nVezes := 1 to nTotVezes	
		AADD(aMovimento,&("COLUNA"+Alltrim(Str(nVezes,2))))
	Next
	
	dbSelectArea("CT1")
	dbSetOrder(1)
	MsSeek(xFilial()+cContaSup)
		
	While !Eof() .And. CT1->CT1_FILIAL == xFilial()

		cDesc := &("CT1->CT1_DESC"+cMoeda)
		If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
			cDesc := CT1->CT1_DESC01
		Endif
	
		dbSelectArea("cArqTmp")
		dbSetOrder(1)
		If !MsSeek(cContaSup)
			dbAppend()
			Replace CONTA		With cContaSup
			Replace DESCCTA		With cDesc
			Replace TIPOCONTA	With CT1->CT1_CLASSE
			Replace CTARES    	With CT1->CT1_RES
			Replace NORMAL   	With CT1->CT1_NORMAL
			Replace GRUPO		With CT1->CT1_GRUPO
			Replace CTASUP		With CT1->CT1_CTASUP
		Else
			
		EndIf      
		                         
		For nVezes := 1 to nTotVezes
			If cTpVlr == 'M'         				 									
				Replace &("COLUNA"+	Alltrim(Str(nVezes,2))) With (&("COLUNA"+Alltrim(Str(nVezes,2)))+aMovimento[nVezes])								
			EndIf
	   	Next
			
		dbSelectArea("CT1")
		cContaSup := CT1->CT1_CTASUP
		If Empty(CT1->CT1_CTASUP)
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea("CT1")
			Exit                            
		EndIf		
		MsSeek(xFilial()+cContaSup)
	EndDo  		
	aMovimento	:= {}    	
	dbSelectArea("cArqTmp")
	dbGoTo(nReg)
	dbSkip()
EndDo	
                   
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³SupCompEnt  Autor ³ Simone Mie Sato       ³ Data ³ 09.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Balancetes Entidade1/Entidade2³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oMeter                                      ³±±
±±³          ³ ExpO2 = Objeto oText                                       ³±±
±±³          ³ ExpO3 = Objeto oDlg                                        ³±±
±±³          ³ ExpL1 = lEnd                                               ³±±
±±³          ³ ExpD1 = Data Inicial                                       ³±±
±±³          ³ ExpD2 = Data Final                                         ³±±
±±³          ³ ExpC1 = Conta Inicial                                      ³±±
±±³          ³ ExpC2 = Conta Final                                        ³±±
±±³          ³ ExpC3 = Classe de Valor Inicial                            ³±±
±±³          ³ ExpC4 = Classe de Valor Final                              ³±±
±±³          ³ ExpC5 = Moeda		                                      ³±±
±±³          ³ ExpC6 = Saldo	                                          ³±±
±±³          ³ ExpA1 = Set Of Book	                                      ³±±
±±³          ³ ExpN1 = Tamanho da descricao da conta	                  ³±±
±±³          ³ ExpC7 = Ate qual segmento sera impresso (nivel)			  ³±±
±±³          ³ ExpC8 = Filtra por Segmento		                          ³±±
±±³          ³ ExpC9 = Segmento Inicial		                              ³±±
±±³          ³ ExpC10= Segmento Final  		                              ³±±
±±³          ³ ExpC11= Segmento Contido em  	                          ³±±
±±³          ³ ExpL12= Se imprime total acumulado	                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                      
Function SupCompEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cAlias,lCusto,lItem,lClvl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,;
				cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado,lEntid,aEntid)
				         
Local aSaveArea 	:= GetArea()
Local cMascara1 	:= ""
Local cMascara2		:= ""
Local nPos			:= 0
Local nDigitos		:= 0
Local cEntid1		:= ""	//Codigo da Entidade Principal
Local cEntid2   	:= "" 	//Codigo da Entidade do Corpo do Relatorio              
local nSaldoAnt 	:= 0
Local nSaldoDeb 	:= 0
Local nSaldoCrd 	:= 0
Local nSaldoAtu 	:= 0
Local nSaldoAntD	:= 0
Local nSaldoAntC	:= 0
Local nSaldoAtuD	:= 0
Local nSaldoAtuC	:= 0
Local nRegTmp   	:= 0
Local nOrder		:= 0
Local cChave		:= ""
Local bCond1		:= {||.F.}
Local bCond2		:= {||.F.}
Local cCadAlias1	:= ""	//Alias do Cadastro da Entidade Principal
Local cCadAlias2	:= ""	//Alias do Cadastro da Entidade que sera impressa no corpo.
Local cCodEnt1		:= ""	//Codigo da Entidade Principal
Local cCodEnt2		:= ""	//Codigo da Entidade que sera impressa no corpo do relat.
Local cDesc1		:= ""
Local cDesc2		:= ""
Local cDescEnt		:= ""
Local cDescEnt1		:= ""	//Descricao da Entidade Principal                           
Local cDescEnt2		:= ""	//Descricao da Entidade que sera impressa no corpo.                          
Local cCodSup1		:= ""	//Cod.Superior da Entidade Principal
Local cCodSup2		:= ""	//Cod.Superior da Entidade que sera impressa no corpo.
Local nRecno1		:= ""
Local nRecno2		:= ""
Local cEntidSup		:= ""
Local nTamDesc1		:= ""
Local nTamDesc2		:= ""
Local cOrigem		:= ""
Local cMensagem		:= OemToAnsi(STR0016)+ OemToAnsi(STR0017)
Local dMinData	                                      
Local nTotVezes		:= 0
Local aMovimento	:= {0,0,0,0,0,0}
Local nMeter		:= 0
Local nVezes		:= 1 

DEFAULT lEntid 		:= .F.
DEFAULT aEntid		:= {}

lFiliais			:= Iif(lFiliais == Nil,.F.,lFiliais)
aFiliais			:= Iif(aFiliais==Nil,{},aFiliais)	
lMeses				:= Iif(lMeses == NIl, .F.,lMeses)
aMeses				:= Iif(aMeses==Nil,{},aMeses)
nDivide 			:= Iif(nDivide == Nil,1,nDivide)
lVlrZerado			:= Iif(lVlrZerado == Nil,.T.,lVlrZerado)

If lFiliais	//Se for Comparativo por Filiais
	nTotVezes := Len(aFiliais)		
Else
	If lMeses	//Se for Comparativo por Mes
		nTotVezes := Len(aMeses)
	Else 
		If lEntid	//// se for comparativo x 6 entidades (em parâmetro)
			nTotVezes := Len(aEntid)
		Endif
	EndIf
Endif

Do Case                  
Case cAlias == 'CT3'
	If cHeader == 'CTT'
//nOrder 		:= 2
		cCadAlias1	:= 'CTT'
		cCadAlias2	:= 'CT1'
		cCodEnt1	:= 'CUSTO' 
		cCodEnt2	:=	'CONTA'
		cCodSup1	:= 'CCSUP'
		cCodSup2	:= 'CTASUP'		
		cMascara1	:= aSetOfBook[6]	//Mascara do Centro de Custo
		cMascara2	:= aSetOfBook[5]	//Mascara do Item
		nTamDesc1	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CT1->CT1_DESC"+cMoeda))		
		cDescEnt	:= "DESCCC"		
	EndIf
Case cAlias == 'CTV'     
	cOrigem		:= 'CT4'	
	If cHeader == 'CTT'		//Se for C.Custo/Item
		nOrder 		:= 2
		cCadAlias1	:= 'CTT'
		cCadAlias2	:= 'CTD'
		cCodEnt1	:= 'CUSTO' 
		cCodEnt2	:=	'ITEM'
		cCodSup1	:= 'CCSUP'
		cCodSup2	:= 'ITSUP'		
		cMascara1	:= aSetOfBook[6]	//Mascara do Centro de Custo
		cMascara2	:= aSetOfBook[7]	//Mascara do Item
		nTamDesc1	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))		
		cDescEnt	:= "DESCCC"
		
	ElseIf cHeader == 'CTD' 	//Se for Item/C.Custo                              	
		nOrder 		:= 1	
		cCadAlias1	:= 'CTD'
		cCadAlias2	:= 'CTT'
		cCodEnt1	:= 'ITEM' 
		cCodEnt2	:= 'CUSTO'
		cCodSup1	:= 'ITSUP'
		cCodSup2	:= 'CCSUP'
		cMascara1	:= aSetOfBook[7]	//Mascara do Item	
		cMascara2	:= aSetOfBook[6]	//Mascara do Centro de Custo
		nTamDesc1	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))	
		cDescEnt	:= "DESCITEM"
	EndIf	
Case cAlias == 'CTW'	
	cOrigem		:= 'CTI'	
	If cHeader == 'CTH'//Se for Cl.Valor/C.Custo
		nOrder 		:= 1      
		cCadAlias1	:= 'CTH'	
		cCadAlias2	:= 'CTT'
		cCodEnt1	:= 'CLVL'  
		cCodEnt2	:= 'CUSTO'
		cCodSup1	:= 'CLSUP'
		cCodSup2	:= 'CCSUP'
		cMascara1	:= aSetOfBook[8]	//Mascara da Classe de Valor
		cMascara2	:= aSetOfBook[6]	//Mascara do Centro de Custo
		nTamDesc1	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))				
		cDescEnt	:= "DESCCLVL"		
	ElseIf cHeader == 'CTT'//Se for C.Custo/Cl.Valor
		nOrder 		:= 2      
		cCadAlias1	:= 'CTT'
		cCadAlias2	:= 'CTH'			
		cCodEnt1	:= 'CUSTO'  
		cCodEnt2	:= 'CLVL'
		cCodSup1  	:= 'CCSUP'
		cCodSup2	:= 'CLSUP'
		cMascara1	:= aSetOfBook[6]	//Mascara do Centro de Custo
		cMascara2	:= aSetOfBook[8]	//Mascara da Classe de Valor	
		nTamDesc1	:=	Len(CriaVar("CTT->CTT_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))		
		cDescEnt	:= "DESCCC"		
	EndIf
Case cAlias == 'CTX'   
	cOrigem		:= 'CTI'	 
	If cHeader == 'CTH'//Se for Cl.Valor/Item
		nOrder 		:= 2      
		cCadAlias1	:= 'CTH'
		cCadAlias2	:= 'CTD'
		cCodEnt1	:= 'CLVL'
		cCodEnt2	:= 'ITEM'
		cCodSup1	:= 'CLSUP'      
		cCodSup2	:= 'ITSUP'
		cMascara1	:= aSetOfBook[8]	//Mascara da Cl.Valor
		cMascara2	:= aSetOfBook[7]	//Mascara do Item Contab.
		nTamDesc1	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))				
		cDescEnt	:= "DESCCLVL"		
	ElseIf cHeader == 'CTD'//Se for Item/Cl.Valor
		nOrder		:= 1
		cCadAlias1	:= 'CTD'
		cCadAlias2	:= 'CTH'
		cCodEnt1	:=	'ITEM'
		cCodEnt2	:=	'CLVL'
		cCodSup1  	:=	'ITSUP'
		cCodSup2	:=	'CLSUP'
		cMascara1	:= aSetOfBook[7]	//Mascara do Item Contab.
		cMascara2	:= aSetOfBook[8]	//Mascara da Cl.Valor
		nTamDesc1	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))				
		cDescEnt	:= "DESCITEM"		
	EndIf

Case cAlias == 'CTD'     //// CASO SEJA INVERTIDO O cHeader x cAlias
	cOrigem		:= 'CT4'	

	If cHeader == 'CTV'		//Se for C.Custo/Item
		cInd	:= "ITEM+CUSTO"
		cCadAlias1	:= 'CTT'
		cCadAlias2	:= 'CTD'
		cCodEnt1	:= 'CUSTO'
		cCodEnt2	:= 'ITEM' 
		cCodSup1	:= 'CCSUP'
		cCodSup2	:= 'ITSUP'
		cMascara1	:= aSetOfBook[6]	//Mascara do Centro de Custo
		cMascara2	:= aSetOfBook[7]	//Mascara do Item	
		nTamDesc1	:= Len(CriaVar("CTT->CTT_DESC"+cMoeda))	
		nTamDesc2	:= Len(CriaVar("CTD->CTD_DESC"+cMoeda))
		cDescEnt	:= "DESCCC"
	ElseIf cHeader == 'CTX' 	//Se for Item x Classe de Valor                              	
		cInd	:= "ITEM+CLVL"
		cCadAlias1	:= 'CTH'
		cCadAlias2	:= 'CTD'
		cCodEnt1	:= 'CLVL'
		cCodEnt2	:= 'ITEM'
		cCodSup1	:= 'CLSUP'      
		cCodSup2	:= 'ITSUP'
		cMascara1	:= aSetOfBook[8]	//Mascara da Cl.Valor
		cMascara2	:= aSetOfBook[7]	//Mascara do Item Contab.
		nTamDesc1	:=	Len(CriaVar("CTH->CTH_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTD->CTD_DESC"+cMoeda))				
		cDescEnt	:= "DESCCLVL"		
	EndIf

	/*
	dbSelectArea("cArqTMP")
	aAreaTMP := GetArea()
                                          
	cArqTrb3:= CriaTrab(NIL,.F.)
	IndRegua("cArqTMP",cArqTrb3,cInd,,,OemToAnsi(STR0001)) //"Selecionando Registros..."
	dbSelectArea("cArqTMP")
	dbSetIndex(cArqTrb3+OrdBagExt())	
	nOrder 		:= RetIndex("cArqTMP") + 1

	dbSetOrder(nOrder)	     	

	dbSelectArea("cArqTMP")
	RestArea(aAreaTMP)*/

EndCase

cChave 		:= xFilial(cAlias)+cMoeda+cSaldos+cEntidIni1+cEntidIni2+dtos(dDataIni)
//bCond		:= {||&(cAlias+"->"+cAlias+"_FILIAL") == xFilial(cAlias) .And.	&(cAlias+"->"+cAlias+"_"+cCodEnt1) >= cEntidIni1 .And. &(cAlias+"->"+cAlias+"_"+cCodEnt1) <= cEntidFim1 }
bCond1		:= {||&(cCadAlias1+"->"+cCadAlias1+"_FILIAL") == xFilial(cCadAlias1) .And. &(cCadAlias1+"->"+cCadAlias1+"_"+cCodEnt1) >= cEntidIni1 .And. &(cCadAlias1+"->"+cCadAlias1+"_"+cCodEnt1) <= cEntidFim1 }
bCond2		:= {||&(cCadAlias2+"->"+cCadAlias2+"_FILIAL") == xFilial(cCadAlias2) .And. &(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2) >= cEntidIni2 .And. &(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2) <= cEntidFim2 }

/*
//Verificar se tem algum saldo a ser atualizado
Ct360Data(cOrigem,,@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt)

//Se o parametro MV_SLDCOMP estiver com "S",isto e, se devera atualizar os saldos compost.
//na emissao dos relatorios, verifica se tem algum registro desatualizado e atualiza as
//tabelas de saldos compostos.

If lAtSldCmp .And. !Empty(dMinData)	//Se atualiza saldos compostos
	oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cSaldos,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt)},"","",.F.)
	oProcess:Activate()	
Else		//Se nao atualiza os saldos compostos, somente da mensagem
	If !Empty(dMinData)
		MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
		Return							//atraves da rotina de saldos compostos	
	EndIf    
EndIf
*/
// Grava sinteticas
dbSelectArea("cArqTmp")	
If ValType(oMeter) == "O"
	oMeter:SetTotal(cArqTmp->(RecCount()))
	oMeter:Set(0)
EndIf
dbGoTop()  

While!Eof()                                                                         
	If ValType(oMeter) == "O"
		nMeter++
   		oMeter:Set(nMeter)
  	EndIf

	nRegTmp := Recno()      
	aMovimento	:= {}
	For nVezes	:= 1 to nTotVezes
		Aadd(aMovimento, 0)               				
	Next
	
	For nVezes := 1 to nTotVezes
		aMovimento[nVezes] := &("COLUNA"+Alltrim(Str(nVezes,2)))	     
	Next
	
	dbSelectArea(cCadAlias2)
	dbSetOrder(1)      
	If Empty(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodSup2))
		dbSelectArea("cArqTmp")
		Replace NIVEL1 With .T.
		dbSelectArea(cCadAlias2)
	EndIf		
	MsSeek(xFilial(cCadAlias2)+ &("cArqTmp->"+cCodSup2))
		
	While !Eof() .And. &(cCadAlias2+"->"+cCadAlias2+"_FILIAL") == xFilial()

		cEntid1	 := &("cArqTmp->"+cCodEnt1)
		cDesc1	 := &("cArqTmp->"+cDescEnt)
		cEntSup2 := &(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2)
								
		cDescEnt2	:= (cCadAlias2+"->"+cCadAlias2+"_DESC")
		cDesc2		:= &(cDescEnt2+cMoeda)			        
		If Empty(cDesc2)	// Caso nao preencher descricao da moeda selecionada		
			cDesc2	:= &(cDescEnt2+"01")
		Endif

		If lEntid									/// SE FOR ENTIDADE X 6 CODIGOS DE ENTIDADE
			cSeek 		:= cEntSup2//cEntid1		/// PROCURA SOMENTE A ENTIDADE SUPERIOR POIS PODE NÃO ESTAR AMARRADO A 1ª ENTIDADE
		Else
			cSeek 		:= cEntid1+cEntSup2
		Endif
		
		dbSelectArea(cCadAlias1)
		dbSetOrder(1)
		MsSeek(xFilial(cCadAlias1)+cEntid1)
		
		dbSelectArea("cArqTmp")
		dbSetOrder(1)      
		If !MsSeek(cSeek)
			RecLock("cArqTmp",.T.)
			Do Case
			Case cAlias == 'CT3'
				If cHeader == 'CTT'
					Replace CUSTO   	With cEntid1
					Replace DESCCC		With cDesc1
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES	
					Replace CONTA		With cEntSup2
					Replace DESCCTA 	With cDesc2
					Replace TIPOCONTA	With CT1->CT1_CLASSE
					Replace CTASUP 		With CT1->CT1_CTASUP	
					Replace CTARES 		With CT1->CT1_RES				
				EndIf
			Case cAlias == 'CTV'      
				If cHeader	== 'CTT'	//Se for Centro de Custo/Item
					Replace CUSTO   	With cEntid1
					Replace DESCCC		With cDesc1
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES	
					Replace ITEM 		With cEntSup2
					Replace DESCITEM	With cDesc2
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES			
				ElseIf cHeader == 'CTD'	//Se for Item/C.Custo
					Replace ITEM 		With cEntid1
					Replace DESCITEM	With cDesc1
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES					
					Replace CUSTO   	With cEntSup2
					Replace DESCCC		With cDesc2
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES	
				EndIf			
			Case cAlias == 'CTW'
				If cHeader	== 'CTH'		//Se for Cl.Valor/C.Custo
					Replace CLVL    	With cEntid1
					Replace DESCCLVL	With cDesc1
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES
					Replace CUSTO   	With cEntSup2
					Replace DESCCC		With cDesc2
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES				                        	
				ElseIf cHeader	== 'CTT'	//Se for C.Custo/Cl.Valor
					Replace CUSTO   	With cEntid1
					Replace DESCCC		With cDesc1
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES				                        	
					Replace CLVL    	With cEntSup2
					Replace DESCCLVL	With cDesc2
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES			
				EndIf
			Case cAlias == 'CTX'                   
				If cHeader == 'CTH'	//Se for Cl.Valor/Item
					Replace CLVL    	With cEntid1 
					Replace DESCCLVL	With cDesc1
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES
					Replace ITEM		With cEntSup2
					Replace DESCITEM	With cDesc2
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES					
				ElseIf cHeader	== 'CTD'	//Se for Item/Cl.Valor
					Replace ITEM		With cEntid1
					Replace DESCITEM	With cDesc1
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES					
					Replace CLVL    	With cEntSup2
					Replace DESCCLVL	With cDesc2
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES			
				Endif
				
			Case cAlias == 'CTD'		/// Se for cHeader x cAlias invertido
				If cHeader	== 'CTV'		//Se for Item x C.Custo
					Replace CUSTO   	With cEntid1
					Replace DESCCC		With cDesc1
					Replace TIPOCC 		With CTT->CTT_CLASSE			
					Replace CCSUP 		With CTT->CTT_CCSUP	
					Replace CCRES		With CTT->CTT_RES	
					Replace ITEM 		With cEntSup2
					Replace DESCITEM	With cDesc2
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES			
				ElseIf cHeader	== 'CTX'	//Se for ITEM X Cl.Valor
					Replace CLVL    	With cEntid1 
					Replace DESCCLVL	With cDesc1
					Replace TIPOCLVL 	With CTH->CTH_CLASSE
					Replace CLSUP    	With CTH->CTH_CLSUP
					Replace CLVLRES		With CTH->CTH_RES
					Replace ITEM		With cEntSup2
					Replace DESCITEM	With cDesc2
					Replace TIPOITEM 	With CTD->CTD_CLASSE
					Replace ITSUP  		With CTD->CTD_ITSUP		
					Replace ITEMRES		With CTD->CTD_RES					
				EndIf
			EndCase
		Else
			RecLock("cArqTmp",.F.)
		EndIf    
		
		For nVezes := 1 to nTotVezes
			If cTpVlr == 'M'
				Replace &("COLUNA"+	Alltrim(Str(nVezes,2))) With (&("COLUNA"+Alltrim(Str(nVezes,2)))+aMovimento[nVezes])
			EndIf
    	Next
		
		dbSelectArea(cCadAlias2)
		If Empty(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodSup2))
			dbSelectArea("cArqTmp")
			Replace NIVEL1 With .T.
			dbSelectArea(cCadAlias2)
			Exit                     						
		EndIf		

		dbSelectArea(cCadAlias2)
		MsSeek(xFilial(cCadAlias2)+ &("cArqTmp->"+cCodSup2))
	EndDo
	dbSelectArea("cArqTmp")
	dbGoto(nRegTmp)
	dbSkip()
EndDo
RestArea(aSaveArea)

Return				


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT7CmpQry ºAutor  ³Marcos S. Lobo      º Data ³  06/16/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o Alias TRBTMP através de query com a composição de º±±
±±º          ³saldos por conta                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CT7CmpQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,;
					cMoeda,cTpSld1,cTpSld2,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					cSegAte,lVariacao0,nDivide,nGrupo,bVariacao,cIdent,lCt1Sint,cString,cFILUSU)

Local cQuery		:= ""
Local aAreaQry		:= {}		/// array com a posição no arquivo original
Local aTamVlr		:= TAMSX3("CT7_DEBITO")
Local nStr			:= 1

DEFAULT lVariacao0	:= .F.

aAreaQry := GetArea()

	cQuery := " 	 SELECT CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, CT1_DESC"+cMoeda+" DESCCTA, "
	cQuery += "   	 	CT1_CLASSE TIPOCONTA, CT1_GRUPO GRUPO,                                                 "

////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cFILUSU)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := (cString)->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////

	cQuery += " 		(SELECT SUM(CT7_CREDIT) - SUM(CT7_DEBITO) "
	cQuery += "  			 	FROM "+RetSqlName("CT7")+" CT7                                                 "
	cQuery += "   			WHERE CT7_FILIAL = '"+xFilial("CT7")+"'											   " 	
	If cTpSld1 == cTpSld2					/// Compatibilização com CTBR380 CodeBase (Se saldo1 = saldo 2 então é comparativo de moedas)
		cQuery += "    			AND CT7_DATA <= '"+DTOS(dDataFim)+"' "
	Else
		cQuery += "    			AND CT7_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
	Endif

	cQuery += "   			AND CT7_CONTA	= CT1_CONTA                                                        "
	If cTpSld1 == cTpSld2					/// Compatibilização com CTBR380 CodeBase (Se saldo1 = saldo 2 então é comparativo de moedas)
		cQuery += "   			AND CT7_MOEDA = '01' "    	
	Else
		cQuery += "   			AND CT7_MOEDA = '"+cMoeda+"' "
	Endif
	cQuery += "  			AND CT7_TPSALD = '"+cTpSld1+"'                                                               "
	cQuery += "   			AND CT7.D_E_L_E_T_ = '') MOVIMENTO1,                                    	       "

	cQuery += " 		(SELECT SUM(CT7_CREDIT) - SUM(CT7_DEBITO) "
	cQuery += "   			FROM "+RetSqlName("CT7")+" CT7                                                     "
	cQuery += "   			WHERE CT7_FILIAL	= '"+xFilial("CT7")+"'                                         "
	If cTpSld1 == cTpSld2					/// Compatibilização com CTBR380 CodeBase (Se saldo1 = saldo 2 então é comparativo de moedas)
		cQuery += "    			AND CT7_DATA <= '"+DTOS(dDataFim)+"' "
	Else
		cQuery += "    			AND CT7_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
	Endif
	cQuery += "   			AND CT7_CONTA	= CT1_CONTA                                                        "
	cQuery += "   			AND CT7_MOEDA = '"+cMoeda+"'                                                       "
	cQuery += "   			AND CT7_TPSALD = '"+cTpSld2+"'                                                     "
	cQuery += "   			AND CT7.D_E_L_E_T_ = '') MOVIMENTO2                                 	           "
	cQuery += "   	FROM "+RetSqlName("CT1")+" ARQ                                                             "
	cQuery += "   	WHERE ARQ.CT1_FILIAL = '"+xFilial("CT1")+"'                                                "
	cQuery += "   	AND ARQ.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"'				               "
	cQuery += "   	AND ARQ.CT1_CLASSE = '2'                                                                   "

	If !Empty(aSetOfBook[1])
		cQuery += "   	AND ARQ.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "
	Endif
	
	cQuery += "   	AND ARQ.D_E_L_E_T_ = ''                                                                    "

	If !lVariacao0
		cQuery += "   	AND ((SELECT SUM(CT7_CREDIT) - SUM(CT7_DEBITO)                                           "
		cQuery += " 			 	FROM "+RetSqlName("CT7")+" CT7                                                 "
		cQuery += "   			 	WHERE CT7_FILIAL = '"+xFilial("CT7")+"'                                        "
		If cTpSld1 == cTpSld2					/// Compatibilização com CTBR380 CodeBase (Se saldo1 = saldo 2 então é comparativo de moedas)
			cQuery += "    			AND CT7_DATA <= '"+DTOS(dDataFim)+"' "
		Else
			cQuery += " 			 	AND CT7_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"'             "
		Endif
		cQuery += "   			 	AND CT7_CONTA	= CT1_CONTA                                                    "
		cQuery += " 				AND CT7_MOEDA = '"+cMoeda+"'                                                   "
		cQuery += "   			 	AND CT7_TPSALD =  '"+cTpSld1+"'  	                                           "
		cQuery += " 				AND CT7.D_E_L_E_T_ = '') <> 0                                                  "
		cQuery += "   	OR  	(SELECT SUM(CT7_CREDIT) - SUM(CT7_DEBITO)                                          "
		cQuery += "  			 	FROM "+RetSqlName("CT7")+" CT7                                                 "
		cQuery += "   			 	WHERE CT7_FILIAL = '"+xFilial("CT7")+"'                                        "
		If cTpSld1 == cTpSld2					/// Compatibilização com CTBR380 CodeBase (Se saldo1 = saldo 2 então é comparativo de moedas)
			cQuery += "    			AND CT7_DATA <= '"+DTOS(dDataFim)+"' "
		Else
			cQuery += "  				AND CT7_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"'             "
		Endif
		cQuery += " 			 	AND CT7_CONTA	= CT1_CONTA                                                    "
		cQuery += " 			  	AND CT7_MOEDA = '"+cMoeda+"'                                                   "
		cQuery += " 			 	AND CT7_TPSALD = '"+cTpSld2+"'                                                 "
		cQuery += " 			  	AND CT7.D_E_L_E_T_ = '') <> 0 )                                                "
	Endif

	cQuery := ChangeQuery(cQuery)

	If Select("TRBTMP") > 0
		dbSelectArea("TRBTMP")
		dbCloseArea()
	Endif
	
  	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)
  	TcSetField("TRBTMP","MOVIMENTO1","N",aTamVlr[1],aTamVlr[2])
  	TcSetField("TRBTMP","MOVIMENTO2","N",aTamVlr[1],aTamVlr[2])
  	

RestArea(aAreaQry)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT3CmpQry ºAutor  ³Marcos S. Lobo      º Data ³  06/16/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna alias TRBTMP com a composição dos saldos C.Custo x  º±±
±±º          ³Conta Contabil                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CT3CmpQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,;
					cMoeda,cTpSld1,cTpSld2,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					cSegAte,lVariacao0,nDivide,nGrupo,bVariacao,cIdent,lCt1Sint,cString,cFILUSU)

Local cQuery		:= ""
Local aAreaQry		:= {}		/// array com a posição no arquivo original
Local aTamVlr	:= TAMSX3("CT7_DEBITO")
Local nStr			:= 1

DEFAULT lVariacao0	:= .F.

aAreaQry := GetArea()

	cQuery := " SELECT CTT_CUSTO CUSTO,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, CT1_DESC"+cMoeda+" DESCCTA,  	"	
	cQuery += " 	CTT_RES CCRES, CTT_DESC"+cMoeda+" DESCCC, CT1_CLASSE TIPOCONTA,CTT_CLASSE TIPOCC,  	"
	cQuery += " 	CTT_CCSUP CCSUP, CT1_GRUPO GRUPO,"
	////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cFILUSU)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := (cString)->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////
	
	cQuery += " 	(SELECT SUM(CT3_CREDIT) - SUM(CT3_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND CT3_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
	cQuery += " 			AND ARQ.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSld1+"' "
	cQuery += "    			AND ARQ2.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') MOVIMENTO1, "
	cQuery += " 		(SELECT SUM(CT3_CREDIT) - SUM(CT3_DEBITO) "
	cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
	cQuery += " 			AND CT3_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
	cQuery += " 			AND ARQ.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSld2+"' "
	cQuery += " 			AND ARQ2.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') MOVIMENTO2 "
	cQuery += " 	FROM "+RetSqlName("CTT")+" ARQ, "+RetSqlName("CT1")+" ARQ2 "
	cQuery += " 	WHERE ARQ.CTT_FILIAL = '"+xFilial("CTT")+"' "
	cQuery += " 	AND ARQ.CTT_CUSTO BETWEEN '"+cCCIni+"' AND '"+cCCFim+"' "
	cQuery += " 	AND ARQ.CTT_CLASSE = '2' "
	
	If !Empty(aSetOfBook[1])										//// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
		cQuery += " 	AND ARQ.CTT_BOOK LIKE '%"+aSetOfBook[1]+"%' "    //// FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
	Endif
	
	cQuery += " 	AND ARQ2.CT1_FILIAL = '"+xFilial("CT1")+"' "
	cQuery += " 	AND ARQ2.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
	cQuery += " 	AND ARQ2.CT1_CLASSE = '2' "    

	If !Empty(aSetOfBook[1])										//// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
		cQuery += " 	AND ARQ2.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "    //// FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
	Endif

	cQuery += " 	AND ARQ.D_E_L_E_T_ = '' "
	cQuery += " 	AND ARQ2.D_E_L_E_T_ = '' "
 
	If !lVariacao0
		cQuery += " 	AND ( (SELECT SUM(CT3_CREDIT) - SUM(CT3_DEBITO)			"
		cQuery += " 	FROM "+RetSqlName("CT3")+" CT3  			"
		cQuery += " 	WHERE CT3_FILIAL = '"+xFilial("CT3")+"'"
		cQuery += " 	AND CT3_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
		cQuery += " 	AND ARQ.CTT_CUSTO	= CT3_CUSTO  			"
		cQuery += " 	AND CT3_MOEDA = '"+cMoeda+"' "
		cQuery += " 	AND CT3_TPSALD =  '"+cTpSld1+"' "
		cQuery += " 	AND ARQ2.CT1_CONTA	= CT3_CONTA  			"
		cQuery += " 	AND CT3.D_E_L_E_T_ = '') <> 0 "
		cQuery += " 	OR "
		cQuery += " 	(SELECT SUM(CT3_CREDIT) - SUM(CT3_DEBITO) 			"
		cQuery += " 	FROM "+RetSqlName("CT3")+" CT3  			"
		cQuery += " 	WHERE CT3_FILIAL = '"+xFilial("CT3")+"'"			
		cQuery += " 	AND CT3_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
		cQuery += " 	AND ARQ.CTT_CUSTO	= CT3_CUSTO  			"
		cQuery += " 	AND CT3_MOEDA = '"+cMoeda+"' "
		cQuery += " 	AND CT3_TPSALD = '"+cTpSld2+"' "
		cQuery += " 	AND ARQ2.CT1_CONTA	= CT3_CONTA  			"
		cQuery += " 	AND CT3.D_E_L_E_T_ = '') <> 0  )"
	Endif
	
	cQuery := ChangeQuery(cQuery)		   

	If Select("TRBTMP") > 0
		dbSelectArea("TRBTMP")
		dbCloseArea()
	Endif
	
  	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)
  	TcSetField("TRBTMP","MOVIMENTO1","N",aTamVlr[1],aTamVlr[2])
  	TcSetField("TRBTMP","MOVIMENTO2","N",aTamVlr[1],aTamVlr[2])  	

RestArea(aAreaQry)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTVCompQryºAutor  ³Marcos S. Lobo      º Data ³  06/16/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Obtem o saldo dos C.Custo x Item Contabil retornando um     º±±
±±º          ³alias TRBTMP executado com a query                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CTVCompQry(dDataIni,dDataFim,cCCIni,cCCFim,cItemIni,cItemFim,cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,lMeses,aMeses,lVlrZerado,lEntid,aEntid,cHeader,cString,cFILUSU)

Local cQuery		:= ""
Local aAreaQry		:= {}		/// array com a posição no arquivo original
Local aTamVlr		:= TAMSX3("CT7_DEBITO")
Local nVezes	    := 0
Local nStr			:= 1
Local nMes			:= 1
Local nColunas		:= 1

DEFAULT lMeses		:= .F.
DEFAULT lVlrZerado	:= .F.
DEFAULT lEntid		:= .F.

aAreaQry := GetArea()   

////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cFILUSU)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := (cString)->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
////////////////////////////////////////////////////////////


If lEntid     
	If cHeader == "CTD"  		
		cQuery := " SELECT CTD_ITEM ITEM, CTD_RES ITEMRES, CTD_DESC"+cMoeda+" DESCITEM, CTD_CLASSE TIPOITEM, CTD_ITSUP ITSUP, "					
		cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
		
		For nVezes := 1 to Len(aEntid)
			cQuery += "(SELECT SUM(CTV_CREDIT) - SUM(CTV_DEBITO) "
			cQuery += "	FROM "+ RetSqlName("CTV") + " CTV "
			cQuery += "	WHERE CTV_FILIAL =  '"+xFilial("CTV")+"' "
			cQuery += "	AND CTV_MOEDA = '"+cMoeda+"' "
			cQuery += "	AND CTV_TPSALD = '"+cSaldos+"' "
			cQuery += "	AND CTV_ITEM = ARQ.CTD_ITEM "
			cQuery += " AND CTV_CUSTO = '"+aEntid[nVezes]+"' " 
			cQuery += " AND CTV_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
			If lImpAntLP .and. dDataLP >= dDataINI
				cQuery += "	AND CTV_LP <> 'Z' "
			Endif
			cQuery += " AND CTV.D_E_L_E_T_ = '') COLUNA"+ALLTRIM(STR(nVezes))
			If nVezes <  Len(aEntid)
				cQuery += ","	
			Endif			
		Next     
		cQuery += " FROM "+RetSqlName("CTD") + " ARQ "
		cQuery += " WHERE ARQ.CTD_FILIAL = '"+xFilial("CTD")+"' "
		cQuery += "	AND ARQ.CTD_ITEM BETWEEN '" +cItemIni+"' AND '"+cItemFim+"' "
		cQuery += "	AND ARQ.CTD_CLASSE = '2' " 	
		
		If !Empty(aSetOfBook[1])
			cQuery += " AND ARQ.CTD_BOOK LIKE '%"+aSetOfBook[1]+"%' "	
		Endif		
		cQuery += "	AND ARQ.D_E_L_E_T_ = '' " 	

		If !lVlrZerado
			If Len(aEntid) > 0
				cQuery += " AND ( "
				For nVezes := 1 to Len(aEntid)
					cQuery += "(SELECT ROUND(SUM(CTV_CREDIT),2) - ROUND(SUM(CTV_DEBITO),2) "
					cQuery += "	FROM "+ RetSqlName("CTV") + " CTV "
					cQuery += "	WHERE CTV_FILIAL =  '"+xFilial("CTV")+"' "
				    
				 	cQuery += "	AND CTV_MOEDA = '"+cMoeda+"' "
					cQuery += "	AND CTV_TPSALD = '"+cSaldos+"' "
					cQuery += "	AND CTV_ITEM = ARQ.CTD_ITEM "
					cQuery += " AND CTV_CUSTO = '"+aEntid[nVezes]+"' " 
					cQuery += " AND CTV_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
					If lImpAntLP .and. dDataLP >= dDataINI
						cQuery += "	AND CTV_LP <> 'Z' "
					Endif
					cQuery += " AND CTV.D_E_L_E_T_ = '') <> 0 "
					If nVezes < Len(aEntid)
						cQuery += " OR "
					Endif
				Next
				cQuery += " ) "
			Endif
		Endif
	EndIf
Else
	If cHeader == "CTT"
		cQuery := " SELECT CTT_CUSTO CUSTO, CTD_ITEM ITEM, CTT_RES CCRES, CTT_DESC"+cMoeda+" DESCCC, CTT_CLASSE TIPOCC, CTT_CCSUP CCSUP, "	
		cQuery += " 	CTD_RES ITEMRES, CTD_DESC"+cMoeda+" DESCITEM, CTD_CLASSE TIPOITEM, CTD_ITSUP ITSUP, "
	
		If CtbExDtFim("CTD") 
			cQuery += " CTD_DTEXSF CTDDTEXSF, "
		EndIf
		
        
		cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY

		If lMeses .and. Len(aMeses) > 0     
			For nMes := 1 to Len(aMeses)
				cQuery += "  	(SELECT SUM(CTV_CREDIT) - SUM(CTV_DEBITO) "
				cQuery += " 		 	FROM "+RetSqlName("CTV")+" CTV "
				cQuery += "   			WHERE CTV_FILIAL = '"+xFilial("CTV")+"' "
				cQuery += "   			AND CTV_MOEDA = '"+cMoeda+"' "
				cQuery += "   			AND CTV_TPSALD = '"+cSaldos+"' "
				cQuery += "  			AND CTV_ITEM = ARQ2.CTD_ITEM "
				cQuery += "   			AND CTV_CUSTO = ARQ.CTT_CUSTO	 "
				cQuery += "    			AND CTV_DATA BETWEEN '"+DTOS(aMeses[nMes,2])+"' AND '"+DTOS(aMeses[nMes,3])+"' "
				If lImpAntLP .and. dDataLP >= aMeses[nMes,2]
					cQuery += "	AND CTV_LP <> 'Z' "
				Endif
				cQuery += "   			AND CTV.D_E_L_E_T_ = '') COLUNA"+ALLTRIM(STR(nMes))
				If nMes < Len(aMeses)
						cQuery += ","	
				Endif
			Next
		Else
			cQuery += "  	(SELECT SUM(CTV_CREDIT) - SUM(CTV_DEBITO) "
			cQuery += " 		 	FROM "+RetSqlName("CTV")+" CTV "
			cQuery += "   			WHERE CTV_FILIAL = '"+xFilial("CTV")+"' "
			cQuery += "   			AND CTV_MOEDA = '"+cMoeda+"' "
			cQuery += "   			AND CTV_TPSALD = '"+cSaldos+"' "
			cQuery += "  			AND CTV_ITEM = ARQ2.CTD_ITEM "
			cQuery += "   			AND CTV_CUSTO = ARQ.CTT_CUSTO	 "
			cQuery += "    			AND CTV_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
			If lImpAntLP .and. dDataLP >= dDataINI
				cQuery += "	AND CTV_LP <> 'Z' "
			Endif	
			cQuery += "   			AND CTV.D_E_L_E_T_ = '') COLUNA1 "
		Endif

		cQuery += " FROM "+RetSqlName("CTT")+" ARQ, "+RetSqlName("CTD")+" ARQ2 "
		cQuery += " WHERE ARQ.CTT_FILIAL = '"+xFilial("CTT")+"'  	"
		cQuery += " AND ARQ.CTT_CUSTO BETWEEN '"+cCCIni+"' AND '"+cCCFim+"' "
		cQuery += " AND ARQ.CTT_CLASSE = '2'  	"

		If !Empty(aSetOfBook[1])
			cQuery += " AND ARQ.CTT_BOOK LIKE '%"+aSetOfBook[1]+"%' 	"
		Endif

		cQuery += " AND ARQ2.CTD_FILIAL = '"+xFilial("CTD")+"'  	"
		cQuery += " AND ARQ2.CTD_ITEM BETWEEN '"+cItemIni+"' AND '"+cItemFim+"'  	"
		cQuery += " AND ARQ2.CTD_CLASSE = '2'  	"

		If !Empty(aSetOfBook[1])
			cQuery += " AND ARQ2.CTD_BOOK LIKE '%"+aSetOfBook[1]+"%' "	
		Endif

		cQuery += " AND ARQ.D_E_L_E_T_ = ''  	"
		cQuery += " AND ARQ2.D_E_L_E_T_ = ''  	"

		If !lVlrZerado
			cQuery += " AND ( "
        
			If lMeses .and. Len(aMeses) > 0
				For nMes := 1 to Len(aMeses)
					cQuery += "  	(SELECT ROUND(SUM(CTV_CREDIT),2) - ROUND(SUM(CTV_DEBITO),2) "
					cQuery += " 		 	FROM "+RetSqlName("CTV")+" CTV "
					cQuery += "   			WHERE CTV_FILIAL = '"+xFilial("CTV")+"' "
					cQuery += "   			AND CTV_MOEDA = '"+cMoeda+"' "
					cQuery += "   			AND CTV_TPSALD = '"+cSaldos+"' "
					cQuery += "  			AND CTV_ITEM = ARQ2.CTD_ITEM "
					cQuery += "   			AND CTV_CUSTO = ARQ.CTT_CUSTO	 "
					cQuery += "    			AND CTV_DATA BETWEEN '"+DTOS(aMeses[nMes,2])+"' AND '"+DTOS(aMeses[nMes,3])+"' "					
					If lImpAntLP .and. dDataLP >= aMeses[nMes,2]
						cQuery += "	AND CTV_LP <> 'Z' "
					Endif	
					cQuery += "   			AND CTV.D_E_L_E_T_ = '') <> 0 "
					If nMes < Len(aMeses)
						cQuery += " OR "
					Endif
				Next
			Else
				cQuery += "  	(SELECT SUM(CTV_CREDIT) - SUM(CTV_DEBITO) "
				cQuery += " 		 	FROM "+RetSqlName("CTV")+" CTV "
				cQuery += "   			WHERE CTV_FILIAL = '"+xFilial("CTV")+"' "
				cQuery += "   			AND CTV_MOEDA = '"+cMoeda+"' "
				cQuery += "   			AND CTV_TPSALD = '"+cSaldos+"' "
				cQuery += "  			AND CTV_ITEM = ARQ2.CTD_ITEM "
				cQuery += "   			AND CTV_CUSTO = ARQ.CTT_CUSTO "
				cQuery += "    			AND CTV_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
				If lImpAntLP .and. dDataLP >= dDataINI
					cQuery += "	AND CTV_LP <> 'Z' "
				Endif	
				cQuery += "   			AND CTV.D_E_L_E_T_ = '') <> 0 "
			Endif
			
			cQuery += " ) "
		Endif
	EndIf

EndIf

cQuery := ChangeQuery(cQuery)	

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif	

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)
If lMeses
	For nColunas := 1 to Len(aMeses)
		TcSetField("TRBTMP","COLUNA"+Str(nColunas,Iif(nColunas>9,2,1)),"N",aTamVlr[1],aTamVlr[2])
	Next 
ElseIf lEntid
	For nColunas := 1 to Len(aEntid)
		TcSetField("TRBTMP","COLUNA"+Str(nColunas,Iif(nColunas>9,2,1)),"N",aTamVlr[1],aTamVlr[2])
	Next 
Else
	TcSetField("TRBTMP","COLUNA1","N",aTamVlr[1],aTamVlr[2])	
EndIf

RestArea(aAreaQry)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTXCompQryºAutor  ³Marcos S. Lobo      º Data ³  06/17/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna Alias TRBTMP com a composicao de Saldos Cl.Valor x  º±±
±±º          ³Item Contabil                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CTXCompQry(dDataIni,dDataFim,cItemIni,cItemFim,cClVlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,lMeses,aMeses,lVlrZerado,lEntid,aEntid,cHeader,cString,cFILUSU)

Local cQuery		:= ""
Local aAreaQry		:= {}		/// array com a posição no arquivo original
Local aTamVlr		:= TAMSX3("CT7_DEBITO")
Local nVezes	    := 0
Local nStr			:= 1
Local nMes 			:= 1		
Local nColunas		:= 1

DEFAULT lMeses		:= .F.
DEFAULT lVlrZerado	:= .F.
DEFAULT lEntid		:= .F.

aAreaQry := GetArea()   

////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cFILUSU)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := (cString)->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
////////////////////////////////////////////////////////////		

If lEntid     //Comparativo por 6 Entidades 
	If cHeader == "CTD"  		
		cQuery := " SELECT CTD_ITEM ITEM, CTD_RES ITEMRES, CTD_DESC"+cMoeda+" DESCITEM, CTD_CLASSE TIPOITEM, CTD_ITSUP ITSUP, "
		cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
	
		For nVezes := 1 to Len(aEntid)
			cQuery += "(SELECT SUM(CTX_CREDIT) - SUM(CTX_DEBITO) "
			cQuery += "	FROM "+ RetSqlName("CTX") + " CTX "
			cQuery += "	WHERE CTX_FILIAL =  '"+xFilial("CTX")+"' "
			cQuery += "	AND CTX_MOEDA = '"+cMoeda+"' "
			cQuery += "	AND CTX_TPSALD = '"+cSaldos+"' "
			cQuery += "	AND CTX_ITEM = ARQ.CTD_ITEM "
			cQuery += " AND CTX_CLVL = '"+aEntid[nVezes]+"' " 
			cQuery += " AND CTX_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "	
			If lImpAntLP .and. dDataLP >= dDataINI
				cQuery += "	AND CTX_LP <> 'Z' "
			Endif	
			cQuery += " AND CTX.D_E_L_E_T_ = '') COLUNA"+ALLTRIM(STR(nVezes))
			If nVezes <  Len(aEntid)
				cQuery += ","	
			Endif			
		Next     
		cQuery += " FROM "+RetSqlName("CTD") + " ARQ "
		cQuery += " WHERE ARQ.CTD_FILIAL = '"+xFilial("CTD")+"' "
		cQuery += "	AND ARQ.CTD_ITEM BETWEEN '" +cItemIni+"' AND '"+cItemFim+"' "
		cQuery += "	AND ARQ.CTD_CLASSE = '2' " 	
		
		If !Empty(aSetOfBook[1])
			cQuery += " AND ARQ.CTD_BOOK LIKE '%"+aSetOfBook[1]+"%' "	
		Endif		
		cQuery += "	AND ARQ.D_E_L_E_T_ = '' " 	

		If !lVlrZerado
			If Len(aEntid) > 0
				cQuery += " AND ( "
				For nVezes := 1 to Len(aEntid)
					cQuery += "(SELECT ROUND(SUM(CTX_CREDIT),2) - ROUND(SUM(CTX_DEBITO),2) "
					cQuery += "	FROM "+ RetSqlName("CTX") + " CTX "
					cQuery += "	WHERE CTX_FILIAL =  '"+xFilial("CTX")+"' "
					cQuery += "	AND CTX_MOEDA = '"+cMoeda+"' "
					cQuery += "	AND CTX_TPSALD = '"+cSaldos+"' "
					cQuery += "	AND CTX_ITEM = ARQ.CTD_ITEM "
					cQuery += " AND CTX_CLVL = '"+aEntid[nVezes]+"' "
					cQuery += " AND CTX_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
					If lImpAntLP .and. dDataLP >= dDataINI
						cQuery += "	AND CTX_LP <> 'Z' "
					Endif	
					cQuery += " AND CTX.D_E_L_E_T_ = '') <> 0 "
					If nVezes < Len(aEntid)
						cQuery += " OR "
					Endif
				Next
				cQuery += " ) "
			Endif
		Endif
	EndIf
Else
	cQuery := " SELECT CTH_CLVL CLVL, CTD_ITEM ITEM, CTH_RES CLVLRES, CTH_DESC"+cMoeda+" DESCCLVL, CTH_CLASSE TIPOCLVL, CTH_CLSUP CLSUP, "
	cQuery += " 	CTD_RES ITEMRES, CTD_DESC"+cMoeda+" DESCITEM, CTD_CLASSE TIPOITEM, CTD_ITSUP ITSUP, "
	cQuery += cCAMPUSU						/// ADICIONA OS CAMPOS DE USUARIO

	If lMeses .and. Len(aMeses) > 0     
		For nMes := 1 to Len(aMeses)
			cQuery += "  	(SELECT SUM(CTX_CREDIT) - SUM(CTX_DEBITO) "
			cQuery += " 		 	FROM "+RetSqlName("CTX")+" CTX "
			cQuery += "   			WHERE CTX_FILIAL = '"+xFilial("CTX")+"' "
			cQuery += "   			AND CTX_MOEDA = '"+cMoeda+"' "
			cQuery += "   			AND CTX_TPSALD = '"+cSaldos+"' "
			cQuery += "  			AND CTX_ITEM = ARQ2.CTD_ITEM "
			cQuery += "   			AND CTX_CLVL = ARQ.CTH_CLVL	 "
			cQuery += "    			AND CTX_DATA BETWEEN '"+DTOS(aMeses[nMes,2])+"' AND '"+DTOS(aMeses[nMes,3])+"' "
			If lImpAntLP .and. dDataLP >= aMeses[nMes,2]
				cQuery += "	AND CTX_LP <> 'Z' "
			Endif	
			cQuery += "   			AND CTX.D_E_L_E_T_ = '') COLUNA"+ALLTRIM(STR(nMes))
			If nMes < Len(aMeses)
				cQuery += ","	
			Endif
		Next
	Else
		cQuery += "  	(SELECT SUM(CTX_CREDIT) - SUM(CTX_DEBITO) "
		cQuery += " 		 	FROM "+RetSqlName("CTX")+" CTX "
		cQuery += "   			WHERE CTX_FILIAL = '"+xFilial("CTX")+"' "
		cQuery += "   			AND CTX_MOEDA = '"+cMoeda+"' "
		cQuery += "   			AND CTX_TPSALD = '"+cSaldos+"' "
		cQuery += "  			AND CTX_ITEM = ARQ2.CTD_ITEM "
		cQuery += "   			AND CTX_CLVL = ARQ.CTH_CLVL	 "
		cQuery += "    			AND CTX_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
		If lImpAntLP .and. dDataLP >= dDataINI
			cQuery += "	AND CTX_LP <> 'Z' "
		Endif	
		cQuery += "   			AND CTX.D_E_L_E_T_ = '') COLUNA1 "
	Endif

	cQuery += " FROM "+RetSqlName("CTH")+" ARQ, "+RetSqlName("CTD")+" ARQ2 "
	cQuery += " WHERE ARQ.CTH_FILIAL = '"+xFilial("CTH")+"'  	"
	cQuery += " AND ARQ.CTH_CLVL BETWEEN '"+cClvlIni+"' AND '"+cCLVlFim+"' "
	cQuery += " AND ARQ.CTH_CLASSE = '2'  	"

	If !Empty(aSetOfBook[1])
		cQuery += " AND ARQ.CTH_BOOK LIKE '%"+aSetOfBook[1]+"%' 	"
	Endif

	cQuery += " AND ARQ2.CTD_FILIAL = '"+xFilial("CTD")+"'  	"
	cQuery += " AND ARQ2.CTD_ITEM BETWEEN '"+cItemIni+"' AND '"+cItemFim+"'  	"
	cQuery += " AND ARQ2.CTD_CLASSE = '2'  	"

	If !Empty(aSetOfBook[1])
		cQuery += " AND ARQ2.CTD_BOOK LIKE '%"+aSetOfBook[1]+"%' "
	Endif

	cQuery += " AND ARQ.D_E_L_E_T_ = ''  	"
	cQuery += " AND ARQ2.D_E_L_E_T_ = ''  	"

	If !lVlrZerado
		cQuery += " AND ( "
        
		If lMeses .and. Len(aMeses) > 0
			For nMes := 1 to Len(aMeses)
				cQuery += "  	(SELECT ROUND(SUM(CTX_CREDIT),2) - ROUND(SUM(CTX_DEBITO),2) "
				cQuery += " 		 	FROM "+RetSqlName("CTX")+" CTX "
				cQuery += "   			WHERE CTX_FILIAL = '"+xFilial("CTX")+"' "
				cQuery += "   			AND CTX_MOEDA = '"+cMoeda+"' "
				cQuery += "   			AND CTX_TPSALD = '"+cSaldos+"' "
				cQuery += "  			AND CTX_ITEM = ARQ2.CTD_ITEM "
				cQuery += "   			AND CTX_CLVL = ARQ.CTH_CLVL	 "		
				cQuery += "    			AND CTX_DATA BETWEEN '"+DTOS(aMeses[nMes,2])+"' AND '"+DTOS(aMeses[nMes,3])+"' "
				If lImpAntLP .and. dDataLP >= aMeses[nMes,2]
					cQuery += "	AND CTX_LP <> 'Z' "
				Endif	
				cQuery += "   			AND CTX.D_E_L_E_T_ = '') <> 0 "
				If nMes < Len(aMeses)
					cQuery += " OR "
				Endif            
			Next
		Else
			cQuery += "  	(SELECT SUM(CTX_CREDIT) - SUM(CTX_DEBITO) "
			cQuery += " 		 	FROM "+RetSqlName("CTX")+" CTX "
			cQuery += "   			WHERE CTX_FILIAL = '"+xFilial("CTX")+"' "
			cQuery += "   			AND CTX_MOEDA = '"+cMoeda+"' "
			cQuery += "   			AND CTX_TPSALD = '"+cSaldos+"' "
			cQuery += "  			AND CTX_ITEM = ARQ2.CTD_ITEM "
			cQuery += "   			AND CTX_CLVL = ARQ.CTH_CLVL	 "
			cQuery += "    			AND CTX_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
			If lImpAntLP .and. dDataLP >= dDataINI
				cQuery += "	AND CTX_LP <> 'Z' "
			Endif	
			cQuery += "   			AND CTX.D_E_L_E_T_ = '') <> 0 "
		Endif
		cQuery += " ) "		
	Endif

EndIf

cQuery := ChangeQuery(cQuery)	

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif	

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)
If lEntid
	For nColunas := 1 to Len(aEntid)
		TcSetField("TRBTMP","COLUNA"+Str(nColunas,Iif(nColunas>9,2,1)),"N",aTamVlr[1],aTamVlr[2])
	Next 	
Else
	If lMeses
		For nColunas := 1 to Len(aMeses)
			TcSetField("TRBTMP","COLUNA"+Str(nColunas,Iif(nColunas>9,2,1)),"N",aTamVlr[1],aTamVlr[2])
		Next
	Else
		TcSetField("TRBTMP","COLUNA1","N",aTamVlr[1],aTamVlr[2])	
	EndIf
EndIf

RestArea(aAreaQry)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTUCmpQry ºAutor  ³Marcos S. Lobo      º Data ³  06/16/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna alias TRBTMP com a composição dos saldos por Entid. º±±
±±º          ³C.Custo, Item ou CL.Valor                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CTUCmpQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,;
					cMoeda,cTpSld1,cTpSld2,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					cSegAte,lVariacao0,nDivide,nGrupo,bVariacao,cIdent,lCt1Sint,cString,cFILUSU)

Local cQuery		:= ""
Local aAreaQry		:= {}		/// array com a posição no arquivo original
Local aTamVlr		:= TAMSX3("CT7_DEBITO")
Local nStr			:= 1

DEFAULT lVariacao0	:= .F.

DO CASE
CASE cIdent == "CTD"
	cFieldQry	:= " CTD_ITEM ITEM	,CTD_RES ITEMRES, CTD_DESC"+cMoeda+" DESCITEM	, CTD_CLASSE TIPOITEM	, CTD_ITSUP ITSUP, "
	cOrdQry		:= "CTD_ITEM"
	cEntIni		:= cITEMIni
	cEntFim		:= cITEMFim
CASE cIdent == "CTT"
	cFieldQry	:= " CTT_CUSTO CUSTO	,CTT_RES CCRES	, CTT_DESC"+cMoeda+" DESCCC		, CTT_CLASSE TIPOCC		, CTT_CCSUP CCSUP, "
	cOrdQry		:= "CTT_CUSTO"
	cEntIni		:= cCCIni
	cEntFim		:= cCCFim
CASE cIdent == "CTH"
	cFieldQry	:= " CTH_CLVL CLVL	,CTH_RES CLVLRES, CTH_DESC"+cMoeda+" DESCCLVL	, CTH_CLASSE TIPOCLVL	, CTH_CLSUP CLSUP, "
	cOrdQry		:= "CTH_CLVL"
	cEntIni		:= cCLVLIni
	cEntFim		:= cCLVLFim
ENDCASE

aAreaQry := GetArea()

cQuery := " SELECT "+cFieldQry
	
	////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cFILUSU)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := (cString)->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////
	
	cQuery += " 	(SELECT SUM(CTU_CREDIT) - SUM(CTU_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CTU")+" CTU "
	cQuery += " 			WHERE CTU_FILIAL = '"+xFilial("CTU")+"'  "
	cQuery += "				AND '"+cIdent+"' = CTU_IDENT "
	cQuery += " 			AND CTU_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CTU_TPSALD = '"+cTpSld1+"' "
	cQuery += " 			AND ARQ."+cOrdQry+"	= CTU_CODIGO "
	cQuery += " 			AND CTU_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
	cQuery += " 			AND CTU.D_E_L_E_T_ = '') MOVIMENTO1, "
	cQuery += " 		(SELECT SUM(CTU_CREDIT) - SUM(CTU_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CTU")+" CTU "
	cQuery += " 			WHERE CTU_FILIAL = '"+xFilial("CTU")+"'  "
	cQuery += "				AND '"+cIdent+"' = CTU_IDENT "
	cQuery += " 			AND CTU_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CTU_TPSALD = '"+cTpSld2+"' "
	cQuery += " 			AND ARQ."+cOrdQry+"	= CTU_CODIGO "
	cQuery += " 			AND CTU_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
	cQuery += " 			AND CTU.D_E_L_E_T_ = '') MOVIMENTO2 "
	cQuery += " 	FROM "+RetSqlName(cIdent)+" ARQ	" 
	cQuery += " 	WHERE ARQ."+cIdent+"_FILIAL = '"+xFilial(cIdent)+"' "
	cQuery += " 	AND ARQ."+cOrdQry+" BETWEEN '"+cEntIni+"' AND '"+cEntFim+"' "
	cQuery += " 	AND ARQ."+cIdent+"_CLASSE = '2' "
	
	If !Empty(aSetOfBook[1])										//// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
		cQuery += " 	AND ARQ."+cIdent+"_BOOK LIKE '%"+aSetOfBook[1]+"%' "    //// FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
	Endif
	cQuery += " 	AND ARQ.D_E_L_E_T_ = '' "
     
	If !lVariacao0
		cQuery += " 	AND ( "
		cQuery += " 	(SELECT SUM(CTU_CREDIT) - SUM(CTU_DEBITO) "
		cQuery += "			 	FROM "+RetSqlName("CTU")+" CTU "
		cQuery += " 			WHERE CTU_FILIAL = '"+xFilial("CTU")+"'  "
		cQuery += "				AND '"+cIdent+"' = CTU_IDENT "
		cQuery += " 			AND CTU_MOEDA = '"+cMoeda+"' "
		cQuery += " 			AND CTU_TPSALD = '"+cTpSld1+"' "
		cQuery += " 			AND ARQ."+cOrdQry+"	= CTU_CODIGO "
		cQuery += " 			AND CTU_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
		cQuery += " 			AND CTU.D_E_L_E_T_ = '') <> 0 "
		cQuery += " OR "
		cQuery += " 		(SELECT SUM(CTU_CREDIT) - SUM(CTU_DEBITO) "
		cQuery += "			 	FROM "+RetSqlName("CTU")+" CTU "
		cQuery += " 			WHERE CTU_FILIAL = '"+xFilial("CTU")+"'  "
		cQuery += "				AND '"+cIdent+"' = CTU_IDENT "
		cQuery += " 			AND CTU_MOEDA = '"+cMoeda+"' "
		cQuery += " 			AND CTU_TPSALD = '"+cTpSld2+"' "
		cQuery += " 			AND ARQ."+cOrdQry+"	= CTU_CODIGO "
		cQuery += " 			AND CTU_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
		cQuery += " 			AND CTU.D_E_L_E_T_ = '') <> 0 )"
	Endif
           
	cQuery := ChangeQuery(cQuery)		   

	If Select("TRBTMP") > 0
		dbSelectArea("TRBTMP")
		dbCloseArea()
	Endif
	
  	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)
  	TcSetField("TRBTMP","MOVIMENTO1","N",aTamVlr[1],aTamVlr[2])
  	TcSetField("TRBTMP","MOVIMENTO2","N",aTamVlr[1],aTamVlr[2])

	Do Case
	Case cIdent == "CTT"     
		If CtbExDtFim("CTT") 
		  	TcSetField("TRBTMP","CTTDTEXSF","D",8,0)	
		EndIf
	Case cIdent == "CTD"
		If CtbExDtFim("CTD") 
		  	TcSetField("TRBTMP","CTDDTEXSF","D",8,0)	
		EndIf
	Case cIdent == "CTH"
		If CtbExDtFim("CTH") 
		  	TcSetField("TRBTMP","CTHDTEXSF","D",8,0)	
		EndIf
	EndCase

RestArea(aAreaQry)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT3CompQryºAutor  ³Simone Mie Sato     º Data ³  30/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Obtem o saldo dos C.Custo x Conta retornando um alias       º±±
±±º          ³TRBTMP executado com a query                          	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CT3CompQry(dDataIni,dDataFim,cCCIni,cCCFim,cContaIni,cContaFim,cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,lMeses,aMeses,lVlrZerado,lEntid,aEntid,cHeader,cString,cFILUSU)

Local cQuery		:= ""
Local aAreaQry		:= {}		/// array com a posição no arquivo original
Local aTamVlr		:= TAMSX3("CT7_DEBITO")
Local nStr			:= 0
Local nMes			:= 0
Local nColunas		:= 0

DEFAULT lMeses		:= .F.
DEFAULT lVlrZerado	:= .F.
DEFAULT lEntid		:= .F.

aAreaQry := GetArea()   

////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cFILUSU)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := (cString)->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
////////////////////////////////////////////////////////////

If lMeses
	If cHeader == "CTT"
		cQuery := " SELECT CTT_CUSTO CUSTO, CT1_CONTA CONTA, CTT_RES CCRES, CTT_DESC"+cMoeda+" DESCCC, CTT_CLASSE TIPOCC, CTT_CCSUP CCSUP, "
		cQuery += " 	CT1_RES CTARES, CT1_DESC"+cMoeda+" DESCCTA, CT1_CLASSE TIPOCONTA, CT1_CTASUP CTASUP, "
		cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY

		If lMeses .and. Len(aMeses) > 0     
			For nMes := 1 to Len(aMeses)
				cQuery += "  	(SELECT SUM(CT3_CREDIT) - SUM(CT3_DEBITO) "
				cQuery += " 		 	FROM "+RetSqlName("CT3")+" CT3 "
				cQuery += "   			WHERE CT3_FILIAL = '"+xFilial("CT3")+"' "
				cQuery += "   			AND CT3_MOEDA = '"+cMoeda+"' "
				cQuery += "   			AND CT3_TPSALD = '"+cSaldos+"' "
				cQuery += "   			AND CT3_CUSTO = ARQ.CTT_CUSTO "
				cQuery += "  			AND CT3_CONTA = ARQ2.CT1_CONTA "
				cQuery += "    			AND CT3_DATA BETWEEN '"+DTOS(aMeses[nMes,2])+"' AND '"+DTOS(aMeses[nMes,3])+"' "
				If lImpAntLP .and. dDataLP >= aMeses[nMes,2]
					cQuery += "	AND CT3_LP <> 'Z' "
				Endif
				cQuery += "   			AND CT3.D_E_L_E_T_ = '') COLUNA"+ALLTRIM(STR(nMes))
				If nMes < Len(aMeses)
						cQuery += ","	
				Endif
			Next
		Else
			cQuery += "  	(SELECT SUM(CT3_CREDIT) - SUM(CT3_DEBITO) "
			cQuery += " 		 	FROM "+RetSqlName("CT3")+" CT3 "
			cQuery += "   			WHERE CT3_FILIAL = '"+xFilial("CT3")+"' "
			cQuery += "   			AND CT3_MOEDA = '"+cMoeda+"' "
			cQuery += "   			AND CT3_TPSALD = '"+cSaldos+"' "
			cQuery += "   			AND CT3_CUSTO = ARQ.CTT_CUSTO	 "
			cQuery += "  			AND CT3_CONTA = ARQ2.CT1_CONTA "
			cQuery += "    			AND CT3_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
			If lImpAntLP .and. dDataLP >= dDataINI
				cQuery += "	AND CT3_LP <> 'Z' "
			Endif	
			cQuery += "   			AND CT3.D_E_L_E_T_ = '') COLUNA1 "
		Endif

		cQuery += " FROM "+RetSqlName("CTT")+" ARQ, "+RetSqlName("CT1")+" ARQ2 "
		cQuery += " WHERE ARQ.CTT_FILIAL = '"+xFilial("CTT")+"'  	"
		cQuery += " AND ARQ.CTT_CUSTO BETWEEN '"+cCCIni+"' AND '"+cCCFim+"' "
		cQuery += " AND ARQ.CTT_CLASSE = '2'  	"

		If !Empty(aSetOfBook[1])
			cQuery += " AND ARQ.CTT_BOOK LIKE '%"+aSetOfBook[1]+"%' 	"
		Endif

		cQuery += " AND ARQ2.CT1_FILIAL = '"+xFilial("CT1")+"'  	"
		cQuery += " AND ARQ2.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"'  	"
		cQuery += " AND ARQ2.CT1_CLASSE = '2'  	"

		If !Empty(aSetOfBook[1])
			cQuery += " AND ARQ2.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "	
		Endif

		cQuery += " AND ARQ.D_E_L_E_T_ = ''  	"
		cQuery += " AND ARQ2.D_E_L_E_T_ = ''  	"

		If !lVlrZerado
			cQuery += " AND ( "
        
			If lMeses .and. Len(aMeses) > 0
				For nMes := 1 to Len(aMeses)
					cQuery += "  	(SELECT ROUND(SUM(CT3_CREDIT),2) - ROUND(SUM(CT3_DEBITO),2) "
					cQuery += " 		 	FROM "+RetSqlName("CT3")+" CT3 "
					cQuery += "   			WHERE CT3_FILIAL = '"+xFilial("CT3")+"' "
					cQuery += "   			AND CT3_MOEDA = '"+cMoeda+"' "
					cQuery += "   			AND CT3_TPSALD = '"+cSaldos+"' "
					cQuery += "   			AND CT3_CUSTO = ARQ.CTT_CUSTO	 "
					cQuery += "  			AND CT3_CONTA = ARQ2.CT1_CONTA "
					cQuery += "    			AND CT3_DATA BETWEEN '"+DTOS(aMeses[nMes,2])+"' AND '"+DTOS(aMeses[nMes,3])+"' "					
					If lImpAntLP .and. dDataLP >= aMeses[nMes,2]
						cQuery += "	AND CT3_LP <> 'Z' "
					Endif	
					cQuery += "   			AND CT3.D_E_L_E_T_ = '') <> 0 "
					If nMes < Len(aMeses)
						cQuery += " OR "
					Endif
				Next
			Else
				cQuery += "  	(SELECT SUM(CT3_CREDIT) - SUM(CT3_DEBITO) "
				cQuery += " 		 	FROM "+RetSqlName("CT3")+" CT3 "
				cQuery += "   			WHERE CT3_FILIAL = '"+xFilial("CT3")+"' "
				cQuery += "   			AND CT3_MOEDA = '"+cMoeda+"' "
				cQuery += "   			AND CT3_TPSALD = '"+cSaldos+"' "
				cQuery += "   			AND CT3_CUSTO = ARQ.CTT_CUSTO "
				cQuery += "  			AND CT3_CONTA = ARQ2.CT1_CONTA "
				cQuery += "    			AND CT3_DATA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
				If lImpAntLP .and. dDataLP >= dDataINI
					cQuery += "	AND CT3_LP <> 'Z' "
				Endif	
				cQuery += "   			AND CT3.D_E_L_E_T_ = '') <> 0 "
			Endif
			
			cQuery += " ) "
		Endif
	EndIf

EndIf

cQuery := ChangeQuery(cQuery)	

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif	

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)
If lMeses
	For nColunas := 1 to Len(aMeses)
		TcSetField("TRBTMP","COLUNA"+Str(nColunas,Iif(nColunas>9,2,1)),"N",aTamVlr[1],aTamVlr[2])
	Next 
ElseIf lEntid
	For nColunas := 1 to Len(aEntid)
		TcSetField("TRBTMP","COLUNA"+Str(nColunas,Iif(nColunas>9,2,1)),"N",aTamVlr[1],aTamVlr[2])
	Next 
Else
	TcSetField("TRBTMP","COLUNA1","N",aTamVlr[1],aTamVlr[2])	
EndIf

RestArea(aAreaQry)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³SupCompMes³ Autor ³ Simone Mie Sato       ³ Data ³ 24.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Comparativo do CT3.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oMeter                                      ³±±
±±³          ³ ExpO2 = Objeto oText                                       ³±±
±±³          ³ ExpO3 = Objeto oDlg                                        ³±±
±±³          ³ ExpL1 = lEnd                                               ³±±
±±³          ³ ExpD1 = Data Inicial                                       ³±±
±±³          ³ ExpD2 = Data Final                                         ³±±
±±³          ³ ExpC1 = Conta Inicial                                      ³±±
±±³          ³ ExpC2 = Conta Final                                        ³±±
±±³          ³ ExpC3 = Classe de Valor Inicial                            ³±±
±±³          ³ ExpC4 = Classe de Valor Final                              ³±±
±±³          ³ ExpC5 = Moeda		                                      ³±±
±±³          ³ ExpC6 = Saldo	                                          ³±±
±±³          ³ ExpA1 = Set Of Book	                                      ³±±
±±³          ³ ExpN1 = Tamanho da descricao da conta	                  ³±±
±±³          ³ ExpC7 = Ate qual segmento sera impresso (nivel)			  ³±±
±±³          ³ ExpC8 = Filtra por Segmento		                          ³±±
±±³          ³ ExpC9 = Segmento Inicial		                              ³±±
±±³          ³ ExpC10= Segmento Final  		                              ³±±
±±³          ³ ExpC11= Segmento Contido em  	                          ³±±
±±³          ³ ExpL12= Se imprime total acumulado	                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                      
Function SupCompMes(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cAlias,lCusto,lItem,lClvl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,;
				cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado,lEntid,aEntid)
				         
Local aSaveArea 	:= GetArea()
Local cMascara1 	:= ""
Local cMascara2		:= ""
Local nPos			:= 0
Local nDigitos		:= 0
Local cEntid1		:= ""	//Codigo da Entidade Principal
Local cEntid2   	:= "" 	//Codigo da Entidade do Corpo do Relatorio              
local nSaldoAnt 	:= 0
Local nSaldoDeb 	:= 0
Local nSaldoCrd 	:= 0
Local nSaldoAtu 	:= 0
Local nSaldoAntD	:= 0
Local nSaldoAntC	:= 0
Local nSaldoAtuD	:= 0
Local nSaldoAtuC	:= 0
Local nRegTmp   	:= 0
Local nOrder		:= 0
Local cChave		:= ""
Local bCond1		:= {||.F.}
Local bCond2		:= {||.F.}
Local cCadAlias1	:= ""	//Alias do Cadastro da Entidade Principal
Local cCadAlias2	:= ""	//Alias do Cadastro da Entidade que sera impressa no corpo.
Local cCodEnt1		:= ""	//Codigo da Entidade Principal
Local cCodEnt2		:= ""	//Codigo da Entidade que sera impressa no corpo do relat.
Local cDesc1		:= ""
Local cDesc2		:= ""
Local cDescEnt		:= ""
Local cDescEnt1		:= ""	//Descricao da Entidade Principal                           
Local cDescEnt2		:= ""	//Descricao da Entidade que sera impressa no corpo.                          
Local cCodSup1		:= ""	//Cod.Superior da Entidade Principal
Local cCodSup2		:= ""	//Cod.Superior da Entidade que sera impressa no corpo.
Local nRecno1		:= ""
Local nRecno2		:= ""
Local cEntidSup		:= ""
Local nTamDesc1		:= ""
Local nTamDesc2		:= ""
Local cOrigem		:= ""
Local cIndice		:= ""
Local cMensagem		:= OemToAnsi(STR0016)+ OemToAnsi(STR0017)
Local dMinData	                                      
Local nTotVezes		:= 0
Local aMovimento	:= {0,0,0,0,0,0}
Local nMeter		:= 0
Local nVezes		:= 1 

DEFAULT lEntid 		:= .F.
DEFAULT aEntid		:= {}

lFiliais			:= Iif(lFiliais == Nil,.F.,lFiliais)
aFiliais			:= Iif(aFiliais==Nil,{},aFiliais)	
lMeses				:= Iif(lMeses == NIl, .F.,lMeses)
aMeses				:= Iif(aMeses==Nil,{},aMeses)
nDivide 			:= Iif(nDivide == Nil,1,nDivide)
lVlrZerado			:= Iif(lVlrZerado == Nil,.T.,lVlrZerado)

If lFiliais	//Se for Comparativo por Filiais
	nTotVezes := Len(aFiliais)		
Else
	If lMeses	//Se for Comparativo por Mes
		nTotVezes := Len(aMeses)
	Else 
		If lEntid	//// se for comparativo x 6 entidades (em parâmetro)
			nTotVezes := Len(aEntid)
		Endif
	EndIf
Endif

Do Case                  
Case cAlias == 'CT3'
	If cHeader == 'CTT'
	//nOrder 		:= 2
		cCadAlias1	:= 'CTT'
		cCadAlias2	:= 'CT1'
		cCodEnt1	:= 'CUSTO' 
		cCodEnt2	:=	'CONTA'
		cCodSup1	:= 'CCSUP'
		cCodSup2	:= 'CTASUP'		
		cMascara1	:= aSetOfBook[6]	//Mascara do Centro de Custo
		cMascara2	:= aSetOfBook[5]	//Mascara do Item
		nTamDesc1	:=	Len(CriaVar("CTT_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CT1_DESC"+cMoeda))		
		cDescEnt1	:= "DESCCC"		
		cSuperior	:= 'CTT_FILIAL+CTT_CCSUP'
	EndIf
Case cAlias == 'CTV'     
	cOrigem		:= 'CT4'	
	If cHeader == 'CTT'		//Se for C.Custo/Item
		nOrder 		:= 2
		cCadAlias1	:= 'CTT'
		cCadAlias2	:= 'CTD'
		cCodEnt1	:= 'CUSTO' 
		cCodEnt2	:=	'ITEM'
		cCodSup1	:= 'CCSUP'
		cCodSup2	:= 'ITSUP'		
		cMascara1	:= aSetOfBook[6]	//Mascara do Centro de Custo
		cMascara2	:= aSetOfBook[7]	//Mascara do Item
		nTamDesc1	:=	Len(CriaVar("CTT_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTD_DESC"+cMoeda))		
		cDescEnt1	:= "DESCCC"
		cSuperior	:= 'CTT_FILIAL+CTT_CCSUP'		
	ElseIf cHeader == 'CTD' 	//Se for Item/C.Custo                              	
		nOrder 		:= 1	
		cCadAlias1	:= 'CTD'
		cCadAlias2	:= 'CTT'
		cCodEnt1	:= 'ITEM' 
		cCodEnt2	:= 'CUSTO'
		cCodSup1	:= 'ITSUP'
		cCodSup2	:= 'CCSUP'
		cMascara1	:= aSetOfBook[7]	//Mascara do Item	
		cMascara2	:= aSetOfBook[6]	//Mascara do Centro de Custo
		nTamDesc1	:=	Len(CriaVar("CTD_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTT_DESC"+cMoeda))	
		cDescEnt1	:= "DESCITEM"              
		cSuperior	:= 'CTD_FILIAL+CTD_ITSUP'		
	EndIf	
Case cAlias == 'CTW'	
	cOrigem		:= 'CTI'	
	If cHeader == 'CTH'//Se for Cl.Valor/C.Custo
		nOrder 		:= 1      
		cCadAlias1	:= 'CTH'	
		cCadAlias2	:= 'CTT'
		cCodEnt1	:= 'CLVL'  
		cCodEnt2	:= 'CUSTO'
		cCodSup1	:= 'CLSUP'
		cCodSup2	:= 'CCSUP'
		cMascara1	:= aSetOfBook[8]	//Mascara da Classe de Valor
		cMascara2	:= aSetOfBook[6]	//Mascara do Centro de Custo
		nTamDesc1	:=	Len(CriaVar("CTH_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTT_DESC"+cMoeda))				
		cDescEnt1	:= "DESCCLVL"		
		cSuperior	:= 'CTH_FILIAL+CTH_CLSUP'				
	ElseIf cHeader == 'CTT'//Se for C.Custo/Cl.Valor
		nOrder 		:= 2      
		cCadAlias1	:= 'CTT'
		cCadAlias2	:= 'CTH'			
		cCodEnt1	:= 'CUSTO'  
		cCodEnt2	:= 'CLVL'
		cCodSup1  	:= 'CCSUP'
		cCodSup2	:= 'CLSUP'
		cMascara1	:= aSetOfBook[6]	//Mascara do Centro de Custo
		cMascara2	:= aSetOfBook[8]	//Mascara da Classe de Valor	
		nTamDesc1	:=	Len(CriaVar("CTT_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTH_DESC"+cMoeda))		
		cDescEnt1	:= "DESCCC"		
		cSuperior	:= 'CTT_FILIAL+CTT_CCSUP'		
	EndIf
Case cAlias == 'CTX'   
	cOrigem		:= 'CTI'	 
	If cHeader == 'CTH'//Se for Cl.Valor/Item
		nOrder 		:= 2      
		cCadAlias1	:= 'CTH'
		cCadAlias2	:= 'CTD'
		cCodEnt1	:= 'CLVL'
		cCodEnt2	:= 'ITEM'
		cCodSup1	:= 'CLSUP'      
		cCodSup2	:= 'ITSUP'
		cMascara1	:= aSetOfBook[8]	//Mascara da Cl.Valor
		cMascara2	:= aSetOfBook[7]	//Mascara do Item Contab.
		nTamDesc1	:=	Len(CriaVar("CTH_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTD_DESC"+cMoeda))				
		cDescEnt1	:= "DESCCLVL"		
		cSuperior	:= 'CTH_FILIAL+CTH_CLSUP'				
	ElseIf cHeader == 'CTD'//Se for Item/Cl.Valor
		nOrder		:= 1
		cCadAlias1	:= 'CTD'
		cCadAlias2	:= 'CTH'
		cCodEnt1	:=	'ITEM'
		cCodEnt2	:=	'CLVL'
		cCodSup1  	:=	'ITSUP'
		cCodSup2	:=	'CLSUP'
		cMascara1	:= aSetOfBook[7]	//Mascara do Item Contab.
		cMascara2	:= aSetOfBook[8]	//Mascara da Cl.Valor
		nTamDesc1	:=	Len(CriaVar("CTD_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTH_DESC"+cMoeda))				
		cDescEnt1	:= "DESCITEM"		
		cSuperior	:= 'CTD_FILIAL+CTD_ITSUP'				
	EndIf

Case cAlias == 'CTD'     //// CASO SEJA INVERTIDO O cHeader x cAlias
	cOrigem		:= 'CT4'	

	If cHeader == 'CTV'		//Se for C.Custo/Item
		cInd	:= "ITEM+CUSTO"
		cCadAlias1	:= 'CTT'
		cCadAlias2	:= 'CTD'
		cCodEnt1	:= 'CUSTO'
		cCodEnt2	:= 'ITEM' 
		cCodSup1	:= 'CCSUP'
		cCodSup2	:= 'ITSUP'
		cMascara1	:= aSetOfBook[6]	//Mascara do Centro de Custo
		cMascara2	:= aSetOfBook[7]	//Mascara do Item	
		nTamDesc1	:= Len(CriaVar("CTT_DESC"+cMoeda))	
		nTamDesc2	:= Len(CriaVar("CTD_DESC"+cMoeda))
		cDescEnt1	:= "DESCCC"
		cSuperior	:= 'CTT_FILIAL+CTT_CCSUP'						
	ElseIf cHeader == 'CTX' 	//Se for Item x Classe de Valor                              	
		cInd	:= "ITEM+CLVL"
		cCadAlias1	:= 'CTH'
		cCadAlias2	:= 'CTD'
		cCodEnt1	:= 'CLVL'
		cCodEnt2	:= 'ITEM'
		cCodSup1	:= 'CLSUP'      
		cCodSup2	:= 'ITSUP'
		cMascara1	:= aSetOfBook[8]	//Mascara da Cl.Valor
		cMascara2	:= aSetOfBook[7]	//Mascara do Item Contab.
		nTamDesc1	:=	Len(CriaVar("CTH_DESC"+cMoeda))
		nTamDesc2	:=	Len(CriaVar("CTD_DESC"+cMoeda))				
		cDescEnt1	:= "DESCCLVL"		
		cSuperior	:= 'CTH_FILIAL+CTH_CLSUP'								
	EndIf


EndCase

cChave 		:= xFilial(cAlias)+cMoeda+cSaldos+cEntidIni1+cEntidIni2+dtos(dDataIni)
bCond1		:= {||&(cCadAlias1+"->"+cCadAlias1+"_FILIAL") == xFilial(cCadAlias1) .And. &(cCadAlias1+"->"+cCadAlias1+"_"+cCodEnt1) >= cEntidIni1 .And. &(cCadAlias1+"->"+cCadAlias1+"_"+cCodEnt1) <= cEntidFim1 }
bCond2		:= {||&(cCadAlias2+"->"+cCadAlias2+"_FILIAL") == xFilial(cCadAlias2) .And. &(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2) >= cEntidIni2 .And. &(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2) <= cEntidFim2 }


DbSelectArea(cCadAlias1)

If !Empty(cSuperior) .And. Empty(IndexKey(5))
	IndRegua(cCadAlias1, cIndice := (CriaTrab(, .F. )), cSuperior,,, STR0001)
	nIndex:=RetIndex(cCadAlias1)+1
	dbSelectArea(cCadAlias1)
	#IfNDef TOP
		dbSetIndex(cIndice+OrdBagExt())	
	#Endif
Else
	nIndex := 5
Endif


// Grava sinteticas
dbSelectArea("cArqTmp")	
If ValType(oMeter) == "O"
	oMeter:SetTotal(cArqTmp->(RecCount()))
	oMeter:Set(0)
EndIF
dbGoTop()  

While!Eof()                                                                         
	If ValType(oMeter) == "O"
		nMeter++
   		oMeter:Set(nMeter)
  	EndIf

	nRegTmp := Recno()      
	aMovimento	:= {}
	For nVezes	:= 1 to nTotVezes
		Aadd(aMovimento, 0)               				
	Next
	
	For nVezes := 1 to nTotVezes
		aMovimento[nVezes] := &("COLUNA"+Alltrim(Str(nVezes,2)))	     
	Next
	
	If cAlias == 'CT3' 
		cEntid 	 := &("cArqTmp->"+cCodEnt1)
		cDescEnt := &("cArqTmp->"+cDescEnt1)
	EndIf                           
	
	dbSelectArea(cCadAlias1)
	cEntidG	:= cEntid	
	dbSetOrder(1)
	MsSeek(xFilial(cCadAlias1)+cEntidG)
	
	While !Eof() .And. &(cCadAlias1 + "->" + cCadAlias1 + "_FILIAL") == xFilial()
	
        nReg := cArqTmp->(Recno())
	
		dbSelectArea(cCadAlias2)
		dbSetOrder(1)      
		
		cEntidSup := &("cArqTmp->"+cCodEnt2)

		MsSeek(xFilial(cCadAlias2)+ cEntidSup) 		
		
		If cEntid = cEntidG
			cEntidSup := &("cArqTmp->"+cCodSup2)
			MsSeek(xFilial(cCadAlias2)+ cEntidSup)
		Endif
		
		cDesc1	 := &((cCadAlias1)+ "->"+cCadAlias1+"_DESC"+cMoeda)		
		
		If Empty(cDesc1) 
			cDesc1	 := &((cCadAlias1)+ "->"+cCadAlias1+"_DESC01")				
		EndIf
		
		While !Eof() .And. &(cCadAlias2+"->"+cCadAlias2+"_FILIAL") == xFilial()

			cEntid1	 := &("cArqTmp->"+cCodEnt1)
//			cDesc1	 := &("cArqTmp->"+cDescEnt1)
			cEntSup2 := &(cCadAlias2+"->"+cCadAlias2+"_"+cCodEnt2)
								
			cDescEnt2	:= (cCadAlias2+"->"+cCadAlias2+"_DESC")
			cDesc2		:= &(cDescEnt2+cMoeda)			        
			If Empty(cDesc2)	// Caso nao preencher descricao da moeda selecionada		
				cDesc2	:= &(cDescEnt2+"01")
			Endif

			If lEntid									/// SE FOR ENTIDADE X 6 CODIGOS DE ENTIDADE
				cSeek 		:= cEntSup2//cEntid1		/// PROCURA SOMENTE A ENTIDADE SUPERIOR POIS PODE NÃO ESTAR AMARRADO A 1ª ENTIDADE
			Else
				cSeek 		:= cEntidG+cEntidSup
			Endif
			dbSelectArea("cArqTmp")
			dbSetOrder(1)      
			If !MsSeek(cSeek)
				RecLock("cArqTmp",.T.)			
				Do Case               
				Case cAlias == 'CT3'
					If cHeader == 'CTT'
						Replace CUSTO		With cEntidG
						Replace DESCCC		With cDesc1
						Replace TIPOCC 		With CTT->CTT_CLASSE			
						Replace CCSUP 		With CTT->CTT_CCSUP	
						Replace CCRES		With CTT->CTT_RES	
						Replace CONTA		With cEntidSup
						Replace DESCCTA 	With cDesc2
						Replace TIPOCONTA	With CT1->CT1_CLASSE
						Replace CTASUP 		With CT1->CT1_CTASUP	
						Replace CTARES 		With CT1->CT1_RES				
					EndIf
				Case cAlias == 'CTV'      
					If cHeader	== 'CTT'	//Se for Centro de Custo/Item
						Replace CUSTO   	With cEntid1
						Replace DESCCC		With cDesc1
						Replace TIPOCC 		With CTT->CTT_CLASSE			
						Replace CCSUP 		With CTT->CTT_CCSUP	
						Replace CCRES		With CTT->CTT_RES	
						Replace ITEM 		With cEntSup2
						Replace DESCITEM	With cDesc2
						Replace TIPOITEM 	With CTD->CTD_CLASSE
						Replace ITSUP  		With CTD->CTD_ITSUP		
						Replace ITEMRES		With CTD->CTD_RES			
					ElseIf cHeader == 'CTD'	//Se for Item/C.Custo
						Replace ITEM 		With cEntid1
						Replace DESCITEM	With cDesc1
						Replace TIPOITEM 	With CTD->CTD_CLASSE
						Replace ITSUP  		With CTD->CTD_ITSUP		
						Replace ITEMRES		With CTD->CTD_RES					
						Replace CUSTO   	With cEntSup2
						Replace DESCCC		With cDesc2
						Replace TIPOCC 		With CTT->CTT_CLASSE			
						Replace CCSUP 		With CTT->CTT_CCSUP	
						Replace CCRES		With CTT->CTT_RES	
					EndIf			
				Case cAlias == 'CTW'
					If cHeader	== 'CTH'		//Se for Cl.Valor/C.Custo
						Replace CLVL    	With cEntid1
						Replace DESCCLVL	With cDesc1
						Replace TIPOCLVL 	With CTH->CTH_CLASSE
						Replace CLSUP    	With CTH->CTH_CLSUP
						Replace CLVLRES		With CTH->CTH_RES
						Replace CUSTO   	With cEntSup2
						Replace DESCCC		With cDesc2
						Replace TIPOCC 		With CTT->CTT_CLASSE			
						Replace CCSUP 		With CTT->CTT_CCSUP	
						Replace CCRES		With CTT->CTT_RES				                        	
					ElseIf cHeader	== 'CTT'	//Se for C.Custo/Cl.Valor
						Replace CUSTO   	With cEntid1
						Replace DESCCC		With cDesc1
						Replace TIPOCC 		With CTT->CTT_CLASSE			
						Replace CCSUP 		With CTT->CTT_CCSUP	
						Replace CCRES		With CTT->CTT_RES				                        	
						Replace CLVL    	With cEntSup2
						Replace DESCCLVL	With cDesc2
						Replace TIPOCLVL 	With CTH->CTH_CLASSE
						Replace CLSUP    	With CTH->CTH_CLSUP
						Replace CLVLRES		With CTH->CTH_RES			
					EndIf
				Case cAlias == 'CTX'                   
					If cHeader == 'CTH'	//Se for Cl.Valor/Item
						Replace CLVL    	With cEntid1 
						Replace DESCCLVL	With cDesc1
						Replace TIPOCLVL 	With CTH->CTH_CLASSE
						Replace CLSUP    	With CTH->CTH_CLSUP
						Replace CLVLRES		With CTH->CTH_RES
						Replace ITEM		With cEntSup2
						Replace DESCITEM	With cDesc2
						Replace TIPOITEM 	With CTD->CTD_CLASSE
						Replace ITSUP  		With CTD->CTD_ITSUP		
						Replace ITEMRES		With CTD->CTD_RES					
					ElseIf cHeader	== 'CTD'	//Se for Item/Cl.Valor
						Replace ITEM		With cEntid1
						Replace DESCITEM	With cDesc1
						Replace TIPOITEM 	With CTD->CTD_CLASSE
						Replace ITSUP  		With CTD->CTD_ITSUP		
						Replace ITEMRES		With CTD->CTD_RES					
						Replace CLVL    	With cEntSup2
						Replace DESCCLVL	With cDesc2
						Replace TIPOCLVL 	With CTH->CTH_CLASSE
						Replace CLSUP    	With CTH->CTH_CLSUP
						Replace CLVLRES		With CTH->CTH_RES			
					Endif
				
				Case cAlias == 'CTD'		/// Se for cHeader x cAlias invertido
					If cHeader	== 'CTV'		//Se for Item x C.Custo
						Replace CUSTO   	With cEntid1
						Replace DESCCC		With cDesc1
						Replace TIPOCC 		With CTT->CTT_CLASSE			
						Replace CCSUP 		With CTT->CTT_CCSUP	
						Replace CCRES		With CTT->CTT_RES	
						Replace ITEM 		With cEntSup2
						Replace DESCITEM	With cDesc2
						Replace TIPOITEM 	With CTD->CTD_CLASSE
						Replace ITSUP  		With CTD->CTD_ITSUP		
						Replace ITEMRES		With CTD->CTD_RES			
					ElseIf cHeader	== 'CTX'	//Se for ITEM X Cl.Valor
						Replace CLVL    	With cEntid1 
						Replace DESCCLVL	With cDesc1
						Replace TIPOCLVL 	With CTH->CTH_CLASSE
						Replace CLSUP    	With CTH->CTH_CLSUP
						Replace CLVLRES		With CTH->CTH_RES
						Replace ITEM		With cEntSup2
						Replace DESCITEM	With cDesc2
						Replace TIPOITEM 	With CTD->CTD_CLASSE
						Replace ITSUP  		With CTD->CTD_ITSUP		
						Replace ITEMRES		With CTD->CTD_RES					
					EndIf
				EndCase
			Else
				RecLock("cArqTmp",.F.)
			EndIf    
		
			For nVezes := 1 to nTotVezes
				If cTpVlr == 'M'
					Replace &("COLUNA"+	Alltrim(Str(nVezes,2))) With (&("COLUNA"+Alltrim(Str(nVezes,2)))+aMovimento[nVezes])
				EndIf
    		Next
		
			dbSelectArea(cCadAlias2)
			cEntidSup	:= &(cCadAlias2+"->"+cCadAlias2+"_"+cCodSup2)
			If Empty(&(cCadAlias2+"->"+cCadAlias2+"_"+cCodSup2)) //.And. Empty(&(cCadAlias1+"->"+cCadAlias1+"_"+cCodSup1))
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea(cCadAlias2)
				Exit                     						
			EndIf		
	
			dbSelectArea("cArqTmp")
			dbGoto(nRegTmp)
			dbSelectArea(cCadAlias2)
			cEntidSup	:= &(cCadAlias2+"->"+cCadAlias2+"_"+cCodSup2)			
			If Empty(cEntidSup) .And. Empty(&(cCadAlias1+ "->"+cCadAlias1+"_" + cCodSup1))
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea(cCadAlias2)
			EndIf		
			
			MsSeek(xFilial(cCadAlias2)+ cEntidSup)
		EndDo
		dbSelectArea("cArqTmp")
		dbGoto(nReg)
		dbSelectArea(cCadAlias1)
		cEntidG	:= &(cCadAlias1+ "->"+cCadAlias1+"_"  + cCodSup1)
		If Empty(cEntidG)		// Ultimo Nivel gerencial
			Exit                                         	
		EndIf
		MsSeek(xFilial(cCadAlias1)+cEntidG)
	EndDo
	dbSelectArea("cArqTmp")
	dbGoto(nREgTmp)
	dbSkip()
EndDo              

If ! Empty(cIndice)
	dbSelectArea(cCadAlias1)
	dbClearFil()
	RetIndex(cCadalias1)
	dbSetOrder(1)
   	Ferase(cIndice + OrdBagExt()) 
Endif

RestArea(aSaveArea)

Return				
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT4Bln3EntºAutor  ³Simone Mie Sato     º Data ³  11/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna alias TRBTMP com a composição dos saldos CC x Conta º±±
±±º          ³x Item.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CT4Bln3Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cMoeda,;
					cTpSald,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP)						

Local cQuery		:= ""
Local aAreaQry		:= GetArea()		/// array com a posição no arquivo original
Local aTamVlr		:= TAMSX3("CT4_DEBITO")

If TCGetDb() == "POSTGRES"		
	cQuery := " SELECT CHAR(3) 'CT3' ALIAS,  ' ' ITEM, CTT_CUSTO CUSTO,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, "
Else
	cQuery := " SELECT 'CT3' ALIAS,  ' ' ITEM, CTT_CUSTO CUSTO,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, "
EndIf
cQuery += " 	CT1_CTASUP SUPERIOR, CTT_RES CCRES, CTT_CCSUP CCSUP, CT1_CLASSE TIPOCONTA, CTT_CLASSE TIPOCC, "
cQuery += " 	' ' ITEMRES, ' ' TIPOITEM, "
If CtbExDtFim("CT1") 
	cQuery += " CT1_DTEXSF CT1DTEXSF, "
EndIf
If CtbExDtFim("CTT") 
	cQuery += " CTT_DTEXSF CTTDTEXSF, "
EndIf                           
If ctbExDtFim("CTD")
	cQuery += " ' ' CTDDTEXSF, "
EndIf
If cMoeda == '01'
	cQuery += "		CT1_DESC01 DESCCTA, CTT_DESC01 DESCCC, ' ' DESCITEM, "                                                   	
Else
	cQuery += "		CT1_DESC"+cMoeda+" DESCCTA, CTT_DESC"+cMoeda+" DESCCC, CT1_DESC01 DESCCTA01, CTT_DESC01 DESCCC01, ' ' DESCITEM, ' ' DESCIT01, "                                                   	
EndIf
cQuery += " 	(SELECT SUM(CT3_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO  "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDOANTDB, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT3_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTDB, "  
EndIf

cQuery += " 		(SELECT SUM(CT3_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDOANTCR, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT3_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO  "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTCR, "  
EndIf

cQuery += " 		(SELECT SUM(CT3_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDODEB, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT3_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "	
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPDEB, "
EndIf

cQuery += " 		(SELECT SUM(CT3_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDOCRD "

If lImpAntLP
	cQuery += ", 		(SELECT SUM(CT3_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "	
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPCRD "
EndIf

cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ, "+RetSqlName("CTT")+" ARQ2 "
cQuery += " 	WHERE ARQ.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += " 	AND ARQ.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 	AND ARQ.CT1_CLASSE = '2' "    

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif

cQuery += " 	AND  ARQ2.CTT_FILIAL = '"+xFilial("CTT")+"' "
cQuery += " 	AND ARQ2.CTT_CUSTO BETWEEN '"+cCCIni+"' AND '"+cCCFim+"' "
cQuery += " 	AND ARQ2.CTT_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ2.CTT_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE ITEM DO MESMO SETOFBOOKS
Endif

cQuery += " 	AND ARQ.D_E_L_E_T_ = '' "
cQuery += " 	AND ARQ2.D_E_L_E_T_ = '' "    
cQuery += " 	AND ((SELECT SUM(CT3_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') <> 0 "
cQuery += " 	OR "
cQuery += " 		(SELECT SUM(CT3_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') <> 0 "
cQuery += " 	OR "	
cQuery += " 		(SELECT SUM(CT3_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '')<> 0 "
cQuery += " 	OR "		
cQuery += " 		(SELECT SUM(CT3_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') <> 0 )"		

cQuery += " UNION "
If TCGetDb() == "POSTGRES"		
	cQuery += " SELECT CHAR(3) 'CT4' ALIAS, CTD_ITEM ITEM, CTT_CUSTO CUSTO,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, "
Else	
	cQuery += " SELECT 'CT4' ALIAS, CTD_ITEM ITEM, CTT_CUSTO CUSTO,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, "
EndIf
cQuery += " 	CT1_CTASUP SUPERIOR, CTT_RES CCRES, CTT_CCSUP CCSUP, CT1_CLASSE TIPOCONTA, CTT_CLASSE TIPOCC, "
cQuery += " 	CTD_RES ITEMRES, CTD_CLASSE TIPOITEM, "
If CtbExDtFim("CT1") 
	cQuery += " CT1_DTEXSF CT1DTEXSF, "
EndIf
If CtbExDtFim("CTT") 
	cQuery += " CTT_DTEXSF CTTDTEXSF, "
EndIf
If CtbExDtFim("CTD") 
	cQuery += " CTD_DTEXSF CTDDTEXSF, "
EndIf                           

If cMoeda == '01'
	cQuery += "		CT1_DESC01 DESCCTA, CTT_DESC01 DESCCC,  CTD_DESC01 DESCITEM, "                                                   	
Else
	cQuery += "		CT1_DESC"+cMoeda+" DESCCTA, CTT_DESC"+cMoeda+" DESCCC, CT1_DESC01 DESCCTA01, CTT_DESC01 DESCCC01, CTD_DESC01 DESCIT01, CTD_DESC"+cMoeda+" DESCITEM, "                                                   	
EndIf
cQuery += " 	(SELECT SUM(CT4_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') SALDOANTDB, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT4_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
	cQuery += "				AND ARQ3.CTD_ITEM = CT4_ITEM "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
	cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT4_LP = 'Z' AND ((CT4_DTLP <> ' ' AND CT4_DTLP >= '"+DTOS(dDataLP)+"') OR (CT4_DTLP = '' AND CT4_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT4.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTDB, "  
EndIf

cQuery += " 		(SELECT SUM(CT4_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL	= '"+xFilial("CT4")+"' "
cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') SALDOANTCR, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT4_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
	cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO  "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
	cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT4_LP = 'Z' AND ((CT4_DTLP <> ' ' AND CT4_DTLP >= '"+DTOS(dDataLP)+"') OR (CT4_DTLP = '' AND CT4_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT4.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTCR, "  
EndIf

cQuery += " 		(SELECT SUM(CT4_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') SALDODEB, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT4_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
	cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "	
	cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CT4_LP = 'Z' AND ((CT4_DTLP <> ' ' AND CT4_DTLP >= '"+DTOS(dDataLP)+"') OR (CT4_DTLP = '' AND CT4_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CT4.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPDEB, "
EndIf

cQuery += " 		(SELECT SUM(CT4_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL	= '"+xFilial("CT4")+"' "
cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') SALDOCRD "

If lImpAntLP
	cQuery += ", 		(SELECT SUM(CT4_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
	cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "	
	cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CT4_LP = 'Z' AND ((CT4_DTLP <> ' ' AND CT4_DTLP >= '"+DTOS(dDataLP)+"') OR (CT4_DTLP = '' AND CT4_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CT4.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPCRD "
EndIf

cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ, "+RetSqlName("CTT")+" ARQ2, "+RetSqlName("CTD")+" ARQ3 "
cQuery += " 	WHERE ARQ.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += " 	AND ARQ.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 	AND ARQ.CT1_CLASSE = '2' "    

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif

cQuery += " 	AND  ARQ2.CTT_FILIAL = '"+xFilial("CTT")+"' "
cQuery += " 	AND ARQ2.CTT_CUSTO BETWEEN '"+cCCIni+"' AND '"+cCCFim+"' "
cQuery += " 	AND ARQ2.CTT_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ2.CTT_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE ITEM DO MESMO SETOFBOOKS
Endif                                      

cQuery += " 	AND ARQ3.CTD_FILIAL = '"+xFilial("CTD")+"' "
cQuery += " 	AND ARQ3.CTD_ITEM BETWEEN '"+cItemIni+"' AND '"+cItemFim+"' "
cquery += " 	AND ARQ3.CTD_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ3.CTD_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE ITEM DO MESMO SETOFBOOKS
Endif                                      

cQuery += " 	AND ARQ.D_E_L_E_T_ = '' "
cQuery += " 	AND ARQ2.D_E_L_E_T_ = '' "    
cQuery += "		AND ARQ3.D_E_L_E_T_ = '' "
cQuery += " 	AND ((SELECT SUM(CT4_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') <> 0 "
cQuery += " 	OR "
cQuery += " 		(SELECT SUM(CT4_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL	= '"+xFilial("CT4")+"' "
cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') <> 0 "
cQuery += " 	OR "	
cQuery += " 		(SELECT SUM(CT4_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '')<> 0 "
cQuery += " 	OR "		
cQuery += " 		(SELECT SUM(CT4_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL	= '"+xFilial("CT4")+"' "
cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') <> 0 )"		
cQuery := ChangeQuery(cQuery)		   

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)

TcSetField("TRBTMP","SALDOANTDB","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDOANTCR","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDODEB","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDOCRD","N",aTamVlr[1],aTamVlr[2])	

If CtbExDtFim("CT1") 
	TcSetField("TRBTMP","CT1DTEXSF","D",8,0)	
EndIf

If CtbExDtFim("CTD") 
	TcSetField("TRBTMP","CTDDTEXSF","D",8,0)	
EndIf

If CtbExDtFim("CTT") 
	TcSetField("TRBTMP","CTTDTEXSF","D",8,0)	
EndIf


RestArea(aAreaQry)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb3CtaSup ³Autor  ³ Simone Mie Sato       ³ Data ³ 12.08.04 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualizacao de sinteticas de c.custo/conta/item             			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb3CtaSup(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias	= Alias a ser utilizado             	               		 ³±±
±±³          ³ lNImpMov = Se imprime entidades sem movimento		               	 ³±±
±±³          ³ cMoeda	= Moeda                              	              		 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb3CtaSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,cHeader)
		
Local aSaveArea	:= GetArea()				
Local cCadAlias	:= ""
Local cCodSup	:= ""     
Local cCodEnt	:= ""
Local cConta	:= ""
Local cDescCta	:= ""
Local cOutEnt	:= ""
Local cEntSup	:= ""
Local cDescEnt	:= ""
Local cSeek		:= ""
Local nSaldoAnt	:= 0
Local nSaldoAtu	:= 0
Local nSaldoDeb	:= 0
Local nSaldoCrd	:= 0
Local nMovimento:= 0
Local nSaldoAntD:= 0
Local nSaldoAntC:= 0
Local nSaldoAtuD:= 0
Local nsaldoAtuC:= 0
Local nRegTmp	:= 0
Local nMeter	:= 0
local cCpoSup	:= ""

dbSelectArea("cArqTmp")	
dbGoTop()  
If ValType(oMeter) == "O"
	nMeter	:= 0
	oMeter:SetTotal(cArqTmp->(RecCount()))
	oMeter:Set(0)
EndIf
While!Eof()                                 
	If cAlias == "CT4"     
		If cHeader == "CTT"			
			//Somar somente o que for do CT3 => para nao duplicar os valores do CT4 com CT3.			
			If !Empty(cArqTmp->ITEM)
				dbSkip()
				Loop
			EndIf						
		EndIf
	EndIf                                            

	nSaldoAnt:= SALDOANT
	nSaldoAtu:= SALDOATU
	nSaldoDeb:= SALDODEB
	nSaldoCrd:= SALDOCRD   
	nMovimento:= MOVIMENTO

	nRegTmp := Recno()      
	
	If cAlias == 'CT4'      	   
		If cHeader == "CTT"		   
			cCadastro := "CTT"
			cEntid 	 := cArqTmp->CUSTO
			cCodRes	 := cArqTmp->CCRES
			cTipoEnt := cArqTmp->TIPOCC
			cDescEnt := cArqTmp->DESCCC			
			cCpoSup	 := "CTT_CCSUP"	   
		EndIf		
	EndIf
	


	DbSelectArea(cCadastro)
	cEntidG := cEntid
	dbSetOrder(1)
	MsSeek(xFilial(cCadastro)+cEntidG)
		
	While !Eof() .And. &(cCadastro + "->" + cCadastro + "_FILIAL") == xFilial()
		
        nReg := cArqTmp->(Recno())
        
		dbSelectArea("CT1")	
		dbSetOrder(1)      
		cContaSup := cArqTmp->CONTA
		MsSeek(xFilial("CT1")+ cContaSup)
		
		If cEntid = cEntidG
			cContaSup := CT1->CT1_CTASUP
			MsSeek(xFilial("CT1")+ cContaSup)
		Endif
		
		While !Eof() .And. CT1->CT1_FILIAL == xFilial()
	
			cDesc := &("CT1->CT1_DESC"+cMoeda)
			If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
				cDesc := CT1->CT1_DESC01
			Endif
	
			cDescEnt := &(cCadastro + "->" + cCadastro + "_DESC"+cMoeda)
			If Empty(cDescEnt)		// Caso nao preencher descricao da moeda selecionada
				cDescEnt := &(cCadastro + "->" + cCadastro + "_DESC01")
			Endif
			cCodRes  := &(cCadastro + "->" + cCadastro + "_RES")
			cTipoEnt := &(cCadastro + "->" + cCadastro + "_CLASSE")
	
			dbSelectArea("cArqTmp")
			dbSetOrder(1)      
			If ! MsSeek(cEntidG+cContaSup)
				dbAppend()
				Replace CONTA		With cContaSup	
				Replace DESCCTA 	With cDesc
				Replace NORMAL   	With CT1->CT1_NORMAL
				Replace TIPOCONTA	With CT1->CT1_CLASSE
				Replace GRUPO		With CT1->CT1_GRUPO
				Replace CTARES		With CT1->CT1_RES
				Replace SUPERIOR	With CT1->CT1_CTASUP
				Replace ESTOUR 		With CT1->CT1_ESTOUR

				If cAlias == 'CT4'
					If cHeader == "CTT"					
						Replace CUSTO With cEntidG		 
						Replace CCRES With cCodRes
						Replace TIPOCC With cTipoEnt
						Replace DESCCC With cDescEnt
				        If !Empty(cArqTmp->ITEM)
							dbSelectArea("CTD")        
							dbSetOrder(1)
							If MsSeek(xFilial()+cArqTmp->ITEM)
								Replace ITEM With cArqTmp->ITEM
							    Replace ITEMRES With CTD->CTD_RES
							    If cMoeda == '01'
					    			Replace DESCITEM With CTD->CTD_DESC01
					    		Else 
					    			If !Empty(&("CTD->CTD_DESC"+cMoeda))
						    			Replace DESCITEM With &("CTD->CTD_DESC"+cMoeda)
						    		Else
						    			Replace DESCITEM With CTD->CTD_DESC01					    			
					    		    EndIf
					    		EndIf
    	    				EndIf
  						EndIf				    
					 EndIf
				EndIf
			EndIf    
			dbSelectArea("cArqTmp")
			Replace	 SALDOANT With SALDOANT + nSaldoAnt
			Replace  SALDOATU With SALDOATU + nSaldoAtu
			Replace  SALDODEB With SALDODEB + nSaldoDeb
			Replace  SALDOCRD With SALDOCRD + nSaldoCrd
			If !lNImpMov
				Replace MOVIMENTO With MOVIMENTO + nMovimento
			Endif
	   		
			dbSelectArea("CT1")
			cContaSup := CT1->CT1_CTASUP
			If Empty(CT1->CT1_CTASUP) //.And. Empty(&(cCadastro + "->" + cCpoSup))
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea("CT1")
				Exit
			EndIf
	
			dbSelectArea("cArqTmp")
			dbGoto(nRegTmp)
			dbSelectArea("CT1")
			cContaSup := CT1->CT1_CTASUP
			If Empty(cContaSup) .And. Empty(&(cCadastro + "->" + cCpoSup))
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea("CT1")
			EndIf		
			MsSeek(xFilial("CT1")+ cContaSup)
		EndDo
		dbSelectArea("cArqTmp")
		dbGoto(nReg)
		DbSelectArea(cCadastro)
		cEntidG := &cCpoSup
		If Empty(cEntidG)		// Ultimo Nivel gerencial
			Exit
		EndIf
		MsSeek(xFilial(cCadastro)+cEntidG)
	EndDo
	dbSelectArea("cArqTmp")
	dbGoto(nRegTmp)
	dbSkip()
	If ValType(oMeter) == "O"	
		nMeter++
   		oMeter:Set(nMeter)					
  	EndIf
EndDo

RestArea(aSaveArea)

Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CtbCta2Ent ³Autor  ³ Simone Mie Sato       ³ Data ³ 17.08.04 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gravacao das entidades analiticas no arq. temporario para codebase     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtbCta2Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oMeter	  = Controle da regua                            			 ³±±
±±³          ³ oText 	  = Controle da regua                             			 ³±±
±±³          ³ oDlg  	  = Janela                                        			 ³±±
±±³          ³ lEnd  	  = Controle da regua -> finalizar                			 ³±±
±±³          ³ dDataIni   = Data Inicial de processamento                 			 ³±±
±±³          ³ dDataFim   = Data Final de processamento                   			 ³±±
±±³          ³ cContaIni  = Codigo Conta Inicial                          			 ³±±
±±³          ³ cContaFim  = Codigo Conta Final                            			 ³±±
±±³          ³ cCCIni     = Codigo C.Custo Inicial                        			 ³±±
±±³          ³ cCCFim     = Codigo C.Custo Final                          			 ³±±
±±³          ³ cItemIni   = Codigo Item Inicial                           			 ³±±
±±³          ³ cItemFim   = Codigo Item Final                             			 ³±±
±±³          ³ cClVlIni   = Codigo Cl.Valor Inicial                       			 ³±±
±±³          ³ cClVlFim   = Codigo Cl.Valor Final                         			 ³±±
±±³          ³ cMoeda     = Moeda		                                  			 ³±±
±±³          ³ cSaldos    = Tipos de Saldo a serem processados           			 ³±±
±±³          ³ aSetOfBook = Matriz de configuracao de livros            			 ³±±
±±³          ³ nTamCta    = Tamanho da conta                            			 ³±±
±±³          ³ cSegmento  = Indica qual o segmento será filtrado          			 ³±±
±±³          ³ cSegIni    = Conteudo inicial do segmento                  			 ³±±
±±³          ³ cSegFim    = Conteudo Final do segmento                    			 ³±±
±±³          ³ cFiltSegm  = Indica se filtrara ou nao segmento            			 ³±±
±±³          ³ lNImpMov   = Indica se imprime ou nao a coluna movimento   			 ³±±
±±³          ³ cAlias     = Alias para regua       	                      			 ³±±
±±³          ³ cHeader    = Entidade do cabecalho do relatorio            			 ³±±
±±³          ³ cIdent     = Identificador do arquivo a ser processado     			 ³±±
±±³          ³ lCusto     = Considera Centro de Custo?                   			 ³±±
±±³          ³ lItem      = Considera Item Contabil?                     			 ³±±
±±³          ³ lCLVL      = Considera Classe de Valor?                   			 ³±±
±±³          ³ lAtSldBase = Indica se deve chamar rot atual. saldo basico			 ³±±
±±³          ³ nInicio    = Moeda Inicial (p/ atualizar saldo)           			 ³±±
±±³          ³ nFinal     = Moeda Final (p/ atualizar saldo)             			 ³±±
±±³          ³ cFilde     = Filial inicial (p/ atualizar saldo)          			 ³±±
±±³          ³ cFilAte    = Filial final (p/atualizar saldo)             			 ³±±
±±³          ³ lImpAntLP  = Imprime lancamentos Lucros e Perdas?         			 ³±±
±±³          ³ dDataLP    = Data ultimo Lucros e Perdas                  			 ³±±
±±³          ³ nDivide    = Divide valores (100,1000,1000000)             		   	 ³±±
±±³          ³ lVlrZerado = Grava ou nao valores zerados no arq temporario			 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtbCta2Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
					cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
					cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
					lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
					nDivide,lVlrZerado)				
					
Local aSaveArea	:= GetArea()
Local aSaldoAnt	:= {}
Local aSaldoAtu	:= {}

Local cConta	:= ""
Local cCusto	:= ""
Local cItem		:= ""
Local cDescCta	:= ""
Local cDescCC	:= ""
Local cDescItem	:= ""

Local nSaldoAntD	:= 0
Local nSaldoAntC	:= 0 
Local nSldAnt		:= 0
Local nSaldoAtuD	:= 0
Local nSaldoAtuC	:= 0 
Local nSldAtu		:= 0
Local nSaldoDeb		:= 0 
Local nSaldoCrd		:= 0 
Local nMovimento	:= 0 
Local nTamItem		:= Len(CriaVar("CTD_ITEM"))
Local nCont			:= 0 


If cAlias == "CT4"		//Se for Balancete C.C x Cta x Item
	If cHeader == "CTT"    	
	
		dbSelectArea("CTT")
		dbSetOrder(1) 
		MsSeek(xFilial()+cCCIni,.T.)
		While !Eof() .And. CTT->CTT_FILIAL == xFilial() .And. CTT->CTT_CUSTO <= cCCFim
		
			If CTT->CTT_CLASSE == "1"
				dbSkip()
				Loop
			EndIf
					
			cCusto	:= CTT->CTT_CUSTO
			cDescCC := &("CTT->CTT_DESC"+cMoeda)
				
			If Empty(cDescCC)// Caso nao preencher descricao da moeda selecionada
				cDescCC := CTT->CTT_DESC01
			Endif			
			
			dbSelectArea("CT1")
			dbSetOrder(1)
			MsSeek(xFilial()+cContaIni,.T.)
			
			While !Eof() .And. CT1->CT1_FILIAL == xFilial() .And. CT1->CT1_CONTA <= cContaFim
			
				If CT1->CT1_CLASSE == "1"
					dbSkip()
					Loop
				EndIf
				
				If CtbExDtFim("CT1") 
					//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
					//relatorio for maior, nao ira imprimir a entidade. 
					If !CtbVlDtFim("CT1",dDataIni) 
						dbSelectArea("CT1")
						dbSkip()
						Loop													
					EndIf
				EndIf				
								
				cConta	:= CT1->CT1_CONTA				
				
				cDescCta := &("CT1->CT1_DESC"+cMoeda)
				
				If Empty(cDescCta)// Caso nao preencher descricao da moeda selecionada
					cDescCta := CT1->CT1_DESC01
				Endif

				aSaldoAnt := SaldoCT3(	cConta,cCusto,dDataIni,cMoeda,cSaldos,,	lImpAntLP,dDataLP)
				aSaldoAtu := SaldoCT3(	cConta,cCusto,dDataFim,cMoeda,cSaldos,,	lImpAntLP,dDataLP)

				nSaldoAntD 	:= aSaldoAnt[7]
				nSaldoAntC 	:= aSaldoAnt[8]
				nSldAnt		:= nSaldoAntC - nSaldoAntD
	
				nSaldoAtuD 	:= aSaldoAtu[4]
				nSaldoAtuC 	:= aSaldoAtu[5]          
				nSldAtu		:= nSaldoAtuC - nSaldoAtuD
	
				nSaldoDeb  	:= nSaldoAtuD - nSaldoAntD
				nSaldoCrd  	:= nSaldoAtuC - nSaldoAntC     
				
			    If nDivide > 1
					nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)		
					nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
				EndIf
			
				nMovimento	:= nSaldoCrd-nSaldoDeb

				If (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0) .And. ;
					(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
					dbSkip()
					Loop
				EndIf				
		
				dbSelectArea("cArqTmp")
				dbSetOrder(1)	
				If !MsSeek(cCusto+cConta+Space(nTamItem))
					dbAppend()
					Replace CONTA 		With CT1->CT1_CONTA
					Replace DESCCTA		With cDescCta
 					Replace NORMAL    	With CT1->CT1_NORMAL
	 				Replace TIPOCONTA 	With CT1->CT1_CLASSE
					Replace GRUPO		With CT1->CT1_GRUPO
					Replace CTARES      With CT1->CT1_RES
					Replace SUPERIOR    With CT1->CT1_CTASUP
					Replace ESTOUR 		With CT1->CT1_ESTOUR
					Replace CUSTO		With cCusto
					Replace CCRES		With CTT->CTT_RES
					Replace TIPOCC  	With CTT->CTT_CLASSE
					Replace DESCCC		With cDescCC
				Endif   

		
				If nDivide > 1
					For nCont := 1 To Len(aSaldoAnt)
						aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
					Next nCont
					For nCont := 1 To Len(aSaldoAtu)
						aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
					Next nCont	
				EndIf	
				
				dbSelectArea("cArqTmp")
				dbSetOrder(1)
				Replace SALDOANT With aSaldoAnt[6]
				Replace SALDOATU With aSaldoAtu[1]			// Saldo Atual
	
				Replace  SALDODEB With nSaldoDeb				// Saldo Debito
				Replace  SALDOCRD With nSaldoCrd				// Saldo Credito
				If !lNImpMov
					Replace MOVIMENTO With nSaldoCrd-nSaldoDeb
				Endif              
			
				If lItem				
					dbSelectArea("CTD")
					dbSetOrder(1)	//Codigo de Item
					MsSeek(xFilial()+cItemIni,.T.)
					While !Eof() .And. CTD->CTD_FILIAL == xFilial() .And. CTD->CTD_ITEM <= cItemFim
						
						If CTD->CTD_CLASSE == "1"
							dbSkip()
							Loop
						EndIf           
						
						If CtbExDtFim("CTD") 
							//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
							//relatorio for maior, nao ira imprimir a entidade. 
							If !CtbVlDtFim("CTD",dDataIni) 
								dbSelectArea("CTD")
								dbSkip()
								Loop													
							EndIf
						EndIf	                
						
						cItem	:= CTD->CTD_ITEM								
						
						cDescItem := &("CTD->CTD_DESC"+cMoeda)
					
						If Empty(cDescItem)// Caso nao preencher descricao da moeda selecionada
							cDescItem := CTD->CTD_DESC01
						Endif								
						
						aSaldoAnt := SaldoCT4(	cConta,cCusto,cItem,dDataIni,cMoeda,cSaldos,,lImpAntLP,dDataLP)
						aSaldoAtu := SaldoCT4(	cConta,cCusto,cItem,dDataFim,cMoeda,cSaldos,,lImpAntLP,dDataLP)
	
						nSaldoAntD 	:= aSaldoAnt[7]
						nSaldoAntC 	:= aSaldoAnt[8]
						nSldAnt		:= nSaldoAntC - nSaldoAntD
		
						nSaldoAtuD 	:= aSaldoAtu[4]
						nSaldoAtuC 	:= aSaldoAtu[5]          
						nSldAtu		:= nSaldoAtuC - nSaldoAtuD
		
						nSaldoDeb  	:= nSaldoAtuD - nSaldoAntD
						nSaldoCrd  	:= nSaldoAtuC - nSaldoAntC     
					
					    If nDivide > 1
							nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)		
							nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
						EndIf
				
						nMovimento	:= nSaldoCrd-nSaldoDeb
	
						If (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0) .And. ;
							(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
							dbSkip()
							Loop
						EndIf				
			
						dbSelectArea("cArqTmp")
						dbSetOrder(1)	
						If !MsSeek(cCusto+cConta+cItem)
							dbAppend()
							Replace CONTA 		With CT1->CT1_CONTA
							Replace DESCCTA		With cDescCta
		 					Replace NORMAL    	With CT1->CT1_NORMAL
			 				Replace TIPOCONTA 	With CT1->CT1_CLASSE
							Replace GRUPO		With CT1->CT1_GRUPO
							Replace CTARES      With CT1->CT1_RES
							Replace SUPERIOR    With CT1->CT1_CTASUP
							Replace ESTOUR 		With CT1->CT1_ESTOUR
							Replace CUSTO		With cCusto
							Replace CCRES		With CTT->CTT_RES
							Replace TIPOCC  	With CTT->CTT_CLASSE
							Replace DESCCC		With cDescCC
							Replace ITEM		With cItem
							Replace DESCITEM	With cDescItem					
						Endif   
					
						If nDivide > 1
							For nCont := 1 To Len(aSaldoAnt)
								aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
							Next nCont
							For nCont := 1 To Len(aSaldoAtu)
								aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
							Next nCont	
						EndIf	
						
						dbSelectArea("cArqTmp")
						dbSetOrder(1)
						Replace SALDOANT With aSaldoAnt[6]
						Replace SALDOATU With aSaldoAtu[1]			// Saldo Atual
		    	
						Replace  SALDODEB With nSaldoDeb				// Saldo Debito
						Replace  SALDOCRD With nSaldoCrd				// Saldo Credito
						If !lNImpMov
							Replace MOVIMENTO With nSaldoCrd-nSaldoDeb
						Endif              								            
				
						dbSelectArea("CTD")	
						dbSkip()           
					End
				EndIf			
				dbSelectArea("CT1")
		 		dbSkip()		
			End																
			dbSelectArea("CTT")
			dbSkip() 
		End
    EndIf
EndIf

RestArea(aSaveArea)

Return()
					
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTIBln4EntºAutor  ³Simone Mie Sato     º Data ³  06/10/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna alias TRBTMP com a composição dos saldos CC x Conta º±±
±±º          ³x Item X Cl.Valor                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CTIBln4Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,;
					cClVlIni,cClVlFim,cMoeda,cTpSald,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP)						
					

Local cQuery		:= ""
Local aAreaQry		:= GetArea()		/// array com a posição no arquivo original
Local aTamVlr		:= TAMSX3("CTY_DEBITO")

If TCGetDb() == "POSTGRES"		
	cQuery := " SELECT CHAR(3) 'CT3' ALIAS,  ' ' CLVL, ' ' ITEM, CTT_CUSTO CUSTO,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, "
Else
	cQuery := " SELECT 'CT3' ALIAS,  '' CLVL, ' ' ITEM, CTT_CUSTO CUSTO,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, "
EndIf
cQuery += " 	CT1_CTASUP SUPERIOR, CTT_RES CCRES, CTT_CCSUP CCSUP, CT1_CLASSE TIPOCONTA, CTT_CLASSE TIPOCC, "
cQuery += " 	' ' ITEMRES, ' ' TIPOITEM, ' ' CLVLRES, ' ' CLSUP,' ' TIPOCLVL, "

If CtbExDtFim("CT1") 
	cQuery += " CT1_DTEXSF CT1DTEXSF, "
EndIf
If CtbExDtFim("CTT") 
	cQuery += " CTT_DTEXSF CTTDTEXSF, "
EndIf                           
If ctbExDtFim("CTD")
	cQuery += " ' ' CTDDTEXSF, "
EndIf
If ctbExDtFim("CTH")
	cQuery += " ' ' CTHDTEXSF, "
EndIf

If cMoeda == '01'
	cQuery += "		CT1_DESC01 DESCCTA, CTT_DESC01 DESCCC, ' ' DESCITEM, ' ' DESCCLVL, "                                                   	
Else
	cQuery += "		CT1_DESC"+cMoeda+" DESCCTA, CTT_DESC"+cMoeda+" DESCCC, CT1_DESC01 DESCCTA01, CTT_DESC01 DESCCC01, ' ' DESCITEM, ' ' DESCIT01,  ' ' DESCCLVL, ' ' DESCCV01,"                                                   	
EndIf
cQuery += " 	(SELECT SUM(CT3_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO  "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDOANTDB, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT3_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTDB, "  
EndIf

cQuery += " 		(SELECT SUM(CT3_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDOANTCR, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT3_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO  "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTCR, "  
EndIf

cQuery += " 		(SELECT SUM(CT3_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDODEB, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT3_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "	
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPDEB, "
EndIf

cQuery += " 		(SELECT SUM(CT3_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDOCRD "

If lImpAntLP
	cQuery += ", 		(SELECT SUM(CT3_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "	
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPCRD "
EndIf

cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ, "+RetSqlName("CTT")+" ARQ2 "
cQuery += " 	WHERE ARQ.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += " 	AND ARQ.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 	AND ARQ.CT1_CLASSE = '2' "    

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif

cQuery += " 	AND  ARQ2.CTT_FILIAL = '"+xFilial("CTT")+"' "
cQuery += " 	AND ARQ2.CTT_CUSTO BETWEEN '"+cCCIni+"' AND '"+cCCFim+"' "
cQuery += " 	AND ARQ2.CTT_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ2.CTT_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE ITEM DO MESMO SETOFBOOKS
Endif

cQuery += " 	AND ARQ.D_E_L_E_T_ = '' "
cQuery += " 	AND ARQ2.D_E_L_E_T_ = '' "    
cQuery += " 	AND ((SELECT SUM(CT3_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') <> 0 "
cQuery += " 	OR "
cQuery += " 		(SELECT SUM(CT3_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') <> 0 "
cQuery += " 	OR "	
cQuery += " 		(SELECT SUM(CT3_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '')<> 0 "
cQuery += " 	OR "		
cQuery += " 		(SELECT SUM(CT3_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ2.CTT_CUSTO = CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') <> 0 )"		

cQuery += " UNION "
If TCGetDb() == "POSTGRES"		
	cQuery += " SELECT CHAR(3) 'CT4' ALIAS,' ' CLVL, CTD_ITEM ITEM, CTT_CUSTO CUSTO,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, "
Else	
	cQuery += " SELECT 'CT4' ALIAS, ' ' CLVL, CTD_ITEM ITEM, CTT_CUSTO CUSTO,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, "
EndIf
cQuery += " 	CT1_CTASUP SUPERIOR, CTT_RES CCRES, CTT_CCSUP CCSUP, CT1_CLASSE TIPOCONTA, CTT_CLASSE TIPOCC, "
cQuery += " 	CTD_RES ITEMRES, CTD_CLASSE TIPOITEM, ' ' CLVLRES, ' ' CLSUP, ' ' TIPOCLVL, "
If CtbExDtFim("CT1") 
	cQuery += " CT1_DTEXSF CT1DTEXSF, "
EndIf
If CtbExDtFim("CTT") 
	cQuery += " CTT_DTEXSF CTTDTEXSF, "
EndIf                           
If ctbExDtFim("CTD")
	cQuery += " CTD_DTEXSF CTDDTEXSF, "
EndIf
If ctbExDtFim("CTH")
	cQuery += " ' ' CTHDTEXSF, "
EndIf

If cMoeda == '01'
	cQuery += "		CT1_DESC01 DESCCTA, CTT_DESC01 DESCCC,  CTD_DESC01 DESCITEM, ' ' DESCLVL, "                                                   	
Else
	cQuery += "		CT1_DESC"+cMoeda+" DESCCTA, CTT_DESC"+cMoeda+" DESCCC, CT1_DESC01 DESCCTA01, "
	cQuery += "     CTT_DESC01 DESCCC01, CTD_DESC01 DESCIT01, CTD_DESC"+cMoeda+" DESCITEM, "                                                   	
	cQuery += " 	' ' DESCV01, ' ' DESCCLVL, " 
EndIf                         

cQuery += " 	(SELECT SUM(CT4_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') SALDOANTDB, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT4_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
	cQuery += "				AND ARQ3.CTD_ITEM = CT4_ITEM "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
	cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT4_LP = 'Z' AND ((CT4_DTLP <> ' ' AND CT4_DTLP >= '"+DTOS(dDataLP)+"') OR (CT4_DTLP = '' AND CT4_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT4.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTDB, "  
EndIf

cQuery += " 		(SELECT SUM(CT4_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL	= '"+xFilial("CT4")+"' "
cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') SALDOANTCR, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT4_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
	cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO  "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
	cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT4_LP = 'Z' AND ((CT4_DTLP <> ' ' AND CT4_DTLP >= '"+DTOS(dDataLP)+"') OR (CT4_DTLP = '' AND CT4_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT4.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTCR, "  
EndIf

cQuery += " 		(SELECT SUM(CT4_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') SALDODEB, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT4_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
	cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "	
	cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CT4_LP = 'Z' AND ((CT4_DTLP <> ' ' AND CT4_DTLP >= '"+DTOS(dDataLP)+"') OR (CT4_DTLP = '' AND CT4_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CT4.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPDEB, "
EndIf

cQuery += " 		(SELECT SUM(CT4_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL	= '"+xFilial("CT4")+"' "
cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') SALDOCRD "

If lImpAntLP
	cQuery += ", 		(SELECT SUM(CT4_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
	cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
	cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
	cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "	
	cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CT4_LP = 'Z' AND ((CT4_DTLP <> ' ' AND CT4_DTLP >= '"+DTOS(dDataLP)+"') OR (CT4_DTLP = '' AND CT4_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CT4.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPCRD "
EndIf
cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ, "+RetSqlName("CTT")+" ARQ2, "+RetSqlName("CTD")+" ARQ3 "
cQuery += " 	WHERE ARQ.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += " 	AND ARQ.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 	AND ARQ.CT1_CLASSE = '2' "    

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif

cQuery += " 	AND  ARQ2.CTT_FILIAL = '"+xFilial("CTT")+"' "
cQuery += " 	AND ARQ2.CTT_CUSTO BETWEEN '"+cCCIni+"' AND '"+cCCFim+"' "
cQuery += " 	AND ARQ2.CTT_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ2.CTT_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE ITEM DO MESMO SETOFBOOKS
Endif                                      

cQuery += " 	AND ARQ3.CTD_FILIAL = '"+xFilial("CTD")+"' "
cQuery += " 	AND ARQ3.CTD_ITEM BETWEEN '"+cItemIni+"' AND '"+cItemFim+"' "
cquery += " 	AND ARQ3.CTD_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ3.CTD_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE ITEM DO MESMO SETOFBOOKS
Endif                                      

cQuery += " 	AND ARQ.D_E_L_E_T_ = '' "
cQuery += " 	AND ARQ2.D_E_L_E_T_ = '' "    
cQuery += "		AND ARQ3.D_E_L_E_T_ = '' "
cQuery += " 	AND ((SELECT SUM(CT4_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') <> 0 "
cQuery += " 	OR "
cQuery += " 		(SELECT SUM(CT4_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL	= '"+xFilial("CT4")+"' "
cQuery += " 			AND CT4_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') <> 0 "
cQuery += " 	OR "	
cQuery += " 		(SELECT SUM(CT4_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL = '"+xFilial("CT4")+"'  "
cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '')<> 0 "
cQuery += " 	OR "		
cQuery += " 		(SELECT SUM(CT4_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT4")+" CT4 "
cQuery += " 			WHERE CT4_FILIAL	= '"+xFilial("CT4")+"' "
cQuery += " 			AND CT4_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ3.CTD_ITEM = CT4_ITEM  "
cQuery += " 			AND ARQ2.CTT_CUSTO = CT4_CUSTO "
cQuery += " 			AND CT4_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT4_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT4_CONTA "
cQuery += " 			AND CT4.D_E_L_E_T_ = '') <> 0 )"
cQuery += " UNION "
If TCGetDb() == "POSTGRES"		
	cQuery += " SELECT CHAR(3) 'CTI' ALIAS, CTH_CLVL CLVL, CTD_ITEM ITEM, CTT_CUSTO CUSTO,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, "
Else	
	cQuery += " SELECT 'CTI' ALIAS, CTH_CLVL CLVL, CTD_ITEM ITEM, CTT_CUSTO CUSTO,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, "
EndIf
cQuery += " 	CT1_CTASUP SUPERIOR, CTT_RES CCRES, CTT_CCSUP CCSUP, CT1_CLASSE TIPOCONTA, CTT_CLASSE TIPOCC, "
cQuery += " 	CTD_RES ITEMRES, CTD_CLASSE TIPOITEM, CTH_RES CLVLRES, CTH_CLSUP CLSUP, CTH_CLASSE TIPOCLVL, "

If CtbExDtFim("CT1") 
	cQuery += " CT1_DTEXSF CT1DTEXSF, "
EndIf
If CtbExDtFim("CTT") 
	cQuery += " CTT_DTEXSF CTTDTEXSF, "
EndIf                           
If ctbExDtFim("CTD")
	cQuery += " CTD_DTEXSF CTDDTEXSF, "
EndIf
If ctbExDtFim("CTH")
	cQuery += " CTH_DTEXSF CTHDTEXSF, "
EndIf

If cMoeda == '01'
	cQuery += "		CT1_DESC01 DESCCTA, CTT_DESC01 DESCCC,  CTD_DESC01 DESCITEM, CTH_DESC01 DESCLVL, "                                                   	
Else
	cQuery += "		CT1_DESC"+cMoeda+" DESCCTA, CTT_DESC"+cMoeda+" DESCCC, CT1_DESC01 DESCCTA01, "
	cQuery += "    	CTT_DESC01 DESCCC01, CTD_DESC01 DESCIT01, CTD_DESC"+cMoeda+" DESCITEM, "
	cQuery += " 	CTH_DESC01 DESCCV01, CTH_DESC"+cMoeda+" DESCCLVL, "                                                   	
EndIf

cQuery += " 	(SELECT SUM(CTI_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
cQuery += " 			AND CTI_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  " 
cQuery += " 			AND ARQ3.CTD_ITEM = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '') SALDOANTDB, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CTI_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
	cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
	cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "	
	cQuery += " 			AND ARQ3.CTD_ITEM = CTI_ITEM "	
	cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
	cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
	cQuery += " 			AND CTI_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CTI_LP = 'Z' AND ((CTI_DTLP <> ' ' AND CTI_DTLP >= '"+DTOS(dDataLP)+"') OR (CTI_DTLP = '' AND CTI_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CTI.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTDB, "  
EndIf

cQuery += " 		(SELECT SUM(CTI_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL	= '"+xFilial("CTI")+"' "
cQuery += " 			AND CTI_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "	
cQuery += " 			AND ARQ3.CTD_ITEM = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '') SALDOANTCR, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CTI_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
	cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
	cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "	
	cQuery += " 			AND ARQ3.CTD_ITEM = CTI_ITEM "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO  "
	cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
	cQuery += " 			AND CTI_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CTI_LP = 'Z' AND ((CTI_DTLP <> ' ' AND CTI_DTLP >= '"+DTOS(dDataLP)+"') OR (CTI_DTLP = '' AND CTI_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CTI.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTCR, "  
EndIf

cQuery += " 		(SELECT SUM(CTI_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "	  
cQuery += " 			AND ARQ3.CTD_ITEM = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '') SALDODEB, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CTI_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
	cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
	cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "		
	cQuery += " 			AND ARQ3.CTD_ITEM = CTI_ITEM "	
	cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
	cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "	
	cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CTI_LP = 'Z' AND ((CTI_DTLP <> ' ' AND CTI_DTLP >= '"+DTOS(dDataLP)+"') OR (CTI_DTLP = '' AND CTI_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CTI.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPDEB, "
EndIf

cQuery += " 		(SELECT SUM(CTI_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL	= '"+xFilial("CTI")+"' "
cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "		
cQuery += " 			AND ARQ3.CTD_ITEM = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '') SALDOCRD "

If lImpAntLP
	cQuery += ", 		(SELECT SUM(CTI_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
	cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
	cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "			
	cQuery += " 			AND ARQ3.CTD_ITEM = CTI_ITEM "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
	cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "	
	cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CTI_LP = 'Z' AND ((CTI_DTLP <> ' ' AND CTI_DTLP >= '"+DTOS(dDataLP)+"') OR (CTI_DTLP = '' AND CTI_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CTI.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPCRD "
EndIf

cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ, "+RetSqlName("CTT")+" ARQ2, "+RetSqlName("CTD")+" ARQ3, "
cQuery +=  		RetSqlName("CTH") + " ARQ4 "
cQuery += " 	WHERE ARQ.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += " 	AND ARQ.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 	AND ARQ.CT1_CLASSE = '2' "    

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif

cQuery += " 	AND  ARQ2.CTT_FILIAL = '"+xFilial("CTT")+"' "
cQuery += " 	AND ARQ2.CTT_CUSTO BETWEEN '"+cCCIni+"' AND '"+cCCFim+"' "
cQuery += " 	AND ARQ2.CTT_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ2.CTT_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE ITEM DO MESMO SETOFBOOKS
Endif                                      

cQuery += " 	AND ARQ3.CTD_FILIAL = '"+xFilial("CTD")+"' "
cQuery += " 	AND ARQ3.CTD_ITEM BETWEEN '"+cItemIni+"' AND '"+cItemFim+"' "
cquery += " 	AND ARQ3.CTD_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ3.CTD_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE ITEM DO MESMO SETOFBOOKS
Endif                                      


cQuery += " 	AND ARQ4.CTH_FILIAL = '"+xFilial("CTH")+"' "
cQuery += " 	AND ARQ4.CTH_CLVL BETWEEN '"+cClVlIni+"' AND '"+cClVlFim+"' "
cQuery += " 	AND ARQ4.CTH_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ4.CTH_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE ITEM DO MESMO SETOFBOOKS
Endif                                      

cQuery += " 	AND ARQ.D_E_L_E_T_ = '' "
cQuery += " 	AND ARQ2.D_E_L_E_T_ = '' "    
cQuery += "		AND ARQ3.D_E_L_E_T_ = '' "
cQuery += "		AND ARQ4.D_E_L_E_T_ = '' "
cQuery += " 	AND ((SELECT SUM(CTI_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
cQuery += " 			AND CTI_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "   
cQuery += " 			AND ARQ3.CTD_ITEM = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '') <> 0 "
cQuery += " 	OR "
cQuery += " 		(SELECT SUM(CTI_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL	= '"+xFilial("CTI")+"' "
cQuery += " 			AND CTI_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "
cQuery += " 			AND ARQ3.CTD_ITEM = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '') <> 0 "
cQuery += " 	OR "	
cQuery += " 		(SELECT SUM(CTI_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "
cQuery += " 			AND ARQ3.CTD_ITEM = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '')<> 0 "
cQuery += " 	OR "		
cQuery += " 		(SELECT SUM(CTI_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL	= '"+xFilial("CTI")+"' "
cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "
cQuery += " 			AND ARQ3.CTD_ITEM = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '') <> 0 )"		
cQuery += " UNION "

If TCGetDb() == "POSTGRES"		
	cQuery += " SELECT CHAR(3) 'CTI' ALIAS, CTH_CLVL CLVL, ' '  ITEM, CTT_CUSTO CUSTO,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, "
Else	
	cQuery += " SELECT 'CTI' ALIAS, CTH_CLVL CLVL, ' ' ITEM, CTT_CUSTO CUSTO,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, "
EndIf
cQuery += " 	CT1_CTASUP SUPERIOR, CTT_RES CCRES, CTT_CCSUP CCSUP, CT1_CLASSE TIPOCONTA, CTT_CLASSE TIPOCC, "
cQuery += " 	' ' ITEMRES, ' ' TIPOITEM, CTH_RES CLVLRES, CTH_CLSUP CLSUP, CTH_CLASSE TIPOCLVL, "

If CtbExDtFim("CT1") 
	cQuery += " CT1_DTEXSF CT1DTEXSF, "
EndIf
If CtbExDtFim("CTT") 
	cQuery += " CTT_DTEXSF CTTDTEXSF, "
EndIf                           
If ctbExDtFim("CTD")
	cQuery += " ' '  CTDDTEXSF, "
EndIf
If ctbExDtFim("CTH")
	cQuery += " CTH_DTEXSF CTHDTEXSF, "
EndIf

If cMoeda == '01'
	cQuery += "		CT1_DESC01 DESCCTA, CTT_DESC01 DESCCC,  ' ' DESCITEM, CTH_DESC01 DESCLVL, "                                                   	
Else
	cQuery += "		CT1_DESC"+cMoeda+" DESCCTA, CTT_DESC"+cMoeda+" DESCCC, CT1_DESC01 DESCCTA01, "
	cQuery += "    	CTT_DESC01 DESCCC01, ' ' DESCIT01, ' '  DESCITEM, "
	cQuery += " 	CTH_DESC01 DESCCV01, CTH_DESC"+cMoeda+" DESCCLVL, "                                                   	
EndIf

cQuery += " 	(SELECT SUM(CTI_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
cQuery += " 			AND CTI_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  " 
cQuery += " 			AND ' '  = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '') SALDOANTDB, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CTI_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
	cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
	cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "	
	cQuery += " 			AND ' ' = CTI_ITEM "	
	cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
	cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
	cQuery += " 			AND CTI_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CTI_LP = 'Z' AND ((CTI_DTLP <> ' ' AND CTI_DTLP >= '"+DTOS(dDataLP)+"') OR (CTI_DTLP = '' AND CTI_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CTI.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTDB, "  
EndIf

cQuery += " 		(SELECT SUM(CTI_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL	= '"+xFilial("CTI")+"' "
cQuery += " 			AND CTI_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "	
cQuery += " 			AND ' '  = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '') SALDOANTCR, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CTI_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
	cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
	cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "	
	cQuery += " 			AND ' ' = CTI_ITEM "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO  "
	cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
	cQuery += " 			AND CTI_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CTI_LP = 'Z' AND ((CTI_DTLP <> ' ' AND CTI_DTLP >= '"+DTOS(dDataLP)+"') OR (CTI_DTLP = '' AND CTI_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CTI.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTCR, "  
EndIf

cQuery += " 		(SELECT SUM(CTI_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "	  
cQuery += " 			AND ' ' = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '') SALDODEB, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CTI_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
	cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
	cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "		
	cQuery += " 			AND ' ' = CTI_ITEM "	
	cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
	cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "	
	cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CTI_LP = 'Z' AND ((CTI_DTLP <> ' ' AND CTI_DTLP >= '"+DTOS(dDataLP)+"') OR (CTI_DTLP = '' AND CTI_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CTI.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPDEB, "
EndIf

cQuery += " 		(SELECT SUM(CTI_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL	= '"+xFilial("CTI")+"' "
cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "		
cQuery += " 			AND ' ' = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '') SALDOCRD "

If lImpAntLP
	cQuery += ", 		(SELECT SUM(CTI_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
	cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
	cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "			
	cQuery += " 			AND ' ' = CTI_ITEM "
	cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
	cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "	
	cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += "				AND CTI_LP = 'Z' AND ((CTI_DTLP <> ' ' AND CTI_DTLP >= '"+DTOS(dDataLP)+"') OR (CTI_DTLP = '' AND CTI_DATA >= '"+DTOS(dDataLP)+"'))"		
	cQuery += " 			AND CTI.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPCRD "
EndIf

cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ, "+RetSqlName("CTT")+" ARQ2, "
cQuery +=  		RetSqlName("CTH") + " ARQ4, "
cQuery +=  		RetSqlName("CTI") + " CTI "
cQuery += " 	WHERE ARQ.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += " 	AND ARQ.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 	AND ARQ.CT1_CLASSE = '2' "    

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif

cQuery += " 	AND  ARQ2.CTT_FILIAL = '"+xFilial("CTT")+"' "
cQuery += " 	AND ARQ2.CTT_CUSTO BETWEEN '"+cCCIni+"' AND '"+cCCFim+"' "
cQuery += " 	AND ARQ2.CTT_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ2.CTT_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE ITEM DO MESMO SETOFBOOKS
Endif                                      

cQuery += " 	AND ARQ4.CTH_FILIAL = '"+xFilial("CTH")+"' "
cQuery += " 	AND ARQ4.CTH_CLVL BETWEEN '"+cClVlIni+"' AND '"+cClVlFim+"' "
cQuery += " 	AND ARQ4.CTH_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ4.CTH_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE ITEM DO MESMO SETOFBOOKS
Endif                                      

cQuery += " 	AND ARQ.D_E_L_E_T_ = '' "
cQuery += " 	AND ARQ2.D_E_L_E_T_ = '' "    
cQuery += "		AND ARQ4.D_E_L_E_T_ = '' "
cQuery += " 	AND ((SELECT SUM(CTI_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
cQuery += " 			AND CTI_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "   
cQuery += " 			AND ' ' = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '') <> 0 "
cQuery += " 	OR "
cQuery += " 		(SELECT SUM(CTI_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL	= '"+xFilial("CTI")+"' "
cQuery += " 			AND CTI_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "
cQuery += " 			AND ' ' = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '') <> 0 "
cQuery += " 	OR "	
cQuery += " 		(SELECT SUM(CTI_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL = '"+xFilial("CTI")+"'  "
cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "
cQuery += " 			AND ' ' = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '')<> 0 "
cQuery += " 	OR "		
cQuery += " 		(SELECT SUM(CTI_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CTI")+" CTI "
cQuery += " 			WHERE CTI_FILIAL	= '"+xFilial("CTI")+"' "
cQuery += " 			AND CTI_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND ARQ4.CTH_CLVL = CTI_CLVL  "
cQuery += " 			AND ' ' = CTI_ITEM "
cQuery += " 			AND ARQ2.CTT_CUSTO = CTI_CUSTO "
cQuery += " 			AND CTI_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CTI_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CTI_CONTA "
cQuery += " 			AND CTI.D_E_L_E_T_ = '') <> 0 )"		
cQuery := ChangeQuery(cQuery)		   

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)

TcSetField("TRBTMP","SALDOANTDB","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDOANTCR","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDODEB","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDOCRD","N",aTamVlr[1],aTamVlr[2])	


RestArea(aAreaQry)

Return				         

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CtbCta3Ent ³Autor  ³ Simone Mie Sato       ³ Data ³ 14.10.04 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gravacao das entidades analiticas no arq. temporario para codebase     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtbCta3Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oMeter	  = Controle da regua                            			 ³±±
±±³          ³ oText 	  = Controle da regua                             			 ³±±
±±³          ³ oDlg  	  = Janela                                        			 ³±±
±±³          ³ lEnd  	  = Controle da regua -> finalizar                			 ³±±
±±³          ³ dDataIni   = Data Inicial de processamento                 			 ³±±
±±³          ³ dDataFim   = Data Final de processamento                   			 ³±±
±±³          ³ cContaIni  = Codigo Conta Inicial                          			 ³±±
±±³          ³ cContaFim  = Codigo Conta Final                            			 ³±±
±±³          ³ cCCIni     = Codigo C.Custo Inicial                        			 ³±±
±±³          ³ cCCFim     = Codigo C.Custo Final                          			 ³±±
±±³          ³ cItemIni   = Codigo Item Inicial                           			 ³±±
±±³          ³ cItemFim   = Codigo Item Final                             			 ³±±
±±³          ³ cClVlIni   = Codigo Cl.Valor Inicial                       			 ³±±
±±³          ³ cClVlFim   = Codigo Cl.Valor Final                         			 ³±±
±±³          ³ cMoeda     = Moeda		                                  			 ³±±
±±³          ³ cSaldos    = Tipos de Saldo a serem processados           			 ³±±
±±³          ³ aSetOfBook = Matriz de configuracao de livros            			 ³±±
±±³          ³ nTamCta    = Tamanho da conta                            			 ³±±
±±³          ³ cSegmento  = Indica qual o segmento será filtrado          			 ³±±
±±³          ³ cSegIni    = Conteudo inicial do segmento                  			 ³±±
±±³          ³ cSegFim    = Conteudo Final do segmento                    			 ³±±
±±³          ³ cFiltSegm  = Indica se filtrara ou nao segmento            			 ³±±
±±³          ³ lNImpMov   = Indica se imprime ou nao a coluna movimento   			 ³±±
±±³          ³ cAlias     = Alias para regua       	                      			 ³±±
±±³          ³ cHeader    = Entidade do cabecalho do relatorio            			 ³±±
±±³          ³ cIdent     = Identificador do arquivo a ser processado     			 ³±±
±±³          ³ lCusto     = Considera Centro de Custo?                   			 ³±±
±±³          ³ lItem      = Considera Item Contabil?                     			 ³±±
±±³          ³ lCLVL      = Considera Classe de Valor?                   			 ³±±
±±³          ³ lAtSldBase = Indica se deve chamar rot atual. saldo basico			 ³±±
±±³          ³ nInicio    = Moeda Inicial (p/ atualizar saldo)           			 ³±±
±±³          ³ nFinal     = Moeda Final (p/ atualizar saldo)             			 ³±±
±±³          ³ cFilde     = Filial inicial (p/ atualizar saldo)          			 ³±±
±±³          ³ cFilAte    = Filial final (p/atualizar saldo)             			 ³±±
±±³          ³ lImpAntLP  = Imprime lancamentos Lucros e Perdas?         			 ³±±
±±³          ³ dDataLP    = Data ultimo Lucros e Perdas                  			 ³±±
±±³          ³ nDivide    = Divide valores (100,1000,1000000)             		   	 ³±±
±±³          ³ lVlrZerado = Grava ou nao valores zerados no arq temporario			 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtbCta3Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
					cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
					cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
					lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
					nDivide,lVlrZerado)				
					
Local aSaveArea		:= GetArea()
Local aSaldoAnt		:= {}
Local aSaldoAtu		:= {}

Local cConta		:= ""
Local cCusto		:= ""
Local cItem			:= ""
Local cClVl			:= ""
Local cDescCta		:= ""
Local cDescCC		:= ""
Local cDescItem		:= ""
Local cDescClVl		:= ""
Local cMascara		:= ""

Local nSaldoAntD	:= 0
Local nSaldoAntC	:= 0 
Local nSldAnt		:= 0
Local nSaldoAtuD	:= 0
Local nSaldoAtuC	:= 0 
Local nSldAtu		:= 0
Local nSaldoDeb		:= 0 
Local nSaldoCrd		:= 0 
Local nMovimento	:= 0 
Local nTamItem		:= Len(CriaVar("CTD_ITEM"))
Local nTamClVl		:= Len(CriaVar("CTH_CLVL"))
Local nCont			:= 0 
Local nPos			:= 0
Local nDigitos		:= 0

If cAlias == "CTI"
	If cHeader == "CTT"		
		If !Empty(aSetOfBook[2])
			cMascara	:= aSetOfBook[2]
		EndIf
	EndIf
EndIf

// Verifica Filtragem por Segmento da Entidade
If !Empty(cSegmento)
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+cMascara)
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascara 
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == cSegmento
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)      
				Exit
			EndIf	
			dbSkip()
		EndDo	
	EndIf	
EndIf		



If cAlias == "CTI"		//Se for Balancete C.C x Cta x Item
	If cHeader == "CTT"    		
	
		dbSelectArea("CTT")
		dbSetOrder(1) 
		MsSeek(xFilial()+cCCIni,.T.)
		While !Eof() .And. CTT->CTT_FILIAL == xFilial() .And. CTT->CTT_CUSTO <= cCCFim
		
			If CTT->CTT_CLASSE == "1"
				dbSkip()
				Loop
			EndIf
					
			cCusto	:= CTT->CTT_CUSTO
			cDescCC := &("CTT->CTT_DESC"+cMoeda)
				
			If Empty(cDescCC)// Caso nao preencher descricao da moeda selecionada
				cDescCC := CTT->CTT_DESC01
			Endif			
			
			dbSelectArea("CT1")
			dbSetOrder(1)
			MsSeek(xFilial()+cContaIni,.T.)
			
			While !Eof() .And. CT1->CT1_FILIAL == xFilial() .And. CT1->CT1_CONTA <= cContaFim
			
				If CT1->CT1_CLASSE == "1"
					dbSkip()
					Loop
				EndIf			
								
				cConta	:= CT1->CT1_CONTA				
				
				cDescCta := &("CT1->CT1_DESC"+cMoeda)
				
				If Empty(cDescCta)// Caso nao preencher descricao da moeda selecionada
					cDescCta := CT1->CT1_DESC01
				Endif
				
				//Caso faca filtragem por segmento de item,verifico se esta dentro 
				//da solicitacao feita pelo usuario. 
				If !Empty(cSegmento)
					If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
						If  !(Substr(cConta,nPos,nDigitos) $ (cFiltSegm) ) 
							dbSkip()
							Loop
						EndIf	
					Else
						If 	Substr(cConta,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
							Substr(cConta,nPos,nDigitos) > Alltrim(cSegFim)
							dbSkip()
							Loop
						EndIf	
					Endif
				EndIf		
			    				

				aSaldoAnt := SaldoCT3(	cConta,cCusto,dDataIni,cMoeda,cSaldos,,	lImpAntLP,dDataLP)
				aSaldoAtu := SaldoCT3(	cConta,cCusto,dDataFim,cMoeda,cSaldos,,	lImpAntLP,dDataLP)

				nSaldoAntD 	:= aSaldoAnt[7]
				nSaldoAntC 	:= aSaldoAnt[8]
				nSldAnt		:= nSaldoAntC - nSaldoAntD
	
				nSaldoAtuD 	:= aSaldoAtu[4]
				nSaldoAtuC 	:= aSaldoAtu[5]          
				nSldAtu		:= nSaldoAtuC - nSaldoAtuD
	
				nSaldoDeb  	:= nSaldoAtuD - nSaldoAntD
				nSaldoCrd  	:= nSaldoAtuC - nSaldoAntC     
				
			    If nDivide > 1
					nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)		
					nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
				EndIf
			
				nMovimento	:= nSaldoCrd-nSaldoDeb

				If (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0) .And. ;
					(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
					dbSkip()
					Loop
				EndIf				
		
				dbSelectArea("cArqTmp")
				dbSetOrder(1)	
				If !MsSeek(cCusto+cConta+Space(nTamItem)+Space(nTamClVl))
					dbAppend()
					Replace CONTA 		With CT1->CT1_CONTA
					Replace DESCCTA		With cDescCta
 					Replace NORMAL    	With CT1->CT1_NORMAL
	 				Replace TIPOCONTA 	With CT1->CT1_CLASSE
					Replace GRUPO		With CT1->CT1_GRUPO
					Replace CTARES      With CT1->CT1_RES
					Replace SUPERIOR    With CT1->CT1_CTASUP
					Replace CUSTO		With cCusto
					Replace CCRES		With CTT->CTT_RES
					Replace TIPOCC  	With CTT->CTT_CLASSE
					Replace DESCCC		With cDescCC
				Endif   

		
				If nDivide > 1
					For nCont := 1 To Len(aSaldoAnt)
						aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
					Next nCont
					For nCont := 1 To Len(aSaldoAtu)
						aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
					Next nCont	
				EndIf	
				
				dbSelectArea("cArqTmp")
				dbSetOrder(1)
				Replace SALDOANT With aSaldoAnt[6]
				Replace SALDOATU With aSaldoAtu[1]			// Saldo Atual
	
				Replace  SALDODEB With nSaldoDeb				// Saldo Debito
				Replace  SALDOCRD With nSaldoCrd				// Saldo Credito
				If !lNImpMov
					Replace MOVIMENTO With nSaldoCrd-nSaldoDeb
				Endif              
			
				If lItem				
					dbSelectArea("CTD")
					dbSetOrder(1)	//Codigo de Item
					MsSeek(xFilial()+cItemIni,.T.)
					While !Eof() .And. CTD->CTD_FILIAL == xFilial() .And. CTD->CTD_ITEM <= cItemFim
						
	 					If CTD->CTD_CLASSE == "1"
							dbSkip()
							Loop
						EndIf           
						
						cItem	:= CTD->CTD_ITEM								
						
						cDescItem := &("CTD->CTD_DESC"+cMoeda)
					
						If Empty(cDescItem)// Caso nao preencher descricao da moeda selecionada
							cDescItem := CTD->CTD_DESC01
						Endif								
						
						//Caso faca filtragem por segmento de item,verifico se esta dentro 
						//da solicitacao feita pelo usuario. 
						If !Empty(cSegmento)
							If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
								If  !(Substr(cConta,nPos,nDigitos) $ (cFiltSegm) ) 
									dbSkip()
									Loop
								EndIf	
							Else
								If 	Substr(cConta,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
									Substr(cConta,nPos,nDigitos) > Alltrim(cSegFim)
									dbSkip()
									Loop
								EndIf	
							Endif
						EndIf		
								
						aSaldoAnt := SaldoCT4(	cConta,cCusto,cItem,dDataIni,cMoeda,cSaldos,,lImpAntLP,dDataLP)
						aSaldoAtu := SaldoCT4(	cConta,cCusto,cItem,dDataFim,cMoeda,cSaldos,,lImpAntLP,dDataLP)
	
						nSaldoAntD 	:= aSaldoAnt[7]
						nSaldoAntC 	:= aSaldoAnt[8]
						nSldAnt		:= nSaldoAntC - nSaldoAntD
		
						nSaldoAtuD 	:= aSaldoAtu[4]
						nSaldoAtuC 	:= aSaldoAtu[5]          
						nSldAtu		:= nSaldoAtuC - nSaldoAtuD
		
						nSaldoDeb  	:= nSaldoAtuD - nSaldoAntD
						nSaldoCrd  	:= nSaldoAtuC - nSaldoAntC     
					
					    If nDivide > 1
							nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)		
							nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
						EndIf
				
						nMovimento	:= nSaldoCrd-nSaldoDeb
	
						If (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0) .And. ;
							(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
							dbSkip()
							Loop
						EndIf				
			
						dbSelectArea("cArqTmp")
						dbSetOrder(1)	
						If !MsSeek(cCusto+cConta+cItem)
							dbAppend()
							Replace CONTA 		With CT1->CT1_CONTA
							Replace DESCCTA		With cDescCta
		 					Replace NORMAL    	With CT1->CT1_NORMAL
			 				Replace TIPOCONTA 	With CT1->CT1_CLASSE
							Replace GRUPO		With CT1->CT1_GRUPO
							Replace CTARES      With CT1->CT1_RES
							Replace SUPERIOR    With CT1->CT1_CTASUP
							Replace CUSTO		With cCusto
							Replace CCRES		With CTT->CTT_RES
							Replace TIPOCC  	With CTT->CTT_CLASSE
							Replace DESCCC		With cDescCC
							Replace ITEM		With cItem
							Replace DESCITEM	With cDescItem					
							Replace ITEMRES		With CTD->CTD_RES
						Endif   
					
						If nDivide > 1
							For nCont := 1 To Len(aSaldoAnt)
								aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
							Next nCont
							For nCont := 1 To Len(aSaldoAtu)
								aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
							Next nCont	
						EndIf	
						
						dbSelectArea("cArqTmp")
						dbSetOrder(1)
						Replace SALDOANT With aSaldoAnt[6]
						Replace SALDOATU With aSaldoAtu[1]			// Saldo Atual
		    	
						Replace  SALDODEB With nSaldoDeb				// Saldo Debito
						Replace  SALDOCRD With nSaldoCrd				// Saldo Credito
						If !lNImpMov
							Replace MOVIMENTO With nSaldoCrd-nSaldoDeb
						Endif              							  
							            
						If lClVl				
							dbSelectArea("CTH")
							dbSetOrder(1)	//Codigo da Cl.Valor
							MsSeek(xFilial()+cClVlIni,.T.)
							While !Eof() .And. CTH->CTH_FILIAL == xFilial() .And. CTH->CTH_CLVL <= cClVlFim
								
			 					If CTH->CTH_CLASSE == "1"
									dbSkip()
									Loop
								EndIf           
								
								cClVl	:= CTH->CTH_CLVL								
								
								cDescClVl := &("CTH->CTH_DESC"+cMoeda)
							
								If Empty(cDescClVl)// Caso nao preencher descricao da moeda selecionada
									cDescClVl := CTH->CTH_DESC01
								Endif							
								
								//Caso faca filtragem por segmento de item,verifico se esta dentro 
								//da solicitacao feita pelo usuario. 
								If !Empty(cSegmento)
									If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
										If  !(Substr(cConta,nPos,nDigitos) $ (cFiltSegm) ) 
											dbSkip()
											Loop
										EndIf	
									Else
										If 	Substr(cConta,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
											Substr(cConta,nPos,nDigitos) > Alltrim(cSegFim)
											dbSkip()
											Loop
										EndIf	
									Endif
								EndIf													
								
								aSaldoAnt := SaldoCTI(	cConta,cCusto,cItem,cClVl,dDataIni,cMoeda,cSaldos,,lImpAntLP,dDataLP)
								aSaldoAtu := SaldoCTI(	cConta,cCusto,cItem,cClVl,dDataFim,cMoeda,cSaldos,,lImpAntLP,dDataLP)
			
								nSaldoAntD 	:= aSaldoAnt[7]
								nSaldoAntC 	:= aSaldoAnt[8]
								nSldAnt		:= nSaldoAntC - nSaldoAntD
				
								nSaldoAtuD 	:= aSaldoAtu[4]
								nSaldoAtuC 	:= aSaldoAtu[5]          
								nSldAtu		:= nSaldoAtuC - nSaldoAtuD
				
								nSaldoDeb  	:= nSaldoAtuD - nSaldoAntD
								nSaldoCrd  	:= nSaldoAtuC - nSaldoAntC     
							
							    If nDivide > 1
									nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)		
									nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
								EndIf
						
								nMovimento	:= nSaldoCrd-nSaldoDeb
			
								If (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0) .And. ;
									(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
									dbSkip()
									Loop
								EndIf				
					
								dbSelectArea("cArqTmp")
								dbSetOrder(1)	
								If !MsSeek(cCusto+cConta+cItem+cClVl)
									dbAppend()
									Replace CONTA 		With CT1->CT1_CONTA
									Replace DESCCTA		With cDescCta
				 					Replace NORMAL    	With CT1->CT1_NORMAL
					 				Replace TIPOCONTA 	With CT1->CT1_CLASSE
									Replace GRUPO		With CT1->CT1_GRUPO
									Replace CTARES      With CT1->CT1_RES
									Replace SUPERIOR    With CT1->CT1_CTASUP
									Replace CUSTO		With cCusto
									Replace CCRES		With CTT->CTT_RES
									Replace TIPOCC  	With CTT->CTT_CLASSE
									Replace DESCCC		With cDescCC
									Replace ITEM		With cItem									
									Replace DESCITEM	With cDescItem					
									Replace CLVL		With cClVl
									Replace DESCCLVL	With cDescClVl
									Replace CLVLRES		With CTH->CTH_RES
								Endif   
							
								If nDivide > 1
									For nCont := 1 To Len(aSaldoAnt)
										aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
									Next nCont
									For nCont := 1 To Len(aSaldoAtu)
										aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
									Next nCont	
								EndIf	
								
								dbSelectArea("cArqTmp")
								dbSetOrder(1)
								Replace SALDOANT With aSaldoAnt[6]
								Replace SALDOATU With aSaldoAtu[1]			// Saldo Atual
				    	
								Replace  SALDODEB With nSaldoDeb				// Saldo Debito
								Replace  SALDOCRD With nSaldoCrd				// Saldo Credito
								If !lNImpMov
									Replace MOVIMENTO With nSaldoCrd-nSaldoDeb
								Endif              								            
								dbSelectArea("CTH")	
								dbSkip()           
							End
						EndIf			
								
						dbSelectArea("CTD")	
						dbSkip()           
					End
				EndIf			
				
				//Classe de Valor / C.Custo / Conta				
				If lClVl              
					cItem	:= Space(nTamItem)
					dbSelectArea("CTH")
					dbSetOrder(1)	//Codigo da Cl.Valor
					MsSeek(xFilial()+cClVlIni,.T.)
					While !Eof() .And. CTH->CTH_FILIAL == xFilial() .And. CTH->CTH_CLVL <= cClVlFim
								
	 					If CTH->CTH_CLASSE == "1"
							dbSkip()
							Loop
						EndIf           
								
						cClVl	:= CTH->CTH_CLVL								
								
						cDescClVl := &("CTH->CTH_DESC"+cMoeda)
							
						If Empty(cDescClVl)// Caso nao preencher descricao da moeda selecionada
							cDescClVl := CTH->CTH_DESC01
						Endif								
						
						//Caso faca filtragem por segmento de item,verifico se esta dentro 
						//da solicitacao feita pelo usuario. 
						If !Empty(cSegmento)
							If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
								If  !(Substr(cConta,nPos,nDigitos) $ (cFiltSegm) ) 
									dbSkip()
									Loop
								EndIf	
							Else
								If 	Substr(cConta,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
									Substr(cConta,nPos,nDigitos) > Alltrim(cSegFim)
									dbSkip()
									Loop
								EndIf	
							Endif
						EndIf		
								
						aSaldoAnt := SaldoCTI(	cConta,cCusto,cItem,cClVl,dDataIni,cMoeda,cSaldos,,lImpAntLP,dDataLP)
						aSaldoAtu := SaldoCTI(	cConta,cCusto,cItem,cClVl,dDataFim,cMoeda,cSaldos,,lImpAntLP,dDataLP)
			
						nSaldoAntD 	:= aSaldoAnt[7]
						nSaldoAntC 	:= aSaldoAnt[8]
						nSldAnt		:= nSaldoAntC - nSaldoAntD
				
						nSaldoAtuD 	:= aSaldoAtu[4]
						nSaldoAtuC 	:= aSaldoAtu[5]          
						nSldAtu		:= nSaldoAtuC - nSaldoAtuD
				
						nSaldoDeb  	:= nSaldoAtuD - nSaldoAntD
						nSaldoCrd  	:= nSaldoAtuC - nSaldoAntC     
							
					    If nDivide > 1
							nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)		
							nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
						EndIf
						
						nMovimento	:= nSaldoCrd-nSaldoDeb
			
						If (nMovimento = 0 .And. nSldAnt = 0 .And. nSldAtu = 0) .And. ;
							(nSaldoDeb = 0 .And. nSaldoCrd = 0) 
							dbSkip()
							Loop
						EndIf				
					
						dbSelectArea("cArqTmp")
						dbSetOrder(1)	
						If !MsSeek(cCusto+cConta+Space(nTamItem)+cClVl)
							dbAppend()
							Replace CONTA 		With CT1->CT1_CONTA
							Replace DESCCTA		With cDescCta
		 					Replace NORMAL    	With CT1->CT1_NORMAL
			 				Replace TIPOCONTA 	With CT1->CT1_CLASSE
							Replace GRUPO		With CT1->CT1_GRUPO
							Replace CTARES      With CT1->CT1_RES
							Replace SUPERIOR    With CT1->CT1_CTASUP
							Replace CUSTO		With cCusto
							Replace CCRES		With CTT->CTT_RES
							Replace TIPOCC  	With CTT->CTT_CLASSE
							Replace DESCCC		With cDescCC
							Replace CLVL		With cClVl
							Replace DESCCLVL	With cDescClVl           
							Replace CLVLRES		With CTH->CTH_RES
						Endif   
							
						If nDivide > 1
							For nCont := 1 To Len(aSaldoAnt)
								aSaldoAnt[nCont] := Round(NoRound((aSaldoAnt[nCont]/nDivide),3),2)
							Next nCont
							For nCont := 1 To Len(aSaldoAtu)
								aSaldoAtu[nCont] := Round(NoRound((aSaldoAtu[nCont]/nDivide),3),2)
							Next nCont	
						EndIf	
								
						dbSelectArea("cArqTmp")
						dbSetOrder(1)
						Replace SALDOANT With aSaldoAnt[6]
						Replace SALDOATU With aSaldoAtu[1]			// Saldo Atual
				    	
						Replace  SALDODEB With nSaldoDeb				// Saldo Debito
						Replace  SALDOCRD With nSaldoCrd				// Saldo Credito
						If !lNImpMov
							Replace MOVIMENTO With nSaldoCrd-nSaldoDeb
						Endif              								            						
						dbSelectArea("CTH")
						dbSkip()
					End
		        EndIf				
				dbSelectArea("CT1")
		 		dbSkip()		
			End																
			dbSelectArea("CTT")
			dbSkip() 
		End
    EndIf
EndIf

RestArea(aSaveArea)

Return()
					
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb4CtaSup ³Autor  ³ Simone Mie Sato       ³ Data ³ 07.10.04 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualizacao de sinteticas de c.custo/conta/item/Cl.Valor    			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb4CtaSup(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias	= Alias a ser utilizado             	               		 ³±±
±±³          ³ lNImpMov = Se imprime entidades sem movimento		               	 ³±±
±±³          ³ cMoeda	= Moeda                              	              		 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb4CtaSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,cHeader)
		
Local aSaveArea	:= GetArea()				
Local cCadAlias	:= ""
Local cCodSup	:= ""     
Local cCodEnt	:= ""
Local cConta	:= ""
Local cDescCta	:= ""
Local cOutEnt	:= ""
Local cEntSup	:= ""
Local cDescEnt	:= ""
Local cSeek		:= ""
Local nSaldoAnt	:= 0
Local nSaldoAtu	:= 0
Local nSaldoDeb	:= 0
Local nSaldoCrd	:= 0
Local nMovimento:= 0
Local nSaldoAntD:= 0
Local nSaldoAntC:= 0
Local nSaldoAtuD:= 0
Local nsaldoAtuC:= 0
Local nRegTmp	:= 0
Local nMeter	:= 0
local cCpoSup	:= ""

dbSelectArea("cArqTmp")	
dbGoTop()  
If ValType(oMeter) == "O"
	nMeter	:= 0
	oMeter:SetTotal(cArqTmp->(RecCount()))
	oMeter:Set(0)
EndIf    

While!Eof()                                 
	If cAlias == "CTI"     
		If cHeader == "CTT"			
			//Somar somente o que for do CT3 => para nao duplicar os valores do CT4/CTI com CT3.			
			If !Empty(cArqTmp->ITEM) .Or. !Empty(cArqTmp->CLVL)
				dbSkip()
				Loop
			EndIf						
		EndIf
	EndIf                                            

	nSaldoAnt:= SALDOANT
	nSaldoAtu:= SALDOATU
	nSaldoDeb:= SALDODEB
	nSaldoCrd:= SALDOCRD   
	nMovimento:= MOVIMENTO

	nRegTmp := Recno()      
	
	If cAlias == 'CTI'      	   
		If cHeader == "CTT"		   
			cCadastro := "CTT"
			cEntid 	 := cArqTmp->CUSTO
			cCodRes	 := cArqTmp->CCRES
			cTipoEnt := cArqTmp->TIPOCC
			cDescEnt := cArqTmp->DESCCC			
			cCpoSup	 := "CTT_CCSUP"	   
		EndIf		
	EndIf
	


	DbSelectArea(cCadastro)
	cEntidG := cEntid
	dbSetOrder(1)
	MsSeek(xFilial(cCadastro)+cEntidG)
		
	While !Eof() .And. &(cCadastro + "->" + cCadastro + "_FILIAL") == xFilial()
		
        nReg := cArqTmp->(Recno())
        
		dbSelectArea("CT1")	
		dbSetOrder(1)      
		cContaSup := cArqTmp->CONTA
		MsSeek(xFilial("CT1")+ cContaSup)
		
		If cEntid = cEntidG
			cContaSup := CT1->CT1_CTASUP
			MsSeek(xFilial("CT1")+ cContaSup)
		Endif
		
		While !Eof() .And. CT1->CT1_FILIAL == xFilial()
	
			cDesc := &("CT1->CT1_DESC"+cMoeda)
			If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
				cDesc := CT1->CT1_DESC01
			Endif
	
			cDescEnt := &(cCadastro + "->" + cCadastro + "_DESC"+cMoeda)
			If Empty(cDescEnt)		// Caso nao preencher descricao da moeda selecionada
				cDescEnt := &(cCadastro + "->" + cCadastro + "_DESC01")
			Endif
			cCodRes  := &(cCadastro + "->" + cCadastro + "_RES")
			cTipoEnt := &(cCadastro + "->" + cCadastro + "_CLASSE")
	
			dbSelectArea("cArqTmp")
			dbSetOrder(1)      
			If ! MsSeek(cEntidG+cContaSup)
				dbAppend()
				Replace CONTA		With cContaSup	
				Replace DESCCTA 	With cDesc
				Replace NORMAL   	With CT1->CT1_NORMAL
				Replace TIPOCONTA	With CT1->CT1_CLASSE
				Replace GRUPO		With CT1->CT1_GRUPO
				Replace CTARES		With CT1->CT1_RES
				Replace SUPERIOR	With CT1->CT1_CTASUP

				If cAlias == 'CTI'
					If cHeader == "CTT"					
						Replace CUSTO With cEntidG		 
						Replace CCRES With cCodRes
						Replace TIPOCC With cTipoEnt
						Replace DESCCC With cDescEnt
				        If !Empty(cArqTmp->ITEM)
							dbSelectArea("CTD")        
							dbSetOrder(1)
							If MsSeek(xFilial()+cArqTmp->ITEM)
								Replace ITEM With cArqTmp->ITEM
							    Replace ITEMRES With CTD->CTD_RES
							    If cMoeda == '01'
					    			Replace DESCITEM With CTD->CTD_DESC01
					    		Else 
					    			If !Empty(&("CTD->CTD_DESC"+cMoeda))
						    			Replace DESCITEM With &("CTD->CTD_DESC"+cMoeda)
						    		Else
						    			Replace DESCITEM With CTD->CTD_DESC01					    			
					    		    EndIf
					    		EndIf
    	    				EndIf
  						EndIf				    
				        If !Empty(cArqTmp->CLVL)
							dbSelectArea("CTH")        
							dbSetOrder(1)
							If MsSeek(xFilial()+cArqTmp->CLVL)
								Replace CLVL With cArqTmp->CLVL
							    Replace CLVLRES With CTH->CTH_RES
							    If cMoeda == '01'
					    			Replace DESCCLVL With CTH->CTH_DESC01
					    		Else 
					    			If !Empty(&("CTH->CTH_DESC"+cMoeda))
						    			Replace DESCCLVL With &("CTH->CTH_DESC"+cMoeda)
						    		Else
						    			Replace DESCCLVL With CTH->CTH_DESC01					    			
					    		    EndIf
					    		EndIf
    	    				EndIf
  						EndIf				    
					 EndIf
				EndIf
			EndIf    
			dbSelectArea("cArqTmp")
			Replace	 SALDOANT With SALDOANT + nSaldoAnt
			Replace  SALDOATU With SALDOATU + nSaldoAtu
			Replace  SALDODEB With SALDODEB + nSaldoDeb
			Replace  SALDOCRD With SALDOCRD + nSaldoCrd
			If !lNImpMov
				Replace MOVIMENTO With MOVIMENTO + nMovimento
			Endif
	   		
			dbSelectArea("CT1")
			cContaSup := CT1->CT1_CTASUP
			If Empty(CT1->CT1_CTASUP) //.And. Empty(&(cCadastro + "->" + cCpoSup))
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea("CT1")
				Exit
			EndIf
	
			dbSelectArea("cArqTmp")
			dbGoto(nRegTmp)
			dbSelectArea("CT1")
			cContaSup := CT1->CT1_CTASUP
			If Empty(cContaSup) .And. Empty(&(cCadastro + "->" + cCpoSup))
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea("CT1")
			EndIf		
			MsSeek(xFilial("CT1")+ cContaSup)
		EndDo
		dbSelectArea("cArqTmp")
		dbGoto(nReg)
		DbSelectArea(cCadastro)
		cEntidG := &cCpoSup
		If Empty(cEntidG)		// Ultimo Nivel gerencial
			Exit
		EndIf
		MsSeek(xFilial(cCadastro)+cEntidG)
	EndDo
	dbSelectArea("cArqTmp")
	dbGoto(nRegTmp)
	dbSkip()
	If ValType(oMeter) == "O"	
		nMeter++
   		oMeter:Set(nMeter)					
  	EndIf
EndDo

RestArea(aSaveArea)

Return


