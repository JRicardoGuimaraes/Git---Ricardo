/*
+-------------------------------------------------------------------------------+
|Programa  : TMCPOEDI   | Autor : J Ricardo Guimar�es | Data :  29/09/10        |
|-------------------------------------------------------------------------------+
| Desc.    : Ponto de Entrada executado na rotina TMSA050 que permite adicionar |
|          : campos para ser exebido na tela de notas de EDI.                   |
|          :                                                                    |
|-------------------------------------------------------------------------------|
| Uso      : M�dulo TMS                                                         |
+-------------------------------------------------------------------------------+
*/
USER Function TMCPOEDI()

Local aCpo := {{"DE5_MUN", "DE5_ESTADO"  },;
		       {DE5_MUN    , DE5_ESTADO}}

Return aCPO
