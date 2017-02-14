#include "rwmake.ch"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³   MSNAT    ³ Autor ³    Saulo Muniz      ³ Data ³ 13.10.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Define a natureza a ser usada no pedido de vendas           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// Implementada nova regra definida para o ILI - Saulo Muniz 18/10/06

User Function TES(nOpc)  
Local aArea := GetArea()
Local lRet  := .T.
Private _cCusto
Private xUo
Private xTes    := ""
Private xAtvFim
Private xAtvRma
Private xAtvRdvm
Private Resposta

_cCusto := M->C5_CCUSTO
                                                   	
xNatur  := ""                                

// xTes            

DbSelectArea("CTT")  // Atualizado para CTB
DbSetOrder(1)	
DbGotop()			
DbSeek(xFilial("CTT")+_cCusto)

xUo      := Substr(Alltrim(_cCusto),2,2) 
_cUODesc := ""
xAtvFim  := Substr(Alltrim(_cCusto),7,3) 

If Empty(_cCusto)
	Return .t.
EndIf

If CTT->CTT_BLOQ == "1"
   MsgInfo("Centro de custo bloqueado !")
   lRet  := .F.   
Endif        

If Substr(_cCusto,10,1) == "7" 
   MsgInfo("Centro de custo Intercentro não permitido !")
   lRet  := .F.   
Endif        
 
///////////////////////////////
// Operações Fretes Normais  //
///////////////////////////////

//As naturezas utilizadas nesta rotina de faturamento iniciarão com '6'.
Do Case            

   Case xUo $("01|02")    // RDVM / TLA
        xNatur   := "600" 
//		xTes     := "503"           		
		_cUODesc := "TLA"

   Case xUo $("22|23")    // RMA / OVS
        xNatur   := "601"            
//		xTes     := "501" 
		_cUODesc := "OVS"		                 

   Case xUo == "11"       // RMLAP / OVL               
        xNatur   := "604"               
//		xTes     := "501"
		_cUODesc := "OVL"		 
		
   Case xUo $("21")       // ILI / LOG
        xNatur   := "606"     
//		xTes     := "501"    
		_cUODesc := "LOG"
		
   Otherwise
        xNatur := "607"   // Natureza com conta transitoria 
//		xTes    := "501"                   
EndCase
	        	            
////////////////////////
// Operações Isentas  //
////////////////////////////////////////////////////
// Tratamento de Frete Rma , Rdvm e Rmlap isento  //          
////////////////////////////////////////////////////            
xAtvRma   := "402|404|406|503|504|506|508"            
xAtvRdvm  := "003|004|006|008|012|016"

If xUo $("22|23") .And. xAtvFim $(xAtvRma)   //Rma                
    xNatur  := "602"                 
//	xTes    := "502"   
Endif

If xUo $("01|02") .And. xAtvFim $(xAtvRdvm)    //Rdvm
    xNatur  := "603"   
//	xTes    := "504"   
Endif	        

If Empty(xNatur)
   MsgInfo("Natureza não encontrada !")
Endif                                   

*--------------------------------------------------------------------------------------------*
* Por: Ricardo - Em: 12/11/2009																 *
* Objetivo: Tratar TES e Natureza para NF modelo 7, conforme orientação da Iris 			 *
*--------------------------------------------------------------------------------------------*

If AllTrim(M->C5_XTIPONF) == "NFT"

	xNatur  := fPegaNat(_cUODesc, GETMV("MV_XNATNF7"))
	xProdNF7:= GETMV("MV_XPRDNF7")
//	xTes    := POSICIONE("SB1",1,xFilial("SB1")+AllTrim(xProdNF7),"B1_TS")
	GdFieldPut("C6_PRODUTO",xProdNF7,1)	
	GdFieldPut("C6_DESCRI" ,POSICIONE("SB1",1,xFilial("SB1")+AllTrim(xProdNF7),"B1_DESC"),1)		
	oGetDad:Refresh()
	
ElseIf 	Empty(AllTrim(M->C5_XTIPONF))
	xNatur := CriaVar("C5_NATUREZ",.F.)
ElseIf 	M->C5_XTIPONF = "ND"
	xNatur := CriaVar("C5_NATUREZ",.F.)
//	xTes   := "999"
EndIf

*--------------------------------------------------------------------------------------------*

If nOpc = 1 //Gatilho                             

	MaFisAlt("NF_NATUREZA",xNatur)
	//GdFieldPut("C6_TES", xTes)
	RestArea(aArea)
	                                                                                
//	GdFieldPut("C6_CF",POSICIONE("SF4",1,xFilial("SF4")+xTes,"F4_CF"),N)	
	// Return(Alltrim(xTes))
	Return( '' )

Else //Valida Campo               
    M->C5_NATUREZ := xNatur
/*    
	_N := N  
	N:= 1	              
	If !Empty(GdFieldGet("C6_PRODUTO"))
	
		For I:= 1 to len(aCols)
			N:= I
			If Empty(xTes)
				GdFieldPut("C6_TES","")
				GdFieldPut("C6_CF","")		
			Else                    
				Alert(GdFieldGet("C6_TES"))
				GdFieldPut("C6_TES",xTes,N)
				GdFieldPut("C6_CF",POSICIONE("SF4",1,xFilial("SF4")+xTes,"F4_CF"),N)
			EndIf                                     
		Next I           
		//Esta linha atualiza os dados visuais do grid onde estao os itens do pedido de venda.
		oGetDad:Refresh()
	EndIf
	N := _N 
*/	
	If Empty(AllTrim(M->C5_XTIPONF))
		Alert("Favor informar o Tipo de NF a ser emitida.")
		lRet := .F.
		M->C5_CCUSTO := SPACE(TAMSX3("C5_CCUSTO")[1])
	EndIf
	
	If Empty(M->C5_CCUSTO)
	   lRet := .t.
	EndIf   
EndIf              

RestArea(aArea)
Return(lRet)

*------------------------------------------*
Static Function fPegaNat(_cUO, _cNat)
*------------------------------------------*
Local _cNaturez := ""
Local _nPosNat  := 0
Local _aNat     := {}
Local _n        := 0
Local _nColIni  := 1

// Monto Array com UO e Natureza
For _n := 1 To Len(AllTrim(_cNat))
	If SubStr(_cNat,_n,1) == "|"
		// Array com UO e Natureza
		AADD(_aNAT,{SubStr(_cNat,_nColIni,3),SubStr(_cNat,_nColIni+4,_n - (_nColIni+4))})
		_nColIni := _n+1
	EndIf
Next _n

AADD(_aNAT,{SubStr(_cNat,_nColIni,3),SubStr(_cNat,_nColIni+4,Len(AllTrim(_cNat)) - (_nColIni+3))})

// ALERT(U_fpeganaT("OVL","OVL=R11108|OVL=R11111|TLA=R811109"))                                                                    

_nPosNat := aScan(_aNat,{|x| alltrim(x[1] ) == _cUO })

If _nPosNat > 0
	_cNaturez := _aNat[_nPosNat, 2]
EndIf

Return _cNaturez
