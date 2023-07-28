/*//#########################################################################################
Projeto : project
Modulo  : module
Fonte   : TASDA3ET
Objetivo: objetivo
*///#########################################################################################

#INCLUDE 'TOTVS.CH'
#include 'REPORT.CH'

/*/{Protheus.doc} TASDA3ET
    Gerenciador de Processamento

    @author  Nome
    @example Exemplos
    @param   [Nome_do_Parametro],Tipo_do_Parametro,Descricao_do_Parametro
    @return  Especifica_o_retorno
    @table   Tabelas
    @since   21-07-2023
/*/
User Function REL03PXF()
    Local cPergRel  := PadR("RELFORN",10)
    Local oReport
    local ccAlias := getNextAlias()

    Pergunte(cPergRel,.T.)

    oReport := xPrintRel(ccAlias,cPergRel)
    oReport:PrintDialog()

Return

/*/{Protheus.doc} xPrintRel
    Imprimir Relatório

    @author  Nome
    @example Exemplos
    @param   [Nome_do_Parametro],Tipo_do_Parametro,Descricao_do_Parametro
    @return  Especifica_o_retorno
    @table   Tabelas
    @since   21-07-2023
/*/
Static Function xPrintRel(ccAlias,cPerg)

    local oReport
    local oSection1
    local oSection2
    local oBreak1

    oReport    := TReport():New(cPerg,'title',cPerg,{|oReport|ReportPrint(oReport,ccAlias)},'')
    oReport:SetLandScape()
    oReport:SetTotalInLine(.F.)

    oSection1 := TRSection():New(oReport)
    oSection1:SetTotalInLine(.F.)

    TRCell():New(oSection1,"A2_COD"   ,'SA2',  "Código"         )
    TRCell():New(oSection1,"A2_NOME"  ,'SA2',  "Nome"           )
    TRCell():New(oSection1,"A2_LOJA"  ,'SA2',  "Loja"           )
    TRCell():New(oSection1,"A2_NREDUZ",'SA2',  "Nome Fantasia"  )
    TRCell():New(oSection1,"A2_EST"   ,'SA2',  "Estado"         )
    TRCell():New(oSection1,"A2_MUN"   ,'SA2',  "Município"      )
    TRCell():New(oSection1,"A2_END"   ,'SA2',  "Endereço"       )
    

    oSection2 := TRSection():New(oSection1)
    oSection2:SetTotalInLine(.F.)

    TRCell():New(oSection2,"B1_COD"   , 'SB1' ,  "Código"         )
    TRCell():New(oSection2,"B1_DESC"  , 'SB1' ,  "Nome"           )
   
    oBreak1 := TRBreak():New(oSection1,{|| oSection2:Cell('cellSession1') },'Total:',.F.)
    TRFunction():New(oSection2:Cell('cellSession2' ), 'TOT1', 'SUM', oBreak1,,,, .F., .T.)

Return oReport


/*/{Protheus.doc} ReportPrint
    Montar query e abrir em tabela temporária

    @author  Nome
    @example Exemplos
    @param   [Nome_do_Parametro],Tipo_do_Parametro,Descricao_do_Parametro
    @return  Especifica_o_retorno
    @table   Tabelas
    @since   21-07-2023
/*/
static function ReportPrint(oReport, ccAlias,cOrdem)
    local oSection1b := oReport:Section(1)
    local oSection2b := ''

    oSection2b := oReport:Section(1):Section(1)

    oSection1b:BeginQuery()
                BeginSQL Alias cAlias
 SELECT 	
        Distinct(A2_LOJA, A2_COD),        
        B1_COD, 
		B1_DESC, 
		A2_NOME,  
		DistinctA2_LOJA, 		
        A2_NREDUZ,
		A2_EST,   
		A2_MUN,   
		A2_END   
 FROM %Table:SA2% SA2
INNER JOIN %Table:SB1% SB1 ON SB1.B1_PROC = SA2.A2_COD
    
    EndSql
    oSection1b:EndQuery()

    oSection2b:SetParentQuery()

    oReport:SetMeter((ccAlias)->(RecCount()))

    oSection2b:SetParentFilter({|cParam| (ccAlias)->cellSession1 == cParam}, {|| (ccAlias)->cellSession1})

 While (cAlias)->(!EoF())

    // Inicia seção 1
    oSection1b:Init()

        oSection1b:Cell('A5_FORNECE'):SetValue(  AllTrim((cAlias)->   A5_FORNECE  ) )
        oSection1b:Cell('A5_LOJA'   ):SetValue(  AllTrim((cAlias)->   A5_LOJA     ) )
        oSection1b:Cell('A5_NOMEFOR'):SetValue(  AllTrim((cAlias)->   A5_NOMEFOR  ) )
        oSection1b:Cell('A5_PRODUTO'):SetValue(  AllTrim((cAlias)->   A5_PRODUTO  ) )
        oSection1b:Cell('A5_NOMPROD'):SetValue(  AllTrim((cAlias)->   A5_NOMPROD  ) )
        
    	(cAlias)->(DbSkip())
        oSection1:PrintLine()
     
     While (cAlias)->(!EoF())
        oSection2b:Init()

        oSection2:Cell('B1_COD'):SetValue(  AllTrim((cAlias)-> B1_COD  ) )
        oSection2:Cell('B1_DESC'):SetValue( AllTrim((cAlias)-> B1_NOME ) )
   
    
    	(cAlias)->(DbSkip())
        oSection2b:PrintLine()
    Enddo
    
    Enddo
    
    oSection1b:Finish()
       
       

    oSection1b:Print()
Return
