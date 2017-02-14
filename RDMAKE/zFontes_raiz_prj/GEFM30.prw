#INCLUDE "rwmake.ch"                                                           
#INCLUDE "TOPCONN.ch"

*****************************************************************************
*****************************************************************************
*  Empresa  : GEFCO
*****************************************************************************
** Funcao   : GEFM30  Autor  : Saulo Muniz                   Data : 29/06/04                                                              *
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
//
// Tabela de centro de custo (4o Digito)
// 1 - RDVM
// 2 - RDVM
// 3 - ILI
// 5 - RMLAP
// 6 - RMA
// 7 - RMA
// 8 - RMA
//   
// Alterado em 19/08/04 - Saulo Muniz
// Nova Definição Ordenação por Nome
//
// Alterado em 19/08/04 - Saulo Muniz
// Nova Definição Ordenação por Total a Receber
//
// Alterado em 20/08/04 - Saulo Muniz
// Log na tela de titulos com Unidade Operacional errada


************************
User  Function GEFM30()
************************

SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
SetPrvt("DDATA,NLINGETD,CTITULO,AC,AR,ACGD")
SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,oGeraCTB,")

cTitulo  := "(A VENCER)                             Relatório de Ageing dos Clientes                                  (VENCIDOS)"
//cTitulo  := "(VENCIDOS)                             Relatório de Ageing dos Clientes                                  (A VENCER)"
cDesc1   := "Este programa tem por objetivo gerar Ageing Analisys  dos      "
cDesc2   := "Titulos Financeiros."
cDesc3   := ""
cString  := "SE1"
aOrd     := {"Valor"}
wnrel    := "GEFM30"
aReturn  := {"90 Colunas", 1,"GEFCO", 2, 2, 1, "",1}
Tamanho  := "G"
cRodaTxt := ""
CbCont   := 1
Li       := 80
nLastKey := 0
m_pag    := 1
cPerg    := "GEFM30"
cabec1   := "      Nome do Cliente                         ( Até 90 Dias )   ( >90 DIAS <180 )   ( >180 DIAS <365)     +365 DIAS (A VENCER) ||  Até 90 Dias   ( >90 DIAS <180 )   ( >180 DIAS < 365 ) +365 DIAS(VENCIDOS) TOTAL RECEBER"
_folha   := 0  // 0= Imprime 1= Nao imprime
nlin     := 8
NomeProg := "GEFM30"                                                                    

wnrel:=SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.)

If LastKey() == 27
	Return(Nil)
Endif

    ValidPerg()  

If LastKey() == 27
	Return(Nil)
Endif

SetDefault(aReturn,cString)                 
nTipo := If(aReturn[4]==1,15,18)
RptStatus({|| RunReport(Cabec1,cTitulo,nLin) },cTitulo)
//RptStatus({|| RunReport(Cabec1,Cabec2,cTitulo,nLin) },cTitulo)

Return
  
************************
//Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Static Function RunReport(Cabec1,Titulo,nLin)
************************                                                                              

_crlf    := CHR(13) + CHR(10) 
V_Alias  := Alias()
cPerg    := "GEFM30"


SetRegua(RecCount()) 
   
   Do While .T.                  
			
         nLastKey:= Pergunte(cPerg,.T.)
	
	  If nLastKey == .F.      
  	     Return(.T.) 
	  Endif	

	  If Empty(Mv_Par08)
         MsgBox("Informe a data até. ")
         DbSelectArea(V_Alias)
         Loop
      Endif
                  
	  Exit		
   Enddo	
   

DbSelectArea("SE1")
DbGotop()
If Bof() .Or. Eof()
   DbSelectArea(V_Alias)
   Alert("O arquivo de Contas a Receber (SE1) está vazio.")
   Return(.T.)
Endif

cNomArq1    := "GEFM30.DBF"                 // Arquivo
cNomInd1    := "GEFM30"+OrdBagExt()         // Indice

If File(cNomArq1)
   
   V_Erase1 := FErase(cNomArq1)
         
   If V_Erase1 != 0 
      
      Msgbox("Problemas ao tentar excluir o arquivo : " + cNomArq1  + "." + chr(13)+;
             "Portanto a operacao nao sera realizada." ,"Aviso")
      Return .t.
   Endif
   
Endif

V_StrTemp1 := {}
V_StrTemp1 := {{"TP_CLIENTE"   ,"C",06,0},; 
               {"TP_DISTRIB"   ,"C",06,0},;
               {"TP_NMDISTR"   ,"C",30,0},;
               {"TP_NMCLIE"    ,"C",60,0},;
               {"TP_TOTREC"    ,"N",17,2},;
               {"TP_TOTCAR"    ,"N",17,2},;
               {"TP_TOTVIS"    ,"N",17,2},;
               {"TP_AVen30"    ,"N",17,2},;
               {"TP_AVen60"    ,"N",17,2},;
               {"TP_Aven90"    ,"N",17,2},;
               {"TP_Aven91"    ,"N",17,2},;
               {"TP_Venc30"    ,"N",17,2},;
               {"TP_Venc60"    ,"N",17,2},;
               {"TP_venc90"    ,"N",17,2},;
               {"TP_venc91"    ,"N",17,2},;
               {"TP_MVPAR1"    ,"C",6,0 },;
               {"TP_MVPAR2"    ,"C",6,0 },;
               {"TP_MVPAR3"    ,"C",6,0 },;
               {"TP_MVPAR4"    ,"C",6,0 },;
               {"TP_MVPAR5"    ,"C",6,0 },;
               {"TP_MVPAR6"    ,"C",6,0 },;
               {"TP_MVPAR7"    ,"D",8,0 },;
               {"TP_MVPAR8"    ,"D",8,0 },;
               {"TP_MVPAR9"    ,"N",1,0 },;
               {"TP_MVPAR10"   ,"D",8,0 },;                                            
               {"TP_LOG"       ,"C",20,0}} 


cabec1   := "      Nome do Cliente                         ( Até 90 Dias )   ( >90 DIAS <180 )   ( >180 DIAS <365)     +365 DIAS (A VENCER) ||  Até 90 Dias   ( >90 DIAS <180 )   ( >180 DIAS < 365 ) +365 DIAS(VENCIDOS) TOTAL RECEBER"
                                                                                                           
V_ArqTemp1  := CriaTrab(V_StrTemp1,.T.)           
V_IndTmp11  := Substr(CriaTrab(NIL,.F.),1,7)+"1"   // Retorna o nome do arquivo de indice temporario (1) 
dbUseArea(.T.,,V_ArqTemp1,V_ArqTemp1,.T.,.F.)     
V_Chave1 := "TP_CLIENTE"  
V_Chave2 := "TP_TOTREC"  

IndRegua(V_ArqTemp1,V_IndTmp11,V_Chave1,,,"Indice temporario") 
DbClearIndex()                                                         
DbSetIndex(V_IndTmp11+OrdBagExt())                            
DbSelectArea(V_ArqTemp1)                      

Cabec(cTitulo,Cabec1,NomeProg,Tamanho,nTipo)
//Cabec(cTitulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
 
Processa({|| FGerRel01() },"Processando Titulos , Aguarde... ")

// pegar todos os titulos pagos com data < que a database   
// pegar os titulos pagos a vista.   

nLin := 8
xErro:= .F.

DbSelectArea(V_ArqTemp1)
//Index on V_Chave2 to V_ArqTemp1
DbSetOrder(01)       
DbGotop()

     // Variaveis - Totalizadores
     xAVen30 := 0
     xAVen60 := 0
     xAVen90 := 0
     xAVen91 := 0
     xVenc30 := 0
     xVenc60 := 0
     xVenc90 := 0
     xVenc91 := 0
     xTotRec := 0

   //_xCliente := (V_ArqTemp1)->TP_CLIENTE

While !Eof() //.AND. (V_ArqTemp1)->TP_CLIENTE == _xCliente
     
   If nLin > 55                                    // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(cTitulo,Cabec1,NomeProg,Tamanho,nTipo)
      //Cabec(cTitulo,Cabec1,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
                  
   nLin := nLin + 1                              // Avanca a linha de impressao   
   @ nlin,001 Psay ALLTRIM((V_ArqTemp1)->TP_NMCLIE)   
   
   // A Vencer  
   @ nlin,046 Psay (V_ArqTemp1)->TP_AVen30 Picture "@E 999,999,999.99"  //PesqPict("SE1","E1_VALOR",12,MV_PAR10)		            				     									
   @ nlin,064 Psay (V_ArqTemp1)->TP_AVen60 Picture "@E 999,999,999.99"		            				     									
   @ nlin,082 Psay (V_ArqTemp1)->TP_Aven90 Picture "@E 999,999,999.99"		            				     	  
   @ nlin,102 Psay (V_ArqTemp1)->TP_Aven91 Picture "@E 999,999,999.99"								     
   // Vencidos   
   @ nlin,130 Psay (V_ArqTemp1)->TP_Venc30 Picture "@E 999,999,999.99"
   @ nlin,148 Psay (V_ArqTemp1)->TP_Venc60 Picture "@E 999,999,999.99"		            				     									
   @ nlin,163 Psay (V_ArqTemp1)->TP_Venc90 Picture "@E 999,999,999.99"		            				     	  
   @ nlin,178 Psay (V_ArqTemp1)->TP_Venc91 Picture "@E 999,999,999.99"								       
   @ nlin,198 Psay (V_ArqTemp1)->TP_TOTREC Picture "@E 999,999,999,999.99"        // Total a receber		            				     									

   
   // Totalizadores Geral do relatorio
   // Saulo Muniz
     xAVen30 := xAVen30 + (V_ArqTemp1)->TP_AVen30
     xAVen60 := xAVen60 + (V_ArqTemp1)->TP_AVen60
     xAVen90 := xAVen90 + (V_ArqTemp1)->TP_AVen90
     xAVen91 := xAVen91 + (V_ArqTemp1)->TP_AVen91
     xVenc30 := xVenc30 + (V_ArqTemp1)->TP_Venc30
     xVenc60 := xVenc60 + (V_ArqTemp1)->TP_Venc60
     xVenc90 := xVenc90 + (V_ArqTemp1)->TP_Venc90
     xVenc91 := xVenc91 + (V_ArqTemp1)->TP_Venc91
     xTotRec := xTotRec + (V_ArqTemp1)->TP_TOTREC    
    
     nLin := nLin + 1                              // Avanca a linha de impressao   
        
     DbSkip()  
     
EndDo
   
   nLin := nLin + 1                              // Avanca a linha de impressao      
   @ nlin,015 Psay " Total Geral  --->"
   @ nlin,046 Psay xAVen30 Picture "@E 999,999,999.99"		            				     									
   @ nlin,064 Psay xAVen60 Picture "@E 999,999,999.99"		            				     									
   @ nlin,082 Psay xAVen90 Picture "@E 999,999,999.99"		            				     									
   @ nlin,102 Psay xAVen91 Picture "@E 999,999,999.99"		            				     									
   @ nlin,130 Psay xVenc30 Picture "@E 999,999,999.99"		            				     									
   @ nlin,148 Psay xVenc60 Picture "@E 999,999,999.99"		            				     	  
   @ nlin,163 Psay xVenc90 Picture "@E 999,999,999.99"								     
   @ nlin,178 Psay xVenc91 Picture "@E 999,999,999.99"		            				     									
   @ nlin,198 Psay xTotRec Picture "@E 999,999,999,999.99"		            				     	  
      
SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()
                                  
DbCloseArea(V_ArqTemp1)
FRename(V_ArqTemp1+".DBF", cNomArq1)   
FRename(V_IndTmp11+OrdBagExt(), cNomInd1)  

Ferase(V_ArqTemp1+".DBF")                                      
Ferase(V_IndTmp11+OrdBagExt())
     
Return(.t.)      

// Processando títulos a vencer
***************************
Static Function FGerRel01()
***************************

cQuery := ""
V_Se1  := RETSQLNAME("SE1")
V_Sa1  := RETSQLNAME("SA1")

cQuery  = "SELECT "
cQuery += " A.E1_FILIAL ,A.E1_NUM,A.E1_CLIENTE ,A.E1_PREFIXO,A.E1_PARCELA,A.E1_TXMOEDA," 
cQuery += " A.E1_SALDO  ,A.E1_VENCREA,A.E1_LOJA ,A.E1_TIPO,A.E1_NATUREZ,A.E1_VALLIQ,"
cQuery += " A.E1_EMISSAO,A.E1_SITUACA,A.E1_CCONT,A.E1_NOMCLI,A.E1_BAIXA,"
cQuery += " B.A1_FILIAL ,B.A1_COD, B.A1_NOME, B.A1_LOJA, B.A1_GRPVEN"
cQuery += " FROM "+V_Se1+" AS A,"+V_Sa1+" AS B "
cQuery += " WHERE A.E1_CLIENTE = B.A1_COD  AND  "
cQuery += "       A.E1_LOJA    = B.A1_LOJA AND  "
cQuery += "       A.E1_VENCREA >=" + "'"+DTOS(Mv_Par07)+"'" +  " AND "
cQuery += "       A.E1_VENCREA <=" + "'"+DTOS(Mv_Par08)+"'" +  " AND "
cQuery += "       A.E1_CLIENTE >= " + "'"+Mv_Par01+"'" + " AND "
cQuery += "       A.E1_CLIENTE <= " + "'"+Mv_Par02+"'" + " AND "
cQuery += "       A.E1_SALDO         > 0      AND  " 
cQuery += "       A.E1_TIPO          <> 'NCC' AND  " 
cQuery += "       A.D_E_L_E_T_ <> '*'  AND B.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY A.E1_NOMCLI,B.A1_NOME"

TCQuery cQuery ALIAS "TRB" New     

DbSelectArea("TRB")
ProcRegua(Lastrec())

xLog :=" "
xErro := .F.
xTipo := .T.

Do While !Eof()           
   
   IncProc()
              
   V_Cliente := TRB->E1_Cliente
   V_Distrib := Space(06)
   V_NmDistr := "NAO CADASTRADO"
   V_NmClie  := "NAO CADASTRADO"
   V_4DG     := Substr(Alltrim(TRB->E1_CCONT),4,1)  //Digito de controle do c.custo Gefco 
   
   If Empty(V_4DG) // faturas com c.custo em branco (Faturas)
      V_4DG  := " "   
   EndIf
 
      
   DbSelectArea("SA1")
   DbSetOrder(1)
   Seek xFilial("SA1")+V_Cliente
   If Found()
      
      DbSelectArea("SA1")
      V_NmClie  := SA1->A1_Nome
   
   Endif   
   
      
   DbSelectArea("TRB")
      
   nSaldo := TRB->E1_SALDO
   
        
   V_TotARec  := 0      // Total a receber
   V_TotCart  := 0      // Total em cartório
   V_TotVista := 0      // Total a receber a vista
   V_TotVenc  := 0      // Pode receber total vencidos ou a vencer
   
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
   
   V_DtVecto  := Ctod(Substr(TRB->E1_VENCREA,7,2)+"/"+ Substr(TRB->E1_VENCREA,5,2)+"/"+Substr(TRB->E1_VENCREA,1,4))   
   V_TotARec  := nSaldo //TRB->E1_SALDO
   
   
   //If TRB->E1_SITUACA == "6"                  // Em cartorio   
   //   V_TotCart  := TRB->E1_SALDO    
   //Elseif TRB->E1_EMISSAO == TRB->E1_VENCREA  // Total a receber a vista   
   //   V_TotVista := TRB->E1_SALDO     
   //Elseif TRB->E1_VENCREA > Dtos(DdataBase)   // A Vencer          
   
   //If TRB->E1_VENCREA > Dtos(DdataBase)   // A Vencer          
   If TRB->E1_VENCREA > Dtos(MV_PAR10)      // A Vencer          
      V_DifDias := V_DtVecto - MV_PAR10 
          Do Case
             Case V_DifDias <= 90  
                  V_AVen30 := nSaldo //TRB->E1_SALDO                 
             Case V_DifDias >= 91  .And. V_DifDias <= 180
                  V_AVen60 := nSaldo //TRB->E1_SALDO                 
             Case V_DifDias >= 181  .And. V_DifDias <= 365
                  V_AVen90 := nSaldo //TRB->E1_SALDO                 
             Otherwise
                  V_AVen91 := nSaldo //TRB->E1_SALDO                 
          EndCase
   
   //Elseif TRB->E1_VENCREA < Dtos(DdataBase)  // Vencidos
   Elseif TRB->E1_VENCREA < Dtos(MV_PAR10)     // Vencidos          
          V_DifDias := MV_PAR10 - V_DtVecto   
          Do Case
             Case V_DifDias <= 90 
                  V_Venc30 := nSaldo //TRB->E1_SALDO                 
             Case V_DifDias >= 91  .And. V_DifDias <= 180
                  V_Venc60 := nSaldo //TRB->E1_SALDO                 
             Case V_DifDias >= 181  .And. V_DifDias <= 365
                  V_Venc90 := nSaldo //TRB->E1_SALDO                 
             Otherwise
                  V_Venc91 := nSaldo //TRB->E1_SALDO                 
          EndCase
   
   Endif
   
   DbSelectArea(V_ArqTemp1)
   DbSetOrder(01)
   Seek V_Cliente
   If !Found()
   
      RecLock(V_ArqTemp1,.T.)
       
      Replace   (V_ArqTemp1)->TP_DISTRIB      With   V_Distrib    ,;
                (V_ArqTemp1)->TP_CLIENTE      With   V_Cliente    ,;
                (V_ArqTemp1)->TP_NMCLIE       With   V_NmClie     ,;
                (V_ArqTemp1)->TP_NMDISTR      With   V_NmDistr     
               
   Else
      RecLock(V_ArqTemp1,.F.)
   Endif             
   
   If Empty(Mv_Par01)
      Mv_Par01 := Replic(".",6)                             
   Endif
   If Empty(Mv_Par02)
      Mv_Par02 := Replic(".",6)                             
   Endif
   If Empty(Mv_Par03)
      Mv_Par03 := Replic(".",6)                             
   Endif
   If Empty(Mv_Par04)
      Mv_Par04 := Replic(".",6)                             
   Endif
   If Empty(Mv_Par05)
      Mv_Par05 := Replic(".",6)                             
   Endif
   If Empty(Mv_Par06)
      Mv_Par06 := Replic(".",6)                             
   Endif
     
   
   Replace   (V_ArqTemp1)->TP_TOTREC      With   (V_ArqTemp1)->TP_TOTREC + V_TotARec  ,; 
             (V_ArqTemp1)->TP_AVen30      With   (V_ArqTemp1)->TP_AVen30 + V_AVen30   ,;
             (V_ArqTemp1)->TP_AVen60      With   (V_ArqTemp1)->TP_AVen60 + V_AVen60   ,;
             (V_ArqTemp1)->TP_AVen90      With   (V_ArqTemp1)->TP_AVen90 + V_AVen90   ,;
             (V_ArqTemp1)->TP_AVen91      With   (V_ArqTemp1)->TP_AVen91 + V_AVen91   ,;  
             (V_ArqTemp1)->TP_Venc30      With   (V_ArqTemp1)->TP_Venc30 + V_Venc30   ,;
             (V_ArqTemp1)->TP_Venc60      With   (V_ArqTemp1)->TP_Venc60 + V_Venc60   ,;
             (V_ArqTemp1)->TP_Venc90      With   (V_ArqTemp1)->TP_Venc90 + V_Venc90   ,;
             (V_ArqTemp1)->TP_Venc91      With   (V_ArqTemp1)->TP_Venc91 + V_Venc91   ,; 
             (V_ArqTemp1)->TP_MvPar1      With   Mv_Par01                             ,;  
             (V_ArqTemp1)->TP_MvPar2      With   Mv_Par02                             ,;  
             (V_ArqTemp1)->TP_MvPar3      With   Mv_Par03                             ,;  
             (V_ArqTemp1)->TP_MvPar4      With   Mv_Par04                             ,;  
             (V_ArqTemp1)->TP_MvPar5      With   Mv_Par05                             ,;  
             (V_ArqTemp1)->TP_MvPar6      With   Mv_Par06                             ,;  
             (V_ArqTemp1)->TP_MvPar7      With   Mv_Par07                             ,;  
             (V_ArqTemp1)->TP_MvPar8      With   Mv_Par08                             ,;  
             (V_ArqTemp1)->TP_MvPar9      With   Mv_Par09                             ,;                             
             (V_ArqTemp1)->TP_MvPar10     With   Ddatabase                            ,;   
             (V_ArqTemp1)->TP_LOG         With   xLog
             //(V_ArqTemp1)->TP_TOTVIS      With   (V_ArqTemp1)->TP_TOTVIS + V_TotVista ,; 
             //(V_ArqTemp1)->TP_TOTCAR      With   (V_ArqTemp1)->TP_TOTCAR + V_TotCart  ,; 
                
   MsUnlock()                                                         
   
   // imprimir
   //
   /*
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      //Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(cTitulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

     nLin := nLin + 1                   // Avanca a linha de impressao   
   @ nlin,001 Psay V_NmClie
   
    // A Vencer  
   @ nlin,040 Psay V_AVen30 		            				     									
   @ nlin,050 Psay V_AVen60 		            				     									
   @ nlin,060 Psay V_AVen90 		            				     	  
   @ nlin,070 Psay V_AVen91								  
   
   // Vencidos   
   @ nlin,080 Psay V_Venc30 		            				     									
   @ nlin,090 Psay V_Venc60 		            				     									
   @ nlin,100 Psay V_Venc90 		            				     	  
   @ nlin,110 Psay V_Venc91								  
   
     nLin := nLin + 2                   // Avanca a linha de impressao
   
   //Totais
   @ nlin,040 Psay V_TotARec            // Total a receber		            				     									
   @ nlin,050 Psay V_TotCart 		    // Total em cartório         				     									
   @ nlin,060 Psay V_TotVista 		    // Total a receber a vista        				     	  
   @ nlin,070 Psay V_TotVenc			// Pode receber total vencidos ou a vencer					  

     nLin := nLin + 3                   // Avanca a linha de impressao
   */                                                                
   
   DbSelectArea("TRB")
   DbSkip()
       
Enddo

DbSelectArea("TRB")
DbCloseArea()

Return(.T.)


***************************
Static Function ValidPerg()
***************************

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

DbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))

Aadd(aRegs,{cPerg,"01","Cliente Inicial......","","","mv_ch1","C",006,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
Aadd(aRegs,{cPerg,"02","Cliente Final........","","","mv_ch2","C",006,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
Aadd(aRegs,{cPerg,"03","Distribuidor Inicial.","","","mv_ch3","C",006,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","ACY",""})
Aadd(aRegs,{cPerg,"04","Distribuidor Final...","","","mv_ch4","C",006,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","ACY",""})
Aadd(aRegs,{cPerg,"05","Regiao Inicial ......","","","mv_ch5","C",006,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","ZF",""})
Aadd(aRegs,{cPerg,"06","Regiao Final ........","","","mv_ch6","C",006,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","ZF",""})
Aadd(aRegs,{cPerg,"07","Data de .............","","","mv_ch7","D",008,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"08","Data ate.............","","","mv_ch8","D",008,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"09","Tipo de relatorio....","","","mv_ch9","N",001,0,0,"C","","mv_par09","RDVM","","","","","ILI","","","","","RMLAP","","","","","RMA","","","","","TODOS","","","","",""})
Aadd(aRegs,{cPerg,"10","Data Base............","","","mv_cha","D",008,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next

DbSelectArea(_sAlias)

Return(.T.)

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
