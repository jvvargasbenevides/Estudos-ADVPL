#INCLUDE 'TOTVS.CH'
#INCLUDE 'REPORT.CH'

User function REL03FORN()

	Private oReport := Nil
	Private cAlias := ""
	Private cPerg1  := "REL01PDF"
	Private oSection1 := Nil
	Private oSection2 := Nil
    Private cCodigo := ""

	cAlias := getNextAlias()


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

	// Cria as colunas do Relatório(CABEÇALHO)
	TRCell():New(oSection1,"A5_NOMEFOR"  ,cAlias,  "NOME DO FORNECEDOR"   )
	TRCell():New(oSection1,"A5_LOJA"     ,cAlias,  "LOJA"                 )
	TRCell():New(oSection1,"A5_FORNECE"  ,cAlias,  "CÓDIGO DO FORNECEDOR" )

	oSection2 := TRSection():New(oReport, 'Fornecedor X Produto')

	// Cria as colunas do Relatório
	TRCell():New(oSection2,"A5_PRODUTO" ,cAlias, "CÓDIGO DO PRODUTO" )
	TRCell():New(oSection2,"A5_NOMPROD" ,cAlias, "NOME DO PRODUTO"   )

Return oReport

static function ReportPrint(oReport)
	// Faz a consulta query
			BeginSQL Alias cAlias
            SELECT
                A5_PRODUTO,
                A5_NOMPROD,
                A5_NOMEFOR,
                A5_LOJA,
                A5_FORNECE

            FROM
                %table:SA5% SA5
            WHERE SA5.%NotDel%
		EndSql

	While (cAlias)->(!EoF())
    cCodigo := ((cAlias)->A5_FORNECE)
		// Inicia seção 1
    While (cCodigo)->(!EoF())
		oSection1:Init()
		// IMPRIME AS CELULAS (COLUNAS)
        oSection1:Cell('A5_FORNECE' ):SetValue( AllTrim( (cAlias)->A5_FORNECE ) )
		oSection1:Cell('A5_LOJA'    ):SetValue( AllTrim( (cAlias)->A5_LOJA    ) )
		oSection1:Cell('A5_NOMEFOR' ):SetValue( AllTrim( (cAlias)->A5_NOMEFOR ) )
		
        oSection1:PrintLine()

		While (cAlias)->(!EoF())
    if cCodigo == A5_FORNECE
			oSection2:Init()

			oSection2:Cell('A5_PRODUTO'):SetValue( AllTrim( (cAlias)->A5_PRODUTO ) )
			oSection2:Cell('A5_NOMPROD'):SetValue( AllTrim( (cAlias)->A5_NOMPROD ) )

			oSection2:PrintLine()

			(cAlias)->(DbSkip())
		Endif
        Enddo


        Enddo
		oSection2:Finish()
		(cAlias)->(DbSkip())
        
        oSection1:Finish()

	Enddo

	
Return
