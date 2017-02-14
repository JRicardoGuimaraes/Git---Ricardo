/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEFEST01  º Autor ³ Saulo Muniz        º Data ³  17/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao de notas de entrada                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEFCO LOGISTICA DO BRASIL                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "tbiconn.ch"
#include 'Ap5Mail.ch'

USER FUNCTION GEFEST01()
Private oProcess := NIL
oProcess := MsNewProcess():New({|lEnd| GEFEST01A(lEnd,oProcess)},"Processando","Lendo...",.T.)
oProcess:Activate()
Return Nil


STATIC FUNCTION GEFEST01A(lEnd,oObj)

Local cDir,cTes,cCond,cProd

Local cCta,cCC,cItemCta,cClas,cNat,cRecebe

Local aFiles, nFiles, nI
Local cBuffer  := ""

Local nOpc := 3
Local cUM, cChave, cDocto, cSerie, cFornec, cLoja, dEmissao, lOk, cNewArq
Local nValorTotal, nPercentualICMS, nBaseICMS, nValorICMS
Local cNatFor, cArq, nLinha
Local aLinha:={}, aItens:={}

Private cServer,cAccount,cPassword

Private lMsErroAuto := .F.
Private CRLF := Chr(13) + Chr(10)
Private lFirstLog := .T.
Private lTemLog := .F.


//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "EST" TABLES ;
//"SB1","SE4","SF4","CT1","SI1","CTT","SI3","CTD","SID","CTH","SED","SA2","SF1"

ConOut("")
ConOut("Inicio da Leitura da Importacao das notas de entrada " + Dtoc( MsDate() ) + " - " + Time() )
ConOut("")

cDir     := AllTrim(GETMV("MV_CTRDIR"))
cTes     := AllTrim(GETMV("MV_CTRTES"))
cCond    := AllTrim(GETMV("MV_CTRCOND"))
cProd    := AllTrim(GETMV("MV_CTRPROD"))

cCta     := AllTrim(GETMV("MV_CTRCTA"))  // Conteudo Opcional
cCC      := AllTrim(GETMV("MV_CTRCC"))   // Conteudo Opcional
cItemCta := AllTrim(GETMV("MV_CTRITEM")) // Conteudo Opcional
cClas    := AllTrim(GETMV("MV_CTRCLAS")) // Conteudo Opcional
cNat     := AllTrim(GETMV("MV_CTRNAT"))  // Conteudo Opcional
cRecebe  := AllTrim(GETMV("MV_CTRMAIL")) // email do destinatario da mensagem

cServer   := Trim(GetMV("MV_RELSERV")) // smtp.ig.com.br ou 200.181.100.51
cAccount  := Trim(GetMV("MV_RELACNT")) // fulano@ig.com.br
cPassword := Trim(GetMV("MV_RELPSW"))  // 123abc

If Empty(cDir) .or. Empty(cTes) .or. Empty(cProd) .or. Empty(cCond)
	WLog("Cadastre (o)s parametro(s) MV_CTRDIR, MV_CTRTES, MV_CTRPROD, MV_CTRCOND")
	Return .t.
Endif

If Empty(cServer) .or. Empty(cAccount) .or. Empty(cPassword) .or. Empty(cRecebe)
	WLog("Não foi definido os parâmetros do server do Protheus para envio de e-mail")
	Return .t.
Endif

Dbselectarea("SB1")
Dbsetorder(1)
If !DbSeek(xFilial("SB1")+cProd)
	WLog("Produto informado no parametro MV_CTRPROD nao cadastrado")
	Return .t.
Else
	cUM := SB1->B1_UM
Endif

Dbselectarea("SE4")
Dbsetorder(1)
If !DbSeek(xFilial("SE4")+cCond)
	WLog("Condicao de pagamento informada no parametro MV_CTRCOND nao cadastrada")
	Return .t.
Endif

Dbselectarea("SF4")
Dbsetorder(1)
If !DbSeek(xFilial("SF4")+cTes)
	WLog("TES informado no parametro MV_CTRTES nao cadastrado")
	Return .t.
Endif

If !Empty(cCTA)
	If CtbInUse()
		Dbselectarea("CT1")
		Dbsetorder(1)
		If !DbSeek(xFilial("CT1")+cCTA)
			WLog("Conta Contabil informada no parametro MV_CTRCTA nao cadastrada")
			Return .t.
		Endif
	Else
		Dbselectarea("SI1")
		Dbsetorder(1)
		If !DbSeek(xFilial("SI1")+cCTA)
			WLog("Conta Contabil informada no parametro MV_CTRCTA nao cadastrada")
			Return .t.
		Endif
	Endif
Endif

If !Empty(cCC)
	If CtbInUse()
		Dbselectarea("CTT")
		Dbsetorder(1)
		If !DbSeek(xFilial("CTT")+cCC)
			WLog("Centro de custo informado no parametro MV_CTRCC nao cadastrado")
			Return .t.
		Endif
	Else
		Dbselectarea("SI3")
		Dbsetorder(1)
		If !DbSeek(xFilial("SI3")+cCC)
			WLog("Centro de custo informado no parametro MV_CTRCC nao cadastrado")
			Return .t.
		Endif
	Endif
Endif

If !Empty(cItemCta)
	If CtbInUse()
		Dbselectarea("CTD")
		Dbsetorder(1)
		If !DbSeek(xFilial("CTD")+cItemCta)
			WLog("Item contabil informado no parametro MV_CTRITEM nao cadastrado")
			Return .t.
		Endif
	Else
		Dbselectarea("SID")
		Dbsetorder(1)
		If !DbSeek(xFilial("SID")+cItemCta)
			WLog("Item contabil informado no parametro MV_CTRITEM nao cadastrado")
			Return .t.
		Endif
	Endif
Endif

If !Empty(cClas)
	If CtbInUse()
		Dbselectarea("CTH")
		Dbsetorder(1)
		If !DbSeek(xFilial("CTH")+cClas)
			WLog("Classe de valor informada no parametro MV_CTRCLAS nao cadastrada")
			Return .t.
		Endif
	Endif
Endif

If !Empty(cNat)
	Dbselectarea("SED")
	Dbsetorder(1)
	If !DbSeek(xFilial("SED")+cNat)
		WLog("Natureza informada no parametro MV_CTRNAT nao cadastrada")
		Return .t.
	Endif
Endif

If Right(cDir,1) != "\"
	cDir := cDir + "\"
Endif

aFiles := Directory(cDir+"*.CTR")

nFiles := Len(aFiles)
lOk	:= .T.

oObj:SetRegua1(nFiles)		//primeira regua

For nI := 1 to nFiles
	If lEnd
		Exit
	Endif
	oObj:IncRegua1("Lendo Arquivo: "+aFiles[nI][1])
	cArq := AllTrim(cDir)+aFiles[nI][1]
	aRetorno := ValidaArquivo( cArq, lEnd )
	If !aRetorno[1] .OR. aRetorno[3]
		GravaComErro( cArq )
		Loop
	Endif
	oObj:SetRegua2(aRetorno[2])		//segunda regua
	cFornec := ""
	cLoja   := ""
	cCondFor:= ""
	nLinha  := 0
	FT_FUSE( cArq )
	FT_FGOTOP()
	
	While !FT_FEOF()
		
		cBuffer := FT_FREADLN()		//joga o conteudo da linha na variavel
		nLinha++
		oObj:IncRegua2("Lendo Linha: "+str(nLinha,5))	//incrementa segunda regua
		
		If lEnd
			Exit
		Endif
		
		If Substr(cBuffer,01,01) == "0"
			Dbselectarea("SA2")
			Dbsetorder(3)
			DbSeek(xFilial("SA2")+Substr(cBuffer,02,14))
			cFornec := SA2->A2_COD
			cLoja   := SA2->A2_LOJA
			cCondFor:= SA2->A2_COND
			cNatFor := SA2->A2_NATUREZ
		Endif
		
		If Substr(cBuffer,01,01) == "1"
			
			cDocto := Substr(cBuffer,02,06)
			cSerie := Substr(cBuffer,08,03)
			
			cChave := cDocto + cSerie + cFornec + cLoja
			
			Dbselectarea("SF1")
			Dbsetorder(1)
			If DbSeek(xFilial("SF1")+cChave)
				FT_FSKIP()
				Loop
			Endif
			
			dEmissao := Ctod(Substr(cBuffer,58,2)+"/"+;
			Substr(cBuffer,60,2)+"/"+;
			Substr(cBuffer,62,4))
			
			aCab := {{"F1_TIPO" ,"N"													  	  ,NIL},;
			{"F1_FORMUL"    ,"N"															  ,NIL},;
			{"F1_DOC"		,cDocto								,NIL},;
			{"F1_SERIE"		,cSerie								,NIL},;
			{"F1_EMISSAO"	,dEmissao							,NIL},;
			{"F1_FORNECE"	,cFornec 							,NIL},;
			{"F1_LOJA"	    ,cLoja								,NIL},;
			{"F1_ESPECIE"	,"CTR"								,NIL},;
			{"F1_COND" 	    ,If(!Empty(cCondFor),cCondFor,cCond),NIL}}
			
			If !Empty( cNat ) .or. !Empty( cNatFor )
				AADD(aCab,{"CNATUREZA",If(!Empty(cNatFor),cNatFor,cNat),NIL})
			Endif
			
			nValorTotal    := Val(Left(Substr(cBuffer,11,14),12)+"."+Right(Substr(cBuffer,11,14),2))
			nPercentualICMS:= Val(Left(Substr(cBuffer,25,5),3)+"."+Right(Substr(cBuffer,25,5),2))
			nBaseICMS      := Val(Left(Substr(cBuffer,30,14),12)+"."+Right(Substr(cBuffer,30,14),2))
			nValorICMS	   := Val(Left(Substr(cBuffer,44,14),12)+"."+Right(Substr(cBuffer,44,14),2))
			
			aItens:={}
			aLinha:={}
			
			AADD(aLinha,{"D1_COD"	 ,cProd			 ,NIL})
			AADD(aLinha,{"D1_UM"	 ,cUM			 ,NIL})
			AADD(aLinha,{"D1_QUANT"	 ,1	  			 ,NIL})
			AADD(aLinha,{"D1_VUNIT"	 ,nValorTotal    ,NIL})
			AADD(aLinha,{"D1_TOTAL"	 ,nValorTotal	 ,NIL})
			AADD(aLinha,{"D1_TES"	 ,cTes			 ,NIL})
			AADD(aLinha,{"D1_PICM"	 ,nPercentualICMS,NIL})
			AADD(aLinha,{"D1_LOCAL"	 ,"01"			 ,NIL})
			AADD(aLinha,{"D1_BASEICM",nBaseICMS	     ,NIL})
			AADD(aLinha,{"D1_VALICM" ,nValorICMS	 ,NIL})
			
			If !Empty( cCta )
				AADD(aLinha,{"D1_CONTA",cCta		 ,NIL})
			Endif
			
			If !Empty( cItemCta )
				AADD(aLinha,{"D1_ITEMCTA",cItemCta	 ,NIL})
			Endif
			
			If !Empty( cCC )
				AADD(aLinha,{"D1_CC",cCC			 ,NIL})
			Endif
			
			If !Empty( cClas )
				AADD(aLinha,{"D1_CLVL",cClas		 ,NIL})
			Endif
			
			AADD(aLinha,{"AUTDELETA" ,"N",NIL})
			
			AADD(aItens,aLinha)
			
			lMsErroAuto := .F.
			lMsHelpAuto := .T.
			begin transaction
			MSExecAuto({|x,y,z| MATA103(x,y,z)},aCab,aItens,nOpc)
			end transaction
			If lMsErroAuto
				WLog("Conhecimento de Frete "+cDocto+" "+cSerie+" Fornec. "+cFornec+" Arquivo: "+cArq+" nao foi importado verifique se os campos gravados estao na ordem da tela e tambem os campos obrigatorios")
				lOk := .F.
			Endif
		Endif
		
		FT_FSKIP()
		
	EndDo
	
	FT_FUSE()
	
	If lOk
		GravaSemErro( cArq )
	Else
		GravaComErro( cArq )
	Endif
	
Next

//RESET ENVIRONMENT

If lTemLog
	Email(cRecebe)
Endif

ConOut("Final da Leitura da Importacao de Conhecimento de Frete " + Dtoc( MsDate() ) + " - " + Time() )
ConOut("")


Return .t.





STATIC FUNCTION ValidaArquivo(cArquivo, lEnd)
Local cBuffer  := ""
Local cChave, cDocto, cSerie, cFornec, cLoja, lOk, nX, nRegistros
Local cValorTotal, cPercentualICMS, cBaseICMS, cValorICMS, cDia, cMes, cAno

lOk	:= .T.
cFornec := ""
cLoja   := ""
nRegistros := 0

If !File(cArquivo)
	WLog("Arquivo "+cArquivo+" nao existe.")
	Return {.F., nRegistros, lEnd}
Endif

FT_FUSE(cArquivo)
FT_FGOTOP()

While !FT_FEOF()
	
	If lEnd
	   Exit
	Endif   
	
	cBuffer := FT_FREADLN()		//joga o conteudo da linha na variavel
	
	If Substr(cBuffer,01,01) == "0"
		Dbselectarea("SA2")
		Dbsetorder(3)
		If !DbSeek(xFilial("SA2")+Substr(cBuffer,02,14))
			WLog("Arquivo: "+cArquivo+" Fornecedor "+Substr(cBuffer,02,14)+" nao cadastrado")
			lOk	:= .F.
		Else
			cFornec := SA2->A2_COD
			cLoja   := SA2->A2_LOJA
		Endif
	Endif
	
	If Substr(cBuffer,01,01) == "1"
		
		cDocto := Substr(cBuffer,02,06)
		cSerie := Substr(cBuffer,08,03)
		
		cChave := cDocto + cSerie + cFornec + cLoja
		
		Dbselectarea("SF1")
		Dbsetorder(1)
		If DbSeek(xFilial("SF1")+cChave)
			WLog("Arquivo: "+cArquivo+" Conhecimento "+cDocto+" Serie "+cSerie+" Fornec. "+cFornec+" Loja "+cLoja+" ja cadastrado" )
		Endif
		
		cValorTotal    := Substr(cBuffer,11,14)
		nTam := Len( cValorTotal )
		For nX := 1 to nTam
			If !(Substr( cValorTotal, nX, 1 ) $ "01234567890")
				WLog("Arquivo: "+cArquivo+" Valor total deve ser numerico")
				lOk := .F.
			Endif
		Next nX
		
		cPercentualICMS:= Substr(cBuffer,25,5)
		nTam := Len( cPercentualICMS )
		For nX := 1 to nTam
			If !(Substr( cPercentualICMS, nX, 1 ) $ "01234567890")
				WLog("Arquivo: "+cArquivo+" Percentual do ICMS deve ser numerico")
				lOk := .F.
			Endif
		Next nX
		
		cBaseICMS      := Substr(cBuffer,30,14)
		nTam := Len( cBaseICMS )
		For nX := 1 to nTam
			If !(Substr( cBaseICMS, nX, 1 ) $ "01234567890")
				WLog("Arquivo: "+cArquivo+" Base de ICMS deve ser numerica")
				lOk := .F.
			Endif
		Next nX
		
		cValorICMS      := Substr(cBuffer,44,14)
		nTam := Len( cValorICMS )
		For nX := 1 to nTam
			If !(Substr( cValorICMS, nX, 1 ) $ "01234567890")
				WLog("Arquivo: "+cArquivo+" Valor do ICMS deve ser numerico")
				lOk := .F.
			Endif
		Next nX
		
		cDia := Substr(cBuffer,58,2)
		If Val(cDia) < 1 .or. Val(cDia) > 31
			WLog("Arquivo: "+cArquivo+" Conhecimento "+cDocto+" Serie "+cSerie+" Fornec. "+cFornec+" Loja "+cLoja+" Dia da data de emissao inválido: "+cDia)
			lOk := .F.
		Endif
		cMes := Substr(cBuffer,60,2)
		If Val(cMes) < 1 .or. Val(cMes) > 12
			WLog("Arquivo: "+cArquivo+" Conhecimento "+cDocto+" Serie "+cSerie+" Fornec. "+cFornec+" Loja "+cLoja+" Mes da data de emissao inválido: "+cMes)
			lOk := .F.
		Endif
		cAno := Substr(cBuffer,62,4)
		If Val(cAno) < 1980 .or. Val(cAno) > 2049
			WLog("Arquivo: "+cArquivo+" Conhecimento "+cDocto+" Serie "+cSerie+" Fornec. "+cFornec+" Loja "+cLoja+" Ano da data de emissao inválido: "+cAno)
			lOk := .F.
		Endif
	Endif
	
	nRegistros++
	
	FT_FSKIP()
	
EndDo

FT_FUSE()

Return {lOk, nRegistros, lEnd}

STATIC FUNCTION GravaComErro( cArquivo )

cNewArq := StrTran( UPPER( cArquivo ), ".CTR", ".ERR" )
FRename( cArquivo, cNewArq )

Return


STATIC FUNCTION GravaSemErro( cArquivo )

cNewArq := StrTran( UPPER( cArquivo ), ".CTR", ".OK" )
FRename( cArquivo, cNewArq )

Return


STATIC FUNCTION WLog(cMensagem)

LOCAL cFileLog := ""
LOCAL cPath := ""

If lFirstLog
	
	AutoGrLog(" ")
	AutoGrLog("LOG DE IMPORTACAO DE Conhecimento de frete")
	AutoGrLog("------------------------------------------")
	AutoGrLog("ARQUIVO DE LOG.....: "+NomeAutoLog())
	AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
	AutoGrLog("DATA...............: "+Dtoc(MsDate()))
	AutoGrLog("HORA...............: "+Time())
	AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
	AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath",""))
	AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath",""))
	AutoGrLog("VERSÃO.............: "+GetVersao())
	AutoGrLog("MÓDULO.............: "+"SIGA"+cModulo)
	AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
	AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
	AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
	AutoGrLog("USUÁRIO............: "+SubStr(cUsuario,7,15))
	AutoGrLog(" ")
	
	lFirstLog := .F.
	
Endif

AutoGrLog(cMensagem)
ConOut(cMensagem)
lTemLog := .T.

RETURN


STATIC FUNCTION Email(cRecebe)

Local lConectou, lEnviado
Local cAnexo := GetSrvProfString("Startpath","")+NomeAutoLog()

cMensagem := 'Favor verificar arquivo de log de importacao de ' + CRLF +;
'conhecimento de frete anexo '+NomeAutoLog()+" "+Dtoc(MsDate())

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

If !lConectou
	WLog("Nao consegui conectar com o server para envio de e-mail")
	Return
Endif

SEND MAIL FROM cAccount;
TO cRecebe;
SUBJECT 'Workflow - Importacao de Conhecimento de Frete' ;
BODY cMensagem ;
ATTACHMENT cAnexo;
RESULT lEnviado

If !lEnviado
	GET MAIL ERROR cMensagem
	WLog("Nao consegui enviar o e-mail do log de importacao de conhecimentos de frete"+ CRLF + cMensagem)
Endif
DISCONNECT SMTP SERVER Result lDisConectou

If !lDisConectou
	WLog("Nao consegui desconectar com o servidor de e-mail "+cServer)
Endif

Return

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³StartFreight ³ Autor ³ Marinaldo de Jesus ³ Data ³21/11/2001³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Start do Processo de WorkFlow                               ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³u_StartFreight 												³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³															³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Importacao conhecimento de frete                          	³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Observacao³Essa Funcao devera ser Incluida no .INI do Server          	³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
User Function StartCtrc()

Local aEmpFil := Array( 02 )

aEmpFil[ 01 ] := "99"	//Codigo da Empresa conforme SIGAMAT
aEmpFil[ 02 ] := "01"	//Codigo da Filial  conforme SIGAMAT

Return( wfStart( aEmpFil ) )
