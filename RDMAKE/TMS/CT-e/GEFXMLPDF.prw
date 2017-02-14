#Include "Protheus.CH"


User Function GEFXMLPDF				// u_GEFXMLPDF()
	Local aArea	 := GetArea()

	Private aDados := {}

	Begin Sequence

		aDados := StaticCall( GEFIMPPA7 , CargaXLS )

		If !( aDados[2] )
			Break
		EndIf

		If Len( aDados[1] ) == 0
			Aviso("Atenção","Não existe registros para importação.",{"OK"})
			Break
		EndIf

		Processa( { || _DactePrint() } ,'Aguarde','Processando Informações...',.F.)

	End Sequence

	RestArea( aArea )

Return


Static Function _DactePrint
	Local aArea		:= GetArea()

	Local cDe			:= GetMv("MV_RELFROM")
	Local cPara		:= UsrRetMail( RetCodUsr() )
	Local cCc			:= ''
	Local cAssunto	:= "Log de erro da Impressão das DACTE´S"
	Local cMsg			:= 'Segue em anexo o arquivo com as informações de erro ocorridos na integração.'
	Local cAnexo		:= '\SYSTEM\DACTE.LOG'
	Private cArquivo	:= "DACTE.LOG"

	DbSelectArea("DT6")

	Private _cPathPDF 	:= ''
	Private _cPrinter 	:= ''
	Private lViewPDF		:= .F.
	Private lDisabeSetup	:= .F.

	For X := 1 To Len( aDados[1] )

		ProcRegua(1)

		SM0->( DbSeek( cEmpAnt + aDados[1][X][1] ) )

		MV_PAR53 := StrZero( Val( aDados[1][X][2] ),TamSx3("DT6_DOC")[1] )		// Numero do Documento
		MV_PAR54 := StrZero( Val( aDados[1][X][2] ),TamSx3("DT6_DOC")[1] )		// Numero do Documento
		MV_PAR55 := '5  '																//	Serie do Documento Inicial
		MV_PAR56 := '5  '																//	Serie do Documento Final
		MV_PAR57 := GetAdvFval( "DT6", "DT6_DOCTMS", xFilial("DT6")+aDados[1][X][1]+MV_PAR53+MV_PAR55 , 1 , '' , .T. )
		MV_PAR58 := 2
		MV_PAR59 := 3

		MV_PAR60 := ".T."

		IncProc()

		u_RTMSR27()

		If File( cAnexo )
			u_EnvEmail( cDe , cPara , cCc , cAssunto , cMsg , cAnexo )
			FErase( cAnexo )
		EndIf

	Next X

	RestArea( aArea )

Return( Nil )

