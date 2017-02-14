#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
/******************************************************************************************************************
* Programa: Funcoes.prw                     Data: 02/10/2013     Auto: Ricardo Guimarães                          *
* Objetivo: Funções genéricas utilizadas em diversos pontos do Protheus                                           *
*                                                                                                                 *
/******************************************************************************************************************/

****************************************************
* Por: Ricardo Guimarães     Em: 02/10/2013        *
* Objetivo: Retorna o prefixo do CT-e usado ple UO *
****************************************************
User Function fPrefixo(_cFilial, _cCC) 
Local _cPrefixo := Space(TamSX3("E1_PREFIXO")[1])
                        
If AllTrim(Left(_cCC,3)) $ (AllTrim(GETMV("MV_XTLACC")))
	If _cFilial == "03" 
		_cPrefixo := "CTV"
	Else	
		_cPrefixo := "CTA"
	EndIf
ElseIf AllTrim(Left(_cCC,3)) $ AllTrim(GETMV("MV_XOVLCC"))
		_cPrefixo := "CTR"
ElseIf AllTrim(Left(_cCC,3)) $ AllTrim(GETMV("MV_XOVSCC"))
		_cPrefixo := "CTR"		
EndIf

Return _cPrefixo            

****************************
User Function fUserCom()
// Lista os usuários que efetuaram entradas por Compras
Local _cChave := ""
Local _cQry   := ""
Local cIndexSF1:= "" 
Local nIndexSF1:= 0
Local cChaveSF1:= "F1_FILIAL + F1_DOC + F1_SERIE"
Local _cUser   := ""
Local _aUser   := {}
Local _nPos := 0
Local _cMsg := ""
Local _cEOF := Chr(13)+Chr(10)

dbSelectArea("SF1") ; dbSetOrder(1)
cIndexSF1 := CriaTrab(nil,.f.)
//IndRegua("SF1",cIndexSF1,cChaveSF1,,"F1_FILIAL = '01' .AND. DTOS(F1_EMISSAO) >= '20130901' .AND. DTOS(F1_EMISSAO) <= '20130930'","Aguarde... Filtro SF1")
IndRegua("SF1",cIndexSF1,cChaveSF1,,"DTOS(F1_EMISSAO) >= '20130901' .AND. DTOS(F1_EMISSAO) <= '20130930'","Aguarde... Filtro SF1")
nIndexSF1 := RetIndex("SF1")
//dbSetIndex(cIndexSF1+OrdBagExt())
dbSetOrder(nIndexSF1+1)
//dbSeek(xFilial("SF1"))


/*
If dbSeek("03"+"000044261"+"5  "+"UNIGI "+"00")
	//ALERT(EMBARALHA("F1_USERLGI",1))
	ALERT(FWLEUSERLG("F1_USERLGI"))
EndIf	
*/

//_cQry := "Select * from sf1010 where f1_filial='01' and f1_emissao >= '20130901' and f1_emissao <= '20130930' "
//TCQUERY _cQry Alias "TSF1" New

ProcRegua(LastRec())

dbGoTop()
While !Eof()        
	IncProc()
	// ALERT(FWLEUSERLG("SF1->F1_USERLGI"))
   	// nPos:=aScan(aPrint, {|aVal| aVal[1] == ALLTRIM(TSZO->ZO_UO) .and. aVal[2] == allTrim(TSZO->ZO_CONTA)})
   	_cUser   := FWLEUSERLG("SF1->F1_USERLGI")
   	_nPos := aScan(_aUser, {|aVal|aVal[1] == SF1->F1_FILIAL .AND. aVal[2] == ALLTRIM(_cUser)})
	If _nPos > 0
		_aUser[_nPos,4] += 1
	Else	
		AADD(_aUser, {SF1->F1_FILIAL, _cUser, UPPER(U_FRetNUser(AllTrim(_cUser))), 1 })
	EndIf	
	dbSkip()
End

_cMsg := "LOJA;USUARIO;NOME USUARIO;QTD.NOTAS" + _cEof
For _n := 1 To Len(_aUser)
	_cMsg += _aUser[_n,1] + ";" + _aUser[_n,2] + ";" + _aUser[_n,3] + ";" + Str(_aUser[_n,4]) + _cEof
Next _n

MEMOWRIT("U:\TEMP\ENTRADAS_USER.CSV",_cMsg)

Alert("Gerado")

dbClearFilter()
fErase( cIndexSF1 + OrdBagExt() )	//Deletando arquivo de trabalho*/
Return

****************************
User Function fUserFat()
// Lista os usuários que efetuaram entradas por Compras
Local _cChave := ""
Local _cQry   := ""
Local cIndexSF2:= "" 
Local nIndexSF2:= 0
Local cChaveSF2:= "F2_FILIAL + F2_DOC + F2_SERIE"
Local _cUser   := ""
Local _aUser   := {}
Local _nPos := 0
Local _cMsg := ""
Local _cEOF := Chr(13)+Chr(10)

dbSelectArea("SF2") ; dbSetOrder(1)
cIndexSF2 := CriaTrab(nil,.f.)
//IndRegua("SF1",cIndexSF1,cChaveSF1,,"F1_FILIAL = '01' .AND. DTOS(F1_EMISSAO) >= '20130901' .AND. DTOS(F1_EMISSAO) <= '20130930'","Aguarde... Filtro SF1")
IndRegua("SF2",cIndexSF2,cChaveSF2,,"DTOS(F2_EMISSAO) >= '20130901' .AND. DTOS(F2_EMISSAO) <= '20130930'","Aguarde... Filtro SF2")
nIndexSF2 := RetIndex("SF2")
//dbSetIndex(cIndexSF1+OrdBagExt())
dbSetOrder(nIndexSF2+1)
//dbSeek(xFilial("SF1"))


/*
If dbSeek("03"+"000044261"+"5  "+"UNIGI "+"00")
	//ALERT(EMBARALHA("F1_USERLGI",1))
	ALERT(FWLEUSERLG("F1_USERLGI"))
EndIf	
*/

//_cQry := "Select * from sf1010 where f1_filial='01' and f1_emissao >= '20130901' and f1_emissao <= '20130930' "
//TCQUERY _cQry Alias "TSF1" New

ProcRegua(LastRec())

dbGoTop()
While !Eof()        
	IncProc()
	// ALERT(FWLEUSERLG("SF1->F1_USERLGI"))
   	// nPos:=aScan(aPrint, {|aVal| aVal[1] == ALLTRIM(TSZO->ZO_UO) .and. aVal[2] == allTrim(TSZO->ZO_CONTA)})

	// Pego o usuário na SF3
	_cUser := ""
	dbSelectArea("SF3") ; dbSetOrder(5)
	If dbSeek(SF2->F2_FILIAL + SF2->F2_SERIE + SF2->F2_DOC + SF2->F2_CLIENTE + SF2->F2_LOJA)
	   	_cUser   := FWLEUSERLG("SF3->F3_USERLGI")
	   	
	   	_nPos := aScan(_aUser, {|aVal|aVal[1] == SF2->F2_FILIAL .AND. aVal[2] == ALLTRIM(_cUser)})
		If _nPos > 0
			If AllTrim(SF2->F2_PREFIXO) $ "CTR|CTE|CTV|CTA|5"
				_aUser[_nPos,4] += 1
			Else
				_aUser[_nPos,5] += 1
			EndIf	
		Else
			_nCTRC := _nNF := 0
			
			If AllTrim(SF2->F2_PREFIXO) $ "CTR|CTE|CTV|CTA"
				_nCTRC := 1
			Else
				_nNF   := 1
			EndIf
			AADD(_aUser, {SF2->F2_FILIAL, _cUser, UPPER(U_FRetNUser(AllTrim(_cUser))), _nCTRC, _nNF })
		EndIf
	EndIf
	
	dbSelectArea("SF2")
	dbSkip()
End

_cMsg += "FILIAL;USUARIO;NOME USUARIO;QTD.CTRC;QTD.NFS" + _cEof
For _n := 1 To Len(_aUser)
	_cMsg += _aUser[_n,1] + ";" + _aUser[_n,2] + ";" + _aUser[_n,3] + ";" + Str(_aUser[_n,4]) +  ";" + Str(_aUser[_n,5]) + _cEof
Next _n

MEMOWRIT("U:\TEMP\SAIDAS_USER.CSV",_cMsg)

Alert("Gerado")

dbClearFilter()
fErase( cIndexSF2 + OrdBagExt() )	//Deletando arquivo de trabalho*/
Return6

*************************************
// Retorna Array com Nome do Usuário 
*************************************
User Function fRetNUser(_cUser)
PswOrder(2)
PswSeek(_cUser,.t.)
aUser := PswRet(1)
Return aUser[1,4]