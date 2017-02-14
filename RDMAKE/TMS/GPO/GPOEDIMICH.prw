
#Include 'Protheus.ch'
//#Include 'FWMVCDef.ch'
//#Include "PARMTYPE.CH"

/*
Programa    : GPOEDIMICH
Funcao      : 
Data        : 23/09/2016
Autor       : Ricardo Guimarães
Descricao   : 
Uso         : GPOEDIMich - Possui as funções do EDI da Michelin
Sintaxe     : 
Chamanda    : 
*/

/*
Programa    : GPOEDIMICH
Funcao      : GPOA1
Data        : 27/09/2016
Autor       : Ricardo Guimarães
Descricao   : Ponto de Entrada executado na Rotina de EDI desenvolvida pela ITUP
            : Usado para carregados os dados da ZTH num vetor
            Uso         : GPOEDIMich - Gera agendamento no GPO
Sintaxe     : 
Chamanda    : E chamado na rotina de EDI do GPO - Painel EDI
*/

#DEFINE _ZA6_FILIAL	01
#DEFINE _ZA6_PROJET	02
#DEFINE _ZA6_OBRA		03
#DEFINE _ZA6_SEQTRA	04
#DEFINE _ZA6_TRANSP	05
#DEFINE _ZA6_DESTRA	06
#DEFINE _ZA6_ORIGEM	07
#DEFINE _ZA6_DESTIN	08
#DEFINE _ZA6_NOMORI	09
#DEFINE _ZA6_MUNORI	10
#DEFINE _ZA6_ESTORI	11
#DEFINE _ZA6_CEPORI	12
#DEFINE _ZA6_NOMDES	13
#DEFINE _ZA6_CGCDES	14
#DEFINE _ZA6_INSDES	15
#DEFINE _ZA6_ENDDES	16
#DEFINE _ZA6_BAIDES	17
#DEFINE _ZA6_ESTDES	18
#DEFINE _ZA6_CEPDES	19
#DEFINE _ZA6_EMADES	20
#DEFINE _ZA6_DDDDES	21
#DEFINE _ZA6_TELDES	22
#DEFINE _ZA6_CLIORI	23
#DEFINE _ZA6_LOJORI	24
#DEFINE _ZA6_LOJDES	25
#DEFINE _ZA6_CLIDES	26
#DEFINE _ZA6_MUNDES	27
#DEFINE _ZA6_CONPAG	28
#DEFINE _ZA6_MUNDE2	29
#DEFINE _ZA6_ESTDE2	30
#DEFINE _ZA6_USERGI	31
#DEFINE _ZA6_USERGA	32
#DEFINE _ZA6_PEDCLI	33
#DEFINE _ZA6_TPTRAN	34
#DEFINE _ZA6_TPFRET	35
#DEFINE _ZA6_EMERGE	36
#DEFINE _ZA6_DESCRO	37
#DEFINE _ZA6_EMERG2	38
#DEFINE _ZA6_CCGEFC	39
#DEFINE _ZA6_TIPFLU	40
#DEFINE _ZA6_TIPDES	41
#DEFINE _ZA6_TABVEN	42
#DEFINE _ZA6_VERVEN	43
#DEFINE _ZA6_ITTABV	44
#DEFINE _ZA6_TABCOM	45
#DEFINE _ZA6_VERCOM	46
#DEFINE _ZA6_ITTABC	47
#DEFINE _ZA6_FERIAC	48
#DEFINE _ZA6_FERIAV	49
#DEFINE _ZA6_TPTRAC	50
#DEFINE _ZA6_CODFOP	51
#DEFINE _ZA6_LOJFOP	52

// ZA7
#DEFINE _ZA7_DTCAR	01
#DEFINE _ZA7_HRCAR	02
#DEFINE _ZA7_DTDES	03
#DEFINE _ZA7_HRDES	04

/*
Programa    : GPOEDIMICH
Funcao      : GPOA1
Data        : 27/09/2016
Autor       : Ricardo Guimarães
Descricao   : Ponto de Entrada executado na Rotina de EDI desenvolvida pela ITUP
            : Usado para carregados os dados da ZTH num vetor
            Uso         : GPOEDIMich - Gera agendamento no GPO
Sintaxe     : 
Chamanda    : E chamado na rotina de EDI do GPO - Painel EDI
*/

/*--------------------------------------*/
User Function GPOA1
/*--------------------------------------*/
Local aArea			:= GetArea()
Local _cCodCliDes		:= "" 
Local _cLjCliDes		:= ""
Local _cCGCMichCG		:= GetNewPar("ES_MICHCG"  ,"50567288000744") 	// CNPJ da Michelin de Destino Campo Grande
Local _cCGCMichIta	:= GetNewPar("ES_MICHITA" ,"50567288000663") 	// CNPJ da Michelin de Destino Itatiaia
Local _cLocMichCG 	:= GetNewPar("ES_LOCALCG" ,"001389"  ) 			// Local de Campo Grande na Tabela ZA2
Local _cLocMichIta	:= GetNewPar("ES_LOCALIT" ,"000728"  ) 			// Local de Itatiaia na Tabela ZA2		
Local _cCCGefco		:= GetNewPar("ES_CCMICH"  ,"2110066176"  ) 		// CC Gefco usado na operação Michelin
Local _cProjeto		:= ""

// ------------------------------------------------------------------------------------------------
// cCombo Tipo do layout ML1, ML2, ML3, ML4, ML5, ML6, ML7... ou novos criados pela GEFCO no SX5 _D
// ------------------------------------------------------------------------------------------------
If substr(cCombo,1,2) == "ML" // Uso exclusivo da ITUP nao esqueca de manter esta linha de codigo para nao misturar os EDI´s
	Return NIL
EndIf  

If !_xT11  // Não foi informado contrato
	Return(.f.)
EndIf 

_cProjeto := AllTrim(_xT10)

If Empty(_cProjeto)  // Contrato em branco
	Return(.f.)
EndIf 

_cProjeto := _xT10 
ZA0->(dbSetOrder(1))
ZA0->(dbSeek(xFilial("ZA0") + _cProjeto))

// --------------------------------------
// Bloquear o projeto antes de atualizar
// --------------------------------------
If ! LockByName(ZA0->ZA0_FILIAL+ZA0->ZA0_PROJET, .F., .F.)                                               
	cErros += "Registro em uso por outro usuário. Contrato: "+ZA0->ZA0_PROJET+_cCrLf
	RestArea(aArea)
	Return(.f.)
EndIf                                                  

// Importante vinvular com a tabela de regras para uso do sistema
ZTG->(dbOrderNickName("ITUPZTG001"))
ZTG->(dbSeek(xFilial("ZTG")+ZTH->(ZTH_LAYOUT+ZTH_TIPO+ZTH_REG+ZTH_SEQ+ZTH_SUB)))
If ZTG->(Eof())
	cErros := "Vinculo nao encontrado entre ZTG e ZTH. "
	cErros += _cCrLf
	cErros += "Layout "+alltrim(ZTH->ZTH_LAYOUT)+" Reg "+ZTH->ZTH_REG+" Seq "+ZTH->ZTH_SEQ+" Sub "+ZTH->ZTH_SUB+_cCrLf
	RestArea(aArea)
	Return .F.
EndIf	                   

_xTemp10 := _cCCGefco 

// Aponta a tabela de Venda

If ZTH->ZTH_REG == "00" .and. ZTH->ZTH_SEQ == "0001"
	// Adicionar a linha no array _aArray01 -> conteudo da ZA6
/*
	aadd(_aArray01,{"",; 		// ZA6_PEDCLI 01
					"",;		// ZA6_ORIGEM 02
					"",;		// ZA6_NOMORI 03							
					"",;		// ZA6_MUNORI 04
					"",;		// ZA6_ESTORI 05
					"",; 		// ZA6_CEPORI 06
					"",;		// ZA6_CLIORI 07
					"",;		// ZA6_LOJORI 08
					"",;		// ZA6_DESTIN 09
					"",;		// ZA6_DESTIN 09
					""})	                    
*/	
	
	// Neste caso estou gerando um array para a ZA6. Criem a ZA7 e demais tabelas necessárias

    aadd(_aArray01,{"",;	// _ZA6_FILIAL	01
            		"",;	// _ZA6_PROJET	02
            		"",;	// _ZA6_OBRA		03
            		"",;	// _ZA6_SEQTRA	04
            		"",;	// _ZA6_TRANSP	05
            		"",;	// _ZA6_DESTRA	06
            		"",;	// _ZA6_ORIGEM	07
            		"",;	// _ZA6_DESTIN	08
            		"",;	// _ZA6_NOMORI	09
            		"",;	// _ZA6_MUNORI	10
            		"",;	// _ZA6_ESTORI	11
            		"",;	// _ZA6_CEPORI	12
            		"",;	// _ZA6_NOMDES	13
            		"",;	// _ZA6_CGCDES	14
            		"",;	// _ZA6_INSDES	15
            		"",;	// _ZA6_ENDDES	16
            		"",;	// _ZA6_BAIDES	17
            		"",;	// _ZA6_ESTDES	18
            		"",;	// _ZA6_CEPDES	19
            		"",;	// _ZA6_EMADES	20
            		"",;	// _ZA6_DDDDES	21
            		"",;	// _ZA6_TELDES	22
            		"",;	// _ZA6_CLIORI	23
            		"",;	// _ZA6_LOJORI	24
            		"",;	// _ZA6_LOJDES	25
            		"",;	// _ZA6_CLIDES	26
            		"",;	// _ZA6_MUNDES	27
            		"",;	// _ZA6_CONPAG	28
            		"",;	// _ZA6_MUNDE2	29
            		"",;	// _ZA6_ESTDE2	30
            		"",;	// _ZA6_USERGI	31
            		"",;	// _ZA6_USERGA	32
            		"",;	// _ZA6_PEDCLI	33
            		"",;	// _ZA6_TPTRAN	34
            		"",;	// _ZA6_TPFRET	35
            		"",;	// _ZA6_EMERGE	36
            		"",;	// _ZA6_DESCRO	37
            		"",;	// _ZA6_EMERG2	38
            		"",;	// _ZA6_CCGEFC	39
            		"",;	// _ZA6_TIPFLU	40
            		"",;	// _ZA6_TIPDES	41
            		"",;	// _ZA6_TABVEN	42
            		"",;	// _ZA6_VERVEN	43
            		"",;	// _ZA6_ITTABV	44
            		"",;	// _ZA6_TABCOM	45
            		"",;	// _ZA6_VERCOM	46
            		"",;	// _ZA6_ITTABC	47
            		"",;	// _ZA6_FERIAC	48
            		"",;	// _ZA6_FERIAV	49
            		"",;	// _ZA6_TPTRAC	50
            		"",;	// _ZA6_CODFOP	51
            		"" ;	// _ZA6_LOJFOP	52
					 } )

	// ZA7
    aadd(_aArray02,{	"",;	// _ZA6_DTCAR
	               	"",;	// _ZA6_HRCAR
	               	"",;	// _ZA6_DTDES
	               	"" ;	// _ZA6_HRDES
    					} )	      

ElseIf ZTH->ZTH_REG == "00" .and. ZTH->ZTH_SEQ == "0006" // Cliente Origem
	// Origem
	_aA15 :=  GetAdvFVal('SA1',{'A1_COD','A1_LOJA','A1_NOME','A1_MUN','A1_EST','A1_CEP'},xFilial('SA1') + alltrim(ZTH->ZTH_CONTEU),3,{'','','','','',''} ) 

	_aArray01[len(_aArray01)][_ZA6_CLIORI] := _aA15[1]	
	_aArray01[len(_aArray01)][_ZA6_LOJORI] := _aA15[2]
	_aArray01[len(_aArray01)][_ZA6_NOMORI] := _aA15[3]
	_aArray01[len(_aArray01)][_ZA6_MUNORI] := _aA15[4]
	_aArray01[len(_aArray01)][_ZA6_ESTORI] := _aA15[5]
	_aArray01[len(_aArray01)][_ZA6_CEPORI] := _aA15[6]
	_aArray01[len(_aArray01)][_ZA6_CCGEFC] := _cCCGefco 	
	
	If AllTrim(_aA15[4]) == 'ITATIAIA'
		_aArray01[len(_aArray01)][_ZA6_ORIGEM] := _cLocMichIta
		_aArray01[len(_aArray01)][_ZA6_DESTIN] := _cLocMichCG
		
	// Cliente Destino
		_aA15 :=  GetAdvFVal('SA1',{'A1_COD','A1_LOJA'},xFilial('SA1') + alltrim(_cCGCMichCG),3,{'',''} )
		_cCodCliDes := _aA15[1]
		_cLojCliDes := _aA15[2]
	Else
		_aArray01[len(_aArray01)][_ZA6_ORIGEM] := _cLocMichCG	
		_aArray01[len(_aArray01)][_ZA6_DESTIN] := _cLocMichIta
		
		_aA15 :=  GetAdvFVal('SA1',{'A1_COD','A1_LOJA'},xFilial('SA1') + alltrim(_cCGCMichITA),3,{'',''} )
		_cCodCliDes := _aA15[1]
		_cLojCliDes := _aA15[2]
		
	EndIf			
	
	_xTemp11 := _cCodCliDes
	_xTemp12 := _cLojCliDes
	
ElseIf ZTH->ZTH_REG == "01" .and. ZTH->ZTH_SEQ == "0006" // Cliente Destino
	// cTemp := alltrim(ZTH->ZTH_CONTEUD)
	
	_cCodCliDes := _xTemp11
	_cCodLojDes := _xTemp12
	
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+_cCodCliDes + _cCodLojDes ))
    	_aArray01[len(_aArray01)][_ZA6_CLIDES] := SA1->A1_COD		
    	_aArray01[len(_aArray01)][_ZA6_LOJDES] := SA1->A1_LOJA    	
    	_aArray01[len(_aArray01)][_ZA6_NOMDES] := SA1->A1_NOME 
    	_aArray01[len(_aArray01)][_ZA6_CGCDES] := SA1->A1_CGC
    	_aArray01[len(_aArray01)][_ZA6_INSDES] := SA1->A1_INSCR
    	_aArray01[len(_aArray01)][_ZA6_ENDDES] := SA1->A1_END			
    	_aArray01[len(_aArray01)][_ZA6_BAIDES] := SA1->A1_BAIRRO
		_aArray01[len(_aArray01)][_ZA6_MUNDES] := SA1->A1_MUN    	
    	_aArray01[len(_aArray01)][_ZA6_ESTDES] := SA1->A1_EST		
    	_aArray01[len(_aArray01)][_ZA6_CEPDES] := SA1->A1_CEP	
    	_aArray01[len(_aArray01)][_ZA6_EMADES] := SA1->A1_EMAIL
    	_aArray01[len(_aArray01)][_ZA6_DDDDES] := SA1->A1_DDD
    	_aArray01[len(_aArray01)][_ZA6_TELDES] := SA1->A1_TEL			
    	_aArray01[len(_aArray01)][_ZA6_MUNDE2] := SA1->A1_MUN    	
    	_aArray01[len(_aArray01)][_ZA6_ESTDE2] := SA1->A1_EST    	
	EndIf

    _aArray01[len(_aArray01)][_ZA6_CONPAG] := ZA0->ZA0_CONPAG
	
ElseIf ZTH->ZTH_REG == "01" .and. ZTH->ZTH_SEQ == "0014" // Pedido do cliente
	_xTemp15 := alltrim(ZTH->ZTH_CONTEU)
	_aArray01[len(_aArray01)][_ZA6_PEDCLI] := _xTemp15

// ZA7
ElseIf ZTH->ZTH_REG == "01" .and. ZTH->ZTH_SEQ == "0023" // Data e Hora de Início de Coleta
	_xTemp15 := alltrim(ZTH->ZTH_CONTEU)
	_aArray02[len(_aArray01)][_ZA7_DTCAR] := SubStr(_xTemp15,1,11)  		// Precisa converter e extrar a data
	_aArray02[len(_aArray01)][_ZA7_HRCAR] := AllTrim(Right(_xTemp15,8))	// Precisa converter e extrar a hora

ElseIf ZTH->ZTH_REG == "01" .and. ZTH->ZTH_SEQ == "0024" // Data e Hora de Final de Coleta
	_xTemp15 := alltrim(ZTH->ZTH_CONTEU)
	_aArray02[len(_aArray01)][_ZA7_DTDES] := SubStr(_xTemp15,1,11)  		// Precisa converter e extrar a data
	_aArray02[len(_aArray01)][_ZA7_HRDES] := AllTrim(Right(_xTemp15,8))	// Precisa converter e extrar a hora

EndIf


// Aponta a tabela de Venda de Frete

// Aponta a tabela de Compra de Frete

// Aponta a tabela de Clientes 

UnLockByName(ZA0->ZA0_FILIAL+ZA0->ZA0_PROJET, .F., .F.)
RestArea(aArea)
Return NIL

/*
Programa    : GPOEDIMICH
Funcao      : GPOG1
Data        : 03/10/2016
Autor       : Ricardo Guimarães
Descricao   : Ponto de Entrada executado na Rotina de EDI desenvolvido pela ITUP
            : Usado para gravar os dados 
Uso         : GPOEDIMich - Gera agendamento no GPO
Sintaxe     : 
Chamanda    : E chamado na rotina de EDI do GPO - Painel EDI
*/
User Function GPOG1
Local _aDtHorCarga 	:= {}
Local _aDtHorDesC		:= {}
Local _nX				:= 1
Local _aArea			:= GetArea()

// cCombo Tipo do layout ML1, ML2, ML3, ML4, ML5, ML6, ML7... ou novos criados pela GEFCO no SX5 _D
If substr(cCombo,1,2) == "ML" // Uso exclusivo da ITUP nao esqueca de manter esta linha de codigo para nao misturar os EDI
	Return NIL
EndIf          

If !_xT11  // Não foi informado contrato
	Return(.f.)
EndIf 
           
/*
If ZTJ->ZTJ_SITUA > '3'
	// Veja o posicionamento da ZTJ, ou crie o registro....
	cErros := "Agendamento ja informado. Projeto "+ZA0->ZA0_PROJET
	RecLock("ZTJ",.F.)
	ZTJ->ZTJ_FILIAL	:= xFilial("ZTJ")
	ZTJ->ZTJ_SITUA  := "2"
	ZTJ->ZTJ_AVISOS := cAvisos
	ZTJ->ZTJ_ERROS	:= cErros
	ZTJ->ZTJ_DTINTE := ctod("")
	ZTJ->(MsUnlock())    
	TRB->(dbCloseArea())	 
Return cErros
*/

// --------------------------------------
// Bloquear o projeto antes de atualizar
// --------------------------------------
If ! LockByName(ZA0->ZA0_FILIAL+ZA0->ZA0_PROJET, .F., .F.)                                               
	cErros += "Registro em uso por outro usuário. Contrato: "+ZAO->ZA0_PROJET+_cCrLf
	RestArea(aArea)
	Return(.f.)
EndIf                                                  


// -------------------
// Gravacao dos dados
// -------------------
Begin Transaction 
	RecLock("ZA6",.T.)
		//ZA6->ZA6_PEDCLI	:= _aArray01[_nX][01]
		//ZA6->ZA6_ORIGEM	:= _aArray01[_nX][02]
	
		ZA6_FILIAL	:= ZA0->ZA0_FILPED
		ZA6_PROJET	:= ZA0->ZA0_PROJET
		// ZA6_OBRA	:= 
		ZA6_SEQTRA	:= '001'
		// ZA6_TRANSP	:= // Depende da tabela de Venda
		// ZA6_DESTRA	:= // Depende da tabela de Venda
		ZA6_ORIGEM	:= _aArray01[_nX][07] // [_ZA6_ORIGEM]
		ZA6_DESTIN	:= _aArray01[_nX][08] // [_ZA6_DESTIN]
		ZA6_NOMORI	:= _aArray01[_nX][09] // [_ZA6_NOMORI]
		ZA6_MUNORI	:= _aArray01[_nX][10] // [_ZA6_MUNORI]
		ZA6_ESTORI	:= _aArray01[_nX][11] // [_ZA6_ESTORI]
		ZA6_CEPORI	:= _aArray01[_nX][12] // [_ZA6_CEPORI]
		ZA6_NOMDES	:= _aArray01[_nX][13] // [_ZA6_NOMDES]
		ZA6_CGCDES	:= _aArray01[_nX][14] // [_ZA6_CGCDES]
		ZA6_INSDES	:= _aArray01[_nX][15] // [_ZA6_INSDES]
		ZA6_ENDDES	:= _aArray01[_nX][16] // [_ZA6_ENDDES]
		ZA6_BAIDES	:= _aArray01[_nX][17] // [_ZA6_BAIDES]
		ZA6_ESTDES	:= _aArray01[_nX][18] // [_ZA6_ESTDES]
		ZA6_CEPDES	:= _aArray01[_nX][19] // [_ZA6_CEPDES]
		ZA6_EMADES	:= _aArray01[_nX][20] // [_ZA6_EMADES]
		ZA6_DDDDES	:= _aArray01[_nX][21] // [_ZA6_DDDDES]
		ZA6_TELDES	:= _aArray01[_nX][22] // [_ZA6_TELDES]
		ZA6_CLIORI	:= _aArray01[_nX][23] // [_ZA6_CLIORI]
		ZA6_LOJORI	:= _aArray01[_nX][24] // [_ZA6_LOJORI]
		ZA6_LOJDES	:= _aArray01[_nX][25] // [_ZA6_LOJDES]
		ZA6_CLIDES	:= _aArray01[_nX][26] // [_ZA6_CLIDES]
		ZA6_MUNDES	:= _aArray01[_nX][27] // [_ZA6_MUNDES]
		ZA6_CONPAG	:= _aArray01[_nX][28] // [_ZA6_CONPAG]
		ZA6_MUNDE2	:= _aArray01[_nX][29] // [_ZA6_MUNDE2]
		ZA6_ESTDE2	:= _aArray01[_nX][30] // [_ZA6_ESTDE2]
		ZA6_USERGI	:= EMBARALHA(cUserName,0) 
		// ZA6_USERGA	:= _aArray01[_nX][ZA6_
		ZA6_PEDCLI	:= _aArray01[_nX][33] // [_ZA6_PEDCLI]
		ZA6_TPTRAN	:= _aArray01[_nX][34] // [_ZA6_TPTRAN]
		ZA6_TPFRET	:= _aArray01[_nX][35] // [_ZA6_TPFRET]
		ZA6_EMERGE	:= _aArray01[_nX][36] // [_ZA6_EMERGE]
		ZA6_DESCRO	:= _aArray01[_nX][37] // [_ZA6_DESCRO]
		ZA6_EMERG2	:= _aArray01[_nX][38] // [_ZA6_EMERG2]
		ZA6_CCGEFC	:= _aArray01[_nX][39] // [_ZA6_CCGEFC]
		ZA6_TIPFLU	:= _aArray01[_nX][40] // [_ZA6_TIPFLU]
		ZA6_TIPDES	:= _aArray01[_nX][41] // [_ZA6_TIPDES]
		ZA6_TABVEN	:= _aArray01[_nX][42] // [_ZA6_TABVEN]
		ZA6_VERVEN	:= _aArray01[_nX][43] // [_ZA6_VERVEN]
		ZA6_ITTABV	:= _aArray01[_nX][44] // [_ZA6_ITTABV]
		ZA6_TABCOM	:= _aArray01[_nX][45] // [_ZA6_TABCOM]
		ZA6_VERCOM	:= _aArray01[_nX][46] // [_ZA6_VERCOM]
		ZA6_ITTABC	:= _aArray01[_nX][47] // [_ZA6_ITTABC]
		ZA6_FERIAC	:= _aArray01[_nX][48] // [_ZA6_FERIAC]
		ZA6_FERIAV	:= _aArray01[_nX][49] // [_ZA6_FERIAV]
		ZA6_TPTRAC	:= _aArray01[_nX][50] // [_ZA6_TPTRAC]
		ZA6_CODFOP	:= _aArray01[_nX][51] // [_ZA6_CODFOP]
		ZA6_LOJFOP	:= _aArray01[_nX][52] // [_ZA6_LOJFOP]
		
	ZA6->(MsUnLock())

	RecLock("ZA7",.T.)

		ZA7_FILIAL	:= ZA0->ZA0_FILPED
		ZA7_PROJET	:= ZA0->ZA0_PROJET
		// ZA7_OBRA	:= _aArray01[_nX][ZA6_
		ZA7_SEQTRA	:= '001'
		// ZA7_SEQCAR	:= _aArray01[_nX][ZA6_ // Sequencia dentro de AST
		ZA7_CARGA	:= "P"
		ZA7_QUANT	:= "1"
		ZA7_EMERGE	:= "N"
		ZA7_EMERG2	:= "N"
/* Depende da tabela de venda		
		ZA7_CARENC	:= _aArray01[_nX][ZA6_
		ZA7_TIPCAR	:= _aArray01[_nX][ZA6_
		ZA7_INCADV	:= _aArray01[_nX][ZA6_
		ZA7_FORMAS	:= _aArray01[_nX][ZA6_
*/		
//		ZA7_VIAGEM	:= _aArray01[_nX][ZA6_ // Será gerada na aprovação da AST
		ZA7_EHTERC	:= "S"
		ZA7_RESPC	:= "C"
		ZA7_RESPD	:= "C"
//		ZA7_VRDES	:= _aArray01[_nX][ZA6_
		
		_aDtHorCarga 	:= fBuscaDtHor(_aArray02[_nX][01]/*[_ZA7_DTCAR]*/, _aArray02[_nX][02]/*[_ZA7_HRCAR]*/)
		_aDtHorDesC	:= fBuscaDtHor(_aArray02[_nX][03]/*[_ZA7_DTDES]*/, _aArray02[_nX][04]/*[_ZA7_HRDES]*/)

		ZA7_DTCAR	:= _aDtHorCarga[1] 	// _aArray01[_nX][ZA7_DTCAR
		ZA7_HRCAR	:= _aDtHorCarga[2] 	// _aArray01[_nX][ZA7_HRCAR
		ZA7_DTDES	:= _aDtHorDesC [1]	// _aArray01[_nX][ZA7_DTDES
		ZA7_HRDES	:= _aDtHorDesC [2]	// _aArray01[_nX][ZA7_HRDES
/*  Dependa da tabela de Venda		
		ZA7_CAREND	:= _aArray01[_nX][ZA6_
		ZA7_TPCARD	:= _aArray01[_nX][ZA6_
*/		
		ZA7_USERGI	:= EMBARALHA(cUserName,0)
		// ZA7_USERGA	:= _aArray01[_nX][ZA6_
		// ZA7_REVNAS	:= _aArray01[_nX][ZA6_
		ZA7_QTD	:= 1
		// ZA7_AS		:= _aArray01[_nX][ZA6_
		ZA7_CODCLI	:= _aArray01[_nX][23] // [_ZA6_CLIORI]
		ZA7_LOJCLI	:= _aArray01[_nX][24] // [_ZA6_LOJORI]
		ZA7_DEVEMB	:= "P"
		ZA7_DESCLI	:= _aArray01[_nX][09] // [_ZA6_NOMORI]
		ZA7_MUNICI	:= _aArray01[_nX][07] // [_ZA6_ORIGEM]
		ZA7_DESMUN	:= _aArray01[_nX][10] // [_ZA6_MUMORI]
		ZA7_UFCARG	:= _aArray01[_nX][11] // [_ZA6_ESTORI]
		// ZA7_FILREG	:= MV_PAR02 // _aArray01[_nX][ZA6_
		ZA7_ADICIO	:= "N" // _aArray01[_nX][ZA6_
/*		// Depende da tabela de Compra
		ZA7_VRDESC	:= _aArray01[_nX][ZA6_ 
		ZA7_VALOR	:= _aArray01[_nX][ZA6_
		ZA7_CUSTO	:= _aArray01[_nX][ZA6_
*/		
		ZA7_CCGEFC	:= _xTemp10 // CC Gefco
		ZA7_TIPDES	:= "O" 
		ZA7_CLIDES	:= _aArray01[_nX][26] // [_ZA6_CLIDES]
		ZA7_LOJDES	:= _aArray01[_nX][25] // [_ZA6_LOJDES]
		ZA7_NOMDES	:= _aArray01[_nX][13] // [_ZA6_NOMDES]
		ZA7_PICKIN	:= "S" // _aArray01[_nX][ZA6_
		// ZA7_CUSTOP	:= _aArray01[_nX][ZA6_ // Dependa da tabela de compras

	ZA7->(MsUnLock())

//	Veja o posicionamento da ZTJ, ou crie o registro....
	RecLock("ZTJ",.F.)
		ZTJ->ZTJ_FILIAL	:= xFilial("ZTJ")
		ZTJ->ZTJ_SITUA  	:= "6"
		ZTJ->ZTJ_AVISOS 	:= cAvisos
		ZTJ->ZTJ_ERROS	:= cErros
		ZTJ->ZTJ_DTINTE 	:= dDataBase
		ZTJ->ZTJ_FILZA6 	:= ZA0->ZA0_FILPED
		ZTJ->ZTJ_FILZA6 	:= ZA0->ZA0_PROJET
		ZTJ->ZTJ_PEDIDO 	:= _aArray01[_nX][33] // [_ZA6_PEDCLI] 		
	ZTJ->(MsUnlock())    
//	TRB->(dbCloseArea())	 

	UnLockByName(ZA0->ZA0_FILIAL+ZA0->ZA0_PROJET, .F., .F.)
	RestArea(_aArea)

_lGravou := .T.

End Transaction 

// Explicacao das situacoes da tabela ZTJ - painel
//AAdd(aLegenda,{"BR_VERDE","Pronto para integrar"})
//AAdd(aLegenda,{"BR_AMARELO","Pendente de integracao"})
//AAdd(aLegenda,{"BR_VERMELHO","Processado com pendencias"})
//AAdd(aLegenda,{"BR_AZUL","Processado com sucesso"})
//AAdd(aLegenda,{"BR_CINZA","Integrado com GPO"})
//AAdd(aLegenda,{"BR_BRANCO","Ligacao de Notas Fiscais do CVA"})
//AAdd(aLegenda,{"BR_LARANJA","Gerado, Aguardando Retorno"})
//AAdd(aLegenda,{"BR_MARROM","Horario real Fornecedor"})
//AAdd(aCores,{"ZTJ->ZTJ_SITUA == '1'","BR_VERDE"})
//AAdd(aCores,{"ZTJ->ZTJ_SITUA == '2'","BR_AMARELO"})
//AAdd(aCores,{"ZTJ->ZTJ_SITUA == '3'","BR_VERMELHO"})
//AAdd(aCores,{"ZTJ->ZTJ_SITUA == '4'","BR_AZUL"})
//AAdd(aCores,{"ZTJ->ZTJ_SITUA == '5'","BR_CINZA"})
//AAdd(aCores,{"ZTJ->ZTJ_SITUA == '6'","BR_BRANCO"})
//AAdd(aCores,{"ZTJ->ZTJ_SITUA == '7'","BR_LARANJA"})
//AAdd(aCores,{"ZTJ->ZTJ_SITUA == '8'","BR_MARROM"})
//AAdd(aCores,{"ZTJ->ZTJ_SITUA == '9'","BR_PRETO"})

Return NIL

/*--------------------------------------------------------------------------*/
/* Função para converter a data e hora que vem na interface no formato      */
/* DD-MMM-ANO, sendo que o mês em ingles                                    */
/*--------------------------------------------------------------------------*/
Static Function fBuscaDtHor(_cData /*30-AUG-2016*/, _cHora /*00:00:00*/)
Local _aRet 	:= Array(2)
Local _aMes 	:= {'01','02','03','04','05','06','07','08','09','10','11','12'}
Local _aMesExt:= {'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'}
Local _nPos	:= AScan(_aMesExt, Upper(SubStr(_cData,4,3)) ) 

_cData := AllTrim(_cData)

_aRet[1] := CtoD(Left(_cData,2)+"/"+_aMes[_nPos]+"/"+Right(_cData,4)) 
_aRet[2] := StrTran(Left(_cHora,5),":","")  

Return _aRet


/*
Programa    : GPOEDIMICH
Funcao      : GPOC1
Data        : 04/10/2016
Autor       : Ricardo Guimarães
Descricao   : Ponto de Entrada executado na Rotina de EDI desenvolvida pela ITUP
            : Usado para posicionar na tebela de contratos(ZA0)
            Uso         : GPOEDIMich - Gera agendamento no GPO
Sintaxe     : 
Chamanda    : E chamado na rotina de EDI do GPO - Painel EDI
*/

User Function GPOC1()

If substr(cCombo,1,2) == "ML" // Uso exclusivo da ITUP nao esqueca de manter esta linha de codigo para nao misturar os EDI´s
	Return NIL
EndIf  

_xT11 := AjustaParam()
	
Return NIL

/*------------------------------------*/
Static Function AjustaParam
/*------------------------------------*/
	Local aParamBox	:= {}
	Local aRet			:= {}
	Local lRetorno	:= .F.
	Local lRetorno	:= .F.
	Local lCanSave	:= .T.
	Local lUserSave	:= .T.

	Local cLoad		:= "GEFEDIMICH"
//	Local aCombo		:= {"Cordovil","Porto Real"}
//	Local cDiretorio	:= PadR(MV_PAR01,20)

//	Aadd(aParamBox,{6,"Diretorio"		,cDiretorio		,"@!"	,"StaticCall(GEFR022,VldDiretorio)","",50,.F.,"XML (*.XML) |*.XML","U:",GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY } )

//	aAdd(aParamBox,{1,"Arquivo"			,PadR("CT-e",50)	,"@!"	,"StaticCall(GEFR022,VldArquivo)"	,"","",50,.F.})

//	aAdd(aParamBox,{1,"Data Inicial"	,Ctod(Space(8))	,""		,""										,"","",50,.F.})
//	aAdd(aParamBox,{1,"Data Final"		,Ctod(Space(8))	,""		,"StaticCall(GEFR022,VldDataFim)"	,"","",50,.F.})

//	aAdd(aParamBox,{1,"CT-e Final"		,Space(GetSx3Cache("DT6_DOC","X3_TAMANHO"))	,"@!","StaticCall(GEFR022,VldCTE)",""		,"",50	,.F.})

//	aAdd(aParamBox,{1,"Filial Inicial"	,Space(GetSx3Cache("DT6_FILDOC","X3_TAMANHO")),"@!","",""		,"",05 ,.F.})

//	aAdd(aParamBox,{1,"C.Custo Inicial",Space(GetSx3Cache("CTT_CUSTO","X3_TAMANHO"))	,"@!","","CTT"	,"",50	,.F.})
//	aAdd(aParamBox,{1,"C.Custo Final"	,Space(GetSx3Cache("CTT_CUSTO","X3_TAMANHO"))	,"@!","","CTT"	,"",50	,.F.})

//	aAdd(aParamBox,{2,"Tipo do Relatorio",1,aCombo,50,"",.F.})

	aAdd(aParamBox,{1,"Contrato	",Space(GetSx3Cache("ZA0_PROJET","X3_TAMANHO")),"@!","U_fBuscaCon(MV_PAR01)",""		,"",50 ,.F.})
//	aAdd(aParamBox,{1,"Filial 	",Space(GetSx3Cache("ZA0_FILIAL","X3_TAMANHO")),"@!",""                                      ,""		,"",05	,.F.})

	If	ParamBox(aParamBox,"Parâmetros...",@aRet,/*bOk*/,/*aButtons*/,/*lCentered*/,/*nPosX*/,/*nPosy*/,/*oDlgWizard*/,cLoad,lCanSave,lUserSave)
		// lAnalitico := ( ValType( MV_PAR11 ) == 'N' )
		_xT10 		:= MV_PAR01 // ZA0->ZA0_PROJET   
		lRetorno	:= .T.
	Endif

Return( lRetorno )

/*---------------------------------------*/
User Function fBuscaCon(_cProjeto)
/*---------------------------------------*/
Local _lRet 		:= .F.

If Empty( _cProjeto )
	Alert("Favor informar um Contrato válido.")
	_lRet := .F.
Else	
	ZA0->(dbSetOrder(1))
	If ZA0->(dbSeek(xFilial("ZA0") + _cProjeto))
		_xT10 := ZA0->ZA0_PROJET
		_lRet := .T.
	Else
		Alert("Contrato não Localizado.")	
	EndIf
EndIf	
Return _lRet
