#INCLUDE 'TOTVS.CH'
#INCLUDE 'REPORT.CH'

User function REL02FORN()

	Private oReport := Nil
	Private cAlias := ""
	Private cAlias2 := ""
	Private cPerg1  := "REL01PDF"
	Private oSection1 := Nil
	Private oSection2 := Nil

	cAlias := getNextAlias()
	cAlias2 := getNextAlias()

	cPerg1  := PadR("RELFORN",10)

	oReport := Relatorio()
	Pergunte(cPerg1,.T.)
	// Abre a dialog para imprimir
	oReport:PrintDialog()

Return

Static Function Relatorio()

	// Cria o TReport
	oReport  := TReport():New('REL01USR','Relatório de Usuários',cPerg1,{|oReport|ReportPrint(oReport)},'')
	// Imprime como Paisagem
	oReport:SetLandScape()

	// Cria a seção
	oSection1 := TRSection():New(oReport, 'Usuários')

	// Cria as colunas do Relatório
	TRCell():New(oSection1,"A2_COD"  ,cAlias,  "CÓDIGO DO FORNECEDOR" )
	TRCell():New(oSection1,"A2_LOJA" ,cAlias,  "LOJA"                 )
	TRCell():New(oSection1,"A2_NOME" ,cAlias,  "NOME DO FORNECEDOR"   )

	oSection2 := TRSection():New(oReport, 'Fornecedor X Produto')

	// Cria as colunas do Relatório
	TRCell():New(oSection2,"A5_PRODUTO" ,cAlias2, "CÓDIGO DO PRODUTO" )
	TRCell():New(oSection2,"A5_NOMPROD" ,cAlias2, "NOME DO PRODUTO"   )

Return oReport

static function ReportPrint(oReport)
	// Faz a consulta query
	BeginSQL Alias cAlias
        SELECT 
            A2_COD,
            A2_LOJA,
            A2_NOME
        FROM
            %table:SA2% SA2
        WHERE
            SA2.%NotDel%
	EndSql

	While (cAlias)->(!EoF())

		// Inicia seção 1

		oSection1:Init()

		oSection1:Cell('A2_COD'  ):SetValue( AllTrim( (cAlias)->A2_COD  ) )
		oSection1:Cell('A2_LOJA' ):SetValue( AllTrim( (cAlias)->A2_LOJA ) )
		oSection1:Cell('A2_NOME' ):SetValue( AllTrim( (cAlias)->A2_NOME ) )

		oSection1:PrintLine()

		if(SELECT(cAlias2) > 0)
			(cAlias2)->(dbCloseArea())
		Endif

		BeginSQL Alias cAlias2
            SELECT
                A5_PRODUTO,
                A5_NOMPROD
            FROM
                %table:SA5% SA5
                INNER JOIN %table:SA2% SA2 ON
                A5_FORNECE  = A2_COD
                AND A2_LOJA = A5_LOJA
            WHERE
                A5_FORNECE = %EXP:(cAlias)->A2_COD%
                AND SA2.%NotDel%
                AND SA5.%NotDel%
		EndSql

		While (cAlias2)->(!EoF())

			oSection2:Init()

			oSection2:Cell('A5_PRODUTO'):SetValue( AllTrim( (cAlias2)->A5_PRODUTO ) )
			oSection2:Cell('A5_NOMPROD'):SetValue( AllTrim( (cAlias2)->A5_NOMPROD ) )

			oSection2:PrintLine()

			(cAlias2)->(DbSkip())
		Enddo
		oSection2:Finish()
		(cAlias)->(DbSkip())
        
        oSection1:Finish()

	Enddo

    
	
Return
