#include "rwmake.ch"    
#include "topconn.ch"   
#INCLUDE "tbiconn.ch" 
#Include "Protheus.Ch"
  
/*
*---------------------------------------------------------------------------*
* Criado por  : Jesus Oliveira       -          Em: 27/01/2010              *
* Objetivo    : Validar as informações dos títulos que irão para a PSA no   *
*               Lote II.                                                    *
*---------------------------------------------------------------------------* 
*/

*--------------------------------------------------------------------------------------------------------------------------*
User Function GEFVALLT2(pDOC, pFilial, pPrefixo, pCC, pCD, pOI, pZI_OI, pTipo_Despesa, pProcesso, pNFE, pEspecie, pChvCte)
*--------------------------------------------------------------------------------------------------------------------------* 
Local _aArea := GetArea()

Private bRetorno := .T.
Private sErrata := ""

  if VALIDAR_CAMPOS_PSA(pDOC, pFilial, pPrefixo, pCC, pCD, pOI, pZI_OI)
    bRetorno := .T.
  endif
  
  if bRetorno
  	if VALIDAR_PROCESSO_RMA(pDOC, pFilial, pPrefixo, pTipo_Despesa, pProcesso)
     	bRetorno := .T.
    else
     	bRetorno := .F.   
    endif
  endif  
  
  // Valida se é um RPS e existe o número da NF-e  - 30/06/2010
  If bRetorno
  	If Empty(pNFE) .and. pEspecie = "RPS"  // RPS - Numero de NF-e
		bRetorno := .F. 
		sErrata := "RPS sem a NF-e informada no sistema.  Provavelmente não foi feito a retorno da Prefeitura." 
		conout("RPS sem a NF-e informada no sistema.  Provavelmente não foi feito a retorno da Prefeitura.")

	 	fGravaErrata(pDOC, pFilial, pPrefixo)  	

  	EndIf
  EndIf
  
  // Valida se CT-e foi gerado e não transmitido - 30/10/2013
  If bRetorno
  	If Empty(pChvCte) .and. pEspecie = "CTE"  // RPS - Numero de NF-e
		bRetorno := .F. 
		sErrata := "CT-e não transmitido/validado pela SEFAZ. " 
		conout("CT-e não transmitido/validado pela SEFAZ.")

	 	fGravaErrata(pDOC, pFilial, pPrefixo)

  	EndIf
  EndIf  
/*
  // Por: Ricardo - Em 01/07/2011 - Motivo: Não enviar na interface Lote I, os CTRC´s do TLA que esteja sem NF 	
  If bRetorno .AND. (pPrefixo = "CTA" .OR. pPrefixo = "CTV")
   	 dbSelectArea("SZ5") ; dbSetOrder(1)
   	 If !dbSeek(pFilial + AllTrim(pDOC))
		bRetorno := .F.
	EndIf
  EndIf	
*/  
RestArea(_aArea)
return bRetorno

*-------------------------------------------------------------------------------------------------*
Static Function VALIDAR_CAMPOS_PSA(pDOC, pFilial, pPrefixo, pCC, pCD, pOI, pZI_OI)
*-------------------------------------------------------------------------------------------------*


/*

Retirado por andré Costa / Ricardo pois a errata esta validando e a PSA nao quer que acontecça.
Em 30/10/2014
Solicitação da Laudiceia

Local _aArea := GetArea()

DbSelectArea("SZI")
DbSetorder(1)

//conout("VALIDAR_CAMPOS_PSA")
     
// Valida os campos Centro de Custo PSA, Conta Despesa e Ordem interna
if (((pCC <> "").and.(pCC <> nil)).and.((pCD <> "").and.(pCD <> nil)).and.((pOI = "").or.(pOI = nil)))

 		// If EMPTY(Alltrim(pCD))
			// bRetorno := .F. 
			//Aviso("Atencao","O campo Cnt.Despesa deve ser preenchido quando o cliente devedor for a PSA!",{"Continuar"})
		//ElseIf EMPTY(Alltrim(pCC))
		//	bRetorno := .F. 
			// Aviso("Atencao","O campo C.Custo PSA deve ser preenchido quando o cliente devedor for a PSA!",{"Continuar"})   

	If Empty(pOI) .AND. POSICIONE("SZG",1,xFilial("SZG")+pCC,"ZG_OIOBRIG") == "S"
		bRetorno := .F. 
		sErrata := "A Ordem Interna PSA é obrigatória para o C.Custo PSA informado."
	ElseIf !Empty(pOI) .AND. POSICIONE("SZG",1,xFilial("SZG")+pCC,"ZG_OIOBRIG") <> "S"
		bRetorno := .F. 
		sErrata := "O C.Custo PSA informado não requer Ordem Interna.  Favor manter o campo OI em branco ou alterar o CC."
			
	ElseIf !Empty(pOI) .AND. POSICIONE("SZG",1,xFilial("SZG")+pCC,"ZG_OIOBRIG") == "S"
	    	If !Dbseek( xFilial("SZI")+PadR(pCC,TamSX3("ZI_CCONT")[1]) + PadR(pCD,TamSX3("ZI_CONTA")[1]) + PadR(pOI,TamSX3("ZI_OI")[1]) )
		   		sErrata := "Os campos C.Custo PSA,Cnt.Despesa e Ord.Interna nãi foram encontrados na tabela SZI!" 
		   		bRetorno := .F.
		   	Else
		   		bRetorno := .T.			   		
			Endif		
	EndIf  
  
//    bRetorno := .T.
else  
	If Empty(pOI) .AND. POSICIONE("SZG",1,xFilial("SZG")+pCC,"ZG_OIOBRIG") == "S"
		bRetorno := .F. 
		sErrata := "A Ordem Interna PSA é obrigatória para o C.Custo PSA informado."
	ElseIf !Empty(pOI) .AND. POSICIONE("SZG",1,xFilial("SZG")+pCC,"ZG_OIOBRIG") <> "S"
		bRetorno := .F. 
		sErrata := "O C.Custo PSA informado não requer Ordem Interna.  Favor manter o campo OI em branco ou alterar o CC."
			
	ElseIf !Empty(pOI) .AND. POSICIONE("SZG",1,xFilial("SZG")+pCC,"ZG_OIOBRIG") == "S"
//    	If !Dbseek(xFilial("SZI")+pCC+pCD+pOI)
    	If !Dbseek( xFilial("SZI")+PadR(pCC,TamSX3("ZI_CCONT")[1]) + PadR(pCD,TamSX3("ZI_CONTA")[1]) + PadR(pOI,TamSX3("ZI_OI")[1]) )
	   		sErrata := "Os campos C.Custo PSA,Cnt.Despesa e Ord.Interna nãi foram encontrados na tabela SZI!"
	   		bRetorno := .F.
	   	Else
	   		bRetorno := .T.			   		
		Endif		
	EndIf    
endif 

if (sErrata <> "")  
	 fGravaErrata(pDOC, pFilial, pPrefixo)  	
endif

RestArea(_aArea)
*/
return bRetorno

*-----------------------------------------------------------------------------------------*
Static Function VALIDAR_PROCESSO_RMA(pDOC, pFilial, pPrefixo, pTipo_Despesa, pProcesso)
*-----------------------------------------------------------------------------------------*
// Local bRetorno := .T.

//conout("VALIDAR_PROCESSO_RMA")

  // Valida o Campo do PCB de acordo com a regra I,E,O passada pela PSA
  if (pTipo_Despesa = "I")
	  if (len(ltrim(rtrim(pProcesso))) >= 10 )
	    if (substr(ltrim(rtrim(pProcesso)), 1, 4) = "PCB-") .or.;
	       (substr(ltrim(rtrim(pProcesso)), 1, 5) = "DLPR-") .or.;
	       (ltrim(rtrim(pProcesso)) = "DIVS - DLPR")
	      bRetorno := .T.
	    else  
	      // bRetorno := .F.
	      // sErrata := "Quando o Tipo Despesa for preenchido como I, o campo Processo_RMA(Ref. GEFCO) deve ser preenchido como (PCB-XXXXXX ou DIVS - DLPR)."
	      bRetorno := .T.	      
	    endif
	  else   
	  //  if (len(ltrim(rtrim(pProcesso))) < 10 ).and.(len(ltrim(rtrim(pProcesso))) <> 0).and.;
	   // 	 (substr(ltrim(rtrim(pProcesso)), 1, 7) = "DIVS - ")
	    	 bRetorno := .T.
	 //	  else  
	  //	  bRetorno := .F.
	  //  	sErrata := "Quando o Tipo Despesa for preenchido como I, o campo Processo_RMA(Ref. GEFCO) deve ser preenchido como (PCB-XXXXXX ou DIVS - VN)."
	  //  endif 
	  endif  
  endif 
  
  if (pTipo_Despesa = "E")
	  if (len(ltrim(rtrim(pProcesso))) <> 0)
	    bRetorno := .T.
	  else  
	    bRetorno := .F.
	    sErrata := "Quando o Tipo Despesa for preenchido como E, o campo Processo_RMA(Ref. GEFCO) deve ser preenchido com o processo de exportação."
	  endif   
  endif 

  if (pTipo_Despesa = "O")
	  if (len(ltrim(rtrim(pProcesso))) = 0)
	    bRetorno := .T.
	  else  
	    bRetorno := .F.
	    sErrata := "Quando o Tipo Despesa for preenchido como O, o campo Processo_RMA(Ref. GEFCO) não deve ser preenchido."
	  endif   
  endif 

  if (sErrata <> "")  
	 fGravaErrata(pDOC, pFilial, pPrefixo)  	
  endif
  	
return bRetorno

*------------------------------------------------------*
Static Function fGravaErrata(pDOC, pFilial, pPrefixo)
*------------------------------------------------------*
Local _aArea := GetArea()

//Gravo Erratas na SZP
dbSelectArea("SZP")
dbSetOrder(3) // Chave
If !dbSeek(pFilial+pDOC+pPrefixo)
	RecLock("SZP",.T.)
   	SZP->ZP_FILIAL := pFilial // Filial do Documento
   	SZP->ZP_LOTE := sNumLote //Número do Lote sendo gerado
   	SZP->ZP_DATA := DDATABASE //Data do servidor
   	SZP->ZP_DOC := pDOC //Documento
  	SZP->ZP_PREFIXO := pPrefixo //Prefixo do documento
    SZP->ZP_ERRATA := sErrata
	MsUnLock()
	//Caso DOC já exista, atualizo o campo ERRATA
Else
	RecLock("SZP",.F.)
   	SZP->ZP_ERRATA := sErrata
	MsUnLock()
EndIf
		
DbSelectArea("SZP")

RestArea(_aArea)
Return
