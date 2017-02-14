#Include 'Protheus.ch'

User Function LerXml()

	Local aArea := GetArea()
	Local _cArqColab := 'C:\_Cert\NeoGrid\Processados'
	Local nHandle

	nHandle := FT_FUse(_cArqColab + "199_20161130105712924_0001_6740.xml")

	If nHandle = -1
		Return
	EndIf

	FT_FGoTop()

	While ! FT_FEOF()

		cLine  := FT_FReadLn()
		nRecno := FT_FRecno()

		FT_FSKIP()

	End While

	RestArea( aArea )

	FT_FUSE()

Return
