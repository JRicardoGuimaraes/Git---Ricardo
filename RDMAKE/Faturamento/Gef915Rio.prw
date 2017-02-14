#INCLUDE "Mata915.ch"
#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Mata915   �Autor  �Mary C. Hergert     � Data � 03/07/2006  ���
�������������������������������������������������������������������������͹��
���Desc.     �Le o arquivo de retorno da Prefeitura Municipal de Rio de   ���
���          �Janeiro, referente as informacoes da Nota Fiscal Eletronica.���
���          �Legislacao:                                                 ���
���          �Adaptado por Ricardo - Em: 08/09/2010 - Para atender NF-e   ���
���          �Carioca                                                     ���
�������������������������������������������������������������������������͹��
���Uso       �SigaFis                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Gef915Rio()

Local aArqTmp	:= {}
Local aCarga	:= {}

Local cTitulo	:= ""
Local cErro		:= ""
Local cSolucao	:= ""
Local cCampos	:= ""     

Local lCarga 	:= .F.

Local oReport
                      
If SF1->(FieldPos("F1_NFELETR")) == 0
	cCampos +=  "F1_NFELETR - "
Endif
If SF1->(FieldPos("F1_EMINFE")) == 0
	cCampos +=  "F1_EMINFE - "
Endif
If SF1->(FieldPos("F1_HORNFE")) == 0
	cCampos += "F1_HORNFE - "
Endif
If SF1->(FieldPos("F1_CODNFE")) == 0
	cCampos += "F1_CODNFE - "
Endif
If SF1->(FieldPos("F1_CREDNFE")) == 0
	cCampos += "F1_CREDNFE - "
Endif
If SF2->(FieldPos("F2_NFELETR")) == 0
	cCampos += "F2_NFELETR - "
Endif
If SF2->(FieldPos("F2_EMINFE")) == 0
	cCampos += "F2_EMINFE - "
Endif
If SF2->(FieldPos("F2_HORNFE")) == 0
	cCampos += "F2_HORNFE - "
Endif
If SF2->(FieldPos("F2_CODNFE")) == 0
	cCampos += "F2_CODNFE - "
Endif
If SF2->(FieldPos("F2_CREDNFE")) == 0
	cCampos += "F2_CREDNFE - "
Endif
If SF3->(FieldPos("F3_NFELETR")) == 0
	cCampos += "F3_NFELETR - "
Endif
If SF3->(FieldPos("F3_EMINFE")) == 0
	cCampos += "F3_EMINFE - "
Endif
If SF3->(FieldPos("F3_HORNFE")) == 0
	cCampos += "F3_HORNFE - "
Endif
If SF3->(FieldPos("F3_CODNFE")) == 0
	cCampos += "F3_CODNFE - "
Endif
If SF3->(FieldPos("F3_CREDNFE")) == 0
	cCampos += "F3_CREDNFE - "
Endif
If AliasIndic("SFT")
	If SFT->(FieldPos("FT_NFELETR")) == 0
		cCampos += "FT_NFELETR - "
	Endif
	If SFT->(FieldPos("FT_EMINFE")) == 0
		cCampos += "FT_EMINFE - "
	Endif
	If SFT->(FieldPos("FT_HORNFE")) == 0
		cCampos += "FT_HORNFE - "
	Endif
	If SFT->(FieldPos("FT_CODNFE")) == 0
		cCampos += "FT_CODNFE - "
	Endif
	If SFT->(FieldPos("FT_CREDNFE")) == 0
		cCampos += "FT_CREDNFE - "
	Endif
Endif
					
//���������������������������������������������������������������
//�Somente efetua o processamento se todas as implementacoes da �
//�Nota Fiscal Eletronica tiverem sido feitas.                  �
//���������������������������������������������������������������
If AliasIndic("SFT") .And. Empty(cCampos)
	If Mta915Wiz()	   
		//������������������������������������������������������������������Ŀ
		//�Carrega no arquivo temporario as informacoes do arquivo de retorno�
		//��������������������������������������������������������������������
		Processa({|| aCarga := Mta915Le(@aArqTmp)})
		lCarga := aCarga[01]   
		If lCarga
			//����������������������������������������������Ŀ
			//�Atualiza tabelas com as informacoes do retorno�
			//������������������������������������������������
			Processa({|| Mta915Atu(aCarga[02])})
			 
			//����������������������������������������������������Ŀ
			//�Imprime o relatorio de conferencia no release 3 e 4 �
			//������������������������������������������������������
			If FindFunction("TRepInUse") .And. TRepInUse()
				//������������������������������������������������������������������������Ŀ
				//�Interface de impressao                                                  �
				//��������������������������������������������������������������������������
				oReport := ReportDef()
				oReport:PrintDialog()
			Else
				Mta915R3()
			EndIf
		Else
			cTitulo 	:= STR0028		//"Importa��o n�o realizada"	
			cErro		:= STR0029		//"A importa��o do arquivo de retorno n�o foi realizada "
			cErro		+= STR0030		//"por n�o existirem informa��es de retorno no arquivo "
			cErro		+= STR0031		//"texto informado. "
			cSolucao	:= STR0032		//"Verifique se o arquivo de retorno informado nas "
			cSolucao	+= STR0033		//"perguntas da rotina � o enviado pela prefeitura "
			cSolucao	+= STR0034		//"e processe esta rotina novamente."
			xMagHelpFis(cTitulo,cErro,cSolucao)
		Endif
		//�������������������������������������Ŀ
		//�Excluindo o arquivo temporario criado�
		//���������������������������������������
		dbSelectArea(aArqTmp[1,2])
		dbCloseArea()
		Ferase(aArqTmp[1,1]+GetDBExtension())
		Ferase(aArqTmp[1,1]+OrdBagExt())
	Endif
Else
	cTitulo 	:= STR0018 				//"Implementa��o n�o efetuada"	
	cErro		:= STR0019 				//"A implementa��o do processo da Nota "
	cErro		+= STR0020 				//"Fiscal Eletr�nica n�o foi efetuada corretamente, "
	cErro		+= STR0021 				//"visto que existem tabelas e campos que "
	cErro		+= STR0022 				//"n�o est�o dispon�veis no dicion�rio de dados."
	If !AliasIndic("SFT")
		cErro		+= STR0026 			//"Tabela SFT "
	Endif
	cErro		+= STR0027 + cCampos 	//"Campos: "
	cSolucao	:= STR0023 				//"verifique a documenta��o que acompanha a rotina e "
	cSolucao	+= STR0024 				//"execute todos os procedimentos indicados e processe "
	cSolucao	+= STR0025 				//"esta rotina novamente."
	xMagHelpFis(cTitulo,cErro,cSolucao)
Endif

Return(.T.)

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �Mta915Wiz   �Autor  �Mary C. Hergert     � Data � 03/07/2006  ���
���������������������������������������������������������������������������͹��
���Desc.     �Monta a wizard com as perguntas a rotina de importacao        ���
���          �                                                              ���
���������������������������������������������������������������������������͹��
���Uso       �Mata915                                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function Mta915Wiz()

//������������������������Ŀ
//�Declaracao das variaveis�
//��������������������������
Local aTxtPre 		:= {}
Local aPaineis 		:= {}

Local cTitObj1		:= ""                
Local cMask			:= Replicate("X",245)
	
Local nPos			:= 0
	
Local lRet			:= 0
	
//�����������������������������������������Ŀ
//�Monta wizard com as perguntas necessarias�
//�������������������������������������������
aAdd(aTxtPre,STR0001) //"Importa��o da Nota Fiscal Eletr�nica"
aAdd(aTxtPre,STR0002) //"Aten��o"
aAdd(aTxtPre,STR0003) //"Preencha corretamente as informa��es solicitadas."
aAdd(aTxtPre,STR0004+STR0005+STR0006)	//"Esta rotina ira importar o arquivo de retorno disponibilizado pela        "
										//"Prefeitura Municipal de S�o Paulo, contendo informa��es sobre as notas     "
										//"fiscais eletr�nicas geradas no per�odo."

//�������������������������������������Ŀ
//�Painel 1 - Informacoes da Empresa    �
//���������������������������������������
aAdd(aPaineis,{})
nPos :=	Len(aPaineis)
aAdd(aPaineis[nPos],STR0007) //"Assistente de parametriza��o" 
aAdd(aPaineis[nPos],STR0008) //"Informa��es sobre o arquivo de retorno: "
aAdd(aPaineis[nPos],{})

cTitObj1 :=	STR0009 //"Arquivo de retorno: "
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{1,cTitObj1,,,,,,})
aAdd(aPaineis[nPos][3],{2,"",cMask,1,,,,245,,.T.})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})
aAdd(aPaineis[nPos][3],{0,"",,,,,,})

lRet :=	xMagWizard(aTxtPre,aPaineis,"MTA915")
	
Return(lRet)   

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �Mta915Tmp   �Autor  �Mary C. Hergert     � Data � 03/07/2006  ���
���������������������������������������������������������������������������͹��
���Desc.     �Cria o arquivo temporario para importacao                     ���
���          �                                                              ���
���������������������������������������������������������������������������͹��
���Uso       �Mata915                                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function Mta915Tmp()

Local aArqNFE	:= {}                                 
Local aArqTmp	:= {}
Local cArqNFE	:= ""

AADD(aArqNFE,{"NFE"			,"C",TamSX3("FT_NFELETR")[1],0})
AADD(aArqNFE,{"EMISSAO"		,"D",8,0})
AADD(aArqNFE,{"HORA"		,"C",6,0})
AADD(aArqNFE,{"VERIFICA"	,"C",TamSX3("FT_CODNFE")[1],0})
AADD(aArqNFE,{"RPS"			,"C",TamSX3("FT_NFISCAL")[1],0})
AADD(aArqNFE,{"SERIE"		,"C",TamSX3("FT_SERIE")[1],0})
AADD(aArqNFE,{"VALSERV"		,"N",TamSX3("FT_VALCONT")[1],TamSX3("FT_VALCONT")[2]}) 
AADD(aArqNFE,{"ALIQUOTA"	,"N",TamSX3("FT_ALIQICM")[1],TamSX3("FT_ALIQICM")[2]})
AADD(aArqNFE,{"VALISS"		,"N",TamSX3("FT_VALICM")[1],TamSX3("FT_VALICM")[2]}) 
AADD(aArqNFE,{"VALCRED"		,"N",TamSX3("FT_CREDNFE")[1],TamSX3("FT_CREDNFE")[2]}) 
AADD(aArqNFE,{"CLIENTE"		,"C",TamSX3("A1_COD")[1],0}) 
AADD(aArqNFE,{"LOJA"		,"C",TamSX3("A1_LOJA")[1],0}) 
AADD(aArqNFE,{"IMPORT"		,"C",1,0}) 
AADD(aArqNFE,{"ERRO"		,"C",145,0}) 
AADD(aArqNFE,{"CODISS"		,"C",TamSX3("F3_CODISS")[1],0}) 
AADD(aArqNFE,{"SITUACAO"	,"C",1,0}) 
cArqNFE	:=	CriaTrab(aArqNFE)
dbUseArea(.T.,__LocalDriver,cArqNFE,"NFE")
IndRegua("NFE",cArqNFE,"RPS+SERIE")

aArqTmp := {{cArqNFE,"NFE"}}

Return(aArqTmp)

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �Mta915Le    �Autor  �Mary C. Hergert     � Data � 03/07/2006  ���
���������������������������������������������������������������������������͹��
���Desc.     �Le arquivo de retorno da prefeitura e carrega o arquivo       ���
���          �temporario para atualizar as tabelsas.                        ���
���������������������������������������������������������������������������͹��
���Uso       �Mata915                                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function Mta915Le(aArqTmp)

Local aWizard		:= {}
	
Local lRet			:= !xMagLeWiz("MTA915",@aWizard,.T.)
	
Local cArqProc		:= Alltrim(aWizard[01][01])
Local cTitulo		:= ""
Local cErro			:= ""
Local cSolucao		:= ""
Local cLinha		:= ""

Local lCarga		:= .F.   
Local lArqValido	:= .F.

Local nTamRPS		:= TamSX3("FT_NFISCAL")[1]
Local nTamSer		:= TamSX3("FT_SERIE")[1]
Local nTamISS		:= TamSX3("FT_CODISS")[1]

//���������������������������������������������
//�Cria o arquivo temporario para a importacao�
//���������������������������������������������
aArqTmp := Mta915TMP()                                  

//����������������������������������������������������
//�Verifica se o arquivo existe no diretorio indicado�
//����������������������������������������������������
If File(cArqProc) .And. !lRet

	nHandle	:=	FOpen(cArqProc)
	nTam	:=	Int(FSeek(nHandle,0,2)/600)
	FClose(nHandle)
	ProcRegua(nTam)	

	FT_FUse(cArqProc)
	FT_FGotop()
	
	//������������������������������������������������������������������Ŀ
	//�Verifica se o arquivo aberto e um arquivo de retorno da prefeitura�
	//��������������������������������������������������������������������
	lArqValido := .F.
	While (!FT_FEof())       
		FT_FSkip()
		cLinha := FT_FREADLN()
		// If (SubStr(cLinha,1,1) == "2" .And. (Alltrim(SubStr(cLinha,40,5)) == "RPS" .Or. Alltrim(SubStr(cLinha,40,5)) == "RPS-M")) .Or. (SubStr(cLinha,1,1) == "3" .And. Alltrim(SubStr(cLinha,40,5)) == "RPS-C")
		If SubStr(cLinha,1,1) == "2" .And. Alltrim(SubStr(cLinha,42,1)) $ "0|1|2" // Tipo de RPS - Tipos: 0-RPS, 1-RPS-M, 2-RPS-C
			lArqValido := .T.
		Endif             
		Exit
	Enddo

	If lArqValido 
		FT_FGotop()
		While (!FT_FEof()) 
		
			IncProc()
			
			cLinha := FT_FREADLN()      
			
			//�����������������������������������������������������Ŀ
			//�Apenas utiliza os registro 2 (RPS) e 3 (cupom fiscal)�
			//�������������������������������������������������������
			If SubStr(cLinha,1,1) $ "23"                             

				RecLock("NFE",.T.)                   
				NFE->NFE		:= SubStr(cLinha,10,8)
				NFE->EMISSAO	:= sTod(SubStr(cLinha,28,8))
				NFE->HORA		:= SubStr(cLinha,36,6)
				NFE->VERIFICA	:= SubStr(cLinha,19,8)
				NFE->RPS		:= Right(SubStr(cLinha,48,15),nTamRPS)
				NFE->SERIE		:= Left(SubStr(cLinha,43,5),nTamSer)
				NFE->VALSERV	:= Val(SubStr(cLinha,1380,15)) / 100
				NFE->ALIQUOTA	:= Val(SubStr(cLinha,1375,5)) / 100
				NFE->VALISS		:= Val(SubStr(cLinha,1530,15)) / 100
				NFE->VALCRED	:= Val(SubStr(cLinha,1545,15)) / 100
				NFE->CODISS		:= Right(SubStr(cLinha,1355,20),nTamISS)
				NFE->SITUACAO	:= IIF(SubStr(cLinha,18,1)=="2","C","N")
				
				//������������������������������������������������������
				//�Buscando o cliente para qual foi emitido o documento�
				//������������������������������������������������������
				SF2->(dbSetOrder(1))
				If SF2->(dbSeek(xFilial("SF2")+NFE->RPS+NFE->SERIE))
					NFE->CLIENTE	:= SF2->F2_CLIENTE
					NFE->LOJA		:= SF2->F2_LOJA
				Endif
				
				MsUnLock()		
				lCarga := .T.
			Endif		
	
			FT_FSkip()
		Enddo         
	Else
		lCarga := .F.
	Endif	
	FT_FUse()
	FClose(nHandle)
Else 
	cTitulo 	:= STR0011 						//"Arquivo de importa��o n�o localizado"	
	cErro		:= STR0012 + cArqProc			//"N�o foi localizado no diret�rio "
	cErro		+= STR0013 + STR0014 	        //" o arquivo "," indicado nas perguntas "
	cErro		+= STR0015 						//"da rotina."
	cSolucao	:= STR0016 						//"Informe o diret�rio e o nome do arquivo "
	cSolucao	+= STR0017 						//"corretamente e processe a rotina novamente."
	xMagHelpFis(cTitulo,cErro,cSolucao)
	lCarga := .F.
Endif

Return({lCarga,cArqProc})

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �Mta915Wiz   �Autor  �Mary C. Hergert     � Data � 03/07/2006  ���
���������������������������������������������������������������������������͹��
���Desc.     �Atualiza tabelas do Protheus com as informacoes retornadas    ���
���          �pela Prefeitura Municipal de Sao Paulo.                       ���
���������������������������������������������������������������������������͹��
���Uso       �Mata915                                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/                                                                                                    
Static Function Mta915Atu(cCarga)

Local aAreaNFE	:= {}
Local aErro		:= {}
Local aNFE		:= {}

Local cChave	:= ""             
Local cErro		:= ""	
Local cCodISS	:= ""

Local lSF3 		:= .F.
Local lImpNFE	:= ExistBlock("MTIMPNFE")
Local lCodISS	:= .F.

Local nX		:= 0

ProcRegua(NFE->(LastRec()))

NFE->(dbGoTop())
Do While !(NFE->(Eof()))

	IncProc()
	//���������������������������������������������������������������Ŀ
	//�Verifica se encontra todos os documentos que serao atualizados:�
	//�SF2, SF3 e SFT. Caso nao encontre, nao sera atualizado.        �
	//�����������������������������������������������������������������
	lSF3 		:= .F.    
	lCodISS		:= .T.
	cErro		:= ""
	cCodISS		:= ""
	aErro		:= {}
	
	//������������������������������������������Ŀ
	//�SF2 - cabecalho das notas fiscais de saida�
	//��������������������������������������������
	// Notas fiscais canceladas nao possuem SF2
	If NFE->SITUACAO <> "C"
		SF2->(dbSetOrder(1))
		If !SF2->(dbSeek(xFilial("SF2")+NFE->RPS+NFE->SERIE))
			//"N�o foi encontrado o cabe�alho (SF2) do documento. Filial: , RPS: e s�rie: . Verifique se o arquivo est� sendo importado na filial correta."
			Aadd(aErro,STR0063 + xFilial("SF2") + STR0066 )
		Endif
	Endif
	
	//������������������Ŀ
	//�SF3 - livro Fiscal�
	//��������������������
	SF3->(dbSetOrder(4))              
	cChave := xFilial("SF3")+NFE->CLIENTE+NFE->LOJA+NFE->RPS+NFE->SERIE
	If SF3->(dbSeek(xFilial("SF3")+NFE->CLIENTE+NFE->LOJA+NFE->RPS+NFE->SERIE))

		Do While cChave == xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE .And. !SF3->(Eof())
			//������������������������������������������������������������������������Ŀ
			//�Verifica se o codigo do ISS no arq. de retorno e o mesmo do livro fiscal�
			//��������������������������������������������������������������������������
            /*
			If Val(NFE->CODISS) <> Val(SF3->F3_CODISS)
				cCodISS := SF3->F3_CODISS
				lCodISS := .F.
				SF3->(dbSkip())
				Loop
			Endif
			*/   
			lCodISS := .T.
			//�������������������������������������������������������������������������������������������Ŀ
			//�Verifica se a aliquota e o valor do ISS estao diferentes para atualizar conforme o retorno.�
			//���������������������������������������������������������������������������������������������
			If Left(SF3->F3_CFO,1) >= "5"
				lSF3 := .T.                     
				/*
				If SF3->F3_VALICM <> NFE->VALISS
					//"ISS no arq. de retorno: diverge do gravado nas notas fiscais: "
					Aadd(aErro,STR0067 + Alltrim(Transform(NFE->VALISS,"@E 9,999,999.99")) + STR0068 + Alltrim(Transform(SF3->F3_VALICM,"@E 9,999,999.99")))
				Endif 
				If SF3->F3_ALIQICM <> NFE->ALIQUOTA
					//"Al�quota no arq. de retorno: diverge da gravada nas notas fiscais: "
					Aadd(aErro,STR0069 + Alltrim(Transform(NFE->ALIQUOTA,"@E 99.99")) + STR0070 + Alltrim(Transform(SF3->F3_ALIQICM,"@E 99.99")))
				Endif
				Exit
				*/
			Endif 
			SF3->(dbSkip())
		Enddo                           
	Else  
		lSF3 := .F.	
	Endif 

	If !lCodIss      
		//"O c�digo do ISS gravado no livro fiscal (SF3) diverge do arquivo de retorno"
		Aadd(aErro,STR0071 + Alltrim(cCodISS) + STR0072 + Alltrim(Str(Val(NFE->CODISS))))
	Endif
	
	If !lSF3
		//"N�o foi localizado o registro no livro fiscal (SF3). Verifique se o c�digo do ISS e o cliente da NF-e correspondem com os do RPS emitido."		
		Aadd(aErro,STR0073)
	Endif

	//��������������������������������Ŀ
	//�Atualizando tabelas posicionadas�
	//����������������������������������
	If Len(aErro) == 0
    
		SF3->(dbSeek(xFilial("SF3")+NFE->CLIENTE+NFE->LOJA+NFE->RPS+NFE->SERIE))		
		
		Begin Transaction

			// Notas fiscais canceladas nao possuem SF2
			If NFE->SITUACAO <> "C"
				RecLock("SF2",.F.)
				SF2->F2_NFELETR	:= NFE->NFE
				SF2->F2_EMINFE	:= NFE->EMISSAO
				SF2->F2_HORNFE	:= NFE->HORA
				SF2->F2_CODNFE	:= NFE->VERIFICA
				SF2->F2_CREDNFE	:= NFE->VALCRED
				MsUnLock()
			Endif
	
			RecLock("SF3",.F.)
			SF3->F3_NFELETR	:= NFE->NFE
			SF3->F3_EMINFE	:= NFE->EMISSAO
			SF3->F3_HORNFE	:= NFE->HORA
			SF3->F3_CODNFE	:= NFE->VERIFICA
			SF3->F3_CREDNFE	:= NFE->VALCRED
			MsUnLock()

    	End Transaction
    	
		//���������������������������������Ŀ
		//�Atualizando todos os itens do SFT�
		//�����������������������������������
		SFT->(dbSetOrder(1))              
		cChave := xFilial("SFT")+"S"+NFE->SERIE+NFE->RPS+NFE->CLIENTE+NFE->LOJA
		If SFT->(dbSeek(xFilial("SFT")+"S"+NFE->SERIE+NFE->RPS+NFE->CLIENTE+NFE->LOJA))
			Do While cChave == xFilial("SFT")+"S"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA .And. !SFT->(Eof())
				If Val(NFE->CODISS) <> Val(SFT->FT_CODISS)
					SFT->(dbSkip())
					Loop
				Endif            
				
				Begin Transaction
					RecLock("SFT",.F.)
					SFT->FT_NFELETR	:= NFE->NFE
					SFT->FT_EMINFE	:= NFE->EMISSAO
					SFT->FT_HORNFE	:= NFE->HORA
					SFT->FT_CODNFE	:= NFE->VERIFICA
					SFT->FT_CREDNFE	:= NFE->VALCRED
					MsUnLock()

					RecLock("NFE",.F.)
					NFE->IMPORT	:= "1"
					MsUnLock()

				End Transaction
				SFT->(dbSkip())
			Enddo      
		Endif
    	
		//����������������������������������������������Ŀ
		//�Se tiver o campo E1_NFELETR de nota fiscal 	 �
		//�eletronica, grava o numero da NFe gerada na 	 �
		//�prefeitura tambem no titulo (SE1)		 	 �		
		//������������������������������������������������
		// Se tiver o campo E1_NFELETR de nota fiscal eletronica, grava o numero da NFe gerada na prefeitura tambem no titulo (SE1)
		If (SE1->(FieldPos("E1_NFELETR")) > 0)
			If !Empty(SF2->F2_NFELETR)
				dbSelectArea("SE1")
				dbSetOrder(2)  // E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
				MsSeek(xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DOC))  
			
				While !Eof() .And. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DOC)	              
					RecLock("SE1",.F.)
					SE1->E1_NFELETR := SF2->F2_NFELETR
					MsUnlock()
						
					dbSkip()
				Enddo	     
			
			Endif
		EndIf

		//����������������������������������������������Ŀ
		//�Se houve algum erro na atualizacao das tabelas�
		//������������������������������������������������
    	If Empty(NFE->IMPORT)
			RecLock("NFE",.F.)
			NFE->IMPORT	:= "1"
			NFE->ERRO	:= STR0039 //"N�o foi poss�vel efetuar a grava��o, tente novamente."
			MsUnLock()
		Endif
		
		//�����������������������������������������������Ŀ
		//�Ponto de entrada apos a importacao de cada NF-e�
		//�������������������������������������������������
		aAreaNFE := NFE->(GetArea())
		If lImpNFE
			Execblock("MTIMPNFE",.F.,.F.,{cCarga}) 		
		Endif       
		RestArea(aAreaNFE)      
		                             
	Else
		For nX := 1 to Len(aErro)
			// Para criar mais de uma linha caso exista mais de um erro por RPS	
			Aadd(aNFE,{NFE->RPS,NFE->SERIE,NFE->CLIENTE,NFE->LOJA,NFE->NFE,NFE->VALISS,NFE->IMPORT,aErro[nX]})
		Next
	Endif
	NFE->(dbSkip())
Enddo

//������������������������������������������������������������������Ŀ
//�Cria registros na tabela temporaria com todos os erros de cada RPS�
//��������������������������������������������������������������������
For nX := 1 to Len(aNFE)     
	NFE->(dbSetOrder(1))
	If NFE->(dbSeek(aNFE[nX][01]+aNFE[nX][02])) .And. Empty(NFE->ERRO)
		RecLock("NFE",.F.)
		NFE->ERRO		:= aNFE[nX][08]
		NFE->IMPORT		:= "2"
		MsUnLock()              
	Else
		RecLock("NFE",.T.)
		NFE->RPS 		:= aNFE[nX][01]
		NFE->SERIE		:= aNFE[nX][02]
		NFE->CLIENTE	:= aNFE[nX][03]
		NFE->LOJA		:= aNFE[nX][04]
		NFE->NFE		:= aNFE[nX][05]
		NFE->VALISS		:= aNFE[nX][06]
		NFE->IMPORT		:= aNFE[nX][07]
		NFE->ERRO		:= aNFE[nX][08]
		NFE->IMPORT		:= "3"
		MsUnLock()              
	Endif
Next

Return(.T.)	

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �ReportDef   �Autor  �Mary C. Hergert     � Data � 03/07/2006  ���
���������������������������������������������������������������������������͹��
���Desc.     �Imprime um relatorio de conferencia com os dados importados e ���
���          �os que nao foram importados por algum erro - Release 4        ���
���������������������������������������������������������������������������͹��
���Uso       �Mata915                                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/                                                                                                    
Static Function ReportDef()

Local aOrdem 	:= {}

Local oReport
Local oImport
Local oTotal                                

//�����������������������Ŀ
//�Componente de impressao�
//�������������������������
oReport := TReport():New("GEF915RIO",STR0051,"MTA915", {|oReport| ReportPrint(oReport)},STR0052) // "Relat�rio de confer�ncia de importa��o da Nota Fiscal Eletr}onica - S�o Paulo","Este programa ir� apresentar uma listagem com o resultado da importa��o do retorno da Nota Fiscal Eletr�nica"
oReport:HideParamPage()

//������������������������������Ŀ
//�Secao 1 Impressao da Listagem �
//��������������������������������
oImport := TRSection():New(oReport,STR0051,{"NFE"},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/) // "Relat�rio de confer�ncia de importa��o da Nota Fiscal Eletr}onica - S�o Paulo"
oImport:SetHeaderSection(.T.) 
oImport:SetReadOnly()
TRCell():New(oImport,"RPS"		,"NFE",STR0037 /*"N�mero RPS"*/,/*Picture*/,TamSX3("FT_NFISCAL")[1],/*lPixel*/,/*{|| codblock de impressao }*/)
TRCell():New(oImport,"SERIE"	,"NFE",STR0038 /*"S�rie"*/,/*Picture*/,TamSX3("FT_SERIE")[1],/*lPixel*/,/*{|| codblock de impressao }*/)
TRCell():New(oImport,"CLIENTE"	,"NFE",STR0053 /*"Cliente"*/,/*Picture*/,TamSX3("A1_COD")[1],/*lPixel*/,/*{|| codblock de impressao }*/)
TRCell():New(oImport,"LOJA"		,"NFE",STR0054 /*"Loja"*/,/*Picture*/,TamSX3("A1_LOJA")[1],/*lPixel*/,/*{|| codblock de impressao }*/)
TRCell():New(oImport,"NFE"		,"NFE",STR0055 /*"NF-e"*/,/*Picture*/,TamSX3("FT_NFELETR")[1],/*lPixel*/,/*{|| codblock de impressao }*/)
TRCell():New(oImport,"VALISS"	,"NFE",STR0056 /*"Valor ISS"*/,PesqPict("SFT","FT_VALICM"),TamSX3("FT_VALICM")[1],/*lPixel*/,/*{|| codblock de impressao }*/)
TRCell():New(oImport,"IMPORT"	,"NFE",STR0057 /*"Status"*/,/*Picture*/,10,/*lPixel*/,{|| Iif(NFE->IMPORT == "1",STR0048,STR0049) })
TRCell():New(oImport,"ERRO"		,"NFE",STR0058 /*"Mensagem de Erro"*/,/*Picture*/,110,/*lPixel*/,/*{|| codblock de impressao }*/)

oTotal := TRFunction():New(oImport:Cell("RPS"),Nil,"COUNT",/*oBreak2*/,STR0061,"9999999999",/*uFormula*/,.F.,.T.) // "Total de documentos importados sem erro: "
oTotal:SetCondition({ || NFE->IMPORT == "1" })
oTotal := TRFunction():New(oImport:Cell("RPS"),Nil,"COUNT",/*oBreak2*/,STR0062,"9999999999",/*uFormula*/,.F.,.T.) // "Total de documentos n�o importados:      "
oTotal:SetCondition({ || NFE->IMPORT == "2" })

Return(oReport)

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �ReportPrint �Autor  �Mary C. Hergert     � Data � 03/07/2006  ���
���������������������������������������������������������������������������͹��
���Desc.     �Impressao do detalhe do relatorio de conferencia no Release 4 ���
���������������������������������������������������������������������������͹��
���Uso       �Mata915                                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/                                                                                                    
Static Function ReportPrint(oReport)                     

Local cChave := ""

//����������������������������������������Ŀ
//�Regua de Processamento                  �
//������������������������������������������
oReport:SetMeter(NFE->(LastRec()))
oReport:Section(1):Init()      

NFE->(dbGoTop())

Do While !NFE->(Eof())
	If cChave == NFE->RPS+NFE->SERIE+NFE->CLIENTE+NFE->LOJA
		oReport:Section(1):Cell("RPS"):Hide()
		oReport:Section(1):Cell("SERIE"):Hide()
		oReport:Section(1):Cell("CLIENTE"):Hide()
		oReport:Section(1):Cell("LOJA"):Hide()
		oReport:Section(1):Cell("NFE"):Hide()
		oReport:Section(1):Cell("VALISS"):Hide()
		oReport:Section(1):Cell("IMPORT"):Hide()           
	Else
		oReport:Section(1):Cell("RPS"):Show()
		oReport:Section(1):Cell("SERIE"):Show()
		oReport:Section(1):Cell("CLIENTE"):Show()
		oReport:Section(1):Cell("LOJA"):Show()
		oReport:Section(1):Cell("NFE"):Show()
		oReport:Section(1):Cell("VALISS"):Show()
		oReport:Section(1):Cell("IMPORT"):Show()
		cChave := NFE->RPS+NFE->SERIE+NFE->CLIENTE+NFE->LOJA
	Endif

	oReport:Section(1):PrintLine() 	
	oReport:IncMeter()
	
	NFE->(dbSkip())

Enddo

oReport:Section(1):Finish()

Return Nil

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �Mta915R3    �Autor  �Mary C. Hergert     � Data � 03/07/2006  ���
���������������������������������������������������������������������������͹��
���Desc.     �Imprime um relatorio de conferencia com os dados importados e ���
���          �os que nao foram importados por algum erro - Release 3        ���
���������������������������������������������������������������������������͹��
���Uso       �Mata915                                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/                                                                                                    
Static Function Mta915R3()

Local Titulo      	:= OemToAnsi(STR0040)	//"Impress�o da listagem de confer�ncia - NF-e"
Local cDesc1      	:= OemToAnsi(STR0041)	//"Este programa ira emitir uma listagem de confer�ncia com o resultado "
Local cDesc2      	:= OemToAnsi(STR0042)	//"da importa��o da Nota Fiscal Eletr�nica, apresentando os documentos "
Local cDesc3      	:= OemToAnsi(STR0043)	//"importados e poss�veis erros na importa��o."
Local cString     	:= "SFT"
Local lDic        	:= .F. 					// Habilita/Desabilita Dicionario
Local lComp       	:= .F. 					// Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro     	:= .F. 					// Habilita/Desabilita o Filtro
Local wnrel       	:= "GEF915RIO" 			// Nome do Arquivo utiLizado no Spool
Local nomeprog    	:= "GEF915RIO"			// nome do programa
Local nPagina     	:= 0

Private Tamanho 	:= "G" 					// P/M/G
Private Limite  	:= 220 					// 80/132/220
Private aOrdem  	:= {}  					// Ordem do Relatorio
//Private cPerg   	:= ""  					// Pergunta do Relatorio
Private aReturn 	:= { STR0043, 1,STR0044, 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"

Private lEnd    	:= .F.					// Controle de cancelamento do relatorio
Private m_pag   	:= 1  					// Contador de Paginas
Private nLastKey	:= 0  					// Controla o cancelamento da SetPrint e SetDefault

//����������������������������������������������������������������������Ŀ
//�Envia para a SetPrint                                                 �
//������������������������������������������������������������������������
wnrel := SetPrint("",NomeProg,"",@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	dbClearFilter()
	Return
Endif
SetDefault(aReturn,cString)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| nPagina := Mta915Det(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

//��������������������������������������������������������������Ŀ
//� Restaura Ambiente                                            �
//����������������������������������������������������������������
dbSelectArea(cString)
dbClearFilter()
Set Device To Screen
Set Printer To
		
If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return(.T.)

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �Mta915R3    �Autor  �Mary C. Hergert     � Data � 03/07/2006  ���
���������������������������������������������������������������������������͹��
���Desc.     �Impressao do detalhe do relatorio de conferencia no Release 3 ���
���������������������������������������������������������������������������͹��
���Uso       �Mata915                                                       ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/                                                                                                    
Static Function Mta915Det(lEnd,wnRel,cString,nomeprog,Titulo)

Local cCabec1	:= STR0047  //"N�mero RPS  S�rie  Cliente  Loja  NF-e            Valor ISS  Status     Mensagem de Erro"
Local cCabec2	:= ""
Local cChave	:= ""
Local nLin		:= 60
Local nImport	:= 0
Local nErro		:= 0

NFE->(dbGoTop())
dbSelectArea("NFE")
SetRegua(LastRec()) 

While !lEnd .And. !NFE->(Eof())

	If nLin > 55
		nLin := Cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,18)
	Endif
	
	nLin++
	
	If cChave <> NFE->RPS+NFE->SERIE+NFE->CLIENTE+NFE->LOJA
		@nLin, 000 PSay NFE->RPS
		@nLin, 012 PSay NFE->SERIE
		@nLin, 019 PSay NFE->CLIENTE
		@nLin, 028 PSay NFE->LOJA
		@nLin, 034 PSay NFE->NFE
		@nLin, 043 PSay Transform(NFE->VALISS,"@E 9,999,999,999.99")

		cChave := NFE->RPS+NFE->SERIE+NFE->CLIENTE+NFE->LOJA

		If NFE->IMPORT == "1"
			@nLin, 061 PSay STR0048 //"Importado"
			nImport += 1
		Else
			@nLin, 061 PSay STR0049 //"Erro"
			@nLin, 072 PSay NFE->ERRO
			nErro += 1
		Endif
	Else
		If NFE->IMPORT <> "1"
			@nLin, 072 PSay NFE->ERRO
		Endif
	Endif

	NFE->(dbSkip())

Enddo             

If nImport + nErro > 0

	nLin++
	@nLin,000 Psay Repli("-",Limite)                        
    nLin++
    
	If nLin > 55
		nLin := Cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,15)
		nLin++
	Endif    
	
	@nLin, 000 PSay STR0059 + Str(nImport,10) // "Total de documentos importados sem erro: "
	nLin++
	@nLin, 000 PSay STR0060 + Str(nErro,10) // "Total de documentos n�o importados:      "
	
Endif

Return(.T.)

