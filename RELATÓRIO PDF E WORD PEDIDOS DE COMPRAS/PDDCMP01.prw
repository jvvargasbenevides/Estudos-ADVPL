#INCLUDE 'TOTVS.CH'
#INCLUDE 'MSOLE.CH'

#Define oleWdFormatDocument "0"
#Define oleWdFormatHTML "102"
#Define oleWdFormatPDF "17"

User function PedidoCompras()
 
 	Local cTitulo  := "Impressão dos clientes em Word"

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
    local cCodFor  := ""
	Private cAlias := GetNextAlias()

	IF CpyS2T("Dot\PedidoCompras.dotm",cCaminho )

		oWord          := OLE_CreateLink( "TMsOleWord97" )
		OLE_SetProperty( oWord, oleWdVisible, .F. )
		OLE_SetProperty( oWord, oleWdPrintBack, .F. )

		OLE_NewFile(oWord,cCaminho +"PedidoCompras.dotm")

		oStatement     := FWPreparedStatement():New()

		cQuery         := " SELECT C7_LOJA, C7_FORNECE, C7_ITEM, C7_PRODUTO, C7_UM, C7_QUANT, C7_PRECO, C7_TOTAL, C7_COND, C7_NUM, A2_NOME, C7_FILCEN "
		cQuery         := " FROM "+ RetSqlName("SC7") + " SC7 "
		cQuery         := " INNER JOIN "+ RetSqlName("SA2") +" SA2 ON SA2.D_E_L_E_T_ = ' ' AND C7_FORNECE = A2_COD"
		cQuery         := " WHERE SC7.D_E_L_E_T_ = '' "

		oStatement:SetQuery(cQuery)

		cFinalQuery    := oStatement:GetFixQuery()

		cAlias         := MPSysOpenQuery(cFinalQuery)

		(cAlias)->(DBGoTop())

		While (cAlias)->(!Eof())
			nQuant         := nQuant + 1
			(cAlias)->(DBSkip())
		enddo
			
			OLE_SetDocumentVar(oWord, "Quant_Prod", nQuant)
		(cAlias)->(DBGoTop())

		While (cAlias)->(!Eof())

				if cCodFor != SC7->C7_FORNECE
				OLE_SetDocumentVar(oWord, "W_C7_FORNECE", (cAlias)->C7_FORNECE )
				OLE_SetDocumentVar(oWord, "W_A2_NOME" , (cAlias)->A2_NOME )
				OLE_SetDocumentVar(oWord, "W_C7_LOJA" , (cAlias)->C7_LOJA )
				  cCodfor        := (cAlias)->C7_FORNECE
				Endif
				
  				for x = 1 To nQuant
				OLE_SetDocumentVar(oWord, "W_C7_ITEM"+Alltrim(Str(x)) , (cAlias)->C7_ITEM )
				OLE_SetDocumentVar(oWord, "W_C7_PRODUTO"+Alltrim(Str(x)) , (cAlias)->C7_PRODUTO )
				OLE_SetDocumentVar(oWord, "W_C7_UM"+Alltrim(Str(x)) , (cAlias)->C7_UM )
				OLE_SetDocumentVar(oWord, "W_C7_QUANT"+Alltrim(Str(x)) , (cAlias)->C7_QUANT )
				OLE_SetDocumentVar(oWord, "W_C7_PRECO"+Alltrim(Str(x)) , (cAlias)->C7_PRECO )
				OLE_SetDocumentVar(oWord, "W_C7_TOTAL"+Alltrim(Str(x)) , (cAlias)->C7_TOTAL )
				OLE_SetDocumentVar(oWord, "W_C7_COND"+Alltrim(Str(x)) , (cAlias)->C7_COND )
				OLE_SetDocumentVar(oWord, "W_C7_NUM"+Alltrim(Str(x)) , (cAlias)->C7_NUM )
				(cAlias)->(DBSkip())
				next
				
		Enddo
						
		OLE_ExecuteMacro(oWord,"Macro1")
		OLE_ExecuteMacro(oWord,"Macro2")

		OLE_UpdateFields(oWord)

		if MV_PAR02 == "1"
			OLE_SaveAsFile( oWord, cCaminho +"PedidoCompras.docx")
		else
			OLE_SaveAsFile( oWord, cCaminho + "PedidoCompras.pdf", '' , '' , .F., oleWdFormatPDF)
		endif
		// Fecha o documento.
		OLE_CloseFile(oWord)

		//Fechando o arquivo e o link
		OLE_CloseLink(oWord)

		// // SE FOR WORD, ABRE O ARQUIVO
		if MV_PAR02 == "1"
			ShellExecute("open","PedidoCompras.docx","",cCaminho,1)
		else
			ShellExecute("open","PedidoCompras.pdf","",cCaminho,1)
		endif

	Else
		FWAlertError("Arquivo nao copiado","TOTVS")
	EndIf

Return


static function perguntaDiretorio()
	Local aPergs   := {}
	local lRet     := .F.

	aadd(aPergs, {6, "Dir. Salvar" , Space(90), ""                 ,   , ""   , 90 , .T., "Diretórios", "C:\", GETF_LOCALHARD+GETF_RETDIRECTORY})
	aadd(aPergs, {2, "Tipo Arquivo", "1"      , {"1=Word", "2=PDF"}, 90, ".T.", .T.})

	If ParamBox(aPergs, "",,,,,,,,, .F., .F.)
		lRet           := .T.
	EndIf

Return lRet
