#INCLUDE 'TOTVS.CH'


User Function MA120BUT() 
        Local aButtons := {} 
        // Botoes a         adicionar
        aadd(aButtons,{'Relatorio',{|| U_PedidoCompras()},'Relat�rio ','RELATORIO.'})

        
         
Return (aButtons )
