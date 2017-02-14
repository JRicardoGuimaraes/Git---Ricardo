#INCLUDE "rwmake.ch"  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"   
#INCLUDE "tbiconn.ch"     

/*
*----------------------------------------------------------------------------*
* Criado por  : Jesus Oliveira       -          Em: 05/03/2010               *
* Objetivo    : Envio de e-mail com errata do Lote II para os usuários       *
*----------------------------------------------------------------------------*
*/

User Function GEFMAILLT2(pMenu)

  if (pMenu = nil)
  	//Abre o processo para exibir em uma tela temporária o progress bar
  	Processa( {|lEnd| EmailGeral(@lEnd,pMenu)},   "Aguarde...","Gerando e-mail Geral das erratas do Lote II.", .T. )
  	Processa( {|lEnd| EmailFiliais(@lEnd,pMenu)}, "Aguarde...","Gerando e-mail para Filiais das erratas do Lote II.", .T. )
  else
    //Mensagem de alerta no console para execução da rotina em schedule
	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT	EMPRESA "01" FILIAL "01" TABLES "SZP", "SM0", "SX6"

    ConOut("Iniciado geração de envio dos e-mails das erratas do Lote II - "+dtos(dDatabase)+substr(Time(),1,2)+substr(Time(),4,2)+substr(Time(),7,2)) 

	EmailGeral()
  	EmailFiliais()
  	
	RpcClearEnv()	// Libera o Environment  	
  endif

Return

Static Function EmailGeral()

	cAssunto := "Errata de Exportação Lote II - " + dTOc(dDataBase)
	cAnexo   := ""
	cCc      := "" 
	cPara    := GETMV("MV_MAILLT2")
	cDe      := "relatorio@gefco.com.ar" 
  
  /* Buscar dados da SZP */
	_CQRY := "select "
	_CQRY += " * "
	_CQRY += "from "
	_CQRY += " SZP010  "
	_CQRY += "where "
	_CQRY += " ZP_ERRATA <> '' "
	_CQRY += " AND D_E_L_E_T_ = '' "

    // Por: Ricardo - Em: 09/01/2014 - Passou a verificar se o título no CAR foi baixado ou excluído
	_CQRY := " SELECT SZP.*, SE1.D_E_L_E_T_ AS E1_DELETADO, E1_BAIXA "
	_CQRY += "   FROM SZP010 SZP, SE1010 SE1 "
	_CQRY += "   WHERE ZP_ERRATA <> '' "
	_CQRY += "   AND SZP.D_E_L_E_T_ = '' "
	_CQRY += "   AND ZP_FILIAL = E1_FILIAL "
	_CQRY += "   AND ZP_DOC = E1_NUM "
	_CQRY += "   AND ZP_PREFIXO = E1_PREFIXO "
						 
	TCQUERY _CQRY ALIAS "TLOTEII" NEW
	
	DBSELECTAREA("TLOTEII") ; DBGOTOP()
	iCod := 0
	cMsg := "<b>Segue a lista de Erratas de exportação da Interface Lote II: </b>" + "<BR>"
	cMsg += "<BR>"
	WHILE !EOF() 
	
        // Por: Ricardo - Em: 09/01/2014 - Passou a verificar se o título no CAR foi baixado ou excluído
        If TLOTEII->E1_DELETADO="*" .OR. !EMPTY(TLOTEII->E1_BAIXA)
        	// Deleta o registro de errata
        	fDeletaReg(TLOTEII->R_E_C_N_O_)   
        	
        	dbSelectArea("TLOTEII") ; dbSkip()
        	Loop
        EndIf	
	    //Monta i corpo do e-mail com as erratas
		cMsg += "<b>Data Geração:</b> " + Trim(TLOTEII->ZP_DATA) + " - " 
		cMsg += "<b>Filial:</b> " + Trim(TLOTEII->ZP_FILIAL) + " - "
		cMsg += "<b>Documento:</b> " + TLOTEII->ZP_DOC + " - "
		cMsg += "<b>Prefixo:</b> " + TLOTEII->ZP_PREFIXO + " - "
		cMsg += "<b>Errata:</b> " + Trim(TLOTEII->ZP_ERRATA) + "<BR>"
	
		iCod := iCod + 1
		DBSELECTAREA("TLOTEII") ; DBSKIP()

	END
  DBSELECTAREA("TLOTEII") ; DBCloseArea()
  cMsg += "<BR>"
	cMsg += "<b>Totalizando "+StrZero(iCod,5)+" títulos em errata. Favor verificar!</b>"
  cMsg += "<BR>"
	cMsg += "Esta é uma mensagem automática do sistema Protheus. Favor não responder!"
 
	if iCod > 0
		*---------------------------------------------*
		U_EnvEmail(cDe,cPara,cCc,cAssunto,cMsg,cAnexo)
		*---------------------------------------------*	 
	endif

Return

Static Function EmailFiliais()

  iCod := 0
  /* Buscar dados da SZP */
	_CQRY := "select "
	_CQRY += " * "
	_CQRY += "from "
	_CQRY += " SZX010  "
	_CQRY += "where "
	_CQRY += " D_E_L_E_T_ <> '*' "
						 
	TCQUERY _CQRY ALIAS "Filiais" NEW
	
	DBSELECTAREA("Filiais") ; DBGOTOP()
	WHILE !EOF() 
	
	  /* Buscar dados da SZP */
	  /*
		_CQRY := "select "
		_CQRY += " * "
		_CQRY += "from "
		_CQRY += " SZP010  "
		_CQRY += "where "
		_CQRY += " ZP_ERRATA <> '' "
		_CQRY += " AND ZP_FILIAL = '"+Filiais->ZX_FILIAL+"' "	
		_CQRY += " AND D_E_L_E_T_ = '' "
       */
       
       // Por: Ricardo - Em: 09/01/2014 - Passou a verificar se o título no CAR foi baixado ou excluído
		_CQRY := " SELECT SZP.*, SE1.D_E_L_E_T_ AS E1_DELETADO, E1_BAIXA "
		_CQRY += "   FROM SZP010 SZP, SE1010 SE1 "
		_CQRY += "   WHERE ZP_ERRATA <> '' "
		_CQRY += "   AND ZP_FILIAL = '"+Filiais->ZX_FILIAL+"' "	
		_CQRY += "   AND SZP.D_E_L_E_T_ = '' "
		_CQRY += "   AND ZP_FILIAL = E1_FILIAL "
		_CQRY += "   AND ZP_DOC = E1_NUM "
		_CQRY += "   AND ZP_PREFIXO = E1_PREFIXO "
							 
		TCQUERY _CQRY ALIAS "TLOTEII" NEW
		
		DBSELECTAREA("TLOTEII") ; DBGOTOP()
    
		if TLOTEII->ZP_FILIAL <> nil
			cAssunto := "Errata de Exportação Lote II - Filial: "+Trim(Filiais->ZX_DESCRIC)+" - " + dTOc(dDataBase)
			cAnexo   := ""
			cCc      := "" 
			cPara    := Trim(Filiais->ZX_MAILERR)
			if Trim(cPara) = ""
			  cPara  := "jose.guimaraes@gefco.com.br"
			  cAssunto += " Sem dest. cadastrados!"
			endif
			// cDe      := "atende.ti@gefco.com.br"                 
			cDe      := GETMV("MV_RELFROM")
			iCod := 0
			cMsg := "<b>Segue a lista de Erratas de exportação da Interface Lote II: </b>" + "<BR>"
			cMsg += "<BR>"
		endif
		
		WHILE !EOF() 
		
	        // Por: Ricardo - Em: 09/01/2014 - Passou a verificar se o título no CAR foi baixado ou excluído
	        If TLOTEII->E1_DELETADO="*" .OR. !EMPTY(TLOTEII->E1_BAIXA)
	        	// Deleta o registro de errata
	        	fDeletaReg(TLOTEII->R_E_C_N_O_)
	        	dbSelectArea("TLOTEII") ; dbSkip()
	        	Loop
	        EndIf
        
		    //Monta i corpo do e-mail com as erratas
			cMsg += "<b>Data Geração:</b> " + Trim(TLOTEII->ZP_DATA) + " - " 
			cMsg += "<b>Filial:</b> " + Trim(TLOTEII->ZP_FILIAL) + " - "
			cMsg += "<b>Documento:</b> " + TLOTEII->ZP_DOC + " - "
			cMsg += "<b>Prefixo:</b> " + TLOTEII->ZP_PREFIXO + " - "
			cMsg += "<b>Errata:</b> " + Trim(TLOTEII->ZP_ERRATA) + "<BR>"
		
			iCod := iCod + 1
			DBSELECTAREA("TLOTEII") ; DBSKIP()
	
		END
	  DBSELECTAREA("TLOTEII") ; DBCloseArea()
	 
		if iCod > 0
		  cMsg += "<BR>"
			cMsg += "<b>Totalizando "+StrZero(iCod,5)+" títulos em errata. Favor verificar!</b>"
		  cMsg += "<BR>"
			cMsg += "Esta é uma mensagem automática do sistema Protheus. Favor não responder!"
			*---------------------------------------------*
			U_EnvEmail(cDe,cPara,cCc,cAssunto,cMsg,cAnexo)
			*---------------------------------------------*
			iCod = 0	 
		endif
		
		DBSELECTAREA("Filiais") ; DBSKIP()

	END
  DBSELECTAREA("Filiais") ; DBCloseArea()
	
Return

*************************************************
Static Function fDeletaReg(_nRecNo)
Local _aArea := GetArea()

dbSelectArea("SZP")
dbGoTo(_nRecNo)
RecLock("SZP",.F.)
	SZP->(dbDelete())
SZP->(MsUnLock())

RestArea(_aArea)
Return
