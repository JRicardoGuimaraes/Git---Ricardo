

User Function GFCAD006()
  cCadastro := "Tipos de Embalagens"
  aAutoCab    := {}
  aAutoItens  := {}
  PRIVATE aRotina := { { "" ,  "AxPesqui"  , 0 , 1},;  // "Pesquisar"
                       { "",   "C160Visual", 0 , 2},;  // "Visualizar"
                       { "",   "C160Inclui", 0 , 3},;  // "Incluir"
                       { "",   "C160Altera", 0 , 4},;  // "Alterar"
                       { "",   "C160Deleta", 0 , 5} }  // "Excluir"
  DbSelectArea("SX5")           
  DbSetOrder(1)
  If !DbSeek(xFilial("SX5")+"MG",.F.)
     MsgAlert(xFilial("SX5"))
     MsgAlert("Nao foi possivel localizar a tabela MG no cadastro de tabelas (SX5) !")
  Else   
     c160altera("SX5",,3)
  Endif   
  return         
