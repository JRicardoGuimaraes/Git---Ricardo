#Include 'rwmake.ch'
****************************************************************************************
* Programa: IMPFIFO - Importa Saldos em Estoque                                        *
****************************************************************************************
USER FUNCTION IMPFIFO()
arqimp :=SPACE( 30 ); tepadrao :="033" ; serie := "UNI"   
ok := 0
nr_item:=0 
MSGSTOP("O arquivo deve estar no diretorio system ou sigaadv.")

*==interface==*
@ 173,242 To 235,646 Dialog impsaldo Title OemToAnsi("Importa N.F.")
*@ 003,003 Say OemToAnsi("Arquivo") Size 32,8
@ 019,003 Say OemToAnsi("T.E. padrão") Size 30,8
@ 002,040 Get arqimp Picture "@!" WHEN .f. VALID VARQIMP() Size 150,10 Object oarqimp
@ 018,040 Get tepadrao Picture "@!" F3 "SF4" Size 23,10 Object otepadrao
*----*                                  
@ 002,003 Button OemToAnsi("Arquivo")           Size 30,12 Action VARQIMP()
@ 017,078 Button OemToAnsi("_Importar Arquivo") Size 50,12 Action MSAGUARDE({||importa()},"Processando","Aguarde...")
Activate Dialog impsaldo CENTERED
Return (.t.)                                     

********************************************************************************************************************
*                                         Verifica o arquivo diigitado                                             *
********************************************************************************************************************
STATIC FUNCTION VARQIMP()
cTipo :="Database Files *.DBF)        | *.DBF | "
cFile := cGetFile(cTipo,"Selecione o arquivo a importar")
If !Empty(cFile)
   Aviso("Arquivo Selecionado",cFile,{"Ok"})
Endif     
arqimp := PADR(ALLTRIM(cFile),30)
*IF "/"$arqimp .OR. ":"$arqimp .OR. "\"$arqimp
*   MSGSTOP("Caracteres invalidos no nome do arquivo.")
*   oarqimp:SetFocus()
*   RETURN(.f.)   
*ENDIF
oarqimp:Refresh()
RETURN(.t.)

****************************************************************************************
*                      importa dados das notas fiscais                                 *
****************************************************************************************
STATIC FUNCTION importa()
IF EMPTY( arqimp )
   MSGSTOP("Informe o arquivo")
   RETURN(.f.)
ENDIF                                                  
***************************************************
*estrutura do arquivo a ser importado tem de ser  *
***************************************************    
* 1  CODFORN      ,Character, 11 ( siga so tem 6 )*                            
* 2  NOTAFISCAL   ,Numeric  ,  9                  *           
* 3  DATAEMISSA   ,Date     ,  8                  *           
* 4  NUMPECA      ,Character, 12                  *           
* 5  QUANTIDADE   ,Numeric  , 10                  *           
* 6  VLORUNIT     ,Numeric  , 10 , 02             *         
* 7  ICMS         ,Numeric  ,  5                  *           
* 8  IPI          ,Numeric  ,  3                  *           
* 9  ITEM         ,Numeric  ,  4                  *           
*10  ENDERECO     ,Character, 10                  *
***************************************************
* grava nas tabelas :                             * 
* SF1 / SD1 - NFs de entrada                      *
* SDB       - MOVIMENTOS DE DISTRIBUICAO          *
* SBE       - Cadastro de Enderecos               * 
* SBF       - Saldos por Endereco                 *
* DC8       - Estrutura Fisica                    *
***************************************************

IF !MSGYESNO("Deseja prosseguir ?")
   RETURN(.F.)
ENDIF    
dbUseArea( .T.,, ALLTRIM(arqimp) , "IMP", .T. , .F. )
IndRegua("IMP",  CriaTrab(Nil,.F.) , " PADR( ALLTRIM( STR(NOTAFISCAL,6) ) , 6 ) ",,,"Selecionando...") 
DBSELECTAREA("IMP"); DBGOTOP()                 
***********************************************
* ordem 1 - F1_FILIAL+F1_DOC+F1_SERIE+F1_LOJA *
***********************************************



importado :=0
WHILE !EOF() 
   MSPROCTXT( "Importando ->"+LEFT(ALLTRIM(STR(IMP->notafiscal)),6)+" "+XFILIAL("SB1") +"  " + ALLTRIM(IMP->numpeca) )   
   *---*
   DBSELECTAREA("SA2"); DBSETORDER(1) // fornecedor
   IF ! DBSEEK( XFILIAL("SA2")+LEFT(IMP->CODFORN,6)+"00" )               //01
      DBSELECTAREA('IMP');DBSKIP();LOOP
   ENDIF   
   *---*
   DBSELECTAREA("SF1"); DBSETORDER(1) // nota fiscal ja existe ?
   IF DBSEEK( XFILIAL("SF1") + LEFT(ALLTRIM(STR(IMP->notafiscal)),6) + serie )
      DBSELECTAREA('IMP');DBSKIP();LOOP
   ENDIF                     
   *---*   
   DBSELECTAREA("SB1") 
   DBSETORDER(1) // produto existe ?
   IF ! DBSEEK( XFILIAL("SB1") + ALLTRIM(IMP->numpeca) )
      DBSELECTAREA('IMP');DBSKIP();LOOP
   ENDIF                     
   *---*     
   importado++
   nfatual := LEFT(ALLTRIM(STR(IMP->notafiscal)),6)
   nr_item := 0
   toticm  := 0 ; vicm    := 0
   totipi  := 0 ; vipi    := 0
   totprod := 0 ; totnota := 0
   DBSELECTAREA("IMP")
   //MSPROCTXT("Importando ->"+LEFT(ALLTRIM(STR(IMP->notafiscal)),6) )    
   GRAVASF1() // grava o cabecalho , depois atualiza com os valores
   DBSELECTAREA("IMP")
   WHILE !EOF() .AND. LEFT(ALLTRIM(STR(IMP->notafiscal)),6)=nfatual   
      totprod := ( IMP->quantidade * IMP->vlorunit )
      totnota += totprod
      *---*
      vicm    := totprod*(IMP->ICMS/100); toticm += vicm
      vipi    := totprod*(IMP->IPI/100 ); totipi += vipi 
      nr_item++
      GRAVASD1()
      DBSELECTAREA("IMP");DBSKIP()
      totprod := 0 
   END 
   *-atualiza totais da nota-*
   RECLOCK("SF1", .f. )
     SF1->F1_baseicm :=  totnota
      SF1->F1_valicm :=  toticm
     SF1->F1_baseipi :=  totnota
      SF1->F1_valipi :=  totipi
     SF1->F1_valmerc :=  totnota
     SF1->F1_valbrut :=  totnota + totipi
   MSUNLOCK()
   DBSELECTAREA("IMP")
END
DBSELECTAREA("IMP")
DBCLOSEAREA()
MSGSTOP("Foram importados "+STR( importado , 5 )+" NFs ")
CLOSE( impsaldo )
RETURN(.t.)

*************************************************************************************************************
*                                    grava sd1 - detalhe                                                    *
*************************************************************************************************************
STATIC FUNCTION GRAVASD1()                   
antes := GETAREA()
RECLOCK("SD1",.t.)
   SD1->D1_filial :=  xFilial("SD1")                   //01
     SD1->D1_item :=  STRzero(nr_item,4)               //STRZERO(IMP->ITEM,4)
      SD1->D1_cod :=  SB1->B1_COD           
       SD1->D1_um :=  SB1->B1_UM
    SD1->D1_quant :=  IMP->quantidade
    SD1->D1_vunit :=  IMP->vlorunit
    SD1->D1_total :=  totprod
    SD1->D1_custo :=  totprod
   SD1->D1_valipi :=  vipi
   SD1->D1_valicm :=  vicm
      SD1->D1_tes :=  tepadrao
DBSELECTAREA("SF4");DBSETORDER(1);DBSEEK( XFILIAL("SF4") + tepadrao );DBSELECTAREA("SD1")      
       SD1->D1_cf := SF4->F4_CF  
      SD1->D1_ipi := IMP->ipi
     SD1->D1_picm := IMP->ICMS
  SD1->D1_fornece := SA2->A2_COD
     SD1->D1_loja := SA2->A2_LOJA
    SD1->D1_local := "01"
      SD1->D1_doc := LEFT(ALLTRIM(STR(IMP->notafiscal)),6) 
  SD1->D1_emissao := IMP->dataemissa
  SD1->D1_dtdigit := dDataBase
    SD1->D1_grupo := SB1->B1_GRUPO
     SD1->D1_tipo := "N"
    SD1->D1_serie := serie
       SD1->D1_tp := SB1->B1_TIPO
  SD1->D1_baseicm := totprod
  SD1->D1_baseipi := totprod
MSUNLOCK()
RESTAREA(antes)      
*--saldo do endereco--*
xSBF  := GETAREA()
xSeek := XFILIAL("SBF") + SD1->D1_LOCAL + PADR( ALLTRIM(IMP->endereco) , 15 ) + SB1->B1_COD 
DBSELECTAREA("SBF");DBSETORDER(1)
IF !DBSEEK( xSeek )
   RECLOCK("SBF" , .t. )
      SBF->BF_filial  := XFILIAL("SBF") 
      SBF->BF_produto := SB1->B1_COD    
      SBF->BF_local   := SB1->B1_LOCAL
      SBF->BF_prior   := "999"
      SBF->BF_localiz := ALLTRIM(IMP->endereco)   
      SBF->BF_quant   := IMP->quantidade
   MSUNLOCK()
ELSE 
   RECLOCK("SBF" , .f. )
      SBF->BF_quant   += IMP->quantidade
   MSUNLOCK()
ENDIF      
RESTAREA(xSBF)
RETURN(.t.)

***************************************************************************************************************
*                                     grava sf1 - cabecalho                                                   *
***************************************************************************************************************
STATIC FUNCTION GRAVASF1()
antes := GETAREA()
*----------------*
RECLOCK("SF1" , .t. )
  SF1->F1_filial  :=  xFilial("SF1")
      SF1->F1_doc :=  LEFT(ALLTRIM(STR(IMP->notafiscal)),6) 
    SF1->F1_serie :=  serie
  SF1->F1_fornece :=  IMP->codforn
     SF1->F1_loja :=  SA2->A2_LOJA       // "01"
     SF1->F1_cond :=  "001"
  SF1->F1_emissao :=  IMP->dataemissa
      SF1->F1_est :=  SA2->A2_EST
  SF1->F1_baseicm :=  0
   SF1->F1_valicm :=  0
  SF1->F1_baseipi :=  0
   SF1->F1_valipi :=  0
  SF1->F1_valmerc :=  0
  SF1->F1_valbrut :=  0
     SF1->F1_tipo :=  "N"
  SF1->F1_dtdigit :=  dDataBase
  SF1->F1_especie :=  "NFE"  
    SF1->F1_moeda :=   1
   SF1->F1_status :=  "A"
  SF1->F1_recbmto :=  dDataBase
MSUNLOCK()  
RESTAREA(antes)
RETURN(.t.)
                       


