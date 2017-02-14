#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGEFCTB20  บ Autor ณ Marcos Furtado     บ Data ณ  03/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO DE CONFERENCIA DE CFOP X UF, exibindo os doc.     ฑฑ
ฑฑบ          ณ que estใo com CFOP errados                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEFCO                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GEFCTB20

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1       := "Este programa tem como objetivo imprimir a diverg๊ncia "
Local cDesc2       := "dos CFOPs dos documentos Fiscais - Livros Fiscais (SF3)."
Local cDesc3       := ""
Local cPict        := ""
Local imprime      := .T.
Local aOrd         := {}
Private Cabec1     := "Data      SERIE   Num     Especie  Cliente  Loja             Valor Imposto   CFOP UF" 
Private Cabec2       := ""
Private titulo := "Relatorio de Doc. Fiscais com CFOP X UF em divergencia. "
Private nLin       := 80
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "GEFCTB20" // Coloque aqui o nome do programa para impressao no cabecalho


Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GEFCTB20" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "SZ2"
Private cPerg      := "GECT20"   



ValidPerg()

If !Pergunte(cPerg,.T.)                           // Pergunta no SX1
   Return
EndIf

 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
wnrel := SetPrint(cString,NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo) },Titulo)


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  14/04/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo)

Local cQry  := ""
Local cBkpFil  := cFilAnt 
Local nRecSM0              
Local lFirst := .T.
Local cGrupo := ""
Local cEstado := ""
nlin := 80

DbSelectArea("SM0")
nRecSM0 := RecNo()

//vALORES iss
cQry := "SELECT F3_FILIAL, F3_SERIE, F3_ESPECIE, F3_NFISCAL, F3_EMISSAO, F3_VALCONT, "
cQry += " F3_CLIEFOR, F3_LOJA, F3_CFO, F3_ESTADO  "
cQry += " FROM " + RetSqlName("SF3") + " SF3 "
cQry += "WHERE SF3.D_E_L_E_T_ <> '*' AND F3_EMISSAO >= '" + DTOS(MV_PAR01) + "' AND "
cQry += "F3_EMISSAO <= '" + DTOS(MV_PAR02) + "' AND "
cQry += "F3_FILIAL >= '" + MV_PAR03 + "' AND "
cQry += "F3_FILIAL <= '" + MV_PAR04 + "' AND "
If MV_PAR05 == 1     // Entrada
	cQry += "F3_CFO	< '5' AND "
ElseIf MV_PAR05 == 2 // Saํda
	cQry += "F3_CFO	>= '5' AND "
EndIf                           
cQry += "F3_CFO	< 'A' "
cQry += "ORDER BY F3_FILIAL, F3_EMISSAO, F3_SERIE, F3_NFISCAL "

TcQuery cQry Alias "TSF3" NEW
DbSelectArea("TSF3")

If !Eof()             
	
    If nLin > 70 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    	nLin := 8
    Endif          
	DbSelectArea("SM0")    
	DbSeek(cEmpAnt+TSF3->F3_FILIAL)
		@nLin,001 PSAY Replicate("_",80)
	nLin ++	
	cGrupo := TSF3->F3_FILIAL
	cFilAnt := TSF3->F3_FILIAL
	cEstado := GetMv("MV_ESTADO")	
	@nLin,001 PSAY "Filial: " +  SM0->M0_CODFIL + " - " + SM0->M0_NOME + " - " + 	cEstado
	nLin ++
	@nLin,001 PSAY Replicate("_",80)
	nLin ++
	

EndIf

DbSelectArea("TSF3")
SetRegua(RecCount())
While !Eof() 
	IncRegua()                   

    If nLin > 70 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
    	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    	nLin := 8
    Endif      
                     
	If cGrupo <> TSF3->F3_FILIAL 
		cFilAnt := TSF3->F3_FILIAL	
		If MV_PAR06 == 1 
		   	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    		nLin := 7          
	    		
  		Endif
  		nLin ++
    	DbSelectArea("SM0")
		DbSeek(cEmpAnt+TSF3->F3_FILIAL)
		cEstado := GetMv("MV_ESTADO")				
		
		@nLin,001 PSAY Replicate("_",80)
		nLin ++	
		@nLin,001 PSAY "Filial: " +  SM0->M0_CODFIL + " - " + SM0->M0_NOME	+ " - " + 	cEstado
		nLin ++
		@nLin,001 PSAY Replicate("_",80)
	
		nLin ++
		cGrupo := TSF3->F3_FILIAL
	EndIF                                                                     
	
	If SubStr(TSF3->F3_CFO,1,1) < '5' //Entrada
		If SubStr(TSF3->F3_CFO,1,1) = '1' .And. cEstado == TSF3->F3_ESTADO
		    DbSelectArea("TSF3")
		    DbSkip()
		    LOOP
		ElseIf SubStr(TSF3->F3_CFO,1,1) = '2' .And. cEstado <> TSF3->F3_ESTADO .And. TSF3->F3_ESTADO <> 'EX'
		    DbSelectArea("TSF3")
		    DbSkip()
		    LOOP
		ElseIf SubStr(TSF3->F3_CFO,1,1) = '3' .And. TSF3->F3_ESTADO == 'EX'
		    DbSelectArea("TSF3")
		    DbSkip()
		    LOOP
		EndIF				
	Else 
		If SubStr(TSF3->F3_CFO,1,1) = '5' .And. cEstado == TSF3->F3_ESTADO
		    DbSelectArea("TSF3")
		    DbSkip()
		    LOOP
		ElseIf SubStr(TSF3->F3_CFO,1,1) = '6' .And. cEstado <> TSF3->F3_ESTADO .And. TSF3->F3_ESTADO <> 'EX'
		    DbSelectArea("TSF3")
		    DbSkip()
		    LOOP
		ElseIf SubStr(TSF3->F3_CFO,1,1) = '7' .And. TSF3->F3_ESTADO == 'EX'
		    DbSelectArea("TSF3")
		    DbSkip()
		    LOOP
		EndIF				
	EndIF
           //          1         2         3         4         5         6         7         8       	
           //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//Cabec1 := "Data      SERIE   Num     Especie  Cliente  Loja             Valor Imposto   CFOP UF" 
	@nLin,001 PSAY DTOC(STOD(TSF3->F3_EMISSAO))
	@nLin,011 PSAY TSF3->F3_SERIE  
	@nLin,018 PSAY TSF3->F3_NFISCAL
	@nLin,026 PSAY TSF3->F3_ESPECIE
	@nLin,035 PSAY TSF3->F3_CLIEFOR
	@nLin,044 PSAY TSF3->F3_LOJA   
	@nLin,051 PSAY TSF3->F3_VALCONT PICTURE "@E 999,999,999.99"   
	@nLin,077 PSAY TSF3->F3_CFO
	@nLin,082 PSAY TSF3->F3_ESTADO   		

	nLin ++		

    DbSelectArea("TSF3")
    DbSkip()
End                     
DbSelectArea("TSF3")
DbCloseArea()

DbSelectArea("SM0")
DbGoTo(nRecSM0)
cFilAnt := cBkpFil

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

Aadd(aRegs,{cPerg,"01","Data de Emissao de    :","","","mv_ch1","D",008,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data de Emissao Ate   :","","","mv_ch2","D",008,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Filial de             :","","","mv_ch3","C",002,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Filial ate            :","","","mv_ch4","C",002,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Tipo de Doc           :","","","mv_ch5","C",001,0,0,"C","","mv_par03","Entrada","Entrada","Entrada","","","Saida","Saida","Saida","","Todos","Todos","Todos","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Quebra pag. por filial:","","","mv_ch6","C",001,0,0,"C","","mv_par06","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"03","Exibe Fin sem Cont     :","","","mv_ch3","C",001,0,0,"C","","mv_par03","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"04","Exibe Fiscal sem Cont  :","","","mv_ch4","C",001,0,0,"C","","mv_par04","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","",""})

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
