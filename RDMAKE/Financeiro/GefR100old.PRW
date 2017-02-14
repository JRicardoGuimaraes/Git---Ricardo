#include "PROTHEUS.CH"
#include "RWMAKE.CH"
#include "tOPCONN.ch"

User Function GefR100()
/*/f/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
<Descricao> : Programa de impressao boletos especifico GEFCO - Layout Banco Real
<Autor> : Edson Maricate
<Data> : 03/01/2007
<Parametros> : Nenhum
<Retorno> : Nil
<Processo> : Cobranca - Impressao de boleto
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : E
<Obs> :
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/

Local aArea		:= GetArea()
Local lOk		:= .F.
Local lEnd		:= .F.
Local nt
Private cCadastro := "Boleto de cobrança banco real"
Private nLin	:= 10000

AjustSX1()

oPrint := U_DItPrtIni(cCadastro,.F.,2,.F.,@lOk,"_GR010")


If lOk
	RptStatus( {|lEnd| ProcR100(@lEnd,oPrint)})
	U_DItPrtEnd(oPrint)
EndIf

RestArea(aArea)

Return


Static Function ProcR100(lEnd,oPrint)
Local lImU_DItnt := .F.
Local lContinua	:= .F.
Local cIndexName	:= Criatrab(Nil,.F.)
Local cIndexKey	:= "E1_FILIAL+E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
Local cFilter		:= ""
Local nDoctos		:= 0
Local nVlrBruto 	:= 0
Local nVlrDesc 	:= 0
Local nTotLiq 		:= 0
LOCAL aBolText     := {"Após o vencimento cobrar multa de R$ "                ,;
"Mora Diaria de R$ "                                   ,;
"",;
""}


cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And."
cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And."
cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
cFilter		+= "E1_PORTADO>='" + MV_PAR07 + "'.And.E1_PORTADO<='" + MV_PAR08 + "'.And."
cFilter		+= "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR10 + "'.And."
cFilter		+= "E1_LOJA>='" + MV_PAR11 + "'.And.E1_LOJA<='"+MV_PAR12+"'.And."
cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par13)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par14)+"'.And."
cFilter		+= 'DTOS(E1_VENCREA)>="'+DTOS(mv_par15)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par16)+'".And.'
cFilter		+= "E1_NUMBOR>='" + MV_PAR17 + "'.And.E1_NUMBOR<='" + MV_PAR18 + "'.And."
cFilter		+= "!(E1_TIPO$'"+MVABATIM+"').And.E1_PORTADO<>'   '"

SM0->(dbSeek(cEmpAnt+cFilAnt))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o filtro                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
dbSelectArea("SE1")
dbSeek(xFilial())

@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
@ 180,310 BMPBUTTON TYPE 01 ACTION (lContinua := .T.,Close(oDlg))
@ 180,280 BMPBUTTON TYPE 02 ACTION (lContinua := .F.,Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do relatorio                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lContinua
	aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
	SM0->M0_ENDCOB                                     ,; //[2]Endereço
	AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
	"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
	"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
	"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
	Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
	Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
	"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
	Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E
	
	
	SetPrtTit("GEFCO LOGISTICA DO BRASIL LTDA.")
	dbSelectArea("SE1")
	dbSeek(xFilial())
	SetRegua(LastRec())
	While !Eof()
		IncRegua()
		If Marked("E1_OK")
			nDoctos		:= 0
			nVlrBruto 	:= 0
			nVlrDesc 	:= 0
			nTotLiq 	:= 0
			
			//Posiciona o SA6 (Bancos)
			DbSelectArea("SA6")
			DbSetOrder(1)
			DbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,.T.)
			
			//Posiciona na Arq de Parametros CNAB
			DbSelectArea("SEE")
			DbSetOrder(1)
			DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
			
			//Posiciona o SA1 (Cliente)
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
			
			DbSelectArea("SE1")
			aDadosBanco  := {SA6->A6_COD                        ,; 							// [1]Numero do Banco
			SA6->A6_NOME      	            	                  ,; 	// [2]Nome do Banco
			SUBSTR(SA6->A6_AGENCIA, 1, 4)                        ,; 		// [3]Agência
			SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1),; 	// [4]Conta Corrente
			SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)  ,; 	// [5]Dígito da conta corrente
			" "                                              		}		// [6]Codigo da Carteira

			If Empty(SA1->A1_ENDCOB)
				aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razão Social
				AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
				AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endereço
				AllTrim(SA1->A1_MUN )                            ,;  			// [4]Cidade
				SA1->A1_EST                                      ,;     		// [5]Estado
				SA1->A1_CEP                                      ,;      	// [6]CEP
				SA1->A1_CGC										          ,;  			// [7]CGC
				SA1->A1_PESSOA										}       				// [8]PESSOA
			Else
				aDatSacado   := {AllTrim(SA1->A1_NOME)            	 ,;   	// [1]Razão Social
				AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]Código
				AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
				AllTrim(SA1->A1_MUNC)	                             ,;   	// [4]Cidade
				SA1->A1_ESTC	                                     ,;   	// [5]Estado
				SA1->A1_CEPC                                        ,;   	// [6]CEP
				SA1->A1_CGC												 		 ,;		// [7]CGC
				SA1->A1_PESSOA												 }				// [8]PESSOA
			Endif
			
			
			nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
			
			cNroDoc	:= StrZero(	Val(Alltrim(SE1->E1_NUM)+Alltrim(SE1->E1_PARCELA)),8)
			
			aCB_RN_NN    :=  Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",Subs(aDadosBanco[3],1,4),aDadosBanco[4],aDadosBanco[5],aDadosBanco[6],AllTrim(E1_NUM)+AllTrim(E1_PARCELA),(E1_VALOR-nVlrAbat),SE1->E1_VENCTO,Str(SE1->(RecNo())))
			
			aDadosTit	:= {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)		,;  // [1] Número do título
			E1_EMISSAO                              	,;  // [2] Data da emissão do título
			dDataBase                    					,;  // [3] Data da emissão do boleto
			E1_VENCTO                               	,;  // [4] Data do vencimento
			(E1_VALOR - nVlrAbat)                  	,;  // [5] Valor do título
			aCB_RN_NN[3]                             	,;  // [6] Nosso número (Ver fórmula para calculo)
			E1_PREFIXO                               	,;  // [7] Prefixo da NF
			E1_TIPO	                           		}   // [8] Tipo do Titulo
			
			//Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo.
			//Abaixo apenas uma sugestao
			cNroDoc	:= StrZero(	Val(Alltrim(SE1->E1_NUM)+Alltrim(SE1->E1_PARCELA)),8)
			
			cQuery:=" SELECT * FROM " +RETSQLNAME('SE1')+"  "
			cQuery+=" WHERE E1_FILIAL  = '"+xFilial("SE1")+"' AND"
			cQuery+=" E1_FATURA = '"+SE1->E1_NUM+"' AND "// AND E1_FATPREF = '"+SE1->E1_PREFIXO+"' AND E1_TIPOFAT = '"+SE1->E1_TIPO+"' AND"
			cQuery+=" D_E_L_E_T_ <> '*'"
			
			If Select("_TE1") > 0
				DbSelectArea("_TE1")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery ALIAS "_TE1" NEW
			
			dbSelectArea("_TE1")
			dbGoTop()
			
			While !_TE1->(EOF())
				
				If U_DItPrtLim(nLin)
					nLin := 200
					U_DItPrtCab(oPrint,2)
					U_DItPrtCol({20,370,2330},.T.,2)
					U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),60,SE1->E1_NUM,oPrint,4,2,/*RgbColor*/,"Fatura")
					U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),60,DTOC(SE1->E1_EMISSAO),oPrint,4,2,/*RgbColor*/,"Data de Emissão")
					nLin+=70
					U_DItPrtCol({20,2330},.T.,1)
					U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),50,"Frete Pago"+If(lImU_DItnt,". Continuação...",""),oPrint,2,2,RGB(230,230,230))
					nLin+=60
					U_DItPrtCol({20,270,470,820,1190,1390,1590,2330},.T.,7)
					U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),40,"Ctrc",oPrint,2,2,RGB(230,230,230))
					U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),40,"Valor Frete",oPrint,2,2,RGB(230,230,230))
					U_DItCell(U_DItPrtPos(3),nLin,U_DItPrtTam(3),40,"Destino",oPrint,2,2,RGB(230,230,230))
					U_DItCell(U_DItPrtPos(4),nLin,U_DItPrtTam(4),40,"Remetente/Destinatário",oPrint,2,2,RGB(230,230,230))
					U_DItCell(U_DItPrtPos(5),nLin,U_DItPrtTam(5),40,"Peso (Kg)",oPrint,2,2,RGB(230,230,230))
					U_DItCell(U_DItPrtPos(6),nLin,U_DItPrtTam(6),40,"Valor NF",oPrint,2,2,RGB(230,230,230))
					U_DItCell(U_DItPrtPos(7),nLin,U_DItPrtTam(7),40,"Notas Fiscais",oPrint,2,2,RGB(230,230,230))
					nLin+=50
					lImU_DItnt := .T.
				EndIf
				
				U_DItPrtCol({20,270,470,820,1190,1390,1590,2330},.T.,7)
				
				U_DItCell(U_DItPrtPos(1),nLin,,30,_TE1->E1_PREFIXO+_TE1->E1_NUM,oPrint,1,1,,,,)
				U_DItCell(U_DItPrtPos(2),nLin,,30,_TE1->E1_VALOR,oPrint,1,1,,,,"E1_VALOR")
				U_DItCell(U_DItPrtPos(3),nLin,,30,"XX Destino",oPrint,1,1,,,,)
				U_DItCell(U_DItPrtPos(4),nLin,,30,"XXXXXX Remetente/Destinatario",oPrint,1,1,,,,)
				U_DItCell(U_DItPrtPos(5),nLin,,30,"XXX Peso 99",oPrint,1,1,,,,)
				U_DItCell(U_DItPrtPos(6),nLin,,30,"XX Valor NF",oPrint,1,1,,,,)
				U_DItCell(U_DItPrtPos(7),nLin,,30,"XXX Notas Fiscais",oPrint,1,1,,,,)
				nLin += 40
				nDoctos++
				nVlrBruto += _TE1->E1_VALOR
				nVlrDesc += _TE1->E1_DESCONT
				nTotLiq += _TE1->E1_VALLIQ
				
				_TE1->(dbskip())
			EndDo
			
			dbSelectArea("_TE1")
			dbCloseArea()
			
			nLin += 10
			U_DItPrtCol({20,420,920,1420,1720})
			U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),60,"Doctos:"+Str(nDoctos,3,0),oPrint,1,2)
			U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),60,"Total Bruto : R$ "+Transform(nVlrBruto,"@E 99,999,999,999.99"),oPrint,1,2)
			U_DItCell(U_DItPrtPos(3),nLin,U_DItPrtTam(3),60,"Desconto : R$ "+Transform(nVlrDesc,"@E 99,999,999,999.99"),oPrint,1,2)
			U_DItCell(U_DItPrtPos(4),nLin,U_DItPrtTam(4),60,"Total Liquido : R$ "+Transform(nTotLiq,"@E 99,999,999,999.99"),oPrint,1,2)
			nLin += 50
			
			If U_DItPrtLim(nLin+1300)
				nLin := 200
				U_DItPrtCab(oPrint,2)
			EndIf
			nLin := U_DItPaperSize()[2] - 1500
			
			U_DItPrtCol({20,420,620,2100},.T.,3)
			U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),90,"",oPrint,2,5)
			U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),90,"bcoreal.bmp",oPrint,8)
			U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),90,"356-5",oPrint,2,5)
			U_DItCell(U_DItPrtPos(3),nLin,U_DItPrtTam(3),90,"Recibo do Sacado  ",oPrint,2,5)
			nLin += 89
			U_DItPrtCol({20,1500,1850,2330},.T.,1)
			U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),60,SM0->M0_NOMECOM,oPrint,4,2,/*RgbColor*/,"Cedente")
			U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),60,DTOC(aDadosTit[4]),oPrint,4,2,/*RgbColor*/,"Vencimento")
			U_DItCell(U_DItPrtPos(3),nLin,U_DItPrtTam(3),60,Alltrim(Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)),oPrint,4,2,/*RgbColor*/,"Nosso número")
			nLin += 59
			U_DItPrtCol({20,1400,1800,2330},.T.,1)
			U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),60,aDatSacado[1]+" ("+aDatSacado[2]+")" ,oPrint,4,2,/*RgbColor*/,"Sacado")
			U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),60,aDadosBanco[3]+"/"+aDadosBanco[4]+"/"+aDadosBanco[5],oPrint,4,2,/*RgbColor*/,"Agencia/Código do cedente")
			U_DItCell(U_DItPrtPos(3),nLin,U_DItPrtTam(3),60,"R$ "+AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oPrint,4,2,/*RgbColor*/,"Valor do documento")
			nlin+= 59
			U_DItPrtCol({20,1400,1950,2330},.T.,1)
			U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),60,aDatSacado[3],oPrint,4,2,/*RgbColor*/,"Endereço")
			U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),60,aDatSacado[4]+"/"+aDatSacado[5],oPrint,4,2,/*RgbColor*/,"Cidade/UF")
			U_DItCell(U_DItPrtPos(3),nLin,U_DItPrtTam(3),60,aDatSacado[6],oPrint,4,2,/*RgbColor*/,"CEP")
			nLin+= 59
			U_DItPrtCol({20,2330},.T.,1)
			U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),60,aDatSacado[7],oPrint,4,2,/*RgbColor*/,"C.N.P.J.")
			nLin += 70
			U_DItCell(U_DItPrtPos(1),nLin+15,U_DItPrtTam(1),60,"   Autenticação Mecânica    ",oPrint,1,1,/*RgbColor*/)
			nlin += 50
			U_DItCell(0,nLin,U_DItPrtTam(1),30,"__ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __  ",oPrint,1,2,/*RgbColor*/)
			nLin += 100
			
			U_DItPrtCol({20,420,620,2100},.T.,3)
			U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),90,"",oPrint,2,5)
			U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),90,"bcoreal.bmp",oPrint,8)
			U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),90,"356-5",oPrint,2,5)
			U_DItCell(U_DItPrtPos(3),nLin,U_DItPrtTam(3),90,aCB_RN_NN[2],oPrint,2,5)
			nLin += 89
			U_DItPrtCol({20,1600,2100},.T.,1)
			U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),65,"ATÉ O VENCIMENTO, PAGÁVEL EM QUALQUER AGÊNCIA BANCÁRIA",oPrint,4,2,/*RgbColor*/,"Local de pagamento")
			U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),65,DTOC(aDadosTit[4]),oPrint,4,2,RGB(235,235,235),"Data de Vencimento")
			nlin += 64
			U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),65,SM0->M0_NOMECOM,oPrint,4,2,/*RgbColor*/,"Cedente")
			U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),65,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oPrint,4,2,,"Agência/Código do cedente")
			nlin += 64
			U_DItPrtCol({20,220,620,920,1200,1600,2100},.T.,1)
			U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),65,StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oPrint,4,2,/*RgbColor*/,"Data do documento")
			U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),65,aDadosTit[7]+aDadosTit[1],oPrint,4,2,/*RgbColor*/,"Número do documento")
			U_DItCell(U_DItPrtPos(3),nLin,U_DItPrtTam(3),65,"CTRC",oPrint,4,2,/*RgbColor*/,"Tipo do documento")
			U_DItCell(U_DItPrtPos(4),nLin,U_DItPrtTam(4),65,"Não",oPrint,4,2,/*RgbColor*/,"Aceite")
			U_DItCell(U_DItPrtPos(5),nLin,U_DItPrtTam(5),65,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oPrint,4,2,/*RgbColor*/,"Data do processamento")
			U_DItCell(U_DItPrtPos(6),nLin,U_DItPrtTam(6),65,Alltrim(Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)),oPrint,4,2,/*RgbColor*/,"Nosso número")
			nlin += 64
			U_DItPrtCol({20,420,620,820,1200,1600,2100},.T.,1)
			U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),65,"",oPrint,4,2,/*RgbColor*/,"Uso do banco")
			U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),65,"20",oPrint,4,2,/*RgbColor*/,"Carteira")
			U_DItCell(U_DItPrtPos(3),nLin,U_DItPrtTam(3),65,"R$",oPrint,4,2,/*RgbColor*/,"Espécie")
			U_DItCell(U_DItPrtPos(4),nLin,U_DItPrtTam(4),65,"",oPrint,4,2,/*RgbColor*/,"Quantidade")
			U_DItCell(U_DItPrtPos(5),nLin,U_DItPrtTam(5),65,"X",oPrint,4,2,/*RgbColor*/,"Valor")
			U_DItCell(U_DItPrtPos(6),nLin,U_DItPrtTam(6),65,"R$ "+AllTrim(Transform(aDadosTit[5],"@E  999,999,999.99")),oPrint,4,2,RGB(235,235,235),"(=)Valor do documento")
			nlin += 64
			U_DItPrtCol({20,1600,2100},.T.,1)
			U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),195,"",oPrint,4,2,/*RgbColor*/,"Instruções")
			U_DItCell(U_DItPrtPos(1),nLin+2,U_DItPrtTam(1),65,aBolText[1]+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 999,999,999.99")),oPrint,1,2,/*RgbColor*/)
			U_DItCell(U_DItPrtPos(1),nLin+42,U_DItPrtTam(1),65,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.01)/30),"@E 99,999.99")),oPrint,1,2,/*RgbColor*/)
			U_DItCell(U_DItPrtPos(1),nLin+82,U_DItPrtTam(1),65,aBolText[3],oPrint,1,2,/*RgbColor*/)
			U_DItCell(U_DItPrtPos(1),nLin+122,U_DItPrtTam(1),65,aBolText[4],oPrint,1,2,/*RgbColor*/)
			
			U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),65,"",oPrint,4,2,/*RgbColor*/,"(-)Desconto / abatimento")
			U_DItCell(U_DItPrtPos(2),nLin+64,U_DItPrtTam(2),65,"",oPrint,4,2,/*RgbColor*/,"(-)Outras deduções")
			U_DItCell(U_DItPrtPos(2),nLin+128,U_DItPrtTam(2),65,"",oPrint,4,2,/*RgbColor*/,"(+)Mora / Multa")
			nLin += 64
			nLin += 64
			nLin += 64
			
			U_DItPrtCol({20,1600,2100},.T.,1)
			U_DItCell(U_DItPrtPos(1),nLin,U_DItPrtTam(1),180,"",oPrint,4,2,/*RgbColor*/,"Sacado")
			U_DItCell(U_DItPrtPos(1),nLin+5,U_DItPrtTam(1),65,aDatSacado[1]+" ("+aDatSacado[2]+")" ,oPrint,1,2,/*RgbColor*/)
			U_DItCell(U_DItPrtPos(1),nLin+45,U_DItPrtTam(1),65,aDatSacado[4]+"/"+aDatSacado[5],oPrint,1,2,/*RgbColor*/)
			U_DItCell(U_DItPrtPos(1),nLin+85,U_DItPrtTam(1),65,"CEP : "+aDatSacado[6],oPrint,1,2,/*RgbColor*/)
			U_DItCell(U_DItPrtPos(1),nLin+130,U_DItPrtTam(1),65,"Sacador / Avalista :"+SPACE(100)+"Código de Baixa :",oPrint,1,1,/*RgbColor*/)
			
			U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),90,"",oPrint,4,2,/*RgbColor*/,"(+)Outros acréscimos")
			U_DItCell(U_DItPrtPos(2),nLin+90,U_DItPrtTam(2),90,"R$ " +AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oPrint,4,2,RGB(235,235,235),"(=)Valor cobrado")
			
			nLin += 185
			U_DItPrtCol({20,1400,2100},.T.,1)
			
			For nt := 13 to 35 Step .1
				nPixUmCm := nt
				oPrint:Cmtr2Pix(@nPixUmCm, 10, .T.)
				If nPixUmCm >= (nLin)
					nPosBar := nt
					Exit
				EndIf
			Next
			
			MSBAR("INT25",nPosBar,0.2,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
			U_DItCell(U_DItPrtPos(2),nLin,U_DItPrtTam(2),65,"Autenticação mecânica / Ficha de compensação",oPrint,1,2,/*RgbColor*/)
			
			nLin += 20000
			DbSelectArea("SE1")
			RecLock("SE1",.f.)
			SE1->E1_NUMBCO 	:=	aCB_RN_NN[3]   // Nosso número (Ver fórmula para calculo)
			MsUnlock()
			
		EndIf
		dbSelectArea("SE1")
		dbSkip()
	End
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura os indices padroes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
RetIndex("SE1")
fErase(cIndexName+OrdBagExt())


Return


Static Function AjustSX1()
Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0
Local cPerg 	:= "_GR010"
Local aPergs 	:= {}


Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Numero","","","mv_ch3","C",6,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",6,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Parcela","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Portador","","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
Aadd(aPergs,{"Ate Portador","","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
Aadd(aPergs,{"De Cliente","","","mv_ch9","C",6,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
Aadd(aPergs,{"Ate Cliente","","","mv_cha","C",6,0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
Aadd(aPergs,{"De Loja","","","mv_chb","C",2,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Loja","","","mv_chc","C",2,0,0,"G","","MV_PAR12","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Emissao","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Emissao","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/07","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Vencimento","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Vencimento","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/07","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do Bordero","","","mv_chh","C",6,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Bordero","","","mv_chi","C",6,0,0,"G","","MV_PAR18","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})



aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]
		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
	Endif
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
		
		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0

L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := Mod(D*10,11)
If D == 10 .or. D == 0
	D := 0
End
D := AllTrim(Str(D))

Return(D)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Retorna os strings para inpressão do Boleto
//CB = String para o cód.barras, RN = String com o número digitável
//Cobrança não identificada, número do boleto = Título + Parcela
//Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor,dvencimento,nSequencial)

Local cNumSeq 
Local bldocnufinal := strzero(val(cNroDoc),9)
Local blvalorfinal := strzero(int(nValor*100),10)
Local cNNumSDig := cCpoLivre := cCBSemDig := cCodBarra := cNNum := cFatVenc := ''
Local cNossoNum
Local _cDigito := ""
Local _cSuperDig := ""


//Fator Vencimento - POSICAO DE 06 A 09
cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)


cNumSeq := strzero(val(nSequencial),13)
//Nosso Numero sem digito
cNNumSDig := cNumSeq
//Nosso Numero
cNNum := cNumSeq
//Nosso Numero para impressao
cNossoNum := cNNum
cCpoLivre := StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7) + AllTrim(Str( modulo10( cNNumSDig+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7) ) ) ) + cNNumSDig


//Dados para Calcular o Dig Verificador Geral
cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
//Codigo de Barras Completo
cCodBarra := cBanco + Modulo11(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre

//Digito Verificador do Primeiro Campo
cPrCpo := cBanco + SubStr(cCodBarra,20,5)
cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))

//Digito Verificador do Segundo Campo
cSgCpo := SubStr(cCodBarra,25,10)
cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))

//Digito Verificador do Terceiro Campo
cTrCpo := SubStr(cCodBarra,35,10)
cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))

//Digito Verificador Geral
cDvGeral := SubStr(cCodBarra,5,1)

//Linha Digitavel
cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
cLinDig += " " + cDvGeral              //dig verificador geral
cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
//cLinDig += "  " + cFatVenc +blvalorfinal  // fator de vencimento e valor nominal do titulo

Return({cCodBarra,cLinDig,cNossoNum})