#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
/***************************************************************************
* Programa.......: MANAD_07()                                              *
* Autor..........: J Ricardo de Oliveira Guimar�es                         *
* Data...........: 03/07/09                                                *
* Descricao......: Rotina para complementar as informa��es do MANAD gerado *
*                  pelo RH, com as informa��es cont�beis, extra�das do     *
*                  sistema Microsiga - 2007 e 2008                         *
****************************************************************************
* Alt. por.......:                                                         *
* Data...........:                                                         *
* Motivo.........:                                                         *
*                                                                          *
***************************************************************************/

*------------------------*
User Function MANAD_08
*------------------------*

*************************************************************************
* Declaracao de Variaveis                                               *
*************************************************************************

Private oLeTxt

Private cString := "CT2"

dbSelectArea("CT2")
dbSetOrder(1)

*************************************************************************
* Montagem da tela de processamento.                                    *
*************************************************************************

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo do arquivo DBF MANAD2008, "
@ 14,018 Say " e acrescenta os registro I ref. contabiliza��o, conforme   "
@ 18,018 Say " manual do MANAD                                            "

@ 30,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 30,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP6 IDE            � Data �  13/01/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkLeTxt
//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������

dbUseArea(.T.,__LocalDriver,"MANAD2008_ORIG","MANAD",.F.,.F.)

If NetErr()  // Verifico se foi bem sucedido a abertura do arquivo
	MsgAlert("O arquivo de nome MANAD2008_ORIG nao pode ser aberto! Poss�vel est� aberto por outro usu�rio.","Atencao!")
	Return
Endif


//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

MSAguarde({|| RunCont() },"Processando...")

//ALERT("INICIO DE COPIA")
//dbUseArea(.T.,__LocalDriver,"MANAD2007","MANAD",.F.,.F.)

dbSelectArea("MANAD")
COPY TO "D:\MANAD_2007_2008\2008\MANAD_2008_2.TXT" SDF
dbCloseArea()
Alert("Arquivo MANAD_2008.TXT copiado.")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  13/01/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont
Local _cQry
Local _cInd_Nat   := ""
Local _cGrp_Cta   := ""

Private _nConta_I := 0

dbSelectArea("MANAD")

MSPROCTXT( "Gerando registros I(Contabiliza��o) do MANAD 2008" )

dbGoTop()
************************************************************************
* Posiciono e apago os registro de contabiliza��o( I )                 *
************************************************************************
Locate FOR Left(LINHA,1) == "I"

// MSPROCTXT( "Excluindo registros inclu�dos em processos anteriores." )

/*
While !Eof() .AND. Left(LINHA,1) == "I"
RecLock("MANAD",.F.)
dbDelete()
MsUnLock()
dbSkip()
End
*/

MSPROCTXT( "Copiando arquivo original - MANAD2008_ORIG." )
COPY TO D:\MANAD_2007_2008\2008\MANAD_2008

dbSelectArea("MANAD") ; dbCloseArea()

dbUseArea(.T.,__LocalDriver,"D:\MANAD_2007_2008\2008\MANAD_2008","MANAD",.F.,.F.)

If NetErr()  // Verifico se foi bem sucedido a abertura do arquivo
	MsgAlert("O arquivo de nome MANAD2008 nao pode ser aberto! Poss�vel est� aberto por outro usu�rio.","Atencao!")
	Return
Endif

MSPROCTXT( "Indexando arquivo - MANAD2008." )
cInd1	:= CriaTrab("",.F.)
IndRegua("MANAD",cInd1,"LEFT(LINHA,4)",,,OemToAnsi("Indexando Registros..."))  //"Selecionando Registros..."
dbSetIndex( cInd1 +OrdBagExt())

************************************************************************
* Insiro os registro de contabiliza��o( I ), extra�do do Microsiga     *
************************************************************************
Locate FOR Left(LINHA,4) == "0990"
dbSkip()

// Registro Tipo I001 - Abertura do Bloco I
RecLock("MANAD",.T.)
MANAD->LINHA := "I001|0"
MsUnLock()
_nConta_I++

// Registro Tipo I005 - Identifica��o da Escritura��o Fiscal
RecLock("MANAD",.T.)
MANAD->LINHA := "I005|G|"
MsUnLock()
_nConta_I++

****************************************************
* Registro Tipo I050 - Plano de Contas             *
****************************************************

MSPROCTXT( "Gerando registros I050(Plano de Contas) do MANAD 2008" )

// Listo o plano de contas referente a Folha
_cQry := " SELECT * FROM CT1010 WHERE D_E_L_E_T_='' "

If Select("I050") > 0
	dbSelectArea("I050") ; dbCloseArea()
EndIf

TCQUERY _cQry ALIAS "I050" NEW

dbSelectArea("I050") ; dbGoTop()
// Gravo os registros
MSPROCTXT( "Gerando registros I050(Plano de Contas) do MANAD 2008" )

_nCntReg := 0

While !Eof()
	
	_cInd_Nat := IIF(LEFT(I050->CT1_CONTA,1)=="1","1",;
	IIF(LEFT(I050->CT1_CONTA,1)=="2","2",;
	IIF(LEFT(I050->CT1_CONTA,1)=="3","3",;
	IIF(LEFT(I050->CT1_CONTA,1)=="7","4",;
	IIF(LEFT(I050->CT1_CONTA,1)=="8","5","" )))))
	
	_cGrp_Cta   := IIF(I050->CT1_CLASSE=="1","S","A")
	
	// Grupo da Conta (NILVEL)
	_cNivel := ""
	If Len(AllTrim(I050->CT1_CONTA)) == 1
		_cNivel := "1"                                                                                                                            
	ElseIf Len(AllTrim(I050->CT1_CONTA)) > 1 .and. Len(AllTrim(I050->CT1_CONTA)) < 3 .and. _cGrp_Cta == "S" //.AND. !(LEFT(I050->CT1_CONTA,1) $ "7|8")
		_cNivel := "2"			
	ElseIf Len(AllTrim(I050->CT1_CONTA)) > 1 .and. Len(AllTrim(I050->CT1_CONTA)) < 4 .and. _cGrp_Cta == "S" //.AND. !(LEFT(I050->CT1_CONTA,1) $ "7|8")
		_cNivel := "3"	
	ElseIf Len(AllTrim(I050->CT1_CONTA)) >= 4 // .and. _cGrp_Cta == "A"
		_cNivel := "4"			
	ElseIf Len(AllTrim(I050->CT1_CONTA)) > 3 .and. _cGrp_Cta == "S" // .and. LEFT(I050->CT1_CONTA,1) $ "7|8"
		_cNivel := "5"		
	EndIF
		
	dbSelectArea("MANAD")
	RecLock("MANAD",.T.)
//	MANAD->LINHA := "I050|01012007|"+_cInd_Nat+"|"+_cGrp_Cta+"|"+IIF(I050->CT1_DC="0","1",I050->CT1_DC)+"|"+AllTrim(I050->CT1_CONTA)+"|"+AllTrim(I050->CT1_CTASUP)+"|"+AllTrim(I050->CT1_DESC01)
	MANAD->LINHA := "I050|01012007|"+_cInd_Nat+"|"+_cGrp_Cta+"|"+_cNivel+"|"+AllTrim(I050->CT1_CONTA)+"|"+AllTrim(I050->CT1_CTASUP)+"|"+AllTrim(I050->CT1_DESC01)	
	MsUnLock()
	_nConta_I++
	_nCntReg++
	
	dbSelectArea("I050")
	dbSkip()
End

dbSelectArea("MANAD")
RecLock("MANAD",.T.)
MANAD->LINHA := "9900|I050|"+AllTrim(Str(_nCntReg))
MsUnLock()

// dbSelectArea("I050") ; dbCloseArea()

****************************************************
* Registro Tipo I100 - Centro de Custo             *
****************************************************

// Listo os Centros de Custos
// Adiantamento de Sal�rios
/*
_cQry := " SELECT DISTINCT CTT_CUSTO FROM CTT010 WHERE CTT_CONTA IN ('113101','113102','113103','811105','811107','711107','711101','811101','713905','711203','811108') AND D_E_L_E_T_='' "
_cQry += " UNION "
// Obriga��es Trabalhista
_cQry += " SELECT DISTINCT CTT_CUSTO FROM CTT010 WHERE CTT_CONTA >= '213201' AND CTT_CONTA >= '213214'  AND D_E_L_E_T_='' "
_cQry += " UNION "
// Provis�es sobre Sal�rios
_cQry += " SELECT DISTINCT CTT_CUSTO FROM CTT010 WHERE CTT_CONTA >= '213301' AND CTT_CONTA >= '213309' AND D_E_L_E_T_='' "
_cQry += " UNION "
// Desp. Pessoal - Salarios/encargos
_cQry += " SELECT DISTINCT CTT_CUSTO FROM CTT010 WHERE CTT_CONTA >= '712101' AND CTT_CONTA >= '712119' AND D_E_L_E_T_='' "
_cQry += " UNION "             
*/
/*
// Desp. Pessoal - Beneficios
_cQry += " SELECT DISTINCT CTT_CUSTO FROM CTT010 WHERE CTT_CONTA >= '712201' AND CTT_CONTA >= '712208' AND D_E_L_E_T_='' "
_cQry += " UNION "
// Desp. Pessoal - Outras
_cQry += " SELECT DISTINCT CTT_CUSTO FROM CTT010 WHERE CTT_CONTA >= '712301' AND CTT_CONTA >= '712307' AND D_E_L_E_T_='' "
_cQry += " UNION "

// Despesas a Distribuir
_cQry += " SELECT  DISTINCT CTT_CUSTO FROM CTT010 WHERE CTT_CONTA >= '712401' AND CTT_CONTA >= '712406' AND D_E_L_E_T_='' "
_cQry += " ORDER BY CTT_CUSTO "
*/

_cQry := " SELECT  DISTINCT CTT_CUSTO FROM CTT010 WHERE D_E_L_E_T_='' "
_cQry += " ORDER BY CTT_CUSTO "

If Select("I1001") > 0
	dbSelectArea("I1001") ; dbCloseArea()
EndIf

TCQUERY _cQry ALIAS "I1001" NEW

_nCntReg := 0

dbSelectArea("I1001") ; dbGoTop()
// Gravo os registros
MSPROCTXT( "Gerando registros I100(Centro de Custos) do MANAD 2004" )
While !Eof()
	
	dbSelectArea("CTT") ; dbSetOrder(1)
	dbSeek(xFilial("CTT")+AllTrim(I1001->CTT_CUSTO))
	
	dbSelectArea("MANAD")
	RecLock("MANAD",.T.)
	MANAD->LINHA := "I100|01012007|"+AllTrim(I1001->CTT_CUSTO)+"|"+AllTrim(CTT->CTT_DESC01)
	MsUnLock()
	_nConta_I++
	_nCntReg++
	
	dbSelectArea("I1001")
	dbSkip()
End

dbSelectArea("MANAD")
RecLock("MANAD",.T.)
MANAD->LINHA := "9900|I100|"+AllTrim(Str(_nCntReg))
MsUnLock()

dbSelectArea("I1001") ; dbCloseArea()

//TEMPOR�RIO
//dbSelectArea("MANAD")
//COPY TO MANAD_2008_TXT.TXT SDF
//RETURN

***********************************************************
* Registro Tipo I200 e I150 - Lan�amentos Cont�bil        *
***********************************************************

/*
CTBGerRaz(oMeter,oText,oDlg,lEnd,@cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
		cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
		aSetOfBook,lNoMov,cSaldo,lJunta,"1",lAnalitico,,,aReturn[7],lSldAnt)},;
		STR0018,;		// "Criando Arquivo Tempor�rio..."
		STR0006)		// "Emissao do Razao"
*/

cArqTmp := "CTBTMP"

// _cQry := " SELECT DISTINCT CTT_CUSTO FROM CTT010 WHERE I3_CONTA IN ('113101','113102','113103') AND D_E_L_E_T_='' "

aSetOfBook := {}
aSetOfBook := CTBSetOf("")

************************************************************

// Gravo os registros I150
MSPROCTXT( "Gerando registros I150(Saldos mensais) do MANAD 2008" )
*-----------------------*
fGerarI150()
*-----------------------*

// Plano de Contas
dbSelectArea("I050") ; dbGoTop()

_nCntReg200 := 0

// Gravo os registros
MSPROCTXT( "Gerando registros I200(Lan�amentos Contabil) do MANAD 2008" )
While !Eof()
	
	// Fecho os arquivo tempor�rio com os lan�amento do Raz�o da conta que foi processada.
	If Select("cArqTmp") > 0
		dbSelectArea("cArqTmp")
		Set Filter To
		dbCloseArea()
		If Select("cArqTmp") == 0
			FErase(cArqTmp+GetDBExtension())
			FErase(cArqTmp+OrdBagExt())
		EndIf		
	EndIf
	*------------------------------------------------------------*
	* Chamo fun��o padr�o para gerar arq. tempor�rio com o Raz�o *
	*------------------------------------------------------------*
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
	CTBGerRazT(oMeter,oText,oDlg,.T.,@cArqTmp,I050->CT1_CONTA,I050->CT1_CONTA,"","9999999999",;
			"","999999999","","999999999","01",CTOD("01/01/08"),CTOD("31/12/08"),;
			aSetOfBook,.F.,"1",.F.,"1",.T.,,,.T.,.T.)},;
			"Criando Arquivo Tempor�rio...",;
			"Emissao do Razao" )
			
	dbSelectArea("cArqTmp")


	// Tratamento para gera��o do registro I150	
	_cAno    := "2008" // RAZ->PERIODO
	
	dbSelectArea("cArqTmp")	 ; dbGoTop()
	While !Eof()
		// Gravo o registro I200 do MANAD
/*
		If Empty(RAZ->VALOR)
			dbSelectArea("RAZ")
			dbSkip()
			Loop
		EndIf
*/		
		_cPar := AllTrim(cArqTmp->XPARTIDA)
		
		If Empty(cArqTmp->LANCDEB) .and. Empty(cArqTmp->LANCCRD)
			dbSelectArea("cArqTmp") 
			dbSkip()		
			Loop
		EndIf

		dbSelectArea("MANAD")
		// Lan�amento a DEBITO
		RecLock("MANAD",.T.)
		MANAD->LINHA := "I200|"+AllTrim(StrTran(Left(DTOC(cArqTmp->DATAL),5),"/","")+StrZero(Year(cArqTmp->DATAL),4)) + "|" + AllTrim(cArqTmp->CONTA)+"|"+;
		AllTrim(cArqTmp->CCUSTO)+"|"+_cPAR+"|" + AllTrim(TRANSFORM(cArqTmp->LANCDEB,"@E 999999999.99"))+"|"+;
		"D"+"|"+AllTrim(cArqTmp->LOTE)+AllTrim(cArqTmp->LINHA)+"|"+AllTrim(cArqTmp->DOC)+"|N|"+AllTrim(cArqTmp->HISTORICO)
		MsUnLock()
		_nConta_I++
		_nCntReg200++
		
		// Lan�amento a CREDITO
		RecLock("MANAD",.T.)
		MANAD->LINHA := "I200|"+AllTrim(StrTran(Left(DTOC(cArqTmp->DATAL),5),"/","")+StrZero(Year(cArqTmp->DATAL),4)) + "|" + AllTrim(cArqTmp->CONTA)+"|"+;
		AllTrim(cArqTmp->CCUSTO)+"|"+_cPAR+"|" + AllTrim(TRANSFORM(cArqTmp->LANCCRD,"@E 999999999.99"))+"|"+;
		"C"+"|"+AllTrim(cArqTmp->LOTE)+AllTrim(cArqTmp->LINHA)+"|"+AllTrim(cArqTmp->DOC)+"|N|"+AllTrim(cArqTmp->HISTORICO)
		MsUnLock()
		_nConta_I++
		_nCntReg200++		
		
		dbSelectArea("cArqTmp") 
		dbSkip()
	End
	
	// Fecho arquivo de tempor�rio com o Raz�o.
	If Select("cArqTmp") > 0
		dbSelectArea("cArqTmp")
		Set Filter To
		dbCloseArea()
		If Select("cArqTmp") == 0
			FErase(cArqTmp+GetDBExtension())
			FErase(cArqTmp+OrdBagExt())
		EndIf		
	EndIf	
	
	dbSelectArea("I050")
	dbSkip()
End

dbSelectArea("MANAD")
RecLock("MANAD",.T.)
MANAD->LINHA := "9900|I200|"+AllTrim(Str(_nCntReg200))
MsUnLock()

// Fecho o tabela de plano de contas
dbSelectArea("I050") ; dbCloseArea()

****************************************************************************
* Registro Tipo I250 - Saldos das contas de resultado antes do encerramento *
****************************************************************************
// Falta implementar

************************************************
* Registro Tipo I990 - Encerramento do bloco I *
************************************************
dbSelectArea("MANAD")
_nConta_I++

RecLock("MANAD",.T.)
MANAD->LINHA := "I990|"+AllTrim(Str(_nConta_I,9))
MsUnLock()

********************************************************
* Registro Tipo 9999 - Encerramento do arquivo Digital *
********************************************************
dbSelectArea("MANAD")
_nConta_I := MANAD->(LASTREC())

Locate FOR Left(LINHA,4) == "9999"

If Found()
	RecLock("MANAD",.F.)
	MANAD->LINHA := "9999|"+AllTrim(Str(_nConta_I,9))
	MsUnLock()
Else
	RecLock("MANAD",.T.)
	MANAD->LINHA := "9999|"+AllTrim(Str(_nConta_I,9))
	MsUnLock()
EndIf

Return

*-----------------------------------------------------*
Static Function fGerarI150()
*-----------------------------------------------------*
Local _nSldAnt   := 0.00
Local _nSldAtu   := 0.00
Local _nTotDeb   := 0.00
Local _nTotCrd   := 0.00
Local _cMes      := ""
Local _cAno      := "2008"
Local _cMesAno   := ''
Local _cTpSldAnt := ""
Local _cTpSldAtu := ""

_nCntReg150 := 0

// Plano de Contas
dbSelectArea("I050") ; dbGoTop()

While !Eof()
	If I050->CT1_CLASSE <> "2"	// 1-Sint�tica ; 2-Anal�tica
		dbSelectArea("I050")
    	dbSkip()
    	Loop
	EndIf

	// SALDOCONTA("113101",CTOD("31/01/08"),"01", "1",1)

	// Inicializo matriz com os 12 per�odos
	For _x := 1 to 12  // 1
		_cMesAno := StrZero(_x,2) + _cAno
		_cMes    := StrZero(_x,2)

		//Pego saldo anterior
		_nSldAnt := SALDOCONTA(AllTrim(I050->CT1_CONTA),CTOD("01/"+_cMes+"/"+_cAno)-1,"01", "1",6)
		_cTpSldAnt := IIF(_nSldAnt < 0, "D","C")
		
		//Pego saldo atual
		_nSldAtu := SALDOCONTA(AllTrim(I050->CT1_CONTA),LASTDATE(CTOD("01/"+_cMes+"/"+_cAno)),"01", "1",1)
		_cTpSldAtu := IIF(_nSldAtu < 0, "D","C")
	
		// Pego os totais dos lan�amentos a Debito e Cr�dito
		_nTotDeb   := MOVCONTA(AllTrim(I050->CT1_CONTA),CTOD("01/"+_cMes+"/"+_cAno),LASTDATE(CTOD("01/"+_cMes+"/"+_cAno)),"01", "1",1)
		_nTotCrd   := MOVCONTA(AllTrim(I050->CT1_CONTA),CTOD("01/"+_cMes+"/"+_cAno),LASTDATE(CTOD("01/"+_cMes+"/"+_cAno)),"01", "1",2)

/*
		// Zerada
		If Empty(_nSldAnt) .and. Empty(_nSldAtu) .and. Empty(_nTotDeb) .and. Empty(_nTotCrd)
			dbSelectArea("I050")
			dbSkip()
			Loop
		EndIf
*/
		// Gravo registros do I150
		dbSelectArea("MANAD")
		RecLock("MANAD",.T.)
			MANAD->LINHA := "I150|"+AllTrim(I050->CT1_CONTA)+"|"+_cMesAno+"|"+;
			AllTrim(TRANSFORM(Abs(_nSldAnt),"@E 999999999.99"))+"|"+_cTpSldAnt+"|"+;
			AllTrim(TRANSFORM(_nTotDeb,"@E 999999999.99"))+"|"+AllTrim(TRANSFORM(_nTotCrd,"@E 999999999.99"))+"|"+;
			AllTrim(TRANSFORM(Abs(_nSldAtu),"@E 999999999.99"))+"|"+_cTpSldAtu
		MsUnLock()
		
		_nConta_I++
		_nCntReg150++
		
		dbSelectArea("I050")
		dbSkip()	
	
	Next _x
End

dbSelectArea("MANAD")
RecLock("MANAD",.T.)
MANAD->LINHA := "9900|I150|"+AllTrim(Str(_nCntReg150))
MsUnLock()

Return

//**************************************************************************************************************

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    �CtbGerRaz � Autor � Pilar S. Albaladejo   � Data � 05/02/01 ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o �Cria Arquivo Temporario para imprimir o Razao               ���
��������������������������������������������������������������������������Ĵ��
��� Sintaxe   �CtbGerRaz(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,cContaFim���
���			  �cCustoIni,cCustoFim,cItemIni,cItemFim,cCLVLIni,cCLVLFim,    ���
���			  �cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,   ���
���			  �cTipo,lAnalit)                                              ���
��������������������������������������������������������������������������Ĵ��
���Retorno    �Nome do arquivo temporario                                  ���
��������������������������������������������������������������������������Ĵ��
��� Uso       � SIGACTB                                                    ���
��������������������������������������������������������������������������Ĵ��
���Parametros � ExpO1 = Objeto oMeter                                      ���
���           � ExpO2 = Objeto oText                                       ���
���           � ExpO3 = Objeto oDlg                                        ���
���           � ExpL1 = Acao do Codeblock                                  ���
���           � ExpC1 = Arquivo temporario                                 ���
���           � ExpC2 = Conta Inicial                                      ���
���           � ExpC3 = Conta Final                                        ���
���           � ExpC4 = C.Custo Inicial                                    ���
���           � ExpC5 = C.Custo Final                                      ���
���           � ExpC6 = Item Inicial                                       ���
���           � ExpC7 = Cl.Valor Inicial                                   ���
���           � ExpC8 = Cl.Valor Final                                     ���
���           � ExpC9 = Moeda                                              ���
���           � ExpD1 = Data Inicial                                       ���
���           � ExpD2 = Data Final                                         ���
���           � ExpA1 = Matriz aSetOfBook                                  ���
���           � ExpL2 = Indica se imprime movimento zerado ou nao.         ���
���           � ExpC10= Tipo de Saldo                                      ���
���           � ExpL3 = Indica se junta CC ou nao.                         ���
���           � ExpC11= Tipo do lancamento                                 ���
���           � ExpL4 = Indica se imprime analitico ou sintetico           ���
���           � c2Moeda = Indica moeda 2 a ser incluida no relatorio       ���
���           � cUFilter= Conteudo Txt com o Filtro de Usuario (CT2)       ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function CtbGerRazT(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
						cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
						aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,lAnalit,c2Moeda,;
						nTipo,cUFilter ,lSldAnt)

Local aTamConta	:= TAMSX3("CT1_CONTA")
Local aTamCusto	:= TAMSX3("CT3_CUSTO")
Local aCtbMoeda	:= {}
Local aSaveArea := GetArea()                       
Local aCampos

Local cChave

Local nTamHist	:= Len(CriaVar("CT2_HIST"))
Local nTamItem	:= Len(CriaVar("CTD_ITEM"))
Local nTamCLVL	:= Len(CriaVar("CTH_CLVL"))
Local nDecimais	:= 0    
Local cMensagem		:= "O plano gerencial nao esta disponivel nesse relatorio."

DEFAULT c2Moeda := ""
DEFAULT nTipo	:= 1
DEFAULT cUFilter:= ""
DEFAULT lSldAnt		:= .F.
#IFDEF TOP
	If TcSrvType() != "AS/400" .And. cTipo == "1" .And. FunName() == 'CTBR400' .And. TCGetDb() $ "MSSQL7/MSSQL/MYSQL"		
		DEFAULT cUFilter	:= ".T."		
    Else
#ENDIF
	DEFAULT cUFilter	:= ""			    	
#IFDEF TOP
	Endif
#ENDIF
// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := aCtbMoeda[5]
                
aCampos :={	{ "CONTA"		, "C", aTamConta[1], 0 },;  		// Codigo da Conta
			{ "XPARTIDA"   	, "C", aTamConta[1] , 0 },;		// Contra Partida
			{ "TIPO"       	, "C", 01			, 0 },;			// Tipo do Registro (Debito/Credito/Continuacao)
			{ "LANCDEB"		, "N", 17			, nDecimais },; // Debito
			{ "LANCCRD"		, "N", 17			, nDecimais },; // Credito
			{ "SALDOSCR"	, "N", 17, nDecimais },; 			// Saldo
			{ "TPSLDANT"	, "C", 01, 0 },; 					// Sinal do Saldo Anterior => Consulta Razao
			{ "TPSLDATU"	, "C", 01, 0 },; 					// Sinal do Saldo Atual => Consulta Razao			
			{ "HISTORICO"	, "C", nTamHist   	, 0 },;			// Historico
			{ "CCUSTO"		, "C", aTamCusto[1], 0 },;			// Centro de Custo
			{ "ITEM"		, "C", nTamItem		, 0 },;			// Item Contabil
			{ "CLVL"		, "C", nTamCLVL		, 0 },;			// Classe de Valor
			{ "DATAL"		, "D", 10			, 0 },;			// Data do Lancamento
			{ "LOTE" 		, "C", 06			, 0 },;			// Lote
			{ "SUBLOTE" 	, "C", 03			, 0 },;			// Sub-Lote
			{ "DOC" 		, "C", 06			, 0 },;			// Documento
			{ "LINHA"		, "C", 03			, 0 },;			// Linha
			{ "SEQLAN"		, "C", 03			, 0 },;			// Sequencia do Lancamento
			{ "SEQHIST"		, "C", 03			, 0 },;			// Seq do Historico
			{ "EMPORI"		, "C", 02			, 0 },;			// Empresa Original
			{ "FILORI"		, "C", 02			, 0 },;			// Filial Original
			{ "NOMOV"		, "L", 01			, 0 }}			// Conta Sem Movimento

If cPaisLoc = "CHI"
	Aadd(aCampos,{"SEGOFI","C",TamSx3("CT2_SEGOFI")[1],0})
EndIf
If ! Empty(c2Moeda)
	Aadd(aCampos, { "LANCDEB_1"	, "N", 17, nDecimais }) // Debito
	Aadd(aCampos, { "LANCCRD_1"	, "N", 17, nDecimais }) // Credito
	Aadd(aCampos, { "TXDEBITO"	, "N", 10, 6 }) // Taxa Debito
	Aadd(aCampos, { "TXCREDITO"	, "N",  10, 6 }) // Taxa Credito
Endif
																	
cArqTmp := CriaTrab(aCampos, .T.)
If ( Select ( "cArqTmp" ) <> 0 )
	dbSelectArea ( "cArqTmp" )
	dbCloseArea ()
Endif


dbUseArea( .T.,, cArqTmp, "cArqTmp", .F., .F. )

//��������������������������������������������������������������Ŀ
//� Cria Indice Temporario do Arquivo de Trabalho 1.             �
//����������������������������������������������������������������
If cTipo == "1"			// Razao por Conta
    If FunName() <> "CTBC400"
		cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
	Else
		cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"
	EndIf
ElseIf cTipo == "2"		// Razao por Centro de Custo                   
	If lAnalit 				// Se o relatorio for analitico
		If FunName() <> "CTBC440"
			cChave 	:= "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		Else
			cChave 	:= "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"		
		EndIf
	Else                                                                  
		cChave 	:= "CCUSTO+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
	Endif
ElseIf cTipo == "3" 		//Razao por Item Contabil      
	If lAnalit 				// Se o relatorio for analitico               
		If FunName() <> "CTBC480"
			cChave 	:= "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		Else
			cChave 	:= "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"		
		Endif
	Else                                                                  
		cChave 	:= "ITEM+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
	Endif
ElseIf cTipo == "4"		//Razao por Classe de Valor	
	If lAnalit 				// Se o relatorio for analitico               
		If FunName() <> "CTBC490"	
			cChave 	:= "CLVL+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		Else
			cChave 	:= "CLVL+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"
		EndIf
	Else                                                                  
		cChave 	:= "CLVL+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
	Endif	
EndIf

IndRegua("cArqTmp",cArqTmp,cChave,,,"Selecionando Registros...")  
dbSelectArea("cArqTmp")
dbSetIndex(cArqTmp+OrdBagExt())
dbSetOrder(1)
                                                                                        
If !Empty(aSetOfBook[5])
	MsgAlert(cMensagem)	
	Return
EndIf                   

CT2->(dbGotop())
#IFDEF TOP
//	If TcSrvType() != "AS/400" .And. cTipo == "1" .And. FunName() == 'CTBR400' .And. TCGetDb() $ "MSSQL7/MSSQL/MYSQL"		
	If TcSrvType() != "AS/400" .And. cTipo == "1" .And. TCGetDb() $ "MSSQL7/MSSQL/MYSQL"			
//		ALERT("FOI")
		CtbQryRazT(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
				cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
				aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,cUFilter,lSldAnt)	
	Else
#ENDIF
	// Monta Arquivo para gerar o Razao
	CtbRazao(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
			cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
			aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,nTipo,cUFilter,lSldAnt)
#IFDEF TOP
	EndIf
#ENDIF	



RestArea(aSaveArea)

Return cArqTmp


/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    �CtbQryRaz � Autor � Simone Mie Sato       � Data � 22/01/04 ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o �Realiza a "filtragem" dos registros do Razao                ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe    �CtbQryRaz(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,	   ���
���			  �	cCustoIni,cCustoFim, cItemIni,cItemFim,cCLVLIni,cCLVLFim,  ���
���			  �	cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,  ���
���			  �	cTipo)                                                     ���
��������������������������������������������������������������������������Ĵ��
���Retorno    �Nenhum                                                      ���
��������������������������������������������������������������������������Ĵ��
��� Uso       � SIGACTB                                                    ���
��������������������������������������������������������������������������Ĵ��
���Parametros � ExpO1 = Objeto oMeter                                      ���
���           � ExpO2 = Objeto oText                                       ���
���           � ExpO3 = Objeto oDlg                                        ���
���           � ExpL1 = Acao do Codeblock                                  ���
���           � ExpC2 = Conta Inicial                                      ���
���           � ExpC3 = Conta Final                                        ���
���           � ExpC4 = C.Custo Inicial                                    ���
���           � ExpC5 = C.Custo Final                                      ���
���           � ExpC6 = Item Inicial                                       ���
���           � ExpC7 = Cl.Valor Inicial                                   ���
���           � ExpC8 = Cl.Valor Final                                     ���
���           � ExpC9 = Moeda                                              ���
���           � ExpD1 = Data Inicial                                       ���
���           � ExpD2 = Data Final                                         ���
���           � ExpA1 = Matriz aSetOfBook                                  ���
���           � ExpL2 = Indica se imprime movimento zerado ou nao.         ���
���           � ExpC10= Tipo de Saldo                                      ���
���           � ExpL3 = Indica se junta CC ou nao.                         ���
���           � ExpC11= Tipo do lancamento                                 ���
���           � c2Moeda = Indica moeda 2 a ser incluida no relatorio       ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function CtbQryRazT(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
				  cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
				  aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,cUFilter,lSldAnt)

Local aSaveArea := GetArea()
Local nMeter	:= 0
Local cQuery	:= ""
Local aTamVlr	:= TAMSX3("CT2_VALOR")     
Local lNoMovim	:= .F.
Local cContaAnt	:= ""
Local cCampUSU	:= ""
local aStrSTRU	:= {}
Local nStr		:= 0

DEFAULT lSldAnt := .F.

oMeter:SetTotal(CT2->(RecCount()))
oMeter:Set(0)

cQuery	:= " SELECT CT1_CONTA CONTA, ISNULL(CT2_CCD,'') CUSTO,ISNULL(CT2_ITEMD,'') ITEM, ISNULL(CT2_CLVLDB,'') CLVL, ISNULL(CT2_DATA,'') DDATA, ISNULL(CT2_TPSALD,'') TPSALD, "	
cQuery	+= " ISNULL(CT2_DC,'') DC, ISNULL(CT2_LOTE,'') LOTE, ISNULL(CT2_SBLOTE,'') SUBLOTE, ISNULL(CT2_DOC,'') DOC, ISNULL(CT2_LINHA,'') LINHA, ISNULL(CT2_CREDIT,'') XPARTIDA, ISNULL(CT2_HIST,'') HIST, ISNULL(CT2_SEQHIS,'') SEQHIS, ISNULL(CT2_SEQLAN,'') SEQLAN, '1' TIPOLAN, "	
////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USU�RIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USU�RIO
If !Empty(cUFilter)									//// SE O FILTRO DE USU�RIO NAO ESTIVER VAZIO
	aStrSTRU := CT2->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////
cQuery  += " ISNULL(CT2_VALOR,0) VALOR, ISNULL(CT2_EMPORI,'') EMPORI, ISNULL(CT2_FILORI,'') FILORI"       
If cPaisLoc == "CHI"
	cQuery	+= ", ISNULL(CT2_SEGOFI,'') SEGOFI"
EndIf
cQuery	+= " FROM "+ RetSqlName("CT1") + " CT1 LEFT JOIN " + RetSqlName("CT2") + " CT2 "
cQuery	+= " ON CT2.CT2_FILIAL = '"+xFilial("CT2")+"' "
cQuery	+= " AND CT2.CT2_DEBITO = CT1.CT1_CONTA"  
cQuery  += " AND CT2.CT2_DATA >= '"+DTOS(dDataIni)+ "' AND CT2.CT2_DATA <= '"+DTOS(dDataFim)+"'"
cQuery	+= " AND CT2.CT2_CCD >= '" + cCustoIni + "' AND CT2.CT2_CCD <= '" + cCustoFim +"'"
cQuery  += " AND CT2.CT2_ITEMD >= '" + cItemIni + "' AND CT2.CT2_ITEMD <= '"+ cItemFim +"'"
cQuery  += " AND CT2.CT2_CLVLDB >= '" + cClvlIni + "' AND CT2.CT2_CLVLDB <= '" + cClVlFim +"'"
cQuery  += " AND CT2.CT2_TPSALD = '"+ cSaldo + "'"
cQuery	+= " AND CT2.CT2_MOEDLC = '" + cMoeda +"'"
cQuery  += " AND (CT2.CT2_DC = '1' OR CT2.CT2_DC = '3') "
cQuery	+= " AND CT2.D_E_L_E_T_ = ' ' "	
cQuery	+= " WHERE CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery	+= " AND CT1.CT1_CLASSE = '2' "
cQuery	+= " AND CT1.CT1_CONTA >= '"+ cContaIni+"' AND CT1.CT1_CONTA <= '"+cContaFim+"'"
cQuery	+= " AND CT1.D_E_L_E_T_ = '' "
cQuery	+= " UNION "
cQuery	+= " SELECT CT1_CONTA CONTA, ISNULL(CT2_CCC,'') CUSTO, ISNULL(CT2_ITEMC,'') ITEM, ISNULL(CT2_CLVLCR,'') CLVL, ISNULL(CT2_DATA,'') DDATA, ISNULL(CT2_TPSALD,'') TPSALD, "	
cQuery	+= " ISNULL(CT2_DC,'') DC, ISNULL(CT2_LOTE,'') LOTE, ISNULL(CT2_SBLOTE,'')SUBLOTE, ISNULL(CT2_DOC,'') DOC, ISNULL(CT2_LINHA,'') LINHA, ISNULL(CT2_DEBITO,'') XPARTIDA, ISNULL(CT2_HIST,'') HIST, ISNULL(CT2_SEQHIS,'') SEQHIS, ISNULL(CT2_SEQLAN,'') SEQLAN, '2' TIPOLAN, "	
////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USU�RIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USU�RIO
If !Empty(cUFilter)									//// SE O FILTRO DE USU�RIO NAO ESTIVER VAZIO
	aStrSTRU := CT2->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////

cQuery  += " ISNULL(CT2_VALOR,0) VALOR, ISNULL(CT2_EMPORI,'') EMPORI, ISNULL(CT2_FILORI,'') FILORI"              
If cPaisLoc == "CHI"
	cQuery	+= ", ISNULL(CT2_SEGOFI,'') SEGOFI"
EndIf
cQuery	+= " FROM "+RetSqlName("CT1")+ ' CT1 LEFT JOIN '+ RetSqlName("CT2") + ' CT2 '
cQuery	+= " ON CT2.CT2_FILIAL = '"+xFilial("CT2")+"' "
cQuery	+= " AND CT2.CT2_CREDIT =  CT1.CT1_CONTA "
cQuery  += " AND CT2.CT2_DATA >= '"+DTOS(dDataIni)+ "' AND CT2.CT2_DATA <= '"+DTOS(dDataFim)+"'"
cQuery	+= " AND CT2.CT2_CCC >= '" + cCustoIni + "' AND CT2.CT2_CCC <= '" + cCustoFim +"'"
cQuery  += " AND CT2.CT2_ITEMC >= '" + cItemIni + "' AND CT2.CT2_ITEMC <= '"+ cItemFim +"'"
cQuery  += " AND CT2.CT2_CLVLCR >= '" + cClvlIni + "' AND CT2.CT2_CLVLCR <= '" + cClVlFim +"'"
cQuery  += " AND CT2.CT2_TPSALD = '"+ cSaldo + "'"
cQuery	+= " AND CT2.CT2_MOEDLC = '" + cMoeda +"'"
cQuery  += " AND (CT2.CT2_DC = '2' OR CT2.CT2_DC = '3') "
cQuery	+= " AND CT2.D_E_L_E_T_ = ' ' "	
cQuery	+= " WHERE CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery	+= " AND CT1.CT1_CLASSE = '2' "
cQuery	+= " AND CT1.CT1_CONTA >= '"+ cContaIni+"' AND CT1.CT1_CONTA <= '"+cContaFim+"'"
cQuery	+= " AND CT1.D_E_L_E_T_ = ''"	            
cQuery := ChangeQuery(cQuery)		   
If Select("cArqCT2") > 0
	dbSelectArea("cArqCT2")
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cArqCT2",.T.,.F.)
TcSetField("cArqCT2","CT2_VLR"+cMoeda,"N",aTamVlr[1],aTamVlr[2])
TcSetField("cArqCT2","DDATA","D",8,0)
 			
dbSelectarea("cArqCT2")

dbSelectarea("cArqCT2")
If Empty(cUFilter)
	cUFilter := ".T."
Endif						

While !Eof()                                              
	If Empty(cArqCT2->DDATA) //Se nao existe movimento 
		cContaAnt	:= cArqCT2->CONTA	
		dbSkip()
		If Empty(cArqCT2->DDATA) .And. cContaAnt == cArqCT2->CONTA
			lNoMovim	:= .T.
		EndIf
	Endif        
	
//	If &("cArqCT2->("+cUFilter+")")						
		If lNoMovim		
			If lNoMov  
				If CtbExDtFim("CT1")							
					dbSelectArea("CT1")
					dbSetOrder(1) 
					If MsSeek(xFilial()+cArqCT2->CONTA)
						If CtbVlDtFim("CT1",dDataIni) 
							CtbGrvNoMov(cArqCT2->CONTA,dDataIni,"CONTA")	//Esta sendo passado "CONTA" fixo, porque essa funcao esta sendo 									
						EndIf												//chamada somente para o CTBR400
					EndIf				
				Else
					CtbGrvNoMov(cArqCT2->CONTA,dDataIni,"CONTA")	//Esta sendo passado "CONTA" fixo, porque essa funcao esta sendo 				
				EndIf												//chamada somente para o CTBR400
			ElseIf lSldAnt 
				If SaldoCT7(cArqCT2->CONTA,dDataIni,cMoeda,cSaldo,'CTBR400')[6] <> 0 .and. cArqTMP->CONTA <> cArqCT2->CONTA																							
					CtbGrvNoMov(cArqCT2->CONTA,dDataIni,"CONTA")	
				Endif			
			EndIf
		Else
			RecLock("cArqTmp",.T.)		    	
		    Replace DATAL		With cArqCT2->DDATA
			Replace TIPO		With cArqCT2->DC
			Replace LOTE		With cArqCT2->LOTE
			Replace SUBLOTE		With cArqCT2->SUBLOTE
			Replace DOC			With cArqCT2->DOC
			Replace LINHA		With cArqCT2->LINHA
			Replace CONTA		With cArqCT2->CONTA			
			Replace CCUSTO		With cArqCT2->CUSTO
			Replace ITEM		With cArqCT2->ITEM
			Replace CLVL		With cArqCT2->CLVL
			If cArqCT2->DC == "3"
				Replace XPARTIDA	With cArqCT2->XPARTIDA
			EndIf		
			Replace HISTORICO	With cArqCT2->HIST
			Replace EMPORI		With cArqCT2->EMPORI
			Replace FILORI		With cArqCT2->FILORI
			Replace SEQHIST		With cArqCT2->SEQHIS
			Replace SEQLAN		With cArqCT2->SEQLAN

			If cPaisLoc == "CHI"
				Replace SEGOFI With cArqCT2->SEGOFI// Correlativo para Chile
			EndIf
	
			If cArqCT2->TIPOLAN = '1'
				Replace LANCDEB	With LANCDEB + cArqCT2->VALOR
			EndIf
			If cArqCT2->TIPOLAN = '2'
				Replace LANCCRD	With LANCCRD + cArqCT2->VALOR
			EndIf	
			MsUnlock()
		Endif         
//	EndIf
	lNoMovim	:= .F.	
	dbSelectArea("cArqCT2")	
	dbSkip()
	nMeter++
	oMeter:Set(nMeter)		
Enddo	

RestArea(aSaveArea)

Return
