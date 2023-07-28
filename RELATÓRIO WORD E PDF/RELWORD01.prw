#INCLUDE 'TOTVS.CH'
#INCLUDE 'MSOLE.CH'

#Define oleWdFormatDocument "0"
#Define oleWdFormatHTML "102"
#Define oleWdFormatPDF "17"

User function abrirWord()
 
 	Local cTitulo := "Impressão dos clientes em Word"

	If !perguntaDiretorio()
		FWAlertError("Impressão cancelada.","TOTVS")
		Return
	EndIf

	FWMsgRun(, {||imprimirWord() }, cTitulo, "Gerando o documento")


Return

Static function imprimirWord()

	Local oWord
	Local cCaminho := Alltrim(MV_PAR01)
	local nQuant   := 0
	local x        := 0

	IF CpyS2T("Dot\CODIGO.dotm",cCaminho )

		oWord := OLE_CreateLink( "TMsOleWord95" )
		OLE_SetProperty( oWord, oleWdVisible, .F. )
		OLE_SetProperty( oWord, oleWdPrintBack, .F. )

		OLE_NewFile(oWord,cCaminho +"CODIGO.dotm")

    IF SELECT("QRY_SB1") > 0
        QRY_SB1->( DbCloseArea())
    ENDIF

		BeginSql Alias "QRY_SB1"
				SELECT *
				FROM %table:SB1% SB1
				WHERE SB1.%notDel%
		EndSql

		QRY_SB1->(DBGoTop())

		While QRY_SB1->(!Eof())
			nQuant := nQuant + 1
			QRY_SB1->(DBSkip())
		enddo

		OLE_SetDocumentVar(oWord, "w_QuantProd", nQuant)

		QRY_SB1->(DBGoTop())

		While QRY_SB1->(!Eof())
			for x = 1 To nQuant
				OLE_SetDocumentVar(oWord, "W_B1_COD"+Alltrim(Str(x))    ,   QRY_SB1->B1_COD    )
				OLE_SetDocumentVar(oWord, "W_B1_DESC"+Alltrim(Str(x))   ,   QRY_SB1->B1_DESC   )
				OLE_SetDocumentVar(oWord, "W_B1_TIPO"+Alltrim(Str(x))   ,   QRY_SB1->B1_TIPO   )
				OLE_SetDocumentVar(oWord, "W_B1_LOCPAD"+Alltrim(Str(x)) ,   QRY_SB1->B1_LOCPAD )
				OLE_SetDocumentVar(oWord, "W_B1_GRUPO"+Alltrim(Str(x))  ,   QRY_SB1->B1_GRUPO  )
  
				QRY_SB1->(DBSkip())
			Next
		enddo

		OLE_ExecuteMacro(oWord,"macro")

		OLE_UpdateFields(oWord)

		if MV_PAR02 == "1"
			OLE_SaveAsFile( oWord, cCaminho +"CODIGO.docx")
		else
			OLE_SaveAsFile( oWord, cCaminho + "CODIGO.pdf", '', '', .F., oleWdFormatPDF)
		endif
		// Fecha o documento.
		OLE_CloseFile(oWord)

		//Fechando o arquivo e o link
		OLE_CloseLink(oWord)

		// // SE FOR WORD, ABRE O ARQUIVO
		if MV_PAR02 == "1"
			ShellExecute("open","CODIGO.docx","",cCaminho,1)
		else
			ShellExecute("open","CODIGO.pdf","",cCaminho,1)
		endif

	Else
		FWAlertError("Arquivo nao copiado","TOTVS")
	EndIf

Return


static function perguntaDiretorio()
	Local aPergs := {}
	local lRet   := .F.

	aAdd(aPergs, {6, "Dir. Salvar", Space(90), "", , "", 90, .T., "Diretórios", "C:\", GETF_LOCALHARD+GETF_RETDIRECTORY})
	aAdd(aPergs, {2, "Tipo Arquivo", "1", {"1=Word", "2=PDF"}, 90, ".T.", .T.})

	If ParamBox(aPergs, "",,,,,,,,, .F., .F.)
		lRet := .T.
	EndIf

Return lRet
