#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO11    � Autor � AP6 IDE            � Data �  05/08/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function DIEF()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private oGeraTxt

Private cString := ""
//���������������������������������������������������������������������Ŀ
//� Cria o arquivo texto                                                �
//�����������������������������������������������������������������������

Private cArqTxt := "D:\TEMP\DIEF_RICARDO.TXT"
Private nHdl    := fCreate(cArqTxt)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Private nTamLin, cLin, cCpo


//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

//While !EOF()

    //���������������������������������������������������������������������Ŀ
    //� Incrementa a regua                                                  �
    //�����������������������������������������������������������������������


    //�����������������������������������������������������������������ͻ
    //� Lay-Out do arquivo Texto gerado:                                �
    //�����������������������������������������������������������������͹
    //�Campo           � Inicio � Tamanho                               �
    //�����������������������������������������������������������������Ķ
    //� ??_FILIAL     � 01     � 02                                    �
    //�����������������������������������������������������������������ͼ

    nTamLin := 2
    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

    //���������������������������������������������������������������������Ŀ
    //� Substitui nas respectivas posicioes na variavel cLin pelo conteudo  �
    //� dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     �
    //� string dentro de outra string.                                      �
    //�����������������������������������������������������������������������

//    cCpo := PADR(->??_FILIAL,02)
    
    cLin := "0100039322200701"+cEOL
    fWrite(nHdl,cLin,Len(cLin))
    cLin := "020201200702   09020300000000000000000026857104100017100000000407912"+cEOL
    fWrite(nHdl,cLin,Len(cLin))
    cLin := "0321400004000000005530900000000000000000000000000000"+cEOL
    fWrite(nHdl,cLin,Len(cLin))    
    cLin := "040000000000000000000000553090"+cEOL
    fWrite(nHdl,cLin,Len(cLin))    
    cLin := "1100000005"+cEOL
    fWrite(nHdl,cLin,Len(cLin))        
        
    //���������������������������������������������������������������������Ŀ
    //� Gravacao no arquivo texto. Testa por erros durante a gravacao da    �
    //� linha montada.                                                      �
    //�����������������������������������������������������������������������



//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������

fClose(nHdl)

Return
