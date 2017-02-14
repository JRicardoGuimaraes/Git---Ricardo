#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GEFM22     � Autor � SAULO MUNIZ       � Data �  11/11/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa para importar clientes                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gefco                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GEFM22


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cArq,cInd
Local cString := "SMC"
Local aStru
Private cPerg := "ADHOC"
Private oLeTxt

aStru:={}

aAdd(aStru,{"CGC","C",14,0})
aAdd(aStru,{"INSCRICAO","C",14,00})
aAdd(aStru,{"RAZAO","C",35,00})
aAdd(aStru,{"CLIENTE","C",5,00})
aAdd(aStru,{"RUA","C",30,00})
aAdd(aStru,{"COMPLEMENT","C",20,00})
aAdd(aStru,{"CEP","C",10,00})
aAdd(aStru,{"CIDADE","C",25,00})
aAdd(aStru,{"UF","C",2,00})
aAdd(aStru,{"TEL","C",11,00})
aAdd(aStru,{"FILLER","C",38,00})
aAdd(aStru,{"COD_FIL","C",2,00})
aAdd(aStru,{"FILLER2","C",5,00})
aAdd(aStru,{"FILIAL_AD","C",25,00})

cArq := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cArq,cString,.T.)
cInd := CriaTrab(NIL,.F.)
IndRegua(cString,cInd,"CGC",,,"Selecionando Registros...")

pos  := 0
cNL  := CHR(13)+CHR(10)


	// criacao do arquivo Log
	//=======================
	Arq01  := "D:\MICROSIGA\SIGAADV\import.log"
	sHdl   := fCreate(Arq01)
	te1:="Criacao do arquivo de erros gerados pelo sistema de importacao de Clientes - Data: "+dtoc(ddatabase)+cNL
	fWrite(sHdl,te1,Len(te1))
	te1:="======================================================================================"+cNL
	fWrite(sHdl,te1,Len(te1))

Pergunte(cPerg,.T.)

xHdl    := fOpen(mv_par01,68)

If xHdl == -1
    MsgAlert("O arquivo de nome "+mv_par01+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Exit
Endif

xArq := ALLTRIM(mv_par01)
APPEND FROM &xArq SDF
DBGOTOP()

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Importa Clientes ADHOC - AP5")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto,"
@ 18,018 Say " conforme os parametros definidos pelo usuario, com os "
@ 26,018 Say " registros do arquivo e importar para a base de dados GEFCO."

@ 60,098 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 60,128 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 60,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP5 IDE            � Data �  10/11/02   ���
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


// forca a entrada ao parametro 
//mv_par01 := 'GEFCO.TXT'


Private nHdl    := fOpen(mv_par01,68)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+mv_par01+" nao pode ser aberto! Verifique os parametros.","Atencao!")
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
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  10/11/02   ���
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

Local nTamFile, nTamLin, cBuffer, nBtLidos

//�����������������������������������������������������������������ͻ
//� Lay-Out do arquivo Texto gerado:                                �
//�����������������������������������������������������������������͹
//�Campo           � Inicio � Tamanho                               �
//�����������������������������������������������������������������Ķ
//� CGC     � 01     � 14                                �
//� INSCRICAO     � 15  � 14                                �
//� RAZAO     � 29  � 35                                �
//� CLIENTE     � 64  � 5                                �
//� RUA     � 69  � 30                                �
//� COMPLEMENT     � 99  � 20                                �
//� CEP     � 119  � 10                                �
//� CIDADE     � 129  � 25                                �
//� UF     � 154  � 2                                �
//� TEL     � 156  � 11                                �
//� AL TERACAO     � 167  � 16                                �
//� COD_VEND     � 184  � 6                                �
//� VENDEDOR     � 191  � 16                                �
//� COD_FILIAL     � 220  � 2                                �
//� FILLER     � 222  � 5                                �
//� FILIAL     � 228  � 25                                �
//�����������������������������������������������������������������ͼ

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 253+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile) // Numero de registros a processar

xcont := 0

While nBtLidos >= nTamLin

    //���������������������������������������������������������������������Ŀ
    // Incrementa a regua                                                  �
    //�����������������������������������������������������������������������

    IncProc()

    //���������������������������������������������������������������������Ŀ
    //� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
    //�����������������������������������������������������������������������
   
   DbSelectArea("SMC") 
   _xcgc := Alltrim(SMC->CGC)
   
  If  CGC(_xcgc)
//      xcont : xcont + 1
//   Msginfo("Cgc/Cnpj nao valido : "+_xcgc+"  "+Alltrim(SMC->RAZAO))
  Else
  		pos  := 2
		errata2()
        Dbskip()                                                                                 
  Endif
    
   DbSelectArea("SA1") 
   DbSetOrder(3)
   IF !DbSeek(xFilial("SA1")+_xcgc) 
 
   RecLock("SA1",.T.)

    SA1->A1_FILIAL := xFilial("SA1")
    SA1->A1_COD  := GETSXENUM("SA1","A1_COD") 
    SA1->A1_LOJA :="01"
    SA1->A1_NATUREZ:= "500"
    SA1->A1_TIPO := "R"
    SA1->A1_CONTA := "112101"  // VERIFICAR CONTA CONTABABIL. 
//    xPessoa :=IIF(LEN(SA1->A1_CGC)==14,"J","R")                                                   
//    SA1->A1_PESSOA := xPessoa
    SA1->A1_GRUPO:="4"
    SA1->A1_GSECON:="121"
    SA1->A1_COND:= "004"
    SA1->A1_CGC  := SMC->CGC
    SA1->A1_INSCR:= SMC->INSCRICAO
    SA1->A1_NOME := SMC->RAZAO       
    SA1->A1_NREDUZ:= Substr(Alltrim(SMC->RAZAO),1,20)       
    SA1->A1_END  := Alltrim(SMC->RUA)+" "+Alltrim(SMC->COMPLEMENT)
    SA1->A1_CEP :=  SMC->CEP
    SA1->A1_MUN :=  SMC->CIDADE
    SA1->A1_EST :=  SMC->UF
    SA1->A1_CCONT := "315501"
    SA1->A1_TEL := SMC->TEL

// Altera��o em 20/03/03 para gravar 
// dados de cobran�a 
    
    SA1->A1_ENDCOB  := Alltrim(SMC->RUA)+" "+Alltrim(SMC->COMPLEMENT)
    SA1->A1_BAIRROC := SMC->CIDADE
    SA1->A1_MUNC    := SMC->CIDADE
    SA1->A1_ESTC    := SMC->UF
    SA1->A1_CEPC    := SMC->CEP   
    SA1->A1_OBS     := "IMPORT"
//
    MSUnLock()
    ConfirmSx8() 
   Else
	pos  := 1
	errata2()
    DbSelectArea("SMC") 
    dbSkip()
   Endif

    //���������������������������������������������������������������������Ŀ
    //� Leitura da proxima linha do arquivo texto.                          �
    //�����������������������������������������������������������������������
   
    DbSelectArea("SMC")
    dbSkip()
    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto

EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������

fClose(nHdl)
Close(oLeTxt)

DbCloseArea("SMC")

fClose(sHdl)
If pos == 0
	MsgInfo("Importacao Concluida com Sucesso !!")
	DBCLOSEAREA("SMC")
Else
	Alert("Importacao Concluida com OBS. !!")
	Alert("Verificar IMPORT.LOG !!")
	DBCLOSEAREA("SMC")
EndIf


Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP5 IDE            � Data �  10/11/02   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","CAMINHO/NOME DO ARQ.","mv_ch1","C",50,00,0,"G","","mv_par01","","","","","","","","","","","","","",""})

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

dbSelectArea(_sAlias)

Return


Static Function Errata2()

If pos == 1
	te1:="Cliente Ja cadastrado.: "+SMC->CGC+" "+" Nome "+SMC->RAZAO+cNL       
	fWrite(sHdl,te1,Len(te1))
Endif
If pos == 2
	te1:="Cgc / Cnpj Invalido.: "+SMC->CGC+" "+" Nome "+SMC->RAZAO+cNL       
	fWrite(sHdl,te1,Len(te1))
Endif

Return
