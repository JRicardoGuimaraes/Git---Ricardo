#INCLUDE "rwmake.ch"

User Function GEFLOGLT2


	/* //Buscar o nome dos arquivos contidos no DIR para importar um por um e verificar as datas
	_aArqsNF  := Directory(_cPath + _cPrefNF  + "*.TXT")
	For _nN := 1 to Len(_aArqsNF)
		_cPathAux   := _cPath + _aArqsNF[_nN,1]
		// Mover o arquivo para a pasta de Backup
		__CopyFile(_cPathAux,_cPathAuxBk)
		
		// Apago o arquivo na origem
		Ferase(_cPathAux)
	Next _nN*/
Private cArqTxt := "D:\users\u266929\My Documents\Sistemas\smartclient\ARQUIVO.TXT"
Private nHdl    := fOpen(cArqTxt,68)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return
Endif

Processa({|| RunCont() },"Processando...")

Return

//FunГЦo para importar os dados do arquivo TXT
Static Function RunCont

Local nTamFile, nTamLin, cBuffer, nBtLidos

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 2+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile) // Numero de registros a processar

While nBtLidos >= nTamLin

    //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё Incrementa a regua                                                  Ё
    //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

    IncProc()


    //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё Grava os campos obtendo os valores da linha lida do arquivo texto.  Ё
    //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

dbSelectArea(cString)
RecLock(cString,.T.)

    TXT->??_FILIAL := Substr(cBuffer,01,02)

MSUnLock()

    //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    //Ё Leitura da proxima linha do arquivo texto.                          Ё
    //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto

    dbSkip()
EndDo

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё O arquivo texto deve ser fechado, bem como o dialogo criado na fun- Ё
//Ё cao anterior.                                                       Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

fClose(nHdl)
Close(oLeTxt)

Return
