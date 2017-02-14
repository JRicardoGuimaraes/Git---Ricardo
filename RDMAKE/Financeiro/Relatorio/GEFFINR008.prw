#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


User Function ANDFIN08		// U_ANDFIN08()

	Local aArea		:=	GetArea()
	Local oReport	:= Nil
	
	Private TRAB	:=	GetNextAlias()	
	
	oReport := ModelReport( oReport )
	oReport:PrintDialog()

	RestArea( aArea )
	
Return

Static Function ModelReport( oReport )
	Local oSection
	Local oBreak

	oReport := TReport():New("GEF008","Relação de PDD","GEF008",{ |oReport| PrintReport( oReport ) },"Relação de PDD")
	oReport:SetLandScape()

	Pergunte(oReport:uParam,.T.)

Return oReport


Static Function ValidPDD
	Local aArea		:= GetArea()
	Local cMes		:= StrZero( Month( MV_PAR05 ) , 2 )
	Local cAno		:= AllTrim( Str( Year( MV_PAR05 ) ) )
	Local DbTrab	:= GetNextAlias()
	Local lRetorno	:= .T.
	
	Local aQuery	
		
	oSection:BeginQuery()			

		BeginSql Alias DbTrab

			Select SUM(Z9_M"+cMes+") AS MESF005053	

 			From %Table:SZ9% SZ9

			Where	(		SZ9.%NotDel%
						And	Z9_FILIAL	= %Exp:xFilial("SZ9")%
						And Z9_ANO		= %Exp:cAno%
					)
		EndSql

	oSection:EndQuery()

	aQuery := GetLastQuery()
	
	If ! DbTrab->( Eof() )
	
		If DbTrab->MES > 0
		
			MsgAlert("A Data do PDD já foi processada."+chr(10)+"Informe outro período!","Atençao!")
			lRetorno := .F.
			
		EndIf		
		
	EndIf
	
	DbTrab->( DbCloseArea() )
			
	RestArea( aArea )
		
Return( lRtorno )



