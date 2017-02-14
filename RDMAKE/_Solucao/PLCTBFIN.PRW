#include "protheus.ch"
#include "folder.ch"
#include "colors.ch"
#include "Font.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#include "rwmake.ch"

/////////////////////////////////////////////////////////////////////////////////
// Funcao:    PLCTBFIN.PRW                                 |                   //
// Autor:     +Soluções Consultoria                                            //
// Data:      25/04/2011                                                       //
// Descricao: PLANILHA EXCEL FINANCEIRO X CONTABIL                             //
// Empresa  : GEFCO                                                            //
/////////////////////////////////////////////////////////////////////////////////

User Function PLCTBFIN()

// declaracao de variaveis
Private _aArea     := GetArea()
Private _cScript   := ""
Private cPerg      := "PLCTBFIN1_"
Private aRegs      := {}
//Private _cDrive    := GetNewPar("MV_XDRIVE","H:\")
Private _cDrive    := GetNewPar("MV_XDRIVE","U:\")    // D$ on client
Private _aDados    := {}
Private _aCT2      := {}
Private _aCT5      := {}

//Cria a Pasta e copia os arquivos da Integração Excel caso nao exista o arquivo Rezende.exe
If !File(_cDrive+"SigaExcel\Rezende.exe")
	MONTADIR(_cDrive+"SigaExcel")
	CPYS2T("\SigaExcel\Rezende.exe",_cDrive+"SigaExcel",.T. )
Endif

// cria perguntas no SX1
AADD(aRegs,{cPerg,"01","Emissao De? ","Emissao De? ","Emissao De?" ,"MV_CHA","D",008,0,0,"G","","MV_PAR01",""             ,"","","","",""             ,"","","","",""     ,"","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Emissao Até?","Emissao Até?","Emissao Até?","MV_CHB","D",008,0,0,"G","","MV_PAR02",""             ,"","","","",""             ,"","","","",""     ,"","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Cliente De? ","Cliente De? ","Cliente De? ","MV_CHC","C",006,0,0,"G","","MV_PAR03",""             ,"","","","",""             ,"","","","",""     ,"","","","","","","","","","","","","","SA1","",""})
AADD(aRegs,{cPerg,"04","Cliente Até?","Cliente Até?","Cliente Até?","MV_CHD","C",006,0,0,"G","","MV_PAR04",""             ,"","","","",""             ,"","","","",""     ,"","","","","","","","","","","","","","SA1","",""})
AADD(aRegs,{cPerg,"05","Numero  De? ","Numero  De? ","Numero  De? ","MV_CHE","C",006,0,0,"G","","MV_PAR05",""             ,"","","","",""             ,"","","","",""     ,"","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Numero Até? ","Numero Até? ","Numero Até? ","MV_CHF","C",006,0,0,"G","","MV_PAR06",""             ,"","","","",""             ,"","","","",""     ,"","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Prefixo De? ","Prefixo De? ","Prefixo De? ","MV_CHG","C",003,0,0,"G","","MV_PAR07",""             ,"","","","",""             ,"","","","",""     ,"","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Prefixo Até?","Prefixo Até?","Prefixo Até?","MV_CHH","C",003,0,0,"G","","MV_PAR08",""             ,"","","","",""             ,"","","","",""     ,"","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Motivo De?  ","Motivo De?  ","Motivo De?  ","MV_CHG","C",003,0,0,"G","","MV_PAR09",""             ,"","","","",""             ,"","","","",""     ,"","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Motivo Até? ","Motivo Até? ","Motivo Até? ","MV_CHH","C",003,0,0,"G","","MV_PAR10",""             ,"","","","",""             ,"","","","",""     ,"","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Filtra por? ","Filtra por? ","Filtra por? ","MV_CHI","N",001,0,0,"C","","MV_PAR11","Sem Contabil"             ,"Sem Contabil","Sem Contabil","","","Com Contabil"             ,"Com Contabil","Com Contabil","","","Ambos"     ,"Ambos","Ambos","","","","","","","","","","","","","",""})


/*
AADD(aRegs,{cPerg,"09","Lote    De? ","Numero  De? ","Numero  De? ","MV_CHI","C",006,0,0,"G","","MV_PAR04",""             ,"","","","",""             ,"","","","",""     ,"","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Lote   Até? ","Numero Até? ","Numero Até? ","MV_CHJ","C",006,0,0,"G","","MV_PAR05",""             ,"","","","",""             ,"","","","",""     ,"","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Documento De?","Documento De?","Documento De?","MV_CHK","C",006,0,0,"G","","MV_PAR04",""             ,"","","","",""             ,"","","","",""     ,"","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Documento Ate?","Documento Ate?","Documento Ate?","MV_CHL","C",006,0,0,"G","","MV_PAR05",""             ,"","","","",""             ,"","","","",""     ,"","","","","","","","","","","","","","","",""})
*/

ValidPerg(aRegs,cPerg)
If !Pergunte(cPerg,.T.)
	// Retorna
	RestArea(_aArea)
	Return
Endif

// define nome do arquivo...
MONTADIR(_cDrive+"SigaExcel")
MONTADIR(_cDrive+"SigaExcel\Scripts")
_cScript := _cDrive+"SigaExcel\Scripts\"+StrTran(AllTrim(cUserName),"+","")+DTOS(dDataBase)+".txt"
_nHandle := FCreate(_cScript,0)
If _nHandle == -1 .Or. !File(_cScript)
	MsgAlert("Arquivo [" + _cScript + "] nao pode ser criado corretamente. Verifique!")
	_cScript := ""
	Return
Endif


// Inicia Processamento para gerar arquivo de Script
Processa({|| fScript()} , "Gerando Script para Excel...")

// gera planilha
fClose(_nHandle)

// chama rotina do Excel
If !Empty(_cScript)
	// chama excel
	WaitRun(_cDrive+"sigaExcel\rezende.Exe "+_cScript)
	// apaga arquivo temporario
	fErase(_cScript)
Else
	MsgAlert("Problema na geracao do arquivo de script...")
Endif

// retorna
//fErase(_cArqTRX+".dbf"); fErase(_cArqTRX+"_1.cdx")

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fScript()
Local _aColunas := {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP"}

_aDados   := fBuscaTit()  // Títulos

If Len(_aDados) < 1 // Sem dados. Sai.
	Alert("Nao há dados para a geração do Relatório!")
	Return
Endif

// cria linha inicial
_xLin := "AbreExcel;"; fGrvLinha(_xLin,.F.)

_cSheet := "1"

// inicia planilha
_xLin := "Escreve;01;01;£;"+_cSheet+";Arial;05;S;N;N;10;N;"; fGrvLinha(_xLin,.F.)

_zContx  := Len(_aDados) // Total Registros
_nContx  := 0  // Progressao
_xMulti  := 0
_xTempoF := fHoray(Time())
_xTempoI := fHoray(Time())
_xRestT  := 0

_xEstoque   := 0
_xCxMast    := 0
_xInner     := 0
_xTotP      := 0
_xTotPL     := 0
_xTotPLV    := 0
_xTransito  := 0

_nLin     := "00008"
_nTotalT  := 0
_nTotalC2 := 0
_nTotalD2 := 0
_nTotalC5 := 0
_nTotalD5 := 0

procRegua(_zContx)

For _Nx := 1 to Len(_aDados)
	If _xTempoI <> _xTempoF
		_xMulti++
		_xRestT := ((_zContx-_nContx)/(_nContx/_xMulti)) //* (_xTempoF -_xTempoI)
		_xTempoI := fHoray(Time())
	Endif
	
	_nContx++
	IncProc("Gerando Planilha..." + IIF((_nContx/_zContx)*100 <= 99, StrZero((_nContx/_zContx)*100,2), STRZERO(100,3)) + "% - Tempo Estimado [" + fHoraz(_xRestT) + "] ")
	
	// Verifica se processara Com/Sem Contabil
	If MV_PAR11 < 3
		If (_aDados[_Nx,13] == 0 .and. MV_PAR11 == 2) .or. (_aDados[_Nx,13] <> 0 .and. MV_PAR11 == 1)
			_xTempoF := fHoray(Time())			
			Loop
        Endif
	Endif

	// Exibe Cabecalho
	fCabec(_nLin)
	_nLin := Soma1(_nLin)
	_nLin := Soma1(_nLin)
	_nCol := "002"
	
	_xCor := _aDados[_Nx,12]
	// Tipo
	_xLin   := "Escreve;"+_nLin+";"+_nCol+";'"+ _aDados[_Nx,1] +";"+_cSheet+";Arial;08;N;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)
	
	// Tipo MOV
	_xLin   := "Escreve;"+_nLin+";"+_nCol+";'"+ _aDados[_Nx,2] +";"+_cSheet+";Arial;08;N;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)
	
	// Emissao
	_xLin   := "Escreve;"+_nLin+";"+_nCol+";'"+ _aDados[_Nx,3] +";"+_cSheet+";Arial;08;N;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)
	
	// Numero
	_xLin   := "Escreve;"+_nLin+";"+_nCol+";'"+ _aDados[_Nx,4] +";"+_cSheet+";Arial;08;N;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)
	
	// Prefixo
	_xLin   := "Escreve;"+_nLin+";"+_nCol+";'"+ _aDados[_Nx,5] +";"+_cSheet+";Arial;08;N;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)
	
	// Cliente
	_xLin   := "Escreve;"+_nLin+";"+_nCol+";'"+ _aDados[_Nx,6] +";"+_cSheet+";Arial;08;N;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)
	
	// Valor do Titulo
	_nClb   := _nCol
	_xLin   := "Escreve;"+_nLin+";"+_nCol+";"+ STR(_aDados[_Nx,7]) +";"+_cSheet+";Arial;08;N;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)
	_xLin   := "FormataNumeroCelula;"+_nLin+";"+_nClB+";12;2;"+_cSheet+";"; fGrvLinha(_xLin,.F.)
	
	// Saldo Titulo
	_nClb   := _nCol
	_xLin   := "Escreve;"+_nLin+";"+_nCol+";"+ STR(_aDados[_Nx,8]) +";"+_cSheet+";Arial;08;N;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)
	_xLin   := "FormataNumeroCelula;"+_nLin+";"+_nClB+";12;2;"+_cSheet+";"; fGrvLinha(_xLin,.F.)
	
	// Valor Baixado
	_nClb   := _nCol
	_xLin   := "Escreve;"+_nLin+";"+_nCol+";"+ STR(_aDados[_Nx,9]) +";"+_cSheet+";Arial;08;N;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)
	_xLin   := "FormataNumeroCelula;"+_nLin+";"+_nClB+";12;2;"+_cSheet+";"; fGrvLinha(_xLin,.F.)
	
	_xLinCT5 := _nLin

	// Posiciona no relacionamento Financeiro x Contabil
	_nPos   := ASCAN ( _aCT2 , {|X| x[13] = _aDados[_Nx,11]})
	
	// Processa Contabil CT2
	_cChave := "" //_aCT2[_nPos,2]+_aCT2[_nPos,3]+_aCT2[_nPos,4] // Lote+SubLote+Doc
	For _Nz := _nPos to Len(_aCT2)
	    
	 	If _aCT2[_Nz,2] == ""
			_cChave := _aCT2[_Nz,2]+_aCT2[_Nz,3]+_aCT2[_Nz,4]
			Loop
		Endif	
	 
		If _aCT2[_Nz,13] == _aDados[_Nx,11]

			// Verifica se e o mesmo Lote+SubLote+Doc
			If (_aCT2[_Nz,2]+_aCT2[_Nz,3]+_aCT2[_Nz,4]) <> _cChave
				
				If _Nz <> _nPos
					_nLin := Soma1(_nLin)
					_xLin := "Escreve;"+_nLin+";12;Data;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
					_xLin := "Escreve;"+_nLin+";13;Lote;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
					_xLin := "Escreve;"+_nLin+";14;SubLote;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
					_xLin := "Escreve;"+_nLin+";15;Doc;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
					_xLin := "Escreve;"+_nLin+";16;DEBITO;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
					_xLin := "Escreve;"+_nLin+";17;CREDITO;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
					_nLin := Soma1(_nLin)
				Endif
				
				_nCol 	:= "012"
				
				For _Nj := 1 to 6
					If STRZERO(_Nj,1) $ "5|6"
						_nClb   := _nCol
						_xLin   := "Escreve;"+_nLin+";"+_nCol+";"+ STR(_aCT2[_Nz,_Nj]) +";"+_cSheet+";Arial;08;S;N;N;10;N;10;02;"; fGrvLinha(_xLin,.T.)
						_xLin   := "FormataNumeroCelula;"+_nLin+";"+_nClB+";12;2;"+_cSheet+";"; fGrvLinha(_xLin,.F.)
						If STRZERO(_Nj,1) == "5"
							_nTotalD2 += _aCT2[_Nz,_Nj]
						Else
							_nTotalC2 += _aCT2[_Nz,_Nj]
						Endif
					Else
						_xLin   := "Escreve;"+_nLin+";"+_nCol+";'"+ _aCT2[_Nz,_Nj] +";"+_cSheet+";Arial;08;N;N;N;10;N;10;02;"; fGrvLinha(_xLin,.T.)
					Endif
				Next
				_cChave := _aCT2[_Nz,2]+_aCT2[_Nz,3]+_aCT2[_Nz,4]
				_nLin := Soma1(_nLin)
				_nCol 	:= "012"
				_xLin := "Escreve;"+_nLin+";12;Debito;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
				_xLin := "Escreve;"+_nLin+";13;Valor;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
				_xLin := "Escreve;"+_nLin+";14;Credito;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
				_xLin := "Escreve;"+_nLin+";15;Valor;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
				_xLin := "Escreve;"+_nLin+";16;Linha;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
				_xLin := "Escreve;"+_nLin+";17;Historico;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
				_nLin := Soma1(_nLin)
			Endif
			
			_nCol := "012"
			For _Nj := 7 to 12
				If _aCT5[_Nz,_Nj] <> _aCT2[_Nz,_Nj]
					_xCor := "05"
				Else
					_xCor := "10"				
				Endif	

				If STRZERO(_Nj,2) $ "08|10"
					_nClb   := _nCol
					_xLin   := "Escreve;"+_nLin+";"+_nCol+";"+ STR(_aCT2[_Nz,_Nj]) +";"+_cSheet+";Arial;08;S;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)
					_xLin   := "FormataNumeroCelula;"+_nLin+";"+_nClB+";12;2;"+_cSheet+";"; fGrvLinha(_xLin,.F.)
				Else
					_xLin   := "Escreve;"+_nLin+";"+_nCol+";'"+ _aCT2[_Nz,_Nj] +";"+_cSheet+";Arial;08;N;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)
				Endif
			Next
			_nLin := Soma1(_nLin)
		Else
			Exit
		Endif
	Next
	
    _nLinMax := _nLin

	_nLin := _xLinCt5 
	_nCol := "019"

	// Processa Contabil CT5
	// Posiciona no relacionamento Financeiro x Contabil
	_nPos   := ASCAN ( _aCT5 , {|X| x[13] = _aDados[_Nx,11]})
	
	_cChave := "" //_aCT2[_nPos,2]+_aCT2[_nPos,3]+_aCT2[_nPos,4] // Lote+SubLote+Doc
	For _Nz := _nPos to Len(_aCT5)
		
	 	If _aCT5[_Nz,2] == ""
			_cChave := _aCT5[_Nz,2]+_aCT5[_Nz,3]+_aCT5[_Nz,4]
			Loop
		Endif	
	 
		If _aCT5[_Nz,13] == _aDados[_Nx,11]

			// Verifica se e o mesmo Lote+SubLote+Doc
			If (_aCT5[_Nz,2]+_aCT5[_Nz,3]+_aCT5[_Nz,4]) <> _cChave
				
				If _Nz <> _nPos
					_nLin := Soma1(_nLin)
					_xLin := "Escreve;"+_nLin+";19;Data;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
					_xLin := "Escreve;"+_nLin+";20;Lote;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
					_xLin := "Escreve;"+_nLin+";21;SubLote;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
					_xLin := "Escreve;"+_nLin+";22;Doc;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
					_xLin := "Escreve;"+_nLin+";23;DEBITO;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
					_xLin := "Escreve;"+_nLin+";24;CREDITO;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
					_nLin := Soma1(_nLin)
				Endif
				
				_nCol 	:= "019"
				
				For _Nj := 1 to 6
					If STRZERO(_Nj,1) $ "5|6"
						_nClb   := _nCol
						_xLin   := "Escreve;"+_nLin+";"+_nCol+";"+ STR(_aCT5[_Nz,_Nj]) +";"+_cSheet+";Arial;08;S;N;N;10;N;10;02;"; fGrvLinha(_xLin,.T.)
						_xLin   := "FormataNumeroCelula;"+_nLin+";"+_nClB+";12;2;"+_cSheet+";"; fGrvLinha(_xLin,.F.)
						If STRZERO(_Nj,1) == "5"
							_nTotalD5 += _aCT5[_Nz,_Nj]
						Else
							_nTotalC5 += _aCT5[_Nz,_Nj]
						Endif
					Else
						_xLin   := "Escreve;"+_nLin+";"+_nCol+";'"+ _aCT5[_Nz,_Nj] +";"+_cSheet+";Arial;08;N;N;N;10;N;10;02;"; fGrvLinha(_xLin,.T.)
					Endif
				Next
				_cChave := _aCT5[_Nz,2]+_aCT5[_Nz,3]+_aCT5[_Nz,4]
				_nLin := Soma1(_nLin)
				_nCol 	:= "019"
				_xLin := "Escreve;"+_nLin+";19;Debito;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
				_xLin := "Escreve;"+_nLin+";20;Valor;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
				_xLin := "Escreve;"+_nLin+";21;Credito;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
				_xLin := "Escreve;"+_nLin+";22;Valor;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
				_xLin := "Escreve;"+_nLin+";23;Linha;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
				_xLin := "Escreve;"+_nLin+";24;Historico;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
				_nLin := Soma1(_nLin)
			Endif
			
			_nCol := "019"
			For _Nj := 7 to 12
				If _aCT5[_Nz,_Nj] <> _aCT2[_Nz,_Nj]
					_xCor := "01"
				Else
					_xCor := "10"				
				Endif	
				If STRZERO(_Nj,2) $ "08|10"
					_nClb   := _nCol
					_xLin   := "Escreve;"+_nLin+";"+_nCol+";"+ STR(_aCT5[_Nz,_Nj]) +";"+_cSheet+";Arial;08;S;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)
					_xLin   := "FormataNumeroCelula;"+_nLin+";"+_nClB+";12;2;"+_cSheet+";"; fGrvLinha(_xLin,.F.)
				Else
					_xLin   := "Escreve;"+_nLin+";"+_nCol+";'"+ _aCT5[_Nz,_Nj] +";"+_cSheet+";Arial;08;N;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)
				Endif
			Next
			_nLin := Soma1(_nLin)
		Else
			Exit
		Endif
	Next
	
	// Verifica qual a maior linha que sera processada
	If _nLinMax > _nLin
		_nLin := _nLinMax
	Endif	

	_nLin := Soma1(_nLin)
	_nLin := Soma1(_nLin)
	
	_xTempoF := fHoray(Time())
	
	// SubTotal
	If _xCor == "10" 
		_nTotalT	+= _aDados[_Nx,9]
	Else
		_nTotalT	-= _aDados[_Nx,9]
	Endif			
	
Next

_nLin := Soma1(_nLin)
_nLin := Soma1(_nLin)

// Total Geral Titulos
_nCol := "009"

// Total
_xLin   := "Escreve;"+_nLin+";"+_nCol+";'Total;"+_cSheet+";Arial;08;N;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)

_nClb   := _nCol
_xLin   := "Escreve;"+_nLin+";"+_nCol+";"+ STR(_nTotalT) +";"+_cSheet+";Arial;08;S;N;N;10;N;10;02;"; fGrvLinha(_xLin,.T.)
_xLin   := "FormataNumeroCelula;"+_nLin+";"+_nClB+";12;2;"+_cSheet+";"; fGrvLinha(_xLin,.F.)


// Total Geral Titulos
_nCol := "015"

// Total
_xLin   := "Escreve;"+_nLin+";"+_nCol+";'Total;"+_cSheet+";Arial;08;N;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)

_nClb   := _nCol
_xLin   := "Escreve;"+_nLin+";"+_nCol+";"+ STR(_nTotalD2) +";"+_cSheet+";Arial;08;S;N;N;10;N;10;02;"; fGrvLinha(_xLin,.T.)
_xLin   := "FormataNumeroCelula;"+_nLin+";"+_nClB+";12;2;"+_cSheet+";"; fGrvLinha(_xLin,.F.)

_nClb   := _nCol
_xLin   := "Escreve;"+_nLin+";"+_nCol+";"+ STR(_nTotalC2) +";"+_cSheet+";Arial;08;S;N;N;10;N;10;02;"; fGrvLinha(_xLin,.T.)
_xLin   := "FormataNumeroCelula;"+_nLin+";"+_nClB+";12;2;"+_cSheet+";"; fGrvLinha(_xLin,.F.)

// Total Geral Titulos
_nCol := "022"

// Total
_xLin   := "Escreve;"+_nLin+";"+_nCol+";'Total;"+_cSheet+";Arial;08;N;N;N;"+_xCor+";N;10;02;"; fGrvLinha(_xLin,.T.)

_nClb   := _nCol
_xLin   := "Escreve;"+_nLin+";"+_nCol+";"+ STR(_nTotalD5) +";"+_cSheet+";Arial;08;S;N;N;10;N;10;02;"; fGrvLinha(_xLin,.T.)
_xLin   := "FormataNumeroCelula;"+_nLin+";"+_nClB+";12;2;"+_cSheet+";"; fGrvLinha(_xLin,.F.)

_nClb   := _nCol
_xLin   := "Escreve;"+_nLin+";"+_nCol+";"+ STR(_nTotalC5) +";"+_cSheet+";Arial;08;S;N;N;10;N;10;02;"; fGrvLinha(_xLin,.T.)
_xLin   := "FormataNumeroCelula;"+_nLin+";"+_nClB+";12;2;"+_cSheet+";"; fGrvLinha(_xLin,.F.)


_xEmp := "Baixa x Contabil"

// autoformata
_xLin := "AutoFormata;1;040;"+_cSheet+";"; fGrvLinha(_xLin,.F.)

// titulo
_xLin := "Escreve;02;02;LUBRIZOL MÉXICO;"+_cSheet+";Arial;15;S;N;N;10;N;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;03;02;Comparativo Baixa x Contabil;" +_cSheet+";Arial;15;S;N;N;10;N;"; fGrvLinha(_xLin,.F.)

_xLin := "Escreve;04;02;Emissao: ["+ DTOC(dDataBase)+"-"+TIME()+"];"+_cSheet+";Arial;10;S;N;N;10;N;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;05;02;Empresa: ["+ SM0->M0_CODIGO + " - " + AllTrim(SM0->M0_NOME) +"];"+_cSheet+";Arial;10;S;N;N;10;N;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;06;02;Filial: ["+ SM0->M0_CODFIL + " - " + AllTrim(SM0->M0_FILIAL) +"];"+_cSheet+";Arial;10;S;N;N;10;N;"; fGrvLinha(_xLin,.F.)

_xLin := "Escreve;04;05;DataBase: ["+ AllTrim(MV_PAR01) + "];"+_cSheet+";Arial;10;S;N;N;10;N;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;05;05;Emissão de: ["+ DTOC(MV_PAR01) + "] ate [" + DTOC(MV_PAR02) + " ];"+_cSheet+";Arial;10;S;N;N;10;N;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;06;05;Cliente de: ["+ AllTrim(MV_PAR03) + "] ate [" + AllTrim(MV_PAR04) + " ];"+_cSheet+";Arial;10;S;N;N;10;N;"; fGrvLinha(_xLin,.F.)

_xLin := "ConfiguraPagina;P;"+_cSheet+";"; fGrvLinha(_xLin,.F.)

_xLin := "RenomeiaSheet;"+_cSheet+";" + _xEmp + ";"; fGrvLinha(_xLin,.F.)


Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fBuscaTit()
Local _aRet := {}

//  Busca Produtos
_cQry := " SELECT E5_TIPODOC, E5_DATA, E5_PREFIXO, E5_NUMERO, E5_CLIFOR, E5_LOJA, E5_TIPO, E5_VALOR, E5_MOTBX, E5_PARCELA, E5_SEQ, E5_DOCUMEN, E5_HISTOR, E5_MOEDA, E5_TXMOEDA, E5_VLMOED2 "
_cQry += " FROM " + RetSqlName("SE5")
_cQry += " WHERE D_E_L_E_T_ <> '*'  AND "
_cQry += " E5_FILIAL = '"+XFILIAL("SE5")+"' AND "
_cQry += " E5_RECPAG = 'R' AND "
_cQry += " E5_NUMERO <> '      ' AND "
_cQry += " E5_TIPODOC <> 'ES' AND " // Nao Cancelados
_cQry += " E5_MOTBX <> 'DAC' AND " // Eliminacao de RESIDUO
_cQry += " E5_TIPO NOT IN ('PA ','NCP') AND " // Pagamento Antecipado e NCP
_cQry += " E5_CLIFOR BETWEEN '"+MV_PAR03+"' AND '" + MV_PAR04 + "' AND "
_cQry += " E5_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "
_cQry += " E5_NUMERO BETWEEN '"+MV_PAR05+"' AND '" + MV_PAR06 + "' AND "
_cQry += " E5_PREFIXO BETWEEN '"+MV_PAR07+"' AND '" + MV_PAR08 + "' AND "
_cQry += " E5_MOTBX BETWEEN '"+MV_PAR09+"' AND '" + MV_PAR10 + "' "
_cQry += " ORDER BY E5_PREFIXO, E5_NUMERO, E5_CLIFOR, E5_LOJA, E5_DATA "
TCQUERY _cQry NEW ALIAS "TSE5"

_zContx := RfRecCount("TSE5") // Total Registros
_nContx := 0  // Progressao
_xMulti := 0
_xTempoF := fHoray(Time())
_xTempoI := fHoray(Time())
_xRestT  := 0

procRegua(_zContx)

_nCont := 0

WHILE !TSE5->(EOF())
	
	_nCont++ // Contador Numero relacionamento Titulo e Contabil
	
	_lProc := .T.
	If _xTempoI <> _xTempoF
		_xMulti++
		_xRestT := ((_zContx-_nContx)/(_nContx/_xMulti)) //* (_xTempoF -_xTempoI)
		_xTempoI := fHoray(Time())
	Endif
	
	_nContx++
	IncProc("Buscando Dados..." + IIF((_nContx/_zContx)*100 <= 99, StrZero((_nContx/_zContx)*100,2), STRZERO(100,3)) + "% - Tempo Estimado [" + fHoraz(_xRestT) + "] ")
	
	DbSelectArea("SE1")
	DbSetOrder(2)
	DbGoTop()
	_xValorOri := 0                
	_xValorSal := 0 
	If DbSeek(XFILIAL("SE1")+TSE5->E5_CLIFOR+TSE5->E5_LOJA+TSE5->E5_PREFIXO+TSE5->E5_NUMERO+TSE5->E5_PARCELA)
		If SE1->E1_MOEDA == 2
			DbSelectArea("SM2")                 // seleciona arquivo de moeda
			SM2->(DbSetOrder(1))                // muda ordem do índice
			SM2->(DbGoTop())
			If SM2->(DbSeek(SE1->E1_EMISSAO)) 	// posiciona ponteiro
				_TxMoeda := SM2->M2_MOEDA2      // valor da moeda 2 (USS Diário)
			EndIf
		Else
			_TxMoeda := 1
		Endif
		_xValorOri := SE1->E1_VALOR * _TxMoeda
		_xValorSal := SE1->E1_SALDO * _TxMoeda
	Endif
	
	// Calcular o Valor Baixado
	If TSE5->E5_MOTBX $ "NOR|   "
		If TSE5->E5_MOEDA == "02"
			_xSaldo := TSE5->E5_VALOR * TSE5->E5_TXMOEDA
		Else	
			_xSaldo := TSE5->E5_VALOR
		Endif
	Else
		_xSaldo := TSE5->E5_VALOR
	Endif	

	// Armazena Dados
	AADD(_aRet,Array(13))
	_aRet[Len(_aRet),1]   := TSE5->E5_MOEDA+"|"+TSE5->E5_TIPO	// Moeda+Tipo
	_aRet[Len(_aRet),2]   := TSE5->E5_MOTBX			// Motivo
	_aRet[Len(_aRet),3]   := DTOC(STOD(TSE5->E5_DATA))		// Emissao
	_aRet[Len(_aRet),4]   := TSE5->E5_PREFIXO+"|"+TSE5->E5_NUMERO+"|"+TSE5->E5_PARCELA	 	
	_aRet[Len(_aRet),5]   := TSE5->E5_HISTOR  		// Historico
	_aRet[Len(_aRet),6]   := TSE5->E5_CLIFOR 		// Cliente
	_aRet[Len(_aRet),7]   := _xValorOri				// Valor Titulo
	_aRet[Len(_aRet),8]   := _xValorSal				// Saldo Titulo
	_aRet[Len(_aRet),9]   := _xSaldo				// Valor Baixa
	_aRet[Len(_aRet),10]  := TSE5->E5_PARCELA		// Valor Baixa
	_aRet[Len(_aRet),11]  := _nCont                       
	_aRet[Len(_aRet),12]  := "10"                   // Cor	
	
	_nCt2 := 0
	If !TSE5->E5_MOTBX $ "NOR|   " // Baixa Normal
		If TSE5->E5_TIPO $ "NF " 
			_cKey := XFILIAL("SE5")+TSE5->E5_PREFIXO+TSE5->E5_NUMERO+TSE5->E5_PARCELA+TSE5->E5_TIPO+;
			TSE5->E5_CLIFOR+TSE5->E5_LOJA+TSE5->E5_SEQ
			_nCt2 := fGravaCt2("",_cKey,_nCont)
	    	If _nCt2 == 0
				_cKey := XFILIAL("SE5")+LEFT(TSE5->E5_DOCUMEN,13)+TSE5->E5_CLIFOR+TSE5->E5_LOJA+TSE5->E5_SEQ+;
				TSE5->E5_PREFIXO+TSE5->E5_NUMERO+TSE5->E5_PARCELA+TSE5->E5_TIPO+TSE5->E5_LOJA//XFILIAL("SE5")
				_nCt2 := fGravaCt2("",_cKey,_nCont)
	    	Endif	
		ELSEIf TSE5->E5_TIPO $ "NDC" 
			_cKey := XFILIAL("SE5")+TSE5->E5_PREFIXO+TSE5->E5_NUMERO+TSE5->E5_PARCELA+TSE5->E5_TIPO+;
			TSE5->E5_CLIFOR+TSE5->E5_LOJA+TSE5->E5_SEQ+AllTrim(TSE5->E5_DOCUMEN)
			_nCt2 := fGravaCt2("",_cKey,_nCont)
		ELSEIF TSE5->E5_TIPO $ "NCC|RA "	
			_cKey := XFILIAL("SE5")+LEFT(TSE5->E5_DOCUMEN,13)+TSE5->E5_CLIFOR+TSE5->E5_LOJA+TSE5->E5_SEQ+;
			TSE5->E5_PREFIXO+TSE5->E5_NUMERO+TSE5->E5_PARCELA+TSE5->E5_TIPO+TSE5->E5_LOJA//XFILIAL("SE5")
			_nCt2 := fGravaCt2("",_cKey,_nCont)
			If _nCt2 == 0
				_cKey := XFILIAL("SE5")+TSE5->E5_PREFIXO+TSE5->E5_NUMERO+TSE5->E5_PARCELA+TSE5->E5_TIPO+;
				TSE5->E5_CLIFOR+TSE5->E5_LOJA+TSE5->E5_SEQ+AllTrim(TSE5->E5_DOCUMEN)
				_nCt2 := fGravaCt2("",_cKey,_nCont)
			Endif
		Else
			_cKey := XFILIAL("SE5")+TSE5->E5_PREFIXO+TSE5->E5_NUMERO+TSE5->E5_PARCELA+TSE5->E5_TIPO+;
			TSE5->E5_CLIFOR+TSE5->E5_LOJA+TSE5->E5_SEQ
			_nCt2 := fGravaCt2("",_cKey,_nCont)
		Endif
	Else
		If TSE5->E5_TIPO $ "NF |TF |NCC|NDC|RA " 
			_cRecibo := fBuscRec()
			_cKey := _cRecibo+TSE5->E5_PREFIXO+TSE5->E5_NUMERO+TSE5->E5_PARCELA+TSE5->E5_TIPO
			_nCt2 := fGravaCt2("",_cKey,_nCont)
		Else
			_cKey := XFILIAL("SE5")+TSE5->E5_PREFIXO+TSE5->E5_NUMERO+TSE5->E5_PARCELA+TSE5->E5_TIPO+;
			TSE5->E5_CLIFOR+TSE5->E5_LOJA+TSE5->E5_SEQ
			_nCt2 := fGravaCt2("",_cKey,_nCont)
		Endif
	Endif	

	_aRet[Len(_aRet),13]  := _nCt2                   // Lancamentos Contabeis

	// Se achar relacao FINxCTB entao Grava no _aCT5 a simulacao dos processos de lancamento
	_nCt5 := 0
	If _nCT2 <> 0
		_nCt5 := fGravaCt5(_nCont,_aCT2[Len(_aCT2),14])
	Endif	

	// Verifica a quantidade de Linhas entre CT2 e CT5
	If _nCt2 <> _nCt5
		If _nCt2 < _nCt5
			fProcLCt2(_nCt2,_nCt5,_nCont)
		Else	                  
			fProcLCt5(_nCt2,_nCt5,_nCont)
		Endif			
	Else
		If _nCt2 == 0 .and. _nCt5 == 0
			fProcLCt2(1,2,_nCont)	
			fProcLCt5(2,1,_nCont)
		Endif				
	Endif
		
	_nCt2 := 0
	// Verifica se ha cancelamento
	_cQry := " SELECT E5_TIPODOC, E5_DATA, E5_PREFIXO, E5_NUMERO, E5_CLIFOR, E5_LOJA, E5_TIPO, E5_VALOR, E5_MOTBX, E5_PARCELA, E5_SEQ, E5_DOCUMEN, E5_HISTOR, E5_MOEDA, E5_TXMOEDA, E5_VLMOED2 "
	_cQry += " FROM " + RetSqlName("SE5")
	_cQry += " WHERE D_E_L_E_T_ <> '*'  AND "
	_cQry += " E5_FILIAL = '"+XFILIAL("SE5")+"' AND "
	_cQry += " E5_RECPAG = 'P' AND "
	_cQry += " E5_TIPODOC = 'ES' AND "
	_cQry += " E5_NUMERO <> '      ' AND "
	_cQry += " E5_MOEDA  = '" + TSE5->E5_MOEDA   + "' AND "
	_cQry += " E5_CLIFOR = '" + TSE5->E5_CLIFOR  + "' AND "
	_cQry += " E5_LOJA   = '" + TSE5->E5_LOJA    + "' AND "
	_cQry += " E5_NUMERO = '" + TSE5->E5_NUMERO  + "' AND "
	_cQry += " E5_PREFIXO= '" + TSE5->E5_PREFIXO + "' AND "
	_cQry += " E5_TIPO   = '" + TSE5->E5_TIPO    + "' AND "
	_cQry += " E5_SEQ    = '" + TSE5->E5_SEQ     + "' "
	_cQry += " ORDER BY E5_PREFIXO, E5_NUMERO, E5_CLIFOR, E5_LOJA, E5_DATA "
	TCQUERY _cQry NEW ALIAS "XSE5"

	If !XSE5->(EOF())
		_nCont++

		// Calcular o Valor Baixado
		If XSE5->E5_MOTBX $ "NOR|   "
			If XSE5->E5_MOEDA == "02"
				_xSaldo := XSE5->E5_VALOR * XSE5->E5_TXMOEDA
			Else	
				_xSaldo := XSE5->E5_VALOR
			Endif
		Else
			_xSaldo := XSE5->E5_VALOR
		Endif	
	
		// Armazena Dados
		AADD(_aRet,Array(13))
		_aRet[Len(_aRet),1]   := XSE5->E5_MOEDA+"|"+XSE5->E5_TIPO		// Moeda+Tipo
		_aRet[Len(_aRet),2]   := XSE5->E5_MOTBX			// Motivo
		_aRet[Len(_aRet),3]   := DTOC(STOD(XSE5->E5_DATA))		// Emissao
		_aRet[Len(_aRet),4]   := XSE5->E5_PREFIXO+"|"+XSE5->E5_NUMERO+"|"+XSE5->E5_PARCELA	 	
		_aRet[Len(_aRet),5]   := XSE5->E5_HISTOR  		// Historico
		_aRet[Len(_aRet),6]   := XSE5->E5_CLIFOR 		// Cliente
		_aRet[Len(_aRet),7]   := _xValorOri				// Valor Titulo
		_aRet[Len(_aRet),8]   := _xValorSal				// Saldo Titulo
		_aRet[Len(_aRet),9]   := _xSaldo				// Valor Baixa
		_aRet[Len(_aRet),10]  := XSE5->E5_PARCELA		// Valor Baixa
		_aRet[Len(_aRet),11]  := _nCont					// Relacionamento
		_aRet[Len(_aRet),12]  := "05"                   // Cor

//			_cKey := XFILIAL("SE5")+XSE5->E5_PREFIXO+XSE5->E5_NUMERO+XSE5->E5_PARCELA+XSE5->E5_TIPO+;
//			XSE5->E5_CLIFOR+XSE5->E5_LOJA+XSE5->E5_SEQ
//			fGravaCt2("",_cKey,_nCont)
		IF XSE5->E5_TIPO $ "NDC|NF "	
			_cKey := XFILIAL("SE5")+LEFT(XSE5->E5_DOCUMEN,13)+XSE5->E5_CLIFOR+XSE5->E5_LOJA+XSE5->E5_SEQ+;
			XSE5->E5_PREFIXO+XSE5->E5_NUMERO+XSE5->E5_PARCELA+XSE5->E5_TIPO+XSE5->E5_LOJA//XFILIAL("SE5")
			_nCt2 := fGravaCt2("",_cKey,_nCont)
		ELSEIF XSE5->E5_TIPO $ "NCC|RA "	
			_cKey := XFILIAL("SE5")+XSE5->E5_PREFIXO+XSE5->E5_NUMERO+XSE5->E5_PARCELA+XSE5->E5_TIPO+;
			XSE5->E5_CLIFOR+XSE5->E5_LOJA+XSE5->E5_SEQ+AllTrim(XSE5->E5_DOCUMEN)
			_nCt2 := fGravaCt2("",_cKey,_nCont)
		Else
			_cKey := XFILIAL("SE5")+XSE5->E5_PREFIXO+XSE5->E5_NUMERO+XSE5->E5_PARCELA+XSE5->E5_TIPO+;
			XSE5->E5_CLIFOR+XSE5->E5_LOJA+XSE5->E5_SEQ
			_nCt2 := fGravaCt2("",_cKey,_nCont)
		Endif
	
		_aRet[Len(_aRet),13]  := _nCt2                   // Lancamentos Contabeis

	Endif	
	XSE5->(DbCloseArea())
		
	// Se achar relacao FINxCTB entao Grava no _aCT5 a simulacao dos processos de lancamento
	_nCt5 := 0
	If _nCT2 <> 0
		_nCt5 := fGravaCt5(_nCont,_aCT2[Len(_aCT2),14])
	Endif	

	// Verifica a quantidade de Linhas entre CT2 e CT5
	If _nCt2 <> _nCt5
		If _nCt2 < _nCt5
			fProcLCt2(_nCt2,_nCt5,_nCont)
		Else	                  
			fProcLCt5(_nCt2,_nCt5,_nCont)
		Endif			
	Else
		If _nCt2 == 0 .and. _nCt5 == 0
			fProcLCt2(1,2,_nCont)	
			fProcLCt5(2,1,_nCont)
		Endif				
	Endif
	
	_xTempoF := fHoray(Time())
	
	TSE5->(DbSkip())
END

TSE5->(DbCloseArea())

Return(_aRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fGrvLinha(_cLin,_lCol)
_cLin += (CHR(13)+CHR(10))
fWrite(_nHandle,_cLin,Len(_cLin))
If _lCol; _nCol := Soma1(_nCol); Endif
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function rfRecCount(_cAlias)
Local _nRet := 0
DbSelectArea(_cAlias)
DbGoTop()
While !EOF()
	_nRet++
	DbSkip()
End
DbGoTop()
Return(_nRet)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDescr(_cDescricao)
Local _cRet := _cDescricao
If AT(",",_cDescricao) > 0
	_cRet := STRTRAN(_cDescricao,","," ")
Endif
If AT(";",_cRet) > 0
	_cRet := STRTRAN(_cDescricao,";"," ")
Endif
Return(_cRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg(aRegs,cPerg)
dbSelectArea("SX1")
dbSetOrder(1)
For i := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		msUnLock()
	EndIf
Next
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fHoray()
Local _yTotT
_xTime := AllTrim(time())
_xHora := Val(SUBSTR(_xTime,1,2)) * 3600
_xMinu := Val(SUBSTR(_xTime,4,2)) * 60
_xSegu := Val(SUBSTR(_xTime,7,2))
_yTotT := _xHora + _xMinu + _xSegu
Return(_yTotT)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fHoraz(_nTotHor)
Local _cRet := ""
If INT(_nTotHor) >59 .and. INT(_nTotHor) < 3600
	_xMinu := _nTotHor / 60
	_cRet := "00:" + STRZERO(Int(_xMinu),2)+":" + STRZERO(100*(_xMinu-Int(_xMinu))/1.6666,2)
Else
	_cRet := "00:00:" + STRZERO(Int(IIF(_nTotHor < 1,1,_nTotHor)),2)
Endif
Return(_cRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDescry(_cDescricao)
Local _cRet  := ""
Local _nI
Local _cChar := "01234567890ABCDEFGHIJKLMNOPQRSTUVXYWZ()/#@!?<>|&%+=[]{} "
For _nI := 1 To Len(_cDescricao)
	If Substr(_cDescricao,_nI,1) $ _cChar
		_cRet += Substr(_cDescricao,_nI,1)
	Else
		_cRet += " "
	Endif
Next
Return(_cRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fGravaCT2(_cRotina,_cKey,_nCont)

_cQry := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_DEBITO, CT2_CREDIT, CT2_LINHA, CT2_HIST, CT2_DC, CT2_VALOR, CT2_LP "
_cQry += " FROM " + RetSqlName("CT2")
_cQry += " WHERE D_E_L_E_T_ <> '*'  AND "
_cQry += " CT2_FILIAL = '"+XFILIAL("SE5")+"' AND "
_cQry += " CT2_MOEDLC = '01' AND "
_cQry += " CT2_TPSALD = '1' AND "
//_cQry += " RTRIM(CT2_ROTINA) = '"+_cRotina+"'  AND "
_cQry += " LEFT(CT2_KEY,"+AllTrim(Str(Len(AlLTrim(_cKey))))+") = '"+AlLTrim(_cKey)+"' "
_cQry += " ORDER BY CT2_DATA, CT2_LINHA "
TCQUERY _cQry NEW ALIAS "TCT2"

_nTotDeb := 0
_nTotCre := 0
_nPos    := 0

WHILE !TCT2->(EOF())
	AADD(_aCT2,Array(14))
	_nPos++
	
	If _nPos == 1;_nPosCT2 := Len(_aCT2);Endif
	
	_aCT2[Len(_aCT2),1]   := DTOC(STOD(TCT2->CT2_DATA))	// Data
	_aCT2[Len(_aCT2),2]   := TCT2->CT2_LOTE			// Lote
	_aCT2[Len(_aCT2),3]   := TCT2->CT2_SBLOTE		// SbLote
	_aCT2[Len(_aCT2),4]   := TCT2->CT2_DOC		 	// Doc
	_aCT2[Len(_aCT2),5]   := 0					 	// Total Debito
	_aCT2[Len(_aCT2),6]   := 0					 	// Total Credito
	_aCT2[Len(_aCT2),7]   := Alltrim(TCT2->CT2_DEBITO)		// Debito
	_aCT2[Len(_aCT2),8]   := Round(IIF(TCT2->CT2_DC $ "1|3",TCT2->CT2_VALOR,0),2)		// Valor
	_aCT2[Len(_aCT2),9]   := Alltrim(TCT2->CT2_CREDIT)		// Credito
	_aCT2[Len(_aCT2),10]   := Round(IIF(TCT2->CT2_DC $ "2|3",TCT2->CT2_VALOR,0),2)		// Valor
	_aCT2[Len(_aCT2),11]   := TCT2->CT2_LINHA		 	// Linha
	_aCT2[Len(_aCT2),12]   := AlLtrim(TCT2->CT2_HIST)			// Historico
	_aCT2[Len(_aCT2),13]   := _nCont					// Relacionamento com Titulo
	_aCT2[Len(_aCT2),14]   := TCT2->CT2_LP				// Lancamento Padrao
	
	_nTotDeb +=  _aCT2[Len(_aCT2),8]
	_nTotCre +=  _aCT2[Len(_aCT2),10]
	
	TCT2->(DbSkip())
END

// Armanzena o Total na 1.a linha
If _nPos <> 0
	_aCT2[_nPosCt2,5]   := _nTotDeb			 	// Total Debito
	_aCT2[_nPosCt2,6]   := _nTotCre			 	// Total Credito
Endif

TCT2->(DbCloseArea())
ReTurn(_nPos)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fGravaCT5(_nCont, _cLanPad)

_cQry := " SELECT CT5_LANPAD, CT5_SEQUEN, CT5_DC, CT5_DEBITO, CT5_CREDIT, CT5_VLR01, CT5_VLR02, CT5_HIST "
_cQry += " FROM " + RetSqlName("CT5")
_cQry += " WHERE D_E_L_E_T_ <> '*'  AND "
_cQry += " CT5_FILIAL = '"+XFILIAL("CT5")+"' AND "
_cQry += " CT5_LANPAD = '"+Alltrim(_cLanPad)+"' "
_cQry += " ORDER BY CT5_LANPAD, CT5_SEQUEN "
TCQUERY _cQry NEW ALIAS "TCT5"

_nTotDeb := 0
_nTotCre := 0
_nPos    := 0

// Posiciona na Baixa
DbSelectArea("SE5")
DbSetOrder(2)
DbGotop()
DbSeek(XFILIAL("SE5")+TSE5->E5_TIPODOC+TSE5->E5_PREFIXO+TSE5->E5_NUMERO+TSE5->E5_PARCELA+;
TSE5->E5_TIPO+TSE5->E5_DATA+TSE5->E5_CLIFOR+TSE5->E5_LOJA+TSE5->E5_SEQ)

// Posiciona na Titulo
DbSelectArea("SE1")
DbSetOrder(2)
DbGotop()
DbSeek(XFILIAL("SE1")+TSE5->E5_CLIFOR+TSE5->E5_LOJA+TSE5->E5_PREFIXO+TSE5->E5_NUMERO+;
TSE5->E5_PARCELA+TSE5->E5_TIPO)

// Posiciona no Recibo
DbSelectArea("SEL")
DbSetOrder(1)
DbGotop()
DbSeek(XFILIAL("SEL")+TSE5->E5_PREFIXO+TSE5->E5_NUMERO+TSE5->E5_PARCELA+TSE5->E5_TIPO+TSE5->E5_CLIFOR+TSE5->E5_LOJA)

// Posiciona no Cliente
DbSelectArea("SA1")
DbSetOrder(1)
DbGotop()
DbSeek(XFILIAL("SA1")+TSE5->E5_CLIFOR+TSE5->E5_LOJA)

WHILE !TCT5->(EOF())

	If &(TCT5->CT5_VLR01) > 0 
		AADD(_aCT5,Array(13))
		_nPos++
		
		If _nPos == 1;_nPosCT5 := Len(_aCT5);Endif
		
		If ValType(&(TCT5->CT5_DEBITO)) == "N"
			_xDebito := AllTrim(STR(&(TCT5->CT5_DEBITO)))
		Else
			_xDebito := AllTrim(&(TCT5->CT5_DEBITO))
		Endif				

		If ValType(&(TCT5->CT5_CREDIT)) == "N"
			_xCredit := AllTrim(STR(&(TCT5->CT5_CREDIT)))
		Else
			_xCredit := AllTrim(&(TCT5->CT5_CREDIT))
		Endif				

		_aCT5[Len(_aCT5),1]   := "XX/XX/XX"				// Data
		_aCT5[Len(_aCT5),2]   := "XXXXXX"				// Lote
		_aCT5[Len(_aCT5),3]   := "XXX" 					// SbLote
		_aCT5[Len(_aCT5),4]   := "XXXXXX"			 	// Doc
		_aCT5[Len(_aCT5),5]   := 0					 	// Total Debito
		_aCT5[Len(_aCT5),6]   := 0					 	// Total Credito
		_aCT5[Len(_aCT5),7]   := _xDebito				// Debito
		_aCT5[Len(_aCT5),8]   := Round(IIF(TCT5->CT5_DC $ "1|3",&(TCT5->CT5_VLR01),0),2)		// Valor
		_aCT5[Len(_aCT5),9]   := _xCredit				// Credito
		_aCT5[Len(_aCT5),10]  := Round(IIF(TCT5->CT5_DC $ "2|3",&(TCT5->CT5_VLR01),0),2)		// Valor
		_aCT5[Len(_aCT5),11]  := STRZERO(_nPos,3)		 	// Linha
		_aCT5[Len(_aCT5),12]  := Alltrim(&(TCT5->CT5_HIST))			// Historico
		_aCT5[Len(_aCT5),13]  := _nCont					// Relacionamento com Titulo

		_nTotDeb +=  _aCT5[Len(_aCT5),8]
		_nTotCre +=  _aCT5[Len(_aCT5),10]
	Endif	
		
	TCT5->(DbSkip())
END

// Armanzena o Total na 1.a linha
If _nPos <> 0
	_aCT5[_nPosCt5,5]   := _nTotDeb			 	// Total Debito
	_aCT5[_nPosCt5,6]   := _nTotCre			 	// Total Credito
Endif

TCT5->(DbCloseArea())
ReTurn(_nPos)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fCabec(_nLin)
_xLin := "Escreve;"+_nLin+";02;Financeiro;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";03;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";04;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";05;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";06;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";07;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";08;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";09;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";10;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "MergeCelulas;"+_nLin+";002;"+_nLin+";010;"+_cSheet+";"; fGrvLinha(_xLin,.F.)

_xLin := "Escreve;"+_nLin+";11;'X;"					+_cSheet+";Arial;08;S;N;N;10;N;10;02;"; fGrvLinha(_xLin,.F.)

_xLin := "Escreve;"+_nLin+";12;Contabil - CT2;"	+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";13;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";14;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";15;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";16;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";17;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "MergeCelulas;"+_nLin+";012;"+_nLin+";017;"+_cSheet+";"; fGrvLinha(_xLin,.F.)

_xLin := "Escreve;"+_nLin+";18;'X;"					+_cSheet+";Arial;08;S;N;N;10;N;10;02;"; fGrvLinha(_xLin,.F.)

_xLin := "Escreve;"+_nLin+";19;Contabil - REGRA - CT5;"	+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";20;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";21;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";22;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";23;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";24;;"					+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "MergeCelulas;"+_nLin+";019;"+_nLin+";024;"+_cSheet+";"; fGrvLinha(_xLin,.F.)
_nLin := Soma1(_nLin)

// Campos
_xLin := "Escreve;"+_nLin+";02;Moeda|Tipo;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";03;Tipo Mov;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";04;Emissao;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";05;Pre|Num|Par;"		+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";06;Historico;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";07;Cliente;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";08;Valor Titulo;"		+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";09;Valor Saldo;"		+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";10;Valor Baixado;"		+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)

_xLin := "Escreve;"+_nLin+";11;'X;"					+_cSheet+";Arial;08;S;N;N;10;N;10;02;"; fGrvLinha(_xLin,.F.)

_xLin := "Escreve;"+_nLin+";12;Data;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";13;Lote;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";14;SubLote;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";15;Doc;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";16;DEBITO;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";17;CREDITO;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)

_xLin := "Escreve;"+_nLin+";18;'X;"					+_cSheet+";Arial;08;S;N;N;10;N;10;02;"; fGrvLinha(_xLin,.F.)

_xLin := "Escreve;"+_nLin+";19;Data;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";20;Lote;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";21;SubLote;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";22;Doc;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";23;DEBITO;"				+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_xLin := "Escreve;"+_nLin+";24;CREDITO;"			+_cSheet+";Arial;08;S;N;N;10;N;10;15;"; fGrvLinha(_xLin,.F.)
_nLin := Soma1(_nLin)
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fBuscRec()
Local _cRet := ""
_cQry := " SELECT EL_RECIBO, EL_TIPODOC "
_cQry += " FROM " + RetSqlName("SEL")
_cQry += " WHERE D_E_L_E_T_ <> '*'  AND "
_cQry += " EL_FILIAL  = '" + XFILIAL("SEL")   + "' AND "
_cQry += " EL_TIPO    = '" + TSE5->E5_TIPO    + "' AND "
_cQry += " EL_PREFIXO = '" + TSE5->E5_PREFIXO + "' AND "
_cQry += " EL_NUMERO  = '" + TSE5->E5_NUMERO  + "' AND "
_cQry += " EL_CLIORIG = '" + TSE5->E5_CLIFOR  + "' AND "
_cQry += " EL_LOJORIG = '" + TSE5->E5_LOJA    + "' AND "
_cQry += " EL_PARCELA = '" + TSE5->E5_PARCELA + "' AND "
_cQry += " EL_DTDIGIT = '" + TSE5->E5_DATA    + "' "
TCQUERY _cQry NEW ALIAS "TSEL"

If !TSEL->(EOF())
	_cRet := XFILIAL("SEL")+TSEL->EL_RECIBO+TSEL->EL_TIPODOC
Endif   
TSEL->(DbCloseArea())
Return(_cRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function  fProcLCT5(_nCt2,_nCt5,_nCont)
	For _Nh := 1 to (_nCt2 - _nCt5)
		AADD(_aCT5,Array(13))
		_aCT5[Len(_aCT5),1]   := "01/01/01"
		_aCT5[Len(_aCT5),2]   := ""
		_aCT5[Len(_aCT5),3]   := ""
		_aCT5[Len(_aCT5),4]   := ""
		_aCT5[Len(_aCT5),5]   := 0					 	// Total Debito
		_aCT5[Len(_aCT5),6]   := 0					 	// Total Credito
		_aCT5[Len(_aCT5),7]   := ""
		_aCT5[Len(_aCT5),8]   := 0
		_aCT5[Len(_aCT5),9]   := ""
		_aCT5[Len(_aCT5),10]   := 0
		_aCT5[Len(_aCT5),11]   := ""
		_aCT5[Len(_aCT5),12]   := ""
		_aCT5[Len(_aCT5),13]   := _nCont					// Relacionamento com Titulo
	Next	
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function  fProcLCT2(_nCt2,_nCt5,_nCont)
	For _Nh := 1 to (_nCt5 - _nCt2)
		AADD(_aCT2,Array(14))
		_aCT2[Len(_aCT2),1]   := "01/01/01"
		_aCT2[Len(_aCT2),2]   := ""
		_aCT2[Len(_aCT2),3]   := ""
		_aCT2[Len(_aCT2),4]   := ""
		_aCT2[Len(_aCT2),5]   := 0					 	// Total Debito
		_aCT2[Len(_aCT2),6]   := 0					 	// Total Credito
		_aCT2[Len(_aCT2),7]   := ""
		_aCT2[Len(_aCT2),8]   := 0
		_aCT2[Len(_aCT2),9]   := ""
		_aCT2[Len(_aCT2),10]   := 0
		_aCT2[Len(_aCT2),11]   := ""
		_aCT2[Len(_aCT2),12]   := ""
		_aCT2[Len(_aCT2),13]   := _nCont					// Relacionamento com Titulo
		_aCT2[Len(_aCT2),14]   := "X"	
	Next	
Return	