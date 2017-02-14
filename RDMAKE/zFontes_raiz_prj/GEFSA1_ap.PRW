#include "rwmake.ch"  

User Function GEFSA1()

SetPrvt("HINI,HFIM,PROCTIME,_CCDPGTO,_CCODIGO,_CENDER")
SetPrvt("_CCEP,_CCGC,_CIE,_CCONTATO,_CFRETE,_CZONA")
SetPrvt("_CVEND,_DVENCLC,_DULCOMP,_CCANAL,_NLIMCRD,_CTPPG")
SetPrvt("_CTABELA,_CEXCLUS,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GEFSA1  ³ Autor ³ Saulo Muniz            ³ Data ³ 30.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Importacao                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Utilizacao³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

If !File("\sigaadv\tab.dbf")
   MsgInfo("Diretorio / Arquivo nao localizado"+CHR(13)+"Abandonando ...")
   Return(.f.)
Else
	
	HIni := TIME()
	
	use \sigaadv\tab.dbf New Exclusive Alias CLI
	Index on CLI->A1_COD to codcli.ntx
	
	DbSelectArea("CLI")
	DbSetOrder(1)
	ProcRegua(RecCount())
	
EndIf

If MsgBox ("Atualiza cadastro de Clientes ?","A T E N C A O","YESNO")
	Processa( { ||CLIENT() } )
	HFim := TIME()
	PROCTIME := ElapTime(HIni,HFim)
	MsgStop(PROCTIME)
EndIf

*--------------------------------------------------------------------------------*
Static Function CLIENT()
*--------------------------------------------------------------------------------*
// Variaveis
//
  xCateg := " "
  xIdent := " "
  xDesc  := " "


DbSelectArea("CLI")
DbSetOrder(1)
DbGoTop()

While ! EOF()

   IncProc()
	
	_cCodigo := Alltrim(CLI->A1_COD)
	_cLoja   := Alltrim(CLI->A1_LOJA)
    _cCodGer := Substr(Alltrim(CLI->COD),1,3)	   
	_Ident   := Alltrim(CLI->IDENT)	   
	
	Do Case	
		Case Alltrim(CLI->CODGER) == "Ventes Hors Groupe PSA"
			_cCateg   := "1"
		Case Alltrim(CLI->CODGER) == "Ventes Groupe GEFCO"
			_cCateg   := "2"
		Case Alltrim(CLI->CODGER) == "Ventes Groupe PSA Consolidé"
			_cCateg   := "3"
		OtherWise
			_cCateg   := "4"
	EndCase
	
	DbselectArea("SA1")
	DbSetOrder(1)
    DbGoTop()
    If !Dbseek(xFilial("SA1")+_cCodigo+_cLoja)
       DbSelectArea("CLI")
       DbSkip()
       Loop
    EndIf	
	
	DbSelectArea("SA1")
	RecLock("SA1",.F.)	
	Replace  A1_GEFCAT1 with _cCateg     ,;
	         A1_GEFIDEN with _Ident  	 ,;
             A1_CODGER  with _cCodGer
	
	MsUnlock()	
	DbSelectArea("CLI")
	DbSkip()
	   
EndDo

DbSelectArea("CLI")
DbCloseArea()
fErase("codcli.ntx")

Return(.t.)