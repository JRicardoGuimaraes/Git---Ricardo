#Include 'Protheus.ch'

User Function ExTable()
	Local aFields := {}
	Local oTempTable
	Local nI
	Local cAlias := "MEUALIAS"
	Local cQuery
	//-------------------
	//Criação do objeto
	//-------------------
	oTempTable := FWTemporaryTable():New( cAlias )
	//--------------------------
	//Monta os campos da tabela
	//--------------------------
	aadd(aFields,{"DESCR","C",30,0})
	aadd(aFields,{"CONTR","N",3,1})
	aadd(aFields,{"ALIAS","C",3,0})
	oTemptable:SetFields( aFields )
	oTempTable:AddIndex("indice1", {"DESCR"} )
	oTempTable:AddIndex("indice2", {"CONTR", "ALIAS"} )
	//------------------
	//Criação da tabela
	//------------------
	oTempTable:Create()

	conout("Executando a cópia dos registros da tabela: " + RetSqlName("CT0") )
	//--------------------------------------------------------------------------
	//Caso o INSERT INTO SELECT preencha todos os campos, este será um método facilitador
	//Caso contrário deverá ser chamado o InsertIntoSelect():
	// oTempTable:InsertIntoSelect( {"DESCR", "CONTR" } , RetSqlName("CT0") , { "CT0_DESC", "CT0_CONTR" } )
	//--------------------------------------------------------------------------
	oTempTable:InsertSelect( RetSqlName("CT0") , { "CT0_DESC", "CT0_CONTR", "CT0_ALIAS" } )

	//------------------------------------
	//Executa query para leitura da tabela
	//------------------------------------
	cQuery := "select * from "+ oTempTable:GetRealName()
	MPSysOpenQuery( cQuery, 'QRYTMP' )
	DbSelectArea('QRYTMP')
	while !eof()
		for nI := 1 to fcount()
			Alert( varinfo(fieldname(nI),fieldget(ni),,.F.) )
		next
		dbskip()
	Enddo

	//---------------------------------
	//Exclui a tabela
	//---------------------------------
	oTempTable:Delete()

return
