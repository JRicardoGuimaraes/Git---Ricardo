#include 'parmtype.ch'
#include "protheus.ch"
#include "APWEBSRV.CH"

/* -------------------------------------------------------------
Fonte WSSRV01.PRW 
Autor Julio Wittwer
Data 10/06/2015
Descrição Fonte de exemplo de Web Services Server com 
 recebimento e retorno de tipos complexos 
 e array de tipos complexos
------------------------------------------------------------- */

// Estutura de dados de um atleta
// CPF, Nome, Aniversário ( obrigatorios ) 
// peso e altura ( opcionais )
WSSTRUCT ATLETA
 
 WSDATA CPF as STRING
 WSDATA Nome as STRING
 WSDATA Nascim as DATE 
 WSDATA PesoKg as FLOAT OPTIONAL
 WSDATA Altura as FLOAT OPTIONAL
ENDWSSTRUCT
// Estrutura de dados de um torneio 
// Descrição, data de inicio e término, e array de atletas participantes
WSSTRUCt TORNEIO
 WSDATA Descricao as STRING
 WSDATA Inicio as DATE
 WSDATA Final as DATE 
 WSDATA Atletas as ARRAY OF ATLETA
 
ENDWSSTRUCT

// Todas as propriedades declaradas nas estruturas (WSDATA) por default são obrigatórias. Para tornar uma propriedade opcional, usamos a palavra reservada “OPTIONAL” após o tipo da propriedade. Feita a declaração das estruturas, vamos agora para a prototipação da classe.
// Prototipação do WebServices
// Serviço de cadastro de torneios esportivos
WSSERVICE TORNEIOS DESCRIPTION "Torneios Esportivos"
 
 // propriedades de entrada e retorno, usados 
 // como parametros ou retornos nos metodos
 
 WSDATA TorneioIn 	AS TORNEIO 
 WSDATA Status 		AS INTEGER
 WSDATA RetCli 		AS STRING
 WSDATA ParamCli	AS STRING 
 
 // Metodos do WebService
 WSMETHOD Incluir
 WSMETHOD ConsultaCli
ENDWSSERVICE

// Por enquanto o WebService vai apenas receber os dados completos de um torneio. O foco do exemplo é justamente como os dados serão recebidos, e como você poderá enviá-los através de um Web Service client em AdvPL criado pela geração de classe client do TDS ou pela nova classe tWSDLManager. O exemplo não abrange a persistência das informações em base de dados. Agora, vamos implementar o método “Incluir” neste fonte:
// Metodo de inclusao. Recebe um Torneio com todos os dados 
// e o array de atletas, e retorna um status numerico ( 0 = sucesso )
WSMETHOD Incluir WSRECEIVE TorneioIn WSSEND Status WSSERVICE TORNEIOS 
 
// Vamos ver tudo o que chegou como parametro
// varinfo("TorneioIn",::TorneioIn) 
 
/*
TorneioIn -> OBJECT ( 4) [...]
 TorneioIn:ATLETAS -> ARRAY ( 2) [...]
 TorneioIn:ATLETAS[1] -> OBJECT ( 5) [...]
 TorneioIn:ATLETAS[1]:ALTURA -> U ( 1) [ ]
 TorneioIn:ATLETAS[1]:CPF -> C ( 12) [123456789-09]
 TorneioIn:ATLETAS[1]:NASCIM -> D ( 8) [02/02/81]
 TorneioIn:ATLETAS[1]:NOME -> C ( 13) [Joao da Silva]
 TorneioIn:ATLETAS[1]:PESOKG -> N ( 15) [ 72.5000]
 TorneioIn:ATLETAS[2] -> OBJECT ( 5) [...]
 TorneioIn:ATLETAS[2]:ALTURA -> U ( 1) [ ]
 TorneioIn:ATLETAS[2]:CPF -> C ( 12) [111111111-11]
 TorneioIn:ATLETAS[2]:NASCIM -> D ( 8) [03/03/80]
 TorneioIn:ATLETAS[2]:NOME -> C ( 13) [Jose da Silva]
 TorneioIn:ATLETAS[2]:PESOKG -> N ( 15) [ 75.2000]
 TorneioIn:DESCRICAO -> C ( 16) [Torneio de Teste]
 TorneioIn:FINAL -> D ( 8) [06/29/15]
 TorneioIn:INICIO -> D ( 8) [06/28/15]
*/
 
// com isso conseguimos montar facilmente o codigo AdvPl para tratar os dados 
// recebidos nesta propriedade. Logo abaixo, eu mostro na tela de console do 
// TOTVS App server a descricao do torneio recebida, e o nome dos atletas recebidos
conout("Torneio : "+TorneioIn:DESCRICAO)
conout("Atletas : "+cValToChar( len(TorneioIn:ATLETAS) ))
For nI := 1 to len(TorneioIn:ATLETAS)
 conout(TorneioIn:ATLETAS[nI]:Nome)
Next
// Caso o processamento seja concluido com sucesso, 
// alimentamos a propriedade de retorno com 0
// em caso de falha, podemos usar um ou mais numeros negativos para indicar
// uma impossibilidade de processamento, como um torneio na mesma data....
::Status := 0
Return .T.

WSMETHOD ConsultaCli WSRECEIVE ParamCli 		WSSEND RetCli WSSERVICE TORNEIOS
::RetCli := "TESTE" //U_FTSTSP()
Return .T.
