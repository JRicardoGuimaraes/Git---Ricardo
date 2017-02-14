#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "MSOLE.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GEFR078v2 ³ Autor ³ J Ricardo Guimarães   ³ Data ³ 02.10.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Emitir relatório de ND em formato excel por intervalo de ND ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GEFR078v2()
/*/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Perguntas                      	    		      ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ mv_par01 - Número da ND               			  ³
³ mv_par02 - Série d ND  			  	   			  ³
* mv_par03 - Destino da Planilha                      *
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local cTitulo:= "Emssão de ND única - FAT V.2"
Local cDesc1 := "Este programa é destinado a imprmir ND no formato Excel, "
Local cDesc2 := "gerado pelo módulo Faturamento. "
Local cDesc3 := ""
Local cDesc4 := ""

Local nOpca
Local cCadastro
Local aSays  := {}, aButtons := {}

Private cPerg := PadR("GEFR78v2",LEN(SX1->X1_GRUPO))

criasx1()

AADD(aSays,OemToAnsi(cDesc1))
AADD(aSays,OemToAnsi(cDesc2))
AADD(aSays,OemToAnsi(cDesc3))
AADD(aSays,OemToAnsi(cDesc4))

Pergunte(cPerg,.F.)

nOpca := 0
cCadastro:=OemToAnsi(cTitulo)
AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T.)}})
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End()}})
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End()}})

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|lEnd| EmiteND()})
Endif

Return

/**************************************************************************|
| Função :  EmiteND |  Autor : J Ricardo Guimarães   | Data :  02.10.12    |
|**************************************************************************|
|Descrição   : Imprmir ND única gerada pelo módulo Faturamento             |
|            : 															   |
|            :                                                             |
|**************************************************************************|
| Sintaxe    : EmiteND()                                                   |
|**************************************************************************|
|Uso         :  Imprmir ND												   |
|**************************************************************************/

*-------------------------*
Static Function EmiteND()
*-------------------------*
Local _cScript     := ""
Local _cNDAnt      := ""
Local _cSerNDAnt   := ""

Private _cPastaExcel := GetNewPar("MV_XEXCEL","C:\PROTHEUS11\") // GETMV("MV_XEXCEL")
Private _cDrive  := GetNewPar("MV_XDRIVE","U:\") // DRIVE D$ NO CLIENT
Private nQtdItem := 0
Private _aItens  := {}
Private _cLin    := ""

Pergunte(cPerg,.F.)

If !File(_cPastaExcel+"SIGAEXCEL\Rezende.exe")
	MONTADIR(_cPastaExcel)
	MONTADIR(_cPastaExcel+"SIGAEXCEL") 				// lpassos subpasta e ajuste do nome SIGALEXCEL para SIGAEXCEL
	MONTADIR(_cPastaExcel+"SIGAEXCEL\Scripts")
	MONTADIR(_cPastaExcel+"SIGAEXCEL\Planilhas") 	// lpassos
	MONTADIR(_cPastaExcel+"Protheus_Data") 			// lpassos 
	MONTADIR(_cPastaExcel+"Protheus_Data\Modelo") 	// lpassos 
	CPYS2T("\system\Rezende.exe",_cPastaExcel+"SIGAEXCEL",.T. )
	CPYS2T("\Modelo\ModeloND.xls",_cPastaExcel+"Protheus_Data\Modelo",.T. ) // lpassos 
	
	If !File(_cPastaExcel+"SIGAEXCEL\Rezende.exe") 	// lpassos faltava SIGAEXCEL no path
		MsgAlert("Não foi possível instalar integração com Excel, verifique com o depto de TI")
		Return
	Endif
Endif

// Posiciono na ND
dbSelectArea("SF2") ; dbSetOrder(1)
If !dbSeek(xFilial("SF2")+MV_PAR01 + MV_PAR03,.T.)  // Posiciona ao registro próximo do procurado, caso este não seja encontrado
	MsgBox("ND não encontrada na base de dados! ","ND Inexistente","INFO")
	Return
EndIf


While !SF2->(Eof()) .AND. SF2->F2_FILIAL==cFilAnt .AND. SF2->F2_DOC >= MV_PAR01 .AND. SF2->F2_DOC <= MV_PAR02

   // Verico a Série
   If AllTrim(SF2->F2_SERIE) <> AllTrim(MV_PAR03)
		dbSelectArea("SF2") 
		dbSkip()
		Loop   
   EndIf
   
	// Posiciono no pedido da ND
	dbSelectArea("SC5") ; dbSetOrder(6)  // Nota + Serie
	dbSeek(xFilial("SC5") + SF2->F2_DOC + SF2->F2_SERIE)
	
	// Posiciono nos itens do pedido da ND
	dbSelectArea("SC6") ; dbSetOrder(1) 
	dbSeek(xFilial("SC6") + SC5->C5_NUM)
	ProcRegua(0) // Numero de registros a processar

	_aItens  := {}
		
	While SC6->C6_NUM == SC5->C5_NUM .AND. !SC6->(EOF())
		IncProc()
		AADD(_aItens, {SC6->C6_ITEM, SC6->C6_PRODUTO, SC6->C6_DESCRI, SC6->C6_XOBS, SC6->C6_VALOR})
		SC6->(dbSkip())
	End
	
	If Len(_aItens) = 0
		MsgBox("Existe inconsistência entre o pedido e o documento gerado.  Favor verificar o pedido " + SC5->C5_NUM,"ND Inexistente","INFO")
		dbSelectArea("SF2") 
		dbSkip()
		Loop
	EndIf
	
	// Início de montagem da planilha
	// define o nome do arquivo
	//_cScript := _cDrive+"SigaExcel\Scripts\NDScript.txt"
	_cScript := _cPastaExcel + "SIGAEXCEL\Scripts\NDScript-"+cFilAnt+"-ND-"+SF2->F2_DOC+".txt"
	If File(_cScript)
		fErase(_cScript)
	Endif
	
	_nHandle := FCreate(_cScript,0)
	If _nHandle == -1 .Or. !File(_cScript)
		MsgAlert("Arquivo [" + _cScript + "] nao pode ser criado corretamente. Verifique!")
		Return
	EndIf	
			
	// gera o arquivo em excel
	Processa({|| fScript()},"Gerando Script para Excel...")
			
	// define nome do arquivo
	//MontaDir(_cDrive+"SigaExcel\Planilhas")
	cPlan := _cPastaExcel + "SIGAEXCEL\Planilhas\ND-" + SF2->F2_FILIAL + "-" + SF2->F2_DOC + ".XLS"
	//cPlan := AllTrim(MV_PAR03) + "\ND-" + SF2->F2_FILIAL + "-" + SF2->F2_DOC + ".XLS"
			
	// exclui o arquivo caso exista
	If File(cPlan)
//		If MsgYesNo("Confirma exclusão do arquivo [" + cPlan + "] ?")
			fErase(cPlan)
//		Endif
	Endif
			
	// inclui no script do excel
	_xLin := "GravaArquivo|"+cPlan+"|"; fGrvLinha(_xLin,.F.)
	_xLin := "Imprime|1|"; fGrvLinha(_xLin,.F.)
	_xLin := "FechaExcel|"; fGrvLinha(_xLin,.F.)	
			
	// fecha o arquivo criado
	fClose(_nHandle)
			
	// chama rotina do Excel
	If !Empty(_cScript)
		WaitRun(_cPastaExcel+"SIGAEXCEL\rezende.Exe "+_cScript)
	
		fErase(_cScript)
		fErase(cPlan)		
	Else
		MsgAlert("Problema na geracao do arquivo de script...")
	Endif
	
	dbSelectArea("SF2")
	dbSkip()
End

Return

***************************
Static Function fScript()
***************************

// declaracao de variaveis
Private _aColunas := {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP","AQ","AR","AS","AT","AU","AV","AW","AX","AY","AZ"}
Private _nCol     := "000"

// abre o excel
_xLin := "AbreExcel|N|N|N|"; fGrvLinha(_xLin,.F.)
//_xLin := "AbreArquivo|" + _cDrive+"SigaExcel\Modelo\ModeloND.xls|";fGrvLinha(_xLin,.F.)
_xLin := "AbreArquivo|" + _cPastaExcel + "Protheus_Data\Modelo\ModeloND.xls|";fGrvLinha(_xLin,.F.)

// geracao de scritps
fSheet1() // planilha de parametros

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fSheet1
Local _nLin := 0
Local xOBS  := ""

// Transformado o caracter "," por Chr(247) devido a rotina Rezendo entender que vírgula é separador de comando.

// inicia planilha - escreve cabeçalho - Dados da Filial
_xLin := "RenomeiaSheet|1|ND|" ; fGrvLinha(_xLin,.F.)                  
_xLin := "Escreve|6|4|" + SM0->M0_NOME + "|1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|7|4|" + STRTRAN(AllTrim(SM0->M0_ENDENT),",",CHR(247)) + " - " + SM0->M0_COMPENT + "|1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|8|4|" + AllTrim(SM0->M0_CIDENT) + " - " + AllTrim(SM0->M0_ESTENT) + " - " + TransForm(SM0->M0_CEPENT,"@R 99.999-999") + " |1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|9|4|TEL.: " + SM0->M0_TEL + "|1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|10|4|FAX.: " + SM0->M0_FAX + "|1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|11|4|CNPJ: " + TRANSFORM(SM0->M0_CGC, "@R 99.999.999/9999-99") + "      Insc.Municipal: "+ AllTrim(SM0->M0_INSCM) + "     Insc. Estadual: " + SM0->M0_INSC + "|1|" ; fGrvLinha(_xLin,.F.)

// inicia planilha - escreve cabeçalho - Dados do cliente
// Posiciono no cliente
SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE + SF2->F2_LOJA))

_xLin := "Escreve|14|5|" + SF2->F2_CLIENTE + "|1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|14|7|" + SF2->F2_LOJA    + "|1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|15|5|" + SA1->A1_NOME    + "|1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|16|5|" + STRTRAN(SA1->A1_END,",",CHR(247)) + "|1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|17|5|" + SA1->A1_BAIRRO  + "|1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|18|5|" + SA1->A1_MUN     + "|1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|19|5|" + SA1->A1_EST     + "|1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|19|7|" + TRANSFORM(SA1->A1_CEP, "@R 99.999-9999") + "|1|"			; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|20|5|" + Transform(SA1->A1_CGC, "@R 99.999.999/9999-99") + "|1|" 	; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|21|5|" + SA1->A1_INSCR + "|1|" ; fGrvLinha(_xLin,.F.)

//_xLin := "Escreve|24|2|Local: " + AllTrim(SA1->A1_MUN) + " - " + SA1->A1_EST + "|1|"; fGrvLinha(_xLin,.F.)
//_xLin := "Escreve|24|7|'" + DTOC(SF2->F2_EMISSAO) + "|1|" ; fGrvLinha(_xLin,.F.)

_xLin := "Escreve|24|2|Local: " + AllTrim(SM0->M0_CIDENT) + " - " + SM0->M0_ESTENT + "|1|"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|24|7|'" + DTOC(SF2->F2_EMISSAO) + "|1|" ; fGrvLinha(_xLin,.F.)

_xLin := "Escreve|26|2|'Deve(mos) à " + AllTrim(SM0->M0_NOME)+CHR(247)+" estabelecida à " + STRTRAN(AllTrim(SM0->M0_ENDENT),",",CHR(247)) + " - " + SM0->M0_CIDENT + "|1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|27|2|'" + AllTrim(SM0->M0_CIDENT) + " - estado de " + SM0->M0_ESTENT + " - a importância demonstrada abaixo:|1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|30|2|" + SF2->F2_DOC + "|1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|30|4|" + AllTrim(SC5->C5_REFGEFC) + "|1|" ; fGrvLinha(_xLin,.F.)
_xLin := "Escreve|30|7|'"+ DTOC(POSICIONE("SE1",1,xFilial("SE1") + SF2->F2_PREFIXO + SF2->F2_DOC, "E1_VENCREA" )) + "|1|" ; fGrvLinha(_xLin,.F.) 

// Escreve itens
_nLin := 34
//_aItens{SC6->C6_ITEM, SC6->C6_PRODUTO, SC6->C6_DESCRI, SC6->C6_XOBS, SC6->C6_VALOR}
For _x:= 1 To Len(_aItens)
	_xLin := "Escreve|" + StrZero(_nLin+_x,3) + "|3|'" + _aItens[_x,01] + "|1|" ; fGrvLinha(_xLin,.F.)
	_xLin := "Escreve|" + StrZero(_nLin+_x,3) + "|4|" + IIF(!Empty(_aItens[_x,04]),_aItens[_x,04],_aItens[_x,03]) + "|1|" ; fGrvLinha(_xLin,.F.)
	_xLin := "Escreve|" + StrZero(_nLin+_x,3) + "|7|" + AllTrim(Str(_aItens[_x,05])) + "|1|" ; fGrvLinha(_xLin,.F.)
Next _x	

// Escreve Rodape       
xOBS	   := AllTrim(SC5->C5_XOBS)
xOBS 	   := StrTran(xOBS,CHR(13)," ") // Retira o Enter
xOBS 	   := StrTran(xOBS,CHR(10)," ") // Retira o Line Feed

_xLin := "Escreve|75|2|'" + AllTrim(xOBS) + "|1|" ; fGrvLinha(_xLin,.F.)
//_xLin := "Escreve|75|2|teste|1|" ; fGrvLinha(_xLin,.F.)
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fGrvLinha(_cLin)
_cLin += (CHR(13)+CHR(10))
fWrite(_nHandle,_cLin,Len(_cLin))
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CriaSX1   ³ Autor ³J Ricardo Guimarães    | Data ³02/10/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ajuste de Perguntas (SX1)                 			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CriaSX1()

_sAlias := Alias()																		
dbSelectArea("SX1")
dbSetOrder(1)
aRegs :={}

aAdd(aRegs,{cPerg,"01","Número de ND De  ?","Número da ND      ?","Número da ND     ?","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Número de ND Ate ?","Número de ND      ?","Séria da ND      ?","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Série da ND      ?","Série da ND       ?","Séria da ND      ?","mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"03","Local de Destino ?","Local de Destino  ?","Local de Destino ?","mv_ch3","C",30,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

Return()
