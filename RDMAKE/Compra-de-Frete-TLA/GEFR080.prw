/***************************************************************************
* Programa.......: GEFR080()                                               *
* Autor..........: J Ricardo Guimar�es                                     *
* Data...........: 23/10/2012                                              *
* Descricao......: Imprimir Fatura a Pagar de Compra de Frete              *
*                                                                          *
****************************************************************************
* Alt. por.......:                                                         *
* Data...........:                                                         *
* Motivo.........:                                                         *
*                                                                          *
***************************************************************************/
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "PRINT.CH"

User Function GEFR080()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Compra de Frete - TLA"
Local cPict          := ""
Local titulo       := "Relatorio de Compra de Frete - TLA"
Local nLin         := 80

Local Cabec1       := "Pr� Fat.: "
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "GEFR080" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "GEF080"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "GEFR080" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SE2"

dbSelectArea("SE2")
dbSetOrder(1)

AjustaSX1()
	
pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  22/11/10   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

*-------------------------------------------------------*
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
*-------------------------------------------------------*
Local nOrdem 
Local _cQry 	:= ""
Local _cNumFat 	:= ""
Local _nItem    := 0
Local _nTotCTRC := 0
Local _cFatAnt  := ""

dbSelectArea(cString)
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

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
//� relatorio. Geralmente a chave principal e a filial (isto vale prin- �
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
/*
_cQry := " SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_EMISSAO, E1_VRFRETE, "
_cQry += "        E1_FATFRET, E1_PREFRET, E2_VALOR, E2_NUM, E2_EMISSAO, E2_VENCREA, A2_COD, SA2.A2_NOME AS RAZ_TRANSP, E1_TRANSP, A2_END, A2_NR_END, A2_BAIRRO, A2_MUN, A2_EST,"
_cQry += "        A2_CEP, A2_TEL, A2_CONTATO, E1_FATFRET, E1_PREFRET, E1_VRFRETE "
_cQry += "   FROM " + RetSqlName("SE1") + " SE1, " + RetSqlName("SA2") + " SA2, " + RetSqlName("SE2") + " SE2 "
_cQry += "   WHERE E2_FILIAL   = '" + xFilial("SE2") + "' "
_cQry += "     AND E2_PREFIXO  = '" + MV_PAR03 + "' "
_cQry += "     AND E2_NUM     >= '" + MV_PAR01 + "' "
_cQry += "     AND E2_NUM     <= '" + MV_PAR02 + "' "
_cQry += "     AND E2_FILIAL   =  E1_FILIAL "
_cQry += "     AND E1_EMISSAO >= '20120101' "
_cQry += "     AND E2_NUM      = E1_FATFRET "
_cQry += "     AND E2_PREFIXO  = E1_PREFRET "
_cQry += "     AND SE1.D_E_L_E_T_= '' "
_cQry += "     AND SE2.D_E_L_E_T_= '' "
_cQry += "     AND A2_CGC        = E1_TRANSP "
_cQry += "  ORDER BY E2_NUM, E2_PREFIXO, E2_PARCELA "
*/

_cQry := " SELECT SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, SE2.E2_VLCRUZ AS VRFRETE, SE2.E2_VALOR, SE2.E2_EMISSAO, SE2.E2_VENCREA "
_cQry += "        A2_COD, SA2.A2_NOME AS RAZ_TRANSP, A2_END, A2_NR_END, A2_BAIRRO, A2_MUN, A2_EST, A2_CGC, "
_cQry += "        A2_CEP, A2_TEL, A2_CONTATO, SE2.E2_FATPREF, SE2.E2_FATURA, FAT.E2_VENCREA AS VENC_FAT, FAT.E2_VLCRUZ AS VALOR_FAT, FAT.E2_EMISSAO AS EMISSAO_FAT "
_cQry += " FROM SA2010 SA2, SE2010 SE2 LEFT JOIN SE2010 FAT ON SE2.E2_FILIAL = FAT.E2_FILIAL AND SE2.E2_FATURA = FAT.E2_NUM AND SE2.E2_FATPREF = FAT.E2_PREFIXO "
_cQry += "   WHERE SE2.E2_FILIAL   = '" + xFilial("SE2") + "' "
_cQry += "     AND SE2.E2_FATPREF  = '" + MV_PAR03 + "' "
_cQry += "     AND SE2.E2_FATURA  >= '" + MV_PAR01 + "' "
_cQry += "     AND SE2.E2_FATURA  <= '" + MV_PAR02 + "' "
_cQry += "     AND SE2.E2_EMISSAO >= '20120101' "
_cQry += "     AND SE2.D_E_L_E_T_= '' "
_cQry += "     AND A2_COD      = SE2.E2_FORNECE "
_cQry += "     AND A2_LOJA     = SE2.E2_LOJA "
_cQry += "  ORDER BY SE2.E2_FATURA, SE2.E2_FATPREF, SE2.E2_NUM, SE2.E2_PREFIXO, SE2.E2_PARCELA "

If Select("TFAT") > 0
	dbSelectArea("TFAT") ; dbCloseArea()
EndIf

cQuery := ChangeQuery(_cQry)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"TFAT")

dbGoTop()

If TFAT->(Eof())
	Aviso("Aviso","N�o h� dados a serem impresso.",{"Ok"})
	dbSelectArea("TFAT") ; dbCloseArea()
	Return
EndIf

While !TFAT->(EOF())

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������
   _cFatAnt := TFAT->E2_FATURA
   nlin 	:= 80
   While !TFAT->(EOF()) .and. _cFatAnt == TFAT->E2_FATURA
	   If lAbortPrint
	      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	      Exit
	   Endif
	
	   //���������������������������������������������������������������������Ŀ
	   //� Impressao do cabecalho do relatorio. . .                            �
	   //�����������������������������������������������������������������������
	
	   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,(Cabec1 + TFAT->E2_FATURA + "  Emis.: " + DTOC(STOD(TFAT->EMISSAO_FAT)) + "  Vencto.: " + DTOC(STOD(TFAT->VENC_FAT)) + "  Valor : " + TRANSFORM(TFAT->VALOR_FAT, "@E 999,999,999.99")),;
	      Cabec2,NomeProg,Tamanho,nTipo)
	      @ prow()+1,00 PSAY "Transp.: " + TFAT->RAZ_TRANSP    + "  CNPJ: " + TRANSFORM(TFAT->A2_CGC, "@R 99.999.999/9999-99")
	      @ prow()+1,00 PSAY "Tel.: "  + AllTrim(TFAT->A2_TEL) + "  Contato: " + AllTrim(TFAT->A2_CONTATO)
	      @ prow()+1,00 PSAY "End.: " + AllTrim(TFAT->A2_END)  + ", " + AllTrim(TFAT->A2_NR_END) + " - Bairro: " + AllTrim(TFAT->A2_BAIRRO) 
	      @ prow()+1,00 PSAY "Mun.: " + AllTrim(TFAT->A2_MUN)  + " Estado: " + TFAT->A2_EST   
	      nLin := 13
	      @ nLin,00 PSAY "No.  DATA EMISSAO  No.CTRC GEFCO                 VALOR       " 
	      //              01      09            23                  43
	      @ nLin+1,00 PSAY __PrtThinLine()
	      nLin := 15
	   Endif
	
	   // Coloque aqui a logica da impressao do seu programa...
	   // Utilize PSAY para saida na impressora. Por exemplo:
	   _nItem++
	   @nLin,00 PSAY StrZero(_nItem,04)
	   @nLin,09 PSAY DTOC(STOD(TFAT->E2_EMISSAO))
	   @nLin,23 PSAY TFAT->E2_NUM
	   @nLin,43 PSAY TRANSFORM(TFAT->VRFRETE, "@E 999,999,999.99")
	  
	   _nTotCTRC += TFAT->VRFRETE
	   nLin := nLin + 1 // Avanca a linha de impressao
	
	   dbSkip() // Avanca o ponteiro do registro no arquivo
   End
End
@ nLin,00 PSAY __PrtThinLine()
nLin++
@ nLin,00 PSAY "Quantidade de CTRC : " + StrZero(_nItem,5)
@ nLin,43 PSAY TRANSFORM(_nTOTCTRC, "@E 999,999,999.99")

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

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

Aadd(aRegs,{cPerg,"01","Numero Fatura de        :","","","mv_ch1","C",009,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""   ,""})
Aadd(aRegs,{cPerg,"02","Numero Fatura Ate       :","","","mv_ch2","C",009,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""   ,""})
Aadd(aRegs,{cPerg,"03","Prefixo da Fatura       :","","","mv_ch3","C",003,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""   ,""})
Aadd(aRegs,{cPerg,"04","Transportadora de       :","","","mv_ch4","C",006,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
Aadd(aRegs,{cPerg,"05","Loja Transportadora de  :","","","mv_ch5","C",002,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""   ,""})
Aadd(aRegs,{cPerg,"06","Transportadora ate      :","","","mv_ch6","C",006,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
Aadd(aRegs,{cPerg,"07","Loja Transportadora ate :","","","mv_ch7","C",002,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""   ,""})

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
