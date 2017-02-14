#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99 

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

/******************************************************************************
* Programa.......: NFGEF02()                                                  *
* Autor..........: Marcelo Aguiar Pimentel                                    *
* Data...........: 23/04/2007                                                 *
* Descricao......: Impressão de Nota Fiscal de servicos - Mod.7 GEFCO         *
*                                                                             *
*******************************************************************************
* Modificado por.:                                                            *
* Data...........:                                                            *
* Motivo.........:                                                            *
*                                                                             *
******************************************************************************/
User Function NFGEF02()
Local aDriver := ReadDriver()

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,CPEDANT,NLININI")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XSAIDA,XTOT_FAT,XLOJA,XFRETE")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XVOLUME,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED")
SetPrvt("XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,XQTD_PRO,XPRE_UNI")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,XPESO_PRO,XPESO_UNIT")
SetPrvt("XDESCRICAO,XUNID_PRO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,")
SetPrvt("XMEN_POS,XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ")
SetPrvt("I,NPELEM,_CLASFIS,NPTESTE,XPESO_LIQUID,XPED")
SetPrvt("XPESO_BRUTO,XP_LIQ_PED,XCLIENTE,XTIPO_CLI,XCOD_MENS,XMENSAGEM")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI,xLOCENTR")
SetPrvt("XDESC_PRO,J,XCOD_CLI,XNOME_CLI,XEND_CLI,XBAIRRO")
SetPrvt("XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF")
SetPrvt("ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP")
SetPrvt("XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP")
SetPrvt("XVALOR_DUP,XDUPLICATAS,XNATUREZA,XFORNECE,XNFORI,XPEDIDO")
SetPrvt("XPESOPROD,XFAX,NOPC,CCOR,NTAMDET,XB_ICMS_SOL")
SetPrvt("XV_ICMS_SOL,NCONT,NCOL,NTAMOBS,NAJUSTE,BB")
SetPrvt("XREDESP,XRD_NOME_TRANSP,XRD_END_TRANSP,XRD_MUN_TRANSP,XRD_EST_TRANSP")
SetPrvt("XRD_VIA_TRANSP,XRD_CGC_TRANSP,XRD_TEL_TRANSP")
SetPrvt("XPESO_PRO_B,XPESO_BRUT,XPBRUTO_UNI,X_PESO_BRUTO,XPESOBRUTO") 
SetPrvt("CDESCR,XCOMPLEMENT,NTAMDESCR,NTAMMAX,NPASS,NTAMDESCRINI,XLOTE,XPOSITE,XDESC_GRUPO")

Private xOBS :=""
Private xVALOR_ISS:=0
Private nPagAtual :=1
Private nDifPg	:=0 //Primeira Nota F(0) segunda(6) // Quantidade somanda na linha para segunda NF em frente
Private aCab:={}
Private aImp:={}
Private _cRefGefco := ""

Private lImprimiu  := .F.

// Configura a impressora para linha e coluna 0

//+--------------------------------------------------------------+
//¦ Define Variaveis Ambientais                                  ¦
//+--------------------------------------------------------------+
//
// variavel w_msg1  e w_msg2 , customizacao para imprimir mensagem na nf de entrada
// O CAMPO e o f1_message e é alimentado pelo ponto de entrada sf100i by rfd 23/01/2002
//
w_msg1    := space(120)
w_msg2    := space(120)
w_msg3    := space(120)
w_msg4    := space(120)

CbTxt     := ""
CbCont    := ""
nOrdem    := 0
Alfa      := 0
Z         := 0
M         := 0
tamanho   := "M"  // "G"  // "P"
limite    := 132//132 // 220  // 132
titulo    := PADC("Nota Fiscal - Nfiscal",74)
cDesc1    := PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2    := ""
cDesc3    := PADC("da Nfiscal",74)
cNatureza := ""
xLOCENTR  := space(30)

aReturn   := { "Especial"      ,;  //
               1               ,;  //
               "Administracao" ,;  //
               2               ,;  // Compactar 
               2               ,;  //
               1               ,;  //
               ""              ,;  //
               1 }                 //

nomeprog  := "nfiscal"
cPerg     := "NFSIGW"
nLastKey  := 0 
lContinua := .T.
nLin      := 0
wnrel     := "siganf"    
w_totpecas:= 0

//+-----------------------------------------------------------+
//¦ Tamanho do Formulario de Nota Fiscal (em Linhas)          ¦
//+-----------------------------------------------------------+
nTamNf    := 50        // Apenas Informativo
nTamDet   := 15//GetMV("MV_NUMITEM")
//GetMV("MV_NUMNF")  // Em 14/10/04 foi criado para permitir quebra pela impressão
nNFImpressas := 1      

//+--------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal¦
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Da Nota Fiscal                       ¦
//¦ mv_par02             // Ate a Nota Fiscal                    ¦ 
//¦ mv_par03             // Da Serie                             ¦ 
//¦ mv_par04             // Nota Fiscal de Entrada/Saida         ¦ 
//¦ mv_par05             // Aglutina produtos com mesmo cod/preco¦ 
//+--------------------------------------------------------------+
Pergunte(cPerg,.F.)     // Pergunta no SX1
cString:="SF2"          // Cabecalho da NF de saida 

wnrel := SetPrint( cString ,;   //   Alias do Arquivo Principal
                   wnrel   ,;   //   Nome padrao do relatorio
                   cPerg   ,;   //   Nome do Grupo de Perguntas
                   Titulo  ,;   //   Titulo do Relatorio
                   cDesc1  ,;   //   Descricao do relatorio 1
                   cDesc2  ,;   //                          2
                   cDesc3  ,;   //                          3
                   .T.)         //   Habilita o Dic Dados

If nLastKey == 27
   Return
Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦          
//+--------------------------------------------------------------+
SetDefault(aReturn, cString)

If nLastKey == 27
   Return
Endif

//+--------------------------------------------------------------+
//¦                                                              ¦
//¦ Inicio do Processamento da Nota Fiscal                       ¦
//¦                                                              ¦
//+--------------------------------------------------------------+
//SetPrc(0,0)
//If aReturn[5] <> 2 
//	alert(1)
//	@ pRow(),pCol() PSAY &(If(aReturn[4]=1,aDriver[3],aDriver[4]))
//EndIf

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})
   Return
   Static Function RptDetail()
#ENDIF

If mv_par04 == 2   

   // NF Saida

   // mv_par01 = Numero inicial para emissao da  nota
   // mv_par02 = Numero final para emissao da nota
   // mv_par03 = Serie da nota fiscal
   //

   // * Cabecalho da Nota Fiscal Saida
   
   dbSelectArea("SF2")                
   dbSetOrder(1)
   dbSeek(xFilial("SF2") + ;
          mv_par01       + ;
          mv_par03,.t.)


   // * Itens de Venda da Nota Fiscal
  
   dbSelectArea("SD2")                
   dbSetOrder(3)
   dbSeek(xFilial("SD2") + ;
          mv_par01       + ;
          mv_par03)           
          
   cPedant := SD2->D2_PEDIDO

Else

   
   // Nota Fiscal de Entrada
   

   // * Cabecalho da Nota Fiscal Entrada
   
   dbSelectArea("SF1")                
   DbSetOrder(1)
   dbSeek(xFilial("SF1") +  ;
          mv_par01       +  ;
          mv_par03,.t.)     
          
   w_msg1 = substr(f1_message,1,120)       
   w_msg2 = substr(f1_message,121,120)       
   w_msg3 = substr(f1_msg,1,120)       
   w_msg4 = substr(f1_msg,121,120)       


   // * Itens da Nota Fiscal de Entrada
  
   dbSelectArea("SD1")                
   dbSetOrder(3)

Endif


// Inicializa  regua de impressao   
// Nota final - Nota inicial (Total de Registros )

SetRegua( Val(mv_par02) - Val(mv_par01))    

If mv_par04 == 2

   // Nota de Saida    
   dbSelectArea("SF2")
   
   While SF2->F2_FILIAL == xFilial("SF2") .AND. SF2->F2_DOC >= mv_par01 .and. SF2->F2_DOC <= mv_par02 .and. lContinua .and. !eof()


      // Se a serie do arquivo for diferente
      // do parametro informado !!!
     
      If SF2->F2_SERIE # mv_par03
         DbSkip()                   
         Loop
      Endif
      
      // Veririca se houve cancelamento pelo operador

      #IFNDEF WINDOWS
	      IF LastKey()==286
	         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
	         lContinua := .F.
	         Exit
	      Endif
      #ELSE
	      IF lAbortPrint
	         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
	         lContinua := .F.
	         Exit
	      Endif
      #ENDIF

      // Linha Inicial da Impressao     
      nLinIni := nLin
     
      // Inicio de Levantamento dos Dados 
      // para emissao da Nota Fiscal de saida

      // Cabecalho da Nota Fiscal

      xNUM_NF     := SF2->F2_DOC             // Numero
      xSERIE      := SF2->F2_SERIE           // Serie
      xEMISSAO    := SF2->F2_EMISSAO         // Data de Emissao
      xTOT_FAT    := SF2->F2_VALBRUT          // Valor Bruto da Fatura       
      xLOJA       := SF2->F2_LOJA            // Loja do Cliente
      xFRETE      := SF2->F2_FRETE           // Frete
      xSEGURO     := SF2->F2_SEGURO          // Seguro
      xBASE_ICMS  := SF2->F2_BASEICM         // Base   do ICMS
      xBASE_IPI   := SF2->F2_BASEIPI         // Base   do IPI
      xVALOR_ICMS := SF2->F2_VALICM          // Valor  do ICMS
      xICMS_RET   := SF2->F2_ICMSRET         // Valor  do ICMS Retido
      xVALOR_IPI  := SF2->F2_VALIPI          // Valor  do IPI
      xVALOR_MERC := SF2->F2_VALMERC         // Valor  da Mercadoria
	  xVALOR_ISS  := SF2->F2_VALISS
      xNUM_DUPLIC := SF2->F2_DUPL            // Numero da Duplicata
      xCOND_PAG   := SF2->F2_COND            // Condicao de Pagamento
      xPBRUTO     := SF2->F2_PBRUTO          // Peso Bruto NF
      xPLIQUI     := SF2->F2_PLIQUI          // Peso Liquido NF
      xTIPO       := SF2->F2_TIPO            // Tipo do Cliente
      xESPECIE    := SF2->F2_ESPECI1         // Especie 1 no Pedido
      xVOLUME     := SF2->F2_VOLUME1         // Volume 1 no Pedido
      
      // Total da Nota
      
      if xTOT_FAT == 0
         xTOT_FAT := SF2->F2_VALMERC + ;
                     SF2->F2_VALIPI  + ;
                     SF2->F2_SEGURO  + ;
                     SF2->F2_FRETE
      endif
      

      // Itens de Venda da N.F.

      dbSelectArea("SD2")                   
      dbSetOrder(3)
      dbSeek(xFilial("SD2") + ;
             xNUM_NF        + ;
             xSERIE)

      cPedAtu   := SD2->D2_PEDIDO
      cItemAtu  := SD2->D2_ITEMPV 
      
      // Inicia Vetores

      xPED_VEND :={}   // Numero do Pedido de Venda
      xITEM_PED :={}   // Numero do Item do Pedido de Venda
      xNUM_NFDV :={}   // nUMERO QUANDO HOUVER DEVOLUCAO
      xPREF_DV  :={}   // Serie  quando houver devolucao
      xICMS     :={}   // Porcentagem do ICMS
      xCOD_PRO  :={}   // Codigo  do Produto
      xQTD_PRO  :={}   // Quantidade do Produto
      xPRE_UNI  :={}   // Preco Unitario de Venda
      xPRE_TAB  :={}   // Preco Unitario de Tabela
      xIPI      :={}   // Porcentagem do IPI
      xVAL_IPI  :={}   // Valor do IPI
      xDESC     :={}   // Desconto por Item
      xVAL_DESC :={}   // Valor do Desconto
      xVAL_MERC :={}   // Valor da Mercadoria
      xTES      :={}   // TES
      xCF       :={}   // Classificacao quanto natureza da Operacao
      xICMSOL   :={}   // Base do ICMS Solidario
      xICM_PROD :={}   // ICMS do Produto
      xPOSITE   :={}   // Posicao do Item
      gUnidade  :={}   // unidade de medida
      x_CODPRE  :={}   // vetor-indice codigo+preco

      // Enquanto houver itens na nota fiscal      
      while SD2->D2_FILIAL == xFilial("SD2") .AND. SD2->D2_DOC   == xNUM_NF .and. ;
            SD2->D2_SERIE == xSERIE  .and. ;
            !eof()

         // Se a Serie do Arquivo for Diferente
         // do Parametro Informado !!!

		 If SD2->D2_SERIE # mv_par03
            DbSkip()                   
            Loop
   		 Endif

         // Vetores para armazanar dados de cada item a ser impresso  
         // Obs: Dados vindos do Itens da Nota de Saida

         // Procura no vetor-indice se existe um produto com o mesmo cod/preco
	     nAchouProd := aScan(x_CODPRE,SD2->D2_COD+Str(SD2->D2_PRCVEN))
		
         // Aglutina produtos iguais com preços iguais
/*
		 if nAchouProd > 0 .and. mv_par05 = 1
		    xQTD_PRO[nAchouProd] 	+= SD2->D2_QUANT                            // Guarda as quant. da NF
		    xVAL_IPI[nAchouProd] 	+= SD2->D2_VALIPI                           // Valor do IPI
		    xDESC[nAchouProd] 		+= SD2->D2_DESC                             // Valor Desconto
		    xVAL_MERC[nAchouProd] 	+= SD2->D2_TOTAL                            // Total do Item
		 else
*/
		    AADD(x_CODPRE, SD2->D2_COD+Str(SD2->D2_PRCVEN))					// Adiciona chave ao vetor-indice
		    AADD(xPED_VEND , SD2->D2_PEDIDO)                                   // Numero do Pedido
	   	    AADD(xITEM_PED , SD2->D2_ITEMPV)                                   // Item do Pedido de Venda
			AADD(xNUM_NFDV , IIF(Empty(SD2->D2_NFORI), "" , SD2->D2_NFORI))    // Nota Original  (Devolucao)
	 	    AADD(xPREF_DV  , SD2->D2_SERIORI)                                  // Serie Original (Devolucao)
			AADD(xICMS     , IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))          // Aliq. de ICMS
			AADD(xCOD_PRO  , SD2->D2_COD)                                      // Codigo do Produto
			AADD(xQTD_PRO  , SD2->D2_QUANT)                                    // Guarda as quant. da NF
			AADD(xPRE_UNI  , SD2->D2_PRCVEN)                                   // Preco de Venda
			AADD(xPRE_TAB  , SD2->D2_PRUNIT)                                   // Preco Unitario
	        AADD(xIPI      , IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))            // Aliq. de IPI
		    AADD(xVAL_IPI  , SD2->D2_VALIPI)                                   // Valor do IPI
	  	    AADD(xDESC     , SD2->D2_DESC)                                     // Valor Desconto
			AADD(xVAL_MERC , SD2->D2_TOTAL)                                    // Total do Item
		    AADD(xTES      , SD2->D2_TES)                                      // TES do Produto
	   	    AADD(xCF       , SD2->D2_CF)                                       // Codigo Fiscal
			AADD(xICM_PROD , IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))          //
		    AADD(xPOSITE   , SD2->D2_ITEM )
			AADD(gUnidade  , SD2->D2_UM)                                    // Guarda as quant. da NF            
//		 endif
		 dbSelectArea("SD2")
         dbskip()
      End

      // * Desc. Generica do Produto
      dbSelectArea("SB1")
      dbSetOrder(1)     
      
      // Inicia Vetores
      xPESO_PRO   := {}       // Peso Liquido
      xPESO_UNIT  := {}       // Peso Unitario do Produto
      xDESCRICAO  := {}       // Descricao do Produto
      xUNID_PRO   := {}       // Unidade do Produto
      xCOD_TRIB   := {}       // Codigo de Tributacao
      xMEN_TRIB   := {}       // Mensagens de Tributacao
      xCOD_FIS    := {}       // Cogigo Fiscal
      xCLAS_FIS   := {}       // Classificacao Fiscal
      xMEN_POS    := {}       // Mensagem da Posicao IPI
      xISS        := {}       // Aliquota de ISS
      xTIPO_PRO   := {}       // Tipo do Produto
      xLUCRO      := {}       // Margem de Lucro p/ ICMS Solidario
      xCLFISCAL   := {}       // Classificacao fiscal
      xPBRUTO_UNI := {}       // Peso Bruto Unitario
      xPESO_PRO_B := {}       // Peso Bruto Total do Item
      xPESO_LIQ   := 0         // Peso Liquido
      xPESO_BRUT  := 0         // Peso Bruto   
      xDESC_GRUPO := {}        // Descricao do Grupo 

      I           := 1         // Indice do Loop

      // Para cada item encontrado na nota fical e armazenado
      // no vetor xCOD_PROD, executar:
      For I := 1 to Len(xCOD_PRO)

          // Busca Cadastro do Produto
          dbSeek(xFilial()+xCOD_PRO[I])

          // Calcular o Peso liquido e Bruto total do item  
          // xQTD_PRO[I] = Quantidade do Item na Nota Fiscal 
          AADD( xPESO_PRO  , SB1->B1_PESO  * xQTD_PRO[I])
//          AADD( xPESO_PRO_B, SB1->B1_PESOB * xQTD_PRO[I])

          // Acumula o Peso Liquido e Bruto Total da Nota Fiscal
          xPESO_LIQ  := xPESO_LIQ  + xPESO_PRO[I]
          xPESO_BRUT := xPESO_BRUT //+ xPESO_PRO_B[I]

          // Guarda peso Liquido e Bruto Unitario     
          AADD(xPESO_UNIT , SB1->B1_PESO  )
//          AADD(xPBRUTO_UNI, SB1->B1_PESOB )
          
          AADD(xUNID_PRO  , gUnidade[I]    )                       

          // Armazena Descricao do produto
          AADD(xDESCRICAO , SB1->B1_DESC  ) 

          // Armazena Codigo de Tributacao
          AADD(xCOD_TRIB  , SB1->B1_ORIGEM )

          // Procura no vetor xMEN_TRIB a origem do cadastro de Itens
          // caso nao encontre armazena no vetor
          If Ascan(xMEN_TRIB, SB1->B1_ORIGEM) == 0
             AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
          Endif

          // Procura posicao classificacao do IPI no vetor xCLASS_FIS
          // --------------------------------------------------------
          npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)

          // Se nao encontrar atribui o cadastrado em SB1
          // --------------------------------------------
          if npElem == 0
             AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
          endif        
          
          // Classificacao Fiscal 
          // --------------------------------------------   
          npElem := Ascan(xCLFISCAL, SB1->B1_CLASFIS )
          if npElem = 0
             AADD(xCLFISCAL, SB1->B1_CLASFIS )   
          endif                                
          
          // Busca Descricao do Grupo do Produto
          // --------------------------------------------- 
          cOld  := Alias() 
          dbSelectArea("SBM")
          DbSetOrder(1)
          dbSeek(xFilial("SBM") + SB1->B1_GRUPO )         
          AADD(xDESC_GRUPO, SBM->BM_DESC )                     
                 
          Select(cOld)       
                 
          // Busca Descricao na Tabela SX5
          // --------------------------------------------- 
          cOld  := Alias() 
          dbSelectArea("SX5")
          DbSetOrder(1)
          dbSeek(xFilial("SX5") + ;
                 "Z1"           + ;
                 SB1->B1_CLASFIS )
          
          if npElem = 0
             AADD(xCLAS_FIS, SX5->X5_DESCRI ) 
          endif   
          
          Select(cOld)  
          
          AADD(xCOD_FIS , SB1->B1_CLASFIS ) 
                   
          If SB1->B1_ALIQISS > 0
             AADD(xISS ,SB1->B1_ALIQISS)
          Endif

          // Armazenar nos vetores TIPO, e ICMS RETIDO
          AADD(xTIPO_PRO , SB1->B1_TIPO    )
          AADD(xLUCRO    , SB1->B1_PICMRET )


          // Calculo do Peso Liquido da Nota Fiscal
          xPESO_LIQUID := 0
          For j := 1 to Len(xPESO_PRO)
             xPESO_LIQUID  := xPESO_LIQUID + xPESO_PRO[ j ]
          Next

//          x_PESO_BRUTO := 0
//          For j := 1 to Len(xPESO_PRO_B)
//              x_PESO_BRUTO := x_PESO_BRUTO + xPESO_PRO_B[ j ]
//          Next
      Next

      // Busca informacoes no Pedido de Venda
      dbSelectArea("SC5")                            
      dbSetOrder(1)

      xPED        := {}
      xPESO_BRUTO := 0
      xP_LIQ_PED  := 0

      // Para cada item encontrado na nota fical e armazenado
      // no vetor xPED_VEND, executar:
      For I := 1 to Len( xPED_VEND )

         // Procura Pedido de Venda
         DBSeek( xFilial("SC5") + ;
                 xPED_VEND[I] )

         // Verifica se pedido esta armazenado           
         If ASCAN(xPED, xPED_VEND[I]) == 0

            // Procura Pedido de Venda (Banco)
            dbSeek(xFilial("SC5") + ;
                   xPED_VEND[I] )
            
            xCLIENTE   := SC5->C5_CLIENTE      // Codigo do Cliente
            xTIPO_CLI  := SC5->C5_TIPOCLI      // Tipo de Cliente
            xCOD_MENS  := SC5->C5_MENPAD       // Codigo da Mensagem Padrao
            xMENSAGEM  := SC5->C5_MENNOTA      // Mensagem para a Nota Fiscal
            xTPFRETE   := SC5->C5_TPFRETE      // Tipo de Entrega
            xCONDPAG   := SC5->C5_CONDPAG      // Condicao de Pagamento 
			xOBS	   := SC5->C5_XOBS
			
			xOBS 	   := StrTran(xOBS,CHR(13)," ") // Retira o Enter
			xOBS 	   := StrTran(xOBS,CHR(10)," ") // Retira o Line Feed
						
			_cRefGefco := SC5->C5_REFGEFC      // Referência Gefco
//            xLOCENTR   := SC5->C5_LOCENTR      // Local de entrega
            
            // Criado em 13/03/01        
            // Verificar a possibilidade de retirar este campo e
            // coloca-lo no SX1
            // -------------------------------------------------
            // xSAIDA      := SC5->C5_DTSAIDA            
            
            // Pega o peso Bruto no pedido

            xPESO_BRUTO := xPESO_BRUTO + SC5->C5_PBRUTO    

            // Pega o peso liquido do pedido

            xP_LIQ_PED  := xP_LIQ_PED  + SC5->C5_PESOL     

            // Pega codigo dos Vendedores

            xCOD_VEND:= { SC5->C5_VEND1 ,;   // Codigo do Vendedor 1
                          SC5->C5_VEND2 ,;   // Codigo do Vendedor 2
                          SC5->C5_VEND3 ,;   // Codigo do Vendedor 3
                          SC5->C5_VEND4 ,;   // Codigo do Vendedor 4
                          SC5->C5_VEND5 }    // Codigo do Vendedor 5

            // Pega Descontos

            xDESC_NF := {SC5->C5_DESC1  ,;   // Desconto Global 1
                         SC5->C5_DESC2  ,;   // Desconto Global 2
                         SC5->C5_DESC3  ,;   // Desconto Global 3
                         SC5->C5_DESC4 }     // Desconto Global 4

            // Pega Redespahao cadastrado

            xREDESP  := SC5->C5_REDESP       // Redespacho
            
            // Adiciona pedido a relacao   
            
            AADD(xPED, xPED_VEND[I])

         Endif

         // Caso o valor do peso liquido apurado seja maior do que 0.00
         // o sistema assume este valor
         // Obs: Este valor vem da digitacao do peso liquido no pedido
         // Ajustado em 21/03/01

         If xP_LIQ_PED > 0
            xPESO_LIQUID := xP_LIQ_PED
         Endif

         if xPESO_BRUTO > 0
            x_PESO_BRUTO := xPESO_BRUTO
         endif

      Next

      //+---------------------------------------------+
      //¦ Pesquisa da Condicao de Pagto               ¦
      //+---------------------------------------------+

      // Condicao de Pagamento

      dbSelectArea("SE4")                    
      dbSetOrder(1)

      // Busca condicao de pagamento

      dbSeek(xFilial("SE4")+xCONDPAG)
      xDESC_PAG := SE4->E4_DESCRI

      // Itens de Pedido de Venda

      dbSelectArea("SC6")                    
      dbSetOrder(1)

      xPED_CLI    := {}   // Numero de Pedido
      xDESC_PRO   := {}   // Descricao aux do produto   
      xCOMPLEMENT := {}   // Complemento da Descricao  
      xLOTE       := {}   // Codigo de Localizacao

      // Para cada item encontrado na nota fical e armazenado
      // no vetor xPED_VEND, executar:
      w_totpecas:= 0

      J := Len(xPED_VEND)
      For I := 1 to J

         // Buscar o Item no cadastro de pedidos
         dbSeek(xFilial()+xPED_VEND[I]+xITEM_PED[I])

         // Atribui os Valores aos respectivos vetores

         AADD(xPED_CLI   , SC6->C6_PEDCLI  )  // Numero Pedido Cliente
         AADD(xDESC_PRO  , SC6->C6_DESCRI  )  // Descricao do Pedido
         AADD(xCOMPLEMENT, SC6->C6_XOBS    )  // Complemento da Descricao do Produto         
         AADD(xVAL_DESC  , SC6->C6_VALDESC )  // Valor do Desconto    
         AADD(xLOTE      , SC6->C6_LOTECTL )  // Codigo de Lote  

/*
         If SubStr(SC6->C6_PRODUTO,1,4) == "2000"  // se bloco
            AADD( xCOMPLEMENT, " "  + Alltrim(Str(SC6->C6_COMPRIM,10,3)) + " " + ; // Complemento da Descricao 
                               " X " + Alltrim(Str(SC6->C6_ALTURA,10,3)) + " " + ;                             
                               " X " + Alltrim(Str(SC6->C6_LARGURA,10,3)))            
         Else
            AADD( xCOMPLEMENT, " "  + Alltrim(Str(SC6->C6_COMPRIM,10,3)) + " " + ; // Complemento da Descricao
                               " X " + Alltrim(Str(SC6->C6_ALTURA,10,3)) + " " + ;                             
                               " X " + Alltrim(Str(SC6->C6_QTCHAPA,10)) )   
         EndIf                            
*/                            
         w_totpecas = SC5->C5_VOLUME1
      Next

      // Tipos de Pedidos
      // ----------------
      If xTIPO == 'N' .OR. ;  // Pedido Normal
         xTIPO == 'C' .OR. ;  //
         xTIPO == 'P' .OR. ;  // Complemento de IPI
         xTIPO == 'I' .OR. ;  //
         xTIPO == 'S' .OR. ;  //
         xTIPO == 'T' .OR. ;  //
         xTIPO == 'O'         //

         // Cadastro de Clientes
         // --------------------
         dbSelectArea("SA1")                
         dbSetOrder(1)
         dbSeek(xFilial("SA1")+xCLIENTE+xLOJA)
         
         xCOD_CLI  := SA1->A1_COD          // Codigo do Cliente
         xNOME_CLI := SA1->A1_NOME         // Nome
         xEND_CLI  := SA1->A1_END          // Endereco
         xBAIRRO   := SA1->A1_BAIRRO       // Bairro
         xCEP_CLI  := SA1->A1_CEP          // CEP
         xCOB_CLI  := SA1->A1_ENDCOB       // Endereco de Cobranca
         xREC_CLI  := SA1->A1_ENDENT       // Endereco de Entrega
         xMUN_CLI  := SA1->A1_MUN          // Municipio
         xEST_CLI  := SA1->A1_EST          // Estado
         xCGC_CLI  := SA1->A1_CGC          // CGC
         xINSC_CLI := SA1->A1_INSCR        // Inscricao estadual
         xTRAN_CLI := SA1->A1_TRANSP       // Transportadora
         xTEL_CLI  := SA1->A1_TEL          // Telefone
         xFAX_CLI  := SA1->A1_FAX          // Fax
         xSUFRAMA  := SA1->A1_SUFRAMA      // Codigo Suframa
         xCALCSUF  := SA1->A1_CALCSUF      // Calcula Suframa
         
         // Alteracao p/ Calculo de Suframa
         // -------------------------------
         if !empty(xSUFRAMA) .and. xCALCSUF == "S"
            IF XTIPO == 'D' .OR. XTIPO == 'B'
               zFranca := .F.
            else
               zFranca := .T.
            endif
         Else
            zfranca:= .F.
         endif

      Else

         zFranca := .F.

         // Cadastro de Fornecedores
         // ------------------------
         dbSelectArea("SA2")                
         dbSetOrder(1)
         dbSeek( xFilial("SA2") + ;
                 xCLIENTE       + ;
                 xLOJA )

         xCOD_CLI := SA2->A2_COD      // Codigo do Fornecedor
         xNOME_CLI:= SA2->A2_NOME     // Nome Fornecedor
         xEND_CLI := SA2->A2_END      // Endereco
         xBAIRRO  := SA2->A2_BAIRRO   // Bairro
         xCEP_CLI := SA2->A2_CEP      // CEP
         xCOB_CLI := ""               // Endereco de Cobranca
         xREC_CLI := ""               // Endereco de Entrega
         xMUN_CLI := SA2->A2_MUN      // Municipio
         xEST_CLI := SA2->A2_EST      // Estado
         xCGC_CLI := SA2->A2_CGC      // CGC
         xINSC_CLI:= SA2->A2_INSCR    // Inscricao estadual
         xTRAN_CLI:= SA2->A2_TRANSP   // Transportadora
         xTEL_CLI := SA2->A2_TEL      // Telefone
         xFAX_CLI := SA2->A2_FAX      // Fax

      Endif

      // Cadastro de Vendedores
      // ----------------------
      dbSelectArea("SA3")                   
      dbSetOrder(1)

      // Para cada item encontrado na nota fical e armazenado
      // no vetor xVENDEDOR, executar:
      // ----------------------------------------------------
      xVENDEDOR := {}

      I := 1
      J := Len(xCOD_VEND)
      For I := 1 to J
         // Busca o nome do vendedor
         dbSeek(xFilial("SA3") + xCOD_VEND[I] )
         Aadd( xVENDEDOR, SA3->A3_NREDUZ )
      Next

      // Apenas se ICMS Retido > 0
      If xICMS_RET > 0
         // Cadastro de Livros Fiscais
         dbSelectArea("SF3")                   
         dbSetOrder(4)
         if dbSeek( xFilial()      + ;
                    SA1->A1_COD    + ;
                    SA1->A1_LOJA   + ;
                    SF2->F2_DOC    + ;
                    SF2->F2_SERIE)
            xBSICMRET := SF3->F3_VALOBSE
         Else
            xBSICMRET := 0
         Endif
      Else
         xBSICMRET := 0
      Endif

      // Transportadoras
      // ---------------
      dbSelectArea("SA4")                   
      dbSetOrder(1)
      dbSeek(xFilial()+SF2->F2_TRANSP)

      xNOME_TRANSP := SA4->A4_NOME           // Nome Transportadora
      xEND_TRANSP  := SA4->A4_END            // Endereco
      xMUN_TRANSP  := SA4->A4_MUN            // Municipio
      xEST_TRANSP  := SA4->A4_EST            // Estado
      xVIA_TRANSP  := SA4->A4_VIA            // Via de Transporte
      xCGC_TRANSP  := SA4->A4_CGC            // CGC
      xTEL_TRANSP  := SA4->A4_TEL            // Fone
      xIE_TRANSP   := SA4->A4_INSEST         // Inscricao Estadual
      
      // Se houver redespacho
      // busca em Transportadoras
      // ------------------------
      if !Empty(xREDESP)
         dbSelectArea("SA4")                   
         dbSetOrder(1)
         dbSeek(xFilial()+xREDESP)

         xRD_NOME_TRANSP := SA4->A4_NOME          // Nome Transportadora
         xRD_END_TRANSP  := SA4->A4_END           // Endereco
         xRD_MUN_TRANSP  := SA4->A4_MUN           // Municipio
         xRD_EST_TRANSP  := SA4->A4_EST           // Estado
         xRD_VIA_TRANSP  := SA4->A4_VIA           // Via de Transporte
         xRD_CGC_TRANSP  := SA4->A4_CGC           // CGC
         xRD_TEL_TRANSP  := SA4->A4_TEL           // Fone
         xIE_TRANSP      := SA4->A4_INSEST        // Inscricao Estadual
      endif
       
      // Contas a Receber
      dbSelectArea("SE1")                   
      dbSetOrder(1)

      xPARC_DUP  :={}      // Parcela
      xVENC_DUP  :={}      // Vencimento
      xVALOR_DUP :={}      // Valor

      // Flag p/Impressao de Duplicatas
      // ------------------------------
      xDUPLICATAS := IIF( dbSeek(xFilial("SE1") + ;
                                 xSERIE         + ;
                                 xNUM_DUPLIC,.T.),.T.,.F.)

      // Enquanto houver duplicatas para esta nota
      // executar:
      // -----------------------------------------
      while SE1->E1_NUM == xNUM_DUPLIC .and. ;
            xDUPLICATAS == .T.         .and. ;
            !eof()

         // Se nao for do tipo NF busca proximo e Retorna
         // ao inicio do loop
         // ---------------------------------------------
         If !("NF" $ SE1->E1_TIPO)
            dbSkip()
            Loop
         Endif

         AADD(xPARC_DUP , SE1->E1_PARCELA )
         AADD(xVENC_DUP , SE1->E1_VENCTO  )
         AADD(xVALOR_DUP, SE1->E1_VLCRUZ   )

         dbSkip()
      EndDo

      // Tipos de Entrada e Saida
      // ------------------------
      dbSelectArea("SF4")                   
      DbSetOrder(1)
      dbSeek(xFilial()+xTES[1])  
      
      // Natureza da Operacao (Vinda do TES - SF4) Alterado para TAPPI
      // para tabela 13 do SX5
      // xNATUREZA := SF4->F4_TEXTO
      // -------------------------------------------------------------
      dbSelectArea("SX5")
      DbSetOrder(1)
      dbSeek(xFilial() + "13" + SF4->F4_CF )
      
      xNATUREZA := SX5->X5_DESCRI    // Natureza da Operacao
     
      // Imprime a Nota Fiscal
      // ---------------------
	  lImprimiu  := .T.       
      Imprime()

      //+--------------------------------------------------------------+
      //¦ Termino da Impressao da Nota Fiscal                          ¦
      //+--------------------------------------------------------------+

      IncRegua()   // Termometro de Impressao

      nLin := 0
   
****************************   
/*
      dbSelectArea("SF2")                
      RecLock("SF2",.F.)  // bloqueia registro  
      If aReturn[5] == 3  // se impressão direta na porta - permite exclusão da NF 
         SF2->F2_FLAGEXC := "S"   // flag de permissão de exclusão da NF
      Else  // se outra impressão - não permite exclusão da NF
         SF2->F2_FLAGEXC := "N"   // flag de permissão de exclusão da NF      
      EndIf   
      MsUnLock()  // libera registro         
*/
****************************            

      // passa para a proxima Nota Fiscal
      // --------------------------------
      dbSelectArea("SF2")
      dbSkip()                      
      
   EndDo

Else      

   // ------------------------------------
   // Cabecalho da Nota Fiscal Entrada
   // ------------------------------------  
   
   dbSelectArea("SF1")              
   dbSeek(xFilial()+mv_par01+mv_par03,.t.)
   
   While !eof() .and.                    ;
         SF1->F1_DOC   <= mv_par02 .and. ;
         SF1->F1_SERIE == mv_par03 .and. ;
         lContinua

      If SF1->F1_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
         DbSkip()                   // do Parametro Informado !!!
         Loop
      Endif

      //+-----------------------------------------------------------+
      //¦ Inicializa  regua de impressao                            ¦
      //+-----------------------------------------------------------+
      SetRegua(Val(mv_par02)-Val(mv_par01))

      #IFNDEF WINDOWS
         IF LastKey() == 286
            @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
            lContinua := .F.
            Exit
         Endif
      #ELSE
         IF lAbortPrint
            @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
	         lContinua := .F.
	         Exit
	      Endif
      #ENDIF

      nLinIni := nLin  // Linha Inicial da Impressao

      //+--------------------------------------------------------------+
      //¦ Inicio de Levantamento dos Dados da Nota Fiscal              ¦
      //+--------------------------------------------------------------+

      xNUM_NF     := SF1->F1_DOC          // Numero
      xSERIE      := SF1->F1_SERIE        // Serie
      xFORNECE    := SF1->F1_FORNECE      // Cliente/Fornecedor
      xEMISSAO    := SF1->F1_EMISSAO      // Data de Emissao
      xTOT_FAT    := SF1->F1_VALBRUT      // Valor Bruto da Compra
      xLOJA       := SF1->F1_LOJA         // Loja do Cliente
      xFRETE      := SF1->F1_FRETE        // Frete
      xSEGURO     := SF1->F1_DESPESA      // Despesa
      xBASE_ICMS  := SF1->F1_BASEICM      // Base do ICMS
      xBASE_IPI   := SF1->F1_BASEIPI      // Base do IPI
      xBSICMRET   := SF1->F1_BRICMS       // Base do ICMS Retido
      xVALOR_ICMS := SF1->F1_VALICM       // Valor do ICMS
      xICMS_RET   := SF1->F1_ICMSRET      // Valor do ICMS Retido
      xVALOR_IPI  := SF1->F1_VALIPI       // Valor do IPI
      xVALOR_MERC := SF1->F1_VALMERC      // Valor  da Mercadoria
      xNUM_DUPLIC := SF1->F1_DUPL         // Numero da Duplicata
      xCOND_PAG   := SF1->F1_COND         // Condicao de Pagamento
      xTIPO       := SF1->F1_TIPO         // Tipo do Cliente
      xNFORI      := SF1->F1_NFORI        // NF Original
      xPREF_DV    := SF1->F1_SERIORI      // Serie Original

      // Itens da N.F. de Compra
      // -----------------------
      dbSelectArea("SD1")                   
      dbSetOrder(1)
      dbSeek(xFilial()+xNUM_NF+xSERIE+xFORNECE+xLOJA)

      cPedAtu := SD1->D1_PEDIDO
      cItemAtu:= SD1->D1_ITEMPC

      xPEDIDO  :={}    // Numero do Pedido de Compra
      xITEM_PED:={}    // Numero do Item do Pedido de Compra
      xNUM_NFDV:={}    // Numero quando houver devolucao
      xPREF_DV :={}    // Serie  quando houver devolucao
      xICMS    :={}    // Porcentagem do ICMS
      xCOD_PRO :={}    // Codigo  do Produto
      xQTD_PRO :={}    // Peso/Quantidade do Produto
      xPRE_UNI :={}    // Preco Unitario de Compra
      xIPI     :={}    // Porcentagem do IPI
      xPESOPROD:={}    // Peso do Produto
      xVAL_IPI :={}    // Valor do IPI
      xDESC    :={}    // Desconto por Item
      xVAL_DESC:={}    // Valor do Desconto
      xVAL_MERC:={}    // Valor da Mercadoria
      xTES     :={}    // TES
      xCF      :={}    // Classificacao quanto natureza da Operacao
      xICMSOL  :={}    // Base do ICMS Solidario
      xICM_PROD:={}    // ICMS do Produto

      while !eof() .and. SD1->D1_DOC == xNUM_NF

         // Se a Serie do Arquivo for Diferente
         // do Parametro Informado !!!
         // -----------------------------------
         If SD1->D1_SERIE #mv_par03        
              DbSkip()                      
              Loop
         Endif

         AADD(xPEDIDO   ,SD1->D1_PEDIDO)         // Ordem de Compra
         AADD(xITEM_PED ,SD1->D1_ITEMPC)         // Item da O.C.
         AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
         AADD(xPREF_DV  ,SD1->D1_SERIORI)        // Serie Original
         AADD(xICMS     ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
         AADD(xCOD_PRO  ,SD1->D1_COD)            // Produto
         // AADD(xQTD_PRO  ,SD1->D1_QTDM3)       // Guarda as quant. da NF
         AADD(xQTD_PRO  ,SD1->D1_QUANT)          // Guarda as quant. da NF
         AADD(xPRE_UNI  ,SD1->D1_VUNIT)          // Valor Unitario
         AADD(xIPI      ,SD1->D1_IPI)            // % IPI
         AADD(xVAL_IPI  ,SD1->D1_VALIPI)         // Valor do IPI
         AADD(xPESOPROD ,SD1->D1_PESO)           // Peso do Produto
         AADD(xDESC     ,SD1->D1_DESC)           // % Desconto
         AADD(xVAL_MERC ,SD1->D1_TOTAL)          // Valor Total
         AADD(xTES      ,SD1->D1_TES)            // Tipo de Entrada/Saida
         AADD(xCF       ,SD1->D1_CF)             // Codigo Fiscal
         AADD(xICM_PROD ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
         dbskip()
      End

      // Desc. Generica do Produto
      // -------------------------
      dbSelectArea("SB1")                     
      dbSetOrder(1)

      xUNID_PRO  := {}   // Unidade do Produto
      xDESC_PRO  := {}   // Descricao do Produto
      xMEN_POS   := {}   // Mensagem da Posicao IPI
      xDESCRICAO := {}   // Descricao do Produto
      xCOD_TRIB  := {}   // Codigo de Tributacao
      xMEN_TRIB  := {}   // Mensagens de Tributacao
      xCOD_FIS   := {}   // Cogigo Fiscal
      xCLAS_FIS  := {}   // Classificacao Fiscal
      xISS       := {}   // Aliquota de ISS
      xTIPO_PRO  := {}   // Tipo do Produto
      xLUCRO     := {}   // Margem de Lucro p/ ICMS Solidario
      xCLFISCAL  := {}   //
      xSUFRAMA   := ""   //
      xCALCSUF   := ""   //

      I := 1
      For I := 1 to Len(xCOD_PRO)

         dbSeek( xFilial() + xCOD_PRO[I] )    
         
         AADD( xDESC_PRO ,SB1->B1_DESC )        

         AADD(xUNID_PRO ,SB1->B1_UM)

         AADD(xCOD_TRIB ,SB1->B1_ORIGEM)                    
         
         If Ascan(xMEN_TRIB, SB1->B1_ORIGEM) == 0
            AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
         Endif

         AADD(xDESCRICAO ,SB1->B1_DESC) 
                  
         AADD(xMEN_POS  ,SB1->B1_POSIPI)
         
         If SB1->B1_ALIQISS > 0
            AADD(xISS,SB1->B1_ALIQISS)
         Endif

         AADD(xTIPO_PRO ,SB1->B1_TIPO)
         AADD(xLUCRO    ,SB1->B1_PICMRET)

         npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)

         if npElem == 0
            AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
         endif
         npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)

         DO CASE
            CASE npElem == 1 ;  _CLASFIS := "A"
            CASE npElem == 2 ;  _CLASFIS := "B"
            CASE npElem == 3 ;  _CLASFIS := "C"
            CASE npElem == 4 ;  _CLASFIS := "D"
            CASE npElem == 5 ;  _CLASFIS := "E"
            CASE npElem == 6 ;  _CLASFIS := "F"

         EndCase              
         
         
         nPteste := Ascan(xCLFISCAL,_CLASFIS)         
         If nPteste == 0
            AADD(xCLFISCAL,_CLASFIS)
         Endif
         
         AADD(xCOD_FIS ,_CLASFIS)

      Next

      //+---------------------------------------------+
      //¦ Pesquisa da Condicao de Pagto               ¦
      //+---------------------------------------------+

      dbSelectArea("SE4")                    // Condicao de Pagamento
      dbSetOrder(1)
      dbSeek(xFilial("SE4")+xCOND_PAG)
      xDESC_PAG := SE4->E4_DESCRI

      If xTIPO == "D"

         dbSelectArea("SA1")                // * Cadastro de Clientes
         dbSetOrder(1)
         dbSeek(xFilial()+xFORNECE)
         xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
         xNOME_CLI:=SA1->A1_NOME            // Nome
         xEND_CLI :=SA1->A1_END             // Endereco
         xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
         xCEP_CLI :=SA1->A1_CEP             // CEP
         xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
         xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
         xMUN_CLI :=SA1->A1_MUN             // Municipio
         xEST_CLI :=SA1->A1_EST             // Estado
         xCGC_CLI :=SA1->A1_CGC             // CGC
         xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
         xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
         xTEL_CLI :=SA1->A1_TEL             // Telefone
         xFAX_CLI :=SA1->A1_FAX             // Fax

      Else

         dbSelectArea("SA2")                // * Cadastro de Fornecedores
         dbSetOrder(1)
         dbSeek(xFilial()+xFORNECE+xLOJA)
         xCOD_CLI :=SA2->A2_COD                // Codigo do Cliente
         xNOME_CLI:=SA2->A2_NOME               // Nome
         xEND_CLI :=SA2->A2_END                // Endereco
         xBAIRRO  :=SA2->A2_BAIRRO             // Bairro
         xCEP_CLI :=SA2->A2_CEP                // CEP
         xCOB_CLI :=""                         // Endereco de Cobranca
         xREC_CLI :=""                         // Endereco de Entrega
         xMUN_CLI :=SA2->A2_MUN                // Municipio
         xEST_CLI :=SA2->A2_EST                // Estado
         xCGC_CLI :=SA2->A2_CGC                // CGC
         xINSC_CLI:=SA2->A2_INSCR              // Inscricao estadual
         xTRAN_CLI:=SA2->A2_TRANSP             // Transportadora
         xTEL_CLI :=SA2->A2_TEL                // Telefone
         xFAX     :=SA2->A2_FAX                // Fax

      EndIf

      dbSelectArea("SE1")                   // * Contas a Receber
      dbSetOrder(1)
      xPARC_DUP  :={}                       // Parcela
      xVENC_DUP  :={}                       // Vencimento
      xVALOR_DUP :={}                       // Valor    
      
      xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas

      while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
         AADD(xPARC_DUP ,SE1->E1_PARCELA)
         AADD(xVENC_DUP ,SE1->E1_VENCTO)
         AADD(xVALOR_DUP,SE1->E1_VLCRUZ)
         dbSkip()
      EndDo

      dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
      dbSetOrder(1)
      // dbSeek(xFilial()+SD1->D1_TES)
       dbSeek(xFilial()+xTES[1])
      
      //xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao

      dbSelectArea("SX5")
      DbSetOrder(1)
      dbSeek(xFilial()+"13"+SF4->F4_CF )
      
      xNATUREZA:=SX5->X5_DESCRI           // Natureza da Operacao 
      
      xNOME_TRANSP :=" "           // Nome Transportadora
      xEND_TRANSP  :=" "           // Endereco
      xMUN_TRANSP  :=" "           // Municipio
      xEST_TRANSP  :=" "           // Estado
      xVIA_TRANSP  :=" "           // Via de Transporte
      xCGC_TRANSP  :=" "           // CGC
      xTEL_TRANSP  :=" "           // Fone
      xIE_TRANSP   :=" "           // Inscricao Estadual
      xTPFRETE     :=" "           // Tipo de Frete
      xVOLUME      := 0            // Volume
      xESPECIE     :=" "           // Especie
      xPESO_LIQ    := 0            // Peso Liquido
      xPESO_BRUTO  := 0            // Peso Bruto
      xCOD_MENS    :=" "           // Codigo da Mensagem
      xMENSAGEM    :=" "           // Mensagem da Nota
      xPESO_LIQUID :=" "


	  lImprimiu  := .T. 
      Imprime()

      //+--------------------------------------------------------------+
      //¦ Termino da Impressao da Nota Fiscal                          ¦
      //+--------------------------------------------------------------+

      IncRegua()                    // Termometro de Impressao

      nLin := 0
      dbSelectArea("SF1")           
      dbSkip()                     // e passa para a proxima Nota Fiscal


   EndDo
Endif

//+--------------------------------------------------------------+
//¦                                                              ¦
//¦                      FIM DA IMPRESSAO                        ¦
//¦                                                              ¦
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//¦ Fechamento do Programa da Nota Fiscal                        ¦
//+--------------------------------------------------------------+

If !lImprimiu
	Aviso("Aviso","Não há NF à imprimir para os parãmetros informados.  Favor Verificar os parâmetros.",{"Ok"})
EndIf

dbSelectArea("SF2")
Retindex("SF2")

dbSelectArea("SF1")
Retindex("SF1")

dbSelectArea("SD2")
Retindex("SD2")

dbSelectArea("SD1")
Retindex("SD1")

Set Device To Screen

If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

Return

//+--------------------------------------------------------------+
//¦ Fim do Programa                                              ¦
//+--------------------------------------------------------------+


//+--------------------------------------------------------------+
//¦                                                              ¦
//¦                   FUNCOES ESPECIFICAS                        ¦
//¦                                                              ¦
//+--------------------------------------------------------------+


/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPDET   ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao de Linhas de Detalhe da Nota Fiscal              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function IMPDET()

nLin  := 19//+nDifPg   // Linha de comeco da impressao dos item da nf  

// Tamanho da Area de Detalhe
// ----------------------------------
nTamDet := nTamDet - 3 // 3 linhas p/ a impressao de mensagens que serão vistas mais tarde         

// Base  do ICMS Solidario
// ----------------------------------
xB_ICMS_SOL := 0
      
// Valor do ICMS Solidario
// ----------------------------------
xV_ICMS_SOL := 0      

I := 1
J := 1

nNFImpressas := 1      
nTamItens    := Len(xCod_Pro)

For I := 1 to nTamItens

   If I <= Len(xCOD_PRO)
      @ nLin,  01  PSAY AllTrim(xCOD_PRO[I]) //Picture "9999999"

  	  If mv_par04 == 2 .AND. !Empty(xCOMPLEMENT[I])  	  
       		cDescr := " " + AllTrim(xCOMPLEMENT[I])
  	  Else
      		cDescr := AllTrim(xDESC_PRO[I])
      EndIf		            
      
//      cDescr := AllTrim(xDESC_PRO[I])  
      nTamDescrIni := Len(cDescr)  
      nTamDescr    := nTamDescrIni   
      nTamMax      := iif(cFilAnt == '03',46 ,60)
      nPass        := 0
      
      // Imprime a descricao do Item
      
      While nTamDescr > 0                             
         nIni := (nPass * nTamMax) + 1        
         @ nLin, 20 PSAY AllTrim(Subs(cDescr, nIni, nTamMax ))         
         nTamDescr -= nTamMax
         nPass++
         nLin++      
      End   
      
      nLin--  // Ajusta linha da Nota apos a saida do loop
         
      @ nLin, 142 PSAY xVAL_MERC[I]     Picture "@E 99,999,999.99"
      J := J + 1
   Endif
   
   // Pula uma linha
   nLin := nLin + 1   
Next  
Return NIL

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPRIME  ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Imprime a Nota Fiscal de Entrada e de Saida                ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Generico RDMAKE                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function Imprime()
@ 06, 000 PSAY Chr(15) + CHR(27)+"M"                   // Compressao de Impressao

Cabecalho()
       
ImpDet()
Impostos( .t. )
fObs() 

@ 47, 000 PSAY chr(18)                   // Descompressao de Impressao
@ 51,020 PSAY " "
SetPrc(0,0)                             // (Zera o Formulario)

Return .t.

Static Function Cabecalho()
//@ nLin,021 PSAY "I"
@ 06,105  PSAY xEMISSAO
@ 06,130  PSAY "NF No. : " + xNUM_NF

@ 07, 105 PSAY SUBSTR(xNATUREZA,1,41)            

@ 08, 105 PSAY xCF[1] Picture"@R 9.999"  

@ 11, 020 PSAY substr(xNOME_CLI,1,90)              //Nome do Cliente  

@ 12, 020 PSAY xEND_CLI                           // Endereco
@ 12, 105 PSAY xMUN_CLI                           // Bairro
@ 12, 137 PSAY xEST_CLI                           // U.F. 

@ 13, 020 PSAY xINSC_CLI
@ 13, 090 PSAY xCGC_CLI  Picture "@R 99.999.999/9999-99"

Return NIL


Static Function Impostos( lValores )
If lValores
   @ 37, 010 PSAY xBASE_ICMS  Picture "@E 999,999,999.99"  // Base do ICMS
   @ 37, 063 PSAY xVALOR_ICMS Picture "@E 999,999,999.99"  // Valor do ICMS
   @ 37, 116 PSAY xVALOR_MERC Picture "@E 999,999,999.99"  // Valor Tot. Prod.
Else
   @ 37, 010 PSAY Replicate("*",14)
   @ 37, 063 PSAY Replicate("*",14)
   @ 37, 116 PSAY Replicate("*",14)
EndIf

Return NIL


Static Function fObs()
nLin:=39//+nDifPg
cDescr       := AllTrim(xOBS)
nTamDescrIni := Len(cDescr)
nTamDescr    := nTamDescrIni
nTamMax      := 120
nPass        := 0
      
// Imprime a descricao do Item
// ------------------------------------------------
While nTamDescr > 0                             
   nIni := (nPass * nTamMax) + 1        
   @ nLin, 01 PSAY AllTrim(Subs(cDescr, nIni, nTamMax ))         
   nTamDescr -= nTamMax
   nPass++
   nLin++      
End   
nLin--  // Ajusta linha da Nota apos a saida do loop
@ nLin, PCOL() PSAY " - Ref. GEFCO : " + AllTrim(_cRefGefco)
Return