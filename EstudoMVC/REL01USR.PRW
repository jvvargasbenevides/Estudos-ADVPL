#INCLUDE 'TOTVS.CH'
#INCLUDE 'REPORT.CH'

User function REL01USR()
    PRIVATE oReport
    PRIVATE cAlias := getNextAlias()
    PRIVATE cPerg1  := PadR("REL01PDF",10)
    PRIVATE oSection1
   
    oReport := Relatorio()
    Pergunte(cPerg1,.F.)
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
    TRCell():New(oSection1,"Z1_IDUSR"   ,cAlias,  "ID"        )
    TRCell():New(oSection1,"Z1_NOME"    ,cAlias,  "Nome"      )
    TRCell():New(oSection1,"Z1_SBRNOME" ,cAlias,  "Sobrenome" )
    TRCell():New(oSection1,"Z1_PAIS"    ,cAlias,  "País"      )
    TRCell():New(oSection1,"Z1_NUMTEL"  ,cAlias,  "Telefone"  )

Return oReport

static function ReportPrint(oReport)
    local oSection1b := oReport:Section(1)
    local nRegs := 0
       
    // Faz a consulta query
    BeginSQL Alias cAlias
    
      SELECT 
    Z1_IDUSR,
    Z1_NOME,
    Z1_SBRNOME,
    Z1_PAIS,
    Z1_NUMTEL
      FROM %Table:SZ1% SZ1
      WHERE SZ1.%NOTDEL%
      AND Z1_FILIAL = %xFilial:SZ1%
      AND Z1_IDUSR BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
    ORDER BY Z1_IDUSR
    EndSql
 
    DbSelectArea(cAlias)
    // Faz a contagem dos registro
    Count TO nRegs

    // Se o registro for maior que 0
    if nRegs > 0
    (cAlias) ->( DbGoTop() )
    // Enquanto o Programa não estiver no fim
    While (cAlias)->(!EoF())

    // Inicia seção 1
    oSection1:Init()

        oSection1:Cell('Z1_IDUSR'):SetValue(   AllTrim((cAlias)-> Z1_IDUSR   ) )
        oSection1:Cell('Z1_NOME'):SetValue(    AllTrim((cAlias)-> Z1_NOME    ) )
        oSection1:Cell('Z1_SBRNOME'):SetValue( AllTrim((cAlias)-> Z1_SBRNOME ) )
        oSection1:Cell('Z1_PAIS'):SetValue(    AllTrim((cAlias)-> Z1_PAIS    ) )
        oSection1:Cell('Z1_NUMTEL'):SetValue(  AllTrim((cAlias)-> Z1_NUMTEL  ) )
          
    	(cAlias)->(DbSkip())
        oSection1:PrintLine()
    Enddo
    oSection1:Finish()
ENDIF

    oSection1b:Print()

Return
