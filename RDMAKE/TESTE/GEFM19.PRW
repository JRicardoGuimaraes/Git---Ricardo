#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEFM19  º Autor ³ Saulo Muniz          º Data ³  11/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Listagem de Cobrança                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEFCO                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GEFM19

Local cDesc1       := "Este programa tem como objetivo imprimir a conferencia "
Local cDesc2       := "dos lancamentos de acordo com os parametros informados "
Local cDesc3       := "pelo usuario."
Local cPict        := ""
Local imprime      := .T.
Local aOrd         := {}
Private Cabec1       := "" 
Private Cabec2       := ""
Private nLin       := 80
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "GEFM19" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GEFM19" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "SZ2"
Private cPerg      := "GEFM19"   //"CTR040"

titulo := "Verifica Cobrança "

ValidPerg()

If !Pergunte(cPerg,.T.)                           // Pergunta no SX1
   Return
EndIf

wnrel := SetPrint(cString,NomeProg,"",titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo) },Titulo)


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  14/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo)

Private nPos   := 0
Private cQuery := ""
nlin := 80

V_Se1  := RETSQLNAME("SE1")
V_Sa1  := RETSQLNAME("SA1")
_cFilial := ""
nValorFil := 0
nTotalG   := 0
_cFilAnt  := ""   
   
Titulo := "Relação de Titulos não Enviados para Banco : Período ( " + DTOC(MV_PAR01) + " - " + DTOC(MV_PAR02) + " )"
Cabec1 := " Emissão  Filial  Prefixo   Numero    Cliente / Loja   Nome                              Valor " 

cQuery = "SELECT A.E1_FILIAL ,A.E1_NUM ,A.E1_PREFIXO ,A.E1_NOMCLI ,A.E1_CLIENTE ,A.E1_LOJA ,A.E1_EMISSAO ,A.E1_VALOR ,B.A1_COD ,B.A1_LOJA ,B.A1_CONTA ,B.A1_NREDUZ,A.E1_BAIXA ,A.E1_NATUREZ ,A.E1_VLRICM,A.E1_ISS"
cQuery += " FROM "+V_Se1+" AS A,"+V_Sa1+" AS B "
cQuery += " WHERE A.E1_CLIENTE = B.A1_COD AND A.E1_LOJA = B.A1_LOJA AND"
cQuery += " A.E1_EMISSAO >=" + "'"+DTOS(Mv_Par01)+"'" +  " AND "
cQuery += " A.E1_EMISSAO <=" + "'"+DTOS(Mv_Par02)+"'" +  " AND "
cQuery += " A.E1_FILIAL >=" + "'"+ Mv_Par03 +"'" +  " AND "
cQuery += " A.E1_FILIAL <=" + "'"+ Mv_Par04 +"'" +  " AND "
cQuery += " B.A1_BOLETO = 'S' AND A.E1_SITUACA = '0'  AND"
cQuery += " A.E1_SALDO > 0 AND "
//cQuery += " A.E1_TIPO <> 'FAT' AND "
cQuery += " A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY A.E1_FILIAL+A.E1_EMISSAO+A.E1_NUM "

//TcQuery cQuery  ALIAS "GFR" NEW
//cQuery := ChangeQuery(cQuery)
//dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)

TcQuery cQuery Alias "XXX" NEW
DbSelectArea("XXX")
DbGoTop()         
SetRegua(RecCount())

_cFilial := XXX->E1_FILIAL
    
While !Eof() 
    
	IncRegua()

    If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    	nLin := 6
		nLin ++		
    Endif      

    If _cFilial <> XXX->E1_FILIAL
		nLin ++		       
       @nLin,050 PSAY " Total da Filial ( " + _cFilial + " )  : " 
       @nLin,080 PSAY nValorFil PICTURE "@E 999,999,999.99"       
       nTotalG := nTotalG + nValorFil
       nValorFil := 0
       _cFilAnt := _cFilial
       _cFilial := XXX->E1_FILIAL   
		nLin ++		                    
    Endif
   
    nLin ++		       
    nValorFil := nValorFil + XXX->E1_VALOR        
    
	@nLin,001 PSAY DTOC(STOD(XXX->E1_EMISSAO))
	@nLin,011 PSAY XXX->E1_FILIAL
	@nLin,018 PSAY XXX->E1_PREFIXO  
	@nLin,028 PSAY XXX->E1_NUM
	@nLin,039 PSAY XXX->E1_CLIENTE
	@nLin,047 PSAY XXX->E1_LOJA   
	@nLin,054 PSAY ALLTRIM(XXX->A1_NREDUZ)   
	@nLin,080 PSAY XXX->E1_VALOR PICTURE "@E 999,999,999.99"   

  	DbSkip()
   

Enddo

 If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
  	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   	nLin := 6
	nLin ++		
 Endif      
 
 nLin ++		       

 If MV_PAR03 <> MV_PAR04
	nLin ++		       
    @nLin,050 PSAY " Total da Filial ( " + _cFilial + " )  : " 
    @nLin,080 PSAY nValorFil PICTURE "@E 999,999,999.99"       
   // nTotalG := nTotalG + nValorFil
   // nValorFil := 0
   // _cFilAnt := _cFilial
   // _cFilial := XXX->E1_FILIAL   
	nLin ++		           
	nLin ++		           
 
 Endif

 @nLin,054 PSAY " Total Geral  :  "
 //@nLin,080 PSAY nValorFil  PICTURE "@E 999,999,999,999.99"       
 @nLin,077 PSAY nTotalG  PICTURE "@E 999,999,999,999.99"       


DbSelectArea("XXX")
DbCloseArea()


SET DEVICE TO SCREEN
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()


Return


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

Aadd(aRegs,{cPerg,"01","Data de Emissao de     :","","","mv_ch1","D",008,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data de Emissao Ate    :","","","mv_ch2","D",008,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Filial de ...........","","","mv_ch2","C",002,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Filial ate...........","","","mv_ch2","C",002,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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