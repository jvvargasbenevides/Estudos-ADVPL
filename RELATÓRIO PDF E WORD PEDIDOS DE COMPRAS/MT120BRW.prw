#INCLUDE 'TOTVS.CH'


User Function MA120BUT() 
        Local aButtons := {} 
        // Botoes a         adicionar
        aadd(aButtons,{'Relatorio',{|| U_PedidoCompras()},'Relatório ','RELATORIO.'})

        
         
Return (aButtons )
