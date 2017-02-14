#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/***************************************************************************
* Programa.......: GEFM073()                                               *
* Autor..........: J Ricardo Guimar�es                                     *
* Data...........: 23/11/2010                                              *
* Descricao......: Imprimir Fatura a Pagar de Compra de Frete              *
*                                                                          *
****************************************************************************
* Alt. por.......:                                                         *
* Data...........:                                                         *
* Motivo.........:                                                         *
*                                                                          *
***************************************************************************/

User Function GEFM073()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg       := "GEF073"
Private oGeraTxt
Private cString 	:= "SE2"
Private _cNomeArq   := ""
Private _cPasta		:= ""

dbSelectArea("SE2")
dbSetOrder(1)

AjustaSX1()
Pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera��o de Arquivo Texto de Fatura de Compra Frete")
@ 00.50,001 TO 005,23
@ 02,003 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 03,003 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 04,003 Say " SE2 - Contas a Pagar                                          "

@ 70,068 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 70,098 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATXT� Autor � AP5 IDE            � Data �  23/11/10   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
*----------------------------*
Static Function OkGeraTxt
*----------------------------*
//���������������������������������������������������������������������Ŀ
//� Cria o arquivo texto                                                �
//�����������������������������������������������������������������������

_cPasta   := MV_PAR03
_cNomeArq := MV_PAR04

If Right(AllTrim(_cPasta),1) <> "\"
   _cPasta := AllTrim(_cPasta) + "\"
EndIf

_cPasta := AllTrim(_cPasta)

Private nHdl    := fCreate(_cPasta + _cNomeArq)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+_cPasta+_cNomeArq+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  23/11/10   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
*------------------------------*
Static Function RunCont
*------------------------------*
Local nTamLin, cLin, cCpo
Local _cQry := ""
Local _nVrFat := 0    
Local _nItem  := 0


//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� O tratamento dos parametros deve ser feito dentro da logica do seu  �
//� programa.  Geralmente a chave principal e a filial (isto vale prin- �
//� cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- �
//� meiro registro pela filial + pela chave secundaria (codigo por exem �
//� plo), e processa enquanto estes valores estiverem dentro dos parame �
//� tros definidos. Suponha por exemplo o uso de dois parametros:       �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//� Assim o processamento ocorrera enquanto o codigo do registro posicio�
//� nado for menor ou igual ao parametro mv_par02, que indica o codigo  �
//� limite para o processamento. Caso existam outros parametros a serem �
//� checados, isto deve ser feito dentro da estrutura de la�o (WHILE):  �
//�                                                                     �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//� mv_par03 -> Considera qual estado?                                  �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//�     If A1_EST <> mv_par03                                           �
//�         dbSkip()                                                    �
//�         Loop                                                        �
//�     Endif                                                           �
//�����������������������������������������������������������������������


_cQry := " SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_EMISSAO, E1_VRFRETE, "
_cQry += "        E1_FATFRET, E1_PREFRET, E2_VALOR, E2_NUM, E2_PREFIXO, E2_EMISSAO, E2_VENCREA, A2_COD, SA2.A2_NOME AS RAZ_TRANSP, E1_TRANSP, "
_cQry += "        A2_END, A2_NR_END, A2_BAIRRO, A2_MUN, A2_EST, A2_CEP, A2_TEL, A2_CONTATO "
_cQry += "   FROM " + RetSqlName("SE1") + " SE1, " + RetSqlName("SA2") + " SA2, " + RetSqlName("SE2") + " SE2 "
_cQry += "   WHERE E2_FILIAL   = '" + xFilial("SE2") + "' "
_cQry += "     AND E2_PREFIXO  = '" + MV_PAR02 + "' "
_cQry += "     AND E2_NUM      = '" + MV_PAR01 + "' "
_cQry += "     AND E2_FILIAL   =  E1_FILIAL "
_cQry += "     AND E1_EMISSAO >= '20100901' "
_cQry += "     AND E2_NUM      = E1_FATFRET "
_cQry += "     AND E2_PREFIXO  = E1_PREFRET "
_cQry += "     AND SE1.D_E_L_E_T_= '' "
_cQry += "     AND SE2.D_E_L_E_T_= '' "
_cQry += "     AND A2_CGC        = E1_TRANSP "
_cQry += "  ORDER BY E2_NUM, E2_PREFIXO, E2_PARCELA "

If Select("TFAT") > 0
	dbSelectArea("TFAT") ; dbCloseArea()
EndIf

cQuery := ChangeQuery(_cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"TFAT")

dbSelectArea("TFAT")
dbGoTop()

If TFAT->(Eof())
	Aviso("Aviso","N�o h� dados para gerar o arquivo de interface.",{"Ok"})
	dbSelectArea("TFAT") ; dbCloseArea()
	Return
EndIf

ProcRegua(0) // Numero de registros a processar

_nVrFat  := TFAT->E2_VALOR
_cNumFat := TFAT->E2_NUM
_cPrefFat:= TFAT->E2_PREFIXO

nTamLin := 150
cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

// Gera Cabe�alho
cLin := Stuff(cLin,01,02,"00")  	// Identifica��o de Registro
cCpo := PadR(TFAT->E1_TRANSP,18)
cLin := Stuff(cLin,03,18,cCPO)  	// Identifica a Transportadora

cCpo := PadR(AllTrim(TFAT->RAZ_TRANSP),30)
cLin := Stuff(cLin,21,30,cCPO)  	// Raz�o Social da Transportadora

cCpo := PadR(TFAT->E2_NUM,09)
cLin := Stuff(cLin,51,09,cCPO)  	// N�mero da Fatura

cCPO := PadR(SubStr(TFAT->E2_VENCREA,7,2)+SubStr(TFAT->E2_VENCREA,5,2)+SubStr(TFAT->E2_VENCREA,1,4),08)
cLin := Stuff(cLin,60,08,cCPO) 		// Vencimento da Fatura

cCPO := PadR(TFAT->E2_PREFIXO,03)
cLin := Stuff(cLin,68,03,cCPO) 		// Prefixo da Fatura
//cLin := Stuff(cLin,71,80,"") 		// Espa�os     

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
      Return
   EndIf
Endif

_nItem := 1

While !EOF()

    //���������������������������������������������������������������������Ŀ
    //� Incrementa a regua                                                  �
    //�����������������������������������������������������������������������

    IncProc()

    //�����������������������������������������������������������������ͻ
    //� Lay-Out do arquivo Texto gerado:                                �
    //�����������������������������������������������������������������͹
    //�Campo           � Inicio � Tamanho                               �
    //�����������������������������������������������������������������Ķ
    //� ??_FILIAL     � 01     � 02                                    �
    //�����������������������������������������������������������������ͼ

    nTamLin := 150
    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

    //���������������������������������������������������������������������Ŀ
    //� Substitui nas respectivas posicioes na variavel cLin pelo conteudo  �
    //� dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     �
    //� string dentro de outra string.                                      �
    //�����������������������������������������������������������������������

    cLin := Stuff(cLin,01,02,"01")		// Fixo "01"
    
    cCpo := PADR(SM0->M0_FILIAL,20)  	// Filial
    cLin := Stuff(cLin,03,20,cCpo)
                                                 
    cCpo := PADR(SubStr(TFAT->E1_EMISSAO,7,2)+SubStr(TFAT->E1_EMISSAO,5,2)+SubStr(TFAT->E1_EMISSAO,1,4),08)  	// Data de Emiss�o
    cLin := Stuff(cLin,23,08,cCpo)
    
    cCpo := PADR(TFAT->E1_NUM,09)  		// N�mero do CTRC
    cLin := Stuff(cLin,31,09,cCpo)
    
    cCpo := PADR(TFAT->E1_PREFIXO,03)  	// Prefixo do N�mero do CTRC
    cLin := Stuff(cLin,40,03,cCpo)
    
    cCpo := STRTRAN(AllTrim(STRZERO(TFAT->E1_VRFRETE,18,2)),".","") // Valor do Frete (Compra)
    cLin := Stuff(cLin,43,17,cCpo)
    
    cCpo := PADR(TFAT->E2_NUM,09)  		// N�mero da Fatura de Compra de Frete
    cLin := Stuff(cLin,60,09,cCpo)  
    
    cCpo := PADR(TFAT->E2_PREFIXO,03)  	// Prefixo Fatura 
    cLin := Stuff(cLin,69,03,cCpo)  

    //���������������������������������������������������������������������Ŀ
    //� Gravacao no arquivo texto. Testa por erros durante a gravacao da    �
    //� linha montada.                                                      �
    //�����������������������������������������������������������������������

    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            Exit
        Endif
    Endif

    dbSkip()
    _nItem++
EndDo

_nItem++
// Gero Rodap�

nTamLin := 150
cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao
    
cLin := Stuff(cLin,01,02,"99")  				// Identifica��o de Registro
cLin := Stuff(cLin,03,07,StrZero(_nItem,07))	// Quantidade de Registros
cLin := Stuff(cLin,10,17,StrTran(AllTrim(StrZERO(_nVrFat,18,2)),".",""))  // Valor da Fatura de Compra de Frete
cLin := Stuff(cLin,27,09,PadR(_cNumFat,09))  	// N�mero da Fatura
cLin := Stuff(cLin,36,03,PadR(_cPrefFat,03)) 	// Prefixo da Fatura

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
   If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
      Return
   Endif
Endif

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������

fClose(nHdl)
Close(oGeraTxt)

dbSelectArea("TFAT") 
dbCloseArea()

Return

*----------------------------------*
Static Function AjustaSX1()
*----------------------------------*
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

DbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))

Aadd(aRegs,{cPerg,"01","Numero Fatura de  :","","","mv_ch1","C",009,0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Prefixo da Fatura :","","","mv_ch2","C",003,0,0,"G","NaoVazio()","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Diretorio Destino :","","","mv_ch3","C",030,0,0,"G","NaoVazio()","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Nome do Arquivo   :","","","mv_ch4","C",030,0,0,"G","NaoVazio()","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//Aadd(aRegs,{cPerg,"06","Transportadora ate      :","","","mv_ch6","C",006,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
//Aadd(aRegs,{cPerg,"07","Loja Transportadora ate :","","","mv_ch7","C",002,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""   ,""})

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