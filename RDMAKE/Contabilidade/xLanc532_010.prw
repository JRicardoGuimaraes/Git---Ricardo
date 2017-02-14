#Include "Protheus.CH"

User Function xLanc532_010
	Local aArea  := GetArea()
	Local _nValor
	
	If (	FunName()					$ 'FINA290'		.Or. ;
			AllTrim(SE5->E5_TIPO)		$ "TX|INS|ISS"	 ;
			)
				
		_nValor := 0
		
	Else
	
		If SE2->E2_MOEDA # 1
			_nValor := Formula("L52")
		Else
			_nValor := SE5->(E5_VALOR+E5_VLDESCO) - SE5->(E5_VLJUROS+E5_VLMULTA)
		EndIf
		
	EndIf
	
	RestArea( aArea )

Return( _nValor )
