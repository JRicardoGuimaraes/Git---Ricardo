#Include 'Protheus.ch'
#Include 'TbiConn.ch'

/*/{Protheus.doc} GEFINTJOB
Rotina responsável por preparar o ambiente para executar a rotina de importação 
automática através de agendador.
@author 	Luiz Alexandre Ferreira
@since 		01/10/2014
@version 	1.0
@return 	${return}, ${return_description}
@example	(examples)
@see 		(links_or_references)
/*/User Function GEFINTJOB(_aId)

// ---	Variaveis utilizadas
Local _aTables 	:=	{"DF0","DF1","DF2","DF3","DF4","DF5","DUE"}
Local _cIniFile	:= 	GetAdv97()
Local _cEmp		:=	GetPvProfString("FWSCHDMANAG_TOP","Empresa"	,"",_cInIfile)
Local _cFil		:=	GetPvProfString("FWSCHDMANAG_TOP","Filial"	,"",_cInIfile)
Local _cEco		:= 	''   

If Empty(_cEmp) .and. Empty(_cFil)
	_cEmp	:=	'01'
	_cFil	:=	'20'
EndIf


// ---	Verifica se houve erro
If _cEmp == '-1' .Or. _cFil == '-1'  	

	// ---	Exibe mensagem no console do servidor
	Conout('GEFINTJOB - Configuracao invalida, verificar variaveis Empresa e Filial no arquivo .ini nos Jobs')		
	// ---	Retorna falso
	Return .f.	
	
Endif

// ---	Mensagem
Conout('GEFINTJOB Iniciando Job Data : '+Dtoc(Date())+' - Empresa ['+_cEmp+'] Filial ['+_cFil+']')

// ---	Set o ambiente para não consumir licenças
RpcSetType(3)

// ---	Parametros para inicializar o ambiente
If RpcSetEnv( _cEmp/*Empresa*/,_cFil/*Filial*/, /*Usuário*/, /*Senha*/, "TMS"/*Modulo*/, "GEFINTJOB", _aTables)
	ConOut('GEFINTJOB - Ambiente preparado com sucesso!')
EndIf

// _aId := {"601",""}

// --- Trata a interface de acordo com o ID.
If _aId[1] == "55"
	// ---	Chamada da rotina a ser executada
	U_GEFINTCNH("55",.t.)
ElseIf _aId[1] == "601"
	// ---	Chamada da rotina a ser executada      
	U_GEFINTCNH("601",.t.)
ElseIf _aId[1] == "701"
	// ---	Chamada da rotina a ser executada      
	U_GEFINTCNH("701",.t.,_aId[2])
EndIf

// ---	Limpa o ambiente
RpcClearEnv() 

Return