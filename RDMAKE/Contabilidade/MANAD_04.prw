#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
/***************************************************************************
* Programa.......: MANAD_04()                                              *
* Autor..........: J Ricardo de Oliveira Guimarães                         *
* Data...........: 13/01/09                                                *
* Descricao......: Rotina para complementar as informações do MANAD gerado *
*                  pelo RH, com as informações contábeis, extraídas do     *
*                  sistema Microsiga - 2004                                *
****************************************************************************
* Alt. por.......:                                                         *
* Data...........:                                                         *
* Motivo.........:                                                         *
*                                                                          *
***************************************************************************/

*------------------------*
User Function MANAD_04
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
@ 10,018 Say " Este programa ira ler o conteudo do arquivo DBF MANAD2004, "
@ 14,018 Say " e acrescenta os registro I ref. contabilização, conforme   "
@ 18,018 Say " manual do MANAD                                            "

@ 30,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 30,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKLETXT  º Autor ³ AP6 IDE            º Data ³  13/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a leitura do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkLeTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbUseArea(.T.,__LocalDriver,"MANAD2004_ORIG","MANAD",.F.,.F.)

If NetErr()  // Verifico se foi bem sucedido a abertura do arquivo
	MsgAlert("O arquivo de nome MANAD2004_ORIG nao pode ser aberto! Possível está aberto por outro usuário.","Atencao!")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MSAguarde({|| RunCont() },"Processando...")

dbSelectArea("MANAD")
COPY TO "MANAD_2004_TXT.TXT" SDF
dbCloseArea()
Alert("Arquivo MANAD_2004_TXT.TXT copiado.")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  13/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont
Local _cQry
Local _cInd_Nat   := ""

Private _nConta_I := 0

dbSelectArea("MANAD")

MSPROCTXT( "Gerando registros I(Contabilização) do MANAD 2004" )

dbGoTop()
************************************************************************
* Posiciono e apago os registro de contabilização( I )                 *
************************************************************************
Locate FOR Left(LINHA,1) == "I"

// MSPROCTXT( "Excluindo registros incluídos em processos anteriores." )

/*
While !Eof() .AND. Left(LINHA,1) == "I"
RecLock("MANAD",.F.)
dbDelete()
MsUnLock()
dbSkip()
End
*/

MSPROCTXT( "Copiando arquivo original - MANAD2004_ORIG." )
COPY TO MANAD2004

dbSelectArea("MANAD") ; dbCloseArea()

dbUseArea(.T.,__LocalDriver,"MANAD2004","MANAD",.F.,.F.)

If NetErr()  // Verifico se foi bem sucedido a abertura do arquivo
	MsgAlert("O arquivo de nome MANAD2004 nao pode ser aberto! Possível está aberto por outro usuário.","Atencao!")
	Return
Endif

MSPROCTXT( "Indexando arquivo - MANAD2004." )
cInd1	:= CriaTrab("",.F.)
IndRegua("MANAD",cInd1,"LEFT(LINHA,4)",,,OemToAnsi("Indexando Registros..."))  //"Selecionando Registros..."
dbSetIndex( cInd1 +OrdBagExt())

************************************************************************
* Insiro os registro de contabilização( I ), extraído do Microsiga     *
************************************************************************
Locate FOR Left(LINHA,4) == "0990"
dbSkip()

// Registro Tipo I001 - Abertura do Bloco I
RecLock("MANAD",.T.)
MANAD->LINHA := "I001|0"
MsUnLock()
_nConta_I++

// Registro Tipo I005 - Identificação da Escrituração Fiscal
RecLock("MANAD",.T.)
MANAD->LINHA := "I005|G|"
MsUnLock()
_nConta_I++

****************************************************
* Registro Tipo I050 - Plano de Contas             *
****************************************************

MSPROCTXT( "Gerando registros I050(Plano de Contas) do MANAD 2004" )

// Listo o plano de contas referente a Folha
_cQry := " SELECT * FROM SI1010 WHERE D_E_L_E_T_='' "

/*
// Adiantamento de Salários
_cQry := " SELECT * FROM SI1010 WHERE I1_CODIGO IN ('113101','113102','113103') AND D_E_L_E_T_='' "
_cQry += " UNION "
// Obrigações Trabalhista
_cQry += " SELECT * FROM SI1010 WHERE I1_CODIGO >= '213201' AND I1_CODIGO >= '213214'  AND D_E_L_E_T_='' "
_cQry += " UNION "
// Provisões sobre Salários
_cQry += " SELECT * FROM SI1010 WHERE I1_CODIGO >= '213301' AND I1_CODIGO >= '213309' AND D_E_L_E_T_='' "
_cQry += " UNION "
// Desp. Pessoal - Salarios/encargos
_cQry += " SELECT * FROM SI1010 WHERE I1_CODIGO >= '712101' AND I1_CODIGO >= '712119' AND D_E_L_E_T_='' "
_cQry += " UNION "
// Desp. Pessoal - Beneficios
_cQry += " SELECT * FROM SI1010 WHERE I1_CODIGO >= '712201' AND I1_CODIGO >= '712208' AND D_E_L_E_T_='' "
_cQry += " UNION "
// Desp. Pessoal - Outras
_cQry += " SELECT * FROM SI1010 WHERE I1_CODIGO >= '712301' AND I1_CODIGO >= '712307' AND D_E_L_E_T_='' "
_cQry += " UNION "
// Despesas a Distribuir
_cQry += " SELECT * FROM SI1010 WHERE I1_CODIGO >= '712401' AND I1_CODIGO >= '712406' AND D_E_L_E_T_='' "
_cQry += " ORDER BY I1_CODIGO "
*/

If Select("I050") > 0
	dbSelectArea("I050") ; dbCloseArea()
EndIf

TCQUERY _cQry ALIAS "I050" NEW

dbSelectArea("I050") ; dbGoTop()
// Gravo os registros
MSPROCTXT( "Gerando registros I050(Plano de Contas) do MANAD 2004" )

_nCntReg := 0

While !Eof()
	
	_cInd_Nat := IIF(LEFT(I050->I1_CODIGO,1)=="1","1",;
	IIF(LEFT(I050->I1_CODIGO,1)=="2","2",;
	IIF(LEFT(I050->I1_CODIGO,1)=="3","3",;
	IIF(LEFT(I050->I1_CODIGO,1)=="7","4",;
	IIF(LEFT(I050->I1_CODIGO,1)=="8","5","" )))))
	
	dbSelectArea("MANAD")
	RecLock("MANAD",.T.)
	MANAD->LINHA := "I050|01012004|"+_cInd_Nat+"|"+I050->I1_CLASSE+"|"+I050->I1_NIVEL+"|"+AllTrim(I050->I1_CODIGO)+"|"+AllTrim(I050->I1_CTASUP)+"|"+AllTrim(I050->I1_DESC)
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
// Adiantamento de Salários
_cQry := " SELECT DISTINCT I3_CUSTO FROM SI3010 WHERE I3_CONTA IN ('113101','113102','113103') AND D_E_L_E_T_='' "
_cQry += " UNION "
// Obrigações Trabalhista
_cQry += " SELECT DISTINCT I3_CUSTO FROM SI3010 WHERE I3_CONTA >= '213201' AND I3_CONTA >= '213214'  AND D_E_L_E_T_='' "
_cQry += " UNION "
// Provisões sobre Salários
_cQry += " SELECT DISTINCT I3_CUSTO FROM SI3010 WHERE I3_CONTA >= '213301' AND I3_CONTA >= '213309' AND D_E_L_E_T_='' "
_cQry += " UNION "
// Desp. Pessoal - Salarios/encargos
_cQry += " SELECT DISTINCT I3_CUSTO FROM SI3010 WHERE I3_CONTA >= '712101' AND I3_CONTA >= '712119' AND D_E_L_E_T_='' "
_cQry += " UNION "
// Desp. Pessoal - Beneficios
_cQry += " SELECT DISTINCT I3_CUSTO FROM SI3010 WHERE I3_CONTA >= '712201' AND I3_CONTA >= '712208' AND D_E_L_E_T_='' "
_cQry += " UNION "
// Desp. Pessoal - Outras
_cQry += " SELECT DISTINCT I3_CUSTO FROM SI3010 WHERE I3_CONTA >= '712301' AND I3_CONTA >= '712307' AND D_E_L_E_T_='' "
_cQry += " UNION "
// Despesas a Distribuir
_cQry += " SELECT  DISTINCT I3_CUSTO FROM SI3010 WHERE I3_CONTA >= '712401' AND I3_CONTA >= '712406' AND D_E_L_E_T_='' "
_cQry += " ORDER BY I3_CUSTO "

If Select("I100") > 0
	dbSelectArea("I100") ; dbCloseArea()
EndIf

TCQUERY _cQry ALIAS "I100" NEW

_nCntReg := 0

dbSelectArea("I100") ; dbGoTop()
// Gravo os registros
MSPROCTXT( "Gerando registros I100(Centro de Custos) do MANAD 2004" )
While !Eof()
	
	dbSelectArea("SI3") ; dbSetOrder(1)
	dbSeek(xFilial("SI3")+AllTrim(I100->I3_CUSTO))
	
	dbSelectArea("MANAD")
	RecLock("MANAD",.T.)
	MANAD->LINHA := "I100|01012004|"+AllTrim(I100->I3_CUSTO)+"|"+AllTrim(SI3->I3_DESC)
	MsUnLock()
	_nConta_I++
	_nCntReg++
	
	dbSelectArea("I100")
	dbSkip()
End

dbSelectArea("MANAD")
RecLock("MANAD",.T.)
MANAD->LINHA := "9900|I100|"+AllTrim(Str(_nCntReg))
MsUnLock()

dbSelectArea("I100") ; dbCloseArea()

/*
Passou-se a ser processado junto com o processo do registro I200
****************************************************
* Registro Tipo I150 - Saldos Mensais              *
****************************************************
// Listos os saldos mensais das contas
// Listo o plano de contas referente a Folha

// Plano de Contas
dbSelectArea("I050") ; dbGoTop()

// Gravo os registros
MSPROCTXT( "Gerando registros I150(Saldos mensais) do MANAD 2004" )
While !Eof()
	
	*------------------*
	fGerarI150()
	*------------------*
	dbSelectArea("I050")
	dbSkip()
End

// dbSelectArea("I050") ; dbCloseArea()
*/

***********************************************************
* Registro Tipo I200 e I150 - Lançamentos Contábil        *
***********************************************************

Private _aSaldos := Array(12,08)

// Listos os lançamentos Contábeis

// Plano de Contas
dbSelectArea("I050") ; dbGoTop()

_nCntReg150 := 0
_nCntReg200 := 0

// Gravo os registros
MSPROCTXT( "Gerando registros I150/I200(Saldos mensais) do MANAD 2004" )
While !Eof()
	
	*------------------------------------------------------------*
	* Chamo função padrão para gerar arq. temporário com o Razão *
	*------------------------------------------------------------*
	U_CONR060G(I050->I1_CODIGO,I050->I1_CODIGO,"D")
	dbUseArea(.T.,__LocalDriver,"MOV_2004","RAZ",.F.,.F.)

	// Tratamento para geração do registro I150	
	_cAno    := "2004" // RAZ->PERIODO
	
	// Inicializo matriz com os 12 períodos
	For _x := 1 to 12
		_aSaldos[_x,1] := AllTrim(I050->I1_CODIGO)  // Conta
		_aSaldos[_x,2] := StrZero(_x,2) + _cAno     // Mês e Ano a que se referem o saldos Inicial e Final
		_aSaldos[_x,3] := 0.00                      // Valor do Saldo Inicial
		_aSaldos[_x,4] := ""                        // Indicador do Saldo Inical (Devedor/Credor)
		_aSaldos[_x,5] := 0.00                      // Valor total dos débitos no mês
		_aSaldos[_x,6] := 0.00                      // Valor total dos crédidos no mês	
		_aSaldos[_x,7] := 0.00                      // Saldo Final
		_aSaldos[_x,8] := ""                        // Indicador do Saldo final (Devedor/Credor)
	Next _x
	
	dbSelectArea("RAZ")	; dbGoTop()
	While !Eof()
		// Gravo o registro I200 do MANAD

		If Empty(RAZ->VALOR)
			dbSelectArea("RAZ")
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("MANAD")
		RecLock("MANAD",.T.)
		MANAD->LINHA := "I200|"+AllTrim(StrTran(Left(DTOC(RAZ->DATAX),5),"/","")+StrZero(Year(RAZ->DATAX),4)) + "|" + AllTrim(RAZ->CONTA)+"|"+;
		AllTrim(RAZ->CCUSTO)+"|"+AllTrim(RAZ->CPAR)+"|" + AllTrim(TRANSFORM(RAZ->VALOR,"@E 999999999.99"))+"|"+;
		RAZ->DC+"|"+AllTrim(RAZ->NUMERO)+AllTrim(RAZ->LINHA)+"|"+AllTrim(RAZ->NUMERO)+"|N|"+AllTrim(RAZ->HISTOR)
		MsUnLock()
		_nConta_I++
		_nCntReg200++

		// Tratamento para geração do registro I150
		If I050->I1_CLASSE == "A"
			// Posiciona no período na Matriz
			_cPeriodo := SubStr(RAZ->PERIODO,5,2)+SubStr(RAZ->PERIODO,1,4) // Mes/Ano
			_nPosPer  := aScan(_aSaldos,{|x| alltrim(x[2]) == _cPeriodo })
			
			If _nPosPer > 0
				_aSaldos[_nPosPer,1] := AllTrim(RAZ->CONTA)  // Conta
				// _aSaldos[_nPosPer,2] := StrZero(_x,2) + _cAno     // Mês e Ano a que se referem o saldos Inicial e Final
				// _aSaldos[_nPosPer,3] := 0.00                      // Valor do Saldo Inicial
				// _aSaldos[_nPosPer,4] := ""                        // Indicador do Saldo Inical (Devedor/Credor)
				_aSaldos[_nPosPer,5] += IIF(RAZ->DC=="D",RAZ->VALOR,0) // Valor total dos débitos no mês
				_aSaldos[_nPosPer,6] += IIF(RAZ->DC=="C",RAZ->VALOR,0) // Valor total dos crédidos no mês	
				//_aSaldos[_nPosPer,7] := 0.00                      // Saldo Final
				//_aSaldos[_nPosPer,8] := ""                        // Indicador do Saldo Inical (Devedor/Credor)
			EndIf		              
		EndIF
		
		dbSelectArea("RAZ")	; dbSkip()
	End
	
	// Gero registro I150
	*-----------------------*
	If I050->I1_CLASSE == "A"	
		f_I150()
	EndIf	
	*-----------------------*
	
	// Fecho o arquivo temporário (Razão)
	If Select("RAZ") > 0
		dbSelectArea("RAZ")	; dbCloseArea()
	EndIf
	
	dbSelectArea("I050")
	dbSkip()
End

dbSelectArea("MANAD")
RecLock("MANAD",.T.)
MANAD->LINHA := "9900|I150|"+AllTrim(Str(_nCntReg150))
MsUnLock()

dbSelectArea("MANAD")
RecLock("MANAD",.T.)
MANAD->LINHA := "9900|I200|"+AllTrim(Str(_nCntReg200))
MsUnLock()

// Fecho o tabela de plano de contas
dbSelectArea("I050") ; dbCloseArea()

****************************************************************************
* Registro Tipo I250 - Saldos das conas de resultado antes do encerramento *
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
Local _cQry
Local _nSldAnt := 0.00
Local _nSldAtu := 0.00
Local _nMes    := 0   
Local _cAno    := ""
Local _cPeriodo:= ""
Local _aSaldos := Array(12,8)  // Segue leiout do registro I150
Local _nPosPer := 0

_cQry := " SELECT A.I2_PERIODO, A.DEBITO, B.CREDITO FROM "
_cQry += " ( "
_cQry += " SELECT I2_PERIODO, SUM(I2_VALOR) AS DEBITO "
_cQry += " FROM SI2010 WHERE I2_PERIODO >= '200401' AND I2_PERIODO <= '200412' AND I2_DEBITO  = '" + AllTrim(I050->I1_CODIGO) + "' AND D_E_L_E_T_='' "
_cQry += " GROUP BY I2_PERIODO "
_cQry += " ) A, "
_cQry += " ( "
_cQry += " SELECT I2_PERIODO, SUM(I2_VALOR) AS CREDITO "
_cQry += " FROM SI2010 WHERE I2_PERIODO >= '200401' AND I2_PERIODO <= '200412' AND I2_CREDITO = '" + AllTrim(I050->I1_CODIGO) + "' AND D_E_L_E_T_='' "
_cQry += " GROUP BY I2_PERIODO "
_cQry += " ) B "
_cQry += " WHERE A.I2_PERIODO = B.I2_PERIODO "
_cQry += " ORDER BY A.I2_PERIODO "

TCQUERY _cQry ALIAS "I150" NEW

dbSelectArea("I150") ; dbGoTop()

dbSelectArea("SI1")
dbSeek(xFilial("SI1")+AllTrim(I050->I1_CODIGO))

_nSldAnt := CalcSaldo(1,1,.T.)

dbSelectArea("I150") ; dbGoTop()
If !Eof()
	_cAno    := SubStr(I150->I2_PERIODO,1,4)
Else
	_cAno    := "2004"	
EndIf	

// Inicializo matriz com os 12 períodos
For _x := 1 to 12
	_aSaldos[_x,1] := AllTrim(I050->I1_CODIGO)  // Conta
	_aSaldos[_x,2] := StrZero(_x,2) + _cAno     // Mês e Ano a que se referem o saldos Inicial e Final
	_aSaldos[_x,3] := 0.00                      // Valor do Saldo Inicial
	_aSaldos[_x,4] := ""                        // Indicador do Saldo Inical (Devedor/Credor)
	_aSaldos[_x,5] := 0.00                      // Valor total dos débitos no mês
	_aSaldos[_x,6] := 0.00                      // Valor total dos crédidos no mês	
	_aSaldos[_x,7] := 0.00                      // Saldo Final
	_aSaldos[_x,8] := ""                        // Indicador do Saldo final (Devedor/Credor)
Next _x

dbSelectArea("I150")

// Preecho Matriz
While !Eof()
		           
	// Posiciona no período na Matriz
	_cPeriodo := SubStr(I150->I2_PERIODO,5,2)+SubStr(I150->I2_PERIODO,1,4) // Mes/Ano
	_nPosPer  := aScan(_aSaldos,{|x| alltrim(x[2]) == _cPeriodo })
	
	If _nPosPer > 0
		_aSaldos[_nPosPer,1] := AllTrim(I050->I1_CODIGO)  // Conta
		// _aSaldos[_nPosPer,2] := StrZero(_x,2) + _cAno     // Mês e Ano a que se referem o saldos Inicial e Final
		// _aSaldos[_nPosPer,3] := 0.00                      // Valor do Saldo Inicial
		// _aSaldos[_nPosPer,4] := ""                        // Indicador do Saldo Inical (Devedor/Credor)
		_aSaldos[_nPosPer,5] := I150->DEBITO                 // Valor total dos débitos no mês
		_aSaldos[_nPosPer,6] := I150->CREDITO                // Valor total dos crédidos no mês	
		//_aSaldos[_nPosPer,7] := 0.00                      // Saldo Final
		//_aSaldos[_nPosPer,8] := ""                        // Indicador do Saldo Inical (Devedor/Credor)
	EndIf
	
	dbSelectArea("I150")
	dbSkip()
End

For _x := 1 To 12
		           
	_nSldAtu := _nSldAnt + (I150->DEBITO - I150->CREDITO)
	//dbSelectArea("SI1")
	//dbSeek(xFilial("SI1")+AllTrim(I050->I1_CODIGO))
	//_nSldAnt := CalcSaldo(_x,1,.T.)
	//_nSldAtu := CalcSaldo(_x,1,.F.)
	
	// _aSaldos[_x,1] := AllTrim(I050->I1_CODIGO)  // Conta
	// _aSaldos[_x,2] := StrZero(_x,2) + _cAno     // Mês e Ano a que se referem o saldos Inicial e Final
	_aSaldos[_x,3] := _nSldAnt                     // Valor do Saldo Inicial
	_aSaldos[_x,4] := IIF(_nSldAnt > 0,"D","C")    // Indicador do Saldo Inical (Devedor/Credor)
	//_aSaldos[_x,5] := I150->DEBITO                 // Valor total dos débitos no mês
	//_aSaldos[_x,6] := I150->CREDITO                // Valor total dos crédidos no mês	
	_aSaldos[_x,7] := _nSldAtu                     // Saldo Final
	_aSaldos[_x,8] := IIF(_nSldAtu > 0,"D","C")    // Indicador do Saldo Inical (Devedor/Credor)

	dbSelectArea("MANAD")
	RecLock("MANAD",.T.)
		MANAD->LINHA := "I150|"+_aSaldos[_x,1]+"|"+_aSaldos[_x,2]+"|"+;
		AllTrim(TRANSFORM(Abs(_aSaldos[_x,3]),"@E 999999999.99"))+"|"+_aSaldos[_x,4]+"|"+;
		AllTrim(TRANSFORM(_aSaldos[_x,5],"@E 999999999.99"))+"|"+AllTrim(TRANSFORM(_aSaldos[_x,6],"@E 999999999.99"))+"|"+;
		AllTrim(TRANSFORM(Abs(_aSaldos[_x,7]),"@E 999999999.99"))+"|"+_aSaldos[_x,8]
	MsUnLock()
	
	_nConta_I++
	_nSldAnt := _nSldAtu
	
Next _x

dbSelectArea("I150") ; dbCloseArea()

Return
      

*-----------------------------------------------------*
Static Function f_I150()
*-----------------------------------------------------*
Local _nSldAnt := 0.00
Local _nSldAtu := 0.00
Local _nMes    := 0   
Local _cAno    := ""
//Local _nPosPer := 0

dbSelectArea("SI1")
dbSeek(xFilial("SI1")+AllTrim(I050->I1_CODIGO))

_nSldAnt := CalcSaldo(1,1,.T.)

For _x := 1 To 12

	// 		                 Débito           Crédito
	_nSldAtu := _nSldAnt + (_aSaldos[_x,5] - _aSaldos[_x,6])
	//dbSelectArea("SI1")
	//dbSeek(xFilial("SI1")+AllTrim(I050->I1_CODIGO))
	//_nSldAnt := CalcSaldo(_x,1,.T.)
	//_nSldAtu := CalcSaldo(_x,1,.F.)
	
	// _aSaldos[_x,1] := AllTrim(I050->I1_CODIGO)  // Conta
	// _aSaldos[_x,2] := StrZero(_x,2) + _cAno     // Mês e Ano a que se referem o saldos Inicial e Final
	_aSaldos[_x,3] := _nSldAnt                     // Valor do Saldo Inicial
	_aSaldos[_x,4] := IIF(_nSldAnt > 0,"D","C")    // Indicador do Saldo Inical (Devedor/Credor)
	//_aSaldos[_x,5] := I150->DEBITO                 // Valor total dos débitos no mês
	//_aSaldos[_x,6] := I150->CREDITO                // Valor total dos crédidos no mês	
	_aSaldos[_x,7] := _nSldAtu                     // Saldo Final
	_aSaldos[_x,8] := IIF(_nSldAtu > 0,"D","C")    // Indicador do Saldo Inical (Devedor/Credor)

	dbSelectArea("MANAD")
	RecLock("MANAD",.T.)
		MANAD->LINHA := "I150|"+_aSaldos[_x,1]+"|"+_aSaldos[_x,2]+"|"+;
		AllTrim(TRANSFORM(Abs(_aSaldos[_x,3]),"@E 999999999.99"))+"|"+_aSaldos[_x,4]+"|"+;
		AllTrim(TRANSFORM(_aSaldos[_x,5],"@E 999999999.99"))+"|"+AllTrim(TRANSFORM(_aSaldos[_x,6],"@E 999999999.99"))+"|"+;
		AllTrim(TRANSFORM(Abs(_aSaldos[_x,7]),"@E 999999999.99"))+"|"+_aSaldos[_x,8]
	MsUnLock()
	
	_nConta_I++
	_nCntReg150++
	_nSldAnt := _nSldAtu
	
Next _x

Return
