#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMBROWSE.CH'

// Cria o Browse

User function AL01BRW()
    Local oBrowse
    
    oBrowse := FwmBrowse():New()

	oBrowse:SetAlias("SZ1")
	// "Descrição" nome do browse
    oBrowse:SetDescription("Usuários")

    // Cria as legendas dos Status
	// oBrowse:AddLegend(" SZ1->Z1_STATUS == '1' ", "GREEN" , "CLIENTE ATIVO" )
	// oBrowse:AddLegend(" SZ1->Z1_STATUS == '2' ", "RED" , "CLIENTE INATIVO" )

    oBrowse:SetMenuDef("AL01BRW")

    oBrowse:Activate()
Return oBrowse

// Cria os menus
Static function MenuDef()
	LOCAL aRotina := {}

	AADD(aRotina, {"Pesquisar" , "PesqBrw", 0, 1, 0, Nil         })
	AADD(aRotina, {"Visualizar", "VIEWDEF.AL01BRW", 0, 2, 0, Nil })
	AADD(aRotina, {"Alterar"   , "VIEWDEF.AL01BRW", 0, 4, 0, Nil })
	AADD(aRotina, {"Incluir"   , "VIEWDEF.AL01BRW", 0, 3, 0, Nil })
	AADD(aRotina, {"Excluir"   , "VIEWDEF.AL01BRW", 0, 5, 0, Nil })
	AADD(aRotina, {"Legenda"   , "U_AL01BRW", 0, 2, 0, Nil       })
    AADD(aRotina, {"Inclusão Automática","U_ROTAUTO01", 0,3,0,Nil})
    AADD(aRotina, {"Relatório" , "U_REL01USR", 0, 2, 0, Nil      })

Return aRotina

// Cria a model
Static function ModelDef()
   local oModel    
   local oStruSZ1

   oModel   := MPFormModel():New("AL01BRWM")
   
   oStruSZ1 := FWFormStruct(1,"SZ1")
   //oStruSZ1:SetProperty('Z1_IDUSR',,)
   oModel:AddFields("SZ1MASTER",/*Owner*/,oStruSZ1 )
   oModel:SetDescription("Usuários")
   oModel:GetModel("SZ1MASTER"):SetDescription("Dados dos Usuários")
   oModel:SetPrimaryKey( {"Z1_FILIAL", "Z1_IDUSR"} )



Return oModel

Static function ViewDef()


 // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruSZ1 := FwFormStruct(2, "SZ1")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("AL01BRW")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SZ1", oStruSZ1, "SZ1MASTER")

    // CRIA BOX HORIZONTAL
    oView:CreateHorizontalBox("TELA" , 100)

    // RELACIONA OS BOX COM A ESTRUTURA VISUAL
    oView:SetOwnerView("VIEW_SZ1", "TELA")

Return oView


