#Include 'Protheus.ch'

User Function xTeste  // u_xTeste()
	Local aArq := {"CA","CERT","KEY"}

	Certificados( "\_Ideias\","CERTIFICADO.PFX",aArq )


Return

Static Function Certificados( cPatch,cArqCert,aArq )

	Local aArea		:= GetArea()
	Local xcArqCert	:= cPatch+cArqCert
	Local xCertif		:= ""
	Local xError		:= ""
	Local xContent	:= ""
	Local lRet


	For X := 1 To Len( aArq )

		xCertif := cPatch+aArq[X]+".PEM"

		If		X == 1
			lRet := PFXCA2PEM( xcArqCert, xCertif, @xError )
		ElseIf X == 2
		ElseIf X == 3
		EndIf

		If( lRet == .F. )
    		Conout( "Error: " + xError )
  		Else
    		xContent := MemoRead( xCertif )
    		VarInfo( aArq[X], xContent )
  		EndIf

	Next X


	RestArea( aArea )

Return

