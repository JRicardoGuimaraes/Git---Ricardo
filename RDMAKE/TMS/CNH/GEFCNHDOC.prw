#Include 'Protheus.ch'
#Include 'Totvs.ch'

/*/{Protheus.doc} GEFCNHDOC
Função responsável por preencher os documentos do plano de transporte automaticamente na viagem de coleta.
@author 	Luiz Alexandre Ferreira
@since 		17/10/2014
@version 	1.0
@return 	${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function GEFCNHDOC()

// ---	Variaveis utilizadas
Local	_aArea		:=	GetArea()
Local	_nCntFor	:= 	1
Local	_cCampo		:= 	''
Local	_nItem		:= 	0
Local	_aDados		:=	{}

// ---	Somente viagem de coleta
If cSerTMS	== '1' .and. cTipTra	= '1'
	
	// --- Verifica se a rotina veio do agendamento
	If IsInCallStack('TMSAF05')
		
		// ---	Pergunta se carrega documentos
		If MsgYesNo(OemToAnsi('Deseja importar documentos através de plano de transporte?'),'Plano de transporte')
			
			// ---	Busca as solicitações de coleta
			DF1->(dbSetOrder(1))
			DF1->(dbSeek(xFilial('DF1')+DF0->DF0_NUMAGE))
			While DF1->( ! Eof() ) .and. DF0->DF0_FILIAL == DF1->DF1_FILIAL .and. DF0->DF0_NUMAGE == DF1->DF1_NUMAGE
				
				// --- Adiciona elemento na Array
				_nItem++
				If _nItem > 1
					Aadd(aCols,Array(Len(aHeader)+1))
					n++
				EndIf
				        
				Aadd( _aDados, {;
				StrZero(n,TamSX3("DUD_SEQUEN")[1]),;
				'1',;
				DF1->DF1_NUMAGE,;
				DF1->DF1_ITEAGE,;
				DF1->DF1_FILDOC,;
				DF1->DF1_DOC,;
				DF1->DF1_SERIE,;
				GetAdvFVal('SA1','A1_NOME',xFilial('SA1')+DF1->DF1_CLIREM+DF1->DF1_LOJREM),;
				GetAdvFVal('SA1','A1_MUN',xFilial('SA1')+DF1->DF1_CLIREM+DF1->DF1_LOJREM),;
				GetAdvFVal('SA1','A1_BAIRRO',xFilial('SA1')+DF1->DF1_CLIREM+DF1->DF1_LOJREM),;
				GetAdvFVal('SA1','A1_EST',xFilial('SA1')+DF1->DF1_CLIREM+DF1->DF1_LOJREM),;
				DF1->DF1_DATPRC,;
				DF1->DF1_HORPRC,;
				0,;
				GetAdvFVal('DT6','DT6_PESO',xFilial('DT6')+DF1->DF1_FILDOC+DF1->DF1_DOC+DF1->DF1_SERIE),;
				GetAdvFVal('DT6','DT6_PESOM3',xFilial('DT6')+DF1->DF1_FILDOC+DF1->DF1_DOC+DF1->DF1_SERIE),;
				GetAdvFVal('DT6','DT6_VALMER',xFilial('DT6')+DF1->DF1_FILDOC+DF1->DF1_DOC+DF1->DF1_SERIE) } )
				

				// ---	Preenche os campos
				For _nCntFor	:= 1 to Len(aHeader)
					
					// ---
					_cCampo := Alltrim(aHeader[_nCntFor,2])
					
					//If ( aHeader[_nCntFor,10] # "V" )
						
						Do Case 
						
							// --- Sequencia
							Case Alltrim(aHeader[_nCntFor][2]) == "DUD_SEQUEN"
								aCols[Len(aCols)][_nCntFor] :=	_aDados[_nItem,1] 
								// --- Status
							Case Alltrim(aHeader[_nCntFor][2]) == "DUD_STATUS"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,2]
								// --- Agendamento
							Case Alltrim(aHeader[_nCntFor][2]) == "DF1_NUMAGE"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,3]
								// --- Item do agendamento
							Case Alltrim(aHeader[_nCntFor][2]) == "DF1_ITEAGE"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,4]
								// --- Filial de documento
							Case Alltrim(aHeader[_nCntFor][2]) == "DTA_FILDOC"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,5]
								// --- Documentos
							Case Alltrim(aHeader[_nCntFor][2]) == "DTA_DOC"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,6]
								// --- Serie
							Case Alltrim(aHeader[_nCntFor][2]) == "DTA_SERIE"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,7]
								If ExistTrigger("DTA_SERIE")
									RunTrigger(2,Len(aCols))
								EndIf
								// --- Nome
							Case Alltrim(aHeader[_nCntFor][2]) == "DUE_NOME"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,8]
							Case Alltrim(aHeader[_nCntFor][2]) == "DUE_MUN"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,9]
							Case Alltrim(aHeader[_nCntFor][2]) == "DUE_BAIRRO"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,10]
							Case Alltrim(aHeader[_nCntFor][2]) == "DUE_EST"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,11]
							Case Alltrim(aHeader[_nCntFor][2]) == "DT5_DATPRV"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,12]
							Case Alltrim(aHeader[_nCntFor][2]) == "DT5_HORPRV"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,13]
							Case Alltrim(aHeader[_nCntFor][2]) == "DTA_QTDVOL"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,14]
							Case Alltrim(aHeader[_nCntFor][2]) == "DT6_PESO"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,15]
							Case Alltrim(aHeader[_nCntFor][2]) == "DT6_PESOM3"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,16]
							Case Alltrim(aHeader[_nCntFor][2]) == "DT6_VALMER"
								aCols[Len(aCols)][_nCntFor] := _aDados[_nItem,17]
							OtherWise
								aCols[Len(aCols)][_nCntFor] := CriaVar(_cCampo)
								
						EndCase
						
					//EndIf
					
				Next _nCntFor
				
				// ---	Linha não excluida
				aCols[Len(aCols)][Len(aHeader)+1] := .f.
				
				// ---	Proximo registro
				DF1->(dbSkip())
				
			EndDo
			
		EndIf
		
	EndIf
	
EndIf

// --- Restaura area
RestArea(_aArea)
               
// --- Refresh na tela.
oGetD:Refresh()

Return .t.

