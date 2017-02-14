// Lay-Out do relatório.
// ---------------------
// NOME USUARIO    NOME COMPLETO                  DIRETORIO DE IMPRESSAO         MENUS DE ACESSO
// XxxxxxxxxxxxxxX XxxxxxxxxxxxxxxxxxxxxxxxxxxxxX XxxxxxxxxxxxxxxxxxxxxxxxxxxxxX XxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxX
// 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
// 0        1         2         3         4         5         6         7         8         9        10        11        12
#INCLUDE "rwmake.ch"

User Function RLEGUsers()
//+-------------------------+
//| Declaracao de Variaveis |
//+-------------------------+
Local aOrd          := {}
Local cDesc1        := "Este programa tem como objetivo imprimir uma lista, mostranto todos"
Local cDesc2        := "usuarios existentes no sistema com o respectivo diretorio de impressao"
Local cDesc3        := "e menus de acesso"
Local cPict         := ""
Local titulo        := "Lista de Usuarios"
Local nLin          := 80
Local Cabec1        := "NOME USUARIO    NOME COMPLETO                  DIRETORIO DE IMPRESSAO         MENUS DE ACESSO"
Local Cabec2        := ""
Local imprime       := .T.

Private CbTxt       := ""
Private cString     := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 132
Private tamanho     := "M"
Private Nomeprog    := "RLEG" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RLEG" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SA1"

//+-------------------------------------------+
//| Monta a interface padrao com o usuario... |
//+-------------------------------------------+

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//+---------------------------------------------------------------------+
//| Processamento. RPTSTATUS monta janela com a regua de processamento. |
//+---------------------------------------------------------------------+

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nI       := 0
Local nY       := 0
Local nX       := 0
Local aUsu     := AllUsers(.T.)
Local aMenuUsu := {}
Local nOrdem

//+---------------------------------------------------------------------+
//| SETREGUA -> Indica quantos registros serao processados para a regua |
//+---------------------------------------------------------------------+

SetRegua(Len(aUsu))

//+-----------------------+
//| Ler todos os usuarios |
//+-----------------------+
For nI := 1 To Len(aUsu)

   //+-----------------------------------------+
   //| Verifica o cancelamento pelo usuario... |
   //+-----------------------------------------+
   If lAbortPrint
      @ nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   
   //+----------------------------------------+
   //| Impressao do cabecalho do relatorio... |
   //+----------------------------------------+
   /*
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   */
   // Usuário Bloqueado 
   If aUsu[nI,1,17] //.OR. aUsu[nI,1,1] $ "000000|000022|000147|000224|000150|000063|000151|000150"
   	  Loop
   EndIf

   cLoginUsu := aUsu[nI,1,2] //Login do usuario
   cNomeUsu  := aUsu[nI,1,4] //Nome completo
   cDirImpr  := aUsu[nI,2,3] //Diretório de impressão

   //+---------------------------------------------------------+
   //| Busca todos os menus e modulos que o usuario tem acesso |
   //+---------------------------------------------------------+
   aMenuUsu := {}
  /* 
   For nY := 1 To Len(aUsu[3,3])
      If SubStr(aUsu[nI,3,nY],3,1) <> 'X'
         aAdd( aMenuUsu, SubStr(aUsu[nI,3,nY],4,50))
      Endif
   Next
  */ 
	// Usuário Bloqueado   
/*	
   If aUsu[nI,1,17]
   		Loop
   EndIf		
*/       
   // Só lista os usuários com acesso à Filial Beneditinos
   /*
   _lAchou := .F.
   For yx:=1 To Len(aUsu[nI][2][6])
      If AllTrim(aUsu[nI][2][6][YX]) == "0113"
		 _lAchou := .T.
      EndIf
   Next
   
   If !_lAchou 
   		Loop
   EndIf
   */
   
   @ nLin, 001 PSay SubStr(cLoginUsu,1,15)
   @ nLin, 017 PSay SubStr(cNomeUsu,1,30)
   @ nLin, 048 PSay SubStr(cDirImpr,1,30)
   nLin++
/*
   For yx:=1 To Len(aUsu[nI][2][6])
      @ nLin, 079 PSay "Teste " + aUsu[nI][2][6][YX]
      nLin++
   Next
*/             
/*
   For nX := 1 To Len(aMenuUsu)
      @ nLin, 079 PSay SubStr(aMenuUsu[nX],1,50)
      nLin++
   Next
*/   
   // @ nLin, 001 PSay Replicate("-",Limite)
   
   nLin ++
      
Next

//+-------------------------------------+
//| Finaliza a execucao do relatorio... |
//+-------------------------------------+
SET DEVICE TO SCREEN

//+------------------------------------------------------------+
//| Se impressao em disco, chama o gerenciador de impressao... |
//+------------------------------------------------------------+
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return