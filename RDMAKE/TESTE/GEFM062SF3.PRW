#include "rwmake.ch"    
#include "topconn.ch"   
#INCLUDE "tbiconn.ch"
#INCLUDE "ap5mail.ch" 
/*
*---------------------------------------------------------------------------*
* Função     |GEFM62    | Autor | J Ricardo             | Data | 28.07.08   *
*---------------------------------------------------------------------------*
* Descrição  |Importacao dos Documentos contido na tabela SZR para as       *
*            |rotinas abaixo, automaticamente:                              *
*            |                                                              *
*            | Titulo a Receber                                             *
*            | Titulo a Pagar - Seguradora                                  *
*            | Titulo a Pagar - Transportadora                              *
*            | Registro Livros Fiscais                                      *
*---------------------------------------------------------------------------*
*/

*---------------------------------------------------------------------------*
* Alterado por: Ricardo Guimarães       -       Em: 28/11/2007              *
* Objetivo    : Provisionar as compras de frete dos CTRC                    *
*---------------------------------------------------------------------------*

// Gerar somente SF3

User Function GEFMSF3()
// GERA SOMENTE FISCAL
Local nQuant:=0     
Local _cQry := ""

// 03/11/2008

error := 0

DBSELECTAREA("SZS")
dbSeek("16")

_cQry := " SELECT * FROM SZR010 "
_cQry += " WHERE ZR_FILIAL='16' AND ZR_XDATA >= '20081001' AND ZR_XDATA <= '20081031' AND ZR_ISSTRI > 0 AND D_E_L_E_T_='' "
_cQry += " AND ZR_FILIAL + ZR_NF + ZR_XDATA NOT IN  "
_cQry += " (SELECT F3_FILIAL + F3_NFISCAL + F3_ENTRADA FROM SF3010 WHERE D_E_L_E_T_='' AND F3_ENTRADA >= '20081001' AND F3_ENTRADA <= '20081031') "
_cQry += " ORDER BY ZR_NF "

TCQUERY _cQry ALIAS "TRA" NEW

TcSetField("TRA" ,"ZR_XDATA","D")
TcSetField("TRA" ,"ZR_DATAIMP","D")	

dbSelectArea("TRA") ; dbGoTop()

WHILE !EOF()
	IncProc(0)
	If Substr(TRA->ZR_CDDEST,1,2) == "MS" // Tratamento para Clientes "EX" (MS+A1_COD+A1_LOJA) - Saulo 12/04/05
	
	   xDestino := Substr(TRA->ZR_CDDEST,3,8)
	   xMSCli   := Substr(TRA->ZR_CDCLI,3,8)
	   // Cliente Destinatário  
	   DbselectArea("SA1")
	   DbSetorder(1)       // Ordena Por Cliente+loja           
	   DbGotop()							    	   
	   If !Dbseek(xFilial("SA1")+xDestino) 
	      pos   := 12
	      errata()
	      error := 1
	      DbselectArea("TRA")
	//      Dbskip()
	//      Return   
	   Endif
	Else
	
	   xDestino := Substr(TRA->ZR_CDDEST,3,8)
	   xMSCli   := Substr(TRA->ZR_CDCLI,3,8)
	
	   // Cliente Destinatário  
	   DbselectArea("SA1")
	   DbSetorder(3)       // Ordena Por Cnpj           
	   DbGotop()							    	   
	   If !Dbseek(xFilial("SA1")+TRA->ZR_CDDEST) 
	   		If !Dbseek(xFilial("SA1")+RIGHT(TRA->ZR_CDDEST,11))
			      pos   := 8
			      errata()
			      error := 1
			      DbselectArea("TRA")
			//      Dbskip()
			//      Return
			EndIf	
	   Endif 
	   //        
	Endif
	
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Função para verificar documento existente e suas series ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	
	    Do Case
		   Case ALLTRIM(TRA->ZR_TPDOC) == "UNS"
	            xSerie := "NFST "   
		   Case Substr(ALLTRIM(TRA->ZR_TPDOC),1,2) == "CT"
	            xSerie := "CTR  "   
		   Case ALLTRIM(TRA->ZR_TPDOC) == "UN1"
	            xSerie := "NF   "   
		   Case ALLTRIM(TRA->ZR_TPDOC) == "UN2"
	            xSerie := "NF   "
		   Case ALLTRIM(TRA->ZR_TPDOC) == "UNI"
	            xSerie := "NF   "
		   Case ALLTRIM(TRA->ZR_TPDOC) == "UNE"  // Por: J Ricardo - Em: 03/09/07
	            xSerie := "NF   "
		   OtherWise
	            xSerie := "CTR  "
		EndCase
	
		// Por: J Ricardo - Em: 03/09/07
		If SZS->ZS_FILIAL == "02"
		    Do Case
			   Case ALLTRIM(TRA->ZR_TPDOC) == "UN2"
		            xSerie := "NF   "
			   Case ALLTRIM(TRA->ZR_TPDOC) == "CTE"
		            xSerie := "CTR  "
			   Case ALLTRIM(TRA->ZR_TPDOC) == "UNE"
		            xSerie := "NFST "
			EndCase
		EndIf	
	                                    
	xEspecie := "1  " //"1" //Default  //Alterado por Marcelo Pimentel esta var. e utilizada como serie entao ela deve ter 3 de tamanho
	
	// Tratamento Porto Real 2 séries
	If SZS->ZS_FILIAL == "03" .And. Alltrim(TRA->ZR_TPDOC) == "UN1"
	   xEspecie := "1  "
	Endif
	If SZS->ZS_FILIAL == "03" .And. Alltrim(TRA->ZR_TPDOC) == "UN2"
	   xEspecie := "2  "
	Endif
	
	// Tratamento Beneditinos 2 séries
	If SZS->ZS_FILIAL == "02" .And. Alltrim(TRA->ZR_TPDOC) == "UN2"
	   xEspecie := "2  "
	Endif
	If SZS->ZS_FILIAL == "02" .And. Alltrim(TRA->ZR_TPDOC) == "CTE"
	   xEspecie := "2  "
	Endif
	If SZS->ZS_FILIAL == "02" .And. Alltrim(TRA->ZR_TPDOC) == "UNE"
	   xEspecie := "1  "
	Endif
	
	// Por: J Ricardo - Em: 26/09/07
	If SZS->ZS_FILIAL == "06" .AND. ALLTRIM(TRA->ZR_TPDOC) == 'CTR' .AND. (TRA->ZR_NF >= '000001' .AND. TRA->ZR_NF <= '100000')
	   xEspecie := "C  "
	EndIf
	
	DbSelectArea("SF3")
	//dbSetOrder(4) //F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
	//DbSetOrder(8) //F3_FILIAL+F3_NFELETR+DTOS(F3_EMINFE)+F3_CLIEFOR+F3_LOJA
	dbSetOrder(1)//F3_FILIAL+DTOS(F3_ENTRADA)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA+F3_CFO+STR(F3_ALIQICM,5,2)
	Dbgotop()
	
	If !dbSeek(SZS->ZS_FILIAL+DTOS(TRA->ZR_XDATA)+TRA->ZR_NF+xEspecie+SA1->A1_COD+SA1->A1_LOJA+ALLTRIM(TRA->ZR_CDFIS))
		If Error = 0	
			Reclock("SF3",.T.)
			SF3->F3_FILIAL	:= SZS->ZS_FILIAL
			SF3->F3_REPROC	:= "N"
			SF3->F3_ENTRADA := TRA->ZR_XDATA
			SF3->F3_NFISCAL := TRA->ZR_NF
		
		    //  Nova Rotina para contab. novas series   
	       Gefcofil := SZS->ZS_FILIAL
		    IF Gefcofil == "02"
		       _xloc := "CJ"
		    EndIF 
		
		    SF3->F3_SERIE  := xEspecie
		
		    //Tratamento Exclusivo para as filiais 06 e 11 (SP) - Saulo 04/07/05
		    //   UNS = "NFS"
		    //   UNI = "NFST"
		    //   "CTR"
		
		    //TRATAMENTO EXCLUSIVO PARA AS FILIAIS 06 E 11 (SP) - SAULO 31/08/05  ( CORREçãO )
		    //   UNS = "NFST"
		    //   UNI = "NFS"
		    //   "CTR"
			
		    If Gefcofil == "06" .OR. Gefcofil == "11"
		       SF3->F3_SERIE   := IIF(ALLTRIM(TRA->ZR_TPDOC) == "CTR" .OR. ALLTRIM(TRA->ZR_TPDOC) == "UNS","U","A") // Alterado em 10/10/05 -Solic. Eraldo                      
		       
				// Por: J Ricardo - Em: 26/09/07
				_cPrefixo := TRA->ZR_TPDOC   //Prefixo do titulo (CTL, CTR, CTV, etc.)
				If SZS->ZS_FILIAL == "06" .AND. ALLTRIM(TRA->ZR_TPDOC) == 'CTR' .AND. (TRA->ZR_NF >= '000001' .AND. TRA->ZR_NF <= '100000')
		   			SF3->F3_SERIE := xEspecie
				EndIf						
		       
		       //SF3->F3_ESPECIE := IIF(ALLTRIM(TRA->ZR_TPDOC) == "UNS","NFST",IIF(ALLTRIM(TRA->ZR_TPDOC) == "CTR","CTR","NF"))  // Solicitado Eraldo 07/11/05 (NFS PARA NF)
		       SF3->F3_CODISS  := ALLTRIM(TRA->ZR_CDSER) // ALLTRIM(TRA->ZR_CDFIS) - Alterado item 15
		    Else  // Demais Casos
		       //SF3->F3_ESPECIE := IIF(ALLTRIM(TRA->ZR_TPDOC) == "UNS","NFST",IIF(ALLTRIM(TRA->ZR_TPDOC) == "UNI","NF","CTR"))         
		       //SF3->F3_ESPECIE := IIF(ALLTRIM(TRA->ZR_TPDOC) == "UNS","NFST",IIF(ALLTRIM(TRA->ZR_TPDOC) == "CTR","CTR","UNI"))         
		   	   SF3->F3_CODISS  := ALLTRIM(TRA->ZR_CDFIS)       
		    Endif
		
		    //SF3->F3_ESPECIE := IIF(ALLTRIM(TRA->ZR_TPDOC) == "UNS","NFST",IIF(ALLTRIM(TRA->ZR_TPDOC) == "CTR","CTR","NF"))  // Solicitado Eraldo 07/11/05 (NFS PARA NF)        
		    SF3->F3_ESPECIE := xSerie
			SF3->F3_CLIEFOR := substr(SA1->A1_COD+SA1->A1_LOJA,1,6)
			SF3->F3_LOJA    := substr(SA1->A1_COD+SA1->A1_LOJA,7,2)
			SF3->F3_CFO     := ALLTRIM(TRA->ZR_CDFIS)
			SF3->F3_ESTADO	:= ALLTRIM(SA1->A1_EST)
			SF3->F3_EMISSAO := TRA->ZR_XDATA
			SF3->F3_ALIQICM := TRA->ZR_ALICM
		    SF3->F3_VALCONT := TRA->ZR_VLCONT
			SF3->F3_VALICM	:= TRA->ZR_ICMTRI
			SF3->F3_BASEIPI := TRA->ZR_BASIPI
			SF3->F3_VALIPI	:= TRA->ZR_VALIPI
		    //
			// TRATAMENTO DE ICMS SUBST. TRIBUTARIA 
			// IMPOSTO TRIB. = 0 , BASE ICMS = 0 - SOLICITADO EM  29/06/04 
			// SAULO MUNIZ
			//
			IF SF3->F3_VALICM > 0
			   SF3->F3_BASEICM := TRA->ZR_VLCONT
			ELSE
		       SF3->F3_BASEICM := 0.00   // ZERA BASE DE ICMS       
		       //
		       // Tratamento de filiais com imposto zerado - Livro Fiscal 02/12/04 
		       // Nova regra com Cfop - 05/01/05
		       //        
		       IF SZS->ZS_FILIAL $ ("01/02/03/05/10") 
		          IF Alltrim(SF3->F3_CFO) $ ("5351/5352/5353/5354/5355/5356") 
		             SF3->F3_ISENICM := SF3->F3_VALCONT  // FILIAIS COM OPERAÇÃO ISENTO              
		          ENDIF
		       ENDIF       
		       //
		       IF SZS->ZS_FILIAL == "03" 
		          IF Alltrim(SF3->F3_CFO) $ ("6921/6949/5949/5921/5915/6915/6902/5902/6903/5903")
		             SF3->F3_OUTRICM := SF3->F3_VALCONT // FILIAIS COM OPERAÇÃO OUTRAS
		          ENDIF 
		        ENDIF
			ENDIF   
		       	
		    //	Reforçado a condição para filtro de incidencia de iss para ctrc
		    //  Saulo - 05/02/03
		    /*
		    // Codigos para Gerar Informações de ISS
		    //
		    F3_CODISS     F3_TIPO 
		    LIX             S
		    CI              S
		    58              S
		    55              S    
		    */
		
			SF3->F3_TIPO    := IIF((ALLTRIM(TRA->ZR_CDFIS) == "LIX") .Or. (ALLTRIM(TRA->ZR_CDFIS) == "CI") .Or. (ALLTRIM(TRA->ZR_CDFIS) == "58") .Or. (ALLTRIM(TRA->ZR_CDFIS) == "55") ;
			                   .OR.(ALLTRIM(TRA->ZR_CDFIS) $ ("1601,1104,1006,2001,3301,2002,2003,5933,6933")) , "S" , " ") //Alterado por Marcos furtado para contemplar altearção de CFOP para servicos
			//SF3->F3_CODISS  := ALLTRIM(TRA->ZR_CDSER) // ALLTRIM(TRA->ZR_CDFIS) - Alterado item 15
			        
			
		
		
			IF (ALLTRIM(TRA->ZR_CDFIS) == "LIX") .Or. (ALLTRIM(TRA->ZR_CDFIS) == "CI") .Or. (ALLTRIM(TRA->ZR_CDFIS) == "58") .Or. (ALLTRIM(TRA->ZR_CDFIS) == "55") ;
			   .OR. (ALLTRIM(TRA->ZR_CDFIS) $ ("1601,1104,1006,2001,3301,2002,2003,5933,6933")) //Alterado por Marcos furtado para contemplar altearção de CFOP para servicos
				SF3->F3_OBSERV  := "Incidencia de ISS"
	            If Gefcofil <> "05" //colocado em 02/08/07 por Marcos Furtado, pois a AdHoc está informando a informação de iss junto com icms.
			  	    SF3->F3_VALICM	:= TRA->ZR_ISSTRI
			    	SF3->F3_ALIQICM := TRA->ZR_ALISS
				    SF3->F3_BASEICM := TRA->ZR_VLCONT
				Endif
			    If Gefcofil == "06" .OR. Gefcofil == "11"
		           SF3->F3_CODISS  := ALLTRIM(TRA->ZR_CDSER) // ALLTRIM(TRA->ZR_CDFIS) - Alterado item 15
			    Endif
			    If Gefcofil == "06" .OR. Gefcofil == "11"
		           SF3->F3_CODISS  := ALLTRIM(TRA->ZR_CDSER) // ALLTRIM(TRA->ZR_CDFIS) - Alterado item 15
			    Endif
			    
			    If Gefcofil == "02" .OR. Gefcofil == "05" .OR. Gefcofil == "13"
					If TRA->ZR_TPDOC == "CTR"	.or.  TRA->ZR_TPDOC == "CTV" .or. TRA->ZR_TPDOC == "CTA"
			           SF3->F3_CNAE  :=  "215406" //  Alterado item 28
			  		Else 
			           SF3->F3_CNAE  := ALLTRIM(TRA->ZR_CDSER) //  Alterado item 28	  		
			  		EndIF
			    Endif
			    
			Else
				SF3->F3_OBSERV := "Incidencia de ICMS"
		    	SF3->F3_CODISS := ""
			EndIf
		
			Msunlock()
		EndIf
	Else
		error:=1
		pos:=6
		errata()
	Endif       
   
	dbSelectArea("TRA")
	dbSkip()
End
Return

Static Function Errata()

If pos == 1
//	te1:="Titulo ja existente..:        "+TRA->ZR_NF+" "+TRA->ZR_CDCLI+cNL
//	_cErrata += "Titulo ja existente. - "
//	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 2
	te1:="Fornecedor nao existe.:       "+TRA->ZR_CDTRA+" "+" Documento "+TRA->ZR_NF+cNL
	_cErrata += "Fornecedor nao existe. - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 3
	te1:="Cliente Inexistente.:         "+TRA->ZR_CDCLI+" "+" Documento "+TRA->ZR_NF+cNL
	_cErrata += "Cliente Inexistente. - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 4
	te1:="Titulo da Seguradora ja existe -S00001 - 01"+" Documento "+TRA->ZR_NF+cNL
	_cErrata += "Titulo da Seguradora ja existe. - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 5
	te1:="Titulo da Trasportadora existe "+TRA->ZR_cdtra+"-"+"Documento "+TRA->ZR_NF+cNL
	_cErrata += "Titulo da Trasportadora existe. - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 6
	te1:="Registro Fiscal existente -   "+TRA->ZR_NF+cNL
	_cErrata += "Registro Fiscal existente. - "	
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 7
	te1:="Titulo de Iss ja Existe       "+TRA->ZR_NF+cNL
	_cErrata += "Titulo de Iss ja Existe. - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 8
	te1:="Cnpj Destinatário nao Existe  : "+TRA->ZR_CDDEST+" "+" Documento "+TRA->ZR_NF+cNL
	_cErrata += "Cnpj Destinatário nao Existe. - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 9
	te1:="Cliente Redespacho nao Existe : "+TRA->ZR_CDRESD+" "+" Documento "+TRA->ZR_NF+cNL
	_cErrata += "Cliente Redespacho nao Existe: " + TRA->ZR_CDRESD + " - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 10
	te1:="Inscricao Estadual nao Existe : "+TRA->ZR_CDCLI+" "+" Documento  "+TRA->ZR_NF+cNL
	_cErrata += "Inscricao Estadual nao Existe. - "	
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 11
	te1:="Centro de custo não existe :   "+TRA->ZR_CC+"    "+" Documento "+TRA->ZR_NF+cNL
	_cErrata += "Centro de custo não existe : " + TRA->ZR_CC+" - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 12
	te1:="Destinatário MS não Existe : "+TRA->ZR_CDDEST+" "+" Documento "+TRA->ZR_NF+cNL
	_cErrata += "Destinatário MS não Existe : "+TRA->ZR_CDDEST+" - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 13
	te1:="Redespacho MS não Existe   : "+TRA->ZR_CDRESD+" "+" Documento "+TRA->ZR_NF+cNL
	_cErrata += "Redespacho MS não Existe   : "+TRA->ZR_CDRESD+" - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 14
	te1:="Cliente MS Inexistente     : "+TRA->ZR_CDCLI+" "+" Documento "+TRA->ZR_NF+cNL
	_cErrata += "Cliente MS Inexistente     : "+TRA->ZR_CDCLI+" - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 15
	te1:="Condição de Pagamento Inexistente:  "+TRA->ZR_CDCLI+" "+" Documento "+TRA->ZR_NF+cNL
	_cErrata += "Condição de Pagamento Inexistente. - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 16
	te1:="Centro de custo Invalido   :  "+TRA->ZR_CC+"    "+" Documento "+TRA->ZR_NF+cNL
	_cErrata += "Centro de custo Invalido : "+TRA->ZR_CC+" - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 17
	te1:="Natureza não cadastrada / Documento "+TRA->ZR_NF+cNL
	_cErrata += "Natureza não cadastrada. - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 18
	te1:="Centro de custo Bloqueado  :  "+TRA->ZR_CC+"    "+" Documento "+TRA->ZR_NF+cNL
	_cErrata += "Centro de custo Bloqueado : " + TRA->ZR_CC + " - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 19
	te1:="Centro de custo Bloqueado (Intercentro) :  "+TRA->ZR_CC+"    "+" Documento "+TRA->ZR_NF+cNL
	_cErrata += "Centro de custo Bloqueado (Intercentro) : " + TRA->ZR_CC + " - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 20
	te1:="Cliente sem Categoria: "+TRA->ZR_CDCLI+" "+" Documento "+TRA->ZR_NF+cNL
	_cErrata += "Cliente sem Categoria: "+TRA->ZR_CDCLI+" - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 21
	te1:="Uo não autoriazada para esta configuração de faturamento: UO X 10ºDigito Centro de custo. Documento: "+TRA->ZR_NF+cNL
	_cErrata += "Uo não autoriazada para esta configuração de faturamento: UO X 10ºDigito Centro de custo."+" - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 22
	te1:="Faturamento não permitido : 10º Digito CC X Categoria do Cliente. Documento "+TRA->ZR_NF+cNL
	_cErrata += "Faturamento não permitido : 10º Digito CC X Categoria do Cliente. Documento."+" - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 24
	te1:="C.Custo PSA nao encontrado.  Documento "+TRA->ZR_NF+" C.C.PSA "+TRA->ZR_CCPSA+cNL
	_cErrata += "C.Custo PSA nao encontrado. "+TRA->ZR_CCPSA+" - "
	fWrite(nHdl,te1,Len(te1))
	
Endif
If pos == 25
	te1:="C.Custo PSA está em branco.  Documento "+TRA->ZR_NF+cNL
	_cErrata += "C.Custo PSA está em branco. - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 26
	te1:="Conta PSA nao encontrada.  Documento "+TRA->ZR_NF+" Cnt.Dsp "+TRA->ZR_CTAPSA+cNL
	_cErrata += "Conta PSA nao encontrada. Cnt.Dsp "+TRA->ZR_CTAPSA + " - "	
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 27
	te1:="Conta PSA em branco.  Documento "+TRA->ZR_NF+cNL
	_cErrata += "Conta PSA em branco. - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 28
	te1:="O.I. obrigatoria para a Conta e C.Custo informado.  Documento "+TRA->ZR_NF+" Conta "+TRA->ZR_CTAPSA +" C.C. "+TRA->ZR_CCPSA+cNL
	_cErrata += "O.I. obrigatoria para a Conta e C.Custo informado. Conta "+TRA->ZR_CTAPSA +" C.C. "+TRA->ZR_CCPSA + " - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 29
	te1:="Conta e C.C. nao encontrado na tabela de CONTA X C.CUSTO X ORDEM INTERNA.  Documento "+TRA->ZR_NF+" Conta "+TRA->ZR_CTAPSA +" C.C. "+TRA->ZR_CCPSA+cNL
	_cErrata += "Conta e C.C. nao encontrado na tabela de CONTA X C.CUSTO X ORDEM INTERNA. Conta "+TRA->ZR_CTAPSA +" C.C. "+TRA->ZR_CCPSA + " - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 30
	te1:="Conta, C.C. e O.I. nao encontrado na tabela de CONTA X C.CUSTO X ORDEM INTERNA.  Documento "+TRA->ZR_NF+" Conta "+TRA->ZR_CTAPSA +" C.C. "+TRA->ZR_CCPSA+" O.I. "+TRA->ZR_OIPSA+cNL
	_cErrata += "Conta, C.C. e O.I. nao encontrado na tabela de CONTA X C.CUSTO X ORDEM INTERNA.  Conta "+TRA->ZR_CTAPSA +" C.C. "+TRA->ZR_CCPSA+" O.I. "+TRA->ZR_OIPSA + " - "
	fWrite(nHdl,te1,Len(te1))
Endif
If pos == 31
	te1:="Tipo de Despesa nao cadastrada no Centro de Custo "+TRA->ZR_CC+" Documento "+TRA->ZR_NF+cNL
	_cErrata += "Tipo de Despesa nao cadastrada no Centro de Custo "+TRA->ZR_CC + " - "
	fWrite(nHdl,te1,Len(te1))
Endif

// Variável usada para gravar a errata na tabela SZR
// _cErrata += te1

//fGravaLog(pos)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VALSERºAutor  ³ Saulo Muniz           º Data ³  26/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VALSER()

Local xTpServ

  //  Nova Rotina para contab. novas series   
     Gefcofil := SZS->ZS_FILIAL
  IF Gefcofil == "02"
     _xloc := "CJ"
  EndIF 


     //xTpServ  := IIF(ALLTRIM(TRA->ZR_TPDOC) == "UNS","NFST",IIF(ALLTRIM(TRA->ZR_TPDOC) == "UNI","NFS","CTR"))  
     xTpServ  := IIF(ALLTRIM(TRA->ZR_TPDOC) == "UNS","NFST",IIF(ALLTRIM(TRA->ZR_TPDOC) == "CTR","CTR","NF")) 
     xTamSrv := Len(xTpServ)  
     xTpServ  := xTpServ + Space( 5 - xTamSrv )
       
Return(xTpServ)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DIAUTIL ºAutor  ³ Saulo Muniz         º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
         
////////////////////////////
// Tabela de Venctos  ISS //
////////////////////////////
/*
 __________________________________
| MATRIZ   - 01 -  3° Dia Util     |
| CAJU     - 02 -  3° Dia Util     |
| BARUERI  - 04 -  Dia 09          |
| CAXIAS   - 05 -  Dia 10          |
| V.GUILHE - 06 -  Dia 10          |
| CAMPINAS - 08 -  Dia 10          |
| V.OLIMPIA- 11 -  Dia 10          |
| CURITIBA - 07 -  Dia 20          |
| RB45     - 13 -  3° Dia Util     |
|__________________________________|                                  

*/

Static Function DIAUTIL(_MesAtu,_AnoAtu)  // 3° Dia Util     

dEmis := Ctod(Substr(TRA->ZR_XDATA,7,2)+"/"+Substr(TRA->ZR_XDATA,5,2)+"/"+Substr(TRA->ZR_XDATA,1,4))

nMes  := IIF(Month(dEmis) == 12, 1, Month(dEmis) + 1)
nAno  := IIF(Month(dEmis) == 12, Year(dEmis) + 1, Year(dEmis))

dIni  := CtoD("01/"+ StrZero(nMes,2) + "/" + StrZero(nAno,4) )        // FirstDay(dDatabase)
dMov  := dIni
dUtil := 0
xDia  := dIni

dSem  := Dow(dIni)


Do Case
   Case dSem == 1
        xDia := CtoD("04/"+ StrZero(nMes,2) + "/" + StrZero(nAno,4) )  

   Case dSem >= 2 .And. dSem <= 4
        xDia := CtoD("03/"+ StrZero(nMes,2) + "/" + StrZero(nAno,4) )  

   Case dSem >= 5 .And. dSem <= 7
        xDia := CtoD("05/"+ StrZero(nMes,2) + "/" + StrZero(nAno,4) )  
   
EndCase
   
Return(xDia)
