/*//#########################################################################################
Projeto : project
Modulo  : module
Fonte   : REL01PDF
Objetivo: objetivo
*///#########################################################################################

#INCLUDE 'TOTVS.CH'
#INCLUDE 'REPORT.CH'

/*/{Protheus.doc} REL01PDF
    Gerenciador de Processamento

    @author  Nome
    @example Exemplos
    @param   [Nome_do_Parametro],Tipo_do_Parametro,Descricao_do_Parametro
    @return  Especifica_o_retorno
    @table   Tabelas
    @since   18-07-2023
/*/
User Function REL01PDF()
    PRIVATE oReport
    PRIVATE cAlias := getNextAlias()
    PRIVATE cPerg  := PadR("REL01PDF",10)
    PRIVATE oSection1
   
    Pergunte(cPerg)
    oReport := Relatorio()
    // Abre a dialog para imprimir
    oReport:PrintDialog()

Return

/*/{Protheus.doc} Relatorio
    Imprimir Relatório

    @author  Nome
    @example Exemplos
    @param   [Nome_do_Parametro],Tipo_do_Parametro,Descricao_do_Parametro
    @return  Especifica_o_retorno
    @table   Tabelas
    @since   18-07-2023
/*/
Static Function Relatorio()

    
    
    // Cria o TReport
    oReport  := TReport():New('CRM980MDef','Relatório de Clientes',cPerg,{|oReport|ReportPrint(oReport)},'')
    // Imprime como Paisagem
    oReport:SetLandScape()
    
    // Cria a seção
    oSection1 := TRSection():New(oReport, 'Clientes')

    // Cria as colunas do Relatório
    TRCell():New(oSection1,"A1_COD"   ,cAlias,  "Código"         )
    TRCell():New(oSection1,"A1_NOME"  ,cAlias,  "Nome"           )
    TRCell():New(oSection1,"A1_LOJA"  ,cAlias,  "Loja"           )
    TRCell():New(oSection1,"A1_TIPO"  ,cAlias,  "Tipo de Cliente")
    TRCell():New(oSection1,"A1_PESSOA",cAlias,  "Tipo de Pessoa" )
    TRCell():New(oSection1,"A1_EST"   ,cAlias,  "Estado"         )
    TRCell():New(oSection1,"A1_MUN"   ,cAlias,  "Município"      )
    TRCell():New(oSection1,"A1_END"   ,cAlias,  "Endereço"       )
    


Return oReport


/*/{Protheus.doc} ReportPrint
    Montar query e abrir em tabela temporária

    @author   Joao vitor vargas
    @example Exemplos
    @param   [Nome_do_Parametro],Tipo_do_Parametro,Descricao_do_Parametro
    @return  Especifica_o_retorno
    @table   Tabelas
    @since   18-07-2023
/*/
static function ReportPrint(oReport)
    local oSection1b := oReport:Section(1)
    local nRegs := 0
    

    
    // Faz a consulta query
    BeginSQL Alias cAlias
    
      SELECT 
      A1_COD,
      A1_NOME, 
      A1_LOJA, 
      A1_TIPO, 
      A1_PESSOA,
      A1_EST,
      A1_MUN,
      A1_END
      FROM %Table:SA1% SA1
      WHERE SA1.%NOTDEL%
      AND A1_FILIAL = %xFilial:SA1%
      AND A1_COD BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
    ORDER BY A1_COD
   
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

        oSection1:Cell('A1_COD'):SetValue(  AllTrim((cAlias)-> A1_COD  ) )
        oSection1:Cell('A1_NOME'):SetValue( AllTrim((cAlias)-> A1_NOME ) )
        oSection1:Cell('A1_LOJA'):SetValue( AllTrim((cAlias)-> A1_LOJA ) )
        oSection1:Cell('A1_TIPO'):SetValue( AllTrim((cAlias)-> A1_TIPO ) )
        oSection1:Cell('A1_PESSOA'):SetValue(AllTrim((cAlias)->A1_PESSOA))
        oSection1:Cell('A1_EST'):SetValue(  AllTrim((cAlias)-> A1_EST  ) )
        oSection1:Cell('A1_MUN'):SetValue(  AllTrim((cAlias)-> A1_MUN  ) )
        oSection1:Cell('A1_END'):SetValue(  AllTrim((cAlias)-> A1_END  ) )
    
    	(cAlias)->(DbSkip())
        oSection1:PrintLine()
    Enddo
    oSection1:Finish()
ENDIF

    

    oSection1b:Print()


Return

