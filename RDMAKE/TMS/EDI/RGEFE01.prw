#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RGEFE01   �Autor  � Vin�cius Moreira   � Data � 07/04/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Recepciona arquivo de ocorr�ncias das transportadoras.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RGEFE01 ()

Private cDirBkp := GetMv("ES_EDIOBKP",,"\")
Private cNomArq := AllTrim (cGetFile("Todos Arquivos | *.*", "Sele��o de Arquivo" , 0 ,, .T. , GETF_LOCALHARD, .F.))

If !Empty(cNomArq)
	Processa({|| fProcArq() } , "Leitura de arquivo", "Iniciando processamento..." , .T. )	
EndIf

Return 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fProcArq �Autor  � Vin�cius Moreira   � Data � 07/04/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Processando leitura e grava��o do arquivo.                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fProcArq()

Local cLinha    := ""
Local cRegistro := ""
Local cMsg      := ""
Local l341      := .F.
Local l342      := .F.
Local aEstru    := {}
Local aTamSX3   := {}
Local cArqTmp   := ""
Local cCgcTra   := ""
Local cNomTra   := ""
Local cFilDoc   := ""
Local cDoc      := ""
Local cSerie    := ""
Local dDatOco   := ""
Local cHorOco   := ""
Local cOcoTra   := ""
Local cOcoEmb   := ""
Local aAuxArq   := {}

Private cAliasTmp := ""
Private cCliGen   := GetMv("MV_CLIGEN",,"")
Private nTamCod   := TamSx3("DE6_CODCLI")[1]
Private nTamLoj   := TamSx3("DE6_LOJCLI")[1]

If Empty(cCliGen)
	Help (" ", 1, "RGEFE0101",,"Cliente generico n�o encontrado.", 3, 0)
ElseIf !File(cNomArq)
	Help (" ", 1, "RGEFE0102",,"Arquivo n�o encontrado.", 3, 0)
Else
	ProcRegua(5)
	IncProc("Criando arquivo temporario.")
	cAliasTmp := GetNextAlias()
	
	//��������������������������������������������������������������Ŀ
	//�Documentos de Transporte                                      �
	//����������������������������������������������������������������		
	dbSelectArea("DT6")
	DT6->(dbSetOrder(1))//DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
	//��������������������������������������������������������������Ŀ
	//�Clientes                                                      �
	//����������������������������������������������������������������		
	dbSelectArea("SA2")
	SA2->(dbSetOrder(3))//A2_FILIAL+A2_CGC

	//��������������������������������������������������������������Ŀ
	//�Inicio - Estrutura do temporario de impress�o                 �
	//����������������������������������������������������������������	
	aTamSX3 := TamSx3("DUA_FILDOC")
	aAdd(aEstru, {"FILDOC", aTamSx3[3], aTamSx3[1], aTamSx3[2]})
	aTamSX3 := TamSx3("DUA_DOC")
	aAdd(aEstru, {"DOC"   , aTamSx3[3], aTamSx3[1], aTamSx3[2]})
	aTamSX3 := TamSx3("DUA_SERIE")
	aAdd(aEstru, {"SERIE" , aTamSx3[3], aTamSx3[1], aTamSx3[2]})	
	aTamSX3 := TamSx3("DUA_DATOCO")
	aAdd(aEstru, {"DATOCO" , aTamSx3[3], aTamSx3[1], aTamSx3[2]})
	aTamSX3 := TamSx3("DUA_HOROCO")
	aAdd(aEstru, {"HOROCO" , aTamSx3[3], aTamSx3[1], aTamSx3[2]})
	aTamSX3 := TamSx3("DUA_CODOCO")
	aAdd(aEstru, {"OCOTRA" , aTamSx3[3], aTamSx3[1], aTamSx3[2]})
	aAdd(aEstru, {"OCOEMB" , aTamSx3[3], aTamSx3[1], aTamSx3[2]})
	aAdd(aEstru, {"MSG", "C", 100, 0})
	//��������������������������������������������������������������Ŀ
	//�Fim - Estrutura do temporario de impress�o                    �
	//����������������������������������������������������������������		
	//���������������������������������������������������������Ŀ
	//� Cria o arquivo temporario								�
	//�����������������������������������������������������������
	cArqTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,"DBFCDX",cArqTmp,cAliasTmp,.F.)

	IncProc("Iniciando leitura do arquivo de ocorr�ncias.")
	FT_FUSE( cNomArq )
	FT_FGOTOP()
	While !FT_FEOF()
		cLinha := FT_FREADLN()
		If !Empty(cLinha)
			cRegistro := Left(cLinha, 3)
			//��������������������������������������������������������������������������������Ŀ
			//�Dados da Transportadora                                                         �
			//����������������������������������������������������������������������������������
			If cRegistro == "341"
				cCgcTra := SubStr(cLinha, 04, 14)// CGC Transportadora
				cNomTra := Capital(AllTrim(SubStr(cLinha, 18, 40)))//Raz�o Social
				
				If !SA2->(dbSeek(xFilial("SA2") + cCgcTra))
					cMsg := "Transportadora n�o encontrada." + CRLF
					cMsg += "C.G.C: " + Transform(cCgcTra, "@R 99.999.999/9999-99") + CRLF
					cMsg += "Nome : " + cNomTra 
					Aviso("ATEN��O",cMsg,{"OK"},1,"")
					Exit
				EndIf
				
				cMsg := "Confirma a recep��o das ocorr�ncias da transportadora abaixo?" + CRLF
				cMsg += "C.G.C: " + Transform(cCgcTra, "@R 99.999.999/9999-99") + CRLF
				cMsg += "Nome : " + cNomTra 
				If Aviso("ATEN��O",cMsg,{"Sim","N�o"},1,"") != 1
					Exit
				EndIf
				l341 := .T.
			//��������������������������������������������������������������������������������Ŀ
			//�Ocorr�ncia na Entrega                                                           �
			//����������������������������������������������������������������������������������	
			ElseIf cRegistro == "342"
				cFilDoc := cFilAnt
				cDoc    := PadL(Right(AllTrim(SubStr(cLinha, 50, 12)),9), 09, " ")
				cSerie  := PadL(Right(AllTrim(SubStr(cLinha, 45, 05)),3), 03, " ")
				dDatOco := cToD(SubStr(cLinha, 31, 02) + "\" + SubStr(cLinha, 33, 02) + "\" + SubStr(cLinha, 35, 04))
				cHorOco := SubStr(cLinha, 39, 04)
				cOcoTra := SubStr(cLinha, 29, 02)
				cOcoEmb := fGetOco(SA2->A2_COD, SA2->A2_LOJA, cOcoTra)
				
				If !DT6->(dbSeek(xFilial("DT6")+cFilDoc + cDoc + cSerie))
					cMsg := "Documento n�o encontrado."
				ElseIf Empty(cOcoEmb)
					cMsg := "Ocorr�ncia n�o encontrada no depara."
				ElseIf fChkDupli (cFilDoc, cDoc, cSerie, dDatOco, cHorOco, cOcoEmb)
					cMsg := "Ocorr�ncia j� foi gravada."
				EndIf
			
				fGrvTmp(cFilDoc, cDoc, cSerie, dDatOco, cHorOco, cOcoTra, cOcoEmb, cMsg)
				l342 := .T.
			EndIf
		EndIf
		
		cMsg := ""
		FT_FSKIP()
	EndDo
	FT_FUSE()
	(cAliasTmp)->(dbGoTop())
	
	If l341 .And. l342 .And. (cAliasTmp)->(!Eof())
		IncProc("Efetuando grava��o das informa��es na tabela de ocorr�ncias.")
		fGrvOcos (cAliasTmp)
		//���������������������������������������������������������Ŀ
		//� Copia o arquivo processado para diretorio de backup.    �
		//�����������������������������������������������������������			
		aAuxArq := Separa(cNomArq, "\")
		__CopyFile(cNomArq, cDirBkp+aAuxArq[Len(aAuxArq)])
		ProcExcel(cAliasTmp, SubStr(cNomArq, 1, At(".",cNomArq)-1) + "_LOG")
	EndIf

	//���������������������������������������������������������Ŀ
	//� Exclui arquivo temporario								�
	//�����������������������������������������������������������	
	(cAliasTmp)->(dbCloseArea())
	FErase(cArqTmp+GetDbExtension())
EndIf

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fGrvTmp  �Autor  � Vin�cius Moreira   � Data � 07/04/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava arquivo temporario para processamento.               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGrvTmp(cFilDoc, cDoc, cSerie, dDatOco, cHorOco, cOcoTra, cOcoEmb, cMsg)

RecLock(cAliasTmp, .T.)
	(cAliasTmp)->FILDOC := cFilAnt
	(cAliasTmp)->DOC    := cDoc
	(cAliasTmp)->SERIE  := cSerie
	(cAliasTmp)->DATOCO := dDatOco 
	(cAliasTmp)->HOROCO := cHorOco
	(cAliasTmp)->OCOTRA := cOcoTra
	(cAliasTmp)->OCOEMB := cOcoEmb
	(cAliasTmp)->MSG    := cMsg
(cAliasTmp)->(MsUnlock())

Return 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fGetOco  �Autor  � Vin�cius Moreira   � Data � 07/04/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Converte c�digo de ocorr�ncia da transportadora para o     ���
���          � c�digo da Gefco.                                           ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGetOco(cCodCli, cLojCli, cOcoTra)

Local cRet      := ""
Local cQuery    := ""
Local cAliasQry := GetNextAlias()

cQuery := "  SELECT " + CRLF 
cQuery += "    DE6.DE6_CODOCO CODOCO " + CRLF 
cQuery += "   FROM " + RetSqlName("DE6") + " DE6 " + CRLF 
cQuery += "  WHERE DE6.DE6_FILIAL = '" + xFilial("DE6") + "' " + CRLF 
cQuery += "    AND DE6.DE6_CODCLI = '" + cCodCli + "' " + CRLF 
cQuery += "    AND DE6.DE6_LOJCLI = '" + cLojCli + "' " + CRLF 
cQuery += "    AND DE6.DE6_OCOEMB = '" + cOcoTra + "' " + CRLF 
cQuery += "    AND DE6.D_E_L_E_T_ = ' ' " + CRLF 
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .T.)
If (cAliasQry)->(!Eof())
	cRet := (cAliasQry)->CODOCO
Else
	(cAliasQry)->(dbCloseArea())
	cQuery := "  SELECT " + CRLF 
	cQuery += "    DE6.DE6_CODOCO CODOCO " + CRLF 
	cQuery += "   FROM " + RetSqlName("DE6") + " DE6 " + CRLF 
	cQuery += "  WHERE DE6.DE6_FILIAL = '" + xFilial("DE6") + "' " + CRLF 
	cQuery += "    AND DE6.DE6_CODCLI = '" + SubStr(cCliGen, 1, nTamCod) + "' " + CRLF 
	cQuery += "    AND DE6.DE6_LOJCLI = '" + SubStr(cCliGen, nTamCod+1, nTamLoj) + "' " + CRLF 
	cQuery += "    AND DE6.DE6_OCOEMB = '" + cOcoTra + "' " + CRLF 
	cQuery += "    AND DE6.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .T.)
	cRet := (cAliasQry)->CODOCO
EndIf
(cAliasQry)->(dbCloseArea())

Return cRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fGrvOcos �Autor  � Vin�cius Moreira   � Data � 08/04/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava ocorr�ncias no DUA.                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGrvOcos (cAliasTmp)

Local aCabDUA := {}
Local aIteDUA := {}
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.
Private lWserver    := .T.

//-- Cabecalho das Ocorrencias
aAdd(aCabDUA, {"DUA_FILORI",Space(Len(DUA->DUA_FILORI)),NIL})
aAdd(aCabDUA, {"DUA_VIAGEM",Space(Len(DUA->DUA_VIAGEM)),NIL})

While (cAliasTmp)->(!Eof())
	If Empty((cAliasTmp)->MSG) .And. DT6->(dbSeek(xFilial("DT6")+(cAliasTmp)->(FILDOC+DOC+SERIE)))
		//-- Itens da Ocorrencia
		aAdd(aIteDUA, {;
			{"DUA_HOROCO", (cAliasTmp)->HOROCO , NIL},;
			{"DUA_DATOCO", (cAliasTmp)->DATOCO , NIL},;
			{"DUA_FILOCO", cFilAnt             , NIL},;
			{"DUA_CODOCO", (cAliasTmp)->OCOEMB , NIL},;
			{"DUA_SEQOCO", StrZero(1,Len(DUA->DUA_SEQOCO)), NIL},;
			{"DUA_RECEBE", ""                  ,NIL},;
			{"DUA_FILDOC", DT6->DT6_FILDOC     ,NIL},;
			{"DUA_DOC"   , DT6->DT6_DOC        ,NIL},;
			{"DUA_SERIE" , DT6->DT6_SERIE      ,NIL},;
			{"DUA_QTDOCO", If(DT6->DT6_QTDVOL == 0, 1, DT6->DT6_QTDVOL),NIL},;
			{"DUA_PESOCO", If(DT6->DT6_PESO   == 0, 1, DT6->DT6_PESO  ),NIL};
		})
		
		MsExecAuto({|x,y,z|Tmsa360(x,y,z)},aCabDUA,aIteDUA,{},3)	
		RecLock (cAliasTmp, .F.)
		If lMsErroAuto
			(cAliasTmp)->MSG := "Problemas durante a tentativa de executar o MsExecAuto."
		Else
			(cAliasTmp)->MSG := "Ocorr�ncia gravada com sucesso."
		EndIf
		(cAliasTmp)->(MsUnlock())
	EndIf	
	
	aIteDUA     := {}
	lMsErroAuto := .F.
	lMsHelpAuto := .T.
	(cAliasTmp)->(dbSkip())
EndDo

Return 
/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    �ProcExcel � Autor �                          � Data �   /  /   ���
����������������������������������������������������������������������������Ĵ��
���Descri��o �Abre os dados de um Alias no Excel                             ���
����������������������������������������������������������������������������Ĵ��
��� Uso      �Especifico                                                     ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/
Static  Function ProcExcel(cAlias, cArqTmp)

Local oExcelApp
Local cDirDocs   	:= MsDocPath()
Local aAuxDir       := Separa(cArqTmp, "\")
Local cNomArqDes 	:= aAuxDir[Len(aAuxDir)]
Local cPath			:= ""
Local nX            := 1

For nX := 1 to Len(aAuxDir)-1
	cPath += aAuxDir[nX] + "\"
Next nX

If !Empty(cPath)
	dbSelectArea( cAlias )
	
	Copy To &(cDirDocs+"\"+cNomArqDes+".XLS") VIA "DBFCDXADS"
	
	CpyS2T( cDirDocs+"\"+cNomArqDes+".XLS" , cPath, .T. )
	
	Ferase(cDirDocs+"\"+cArqTmp+".XLS")
	
	If ApOleClient( 'MsExcel' )
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cPath+cNomArqDes+".XLS" ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	Else
		MsgStop(OemToAnsi("Microsoft Excel N�o Instalado"))
	EndIf
EndIf

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fChkDupli �Autor  � Vin�cius Moreira   � Data � 08/04/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Checa se esta ocorr�ncia j� foi lan�ada.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fChkDupli (cFilDoc, cDoc, cSerie, dDatOco, cHorOco, cOcoEmb)

Local lRet      := .F.
Local cQuery    := ""
Local cAliasQry := GetNextAlias()

cQuery += "   SELECT " + CRLF 
cQuery += "     DUA.DUA_DOC " + CRLF 
cQuery += "    FROM " + RetSqlName("DUA") + " DUA " + CRLF 
cQuery += "   WHERE DUA.DUA_FILIAL = '" + xFilial("DUA") + "' " + CRLF 
cQuery += "     AND DUA.DUA_FILDOC = '" + cFilDoc + "' " + CRLF 
cQuery += "     AND DUA.DUA_DOC    = '" + cDoc    + "' " + CRLF 
cQuery += "     AND DUA.DUA_SERIE  = '" + cSerie  + "' " + CRLF 
cQuery += "     AND DUA.DUA_CODOCO = '" + cOcoEmb + "' " + CRLF 
cQuery += "     AND DUA.DUA_DATOCO = '" + dToS(dDatOco) + "' " + CRLF 
cQuery += "     AND DUA.DUA_HOROCO = '" + cHorOco + "' " + CRLF 
cQuery += "     AND DUA.D_E_L_E_T_ = ' ' " + CRLF 
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .T.)
lRet := (cAliasQry)->(!Eof())
(cAliasQry)->(dbCloseArea())

Return lRet