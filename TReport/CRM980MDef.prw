#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMBROWSE.CH'

Function U_CRM980MDEF()
	Local aRotina := {}
	// Local aParam := PARAMIXB
//----------------------------------------------------------------------------------------------------------
// [n][1] - Nome da Funcionalidade
// [n][2] - Função de Usuário
// [n][3] - Operação (1-Pesquisa; 2-Visualização; 3-Inclusão; 4-Alteração; 5-Exclusão)
// [n][4] - Acesso relacionado a rotina, se esta posição não for informada nenhum acesso será validado
//----------------------------------------------------------------------------------------------------------

	aAdd(aRotina,{"Relat�rio PDF","u_REL01PDF()",2,0})

Return( aRotina )
