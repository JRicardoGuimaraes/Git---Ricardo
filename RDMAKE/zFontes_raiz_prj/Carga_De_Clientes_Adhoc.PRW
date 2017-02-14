#include "rwmake.ch"    
#include "topconn.ch"   
#INCLUDE "tbiconn.ch" 
#Include "Protheus.Ch"

*---------------------------------------------------------------------------*
* Criado por  : Jesus Oliveira       -          Em: 14/08/2009              *
* Objetivo    : Efetuar a carga inicial dos clientes vindos do Adhoc        *
*---------------------------------------------------------------------------*
User Function CLIADHOC
              
  //Abre o processo para exibir em uma tela temporária o progress bar
	//Private oProcess := NIL //Tela com 2 réguas
	//oProcess := MsNewProcess():New({|lEnd| IMPORTAR(lEnd,oProcess)},"Processando","Lendo...",.T.) //Tela com 2 réguas
  Processa( {|lEnd| IMPORTAR(@lEnd)}, "Aguarde...","Executando rotina.", .T. )

	//tela com duas reguas
	//oProcess:Activate()

return

//Static Function IMPORTAR(lEnd,oObj)
Static Function IMPORTAR(lEnd)

	// QUERY PARA CONTAR OS REGISTROS
	_CQRY := "SELECT   "
	_CQRY += " count(*) as QTDE "
	_CQRY += "FROM Temp_Clientes_Adhoc "
	
	TCQUERY _CQRY ALIAS "TCLICnt" NEW
	
	DBSELECTAREA("TCLICnt") ; DBGOTOP()
  nCnt := TCLICnt->QTDE
  DBSELECTAREA("TCLICnt") ; dbCloseArea()
  
	//Barra de progresso
  //oObj:SetRegua1(nCnt) //Para régua 1 e 2 para a segunda	
	ProcRegua(nCnt)
	/*Exemplo de um "for"
	For j:=1 to Len(aReg[ny])
		FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
	Next j*/

	// QUERY PARA PEGAR OS CLIENTES NA TABELA TEMPORÁRIA
	_CQRY := "SELECT   "
	_CQRY += " 	* "
	_CQRY += "FROM Temp_Clientes_Adhoc "
	
	TCQUERY _CQRY ALIAS "TCLI" NEW
	
	DBSELECTAREA("TCLI") ; DBGOTOP()
	iCod := 0
	WHILE !EOF()
		
		// Buscar código da região na tabela DUY
		sRegiao := ""
		Qry_aux := " SELECT * FROM " + RetSqlName("DUY") + " DUY "
		Qry_aux += " 	WHERE DUY_DESCRI = '"+TCLI->Cidade+"' and (RTRIM(DUY_EST) <> '') "                             
		TCQUERY Qry_aux ALIAS "tDUY" NEW
		DbSelectArea("tDUY") ; dbGoTop()		                               
		
		If !EOF()
			//MsgInfo("CNPJ ->"+TCLI->CNPJ_Microsiga+" - Regiao ->"+tDUY->DUY_DESCRI, "Informação")
		 	sRegiao := tDUY->DUY_GRPVEN
		Else
		  sRegiao := "999999"
		EndIf
		
		DbSelectArea("tDUY")  ; dbCloseArea()

		// Gravo as informações na tabela SA1010 
		dbSelectArea("SA1")
		dbSetOrder(1)
		If !dbSeek(Xfilial("SA1")+TCLI->Codigo_MS)
			RecLock("SA1",.T.)
	    	SA1->A1_FILIAL := xFilial("SA1") // Obrigatorio
    	  SA1->A1_COD := TCLI->Codigo_MS //Obrigatorio
     		SA1->A1_LOJA := "01" //Obrigatorio
	    	SA1->A1_NOME := substr(TCLI->Descripcion,01,40) //Obrigatorio
		    SA1->A1_PESSOA := "J"
			  SA1->A1_NREDUZ := substr(TCLI->Descripcion,01,20) //Obrigatorio
	    	SA1->A1_END := substr(TCLI->Endereco,01,40) //Obrigatorio
    		SA1->A1_TIPO := "R" //Obrigatorio
			  SA1->A1_MUN := substr(TCLI->Cidade,01,30) // Obrigatorio
    		SA1->A1_EST := substr(TCLI->Estado,01,02) // Obrigatorio
    		SA1->A1_BAIRRO := substr(TCLI->Bairro,01,30)
    		SA1->A1_TEL := substr(TCLI->Telefone,01,15)
	    	SA1->A1_CGC := TCLI->CNPJ_Microsiga	  
	    	SA1->A1_BOLETO := "N"	  
	    	SA1->A1_FATURA := "N"	  
	    	SA1->A1_CDRDES := sRegiao
			MsUnLock()
		//Caso o cliente já exista, atualizo a região
		Else
			RecLock("SA1",.F.)
	    	SA1->A1_CDRDES := sRegiao
			MsUnLock()
		  //MsgInfo("Região "+sRegiao+" Atualizada!", "Informação")
		EndIf
		
		DbSelectArea("SA1")  ; dbCloseArea()
		
		iCod := iCod+1  
		//Incrementa a barra de progressão
		//oObj:IncRegua1("Processando alterações: "+Ltrim(Rtrim(str(iCod)))) //Para tela com mais de uma régua
		IncProc("Processando alterações: "+Ltrim(Rtrim(str(iCod))))
		DBSELECTAREA("TCLI") ; DBSKIP()

	END
  MsgInfo("Clientes cadastrados com sucesso! Foram importados "+Ltrim(Rtrim(str(iCod)))+" clientes.", "Informação")
	DBSELECTAREA("TCLI") ; DBCLOSEAREA()
return                                  
