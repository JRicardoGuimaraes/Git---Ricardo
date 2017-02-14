#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "TopConn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIRSTNFSE ºAutor ³Leandro PASSOS (+Solucoes) Data ³20/08/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para inclusão de novos itens no menu aRotinaº±±
±±º          ³O programa tem como objetivo visualizar a NFS-e emitida para º±±
±±º          ³viabilizar a impressao via Internet Explorer.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FATURAMENTO - NFS-e Municipal                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


*------------------------------------------*
User Function FIRSTNFSE
*------------------------------------------*
AADD(aRotina,{"Impressao NFS-e"  ,"U_fLnkNFSe()",0,10})
aArray := aClone(aRotina)
aSvRotina := aClone(aRotina)
  
/*
Parametros do array a Rotina:
1. Nome a aparecer no cabecalho
2. Nome da Rotina associada    
3. Reservado                        
4. Tipo de Transação a ser efetuada:     
	1 - Pesquisa e Posiciona em um Banco de Dados      
	2 - Simplesmente Mostra os Campos                  
	3 - Inclui registros no Bancos de Dados            
	4 - Altera o registro corrente                     
	5 - Remove o registro corrente do Banco de Dados 
5. Nivel de acesso                                   
6. Habilita Menu Funcional 
*/

Return (aRotina)

*---------------------------------------------------*
User Function fLnkNFSe()             
*Chama o link da NFS-e posicionada
*---------------------------------------------------*
/*
https://notacarioca.rio.gov.br/nfse.aspx?ccm=99999999&nf=999999999&cod=XXXXXXXX 
ccm = Inscricao do Prestador de Servicos (sem formato) 
nf = Numero da NFS-e (sem formato). 
cod = Código de Verificacao da NFS-e (sem traço) 
*/

// Ja vem posicionado na SF2 a medida que se clica na grid
Local _cSerie  := SF2->F2_SERIE
Local _cNota   := SF2->F2_DOC
Local _cCCM 	:= AllTrim(SM0->M0_INSCM) 			// Inscricao Municipal
Local _cCod 	:= SF2->F2_CODNFE	// Codigo de verificacao
//Local _cLnk 	:= AllTrim(GetMV("MV_NFSELNK",,"https://notacarioca.rio.gov.br/nfse.aspx?")) // Inicio link NFS-e no site da prefeitura
Local _cLnk 	:= "" //AllTrim(GetMV("MV_NFSELNK")) // Inicio link NFS-e no site da prefeitura
Local aArea		:= GetArea()
                //https://notacarioca.rio.gov.br/nfse.aspx?ccm=02582880&nf=000000025&cod=8NVE-5GA8
// Carioca 		https://notacarioca.rio.gov.br/nfse.aspx?ccm=2002698&nf=900&cod=xxxAXHTA 
// Guarulhos	https://visualizar.ginfes.com.br/report/consultarNota?__report=nfs_ver4&cdVerificacao=955370251&numNota=270&cnpjPrestador=null

If AllTrim(_cCod)==""
	MsgAlert("Nota ainda nao autorizada. Selecione uma nota com codigo de verificacao.")
	Return
Endif

//Monta link completo 
If AllTrim(_cCCM) == "02582880" // Rio de Janeiro  
	// Problemas no reconhecimento do parametro
	_cLnk = "https://notacarioca.rio.gov.br/nfse.aspx?"
	_cLnk += AllTrim("ccm=" + AllTrim(_cCCM) + "&nf=" + AllTrim(_cNota) + "&cod=" + AllTrim(_cCod)) 
ElseIF AllTrim(_cCCM) $ "194161|195267" //Guarulhos VG | VO 
	// Problemas no reconhecimento do parametro
	_cLnk = "https://visualizar.ginfes.com.br/report/consultarNota?__report=nfs_ver4&"
	_cLnk += AllTrim("cdVerificacao=" + AllTrim(_cCod) + "&nf=" + AllTrim(_cNota)) + "&cnpjPrestador=null"     
Else
	MsgAlert("Endereco para consulta NFS-e desta inscricao municipal nao configurado no sistema!")
	Return	
Endif  

RestArea(aArea)

//ShellExecute( "Open", "%PROGRAMFILES%\Internet Explorer\iexplore.exe", _cLnk, "C:\", 1 )  
ShellExecute( "Open", "iexplore.exe", _cLnk, "C:\", 1 )    

MsgAlert("Nota localizada! Por favor, verifique a janela do I.E. que foi aberta.")

Return